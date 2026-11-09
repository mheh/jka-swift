# The open rows of the dedicated host, the sixth ledger

This record holds the sixth batch of open rows of the dedicated host: the generator rows of the six round records of the sixth wave, `dedicated-round-common.md`, `dedicated-round-files.md`, `dedicated-round-win.md`, `dedicated-round-vm.md`, `dedicated-round-sv-core.md`, and `dedicated-round-cm-load.md`, all under `notes/2026-11-09/`. The user ruled the rows by delegation on 2026-11-09, and the main session ruled Z6, V10, W4 with V2, F14, the HOST_ROOTS rows, the RETURNS and PARAMS rows, the drafter rows, and the rows that wait on another stem. The hand rows of the six records went to a sibling batch: Com_Error's drop path, `rand` and `random`, `qsort`, the SysBackend additions, the Win32 drops, and the file list form. The landing is the branch `dedicated-rulings-batch-6`, off master at `5c71cb9`, in the worktree `/tmp/jka-ded-rules-6`.

The generator sequence of `tools/oracle-closure/README.md` ran whole after every change: the extracts of the nine merge modules, merge, tables, check, the reexport of `JKAShared` and `JKAMP_Ded`, views, skeleton, and manifest for the three units, and traps and channel for the game and the cgame. The gate found two generator defects, and the sequence ran whole a second time after their fix. The merge moved an SP UI header on this case-insensitive file system, and the landing kept master's `Sources/CJKASP_UI`. Each row below proves the record's claim at Raven's line and at the port's site, names the precedent it takes, and fills the body lines the row unblocks.

## Row Z6, the Ghoul2 and renderer names, stage E5

Question: the server, common, z_memman_pc, and cm_load call Ghoul2 and renderer functions that have no Swift stub, because `deferred` of `project.toml` held the files back.

Sites: sv-core row S1 at `oracle/codemp/server/sv_init.cpp:481`, `:533`, `:534`, `:578`, `:618`, `:670`, `:677`, `:735`, and `:885`, and `sv_main.cpp:918`. Common row G1 at `common.cpp:1598` and `:1768` to `:1775`. The z_memman_pc holes at `z_memman_pc.cpp:226`, `:768`, and `:776`. Cm-load row CM6 at `cm_load.cpp:800` to `:809` and `:1067` to `:1078`.

Proof: `oracle/codemp/WinDed.vcproj:301-425` links the five Ghoul2 files and nine renderer files, and `grep -l DEDICATED` over `oracle/codemp/renderer/*.cpp` gives `tr_backend`, `tr_ghoul2`, `tr_image`, `tr_init`, `tr_main`, `tr_mesh`, `tr_model`, and `tr_shader`. The fork's `MPDedicatedRendererFiles` of `openjk/codemp/CMakeLists.txt:634` names the same files, with `tr_skin.cpp` split out of Raven's `tr_image.cpp`, which holds `R_InitSkins`. WinDed also links `cm_terrain.cpp`, which defines `CCMLandScape`, and the RMG files, where `RM_Manager.cpp:23` defines `TheRandomMissionManager`.

Verdict: ruled by the main session, 2026-11-09. `deferred` of the host row no longer names `codemp/renderer/*.cpp` and `codemp/ghoul2/*.cpp`, and the RMG entry names every RMG file but `RM_Manager.cpp`. `cm_terrain.cpp` leaves the list. The parse already read the files, so no define changes. The fills at Raven's lines: `G2API_SetTime(svs.time, 0)` at the five sites, `RE_RegisterMedia_LevelLoadBegin(server, eForceReload)`, `R_InitSkins()`, `R_InitShaders(true)`, and `R_SVModelInit()` of SV_SpawnServer, `RE_RegisterModels_LevelLoadEnd(true)` of Z_Malloc, `R_HunkClearCrap()` and the Ghoul2 leak report of Hunk_Clear, and `G2Time_ReportTimers()` and `G2Time_ResetTimers()` of Com_Frame.

