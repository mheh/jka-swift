# The review of the rulings build, phase 1

A read-only review of the uncommitted working tree on `wave-0` at 3222d10 against the ledger and "The work the rulings order" in `frame-path-walk.md`, the Verdict paragraphs of the `docket-proofs-*.md` records, and the six conflict verdicts. No build, no test, and no generator ran. The diff holds 95 changed files and 4 new Swift files, of which 64 are manifest output and 10 are generated Swift.

Counts: 52 checks, 48 matches, 1 mismatch, 3 beyond the ruling, and 4 style notes. No changed line adds a cast that Raven did not write in a body. No changed line adds a `Slots(rows:)` accessor or a read past a short table, and the retype of the five `vec3_t[N]` fields removes the row-store trap of U1.

## Checks

| # | File and line | Row | Verdict |
|---|---|---|---|
| 1 | `Sources/JKAMP_BG/bg_lib.swift:47` | D6 | match, `qsort` is public |
| 2 | `Sources/JKAMP_BG/bg_lib.swift:53` | D6 | match, the count overload calls `qsortSpan(&a, 0, Int(n), cmp)` |
| 3 | `Sources/JKAMP_BG/bg_lib.swift:59` | A1 | match, `Slots<Int32>` overload with an `(Int32, Int32) -> Int32` comparator |
| 4 | `Sources/JKAShared/CharBuf.swift:77` | B5 | match, `zero(count:)` beside `zero()` |
| 5 | `Sources/JKAShared/Format.swift:57` | D1 | match, `.integer(self ? 1 : 0)` |
| 6 | `Sources/JKAShared/Scan.swift:212` | D2 | match, the signature of the verdict, format order, count read, a target past the stop kept |
| 7 | `Sources/JKAShared/Bool+Int32.swift:4` | D3, I1 | match, `self = value != 0` |
| 8 | `Sources/JKAMP_GameLogic/g_utils.swift:375` | D7 | match, copy, call, write back `0..<count`, cite `g_utils.c:252` is correct |
| 9 | `Sources/JKAMP/EntityState+Bones.swift:9`, `:15` | F2, J5, Q2, conflict 4 | match, the four `int` and four `vec3_t` fields are adjacent at `q_shared.h:2799-2802` and `:2811-2814` |
| 10 | `Sources/JKAMP/Vehicle+Orientation.swift:9` | J3 | match, `m_vOrientation` is `float *` at `bg_vehicles.h:552` |
| 11 | `Sources/JKAShared/NativeBytes.swift:6`, `:17` | L1 | match, native byte order |
| 12 | `Sources/JKAShared/q_shared.c.swift:974` | L2 | match, the suffix-and-write-back body of `Q_strcat` at line 891 |
| 13 | `Sources/JKAShared/Promotion.swift:48` | L3 | match, adds 1 or 0, the example `isfog += G_SpawnInt(...)` is Raven's `g_misc.c:708` |
| 14 | `Sources/JKAMP_GameLogic/ai_main.swift:775` | O5 | match, the suffix-and-write-back body |
| 15 | `Sources/JKAShared/q_shared.c.swift:819` | R9 | match, -1 for nil as `q_shared.c:901` |
| 16 | `Sources/JKAMP_GameLogic/g_saga.swift:98` | A2 | match, `Int32` over the `Int32` storage, Raven's `qboolean gSiegeRoundWinningTeam = 0;` at `g_saga.c:38` |
| 17 | `Sources/JKAMP_GameLogic/g_saga.swift:678` | A2 | match, Raven's `gSiegeRoundWinningTeam = winningteam;` at `g_saga.c:688` |
| 18 | `tools/oracle-closure/rulings.py:157-164`, `skeleton.py:507-510`, `GameVariables.swift:599` | A2 | match, the comment names `qboolean` and the team numbers |
| 19 | `tools/oracle-closure/rulings.py:329-331`, `.claude/manifest/g_utils.md:22` | R9 | match, `_ match: String?` |
| 20 | `tools/oracle-closure/rulings.py:216`, `:254-259`, `spelling.py:258-260`, `g_team.md:39`, `g_main.md` | A1, D6 | match, `SortClients` and `SortRanks` read `(_ a: Int32, _ b: Int32) -> Int32` |
| 21 | `tools/oracle-closure/views.py:663`, `:683-686`, both `Callbacks.swift` | A3 | match, one `!=` beside each of the 12 `==`, `EntityTouch` at `JKAMP_Game/.../Callbacks.swift:56` |
| 22 | `tools/oracle-closure/views.py:279-284`, `:360-373`, `Parms.swift:68`, `Level.swift:294` | H3, R4, conflict 6 | match, `Slots<CharBuf>` rows of 64 and `MAX_STRING_CHARS` bytes |
| 23 | `tools/oracle-closure/spelling.py:226-229`, `GNPC.swift:629`, `Vehicle.swift:187`, `:190`, `SaberTrail.swift:109`, `:112` | M2, S2, U1, D8, conflict 3 | match, five fields `Slots<vec3_t>` through `Slots(vectors:count:)`, no second accessor |
| 24 | `tools/oracle-closure/skeleton.py:807-856`, `JKAMP_GameLogic/Generated/Callbacks.swift` | J1 | match, 13 `Pain` thunks and `Touch.NPC_Touch`, the 13 new names of Raven's `NPC_spawn.c:109-203` stores |
| 25 | `.claude/manifest/g_spawn.md:13` | L3 | match, `_ out: inout JKAShared.vec3_t` |
| 26 | `tools/oracle-closure/traps.py:198`, `:289-356`, `g_syscalls.swift:1376` | O4 | match, cite `g_syscalls.c:845` is correct |
| 27 | `draft_declarations.py:584-607`, `draft_expressions.py:125-137`, `:442-444`, `draft_statements.py:538-540`, `:691-697`, `bodies.py:258-259` | R3, L1 | match, `[UInt8]` storage, a truncating store, a widened read |
| 28 | `draft_declarations.py:403-480`, `draft_classification.py:690-691`, `bodies.py:168`, `:243` | R7 | match |
| 29 | `draft_classification.py:363-410`, `draft_statements.py:556-560` | O2 | match for the NULL store |
| 30 | `draft_declarations.py:327-328` | O2 | beyond the ruling, see Finding 2 |
| 31 | `docs/transcription.md:325` | A4 | match |
| 32 | `docs/transcription.md:552` | A5 | mismatch, see Finding 1 |
| 33 | `docs/transcription.md:539` | A6, F1 | match |
| 34 | `docs/transcription.md:545-546` | B1 | match, the comment follows `w_saber.swift:2266` |
| 35 | `docs/transcription.md:659` | B2 | match |
| 36 | `docs/transcription.md:654`, `:656` | B3 | match |
| 37 | `docs/transcription.md:553` | B4, C1 | match |
| 38 | `docs/transcription.md:179-180` | B5 | match |
| 39 | `docs/transcription.md:419-420` | B6 | match |
| 40 | `docs/transcription.md:337` | C2, S1, conflict 2 | match |
| 41 | `docs/transcription.md:622` | D4, O3, Q1 | match |
| 42 | `docs/transcription.md:623-624` | D5, I4, Q4, T1 | match |
| 43 | `docs/transcription.md:540` | E2, H2, P1, T2, conflict 1 | match |
| 44 | `docs/transcription.md:367-369` | F3, M3, Q3, I3 | match |
| 45 | `docs/transcription.md:554` | N1 | match |
| 46 | `docs/transcription.md:162` | O4 | match |
| 47 | `docs/transcription.md:153` | O5 | match |
| 48 | `docs/transcription.md:251` | R1 | match |
| 49 | `docs/transcription.md:339-340` | R2, C1, U2 | match, with a side effect in the Unruled section |
| 50 | `docs/transcription.md:555` | R5 | match |
| 51 | `docs/transcription.md:342` | R10 | beyond the ruling, see Finding 3 |
| 52 | `notes/2026-10-09/load-test-walk.md:73` | none | beyond the ruling, see Finding 4 |

