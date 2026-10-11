# Docket proofs, rows H1 to J5

This record proves the premise and the proposed form of each row before the user rules on it.
The guide is `docs/transcription.md`, and a line number without a file is a line of the guide.
The jka-rust paths are in the submodule `jka-rust/` at the repository root.

### H1

**Sites.** `Sources/JKAMP_GameLogic/g_ICARUScb.swift:1294-1296`, Raven wrote `*value = (char *) Q3_GetAnimBoth( ent )`, `portMissing("Q3_GetString", source: "oracle/codemp/game/g_ICARUScb.c:1642")`. `g_ICARUScb.swift:1298-1300`, Raven wrote `if ( !value || !value[0] ) return 0`, the same `portMissing` line.

**Raven's C.** `oracle/codemp/game/g_ICARUScb.c:1656-1659` is the one site. `value` is `char **`, so `value[0]` is `*value`, the pointer the store set, not the first byte of the text. The test is a NULL test and not an empty-text test. `Q3_GetAnimBoth` (`g_ICARUScb.c:371`) returns NULL on two paths. The caller `g_main.c:650-655` copies the text into the shared buffer only when the pointer is not NULL. jka-rust `crates/mp/game/src/g_ICARUScb.rs:1291-1294` keeps the raw `*mut *mut c_char` and tests `value.is_null() || (*value).is_null()`.

**Swift types.** `sig Q3_GetString`: `func Q3_GetString(_ entID: Int32, _ type: Int32, _ name: String, _ value: inout String) -> Int32`. `sig Q3_GetAnimBoth`: `private func Q3_GetAnimBoth(_ ent: Entity) -> String?`. The caller `Sources/jampgame/jampgame.swift:164-169` passes the buffer's own text as the `inout` and writes it back.

**Existing helper.** None. No overload stores a `String?` into an `inout String`.

**Guide.** Line 117 gives the caller side of this exact case. Line 339 gives a text local set from an optional callee, and line 340 gives `guard let ... else { return }` for an optional view in Raven's early-out shape. No line gives the callee side for an `out_string` parameter, so the row is new ground.

**Verdict.** Premise amended: "The `out_string` parameter `value` is a non-optional `inout String`, and the callee `Q3_GetAnimBoth` returns `String?`. Raven's `!value[0]` is the NULL test of that result, and `!value` drops as an `inout` guard (line 335)." Form confirmed. It is line 340's shape applied to line 339's optional text, and the NULL path leaves `value` as it is, so the caller of line 117 writes back the same text, which matches Raven's caller that copies nothing.

```swift
case SET_ANIM_BOTH:
    guard let text = Q3_GetAnimBoth(ent!) else { return 0 }
    value = text
```

**Same ground.** None in this record.

### H2

**Site.** `Sources/JKAMP_GameLogic/g_ICARUScb.swift:1848-1850`, Raven wrote `if ( TAG_GetOrigin2( NULL, name, goalPos ) == qfalse ) { ... } else { ... return qtrue; }`, `portMissing("Q3_SetNavGoal", source: "oracle/codemp/game/g_ICARUScb.c:2255")`. The hole holds the whole `if`-`else` statement.

**Raven's C.** `TAG_GetOrigin2` is declared `int` at `g_local.h:1254` and defined `int` at `g_misc.c:3134`, and it returns 0 or 1. Raven compares it with `qfalse` at `g_ICARUScb.c:2290`, its one call. Of the 110 comparisons with `qfalse` or `qtrue` in `oracle/codemp/game/*.c`, the other live site with an `int` operand is `w_saber.c:843`, `VectorCompare( ... ) == qfalse`, row E2. The rest compare a `qboolean` return, or sit in a comment (`g_combat.c:393`, `g_nav.c:841`). jka-rust `g_ICARUScb.rs:1986` writes `== qfalse`, because `qboolean` is `c_int` there (`crates/native/types/src/lib.rs:79`, `:87`).

**Swift types.** `sig TAG_GetOrigin2`: `func TAG_GetOrigin2(_ owner: String?, _ name: String, _ origin: inout JKAShared.vec3_t) -> Int32`. Line 522 makes `qfalse` a `Bool`.

