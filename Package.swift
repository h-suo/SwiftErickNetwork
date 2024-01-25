// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "SwiftErickNetwork",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "SwiftErickNetwork",
            targets: ["SwiftErickNetwork"]),
    ],
    targets: [
        .target(
            name: "SwiftErickNetwork",
            dependencies: []),
        .testTarget(
            name: "SwiftErickNetworkTests",
            dependencies: ["SwiftErickNetwork"]),
    ]
)
