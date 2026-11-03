# The cgame transcription rounds, round 10, the near-clean stems

The record of the tenth cgame transcription round, eleven stems on the branch `cgame-round-10-near-clean` off master `07f5874`: cg_snapshot, cg_playerstate, SpeederNPC, cg_scoreboard, WalkerNPC, cg_info, AnimalNPC, cg_light, cg_turret, cg_weaponinit, and cg_marks.

## The adoption

The draft gate ran over the ten stems without cg_marks and ended at 51 holes, 0 cascade errors, 0 defects, and 39 compile holes over 6 passes. The gate lines:

- `cg_snapshot: 7 of 7 hand functions replaced, 0 kept, 2 holes, 0 cascade errors, 0 defects, 2 compile holes over 2 passes`
- `cg_playerstate: 7 of 7 hand functions replaced, 0 kept, 1 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `SpeederNPC: 6 of 9 hand functions replaced, 0 kept, 5 holes, 0 cascade errors, 0 defects, 3 compile holes over 2 passes`
- `cg_scoreboard: 6 of 6 hand functions replaced, 0 kept, 4 holes, 0 cascade errors, 0 defects, 2 compile holes over 2 passes`
- `WalkerNPC: 5 of 8 hand functions replaced, 0 kept, 2 holes, 0 cascade errors, 0 defects, 2 compile holes over 2 passes`
- `cg_info: 5 of 5 hand functions replaced, 0 kept, 3 holes, 0 cascade errors, 0 defects, 3 compile holes over 2 passes`
- `AnimalNPC: 5 of 8 hand functions replaced, 0 kept, 2 holes, 0 cascade errors, 0 defects, 2 compile holes over 2 passes`
- `cg_light: 3 of 3 hand functions replaced, 0 kept, 2 holes, 0 cascade errors, 0 defects, 1 compile holes over 2 passes`
- `cg_turret: 2 of 2 hand functions replaced, 0 kept, 1 holes, 0 cascade errors, 0 defects, 1 compile holes over 2 passes`
- `cg_weaponinit: 1 of 1 hand functions replaced, 0 kept, 29 holes, 0 cascade errors, 0 defects, 23 compile holes over 2 passes`

The ten stubs were adopted at 0a7e81e with 51 Port-notes, and the build passed.

cg_marks took no adoption. Its one `portMissing` line is the dead stub of CG_ParticleExplosion, with the dead note line of the `DEAD` table of `rulings.py` above the marker pair. No file of `oracle/` calls the function, so the stub is the rule 20 form that R17 ruled, and it stays.

## The hole rounds

One commit per stem closed the notes by hand:

- b8553be, cg_snapshot. The two `memcpy` of an entity state store the record through the view setter, `cent!.currentState = state!`.
- a06d73d, cg_playerstate. Raven's `*ops = *ps` is `ops.copy(from: ps)`.
- 7eaa671, SpeederNPC. The strafe test, the `Attacking` local, and its animation chain take the text of the game body of the same file.
- 16168c8, 21896bb, and the SpeederNPC commit. The `G_Create*NPC` memset and the info store go through `pVeh!`, as the game bodies do.
- f9ecbc8, cg_scoreboard. The `float *color` parameter takes `&color[0]` and `&fadeColor![0]`, the first float of Raven's pointer. `fade = *fadeColor` reads `fadeColor![0]`. The pre-increment in the test is a step and then the test.
- 4ff650f, cg_info. `Q_strupr(&upperKey)` runs in place, and the call passes `String(upperKey)`.
- a649d86, cg_light. `*(int*)ls->value` joins the four bytes in little-endian order under one AI line. The light style string is a CharBuf, and Raven's expression is two terms.
- add4245, cg_turret. The test of the `turAngles` array address is always true, so the bone call runs with no test.
- 691923e, cg_weaponinit. The `bg_itemlist + 1` walks are `itemIndex` and `ammoIndex`. The memset is `weaponInfo!.clear()`. MAKERGB is three stores under one comment that names the macro. The 16 trail function stores use the 14 thunks of a private `WeaponInfoThunks`, in the `VehicleInfoThunks` form.

The build passes, and `swift test --no-parallel` passes 113 tests across its runs of 1, 84, 13, and 15.

## The shapes

- A `memcpy` or `*a = *b` of a whole record: the view setter for a field, `copy(from:)` for a record pointer.
- A record pointer out-param after its allocation: the force unwrap of the `inout View?`.
- A `float *` parameter the callee never reads: the first element of the caller's array or vector.
- A `bg_itemlist + 1` walk: an index local.
- A store of a function into a callback field of another record: a private thunk enum at the end of the stub.
- A multi-statement macro, MAKERGB: its stores at the site.
- A reinterpret of four bytes as an `int`: the bytes joined with shifts.
- A truth test of an array field: no test.

## The notes left

cg_info holds 2 Port-notes and 2 `portMissing` lines, at the two reads of `forceMasteryLevels` in CG_DrawInformation. Raven declares the table at `bg_misc.c:150`, and `bg_misc.swift` carries `forceMasteryPoints` beside its place but not `forceMasteryLevels`. The table belongs in `bg_misc.swift` as a public `let` of Raven's eight strings, which is a file outside this round.

cg_marks holds 0 Port-notes and the one dead `portMissing` line of R17.

The other nine files hold 0 Port-notes and 0 `portMissing` lines.

## Drafter rows found

- Whole record copy. C `memcpy(&cent->currentState, state, sizeof(entityState_t))` with an optional source. Swift `cent!.currentState = state!`.
- Record assignment through pointers. C `*ops = *ps`. Swift `ops.copy(from: ps)`.
- Pointer out-param after an allocation. C `memset(*pVeh, 0, sizeof(Vehicle_t))`. Swift `pVeh!.clear()`.
- Pointer out-param member store. C `(*pVeh)->m_pVehicleInfo = &g_vehicleInfo[i]`. Swift `pVeh!.m_pVehicleInfo = g_vehicleInfo[i]`.
- `#ifdef` inside an `if` test. C `if ( !x #ifdef _JK2MP || (0 && y) ) #else ... #endif {}`. Swift `if x == 0 || (false && y) {}`.
- A `bool` local from `!!(a & b)`. C `bool Attacking = (HasWeapon && !!(buttons & BUTTON_ATTACK))`. Swift `let Attacking: Bool = (HasWeapon && ((buttons & BUTTON_ATTACK) != 0))`.
- A `float *` argument from an array. C `CG_DrawClientScore(y, score, color, fade, b)`. Swift `CG_DrawClientScore(y, score!, &color[0], fade, b)`.
- A dereference of a `float *` local. C `fade = *fadeColor`. Swift `fade = fadeColor![0]`.
- Pre-increment in an `if` test. C `if ( ++cg.deferredPlayerLoading > 10 )`. Swift `cg.deferredPlayerLoading += 1` and then `if cg.deferredPlayerLoading > 10`.
- An `in_place` return passed on. C `CG_GetStringEdString("SP_INGAME", Q_strupr(upperKey))`. Swift `Q_strupr(&upperKey)` and then `CG_GetStringEdString("SP_INGAME", String(upperKey))`.
- A table walk from `+ 1`. C `for ( item = bg_itemlist + 1 ; item->classname ; item++ )`. Swift `itemIndex = 1`, `while bg_itemlist[itemIndex].classname != nil`, and `itemIndex += 1`.
- A function store into a callback field. C `weaponInfo->missileTrailFunc = FX_BlasterProjectileThink`. Swift `weaponInfo!.missileTrailFunc = WeaponInfoThunks.FX_BlasterProjectileThink`.
- MAKERGB. C `MAKERGB( weaponInfo->flashDlightColor, 1, 1, 1 )`. Swift three stores, `weaponInfo!.flashDlightColor[0] = 1` and the same for 1 and 2.
- An array field truth test. C `if (ent->turAngles) { ... }`. Swift the block with no test.
- A byte read of a `const char *` local. C `(float)(s[k]-'a')/(float)('z'-'a') * 255.0`. Swift `let s: CharBuf` and two typed terms.
- A pointer element of a `char *` array field. C `trap_R_RegisterModel( item->world_model[0] )`. Swift `trap_R_RegisterModel(bg_itemlist[itemIndex].world_model[0]!)`.
