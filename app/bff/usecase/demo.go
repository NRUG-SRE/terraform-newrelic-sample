package usecase

import (
	"context"

	"github.com/NRUG-SRE/terraform-newrelic-sample/app/bff/presenter"
)

type (
	Demo struct {
	}
)

func NewDemo() *Demo {
	return &Demo{}
}

func (u *Demo) Do(ctx context.Context) (presenter.Response, error) {
	return nil, nil
}
