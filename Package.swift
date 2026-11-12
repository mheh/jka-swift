// swift-tools-version: 6.3
import Foundation
import PackageDescription

let implicitDynamic: [SwiftSetting] = ProcessInfo.processInfo.environment["JKA_IMPLICIT_DYNAMIC"] != nil ? [.unsafeFlags(["-Xfrontend", "-enable-implicit-dynamic"])] : []

let package = Package(
    name: "jka-swift",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "jampgame", type: .dynamic, targets: ["jampgame"]),
        .library(name: "cgame", type: .dynamic, targets: ["cgame"]),
        .executable(name: "jampded", targets: ["jampded"]),
        .library(name: "JKAMP_BG", targets: ["JKAMP_BG", "JKAMP", "JKAShared"]),
        .library(name: "JKAMP_GameLogic", targets: ["JKAMP_GameLogic", "JKAMP_BG", "JKAMP_Game", "JKAMP", "JKAShared"]),
        .library(name: "JKAMP_CGameLogic", targets: ["JKAMP_CGameLogic", "JKAMP_BG", "JKAMP_CGame", "JKAMP", "JKAShared"]),
        .library(name: "JKAMP_UILogic", targets: ["JKAMP_UILogic", "JKAMP_BG", "JKAMP_UI", "JKAMP", "JKAShared"]),
        .library(name: "JKAMP_DedLogic", targets: ["JKAMP_DedLogic", "JKAMP_Ded", "JKAMP", "JKAShared"]),
        .library(name: "JKAMP_GameShell", targets: ["jampgame"]),
        .library(name: "JKAMP_DedShell", targets: ["CJKAHost"]),
    ],
    targets: [
        // MARK: - C, the syscall shim
        .target(name: "CJKASyscall"),
        .target(name: "CJKAHost", dependencies: ["CJKASyscall"]),

        // MARK: - C, the system zlib
        .systemLibrary(name: "CJKAZlib"),

        // MARK: - C, the copied Raven headers, written by merge.py
        .target(name: "CJKAShared"),
        .target(name: "CJKAMP", dependencies: ["CJKAShared"]),
        .target(name: "CJKAMP_Game", dependencies: ["CJKAMP"]),
        .target(name: "CJKAMP_CGame", dependencies: ["CJKAMP"]),
        .target(name: "CJKAMP_UI", dependencies: ["CJKAMP"]),
        .target(name: "CJKAMP_Ded", dependencies: ["CJKAMP"]),
        .target(name: "CJKASP", dependencies: ["CJKAShared"]),
        .target(name: "CJKASP_Game", dependencies: ["CJKASP"]),
        .target(name: "CJKASP_CGame", dependencies: ["CJKASP"]),
        .target(name: "CJKASP_UI", dependencies: ["CJKASP"]),

        // MARK: - Swift views, one per C target, generated
        .target(name: "JKAShared", dependencies: ["CJKAShared", "CJKASyscall"]),
        .target(name: "JKAMP", dependencies: ["JKAShared", "CJKAMP"]),
        .target(name: "JKAMP_Game", dependencies: ["JKAMP", "CJKAMP_Game"]),
        .target(name: "JKAMP_CGame", dependencies: ["JKAMP", "CJKAMP_CGame"]),
        .target(name: "JKAMP_UI", dependencies: ["JKAMP", "CJKAMP_UI"]),
        .target(name: "JKAMP_Ded", dependencies: ["JKAMP", "CJKAMP_Ded", "JKAZlib"]),
        .target(name: "JKAZlib", dependencies: ["CJKAZlib"]),

        // MARK: - Swift logic, ported bodies, no C import
        .target(name: "JKAMP_BG", dependencies: ["JKAMP"], swiftSettings: implicitDynamic),
        .target(name: "JKAMP_GameLogic", dependencies: ["JKAMP_Game", "JKAMP_BG"], swiftSettings: implicitDynamic),
        .target(name: "JKAMP_CGameLogic", dependencies: ["JKAMP_CGame", "JKAMP_BG"]),
        .target(name: "JKAMP_UILogic", dependencies: ["JKAMP_UI", "JKAMP_BG"]),
        .target(name: "JKAMP_DedLogic", dependencies: ["JKAMP_Ded"], swiftSettings: implicitDynamic),

        // MARK: - Shell, the product
        .target(name: "jampgame", dependencies: ["JKAMP_GameLogic"]),
        .target(name: "cgame", dependencies: ["JKAMP_CGameLogic"]),
        .executableTarget(name: "jampded", dependencies: ["JKAMP_DedLogic", "CJKAHost", "CJKAZlib"]),
        .executableTarget(name: "jampsmoke", dependencies: ["CJKASyscall"]),

        // MARK: - Test support, a library and not a product, so it ships in no dylib
        .target(
            name: "JKATestSupport",
            dependencies: ["JKAShared"],
            resources: [.copy("Oracle")]
        ),

        // MARK: - Tests
        .testTarget(name: "JKASharedTests", dependencies: ["JKAShared", "JKATestSupport"]),
        .testTarget(name: "JKAMPTests", dependencies: ["JKAMP", "JKAMP_BG", "JKATestSupport"]),
        .testTarget(name: "JKAMP_GameTests", dependencies: ["JKAMP_GameLogic", "JKATestSupport"]),
        .testTarget(name: "jampgameTests", dependencies: ["CJKAMP_Game"]),
        .testTarget(name: "JKAMP_CGameTests", dependencies: ["JKAMP_CGameLogic", "JKATestSupport"]),
        .testTarget(name: "JKAMP_DedLogicTests", dependencies: ["JKAMP_DedLogic", "JKATestSupport"]),
        .testTarget(name: "cgameTests", dependencies: ["CJKAMP_CGame"]),
        .testTarget(
            name: "CJKAHostTests",
            dependencies: ["CJKAHost", "CJKASyscall"],
            linkerSettings: [.unsafeFlags(["-Xlinker", "--export-dynamic"], .when(platforms: [.linux]))]
        ),
        .testTarget(name: "jampdedTests"),
    ]
)
