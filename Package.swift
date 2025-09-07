// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SUtils",
    platforms: [
        .macOS(.v13),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "BaseClasses",
            targets: [
                "Base"
            ]
        ),
        .library(
            name: "DesignSystem",
            targets: [
                "DS"
            ]
        ),
        .library(
            name: "Environment",
            targets: [
                "Env"
            ]
        ),
        .library(
            name: "Extensions",
            targets: [
                "FoundationExtensions",
                "UIKitExtensions"
            ]
        ),
        .library(
            name: "Protocols",
            targets: [
                "Protocols"
            ]
        ),
        .library(
            name: "Tools",
            targets: [
                "Finder",
                "FSTracker",
                "Log",
                "PlistReader",
                "Pusher",
                "Scripter"
            ]
        )
    ],
    targets: [

        /// ** BASE CLASSES **
        .target(
            name: "Base",
            path: "Sources/Base"
        ),

        /// ** DESIGN SYSTEM **
        .target(
            name: "DS",
            path: "Sources/DS"
        ),

        /// ** ENVIRONMENT **
        .target(
            name: "Env",
            dependencies: [
                .target(name: "PlistReader"),
                .target(name: "Log")
            ],
            path: "Sources/Env"
        ),

        /// ** EXTENSIONS **
        .target(
            name: "FoundationExtensions",
            path: "Sources/Extensions/Base"
        ),
        .target(
            name: "UIKitExtensions",
            path: "Sources/Extensions/UIKit"
        ),

        /// ** PROTOCOLS **
        .target(
            name: "Protocols",
            path: "Sources/Protocols"
        ),

        /// ** TOOLS **
        .target(
            name: "Finder",
            path: "Sources/Tools/Finder"
        ),
        .target(
            name: "FSTracker",
            path: "Sources/Tools/FSTracker"
        ),
        .target(
            name: "Log",
            path: "Sources/Tools/Log"
        ),
        .target(
            name: "PlistReader",
            path: "Sources/Tools/PlistReader"
        ),
        .target(
            name: "Pusher",
            path: "Sources/Tools/Pusher"
        ),
        .target(
            name: "Scripter",
            path: "Sources/Tools/Scripter"
        )
    ]
)
