import Foundation
import Network

// TCP сервер на Swift

let port: UInt16 = 8080

let listener = try! NWListener(using: .tcp, on: NWEndpoint.Port(rawValue: port)!)

listener.newConnectionHandler = { connection in
    print("Клиент подключен")
    
    connection.start(queue: .global())
    
    connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, context, isComplete, error in
        if let data = data, !data.isEmpty {
            let message = String(data: data, encoding: .utf8) ?? ""
            print("Получено от клиента: \(message.trimmingCharacters(in: .whitespacesAndNewlines))")
            
            let response = "Сервер получил: \(message)"
            connection.send(content: response.data(using: .utf8), completion: .contentProcessed { error in
                if let error = error {
                    print("Ошибка отправки: \(error)")
                }
            })
        }
        
        if isComplete {
            print("Клиент отключен")
            connection.cancel()
        } else if let error = error {
            print("Ошибка: \(error)")
            connection.cancel()
        } else {
            connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { _, _, _, _ in }
        }
    }
}

listener.start(queue: .global())
print("TCP сервер запущен на порту \(port)")
print("Ожидание подключений...")

// Держим программу запущенной
RunLoop.main.run()

