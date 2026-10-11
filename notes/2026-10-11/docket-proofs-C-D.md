# Docket proofs, rows C1, C2, and D1 to D8

This record proves the premise and the proposed form of each row before the user rules on it. The rows are in `frame-path-round.md`, and the holes are in `holes-g_mover-g_combat.md` and `holes-g_weapon-g_team-g_session.md`. jka-rust is the submodule `jka-rust/` at the repository root.

### C1

**Sites.** `Sources/JKAMP_GameLogic/g_combat.swift:1970`, Raven wrote `if ( meansOfDeath < 0 || meansOfDeath >= sizeof( modNames ) / sizeof( modNames[0] ) ) { obit = "<bad obituary>"; } else { obit = modNames[ meansOfDeath ]; }`, marker at line 1971, `portMissing("player_die", source: "oracle/codemp/game/g_combat.c:2123")`. The read of `obit` at lines 1974-1975 is the blocked hole that waits on this row.

**Raven's C.** `g_combat.c:755` declares `char *modNames[MOD_MAX]`, and `g_log.c:99` declares `extern char *modNames[]`. The initializer at `g_combat.c:755-797` holds 42 names, but `bg_public.h:1098` gives `MOD_MAX` as 45, so slots 42 to 44 are NULL. The quotient at `g_combat.c:2527` is 45. `MOD_TRIGGER_HURT` is 43, so a trigger_hurt death reads a NULL slot and prints it with `%s`. Raven also reads `modNames[j]` for `j < MOD_MAX` at `g_log.c:321`, `715`, and `771`. jka-rust (`crates/mp/game/src/g_combat.rs:64-70`, `2337-2346`) declares all 45 slots, tests `modNames.len()`, and prints `"(null)"` for a NULL slot under its rule-19 note.

**Types.** `modNames: [String]` at `Sources/JKAMP_GameLogic/g_local.swift:148`, forwarded at `g_combat.swift:9`, with 42 entries. `meansOfDeath: Int32`, `obit: String` (line 1635).

**Helpers.** None is needed for the comparison. Swift's `BinaryInteger` has the mixed-integer `>=`, and `g_spawn.swift:169` compiles `sIndex < spawns.count` with an `Int32` on the left. The drafter spells a buffer `sizeof` as `Int32(x.count)` (`tools/oracle-closure/draft_expressions.py:42`), and `g_main.swift:468` spells `gameCvarTableSize` as `Int32(world.gameCvarTable.count)`.

**Guide.** No line gives the element count of an array of pointers. Line 172 names the declared bound for a memset size only.

**Verdict.** Premise amended: the guide has no form, and the Swift table also holds 42 slots where Raven's holds 45. The form `modNames.count` reads 42, so deaths 42 to 44 log `<bad obituary>` where Raven logs `(null)`. The `g_log` loops index past the end of the Swift array at `j = 42` and trap.

**Form.** Replaced. `modNames` becomes `[String?]` with Raven's 45 slots, the last three `nil`. The quotient is `modNames.count`, compared with the mixed-integer comparison, and a read for `%s` takes `?? "(null)"` under the two-line note of rule 19. The `g_log` reads of `modNames[j]` at `g_log.swift:277`, `679`, and `736` take the same `??`.

```swift
if meansOfDeath < 0 || meansOfDeath >= modNames.count {
    obit = "<bad obituary>"
} else {
    // Raven's table holds NULL past its 42 names, and his `%s` of NULL is undefined.
    // The port prints "(null)", as the C runtimes do.
    obit = modNames[meansOfDeath] ?? "(null)"
}
```

**Shared ground.** B4 (`gc_orders`, the same quotient over `[String]`). Check that `gc_orders` holds Raven's full bound.

### C2

**Sites.** `g_combat.swift:2792`, Raven wrote `if (ent->ghoul2 && limbName && trap_G2API_GetSurfaceRenderStatus(ent->ghoul2, 0, limbName)) { ... return; }`, marker at line 2793, `portMissing("G_Dismember", source: "oracle/codemp/game/g_combat.c:3436")`. `g_combat.swift:2894`, Raven wrote `if (ent->s.eType == ET_NPC && ent->ghoul2 && limbName && stubCapName) { trap_G2API_SetSurfaceOnOff(...) x2 }`, marker at line 2895, the same `portMissing` line.

