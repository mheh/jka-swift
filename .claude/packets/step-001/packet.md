# Packet jka-swift step-001 - the package skeleton and the first engine call

This packet binds the first lane of a Swift port of Jedi Academy.
The port shares the oracle, the porting rules, and the differential rigs of `mheh/jka-rust`, and it uses Swift's C interop as the ABI layer.
Every row below states a ratified ruling.
The three ratification ledgers beside this file, `ported-types.md`, `struct-views.md`, and `abi-stubs.md`, hold the mechanisms each row fixes.

## Scope

This step delivers a Swift package that builds `jampgame` as a dynamic library, exports `dllEntry` and `vmMain`, and answers `GAME_INIT` with one real syscall.
The proof is an engine that loads the library, calls `dllEntry`, calls `vmMain(GAME_INIT, ...)`, and prints the line the module sends through `trap_Print`.

The step delivers:

- The repository at `/Users/milohehmsoth/Developer/Milo/jka-swift` with `oracle/` as the same submodule jka-rust uses, `https://github.com/mheh/jediacademy`, read-only.
- `Package.swift` with the C targets, the Swift view targets, the logic targets, the `jampgame` shell, the test targets, and the one dynamic product `jampgame`.
- The C targets: `CJKASyscall` for the fixed-arity syscall shim, and the copied Raven headers `merge.py` writes into `CJKAShared`, `CJKAMP`, `CJKAMP_Game`, `CJKAMP_CGame`, `CJKAMP_UI`, `CJKASP`, `CJKASP_Game`, `CJKASP_CGame`, and `CJKASP_UI`.
- The `JKAShared` Swift target: `Syscall`, the `SyscallTransport` protocol, `EngineTransport`, the `SyscallWord` protocol, and `portMissing`.
- The `JKAMP` and `JKAMP_Game` Swift view targets: the generated re-exports, the generated views, and the typed `trap_*` functions of `g_syscalls.c`.
- The `JKAMP_BG` and `JKAMP_GameLogic` logic targets: the generated stub of every function of the module, and the generated callback thunk namespaces.
- The `jampgame` shell target: `dllEntry`, `vmMain`, the 40-arm decode, the `GAME_INIT` slice, and an explicit unported marker on every other command.
- `JKATestSupport` with the recording transport, and a test target that loads the built library, installs a recording syscall, and proves the `GAME_INIT` print arrives.
- `docs/porting-rules.md`, walked and ratified for Swift, and `docs/style.md` for the comment style rule 21 cites.

The step does not deliver: any game logic beyond the one print, `cgame`, `ui`, an engine, a renderer, C++ interop, a referee harness of its own, CI, or Linux and Windows builds.
Those are later steps.

## Surface contract

### Package.swift

The manifest as it stands, trimmed to the product and target lines:

```swift
// swift-tools-version: 6.3
import PackageDescription

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
        // The SP tree compiles clean as C today, so it is declared. Its Swift side waits on row 4.
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

`JKATestSupport` joins the manifest as a library target that depends on `JKAShared`, and every test target may depend on it.
It is a library target and not a product, so it ships in no dylib.
No `interoperabilityMode(.Cxx)` setting appears anywhere in this step.

### The C targets

The C targets hold Raven's copied headers and nothing else.
`tools/oracle-closure/extract.py` copies every type of a module into headers we own, one declaration per file with the oracle path mirrored and a `Source:` line.
`merge.py` partitions them into the targets above and writes `layout_asserts.h` per target with the oracle's `sizeof` and `offsetof`.
A copied header is never edited, and every header and every assert is regenerated whole on every run.
Raven's MP game module builds with `QAGAME`, `MISSIONPACK`, `_JK2`, and `NDEBUG`, which is the flag set the parse uses.
No target reads the oracle through a header search path.

### The syscall shim

`Sources/CJKASyscall/include/jka_syscall.h` and `Sources/CJKASyscall/jka_syscall.c`:

```c
typedef intptr_t (*jka_syscall_fn)(intptr_t arg, ...);

