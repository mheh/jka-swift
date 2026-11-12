# Review 11: the bodies of the run-path round

Scope: commit de10821 "The run-path bodies of the dedicated server" (record `notes/2026-11-10/dedicated-body-round-path.md`), plus the bodies on the path from Com_Init to SV_SpawnServer to SV_Frame, on master f292db9.
Method: each Swift body compared line by line with Raven's function. Read only. No build, no run.

Result: 0 DEFECT, 0 SUSPECT, 5 NOTE.

## Findings

### N1. NOTE: CM_EdgePlaneNum indexes `planes` with the -1 of CM_GridPlane

- Swift: `Sources/JKAMP_DedLogic/cm_patch.swift:674` (and the five other arms to :706): `p = CM_GridPlane(gridPlanes, i, j, 0)` then `_VectorMA(p1, 4, vec3_t(planes[p].plane[0], planes[p].plane[1], planes[p].plane[2]), &up)`
- Raven: `oracle/codemp/qcommon/cm_patch.cpp:624`: `p = CM_GridPlane( gridPlanes, i, j, 0 );` then `VectorMA( p1, 4, planes[ p ].plane, up );`
- Effect: CM_GridPlane returns -1 after "WARNING: CM_GridPlane unresolvable" (cm_patch.cpp:605, cm_patch.swift:648). Raven then reads `planes[-1]`, out of bounds with no check. The Swift subscript traps. Raven's behavior is undefined here, so this is not a defect. The comment "should never happen" applies.

### N2. NOTE: GetBotLibAPI version mismatch arm is a hole, and Raven returns NULL there

- Swift: `Sources/JKAMP_DedLogic/be_interface.swift:385` to `:388`: `if apiVersion != BOTLIB_API_VERSION { ... portMissing("GetBotLibAPI", ...) }`
- Raven: `oracle/codemp/botlib/be_interface.cpp:848` to `:851`: `botimport.Print( PRT_ERROR, "Mismatched BOTLIB_API_VERSION: ..." ); return NULL;`
- Effect: portMissing returns `Never`, so the arm does not fall through into the table stores. The one caller passes `BOTLIB_API_VERSION` (sv_bot.swift, `GetBotLibAPI(BOTLIB_API_VERSION, botlib_import)`), so the arm is never reached. The Port-note states the cause (no variadic tail on `BotlibImportPrint`) correctly. Every other store of Init_AAS_Export, Init_EA_Export, Init_AI_Export, and GetBotLibAPI matches Raven name for name and in order (checked by a diff of the 138 stores).

### N3. NOTE: the botlib import thunks of the round are stubs, so the first botlib callback traps

- Swift: `Sources/JKAMP_DedLogic/sv_bot.swift`, enum `BotlibImportThunks` at the end of the file, for example `static let BotImport_Print: BotlibImportPrint = { _, _ in portMissing("BotImport_Print", ...) }`, and the same for Trace, EntityTrace, PointContents, inPVS, BSPModelMinsMaxsOrigin, BotClientCommand, DebugLineShow, DebugPolygonCreate, and the three W3P2 thunks.
- Raven: `oracle/codemp/server/sv_bot.cpp:691` to `:698`: `botlib_import.Print = BotImport_Print;` and the stores that follow, each to the real function.
- Effect: SV_BotInitBotLib stores 13 stub thunks and 5 real ones. GetBotLibAPI's `assert(botimport.Print != nil)` passes, because the field holds the stub. The first botlib call to `botimport.Print` (for example at BotLibSetup, `bot_enable 1`) traps instead of printing. Each stub carries `// TODO: Port signature`, and the record names W3P1, W3P2, and B1, so these are known holes, not wrong behavior.

### N4. NOTE: the free of `debugpolygons` reads element 0 of the Slots

- Swift: `Sources/JKAMP_DedLogic/sv_bot.swift:743`: `if debugpolygons != nil { Z_Free(debugpolygons![0].handle) }`
- Raven: `oracle/codemp/server/sv_bot.cpp:687`: `if (debugpolygons) Z_Free(debugpolygons);`
- Effect: if a block was made with `bot_maxdebugpolys 0`, the Slots has count 0, and `[0]` traps where Raven frees the block. SV_BotInitBotLib has one caller, SV_Init (`oracle/codemp/server/sv_init.cpp:878`), which runs once, so `debugpolygons` is always nil at this line. Not reachable now.

### N5. NOTE: the checksum feed of SV_SpawnServer uses the host rand()

- Swift: `Sources/JKAMP_DedLogic/sv_init.swift:578`: `sv.checksumFeed = ((rand() << 16) ^ rand()) ^ Com_Milliseconds()`
- Raven: `oracle/codemp/server/sv_init.cpp:613`: `sv.checksumFeed = ( ((int) rand() << 16) ^ rand() ) ^ Com_Milliseconds();`
- Effect: the expression is the same. Swift `<<` on Int32 drops the high bits as the C shift does on the target, so no trap. The host rand() has RAND_MAX 0x7fffffff, against 0x7fff of MSVC, so the bit spread of the feed differs. The feed is random by design, and pure clients take it from the server, so no visible change.

## Checks with no finding

