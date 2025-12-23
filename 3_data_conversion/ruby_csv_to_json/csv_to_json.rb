#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# Преобразование CSV в JSON на Ruby

require 'csv'
require 'json'

def csv_to_json(csv_file, json_file)
  unless File.exist?(csv_file)
    puts "Ошибка: файл #{csv_file} не найден"
    exit 1
  end

  # Читаем CSV файл
  data = []
  CSV.foreach(csv_file, headers: true, encoding: 'UTF-8') do |row|
    data << row.to_h
  end

  # Преобразуем в JSON
  json_data = {
    'total_rows' => data.length,
    'data' => data
  }

  # Записываем JSON файл
  File.open(json_file, 'w', encoding: 'UTF-8') do |f|
    f.write(JSON.pretty_generate(json_data))
  end

  puts "Успешно преобразовано #{data.length} строк из #{csv_file} в #{json_file}"
end

# Главная функция
if __FILE__ == $0
  if ARGV.length != 2
    puts "Использование: #{$0} <входной_csv_файл> <выходной_json_файл>"
    puts "Пример: #{$0} data.csv output.json"
    exit 1
  end

  csv_file = ARGV[0]
  json_file = ARGV[1]
  csv_to_json(csv_file, json_file)
end

