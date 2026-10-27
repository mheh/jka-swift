# The plan of phase 2 of the rulings build

This plan covers task 2 of `HANDOFF.md`. Part A lists the units that the ruled rows order and puts them into one wave of seven transcriptors. Part B counts the standing Port-notes and puts a hole round over them into one wave of seven transcriptors after wave A lands. Part C lists the unruled choices of the phase 1 records as the docket of the next ratification walk. The line numbers are the lines of `wave-0` at a1b6196.

Each transcriptor brief has the shape of the frame-path waves in `frame-path-round.md`. A transcriptor reads only its files, their oracle slices, their manifests, the state file `Sources/JKAMP_GameLogic/g_local.swift`, the guide `docs/transcription.md`, and the lookup tool `tools/oracle-closure/lookup.py`. It never builds, never edits `g_local.swift` or the guide, and lists the `GameWorld` properties the coordinator must add. It writes one hole table record in `notes/<date>/`, one row per unit with the function, the line before the edit, the row, and the verdict filled, stands, or blocked. The coordinator gates the wave with `swift build`, `swift test --no-parallel`, and `tools/load-test.sh`, then one review leg reads every change against Raven's C and the jka-rust range before the commit.

## Part A, the wave table

### The units

The kind column reads "fill" for a hole that a ruled form now covers, "hand" for a hand change of committed code under a ruled row, and "caller" for a caller update that follows a signature change.

