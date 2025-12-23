import Foundation
import Network

// TCP клиент на Swift

guard CommandLine.arguments.count >= 2 else {
    print("Использование: \(CommandLine.arguments[0]) <сообщение>")
    print("Пример: \(CommandLine.arguments[0]) \"Привет, сервер!\"")
    exit(1)
}

let message = CommandLine.arguments[1]
let host = "127.0.0.1"
let port: UInt16 = 8080

let hostEndpoint = NWEndpoint.Host(host)
let portEndpoint = NWEndpoint.Port(rawValue: port)!
let connection = NWConnection(host: hostEndpoint, port: portEndpoint, using: .tcp)

let semaphore = DispatchSemaphore(value: 0)

connection.stateUpdateHandler = { state in
    switch state {
    case .ready:
        print("Подключено к серверу \(host):\(port)")
        
        // Отправляем сообщение
        let data = (message + "\n").data(using: .utf8)!
        connection.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                print("Ошибка отправки: \(error)")
            } else {
                print("Отправлено: \(message)")
            }
        })
        
        // Получаем ответ
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, context, isComplete, error in
            if let data = data, !data.isEmpty {
                let response = String(data: data, encoding: .utf8) ?? ""
                print("Получено от сервера: \(response.trimmingCharacters(in: .whitespacesAndNewlines))")
            }
            if let error = error {
                print("Ошибка получения: \(error)")
            }
            connection.cancel()
            semaphore.signal()
        }
    case .failed(let error):
        print("Ошибка подключения: \(error)")
        semaphore.signal()
    case .cancelled:
        semaphore.signal()
    default:
        break
    }
}

connection.start(queue: .global())
semaphore.wait()