**Raven's C.** `g_combat.c:3440` and `3442` declare `char limbName[MAX_QPATH]` and `char stubCapName[MAX_QPATH]`. The tests at `g_combat.c:3491` and `3608` read the array addresses, which are never NULL, so both terms are always true. Every arm of the `if` chain at `3444-3489` writes both buffers. jka-rust (`g_combat.rs:3711-3712`, `3844-3848`) drops both terms with no comment.

**Types.** `limbName` and `stubCapName` are `CharBuf(64)` locals (lines 2754, 2756). `trap_G2API_GetSurfaceRenderStatus(_: OpaquePointer?, _: Int32, _: String) -> Int32` and `trap_G2API_SetSurfaceOnOff(_: OpaquePointer?, _: String, _: Int32) -> Bool` in `Sources/JKAMP_Game/Generated/g_syscalls.swift:2267` and `2241`. `ent.ghoul2` is `OpaquePointer?`.

**Helpers.** None. `CharBuf` has no truth test, and none is needed.

**Guide.** Lines 334-335 drop a null guard on a value that cannot be NULL, "with no comment and no marker", for a view parameter, an `inout` parameter, a text local, and a never-null variable. A local array is not on that list. Lines 617-618 cover a record field, a different test.

**Verdict.** Premise holds: no line names the address of a local array.

**Form.** Amended. The term drops, and line 335 adds "the address of a local or file-scope array" to its list, so the drop takes no comment, as the other never-null drops do. A comment line under Raven's text is redundant, because the `// Raven wrote:` line leaves the file when the hole fills.

```swift
if ent.ghoul2 != nil && trap_G2API_GetSurfaceRenderStatus(ent.ghoul2, 0, String(limbName)) != 0 {
    //is it already off? If so there's no reason to be doing it again, so get out of here.
    return
}
```

**Shared ground.** S1 (`if ( point )` over the local `vec3_t point` of `NPC_AI_GalakMech.c:240`).

### D1

**Sites.** `g_session.swift:65`, Raven wrote `s = va("%i %i ... %s %s %s", client->sess.sessionTeam, ..., client->sess.teamLeader, client->sess.setForce, ...)`, marker at line 66, `portMissing("G_WriteClientSessionData", source: "oracle/codemp/game/g_session.c:23")`. A grep for the compiler text "'Bool' does not conform to expected type 'FormatArg'" across `Sources/` finds this one site.

**Raven's C.** `g_session.c:72-88` passes `teamLeader` and `setForce`, both `qboolean` (`g_local.h:420`, `422`), to `%i`. C reads the enum as its `int`, 0 or 1. jka-rust (`g_session.rs:72-73`) writes `c.sess.teamLeader as i32` and passes `setForce` as its integer.

**Types.** `lookup.py clientSession_t teamLeader` and `setForce` give `teamLeader: Bool` and `setForce: Bool` on `JKAMP_Game.ClientSession`. `va(_ format: String, _ args: any JKAShared.FormatArg...) -> String`.

**Helpers.** `Sources/JKAShared/Format.swift:27-53` conforms `Int32`, `Int`, `Float`, `Double`, `String`, `CharBuf`, and `PooledString`, and not `Bool`. No helper closes the hole.

**Guide.** Line 649 names the specifier subset and no `Bool` argument. Line 689 reads a `qboolean` as an `int` slot only in the parse tables.

**Verdict.** Premise holds.

**Form.** Confirmed. `extension Bool: FormatArg { public var formatValue: FormatValue { .integer(self ? 1 : 0) } }` in `Format.swift`. A `Bool` under `%s` still traps, because the format checks the case. The site passes the fields as Raven wrote them.

```swift
s = va("%i %i %i %i %i %i %i %i %i %i %i %i %s %s %s", client.sess.sessionTeam, client.sess.spectatorTime, client.sess.spectatorState, client.sess.spectatorClient, client.sess.wins, client.sess.losses, client.sess.teamLeader, client.sess.setForce, client.sess.saberLevel, client.sess.selectedFP, client.sess.duelTeam, client.sess.siegeDesiredTeam, siegeClass, saberType, saber2Type)
```

**Shared ground.** A6 and F1 give a `qboolean` to an integer operator, `(b ? 1 : 0)`. D1 covers the format path alone.

### D2

**Sites.** `g_session.swift:97`, Raven wrote `sscanf( s, "%i %i %i %i %i %i %i %i %i %i %i %i %s %s %s", &sessionTeam, ..., &client->sess.saber2Type )`, marker at line 98, `portMissing("G_ReadSessionData", source: "oracle/codemp/game/g_session.c:105")`.

