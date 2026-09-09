# ABI stubs, the proposal for vet task 7

Written 2026-09-09. Four rows. The packet already fixes the shell shape: `dllEntry`, `vmMain` with twelve words, `GAME_INIT` answered with one `trap_Print`, `portMissing` on every other command, the marker pair, and the `dlopen` smoke test. These rows fix the mechanisms under that shape. Each row shows the file it would produce. Nothing is implemented until its row is ratified.

The evidence, measured on the oracle with `fnsweep.py` and libclang, not grep:

- `g_syscalls.c` holds 313 `trap_*` definitions. The widest is `trap_AAS_PredictClientMovement` with 13 words, `g_syscalls.c:745`. Returns: 154 void, 106 int, 48 qboolean, 4 float, 1 qhandle_t. A float crosses through `PASSFLOAT`, `g_syscalls.c:21`, and a float return is the inverse cast in the caller, `g_syscalls.c:667`.
- `vmMain`, `g_main.c:515`, takes twelve words and has 40 cases, one per `gameExport_t` member. `GAME_CLIENT_CONNECT` returns a `char *` as the word, `g_main.c:524`. `GAME_ROFF_NOTETRACK_CALLBACK` casts its second word to `const char *`, `g_main.c:548`. The 17 `GAME_ICARUS_*` cases read a shared buffer and ignore every word.
- `gameImport_t` has 329 members, numeric range 0 to 634, and `gameExport_t` has 40. Both are re-exported in `Sources/JKAMP_Game/Generated/g_public.swift`.
- The module has 2934 function definitions across 89 `.c` files, 2569 non-static and 365 static.
- The callback fields hold 326 real stores of 201 distinct functions. No function is stored in two fields. The stores to exclude are `= 0` and `= NULL` clears, and two dynamic stores at `NPC_spawn.c:1119` and `:1120` whose value is a call.

## Row 1, the transport

Rule 11 says `Syscall.call` runs over a `SyscallTransport` protocol with the C shim as the engine conformer and a recorder as the test conformer. The mechanism: one protocol with one requirement, one static on `Syscall` that holds the conformer, and `Syscall.call` forwards to it. `Syscall.entry` goes away, because the transport holds the engine pointer.

`Sources/JKAShared/Syscall.swift`:

```swift
/// A transport carries one trap to an engine and returns the engine's word.
/// The engine conformer is `EngineTransport`, and a test installs a recorder.
public protocol SyscallTransport {
    func call(_ command: Int, _ words: [Int]) -> Int
}

/// This namespace holds the one transport the module talks through.
/// The engine calls the module from one thread, so the static needs no isolation.
public enum Syscall {
    /// The installed transport, set once by `dllEntry` or by a test.
    nonisolated(unsafe) public static var transport: SyscallTransport?

    /// This sends one trap through the transport and returns the engine's word.
    /// A call before `dllEntry` traps, because the module has no engine yet.
    public static func call(_ command: Int, _ words: [Int] = []) -> Int {
        guard let transport = self.transport else { fatalError("Syscall.call before dllEntry") }
        return transport.call(command, words)
    }
}
```

`Sources/JKAShared/EngineTransport.swift`, the one conformer that sees the C shim:

```swift
internal import CJKASyscall

/// This transport calls the engine's variadic entry point through the C shim.
/// The shim has one arm per word count, 0 through 13, and aborts on a wider call.
public struct EngineTransport: SyscallTransport {
    let entry: OpaquePointer

    public init(entry: OpaquePointer) { self.entry = entry }

    public func call(_ command: Int, _ words: [Int]) -> Int {
        words.withUnsafeBufferPointer { buffer in
            let base = UnsafeRawPointer(buffer.baseAddress!).assumingMemoryBound(to: intptr_t.self)
            return Int(jka_syscall(self.entry, intptr_t(command), Int32(words.count), base))
        }
    }
}
```

The recorder lives in a new target, `JKATestSupport`, that depends on `JKAShared` and that every test target may depend on. It is a library target and not a product, so it ships in no dylib.

`Sources/JKATestSupport/RecordingTransport.swift`:

```swift
/// This transport records every trap and answers each with a scripted word.
/// A test reads `calls` and `texts` after the code under test ran.
public final class RecordingTransport: SyscallTransport {
    public private(set) var calls: [(command: Int, words: [Int])] = []
    public private(set) var texts: [(command: Int, text: String)] = []
    public var answers: [Int: Int] = [:]
    ...
}
```

`texts` holds the first word of a call read as a C string, for the commands whose first word is one, `G_PRINT` and `G_ERROR` first. The scripted `answers` map a command to its return word, and an unlisted command returns 0. The `dlopen` smoke test in the packet does not use the recorder, because it drives the built dylib from outside, so it keeps its `@convention(c)` recording syscall.

The delta. Rule 6 names `Syscall.entry` as the one static in `JKAShared`. The name becomes `Syscall.transport`, and the rule's sentence changes with it. The packet's row 8 and its 2026-09-08 amendment name `entry` too, and the ledger of this walk amends them.

## Row 2, the typed traps

