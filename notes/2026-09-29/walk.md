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

## The review walk

After 8e17b5c landed, the review in unity-parse-review.md gave seven rows. Each closed on a typed ruling.

| Row | Subject | Verdict |
|---|---|---|
| R1 | A name rule HEADER_PRELUDES in rulings.py maps a header to a slice of a .c file, interpreter.h to lines 20 to 44 of g_ICARUScb.c, and the parser writes the slice into the synthetic unit before the include. The .c enum test exempts names a prelude defines, and the umbrella places that constants file before the interpreter enums through R2 | ratified as proposed |
| R2 | merge.py orders each target's umbrella by the position of each file's first source header in the emitting module's own umbrella order. Then the ui/menudef.h exclude goes from the game spec | ratified as proposed |
| R3 | After the header parse, extract checks that every header of the unfiltered derived list stands in the parsed file order, and exits with the missing names | ratified as proposed |
| R4 | The derive function takes an optional translation unit, and extract parses the unity unit once and hands it over. The Parse object's overlay parse stays separate | ratified as proposed |
| R5 | A HandMacro dataclass in rulings.py with the fields spelling, reason, and swift, default none. The skeleton and the drafter read a field, not an index | ratified as proposed |
| R6 | docs/oracle-closure.md states the rule only: a spec with an entry field uses it, a spec without one derives its list from its source glob. No module names | ratified as proposed |
| R7 | The cgame and ui specs lose their hand lists after three things are true: the five cgame struct text changes are explained by the macro that causes them, the lowercase g2.h claim is checked and the derive function takes the on-disk spelling if a real one exists, and R2 has landed | ratified as proposed |

## The rounds of the review walk

R1 to R6 landed in one round. Along the way extract's include lists proved to be sorted, so the umbrella never followed Raven's order, and that is fixed with R2. The prelude slice is lines 31 to 44 of g_ICARUScb.c, since lines 20 to 30 are a comment and two conditionals. The reach check compares against the file order plus the parse's include list, since three headers have no top-level cursor under C. The gate after the round: build 0 errors, 106 tests, bg 97 holes and 0 defects, game 1579 holes and 1171 defects with 0 not in scope.

R7 did not land. Both conditions hold: the cgame struct changes are only the owner of MAX_QPATH and NUM_CROSSHAIRS, each defined twice with one value, and four cgame files include ghoul2/g2.h in lowercase with a backslash, so the derive function takes the on-disk case. The switch then fails in merge on STRING_POOL_SIZE, which R9 rules.

| Row | Subject | Verdict |
|---|---|---|
| R8 | When a re-exported macro has the name of an enumerator of the same target, the enumerator wins and reexport writes no line for the macro. Four color names today | ratified as proposed |
| R9 | When two modules read a different text for one header macro, merge places that header's constants file per module in each module's own target, as the .c constants files are. When they agree, the shared placement stands | ratified as proposed |

R9 and R7 landed in one round, uncommitted with R1 to R8. The whole constants file goes per module, since a per-macro split cannot keep merge's shape. Every multiplayer spec now derives its entry list. Gate: build 0 errors, 106 tests, bg 97 holes and 0 defects, game 1579 holes and 1171 defects with 0 not in scope. The game gate alone runs past ten minutes.

| Row | Subject | Verdict |
|---|---|---|
| R10 | A type both modules read the same, that includes a constants file placed per module, is itself placed per module, one copy per emitting module and none for a bg parse. Eight ui_shared types today | ratified as proposed |
