# jka-swift

A Swift port of Star Wars Jedi Knight: Jedi Academy, modeled on [jka-rust](jka-rust), a git submodule at its `master` branch. The MP game module comes first, as the dynamic library `jampgame` the `jamp` engine loads, and the other modules follow it. The target is a drop-in replacement for each binary Raven shipped.

## The oracle (`oracle/`)

[`oracle/`](oracle) is a git submodule that holds Raven's released Jedi Academy source, SP under `code/` and MP under `codemp/`. We never edit it. Every port is verified against it, and every generated declaration cites the line it came from. The rules a port follows are in [`docs/porting-rules.md`](docs/porting-rules.md), the shapes a transcriptor writes are in [`docs/transcription.md`](docs/transcription.md), and the generators that read the oracle are described in [`tools/oracle-closure/README.md`](tools/oracle-closure/README.md).

## Status

The tree holds every function of the MP game module as a callable stub, and the bg files with the most logic, `bg_pmove` and `bg_misc`, have bodies. The per file tables under [`.claude/manifest`](.claude/manifest) say which functions are ported, which are markers, and what each stub's signature is, and a Port-note in a body marks each place Raven's C has no Swift form yet.

The ported bodies are untested. The test targets cover the shared layer and the generated seam: the math parity, the string pool, `Slots`, the syscall word, the format and scan helpers, the bg channel, the bg tables, the type layouts, the world, the game storage, the game traps, and the dylib smoke test. No test names a `PM_` function. I report that the module booted under the engine, registered, and fatal errored at the first unported body. The tree cannot show that run.

The rulings that shaped the tools were made one row at a time, each shown as generated output and committed on its own, and the ledger of those walks sits in the guide.

## Build and verify

Run these from the repo root.

1. Fetch the oracle source: `git submodule update --init`. The generators and the tests read it.
2. Build: `swift build`, and `swift build -c release` for the library the engine loads. `Package.swift` declares `swift-tools-version: 6.3`, and the tree builds with Apple Swift 6.3.3.
3. Test: `swift test --no-parallel`. The tests share the module's one world and one bg state, so the suites run one at a time.

## For readers of Raven's `g_*.c`

Files mirror Raven's `.c` files, functions keep Raven's names, fields keep Raven's names, and Raven's comments stay in place. `grep -rn "G_RadiusDamage"` lands where you expect. Here is one function in two forms, 2003 and today.

```c
/* 2003 - oracle/codemp/game/bg_pmove.c */
qboolean PM_DoSlowFall(void)
{
	if ( ( (pm->ps->legsAnim) == BOTH_WALL_RUN_RIGHT || (pm->ps->legsAnim) == BOTH_WALL_RUN_LEFT ) && pm->ps->legsTimer > 500 )
	{
		return qtrue;
	}

	return qfalse;
}
```

```swift
/// Source: oracle/codemp/game/bg_pmove.c:321
func PM_DoSlowFall() -> Bool {
    let ps = bg.pm.ps
    if ((ps.legsAnim) == BOTH_WALL_RUN_RIGHT || (ps.legsAnim) == BOTH_WALL_RUN_LEFT) && ps.legsTimer > 500 {
        return true
    }

    return false
}
```

`qboolean` is `Bool`, `pm->ps` is a view, and the line reads as Raven wrote it. Three approaches make that possible, and each one is a turn away from what jka-rust did, where the early expectations about threading, ownership, and language types over raw buffers came apart against the engine.

### 1. A Swift type overlays the C type

Where jka-rust took each ABI struct apart into a seam half the engine reads and a private half of owned Rust values, this port keeps the C struct whole. To keep the casts across the ABI boundary, a view is a Swift struct that stores one pointer, and the pointer is the real `gentity_t` or `vmCvar_t` in the memory the engine reads. Everything that makes the type more usable, a `String` over a `char` array, a `Bool` over a `qboolean`, a view over a pointer field, is a property accessor above the pointer. `views.py` writes every view from the oracle's headers. The `string` field of a cvar is the whole idea in four lines:

```swift
public struct VmCvar: Hashable, HandleView {
    let raw: UnsafeMutablePointer<vmCvar_t>
    // ...

    /// Source: oracle/codemp/game/q_shared.h:1829
    public var string: String {
        get { cString(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.string)!)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.string)!), capacity: Int(JKAShared.MAX_CVAR_VALUE_STRING)) }
    }
}
```

