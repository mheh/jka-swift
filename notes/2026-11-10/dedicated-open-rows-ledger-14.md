# The open rows of the dedicated host, the fourteenth ledger

This record holds the generator batch of `notes/2026-11-10/docket-13.md` of the main tree: rows G1 to G21 of its section 2, the hand items, the row G22 that the coordinator added, the two review corrections, and the new-form rows of `notes/2026-11-10/rows-14-new.md` for the body wave. The batch is the branch `dedicated-rulings-batch-13`, from the local branch `dedicated-integration-14` (master `001b610c` with the eight body sets S1 to S8), in the worktree `/tmp/jka-batch-11`.

The authority "auto ruled by pattern" means that the coordinator checked the proof at Raven's line and at the line of the precedent before the change, under the delegation of 2026-11-03. Every Raven cite is under `oracle/codemp/`, and every Swift cite is under `Sources/`. A C++ method has no generated stub, so a row keyed by a method records the hand signature, and the change that unblocks the body is the hand signature in the adopted file.

## The rows

| Row | Verdict | Authority | Precedent | Status | Unblocks |
| --- | --- | --- | --- | --- | --- |
| G1, TYPES `TGenericParser2`, `TGPGroup`, `TGPValue` | Each handle is the hand Swift type, optional. Every routine of `GenericParser2.cpp:928` to `:1203` casts its handle to `CGenericParser2 *`, `CGPGroup *`, or `CGPValue *`. A pointer to a handle typedef, `TGenericParser2 *GP2` of GP_Delete (`:952`), is the caller's optional handle, inout, through a new branch of `spelling.py` beside the class pointer pointer rule | auto ruled by pattern | `"captureData": "ScrollInfo?"`, `rulings.py:900`; the `CGhoul2Info_v **` rule, `spelling.py:373` to `:378` | landed | W1 |
| G2, CXX_CLASSES `CGPGroup` | The final class of `GenericParser2.swift` | auto ruled by pattern | `"CGenericParser2"`, `rulings.py:1629` | landed | W1 |
| G3, PARAMS `("GP_Parse", "dataPtr")` | Not applied. The proof does not hold: the default rule of a non-const `char **` (`spelling.py:550` to `:552`) already gives `inout TextCursor`, and a skeleton run without the row prints the same signature | none | `("Q3_ReadScript", "buf")` is a `void **`, which needs its row | open, no row needed | W1 needs nothing more |
| G4, RETURNS `GPG_FindPairValue`, `GPV_GetTopValue` as `optional_string` | `CGPGroup::FindPairValue` returns NULL for a missing key and a NULL default, and `CGPValue::GetTopValue` returns NULL for an empty list. The kind now reads a pointer return alone (`table.py`), so the `bool` overloads of `:1099` and `:1182` keep their Bool | auto ruled by pattern | `rulings.py:988` to `:993`; the record-kind test of `table.py:2185` | landed | W1 |
| G5, NOT_PORTED `CleanTextPool`, `Cvar_Realloc`, `GetNodeLeadDistance` | CleanTextPool: row C3 makes the text pool a String (`GenericParser2.cpp:907` is the one caller). Cvar_Realloc: Cvar_Defrag (`cvar.cpp:979`, calls at `:1007` to `:1010`) is a no-op, and only `client/cl_main.cpp:715` calls it. GetNodeLeadDistance: `navigator.h:182` declares the method and no file defines it | auto ruled by pattern | `Cvar_FreeString`, `rulings.py`, and the form of `skeleton.py:1440` to `:1443` | landed: the rows, the marker of `cvar.swift`, and the marker of `CNavigator.swift`. The CleanTextPool marker was already in the file (ledger 13, R5) | W1, W2, W3 |
| G6, BYTE_STORAGE_LOCALS | `("checksums", "CM_Checksum")` goes to Com_BlockChecksum at `cm_load.cpp:558`. `("info", "FractionBelowLevel")` goes to CM_CircularIterate at `cm_terrain.cpp:1401` | auto ruled by pattern | `"digest"` and `("info", "FlattenArea")`, `rulings.py:606` and `:727` | landed, with the forwards `checksums_CM_Checksum` in `cm_load.swift` and `info_FractionBelowLevel` in `cm_terrain.swift` | W2 |
| G6, `comp` of MC_Compress | Not applied. `char comp[MC_COMP_BYTES*2]` is a `char` local, and the storage rule gives a `char` element an `UnsafeMutableRawPointer`, which a body cannot use. No row is needed: the default CharBuf local writes typed words through `withMutableSlots { $0[int: ...] }`, the form of `CNode.swift:337` to `:342` | none | `CNode.Save` | open, no row needed | W4 needs nothing more |
| G6, `v` of CM_DrawDebugSurface | Not applied. The function declares two locals named `v`, `vec3_t v[3]` at `cm_patch.cpp:1772` and `vec3_t v[4]` at `:1786`, and the storage rule keys one local by name. Candidates: A, one storage of four vectors for both scopes, the form of `seq` that serves two functions; B, no storage, because N-CLOSURE below passes `v` as a `Slots<vec3_t>` and the body can hold a local Slots | none | `seq`, `rulings.py:605` | open | R2 |
| G7, PARAMS `table` | `("CM_CarveBezierCurve", "ctls")` and `("CarveBezierCurve", "ctlPoints")`: Raven multiplies the caller's points in place at `cm_terrain.cpp:1269` and `:1270`. `("ProcessAutomapSymbols", "symbols")`: the body reads `count` records | auto ruled by pattern | `("BotImport_DebugPolygonCreate", "points")`, `rulings.py:1354` | landed, with the hand signatures in `cm_terrain.swift`, `CCMLandScape.swift`, and `CRMManager.swift`. The two old AI lines that named `vec3_array` are gone, because the Slots is Raven's form | W2, W3 |
| G8, PARAMS `("CM_BoxBrushes", "boxList")` as `pointer_table` | Raven stores the table into `ll.list` at `cm_test.cpp:204` | auto ruled by pattern | `("trap_Bot_UpdateWaypoints", "wps")`, `rulings.py:1197` | landed, with the hand signature | R2 (with N-LEAFLIST) |
| G9, PARAMS `bytes` on the save data | `AppendToSaveGame`, `ReadFromSaveGame` (`Q3_Interface.cpp:695`, `:701`), and the table fields `I_WriteSaveData` and `I_ReadSaveData`, which the ICARUS save functions call at `Instance.cpp:316` to `:612` | auto ruled by pattern | `("FS_Write", "buffer")` and `("botlib_import_t.FS_Write", "buffer")` | landed, with the hand signatures and the two fields of `interface_export_t.swift` | W6 |
| G10, PARAMS `("WriteMember", "m_fileHandle")` as `opaque` | The owner key of a method is its bare name: `skeleton.py:383` passes `fn.name`, the cursor spelling, `table.py:1632` passes `fn.spelling`, and `table.py:2036` reads the same pair. The BYTE_STORAGE_LOCALS key `("info", "FlattenArea")` is the precedent of a bare method key | auto ruled by pattern | `("WriteIndent", "fp")`, `rulings.py:1464` | landed, with the hand signature `WriteMember(_ m_fileHandle: OpaquePointer?) -> Int32` | W6 |
| G11, PARAMS `bytes` | `("CRC_ContinueProcessString", "data")` reads `length` bytes. `("LoadTGA", "pic")` sets `*pic` to a byte buffer, and the `void **` branch of `spelling.py` now also takes a `byte **` | auto ruled by pattern | `("Com_BlockChecksum", "buffer")` and `("RE_RegisterModels_GetDiskFile", "ppvBuffer")` | landed, with the hand signatures | W3, W4 |
| G12, PARAMS `("ParseOrigin", "flattenHeight")` | No row. The rule of a non-const `int *` with no NULL caller, `spelling.py:596` to `:603`, already gives `inout Int32`, and the kind `out_scalar` of a row is defined for a `char *`. The one caller passes `&flattenHeight` (`RM_Mission.cpp:925`) | auto ruled by pattern | `spelling.py:596` to `:603` | landed as the hand signature `(_ originGroup: CGPGroup?, _ origin: inout vec3_t, _ lookat: inout vec3_t, _ flattenHeight: inout Int32) -> Bool` | W3 |
| G13, PARAMS `mat` of MC_Compress and MC_UnCompress | The `matrix` of an `mdxaBone_t` | auto ruled by pattern | `("MC_UnCompressQuat", "mat")`, `rulings.py:1485` | landed | W4 |
| G14, PARAMS `("ParseVector", "v")` as `vec3_mut` | Every caller passes a `vec3_t` (`tr_shader.cpp:1604`, `:1773`, `:1774`, `:2398`, `:2473`). The ported body is unchanged | auto ruled by pattern | `("CM_ParseVector", "v")`, `rulings.py:1384` | landed | W5 |
| G15, FIELDS `("textureBundle_t", "tcGenVectors")` as `vectors` | ParseStage stores a block of two vectors at `tr_shader.cpp:1772`, and ComputeTexCoords indexes it at `tr_shade.cpp:1858` | auto ruled by pattern | `("aas_t", "vertexes")` | landed | W5 |
| G16, HOST_ROOTS and ded_types.h | `orientation_t` (CJKAShared), `refexport_t` (CJKAMP_Ded), and `TGAHeader_t` with a `#pragma pack(1)` copy in `ded_types.h`. The static `re` of GetRefAPI (`tr_init.cpp:1460`) takes the BYTE_STORAGE_LOCALS row `("re", "GetRefAPI")`. REF_API_VERSION was already a re-export | auto ruled by pattern | GAME_ROOTS `orientation_t`; `botlib_export_t`; `StaticZeroMem_t`; `("nullSym", "VM_ValueToFunctionSymbol")` | landed: the views Refexport and TGAHeader, the forward `re_GetRefAPI`, the thunk enum `RefexportThunks` that the skeleton prints, and the hand signatures of R_LerpTag, LoadTGA, and GetRefAPI | W4 |
| G17, HAND_VARS `"RSStorage": "[CRenderableSurface]"` | Raven holds 2048 records by value at `tr_ghoul2.cpp:866` | auto ruled by pattern | `"gSequencers"`, `"ragBoneData"` | landed: the forward in `tr_ghoul2.swift` and the property of `EngineWorld.swift` with 2048 instances | W4 |
| G18, RETURNS `"VM_VM2C": "opaque"` | Raven returns `(void *)p` at `vm.cpp:38` | auto ruled by pattern | `Sys_GetBotAIAPI`, `rulings.py:1039` | landed, with the hand signature | W2 |
| G19, PARAMS `text` on `botlib_export_t.BotLibVarSet` | Export_BotLibVarSet (`be_interface.cpp:202`) only reads both texts. The BOTLIB_LIBVAR_SET arm of `sv_game.swift:1040` compiles unchanged, because `args.VMA(_:)` has a String overload | auto ruled by pattern | `("botlib_import_t.BotClientCommand", "command")`, `rulings.py:1481` | landed | R2 (part of BotDrawDebugPolygons) |
| G20, HAND_MACROS `PATHSEPERATOR_STR` | Raven picks the text by a platform `#if` at `l_precomp.h:20` to `:24` | auto ruled by pattern | `__DATE__`, and `PATH_SEP` of `FileBackend.swift` | landed: the row and the hand constant beside PATH_SEP | R3 (PC_SetIncludePath) |
| G21, DEAD | Every DEAD row of the dedicated host goes out, because rule 20 now gives a function with no caller its real body. The row of `CG_ParticleExplosion` stays, because it is the cgame stub of row R10 of ledger 13 and the cgame snapshot must not change. The comments of `rulings.py` and `bodies.py` state the rule as it is now | auto ruled by the user's rule 20 of 2026-11-10 | `docs/porting-rules.md:45` | landed | all the dead stubs below |
| G22, PARAMS kind `string_slots` | A `char *x[]` table whose slots can hold NULL is the caller's `Slots<String?>`, the type of `Aas.configstrings`, through a `spelling.py` branch before the `string_slice` default, with the rows of AAS_StringFromIndex, AAS_IndexFromString, and AAS_UpdateStringIndexes and the test `tests/test_string_slots.py`. The game and cgame snapshots stay equal | auto ruled by the coordinator, single file | `pointer_table`, `Slots(strings:)` | landed, with the three hand signatures in `be_aas_main.swift` | R3 (N-STRSLOTS) |

