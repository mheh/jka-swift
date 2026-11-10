# The second G2_bones, G2_misc, and tr_ghoul2 body round

This record holds the second body round of `Sources/JKAMP_DedLogic/G2_bones.swift`, `G2_misc.swift`, and `tr_ghoul2.swift`, and of the hand classes whose methods `G2_bones.cpp`, `G2_misc.cpp`, `tr_ghoul2.cpp`, `G2_gore.h`, and `MiniHeap.h` define: `CBoneCache`, `CGoreSet`, `CMiniHeap`, `CRagDollUpdateParams`, `CTraceSurface`, and `GoreTextureCoordinates`. The tree is the worktree `/tmp/jka-g2-bones-2` on the branch `ded-bodies-g2-bones-2`, off master at 837bc43, the merge of PR 84. The round filled bodies against the signatures that PR 84 gave. It ran no generator, no python tool, no draftcheck, and no snapshot. Two opus agents wrote the bodies, one on G2_bones.swift and one on the other files.

## Counts

| File | `portMissing` before | after |
|---|---|---|
| G2_bones.swift | 55 | 22 |
| G2_misc.swift | 32 | 18 |
| tr_ghoul2.swift | 41 | 34 |
| CBoneCache.swift | 11 | 4 |
| CGoreSet.swift | 1 | 0 |
| CMiniHeap.swift | 3 | 1 |
| CRagDollUpdateParams.swift | 5 | 0 |
| CTraceSurface.swift | 1 | 0 |
| GoreTextureCoordinates.swift | 1 | 0 |
| Total | 150 | 79 |

`grep -c Unsafe` gives 0 on all nine files.

## The bodies

- G2_bones: G2_Remove_Bone_Index, G2_Find_Bone_In_List, G2_Stop_Bone_Index, G2_Remove_Bone, G2_Set_Bone_Angles_Index, G2_Set_Bone_Angles, G2_Set_Bone_Angles_Matrix_Index, G2_Set_Bone_Angles_Matrix, G2_Set_Bone_Anim_Index, G2_Set_Bone_Anim, G2_Get_Bone_Anim_Range, G2_Get_Bone_Anim, G2_Pause_Bone_Anim, G2_IsPaused, G2_Stop_Bone_Anim_Index, G2_Stop_Bone_Anim, G2_Stop_Bone_Angles_Index, G2_Stop_Bone_Angles, G2_Generate_MatrixRag, G2_RagDollMatchPosition, G2_Set_Bone_Anim_No_BS, G2_ResetRagDoll, Rag_Trace, G2_BoneOnGround, G2_ApplyRealBonePhysics, G2_RagGetWorldAnimMatrix, G2_RagGetPelvisLumbarOffsets, G2_BoneSnap, G2_IKReposition, G2_DoIK, G2_Init_Bone_List, G2_RemoveRedundantBoneOverrides, and G2_Get_Bone_Index.
- G2_misc: DestroyGoreTexCoordinates, AllocGoreRecord, ResetGoreTag, FindGoreRecord, DeleteGoreRecord, FindGoreSet, NewGoreSet, DeleteGoreSet, G2_GetAnimFileName, G2_DecideTraceLod, TransformPoint, TransformAndTranslatePoint, Inverse_Matrix, and G2_FreeSaveBuffer.
- tr_ghoul2: the initializer of `HackadelicOnClient`, G2_GetModA, G2_WasBoneRendered, Multiply_3x4Matrix, G2_Sort_Models, G2_NeedsRecalc, and R_AddGhoulSurfaces.
- CBoneCache: EvalLow, Root, EvalUnsmooth, Eval, EvalRender, WasRendered, and GetParent.
- CGoreSet: the deinit. CMiniHeap: ResetHeap and MiniHeapAlloc. CRagDollUpdateParams: the SRagDollEffectorCollision initializer and the four callbacks. CTraceSurface: the initializer. GoreTextureCoordinates: the initializer.

Notes on the forms:

- The storage of ledger 8 closes the first round's notes on G2_RagDollMatchPosition, G2_BoneOnGround, and the gore maps. The round removed those notes.
- Rag_Trace and G2_BoneSnap take the `DEDICATED` arm. R_AddGhoulSurfaces is empty, because Raven's whole body stands under `#ifndef DEDICATED`.
- `blist.resize(n)` is `removeSubrange(n...)`, and `blist.clear()` is `removeAll()`. A `boneInfo_v &blist` bound to `ghoul2.mBlist` is `&ghoul2.mBlist` at each call.
- A copy of an `mdxaBone_t` into a field is `copy(from:)`, and a static `mdxaBone_t` local that each call writes before a read is `MdxaBone.scratch`.
- The gore maps walk their keys in sorted order where Raven walks a `std::map`, under one rule 24 line at each site. G2_FreeSaveBuffer frees nothing under the rule 24 line of row G2B6.
- GoreTextureCoordinates loops to 8 under a rule 24 line, because `MAX_LODS` of `G2_gore.h:9` has no Swift name. Row R10 below holds the gap.

## The stubs that stay

Signature markers (17): G2_RagSetState, G2_InitIK, G2_SetBoneIKState, G2_IKMove, G2_GetGoreRecord, G2_BuildHitPointST, G2_TraceModels, G2_FindSurface, EvalBoneCache, G2_GetBoneBasepose, G2_GetBoneMatrixLow, G2_GetParentBoneMatrixLow, UnCompressBone, G2_TimingModel, G2_FindSurface_BC, R_LoadMDXM, and R_LoadMDXA.

A body that calls a marker function (5, plus the cast-blocked bodies that also do): G2_Get_Bone_Anim_Index (G2_TimingModel), G2_Set_Bone_Rag and G2_RagDollCurrentPosition (G2_GetBoneMatrixLow), G2_RagDollSetup (G2_GetBoneBasepose), and G2_RagDoll (G2_RagSetState).

The byte-offset cast of row R1 (26): G2_Find_Bone, G2_Add_Bone, G2_Generate_Matrix, G2_Find_Bone_Rag, G2_RagDollSettlePositionNumeroTrois, G2_List_Model_Surfaces, G2_List_Model_Bones, R_TransformEachSurface, G2_TransformSurfaces, G2_GorePolys, G2_TracePolys, G2_RadiusTracePolys, G2_TraceSurfaces, G2_GetBoneDependents, G2_GetBoneNameFromSkel, G2_RagGetBoneBasePoseMatrixLow, G2_GetBonePoolIndex, G2_RagGetAnimMatrix, G2_TransformBone, G2_SetUpBolts, G2_ProcessSurfaceBolt, ProcessModelBoltSurfaces, G2_ConstructUsedBoneList, G2_ProcessSurfaceBolt2, CBoneCache::SmoothLow, and the CBoneCache initializer.

The `mdxaBone_t` fields of ledger 8 (1): the CTransformBone initializer.

Dead under rule 20 (15), each with a one-line proof:

- No caller in either tree: G2_SetRagDollBullet, G2_LerpAngles, G2_CreateQuaterion, G2_CreateMatrixFromQuaterion, and G2_ProcessGeneratedSurfaceBolts.
- The three-argument G2_Animate_Bone_List: the one call reaches the overload with `CRagDollUpdateParams *`, at `G2_API.cpp:1450`.
- G2_Get_Bone_Name: its callers stand under `_DEBUG_BONE_NAMES` (`G2_bones.cpp:2576`) and in the `#ifndef DEDICATED` arm of G2_BoneSnap (`:3953`).
- G2_Find_Bone_ByNum: its one call stands inside `#if 0` at `tr_ghoul2.cpp:274`.
- AllocRS: its one call is in RenderSurfaces, under `#ifndef DEDICATED` at `tr_ghoul2.cpp:2520`.
- R_GCullModel, R_GComputeFogNum, G2_ComputeLOD, and bInShadowRange: the one call of each is in R_AddGhoulSurfaces, under `#ifndef DEDICATED` at `tr_ghoul2.cpp:3384`.
- CBoneCache::SetRenderMatrix: its body and both calls stand under `_XBOX`, at `tr_ghoul2.cpp:261` and `:339`.

