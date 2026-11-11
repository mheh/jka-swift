# Docket 13, section 3: proofs of ten ROW-NEW rows

Read-only. Four opus agents did the proofs. This file merges their results. The citations are from master 001b610c.

Summary:

| row | verdict | scope |
|---|---|---|
| N-ROFFCLIENT | SETTLED, rule 19, `return false` | SINGLE-SITE |
| N-STRSLOTS | NOT SETTLED, recommend a `Slots<String?>` PARAMS kind | NEW PATTERN |
| N-CLOSURE | SETTLED, `CM_CircularIterate` hand edit | SINGLE-SITE |
| N-GP2 | split: 2 GPG in-order SETTLED, 6 NOT SETTLED | GPG part SINGLE-SITE, value part NEW PATTERN |
| N-USERDATA | NOT SETTLED, recommend dropping `userdata` | NEW PATTERN |
| N-LEAFLIST | SETTLED, `slotAddress`/`VMA` hand accessor | SINGLE-SITE |
| N-G2SAVE | SETTLED (CNode record form); pointer fields need a coordinator choice | SINGLE-SITE (flag: `char **` + `bytes` branch) |
| N-GORE | NOT SETTLED, recommend a hand signature | B SINGLE-SITE, A NEW PATTERN |
| N-LOCALTABLE | end row SETTLED (drop it, walk to count); element form a coordinator choice | SINGLE-SITE |
| N-X86 | SETTLED (CPUID precedent, real bodies) | SINGLE-SITE (flag: unix_main.c is the source) |

---

## 1. N-ROFFCLIENT

**Problem.** `oracle/codemp/qcommon/RoffSystem.cpp:833-848` (ApplyROFF) and `:979-991` (ClearLerp). The DEDICATED build removes the whole `mIsClient` arm. Four locals stay uninitialized: `originTrajectory`, `angleTrajectory`, `origin`, `angle`. SetLerp then writes through the two trajectory pointers (`:864-865`, `:883-887`, `:1006-1007`). These are wild writes to a garbage address. No entity state gets the values, and no client gets them. ApplyROFF then writes `ent->next_roff_time` with `ent == NULL` (`:906`).

**Reachability on WinDed.** Only `Play` sets `mIsClient` (`:617`). The server passes `qfalse` (`server/sv_game.cpp:725`). Only `cl_cgame.cpp:1279` passes `qtrue`, and WinDed does not link that file. `UpdateEntities(qfalse)` skips client ents (`:754`). So the arm is unreachable on WinDed.

**Swift.** `Sources/JKAMP_DedLogic/CROFFSystem.swift:432-435` and `:598-601`: `if roff_ent.mIsClient { // Port-note ... portMissing(...) }`. The `let`s are `Trajectory` HandleViews (`JKAShared/Generated/Views/Trajectory.swift:9`), and a view has no zero value. So candidate C cannot compile.

**Precedents.**
- Rule 19, `docs/porting-rules.md:44`: for a read of uninitialized memory, pick one defined behavior, under a Port-note.
- The function's own "bad stuff" exit, `return qfalse` (`RoffSystem.cpp:851-854`, `:997`). UpdateEntities reads false as "mark for death" (`:764-767`). Nothing reads the ClearLerp result (`:693`, `:777`).
- An empty DEDICATED arm in the same file: ProcessNote, `CROFFSystem.swift:535`.
- Rule 19 as a trap: `CROFFSystem.swift:713`, `be_ai_chat.swift:2083-2084`, `vm_interpreted.swift:35`, `:152`.
- Rule 19 as a zero value: `bg_pmove.swift:8265`, `Q3_Interface.swift:529`, `be_aas_move.swift:1068`. This does not apply, because a view has no zero.

**jka-rust.** It drops the `mIsClient` test as a "§20 DEDICATED drop" (`jka-rust/crates/mp/engine/qcommon/src/roff/roff_system.rs:651-652`, `:837-842`). A client ent then takes the server path. In Swift that would act on the server entity with the same number, so this form is wrong for this port.

**Verdict: SETTLED by rule 19** (candidate A). In `CROFFSystem.swift:432-435` and `:598-601`, replace `portMissing` with `return false`. Keep a Port-note of two lines or fewer: Raven writes through uninitialized trajectory pointers here, no WinDed caller sets mIsClient, and the arm takes the function's "bad stuff" return. No generator row. Candidate B (Com_Error) also meets rule 19, but it adds a behavior that Raven does not have.

**SINGLE-SITE.** Two sites in one file. No new kind or type.

---

