# The body round g2tr of the third wave

This record holds the body round of the Ghoul2, renderer, ICARUS, navigator, ROFF, and GenericParser2 stems of the dedicated host, on the branch `ded-wave3-g2tr`. Three transcriptors filled the bodies, each in its own files, and the agent g2tr built and fixed. Every Raven cite is under `oracle/codemp/`, and every Swift cite is under `Sources/JKAMP_DedLogic/`.

## The counts

The column "before" is the `portMissing(` count of the file on master `6f3abc1`, and "after" is the count on the branch. A filled body with one hole under a Port-note counts as one in "after".

| File | Before | After |
| --- | --- | --- |
| G2_API.swift | 8 | 2 |
| G2_bones.swift | 17 | 3 |
| G2_bolts.swift | 1 | 0 |
| G2_misc.swift | 14 | 9 |
| G2_surfaces.swift | 9 | 0 |
| CBoneCache.swift | 3 | 2 |
| CRenderableSurface.swift | 2 | 2 |
| tr_ghoul2.swift | 29 | 19 |
| tr_shader.swift | 7 | 7 |
| tr_model.swift | 2 | 2 |
| tr_init.swift | 1 | 1 |
| tr_image.swift | 1 | 1 |
| GenericParser2.swift | 27 | 27 |
| CTaskManager.swift | 28 | 3 |
| CSequencer.swift | 20 | 1 |
| CBlockMember.swift | 12 | 1 |
| ICARUS_Instance.swift | 9 | 8 |
| CBlockStream.swift | 4 | 4 |
| CPriorityQueue.swift | 3 | 3 |
| CROFFSystem.swift | 3 | 3 |
| Q3_Interface.swift | 2 | 0 |
| GameInterface.swift | 2 | 1 |
| CBlock.swift | 1 | 0 |
| CSequence.swift | 1 | 1 |
| CNavigator.swift | 1 | 1 |
| NodeTotalGreater.swift | 1 | 0 |
| Total | 208 | 101 |

## The bodies filled

- G2_bones.swift: G2_Find_Bone, G2_Add_Bone, G2_Generate_Matrix, G2_Find_Bone_Rag, G2_Set_Bone_Rag, G2_Get_Bone_Anim_Index, G2_SetRagDoll, G2_RagSetState, G2_RagDollSetup, G2_RagDoll, G2_RagDollCurrentPosition, G2_RagDollSettlePositionNumeroTrois, G2_RagDollSolve, G2_IKSolve.
- G2_API.swift: G2API_SetRootSurface, G2API_DoesBoneExist, G2API_AttachG2Model, G2API_GetSurfaceName, G2API_GetGLAName, G2API_SkinlessModel. G2API_CollisionDetect and G2API_CollisionDetectCache are filled up to the final sort, which keeps a hole (row G3).
- G2_bolts.swift: G2_Add_Bolt.
- G2_misc.swift: G2_List_Model_Surfaces, G2_List_Model_Bones, G2_TransformSurfaces, G2_TraceSurfaces, G2_BuildHitPointST.
- G2_surfaces.swift: all nine.
- CBoneCache.swift: the initializer.
- tr_ghoul2.swift: EvalBoneCache, G2_GetBoneBasepose, G2_RagGetBoneBasePoseMatrixLow, G2_GetBoneMatrixLow, G2_TimingModel, G2_ConstructUsedBoneList, G2_FindSurface_BC, G2_GetBoltMatrixLow, RootMatrix, G2_ConstructGhoulSkeleton.
- CTaskManager.swift: GetFloat, GetVector, Get, WaitSignal, Print, Sound, Rotate, Remove, Camera, Move, Kill, Set, Use, DeclareVariable, FreeVariable, Signal, Play, and the eight I_DPrintf holes. Go keeps one hole (row T1).
- CSequencer.swift: Init, ParseRun, ParseLoop, ParseAffect, ParseTask, EvaluateConditional, CheckIf, CheckLoop, CheckAffect, CheckDo, and the nine debug print holes. CheckRun keeps one hole (row T1).
- CBlockMember.swift: Free, GetInfo, the three SetData overloads, ReadMember, Duplicate, both WriteData, both WriteDataPointer, and `deinit`, which is Raven's destructor of `BlockStream.cpp:33`.
- CBlock.swift: GetMemberData. ICARUS_Instance.swift: Create. Q3_Interface.swift: Q3_SetVar and Interface_Init. GameInterface.swift: ICARUS_Init, and ICARUS_InterrogateScript with one hole (row S1). NodeTotalGreater.swift: the operator.

## The stubs left

