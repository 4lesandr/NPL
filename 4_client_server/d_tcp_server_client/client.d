#!/usr/bin/env rdmd
// TCP клиент на D

import std.socket;
import std.stdio;
import std.string;

void main(string[] args) {
    if (args.length < 2) {
        writeln("Использование: ", args[0], " <сообщение>");
        writeln("Пример: ", args[0], " \"Привет, сервер!\"");
        return;
    }
    
    string message = args[1];
    
    try {
        // Создаем TCP сокет
        auto client = new TcpSocket();
        
        // Подключаемся к серверу
        auto address = new InternetAddress("127.0.0.1", 8080);
        client.connect(address);
        
        writeln("Подключено к серверу 127.0.0.1:8080");
        
        // Отправляем сообщение
        client.send(message);
        writeln("Отправлено: ", message);
        
        // Получаем ответ
        ubyte[1024] buffer;
        auto received = client.receive(buffer);
        
        if (received > 0) {
            string response = cast(string) buffer[0..received].dup;
            writeln("Получено от сервера: ", response);
        }
        
        client.close();
    } catch (Exception e) {
        writeln("Ошибка: ", e.msg);
    }
}

