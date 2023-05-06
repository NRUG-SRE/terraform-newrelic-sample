package handler

import (
	"log"
	"net/http"
	"os"
	"runtime/debug"

	"github.com/newrelic/go-agent/v3/newrelic"

	"github.com/NRUG-SRE/terraform-newrelic-sample/app/bff/presenter"
)

type (
	DemoError struct{}
)

func NewDemoError() http.Handler {
	return &DemoError{}
}

func (h *DemoError) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer newrelic.FromContext(r.Context()).StartSegment("handler").End()

	// logパッケージでログ出力先を標準出力に設定
	log.SetOutput(os.Stdout)

	// ログのフォーマットを変更
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)

	// エラーが発生したと仮定し、スタックトレースをログに出力
	log.Printf("Error occurred: %s\nStack Trace:\n%s", "sample error", debug.Stack())

	(&presenter.DemoResponse{}).Write(w, http.StatusInternalServerError, r.Context())
}
