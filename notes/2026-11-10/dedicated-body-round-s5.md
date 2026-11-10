# The S5 body round of the dead-function wave

This record holds set S5 of `notes/2026-11-10/docket-13.md`, section 4, on the branch `ded-bodies-s5` in the worktree `/tmp/jka-s5`. The set is 15 functions in `Sources/JKAMP_DedLogic/tr_ghoul2.swift` and `Sources/JKAMP_DedLogic/CRenderableSurface.swift`. Each function has no caller in the dedicated server, and each keeps its one-line note that says so.

## The functions

| Function | Raven | State |
| --- | --- | --- |
| G2_Find_Bone_ByNum | renderer/tr_ghoul2.cpp:112 | landed |
| G2_GetBoneNameFromSkel | :678 | landed |
| G2_GetParentBoneMatrixLow | :780 | landed |
| R_GCullModel | :896 | landed |
| R_GComputeFogNum | :939 | landed |
| G2_ComputeLOD | :967 | landed |
| G2_CreateQuaterion | :1048 | landed |
| G2_CreateMatrixFromQuaterion | :1097 | landed |
| G2_SetUpBolts | :2053 | landed |
| G2_ProcessSurfaceBolt | :2246 | landed |
| G2_ProcessGeneratedSurfaceBolts | :2495 | landed |
| ProcessModelBoltSurfaces | :2739 | landed |
| bInShadowRange | :3369 | landed |
| CRenderableSurface::operator= | renderer/tr_local.h:2067 | landed |
| CRenderableSurface::Init | :2092 | landed |

All 15 bodies are written. No stub of the set is left. AllocRS (`tr_ghoul2.cpp:869`) is not in the set. It waits on row G17 for the storage `RSStorage`.

## The forms

- G2_GetParentBoneMatrixLow has a hand signature in the form of G2_GetBoneMatrixLow, with `inout MdxaBone?` for the two `mdxaBone_t *&` parameters, as the docket says. The file has no generator skeleton header, so the hand edit follows the existing form in the file.
- G2_ComputeLOD reads `myftol` as `(int)` under `DEDICATED`, so `lod = Int32(flod)`. The radius argument `0.75*largestScale*ent->e.radius` is double math in C, so it takes the `Double` widening of transcription.md and one `Float(...)` at the argument.
- G2_CreateQuaterion keeps the float `sqrt(t)` and the double `sqrt(1.0 + ...)` of Raven, and `0.25 * s` is double math with one `Float(...)` at the store.
- G2_ProcessSurfaceBolt is the twin of G2_ProcessSurfaceBolt2. It reads `bonePtr[piBoneRefs[iBoneIndex]].1` at each site as Raven does, and writes into `boltList[boltNum].position`. The `_XBOX` branches are not in the WinDed build. Its `baryCentricK` takes the `Double` widening for the `1.0` literal.
- G2_ProcessGeneratedSurfaceBolts and ProcessModelBoltSurfaces keep the timer lines, because `game/q_shared.h:46` defines `G2_PERFORMANCE_ANALYSIS`. ProcessModelBoltSurfaces returns before the timer end on the `G2SURFACEFLAG_NODESCENDANTS` path, as Raven does.

## The checks

`swift build -j 2` passes. `swift test --no-parallel -j 2` runs 156 tests with no failure.