**Raven's C.** `g_session.c:118-133` is the one mixed format in the game. The other `sscanf` calls (`bg_misc.c:379`, `bg_vehicleLoad.c:205`, `879`, `g_ICARUScb.c:305`, `1604`, `5034`, `5043`, `5057`, `g_spawn.c:48`, `898`, `917`, `929`, `945`) read `"%f %f %f"`, `"%f"`, or `"%d"`. The twelve `%i` targets are three uninitialized `int` locals (`g_session.c:111-113`), eight `int` fields, and `setForce`, a `qboolean`. The three `%s` targets are `char[64]` fields with no width, so a token of 64 bytes or more overruns. A short string leaves the fields as they were and the locals uninitialized. jka-rust (`g_session.rs:96-165`) splits on whitespace, parses each token with `unwrap_or(0)`, and notes the uninitialized locals under its rule 19.

**Types.** `spectatorTime`, `spectatorClient`, `wins`, `losses`, `saberLevel`, `selectedFP`, `duelTeam`, `siegeDesiredTeam` are `Int32`. `setForce` is `Bool`. `siegeClass`, `saberType`, `saber2Type` are `String`, with `siegeClassBuffer`, `saberTypeBuffer`, `saber2TypeBuffer: CharBuf` accessors of 64 bytes. `s` is `CharBuf(1024)`.

**Helpers.** `Sources/JKAShared/Scan.swift:163-207` has six overloads, `vec3_t`, `Float`, and `Int32` targets, over `String` and `CharBuf`. None takes this format.

**Guide.** Lines 665-666 give the method: one `Scan.swift` overload per target shape in use, and each overload checks its format. A transcriptor cannot add it, because `Sources/JKAShared/` is outside the read set.

**Verdict.** Premise amended: the guide gives the method, and the shape has no overload yet.

**Form.** Amended to the guide's method, and the hand `COM_Parse` walk drops, because `COM_Parse` reads quotes and comments that `sscanf` does not. The overload is `sscanf(_ s: CharBuf, _ fmt: String, _ ints: inout [Int32], _ texts: inout [String]) -> Int32`, for a format of `%i` and `%s` conversions alone, in format order, which returns the count read and leaves a target past the stop as it was. `setForce` crosses through D3's initializer, and A6's `(b ? 1 : 0)` gives its old value.

```swift
var ints: [Int32] = [sessionTeam, client.sess.spectatorTime, spectatorState, client.sess.spectatorClient, client.sess.wins, client.sess.losses, teamLeader, (client.sess.setForce ? 1 : 0), client.sess.saberLevel, client.sess.selectedFP, client.sess.duelTeam, client.sess.siegeDesiredTeam]
var texts: [String] = [client.sess.siegeClass, client.sess.saberType, client.sess.saber2Type]
sscanf(s, "%i %i %i %i %i %i %i %i %i %i %i %i %s %s %s", &ints, &texts)
sessionTeam = ints[0]
client.sess.spectatorTime = ints[1]
// ... one store per target, in Raven's order, to client.sess.saber2Type = texts[2]
```

**Shared ground.** D3 (the `setForce` store back), A6.

### D3

**Sites.** `g_session.swift:129`, Raven wrote `client->sess.teamLeader = (qboolean)teamLeader`, marker at line 130, `portMissing("G_ReadSessionData", source: "oracle/codemp/game/g_session.c:105")`.

**Raven's C.** `g_session.c:172`. The game has 27 `(qboolean)` casts. Three cast an `int` in a body: `g_session.c:172`, `NPC_AI_Jedi.c:388`, and `NPC_AI_Jedi.c:3833`. The others cast a comparison or a syscall return, and the draft already writes `Bool((distance > MIN_DISTANCE_SQR))` (`NPC_AI_Mark2.swift:232`) and `Bool(((parentPS!.eFlags & EF_DEAD) != 0))` (`FighterNPC.swift:105`). C keeps the integer value in the enum, and every truth test of it reads `!= 0`. jka-rust (`g_session.rs:178`) writes `if team_leader != 0 { qtrue } else { qfalse }`.

**Types.** `teamLeader: Int32` local, `client.sess.teamLeader: Bool`.

**Helpers.** No `Bool.init(_: Int32)` exists in `JKAShared`, `JKAMP_Game`, or `JKAMP_BG`. `Sources/JKAShared/SyscallWord.swift:15` conforms `Bool` to `SyscallWord` and adds no initializer.

