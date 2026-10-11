# Hole round: g_saga, g_turret_G2, g_turret, g_target

This round gave a verdict on each Port-note in the four files under `Sources/JKAMP_GameLogic/`. The counts are 42 filled, 14 stands, and 3 blocked, from 59 holes. No build ran, under the transcriptor gate.

## g_saga.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| InitSiegeMode | `!levelname \|\| !levelname[0]` did not compile | filled | `levelname` is a C array, so `!levelname` drops as a never-null variable. The test is `levelname[0] == 0` and `break failure`. |
| G_SiegeSetObjectiveComplete | pointer local `char *p` | filled | A write cursor over `gObjectiveCfgStr`, `var p: Int32? = nil`. |
| G_SiegeSetObjectiveComplete | store `p = strstr(..., "t1")` | filled | `strstr` returns the offset as `Int32?`. |
| G_SiegeSetObjectiveComplete | store `p = strstr(..., "t2")` | filled | Same form. |
| G_SiegeSetObjectiveComplete | read `if (!p)` | filled | `if p == nil { return }`, and `assert` drops. |
| G_SiegeSetObjectiveComplete | read of `p` in the walk loop | filled | `gObjectiveCfgStr[p!]` reads and writes the byte, and `p! += 1` steps. Raven's comments stay. |
| G_SiegeGetCompletionStatus | pointer local `char *p` | filled | Same write-cursor form, read only. |
| G_SiegeGetCompletionStatus | store `p = strstr(..., "t1")` | filled | Same form. |
| G_SiegeGetCompletionStatus | store `p = strstr(..., "t2")` | filled | Same form. |
| G_SiegeGetCompletionStatus | read `if (!p)` | filled | `if p == nil { return false }`. |
| G_SiegeGetCompletionStatus | read of `p` in the walk loop | filled | Raven's `break` after the two returns stays, so the compiler warns on a line Raven wrote. |
| UseSiegeTarget | assignment inside a `while` test | filled | `while let next = G_Find(...)`. `t == ent` compares the entity numbers. Nothing after the loop reads `t`. |
| SiegeItemRespawnOnOriginalSpot | optional `carrier` into a value parameter | blocked | Raven's `SiegeItemRemoveOwner` tests `if (carrier)` at g_saga.c:1344, so a force unwrap traps where Raven skips. The parameter needs a NULL-sweep entry in `rulings.py` that makes it `Entity?`, and that is a signature change outside this round. |
| SiegeItemUse | declaration `targ = G_Find(NULL, ...)` | filled | `let targ = G_Find(nil, \.targetname, ent.paintarget!)`. |
| SiegeItemUse | read of `targ` | filled | `if targ != nil && targ!.inuse`, and `G_SetOrigin(ent, &targ!.r.currentOrigin)`. |
| SP_misc_siege_item | byte read `ent->model[strlen(ent->model) - 4]` | stands | The lookup tool gives `model: String?`, not `OpaquePointer?` as the note says. The guide has no form for a pointer into the text of a `char *` field. See docket row 1. |
| SP_misc_siege_item | `G_SpawnVector("mins", ..., ent->r.mins)` | blocked | `lookup.py sig G_SpawnVector` gives `out: inout Float`. The guide row for a pointer Raven fills as a fixed set of floats gives `inout vec3_t`. The fix is in `g_spawn.swift` and the tables, outside this round. |
| SP_misc_siege_item | `G_SpawnVector("maxs", ..., ent->r.maxs)` | blocked | Same as the row above. |

## g_turret_G2.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G2Tur_SetBoneAngles | pointer local `int *thebone` | stands | The pointer picks one of four fields of `ent->s`. See docket row 2. |
| G2Tur_SetBoneAngles | pointer local `int *firstFree` | stands | Docket row 2. |
| G2Tur_SetBoneAngles | pointer local `vec3_t *boneVector` | stands | Docket row 2. |
| G2Tur_SetBoneAngles | pointer local `vec3_t *freeBoneVec` | stands | Docket row 2. |
| G2Tur_SetBoneAngles | read of `thebone` in the walk loop | stands | Docket row 2. |
| G2Tur_SetBoneAngles | read of `thebone` after the loop | stands | Docket row 2. |
| G2Tur_SetBoneAngles | `VectorCopy(angles, *boneVector)` | stands | Docket row 2. |
| turretG2_fire | NULL `right` into `AngleVectors` | filled | The callee's NULL arm only skips the write, so one plain comment names the NULL outputs. |
| turretG2_fire | NULL `up` into `AngleVectors` | filled | Same comment as the row above. |
| turretG2_find_enemies | local `gentity_t *entity_list[MAX_GENTITIES]` | filled | `var entity_list = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))`. |
| turretG2_find_enemies | `G_RadiusList` into `entity_list` | filled | The callee takes `inout [Entity?]`, so the call passes `&entity_list`. |
| turretG2_find_enemies | `for` loop with `trace_t tr` and `continue` | stands | Each `continue` sits inside the scratch closure. See docket row 3. |
| turretG2_find_enemies | `VALIDSTRING(self->target2)` | filled | The `String?` overload of `VALIDSTRING`. `G_UseTargets2` takes `String?`. |
| turretG2_base_think | NULL `mins` into `trap_Trace` | filled | `vec3_origin` was already on the call, so the note and marker go. |
| turretG2_base_think | NULL `maxs` into `trap_Trace` | filled | Same as the row above. |
| finish_spawning_turretG2 | NULL `right` into `AngleVectors` | filled | Plain comment form. |
| finish_spawning_turretG2 | NULL `up` into `AngleVectors` | filled | Plain comment form. |

