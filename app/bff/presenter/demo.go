package presenter

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/newrelic/go-agent/v3/newrelic"
)

type (
	DemoResponse struct {
	}
)

func (r *DemoResponse) Write(w http.ResponseWriter, status int, ctx context.Context) {
	defer newrelic.FromContext(ctx).StartSegment("presenter").End()
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(status)
	buf, _ := json.MarshalIndent(r, "", "    ")
	_, _ = w.Write(buf)
}