Open: four sites name a C++ class of rule 17, which a stem gives no Swift name. `G2VertSpaceServer = &CMiniHeap_singleton` of SV_Init holds a `CMiniHeap`, the start and end of `G2PerformanceTimer_PreciseFrame` of Com_Frame hold a `timing_c`, and CM_ClearMap and CM_ShutdownTerrain delete `TheRandomMissionManager` and call the methods of `CCMLandScape`. Each keeps its hole, and its Port-note now names the C++ track.

Files: `tools/oracle-closure/project.toml`, the 15 new stems under `Sources/JKAMP_DedLogic`, `Sources/JKAMP_Ded/Generated/Storage/EngineVariables.swift`, `Sources/JKAMP_DedLogic/EngineWorld.swift`, `sv_init.swift`, `sv_main.swift`, `common.swift`, `z_memman_pc.swift`, and `cm_load.swift`.

## The E5 stems

| Stem | `portMissing` lines | Signature markers |
|---|---|---|
| G2_API | 99 | 88 |
| G2_bolts | 7 | 7 |
| G2_bones | 58 | 54 |
| G2_misc | 35 | 22 |
| G2_surfaces | 14 | 13 |
| tr_backend | 1 | 0 |
| tr_ghoul2 | 44 | 39 |
| tr_image | 11 | 2 |
| tr_init | 8 | 1 |
| tr_main | 4 | 0 |
| tr_mesh | 1 | 0 |
| tr_model | 30 | 10 |
| tr_shader | 42 | 14 |
| cm_terrain | 20 | 14 |
| RM_Manager | 0 | 0 |

The 15 stems hold 374 `portMissing` lines. Most markers are a `CGhoul2Info_v &` or a `CGhoul2Info *` parameter, which the C++ track shapes. RM_Manager.cpp defines the methods of `CRMManager` and one global, so its stub holds the `TODO: Port global` marker of `TheRandomMissionManager` alone. No round ran on these stems.

The new stems needed four generator fixes, each without a game or cgame change:

- A C++ overload whose parameters have no table row spells the empty signature of the overload before it, `G2_SetupModelPointers` of `G2_API.cpp:2675` and `:2773` and `G2_Animate_Bone_List` of `G2_bones.cpp`. The second marker is the form of a NOT_PORTED stub: the cite, Raven's line, the `TODO: Port` line, and no function.
- `GORE_TAG_UPPER` of `G2_misc.cpp:29` is a constant of the logic target, which the variables struct in the view target cannot see. The skeleton writes the hand line comment, and `EngineWorld.init` sets `CurrentTag` and `CurrentTagUpper`.
- `FILE_HASH_SIZE` stands in cvar.cpp, tr_model.cpp, and tr_shader.cpp, so the adopted cvar.swift takes the skeleton's `private let` and `private var hashTable`, and the storage is `cvar_hashTable`.
- Four data tables of the renderer stems take the `state_data` form: `FakeGLAFile` of tr_model.cpp, and `lightmapsNone`, `lightmaps2d`, `stylesDefault`, and `materialNames` of tr_shader.cpp are hand properties of `EngineWorld`. `LIGHTMAP_NONE` and `LIGHTMAP_2D` of `tr_local.h` have no re-export in the host target, so their two tables hold Raven's values under a rule 24 line each.

## Row V10, the return of VM_Call

Question: VM_Call returns `Int32`, and the module's vmMain returns a word, which holds the address of the denial text for GAME_CLIENT_CONNECT.

Sites: `oracle/codemp/qcommon/vm.cpp:787` and `:816`, and `jka_vmmain_fn` of `Sources/CJKAHost/include/jka_host.h`, which returns `intptr_t`.

Verdict: ruled by the main session, 2026-11-09. The RETURNS kind `word` gives VM_Call `Int`, and the PARAMS kind `word` gives the `intValue` of VM_ExplicitArgPtr `Int`, so `VM_ExplicitArgPtr(gvm!, VM_Call(...))` keeps the whole word. `runEntryPoint` of `VmEntry.swift` returns the word of the export. The two QVM arms widen their `int` under one AI line.

Files: `rulings.py`, `table.py`, `spelling.py`, `Sources/JKAMP_Ded/VmEntry.swift`, and `Sources/JKAMP_DedLogic/vm.swift`.

## Rows W4, V2, and V4, Sys_LoadDll and the systemCalls field

