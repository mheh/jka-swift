# Struct views, the proposal for vet task 5

Written 2026-09-09. Five rows. Rules 3, 5, 7, 8, 9, 11, 12, and 13 already fix the outer shape: a view is a struct that holds the slot pointer, every field is a computed property with a `nonmutating` setter, one view type per file, the view target is the only importer of the C module, and the accessors are generated whole. The rows below are the mechanisms those rules leave open. Nothing is implemented until its row is ratified.

The evidence. `gentity_t` has about 154 fields: 69 `int`, 8 `float`, 9 `qboolean`, 30 `char *` plus one array of `char *`, 6 `vec3_t`, 3 `int` arrays, 2 nested structs by value, 10 pointers to `gentity_t`, one to `gclient_t`, 6 other pointers, one enum, and 7 function pointers. `gclient_t` adds four nested structs, an array of `saberInfo_t`, an array of `void *`, and one `char[MAX_QPATH]`. `level_locals_t` adds the two table base pointers, an array of entity pointers, four arrays of structs, five `char` arrays, and a two-dimensional `char *` array. `playerState_t` is plain data: no pointer, no string, one nested `forcedata_t`. None of the four holds a union or a bitfield.

## Row 1, the generated file and its names

A new generator, `tools/oracle-closure/views.py`, reads the merged headers with libclang, as `reexport.py` does, and writes one Swift file per view type under `Sources/<View target>/Generated/Views/<Name>.swift`. The roots are `gentity_t`, `gclient_t`, and `level_locals_t` in `JKAMP_Game`, and `playerState_t` in `JKAMP`. Every struct a root reaches by value, by array, or by pointer gets a view too, in the target that owns its header, so `entityState_t`, `entityShared_t`, `forcedata_t`, `saberInfo_t`, and `alertEvent_t` each get a file. The roots take the names rule 5 and the placeholder already use: `Entity`, `Client`, `Level`, `PlayerState`. Every other view takes Raven's typedef name with the `_t` dropped and the first letter raised: `EntityState`, `EntityShared`, `Forcedata`, `SaberInfo`, `AIGroupInfo`.

The file for `gentity_t`, `Sources/JKAMP_Game/Generated/Views/Entity.swift`, begins:

```swift
internal import CJKAMP_Game

/// Source: oracle/codemp/game/g_local.h:133
/// A view over one slot of the entity table.
/// Two views of one slot compare equal, and a copy of a view is a copy of the pointer.
public struct Entity: Hashable {
    let raw: UnsafeMutablePointer<gentity_t>

    /// Source: oracle/codemp/game/g_local.h:135
    public var s: EntityState { EntityState(raw: self.raw.pointer(to: \.s)!) }

    /// Source: oracle/codemp/game/g_local.h:157
    public var inuse: Bool {
        get { self.raw.pointee.inuse != qfalse }
        nonmutating set { self.raw.pointee.inuse = newValue ? qtrue : qfalse }
    }

    /// Source: oracle/codemp/game/g_local.h:279
    public var enemy: Entity? {
        get { self.raw.pointee.enemy.map { Entity(raw: $0) } }
        nonmutating set { self.raw.pointee.enemy = newValue?.raw }
    }
}
```

A nested struct by value is a view over the field's address, so its fields carry their own setters and the parent needs none. The initializer from the raw pointer is internal to the view target. A field the generator cannot map gets the rule 14 marker, `// TODO: Port <field>` above `// Raven wrote: <declaration>`, and the generator's report counts them.

## Row 2, the conversion table

One Swift form per C shape, applied by the generator with no per-field exceptions:

