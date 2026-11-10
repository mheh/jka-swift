# The run-path round of the third body wave

This record holds the round `path` of the third body wave on the branch `ded-wave3-path`. The round drives `jampded` along its real run path, `+set dedicated 1 +map mp/ffa1` in `~/Developer/jka/jka_server`, with `fs_homepath` under `/tmp`. It fills the stubs and holes that the run reaches, and it reports each stop that needs a form with no pattern.

## The stop point

On the committed tree, the run stops in SV_Init at `TODO: Port SV_BotInitBotLib, source: oracle/codemp/server/sv_bot.cpp:684`, at the store `botlib_import.FS_FOpenFile = FS_FOpenFileByMode` (`Sources/JKAMP_DedLogic/sv_bot.swift:767`), row W3P1.
Before the round, the run stopped in Com_Init at `TODO: Port SE_LoadLanguage, source: oracle/codemp/qcommon/stringed_ingame.cpp:1216`.

A probe tree, never committed, skipped the stops one at a time to find the stops after this one. The probe skipped the five W3P1 stores, gave Hunk_Alloc one contiguous arena for row L1, and skipped ICARUS_Init and its two asserts. With these probes, the run passed SV_SpawnServer, CM_LoadMap, SV_InitGameProgs, VM_Create with the dll arm, and GAME_INIT into G_InitGame. It stopped in SP_worldspawn at `trap_G2API_InitGhoul2Model`, row W3P4. No run reached a server frame.

## The functions the run passed

On the committed tree: WinMain, Com_Init, Com_StartupVariable, Cvar_Init, Cmd_Init, FS_InitFilesystem, FS_Startup with the four pk3 files, FS_SetRestrictions, the exec of `mpdefault.cfg`, SE_Init, SE_LoadLanguage, SE_BuildFileList, SE_Load of every `strings/english/*.str` file, Sys_Init, NET_Init, SV_Init, SV_AddOperatorCommands, SV_BotInitCvars, and SV_BotInitBotLib to its first file store.

On the probe tree, after SV_BotInitBotLib: GetBotLibAPI and the three Init_*_Export functions, the rest of SV_Init, `--- Common Initialization Complete ---`, Winsock and the IP socket on port 29070, Com_Frame, Cbuf_Execute, SV_Map_f, SV_SpawnServer, FS_Restart, CM_LoadMap with CMod_LoadShaders, CMod_LoadSubmodels, CMod_LoadPatches, CM_GeneratePatchCollide, and CM_LoadShaderFiles, SV_InitGameProgs, VM_Create, Sys_UnpackDLL, Sys_LoadDll of `jampgamearm64.dylib`, VM_Call of GAME_INIT, and G_InitGame to `------- Game Initialization -------`, the InitGame line, trap_G2API_CleanEntAttachments, trap_ICARUS_Init, and G_SpawnEntitiesFromString into SP_worldspawn.

The probe tree loads the game module with the arguments of `tools/host-referee.sh`: `+set fs_game swift +set sv_pure 0 +set vm_game 0 +set bot_enable 0`, and `+set fs_cdpath /tmp/w3-out/path/home`. Raven's Sys_LoadDll tries the bare name, then `fs_basepath`, then `fs_cdpath`, each with `fs_game`, so a module outside the data directory needs `fs_cdpath`. The copy is `.build/debug/libjampgame.dylib` as `/tmp/w3-out/path/home/swift/jampgamearm64.dylib`.

## Bodies and holes filled, per file

- `stringed_ingame.swift`: SE_LoadLanguage, 1 hole to 0. Row S6 is gone, because SE_Load has its defaults now.
- `common.swift`: the two G2PerformanceTimer_PreciseFrame lines of Com_Frame, 2 holes to 0. Row G1 is gone, because the timer has storage now.
- `sv_init.swift`: `G2VertSpaceServer = CMiniHeap_singleton` of SV_Init, 1 hole to 0. Row S1 is gone.
- `sv_world.swift`: the `touchlist` of SV_ClipMoveToEntities reads `touchlist_SV_ClipMoveToEntities`, 2 holes to 1. Row SV2 is gone. The three locals that the closures capture start at zero, with one comment. The Ghoul2 trace hole stays.
- `cm_load.swift`: the CM_GeneratePatchCollide call of CMod_LoadPatches, 4 holes to 3.
- `cm_shader.swift`: the fogParms call of CM_ParseShader, 2 holes to 1. CM_ParseVector lost its shadow copy of `v`, which dropped the write to the `inout` parameter. CM_LoadShaderFiles starts each `buffers` entry as an empty CharBuf, so FS_ReadFile reads the file and does not return the length alone.
- `cm_patch.swift`: CM_GridPlane, CM_EdgePlaneNum, and CM_SetBorderInward, and the static `cv` of CM_TracePointThroughPatchCollide and CM_TraceThroughPatchCollide, 9 holes to 2. Rows T7 and the `cv` rows are gone. Two AI lines mark the vector copies where Raven points into the grid.
- `be_interface.swift`: adopted. Init_AAS_Export, Init_EA_Export, Init_AI_Export, and GetBotLibAPI, 75 holes to 72. The 138 stores take the generated thunks. `BOTLIB_API_VERSION` is a `let` with its `Source:` line, the form of `MAX_FILENAME_LENGTH` of `CBlockStream.swift`, because `ded_types.h` copies `botlib.h` from :18. The mismatch arm of GetBotLibAPI keeps a hole, because `botimport.Print` has no variadic tail.
- `sv_bot.swift`: SV_BotInitBotLib with its scratch import table, the debug polygons of row B3, 18 stores, and the GetBotLibAPI call. Five stores stay holes, row W3P1. The `BotlibImportThunks` enum is the one of the generator skeleton of `sv_bot.cpp`, copied as the adopted-stem rule copies a changed stub. Its three thunks that return a `char *` or a `void *` do not compile, so they take the generator's form for an unmapped signature, row W3P2.
- `sv_game.swift`: the arms G_R_REGISTERSKIN, G_G2_CLEARATTACHEDINSTANCE, and G_G2_CLEANENTATTACHMENTS. The other 45 Ghoul2 arms stay one hole, row W3P4, and row Z6 is gone, because the G2API stubs have signatures now.
- `win_main.swift`: Sys_UnpackDLL starts `data` as an empty CharBuf, the form of `productId` of FS_SetRestrictions, so FS_ReadFile reads the module.
- `Sources/JKAZlib/SystemInflate.swift`: the system stream takes a raw block of `MemoryLayout<z_stream>.size` bytes. The runtime keeps one type record per C struct name, and Raven's `struct z_stream_s` of `zlib32/zip.h:129` is 80 bytes against 112 of the system. So `UnsafeMutablePointer<z_stream>.allocate(capacity: 1)` took 80 bytes, and every inflateInit2_ wrote 32 bytes past the block. Guard Malloc stopped at the write, and the corruption broke the debug run in SE_Load.

