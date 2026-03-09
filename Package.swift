import Foundation

// swift-tools-version: 6.0
import PackageDescription

// MARK: - 环境判断逻辑（更健壮）

let envOverride = ProcessInfo.processInfo.environment["CODEGEN_ENABLED"]?.lowercased()
let config = ProcessInfo.processInfo.environment["CONFIGURATION"]?.lowercased() ?? ""

// 优先使用 CODEGEN_ENABLED 环境变量，否则根据 CONFIGURATION 判断
let codegenEnabled: Bool = {
    if let override = envOverride {
        return override != "no" && override != "false" && override != "0"
    } else {
        return ["debug", "development"].contains(config)
    }
}()

// MARK: - SwiftPM 配置主体

let package = Package(
    name: "AppUIKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "AppUIKit",
            targets: ["AppUIKit"]
        ),
    ],
    dependencies: (codegenEnabled ? [
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2")
    ] : []),
    targets: [
        .target(
            name: "AppUIKit",
            dependencies: [
                "AppResources",
                "AppFoundation"
            ]
        ),
        .target(
            name: "AppResources",
            resources: [
                .process("Assets/Animations"),
                .process("Assets/Images.xcassets"),
                .process("Assets/Colors.xcassets"),
            ],
            plugins: codegenEnabled ? [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ] : []
        ),
        .target(
            name: "AppFoundation",
            dependencies: []
        ),
        .testTarget(
            name: "AppUIKitTests",
            dependencies: ["AppUIKit"]
        ),
    ]
)
