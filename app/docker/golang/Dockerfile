FROM golang:1.20.0-alpine3.17
ENV CGO_ENABLED=0
RUN apk add git make tzdata
RUN go install golang.org/x/tools/cmd/goimports@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest
