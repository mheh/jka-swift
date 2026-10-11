# Phase 2, wave A, the review of the transcriptors "find" and "sort"

The diff is `git diff HEAD -- <files>` at a1b6196, read once at the start. The seven files hold 24 hunks with 26 changed sites. The Swift lines are the lines after the change. The C lines are lines of `oracle/codemp/game/`.

## Hunks

| File and line | C line | Unit | Row | Verdict |
|---|---|---|---|---|
| `g_utils.swift:270` | `g_utils.c:222` | A-29 | R9 | match |
| `g_utils.swift:291` | `g_utils.c:237` | A-29 | R9 | match |
| `g_target.swift:42` | `g_target.c:24` | A-30 | R9 | match |
| `g_target.swift:410` | `g_target.c:408` | A-30 | R9 | match |
| `g_target.swift:689` | `g_target.c:694` | A-30 | R9 | match |
| `g_target.swift:709` | `g_target.c:716` | A-30 | R9 | match |
| `g_trigger.swift:1390` | `g_trigger.c:1510` | A-31 | R9 | match |
| `g_trigger.swift:1500` | `g_trigger.c:1620` | A-31 | R9 | match |
| `g_trigger.swift:1513` | `g_trigger.c:1633` | A-31 | R9 | match |
| `g_trigger.swift:1542` | `g_trigger.c:1664` | A-31 | R9 | match |
| `g_trigger.swift:1683` | `g_trigger.c:1803` | A-31 | R9 | match |
| `g_trigger.swift:1696`, `:1702` (one hunk) | `g_trigger.c:1818`, `:1824` | A-31 | R9 | match |
| `g_misc.swift:2030` | `g_misc.c:2396` | A-32 | R9 | match |
| `g_misc.swift:2048` | `g_misc.c:2418` | A-32 | R9 | match |
| `g_misc.swift:2718` | `g_misc.c:3274` | A-32 | R9 | match |
| `g_misc.swift:2815` | `g_misc.c:3422` | A-32 | R9 | match |
| `g_mover.swift:1792` | `g_mover.c:1805` | A-33 | R9 | match |
| `g_mover.swift:1823` | `g_mover.c:1836` | A-33 | R9 | match |
| `g_mover.swift:2307` | `g_mover.c:2451` | A-25 | N1 | match |
| `g_main.swift:1648`, `:1652`, `:1653` (one hunk) | `g_main.c:1624`, `:1627`, `:1628` | A-38 | A1, D6 | match |
| `g_main.swift:1843` | `g_main.c:1829` | A-39 | A1, D6 | match |
| `g_main.swift:1990` to `:2000` | `g_main.c:1990` to `:2005` | A-43 | A2, R9 | match |
| `g_team.swift:1065`, `:1066` (one hunk) | `g_team.c:1089`, `:1090` | A-40 | A1, D6 | match |
| `g_team.swift:1113` | `g_team.c:1128` | A-41 | A1, D6 | match |

## Checks

`G_Find`: Raven's body skips a slot that is not in use, skips a NULL field, and returns the slot when `!Q_stricmp(s, match)`. The Swift body keeps the two skips and calls `Q_stricmp(s, match) == 0` with the optional `s`. The call binds to `Q_stricmp(_ s1: String?, _ s2: String?)` at `Sources/JKAShared/q_shared.c.swift:819`, because both arguments are `String?`. That overload returns -1 when either argument is nil, as `q_shared.c:900` does with `(s1 && s2) ? ... : -1`.

`G_Find` with a NULL `match`: Raven compares every live slot with a non-NULL field, gets -1 each time, and returns NULL at the end of the list. The Swift body gets -1 from the overload at each slot and returns nil. The result is the same at all 18 changed callers, and a nil `self.target` no longer traps at the old force unwrap. jka-rust keeps `match` as `&str` and handles a None target at the caller with `None => null_mut()` (`g_target.rs:1003`, `:1029`), which gives the same result.

The callers: each Swift call passes the same `from` argument (`nil`, `t`, `target`, or `next`), the same field, and the same match field as Raven's call. The form is the ruled form of R9 exactly, for example ``while let next = G_Find(t, \.targetname, `self`.target) {`` at `g_target.swift:689`. The `path!` at `g_mover.swift:1823` is Raven's `path->target` dereference and is outside the ruling.

