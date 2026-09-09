# Packet jka-swift step-001 - the package skeleton and the first engine call

Draft 2026-09-08, written in the jka-rust session for a new repository.
This packet binds the first lane of a Swift port of Jedi Academy.
The port shares the oracle, the porting rules, and the differential rigs of `mheh/jka-rust`, and it uses Swift's C interop as the ABI layer.
The step number is 001 because the repository does not exist yet.
Every open row below carries a proposed default, and the rows need a ratification walk before the lane spawns.

## Scope

This step delivers a Swift package that builds `jampgame` as a dynamic library, exports `dllEntry` and `vmMain`, and answers `GAME_INIT` with one real syscall.
The proof is an engine that loads the library, calls `dllEntry`, calls `vmMain(GAME_INIT, ...)`, and prints the line the module sends through `trap_Print`.

The step delivers:

- The repository at `/Users/milohehmsoth/Developer/Milo/jka-swift` with `oracle/` as the same submodule jka-rust uses, `https://github.com/mheh/jediacademy`, read-only.
- `Package.swift` with three targets and one dynamic product: `CJKA`, `JKAAbi`, `JKAGame`, and the product `jampgame`.
- The `CJKA` C target: one umbrella header that imports the Raven MP game headers, and one C file with the fixed-arity syscall shim.
- The `JKAAbi` Swift target: the syscall pointer's home, the typed `trap_Print` call, and the two exported entry points.
- The `JKAGame` Swift target: `vmMain` dispatch over the imported `gameExport_t`, the `GAME_INIT` slice, and an explicit unported marker on every other command.
- A test target that loads the built library, installs a recording syscall, and proves the `GAME_INIT` print arrives.
- `docs/porting-rules.md`, copied from jka-rust and amended for Swift in the places the surface contract names.

The step does not deliver: any game logic beyond the one print, `cgame`, `ui`, an engine, a renderer, C++ interop, a referee harness of its own, golden fixtures, CI, or Linux and Windows builds.
Those are later steps.

## Surface contract

### Package.swift

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "jka-swift",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "jampgame", type: .dynamic, targets: ["JKAGame"]),
    ],
    targets: [
        .target(
            name: "CJKA",
            path: "Sources/CJKA",
            cSettings: [
                .headerSearchPath("../../oracle/codemp"),
                .define("_GAME"),
            ]
        ),
        .target(
            name: "JKAAbi",
            dependencies: ["CJKA"]
        ),
        .target(
            name: "JKAGame",
            dependencies: ["JKAAbi"]
        ),
        .testTarget(
            name: "JKAGameSmokeTests",
            dependencies: ["JKAGame"]
        ),
    ]
)
```

The `_GAME` define matches Raven's game-module build and selects the game arm of `namespace_begin.h`.
No `interoperabilityMode(.Cxx)` setting appears anywhere in this step.

### CJKA

- `Sources/CJKA/include/CJKA.h`, the umbrella header.
  It includes, in this order: `game/q_shared.h`, `game/bg_public.h`, `game/g_public.h`, and `Sources/CJKA/include/jka_syscall.h`.
  It edits no Raven file.
- `Sources/CJKA/include/jka_syscall.h` and `Sources/CJKA/jka_syscall.c`:

```c
typedef intptr_t (*jka_syscall_fn)(intptr_t arg, ...);

