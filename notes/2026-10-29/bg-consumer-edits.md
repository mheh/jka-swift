# The bg consumer edits

This record holds the code rows of `notes/2026-10-29/bg-consumer-docket.md`, which the user ratified as proposed, rows C1 to C9. Rows C3, C4, C5, and C7 item 1 change code. Rows C1, C2, C6, C8, and C7 items 2 and 3 need no code. Row C9 is its own docket. The tree is the worktree `/tmp/jka-bgedits` on branch `bg-consumer-edits`, off master at 3a7e90e.

## The commits

| Commit | Subject |
|---|---|
| 85769f7 | The rule 23 test at the game arms Raven gives cgame nothing |
| 3f96dc0 | The cgame and ui arms of the bg asset registrations |
| 0b86d1b | The switch form of a bg consumer chain in rule 23 |
| 24ff2fb | The cgame read callbacks of BG_MySaber on the bg channel |
| a9ce96a | The cgame arms of the bg logic chains |
| acdd020 | The bg state files of the cgame and ui anim event block |
| 07ea3f9 | The anim event type and footstep type tables as C storage |
| ce4dba8 | The cgame and ui anim event parse in bg_panimate |
| 7015ec4 | The cgame Pmove test of the bg consumer |

## C3, the game arms Raven gives cgame nothing

Each of the 13 arms stands under `if bg.consumer == .game`. Where Raven's arm is an `else if` clause, or the `else` of a landing test, the test joins the condition. The closures stay game closures. Raven's trailing comment on the `#ifdef QAGAME` line stands on the `if` line, where Raven wrote one.

| Raven | Swift after the edit |
|---|---|
| `bg_panimate.c:2610-2616` | `bg_panimate.swift:2175` |
| `bg_panimate.c:2677-2683` | `bg_panimate.swift:2241` |
| `bg_pmove.c:776-783` | `bg_pmove.swift:667` |
| `bg_pmove.c:842-847` | `bg_pmove.swift:734` |
| `bg_pmove.c:6649-6664` | `bg_pmove.swift:5967` |
| `bg_pmove.c:7395-7404` | `bg_pmove.swift:6534` |
| `bg_pmove.c:10887-10901` | `bg_pmove.swift:9200` |
| `bg_pmove.c:10919-10922` | `bg_pmove.swift:9224` |
| `bg_saber.c:1118-1121` | `bg_saber.swift:774` |
| `bg_slidemove.c:128-133` | `bg_slidemove.swift:74` |
| `bg_slidemove.c:313-398` | `bg_slidemove.swift:214` |
| `bg_slidemove.c:724-732` | `bg_slidemove.swift:567` |
| `bg_vehicleLoad.c:685-688` | `bg_vehicleLoad.swift:329` |

## C4, the asset registrations

A chain on `QAGAME` with two arms is `if bg.consumer == .game { } else { }`. A chain with more than two arms, or with a `CGAME` test, is a `switch bg.consumer` with one case per Raven arm, in Raven's order. A consumer with no arm gets `case .game: break` or `case .ui: break`. A game arm that is only a comment keeps the comment, and in a `switch` the case adds `break` after it, because Swift takes no case without a statement. The cgame and ui arms call the traps of `bg_strap.swift` by Raven's names.

| Raven | Swift after the edit |
|---|---|
| `bg_saberLoad.c:34-38`, `BG_SoundIndex` | `bg_saberLoad.swift:33` |
| `bg_saberLoad.c:1804-1810`, `:1822-1828` | `bg_saberLoad.swift:1432`, `:1451` |
| `bg_saberLoad.c:2073-2079`, `:2090-2096`, `:2107-2113`, `:2124-2130` | `bg_saberLoad.swift:1660`, `:1678`, `:1696`, `:1714` |
| `bg_saberLoad.c:2215-2221`, `:2233-2239` | `bg_saberLoad.swift:1792`, `:1811` |
| `bg_saberLoad.c:2484-2490`, `:2501-2507`, `:2518-2524`, `:2535-2541` | `bg_saberLoad.swift:2020`, `:2038`, `:2056`, `:2074` |
| `bg_saga.c:997-1009` | `bg_saga.swift:774-780` |
| `bg_saga.c:1268-1275` | `bg_saga.swift:1027` |
| `bg_vehicleLoad.c:232-289`, the eight field types of the weapon parse | `bg_vehicleLoad.swift:118`, `:125`, `:132`, `:144`, `:157`, `:169`, `:174`, `:181` |
| `bg_vehicleLoad.c:392-408`, the homing sounds | `bg_vehicleLoad.swift:270` |
| `bg_vehicleLoad.c:906-963`, the eight field types of the vehicle parse | `bg_vehicleLoad.swift:538`, `:545`, `:552`, `:564`, `:577`, `:589`, `:594`, `:601` |
| `bg_vehicleLoad.c:1264-1268` | `bg_vehicleLoad.swift:820` |
| `bg_vehicleLoad.c:1293-1299` | `bg_vehicleLoad.swift:832`, beside the SP comments |
| `bg_vehicleLoad.c:1308-1312`, `:1316-1322`, `:1327-1333`, `:1336-1359` | `bg_vehicleLoad.swift:843`, `:855`, `:868`, `:880` |

