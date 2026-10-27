# Phase 3, group 4: the hand sites

This record holds group 4 of phase 3 of the rulings build, the items of `notes/2026-10-11/phase-2-walk.md`, section "Hand sites in Sources", with the forms of "The strike". The tree is `wave-0` on b72fe3b with the changes below, uncommitted. A line number is the line in the changed tree. Every changed file is under `Sources/`, and no file under `Sources/*/Generated/` changed.

## Items that earlier groups landed

The tree holds these items, and this group did not change them. V36: `crandom()` returns `Double` at `Sources/JKAMP_BG/bg_lib.swift:193`, and the build compiles every site. W17: `atof` returns `Double` at `Sources/JKAShared/CString.swift:121` and `:126`. V1: `Sources/JKAMP_GameLogic/ai_main.swift:812-813` reads `var argsText = buf[args!...]` and `RemoveColorEscapeSequences(&argsText)`. V2: `g_svcmds.swift:97-99` holds the local `ip`, the base `Com_sprintf`, and `strcat(&iplist, ip)`. V6: `Bool+Int32.swift` is gone, and `g_session.swift:134` and `:173` read `!= 0`. V9 and V15: `g_utils.swift:109` reads `memset(&buff, 0, MAX_STRING_CHARS)`. V23: no `parmBuffers` or `teamVoteStringBuffers` stands in Sources, and `g_ICARUScb.swift:3207` and `:3219` store `ent!.parms!.parm[parmNum] = String(buf)`. W6 and W9: the accessors at `g_nav.swift:74` and `g_ICARUScb.swift:19`, `:25`, and `:31` take `Int32?` and `JKAShared.vec4_t`. W16, Seeker site: `NPC_AI_Seeker.swift:206-208` holds the three stores. W28: `g_spawn.swift:37`, `:60`, `:71`, and `:82` hold `@discardableResult` between the `Source:` line and the `func` line.

V16 and the nine other bare `portMissing` data entries of W30 wait, as the plan orders.

## V37. Raven's comments on the arm heads

A throwaway script under `/tmp` read the drafts of `snapshot.py --out /tmp/v37snap`, one parse of every stem. For each function that the hand file and the draft both hold, matched by Raven line through `functions()` of `draftcheck.py`, it found each draft arm head that carries a comment. It matched the head to the next hand head with the same labels, with comments and whitespace stripped, and wrote the draft head lines over the hand head lines at the hand indent. No other line moved.

The splice wrote 263 arm heads in 20 files, with 527 comment lines. 509 of those comment lines are new, and 18 were on the hand heads already, in the two joined `LEGS_*` heads of `bg_pmove.swift`, which now take one label per line. No draft head failed to find its hand head. The review found two heads in `bg_panimate.swift` that the splice missed, `BG_SaberInSpecialAttack` and `BG_InDeathAnim`, and the review-fix round wrote them with 80 comment lines. 15 more draft heads with a comment were already in the hand files as the draft writes them, among them the one head of `bg_misc.swift`, so that file did not move.

| File | Heads | Comment lines |
|---|---|---|
| `Sources/JKAMP_BG/bg_panimate.swift` | 19 | 190 |
| `Sources/JKAMP_BG/bg_pmove.swift` | 3 | 19 |
| `Sources/JKAMP_BG/bg_saber.swift` | 9 | 31 |
| `Sources/JKAMP_BG/bg_vehicleLoad.swift` | 20 | 20 |
| `Sources/JKAMP_GameLogic/g_ICARUScb.swift` | 120 | 124 |
| `Sources/JKAMP_GameLogic/g_active.swift` | 13 | 14 |
| `Sources/JKAMP_GameLogic/g_cmds.swift` | 1 | 1 |
| `Sources/JKAMP_GameLogic/g_combat.swift` | 4 | 48 |
| `Sources/JKAMP_GameLogic/g_mover.swift` | 1 | 1 |
| `Sources/JKAMP_GameLogic/g_team.swift` | 4 | 4 |
| `Sources/JKAMP_GameLogic/g_vehicles.swift` | 8 | 8 |
| `Sources/JKAMP_GameLogic/NPC.swift` | 17 | 17 |
| `Sources/JKAMP_GameLogic/NPC_AI_Grenadier.swift` | 3 | 3 |
| `Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift` | 3 | 3 |
| `Sources/JKAMP_GameLogic/NPC_AI_Stormtrooper.swift` | 7 | 7 |
| `Sources/JKAMP_GameLogic/NPC_combat.swift` | 12 | 12 |
| `Sources/JKAMP_GameLogic/NPC_reactions.swift` | 7 | 7 |
| `Sources/JKAMP_GameLogic/NPC_spawn.swift` | 4 | 4 |
| `Sources/JKAMP_GameLogic/w_force.swift` | 1 | 2 |
| `Sources/JKAMP_GameLogic/w_saber.swift` | 7 | 12 |
| Total | 263 | 527 |

