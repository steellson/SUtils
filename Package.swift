// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "STUtilites",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "STUtilites",
            type: .static,
            targets: ["STUtilites"]
        )
    ],
    targets: [
        .target(name: "STUtilites")
    ]
)
