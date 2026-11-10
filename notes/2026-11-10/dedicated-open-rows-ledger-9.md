# The open rows of the dedicated host, the ninth ledger

This record holds the ninth batch of open rows of the dedicated host: the botlib docket `notes/2026-11-09/botlib-docket-9.md` (rows D1 to D20 and N1 to N8), the rows of the four body rounds `dedicated-body-round-icarus.md`, `dedicated-body-round-g2-api-2.md`, `dedicated-body-round-g2-bones-2.md`, and `dedicated-body-round-tr-2.md` under `notes/2026-11-09/`, the review findings of the cm, tr, G2 API, and G2 bones reviews, and the rows the user ratified on 2026-11-10. The landing is the branch `dedicated-rulings-batch-9`, off master at `d6f2dd7`, in the worktree `/tmp/jka-batch-9`, with the five bot body branches and `ded-bodies-icarus` merged into it first.

The batch is a generator batch. It changes the tables and tools of `tools/oracle-closure`, the hand classes, the views, and the storage, so that the stubs of the botlib, ICARUS, navigator, ROFF, Ghoul2, and renderer stems get real signatures. It also fills the bodies that a ruled row needs.

The verdict "ratified, delegated, 2026-11-09" means the form follows the pattern cited beside it, by the delegation of 2026-11-09. The verdict "ratified by the user as proposed, 2026-11-10" means the user ruled the row by his own word. Every Raven cite is under `oracle/codemp/`, and every Swift cite is under `Sources/` or `tools/oracle-closure/` of the worktree.

## The botlib rows

Rows D1 to D20 are ratified, delegated, 2026-11-09, as the docket states them, each by the pattern the docket names: D1 the copy of a .cpp record in `ded_types.h` with a HOST_ROOTS row (`cmd_t` and row W1), D2 the clip map storage record, D3 and D4 the D1 copy, D5 the D1 copy with the MSVC widths of `UINT4`, D6 the TYPES row N3, D8 the D1 copy with an optional view per `libvar_t *` global, D9 row B1 of the eighth ledger, D10 the macros that `ded_types.h` copies with their records, D11 the directive tables on EngineWorld and `default_punctuations` as C storage, D12 the allocator RETURNS rows, D13 the `Slots<View?>` of a file-scope array of record pointers, D14 and D15 the FIELDS kinds, D16 the PARAMS, NULLABLE, and BYTE_STORAGE_LOCALS rows, D17 the shared view row `pc_token_t`, D18 the varargs form of `Com_Printf`, D19 the field tables as C storage beside the hand headers, and D20 the FIELDS and RETURNS kind `opaque`.

- D18: `__builtin_va_start` joins TEXT_READERS in `table.py`, so the `char *fmt` of Log_Write is a String. The game and cgame snapshots show no difference from it.
- N1 (D7): the FIELDS kind `text_offset`. Ratified, delegated, 2026-11-09.
- N2 (D10): the three `CS_` constants of `be_aas_def.h:29` to `:31`. Ratified, delegated, 2026-11-09. The skeleton has no form for them, so `be_aas_main.swift` is adopted in this batch and holds three file-private constants with Raven's values and one AI line. Pattern: the file-private `let` of a .cpp constant, `GT_FFA` of `be_ai_goal.swift`.
- N3 to N7 (D6, D15): ratified, delegated, 2026-11-09, as the docket states them.
- N8 (D12 shapes 5, 10, and 11): ratified, delegated, 2026-11-09. Each site takes the batch-8 form of `files_pc.swift:1679` to `:1682`. A site that does not fit stays open with its proof in the bot body rounds.

### The botlib findings of the gate

- The host enums of a .cpp file, `GT_FFA` of `be_ai_goal.cpp:76`, read Raven's trailing comment as the initializer, so the stub did not compile. `extract.enumerator_values` now skips comment tokens. Pattern: the enum rows of `file_enums`, which carry no comment. The game and cgame snapshots show no difference.
- The field tables of D19 (`iteminfo_fields`, `weaponinfo_fields`, `projectileinfo_fields`) and `default_punctuations` of D11 took the hand-table branch of the skeleton, because `fielddef_t` and `punctuation_t` hold a record pointer. `tables.py` writes them as C storage. `Skeleton.fills_no_address` keeps a host table as storage when the record has no function pointer and Raven's initializer takes no address outside a text, a character literal, or a comment. Pattern: the storage rows of `tables.py`, the D11 and D19 rulings. The game and cgame snapshots show no difference.
- `logfile` of `l_log.cpp:33` is a static of the same name as the global of `common.cpp:33`. Both copies are private, the skeleton rule of a name that two files declare (`skeleton.py`, `Variable.access`), and `common.swift` takes the private word with one AI line.

