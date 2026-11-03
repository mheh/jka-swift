// swift-tools-version: 6.3
import PackageDescription

// C targets hold Raven's copied headers and nothing else. A Swift view target imports exactly one of them with internal import.
// A logic target imports its view target and no C module. The shell target holds dllEntry and vmMain and becomes the product.
let package = Package(
    name: "jka-swift",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "jampgame", type: .dynamic, targets: ["jampgame"]),
        .library(name: "cgame", type: .dynamic, targets: ["cgame"]),
        .executable(name: "jampded", targets: ["jampded"]),
    ],
    targets: [
        // MARK: - C, the syscall shim
        // The variadic call the Swift importer cannot express. It holds no Raven header.
        .target(name: "CJKASyscall"),
        // The engine side of the same call, the variadic callee VM_DllSyscall and the module load.
        // It holds no Raven header.
        .target(name: "CJKAHost", dependencies: ["CJKASyscall"]),

        // MARK: - C, the system zlib
        // The inflate calls of the pk3 reader.
        // The module map links the system zlib, because zlib is not Raven's code.
        .systemLibrary(name: "CJKAZlib"),

        // MARK: - C, the copied Raven headers, written by merge.py
        // A type both trees define identically, 48 today. Every other C target depends on it.
        .target(name: "CJKAShared"),
        // The MP tree: q_shared.h, bg_public.h, and the types all four MP modules agree on.
        .target(name: "CJKAMP", dependencies: ["CJKAShared"]),
        // The types only one MP module declares, g_local.h for the game module.
        .target(name: "CJKAMP_Game", dependencies: ["CJKAMP"]),
        .target(name: "CJKAMP_CGame", dependencies: ["CJKAMP"]),
        .target(name: "CJKAMP_UI", dependencies: ["CJKAMP"]),
        // The types only the dedicated server declares. It reads the g_public.h types it shares with the game from the game's target.
        .target(name: "CJKAMP_Ded", dependencies: ["CJKAMP_Game", "CJKAMP"]),
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
        // The dedicated server views: ServerStatic, Server, Client, Msg, Vm, and every struct they reach.
        .target(name: "JKAMP_Ded", dependencies: ["JKAMP", "CJKAMP_Ded"]),

        // MARK: - Swift logic, ported bodies, no C import
        // bg_*.c, shared by the game and cgame modules.
        .target(name: "JKAMP_BG", dependencies: ["JKAMP"]),
        // g_*.c and the one world instance.
        .target(name: "JKAMP_GameLogic", dependencies: ["JKAMP_Game", "JKAMP_BG"]),
        // cg_*.c and the one world instance.
        .target(name: "JKAMP_CGameLogic", dependencies: ["JKAMP_CGame", "JKAMP_BG"]),
        // The qcommon, server, null, and win32 files of the dedicated server and the one world instance. A host compiles no bg file.
        .target(name: "JKAMP_DedLogic", dependencies: ["JKAMP_Ded"]),

        // MARK: - Shell, the product
        // dllEntry and vmMain. It decodes words and calls the bare functions.
        .target(name: "jampgame", dependencies: ["JKAMP_GameLogic"]),
        .target(name: "cgame", dependencies: ["JKAMP_CGameLogic"]),
        // The dedicated server shell holds main, and it becomes the jampded executable.
        .executableTarget(name: "jampded", dependencies: ["JKAMP_DedLogic", "CJKAHost", "CJKAZlib"]),
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
        .testTarget(name: "JKAMP_CGameTests", dependencies: ["JKAMP_CGameLogic", "JKATestSupport"]),
        // The cgame smoke test runs the same loader on the cgame library, so it does not depend on cgame.
        .testTarget(name: "cgameTests", dependencies: ["CJKAMP_CGame"]),
        // The host test calls VM_DllSyscall through the module side shim, so it depends on both C targets.
        // The test finds VM_DllSyscall with dlsym, and a Linux executable puts its symbols in the dynamic table only with --export-dynamic.
        .testTarget(
            name: "CJKAHostTests",
            dependencies: ["CJKAHost", "CJKASyscall"],
            linkerSettings: [.unsafeFlags(["-Xlinker", "--export-dynamic"], .when(platforms: [.linux]))]
        ),
        // The dedicated server smoke test runs the jampded executable as a process, so it depends on no target.
        .testTarget(name: "jampdedTests"),
    ]
)
