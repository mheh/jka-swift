# Review of wave 2A: NPC_spawn, NPC_utils, NPC_AI_Jedi, NPC_senses, NPC_stats, g_ICARUScb

The review reads the fills of commit ead6901 in six files against Raven's C, the jka-rust range of the manifest in the submodule `jka-rust/`, and `docs/transcription.md`.
The commit removes 114 `portMissing` markers in these files and adds none: NPC_spawn 24, NPC_utils 4, NPC_AI_Jedi 29, NPC_senses 16, NPC_stats 20, g_ICARUScb 21.

| File | Function | Finding | Severity | Raven line | Swift line |
|---|---|---|---|---|---|
| NPC_AI_Jedi.swift | Jedi_SetEnemyInfo | Raven's `VectorMA` is the macro of the `#if 1` branch of q_shared.h:1365, so each component computes `v[i] + b[i] * s` in double with `s = *enemy_movespeed * 0.001 * prediction`, and narrows once at the store. The fill narrows `s` to `Float` first and then calls `_VectorMA`, so the multiply and the add run in float. The bits of `enemy_dest` can differ from Raven's. The jka-rust range does the same narrow, and the guide row `VectorMA(a, s, b, c)` to `_VectorMA(a, s, b, &c)` gives this form, so the root is the guide row for a double scale. | behavior | oracle/codemp/game/NPC_AI_Jedi.c:3784 | Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:3122 |
| g_ICARUScb.swift | G_DebugPrint | Raven passes `g_entities[entNum].script_targetname` to a `%s` with no NULL test. The fill force-unwraps it, so the call traps where Raven's `vsprintf` prints `(null)`. `entNum` is often 0 here, the `sscanf` result of a text with no number, and the player slot has no `script_targetname`, so the trap is likely on this path when `g_developer` is 2. The jka-rust range reads the field through `script_targetname_str()` and does not trap. No guide row covers a NULL `char *` into a format argument with no test, so the site needs a ruling. | behavior | oracle/codemp/game/g_ICARUScb.c:316 | Sources/JKAMP_GameLogic/g_ICARUScb.swift:78 |

## Files with no finding

- NPC_spawn.swift: the droid block of NPC_Begin keeps the order of Raven's chained store, right to left, and his comments. The `clear()` of New_NPC_t, NPC_Spawn_Do, and the parm test follow the guide. The `G_NewString(Q_strlwr(...))` store is the guide's pooled-string form. The `slash` offset and the `CharBuf` arguments of NPC_VehiclePrecache, the scratch outputs and traces of NPC_SpawnType, and the three fills of Cmd_NPC_f all reproduce Raven.
- NPC_utils.swift: G_ActivateBehavior keeps the `bs_name` local, the `VALIDSTRING` early-out, and the script call.
- NPC_senses.swift: every `NULL` `mins` and `maxs` into `trap_Trace` is `vec3_origin` with no comment, and the `AngleVectors` site of InFront has the comment that names the NULL outputs.
- NPC_stats.swift: the `patch` offset and its `if let` follow the pointer rule. The `WP_RemoveSaber` call passes the `Slots` of the client's sabers, and `NPC_type` takes the cursor's text.
