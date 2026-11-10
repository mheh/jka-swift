# The open rows of the dedicated host, the eleventh ledger

This record holds the eleventh batch of open rows of the dedicated host: the rows with the verdict PATTERN of `notes/2026-11-10/docket-11-proofs.md` of the main tree. The batch is a generator batch on the branch `dedicated-rulings-batch-11`, from master `f292db9`.

Each row is auto ruled by pattern, under the standing delegation of the dedicated track. The coordinator checked each proof at its Raven line and at the line of its precedent before the change. Every proof held at its line. One sub-row of row 8 had no form at the line, and it stays open.

Out of scope by the brief: the `%02d` row (it reaches the cgame, and the user rules its reach), `%lu` (no site), the hitch warning at `win_main.swift:892`, and any `M_PI` change.

## The rows

Row 1, the export thunks with an `inout CharBuf` parameter, `Sources/JKAMP_DedLogic/be_interface.swift`:

- The 6 thunks of a sized buffer, AAS_ValueForBSPEpairKey (`:599`), Export_BotLibVarGet, BotGetChatMessage, BotGoalName, Characteristic_String, BotMatchVariable: PATTERN, auto ruled by pattern, precedent `charBuf(at:capacity:)` and `store(_:at:capacity:)` of `Sources/JKAShared/Views/CStrings.swift:24` and `:33` in the shape of `Sources/JKAMP_CGameLogic/cg_main.swift:3871` and the store of `cg_main.swift:4013`. Landed.
- The 8 read-only thunks, EA_Command (`:1010`), BotLoadCharacter, BotLoadChatFile, BotLoadItemWeights, BotLoadWeaponWeights, BotNumInitialChats, StringContains, BotReplyChat: PATTERN, auto ruled by pattern, precedent `CharBuf(text(at:))` of `cg_main.swift:3914`. Landed.
- UnifyWhiteSpaces (`:925`): PATTERN, auto ruled by pattern, the read-only form and a write-back of `buf.count` bytes, because the text only gets shorter. Landed.
- PC_SourceFileAndLine (`:983`): PATTERN, auto ruled by pattern, the store bound of `char filename[1024]` at `l_precomp.h:82` and the one-slot write-back of `cg_main.swift:3996`. Landed. The thunk writes the text only when the handle is valid, as Raven's strcpy does.
- BotReplaceSynonyms (`:827`): no pattern. Open for the user, see below.

Row 2, the three chooser thunks, `be_interface.swift:643` to `:651`: PATTERN, auto ruled by pattern, precedent `Slots<Int32>(scalars:count: Int.max / 4)` of `Sources/JKAMP_Ded/GameViews.swift:96`. Landed.

Row 3, the two `sv_game` arms:

- AAS_FloatForBSPEpairKey: PATTERN, auto ruled by pattern, precedent the `float_mut` row of `botlib_import_t.FS_FOpenFile` at `rulings.py:1466` and the twin arm BOTLIB_AAS_VECTOR_FOR_BSP_EPAIR_KEY. Landed: the row at `tools/oracle-closure/rulings.py:1472` and the arm at `Sources/JKAMP_DedLogic/sv_game.swift:1161`.
- GeneticParentsAndChildSelection: PATTERN with a generator branch, auto ruled by pattern, precedent the D16 list row of `rulings.py:1438` to `:1444` and the `table` branch of `views.py:815`. Landed: the row at `rulings.py:1474`, the FLOAT branch of kind `bytes` at `tools/oracle-closure/views.py:814` to `:818`, and the arm at `sv_game.swift:1601`.

Row 4, the two FS reads and writes:

- AAS_WriteAASLump: PATTERN, auto ruled by pattern, precedent the handle form of `Sources/JKAMP_Ded/ThunkReaders.swift:33`. Landed at `Sources/JKAMP_DedLogic/be_aas_file.swift:291`.
- AAS_ReadCache: PATTERN, auto ruled by pattern, precedent GetInt of `Sources/JKAMP_DedLogic/CNavigator.swift:2018`. Landed at `Sources/JKAMP_DedLogic/be_aas_route.swift:1097`.

Row 6, the two Wait holes of CTaskManager:

- `TaskManager.cpp:1111` and `:1127`: PATTERN, auto ruled by pattern, precedent the CharBuf form of `CNavigator.swift:183` to `:189`. Landed at `Sources/JKAMP_DedLogic/CTaskManager.swift:987` and `:1011`.
- `TaskManager.cpp:1122`: PATTERN, auto ruled by pattern, precedent X39 P17b of ledger 10. Landed at `CTaskManager.swift:1003`, with the body of the `if` that the hole had dropped. The store of `Q3_INFINITE` into the float local stands under a "C converts" line.

Row 7, BSPEntityData: PATTERN, auto ruled by pattern, precedent `Sources/jampgame/jampgame.swift:55`. Landed at `Sources/JKAMP_DedLogic/sv_bot.swift:852`. The thunk returns the pool's pointer of the entity text, with no cut.

Row 8, the RMG classes:

