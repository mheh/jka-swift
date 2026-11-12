# Review of the second G2_bones body round against Raven

Tree: master at `d6f2dd7`. Files: `Sources/JKAMP_DedLogic/G2_bones.swift`, `G2_misc.swift`, `tr_ghoul2.swift`, `CBoneCache.swift`, `CRagDollUpdateParams.swift`. Raven: `oracle/codemp/ghoul2/G2_bones.cpp`, `G2_misc.cpp`, `G2_gore.h`, `oracle/codemp/renderer/tr_ghoul2.cpp`.

Facts that the review used:

- `boneInfo_t` is a `final class` (`boneInfo_t.swift:10`), and `SBoneCalc`, `CTransformBone`, `CRagDollUpdateParams`, and the `RagEffector` view are reference types. Thus a `let bone = blist[index]` followed by writes writes the element, and no lost write through a copy exists in the five files.
- `Array` takes a C integer index through `Sources/JKAShared/Views/Int32Indexing.swift:38`, which converts to `Int` and keeps the range check. An index of -1 traps.
- `Promotion.swift` gives the mixed `Float`/`Int32` compares. The `Float(...)` and `Double(...)` conversions in the bodies follow `docs/transcription.md:633` to `:644`, so they are not findings.

## Findings, most severe first

### 1. DEFECT: the unsigned `blist.size()` compare became a signed compare, so an index of -1 traps (5 sites)

Raven compares a signed `int index` with the unsigned `blist.size()`. C converts `index` to unsigned, so -1 (or any negative index) is greater than the size, and the function returns `qfalse`. Swift compares `Int32` with `Int` as signed values, so `-1 >= blist.count` is false, the second operand `blist[index]` runs with -1, and the process traps. G2_API passes the game's index without a check (`G2_API.cpp:1059`, `:1247`, `:1293`, `:1346`, `:1369`).

| Function | Swift | Raven |
|---|---|---|
| G2_Set_Bone_Angles_Index | `G2_bones.swift:280` | `G2_bones.cpp:440` |
| G2_Set_Bone_Angles_Matrix_Index | `G2_bones.swift:359` | `G2_bones.cpp:541` |
| G2_Set_Bone_Anim_Index | `G2_bones.swift:432` | `G2_bones.cpp:639` |
| G2_Stop_Bone_Anim_Index | `G2_bones.swift:672` | `G2_bones.cpp:996` |
| G2_Stop_Bone_Angles_Index | `G2_bones.swift:703` | `G2_bones.cpp:1031` |

- Raven: `if ((index >= blist.size()) || (blist[index].boneNumber == -1))`
- Swift: `if (index >= blist.count) || (blist[index].boneNumber == -1) {`

Difference: for a negative index Raven returns false and Swift traps on the array read. The faithful form is a test that also catches a negative index, for example `index < 0 || index >= blist.count`, with an `AI:` line or a Port-note that names the unsigned compare.

### 2. SUSPECT: `Int32(...)` of a NaN or infinite start time traps where Raven stores a value

- Swift `G2_bones.swift:527`: `blist[index].startTime = Int32(Double(currentTime) - ((Double(setFrame - Float(startFrame)) * 50.0) / Double(animSpeed)))`
- Raven `G2_bones.cpp:760`: `blist[index].lastTime = blist[index].startTime = (currentTime - (((setFrame - (float)startFrame) * 50.0)/ animSpeed));`

Difference: with `animSpeed == 0` and `setFrame != -1`, the quotient is infinite or NaN; Raven's conversion is undefined (x86 stores `INT_MIN`), and Swift traps. G2_Pause_Bone_Anim reaches this case when it un-pauses a bone with no animation flags, because G2_Get_Bone_Anim_Index then returns `animSpeed = 0`, `startFrame = 0`, and `currentFrame = 0` (`G2_bones.cpp:895` to `:899`), and G2_Set_Bone_Anim gets `setFrame = 0` (`G2_bones.cpp:954`). Rule 19 asks for one defined behavior and a Port-note at the site, and the site has neither. The same trap class applies to `Int32(floor(currentFrame))` and `Int32(currentFrame + 1)` at `G2_bones.swift:460` and `:463` (Raven `:678` and `:683`) for a NaN frame. The path is not live yet, because G2_Get_Bone_Anim_Index is still a `portMissing` hole.

