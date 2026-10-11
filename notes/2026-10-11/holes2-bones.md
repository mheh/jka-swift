# Hole round 2, transcriptor bones

This record covers wave B of phase 2 for `g_items.swift`, `g_turret_G2.swift`, and `g_vehicleTurret.swift` under `Sources/JKAMP_GameLogic/`. The line numbers are the lines of `wave-0` at 4308ee3. No build and no test ran.

## The holes

| File:line before | Function | Row or guide line | What the body now reads |
|---|---|---|---|
| g_items.swift:414 | CreateShield | F1, A6, guide line 539 | `paramData = ((xaxis ? 1 : 0) << 24) \| (height << 16) \| (posWidth << 8) \| (negWidth)` |
| g_items.swift:1456 | EWeb_SetBoneAngles | F2 (J5 form), conflict 4 | `var thebone: Int32? = 0` |
| g_items.swift:1459 | EWeb_SetBoneAngles | F2 (J5 form) | `var firstFree: Int32? = nil` |
| g_items.swift:1468 | EWeb_SetBoneAngles | F2 (J5 form) | `var boneVector: Int32? = 0` |
| g_items.swift:1471 | EWeb_SetBoneAngles | F2 (J5 form) | `var freeBoneVec: Int32? = nil` |
| g_items.swift:1475 | EWeb_SetBoneAngles | F2 (J5 form), E2 for `!*thebone` | `while thebone != nil`, reads `ent.s.boneIndexSlots[thebone!]`, `switch i` sets slots 1 to 3, `default` sets `nil` |
| g_items.swift:1479 | EWeb_SetBoneAngles | F2 (J5 form) | `if thebone == nil`, `ent.s.boneIndexSlots[thebone!] = boneIndex`, `boneVector = freeBoneVec` |
| g_items.swift:1487 | EWeb_SetBoneAngles | F2 (J5 form) | `ent.s.boneAnglesSlots[boneVector!] = angles` |
| g_items.swift:1946 | Pickup_Powerup | F3, guide lines 367-368 | `i = 0`, `while i < level.maxclients`, `Trace.scratch { tr in ... }` with each `continue` as `return`, then `i += 1` |
| g_turret_G2.swift:40 | G2Tur_SetBoneAngles | Q2 (J5 form) | `var thebone: Int32? = 0` |
| g_turret_G2.swift:43 | G2Tur_SetBoneAngles | Q2 (J5 form) | `var firstFree: Int32? = nil` |
| g_turret_G2.swift:52 | G2Tur_SetBoneAngles | Q2 (J5 form) | `var boneVector: Int32? = 0` |
| g_turret_G2.swift:55 | G2Tur_SetBoneAngles | Q2 (J5 form) | `var freeBoneVec: Int32? = nil` |
| g_turret_G2.swift:59 | G2Tur_SetBoneAngles | Q2 (J5 form) | the same walk as `EWeb_SetBoneAngles` |
| g_turret_G2.swift:63 | G2Tur_SetBoneAngles | Q2 (J5 form) | the same arm, with Raven's "NPC has no free bone indexes" text |
| g_turret_G2.swift:71 | G2Tur_SetBoneAngles | Q2 (J5 form) | `ent.s.boneAnglesSlots[boneVector!] = angles` |
| g_turret_G2.swift:569 | turretG2_find_enemies | Q3, guide lines 367-368 | `i = 0`, `while i < count`, `Trace.scratch { tr in ... }`, then `i += 1` |
| g_vehicleTurret.swift:35 | VEH_TurretCheckFire | M2, D8 | `missile = WP_FireVehicleWeapon(parent, &pVeh.m_vMuzzlePos[curMuzzle], pVeh.m_vMuzzleDir[curMuzzle], vehWeapon, (turretNum != 0), true)` |
| g_vehicleTurret.swift:65 | VEH_TurretAnglesToEnemy | M2 | `diff = org - pVeh.m_vMuzzlePos[curMuzzle]` |
| g_vehicleTurret.swift:78 | VEH_TurretAnglesToEnemy | M2 | `enemyDir = org - pVeh.m_vMuzzlePos[curMuzzle]` |
| g_vehicleTurret.swift:97 | VEH_TurretAim | M2 | `vectoangles(pVeh.m_vMuzzleDir[curMuzzle], &curAngles)` |
| g_vehicleTurret.swift:189 | VEH_TurretFindEnemies | M2 | `org2 = pVeh.m_vMuzzlePos[curMuzzle]` |
| g_vehicleTurret.swift:195 | VEH_TurretFindEnemies | M3, guide lines 367-368, R9 overload of `Q_stricmp` | `i = 0`, `while i < count`, `Trace.scratch { tr in ... }`, then `i += 1` |
| g_vehicleTurret.swift:295 | VEH_TurretThink | M2 | `enemyDir = turretEnemy!.r.currentOrigin - pVeh.m_vMuzzlePos[curMuzzle]` |
| g_vehicleTurret.swift:302 | VEH_TurretThink | M2, guide lines 350-364 | `if trap_InPVS(pVeh.m_vMuzzlePos[curMuzzle], ...)` around a block `Trace.scratch { tr in ... }` that sets `doAim` |

## Port-note counts

| File | Before | After |
|---|---|---|
| `g_items.swift` | 9 | 0 |
| `g_turret_G2.swift` | 8 | 0 |
| `g_vehicleTurret.swift` | 8 | 0 |
| Total | 25 | 0 |

No `portMissing` call and no `// Raven wrote:` line stays in the three files.

## GameWorld properties

None.

## Findings

1. `Pickup_Powerup` compares `DotProduct( delta, forward ) < 0.4`, a `float` against a `double` literal. The body reads `Double(_DotProduct(delta, forward)) < 0.4` under the double-math rule of guide lines 547-549, as `NPC_AI_Stormtrooper.swift:2092` does.
2. The three loops pass `NULL` for `mins` and `maxs` to `trap_Trace`, and the bodies pass `vec3_origin` under guide line 232. `AngleVectors` in `Pickup_Powerup` takes two scratch outputs and the one comment line of guide line 224, as `g_turret_G2.swift:300` does.
3. `WP_FireVehicleWeapon` takes `start` as `inout`, so the call passes `&pVeh.m_vMuzzlePos[curMuzzle]` through the nonmutating setter of the M2 `Slots<vec3_t>`. A write of the callee lands in the muzzle slot, as in Raven's C. The gate must confirm that Swift accepts the `inout` of a `Slots` element through the get-only field.
4. The `client` local of `Pickup_Powerup` is a `Client?` that each pass sets, and the body reads it as `client!` eight times. Guide line 344 binds a chain, not a local, so the body keeps the force unwraps. A bind rule for a local that a loop sets each pass could be a docket row.
5. Raven's trailing comments inside the multi-line `if` tests of `turretG2_find_enemies` and `VEH_TurretFindEnemies` stay at the ends of the Swift test lines, and the comment after the closing parenthesis moves to the first line of the arm.
6. `NPC_utils.swift` takes the same J5 walk in this wave under another transcriptor. The review leg compares the three bodies, which follow the proof text of `docket-proofs-conflict-4.md` here.
7. `lookup.py sig` reports that the signature rows are stale for 28 stubs. No hole of this record read a signature from it.
