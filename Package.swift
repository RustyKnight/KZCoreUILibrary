// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KZCoreUILibrary",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KZCoreUILibrary",
            targets: ["KZCoreUILibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/RustyKnight/KZCoreLibrary", branch: "master"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KZCoreUILibrary",
            dependencies: [
                "KZCoreLibrary",
            ]
        ),
        .testTarget(
            name: "KZCoreUILibraryTests",
            dependencies: ["KZCoreUILibrary"]),
    ]
)
