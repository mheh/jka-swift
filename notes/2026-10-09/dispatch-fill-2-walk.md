# The dispatch fill walk, second pass

The walk of the five docket rows in `dispatch-fill-2.md`, one row per message under the ratification-walk skill. Every row was ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| F1 | ratified as proposed | `jampsmoke` and its test send `GAME_GETITEMINDEXBYTAG` and assert the answer. The smoke test proves the load and the dispatch and does not run `G_InitGame`, which needs the engine behind the syscalls. The fill of `jampgame.swift` then commits. |
| F2 | ratified as proposed | The guide gets the form for a `char **` out-parameter that the callee may leave NULL: the arm passes the buffer's own text as the inout and writes the result back. |
| F3 | ratified as proposed | The two private helpers that decode a `const char *` word and a `float *` word stay in the shell, and the guide documents the form. Rule 11 names the shell as a pointer place. |
| F4 | ratified as proposed | The sixteen "A Slots over one record has no form yet" holes over the six game tables fill in the frame-path round, whose first wave reaches `g_spawn` and `g_main`. |
| F5 | ratified as proposed | The logic `vmMain` in `g_main.swift` goes at the next g_main re-splice. The re-splice skips the function or a rule excludes it from the stem, so the drafter does not write it back. |

## The work the rulings order

1. The smoke driver and test change of F1, then the commit of the held fill.
2. The two guide forms of F2 and F3 in `docs/transcription.md`.
3. F4 joins the frame-path round. F5 joins the next g_main re-splice.