**Existing helper.** None. `Sources/JKAShared/Promotion.swift:29-30` gives `==` between `Int32` and `Float` only. No `==` between `Int32` and `Bool` exists in `JKAShared`, `JKAMP_Game`, or `JKAMP_BG`.

**Guide.** No line. Line 533 is the nearest precedent: a spelling Raven did not write takes one comment line that says what Raven wrote.

**Verdict.** Premise holds. Form confirmed. `== 0` keeps Raven's comparison on the page with the value C compares, and the comment line follows line 533's precedent.

```swift
// Raven compares the `int` with `qfalse`.
if TAG_GetOrigin2(nil, name, &goalPos) == 0 {
```

**Same ground.** E2.

### H3

**Site.** `Sources/JKAMP_GameLogic/g_ICARUScb.swift:3182-3184`, Raven wrote `if ( (val = Q3_GameSideCheckStringCounterIncrement( parmValue )) ) { val += atof( ent->parms->parm[parmNum] ); Com_sprintf( ent->parms->parm[parmNum], sizeof(ent->parms->parm), "%f", val ); } else { strncpy( ... ); if ( ent->parms->parm[parmNum][sizeof(ent->parms->parm[0]) - 1] != 0 ) { ... = 0; G_DebugPrint( ... ); } }`, `portMissing("Q3_SetParm", source: "oracle/codemp/game/g_ICARUScb.c:3651")`.

**Raven's C.** `g_public.h:666-670` declares `char parm[MAX_PARMS][MAX_PARM_STRING_LENGTH]`, 16 rows of 64 bytes. Raven writes into a row at `g_ICARUScb.c:3677` (`Com_sprintf`), `:3682` (`strncpy`), and `:3684-3686` (a byte read and a byte store). He reads rows as text at `g_ICARUScb.c:1226`, `:1604`, `:1681`, and `NPC_spawn.c:1679-1681`. The `Com_sprintf` size is `sizeof(ent->parms->parm)`, 1024, the whole field and not one row. `Q_strncpyz` (`q_shared.c:838`) calls `strncpy( dest, src, 1023 )`, which zero-pads 1023 bytes from the row start. So for `parmNum` 0 Raven clears rows 1 to 15, a defined effect, and for any other `parmNum` he writes past `parms_t`, an overrun. jka-rust `g_ICARUScb.rs:3016-3029` writes each arm into the row with `write_cstr_field` and drops both the clear and the truncation warning, with no note.

**Swift types.** `lookup parms_t parm`: `char[16][64] parm -> parm: Slots<String>`. `Sources/JKAMP_Game/Generated/Views/Parms.swift:65` builds it with `Slots(cStrings:count:capacity:)`, whose setter stores at most 63 bytes and a NUL (`Sources/JKAShared/Views/CStrings.swift:8`). So a `String` store can never leave byte 63 set, and Raven's warning arm would never run.

**Existing helper.** None. `views.py` writes a `<name>Buffer` accessor for a one-row `char[N]` field (for example `Botattachment.swift:77`), but no accessor for a row of a two-row field.

**Guide.** Line 164 gives `nameBuffer` for a `char name[N]` field. No line covers a row of `char name[M][N]`.

**Verdict.** Premise holds. Form amended: `views.py` writes `parmBuffers: Slots<CharBuf>`, one 64-byte `CharBuf` per row through `charBuf(at:capacity:)` and `store(_:at:capacity:)`, and the `strncpy` arm ports line for line. The `Com_sprintf` arm needs a separate ruling, because `Q_strncpyz` at size 1024 writes `dest[1023]` and traps on a 64-byte buffer (`Sources/JKAShared/q_shared.c.swift:719`). Option one is the row size under rule 19, with a two-line note that names the clear of rows 1 to 15 that it drops. Option two is one `CharBuf` over the whole 1024-byte field with an `at:` offset, which needs an `at:` overload of `Com_sprintf`.

```swift
strncpy(&ent!.parms!.parmBuffers[parmNum], parmValue, MAX_PARM_STRING_LENGTH)
if ent!.parms!.parmBuffers[parmNum][MAX_PARM_STRING_LENGTH - 1] != 0 {
```

**Same ground.** B6, a `char[8][32]` with a row pointer.

