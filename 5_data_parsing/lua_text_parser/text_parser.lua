#!/usr/bin/env lua
-- Извлечение email, телефонов и IP-адресов из текста с помощью регулярных выражений

local function extract_emails(text)
    local emails = {}
    -- Паттерн для email адресов
    local pattern = "[%w%.%-_]+@[%w%.%-_]+%.%w+"
    for email in text:gmatch(pattern) do
        table.insert(emails, email)
    end
    return emails
end

local function extract_phones(text)
    local phones = {}
    -- Паттерны для телефонов (различные форматы)
    -- +7 (XXX) XXX-XX-XX или +7XXXXXXXXXX или 8XXXXXXXXXX
    local patterns = {
        "%+7%s*%(%d%d%d%)%s*%d%d%d%-%d%d%-%d%d",  -- +7 (XXX) XXX-XX-XX
        "%+7%d%d%d%d%d%d%d%d%d%d",                -- +7XXXXXXXXXX
        "8%d%d%d%d%d%d%d%d%d%d",                  -- 8XXXXXXXXXX
        "%(%d%d%d%)%s*%d%d%d%-%d%d%d%d"           -- (XXX) XXX-XXXX
    }
    
    for _, pattern in ipairs(patterns) do
        for phone in text:gmatch(pattern) do
            table.insert(phones, phone)
        end
    end
    return phones
end

local function extract_ips(text)
    local ips = {}
    -- Паттерн для IP-адресов (IPv4)
    local pattern = "%d+%.%d+%.%d+%.%d+"
    for ip in text:gmatch(pattern) do
        -- Проверяем, что это действительно IP (каждая часть от 0 до 255)
        local valid = true
        for part in ip:gmatch("%d+") do
            local num = tonumber(part)
            if num < 0 or num > 255 then
                valid = false
                break
            end
        end
        if valid then
            table.insert(ips, ip)
        end
    end
    return ips
end

local function parse_text(input_file, output_file)
    local file = io.open(input_file, "r")
    if not file then
        print("Ошибка: не удалось открыть файл " .. input_file)
        os.exit(1)
    end
    
    local text = file:read("*all")
    file:close()
    
    local emails = extract_emails(text)
    local phones = extract_phones(text)
    local ips = extract_ips(text)
    
    -- Выводим результаты
    print("=== Найденные email адреса ===")
    for i, email in ipairs(emails) do
        print(string.format("%d. %s", i, email))
    end
    
    print("\n=== Найденные телефоны ===")
    for i, phone in ipairs(phones) do
        print(string.format("%d. %s", i, phone))
    end
    
    print("\n=== Найденные IP-адреса ===")
    for i, ip in ipairs(ips) do
        print(string.format("%d. %s", i, ip))
    end
    
    -- Сохраняем результаты в файл
    local out_file = io.open(output_file, "w")
    if out_file then
        out_file:write("{\n")
        out_file:write('  "emails": [\n')
        for i, email in ipairs(emails) do
            out_file:write(string.format('    "%s"', email))
            if i < #emails then
                out_file:write(",")
            end
            out_file:write("\n")
        end
        out_file:write("  ],\n")
        out_file:write('  "phones": [\n')
        for i, phone in ipairs(phones) do
            out_file:write(string.format('    "%s"', phone))
            if i < #phones then
                out_file:write(",")
            end
            out_file:write("\n")
        end
        out_file:write("  ],\n")
        out_file:write('  "ips": [\n')
        for i, ip in ipairs(ips) do
            out_file:write(string.format('    "%s"', ip))
            if i < #ips then
                out_file:write(",")
            end
            out_file:write("\n")
        end
        out_file:write("  ]\n")
        out_file:write("}\n")
        out_file:close()
        print(string.format("\nРезультаты сохранены в %s", output_file))
    end
end

-- Главная функция
if #arg ~= 2 then
    print("Использование: " .. arg[0] .. " <входной_файл> <выходной_файл>")
    print("Пример: " .. arg[0] .. " input.txt output.json")
    os.exit(1)
end

parse_text(arg[1], arg[2])

