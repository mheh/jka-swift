# The cg_draw rows R4 to R8

The five open rows of `cgame-round-1-cg-draw.md`, run as one drafter pass on `cgame-rows-r4-r8` off master 952ac51. Every site is read at its line in Raven's tree and in the Swift tree.

## The verdicts

| Row | Verdict | Commit |
|---|---|---|
| R4 | Ratified, narrowed to option 1 | dcae157 |
| R5 | Ratified, the rule does not test for const | 406e9b3 |
| R6 | Ratified, alpha 1 under rule 19 with the AI line | fd55cf1 |
| R7 | Ratified as proposed | 4e744fd |
| R8 | Ratified as proposed | 8a19c42 |

## R4, a `const float *` parameter as `vec4_t?`

A `const float *` parameter spells `JKAShared.vec4_t?`. The exception is a parameter that the body reads only through `*f` or a cast. That test is the fact `reinterprets`, which `table.py` computes from the definition's body, and its reason sits in the rule's comment in `spelling.py`. In the cgame the rule reaches `CG_DrawRect`, `CG_FillRect`, `CG_FillRect2`, `CG_DrawStringExt`, and `CG_DrawHealthBarRough`. The trap rows `trap_R_SetColor` and `trap_R_Font_DrawString` did not change. In the game it reaches no parameter, and `FloatSwap` and `FloatNoSwap` keep `Float`.

## R5, a trap vector that a caller passes as NULL

A trap `vec3_t` parameter that a NULL reaches spells `vec3_t?`, and the wrapper sends the zero word for nil. Raven declares `trap_S_StartSound(vec3_t origin, ...)` without const at `cg_syscalls.c:192`, so the rule does not test for const. The engine only reads the two non-const vectors the rule reaches, `S_StartSound(const vec3_t origin)` and `G2_API.cpp:1552-1558`. Game traps reached: `trap_Trace` and `trap_G2Trace` for mins and maxs, and `trap_G2API_RagEffectorGoal` for pos. Cgame traps reached: `trap_CM_BoxTrace` and `trap_CM_TransformedBoxTrace` for mins and maxs, `trap_S_StartSound` for origin, and `trap_G2API_RagEffectorGoal` for pos. In `cg_draw.swift` six call sites pass the vector by value, and the two scratch-origin sites pass nil with their Port-notes removed.

## R6, the saber clash flare color

`CG_SaberClashFlare` passes `vec4_t(color.x, color.y, color.z, 1)` to `trap_R_SetColor`, with the rule 24 line under Raven's comment.

## R7, a four-float memcpy as a vector store

The `record_bytes` rule in `draft_statements.py` drafts a four-float copy into a `vec4_t` as a plain store. The source is a `vec4_t` value, a `[vec4_t]` table row, or a `float[4]` field that crosses as `vec4_t(f[0], f[1], f[2], f[3])`. In cg_draw it reaches 26 `calcColor` sites. A copy from an optional parameter stays a hole.

## R8, a float pointer local that names a color

The "pointer local with no view" hole in `draft_declarations.py` takes the `color_local` test from `draft_classification.py`. It reaches `fadeColor` in `CG_DrawPickupItem` and `CG_DrawOldScoreboard`, and `color` in `CG_DrawCenterString` and `CG_DrawCrosshairNames`, all as `vec4_t?`. No game local matches.

## The gate

The generator sequence ran for both units at each commit. The eleven stale game manifests stayed out of every commit. The snapshot gate moved 80 lines in 22 game body files, every one from R5, where `trap_Trace` and `trap_G2Trace` pass nil for `vec3_origin`. The build passed, and `swift test --no-parallel` passed. The cg_draw draft gate replaced 69 of 100 hand functions, kept 31, and reported 108 holes, 0 cascade errors, and 0 defects.

| File | `portMissing(` | `// Port-note:` |
|---|---|---|
| `cg_draw.swift` | 161, was 164 | 160, was 163 |
| `cg_drawtools.swift` | 24, was 24 | 0, was 0 |
