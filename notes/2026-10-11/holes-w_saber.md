# Hole round of w_saber.swift

The file `Sources/JKAMP_GameLogic/w_saber.swift` had 39 Port-notes at the start of the round. The count is 2 filled, 31 stands, and 6 blocked. The line numbers are the lines before the round.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| SetSaberBoxSize (458) | The local `qboolean alwaysBlock[MAX_SABERS][MAX_BLADES]` has no type in the table. | stands | The guide gives no form for a local two-dimensional array of a scalar. Docket row 1. |
| SetSaberBoxSize (488) | The store `alwaysBlock[i][j] = qfalse` | stands | It waits for the declaration. Docket row 1. |
| SetSaberBoxSize (497) | The store `alwaysBlock[i][j] = qtrue` | stands | It waits for the declaration. Docket row 1. |
| SetSaberBoxSize (508) | The store `alwaysBlock[i][j] = qtrue` | stands | It waits for the declaration. Docket row 1. |
| SetSaberBoxSize (513) | The store `alwaysBlock[i][j] = qfalse` | stands | It waits for the declaration. Docket row 1. |
| SetSaberBoxSize (595) | The read `if ( !alwaysBlock[j][k] ) continue;` | stands | It waits for the declaration. Docket row 1. |
| G_G2NPCAngles (872) | `VectorCompare( oldLookAngles, lookAngles ) == qfalse` compares an `int` with a `qboolean`, and the draft did not compile. | stands | The guide gives no form for an `int` compared with `qfalse`. Docket row 2. |
| G_G2PlayerAngles (1010) | Raven passes the `let` vector `vec3_origin` to `desiredPos`, which `BG_IK_MoveArm` takes `inout`. | stands | The guide keeps this note and marker until a ruling reads the write of the callee. Docket row 3. |
| G_G2TraceCollide (2013) | The local `G2Trace_t G2Trace` has no type in the table. | blocked | The definition of `G2Trace_t` is in q_shared.h, outside the read set, and the lookup tool has no row for it. The usage shows an array of `CollisionRecord_t`, which has the view `CollisionRecord`, so the `count` form of `scratch` is the probable fill. |
| G_G2TraceCollide (2034) | `memset (&G2Trace, 0, sizeof(G2Trace))` | blocked | It waits for the type of `G2Trace`. Under the `scratch` form, the memset drops, because the slots are zero at entry. |
| G_G2TraceCollide (2039) | The store `G2Trace[tN].mEntityNum = -1` | blocked | It waits for the type of `G2Trace`. |
| G_G2TraceCollide (2061) | The call `trap_G2API_CollisionDetectCache ( G2Trace, ... )` | blocked | It waits for the type of `G2Trace`, and the lookup tool has no signature for the trap. |
| G_G2TraceCollide (2065) | The call `trap_G2API_CollisionDetect ( G2Trace, ... )` | blocked | It waits for the type of `G2Trace`, and the lookup tool has no signature for the trap. |
| G_G2TraceCollide (2070) | The reads of `G2Trace[0]` in the test of the hit | blocked | It waits for the type of `G2Trace`. |
| G_BuildSaberFaces (2102) | The pointer local `float *d1 = NULL` has no view. | stands | The guide gives no form for a `float *` local that points at a vector local. Docket row 4. |
| G_BuildSaberFaces (2105) | The pointer local `float *d2 = NULL` has no view. | stands | Docket row 4. |
| G_BuildSaberFaces (2124 to 2151) | Eight stores, `d1 = &fwd[0]` and the others | stands | They wait for the declarations. Docket row 4. |
| G_BuildSaberFaces (2157 to 2198) | Twelve reads of `d1` and `d2` in `VectorMA` calls | stands | They wait for the declarations. Docket row 4. |
| G_SaberFaceCollisionCheck (2385) | `fList++` steps a `SaberFace` view, and the draft did not compile. | filled | The form is the pointer walk over a table: the parameter keeps its signature, and the body walks the index local `fListIndex`, set from `faces.index(of: fList)`. The only caller passes `faces[0]` from `G_BuildSaberFaces`. Every read `fList.vN` in the body is now `faces[fListIndex].vN`, and the step is `fListIndex += 1`. |
| CheckSaberDamage (3963) | `goto blockStuff` jumps from the blocked-hit arm into the saber-clash arm. | filled | The form is the `goto` restructure. The statements from the label to the end of the saber-clash arm are the nested function `blockStuff() -> Bool`, which ends with `return didHit`. The goto site and the end of the saber-clash arm both write `return blockStuff()`. The whole statement is now Swift, with the `#ifndef FINAL_BUILD` prints kept. The guide gives this form a Port-note that names the label, so one Port-note stays above the nested function, with no `Raven wrote:` line and no `portMissing` call. |
| WP_SaberStartMissileBlockCheck (4377) | An assignment inside an expression, `(dot1 = DotProduct( dir, forward )) < SABER_REFLECT_MISSILE_CONE`, inside the right side of `\|\|` | stands | The guide keeps a store inside the right side of `\|\|` as a hole. Docket row 5. |

## GameWorld properties

None. No hole in this round needs a static local or a file-scope static.

## Docket rows

1. SetSaberBoxSize, `alwaysBlock`. The guide has no form for a local array of a scalar with two dimensions. Proposed form: `var alwaysBlock = [[Bool]](repeating: [Bool](repeating: false, count: Int(MAX_BLADES)), count: Int(MAX_SABERS))`, and a body reads and writes `alwaysBlock[i][j]` as Raven wrote it. Raven leaves the array uninitialized, so the zero fill changes only a read of a slot that no statement set.
2. G_G2NPCAngles, `VectorCompare(...) == qfalse`. The guide has no form for an `int` compared with `qfalse` or `qtrue`. Proposed form: the comparison uses the value of the C enum, so `x == qfalse` reads `x == 0` and `x == qtrue` reads `x == 1`.
3. G_G2PlayerAngles, `vec3_origin` into `desiredPos` of `BG_IK_MoveArm`. The guide keeps the scratch copy under a note until a ruling reads the write of the callee. Proposed ruling: read `BG_IK_MoveArm` for a store into `desiredPos`. If the call with `forceHalt` set writes nothing into it, the copy takes a one-line comment and no note, as the `G_Damage` case does.
4. G_BuildSaberFaces, `d1` and `d2`. The guide has no form for a `float *` local that points at a vector. Proposed form: a `float *` local whose every store is `&v[0]` of a `vec3_t` local or parameter, and whose every use is a read of the three floats, is a `vec3_t` value local, so `d1 = &fwd[0]` reads `d1 = fwd`. The form holds only when no statement writes the vector between the store and the last read.
5. WP_SaberStartMissileBlockCheck, the store into `dot1` inside the right side of `||`. The guide keeps the hole, because a line before the statement runs at the wrong time. Proposed form: a `Bool` local takes the test, and each operand after the store runs in its own `if !test { ... }` in Raven's order, so the store runs only when C evaluates it.
