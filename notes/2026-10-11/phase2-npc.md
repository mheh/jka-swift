# Phase 2, wave A, the record of the npc transcriptor

This record covers units A-01, A-09, A-10, A-11, A-15, A-17, and A-26 of Part A of `phase-2-plan.md`. Units A-24 and A-42 wait on a ruling, and this transcriptor did not touch `NPC_combat.swift:130` or the `?? ""` lines at `NPC_combat.swift:1315`, `:1322`, `:1434`, and `:1442`. The line numbers before are the lines of `wave-0` at a1b6196.

## Sites

| File:line before | Unit | Row | What the site holds now |
|---|---|---|---|
| `NPC_utils.swift:665` | A-01 | G1, J4 | `bSID = bState_t(GetIDForString(BSTable, bs_name!))` |
| `NPC_utils.swift:682` | A-01 | G1, J4 | ``G_DebugPrint(WL_VERBOSE, "...", `self`.targetname ?? "", GetStringForID(BSETTable, bset) ?? "", bs_name!)``, the J4 form |
| `NPC_AI_Jedi.swift:1991` | A-09 | I2 | The store drops, and the arm keeps `//medium speed parry` and the one I2 comment line that quotes Raven. |
| `NPC_AI_Jedi.swift:3122` | A-26 | R1 | `let scale = Double(enemy_movespeed) * 0.001 * Double(prediction)` and three per-component stores `enemy_dest[n] = Float(Double(...) + Double(enemy_movedir[n]) * scale)` |
| `NPC_senses.swift:657` | A-10 | I5 | An ascending loop from `j = i` to `MAX_ALERT_EVENTS - 2` with `level.alertEvents[j] = level.alertEvents[j + 1]` |
| `NPC_senses.swift:698` | A-10 | I5 | The same loop from `j = oldestEvent` |
| `NPC_spawn.swift:960` | A-11 | J2 | Three element stores `ucmd.angles[n] = client!.pers.cmd.angles[n]` |
| `NPC_combat.swift:2208` | A-15 | T3 | `if level.combatPoints[i].occupied == true {`, `i += 1`, `continue`, `}` |
| `NPC_AI_Rancor.swift:509` | A-17 | R14 | Raven's trailing comment `//, HL_NONE );//` after the `G_Damage` call |
| `NPC_AI_Rancor.swift:551` | A-17 | R14 | Raven's trailing comment `//, HL_NONE );` after the `G_Damage` call |

No site was left. No unit needs a new GameWorld property in `g_local.swift`.

## Port-note counts

| File | Before | After |
|---|---|---|
| `NPC_utils.swift` | 9 | 7 |
| `NPC_AI_Jedi.swift` | 5 | 4 |
| `NPC_senses.swift` | 4 | 2 |
| `NPC_spawn.swift` | 23 | 22 |
| `NPC_combat.swift` | 3 | 2 |
| `NPC_AI_Rancor.swift` | 0 | 0 |

The six files hold 44 Port-notes before and 37 after. The 7 filled Port-notes are the 7 holes of A-01, A-09, A-10, A-11, and A-15. A-17 and A-26 are hand changes and fill no Port-note.

## Findings

1. The G1 proof and the J4 proof give different third arguments at `NPC_utils.swift:682`. G1 writes `bs_name ?? ""`, and J4 writes `bs_name!`. The ledger row of J4 says that `bs_name` takes `!` after Raven's `VALIDSTRING` guard, so the site takes `bs_name!`. The guard at the top of `G_ActivateBehavior` returns when the text is NULL, so the unwrap cannot trap.
2. The `G_DebugPrint` call at `NPC_utils.swift:682` is the runtime-test case of V14. The site takes `?? ""` for `targetname` and for the `GetStringForID` result, as the J4 proof gives. Guide lines 339-340 already read `?? "(null)"` for this case. If V14 rules yes, these two arguments change to `?? "(null)"` with the four lines of A-42.
3. The R1 ledger row names three `_VectorMA` sites with a double scale. In the six files of this transcriptor, only A-26 has a `Float(Double(...))` scale. Plan note 7 agrees.
4. At A-26, the Swift now computes in `Double` and narrows once at each store, as Raven's macro does. jka-rust `NPC_AI_Jedi.rs:4531-4534` narrows the scale to `f32` first, so jka-rust and this port can differ by one ulp at this site.
5. At A-11, jka-rust `NPC_spawn.rs:864` writes one array copy. The three element stores give the same result.
