# The frame-path round walk

The walk of the docket rows in `frame-path-round.md`. The user ruled each row on 2026-10-11.

| Row | Verdict | What the ruling orders |
|---|---|---|
| A1 | ratified as proposed | A `qsort` helper over a `Slots<Int32>` with an `(Int32, Int32) -> Int32` comparator that keeps the libc order. Raven's comparator ports as a Swift function over two `Int32` values. The ruling settles D6 too. |
| A2 | ratified as amended | `gSiegeRoundWinningTeam` is a TYPES entry in `rulings.py` as `Int32`. Raven declares it `qboolean` in both the definition at g_saga.c:38 and the extern at g_main.c:1978, and stores and compares a team number, 0, 1, or 2, through it. The entry's comment names Raven's `qboolean` and the team numbers. The store in `SiegeRoundComplete` and the two compares in g_main are Raven's lines. |
