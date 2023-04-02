package server

import "net/http"

type ChainHandler func(http.Handler) http.Handler
type HandlerList []ChainHandler

type Middleware struct {
	handlers HandlerList
}

func NewMiddleware() *Middleware {
	return &Middleware{HandlerList{}}
}

func (m *Middleware) Use(handlers ...ChainHandler) {
	m.handlers = append(m.handlers, handlers...)
}

func (m *Middleware) Chain(handler http.Handler) http.Handler {
	if m == nil || len(m.handlers) == 0 {
		return handler
	}

	h := handler

	for i := len(m.handlers) - 1; i >= 0; i-- {
		h = m.handlers[i](h)
	}

	return h
}
