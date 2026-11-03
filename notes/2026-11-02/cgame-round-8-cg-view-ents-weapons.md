# The cgame transcription rounds, round 8, cg_view, cg_ents, and cg_weapons

The record of the eighth cgame transcription round, three stems, `cg_view`, `cg_ents`, and `cg_weapons`, on the branch `cgame-round-8-cg-view-ents-weapons` off master `07f5874`.

## The adoption

The draft gate gave these lines:

- `cg_view: 42 of 42 hand functions replaced, 0 kept, 16 holes, 0 cascade errors, 0 defects, 13 compile holes over 2 passes`
- `cg_ents: 40 of 40 hand functions replaced, 0 kept, 27 holes, 0 cascade errors, 0 defects, 23 compile holes over 7 passes`
- `cg_weapons: 28 of 28 hand functions replaced, 0 kept, 21 holes, 0 cascade errors, 0 defects, 19 compile holes over 5 passes`

The gate also counted 6 defects in cg_players.swift, at the three callers of CG_G2WeaponInstance. The skeleton has no RETURNS row for the `void *` of CG_G2WeaponInstance, so the draft wrote the function with no parameters and a `Never` return. The adoption kept the hand signature of 177a133 under the three signature marker lines, and the build passed. Adopted at 5fa89f2 with 64 Port-notes.

## The hole rounds

- 4e215fa, cg_view. 16 notes and 3 initializer markers closed.
- f80e937, cg_ents. 27 notes and 3 initializer markers closed.
- c69d2bc, cg_weapons. 21 notes, the signature marker of CG_G2WeaponInstance, and the global marker of g2WeaponInstances closed.

The three files hold 0 Port-notes and 0 `portMissing` lines. The build passes, and `swift test --no-parallel` passes 113 tests across its runs of 1, 84, 13, and 15. The round adds no AI line, because every site takes a form of the guide or of an earlier body.

## The shapes

- An axis of a view into AnglesToAxis, AxisClear, AxisCopy, or MatrixMultiply passes the `Slots` to the forward of 1cc9dad, and an input axis passes `Array(...)`. 27 sites.
- RotateAroundDirection fills a copy of the axis that stores back, the CG_G2PlayerAngles form of cg_players.swift. 5 sites.
- An axis into a trap that the engine only reads takes a copy under the engine read comment. `S_Respatialize` copies the axis at `snd_dma.cpp:2518`, and `CreateEffect` takes a work copy at `FxScheduler.cpp:1230`. 3 sites.
- `atan2` of an `int` and a `float` takes `Double` arguments and stores the `Float`. 3 sites.
- The static local `zoomSoundTime` and the file-scope static `g2WeaponInstances` are CGameWorld properties with forwards.
- A file-scope variable that no body assigns takes Raven's initializer, the `BMS_START` form. 6 sites.
- The memcpy of `areamask` is the index loop of the cg_players sound copies.
- The `sizeof(a)/sizeof(a[0])` test reads the count of the `Slots`, and the `a[n++] = v` store is the store and then the step.
- The pointer-sized memset of `itemInfo` zeroes the 8 bytes of `registered` and `models[0]`, the ai_wpnav.swift form.
- The `bg_itemlist + 1` walk is an index local, the BG_FindItemForWeapon form.
- The `Q_strupr` call inside a `va` argument is the in-place statement before the call, the cg_event form.

## The notes left

None.

## Drafter rows found

Each row is a shape a drafter rule could draft. The first line is Raven's C, and the second line is the hand Swift.

- The axis of a view into an axis function with a `Slots` forward.
  `AnglesToAxis( cent->lerpAngles, ent.axis )`
  `AnglesToAxis(cent.lerpAngles, ent.axis)`
- An input axis of a view into an axis function.
  `AxisCopy( cg.autoAxis, ent.axis )`
  `AxisCopy(Array(cg.autoAxis), ent.axis)`
- An axis of a view into RotateAroundDirection.
  `RotateAroundDirection( ent.axis, cg.time * 0.5f )`
  `var axisCopy = [ent.axis[0], ent.axis[1], ent.axis[2]]`, `RotateAroundDirection(&axisCopy, cg.time * 0.5)`, and one store per row.