## The ICARUS, vm, navigator, and ROFF rows

The rows of `dedicated-body-round-icarus.md`. Each is ratified, delegated, 2026-11-09, by the pattern the record names.

- Row 1, the `std::map` globals of GameInterface.cpp: HAND_VARS rows with hand properties of EngineWorld. Applied.
- Row 2, `BSTable`: the twin of `JKAMP_Game/GameTables.swift:18` in `DedTables.swift`, C storage of `tables.py`. Applied.
- Row 3, the register maps: HAND_VARS rows. Storage applied. The 16 bodies of `Q3_Registers.swift` are filled in this batch, and the file is adopted.
- Row 4 and row 5, the constants of `Q3_Registers.h`, `navigator.h`, `g_nav.h`, and `RoffSystem.h`: the four headers join the host entry list of `project.toml`, and the reexport writes them. The literal sites of `CNode.swift`, `CNavigator.swift`, and `CROFFSystem.swift` read the names now, 29 sites in all. `NODE_HEADER_ID` and `NAV_HEADER_ID` are four-character constants that the reexport does not give, so their two sites keep the literal and the AI line.
- Rows 6, 8, 9, 10, 11, 13: applied as the record proposes.
- Row 7, `long`: `icarus` and `NPCNav` join `MSVC_WIDTH_FOLDERS`, ROFF stays out because it lives in `qcommon`. Applied.
- Row 12: `@discardableResult` on the declarations. Applied.
- Rows 14 and 15: no change.
- Row 16, the shadow of `MASK_SOLID`: the shared-macro rule of `skeleton.collect_macros` for a host name that a module exports. Applied, and `be_aas_entity.swift:9` is private.
- SV_GameSystemCalls returns `Int`, with a `VMA -> Int` overload of the arguments view. The ROFF, ICARUS, and NPC nav arms are written from Raven's `sv_game.cpp:714` to `:935`. Raven's G_NAV_SETCHECKEDNODE and G_NAV_FLAGALLNODES arms have no return, so each falls through to the next arm with `fallthrough`. The G_ICARUS_GETVECTORVARIABLE arm is written too, because Q3_GetVectorVariable takes an `inout vec3_t` now.
- `ICARUS_Instance.GetSequencer` passes Raven's four arguments to `CSequencer.Init`, which has its signature now.

## The Ghoul2 rows

The rows of `dedicated-body-round-g2-api-2.md` and `dedicated-body-round-g2-bones-2.md`. Each is ratified, delegated, 2026-11-09, by the pattern the record names, except where a line says the user ruled it.

