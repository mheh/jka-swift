# The tr_shader body round of set S7

This record holds the body round of set S7 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-s7` in the worktree `/tmp/jka-s7`. The file is `Sources/JKAMP_DedLogic/tr_shader.swift`, which was adopted already. One agent wrote the five bodies and ran the build and the tests.

## The functions

| Function | Raven | State |
| --- | --- | --- |
| ParseTexMod | renderer/tr_shader.cpp:572 | landed |
| ParseSurfaceSprites | :808 | landed |
| ParseSurfaceSpritesOptional | :970 | landed |
| ParseDeform | :1936 | landed |
| RE_RegisterShaderFromImage | :3598 | landed |

ParseStage (:1279) and ParseShader (:2300) are not in this set. They wait on the rows G14 and G15 of set W5.

Each body keeps its note that it has no caller in the dedicated build. The five notes state the correct reason, so no note changed.

## The forms

- Raven's `const char **text = &_text` points at his own `const char *` parameter. ParseTexMod, ParseSurfaceSprites, and ParseSurfaceSpritesOptional walk a `TextCursor` over a copy of the bytes, the form of `cg_players.swift:360`.
- `Com_Error(ERR_DROP, ...)` in ParseTexMod has no `return` after it, because `Com_Error` is `-> Never` by rule 22.
- `stage->ss` and `shader.deforms[n]` get their records from `Hunk_Alloc` through the view initializer, the form of ParseSkyParms.
- The `stage->ss` chain binds once after the allocation, by the chain rule of transcription.md.
- `fadedist*1.33` and `1.0f / atof( token )` compute in `double` and convert at the store, the form of `CPathInfo.swift:266`.
- Raven's expression statement `stage->ss->vertSkew;` reads `_ = ss.vertSkew`.
- The `#ifdef _XBOX` block of ParseSurfaceSprites is not in the WinDed build, so the body leaves it out.
- RE_RegisterShaderFromImage copies the lightmap and style tables with the loops of R_FindShader, with the same two AI lines, and points `texMods` with the form of ClearGlobalShader.

## The gate

`swift build -j 2` completes with no error and no warning in the file. `swift test --no-parallel -j 2` passes 156 tests in 9 runs, the count of the base branch.
