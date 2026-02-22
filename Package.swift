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
    ],
    targets: [
        .target(
            name: "IRC",
            dependencies: [
                .product(
                    name: "Parsing",
                    package: "swift-parsing"
                ),
            ]
        ),
        .testTarget(
            name: "IRCTests",
            dependencies: ["IRC"]
        ),
    ]
)
