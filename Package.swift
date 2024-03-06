// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyAdMobBanner",
    platforms: [.macOS(.v14), .iOS(.v14), .tvOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EasyAdMobBanner",
            targets: ["EasyAdMobBanner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "11.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EasyAdMobBanner", dependencies: [.product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")]),
        .testTarget(
            name: "EasyAdMobBannerTests",
            dependencies: ["EasyAdMobBanner"]),
    ]
)
