# The open rows of the dedicated host, the seventh ledger

This record holds the seventh batch of open rows of the dedicated host: every open row of the records `dedicated-round-sv-game.md`, `dedicated-round-sv-snapshot.md`, `dedicated-round-cm-trace.md`, `dedicated-round-unzip.md`, `dedicated-round-stringed.md`, `dedicated-round-wave6-hand.md`, `dedicated-round-cm-load.md`, `dedicated-round-vm.md`, `dedicated-round-files.md`, `dedicated-round-win.md`, and `dedicated-round-common.md`, all under `notes/2026-11-09/`, and the four stages that Raven's dedicated build links and the port had no stems for: the botlib, ICARUS, the NPC navigator, and the ROFF system. The user ruled the rows by delegation on 2026-11-09. The landing is the branch `dedicated-rulings-batch-7`, off master at `1d2bdeb`, in the worktree `/tmp/jka-ded-rules-7`.

The batch makes table rows and manifest entries alone, so that every stem the server needs has its generated signature, views, and storage before the body rounds. It writes no new body. An adopted stem takes the func line or the stub of the generator at each changed signature, read from the skeleton's text of the stem, and a hand body line changes only where the new signature breaks it. Each row below proves the record's claim at Raven's line and at the port's site and names the precedent it takes.

The batch ran in three steps: every change, then the generator sequence of `tools/oracle-closure/README.md` and the gate once, then one fix pass and the sequence and the gate again until the gate was green.

## Row F4 with W3, the file lists

Question: Sys_ListFiles, FS_ListFilteredFiles, FS_ListFiles, and Sys_ConcatenateFileLists return `char **` lists of CopyString texts, and their partners take the list as `char **`. The stubs carried signature markers or a TextCursor, which holds one text.

Sites: `oracle/codemp/null/win_main.cpp:434`, `:502`, and `:597`, and `oracle/codemp/qcommon/files_pc.cpp:1587`, `:1724`, `:1733`, `:1803`, `:1818`, `:2078`, and `:2194`. The port's stubs are `win_main.swift` and `files_pc.swift`, and FS_AddGameDirectory stops at the list hole on every FS_Startup.

Proof: Raven returns `listCopy`, a Z_Malloc table of `nfiles + 1` CopyString pointers with a NULL at the end, at win_main.cpp:576 and files_pc.cpp:1710, and writes the count through `int *numfiles`. Sys_FreeFileList and FS_FreeFileList free each text and the table. paksort reads `*(char **)a` at files_pc.cpp:2197.

Verdict: ratified as proposed in row 8 of `dedicated-round-wave6-hand.md`, delegated, 2026-11-09. The RETURNS kind `string_list` gives `[String]`, and `numfiles` stays `inout Int32`. The PARAMS kind `string_list` gives a list the body reads or frees `[String]`, `string_list_mut` gives FS_SortFileList `inout [String]`, `string_slice` gives `psList` of Sys_ListFilteredFiles `inout ArraySlice<String>`, the row of `char *infos[]` of G_ParseInfos, and `string_value` gives paksort `(String, String) -> Int32`, the text twin of `int_value`. The bodies and the free-nothing form of the two free functions wait for the files round.

Files: `rulings.py`, `spelling.py`, `table.py`, `files_pc.swift`, and `win_main.swift`.

## Row V8, the profile sort

Verdict: ratified as proposed, delegated, 2026-11-09. `a` and `b` of VM_ProfileSort take the PARAMS kind `("view", "vmSymbol_t")`, the row of `p` of CG_SetScoreSelection, so the comparator is `(VmSymbol?, VmSymbol?) -> Int32`, and `qsort(&sorted, count, VM_ProfileSort)` reads over the `[T]` qsort of CommonViews.swift. Raven reads `*(vmSymbol_t **)a` at `vm.cpp:837`.

Files: `rulings.py` and `vm.swift`.

## Rows F7 and F8

Closed by rows F7 and F8 of the sixth ledger: the host defines take WinDed's `PATH_SEP`, so FS_ReplaceSeparators takes `inout CharBuf`, and FS_ShiftedStrStr has the RETURNS kind `optional_string`. No change.