### I1

**Sites.** `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:316-318`, Raven wrote `return ((qboolean)(self->client->ps.eFlags2&EF2_FLYING))`, `portMissing("Boba_Flying", source: "oracle/codemp/game/NPC_AI_Jedi.c:386")`. `NPC_AI_Jedi.swift:3164-3166`, Raven wrote `float missileSpeed = WP_SpeedOfMissileForWeapon( NPC->s.weapon, ((qboolean)(NPCInfo->scriptFlags&SCF_ALT_FIRE)) );`, `portMissing("Jedi_FaceEnemy", source: "oracle/codemp/game/NPC_AI_Jedi.c:3799")`. `NPC_AI_Jedi.swift:3167-3169` is the read of `missileSpeed`, which waits on the first hole.

**Raven's C.** Of the 27 `(qboolean)` casts in `oracle/codemp/game/*.c`, three cast a raw `int`: `NPC_AI_Jedi.c:388`, `NPC_AI_Jedi.c:3833`, and `g_session.c:172`, `(qboolean)teamLeader`. The others cast a comparison, which is already `Bool` in Swift, and `g_syscalls.c` is generated code. The cast does not normalize: `EF2_FLYING` is `1<<4` (`bg_public.h:620`) and `SCF_ALT_FIRE` is `0x40` (`b_public.h:33`), so Raven's `qboolean` holds 16 or 64. Every reader tests truth only: `NPC.c:1427` is `if ( Boba_Flying( NPC ) )`, and `WP_SpeedOfMissileForWeapon` (`g_weapon.c:176-179`) ignores `alt_fire` and returns 500. jka-rust `NPC_AI_Jedi.rs:482-491` and `:4600-4603` write `!= 0`.

**Swift types.** `Boba_Flying(_ self: Entity) -> Bool`. `eFlags2: Int32`, `scriptFlags: Int32`. No `Bool.init` takes an `Int32`, which is the compiler's "no exact matches in call to initializer".

**Existing helper.** None. The only `extension Bool` in the three targets is `Sources/JKAShared/SyscallWord.swift:15`, which adds no public initializer.

**Guide.** Line 535: "A cast Raven wrote explicitly stays on the page". The `!= 0` form drops the cast, so it conflicts with line 535. Line 580 shows `(s.spawnflags & 1) != 0` for a flag test with no cast.

**Verdict.** Premise holds. Form amended to D3's form: a `Bool(_ value: Int32)` initializer in `JKAShared`, `value != 0`, so Raven's cast stays on the page as line 535 asks. The value 16 or 64 becomes `true`, and this is safe because every reader tests truth only.

```swift
return Bool(`self`.client!.ps.eFlags2 & EF2_FLYING)
```

**Same ground.** D3. The third site, `Sources/JKAMP_GameLogic/g_session.swift:128-130` (`G_ReadSessionData`), is the same hole.

### I2

**Site.** `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:1991-1993`, Raven wrote `baseTime = baseTime`, `portMissing("Jedi_ReCalcParryTime", source: "oracle/codemp/game/NPC_AI_Jedi.c:2305")`.

**Raven's C.** `NPC_AI_Jedi.c:2391` is the only self-store of a plain variable in `oracle/codemp/game/*.c`. The search for `x = x;` matched only this line. jka-rust `NPC_AI_Jedi.rs:3006-3008` drops the statement and keeps Raven's comment `//medium speed parry` as the whole arm.

**Swift types.** `baseTime: Int32`. Swift rejects the statement with the error "assigning a variable to itself".

**Existing helper.** None applies. A helper would only hide a statement that has no effect.

**Guide.** No line.

**Verdict.** Premise holds. Form confirmed. The store has no effect in C, so the drop changes nothing, and the comment keeps the line visible to a reviewer who compares with Raven. The arm then holds only comments, which Swift accepts.

```swift
if Q_irand(0, 2) != 0 {
    //medium speed parry
    // Raven wrote `baseTime = baseTime`, a store with no effect, and Swift refuses a store of a variable to itself.
}
```

**Same ground.** None.

### I3

