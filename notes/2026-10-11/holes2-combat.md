# Hole round of phase 2, wave B, transcriptor combat

This record lists every Port-note of `w_saber.swift`, `g_active.swift`, `g_weapon.swift`, and `g_combat.swift` under `Sources/JKAMP_GameLogic/` at 4308ee3. The line is the line of the Port-note before the edit. "Guide" means `docs/transcription.md`. No build and no test ran.

## The holes

| File:line before | Function | Row or guide line | Verdict and what the line reads now |
|---|---|---|---|
| `w_saber.swift:864` | `G_G2NPCAngles` | E2, guide line 540 | Filled. `if VectorCompare(oldLookAngles, lookAngles) == 0 {` with Raven's two FIXME lines and the lerp store, `* 0.4` beside a `Float`. |
| `w_saber.swift:2004` | `G_G2TraceCollide` | none | Blocked. The local `G2Trace_t G2Trace` waits on a form for a local C array of `CollisionRecord_t`. `lookup.py G2Trace_t` has no type, and the two collision traps take one `CollisionRecord`. |
| `w_saber.swift:2025` | `G_G2TraceCollide` | none | Blocked. The `memset` of `G2Trace` waits on the same type. |
| `w_saber.swift:2030` | `G_G2TraceCollide` | none | Blocked. The store `G2Trace[tN].mEntityNum = -1` waits on the same type. |
| `w_saber.swift:2052` | `G_G2TraceCollide` | none | Blocked. `trap_G2API_CollisionDetectCache` waits on the same type. |
| `w_saber.swift:2056` | `G_G2TraceCollide` | none | Blocked. `trap_G2API_CollisionDetect` waits on the same type. |
| `w_saber.swift:2061` | `G_G2TraceCollide` | none | Blocked. The read of `G2Trace[0]` waits on the same type. |
| `w_saber.swift:3900` | `CheckSaberDamage`, `goto blockStuff` | guide "`goto`" section | Stands. The guide orders a Port-note that names the label of a restructured `goto`. It is not a hole. |
| `g_active.swift:530` | `G_TouchTriggers` | A3 | Filled. `hit!.s.eType != ET_TELEPORT_TRIGGER && ... hit!.touch != Touch.Touch_DoorTrigger` with Raven's two comment lines, then `i += 1` and `continue`. The generated `!=` for `EntityTouch` is at `Sources/JKAMP_Game/Generated/Views/Callbacks.swift:56`. |
| `g_active.swift:701` | `SpectatorThink` | none | No form. Shape: the store of a Swift trap function into a `@convention(c)` field of `pmove_t`, `pm.trace = trap_Trace`. No thunk for `trap_Trace` as a `PmoveTrace` exists, and the guide orders no hand closure in a callback field. |
| `g_active.swift:704` | `SpectatorThink` | none | No form. The same shape, `pm.pointcontents = trap_PointContents` as a `PmovePointcontents`. |
| `g_active.swift:714` | `SpectatorThink` | A4, guide line 323 | Filled. `pm.baseEnt = BgEntity(g_entities[0])`. |
| `g_active.swift:717` | `SpectatorThink` | A5, guide line 552 | Filled. `pm.entSize = Int32(Entity.byteCount)`. |
| `g_active.swift:2562` | `ClientThink_real` | none | No form. The same shape as `g_active.swift:701`. |
| `g_active.swift:2565` | `ClientThink_real` | none | No form. The same shape as `g_active.swift:704`. |
| `g_active.swift:2571` | `ClientThink_real` | A6, guide line 539 | Filled. `pm.pmove_fixed = pmove_fixed.integer \| (client!.pers.pmoveFixed ? 1 : 0)`. |
| `g_active.swift:2625` | `ClientThink_real` | A4, guide line 323 | Filled. `pm.baseEnt = BgEntity(g_entities[0])`. |
| `g_active.swift:2628` | `ClientThink_real` | A5, guide line 552 | Filled. `pm.entSize = Int32(Entity.byteCount)`. |
| `g_weapon.swift:1533` | `prox_mine_think` | D7, guide line 555 | Filled. `count = G_RadiusList(ent.r.currentOrigin, Float(FLECHETTE_MINE_RADIUS_CHECK), ent, true, ent_list)` through the `Slots<Entity?>` overload at `g_utils.swift:375`. |
| `g_weapon.swift:3487` | `WP_CalcVehMuzzle` | none | Blocked. The `mdxaBone_t boltMatrix` scratch waits on the `sig` row of `trap_G2API_GetBoltMatrix_NoRecNoRot`, as the brief orders. |
| `g_weapon.swift:3506` | `WP_CalcVehMuzzle` | none | Blocked. The trap call waits on the same `sig` row. |
| `g_weapon.swift:3509` | `WP_CalcVehMuzzle` | D8 for the target | Blocked. The D8 target `&pVeh!.m_vMuzzlePos[muzzleNum]` has its form, but the read of `boltMatrix` waits on the scratch. |
| `g_weapon.swift:3512` | `WP_CalcVehMuzzle` | D8 for the target | Blocked. The same, for `m_vMuzzleDir`. |
| `g_weapon.swift:4154` | `FireVehicleWeapon` | D8, M2 | Filled. `start = pVeh!.m_vMuzzlePos[i]`. |
| `g_weapon.swift:4157` | `FireVehicleWeapon` | D8, M2 | Filled. `dir = pVeh!.m_vMuzzleDir[i]`. |
| `g_combat.swift:2793` | `G_Dismember` | C2, guide line 335 | Filled. `if ent.ghoul2 != nil && trap_G2API_GetSurfaceRenderStatus(ent.ghoul2, 0, String(limbName)) != 0 {` with Raven's comment and `return`. |
| `g_combat.swift:2895` | `G_Dismember` | C2, guide line 335 | Filled. `if ent.s.eType == ET_NPC && ent.ghoul2 != nil {` with Raven's comment and the two `trap_G2API_SetSurfaceOnOff` calls over `String(limbName)` and `String(stubCapName)`. |

