# Docket proofs of rows E1 to E5, F1 to F4, and G1

Each section proves one row of `frame-path-round.md` against the Swift holes, Raven's C, the jka-rust range of the manifest, the views, the helpers, and `docs/transcription.md`. A line number is a line of the file named, read on wave-0 at 3f2a965.

### E1

**Sites.** Six holes in `Sources/JKAMP_GameLogic/w_saber.swift`, `SetSaberBoxSize`, each with `portMissing("SetSaberBoxSize", source: "oracle/codemp/game/w_saber.c:376")` on the line after the `// Raven wrote:` line: 459/460 `qboolean alwaysBlock[MAX_SABERS][MAX_BLADES];`, 489/490 `alwaysBlock[i][j] = qfalse`, 498/499 `alwaysBlock[i][j] = qtrue`, 509/510 `alwaysBlock[i][j] = qtrue`, 514/515 `alwaysBlock[i][j] = qfalse`, 596/597 `if ( !alwaysBlock[j][k] ) {... continue; }`.

**Raven.** `oracle/codemp/game/w_saber.c:384` declares the local with no initializer. Stores at 420, 429, 439, 444, all in the broken-parry arm. The one read is 530, under `if ( forceBlock )`. A slot that no store set can be read at 530 when saber 0 has no `SFL2_ALWAYS_BLOCK` flag and saber 1 sets `forceBlock`, so C reads stack garbage there. It is the only two-dimensional scalar local of the game files beside the four `float m[3][3]` of `q_math.c:407-411`. jka-rust `crates/mp/game/src/w_saber.rs:567` writes `let mut alwaysBlock = [[qfalse; MAX_BLADES as usize]; MAX_SABERS as usize];`, a zero fill.

**Types.** `qboolean` is `Bool` (lookup). `MAX_SABERS` and `MAX_BLADES` are the `CJKAShared` imports at `Sources/JKAShared/Generated/q_shared.swift:368` and `:204`.

**Helpers.** `Array.init(repeating:count:)` with a C integer count is at `Sources/JKAShared/Views/Int32Indexing.swift:48`, and the `Array` subscript of any C integer is at `:26`. The precedent is `RotatePointAroundVector`, `Sources/JKAShared/q_math.swift:306`, `[[Float]](repeating: [Float](repeating: 0, count: 3), count: 3)`. No helper closes the declaration hole by itself.

**Guide.** No form for a local scalar array of two dimensions. Line 174 covers `fill(0)` over a file-scope two-dimensional array only. Line 112 gives the one-dimension local `[Entity?](repeating: nil, count: Int(MAX_GENTITIES))`, with an `Int(...)` that the overload at `Int32Indexing.swift:48` makes needless.

**Verdict.** Premise holds. Form amended: drop the two `Int(...)` casts, because the C integer overload takes the constant as it stands. The zero fill changes only the garbage read that C has at line 530. The read at 596 sits inside the `k` loop, so its `continue` runs the step first under guide line 593. No other row shares the ground. B6 and H3 are two-dimensional `char` arrays, a different form.

```swift
var alwaysBlock = [[Bool]](repeating: [Bool](repeating: false, count: MAX_BLADES), count: MAX_SABERS)
...
alwaysBlock[i][j] = false
...
if !alwaysBlock[j][k] {
    //this blade shouldn't be blocking
    k += 1
    continue
}
```

### E2

**Sites.** `Sources/JKAMP_GameLogic/w_saber.swift:873` `// Raven wrote: if( VectorCompare( oldLookAngles, lookAngles ) == qfalse ) {... lookAngles[YAW] = oldLookAngles[YAW]+(lookAngles[YAW]-oldLookAngles[YAW])*0.4f; }`, and 874 `portMissing("G_G2NPCAngles", source: "oracle/codemp/game/w_saber.c:732")`. The note quotes the compiler, `binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'`.

**Raven.** `oracle/codemp/game/w_saber.c:843`. `VectorCompare` returns `int` at `q_shared.h:1453`, the `static ID_INLINE` twin the native build takes, and at `q_math.c:141`. This is Raven's one `== qfalse` on `VectorCompare`. The game files hold nine holes of one ground, an integer compared with `qfalse`: this one, five in `g_nav.swift` (Raven wrote at 349, 519, 794, 807, 978, on `byte` trace fields), two in `NPC_combat.swift` (2232, 2502), and one in `g_ICARUScb.swift` (1849). jka-rust `w_saber.rs:1026` writes `if !VectorCompare(oldLookAngles, lookAngles)`, because its `VectorCompare` returns `bool`.

