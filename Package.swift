// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-irc",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "IRC",
            targets: ["IRC"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-parsing",
            from: "0.14.1"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-transport-services",
            from: "1.26.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio-extras",
            from: "1.32.1"
        ),
    ],
    targets: [
        .target(
            name: "IRC",
            dependencies: [
                .product(
                    name: "Parsing",
                    package: "swift-parsing"
                ),
                .product(
                    name: "NIOTransportServices",
                    package: "swift-nio-transport-services"
                ),
                .product(
                    name: "NIOExtras",
                    package: "swift-nio-extras"
                ),
            ]
        ),
        .testTarget(
            name: "IRCTests",
            dependencies: ["IRC"]
        ),
    ]
)
