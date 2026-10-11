# Docket proofs: rows L1 to O5

This record proves the premise and the proposed form of rows L1, L2, L3, M1, M2, M3, N1, O1, O2, O3, O4, and O5 of `frame-path-round.md`. Each section gives the hole sites, Raven's uses, the Swift types, the helpers that exist, the guide lines, and the verdict. A line number in `docs/transcription.md` is "guide N".

### L1

**Sites.** Six Port-notes in `Sources/JKAMP_GameLogic/g_svcmds.swift`, each with the text "A pointer dereference the draft cannot place":

| Swift line | Raven wrote | Marker |
| --- | --- | --- |
| 70-71 | `f->mask = *(unsigned *)m` | `portMissing("StringToFilter", source: "oracle/codemp/game/g_svcmds.c:62")` |
| 73-74 | `f->compare = *(unsigned *)b` | `portMissing("StringToFilter", source: "oracle/codemp/game/g_svcmds.c:62")` |
| 101-102 | `*(unsigned *)b = ipFilters[i].compare` | `portMissing("UpdateIPBans", source: "oracle/codemp/game/g_svcmds.c:109")` |
| 147-148 | `in = *(unsigned int *)m` | `portMissing("G_FilterPacket", source: "oracle/codemp/game/g_svcmds.c:134")` |
| 299-300 | `*(unsigned *)b = ipFilters[i].compare` | `portMissing("Svcmd_ListIPs_f", source: "oracle/codemp/game/g_svcmds.c:276")` |
| 331-332 | `*(unsigned *)b = ipFilters[i].compare` | `portMissing("G_SaveBanIP", source: "oracle/codemp/game/g_svcmds.c:299")` |

**Raven.** The six casts are the only `*(unsigned *)` reads or stores in `oracle/codemp/game/`: g_svcmds.c:98, 99, 121, 159, 292, 324. Raven declares every byte array `byte b[4]` or `byte m[4]` (g_svcmds.c:66, 67, 111, 136, 280, 304), and the fields `unsigned mask` and `unsigned compare` (g_svcmds.c:43-44). The draft declares all six arrays `[Int32]` (Swift lines 31, 32, 88, 122, 289, 314). jka-rust (`g_svcmds.rs:43-180`, `325-376`) holds `[0u8; 4]`, reads with `u32::from_ne_bytes`, and writes with `to_ne_bytes` inside `format_ip`. Its `G_FilterPacket` uses `wrapping_mul` and `wrapping_add`, so the byte wraps at 8 bits.

**Swift types.** `lookup.py ipFilter_t` gives `IpFilter` with `mask: UInt32` and `compare: UInt32`. `UInt8` has no `FormatArg` conformance (`Format.swift:27-51`), so a `%i` argument reads `Int32(b[0])`.

**Helpers.** No pack or unpack helper exists in `JKAShared`, `JKAMP_Game`, or `JKAMP_BG`. The only byte reinterpret is the `bitPattern` of guide 182, which covers one scalar, not a byte array.

**Guide.** Guide 525 already says "A fixed array of a narrow type keeps its element type", and guide 526-527 give the local's truncating store and widening read. So the `[UInt8]` half of the form is in the guide, and the `[Int32]` declarations are a drafter defect, row R3.

**Verdict.** Premise amended: "The guide has no form for four bytes read or stored as one `unsigned`. The byte arrays already take `[UInt8]` under guide 525, and the drafter missed that rule." Form amended: the helper half stands, and the storage half moves to R3 as a drafter fix. The helpers use the native byte order, as Raven's cast does and as jka-rust's `from_ne_bytes` does. Every target triple of the port is little-endian.

```swift
var m: [UInt8] = [UInt8](repeating: 0, count: 4)
m[i] = UInt8(truncatingIfNeeded: Int32(m[i]) * 10 + (p.byte - Int32(ascii: "0")))
`in` = UInt32(nativeBytes: m)
b = nativeBytes(of: ipFilters[i].compare)
G_Printf("%s\n", va("%i.%i.%i.%i \n", Int32(b[0]), Int32(b[1]), Int32(b[2]), Int32(b[3])))
```

