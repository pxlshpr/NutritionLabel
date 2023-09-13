// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FoodLabel",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FoodLabel",
            targets: ["FoodLabel"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/pxlshpr/PrepShared", from: "0.0.18"),
        .package(url: "https://github.com/pxlshpr/ViewSugar", from: "0.0.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FoodLabel",
            dependencies: [
                .product(name: "PrepShared", package: "PrepShared"),
                .product(name: "ViewSugar", package: "ViewSugar"),
            ]),
        .testTarget(
            name: "FoodLabelTests",
            dependencies: ["FoodLabel"]),
    ]
)
