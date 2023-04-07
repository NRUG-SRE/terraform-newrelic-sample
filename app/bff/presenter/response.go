package presenter

import (
	"net/http"
)

type Response interface {
	Write(w http.ResponseWriter, status int)
}
