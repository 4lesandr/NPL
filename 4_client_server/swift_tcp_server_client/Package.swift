// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "tcp_server_client",
    platforms: [
        .macOS(.v10_15)
    ],
    targets: [
        .executableTarget(
            name: "Server",
            path: "Sources/Server"
        ),
        .executableTarget(
            name: "Client",
            path: "Sources/Client"
        )
    ]
)