## Rows

1. W3P1, the file functions of the botlib import table. Raven stores FS_FOpenFileByMode, FS_Read2, FS_Write, FS_FCloseFile, and FS_Seek into `botlib_import` at `server/sv_bot.cpp:702` to `:706`. The generator skeleton of `sv_bot.cpp` (`~/.cache/jka-swift/snapshot-mp-engine-ded/skeleton/sv_bot.swift:451`) holds thunks for the other 18 stores and none for these five. be_aas_file.cpp reads all five at `botlib/be_aas_file.cpp:286` to `:492`. Candidate forms: a generator thunk for a store of a function of another stem, as BotlibExportThunks holds the PC_ functions of `l_precomp.cpp`, or a thunk file in the view target in the form of `PmoveThunks.swift`. This row is the stop point of the committed tree.
2. W3P2, three generated thunks that do not compile. BotImport_BSPEntityData returns `String`, and BotImport_GetMemory and BotImport_HunkAlloc return `UnsafeMutableRawPointer`, against the `OpaquePointer?` of `BotlibImportBSPEntityData`, `BotlibImportGetMemory`, and `BotlibImportHunkAlloc` (`JKAMP_Ded/Generated/Views/Callbacks.swift:234`, `:264`, `:266`). Candidate forms: a RETURNS kind for a thunk that hands a `char *` from the string pool, and a thunk in the view target for a raw block.
3. L1 fails at run time. CMod_LoadSubmodels traps in `ClipMap.leafsurfaces(_:)` (`JKAMP_Ded/LumpViews.swift:85`) with "Not enough bits to represent a signed value". Hunk_Alloc is Z_Malloc (`qcommon/z_memman_pc.cpp:791`), so the table and the submodel block are two malloc blocks, and on arm64 macOS two blocks can lie more than 8 GB apart, past an `Int32` count of words. The run with `MallocNanoZone=0` traps the same way. Raven's 32-bit build never meets this. Candidate forms: a rule 19 note with one contiguous hunk arena in Hunk_Alloc, the form of the Q3 hunk that OpenJK keeps, or a word index into a host-side table. The probe used the arena and the map loaded.
4. ICARUS_Init has no form. Raven calls Interface_Init with `&interface_export` and ICARUS_Instance::Create at `icarus/GameInterface.cpp:146` to `:149`. Interface_Init is a stub with no signature (`Q3_Interface.swift:795`), and `interface_export_t` has no Swift form (`CSequencer.swift:382`). G_InitGame calls trap_ICARUS_Init at `g_main.swift:854`, and ICARUS_FreeEnt asserts `iICARUS` at `GameInterface.swift:167`. This row belongs to the ICARUS stem.
5. W3P4, the Ghoul2 handle across the game ABI. Raven reads `args[1]` as a `CGhoul2Info_v *` and `VMA(1)` as a `CGhoul2Info_v **` in 45 arms of `server/sv_game.cpp:1316` to `:1617`. The port's CGhoul2Info_v is a final class (`CGhoul2Info_v.swift:9`) whose deinit frees its item, so a word from the module has no form that gives the class back. SP_worldspawn reaches the first arm through trap_G2API_InitGhoul2Model (`g_spawn.swift:577`). Candidate forms: a C block of Raven's 4-byte `CGhoul2Info_v` that holds `mItem`, with a host table from the block to the class, or a table index in the word. This row is the stop point of the probe tree.
6. Two copies of JKAShared. The dyld log prints "Class _TtC9JKAShared13SharedChannel is implemented in both" `jampded` and `jampgamearm64.dylib`, and the same for StringPool. Each image links its own JKAShared, so each holds its own `sharedChannel` and `StringPool.shared`. The run went on, but the runtime warns of casting failures. No row of the notes names it.
7. A bot run. With the default `bot_enable 1`, G_InitGame calls trap_BotLibSetup (`game/g_main.c:1068`), whose arm is the hole of row B1 at `sv_game.swift:1044`. The probe ran with `bot_enable 0` as the referee script does.

## The checks

- `swift build -j 2`: passes.
- `swift test --no-parallel -j 2`: 150 tests in 9 runs, all pass.
- The run of the committed tree stops at the hole of row W3P1, as above.
