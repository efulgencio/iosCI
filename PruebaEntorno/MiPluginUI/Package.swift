// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MiPluginUI",
    platforms: [
        .iOS(.v15) // <-- Esto soluciona el primer error
    ],
    products: [
        .library(
            name: "MiPluginUI",
            targets: ["MiPluginUI"]),
    ],
    targets: [
        .target(
            name: "MiPluginUI",
            dependencies: []),
        .testTarget(
            name: "MiPluginUITests",
            dependencies: ["MiPluginUI"]),
    ]
)