## Row CM5, the storage of `shaderText`

Question: `char *shaderText` is a generated `String`, so the Z_Malloc of CM_LoadShaderFiles at `cm_shader.cpp:135` and the Z_Free of CM_FreeShaderText at `:181` have no form. The record gives two proposals: the G_Alloc form, and a HAND_VARS entry that keeps the block beside the text.

Verdict: the G_Alloc form, delegated, 2026-11-09, because it is the nearer precedent: the `G_Alloc` form of `docs/transcription.md` and the CopyString form of row Z3 of the fifth ledger, where the zone count keeps the call and the free drops under an AI line. A HAND_VARS entry for a zone block has no precedent. The fill is a body change, so it goes to the cm_load round with CM_LoadShaderFiles, which also needs FS_ListFiles of row F4.

## Row F3, Sys_GetFileTime

Verdict: ratified as proposed in row F3 of the files round, delegated, 2026-11-09: the function keeps its marker as a Windows platform function, the form of `timeGetTime`, because `FILETIME &` has no table row. Sys_FileOutOfDate already calls `SysBackend.GetFileTime` under an AI line by row 7 of the wave6-hand record.

## Row W7, the CPU speed

Verdict: ratified as proposed, delegated, 2026-11-09. Sys_GetCPUSpeedOld and Sys_GetCPUSpeed keep their markers. The one caller is the client's main at `win32/win_main.cpp:1469`, outside the WinDed link set.

## Rows V3, V6, and V9 of the vm round

V9 is closed by row V9 of the sixth ledger. V3 and V6 wait: V3 asks an FS_ReadFile overload over `VmHeader`, and V6 a view-target accessor on `Vm` with the full width of the address. Both are hand pieces whose only callers are bodies, the QVM arm and the G_TRUEMALLOC arms of sv_game, so they go to the vm round. No change.

## Rows G1 and G2, the hand accessors of GameViews.swift

Question: SV_GameSystemCalls reads the module's words through `Slots(syscallWords:)`, `VMA`, and `VMF`, and the server reads the game's memory through five `Server` accessors.

Verdict: ratified as hand views, delegated, 2026-11-09. The generator gives no form for them: Raven's `VMA` and `VMF` are macros over the word list, `sv.gentities` and `sv.gameClients` step by a size the game hands over at run time, and the two parse points walk a `char *` by the bytes COM_Parse reads. `mSharedMemory` stays a hand accessor too, because the FIELDS kind `bytes` reads a `byte *` or an `int *` and the field is a `char *`. GameViews.swift keeps every piece.

## Row G3, TRAP_STRNCPY

Verdict: ratified as proposed, delegated, 2026-11-09: a rule 19 note and a return of 0 at `sv_game.cpp:470`. The arm is body work, so it goes to the sv_game round.

## Row G4, the precision timers

Verdict: ratified as proposed, delegated, 2026-11-09. The switch has no arm for the cgame labels, and the number reaches the default arm as in Raven's switch. No change.

## Rows G5 and T5, the return of CM_ClusterPVS

Verdict: ratified as proposed, delegated, 2026-11-09. The RETURNS kind `bytes` gives `Slots<JKAShared.byte>`, the return twin of the PARAMS kind and the `visibility` field of row CM1 of the sixth ledger. CM_ClusterPVS takes the generated stub.

Files: `rulings.py`, `table.py`, and `cm_test.swift`.

## Rows G6, W2, and T4, the `int *` lists

Question: SV_AreaEntities takes `int *entityList` and CM_BoxLeafnums `int *boxList` as one `inout Int32`. The sv-game record proposes a `Slots<Int32>`, and the sv-snapshot record an `inout [Int32]`.

Verdict: the `Slots<Int32>` form, delegated, 2026-11-09, because the G_ENTITIES_IN_BOX arm hands the module's array, which `VMA` gives as a Slots, and an `inout [Int32]` would copy it. The PARAMS kind `bytes` on an `int *` gives `Slots<Int32>`, the rule of the FIELDS kind on an `int *` of the sixth ledger. `areaParms_t.list` and `leafList_t.list` take the FIELDS kind `bytes`. The locals `touch` of SV_PointContents and `leafs` of SV_LinkEntity join BYTE_STORAGE_LOCALS, the form of `send_buf_Netchan_Transmit` of the fourth ledger, so each caller hands a Slots.

