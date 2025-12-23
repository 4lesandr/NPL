#!/bin/bash
# Скрипт для запуска Lua программы
cd "$(dirname "$0")"
lua text_parser.lua input.txt output.json

