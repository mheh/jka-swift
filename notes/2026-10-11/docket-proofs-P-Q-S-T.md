# Docket proofs, rows P, Q, S, and T

This record proves the premise and the proposed form of the rows P1, P2, Q1, Q2, Q3, Q4, S1, S2, T1, T2, and T3 of `frame-path-round.md`. Each site is a Swift line under `Sources/JKAMP_GameLogic/`, a Raven line under `oracle/codemp/game/`, and a jka-rust line under `jka-rust/crates/mp/game/src/`. A "guide" line is a line of `docs/transcription.md`. No file under `Sources/`, `docs/`, or `tools/` changed, and no build ran.

### P1

Hole sites, shared with E2, H2, and T2. One ruling covers 9 holes, and T3 is a separate case.

| Row | Swift site | Raven wrote | Raven line | portMissing |
| --- | --- | --- | --- | --- |
| P1 | g_nav.swift:349 | `( trace.startsolid == qfalse ) && ( trace.allsolid == qfalse )` | g_nav.c:319 | :350 `NAV_ClearPathToPoint`, g_nav.c:222 |
| P1 | g_nav.swift:519 | `( trace->allsolid == qfalse ) && ( trace->startsolid == qfalse )` | g_nav.c:512 | :520 `NAV_CheckAhead`, g_nav.c:494 |
| P1 | g_nav.swift:794 | `tr.startsolid == qfalse && tr.allsolid == qfalse` | g_nav.c:790 | :795 `NAV_StackedCanyon`, g_nav.c:758 |
| P1 | g_nav.swift:807 | the same text | g_nav.c:802 | :808 `NAV_StackedCanyon`, g_nav.c:758 |
| P1 | g_nav.swift:978 | `( trace.allsolid == qfalse ) && ( trace.startsolid == qfalse )` | g_nav.c:992 | :979 `NAV_TestBestNode`, g_nav.c:971 |
| E2 | w_saber.swift:873 | `VectorCompare( oldLookAngles, lookAngles ) == qfalse` | w_saber.c:843 | :874 `G_G2NPCAngles`, w_saber.c:732 |
| H2 | g_ICARUScb.swift:1849 | `TAG_GetOrigin2( NULL, name, goalPos ) == qfalse` | g_ICARUScb.c:2290 | :1850 `Q3_SetNavGoal`, g_ICARUScb.c:2255 |
| T2 | NPC_combat.swift:2232 | `( flags & CP_SQUAD ) == qfalse` | NPC_combat.c:2609 | :2233 `NPC_CollectCombatPoints`, NPC_combat.c:2575 |
| T2 | NPC_combat.swift:2502 | `( level.combatPoints[i].flags & CPF_SQUAD ) == qfalse` | NPC_combat.c:2893 | :2503 `NPC_FindSquadPoint`, NPC_combat.c:2882 |

Raven's C. `trace_t` declares `byte allsolid` and `byte startsolid` at q_shared.h:1895-1896. `VectorCompare` returns `int` at q_math.c:141, and `TAG_GetOrigin2` returns `int` at g_local.h:1254 and g_misc.c:3134. Raven compares many more operands with `qfalse` or `qtrue` in the game files, for example `moved == qfalse` at NPC_AI_Sniper.c:147. Those operands are `qboolean`, the draft writes `== false`, and they compiled. A search of every `// Raven wrote:` line for `qfalse` and `qtrue` finds no other compare hole than these 9 and T3. jka-rust writes `trace.startsolid == 0 && trace.allsolid == 0` at g_nav.rs:440, 679-680, 1088, 1122, and 1413, and `(flags & CP_SQUAD) == 0` at NPC_combat.rs:2578. It writes `!VectorCompare(...)` at w_saber.rs:1026 and keeps `== qfalse` on a C int at g_ICARUScb.rs:1986.

Swift types. `lookup.py trace_t startsolid` gives `startsolid: Int32` on `JKAMP.Trace`. The draft spells `qfalse` as `false` (draft_expressions.py:663), and so the compiler compares `Int32` with `Bool`.

