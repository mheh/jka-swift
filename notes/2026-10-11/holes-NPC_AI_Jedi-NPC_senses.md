# Hole round of NPC_AI_Jedi and NPC_senses

This record gives the verdict for each Port-note of `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift` and `Sources/JKAMP_GameLogic/NPC_senses.swift`, in the order of each file.

## NPC_AI_Jedi.swift

Filled 29, stands 5, blocked 0.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Boba_StopKnockdown | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Boba_Flying | Draft did not compile | stands | Raven wrote `return ((qboolean)(self->client->ps.eFlags2&EF2_FLYING))`. The guide has no form for a cast of an `int` to `qboolean`. See docket row 1. |
| Boba_FireDecide | NULL output | filled | AngleVectors NULL `right` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Boba_FireDecide | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Boba_FireDecide | NULL output | filled | AngleVectors NULL `right` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Boba_FireDecide | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| NPC_MoveDirClear | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_CheckFlipEvasions | NULL output | filled | AngleVectors NULL `forward` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_CheckFlipEvasions | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_CheckFlipEvasions | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_CheckFlipEvasions | NULL output | filled | AngleVectors NULL `forward` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_CheckFlipEvasions | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_ReCalcParryTime | Draft did not compile | stands | Raven wrote `baseTime = baseTime`, and Swift refuses a store of a variable to itself. The guide has no form. See docket row 2. |
| Jedi_SaberBlockGo | NULL output | filled | AngleVectors NULL `forward` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_SaberBlockGo | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_SaberBlockGo | Assignment inside an expression | filled | Guide section 3, an assignment inside an expression: the store `evasionType = Jedi_CheckFlipEvasions(...)` lifts before the `if`, and the `if` and its `else if` chain follow as Raven wrote them. |
| Jedi_SaberBlock | Assignment inside an expression | filled | Same form. The store `evasionType = Jedi_SaberBlockGo(NPC!, ucmd, hitloc, dir, nil, dist)` lifts before the `if`. Raven's `parryReCalcTime*1.5` into an `int` parameter takes the double rule, `Int32(Double(parryReCalcTime) * 1.5)`. |
| Jedi_EvasionSaber | NULL output | filled | AngleVectors NULL `right` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_EvasionSaber | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_EvasionSaber | NULL output | filled | AngleVectors NULL `right` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_EvasionSaber | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_FindEnemyInCone | NULL output | filled | AngleVectors NULL `right` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_FindEnemyInCone | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_SetEnemyInfo | Draft did not compile | filled | Guide section 3, primitive types, the double rule: `Float(Double(enemy_movespeed) * 0.001 * Double(prediction))` at the `scale` parameter of `_VectorMA`. |
| Jedi_FaceEnemy | Draft did not compile | stands | Raven passes `((qboolean)(NPCInfo->scriptFlags&SCF_ALT_FIRE))` to a `qboolean` parameter. The guide has no form for that cast. See docket row 1. |
| Jedi_FaceEnemy | Read of a local left as a hole | stands | The block reads `missileSpeed`, which the hole above does not declare. It waits for docket row 1. |
| Jedi_AttackDecide | NULL output | filled | AngleVectors NULL `forward` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_AttackDecide | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_TryJump | Record block leaves a loop | stands | The `trace_t trace` local sits inside the `while( sideTry < 10 )` body, and Raven's `break` leaves the loop from inside the record's block. The guide gives a closure value for a `return` only. See docket row 3. |
| Jedi_CheckEnemyMovement | NULL output | filled | AngleVectors NULL `right` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_CheckEnemyMovement | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| NPC_Jedi_Pain | NULL output | filled | AngleVectors NULL `forward` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| NPC_Jedi_Pain | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| Jedi_CheckAmbushPlayer | Assignment inside an expression | filled | Same form. The store `target_dist = DistanceHorizontalSquared(...)` lifts before the `if`. Each `continue` runs the step `i += 1` first, under the `for` loop form. |

## NPC_senses.swift

