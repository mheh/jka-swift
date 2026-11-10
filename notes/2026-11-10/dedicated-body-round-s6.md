# The body round of set S6

This record holds the body round of set S6 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-s6` in the worktree `/tmp/jka-s6`, made from `dedicated-rulings-batch-12`. The set has seven functions in `Sources/JKAMP_DedLogic/G2_misc.swift`, `G2_bones.swift`, and `CBoneCache.swift`. No file of the set had the skeleton header.

## The functions

| Function | Raven | State |
| --- | --- | --- |
| G2_GorePolys | `ghoul2/G2_misc.cpp:804` | landed |
| G2_LerpAngles | `ghoul2/G2_misc.cpp:1912` | landed |
| G2_Animate_Bone_List (3 args) | `ghoul2/G2_bones.cpp:1065` | landed |
| G2_SetRagDollBullet | `ghoul2/G2_bones.cpp:2040` | landed |
| G2_Get_Bone_Name | `ghoul2/G2_bones.cpp:2580` | landed |
| CBoneCache::SetRenderMatrix | `renderer/tr_ghoul2.cpp:208` | landed, an empty body |
| CBoneCache::SmoothLow | `renderer/tr_ghoul2.cpp:267` | landed |

No stub of the set is open. G2_GetGoreRecord, G2_SaveGhoul2Models, and G2_LoadGhoul2Model are not in this round, because they wait on the rows N-GORE and N-G2SAVE.

## Notes on the bodies

- G2_GorePolys keeps Raven's over-allocation: the block is `sizeof(int) * size` bytes, and `size` is already a count of bytes. The `int *data` and `float *fdata` walks are index locals into two `Slots` over the one block. The two `memcpy` calls from `GoreIndexCopy` and `GoreIndecies` are loops, because the two tables are Swift arrays of the world, and each site has a rule 24 line. The `#ifdef _DEBUG` counter lines drop.
- G2_LerpAngles and SmoothLow walk the twelve floats of a bone matrix as `matrix[z / 4][z % 4]`.
- SmoothLow drops Raven's `#if 0` block, the `#ifdef _XBOX` call, and the `#ifdef _DEBUG` NaN check.
- SetRenderMatrix: Raven's whole body stands under `#ifdef _XBOX`, so the dedicated body is empty. The existing note states this.
- G2_SetRagDollBullet drops the `#if 0` block. It does not call `G2_Set_Bone_Rag`.
- G2_Get_Bone_Name: the body has no guard in Raven's source, so the Release build compiles it. Its two calls, at `G2_bones.cpp:2625` and `:3851`, stand under `_DEBUG_BONE_NAMES`, and only `_DEBUG` defines it (`:2576`). The note now states this reason. The old note named the `#ifndef DEDICATED` arm of G2_BoneSnap, and that was wrong.
- The edits in `G2_bones.swift` stay inside the bodies of the three functions, so the branch that removes the `inout blist` parameter of `G2_Set_Bone_Rag` merges clean.

## The checks

- `swift build -j 2`: clean, with no new warning in the three files.
- `swift test --no-parallel -j 2`: 156 tests pass.
