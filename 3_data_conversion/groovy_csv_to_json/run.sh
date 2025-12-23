#!/bin/bash
# Скрипт для запуска Groovy программы
cd "$(dirname "$0")"
groovy csv_to_json.groovy data.csv output.json

