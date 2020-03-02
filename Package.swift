// swift-tools-version:5.1
//
// Edited:
//  author: Filip Klembara (filip@klembara.pro)
//  date:   2. Mar. 2020
//  modifications: Updated swift version and platform
//
import PackageDescription

let package = Package(
    name: "nio-apns",
    platforms: [
        .macOS("10.15"),
    ],
    products: [
        .executable(
            name: "nio-apns-example",
            targets: ["NIOAPNSExample"]
        ),
        .library(
            name: "NIOAPNS",
            targets: ["NIOAPNS"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/moritzsternemann/nio-h2",
            .upToNextMinor(from: "0.1.0")
        ),
    ],
    targets: [
        .target(
            name: "NIOAPNSExample",
            dependencies: ["NIOAPNS"]
        ),
        .target(
            name: "NIOAPNS",
            dependencies: ["NIOH2", "CAPNSOpenSSL"]
        ),
        .systemLibrary(
            name: "CAPNSOpenSSL",
            pkgConfig: "openssl",
            providers: [
                .apt(["openssl libssl-dev"]),
                .brew(["openssl"])
            ]
        ),
        .testTarget(
            name: "NIOAPNSTests",
            dependencies: ["NIOAPNS"]
        ),
    ]
)
