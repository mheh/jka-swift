import Foundation
import JKAMP
import JKAShared

/// Raven's `forcePowerSorted` of `bg_misc.c`. Always use this order when drawing force powers, for any reason.
/// Source: oracle/codemp/game/bg_misc.c:197
let forcePowerSorted: [Int32] = [
    FP_TELEPATHY,
    FP_HEAL,
    FP_ABSORB,
    FP_PROTECT,
    FP_TEAM_HEAL,
    FP_LEVITATION,
    FP_SPEED,
    FP_PUSH,
    FP_PULL,
    FP_SEE,
    FP_LIGHTNING,
    FP_DRAIN,
    FP_RAGE,
    FP_GRIP,
    FP_TEAM_FORCE,
    FP_SABER_OFFENSE,
    FP_SABER_DEFENSE,
    FP_SABERTHROW,
]

// Port-note: `trap_FS_FOpenFile`'s own stub has no table row for its `int *f` out-param, so it takes no
// arguments yet and this body cannot open the file to test it.
/// Source: oracle/codemp/game/bg_misc.c:319
func BG_FileExists(_ fileName: String) -> Bool {
    // TODO: Port BG_FileExists
    portMissing("BG_FileExists", source: "oracle/codemp/game/bg_misc.c:319")
}

/// Source: oracle/codemp/game/bg_misc.c:358
// TODO: Port signature
// Raven wrote: void BG_ParseField( BG_field_t *l_fields, const char *key, const char *value, byte *ent )
// No table row for `BG_field_t * l_fields`.
// Port-note: the body writes through a `byte *ent` at a field's byte offset, so it needs a design for typed field
// tables and raw byte-offset writes before it can port.
func BG_ParseField() -> Never {
    // TODO: Port BG_ParseField
    portMissing("BG_ParseField", source: "oracle/codemp/game/bg_misc.c:358")
}

/**
================
BG_LegalizedForcePowers

The magical function to end all functions.
This will take the force power string in powerOut and parse through it, then legalize
it based on the supposed rank and spit it into powerOut, returning true if it was legal
to begin with and false if not.
fpDisabled is actually only expected (needed) from the server, because the ui disables
force power selection anyway when force powers are disabled on the server.
================
*/
/// Source: oracle/codemp/game/bg_misc.c:439
// TODO: Port signature
// Raven wrote: qboolean BG_LegalizedForcePowers(char *powerOut, int maxRank, qboolean freeSaber, int teamForce, int gametype, int fpDisabled)
// No table row for `char * powerOut`.
// Port-note: `powerOut` is read and rewritten in place as a fixed-size char buffer, an in-out `char *` the
// generator has no row for. This needs a design for that shape before it can port.
func BG_LegalizedForcePowers() -> Never {
    // TODO: Port BG_LegalizedForcePowers
    portMissing("BG_LegalizedForcePowers", source: "oracle/codemp/game/bg_misc.c:439")
}

/// Source: oracle/codemp/game/bg_misc.c:1773
func vectoyaw(_ vec: JKAShared.vec3_t) -> Float {
    var yaw: Float

    if vec[YAW] == 0 && vec[PITCH] == 0 {
        yaw = 0
    } else {
        if vec[PITCH] != 0 {
            yaw = atan2(vec[YAW], vec[PITCH]) * 180 / .pi
        } else if vec[YAW] > 0 {
            yaw = 90
        } else {
            yaw = 270
        }
        if yaw < 0 {
            yaw += 360
        }
    }

    return yaw
}

