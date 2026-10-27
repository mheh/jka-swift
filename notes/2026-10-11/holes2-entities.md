# Wave B holes, transcriptor entities

This record covers the hole round of wave B of phase 2 for `g_utils.swift`, `g_target.swift`, `g_misc.swift`, `g_cmds.swift`, `g_client.swift`, `g_saga.swift`, `g_team.swift`, and `g_mover.swift` under `Sources/JKAMP_GameLogic/`. The line numbers are the lines of `wave-0` at 4308ee3, before the edit. The guide lines are the lines of `docs/transcription.md` at the same commit.

## The holes

| File:line before | Function | Row or guide line | Result |
|---|---|---|---|
| `g_utils.swift:109` | `BuildShaderStateConfig` | B5, guide line 179 | Filled: `buff.zero(count: MAX_STRING_CHARS)`. |
| `g_utils.swift:632` | `vtos` | B6, guide lines 419-421 | Filled: Raven's `static char str[8][32]` drops, with one comment line on the ring. |
| `g_utils.swift:635` | `vtos` | B6, guide lines 419-421 | Filled: `var s = CharBuf(32)`. |
| `g_utils.swift:640` | `vtos` | B6, guide lines 419-421 | Filled: `s = str[index]` and `index_vtos = (index_vtos + 1) & 7` drop, and the `index_vtos` forward at `g_utils.swift:612-617` drops. |
| `g_utils.swift:645` | `vtos` | B6 | Filled: `Com_sprintf(&s, 32, "(%i %i %i)", Int32(v[0]), Int32(v[1]), Int32(v[2]))`. |
| `g_utils.swift:649` | `vtos` | B6 | Filled: `return String(s)`. |
| `g_target.swift:210` | `Use_Target_Print` | Q1, guide lines 624 and 339 | Filled: `let message = CharBuf(ent.message!)`, then `if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {` with Raven's two arms and `ent.message ?? "(null)"` at each `%s`. The activator arm passes `activator.s.number` for `activator-g_entities`. |
| `g_target.swift:220` | `Use_Target_Print` | Q1, guide lines 624 and 339 | Filled: `let message = CharBuf(ent.message!)`, then `if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {` with Raven's two arms and `ent.message ?? "(null)"` at each `%s`. |
| `g_target.swift:225` | `Use_Target_Print` | Q1, guide lines 624 and 339 | Filled: `let message = CharBuf(ent.message!)`, then `if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {` with Raven's two arms and `ent.message ?? "(null)"` at each `%s`. |
| `g_target.swift:232` | `Use_Target_Print` | Q1, guide lines 624 and 339 | Filled: `let message = CharBuf(ent.message!)`, then `if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {` with Raven's two arms and `ent.message ?? "(null)"` at each `%s`. |
| `g_target.swift:774` | `scriptrunner_run` | D5, guide line 625 | Filled: ``` `self`.activator!.script_targetname = va("newICARUSEnt%d", numNewICARUSEnts) ```, then `numNewICARUSEnts += 1`. |
| `g_misc.swift:716` | `SP_misc_skyportal` | L3, `Int32 += Bool` of `Promotion.swift:48` | Filled: `isfog += G_SpawnVector("fogcolor", "0 0 0", &fogv)`. |
| `g_misc.swift:719` | `SP_misc_skyportal` | L3 | Filled: `isfog += G_SpawnInt("fognear", "0", &fogn)`. |
| `g_misc.swift:722` | `SP_misc_skyportal` | L3 | Filled: `isfog += G_SpawnInt("fogfar", "300", &fogf)`. |
| `g_cmds.swift:168` | `ConcatArgs` | guide line 661 | Filled: `strncpy(&line, String(arg), tlen, at: len)`. |
| `g_cmds.swift:197` | `SanitizeString` | B3, guide line 658 | Filled: Raven's loop over the two `Int32` cursors `inIndex` and `outIndex`, with ``out[outIndex] = tolower(Int32(UInt8(truncatingIfNeeded: `in`[inIndex])))``. |
| `g_cmds.swift:1755` | `Cmd_GameCommand_f` | guide line 555 | Filled: `if order < 0 \|\| order > gc_orders.count { return }`. See finding 3. |
| `g_client.swift:1404` | `ClientCleanName` | none | No form, shape: `ColorIndex(*in)`, where `ColorIndex` at `Sources/JKAShared/q_shared.h.swift:39` takes a `CChar` and the `TextCursor` read gives an `Int32`. The proposed form is an `Int32` parameter on `ColorIndex` under the narrow-type rule of guide line 528, an edit outside the read set. |
| `g_client.swift:3240` | `ClientSpawn` | B1, guide lines 545-546 and 556 | Filled: the two typed terms `healthSpan: Int32` and `healthLoss: Float` under the split comment, then `client!.ps.stats[STAT_MAX_HEALTH] = Int32(g_powerDuelStartHealth.integer - healthLoss)` and the two chained stores. |
| `g_saga.swift:1275` | `SiegeItemRespawnOnOriginalSpot` | none | No form, shape: a view parameter that Raven's callee tests for NULL, and a caller chain that passes NULL one hop on. See finding 2. |
| `g_saga.swift:1634` | `SP_misc_siege_item` | Q1, guide line 624 | Filled: `let model = CharBuf(ent.model!)`, then `if Q_stricmp(model[(strlen(model) - 4)...], ".glm") == 0 {` with Raven's comment and `ent.s.modelGhoul2 = 1`. |
| `g_team.swift:1105` | `TeamplayInfoMessage` | D5, guide line 625 | Filled: `clients[cnt] = level.sortedClients[i]`, then `cnt += 1`. |
| `g_mover.swift:2573` | `SP_func_breakable` | none | No form, shape: a `char *s = NULL` text local that Raven passes to the `out_string` parameter of `G_SpawnString`, which always sets it, and then tests for NULL. The local is `String?`, and the parameter is `inout String`. A proposed form is a `String` local with the default text, because `G_SpawnString` stores `defaultString` on the miss path, and Raven's NULL test then reads as `!s.isEmpty`. |