**Site.** `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:3988-3990`, Raven wrote `while( sideTry < 10 ) { trace_t trace; vec3_t bottom; ... trap_Trace( &trace, dest, ... ); if ( trace.fraction < 1.0f ) { break; } sideTry++; }`, `portMissing("Jedi_TryJump", source: "oracle/codemp/game/NPC_AI_Jedi.c:4719")`.

**Raven's C.** `NPC_AI_Jedi.c:4769-4795`. The `trace_t trace` local is the first declaration of the loop body, so its scope is one pass, and the `break` leaves the loop that encloses the scope. The other bodies with a record local at the top of a loop body are `g_turret_G2.c:677` (`turretG2_find_enemies`), `g_items.c:2024` (`Pickup_Powerup`), and `g_vehicleTurret.c:193` (`VEH_TurretFindEnemies`). Their Swift holes carry the same Port-note at `g_turret_G2.swift:569`, `g_items.swift:1946`, and `g_vehicleTurret.swift:195`, and they leave the pass with `continue`. jka-rust `NPC_AI_Jedi.rs:5591` declares `let mut trace: trace_t = core::mem::zeroed()` inside the loop and writes `break` as Raven did.

**Swift types.** `Trace.scratch { trace in ... }` from `views.py`. `sideTry: Int32`, `dest: vec3_t`.

**Existing helper.** None. A Swift closure cannot `break` or `continue` an enclosing loop.

**Guide.** Lines 361 and 364 give the closure's value for a Raven `return` only: "A `return` inside Raven's block is the closure's value, and the body acts on that value after the closure." No line names `break` or `continue`.

**Verdict.** Premise holds. Form confirmed. It extends lines 361 and 364 from `return` to `break`: the closure opens where Raven's record opens, inside the loop body, and returns `true` where Raven breaks. The loop step follows the closure as Raven's step follows the block.

```swift
while sideTry < 10 {
    var bottom = vec3_t()
    let landed = Trace.scratch { trace -> Bool in
        ...
        trap_Trace(trace, dest, NPC!.r.mins, NPC!.r.maxs, bottom, goal.s.number, NPC!.clipmask)
        if trace.fraction < 1.0 { return true }
        return false
    }
    if landed { break }
    sideTry += 1
}
```

**Same ground.** F3, M3, and Q3 carry the `continue` case. One guide paragraph can state `break` and `continue` together.

### I4

**Sites.** `Sources/JKAMP_GameLogic/NPC_senses.swift:600-602`, Raven wrote `level.alertEvents[ level.numAlertEvents ].ID = level.curAlertID++`, `portMissing("AddSoundEvent", source: "oracle/codemp/game/NPC_senses.c:579")`. `NPC_senses.swift:633-635`, the same line, `portMissing("AddSightEvent", source: "oracle/codemp/game/NPC_senses.c:623")`.

**Raven's C.** `NPC_senses.c:611` and `:648`. Other postfix steps inside an expression in `oracle/codemp/game/*.c`: an index, `g_team.c:1123` (row D5), `g_utils.c:538`, `g_weapon.c:2560` and `:2903`, `NPC_combat.c:1625`, `:1630`, `:1770`, `:1775`, `NPC_AI_Utils.c:249`, `w_saber.c:3557`, `ai_main.c:685`, `g_svcmds.c:86`, an argument, `g_target.c:800`, and a return, `bg_vehicleLoad.c:410` and `:1361`. jka-rust `NPC_senses.rs:820-822` and `:869-871` stores `curAlertID`, then writes `curAlertID += 1` on the next line.

**Swift types.** `lookup level_locals_t curAlertID`: `curAlertID: Int32`. `lookup alertEvent_t ID`: `ID: Int32`.

**Existing helper.** None. No postfix `++` operator or step helper exists in `JKAShared`, `JKAMP_Game`, or `JKAMP_BG`.

**Guide.** Line 611 gives the form for a byte cursor only: "Raven's `*s1++` is the read plus `i1 += 1`". Lines 558-561 lift a store before the statement, which is the wrong time for a postfix step.

**Verdict.** Premise holds. Form confirmed. The statement reads the old value, and the step comes on the next line, which is C's order. The paragraph must also cover a postfix step in a `return`, `return (numVehicles++)`, which reads into a `let`, steps, and returns the `let`.

