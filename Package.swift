// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ParadoxDesignSystem",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "ParadoxTokens", targets: ["ParadoxTokens"]),
        .library(name: "ParadoxUI", targets: ["ParadoxUI"]),
        .library(name: "ParadoxGlass", targets: ["ParadoxGlass"]),
        .executable(name: "generate-tokens", targets: ["generate-tokens"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.17.0")
    ],
    targets: [
        .target(
            name: "ParadoxTokens",
            path: "Sources/ParadoxTokens",
            resources: [
                // Enumerate each .ttf explicitly. Pointing .process at the
                // Fonts/ directory would also sweep in ParadoxFonts.swift as
                // a resource (copy-not-compile), and the type would vanish
                // at runtime.
                .process("Fonts/AppleGaramond-Bold.ttf"),
                .process("Fonts/AppleGaramond-BoldItalic.ttf"),
                .process("Fonts/AppleGaramond-Italic.ttf"),
                .process("Fonts/AppleGaramond-Light.ttf"),
                .process("Fonts/AppleGaramond-LightItalic.ttf"),
                .process("Fonts/AppleGaramond-Regular.ttf")
            ]
        ),
        .target(
            name: "ParadoxUI",
            dependencies: ["ParadoxTokens"],
            path: "Sources/ParadoxUI"
        ),
        .target(
            name: "ParadoxGlass",
            dependencies: ["ParadoxUI"],
            path: "Sources/ParadoxGlass"
        ),
        .executableTarget(
            name: "generate-tokens",
            path: "Sources/generate-tokens"
        ),
        .testTarget(
            name: "ParadoxTokensTests",
            dependencies: [
                "ParadoxTokens",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/ParadoxTokensTests"
        ),
        .testTarget(
            name: "ParadoxUITests",
            dependencies: [
                "ParadoxUI",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/ParadoxUITests"
        ),
        .testTarget(
            name: "ParadoxGlassTests",
            dependencies: [
                "ParadoxGlass",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/ParadoxGlassTests"
        )
    ]
)
