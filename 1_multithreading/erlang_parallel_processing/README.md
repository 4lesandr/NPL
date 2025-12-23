# Erlang - Параллельная обработка данных из файла

## Описание
Программа параллельно обрабатывает данные из файла, используя процессы Erlang (actor model).

## Компиляция и запуск
```bash
cd erlang_parallel_processing
erlc parallel_processing.erl
erl -noshell -s parallel_processing main data.txt -s init stop
```

## Альтернативный способ запуска
```bash
erl
1> c(parallel_processing).
2> parallel_processing:main(["data.txt"]).
```

