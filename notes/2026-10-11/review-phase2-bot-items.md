# Review of phase 2, wave A, the bot-items transcriptor

This review reads the diff of `ai_wpnav.swift`, `g_nav.swift`, `g_items.swift`, `g_saga.swift`, and `g_weapon.swift` against HEAD a1b6196, once, at the start of the review. It compares each hunk to Raven's C in `oracle/codemp/game/`, to the jka-rust port in the submodule `jka-rust/`, and to the ruled rows of `frame-path-walk.md`. The line numbers are the lines of the working tree. No build and no test ran.

## Hunks

| File:line | Unit | Row | Raven | Verdict |
|---|---|---|---|---|
| `ai_wpnav.swift:498` `RemoveWP` | A-13 | O1 | `ai_wpnav.c:473` | match |
| `ai_wpnav.swift:556` `RemoveWP_InTrail` | A-13 | O1 | `ai_wpnav.c:536` | match |
| `ai_wpnav.swift:568` `RemoveWP_InTrail` | A-13 | O1 | `ai_wpnav.c:548` | match |
| `ai_wpnav.swift:2500` `G_RMGPathing`, the guard | A-28 | R10 | `ai_wpnav.c:3070-3074` | match |
| `ai_wpnav.swift:2512-2518` `G_RMGPathing`, four reads | A-28 | R10 | `ai_wpnav.c:3086-3092` | match |
| `ai_wpnav.swift:2523` `G_RMGPathing` | A-28 | R10 | `ai_wpnav.c:3099` | match |
| `ai_wpnav.swift:2536` `G_RMGPathing` | A-28 | R10 | `ai_wpnav.c:3114` | match |
| `ai_wpnav.swift:2547` `G_RMGPathing` | A-28 | R10 | `ai_wpnav.c:3127` | match |
| `ai_wpnav.swift:2582`, `:2586` `G_RMGPathing` | A-28 | R10 | `ai_wpnav.c:3170`, `:3178` | match |
| `g_items.swift:2132-2136` `RespawnItem` | A-07 | F4 | `g_items.c:2300-2301` | match |
| `g_items.swift:2386` `Touch_Item` | A-19 | N1 | `g_items.c:2601` | behavior differs |
| `g_nav.swift:1200-1214` `waypoint_getRadius` | A-14 | P2 | `g_nav.c:1253-1265` | match |
| `g_saga.swift:1641-1642` `SP_misc_siege_item` | A-02 | L3 | `g_saga.c:1762-1763` | match |
| `g_weapon.swift:1429` `WP_DEMP2_AltFire` | A-23 | N1 | `g_weapon.c:1368` | match |
| `g_weapon.swift:1868` `WP_FireRocket` | A-23 | N1 | `g_weapon.c:1837` | match |

The diff has 15 hunks. 14 hunks match, and 1 hunk has a behavior difference that the hunk did not cause.

## Checks per unit

A-13, O1. `wpobject_t` starts with `vec3_t origin` (`q_shared.h:1009`). `sizeof(gWPArray[i])` is the size of a pointer, 8 bytes on LP64, so Raven zeroes `origin[0]` and `origin[1]` and nothing else. The Swift zeroes the same two floats by name, then stores `inuse = 0` as before. The comment is the ruled text, word for word. jka-rust writes `write_bytes(p, 0, size_of::<*mut wpobject_t>())`, the same 8 bytes.

A-14, P2. `MAX_RADIUS_CHECK` is 1024 (`g_nav.h:20`) and imports as `Int32`, so `UInt32(bitPattern: 1025)` stores `0x00000401`, the value Raven's `unsigned int minDist = MAX_RADIUS_CHECK + 1` stores. The trailing `// (unsigned int) -1;` is Raven's comment. `(360.0 / YAW_ITERATIONS) * i` resolves to the `Promotion.swift` operators `/ (Float, Int32)` and `* (Float, Int32)`, so the yaw is `22.5f * (float)i` as in C. The compare and the return are Raven's lines. jka-rust writes `(MAX_RADIUS_CHECK + 1) as c_uint` and the same loop.