- G2A1: the `Array` get and set of `CGhoul2Info_v`, the subscript setter, `resize`, and `push_back`. Applied.
- G2A2, G2A3, G2A5, G2A6, G2A9: applied as the record proposes.
- G2A4, bones R1, and TR14: one form, `HandleView.init(_:byteOffset:)` in `LumpViews.swift`, with five SLOT_BOUNDS rows with no bound for the `[1]` arrays of `mdx_format.h`. Applied.
- G2A7 with G2_Generate_Matrix, G2A8 (`GHOUL2_CRAZY_SMOOTH`, the GHOUL2_RAG_STARTED form), the three marker functions: applied.
- G2A10, a row of a `float[3][4]` field as a vector: ratified by the user as proposed, 2026-11-10. `Slots<Float>.vector` in `Sources/JKAShared/Views/Slots.swift`, the twin of the generated `<name>Vector`, with one AI line. G2API_GetBoltMatrix and G2API_GetBoltMatrix_SPMethod are filled, and the sites read `VectorNormalize(&use.matrix[0].vector)`.
- R2, `tempDependents`: BYTE_STORAGE_VARS and the PARAMS kind `bytes`. G2_GetBoneDependents takes `Slots<Int32>` and its body is filled. The callers G2_RagDollSolve and G2_IKSolve are still whole holes.
- R3, the identity matrices: C storage of `tables.py` in `ded_tables.c` and `DedTables.swift`. Applied.
- R4, R6, R10: applied. R7: partly applied. R8: the BYTE_STORAGE_LOCALS row of `modelList`, with the forward `modelList_G2_ConstructGhoulSkeleton` in `tr_ghoul2.swift`. R9: DEAD rows.
- R5, `sizeof(CBoneCache)`: ratified by the user as proposed, 2026-11-10. `private let sizeofCBoneCache = 88 as Int32` in `tr_ghoul2.swift` with its member comment and one AI line. RemoveBoneCache and G2_TransformGhoulBones are filled.
- R11, the heap of CMiniHeap: `Slots<byte>.malloc(_:)` and `free()` in `ServerViews.swift`, the twin of `Slots.new(count:)` and `delete()`, each with one AI line. The constructor and the destructor of `CMiniHeap.swift` are filled from `MiniHeap.h:20` to `:37`.
- `int *` over bytes, ratified by the user as proposed, 2026-11-10. Site B, G2_TransformModel (`G2_misc.cpp:627`): `Slots<Int32>(scalars: heap.base, count: numSurfaces)` on the MiniHeapAlloc result, the form of `vm_interpreted.swift:81`, and the body is filled. Site A, the old model bone remap of R_LoadMDXM (`tr_ghoul2.cpp:5028`): `MdxmSurface.boneReferences` in `LumpViews.swift`, the L1 form, and the loop is filled.
- `CBoneCache.rootBoneList`: ratified by the user as proposed, 2026-11-10. A `weak var rootBoneListOwner: CGhoul2Info?` and `rootBoneList` a computed get and set over its `mBlist`, one AI line at the field and one at the store of G2_TransformGhoulBones.
- DeepCopy of `CGhoul2Info_v`: ratified by the user as proposed, 2026-11-10. `copy(_:)` on `CGhoul2Info`, `surfaceInfo_t`, `boltInfo_t`, and `boneInfo_t`, a memberwise assign in Raven's member order with one AI line each. DeepCopy, G2API_CopySpecificG2Model, and G2API_CopyGhoul2Instance are filled.
- The signed-index sweep: six sites. The four findings of the G2 API review (`G2_bolts.swift:62`, RagEffectorGoal NULLABLE `pos`, the `&+=` of `mRefCount`, the leak tracker guard): fixed.

## The renderer rows

The rows of `dedicated-body-round-tr-2.md`. Each is ratified, delegated, 2026-11-09, by the pattern the record names.

- TR11 (PARAMS kind `byte_array`), TR13 (PARAMS kind `bytes`), TR14 (with G2A4), TR15 (a `_Bool` field gets a `Bool` accessor), TR16 (`Slots(pointers:)`), TR17 (the product of the bounds), TR18 (RETURNS kind `int32`), TR20 (PARAMS kind `byte_offset`): applied.
- TR12, `modelHash_t.handle`: the FIELD_NAMES row `("modelHash_t", "handle"): "modelHandle"`, the form of `cvarHandle` and `packHandle`. The row was ruled and not yet in `rulings.py`, so the gate added it.
- TR15 made the hand accessors `startout` and `getout` of `TraceViews.swift` a second declaration, so the gate removed the hand pair.
- TR19, `infoParms`: kept as the hand `[InfoParm]` of `cm_shader.swift:31` in `tr_shader.swift`, not a C table.
- The bodies of R_LoadMDXA, R_LoadMDXM, ServerLoadMDXA, ServerLoadMDXM, FinishShader, RE_RegisterModel_Actual, RE_RegisterShaderFromImage, and R_LoadMD3. The StoreShaderRequest form `MdxmSurfHierarchy.shader(_:)` after `ClipMap.leafbrushes(_:)`. Rule 20 notes on the six parsers. R_LerpTag is DEAD.

## The rows the user ratified on 2026-11-10

Each row below is ratified by the user as proposed, 2026-11-10.