**Types.** `public func VectorCompare(_ v1: vec3_t, _ v2: vec3_t) -> Int32` at `Sources/JKAShared/q_math.swift:1336`. The drafter writes `qfalse` as `false` (`tools/oracle-closure/draft_expressions.py:663`), so the compare is `Int32 == Bool`.

**Helpers.** `Promotion.swift` has `==` between `Int32` and `Float` only. No `Int32 == Bool` operator exists in `JKAShared`, `JKAMP_Game`, or `JKAMP_BG`.

**Guide.** No form. Line 522 says `qboolean` is `Bool`, and line 531 says a C enum case is a bare `Int32` constant, but `qfalse` is drafted as `false`, so neither line reaches this compare. The drafter already writes Raven's `!VectorCompare(...)` as `VectorCompare(...) == 0`, `g_combat.swift:103`.

**Verdict.** Premise holds. Form confirmed: the value of the constant, `== 0` for `qfalse` and `== 1` for `qtrue`, with no comment line, the same text the drafter gives for `!x`. H2 asks for one comment line that names the constant. One ruling must pick one of the two, and this record proposes no comment, because `== 0` already reads as Raven's test. Same ground as H2, P1, and T2, nine holes in all.

```swift
if VectorCompare(oldLookAngles, lookAngles) == 0 {
```

### E3

**Sites.** `Sources/JKAMP_GameLogic/w_saber.swift:1010` `// Port-note: Raven passes the `let` vector `vec3_origin` to `desiredPos`, which BG_IK_MoveArm takes by reference, so the body passes a scratch copy until a ruling reads that write.`, 1011 `portMissing("G_G2PlayerAngles", source: "oracle/codemp/game/w_saber.c:881")`, then the copy `var originPos = vec3_origin` at 1012 and the call at 1013. No `// Raven wrote:` line, because the call itself is filled.

**Raven.** The call is `oracle/codemp/game/w_saber.c:1001-1002`, `BG_IK_MoveArm(..., vec3_origin, &ent->client->ikStatus, ..., 500, qtrue)`. `BG_IK_MoveArm` is in `bg_pmove.c:8576-8730`, not `bg_panimate.c`. It declares `vec3_t desiredPos` with no `const`. Its only two uses are reads, `VectorCopy(desiredPos, ikM.desiredOrigin)` at 8650 and `VectorSubtract(lHand, desiredPos, torg)` at 8661. Both sit under `if (*ikInProgress && !forceHalt)` at 8643, so the `qtrue` call reads nothing either. **The callee never writes `desiredPos` on any path.** `origin`, `angles`, and `scale` are read only too. The other callers are `w_saber.c:982` and `cg_players.c:4270, 4276`. jka-rust `crates/mp/bg/src/bg_pmove.rs:8544` takes `desiredPos: vec3_t` by value, and `w_saber.rs:1265` passes `vec3_origin` directly.

**Types.** `sig BG_IK_MoveArm` gives `_ desiredPos: inout JKAShared.vec3_t`, from guide line 91, a non-const `vec3_t` is `inout`. The Swift body reads it at `Sources/JKAMP_BG/bg_pmove.swift:7336` and `:7348` only.

**Helpers.** None needed. No by-value overload of `BG_IK_MoveArm` exists.

**Guide.** Lines 228-229 are the form. Line 228 keeps the note and the marker until the callee's write is read, and line 229 gives `G_Damage` the one-line comment. This record is that read.

**Verdict.** Premise holds. Form confirmed: the copy stays, under one comment line, with no note and no marker, as line 229 gives for `G_Damage`. A PARAMS row in `rulings.py` that makes `desiredPos`, `origin`, `angles`, and `scale` by value would remove the copy, but it changes a signature, so it belongs to a generator round. No other row shares the ground.

```swift
// BG_IK_MoveArm only reads `desiredPos`, so the copy of `vec3_origin` is never written.
var originPos = vec3_origin
BG_IK_MoveArm(ent.ghoul2, lHandBolt, level.time, ent.s, ent.client!.ps.torsoAnim/*BOTH_DEAD1*/, &originPos, &ent.client!.ikStatus, &ent.client!.ps.origin, &ent.client!.ps.viewangles, &ent.modelScale, 500, true)
```