## Findings

1. Mismatch, A5, `docs/transcription.md:552`. The verdict reads: "C's `sizeof` is Swift's `stride`, and for `gentity_t` the two are 1832." The proof reads: "C's `sizeof` is Swift's `stride`, and `size` differs only by tail padding." The guide line reads: "Raven's `sizeof(T)` stored into an `int` is `Int32(View.byteCount)`, the size of one slot". `byteCount` is `MemoryLayout<T>.size` (`Entity.swift:28`), and one slot is `stride`. The gloss "the size of one slot" is true only where the two are equal, and the line gives the form for every `T` with no word on the difference. The builder record lists this as Unruled item 8 of the guide record.

2. Beyond the ruling, O2, `draft_declarations.py:327-328`. The verdict reads: "a `NULL` store that no read reaches before the allocator store drops under one comment that quotes Raven". The diff drops a NULL initializer on the declaration with no comment: `return declared + (f"\n_ = ..." if init and not self.is_null(init[0]) else "")`. Only the statement form at `draft_statements.py:556-560` writes the comment. The generator record names the initializer case but not the missing comment.

3. Beyond the ruling, R10, `docs/transcription.md:342`. The verdict reads: "line 340 gains the form for an early-out whose arm does work". The diff removes the sentence "A guard that does other work on the NULL path keeps a Port-note." and puts the new form in its place. The guide record lists this as Unruled item 3.

