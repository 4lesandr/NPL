#!/bin/bash
# Скрипт для запуска Objective-C программы
cd "$(dirname "$0")"

# Компилируем, если нужно
if [ ! -f "text_parser" ] || [ "main.m" -nt "text_parser" ]; then
    echo "Компиляция..."
    clang -framework Foundation main.m -o text_parser
fi

./text_parser input.txt output.json