Files: `rulings.py`, `spelling.py`, `sv_world.swift`, and `cm_test.swift`.

## Row G7, `sv_siegePersData`

Verdict: ratified as proposed, delegated, 2026-11-09. `siegePers_t` joins HOST_ROOTS with the game's view `JKAMP.SiegePers`, the row of `qtime_t`, so the variable is a record on EngineStorage at `sv_game.cpp:454`. The two arms are body work for the sv_game round.

## Rows G8 and B4, the debug polygon points

Question: BotImport_DebugPolygonCreate and BotImport_DebugPolygonShow take `vec3_t *points` with `numPoints` beside it. The sv-game record proposes a `Slots<vec3_t>`, and the sv-snapshot record a `[vec3_t]` by value.

Verdict: the `Slots<vec3_t>` form, delegated, 2026-11-09, because the G_DEBUG_POLYGON_CREATE arm hands the module's array and `VMA` has the `Slots<vec3_t>` overload. The PARAMS kind `table`, the row of `verts` of trap_R_AddPolyToScene, now covers a `vec3_t *` too.

Files: `rulings.py`, `spelling.py`, and `sv_bot.swift`.

## Rows G9 and G10

Closed by rows R1 and W6 of the sixth ledger. No change.

## Rows G11 and B2, the waypoint table

Verdict: ratified as proposed, delegated, 2026-11-09. `wpobject_t` joins HOST_ROOTS with the game's view `JKAMP.Wpobject`, so `gWPArray` of `sv_bot.cpp:23` is a `Slots<JKAMP.Wpobject?>` on EngineStorage, the form of the game's `gWPArray`. `wps` of SV_BotWaypointReception takes the PARAMS kind `pointer_table`, the row of `trap_Bot_UpdateWaypoints`.

Files: `rulings.py` and `sv_bot.swift`.

## Rows G12 and N4, the message buffers

Verdict: ratified as proposed, delegated, 2026-11-09. `("msgBuffer", "SV_SendClientGameState")`, `("msgBuffer", "SV_SendClientMapChange")`, and `("msg_buf", "SV_SendClientSnapshot")` join BYTE_STORAGE_LOCALS, the form of `send_buf_Netchan_Transmit` of the fourth ledger. The three MSG_Init lines are body work for their rounds.

Files: `rulings.py` and the generated EngineStorage.

## Row G13, `downloadBlocks`

Question: `byte *downloadBlocks[MAX_DOWNLOAD_WINDOW]` of client_t is a `Slots<OpaquePointer?>`, so the Z_Malloc block of SV_WriteDownloadToClient has no byte form.

Verdict: open, no precedent. No FIELDS kind reads an array of byte pointers: `pointer_table` reads record pointers, and `bytes` reads one pointer. Proposed form: a FIELDS kind `bytes_table` that gives `[Slots<byte>?]` slots of MAX_DOWNLOAD_BLKSIZE bytes each. The two holes of `sv_client.cpp:1158` and `:1243` stay.

## Row W1, the records of sv_world.cpp

Verdict: ratified as proposed, delegated, 2026-11-09. `worldSector_t`, `areaParms_t`, and `moveclip_t` join `ded_types.h` with Raven's text and HOST_ROOTS, the form of `cmd_t` and of row Z1 of the fifth ledger. `sv_worldSectors` is a table on EngineStorage, and the generated `SvEntity.worldSector` is a `WorldSector?`. SnapshotViews.swift and `EngineWorld.sv_worldSectors` are gone, and SV_UnlinkEntity and SV_LinkEntity read `ent!.worldSector` where the hand accessor read `worldSectorNode`. SV_CreateworldSector, SV_AreaEntities_r, and SV_ClipMoveToEntities take the generated stubs. A `const float *` field of the two records reads as the pointer and a read-only vector, a views.py rule of this batch.

Files: `ded_types.h`, `rulings.py`, `views.py`, the views `WorldSector`, `AreaParms`, `Moveclip`, and `SvEntity`, `SnapshotViews.swift`, `EngineWorld.swift`, and `sv_world.swift`.

