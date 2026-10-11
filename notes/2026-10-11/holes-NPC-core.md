# Hole round of the NPC core files

This record covers the Port-notes of seven files under `Sources/JKAMP_GameLogic/`.

## NPC_misc.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Debug_Printf | `va_list argptr` local | filled | The local drops under the variadic form. |
| Debug_Printf | `va_start` | filled | It drops under the variadic form. |
| Debug_Printf | `vsprintf (msg, fmt, argptr)` | filled | `strcpy(&msg, JKAShared.format(String(fmt), args))`, because `fmt` is a `CharBuf` parameter. |
| Debug_Printf | `va_end` | filled | It drops under the variadic form. |
| Debug_NPCPrintf | `va_list argptr` local | filled | Same form as Debug_Printf. |
| Debug_NPCPrintf | `va_start` | filled | It drops. |
| Debug_NPCPrintf | `vsprintf (msg, fmt, argptr)` | filled | `strcpy(&msg, JKAShared.format(String(fmt), args))`. |
| Debug_NPCPrintf | `va_end` | filled | It drops. |

## NPC_behavior.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_BSAdvanceFight | NULL `mins` into `trap_Trace` | filled | The note is deleted, and `vec3_origin` stays with no comment. |
| NPC_BSAdvanceFight | NULL `maxs` into `trap_Trace` | filled | Same. |
| NPC_BSAdvanceFight | NULL `mins` into the second `trap_Trace` | filled | Same. |
| NPC_BSAdvanceFight | NULL `maxs` into the second `trap_Trace` | filled | Same. |
| NPC_BSAdvanceFight | NULL `right` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| NPC_BSAdvanceFight | NULL `up` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| NPC_BSNoClip | NULL `up` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |

## NPC_AI_Stormtrooper.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| ST_OffsetLook | NULL `right` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| ST_OffsetLook | NULL `up` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| ST_CheckFireState | NULL `right` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| ST_CheckFireState | NULL `up` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| ST_TransferMoveGoal | `?qtrue:qfalse` over an int test did not compile | filled | The int truth test is `(... & FL_NAVGOAL) != 0`, and the `?:` keeps Raven's two arms. |
| NPC_BSST_Attack | NULL `right` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| NPC_BSST_Attack | NULL `up` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |

## NPC_AI_Utils.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| AI_SortGroupByPathCostToEnemy | local `AIGroupMember_t bestMembers[MAX_GROUP_MEMBERS]` | filled | The `count` scratch form wraps the rest of the body. The count is `Int(MAX_GROUP_MEMBERS)`, the spelling of guide line 112 for a C bound. |
| AI_SortGroupByPathCostToEnemy | `bestMembers[j].number = ENTITYNUM_NONE` | filled | It is a plain store into the scratch slot. |
| AI_SortGroupByPathCostToEnemy | the insertion block over `bestMembers` | filled | Each `memcpy` into a slot is `copy(from:)`. Raven's inner loop steps `k++` while it tests `k > j`, so it runs past slot 31. The port keeps his loop as he wrote it. |
| AI_SortGroupByPathCostToEnemy | `memcpy( &group->member[i], &bestMembers[i], ... )` | filled | `group.member[i].copy(from: bestMembers[i])`. |
| AI_InsertGroupMember | `group->member[group->numGroup++].number = ...` | stands | The guide has no form for a post-increment inside an index. See docket row 1. |
| AI_GetGroup | `memset( self->NPC->group, 0, sizeof( AIGroupInfo_t ) )` | filled | The size is the pointee's type name, so the size is the record's own size. The target is a pointer, so the call is `` `self`.NPC!.group!.clear() ``. |

## NPC.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| pitch_roll_for_slope | NULL `up` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| pitch_roll_for_slope | NULL `right` into the second AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| pitch_roll_for_slope | NULL `up` into the second AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |
| DeadThink | `int contents = NPC->bounceCount = trap_PointContents(...)` | filled | The compound store lifts. The inner store comes first, then `let contents: Int32 = NPC!.bounceCount`. |
| DeadThink | the read of `contents` | filled | `if (contents & CONTENTS_NODROP) != 0 { ... }`. |
| NPC_ShowDebugInfo | `while( (found = G_Find(...)) != NULL )` | filled | The form is `while let next`, then `found = next`. No statement after the loop reads `found`, so no line follows the loop. |

## NPC_combat.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_CollectCombatPoints | `occupied == (int) qtrue` did not compile | stands | `occupied` is a `Bool`, and the guide has no form for Raven's `(int)` cast on a qboolean constant. See docket row 3. |
| NPC_CollectCombatPoints | `( flags & CP_SQUAD ) == qfalse` did not compile | stands | The guide has no form for an int compared with a qboolean constant. See docket row 2. |
| NPC_FindSquadPoint | `( ... flags & CPF_SQUAD ) == qfalse` did not compile | stands | Same as docket row 2. |
| NPC_SearchForWeapons | `!trap_Nav_GetBestPathBetweenEnts(...)` on an int return | filled | The int truth test is `== 0`, and the draft's commented block is live code again. |

## NPC_move.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NAV_GetLastMove | `*info = frameNavInfo` | filled | `info.copy(from: frameNavInfo)` writes the record through the parameter's view. |
| G_UcmdMoveForDir | NULL `up` into AngleVectors | filled | The coordinator confirmed that the NULL arms of AngleVectors only skip the writes. The note and the marker are deleted, the scratch locals stay, and one plain comment above the call names the NULL outputs. |

## GameWorld properties

None. No hole in this round is a static local or a file-scope static.

## Docket rows

1. `AI_InsertGroupMember`, `group->member[group->numGroup++].number = member->s.number`. The assignment-inside-an-expression form lifts a store before the statement, but a post-increment gives the old value to the index. Proposed form: the statement reads the variable, and `x += 1` is the statement after it, `group.member[group.numGroup].number = member.s.number` and then `group.numGroup += 1`.
2. `NPC_CollectCombatPoints` and `NPC_FindSquadPoint`, an `int` expression compared with `qfalse`. No form compares an `Int32` with a `Bool` constant. Proposed form: `== qfalse` on an int is `== 0`, because `qfalse` is 0 in C.
3. `NPC_CollectCombatPoints`, `level.combatPoints[i].occupied == (int) qtrue`. The view field is a `Bool`, and Swift has no `Int32` from a `Bool`, so Raven's cast cannot stay on the page. Proposed form: the cast drops, and the test is `occupied == true`, as `NPC_FindSquadPoint` already reads.
