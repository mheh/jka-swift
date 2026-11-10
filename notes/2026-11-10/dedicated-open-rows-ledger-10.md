# The open rows of the dedicated host, the tenth ledger

This record holds the tenth batch of open rows of the dedicated host: the docket `notes/2026-11-10/docket-10.md` of the main tree, rows X1 to X49 with X1a and X1b, and row Z6. The docket gathers the rows of the body rounds of the third wave: bot-ai, g2tr, cmsv, bot-lib, bot-aas, and path. The landing is the branch `dedicated-rulings-batch-10`, off master at `2b5bccc`, in the worktree `/tmp/jka-batch-10`.

The batch is a generator batch. It changes the tables and tools of `tools/oracle-closure`, the views, the storage, and the hand bodies, so that the run path of `jampded` reaches past the botlib setup, the submodel load, ICARUS_Init, and SP_worldspawn.

Each row names its authority. "Auto ruled by pattern" means the coordinator ruled the row by the pattern cited beside it, under the standing delegation of the dedicated track. "The user's typed word" means the user typed "ratified" for the row. "The user's delegation" means the user ruled the row with the words "ratified each as proposed unless it deviates too much". Every Raven cite is under `oracle/codemp/`, every OpenJK cite is under `openjk/codemp/`, and every Swift or tool cite is in the worktree.

## The rulings of 2026-11-10

By the user's typed word "ratified":

- X46: the OpenJK width. `firstLeafBrush` and `firstLeafSurface` of `cLeaf_t` take `ptrdiff_t`, as `openjk/codemp/qcommon/cm_local.h:48` and `:51` do.
- Z6: the world table `[CGhoul2Info_v?]`, and the module word is the slot plus 1.
- X39 P17b: candidate B. Each site keeps its explicit conversion under a "C converts" comment, and no new operator goes into `Promotion.swift`.
- X13: candidate A. Private `push_heap` and `pop_heap` in `CPriorityQueue.swift` follow the Dinkumware steps of the MSVC library. The order is unverified against Raven's binary.

By the user's delegation: X1a, X1b, X7, X8, X38, and X43, each as the docket proposes.

By the user's typed word, after the pause:

- X23 as made for all three units. `CHAR_S` joins `NARROW` at `tools/oracle-closure/reexport.py:58`. The reach is the two `GNPC.swift` fields `last_forwardmove` and `last_rightmove`, the `cursor` parameter of `CG_Text_PaintWithCursor` at `Sources/JKAMP_CGameLogic/cg_main.swift:2798`, which a hand edit changed to `Int32` with `Int32(cursor)` in its thunk, and the drafts of 25 game stems and 9 cgame stems.
- The X46 mechanism. The ruled `ded_types.h` copy of `cLeaf_t` could not work, because `clipMap_t` includes `cLeaf_t` before that header. The user ratified the `WIDENED_FIELDS` table of `tools/oracle-closure/rulings.py:1603` to `:1605`, which `extract.py:971` reads, on the precedent of the `_Bool` override at `extract.py:968`. The cost: `cLeaf_t` and `cmodel_t` have no layout asserts in the dedicated unit. A new row in that table is a new ruling.

## The rows

Tier 0, the stops of the run path:

- X46, the leaf index distance on arm64: OpenJK `ptrdiff_t` width through `WIDENED_FIELDS`, the user's typed word, precedent `openjk/codemp/qcommon/cm_local.h:48` and `:51` and the `_Bool` override of `extract.py:968`. Landed. The `Int` sites stand under "C converts" lines.
- X47, ICARUS_Init, Interface_Init, and `interface_export_t`: PATTERN, auto ruled by pattern, the g2tr bodies and the CXX_CLASSES pointer rule of `docs/transcription.md:142`. No change in this batch.
- X48, two copies of `JKAShared`: PATTERN, no change, auto ruled by pattern, `notes/2026-11-03/cgame-listen-server-runs.md:37` and rule 6. No change.
- X49, the bot run: PATTERN, auto ruled by pattern, no row of its own, the stops are X1 and X2. No change.