A-07, F4. Raven's `for (count = 0, ent = master; ent; ent = ent->teamchain, count++)` and the Swift `while entWalk != nil { entWalk = entWalk!.teamchain; count += 1 }` give the same count, with the step before the increment as in C. Raven's `ent` is NULL after his loop, and the Swift `ent` keeps the parameter. No statement reads `ent` before `ent = master!` of the second loop, so the ruled condition holds. jka-rust writes `while let Some(eid) = e { e = teamchain; count += 1 }`.

A-28, R10. The guard is Raven's test negated in his order, and the `else` holds his `G_Printf` and his return. The work before the test is `G_Find` in both, and the `Trace.scratch` record of the existing closure is not game state. The nine `terrain.` reads match Raven's nine `terrain->` reads one for one. jka-rust tests `terrain_id.is_none() || inuse == 0 || eType != ET_TERRAIN` and returns.

A-02, L3. Raven drops the `qboolean` result, and the Swift does too. The stub takes `inout vec3_t`, so `&ent.r.mins` and `&ent.r.maxs` are the ruled form. jka-rust passes the same default strings.

A-23, N1. `damage * fact` is `* (Int32, Float)`, the float multiply of C, and `Int32(...)` truncates at the store. `vel * 0.5` takes the literal as a `Float`, the `0.5f` of C. The forms are the ruled form with no `Float(x)`. jka-rust writes `(damage as f32 * fact) as c_int`, and it keeps `vel` as an `f32`, so it does not truncate at the store. `ROCKET_VELOCITY` is 900, so the value is 450 in all three.

Each closed hole removed its Port-note, its `Raven wrote` line, and its `portMissing` call. The Port-note counts and the `portMissing` counts both go from 12 to 9, 13 to 9, 10 to 9, 4 to 2, and 7 to 7, the counts of the transcriptor record. No other line in the five files changed. The new code has no cast that Raven did not write, and each index is a C integer. The one new comment is one sentence on one line, in STE form, with no em dash.

## Findings

1. A-19, `g_items.swift:2386`, behavior differs. Raven wrote `respawn += crandom() * ent->random;`. The Swift reads `respawn = Int32(respawn + crandom() * ent.random)`. In C, `crandom()` is the macro `(2.0 * (random() - 0.5))` (`q_shared.h:1592`), a `double` expression, so C multiplies and adds in `double` and truncates the `double` sum once into `respawn`. The Swift `crandom()` in `bg_lib.swift:193` returns a `Float`, so the Swift rounds `crandom()` to float, multiplies and adds in float, and truncates the float sum. jka-rust writes `respawn = (respawn as f64 + crandom() * random) as c_int` with a comment that names the `double` math. The hunk applies the N1 form exactly, and the old line had the same float math, so the hunk did not cause the difference. The N1 proof lists `g_items.c:2601` beside the float sites and does not name the `double` of `crandom()`. Under the double-math rule of the guide, the form would be `respawn = Int32(Double(respawn) + crandomDouble * Double(ent.random))`, and that needs a `crandom` that returns `Double`. The coordinator decides whether this is a new row for the `crandom` return type and for each caller that uses it in an `int` store.

## Notes for the coordinator

These are not hunk non-matches.

1. The R10 ruling text says "the eight reads". Raven has nine `terrain->` reads after the early-out, and the Swift has nine. The plan says 11. The code is correct, and only the ruling text and the plan count are wrong.
2. The N1 proof names `g_weapon.c:1765` among the sites. The A-23 site at `g_weapon.swift:1868` is `g_weapon.c:1837` in `WP_FireRocket`, as the transcriptor record says in its finding 4.
3. The two A-02 calls drop the result of `G_SpawnVector`, which is not `@discardableResult`, so the build gives an unused-result warning at each call. The `G_SpawnInt` calls in the same file give the same warning.