| Unit | File and line | Row | Kind |
|---|---|---|---|
| A-01 | `NPC_utils.swift:665`, `:682`, `G_ActivateBehavior` | G1, J4 | fill |
| A-02 | `g_saga.swift:1641`, `:1644`, `SP_misc_siege_item` | L3 | fill |
| A-03 | `w_saber.swift:458`, `:488`, `:497`, `:508`, `:513`, `:595`, `alwaysBlock` in `SetSaberBoxSize` | E1 | fill |
| A-04 | `w_saber.swift:1010`, the `vec3_origin` copy into `BG_IK_MoveArm` | E3 | fill |
| A-05 | `w_saber.swift:2102` to `:2198`, `d1` and `d2` in `G_BuildSaberFaces`, 22 holes, and the drop of the copies `var fwd = fwd` at `:2111` and `var right = right` at `:2113` | E4 | fill |
| A-06 | `w_saber.swift:4869`, the `dot1` store in `WP_SaberStartMissileBlockCheck` | E5 | fill |
| A-07 | `g_items.swift:2134`, the `RespawnItem` walk | F4 | fill |
| A-08 | `g_ICARUScb.swift:1294`, `:1298`, `Q3_GetAnimBoth` arm | H1 | fill |
| A-09 | `NPC_AI_Jedi.swift:1991`, `baseTime = baseTime` | I2 | fill |
| A-10 | `NPC_senses.swift:657`, `:698`, the alert-table `memmove` | I5 | fill |
| A-11 | `NPC_spawn.swift:960`, the `VectorCopy` of `ucmd.angles` | J2 | fill |
| A-12 | `g_vehicles.swift:2122` to `:2209`, `surfName`, 13 holes | M1 | fill |
| A-13 | `ai_wpnav.swift:498`, `:556`, `:568`, `RemoveWP` and `RemoveWP_InTrail` | O1 | fill |
| A-14 | `g_nav.swift:1200`, `:1208`, `:1212`, `:1218`, `minDist` in `waypoint_getRadius` | P2 | fill |
| A-15 | `NPC_combat.swift:2208`, the `occupied` test | T3 | fill |
| A-16 | `SpeederNPC.swift:253-254`, Raven's `0` as `false` | R6 | hand |
| A-17 | `NPC_AI_Rancor.swift:509`, `:551`, the two `HL_NONE` comments in `Rancor_Attack` | R14 | hand |
| A-18 | `FighterNPC.swift:579`, `:593`, `:601`, `:606`, the `hackingTime` stores | N1 | hand |
| A-19 | `g_items.swift:2388`, `respawn += crandom() * ent->random` | N1 | hand |
| A-20 | `g_combat.swift:4333`, `:4335`, the `forcePower` stores | N1 | hand |
| A-21 | `w_saber.swift:1961`, `:3840`, `:4337`, `totalDamage` and `dmg` | N1 | hand |
| A-22 | `g_active.swift:303`, `splashRadius` | N1 | hand, no change, see note 2 |
| A-23 | `g_weapon.swift:1429`, `:1868`, `damage` and `vel` | N1 | hand |
| A-24 | `NPC_combat.swift:130`, `attDelay` | N1 | hand, see note 3 |
| A-25 | `g_mover.swift:2307`, `numChunks` | N1 | hand |
| A-26 | `NPC_AI_Jedi.swift:3122`, the `_VectorMA` in `Jedi_SetEnemyInfo` | R1 | hand |
| A-27 | `g_ICARUScb.swift:78`, `G_DebugPrint`, and the four force unwraps of the same ground at `:1827`, `:1831`, `:1835`, `:1839` | R2 | hand |
| A-28 | `ai_wpnav.swift:2498-2502`, the early-out of `G_RMGPathing`, and the 11 `terrain!` reads after it | R10 | hand |
| A-29 | `g_utils.swift:270`, the `G_Find` signature to `_ match: String?` | R9 | hand |
| A-30 | `g_target.swift:42`, `:410`, `:689`, `:709` | R9 | caller |
| A-31 | `g_trigger.swift:1390`, `:1500`, `:1513`, `:1542`, `:1683`, `:1696`, `:1702` | R9 | caller |
| A-32 | `g_misc.swift:2030`, `:2048`, `:2718`, `:2815` | R9 | caller |
| A-33 | `g_mover.swift:1792`, `:1823` | R9 | caller |
| A-34 | `g_local.swift:148`, `modNames` to `[String?]` with three `nil` rows under the guide line 448 form | U2, C1 | hand, coordinator only |
| A-35 | `g_combat.swift:9-11`, the `modNames` accessor type | U2, C1 | caller |
| A-36 | `g_log.swift:277`, `:679`, `:736`, `modNames[j] ?? "(null)"` | U2, C1 | caller |
| A-37 | `g_combat.swift:1969`, `:1973`, the quotient and the `obit` read in `player_die` | C1 | fill |
| A-38 | `g_main.swift:1648`, the `SortRanks` signature to `(_ a: Int32, _ b: Int32) -> Int32`, and its holes `:1652`, `:1655` | A1, D6 | hand and fill |
| A-39 | `g_main.swift:1847`, the `qsort` caller in `CalculateRanks` | A1, D6 | fill |
| A-40 | `g_team.swift:1065`, the `SortClients` signature to `(_ a: Int32, _ b: Int32) -> Int32`, and its hole `:1066` | A1, D6 | hand and fill |
| A-41 | `g_team.swift:1115`, the `qsort` caller of `SortClients` | A1, D6 | fill |
| A-42 | `NPC_combat.swift:1315`, `:1322`, `:1434`, `:1442`, eight `?? ""` arguments to `?? "(null)"` | R2, guide line 339 | hand, see V14 |
| A-43 | `g_main.swift:1996`, the `FindIntermissionPoint` hole | A2, R9 | fill |

The 17 "Hole fills that can run now" are A-01 to A-17. N1 is A-18 to A-25, four FighterNPC lines and eleven other lines. R9 is A-29 to A-33. U2 is A-34 to A-36. The sort comparators are A-38 to A-41.

### Notes on the units

1. A-37 is outside the list of task 2. It is the C1 ruling over the same table as U2, so it goes with the transcriptor of U2. The new `modNames.count` counts the three `nil` rows, and the C1 verdict puts a two-line note at the read.
2. A-22 is in the grep of `Int32(Float(`, but Raven wrote the cast at `g_active.c:332`, `(float)(self->r.maxs[0] - self->r.mins[0])/4.0f`, and the store is not a compound store. The line keeps its form. The transcriptor confirms this and records it as "no change".
3. A-24 is `attDelay += floor( ... )` at `NPC_combat.c:134`. C's `floor` returns a `double`, so the N1 form and the double-math rule of the guide meet at this site. The transcriptor records the form it chose, or the coordinator gives one in the brief.
4. A-34 edits the state file, which no transcriptor edits. The coordinator writes it before the wave or with the gate, and A-35 and A-36 compile only with it.
5. The R9 verdict names 14 other calls of the `x.target!` shape in four files. The grep gives 15 calls of `.target!` or `.target2!` beside the two sites of `target_random_use`, A-30 to A-33. Eight more calls pass a force-unwrapped `String?` of another field: `g_mover.swift:1261`, `:1268`, `:1306`, `:1316` (`targetname!`), `ai_wpnav.swift:1565` (`targetname!`), `g_saga.swift:1497` (`paintarget!`), `g_client.swift:700` (`classname!`), and `g_utils.swift:563` (`string!`). The ruling text does not name them. The plan leaves them as they are until the coordinator decides.
6. The `String` to `String?` change of A-29 compiles with every caller as it stands, so A-30 to A-33 do not break the build if they lag. They stay with A-29 in one transcriptor all the same.
7. R1 names three `_VectorMA` sites of the same ground. The grep for a `Float(Double(` or `Float(... * 0.x)` scale finds only A-26.
8. A-42 rests on guide item 4 of `rulings-build-guide.md`, which is unruled. See V14 in Part C.

