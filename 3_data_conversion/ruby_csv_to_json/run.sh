#!/bin/bash
# Скрипт для запуска Ruby программы
cd "$(dirname "$0")"
ruby csv_to_json.rb data.csv output.json