Tier 1, every server start, map load, spawn, or frame:

- Z6, the module word of `CGhoul2Info_v`: candidate A, the user's typed word, precedent the botlib state tables of D13 (`BotMoveStateFromHandle`). Landed: `ghoul2Instances` at `Sources/JKAMP_DedLogic/EngineWorld.swift:609`. The G_G2_LISTBONES and G_G2_LISTSURFACES arms stay open.
- X1, the `botlib_import_t` surface: PATTERN, auto ruled by pattern, the private thunk of `docs/transcription.md:592`, the RETURNS `raw` of `Bot_GetMemoryGame` and `BotImport_HunkAlloc` by the `record.field` key, the PARAMS rows of `FS_Read` and `FS_Write`, and the readers of `Sources/JKAMP_CGame/ThunkReaders.swift:9` and `:15`. Landed: `BotlibImportThunks`, the five file thunks, the 21 stores, the W3P2 returns, and `Sources/JKAMP_Ded/ThunkReaders.swift`. The 32000-byte cut of BSPEntityData through `ringText` stays open.
- X1a, the variadic `Print`: candidate A, the user's delegation, precedent D18 of the ninth batch. Landed: `runPrint(_ type: Int32, _ fmt: String, _ args: any JKAShared.FormatArg...)` at `Sources/JKAMP_Ded/Generated/Views/BotlibImport.swift:71`, and the thunk prints the text through `"%s"`.
- X1b, the non-const `char *` of `BotClientCommand`: candidate A, the user's delegation, the trap rule of `docs/transcription.md:105`. Landed: the PARAMS kind `text` at `rulings.py:1472`.
- X2, the export thunks and the botlib arms of `SV_GameSystemCalls`: PATTERN, auto ruled by pattern, the `VMA -> OpaquePointer?` overload of `GameViews.swift` and the thunk readers of `CG_PlayCinematic` and `CG_OwnerDrawHandleKey`. Landed in part. Open: 17 export thunks with an `inout CharBuf` parameter, EA_Command among them, the thunks of BotChooseBestFightWeapon, BotChooseLTGItem, and BotChooseNBGItem, which have no count, and the AAS_FloatForBSPEpairKey and GeneticParentsAndChildSelection arms, which need PARAMS rows.
- X3, `BOTLIB_API_VERSION`: PATTERN, auto ruled by pattern, D10 of the ninth batch. Landed: `Sources/JKAMP_Ded/Generated/botlib.swift:8`, read at `sv_bot.swift:789`.
- X4, UnCompressBone and the matcomp unit: PATTERN, auto ruled by pattern, row G3 of ledger 8 and the mdx HOST_ROOTS rows. Landed: `mdxaCompQuatBone_t` at `rulings.py:457`, `renderer/matcomp.c` in the host list, and the body of MC_UnCompressQuat in the adopted `matcomp.swift`.
- X5, the static locals of G2_TransformBone: PATTERN, auto ruled by pattern, the static-local form of `docs/transcription.md:480`. Landed.
- X6, `mdxaIndex_t`: PATTERN, auto ruled by pattern, the mdx HOST_ROOTS rows and the G2A4 form of ledger 9. Landed: `rulings.py:458`.
- X7, `qsort` over a table of records: candidate A, the user's delegation, the twin of `bg_lib.swift:61`. Landed: `qsort<V: HandleView>` at `Sources/JKAMP_Ded/CommonViews.swift:163`.
- X8, a pointer stored in an `int`: candidate A, the user's delegation, the L1 form of ledger 8. Landed: the slot holds the offset in the `CMiniHeap` block, `Sources/JKAMP_DedLogic/G2_misc.swift:340`.
- X9, `CTraceSurface.collRecMap`: PATTERN, auto ruled by pattern, the PARAMS kind `table` and NULLABLE. Landed.
- X10, G2_ProcessSurfaceBolt2 and the mdx inline functions: PATTERN, auto ruled by pattern, the inline-function form of `docs/transcription.md:339`. Landed: `mdxmTriangle_t` at `rulings.py:459`.
- X11, the `SET_` names of `Q3_Interface.h`: PATTERN, auto ruled by pattern, rows 4 and 5 of ledger 9. Landed: `icarus/Q3_Interface.h` in the host entry list.
- X12, the ICARUS time stamp: PATTERN, auto ruled by pattern, `MSVC_WIDTH_FOLDERS` and the `UInt8` conformance of `Format.swift`. Landed in part: `UInt32` conforms at `Sources/JKAShared/Format.swift:37`. The two Wait holes of CTaskManager, `TaskManager.cpp:1111` and `:1122`, stay open.
- X13, `std::pop_heap` and `std::push_heap`: candidate A, the user's typed word, rule 1. Landed: `Sources/JKAMP_DedLogic/CPriorityQueue.swift:112` and `:131`, unverified against Raven's binary.
- X14, the Ghoul2 signatures: PATTERN, auto ruled by pattern, each part by its cite in the docket. Landed: G1b to G1f. G1a and G1g were already right.
- X15, the `ERagState` enum: PATTERN, no change, auto ruled by pattern, the `file_enums` rows. No change.
- X16, `_ =` before the `Q3_Registers` calls: PATTERN, auto ruled by pattern, `docs/transcription.md:789`. Landed.