**Same ground.** R3 (the `byte` local arrays), L2 (the `UpdateIPBans` line that reads `b`).

### L2

**Sites.** One Port-note, `g_svcmds.swift:103-105`, the compiler text "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'CharBuf'". Raven wrote: `Com_sprintf( iplist + strlen(iplist), sizeof(iplist) - strlen(iplist), "%i.%i.%i.%i ", b[0], b[1], b[2], b[3])`. Marker: `portMissing("UpdateIPBans", source: "oracle/codemp/game/g_svcmds.c:109")`.

**Raven.** g_svcmds.c:122-123 is the only `Com_sprintf` into a pointer offset in `oracle/codemp/game/`. The buffer is `char iplist[MAX_INFO_STRING]` (g_svcmds.c:113). jka-rust (`g_svcmds.rs:114-126`) appends to a `String` with `push_str(&format_ip(...))` and drops the size limit.

**Swift types.** `lookup.py sig Com_sprintf`: `Com_sprintf(_ dest: inout CharBuf, _ size: Int32, _ fmt: String, _ args: any FormatArg...)`. The local is `var iplist = CharBuf(1024)`.

**Helpers.** `Com_sprintf` has one overload, `q_shared.c.swift:949`, with no offset. The `at:` overloads exist for `strcpy` (`CString.swift:183`), `strcat` (`CString.swift:276`, `286`, `292`), `Q_strncpyz` (`q_shared.c.swift:853`), and `Q_strcat` (`q_shared.c.swift:884`). Each takes the suffix, calls the base form, and writes the suffix back. `Q_strcat(&iplist, ..., va(...))` is not the same call, because `Com_sprintf` prints its own overflow message.

**Guide.** Guide 643 gives `at:` for `strcpy` and `strcat`, guide 634 for `Q_strcat`, and guide 652 for `vsprintf(string + 7, ...)`. No line gives it for `Com_sprintf`.

**Verdict.** Premise holds. Form confirmed: a `Com_sprintf(_:_:_:_:at:)` overload beside `Q_strcat`'s, with the same suffix-and-write-back body. A labeled parameter after a variadic one is legal Swift.

```swift
Com_sprintf(&iplist, Int32(iplist.count) - strlen(iplist), "%i.%i.%i.%i ", Int32(b[0]), Int32(b[1]), Int32(b[2]), Int32(b[3]), at: strlen(iplist))
```

**Same ground.** O5 (an `at:` overload for a pointer into `buf`), L1 (the `b` bytes on the same line), R4.

### L3

**Sites.** Three Port-notes in `g_misc.swift`, each with the compiler text "cannot convert value of type 'Bool' to expected argument type 'Int32'", and each marker `portMissing("SP_misc_skyportal", source: "oracle/codemp/game/g_misc.c:694")`:

| Swift line | Raven wrote |
| --- | --- |
| 716-718 | `isfog += G_SpawnVector ("fogcolor", "0 0 0", fogv)` |
| 719-721 | `isfog += G_SpawnInt ("fognear", "0", &fogn)` |
| 722-724 | `isfog += G_SpawnInt ("fogfar", "300", &fogf)` |

**Raven.** g_misc.c:707-709 are the only `+=` of a `G_Spawn*` result in `oracle/codemp/game/`. `isfog` is `int` (g_misc.c:700), and g_misc.c:711 reads it as `(int)isfog`. `G_SpawnVector` is declared `float *out` (g_spawn.c:43, g_local.h:940), and all six callers pass a `vec3_t`: g_misc.c:707, g_mover.c:958, 2172, 2627, g_saga.c:1762, 1763. jka-rust (`g_misc.rs:727-755`) writes `isfog += G_SpawnVector(...)`, because its `qboolean` is `c_int`. Its `G_SpawnVector` (`g_spawn.rs:140-157`) takes `*mut f32` and reads three floats.

