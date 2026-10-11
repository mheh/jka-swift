# Review of phase 2, wave B: spawn and npc

This record reviews the hole fills of the transcriptors "spawn" (`holes2-spawn.md`) and "npc" (`holes2-npc.md`) against Raven's C, the jka-rust port, and the rulings.
The reviewer read `git diff HEAD` once at the start, with HEAD at 4308ee3, and did not build, test, or edit a source file.
The line numbers are the lines of the working tree at that read.

## Hunks

The diff has 36 hunks in 9 files. `NPC_stats.swift` has no change, and its four blocked holes stay as they were.

| File:line | Function | Row | Verdict |
|---|---|---|---|
| NPC_AI_GalakMech.swift:293 | NPC_GM_Pain | S1, C2 | match |
| NPC_AI_Jedi.swift:313 | Boba_Flying | I1, D3 | match |
| NPC_AI_Jedi.swift:3160 | Jedi_FaceEnemy | I1, D3, guide VectorMA row | behavior differs |
| NPC_AI_Jedi.swift:3984 | Jedi_TryJump | I3, double rule | match |
| NPC_AI_Sniper.swift:523 | Sniper_FaceEnemy | S2, M2 | match |
| NPC_AI_Sniper.swift:547 | Sniper_UpdateEnemyPos | S2, M2, U1 | match |
| NPC_AI_Utils.swift:253 | AI_InsertGroupMember | T1 | match |
| NPC_combat.swift:2229 | NPC_CollectCombatPoints | T2 | match |
| NPC_combat.swift:2500 | NPC_FindSquadPoint | T2 | match |
| NPC_senses.swift:597 | AddSoundEvent | I4 | match |
| NPC_senses.swift:629 | AddSightEvent | I4 | match |
| NPC_spawn.swift:33 | NPC_PainFunc | J1 | match |
| NPC_spawn.swift:50 | NPC_PainFunc, NPC_TouchFunc | J1 | match |
| NPC_spawn.swift:1241 | NPC_Spawn_Do | J3 | match |
| NPC_utils.swift:687 | NPC_SetBoneAngles | J5, conflict 4 | style |
| g_ICARUScb.swift:908 | Q3_GetFloat | R2 | match |
| g_ICARUScb.swift:924 | Q3_GetFloat | R2 | match |
| g_ICARUScb.swift:986 | Q3_GetFloat | R2 | match |
| g_ICARUScb.swift:1004 | Q3_GetFloat | R2 | match |
| g_ICARUScb.swift:1298 | Q3_GetString | R2 | match |
| g_ICARUScb.swift:1840 | Q3_SetNavGoal | H2, double rule | match |
| g_ICARUScb.swift:2129 | Q3_SetBState | R2 | match |
| g_ICARUScb.swift:2154 | Q3_SetBState | R2 | match |
| g_ICARUScb.swift:2240 | Q3_SetTempBState | R2 | match |
| g_ICARUScb.swift:2288 | Q3_SetDefaultBState | R2 | match |
| g_ICARUScb.swift:2673 | Q3_SetWalkSpeed | R2 | match |
| g_ICARUScb.swift:2707 | Q3_SetRunSpeed | R2 | match |
| g_ICARUScb.swift:2792 | Q3_SetFriction | R2 | match |
| g_ICARUScb.swift:2821 | Q3_SetGravity | R2 | match |
| g_ICARUScb.swift:3189 | Q3_SetParm | H3, conflict 6 | behavior differs |
| g_ICARUScb.swift:3487 | Q3_SetWalking | R2 | match |
| g_ICARUScb.swift:3820 | Q3_SetNoAvoid | R2 | match |
| g_ICARUScb.swift:3928 | Q3_SetForwardMove | R2 | match |
| g_ICARUScb.swift:3955 | Q3_SetRightMove | R2 | match |
| g_ICARUScb.swift:3982 | Q3_SetLockAngle | R2 | match |
| g_ICARUScb.swift:4690 | Q3_Set, SET_ANIM_BOTH arm | R2 | match |

33 hunks match, 2 hunks differ in behavior, and 1 hunk differs in style.

## Checks that pass

