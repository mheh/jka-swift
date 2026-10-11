# The frame-path round

The round fills the Port-notes of the game files in the order of the frame, under the forms of `docs/transcription.md`. A transcriptor reads only its files, their oracle slices, their manifests, the state file, the guide, and the lookup tool. A transcriptor never builds, and the coordinator gates each wave with `swift build`, `swift test --no-parallel`, and `tools/load-test.sh`. The per-file hole tables are in the `holes-*.md` records of this folder.

## Wave 1

Seven transcriptors ran at once on disjoint files: the thirteen frame-path files g_main, g_active, g_client, g_cmds, g_utils, g_mover, g_combat, g_weapon, w_saber, g_items, g_team, g_session, and the sixteen Slots holes of F4 in g_ICARUScb, NPC_stats, NPC_utils, and NPC_spawn. No transcriptor needed a `GameWorld` property.

| Files | Holes | Filled | Stand | Blocked | Record |
| --- | --- | --- | --- | --- | --- |
| g_main, g_active | 25 | 1 | 19 | 4 | `holes-g_main-g_active.md` |
| g_client, g_cmds, g_utils | 19 | 8 | 10 | 1 | `holes-g_client-g_cmds-g_utils.md` |
| g_mover, g_combat | 22 | 17 | 2 | 3 | `holes-g_mover-g_combat.md` |
| g_weapon, g_team, g_session | 29 | 14 | 13 | 2 | `holes-g_weapon-g_team-g_session.md` |
| w_saber | 39 | 2 | 31 | 6 | `holes-w_saber.md` |
| g_items | 39 | 29 | 10 | 0 | `holes-g_items.md` |
| Slots holes of F4 | 14 | 12 | 2 | 0 | `holes-slots-tables.md` |

Ten of the g_main stands are in the logic `vmMain`, which goes under F5. The two Slots holes left are in `G_ActivateBehavior` of NPC_utils, which read a `char *` local with no form. The Slots agent counted 14 holes of the class, not 16, because the `WP_RemoveSaber` note in NPC_stats uses the same text and is outside the class, and the g_main one is in `vmMain`.

The gate passed, `swift build` at 0 errors and `swift test --no-parallel` at 112 tests in four binaries. `tools/load-test.sh` exits with status 0. The game-logic Port-note count fell from 830 to 748. The commit is `619bed8`.

### The blocked holes

- g_active: the stores `pm.trace = trap_Trace` and `pm.pointcontents = trap_PointContents` in `SpectatorThink` and `ClientThink_real`. The thunk names are in `Callbacks.swift`, outside the read set.
- g_client: `ClientCleanName`, because `ColorIndex` takes a `CChar` and the narrow-type rule asks for `Int32`. The change is in `Sources/JKAShared/q_shared.h.swift`.
- g_mover: `SP_func_breakable` passes a `String?` local to the `inout String` of `G_SpawnString`. The local's shape comes from the text-local rule of `docs/porting-rules.md`.
- g_combat: the `G_LogPrintf` read of `obit` in `player_die`, which waits on row C1.
- g_weapon: the `boltMatrix` scratch and the `trap_G2API_GetBoltMatrix_NoRecNoRot` call, which has no `sig` row.
- w_saber: the six `G2Trace` holes of `G_G2TraceCollide`. `G2Trace_t` and the two `trap_G2API_CollisionDetect` traps are outside the read set.

### Docket rows

The rows the transcriptors raised. Each is a hole the guide has no form for, with the transcriptor's proposed form. The letter names the record.