// Swift cannot call a C variadic, so this shim spreads a fixed array into the variadic call.
// One arm exists per argument count Raven uses, 0 through 13.
intptr_t jka_syscall(jka_syscall_fn fn, intptr_t command, int count, const intptr_t *args);
```

The arms cover 0 through 13 arguments.
The widest Raven trap is `BOTLIB_AAS_PREDICT_CLIENT_MOVEMENT` at 13 words, `oracle/codemp/game/g_syscalls.c:745`.
A wider call aborts, because it is a module bug.

### JKAShared, the transport and the word

`Syscall.call` runs over a `SyscallTransport` protocol with one requirement:

```swift
public protocol SyscallTransport {
    func call(_ command: Int, _ words: [Int]) -> Int
}
```

`public enum Syscall` is a namespace with no cases.
It holds `nonisolated(unsafe) public static var transport: SyscallTransport?`, set by `dllEntry` or by a test.
`Syscall.call` forwards to the installed transport, and traps with `Syscall.call before dllEntry` when none is installed.

`EngineTransport` is a public struct in `JKAShared` that holds the engine `OpaquePointer` and calls `jka_syscall` with the words.
It is the only Swift type that imports `CJKASyscall`.

`RecordingTransport` is a final class in `JKATestSupport`.
It records `calls`, records `texts` with the first word of a call read as a C string for the commands whose first word is one, `G_PRINT` and `G_ERROR` first, and answers from `answers: [Int: Int]` with 0 for an unlisted command.

`JKAShared` also holds the `SyscallWord` protocol, one `var word: Int` requirement, conformed by `Int32`, `Bool`, `Float`, `OpaquePointer`, `UnsafePointer`, `UnsafeMutablePointer`, and every `HandleView` by its handle.
`Float.word` is the sign-extended word `PASSFLOAT` makes, `Int(Int32(bitPattern: self.bitPattern))`.

`func portMissing(_ subject: String, source: String) -> Never` lives in `Sources/JKAShared/PortMissing.swift`, and traps with `TODO: Port <subject>` in the message.

### JKAMP_Game, the typed traps

Each view target hand-writes one typed overload of the call over its own wire enum, `Sources/JKAMP_Game/Syscall+Game.swift`:

```swift
extension Syscall {
    /// This packs typed words for one game import and sends it through the transport.
    @discardableResult
    static func call(_ command: gameImport_t, _ words: any SyscallWord...) -> Int {
        self.call(Int(command.rawValue), words.map(\.word))
    }
}
```

Both `Syscall.call` shapes carry `@discardableResult`, so a void trap does not spell `_ =`.

`tools/oracle-closure/traps.py` reads the `mp-game` unity parse and writes `Sources/JKAMP_Game/Generated/g_syscalls.swift`, one typed trap per Raven `trap_*` with Raven's name, Raven's parameter names, Raven's comment where one exists, a `/// Source:` line, and a body of one `Syscall.call`.
`PASSFLOAT` and `dllEntry` are not traps and are skipped.
The parameter table, one row per C shape:

| Raven | Swift | In the call |
|---|---|---|
| `int`, scalar typedef | `Int32`, the re-exported typealias | bare |
| `qboolean` | `Bool` | bare |
| `float` | `Float` | bare |
| `const char *` | `String` | `withCString` around the call, the pointer |
| `char *` followed by an `int` size | dropped, the trap returns `String` | a buffer of the size, read after the call |
| `const vec3_t`, `vec3_t` | `vec3_t` | a local `var` copy, passed as `&start`, written back when Raven's parameter was not `const` |
| pointer to a struct with a view | the view, `Entity`, `Trace`, `Usercmd` | bare |
| `void *` | `OpaquePointer?` | bare |
| anything else | the trap is emitted with `// TODO: Port signature` and Raven's C text, body `portMissing` | |