The text of each removed DEAD row, for the one-line note of the body:

| Function | Reason |
| --- | --- |
| CM_DrawDebugSurface | The renderer's R_DebugGraphics (`tr_main.cpp:1583`) is the one caller, and the dedicated build never draws |
| LoadTGA | Its two callers in `tr_image.cpp:2252` and `:2295` stand under `#ifndef DEDICATED`, so no caller builds in the dedicated host |
| GetRefAPI | The client's `cl_main.cpp:2483` is the one caller, and the dedicated host does not link it |
| bInShadowRange | R_AddGhoulSurfaces (`tr_ghoul2.cpp:3384`) is the one caller, under `#ifndef DEDICATED` |
| CM_BoxBrushes | Raven calls this function from no file of either tree |
| CM_StoreBrushes | CM_BoxBrushes is the one function that stores it, and no file of either tree calls CM_BoxBrushes |
| R_LerpTag | GetRefAPI is the one function that stores it (`tr_init.cpp:1488`), and the dedicated host does not link the client that calls GetRefAPI |
| G2_SaveGhoul2Models | G2API_SaveGhoul2Models (`G2_API.cpp:2472`) is the one caller, and no file of the MP tree calls it |
| G2_LoadGhoul2Model | G2API_LoadGhoul2Models (`G2_API.cpp:2477`) is the one caller, and no file of the MP tree calls it |
| CM_Checksum | Raven calls this function from no file of either tree |
| BotDrawDebugPolygons | CM_DrawDebugSurface (`cm_patch.cpp:1674`) is the one caller, and the dedicated build never draws |
| WriteIndent, WriteFloat | WriteStructWithIndent is the one live caller, its one caller WriteStructure stands only under DEBUG_AI_WEAP, and the calls of `be_ai_weight.cpp:433` to `:525` stand under `#if 0` |
| ProcessAutomapSymbols | Its body (`RM_Manager.cpp:444` to `:473`) and its two callers (`RM_Mission.cpp:1508`, `:1512`) stand under `#ifndef DEDICATED` |
| CM_TerrainPatchIterate | The callers are the renderer's `tr_terrain.cpp:923` and RM_CreateRandomModels (`RM_Terrain.cpp:493`), and only `cl_cgame.cpp:1707` calls the second |