The ins and outs of the syscall layer are C types with nothing on top. [`Sources/JKAShared/Syscall.swift`](Sources/JKAShared/Syscall.swift) takes a command number and an array of `Int` words and returns one word, and `SyscallWord.swift` packs each type into a word, a `Float` through Raven's `PASSFLOAT` bit pattern and a pointer through its bit pattern. The generated traps in [`Sources/JKAMP_Game/Generated/g_syscalls.swift`](Sources/JKAMP_Game/Generated/g_syscalls.swift) take Swift types above that, a `String` through `withCString` and a `VmCvar` by its handle. Everything logic side is written on top of the traps, in the native language, and works as the native language.

### 2. Owned state is one singleton

Where jka-rust treated ownership as the point of truth and passed a context of the whole game into every function, this port says what the engine says. The game is single threaded. The engine calls `vmMain` from one thread with no context argument, so the port keeps Raven's globals, `g_entities`, `g_clients`, `level`, behind one instance and reaches them through file-scope accessors with Raven's names. The concurrency machinery of the last ten years is set aside on purpose, with `nonisolated(unsafe)` on the one instance, because the engine is bare function calls and the module has to meet it there.

```swift
/// All state of the game module, rule 3. One instance exists behind `world`, and a test assigns a fresh one.
final class GameWorld {
    let storage = GameStorage()
    let strings = StringPool()

    /// Raven's `static unsigned long holdrand` of `q_math.c`, which the game module owns one copy of.
    /// Source: oracle/codemp/game/q_math.c:1432
    var rng = Rng()
}

/// The one instance. `vmMain` has no context argument and the engine calls the module from one thread, so this is not isolated.
nonisolated(unsafe) var world = GameWorld()

/// Source: oracle/codemp/game/g_main.c:27
var g_entities: Slots<Entity> { world.storage.g_entities }
```

A test swaps the world with `world = GameWorld()`. The bg files, which Raven compiles into each module, keep the same shape on `BgState` behind `bg`. One thread as the game and ABI layer while other threads copy the whole state out still seems worth having, and the singleton keeps that door open, because the state is one object.

A variable Raven writes at file scope is a property of a generated variables struct the world owns, and the stub of Raven's file forwards it under Raven's name, so a body writes `gWPNum = 0` as he did. A file-scope variable Raven never writes is a `let` constant of C's zero in its stub, which is not state, so it stays there.

### 3. The machine writes everything but the bodies

Where jka-rust prompted agents blind, with a translation book and a line range and no grep, no build, and no new types, this port generates the ground the agents stand on. That first attempt It took clang symbol dumps and a call-graph tool to decide the porting order, and the agents still stopped at a call they could not see, because no signature existed for `G_Spawn`.

Now the generators in [`tools/oracle-closure`](tools/oracle-closure) read the oracle with libclang and write everything a body needs before any body is written. `extract.py` copies Raven's types as C headers. `merge.py` places each type in a shared, per tree, or per module C target. `reexport.py` writes the macros and enums as Swift declarations. `views.py` writes the views. `skeleton.py` writes every function as a stub with the table's signature, one Swift file per Raven `.c` file, and the storage and variables the world owns. `traps.py` writes the typed traps, `channel.py` the bg call channel, and `manifest.py` the per file function tables under `.claude/manifest`. `table.py` holds the C to Swift mapping the generators share, and `rulings.py` holds the name rules, so a decision is one entry, not a patch.

A stub is a signature over `portMissing`, so every call with a signature is valid at the onset, and the module fatal errors at the first body that is not filled:

```swift
/// Source: oracle/codemp/game/g_combat.c:5823
func G_RadiusDamage(_ origin: inout JKAShared.vec3_t, _ attacker: Entity, _ damage: Float, _ radius: Float, _ ignore: Entity, _ missile: Entity, _ mod: Int32) -> Bool {
    // TODO: Port G_RadiusDamage
    portMissing("G_RadiusDamage", source: "oracle/codemp/game/g_combat.c:5823")
}
```

A function the table cannot shape yet keeps a marker that says why, `// No table row for `stringID_table_t * table``, until a ruling gives the table the row.

### The middle state

The generated signatures grew one ruling at a time, and the log of `table.py` shows the order: the skeleton and its first table, then the vector, axis, in-place string, and closure rows, then the `char *` rows, then the pointer to pointer, text cursor, function pointer, and matrix rows. Each ruling regenerated the whole tree and was read as output before it was committed, so a massive change is vetted step by step. The trust lands in the bodies, where a transcriptor fills the logic under the guide, and a Port-note marks every place Raven's C has no Swift form yet, an implicit cast, an out of bounds index, a struct on the stack.

## Ship targets

- **MP** (`jamp` engine): the game module `jampgame` first, then `cgame` and `ui`.
- **SP** (`jasp` engine): `jagame`, after MP.
- Windows builds are not exercised, and the pointer and layout choices may need work there.
