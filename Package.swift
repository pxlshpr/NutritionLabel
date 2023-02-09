// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FoodLabel",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FoodLabel",
            targets: ["FoodLabel"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/pxlshpr/PrepDataTypes", from: "0.0.254"),
        .package(url: "https://github.com/pxlshpr/FoodLabelScanner", from: "0.0.82"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FoodLabel",
            dependencies: [
                .product(name: "PrepDataTypes", package: "prepdatatypes"),
                .product(name: "FoodLabelScanner", package: "foodlabelscanner"),
            ]),
        .testTarget(
            name: "FoodLabelTests",
            dependencies: ["FoodLabel"]),
    ]
)
