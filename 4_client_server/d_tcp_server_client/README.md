# D - TCP сервер и клиент

## Описание
Реализация TCP сервера и клиента на языке D с использованием стандартной библиотеки std.socket.

## Компиляция и запуск

### Сервер:
```bash
cd d_tcp_server_client
dub build --build=release --config=server
./server
```

Или с rdmd:
```bash
rdmd server.d
```

### Клиент:
```bash
dub build --build=release --config=client
./client "Привет, сервер!"
```

Или с rdmd:
```bash
rdmd client.d "Привет, сервер!"
```

## Альтернативный способ (через run.sh)
```bash
# В первом терминале запустите сервер:
./run_server.sh

# Во втором терминале запустите клиента:
./run_client.sh "Привет, сервер!"
```

## Требования
Требуется D компилятор (dmd, ldc или gdc) и dub (опционально).