Tier 2, the bot paths that the MP game does not call:

- X17, a record returned by value: PATTERN, auto ruled by pattern, RETURNS `record` and BYTE_STORAGE_LOCALS, the rows of `Com_GetRealEvent` and `Sys_GetEvent`. Landed.
- X18, AAS_BSPModelMinsMaxsOrigin outputs: PATTERN, auto ruled by pattern, PARAMS `vec3_mut`. Landed.
- X19, NULL into a view parameter: PATTERN, auto ruled by pattern, NULLABLE and PARAMS `table`. Landed.
- X20, more scalar kinds for BYTE_STORAGE_LOCALS: PATTERN, auto ruled by pattern, `INT_ELEMENTS` of `skeleton.py:72`. Landed. The Wait stub part stays open with X12.
- X21, the botlib list parameters: PATTERN, auto ruled by pattern, PARAMS, FIELDS, and RETURNS `bytes`. Landed: `rulings.py:1484`.
- X22, the union `cvalue`: PATTERN, auto ruled by pattern, `docs/transcription.md:393`. Landed: `rulings.py:464`.
- X23, a plain `char` scalar: PATTERN, auto ruled by pattern, the narrow rule of `docs/transcription.md:612`, and its reach by the user's typed word. Landed: `reexport.py:58`.
- X24, the text and offset returns of be_ai_chat: PATTERN, auto ruled by pattern. P15 RETURNS `text_offset` and P19 NULLABLE landed. P18 needs no change.
- X25, the botlib blocks of records and texts: PATTERN, auto ruled by pattern, `vm.swift:331` and N8 of ledger 9. Landed.
- X26, `crandom` in the host: PATTERN, auto ruled by pattern, `bg_lib.swift:195`. Landed: `Sources/JKAMP_DedLogic/common.swift:2078`.
- X27, the C library twins: PATTERN, auto ruled by pattern, `docs/transcription.md:746`. Landed: `"atol": "atoi"` at `rulings.py:1570` and the twins in `CString.swift`.
- X28, the C library time functions: PATTERN, auto ruled by pattern, `SysBackend.timeGetTime()`. Landed.
- X29, the definehash table parameters: PATTERN, auto ruled by pattern, PARAMS `pointer_table`. Landed: `rulings.py:1488`.
- X30, the evaluate functions of l_precomp: PATTERN, auto ruled by pattern, `docs/transcription.md:259`. Landed.
- X31, the parameter array of PC_ReadDefineParms: PATTERN, auto ruled by pattern, `docs/transcription.md:115`. Landed.
- X32, the one-`char` output of PS_ReadEscapeCharacter: PATTERN, auto ruled by pattern, the scalar outputs of D16. Landed.
- X33, COM_Compress over `script->buffer`: PATTERN, auto ruled by pattern, the `Com_Memcpy` overloads of `CString.swift`. Landed.
- X34, `fprintf` and `vfprintf` on a `FILE *`: PATTERN, auto ruled by pattern, `docs/transcription.md:758`. Landed, with WriteIndent DEAD at `rulings.py:1527`. The `%02d` of Log_WriteTimeStamped stays open.
- X35, the `fmt` of Log_Write: PATTERN, auto ruled by pattern, D18 of ledger 9. Landed: `vfprintf` and `fprintf` at `tools/oracle-closure/table.py:317`.
- X36, the remaining bot-aas rows A3, A6, A9, A11, A13: PATTERN, auto ruled by pattern, each by its cite in the docket. Landed. The scalar writes of AAS_WriteAASLump and AAS_ReadCache stay open.
- X37, the forms of the bot-aas round: PATTERN, auto ruled by pattern. Landed.
- X38, the format subset: candidate A for `%ld` and B for `%p`, the user's delegation. Landed: the `l` modifier at `Sources/JKAShared/Format.swift:124`, and `%p` as `%d` of 0 at `Sources/JKAMP_DedLogic/cm_patch.swift:1320`. `%lu` stays open.
- X39, the conversions between `unsigned long` and `int`: P17a PATTERN, auto ruled by pattern, the `srand` form of `docs/transcription.md:647`. P17b candidate B, the user's typed word. Landed.

