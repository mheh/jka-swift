# Docket proofs of rows A3 to A6 and B1 to B6

Each section proves one row of `frame-path-round.md` against the Swift hole sites, Raven's C, the jka-rust range of the manifest in the submodule `jka-rust/`, the lookup tool, the helpers of `JKAShared`, `JKAMP_Game`, and `JKAMP_BG`, and `docs/transcription.md`.
"Guide" means `docs/transcription.md`, and a bare line number is a line of that file.

### A3

**Sites.** `Sources/JKAMP_GameLogic/g_active.swift:531`, `// Raven wrote: if ( hit->s.eType != ET_TELEPORT_TRIGGER && ... hit->touch != Touch_DoorTrigger) { continue; }`, then `g_active.swift:532`, `portMissing("G_TouchTriggers", source: "oracle/codemp/game/g_active.c:516")`. The compiler said that `EntityTouch` cannot conform to `Equatable`.

**Raven.** A compare of a stored function with a named function occurs seven times in the game files. Six use `==`: `g_ICARUScb.c:584` and `:624`, `g_trigger.c:134` and `:540`, `g_utils.c:1829`, `g_misc.c:3403`. One uses `!=`: `g_active.c:557`, this site. jka-rust `g_active.rs:709` compares an enum, `touch.get() != Some(EntTouch::Touch_DoorTrigger)`.

**Types.** `lookup.py gentity_t touch` gives `touch: EntityTouch?`. `EntityTouch` is `@convention(c) (OpaquePointer?, OpaquePointer?, OpaquePointer?) -> Void` at `Sources/JKAMP_Game/Generated/Views/Callbacks.swift:17`. The thunk is `Touch.Touch_DoorTrigger` at `Sources/JKAMP_GameLogic/Generated/Callbacks.swift:455`.

**Helpers.** `Callbacks.swift:42` already defines `public func == (lhs: EntityTouch?, rhs: EntityTouch?) -> Bool`, an address compare. `views.py:644-663` writes one `==` per signature. No `!=` exists, so Swift tried the `Equatable` `!=` and failed. The six `==` sites compile today, for example `g_utils.swift:1659`, `if target!.touch == Touch.Touch_Button`.

**Guide.** No line gives the compare. Lines 501-508 give only the store, the clear, the call, and the NULL test.

**Verdict.** Premise amended: "The view target has an address `==` for each callback type, and no `!=`. Raven's one `!=` compare of a stored function has no spelling." Form replaced: `views.py` writes a `!=` beside each `==`, so the site reads as Raven wrote it. A generated `touchIs(...)` adds a second spelling for a test that `==` already does. Until the generator change, `!(a == b)` compiles with no new code.

```swift
if hit!.s.eType != ET_TELEPORT_TRIGGER &&
    // this is ugly but adding a new ET_? type will
    // most likely cause network incompatibilities
    hit!.touch != Touch.Touch_DoorTrigger {
    i += 1
    continue
}
```

**Shared ground.** J1, a function pointer in a local, reads the same callback types.

### A4

**Sites.** `g_active.swift:715`, `// Raven wrote: pm.baseEnt = (bgEntity_t *)g_entities`, and `:716`, `portMissing("SpectatorThink", source: "oracle/codemp/game/g_active.c:678")`. `g_active.swift:2626` with the same text, and `:2627`, `portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")`.

**Raven.** The cast of a table name to a view pointer occurs only at `g_active.c:710` and `:2986`. The one read is `bg_pmove.c:196`, `(bgEntity_t *)((byte *)pm->baseEnt + pm->entSize*(num))`, behind the NULL test at `:182`. In C, `g_entities` decays to `&g_entities[0]`. jka-rust `g_active.rs:933` and `:3149` write `g_entities.as_mut_ptr() as *mut _`, the base address.

**Types.** `lookup.py pmove_t baseEnt` gives `baseEnt: BgEntity?`. `g_entities` is `Slots<Entity>`. `BgEntity` has `init(_ other: some HandleView)`, and `Entity` is a `HandleView` (`Entity.swift:10`, `:22`). The bg read is `pm.entity(at:)` at `Sources/JKAMP/Generated/Views/Pmove.swift:65`, which adds `entSize * num` to the base.

**Helpers.** None is needed. `BgEntity(g_entities[0])` is the address of slot 0, the base Raven stores.

