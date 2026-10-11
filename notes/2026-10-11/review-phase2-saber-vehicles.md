# Review of phase 2, wave A, saber and vehicles

This review reads the diff of `w_saber.swift`, `g_active.swift`, `g_vehicles.swift`, `FighterNPC.swift`, and `SpeederNPC.swift` against `wave-0` at a1b6196. It compares each hunk to Raven's C in `oracle/codemp/game/`, to the jka-rust port in `jka-rust/crates/mp/`, and to the ruled form in `frame-path-walk.md`. The line numbers are the lines of the working tree after the edit.

The diff has 17 hunks in four files. `g_active.swift` has no diff, and A-22 is a "no change" unit. The record has 18 rows, the 17 hunks and the A-22 row.

## Hunks

| File:line | Unit | Row | Raven | Verdict |
|---|---|---|---|---|
| `w_saber.swift:458` | A-03 | E1 | `w_saber.c:384` | match |
| `w_saber.swift:486` | A-03 | E1 | `w_saber.c:420` | match |
| `w_saber.swift:493` | A-03 | E1 | `w_saber.c:429` | match |
| `w_saber.swift:502`, `:505` | A-03 | E1 | `w_saber.c:439`, `:444` | match |
| `w_saber.swift:585-589` | A-03 | E1 | `w_saber.c:530-533` | match |
| `w_saber.swift:1002` | A-04 | E3 | `w_saber.c:1001-1002` | match |
| `w_saber.swift:1952` | A-21 | N1 | `w_saber.c:2274` | match |
| `w_saber.swift:2093-2094`, the drop of `var fwd = fwd` and `var right = right` | A-05 | E4 | `w_saber.c:2459` | match |
| `w_saber.swift:2104-2143` | A-05 | E4 | `w_saber.c:2471-2513` | match |
| `w_saber.swift:3783` | A-21 | N1 | `w_saber.c:4410` | match |
| `w_saber.swift:4280` | A-21 | N1 | `w_saber.c:4688` | match |
| `w_saber.swift:4812-4830` | A-06 | E5 | `w_saber.c:5687-5701` | match |
| `g_active.swift:303` | A-22 | N1 | `g_active.c:332` | match, no change |
| `g_vehicles.swift:2122` | A-12 | M1 | `g_vehicles.c:3104` | match |
| `g_vehicles.swift:2133-2167` | A-12 | M1 | `g_vehicles.c:3116-3150` | match |
| `g_vehicles.swift:2185` | A-12 | M1 | `g_vehicles.c:3166` | match |
| `SpeederNPC.swift:253` | A-16 | R6 | `SpeederNPC.c:461-466` | match |
| `FighterNPC.swift:579`, `:593` | A-18 | N1 | `FighterNPC.c:760`, `:776` | match |
| `FighterNPC.swift:601`, `:606` | A-18 | N1 | `FighterNPC.c:786`, `:794` | match |

## Checks per unit

A-03. The array type, the zero fill, and the six stores and reads are the E1 form, with no `Int(...)` cast. The read at `:585` runs `k += 1` before `continue`, as guide line 593 gives for a C `for` loop. The index order `[j][k]` at the read and `[i][j]` at the stores is Raven's. jka-rust `w_saber.rs:567` also fills the array with `qfalse`.

A-04. The comment line is the E3 text word for word, and the Port-note and the `portMissing` call are gone. The copy and the `&originPos` argument stay. jka-rust `w_saber.rs:1265` passes `vec3_origin` by value.

A-05. `d1` and `d2` are `vec3_t()` value locals, and the 8 stores and 12 reads are the E4 form. Each `-radius / 2.0` is at the same operand as Raven's `-radius/2.0f`. No statement of the function writes `fwd`, `right`, `invFwd`, or `invRight` after `VectorInverse`, so the E4 condition holds and the two dropped copies change nothing. jka-rust `w_saber.rs:3076` takes `d1` and `d2` as a tuple of `vec3_t` values, the same ground.

A-06. The `if` holds Raven's four `&&` operands in his order, and the flag takes the three `||` operands in turn. The store into `dot1` runs only when the first two operands are false, as in C. The `else if` arm and Raven's three comments are in place. jka-rust `w_saber.rs:6752` keeps the one `if` and drops the store into `dot1` and the second FIXME comment, and the Swift keeps both.

A-21. Each site is `x = Int32(x op f)` over the `(Int32, Float)` operator of `Promotion.swift:12`. C converts the `int` to `float`, multiplies in `float`, and truncates toward zero, and the Swift does the same. The literal `0.2` is `Float` at `:4280`, as Raven's `0.2f`. jka-rust writes `(x as f32 * f) as c_int` at the three sites.

A-22. Raven wrote `(float)(self->r.maxs[0] - self->r.mins[0])/4.0f` as a plain store, so the `Float(...)` is his cast and the line keeps its form.

A-12. `surfName` is `[String]` with an empty fill, the M1 form, and the read at `:2185` has no force unwrap. The trailing comment is Raven's. The 13 Port-notes, Raven-wrote lines, and `portMissing` calls are gone, and the file has no Port-note left. jka-rust `g_vehicles.rs:2344` holds `[*const c_char; 4]` with null starts, and no path reads a null.

A-16. The line is the R6 text word for word, and the two comments stay. Raven's `0 &&` gives `false` in C, so the behavior is the same. jka-rust `speeder_npc.rs` has no statement for the empty block.

A-18. Each store is the N1 form over `Promotion.swift:8` and `:10`. The evaluation is `Float(hackingTime) - 50 * m_fTimeModifier` with a truncation toward zero, as C. jka-rust `fighter_npc.rs:798` and `:814` write the same arithmetic with `as f32` and `as c_int`.

## Removal of the holes

No `portMissing` call with the name `SetSaberBoxSize`, `G_G2PlayerAngles`, `G_BuildSaberFaces`, `WP_SaberStartMissileBlockCheck`, or `G_FlyVehicleDestroySurface` is left. The Port-note counts are 8 in `w_saber.swift`, 0 in `g_vehicles.swift`, and 10 in `g_active.swift`, the counts of the two transcriptor records. The diff changes no line outside the units.

## Style

No hunk adds a cast that Raven did not write. Each array index is a C integer, with no `Int(...)`. The one new comment, at `w_saber.swift:1002`, is one STE sentence on one line, with no em dash. The other comments in the hunks are Raven's text.

## Findings

No hunk differs from Raven's C or from the ruled form.

## Observations outside the hunks

These lines are not in the diff. They are for the coordinator to decide, and they are not findings of this wave.

1. `g_vehicles.swift:2132` and the next three `case` lines have no copy of Raven's case comments, for example `//break the nose off` at `g_vehicles.c:3115`. The draft dropped them before this wave.
2. `FighterNPC.swift:603` and `:608` write `Int32(0.0)` for Raven's `parentPS->hackingTime = 0.0f;` at `FighterNPC.c:789` and its twin. The vehicles record names these lines in its finding 3.