Question: Sys_LoadDll takes `int (**entryPoint)(int, ...)` and the syscall entry, VM_Create stores `systemCalls` into `vm->systemCall`, and the logic target cannot import CJKAHost, where `jka_load_dll` lives.

Sites: `oracle/codemp/null/win_main.cpp:784`, `oracle/codemp/qcommon/vm.cpp:403` to `:408`, `:506`, and `:518`.

Verdict: ruled by the main session, 2026-11-09, by the win record's proposal. `entryPoint` takes the PARAMS kind `raw`, `systemcalls` the kind `opaque`, and the return the RETURNS kind `opaque`, the row of `CG_G2WeaponInstance`. VM_Create hands `vm!.entryPointAddress`, the address of the field in the view target, the form of `slotAddress` of `NodeSlots.swift`, and `nil` for VM_DllSyscall under an AI line, because the C VM_DllSyscall reaches the module through the load. `LoadLibrary` of `VmEntry.swift` is a closure that the shell installs over `jka_load_dll` in `Sources/jampded/main.swift`, the shape of `sharedChannel`. Sys_LoadDll has Raven's body: the name with `DLL_SUFFIX`, `jampgamearm64.dylib` on Apple arm64, Sys_UnpackDLL, and the load from the current folder, `fs_basepath`, and `fs_cdpath`.

For V2, the PARAMS kind `callback` gives `systemCalls` the callback typealias of the field, `VmSystemCall?`, the form of a function-pointer return, so VM_Create reads `vm!.systemCall = systemCalls` and VM_Restart passes the field back to VM_Create as Raven does.

Open: SV_InitGameVM of sv_game.cpp, a stem of the second wave, calls VM_Create, so no run reaches the dll arm yet. It waits on sv_game.

Files: `rulings.py`, `spelling.py`, `Sources/JKAMP_Ded/VmEntry.swift`, `Sources/jampded/main.swift`, `Sources/JKAMP_DedLogic/win_main.swift`, and `vm.swift`.

## Row V9, the Swift VM_DllSyscall

Verdict: ratified as proposed, delegated, 2026-11-09. NOT_PORTED names VM_DllSyscall, the precedent of ZoneTailFromHeader of ledger 5 row 2, and vm.swift takes the skeleton's text with no function.

Files: `rulings.py` and `Sources/JKAMP_DedLogic/vm.swift`.

## Row V1 and row S3, the `void *` returns of vm.cpp

Question: VM_Alloc, VM_ArgPtr, BotVMShift, and VM_ExplicitArgPtr return `void *` with no RETURNS row.

Sites: `oracle/codemp/qcommon/vm.cpp:227`, `:640`, `:657`, and `:742`, and the `denied` sites of `sv_init.cpp:700` and `sv_ccmds.cpp:326`.

Verdict: ratified as proposed, delegated, 2026-11-09. VM_Alloc, VM_ArgPtr, and BotVMShift take the RETURNS kind `raw`, the row of Z_Malloc and row Z3 of ledger 5. VM_ExplicitArgPtr takes the kind `optional_string` by the main session's ruling for row S3, because every caller casts the return to `char *`. The `denied` sites of SV_SpawnServer and SV_MapRestart_f read `denied = VM_ExplicitArgPtr(gvm!, VM_Call(gvm!, GAME_CLIENT_CONNECT, i, false, isBot))`. VM_Create stores the two VM_Alloc blocks as the `Slots` of the fields, each under an AI line.

Open: the bodies of VM_ArgPtr, BotVMShift, and VM_ExplicitArgPtr read the module's data at `dataBase + intValue`, which is raw arithmetic and a text read at a word, and VM_ArgPtr returns NULL, which the `raw` kind holds no seat for. Their drafts keep the holes. Their callers are sv_game, sv_client, sv_snapshot, and sv_bot, stems of the second wave.

Files: `rulings.py`, `Sources/JKAMP_DedLogic/vm.swift`, `sv_init.swift`, and `sv_ccmds.swift`.

## Row V3, the QVM image

Verdict: partly ratified, delegated, 2026-11-09. `dataBase` and `instructionPointers` of `vm_t` take the FIELDS kind `bytes`, the row of `msg_t.data` of ledger 3 row 1, with the `int *` form below. VM_LoadSymbols reads `vm.instructionPointers![value]`. The interpreter and its test take the `base` of the `Slots`, the smallest edit that compiles.

