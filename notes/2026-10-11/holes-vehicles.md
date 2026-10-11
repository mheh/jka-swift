# Hole round: the vehicle files

The dockets of six files under `Sources/JKAMP_GameLogic/` held 54 Port-notes.
33 are filled, 21 stand, and 0 are blocked.

| File | Port-notes | Filled | Stands | Blocked |
|---|---|---|---|---|
| FighterNPC.swift | 14 | 14 | 0 | 0 |
| g_vehicles.swift | 13 | 0 | 13 | 0 |
| g_vehicleTurret.swift | 11 | 3 | 8 | 0 |
| SpeederNPC.swift | 6 | 6 | 0 | 0 |
| WalkerNPC.swift | 3 | 3 | 0 | 0 |
| AnimalNPC.swift | 7 | 7 | 0 | 0 |

## FighterNPC.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Update | `Bool?` from a call through `g_vehicleInfo[VEHICLE_BASE].Update` | filled | A call through a stored function of a view is its `run` method, `g_vehicleInfo[VEHICLE_BASE].runUpdate(pVeh, pUcmd)`, the form `WalkerNPC.swift` already uses for `runRegisterAssets`. |
| Board | `Bool?` from a call through `g_vehicleInfo[VEHICLE_BASE].Board` | filled | Same form, `runBoard`. |
| Eject | `Bool?` from a call through `g_vehicleInfo[VEHICLE_BASE].Eject` | filled | Same form, `runEject`. |
| FighterIsLanding | `#ifdef QAGAME` inside the condition | filled | The game build takes the `QAGAME` branch, as the file already does for `G_EntitySound`. The `Inhabited` test is `runInhabited`, and Raven's inline comments stay at their operands. |
| FighterIsLaunching | `#ifdef QAGAME` inside the condition | filled | Same form. |
| ProcessMoveCommands | `Bool?` from `Inhabited`, and the rest of the `else if` chain | filled | The game build keeps the `QAGAME` arm. Truth tests of a `float` and an `int` read `!= 0`, `a = b = c` lifts the inner store first, `float = MIN_LANDING_SPEED` takes `Float(...)` at the store, and the `#ifndef _JK2MP` arm drops. |
| ProcessMoveCommands | `#ifdef QAGAME` inside the strafe condition | filled | Same `QAGAME` branch. `VectorCopy` from `m_vOrientation` reads `m_vOrientationVector`. The NULL `forward` and `up` of `AngleVectors` take scratch locals under one comment, and `hackingTime = 0.0f` is `Int32(0.0)`. |
| ProcessMoveCommands | `gravity = -500.0f`, a `float` into an `int` | filled | `parentPS!.gravity = Int32(-500.0)`, the float-into-int store form. |
| ProcessMoveCommands | `gravity = 500.0f`, a `float` into an `int` | filled | Same form. |
| ProcessMoveCommands | `gravity = 500.0f`, a `float` into an `int` | filled | Same form. |
| FighterDamageRoutine | an `Entity?` into the value parameters of `G_DamageFromKiller` | filled | The force unwrap at the call, `parent!`, and `nil` for Raven's `NULL` attacker. |
| ProcessOrientCommands | `Bool?` from `Inhabited` | filled | `runInhabited`, the `(gentity_t *)parent` cast maps over the optional, and `m_vOrientation[PITCH]` reads `m_vOrientationVector[PITCH]`. |
| G_CreateFighterNPC | `memset(*pVeh, 0, sizeof(Vehicle_t))` | filled | The guide names this exact memset as the view's `clear()`, so it is `pVeh!.clear()`. |
| G_CreateFighterNPC | `Vehicle?` member store | filled | `pVeh!.m_pVehicleInfo = g_vehicleInfo[BG_VehicleGetIndex(strType)]`. |

## g_vehicles.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G_FlyVehicleDestroySurface | local `char *surfName[4]` | stands | The guide gives no form for a local array of `char *`. Docket row 1. |
| G_FlyVehicleDestroySurface | `surfName[0] = "nose"` | stands | It needs the local of docket row 1. |
| G_FlyVehicleDestroySurface | `surfName[0] = "r_wing2"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[1] = "l_wing2"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[2] = "r_gear"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[3] = "l_gear"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[0] = "r_wing1"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[1] = "r_wing2"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[2] = "r_gear"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[0] = "l_wing1"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[1] = "l_wing2"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[2] = "l_gear"` | stands | Same reason. |
| G_FlyVehicleDestroySurface | `surfName[numSurfs]` into `NPC_SetSurfaceOnOff` | stands | Same reason. |

## g_vehicleTurret.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| VEH_TurretCheckFire | `m_vMuzzlePos[curMuzzle]` into `WP_FireVehicleWeapon` | stands | The view gives `vec3_t m_vMuzzlePos[12]` as `Slots<Slots<Float>>`, and no form reads a `vec3_t` from it. Docket row 2. |
| VEH_TurretAnglesToEnemy | `VectorSubtract` with `m_vMuzzlePos[curMuzzle]` | stands | Same reason. Docket row 2. |
| VEH_TurretAnglesToEnemy | `VectorSubtract` with `m_vMuzzlePos[curMuzzle]` | stands | Same reason. Docket row 2. |
| VEH_TurretAim | `vectoangles` of `m_vMuzzleDir[curMuzzle]` | stands | Same reason for `m_vMuzzleDir`. Docket row 2. |
| VEH_TurretAim | the optional `turretEnemy` into a value parameter | filled | A caller that holds an optional and passes it where a value is due writes the force unwrap with no comment, so the call passes `turretEnemy!`. The guide settles it, and no never-null ruling is due. |
| VEH_TurretFindEnemies | local `gentity_t *entity_list[MAX_GENTITIES]` | filled | `var entity_list = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))`, the caller form for an array of struct pointers the callee fills. |
| VEH_TurretFindEnemies | `VectorCopy` from `m_vMuzzlePos[curMuzzle]` | stands | Docket row 2. |
| VEH_TurretFindEnemies | read of `entity_list` in `G_RadiusList` | filled | `count = G_RadiusList(org2, turretStats.fAIRange, parent, true, &entity_list)`. |
| VEH_TurretFindEnemies | `trace_t tr` inside the loop body, with `continue` before the trace | stands | The guide maps a `return` inside the block to the closure's value, but gives no form for a `continue` of the enclosing loop. Docket row 3. |
| VEH_TurretThink | `VectorSubtract` with `m_vMuzzlePos[curMuzzle]` | stands | Docket row 2. |
| VEH_TurretThink | `trap_InPVS` with `m_vMuzzlePos[curMuzzle]`, and a `trace_t tr` block | stands | Docket row 2. The scratch `Trace` block has a form once the vector reads. |

