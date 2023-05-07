package handler

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/newrelic/go-agent/v3/newrelic"

	"github.com/NRUG-SRE/terraform-newrelic-sample/app/bff/presenter"
	"github.com/NRUG-SRE/terraform-newrelic-sample/app/internal/database/connection"
)

type (
	Demo struct {
		conns connection.Database
	}

	DemoDB struct {
		ID        uint64    `db:"id"`
		Name      string    `db:"name"`
		CreatedAt time.Time `db:"created_at"`
		UpdatedAt time.Time `db:"updated_at"`
	}
)

func NewDemo(conns connection.Database) http.Handler {
	return &Demo{conns}
}

func (h *Demo) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	txn := newrelic.FromContext(r.Context())
	defer txn.StartSegment("handler").End()

	var demo []DemoDB

	querySegment := newrelic.DatastoreSegment{
		Product:    newrelic.DatastoreMySQL, // Use DatastoreMySQL instead of DatastorePostgres
		Collection: "demo",
		Operation:  "SELECT",
	}

	querySegment.StartTime = newrelic.StartSegmentNow(txn)
	err := h.conns.Reader().Select(&demo, "SELECT * FROM demo")
	if err != nil {
		log.Fatalf("Failed to execute SELECT query: %v", err)
		return
	}
	querySegment.End()

	for _, d := range demo {
		fmt.Printf("ID: %d, Name: %s, CreatedAt: %s, UpdatedAt: %s\n", d.ID, d.Name, d.CreatedAt, d.UpdatedAt)
	}

	(&presenter.DemoResponse{}).Write(w, http.StatusOK, r.Context())
}