### The wave

One wave of seven transcriptors on disjoint files covers every unit. No file belongs to two transcriptors.

| Transcriptor | Files | Units |
|---|---|---|
| saber | `w_saber.swift`, `g_active.swift` | A-03, A-04, A-05, A-06, A-21, A-22 |
| find | `g_utils.swift`, `g_target.swift`, `g_trigger.swift`, `g_misc.swift`, `g_mover.swift` | A-25, A-29, A-30, A-31, A-32, A-33 |
| sort | `g_main.swift`, `g_team.swift` | A-38, A-39, A-40, A-41, A-43 |
| npc | `NPC_utils.swift`, `NPC_AI_Jedi.swift`, `NPC_senses.swift`, `NPC_spawn.swift`, `NPC_combat.swift`, `NPC_AI_Rancor.swift` | A-01, A-09, A-10, A-11, A-15, A-17, A-24, A-26, A-42 |
| icarus-log | `g_ICARUScb.swift`, `g_combat.swift`, `g_log.swift`, and the coordinator's line in `g_local.swift` | A-08, A-20, A-27, A-34, A-35, A-36, A-37 |
| vehicles | `FighterNPC.swift`, `SpeederNPC.swift`, `g_vehicles.swift` | A-12, A-16, A-18 |
| bot-items | `ai_wpnav.swift`, `g_nav.swift`, `g_items.swift`, `g_saga.swift`, `g_weapon.swift` | A-02, A-07, A-13, A-14, A-19, A-23, A-28 |

The wave fills 70 Port-notes: 62 in the 15 hole fills, 5 in the sort units, 1 in A-43, and 2 in A-37. The count falls from 246 to 176.

## Part B, the new hole round

### The standing Port-notes

`grep -c "Port-note:"` over `Sources/JKAMP_GameLogic` gives 246 Port-notes in 33 files at a1b6196. The third column subtracts the fills of wave A. After wave A, 176 Port-notes stand in 32 files, and `g_vehicles.swift` has none.

| File | Now | After wave A |
|---|---|---|
| `w_saber.swift` | 38 | 8 |
| `NPC_spawn.swift` | 23 | 22 |
| `g_main.swift` | 14 | 10 |
| `g_vehicles.swift` | 13 | 0 |
| `g_nav.swift` | 13 | 9 |
| `ai_wpnav.swift` | 12 | 9 |
| `g_svcmds.swift` | 11 | 11 |
| `g_items.swift` | 10 | 9 |
| `g_active.swift` | 10 | 10 |
| `NPC_utils.swift` | 9 | 7 |
| `g_vehicleTurret.swift` | 8 | 8 |
| `g_turret_G2.swift` | 8 | 8 |
| `g_weapon.swift` | 7 | 7 |
| `g_ICARUScb.swift` | 7 | 5 |
| `g_utils.swift` | 6 | 6 |
| `NPC_AI_Jedi.swift` | 5 | 4 |
| `g_target.swift` | 5 | 5 |
| `g_session.swift` | 5 | 5 |
| `NPC_stats.swift` | 4 | 4 |
| `NPC_senses.swift` | 4 | 2 |
| `g_saga.swift` | 4 | 2 |
| `g_combat.swift` | 4 | 2 |
| `ai_util.swift` | 4 | 4 |
| `NPC_combat.swift` | 3 | 2 |
| `g_team.swift` | 3 | 1 |
| `g_misc.swift` | 3 | 3 |
| `g_cmds.swift` | 3 | 3 |
| `ai_main.swift` | 3 | 3 |
| `NPC_AI_Sniper.swift` | 2 | 2 |
| `g_client.swift` | 2 | 2 |
| `NPC_AI_Utils.swift` | 1 | 1 |
| `NPC_AI_GalakMech.swift` | 1 | 1 |
| `g_mover.swift` | 1 | 1 |
| Total | 246 | 176 |

