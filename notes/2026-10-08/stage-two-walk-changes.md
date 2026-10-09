# Stage two, the four code changes of the delegated walk, the gates of 2026-10-08

The fifth builder, an opus agent, built the four code changes of the last section of `stage-two-steps-8-10-walk.md` on the branch `stage-two` in the worktree `.claude/worktrees/agent-ac60452bfe29cede1`, one commit each, from f5a6d50. Every exit code below comes from `$?` of the command itself. The logs are under `/tmp/stage-two-changes/`, which does not last, so this record carries the counts.

## Change 1, commit cf131b0, the labeled path marks its lines

`labeled()` in `draft_statements.py` passes the frame, the lines inside it, and the closing frame through `marked(..., self.statement_number(label))` in the `do` form, and the frame, the lines inside it, the `break`, and the closing frame in the `while true` form. The lead declarations and the statements after the `do` frame keep their own marks. The record local before a label takes `self.lowered_as(decl, "scratch", depth)` and the mark of its statement, as the plain path does. The SLOW test `test_a_nested_blank_row_names_its_enclosing_statement_and_not_the_body` no longer leaves out the labeled functions, and it asserts that no comment row at depth 2 or more of bg_pmove names the body.

| Check | Result |
|---|---|
| The test on the old code | red in 27 s, 2 blank rows at seq 0 on bg_pmove, in PM_DoChargedWeapons and PM_VehicleWeaponAnimate |
| The store on the old code, every stem | 7,695 nested blank rows, 356 at seq 0, and 12,498 comment rows at depth 2 or more, 225 at seq 0, over 34 functions |
| The test on the new code | green in 27 s |
| `snapshot.py --check` against the step-4 folder | exit 0 in 91 s, 351 files, no difference, stderr named `draft_statements.py` as the changed lowering module |
| `bodies.py --stem q_math` and `--stem q_shared` | exit 0 in 26 s and 29 s, because the snapshot lowered the bg and game stems alone |
| The store on the new code, every stem | 2,628 functions, 7,695 nested blank rows, 0 at seq 0, and 12,498 comment rows at depth 2 or more, 0 at seq 0 |
| Rows with a null statement outside the header | 2,628, one closing brace for each function, as before |
| Lowered rows | 60,523, 7 more than the 60,516 of the walk, each a `scratch` row of a record local before a label |
| Full suite under `SLOW=1` | 60 OK in 156 s, exit 0 |

## Change 2, commit 090c6f9, the stub state

`align.py` holds the state `stub` after `rewritten` in `STATES`. The function `stub()` is true when the hand function ends with a signature line that ends in `{`, the line `// TODO: Port <name>`, a line that starts with `portMissing("<name>"`, and the closing brace, each stripped. `align_function` tests it before the ratio and gives each line of the function a `stub` row with null line row, statement, and role, with nothing on standard error. `compare_stem` prints the one line for `stub` as it does for `rewritten`, and `compare_counts` counts it through `STATES`.

| Check | Result |
|---|---|
| `test_a_hand_body_of_the_marker_pair_is_stub_and_not_rewritten` on the old code | red, the five lines aligned as `same` with their line rows |
| `test_a_stub_function_prints_one_line_and_exits_one` on the old `compare.py` | red, the stub lines printed as `hand` with texts |
| Both tests on the new code | green |
| Fast tests | 62 OK, 9 skipped, exit 0 in 3 s |
| `align.py --adopted`, cold under the new lowered key | exit 0 in 2 s, `total: 87 files, 119598 same, 1508 edited, 3411 hand, 327 rewritten, 488 stub` |
| Rewritten functions on standard error | 14, BG_InSlopeAnim, G_GetMapTypeBits, SanitizeString, G_LogWeaponInit, G_Printf, G_Error, Com_Error, Com_Printf, tv, RotatePointAroundVector, MatrixMultiply, NormalToLatLong, va, and coplanar_tri_tri |
| g_main | 0 same, 0 edited, 0 hand, 17 rewritten, 225 stub |
| q_shared | 38 same, 8 edited, 31 hand, 5 rewritten, 263 stub |
| Every other stem | the counts of the step-8 table, with no stub row |
| `compare.py --stem g_main` | exit 1, 49 lines, 45 that end in `stub` and 4 that end in `rewritten`, G_Printf, G_Error, Com_Error, and Com_Printf |

The 327 rewritten rows, the 14 rewritten functions, and the 4 rewritten lines of g_main meet the walk. The stub counts do not, see departure 1.

## Change 3, commit cde0bb3, the snapshot drafts the shared stems

`write()` in `snapshot.py` takes the stems whose target is `BG`, `LOGIC`, or `SHARED`, with `SHARED` imported from `skeleton`. `tests/test_snapshot.py` reads no file count, so it did not change.

| Check | Result |
|---|---|
| `snapshot.py --out $HOME/.cache/jka-swift/snapshot-stage-two-shared` | exit 0 in 28 s, 353 files |
| `diff -r` of the step-4 folder against the new folder | exit 1, two lines, `Only in .../snapshot-stage-two-shared/bodies: q_math.swift` and the same line for `q_shared.swift`, and no other line |
| `bodies.py --stem q_math` and `--stem q_shared` against the two new files | `cmp` exit 0 for each, and each equal to the output of the same command after change 1 |
| Fast tests | 62 OK, 9 skipped |
| `snapshot.py --check` against the new folder, after the commit | exit 0 in 31 s, 353 files, no difference |

