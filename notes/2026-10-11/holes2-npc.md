# Wave B hole round, transcriptor npc

This record covers the holes of wave B in eight files under `Sources/JKAMP_GameLogic/`, and the R2 sweep of `g_ICARUScb.swift`.
The line numbers in the "Before" column are the lines of `wave-0` at 4308ee3.
The transcriptor did not build and did not run tests.

## The holes

| Before | Function | Row or guide line | Result |
|---|---|---|---|
| `g_ICARUScb.swift:1843` | `Q3_SetNavGoal` | H2, guide line 540 | Filled. `if TAG_GetOrigin2(nil, name, &goalPos) == 0 {` with both arms. `goalRadius` takes `Int32(sqrt(Double(a + a)) + sqrt(Double(b + b)))` under guide lines 550 and 556. The `#ifdef _DEBUG` arm drops under guide line 566. |
| `g_ICARUScb.swift:3177` | `Q3_SetParm` | H3, Verdict of `docket-proofs-conflict-6.md` | Filled with the Verdict text. The lifted store `val = ...`, then `if val != 0`, the `Com_sprintf` arm through `parmBuffers[parmNum]` at size `MAX_PARM_STRING_LENGTH` under the two-line rule 19 note, and the `strncpy` arm through the same accessor. Raven's inline comments stay. |
| `g_ICARUScb.swift:4505` | `Q3_SetCaptionTextColor` | none | No form, shape: the `GameVariables` property `textcolor_caption` is `[Float]` for Raven's `vec4_t`, and `SetTextColor` takes `vec4_t`. |
| `g_ICARUScb.swift:4521` | `Q3_SetCenterTextColor` | none | No form, the same shape for `textcolor_center`. |
| `g_ICARUScb.swift:4537` | `Q3_SetScrollTextColor` | none | No form, the same shape for `textcolor_scroll`. |
| `NPC_stats.swift:1625` | `NPC_ParseParms` | guide line 709 | Blocked, `saberName` is a `char *` from `BG_TempAlloc(4096)`, and `CHARBUF_ALLOCS` in `rulings.py` holds only `B_TempAlloc`. |
| `NPC_stats.swift:1628` | `NPC_ParseParms` | guide line 709 | Blocked, the same cause. |
| `NPC_stats.swift:1647` | `NPC_ParseParms` | guide line 709 | Blocked, the same cause. |
| `NPC_stats.swift:1655` | `NPC_ParseParms` | guide line 709 | Blocked, the same cause. |
| `NPC_AI_Jedi.swift:316` | `Boba_Flying` | I1, D3, guide line 542 | Filled. ``return Bool(`self`.client!.ps.eFlags2 & EF2_FLYING)``. |
| `NPC_AI_Jedi.swift:3165` | `Jedi_FaceEnemy` | I1, D3 | Filled. `let missileSpeed: Float = WP_SpeedOfMissileForWeapon(NPC!.s.weapon, Bool(NPCInfo!.scriptFlags & SCF_ALT_FIRE))`. |
| `NPC_AI_Jedi.swift:3168` | `Jedi_FaceEnemy` | follows the fill above | Filled. `if missileSpeed != 0 {` with `eDist` and `_VectorMA(enemy_eyes, eDist * flrand(0.95, 1.25), ..., &enemy_eyes)`. |
| `NPC_AI_Jedi.swift:3989` | `Jedi_TryJump` | I3, guide lines 367-369 | Filled. `let landed = Trace.scratch { trace -> Bool in ... }` inside the loop, then `if landed { break }` and `sideTry += 1`. The four `dest[k] += x * 1.25` stores take the double form `dest[k] = Float(Double(dest[k]) + Double(x) * 1.25)`. |
| `NPC_senses.swift:600` | `AddSoundEvent` | I4, guide line 625 | Filled. `... .ID = level.curAlertID`, then `level.curAlertID += 1`. |
| `NPC_senses.swift:633` | `AddSightEvent` | I4, guide line 625 | Filled, the same two lines. |
| `NPC_combat.swift:2232` | `NPC_CollectCombatPoints` | T2, guide lines 540 and 606 | Filled. `if (level.combatPoints[i].flags & CPF_SQUAD) != 0 && (flags & CP_SQUAD) == 0 {`, with `i += 1` before the `continue`. |
| `NPC_combat.swift:2502` | `NPC_FindSquadPoint` | T2, guide lines 540 and 606 | Filled. `if (level.combatPoints[i].flags & CPF_SQUAD) == 0 {`, with `i += 1` before the `continue`. |
| `NPC_AI_Sniper.swift:526` | `Sniper_FaceEnemy` | S2, M2 | Filled. `target = NPCInfo!.enemyLaggedPos[missFactor]`. |
| `NPC_AI_Sniper.swift:552` | `Sniper_UpdateEnemyPos` | S2, M2 | Filled. `CalcEntitySpot(NPC!.enemy!, SPOT_HEAD_LEAN, &NPCInfo!.enemyLaggedPos[index])`. |
| `NPC_AI_Utils.swift:256` | `AI_InsertGroupMember` | T1, guide line 625 | Filled. `group.member[group.numGroup].number = member.s.number`, then `group.numGroup += 1`. |
| `NPC_AI_GalakMech.swift:296` | `NPC_GM_Pain` | S1, C2, guide lines 336-337 | Filled. The always-true test of the local `point` drops with no comment, and the arm keeps Raven's three comment lines, as the `docket-proofs-conflict-2.md` Verdict shows. |

