# Stage two, steps 5 to 7, the gates of 2026-10-08

The third builder, an opus agent, built steps 5, 6, and 7 of S26 on the branch `stage-two` in the worktree `.claude/worktrees/agent-ac60452bfe29cede1`, one commit each, from 5d0fec9. The gate reference is the step-4 snapshot at `$HOME/.cache/jka-swift/snapshot-stage-two-step4`. This record holds the gate counts, the departures the builder named, and one correction to the draftcheck reference.

## The draftcheck reference is 1357 holes over 75 stems

The record of 2026-10-05 and the S27 text name 1342 game holes over 72 stems. `draftcheck.py --game` enumerates 75 stems on this tree and gives 1357 holes, 0 defects, and 224 compile holes. The builder set its edits aside, ran the unchanged code of 5d0fec9 over the same 75 stems, and got the same 1357, 0 defects, and 224 compile holes, with the same counts per stem. No step of this branch moved a count. The reference moved between the gate of 2026-10-05 and fde7fa8, and nothing in this record says which commit moved it. The bg reference holds at 107 holes and 0 defects. From here the game reference is 1357 holes and 0 defects over 75 stems.

## Step 5, commit 49b1bef, the printer takes the layout out of the drafter

`printer.py` is new, and `short_named` moved into it, so the stored rows keep their module qualifiers and the printer drops them. `bodies.py` lowers first and then calls the printer, and `snapshot.py` does the same. `printed()` is gone, and the first S30 test compares the drafter's lines of each function with the printer's lines. draftcheck builds what the printer prints, from the rows of each draft in memory. All five non-blocking items of the step-4 review are in this commit: the depth comment, the named early-out in the lowering, the roles test on a copied store, the cold first run of the warm S30 test, and the `path` parameter of `Skeleton`.

One departure under S7 as amended. `marked()` skips blank lines, so the one body-level call marks blank lines too, through a new `blanks` parameter. A blank line inside a nested block then names the body, seq 0, and not its block.

| Check | Result |
|---|---|
| Fast tool tests | OK in 2 s, 42 before and 44 after |
| The three S30 tests under `SLOW=1` | red on the null rows, then green |
| `snapshot.py --check` against step 4, cold | exit 0 in 170 s, stderr named the stale lowering modules |
| `draftcheck.py --all` | 107 holes, 0 defects, exit 0 in 131 s |
| `draftcheck.py --game` in five calls | 1357 holes, 0 defects, 147 s, 201 s, 251 s, 131 s, 117 s |
| `snapshot.py --check`, warm | exit 0 in 93 s |
| Full suite under `SLOW=1` | 44 OK in 151 s |

## Step 6, commit 58aeb3d, the printer prints a stem from the store with no parse

`printer.py --stem` and `--only` print from the store with no parse and no libclang. bg_pmove prints in 0.34 s and one function in 0.28 s, byte for byte the step-4 snapshot and the output of `bodies.py --only`. The key check rehashes the stubs' first lines, the Swift declaration lines, and the lowering modules, and takes the C-inputs part from the stored base key in the S5a shape. A stale key or a missing function stops the command with one line on standard error and exit 1. The function order comes from the `functions` facts, which keep the parse order. The new SLOW test is `test_the_printer_prints_a_stem_from_a_copied_store_with_no_parse_byte_for_byte`, red then green, and it fails if libclang loads.

| Check | Result |
|---|---|
| Fast tool tests | OK in 5 s, 44 before and 45 after |
| Full suite under `SLOW=1` | 45 OK in 238 s |
| `snapshot.py --check`, warm | exit 0 in 26 s |

## Step 7, commit 83041bd, draftcheck keys a statement by file, function, and seq

`compile_due` and the draftcheck key are `(file, function, seq)`, and seq 0, the body, gets no key. The new `rejected` table holds the last pass's compile holes under the lowered key. No existing column changed, so `table.sqlite` was not deleted. `bodies.py --compile-holes` drafts the affected functions again in memory, and over the 43 stems with rejected rows its text equals draftcheck's last-pass draft byte for byte. The S35 test was red with no `save_rejected`, then green. A fast test of the deeper loop step was red with the fix taken out and green with it. One gate failure was caught before the commit: the first `--all` run crashed in `save_rejected`, because the gate's error loop reused the name `key` and a tuple reached SQLite. The parameter is now `lowered`.

One departure under S16. `printer.py --compile-holes` puts the three hole lines in place of each rejected statement's rows, deeper rows such as the loop step before a `continue` included. A rejected declaration, or a rejected statement that opens a scratch or choice closure, changes the drafter's later lines through `local_holes`, and the rows cannot show that. For those functions the printer stops with one line that names `bodies.py --compile-holes`. Over the 43 stems, 35 print the same bytes as `bodies.py --compile-holes` and 8 stop.

| Check | Result |
|---|---|
| Fast tool tests | 47 OK in 2 s, 45 before and 47 after |
| Full suite under `SLOW=1` | 47 OK in 149 s |
| `snapshot.py --check` against step 4, cold | exit 0 in 168 s, stderr named `bodies.py` and `draft_statements.py` |
| `draftcheck.py --all` | 107 holes, 0 defects, 106 s |
| `draftcheck.py --game` in four calls | 1357 holes, 0 defects, 224 compile holes, 247 s, 187 s, 239 s, 110 s, all exit 0 |
| `snapshot.py --check`, warm | exit 0 in 26 s |

## Findings the notes did not predict

An edit to `store.py`, a comment included, makes the base facts stale, because `store.py` is in the base modules list. That costs a cold sweep of 75 to 90 seconds in every SLOW test copy and in the next snapshot.

A compile hole on a declaration changes later statements through `local_holes`, so a printer-only view of compile holes cannot be exact for those functions. That is why the printer stops on them.

The builder's early exit codes came from `${pipestatus[1]}` after a `time` pipeline, which printed exit 0 once for a run that had crashed. The earlier codes hold by what the tools printed, "no difference" is the only exit-0 branch of `snapshot.py` and draftcheck exits 0 only on 0 defects. From the step-7 draftcheck runs on, the codes came from `$?` in a log file.

The step-5 patch, the draftcheck logs, and the comparison script are under `/tmp/step5-aside/`.
