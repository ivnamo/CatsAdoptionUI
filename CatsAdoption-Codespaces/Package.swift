// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CatsAdoption",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "CatsCore", targets: ["CatsCore"]),
        .executable(name: "cats-cli", targets: ["CatsCLI"])
    ],
    targets: [
        .target(name: "CatsCore", path: "Sources/CatsCore"),
        .executableTarget(name: "CatsCLI", dependencies: ["CatsCore"], path: "Sources/CatsCLI")
    ]
)
