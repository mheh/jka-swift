# Hole round: g_items.swift

The docket of `Sources/JKAMP_GameLogic/g_items.swift` held 39 Port-notes.
29 are filled, 10 stand, and 0 are blocked.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| CreateShield | NULL `mins` into `trap_Trace` | filled | The call already passes `vec3_origin`, so the note and the marker go. |
| CreateShield | NULL `maxs` into `trap_Trace` | filled | Same form as `mins`. |
| CreateShield | NULL `mins` into `trap_Trace`, positive trace | filled | Same form. |
| CreateShield | NULL `maxs` into `trap_Trace`, positive trace | filled | Same form. |
| CreateShield | NULL `mins` into `trap_Trace`, negative trace | filled | Same form. |
| CreateShield | NULL `maxs` into `trap_Trace`, negative trace | filled | Same form. |
| CreateShield | `xaxis << 24` on a `qboolean` | stands | A `Bool` takes no shift, and the guide has no form for a `qboolean` in integer arithmetic. Docket row 1. |
| PlaceShield | NULL `right` into `AngleVectors` | filled | `lookup.py sig AngleVectors` gives a plain `inout`, so the NULL arm only skips the write. The call site keeps the scratch locals under one comment that names the NULL outputs. |
| PlaceShield | NULL `up` into `AngleVectors` | filled | Same comment as `right`. |
| pas_find_enemies | local `gentity_t *entity_list[MAX_GENTITIES]` | filled | `var entity_list = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))`, the caller form for an array of struct pointers the callee fills. |
| pas_find_enemies | read of `entity_list` in `G_RadiusList` | filled | `&entity_list` into `inout [Entity?]`, and `Float(TURRET_RADIUS)` at the `Float` parameter, as the file already does for `adjustRespawnTime(Float(RESPAWN_HOLDABLE), ...)`. |
| pas_find_enemies | read of `entity_list[i]` | filled | `target = entity_list[i]`. |
| pas_find_enemies | NULL `mins` into `trap_Trace` | filled | Same form as CreateShield. |
| pas_find_enemies | NULL `maxs` into `trap_Trace` | filled | Same form. |
| pas_adjust_enemy | NULL `mins` into `trap_Trace` | filled | Same form. |
| pas_adjust_enemy | NULL `maxs` into `trap_Trace` | filled | Same form. |
| ItemUse_Sentry | NULL `right` into `AngleVectors` | filled | Same form as PlaceShield. |
| ItemUse_Sentry | NULL `up` into `AngleVectors` | filled | Same form. |
| ItemUse_Sentry | `g2radius = 30.0f`, a `float` into an `int` | filled | `sentry!.s.g2radius = Int32(30.0)`, the float-into-int store form. |
| ItemUse_Seeker | `"remote"` into `NPC_SpawnType` | filled | `lookup.py sig NPC_SpawnType` now gives `String?` for `npc_type` and `targetname`, so the call passes the literal and `nil`. |
| ItemUse_Seeker | read of `remote` | filled | Raven's block with the file's own NULL-test form, `remote != nil && remote!.client != nil`. His `a = b = c` lifts the inner store first. |
| ItemUse_UseDisp | NULL `right` into `AngleVectors` | filled | Same form as PlaceShield. |
| ItemUse_UseDisp | NULL `up` into `AngleVectors` | filled | Same form. |
| EWeb_SetBoneAngles | pointer local `int *thebone` | stands | The guide has no form for a pointer to one of several scalar fields of a record. Docket row 2. |
| EWeb_SetBoneAngles | pointer local `int *firstFree` | stands | Docket row 2. |
| EWeb_SetBoneAngles | pointer local `vec3_t *boneVector` | stands | Docket row 2. |
| EWeb_SetBoneAngles | pointer local `vec3_t *freeBoneVec` | stands | Docket row 2. |
| EWeb_SetBoneAngles | `while (thebone)` loop | stands | It reads the four pointer locals. Docket row 2. |
| EWeb_SetBoneAngles | `if (!thebone)` block | stands | It reads and writes through the pointer locals. Docket row 2. |
| EWeb_SetBoneAngles | `VectorCopy(angles, *boneVector)` | stands | A write through a pointer local. Docket row 2. |
| EWeb_Create | NULL `right` into `AngleVectors` | filled | Same form as PlaceShield. |
| EWeb_Create | NULL `up` into `AngleVectors` | filled | Same form. |
| Pickup_Powerup | `trace_t tr` inside a `for` body with `continue` | stands | The scratch closure is the loop body, and the guide has no form for a `continue` inside it. Docket row 3. |
| RespawnItem | `ent = master`, first loop | filled | `ent = master!`, the store from an optional into a value. |
| RespawnItem | `ent = ent->teamchain`, first loop | stands | Raven's loop runs `ent` to NULL, and `ent` is a non-optional `Entity`. A force unwrap traps at the end of the chain, and the draft's `while true` has lost Raven's test. Docket row 4. |
| RespawnItem | `ent = master`, second loop | filled | `ent = master!`. |
| RespawnItem | `ent = ent->teamchain`, second loop | filled | `ent = ent.teamchain!`. The loop stops at `count < choice`, so the chain never ends under it. |
| Drop_Item | NULL `right` into `AngleVectors` | filled | Same form as PlaceShield. |
| Drop_Item | NULL `up` into `AngleVectors` | filled | Same form. |

## GameWorld properties

None. No hole in this file is a static local or a file-scope static.

## Docket rows

1. CreateShield, `paramData = (xaxis << 24) | ...` at oracle/codemp/game/g_items.c:330. A `qboolean` local is a Swift `Bool`, and no guide form lets a `Bool` take an integer operator. Proposed form: a `qboolean` that meets an integer operator reads `(xaxis ? 1 : 0)`, or `Promotion.swift` gains `<<` and `|` between `Bool` and `Int32` that promote the `Bool` as C does.
2. EWeb_SetBoneAngles, the locals `thebone`, `firstFree`, `boneVector`, and `freeBoneVec` at oracle/codemp/game/g_items.c:1499. Each is a pointer to one of the four numbered fields `boneIndex1` to `boneIndex4` or `boneAngles1` to `boneAngles4` of `ent->s`, and the guide has no form for a pointer to a chosen field of a record. Proposed form: each pointer is an `Int32?` slot number, 1 to 4 or nil for NULL, and a private hand accessor pair on the view reads and writes the field of that number.
3. Pickup_Powerup, the `for` loop at oracle/codemp/game/g_items.c:2024 whose body declares `trace_t tr` and holds a `continue`. Proposed form: when Raven's record block is the whole loop body, the closure opens inside the loop, a `continue` is a `return` from the closure, and the loop step follows the closure.
4. RespawnItem, the first loop at oracle/codemp/game/g_items.c:2300, `for (count = 0, ent = master; ent; ent = ent->teamchain, count++)`. The loop runs `ent` to NULL, but `ent` is a non-optional `Entity`, and the draft's `while true` has lost the test. Proposed form: a loop that runs a non-optional variable to NULL walks an optional local, `var e: Entity? = master` and `while e != nil { e = e!.teamchain; count += 1 }`, because no later statement reads the NULL value.
