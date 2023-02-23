// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWToast",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WWToast", targets: ["WWToast"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWPrint.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "WWToast", dependencies: ["WWPrint"], resources: [.process("Storyboard")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