**Swift types.** `sig G_SpawnVector` prints `inout Float`, but the store is stale: the tool warns that 64 stubs changed. The live stub is `g_spawn.swift:79`, `func G_SpawnVector(_ key: String, _ defaultString: String, _ out: inout JKAShared.vec3_t) -> Bool`, from `rulings.py:222`, `("G_SpawnVector", "out"): "vec3_mut"`. `g_mover.swift:973`, `2052`, and `2460` already call it with `&color` and `&spinangles`. The manifest row `.claude/manifest/g_spawn.md:13` carries the same stale `inout Float`. `sig G_SpawnInt` gives `inout Int32` and `-> Bool`.

**Helpers.** `Promotion.swift` defines no operator with a `Bool` operand. No `Int32` initializer from `Bool` exists in `JKAShared`.

**Guide.** No line gives a `qboolean` as an `int` operand. Guide 522 maps `qboolean` to `Bool`, and guide 535 forbids a conversion Raven did not write.

**Verdict.** Premise amended: "Swift adds no `Bool` to an `Int32`, three holes. The `inout Float` of the sig table is a stale store row. The stub takes `inout vec3_t`, so the two g_saga holes of `SP_misc_siege_item` (`g_saga.swift:1640-1645`) fill today as `G_SpawnVector("mins", "-16 -16 -24", &ent.r.mins)`." Form confirmed: one `@_disfavoredOverload public func += (lhs: inout Int32, rhs: Bool)` in `Promotion.swift` that adds 1 or 0, the only shape Raven writes. The operator keeps Raven's line, and a `? 1 : 0` at the site would be a conversion Raven did not write.

```swift
isfog += G_SpawnVector("fogcolor", "0 0 0", &fogv)
```

**Same ground.** The g_saga blocked note of wave 2B. The skeleton regenerate refreshes the stale sig rows.

### M1

**Sites.** Thirteen Port-notes in `g_vehicles.swift`, each marker `portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")`. Line 2122-2124: "A local `char *[4] surfName` the table has no type for", Raven wrote `char *surfName[4];`. Lines 2135-2137, 2144-2146, 2147-2149, 2152-2154, 2155-2157, 2164-2166, 2167-2169, 2172-2174, 2181-2183, 2184-2186, 2189-2191: "A read of `surfName`, a local the draft left as a hole", the stores `surfName[0] = "nose"`, `"r_wing2"`, `"l_wing2"`, `"r_gear"`, `"l_gear"`, `"r_wing1"`, `"r_wing2"`, `"r_gear"`, `"l_wing1"`, `"l_wing2"`, `"l_gear"`. Line 2209-2211: `NPC_SetSurfaceOnOff(veh, surfName[numSurfs], TURN_OFF)`.

**Raven.** g_vehicles.c:3104 is the only `char *name[N]` local in `oracle/codemp/game/`. Each arm stores slots 0 to `numSurfs - 1` (g_vehicles.c:3116-3150), and the loop at 3163-3167 reads only those slots, from `numSurfs - 1` down. No read tests a slot for NULL, and the unset slots hold stack garbage, not NULL. jka-rust (`g_vehicles.rs:2338-2441`) declares `[*const c_char; 4]` set to null.

**Swift types.** `sig NPC_SetSurfaceOnOff`: `(_ ent: Entity, _ surfaceName: String, _ surfaceFlags: Int32)`, so the read must give a `String`.

**Helpers.** None needed. `Int32Indexing.swift` lets `numSurfs` index an `Array`.

**Guide.** No line gives a local array of `char *`. Guide 112 gives the nearest form, `var entity_list = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))`, for an array of record pointers that a callee fills. Guide 93 makes a `char *` that the NULL sweep does not reach a `String`, not a `String?`.

**Verdict.** Premise holds. Form amended: `[String]`, not `[String?]`. No read tests NULL and every read follows a store on the same path, so guide 93 gives `String`, and the force unwrap of the proposal would be noise.

```swift
var surfName = [String](repeating: "", count: 4) //up to 4 surfs at once
surfName[0] = "nose"
NPC_SetSurfaceOnOff(veh, surfName[numSurfs], TURN_OFF)
```

**Same ground.** None in the record. Guide 112 is the precedent.

### M2

