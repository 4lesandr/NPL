#!/bin/bash
# Скрипт для запуска Swift TCP сервера и клиента
cd "$(dirname "$0")"

echo "Компиляция Swift программы..."
swift build -c release

echo "Запуск сервера в фоне..."
.build/release/Server &
SERVER_PID=$!

# Ждем запуска сервера
sleep 2

echo "Запуск клиента..."
.build/release/Client "Тест от Swift клиента"

# Останавливаем сервер
echo "Остановка сервера..."
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo "Готово!"

