# Review of phase 2, wave B, combat and bones

This record reviews the diff of the hole round against HEAD 4308ee3 for seven files under `Sources/JKAMP_GameLogic/`. The transcriptor records are `holes2-combat.md` and `holes2-bones.md`. The reviewer read the diff once at the start, compared each line with Raven's C under `oracle/codemp/game/` and with the jka-rust port under `jka-rust/crates/mp/game/src/`, and checked the cited rows in the ledger of `frame-path-walk.md` and in `docket-proofs-conflict-4.md`. No build, no test, and no generator ran.

The diff has 20 hunks at the default context. They fill 37 holes, 12 in the combat files and 25 in the bones files. The table gives one row per filled hole.

## Hunks

| File:line now | Function | Row | Verdict |
|---|---|---|---|
| `g_active.swift:530` | `G_TouchTriggers` | A3 | match |
| `g_active.swift:718` | `SpectatorThink`, `pm.baseEnt` | A4 | match |
| `g_active.swift:719` | `SpectatorThink`, `pm.entSize` | A5 | match |
| `g_active.swift:2571` | `ClientThink_real`, `pm.pmove_fixed` | A6 | match |
| `g_active.swift:2623` | `ClientThink_real`, `pm.baseEnt` | A4 | match |
| `g_active.swift:2624` | `ClientThink_real`, `pm.entSize` | A5 | match |
| `g_combat.swift:2793` | `G_Dismember`, render status test | C2 | match |
| `g_combat.swift:2896` | `G_Dismember`, NPC surface test | C2 | match |
| `g_weapon.swift:1533` | `prox_mine_think` | D7 | match |
| `g_weapon.swift:4152` | `FireVehicleWeapon`, `start` | D8, M2 | match |
| `g_weapon.swift:4153` | `FireVehicleWeapon`, `dir` | D8, M2 | match |
| `w_saber.swift:864` | `G_G2NPCAngles` | E2 | match |
| `g_items.swift:414` | `CreateShield` | F1, A6 | match |
| `g_items.swift:1454` | `EWeb_SetBoneAngles`, `thebone` | F2, J5 | match |
| `g_items.swift:1455` | `EWeb_SetBoneAngles`, `firstFree` | F2, J5 | match |
| `g_items.swift:1462` | `EWeb_SetBoneAngles`, `boneVector` | F2, J5 | match |
| `g_items.swift:1463` | `EWeb_SetBoneAngles`, `freeBoneVec` | F2, J5 | match |
| `g_items.swift:1465` | `EWeb_SetBoneAngles`, the walk | F2, J5, E2 | match |
| `g_items.swift:1495` | `EWeb_SetBoneAngles`, the create arm | F2, J5 | match |
| `g_items.swift:1513` | `EWeb_SetBoneAngles`, the angles store | F2, J5 | match |
| `g_items.swift:1970` | `Pickup_Powerup` | F3 | match |
| `g_turret_G2.swift:40` | `G2Tur_SetBoneAngles`, `thebone` | Q2, J5 | match |
| `g_turret_G2.swift:41` | `G2Tur_SetBoneAngles`, `firstFree` | Q2, J5 | match |
| `g_turret_G2.swift:48` | `G2Tur_SetBoneAngles`, `boneVector` | Q2, J5 | match |
| `g_turret_G2.swift:49` | `G2Tur_SetBoneAngles`, `freeBoneVec` | Q2, J5 | match |
| `g_turret_G2.swift:51` | `G2Tur_SetBoneAngles`, the walk | Q2, J5 | match |
| `g_turret_G2.swift:89` | `G2Tur_SetBoneAngles`, the create arm | Q2, J5 | match |
| `g_turret_G2.swift:99` | `G2Tur_SetBoneAngles`, the angles store | Q2, J5 | match |
| `g_turret_G2.swift:595` | `turretG2_find_enemies` | Q3 | match |
| `g_vehicleTurret.swift:35` | `VEH_TurretCheckFire` | M2, D8 | match |
| `g_vehicleTurret.swift:63` | `VEH_TurretAnglesToEnemy`, `diff` | M2 | match |
| `g_vehicleTurret.swift:74` | `VEH_TurretAnglesToEnemy`, `enemyDir` | M2 | match |
| `g_vehicleTurret.swift:91` | `VEH_TurretAim` | M2 | match |
| `g_vehicleTurret.swift:181` | `VEH_TurretFindEnemies`, `org2` | M2 | match |
| `g_vehicleTurret.swift:185` | `VEH_TurretFindEnemies`, the loop | M3, R9 | match |
| `g_vehicleTurret.swift:348` | `VEH_TurretThink`, `enemyDir` | M2 | match |
| `g_vehicleTurret.swift:353` | `VEH_TurretThink`, the PVS block | M2, guide lines 350-364 | style |