## 2. N-STRSLOTS

**Problem.** `botlib/be_aas_main.cpp:68` `if (!stringindex[index])`, `:94` `if (!stringindex[i]) continue;`, `:131` `if (configstrings[i])`. The table is `char *configstrings[MAX_CONFIGSTRINGS]` (`be_aas_def.h:250`). The callers pass `&aasworld.configstrings[CS_MODELS]` (`:107`, `:117`).

**Swift.** `Sources/JKAMP_DedLogic/be_aas_main.swift:47`, `:60`, `:99` take `inout ArraySlice<String>`. That is the `string_slice` default at `spelling.py:623-626`. It cannot hold nil.

**Run time.** The NULL slots are real, but no file calls AAS_UpdateStringIndexes. `indexessetup` is written only at `:138` and stays 0, and the one use of AAS_IndexFromModel is in a comment (`be_ai_goal.cpp:548`). The cluster is dead, but rule 20 gives it real bodies.

**Precedents.**
- The view field already has the right type: `Aas.configstrings: Slots<String?>` (`Generated/Views/Aas.swift:466`), built by `Slots(strings:)` (`JKAShared/Views/Slots.swift:112`). `Server.configstrings` (`Server.swift:116`) has the same type.
- A nil test on that type: `sv.configstrings[index] == nil` (`sv_init.swift:105`).
- `suffix(from:)` (`Slots.swift:179`) gives the `&table[CS_MODELS]` form.
- TYPES `"opnames": "[String?]"` (`rulings.py:904-905`) is a file-scope table, not a parameter.
- PARAMS `pointer_table` (`rulings.py:1154`, `:1197`; `spelling.py:556`) gives `Slots<View?>`, for record pointers only.
- `string_slice` (`rulings.py:1177`, `:1332`) has no nil.
- No PARAMS kind gives `Slots<String?>`, and no parameter in any target has that type.

**jka-rust.** Raw `*mut *mut c_char` (`be_aas_main.rs:76`, `:120`, `:192`), with `is_null` at `:102`, `:201`.

**Verdict: NOT SETTLED.**
- **A (recommended):** a PARAMS kind that gives `Slots<String?>`, as the text twin of `pointer_table`. A `spelling.py` branch goes before the `string_slice` default, plus three PARAMS rows: `("AAS_StringFromIndex","stringindex")`, `("AAS_IndexFromString","stringindex")`, `("AAS_UpdateStringIndexes","configstrings")`. The callers pass `aasworld.configstrings.suffix(from: CS_MODELS)`.
- **B:** copy the table with nil changed to "". This loses Raven's NULL arm. An empty entry then matches an empty `string` in IndexFromString, and every call needs a copy.

**NEW PATTERN.** A new PARAMS kind.

---

## 3. N-CLOSURE

**Problem.** `server/sv_bot.cpp:257` `drawPoly(poly->color, poly->numPoints, (float *) poly->points)`. `qcommon/cm_patch.cpp:1758`, `:1761` pass `w->p[0]`, and `:1777`, `:1782` pass `v[0]`. The call at `:1804` is inside `#if 0`. Every argument is a vector table. The one real drawPoly, `R_DebugPolygon` (`tr_main.cpp:1540`), reads `points + i*3` as vectors.

**Swift.** `sv_bot.swift:245` and `cm_patch.swift:1831` have `drawPoly: ((Int32, Int32, inout Float) -> Void)?`. `table.closure` (`table.py:2129`) calls `self.param(p, following, traps=False)` with no owner, so no row can reach `points`.

**Precedents.**
- `CM_CircularIterate`, `cm_terrain.swift:22`: `_ callback: ((Slots<UInt8>, Float, Slots<Int32>) -> Void)?`. The generator gave `inout Int32`. A hand edit in the adopted file changed it (commit 6f1f376c, X42 R5). Ledger 10 `:86` records it as "auto ruled by pattern".
- A hand signature edit in an adopted file: `CG_Text_PaintWithCursor` `cursor` (ledger 10 `:22`).
- Element type: `("botlib_import_t.DebugPolygonCreate","points"): "table"` (`rulings.py:1474`) gives `Slots<vec3_t>` (`BotlibImport.swift:385`). These are the same debug polygon points.
- Argument types: `Winding.p: Slots<vec3_t>` (`Winding.swift:72`), `BotDebugpoly.points: Slots<vec3_t>` (`BotDebugpoly.swift:83`), and a local `vec3_t v[3]` under G6 (the form of `sv_bot.swift:547`).

