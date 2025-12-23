#!/bin/bash
# Скрипт для запуска D TCP сервера и клиента
cd "$(dirname "$0")"

if ! command -v rdmd &> /dev/null; then
    echo "Ошибка: rdmd не найден. D компилятор не установлен."
    echo "D не поддерживается на ARM Mac. Программа будет собрана на другом устройстве."
    exit 1
fi

echo "Запуск сервера в фоне..."
rdmd server.d &
SERVER_PID=$!

# Ждем запуска сервера
sleep 2

echo "Запуск клиента..."
rdmd client.d "Тест от D клиента"

# Останавливаем сервер
echo "Остановка сервера..."
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo "Готово!"