Open: the read of the image into a `vmHeader_t *`, the casts of the header to `int *`, the clear of `dataLength` bytes of a field `Slots` with the widest count, and `FS_FreeFile( header )` keep their holes. The record's proposal is an `FS_ReadFile` overload over `VmHeader`, which is hand work, and the dll host never takes the QVM path.

Files: `rulings.py`, `views.py`, `Sources/JKAMP_Ded/Generated/Views/Vm.swift`, `vm.swift`, `vm_interpreted.swift`, and `Tests/JKAMP_DedLogicTests/QVMInterpreterTests.swift`.

## Row V5, nullSym

Verdict: ratified as proposed, delegated, 2026-11-09. `("nullSym", "VM_ValueToFunctionSymbol")` joins BYTE_STORAGE_LOCALS, the form of `send_buf_Netchan_Transmit` of ledger 4 row 2, and the record is `nullSym_VM_ValueToFunctionSymbol` on EngineStorage. The body returns it at Raven's line. The skeleton's rule 24 line of a static local now says static, not stack.

Files: `rulings.py`, `skeleton.py`, `EngineStorage.swift`, and `vm.swift`.

## Row V7, the symbol chain of VM_LoadSymbols

Verdict: ratified with the precedent of row 6 of the first ledger, delegated, 2026-11-09. A record pointer field of FIELDS kind `slot` carries `<field>Slot`, the slot of the field as a `Slots<View?>` of count 1, so `prev = &vm->symbols` reads `prev = vm.symbolsSlot`, `*prev = sym` reads `prev[0] = sym`, and `prev = &sym->next` reads `prev = sym.nextSlot`. `symName`, `char symName[1]`, takes a SLOT_BOUNDS row of `MAX_TOKEN_CHARS`, the form of `winding_t.p` of row 3 of the first ledger, so the setter holds Raven's `Q_strncpyz`. The record proposed the `Winding.byteCount(points:)` form, and the bound of the setter is the nearer precedent. The body is Raven's from `prev` to the map store.

Files: `rulings.py`, `views.py`, `VmSymbol.swift`, `Vm.swift`, and `vm.swift`.

## Row V6, the shifted words, and row V8, the profile sort

V6 waits on a view-target accessor on `Vm` with the full width of the address, the hand piece the record proposes, and its callers are the G_TRUEMALLOC arms of sv_game. V8 waits on `qsort` in JKAShared, a row of the sibling batch. Both keep their holes.

## Rows S1 and W5, the event ring

Question: `sysEvent_t` had no view, so the ring of common.cpp, the queue of win_main.cpp, and four functions that return the record by value had no form.

Sites: `oracle/codemp/qcommon/common.cpp:752`, `:789`, `:837`, `:850`, `:881`, `:921`, and `:1028`, and `oracle/codemp/null/win_main.cpp:1113`, `:1127`, and `:1160`.

Verdict: ratified as proposed, delegated, 2026-11-09. `sysEvent_t` joins HOST_ROOTS, the `bitStorage_t` and `zone_t` form, so `SysEvent` is generated, and `com_pushedEvents` and `eventQue` are tables on EngineStorage. A `sysEvent_t *` parameter is the view. The RETURNS kind `record` gives Com_GetRealEvent, Com_GetEvent, and Sys_GetEvent the view of a record that lives past the call: the BYTE_STORAGE_LOCALS record of the local `ev` of Com_GetRealEvent and of Sys_GetEvent, or a slot of the ring. A caller copies it into its own scratch, `ev.copy(from: Com_GetEvent())`. `evPtr` takes the FIELDS kind `raw`, the row of `itemDef_t.typeData`, because Raven casts it back by `evType`, and `ptr` of Sys_QueEvent takes the PARAMS kind `raw`. `sys_packetReceived` joins BYTE_STORAGE_VARS, the `cmd_text_buf` form, so MSG_Init takes it.

