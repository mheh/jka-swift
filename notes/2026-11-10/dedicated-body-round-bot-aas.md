# The body round of the AAS stems of the botlib

This record holds the body round of the twelve `be_aas_*.swift` stems of `Sources/JKAMP_DedLogic`, against Raven's `oracle/codemp/botlib/be_aas_*.cpp`. The round started with 265 stubs. It filled 226 bodies and left 39 stubs. Every stem is adopted, so no file keeps the skeleton header. Three sub-agents filled `be_aas_reach`, the route group (`be_aas_route`, `be_aas_routealt`, `be_aas_optimize`), and the sample group (`be_aas_sample`, `be_aas_cluster`, `be_aas_move`). The coordinator filled `be_aas_main`, `be_aas_bspq3`, `be_aas_file`, `be_aas_entity`, and `be_aas_debug`, built, and fixed the compile errors.

## Bodies per file

| File | Stubs at start | Filled | Left |
| --- | --- | --- | --- |
| be_aas_bspq3 | 20 | 14 | 6 |
| be_aas_cluster | 22 | 18 | 4 |
| be_aas_debug | 19 | 18 | 1 |
| be_aas_entity | 15 | 10 | 5 |
| be_aas_file | 7 | 5 | 2 |
| be_aas_main | 17 | 12 | 5 |
| be_aas_move | 21 | 18 | 3 |
| be_aas_optimize | 8 | 8 | 0 |
| be_aas_reach | 53 | 49 | 4 |
| be_aas_route | 51 | 47 | 4 |
| be_aas_routealt | 4 | 4 | 0 |
| be_aas_sample | 28 | 23 | 5 |

## Stubs left

- Dead by rule 20, with the note of `l_crc.swift:71`, 32 stubs: AAS_StringFromIndex, AAS_IndexFromString, AAS_ModelFromIndex, AAS_IndexFromModel, AAS_UpdateStringIndexes (main), AAS_inPVS, AAS_inPHS, AAS_BoxEntities, AAS_BSPTraceLight (bspq3), AAS_EntityOrigin, AAS_EntitySize, AAS_EntityBSPData, AAS_NearestEntity, AAS_BestReachableEntityArea (entity), AAS_ClearCluster, AAS_RemovePortalsClusterReference, AAS_RemoveAllPortals, AAS_NumberClusterPortals (cluster), AAS_AirControl, AAS_SetMovedir, AAS_TestMovementPrediction (move), AAS_AreaLiquid, AAS_BarrierJumpTravelTime, AAS_NearbySolidOrGap (reach), AAS_CreateAllRoutingCache, AAS_BridgeWalkable, DistancePointToLine, AAS_NearestHideArea (route), AAS_BoxOriginDistanceFromPlane, AAS_FacePlane, AAS_AreaGroundFace, AAS_TraceEndFace (sample).
- A signature marker: AAS_Trace (bspq3), AAS_TraceClientBBox (sample), row A1.
- A signature that takes outputs by value: AAS_BSPModelMinsMaxsOrigin (bspq3), row A2.
- AAS_LoadAASLump and AAS_LoadAASFile (file), rows A3 and A4.
- Static locals with no storage: AAS_ContinueInitReachability (reach) and AAS_ShowReachableAreas (debug), row A6.

## Holes in filled bodies

Each hole is a `Port-note:` line with a `portMissing` line under it.