The hand notes of the adopted stubs still state the old form of rule 20, for example "so it keeps its marker". The body of each function replaces its note.

## The hand items

| Item | Verdict | Authority | Precedent | Status | Unblocks |
| --- | --- | --- | --- | --- | --- |
| H-E2, `%02d` | Already on the branch: row R6 of ledger 13, `84c76b1f` | the earlier ruling | `Format.swift` | landed earlier | W3 (Log_WriteTimeStamped) |
| H-FPRINTF, `FileBackend.fprintf` | Not added. The form of `l_log.swift:75` to `:77` and of the S3 dump functions covers the writers of `l_struct.cpp`: `JKAShared.format` into a CharBuf, then `FileBackend.fwrite`, under the same AI line. Raven tests `fprintf(...) < 0` at `l_struct.cpp:313` to `:435`. The body tests the short count of the write, `fwrite(...) < strlen(text)`, because a stream error gives both | auto ruled by pattern | `l_log.swift:75` to `:77`, `be_ai_chat.swift:473` | landed, no helper | W3 (WriteIndent, WriteFloat, WriteStructWithIndent, WriteStructure) |
| H-RMG | `MAX_RANDOM_CHOICES` (`RM_Mission.h:10`) and `SIDE_NONE`, `SIDE_BLUE`, `SIDE_RED` (`cm_terrainmap.h:63` to `:65`) in `CRMMission.swift`. The noise code of `cm_randomterrain.cpp:11` to `:89` in `CRandomTerrain.swift`: NOISE_SIZE, NOISE_MASK, the two tables as file-scope `let`s of zeros under AI lines (only CM_NoiseInit under `#if 0` writes them), and GetNoiseValue and CM_NoiseGet4f with the VAL, INDEX, and LERP macros expanded at the sites | auto ruled by pattern | `CRMManager.swift:7`; `neighbor_x` of `CRMPathManager.swift:26`; the expanded LERP of `CCMLandScape.swift:445` | landed | W3 (ParseRandom, Generate), part of R1c |
| H-VMLOG | The static locals `callnum` and `f` of VM_LogSyscalls (`vm.cpp:935`, `:936`) as properties of `EngineWorld.swift` with forwards in `vm.swift`. No `Slots<Int32>` twin of `offset(of:)`: the existing `Slots.bytes` (`Slots.swift:193`) and `Slots<byte>.offset(of:)` (`MiniHeapViews.swift:10`) give `args - (int *)currentVM->dataBase` as `dataBase.offset(of: args.bytes) / Int32(Int32.byteCount)` under one AI line | auto ruled by pattern | the static-local form of `docs/transcription.md:480`, `lastErrorTime` of `common.swift` | landed | W2 (VM_LogSyscalls) |
| NOT_PORTED CleanTextPool | The row in `rulings.py`, the reason of the Swift line | auto ruled by pattern | ledger 13 R5 | landed | W1 |
| Review, `G2_ProcessSurfaceBolt2` | `baryCentricK` is `Float(1.0 - Double(I + J))`, the form of G2_ProcessSurfaceBolt, Raven's `tr_ghoul2.cpp:3119` | auto ruled by pattern | `docs/transcription.md:633` | landed | none |
| Review, `G2_Get_Bone_Name` | The note names all three calls: `G2_bones.cpp:2625` and `:3851` under `_DEBUG_BONE_NAMES`, and `:3964` in the `#ifndef DEDICATED` arm of G2_BoneSnap, whose dedicated arm returns at `:3954` | auto ruled by proof | `G2_bones.cpp:3951` to `:3964` | landed | none |