**Sites.** Seven Port-notes in `g_vehicleTurret.swift`. Each draft did not compile on a `Slots<Float>` row.

| Swift line | Raven wrote | Marker function |
| --- | --- | --- |
| 36-37 | `missile = WP_FireVehicleWeapon( parent, pVeh->m_vMuzzlePos[curMuzzle], pVeh->m_vMuzzleDir[curMuzzle], ...)` | `VEH_TurretCheckFire`, `g_vehicleTurret.c:12` |
| 66-67 | `VectorSubtract( org, pVeh->m_vMuzzlePos[curMuzzle], diff )` | `VEH_TurretAnglesToEnemy`, `:61` |
| 79-80 | `VectorSubtract( org, pVeh->m_vMuzzlePos[curMuzzle], enemyDir )` | `VEH_TurretAnglesToEnemy`, `:61` |
| 98-99 | `vectoangles( pVeh->m_vMuzzleDir[curMuzzle], curAngles )` | `VEH_TurretAim`, `:89` |
| 190-191 | `VectorCopy( pVeh->m_vMuzzlePos[curMuzzle], org2 )` | `VEH_TurretFindEnemies`, `:193` |
| 296-297 | `VectorSubtract( turretEnemy->r.currentOrigin, pVeh->m_vMuzzlePos[curMuzzle], enemyDir )` | `VEH_TurretThink`, `:324` |
| 303-304 | `if ( trap_InPVS( pVeh->m_vMuzzlePos[curMuzzle], ...) ) { trace_t tr; ... }` | `VEH_TurretThink`, `:324` |

D8 holds four more, `g_weapon.swift:3510-3514` and `4155-4159`.

**Raven.** `vec3_t m_vMuzzlePos[MAX_VEHICLE_MUZZLES], m_vMuzzleDir[MAX_VEHICLE_MUZZLES]` (bg_vehicles.h:530). Every use reads or writes one whole row as a `vec3_t`: g_vehicleTurret.c:43, 69, 83, 102, 208, 410, 416, 421, and g_weapon.c:3606, 3607, 4290, 4291. jka-rust holds `[vec3_t; 12]` and indexes the row as a vector.

**Swift types.** `lookup.py Vehicle_t m_vMuzzlePos`: `m_vMuzzlePos: Slots<Slots<Float>>`, array of 12 (`Sources/JKAMP/Generated/Views/Vehicle.swift:187`, `190`).

**Helpers.** `Slots(vectors:count:)` exists at `Sources/JKAShared/Views/Slots.swift:134`, with a 12-byte stride and a read and a write of `vec3_t`. `views.py:183-184` emits it for the `vectors` kind. `spelling.py:226-235` has the `vectors` answer, but `field()` tests `CONSTANTARRAY` first. A `vec3_t` element is canonically `float[3]`, so the element falls into the `rows` arm at line 233, and the `is_vec3(t)` test at line 234 never runs for it. That is a generator defect, not a missing form. Five fields carry it: `m_vMuzzlePos`, `m_vMuzzleDir`, `enemyLaggedPos`, `oldPos`, and `oldNormal`. `mdxaBone_t.matrix` is `float[3][4]` and stays `rows`.

**Guide.** No line names a `vec3_t[N]` field.

**Verdict.** Premise amended: "A `vec3_t[N]` field is `Slots<Slots<Float>>` because `spelling.py` `field()` tests the element's canonical array before `is_vec3`, so the existing `Slots(vectors:)` is never chosen." Form amended: move the `is_vec3(t)` test above the `CONSTANTARRAY` arm in `spelling.py`, and the field itself becomes `Slots<vec3_t>`, with no second accessor. The one live body use, `NPC_AI_Sniper.swift:555`, `enemyLaggedPos[index][2] -= ...`, still compiles, because the `Slots` subscript has a nonmutating setter.

```swift
org2 = pVeh.m_vMuzzlePos[curMuzzle]
```

**Same ground.** D8, S2.

### M3