Helpers. No `==` between `Int32` and `Bool` exists in JKAShared, JKAMP_Game, or JKAMP_BG. Promotion.swift:29-32 covers only `Int32` and `Float`. The premise holds.

Guide. Line 522 makes `qboolean` a `Bool`, and no line gives a compare of an integer with `qfalse`. The drafter writes the truth test `!x` on a number as `x == 0` (bodies.py:5), and the guide does not state that rule. The transcriptor missed no form.

Verdict. The premise holds. The form is confirmed and narrowed to the four proposals. An `int` or `byte` compared with `qfalse` is `== 0`, and with `qtrue` is `== 1`, with no comment line. This is the text the drafter already writes for `!x`, and jka-rust wrote the same text. H2's extra comment line is the one open choice, and the record recommends no comment, because none of the 9 sites has a `qtrue` compare where `== 1` and a truth test differ. At g_nav.swift:349 the line is `if ((trace.startsolid == 0) && (trace.allsolid == 0)) && (trace.fraction == 1.0) {` with `//FIXME: check for drops` and `return true` inside. A `==(Int32, Bool)` operator is rejected, because it would let any `Bool` meet any integer with no error. Same ground: E2, H2, T2. T3 is the reverse case.

### P2

Hole sites. g_nav.swift:1201 `unsigned int minDist = MAX_RADIUS_CHECK + 1;`, with portMissing at :1202 `waypoint_getRadius`, g_nav.c:1251. The three reads of the local are blocked by this one hole, at :1209 `dist = waypoint_testDirection( ..., minDist )`, :1213 `if ( dist < minDist ) minDist = dist`, and :1219 `return minDist`, each with portMissing on the next line.

Raven's C. g_nav.c:1253 is `unsigned int minDist = MAX_RADIUS_CHECK + 1; // (unsigned int) -1;`, and g_nav.h:20 defines `MAX_RADIUS_CHECK 1024`. This is the one store of an `int` into an `unsigned` local in the file. jka-rust writes `let mut minDist: c_uint = (MAX_RADIUS_CHECK + 1) as c_uint;` at g_nav.rs:1734, a modular `as` cast.

Swift types. `lookup.py sig waypoint_getRadius` gives `-> UInt32`, and `sig waypoint_testDirection` gives `_ minDist: UInt32) -> UInt32`. `MAX_RADIUS_CHECK` is `CJKAMP_Game.MAX_RADIUS_CHECK`, an `Int32`, at Sources/JKAMP_Game/Generated/g_nav.swift:41.

Helpers. No overload stores an `Int32` into a `UInt32`. The compiled bodies already convert a signed constant to unsigned with `UInt32(bitPattern:)`, for example `UInt32(bitPattern: PSG_VOTED)` at g_cmds.swift:2040 and g_client.swift:2861. The guide does not state that form. The premise holds.

Guide. Line 543 gives `Int32(...)` for a `float` into an `int`. Line 546 gives an `Int32` overload for an `int` into an `unsigned` parameter. Neither covers a store into an `unsigned` local.

Verdict. The premise holds. The form is amended. C converts an `int` to `unsigned` modulo 2^32, which is defined behavior, and `UInt32(_:)` traps on a negative value, so the exact mirror is `UInt32(bitPattern:)`. The compiled g_cmds and g_client sites already use this spelling. The line is `var minDist: UInt32 = UInt32(bitPattern: MAX_RADIUS_CHECK + 1) // (unsigned int) -1;`, and the three reads then compile as Raven wrote them. No other row shares the ground.

### Q1

Hole sites, 5 holes:

| Swift site | Raven wrote | portMissing |
| --- | --- | --- |
| g_saga.swift:1635 | `if (!Q_stricmp(&ent->model[strlen(ent->model) - 4], ".glm"))` | :1636 `SP_misc_siege_item`, g_saga.c:1676 |
| g_target.swift:211 | `if (ent->message[0] == '@' && ent->message[1] != '@')`, activator arm | :212 `Use_Target_Print`, g_target.c:132 |
| g_target.swift:221 | the same test, red team arm | :222 |
| g_target.swift:226 | the same test, blue team arm | :227 |
| g_target.swift:233 | the same test, broadcast arm | :234 |

