# Phase 2, wave A, the record of the transcriptor "find"

The line numbers are the lines of `wave-0` at a1b6196. Every edit keeps its line, so the lines before are also the lines after.

## Sites

| File and line before | Unit | Row | What I wrote, or left and why |
|---|---|---|---|
| `g_mover.swift:2307` | A-25 | N1 | `numChunks = Int32(numChunks * \`self\`.radius)`, with no `Float(numChunks)`, over the `Promotion.swift` operator `* (Int32, Float) -> Float`. Raven: `g_mover.c:2451`, `numChunks *= self->radius;`. |
| `g_utils.swift:270` | A-29 | R9 | The `G_Find` signature takes `_ match: String?`. The `rulings.py` entry at `tools/oracle-closure/rulings.py:333` already holds `("G_Find", "match")`. |
| `g_utils.swift:291` | A-29 | R9 | `if Q_stricmp(s, match) == 0 {`, Raven's call at `g_utils.c:237`, through the `Q_stricmp(_ s1: String?, _ s2: String?)` overload at `Sources/JKAShared/q_shared.c.swift:819`, which returns -1 for nil. |
| `g_target.swift:42` | A-30 | R9 | `G_Find(t, \.targetname, ent.target)` |
| `g_target.swift:410` | A-30 | R9 | `G_Find(nil, \.targetname, \`self\`.target)` |
| `g_target.swift:689` | A-30 | R9 | `G_Find(t, \.targetname, \`self\`.target)`, the `target_random_use` site of the verdict. |
| `g_target.swift:709` | A-30 | R9 | `G_Find(t, \.targetname, \`self\`.target)`, the second `target_random_use` site. |
| `g_trigger.swift:1390` | A-31 | R9 | `G_Find(nil, \.targetname, \`self\`.target)` |
| `g_trigger.swift:1500` | A-31 | R9 | `G_Find(nil, \.targetname, \`self\`.target)` |
| `g_trigger.swift:1513` | A-31 | R9 | `G_Find(nil, \.targetname, \`self\`.target2)` |
| `g_trigger.swift:1542` | A-31 | R9 | `G_Find(nil, \.targetname, \`self\`.target)` |
| `g_trigger.swift:1683` | A-31 | R9 | `G_Find(t, \.targetname, \`self\`.target)` |
| `g_trigger.swift:1696` | A-31 | R9 | `G_Find(nil, \.targetname, \`self\`.target)` |
| `g_trigger.swift:1702` | A-31 | R9 | `G_Find(t, \.targetname, \`self\`.target)` |
| `g_misc.swift:2030` | A-32 | R9 | `G_Find(target, \.targetname, ent.target)` |
| `g_misc.swift:2048` | A-32 | R9 | `G_Find(target, \.targetname, ent.target2)` |
| `g_misc.swift:2718` | A-32 | R9 | `G_Find(nil, \.targetname, ent.target)` |
| `g_misc.swift:2815` | A-32 | R9 | `G_Find(nil, \.targetname, \`self\`.target)` |
| `g_mover.swift:1792` | A-33 | R9 | `G_Find(nil, \.targetname, ent.target)` |
| `g_mover.swift:1823` | A-33 | R9 | `G_Find(next, \.targetname, path!.target)`. The `path!` stays, because Raven reads `path->target` and the ruling covers only the `target` unwrap. |

No site was left. No unit filled a Port-note hole, so I removed no `// Port-note:` line, no `// Raven wrote:` line, and no `portMissing(...)` call.

### The callers outside the ruling

These calls pass a force-unwrapped `String?` of another field. The R9 ruling does not name them, so they stand as they are until the coordinator decides.

| File and line | Argument |
|---|---|
| `Sources/JKAMP_GameLogic/g_mover.swift:1261` | `door!.targetname!` |
| `Sources/JKAMP_GameLogic/g_mover.swift:1268` | `door!.targetname!` |
| `Sources/JKAMP_GameLogic/g_mover.swift:1306` | `ent!.targetname!` |
| `Sources/JKAMP_GameLogic/g_mover.swift:1316` | `ent!.targetname!` |
| `Sources/JKAMP_GameLogic/g_utils.swift:563` | `string!` |
| `Sources/JKAMP_GameLogic/ai_wpnav.swift:1565` | `targetname!`, not my file |
| `Sources/JKAMP_GameLogic/g_saga.swift:1497` | `paintarget!`, not my file |
| `Sources/JKAMP_GameLogic/g_client.swift:700` | `classname!`, not my file |

## Port-note counts

The count is `grep -c "Port-note:"`.

| File | Before | After |
|---|---|---|
| `g_utils.swift` | 6 | 6 |
| `g_target.swift` | 5 | 5 |
| `g_trigger.swift` | 0 | 0 |
| `g_misc.swift` | 3 | 3 |
| `g_mover.swift` | 1 | 1 |

## Findings

1. The plan names the `rulings.py` entry and the `Q_stricmp` overload as work of R9. Both were already in the tree at a1b6196, so A-29 changed only the signature and the call in the body.
2. `G_Find` now calls `Q_stricmp(s, match)` with the optional `s`, as Raven writes it, in place of `s!`. The `s == nil` test above the call stays, so the result does not change.
3. `lookup.py --help` is not a help flag. The tool reads `--help` as a type name and writes "no type named --help". `lookup.py gentity_t` gives `radius: Float`, which the N1 form at A-25 needs.
4. No GameWorld property is necessary for these units.