## Row N1, the NULL `from`

Verdict: ratified as proposed, delegated, 2026-11-09. NULLABLE names `("SV_EmitPacketEntities", "from")`, the precedent of Cvar_Register of the second ledger, so the parameter is `ClientSnapshot?`. The NULL arm at the caller is body work.

## Row N2, `snapshotEntityNumbers_t`

Verdict: ratified as proposed, delegated, 2026-11-09. The record joins `ded_types.h` and HOST_ROOTS, so SV_AddEntToSnapshot and SV_AddEntitiesVisibleFromPoint take the generated stubs over `SnapshotEntityNumbers`.

## Row N3, the entity sort

Verdict: ratified as proposed, delegated, 2026-11-09. `a` and `b` of SV_QsortEntityNumbers take the PARAMS kind `int_value`, the row of SortRanks. The host qsort over a `[Int32]` is the `[T]` form of CommonViews.swift.

## Row N5, the vehicle playerstate

Verdict: VM_ArgPtr keeps the RETURNS kind `raw` of row V1 of the sixth ledger, delegated, 2026-11-09. The record's proposal names a RETURNS kind for one call site of a function that returns many record types, and no precedent gives a function two returns. The site reads the view at the address, body work for the snapshot round.

## Row B1, the botlib edge

Question: the host has no form for `botlib_export_t *botlib_export`, the `botlib_import_t` table, GetBotLibAPI, or the PRT_ print types.

Verdict: open, no precedent in the host. `botlib.h` is a header of the game parse, so `botlib_export_t` and `botlib_import_t` live in CJKAMP_Game, which the host cannot import. A host parse of `botlib.h` would move the records into CJKAMP and change the game's views. Proposed form: a copy of the two records and the PRT_ macros in `ded_types.h` under HOST_ROOTS, the form of row W1, and the export table as a record on EngineStorage whose callback fields take thunks of the botlib stems. The 30 B1 holes and the markers of `be_interface.cpp` that name the two records stay.

## Row B3, the debug polygons

Verdict: ratified as proposed, delegated, 2026-11-09. `bot_debugpoly_t` joins `ded_types.h` and HOST_ROOTS, and TYPES gives `debugpolygons` the type `Slots<BotDebugpoly>?`, the form of `captureData`, so the Z_Malloc table reads by polygon id.

## Row B5, the `void *` returns of sv_bot

Verdict: ratified as proposed, delegated, 2026-11-09. Bot_GetMemoryGame, BotImport_GetMemory, and BotImport_HunkAlloc take the RETURNS kind `raw`, the row of S_Malloc of row Z3 of the fifth ledger.

## Row T1, `traceWork_t`

Verdict: ratified as proposed, delegated, 2026-11-09. `traceWork_t` joins HOST_ROOTS, and C_STRUCT_CLASSES already copies it, so 19 functions of cm_trace and cm_patch take the generated stubs over `TraceWork`.

## Row T2, `sphere_t`

Verdict: ratified as proposed, delegated, 2026-11-09. `sphere_t` joins HOST_ROOTS, the hand view of TraceViews.swift is gone, and CM_Trace takes `Sphere?` by the NULL sweep. CM_TransformedBoxTrace keeps `Sphere.scratch` of the generated view.

## Row T3, `vec3pair_t`

Verdict: ratified as proposed, delegated, 2026-11-09. A const `vec3pair_t` is `[JKAShared.vec3_t]` and a written one `inout [JKAShared.vec3_t]`, the form of the axis.

## Row T6, the `clipMap_t` parameters

Closed by row CM3 of the sixth ledger, and the remaining markers close with row T1.

## Row T7, `cGrid_t`

Verdict: partly ratified, delegated, 2026-11-09. `cGrid_t` joins HOST_ROOTS, so the grid functions take `CGrid`. The `int gridPlanes[MAX_GRID_SIZE][MAX_GRID_SIZE][2]` of CM_GridPlane, CM_EdgePlaneNum, and CM_SetBorderInward keeps its markers, because no table row reads a three-index array parameter, and the record's three-index subscript is a hand piece for the cm_patch round.