// The engine gives us one variadic function pointer, and Swift cannot call a C variadic.
// This shim spreads a fixed array into the variadic call, one arm per argument count Raven uses.
intptr_t jka_syscall(jka_syscall_fn fn, intptr_t command, int count, const intptr_t *args);
```

The arm count covers 0 through 12 arguments, which is the widest `trap_*` in `oracle/codemp/game/g_syscalls.c`.

### JKAAbi

- `public enum Syscall`, a namespace with no cases.
  It holds `nonisolated(unsafe) static var entry: jka_syscall_fn?`, set once by `dllEntry`.
- `public func trapPrint(_ text: String)`, the `G_PRINT` call through the shim.
  Source: `oracle/codemp/game/g_syscalls.c`, the `trap_Printf` body.
- `@_cdecl("dllEntry") public func dllEntry(_ syscall: jka_syscall_fn)`.
  It stores the pointer and returns.
  Source: `oracle/codemp/game/g_syscalls.c:14`.

`JKAAbi` imports `CJKA` with `internal import`, so no C type appears in a public signature.
Where a later step needs a C struct in a public signature, the wrapper owns a Swift type for it.

### JKAGame

- `@_cdecl("vmMain") public func vmMain(_ command: Int32, _ arg0: Int32, ... _ arg11: Int32) -> Int32`, twelve arguments after the command, the shape of Raven's `vmMain`.
  Source: `oracle/codemp/game/g_main.c`, the `vmMain` definition.
- `GAME_INIT` calls `trapPrint("jka-swift jampgame init\n")` and returns 0.
  This is the slice, and it does not port `G_InitGame`.
- Every other `gameExport_t` command calls `portMissing("<Raven subject>", source: "oracle/codemp/game/g_main.c:<line>")`, which traps with the subject in the message.
- `func portMissing(_ subject: String, source: String) -> Never`, the executable form of the unported-work marker.

### Markers

The unported-work marker keeps the jka-rust form so both repositories grep the same way:

```swift
// TODO: Port G_InitGame
// Source: oracle/codemp/game/g_main.c:<line>
```

### Test target

- One test that does `dlopen` on the built `libjampgame.dylib`, resolves `dllEntry` and `vmMain`, installs a `@convention(c)` recording syscall, calls `dllEntry`, calls `vmMain(GAME_INIT, 0, 0, 0, ...)`, and asserts the recorded call is `G_PRINT` with the init line.

Anything not on this list is out of scope, and the agent must not add it.
A new package dependency is a ruling of the user's, and this packet grants none.

## Commit bundle

Every commit uses `--no-gpg-sign`, a heading subject, an STE body, and no trailer of any kind.
Every commit gates on `swift build` and `swift build -c release`.
Commits 4 and later also gate on `swift test`.

1. `process(step-001): the repository skeleton` - `.gitignore`, `README.md` with the goal in four sentences, `docs/porting-rules.md` copied from jka-rust with the Swift amendments the surface contract names, and the `oracle/` submodule.
   Gate: `git submodule status` shows the oracle at a commit, and the tree holds no build output.
2. `feat(step-001): the CJKA target imports the Raven game headers` - `Package.swift` with the `CJKA` target only, the umbrella header, an empty `jka_syscall.c`.
   Gate: `swift build` succeeds. The proof is a scratch Swift file that prints `MemoryLayout<gentity_t>.size` and matches the size jka-rust asserts for `gentity_t`. The scratch file is deleted before the commit, so the tree holds only the umbrella header and the empty shim.
3. `feat(step-001): the syscall shim` - `jka_syscall.h` and `jka_syscall.c` with the 0 through 12 arms.
   Gate: `swift build`, plus a C unit call in the test target that passes 12 arguments through the shim to a counting variadic and gets them back in order.
4. `feat(step-001): JKAAbi holds the syscall entry and trapPrint` - the `JKAAbi` target, `Syscall.entry`, `trapPrint`, `dllEntry`.
   Gate: `swift build`, `swift test`.
5. `feat(step-001): jampgame answers GAME_INIT` - the `JKAGame` target, the product, `vmMain`, the dispatch, the markers, `portMissing`.
   Gate: `swift build -c release`, `nm -gU .build/release/libjampgame.dylib` lists `_dllEntry` and `_vmMain`, `swift test` runs the smoke test green.
6. `process(step-001): the live-engine proof` - a `tools/stage-module.sh` that symlinks the release dylib as `jampgamei386.so` into a base folder the way `jka-rust/tools/lockstep-referee/run.sh` does.
   Gate: a STOP for the user. The user boots `jka-rust`'s `target/debug/mp_app` against that base folder and reads the init line in the console. The engine then hits the first unported command and traps with its Raven subject, which is the expected end of the proof.
7. `process(step-001): finished file`.

## Write scopes

- Branch: `step-001-skeleton` off the initial empty `master`.
- Paths: everything under the new repository except `oracle/`, which is read-only.
- The finished file lands at `.claude/packets/step-001/finished.md`.
- The agent never touches `/Users/milohehmsoth/Developer/Milo/jka-rust` and never touches `/Users/milohehmsoth/Developer/jka/`.

## Disposition

After a clean lane-review: open the pull request to `master` and merge it on GitHub with a merge commit.
Never squash, and never commit directly on `master`.
The user pushes and merges, the agent does not.

## Open rows

1. **The repository home** (user ruling). `/Users/milohehmsoth/Developer/Milo/jka-swift`, GitHub `mheh/jka-swift`, default branch `master`.
2. **The language mode** (user ruling). Swift tools version 6.0 and Swift 6 language mode from the first commit. The syscall pointer is the only global, marked `nonisolated(unsafe)` because the engine calls the module from one thread. The alternative is Swift 5 language mode, which defers the isolation questions to a later step.
3. **The minimum platform** (user ruling). macOS 15. Linux and Windows are later steps and this row does not bind them.
4. **The interop mode** (user ruling). C mode only, in every target of this step. C++ interop arrives only in a future rig target for the oracle C++ subsystems, and never in `CJKA` or `JKAAbi`.
5. **The header strategy** (mechanical). The umbrella header includes the oracle headers through a `headerSearchPath` into `oracle/codemp`. Fallback if SwiftPM rejects the path: a symlink `Sources/CJKA/include/codemp` that points at `../../../oracle/codemp`, committed as a symlink.
6. **The syscall argument width** (user ruling). `intptr_t`, the width jka-rust's trap layer uses on 64-bit hosts, see `jka-rust/docs/abi-traps.md`. Raven's ILP32 `int` is the 32-bit truth and a later step adds the `cfg` twin for it.
7. **The target names** (user ruling). `CJKA`, `JKAAbi`, `JKAGame`, product `jampgame`. The names mirror jka-rust's `native < qshared < bg < game` tiers in three steps instead of four, because Clang supplies the types the `qshared` tier hand-wrote.
8. **The state home for the syscall pointer** (user ruling). A static in the `Syscall` namespace in `JKAAbi`. Rule 6 allows one owned instance per logical singleton, and the engine hands over one pointer.
9. **The engine for the proof** (user ruling). jka-rust's `mp_app` is the engine for commit 6, because it is the one engine on this machine that loads a 64-bit `jampgamei386.so`. Retail `jamp` is 32-bit and cannot load the release dylib until the ILP32 twin lands.
10. **The git process** (mechanical). Branch, pull request, merge commit, never squash, never commit on `master`. The agent never pushes. This copies jka-rust DEC-67 and the copied porting rules say so.
11. **The fixture plan** (user ruling, deferred). Step-002 decides whether the jampgame goldens are copied from `jka-rust/tools/jampgame-oracle` or read by path. This step touches no fixture.

## Dispatch flags

- Oracle ambiguity: **false**. The two entry points and `trap_Printf` are three short bodies with one reading.
- New state home: **true**. The syscall pointer needs a home, row 8.
- ABI or parity-gate surface: **true**. Both exported symbols are the ABI, and the shim's argument width is row 6.
- Divergence proposal: **false**. The `GAME_INIT` slice is a stub with a marker, not a divergence.

## Standing constraints for the lane agent

- Invoke the `house-style` skill before you write anything, and pass this instruction to your sub-agents.
- Read `~/.claude/skills/asd-ste100/SKILL.md` and `~/.claude/skills/house-style/SKILL.md` by path before you write.
- `oracle/` is read-only and is cited by `file:line`.
- Source files change through the Edit tool only.
- `swift build` is the ground truth for compilation.
- Do not push.
- Pause on any unlisted surface, any contract signature change, any new dependency, or any fact that contradicts this packet. Ask, and resume after the amendment lands.
- The finished file is the last act: assumptions and choices keyed to their commits, deviations or the word "none", the commit list with gate results, and open gaps.

## Amendments

None yet.