**Sites.** One Port-note, `g_vehicleTurret.swift:195-197`: "Raven's block leaves a loop outside the record's scope, and the closure cannot." Raven wrote the whole `for ( i = 0; i < count; i++ ) { trace_t tr; ... }` body. Marker: `portMissing("VEH_TurretFindEnemies", source: "oracle/codemp/game/g_vehicleTurret.c:193")`.

**Raven.** g_vehicleTurret.c:214-300 declares `trace_t tr` at the top of the loop body. The body has eight `continue` statements and no `break` and no `return`. The only use of `tr` is `trap_Trace( &tr, ...)` at 260 and the reads after it. jka-rust (`g_vehicleTurret.rs:321`) declares `let mut tr: trace_t = core::mem::zeroed()` inside the loop and keeps each `continue`.

**Swift types.** `Trace.scratch` gives the three forms of guide 367 on every view, for example `Usercmd.swift:33`.

**Helpers.** None. The closure cannot `continue` an outer loop.

**Guide.** Guide 347-363 gives the scratch closure, and guide 359 makes a Raven `return` the closure's value. Guide 593 puts the `for` step before a `continue`. No line covers a `continue` inside the closure.

**Verdict.** Premise holds. Form confirmed: when the record is the first declaration of a loop body, the closure wraps the body, each `continue` is a closure `return`, and the step follows the closure. A closure around the whole loop is also exact here, because `trap_Trace` fills `tr` before any read, but that needs a per-site proof, and the confirmed form does not. M2 blocks line 190 above the loop.

```swift
i = 0
while i < count {
    Trace.scratch { tr in
        target = entity_list[i]
        if target == parent || !target!.takedamage || target!.health <= 0 || (target!.flags & FL_NOTARGET) != 0 { return }
        // ... the rest of Raven's body, each `continue` a `return`
    }
    i += 1
}
```

**Same ground.** F3, Q3, and I3 (`break` from a scratch closure).

### N1

**Sites.** No Port-note. `FighterNPC.swift:579`, `593`, `601`, and `606`, written by the coordinator: `parentPS!.hackingTime = Int32(Float(parentPS!.hackingTime) - 50 * pVeh.m_fTimeModifier)`, and the `+` form at 593 and 606. Raven wrote `parentPS->hackingTime -= 50*pVeh->m_fTimeModifier;` at FighterNPC.c:760, 786, and the `+=` form at 776, 794.

**Raven.** Other `int` compound stores from a `float` in `oracle/codemp/game/`: g_combat.c:5461, 5465, g_items.c:2601, g_mover.c:2451, g_weapon.c:1368, 1765, bg_pmove.c:10715, 10719, and 10725, where `gravity *= 0.5` multiplies by a double. The port already writes the same `Int32(Float(x) op f)` shape at `g_combat.swift:4333`, `4335`, `g_items.swift:2388`, `w_saber.swift:1961`, `3840`, `4337`, `g_mover.swift:2307`, `g_weapon.swift:1429`, `1868`, `bg_pmove.swift:9024`, and `9026`. jka-rust (`crates/mp/bg/src/vehicles/fighter_npc.rs:799-827`) writes `(hackingTime as f32 - 50.0 * m_fTimeModifier) as c_int`. The manifest points `ProcessMoveCommands` at `animal_npc.rs`, the defect the round record names.

**Swift types.** `lookup.py`: `playerState_t.hackingTime` is `Int32`, and `Vehicle_t.m_fTimeModifier` is `Float`.

**Helpers.** `Promotion.swift:39-42` defines only `+=`, `-=`, `*=`, `/=` with a `Float` left side and an `Int32` right side. Its doc comment at line 35 says "There is no `Int32` left-side form, since C truncates there and Raven's sites carry an explicit cast." Raven's sites above carry no cast, so that sentence is false. `Promotion.swift:10` defines `- (Int32, Float) -> Float`, so `hackingTime - 50 * m_fTimeModifier` is already a `Float`.

**Guide.** Guide 536 says `Promotion.swift` defines "the compound assignments", which overpromises: it defines only the `Float` left side. Guide 542 gives `Int32(...)` at a float-into-int store, and guide 535 says "A body never adds a cast Raven did not write".