A `#ifndef QAGAME` chain with one arm, `VF_SHADER_NOMIP` and the skin of `bg_vehicleLoad.c:1293`, is `if bg.consumer != .game { }`, the test the directive states.
Raven's `if ( !classShader ) { print } else` at `bg_saga.c:1001-1007` runs the block after it on the game path and on the cgame and ui path when the shader registered. The Swift body holds the two arms of the chain, then `if bg.consumer != .game && classShader == 0 { print } else { block }`.
The skin arm passes `vehicleInfo.model ?? "(null)"` to `va`, the form `g_log.swift:344` takes for a `char *` that can be NULL under `%s`.

`BG_SoundIndex` gives the ui 0, with this note at `bg_saberLoad.swift:41-42` under rule 19:

```swift
// Port-note: Raven compiles no return for the ui, so the ui reads an undefined value.
// The ui gets 0.
```

### The rule 23 sentence

Rule 23 at `docs/porting-rules.md:48` and the `#ifdef` section at `docs/transcription.md:573` hold this sentence:

> A chain with more than two arms, or with a `CGAME` test, is a `switch bg.consumer` with one `case` per Raven arm in Raven's order, `case .game, .ui:` where Raven's `#else` covers both, and `case .game: break` for a consumer with no arm.

## C5, the logic arms

| Raven | Swift after the edit | The cgame arm |
|---|---|---|
| `bg_pmove.c:6699-6712` | `bg_pmove.swift:6009` | `vehicleRocketLock` and `BUTTON_ATTACK` when a vehicle weapon is homing |
| `bg_pmove.c:7478-7488` | `bg_pmove.swift:6576` | `return` |
| `bg_pmove.c:10944-11019` | `bg_pmove.swift:9242` | `BG_FighterUpdate` at `:9262`, the pilot, the orientation, `PM_SetPMViewAngle`, the move direction |
| `bg_saber.c:1172-1184` | `bg_saber.swift:824` | `PM_SetAnim` on the local player |
| `bg_saber.c:1200-1204` | `bg_saber.swift:850` | the test on `duelist->clientNum` |
| `bg_saber.c:1213-1217` | `bg_saber.swift:858` | the same test |
| `bg_saber.c:4103-4138`, `BG_MySaber` | `bg_saber.swift:3164` | the reads of `cgs.clientinfo` and of `npcClient` |
| `bg_slidemove.c:55-107` | `bg_slidemove.swift:21`, `:29`, `:54` | the landing test only |
| `bg_slidemove.c:197-201` | `bg_slidemove.swift:113` | `hitEntity.s.origin` |
| `bg_slidemove.c:218-229` | `bg_slidemove.swift:138` | scales `bounceDir` into `bounceDir`, Raven's text |
| `bg_slidemove.c:402-554` | `bg_slidemove.swift:288` | `trap_FX_PlayEffectID` at `:420` and `VEH_CRASHING` |

The four cgame-only names of the cgame arms resolve: `BG_FighterUpdate` at `bg_callbacks.swift:185`, `CG_GetVehicleCamPos` at `bg_callbacks.swift:196`, `PM_SetPMViewAngle` as the bg body at `bg_pmove.swift:1224`, and `trap_FX_PlayEffectID` at `bg_strap.swift:201`. No arm is a marker.