**Guide.** Line 323 gives `View(x)` for Raven's explicit cast of another struct's pointer. It does not say that a table name is the pointer to its slot 0. The transcriptor did not miss a line.

**Verdict.** Premise holds. Form confirmed: the cast of a table name is the view cast of line 323 over slot 0, because C's array name is the address of its first element. One sentence at line 323 covers it.

```swift
pm.baseEnt = BgEntity(g_entities[0])
```

**Shared ground.** None in the record.

### A5

**Sites.** `g_active.swift:718`, `// Raven wrote: pm.entSize = sizeof(gentity_t)`, and `:719`, `portMissing("SpectatorThink", source: "oracle/codemp/game/g_active.c:678")`. `g_active.swift:2629` and `:2630`, the same in `ClientThink_real`, `source: "oracle/codemp/game/g_active.c:1939"`.

**Raven.** A bare `sizeof(T)` stored as a value occurs at `g_active.c:711` and `:2987`. `g_main.c:997` and `g_utils.c:848` pass `sizeof( gentity_t )` to `trap_LocateGameData`, and the allocators take `sizeof(bot_state_t)` and the rest. jka-rust `g_active.rs:934` and `:3150` write `size_of::<gentity_t>() as c_int`, a cast.

**Types.** `lookup.py pmove_t entSize` gives `entSize: Int32`. `Entity.byteCount` is `MemoryLayout<gentity_t>.size`, an `Int`, at `Entity.swift:28`, and `Entity.stride` is `MemoryLayout<gentity_t>.stride` at `:31`.

**Helpers.** The compiled bodies already spell Raven's `sizeof(T)` into an `int` as `Int32(View.byteCount)` at ten sites: `g_main.swift:1081`, `g_utils.swift:469` and `:814`, `ai_main.swift:893`, `g_ICARUScb.swift:3178`, and five in `ai_wpnav.swift` (`:393`, `:420`, `:447`, `:627`, `:695`).

**Guide.** Line 319 names `byteCount` for a module that allocates its own slot. No line gives the store of `sizeof` into an `int`. Line 543 is the nearest shape, a conversion at the store.

**Verdict.** Premise amended: "The guide gives no form for `sizeof(T)` into an `int`, and ten compiled sites spell it `Int32(View.byteCount)`." Form replaced: a guide line names the compiled spelling, the mirror of line 543, and no view gains a new constant. C's `sizeof` is Swift's `stride`, and `size` differs only by tail padding. `gentity_t` ends on the pointer `item` (`g_local.h:359`), so the two are 1832 here (`CJKAMP_Game/layout_asserts.h:2129`).

```swift
pm.entSize = Int32(Entity.byteCount)
```

**Shared ground.** B4 and C1 read `sizeof` of an array, not of a type.

### A6

**Sites.** `g_active.swift:2572`, `// Raven wrote: pm.pmove_fixed = pmove_fixed.integer | client->pers.pmoveFixed`, and `:2573`, `portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")`.

**Raven.** `g_local.h:449` declares `qboolean pmoveFixed`. `g_client.c:2174` and `:2177` store `qfalse` and `qtrue`. `g_active.c:2107` tests it with `||`, and `g_active.c:2910` ORs it into an `int`. jka-rust `g_active.rs:3112` writes `pmove_fixed.integer | (*client).pers.pmoveFixed`, because its `qboolean` is a `c_int`.

**Types.** `lookup.py clientPersistant_t pmoveFixed` gives `pmoveFixed: Bool`. `lookup.py pmove_t pmove_fixed` gives `pmove_fixed: Int32`. `vmCvar_t.integer` is `Int32`.

**Helpers.** `Promotion.swift` has no `Bool` operator, and no `Int32(Bool)` initializer exists in the three modules. Compiled bodies already spell a `qboolean` as an `int` with `(b ? 1 : 0)`: `g_client.swift:2068`, `teamLeader = (client!.sess.teamLeader ? 1 : 0)` for Raven's `g_client.c:2184`, and the `vmMain` returns at `g_main.swift:586`, `:614`, `:761`.

**Guide.** No line gives it. Line 522 says only that `qboolean` is `Bool`.

**Verdict.** Premise holds. Form confirmed: a `qboolean` operand where C reads an `int` is `(b ? 1 : 0)`, the spelling of the compiled sites. One guide line closes this row and F1.

```swift
pm.pmove_fixed = pmove_fixed.integer | (client!.pers.pmoveFixed ? 1 : 0)
```