Filled: Com_InitPushEvent, Com_GetRealEvent, Com_PushEvent with its static `printedWarning`, Com_GetEvent, Com_EventLoop with its static `seed`, Com_Milliseconds, Sys_QueEvent, and Sys_GetEvent. A record read of the journal is `Slots(record: ev).bytes`, the form of the delta walkers of ledger 3 row 1. The packet copy is the tail of a `Slots<byte>` over the zone block from the byte offset of one `Netadr`, and the console text is `cString(at: ev.evPtr!)`, each under an AI line. The Win32 message pump of Sys_GetEvent drops under an AI line, the form of the GetMessage loop of Sys_Error in the win round.

Open: the journal write of `ev.evPtr` in Com_GetRealEvent keeps its hole, because a raw field gives no `Slots` without the length beside it at the call.

Files: `rulings.py`, `table.py`, `views.py`, `SysEvent.swift`, `EngineStorage.swift`, `common.swift`, `win_main.swift`, and `EngineWorld.swift`.

## Row S2, bufData

Verdict: ratified as proposed, delegated, 2026-11-09. `("bufData", "Com_EventLoop")` joins BYTE_STORAGE_LOCALS, the form of `send_buf_Netchan_Transmit` of ledger 4 row 2, and Com_EventLoop reads `MSG_Init(buf, bufData_Com_EventLoop, ...)`.

Files: `rulings.py`, `EngineStorage.swift`, and `common.swift`.

## Row R1, the qtime_t parameter

Verdict: ratified as proposed, delegated, 2026-11-09. `qtime_t` joins HOST_ROOTS with the game's name and target, `JKAMP.Qtime`, the row of `vmCvar_t`, and a NULLABLE row makes the parameter optional, the precedent of Cvar_Register of ledger 2 row 5. Com_RealTime has Raven's body. `CommonBackend.localtime` of `CommonViews.swift` does Raven's `localtime(&t)` and the copy of the fields when it is not NULL, under an AI line at the call, the form of `CommonBackend.asctime`.

Files: `rulings.py`, `Sources/JKAMP_Ded/CommonViews.swift`, and `common.swift`.

## Row F14 and common row F1, the `void *` buffers of the file system

Verdict: ruled by the main session, 2026-11-09, with the precedent of ledger 5 row 6. The buffers of FS_Read, FS_Read2, FS_Write, FS_WriteFile, Sys_StreamedRead, and unzReadCurrentFile take the PARAMS kind `bytes`. The CharBuf overload of FS_Write forwards through `withSlots`, the form of the CharBuf NET_SendPacket, so `FS_Write(msg, strlen(msg), logfile)` of Com_Printf reads as Raven wrote it. `FileBackend.fread` and `fwrite` take the `Slots<byte>` and its byte offset. FS_ReadFile hands `Slots(scalars: buf, count: Int(len) + 1)` over its zone block. Sys_UnpackDLL reads the dll through the CharBuf forms of FS_ReadFile, FS_Write, and FS_FreeFile under an AI line, because the `bytes` FS_Write takes no handle.

Files: `rulings.py`, `Sources/JKAMP_Ded/FileBackend.swift`, `files_pc.swift`, `files_common.swift`, `win_main.swift`, `common.swift`, and the generated `unzip.swift`.

## Row F2, FILE *

Verdict: ratified as proposed, delegated, 2026-11-09. FS_FileForHandle takes the RETURNS kind `opaque`, the row of `CG_G2WeaponInstance`, and has Raven's body. FS_ForceFlush, FS_filelength, FS_Write, and FS_Seek call it at Raven's lines.

Files: `rulings.py` and `files_pc.swift`.

## Rows F5, F6, and F1, the files.h views

Verdict: ratified as proposed, delegated, 2026-11-09. `fileHandleData_t`, `searchpath_t`, `pack_t`, `directory_t`, `fileInPack_t`, `qfile_ut`, and `qfile_gut` join HOST_ROOTS, the form of ledger 5 row 1, with the hand view names `Qfile_u` and `Qfile_gu`. A named union that a root row names now takes a view. `FIELD_NAMES` gives `pack_t.handle` the name `packHandle`, a `void *` field. `qfile_gut.o` takes a new FIELDS kind `opaque`, the record's proposal, because the views would otherwise walk into the SDK's `FILE`. `pack_t.hashTable` takes the FIELDS kind `pointer_table`, the field twin of the PARAMS kind, with the widest count. `fs_searchpaths` is a variable of EngineVariables and `fsh` a table on EngineStorage, so the two hand properties of EngineWorld are gone. FileBackend.swift keeps `PATH_SEP` and the stream calls.