- The `std::map &` parameters of `Q3_Registers.cpp:267`, `:296`, `:343`, and `:376`: the TYPES rows `varString_m` and `varFloat_m` give `inout [String: String]` and `inout [String: Float]` through the C++ reference rule of `spelling.py`, the twin of `boneInfo_v &`. The four bodies are Raven's `return` with his commented block kept.
- VM_Call with arguments: no new form. `gameCallbacks.swift:27` keeps its `Int32(truncatingIfNeeded:)` and AI line as the one stated exception.
- `int *` over bytes, G2A10, R5, `rootBoneList`, DeepCopy: see the Ghoul2 rows.
- `timing_c`: as written, milliseconds through `SysBackend.timeGetTime()`.
- `docs/transcription.md:634`: `M_PI` leaves the double-literal sentence, and one sentence follows it: a macro constant with an `f` suffix, `M_PI` of `q_shared.h:548`, is a `Float`, and an expression with it stays in float unless another operand is a double.
- F10, `fs_searchpaths` of `files_pc.cpp:2458`: POINTER_SLOT_VARS of `rulings.py` makes the pointer a pointer table of one slot on EngineStorage, `EngineStorage.table(count: 1, of: Searchpath.self)`. The forward `fs_searchpaths` of `files_common.swift` reads and writes slot 0, and `fs_searchpathsSlot` gives the Slots, the name twin of `nextSlot`. FS_ReorderPurePaks is filled with Raven's lines.
- The three `let` globals of `tr_backend.swift:17`, `:21`, and `:25`: closed with no change, correct by the generator rule of `skeleton.py:218` to `:220`.

### The sites that widen `M_PI` to `Double`

The ruling of the doc line asked for this list. Nothing changed at these sites. 56 sites, 52 without the four `return Float(Foundation.M_PI)` lines of `common.swift`.

- Game, 5: `g_misc.swift:1088` (`g_misc.c:1159`), `w_force.swift:4135`, `:4174`, `:4226` (`w_force.c:4730`, `:4777`, `:4845`), `g_mover.swift:2161` (`g_mover.c:2298`).
- BG, 5, as `Double.pi`: `bg_misc.swift:536` (`bg_misc.c:1780`), `:1103` (`:2368`), `:1125` (`:2393`, DEG2RAD), `:1164` (`:2433`), `:1180` (`:2450`, DEG2RAD).
- Cgame, 27: `cg_view.swift:1065`, `:1067`, `:1192`, `:1194`, `:1199`, `:1485`, `:1723`, `:1725` (`cg_view.c:1139`, `:1141`, `:1296`, `:1298`, `:1303`, `:1601`, `:1896`, `:1898`), `cg_localents.swift:712` (`cg_localents.c:684`), `cg_draw.swift:7155`, `:7164`, `:7173` (`cg_draw.c:8088`, `:8098`, `:8108`), `cg_players.swift:7682`, `:7703`, `:7723`, `:8250`, `:8259`, `:8268`, `:8269`, `:8271`, `:8278`, `:8281`, `:8290`, `:8291`, `:8293` (`cg_players.c:9114`, `:9137`, `:9159`, `:9763`, `:9770`, `:9778`, `:9779`, `:9780`, `:9786`, `:9787`, `:9795`, `:9796`, `:9797`, where `:9780` and `:9797` are `(float)M_PI` in Raven), `ui_shared.swift:5220`, `:5763` (`ui/ui_shared.c:5827`, `:6460`).
- Dedicated, 9: `cm_terrain.swift:52` (`cm_terrain.cpp:1108`), `common.swift:1961`, `:1962`, `:1964`, `:1965`, `:1977`, `:1978`, `:1980`, `:1981` (`common.cpp:2148`, `:2149`, `:2151`, `:2152`, `:2163`, `:2164`, `:2166`, `:2167`, where the four return lines are `(float)M_PI` in Raven).
- JKAShared, 10, as `Double.pi` in `q_math.swift`: `:349`, `:411`, `:422`, `:1039`, `:1042`, `:1045`, `:1128`, `:1132`, `:1279`, `:1355` (`q_math.c:447`, `:500`, `:513`, `:1320`, `:1323`, `:1326`, `:1414`, `:1417`, `:1595`, `:1661`).

## The timing

Each line is one step, in seconds. Run 1 is the first sequence run. Run 2 and run 3 are the reruns after the tool fixes of the gate: run 2 after the enum comment rule, the host table rule, TR12, the map TYPES rows, and F10, and run 3 after the two fixes of the address test and the enum comment filter. The build lines of run 1 are the rounds of the first bulk fix, each one cut short by the first file that failed.

