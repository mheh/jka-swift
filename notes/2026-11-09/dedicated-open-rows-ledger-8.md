# The open rows of the dedicated host, the eighth ledger

This record holds the eighth batch of open rows of the dedicated host: rows G13, B1, C, S4, and S6 of `dedicated-open-rows-ledger-7.md`, and the rows of the six body rounds under `notes/2026-11-09/`: `dedicated-body-round-g2-api.md`, `dedicated-body-round-g2-bones.md`, `dedicated-body-round-tr.md`, `dedicated-body-round-sv.md`, `dedicated-body-round-files-core.md`, and `dedicated-body-round-cm.md`. The user ruled the rows by delegation on 2026-11-09, and row L1 by his own word. The landing is the branch `dedicated-rulings-batch-8`, off master at `7961ee4`, in the worktree `/tmp/jka-batch-8`, with the six round branches merged into it first.

The batch is a generator batch. It changes the tables and tools of `tools/oracle-closure`, the hand classes, the views, and the storage, so that the stubs of the Ghoul2, botlib, ICARUS, navigator, ROFF, and renderer stems get real signatures. It writes no body beyond what a class, a view, or a ruled row needs. An adopted stem takes the stub of the generator at each changed signature, matched by its `Source:` line, and a hand body keeps its text where the signature does not change.

The verdict "ratified, delegated, 2026-11-09" means the form follows the pattern cited beside it. Every Raven cite is under `oracle/codemp/`, and every Swift cite is under `Sources/` or `tools/oracle-closure/` of the worktree.

## The rows of the seventh ledger

### Row B1, the botlib edge

Question: the host has no form for `botlib_export_t`, `botlib_import_t`, and the PRT_ print types, and `botlib.h` is a header of the game parse.

Proof: `game/botlib.h:18` to `:44` declare the struct tags and the PRT_ macros, and `:93` to `:422` the records. `botlib/be_interface.cpp:41` and `:42` declare `be_botlib_export` and `botimport`, and `server/sv_bot.cpp:722` stores the export pointer. The stubs of `be_interface.swift` carried "No view for `botlib_export_s`".

Verdict: ratified, delegated, 2026-11-09. `CJKAMP_Ded/include/ded_types.h` holds a copy of botlib.h:18 to :28, :40 to :44, and :92 to :422 with Raven's text. HOST_ROOTS names `botlib_export_t`, `botlib_import_t`, `bot_input_t`, `bsp_trace_t`, and `bot_entitystate_t`, so `be_botlib_export` and `botimport` are records on EngineStorage and `botlib_export` is an optional view.

Pattern: row W1 of the seventh ledger, `worldSector_t` in `ded_types.h` and `tools/oracle-closure/rulings.py:279`.

Note: the other records of the botlib, `source_t`, `script_t`, `bot_movestate_t`, `libvar_t`, and about 40 more, are not in this row. They live in the botlib's own headers and .cpp files, and they keep their markers.

### Row G13, `downloadBlocks`

Question: `unsigned char *downloadBlocks[MAX_DOWNLOAD_WINDOW]` of `server/server.h:155` read as `Slots<OpaquePointer?>`.

Proof: SV_WriteDownloadToClient stores a Z_Malloc block of MAX_DOWNLOAD_BLKSIZE bytes in each slot at `server/sv_client.cpp:1158` and reads it at `:1243`.

Verdict: ratified as proposed, delegated, 2026-11-09. The FIELDS kind `bytes_table` (`rulings.py:554`) gives `[Slots<JKAShared.byte>?]`, each Slots bounded by the SLOT_BOUNDS row MAX_DOWNLOAD_BLKSIZE. `views.py:448` writes the getter and the setter. SV_DropClient frees each block as `Z_Free(OpaquePointer(cl.downloadBlocks[i]!.base))` at `JKAMP_DedLogic/sv_client.swift:732`.

Pattern: the FIELDS kind `bytes` per slot, `views.py:356`, and the free form `Z_Free(OpaquePointer(fs_headerLongs.base))` of `files_pc.swift:1729`.

