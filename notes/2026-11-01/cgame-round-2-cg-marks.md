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

## Rows R14 to R16 and the three forms

Ruled by the coordinator under the user's delegation on 2026-11-01, each on a pattern the port already uses, with every citation read in both trees. The file was past its hole round, so every change to it is a hand edit.

- R14. Raven never steps `cg_freeMarkPolys`, it moves along `nextMark` links. The file-scope walk sweep took the two tests of the local rule, stepped and every store a table slot, so the pointer is `MarkPoly?` on the generated variables, the shape of `g_timerFreeList` and `free_particles`. A bare table store drafts as slot 0. `cg_freeLocalEntities` took the same form in its stub, and `pushed_p` stays an index. The three list functions read as Raven wrote them. Commit c97b7a1.
- R15. C's `a op= e` is `a = a op (e)`, so the three compound store arms group a right side that is an operator. The hand sites that multiplied left to right took the grouped form: ai_main.c:526, g_items.c:74 and :78, bg_pmove.c:526, and five cg_marks sites. 38 game draft lines moved. Commit 4765dcf.
- R16. The two AddPoly traps take `Slots<JKAMP.PolyVert>` by a PARAMS table row each, and the four cg_marks calls pass the Slots. Commit f37323d.
- The int copy stays as four byte stores under its comment. The partial memcpy stays a while loop with no comment, the NPC_senses form. CG_ParticleExplosion has zero callers in either tree, so under rule 20 it is its stub again with a dead note. Commit 8fccab4.

The gate after the rows: 11 holes, 0 cascade errors, 0 defects, 0 compile holes. The build and `swift test --no-parallel` pass. cg_marks.swift holds 1 portMissing line, the dead stub, and 0 Port-notes.

## The rows left open

- R17. The tools have no dead-function form. `NOT_PORTED` removes the function, and rule 20 keeps the stub with a marker and a note. The CG_ParticleExplosion stub is hand-written, and the adopt tool leaves it alone because of its note line. A `rulings.py` entry with a stub form in `skeleton.py` would let the generators state it.
- R18. The hand line bg_pmove.swift:440 computes `(viewangles - vAngles) * 0.75` in double where Raven's `0.75f` keeps it in float.
- The other adopted cgame stem, cg_draw, is not checked for hand sites with the R15 grouping defect.
- Two older drafter shapes R11 showed in the game drafts: a `0.2f` literal drafts as `0.2` where the hand file has `Double(0.2 as Float)`, and a `_VectorMA` scale drafts as `Float(crandom() * 25)` where the hand file writes each component in double.
