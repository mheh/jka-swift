# The walk of 2026-10-04

This walk opened on the class table at 649163e, tabled in game-gate-649163e.md beside this file. The open docket from the walk of 2026-10-01 is R7, the never-null name rule for the vehicleInfo_t function pointers, and R11, the Slots index form that returns Int32. R2 of the walk of 2026-09-29 stays open as well.

## Ledger

| Row | Question | Verdict |
|---|---|---|
| R15 | The composition of the next round, from the class table at 649163e in game-gate-649163e.md. Proposed: row C first, a global `let` vector at an inout vector parameter, 43 lines of `vec3_origin`. The callee reads only, so a vector parameter the callee never writes drops inout, and the written-first test already exists. Then row D, a pooled string field read at a `PooledString` or `String` site takes the bind, 49 lines. Then row E, C's implicit numeric conversion: a `Float` meeting an `Int32` slot takes `Int32(...)`, an `Int32` meeting a `Float` slot takes `Float(...)`, 40 lines. Then R11, the Slots index form that returns Int32 in Sources/JKAShared, a hand change to the views. R2 and R7 stay open | ratified as proposed |

## The round at 9a756c8

Row C built: a non-const vector parameter crosses by value when the callee's body never writes it, by the table's parameter write census. The vec3_origin lines go from 45 to 11, and the 11 left pass the zero vector to a callee that writes it, G_Damage, or to a hand inout signature, BG_IK_MoveArm. The row changed 31 stub signatures, so the skeleton and the channel ran inside the row. Row D built: a char pointer field at a String site takes the bind at every format position and at a char pointer output store. The 49 lines go to 0. Row E built: a Float at an Int32 slot takes Int32 and the reverse takes Float, at the store or the argument. The parse met the SDK's long random before the overlay's float one, so the drafter now reads C's real number kind through the overlay. The 42 lines go to 0. Row R11 built: Slots gains slot(of:), an Int32 by pointer distance, and the six hole sites read it. Two lines became visible when earlier errors stopped hiding them, a get-only angles property in NPC_spawn and a Double to Int32 store in g_active.

Gate: build 0 errors, 106 tests in four binaries, bg 103 holes with 0 defects, game 1632 holes with 0 cascade errors and 341 defects. No defect class grew in any stem. The skeleton rewrote w_force.swift and the manifest rewrote three tables in the final run.

### Rulings on the round

| Row | Question | Verdict |
|---|---|---|
| R16 | Row C ran skeleton.py and channel.py before R11. Without the new stubs, a caller still reads inout and the row does not show in the gate. Proposed: a signature row runs the skeleton and the channel inside its own row | ratified as proposed |
| R17 | Two adopted files pass `&` to a vector the body never writes: g_exphysics.swift to G_SetOrigin `origin`, and g_object.swift to G_MoverTouchPushTriggers `oldOrg`. Both are `vec3_mut` holds in PARAMS of rulings.py. Proposed: ratify the two name holds | ratified as proposed |
| R18 | A shape rule beyond the row text. A non-const vector of an adopted stub, and a PARAMS hold, count as written in the store census, unless a NULL reaches the vector. This keeps the table equal to the hand signatures, and a caller's own vector stays inout. 24 adopted bg and g_strap parameters would otherwise drop inout. Proposed: ratify | ratified as proposed |
| R19 | The bg channel keeps inout on its bg surface for a game function that dropped inout, because the adopted bg callers pass `&`. The install passes the value on. The drafter reads the callee signature of its own target first. Proposed: ratify | ratified as proposed |
| R20 | 10 sites pass `vec3_origin` to G_Damage `dir`, which the callee writes, so the rule does not apply. Proposed: a `let` vector at a parameter the callee writes passes a scratch copy, `var scratchDir = vec3_origin`, under a Port-note. VectorNormalize does not write a zero vector, so the copy keeps Raven's behavior | ratified as a docketed open row |
| R21 | w_saber:1021 passes `vec3_origin` to BG_IK_MoveArm `desiredPos`. The hand signature in the adopted bg_pmove.swift takes it inout, and the C body never writes it. Proposed: a hand change to a by-value `desiredPos` in bg_pmove.swift, as its own commit. Or the scratch copy of R20, if the hand signature must stay | replaced: the scratch copy of R20, the hand signature stays |
| R22 | Row D binds a `char *` field at each `%s` position and at a `char **` output store. Raven's printf prints "(null)" for a NULL there, and the bind traps. Proposed: ratify, with the trap as the rule 19 divergence, the R5 form | ratified as proposed |
| R23 | Row E needed shape rules beyond its text: `arith_kind` with the overlay return type for `random()` and `crandom()` against the SDK's long, Float vector initializer members, the conversion of the chained store value, the float compound store for a library call Swift holds in Float. It also leaves out a conversion where the kinds agree. Proposed: ratify | ratified as proposed |
| R24 | The R11 form is named `slot(of:)`. It reads the pointer distance, not a search, and it traps outside the table. The Int sites keep `firstIndex(of:)!`. The name is in the drafter code, not in rulings.py, as `firstIndex` was. Proposed: ratify the name and the form | ratified as proposed |
