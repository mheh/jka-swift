# The first game Port-note round, 2026-10-05

Commit 2801330. Ten transcriptors, nine reviewers, one compile gate. The gate: build 0 errors, release build 0 errors, 106 tests in four binaries.

## The counts

| File | Before | After |
|---|---|---|
| w_saber | 172 | 97 |
| tri_coll_test | 128 | 128 |
| g_cmds | 101 | 31 |
| ai_main | 78 | 33 |
| g_active | 76 | 26 |
| g_client | 69 | 33 |
| g_vehicles | 65 | 32 |
| NPC_combat | 64 | 40 |
| g_combat | 60 | 24 |
| g_weapon | 56 | 23 |
| total | 869 | 467 |

## What the round settled

- A NULL output of `AngleVectors` closes under the guide's own line, because the callee's NULL arm only skips the write. Nine reviewers confirmed it from `q_math.c:1315-1348`.
- The two signatures in g_main that took inout buffers follow the table and take Strings.
- The manifests are regenerated under the R35 table. The lookup tool reads the manifests, so a manifest regeneration belongs after every table change. A signature sweep against the stale manifests flipped 173 functions to inout and was restored from its own snapshot. Against the fresh manifests the sweep found only the two g_main signatures.

## The docket

The open families across the ten files, by count. `grep -rn "Port-note:" Sources/JKAMP_GameLogic` is the full list.

| Count | Family | What a ruling decides |
|---|---|---|
| 128 | The nine function-like macros of tri_coll_test | Hand Swift functions of the same name in a file in scope, or an inline expansion rule. Two macros return out of the enclosing function. |
| 104 | A read of a local the draft left as a hole | Mostly the static locals of the saber trace (`faces`, `planeEq`), the float pointers `d1` and `d2`, and the combat point array. A storage ruling for a static local, and a type for a local array of records. |
| 62 | NULL for `mins` or `maxs` into a trace trap | Whether NULL and `vec3_origin` give the same syscall stream. |
| 52 | A statement that did not compile | Each carries the compiler's first line. |
| 25 | NULL for an output the callee reads | The NULL `dir` into `G_Damage`, whose NULL arm changes behavior, and the NULL `out_axis` into `BG_AttachToRancor`. |
| 21 | A literal or String into an inout CharBuf | `G_SetSaber`, `G_FilterPacket`, `SetupGameGhoul2Model`, `Debug_Printf`, `SanitizeString`. |
| 15 | A never-null ruling | An optional attacker, inflictor, or text into a parameter that takes a value. R7 covers the vehicleInfo case. |
| 12 | A memset over bytes that are not one record | Scalar arrays, and two memsets of -1 over tag arrays. |
| 11 | An assignment inside an expression | Mostly `G_Find` inside a `while` test, with `FOFS` at the call site. |

Smaller rows: a slot index stored into an Int32 (`client - level.clients`, a record index into a field), a function pointer compared with `!=`, a float stored into an int, a compound assignment inside an expression, a `goto` into a block, a sizeof the draft cannot size, a Slots over one record, and the pmove stores of `trace`, `pointcontents`, `baseEnt`, `entSize`, and `pmove_fixed`.

## Found outside the diffs

- The manifest's jka-rust column is stale. The path names `crates/mp/game/src/`, the files live under `crates/port/mp/game/src/`, every function the reviewers looked up is a `port_missing` stub there, and some rows match a function of the same name in another file. The three-way check compared oracle and Swift only.
- `G_SayTo` in g_cmds drops Raven's `if (locMsg)` test and always sends the located chat form.
- `UpdateRider` in g_vehicles holds five holes on the `Eject` callback calls, which return `Bool?`.
