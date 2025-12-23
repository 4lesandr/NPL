defmodule TcpServerClient.Client do
  def connect(host, port, message) do
    case :gen_tcp.connect(String.to_charlist(host), port, [
      :binary,
      active: false,
      packet: :line
    ]) do
      {:ok, socket} ->
        IO.puts("Подключено к серверу #{host}:#{port}")
        
        # Отправляем сообщение
        :gen_tcp.send(socket, "#{message}\n")
        IO.puts("Отправлено: #{message}")
        
        # Получаем ответ
        case :gen_tcp.recv(socket, 0) do
          {:ok, data} ->
            response = String.trim(data)
            IO.puts("Получено от сервера: #{response}")
          {:error, reason} ->
            IO.puts("Ошибка получения данных: #{reason}")
        end
        
        :gen_tcp.close(socket)
      {:error, reason} ->
        IO.puts("Ошибка подключения: #{reason}")
    end
  end
end