## Row T8, the patch records

Closed in part by the sixth ledger, where `planes`, `debugPatchCollide`, and `debugFacet` took storage. TYPES gives `facets` the type `Slots<Facet>?`, the form of `captureData`, delegated, 2026-11-09. The holes of CM_ClearLevelPatches go to the cm_patch round.

## Row T9, the plane parameters

Verdict: ratified as proposed, delegated, 2026-11-09. `p1`, `p2`, `p3` of CM_FindPlane and `p` of CM_PointOnPlaneSide take the PARAMS kind `vec3_const`, and `plane` of CM_PlaneEqual, CM_FindPlane2, and CM_CheckFacetPlane takes the new kind `vec4_const`, the parameter twin of the RETURNS kind `vec4`.

## Row T10, Com_Memset over a Slots

Verdict: ratified as proposed, delegated, 2026-11-09. The overload stays in TraceViews.swift.

## Row T11, CM_DrawDebugSurface

Verdict: ratified as proposed, delegated, 2026-11-09. DEAD names the function, because R_DebugGraphics of `tr_main.cpp:1583` is the one caller and the dedicated build never draws. The stub has the rule 20 note.

## Row U1, the stream helpers of unzip

Verdict: partly ratified, delegated, 2026-11-09. `fin` of unzlocal_getShort, unzlocal_getLong, and unzlocal_SearchCentralDir takes the PARAMS kind `opaque`, the row of the stream of row F2 of the sixth ledger, and `uLong *pX` is `inout CUnsignedLong` by the table. The `short v` and `int v` locals keep no storage row, because BYTE_STORAGE_LOCALS reads no `short` local, and the read goes to the unzip round.

## Row U2, the `unzFile` return

Verdict: ratified as proposed, delegated, 2026-11-09. unzOpen and unzReOpen take the RETURNS kind `opaque`.

## Row U3

Closed by row F11 of the sixth ledger and its merge section.

## Row U4, the file info

Verdict: partly ratified, delegated, 2026-11-09. NULLABLE names `pfile_info` and `pfile_info_internal`, so both are optional views. The two text buffers stay `inout CharBuf`: the NULL sweep gives an optional only to a `String` or a view, and an `inout CharBuf?` has no precedent in the table. The four callers keep their holes.

## Row U5, the CharBuf read of a zip

Waits. The mutating `withSlots` and the overload are hand pieces with a body, so they go to the unzip round.

## Row G1 of the unzip round, the CGenericParser2 signatures

Verdict: ratified as proposed, delegated, 2026-11-09. The new table CXX_CLASSES names `CGenericParser2`, the final class of row C3 of the C++ docket. A reference parameter of the class is the class, a pointer is the optional class, and the RETURNS kind `class_ref` gives the pointer return of Com_ParseTextFile `CGenericParser2?`. The three functions of common.swift take the generated stubs.

## Row G2 of the unzip round, the class file

Verdict: ratified as proposed, delegated, 2026-11-09. The three classes stay in GenericParser2.swift beside GetToken, because rule 21 allows private helpers in the class file.

## Row S1, the C++ `string &`

Verdict: ratified as proposed, delegated, 2026-11-09. The PARAMS kind `std_string` gives `inout String`, the reference twin of `out_string`, and SE_GetFoundFile takes the RETURNS kind `optional_string`. SE_GetFoundFile, SE_R_ListFiles, and SE_BuildFileList take the generated stubs.

## Row S2, the loaded bytes

Verdict: partly ratified, delegated, 2026-11-09. SE_LoadFileData takes the RETURNS kind `optional_bytes`, `Slots<JKAShared.byte>?`, beside the `Slots<UInt8>` of SE_FreeFileDataAfterLoad. `piLoadedLength` is `inout Int32` by the table, with no default, because Swift gives an `inout` parameter no default. The Slots overload of FS_FreeFile is body work.

## Row S3

Verdict: ratified as proposed, delegated, 2026-11-09: `CStringEdPackage` stays a final class.

## Row S4, the constants of `stringed_ingame.h`

Not taken. The HANDOFF list of this batch names S1, S2, S5, and S6, and a new header in the host entry list moves the merge placement of its names, which needs its own gate.