Returns: `void` is no return, `int` and a scalar typedef return `Int32(truncatingIfNeeded:)`, `qboolean` returns `word != 0`, `float` returns `Float(bitPattern: UInt32(truncatingIfNeeded: word))`, and `qhandle_t` returns the typealias.
The wire enum is `gameImport_t`, re-exported as a struct over `Int32`, so `.G_PRINT` is its static member and no per-syscall type exists.

### jampgame, the shell

`Sources/jampgame/jampgame.swift` holds both entry points.

- `@_cdecl("dllEntry") public func dllEntry(_ syscallptr: OpaquePointer)` sets `Syscall.transport = EngineTransport(entry: syscallptr)`.
  Source: `oracle/codemp/game/g_syscalls.c:14`.
- `@_cdecl("vmMain") public func vmMain(_ command: Int, _ arg0: Int, ... _ arg11: Int) -> Int`, twelve words after the command, the shape of Raven's `vmMain`.
  Source: `oracle/codemp/game/g_main.c:515`.

The words and the return are `Int`, not `Int32`, because row 6 ruled `intptr_t` as the word width and two arms carry a pointer in a word.
`GAME_ROFF_NOTETRACK_CALLBACK` reads a `const char *` from its second word, and `GAME_CLIENT_CONNECT` returns a `char *` as the word.
The ILP32 twin narrows the words with the shim in a later step.

The 40 arms are hand-written in Raven's order, because the arms have four shapes and 40 lines is not a generator's job.
`GAME_INIT` calls `trap_Print("jka-swift jampgame init\n")` and returns 0.
This is the slice, and it does not port `G_InitGame`.
Every other arm carries the `// TODO: Port <subject>` marker and calls `portMissing("<Raven subject>", source: "oracle/codemp/game/g_main.c:<line>")`, so the marker count of the file is 39.
The `default` arm returns -1.

### The skeleton

`tools/oracle-closure/skeleton.py` reads the `mp-game` unity parse and writes one Swift file per Raven `.c` file, `Sources/JKAMP_GameLogic/g_mover.swift` for `g_mover.c` and `Sources/JKAMP_BG/bg_pmove.swift` for `bg_pmove.c`.
`g_syscalls.c` belongs to `traps.py` and is skipped.
Functions keep Raven's order.
Raven's comment block above a function is emitted verbatim as `/** */`, and the `/// Source:` line sits beneath it, directly above the declaration.
Raven's signature maps through the parameter table above, and Raven's `static` becomes `private`, and so does every copy of a name that more than one file defines, because SpeederNPC.c defines `Update` without `static` and four vehicle files define it with. A function the oracle stores in a callback field stays internal, because its thunk names it from another file. A function that returns a pointer to a viewed struct returns the optional view.
A body is `// TODO: Port X` plus `portMissing`.
A signature the table cannot map carries `// TODO: Port signature` with Raven's C text.

`skeleton.py` also writes `Sources/JKAMP_GameLogic/Generated/Callbacks.swift`: one enum per callback field, `Think`, `Use`, `Touch`, `Die`, `Pain`, `Reached`, and `Blocked`, and one static thunk per stored function, named as the function.
Clears to `0` and `NULL` are not stores of a name and are skipped, as are the two dynamic stores at `NPC_spawn.c:1119` and `:1120`.

The counts the run reports: 2932 stubs across 88 files, 201 statics in seven namespaces, and the `TODO: Port signature` count per file.

### Markers

The unported-work marker keeps the jka-rust form so both repositories grep the same way:

```swift
// TODO: Port G_InitGame
// Source: oracle/codemp/game/g_main.c:<line>
```

### Test target

- One test that does `dlopen` on the built `libjampgame.dylib`, resolves `dllEntry` and `vmMain`, installs a `@convention(c)` recording syscall, calls `dllEntry`, calls `vmMain(GAME_INIT, 0, 0, 0, ...)`, and asserts the recorded call is `G_PRINT` with the init line.
  The smoke test drives the built dylib from outside, so it keeps its own `@convention(c)` syscall and does not use `RecordingTransport`.
- The in-process tests install `RecordingTransport` on `Syscall.transport` and read `calls` and `texts` after the code under test ran.