### Row C, the C++ classes of ICARUS, the navigator, and ROFF

Question: the classes of `icarus/blockstream.h:38` to `:158`, `sequence.h:12`, `sequencer.h:68`, `taskmanager.h:33` to `:97`, `instance.h:12`, `server/NPCNav/navigator.h:50` to `:254`, and `qcommon/RoffSystem.h:35` have no Swift form.

Verdict: ratified as proposed, delegated, 2026-11-09. Each class is a `final class` with Raven's name, fields, and method signatures, one class per file named for the class, rule 21: `CBlockMember`, `CBlock`, `CBlockStream`, `CSequence`, `CSequencer`, `CTask`, `CTaskGroup`, `CTaskManager`, `ICARUS_Instance`, `CEdge`, `CNode`, `CNavigator`, `CPriorityQueue`, and `CROFFSystem`. A method body is the marker pair of rule 14, except a one-line inline accessor. Each name joins CXX_CLASSES (`rulings.py:1092`). The file-scope instances `navigator`, `theROFFSystem`, `gSequencers`, `gTaskManagers`, and `iICARUS` are HAND_VARS rows (`rulings.py:387`) and hand properties of `EngineWorld`, and the skeleton forwards a class instance (`skeleton.py:970`).

Pattern: `CGenericParser2` at `JKAMP_DedLogic/GenericParser2.swift:634`, `CStringEdPackage` at `stringed_ingame.swift:77`, and the forward of `TheStringPackage` at `stringed_ingame.swift:124` over `EngineWorld.swift:38`.

Changes in the form:
- The navigator's `CNode` keeps Raven's name, so the clip map view of `cNode_t` takes the name `CmNode` (`rulings.py:259`), the form of `CCMShader` and `CmShader` at `rulings.py:264`. Six references of `cm_load.swift`, `cm_test.swift`, and `cm_trace.swift` read `CmNode`.
- `navigator`, `theROFFSystem`, and `CMiniHeap_singleton` are `lazy` properties of `EngineWorld` under one rule 24 line each, because Raven's constructors run before main and read the cvars or allocate the heap.

Left open in the classes:
- `interface_export_t` of `icarus/interface.h:17`, the game's function table, has no Swift form. The fields `CSequencer.m_ie` and `ICARUS_Instance.m_interface` are placeholders, and four methods keep the signature marker. No precedent gives a struct of function pointers that one module fills a Swift form.
- `CBlockMember.m_data` of `blockstream.h:104` is `OpaquePointer?`, so SetData, GetMemberData, ReadMember, WriteData, and WriteDataPointer have no body form.
- `FILE *` of `CBlockStream.m_fileHandle` has no table row.
- `failedEdge_t failedEdges[MAX_FAILED_EDGES]` of `navigator.h:245` needs C storage.
- `NodeTotalGreater` of `navigator.cpp:2694`, the comparator class of CPriorityQueue, is not written.

### Row S4, the constants of `stringed_ingame.h`

Not taken. The form is in reach: the header joins the entry list of the host parse, the re-export gives the 17 macros of `qcommon/stringed_ingame.h:10` to `:35` as Swift constants, the form of `BASEGAME` at `JKAMP_Ded/Generated/files.swift:8`, and the file constants of `stringed_ingame.swift:8` to `:40` go. The change needs one more sequence run, and this batch made none after its second run. The file constants hold Raven's values and stay.

### Row S6, the defaults of SE_Load

Question: the stub of SE_Load had no defaults, though `qcommon/stringed_ingame.cpp:910` declares `SE_BOOL bLoadDebug = SE_TRUE, SE_BOOL bFailIsCritical = SE_TRUE`.

Proof: the parameter type `SE_BOOL` is a macro, so the extent of each parameter starts inside the expansion and gives no token, and `cxx_default` found no `=`.

Verdict: ratified, delegated, 2026-11-09. When a parameter gives no token, `cxx_default` takes the one reference the parse resolved under the parameter (`skeleton.py:1289`), so the stub reads `_ bLoadDebug: Bool = true, _ bFailIsCritical: Bool = true` at `stringed_ingame.swift:822`.

