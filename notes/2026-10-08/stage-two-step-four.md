# Stage two, step 4, the ruling and the gate of 2026-10-08

The second builder, an opus agent, took the worktree `.claude/worktrees/agent-ac60452bfe29cede1` on the branch `stage-two` with the two notes of 2026-10-07 as its plan. This record holds the one row the build raised, its ruling, and the gate counts.

## Ledger

| Row | Verdict | Ruled by | Date |
|---|---|---|---|
| S38a | Ratified as proposed. | User | 2026-10-08 |

## S38a, the hole footer when the drafter counts a hole it throws away

The question. The drafter's hole counter rises for a hole inside a draft it later discards, so no note line prints for that hole. Two functions do this. G_ProcessIPBans of g_svcmds drafts a for statement, counts a store hole, then redrafts it. CheckSaberDamage of w_saber counts a goto hole on an if arm, then the scratch path drafts the block again with a different note. The old footer prints the counter, so g_svcmds says 16 holes and w_saber says 139. The rows give 15 and 138, the number of note lines in the text.

The ruling. S38 is amended so the footer counts the line rows with role note, which is the count of holes in the printed text. The two footers change to 15 and 138 in the step-4 commit, and the step-1 snapshot is refreshed after that commit so steps 5 to 9 gate against the corrected footer. The drafter's counter stays as it is.

The reason. The footer names the holes a reader finds in the text, and a hole whose lines never print is not one of them. The review of 2026-10-07 already asked for this amendment on the DECL_STMT case, where one lowered row holds two note lines.

The delta. draftcheck prints and returns the drafter's counter, so its reference of 1342 game holes and 107 bg holes stays the same. A stored per-function count would keep the old footer byte for byte and keep the wrong number. A drafter rule that stops counting a discarded hole would move the same two footers and lower the draftcheck reference by two.

## The gate of the drafter fix, commit 1b0b518

The commit moves the four assignments of `optional_vectors`, `local_facts`, `slots_locals`, and `narrow_locals` above the `raw_local_names` line in `draft()` of `bodies.py`. The builder set the step-4 edits aside so the commit holds the reorder alone.

| Check | Result |
|---|---|
| Fast tool tests | 39 pass, the step-4 tests set aside |
| `bodies.py --only G_Find`, old code | exit 1 in 21 s, AttributeError on `optional_vectors` |
| `bodies.py --only G_Find`, new code | exit 0 in 98 s |
| `snapshot.py --check` against step 1 | exit 0 in 255 s, 351 files, no difference |

No other function read an unset field.

## The gate of step 4 before the ruling

The lowering is per function with one drafter held by `Lowering`. `Skeleton` takes a store parameter and passes it to `Table`. Both S30 tests run on a sqlite backup copy of the working store in a temporary folder, and the md5 of the working store was the same before and after the run. The second S30 test went red on the missing parameter, then green. The key check sits inside the lowered-lines read, the lowering reads `(stem, function)` strings, the roles test asserts at least one hole, and `INDENT` is imported.

| Check | Result |
|---|---|
| `bodies.py --only G_Find` through the lowering | exit 0 in 93 s, same text as commit one |
| Fast tool tests | 42 pass in 1 s |
| Tool tests under `SLOW=1` | 42 pass in 152 s, 5 skipped |
| `snapshot.py --check` against step 1 | exit 1 in 102 s, two files differ in the footer line only |

The test count went from 41 to 42.

## The gate of step 4 after the ruling, commit 5d0fec9

The commit holds the per-function lowering, the store parameter on `Skeleton`, both S30 tests on a copy of the store, the four small items, and the footer under the amended S38. One change the ruling did not list: `printed()` in `bodies.py`, the in-memory form that the first S30 test reads as its expected text, printed the drafter's counter in its footer. It now adds the count of note-role lines per function. The drafter's counter is unchanged, and draftcheck still prints it.

| Check | Result |
|---|---|
| Fast tool tests | exit 0 in 2 s, 42 tests, 37 pass and 5 skipped |
| The two S30 tests under `SLOW=1` | exit 0 in 34 s, both pass |
| `snapshot.py --out` to `snapshot-stage-two-step4` | exit 0 in 92 s, 351 files |
| `snapshot.py --check` against step 4 | exit 0 in 26 s, 351 files, no difference |
| `diff -r` step 1 against step 4 | exit 1, two files differ, each in its footer line only |

The two footer lines: `bodies/g_svcmds.swift` line 569 goes from 16 holes to 15, and `bodies/w_saber.swift` line 7710 goes from 139 holes to 138. The gate reference for steps 5 to 9 is the step-4 snapshot at `$HOME/.cache/jka-swift/snapshot-stage-two-step4`. The step-1 folder stays in place.