Rule 11 says one typed trap per Raven `trap_*`, with Raven's name, taking views and Swift values, doing the word packing, in `JKAMP_Game`. The mechanism: `tools/oracle-closure/traps.py` reads the `mp-game` unity parse, finds every function of `g_syscalls.c` whose body is one `syscall(...)` call, and writes `Sources/JKAMP_Game/Generated/g_syscalls.swift`. Each trap carries Raven's comment when one exists, a `/// Source:` line, Raven's parameter names, and a body of one `Syscall.call`. `PASSFLOAT` and `dllEntry` are not traps and are skipped.

The packing lives once per value kind, not once per trap. `JKAShared` holds a `SyscallWord` protocol, and each view target holds one typed overload of `Syscall.call` over its own wire enum, so a trap reads as Raven's `syscall( G_PRINT, string )` did.

`Sources/JKAShared/SyscallWord.swift`:

```swift
/// A value that packs into one syscall word, as Raven's `int` argument did.
public protocol SyscallWord {
    var word: Int { get }
}

extension Int32: SyscallWord { public var word: Int { Int(self) } }
extension Bool: SyscallWord { public var word: Int { self ? 1 : 0 } }
extension Float: SyscallWord { public var word: Int { Int(Int32(bitPattern: self.bitPattern)) } }
extension OpaquePointer: SyscallWord { public var word: Int { Int(bitPattern: self) } }
extension UnsafePointer: SyscallWord { public var word: Int { Int(bitPattern: self) } }
extension UnsafeMutablePointer: SyscallWord { public var word: Int { Int(bitPattern: self) } }
extension HandleView { public var word: Int { Int(bitPattern: self.handle) } }
```

`Float.word` is the sign-extended word `PASSFLOAT` makes. `HandleView` gains `SyscallWord` as a refinement, so every view is a word by its handle. `Syscall.call` in row 1 and the typed overload carry `@discardableResult`, so a void trap does not spell `_ =`.

`Sources/JKAMP_Game/Syscall+Game.swift`, hand-written, one per view target:

```swift
extension Syscall {
    /// This packs typed words for one game import and sends it through the transport.
    @discardableResult
    static func call(_ command: gameImport_t, _ words: any SyscallWord...) -> Int {
        self.call(Int(command.rawValue), words.map(\.word))
    }
}
```

The parameter table, one row per C shape `views.py` already knows plus the seam shapes:

| Raven | Swift | In the call |
|---|---|---|
| `int`, scalar typedef | `Int32`, the re-exported typealias | bare |
| `qboolean` | `Bool` | bare |
| `float` | `Float` | bare |
| `const char *` | `String` | `withCString` around the call, the pointer |
| `char *` followed by an `int` named as a size | dropped, the size stays, the trap returns `String` | a buffer of the size, read after the call |
| `const vec3_t`, `vec3_t` | `vec3_t` | `withUnsafePointer` around the call, a `var` copy and `withUnsafeMutablePointer` when Raven's parameter was not `const`, because `&x` converts to a pointer only for a pointer parameter |
| pointer to a struct with a view | the view, `Entity`, `Trace`, `Usercmd` | bare |
| `void *` | `OpaquePointer?` | bare |
| anything else | the trap is emitted with `// TODO: Port signature` and Raven's C text, body `portMissing` | |

Returns: `void` is no return, `int` and a scalar typedef return `Int32(truncatingIfNeeded:)`, `qboolean` returns `word != 0`, `float` returns `Float(bitPattern: UInt32(truncatingIfNeeded: word))`, and `qhandle_t` returns the typealias. A `char *` out-buffer with no size parameter beside it, and a struct pointer with no view, fall to the last row, so the count of `TODO: Port signature` in the file is the count of traps a later step must shape by hand.

Three of the 313 as `traps.py` would write them:

```swift
/// Source: oracle/codemp/game/g_syscalls.c:27
public func trap_Print(_ text: String) {
    text.withCString { Syscall.call(.G_PRINT, $0) }
}

/// Source: oracle/codemp/game/g_syscalls.c:178
public func trap_LinkEntity(_ ent: Entity) {
    Syscall.call(.G_LINKENTITY, ent)
}

/// Source: oracle/codemp/game/g_syscalls.c:148
public func trap_Trace(_ results: Trace, _ start: vec3_t, _ mins: vec3_t, _ maxs: vec3_t, _ end: vec3_t, _ passEntityNum: Int32, _ contentmask: Int32) {
    _ = withUnsafePointer(to: start) { start in
        withUnsafePointer(to: mins) { mins in
            withUnsafePointer(to: maxs) { maxs in
                withUnsafePointer(to: end) { end in
                    Syscall.call(.G_TRACE, results, start, mins, maxs, end, passEntityNum, contentmask, 0, 10)
                }
            }
        }
    }
}
```

The wire enum is `gameImport_t`, re-exported as a struct over `Int32`, so `.G_PRINT` is its static member and no per-syscall type exists.

## Row 3, the shell

The packet fixes `dllEntry` and `vmMain`. Two mechanisms sit under them.

