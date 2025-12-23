#!/bin/bash
# Скрипт для запуска Elixir TCP сервера и клиента
cd "$(dirname "$0")"

PORT=8082
MESSAGE="Тест от Elixir клиента"

echo "Запуск сервера на порту $PORT в фоне..."
elixir -S mix run -e "TcpServerClient.Server.start_link($PORT); Process.sleep(:infinity)" &
SERVER_PID=$!

# Ждем запуска сервера
sleep 3

echo "Запуск клиента..."
elixir -S mix run -e "TcpServerClient.Client.connect(\"127.0.0.1\", $PORT, \"$MESSAGE\")"

# Останавливаем сервер
echo "Остановка сервера..."
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo "Готово!"

