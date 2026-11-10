# The cmsv body round, the clip map, the server, the terrain, and the random mission manager

This record holds the third body wave of the stems `cm_*`, `sv_*`, `CCMLandScape`, `CCMPatch`, `CCMHeightDetails`, `CRMManager`, and `CRMObjective` of `Sources/JKAMP_DedLogic`. The tree is the worktree `/tmp/jka-w3-cmsv` on the branch `ded-wave3-cmsv`, off master at `6f3abc1`. The round wrote bodies only. It changed no generated file, no signature, no generator table, and no file outside the stems. Three sub-agents wrote the bodies in disjoint files, and one build gate ran at the end.

## The count of holes

| Stem | `portMissing` before | after |
|---|---|---|
| cm_load | 4 | 2 |
| cm_patch | 9 | 2 |
| cm_trace | 7 | 1 |
| cm_test | 3 | 2 |
| cm_shader | 2 | 1 |
| cm_polylib | 1 | 1 |
| cm_terrain | 14 | 14 |
| sv_bot | 64 | 5 |
| sv_game | 4 | 4 |
| sv_world | 2 | 1 |
| sv_client | 5 | 2 |
| sv_init | 1 | 0 |
| CCMLandScape | 28 | 25 |
| CCMPatch | 5 | 0 |
| CRMManager | 18 | 18 |
| CRMObjective | 2 | 0 |
| Total | 170 | 78 |

The counts of CCMLandScape and CRMManager fall less than the bodies filled, because a filled body keeps one hole per row it needs.

## The bodies

- cm_patch. CM_GridPlane, CM_EdgePlaneNum, and CM_SetBorderInward are whole, because `gridPlanes` is `[[[Int32]]]` now (row T7). The `cv` sites of CM_TracePointThroughPatchCollide and CM_TraceThroughPatchCollide read the forwards `cv_CM_TracePointThroughPatchCollide` and `cv_CM_TraceThroughPatchCollide` (row P3). CM_DrawDebugSurface stays dead under rule 20.
- cm_load. CMod_LoadPatches calls CM_GeneratePatchCollide with the `[vec3_t]` of row P2. CM_ShutdownTerrain calls DecreaseRefCount and GetRefCount of CCMLandScape. CM_Checksum stays dead, and CM_RegisterTerrain keeps its signature marker.
- cm_trace. CM_TraceThroughTerrain is whole. CM_HandlePatchCollision keeps its signature marker.
- cm_test. The water arm of CM_PointContents is filled. CM_BoxBrushes has no caller in either tree, so it keeps its stub with a rule 20 note, and the hole of CM_StoreBrushes stays with it.
- cm_shader. CM_ParseShader passes `fogColor` to CM_ParseVector (row S2). CM_ParseVector shadowed its `inout` parameter with a local copy, so the parsed values never reached the caller. The copy is gone.
- sv_bot. SV_BotWaypointReception, SV_BotCalculatePaths, BotImport_Print, BotImport_Trace, BotImport_EntityTrace, Bot_GetMemoryGame, BotImport_GetMemory, BotImport_HunkAlloc, BotImport_DebugPolygonCreate, BotImport_DebugPolygonShow, BotImport_DebugPolygonDelete, SV_BotLibSetup, and SV_BotLibShutdown are whole. SV_BotInitBotLib has the `BotlibImport.scratch` record, the free and the allocation of `debugpolygons` (row B3), and the GetBotLibAPI call. Its 21 import stores are one hole. BotDrawDebugPolygons has a hole at the BotLibVarSet line and at the `drawPoly` call.
- sv_game. 100 of the 134 botlib arms call the `run` methods of `botlib_export!`, `.aas`, `.ea`, and `.ai`. The function ends in Raven's `return -1`, because the BOTLIB_EA_ACTION arm breaks out of the switch. G_R_REGISTERSKIN and G_RMG_INIT are filled.
- sv_world. SV_ClipMoveToEntities reads the forward `touchlist_SV_ClipMoveToEntities` (row SV2). The locals `clipHandle`, `origin`, and `angles` moved into the scratch closure, because the closure captured them before their first store.
- sv_client. The download block holes are filled, because `downloadBlocks` is `[Slots<byte>?]` now (row G13). SV_SendClientGameState runs Raven's test of TheRandomMissionManager, so a client connect on a map with no random mission writes the short 0 and goes on. SV_WriteRMGAutomapSymbols writes the count, and the body per symbol is a hole.
- sv_init. SV_Init is whole, `G2VertSpaceServer = CMiniHeap_singleton`.
- CCMPatch. All five methods are whole.
- CCMLandScape. GetPatch, WaterCollide, UpdatePatches, CalcRealCoords, SetShaders, SaveArea, AreaCollision, GetFirstArea, GetNextArea, rand_seed, flrand, and irand are whole. The initializer, the deinit, PatchCollide, GetWorldHeight, LoadTerrainDef, and FlattenArea have holes. GetTerxelLocalCoords, CarveLine, CarveBezierCurve, FractionBelowLevel, GetFirstObjectiveArea, GetPlayerArea, and GetNextObjectiveArea have no caller in either tree and keep their stubs with a rule 20 note.
- CRMManager. UpdateStatisticCvars, HasTimeExpired, Preview, and GetAutomapSymbolCount are whole. Ten methods have holes for the members the class does not hold. GetTerrain, GetMission, GetAutomapSymbol, and ProcessAutomapSymbols keep their signature markers.
- CRMObjective. The initializer and Link are whole.
- cm_terrain. The 14 wrappers keep their signature markers, because no table row maps `CCMLandScape *`.