`numChunks`: Raven writes `numChunks *= self->radius`, an `int` times a `float`, truncated to `int` at the store. The Swift `numChunks = Int32(numChunks * self.radius)` uses the `Promotion.swift:12` operator `* (Int32, Float) -> Float`, which converts the left side to `Float`. That is the N1 form, with no `Float(numChunks)`. jka-rust writes `(num_chunks as f32 * (*self_).radius) as c_int` at `g_mover.rs:2867`, the same arithmetic.

`SortRanks`: Raven reads `&level.clients[*(int *)a]`. The Swift reads `level.clientsSlots[a]`, the same form that `CalculateRanks` and `CheckTournament` use for a client by number. The rest of the body is unchanged. jka-rust reads `(*world).clients.as_mut_ptr().add(ia as usize)` with an `(c_int, c_int)` comparator, the same shape.

`CalculateRanks`: Raven calls `qsort(level.sortedClients, level.numConnectedClients, sizeof(level.sortedClients[0]), SortRanks)`. The Swift `qsort(level.sortedClients, level.numConnectedClients, SortRanks)` drops the `sizeof` as D6 rules, with no `&`, as `rulings-build-helpers.md` line 25 gives it. The call binds to `qsort(_ a: Slots<Int32>, _ n: Int32, _ cmp: (Int32, Int32) -> Int32)` at `Sources/JKAMP_BG/bg_lib.swift:59`, which sorts a copy through `qsortSpan`, the port of `bg_lib.c:110`, and writes the first `n` slots back. Darwin's `qsort` takes four arguments, so it does not compete.

`SortClients` and `TeamplayInfoMessage`: Raven returns `*(int *)a - *(int *)b`. The Swift returns `a - b` over two `Int32` values. The operands are client numbers below 32, so the subtraction cannot overflow. The call `qsort(&clients, cnt, SortClients)` binds to `qsort<T>(_ a: inout [T], _ n: Int32, _ cmp: (T, T) -> Int32)` at `bg_lib.swift:53`. `clients` holds 32 elements and `cnt` stops at `TEAM_MAXOVERLAY`, so the span stays in the array. jka-rust calls `qsort(&mut clients[..cnt as usize], SortClients)` at `g_team.rs:1378`.

`FindIntermissionPoint`: Raven's two branches compare `gSiegeRoundWinningTeam` with `SIEGETEAM_TEAM1` and `SIEGETEAM_TEAM2`. The A2 entry makes the global `Int32` (`rulings.py:164`, `GameVariables.swift:599`), so the compares are Raven's lines. Each branch calls `G_Find(nil, \.classname, ...)` with Raven's literal and tests `ent != nil && ent!.target2 != nil`, Raven's `ent && ent->target2`, before `G_UseTargets2(ent!, ent, ent!.target2)`. The first parameter of `G_UseTargets2` is a non-optional `Entity` at `g_utils.swift:548`, and the guard makes the unwrap safe. jka-rust has the same two branches at `g_main.rs:1256` to `:1283`.

House rules: no hunk adds a cast that Raven did not write. Every index is a C integer. No hunk adds a comment line. The Port-note count falls by 4 in `g_main.swift` (two in `SortRanks`, one in `CalculateRanks`, one in `FindIntermissionPoint`) and by 2 in `g_team.swift`. Each filled hole lost its Port-note line, its Raven-wrote line, and its `portMissing` call. The find units fill no hole, and their Port-note counts do not change. No other line in the seven files changed.

## Findings

No hunk differs from Raven's C or from the ruled form. The review has no finding.

## Open items outside the diff

1. Eight callers still pass a force-unwrapped `String?` of a field to `G_Find`: `g_mover.swift:1261`, `:1268`, `:1306`, `:1316`, `g_utils.swift:563`, `ai_wpnav.swift:1565`, `g_saga.swift:1497`, and `g_client.swift:700`. Raven passes the pointer as it is, so a NULL field there gives NULL in C and a trap in Swift. R9 does not name these sites, and the coordinator decides them.
2. The `clients[cnt++]` hole at `g_team.swift:1106` stays open, so `cnt` stays 0 and the A-41 sort sorts no elements until that hole is filled.
3. `SortRanks` keeps `var ca: Client?` and `ca!` at each read. The R-row verdict on record pointer locals set from `&table[i]` asks for a plain local through a drafter rule. That rule names `gentity_t *` locals, and this is a `gclient_t *` local, so it is a candidate for the same rule, not a defect of this wave.