## g_turret.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| turret_head_think | NULL `right` into `AngleVectors` | filled | Plain comment form. |
| turret_head_think | NULL `up` into `AngleVectors` | filled | Plain comment form. |
| turret_find_enemies | local `gentity_t *entity_list[MAX_GENTITIES]` | filled | The caller declaration of the array form. |
| turret_find_enemies | `G_RadiusList` into `entity_list` | filled | `&entity_list`, inside the scratch closure. |
| turret_find_enemies | `target = entity_list[i]` | filled | An `Int32` index reads the array as it is. |
| turret_find_enemies | NULL `mins` into `trap_Trace` | filled | `vec3_origin`, no comment. |
| turret_find_enemies | NULL `maxs` into `trap_Trace` | filled | Same as the row above. |
| turret_find_enemies | `VALIDSTRING(self->target2)` | filled | Same form as in g_turret_G2. |
| turret_base_think | NULL `mins` into `trap_Trace` | filled | `vec3_origin`, no comment. |
| turret_base_think | NULL `maxs` into `trap_Trace` | filled | Same as the row above. |

## g_target.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Use_Target_Give | assignment inside a `while` test | filled | `while let next = G_Find(t, \.targetname, ent.target!)`. The `continue` runs the test again, as in C. `Touch_Item` takes the scratch `trace`. |
| Use_target_remove_powerups | `memset` over `ps.powerups` | filled | The lookup tool gives `powerups: Slots<Int32>`, so the memset of the whole array is `activator.client!.ps.powerups.fill(0)`. |
| Use_Target_Print | byte read `ent->message[0]`, the activator arm | stands | The lookup tool gives `message: String?`. Docket row 1. |
| Use_Target_Print | byte read `ent->message[0]`, the red team arm | stands | Docket row 1. |
| Use_Target_Print | byte read `ent->message[0]`, the blue team arm | stands | Docket row 1. |
| Use_Target_Print | byte read `ent->message[0]`, the broadcast arm | stands | Docket row 1. |
| target_laser_think | NULL `mins` into `trap_Trace` | filled | `vec3_origin`, no comment. |
| target_laser_think | NULL `maxs` into `trap_Trace` | filled | Same as the row above. |
| target_laser_start | `ent = G_Find(NULL, ...)` | filled | `ent = G_Find(nil, \.targetname, self.target!)`. |
| target_kill_use | NULL `dir` into `G_Damage` | filled | `G_Damage` takes `inout vec3_t?`, so the caller declares `var dir: vec3_t? = nil` and passes `&dir`. |
| target_random_use | assignment inside the first `while` test | filled | `while let` form. The second loop reads `t`, so `t = nil` follows the loop. |
| target_random_use | assignment inside the second `while` test | filled | `while let` form. Raven's commented-out print stays in the empty arm. |
| scriptrunner_run | `numNewICARUSEnts++` inside a `va` argument | stands | The lift form reads the variable after the store, but a post-increment reads it before. See docket row 4. |
| G_SetActiveState | assignment inside a `while` test | filled | `while let` form, and the `?:` store stays as Raven wrote it. |

A fill compares two entities by `s.number`, the slot index, because two entity pointers compare as their slots.
The `AngleVectors` fills rest on Raven's `q_math.c`, where each output has its own `if` and the NULL arm only skips that write. That file is outside the read set of this round, so a reviewer can confirm it.

## GameWorld properties

None. No hole in the four files needs a static local or a file-scope static.

## Docket rows

1. A byte read through the text of a `char *` field, `ent->model[strlen(ent->model) - 4]` in SP_misc_siege_item and `ent->message[0]` in Use_Target_Print. The view gives the field as `String?`, and the guide gives the byte-walk form only for a `String` parameter and a `char name[N]` truth test. Proposed form: the site reads `CharBuf(ent.message!)` and then the byte subscript or the suffix subscript, as for a `String` parameter that a body walks by byte. The existing Port-note text says `OpaquePointer?`, which is not true.
2. A pointer local that picks one of several fields of one record, `thebone` and `boneVector` over `ent->s.boneIndex1` to `boneIndex4` and `boneAngles1` to `boneAngles4` in G2Tur_SetBoneAngles. The "pointer to a chosen file-scope variable" form covers only file-scope variables. Proposed form: an `Int32` field index local, 0 to 3 with -1 for NULL, and two private helpers that read and write the field of that index through a `switch`.
3. A `continue` inside a scratch closure whose record Raven declares at the top of a `for` body, in turretG2_find_enemies. The guide maps a `return` inside the block to the closure's value, but it gives no form for a `continue`. Proposed form: when the closure spans the whole loop body, a `continue` is a `return` of the closure, and the loop step follows the closure.
4. A post-increment inside an expression, `va("newICARUSEnt%d", numNewICARUSEnts++)` in scriptrunner_run. The lift form puts the store first, so the expression reads the new value. Proposed form: the expression reads the variable as it is, and the step `numNewICARUSEnts += 1` follows as its own statement after the enclosing statement.