- An axis of a view into a trap that the engine only reads. The row needs a table of the trap parameters with the engine cite.
  `trap_S_Respatialize( cg.snap->ps.clientNum, cg.refdef.vieworg, cg.refdef.viewaxis, inwater )`
  `var viewaxis = Array(cg.refdef.viewaxis)`, `trap_S_Respatialize(cg.snap!.ps.clientNum, cg.refdef.vieworg, &viewaxis, inwater)`
- `atan2` of an `int` and a `float`.
  `fov_y = atan2( cg.refdef.height, x )`
  `fov_y = Float(atan2(Double(cg.refdef.height), Double(x)))`
- A store of a variable to itself.
  `fov_x = fov_x`
  ``// Raven wrote `fov_x = fov_x`, a store with no effect, and Swift refuses a store of a variable to itself.``
- A cgame static local that a statement reads before it writes.
  `static int zoomSoundTime = 0;`
  `var zoomSoundTime: Int32 = 0` on CGameWorld and a forward in the stem file.
- A file-scope `void *` array.
  `static void *g2WeaponInstances[MAX_WEAPONS];`
  `var g2WeaponInstances: [OpaquePointer?] = Array(repeating: nil, count: Int(MAX_WEAPONS))` on CGameWorld and a forward at the stub entry.
- A memset of zero over a file-scope `void *` array.
  `memset(g2WeaponInstances, 0, sizeof(g2WeaponInstances))`
  `g2WeaponInstances.fill(nil)`
- A `void *` return of a function that is not an allocator.
  `void *CG_G2WeaponInstance(centity_t *cent, int weapon)`
  `func CG_G2WeaponInstance(_ cent: Centity, _ weapon: Int32) -> OpaquePointer?`
- A file-scope variable that no body assigns, with a constant initializer.
  `int CG_BMS_START = 0;`
  `let CG_BMS_START: Int32 = 0`
- A memcpy of a whole fixed scalar array between two views.
  `memcpy( cg.refdef.areamask, cg.snap->areamask, sizeof( cg.refdef.areamask ) )`
  `var k: Int32 = 0`, `while k < MAX_MAP_AREA_BYTES { cg.refdef.areamask[k] = cg.snap!.areamask[k]; k += 1 }`
- The count of a fixed array field in a test.
  `if (cg.radarEntityCount == sizeof(cg.radarEntities)/sizeof(cg.radarEntities[0]))`
  `if cg.radarEntityCount == cg.radarEntities.count`
- A post-increment of a field in the index of a narrow array store.
  `cg.radarEntities[cg.radarEntityCount++] = cent->currentState.number`
  `cg.radarEntities[cg.radarEntityCount] = Int16(truncatingIfNeeded: cent.currentState.number)`, then `cg.radarEntityCount += 1`
- A store of `0` into a handle field.
  `cent->ghoul2 = 0`
  `cent.ghoul2 = nil`
- A memset of the size of a pointer over a record.
  `memset( itemInfo, 0, sizeof( &itemInfo ) )`
  `itemInfo!.registered = false`, `itemInfo!.models[0] = 0`
- A `String?` row of a view's string table into a `String` parameter with no guard.
  `trap_R_RegisterModel( item->world_model[1] )`
  `trap_R_RegisterModel(item!.world_model[1]!)`
- A pointer into a `String?` row at an offset.
  `Q_stricmp(&item->world_model[0][strlen(item->world_model[0]) - 4], ".glm")`
  `Q_stricmp(CharBuf(item!.world_model[0]!)[(strlen(item!.world_model[0]!) - 4)...], ".glm")`
- An in-place text call inside an argument.
  `va("SP_INGAME_%s",Q_strupr(upperKey))`
  `Q_strupr(&upperKey)` before the statement, then `va("SP_INGAME_%s", upperKey)`
- A record pointer walk over `bg_itemlist` in a `for` loop.
  `for ( item = bg_itemlist + 1 ; item->classname ; item++ )`
  `itemIndex = 1`, `while bg_itemlist[itemIndex].classname != nil { let item = bg_itemlist[itemIndex] ... itemIndex += 1 }`