**Shared ground.** F1 is the same form. L3 proposes an operator for the same case. D1, D3, I1, and T3 are the reverse or the print of the same `Bool` and `int` boundary.

### B1

**Sites.** `g_client.swift:3241`, `// Raven wrote: ent->health = client->ps.stats[STAT_HEALTH] = client->ps.stats[STAT_MAX_HEALTH] = g_powerDuelStartHealth.integer - ((g_powerDuelStartHealth.integer - g_powerDuelEndHealth.integer) * (float)client->sess.wins / (float)g_duel_fraglimit.integer)`, and `:3242`, `portMissing("ClientSpawn", source: "oracle/codemp/game/g_client.c:2938")`.

**Raven.** `g_client.c:3635-3636`. C computes the right side in `float`, `int - float`, and the innermost store truncates to `int`. jka-rust `g_client.rs:2992-3000` computes one `f32` value, casts it once to `c_int`, and stores it three times.

**Types.** `lookup.py clientSession_t wins` gives `Int32`. `vmCvar_t.integer` is `Int32`. `ps.stats` elements and `ent.health` are `Int32`.

**Helpers.** The compiled body `w_saber.swift:2266-2269`, `G_SabCol_CalcPlaneEq`, already splits one expression into typed `let` terms under the comment "Raven's one expression is three terms here, because the compiler cannot type-check it whole in reasonable time." That fill came with the build of rulings R36 to R58, commit `201b92f`.

**Guide.** No line gives the split. Line 561 gives the chained store, inner first. Line 543 gives `Int32(...)` at the store of a `float`.

**Verdict.** Premise amended: "The guide has no form, and `w_saber.swift:2266` is a compiled precedent." Form confirmed with one addition: each term is a `let` of the type C computes it in, and the comment of the precedent names the split. The explicit `(float)` casts stay, and the Promotion operators promote the rest.

```swift
// Raven's one expression is two terms here, because the compiler cannot type-check it whole in reasonable time.
let healthSpan: Int32 = g_powerDuelStartHealth.integer - g_powerDuelEndHealth.integer
let healthLoss: Float = healthSpan * Float(client!.sess.wins) / Float(g_duel_fraglimit.integer)
client!.ps.stats[STAT_MAX_HEALTH] = Int32(g_powerDuelStartHealth.integer - healthLoss)
client!.ps.stats[STAT_HEALTH] = client!.ps.stats[STAT_MAX_HEALTH]
ent.health = client!.ps.stats[STAT_HEALTH]
```

**Shared ground.** N1 is the same `Int32(Float op Float)` store.

### B2

**Sites.** `g_cmds.swift:169`, `// Raven wrote: memcpy( line + len, arg, tlen )`, and `:170`, `portMissing("ConcatArgs", source: "oracle/codemp/game/g_cmds.c:127")`.

**Raven.** `memcpy` with a size other than `sizeof` occurs twice in the game files: `g_cmds.c:141`, this site, and `g_spawn.c:861`, the `l+1` case the guide already gives. At `:141`, `tlen` is `strlen(arg)`, so the copy writes no NUL. Every path overwrites `line[len]` after it: `line[len] = ' '` at `:144`, or `line[len] = 0` at `:149`. jka-rust `g_cmds.rs:208-230` builds a `String` with `push_str` and counts `tlen` in Latin-1 characters.

**Types.** `line` is the world `CharBuf(MAX_STRING_CHARS)` at `g_local.swift:142`, with the forward at `g_cmds.swift:24`. `arg` is a local `CharBuf(1024)`, and `tlen` and `len` are `Int32`.

**Helpers.** `strncpy(_ dest: inout CharBuf, _ source: String, _ n:, at offset:)` exists at `Sources/JKAShared/CString.swift:338`. With `n` equal to the source length it copies `n` bytes and writes no NUL, which is `memcpy` byte for byte. The proposed `strcpy(&line, arg, at: len)` does not compile today, because `strcpy` with `at:` takes only a `String` source (`CString.swift:183`). `String(arg)` gives back the same bytes, because `arg` holds the UTF-8 of the `String` that `trap_Argv` returned.

**Guide.** Line 644 gives only the `l+1` case. No line gives a copy of `strlen` bytes.

**Verdict.** Premise amended: "The guide has no form, and `strncpy` with `at:` already copies `strlen` bytes with no NUL." Form replaced: Raven's `memcpy(dest + off, src, strlen(src))` is `strncpy(&dest, String(src), len, at: off)`. This form writes exactly Raven's bytes, so it needs no proof that a later store covers an extra NUL.