- `botimport.Print`, about 95 sites in all twelve files. `runPrint` of `BotlibImport.swift:71` takes `OpaquePointer?` for `char *fmt, ...` and no arguments, row A5. The map load reaches the first one in AAS_LoadFiles (`be_aas_main.cpp:313`), and AAS_InitClustering reaches more.
- `botimport.FS_FOpenFile`, `FS_Read`, and `FS_Write` with a buffer: AAS_WriteAASFile (`be_aas_file.cpp:520`) and the route cache functions of `be_aas_route.cpp:948` to `:1047`, rows A4 and A7.
- AAS_Trace and AAS_TraceClientBBox calls: 14 sites in `be_aas_reach`, 6 in `be_aas_move`, 1 in `be_aas_route`, row A1.
- AAS_BSPModelMinsMaxsOrigin calls: 5 sites in `be_aas_reach`, row A2. The call at `be_aas_entity.cpp:107` stays a call to the stub.
- AAS_UnlinkFromAreas, AAS_UnlinkFromBSPLeaves, and AAS_BestReachableLinkArea with a list that can be NULL: 4 sites in `be_aas_entity`, 10 in `be_aas_reach`, 1 in `be_aas_sample`, row A8.
- CRC_ProcessString over the bytes of the first N records of an unbounded Slots: `be_aas_route.cpp:959`, `:960`, `:1069`, `:1075`, row A9.
- `startareatraveltimes[128]` of AAS_UpdateAreaRoutingCache, an `unsigned short` local whose address a record keeps: `be_aas_route.cpp:1275`, row A10.
- `sscanf(buf, "%lf %lf %lf", ...)` of AAS_VectorForBSPEpairKey (`be_aas_bspq3.cpp:294`): Scan.swift has no overload for three doubles, row A11.

## Forms of the round

- An allocator result goes straight into a view or a `Slots` initializer, and a block walk holds the raw block in an untyped local, the N8 form of `files_pc.swift:1679`. The size takes the conversion of C at the `unsigned long` parameter, `UInt32(...)`.
- A text that Raven copies into a GetHunkMemory or GetClearedHunkMemory block keeps the call for the hunk count, and the `char *` field takes the text, the CopyString form, with one AI line. A free of such a text goes under one AI line, the form of `cvar.swift:235`. Sites: `be_aas_bspq3.cpp:349`, `:350`, `:405`, `:414`, `:447`, `:465`.
- `LittleLong`, `LittleShort`, and `LittleFloat` drop, because each one of the WinDed arm is its argument, the form of `files_pc.swift:1725`. AAS_SwapAASData has no line left.
- A `let` vector into an `inout` parameter of a botimport `run` method takes a copy, with one comment that cites the engine read in `sv_bot.cpp`, the form of `w_saber.swift:2048`.
- The enum of `be_aas_entity.cpp:32` is five `private let` constants, the form of `transcription.md:86`, because `ET_MOVER` has another value in `bg_public.h`.
- `bboxcorners[4..7]` of AAS_ShowBoundingBox takes the loop of `tr_shader.swift:1297` for Raven's memcpy, with one AI line.

## Rows