Pattern: the macro default of SE_LoadLanguage that `cxx_default` already reads, `skeleton.py` docstring of `cxx_default`.

## The Ghoul2 rows

### Row G2B1, the Ghoul2 classes and parameter types

Question: 53 functions of G2_bones, 22 of G2_misc, 39 of tr_ghoul2, and 88 of G2_API took a Ghoul2 C++ type with no table row.

Proof: `ghoul2/ghoul2_shared.h:38` to `:457` declare `surfaceInfo_t`, `boneInfo_t`, `boltInfo_t`, `CGhoul2Info`, `IGhoul2InfoArray`, and `CGhoul2Info_v`, and `:223` to `:226` the four vectors. `ghoul2/G2_gore.h:10` to `:131` and `renderer/tr_ghoul2.cpp:142` to `:206` declare the gore, ragdoll, and bone cache classes.

Verdict: ratified, delegated, 2026-11-09. The row C form: a `final class` per class, 21 hand types in 16 files. The vectors are TYPES rows, `[surfaceInfo_t]`, `[boneInfo_t]`, `[boltInfo_t]`, and `[(Int32, MdxaBone)]`, and a non-const reference to one is `inout` (`spelling.py:363`). `IGhoul2InfoArray` is the one class it hides, `Ghoul2InfoArray`, under one rule 24 line, by rule 17. A returned class reference is the class and a returned class pointer is optional (`spelling.py:638`), and a `T **` of a class is `inout T?` (`spelling.py:358`). `EG2_Collision` is the re-exported enum, an `Int32` alias. The two `CConstructBoneList` texts of `G2_surfaces.cpp:18` and `tr_ghoul2.cpp:142` are the same, so one class serves both.

Pattern: row C above, the parameter rule of CXX_CLASSES at `spelling.py:348`, the `void **` shape `inout OpaquePointer?` at `spelling.py:299`, and the TYPES pointer rule of `UINT4 *` in `README.md`.

Left open in the classes: a field that holds `mdxaBone_t` by value has no allocator in the logic target, so eleven fields of `boneInfo_t`, `boltInfo_t`, `CTransformBone`, and `CBoneCache` have no default, and their constructors are the marker pair. `CGhoul2Info_v::Array` and `Ghoul2InfoArray::Get` return a `vector &` that callers write, and the Swift method returns a copy. `mTransformedVertsArray` holds pointers cast to `int` at `G2_misc.cpp:417`, which a 64-bit build cannot hold.

### Rows G1, G2, G2B2, and G2B3, the Ghoul2 statics

Question: `g_G2AllocTrackInit` and `g_G2AllocTrack` of `ghoul2/G2_API.cpp:43` and `:44`, `singleton` of `:477`, the ragdoll statics of `ghoul2/G2_bones.cpp:1214` to `:1241`, and the gore maps of `ghoul2/G2_misc.cpp:35`, `:36`, and `:125` had no storage.

Verdict: ratified, delegated, 2026-11-09.
- `bool` statics: TYPES `Bool` rows, `g_G2AllocTrackInit` and `haveDesiredPelvisOffset`. Pattern: `g_nOverrideChecked` at `rulings.py:614`.
- Record tables: `ragBasepose`, `ragBaseposeInv`, and `ragBones` take storage on EngineStorage through the HOST_ROOTS row of `mdxaBone_t`, and `ragEffectors` through the copy of `SRagEffector` (`G2_bones.cpp:1165`) in `ded_types.h`, whose view is `RagEffector`. Pattern: `gWPArray` of row G11 and the `CmShader` name rule.
- Class tables and maps: HAND_VARS rows and `EngineWorld` properties, `g_G2AllocTrack: [CGhoul2Info_v?]`, `singleton: Ghoul2InfoArray?`, `ragBoneData` and `rag: [boneInfo_t?]`, `GoreRecords: [Int32: GoreTextureCoordinates]`, `GoreTagsTemp: [[Int32]: Int32]` under one rule 24 line for the pair key, and `GoreSets: [Int32: CGoreSet]`. Pattern: the `[CommandDefRow]` hand tables of `rulings.py:387` and the rule 17 `Dictionary`.

