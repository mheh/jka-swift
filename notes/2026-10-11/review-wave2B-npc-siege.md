# Review of wave 2B, the NPC and siege files

This record covers 26 files and 149 removed `portMissing` holes. The fills add no new `portMissing` line.

| File | Function | Finding | Severity | Raven line | Swift line |
|---|---|---|---|---|---|
| g_saga.swift | InitSiegeMode | Raven tests `!levelname \|\| !levelname[0]`. The fill keeps only `levelname[0] == 0` and drops the first test with no comment. The test on a local array is always false, so the value does not change, but the guide gives no form that drops it silently. | form | oracle/codemp/game/g_saga.c:145 | g_saga.swift:218 |
| g_target.swift | target_random_use | Both loops pass `self.target!` to `G_Find`. Raven passes `self->target` as it is, and his `G_Find` takes a NULL `match`, because `Q_stricmpn` returns 1 for a NULL `s2` (q_shared.c:852). A `target_random` with no `target` key returns at `if (!t_count)` in Raven, and the Swift traps at the unwrap. The force-unwrap rule applies only where Raven's callee dereferences NULL. | behavior | oracle/codemp/game/g_target.c:693, 715 | g_target.swift:689, 709 |
| NPC_AI_Rancor.swift | Rancor_Attack | The two `NPC->enemy->health+10` calls drop Raven's trailing comments `//, HL_NONE );//` and `//, HL_NONE );`. The guide keeps inline comments verbatim, and the draft keeps the same kind of comment on `G_Knockdown` in this file. | style | oracle/codemp/game/NPC_AI_Rancor.c:537, 577 | NPC_AI_Rancor.swift:509, 551 |

Notes on the two fills that the brief named:

- `AI_SortGroupByPathCostToEnemy` keeps Raven's `for ( k = group->numGroup; k > j; k++ )` as `k = group.numGroup`, `while k > j`, `k += 1`. This is Raven's defect, and the fill transcribes it as written. C writes past `bestMembers[MAX_GROUP_MEMBERS]`, and the Swift `Slots` subscript traps at the first index out of range. Both crash on the same path. The array is `AIGroupMember.scratch(count:)`, which zeroes the slots where Raven left them uninitialized, and the body writes `number` before any read. This is not a finding.
- `NPC_Seeker_Pain` drops Raven's `(float*)` casts on `vec3_origin`. The casts only remove `const` and have no Swift spelling. The `dir` argument is a copy under the guide's `G_Damage` comment, and the `point` argument is `vec3_origin`, in Raven's order. This is not a finding.

Other checks with no finding:

- Every `AngleVectors` fill keeps Raven's argument order, and a scratch local stands at each position where Raven passed NULL.
- Every `G_Damage` fill with a NULL `dir` declares `var dir: vec3_t? = nil` and passes `&dir`. Every fill with Raven's `vec3_origin` as `dir` passes a copy under the one-line comment the guide gives.
- Every `trap_Trace` fill passes `vec3_origin` for a NULL `mins` or `maxs`, with no comment.
- `UseSiegeTarget` and `target_random_use` compare entities as `s.number`, where Raven compares pointers. The values are equal, because every `g_entities` slot holds its own index in `s.number`.

## Files with no finding

NPC.swift, NPC_AI_Droid.swift, NPC_AI_GalakMech.swift, NPC_AI_Grenadier.swift, NPC_AI_Howler.swift, NPC_AI_ImperialProbe.swift, NPC_AI_Interrogator.swift, NPC_AI_Mark1.swift, NPC_AI_Mark2.swift, NPC_AI_MineMonster.swift, NPC_AI_Remote.swift, NPC_AI_Seeker.swift, NPC_AI_Sentry.swift, NPC_AI_Sniper.swift, NPC_AI_Stormtrooper.swift, NPC_AI_Utils.swift, NPC_AI_Wampa.swift, NPC_behavior.swift, NPC_combat.swift, NPC_misc.swift, NPC_move.swift, g_turret.swift, g_turret_G2.swift.