**Verdict.** Premise amended: "Guide 536 promises compound assignments, and `Promotion.swift` has no `Int32` left side. Its doc comment says that Raven's sites cast, and they do not." Form amended: `x = Int32(x op f)`, guide 542 over the `Promotion.swift` operator, with no `Float(x)`. The `Float(...)` of the exemplar is a conversion Raven did not write and the operator already does. The alternative is `-=` and `+=` with an `Int32` left side in `Promotion.swift`, which keeps Raven's line, but bg_pmove.c:10725 then needs a `Double` operand form too.

```swift
parentPS!.hackingTime = Int32(parentPS!.hackingTime - 50 * pVeh.m_fTimeModifier)
```

**Same ground.** R1 (the double scale), R5 (an integer at a `Float` site), and the eleven existing sites above.

### O1

**Sites.** Three Port-notes in `ai_wpnav.swift`, with the compiler text "value of optional type 'Wpobject?' must be unwrapped to refer to member 'clear'". Line 498-500: Raven wrote `memset( gWPArray[gWPNum], 0, sizeof(gWPArray[gWPNum]) )`, marker `portMissing("RemoveWP", source: "oracle/codemp/game/ai_wpnav.c:456")`. Lines 556-558 and 568-570: `memset( gWPArray[i], 0, sizeof(gWPArray[i]) )`, marker `portMissing("RemoveWP_InTrail", source: "oracle/codemp/game/ai_wpnav.c:491")`.

**Raven.** ai_wpnav.c:473, 536, and 548 are the three `memset` of `sizeof` a pointer. `gWPArray[i]` is a `wpobject_t *`, so the size is 4 bytes on ILP32 and 8 bytes on LP64. `wpobject_t` starts with `vec3_t origin` (q_shared.h:1009), so the call zeroes `origin[0]`, or `origin[0]` and `origin[1]`. Each call is followed by `->inuse = 0`. jka-rust (`ai_wpnav.rs:502-583`) writes `write_bytes(p, 0, size_of::<*mut wpobject_t>())`, the host width, 8 bytes on its 64-bit build.

**Swift types.** `lookup.py wpobject_t origin`: `origin: JKAShared.vec3_t`. `gWPArray` is `Slots<JKAMP.Wpobject?>` (`ai_wpnav.swift:32`). `Wpobject.clear()` zeroes the whole record, which is wrong here.

**Helpers.** No partial-zero method on a view. Guide 690 bars `MemoryLayout` in a body.

**Guide.** Guide 177 already gives the form: "A memset over a partial size keeps its Port-note." The transcriptor applied it correctly.

**Verdict.** Premise holds. The holes stand under guide 177, and the row asks the user for a ruling. Form amended to a concrete ruling: the port follows the LP64 width of its host build and of jka-rust's `mp_app`, the referee that porting-rules rule 16 names, and the body zeroes `origin[0]` and `origin[1]` by name under one comment. An ILP32 build zeroes only `origin[0]`, so the ruling must name the build, or a view method that zeroes the pointer width.

```swift
// Raven's memset zeroes the size of a pointer, 8 bytes of `origin` on the 64-bit build.
gWPArray[gWPNum]!.origin[0] = 0
gWPArray[gWPNum]!.origin[1] = 0
```

**Same ground.** None in the record.

### O2

**Sites.** Seven Port-notes in `ai_wpnav.swift`, each marker `portMissing("SavePathData", source: "oracle/codemp/game/ai_wpnav.c:2372")`. Lines 2127-2129 (`char *fileString;`), 2138-2140 (`fileString = NULL`), 2170-2172 (`fileString = (char *)B_TempAlloc(524288)`), 2175-2177 (the first `Com_sprintf(fileString, 524288, ...)`), 2199-2201 (`Com_sprintf(fileString, 524288, "%s} %f\n", fileString, flLen)`), 2231-2233 (`strcat(fileString, storeString)`), 2238-2240 (`trap_FS_Write(fileString, strlen(fileString), f)`).