- Rule 20, dead in the dedicated build or with no caller: G2_Animate_Bone_List (three arguments), G2_SetRagDollBullet, G2_Get_Bone_Name, CBoneCache.SmoothLow (its one caller EvalRender is under `G2EVALRENDER`, `#if 0`, or `_XBOX`, `tr_ghoul2.cpp:3033`, `:4272`, `:559`), CBoneCache.SetRenderMatrix, G2_GetGoreRecord, G2_SaveGhoul2Models, G2_LoadGhoul2Model, G2_LerpAngles, the two CRenderableSurface methods (callers under `#ifndef DEDICATED` or in the dead AllocRS), G2_GetBoneNameFromSkel, G2_SetUpBolts, G2_ProcessGeneratedSurfaceBolts, G2_GetParentBoneMatrixLow, ProcessModelBoltSurfaces, G2_ProcessSurfaceBolt, G2_Find_Bone_ByNum, AllocRS, R_GCullModel, R_GComputeFogNum, G2_ComputeLOD, the two quaternion functions, bInShadowRange, the seven tr_shader stubs, R_LerpTag, GetRefAPI, LoadTGA, all 27 GenericParser2 stubs (no file outside `GenericParser2.cpp` calls the GP_, GPG_, or GPV_ API), CTaskManager.SaveCommand and CSequence.SaveCommand (callers under `#if 0`), CBlockMember.WriteMember and CBlockStream.Create and WriteBlock (callers only in `Interpreter.cpp`, which WinDed does not link), CBlockStream.GetUnsignedInteger and GetLong, the eight ICARUS_Instance save and load methods (no caller in `oracle/codemp`), CNavigator.GetNodeLeadDistance (`navigator.h:182` has no body and no caller).
- Blocked by a row: G2_GetBonePoolIndex (R2), UnCompressBone, G2_RagGetAnimMatrix, and G2_TransformBone (R3, R4), G2_ProcessSurfaceBolt2 (R5), R_LoadMD3 (R6), R_TransformEachSurface, G2_GorePolys, G2_TracePolys, G2_RadiusTracePolys (G4), G2_TraceModels (G5), CTaskManager.Wait (T1), CPriorityQueue Pop, Push, and Update (H1), the three CROFFSystem holes (SV3, and the client arms that WinDed does not link, `sv_game.cpp:725`).

## The build fix

G2_RagDollSetup, G2_RagDollSolve, and G2_IKSolve read the locals `i` and `k` inside `MdxaBone.scratch` and `Trace.scratch` closures, and Swift refuses a closure capture of a local with no initial value. The four declarations take `= 0` at `G2_bones.swift:2058`, `:2060`, `:2419`, and `:2726`. Raven writes no initial value, and every path stores the local before the first read.

## The rows

- G1, hand signature changes that the skeleton does not write. Each follows an existing form, and each needs a rulings row so the generator writes the same signature:
  - G2_RagSetState (`G2_bones.cpp:2152`, `bool &resetOrigin`): `inout Bool` at `G2_bones.swift:1491`, the form of `CTaskManager.swift:660`.
  - G2_BuildHitPointST (`G2_misc.cpp:677`): four `inout Float` at `G2_misc.swift:471`.
  - EvalBoneCache (`tr_ghoul2.cpp:585`, a `const mdxaBone_t &` return): returns `MdxaBone` at `tr_ghoul2.swift:277`, the form of `CBoneCache.Eval` (`CBoneCache.swift:155`).
  - G2_GetBoneBasepose and G2_GetBoneMatrixLow (`tr_ghoul2.cpp:656`, `:727`, `mdxaBone_t *&`): `inout MdxaBone?` at `tr_ghoul2.swift:347` and `:399`, the form of `boneInfo_t.basepose`.
  - G2_FindSurface_BC (`tr_ghoul2.cpp:2952`, a `void *` return): returns `MdxmSurface?` at `tr_ghoul2.swift:1039`. Candidate: the RETURNS row of G2_FindSurface, G2A5.
  - The `surface` parameter of G2_ProcessSurfaceBolt2 (`tr_ghoul2.swift:1062`): `MdxmSurface?`, because G2_GetBoltMatrixLow passes NULL (`tr_ghoul2.cpp:3316` to `:3324`). Candidate: a NULLABLE row.
  - G2_TimingModel: the signature of the batch-9 table store. The adopted file kept the old marker.
  - Interface_Init (`Q3_Interface.cpp:956`): `(_ pe: interface_export_t?)` at `Q3_Interface.swift:823`, the form of `ICARUS_Instance.Create`. The skeleton writes `() -> Never`. Candidate: a PARAMS or CXX_CLASSES row for `interface_export_t *`.