- ProcessAutomapSymbols: PATTERN, DEAD row, auto ruled by pattern, precedent LoadTGA at `rulings.py:1513`. Landed at `rulings.py:1535` and the note at `Sources/JKAMP_DedLogic/CRMManager.swift`.
- CM_TerrainPatchIterate: PATTERN, DEAD row, auto ruled by pattern, precedent BotDrawDebugPolygons at `rulings.py:1529`. Landed at `rulings.py:1537` and the note at `Sources/JKAMP_DedLogic/cm_terrain.swift`.
- `symmetry_t`: PATTERN, auto ruled by pattern, precedent the `ded_types.h` copy of `rmAutomapSymbol_t`, row X41. Landed at `Sources/CJKAMP_Ded/include/ded_types.h:2268`, re-exported in `Sources/JKAMP_Ded/Generated/RM_Headers.swift`.
- CPathInfo, CRMArea, CRMAreaManager, CRMNode, CRMLoc, CRMCell, CRMPathManager: PATTERN, auto ruled by pattern, precedent the CXX_CLASSES rows of X41 at `rulings.py:1642` to `:1645` and the hand classes CRandomTerrain and CRMMission. Landed: the rows at `rulings.py:1648` to `:1649` and one hand class per file under `Sources/JKAMP_DedLogic/`. CRMCell is a struct, the form of `SGoreSurface` in `CGoreSet.swift`. The RM files stay in `deferred`, as cm_randomterrain.cpp did for CRandomTerrain in X41, because none of them holds a free function that these classes need. The macros and the ERMDir enum of the headers the host parse does not read are hand `let` constants and an Int32 alias, the forms of `CRMManager.swift:7` and `CRagDollParams.swift:12`.
- CRMInstance and its four subclasses, and CRMInstanceFile: no form. Open, see below.
- The `int *flattenHeight` row of ParseOrigin: not applied, because ParseOrigin also needs CRMInstance through its callers. It stays a `TODO: Port signature`.

## The timing

Each line is one step, in seconds. One sequence run, all steps exit 0. Other Swift processes ran on the machine during the run.

| Step | Run 1 |
| --- | --- |
| extract, 9 units | 75 |
| merge | 1 |
| tables | 0 |
| check | 5 |
| reexport | 91 |
| views-game | 68 |
| views-cgame | 48 |
| views-ded | 62 |
| skeleton-game | 31 |
| skeleton-cgame | 18 |
| skeleton-ded | 31 |
| manifest-game | 28 |
| manifest-cgame | 17 |
| manifest-ded | 32 |
| traps-game | 5 |
| traps-cgame | 2 |
| channel | 3 |
| sum of steps | 517 |

The debug builds: run 1, 25, exit 1 with one error, the store of the int `Q3_INFINITE` into a float. Run 2, 56, exit 0.

| Gate step | Seconds | Exit |
| --- | --- | --- |
| snapshot check mp-game | 128 | 0 |
| snapshot check mp-cgame | 55 | 0 |
| snapshot check mp-engine-ded | 74 | 1 |
| swift test | 45 | 0 |
| tool tests | 2 | 0 |
| release build | 116 | 0 |

## The gate

- The sequence, run 1: every step exits 0.
- `swift build -j 6`, debug and release: exit 0.
- `swift test --no-parallel -j 6`: 150 of 150 pass.
- The tool tests: 100 run, OK, 15 skipped.
- `snapshot.py --check`: mp-game, 372 files, no difference. mp-cgame, 246 files, no difference.
- mp-engine-ded, 554 files, a difference. Each line belongs to this batch: the two run methods of row 3 in `Aas_export.swift` and `Ai_export.swift`, the DEAD note of CM_TerrainPatchIterate in the skeleton and the draft of `cm_terrain.swift` (33 holes to 32), and line shifts in the manifests of `be_aas_file`, `be_aas_route`, `cm_terrain`, and `sv_game`. With the line numbers removed, the old and new manifest rows are the same.

## The result

`portMissing(` stands 234 times under `Sources/JKAMP_DedLogic`, against 265 on master `f292db9`.

The release `jampded` with the real game data spawns `mp/ffa1`, completes GAME_INIT to the `InitGame:` line, and runs server frames to the 40-second alarm, with `bot_enable 0` and with `bot_enable 1`. After `InitGame:`, the only lines are the two `Hitch warning` lines of the first frames, as in batch 10.

## The open rows

- BotReplaceSynonyms, `be_interface.swift:827`. Raven's StringReplaceWords can make the text longer with no bound. Candidate A: capacity `MAX_MESSAGE_SIZE` (256), the botlib bound for chat text at `be_ai_chat.cpp:328` and `:1422`, with an AI comment. Candidate B: `CharBuf(text(at:))` and a write-back of `strlen(buf) + 1` bytes, faithful but unsafe past the module's text.
- CRMInstance, CRMBSPInstance, CRMGroupInstance, CRMRandomInstance, CRMVoidInstance, and CRMInstanceFile. The repo has no form for a C++ virtual hierarchy. Candidate A: an enum with a switch, the closed-hierarchy form of rule 17. Candidate B: a protocol with one conforming class per Raven class. Candidate C: a Swift class hierarchy with `override`. The 20 holes of `CRMMission.swift` wait for this row, the instance hole of its deinit among them.
- A Port-note of rule 19 at `CRMPathManager.swift:550`: PathVisit indexes the 3 by 3 `directionSet` with a delta of -1, so Raven reads outside the table. The Swift subscript traps there.
