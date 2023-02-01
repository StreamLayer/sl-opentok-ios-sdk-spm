// swift-tools-version:5.3
import PackageDescription

let package = Package(
name: "OpenTok",
products: [
.library(
name: "OpenTok",
targets: ["OpenTok"]),
],
dependencies: [
],
targets: [
.binaryTarget(name: "OpenTok",
path: "OpenTok.xcframework")
]
)
