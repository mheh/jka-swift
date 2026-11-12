# Review 11: the Ghoul2 and renderer bodies of round g2tr and of batch 10

Tree: master `f292db9` (no `Sources/JKAMP_DedLogic` change in the G2 or tr stems after `919cab4`). Raven: `oracle/codemp/`. Every Swift cite is under `Sources/JKAMP_DedLogic/` unless the cite names another target.

Counts: DEFECT 1, SUSPECT 0, NOTE 2.

## Findings

### 1. DEFECT: G2_Set_Bone_Rag evaluates the bone cache while its caller holds `inout` access to the same `mBlist`, which is a Swift exclusivity trap

- Swift `G2_bones.swift:1076` (in G2_Set_Bone_Rag, a body of this round):
  `G2_GetBoneMatrixLow(ghoul2, bone.boneNumber, scale, bone.originalTrueBoneMatrix, &bone.basepose, &bone.baseposeInv)`
- Raven `ghoul2/G2_bones.cpp:1338`:
  `G2_GetBoneMatrixLow(ghoul2,bone.boneNumber,scale,bone.originalTrueBoneMatrix,bone.basepose,bone.baseposeInv);`

The callers pass the list as `&g2.mBlist` (`G2_bones.swift:3127` in G2_SetBoneIKState, and `:1332` to `:1357` in G2_SetRagDoll). `mBlist` is a stored property of the class `CGhoul2Info` (`CGhoul2Info.swift:13`), so the `inout` argument is a modify access that lasts for the whole call. Inside the call, the chain reads the same property:

1. `tr_ghoul2.swift:442` `boneCache.Eval(boneNum)`.
2. `CBoneCache.swift:250` to `:251`: the touch differs, because G2_SetBoneIKState calls G2_ConstructGhoulSkeleton just before (`G2_bones.swift:3116`) and G2_TransformGhoulBones increments `mCurrentTouch` (`tr_ghoul2.swift:1331`). So `EvalLow` runs, and `CBoneCache.swift:117` calls G2_TransformBone.
3. `tr_ghoul2.swift:816` `var boneList = BC.rootBoneList`.
4. `CBoneCache.swift:70` `get { self.rootBoneListOwner!.mBlist }`, and the owner is the same `g2` (`tr_ghoul2.swift:1345`).

Swift enforces exclusivity on class stored properties at run time in debug and release builds, so step 4 stops the process with "Simultaneous accesses ... modification requires exclusive access". Raven's `blist` is a reference, so the read is legal and sees the list. Reach on the server: `game/w_saber.c:982` calls BG_IK_MoveArm when a client is held (`ps.heldByClient`), and `game/bg_pmove.c:8629` calls `strap_G2API_SetBoneIKState(ghoul2, time, "lhumerus", ...)`, which reaches `G2_bones.swift:3127`. The G2_SetRagDoll calls have the same conflict, but they are dead on the dedicated server: `broadsword` is created only in R_Register (`renderer/tr_init.cpp:1164`), which WinDed never calls, so G2_SetRagDoll returns at `G2_bones.swift:1299`. The defect came in when the fix of the earlier SUSPECT 3 (review-g2-bones) made `rootBoneList` read the owner's live `mBlist`. Proof that is missing: a run of a grab move on a dedicated server.

### 2. NOTE: G2_GetBonePoolIndex reads a 4-byte `int` at a 3-byte stride, a misaligned typed load

- Swift `tr_ghoul2.swift:556` and `:558`:
  `let pIndex = MdxaIndex(pMDXAHeader, byteOffset: pMDXAHeader.ofsFrames + iOffsetToIndex)` / `return pIndex.iIndex & 0x00FFFFFF`
- Raven `renderer/tr_ghoul2.cpp:1152` and `:1154`:
  `mdxaIndex_t *pIndex = (mdxaIndex_t *) ((byte*) pMDXAHeader + pMDXAHeader->ofsFrames + iOffsetToIndex);` / `return pIndex->iIndex & 0x00FFFFFF;`

`iOffsetToIndex` is a multiple of 3 (`mdx_format.h:400` to `:410`), so most reads are not 4-byte aligned. The view reads through `UnsafeMutablePointer<mdxaIndex_t>.pointee` (`JKAMP_Ded/Generated/Views/MdxaIndex.swift:65`), which Swift defines only for aligned memory. x86 and arm64 user mode load misaligned words, so the result is Raven's today. A byte-wise read (or `loadUnaligned`) removes the dependence on the code generator. Every bone transform of the server reaches this line through UnCompressBone.

### 3. NOTE: G2_RagGetAnimMatrix writes the live bone where Raven's reference can dangle