### The forms the holes now have

The sample reads `holes-w_saber.md`, the docket table of `frame-path-round.md`, and the Port-note reason texts that stand in the code. The reason texts fall into two large groups.

The first group is 121 holes of the pointer-local shape, "A pointer local", "A read of", and "A store into". After wave A, 77 of them stand, and four rulings give a form to about 70 of them:

- 21 in `NPC_spawn.swift`, the `func` locals of pain and touch callbacks, take the thunks of J1 that `skeleton.py` now writes into `Callbacks.swift`.
- 21 in `g_items.swift`, `g_turret_G2.swift`, and `NPC_utils.swift`, the `thebone`, `firstFree`, `boneVector`, and `freeBoneVec` locals with their pointer dereferences, take the J5 shape of conflict 4 through `EntityState+Bones.swift`.
- About 20 text locals, `fileString` in `ai_wpnav.swift`, `s` and `str` in `g_utils.swift`, `s` and `t` in `g_svcmds.swift`, `args` in `ai_main.swift`, and `crap` and `morecrap` in `g_main.swift`, take guide line 622 (D4, O3, Q1), the drafter rule of O2, and guide lines 419-420 (B6) for `vtos`.
- Five `pm` holes of `g_active.swift` take guide lines 323 (A4), 552 (A5), and 539 (A6), and the four `trace` and `pointcontents` stores take the thunk of ruling W4.

The second group is 75 holes where the draft did not compile. The largest share, about 20, is a binary operator over `Int32` and `Bool`, which guide lines 539 (A6, F1) and 540 (E2, H2, P1, T2) cover with the `Bool(Int32)` initializer of D3 and I1. Smaller shares take line 554 (N1), line 555 (R5), lines 545-546 (B1) for the three "unable to type-check" and "failed to produce diagnostic" sites, and lines 623-624 (D5, I4, Q4, T1) for the five "A ++ inside an expression" holes. The four "Raven's block leaves a loop outside the record's scope" holes take lines 367-369 (F3, M3, Q3, I3).

Some holes still have no form: the six `G2Trace` holes of `w_saber.swift`, which wait on a type outside the read set, the four `boltMatrix` holes of `g_weapon.swift`, which take the `MdxaBone.scratch` form by ruling W3, and the five holes of the rule 11 `char *` field shape. The transcriptors record these as blocked again.

### The wave

One wave of seven transcriptors on disjoint files covers the 176 holes. Each transcriptor holds files of one area, so the oracle slices stay small.

| Transcriptor | Files | Holes |
|---|---|---|
| combat | `w_saber.swift` 8, `g_active.swift` 10, `g_weapon.swift` 7, `g_combat.swift` 2 | 27 |
| spawn | `NPC_spawn.swift` 22, `NPC_utils.swift` 7 | 29 |
| main | `g_main.swift` 10, `g_svcmds.swift` 11, `g_session.swift` 5 | 26 |
| bones | `g_items.swift` 9, `g_turret_G2.swift` 8, `g_vehicleTurret.swift` 8 | 25 |
| bot | `g_nav.swift` 9, `ai_wpnav.swift` 9, `ai_util.swift` 4, `ai_main.swift` 3 | 25 |
| npc | `g_ICARUScb.swift` 5, `NPC_stats.swift` 4, `NPC_AI_Jedi.swift` 4, `NPC_senses.swift` 2, `NPC_combat.swift` 2, `NPC_AI_Sniper.swift` 2, `NPC_AI_Utils.swift` 1, `NPC_AI_GalakMech.swift` 1 | 21 |
| entities | `g_utils.swift` 6, `g_target.swift` 5, `g_misc.swift` 3, `g_cmds.swift` 3, `g_client.swift` 2, `g_saga.swift` 2, `g_team.swift` 1, `g_mover.swift` 1 | 23 |