Raven's C. g_local.h declares `char *model` and `char *message` on `gentity_t`. g_saga.c:1688 tests `!ent->model || !ent->model[0]` before the read at g_saga.c:1754. Use_Target_Print never tests `ent->message` for NULL, and `SP_target_print` at g_target.c:239 sets only `use`, so a NULL message crashes in C. The `strlen(model) - 4` index is negative for a name shorter than 4 bytes, which C reads before the buffer. jka-rust reads `message.as_deref().unwrap()` and tests `mb.first()` and `mb.get(1)` at g_target.rs:304-307. It guards `model.len() >= 4` at g_saga.rs:2200-2202, a divergence its comment names.

Swift types. `lookup.py gentity_t model` and `gentity_t message` give `String?`. The Port-note text at each site says the field is `OpaquePointer?`, which is false.

Helpers. `CharBuf.init(_ string: String)` at CharBuf.swift:16 copies the text and a NUL. The suffix subscript is at :62, and `Q_stricmp(CharBuf, CharBuf)` is at q_shared.c.swift:808. g_bot.swift:145 already writes `let type = CharBuf(type!)` for a `String?` parameter. No helper reads a byte of a `String?` field. The premise holds.

Guide. Line 611 gives `CharBuf(s1)` for a `String` parameter walked by byte, and lines 613-614 give the suffix subscript. Line 496 gives the `String?` field. No line joins the two for a field.

Verdict. The premise is amended: the field is `String?`, not `OpaquePointer?`, and the stale Port-note text goes when the sites are filled. The form is confirmed, with the bind at the site and not at the top of the body, because Raven reads the field only on the arm. At g_target.swift:211 the lines are `let message = CharBuf(ent.message!)` and `if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {`. At g_saga.swift:1635 they are `let model = CharBuf(ent.model!)` and `if Q_stricmp(model[(strlen(model) - 4)...], ".glm") == 0 {`. A name under 4 bytes traps in the suffix subscript, where C reads outside the buffer. Same ground: D4 and O3, a byte read of a `String` local.

### Q2

Hole sites, shared with F2 and J5. One ruling covers 21 holes, 7 per function, in three copies of one Raven function.

| Function | Swift holes, `Raven wrote` line, portMissing on the next line | Raven lines |
| --- | --- | --- |
| G2Tur_SetBoneAngles (Q2) | g_turret_G2.swift:41 `int *thebone`, :44 `int *firstFree`, :53 `vec3_t *boneVector`, :56 `vec3_t *freeBoneVec`, :60 `while (thebone)`, :64 `if (!thebone)`, :72 `VectorCopy(angles, *boneVector)` | g_turret_G2.c:24-123 |
| EWeb_SetBoneAngles (F2) | g_items.swift:1457, :1460, :1469, :1472, :1476, :1480, :1488, the same seven | g_items.c:1499-1598 |
| NPC_SetBoneAngles (J5) | NPC_utils.swift:695, :698, :707, :710, :714, :718, :726, the same seven | NPC_utils.c:906-995 |

Raven's C. Each body declares `int *thebone = &ent->s.boneIndex1` and `vec3_t *boneVector = &ent->s.boneAngles1` (g_items.c:1505 and 1511, g_turret_G2.c:30 and 36, NPC_utils.c:912 and 918). A `switch (i)` moves both to field 2, 3, or 4, and `default` sets both to NULL. `firstFree` and `freeBoneVec` take their stores together, and so do `thebone` and `boneVector`. So two indices carry the four pointers. The `_XBOX` arm declares `byte *`, which the native build drops. jka-rust walks `for i in 0..4` with `match i` arms at g_items.rs:1952-1993, and it drops Raven's `Com_Printf` warning to a comment.

