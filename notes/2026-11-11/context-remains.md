# What remains of `context.md`

The coordinator's `context.md` at the root of the main tree is removed by row E5. Most of it was history of 2026-10-31 to 2026-11-02. This file holds the sentences that a search found in no doc, no ledger, and not in `.claude/CLAUDE.md`. None of them was checked against the tree of today, so each one needs a check before it goes to its home.

## Facts of the port and the tools, with no doc line

- A file-scope variable of the cgame that the port adds by hand goes on `CGameWorld` in `cg_local.swift`, under the MARK of its file. It does not go on the generated `CGameVariables`.
- `adopt.py` keeps every body that is not the marker pair. So a drafter change after an adoption reaches the file by a reset to the stub and a second adoption, and that is safe only before the first hole round of the file. After a hole round, the change reaches the file through the transcriptor.
- A draft gate over a file that already carries drafts gives a different count from a gate over the stub. A count in a record is the count over the stub.
- `draftcheck.py` counts its passes across the whole unit, so the cap on passes is a budget of the unit and not of one stem.
- One rule in `spelling.py` reaches the traps, the wrappers, and the stubs. A signature row names every function that the rule reaches before the row is ruled.
- A C cast that the port drops is the no-casts rule at that site and not a change by a ruling, so the site takes no `AI:` line.

## Rules of the workflow, with no line in the coordinator file

- After each landing on master, refresh the codegraph index with `codegraph init` in the main tree.
- The permission classifier can block a merge or a worktree removal that the coordinator starts alone. The user's typed word in chat removes the block.

## Possible rows that the user has not seen as rows

- `reexport.py` finds its names from the error lines of a build. A build that fails for another reason gives no names, and the run exits 0. A possible row: a nonzero exit in that case.
- On 2026-10-31 the symbols `level`, the storage field, `cg`, and `cgs` were internal. Rule 25 of `docs/porting-rules.md` makes them public. A possible row: the change of the four symbols.
