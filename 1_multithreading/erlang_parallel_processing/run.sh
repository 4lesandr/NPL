#!/bin/bash
# Скрипт для запуска Erlang программы
cd "$(dirname "$0")"
erl -noshell -eval "parallel_processing:main([\"data.txt\"]), init:stop()."

