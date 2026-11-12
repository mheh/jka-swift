# Batch 9 resume state

The worktree `/tmp/jka-batch-9`, branch `dedicated-rulings-batch-9`. Step 1 of the brief (make every change) is still in progress. No sequence run, no build, and no gate check has run on this branch. No check is running now.

## Merge state

- The five bot body branches are merged (`ded-bodies-bot-util`, `-precomp`, `-chat`, `-aas`, `-move`).
- master `d6f2dd7` (PR 85, 86, 87) is merged as `f068c31`. The one conflict, `CGhoul2Info_v.swift`, is resolved: `Array` is a get/set property over `Ghoul2InfoArray.mInfos`.
- `ded-bodies-icarus` `74bfc29` is merged as `86d069a`. The conflicts of `CBlock.swift`, `CBlockMember.swift`, and `CNavigator.swift` are resolved to the new signatures of this batch. No conflict is open.
- The work-in-progress commits after the merges hold every edit, tools and hand code apart. Their subjects start with "Work in progress".

## Done in step 1 (my own rows)

- The botlib rows D1 to D17, D19, D20, N1, N3 to N7: the `ded_types.h` copies, 95 HOST_ROOTS rows and `pc_token_t`, `MSVC_WIDTH_FOLDERS` with `Table.msvc_width`, TYPES, FIELDS kinds `text_buffer`, `text_offset`, `vectors`, `bytes` on `unsigned short *`, SLOT_BOUNDS with a None row, the directive tables on EngineWorld, the botlib C tables in `tables.py`, `ded_tables.h`, and `DedTables.swift`, the allocator RETURNS rows, `BotlibViews.swift` (the AAS accessors and `Slots<UInt32>(wordBefore:)`), the D16 PARAMS, NULLABLE, and BYTE_STORAGE_LOCALS rows.
- D18: `__builtin_va_start` joins TEXT_READERS in `table.py`, so the `char *fmt` of Log_Write becomes a String. Check the game and cgame snapshots for other functions that change.
- The terrain classes: the Raven comment blocks of `CRMManager.swift` and `CRMObjective.swift`, the `landScape_cmg` forward in `cm_load.swift`, and the readers of `cmg.landScape` in `cm_load.swift`, `cm_trace.swift`, and `cm_test.swift` read the forward with one AI line each.
- G2A1: `CGhoul2Info_v` `Array` get/set, the subscript setter, `resize`, and `push_back` (one AI line: the one caller hands a new temporary, `G2_API.cpp:645`). DeepCopy stays a marker: CGhoul2Info and its list elements are classes with no value copy.
- The rows of `/tmp/review-cm.md`: the stride of a two-index array of arrays (`views.row_stride`, test `tests/test_rows.py`, passes), and the holes of `cm_patch.swift` (CM_RemoveDegenerateColumns, the grid fill, the dead `i += 1`) and of `cm_trace.swift` (CM_PositionTest `leafs`, the terrain box test) closed with Raven's lines.

## Done by the first two helper agents (in the earlier commits)

T7, P6, R1, the callback alias, S4 ratified. F10 open (no slot form for a Swift-storage global). interface_export_t, the mdxaBone fields, the `vector &` returns, CBlockMember.m_data, failedEdges, NodeTotalGreater ratified. The terrain and RMG classes written.

## In progress with the second two helper agents, at the pause

Their edits are in the last work-in-progress commits, unchecked.

