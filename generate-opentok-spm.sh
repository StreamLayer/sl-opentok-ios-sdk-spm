#!/bin/bash

generate_podfile(){
echo "platform :ios, '12.0'
install! 'cocoapods', integrate_targets: false
use_frameworks!
pod 'OTXCFramework', '$1'

" > Podfile

}

generate_spm_info(){
rm -f Package.swift
echo "// swift-tools-version:5.3
import PackageDescription

let package = Package(
name: \"OpenTok\",
products: [
.library(
name: \"OpenTok\",
targets: [\"OpenTok\"]),
],
dependencies: [
],
targets: [
.binaryTarget(name: \"OpenTok\",
path: \"OpenTok.xcframework\")
]
)" > Opentok-SPM-$1/Package.swift

}

move_xcframework(){
rm -rf Opentok-SPM-$1
mkdir Opentok-SPM-$1
mv -f Pods/OTXCFramework/OpenTok.xcframework Opentok-SPM-$1
cd Opentok-SPM-$1
git init -b master
git add *
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
echo "Extracting XCFramework"
move_xcframework $1
echo "Generating SPM package"
generate_spm_info $1