The group 2 record gives 273 heads in 21 files and 642 comments. That count is the draft against the draft before the V37 rule, so it includes the 15 heads that the hand files already held. It counts comments, and this record counts the comment lines of the heads that the splice wrote.

## W1. The logic `vmMain`

`Sources/JKAMP_GameLogic/g_main.swift:545-547` is the `NOT_PORTED` stub, the text of `skeleton.py` for `g_main`: the `Source:` line, `// Raven wrote: int vmMain( int command, ..., int arg11 )`, and `// Not ported: the shell's vmMain in Sources/jampgame/jampgame.swift decodes the command words and calls the bare functions, under rule 11 and ruling F5.` The function at the old lines 545-787 and its ten Port-notes are gone.

## V34. Integral `float` literals stored into an `int`

The nine sites read the integer literal: `FighterNPC.swift:603` and `:608` `parentPS!.hackingTime = 0`, `:644` `parentPS!.gravity = -500`, `:648` and `:653` `parentPS!.gravity = 500`, `g_items.swift:1066` `sentry!.s.g2radius = 30`, `g_active.swift:2193` and `:2201` `client!.ps.gravity = 1`, and `g_misc.swift:1650` `var add: Int32 = 0 //,highest;`. No `Int32(n.0)` text stands in `Sources/JKAMP_GameLogic`.

## V35. `SortRanks`

`g_main.swift:1409-1410` read `let ca: Client` and `let cb: Client`, and the 22 reads of the body drop the `!`, for example `ca.sess.duelTeam == DUELTEAM_LONE && ca.sess.sessionTeam != TEAM_SPECTATOR`. The proof counts 20 reads, and the body holds 22.

## W14. `Pickup_Powerup`

The top declaration `var client: Client?` is gone. `g_items.swift:1979` reads `let client = level.clientsSlots[i]` inside the `Trace.scratch` closure, and the seven reads drop the `!`. The reads through `other.client!` keep their `!`.

## V32. `attDelay`

`NPC_combat.swift:130` reads `attDelay = Int32(Double(attDelay) + floor(Double((_DotProduct(fwd, dir) + 1.0) * 2000.0))) //add up to 4000ms delay if they're facing away`.

## V33. The eight `G_Find` callers

The `String?` argument drops its `!` at `g_utils.swift:560` `string`, `ai_wpnav.swift:1565` `ent.targetname`, `g_client.swift:700` `classname`, `g_mover.swift:1261` and `:1268` `door!.targetname`, `g_mover.swift:1306` and `:1316` `ent!.targetname`, and `g_saga.swift:1497` `ent.paintarget`. The `door!` and `ent!` view unwraps stay.

## V14. `?? "(null)"` at the debug prints

