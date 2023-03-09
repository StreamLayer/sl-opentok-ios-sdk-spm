#!/bin/bash

generate_podfile(){
	echo "platform :ios, '12.0'
	install! 'cocoapods', integrate_targets: false
	use_frameworks!
  	pod 'OTXCFramework', '$1'
	
	" > Podfile

}

generate_spm_info(){
	rm -rf Opentok-SPM-$1
	mkdir Opentok-SPM-$1
	echo '// swift-tools-version:5.6
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
	' > Opentok-SPM-$1/Package.swift
}

move_xcframework(){
	mv -f Pods/OTXCFramework/OpenTok.xcframework Opentok-SPM-$1
	mv -f Pods/VonageWebRTC/VonageWebRTC.xcframework Opentok-SPM-$1
	cd Opentok-SPM-$1
	mkdir Sources
	mkdir Sources/OpenTokLib
	touch Sources/OpenTokLib/Empty.swift
	git init -b master
	git add *
	git add Package.swift
	git commit -q -m "initial commit"
	git tag $1
	cd ..
	rm -f Podfile
	rm -f Podfile.lock
	rm -rf Pods
}

echo "Generating Podfile for SDK version" $1
generate_podfile $1
echo "Installing pods"
pod install
echo "Generating SPM package"
generate_spm_info $1
echo "Extracting XCFramework"
move_xcframework $1