Swift types. `lookup.py entityState_t boneIndex1` gives `Int32`, and `boneAngles1` gives `JKAShared.vec3_t`. EntityState.swift:511 and :541 have `nonmutating set`.

Helpers. No file of JKAShared, JKAMP_Game, JKAMP_BG, or JKAMP names `boneIndex` outside the generated view. The premise holds.

Guide. Lines 370-395 cover a pointer to a chosen file-scope variable only. Line 277 already lets a stub write a `fileprivate` accessor in an extension on a view.

Verdict. The premise holds. The form is amended: two locals, not four, because each pair moves as one. `thebone` is `var thebone: Int32? = 1` and stands for `boneVector` too, and `firstFree` is `var firstFree: Int32? = nil` and stands for `freeBoneVec`. The slot number is 1 to 4, Raven's field suffix, as F2 proposed, and not Q2's 0 to 3 with -1. A `fileprivate extension EntityState` in each of the three files gives `boneIndex(_ n: Int32) -> Int32`, `setBoneIndex(_ n: Int32, _ value: Int32)`, and `setBoneAngles(_ n: Int32, _ value: vec3_t)`, each a `switch n` over the four fields. At g_items.swift:1488 the line is `ent.s.setBoneAngles(thebone!, angles)`, and `while (thebone)` is `while let n = thebone {`. The record leaves one choice open: three `fileprivate` copies, or one internal extension in g_local.swift.

### Q3

Hole sites, shared with F3 and M3. One ruling covers 3 holes. I3 is the `break` case.

| Row | Swift site | Raven loop | portMissing |
| --- | --- | --- | --- |
| F3 | g_items.swift:1947 | g_items.c:2054, `trace_t tr`, 7 `continue` | :1948 `Pickup_Powerup`, g_items.c:2024 |
| Q3 | g_turret_G2.swift:570 | g_turret_G2.c:713, `trace_t tr`, 7 `continue` | :571 `turretG2_find_enemies`, g_turret_G2.c:677 |
| M3 | g_vehicleTurret.swift:196 | g_vehicleTurret.c:212, `trace_t tr`, 9 `continue` | :197 `VEH_TurretFindEnemies`, g_vehicleTurret.c:193 |
| I3 | NPC_AI_Jedi.swift:3989 | NPC_AI_Jedi.c:4768, `trace_t trace`, one `break` | :3990 `Jedi_TryJump`, NPC_AI_Jedi.c:4719 |

Raven's C. Each `for` body opens with the record, and the three bodies hold no `break` and no `return`. In Pickup_Powerup one `continue` follows the trace, `if ( tr.fraction != 1.0 ) continue;`, so a closure that opens at the trace still holds a `continue`. jka-rust moves the record down to the trace and keeps a plain `continue`, `let mut tr: trace_t = zeroed()` at g_turret_G2.rs:1025.

Swift types. `Trace.scratch<Result>(_ body: (Trace) throws -> Result)` at Sources/JKAMP/Generated/Views/Trace.swift:33 takes a `Void` closure.

Helpers. No helper exists, and none is needed. The premise holds.

Guide. Line 361 maps a `return` in the block to the closure's value. Line 593 makes a `continue` run the step first. No line gives a `continue` inside the closure.

Verdict. The premise holds. The form is confirmed, with one limit: the closure spans the whole loop body, the loop step is the first statement after the closure, and a `continue` is a bare `return`. The step runs on every path, so the `continue` needs no step line of its own and no flag. A body with a `break` or a `return` uses I3's flag form. At g_turret_G2.swift:570 the shape is `while i < count {`, then `Trace.scratch { tr in` holding Raven's body with each `continue` as `return`, then `}`, `i += 1`, and `}`.

### Q4

Hole sites, shared with D5, I4, and T1. One ruling covers 5 holes.

