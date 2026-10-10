# The dispatch fill walk

The walk of the three docket rows in `dispatch-fill.md`, one row per message under the ratification-walk skill. Every row was ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| E1 | ratified as proposed | Each bare function the shell calls goes `public` in its own logic file, and so do `gSharedBuffer`, `g_entities`, and `world`. Rule 11 stands: the shell decodes the words and calls the bare function. The skeleton generator writes the marker on a generated forward, so a skeleton run keeps it. |
| E2 | ratified as proposed | The six game tables with no storage, `setTable`, `TeamTable`, `ClassTable`, `BSTable`, `BSETTable`, and `fields`, take the shape of `Sources/JKAMP/BgTables.swift` as public Slots tables in the game view target. |
| E3 | ratified as proposed | The sixteen `TODO: Port global` lines in JKAMP_BG stay as the generator wrote them and go when the bg files are adopted. |

## The work the rulings order

1. The `public` markers of E1 on the 41 callees and the three globals, in the hand files and in the skeleton generator for the generated forwards.
2. The six tables of E2 in the game view target.
3. The fill of the 38 stubbed arms and the `G_InitGame` call under `GAME_INIT` in `Sources/jampgame/jampgame.swift`, which `dispatch-fill.md` tabulates with each function, file, line, and signature.