- J1: all 16 pain arms store the thunk of Raven's function name, from `Pain.NPC_Jedi_Pain` to the default `Pain.NPC_Pain`, and the touch arm stores `Touch.NPC_Touch`. All 17 thunks exist in `Sources/JKAMP_GameLogic/Generated/Callbacks.swift`. The local is ``var `func`: EntityPain? = nil`` as J1 rules.
- J3: `newent!.m_pVehicle!.pointOrientation(at: newent!.client!.ps)` is the ruled form. The extra `!` comes from the `Entity?` local. The method is at `Sources/JKAMP/Vehicle+Orientation.swift:9`.
- J5: the walk reads all four slots in Raven's order, stores `firstFree` and `freeBoneVec` at the first zero slot, and writes `boneIndexSlots` and `boneAnglesSlots` through the `Int32?` slot numbers that conflict 4 rules.
- I3: the four `dest[k]` stores compute `Float(Double(dest[k]) + Double(x) * 1.25)`. C computes `x*1.25` in `double`, adds the promoted `dest[k]` in `double`, and narrows once at the store, so the Swift gives the same bits. jka-rust `NPC_AI_Jedi.rs:5595-5602` adds in `f32` and can differ in the last bit.
- H2: `goalRadius` takes `Int32(sqrt(Double(a + a)) + sqrt(Double(b + b)))`. C adds in `float`, promotes for the `double` `sqrt`, adds in `double`, and truncates to `int`, so the Swift gives the same value. jka-rust `g_ICARUScb.rs:2011` does the same. The `#ifdef _DEBUG` arm drops as guide line 566 asks.
- S2 and U1: `enemyLaggedPos` is `Slots<JKAShared.vec3_t>` through `Slots(vectors:count:)` at `Sources/JKAMP_Game/Generated/Views/GNPC.swift:629`, so the row store at `NPC_AI_Sniper.swift:552` no longer goes through `Slots(rows:)`.
- R2: the sweep changes 24 arguments on 23 lines. Each argument is a `String?` field, `targetname` or `classname`, under a `%s`, and each takes `?? "(null)"`. No other token on those lines changed. No `G_DebugPrint` of the file still passes a force-unwrapped `String?`.
- T2: each fill steps `i += 1` before the `continue`, as the other arms of the same loops do.
- `NPC_combat.swift:130` and the four `?? ""` lines at 1315, 1322, 1434, and 1442 are unchanged.
- The three `Q3_Set*TextColor` holes and `player_locked` keep their `portMissing` calls, and the four `NPC_ParseParms` holes of `NPC_stats.swift` keep theirs.
- Each closed hole removed its Port-note line, its `// Raven wrote:` line, and its `portMissing` call. The Port-note counts after the round are 0 in eight files, 3 in `g_ICARUScb.swift`, and 4 in `NPC_stats.swift`.
- The new comment lines are Raven's own comments, or the two-line rule 19 note in `Q3_SetParm`, which is the conflict 6 Verdict text. No new comment has an em dash.

## Findings

1. `Jedi_FaceEnemy`, `NPC_AI_Jedi.swift:3167`, behavior differs.
   Raven `NPC_AI_Jedi.c:3838` writes `VectorMA( enemy_eyes, eDist*flrand(0.95f,1.25f), NPC->enemy->client->ps.velocity, enemy_eyes );`.
   The build takes the `#if 1` branch at `q_shared.h:1351`, so `VectorMA` is the macro at `q_shared.h:1365`, and the macro puts the scale text into each of the three components.
   Raven calls `flrand` three times and scales each component by a different value.
   The Swift writes `_VectorMA(enemy_eyes, eDist * flrand(0.95, 1.25), NPC!.enemy!.client!.ps.velocity, &enemy_eyes)`, which calls `flrand` once.
   The Swift takes one random draw where Raven takes three, so the lead point and the random stream after it differ.
   jka-rust `NPC_AI_Jedi.rs:4607-4612` writes a loop over the three components with one `flrand` call in each, with a comment that names the macro.
   The guide VectorMA row at `docs/transcription.md:251` gives only `_VectorMA(a, s, b, &c)` and does not name a scale with a side effect. The four `_VectorMA` calls with `flrand` at `NPC_AI_Sniper.swift:493-502` are older lines on the same ground.
2. `Q3_SetParm`, `g_ICARUScb.swift:3194`, behavior differs, and the Swift is the ruled form exactly.
   Raven `g_ICARUScb.c:3676` writes `val += atof( ent->parms->parm[parmNum] );`, where `atof` parses to `double`, the `float` `val` promotes, the add runs in `double`, and the store narrows once.
   The Swift writes `val += atof(ent!.parms!.parm[parmNum])`, where `atof` at `Sources/JKAShared/CString.swift:120` and `125` parses to `Float`, and the add runs in `float`.
   The Swift rounds twice where Raven rounds once, so the last bit of the stored text can differ.
   jka-rust `g_ICARUScb.rs:3016-3017` adds in `f64` with a `double` parse.
   The conflict 6 Verdict and the transcriptor record both name this as a side finding, so it needs a ruling, not a fix in this round.
3. `NPC_SetBoneAngles`, `NPC_utils.swift:713-731`, style, and the three walks are not one shape.
   The `switch i` of `NPC_utils.swift` puts a blank line between its two-line arms, and the walks of `G2Tur_SetBoneAngles` at `g_turret_G2.swift` and `EWeb_SetBoneAngles` at `g_items.swift:1477-1489` do not.
   The house rule asks for a blank line between multi-line switch cases, so `NPC_utils.swift` has the house form, and the other two files need the blank lines.
   No other token differs among the three walks, except Raven's own warning text, "NPC" and "E-Web".
   jka-rust `NPC_utils.rs:732` walks the slots with a `for` loop and a `match`, the different control flow that conflict 4 records.
   The brief names `g_vehicleTurret.swift` for the third walk, but that file has no bone walk. The third walk of conflict 4 is `EWeb_SetBoneAngles` in `g_items.swift`, from wave A.

## Notes

- `Sniper_FaceEnemy`, `NPC_AI_Sniper.swift:526`, matches Raven, and one edge stays open. Raven clamps `missFactor` to `ENEMY_POS_LAG_STEPS`, 24, and reads `enemyLaggedPos[24]`, one past the array. Raven reads past the array there, and the Swift `Slots` precondition at `Slots.swift:32` traps. `stats.aim` is 1 to 5, so only a negative `g_spskill` below -3 reaches the edge. jka-rust `NPC_AI_Sniper.rs:768-776` skips the read with a guard and a rule 19 comment.
- `NPC_GM_Pain` writes the local `point` at `NPC_AI_GalakMech.swift:267` and no line reads it after the S1 fill, so the build can warn. Raven has the same unread local. The transcriptor record names this as its finding 5.
