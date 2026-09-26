# The bg adoption walk of 2026-09-24

This walk landed eight bg stems into Sources/JKAMP_BG and ruled on the two drafter rows the adoption surfaced. The drafts came from the tree at 3ca24cf, where the nine bg stems gate at 90 holes. One writer agent per file spliced the drafter's function of the same Raven line over each `portMissing` stub, left every hand function as it was, and deleted the skeleton.py header line, so skeleton.py leaves an adopted file alone. One compile agent then ran the gate. Each row closed on a typed ruling under the ratification-walk shape.

## Adoption

| File | Stubs replaced |
|---|---|
| bg_pmove | 9 |
| bg_slidemove | 5 |
| bg_saber | 43 |
| bg_panimate | 83 |
| bg_saga | 20 |
| bg_g2_utils | 2 |
| bg_vehicleLoad | 16 |
| bg_saberLoad | 30 |

bg_misc had no stubs. A data-table stub, `// TODO: Port global`, and the four partial-body markers inside hand functions of bg_pmove stay. The eight manifests under .claude/manifest read `ported` for each spliced function.

## Ledger

| Row | Subject | Verdict | Commit |
|---|---|---|---|
| 1 | The zero vector spells as `vec3_t()`, a vector with values as `vec3_t(a, b, c)`, no module qualifier | ratified as proposed | this commit |
| 2 | Every body line reads its types by their short names, and the signature keeps the tables' spelling | ratified as proposed | this commit |
| 3 | `fabs` spells as `abs`, because Swift deprecates Foundation's `fabs` | parked | |

Both rows rest on the short-name rule of docs/porting-rules.md: a symbol is never module-qualified in an expression.

Row 1 touched draft_calls.py `SCRATCH_ZEROS`, the two returns of draft_declarations.py, `VectorClear` and `VectorSet` in overlay.py, the storage literal of skeleton.py, and the vector literal of draft_expressions.py.

Row 2 added `short_named()` to draft_declarations.py, which strips `JKAMP.` and `JKAShared.`, and bodies.py applies it to each body line. The main session swept the hand code with the same rule: 245 lines in bg_pmove, 3 in bg_misc, and 2 in Sources/JKAMP_GameLogic/g_local.swift.

## The gate after the walk

The drafts of the eight stems hold 88 holes after both rows, the same count as before them. The build reads 0 errors, and the tests read 1 of 1, 78 of 3 suites, 13 of 2, and 14 of 4, all passed. bg_pmove carries 27 warnings: 9 unused call results, 8 deprecated names, 5 never-mutated variables, 4 "will never be executed" under Raven's `if (0)` blocks at lines 151, 486, 6716, and 8950, and 1 written-but-never-read variable. Three bg_panimate warnings are faithful to Raven and stay unless ruled: the `skip` dead store, `wasLoaded` read only inside his commented block, and the `blendTime` parameter copy.

## Open after the walk

- Row 3, the `fabs` spelling.
- A ruling on the 27 bg_pmove warnings, which the incremental build listed, and a full rebuild for the seven other files.
- bg_lib, the ninth gate stem, which holds four stubs and is not adopted.