**Guide.** Line 534: "A cast Raven wrote explicitly stays on the page". That line gives the spelling `Bool(teamLeader)`, and the initializer is missing.

**Verdict.** Premise holds.

**Form.** Confirmed. `extension Bool { public init(_ value: Int32) { self = value != 0 } }` in `JKAShared`. It keeps the cast on the page by line 534, and it matches the drafted `Bool(...)` of the comparison casts. The view stores 1 where C stores the raw integer, and no read in the game tests `teamLeader` against a value other than 0.

```swift
client.sess.teamLeader = Bool(teamLeader)
```

**Shared ground.** I1 (the two `NPC_AI_Jedi.c` casts, proposed as `(x) != 0`). One form serves both, and I1 then reads `Bool(...)`.

### D4

**Sites.** `g_session.swift:168`, Raven wrote `if (value[0] == 'r' || value[0] == 'R') { ... } else if (value[0] == 'b' || value[0] == 'B') { ... } else { ... }`, marker at line 169. `g_session.swift:176`, Raven wrote `if ( value[0] == 's' ) { ... } else { switch ( g_gametype.integer ) { ... } }`, marker at line 177. Both are `portMissing("G_InitSessionData", source: "oracle/codemp/game/g_session.c:187")`.

**Raven's C.** `g_session.c:188` declares `const char *value`. The stores at `g_session.c:211` and `228` are `value = Info_ValueForKey( userinfo, "team" )`, and every read is `value[0]`. `Info_ValueForKey` returns `""` for a missing key, so `value[0]` is then NUL. jka-rust (`g_session.rs:203-205`) reads `value.chars().next().unwrap_or('\0')`.

**Types.** `var value: String` (line 143). `Info_ValueForKey(_ s: String, _ key: String) -> String`. `PickTeam(_:) -> JKAMP.team_t`, `G_PowerDuelCount(_: inout Int32, _: inout Int32, _: Bool)`.

**Helpers.** `CharBuf.init(_ string: String)` (`Sources/JKAShared/CharBuf.swift:16`) copies the text and a NUL, so `CharBuf("")[0]` is 0. No `String` byte subscript exists in `JKAShared`.

**Guide.** Line 611 gives the form for a `String` parameter, `let s1 = CharBuf(s1)` at the top of the body. No line covers a local.

**Verdict.** Premise holds.

**Form.** Confirmed. A text local whose every read is a byte read is a `CharBuf`, and each store converts, so line 611 extends from a parameter to such a local.

```swift
value = CharBuf(Info_ValueForKey(userinfo, "team"))
if value[0] == Int32(ascii: "r") || value[0] == Int32(ascii: "R") {
    sess!.sessionTeam = TEAM_RED
} else if value[0] == Int32(ascii: "b") || value[0] == Int32(ascii: "B") {
```

The declaration at line 143 becomes `var value: CharBuf`.

**Shared ground.** O3 (`AcceptBotCommand`, a `String?` local walked by byte) and Q1 (a byte read of a `char *` field).

### D5

**Sites.** `g_team.swift:1108`, Raven wrote `clients[cnt++] = level.sortedClients[i]`, marker at line 1109, `portMissing("TeamplayInfoMessage", source: "oracle/codemp/game/g_team.c:1103")`. The same shape stands at `NPC_AI_Utils.swift:257`, `group->member[group->numGroup++].number = member->s.number`, which is row T1.

**Raven's C.** `g_team.c:1123`. The game has 17 post-steps inside an index (`bg_lib.c:1049`, `1054`, `1097`, `1102`, `1126`, `ai_main.c:685`, `g_svcmds.c:86`, `g_utils.c:538`, `NPC_AI_Utils.c:249`, `g_team.c:1123`, `g_weapon.c:2560`, `2903`, `NPC_combat.c:1625`, `1630`, `1770`, `1775`, `w_saber.c:3557`). In each one the right side does not read the stepped variable. jka-rust (`g_team.rs:1373-1374`) writes the store at the old index, then `cnt += 1`.

**Types.** `clients: [Int32]` of 32, `cnt: Int32`, `level.sortedClients: Slots<Int32>`.

**Helpers.** No operator is needed. The tree already holds the form: `g_utils.swift:508-509`, `g_weapon.swift:2522-2523`, and `w_saber.swift:3161-3162` store at the old index and step on the next line.

**Guide.** No general line. Line 611 gives `*s1++` as "the read plus `i1 += 1`", the same order for a byte walk.