`grep Unsafe` gives 0 in the added lines. The `Z_Free(OpaquePointer(x.base))` lines of sv_bot and CCMLandScape take the form of `files_pc.swift:1729`.

## The rule 24 sites

- CM_ShutdownTerrain: the store of nil releases the landscape, and its deinit runs Raven's destructor.
- SV_BotWaypointReception: each pointer is copied and not mapped through BotVMShift, the ConvertedEntity line of `sv_game.swift:388`.
- SV_BotInitBotLib: the literal 2 for BOTLIB_API_VERSION, the form of the NODE_HEADER_ID sites of the ninth ledger, rows 4 and 5.
- SV_GameSystemCalls: the module vector line at 18 botlib arms, and the CharBuf and Com_Memcpy line at 4 arms.
- CCMLandScape: the memset of `mHeightDetails`, the patch array in the initializer and the deinit, the area list in the deinit, the index walk and the brush cast of UpdatePatches, and the `%d` argument of rand_seed.
- CCMPatch: SetPlaneSignbits through `.plane` in InitPlane, the bounded Slots of the side and plane casts in CreatePatchPlaneData.
- CRMManager.LoadMission: `sprintf` is Com_sprintf with the buffer size, the form of `GameInterface.swift:264`.

## The rows

Each row cites Raven's line under `oracle/codemp/` and the Swift site under `Sources/JKAMP_DedLogic/`.

