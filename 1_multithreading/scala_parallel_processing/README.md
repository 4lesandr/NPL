# Scala - Параллельная обработка данных из файла

## Описание
Программа параллельно обрабатывает данные из файла, используя Future и акторы (Akka).

## Компиляция и запуск
```bash
cd scala_parallel_processing
sbt compile
sbt run data.txt
```

## Альтернативный способ запуска
```bash
sbt "runMain ParallelProcessing data.txt"
```