## SpeederNPC.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Update | `Bool?` from a call through `g_vehicleInfo[VEHICLE_BASE].Update` | filled | `runUpdate`, the same form as FighterNPC. |
| ProcessMoveCommands | `#ifdef _JK2MP` inside the condition | filled | The native build takes the `_JK2MP` branch. Raven's `0 &&` reads `0 != 0`, the form the file already uses for `if (1)`, and the body keeps only Raven's two comments. |
| AnimateRiders | `bool Attacking = (HasWeapon && !!(buttons & BUTTON_ATTACK))` | filled | `!!x` is the truth test `(x) != 0`. |
| AnimateRiders | read of `Attacking`, the whole animation chain | filled | `WeaponPose`, an `Int32` enum, tests `!= 0`. The `#ifndef _JK2MP` enemy arm drops, `assert(0)` drops to `default: break`, `buttons & BUTTON_USE` tests `!= 0`, and `m_vOrientation[ROLL]` reads `m_vOrientationVector[ROLL]`. |
| G_CreateSpeederNPC | `memset(*pVeh, 0, sizeof(Vehicle_t))` | filled | `pVeh!.clear()`, the form the guide names. |
| G_CreateSpeederNPC | `Vehicle?` member store | filled | `pVeh!.m_pVehicleInfo = g_vehicleInfo[BG_VehicleGetIndex(strType)]`. |

## WalkerNPC.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Board | `Bool?` from a call through `g_vehicleInfo[VEHICLE_BASE].Board` | filled | `runBoard`. |
| G_CreateWalkerNPC | `memset(*pVeh, 0, sizeof(Vehicle_t))` | filled | `pVeh!.clear()`. |
| G_CreateWalkerNPC | `Vehicle?` member store | filled | `pVeh!.m_pVehicleInfo = g_vehicleInfo[BG_VehicleGetIndex(strAnimalType)]`. |

## AnimalNPC.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| DeathUpdate | `Bool?` from `Inhabited` | filled | `runInhabited` and `runEjectAll`, and the empty `else` keeps Raven's comment. |
| Update | `Bool?` from a call through `g_vehicleInfo[VEHICLE_BASE].Update` | filled | `return g_vehicleInfo[VEHICLE_BASE].runUpdate(pVeh, pUcmd)`. |
| AnimateVehicle | `pilotPS = (pilot)?(pilot->playerState):(0)` | filled | The pointer truth test is `pilot != nil`, the read is `pilot!.playerState`, and Raven's `0` is `nil`. |
| AnimateRiders | `bool Attacking = (HasWeapon && !!(buttons & BUTTON_ATTACK))` | filled | Same form as SpeederNPC. |
| AnimateRiders | read of `Attacking`, the whole animation chain | filled | Same forms as SpeederNPC. |
| G_CreateAnimalNPC | `memset(*pVeh, 0, sizeof(Vehicle_t))` | filled | `pVeh!.clear()`. |
| G_CreateAnimalNPC | `Vehicle?` member store | filled | `pVeh!.m_pVehicleInfo = g_vehicleInfo[BG_VehicleGetIndex(strAnimalType)]`. |

## GameWorld properties

None. No hole in the six files is a static local or a file-scope static.

## Docket rows

1. `char *surfName[4]` of `G_FlyVehicleDestroySurface`, 13 holes in `g_vehicles.swift`. The guide has a form for a C array of struct pointers that a callee fills, but no form for a local array of `char *` that the body fills with literals. Proposed form: such a local is `var surfName = [String?](repeating: nil, count: 4)`, a store writes the literal, and a read where Raven dereferences is the force unwrap, `NPC_SetSurfaceOnOff(veh, surfName[numSurfs]!, TURN_OFF)`.
2. `vec3_t m_vMuzzlePos[12]` and `vec3_t m_vMuzzleDir[12]` of `Vehicle_t`, 7 holes in `g_vehicleTurret.swift`. The view gives each field as `Slots<Slots<Float>>`, and no form turns one row into a `vec3_t`. Proposed form: `views.py` gives a `vec3_t[N]` field a `Slots<JKAShared.vec3_t>` with the 12-byte stride of Raven's `vec3_t`, the shape `WP_MuzzlePoint` already has, so `pVeh.m_vMuzzlePos[curMuzzle]` reads a vector and `&pVeh.m_vMuzzlePos[curMuzzle]` passes one to an `inout` parameter.
3. `trace_t tr` at the top of the loop body of `VEH_TurretFindEnemies`, 1 hole in `g_vehicleTurret.swift`. The body has `continue` statements before the trace, and the guide gives no form for a `continue` inside a scratch closure. Proposed form: when a record local opens a `for` body, the closure wraps the body before the step, and Raven's `continue` is a `return` of the closure.