Tier 3, the terrain, the random mission manager, and the clip map:

- X40, `CCMLandScape *` and `CCMPatch *` signatures: PATTERN, auto ruled by pattern, RETURNS `class_ref` and the CXX_CLASSES rule. Landed. CM_TerrainPatchIterate stays open.
- X41, the classes of the random mission manager: PATTERN, auto ruled by pattern, row C of ledger 8 and row W1. Landed in part: `rmAutomapSymbol_t` at `rulings.py:466`. CPathInfo, CRMInstance, and the other RMG classes have no form yet, and ProcessAutomapSymbols stays open.
- X42, the smaller terrain rows R2, R4, R5: PATTERN, auto ruled by pattern. Landed: `Round` at `Sources/JKAMP_DedLogic/common.swift:2083`.
- X43, `cmShaderTable` records outside `cmg.shaders`: candidate A, the user's delegation, rule 17. Landed: `[String: CmShader]` at `Sources/JKAMP_DedLogic/cm_shader.swift:21`.
- X44, zlib `deflate`: PATTERN, auto ruled by pattern, the `inflate` of `Sources/JKAZlib`. Landed: `Sources/JKAZlib/SystemDeflate.swift` and `Sources/JKAMP_Ded/ZipBackend.swift`.
- X45, the clip map findings: PATTERN, auto ruled by pattern. Landed: CM_Checksum DEAD at `rulings.py:1522`, BotDrawDebugPolygons DEAD at `rulings.py:1524`, `TERRAIN_STEP_MAGIC` as a `Float`, and the B4 keys. The old R4 needs no change.

The md3 row R6 of g2tr took HOST_ROOTS `md3Surface_t` at `rulings.py:460`, by the pattern of `rulings.py:312` to `:314`.

## The timing

Each line is one step, in seconds. A sequence run starts at the step where the run before it stopped. Run 1 stopped at the check. Run 2 stopped at views-ded. Run 4 stopped at skeleton-ded. Run 6 is the full sequence after the tool fixes. A lone skeleton-ded run of 4 s, logged as run 6, ran between build runs 6 and 7.