Filled 16, stands 4, blocked 0.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G_ClearLineOfSight | NULL `mins` | filled | `trap_Trace` NULL `mins`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| G_ClearLineOfSight | NULL `maxs` | filled | `trap_Trace` NULL `maxs`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| G_ClearLineOfSight | NULL `mins` | filled | `trap_Trace` NULL `mins`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| G_ClearLineOfSight | NULL `maxs` | filled | `trap_Trace` NULL `maxs`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| CanSee | NULL `mins` | filled | `trap_Trace` NULL `mins`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| CanSee | NULL `maxs` | filled | `trap_Trace` NULL `maxs`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| CanSee | NULL `mins` | filled | `trap_Trace` NULL `mins`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| CanSee | NULL `maxs` | filled | `trap_Trace` NULL `maxs`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| CanSee | NULL `mins` | filled | `trap_Trace` NULL `mins`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| CanSee | NULL `maxs` | filled | `trap_Trace` NULL `maxs`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| InFront | NULL output | filled | AngleVectors NULL `right` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| InFront | NULL output | filled | AngleVectors NULL `up` output. Guide section 3, the caller of a NULL output: a scratch local and a plain comment that names the NULL outputs, because the NULL arm of `AngleVectors` only skips the write. |
| AddSoundEvent | `++` inside an expression | stands | Raven wrote `level.alertEvents[ level.numAlertEvents ].ID = level.curAlertID++`. The guide lifts a store before the statement, but a postfix `++` stores after the read. The guide has no form for it. See docket row 4. |
| AddSightEvent | `++` inside an expression | stands | The same line as `AddSoundEvent`. See docket row 4. |
| ClearPlayerAlertEvents | Draft did not compile | stands | Raven wrote `memmove( &level.alertEvents[i], &level.alertEvents[i+1], sizeof(alertEvent_t)*(MAX_ALERT_EVENTS-(i+1) ) )`. The guide has no form for a `memmove` over a table of records. See docket row 5. |
| RemoveOldestAlert | Draft did not compile | stands | The same `memmove` over `level.alertEvents`, from `oldestEvent+1`. See docket row 5. |
| G_ClearLOS | NULL `mins` | filled | `trap_Trace` NULL `mins`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| G_ClearLOS | NULL `maxs` | filled | `trap_Trace` NULL `maxs`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| G_ClearLOS | NULL `mins` | filled | `trap_Trace` NULL `mins`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |
| G_ClearLOS | NULL `maxs` | filled | `trap_Trace` NULL `maxs`. Guide section 3: a NULL `mins` or `maxs` into `trap_Trace` is `vec3_origin` with no comment. The call already passed `vec3_origin`, so the fill deletes the note and the marker. |

## GameWorld properties

None. No hole of this round is a static local or a file-scope static.

## Docket rows

1. `Boba_Flying` and `Jedi_FaceEnemy`, a cast of an `int` expression to `qboolean`. The guide keeps an explicit cast on the page, but Swift has no `Bool` initializer from `Int32`, so no form fits. Proposed form: Raven's `(qboolean)(x)` of an `int` reads `(x) != 0`, with no comment.
2. `Jedi_ReCalcParryTime`, Raven's `baseTime = baseTime`. Swift refuses a store of a variable to itself, and the guide has no form for a statement with no effect. Proposed form: a self-store drops, and the arm keeps one comment line that quotes Raven's statement, so the arm is not empty.
3. `Jedi_TryJump`, a `break` inside a record's `scratch` closure that leaves the enclosing loop. The guide gives a closure value for a `return` only. Proposed form: a `break` or `continue` inside the block is `return true` of a flag closure, and the loop tests the flag after the closure and runs Raven's `break` or `continue` there.
4. `AddSoundEvent` and `AddSightEvent`, a postfix `++` inside an expression. The assignment form lifts the store before the statement, but a postfix `++` stores after the read. Proposed form: the statement reads the variable as it stands, and the next statement is `x += 1`.
5. `ClearPlayerAlertEvents` and `RemoveOldestAlert`, a `memmove` that shifts the records of a table down by one. The guide has no form for `memmove` over records. Proposed form: a loop from the destination index up to the last moved slot copies each record with `copy(from:)`, `level.alertEvents[j].copy(from: level.alertEvents[j + 1])`, in ascending order, so an overlap reads each source before the loop writes it.