### Rows G3, G2B4, and G2B5, the model views

Question: `model_t` of `renderer/tr_local.h:1117`, the mdx records of `renderer/mdx_format.h`, and `mdxaBone_t` had no host view, so R_GetModelByHandle and the bone math had no signature.

Verdict: ratified, delegated, 2026-11-09. `codemp/renderer/tr_local.h` joins the entry list of the host parse (`project.toml`, unit mp-engine-ded), and HOST_ROOTS names `model_t`, the mdxm and mdxa headers, surfaces, hierarchy, LOD, vertex, skeleton records, the md3 records, and `mdxaBone_t` with the game's view `MdxaBone`. `worldMatrix` and `worldMatrixInv` of `tr_ghoul2.cpp:136` and `:137` are storage records, and a `mdxaBone_t *` parameter is the view.

Pattern: the entry list headers of row T2 and the HOST_ROOTS rows of `rulings.py:199`, and `qtime_t` with the view of `CJKAMP` at `rulings.py:239`.

### Row G4, the collision records

Proof: QsortDistance of `ghoul2/G2_API.cpp:1993` reads `((CollisionRecord_t*)a)->mDistance`, and the two collision functions index `collRecMap[i]` at `:2115` and `:2167` and sort it at `:2118` and `:2170`.

Verdict: ratified, delegated, 2026-11-09. `CollisionRecord_t` takes a host view (`rulings.py`, HOST_ROOTS), `a` and `b` of QsortDistance take the PARAMS kind `("view", "CollisionRecord_t")`, and `collRecMap` of G2API_CollisionDetect, G2API_CollisionDetectCache, and G2_TraceModels takes the PARAMS kind `table`. Pattern: the cgame's own view of CollisionRecord_t at `rulings.py:180`, row V8 of the seventh ledger, and `GetIDForString` of PARAMS `table`.

### Row G2B6, the buffer of G2_FreeSaveBuffer

Verdict: ratified as the round wrote it, delegated, 2026-11-09. G2API_FreeSaveBuffer frees nothing under one rule 24 line, because the `inout CharBuf` owns its bytes. Pattern: the CharBuf overload of FS_FreeFile at `files_pc.swift:1489`. The `OpaquePointer?` of the round's proposal waits for G2_SaveGhoul2Models, whose `char **buffer` keeps its marker.

### Rows G2B7 and G2B8

Verdict: ratified, delegated, 2026-11-09.
- G2B7: DEAD names bInShadowRange, because R_AddGhoulSurfaces of `renderer/tr_ghoul2.cpp:3383` is the one caller, under `#ifndef DEDICATED` at `:3384`.
- G2B8: the timers are not dead. `game/q_shared.h:46` defines G2_PERFORMANCE_ANALYSIS, and Com_Frame starts and ends `G2PerformanceTimer_PreciseFrame` at `qcommon/common.cpp:1598` and `:1768`. `timing_c` of `qcommon/timing.h:2` is a row C class in `timing_c.swift`, with the `rdtsc` reads as marker pairs, and the nine timers are HAND_VARS rows.

Pattern: DEAD at `rulings.py`, the `CM_DrawDebugSurface` row, and row C above.

## The tr rows

### Row TR1, the renderer records

Verdict: ratified, delegated, 2026-11-09. The entry list change of row G3 gives the host target the records of `tr_local.h`. Five records hold C++ `bool` fields or a `class` pointer, so C_STRUCT_CLASSES copies their fields as C (`rulings.py:1080`): `image_t`, `textureBundle_t`, `shaderStage_t`, `shader_t`, and `srfTerrain_t`, with `CTRLandScape` as a tag. `trGlobals_t` then copies as C. HOST_ROOTS names `trGlobals_t`, `backEndState_t`, `backEndData_t`, `shader_t`, `shaderStage_t`, `texModInfo_t`, `waveForm_t`, `skin_t`, `skinSurface_t`, `image_t`, `trRefEntity_t`, and the md3 records. `modelHash_t` of `renderer/tr_model.cpp:27` is a copy in `ded_types.h`. `tr`, `backEnd`, `shader`, and `stages` are records on EngineStorage, and `hashTable` and `mhHashTable` are Slots of optional views.