## Counts

| File | Port-notes before | Filled | Blocked | No form | Stands | Port-notes after |
|---|---|---|---|---|---|---|
| `w_saber.swift` | 8 | 1 | 6 | 0 | 1 | 7 |
| `g_active.swift` | 10 | 6 | 0 | 4 | 0 | 4 |
| `g_weapon.swift` | 7 | 3 | 4 | 0 | 0 | 4 |
| `g_combat.swift` | 2 | 2 | 0 | 0 | 0 | 0 |
| Total | 27 | 12 | 10 | 4 | 1 | 15 |

## GameWorld properties

None. No hole needs a new property.

## Findings

1. The brief names three `boltMatrix` holes in `g_weapon.swift`, and the file has four, because the `mdxaBone_t boltMatrix` declaration carries its own Port-note.
2. The `sig` blocker of `WP_CalcVehMuzzle` looks stale. `trap_G2API_GetBoltMatrix_NoRecNoRot` has a compiled Swift signature at `Sources/JKAMP_Game/Generated/g_syscalls.swift:2050`, and `g_active.swift:840` fills the same shape with `MdxaBone.scratch { boltMatrix in ... }` and `&vehEnt.modelScale`. With D8, the four holes can take that form when the coordinator orders it.
3. The four `pm.trace` and `pm.pointcontents` holes in `g_active.swift` have no ruling, although the plan counts nine `pm` holes under A4 and A5. A4 and A5 cover four holes, and A6 covers the fifth. The shape needs a docket row: a thunk of `trap_Trace` as a `PmoveTrace` and of `trap_PointContents` as a `PmovePointcontents`, which jka-rust and the bg tests may already show.
4. The reason text "A read of `pm`, a local the draft left as a hole." on the four `pm` holes that stand is stale, because `pm` is a declared local now. The text stays until the holes fill.
5. The `goto blockStuff` Port-note at `w_saber.swift:3900` is a guide-ordered note, not a hole, so a count by the text Port-note holds one note that no round fills, and a count by the `portMissing` marker excludes it.
