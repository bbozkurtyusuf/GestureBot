#!/bin/sh
set -eu
cd "$(dirname "$0")"

if ! docker info >/dev/null 2>&1; then
  echo "Docker çalışmıyor. Docker'ı açıp tekrar deneyin."
  exit 1
fi

if [ ! -f .env ]; then
  cp .env.example .env
fi

docker compose up --build -d

echo "GestureBot hazır olana kadar bekleniyor..."
status=""
i=0
while [ "$i" -lt 60 ]; do
  cid="$(docker compose ps -q web || true)"
  if [ -n "$cid" ]; then
    status="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$cid" 2>/dev/null || true)"
  fi
  if [ "$status" = "healthy" ]; then
    break
  fi
  i=$((i + 1))
  sleep 2
done

if [ "$status" != "healthy" ]; then
  echo "Web konteyneri sağlıklı olmadı. docker compose logs web"
  exit 1
fi

url="http://localhost:8080"
echo "GestureBot hazır: $url"
if command -v open >/dev/null 2>&1; then
  open "$url"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$url" >/dev/null 2>&1 || true
fi
