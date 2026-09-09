# Package layout, the proposal for vet row 1

Written 2026-09-08 for the first vet. The real `Package.swift` stays as committed until this row is ratified, because rule 15 keeps every commit green and the merged headers are not under `Sources/` yet.

## The manifest

```swift
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

        // MARK: - Swift logic, ported bodies, no C import
        // bg_*.c, shared by the game and cgame modules.
        .target(name: "JKAMP_BG", dependencies: ["JKAMP"]),
        // g_*.c and the one world instance.
        .target(name: "JKAMP_GameLogic", dependencies: ["JKAMP_Game", "JKAMP_BG"]),

        // MARK: - Shell, the product
        // dllEntry and vmMain. It decodes words and calls the bare functions.
        .target(name: "jampgame", dependencies: ["JKAMP_GameLogic"]),

        // MARK: - Tests
        .testTarget(name: "JKASharedTests", dependencies: ["JKAShared"]),
        .testTarget(name: "JKAMPTests", dependencies: ["JKAMP", "JKAMP_BG"]),
        .testTarget(name: "JKAMP_GameTests", dependencies: ["JKAMP_GameLogic"]),
    ]
)
```

## The dependency table

| Target | Kind | Imports | Holds |
|---|---|---|---|
| `CJKASyscall` | C | libc | `jka_syscall.h`, `jka_syscall.c`, arms 0 through 13 |
| `CJKAShared` | C | nothing | the 48 identical types, `layout_asserts.h`, umbrella `CJKAShared.h` |
| `CJKAMP` | C | `CJKAShared` | the MP tree types, 192 today, and their constants |
| `CJKAMP_Game`, `_CGame`, `_UI` | C | `CJKAMP` | one module's private types |
| `CJKASP`, `CJKASP_Game`, `_CGame`, `_UI` | C | `CJKAShared`, `CJKASP` | the SP tree, C only, no Swift side yet |
| `JKAShared` | Swift, views | `CJKAShared`, `CJKASyscall` internal | `Syscall`, `SyscallTransport`, the engine conformer, the recorder, shared views and re-exports |
| `JKAMP` | Swift, views | `JKAShared` public, `CJKAMP` internal | MP tree views, constants, enums |
| `JKAMP_Game` | Swift, views | `JKAMP` public, `CJKAMP_Game` internal | `Entity`, `Client`, `Level`, typed `trap_*` |
| `JKAMP_BG` | Swift, logic | `JKAMP` | `bg_*.c` bodies |
| `JKAMP_GameLogic` | Swift, logic | `JKAMP_Game`, `JKAMP_BG` | `GameWorld`, `world`, `g_*.c` bodies |
| `jampgame` | Swift, shell | `JKAMP_GameLogic` | `dllEntry`, `vmMain`, the decode table |

Only a view target imports a C module, with `internal import`, so no C type appears in a public signature and no Raven prototype collides with a bare Swift function.

## The shape of a C target

merge.py writes each C target as SwiftPM expects it, so no hand file sits in a generated directory.

```
Sources/CJKAMP/
  CJKAMP.c                  one translation unit, includes the umbrella and layout_asserts.h
  include/
    CJKAMP.h                the umbrella, today's all.h under the target's name
    module.modulemap        module CJKAMP { umbrella header "CJKAMP.h" export * }
    CJKAMP_forward.h, CJKAMP_platform.h, constants/, layout_asserts.h
    codemp/game/...         one type per file, oracle path mirrored
```

The `#include "CJKAShared.h"` a dependent target needs resolves through SwiftPM's dependency include paths, the same way `check.sh` passes `-I` today. The umbrella carries no `__linux__` and no `powf` shim, because the copied headers contain no platform section.

## What changes against the committed manifest

- `CJKACore` becomes `CJKASyscall`, and `JKACore` becomes `JKAShared`. Row 7 retired the `Core` names. `CJKASyscall` is the one name row 7 did not list, because the shim is not a Raven header.
- `CJKAMP` drops `path`, `sources`, the oracle symlink, and the defines. Its headers are the merged copies.
- The prototype targets leave the manifest. Their source stays in history at `406de1d`, and the views move onto the generated ones in task 6.
- `CJKAMP_Engine` and `JKAMP_Engine` are not declared, because merge.py has no engine target yet. They are added when the engine step starts.
- The SP Swift targets are not declared, because their seam types are C++ by construction and packet row 4 is open.

## Open names for the ruling

1. `CJKASyscall` for the shim target.
2. `JKAMP_GameLogic` for the game logic target, next to the `JKAMP_Game` view target.
3. `jampgame` as both the shell target and the dynamic library product.

## Ledger

- Row 1, the package layout: ratified as proposed, 2026-09-08. The three open names stand: `CJKASyscall`, `JKAMP_GameLogic`, `jampgame`.