The word type. The packet spells `vmMain` over `Int32`. Raven's `vmMain` takes `int`, and two of its arms carry a pointer in a word: `GAME_ROFF_NOTETRACK_CALLBACK` reads a `const char *` from the second word, and `GAME_CLIENT_CONNECT` returns a `char *` as the word. Packet row 6 ruled `intptr_t` as the word width for this 64-bit build, and jka-rust's `vmMain` takes its words as `isize`. So `vmMain` takes `Int` words, and the ILP32 twin narrows them with the shim in a later step. This is a delta to the packet text.

The decode. The 40 arms are hand-written in `Sources/jampgame/jampgame.swift`, cited to `g_main.c:515`, because the arms have four shapes and 40 lines is not a generator's job. `GAME_INIT` calls `trap_Print("jka-swift jampgame init\n")` and returns 0. Every other arm calls `portMissing` with the arm's Raven subject and its `g_main.c` line, so the marker count of the file is 39. The arm order is Raven's.

```swift
import JKAShared
import JKAMP_Game
import JKAMP_GameLogic

/// Source: oracle/codemp/game/g_syscalls.c:14
@_cdecl("dllEntry")
public func dllEntry(_ syscallptr: OpaquePointer) {
    Syscall.transport = EngineTransport(entry: syscallptr)
}

/// Source: oracle/codemp/game/g_main.c:515
@_cdecl("vmMain")
public func vmMain(
    _ command: Int,
    _ arg0: Int, _ arg1: Int, _ arg2: Int, _ arg3: Int, _ arg4: Int, _ arg5: Int,
    _ arg6: Int, _ arg7: Int, _ arg8: Int, _ arg9: Int, _ arg10: Int, _ arg11: Int
) -> Int {
    switch gameExport_t(rawValue: Int32(truncatingIfNeeded: command)) {
    case .GAME_INIT:
        trap_Print("jka-swift jampgame init\n")
        return 0

    case .GAME_SHUTDOWN:
        // TODO: Port G_ShutdownGame
        portMissing("G_ShutdownGame", source: "oracle/codemp/game/g_main.c:521")
    ...
    default:
        return -1
    }
}
```

`portMissing` lives in `Sources/JKAShared/PortMissing.swift` as rule 14 spells it, `func portMissing(_ subject: String, source: String) -> Never`, and traps with `TODO: Port <subject>` in the message.

## Row 4, the skeleton

Rule 13 says every function of the module is a generated stub with Raven's signature, Raven's comment, a `Source:` line, and a body that traps. The mechanism: `tools/oracle-closure/skeleton.py` reads the `mp-game` unity parse and writes one Swift file per Raven `.c` file, `Sources/JKAMP_GameLogic/g_mover.swift` for `g_mover.c` and `Sources/JKAMP_BG/bg_pmove.swift` for `bg_pmove.c`. `g_syscalls.c` is row 2's and is skipped. Functions keep Raven's order. Raven's block above a function is emitted verbatim as `/** */`, and the `/// Source:` line sits beneath it, directly above the declaration, as the comment rules say. The parameter table is row 2's, and a signature the table cannot map carries `// TODO: Port signature` with Raven's C text above a stub that takes no arguments. Raven's `static` is dropped, because Swift module scope already hides the function from other modules and the thunk namespaces below must reach it.

```swift
/**
================
G_ExplodeMissile

Explode a missile without an impact
================
*/
/// Source: oracle/codemp/game/g_missile.c:113
func G_ExplodeMissile(_ ent: Entity) {
    // TODO: Port G_ExplodeMissile
    portMissing("G_ExplodeMissile", source: "oracle/codemp/game/g_missile.c:113")
}
```

The thunk namespaces of struct-views row 4 are the second output. `skeleton.py` finds every store to a callback field across the module's `.c` files and writes `Sources/JKAMP_GameLogic/Generated/Callbacks.swift`, one `enum` per field, one static per stored function, named as the function. Clears to `0` and `NULL` and the two dynamic stores in `NPC_spawn.c` are not stores of a name and are skipped. `touch_NULL` is a real function and is kept.

```swift
/// One static per function the oracle stores in `think`, so each has one address.
enum Think {
    /// Source: oracle/codemp/game/g_missile.c:113
    static let G_ExplodeMissile: EntityThink = { JKAMP_GameLogic.G_ExplodeMissile(Entity(handle: $0!)) }
    ...
}
```

The counts the run must report: 2932 stubs across 88 files, seven namespaces with 201 statics, and the `TODO: Port signature` count per file. A regenerated file is replaced whole until its first hand edit, as rule 13 says, and the generator refuses to overwrite a file that no longer carries its header line.

## Ledger

- Row 1, the transport: ratified as proposed, `Syscall.entry` becomes `Syscall.transport`, 2026-09-09.
- Row 2, the typed traps: ratified as amended, `SyscallWord` in `JKAShared`, one typed `Syscall.call` overload per view target, `@discardableResult` on both calls, 2026-09-09.
- Row 3, the shell: ratified as proposed, `vmMain` words and return are `Int`, 2026-09-09.
- Row 4, the skeleton: ratified as amended, Raven's block first as `/** */` and the `Source:` line beneath it, 2026-09-09.