| Row | Swift site | Raven wrote | Raven line | portMissing |
| --- | --- | --- | --- | --- |
| Q4 | g_target.swift:775 | `self->activator->script_targetname = va( "newICARUSEnt%d", numNewICARUSEnts++ )` | g_target.c:800 | :776 `scriptrunner_run`, g_target.c:754 |
| T1 | NPC_AI_Utils.swift:257 | `group->member[group->numGroup++].number = member->s.number` | NPC_AI_Utils.c:249 | :258 `AI_InsertGroupMember`, NPC_AI_Utils.c:232 |
| D5 | g_team.swift:1108 | `clients[cnt++] = level.sortedClients[i]` | g_team.c:1123 | :1109 `TeamplayInfoMessage`, g_team.c:1103 |
| I4 | NPC_senses.swift:601 | `level.alertEvents[ level.numAlertEvents ].ID = level.curAlertID++` | NPC_senses.c:611 | :602 `AddSoundEvent`, NPC_senses.c:579 |
| I4 | NPC_senses.swift:634 | the same text | NPC_senses.c:648 | :635 `AddSightEvent`, NPC_senses.c:623 |

Raven's C. In each statement the stepped variable is read once and nowhere else in the statement, and the statement is not a test. So the old value feeds the expression, and the step lands at the sequence point at the end. `numNewICARUSEnts` is a file-scope `int` at g_target.c:753. jka-rust reads first and steps on the next line, at g_target.rs:1105-1106 and NPC_AI_Utils.rs:322-324.

Swift types. `numNewICARUSEnts` is an `Int32` forward to `world.variables` at g_target.swift:8. `lookup.py` gives `AIGroupInfo_t.numGroup: Int32` and `level_locals_t.curAlertID: Int32`.

Helpers. No postfix operator exists, and Swift 3 removed `++`. The premise holds.

Guide. Line 559 lifts an assignment before the statement, so the expression reads the new value, which is wrong here. Line 611 already gives Raven's `*s1++` as "the read plus `i1 += 1`", a form for a pointer step. The draft writes a `++` statement as `+= 1` (bodies.py:5).

Verdict. The premise holds. The form is confirmed, with two limits: the variable appears once in the statement, and the statement is not an `if`, `while`, or `for` test. The step is the next statement, and line 611 is its precedent. The g_target.swift:775 lines are `` `self`.activator!.script_targetname = va("newICARUSEnt%d", numNewICARUSEnts) `` and `numNewICARUSEnts += 1`. The pointer steps `*out++` of B3, `*args++` of O5, and `*s++` of `G_ProcessIPBans` follow line 611 and are outside this ruling.

### S1

Hole sites. NPC_AI_GalakMech.swift:297 `if ( point ) { // VectorCopy( point, self->pos4 ); // self->client->poisonTime = level.time; //rwwFIXMEFIXME: ..do this is as well. }`, with portMissing at :298 `NPC_GM_Pain`, NPC_AI_GalakMech.c:238.

Raven's C. NPC_AI_GalakMech.c:240 declares `vec3_t point;` as a local, :245 copies `gPainPoint` into it, and :275 tests `if ( point )`. The test reads the address of a local array, so C always takes the arm, and the arm holds only comments. The arm is the `else` of Raven's `if (0)` at :248. jka-rust drops the `if (0)` block and its `else` with no comment, at NPC_AI_GalakMech.rs:321-340.

Swift types. `point` is `var point = vec3_t()` at NPC_AI_GalakMech.swift:262. The draft wrote `point != 0`, and the compiler refused `vec3_t` against `Int`.

Helpers. None applies. The premise holds.

Guide. Line 617 covers a truth test of a record's `char name[N]` field, which reads the first byte, a different test. Line 680 keeps Raven's inline comments in place. No line covers a truth test of a local array's address.