Anything not on this list is out of scope, and the agent must not add it.
A new package dependency is a ruling of the user's, and this packet grants none.

## Commit bundle

Every commit uses `--no-gpg-sign`, a heading subject, an STE body, and no trailer of any kind.
Every commit gates on `swift build` and `swift build -c release`.
A commit that touches Swift code also gates on `swift test`, and a commit that touches the generated headers also gates on `check.sh`.

What has landed:

- The repository skeleton, the oracle submodule, and the package building against the MP oracle headers.
- `docs/porting-rules.md` walked and ratified, and `docs/style.md`.
- The oracle type extractor, the target merge, the ratified package layout, and the manifest above.
- The ported types: placement by Raven header, the layout asserts on six triples, the re-export generator, and rule 12's one size per pointer width.
- The struct views: the view generator, the `.c`-file macros, the support types, `GameMemory` and the world, the generated views, and the boxed word read for the callback compare.

What task 8 still delivers:

1. `feat(step-001): the transport and the syscall word` - `Syscall`, `SyscallTransport`, `EngineTransport`, `SyscallWord`, and `PortMissing.swift` in `JKAShared`, plus `JKATestSupport` with `RecordingTransport`.
   Gate: `swift build`, `swift test` with a test that installs the recorder and reads back one call.
2. `tools(step-001): the typed traps` - `traps.py`, the generated `Sources/JKAMP_Game/Generated/g_syscalls.swift`, and the hand-written `Syscall+Game.swift`.
   Gate: `swift build`, and the report states the trap count and the `TODO: Port signature` count.
3. `tools(step-001): the skeleton and the callback thunks` - `skeleton.py`, the stub file per Raven `.c` file in `JKAMP_BG` and `JKAMP_GameLogic`, and `Generated/Callbacks.swift`.
   Gate: `swift build`, and the report states 2932 stubs across 88 files and 201 statics in seven namespaces.
4. `feat(step-001): jampgame answers GAME_INIT` - the `jampgame` shell, `dllEntry`, `vmMain`, the 40 arms, the markers.
   Gate: `swift build -c release`, `nm -gU .build/release/libjampgame.dylib` lists `_dllEntry` and `_vmMain`, `swift test` runs the smoke test green.
5. `process(step-001): the live-engine proof` - a `tools/stage-module.sh` that symlinks the release dylib as `jampgamei386.so` into a base folder the way `jka-rust/tools/lockstep-referee/run.sh` does.
   Gate: a STOP for the user. The user boots `jka-rust`'s `target/debug/mp_app` against that base folder and reads the init line in the console. The engine then hits the first unported command and traps with its Raven subject, which is the expected end of the proof.
6. `process(step-001): finished file`.

## Write scopes

- Branch: `step-001-skeleton` off `master`.
- Paths: everything under the repository except `oracle/`, which is read-only.
- Task 8 writes `Sources/JKAShared/`, `Sources/JKATestSupport/`, `Sources/JKAMP_Game/Syscall+Game.swift`, `Sources/JKAMP_Game/Generated/g_syscalls.swift`, `Sources/JKAMP_BG/`, `Sources/JKAMP_GameLogic/`, `Sources/jampgame/`, `Tests/`, `Package.swift`, and `tools/oracle-closure/traps.py` and `skeleton.py` with their `README.md` entries.
- The finished file lands at `.claude/packets/step-001/finished.md`.
- The agent never touches `/Users/milohehmsoth/Developer/Milo/jka-rust` and never touches `/Users/milohehmsoth/Developer/jka/`.

## Disposition

After a clean lane-review: open the pull request to `master` and merge it on GitHub with a merge commit.
Never squash, and never commit directly on `master`.
The user pushes and merges, the agent does not.

## Open rows