- G2, `ERagState` (`G2_bones.cpp:1233`) has no Swift names. `G2_bones.swift:151` holds three file-private lets with Raven's values. Candidate: the extract and reexport emit the enum.
- G3, no `qsort` form takes a table of records. Raven: `G2_API.cpp:2117` and `:2170`. Swift: holes at `G2_API.swift:1442` and `:1488`. Candidate: a `qsort` overload on `Slots<View>` beside `qsort` of `JKAMP_BG/bg_lib.swift:61`. Effect: G2API_CollisionDetect traps at the sort, and the saber trace of a dedicated server reaches it.
- G4, Raven stores a pointer in an `int`. `TransformedVertsArray[i] = (int)TransformedVerts` (`G2_misc.cpp:416`), read back as `float *` by the trace functions. Swift: `G2_misc.swift:325`, `:567`, `:575`, `:583`. R_TransformEachSurface also needs G2_GetVertWeights, G2_GetVertBoneIndex, and G2_GetVertBoneWeight (`mdx_format.h:290` to `:322`). Candidates: a MiniHeap byte offset in the slot, or a `Slots<Slots<Float>?>` table. No precedent exists for either.
- G5, `CTraceSurface.collRecMap` is one record (`CTraceSurface.swift:17`, `:45`), but Raven's field is a `CollisionRecord_t *` table (`G2_misc.cpp:190`). Candidate: `Slots<CollisionRecord>?`, the PARAMS kind `table` of G2_TraceModels.
- R2, `mdxaIndex_t` (`mdx_format.h:410`, read at `tr_ghoul2.cpp:1152`) has no view. Candidate: a HOST_ROOTS row read through `HandleView.init(_:byteOffset:)`.
- R3, UnCompressBone (`tr_ghoul2.cpp:1158`): the stub takes `mat: [[Float]]` by value, but every caller passes the `matrix` of an `mdxaBone_t` that the body writes (`tr_ghoul2.cpp:1464`, `:1707`, `:1708`, `:1723`, `:1747`, `:1748`). MC_UnCompressQuat of `renderer/matcomp.c` has no Swift stub, and `mdxaCompQuatBone_t` (`mdx_format.h:119`) has no view. Candidates: take the `MdxaBone` view, add the matcomp unit, a HOST_ROOTS row. Effect: this is the next stop on the bone path of the server, through CBoneCache.EvalLow.
- R4, the static locals of G2_TransformBone (`tr_ghoul2.cpp:1544` to `:1552`) have no storage. Candidate: the static-local form of transcription.md.
- R5, G2_ProcessSurfaceBolt2: the three static inline functions of `mdx_format.h:290` to `:322` have no Swift home, and `mdxmTriangle_t` (`mdx_format.h:250`) has no view. Candidates: the hand-function form of `BG_GiveMeVectorFromMatrix`, a HOST_ROOTS row.
- R6, `md3Surface_t` has no view, which blocks R_LoadMD3. Candidate: HOST_ROOTS, the form of Md3Frame and Md3Tag.
- T1, the DWORD time stamp. `CTask.swift:11` keeps `m_timeStamp` as `Int32`, but I_GetTime returns `UInt32` (`interface.h:26`), and the format has no `UInt32` argument (`Format.swift:27` to `:62`). Holes: `TaskManager.cpp:728` (`CTaskManager.swift:632`), the Wait stub (`TaskManager.cpp:1111` to `:1132`, which also needs a Slots over a local float for `SetData`), and `Sequencer.cpp:973` (`CSequencer.swift:979`). Candidates: a `UInt32` time stamp and a `UInt32` format argument, or an `Int32` I_GetTime. Effect: the Go hole traps on the first task of any script.
- S1, the SET_ names of `icarus/Q3_Interface.h:6` to `:255` go only into `JKAMP_Game/Generated/Q3_Interface.swift:9`. They block the switch of `GameInterface.cpp:540` to `:572` (hole at `GameInterface.swift:449`). Candidate: the header joins the host entry list, as rows 4 and 5 of the ninth ledger did. Effect: the hole traps on every text `set` block of a script precache.
- H1, `std::pop_heap` and `std::push_heap` (`navigator.cpp:2737`, `:2757`, `:2771`) have no Swift form. The order of edges of equal cost follows the MSVC algorithm.
- D1, Q3_SetVar writes `_ =` at `Q3_Interface.swift:256` to `:265`, because the Q3_Registers functions lack `@discardableResult`. Row 12 of the ninth ledger puts the attribute on the declarations.
- Rule 19, ParseAffect and CheckAffect print `'%s' : invalid affect() target` with no argument (`Sequencer.cpp:669`, `:1802`). The port passes `"(null)"` under a rule 19 note.

## The forms used

- Text from the bytes of a block member: `var x = CharBuf(member.GetSize())` and `Com_Memcpy(&x, data, x.count)`, the form of `stringed_ingame.swift:717`, with one AI line at each site.
- A block allocation: `Slots<byte>(scalars: ICARUS_Malloc(n), count:)`, the form of `tr_model.swift:89`. The free: `ICARUS_Free(OpaquePointer(m_data!.base))`, the form of `sv_client.swift:732`.

## The gate

- `swift build -j 2`: exit 0, 376 warning lines.
- `swift test --no-parallel -j 2`: exit 0, 150 tests in 9 runs, all pass.
