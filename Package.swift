// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "com.outsystems.firebase.cloudmessaging",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "com.outsystems.firebase.cloudmessaging",
            targets: ["com.outsystems.firebase.cloudmessaging", "OSCloudMessagingObjectiveC"])
    ],
    dependencies: [
        .package(url: "https://github.com/apache/cordova-ios.git", branch: "master"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.29.0")
    ],
    targets: [
        .target(
            name: "com.outsystems.firebase.cloudmessaging",
            dependencies: [
                .product(name: "Cordova", package: "cordova-ios"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ],
            path: "src/ios",
            exclude: [
                "AppDelegate+OSFirebaseCloudMessaging.h",
                "AppDelegate+OSFirebaseCloudMessaging.m"
            ],
            resources: [
                .process("ios-lib/CoreDataManager/NotificationsModel.xcdatamodeld")
            ],
            publicHeadersPath: "."),
        .target(name: "OSCloudMessagingObjectiveC",
                dependencies: [
                    .product(name: "Cordova", package: "cordova-ios"),
                    .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                    .target(name: "com.outsystems.firebase.cloudmessaging")
                ],
                path: "src/ios",
                exclude: [
                    "ios-lib",
                    "ios-local-not-lib",
                    "OSFCMEventExtensions.swift",
                    "OSFirebaseCloudMessaging.swift"
                ],
                publicHeadersPath: ".")
    ]
)
