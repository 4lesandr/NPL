# Elixir - TCP сервер и клиент (GenServer)

## Описание
Реализация TCP сервера и клиента на Elixir с использованием GenServer для управления сервером.

## Запуск

### Сервер:
```bash
cd elixir_tcp_server_client
./run_server.sh [порт]
```

По умолчанию используется порт 8080.

### Клиент:
```bash
./run_client.sh "Привет, сервер!" [хост] [порт]
```

## Альтернативный способ
```bash
# Сервер
iex -S mix
> TcpServerClient.Server.start_link(8080)

# Клиент (в другом терминале)
iex -S mix
> TcpServerClient.Client.connect("127.0.0.1", 8080, "Привет, сервер!")
```

## Требования
Требуется Elixir и Erlang/OTP.

