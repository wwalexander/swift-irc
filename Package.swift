// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-irc",
    platforms: [
        .macOS(.v26),
        .macCatalyst(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "IRC",
            targets: ["IRC"]
        ),
        .library(
            name: "IRCFormatting",
            targets: ["IRCFormatting"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-async-algorithms.git",
            from: "1.1.2"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-parsing",
            from: "0.14.1"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-nonempty",
            from: "0.5.0"
        ),
    ],
    targets: [
        .target(
            name: "IRC",
        ),
        .target(
            name: "IRCMessaging",
            dependencies: [
                "IRC",
                .product(
                    name: "Parsing",
                    package: "swift-parsing"
                ),
                .product(
                    name: "NonEmpty",
                    package: "swift-nonempty"
                ),
            ]
        ),
        .target(
            name: "IRCConnectivity",
            dependencies: [
                "IRCMessaging",
                .product(
                    name: "AsyncAlgorithms",
                    package: "swift-async-algorithms"
                ),
            ]
        ),
        .target(
            name: "IRCFormatting",
            dependencies: [
                .product(
                    name: "Parsing",
                    package: "swift-parsing"
                ),
            ]
        ),
        .testTarget(
            name: "IRCConnectivityTests",
            dependencies: ["IRCConnectivity"]
        ),
        .testTarget(
            name: "IRCMessagingTests",
            dependencies: ["IRCMessaging"]
        ),
        .testTarget(
            name: "IRCFormattingTests",
            dependencies: ["IRCFormatting"]
        ),
    ]
)