### 3. SUSPECT: `rootBoneList` holds a copy of the bone list, not a pointer to it

- Swift `CBoneCache.swift:55`: `var rootBoneList: [boneInfo_t]? = nil`, under `// AI: Raven points at the caller's boneInfo_v. The field holds the array, and its elements are the caller's bone objects.`
- Raven `tr_ghoul2.cpp:374`: `boneInfo_v		*rootBoneList;`

Difference: Raven's pointer sees each later add, remove, or resize of `ghoul2.mBlist`, and the Swift field keeps the array as it was at the assignment, so a lazy `Eval` or `EvalLow` after a bone add or remove (for example a `G2API_SetBoneAnim` between G2_TransformGhoulBones and a later bolt query) reads a stale list. The `AI:` line states the array copy, but it does not say that a resize after the assignment is not seen. No body assigns the field yet, because G2_TransformGhoulBones is a hole, so a run cannot show the effect now.

## Functions compared in full

G2_bones.swift: G2_Remove_Bone_Index, G2_Find_Bone_In_List, G2_Stop_Bone_Index, G2_Remove_Bone, G2_Set_Bone_Angles_Index, G2_Set_Bone_Angles, G2_Set_Bone_Angles_Matrix_Index, G2_Set_Bone_Angles_Matrix, G2_Set_Bone_Anim_Index, G2_Set_Bone_Anim, G2_Get_Bone_Anim_Range, G2_Get_Bone_Anim, G2_Pause_Bone_Anim, G2_IsPaused, G2_Stop_Bone_Anim_Index, G2_Stop_Bone_Anim, G2_Stop_Bone_Angles_Index, G2_Stop_Bone_Angles, G2_Generate_MatrixRag, G2_RagDollMatchPosition, G2_Set_Bone_Anim_No_BS, G2_ResetRagDoll, Rag_Trace, G2_BoneOnGround, G2_ApplyRealBonePhysics, G2_RagGetWorldAnimMatrix, G2_RagGetPelvisLumbarOffsets, AngleNormZero, G2_BoneSnap, G2_IKReposition, G2_DoIK, G2_Init_Bone_List, G2_RemoveRedundantBoneOverrides, G2_Get_Bone_Index.

CBoneCache.swift: EvalLow, Root, EvalUnsmooth, Eval, EvalRender, WasRendered, GetParent, and the field list of CBoneCache, CTransformBone, and SBoneCalc.

CRagDollUpdateParams.swift: the SRagDollEffectorCollision initializer, the CRagDollUpdateParams fields, EffectorCollision, RagDollBegin, RagDollSettled, Collision.

G2_misc.swift: DestroyGoreTexCoordinates, AllocGoreRecord, ResetGoreTag, FindGoreRecord, DeleteGoreRecord, FindGoreSet, NewGoreSet, DeleteGoreSet, G2_GetAnimFileName, G2_DecideTraceLod, G2_AreaOfTri, G2_SegmentTriangleTest, TransformPoint, TransformAndTranslatePoint, Inverse_Matrix, G2_FreeSaveBuffer, G2_FindConfigStringSpace, and the initial values of CurrentTag, CurrentTagUpper, CurrentGoreSet, and GoreTouch.

tr_ghoul2.swift: G2Time_ResetTimers, G2Time_ReportTimers, G2_GetModA, G2_WasBoneRendered, Multiply_3x4Matrix (all twelve index expressions), G2_Sort_Models, R_AddGhoulSurfaces, G2_NeedsRecalc.

## Functions not reached

None in the five files: every function with a body was compared. The bodies that each function above calls through a `portMissing` hole (G2_Find_Bone, G2_Add_Bone, G2_Get_Bone_Anim_Index, G2_RagGetAnimMatrix, G2_GetBoltMatrixLow, and the others in the round record) have no body to compare. The round's bodies in the other hand classes are outside the five files and were not compared: the CGoreSet deinit, CMiniHeap ResetHeap and MiniHeapAlloc, the CTraceSurface initializer, and the GoreTextureCoordinates initializer.
