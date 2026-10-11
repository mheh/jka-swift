# Hole round: NPC_AI droid files

The round covers seven adopted files under `Sources/JKAMP_GameLogic/`.
The docket is `grep -n "Port-note"` over each file.

## NPC_AI_Interrogator.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Interrogator_Strafe | NULL `forward` into `AngleVectors` | filled | The callee signature has a plain `inout`, so the NULL arm only skips the write. The scratch local stays under one plain comment that names the NULL outputs. |
| Interrogator_Strafe | NULL `up` into `AngleVectors` | filled | The same comment as the row above. |
| Interrogator_Strafe | NULL `mins` into `trap_Trace` | filled | The guide gives `vec3_origin` with no comment. |
| Interrogator_Strafe | NULL `maxs` into `trap_Trace` | filled | The guide gives `vec3_origin` with no comment. |
| Interrogator_Melee | NULL `dir` into `G_Damage` | filled | `G_Damage` takes `inout vec3_t?`, so the caller declares `var dir: vec3_t? = nil` and passes `&dir`. |

## NPC_AI_GalakMech.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_GM_Pain | `if ( point )` on the local array `vec3_t point` | stands | C reads the address of a local array, so the test is always true. The block holds only Raven's comments. The guide has no form for a NULL test of a local array. Docket row 1. |
| GM_CheckFireState | NULL `right` into `AngleVectors` | filled | One plain comment names the NULL `right` and `up` outputs. |
| GM_CheckFireState | NULL `up` into `AngleVectors` | filled | The same comment as the row above. |
| NPC_BSGM_Attack | NULL `dir` into `G_Damage`, `MOD_UNKNOWN` arm | filled | `var dir: vec3_t? = nil` and `&dir`. |
| NPC_BSGM_Attack | NULL `dir` into `G_Damage`, `MOD_CRUSH` arm | filled | `var dir: vec3_t? = nil` and `&dir`. |

## NPC_AI_Sniper.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Sniper_FaceEnemy | `VectorCopy( NPCInfo->enemyLaggedPos[missFactor], target )` did not compile | stands | The view gives `enemyLaggedPos` as `Slots<Slots<Float>>`, and the guide has no form that reads a row of a `vec3_t[N]` field as a `vec3_t`. Docket row 2. |
| Sniper_UpdateEnemyPos | `CalcEntitySpot( NPC->enemy, SPOT_HEAD_LEAN, NPCInfo->enemyLaggedPos[index] )` did not compile | stands | The callee writes an `inout vec3_t`, and the guide has no form that passes a row of a `vec3_t[N]` field by reference. Docket row 2. |
| NPC_BSSniper_Attack | NULL `mins` into `trap_Trace` | filled | `vec3_origin` with no comment. |
| NPC_BSSniper_Attack | NULL `maxs` into `trap_Trace` | filled | `vec3_origin` with no comment. |

## NPC_AI_Sentry.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Sentry_Strafe | NULL `forward` into `AngleVectors` | filled | One plain comment names the NULL `forward` and `up` outputs. |
| Sentry_Strafe | NULL `up` into `AngleVectors` | filled | The same comment as the row above. |
| Sentry_Strafe | NULL `mins` into `trap_Trace` | filled | `vec3_origin` with no comment. |
| Sentry_Strafe | NULL `maxs` into `trap_Trace` | filled | `vec3_origin` with no comment. |

## NPC_AI_Remote.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Remote_Strafe | NULL `forward` into `AngleVectors` | filled | One plain comment names the NULL `forward` and `up` outputs. |
| Remote_Strafe | NULL `up` into `AngleVectors` | filled | The same comment as the row above. |
| Remote_Strafe | NULL `mins` into `trap_Trace` | filled | `vec3_origin` with no comment. |
| Remote_Strafe | NULL `maxs` into `trap_Trace` | filled | `vec3_origin` with no comment. |

## NPC_AI_Droid.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_Droid_Pain | NULL `forward` into `AngleVectors`, R5D2 arm | filled | One plain comment names the NULL `forward` and `right` outputs. |
| NPC_Droid_Pain | NULL `right` into `AngleVectors`, R5D2 arm | filled | The same comment as the row above. |
| NPC_Droid_Pain | NULL `forward` into `AngleVectors`, R2D2 arm | filled | One plain comment names the NULL `forward` and `right` outputs. |
| NPC_Droid_Pain | NULL `right` into `AngleVectors`, R2D2 arm | filled | The same comment as the row above. |

## NPC_AI_Grenadier.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_BSGrenadier_Attack | NULL `impactPos` into `NPC_ShotEntity` | filled | The callee signature has a plain `inout`, so the NULL arm only skips the write. The scratch local stays under one plain comment. |

## GameWorld properties

None. No hole in this round needs a static local or a file-scope static.

## Docket rows

1. NPC_GM_Pain, `if ( point )` at oracle/codemp/game/NPC_AI_GalakMech.c:275. The test reads the address of the local array `vec3_t point`, so C always takes the arm, and the guide has no form for it. Proposed form: a NULL test of a local array drops, and the arm's lines, here only Raven's comments, stay in place with no `if`.
2. Sniper_FaceEnemy at oracle/codemp/game/NPC_AI_Sniper.c:508 and Sniper_UpdateEnemyPos at oracle/codemp/game/NPC_AI_Sniper.c:605. The view gives the `vec3_t[24]` field `enemyLaggedPos` as `Slots<Slots<Float>>`, and the guide has no form that reads or writes one row as a `vec3_t`. Proposed form: the view generator gives a `vec3_t[N]` field a `<name>Vectors: Slots<vec3_t>` accessor with the 12-byte stride, as `BgTables.swift` does for `WP_MuzzlePoint`, so a body reads `target = NPCInfo!.enemyLaggedPosVectors[missFactor]` and passes `&NPCInfo!.enemyLaggedPosVectors[index]`.