| Raven's C shape | Swift property type | The conversion |
|---|---|---|
| `int`, `float`, `unsigned` | `Int32`, `Float`, `UInt32` | none |
| scalar typedef, `material_t`, `fileHandle_t` | the re-exported typealias | none |
| `qboolean` | `Bool` | `!= qfalse` and `? qtrue : qfalse`, rule 7 |
| C enum, `moverState_t`, `class_t` | the re-exported struct | `rawValue` both ways |
| `vec3_t` | `vec3_t`, a `SIMD3<Float>` typealias in `JKAShared` | the imported tuple, both ways |
| `T[N]` of a scalar | `Slots<T>` | a view over the field's address and `N` |
| `T[N]` of a struct | `Slots<View>` | the same view, elements are views |
| `char[N]` | `String` | `String(cString:)` on read, `strncpy` to `N - 1` and a NUL on write |
| `char *` | `PooledString?` | row 3 |
| `struct S` by value | `View` | row 1 |
| `gentity_t *`, `gclient_t *`, any copied struct pointer | `Entity?`, `Client?`, `View?` | `map` both ways, rule 5 |
| `void *` | `OpaquePointer?` | none |
| function pointer | row 4 | |

`Slots` is one generic type in `JKAShared`, a view that holds a base pointer and a count, conforms to `RandomAccessCollection`, and gives each element a getter and a `nonmutating` setter, so `client.ps.stats[STAT_HEALTH] = 100` reads as Raven wrote it. A two-dimensional array, `spawnVars[MAX_SPAWN_VARS][2]` and `teamVoteString[2][MAX_STRING_CHARS]`, is `Slots` of `Slots`. Every view conforms to `Hashable` by its pointer.

`spawnflags` stays `Int32` in the view. Each Raven file that defines spawn flag macros gets an `OptionSet` in the logic target with idiomatic member names and a `/// Raven:` line per member, where every member reads its re-exported C macro and no member is a literal, which means the type generator also copies the macros a `.c` file defines for itself. Each such class gets an `Entity` extension property. A bit Raven read as a bare literal stays a bare literal on the `Int32` field in the ported body.

```swift
/// Source: oracle/codemp/game/g_mover.c:27
public struct MoverSpawnFlags: OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }
    /// Raven: `MOVER_LOCKED`.
    public static let locked = MoverSpawnFlags(rawValue: MOVER_LOCKED)
}

extension Entity {
    var moverSpawnflags: MoverSpawnFlags {
        get { MoverSpawnFlags(rawValue: self.spawnflags) }
        nonmutating set { self.spawnflags = newValue.rawValue }
    }
}
```

## Row 3, the strings

Rule 9 says the world owns a string pool that hands out stable C pointers for the `char *` fields. The pool is `StringPool`, a final class in `JKAMP_Game`, because the view target is the memory side and the world holds one as a stored property. `intern(_:)` copies a Swift string into pool memory once per distinct text and returns a `PooledString`, a struct over the C pointer that reads back as `.string`, compares to a Swift string with `==`, and never frees. `PooledString` also adopts `ExpressibleByStringLiteral` over `StaticString`, so a literal assigns directly as a pointer into the binary's read-only data, as Raven's literals were, and a runtime string reaches a field only through the pool. A `char *` field is `PooledString?` in both directions, so a field only ever holds a literal, a pool pointer, a pointer copied from another field, or `nil`. `PooledString` has no mutating API and its initializer from a pointer is internal to the view target. Raven's `char *` has no length, so `PooledString` has none. The `char[N]` fields carry the only bound, in the row 2 table.

```swift
// Raven: ent->classname = "noclass";
ent.classname = "noclass"

// Raven: ent->roffname = G_NewString( name );
ent.roffname = strings.intern(name)

// Raven: if (!strcmp(ent->classname, "noclass"))
if ent.classname == "noclass"
```

`strings` is the world's pool through a computed property in `g_local.swift`, as every Raven global is. A logic target sees `PooledString` and `StringPool` and no `CChar` pointer.

## Row 4, the function pointer fields

Ratified as replaced, 2026-09-09. The proposal as first written kept the C shape for the stored functions themselves, and that contradicted rule 5 and rule 13, which give every ported function Raven's signature. The ruling: the stored function keeps Raven's signature, `func G_ExplodeMissile(_ ent: Entity)`, and the field keeps Raven's type, so identity is the C address as Raven had it.

The generator writes one public typealias per distinct signature in `JKAMP_Game`, with `OpaquePointer?` for each `gentity_t *` and `trace_t *`, and an `==` per typealias by a boxed word read, because a C function pointer is one word, the code address. The pointer is read from a struct and never passed to a generic, so no reabstraction thunk can change the word, as NIOSSL's `ClosureBits` in `TLSConfiguration.swift` does:

```swift
public typealias EntityThink = @convention(c) (OpaquePointer?) -> Void
private struct EntityThinkBits { var function: EntityThink? }
public func == (lhs: EntityThink?, rhs: EntityThink?) -> Bool {
    precondition(MemoryLayout<EntityThinkBits>.size == MemoryLayout<UInt>.size)
    return withUnsafeBytes(of: EntityThinkBits(function: lhs)) { $0.load(as: UInt.self) }
        == withUnsafeBytes(of: EntityThinkBits(function: rhs)) { $0.load(as: UInt.self) }
}
```

The skeleton generator reads every site where the oracle stores a function in one of the seven fields and writes one namespace per field in the logic target, with one static thunk per function, named as the function and calling it with the module qualifier. Each static holds one closure, so one function has one address for the life of the module, which is C's guarantee:

```swift
public enum Think {
    /// Source: oracle/codemp/game/g_missile.c:215
    public static let G_ExplodeMissile: EntityThink = { JKAMP_GameLogic.G_ExplodeMissile(Entity(handle: $0!)) }
}
```

The three operations then read as Raven wrote them, and the call goes through the C pointer as Raven's did, so `G_FreeEntity`'s `memset` clears it and no dispatch table exists:

```swift
ent.think = Think.G_ExplodeMissile
if ent.think == Think.G_FreeEntity
ent.runThink()
```

`runThink` and the other six calls are view-target methods that pass the slot pointer as the handle. `Entity.init(handle:)` is public and appears only in generated thunks, so rule 11's handle exception narrows to generated code. Proved in a playground and as a two-module build, debug and release: store, call, compare, and a `nil` read after a zero store all match C.

The delta. jka-rust replaced these fields with an ID enum and a central `match`. This port keeps Raven's mechanism end to end, so the referee sees the same call path.

Rules 3, 8, and 11 carry the old exception in their text and need amended sentences. That is a ledger row of its own at the end of the walk.

## Row 5, the tables and the level

Rule 3 says the entity and client tables are C memory the world owns, with Raven's stride. `GameMemory`, a final class in `JKAMP_Game`, allocates `gentity_t[MAX_GENTITIES]`, `gclient_t[MAX_CLIENTS]`, and one `level_locals_t`, zeroed as Raven's statics were, and frees them in `deinit`. It exposes `entities: Slots<Entity>`, `clients: Slots<Client>`, and `level: Level`, and it is the only place a table is allocated. The world holds one `GameMemory`, and `g_entities`, `level`, and `g_clients` are computed properties over it, so `g_entities[i]` is an `Entity` and `level.time` is an `Int32`. `Level.gentities` and `Level.clients`, the base pointer fields, are `Slots<Entity>` and `Slots<Client>` over the pointer and `level.num_entities` or `level.maxclients`, and `G_InitGame` sets them from `GameMemory` as Raven set them from the statics. The typed trap `trap_LocateGameData` takes `Slots<Entity>`, the count, and `Slots<Client>`, and packs the base words and strides in the view target.

No guard slot precedes element 0. Raven's `g_entities` is a plain static array, and the referee will show a read of slot -1 if the engine makes one.

## Ledger

- Row 1, the generated file and its names: ratified as proposed, 2026-09-09.
- Row 2, the conversion table: ratified with the spawnflags sentence, an `OptionSet` per Raven file whose members read re-exported C macros and never a literal, and the type generator copies a `.c` file's own macros, 2026-09-09.
- Row 3, the strings: ratified as amended, a literal assigns as a `StaticString` pointer and a runtime string goes through the pool, 2026-09-09.
- Row 4, the function pointer fields: replaced. The stored function keeps Raven's Swift signature, the field keeps Raven's C type, one generated static thunk per function in a per-field namespace gives the address identity, `==` compares addresses, the call goes through the pointer. 2026-09-09. Amended 2026-09-09: `==` reads the address from a box, not through `unsafeBitCast`, after the NIOSSL `ClosureBits` precedent.
- Row 5, the tables and the level: ratified as proposed, 2026-09-09.
- Row 6, rules 3, 8, and 11 wording for the stored functions: ratified as proposed, 2026-09-09.