- CM_GridPlane: `gridPlanes[i][j][!tri]` is `tri == 0 ? 1 : 0`. Same for every int value of `tri`.
- CM_EdgePlaneNum: all six arms match in point order, triangle index, and CM_FindPlane argument order. The default arm reaches Com_Error(ERR_DROP).
- CM_SetBorderInward: the three point sets, the counts, the four outcomes, and the debugBlock copies match. The AI lines (copy of the vector where Raven points into the grid) are true, because Raven only reads through the pointers.
- Static `cv` of CM_TracePointThroughPatchCollide and CM_TraceThroughPatchCollide: world storage starts at nil, so the lazy Cvar_Get runs once, as Raven's static does. The `cv &&` test of the second function is kept.
- CM_ParseVector: the shadow copy is gone, and `v[i]` writes through `inout` to the caller's `fogColor`. CM_ParseShader `fogParms` returns on false, as Raven does.
- CM_LoadShaderFiles and Sys_UnpackDLL: CharBuf is a struct, so `repeating: CharBuf(0)` does not alias the 1024 entries. FS_ReadFile (files_pc.swift:1415) treats a non-nil buffer as Raven's non-NULL address, sets nil on a missing file, and the callers' nil tests match Raven's `!buffers[i]`.
- CMod_LoadPatches: `patch.pc = CM_GeneratePatchCollide(width, height, points)` matches cm_load.cpp:483.
- SE_LoadLanguage: `while let p = SE_GetFoundFile(&strResults), psErrorMessage == nil` calls SE_GetFoundFile first and tests the error second, as Raven's `&&` does.
- Com_Frame: G2_PERFORMANCE_ANALYSIS is defined when FINAL_BUILD is not (q_shared.h:45). Start sits at the top, End after `com_frameNumber++`, then the report and the reset, as in common.cpp:1598 and :1768. The AI lines of timing_c (millisecond clock for rdtsc) are true.
- SV_Init: `G2VertSpaceServer = CMiniHeap_singleton` keeps one object, because CMiniHeap is a final class. The heap size is 256 * 1024, as tr_init.cpp:28 and :30 give.
- SV_ClipMoveToEntities: `touchlist_SV_ClipMoveToEntities` is world storage, so it keeps the static. The zero start of `clipHandle`, `origin`, and `angles` changes nothing, because each is written before its read. The `return` inside the scratch closures ends the function, because no statement follows the closures.
- SV_GameSystemCalls: G_R_REGISTERSKIN, G_G2_CLEARATTACHEDINSTANCE, and G_G2_CLEANENTATTACHMENTS match sv_game.cpp:1313 and :1590 to :1595.
- SystemInflate.start: host code, not a Raven body. The raw block of `MemoryLayout<z_stream>.size` bytes, set to zero, matches the size handed to inflateInit2_.

## Functions read

Bodies of the round: CM_GridPlane, CM_EdgePlaneNum, CM_SetBorderInward, CM_TracePointThroughPatchCollide (the `cv` lines), CM_TraceThroughPatchCollide (the `cv` lines), CMod_LoadPatches (the changed call), CM_LoadShaderFiles, CM_ParseVector, CM_ParseShader (the `fogParms` arm), Com_Frame, SE_LoadLanguage, SV_Init, SV_ClipMoveToEntities, SV_GameSystemCalls (the three new arms), Sys_UnpackDLL, SystemInflate.start, Init_AAS_Export, Init_EA_Export, Init_AI_Export, GetBotLibAPI, SV_BotInitBotLib, the BotlibImportThunks enum, and the names of the Aas/Ea/Ai/BotlibExport thunks.

Path bodies: Com_Init, Com_ParseCommandLine, Com_SafeMode (top), Com_StartupVariable, Com_AddStartupCommands, Com_EventLoop, Com_Milliseconds, Com_ModifyMsec, Cbuf_Execute, Cmd_TokenizeString, SV_Map_f, SV_SpawnServer, SV_CreateBaseline, SV_BoundMaxClients, SV_Startup, SV_InitSV, SV_ChangeMaxClients, SV_ClearServer, SV_TouchCGame, SV_SendMapChange, SV_Frame, SV_CalcPings, SV_CheckTimeouts, SV_CheckPaused, SV_CheckCvars, timing_c.

## Functions not read

Cvar_Init, Cvar_Get, Cvar_Set2, Cvar_InfoString, Cvar_InfoString_Big, Cmd_Init, Cmd_ExecuteString, Cbuf_AddText, Com_InitZoneMemory, Com_InitHunkMemory, Hunk_Clear, Hunk_SetMark, Z_Malloc and Z_Free, FS_InitFilesystem, FS_Startup, FS_SetRestrictions, FS_Restart, FS_ReadFile beyond the buffer arms, FS_FOpenFileRead, the pk3 and unzip code, the huffman and msg code, Netchan_Init, NET_Init, NET_Sleep, Sys_Init, Sys_LoadDll, VM_Init, VM_Create, VM_Call, SE_Init, SE_BuildFileList, SE_Load, SV_BotInitCvars, SV_AddOperatorCommands, SV_InitGameProgs, SV_InitGameVM, SV_ShutdownGameProgs, CM_LoadMap and the CMod_Load functions other than the one changed call, CM_GeneratePatchCollide, SV_ClearWorld, SV_SetConfigstring, SV_SendClientMessages, SV_MasterHeartbeat, SV_BotFrame, G2API_SetTime, Com_RunAndTimeServerPacket and SV_PacketEvent, the rest of SV_GameSystemCalls, and every `win_*` body other than Sys_UnpackDLL.

Side remark: the record says the Ghoul2 trace hole of SV_ClipMoveToEntities stays. On master it is filled (sv_world.swift:662, an AI line that names row Z6 of docket 10), so the record is older than the code.
