package handler

import (
	"net/http"

	"github.com/newrelic/go-agent/v3/newrelic"

	"github.com/NRUG-SRE/terraform-newrelic-sample/app/bff/presenter"
)

type (
	Demo struct{}
)

func NewDemo() http.Handler {
	return &Demo{}
}

func (h *Demo) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer newrelic.FromContext(r.Context()).StartSegment("handler").End()
	(&presenter.DemoResponse{}).Write(w, http.StatusOK, r.Context())
}
