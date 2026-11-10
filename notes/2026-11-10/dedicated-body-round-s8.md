# The S8 body round of the dead-function wave

This record holds the body round of set S8 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-s8` in the worktree `/tmp/jka-s8`. The set is 12 functions in `Sources/JKAMP_DedLogic/CRMMission.swift` and `Sources/JKAMP_DedLogic/CRandomTerrain.swift`. Both files were adopted already, so no skeleton header was removed.

## The counts

| File | Set | Landed | Open |
| --- | --- | --- | --- |
| CRMMission | 9 | 9 | 0 |
| CRandomTerrain | 3 | 3 | 0 |
| Total | 12 | 12 | 0 |

`swift build -j 2` is clean. `swift test --no-parallel -j 2` passes 156 tests, the count of the base branch.

## The functions

- ParseNodes (`RMG/RM_Mission.cpp:248`): landed. The body takes a mutable copy of `group`, the form of CRMMission.swift:183. The `int` locals that Raven sets from `atof` take `Int32(atof(...))` with a C conversion line.
- ParsePaths (`:294`): landed.
- ParseRivers (`:340`): landed.
- ParseInstances (`:966`): landed. The `#ifndef PRE_RELEASE_DEMO` arm builds, because the build does not define the macro. The loop calls the ParseInstance stub, so the body traps when a group has a sub group, until the CRMInstance classes of row N-RMG land. ParseInstance gets `@discardableResult`, because Raven drops its result at `:981`.
- ParseObjectives (`:1000`): landed. `CRMObjective(group)` goes into `mObjectives` with `append`.
- ParseAmmo (`:1040`), ParseWeapons (`:1090`), ParseOutfit (`:1147`): landed. Raven's comment blocks stay.
- ParseDifficulty (`:1236`): landed. `atol` is `atoi`, through LIBC_SPELLINGS. `symmetry_t` is an `Int32` alias, so the cast of `atoi` drops. The body calls the ParseRandom stub, so it traps until set W3 lands ParseRandom.
- CRandomTerrain::CreatePath (`qcommon/cm_randomterrain.cpp:605`): landed.
- GetPathInfo (`:628`): landed with `@discardableResult`, because every caller drops the result.
- Smooth (`:644`): landed. Only the `#if 1` arm is written, by the `#ifdef` rule of transcription.md. The zone block is a Slots over Z_Malloc, and the copy is Com_Memcpy over the two Slots, the form of `R_InvertImage` in tr_image.swift.

## The notes

The three terrain methods said that Raven calls them only from a client build. That is wrong: CRMPathManager calls CreatePath (`RM_Path.cpp:327`, `:416`, `:564`), and CRMMission calls GetPathInfo and Smooth (`RM_Mission.cpp:213`, `:1463`). Each note now says that the dedicated build never makes a CRandomTerrain, so it never calls the method. The note of Generate, outside this set, still holds the old reason.
