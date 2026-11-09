// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "swift-murmurhash2",
    products: [.library(name: "MurmurHash2", targets: ["MurmurHash2"])],
    targets: [
        .target(name: "MurmurHash2"),
        .testTarget(name: "MurmurHash2Tests", dependencies: ["MurmurHash2"]),
    ],
)
