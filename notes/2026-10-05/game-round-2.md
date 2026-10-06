# The second game Port-note round, 2026-10-05

The build of rulings R36 to R48 and the walk of R49 to R58. One generator agent, twelve hand agents, one follow-through agent, thirteen reviewers, one compile gate. The gate: build 0 errors, release build 0 errors, 106 tests in four binaries, bg draftcheck 107 holes and 0 defects, game draftcheck 1342 holes and 0 defects over 72 stems.

## The counts

| File | Before | After |
|---|---|---|
| w_saber | 97 | 39 |
| tri_coll_test | 128 | 0 |
| g_cmds | 32 | 8 |
| ai_main | 33 | 3 |
| g_active | 26 | 10 |
| g_client | 33 | 2 |
| g_vehicles | 32 | 13 |
| NPC_combat | 40 | 4 |
| g_combat | 24 | 5 |
| g_weapon | 23 | 7 |
| g_utils | 34 | 9 |
| total | 502 | 100 |

The game target holds 903 Port-notes in all after the round, and the bg target holds 12.

## What the round settled

- The generator phase of R36 to R48: `scratch(count:)` and `fill` on the views, `index(of:)` on Slots, the optional inout vector and axis with a generated forward, the key path for `G_Find`, the `String?` for a reached `char *`, the plain-value `run` helpers that trap on a NULL pointer, and twenty manifest signatures.
- The hand wave over twelve files, one agent per file, with the GameWorld properties for eighteen static locals, the alignment of the twenty adopted signatures with their callers, and the removal of `slot(of:)`.
- The walk of R49 to R58 in `walk.md`, ten rows the hand agents and reviewers raised while they worked, every one ratified as proposed. Three of them share one cause: the NULL sweep does not follow a NULL that arrives through a caller's optional local or an optional field. The rows hold the evidence.
- The guide gains the value-returning macro, the one-array inout parameter, the optional trace bound, the `?? ""` under a runtime test, the `spot = nil` after a `while let` a later read follows, and the step-at-the-bottom loop for a `break` with a later read.
- The jka-rust review leg ran over every changed file against the submodule. Every function agrees with Raven. The reviewers put back twelve of Raven's inline comments the drafts had dropped, restored one two-space format literal, and took the guide's short spellings at thirty sites.
- The draftcheck scan ignores the Source line of a generated forward, so a draft replaces the hand body and not the forward. Before this fix the two forwards gave one defect each.
- The views generator writes `@discardableResult` on every `run` helper that returns a value.

## The docket

The open rows for the next walk, found during this round.

| Count | Family | What a ruling decides |
|---|---|---|
| 22 | The `d1` and `d2` float pointer locals of the saber face loop | A form for a float pointer local that steps through a record's vectors. |
| 13 | `surfName` in G_FlyVehicleDestroySurface | A form for a `char *` local the body walks and compares. |
| 7 | The scalar array `alwaysBlock` and the `G2Trace` marker | The scalar-array row R37 deferred. |
| 6 | A compile hole in g_combat the redeclaration had hidden | Each carries the compiler's first line. |
| 5 | The pmove stores `trace`, `pointcontents`, `baseEnt`, `entSize`, `pmove_fixed` | The row R45 deferred. |
| 4 | An `Int32` used as a Bool, `== qtrue` on a Bool field | A widening rule for a qboolean field against an int literal. |
| 3 | A memcpy into a CharBuf at an offset, ConcatArgs | A form for a byte copy at an offset, `strcpy(&line, String(arg), at: len)` is one shape. |
| 3 | A compound int-times-float store, `damage *= fact` | Whether the expansion `damage = Int32(Float(damage) * fact)` is the form, or Promotion gains the operator. |
| 2 | A Raven comment that trails a condition line | Where the comment goes when the condition takes one Swift line. |
| 1 | The `fList++` step of the saber face loop | A form for stepping a view to the next slot. |
| 1 | The `goto blockStuff` in CheckSaberDamage | The goto row R45 deferred. |

Smaller rows: the sizeof of a `char *` array, the Slots over one record, the function pointer compared with `!=`, the `ColorIndex` byte against an `Int32` cursor, the long health chain the compiler cannot type-check, the two-dimensional float field read as a vector, and a `[Int32]` for Raven's `byte m[4]`.

## Found outside the diffs

- `BG_SiegeGetPairedValue` reads one byte past the NUL when a value opens a quote as the last byte of the file. Before this round the read stayed inside the caller's buffer, and now it hits the CharBuf precondition. A malformed file is the only trigger.
- The manifest's jka-rust range for Board, DeathUpdate and Update in g_vehicles points at a per-vehicle wrapper and not the generic body.
- `G_TouchTriggers` at g_active.swift:523 keeps a Port-note on a function pointer compared with `!=`, outside this round's scope.
- The `/// Source:` lines of the two bot-timer forwards cited the function line and now cite the static declarations, as the g_client forwards do.
- The `while let` form of R44 leaves the loop variable set when the loop ends. Nine of the eleven loops this round wrote have no later read, and the two that do took R54 and R56.
