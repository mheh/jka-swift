# Phase 2, wave A, the vehicles transcriptor

The line numbers in the "Site" column are the lines of `wave-0` at a1b6196, before the edit.

## Sites

| Site | Unit | Row | What I wrote |
|---|---|---|---|
| `g_vehicles.swift:2122` | A-12 | M1 | filled, `var surfName = [String](repeating: "", count: 4) //up to 4 surfs at once` |
| `g_vehicles.swift:2135` | A-12 | M1 | filled, `surfName[0] = "nose"` |
| `g_vehicles.swift:2144` | A-12 | M1 | filled, `surfName[0] = "r_wing2"` |
| `g_vehicles.swift:2147` | A-12 | M1 | filled, `surfName[1] = "l_wing2"` |
| `g_vehicles.swift:2152` | A-12 | M1 | filled, `surfName[2] = "r_gear"` |
| `g_vehicles.swift:2155` | A-12 | M1 | filled, `surfName[3] = "l_gear"` |
| `g_vehicles.swift:2164` | A-12 | M1 | filled, `surfName[0] = "r_wing1"` |
| `g_vehicles.swift:2167` | A-12 | M1 | filled, `surfName[1] = "r_wing2"` |
| `g_vehicles.swift:2172` | A-12 | M1 | filled, `surfName[2] = "r_gear"` |
| `g_vehicles.swift:2181` | A-12 | M1 | filled, `surfName[0] = "l_wing1"` |
| `g_vehicles.swift:2184` | A-12 | M1 | filled, `surfName[1] = "l_wing2"` |
| `g_vehicles.swift:2189` | A-12 | M1 | filled, `surfName[2] = "l_gear"` |
| `g_vehicles.swift:2207` | A-12 | M1 | filled, `NPC_SetSurfaceOnOff(veh, surfName[numSurfs], TURN_OFF)` |
| `SpeederNPC.swift:253-254` | A-16 | R6 | changed, `if pVeh.m_pVehicleInfo!.strafePerc == 0 \|\| (false && pVeh.m_pParentEntity!.s.number < MAX_CLIENTS) {`, the two comments stay |
| `FighterNPC.swift:579` | A-18 | N1 | changed, `parentPS!.hackingTime = Int32(parentPS!.hackingTime - 50 * pVeh.m_fTimeModifier)` |
| `FighterNPC.swift:593` | A-18 | N1 | changed, `parentPS!.hackingTime = Int32(parentPS!.hackingTime + 50 * pVeh.m_fTimeModifier)` |
| `FighterNPC.swift:601` | A-18 | N1 | changed, `parentPS!.hackingTime = Int32(parentPS!.hackingTime - 50 * pVeh.m_fTimeModifier)` |
| `FighterNPC.swift:606` | A-18 | N1 | changed, `parentPS!.hackingTime = Int32(parentPS!.hackingTime + 50 * pVeh.m_fTimeModifier)` |

The N1 form uses `public func - (lhs: Int32, rhs: Float) -> Float` and its `+` twin at `Sources/JKAShared/Promotion.swift:8` and `:10`.
`TURN_OFF` is the file constant at `g_vehicles.swift:66`.
No site was left.

## Port-note counts

| File | Before | After |
|---|---|---|
| `FighterNPC.swift` | 0 | 0 |
| `SpeederNPC.swift` | 0 | 0 |
| `g_vehicles.swift` | 13 | 0 |

## GameWorld properties

None.

## Findings

1. The R6 ruling gives the condition on one line, and Raven's C spans two lines with an `#ifdef`. I wrote the ruled line. The line is under 150 columns.
2. jka-rust `g_vehicles.rs:2344` holds `surfName` as `[*const c_char; 4]` with null starts. The Swift `String` with an empty start is the M1 form, and no read tests the null, so the behavior is the same.
3. `FighterNPC.swift:603` and `:608` write `Int32(0.0)` for Raven's `parentPS->hackingTime = 0.0f;` at `FighterNPC.c:789` and its twin. These lines are outside A-18, and I did not change them. The coordinator can decide if a plain `0` is the better form.