```swift
level.alertEvents[level.numAlertEvents].ID = level.curAlertID
level.curAlertID += 1
```

**Same ground.** D5.

### I5

**Sites.** `Sources/JKAMP_GameLogic/NPC_senses.swift:657-659`, Raven wrote `memmove( &level.alertEvents[i], &level.alertEvents[i+1], sizeof(alertEvent_t)*(MAX_ALERT_EVENTS-(i+1) ) )`, `portMissing("ClearPlayerAlertEvents", source: "oracle/codemp/game/NPC_senses.c:660")`. `NPC_senses.swift:698-700`, the same call from `oldestEvent`, `portMissing("RemoveOldestAlert", source: "oracle/codemp/game/NPC_senses.c:695")`.

**Raven's C.** `NPC_senses.c:677` and `:718` are the only `memmove` calls in `oracle/codemp/game/*.c` outside its definition at `bg_lib.c:287`. Each moves the records from `i+1` to `MAX_ALERT_EVENTS-1` down by one slot and leaves the last slot as it was. jka-rust `NPC_senses.rs:905-907` and `:953` copy `alertEvents[j] = alertEvents[j + 1]` for `j` from `i` to `MAX_ALERT_EVENTS - 2`, with a comment that the last slot stays.

**Swift types.** `lookup level_locals_t alertEvents`: `alertEvents: Slots<AlertEvent>`. The `Slots(views:)` setter copies `stride` bytes, which is C record assignment (`Sources/JKAShared/Views/Slots.swift:60-68`). `AlertEvent.copy(from:)` exists at `Sources/JKAMP_Game/Generated/Views/AlertEvent.swift:60`.

**Existing helper.** No `memmove` exists in the port, so the draft's call reached the Darwin `memmove`, which takes raw pointers. The record copy already exists in two spellings.

**Guide.** Line 343: "Raven's `a = b` on two records reads `a = b` when `a` is a field, because the view's setter copies the record, and `a.copy(from: b)` when `a` is a scratch slot." A slot of a world table is a field, so the copy is `a = b`. No line gives the loop for `memmove`.

**Verdict.** Premise amended: "The guide has no form for a `memmove` over a table of records. The record copy itself is line 343's `a = b`." Form amended: an ascending loop that stores each record with the `Slots` setter, `a = b`, not `copy(from:)`, because line 343 keeps `copy(from:)` for a scratch slot. An ascending copy is correct because the destination is below the source.

```swift
var j = i
while j < MAX_ALERT_EVENTS - 1 {
    level.alertEvents[j] = level.alertEvents[j + 1]
    j += 1
}
```

**Same ground.** None in this record.

### J1

**Sites.** `Sources/JKAMP_GameLogic/NPC_spawn.swift:36-38`, Raven wrote `void (*func)(gentity_t *self, gentity_t *attacker, int damage);`. Sixteen stores at `NPC_spawn.swift:41-43`, `:57-59`, `:62-64`, `:67-69`, `:72-74`, `:77-79`, `:83-85`, `:88-90`, `:93-95`, `:98-100`, `:103-105`, `:108-110`, `:113-115`, `:118-120`, `:123-125`, `:129-131`, Raven wrote `func = NPC_Jedi_Pain` to `func = NPC_Pain`. The read at `:135-137`, Raven wrote `return func`. Every one carries `portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")`. `NPC_TouchFunc` has the local at `:142-144`, the store `func = NPC_Touch` at `:146-148`, and the read at `:150-152`, each with `portMissing("NPC_TouchFunc", source: "oracle/codemp/game/NPC_spawn.c:199")`.

**Raven's C.** The function-pointer locals in `oracle/codemp/game/*.c` are `NPC_spawn.c:105` and `:201`. The other `(*name)(` declarations are parameters (`bg_pmove.c:9995`, `:10086`, `FighterNPC.c:100`) or a struct field (`g_spawn.c:155`). The sixteen live stores are `NPC_spawn.c:109` to `:182`. `NPC_spawn.c:118` is in a comment. The callers store the result into the field, `ent->touch = NPC_TouchFunc( ent )` at `NPC_spawn.c:1120`. jka-rust `NPC_spawn.rs:79-117` returns an `EntPain` or `EntTouch` enum case from each arm and has no local.

