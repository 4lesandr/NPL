#!/bin/bash
# Скрипт для запуска Haskell программы
cd "$(dirname "$0")"
ghc -o fibonacci Fibonacci.hs
./fibonacci
rm -f fibonacci fibonacci.hi fibonacci.o