**Verdict.** Premise holds for the guide. The form is not new, because three filled sites already use it.

**Form.** Confirmed, as one guide line beside line 611. The form holds when the rest of the statement does not read the stepped variable, which is true at all 17 sites.

```swift
clients[cnt] = level.sortedClients[i]
cnt += 1
```

**Shared ground.** I4, Q4, T1.

### D6

**Sites.** `g_team.swift:1066`, Raven wrote `return *(int *)a - *(int *)b`, marker at line 1067, `portMissing("SortClients", source: "oracle/codemp/game/g_team.c:1089")`. `g_team.swift:1116`, Raven wrote `qsort( clients, cnt, sizeof( clients[0] ), SortClients )`, marker at line 1117. The compiler message there names Darwin's `@convention(c)` `qsort`.

**Raven's C.** The game calls `qsort` twice, `g_team.c:1128` and `g_main.c:1829`, and has two comparators, `SortClients` (`g_team.c:1089`) and `SortRanks` (`g_main.c:1624`), both over `int` arrays. `bg_lib.c:105` defines `qsort` with no `Q3_VM` guard. Raven sorts the first `cnt` of 32 elements. jka-rust writes `SortClients(a: &c_int, b: &c_int) -> c_int` (`g_team.rs:1343-1345`) and calls `qsort(&mut clients[..cnt as usize], SortClients)` (`g_team.rs:1378`) through `crates/native/sort/src/qsort.rs:71`.

**Types.** `lookup.py sig SortClients` gives `private func SortClients(_ a: OpaquePointer?, _ b: OpaquePointer?) -> Int32`, and `SortRanks` the same shape. `clients: [Int32]`, `cnt: Int32`.

**Helpers.** `Sources/JKAMP_BG/bg_lib.swift:47` ports Raven's `qsort` as `func qsort<T>(_ a: inout [T], _ cmp: (T, T) -> Int32)`. It is internal to `JKAMP_BG`, so the game target cannot see it, and the call resolves to Darwin's. It sorts the whole array and takes no count. `qsortSpan` (line 53) takes a span and is private.

**Guide.** No line names `qsort` or a comparator.

**Verdict.** Premise amended: a port of Raven's `qsort` exists, but it is internal to `JKAMP_BG` and has no count.

**Form.** Amended. `bg_lib.swift` makes `qsort` public and adds a count overload, `public func qsort<T>(_ a: inout [T], _ n: Int32, _ cmp: (T, T) -> Int32)`, which calls `qsortSpan(&a, 0, Int(n), cmp)`. A comparator over `int` takes `(_ a: Int32, _ b: Int32) -> Int32` by a sig ruling. The call keeps Raven's first three arguments and drops the `sizeof`.

```swift
private func SortClients(_ a: Int32, _ b: Int32) -> Int32 {
    return a - b
}
qsort(&clients, cnt, SortClients)
```

**Shared ground.** A1 (`SortRanks` over `level.sortedClients`, a `Slots<Int32>`, which needs a `Slots` overload too).

### D7

**Sites.** `g_weapon.swift:1534`, Raven wrote `count = G_RadiusList( ent->r.currentOrigin, FLECHETTE_MINE_RADIUS_CHECK, ent, qtrue, ent_list )`, marker at line 1535, `portMissing("prox_mine_think", source: "oracle/codemp/game/g_weapon.c:1470")`.

**Raven's C.** `g_weapon.c:1162` declares `static gentity_t *ent_list[MAX_GENTITIES]`. Its only uses are the call at `g_weapon.c:1479` and the reads at `1483`, which follow the call. `G_RadiusList` (`g_utils.c:252`) writes `ent_list[0..<count]` alone (`g_utils.c:305`). The other four callers pass a local array: `g_items.c:570`, `g_turret_G2.c:711`, `g_vehicleTurret.c:210`, `g_turret.c:422`. jka-rust (`g_weapon.rs:1733-1745`) makes `ent_list` a local array of the body.

**Types.** `G_RadiusList(_ origin: JKAShared.vec3_t, _ radius: Float, _ ignore: Entity, _ takeDamage: Bool, _ ent_list: inout [Entity?]) -> Int32`. `ent_list: Slots<Entity?>` at `g_weapon.swift:311`, over `GameStorage.ent_list`. `Slots` has a `nonmutating set` subscript. `FLECHETTE_MINE_RADIUS_CHECK` is `Int32` (line 167).

**Helpers.** No overload of `G_RadiusList` takes `Slots`, and no conversion from `Slots` to `inout [T]` exists.