| Row | Hole | Proposed form |
| --- | --- | --- |
| A1 | `SortRanks` and the `qsort` in `CalculateRanks`: no form for `qsort` or `*(int *)a`. | A `qsort` helper over a `Slots<Int32>` with an `(Int32, Int32)` comparator that keeps the libc order. |
| A2 | `gSiegeRoundWinningTeam`: Raven's extern says `qboolean`, and he compares it with a team number. | A TYPES ruling that makes it `Int32`. |
| A3 | `hit->touch != Touch_DoorTrigger`: a C function pointer is not `Equatable`. | A generated `touchIs(...)` identity test. |
| A4 | `(bgEntity_t *)g_entities`. | A cast of a table name is the view over slot 0. |
| A5 | `sizeof(gentity_t)` into `Int32`. | An `Int32` size constant on each view. |
| A6 | `pmove_fixed.integer \| pmoveFixed`. | A `qboolean` operand of an integer operator is `(b ? 1 : 0)`. |
| B1 | `ClientSpawn`: the type checker times out, and no form splits an expression. | Typed `let` locals, one per term. |
| B2 | `ConcatArgs`: `memcpy` of `strlen` bytes with no NUL. | `strcpy(&line, arg, at: len)`. |
| B3 | `SanitizeString`: `tolower` has no home, and `(unsigned char)` has no spelling. | `tolower` joins `CString.swift`. |
| B4 | `Cmd_GameCommand_f`: no form for `sizeof(table)/sizeof(elem)`. | `gc_orders.count`. |
| B5 | `BuildShaderStateConfig`: a partial memset. | `CharBuf.zero(count:)`. |
| B6 | `vtos`: no form for `char[8][32]` with a row pointer. | A `[CharBuf]` property on `GameWorld` and a row index local. |
| C1 | `player_die`: `sizeof(modNames)/sizeof(modNames[0])`. | `modNames.count`, compared to an `Int32` with the mixed-integer comparison, no cast. |
| C2 | `G_Dismember`: a truth test of a local `char buf[N]`, two holes, always true in C. | Drop the test, under one comment line that names Raven's test. |
| D1 | A `qboolean` given to `%i`. | `Bool` conforms to `FormatArg` and prints 0 or 1. |
| D2 | `sscanf` with 12 `%i` and 3 `%s` targets. | A token overload or a hand `COM_Parse` walk. |
| D3 | The `(qboolean)` cast of an `int`. | A `Bool(Int32)` initializer in `JKAShared`. |
| D4 | A byte read of a `String` local, `value[0]`. | The local takes a `CharBuf` at its store. |
| D5 | A post-increment inside an index, `clients[cnt++]`. | The index takes the old value, and `cnt += 1` comes after. |
| D6 | `qsort` with a `void *` comparator. | An `Int32` closure comparator over `[Int32]`. Same ground as A1. |
| D7 | The `Slots<Entity?>` `ent_list` goes to `inout [Entity?]`. | `G_RadiusList` takes `Slots`, or a copy and a write back. |
| D8 | A `vec3_t[N]` field is `Slots<Slots<Float>>`. | A `<name>Vectors: Slots<vec3_t>` accessor. |
| E1 | `alwaysBlock`: a local scalar array with two dimensions. | `[[Bool]](repeating:..., count:...)`. |
| E2 | `VectorCompare(...) == qfalse`. | An `int` compared with `qfalse` reads `== 0`. |
| E3 | `vec3_origin` into `desiredPos` of `BG_IK_MoveArm`. | A ruling on whether the callee writes `desiredPos`. |
| E4 | `d1` and `d2`, 22 holes: a `float *` local over a vector. | A `vec3_t` value local. |
| E5 | The store into `dot1` inside `\|\|`. | A `Bool` local with one `if` per operand, in Raven's order. |
| F1 | `CreateShield`, `xaxis << 24`: a `Bool` cannot take an integer operator. | `(xaxis ? 1 : 0)`, same ground as A6. |
| F2 | `EWeb_SetBoneAngles`, 7 holes: pointer locals to one of `boneIndex1` to `boneIndex4` or `boneAngles1` to `boneAngles4`. | An `Int32?` slot number with a hand accessor pair on the view. |
| F3 | `Pickup_Powerup`: the loop body holds `trace_t tr` and a `continue`. | The closure opens inside the loop, `continue` is a closure `return`, and the loop step follows the closure. |
| F4 | `RespawnItem`, first loop: the non-optional `ent` runs to NULL, and the draft's `while true` lost Raven's test. | A walk over an optional local. |
| G1 | `G_ActivateBehavior`: `bs_name`, a `char *` local with no form, two holes. | Waits for a ruling on that local. |