**jka-rust.** Not ported. The renderer-debug surface is dropped (`cm_patch_fns.rs:15-21`).

**Verdict: SETTLED by the CM_CircularIterate precedent.** In `sv_bot.swift:245` and `cm_patch.swift:1831` (both adopted, with no skeleton header), change the closure type to `((Int32, Int32, Slots<JKAShared.vec3_t>) -> Void)?`, with one rule 24 AI line at each signature (Raven passes a `float *` to the vectors). The bodies pass `poly.points`, `w.p`, and `v`. No generator row. Candidate A (a `"<fn>.drawPoly"` owner key) is the option only if the user wants the generator to own closure parameters. It would also need a `table` branch for a `float` pointee (`spelling.py:360` requires a VECTORS pointee).

**SINGLE-SITE.** One closure type in two signatures, in an existing form.

---

## 4. N-GP2

**C3 as written.** `notes/2026-11-03/dedicated-cxx-docket.md:113` with its ledger line at `:136`. The coordinator ratified it under the 2026-11-03 delegation. The user's only recorded word on it is "The RMG should port". Text: "CGPGroup and CGenericParser2 become final class types ... CGPValue becomes a struct over [String]". The shapes paragraph (`:53`) says: "CTextPool and CGPObject have no Swift type ... the intrusive mNext and mInOrder* chains become Array order."

**Raven.** `CGPObject` holds `mNext`, `mInOrderNext`, `mInOrderPrevious` (`qcommon/GenericParser2.h:48`). SortObject (`GenericParser2.cpp:570-611`) builds the add chain and the name-order chain. The value list `mList` is a chain of plain CGPObject nodes, and the head's `mInOrderNext` holds the tail (`:343-358`). All handles are `void *` (`.h:166-168`).

**Swift.** `Sources/JKAMP_DedLogic/GenericParser2.swift`:
- `struct CGPValue { mName; mList: [String] }` at `:167-169`. It has no link and no parent.
- `final class CGPGroup` at `:308-316`: `weak var mNext`, `weak var mParent`, and the arrays `mPairs`, `mInOrderPairs`, `mSubGroups`, `mInOrderSubGroups`. AddGroup sets `mNext` by hand (`:460-463`), with an AI line at `:306-307`.
- All GPV_ stubs take `OpaquePointer?`, and no GPV_ body exists yet. Row G1 (`docket-13.md:296`) proposes `TGPValue -> CGPValue?`, which is a copy with no identity.

**Callers.** None of the 8 has a caller in `oracle/codemp`, the SP tree, `openjk`, or the MP game (`notes/2026-11-10/dead-check.md:17-22`).

| function | Raven returns | computable from today's arrays without reopening C3 |
|---|---|---|
| GPG_GetInOrderNext | the next subgroup in name order | Yes. Option 1: search `===` in `GetParent()?.mInOrderSubGroups`, then take index+1. This has a gap: Duplicate builds children with no parent (Raven `:532`, Swift `:367-381`). Option 2: a `weak var mInOrderNext`, in the `mNext` form, with no gap. |
| GPG_GetInOrderPrevious | the previous subgroup in name order | Same, with index-1. |
| GPG_GetPairs | the head of the add-order pair chain | Only `mPairs.first`. The head is no use without GPV_GetNext. |
| GPG_GetInOrderPairs | the head of the name-order pair chain | Same: `mInOrderPairs.first`. |
| GPV_GetNext | the next pair in add order | No. |
| GPV_GetInOrderNext | the next pair in name order (on a list head, the tail) | No. |
| GPV_GetInOrderPrevious | the previous pair in name order | No. |
| GPV_GetList | the head CGPObject node of the value list | No. CGPObject has no type under C3. |

**What breaks for values.** A struct copy has no identity and no parent, so the function cannot find the array to search. A search by content also fails, because AddPair keeps duplicates (`:615-639`, Parse `:721`, `:729`). With pairs `[a=1, b, a=1, c]`, a GetNext walk loops a, b, a, b and never ends. GPV_GetList needs a list-node type that C3 removed.

