// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "jka-swift",
    platforms: [.macOS(.v15)],
    products: [],
    targets: [
        // The C variadic syscall shim. It holds no Raven header.
        .target(
            name: "CJKACore",
            path: "Sources/CJKACore"
        ),
        // Raven-free Swift, shared by SP and MP: scalars, handles, the syscall entry, and the tuple bridges.
        .target(
            name: "JKACore",
            dependencies: ["CJKACore"]
        ),
        // The MP oracle headers as one clang module. Swift sees Raven's types with Raven's layouts.
        .target(
            name: "CJKAMP",
            path: "Sources/CJKAMP",
            sources: ["CJKAMP.c"]
        ),
        // The MP overlay layer. It is the only Swift target that imports CJKAMP.
        .target(
            name: "JKAMP",
            dependencies: ["JKACore", "CJKAMP"]
        ),
        .testTarget(
            name: "JKAMPTests",
            dependencies: ["JKAMP"]
        ),
        // PROTOTYPE, throwaway. It answers row B3 of the porting-rules walk: does a view-based GameWorld over C memory work?
        // The views target is the only one that imports CJKAMP. The logic target sees the views and never a Raven prototype.
        .target(
            name: "GameWorldPrototypeViews",
            dependencies: ["CJKAMP"],
            path: "Prototypes/GameWorldPrototypeViews"
        ),
        .executableTarget(
            name: "GameWorldPrototype",
            dependencies: ["GameWorldPrototypeViews"],
            path: "Prototypes/GameWorldPrototype"
        ),
    ]
)
