# Hole round 2: NPC_spawn and NPC_utils

The transcriptor "spawn" of phase 2, wave B, filled the holes of `Sources/JKAMP_GameLogic/NPC_spawn.swift` and `Sources/JKAMP_GameLogic/NPC_utils.swift` at 4308ee3.
No build ran and no test ran.

## Port-note counts

| File | Before | After |
|---|---|---|
| `NPC_spawn.swift` | 22 | 0 |
| `NPC_utils.swift` | 7 | 0 |

## NPC_spawn.swift

| Line before | Function | Row | Written |
|---|---|---|---|
| 36 | NPC_PainFunc | J1 | ``var `func`: EntityPain? = nil`` |
| 41 | NPC_PainFunc | J1, guide line 503 | `` `func` = Pain.NPC_Jedi_Pain `` |
| 57 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_ST_Pain `` |
| 62 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Seeker_Pain `` |
| 67 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Remote_Pain `` |
| 72 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_MineMonster_Pain `` |
| 77 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Howler_Pain `` |
| 83 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Droid_Pain `` |
| 88 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Probe_Pain `` |
| 93 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Sentry_Pain `` |
| 98 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Mark1_Pain `` |
| 103 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Mark2_Pain `` |
| 108 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_ATST_Pain `` |
| 113 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_GM_Pain `` |
| 118 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Rancor_Pain `` |
| 123 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Wampa_Pain `` |
| 129 | NPC_PainFunc | J1 | `` `func` = Pain.NPC_Pain `` |
| 135 | NPC_PainFunc | J1 | ``return `func` `` |
| 142 | NPC_TouchFunc | J1 | ``var `func`: EntityTouch? = nil`` |
| 146 | NPC_TouchFunc | J1 | `` `func` = Touch.NPC_Touch `` |
| 150 | NPC_TouchFunc | J1 | ``return `func` `` |
| 1286 | NPC_Spawn_Do | J3 | `newent!.m_pVehicle!.pointOrientation(at: newent!.client!.ps)`, the method of `Sources/JKAMP/Vehicle+Orientation.swift` |

All 16 pain thunks and `Touch.NPC_Touch` exist in `Sources/JKAMP_GameLogic/Generated/Callbacks.swift`.

## NPC_utils.swift

| Line before | Function | Row | Written |
|---|---|---|---|
| 690 | NPC_SetBoneAngles | J5, conflict 4 | `var thebone: Int32? = 0` |
| 693 | NPC_SetBoneAngles | J5, conflict 4 | `var firstFree: Int32? = nil` |
| 702 | NPC_SetBoneAngles | J5, conflict 4 | `var boneVector: Int32? = 0` |
| 705 | NPC_SetBoneAngles | J5, conflict 4 | `var freeBoneVec: Int32? = nil` |
| 709 | NPC_SetBoneAngles | J5, conflict 4 | `while thebone != nil`, the tests read `ent.s.boneIndexSlots[thebone!]`, and the `switch i` arms store slots 1 to 3 into both locals, `default` stores `nil` |
| 713 | NPC_SetBoneAngles | J5, conflict 4 | `if thebone == nil`, with `ent.s.boneIndexSlots[thebone!] = boneIndex` in the arm |
| 721 | NPC_SetBoneAngles | J5, conflict 4 | `ent.s.boneAnglesSlots[boneVector!] = angles` |

Raven's comments inside the two blocks are copied as written, one per line.

## GameWorld properties

None.

## Findings

None. The fills follow Raven's C line for line. jka-rust `NPC_utils.rs:732` walks the slots with a `for` loop and a `match`, a different control flow, which the conflict 4 proof already records.
