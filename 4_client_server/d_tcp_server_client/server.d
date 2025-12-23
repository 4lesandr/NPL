#!/usr/bin/env rdmd
// TCP сервер на D

import std.socket;
import std.stdio;
import std.string;
import std.conv;

void main() {
    // Создаем TCP сокет
    auto server = new TcpSocket();
    server.setOption(SocketOption.REUSEADDR, true);
    
    // Привязываем к порту 8080
    auto address = new InternetAddress(InternetAddress.ADDR_ANY, 8080);
    server.bind(address);
    server.listen(10);
    
    writeln("TCP сервер запущен на порту 8080");
    writeln("Ожидание подключений...");
    
    while (true) {
        // Принимаем подключение
        auto client = server.accept();
        writeln("Клиент подключен: ", client.remoteAddress());
        
        // Обрабатываем клиента в отдельном потоке
        import core.thread;
        auto thread = new Thread({
            handleClient(client);
        });
        thread.start();
    }
}

void handleClient(Socket client) {
    scope(exit) {
        client.close();
        writeln("Клиент отключен");
    }
    
    try {
        // Читаем данные от клиента
        ubyte[1024] buffer;
        auto received = client.receive(buffer);
        
        if (received > 0) {
            string message = cast(string) buffer[0..received].dup;
            writeln("Получено от клиента: ", message);
            
            // Отправляем ответ
            string response = "Сервер получил: " ~ message;
            client.send(response);
        }
    } catch (Exception e) {
        writeln("Ошибка при обработке клиента: ", e.msg);
    }
}

