# Phase 2, wave A, the bot-items transcriptor

This record covers units A-02, A-07, A-13, A-14, A-19, A-23, and A-28 of `phase-2-plan.md`. The line numbers are the lines of `wave-0` at a1b6196, before the edit. No build and no test ran.

## Sites

| Site, line before | Unit | Row | What the transcriptor wrote |
|---|---|---|---|
| `g_saga.swift:1641`, `SP_misc_siege_item` | A-02 | L3 | filled, `G_SpawnVector("mins", "-16 -16 -24", &ent.r.mins)` |
| `g_saga.swift:1644`, `SP_misc_siege_item` | A-02 | L3 | filled, `G_SpawnVector("maxs", "16 16 32", &ent.r.maxs)` |
| `g_items.swift:2132-2137`, `RespawnItem` | A-07 | F4 | filled, `var entWalk: Entity? = master` and `while entWalk != nil { entWalk = entWalk!.teamchain; count += 1 }`, the `ent = master!` before the loop dropped |
| `ai_wpnav.swift:498`, `RemoveWP` | A-13 | O1 | filled, the O1 comment, then `gWPArray[gWPNum]!.origin[0] = 0` and `[1] = 0` |
| `ai_wpnav.swift:556`, `RemoveWP_InTrail` | A-13 | O1 | filled, the O1 comment, then `gWPArray[i]!.origin[0] = 0` and `[1] = 0` |
| `ai_wpnav.swift:568`, `RemoveWP_InTrail` | A-13 | O1 | filled, the O1 comment, then `gWPArray[i]!.origin[0] = 0` and `[1] = 0` |
| `g_nav.swift:1200`, `waypoint_getRadius` | A-14 | P2 | filled, `var minDist: UInt32 = UInt32(bitPattern: MAX_RADIUS_CHECK + 1) // (unsigned int) -1;` |
| `g_nav.swift:1208`, `waypoint_getRadius` | A-14 | P2 | filled, `dist = waypoint_testDirection(ent.r.currentOrigin, ((360.0 / YAW_ITERATIONS) * i), minDist)` |
| `g_nav.swift:1212`, `waypoint_getRadius` | A-14 | P2 | filled, `if dist < minDist { minDist = dist }` |
| `g_nav.swift:1218`, `waypoint_getRadius` | A-14 | P2 | filled, `return minDist` |
| `g_items.swift:2388`, `RespawnItem` | A-19 | N1 | hand, `respawn = Int32(respawn + crandom() * ent.random)` |
| `g_weapon.swift:1429`, `damage` | A-23 | N1 | hand, `damage = Int32(damage * fact)` |
| `g_weapon.swift:1868`, `WP_FireRocket` | A-23 | N1 | hand, `vel = Int32(vel * 0.5)` |
| `ai_wpnav.swift:2500-2503`, `G_RMGPathing` | A-28 | R10 | hand, `guard let terrain, terrain.inuse, terrain.s.eType == ET_TERRAIN else { G_Printf(...); return true }` |
| `ai_wpnav.swift:2512-2586`, `G_RMGPathing` | A-28 | R10 | hand, the 9 `terrain!.` reads became `terrain.` |

No site was left.

## Port-note counts

| File | Before | After |
|---|---|---|
| `ai_wpnav.swift` | 12 | 9 |
| `g_nav.swift` | 13 | 9 |
| `g_items.swift` | 10 | 9 |
| `g_saga.swift` | 4 | 2 |
| `g_weapon.swift` | 7 | 7 |

The units fill 10 Port-notes.

## Findings

1. A-28 has 9 `terrain!` reads after the early-out. The plan says 11, and the R10 verdict says eight. The 9 reads are `absmin[0]` twice, `absmin[1]`, `absmax[0]`, `absmax[1]`, `absmax[2]`, and `absmin[2]` three times.
2. The `guard let terrain` shadows the local `let terrain` in the same closure scope. A scratch file outside the repo type-checks this shape with `swiftc -typecheck`, so the ruled form compiles.
3. `G_SpawnVector` and the other `G_Spawn*` stubs in `g_spawn.swift` are not `@discardableResult`. Raven drops the result at the two A-02 sites, so the compiler gives an "unused result" warning there, the same warning as the existing `G_SpawnInt` calls in `g_saga.swift`.
4. A-23 at line 1868 is `WP_FireRocket`, from Raven's `vel *= 0.5f` at `g_weapon.c:1837`. The N1 verdict names `g_weapon.c:1765`, which is `rocketThink`. In the port, that site is `vel *= 0.5` at `g_weapon.swift:1804` over a `Float` local, and it needs no change.
5. No unit needs a new `GameWorld` property.