```swift
strncpy(&line, String(arg), tlen, at: len)
```

**Shared ground.** L2 asks for an `at:` overload of `Com_sprintf`. O5 passes a pointer into a buffer.

### B3

**Sites.** `g_cmds.swift:198`, `// Raven wrote: while ( *in ) { ... *out++ = tolower( (unsigned char) *in++ ); }`, and `:199`, `portMissing("SanitizeString", source: "oracle/codemp/game/g_cmds.c:161")`.

**Raven.** `g_cmds.c:162-171`. `tolower` occurs here and at `q_shared.c:910`. `(unsigned char)` occurs only at `g_cmds.c:171`. The cast cannot change a value there, because the test `*in < 32` at `:166` on a signed `char` skips every byte of 0x80 or more. jka-rust `g_cmds.rs:237-261` walks the bytes, skips `(c as i8) < 32`, and lowercases with `to_ascii_lowercase`.

**Types.** `in` and `out` are `inout CharBuf` (`lookup.py sig SanitizeString`). The `CharBuf` subscript reads an `Int8` and sign-extends it, as C does (`CharBuf.swift:49-58`).

**Helpers.** `tolower(_ c: Int32) -> Int32` already exists at `Sources/JKAShared/CString.swift:468`, in the C locale, and `q_shared.c.swift:824` calls it. The premise that `tolower` has no home fails.

**Guide.** Line 641 lists the libc names of `CString.swift` and omits `tolower` and `toupper`. Lines 526-527 give `UInt8(truncatingIfNeeded:)`-style truncation for a narrow type, which spells `(unsigned char)`.

**Verdict.** Premise amended: "`tolower` is in `CString.swift:468`, and line 641 does not list it. The `(unsigned char)` cast has no listed spelling." Form amended: line 641 adds `tolower` and `toupper`, and `(unsigned char) c` is `Int32(UInt8(truncatingIfNeeded: c))`, as the transcriptor proposed. The loop is the pointer walk of line 613 with two `Int32` cursors.

```swift
var inIndex: Int32 = 0
while `in`[inIndex] != 0 {
    if `in`[inIndex] == 27 {
        inIndex += 2 // skip color code
        continue
    }
    if `in`[inIndex] < 32 {
        inIndex += 1
        continue
    }
    out[outIndex] = tolower(Int32(UInt8(truncatingIfNeeded: `in`[inIndex])))
    outIndex += 1
    inIndex += 1
}
```

**Shared ground.** R8 asks this loop to step `outIndex`. D4, O3, and Q1 are byte walks of other text shapes.

### B4

**Sites.** `g_cmds.swift:1756`, `// Raven wrote: if ( order < 0 || order > sizeof(gc_orders)/sizeof(char *) ) { return; }`, and `:1757`, `portMissing("Cmd_GameCommand_f", source: "oracle/codemp/game/g_cmds.c:1822")`.

**Raven.** `sizeof(table)/sizeof(elem)` occurs four times: `g_cmds.c:1835`, `g_combat.c:2527`, `g_main.c:478`, and `bg_misc.c:1771`. At `:1835` Raven's `>` lets `order == 7` read past the seven rows of `gc_orders` (`g_cmds.c:1810-1818`), so C reads out of bounds and the Swift `gc_orders[order]` traps. jka-rust `g_cmds.rs:2008-2011` changes the test to `>=` and notes the off-by-one.

**Types.** `gc_orders` is a hand `[String]` on `GameWorld` at `g_local.swift:115`, with the forward at `g_cmds.swift:31`. `order` is `Int32`.

**Helpers.** None is needed. Swift's heterogeneous `BinaryInteger` compare takes an `Int32` and an `Int`, and `g_spawn.swift:169`, `while sIndex < spawns.count`, compiles that form today. `gameCvarTableSize` at `g_main.swift:468` is a hand forward with `Int32(...)` for a name Raven declared, which is a different case.

**Guide.** No line gives the count of an array. Line 425 says `gameCvarTableSize` is the count of `gameCvarTable`.

**Verdict.** Premise holds. Form confirmed: `sizeof(t)/sizeof(t[0])` of a Swift array is `t.count`, compared with no cast. The user rules separately whether the site keeps Raven's `>` and its trap at 7, or takes jka-rust's `>=`.