4. Beyond the ruling, `notes/2026-10-09/load-test-walk.md:73`. Row X1 changes from "open" to "ratified as proposed". No row of the frame-path docket orders it, and no record of 2026-10-11 names the ruling. The line belongs to the records commit, not to the code commit of phase 1.

5. Style, `tools/oracle-closure/rulings.py:162`. Two sentences stand on one comment line: "... or SIEGETEAM_TEAM2. Ruling A2 of 2026-10-11."

6. Style, `tools/oracle-closure/rulings.py:255`. Two sentences stand on one comment line: "The hand qsort of bg_lib.swift takes `(Int32, Int32) -> Int32`. Rulings A1 and D6 of 2026-10-11."

7. Style, `tools/oracle-closure/traps.py:293`. Two sentences stand on one docstring line: "... reaches a logic target. Ruling O4 of 2026-10-11."

8. Style, `tools/oracle-closure/skeleton.py:809`. Two sentences stand on one docstring line: "because the function returns the local into the field. A local whose type fits more than one field names no field."

## Unruled

These are choices or effects that no proof gives and that the three builder records do not list.

1. R2: the new line 339 gives `?? "(null)"` for every `String?` at a `%s`, and line 340 keeps the `Debug_Printf` runtime-test case under it. Four compiled lines in `NPC_combat.swift` (1315, 1322, 1434, 1442) still pass `NPC!.targetname ?? ""` and `newenemy!.targetname ?? ""`, eight arguments that now disagree with the guide. No phase 2 item in `HANDOFF.md` names them.
2. A1 and D6: the sig table now gives `SortRanks(_ a: Int32, _ b: Int32)` and `SortClients(_ a: Int32, _ b: Int32)`, but the compiled functions at `g_main.swift:1648` and `g_team.swift:1065` still take `OpaquePointer?`. The phase 2 list in `HANDOFF.md` names the `G_Find` signature under R9 but not these two signatures.
3. R9: the sig table gives `_ match: String?`, and the compiled `G_Find` at `g_utils.swift:270` still takes `String`. Phase 2 names this change, so the table and the code disagree until then.
4. The manifest regenerate also carries changes from earlier commits: `public` on `g_entities` and `gSharedBuffer`, refreshed marker counts, and shifted Swift line numbers in 64 files. No row orders these lines, and they are the plain output of `manifest.py`.
5. `HANDOFF.md` at the root is untracked and is not part of phase 1. It says to delete it after the phase 1 commit and review.
6. R3: `narrow_array_names` takes every local array of `short`, `unsigned short`, `signed char`, or `unsigned char`, not only `byte`. A `short` array now drafts as `[Int16]`. The proof names `byte` arrays alone.
7. No `draftcheck.py` and no `snapshot.py --check` ran, so the three drafter rules have no run over the 136 R7 sites or the `G_FilterPacket` and `SavePathData` drafts beyond the tool tests.