- A1. A record returned by value. AAS_Trace (`be_aas_bspq3.cpp:130`) returns `bsp_trace_t`, and AAS_TraceClientBBox (`be_aas_sample.cpp:432`) returns `aas_trace_t`. Both stubs say "No table row for the return". Candidate: the RETURNS kind `record` of `transcription.md:129`, so a caller reads `trace.copy(from: AAS_TraceClientBBox(...))`.
- A2. AAS_BSPModelMinsMaxsOrigin (`be_aas_bspq3.cpp:195`) writes `mins`, `maxs`, and `origin` through `botimport`, and `be_aas_bspq3.swift:91` takes them by value. Candidate: `inout vec3_t` for `mins` and `maxs`, and for `origin` the scratch-local form of `transcription.md:254`, because the NULL arm of `BotImport_BSPModelMinsMaxsOrigin` (`sv_bot.cpp:387`) only skips the write.
- A3. AAS_LoadAASLump (`be_aas_file.cpp:273`) returns the raw block that each caller casts to a lump table, and `be_aas_file.swift` returns `String?`. Candidate: the RETURNS kind `raw` of `rulings.py:632`, D12 shape 7.
- A4. `runFS_FOpenFile` of `BotlibImport.swift:262` takes the `fileHandle_t *` as `OpaquePointer?`. Raven: `be_aas_file.cpp:336`, `:520`, `be_aas_route.cpp:948`, `:1042`. Candidate: a parameter `inout fileHandle_t`, the form of `FS_FOpenFileByMode(file, &f, FS_READ)` at `common.swift:1993`.
- A5. `runPrint` of `BotlibImport.swift:71` takes the format as `OpaquePointer?` and no arguments. Raven calls `botimport.Print(type, fmt, ...)` at about 95 sites. Candidate: the varargs form of D18, `(_ type: Int32, _ fmt: String, _ args: any JKAShared.FormatArg...)`, the form of `BotImport_Print` at `sv_bot.swift:278`.
- A6. Static locals with no storage: `framereachability`, `reachability_delay`, `lastpercentage` of AAS_ContinueInitReachability (`be_aas_reach.cpp:4350`, `:4351`) and `reach`, `index`, `lastareanum`, `lasttime` of AAS_ShowReachableAreas (`be_aas_debug.cpp:670` to `:672`). Candidate: world properties with forwards in the stem, the form of `lastErrorTime` (`EngineWorld.swift:109`, `common.swift:480`).
- A7. `runFS_Read` and `runFS_Write` of `BotlibImport.swift:278` and `:292` take the buffer as `OpaquePointer?`. A view handle passes as it stands, so AAS_WriteAASFile writes its records. A local array or a `Slots` has no form. Candidate: a `Slots<byte>` overload, PARAMS kind `bytes`, the host `FS_Read` row of `transcription.md:132`.
- A8. AAS_UnlinkFromAreas (`be_aas_sample.cpp:1175`), AAS_UnlinkFromBSPLeaves (`be_aas_bspq3.cpp:206`), and AAS_BestReachableLinkArea (`be_aas_reach.cpp:168`) take a value, and Raven's bodies accept NULL. The callers hold the `AasLink?` that AAS_LinkEntityClientBBox returns and the `BspLink?` that AAS_BSPLinkEntity returns, which is always NULL. AAS_UnlinkInvalidEntities reaches the hole on the first frame. Candidate: NULLABLE rows of `rulings.py:992` for the three parameters.
- A9. The bytes of the first N records of a `Slots` with the widest count, `be_aas_route.cpp:959`, `:960`, `:1069`, `:1075`. Candidate: a count form of `bytes` on `Slots`, the twin of `zero(count:)` at `ServerViews.swift:31`.
- A10. A BYTE_STORAGE_LOCALS row for the `unsigned short` local `startareatraveltimes` (`be_aas_route.cpp:1275`). The rows cover `int` and `vec3_t`. Candidate: a `Slots<UInt16>` row by N5. AAS_UpdateAreaRoutingCache traps until then, so bots cannot route.
- A11. `sscanf` with `"%lf %lf %lf"` into three doubles (`be_aas_bspq3.cpp:294`). Candidate: a `Scan.swift` overload with three `inout Double`, the twin of the vector overload at `Scan.swift:164`.
- A12. `Log_Write` takes `inout CharBuf` at `l_log.swift:57`, and ledger 9 D18 makes `fmt` a `String`. Eleven sites of `be_aas_cluster` and `be_aas_reach` pass `var fmt = CharBuf("...")`, and they change if the signature changes.
- A13. AAS_AreaTravelTime returns `unsigned short` (`be_aas_route.cpp:457`), and the port returns `Int32` with no truncation. It differs only past 65535. Candidate: the narrow store of `transcription.md:616` at the return, with one AI line.
- A14. Sys_MilliSeconds (`be_interface.swift:36`) is a stub of another stem. AAS_CalculateAreaTravelTimes and AAS_ContinueInitReachability call it.

## Rule 19 notes

- AAS_ReadRouteCache: Raven's `AAS_Error("%s is not a route cache dump\n")` at `be_aas_route.cpp` gives no argument for `%s`. The port passes the file name.
- AAS_PredictClientMovement: Raven passes `mins` and `maxs` uninitialized, so the locals are zero. Only `SE_HITBOUNDINGBOX` reads them, and no caller sets that event.

## Gate

- `swift build -j 2`: complete. The warnings of the stems are 42 "will never be executed" after a hole, 10 "written to, but never read", 10 unused results, and 2 unused values.
- `swift test --no-parallel -j 2`: 150 tests in 9 runs, all pass.
