// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SUtils",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SUtils",
            type: .static,
            targets: ["SUtils"]
        ),
    ],
    targets: [
        .target(
            name: "SUtils"
        )
    ]
)