## Part C, the unruled rows

Each row is one choice that no proof gave and that no ruling closed. The proposed answer is the choice the builder made. Rows that ask the same question are one row, and the source column names each record.

| Row | Source | Question | Proposed answer |
|---|---|---|---|
| V1 | `rulings-build-helpers.md:23` | Where does the `at:` overload of `RemoveColorEscapeSequences` (O5) live, since the function is internal to `JKAMP_GameLogic`? | Beside the function in `ai_main.swift`, as the D7 proof puts its forward beside `G_RadiusList`. |
| V2 | `rulings-build-helpers.md:24` | How does the `at:` overload of `Com_sprintf` (L2) pass on its variadic list, which Swift cannot forward? | It formats the text once with `format(fmt, args)` and passes it to the base form under `"%s"`, with one comment line that names this. |
| V3 | `rulings-build-helpers.md:25` | Does the `Slots<Int32>` overload of `qsort` (A1) take the table by value or `inout`? | By value, because `Slots` has a `nonmutating` setter, so the call reads `qsort(level.sortedClients, level.numConnectedClients, SortRanks)` with no `&`, and the body sorts a copy and writes back the first `n` slots. |
| V4 | `rulings-build-helpers.md:26` | What does the list `sscanf` (D2) return when the input ends before the first conversion, where C returns -1? | 0, because Raven's one caller does not read the result. |
| V5 | `rulings-build-helpers.md:27` | How strict is the list `sscanf` (D2) about its format, and how does `%s` read? | A `precondition` that every token is `%i` or `%s` and that the target counts match, and `%s` reads the bytes up to the next whitespace as UTF-8 text. |
| V6 | `rulings-build-helpers.md:28` | Where does `Bool.init(_ value: Int32)` (D3, I1) live? | A new file `Bool+Int32.swift` in `JKAShared`, on the model of `Int32+Ascii.swift`. |
| V7 | `rulings-build-helpers.md:29` | Where do the native-byte helpers (L1) live, and what does the unpack do with an array that does not hold four bytes? | A new file `NativeBytes.swift`, and the unpack traps on any other length. |
| V8 | `rulings-build-helpers.md:30` | Where does `pointOrientation(at:)` (J3) live, and what does it take? | A new file `Vehicle+Orientation.swift`, an extension on `Vehicle` that takes the `PlayerState` view. |
| V9 | `rulings-build-helpers.md:31` | What count type does `CharBuf.zero(count:)` (B5) take, and what happens past the end? | Any `BinaryInteger`, so `MAX_STRING_CHARS` passes with no cast, and a count past the end traps. |
| V10 | `rulings-build-helpers.md:32` | Which Raven line does the `Source:` line of the `Q_stricmp(String?, String?)` overload (R9) cite? | `q_shared.c:900`, the line of the function, as the other overloads cite, not the body line 901 of the proof. |
| V11 | `rulings-build-guide.md:29` | Where does the compound store form of N1 go, since the walk record names line 542 and the `float` into `int` rule stood at line 543? | On the `float` into `int` rule, now line 556, and line 542, the `Double` conversion rule, stays as it was. |
| V12 | `rulings-build-guide.md:30` | Do the words "the mirror of the next rule" on the `float` into `int` line still point at the right line after A5 and B4 put two lines before it? | Yes, they still point at the `int` into `float` line, and the text stays. |
| V13 | `rulings-build-guide.md:31`, `review-rulings-build-1.md:70` (finding 3) | Does the R10 form at guide line 342 replace the sentence "A guard that does other work on the NULL path keeps a Port-note.", and what, if anything, still keeps that Port-note? | The new form replaces the sentence, because it covers the case, and no case keeps the Port-note. |
| V14 | `rulings-build-guide.md:32`, `review-rulings-build-1.md:86` (unruled 1) | Does `?? "(null)"` at guide lines 339-340 cover the `Debug_Printf` runtime-test case too, with no rule 19 note at the read, so the eight `?? ""` arguments at `NPC_combat.swift:1315`, `:1322`, `:1434`, `:1442` change? | Yes, the case takes `?? "(null)"` with no note, and line 340 keeps the case as a reason. Phase 2 unit A-42 then changes the four lines. |
| V15 | `rulings-build-guide.md:33` | Does the B5 line join the old partial-size Port-note sentence into its next line? | Yes, the next line reads "A memset over any other partial size ...". |
| V16 | `rulings-build-guide.md:34` | Does the B6 line say that the index of `index_vtos` drops with its world property and its forward? | Yes, the line says so and keeps the one comment line of line 421. |
| V17 | `rulings-build-guide.md:35` | Where does the `char *` field form of Q1 go? | On line 622 beside the local form, with the bind on the arm where Raven reads the field. |
| V18 | `rulings-build-guide.md:36`, `review-rulings-build-1.md:66` (finding 1), `rulings-build-generators.md:96` (fix 1) | Does the A5 line say anything about `size` against `stride`? | After the review, the line says that `byteCount` is `MemoryLayout<T>.size`, that C's `sizeof` is Swift's `stride`, that the form holds only where the two are equal, and that for `gentity_t` both are 1832. |
| V19 | `rulings-build-generators.md:83` | How does the A2 entry key a variable in `TYPES`, a table that held typedef names only? | The entry keys the variable name in the same table, and `map_variable` reads it before every other shape. |
| V20 | `rulings-build-generators.md:84` | What shape does the A1 and D6 sig ruling take in `rulings.py`? | A new `PARAMS` kind `int_value` with one row per parameter, four rows, not a set of comparator names. |
| V21 | `rulings-build-generators.md:85` | Does a function-pointer local whose type fits more than one callback field, such as `think` and `reached`, get a J1 thunk? | No, it names no field and gets no thunk. |
| V22 | `rulings-build-generators.md:86` | Does the O4 overload copy the syscall body or forward to the first overload, and which callers does the rule check? | It forwards with `input.handle`, it reads Raven's comment from the parameter text, and it checks the game unit's callers only. |
| V23 | `rulings-build-generators.md:87` | Does the H3 and R4 row accessor go on every `char[M][N]` field or on a named list? | On every `char[M][N]` field, two today. |
| V24 | `rulings-build-generators.md:88` | What does the R7 drafter rule need before a `gentity_t *` local drafts as a plain `Entity`? | An initializer that is a slot address, so a local with no initializer stays `Entity?`, and a compare with a non-NULL value and a return count as non-NULL reads. |
| V25 | `rulings-build-generators.md:89` | How does the O2 drafter rule test that no read reaches a NULL store before the allocator store? | By source offset: every NULL store stands before the first allocator store, no read stands between them, and a NULL initializer on the declaration fits the same way. |
| V26 | `rulings-build-generators.md:90`, `review-rulings-build-1.md:92` (unruled 7) | Do the drafter changes need a `draftcheck.py` run and a `snapshot.py --check` before they count as done, since they move the drafts of other stems, such as the 136 `Entity?` locals of R7? | No run, because the brief named neither. |
| V27 | `review-rulings-build-1.md:72` (finding 4) | Does the change of row X1 in `notes/2026-10-09/load-test-walk.md:73` from "open" to "ratified as proposed" stand, though no row of the frame-path docket orders it and no record names the ruling? | It stands, in the records commit. |
| V28 | `review-rulings-build-1.md:87` (unruled 2), `:88` (unruled 3) | Do the sig table and the compiled code disagree until phase 2, for `SortRanks` at `g_main.swift:1648`, `SortClients` at `g_team.swift:1065`, and `G_Find` at `g_utils.swift:270`? | Yes, and phase 2 changes the three compiled signatures, units A-29, A-38, and A-40. |
| V29 | `review-rulings-build-1.md:89` (unruled 4) | Does the phase 1 commit carry the manifest changes from earlier commits, `public` on `g_entities` and `gSharedBuffer`, the marker counts, and the shifted line numbers in 64 files? | Yes, as the plain output of `manifest.py`. |
| V30 | `review-rulings-build-1.md:90` (unruled 5) | Does `HANDOFF.md` stay untracked at the root until phase 2 is committed and reviewed? | Yes, it stays out of the phase 1 commit, and the session deletes it after task 2. |
| V31 | `review-rulings-build-1.md:91` (unruled 6) | Does the R3 drafter rule take every local array of `short`, `unsigned short`, `signed char`, or `unsigned char`, or only `byte`, which the proof names? | Every narrow type, so a `short` array drafts as `[Int16]`. |
