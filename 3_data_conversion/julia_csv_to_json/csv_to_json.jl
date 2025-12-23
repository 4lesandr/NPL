#!/usr/bin/env julia
# Преобразование CSV в JSON на Julia (упрощенная версия без внешних зависимостей)

function csv_to_json(csv_file::String, json_file::String)
    if !isfile(csv_file)
        error("Файл $csv_file не найден")
    end

    # Читаем CSV файл построчно
    lines = readlines(csv_file)
    if isempty(lines)
        error("Файл пуст")
    end
    
    # Парсим заголовки
    headers = split(strip(lines[1]), ',')
    headers = [strip(h) for h in headers]
    
    # Парсим данные
    data = []
    for i in 2:length(lines)
        if isempty(strip(lines[i]))
            continue
        end
        values = split(strip(lines[i]), ',')
        values = [strip(v) for v in values]
        
        row = Dict()
        for (j, header) in enumerate(headers)
            if j <= length(values)
                row[header] = values[j]
            else
                row[header] = ""
            end
        end
        push!(data, row)
    end

    # Создаем структуру JSON
    json_data = Dict(
        "total_rows" => length(data),
        "data" => data
    )

    # Записываем JSON файл (простой формат)
    open(json_file, "w") do f
        println(f, "{")
        println(f, "  \"total_rows\": $(length(data)),")
        println(f, "  \"data\": [")
        for (i, row) in enumerate(data)
            println(f, "    {")
            for (j, (key, value)) in enumerate(row)
                print(f, "      \"$key\": \"$value\"")
                if j < length(row)
                    println(f, ",")
                else
                    println(f, "")
                end
            end
            print(f, "    }")
            if i < length(data)
                println(f, ",")
            else
                println(f, "")
            end
        end
        println(f, "  ]")
        println(f, "}")
    end

    println("Успешно преобразовано $(length(data)) строк из $csv_file в $json_file")
end

# Главная функция
if length(ARGS) != 2
    println("Использование: $(PROGRAM_FILE) <входной_csv_файл> <выходной_json_файл>")
    println("Пример: $(PROGRAM_FILE) data.csv output.json")
    exit(1)
end

csv_file = ARGS[1]
json_file = ARGS[2]
csv_to_json(csv_file, json_file)