The condition of `bg_saber.c:1200` and `:1213` is Raven's `if ( 1 )` for the game and his test for the cgame, so the Swift condition is `bg.consumer == .game ? 1 != 0 : duelist.clientNum == pm.ps.clientNum`, and the block stays one block.
The cgame arm of `bg_slidemove.c:402-554` starts with `hitEnt = PM_BGEntForNum(trace->entityNum)`. The one Swift `hitEnt` at `bg_slidemove.swift:19` holds that value for every consumer by row C1, so the arm writes no store.
A NULL output of `AngleVectors` is a scratch vector with two comment lines in the form of `bg_pmove.swift:323-324`.

### The read callbacks

`CGAME_READS` at `tools/oracle-closure/rulings.py:423` holds one read callback per field the cgame arm of `BG_MySaber` reads. `channel.py:275` writes each one into `bg_callbacks.swift` with its trapping default, as a foreign hook, so `installBgChannel()` skips it and `BgChannel.swift` does not change. Each entry carries the expression a cgame install reads.

| Callback | Raven's read | The cgame install expression |
|---|---|---|
| `bgClientInfoInfoValid(of:) -> Bool` | `bg_saber.c:4129` | `cgs.clientinfo[Int(entityNum)].infoValid` |
| `bgClientInfoSaber(of:at:) -> JKAMP.SaberInfo` | `bg_saber.c:4131` | `cgs.clientinfo[Int(entityNum)].saber[Int(index)]` |
| `bgCentNpcClient(of:) -> Bool` | `bg_saber.c:4123` | `cg_entities[Int(entityNum)].npcClient != nil` |
| `bgNpcClientInfoValid(of:) -> Bool` | `bg_saber.c:4129` | `cg_entities[Int(entityNum)].npcClient!.infoValid` |
| `bgNpcClientSaber(of:at:) -> JKAMP.SaberInfo` | `bg_saber.c:4131` | `cg_entities[Int(entityNum)].npcClient!.saber[Int(index)]` |

bg holds no view of `clientInfo_t`, so `BG_MySaber` cannot hold Raven's `ci`. Each arm of his `clientNum < MAX_CLIENTS` test reads the fields through the callbacks of the table Raven named, and the test of `infoValid` and `model` stands in both arms.

## C7 item 1, the anim event block

| Raven | Swift |
|---|---|
| `animEventTypeTable`, `bg_panimate.c:1758` | C storage, `tables.py:71`, `bg_tables.h:21`, `BgTables.swift:35` |
| `footstepTypeTable`, `bg_panimate.c:1772` | C storage, `tables.py:72`, `bg_tables.h:23`, `BgTables.swift:39` |
| `CheckAnimFrameForEventType`, `:1782` | `bg_panimate.swift:1407` |
| `ParseAnimationEvtBlock`, `:1800` | `bg_panimate.swift:1426` |
| `bgAllEvents`, `:2166` | `BgStorage.bgAllEvents`, forwarder at `bg_panimate.swift:32`, public |
| `bgNumAnimEvents`, `:2167` | `BgVariables.bgNumAnimEvents`, forwarder at `bg_panimate.swift:35`, public |
| `bg_animParseIncluding`, `:2168` | `BgVariables.bg_animParseIncluding`, forwarder at `bg_panimate.swift:41` |
| `BG_ParseAnimationEvtFile`, `:2169` | `bg_panimate.swift:1769`, public |

The two name tables are Raven's data, so they take the shape of every bg name table, and the skeleton prints the `storage_data` line for each. `bgLoadedEvents_t` has the view `BgLoadedEvents` of stage 2, and `animevent_t` has `Animevent`.

The skeleton learns the block for the state files. `skeleton.py:307` reads the file-scope cursors of the game parse and then those of the cgame parse, and a bg variable that only the cgame parse holds joins the run. `skeleton.py:315` counts the writes of a bg function that only the cgame parse compiles. `GAME_ROOTS` at `rulings.py:53` names `bgLoadedEvents_t` with the cgame's view name and target, so the game's view set holds the view of `bgAllEvents`. `views.py` for the game writes no changed file.

The bodies are hand transcriptions in the form of `BG_ParseAnimationFile`. Raven's `if ( !token ) break;` after a `COM_Parse` keeps its text in the comment form of `bg_panimate.swift:2053-2056`. His `goto fin` is the labeled block `fin` with a Port-note, by `docs/transcription.md:614-617`. A store into `eventData`, a `signed short` array, truncates with `Int16(truncatingIfNeeded:)`, by `docs/transcription.md:533-535`. `FINAL_BUILD` is not a define of the parse, so the `#ifndef FINAL_BUILD` arms are live: the print of a sound that did not register, and the `Com_Error` of a file that is too long.

