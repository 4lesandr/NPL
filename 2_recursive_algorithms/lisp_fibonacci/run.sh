#!/bin/bash
# Скрипт для запуска Lisp программы
cd "$(dirname "$0")"
sbcl --script fibonacci.lisp

