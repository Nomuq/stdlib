// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "stdlib",
    products: [
        .library(name: "io", targets: ["io"]),
    ],
    targets: [
        .target(name: "io", dependencies: []),
        .testTarget(name: "ioTests", dependencies: ["io"]),
    ]
)
