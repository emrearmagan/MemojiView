// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MemojiView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "MemojiView", targets: ["MemojiView"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MemojiView",
            dependencies: [],
            path: "MemojiView"
        )
    ],
    swiftLanguageVersions: [.v5]
)