## Wave 2A

Six transcriptors ran at once on the next files of the frame order. No transcriptor needed a `GameWorld` property.

| Files | Holes | Filled | Stand | Blocked | Record |
| --- | --- | --- | --- | --- | --- |
| NPC_spawn, NPC_utils | 60 | 28 | 32 | 0 | `holes-NPC_spawn-NPC_utils.md` |
| NPC_AI_Jedi, NPC_senses | 54 | 45 | 9 | 0 | `holes-NPC_AI_Jedi-NPC_senses.md` |
| NPC_stats, g_ICARUScb | 52 | 41 | 4 | 7 | `holes-NPC_stats-g_ICARUScb.md` |
| FighterNPC, g_vehicles, g_vehicleTurret, SpeederNPC, WalkerNPC, AnimalNPC | 54 | 33 | 21 | 0 | `holes-vehicles.md` |
| w_force, g_missile | 55 | 55 | 0 | 0 | `holes-w_force-g_missile.md` |
| g_svcmds, g_misc, g_trigger | 64 | 50 | 10 | 4 | `holes-g_svcmds-g_misc-g_trigger.md` |

The first build failed on four lines of `ProcessMoveCommands` in FighterNPC, inside the fill of the `#endif &&` hole: Raven's `parentPS->hackingTime -= 50*pVeh->m_fTimeModifier`, an `int` compound store from a `float` product, which `Promotion.swift` does not cover. The coordinator wrote each as `parentPS!.hackingTime = Int32(Float(parentPS!.hackingTime) - 50 * pVeh.m_fTimeModifier)`, the shape of the compiled `damage = Int32(Float(damage) * fact)` in g_weapon. The second build passed.

The gate passed, 0 errors and 112 tests, and `tools/load-test.sh` exits with status 0. The Port-note count fell from 748 to 496. The commit is `ead6901`.

### Findings

- The `ForceThrow` fill in w_force writes `Int32(Double(pushPowerMod) - Double(pushPowerMod) * 0.2)` for Raven's `pushPowerMod -= pushPowerMod*0.2`, under the guide's double-math rule, and `Float(radius)` for an `Int32` into a `Float` parameter. Three file-scope tables of w_force at lines 51, 55, and 59 still call `portMissing` with no Port-note, so no docket listed them.
- In `G_FilterPacket` of g_svcmds, the draft declares Raven's `byte m[4]` as `[Int32]`, so `m[i]*10` does not truncate to a byte. Not on the docket, not changed.
- The fill of `trap_ICARUS_RunScript` in `G_ActivateBehavior` had no `sig` row, and the build accepted it.

### The blocked holes

- NPC_stats, `NPC_ParseParms`: the four `saberName` statements fill as a `CharBuf(4096)` only if `rulings.py` lists `BG_TempAlloc` in `CHARBUF_ALLOCS`.
- g_ICARUScb, the three `Q3_Set*TextColor` functions: `GameVariables` gives the `textcolor_*` globals the type `[Float]`, and `SetTextColor` takes `vec4_t`. The fix is in the generator.
- g_svcmds, `G_ProcessIPBans` and `ClientForString`: a `strchr` overload at an offset, a buffer offset into `AddIP`, and a `Q_stricmp` overload for a `String` and a `CharBuf`.

### Docket rows

