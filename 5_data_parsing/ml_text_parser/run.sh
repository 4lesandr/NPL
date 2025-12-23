#!/bin/bash
# Скрипт для запуска ML программы
cd "$(dirname "$0")"

# Пытаемся использовать mlton, если доступен
if command -v mlton &> /dev/null; then
    if [ ! -f "text_parser" ] || [ "text_parser.sml" -nt "text_parser" ]; then
        mlton -default-ann 'allowExtendedTextConsts true' text_parser.sml
    fi
    ./text_parser input.txt output.json
elif command -v sml &> /dev/null; then
    # Используем упрощенную версию для SML/NJ
    sml <(echo "use \"text_parser_simple.sml\"; main();") input.txt 2>&1 | grep -v "^\\["
else
    echo "ML компилятор не найден. Установите MLton или SML/NJ."
    echo "Для macOS: brew install mlton"
    exit 1
fi

