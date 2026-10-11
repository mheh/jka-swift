# Phase 2, wave A, the record of the transcriptor "sort"

## Sites

| Site before | Unit | Row | What I wrote |
|---|---|---|---|
| `g_main.swift:1648` | A-38 | A1, D6 | The `SortRanks` signature is `(_ a: Int32, _ b: Int32) -> Int32`. |
| `g_main.swift:1652` | A-38 | A1, D6 | `ca = level.clientsSlots[a]`, the form of `&level.clients[i]` that `CalculateRanks` uses. |
| `g_main.swift:1655` | A-38 | A1, D6 | `cb = level.clientsSlots[b]`. |
| `g_main.swift:1847` | A-39 | A1, D6 | `qsort(level.sortedClients, level.numConnectedClients, SortRanks)`, the `Slots<Int32>` overload with no `&`. |
| `g_main.swift:1996` | A-43 | A2, R9 | Raven's two branches on `gSiegeRoundWinningTeam == SIEGETEAM_TEAM1` and `SIEGETEAM_TEAM2`, each with `G_Find(nil, \.classname, "...")` and `G_UseTargets2(ent!, ent, ent!.target2)` under `if ent != nil && ent!.target2 != nil`. |
| `g_team.swift:1065` | A-40 | A1, D6 | The `SortClients` signature is `(_ a: Int32, _ b: Int32) -> Int32`. |
| `g_team.swift:1066` | A-40 | A1, D6 | `return a - b`. |
| `g_team.swift:1115` | A-41 | A1, D6 | `qsort(&clients, cnt, SortClients)`, the array overload with a count. |

No site was left. No unit needs a new GameWorld property.

## Port-note counts

| File | Before | After |
|---|---|---|
| `g_main.swift` | 14 | 10 |
| `g_team.swift` | 3 | 1 |

The six filled Port-notes match the plan: five in the sort units and one in A-43.

## Findings

1. The task names a Verdict paragraph for A1 and A2 in `docket-proofs-A-B.md`, but that file starts at A3. I used the ledger rows in `frame-path-walk.md`, the proposals in `holes-g_main-g_active.md`, and line 25 of `rulings-build-helpers.md`, which gives the `Slots` call form.
2. The A-43 literals pass to `G_Find` as a `String` or a `String?`, so the call compiles before and after the R9 change of A-29.
3. `G_UseTargets2` takes a non-optional `Entity` as its first parameter, so the call unwraps `ent` once. Raven's guard `ent && ent->target2` makes the unwrap safe.
4. The `clients[cnt++]` hole at `g_team.swift:1108` stays. It is not a unit of this wave, and until it is filled, `clients` holds zeros, so `SortClients` sorts zeros.
5. `g_main.swift` imports `Foundation`, which also exports Darwin's four-argument `qsort`. The three-argument calls resolve to the `JKAMP_BG` overloads by arity, but the compile agent must confirm this.
