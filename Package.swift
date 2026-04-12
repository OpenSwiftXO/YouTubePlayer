// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "YouTubePlayer",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "YouTubePlayer",
            targets: ["YouTubePlayer"]
        )
    ],
    targets: [
        .target(
            name: "YouTubePlayer",
            resources: [
                .process("Assets")
            ]
        )
    ]
)