## Port-note counts

| File | Before | After |
|---|---|---|
| `g_utils.swift` | 6 | 0 |
| `g_target.swift` | 5 | 0 |
| `g_misc.swift` | 3 | 0 |
| `g_cmds.swift` | 3 | 0 |
| `g_client.swift` | 2 | 1 |
| `g_saga.swift` | 2 | 1 |
| `g_team.swift` | 1 | 0 |
| `g_mover.swift` | 1 | 1 |
| Total | 23 | 3 |

The round fills 20 holes, and three have no form.

## GameWorld properties

Adds: none.

Drops: the property `var index_vtos: Int32 = 0` and its two doc lines at `Sources/JKAMP_GameLogic/g_local.swift:788-790`, under B6. The forward in `g_utils.swift` has dropped already, and no other file reads `index_vtos`.

## Findings

1. The Q1 ruling of `frame-path-walk.md:66` and guide line 624 give the form for the four `message` holes and the `model` hole, and `phase-2-plan.md:144` was wrong to list them as having no form. The coordinator confirmed this, and the five holes are filled. The `SP_misc_siege_item` site traps on a model name under 4 bytes, where C reads outside the buffer, as the Q1 text says.
2. `SiegeItemRemoveOwner` at `g_saga.swift:1242` takes `carrier: Entity`, but Raven's body at `g_saga.c:1344` tests `if (carrier)`, and `SiegeItemThink` at `g_saga.swift:1326` passes `nil` to `SiegeItemRespawnOnOriginalSpot`, which passes it on. The force unwrap of guide line 338 traps on that path where C does not, so the hole needs a sig ruling that makes `carrier` an `Entity?` and restores Raven's guard in the callee. The callers at `g_saga.swift:1346` and `g_trigger.swift:190` then pass the value with no change.
3. `Cmd_GameCommand_f` keeps Raven's bound test `order > gc_orders.count`, so `order == 7` passes, and `gc_orders[7]` traps in Swift where C reads past the table. The line is Raven's off-by-one, and the trap is the rule 19 divergence. The finding was resolved before the wave B commit.
4. Two file-scope entries of the files carry a `portMissing` initializer and no Port-note, so this round did not touch them: `ctfFlagStatusRemap` at `g_team.swift:11-12`, and `BMS_START`, `BMS_MID`, and `BMS_END` at `g_mover.swift:42-51`. Guide line 447 gives the form, Raven's data in the initializer.