| Step | Run 1 | Run 2 | Run 3 | Run 4 | Run 5 | Run 6 |
| --- | --- | --- | --- | --- | --- | --- |
| extract, units run | 70, 9 units | 45, 5 units | | | | 67, 9 units |
| merge | 1 | 1 | 0 | | | 1 |
| tables | 0 | 0 | 0 | | | 0 |
| check | 5, exit 1 | 4 | 4 | | | 5 |
| reexport | | 55 | 55 | | | 107 |
| views-game | | 62 | 1 | | | 2 |
| views-cgame | | 42 | 1 | | | 1 |
| views-ded | | 2, exit 1 | 49 | | | 3 |
| skeleton-game | | | 24 | | | 24 |
| skeleton-cgame | | | 15 | | | 14 |
| skeleton-ded | | | 24 | 50, exit 1 | 25 | 24 |
| manifest-game | | | 23 | | 84 | 23 |
| manifest-cgame | | | 15 | | 57 | 15 |
| manifest-ded | | | 27 | | 24 | 25 |
| traps-game | | | 4 | | 4 | 3 |
| traps-cgame | | | 1 | | 1 | 2 |
| channel | | | 3 | | 3 | 3 |
| sum of steps | 76 | 211 | 246 | 50 | 198 | 319 |

The debug builds, in order: runs 1 to 5 after sequence run 3, 33, 11, 6, 15, and 6, each exit 1. Runs 6 to 10 after sequence run 5, 10, 16, 12, 16, and 16, each exit 1. Run 11, 39, exit 0. Run 12 after sequence run 6, 35, exit 0, the last full debug build. Run 13, 4, exit 0.

| Gate step | Seconds | Exit |
| --- | --- | --- |
| snapshot check mp-game | 123 | 1 |
| snapshot check mp-cgame | 51 | 1 |
| snapshot check mp-engine-ded | 72 | 1 |
| swift test | 40 | 0 |
| tool tests | 2 | 0 |
| release build | 116 | 0 |

## The gate

- The sequence, run 6: every step exits 0.
- `swift build`, debug and release: exit 0.
- `swift test --no-parallel -j 6`: 150 of 150 pass.
- The tool tests: 99 run, OK.
- `snapshot.py --check` of mp-game, mp-cgame, and mp-engine-ded: each differs before the refresh. Every game and cgame difference comes from X23: the GNPC view, the skeleton signature of `CG_Text_PaintWithCursor`, and the drafts of 25 game stems and 9 cgame stems. The host differences are the batch. The coordinator refreshes the three caches after this ledger.

## The result

`portMissing(` stands 265 times under `Sources/JKAMP_DedLogic`, against 770 on master `2b5bccc`.

`jampded` with the real game data spawns `mp/ffa1`, completes GAME_INIT to the `InitGame:` line, and runs server frames to the time limit. It does this with `bot_enable 0` in the debug and the release builds, and with `bot_enable 1` in the release build.

## The open rows

These rows have no existing form, or their form did not land in this batch.

- The two Wait holes of CTaskManager, `TaskManager.cpp:1111` and `:1122`: no storage form for `&dwtime` of a method, and no compare between `UInt32` and `Float`.
- The G_G2_LISTBONES and G_G2_LISTSURFACES arms of `sv_game.swift`.
- G2_GorePolys, dead in the dedicated build.
- 17 export thunks with an `inout CharBuf` parameter, EA_Command among them.
- The thunks of BotChooseBestFightWeapon, BotChooseLTGItem, and BotChooseNBGItem, which have no count.
- The AAS_FloatForBSPEpairKey and GeneticParentsAndChildSelection arms of `sv_game.swift`, which need PARAMS rows.
- The scalar writes of AAS_WriteAASLump and AAS_ReadCache.
- The `%02d` of Log_WriteTimeStamped, and `%lu`.
- CM_TerrainPatchIterate and ProcessAutomapSymbols.
- The RMG classes with no form, CPathInfo, CRMInstance, and others.
- The 32000-byte cut of BSPEntityData through `ringText`.

## The run observations

- After `InitGame:`, the server prints two `Hitch warning` lines on the first frames, the first of about 1884 million msec.
- A debug build spends minutes in `MSG_initHuffman` before the first frame.