## Row S5, the NULL error text

Verdict: ratified as proposed, delegated, 2026-11-09. SE_Load_Actual, SE_Load, and SE_LoadLanguage take the RETURNS kind `optional_string`. The hand bodies test `psErrorMessage == nil` and `!= nil` as Raven does, and the three AI lines of the empty-text form are gone. ParseLine is a method of CStringEdPackage and keeps its `String`, so SE_Load_Actual stores its empty text as nil under one AI line.

Files: `rulings.py` and `stringed_ingame.swift`.

## Row S6, the defaults of SE_Load

Open. `cxx_default` reads the definition and the first declaration, and SE_Load has its defaults in its definition at `stringed_ingame.cpp:910` with no other declaration, yet the stub has no default. The cause is not found. The one caller with two arguments, SE_LoadLanguage, is inside the hole of row S1.

## The cm-load row, `cmod_base`

Verdict: ratified, delegated, 2026-11-09. TYPES gives `cmod_base` of `cm_load.cpp:64` the type `Slots<JKAShared.byte>?`, the form of `captureData` and the `Slots` that FS_ReadFile gives, so a loader reads a lump at `cmod_base!.suffix(from: l.fileofs)`. The twelve loaders go to the cm_load round.

## The drafter rows

The records name no open drafter row. The `bool` row of the win round closed in the sixth ledger.

## The stages, the botlib, ICARUS, the NPC navigator, and ROFF

Proof: `oracle/codemp/WinDed.vcproj` links `qcommon/RoffSystem.cpp` at :144, `server/NPCNav/gameCallbacks.cpp` and `navigator.cpp` at :365 and :368, the 27 botlib files at :461 to :605, and ten ICARUS files at :736 to :787. The fork links the same code: MPBotlibBotlibFiles, MPEngineAndDedIcarusFiles, MPEngineAndDedServerFiles, and RoffSystem.cpp of `openjk/codemp/CMakeLists.txt:62` to `:336`.

Change: `deferred` of the host row of `project.toml` no longer names `RoffSystem.cpp`, `server/NPCNav/*.cpp`, `botlib/*.cpp`, and `icarus/*.cpp`. The srcglob already held the files, and the host defines already hold WinDed's `DEDICATED` and `BOTLIB`, so no define changes. The `mp-botlib` extract is a header-only unit of the botlib include order, outside the merge, and the batch does not use it: the host parse of the unit reads the botlib files itself. Folding `botlib.h` into the host entry list would move its records out of CJKAMP_Game, row B1.

The run gives 36 new stems with 795 `portMissing` lines. BlockStream, Interface, Sequence, Sequencer, and TaskManager give no stem, because every definition is a method of a class: the skeleton skipped 3 constructors, 3 destructors, and 33 methods in BlockStream.cpp, 1, 1, and 16 in Sequence.cpp, 1, 1, and 41 in Sequencer.cpp, 3, 3, and 46 in TaskManager.cpp, 1, 1, and 22 in Instance.cpp, 1, 1, and 20 in RoffSystem.cpp, and 4, 4, and 71 in navigator.cpp.

| Stem | `portMissing` | Signature markers |
|---|---|---|
| be_aas_bspq3 | 20 | 4 |
| be_aas_cluster | 22 | 0 |
| be_aas_debug | 19 | 1 |
| be_aas_entity | 15 | 3 |
| be_aas_file | 7 | 1 |
| be_aas_main | 17 | 0 |
| be_aas_move | 21 | 5 |
| be_aas_optimize | 8 | 7 |
| be_aas_reach | 53 | 6 |
| be_aas_route | 51 | 11 |
| be_aas_routealt | 4 | 1 |
| be_aas_sample | 28 | 13 |
| be_ai_char | 19 | 5 |
| be_ai_chat | 60 | 31 |
| be_ai_gen | 2 | 0 |
| be_ai_goal | 43 | 18 |
| be_ai_move | 67 | 47 |
| be_ai_weap | 13 | 4 |
| be_ai_weight | 21 | 20 |
| be_ea | 34 | 1 |
| be_interface | 16 | 5 |
| l_crc | 6 | 0 |
| l_libvar | 13 | 4 |
| l_log | 7 | 1 |
| l_memory | 8 | 4 |
| l_precomp | 80 | 67 |
| l_script | 38 | 35 |
| l_struct | 9 | 9 |
| GameInterface | 16 | 1 |
| Instance | 0 | 0 |
| Memory | 2 | 1 |
| Q3_Interface | 44 | 1 |
| Q3_Registers | 16 | 4 |
| gameCallbacks | 9 | 0 |
| navigator | 7 | 0 |
| RoffSystem | 0 | 0 |