FS_PakIsPure has Raven's body from the drafter, and FS_FileIsInPAK and FS_Path_f call it at Raven's lines.

Open: FS_LoadZipFile takes the generated signature, `-> Pack?`, and its body waits on unzip, whose unzOpen, unzGetGlobalInfo, and unzGetCurrentFileInfo carry signature markers.

Files: `rulings.py`, `views.py`, `spelling.py`, the new views, `FileBackend.swift`, `EngineWorld.swift`, `files_common.swift`, and `files_pc.swift`.

## Row F7, FS_ReplaceSeparators

Question: the text sweep read `char *path` as a `String`, though Raven writes through the local `s`.

Proof: the store `*s = PATH_SEP` of `files_common.cpp:282` did not parse, because the host parse defines no `WIN32` and so no `PATH_SEP` of `q_shared.h:178`. The sweep saw no store.

Verdict: ratified with the precedent of the mp-renderer unit, delegated, 2026-11-09. The host defines take WinDed's `PATH_SEP='\\'`, the form of the `PATH_SEP='/'` define of the mp-renderer row, so the store parses and the skeleton gives `inout CharBuf`. NOT_PORTED_MACROS names `PATH_SEP`, because the hand constant of FileBackend.swift takes the separator of the platform that builds. The hand overload is the function now, and the `String` form is gone.

Files: `project.toml`, `rulings.py`, `tests/test_project.py`, `CJKAMP_Ded_platform.h`, `Generated/unknown.swift`, and `files_common.swift`.

## Row F8, FS_ShiftedStrStr

Verdict: ratified as proposed, delegated, 2026-11-09. The RETURNS kind `optional_string` gives `-> String?`, and the body returns the text from the match, the form of Com_StringContains of the common round, under an AI line.

Files: `rulings.py` and `files_pc.swift`.

## Row F9, the journal length

Verdict: ratified as proposed, delegated, 2026-11-09. `("len", "FS_ReadFile")` joins BYTE_STORAGE_LOCALS, a `Slots<Int32>` of one slot. Each journal site copies `len` into the slot and hands on `len_FS_ReadFile.bytes`, or reads into the slot and takes `len` from it, the form of `key_Com_BlockChecksumKey`. Both FS_ReadFile forms have Raven's journal read arm whole.

Files: `rulings.py`, `EngineStorage.swift`, and `files_pc.swift`.

## Row F10, FS_ReorderPurePaks

Verdict: partly ratified, delegated, 2026-11-09. `searchpath_t.next` takes the FIELDS kind `slot`, so `&s->next` reads `s.nextSlot`. `&fs_searchpaths` has no slot, because the head is a variable of EngineVariables, so the hole stays and its Port-note says so. The body returns at once while `fs_numServerPaks` is 0, and only the client sets it.

Files: `rulings.py`, `Searchpath.swift`, and `files_pc.swift`.

## Rows F11 and F13, unz_s and the CharBuf read of a zip

F11 is ratified as proposed, delegated, 2026-11-09: `unz_s` joins HOST_ROOTS as `UnzS`, and its `ZIP_FILE *file` and the one of `file_in_zip_read_info_s` take the FIELDS kind `opaque`. The pak arm of FS_FOpenFileRead waits on unzip and FS_PakIsPure. F13 waits on unzip: unzReadCurrentFile now takes the `Slots<byte>` of F14, and the CharBuf FS_Read keeps its hole.

Files: `rulings.py`, `UnzS.swift`, and the generated `unzip.swift`.

## Row W1, Sys_GetBotAIAPI

Verdict: ratified as proposed, delegated, 2026-11-09. The RETURNS kind `opaque`, the row of `CG_G2WeaponInstance`, and the body is Raven's `return nil`.

Files: `rulings.py` and `win_main.swift`.

## Row W6, Sys_SnapVector

