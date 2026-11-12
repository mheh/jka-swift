# Review: G2_API, G2_bolts, G2_surfaces, CGhoul2Info_v, Ghoul2InfoArray against Raven

Base: master `d6f2dd7`. Raven: `oracle/codemp/ghoul2/`. Build defines: WinDed Release, which is not FINAL_BUILD, so `_FULL_G2_LEAK_CHECKING`, `G2_PERFORMANCE_ANALYSIS`, and `_G2_GORE` are on and `_DEBUG` is off (`q_shared.h:45-47`, `:3110`, `tools/oracle-closure/closure.py:60`, `:340`). The Swift bodies follow these arms.

Counts: DEFECT 3, SUSPECT 0, RULE 2.

## Findings, most severe first

### 1. DEFECT: G2_Add_Bolt_Surf_Num accepts a negative surface number

- Swift: `Sources/JKAMP_DedLogic/G2_bolts.swift:62`
  `if surfNum >= slist.count {`
- Raven: `oracle/codemp/ghoul2/G2_bolts.cpp:77`
  `if (surfNum >= slist.size())`

Raven compares an `int` with the unsigned `size_t`, so a negative `surfNum` (for example the -1 that G2API_AddSurface returns on a failure) converts to a large unsigned value and the function returns -1. Swift compares signed values, so -1 passes the test. The first loop (`:68-76`) then finds the first bone bolt, whose `surfaceNumber` is -1, increments its `boltUsed`, and returns its index.

### 2. DEFECT: the index functions of G2_bones trap on a negative index, where Raven returns false (outside the five files, reached from this round's wrappers)

- Swift: `Sources/JKAMP_DedLogic/G2_bones.swift:432` (G2_Set_Bone_Anim_Index), and the same line at `:280` (G2_Set_Bone_Angles_Index), `:359` (G2_Set_Bone_Angles_Matrix_Index), `:672` (G2_Stop_Bone_Anim_Index), and `:703` (G2_Stop_Bone_Angles_Index)
  `if (index >= blist.count) || (blist[index].boneNumber == -1) {`
- Raven: `oracle/codemp/ghoul2/G2_bones.cpp:639`, and `:440`, `:541`, `:996`, `:1031`
  `if ((index >= blist.size()) || (blist[index].boneNumber == -1))`

The signed and unsigned comparison is the same as in finding 1. In Raven, `index` -1 converts to a large unsigned value, so the test is true and the function returns false. In Swift, -1 is less than the count, so `blist[-1]` traps. The bodies of this round that reach these functions are G2API_SetBoneAnimIndex (`G2_API.swift:597`), G2API_SetBoneAnglesMatrixIndex (`:715`), G2API_StopBoneAnimIndex (`:683`), and G2API_StopBoneAnglesIndex (`:735`). The base game module calls none of the four.

### 3. DEFECT: G2API_RagEffectorGoal has no NULL `pos` arm

- Swift: `Sources/JKAMP_DedLogic/G2_API.swift:843` and `:854-855`
  `func G2API_RagEffectorGoal(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ pos: JKAShared.vec3_t) -> Bool {`
  `_VectorCopy(pos, &bone!.overGoalSpot)` / `bone!.hasOverGoal = true`
- Raven: `oracle/codemp/ghoul2/G2_API.cpp:1552-1560`
  `if (!pos) { bone->hasOverGoal = false; } else { VectorCopy(pos, bone->overGoalSpot); bone->hasOverGoal = true; }`

Raven clears `hasOverGoal` when `pos` is NULL. The Swift parameter is not optional, so the clear arm is gone and no caller can request it. The trap of the game module takes `vec3_t?` (`Sources/JKAMP_Game/Generated/g_syscalls.swift:2338`). The cgame passes `nil` at `Sources/JKAMP_CGameLogic/cg_players.swift:3181-3185`. The base game module has no caller.

### 4. RULE: G2API_CopyGhoul2Instance increments the gore reference count with a wrapping add

- Swift: `Sources/JKAMP_DedLogic/G2_API.swift:1192`
  `gore!.mRefCount &+= 1`
- Raven: `oracle/codemp/ghoul2/G2_API.cpp:2269`
  `gore->mRefCount++;`