```swift
if order < 0 || order > gc_orders.count {
    return
}
```

**Shared ground.** C1 is the same form for `modNames`.

### B5

**Sites.** `g_utils.swift:110`, `// Raven wrote: memset(buff, 0, MAX_STRING_CHARS)`, and `:111`, `portMissing("BuildShaderStateConfig", source: "oracle/codemp/game/g_utils.c:39")`.

**Raven.** `g_utils.c:40` declares `static char buff[MAX_STRING_CHARS*4]`, and `:44` zeroes the first quarter. It is the one `memset` in the game files with a partial size and no `sizeof`. The next `Q_strcat` appends at the first NUL, which is byte 0, so only that byte affects the result. jka-rust `g_utils.rs:95-113` drops the buffer, builds a `String`, and cuts it to `MAX_STRING_CHARS*4` bytes.

**Types.** `buff` is the world `CharBuf(MAX_STRING_CHARS * 4)` at `g_local.swift:781`, with the forward at `g_utils.swift:99`.

**Helpers.** `CharBuf` has only `zero()`, the whole buffer (`CharBuf.swift:71`). `strncpy(&buff, "", MAX_STRING_CHARS)` (`CString.swift:320`) pads N NUL bytes and gives Raven's bytes exactly, but it hides the `memset`.

**Guide.** Line 177 already names this exact call, `memset(buff, 0, MAX_STRING_CHARS)` of `BuildShaderStateConfig`, as a `memset` that keeps its Port-note. The transcriptor cited it, and the row asks to change that line.

**Verdict.** Premise amended: "Line 177 keeps this memset as a hole by name, and the row asks for a form in its place." Form confirmed: a `CharBuf` method `zero(count:)` beside `zero()`, and line 177 gives a `memset` of zero over the first N bytes of a `CharBuf` as that call. The value is zero only, because no other partial memset occurs.

```swift
buff.zero(count: MAX_STRING_CHARS)
```

**Shared ground.** O1 is a partial `memset` of the size of a pointer.

### B6

**Sites.** All in `vtos`, each `portMissing("vtos", source: "oracle/codemp/game/g_utils.c:653")`: `g_utils.swift:621`/`:622`, `static char str[8][32];`. `:624`/`:625`, `char *s;`. `:629`/`:630`, `s = str[index]`. `:634`/`:635`, `Com_sprintf (s, 32, "(%i %i %i)", (int)v[0], (int)v[1], (int)v[2])`. `:638`/`:639`, `return s`.

**Raven.** `g_utils.c:653-665`. A static `char [N][M]` ring occurs only here in the game files. The ring exists because C returns a pointer, so eight results stay valid in one `printf`. jka-rust `g_utils.rs:769-777` drops the ring, formats a `String`, and keeps the 31-byte bound of `Com_sprintf`.

**Types.** `vtos` returns `String` (`lookup.py sig vtos`). `index_vtos` is already a `GameWorld` property at `g_local.swift:785`, with the forward at `g_utils.swift:602`.

**Helpers.** None is needed. `Com_sprintf` takes an `inout CharBuf` and a size.

**Guide.** Lines 413-416 give the form for `va` and `Info_ValueForKey`: a ring of static buffers returned as a `String` is one local `CharBuf` of Raven's bound, and the index drops, because a returned `String` is already a copy. Lines 108 and 201 give the same for `tv`, whose Swift body at `g_utils.swift:596` has no ring and no index. Line 413 limits the text form to `JKAShared`, so the transcriptor read it as closed to the game module.

**Verdict.** Premise amended: "Lines 413-416 give the form for a ring returned as a `String`, and line 413 limits it to `JKAShared`." Form replaced: line 413 holds for any function that returns its ring as a `String`, so `vtos` takes a local `CharBuf(32)` and drops `str`, `s`, and `index`. A `[CharBuf]` on `GameWorld` keeps a state that no reader can see. `index_vtos` and its forward go with it.

```swift
func vtos(_ v: JKAShared.vec3_t) -> String {
    // Raven's ring of eight static buffers exists because C cannot return a string, and a returned String is already a copy.
    var s = CharBuf(32)
    Com_sprintf(&s, 32, "(%i %i %i)", Int32(v[0]), Int32(v[1]), Int32(v[2]))
    return String(s)
}
```

**Shared ground.** H3 and R4 write one row of a `char [N][M]` field, which is engine memory and keeps its rows.