The two sites of `NPC_combat.swift` that wait on rulings, line 130 (V32) and the four `?? ""` lines 1315, 1322, 1434, and 1442 (V14), did not change.

## The R2 sweep of `g_ICARUScb.swift`

Each site passes a `String?` field of an `Entity` to a `%s` of `G_DebugPrint`, and each force unwrap became `?? "(null)"` under guide line 339.
No `Com_Printf`, `G_Printf`, `Com_Error`, or `va` call of the file passes a force-unwrapped `String?` to a `%s`.
No other force unwrap changed.

| Line | Function | Argument |
|---|---|---|
| 911 | `Q3_GetFloat` | `ent!.classname` |
| 911 | `Q3_GetFloat` | `ent!.targetname` |
| 927 | `Q3_GetFloat` | `ent!.targetname` |
| 934 | `Q3_GetFloat` | `ent!.targetname` |
| 941 | `Q3_GetFloat` | `ent!.targetname` |
| 989 | `Q3_GetFloat` | `ent!.targetname` |
| 996 | `Q3_GetFloat` | `ent!.targetname` |
| 1007 | `Q3_GetFloat` | `ent!.targetname` |
| 1301 | `Q3_GetString` | `ent!.targetname` |
| 2132 | `Q3_SetBState` | `ent!.targetname` |
| 2157 | `Q3_SetBState` | `ent!.targetname` |
| 2243 | `Q3_SetTempBState` | `ent!.targetname` |
| 2291 | `Q3_SetDefaultBState` | `ent!.targetname` |
| 2676 | `Q3_SetWalkSpeed` | `` `self`!.targetname `` |
| 2710 | `Q3_SetRunSpeed` | `` `self`!.targetname `` |
| 2795 | `Q3_SetFriction` | `` `self`!.targetname `` |
| 2824 | `Q3_SetGravity` | `` `self`!.targetname `` |
| 3490 | `Q3_SetWalking` | `ent!.targetname` |
| 3823 | `Q3_SetNoAvoid` | `ent!.targetname` |
| 3931 | `Q3_SetForwardMove` | `ent!.targetname` |
| 3958 | `Q3_SetRightMove` | `ent!.targetname` |
| 3985 | `Q3_SetLockAngle` | `ent!.targetname` |
| 4693 | `Q3_Set`, the `SET_ANIM_BOTH` arm | `ent!.targetname` |
| 4699 | `Q3_Set`, the `SET_ANIM_BOTH` arm | `ent!.targetname` |

The sweep changed 24 arguments on 23 lines. The line numbers are the lines after the hole fills of this round.

## Port-note counts

| File | Before | After |
|---|---|---|
| `g_ICARUScb.swift` | 5 | 3 |
| `NPC_stats.swift` | 4 | 4 |
| `NPC_AI_Jedi.swift` | 4 | 0 |
| `NPC_senses.swift` | 2 | 0 |
| `NPC_combat.swift` | 2 | 0 |
| `NPC_AI_Sniper.swift` | 2 | 0 |
| `NPC_AI_Utils.swift` | 1 | 0 |
| `NPC_AI_GalakMech.swift` | 1 | 0 |
| Total | 21 | 7 |

## GameWorld properties

None. No hole in the eight files names a static local or a file-scope static.

## Findings

1. The three `Q3_Set*TextColor` holes need a generator change, so they can become one docket row. `GameVariables.swift:273-283` gives Raven's `vec4_t textcolor_caption`, `textcolor_center`, and `textcolor_scroll` the type `[Float]`, and the stub of `SetTextColor` takes `JKAShared.vec4_t` by value. Guide line 91 gives a non-const `vec4_t` parameter as `inout JKAShared.vec4_t`, so the signature also differs from the guide. `SetTextColor` only prints a warning in MP, so no value of the globals is read.
2. The four `NPC_ParseParms` holes fill as `var saberName = CharBuf(4096)` with `_ = BG_TempAlloc(4096)` if `rulings.py` adds `BG_TempAlloc` to `CHARBUF_ALLOCS`. This is the frame-path-round item at `frame-path-round.md:96`, and no row ruled it.
3. Guide line 548 states the double rule as `Double(...)` on each operand at the operator that meets the double operand, but its example `drop += Float(Double(speed) * 0.1 * ...)` narrows the product before the `float` add. C adds in `double` and narrows once. `Jedi_TryJump` takes the form of the rule text, `dest[0] = Float(Double(dest[0]) + Double(x) * 1.25)`, as `g_combat.swift:4628` does. The guide example and `bg_pmove.swift:988` can differ from C in the last bit.
4. `Q3_SetParm` keeps `val += atof(...)` as the H3 Verdict gives it. `atof` returns `Float` in `CString.swift:125`, so the add runs in `float`, where Raven adds in `double`. The conflict-6 proof names this side finding too.
5. After the S1 fill, no line of `NPC_GM_Pain` reads the local `point`, so the build can warn that it is written and never read.