**Raven.** ai_wpnav.c:2375 declares the local, 2382 stores `NULL`, and 2415 stores `B_TempAlloc(524288)`. No statement between 2382 and 2415 reads `fileString`, and the three `return 0` paths at 2388, 2402, and 2408 do not read it. `B_TempFree(524288)` is at 2492. `LoadPathData` (ai_wpnav.c:2010, 2041) has no `NULL` store, so it already takes the form. jka-rust (`ai_wpnav.rs:2349-2495`) builds `file_string` as a `String` with `format!`.

**Swift types.** `rulings.py:200`, `CHARBUF_ALLOCS = {"B_TempAlloc"}`, and `rulings.py:191`, `"B_TempAlloc": "raw"`. The sibling `storeString` already reads `Com_sprintf(&storeString, 4096, "%s%i ", storeString, ...)` and compiles (`ai_wpnav.swift:2185`).

**Helpers.** None needed.

**Guide.** Guide 692-693 require "every store" to be the allocator call.

**Verdict.** Premise holds. Form confirmed: a `NULL` store that no read reaches before the allocator store drops, under one comment that quotes Raven, and the local takes the `CHARBUF_ALLOCS` form. The proof is per site and fits a drafter check: no read and no exit that reads the local between the `NULL` store and the allocator store.

```swift
var fileString = CharBuf(524288)
// Raven wrote `fileString = NULL` here, and no read reaches it before the allocation.
_ = B_TempAlloc(524288)
Com_sprintf(&fileString, 524288, "%s} %f\n", fileString, flLen)
```

**Same ground.** None in the record.

### O3

**Sites.** Two Port-notes in `ai_wpnav.swift`, compiler text "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'", marker `portMissing("AcceptBotCommand", source: "oracle/codemp/game/ai_wpnav.c:3501")`. Line 2924-2927, the `bot_wp_addflagged` arm, and line 2952-2955, the `bot_wp_switchflags` arm. Raven wrote: `while (RequiredSArgument[i]) { if (RequiredSArgument[i] == 'j') { FlagsFromArgument |= WPFLAG_JUMP; } ...`.

**Raven.** `char *RequiredSArgument` (ai_wpnav.c:3505) takes `NULL` at 3519 and `ConcatArgs( 1 )` at 3630 and 3706. The tests `!RequiredSArgument || !RequiredSArgument[0]` are at 3632 and 3708, and the byte walks at 3638-3680 and 3714-3756. jka-rust (`ai_wpnav.rs:3246-3508`) holds a `String` and walks `as_bytes()` under a second name.

**Swift types.** `sig ConcatArgs`: `func ConcatArgs(_ start: Int32) -> String`. The draft declares `var RequiredSArgument: String? = nil` (`ai_wpnav.swift:2814`) and tests `RequiredSArgument!.isEmpty` (2920, 2948).

**Helpers.** `String` has no byte subscript in `JKAShared`. `CharBuf(String)` and the generic byte subscript of `CharBuf.swift:49` exist.

**Guide.** Guide 611 covers a `String` parameter only.

**Verdict.** Premise holds. Form confirmed with the type spelled: the local is `CharBuf?`, each store wraps the call, and Raven's two tests read the byte. This keeps one name for Raven's one local, as D4 does.

```swift
var RequiredSArgument: CharBuf? = nil
RequiredSArgument = CharBuf(ConcatArgs(1))
if RequiredSArgument == nil || RequiredSArgument![0] == 0 {
while RequiredSArgument![i] != 0 {
    if RequiredSArgument![i] == Int32(ascii: "j") {
```

**Same ground.** D4, Q1.

### O4

**Sites.** One Port-note, `ai_main.swift:707-709`, compiler text "cannot convert value of type 'BotInput' to expected argument type 'OpaquePointer'". Raven wrote: `trap_EA_GetInput(bs->client, (float) time / 1000, &bi)`. Marker: `portMissing("BotUpdateInput", source: "oracle/codemp/game/ai_main.c:633")`.

