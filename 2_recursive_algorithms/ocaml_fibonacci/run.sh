#!/bin/bash
# Скрипт для запуска OCaml программы
cd "$(dirname "$0")"
ocamlc -o fibonacci fibonacci.ml
./fibonacci
rm -f fibonacci fibonacci.cmi fibonacci.cmo

