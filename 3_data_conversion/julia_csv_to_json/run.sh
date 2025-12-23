#!/bin/bash
# Скрипт для запуска Julia программы
cd "$(dirname "$0")"
julia csv_to_json.jl data.csv output.json

