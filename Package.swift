// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OneSignal",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "OneSignal",
            targets: ["OneSignalWrapper"]),
        .library(
            name: "OneSignalExtension",
            targets: ["OneSignalExtensionWrapper"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: .init(stringLiteral: "10.11.0")),
    ],
    targets: [
        .target(
            name: "LModule",
            dependencies: [
                .target(name: "OneSignal"),
                .target(name: "AppsFlyerLib"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
            ],
            path: "LModule"
        ),
        .target(
            name: "OneSignalWrapper",
            dependencies: [
                "OneSignal",
                "OneSignalExtension",
                "OneSignalOutcomes",
                "OneSignalCore",
                "LModule"
            ],
            path: "OneSignalWrapper"
        ),
        .target(
            name: "OneSignalExtensionWrapper",
            dependencies: [
                "OneSignalExtension",
                "OneSignalOutcomes",
                "OneSignalCore"
            ],
            path: "OneSignalExtensionWrapper"
        ),
        .target(
            name: "OneSignalOutcomesWrapper",
            dependencies: [
                "OneSignalOutcomes",
                "OneSignalCore"
            ],
            path: "OneSignalOutcomesWrapper"
        ),
        .binaryTarget(
          name: "OneSignal",
          url: "https://github.com/OneSignal/OneSignal-iOS-SDK/releases/download/3.12.5/OneSignal.xcframework.zip",
          checksum: "ae6944383b688f85b759b52fefbfea1f788245f03248c1961e5af60b1b062aa8"
        ),
        .binaryTarget(
          name: "OneSignalExtension",
          url: "https://github.com/OneSignal/OneSignal-iOS-SDK/releases/download/3.12.5/OneSignalExtension.xcframework.zip",
          checksum: "ccf3ea1bdec0cfe706a36ac78346beda9aa118eaccedbeccd79f7fce1ac8309c"
        ),
        .binaryTarget(
          name: "OneSignalOutcomes",
          url: "https://github.com/OneSignal/OneSignal-iOS-SDK/releases/download/3.12.5/OneSignalOutcomes.xcframework.zip",
          checksum: "11c0417695e5a488286651ab67850fa4509d3825a2f048f925614797e7083d5f"
        ),
        .binaryTarget(
          name: "OneSignalCore",
          url: "https://github.com/OneSignal/OneSignal-iOS-SDK/releases/download/3.12.5/OneSignalCore.xcframework.zip",
          checksum: "4f93b420d2421b65681d00a3b95de8c0b0057a678f4ededa5ffc772fc13f4442"
        ),
        .binaryTarget(
            name: "AppsFlyerLib",
            url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework/releases/download/6.12.0/AppsFlyerLib.xcframework.zip",
            checksum: "b213c8c89ffb1c3dc9f6566c8a9d3fa3d10c57ceedaa720ebc549505f2da96e8"
        ),
//        .binaryTarget(
//            name: "AppsFlyerLib-Strict",
//            url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework/releases/download/6.12.0/AppsFlyerLib-Strict.xcframework.zip",
//            checksum: "207188125ad4d8807d2beb596ad6ce5981ffab9f03077a4284f0db2423936601"
//        ),
//        .binaryTarget(
//            name: "AppsFlyerLib-Dynamic",
//            url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework/releases/download/6.12.0/AppsFlyerLib-Dynamic.xcframework.zip",
//            checksum: "375ababb560655f8843f1060e143c34fe08b18d257b08153515d37a25c719d5b"
//        ),
    ]
)
