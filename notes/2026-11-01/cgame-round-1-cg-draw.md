# The cgame transcription rounds, round 1, cg_draw

The record of the first cgame transcription round on 2026-11-01, one stem, `cg_draw`, on the branch `cgame-rounds-cg-draw` off master `f039137`. The user tests each stem's result before the next stem starts.

## The tool findings before the first adoption

- `adopt.py` took no `--unit` option and skipped a file that was already adopted. The markers walk adopted several cgame stubs by hand, so the tool now takes `--unit` through the shared helper of `closure.py` and splices into an adopted file. In an adopted file a draft replaces only a function whose body is still the marker pair, and a hand signature stands over the draft body. Commit 66ebf20.
- The drafter marked a read of a hole local only through `reference()`, and about 24 print sites name a local directly, so a subscript read of the static local `previousTimes` inside `+=` in `CG_DrawFPS` printed as bare code and the adopted file did not build. A statement that drafts with no hole now takes one check over its own expressions for any hole local, and a match makes the statement a hole. The snapshot moved one line, the `v = vecs[index]` read of `tv` in `g_utils`, which the old rule also missed. Commit 4974a7f.

## The first adoption

Draft gate of the stem: 100 of 100 replaced, 334 holes, 0 cascade errors, 0 defects, 233 compile holes over 4 passes. Adopted at 7da585c with 334 Port-notes. 126 of them read "cannot convert value", and the coordinator read them before the hole round, at the user's word.

## Rows R1 to R3, ruled by the user on 2026-11-01

The 126 came from three shapes.

- R1. A `const float *` trap parameter Raven fills as four floats spells `JKAShared.vec4_t?`, nil for NULL, and the wrapper packs the four floats for the word and sends 0 for nil. The rule sits in `spelling.py` beside the vector rows and reaches `trap_R_SetColor` and `trap_R_Font_DrawString`. The game has no such trap. Commit 7ff7eec.
- R2. A local `vec4_t` drafts as `JKAShared.vec4_t`, with its element stores as they are. A `vec4_t` view field, which crosses as `Slots<Float>` of count 4, or a `[Float]` local passed to a `vec4_t` parameter crosses by its four elements. Commit a1fcf1a.
- R3. A call to a buffer trap with a scalar return, `trap_SP_GetStringTextString`, drafts as the tuple it is: `strcpy(&buffer, trap(...).1)` as a statement, and the lifted `let` with `.0 != 0` inside an `if` test. Commit 7472bb9.

The regate of the stem after the three rows: 244 holes, 143 compile holes, 0 cascade errors, 0 defects. "cannot convert value" fell from 126 to 51. The file was reset to its stub and readopted at 1bfb749, because no hole round had touched it and the adopt tool keeps every body that is not the marker pair.

## The shape left open

43 of the 51 are the same color shape at hand functions: every `const float *` parameter in the cgame sources is a color of four floats (`CG_DrawRect`, `CG_FillRect`, `CG_FillRect2`, `CG_DrawStringExt`, `CG_DrawHealthBarRough`), and the stub table spells them as one `Float`. The coordinator proposed R4, the R1 rule over every function parameter, and the user chose the hole round first and left R4 open.