**Precedents.** `weak var mNext` and its set site (`:310`, `:462`). R5 CleanTextPool, NOT_PORTED because C3 removed its storage (`dedicated-open-rows-ledger-13.md:15`). `docket-13.md:17` lets NOT_PORTED stand when a ratified ruling removed the storage. R8 (the user's word that a function with no caller gets its real body: `ledger-13.md:18`, `porting-rules.md:45`). Note: docket line 17 supports candidate C, but the docket's own N-GP2 row (`:346`) says that C "goes against the new ruling". Line 17 is the coordinator's text, not the user's.

**jka-rust.** The handle API is not ported (`gp2/mod.rs:11-14`). Values are a `Vec<String>` (`gp_value.rs:11`), and in-order access is a sorted Vec (`gp_group.rs:80`, `:98`).

**Verdict.**
- **GPG_GetInOrderNext and GPG_GetInOrderPrevious: SETTLED by the `mNext` precedent.** Add `weak var mInOrderNext` and `weak var mInOrderPrevious` to CGPGroup. In AddGroup, after the sort, find the new group's index in `mInOrderSubGroups` by `===` and link both neighbours (Raven `:596-606`). Add the two getters and extend the AI line at `:306-307`. The bodies depend on rows G1 and G2. This does not reverse C3: C3 already keeps the group sibling walk "as Raven wrote it". SINGLE-SITE.
- **GPV_GetNext, GPV_GetInOrderNext, GPV_GetInOrderPrevious, GPV_GetList, GPG_GetPairs, GPG_GetInOrderPairs: NOT SETTLED.** Candidates:
  - **A:** CGPValue becomes a class with weak links, and the list node gets a type. This REVERSES C3 for values. Duplicate, `mutating AddValue`, and the AI line at `:513` change.
  - **D:** a handle of group plus index, or a weak parent and an index stored in the struct. Raven has no counterpart, so it is a new handle form, against the no-helper-litter ruling. GPV_GetList still has no body.
  - **C (recommended):** NOT_PORTED-replaced in the CleanTextPool form: "C3 makes the value list an Array, so the chain does not exist." This makes R8 yield to C3 for 6 functions with no caller in any tree.

**NEW PATTERN** for the value part. A reverses C3 (a coordinator ruling that the user accepted). D is a new handle form. C makes the user's R8 yield to C3. Whichever candidate the user picks, it is the user's ruling.

---

## 5. N-USERDATA

**Problem.** `qcommon/cm_terrain.cpp:997` `TerrainPatchIterate(void (*IterateFunc)(CCMPatch *, void *), void *userdata)`, and `:1628` forwards to it. There are two real userdata types: `tr_terrain.cpp:923` passes a renderer `CTRLandScape *`, and `RM_Terrain.cpp:493` passes a `CRMLandScape *` (called only from `cl_cgame.cpp:1707`). The dedicated server calls neither path. `CRMLandScape` is only in `mp-rmg/cxx_only.txt:43`, not in `mp-engine-ded`, so no Swift type exists.

**Swift.** `cm_terrain.swift:108` `CM_TerrainPatchIterate() -> Never` and `CCMLandScape.swift:398` `TerrainPatchIterate() -> Never`. `CCMPatch` exists (`CCMPatch.swift:10`, CXX_CLASSES `rulings.py:1651`).

**Precedents for a `void *` user argument.**
- Typed by the one referent: `captureData: ScrollInfo?` and `captureFunc: ((ScrollInfo?) -> Void)?` (`rulings.py:899-903`, `ui_shared.swift:23`). Also the PARAMS `("view", record)` rows (`rulings.py:1261`, `:1267-1272`).
- qsort comparators: `int_value` and `string_value` (`rulings.py:1156`, `:1178`, `:1253`, `:1341`).
- `int *user` as `Slots<Int32>` (`rulings.py:1503-1508`).
- No logic target uses `AnyObject`. No port drops a user argument in favor of closure capture.

**jka-rust.** Dropped as §20 (`cm_terrain.rs:59-60`).

**Verdict: NOT SETTLED.** The typed-referent precedent needs one referent type. Raven has two, and neither is ported.
- **A (recommended):** drop `userdata`. The closure becomes `((CCMPatch?) -> Void)?`, and a caller captures the value. No cast. It changes the arity and needs AI lines.
- **B:** `AnyObject?`. Every callee needs a downcast, against the no-casts rule.
- **C:** a typed CRMLandScape. It needs the RM_Terrain port, which is outside the dedicated unit, and it is still wrong for the renderer caller.

**NEW PATTERN.** The codebase has no form for this.

---

## 6. N-LEAFLIST

**Problem.** `qcommon/cm_test.cpp:117` `((cbrush_t **)ll->list)[ ll->count++ ] = b;`, and `:204-205` set `ll.list = (int *)boxList` and `ll.storeLeafs = CM_StoreBrushes`. CM_BoxBrushes has no caller.

**Swift.** The view `LeafList.list: Slots<Int32>?` (`Generated/Views/LeafList.swift:83`). CM_StoreLeafs (`cm_test.swift:54`) writes `ll.list![ll.count] = leafNum`. CM_StoreBrushes (`:73`) is complete except for the store, which is `portMissing`. CM_BoxBrushes (`:198`) has `boxList: inout Cbrush?`. LeafListThunks (`:476`) holds only CM_StoreLeafs.

**Precedents.**
- `NodeSlots.swift:8` `slotAddress`: a hand accessor in the view target that reads a `node_t *` slot as `node_t **`, under one AI line. Ratified 2026-11-04 (`notes/2026-11-04/dedicated-open-rows-ledger.md:61`).
- `GameViews.swift:7-21`, `:115`: int words read as pointers, and `VMA<V>` gives `Slots<V?>(pointers:)`.
- `BotlibViews.swift:9-46` (row N6).
- FIELDS `raw` (`rulings.py:746`, `:779`) moves every user to byte offsets, including CM_StoreLeafs and CM_BoxLeafnums.

**jka-rust.** Casts (`cm_test.rs:123`, `:257`).

**Verdict: SETTLED by the slotAddress and VMA form.** In a hand view file (for example `Sources/JKAMP_Ded/TraceViews.swift`, which holds cm_test helpers), add `extension LeafList { public var listBrushes: Slots<Cbrush?>? }` with a get and a nonmutating set over the same word, through `Slots(pointers:count:)`, a `Source: cm_test.cpp:117` line, and one AI line. CM_StoreBrushes writes `ll.listBrushes![ll.count] = b` and then `ll.count += 1`. CM_BoxBrushes gets `boxList: Slots<Cbrush?>` from G8, sets `ll.listBrushes = boxList`, and stores `LeafListThunks.CM_StoreBrushes`. Add that thunk at `cm_test.swift:476` in the form of `:478`. No generator row beyond G8 and G21.

**SINGLE-SITE.** One accessor in an existing hand view pattern.

---

## 7. N-G2SAVE

**Problem.** `oracle/codemp/ghoul2/G2_misc.cpp:1715-1717`: `SURFACE_SAVE_BLOCK_SIZE sizeof(surfaceInfo_t)`, `BOLT_SAVE_BLOCK_SIZE (sizeof(boltInfo_t) - sizeof(mdxaBone_t))`, `BONE_SAVE_BLOCK_SIZE sizeof(boneInfo_t)`. `:1736`, `:1858`: the band size is `&mTransformedVertsArray - &mModelindex`. The marker is at `ghoul2_shared.h:239`.
- Save (`:1719-1809`): an empty vector gives a 4-byte zero buffer. Otherwise it computes `*size`, calls `Z_Malloc(TAG_GHOUL2)`, and writes the count, then for each model the band, then the counts and records of slist, blist, and bltlist, each by memcpy.
- Load (`:1841-1910`): it resets 4 fields and copies the band. If `mModelindex != -1 && mFileName[0]`, it sets `mModelindex = i` and calls G2_SetupModelPointers. Then it resizes each list and copies the records.

**Raven 32-bit layout.**
- **CGhoul2Info band, 116 bytes:** mModelindex 0, mCustomShader 4, mCustomSkin 8, mModelBoltLink 12, mSurfaceRoot 16, mLodBias 20, mNewOrigin 24, mGoreSetTag 28, mModel 32, mFileName[64] 36, mAnimFrameDefault 100, mSkelFrameNum 104, mMeshFrameNum 108, mFlags 112. No pointer and no padding.
- **surfaceInfo_t, 24 bytes:** offFlags 0, surface 4, genBarycentricJ 8 (float), genBarycentricI 12 (float), genPolySurfaceIndex 16, genLod 20.
- **boltInfo_t save block, 16 bytes:** boneNumber 0, surfaceNumber 4, surfaceType 8, boltUsed 12. The `position` matrix is not saved.
- **boneInfo_t, 744 bytes.** This agrees with jka-rust's ILP32 asserts, `jka-rust/crates/mp/engine/ghoul2/src/shared/bone_info_t.rs:130-172`, `:201-229`, which are a full offset list. Four saved members are pointers and cannot round-trip: basepose 484, baseposeInv 488, baseposeParent 492, baseposeInvParent 496 (in Swift, `MdxaBone?` views, `boneInfo_t.swift:63-66`). The padding at 658-659 and 685-687 is copied uninitialized.

**Consumers.** None in MP. No file of `oracle/codemp` or `openjk/codemp` outside `ghoul2/` calls G2API_Save, Load, or FreeSaveBuffer. The exception is the `re.` table entries in `openjk/codemp/rd-*/tr_init.cpp:608`, `:635`, `:651`, which nothing calls. `server/sv_game.cpp` has no G_G2_ save trap. The only users are SP (`oracle/code/game/g_savegame.cpp:856`, `:1058`), against the SP tree's own Ghoul2. `rulings.py:1526-1529` (DEAD) and `dead-check.md:173-174` agree. The buffer never leaves the process (no disk, no network). Byte compatibility with a Raven client or a saved file is not needed. A faithful port keeps the 32-bit `*size` value, the record order and offsets, and a Save-to-Load round trip in the same process.

**Swift.** `G2_misc.swift:1257` Save: `_ buffer: inout JKAShared.TextCursor`. That is the `char **` text cursor default at `spelling.py:552`, which is wrong. `:1265` FreeSaveBuffer: `inout CharBuf`, with an empty body and an AI line. `:1290` Load: `inout CharBuf`. The callers have the same shapes: `G2_API.swift:1729`, `:1734`, `:1739`. Ledger 8 row G2B6 (`dedicated-open-rows-ledger-8.md:103-105`) said the buffer form "waits for G2_SaveGhoul2Models". So a change here completes that wait. It is not a reversal.

**Precedents.**
1. A hand 32-bit record at byte offsets: `CNode.swift:362-371` (save) and `:427-435` (load), with typed subscripts `[int:]`, `[float:]`, `[ushort:]`, `[byte:]` (`Slots.swift:203-226`), and padding written as zero under a Port-note (`CNode.swift:363`). Also `CNavigator.swift:187`, `CBlockMember.swift:117`, `:125`.
2. A 32-bit size constant for a hand class: `tr_ghoul2.swift:289-294` `sizeofCBoneCache = 140`.
3. A Z_Malloc block as `Slots<byte>`: `tr_model.swift:89`. A `void **` of kind `bytes` gives `inout Slots<byte>?` (row TR13, `spelling.py:327-332`, `rulings.py:1400-1402`).
4. Free of a `Slots<byte>` block: `files_pc.swift:1603` `FS_FreeFile(OpaquePointer(buffer.base))`. Z_Free is at `z_memman_pc.swift:261`.
5. `MSVC_WIDTH_FOLDERS` (`rulings.py:952`) does not apply. It covers only `long` widths.

**jka-rust.** `misc.rs:1562-1580` writes the band field by field in Raven's order. The records are raw `size_of` copies: boneInfo_t is 768 bytes on a 64-bit host (`bone_info_t.rs:174`), and boltInfo_t is 64 bytes (`misc.rs:1646`, `:1772`) where Raven saves 16. So jka-rust is not byte-compatible, and it says so at `:1551-1561` (round trip only). The pointers travel as raw addresses, which rule 11 forbids here.

**Verdict: SETTLED for the layout, by the CNode record form.** Write each field at Raven's 32-bit offset into a Z_Malloc'd `Slots<byte>`. Use size constants in the `sizeofCBoneCache` form: band 116, surface 24, bolt 16, bone 744.
- `G2_misc.swift`: Save takes `_ buffer: inout Slots<JKAShared.byte>?` and calls `Z_Malloc(size, TAG_GHOUL2, true)`. Copy the bone offset list from `bone_info_t.rs:201-229`. Write the padding as zero under a Port-note. Load takes `Slots<JKAShared.byte>`. FreeSaveBuffer takes `Slots<JKAShared.byte>` and calls `Z_Free(OpaquePointer(buffer.base))`. This replaces the G2B6 empty body.
- `G2_API.swift:1729-1741`: the same three signature changes.
- Generator: PARAMS `bytes` on `("G2_SaveGhoul2Models","buffer")`, `("G2API_SaveGhoul2Models","buffer")`, `("G2_LoadGhoul2Model","buffer")`, `("G2API_LoadGhoul2Models","buffer")`, `("G2_FreeSaveBuffer","buffer")`, `("G2API_FreeSaveBuffer","buffer")`. `char *` with `bytes` already gives `Slots<byte>` (`spelling.py:338`). `char **` with `bytes` has no branch: only `void **` gets `inout Slots<byte>?` (`:329-332`). Widen that test to a `char **` pointee, or use a hand signature and keep the table row in agreement. Remove the DEAD rows at `rulings.py:1528-1529` (G21).
- **Open choice for the coordinator (no source fixes it):** the four pointer fields at 484-499. Raven restores the same addresses in the same process, and a Swift view cannot fit in 4 bytes. Recommended: write zero on Save under one rule 24 line, and store nil on Load. Alternative: skip the 16 bytes on Load and keep the Swift values.

**SINGLE-SITE**, with one flag. The record form, the size constant, the Slots out-buffer, and the free all exist. The `char **` + `bytes` widening reuses the existing kind and Swift shape. If the coordinator reads that widening as a new PARAMS shape, a hand signature avoids it.

---

## 8. N-GORE

**Problem.** `ghoul2/G2_misc.cpp:113-116` `void *G2_GetGoreRecord(int tag) { return FindGoreRecord(tag); }`. FindGoreRecord returns `GoreTextureCoordinates *` (`:103`). Swift `G2_misc.swift:161-169` is `func G2_GetGoreRecord() -> Never`, with the note "No table row for the return void *".

**Facts.** GoreTextureCoordinates is a ported hand class (`GoreTextureCoordinates.swift:14`, CXX_CLASSES `rulings.py:1643`, storage `EngineWorld.swift:726` `[Int32: GoreTextureCoordinates]`). Swift FindGoreRecord already returns `GoreTextureCoordinates?` (`G2_misc.swift:154`). FindGoreSet and NewGoreSet return `CGoreSet?` (`:178`, `:186`). `spelling.py:699-703` spells a typed class-pointer return as an optional class. Gore is compiled on WinDed: `game/q_shared.h:3110` defines `_G2_GORE` with no condition, and the function is inside `#ifdef _G2_GORE` (`G2_misc.cpp:26`). G2_GetGoreRecord has no caller in any tree.

**RETURNS precedents.** `class_ref` (`rulings.py:981`, used at `:1070` for Com_ParseTextFile). `table.py:2200-2205` reads the class from the pointee declaration, and a `void *` has none. The tuple form `("view", record)` for a `void *` return (`table.py:2215-2217`; rows G2_FindSurface `rulings.py:1082` and G2_FindSurface_BC `:1095`, the latter with an AI line at `tr_ghoul2.swift:1545`). TYPES `"captureData": "ScrollInfo?"` (`rulings.py:896`).

**jka-rust.** Dropped as dead (`api_gore.rs:16-19`, `gore/gore_set.rs:18`).

**Verdict: NOT SETTLED.**
- **A:** RETURNS `("class_ref", "GoreTextureCoordinates")`. It needs a tuple branch in `table.py:2200`. That is a new RETURNS shape.
- **B (recommended):** a hand signature `func G2_GetGoreRecord(_ tag: Int32) -> GoreTextureCoordinates?` with the body `return FindGoreRecord(tag)`, and one rule 24 AI line in the `tr_ghoul2.swift:1545` form. `G2_misc.swift` is adopted, so the hand signature holds. No generator change.

**B is SINGLE-SITE. A is a NEW PATTERN** (a new RETURNS tuple kind).

---

## 9. N-LOCALTABLE

**Problem.** `botlib/l_precomp.cpp:669-681`: a local `struct builtin { char *string; int mBuiltin; } builtin[]` with 4 rows and a `{ NULL, 0 }` end row. The walk is `for (i = 0; builtin[i].string; i++)`. No caller (`l_precomp.h:126` only declares it). Swift `l_precomp.swift:569-573` is `portMissing`.

**Precedents.**
- End row dropped, walk to count: `docs/transcription.md:499` ("the array's count takes the place of his {0, 0} row"). `spawns`, `g_local.swift:350-353` with `SpawnRow` at `:787`. `itemParseKeywords`, `cg_local.swift:814-817`, walked as `while i < itemParseKeywords.count` (`ui_shared.swift:7999`, `:8715`) for Raven's `ui_shared.c:8999`.
- End rows kept only for a declared bound: `directives[20]` and `dollardirectives[20]` (`EngineWorld.swift:370-393`, `DirectiveRow` at `:822`, walk at `l_precomp.swift:2039`).
- Element form: every existing table is file-scope data with a named `<View>Row` struct on the World (`transcription.md:496-497`). The port has no local table of records and no local type. A tuple stands for a two-field record in `CachedEndianedModelBinary_t.swift:12-13` (`[(Int32, Int32)]`, by the C++ docket).

**jka-rust.** A local unlabeled tuple array, end row dropped, a `for` loop (`l_precomp_fns.rs:376-389`).

**Verdict.**
- The end row is **SETTLED**: drop it and walk to `.count` (`transcription.md:499`, `ui_shared.swift:7999`).
- The element form is not fixed by a source, because the port has no local table. Recommended for the coordinator: a local labeled tuple array `let builtin: [(string: String, mBuiltin: Int32)]`, walked with `while i < builtin.count`. It adds no type, and `builtin[i].string` reads as Raven wrote it. jka-rust and the pair precedent support it. A local struct named `builtin` collides with the variable name in Swift. A file-scope `BuiltinRow` on EngineWorld moves a non-static local to the world and adds a type.

**SINGLE-SITE.** One function. No new kind, view, or type.

---

## 10. N-X86

**What each function does.**
- `Sys_FunctionCmp` (`null/win_main.cpp:59`) and `Sys_FunctionCheckSum` (`:128`) read machine code at a function address. They follow an x86 `0xE9` jmp, scan for a `C3 90 90` end, and skip `0xE8` call displacements. They have no meaning on arm64, which has fixed 4-byte instructions. A literal body also needs raw reads of code memory, which rule 11 forbids.
- `Sys_GetCPUSpeedOld` (`win32/win_shared.cpp:338`): `timeBeginPeriod`/`timeEndPeriod`, thread priority, `timeGetTime`, `rdtsc`.
- `Sys_GetCPUSpeed` (`:399`): `QueryPerformanceFrequency`/`QueryPerformanceCounter` (`LARGE_INTEGER.LowPart`), thread priority, `rdtsc`.
- On arm64 the performance counter and thread priority have POSIX equivalents. `rdtsc` has none, because Apple silicon gives user code no CPU cycle counter.

**Callers.** The two scan functions have none (`qcommon.h:1032-1033` only declares them). Sys_GetCPUSpeed: only the client's `win32/win_main.cpp:1469`. Sys_GetCPUSpeedOld: only `win_shared.cpp:425`. OpenJK removed all four. jka-rust does not have them. Raven's own non-Win32 form is `unix/unix_main.c:68-79`: Sys_FunctionCmp returns qtrue, and Sys_FunctionCheckSum returns 0.

**Swift.** `win_main.swift:122-140` and `win_shared.swift:245-258` are `portMissing`. The second cites ledger 7 row W7 "keep markers" (`dedicated-open-rows-ledger-7.md:41-43`). Ledger 13 R8 (`dedicated-open-rows-ledger-13.md:18`, rule 20 at `porting-rules.md:45`) replaced that ruling.

**Precedents.**
- An x86 instruction with no host form gets a body and an AI line, not NOT_PORTED, in the same file: CPUID stores nothing (`win_shared.swift:98`), IsPentium takes Raven's `err:` arm (`:103`), and the Willamette test drops (`:178`).
- `rdtsc` becomes `SysBackend.timeGetTime()` milliseconds, with an AI line (`timing_c.swift:20`, `:27`; ledger 9 line 77).
- A Win32 call becomes a SysBackend member, "one function for each Win32 or Winsock call" (`SysBackend.swift:156`): `timeGetTime` `:174`, `GetFileTime` `:547`, `GlobalMemoryStatus` `:289`. A Win32 record type follows the `FILETIME` form (`:52`).
- NOT_PORTED with a platform reason: `VM_DllSyscall`, "Swift cannot write a C variadic callee" (`rulings.py:1559-1560`). `Sys_GetFileTime` is NOT_PORTED because SysBackend replaces it (`:1563-1564`).

**Verdict: SETTLED by the CPUID precedent.** Each body can exist, so NOT_PORTED does not meet the user's bar for any of the four.
- `Sys_FunctionCmp` and `Sys_FunctionCheckSum`: `return 1` and `return 0` (Raven's `unix_main.c:68-79`), each with one AI line: "Raven scanned the x86 opcodes of the function body. The host runs no x86 code, so the body takes Raven's unix return." Change the Port-note to the no-caller note.
- `Sys_GetCPUSpeedOld` and `Sys_GetCPUSpeed`: real bodies. `rdtsc` takes the timing_c form. Add SysBackend members `timeBeginPeriod`, `timeEndPeriod`, `GetCurrentThread`, `GetThreadPriority`, `SetThreadPriority`, `QueryPerformanceFrequency`, `QueryPerformanceCounter`, a `LARGE_INTEGER` struct with `LowPart` in the FILETIME form, and the `THREAD_PRIORITY_*` constants. With a millisecond clock the result is a constant 0 on the host.

**SINGLE-SITE**, with one flag. This is the first time the port takes a value from a non-WinDed Raven file (`unix_main.c`). If the coordinator rejects that source, the two scan functions become NOT SETTLED. The candidate is then NOT_PORTED, with rule 11 (raw code reads) and the arm64 reason, and that goes to the user.
