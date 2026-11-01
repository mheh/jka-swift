# The cgame transcription rounds, round 2, cg_marks

The record of the second cgame transcription round on 2026-11-01, one stem, `cg_marks`, on the branch `cgame-round-2-cg-marks` off master `f5560fc`. The eleven stale game manifests regenerated first, in their own commit d33a64a.

## The first adoption

Draft gate of the stem: 28 of 28 replaced, 309 holes, 0 cascade errors, 0 defects, 42 compile holes over 2 passes. Adopted at ea3129b with 300 Port-notes. 237 of them were reads of the record array locals `verts`, `TRIverts`, and `markFragments`, which the table had no type for.

## Rows R9 to R13

R9 ruled by the user. R10 to R13 ruled by the coordinator under the user's delegation, each on a pattern the port already uses, with every citation read in both trees.

- R9. A record array local whose record has a view opens `View.scratch(count: N) { name in ... }`, the form of the single record local, and its reads index the Slots. The game drafts of four such locals moved. Commit ee7ec86.
- R10. A cast of a `vec3_t[N]` local to `const vec3_t *` drafts as the array, and element 0 of a local vector array passed to an `inout [vec3_t]` parameter drafts as the array by reference. The `trap_CM_MarkFragments` call at cg_marks.c:161 drafts whole. Commit 50f62bf.
- R11. `crandom` and `atof` are double to the drafter, as they are in C. The overlay declared `crandom` as float, and the double rule skipped `atof` as a shared name. The store takes the game's form, `Float(Double(a) + crandom() * Double(b))`. 34 crandom and 2 atof holes closed, and 70 game draft lines moved to the hand form. Commit 76cffeb.
- R12. A float stored into a narrow element converts to Int32 before the truncating init, `UInt8(truncatingIfNeeded: Int32(red * 255))`, the form of the narrow view field path. The fix sits in the narrow crossing of `spelling.py`. Commit 3f56714.
- R13. A NULL output takes the settled form: one plain comment per call above the scratch locals and no hole, "Raven passes NULL for the `X` and `Y` outputs." The game drafts closed 427 holes at 227 calls. Commit 5c88899.

The regate after the rows: 15 holes, 2 compile holes, 0 cascade errors, 0 defects. The file was reset to its stub and readopted at 3d648cc, with 14 Port-notes.

## The hole round

Commit 9a608be closed every note. 0 Port-notes and 0 portMissing lines remain. The shapes: `char *str` with `COM_Parse` as a `TextCursor`, the `trap_R_AddPolyToScene` calls pass the first record of the Slots, the fragment loop of `CG_ImpactMark` is written whole with index locals for Raven's walk pointers and a closure `return` for his `continue`, and three file-scope variables went on `CGameWorld`. The build and `swift test --no-parallel` pass.

Three forms the transcriptor chose with no rule to name them, for the user's ruling:

- The int copy `*(int *)v->modulate = *(int *)colors` is four byte stores under one comment.
- The partial `memcpy` of `numPoints` records is a local `while` loop that copies each record. cg_players.c:5615 and :5627 have the same shape.
- `if (animStr < (char *)10) CG_Error(...)` at cg_marks.c:1501 is dropped with no comment. A `String` parameter cannot hold an index cast to a pointer, so the arm has no path.

## The rows left open

- R14, a defect. The drafter ports Raven's file-scope walk pointer `cg_freeMarkPolys` as the index `cg_freeMarkPolysIndex`, and writes `= 0` for `cg_freeMarkPolys = le` at cg_marks.c:58 and for `cg_freeMarkPolys = cg_freeMarkPolys->nextMark` at :83, and `cg_markPolys[index] == nil` for `!cg_freeMarkPolys` at :73. Every allocation takes slot 0. The draft gate reported no defect. The free list needs a form, and the game's pools are the precedent to read.
- R15. The double compound store at draft_statements.py:841 writes `a += b + c` with no grouping, so Swift adds left to right where C computes `a + (b + c)`. The hand game files group it. A fix moved about 20 game draft lines outside the ruled rows and was reverted.
- R16. `trap_R_AddPolyToScene` and `trap_R_AddPolysToScene` take one `PolyVert` at cg_syscalls.swift:621 and :626 where Raven passes an array. Every caller passes the first record of a Slots.
- Two older drafter shapes R11 showed in the game drafts: a `0.2f` literal drafts as `0.2` where the hand file has `Double(0.2 as Float)`, and a `_VectorMA` scale drafts as `Float(crandom() * 25)` where the hand file writes each component in double.