| Step | Run 1 | Run 2 | Run 3 |
| --- | --- | --- | --- |
| extract, 9 units | 67 | 68 | 77 |
| merge | 1 | 1 | 1 |
| tables | 0 | 0 | 0 |
| check | 4 | 5 | 5 |
| reexport | 37 | 80 | 78 |
| views-game | 62 | 64 | 2 |
| views-cgame | 46 | 44 | 1 |
| views-ded | 48 | 49 | 2 |
| skeleton-game | 24 | 24 | 24 |
| skeleton-cgame | 15 | 15 | 15 |
| skeleton-ded | 23 | 26 | 23 |
| manifest-game | 23 | 26 | 23 |
| manifest-cgame | 15 | 17 | 15 |
| manifest-ded | 23 | 25 | 23 |
| traps-game | 3 | 4 | 3 |
| traps-cgame | 2 | 2 | 2 |
| channel | 3 | 3 | 3 |
| sequence total | 396 | 453 | 297 |
| swift build | 8, 31, 5, 3, 7, 7, 36 | | 66, 8 |
| snapshot game | | | 124 |
| snapshot cgame | | | 51 |
| snapshot dedicated | | | 70 |
| swift test | | | 38 |
| tool tests | | | 2, 2 |

## The gate

- `swift build -j 6`: exit 0.
- `snapshot.py --check` of the game against `~/.cache/jka-swift/snapshot-stage-two-shared`: 372 files, no difference.
- `snapshot.py --unit mp-cgame --check`: 246 files, no difference.
- `snapshot.py --unit mp-engine-ded --check`: 544 files, a difference, which is the batch: 168 files differ, 98 files are new (the botlib views and their stubs), and one view is gone, `CArea.swift`.
- `swift test --no-parallel -j 6`: 149 of 150 pass. The one failure is the smoke test of `jampded`, see the open rows.
- `.venv/bin/python -m unittest discover -s tests`: 99 tests, OK, 14 skipped. `tests/test_project.py` takes the four headers that row 4 and row 5 add to the host entry list.
- `jampded < /dev/null`: it runs FS_Startup twice, prints `Couldn't load mpdefault.cfg`, frees 33 zone blocks, and exits 1. The stop is Raven's own fatal error for a tree with no game data, `files_pc.cpp:3022`, and no `TODO: Port` trap. FS_ReorderPurePaks of row F10 was the earlier stop.
- The SP UI target: the run wrote `code/ui/ui_public/uiImport_t.h` of `CJKASP_UI` as `cxx/code/ui/ui_public/uiimport_t.h`. Raven declares `uiimport_t` at `code/ui/ui_public.h:141` and `uiImport_t` at `:248`, two names that differ only in case, and the file system of the Mac folds them into one file. The `merge.py` of master gives the same output on the same extract trees, so the change of `partition_tree` is not the cause. The committed files are restored, and the row is open.

## The portMissing count

`portMissing(` stands 1146 times under `Sources/JKAMP_DedLogic`, against 1402 on master `d6f2dd7`.

## The open rows

- The smoke test `JampdedSmokeTests.swift:32` expects a `TODO: Port` trap on standard error. `jampded` now stops at Raven's own fatal error `Couldn't load mpdefault.cfg`, because the test tree has no game data. A ruling picks the new expectation of the test.
- R5: the ruled size of `CBoneCache` is 88 bytes. The member list of the ruling leaves out `boneInfo_v *rootBoneList` (4 bytes) and `mdxaBone_t rootMatrix` (48 bytes) of `tr_ghoul2.cpp:353` to `:389`, so the 32-bit size with every member is 140. Only the leak print of `z_memman_pc.swift:547` reads the count.
- The case fold of `uiimport_t.h` and `uiImport_t.h` in the SP UI target, see the gate.
- The remaining Ghoul2 holes that a ruled row names: the CBoneCache initializer (`CBoneCache.swift:129`), which G2_TransformGhoulBones calls, and the whole bodies of G2_RagDollSolve and G2_IKSolve.
- `.claude/manifest/mp-engine-ded/` is the manifest output of the dedicated unit. The manifest of the cgame is committed, and the one of the dedicated unit never was, so it stays out of the commits.
