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
            path: "Sources/ParadoxTokens"
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
        )
    ]
)