### E4

**Sites.** 22 holes in `Sources/JKAMP_GameLogic/w_saber.swift`, `G_BuildSaberFaces`, each with `portMissing("G_BuildSaberFaces", source: "oracle/codemp/game/w_saber.c:2454")` on the line after the `// Raven wrote:` line. Declarations at 2103 `float *d1 = NULL;` and 2106 `d2 = NULL;`. Stores at 2125, 2128, 2133, 2136, 2141, 2144, 2149, 2152, such as `d1 = &fwd[0]`. Reads at 2158, 2161, 2165, 2168, 2172, 2175, 2182, 2185, 2189, 2192, 2196, 2199, such as `VectorMA(base, radius/2.0f, d1, faces[i].v1)`.

**Raven.** `oracle/codemp/game/w_saber.c:2459` declares the two pointers. Each store at 2473 to 2489 is `&v[0]` of `fwd`, `right`, `invFwd`, or `invRight`, and the `if` chain sets both pointers on every pass, because `i < 8` always meets one arm. Each use at 2493 to 2511 is the read operand of `VectorMA`. No statement writes the four vectors inside the loop, and the body never writes `fwd` or `right` at all. It is the only `float *` local over a vector in the game files. `PM_Friction`'s `float *vel` of `bg_pmove.c:1000` writes through its target, so it is a different shape. jka-rust `w_saber.rs:3078` writes `let (d1, d2): (vec3_t, vec3_t) = if i < 2 { (fwd, invRight) } ...`, value copies.

**Types.** `vec3_t` is `SIMD3<Float>`. `_VectorMA(_ veca: vec3_t, _ scale: Float, _ vecb: vec3_t, _ vecc: inout vec3_t)` reads `vecb` by value.

**Helpers.** None needed. A `vec3_t` local is a plain value.

**Guide.** No form for a local. Line 96 gives a `float *` parameter Raven fills as `inout vec3_t`, and line 184 gives a pointer-to-vector parameter as `inout`. Both are parameters.

**Verdict.** Premise holds. Form confirmed, with its condition as written: every store is `&v[0]` of a vector, every use reads, and no statement writes the vector between the store and the last read. The NULL initializer is `vec3_t()`, which no read sees. The two lines `var fwd = fwd` and `var right = right` at 2111 and 2113 exist only because the draft read `&fwd[0]` as a write. Under this form nothing writes the parameters, so the copies can drop. No other row shares the ground.

```swift
var d1 = vec3_t()
var d2 = vec3_t()
...
d1 = fwd
d2 = invRight
...
_VectorMA(base, radius / 2.0, d1, &faces[i].v1)
```

### E5

**Sites.** `Sources/JKAMP_GameLogic/w_saber.swift:4870` `// Raven wrote: if ( dist < ent->splashRadius && ent->nextthink < level.time + 600 && ent->count && self->client->ps.groundEntityNum != ENTITYNUM_NONE && (ent->s.pos.trType == TR_STATIONARY|| ent->s.pos.trType == TR_INTERPOLATE|| (dot1 = DotProduct( dir, forward )) < SABER_REFLECT_MISSILE_CONE|| !WP_ForcePowerUsable( self, FP_PUSH )) ) {...} else if ( self->client->NPC_class != CLASS_BOBAFETT ) {... ForceThrow( self, qfalse ); }`, and 4871 `portMissing("WP_SaberStartMissileBlockCheck", source: "oracle/codemp/game/w_saber.c:5492")`.

**Raven.** `oracle/codemp/game/w_saber.c:5504` declares `float dot1, dot2;`. The store inside `||` is at 5693. The only other store is 5769, `if ( (dot1 = DotProduct( dir, forward )) < SABER_REFLECT_MISSILE_CONE )`. **Both stores are read on the next line, by the `<` test that holds the store, so the compiler reports nothing.** The block of 5693 ends in `continue` at 5703, and 5752 writes the same test with no store. The only other store inside the right side of `&&` or `||` in the game files is `bg_lib.c:136` and `:144`, inside `while` tests of `qsort`. jka-rust `w_saber.rs:6759` writes `|| _DotProduct(dir, forward) < SABER_REFLECT_MISSILE_CONE` and drops `dot1`.

