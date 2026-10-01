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
