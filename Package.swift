// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWToast",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWToast", targets: ["WWToast"]),
    ],
    targets: [
        .target(name: "WWToast", resources: [.process("Storyboard"), .copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
