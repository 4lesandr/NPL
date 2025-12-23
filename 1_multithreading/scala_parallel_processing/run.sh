#!/bin/bash
# Скрипт для запуска Scala программы
cd "$(dirname "$0")"
sbt "run data.txt"

