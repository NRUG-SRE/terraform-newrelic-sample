package server

import (
	"fmt"
	"net/http"

	"github.com/newrelic/go-agent/v3/newrelic"
)

type AppServer struct {
	*http.Server
	mux *http.ServeMux
	app *newrelic.Application
	mw  *Middleware
}

func NewAppServer(mux *http.ServeMux, port uint) *AppServer {
	svr := &http.Server{
		Addr:    fmt.Sprintf(":%d", port),
		Handler: mux,
	}
	svr.SetKeepAlivesEnabled(true)

	return &AppServer{
		Server: svr,
		mux:    mux,
	}
}

func (s *AppServer) SetNewrelicApp(appName, licenseKey string) error {
	if appName == "" || licenseKey == "" {
		return nil
	}
	app, err := newrelic.NewApplication(
		newrelic.ConfigAppName(appName),
		newrelic.ConfigLicense(licenseKey),
	)
	if err != nil {
		return err
	}
	s.app = app
	return nil
}

func (s *AppServer) SetMiddleware(mw *Middleware) {
	s.mw = mw
}

func (s *AppServer) Handle(path string, handler http.Handler) {
	s.mux.Handle(newrelic.WrapHandle(s.app, path, s.mw.Chain(handler)))
}

func (s *AppServer) HandleFunc(path string, handlerFunc func(http.ResponseWriter, *http.Request)) {
	s.Handle(path, http.HandlerFunc(handlerFunc))
}
