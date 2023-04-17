# ベースイメージとして公式のNode.jsイメージを使用
FROM node:16

# 作業ディレクトリを設定
WORKDIR /app

# package.jsonとpackage-lock.jsonをコピー
COPY ../front/new-relic-monitoring-example/package.json ./
COPY ../front/new-relic-monitoring-example/yarn.lock ./

# 依存関係をインストール
RUN yarn install --frozen-lockfile

# ソースコードをコピー
COPY ../front/new-relic-monitoring-example .

# アプリケーションをビルド
RUN yarn build

# Nginxイメージを使用してReactアプリケーションをホスト
FROM nginx:stable-alpine

# ビルドされたアプリケーションをNginxコンテナにコピー
COPY --from=0 /app/build /usr/share/nginx/html

# Nginxのデフォルト設定を上書き
COPY --from=0 /app/nginx.conf /etc/nginx/conf.d/default.conf

# コンテナが80番ポートでリッスンするように設定
EXPOSE 80

# Nginxを起動
CMD ["nginx", "-g", "daemon off;"]