## The new-form rows for the body wave

No code of this batch writes these rows. The body wave writes them. The proofs are in `notes/2026-11-10/rows-14-new.md` of the main tree.

| Row | Verdict | Authority | Deciding source |
| --- | --- | --- | --- |
| N-ROFFCLIENT | The client arms of `ApplyROFF` and `ClearLerp` return false, with a rule 19 Port-note | auto ruled by proof, single-site form | `RoffSystem.cpp:833` to `:848` and `:979` to `:991`, the "bad stuff" exit of `:851` to `:854`, rule 19 |
| N-STRSLOTS | Row G22 above | auto ruled by proof, single-site form | `be_aas_main.cpp:68`, `:94`, `:131`; `Aas.configstrings` |
| N-CLOSURE | The `drawPoly` closure takes `Slots<vec3_t>`, with hand signatures in `sv_bot.swift` and `cm_patch.swift` and one AI line at each | auto ruled by proof, single-site form | the `CM_CircularIterate` form, `cm_terrain.swift:22` |
| N-GP2, group part | `weak var mInOrderNext` and `mInOrderPrevious` on `CGPGroup`, in the `mNext` form, for `GPG_GetInOrderNext` and `GPG_GetInOrderPrevious` | auto ruled by proof, single-site form | `GenericParser2.cpp:596` to `:606`; `mNext`, `GenericParser2.swift:310`, `:462` |
| N-USERDATA | `TerrainPatchIterate` and `CM_TerrainPatchIterate` drop `userdata`, and the closure `((CCMPatch?) -> Void)?` captures the value, with AI lines. This is the first such form in the port | auto ruled by proof, single-site form | `cm_terrain.cpp:997`, `:1628`; the two referent types of `tr_terrain.cpp:923` and `RM_Terrain.cpp:493` |
| N-LEAFLIST | A hand accessor `LeafList.listBrushes: Slots<Cbrush?>?` | auto ruled by proof, single-site form | `slotAddress` of `NodeSlots.swift:8`, `cm_test.cpp:117` |
| N-G2SAVE | Raven's 32-bit offsets into a `Slots<byte>` buffer (band 116, surface 24, bolt 16, bone 744 bytes), hand signatures, and the four basepose pointer fields written as zero with a note | auto ruled by proof, single-site form | `CNode.swift:362` to `:371`, `G2_misc.cpp:1715` to `:1717` |
| N-GORE | A hand signature `-> GoreTextureCoordinates?` with an AI line | auto ruled by proof, single-site form | `G2_misc.cpp:113` to `:116`, the `tr_ghoul2.swift:1545` form |
| N-LOCALTABLE | A local array of labeled tuples with no end row | auto ruled by proof, single-site form | `docs/transcription.md:499` |
| N-X86 | `Sys_FunctionCmp` and `Sys_FunctionCheckSum` return the values of Raven's `unix/unix_main.c:68` to `:79`, and `Sys_GetCPUSpeedOld` and `Sys_GetCPUSpeed` get bodies behind new `SysBackend` members | auto ruled by proof, single-site form | the CPUID precedent of `win_shared.swift:98` |
| N-GP2, value part | `GPV_GetNext`, `GPV_GetInOrderNext`, `GPV_GetInOrderPrevious`, `GPV_GetList`, `GPG_GetPairs`, and `GPG_GetInOrderPairs` are "Not ported" in the CleanTextPool form, with the reason "C3 makes the value list an Array, so the chain does not exist." Rule 20 yields to ruling C3 for these six. The six NOT_PORTED rows landed in `rulings.py` in this batch, and the skeleton now prints the markers. The six stubs of the adopted `GenericParser2.swift` still wait for the markers | the user's typed word "ratified", 2026-11-10 | ruling C3, `notes/2026-11-03/dedicated-cxx-docket.md:113` |