`NPC_combat.swift:1315`, `:1322`, `:1434`, and `:1442` read `NPC!.targetname ?? "(null)", newenemy!.targetname ?? "(null)"`. `NPC_utils.swift:680` reads ``G_DebugPrint(WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", `self`.targetname ?? "(null)", GetStringForID(BSETTable, bset) ?? "(null)", bs_name!)``.

## V38. The `entNum` note

`g_ICARUScb.swift:63-64` hold the two-line rule 19 note above `var entNum: Int32 = 0`: ``// Raven's `entNum` is uninitialized, and he reads a stack value when `sscanf` finds no number.`` and `// The port starts it at 0, so that print names slot 0.`

## W2. `G_G2TraceCollide`

`w_saber.swift:2004-2077` hold the body of the proof. Raven's first comment stays, then `// Raven's record array lives to the end of his block, so the block is the closure.` and `return CollisionRecord.scratch(count: Int(MAX_G2_COLLISIONS)) { G2Trace -> Bool in` at `:2007`. The six holes fill: `G2Trace[tN].mEntityNum = -1`, the two traps with `G2Trace[0]`, `&rayStart`, `&rayEnd`, and `&g2Hit!.modelScale`, and the test of `G2Trace[0].mEntityNum` with its two arms. The scratch copies `var rayStart = lastValidStart` and `var rayEnd = lastValidEnd` stand under `// The engine only reads the ray, at G2_API.cpp:2157-2158, so the copies are behavior-equal.`

The memset drops under one comment line. The proof gives two sentences on that line, and the house rule gives one sentence per line, so the line is one sentence: ``// Raven clears the array with `memset` here, and the body drops the call, because the scratch slots are zero at entry.``

## W3. `WP_CalcVehMuzzle`

`g_weapon.swift:3483-3507` hold the body of the proof. `// Raven's record lives to the end of his block, so the block is the closure.` and `MdxaBone.scratch { boltMatrix in` at `:3486` open the closure after `let pVeh`, and the four holes fill: the declaration drops, and the three calls read `trap_G2API_GetBoltMatrix_NoRecNoRot(ent.ghoul2, 0, pVeh!.m_iMuzzleTag[muzzleNum], boltMatrix, vehAngles, ent.client!.ps.origin, level.time, nil, &ent.modelScale)`, `BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &pVeh!.m_vMuzzlePos[muzzleNum])`, and the same with `NEGATIVE_Y` and `m_vMuzzleDir`.

## W4. The `pm` callback stores

`g_active.swift:705-706` in `SpectatorThink` and `:2568-2569` in `ClientThink_real` read `pm.trace = PmoveThunks.trap_Trace` and `pm.pointcontents = PmoveThunks.trap_PointContents`. The four Port-notes and their markers are gone, which closes W5.

## W6. The `fatalErrorPointer` holes

`g_nav.swift:1519-1524` in `NAV_WaypointsTooFar` read `if fatalErrorPointer! + len >= Int32(fatalErrorString.count) {`, the `Com_Error` call with `return true`, `strcat(&fatalErrorString, temp, at: fatalErrorPointer!)`, and `fatalErrorPointer! += len`. `g_nav.swift:1600` in `NAV_CalculatePaths` reads `fatalErrorPointer = 0`, not the draft line `fatalErrorPointer = fatalErrorString[0]`.

## W7. The `placesecond` holes

`ai_util.swift:72-85` in `GetValueGroup` read `if let found = strstr(buf[(place! + 1)...], group) { placesecond = place! + 1 + found } else { placesecond = nil }`, each arm on its own lines, and then the read hole `if let placesecond {` with `startpoint += (placesecond - place!)`, `startletter += (placesecond - place!)`, and `place = placesecond`, and the else arm `failure = 1` and `break`. `ai_util.swift:165-178` in `GetPairedValue` read the same with `key`, with Raven's operands with no parentheses, and the else arm `place = nil` and `break`.

## W8. `G_ProcessIPBans`

`g_svcmds.swift:195-196` read `var s: Int32` and `var t: Int32`. The loop at `:201-215` walks `g_banIPs.stringBuffer` with the two cursors. Each space is found by the suffix form of ruling W7, `guard let found = strchr(g_banIPs.stringBuffer[s...], Int32(ascii: " ")) else { break }` and `s += found`. The NUL stores, the test of `t`, `var token = g_banIPs.stringBuffer[t...]`, `AddIP(&token)`, and `t = s` follow the proof.

## W9. The `SetTextColor` holes

`g_ICARUScb.swift:4546`, `:4560`, and `:4574` read `SetTextColor(textcolor_caption, color)` and the same for `textcolor_center` and `textcolor_scroll`.

## W10. The `saberName` arms of `NPC_ParseParms`

The `saber` arm at `NPC_stats.swift:1616-1629` reads `var saberName = CharBuf(4096)`, `_ = BG_TempAlloc(4096) //G_NewString( value );`, `strcpy(&saberName, value)`, `WP_SaberParseParms(String(saberName), NPC.client!.saber[0])`, `npcSaber1 = G_ModelIndex(va("@%s", saberName))`, and `BG_TempFree(4096)`. The `saber2` arm at `:1640-1652` reads `var saberName = CharBuf(4096)`, `_ = BG_TempAlloc(4096)`, `strcpy(&saberName, value)`, `WP_SaberParseParms(String(saberName), NPC.client!.saber[1])`, and `npcSaber2 = G_ModelIndex(va("@%s", saberName))` in the else arm. The hand line `WP_RemoveSaber(NPC.client!.saber, 1)` stays.

## W11. `ClientCleanName`

`g_client.swift:1404-1407` read ``if ColorIndex(`in`.byte) == 0 {``, `` `in`.advance()``, `continue`, and `}`, under Raven's comment at `:1403`.

## W12. `SiegeItemRemoveOwner`

`g_saga.swift:1242` reads `func SiegeItemRemoveOwner(_ ent: Entity, _ carrier: Entity?) {`, and `:1247-1250` restore `if carrier != nil {` with the two `carrier!` stores. The hole at `:1277` and the call at `:1346` read `SiegeItemRemoveOwner(ent, carrier)`. `g_trigger.swift:190` compiles with no change.

## W13. `SP_func_breakable`

`g_mover.swift:2575` reads `var s: String = ""`, then `G_SpawnString("playfx", "", &s)`, `if !s.isEmpty {`, and `G_EffectIndex(s)`.

## W15. The `default` note of `G_InitSessionData`

The two comment lines under `default:` at `g_session.swift:251` are gone.

## W16. The `_VectorMA` calls with a random scale

`NPC_AI_Jedi.swift:3167-3169` read `enemy_eyes[0] = enemy_eyes[0] + NPC!.enemy!.client!.ps.velocity[0] * (eDist * flrand(0.95, 1.25))` and the same for 1 and 2. `NPC_AI_Sniper.swift:493-495`, `:497-499`, `:504-506`, and `:508-510` read the same shape for the four calls, for example `target[0] = target[0] + right[0] * (NPC!.enemy!.r.maxs[2] * flrand(1.5, 4))`.

## W18. The two compound stores in double

`bg_pmove.swift:988` reads `drop = Float(Double(drop) + Double(speed) * 0.1 * Double(pml.frametime))`. `bg_misc.swift:1084` reads `result[2] = Float(Double(result[2]) - 0.5 * Double(DEFAULT_GRAVITY) * Double(deltaTime) * Double(deltaTime))` with Raven's `// FIXME: local gravity...`, and the comment at `:1083` reads "Raven's `0.5` is a double, so the subtraction runs in double and rounds once into the float."

## W19. The raw allocation return of `G_NewString`

`g_spawn.swift:231` reads `return cString(at: newb)`, the form of `phase3-helpers.md` section "W19". `cString(at:)` is at `Sources/JKAShared/Views/CStrings.swift:2`.

## W20. `Use_Target_Print`

The eight `%s` reads at `g_target.swift:212`, `:214`, `:225`, `:227`, `:233`, `:235`, `:243`, and `:245` read the bound name, for example `va("cps \"%s\"", message)`.

## W22. `G_ReadSessionData`

`g_session.swift:139-140` hold the two-line rule 19 note above the three stores: ``// Raven reads a token of 64 bytes or more into a `char[64]` field and overruns it.`` and ``// The setter stores the first 63 bytes and the NUL, as `Q_strncpyz` does.``

## W23. `Sniper_FaceEnemy`

`NPC_AI_Sniper.swift:534-535` hold the rule 19 note above `target = NPCInfo!.enemyLaggedPos[missFactor]`. The ruled text is one sentence of 176 characters, and with its indent the line passes the house limit of 150 columns. So the sentence breaks at its clause boundary, with no word changed: `// Raven reads one row past the 24 rows, the bytes of watchTarget and the next fields,` and `// when stats.aim plus g_spskill.integer is -6 or less, and the Swift subscript traps there.`

## W24. `VEH_TurretThink`

`g_vehicleTurret.swift:362` is a blank line after the `trap_Trace` call at `:361`.

## W25. The bone-angle switches

`g_turret_G2.swift` and `g_items.swift` hold one blank line before `case 1:`, `case 2:`, and `default:` of their `switch i`, after the old lines 66, 69, and 72 and 1480, 1483, and 1486.

## W30. The four data entries

`g_mover.swift:43`, `:47`, and `:51` read `let BMS_START: Int32 = 0`, `let BMS_MID: Int32 = 1`, and `let BMS_END: Int32 = 2`. `g_team.swift:12` reads `nonisolated(unsafe) let ctfFlagStatusRemap: JKAShared.CharBuf = CharBuf(bytes: [0x30, 0x31, 0x2A, 0x2A, 0x32])`. The `// Raven wrote:` lines stay.

## Findings for the review leg

- The draft of `SiegeItemRespawnOnOriginalSpot` in `bodies.py --stem g_saga` writes `SiegeItemRemoveOwner(ent, carrier!)`, a force unwrap of an optional into the optional parameter of ruling W12. The V33 guide sentence for line 338 rules that form out. The hand site reads `SiegeItemRemoveOwner(ent, carrier)`. This is a drafter defect, and no hand fix went anywhere else.
- The draft of `NPC_ParseParms` holds `WP_RemoveSaber( NPC->client->saber, 1 )` as a hole, "A Slots over one record has no form yet", where the hand line `WP_RemoveSaber(NPC.client!.saber, 1)` compiles.

## Blocked items

No item is blocked. Every verdict form compiled as written, and no form needed a new name.

## Gate

The cheap gate, `swift build`, ran after each file and gave "Build complete!" each time. The full gate ran in one foreground call: `swift build`, `swift test --no-parallel`, and `tools/load-test.sh`.

- `swift build`: 0 errors, "Build complete!".
- `swift test --no-parallel`: 112 tests in four binaries, 84, 14, 13, and 1, all passed.
- `tools/load-test.sh`: exit 0. The server loaded `mp/ffa1`, ran `InitGame`, and shut down with `ShutdownGame`.

Draftcheck and the snapshot check did not run, because no rule, signature, or generator changed in this group.
