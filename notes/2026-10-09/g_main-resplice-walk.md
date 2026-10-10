# The g_main re-splice walk

The walk of the four docket rows in `g_main-resplice.md`, one row per message under the ratification-walk skill. Every row was ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| D1 | ratified as proposed | A drafter change in the shape of post-spine item 3, so a read of a local declared as a view at `gSharedBuffer` is written plain and not as `sharedMem!`. Then a re-splice of `vmMain`. |
| D2 | ratified as proposed | The g_main reference reads 61 holes and 21 compile holes. The game total reads 1178 holes and 135 compile holes. The post-spine record keeps the counts its run measured. |
| D3 | ratified as proposed | A transcriptor round on `G_InitGame` takes the register call of the shared buffer and the seed call from the draft into the hand body and builds them. The round folds into the first load test under the engine. |
| D4 | ratified as proposed, the transcriptor form | A transcriptor round on `CheckCvars` and `G_GetStringEdString` reads `lastMod` and `text` through their forwards. The user chose the transcriptor round over a drafter rule. |

## The work the rulings order

1. The drafter change of D1 in `draft_declarations.py` or its neighbour, with a test in `tests/test_shapes.py`, and the `vmMain` re-splice.
2. One transcriptor round over `G_InitGame`, `CheckCvars`, and `G_GetStringEdString` for D3 and D4.
3. The next game gate takes the D2 figures as its reference.
