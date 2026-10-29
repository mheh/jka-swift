// swift-tools-version: 6.3
import PackageDescription

// C targets hold Raven's copied headers and nothing else. A Swift view target imports exactly one of them with internal import.
// A logic target imports its view target and no C module. The shell target holds dllEntry and vmMain and becomes the product.
let package = Package(
    name: "jka-swift",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "jampgame", type: .dynamic, targets: ["jampgame"]),
    ],
    targets: [
        // MARK: - C, the syscall shim
        // The variadic call the Swift importer cannot express. It holds no Raven header.
        .target(name: "CJKASyscall"),

        // MARK: - C, the copied Raven headers, written by merge.py
        // A type both trees define identically, 48 today. Every other C target depends on it.
        .target(name: "CJKAShared"),
        // The MP tree: q_shared.h, bg_public.h, and the types all four MP modules agree on.
        .target(name: "CJKAMP", dependencies: ["CJKAShared"]),
        // The types only one MP module declares, g_local.h for the game module.
        .target(name: "CJKAMP_Game", dependencies: ["CJKAMP"]),
        .target(name: "CJKAMP_CGame", dependencies: ["CJKAMP"]),
        .target(name: "CJKAMP_UI", dependencies: ["CJKAMP"]),
        // The SP tree compiles clean as C today, so it is declared. Its Swift side waits on packet row 4.
        .target(name: "CJKASP", dependencies: ["CJKAShared"]),
        .target(name: "CJKASP_Game", dependencies: ["CJKASP"]),
        .target(name: "CJKASP_CGame", dependencies: ["CJKASP"]),
        .target(name: "CJKASP_UI", dependencies: ["CJKASP"]),

        // MARK: - Swift views, one per C target, generated
        // Syscall, SyscallTransport, and the views and re-exports of the shared types.
        .target(name: "JKAShared", dependencies: ["CJKAShared", "CJKASyscall"]),
        // The MP tree views: playerState_t, the bg types, and every MP constant and enum as a Swift declaration.
        .target(name: "JKAMP", dependencies: ["JKAShared", "CJKAMP"]),
        // The game module views: Entity, Client, Level, and the typed traps of g_syscalls.c.
        .target(name: "JKAMP_Game", dependencies: ["JKAMP", "CJKAMP_Game"]),
        // The cgame module views: Cg, Cgs, Centity, and every struct they reach.
        .target(name: "JKAMP_CGame", dependencies: ["JKAMP", "CJKAMP_CGame"]),

        // MARK: - Swift logic, ported bodies, no C import
        // bg_*.c, shared by the game and cgame modules.
        .target(name: "JKAMP_BG", dependencies: ["JKAMP"]),
        // g_*.c and the one world instance.
        .target(name: "JKAMP_GameLogic", dependencies: ["JKAMP_Game", "JKAMP_BG"]),
        // cg_*.c and the one world instance.
        .target(name: "JKAMP_CGameLogic", dependencies: ["JKAMP_CGame", "JKAMP_BG"]),

        // MARK: - Shell, the product
        // dllEntry and vmMain. It decodes words and calls the bare functions.
        .target(name: "jampgame", dependencies: ["JKAMP_GameLogic"]),
        // The dlopen loader, run in its own process, so the smoke test never loads the built library into the test process.
        .executableTarget(name: "jampsmoke", dependencies: ["CJKASyscall"]),

        // MARK: - Test support, a library and not a product, so it ships in no dylib
        // The recording transport a test installs on Syscall.transport.
        .target(
            name: "JKATestSupport",
            dependencies: ["JKAShared"],
            // The goldens are jka-rust's copied parity data, rule 18.
            resources: [.copy("Oracle")]
        ),

        // MARK: - Tests
        .testTarget(name: "JKASharedTests", dependencies: ["JKAShared", "JKATestSupport"]),
        .testTarget(name: "JKAMPTests", dependencies: ["JKAMP", "JKAMP_BG", "JKATestSupport"]),
        .testTarget(name: "JKAMP_GameTests", dependencies: ["JKAMP_GameLogic", "JKATestSupport"]),
        // The smoke test runs the jampsmoke loader as a process and must not link the built dylib, so it does not depend on jampgame.
        .testTarget(name: "jampgameTests", dependencies: ["CJKAMP_Game"]),
    ]
)