The folder `$HOME/.cache/jka-swift/snapshot-stage-two-shared`, 353 files, is the reference from this commit on.

## Change 4, commit 6b44653, a reader open keeps a store of another version

`Store.__init__` in `store.py` tests the reader open before the writer's delete. When `reader` is set, the stored version differs from `SCHEMA_VERSION`, and the store is not fresh, the open closes the connection and raises `SystemExit` with one line that names the path, the stored version, the version of the code, and `bodies.py`. It deletes nothing. The writer open keeps its delete. The docstring of `Store` states both opens.

| Check | Result |
|---|---|
| `test_a_reader_open_of_another_schema_version_stops_and_keeps_the_file` on the old code | red, `SystemExit not raised` |
| The test on the new code | green, 20 OK in `tests.test_store` |
| Fast tests | 63 OK, 9 skipped, exit 0 in 2 s |
| Full suite under `SLOW=1` | 63 OK in 233 s, exit 0, with the cold base sweep that the `store.py` edit causes |
| `snapshot.py --check` against the new reference | exit 0 in 105 s, 353 files, no difference |
| `align.py --adopted` after the check | exit 0, the totals of change 2 byte for byte |
| The store, every stem | 7,695 nested blank rows and 12,498 comment rows at depth 2 or more, none at seq 0 |

The tool tests went from 60 to 60, 62, 62, and 63 across the four commits, 9 of them under `SLOW=1`.

## Departures from the walk's text

1. Change 2, the stub counts. The walk's gate gives `280 stub`, g_main at 23, 0, 12, 17, and 190, q_shared at 156, 24, 70, 5, and 90, and 38 stub lines from `compare.py --stem g_main`. The code of the ruled text gives `488 stub`, g_main at 0, 0, 0, 17, and 225, q_shared at 38, 8, 31, 5, and 263, and 45 stub lines. The walk counted as stub only the 56 rewritten functions that hold the marker pair. The S20 text as amended makes every hand function whose body is the marker pair `stub`, and its test comes before the ratio. 41 more functions hold the marker pair and nothing else, and their ratio was 0.3 or more: a short draft, for example G_RemapTeamShaders with 3 draft lines, or a draft whose hole marker line equals the hand's `portMissing` line, for example G_UpdateCvars, which aligned as 4 same and 1 hand. On a copy of the walk's store, `/tmp/walk810/store.sqlite` with md5 `b25cf96e9e9bfc699346042bd64bd078`, the 97 stub functions of the new run held 280 rewritten rows over 56 functions, and 141 same, 16 edited, and 51 hand rows over 41 functions. 280 and 208 make 488, and the three lower totals drop by 141, 16, and 51. An awk count of the marker pair before a closing brace gives 45 functions in `g_main.swift` and 52 in `q_shared.c.swift`, the 97 of the run. The rewritten counts of the walk hold: 327 rows, 14 functions, and 4 rewritten lines of g_main. I kept the code of the ruled text and committed it.
2. Change 1, the red count. The walk's gate names the test red with 356 blank rows. The test reads bg_pmove alone, and it was red with 2 blank rows at seq 0 there, in PM_DoChargedWeapons and PM_VehicleWeaponAnimate. The 356 is the count over the whole store, and the store query on the old code gave 356 nested blank rows and 225 comment rows at depth 2 or more at seq 0. The comment assertion stands after the blank assertion, so the red run stopped on the blank rows.
3. Change 1, the record local. The `scratch` row of a record local before a label is new, so the store holds 60,523 lowered rows, 7 more than the walk's 60,516. No printed byte moved.
4. The tdd skill. I invoked it before the two tests of change 2 and the test of change 4, but after I wrote the test of change 1. That test still ran red before the code.

## Open findings for the user

1. The `stub()` test reads a hand function from its end: a line that ends in `{`, the TODO line, the `portMissing` line, and the closing brace, each stripped. A stub under a `// TODO: Port signature` block passes it too, because the comment lines stand before the signature.
2. 41 of the 97 stub functions aligned as `same`, `edited`, or `hand` under the old rule. In some of them the draft is a hole whose marker line is byte-equal to the skeleton's `portMissing` line, so the old alignment called an untranscribed body `same`.
3. The usage line of `compare.py` names the step-4 folder in its `--against` example. The example still runs, and the reference is now `snapshot-stage-two-shared`. `HANDOFF.md` at the root of the main checkout names the step-4 folder at line 16 as the reference.
4. The store of the worktree now holds the lowered rows and the alignment under the key of commit 6b44653. The main checkout's store is untouched.

## The ruling on the stub count

| Row | Verdict | Ruled by | Date |
|---|---|---|---|
| S20, the stub count | Ratified as built. Every hand function whose body is the marker pair alone is `stub`, tested before the ratio, whatever its ratio against the draft. The count over the adopted stems is 488 rows over 97 functions. The delegated walk's gate figure of 280 counted only the 56 marker-pair functions that the ratio already made `rewritten`, and the figure gives way to the ruled text. | User | 2026-10-08 |