**Types.** `dot1` is `var dot1: Float = 0` at `w_saber.swift:4694`. `SABER_REFLECT_MISSILE_CONE` is the `CJKAMP` import of `0.2f`, a `Float`. `WP_ForcePowerUsable` returns `Bool`.

**Helpers.** None applies.

**Guide.** Line 588 keeps the hole on purpose: a store inside the right side of `&&` or `||` runs at the wrong time on a line before the statement.

**Verdict.** Premise holds. Form amended to give the shape exactly. The `&&` operands before the parenthesized `||` group become the `if` that guards the flag, and the flag takes each `||` operand in turn, so the store runs only when C evaluates it. The form keeps Raven's dead store, as jka-rust did not. A ruling may instead drop a store that no statement reads, but that rule is wider than this one site, so this record does not propose it. No other row shares the ground.

```swift
var jump = false
if dist < ent!.splashRadius && ent!.nextthink < level.time + 600 && ent!.count != 0 && `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE {
    jump = ent!.s.pos.trType == TR_STATIONARY || ent!.s.pos.trType == TR_INTERPOLATE
    if !jump {
        dot1 = _DotProduct(dir, forward)
        jump = dot1 < SABER_REFLECT_MISSILE_CONE
    }
    if !jump {
        jump = !WP_ForcePowerUsable(`self`, FP_PUSH)
    }
}
if jump {
    `self`.client!.ps.fd.forceJumpCharge = 480
} else if `self`.client!.NPC_class != CLASS_BOBAFETT {
    ForceThrow(`self`, false)
}
```

### F1

**Sites.** `Sources/JKAMP_GameLogic/g_items.swift:415` `// Raven wrote: paramData = (xaxis << 24) | (height << 16) | (posWidth << 8) | (negWidth)`, and 416 `portMissing("CreateShield", source: "oracle/codemp/game/g_items.c:254")`. The note quotes the compiler, `cannot convert value of type 'Bool' to expected argument type 'Int32'`.

**Raven.** `oracle/codemp/game/g_items.c:259` declares `qboolean xaxis;`. It is stored at 279 and 285 as `qfalse` and `qtrue`, tested at 300 and 311 as a truth value, and shifted as an integer at 330. **Raven declares a `qboolean` and uses it once as an `int`.** `q_shared.h:353-355` makes `qboolean` an `int` under the macro, so C shifts 0 or 1. jka-rust `g_items.rs:512` writes `(xaxis << 24)`, because its `qboolean` is `c_int`.

**Types.** `qboolean` is `Bool`. `var xaxis: Bool = false` at `g_items.swift:352`, and `height`, `posWidth`, `negWidth`, and `paramData` are `Int32` at 348 to 353.

**Helpers.** No `<<`, `|`, or `+` between `Bool` and `Int32` exists in `Promotion.swift` or anywhere in `JKAShared`, `JKAMP_Game`, or `JKAMP_BG`. No `Int32(Bool)` initializer exists.

**Guide.** No form. Line 522 maps `qboolean` to `Bool`, and no line gives a `Bool` in integer arithmetic.

**Verdict.** Premise holds. Form confirmed: `(xaxis ? 1 : 0)`, which the type checker reads as `Int32` from the `|` beside it. The form is C's promotion spelled out, the same kind of conversion line 542 allows for `Double`. Same ground as A6 (`pmove_fixed.integer | pmoveFixed`) and L3 (`isfog += G_SpawnVector(...)`, which proposes an operator instead), and near D1 and D3. One ruling picks the inline form or a `Promotion.swift` operator for all three.

```swift
paramData = ((xaxis ? 1 : 0) << 24) | (height << 16) | (posWidth << 8) | (negWidth)
```

### F2

**Sites.** Seven holes in `Sources/JKAMP_GameLogic/g_items.swift`, `EWeb_SetBoneAngles`, each with `portMissing("EWeb_SetBoneAngles", source: "oracle/codemp/game/g_items.c:1499")` on the next line: 1457 `int *thebone = &ent->s.boneIndex1;`, 1460 `int *firstFree = NULL;`, 1469 `vec3_t *boneVector = &ent->s.boneAngles1;`, 1472 `vec3_t *freeBoneVec = NULL;`, 1476 `while (thebone) {...}`, 1480 `if (!thebone) {...}`, 1488 `VectorCopy(angles, *boneVector)`.