| Row | Hole | Proposed form |
| --- | --- | --- |
| H1 | `Q3_GetString`, `SET_ANIM_BOTH` arm: an `out_string` takes a `String?` from a callee, and the NULL path returns 0. | `guard let text = Q3_GetAnimBoth(ent!) else { return 0 }`, then `value = text`. |
| H2 | `Q3_SetNavGoal`: an `Int32` return compared with `qfalse`. | `== 0` for `qfalse` and `== 1` for `qtrue`, with one comment line that names Raven's constant. Same ground as E2. |
| H3 | `Q3_SetParm`: bytes into one row of `char parm[16][64]`, which the view gives as `Slots<String>`. | `views.py` writes a `parmBuffers` accessor, each row a `CharBuf` of 64 bytes. |
| I1 | `Boba_Flying` and `Jedi_FaceEnemy`: a `(qboolean)` cast of an `int`, two holes. | `(x) != 0`. Same ground as D3. |
| I2 | `Jedi_ReCalcParryTime`: Swift refuses `baseTime = baseTime`. | Drop the line under one comment that quotes Raven. |
| I3 | `Jedi_TryJump`: Raven's `break` leaves the loop from inside a scratch closure. | The closure returns a flag, and the loop acts on it. |
| I4 | `AddSoundEvent` and `AddSightEvent`: a postfix `++` inside an expression. | Read the variable, then `x += 1` on the next line. Same ground as D5. |
| I5 | `ClearPlayerAlertEvents` and `RemoveOldestAlert`: a `memmove` over a table of records. | An ascending loop that copies each record down with `copy(from:)`. |
| J1 | `NPC_PainFunc` and `NPC_TouchFunc`: a function pointer in a local `func`. | `var func: EntityPain?` or `EntityTouch?`, and each store takes a generated thunk. |
| J2 | `NPC_Begin`: `VectorCopy` of one `int[3]` field into another, with a get-only `Slots<Int32>`. | Three element stores, or a `Slots` copy method. |
| J3 | `NPC_Spawn_Do`: `&ps.vehOrientation[0]` into the `float *` field `m_vOrientation`. | A setter in the view target that points the field at the vector field. |
| J4 | `G_ActivateBehavior`: `BSTable` and `BSETTable` reach the body as one record. | Forward both as `Slots<StringIDTable>`. Supersedes G1. |
| J5 | `NPC_SetBoneAngles`: four pointer locals over `boneIndex1` to `boneIndex4` and `boneAngles1` to `boneAngles4`. | An `Int32?` slot index per pointer with a private accessor per field set. Same ground as F2. |
| L1 | Four bytes read as one `unsigned`, `*(unsigned *)m` and the reverse store, 6 holes in g_svcmds. | Pack and unpack helpers in JKAShared, and `[UInt8]` storage for the byte locals. |
| L2 | `Com_sprintf` into a buffer offset in `UpdateIPBans`. | An `at:` overload, as `strcpy` and `Q_strcat` have. |
| L3 | A `qboolean` added to an `int`, `isfog += G_SpawnVector(...)`, 3 holes. | An `Int32 += Bool` operator in `Promotion.swift`. The sig table gives `G_SpawnVector` an `inout Float` output where Raven passes a `vec3_t`. |
| M1 | `char *surfName[4]` in `G_FlyVehicleDestroySurface`, 13 holes. | `var surfName = [String?](repeating: nil, count: 4)`, read as `surfName[i]!`. |
| M2 | `m_vMuzzlePos` and `m_vMuzzleDir` of `Vehicle_t`, 7 holes: a `vec3_t[N]` field as `Slots<Slots<Float>>`. | `views.py` gives a `vec3_t[N]` field a `Slots<vec3_t>` with a 12-byte stride. Same ground as D8. |
| M3 | `trace_t tr` at the top of a loop body in `VEH_TurretFindEnemies`, a `continue` inside a scratch closure. | The closure wraps the body before the step, and `continue` is `return`. Same ground as F3. |
| N1 | An `int` compound store from a `float` product, `hackingTime -= 50*m_fTimeModifier`, written by the coordinator in FighterNPC. | `x = Int32(Float(x) op f)`, the compiled exemplar, as one guide line beside the Promotion rule. |