Pattern: `traceWork_t` of row S7 at `rulings.py:1078`, row W1, and `gWPArray`.

Tool fixes: the field copy of `extract.py:915` writes a declaration of two names, `USHORT width, height`, once, and an anonymous record keeps no tag (`extract.py:935`). `views.py:962` puts a field named with a Swift keyword, `func` of `waveForm_t` at `tr_local.h:288`, in backticks. A `const byte *` field stores an `UnsafePointer`, `vis` of `world_t` at `tr_local.h:1084`.

### Row TR2, `CachedModels`

Verdict: ratified, delegated, 2026-11-09. `CachedEndianedModelBinary_t` of `renderer/tr_model.cpp:48` is a row C class, and `CachedModels` of `:68` is the HAND_VARS row `[String: CachedEndianedModelBinary_t]?`. Pattern: the rule 17 `Dictionary` and the HAND_VARS hand tables.

### Row TR3, the `bool` globals

Verdict: ratified, delegated, 2026-11-09. TYPES `Bool` rows for `gServerSkinHack`, `tr_stencilled`, `g_bRenderGlowingObjects`, `g_bDynamicGlowSupported`, and `HackadelicOnClient`. Pattern: `g_nOverrideChecked` at `rulings.py:614`.

### Row TR4, `r_vidModes`

Verdict: ratified, delegated, 2026-11-09. `vidmode_t` of `renderer/tr_init.cpp:459` is a copy in `ded_types.h` and a HOST_ROOTS row, `tables.py` copies Raven's 13 rows of `:467` to `:480` into `ded_tables.c`, `ded_tables.h` declares the table with its bound, and `JKAMP_Ded/DedTables.swift` reads it as `Slots<Vidmode>`. Pattern: `PADDING` of md4.cpp in the same three files.

### Row TR5, the resample records

Verdict: ratified, delegated, 2026-11-09. `contrib_t` and `contrib_list_t` of `renderer/tr_image.cpp:2338` and `:2344` are copies in `ded_types.h` and HOST_ROOTS rows. Pattern: row W1.

### Row TR6 and row P3, the static locals

Verdict: ratified, delegated, 2026-11-09. `static char sPrevMapName[MAX_QPATH]` of `renderer/tr_model.cpp:560` is a `CharBuf` property of `EngineWorld` with a forward in `tr_model.swift`. `static cvar_t *cv` of `qcommon/cm_patch.cpp:1256` and `:1401` are two `Cvar?` properties, `cv_CM_TracePointThroughPatchCollide` and `cv_CM_TraceThroughPatchCollide`, with forwards in `cm_patch.swift`. Pattern: "A file-scope static or a static local" of `docs/transcription.md:469` and `string_MSG_ReadString` at `msg.swift:390`. The bodies that read them are body work.

### Row TR7, `shaderTextHashTable`

Verdict: ratified as proposed, delegated, 2026-11-09. The HAND_VARS row `[[TextCursor]]` and an `EngineWorld` property of MAX_SHADERTEXT_HASH lists. Pattern: the HAND_VARS hand tables.

### Row TR8, the lightmap index lists

Proof: R_CreateExtendedName indexes `lightmapIndex` at `renderer/tr_shader.cpp:207` and compares it with the four tables at `:187` to `:199`, and no body writes through it.

Verdict: ratified, delegated, 2026-11-09. The PARAMS kind `int_array`, `[Int32]?`, for `lightmapIndex` of R_CreateExtendedName, IsShader, R_FindShader, R_FindServerShader, RE_RegisterShaderFromImage, and RE_RegisterShaderLightMap. The four tables stay `[Int32]`, the sixth ledger's form of `lightmapsNone`, so a caller hands the table as it is. The address compare becomes a compare of the values for the body round. Pattern: `VM_CallInterpreted` `args` of PARAMS `int_array`.

### Rows TR9 and TR10