- Row B1, the botlib import stores. Raven stores 21 functions into `botlib_import` at `server/sv_bot.cpp:694` to `:724`. The generator writes a `<Record>Thunks` enum only into a stub with the skeleton header (`be_interface.swift:566`), and sv_bot is adopted, so no BotlibImportThunks exists. BotImport_Print is variadic, and most imports take a `vec3_t *` or a `char *` as an OpaquePointer, so a hand thunk needs a handle in logic code. Swift: the hole at `sv_bot.swift:811`. SV_Init calls SV_BotInitBotLib, so a server start stops here. Candidate forms: a generated thunk file for an adopted stem, with readers for a vector pointer and a C string, and a C variadic shim for Print. The hand `LeafListThunks` of `cm_test.swift:473` and `cm_trace.swift:1796` came in with the ninth batch and no ledger row records it.
- Row B1a, BOTLIB_API_VERSION. The dedicated target does not re-export the macro of `botlib.h:16`, only `JKAMP_Game/Generated/botlib.swift:8` holds it. Swift: `sv_bot.swift:813`, the literal under one AI line. Candidate form: a reexport row.
- Row B5, the `run` methods with an untyped `OpaquePointer?` for a `char *`, an `int *`, or a `float (*)[3]` of the module. Raven: `server/sv_game.cpp:948`, `:950`, `:953`, `:961`, `:971`, 29 arms from `:981` to `:1311`, and `server/sv_bot.cpp:247`. Swift: `sv_game.swift:1060` (5 arms), `:1484` (29 arms), and `sv_bot.swift:285`. Candidate forms: the `VMA -> OpaquePointer?` overload of `GameViews.swift:32`, as TRAP_MEMSET does, or PARAMS rows that give `String` or `Slots<Int32>`.
- Row B4, a local `vec3_t` array handed to a `Slots<vec3_t>` parameter. Raven: `server/sv_bot.cpp:526` and `:569`. Swift: `sv_bot.swift:610` and `:666`. Candidate forms: BYTE_STORAGE_LOCALS rows, the `leafs_SV_LinkEntity` form, or a `scratch(count:)` for `vec3_t`.
- Row B6, the `drawPoly` parameter `(Int32, Int32, inout Float)` against Raven's `float *` over 128 points at `server/sv_bot.cpp:249`. Swift: `sv_bot.swift:296`, the signature at `:209`. Candidate form: a PARAMS row that gives `Slots<vec3_t>`.
- Row Z6, a module word read as the address of a `CGhoul2Info_v`. Raven: `server/sv_game.cpp:1316` to `:1617` and `server/sv_world.cpp:692` to `:782`, which also needs storage for the static `G2Trace_t G2Trace`. Swift: `sv_game.swift:1502` (47 arms) and `sv_world.swift:629`. Candidate form: a handle table of the classes on the world, keyed by the word, the form of `Ghoul2InfoArray`.
- Row C, the return `CCMLandScape *` of CM_RegisterTerrain and the 14 wrappers of cm_terrain. Raven: `qcommon/cm_load.cpp:1036`, `qcommon/cm_terrain.cpp:1618` to `:1688`, the call at `server/sv_game.cpp:1641`. Swift: `cm_load.swift:1138`, `cm_terrain.swift:88` to `:205`, `sv_game.swift:1525`. Candidate form: a TYPES and RETURNS row that maps `CCMLandScape *` to `CCMLandScape?`.
- Row C, `CCMPatch *` of CM_HandlePatchCollision. Raven: `qcommon/cm_trace.cpp:914`, called at `qcommon/cm_terrain.cpp:683`, `:770`, `:825`. Swift: `cm_trace.swift:778`, the holes at `CCMLandScape.swift:259`, `:336`, `:398`. Candidate form: the same TYPES row for `CCMPatch *`. The body also needs a form for `brush++` over GetCollisionData.
- Row C, CRMManager.GetAutomapSymbol has no signature. Raven: `server/sv_client.cpp:677`. Swift: `sv_client.swift:563`, `CRMManager.swift:197`.
- Row C2, zlib `deflate`. Only inflate exists, in JKAZlib. Raven: `server/sv_client.cpp:742` to `:781`. Swift: `sv_client.swift:661`. A map with a random mission only.
- Row R1, `atol` and `strtoul`. No Swift function exists, and `LIBC_SPELLINGS` of rulings.py has no row. Raven: `qcommon/cm_terrain.cpp:74`, `:93`, `:134` to `:137`. Swift: `CCMLandScape.swift:70`, `:73`, `:76`, `:79`, `:648`, `:665`. The initializer stops at the first one, so no landscape loads before this row closes. Candidate forms: a `LIBC_SPELLINGS` row `"atol": "atoi"`, because `long` is 32 bits in MSVC. For `strtoul`, a function beside `atoi` in JKAShared, or a rule 20 note, because nothing reads `seed`.
- Row R2, `Round` of `qcommon/qcommon.h:1094` has no Swift function. Raven: `qcommon/cm_terrain.cpp:150`, `:151`. Swift: `CCMLandScape.swift:94`, `:97`. Candidate form: `func Round(_ value: Float) -> Int32` in common.swift with Raven's body.
- Row R3, the class members with no Swift class. `mRandomTerrain` (`CRandomTerrain *`): Raven `qcommon/cm_terrain.cpp:169`, `:1605`, `qcommon/cm_landscape.h:224`, Swift `CCMLandScape.swift:115`, `:168`, `:1014`. `mTerrain`, `mMission` (`CRMMission *`), and `mAutomapSymbols` (`rmAutomapSymbol_t`): Raven `RMG/RM_Manager.cpp:37` to `:407`, Swift `CRMManager.swift:117` to `:526`. Candidate forms: Swift classes for CRandomTerrain and CRMMission, and a record type for `rmAutomapSymbol_t`. In the DEDICATED build, `cm_terrain.cpp:169` only stores 0, so a rule 20 note is an alternative for `mRandomTerrain`. The deinit of CCMLandScape stops at this row, so CM_ShutdownTerrain stops here when a landscape exists.
- Row R4, the `origin` parameter of GetWorldHeight. Raven writes `origin[2]` at `qcommon/cm_terrain.cpp:1054`, and `RMG/RM_Mission.cpp:403` and `:412` read it. Swift: `CCMLandScape.swift:476`. Candidate form: a PARAMS row for an `inout vec3_t`.
- Row R5, the `user` parameter of CM_CircularIterate. The callback type is `(Slots<UInt8>, Float, inout Int32)`, and Raven passes an `ivec3_t` to CM_GetAverage and CM_BelowLevel, which take `Slots<Int32>`. Raven: `qcommon/cm_terrain.cpp:1343` (FlattenArea) and `:1401` (dead). Swift: `CCMLandScape.swift:729`, `cm_terrain.swift:10`, `:43`, `:74`. Candidate form: `Slots<Int32>` for `user` and the four callbacks.
- Row S1, still open. Raven inserts a Hunk_Alloc record into `cmShaderTable` at `qcommon/cm_shader.cpp:521`, and the table holds offsets into `cmg.shaders`. Swift: `cm_shader.swift:449`. Only CCMLandScape calls it. Candidate forms: `[String: CmShader]`, or a second table of views for the records outside `cmg.shaders`.
- Row P7, `%p`. Raven formats `points` with `%p` at `qcommon/cm_patch.cpp:1171` before a fatal error. The format subset has no `%p`. Swift: `cm_patch.swift:1315`. Candidate forms: `%p` in the format subset, or a rule 24 line that prints 0.
- Row R4 of the cm round, `cbrush_t **`. CM_BoxBrushes and CM_StoreBrushes have no live caller. Swift: `cm_test.swift:110` and `:197`. Proposal: close the row as rule 20.
- A generator finding. `TERRAIN_STEP_MAGIC` is `(1.0f / 1.2071f)` at `qcommon/cm_landscape.h:17`, and `JKAMP_Ded/Generated/cm_landscape.swift:11` gives a `Double`, so the reexport drops the `f` suffix of a division in parentheses. The site `cm_trace.swift:719` converts through Double, and Raven sets `count = 1` on the next line, so the value has no effect.
- CM_Checksum needs a BYTE_STORAGE_LOCALS row for `checksums`. The function is dead, so the stub stays.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | Run 1 exit 1, three errors in sv_world.swift: `clipHandle`, `origin`, and `angles` captured by the scratch closure before their first store. The fix moved the three locals into the closure. Run 2 exit 0. |
| `swift test --no-parallel -j 2` | exit 0, 150 tests in 9 runs, 0 failures |