Three lines of the bodies carry a comment of the port:

- Raven's `stricmp` at `bg_panimate.c:1903-1925` is the C library's, which Swift has on no platform. The body calls `Q_stricmp`, which gives the same answer for two set texts.
- Raven points `stringData` at a block of `BG_Alloc(2048)` and copies the token into it. The field's setter interns the text under rule 9, and the body still calls `BG_Alloc(2048)`, so the pool count stays Raven's.
- Raven tests `include_filename != NULL`, and `COM_Parse` never returns NULL, so the arm always runs.

## The gate

Each check ran in the worktree, in the foreground, one after the other, after the last code commit.

1. `swift build`: 0 errors.
2. `swift test --no-parallel`: 113 tests in four runs, 1, 84, 13, and 15, all passed. The new test is `BgConsumerTests` at `Tests/JKAMPTests/BgConsumerTests.swift`, so master holds 112.
3. `.venv/bin/python -m unittest discover -s tests`, the form of the README: 93 tests, OK, 14 skipped.
4. `draftcheck.py --every`: 1283 holes, 0 cascade errors, 0 defects, 2 compile holes, 3 passes, exit 0, in 10 minutes 5 seconds. These are the counts of stage 2.
5. `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared`: exit 1, `372 files, a difference`. Every difference is one this change means: `channel/bg_callbacks.swift` holds the five read callbacks of C5. `skeleton/bg_panimate.swift` holds the three forwarders and the two table lines of C7. `views/JKAMP/Animevent.swift` and `views/JKAMP/BgLoadedEvents.swift` are new in the game run, with the bytes of the committed files. `manifest/` of `bg_panimate`, `bg_pmove`, `bg_saber`, `bg_saberLoad`, `bg_saga`, `bg_slidemove`, and `bg_vehicleLoad` moves the Swift line of each function and changes nothing else. No `bodies/` file differs. The skeleton reads `out/extract/mp-game/extract.json` for the file enums of the `NPC_AI_*` stubs, and a fresh worktree has no `out/`, so the check ran with the main tree's copy of that file. Without it, ten `NPC_AI_*` stubs lose their `LSTATE` constants.
6. `tools/load-test.sh` builds and then exits 0 with an empty log, because the worktree has no `.build/openjk/openjkded.arm64`. The same command with the main tree's engine and the branch dylib loads `mp/ffa1`: exit 0, one `InitGame` and one `ShutdownGame`, no Fatal, `portMissing`, or `TODO: Port` line.
7. The replay of `corpus-ffa1-human-3.rec` on `mp/ffa1`, 6500 steps, with `sv_maxclients 32`, `bot_minplayers 31`, and `g_debugAlloc 1`, through `/tmp/game-pool-scripts/replay.sh` with the branch dylib in `DYLIB`: exit 0, `REF REPLAY END` at log line 6721, 11 kills, 472 `G_Alloc of` lines, last line `G_Alloc of 81 bytes (240768 left)`. These are the numbers of `notes/2026-10-29/game-pool-docket.md:176` and `:188`. Against the master log `/tmp/jka-load/gp-ffa1-master.log`, without the time stamps, the `G_Alloc of` lines and the `Kill:` lines do not differ. The whole logs differ only in the port, the homepath, the hitch time, and two bytes of the engine's last free, which the two bytes of the shorter homepath give.

The unit test of the docket builds `BgState(consumer: .cgame, maxPoolSize: 2_048_000)`, installs the cgame's `bgClientInfoInfoValid` and `trap_SnapVector`, and installs no game closure. It runs `Pmove` on one player on a floor in a child process and expects a clean exit, and it passes. With the C3 test of `BG_StartLegsAnim` taken out of `bg_panimate.swift:2175`, the same test traps with `No consumer installed bgEntityLegsAnim, source: oracle/codemp/game/bg_panimate.c:2611`. The first closure a cgame `Pmove` calls is the cgame read `bgClientInfoInfoValid` of `BG_MySaber`, and the second is the cgame trap `trap_SnapVector`.

## What stays

- The cgame install, blocker 8 of `notes/2026-10-29/cgame-scout.md:313`, installs the five read callbacks of C5 with the expressions of `CGAME_READS`, beside the closures of the docket's list. `channel.py` writes no cgame install.
- Row C9, the four vehicle NPC files, is its own docket.
- The ui arms of row C6 land in the ui stage. The C4 sites hold their ui cases.
