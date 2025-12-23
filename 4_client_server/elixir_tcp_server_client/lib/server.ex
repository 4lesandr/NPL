defmodule TcpServerClient.Server do
  use GenServer

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  def init(port) do
    case :gen_tcp.listen(port, [
      :binary,
      active: false,
      reuseaddr: true,
      packet: :line
    ]) do
      {:ok, listen_socket} ->
        IO.puts("TCP сервер запущен на порту #{port}")
        IO.puts("Ожидание подключений...")
        accept_connections(listen_socket)
        {:ok, listen_socket}
      {:error, reason} ->
        IO.puts("Ошибка запуска сервера: #{reason}")
        {:stop, reason}
    end
  end

  defp accept_connections(listen_socket) do
    spawn(fn -> accept_loop(listen_socket) end)
  end

  defp accept_loop(listen_socket) do
    case :gen_tcp.accept(listen_socket) do
      {:ok, client_socket} ->
        IO.puts("Клиент подключен")
        spawn(fn -> handle_client(client_socket) end)
        accept_loop(listen_socket)
      {:error, reason} ->
        IO.puts("Ошибка принятия подключения: #{reason}")
    end
  end

  defp handle_client(client_socket) do
    case :gen_tcp.recv(client_socket, 0) do
      {:ok, data} ->
        message = String.trim(data)
        IO.puts("Получено от клиента: #{message}")
        
        response = "Сервер получил: #{message}\n"
        :gen_tcp.send(client_socket, response)
        
        handle_client(client_socket)
      {:error, :closed} ->
        IO.puts("Клиент отключен")
        :gen_tcp.close(client_socket)
      {:error, reason} ->
        IO.puts("Ошибка: #{reason}")
        :gen_tcp.close(client_socket)
    end
  end
end

