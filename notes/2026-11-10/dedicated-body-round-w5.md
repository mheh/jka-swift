# The tr_shader body round of the fifth wave

This record holds the body round of set W5 of section 4 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-w5` in the worktree `/tmp/jka-w5`. The set is the two parse functions of `Sources/JKAMP_DedLogic/tr_shader.swift` that rows G14 and G15 of ledger 14 unblocked. The file was adopted already.

## The functions

| Function | Raven | State |
| --- | --- | --- |
| ParseStage | `tr_shader.cpp:1279` | landed |
| ParseShader | `tr_shader.cpp:2300` | landed |

Both functions keep their note that says the dedicated build never calls them. The notes are correct: ParseShader is the one caller of ParseStage at `tr_shader.cpp:2336`, and R_FindShader calls ParseShader at `:3477` only on a text that ScanAndLoadShaderFiles loads under `#ifndef DEDICATED` at `:3812`.

## The forms

- Each body takes the `DEDICATED` arms and drops the `VV_LIGHTING` and `_XBOX` arms. WinDed Release has no `FINAL_BUILD`, so the "Lightmap requested" print stays.
- The `image_t *images[MAX_IMAGE_ANIMATIONS]` local of the animMap arm is a `[Image?]` under one AI line, as the docket names. The dedicated arm never writes it, and `numImageAnimations` stays 0.
- Raven's `memcpy` of the image pointers into the hunk block is a loop over a `Slots<Image?>` of the block under one AI line, the form of the memcpy loops of `G2_misc.swift` and of this file. The block size uses the machine pointer size, `OpaquePointer.byteCount`, the form of `cm_load.swift:624`.
- The tcGen vector block is `Slots(vectors:)` over the `Hunk_Alloc` of two `vec3_t`, the field kind of row G15.
- The `float` sun angles use `JKAShared.M_PI` and the float overloads of `sin` and `cos`.

## The checks

`swift build -j 2` is clean, with no warning in `tr_shader.swift`. `swift test --no-parallel -j 2` passes 162 tests, the count of the base. No stub of the set stays open.