Verdict: ratified as proposed, delegated, 2026-11-09. The PARAMS kind `vec3_mut`, the row of `trap_SnapVector`. The body rounds each component to the nearest integer and to the even one on a tie, the rounding of the x87 `fld` and `fistp` Raven wrote, under an AI line.

Files: `rulings.py` and `win_shared.swift`.

## Row W9, the socket statics

Verdict: ratified with the precedent of the Windows type defines, delegated, 2026-11-09. The host parse had no `SOCKET` and no `INVALID_SOCKET`, so the declarations of `win_net.cpp:27` to `:29` did not parse and the write sweep saw no store. The host defines take `SOCKET=int` and `INVALID_SOCKET=(-1)`, the values of SysBackend.swift, beside `DWORD` and `HANDLE`. `ip_socket` and `socks_socket` are variables of EngineVariables with the hand line comment of `ipx_socket`, EngineWorld.init sets the three, and the two hand properties are gone.

Files: `project.toml`, `tests/test_project.py`, `CJKAMP_Ded_platform.h`, `EngineVariables.swift`, `EngineWorld.swift`, and `win_net.swift`.

## Row W8, SOCKS

W8 waits on the TCP client of SysBackend, the sibling batch's SysBackend additions. `NET_OpenSocks` is the one writer of `usingSocks`, so the SOCKS arm of Sys_SendPacket has no path.

## Rows CM1 to CM4, the clip map

Verdict: ratified as proposed, delegated, 2026-11-09. `clipMap_t`, `cbrush_t`, `cbrushside_t`, `cNode_t`, `cLeaf_t`, `cPatch_t`, `cArea_t`, and `CCMShader` join HOST_ROOTS, the last as `CmShader`, because the view target imports the C struct under its own name. The disk records of `qfiles.h` join for CM2: `dheader_t`, `dshader_t`, `dmodel_t`, `dnode_t`, `dleaf_t`, `dplane_t`, `dbrush_t`, `dbrushside_t`, `dsurface_t`, and `mapVert_t`, and `lump_t` as the view `JKAMP.Lump`, where the merge places it. `leafbrushes`, `leafsurfaces`, `areaPortals`, and `visibility` take the FIELDS kind `bytes`, and `surfaces` the kind `pointer_table`. `cmg` is a record and `SubBSP` a table on EngineStorage, and `box_brush` is a variable of EngineVariables, so ClipMapViews.swift and the three EngineWorld properties are gone. The `Cplane` subscript stays as `CplaneSubscript.swift`, because `box_planes` holds one `Cplane?`.

Two shape rules close CM3 and CM4: a C++ reference to a record is its view, and a C++ class that C_STRUCT_CLASSES copies is its view in the C++ parse of a body. The skeleton gives an `inout` parameter no default, so CM_ClipHandleToModel takes `inout ClipMap?` with no `= nil`.

Filled: CM_BoundBrush, CM_LumpChecksum, CM_Checksum, CM_ClipHandleToModel, and CM_ModelContents_Actual from the drafter, and the parsers of cm_shader, SV_ParseSurfaceParm, SV_ParseMaterial, CM_ParseVector, CM_ParseShader, and both CM_GetShaderInfo forms.

Open: the twelve `CMod_Load*` loaders and CM_LoadMap_Actual take the generated signatures, and their bodies wait on the cm_load round. Each reads `cmod_base`, the `byte *` of `cm_load.cpp:64`, which has no storage row, and steps a record pointer with `+=`. Row CM5 is hand work and stays with its round.

Files: `rulings.py`, `spelling.py`, `skeleton.py`, the new views, `EngineStorage.swift`, `EngineVariables.swift`, `CplaneSubscript.swift`, `EngineWorld.swift`, `cm_load.swift`, and `cm_shader.swift`.

## The drafter row

Question: the drafter tests a C++ `bool` against zero, `if baseTime == 0` of Sys_Milliseconds, and writes a C++ `true` as `` `true` ``.

Verdict: ratified as proposed, delegated, 2026-11-09. `is_bool` of `draft_expressions.py` takes a C++ `bool` and a C++ bool literal, and the literal prints as itself, so the drafts read `if !baseTime` and `while true`. The fix moves no game and no cgame draft.