The new stems needed three generator fixes and one hand table, each without a game or cgame change:

- `HUNK_ID` of `l_memory.cpp:24` is `0x87654321l`, past INT_MAX, so a hex literal past INT_MAX is `UInt32`, the C type of such a literal.
- `be_aas_debug.cpp` declares an `int debugpolygons[]` of its own, so a TYPES key `stem:name` names the variable of one file, and the row of B3 is `sv_bot:debugpolygons`.
- `logfile` of `l_log.cpp` beside the one of `common.cpp` gives the storage the name `common_logfile`, and the adopted forward of common.swift reads it.
- `VEC_UP` and `VEC_DOWN` of `be_aas_move.cpp:213` and `:215` take the `state_data` form, hand properties of `EngineWorld`, the form of the renderer tables of the sixth ledger.

## Row C, the C++ classes of the stages

Question: ICARUS, the navigator, and ROFF are C++ classes: `CBlock`, `CBlockMember`, and `CBlockStream` of BlockStream.cpp, `ICARUS_Instance` of Instance.cpp, `CSequence`, `CSequencer`, `CTask`, `CTaskGroup`, and `CTaskManager`, `CNavigator`, `CNode`, `CEdge`, and `CPriorityQueue` of navigator.cpp, and `CROFFSystem` of RoffSystem.cpp. No ledger rules them.

Verdict: open, no precedent. Proposed form: each class is a `final class` with Raven's name, fields, and methods, the form of `CStringEdPackage` and `CGenericParser2` and rule 17, one class per file with its private helpers. Its `std::` members are `Array`, `Dictionary`, and `String`. A file-scope instance, `TheRoffSystem` or the navigator, is a `let` of `EngineWorld`. A name joins CXX_CLASSES when its class lands, so the functions that take it lose their markers. Until then the functions keep their markers.

## Rule 11

`grep Unsafe` over `Sources/JKAMP_DedLogic` gives the signatures of the RETURNS and PARAMS kind `raw`, among them the three new rows of B5, and vm_interpreted.swift. No body of this batch adds raw arithmetic.

## The gate, as far as it ran

The batch is paused by the user's word before the end of step 3. The loop of step 3 ran six passes of the sequence. Passes 1 to 5 each stopped at the build: a `const float *` field of `moveclip_t` and `areaParms_t` that views.py wrote with a setter, the `HUNK_ID` literal, `VEC_UP` and `VEC_DOWN`, the optional `from` of SV_EmitPacketEntities, and the renamed `logfile` storage. Each pass fixed its findings and ran the sequence again. The sixth pass:

- The sequence ran whole, every step exit 0.
- `swift build` passed, exit 0.
- The game snapshot check read 372 files and found no difference, exit 0.
- The cgame snapshot check read 246 files and found no difference, exit 0.
- The host snapshot check read 373 files and found a difference, exit 1: 49 files differ and 120 are new.
- `swift test --no-parallel` passed 147 tests in nine runs, exit 0.
- The tool tests passed 97 tests with 14 skipped, exit 0.
- `draftcheck.py --unit mp-engine-ded` over cm_load, cm_patch, cm_test, cm_trace, common, files_pc, stringed_ingame, stringed_interface, sv_bot, sv_game, sv_snapshot, sv_world, unzip, vm, and win_main gave 1208 holes, 0 cascade errors, 0 defects, and 133 compile holes over 19 passes, exit 0.
- Not run yet: `swift build --product jampded` and the run of `.build/debug/jampded`.

The `portMissing` total over `Sources/JKAMP_DedLogic` is 1549: 795 in the 36 new stems and 754 in the old stems, from 765 on master.