## The review of waves 1 and 2A

Three reviewers read every fill of 619bed8 and ead6901 against Raven's C, the jka-rust range of the manifest, and the guide. The records are `review-wave1.md`, `review-wave2A-npc.md`, and `review-wave2A-vehicles-force.md`. 335 fills were read: 83 in wave 1, 114 in the NPC and ICARUS files of wave 2A, 138 in the vehicle, force, missile, and server-command files of wave 2A. The `ForceThrow` and `ProcessMoveCommands` fills match Raven and jka-rust line by line.

| Severity | Count |
| --- | --- |
| behavior | 3 |
| form | 2 |
| style | 3 |

The findings are docket rows, not hand fixes, under the rule that a defect of a form goes to the form. Each row below names the fix the reviewer proposed.

| Row | Finding | Proposed fix |
| --- | --- | --- |
| R1 | NPC_AI_Jedi, `Jedi_SetEnemyInfo`: Raven's `VectorMA` macro computes `v + b*s` in double when the scale is the double `*enemy_movespeed * 0.001 * prediction`. The fill converts the scale to `Float` before `_VectorMA`, under the guide's VectorMA row, so the bits can differ. jka-rust does the same. | The guide's VectorMA row gains a double-scale case, or the row stands with the jka-rust parity noted. |
| R2 | g_ICARUScb, `G_DebugPrint`: the fill force-unwraps `g_entities[entNum].script_targetname` into a `%s`. Raven's printf prints `(null)` there, and the Swift traps when `g_developer` is 2 and the slot has no name. | A form for a `String?` into `%s`: the argument reads `name ?? "(null)"`, or the `FormatArg` conformance of `String?` prints `(null)`. |
| R3 | g_svcmds, `G_FilterPacket` and `StringToFilter`: the draft declares Raven's `byte m[4]` and `byte b[4]` as `[Int32]`, so `m[i]*10 + digit` does not wrap at 8 bits, and ten digits trap on overflow. The fill stores into that array. | A drafter rule: a `byte` local array is `[UInt8]`, and the store truncates as the narrow-type rule says. Same ground as L1. |
| R4 | g_cmds, `Cmd_CallTeamVote_f`: each `Com_sprintf` into `level.teamVoteString[cs_offset]` writes a local `CharBuf(1024)` and stores its text into the `Slots<String>` element. No guide form. Behavior is the same. | A guide line for a `Com_sprintf` into one row of a `char[N][M]` field the view gives as `Slots<String>`. Same ground as H3. |
| R5 | g_items, `pas_find_enemies`: the fill writes `Float(TURRET_RADIUS)` at the radius argument of `G_RadiusList`, a cast Raven did not write. The value is the same. | A ruling on an integer constant into a `Float` parameter: a `Float` overload of the constant, or the cast as a guide form. The `Float(radius)` of `ForceThrow` is the same case. |
| R6 | SpeederNPC: Raven's `(0 && ...)` is written `(0 != 0 && ...)`. No guide form, and the block body is empty. | The dead `if (0 && ...)` block drops under one comment that quotes Raven. |
| R7 | w_force, `ForceThrow`: `vehEnt` is `Entity?` and force-unwrapped six times, where Raven's table-slot address is never NULL. | The local is a non-optional `Entity`. |
| R8 | g_cmds, `SanitizeString`: the new `outIndex` cursor never steps, because the loop above it is still a hole. | The loop fill under B3 steps `outIndex`. |

Two notes outside the fills. The FighterNPC manifest points `ProcessMoveCommands` and `ProcessOrientCommands` at `animal_npc.rs` in jka-rust, and the bodies are in `fighter_npc.rs`, a manifest defect for the regenerate. `SelectRandomTeamSpawnPoint` keeps Raven's bug, the class arm returns `spots[selection]` where `classSpots` was likely meant, and jka-rust records the same.

## Wave 2B

