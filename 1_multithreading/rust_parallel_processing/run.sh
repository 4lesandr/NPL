#!/bin/bash
# Скрипт для запуска Rust программы
cd "$(dirname "$0")"
cargo run --release data.txt

