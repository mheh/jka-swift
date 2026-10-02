# The walk of 2026-10-01

This walk closed rows 3, 4, and 5 of the walk of 2026-09-29, and the round for rows 1 and 3 landed at f6218f1. The game gate at b592573 is tabled in game-gate.md beside this file. The rows below opened from that round.

## Ledger

| Row | Question | Verdict |
|---|---|---|
| 1 | The raw pointer to CharBuf sub-shape, 68 lines. 67 are a `char *` local from `B_TempAlloc` at a constant size, passed to `GetValueGroup` or `GetPairedValue`, which take an inout CharBuf, in ai_util and ai_wpnav. Proposed: a name rule `CHARBUF_ALLOCS = {"B_TempAlloc"}` in rulings.py, an allocator whose `char *` result a body holds as a CharBuf of the constant size Raven asks for. The allocation call and its free stay on the page, so the pool keeps Raven's count. The other choice is raw parameters on the two callees, which also take CharBufs from the chat buffer table | ratified as proposed |
| 2 | The g_main gate count is a floor when the jampgame target fails first. The drafted g_main writes `Com_Error` and `Com_Printf` without `public`, so jampgame.swift fails, and that failure cancels the GameLogic compile. g_main read 2 defects at b592573 and reads 48 on equal terms. draftcheck also names every error after the stem's file, so a jampgame.swift error reads as g_main.swift. Two parts: the drafted definitions are public, and the gate keeps the file name of the error | ratified as proposed |
| 3 | Rule 5 shrinks a buffer. For a `(Int32, String)` trap it writes `buf = CharBuf(filled.1)`, so the buffer is the text length, and a later `sizeof(buf)` passes the smaller size. The new filled_call rule copies with `strcpy` and keeps the size. Proposed: rule 5 takes the strcpy form too | ratified as proposed |
| 4 | Entity to Int, 19 lines in g_utils and g_main, from entity parameter walks such as `from++` over `g_entities`. A rule 5 question | ratified 2026-10-01: a walked entity parameter keeps its Entity? signature, and the body takes an index local `<name>Index` at the top, 0 for nil and `s.number + 1` for a stepped parameter, and every read of the parameter in the walk is the table at the index. The same text the walk sweep writes for a walked local |

## The round at f6218f1

Row 1 of 2026-09-29 built: the file-scope walk index. Row 3 built for CharBuf to Int32 (89 to 1), [Int32] to Int32 (30 to 0), String to CharBuf (7 to 1), and the (Bool, String) trap test (3 to 0). The class reads 162 lines. "Extra argument in call" reads 2, from 98.

Gate: build 0 errors, 106 tests in four binaries, bg 97 holes with 0 defects, game 1578 holes with 0 cascade errors and 986 defects.

## The round at 476626c

Row 2 built: a game function that a Swift file of another source target calls is public, and a defect line names the file the compiler names. The drafted g_main also needed a Never rule, since jampgame.swift expects Never from Com_Error. g_main reads 48 defects on equal terms. Row 3 built: rule 5 takes the strcpy form, and no drafted site uses the text form today, so no count moves. Row 1 built: the raw pointer to CharBuf lines go from 67 to 0, ai_util defects from 136 to 3, ai_wpnav from 28 to 7. The fileString site in SavePathData stays a hole, because Raven stores NULL into it before the allocation. Row 4 built for parameter walks with an Int32 index, since s.number is Int32 and the Slots subscript takes any integer type. Entity to Int lines go from 19 to 15. G_Find and target_location_linkup take the form.

The round fixed a shadowed loop variable in the row 2 draftcheck edit, so the restore step copies the mirror back after every stem. The rosetta stones match the views again.

Gate: build 0 errors, 106 tests in four binaries, bg 97 holes with 0 defects, game 1576 holes with 0 cascade errors and 824 defects.

### Rulings on the round

| Row | Question | Verdict |
|---|---|---|
| R1 | The Never rule. A void function with no return statement whose last statement calls a Never function also returns Never. It catches G_Error and Com_Error and matches the hand port. Not in the ratified text of row 2 | ratified as proposed |
| R2 | The 15 Entity to Int lines row 4 does not reach are local walks that start at a slot address, `&g_entities[N]`: e in G_Spawn and G_EntitiesFree, ent in G_RunFrame. The walk sweep reads a bare table and a table plus an offset as a walk start, not a slot address. Proposed: a local that starts at `&table[n]` and that the body steps is a walk over that table | ratified as a docketed open row, not built |
| R3 | The rosetta stones were stale since 03c875d. The generator run brought 22 stones and the index up to date and added 18 stones. Proposed: the catch-up goes in this commit | ratified as proposed |
