// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoremIpsumLib",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "LoremIpsumLib",
            targets: ["LoremIpsumLib"]),
    ],
    targets: [
        .target(
            name: "LoremIpsumLib"),
        .testTarget(
            name: "LoremIpsumLibTests",
            dependencies: ["LoremIpsumLib"],
            resources: [
                .copy("Data/ThreeParagraphsTextResponse.json")
            ]),
    ]
)