- Agent "Ghoul2 and tr": rows G2A2 to G2A10 and G2API_SetBoneIKState, G2API_IKMove, G2API_AddSkinGore (`notes/2026-11-09/dedicated-body-round-g2-api-2.md`), TR11 to TR20 and the six marker stubs (`dedicated-body-round-tr-2.md`), R1 to R11 of `dedicated-body-round-g2-bones-2.md` (R9 as DEAD), one form for TR14, G2A4, and bones R1, the signed-index sweep of `/tmp/review-g2-bones.md` (five sites) over the Ghoul2 and renderer stems, and the four findings of `/tmp/review-g2-api.md` (G2_bolts.swift:62, RagEffectorGoal NULLABLE `pos`, the `&+=` of mRefCount, the leak tracker guard).
- Agent "ICARUS, vm, skeleton": rows 1 to 16 of `notes/2026-11-09/dedicated-body-round-icarus.md` (row 7 `MSVC_WIDTH_FOLDERS` for ICARUS, NPCNav, ROFF; row 12 `@discardableResult`; row 13 the `Int32` VM_Call form and Q3_GetTime, Q3_GetTimeScale; row 16 the module-wide `let` of a .cpp `#define`, and N2 the `CS_` constants of be_aas_main), the navigator `bitPattern:` casts, the navigator and ICARUS signed-index sweep, and the pointer-wide return of SV_GameSystemCalls (the coordinator's message on PR 85).

## Next

1. Read the two agents' reports or their diffs, and finish what they left.
2. Run `cd /tmp/jka-batch-9 && RUN=1 /tmp/b9-seq.sh`. It logs each step's seconds to `/tmp/b9-timing.log`. Then the gate, timed the same way: `swift build -j 6`, the three `snapshot.py --check` runs against `~/.cache/jka-swift/`, `swift test --no-parallel -j 6`, and `.venv/bin/python -m unittest discover -s tests`.
3. N2 if the agent found no generator path: adopt `be_aas_main.swift` after the run and add the three `private let` constants with one AI line.
4. Fix in bulk, run again, then write `notes/2026-11-09/dedicated-open-rows-ledger-9.md` with the timing table, and commit tools, generated output, hand code, and records apart.

## The report of agent "ICARUS, vm, skeleton" at the pause

- Changed `CNavigator.swift` only: TestBestFirst signed-index test (navigator.cpp:1188), the failedEdges bodies ClearAllFailedEdges, EdgeFailed, AddFailedEdge, CheckAllFailedEdges. The ten `bitPattern:` casts stay, with a "C converts ..." line each (master's form at cm_load.swift:739). No tool file changed.
- Row 16, proved, not edited: in `skeleton.collect_macros` (about :514), set `macro.shared = True` when `C.HOST` and the name is in `self.exported_of(stem)`. Host only, because other files read `NODE_COLLECT_MAX`, `GORE_TAG_UPPER`, `MAX_DEBUGLINES`. Shadows: `MASK_SOLID` (be_aas_entity, other value, the bug); same value: ET_ITEM, MAX_LOGFILENAMESIZE, MAX_CHARACTERISTICS, MAX_BSPENTITIES (generated), STAT_WEAPONS, MAX_QUED_EVENTS, MASK_QUED_EVENTS, MAX_PACKETLEN, MAX_LOOPBACK, MAX_SNAPSHOT_ENTITIES, NUM_G2T_TIME (adopted, hand edit).
- Row 7, proved, not edited: add "icarus" and "NPCNav" to MSVC_WIDTH_FOLDERS (ROFF lives in qcommon, do not add). Then GetLong to Int32, CNode Save and Load, CNavigator Save and Load by hand.
- N2: no generator path; adopt `be_aas_main.swift` after the run.
- Not done: rows 1 to 6, 8 to 15 of the icarus record (row 12 `@discardableResult`, row 13 VM_Call `Int32` form), and SV_GameSystemCalls to `Int`.

## The report of agent "Ghoul2 and tr" at the pause

- Ratified: one form for bones R1, G2A4, and TR14, `extension HandleView { init(_ record:, byteOffset:) }` in `Sources/JKAMP_Ded/LumpViews.swift`, with `MdxmSurfHierarchy.byteCount(childIndexes:)` and `MdxaSkel.byteCount(children:)`; five SLOT_BOUNDS None rows for the `[1]` arrays of `mdx_format.h:179`, `:194`, `:211`, `:378`, `:395`. G2A2 (the CGhoul2Info_v overload of G2_SetupModelPointers, written). G2A3 (PARAMS view model_t, body filled). G2A5 (G2_FindSurface not private, view rows, body still a hole). G2A6 (PARAMS model_list). G2A9 (the 4-argument G2_Animate_Bone_List and the G2API_AnimateG2Models body).
- Open or not started: G2A7 (G2_Generate_Matrix must change in the same edit), G2A8 (ruling found: an internal `let GHOUL2_CRAZY_SMOOTH = 0x2000 as Int32` in G2_API.swift, the GHOUL2_RAG_STARTED form, not applied), G2A10, the three marker stubs, bones R2 to R11 (R9 DEAD not confirmed), every finding of `/tmp/review-g2-bones.md` and `/tmp/review-g2-api.md`.
- A fork of that agent worked on TR11 to TR20 and the six tr_model stubs and may still have been running at the pause. Its edits, if any, are in `tr_*.swift` and `rulings.py`, and its result is unknown. Check `git status` first: an edit after the last commit is the fork's.
- Build risks named by the agent: `Q_stricmp(String, String)` in G2_IsSurfaceLegal, `Int32(truncatingIfNeeded: surf.flags)`, `MemoryLayout.offset(of:)` on the imported `childIndexes` and `children`.

## The TR fork's results, after the pause (part committed in a573b01, a1f1683, bb951c3, the rest in the last WIP commits)

- Ruled: TR11 (PARAMS kind `byte_array`, `[byte]` for `styles`, two Com_Memcpy as loops under AI lines), TR12 (FIELD_NAMES `modelHandle`), TR13 (PARAMS `bytes`, a `void **` of kind `bytes` is `inout Slots<byte>?`), TR14 (`HandleView.init(_:byteOffset:)` in R_ModelBounds and R_GetTag), TR15 (a `_Bool` field gets a `Bool` accessor, also `traceWork_t.startout` and `getout`), TR16 (a pointer array over IMPORT_LIMIT gets `Slots(pointers:)`, `tr.shaders` and `sortedShaders`), TR17 (a record storage of several dimensions takes the product of its bounds, `texMods` 32 records; ClearGlobalShader traps until the generator runs), TR18 (RETURNS kind `int32`, NameToAFunc), TR20 (PARAMS kind `byte_offset`).
- TR19 differs from the coordinator's form: the fork reused the hand `InfoParm` struct of `cm_shader.swift:31` as a `let [InfoParm]` in tr_shader.swift, not the DED_PIECES C table. Redo it as the `r_vidModes` form if the C table is wanted.
- The six stubs: the two Malloc functions return `Slots<byte>` with bodies; ServerLoadMDXA, ServerLoadMDXM, R_LoadMD3 have signatures, no bodies (a new spelling.py rule spells a C++ non-const scalar reference `inout <scalar>`; check the generator diff for other host markers it shapes); R_LerpTag is DEAD.
- Open: R_LoadMDXA and R_LoadMDXM of tr_ghoul2.swift need the hand signature `(_ mod: Model, _ buffer: Slots<JKAShared.byte>, _ mod_name: String, _ bAlreadyCached: inout Bool) -> Bool`; RE_RegisterModel_Actual keeps its switch hole; the three StoreShaderRequest callers need a byte-distance form.