Verdict: ratified, delegated, 2026-11-09.
- TR9: DEAD names LoadTGA and GetRefAPI. Their callers stand under `#ifndef DEDICATED` at `renderer/tr_image.cpp:2252` and `:2295`, and in `client/cl_main.cpp:2483`.
- TR10: the re-export of the host takes the macros of `tr_local.h` with row TR1, and the four held values go back to Raven's names: `MAX_POLYS` and `MAX_POLYVERTS` in `tr_init.swift`, `LIGHTMAP_BY_VERTEX` and `LIGHTMAP_WHITEIMAGE` in `tr_shader.swift`, and `LIGHTMAP_NONE` and `LIGHTMAP_2D` in `EngineWorld.swift`. The six rule 24 lines go.

### Row S1 of the sv-core round, `CMiniHeap`

Verdict: ratified, delegated, 2026-11-09. `CMiniHeap` of `qcommon/MiniHeap.h:5` is a row C class, and `G2VertSpaceServer` and `CMiniHeap_singleton` of `renderer/tr_init.cpp:29` and `:30` are HAND_VARS rows on `EngineWorld`.

## The sv rows

### Row SV1, the `const float *` fields

Proof: in `server/sv_world.cpp`, Raven stores the caller's vectors at `:424`, `:425`, `:839`, and `:840`, reads them at `:385` to `:411`, `:610`, `:698` to `:701`, and `:850` to `:854`, and never writes through them, compares the pointers, or tests them against NULL. SV_Trace replaces a NULL parameter by `vec3_origin` before the store.

Verdict: ratified as proposed, delegated, 2026-11-09. The copies of `areaParms_t` and `moveclip_t` in `ded_types.h` hold `vec3_t mins, maxs` by value under one rule 24 line, the view gives `vec3_t` properties, and the four holes of `sv_world.swift` are the stores. Pattern: PARAMS `vec3_const` at `rulings.py:656` and row W1.

### Rows SV2, SV4, and SV3

- SV2, verdict ratified, delegated, 2026-11-09: the BYTE_STORAGE_LOCALS key `("touchlist", "SV_ClipMoveToEntities")` (`rulings.py:483`) for `server/sv_world.cpp:523`. Pattern: `touch_SV_PointContents` of row G6.
- SV4, verdict ratified, delegated, 2026-11-09: PARAMS `vec3_mut` for `value` of Q3_GetVectorVariable, which sscanf writes at `icarus/Q3_Registers.cpp:179`. Pattern: `Sys_SnapVector` `v`.
- SV3, open. GNavCallback_NAV_ClearPathToPoint and its two siblings hand the address of a `vec3_t` to the module through VM_Call at `server/NPCNav/gameCallbacks.cpp:8`, `:13`, and `:18`. The host has no form that gives the module the address of a Swift vector for the life of the call. The trap thunks hand a vector in the other direction.

### Row V2, the system call thunk

Open. VM_Create takes `VmSystemCall?`, a C function over the words, at `server/sv_game.cpp:1750`, and the shell does not set `jka_systemCall` of `CJKAHost/jka_host.c:7`. The proposed thunk over `Slots(syscallWords:)` with a closure the shell installs follows `LoadLibrary` at `JKAMP_Ded/VmEntry.swift:48`, but it needs shell code and a second word width for the dll arm, which is more than a table row. It goes to the vm round.

## The files-core rows