**Swift types.** `EntityPain` and `EntityTouch` are `@convention(c)` typealiases in `Sources/JKAMP_Game/Generated/Views/Callbacks.swift:11` and `:17`. The thunks are `enum Pain` and `enum Touch` in `Sources/JKAMP_GameLogic/Generated/Callbacks.swift:564` and `:426`, which `skeleton.py` writes "from the oracle's store sites".

**Existing helper.** Only 3 of the 16 pain thunks exist: `Pain.NPC_ATST_Pain`, `Pain.NPC_Rancor_Pain`, and `Pain.NPC_Wampa_Pain`, because `NPC_spawn.c:238`, `:249`, and `:257` store those three into `ent->pain`. `Touch.NPC_Touch` does not exist. The generator reads a store into a callback field and not a store into a function-pointer local.

**Guide.** Line 106 gives the return type `EntityPain?`. Line 197 gives the caller. Lines 503-504 give the field store, `ent.think = Think.G_FreeEntity`, and forbid a hand-written closure. No line gives a function-pointer local.

**Verdict.** Premise holds. Form amended: the local is `` var `func`: EntityPain? `` with backticks, because `func` is a Swift keyword, as the parameter `` `self` `` is. Each store takes the thunk under line 503, and `skeleton.py` must also write a thunk for each name Raven stores into a function-pointer local of a callback type, 13 pain thunks and `Touch.NPC_Touch`.

```swift
var `func`: EntityPain? = nil
`func` = Pain.NPC_Jedi_Pain
return `func`
```

**Same ground.** None. A side finding for A3: `Sources/JKAMP_Game/Generated/Views/Callbacks.swift:26-46` already defines `==` over `EntityDie?`, `EntityPain?`, and `EntityTouch?` and no `!=`, so A3 may need only `!(a == b)` or a generated `!=`, and it needs its own proof.

### J2

**Site.** `Sources/JKAMP_GameLogic/NPC_spawn.swift:960-962`, Raven wrote `VectorCopy(client->pers.cmd.angles, ucmd.angles)`, `portMissing("NPC_Begin", source: "oracle/codemp/game/NPC_spawn.c:862")`.

**Raven's C.** `NPC_spawn.c:1173` is the one `VectorCopy` over an `int[3]` in `oracle/codemp/game/*.c`. No other call copies `cmd.angles`, `delta_angles`, or `cmd_angles`. The live macro is `q_shared.h:1363`, `((b)[0]=(a)[0],(b)[1]=(a)[1],(b)[2]=(a)[2])`, which is three element stores. jka-rust `NPC_spawn.rs:864` writes `ucmd.angles = (*client).pers.cmd.angles`, an array copy.

**Swift types.** `lookup usercmd_t angles`: `int[3] angles -> angles: Slots<Int32>`, get-only, whose subscript setter is `nonmutating`. `lookup clientPersistant_t cmd`: `cmd: JKAMP.Usercmd`. `client` is the local `var client: Client?`, and `ucmd` is the closure parameter of `Usercmd.scratch` at `NPC_spawn.swift:688`.

**Existing helper.** None. `Slots` has `zero()`, `fill(_:)`, and `index(of:)` (`Sources/JKAShared/Views/Slots.swift:42`, `:167`, `:181`) and no copy from another `Slots`. `_VectorCopy` (`Sources/JKAShared/q_math.swift:918`) takes `vec3_t`.

**Guide.** Line 248 gives `b = a` for `VectorCopy`, which needs a settable `vec3_t`. No line covers an `int[3]` target.

**Verdict.** Premise holds. Form confirmed with the first choice, three element stores, because they are the macro's own expansion at `q_shared.h:1363`, and the site is the only one. A `Slots` copy method would add a helper for one call.

```swift
ucmd.angles[0] = client!.pers.cmd.angles[0]
ucmd.angles[1] = client!.pers.cmd.angles[1]
ucmd.angles[2] = client!.pers.cmd.angles[2]
```

**Same ground.** None.

### J3