**Raven.** `oracle/codemp/game/g_items.c:1505-1512` declares the four pointers. The walk at 1514 steps `thebone` and `boneVector` together through a `switch (i)` to fields 2, 3, 4, then NULL. `firstFree` and `freeBoneVec` take one slot together at 1518-1519. The write through `thebone` is 1562, and the write through `boneVector` is 1570. The same shape is in `NPC_utils.c:912-977` (row J5) and `g_turret_G2.c:30-95` (row Q2), and nowhere else. jka-rust `g_items.rs:1940-2025` uses `Option<usize>` slots 0 to 3 and a `match` per field set.

**Types.** `lookup entityState_t boneIndex1` gives `boneIndex1: Int32`, and `boneAngles1` gives `boneAngles1: JKAShared.vec3_t`, on the view `JKAMP.EntityState`.

**Helpers.** No accessor by slot number exists for `boneIndexN` or `boneAnglesN` in `JKAShared`, `JKAMP_Game`, `JKAMP_BG`, or `JKAMP`.

**Guide.** No form. Lines 370-395 cover a pointer to a chosen file-scope variable only, and line 431 covers a record pointer over slots of one table.

**Verdict.** Premise holds. Form amended: one public hand extension on `EntityState` in the `JKAMP` target, `boneIndex(_:)`, `setBoneIndex(_:_:)`, and `setBoneAngles(_:_:)` by slot 1 to 4 through a `switch`, which F2, J5, and Q2 share. Three private copies, as J5 proposes, and Q2's 0 to 3 with -1 for NULL, would give three spellings of one shape. Each pointer local is an `Int32?`, 1 to 4, and `nil` is Raven's NULL.

```swift
var thebone: Int32? = 1
var boneVector: Int32? = 1
...
ent.s.setBoneAngles(boneVector!, angles)
```

### F3

**Sites.** `Sources/JKAMP_GameLogic/g_items.swift:1947` `// Raven wrote: for ( i = 0 ; i < level.maxclients ; i++ ) { vec3_t delta; float len; vec3_t forward; trace_t tr; client = &level.clients[i]; if ( client == other->client ) { continue; } ...`, and 1948 `portMissing("Pickup_Powerup", source: "oracle/codemp/game/g_items.c:2024")`. The note says the block leaves a loop outside the record's scope.

**Raven.** `oracle/codemp/game/g_items.c:2054-2097`. The `for` body declares `trace_t tr` with three other locals and holds seven `continue` statements. The body has no `break` and no `return`. jka-rust `g_items.rs:2715-2776` declares `tr` zeroed inside the loop at 2762, and its `continue` is Rust's.

**Types.** `Trace.scratch<Result>(_ body: (Trace) throws -> Result)` at `Sources/JKAMP/Generated/Views/Trace.swift:33`. `trap_Trace(_ results: JKAMP.Trace, ...)` at `Sources/JKAMP_Game/Generated/g_syscalls.swift:253`. `level.clientsSlots` reads the pointer field.

**Helpers.** None. The `scratch` closure is the only home of the record.

**Guide.** Lines 346-367 give the closure and say a `return` inside Raven's block is the closure's value. Lines 592-593 give the step and the `continue`. No line puts a `continue` inside the closure.

**Verdict.** Premise holds. Form confirmed: when the record block is the whole loop body, the closure opens inside the loop, each `continue` is a `return` from the closure, and the step follows the closure, so a `continue` runs the step as C does. The form holds only where the body holds no `break` and no `return` of Raven's. Same ground as M3 and Q3, and I3 adds the `break` case.

```swift
i = 0
while i < level.maxclients {
    Trace.scratch { tr in
        var delta = vec3_t()
        ...
        client = level.clientsSlots[i]
        ...
        trap_Trace(tr, client!.ps.origin, vec3_origin, vec3_origin, ent.s.pos.trBase, ENTITYNUM_NONE, CONTENTS_SOLID)
        if tr.fraction != 1.0 { return }
        client!.ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_DENIEDREWARD
    }
    i += 1
}
```

### F4

**Sites.** `Sources/JKAMP_GameLogic/g_items.swift:2135` `// Raven wrote: ent = ent->teamchain`, and 2136 `portMissing("RespawnItem", source: "oracle/codemp/game/g_items.c:2288")`, inside the draft's `while true` at 2132.