- Swift `tr_ghoul2.swift:755` and `:801`: `let bone = ghoul2.mBlist[bListIndex]` ... `bone.hasAnimFrameMatrix = frame`
- Raven `renderer/tr_ghoul2.cpp:1455` and `:1528`: `boneInfo_t &bone = ghoul2.mBlist[bListIndex];` ... `bone.hasAnimFrameMatrix = frame;`

The recursive call (`tr_ghoul2.swift:768`, Raven `:1470`) can reach G2_Add_Bone, whose `push_back` can reallocate the vector. Raven's `bone` then points into the freed buffer, and the writes at `:1495` and `:1528` miss the live element. The Swift element is a class object, so the writes reach the live bone. Raven is undefined here, and the Swift result is the intended one. The site has no rule 19 Port-note.

## Checks with no finding

- G2_TransformBone: every arm, the twelve-float loops (byte offset `j * 4`, the AI line is true), the static `toMatrix` as a scratch with identity values (the six written floats are the only ones that change, so the AI line is true), the `tbone` static of six records, and the blend and override arms agree with `tr_ghoul2.cpp:1541` to `:2051`.
- UnCompressBone and MC_UnCompressQuat: record size 14 (`mdxaCompQuatBone_t`, `mdx_format.h:119`), the `unsigned short` walk, and every constant agree with `tr_ghoul2.cpp:1158` and `matcomp.c:219` to `:291`.
- G2_GetVertWeights, G2_GetVertBoneIndex, G2_GetVertBoneWeight: `uiNmWeightsAndBoneIndexes` is `UInt32`, so `>> 30` is a logical shift, as in `mdx_format.h:290` to `:322`. The vertex record is 32 bytes.
- G2_ProcessSurfaceBolt2, G2_GetBoltMatrixLow, RootMatrix, G2_ConstructGhoulSkeleton, G2_Sort_Models, G2_ConstructUsedBoneList, G2_TransformGhoulBones: no difference. The shared `modelList` storage is safe, because the nested call from RootMatrix ends before the outer G2_Sort_Models writes it. The last-match loop for `surfInfo` is kept.
- R_TransformEachSurface, G2_TransformSurfaces, G2_TransformModel, G2_TracePolys, G2_RadiusTracePolys, G2_TraceSurfaces, G2_TraceModels, CTraceSurface: no difference. The heap offset of row X8 is never 0 for a live block in G2API_CollisionDetect, because the slot table is the first allocation after ResetHeap.
- G2API_CollisionDetect and G2API_CollisionDetectCache: statement order, the record count loop, and the sort agree. The sort's tie order follows DEC-34, a ruled change.
- G2API_GetBoltMatrix and G2API_GetBoltMatrix_SPMethod: `use` aliases the bolt's `position` view as Raven's pointer does.
- G2API_InitGhoul2Model, G2API_SetRootSurface, G2API_DoesBoneExist, G2API_AttachG2Model, G2API_GetSurfaceName, G2API_GetGLAName, G2API_SkinlessModel, G2_Add_Bolt, all nine G2_surfaces bodies, G2_Find_Bone, G2_Add_Bone, G2_Generate_Matrix, G2_Get_Bone_Anim_Index, G2_Find_Bone_Rag, G2_RagSetState, G2_RagDollSetup, G2_RagDoll, G2_IKSolve: no difference.
- R_LoadMDXM, R_LoadMDXA, ServerLoadMDXM, ServerLoadMDXA, RE_RegisterModels_Malloc, RE_RegisterServerModels_Malloc, RE_RegisterModels_GetDiskFile, RE_RegisterModels_StoreShaderRequest: no difference. The dropped NULL-buffer arm of the two Malloc functions is correct, because CREATE_LIMB_HIERARCHY is not defined.
- `sizeofCBoneCache` (140) matches the 32-bit layout of `tr_ghoul2.cpp:354` to `:388` with the VC7 vector of 16 bytes.

## Functions read