## The body sets

All six waiting sets of section 4 of the docket are unblocked in full: W1, W2, W3, W4, W5, and W6. Two rows of the docket closed with no change, G3 and the `comp` key of G6, and the hand item H-FPRINTF closed with the existing form, so none of them blocks a set.

## The timing

Each line is one step, in seconds. One sequence run, all steps exit 0. No other Swift process ran.

| Step | Run 1 |
| --- | --- |
| extract, 9 units | 71 |
| merge | 1 |
| tables | 0 |
| check | 4 |
| reexport | 77 |
| views-game | 63 |
| views-cgame | 43 |
| views-ded | 50 |
| skeleton-game | 24 |
| skeleton-cgame | 15 |
| skeleton-ded | 72 |
| manifest-game | 24 |
| manifest-cgame | 15 |
| manifest-ded | 25 |
| traps-game | 3 |
| traps-cgame | 2 |
| channel | 3 |
| sum of steps | 492 |

| Gate step | Seconds | Exit |
| --- | --- | --- |
| debug build | 97 | 0 |
| snapshot check mp-game | 140 | 0 |
| snapshot check mp-cgame | 61 | 0 |
| snapshot check mp-engine-ded | 67 | 1 |
| swift test | 39 | 0 |
| tool tests | 2 | 0 |
| release build | 100 | 0 |
| referee, with the module build | 100 | 0 |