Verdict. The premise holds. The form is amended to match C2: the test drops, Raven's comment lines stay in the `else` arm, and one comment line names the dropped test. C2 proposes that line for `limbName` in G_Dismember, and R11 and R13 ask for it at other dropped tests. The arm is `} else {`, `//store the point for shield impact`, `// Raven's test of the local array point is always true, so the test drops.`, Raven's three comment lines, and `}`. Same ground: C2, at g_combat.swift:2791 and :2894.

### S2

Hole sites, shared with D8 and M2. One ruling covers 13 holes.

| Row | Swift site | Raven wrote | portMissing |
| --- | --- | --- | --- |
| S2 | NPC_AI_Sniper.swift:527 | `VectorCopy( NPCInfo->enemyLaggedPos[missFactor], target )` | :528 `Sniper_FaceEnemy`, NPC_AI_Sniper.c:508 |
| S2 | NPC_AI_Sniper.swift:553 | `CalcEntitySpot( NPC->enemy, SPOT_HEAD_LEAN, NPCInfo->enemyLaggedPos[index] )` | :554 `Sniper_UpdateEnemyPos`, NPC_AI_Sniper.c:605 |
| M2 | g_vehicleTurret.swift:36, :66, :79, :98, :190, :296, :303 | `m_vMuzzlePos[curMuzzle]` or `m_vMuzzleDir[curMuzzle]` as a `vec3_t` | the next line of each, VEH_Turret* functions |
| D8 | g_weapon.swift:3510, :3513 | `BG_GiveMeVectorFromMatrix(&boltMatrix, ..., pVeh->m_vMuzzlePos[muzzleNum])`, and the same for `m_vMuzzleDir` | :3511 and :3514 `WP_CalcVehMuzzle`, g_weapon.c:3580 |
| D8 | g_weapon.swift:4155, :4158 | `VectorCopy( pVeh->m_vMuzzlePos[i], start )`, and the same for `m_vMuzzleDir` | :4156 and :4159 `FireVehicleWeapon`, g_weapon.c:4116 |

A compiled site traps. NPC_AI_Sniper.swift:557 is `NPCInfo!.enemyLaggedPos[index] = NPCInfo!.enemyLaggedPos[index - 1]`, Raven's `VectorCopy` at NPC_AI_Sniper.c:620. The row store of `Slots(rows:)` is `fatalError` at Slots.swift:157, so this compiled line traps at its first run. No docket row lists it. NPC_AI_Sniper.swift:555, `enemyLaggedPos[index][2] -= ...`, works.

Raven's C. b_public.h:257 declares `vec3_t enemyLaggedPos[ENEMY_POS_LAG_STEPS]`, 24 rows,, and bg_vehicles.h:530 declares `vec3_t m_vMuzzlePos[MAX_VEHICLE_MUZZLES], m_vMuzzleDir[MAX_VEHICLE_MUZZLES]`. Raven reads and writes a whole row at every use. In the game files, NPC_AI_Sniper.c:616 is the one use that indexes an element. jka-rust holds the fields as native `[vec3_t; N]` arrays.

Swift types. `lookup.py` gives `enemyLaggedPos: Slots<Slots<Float>>` of 24, `m_vMuzzlePos` and `m_vMuzzleDir: Slots<Slots<Float>>` of 12. Two more `vec3_t[N]` fields have the same shape, `SaberTrail.oldPos` and `oldNormal` of 2, and no body reads them. `MdxaBone.matrix` is `float[3][4]` and is outside the rule. `CalcEntitySpot` takes `inout vec3_t`, and so do `WP_FireVehicleWeapon` (its `start`) and `BG_GiveMeVectorFromMatrix`.

Helpers. `Slots.init(vectors:count:)` at Slots.swift:134 already reads and writes `vec3_t` with the 12-byte stride. BgTables.swift:15 uses it for `WP_MuzzlePoint`. A body cannot call it, because the base is an `UnsafeMutableRawPointer` and rule 11 bars it. So the view must give the accessor, and the premise holds.

Guide. Line 327 gives the `<name>Slots` and `<name>Vector` second accessors. No line gives a `vec3_t[N]` field.

Verdict. The premise holds. The form is amended to M2's form: `views.py` gives a `vec3_t[N]` field the type `Slots<vec3_t>` under Raven's name, built with `Slots(vectors:count:)`, and no second accessor. The one element use, `[index][2] -= `, still compiles through the `nonmutating set` of the `Slots` subscript. The row copy at :557 then works with no change, and Raven's name stays on the page. At NPC_AI_Sniper.swift:553 the line is `CalcEntitySpot(NPC!.enemy!, SPOT_HEAD_LEAN, &NPCInfo!.enemyLaggedPos[index])`. If the ruling keeps D8's second accessor `<name>Vectors`, line 557 needs the same accessor, or it still traps.

### T1

Hole site. NPC_AI_Utils.swift:257 `group->member[group->numGroup++].number = member->s.number`, with portMissing at :258 `AI_InsertGroupMember`, NPC_AI_Utils.c:232. Raven's line is NPC_AI_Utils.c:249.

The proof is in Q4, which covers T1, D5, and I4 with the same 5 sites. `lookup.py` gives `AIGroupInfo_t.member: Slots<AIGroupMember>` of 32 and `numGroup: Int32`. jka-rust at NPC_AI_Utils.rs:322-324 reads `numGroup` into `idx`, stores, and then steps.

Verdict. The premise holds. The form is confirmed under Q4's limits. The lines are `group.member[group.numGroup].number = member.s.number` and then `group.numGroup += 1`, and the next Raven line, `group.numState[member.NPC!.squadState] += 1`, follows unchanged. Same ground: Q4, D5, I4.

### T2

Hole sites. NPC_combat.swift:2232 `if ( ( level.combatPoints[i].flags & CPF_SQUAD ) && ( ( flags & CP_SQUAD ) == qfalse ) ) continue`, with portMissing at :2233 `NPC_CollectCombatPoints`. NPC_combat.swift:2502 `if ( ( level.combatPoints[i].flags & CPF_SQUAD ) == qfalse ) continue`, with portMissing at :2503 `NPC_FindSquadPoint`. The Raven lines are NPC_combat.c:2609 and 2893.

The proof is in P1, which lists the 9 sites of P1, E2, H2, and T2. The operand is `int flags & int`, an `Int32` in Swift, and jka-rust writes `(flags & CP_SQUAD) == 0` at NPC_combat.rs:2578.

Verdict. The premise holds. The form is confirmed, the same as P1. At :2232 the lines are `if (level.combatPoints[i].flags & CPF_SQUAD) != 0 && (flags & CP_SQUAD) == 0 {`, `i += 1`, `continue`, and `}`. The step comes before the `continue` under line 593. Same ground: P1, E2, H2.

### T3

Hole site. NPC_combat.swift:2209 `if ( level.combatPoints[i].occupied == (int) qtrue ) continue`, with portMissing at :2210 `NPC_CollectCombatPoints`, NPC_combat.c:2575. Raven's line is NPC_combat.c:2593.

Raven's C. g_local.h:770 declares `qboolean occupied` in `combatPoint_t`. Raven compares the field with `(int) qtrue` at :2593, with `qtrue` at :2897, and with `qfalse` at :2956, and he stores only `qtrue` and `qfalse` (:2541, :2934, :2960). The cast is Raven's own mix of types, and both sides are one enum value. jka-rust writes `occupied != 0` at NPC_combat.rs:2556.

Swift types. `lookup.py` gives `occupied: Bool` (CombatPoint.swift:78, `!= qfalse` on read). The compiled sibling at NPC_combat.swift:2506 is `if level.combatPoints[i].occupied == true {`, from NPC_combat.c:2897.

Helpers. No `Int32(Bool)` initializer and no `==(Bool, Int32)` exist. The premise holds.

Guide. Line 535 says a cast Raven wrote stays on the page. That line blocks the drop, so the row needs an exception and not only a form.

Verdict. The premise holds. The form is amended to name the exception: an `(int)` cast of `qtrue` or `qfalse` that meets a `qboolean` operand drops, because Swift has no `Int32` from a `Bool` and C compares the same enum value. The test is `== true`, as the sibling at :2506 reads. The lines are `if level.combatPoints[i].occupied == true {`, `i += 1`, `continue`, and `}`. Same ground: D3 and I1, the reverse cast `(qboolean)` of an `int`, and P1 for the compare of an integer with `qfalse`.
