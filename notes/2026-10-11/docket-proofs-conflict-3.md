# Docket proofs, conflict 3: rows D8, M2, S2, and the finding U1

This record decides between the D8 form, a second accessor `<name>Vectors: Slots<vec3_t>`, and the M2 and S2 form, a retype of the `vec3_t[N]` field itself as `Slots<vec3_t>` under Raven's name. No file under `Sources/`, `docs/`, or `tools/` changed, and no build ran.

## 1. The check order in `spelling.py`

The M2 claim holds. `views.py` `accessor()` sends a `vec3_t[N]` field to `element(element_type(t))`, and `element_type` keeps the typedef, so `field()` gets the `vec3_t` typedef itself. In `field()` (`tools/oracle-closure/spelling.py:210`), the `CONSTANTARRAY` arm at line 226 tests the canonical type first, and the canonical type of `vec3_t` is `float[3]`. In that arm, `element_type(vec3_t)` is a plain `float`, so the test `is_vec3(inner)` at line 230 is false, and the arm returns the kind `rows` at line 233. The test `is_vec3(t)` at line 234 never runs for a `vec3_t` element. `views.py:189` then writes `Slots(rows:)` over `Slots<Float>(scalars:)`. `Slots(vectors:)` at `views.py:183` is never chosen.

After the swap, `is_vec3(t)` comes first and returns the kind `vectors`, so the generator writes, for example:

`public var m_vMuzzlePos: Slots<JKAShared.vec3_t> { Slots(vectors: UnsafeMutableRawPointer(self.raw.pointer(to: \.m_vMuzzlePos)!), count: 12) }`

The swap touches only a field whose element is the `vec3_t` typedef. `views.py` handles a plain `vec3_t` field at line 273 before it calls `element()`, and `field()` has no other caller.

## 2. The `vec3_t[N]` fields and their compiled sites

Six views show `Slots<Slots<Float>>`. `MdxaBone.matrix` is `float[3][4]`, not `vec3_t[N]`, so it stays as it is. The five `vec3_t[N]` fields:

| Field | View | Compiled sites in `JKAMP_GameLogic` and `JKAMP_BG` |
|---|---|---|
| `enemyLaggedPos` | `Sources/JKAMP_Game/Generated/Views/GNPC.swift:629` | 2: `NPC_AI_Sniper.swift:555` and `:557` |
| `m_vMuzzlePos` | `Sources/JKAMP/Generated/Views/Vehicle.swift:187` | 0 |
| `m_vMuzzleDir` | `Sources/JKAMP/Generated/Views/Vehicle.swift:190` | 0 |
| `oldPos` | `Sources/JKAMP/Generated/Views/SaberTrail.swift:109` | 0 |
| `oldNormal` | `Sources/JKAMP/Generated/Views/SaberTrail.swift:112` | 0 |

`Sources/JKAShared/Views/` and `Sources/JKAShared/Generated/Views/` hold none. Every other use is a "Raven wrote" comment at a hole.

Under the retype, no compiled line changes its text. Line 555, `NPCInfo!.enemyLaggedPos[index][2] -= flrand(2, 16)`, gets a `vec3_t`, changes its `z` lane, and stores 12 bytes back through the nonmutating setter. Line 557, `NPCInfo!.enemyLaggedPos[index] = NPCInfo!.enemyLaggedPos[index - 1]`, stores one `vec3_t` and no longer traps. Under the second accessor, line 557 must change to `enemyLaggedPosVectors` on both sides, or it still traps.

## 3. The hole sites

| Row | File and line ("Raven wrote" line) |
|---|---|
| D8 | `Sources/JKAMP_GameLogic/g_weapon.swift:3510`, `:3513`, `:4155`, `:4158` |
| M2 | `Sources/JKAMP_GameLogic/g_vehicleTurret.swift:36`, `:66`, `:79`, `:98`, `:190`, `:296`, `:303` |
| S2 | `Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift:527`, `:553` |
| U1 | `Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift:557`, a compiled line, not a hole |

That is 13 holes and one trap. `g_weapon.swift:3510` and `:3513` also wait on the local `boltMatrix`.

## 4. What each `Slots` shape allows

`Sources/JKAShared/Views/Slots.swift:134`, `Slots(vectors:count:)`, stride 12, element `vec3_t`: element read, element write, whole-row read, and whole-row write all work. A lane write such as `[i][2] -= x` works through a get and a nonmutating set of the whole vector. An `inout` argument `&s[i]` works.

`Slots.swift:146`, `Slots(rows:)`, element `Slots<Float>`: a lane read and a lane write work, because the inner `Slots<Float>` has its own nonmutating setter. A whole-row read gives a `Slots<Float>`, not a `vec3_t`, so `start = row` does not compile. A whole-row write compiles and reaches the `fatalError` at `Slots.swift:157`. U1 holds.

## 5. jka-rust

`jka-rust/crates/mp/bg/src/vehicles/vehicle_s.rs:150` types the field `pub m_vMuzzlePos: [vec3_t; MAX_VEHICLE_MUZZLES]`, and `jka-rust/crates/mp/game/src/npc/g_npc_t.rs:206` types `pub enemyLaggedPos: [vec3_t; ENEMY_POS_LAG_STEPS]`. Each is one field under Raven's name, an array of vectors. `g_vehicleTurret.rs:308` reads `(*pVeh).m_vMuzzlePos[curMuzzle as usize]` as a whole vector. jka-rust has no second accessor.

## 6. Verdict

Retype, the M2 and S2 form. The swap in `field()` fixes the cause in one place, keeps Raven's name, and matches jka-rust. It changes 0 compiled lines, and it closes the U1 trap at line 557 with no edit. The second accessor leaves a trapping `Slots<Slots<Float>>` beside the correct shape, and it needs an edit at line 557. The D8 ledger row needs an amendment to the M2 form.

- D8, `g_weapon.swift:4155`: `start = pVeh!.m_vMuzzlePos[i]`
- M2, `g_vehicleTurret.swift:190`: `org2 = pVeh.m_vMuzzlePos[curMuzzle]`
- S2, `NPC_AI_Sniper.swift:553`: `CalcEntitySpot(NPC!.enemy!, SPOT_HEAD_LEAN, &NPCInfo!.enemyLaggedPos[index])`
- U1, `NPC_AI_Sniper.swift:557`: `NPCInfo!.enemyLaggedPos[index] = NPCInfo!.enemyLaggedPos[index - 1]`, with no change