**Guide.** Line 112 gives `inout [View?]` and a caller local where Raven declared a local. Lines 225-226 give a forward under Raven's name that wraps a value, calls the function, and writes the value back.

**Verdict.** Premise holds.

**Form.** Amended to one of the two proposals: the forward. A hand overload `G_RadiusList(..., _ ent_list: Slots<Entity?>) -> Int32` beside the function copies the table into an array, calls the function, and writes `[0..<count]` back, on the pattern of lines 225-226. The call site then reads Raven's line, and the storage keeps Raven's file scope.

```swift
count = G_RadiusList(ent.r.currentOrigin, Float(FLECHETTE_MINE_RADIUS_CHECK), ent, true, ent_list)
```

**Shared ground.** None in the record.

### D8

**Sites.** `g_weapon.swift:3510`, Raven wrote `BG_GiveMeVectorFromMatrix(&boltMatrix, ORIGIN, pVeh->m_vMuzzlePos[muzzleNum])`, marker at line 3511. `g_weapon.swift:3513`, the same with `NEGATIVE_Y` and `m_vMuzzleDir`, marker at line 3514. Both are `portMissing("WP_CalcVehMuzzle", source: "oracle/codemp/game/g_weapon.c:3580")`. `g_weapon.swift:4155`, Raven wrote `VectorCopy( pVeh->m_vMuzzlePos[i], start )`, and line 4158, `VectorCopy( pVeh->m_vMuzzleDir[i], dir )`, both `portMissing("FireVehicleWeapon", source: "oracle/codemp/game/g_weapon.c:4116")`. Six more holes read these fields in `g_vehicleTurret.swift` at lines 36, 66, 79, 98, 190, 296, and 303.

**Raven's C.** `bg_vehicles.h` declares `vec3_t m_vMuzzlePos[12]` and `m_vMuzzleDir[12]`. The game reads them 16 times as whole vectors: `g_weapon.c:3606`, `3607`, `4290`, `4291`, and eight sites in `g_vehicleTurret.c`. Raven indexes an element of a `vec3_t[N]` field once, `NPCInfo->enemyLaggedPos[index][2]` at `NPC_AI_Sniper.c:616`. jka-rust reads `pVeh.m_vMuzzlePos[i as usize]` as a vector (`g_weapon.rs:5263-5264`) and writes `&mut (*pVeh).m_vMuzzlePos[muzzleNum as usize]` (`g_weapon.rs:4408`).

**Types.** `lookup.py Vehicle_t m_vMuzzlePos` gives `m_vMuzzlePos: Slots<Slots<Float>>`, Array of 12, at `Sources/JKAMP/Generated/Views/Vehicle.swift:187`. Its rows come from `Slots(rows:...)`, whose write traps (`Slots.swift:146-158`). `BG_GiveMeVectorFromMatrix(_: JKAMP.MdxaBone, _: Int32, _ vec: inout JKAShared.vec3_t)` at `Sources/JKAMP_BG/bg_public.h.swift:9`. `pVeh: Vehicle?`.

**Helpers.** `Slots.init(vectors:count:)` (`Slots.swift:134`) builds a `Slots<vec3_t>` with the 12-byte stride. No generated view uses it, and no accessor gives a row as a `vec3_t`. The premise holds.

**Guide.** Line 327 gives the `<name>Slots` second accessor, "the way a `float *` field carries its `<name>Vector` accessor". No line covers a `vec3_t[N]` field.

**Verdict.** Premise holds. Also, `NPC_AI_Sniper.swift:557` compiles `NPCInfo!.enemyLaggedPos[index] = NPCInfo!.enemyLaggedPos[index - 1]` for Raven's `VectorCopy`, and that row write traps at runtime.

**Form.** Confirmed. `views.py` gives each `vec3_t[N]` field a second accessor `<name>Vectors: Slots<vec3_t>` over `Slots(vectors:count:)`. The subscript has a `nonmutating set`, so the accessor takes an `inout` argument. The five fields are `m_vMuzzlePos`, `m_vMuzzleDir`, `enemyLaggedPos`, and the two `SaberTrail` fields `oldPos` and `oldNormal`.

```swift
start = pVeh!.m_vMuzzlePosVectors[i]
BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &pVeh!.m_vMuzzlePosVectors[muzzleNum])
```

**Shared ground.** M2 and S2. The Sniper row copy at `NPC_AI_Sniper.swift:557` takes the same accessor.