Six transcriptors ran at once on the last files of the frame order. No transcriptor needed a `GameWorld` property. The coordinator confirmed for the NPC core transcriptor that the NULL arms of `AngleVectors` at `q_math.c:1315-1348` only skip the writes, and the transcriptor filled its thirteen blocked holes under the NULL-output caller form.

| Files | Holes | Filled | Stand | Blocked | Record |
| --- | --- | --- | --- | --- | --- |
| ai_wpnav, g_bot, ai_main | 64 | 49 | 15 | 0 | `holes-ai_wpnav-g_bot-ai_main.md` |
| g_nav, g_navnew, ai_util | 69 | 52 | 6 | 11 | `holes-g_nav-g_navnew-ai_util.md` |
| g_saga, g_turret_G2, g_turret, g_target | 59 | 42 | 14 | 3 | `holes-g_saga-turrets-g_target.md` |
| NPC_AI_Wampa, Rancor, Seeker, ImperialProbe, Howler, MineMonster, Mark1, Mark2 | 47 | 47 | 0 | 0 | `holes-NPC_AI-beasts.md` |
| NPC_misc, NPC_behavior, NPC_AI_Stormtrooper, NPC_AI_Utils, NPC, NPC_combat, NPC_move | 40 | 36 | 4 | 0 | `holes-NPC-core.md` |
| NPC_AI_Interrogator, GalakMech, Sniper, Sentry, Remote, Droid, Grenadier | 28 | 25 | 3 | 0 | `holes-NPC_AI-droids.md` |

The gate passed, 0 errors and 112 tests, and `tools/load-test.sh` exits with status 0. The Port-note count fell from 496 to 246. The commit is `5e99704`.

### The blocked holes

- g_nav: the four `fatalErrorPointer` holes need the write-cursor form, and `GameVariables.fatalErrorPointer` is a `String`, so the fill needs a generator change. The three `minDist` reads wait on the `minDist` declaration, row P2.
- ai_util: the four `placesecond` holes need to know whether `strstr` over a suffix subscript returns an offset from the suffix or from the whole buffer, a fact in `CString.swift` and `CharBuf.swift`.
- g_saga: the `carrier` pass in `SiegeItemRespawnOnOriginalSpot` needs a `rulings.py` entry that makes the parameter optional, because Raven's callee tests it. The two `G_SpawnVector` calls meet an `inout Float` signature where Raven passes a `vec3_t`, same ground as L3.

### Findings

- The fills of `trap_Nav_GetBestNodeAltRoute2` and `trap_Nav_GetBestPathBetweenEnts` had no `sig` row and took the shape of the sibling trap. The build accepted them.
- The lookup tool warned that 40 stub signatures are stale, which the manifest regenerate closes.
- `AI_SortGroupByPathCostToEnemy` keeps Raven's `k++` loop that tests `k > j`, which runs past slot 31 in C too, so the Swift traps on the same path.

### Docket rows