- tr_ghoul2.swift: RemoveBoneCache, EvalBoneCache, G2_GetModA, G2_GetBoneDependents, G2_WasBoneRendered, G2_GetBoneBasepose, G2_RagGetBoneBasePoseMatrixLow, G2_GetBoneMatrixLow, Multiply_3x4Matrix, G2_GetBonePoolIndex, UnCompressBone, G2_TimingModel, G2_RagGetAnimMatrix, G2_TransformBone and its statics, G2_TransformGhoulBones, G2_ConstructUsedBoneList, G2_Sort_Models, G2_FindSurface_BC, G2_GetVertWeights, G2_GetVertBoneIndex, G2_GetVertBoneWeight, G2_ProcessSurfaceBolt2, G2_GetBoltMatrixLow, RootMatrix, G2_NeedsRecalc, G2_ConstructGhoulSkeleton, R_LoadMDXM, R_LoadMDXA.
- matcomp.swift: MC_UnCompressQuat.
- CBoneCache.swift: every member.
- tr_model.swift: RE_RegisterModels_StoreShaderRequest, RE_RegisterModels_GetDiskFile, RE_RegisterModels_Malloc, RE_RegisterServerModels_Malloc, ServerLoadMDXA, ServerLoadMDXM.
- G2_misc.swift: G2_List_Model_Surfaces, G2_List_Model_Bones, G2_GetAnimFileName, G2_DecideTraceLod, R_TransformEachSurface, G2_TransformSurfaces, G2_TransformModel, G2_BuildHitPointST, G2_SegmentTriangleTest, G2_TracePolys, G2_RadiusTracePolys, G2_TraceSurfaces, G2_TraceModels. CTraceSurface.swift: the initializer.
- G2_surfaces.swift: all functions.
- G2_API.swift: G2API_InitGhoul2Model, G2API_SetRootSurface, G2API_DoesBoneExist, G2API_AttachG2Model, G2API_GetSurfaceName, G2API_GetGLAName, G2API_SkinlessModel, G2API_GetBoltMatrix_SPMethod, G2API_GetBoltMatrix, QsortDistance, G2_NeedRetransform, G2API_CollisionDetectCache, G2API_CollisionDetect.
- G2_bolts.swift: G2_Add_Bolt, G2_Add_Bolt_Surf_Num.
- G2_bones.swift: G2_Find_Bone, G2_Add_Bone, G2_Generate_Matrix, G2_Get_Bone_Anim_Index, G2_Find_Bone_Rag, G2_Set_Bone_Rag, G2_RagSetState, G2_RagDollSetup, G2_RagDoll, G2_IKSolve, and G2_SetBoneIKState for the call chain of finding 1.

## Functions not read

- G2_bones.swift: G2_SetRagDoll after `:1357`, G2_RagDollCurrentPosition, G2_RagDollSettlePositionNumeroTrois, G2_RagDollSolve. They are on the ragdoll path, which `broadsword` keeps dead on WinDed.
- tr_model.swift: R_LoadMD3 (batch 10) was read in Swift only, not against `tr_model.cpp:1427`. No WinDed path reaches it.
- The helpers that the bodies call: the `qsort` overload of `JKAMP_Ded/CommonViews.swift:163`, `MiniHeapViews.swift` (`offset(of:)`, `floats(at:)`), `TextCursor`, `Slots`. They were taken as their doc comments state.
- The ICARUS, navigator, ROFF, and GenericParser2 bodies of round g2tr, and the batch-10 bodies outside the G2 and tr stems. They are outside the scope of this brief.

## State of the earlier reviews' findings

review-g2-api.md:
1. G2_Add_Bolt_Surf_Num negative surface: fixed, `G2_bolts.swift:63` with an AI line.
2. Index functions trap on -1: fixed, `G2_bones.swift:517`, `:597`, `:671`, `:936`, `:968`.
3. G2API_RagEffectorGoal NULL `pos`: fixed, `G2_API.swift:995` and `:1006` to `:1010`.
4. RULE `&+=` on `mRefCount`: fixed, `G2_API.swift:1572` is `+= 1`.
5. RULE leak tracker element 0: fixed, `G2_API.swift:162` to `:164` and `:191` to `:193`, with Port-notes.

review-g2-bones.md:
1. Same as review-g2-api 2: fixed.
2. SUSPECT `Int32(...)` of NaN or infinity: partly fixed. The start time uses `truncateToInt` under a Port-note (`G2_bones.swift:768`). Still open: `G2_bones.swift:699` `Int32(floor(currentFrame))` and `:702` `Int32(currentFrame + 1)` (Raven `G2_bones.cpp:678`, `:683`).
3. SUSPECT `rootBoneList` copy: fixed, `CBoneCache.swift:67` to `:72` reads the owner's live list. The fix opens finding 1 above.

review-tr.md:
1. RE_RegisterIndividualSkin short name: fixed, `tr_image.swift:337` to `:338`, TextCursor with a Port-note.
2. RE_RegisterSkin short name: fixed, `tr_image.swift:414` to `:415`.
3. M_PI type: fixed for Lanczos3, `tr_image.swift:66` to `:68` uses the float `M_PI` of q_shared.h:548.
4. R_RemapShader NULL `timeOffset`: fixed, `tr_shader.swift:365` and `:408` to `:409`.
5. RULE `let` globals: still open, `tr_backend.swift:17`, `:21`, `:25`. No behavior effect on WinDed.