The rows below hold the rest: G2_RagDollSolve and G2_IKSolve (R2), G2_Set_Bone_Angles_Rag and G2_Set_Bone_Angles_IK (R3 and R4), G2_SetRagDoll (R4), G2_GetBoltMatrixLow, RootMatrix, and G2_ConstructGhoulSkeleton (R3, R8), RemoveBoneCache and G2_TransformGhoulBones (R5), Create_Matrix and G2_GenerateWorldMatrix (R6), G2_TransformModel (R7), G2_SaveGhoul2Models and G2_LoadGhoul2Model (R9), and the CMiniHeap initializer (R11).

## Rows

- Row R1, a view at a byte offset of another view. Question: Raven reads every skeleton, surface, and frame record of the mdx files through a cast at a byte offset, and the view target has no accessor for it, so a body would need `UnsafeMutableRawPointer`. Proof: `ghoul2/G2_bones.cpp:45` and `:46` and `G2_bones.swift:172` (G2_Find_Bone), `renderer/tr_ghoul2.cpp:603` and `tr_ghoul2.swift:283` (G2_GetBoneDependents), `ghoul2/G2_misc.cpp:404` and `G2_misc.swift:274` (R_TransformEachSurface). The 26 stubs above wait on it. Pattern: an initializer in the view target that does the byte step under one rule 24 line, the form of `ZoneHeader(block:)` at `Sources/JKAMP_Ded/ZoneBlocks.swift:19` and of `Slots<View>(_ bytes:count:)` at `Sources/JKAMP_Ded/LumpViews.swift:11`, so `(mdxaSkel_t *)((byte *)h + sizeof(mdxaHeader_t) + o->offsets[i])` reads as one cast with Raven's offset.
- Row R2, the `int *tempDependents` table. Question: G2_GetBoneDependents takes `_ tempDependents: inout Int32`, and Raven fills and steps the table through the pointer. The global `tempDependents` is a `[Int32]` variable. Proof: `renderer/tr_ghoul2.cpp:603`, `:624`, `:627`, and `:633`, `ghoul2/G2_bones.cpp:1219`, `:4112`, and `:4355`, and `tr_ghoul2.swift:283` and `G2_bones.swift:86`. Pattern: a host `int *` list the body fills is `Slots<Int32>`, PARAMS kind `bytes`, the row of `entityList` of SV_AreaEntities (`docs/transcription.md:140`), stepped with `suffix(from:)`, and `tempDependents` becomes a `Slots<Int32>` on EngineStorage, the form of `ragBones`.
- Row R3, the identity matrices. Question: the static local `id` of G2_Set_Bone_Angles_Rag and G2_Set_Bone_Angles_IK and the file-scope `identityMatrix` hold Raven's data and have no storage. Proof: `ghoul2/G2_bones.cpp:1423` and `:4575`, `renderer/tr_ghoul2.cpp:128`, and `G2_bones.swift:764` and `:1253` and `tr_ghoul2.swift:107`. Pattern: an `MdxaBone` record on EngineStorage, the form of `worldMatrix` (`Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift:199`), with Raven's data written once, or C storage by `tables.py` as `PADDING` of `md4.cpp` has it. A static local takes the function name as a suffix (`docs/transcription.md:482`).
- Row R4, NULL for `angleMin` and `angleMax`. Question: Raven defaults both to `0` and tests `if (angleMin&&angleMax)`, and the Swift signature takes a `vec3_t` with no default, so the body cannot test the NULL, and the ten calls of G2_SetRagDoll that leave both out have no form. Proof: `ghoul2/G2_bones.cpp:1356`, `:1357`, `:1411`, `:1981` to `:1994`, `:4543`, `:4544`, and `:4563`, and `G2_bones.swift:764`, `:879`, and `:1253`. Pattern: a read-only vector the NULL sweep reaches is `JKAShared.vec3_t?` with the default `nil` (`docs/transcription.md:125` and `:256`), and the body keeps `angleMin != nil && angleMax != nil`.
- Row R5, `sizeof` of a C++ class. Question: RemoveBoneCache and G2_TransformGhoulBones add `sizeof(*boneCache)` to `g_Ghoul2Allocations`, which Z_Shutdown prints, and the Swift class has no byte size. Proof: `renderer/tr_ghoul2.cpp:572` and `:2114`, and `tr_ghoul2.swift:261` and `:473`. G2_API holds the same text at `ghoul2/G2_API.cpp:559` and `:626`. Pattern: the `Int32(View.byteCount)` form with a hand constant of Raven's 32-bit `sizeof(CBoneCache)`, or a rule 17 ruling that drops the count.
- Row R6, the `angle` of Create_Matrix. Question: the signature gives `const float *angle` as `vec4_t?`, every caller passes a `vec3_t`, and AnglesToAxis takes a `vec3_t`, so Create_Matrix and G2_GenerateWorldMatrix have no form. Proof: `ghoul2/G2_misc.cpp:1630` and `:1680`, `ghoul2/G2_bones.cpp:312`, and `G2_misc.swift:452` and `:487`. Pattern: PARAMS kind `vec3_const`, the row of `p1` of CM_FindPlane (`docs/transcription.md:137`).
- Row R7, `int *TransformedVertsArray`. Question: R_TransformEachSurface and G2_TransformSurfaces take it as `inout Int32`, the field `mTransformedVertsArray` is `Slots<Int32>?`, and G2_TransformModel casts the bytes of MiniHeapAlloc to `int *` and clears `numSurfaces * 4` of them. The gore and trace bodies cast the `int` back to `float *`, which ledger 8 already names. Proof: `ghoul2/G2_misc.cpp:404`, `:518`, `:639`, and `:646`, and `G2_misc.swift:275`, `:283`, and `:291`. Pattern: PARAMS kind `bytes`, which gives `Slots<Int32>`, the row of `entityList`.
- Row R8, the local `int modelList[256]` of G2_ConstructGhoulSkeleton. Question: G2_Sort_Models takes it as `Slots<Int32>`, and the local has no storage. Proof: `renderer/tr_ghoul2.cpp:3579` and `tr_ghoul2.swift:668`. Pattern: `BYTE_STORAGE_LOCALS`, the form of `digest` of Com_BlockChecksum (`docs/transcription.md:529`).
- Row R9, the save and load buffers. Question: G2_SaveGhoul2Models and G2_LoadGhoul2Model copy the bytes of `CGhoul2Info` from `mModelindex` on, and of `surfaceInfo_t`, `boneInfo_t`, and `boltInfo_t`, and the Swift classes have no byte layout. Proof: `ghoul2/G2_misc.cpp:1736`, `:1770`, and `:1866`, and `G2_misc.swift:505` and `:539`. No precedent: the row needs a rule 17 ruling for a writer and a reader in Raven's byte layout, field by field.
- Row R10, the `G2_gore.h` constants and `GoreVerts`. Question: `MAX_LODS` of `G2_gore.h:9` has no Swift name, and `static SVertexTemp GoreVerts[MAX_GORE_VERTS]` has no storage. Proof: `ghoul2/G2_gore.h:9` and `GoreTextureCoordinates.swift:18`, and `ghoul2/G2_misc.cpp:793` and `G2_misc.swift:71`. Pattern: the reexport of a header macro (rule 8), and for `GoreVerts` a copy of `SVertexTemp` in `ded_types.h` with a storage table, the form of `ragEffectors` (row G2B2 of ledger 8).
- Row R11, the heap of CMiniHeap. Question: the initializer calls the C library `malloc`, and the logic target has no allocator for a byte block outside the zone. Proof: `qcommon/MiniHeap.h:22` and `CMiniHeap.swift:24`. Pattern: `ZoneBackend.malloc` of `Sources/JKAMP_Ded/ZoneBlocks.swift`, which gives a block to the logic target under a rule 24 line, with a `Slots<byte>` over it.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0 on the first run. Five warnings in the round's files, each at a line Raven wrote: four dropped results (`G2_bones.swift:632`, `:634`, `:1302`, `tr_ghoul2.swift:645`) and the unused `mod_m` of G2_Set_Bone_Angles (`G2_bones.swift:310`) |
| `swift test --no-parallel -j 2` | exit 0, 147 tests in 9 runs passed, 0 failed |