`docs/transcription.md:617` gives `&+` only to the generator and hash arithmetic of `WRAPPING_ARITHMETIC`. Here the add has no Port-note. The behavior differs only on a signed overflow.

### 5. RULE: the leak tracker traps on element 0 of an empty list with no rule 19 note

- Swift: `Sources/JKAMP_DedLogic/G2_API.swift:151` (G2_DEBUG_ShovePtrInTracker) and `:178` (G2_DEBUG_RemovePtrFromTracker)
  `if g2v[0].currentModel != nil && !g2v[0].currentModel!.name.isEmpty {`
- Raven: `oracle/codemp/ghoul2/G2_API.cpp:109` and `:140`
  `if (g2v[0].currentModel && g2v[0].currentModel->name && g2v[0].currentModel->name[0])`

These arms run only when the tracker is full or does not hold the instance. At those times the list is empty: G2API_InitGhoul2Model shoves the new instance before it allocates a handle, and G2API_CleanGhoul2Models removes the instance after `clear()`. Raven reads past the end of an empty vector, and Swift traps. Rule 19 requires a Port-note at a trap of this kind. The note is on G2_DEBUG_ReportLeaks (`:115`) but not on these two sites.

## Checks with no finding

- Writes through a copy. `Ghoul2InfoArray.Get` and `CGhoul2Info_v.Array()` return a copy of `[CGhoul2Info]`. But `CGhoul2Info`, `boneInfo_t`, `boltInfo_t`, and `surfaceInfo_t` are all `final class`, so every element write in the bodies (`ghlInfo[modelIndex].mModelindex = -1`, `mBoneCache = nil`, `mGoreSetTag = 0`, `mModelBoltLink`, `mBlist.removeAll()` on an element, and the bone writes of the ragdoll functions) goes to the stored object. Only Raven's changes to the structure of the list (`resize`, `push_back`, `Array()=other.Array()`, and the slot assignments) need the write path, and all of them are still stubs. `DeleteLow` writes `self.mInfos[idx]` directly.
- Exclusivity. The calls that pass an instance and an `inout` field of the same instance are at `G2_API.swift:332`, `:340`, `:383`, `:597`, `:642`, `:658`, `:667`, `:772`, `:792`, `:931`, and `:940`. No callee body with a port reads the same field through the instance: G2_Set_Bone_Anim, G2_Get_Bone_Anim_Range, G2_Pause_Bone_Anim, G2_Get_Bone_Anim, and G2_Remove_Bone (`G2_bones.swift:269-647`) read only `animModel` and `aHeader`, and G2_Add_Bolt_Surf_Num reads nothing through `ghlInfo`. For the callees that are stubs (G2_SetSurfaceOnOff, G2_IsSurfaceOff, G2_IsSurfaceRendered, G2_Add_Bolt, G2_Find_Bone_Rag), Raven's bodies also do not read the passed list through the instance (`G2_surfaces.cpp`, `G2_bolts.cpp:119-233`, `G2_bones.cpp:1267`).
- G2_RemoveRedundantBolts: the guarded original-surface block (`G2_bolts.swift:176`) gives Raven's result in every case. A surviving generated bolt still reaches the `activeSurfaces` test, as in Raven's unconditional block. A second removal of a bolt that stays in the list changes nothing, and a trimmed bolt ends the loop. The Port-note is accurate.
- G2_SetupModelPointers and G2_TestModelPointers: every statement, condition, and order agrees with `G2_API.cpp:2606-2771`. `G2ERROR` is `((void)0)` (`G2_API.cpp:1785`). The timer `Start` comes before the NULL return and `End` comes only on the two `true` paths, as in Raven.
- G2API_RemoveGhoul2Model and G2API_RemoveGhoul2Models: the statements, the loop bounds and step, the `continue`, the `break`, and the delete arm agree with `G2_API.cpp:795-960`.

## Reach notes (stub calls, not defects)

