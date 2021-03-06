// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coupage",
    products: [
        .executable(name: "coupage", targets: ["Coupage"])
        ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.1"),
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Coupage",
            dependencies: ["CoupageCLI", "Extension", "Commander"]),
        .target(
            name: "CoupageCLI",
            dependencies: ["Config", "ConfigLoader", "TemplateLoader", "PageGenerator"]),
        .target(
            name: "Config",
            dependencies: []),
        .target(
            name: "ConfigLoader",
            dependencies: ["Yams", "Config"]),
        .target(
            name: "TemplateLoader",
            dependencies: []),
        .target(
            name: "PageGenerator",
            dependencies: ["Config", "ConfigLoader", "TemplateLoader"]),
        .target(
            name: "Extension",
            dependencies: []),
        .testTarget(
            name: "CoupageTests",
            dependencies: ["Coupage"]),
    ]
)
