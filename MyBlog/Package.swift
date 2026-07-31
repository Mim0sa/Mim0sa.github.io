// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MyBlog",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "MyBlog",
            targets: ["MyBlog"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.8.0"),
        .package(
            name: "HighlightJSPublishPlugin",
            url: "https://github.com/alex-ross/HighlightJSPublishPlugin.git",
            from: "1.0.2"
        )
    ],
    targets: [
        .executableTarget(
            name: "MyBlog",
            dependencies: [
                "Publish",
                "HighlightJSPublishPlugin"
            ]
        )
    ]
)