- FC1, ratified, delegated, 2026-11-09: INDEXED_FIELDS (`rulings.py:1218`) names `("pack_t", "buildBuffer")`, so `views.py:601` writes `Pack.buildBufferSlots`, and the hand accessor of `FileBackend.swift` goes. Raven indexes a local copy at `qcommon/files_pc.cpp:1635`. Pattern: NULLABLE, a name rule for a fact the sweep cannot see.
- FC2, ratified as the round wrote it, delegated, 2026-11-09: the callers that pass NULL for `szFileName` and `szComment` at `qcommon/unzip.cpp:746`, `:775`, `:812`, `:855` and `files_pc.cpp:1452`, `:1493` pass a scratch CharBuf of size 0. Pattern: a scratch record for a NULL record, `AreaParms.scratch`.
- FC3, partly ratified, delegated, 2026-11-09: VM_ArgPtr and BotVMShift take the RETURNS kind `optional_raw`, `UnsafeMutableRawPointer?` (`rulings.py:712`, `table.py:2136`), for the NULL of `qcommon/vm.cpp:642` and `:661`. Pattern: the optional twin `optional_bytes`. The full-width read at `dataBase + word` is a hand piece with a body, so it goes to the vm round.
- FC4, ratified, delegated, 2026-11-09: RETURNS `raw` for ICARUS_Malloc of `icarus/Memory.cpp:8`. Pattern: S_Malloc of row Z3.
- F10, open: FS_ReorderPurePaks walks `searchpath_t **` from `&fs_searchpaths` at `qcommon/files_pc.cpp:2458`, and a file-scope view variable has no slot form. The body returns at once when `fs_numServerPaks` is 0, which the dedicated host never sets.

## The cm rows

- P1, ratified, delegated, 2026-11-09: PARAMS `vec3_const` for `a` and `b` of CM_ComparePoints, `qcommon/cm_patch.cpp:370`. Pattern: CM_FindPlane of row T9.
- P2, ratified, delegated, 2026-11-09: the new PARAMS kind `vec3_array` (`rulings.py:992`, `spelling.py:345`) gives `points` of CM_GeneratePatchCollide `[vec3_t]`, for the caller's `vec3_t points[MAX_PATCH_VERTS]` of `qcommon/cm_load.cpp:534`. Pattern: the trap form of a `vec3_t *` array, `vec3_array` of `spelling.py`, and row T3.
- S2, ratified, delegated, 2026-11-09: PARAMS `vec3_mut` for `v` of CM_ParseVector, whose one caller hands `fogColor` at `qcommon/cm_shader.cpp:435`. Pattern: BG_ValidateSkinForTeam `colors`.
- R2, ratified, delegated, 2026-11-09: the BYTE_STORAGE_LOCALS key `("leafs", "CM_PositionTest")` for `qcommon/cm_trace.cpp:449`. Two keys named `leafs` give the storage the stem prefix, `cm_trace_leafs_CM_PositionTest` and `sv_world_leafs_SV_LinkEntity`, the form of `common_logfile` of the seventh ledger.
- R3, ratified, delegated, 2026-11-09: a `vec3pair_t` field reads as `[vec3_t]` with a setter (`views.py:437`), `bounds` and `localBounds` of `traceWork_t` at `qcommon/cm_local.h:252` and `:253`. Pattern: row T3.
- P4, ratified, delegated, 2026-11-09: a two-index array of vectors is a row of vectors (`spelling.py`, the field role), so `CGrid.points` is `Slots<Slots<vec3_t>>`, and `pointsRows` and `PatchViews.swift` go. Pattern: the `matrix` rows of `MdxaBone`.
- P5, ratified, delegated, 2026-11-09: INDEXED_FIELDS names `("patchCollide_t", "facets")`, so the generated `PatchCollide.facetsSlots` replaces the hand piece. Pattern: FC1.
- R4, ratified, delegated, 2026-11-09: DEAD names CM_BoxBrushes and CM_StoreBrushes. `qcommon/cm_test.cpp:194` has no caller in either tree, and `:205` is the one store of CM_StoreBrushes.
- P6, open: the skeleton gives no entry for `edgeName_t` of `qcommon/cm_patch.cpp:971`, and the cause is not found. The hand lines stay.
- R1, open: Raven stores CM_StoreLeafs into `ll.storeLeafs` at `qcommon/cm_test.cpp:179` and `cm_trace.cpp:465`, and the generated Callbacks file declares the type with no thunk. The cause in the thunk sweep is not found.
- T7, open: `int gridPlanes[MAX_GRID_SIZE][MAX_GRID_SIZE][2]` of `qcommon/cm_patch.cpp:592`, `:615`, and `:675` has no PARAMS kind for a three-index array. The seventh ledger proposed a hand subscript, and the cm round chose a nested Array, so no one form exists yet.
- S1 and CM6, open: `CCMLandScape`, `CRMManager`, and `CRMObjective` of the terrain and the random mission manager are C++ classes, but no row of this batch names them, and the 14 terrain markers stay.