## The gate

- The sequence, run 1: every step exits 0. The debug build, run 1: exit 0, so no fix round was necessary. No generator run touched an adopted file: the run changed only the generated views and storage of `JKAMP_Ded` and wrote the two new views.
- `swift build -c release -j 6 --product jampded`: exit 0.
- `swift test --no-parallel -j 6`: 161 of 161 pass.
- The tool tests: 102 run, OK, 15 skipped.
- `snapshot.py --check`: mp-game, no difference. mp-cgame, no difference.
- mp-engine-ded against the cache: 72 files differ. The cache predates the 109 bodies of `dedicated-integration-14`, so the batch was also checked against a snapshot of the branch base, taken before the first change. Against that base, 56 files differ, and each line belongs to a row of this batch: the signatures of rows G1, G4, G7, G8, G9, G11, G13, G14, G16, G18, and G22 in the skeletons, drafts, and manifests; the NOT_PORTED markers of CleanTextPool, Cvar_Realloc, and the six N-GP2 value routines; the storage forwards of `checksums`, `info`, and `re`; the RSStorage forward; the removed DEAD note lines, and the full drafts of the functions they held (CM_DrawDebugSurface, CM_StoreBrushes, CM_BoxBrushes, CM_Checksum, G2_SaveGhoul2Models, G2_LoadGhoul2Model, BotDrawDebugPolygons, bInShadowRange, LoadTGA, GetRefAPI, R_LerpTag, WriteIndent, WriteFloat, CM_TerrainPatchIterate); the drafts that read a changed signature (the BOTLIB_LIBVAR_SET arm, ParseVector, and one hole fewer in ParseStage); the views BotlibExport, TextureBundle, and the Refexport callback aliases; and line shifts. With the line numbers removed, the other manifest rows are the same.

## The result

`portMissing(` stands 97 times under `Sources/JKAMP_DedLogic`, against 99 at the branch base. The batch removed the stubs of Cvar_Realloc and GetNodeLeadDistance.

The referee replay of `corpus-ffa1.rec`, 2400 frames, through `SCRATCH=/tmp/referee-scratch-b13 FRAMES=2400 tools/host-referee.sh`, with the reference host `/tmp/jka-rulings-13/.build/openjk-nocontract/openjkded.arm64` as host A and the release `jampded` of this branch as host B: green. The `REF READY` lines are equal, each host prints 2400 `REF STEP` lines, the diff is empty, and each host prints `REF REPLAY END` once. First and last steps: `n=1 t=425 ck=3cfa876c` and `n=2400 t=60400 ck=1b1716ec`. Module shasum `34df7ffef2281358a567f2fd8f08335ff867a276`.

## The open items

- G3: no row, because the default rule gives the signature.
- G6 `v` of CM_DrawDebugSurface: two locals of one name, candidates A and B above. It belongs to set R2.
- G6 `comp` of MC_Compress: no row, because the CharBuf local covers it.
- The DEAD row of `CG_ParticleExplosion` stays until its body lands, row R10 of ledger 13.
- The six N-GP2 value stubs of `GenericParser2.swift` wait for their not-ported markers in the body wave.
