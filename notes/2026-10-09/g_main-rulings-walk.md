# The g_main rulings build walk

The walk of the one docket row in `g_main-rulings-build.md`, under the ratification-walk skill.

| Row | Verdict | What the ruling orders |
|---|---|---|
| R1 | ratified as proposed | The guide gets a form for an implicit `int` to `unsigned` argument: the callee takes an `Int32` overload that converts once inside it. The first case is an `Int32` overload of `srand` in `Sources/JKAMP_BG/bg_lib.swift`, and the `JKAMP_BG.srand(randomSeed)` line of `G_InitGame` then builds, so its Port-note goes. |

## The work the ruling orders

1. The guide form in `docs/transcription.md`, beside the other argument forms.
2. The `srand` overload in `bg_lib.swift` with its `/// Source:` line.
3. The `G_InitGame` line, after the dispatch pass stops editing `g_main.swift`.
