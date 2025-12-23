# Swift - TCP сервер и клиент

## Описание
Реализация TCP сервера и клиента на Swift с использованием фреймворка Network.

## Компиляция и запуск

### Сервер:
```bash
cd swift_tcp_server_client
swift build -c release
.build/release/Server
```

### Клиент:
```bash
.build/release/Client "Привет, сервер!"
```

## Альтернативный способ (через run.sh)
```bash
# В первом терминале запустите сервер:
./run_server.sh

# Во втором терминале запустите клиента:
./run_client.sh "Привет, сервер!"
```

## Требования
Требуется Swift 5.9+ и Xcode Command Line Tools.