/// Source: oracle/codemp/game/bg_misc.c:1794
func BG_HasYsalamiri(_ gametype: Int32, _ ps: JKAMP.PlayerState) -> Bool {
    if gametype == GT_CTY && (ps.powerups[PW_REDFLAG] != 0 || ps.powerups[PW_BLUEFLAG] != 0) {
        return true
    }

    if ps.powerups[PW_YSALAMIRI] != 0 {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/bg_misc.c:1810
func BG_CanUseFPNow(_ gametype: Int32, _ ps: JKAMP.PlayerState, _ time: Int32, _ power: JKAMP.forcePowers_t) -> Bool {
    if BG_HasYsalamiri(gametype, ps) {
        return false
    }

    if ps.forceRestricted || ps.trueNonJedi {
        return false
    }

    if ps.weapon == WP_EMPLACED_GUN {
        // Can't use any of your powers while on an emplaced weapon.
        return false
    }

    if ps.m_iVehicleNum != 0 {
        // Can't use powers while riding a vehicle. This may change.
        return false
    }

    if ps.duelInProgress {
        if power != FP_SABER_OFFENSE && power != FP_SABER_DEFENSE && power != FP_LEVITATION {
            if ps.saberLockFrame == 0 || power != FP_PUSH {
                return false
            }
        }
    }

    if ps.saberLockFrame != 0 || ps.saberLockTime > time {
        if power != FP_PUSH {
            return false
        }
    }

    if ps.fallingToDeath != 0 {
        return false
    }

    let brokenRightArm = (1 as Int32) << BROKENLIMB_RARM
    let brokenLeftArm = (1 as Int32) << BROKENLIMB_LARM
    if (ps.brokenLimbs & brokenRightArm) != 0 || (ps.brokenLimbs & brokenLeftArm) != 0 {
        // Powers we can't use with a broken arm.
        switch power {
        case FP_PUSH, FP_PULL, FP_GRIP, FP_LIGHTNING, FP_DRAIN:
            return false
        default:
            break
        }
    }

    return true
}

/**
==============
BG_FindItemForPowerup
==============
*/
// Port-note: this body walks Raven's `bg_itemlist` table, and that table has no Swift storage yet.
/// Source: oracle/codemp/game/bg_misc.c:1881
func BG_FindItemForPowerup(_ pw: JKAMP.powerup_t) -> JKAMP.Gitem? {
    // TODO: Port BG_FindItemForPowerup
    portMissing("BG_FindItemForPowerup", source: "oracle/codemp/game/bg_misc.c:1881")
}

/**
==============
BG_FindItemForHoldable
==============
*/
// Port-note: this body walks Raven's `bg_itemlist` table, and that table has no Swift storage yet.
/// Source: oracle/codemp/game/bg_misc.c:1901
func BG_FindItemForHoldable(_ pw: JKAMP.holdable_t) -> JKAMP.Gitem? {
    // TODO: Port BG_FindItemForHoldable
    portMissing("BG_FindItemForHoldable", source: "oracle/codemp/game/bg_misc.c:1901")
}

/**
===============
BG_FindItemForWeapon

===============
*/
// Port-note: this body walks Raven's `bg_itemlist` table, and that table has no Swift storage yet.
/// Source: oracle/codemp/game/bg_misc.c:1922
func BG_FindItemForWeapon(_ weapon: JKAMP.weapon_t) -> JKAMP.Gitem? {
    // TODO: Port BG_FindItemForWeapon
    portMissing("BG_FindItemForWeapon", source: "oracle/codemp/game/bg_misc.c:1922")
}

/**
===============
BG_FindItemForAmmo

===============
*/
// Port-note: this body walks Raven's `bg_itemlist` table, and that table has no Swift storage yet.
/// Source: oracle/codemp/game/bg_misc.c:1941
func BG_FindItemForAmmo(_ ammo: JKAMP.ammo_t) -> JKAMP.Gitem? {
    // TODO: Port BG_FindItemForAmmo
    portMissing("BG_FindItemForAmmo", source: "oracle/codemp/game/bg_misc.c:1941")
}

/**
===============
BG_FindItem

===============
*/
// Port-note: this body walks Raven's `bg_itemlist` table, and that table has no Swift storage yet.
/// Source: oracle/codemp/game/bg_misc.c:1960
func BG_FindItem(_ classname: String) -> JKAMP.Gitem? {
    // TODO: Port BG_FindItem
    portMissing("BG_FindItem", source: "oracle/codemp/game/bg_misc.c:1960")
}

/**
============
BG_PlayerTouchesItem

Items can be picked up without actually touching their physical bounds to make
grabbing them easier
============
*/
// Port-note: this body needs `BG_EvaluateTrajectory`'s origin, and that stub's `result` parameter is not
// `inout`, so it cannot hand the origin back yet.
/// Source: oracle/codemp/game/bg_misc.c:1979
func BG_PlayerTouchesItem(_ ps: JKAMP.PlayerState, _ item: JKAMP.EntityState, _ atTime: Int32) -> Bool {
    // TODO: Port BG_PlayerTouchesItem
    portMissing("BG_PlayerTouchesItem", source: "oracle/codemp/game/bg_misc.c:1979")
}

/// Source: oracle/codemp/game/bg_misc.c:1997
func BG_ProperForceIndex(_ power: Int32) -> Int32 {
    var i: Int32 = 0

    while i < NUM_FORCE_POWERS {
        if forcePowerSorted[i] == power {
            return i
        }

        i += 1
    }

    return -1
}

/// Source: oracle/codemp/game/bg_misc.c:2014
func BG_CycleForce(_ ps: JKAMP.PlayerState, _ direction: Int32) {
    var i = ps.fd.forcePowerSelected
    var x = i
    var presel = i
    var foundnext: Int32 = -1

    // Port-note: Raven wrote `!ps->fd.forcePowersKnown & (1 << x)`.
    // In C, negation has higher precedence than bitwise AND.
    // The port keeps that order per rule 2.
    let hasNoKnownPowers: Int32 = (ps.fd.forcePowersKnown == 0 ? 1 : 0) & (1 << x)
    if hasNoKnownPowers != 0 || x >= NUM_FORCE_POWERS || x == -1 {
        // Apparently we have no valid force powers.
        return
    }

    x = BG_ProperForceIndex(x)
    presel = x

    if direction == 1 {
        // Get the next power.
        x += 1
    } else {
        // Get the previous power.
        x -= 1
    }

    if x >= NUM_FORCE_POWERS {
        // Cycled off the end, cycle around to the first.
        x = 0
    }
    if x < 0 {
        // Cycled off the beginning, cycle around to the last.
        x = NUM_FORCE_POWERS - 1
    }

    i = forcePowerSorted[x]

    while x != presel {
        // Loop around to the current force power.
        if (ps.fd.forcePowersKnown & (1 << i)) != 0 && i != ps.fd.forcePowerSelected {
            // We have the force power.
            if i != FP_LEVITATION && i != FP_SABER_OFFENSE
                && i != FP_SABER_DEFENSE && i != FP_SABERTHROW {
                // It's selectable.
                foundnext = i
                break
            }
        }

        if direction == 1 {
            // Next.
            x += 1
        } else {
            // Previous.
            x -= 1
        }

        if x >= NUM_FORCE_POWERS {
            // Loop around.
            x = 0
        }
        if x < 0 {
            // Loop around.
            x = NUM_FORCE_POWERS - 1
        }

        i = forcePowerSorted[x]
    }

    if foundnext != -1 {
        // Found one, select it.
        ps.fd.forcePowerSelected = foundnext
    }
}

// Port-note: this body walks Raven's `bg_itemlist` table, and that table has no Swift storage yet.
/// Source: oracle/codemp/game/bg_misc.c:2092
func BG_GetItemIndexByTag(_ tag: Int32, _ type: Int32) -> Int32 {
    // TODO: Port BG_GetItemIndexByTag
    portMissing("BG_GetItemIndexByTag", source: "oracle/codemp/game/bg_misc.c:2092")
}

//yeah..
/// Source: oracle/codemp/game/bg_misc.c:2111
func BG_IsItemSelectable(_ ps: JKAMP.PlayerState, _ item: Int32) -> Bool {
    if item == HI_HEALTHDISP || item == HI_AMMODISP || item == HI_JETPACK {
        return false
    }
    return true
}

// Port-note: this body reads Raven's `bg_itemlist` table and calls `BG_GetItemIndexByTag`, and neither the
// table nor that lookup has Swift storage yet.
/// Source: oracle/codemp/game/bg_misc.c:2121
func BG_CycleInven(_ ps: JKAMP.PlayerState, _ direction: Int32) {
    // TODO: Port BG_CycleInven
    portMissing("BG_CycleInven", source: "oracle/codemp/game/bg_misc.c:2121")
}

/**
================
BG_CanItemBeGrabbed

Returns false if the item should not be picked up.
This needs to be the same for client side prediction and server use.
================
*/
// Port-note: this body reads Raven's `bg_itemlist`, `weaponData`, and `ammoData` tables, and none of them has
// Swift storage yet.
/// Source: oracle/codemp/game/bg_misc.c:2192
func BG_CanItemBeGrabbed(_ gametype: Int32, _ ent: JKAMP.EntityState, _ ps: JKAMP.PlayerState) -> Bool {
    // TODO: Port BG_CanItemBeGrabbed
    portMissing("BG_CanItemBeGrabbed", source: "oracle/codemp/game/bg_misc.c:2192")
}

/**
================
BG_EvaluateTrajectory

================
*/
// Port-note: Raven's `result` is an out-param, `vec3_t result`. The stub's `result` is a plain value, not
// `inout`, so a body cannot hand the evaluated point back to the caller. This needs the row 6 out-param
// treatment before it can port.
/// Source: oracle/codemp/game/bg_misc.c:2353
func BG_EvaluateTrajectory(_ tr: JKAShared.Trajectory, _ atTime: Int32, _ result: JKAShared.vec3_t) {
    // TODO: Port BG_EvaluateTrajectory
    portMissing("BG_EvaluateTrajectory", source: "oracle/codemp/game/bg_misc.c:2353")
}

/**
================
BG_EvaluateTrajectoryDelta

For determining velocity at a given time
================
*/
// Port-note: Raven's `result` is an out-param, `vec3_t result`. The stub's `result` is a plain value, not
// `inout`, so a body cannot hand the evaluated delta back to the caller. This needs the row 6 out-param
// treatment before it can port.
/// Source: oracle/codemp/game/bg_misc.c:2419
func BG_EvaluateTrajectoryDelta(_ tr: JKAShared.Trajectory, _ atTime: Int32, _ result: JKAShared.vec3_t) {
    // TODO: Port BG_EvaluateTrajectoryDelta
    portMissing("BG_EvaluateTrajectoryDelta", source: "oracle/codemp/game/bg_misc.c:2419")
}

/// Source: oracle/codemp/game/bg_misc.c:2635
func BG_AddPredictableEventToPlayerstate(_ newEvent: Int32, _ eventParm: Int32, _ ps: JKAMP.PlayerState) {
    let seq = Int(ps.eventSequence) & (Int(MAX_PS_EVENTS) - 1)
    ps.events[seq] = newEvent
    ps.eventParms[seq] = eventParm
    ps.eventSequence += 1
}

/**
========================
BG_TouchJumpPad
========================
*/
/// Source: oracle/codemp/game/bg_misc.c:2667
func BG_TouchJumpPad(_ ps: JKAMP.PlayerState, _ jumppad: JKAMP.EntityState) {
    // Spectators don't use jump pads.
    if ps.pm_type != PM_NORMAL && ps.pm_type != PM_JETPACK && ps.pm_type != PM_FLOAT {
        return
    }

    // If we didn't hit this same jumppad the previous frame,
    // then don't play the event sound again if we are in a fat trigger.
    if ps.jumppad_ent != jumppad.number {
        var angles = vec3_t()
        vectoangles(jumppad.origin2, &angles)
        let p = fabsf(AngleNormalize180(angles[PITCH]))
        // Port-note: `effectNum` was computed here in Raven's body and never used again, so it is dropped.
        _ = p < 45 ? 0 : 1
    }
    // Remember hitting this jumppad this frame.
    ps.jumppad_ent = jumppad.number
    ps.jumppad_frame = ps.pmove_framecount
    // Give the player the velocity from the jumppad.
    ps.velocity = jumppad.origin2
}

/**
=================
BG_EmplacedView

Shared code for emplaced angle gun constriction
=================
*/
/// Source: oracle/codemp/game/bg_misc.c:2703
// TODO: Port signature
// Raven wrote: int BG_EmplacedView(vec3_t baseAngles, vec3_t angles, float *newYaw, float constraint)
// No table row for `float * newYaw`.
// Port-note: `newYaw` is an out-param the generator has no row for. This needs the row 6 out-param treatment
// before it can port.
func BG_EmplacedView() -> Never {
    // TODO: Port BG_EmplacedView
    portMissing("BG_EmplacedView", source: "oracle/codemp/game/bg_misc.c:2703")
}

//To see if the client is trying to use one of the included skins not meant for MP.
//I don't much care for hardcoded strings, but this seems the best way to go.
/// Source: oracle/codemp/game/bg_misc.c:2744
func BG_IsValidCharacterModel(_ modelName: String, _ skinName: String) -> Bool {
    // Port-note: Raven compares with `Q_stricmp`, a case-insensitive C string compare with no Swift port yet.
    // This uses Swift's `lowercased()` compare, which is not proven to match `Q_stricmp` byte for byte.
    if skinName.lowercased() == "menu" {
        return false
    } else if modelName.lowercased() == "kyle" {
        if skinName.lowercased() == "fpls" {
            return false
        } else if skinName.lowercased() == "fpls2" {
            return false
        } else if skinName.lowercased() == "fpls3" {
            return false
        }
    }
    return true
}

/// Source: oracle/codemp/game/bg_misc.c:2768
// TODO: Port signature
// Raven wrote: qboolean BG_ValidateSkinForTeam( const char *modelName, char *skinName, int team, float *colors )
// No table row for `char * skinName`.
// Port-note: `skinName` is rewritten in place as a fixed-size char buffer, and `colors` is an out-param.
// Neither has a row yet. This needs the row 6 out-param treatment before it can port.
func BG_ValidateSkinForTeam() -> Never {
    // TODO: Port BG_ValidateSkinForTeam
    portMissing("BG_ValidateSkinForTeam", source: "oracle/codemp/game/bg_misc.c:2768")
}

/**
========================
BG_PlayerStateToEntityState

This is done after each set of usercmd_t on the server,
and after local prediction on the client
========================
*/
/// Source: oracle/codemp/game/bg_misc.c:2887
func BG_PlayerStateToEntityState(_ ps: JKAMP.PlayerState, _ s: JKAMP.EntityState, _ snap: Bool) {
    if ps.pm_type == PM_INTERMISSION || ps.pm_type == PM_SPECTATOR {
        s.eType = ET_INVISIBLE
    } else if ps.stats[STAT_HEALTH] <= GIB_HEALTH {
        s.eType = ET_INVISIBLE
    } else {
        s.eType = ET_PLAYER
    }

    s.number = ps.clientNum

    s.pos.trType = TR_INTERPOLATE
    s.pos.trBase = ps.origin
    if snap {
        var base = s.pos.trBase
        SnapVector(&base)
        s.pos.trBase = base
    }
    // Set the trDelta for flag direction.
    s.pos.trDelta = ps.velocity

    s.apos.trType = TR_INTERPOLATE
    s.apos.trBase = ps.viewangles
    if snap {
        var base = s.apos.trBase
        SnapVector(&base)
        s.apos.trBase = base
    }

    s.trickedentindex = ps.fd.forceMindtrickTargetIndex
    s.trickedentindex2 = ps.fd.forceMindtrickTargetIndex2
    s.trickedentindex3 = ps.fd.forceMindtrickTargetIndex3
    s.trickedentindex4 = ps.fd.forceMindtrickTargetIndex4

    s.forceFrame = ps.saberLockFrame

    s.emplacedOwner = ps.electrifyTime

    s.speed = ps.speed

    s.genericenemyindex = ps.genericEnemyIndex

    s.activeForcePass = ps.activeForcePass

    s.angles2[YAW] = Float(ps.movementDir)
    s.legsAnim = ps.legsAnim
    s.torsoAnim = ps.torsoAnim

    s.legsFlip = ps.legsFlip
    s.torsoFlip = ps.torsoFlip

    // ET_PLAYER looks here instead of at number, so corpses can also reference the proper config.
    s.clientNum = ps.clientNum
    s.eFlags = ps.eFlags
    s.eFlags2 = ps.eFlags2

    s.saberInFlight = ps.saberInFlight
    s.saberEntityNum = ps.saberEntityNum
    s.saberMove = ps.saberMove
    s.forcePowersActive = ps.fd.forcePowersActive

    if ps.duelInProgress {
        s.bolt1 = 1
    } else {
        s.bolt1 = 0
    }

    s.otherEntityNum2 = ps.emplacedIndex

    s.saberHolstered = ps.saberHolstered

    if ps.genericEnemyIndex != -1 {
        s.eFlags |= EF_SEEKERDRONE
    }

    if ps.stats[STAT_HEALTH] <= 0 {
        s.eFlags |= EF_DEAD
    } else {
        s.eFlags &= ~EF_DEAD
    }

    if ps.externalEvent != 0 {
        s.event = ps.externalEvent
        s.eventParm = ps.externalEventParm
    } else if ps.entityEventSequence < ps.eventSequence {
        if ps.entityEventSequence < ps.eventSequence - MAX_PS_EVENTS {
            ps.entityEventSequence = ps.eventSequence - MAX_PS_EVENTS
        }
        let seq = Int(ps.entityEventSequence) & (Int(MAX_PS_EVENTS) - 1)
        s.event = ps.events[seq] | ((ps.entityEventSequence & 3) << 8)
        s.eventParm = ps.eventParms[seq]
        ps.entityEventSequence += 1
    }

    s.weapon = ps.weapon
    s.groundEntityNum = ps.groundEntityNum

    s.powerups = 0
    for i in 0..<Int(MAX_POWERUPS) {
        if ps.powerups[i] != 0 {
            s.powerups |= 1 << i
        }
    }

    s.loopSound = ps.loopSound
    s.generic1 = ps.generic1

    // Not included in EntityStateToPlayerState.
    s.modelindex2 = ps.weaponstate
    s.constantLight = ps.weaponChargeTime

    s.origin2 = ps.lastHitLoc

    s.isJediMaster = ps.isJediMaster

    s.time2 = ps.holocronBits

    s.fireflag = ps.fd.saberAnimLevel

    s.heldByClient = ps.heldByClient
    s.ragAttach = ps.ragAttach

    s.iModelScale = ps.iModelScale

    s.brokenLimbs = ps.brokenLimbs

    s.hasLookTarget = ps.hasLookTarget
    s.lookTarget = ps.lookTarget

    s.customRGBA[0] = ps.customRGBA[0]
    s.customRGBA[1] = ps.customRGBA[1]
    s.customRGBA[2] = ps.customRGBA[2]
    s.customRGBA[3] = ps.customRGBA[3]

    s.m_iVehicleNum = ps.m_iVehicleNum
}

/**
========================
BG_PlayerStateToEntityStateExtraPolate

This is done after each set of usercmd_t on the server,
and after local prediction on the client
========================
*/
/// Source: oracle/codemp/game/bg_misc.c:3037
func BG_PlayerStateToEntityStateExtraPolate(_ ps: JKAMP.PlayerState, _ s: JKAMP.EntityState, _ time: Int32, _ snap: Bool) {
    if ps.pm_type == PM_INTERMISSION || ps.pm_type == PM_SPECTATOR {
        s.eType = ET_INVISIBLE
    } else if ps.stats[STAT_HEALTH] <= GIB_HEALTH {
        s.eType = ET_INVISIBLE
    } else {
        s.eType = ET_PLAYER
    }

    s.number = ps.clientNum

    s.pos.trType = TR_LINEAR_STOP
    s.pos.trBase = ps.origin
    if snap {
        var base = s.pos.trBase
        SnapVector(&base)
        s.pos.trBase = base
    }
    // Set the trDelta for flag direction and linear prediction.
    s.pos.trDelta = ps.velocity
    // Set the time for linear prediction.
    s.pos.trTime = time
    // Set maximum extrapolation time.
    s.pos.trDuration = 50 // 1000 / sv_fps (default = 20)

    s.apos.trType = TR_INTERPOLATE
    s.apos.trBase = ps.viewangles
    if snap {
        var base = s.apos.trBase
        SnapVector(&base)
        s.apos.trBase = base
    }

    s.trickedentindex = ps.fd.forceMindtrickTargetIndex
    s.trickedentindex2 = ps.fd.forceMindtrickTargetIndex2
    s.trickedentindex3 = ps.fd.forceMindtrickTargetIndex3
    s.trickedentindex4 = ps.fd.forceMindtrickTargetIndex4

    s.forceFrame = ps.saberLockFrame

    s.emplacedOwner = ps.electrifyTime

    s.speed = ps.speed

    s.genericenemyindex = ps.genericEnemyIndex

    s.activeForcePass = ps.activeForcePass

    s.angles2[YAW] = Float(ps.movementDir)
    s.legsAnim = ps.legsAnim
    s.torsoAnim = ps.torsoAnim

    s.legsFlip = ps.legsFlip
    s.torsoFlip = ps.torsoFlip

    // ET_PLAYER looks here instead of at number, so corpses can also reference the proper config.
    s.clientNum = ps.clientNum
    s.eFlags = ps.eFlags
    s.eFlags2 = ps.eFlags2

    s.saberInFlight = ps.saberInFlight
    s.saberEntityNum = ps.saberEntityNum
    s.saberMove = ps.saberMove
    s.forcePowersActive = ps.fd.forcePowersActive

    if ps.duelInProgress {
        s.bolt1 = 1
    } else {
        s.bolt1 = 0
    }

    s.otherEntityNum2 = ps.emplacedIndex

    s.saberHolstered = ps.saberHolstered

    if ps.genericEnemyIndex != -1 {
        s.eFlags |= EF_SEEKERDRONE
    }

    if ps.stats[STAT_HEALTH] <= 0 {
        s.eFlags |= EF_DEAD
    } else {
        s.eFlags &= ~EF_DEAD
    }

    if ps.externalEvent != 0 {
        s.event = ps.externalEvent
        s.eventParm = ps.externalEventParm
    } else if ps.entityEventSequence < ps.eventSequence {
        if ps.entityEventSequence < ps.eventSequence - MAX_PS_EVENTS {
            ps.entityEventSequence = ps.eventSequence - MAX_PS_EVENTS
        }
        let seq = Int(ps.entityEventSequence) & (Int(MAX_PS_EVENTS) - 1)
        s.event = ps.events[seq] | ((ps.entityEventSequence & 3) << 8)
        s.eventParm = ps.eventParms[seq]
        ps.entityEventSequence += 1
    }

    s.weapon = ps.weapon
    s.groundEntityNum = ps.groundEntityNum

    s.powerups = 0
    for i in 0..<Int(MAX_POWERUPS) {
        if ps.powerups[i] != 0 {
            s.powerups |= 1 << i
        }
    }

    s.loopSound = ps.loopSound
    s.generic1 = ps.generic1

    // Not included in EntityStateToPlayerState.
    s.modelindex2 = ps.weaponstate
    s.constantLight = ps.weaponChargeTime

    s.origin2 = ps.lastHitLoc

    s.isJediMaster = ps.isJediMaster

    s.time2 = ps.holocronBits

    s.fireflag = ps.fd.saberAnimLevel

    s.heldByClient = ps.heldByClient
    s.ragAttach = ps.ragAttach

    s.iModelScale = ps.iModelScale

    s.brokenLimbs = ps.brokenLimbs

    s.hasLookTarget = ps.hasLookTarget
    s.lookTarget = ps.lookTarget

    s.customRGBA[0] = ps.customRGBA[0]
    s.customRGBA[1] = ps.customRGBA[1]
    s.customRGBA[2] = ps.customRGBA[2]
    s.customRGBA[3] = ps.customRGBA[3]

    s.m_iVehicleNum = ps.m_iVehicleNum
}

// Port-note: Raven branches this body on `#ifdef QAGAME`, one path for the game module and another for cgame
// and the UI. `bg_local.swift` says `JKAMP_BG` is one Swift module shared by both, with no build flag yet to
// pick a branch, so this needs that design before it can port.
/// Source: oracle/codemp/game/bg_misc.c:3200
func BG_ModelCache(_ modelName: String, _ skinName: String) -> Int32 {
    // TODO: Port BG_ModelCache
    portMissing("BG_ModelCache", source: "oracle/codemp/game/bg_misc.c:3200")
}

/// Source: oracle/codemp/game/bg_misc.c:3328
// TODO: Port signature
// Raven wrote: void *BG_Alloc ( int size )
// No table row for the return `void *`.
// Port-note: the body bumps a pointer into Raven's `bg_pool` buffer and returns it. This needs a design for a
// `void *` return before it can port.
func BG_Alloc() -> Never {
    // TODO: Port BG_Alloc
    portMissing("BG_Alloc", source: "oracle/codemp/game/bg_misc.c:3328")
}

/// Source: oracle/codemp/game/bg_misc.c:3343
// TODO: Port signature
// Raven wrote: void *BG_AllocUnaligned ( int size )
// No table row for the return `void *`.
// Port-note: the body bumps a pointer into Raven's `bg_pool` buffer and returns it. This needs a design for a
// `void *` return before it can port.
func BG_AllocUnaligned() -> Never {
    // TODO: Port BG_AllocUnaligned
    portMissing("BG_AllocUnaligned", source: "oracle/codemp/game/bg_misc.c:3343")
}

/// Source: oracle/codemp/game/bg_misc.c:3356
// TODO: Port signature
// Raven wrote: void *BG_TempAlloc( int size )
// No table row for the return `void *`.
// Port-note: the body bumps a pointer from the tail of Raven's `bg_pool` buffer and returns it. This needs a
// design for a `void *` return before it can port.
func BG_TempAlloc() -> Never {
    // TODO: Port BG_TempAlloc
    portMissing("BG_TempAlloc", source: "oracle/codemp/game/bg_misc.c:3356")
}

/// Source: oracle/codemp/game/bg_misc.c:3371
// Port-note: Raven's bound is `MAX_POOL_SIZE`, an `#ifdef` macro with no single value. `bg_local.swift` keeps
// the QAGAME value on `bg.poolTail`'s initializer, and this uses the same literal.
func BG_TempFree(_ size: Int32) {
    let alignedSize = (size + 0x0000_0003) & 0xffff_fffc
    let maxPoolSize: Int32 = 3_000_000
    if bg.poolTail + alignedSize > maxPoolSize {
        Com_Error(ERR_DROP, "BG_TempFree: tail greater than size (\(bg.poolTail + alignedSize) > \(maxPoolSize))")
    }
    bg.poolTail += alignedSize
}

/// Source: oracle/codemp/game/bg_misc.c:3383
// TODO: Port signature
// Raven wrote: char *BG_StringAlloc ( const char *source )
// No table row for the return `char *`.
// Port-note: the body copies through `BG_Alloc`, which is itself unported for the same `void *` return reason.
func BG_StringAlloc() -> Never {
    // TODO: Port BG_StringAlloc
    portMissing("BG_StringAlloc", source: "oracle/codemp/game/bg_misc.c:3383")
}

/// Source: oracle/codemp/game/bg_misc.c:3392
// Port-note: Raven's bound is `MAX_POOL_SIZE`, an `#ifdef` macro with no single value. This uses the same
// QAGAME literal `bg.poolTail`'s initializer in `bg_local.swift` keeps.
func BG_OutOfMemory() -> Bool {
    let maxPoolSize: Int32 = 3_000_000
    return bg.poolSize >= maxPoolSize
}