## Checks that hold

- Every filled hole removed its Port-note, its `// Raven wrote:` line, and its `portMissing` call. The files now hold 7, 4, 4, 0, 0, 0, and 0 Port-notes in the order `w_saber`, `g_active`, `g_weapon`, `g_combat`, `g_items`, `g_turret_G2`, `g_vehicleTurret`, as the two records say.
- The blocked holes of `G_G2TraceCollide` and `WP_CalcVehMuzzle`, the four no-form `pm.trace` and `pm.pointcontents` holes, and the `goto blockStuff` note are not in the diff, so they are unchanged. No other line in the seven files changed.
- The bone walks match Raven's address arithmetic. `entityState_t` declares `boneIndex1` to `boneIndex4` and `boneAngles1` to `boneAngles4` as adjacent fields at q_shared.h:2799-2814, and `EntityState+Bones.swift` bases slot 0 at `boneIndex1` and at `boneAngles1`. So `thebone = 0` is `&ent->s.boneIndex1`, and `case 0` to `case 2` set slots 1 to 3, which are `boneIndex2` to `boneIndex4`. The `break` sits in an `if`, not in the `switch`, so it leaves the `while` as Raven's does. The three bodies are the text of the conflict 4 verdict.
- The four scratch loops open the closure inside the loop around the whole body, each `continue` is a bare `return`, and `i += 1` follows the closure, so the step runs on every path Raven steps. No loop body has a `break` or a `return` of Raven's, so the F3, M3, and Q3 form holds.
- The `pm` fills are the ruled text of A4, A5, and A6, word for word. `G_TouchTriggers` already steps `i` before each `continue` in its `while`, and the A3 fill does the same. The generated `!=` for `EntityTouch?` is at `Callbacks.swift:56`.
- `Pickup_Powerup` writes `Double(_DotProduct(delta, forward)) < 0.4` under the double-math rule. jka-rust compares in `f32`, so the Swift is nearer to Raven there. `tr.fraction != 1.0` and `tr.fraction == 1.0` keep the guide's own F3 spelling, and 1.0 is exact in `float`.
- `client == other.client` compares handles through the `Hashable` conformance of `HandleView`, which is Raven's pointer compare.
- `VEH_TurretCheckFire` passes `&pVeh.m_vMuzzlePos[curMuzzle]` to the `inout start` of `WP_FireVehicleWeapon`, and `WP_TraceSetStart` writes that vector. So the write lands in the muzzle slot, as Raven's pointer does. jka-rust passes a copy and loses that write. The gate must still confirm that Swift takes the `inout` through the nonmutating setter.
- `VEH_TurretFindEnemies` writes `pVeh.m_pPilot.map { Entity($0) }` for Raven's cast, the guide's own example. `target!.classname!` follows Raven's `target->classname &&` test in the same chain.
- `prox_mine_think` writes `Float(FLECHETTE_MINE_RADIUS_CHECK)`, the D7 text and the guide rule for an `int` into a `float` parameter. jka-rust writes the same cast.
- `G_Dismember` drops Raven's `limbName` and `stubCapName` terms with no comment, as C2 and guide line 335 order. jka-rust drops the same terms.
- `CreateShield` declares `height`, `posWidth`, `negWidth`, and `paramData` as `Int32`, so the F1 text compiles as Raven's `int` math.
- The comment lines are Raven's text. Where Raven put a comment after the closing parenthesis of a multi-line `if`, the comment moves to the first line of the arm. No new comment line breaks the STE rules, and none has an em dash.

## Findings

1. `g_vehicleTurret.swift:353`, `VEH_TurretThink`, style. Raven puts a blank line after `trap_Trace( &tr, start, NULL, NULL, end, parent->s.number, MASK_SHOT );` at g_vehicleTurret.c:424-425 and before the `if` at line 426. The Swift line `trap_Trace(tr, start, vec3_origin, vec3_origin, end, parent.s.number, MASK_SHOT)` has no blank line after it, and the `if` follows at once. jka-rust is not the reference for blank lines. The behavior is the same, and only the layout differs from Raven's.