The host snapshot crashed in `draft_calls.py` on an array field whose declared type is a typedef, which the new `Slots<byte>` parameters reach. `declared_element` reads the element of the canonical array for such a field.

Files: `draft_expressions.py` and `draft_calls.py`.

## Rows that wait

- Common row C3, the CGenericParser2 functions: waits on GenericParser2.
- Common row V1, the version constants: not taken. The reexport of `JKAMP_Ded` reads no `game_version.h`, and the entry list of the host unit is a parse change outside the rows of this batch.
- Common row O1 is a hole by the rule of ledger 5 row 7, and C1 is a row of the sibling batch.

## Rule 11

`grep Unsafe` over `Sources/JKAMP_DedLogic` gives the signatures of the RETURNS and PARAMS kind `raw`: Z_Malloc, S_Malloc, Hunk_Alloc, Hunk_AllocateTempMemory, VM_Alloc, VM_ArgPtr, BotVMShift, Sys_LoadDll, and Sys_QueEvent, the precedent of ledger 5 row 3. vm_interpreted.swift keeps the raw locals of master. No body of this batch adds raw arithmetic: an offset into a block is `suffix(from:)` of a `Slots`.

## The gate

The gate ran twice. The first run found three defects in the tools, which one fix pass closed: the overload marker of the skeleton fired on a function with no overload, the `module_lets` initializer rule reached the bg variables, and the drafter crashed on a typedef array field. The second run is the record below, on the final tree.

- The game snapshot check read 372 files and found no difference, exit 0.
- The cgame snapshot check read 246 files and found no difference, exit 0.
- The host snapshot check read 253 files and found a difference, exit 1. 53 files differ: the bodies of cm_load, cm_patch, cm_shader, cm_test, cm_trace, common, files_common, files_pc, GenericParser2, msg, sv_ccmds, sv_client, sv_game, sv_init, sv_main, unzip, vm, win_main, win_net, and win_shared, the manifests of cm_load, cm_patch, cm_shader, cm_test, common, cvar, files_common, files_pc, sv_ccmds, sv_init, sv_main, sv_net_chan, unzip, vm, win_main, win_net, win_shared, and z_memman_pc, the skeleton text of cm_load, cm_patch, cm_shader, cm_test, common, cvar, files_common, files_pc, unzip, vm, win_main, win_net, and win_shared, and the views Vm and VmSymbol. 82 files are new: the bodies, the manifest, and the skeleton text of the 15 E5 stems, 35 views of JKAMP_Ded, and Lump and Qtime of JKAMP.
- `swift build -j 2` passed, exit 0, 0 errors.
- `swift test --no-parallel -j 2` passed 146 tests in nine runs, exit 0, 0 failures, 0 skipped.
- The tool tests passed 97 tests with 14 skipped, exit 0.
- `draftcheck.py --unit mp-engine-ded` over common, files_pc, files_common, win_main, win_net, win_shared, vm, vm_interpreted, sv_main, sv_init, sv_ccmds, cm_load, cm_shader, z_memman_pc, and cvar gave 831 holes, 0 cascade errors, 0 defects, and 5 compile holes over 3 passes, exit 0. The compile holes are 4 in files_pc and 1 in cvar.

The `portMissing` total over `Sources/JKAMP_DedLogic` is 798, from 435 on master. The 15 E5 stems add 374, and the other stems went down from 435 to 424. Per stem: common 12 to 10, files_pc 34 to 20, files_common 1 to 0, win_main 9 to 5, win_shared 3 to 2, vm 35 to 30, cm_load 26 to 30, cm_shader 10 to 9, sv_init 10 to 2, sv_ccmds 1 to 0, sv_main 1 to 0, and z_memman_pc 3 to 0. cm_load went up, because the drafted CM_BoundBrush, CM_LumpChecksum, CM_Checksum, and CM_ClipHandleToModel keep the drafter's holes, and each loader keeps its one marker.

`swift build -j 2 --product jampded` passed, and `.build/debug/jampded` with standard input from `/dev/null` printed the version line and stopped at `TODO: Port Cmd_AddCommand, source: oracle/codemp/qcommon/cmd_pc.cpp:19`, exit 133.