**Raven.** `oracle/codemp/game/g_items.c:2300` `for (count = 0, ent = master; ent; ent = ent->teamchain, count++) ;` counts the chain and leaves `ent` NULL. The next statement that reads `ent` is the store `ent = master` of the second loop at 2304, so no read sees the NULL. Raven's other walks to NULL over `teamchain` use a local pointer, `g_mover.c:427, 444, 460, 519, 603, 1177, 1187`, and the Swift port gives them an optional local, `while part != nil { ...; part = part!.teamchain }` at `g_mover.swift:481-494`. jka-rust `g_items.rs:3030-3034` walks a separate `Option` local `e`.

**Types.** The parameter is `_ ent: Entity`, and the body copies it to `var ent = ent` at `g_items.swift:2119`. `master` is `Entity?`, and `teamchain` is `Entity?`.

**Helpers.** None applies.

**Guide.** Line 336 gives `ent = master!`, but a force unwrap of `teamchain` traps at the end of the chain, where C does not read through the pointer. No line covers a non-optional variable that a loop runs to NULL.

**Verdict.** Premise holds. Form amended: the walk local takes the shape of `g_mover.swift:481`, `while x != nil`, and a name that keeps Raven's, such as `entWalk`. The draft's `ent = master!` before the loop drops, because the walk local takes that store. The form holds only where no statement reads the variable's NULL value before its next store. No other row shares the ground.

```swift
count = 0
var entWalk: Entity? = master
while entWalk != nil {
    entWalk = entWalk!.teamchain
    count += 1
}
```

### G1

**Sites.** Two holes in `Sources/JKAMP_GameLogic/NPC_utils.swift`, `G_ActivateBehavior`: 666 `// Raven wrote: bSID = (bState_t)(GetIDForString( BSTable, bs_name ))` with 667 `portMissing("G_ActivateBehavior", source: "oracle/codemp/game/NPC_utils.c:851")`, and 683 `// Raven wrote: G_DebugPrint( WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", self->targetname, GetStringForID( BSETTable, bset ), bs_name )` with 684 the same marker. Each note says Swift holds one record where the callee takes a `Slots`.

**Raven.** `oracle/codemp/game/NPC_utils.c:854` declares `char *bs_name = NULL`, and 861 stores `self->behaviorSet[bset]`. Lines 849-850 declare `extern stringID_table_t BSTable[]` and `BSETTable[]`, arrays of records, and `NPC_stats.c:88` and `:106` define them. `g_ICARUScb.c:17` has the same `extern`. jka-rust `NPC_utils.rs:693` reads `behavior_set_str(bset)` into a local, and `:702` passes `BSTable.as_ptr()`.

**Types.** `lookup gentity_t behaviorSet` gives `behaviorSet: Slots<String?>`. `sig GetIDForString` gives `(_ table: Slots<JKAShared.StringIDTable>, _ string: String) -> Int32`, and `sig GetStringForID` gives `(_ table: Slots<...>, _ id: Int32) -> String?`.

**Helpers.** `BSTable` and `BSETTable` are already `public let ...: Slots<StringIDTable>` at `Sources/JKAMP_Game/GameTables.swift:18` and `:22`. No local in `NPC_utils.swift` hides them. `g_ICARUScb.swift:2126, 2237, 2285` compile `GetIDForString(BSTable, bs_name)` today. The `String?` overload of `VALIDSTRING` is at `Sources/JKAShared/q_shared.h.swift:23`.

**Guide.** Line 496 gives a `char *` field as `String?`, and wave 2A filled the local as `var bs_name: String? = nil` at 655. Line 337 gives `?? ""` for a `String?` that `G_DebugPrint` reads under its own runtime test.

**Verdict.** Premise fails. The `bs_name` local has its form and is filled. The two holes are the same two holes J4 names, so J4 supersedes G1 on the same sites. J4's premise also fails, because the two tables already reach the body as `Slots<StringIDTable>`. The notes came from the drafter's reading of the `extern` at line 849, not from Swift. Form replaced: fill both holes now with the existing forwards, and close G1 and J4 with no guide line.

```swift
bSID = bState_t(GetIDForString(BSTable, bs_name!))
...
G_DebugPrint(WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", `self`.targetname ?? "", GetStringForID(BSETTable, bset) ?? "", bs_name ?? "")
```