**Site.** `Sources/JKAMP_GameLogic/NPC_spawn.swift:1285-1288`, Raven wrote `newent->m_pVehicle->m_vOrientation = &newent->client->ps.vehOrientation[0]`, `portMissing("NPC_Spawn_Do", source: "oracle/codemp/game/NPC_spawn.c:1377")`.

**Raven's C.** `bg_vehicles.h:551-552` declares the field `float *m_vOrientation`, with the old `//vec3_t m_vOrientation;` above it. Raven stores an address into it and reads it as a `vec3_t`. The one store in the game is `NPC_spawn.c:1544`. The reads include `AnimalNPC.c:386-453`, `bg_pmove.c:387`, `:569`, and `:611-662`. The cgame stores six more addresses (`cg_players.c:7046`, `:7566`, `:7570`, `cg_predict.c:267`, `:270`, `:1329`, `:1492`), outside this module. jka-rust `NPC_spawn.rs:1244-1245` stores `&mut ... ps.vehOrientation[0] as *mut f32`.

**Swift types.** `lookup Vehicle_t m_vOrientation`: `m_vOrientation: OpaquePointer?`, plus `m_vOrientationVector: JKAShared.vec3_t`, which traps when the pointer is NULL (`Sources/JKAMP/Generated/Views/Vehicle.swift:220-237`). `lookup playerState_t vehOrientation`: `vehOrientation: JKAShared.vec3_t`. `Client.ps` is `JKAMP.PlayerState`. Both views keep `raw` internal to `JKAMP`.

**Existing helper.** None. The `OpaquePointer?` setter exists, but rule 11 (`docs/porting-rules.md:28`) says no hand-written logic code holds a handle, so a body cannot form the address.

**Guide.** Line 326 keeps the `handle:` form inside generated code under rule 11. No line gives a store of a field address.

**Verdict.** Premise holds. Form confirmed. A method in `Sources/JKAMP/`, beside both views, points the field at the vector, so the address stays in the view target under rule 11. Until the store runs, every `m_vOrientationVector` read on this vehicle traps.

```swift
newent.m_pVehicle!.pointOrientation(at: newent.client!.ps)
```

**Same ground.** None in this record. The cgame stores need the same method with other targets later.

### J4

**Sites.** `Sources/JKAMP_GameLogic/NPC_utils.swift:665-667`, Raven wrote `bSID = (bState_t)(GetIDForString( BSTable, bs_name ))`, `portMissing("G_ActivateBehavior", source: "oracle/codemp/game/NPC_utils.c:851")`. `NPC_utils.swift:682-684`, Raven wrote `G_DebugPrint( WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", self->targetname, GetStringForID( BSETTable, bset ), bs_name )`, the same `portMissing` line.

**Raven's C.** `NPC_stats.c:88` and `:106` define both tables as arrays, `stringID_table_t BSTable[] =`. `NPC_utils.c:849-850` and `g_ICARUScb.c:17` declare them `extern stringID_table_t BSTable[];`, also as arrays. The uses are `NPC_utils.c:870`, `:889`, and `g_ICARUScb.c:2590`, `:2716`, `:2766`. Raven declares and uses both names as tables everywhere. jka-rust `NPC_utils.rs:702` passes `BSTable.as_ptr() as *mut stringID_table_t`.

**Swift types.** `sig GetIDForString`: `(_ table: Slots<JKAShared.StringIDTable>, _ string: String) -> Int32`. `sig GetStringForID`: `(_ table: Slots<JKAShared.StringIDTable>, _ id: Int32) -> String?`. `Sources/JKAMP_Game/GameTables.swift:18` and `:22` declare `BSTable` and `BSETTable` as `public nonisolated(unsafe) let ... : Slots<StringIDTable>`. In the body, `bs_name` is `var bs_name: String? = nil` (`NPC_utils.swift:655`).

**Why the body sees one record.** It does not. No forward, stub line, or shadowing name exists. A grep for `BSTable` over `Sources/` finds only `GameTables.swift`, the C target, the three filled calls in `g_ICARUScb.swift:2126`, `:2237`, and `:2285`, and these two holes. The Port-note is stale drafter text. `tools/oracle-closure/draft_calls.py:360-363` writes it when `registry.var_types` (`bodies.py:96-105`) has no `Slots` type for the name. The drafts entered the tree in `a43b87e` on 2026-10-04, and `GameTables.swift` arrived in `34e7f5b` on 2026-10-09. The same note stood at the three `g_ICARUScb` sites until wave 1 (`619bed8`) filled them with the plain call.

