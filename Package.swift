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
            name: "Design System",
            targets: ["DS"]
        ),
        .library(
            name: "Enviroment Config",
            targets: ["Env"]
        ),
        .library(
            name: "Development Tools",
            targets: ["Log", "PlistReader"]
        )
    ],
    targets: [
        .target(
            name: "DS",
            path: "Sources/DS"
        ),
        .target(
            name: "Env",
            path: "Sources/Env"
        ),
        .target(
            name: "Log",
            path: "Sources/Tools/Log"
        ),
        .target(
            name: "PlistReader",
            path: "Sources/Tools/PlistReader"
        )
    ]
)
