FROM node:24-slim

WORKDIR /app

# 依存関係インストール
COPY app/package*.json ./
RUN npm ci --omit=dev

# アプリケーションコードをコピー
COPY app/ .

# データディレクトリ作成。root でビルドした /app をまとめて node の所有にする
RUN mkdir -p data && chown -R node:node /app

# root では動かさない（node イメージに用意された一般ユーザー node〔uid 1000〕で実行する）
USER node

EXPOSE 3000

CMD ["node", "app.js"]