**Existing helper.** Yes. `BSTable` and `BSETTable` are already `Slots<StringIDTable>`, and the plain call compiles at `g_ICARUScb.swift:2126`.

**Guide.** No new line is due. Lines 336-337 cover the optional texts: a store into a value takes the force unwrap, and a format call under a runtime test takes `?? ""`.

**Verdict.** Premise fails. The tables are already forwarded as `Slots<StringIDTable>`, and the note predates `GameTables.swift`. Form replaced: fill both holes with the plain call. The one real gap is `bs_name`, a `String?`, which takes `!` after Raven's `VALIDSTRING` guard. The row closes with no ruling, and G1 also closes, because the `bs_name` local already exists at `NPC_utils.swift:655`.

```swift
bSID = bState_t(GetIDForString(BSTable, bs_name!))
G_DebugPrint(WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", `self`.targetname ?? "", GetStringForID(BSETTable, bset) ?? "", bs_name!)
```

**Same ground.** G1.

### J5

**Sites.** `Sources/JKAMP_GameLogic/NPC_utils.swift`, each with `portMissing("NPC_SetBoneAngles", source: "oracle/codemp/game/NPC_utils.c:906")`: `:694-696` `int *thebone = &ent->s.boneIndex1;`, `:697-699` `int *firstFree = NULL;`, `:706-708` `vec3_t *boneVector = &ent->s.boneAngles1;`, `:709-711` `vec3_t *freeBoneVec = NULL;`, `:713-715` the search loop `while (thebone) { ... }`, `:717-719` the create arm `if (!thebone) { ... }`, and `:725-727` `VectorCopy(angles, *boneVector)`.

**Raven's C.** `NPC_utils.c:906-995`. Under `_XBOX`, Raven declares `byte *thebone` (`:909`) because that build's `entityState_t` has `byte boneIndex1` (`q_shared.h:2978`). The native build declares `int *thebone` (`:912`) over `int boneIndex1` (`q_shared.h:2799`), and only that branch is written (guide `#ifdef` section). The same walk is in `g_items.c:1505-1511` (`EWeb_SetBoneAngles`) and `g_turret_G2.c:30-36`. `thebone` and `boneVector` always move together, and so do `firstFree` and `freeBoneVec`. The fields are contiguous: `boneIndex1` to `boneIndex4` at `q_shared.h:2799-2802`, and `boneAngles1` to `boneAngles4` at `:2811-2814`. jka-rust `NPC_utils.rs:732-822` walks a slot number `0..4` with a `match` per field and `Option<usize>` for the free slot.

**Swift types.** `lookup entityState_t boneIndex1`: `boneIndex1: Int32`. `lookup entityState_t boneAngles1`: `boneAngles1: JKAShared.vec3_t`. Both are on `JKAMP.EntityState`.

**Existing helper.** None. No slot accessor over the four field sets exists in `JKAShared`, `JKAMP`, `JKAMP_Game`, or `JKAMP_BG`.

**Guide.** Lines 371-395 give a chosen pointer to file-scope variables as an `inout` parameter of a nested function. That form needs every store in one `if` chain, and this walk stores in a loop and tests the pointer for NULL, so it does not apply.

**Verdict.** Premise holds. Form amended: the accessor is shared, not private, because three bodies walk the same fields. One hand extension on `JKAMP.EntityState` in `Sources/JKAMP/` gives `boneIndexSlots: Slots<Int32>` and `boneAnglesSlots: Slots<vec3_t>` over the contiguous fields, through `Slots(scalars:count:)` and `Slots(vectors:count:)`. Each of Raven's four locals is an `Int32?` slot number, `nil` for `NULL`, so each store reads as Raven wrote it.

```swift
var thebone: Int32? = 0
if ent.s.boneIndexSlots[thebone!] == 0 && firstFree == nil {
ent.s.boneAnglesSlots[boneVector!] = angles
```

**Same ground.** F2 (`EWeb_SetBoneAngles`) and Q2 (`g_turret_G2.c:30`).
