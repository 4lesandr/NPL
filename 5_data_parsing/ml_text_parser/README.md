# ML - Извлечение email, телефонов и IP-адресов из текста

## Описание
Программа извлекает email адреса, номера телефонов и IP-адреса из текстового файла на Standard ML.

## Компиляция и запуск
```bash
cd ml_text_parser
mlton text_parser.sml
./text_parser input.txt output.json
```

## Альтернативный способ (SML/NJ)
```bash
sml text_parser.sml
- parseText "input.txt";
```

## Требования
Требуется MLton или SML/NJ компилятор.

