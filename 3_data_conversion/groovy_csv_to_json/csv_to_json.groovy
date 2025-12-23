#!/usr/bin/env groovy
// Преобразование CSV в JSON на Groovy

@Grab('org.apache.commons:commons-csv:1.10.0')
import org.apache.commons.csv.*
import groovy.json.*

def csvToJson(csvFile, jsonFile) {
    def csvFileObj = new File(csvFile)
    if (!csvFileObj.exists()) {
        println "Ошибка: файл $csvFile не найден"
        System.exit(1)
    }

    def records = []

    // Читаем CSV файл
    csvFileObj.withReader { reader ->
        def parser = CSVParser.parse(reader, CSVFormat.DEFAULT.withHeader())
        parser.each { record ->
            def row = [:]
            record.toMap().each { key, value ->
                row[key] = value
            }
            records << row
        }
    }

    // Создаем структуру JSON
    def jsonData = [
        total_rows: records.size(),
        data: records
    ]

    // Записываем JSON файл
    def json = new JsonBuilder(jsonData)
    new File(jsonFile).withWriter { writer ->
        json.writeTo(writer)
    }

    println "Успешно преобразовано ${records.size()} строк из $csvFile в $jsonFile"
}

// Главная функция
if (args.length != 2) {
    println "Использование: ${this.class.name} <входной_csv_файл> <выходной_json_файл>"
    println "Пример: groovy csv_to_json.groovy data.csv output.json"
    System.exit(1)
}

def csvFile = args[0]
def jsonFile = args[1]
csvToJson(csvFile, jsonFile)

