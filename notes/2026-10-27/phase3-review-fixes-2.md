# Review fixes of phase 3, groups 3, 4, and 5

## Drafter rows

- W10a, ruling S2. `tools/oracle-closure/draft_declarations.py:335`: the `_ =` line of a `CHARBUF_ALLOCS` initializer now takes `self.trailing(var)`, so the draft of `NPC_ParseParms` prints `_ = BG_TempAlloc(4096) //G_NewString( value );` for the `saber2` arm, as it does for the `saber` arm.
- W10b, ruling S5. `tools/oracle-closure/draft_calls.py:360-364`: the Slots parameter rule passes the argument as it is when the argument is a record array field of a view, `NPC->client->saber`, whose Swift spelling is its Slots accessor. The draft of `NPC_ParseParms` prints `WP_RemoveSaber(NPC.client!.saber, 1)`. The hole stays for every other argument. The ruled test, `self.slots_expression(inner)` is not `None`, was already the first branch at `draft_calls.py:306`, and it returns `None` for this field, because `slots_member` covers pointer fields that a body indexes and `saber` is a fixed array. So the rule tests the field type itself: a constant array whose element is a record that a view covers.
- Unittest: `.venv/bin/python -m unittest discover -s tests` gives 82 tests, OK, 16 skipped. No test was added.
- Snapshot: `snapshot.py --out /tmp/s-before` before the first tool change and `/tmp/s-after` after the last. 2 files moved, both body files: `bodies/NPC_stats.swift` (the `saber2` comment, the `WP_RemoveSaber` call, and 19 holes to 18) and `bodies/g_cmds.swift` (`WP_SetSaber(ent.s.number, ent.client!.saber, saberNum, String(truncSaberName))` in `G_SetSaber`, and 20 holes to 19). The hand line `g_cmds.swift:1401` already reads the same. No other file moved.

## Hand fixes

- `docs/transcription.md:251`: the period before "Where the scale holds a call".
- `docs/transcription.md:505`: "the two initializers of `CharBuf.swift`, `CharBuf(_ string:)` and `String(_ buf:)`" (ruling S1).
- `Sources/JKAMP_BG/bg_panimate.swift:364` and `:538` (now `:364-412` and `:586-663`): the draft heads of `BG_SaberInSpecialAttack` and `BG_InDeathAnim` replace the two joined hand heads, one label per line. The labels match the hand heads with comments stripped. The splice added 80 comment lines, 2 in the first head and 78 in the second.
- `Sources/JKAMP_GameLogic/NPC_stats.swift:1641`: `_ = BG_TempAlloc(4096) //G_NewString( value );`.
- `Sources/JKAMP_GameLogic/w_saber.swift:2026`: two comment lines, one sentence each.
- `notes/2026-10-11/count-corrections.md`, item (d): "stood ... before the W3 fill".
- `notes/2026-10-11/count-corrections.md`, item (e): the W32 quote (ruling S4).
- `notes/2026-10-11/phase-2-plan.md:140`: "Five `pm` holes ... guide lines 323 (A4)" (ruling S4).
- `notes/2026-10-27/phase3-hand-sites.md`, section V37: one sentence that the review found two missed heads in `bg_panimate.swift` and this round wrote them with 80 comment lines.

## Gate

- `swift build`: 0 errors.
- `swift test --no-parallel`: 112 tests in four binaries (84, 14, 13, 1), all passed.
- `tools/load-test.sh`: exit 0.

## Blocked items

- None.
