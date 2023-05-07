package main

import (
	"context"
	"flag"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/NRUG-SRE/terraform-newrelic-sample/app/bff/handler"
	"github.com/NRUG-SRE/terraform-newrelic-sample/app/bff/internal/config"
	"github.com/NRUG-SRE/terraform-newrelic-sample/app/bff/internal/server"
	"github.com/NRUG-SRE/terraform-newrelic-sample/app/internal/database/connection"
	"github.com/NRUG-SRE/terraform-newrelic-sample/app/internal/logger"
)

func main() {
	log, _ := logger.New()
	defer func() {
		recover()
		_ = log.Sync()
	}()

	sugar := log.Sugar()
	defer func() {
		if r := recover(); r != nil {
			sugar.Panic(r)
		}
	}()

	var port uint
	flag.UintVar(&port, "p", 4000, "port")
	flag.Parse()

	mux := http.NewServeMux()
	svr := server.NewAppServer(mux, port)

	cfg, err := config.NewAppConfig()
	if err != nil {
		sugar.Panic(err)
	}

	if err := svr.SetNewrelicApp(cfg.GetNewRelicConfig()); err != nil {
		sugar.Panic(err)
	}

	conns, err := connection.NewDatabase(cfg.GetDatabaseConfig())
	if err != nil {
		sugar.Panic(err)
	}
	defer conns.AllClose()

	svr.Handle("/bff/tracing-demo", handler.NewDemo(conns))
	svr.Handle("/bff/tracing-demo-error", handler.NewDemoError())

	done := make(chan bool, 1)
	go func() {
		sigs := make(chan os.Signal, 1)
		signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
		<-sigs

		if err := svr.Shutdown(context.Background()); err != nil {
			sugar.Errorf("BFF Server shutdown failed: %v", err)
		} else {
			sugar.Info("Graceful Shutdown API Server.")
		}
		done <- true
	}()

	sugar.Infof("Start BFF Server, Port:%d.", port)
	if err := svr.ListenAndServe(); err != http.ErrServerClosed {
		sugar.Panic(err)
	}
	<-done
}
