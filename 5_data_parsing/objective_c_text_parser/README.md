# Objective-C - Извлечение email, телефонов и IP-адресов из текста

## Описание
Программа извлекает email адреса, номера телефонов и IP-адреса из текстового файла с помощью NSRegularExpression.

## Компиляция и запуск
```bash
cd objective_c_text_parser
clang -framework Foundation main.m -o text_parser
./text_parser input.txt output.json
```

## Альтернативный способ (Xcode)
Создайте проект в Xcode и добавьте main.m в проект.

## Требования
Требуется Clang с поддержкой Foundation framework (обычно предустановлен в macOS).

