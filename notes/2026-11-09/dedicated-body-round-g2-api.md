# Dedicated body round: g2-api

Branch `ded-bodies-g2-api`, off master at `7961ee4`, in the worktree `/tmp/jka-g2-api`. The code commit is `37b31ac`. The round ran no generator, no python tool, no draftcheck, and no snapshot tool. The stems are G2_API, G2_bolts, and G2_surfaces of `oracle/codemp/ghoul2/`, which stage E5 of `dedicated-open-rows-ledger-6.md` opened.

## Adoption

G2_API.swift loses the skeleton header in the code commit. G2_bolts.swift and G2_surfaces.swift take no hand edit, so they keep the header, and the next generator run can rewrite them.

## Bodies filled

| Stem | portMissing before | portMissing after | Filled |
|---|---|---|---|
| G2_API | 99 | 92 | 7 |
| G2_bolts | 7 | 7 | 0 |
| G2_surfaces | 14 | 14 | 0 |

- G2API_SetTime and G2API_GetTime of `G2_API.cpp:162` and `:179` read and write `G2TimeBases`. The body drops the `assert` of `:164`, because the build defines NDEBUG. The two `#if G2_DEBUG_TIME` blocks are dead, because no file defines `G2_DEBUG_TIME`.
- G2API_ClearAttachedInstance and G2API_CleanEntAttachments of `G2_API.cpp:214` and `:221` are empty. Their whole bodies stand under `#ifdef _G2_LISTEN_SERVER_OPT`, and no file of `oracle/codemp/` defines that name.
- G2_ShouldRegisterServer of `G2_API.cpp:570` compares `currentVM` with `gvm` and reads `com_cl_running`, Com_TheHunkMarkHasBeenMade, and ShaderHashTableExists. ShaderHashTableExists of `Sources/JKAMP_DedLogic/tr_shader.swift:108` is still a stub, and the dedicated server never reaches it, because `cl_running` is 0 there.
- G2API_PrecacheGhoul2Model of `G2_API.cpp:585` calls RE_RegisterServerModel or RE_RegisterModel by their stub signatures in `tr_model.swift`.
- G2API_FreeSaveBuffer of `G2_API.cpp:2482` frees nothing. Raven calls Z_Free on the buffer, and the Swift parameter is an `inout CharBuf`, which owns its bytes. The precedent is the CharBuf overload of FS_FreeFile at `Sources/JKAMP_DedLogic/files_pc.swift:1489`. The site carries one rule 24 line at `Sources/JKAMP_DedLogic/G2_API.swift:912`.

`grep -c Unsafe` gives 0 on G2_API.swift.

## Stubs that stay

### The C++ track, 108 stubs

88 stubs of G2_API, all 7 of G2_bolts, and 13 of G2_surfaces carry the generator's `TODO: Port signature` marker. Each names a parameter or a return of a class of rule 17 that has no table row: `CGhoul2Info *`, `CGhoul2Info_v &`, `CGhoul2Info_v **`, `boltInfo_v &`, `surfaceInfo_v &`, `model_t *`, or `IGhoul2InfoArray &`. A body needs the signature first, and this round changes no signature. Each stub cites its Raven line in its own `Source:` line and names the missing row in its `No table row` line.

### Row G1, the leak tracker globals

G2_DEBUG_InitPtrTracker and G2_DEBUG_ReportLeaks of `oracle/codemp/ghoul2/G2_API.cpp:46` and `:52` read `g_G2AllocTrackInit` and `g_G2AllocTrack` of `:43` and `:44`. The build compiles them, because `oracle/codemp/game/q_shared.h:47` defines `_FULL_G2_LEAK_CHECKING` when `FINAL_BUILD` is not defined, and `oracle/codemp/WinDed.vcproj:32` does not define it. The two globals keep the `TODO: Port global` marker at `Sources/JKAMP_DedLogic/G2_API.swift:34` and `:39`, because the table has no row for `bool` or `CGhoul2Info_v *[4096]`. ReportLeaks also indexes a `CGhoul2Info_v`. The stubs stand at `G2_API.swift:91` and `:97`.

### Row G2, the Ghoul2InfoArray singleton

Ghoul2InfoArray_Free of `G2_API.cpp:487` deletes `singleton` of `:477`, a `Ghoul2InfoArray *` of rule 17. The global keeps its marker at `G2_API.swift:62`, and the stub stands at `G2_API.swift:175`.

### Row G3, the model_t view

G2API_GetAnimFileNameIndex of `G2_API.cpp:1962` returns `mod_m->mdxm->animName` of the model that R_GetModelByHandle gives. R_GetModelByHandle of `oracle/codemp/renderer/tr_model.cpp` has a `TODO: Port signature` stub at `Sources/JKAMP_DedLogic/tr_model.swift:143`, and `model_t` of `oracle/codemp/renderer/tr_local.h:1117` has no view in `Sources/JKAMP_Ded`. The stub stands at `G2_API.swift:723`.

G2_IsSurfaceLegal of `oracle/codemp/ghoul2/G2_surfaces.cpp:65` has a mapped signature, `(_ mod: OpaquePointer?, _ surfaceName: String, _ flags: inout Int32) -> Int32`, at `Sources/JKAMP_DedLogic/G2_surfaces.swift:20`. The body walks the `mdxmSurfHierarchy_t` records of `oracle/codemp/renderer/mdx_format.h:185` behind `mod_m->mdxm`. A logic body cannot read an `OpaquePointer` by rule 11, and no view exists for `model_t`, `mdxmHeader_t`, or `mdxmSurfHierarchy_t`. The stub stays until that view exists.

### Row G4, the collision record comparator

QsortDistance of `G2_API.cpp:1993` is the qsort comparator over `CollisionRecord_t` of `oracle/codemp/game/q_shared.h:1884`. Its two `OpaquePointer?` parameters at `G2_API.swift:760` need a view of the record, and its only callers, G2API_CollisionDetectCache and G2API_CollisionDetect of `G2_API.cpp:2035` and `:2124`, carry signature markers. A Swift sort over a record array replaces the comparator when those callers take a body.

## Gate

- `swift build -j 2`: exit 0, 0 errors, and no warning in G2_API.swift.
- `swift test --no-parallel -j 2`: exit 0, 147 tests in 22 suites, 0 failures, 0 skipped.