| Row | Hole | Proposed form |
| --- | --- | --- |
| O1 | `RemoveWP` and `RemoveWP_InTrail`: a `memset` of `sizeof` a pointer, a partial size. | A pointer-width ruling. |
| O2 | `SavePathData`: a `NULL` store before the `B_TempAlloc` store stops the `CharBuf` form on `fileString`. | The `CharBuf` form allows a prior `NULL` store that no read follows. |
| O3 | `AcceptBotCommand`: no byte-walk form for a `String?` local. | The local takes a `CharBuf` at its store, same ground as D4. |
| O4 | `BotUpdateInput`: `trap_EA_GetInput` needs an overload for its `void *` parameter. | An overload that takes the view. |
| O5 | `BotAI`: a `(Int32, String)` trap in a `while` test, and a pointer into `buf` passed to an `inout CharBuf`. | Two guide lines, one per shape. |
| P1 | Five compares of a `byte` field with `qfalse`, `trace.startsolid == qfalse`. | `qfalse` reads `0` and `qtrue` reads `1` at the compare. Same ground as E2 and H2. |
| P2 | `unsigned int minDist = MAX_RADIUS_CHECK + 1`, an `int` into an `unsigned` local. | `UInt32(...)` at the store, the mirror of the float-into-int rule. |
| Q1 | A byte read through the text of a `char *` field, `model` and `message`, which the view gives as `String?`. | `CharBuf(field!)` at the site, then the byte subscript. |
| Q2 | A pointer that picks one of the `boneIndexN` or `boneAnglesN` fields. | An `Int32` index local and switch helpers. Same ground as F2 and J5. |
| Q3 | A `continue` inside a scratch closure that spans the loop body. | The `continue` is a closure `return`, and the step follows the closure. Same ground as F3 and M3. |
| Q4 | A post-increment in an expression. | Read the variable, then step it after the statement. Same ground as D5 and I4. |
| S1 | `NPC_GM_Pain`, `if ( point )`: the test reads the address of a local array, always true, and the arm holds only comments. | Drop the test and keep the arm's lines. |
| S2 | `Sniper_FaceEnemy` and `Sniper_UpdateEnemyPos`: `enemyLaggedPos` as `Slots<Slots<Float>>`. | A `<name>Vectors: Slots<vec3_t>` accessor. Same ground as D8 and M2. |
| T1 | `AI_InsertGroupMember`: a post-increment inside an index. | Read `numGroup`, then `group.numGroup += 1`. Same ground as D5. |
| T2 | `NPC_CollectCombatPoints` and `NPC_FindSquadPoint`: an int compared with `qfalse`. | `== 0`. Same ground as E2. |
| T3 | `NPC_CollectCombatPoints`: `occupied == (int) qtrue` on a `Bool` field. | The cast drops, and the test is `occupied == true`. |

## The review of wave 2B

Two reviewers read every fill of the working tree before the commit, 250 fills: 101 in the bot and navigation files, 149 in the siege, turret, target, and NPC files. The records are `review-wave2B-bot-nav.md` and `review-wave2B-npc-siege.md`. The `G_AddBot` early-out matches Raven and jka-rust, and the dropped `(float*)` cast of `NPC_Seeker_Pain` only removed `const`.

| Severity | Count |
| --- | --- |
| behavior | 1 |
| form | 2 |
| style | 3 |

| Row | Finding | Proposed fix |
| --- | --- | --- |
| R9 | g_target, `target_random_use`: the fill passes `self.target!` to `G_Find`. Raven's `G_Find` takes a NULL `match`, because `Q_stricmpn` returns 1 for a NULL second argument, so a `target_random` with no `target` key returns at `if (!t_count)`. The Swift traps at the unwrap. | `G_Find` takes a `String?` match and answers nil for nil, or the caller guards. A ruling. |
| R10 | ai_wpnav, `G_RMGPathing`: Raven's `!terrain \|\| ...` prints an error before the early return. The fill writes `terrain == nil \|\| ...` and eight `terrain!` reads. The guide gives `guard let` for an early-out, and a guard that does work on the NULL path keeps a Port-note. | A guide line for an early-out with work on the NULL path. |
| R11 | g_saga, `InitSiegeMode`: Raven's `!levelname` test drops with no comment. | One comment line that names the dropped test, under the never-null rule. |
| R12 | g_nav, `NAV_TestBestNode`: Raven's `fabs(...) > 48` is a `Float` `abs`, where the double-math rule wants `Double`. The file uses the form at two other lines. | `abs(Double(...)) > 48`. |
| R13 | g_nav, `NAV_CalculatePaths`: the Port-note for `if (!tempWaypointList) return;` drops with no line, allowed by the never-null rule for a static array. | One comment line that names the dropped test. |
| R14 | NPC_AI_Rancor, `Rancor_Attack`: two trailing `//, HL_NONE );` comments of Raven's dropped. | Write them back. |
