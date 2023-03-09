// swift-tools-version:5.6
                import PackageDescription
                let package = Package(
                name: "OpenTokLib",
                products: [
                        .library(
                        name: "OpenTokLib",
                        targets: ["OpenTokLib","OpenTok","VonageWebRTC"]),
                ],
                dependencies: [],

                targets: [
                        .target(name: "OpenTokLib",
                                path: "./",
                                linkerSettings: [
                                        .unsafeFlags(["-ObjC"]),
                                        .linkedLibrary("c++"),
                                        .linkedFramework("VideoToolbox"),
                                        .linkedFramework("Foundation"),
                                        .linkedFramework("Network")
                                ]
                         ),
                        .binaryTarget(name: "OpenTok",path: "OpenTok.xcframework"),
                        .binaryTarget(name: "VonageWebRTC",path: "VonageWebRTC.xcframework")
                ]
        )
	