1. **The repository home** (user ruling). `/Users/milohehmsoth/Developer/Milo/jka-swift`, GitHub `mheh/jka-swift`, default branch `master`.
2. **The language mode** (user ruling). Swift tools version 6.3 and Swift 6 language mode. The one static is `Syscall.transport`, the installed `SyscallTransport?`, marked `nonisolated(unsafe)` because the engine calls the module from one thread.
3. **The minimum platform** (user ruling). macOS 15. Linux and Windows are later steps and this row does not bind them.
4. **The interop mode** (user ruling). C mode only, in every target of this step. C++ interop arrives only in a future rig target for the oracle C++ subsystems, and never in a C target or a view target of this step.
5. **The header strategy** (mechanical). Every C target holds headers we own, copied by `extract.py` and partitioned by `merge.py`, with `layout_asserts.h` per target. No target reads the oracle through a header search path and no oracle symlink sits under `Sources/`.
6. **The syscall argument width** (user ruling). `intptr_t`, the width jka-rust's trap layer uses on 64-bit hosts, see `jka-rust/docs/abi-traps.md`. The layout asserts are generated per target triple for `i686-pc-windows-msvc`, `i686-pc-linux-gnu`, `x86_64-pc-windows-msvc`, `x86_64-pc-linux-gnu`, `x86_64-apple-macosx`, and `arm64-apple-macosx`, checked with `clang -target -fsyntax-only` on any host. A seam type has one size on every triple of the same pointer width. Raven's ILP32 `int` is the 32-bit truth and a later step adds the twin for it.
7. **The target names** (user ruling). C targets `CJKASyscall`, `CJKAShared`, `CJKAMP`, `CJKAMP_Game`, `CJKAMP_CGame`, `CJKAMP_UI`, `CJKASP`, `CJKASP_Game`, `CJKASP_CGame`, and `CJKASP_UI`. Swift view targets `JKAShared`, `JKAMP`, and `JKAMP_Game`. Logic targets `JKAMP_BG` for `bg_*` and `JKAMP_GameLogic` for `g_*`. The shell target and the dynamic product both take Raven's name `jampgame`. The cgame, ui, and engine Swift targets are declared when their step starts.
8. **The state home for the syscall pointer** (user ruling). `Syscall.transport`, one static in the `Syscall` namespace in `JKAShared`, holding the installed `SyscallTransport`. `dllEntry` sets it to an `EngineTransport` over the engine pointer, and a test sets it to a recorder. Rule 6 allows one owned instance per logical singleton, and the engine hands over one pointer.
9. **The engine for the proof** (user ruling). jka-rust's `mp_app` is the engine for the live proof, because it is the one engine on this machine that loads a 64-bit `jampgamei386.so`. Retail `jamp` is 32-bit and cannot load the release dylib until the ILP32 twin lands.
10. **The git process** (mechanical). Branch, pull request, merge commit, never squash, never commit on `master`. The agent never pushes. This copies jka-rust DEC-67 and the porting rules say so.
11. **The fixture plan** (user ruling). The goldens are copied into the repository from jka-rust's oracle harnesses, so `swift test` is self-contained and needs no C toolchain and no oracle checkout.

## Dispatch flags

- Oracle ambiguity: **false**. The two entry points, the 40 arms, and `trap_Printf` have one reading each.
- New state home: **true**. The transport needs a home, row 8.
- ABI or parity-gate surface: **true**. Both exported symbols are the ABI, and the shim's argument width is row 6.
- Divergence proposal: **false**. The `GAME_INIT` slice is a stub with a marker, not a divergence.

## Standing constraints for the lane agent

- Invoke the `house-style` skill before you write anything, and pass this instruction to your sub-agents.
- Read `~/.claude/skills/asd-ste100/SKILL.md` and `~/.claude/skills/house-style/SKILL.md` by path before you write.
- `oracle/` is read-only and is cited by `file:line`.
- Source files change through the Edit tool only.
- `swift build` is the ground truth for compilation.
- Do not push.
- Pause on any unlisted surface, any contract signature change, any new dependency, or any fact that contradicts this packet. Ask, and resume after the packet is rewritten.
- The finished file is the last act: assumptions and choices keyed to their commits, deviations or the word "none", the commit list with gate results, and open gaps.