- G2API_RemoveGhoul2Models (`G2_API.swift:524`) always calls the `CGhoul2Info_v.resize` stub (`CGhoul2Info_v.swift:80`). After the loop every slot is -1, so `newSize` is 0 and differs from a size that the sanity check makes nonzero. Every call that passes the sanity check traps. The game calls it at `Sources/JKAMP_GameLogic/w_saber.swift:5651`.
- G2API_RemoveGhoul2Model (`G2_API.swift:446`) reaches the same stub each time the removed model is the last model in the list.
- G2API_CopyGhoul2Instance and G2API_DuplicateGhoul2Instance reach the DeepCopy stub (`CGhoul2Info_v.swift:67`).

## Functions compared in full

G2_API.swift: G2_DEBUG_InitPtrTracker, G2_DEBUG_ReportLeaks, G2_DEBUG_ShovePtrInTracker, G2_DEBUG_RemovePtrFromTracker, G2API_SetTime, G2API_GetTime, G2API_AttachInstanceToEntNum, G2API_ClearAttachedInstance, G2API_CleanEntAttachments, G2API_OverrideServerWithClientData, TheGhoul2InfoArray, Ghoul2InfoArray_Free, G2API_CleanGhoul2Models, G2_ShouldRegisterServer, G2API_PrecacheGhoul2Model, G2API_SetLodBias, G2API_SetSkin, G2API_SetShader, G2API_SetSurfaceOnOff, G2API_GetSurfaceOnOff, G2API_AddSurface, G2API_RemoveSurface, G2API_GetParentSurface, G2API_GetSurfaceRenderStatus, G2API_HasGhoul2ModelOnIndex, G2API_RemoveGhoul2Model, G2API_RemoveGhoul2Models, G2API_SetBoneAnimIndex, G2API_SetBoneAnim, G2API_GetAnimRange, G2API_PauseBoneAnim, G2API_IsPaused, G2API_StopBoneAnimIndex, G2API_StopBoneAnim, G2API_SetBoneAnglesMatrixIndex, G2API_SetBoneAnglesMatrix, G2API_StopBoneAnglesIndex, G2API_StopBoneAngles, G2API_SetRagDoll, G2API_ResetRagDoll, G2API_RemoveBone, G2_GetRagBoneConveniently, G2API_RagPCJConstraint, G2API_RagPCJGradientSpeed, G2API_RagEffectorGoal, G2API_GetRagBonePos, G2API_RagEffectorKick, G2API_RagForceSolve, G2API_RemoveBolt, G2API_AddBolt, G2API_AddBoltSurfNum, G2API_SetBoltInfo, G2API_DetachG2Model, G2API_AttachEnt, G2API_ListSurfaces, G2API_ListBones, G2API_HaveWeGhoul2Models, G2API_SetGhoul2ModelIndexes, G2API_GetAnimFileNameIndex, G2API_GetAnimFileName, QsortDistance, G2_NeedRetransform, G2API_SetGhoul2ModelFlags, G2API_GetGhoul2ModelFlags, G2API_GiveMeVectorFromMatrix, G2API_CopyGhoul2Instance, G2API_DuplicateGhoul2Instance, G2API_GetSurfaceIndex, G2API_SetNewOrigin, G2API_GetBoneIndex, G2API_SaveGhoul2Models, G2API_LoadGhoul2Models, G2API_FreeSaveBuffer, G2API_LoadSaveCodeDestructGhoul2Info, G2API_GetNumGoreMarks, G2API_ClearSkinGore, G2API_Ghoul2Size, G2_TestModelPointers, G2_SetupModelPointers.

G2_bolts.swift: G2_Find_Bolt_Bone_Num, G2_Find_Bolt_Surface_Num, G2_Add_Bolt_Surf_Num, G2_Remove_Bolt, G2_Init_Bolt_List, G2_RemoveRedundantBolts.

G2_surfaces.swift: G2_FindOverrideSurface, G2_RemoveRedundantGeneratedSurfaces, G2_AddSurface, G2_RemoveSurface.

CGhoul2Info_v.swift: InfoArray, Alloc, Free, Array, both init forms, deinit, both copy forms, subscript, clear, size, IsValid, kill.

Ghoul2InfoArray.swift: DeleteLow, init, New, IsValid, Delete, Get.

## Functions not reached

None. Every function with a body in the five files was compared. The `portMissing` stubs were not reviewed.
