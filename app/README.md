# Demo-App
Go言語におけるAPM実装デモアプリケーションです。

## インストール要件

- Go(1.20.2)
- Docker Compose v2(Docker)

## 事前準備物
- New Relic LicenseKey

## 依存解決
```bash
go mod tidy
go mod download
```

## 起動方法
```bash
export APM_NEWRELIC_LICENSE_KEY=xxxxxxxxxxxxxxxxxxxxNRAL
docker compose up -d
```

## APIの実行
```bash
curl --location --request GET 'localhost:4000/bff/tracing-demo'
```