**Raven.** The trap is `void trap_EA_GetInput(int client, float thinktime, void /* struct bot_input_s */ *input)` (g_syscalls.c:845, g_local.h:1809). Its one caller, ai_main.c:644, passes `&bi`, a `bot_input_t` local (ai_main.c:634). Twenty other traps of g_syscalls.c carry the same `void /* struct ... */ *` shape, and only `trap_AAS_EntityInfo` has a caller (ai_main.c:408), in a function the port marks not ported. jka-rust passes `&mut bi as *mut bot_input_t as *mut c_void`.

**Swift types.** `g_syscalls.swift:1370`: `trap_EA_GetInput(_ client: Int32, _ thinktime: Float, _ input: OpaquePointer?)`. `lookup.py bot_input_t` gives the view `JKAMP_Game.BotInput`. `trap_SiegePersSet` (`g_syscalls.swift:384`) already hands a view to `Syscall.call`, so a view is a syscall word.

**Helpers.** No overload takes the view. A body cannot build an `OpaquePointer` from the view's handle, because guide 699 bars `Unsafe` types.

**Guide.** Guide 159 gives the second overload only for a `char buf[N]`, and guide 162 gives `NIL_OVERLOADS` for an optional view.

**Verdict.** Premise holds. Form confirmed: a second generated overload that takes the view, chosen where Raven's comment names the struct and every caller passes that record. One guide line beside guide 159 states it.

```swift
trap_EA_GetInput(bs.client, Float(time) / 1000, bi)
```

**Same ground.** None in the record.

### O5

**Sites.** Two Port-notes in `ai_main.swift`, marker `portMissing("BotAI", source: "oracle/codemp/game/ai_main.c:696")`. Line 784-786: "A pointer local `char * args` with no view", Raven wrote `args;`. Line 801-803: compiler text "binary operator '!=' cannot be applied to operands of type '(Int32, String)' and 'Int'", Raven wrote the whole `while( trap_BotGetServerCommand(client, buf, sizeof(buf)) ) { ... }` loop.

**Raven.** ai_main.c:698 declares `char buf[1024], *args`. The loop at 717-733 sets `args = strchr( buf, ' ')`, does `*args++ = '\0'`, and passes `args` to `RemoveColorEscapeSequences` (674-688), which rewrites the text in place. Nothing after the call reads `args`. The `Q_stricmp` tests read `buf`, and their arms are empty. ai_main.c:724 is the only caller. jka-rust (`ai_main.rs:734-784`) loops with `while let Some(msg)`, passes a copy of the suffix, and drops the empty dispatch.

**Swift types.** `g_syscalls.swift:1030`: `trap_BotGetServerCommand(_ clientNum: Int32, _ size: Int32) -> (Int32, String)`. `sig RemoveColorEscapeSequences`: `(_ text: inout CharBuf)`. `strchr(_ s: CharBuf, _ c: Int32) -> Int32?` (`CString.swift:395`).

**Helpers.** No `at:` overload of `RemoveColorEscapeSequences`.

**Guide.** The loop shape follows from two lines: guide 151-152 put the trap call and the `strcpy` before the test, and guide 587 makes a `while` test with a store into `while true` with the test as a break at the top. Guide 632-634 give `args` as the `Int32` offset of a write cursor. No line gives a pointer into a buffer passed to an `inout CharBuf` parameter of a ported function.

**Verdict.** Premise amended: "The `while` shape follows from guide 151-152 and 587, and a line that joins them helps the next transcriptor. The pointer passed to `inout CharBuf` has no form." Form amended: the `while` line as stated, plus an `at:` overload of `RemoveColorEscapeSequences` with the suffix-and-write-back body of `Q_strcat`'s, not a second guide-only line.

```swift
var args: Int32?
while true {
    let (count, text) = trap_BotGetServerCommand(client, Int32(buf.count))
    strcpy(&buf, text)
    if count == 0 { break }
    args = strchr(buf, Int32(ascii: " "))
    if args == nil { continue }
    buf[args!] = 0
    args! += 1
    RemoveColorEscapeSequences(&buf, at: args!)
```

**Same ground.** L2 (an `at:` overload), D5, I4, Q4, and T1 (the post-increment `*args++`).