### Row L1, the leaf index blocks

Verdict: ratified as proposed, by the user, 2026-11-09. Keep Raven's memory and Raven's numbers, and put the unchecked step in the view layer, where rule 11 allows it.
- The store: the hand view of `clipMap_t` in `JKAMP_Ded/LumpViews.swift` has `leafbrushes(_:)` and `leafsurfaces(_:)`, which return the `Int32` distance from the table's base to a block. CMod_LoadSubmodels stores Raven's numbers at `qcommon/cm_load.cpp:153` to `:154` and `:160` to `:161`.
- The read: `leafbrush(at:)` and `leafsurface(at:)` read the `Int32` at `base + index` with no bound, as C does. Ten reader sites of `cm_test.swift`, `cm_trace.swift`, and `cm_load.swift` call them.
- Each changed site carries one rule 24 line.

### The hand helpers of the cm round

Each helper was checked against the no-litter rule.
- `OpaquePointer.byteCount` of `JKAShared/Views/ByteCount.swift`: kept. Its counterpart is `sizeof( cm.surfaces[0] )` of `cm_load.cpp:498`, the sibling of the `byteCount` of each view.
- The C integer subscript of `vec4_t` in `Int32Indexing.swift`: kept, the sibling of the `vec3_t` subscript.
- `Square` and `VectorAdvance` of `q_shared.h.swift`: kept, Raven's macros of `game/q_shared.h:3005` and `:1370`.
- The `Slots` lump initializer of `LumpViews.swift`: kept, the cast of `cm_load.cpp:81`.
- The `cmShaderTable` slot index: kept, the offset form of row C5.
- The `MapVert` read of the vertex lump: replaced. Raven reads `drawVert_t` at `cm_load.cpp:500`, and HOST_ROOTS now names `drawVert_t` with the view `DrawVert` of `CJKAMP`, the `qtime_t` form, so the read takes `DrawVert` and the rule 24 line goes.
- The CM_ClipHandleToModel local: kept, the scratch form of FC2.

## The gate

Two sequence runs. The first stopped at `check.sh`, because the field copy of an anonymous record wrote `typedef struct None`, and it ran again from the host extract after the fix. The second ran whole after every fix of step 3, every step exit 0. The fixes after the second run are hand code and one tool test, and they change no generated text.

| Check | Result |
|---|---|
| sequence, run 2 | every step exit 0 |
| `swift build -j 2` | exit 0, 0 errors |
| game snapshot | exit 0, 372 files, no difference |
| cgame snapshot | exit 0, 246 files, no difference |
| host snapshot | exit 1, 447 files: 75 new, 119 differ, 1 gone (`CNode.swift`, now `CmNode.swift`), the batch's own views and signatures |
| `swift test --no-parallel -j 2` | exit 0, 150 tests in 9 runs, 0 failures |
| tool tests | exit 0, 97 tests, 14 skipped |

Before the last build, the first test run trapped in the constructor of CNavigator at world creation, and the lazy properties of row C fixed it. The first tool test run failed on the host entry list, and `tests/test_project.py` now names `tr_local.h`.

## The portMissing count

`portMissing` over `Sources/JKAMP_DedLogic`: 1624 lines.
- Signature markers: 377, from 600 before the batch.
- Body stubs: 1247, of which 318 are the method stubs of the 31 new class files.

## The open rows

- SV3: no host form for the address of a vector argument of VM_Call.
- V2: the system call thunk needs shell code, the vm round.
- F10: no slot form for the address of a file-scope view variable.
- T7: no PARAMS kind for a three-index array.
- P6: the skeleton gap for `edgeName_t` is not found.
- R1: the missing `storeLeafs` thunk is not found.
- S4: in reach, a header of the entry list and one more sequence run.
- S1 and CM6: the terrain and random mission classes.
- `interface_export_t`, the ICARUS game table.
- The botlib's internal records beyond row B1.
