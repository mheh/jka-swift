# The walk of 2026-09-29

This walk took the open rows the handoff of 2026-09-28 left. The game gate at 6bbbb37 ran between row 1 and row 2, and its counts are in game-gate.md beside this file. Each closed row closed on a typed ruling under the ratification-walk shape. The record lives in this folder, not in notes/LEDGER.md.

## Ledger

| Row | Subject | Verdict |
|---|---|---|
| 1 | `pushed_p`, the pointer that walks `pushed[]` in g_mover.c across G_TryPushingEntity and G_MoverPush, is a file-scope index into the `pushed` array | ratified as proposed |
| 2 | One fix round makes SABERINVALID of w_saber and SOLID_BBOX of be_aas.h in scope. TYPE_ORIGIN and TYPE_ANGLES left the not-in-scope list at 6bbbb37, so they are out of the row | ratified |
| 2a | SABERINVALID is a HAND_MACROS entry in rulings.py that spells the use as a call to a hand Bool function `saberInvalid(saberent, saberOwner, other)` in JKAMP_GameLogic. The entry carries a Bool flag, so the drafter's type check reads Bool and appends no `!= 0` | ratified |
| 2b | The entry list of each module is derived from the unity parse's include graph, option (a) of unity-parse-proposal.md, with a per-module exclude field in place of the hand list. The first step is a proving run behind a flag that writes nothing and diffs the file lists. be_aas.h and the other 14 game headers reach the generated module through it. The hand lists go only after the diff is read | ratified |
| 2b, amended | The derived list holds every oracle header a .c file of the module includes directly, in order of first reach, minus the module's exclude paths, minus any header that another derived header reaches without a cycle. The filter lands in the derive function in closure.py. The hand lists go after a second proving run with the filter shows the same result as the scratch run, and after the menudef.h path is checked against merge.py. The reason: g_local.h and bg_saga.h have no include guard, so the unfiltered list parses them twice and loses 29 files | ratified |
| 3 | The next defect class after not-in-scope | open, parked until after the fix round of row 2 |
| 4 | The g_main defect count moves by two between identical runs, 57 or 59 | open |
| 5 | The three undocketed findings of notes/drafter-analysis-2026-09-23.md: the one-hop NULL proof, the static local read before written, and Float `sin` and `cos` under a double literal | open |

## The work

1. The fix round of row 2, as rows 2a and 2b rule it. The diagnosis and the proposal are in this folder.
2. Row 1 as a drafter rule, so the one hole in g_mover closes.
3. After the fix round, a class table of the game gate in the shape of notes/game-gate-2026-09-27.md, then row 3.
