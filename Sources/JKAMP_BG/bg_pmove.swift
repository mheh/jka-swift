import Foundation
import JKAMP
import JKAShared

// movement parameters/// Source: oracle/codemp/game/bg_pmove.c:30
/// Raven's callers always set `pm`, so a body reads it with no bind. A NULL here traps with the name.
var pm: JKAMP.Pmove {
    get {
        guard let pm = bg.variables.pm else { preconditionFailure("pm is NULL") }
        return pm
    }
    set { bg.variables.pm = newValue }
}


/// Source: oracle/codemp/game/bg_pmove.c:33
var pm_entSelf: JKAMP.BgEntity? {
    get { bg.variables.pm_entSelf }
    set { bg.variables.pm_entSelf = newValue }
}

/// Source: oracle/codemp/game/bg_pmove.c:34
var pm_entVeh: JKAMP.BgEntity? {
    get { bg.variables.pm_entVeh }
    set { bg.variables.pm_entVeh = newValue }
}

/// Source: oracle/codemp/game/bg_pmove.c:36
var gPMDoSlowFall: Bool {
    get { bg.variables.gPMDoSlowFall }
    set { bg.variables.gPMDoSlowFall = newValue }
}

/// Source: oracle/codemp/game/bg_pmove.c:38
var pm_cancelOutZoom: Bool {
    get { bg.variables.pm_cancelOutZoom }
    set { bg.variables.pm_cancelOutZoom = newValue }
}

/// Source: oracle/codemp/game/bg_pmove.c:41
let pm_stopspeed: Float = 100.0
/// Source: oracle/codemp/game/bg_pmove.c:42
let pm_duckScale: Float = 0.50
/// Source: oracle/codemp/game/bg_pmove.c:43
let pm_swimScale: Float = 0.50
/// Source: oracle/codemp/game/bg_pmove.c:44
let pm_wadeScale: Float = 0.70

/// Source: oracle/codemp/game/bg_pmove.c:46
let pm_vehicleaccelerate: Float = 36.0
/// Source: oracle/codemp/game/bg_pmove.c:47
let pm_accelerate: Float = 10.0
/// Source: oracle/codemp/game/bg_pmove.c:48
let pm_airaccelerate: Float = 1.0
/// Source: oracle/codemp/game/bg_pmove.c:49
let pm_wateraccelerate: Float = 4.0
/// Source: oracle/codemp/game/bg_pmove.c:50
let pm_flyaccelerate: Float = 8.0

/// Source: oracle/codemp/game/bg_pmove.c:52
let pm_friction: Float = 6.0
/// Source: oracle/codemp/game/bg_pmove.c:53
let pm_waterfriction: Float = 1.0
/// Source: oracle/codemp/game/bg_pmove.c:54
let pm_flightfriction: Float = 3.0
/// Source: oracle/codemp/game/bg_pmove.c:55
let pm_spectatorfriction: Float = 5.0

/// Source: oracle/codemp/game/bg_pmove.c:57
var c_pmove: Int32 {
    get { bg.variables.c_pmove }
    set { bg.variables.c_pmove = newValue }
}

/// Source: oracle/codemp/game/bg_pmove.c:59
let forceSpeedLevels: [Float] = [
    1, //rank 0?
    1.25,
    1.5,
    1.75,
]

/// Source: oracle/codemp/game/bg_pmove.c:67
/// Raven's data table, a hand property of `BgState`.
var forcePowerNeeded: [[Int32]] {
    get { bg.forcePowerNeeded }
    set { bg.forcePowerNeeded = newValue }
}

/// Source: oracle/codemp/game/bg_pmove.c:155
let forceJumpHeight: [Float] = [
    32,//normal jump (+stepheight+crouchdiff = 66)
    96,//(+stepheight+crouchdiff = 130)
    192,//(+stepheight+crouchdiff = 226)
    384//(+stepheight+crouchdiff = 418)
]

/// Source: oracle/codemp/game/bg_pmove.c:163
let forceJumpStrength: [Float] = [
    Float(JUMP_VELOCITY),//normal jump
    420,
    590,
    840
]

/// Source: oracle/codemp/game/bg_pmove.c:1768
let forceJumpHeightMax: [Float] = [
    66,//normal jump (32+stepheight(18)+crouchdiff(24) = 74)
    130,//(96+stepheight(18)+crouchdiff(24) = 138)
    226,//(192+stepheight(18)+crouchdiff(24) = 234)
    418//(384+stepheight(18)+crouchdiff(24) = 426)
]

/// Raven's `#define SLOPE_RECALC_INT`, a file-local macro of `bg_pmove.c`.
/// Source: oracle/codemp/game/bg_pmove.c:4802
let SLOPE_RECALC_INT: Int32 = 100

/// Raven's `#define USE_DELAY`, a file-local macro of `bg_pmove.c`.
/// Source: oracle/codemp/game/bg_pmove.c:4557
let USE_DELAY: Int32 = 2000

/// Raven's `#define FLY_NONE`, a file-local macro of `bg_pmove.c` that names a value of `pm_flying`.
/// Source: oracle/codemp/game/bg_pmove.c:440
let FLY_NONE: Int32 = 0
/// Source: oracle/codemp/game/bg_pmove.c:441
let FLY_NORMAL: Int32 = 1
/// Source: oracle/codemp/game/bg_pmove.c:442
let FLY_VEHICLE: Int32 = 2
/// Source: oracle/codemp/game/bg_pmove.c:443
let FLY_HOVER: Int32 = 3

//rww - Get a pointer to the bgEntity by the index
/// Source: oracle/codemp/game/bg_pmove.c:172
func PM_BGEntForNum(_ num: Int32) -> JKAMP.BgEntity? {
    // Port-note: Raven walks `(byte *)pm->baseEnt + pm->entSize*num` to reach the slot. Rule 11 keeps a pointer out of a logic target, and `BgEntity` has no slot-at-index helper yet.
    // Port-note: Raven guards a NULL `pm` here and asserts. The view is non-optional, so the guard has no Swift form.
    // TODO: Port PM_BGEntForNum
    portMissing("PM_BGEntForNum", source: "oracle/codemp/game/bg_pmove.c:172")
}

/// Source: oracle/codemp/game/bg_pmove.c:201
func BG_SabersOff(_ ps: JKAMP.PlayerState) -> Bool {
    if ps.saberHolstered == 0 {
        return false
    }
    if ps.fd.saberAnimLevelBase == SS_DUAL
        || ps.fd.saberAnimLevelBase == SS_STAFF {
        if ps.saberHolstered < 2 {
            return false
        }
    }
    return true
}

/// Source: oracle/codemp/game/bg_pmove.c:218
func BG_KnockDownable(_ ps: JKAMP.PlayerState) -> Bool {
    // Port-note: Raven's `if (!ps)` safety check has no Swift form, because the signature takes a non-optional `PlayerState`.
    if ps.m_iVehicleNum != 0 {
        //riding a vehicle, don't knock me down
        return false
    }

    if ps.emplacedIndex != 0 {
        //using emplaced gun or eweb, can't be knocked down
        return false
    }

    //ok, I guess?
    return true
}

//hacky assumption check, assume any client non-humanoid is a rocket trooper
/// Source: oracle/codemp/game/bg_pmove.c:247
func PM_IsRocketTrooper() -> Bool {
    /*
    if (pm->ps->clientNum < MAX_CLIENTS &&
        pm->gametype == GT_SIEGE &&
        pm->nonHumanoid)
    {
        return qtrue;
    }
    */

    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:261
func PM_GetSaberStance() -> Int32 {
    let ps = pm.ps
    var anim = BOTH_STAND2
    let saber1 = BG_MySaber(ps.clientNum, 0)
    let saber2 = BG_MySaber(ps.clientNum, 1)

    if ps.saberEntityNum == 0 {
        //lost it
        return BOTH_STAND1
    }

    if BG_SabersOff(ps) {
        return BOTH_STAND1
    }

    if let saber1,
        saber1.readyAnim != -1 {
        return saber1.readyAnim
    }

    if let saber2,
        saber2.readyAnim != -1 {
        return saber2.readyAnim
    }

    if saber1 != nil
        && saber2 != nil
        && ps.saberHolstered == 0 {
        //dual sabers, both on
        return BOTH_SABERDUAL_STANCE
    }

    switch ps.fd.saberAnimLevel {
    case SS_DUAL:
        anim = BOTH_SABERDUAL_STANCE

    case SS_STAFF:
        anim = BOTH_SABERSTAFF_STANCE

    case SS_FAST, SS_TAVION:
        anim = BOTH_SABERFAST_STANCE

    case SS_STRONG:
        anim = BOTH_SABERSLOW_STANCE

    case SS_NONE, SS_MEDIUM, SS_DESANN:
        anim = BOTH_STAND2

    default:
        anim = BOTH_STAND2
    }
    return anim
}

/// Source: oracle/codemp/game/bg_pmove.c:321
func PM_DoSlowFall() -> Bool {
    let ps = pm.ps
    if ((ps.legsAnim) == BOTH_WALL_RUN_RIGHT || (ps.legsAnim) == BOTH_WALL_RUN_LEFT) && ps.legsTimer > 500 {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:346
func PM_pitch_roll_for_slope(_ forwhom: JKAMP.BgEntity, _ pass_slope: inout JKAShared.vec3_t, _ storeAngles: inout JKAShared.vec3_t) {
    var slope = JKAShared.vec3_t(0, 0, 0)
    var nvf = JKAShared.vec3_t(0, 0, 0)
    var ovf = JKAShared.vec3_t(0, 0, 0)
    var ovr = JKAShared.vec3_t(0, 0, 0)
    var startspot = JKAShared.vec3_t(0, 0, 0)
    var endspot = JKAShared.vec3_t(0, 0, 0)
    var new_angles = JKAShared.vec3_t(0, 0, 0)
    let pitch: Float
    var mod: Float
    let dot: Float
    let ps = pm.ps

    //if we don't have a slope, get one
    // Port-note: Raven guards a NULL `pass_slope` here. The parameter is `inout`, so the guard has no Swift form.
    if VectorCompare(vec3_origin, pass_slope) != 0 {
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut = JKAMP.Trace.scratch { trace -> Bool in
            startspot = ps.origin
            startspot[2] += pm.mins[2] + 4
            endspot = startspot
            endspot[2] -= 300
            pm.runTrace(trace, ps.origin, vec3_origin, vec3_origin, endspot, forwhom.s.number, MASK_SOLID)
//		if(trace_fraction>0.05&&forwhom.movetype==MOVETYPE_STEP)
//			forwhom.flags(-)FL_ONGROUND;

            if trace.fraction >= 1.0 {
                return true
            }

            // Port-note: Raven tests the address of `trace.plane`, which C never gives as NULL. The view is non-optional, so the test has no Swift form.

            if VectorCompare(vec3_origin, trace.plane.normal) != 0 {
                return true
            }

            slope = trace.plane.normal
            return false
        }
        if earlyOut {
            return
        }
    } else {
        slope = pass_slope
    }

    if forwhom.s.NPC_class == CLASS_VEHICLE {
        //special code for vehicles
        // Port-note: Raven reads `pVeh->m_vOrientation[YAW]` in this arm. The generated field is an `OpaquePointer?` for Raven's `float *`, and rule 11 keeps a pointer out of a logic target, so the arm has no Swift form.
        portMissing("PM_pitch_roll_for_slope: pVeh->m_vOrientation", source: "oracle/codemp/game/bg_pmove.c:387")
    } else {
        // Raven passes NULL for the third output of `AngleVectors`. The ported function takes it by reference, so the body passes a scratch vector it never reads.
        var scratchUp = JKAShared.vec3_t(0, 0, 0)
        AngleVectors(ps.viewangles, &ovf, &ovr, &scratchUp)
    }

    vectoangles(slope, &new_angles)
    pitch = new_angles[PITCH] + 90
    new_angles[ROLL] = 0
    new_angles[PITCH] = 0

    var scratchRight = JKAShared.vec3_t(0, 0, 0)
    var scratchUp = JKAShared.vec3_t(0, 0, 0)
    AngleVectors(new_angles, &nvf, &scratchRight, &scratchUp)

    mod = _DotProduct(nvf, ovr)

    if mod < 0 {
        mod = -1
    } else {
        mod = 1
    }

    dot = _DotProduct(nvf, ovf)

    // Port-note: Raven guards a NULL `storeAngles` here. The parameter is `inout`, so the guard has no Swift form, and no path reaches Raven's else arm, which writes `pm->ps->viewangles` and `pm->mins[2]`.
    storeAngles[PITCH] = dot * pitch
    storeAngles[ROLL] = ((1 - Q_fabs(dot)) * pitch * mod)
    /*
    else
    {
        forwhom->currentAngles[PITCH] = dot * pitch;
        forwhom->currentAngles[ROLL] = ((1-Q_fabs(dot)) * pitch * mod);
    }
    */
}

/// Source: oracle/codemp/game/bg_pmove.c:445
var pm_flying: Int32 {
    get { bg.variables.pm_flying }
    set { bg.variables.pm_flying = newValue }
}

/// Source: oracle/codemp/game/bg_pmove.c:447
func PM_SetSpecialMoveValues() {
    let ps = pm.ps
    let pEnt: JKAMP.BgEntity?

    if ps.clientNum < MAX_CLIENTS {
        //we know that real players aren't vehs
        pm_flying = FLY_NONE
        return
    }

    //default until we decide otherwise
    pm_flying = FLY_NONE

    pEnt = pm_entSelf

    if let pEnt {
        if (ps.eFlags2 & EF2_FLYING) != 0 {// pm->gent->client->moveType == MT_FLYSWIM )
            pm_flying = FLY_NORMAL
        } else if pEnt.s.NPC_class == CLASS_VEHICLE {
            // Port-note: Raven walks `pEnt->m_pVehicle->m_pVehicleInfo` with no guard. Both generated fields are optional, so the body binds them, and the nil path takes neither arm.
            if let pVehicleInfo = pEnt.m_pVehicle?.m_pVehicleInfo {
                if pVehicleInfo.type == VH_FIGHTER {
                    pm_flying = FLY_VEHICLE
                } else if pVehicleInfo.hoverHeight > 0 {
                    pm_flying = FLY_HOVER
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:482
private func PM_SetVehicleAngles(_ normal: inout JKAShared.vec3_t) {
    // Port-note: Raven reads and writes `pVeh->m_vOrientation[i]`. The generated field is an `OpaquePointer?` for Raven's `float *`, and rule 11 keeps a pointer out of a logic target.
    // TODO: Port PM_SetVehicleAngles
    portMissing("PM_SetVehicleAngles", source: "oracle/codemp/game/bg_pmove.c:482")
}

/// Source: oracle/codemp/game/bg_pmove.c:641
func BG_ExternThisSoICanRecompileInDebug(_ pVeh: JKAMP.Vehicle, _ riderPS: JKAMP.PlayerState) {
/*
	float pitchSubtract, pitchDelta, yawDelta;
	//Com_Printf( S_COLOR_RED"PITCH: %4.2f, YAW: %4.2f, ROLL: %4.2f\n", riderPS->viewangles[0],riderPS->viewangles[1],riderPS->viewangles[2]);
	yawDelta = AngleSubtract(riderPS->viewangles[YAW],pVeh->m_vPrevRiderViewAngles[YAW]);
#ifndef QAGAME
	if ( !cg_paused.integer )
	{
		//Com_Printf( "%d - yawDelta %4.2f\n", pm->cmd.serverTime, yawDelta );
	}
#endif
	yawDelta *= (4.0f*pVeh->m_fTimeModifier);
	pVeh->m_vOrientation[ROLL] -= yawDelta;

	pitchDelta = AngleSubtract(riderPS->viewangles[PITCH],pVeh->m_vPrevRiderViewAngles[PITCH]);
	pitchDelta *= (2.0f*pVeh->m_fTimeModifier);
	pitchSubtract = pitchDelta * (fabs(pVeh->m_vOrientation[ROLL])/90.0f);
	pVeh->m_vOrientation[PITCH] += pitchDelta-pitchSubtract;
	if ( pVeh->m_vOrientation[ROLL] > 0 )
	{
		pVeh->m_vOrientation[YAW] += pitchSubtract;
	}
	else
	{
		pVeh->m_vOrientation[YAW] -= pitchSubtract;
	}
	pVeh->m_vOrientation[PITCH] = AngleNormalize180( pVeh->m_vOrientation[PITCH] );
	pVeh->m_vOrientation[YAW] = AngleNormalize360( pVeh->m_vOrientation[YAW] );
	pVeh->m_vOrientation[ROLL] = AngleNormalize180( pVeh->m_vOrientation[ROLL] );

	VectorCopy( riderPS->viewangles, pVeh->m_vPrevRiderViewAngles );
*/
}

/// Source: oracle/codemp/game/bg_pmove.c:676
func BG_VehicleTurnRateForSpeed(_ pVeh: JKAMP.Vehicle, _ speed: Float, _ mPitchOverride: inout Float, _ mYawOverride: inout Float) {
    // Port-note: Raven guards a NULL `pVeh` here. The view is non-optional, so that half of the guard has no Swift form.
    if let m_pVehicleInfo = pVeh.m_pVehicleInfo {
        var speedFrac: Float = 1.0
        if m_pVehicleInfo.speedDependantTurning {
            if pVeh.m_LandTrace.fraction >= 1.0
                || pVeh.m_LandTrace.plane.normal[2] < MIN_LANDING_SLOPE {
                speedFrac = (speed / (m_pVehicleInfo.speedMax * 0.75))
                if speedFrac < 0.25 {
                    speedFrac = 0.25
                } else if speedFrac > 1.0 {
                    speedFrac = 1.0
                }
            }
        }
        if m_pVehicleInfo.mousePitch != 0 {
            mPitchOverride = m_pVehicleInfo.mousePitch * speedFrac
        }
        if m_pVehicleInfo.mouseYaw != 0 {
            mYawOverride = m_pVehicleInfo.mouseYaw * speedFrac
        }
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:719
func PM_HoverTrace() {
    // Port-note: Raven reads `pVeh->m_vOrientation[YAW]`. The generated field is an `OpaquePointer?` for Raven's `float *`, and rule 11 keeps a pointer out of a logic target.
    // TODO: Port PM_HoverTrace
    portMissing("PM_HoverTrace", source: "oracle/codemp/game/bg_pmove.c:719")
}

/**
```
===============
PM_AddEvent

===============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:910
func PM_AddEvent(_ newEvent: Int32) {
    let ps = pm.ps
    BG_AddPredictableEventToPlayerstate(newEvent, 0, ps)
}

/// Source: oracle/codemp/game/bg_pmove.c:914
func PM_AddEventWithParm(_ newEvent: Int32, _ parm: Int32) {
    let ps = pm.ps
    BG_AddPredictableEventToPlayerstate(newEvent, parm, ps)
}

/**
```
===============
PM_AddTouchEnt
===============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:924
func PM_AddTouchEnt(_ entityNum: Int32) {
    var i: Int32

    if entityNum == ENTITYNUM_WORLD {
        return
    }
    if pm.numtouch == MAXTOUCH {
        return
    }

    // see if it is already added
    i = 0
    while i < pm.numtouch {
        if pm.touchents[i] == entityNum {
            return
        }
        i += 1
    }

    // add it
    pm.touchents[pm.numtouch] = entityNum
    pm.numtouch += 1
}

/**
```
==================
PM_ClipVelocity

Slide off of the impacting surface
==================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:954
func PM_ClipVelocity(_ `in`: inout JKAShared.vec3_t, _ normal: inout JKAShared.vec3_t, _ out: inout JKAShared.vec3_t, _ overbounce: Float) {
    var backoff: Float
    var change: Float
    let oldInZ: Float
    var i: Int32
    let ps = pm.ps
    if (ps.pm_flags & PMF_STUCK_TO_WALL) != 0 {
        //no sliding!
        out = `in`
        return
    }
    oldInZ = `in`[2]

    backoff = _DotProduct(`in`, normal)

    if backoff < 0 {
        backoff *= overbounce
    } else {
        backoff /= overbounce
    }

    i = 0
    while i < 3 {
        change = normal[i] * backoff
        out[i] = `in`[i] - change
        i += 1
    }
    if pm.stepSlideFix != 0 {
        if ps.clientNum < MAX_CLIENTS//normal player
            && ps.groundEntityNum != ENTITYNUM_NONE//on the ground
            && normal[2] < MIN_WALK_NORMAL//sliding against a steep slope
        {
            //if walking on the ground, don't slide up slopes that are too steep to walk on
            out[2] = oldInZ
        }
    }
}

/**
```
==================
PM_Friction

Handles both ground friction and water friction
==================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:998
private func PM_Friction() {
    var vec: JKAShared.vec3_t
    let speed: Float
    var newspeed: Float
    var control: Float
    var drop: Float
    var pEnt: JKAMP.BgEntity? = nil
    let ps = pm.ps
    // Port-note: Raven aliases `pm->ps->velocity` through `float *vel`. The view carries no pointer, so the body reads and writes the field itself.
    vec = ps.velocity
    if bg.pml.walking {
        vec[2] = 0 // ignore slope movement
    }

    speed = VectorLength(vec)
    if speed < 1 {
        ps.velocity[0] = 0
        ps.velocity[1] = 0 // allow sinking underwater
        if ps.pm_type == PM_SPECTATOR {
            ps.velocity[2] = 0
        }
        // FIXME: still have z friction underwater?
        return
    }

    drop = 0

    if ps.clientNum >= MAX_CLIENTS {
        pEnt = pm_entSelf
    }

    // apply ground friction, even if on ladder
    // Port-note: Raven guards `pEnt->m_pVehicle` and then walks `m_pVehicleInfo` with no guard. Both generated fields are optional, so the body binds both.
    if pm_flying != FLY_VEHICLE,
        let pEnt,
        pEnt.s.NPC_class == CLASS_VEHICLE,
        let m_pVehicle = pEnt.m_pVehicle,
        let m_pVehicleInfo = m_pVehicle.m_pVehicleInfo,
        m_pVehicleInfo.type != VH_ANIMAL,
        m_pVehicleInfo.type != VH_WALKER,
        m_pVehicleInfo.friction != 0 {
        let friction = m_pVehicleInfo.friction
        if (ps.pm_flags & PMF_TIME_KNOCKBACK) == 0 /*&& !(pm->ps->pm_flags & PMF_TIME_NOFRICTION)*/ {
            control = speed < pm_stopspeed ? pm_stopspeed : speed
            drop += control * friction * bg.pml.frametime
            /*
            if ( Flying == FLY_HOVER )
            {
                if ( pm->cmd.rightmove )
                {//if turning, increase friction
                    control *= 2.0f;
                }
                if ( pm->ps->groundEntityNum < ENTITYNUM_NONE )
                {//on the ground
                    drop += control*friction*pml.frametime;
                }
                else if ( pml.groundPlane )
                {//on a slope
                    drop += control*friction*2.0f*pml.frametime;
                }
                else
                {//in air
                    drop += control*2.0f*friction*pml.frametime;
                }
            }
            */
        }
    } else if pm_flying != FLY_NORMAL && pm_flying != FLY_VEHICLE {
        // apply ground friction
        if pm.waterlevel <= 1 {
            if bg.pml.walking && (bg.pml.groundTrace.surfaceFlags & SURF_SLICK) == 0 {
                // if getting knocked back, no friction
                if (ps.pm_flags & PMF_TIME_KNOCKBACK) == 0 {
                    control = speed < pm_stopspeed ? pm_stopspeed : speed
                    drop += control * pm_friction * bg.pml.frametime
                }
            }
        }
    }

    if pm_flying == FLY_VEHICLE {
        if (ps.pm_flags & PMF_TIME_KNOCKBACK) == 0 {
            control = speed// < pm_stopspeed ? pm_stopspeed : speed;
            drop += control * pm_friction * bg.pml.frametime
        }
    }

    // apply water friction even if just wading
    if pm.waterlevel != 0 {
        drop += speed * pm_waterfriction * pm.waterlevel * bg.pml.frametime
    }
    // If on a client then there is no friction
    else if ps.groundEntityNum < MAX_CLIENTS {
        drop = 0
    }

    if ps.pm_type == PM_SPECTATOR || ps.pm_type == PM_FLOAT {
        if ps.pm_type == PM_FLOAT {
            //almost no friction while floating
            // C promotes this product to double, because 0.1 is a double literal.
            // Port-note: Raven adds `drop` in double here, and jka-rust keeps that, so the guide's `Float(...)` at the store can round one ulp early.
            drop += Float(Double(speed) * 0.1 * Double(bg.pml.frametime))
        } else {
            drop += speed * pm_spectatorfriction * bg.pml.frametime
        }
    }

    // scale the velocity
    newspeed = speed - drop
    if newspeed < 0 {
        newspeed = 0
    }
    newspeed /= speed

    ps.velocity[0] = ps.velocity[0] * newspeed
    ps.velocity[1] = ps.velocity[1] * newspeed
    ps.velocity[2] = ps.velocity[2] * newspeed
}

/**
```
==============
PM_Accelerate

Handles user intended acceleration
==============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:1133
private func PM_Accelerate(_ wishdir: inout JKAShared.vec3_t, _ wishspeed: Float, _ accel: Float) {
    let ps = pm.ps
    if pm.gametype != GT_SIEGE
        || ps.m_iVehicleNum != 0
        || ps.clientNum >= MAX_CLIENTS
        || ps.pm_type != PM_NORMAL {
        //standard method, allows "bunnyhopping" and whatnot
        var i: Int32
        let addspeed: Float
        var accelspeed: Float
        let currentspeed: Float

        currentspeed = _DotProduct(ps.velocity, wishdir)
        addspeed = wishspeed - currentspeed
        if addspeed <= 0 && ps.clientNum < MAX_CLIENTS {
            return
        }

        if addspeed < 0 {
            accelspeed = (-accel) * bg.pml.frametime * wishspeed
            if accelspeed < addspeed {
                accelspeed = addspeed
            }
        } else {
            accelspeed = accel * bg.pml.frametime * wishspeed
            if accelspeed > addspeed {
                accelspeed = addspeed
            }
        }

        i = 0
        while i < 3 {
            ps.velocity[i] += accelspeed * wishdir[i]
            i += 1
        }
    } else {
        //use the proper way for siege
        var wishVelocity = JKAShared.vec3_t(0, 0, 0)
        var pushDir = JKAShared.vec3_t(0, 0, 0)
        var pushLen: Float
        var canPush: Float

        _VectorScale(wishdir, wishspeed, &wishVelocity)
        _VectorSubtract(wishVelocity, ps.velocity, &pushDir)
        pushLen = VectorNormalize(&pushDir)

        canPush = accel * bg.pml.frametime * wishspeed
        if canPush > pushLen {
            canPush = pushLen
        }

        _VectorMA(ps.velocity, canPush, pushDir, &ps.velocity)
    }
}

/**
```
============
PM_CmdScale

Returns the scale factor to apply to cmd movements
This allows the clients to use axial -127 to 127 values for all directions
without getting a sqrt(2) distortion in speed.
============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:1199
private func PM_CmdScale(_ cmd: JKAMP.Usercmd) -> Float {
    var max: Int32
    let total: Float
    let scale: Float
    let umove: Int32 = 0 //cmd->upmove;
            //don't factor upmove into scaling speed
    let ps = pm.ps
    // C promotes a `signed char` of `usercmd_t` to `int` in each of these expressions.
    max = abs(Int32(cmd.forwardmove))
    if abs(Int32(cmd.rightmove)) > max {
        max = abs(Int32(cmd.rightmove))
    }
    if abs(umove) > max {
        max = abs(umove)
    }
    if max == 0 {
        return 0
    }

    total = Float(sqrt(Double(Float(Int32(cmd.forwardmove) * Int32(cmd.forwardmove)
        + Int32(cmd.rightmove) * Int32(cmd.rightmove) + umove * umove))))
    // C promotes the divide to double, because 127.0 is a double literal.
    scale = Float(Double(Float(ps.speed) * max) / (127.0 * Double(total)))

    return scale
}

/**
```
================
PM_SetMovementDir

Determine the rotation of the legs reletive
to the facing dir
================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:1233
private func PM_SetMovementDir() {
    let ps = pm.ps
    if pm.cmd.forwardmove != 0 || pm.cmd.rightmove != 0 {
        if pm.cmd.rightmove == 0 && pm.cmd.forwardmove > 0 {
            ps.movementDir = 0
        } else if pm.cmd.rightmove < 0 && pm.cmd.forwardmove > 0 {
            ps.movementDir = 1
        } else if pm.cmd.rightmove < 0 && pm.cmd.forwardmove == 0 {
            ps.movementDir = 2
        } else if pm.cmd.rightmove < 0 && pm.cmd.forwardmove < 0 {
            ps.movementDir = 3
        } else if pm.cmd.rightmove == 0 && pm.cmd.forwardmove < 0 {
            ps.movementDir = 4
        } else if pm.cmd.rightmove > 0 && pm.cmd.forwardmove < 0 {
            ps.movementDir = 5
        } else if pm.cmd.rightmove > 0 && pm.cmd.forwardmove == 0 {
            ps.movementDir = 6
        } else if pm.cmd.rightmove > 0 && pm.cmd.forwardmove > 0 {
            ps.movementDir = 7
        }
    } else {
        // if they aren't actively going directly sideways,
        // change the animation to the diagonal so they
        // don't stop too crooked
        if ps.movementDir == 2 {
            ps.movementDir = 1
        } else if ps.movementDir == 6 {
            ps.movementDir = 7
        }
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:1266
func PM_ForceJumpingUp() -> Bool {
    let ps = pm.ps
    if (ps.fd.forcePowersActive & (1 << FP_LEVITATION)) == 0 && ps.fd.forceJumpCharge != 0 {
        //already jumped and let go
        return false
    }

    if BG_InSpecialJump(ps.legsAnim) {
        return false
    }

    if BG_SaberInSpecial(ps.saberMove) {
        return false
    }

    if BG_SaberInSpecialAttack(ps.legsAnim) {
        return false
    }

    if BG_HasYsalamiri(pm.gametype, ps) {
        return false
    }

    if !BG_CanUseFPNow(pm.gametype, ps, pm.cmd.serverTime, FP_LEVITATION) {
        return false
    }

    if ps.groundEntityNum == ENTITYNUM_NONE && //in air
        (ps.pm_flags & PMF_JUMP_HELD) != 0 && //jumped
        ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_0 && //force-jump capable
        ps.velocity[2] > 0 {
        //going up
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:1308
private func PM_JumpForDir() {
    let ps = pm.ps
    var anim = BOTH_JUMP1
    if pm.cmd.forwardmove > 0 {
        anim = BOTH_JUMP1
        ps.pm_flags &= ~PMF_BACKWARDS_JUMP
    } else if pm.cmd.forwardmove < 0 {
        anim = BOTH_JUMPBACK1
        ps.pm_flags |= PMF_BACKWARDS_JUMP
    } else if pm.cmd.rightmove > 0 {
        anim = BOTH_JUMPRIGHT1
        ps.pm_flags &= ~PMF_BACKWARDS_JUMP
    } else if pm.cmd.rightmove < 0 {
        anim = BOTH_JUMPLEFT1
        ps.pm_flags &= ~PMF_BACKWARDS_JUMP
    } else {
        anim = BOTH_JUMP1
        ps.pm_flags &= ~PMF_BACKWARDS_JUMP
    }
    if !BG_InDeathAnim(ps.legsAnim) {
        PM_SetAnim(SETANIM_LEGS, anim, SETANIM_FLAG_OVERRIDE, 100)
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:1342
func PM_SetPMViewAngle(_ ps: JKAMP.PlayerState, _ angle: inout JKAShared.vec3_t, _ ucmd: JKAMP.Usercmd) {
    var i: Int32

    i = 0
    while i < 3 {
        // set the delta angle
        let cmdAngle: Int32

        cmdAngle = ANGLE2SHORT(angle[i])
        ps.delta_angles[i] = cmdAngle - ucmd.angles[i]
        i += 1
    }
    ps.viewangles = angle
}

/// Source: oracle/codemp/game/bg_pmove.c:1356
func PM_AdjustAngleForWallRun(_ ps: JKAMP.PlayerState, _ ucmd: JKAMP.Usercmd, _ doMove: Bool) -> Bool {
    if ((ps.legsAnim) == BOTH_WALL_RUN_RIGHT || (ps.legsAnim) == BOTH_WALL_RUN_LEFT) && ps.legsTimer > 500 {
        //wall-running and not at end of anim
        //stick to wall, if there is one
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives nil where Raven's block falls through to the trailing return.
        let earlyOut = JKAMP.Trace.scratch { trace -> Bool? in
            var fwd = JKAShared.vec3_t(0, 0, 0)
            var rt = JKAShared.vec3_t(0, 0, 0)
            var traceTo = JKAShared.vec3_t(0, 0, 0)
            var mins = JKAShared.vec3_t(0, 0, 0)
            var maxs = JKAShared.vec3_t(0, 0, 0)
            var fwdAngles = JKAShared.vec3_t(0, 0, 0)
            let dist: Float
            let yawAdjust: Float

            mins = JKAShared.vec3_t(-15, -15, 0)
            maxs = JKAShared.vec3_t(15, 15, 24)
            fwdAngles = JKAShared.vec3_t(0, pm.ps.viewangles[YAW], 0)

            // Raven passes NULL for the third output of `AngleVectors`. The ported function takes it by reference, so the body passes a scratch vector it never reads.
            var scratchUp = JKAShared.vec3_t(0, 0, 0)
            AngleVectors(fwdAngles, &fwd, &rt, &scratchUp)
            if (ps.legsAnim) == BOTH_WALL_RUN_RIGHT {
                dist = 128
                yawAdjust = -90
            } else {
                dist = -128
                yawAdjust = 90
            }
            _VectorMA(ps.origin, dist, rt, &traceTo)

            pm.runTrace(trace, ps.origin, mins, maxs, traceTo, ps.clientNum, MASK_PLAYERSOLID)

            if trace.fraction < 1.0
                && (trace.plane.normal[2] >= 0.0 && trace.plane.normal[2] <= 0.4) {//&& ent->client->ps.groundEntityNum == ENTITYNUM_NONE )
                JKAMP.Trace.scratch { trace2 in
                    var traceTo2 = JKAShared.vec3_t(0, 0, 0)
                    var wallRunFwd = JKAShared.vec3_t(0, 0, 0)
                    var wallRunAngles = JKAShared.vec3_t(0, 0, 0)

                    wallRunAngles = JKAShared.vec3_t(0, 0, 0)
                    wallRunAngles[YAW] = vectoyaw(trace.plane.normal) + yawAdjust
                    // Raven passes NULL for the second and third outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
                    var wallRunRight = JKAShared.vec3_t(0, 0, 0)
                    var wallRunUp = JKAShared.vec3_t(0, 0, 0)
                    AngleVectors(wallRunAngles, &wallRunFwd, &wallRunRight, &wallRunUp)

                    _VectorMA(pm.ps.origin, 32, wallRunFwd, &traceTo2)
                    pm.runTrace(trace2, pm.ps.origin, mins, maxs, traceTo2, pm.ps.clientNum, MASK_PLAYERSOLID)
                    if trace2.fraction < 1.0 && _DotProduct(trace2.plane.normal, wallRunFwd) <= -0.999 {
                        //wall we can't run on in front of us
                        trace.fraction = 1.0//just a way to get it to kick us off the wall below
                    }
                }
            }

            if trace.fraction < 1.0
                && (trace.plane.normal[2] >= 0.0 && trace.plane.normal[2] <= 0.4/*MAX_WALL_RUN_Z_NORMAL*/) {
                //still a wall there
                if (ps.legsAnim) == BOTH_WALL_RUN_RIGHT {
                    ucmd.rightmove = 127
                } else {
                    ucmd.rightmove = -127
                }
                if ucmd.upmove < 0 {
                    ucmd.upmove = 0
                }
                //make me face perpendicular to the wall
                ps.viewangles[YAW] = vectoyaw(trace.plane.normal) + yawAdjust

                PM_SetPMViewAngle(ps, &ps.viewangles, ucmd)

                ucmd.angles[YAW] = ANGLE2SHORT(ps.viewangles[YAW]) - ps.delta_angles[YAW]
                if doMove {
                    //push me forward
                    let zVel = ps.velocity[2]
                    if ps.legsTimer > 500 {
                        //not at end of anim yet
                        var speed: Float = 175
                        if ucmd.forwardmove < 0 {
                            //slower
                            speed = 100
                        } else if ucmd.forwardmove > 0 {
                            speed = 250//running speed
                        }
                        _VectorScale(fwd, speed, &ps.velocity)
                    }
                    ps.velocity[2] = zVel//preserve z velocity
                    //pull me toward the wall, too
                    _VectorMA(ps.velocity, dist, rt, &ps.velocity)
                }
                ucmd.forwardmove = 0
                return true
            } else if doMove {
                //stop it
                if (ps.legsAnim) == BOTH_WALL_RUN_RIGHT {
                    PM_SetAnim(SETANIM_BOTH, BOTH_WALL_RUN_RIGHT_STOP, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                } else if (ps.legsAnim) == BOTH_WALL_RUN_LEFT {
                    PM_SetAnim(SETANIM_BOTH, BOTH_WALL_RUN_LEFT_STOP, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                }
            }
            return nil
        }
        if let earlyOut {
            return earlyOut
        }
    }

    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:1464
func PM_AdjustAnglesForWallRunUpFlipAlt(_ ucmd: JKAMP.Usercmd) -> Bool {
//	ucmd->angles[PITCH] = ANGLE2SHORT( pm->ps->viewangles[PITCH] ) - pm->ps->delta_angles[PITCH];
//	ucmd->angles[YAW] = ANGLE2SHORT( pm->ps->viewangles[YAW] ) - pm->ps->delta_angles[YAW];
    let ps = pm.ps
    PM_SetPMViewAngle(ps, &ps.viewangles, ucmd)
    return true
}

/// Source: oracle/codemp/game/bg_pmove.c:1472
func PM_AdjustAngleForWallRunUp(_ ps: JKAMP.PlayerState, _ ucmd: JKAMP.Usercmd, _ doMove: Bool) -> Bool {
    if ps.legsAnim == BOTH_FORCEWALLRUNFLIP_START {
        //wall-running up
        //stick to wall, if there is one
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives nil where Raven's block falls through to the trailing return.
        let earlyOut = JKAMP.Trace.scratch { trace -> Bool? in
            var fwd = JKAShared.vec3_t(0, 0, 0)
            var traceTo = JKAShared.vec3_t(0, 0, 0)
            var mins = JKAShared.vec3_t(0, 0, 0)
            var maxs = JKAShared.vec3_t(0, 0, 0)
            var fwdAngles = JKAShared.vec3_t(0, 0, 0)
            let dist: Float = 128

            mins = JKAShared.vec3_t(-15, -15, 0)
            maxs = JKAShared.vec3_t(15, 15, 24)
            fwdAngles = JKAShared.vec3_t(0, pm.ps.viewangles[YAW], 0)

            // Raven passes NULL for the second and third outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
            var scratchRight = JKAShared.vec3_t(0, 0, 0)
            var scratchUp = JKAShared.vec3_t(0, 0, 0)
            AngleVectors(fwdAngles, &fwd, &scratchRight, &scratchUp)
            _VectorMA(ps.origin, dist, fwd, &traceTo)
            pm.runTrace(trace, ps.origin, mins, maxs, traceTo, ps.clientNum, MASK_PLAYERSOLID)
            if trace.fraction > 0.5 {
                //hmm, some room, see if there's a floor right here
                let landed = JKAMP.Trace.scratch { trace2 -> Bool? in
                    var top = JKAShared.vec3_t(0, 0, 0)
                    var bottom = JKAShared.vec3_t(0, 0, 0)

                    top = trace.endpos
                    top[2] += (pm.mins[2] * -1) + 4.0
                    bottom = top
                    bottom[2] -= 64.0
                    pm.runTrace(trace2, top, pm.mins, pm.maxs, bottom, ps.clientNum, MASK_PLAYERSOLID)
                    if trace2.allsolid == 0
                        && trace2.startsolid == 0
                        && trace2.fraction < 1.0
                        && trace2.plane.normal[2] > 0.7 {//slope we can stand on
                        //cool, do the alt-flip and land on whetever it is we just scaled up
                        _VectorScale(fwd, 100, &pm.ps.velocity)
                        pm.ps.velocity[2] += 400
                        PM_SetAnim(SETANIM_BOTH, BOTH_FORCEWALLRUNFLIP_ALT, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                        pm.ps.pm_flags |= PMF_JUMP_HELD
                        //ent->client->ps.pm_flags |= PMF_JUMPING|PMF_SLOW_MO_FALL;
                        //ent->client->ps.forcePowersActive |= (1<<FP_LEVITATION);
                        //G_AddEvent( ent, EV_JUMP, 0 );
                        PM_AddEvent(EV_JUMP)
                        ucmd.upmove = 0
                        return false
                    }
                    return nil
                }
                if let landed {
                    return landed
                }
            }

            if //ucmd->upmove <= 0 && 
                ps.legsTimer > 0 &&
                ucmd.forwardmove > 0 &&
                trace.fraction < 1.0 &&
                (trace.plane.normal[2] >= 0.0 && trace.plane.normal[2] <= 0.4/*MAX_WALL_RUN_Z_NORMAL*/) {
                //still a vertical wall there
                //make sure there's not a ceiling above us!
                let keptGoing = JKAMP.Trace.scratch { trace2 -> Bool? in
                    traceTo = ps.origin
                    traceTo[2] += 64
                    pm.runTrace(trace2, ps.origin, mins, maxs, traceTo, ps.clientNum, MASK_PLAYERSOLID)
                    if trace2.fraction < 1.0 {
                        //will hit a ceiling, so force jump-off right now
                        //NOTE: hits any entity or clip brush in the way, too, not just architecture!
                    } else {
                        //all clear, keep going
                        //FIXME: don't pull around 90 turns
                        //FIXME: simulate stepping up steps here, somehow?
                        ucmd.forwardmove = 127
                        if ucmd.upmove < 0 {
                            ucmd.upmove = 0
                        }
                        //make me face the wall
                        ps.viewangles[YAW] = vectoyaw(trace.plane.normal) + 180
                        PM_SetPMViewAngle(ps, &ps.viewangles, ucmd)
                        /*
                        if ( ent->client->ps.viewEntity <= 0 || ent->client->ps.viewEntity >= ENTITYNUM_WORLD )
                        {//don't clamp angles when looking through a viewEntity
                            SetClientViewAngle( ent, ent->client->ps.viewangles );
                        }
                        */
                        ucmd.angles[YAW] = ANGLE2SHORT(ps.viewangles[YAW]) - ps.delta_angles[YAW]
                        //if ( ent->s.number || !player_locked )
                        if true {//aslkfhsakf
                            if doMove {
                                //pull me toward the wall
                                _VectorScale(trace.plane.normal, -dist * trace.fraction, &ps.velocity)
                                //push me up
                                if ps.legsTimer > 200 {
                                    //not at end of anim yet
                                    let speed: Float = 300
                                    /*
                                    if ( ucmd->forwardmove < 0 )
                                    {//slower
                                        speed = 100;
                                    }
                                    else if ( ucmd->forwardmove > 0 )
                                    {
                                        speed = 250;//running speed
                                    }
                                    */
                                    ps.velocity[2] = speed//preserve z velocity
                                }
                            }
                        }
                        ucmd.forwardmove = 0
                        return true
                    }
                    return nil
                }
                if let keptGoing {
                    return keptGoing
                }
            }
            //failed!
            if doMove {
                //stop it
                _VectorScale(fwd, -300.0, &ps.velocity)
                ps.velocity[2] += 200
                //NPC_SetAnim( ent, SETANIM_BOTH, BOTH_FORCEWALLRUNFLIP_END, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD );
                //why?!?#?#@!%$R@$KR#F:Hdl;asfm
                PM_SetAnim(SETANIM_BOTH, BOTH_FORCEWALLRUNFLIP_END, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                ps.pm_flags |= PMF_JUMP_HELD
                //ent->client->ps.pm_flags |= PMF_JUMPING|PMF_SLOW_MO_FALL;

                //FIXME do I need this in mp?
                //ent->client->ps.forcePowersActive |= (1<<FP_LEVITATION);
                PM_AddEvent(EV_JUMP)
                ucmd.upmove = 0
                //return qtrue;
            }
            return nil
        }
        if let earlyOut {
            return earlyOut
        }
    }
    return false
}

//nice...
/// Source: oracle/codemp/game/bg_pmove.c:1602
private func BG_ForceWallJumpStrength() -> Float {
    return (forceJumpStrength[FORCE_LEVEL_3] / 2.5)
}

/// Source: oracle/codemp/game/bg_pmove.c:1607
func PM_AdjustAngleForWallJump(_ ps: JKAMP.PlayerState, _ ucmd: JKAMP.Usercmd, _ doMove: Bool) -> Bool {
    if ((BG_InReboundJump(ps.legsAnim) || BG_InReboundHold(ps.legsAnim))
            && (BG_InReboundJump(ps.torsoAnim) || BG_InReboundHold(ps.torsoAnim)))
        || (pm.ps.pm_flags & PMF_STUCK_TO_WALL) != 0 {
        //hugging wall, getting ready to jump off
        //stick to wall, if there is one
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives nil where Raven's block falls through to the trailing return.
        let earlyOut = JKAMP.Trace.scratch { trace -> Bool? in
            var checkDir = JKAShared.vec3_t(0, 0, 0)
            var traceTo = JKAShared.vec3_t(0, 0, 0)
            var mins = JKAShared.vec3_t(0, 0, 0)
            var maxs = JKAShared.vec3_t(0, 0, 0)
            var fwdAngles = JKAShared.vec3_t(0, 0, 0)
            let dist: Float = 128.0
            let yawAdjust: Float

            mins = JKAShared.vec3_t(pm.mins[0], pm.mins[1], 0)
            maxs = JKAShared.vec3_t(pm.maxs[0], pm.maxs[1], 24)
            fwdAngles = JKAShared.vec3_t(0, pm.ps.viewangles[YAW], 0)

            // Raven passes NULL for the outputs of `AngleVectors` he does not read. The ported function takes them by reference, so the body passes scratch vectors it never reads.
            var scratchForward = JKAShared.vec3_t(0, 0, 0)
            var scratchRight = JKAShared.vec3_t(0, 0, 0)
            var scratchUp = JKAShared.vec3_t(0, 0, 0)

            switch ps.legsAnim {
            case BOTH_FORCEWALLREBOUND_RIGHT,
                 BOTH_FORCEWALLHOLD_RIGHT:
                AngleVectors(fwdAngles, &scratchForward, &checkDir, &scratchUp)
                yawAdjust = -90

            case BOTH_FORCEWALLREBOUND_LEFT,
                 BOTH_FORCEWALLHOLD_LEFT:
                AngleVectors(fwdAngles, &scratchForward, &checkDir, &scratchUp)
                checkDir = checkDir * -1
                yawAdjust = 90

            case BOTH_FORCEWALLREBOUND_FORWARD,
                 BOTH_FORCEWALLHOLD_FORWARD:
                AngleVectors(fwdAngles, &checkDir, &scratchRight, &scratchUp)
                yawAdjust = 180

            case BOTH_FORCEWALLREBOUND_BACK,
                 BOTH_FORCEWALLHOLD_BACK:
                AngleVectors(fwdAngles, &checkDir, &scratchRight, &scratchUp)
                checkDir = checkDir * -1
                yawAdjust = 0

            default:
                //WTF???
                pm.ps.pm_flags &= ~PMF_STUCK_TO_WALL
                return false
            }
            if pm.debugMelee != 0 {
                //uber-skillz
                if ucmd.upmove > 0 {
                    //hold on until you let go manually
                    if BG_InReboundHold(ps.legsAnim) {
                        //keep holding
                        if ps.legsTimer < 150 {
                            ps.legsTimer = 150
                        }
                    } else {
                        //if got to hold part of anim, play hold anim
                        if ps.legsTimer <= 300 {
                            ps.saberHolstered = 2
                            PM_SetAnim(SETANIM_BOTH, BOTH_FORCEWALLRELEASE_FORWARD + (ps.legsAnim - BOTH_FORCEWALLHOLD_FORWARD), SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                            ps.legsTimer = 150
                            ps.torsoTimer = 150
                        }
                    }
                }
            }
            _VectorMA(ps.origin, dist, checkDir, &traceTo)
            pm.runTrace(trace, ps.origin, mins, maxs, traceTo, ps.clientNum, MASK_PLAYERSOLID)
            if //ucmd->upmove <= 0 && 
                ps.legsTimer > 100 &&
                trace.fraction < 1.0 &&
                Q_fabs(trace.plane.normal[2]) <= 0.2/*MAX_WALL_GRAB_SLOPE*/ {
                //still a vertical wall there
                //FIXME: don't pull around 90 turns
                /*
                if ( ent->s.number || !player_locked )
                {
                    ucmd->forwardmove = 127;
                }
                */
                if ucmd.upmove < 0 {
                    ucmd.upmove = 0
                }
                //align me to the wall
                ps.viewangles[YAW] = vectoyaw(trace.plane.normal) + yawAdjust
                PM_SetPMViewAngle(ps, &ps.viewangles, ucmd)
                /*
                if ( ent->client->ps.viewEntity <= 0 || ent->client->ps.viewEntity >= ENTITYNUM_WORLD )
                {//don't clamp angles when looking through a viewEntity
                    SetClientViewAngle( ent, ent->client->ps.viewangles );
                }
                */
                ucmd.angles[YAW] = ANGLE2SHORT(ps.viewangles[YAW]) - ps.delta_angles[YAW]
                //if ( ent->s.number || !player_locked )
                if true {
                    if doMove {
                        //pull me toward the wall
                        _VectorScale(trace.plane.normal, -128.0, &ps.velocity)
                    }
                }
                ucmd.upmove = 0
                ps.pm_flags |= PMF_STUCK_TO_WALL
                return true
            } else if doMove
                && (ps.pm_flags & PMF_STUCK_TO_WALL) != 0 {
                //jump off
                //push off of it!
                ps.pm_flags &= ~PMF_STUCK_TO_WALL
                ps.velocity[0] = 0
                ps.velocity[1] = 0
                // Raven's `JUMP_OFF_WALL_SPEED` is 200.0f.
                _VectorScale(checkDir, -200.0, &ps.velocity)
                ps.velocity[2] = BG_ForceWallJumpStrength()
                ps.pm_flags |= PMF_JUMP_HELD//PMF_JUMPING|PMF_JUMP_HELD;
                //G_SoundOnEnt( ent, CHAN_BODY, "sound/weapons/force/jump.wav" );
                ps.fd.forceJumpSound = 1 //this is a stupid thing, i should fix it.
                //ent->client->ps.forcePowersActive |= (1<<FP_LEVITATION);
                if ps.origin[2] < ps.fd.forceJumpZStart {
                    ps.fd.forceJumpZStart = ps.origin[2]
                }
                //FIXME do I need this?

                BG_ForcePowerDrain(ps, FP_LEVITATION, 10)
                //no control for half a second
                ps.pm_flags |= PMF_TIME_KNOCKBACK
                ps.pm_time = 500
                ucmd.forwardmove = 0
                ucmd.rightmove = 0
                ucmd.upmove = 127

                if BG_InReboundHold(ps.legsAnim) {
                    //if was in hold pose, release now
                    PM_SetAnim(SETANIM_BOTH, BOTH_FORCEWALLRELEASE_FORWARD + (ps.legsAnim - BOTH_FORCEWALLHOLD_FORWARD), SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                } else {
                    //PM_JumpForDir();
                    PM_SetAnim(SETANIM_LEGS, BOTH_FORCEJUMP1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD | SETANIM_FLAG_RESTART, 0)
                }

                //return qtrue;
            }
            return nil
        }
        if let earlyOut {
            return earlyOut
        }
    }
    ps.pm_flags &= ~PMF_STUCK_TO_WALL
    return false
}

//Set the height for when a force jump was started. If it's 0, nuge it up (slight hack to prevent holding jump over slopes)
/// Source: oracle/codemp/game/bg_pmove.c:1759
func PM_SetForceJumpZStart(_ value: Float) {
    let ps = pm.ps
    ps.fd.forceJumpZStart = value
    if ps.fd.forceJumpZStart == 0 {
        ps.fd.forceJumpZStart -= 0.1
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:1776
func PM_GrabWallForJump(_ anim: Int32) {
    //NOTE!!! assumes an appropriate anim is being passed in!!!
    let ps = pm.ps
    PM_SetAnim(SETANIM_BOTH, anim, SETANIM_FLAG_RESTART | SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
    PM_AddEvent(EV_JUMP)//make sound for grab
    ps.pm_flags |= PMF_STUCK_TO_WALL
}

/**
```
=============
PM_CheckJump
=============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:1788
private func PM_CheckJump() -> Bool {
    var allowFlips = true
    let ps = pm.ps

    if ps.clientNum >= MAX_CLIENTS {
        let pEnt: JKAMP.BgEntity? = pm_entSelf

        // Port-note: Raven reads `pEnt` with no NULL guard. The generated view is optional, so the body binds it.
        if let pEnt,
            pEnt.s.eType == ET_NPC,
            pEnt.s.NPC_class == CLASS_VEHICLE {
            //no!
            return false
        }
    }

    if ps.forceHandExtend == HANDEXTEND_KNOCKDOWN
        || ps.forceHandExtend == HANDEXTEND_PRETHROWN
        || ps.forceHandExtend == HANDEXTEND_POSTTHROWN {
        return false
    }

    if ps.pm_type == PM_JETPACK {
        //there's no actual jumping while we jetpack
        return false
    }

    //Don't allow jump until all buttons are up
    if (ps.pm_flags & PMF_RESPAWNED) != 0 {
        return false
    }

    if PM_InKnockDown(ps) || BG_InRoll(ps, ps.legsAnim) {
        //in knockdown
        return false
    }

    if ps.weapon == WP_SABER {
        let saber1 = BG_MySaber(ps.clientNum, 0)
        let saber2 = BG_MySaber(ps.clientNum, 1)
        if let saber1,
            (saber1.saberFlags & SFL_NO_FLIPS) != 0 {
            allowFlips = false
        }
        if let saber2,
            (saber2.saberFlags & SFL_NO_FLIPS) != 0 {
            allowFlips = false
        }
    }

    if ps.groundEntityNum != ENTITYNUM_NONE || ps.origin[2] < ps.fd.forceJumpZStart {
        ps.fd.forcePowersActive &= ~(1 << FP_LEVITATION)
    }

    if (ps.fd.forcePowersActive & (1 << FP_LEVITATION)) != 0 {
        //Force jump is already active.. continue draining power appropriately until we land.
        if ps.fd.forcePowerDebounce[FP_LEVITATION] < pm.cmd.serverTime {
            if pm.gametype == GT_DUEL
                || pm.gametype == GT_POWERDUEL {
                //jump takes less power
                BG_ForcePowerDrain(ps, FP_LEVITATION, 1)
            } else {
                BG_ForcePowerDrain(ps, FP_LEVITATION, 5)
            }
            if ps.fd.forcePowerLevel[FP_LEVITATION] >= FORCE_LEVEL_2 {
                ps.fd.forcePowerDebounce[FP_LEVITATION] = pm.cmd.serverTime + 300
            } else {
                ps.fd.forcePowerDebounce[FP_LEVITATION] = pm.cmd.serverTime + 200
            }
        }
    }

    if ps.forceJumpFlip {
        //Forced jump anim
        var anim = BOTH_FORCEINAIR1
        var parts = SETANIM_BOTH
        if allowFlips {
            if pm.cmd.forwardmove > 0 {
                anim = BOTH_FLIP_F
            } else if pm.cmd.forwardmove < 0 {
                anim = BOTH_FLIP_B
            } else if pm.cmd.rightmove > 0 {
                anim = BOTH_FLIP_R
            } else if pm.cmd.rightmove < 0 {
                anim = BOTH_FLIP_L
            }
        } else {
            if pm.cmd.forwardmove > 0 {
                anim = BOTH_FORCEINAIR1
            } else if pm.cmd.forwardmove < 0 {
                anim = BOTH_FORCEINAIRBACK1
            } else if pm.cmd.rightmove > 0 {
                anim = BOTH_FORCEINAIRRIGHT1
            } else if pm.cmd.rightmove < 0 {
                anim = BOTH_FORCEINAIRLEFT1
            }
        }
        if ps.weaponTime != 0 {
            //FIXME: really only care if we're in a saber attack anim...
            parts = SETANIM_LEGS
        }

        PM_SetAnim(parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 150)
        ps.forceJumpFlip = false
        return true
    }
    // Raven's `#if METROID_JUMP` is 1 in this build, so the block below is the arm the build takes.
    if pm.waterlevel < 2 {
        if ps.gravity > 0 {
            //can't do this in zero-G
            if PM_ForceJumpingUp() {
                //holding jump in air
                let curHeight = ps.origin[2] - ps.fd.forceJumpZStart
                //check for max force jump level and cap off & cut z vel
                if (curHeight <= forceJumpHeight[0] ||//still below minimum jump height
                        (ps.fd.forcePower != 0 && pm.cmd.upmove >= 10))////still have force power available and still trying to jump up
                    && curHeight < forceJumpHeight[ps.fd.forcePowerLevel[FP_LEVITATION]]
                    && ps.fd.forceJumpZStart != 0 {//still below maximum jump height
                    //can still go up
                    if curHeight > forceJumpHeight[0] {
                        //passed normal jump height  *2?
                        if (ps.fd.forcePowersActive & (1 << FP_LEVITATION)) == 0 {//haven't started forcejump yet
                            //start force jump
                            ps.fd.forcePowersActive |= (1 << FP_LEVITATION)
                            ps.fd.forceJumpSound = 1
                            //play flip
                            if (pm.cmd.forwardmove != 0 || pm.cmd.rightmove != 0) && //pushing in a dir
                                (ps.legsAnim) != BOTH_FLIP_F &&//not already flipping
                                (ps.legsAnim) != BOTH_FLIP_B &&
                                (ps.legsAnim) != BOTH_FLIP_R &&
                                (ps.legsAnim) != BOTH_FLIP_L
                                && allowFlips {
                                var anim = BOTH_FORCEINAIR1
                                var parts = SETANIM_BOTH

                                if pm.cmd.forwardmove > 0 {
                                    anim = BOTH_FLIP_F
                                } else if pm.cmd.forwardmove < 0 {
                                    anim = BOTH_FLIP_B
                                } else if pm.cmd.rightmove > 0 {
                                    anim = BOTH_FLIP_R
                                } else if pm.cmd.rightmove < 0 {
                                    anim = BOTH_FLIP_L
                                }
                                if ps.weaponTime != 0 {
                                    parts = SETANIM_LEGS
                                }

                                PM_SetAnim(parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 150)
                            } else if ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_1 {
                                var facingFwd = JKAShared.vec3_t(0, 0, 0)
                                var facingRight = JKAShared.vec3_t(0, 0, 0)
                                var facingAngles = JKAShared.vec3_t(0, 0, 0)
                                var anim: Int32 = -1
                                let dotR: Float, dotF: Float

                                facingAngles = JKAShared.vec3_t(0, ps.viewangles[YAW], 0)

                                // Raven passes NULL for the third output of `AngleVectors`. The ported function takes it by reference, so the body passes a scratch vector it never reads.
                                var scratchUp = JKAShared.vec3_t(0, 0, 0)
                                AngleVectors(facingAngles, &facingFwd, &facingRight, &scratchUp)
                                dotR = _DotProduct(facingRight, ps.velocity)
                                dotF = _DotProduct(facingFwd, ps.velocity)

                                // C computes this comparison in double, because `fabs` returns a double and 1.5 is a double literal.
                                if Double(Q_fabs(dotR)) > Double(Q_fabs(dotF)) * 1.5 {
                                    if dotR > 150 {
                                        anim = BOTH_FORCEJUMPRIGHT1
                                    } else if dotR < -150 {
                                        anim = BOTH_FORCEJUMPLEFT1
                                    }
                                } else {
                                    if dotF > 150 {
                                        anim = BOTH_FORCEJUMP1
                                    } else if dotF < -150 {
                                        anim = BOTH_FORCEJUMPBACK1
                                    }
                                }
                                if anim != -1 {
                                    var parts = SETANIM_BOTH
                                    if ps.weaponTime != 0 {
                                        //FIXME: really only care if we're in a saber attack anim...
                                        parts = SETANIM_LEGS
                                    }

                                    PM_SetAnim(parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 150)
                                }
                            }
                        } else {
                            //jump is already active (the anim has started)
                            if ps.legsTimer < 1 {
                                //not in the middle of a legsAnim
                                let anim = (ps.legsAnim)
                                var newAnim: Int32 = -1
                                switch anim {
                                case BOTH_FORCEJUMP1:
                                    newAnim = BOTH_FORCELAND1//BOTH_FORCEINAIR1;

                                case BOTH_FORCEJUMPBACK1:
                                    newAnim = BOTH_FORCELANDBACK1//BOTH_FORCEINAIRBACK1;

                                case BOTH_FORCEJUMPLEFT1:
                                    newAnim = BOTH_FORCELANDLEFT1//BOTH_FORCEINAIRLEFT1;

                                case BOTH_FORCEJUMPRIGHT1:
                                    newAnim = BOTH_FORCELANDRIGHT1//BOTH_FORCEINAIRRIGHT1;

                                default:
                                    break
                                }
                                if newAnim != -1 {
                                    var parts = SETANIM_BOTH
                                    if ps.weaponTime != 0 {
                                        parts = SETANIM_LEGS
                                    }

                                    PM_SetAnim(parts, newAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 150)
                                }
                            }
                        }
                    }

                    //need to scale this down, start with height velocity (based on max force jump height) and scale down to regular jump vel
                    ps.velocity[2] = (forceJumpHeight[ps.fd.forcePowerLevel[FP_LEVITATION]] - curHeight) / forceJumpHeight[ps.fd.forcePowerLevel[FP_LEVITATION]] * forceJumpStrength[ps.fd.forcePowerLevel[FP_LEVITATION]]//JUMP_VELOCITY;
                    ps.velocity[2] /= 10
                    ps.velocity[2] += JUMP_VELOCITY
                    ps.pm_flags |= PMF_JUMP_HELD
                } else if curHeight > forceJumpHeight[0] && curHeight < forceJumpHeight[ps.fd.forcePowerLevel[FP_LEVITATION]] - forceJumpHeight[0] {
                    //still have some headroom, don't totally stop it
                    if ps.velocity[2] > JUMP_VELOCITY {
                        ps.velocity[2] = Float(JUMP_VELOCITY)
                    }
                } else {
                    //pm->ps->velocity[2] = 0;
                    //rww - changed for the sake of balance in multiplayer

                    if ps.velocity[2] > JUMP_VELOCITY {
                        ps.velocity[2] = Float(JUMP_VELOCITY)
                    }
                }
                pm.cmd.upmove = 0
                return false
            }
        }
    }

    //Not jumping
    if pm.cmd.upmove < 10 && ps.groundEntityNum != ENTITYNUM_NONE {
        return false
    }

    // must wait for jump to be released
    if (ps.pm_flags & PMF_JUMP_HELD) != 0 {
        // clear upmove so cmdscale doesn't lower running speed
        pm.cmd.upmove = 0
        return false
    }

    if ps.gravity <= 0 {
        //in low grav, you push in the dir you're facing as long as there is something behind you to shove off of
        var forward = JKAShared.vec3_t(0, 0, 0)
        var back = JKAShared.vec3_t(0, 0, 0)

        // Raven passes NULL for the last two outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
        var scratchRight = JKAShared.vec3_t(0, 0, 0)
        var scratchUp = JKAShared.vec3_t(0, 0, 0)
        AngleVectors(ps.viewangles, &forward, &scratchRight, &scratchUp)
        _VectorMA(ps.origin, -8, forward, &back)
        Trace.scratch { trace in
            pm.runTrace(trace, ps.origin, pm.mins, pm.maxs, back, ps.clientNum, pm.tracemask)

            if trace.fraction <= 1.0 {
                _VectorMA(ps.velocity, Float(JUMP_VELOCITY * 2), forward, &ps.velocity)
                PM_SetAnim(SETANIM_LEGS, BOTH_FORCEJUMP1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD | SETANIM_FLAG_RESTART, 150)
            }//else no surf close enough to push off of
        }
        pm.cmd.upmove = 0
    } else if pm.cmd.upmove > 0 && pm.waterlevel < 2
        && ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_0
        && (ps.pm_flags & PMF_JUMP_HELD) == 0
        && (ps.weapon == WP_SABER || ps.weapon == WP_MELEE)
        && !PM_IsRocketTrooper()
        && !BG_HasYsalamiri(pm.gametype, ps)
        && BG_CanUseFPNow(pm.gametype, ps, pm.cmd.serverTime, FP_LEVITATION) {
        var allowWallRuns = true
        var allowWallFlips = true
        var allowFlips = true
        var allowWallGrabs = true
        if ps.weapon == WP_SABER {
            let saber1 = BG_MySaber(ps.clientNum, 0)
            let saber2 = BG_MySaber(ps.clientNum, 1)
            if let saber1,
                (saber1.saberFlags & SFL_NO_WALL_RUNS) != 0 {
                allowWallRuns = false
            }
            if let saber2,
                (saber2.saberFlags & SFL_NO_WALL_RUNS) != 0 {
                allowWallRuns = false
            }
            if let saber1,
                (saber1.saberFlags & SFL_NO_WALL_FLIPS) != 0 {
                allowWallFlips = false
            }
            if let saber2,
                (saber2.saberFlags & SFL_NO_WALL_FLIPS) != 0 {
                allowWallFlips = false
            }
            if let saber1,
                (saber1.saberFlags & SFL_NO_FLIPS) != 0 {
                allowFlips = false
            }
            if let saber2,
                (saber2.saberFlags & SFL_NO_FLIPS) != 0 {
                allowFlips = false
            }
            if let saber1,
                (saber1.saberFlags & SFL_NO_WALL_GRAB) != 0 {
                allowWallGrabs = false
            }
            if let saber2,
                (saber2.saberFlags & SFL_NO_WALL_GRAB) != 0 {
                allowWallGrabs = false
            }
        }

        if ps.groundEntityNum != ENTITYNUM_NONE {
            //on the ground
            //check for left-wall and right-wall special jumps
            var anim: Int32 = -1
            var vertPush: Float = 0
            if pm.cmd.rightmove > 0 && ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_1 {
                //strafing right
                if pm.cmd.forwardmove > 0 {
                    //wall-run
                    if allowWallRuns {
                        vertPush = forceJumpStrength[FORCE_LEVEL_2] / 2.0
                        anim = BOTH_WALL_RUN_RIGHT
                    }
                } else if pm.cmd.forwardmove == 0 {
                    //wall-flip
                    if allowWallFlips {
                        vertPush = forceJumpStrength[FORCE_LEVEL_2] / 2.25
                        anim = BOTH_WALL_FLIP_RIGHT
                    }
                }
            } else if pm.cmd.rightmove < 0 && ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_1 {
                //strafing left
                if pm.cmd.forwardmove > 0 {
                    //wall-run
                    if allowWallRuns {
                        vertPush = forceJumpStrength[FORCE_LEVEL_2] / 2.0
                        anim = BOTH_WALL_RUN_LEFT
                    }
                } else if pm.cmd.forwardmove == 0 {
                    //wall-flip
                    if allowWallFlips {
                        vertPush = forceJumpStrength[FORCE_LEVEL_2] / 2.25
                        anim = BOTH_WALL_FLIP_LEFT
                    }
                }
            } else if pm.cmd.forwardmove < 0 && (pm.cmd.buttons & BUTTON_ATTACK) == 0 {
                //backflip
                if allowFlips {
                    vertPush = Float(JUMP_VELOCITY)
                    anim = BOTH_FLIP_BACK1//BG_PickAnim( BOTH_FLIP_BACK1, BOTH_FLIP_BACK3 );
                }
            }

            vertPush += 128 //give them an extra shove

            if anim != -1 {
                var fwd = JKAShared.vec3_t(0, 0, 0)
                var right = JKAShared.vec3_t(0, 0, 0)
                var traceto = JKAShared.vec3_t(0, 0, 0)
                var mins = JKAShared.vec3_t(0, 0, 0)
                var maxs = JKAShared.vec3_t(0, 0, 0)
                var fwdAngles = JKAShared.vec3_t(0, 0, 0)
                var idealNormal = JKAShared.vec3_t(0, 0, 0)
                var wallNormal = JKAShared.vec3_t(0, 0, 0)
                Trace.scratch { trace in
                    var doTrace = false
                    let contents = MASK_SOLID//MASK_PLAYERSOLID;

                    mins = JKAShared.vec3_t(pm.mins[0], pm.mins[1], 0)
                    maxs = JKAShared.vec3_t(pm.maxs[0], pm.maxs[1], 24)
                    fwdAngles = JKAShared.vec3_t(0, ps.viewangles[YAW], 0)

                    //to shut the compiler up
                    // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

                    // Raven passes NULL for the third output of `AngleVectors`. The ported function takes it by reference, so the body passes a scratch vector it never reads.
                    var scratchUp = JKAShared.vec3_t(0, 0, 0)
                    AngleVectors(fwdAngles, &fwd, &right, &scratchUp)

                    //trace-check for a wall, if necc.
                    switch anim {
                    case BOTH_WALL_FLIP_LEFT:
                        //NOTE: purposely falls through to next case!
                        fallthrough
                    case BOTH_WALL_RUN_LEFT:
                        doTrace = true
                        _VectorMA(ps.origin, -16, right, &traceto)

                    case BOTH_WALL_FLIP_RIGHT:
                        //NOTE: purposely falls through to next case!
                        fallthrough
                    case BOTH_WALL_RUN_RIGHT:
                        doTrace = true
                        _VectorMA(ps.origin, 16, right, &traceto)

                    case BOTH_WALL_FLIP_BACK1:
                        doTrace = true
                        _VectorMA(ps.origin, 16, fwd, &traceto)

                    default:
                        break
                    }

                    if doTrace {
                        pm.runTrace(trace, ps.origin, mins, maxs, traceto, ps.clientNum, contents)
                        wallNormal = trace.plane.normal
                        _ = VectorNormalize(&wallNormal)
                        _VectorSubtract(ps.origin, traceto, &idealNormal)
                        _ = VectorNormalize(&idealNormal)
                    }

                    // Port-note: `trace_t.entityNum` is Raven's `short`, which C promotes to `int` in this compare. Swift has no such promotion, so the body adds `Int32(...)`.
                    // C computes the dot-product compare in double, because 0.7 is a double literal.
                    if !doTrace || (trace.fraction < 1.0 && (Int32(trace.entityNum) < MAX_CLIENTS || Double(_DotProduct(wallNormal, idealNormal)) > 0.7)) {
                        //there is a wall there.. or hit a client
                        if (anim != BOTH_WALL_RUN_LEFT
                                && anim != BOTH_WALL_RUN_RIGHT
                                && anim != BOTH_FORCEWALLRUNFLIP_START)
                            || (wallNormal[2] >= 0.0 && wallNormal[2] <= 0.4/*MAX_WALL_RUN_Z_NORMAL*/) {
                            //wall-runs can only run on perfectly flat walls, sorry.
                            var parts: Int32
                            //move me to side
                            if anim == BOTH_WALL_FLIP_LEFT {
                                ps.velocity[0] = 0
                                ps.velocity[1] = 0
                                _VectorMA(ps.velocity, 150, right, &ps.velocity)
                            } else if anim == BOTH_WALL_FLIP_RIGHT {
                                ps.velocity[0] = 0
                                ps.velocity[1] = 0
                                _VectorMA(ps.velocity, -150, right, &ps.velocity)
                            } else if anim == BOTH_FLIP_BACK1
                                || anim == BOTH_FLIP_BACK2
                                || anim == BOTH_FLIP_BACK3
                                || anim == BOTH_WALL_FLIP_BACK1 {
                                ps.velocity[0] = 0
                                ps.velocity[1] = 0
                                _VectorMA(ps.velocity, -150, fwd, &ps.velocity)
                            }

                            /*
                            if ( doTrace && anim != BOTH_WALL_RUN_LEFT && anim != BOTH_WALL_RUN_RIGHT )
                            {
                                if (trace.entityNum < MAX_CLIENTS)
                                {
                                    pm->ps->forceKickFlip = trace.entityNum+1; //let the server know that this person gets kicked by this client
                                }
                            }
                            */

                            //up
                            if vertPush != 0 {
                                ps.velocity[2] = vertPush
                                ps.fd.forcePowersActive |= (1 << FP_LEVITATION)
                            }
                            //animate me
                            parts = SETANIM_LEGS
                            if anim == BOTH_BUTTERFLY_LEFT {
                                parts = SETANIM_BOTH
                                pm.cmd.buttons &= ~BUTTON_ATTACK
                                ps.saberMove = LS_NONE
                            } else if ps.weaponTime == 0 {
                                parts = SETANIM_BOTH
                            }
                            PM_SetAnim(parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                            if anim == BOTH_BUTTERFLY_LEFT {
                                ps.weaponTime = ps.torsoTimer
                            }
                            PM_SetForceJumpZStart(ps.origin[2])//so we don't take damage if we land at same height
                            ps.pm_flags |= PMF_JUMP_HELD
                            pm.cmd.upmove = 0
                            ps.fd.forceJumpSound = 1
                        }
                    }
                }
            }
        } else {
            //in the air
            let legsAnim = ps.legsAnim

            if legsAnim == BOTH_WALL_RUN_LEFT || legsAnim == BOTH_WALL_RUN_RIGHT {
                //running on a wall
                var right = JKAShared.vec3_t(0, 0, 0)
                var traceto = JKAShared.vec3_t(0, 0, 0)
                var mins = JKAShared.vec3_t(0, 0, 0)
                var maxs = JKAShared.vec3_t(0, 0, 0)
                var fwdAngles = JKAShared.vec3_t(0, 0, 0)
                var anim: Int32 = -1

                mins = JKAShared.vec3_t(pm.mins[0], pm.mins[0], 0)
                maxs = JKAShared.vec3_t(pm.maxs[0], pm.maxs[0], 24)
                fwdAngles = JKAShared.vec3_t(0, ps.viewangles[YAW], 0)

                // Raven passes NULL for the first and third outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
                var scratchForward = JKAShared.vec3_t(0, 0, 0)
                var scratchUp = JKAShared.vec3_t(0, 0, 0)
                AngleVectors(fwdAngles, &scratchForward, &right, &scratchUp)

                if legsAnim == BOTH_WALL_RUN_LEFT {
                    if ps.legsTimer > 400 {
                        //not at the end of the anim
                        let animLen = Float(PM_AnimLength(0, BOTH_WALL_RUN_LEFT))
                        if ps.legsTimer < animLen - 400 {
                            //not at start of anim
                            _VectorMA(ps.origin, -16, right, &traceto)
                            anim = BOTH_WALL_RUN_LEFT_FLIP
                        }
                    }
                } else if legsAnim == BOTH_WALL_RUN_RIGHT {
                    if ps.legsTimer > 400 {
                        //not at the end of the anim
                        let animLen = Float(PM_AnimLength(0, BOTH_WALL_RUN_RIGHT))
                        if ps.legsTimer < animLen - 400 {
                            //not at start of anim
                            _VectorMA(ps.origin, 16, right, &traceto)
                            anim = BOTH_WALL_RUN_RIGHT_FLIP
                        }
                    }
                }
                if anim != -1 {
                    Trace.scratch { trace in
                        pm.runTrace(trace, ps.origin, mins, maxs, traceto, ps.clientNum, CONTENTS_SOLID | CONTENTS_BODY)
                        if trace.fraction < 1.0 {
                            //flip off wall
                            var parts: Int32 = 0

                            if anim == BOTH_WALL_RUN_LEFT_FLIP {
                                ps.velocity[0] *= 0.5
                                ps.velocity[1] *= 0.5
                                _VectorMA(ps.velocity, 150, right, &ps.velocity)
                            } else if anim == BOTH_WALL_RUN_RIGHT_FLIP {
                                ps.velocity[0] *= 0.5
                                ps.velocity[1] *= 0.5
                                _VectorMA(ps.velocity, -150, right, &ps.velocity)
                            }
                            parts = SETANIM_LEGS
                            if ps.weaponTime == 0 {
                                parts = SETANIM_BOTH
                            }
                            PM_SetAnim(parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                            pm.cmd.upmove = 0
                        }
                    }
                }
                if pm.cmd.upmove != 0 {
                    //jump failed, so don't try to do normal jump code, just return
                    return false
                }
            }
            //NEW JKA
            else if ps.legsAnim == BOTH_FORCEWALLRUNFLIP_START {
                var fwd = JKAShared.vec3_t(0, 0, 0)
                var traceto = JKAShared.vec3_t(0, 0, 0)
                var mins = JKAShared.vec3_t(0, 0, 0)
                var maxs = JKAShared.vec3_t(0, 0, 0)
                var fwdAngles = JKAShared.vec3_t(0, 0, 0)
                var anim: Int32 = -1
                var animLen: Float

                mins = JKAShared.vec3_t(pm.mins[0], pm.mins[0], 0.0)
                maxs = JKAShared.vec3_t(pm.maxs[0], pm.maxs[0], 24.0)
                //hmm, did you mean [1] and [1]?
                fwdAngles = JKAShared.vec3_t(0, ps.viewangles[YAW], 0.0)
                // Raven passes NULL for the last two outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
                var scratchRight = JKAShared.vec3_t(0, 0, 0)
                var scratchUp = JKAShared.vec3_t(0, 0, 0)
                AngleVectors(fwdAngles, &fwd, &scratchRight, &scratchUp)

                assert(pm_entSelf != nil) //null pm_entSelf would be a Bad Thing<tm>
                // Port-note: Raven reads `pm_entSelf` right after his assert. The generated view is optional, so the body binds it, and the nil path leaves `anim` at -1.
                if let pm_entSelf = pm_entSelf {
                    animLen = Float(BG_AnimLength(pm_entSelf.localAnimIndex, BOTH_FORCEWALLRUNFLIP_START))
                    if ps.legsTimer < animLen - 400 {
                        //not at start of anim
                        _VectorMA(ps.origin, 16, fwd, &traceto)
                        anim = BOTH_FORCEWALLRUNFLIP_END
                    }
                }
                if anim != -1 {
                    Trace.scratch { trace in
                        pm.runTrace(trace, ps.origin, mins, maxs, traceto, ps.clientNum, CONTENTS_SOLID | CONTENTS_BODY)
                        if trace.fraction < 1.0 {
                            //flip off wall
                            var parts = SETANIM_LEGS

                            ps.velocity[0] *= 0.5
                            ps.velocity[1] *= 0.5
                            _VectorMA(ps.velocity, -300, fwd, &ps.velocity)
                            ps.velocity[2] += 200
                            if ps.weaponTime == 0 {
                                //not attacking, set anim on both
                                parts = SETANIM_BOTH
                            }
                            PM_SetAnim(parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                            //FIXME: do damage to traceEnt, like above?
                            //pm->ps->pm_flags |= PMF_JUMPING|PMF_SLOW_MO_FALL;
                            //ha ha, so silly with your silly jumpy fally flags.
                            pm.cmd.upmove = 0
                            PM_AddEvent(EV_JUMP)
                        }
                    }
                }
                if pm.cmd.upmove != 0 {
                    //jump failed, so don't try to do normal jump code, just return
                    return false
                }
            }
            /*
            else if ( pm->cmd.forwardmove > 0 //pushing forward
                && pm->ps->fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_1
                && pm->ps->velocity[2] > 200
                && PM_GroundDistance() <= 80 //unfortunately we do not have a happy ground timer like SP (this would use up more bandwidth if we wanted prediction workign right), so we'll just use the actual ground distance.
                && !BG_InSpecialJump(pm->ps->legsAnim))
            {//run up wall, flip backwards
                vec3_t fwd, traceto, mins, maxs, fwdAngles;
                trace_t	trace;
                vec3_t	idealNormal;

                VectorSet(mins, pm->mins[0],pm->mins[1],pm->mins[2]);
                VectorSet(maxs, pm->maxs[0],pm->maxs[1],pm->maxs[2]);
                VectorSet(fwdAngles, 0, pm->ps->viewangles[YAW], 0);

                AngleVectors( fwdAngles, fwd, NULL, NULL );
                VectorMA( pm->ps->origin, 32, fwd, traceto );

                pm->trace( &trace, pm->ps->origin, mins, maxs, traceto, pm->ps->clientNum, MASK_PLAYERSOLID );//FIXME: clip brushes too?
                VectorSubtract( pm->ps->origin, traceto, idealNormal );
                VectorNormalize( idealNormal );

                if ( trace.fraction < 1.0f )
                {//there is a wall there
                    int parts = SETANIM_LEGS;

                    pm->ps->velocity[0] = pm->ps->velocity[1] = 0;
                    VectorMA( pm->ps->velocity, -150, fwd, pm->ps->velocity );
                    pm->ps->velocity[2] += 128;

                    if ( !pm->ps->weaponTime )
                    {
                        parts = SETANIM_BOTH;
                    }
                    PM_SetAnim( parts, BOTH_WALL_FLIP_BACK1, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD, 0 );

                    pm->ps->legsTimer -= 600; //I force this anim to play to the end to prevent landing on your head and suddenly flipping over.
                                              //It is a bit too long at the end though, so I'll just shorten it.

                    PM_SetForceJumpZStart(pm->ps->origin[2]);//so we don't take damage if we land at same height
                    pm->cmd.upmove = 0;
                    pm->ps->fd.forceJumpSound = 1;
                    BG_ForcePowerDrain( pm->ps, FP_LEVITATION, 5 );

                    if (trace.entityNum < MAX_CLIENTS)
                    {
                        pm->ps->forceKickFlip = trace.entityNum+1; //let the server know that this person gets kicked by this client
                    }
                }
            }
            */
            else if pm.cmd.forwardmove > 0 //pushing forward
                && ps.fd.forceRageRecoveryTime < pm.cmd.serverTime	//not in a force Rage recovery period
                && ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_1
                && PM_WalkableGroundDistance() <= 80 //unfortunately we do not have a happy ground timer like SP (this would use up more bandwidth if we wanted prediction workign right), so we'll just use the actual ground distance.
                && (ps.legsAnim == BOTH_JUMP1 || ps.legsAnim == BOTH_INAIR1) {//not in a flip or spin or anything
                //run up wall, flip backwards
                if allowWallRuns {
                    //FIXME: have to be moving... make sure it's opposite the wall... or at least forward?
                    var wallWalkAnim = BOTH_WALL_FLIP_BACK1
                    var parts = SETANIM_LEGS
                    let contents = MASK_SOLID//MASK_PLAYERSOLID;//CONTENTS_SOLID;
                    //qboolean kick = qtrue;
                    if ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_2 {
                        wallWalkAnim = BOTH_FORCEWALLRUNFLIP_START
                        parts = SETANIM_BOTH
                        //kick = qfalse;
                    } else {
                        if ps.weaponTime == 0 {
                            parts = SETANIM_BOTH
                        }
                    }
                    //if ( PM_HasAnimation( pm->gent, wallWalkAnim ) )
                    if true {
                        //sure, we have it! Because I SAID SO.
                        var fwd = JKAShared.vec3_t(0, 0, 0)
                        var traceto = JKAShared.vec3_t(0, 0, 0)
                        var mins = JKAShared.vec3_t(0, 0, 0)
                        var maxs = JKAShared.vec3_t(0, 0, 0)
                        var fwdAngles = JKAShared.vec3_t(0, 0, 0)
                        var idealNormal = JKAShared.vec3_t(0, 0, 0)
                        var traceEnt: JKAMP.BgEntity? = nil
                        Trace.scratch { trace in
                            mins = JKAShared.vec3_t(pm.mins[0], pm.mins[1], 0.0)
                            maxs = JKAShared.vec3_t(pm.maxs[0], pm.maxs[1], 24.0)
                            fwdAngles = JKAShared.vec3_t(0, ps.viewangles[YAW], 0.0)

                            // Raven passes NULL for the last two outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
                            var scratchRight = JKAShared.vec3_t(0, 0, 0)
                            var scratchUp = JKAShared.vec3_t(0, 0, 0)
                            AngleVectors(fwdAngles, &fwd, &scratchRight, &scratchUp)
                            _VectorMA(ps.origin, 32, fwd, &traceto)

                            pm.runTrace(trace, ps.origin, mins, maxs, traceto, ps.clientNum, contents)//FIXME: clip brushes too?
                            _VectorSubtract(ps.origin, traceto, &idealNormal)
                            _ = VectorNormalize(&idealNormal)
                            // Port-note: `trace_t.entityNum` is Raven's `short`, which C promotes to `int` at this call. Swift has no such promotion, so the body adds `Int32(...)`.
                            traceEnt = PM_BGEntForNum(Int32(trace.entityNum))

                            // Port-note: Raven tests `traceEnt` inside one `&&` chain. The generated view is optional, so the body binds it into a flag first.
                            var hitPushableEnt = false
                            if Int32(trace.entityNum) < ENTITYNUM_WORLD,
                                let traceEnt,
                                traceEnt.s.solid != SOLID_BMODEL {
                                hitPushableEnt = true
                            }
                            // C computes the dot-product compare in double, because 0.7 is a double literal.
                            if trace.fraction < 1.0
                                && (hitPushableEnt || Double(_DotProduct(trace.plane.normal, idealNormal)) > 0.7) {
                                //there is a wall there
                                ps.velocity[0] = 0
                                ps.velocity[1] = 0
                                if wallWalkAnim == BOTH_FORCEWALLRUNFLIP_START {
                                    ps.velocity[2] = forceJumpStrength[FORCE_LEVEL_3] / 2.0
                                } else {
                                    _VectorMA(ps.velocity, -150, fwd, &ps.velocity)
                                    ps.velocity[2] += 150.0
                                }
                                //animate me
                                PM_SetAnim(parts, wallWalkAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
    //						pm->ps->pm_flags |= PMF_JUMPING|PMF_SLOW_MO_FALL;
                                //again with the flags!
                                //G_SoundOnEnt( pm->gent, CHAN_BODY, "sound/weapons/force/jump.wav" );
                                //yucky!
                                PM_SetForceJumpZStart(ps.origin[2])//so we don't take damage if we land at same height
                                pm.cmd.upmove = 0
                                ps.fd.forceJumpSound = 1
                                BG_ForcePowerDrain(ps, FP_LEVITATION, 5)

                                //kick if jumping off an ent
                                /*
                                if ( kick && traceEnt && (traceEnt->s.eType == ET_PLAYER || traceEnt->s.eType == ET_NPC) )
                                { //kick that thang!
                                    pm->ps->forceKickFlip = traceEnt->s.number+1;
                                }
                                */
                                pm.cmd.forwardmove = 0
                                pm.cmd.rightmove = 0
                            }
                        }
                        _ = traceEnt
                    }
                }
            } else if (!BG_InSpecialJump(legsAnim)//not in a special jump anim
                        || BG_InReboundJump(legsAnim)//we're already in a rebound
                        || BG_InBackFlip(legsAnim))//a backflip (needed so you can jump off a wall behind you)
                    //&& pm->ps->velocity[2] <= 0
                    && ps.velocity[2] > -1200 //not falling down very fast
                    && (ps.pm_flags & PMF_JUMP_HELD) == 0//have to have released jump since last press
                    && (pm.cmd.forwardmove != 0 || pm.cmd.rightmove != 0)//pushing in a direction
                    //&& pm->ps->forceRageRecoveryTime < pm->cmd.serverTime	//not in a force Rage recovery period
                    && ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_2//level 3 jump or better
                    //&& WP_ForcePowerAvailable( pm->gent, FP_LEVITATION, 10 )//have enough force power to do another one
                    && BG_CanUseFPNow(pm.gametype, ps, pm.cmd.serverTime, FP_LEVITATION)
                    && (ps.origin[2] - ps.fd.forceJumpZStart) < (forceJumpHeightMax[FORCE_LEVEL_3] - (BG_ForceWallJumpStrength() / 2.0)) //can fit at least one more wall jump in (yes, using "magic numbers"... for now)
                    //&& (pm->ps->legsAnim == BOTH_JUMP1 || pm->ps->legsAnim == BOTH_INAIR1 ) )//not in a flip or spin or anything
                    {
                //see if we're pushing at a wall and jump off it if so
                if allowWallGrabs {
                    //FIXME: make sure we have enough force power
                    //FIXME: check  to see if we can go any higher
                    //FIXME: limit to a certain number of these in a row?
                    //FIXME: maybe don't require a ucmd direction, just check all 4?
                    //FIXME: should stick to the wall for a second, then push off...
                    var checkDir = JKAShared.vec3_t(0, 0, 0)
                    var traceto = JKAShared.vec3_t(0, 0, 0)
                    var mins = JKAShared.vec3_t(0, 0, 0)
                    var maxs = JKAShared.vec3_t(0, 0, 0)
                    var fwdAngles = JKAShared.vec3_t(0, 0, 0)
                    var idealNormal = JKAShared.vec3_t(0, 0, 0)
                    var anim: Int32 = -1

                    mins = JKAShared.vec3_t(pm.mins[0], pm.mins[1], 0.0)
                    maxs = JKAShared.vec3_t(pm.maxs[0], pm.maxs[1], 24.0)
                    fwdAngles = JKAShared.vec3_t(0, ps.viewangles[YAW], 0.0)

                    // Raven passes NULL for two of the three outputs of `AngleVectors` at each call below. The ported function takes them by reference, so the body passes scratch vectors it never reads.
                    var scratchForward = JKAShared.vec3_t(0, 0, 0)
                    var scratchRight = JKAShared.vec3_t(0, 0, 0)
                    var scratchUp = JKAShared.vec3_t(0, 0, 0)
                    if pm.cmd.rightmove != 0 {
                        if pm.cmd.rightmove > 0 {
                            anim = BOTH_FORCEWALLREBOUND_RIGHT
                            AngleVectors(fwdAngles, &scratchForward, &checkDir, &scratchUp)
                        } else if pm.cmd.rightmove < 0 {
                            anim = BOTH_FORCEWALLREBOUND_LEFT
                            AngleVectors(fwdAngles, &scratchForward, &checkDir, &scratchUp)
                            _VectorScale(checkDir, -1, &checkDir)
                        }
                    } else if pm.cmd.forwardmove > 0 {
                        anim = BOTH_FORCEWALLREBOUND_FORWARD
                        AngleVectors(fwdAngles, &checkDir, &scratchRight, &scratchUp)
                    } else if pm.cmd.forwardmove < 0 {
                        anim = BOTH_FORCEWALLREBOUND_BACK
                        AngleVectors(fwdAngles, &checkDir, &scratchRight, &scratchUp)
                        _VectorScale(checkDir, -1, &checkDir)
                    }
                    if anim != -1 {
                        //trace in the dir we're pushing in and see if there's a vertical wall there
                        var traceEnt: JKAMP.BgEntity? = nil

                        Trace.scratch { trace in
                            _VectorMA(ps.origin, 8, checkDir, &traceto)
                            pm.runTrace(trace, ps.origin, mins, maxs, traceto, ps.clientNum, CONTENTS_SOLID)//FIXME: clip brushes too?
                            _VectorSubtract(ps.origin, traceto, &idealNormal)
                            _ = VectorNormalize(&idealNormal)
                            // Port-note: `trace_t.entityNum` is Raven's `short`, which C promotes to `int` at this call. Swift has no such promotion, so the body adds `Int32(...)`.
                            traceEnt = PM_BGEntForNum(Int32(trace.entityNum))
                            // Port-note: Raven tests `traceEnt` inside one `&&` chain. The generated view is optional, so the body binds it into a flag first.
                            var hitPushableEnt = false
                            if Int32(trace.entityNum) < ENTITYNUM_WORLD,
                                let traceEnt,
                                traceEnt.s.solid != SOLID_BMODEL {
                                hitPushableEnt = true
                            }
                            // C computes the dot-product compare in double, because 0.7 is a double literal.
                            if trace.fraction < 1.0
                                && Q_fabs(trace.plane.normal[2]) <= 0.2/*MAX_WALL_GRAB_SLOPE*/
                                && (hitPushableEnt || Double(_DotProduct(trace.plane.normal, idealNormal)) > 0.7) {
                                //there is a wall there
                                let dot = _DotProduct(ps.velocity, trace.plane.normal)
                                if dot < 1.0 {
                                    //can't be heading *away* from the wall!
                                    //grab it!
                                    PM_GrabWallForJump(anim)
                                }
                            }
                        }
                        _ = traceEnt
                    }
                }
            } else {
                //FIXME: if in a butterfly, kick people away?
            }
            //END NEW JKA
        }
    }

    /*
    if ( pm->cmd.upmove > 0
        && (pm->ps->weapon == WP_SABER || pm->ps->weapon == WP_MELEE)
        && !PM_IsRocketTrooper()
        && (pm->ps->weaponTime > 0||pm->cmd.buttons&BUTTON_ATTACK) )
    {//okay, we just jumped and we're in an attack
        if ( !BG_InRoll( pm->ps, pm->ps->legsAnim )
            && !PM_InKnockDown( pm->ps )
            && !BG_InDeathAnim(pm->ps->legsAnim)
            && !BG_FlippingAnim( pm->ps->legsAnim )
            && !PM_SpinningAnim( pm->ps->legsAnim )
            && !BG_SaberInSpecialAttack( pm->ps->torsoAnim )
            && ( BG_SaberInAttack( pm->ps->saberMove ) ) )
        {//not in an anim we shouldn't interrupt
            //see if it's not too late to start a special jump-attack
            float animLength = PM_AnimLength( 0, (animNumber_t)pm->ps->torsoAnim );
            if ( animLength - pm->ps->torsoTimer < 500 )
            {//just started the saberMove
                //check for special-case jump attacks
                if ( pm->ps->fd.saberAnimLevel == FORCE_LEVEL_2 )
                {//using medium attacks
                    if (PM_GroundDistance() < 32 &&
                        !BG_InSpecialJump(pm->ps->legsAnim))
                    { //FLIP AND DOWNWARD ATTACK
                        //trace_t tr;

                        //if (PM_SomeoneInFront(&tr))
                        {
                            PM_SetSaberMove(PM_SaberFlipOverAttackMove());
                            pml.groundPlane = qfalse;
                            pml.walking = qfalse;
                            pm->ps->pm_flags |= PMF_JUMP_HELD;
                            pm->ps->groundEntityNum = ENTITYNUM_NONE;
                            VectorClear(pml.groundTrace.plane.normal);

                            pm->ps->weaponTime = pm->ps->torsoTimer;
                        }
                    }
                }
                else if ( pm->ps->fd.saberAnimLevel == FORCE_LEVEL_3 )
                {//using strong attacks
                    if ( pm->cmd.forwardmove > 0 && //going forward
                        (pm->cmd.buttons & BUTTON_ATTACK) && //must be holding attack still
                        PM_GroundDistance() < 32 &&
                        !BG_InSpecialJump(pm->ps->legsAnim))
                    {//strong attack: jump-hack
                        PM_SetSaberMove( PM_SaberJumpAttackMove() );
                        pml.groundPlane = qfalse;
                        pml.walking = qfalse;
                        pm->ps->pm_flags |= PMF_JUMP_HELD;
                        pm->ps->groundEntityNum = ENTITYNUM_NONE;
                        VectorClear(pml.groundTrace.plane.normal);

                        pm->ps->weaponTime = pm->ps->torsoTimer;
                    }
                }
            }
        }
    }
    */
    if ps.groundEntityNum == ENTITYNUM_NONE {
        return false
    }
    if pm.cmd.upmove > 0 {
        //no special jumps
        ps.velocity[2] = Float(JUMP_VELOCITY)
        PM_SetForceJumpZStart(ps.origin[2])//so we don't take damage if we land at same height
        ps.pm_flags |= PMF_JUMP_HELD
    }

    //Jumping
    bg.pml.groundPlane = false
    bg.pml.walking = false
    ps.pm_flags |= PMF_JUMP_HELD
    ps.groundEntityNum = ENTITYNUM_NONE
    PM_SetForceJumpZStart(ps.origin[2])

    PM_AddEvent(EV_JUMP)

    //Set the animations
    if ps.gravity > 0 && !BG_InSpecialJump(ps.legsAnim) {
        PM_JumpForDir()
    }

    return true
}

/**
```
=============
PM_CheckWaterJump
=============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:2781
private func PM_CheckWaterJump() -> Bool {
    var spot = JKAShared.vec3_t(0, 0, 0)
    var cont: Int32
    var flatforward = JKAShared.vec3_t(0, 0, 0)
    let ps = pm.ps
    if ps.pm_time != 0 {
        return false
    }

    // check for water jump
    if pm.waterlevel != 2 {
        return false
    }

    flatforward[0] = bg.pml.forward[0]
    flatforward[1] = bg.pml.forward[1]
    flatforward[2] = 0
    _ = VectorNormalize(&flatforward)

    _VectorMA(ps.origin, 30, flatforward, &spot)
    spot[2] += 4
    // Port-note: Raven calls `pm->pointcontents` with no guard. The generated call gives nil when the stored pointer is nil, so the body binds the result, and the nil path traps.
    let contBelow = pm.runPointcontents(spot, ps.clientNum)
    cont = contBelow
    if (cont & CONTENTS_SOLID) == 0 {
        return false
    }

    spot[2] += 16
    let contAbove = pm.runPointcontents(spot, ps.clientNum)
    cont = contAbove
    if cont != 0 {
        return false
    }

    // jump out of water
    ps.velocity = bg.pml.forward * 200
    ps.velocity[2] = 350

    ps.pm_flags |= PMF_TIME_WATERJUMP
    ps.pm_time = 2000

    return true
}

/**
```
===================
PM_WaterJumpMove

Flying out of the water
===================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:2833
private func PM_WaterJumpMove() {
    // waterjump has no control, but falls
    let ps = pm.ps
    PM_StepSlideMove(true)

    ps.velocity[2] -= ps.gravity * bg.pml.frametime
    if ps.velocity[2] < 0 {
        // cancel as soon as we are falling down again
        ps.pm_flags &= ~PMF_ALL_TIMES
        ps.pm_time = 0
    }
}

/**
```
===================
PM_WaterMove

===================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:2852
private func PM_WaterMove() {
    var i: Int32
    var wishvel = JKAShared.vec3_t(0, 0, 0)
    var wishspeed: Float
    var wishdir = JKAShared.vec3_t(0, 0, 0)
    let scale: Float
    let vel: Float
    let ps = pm.ps
    if PM_CheckWaterJump() {
        PM_WaterJumpMove()
        return
    }
    PM_Friction()

    scale = PM_CmdScale(pm.cmd)
    //
    // user intentions
    //
    if scale == 0 {
        wishvel[0] = 0
        wishvel[1] = 0
        wishvel[2] = -60 // sink towards bottom
    } else {
        i = 0
        while i < 3 {
            wishvel[i] = scale * bg.pml.forward[i] * Float(pm.cmd.forwardmove) + scale * bg.pml.right[i] * Float(pm.cmd.rightmove)
            i += 1
        }

        wishvel[2] += scale * Float(pm.cmd.upmove)
    }

    wishdir = wishvel
    wishspeed = VectorNormalize(&wishdir)

    if wishspeed > ps.speed * pm_swimScale {
        wishspeed = ps.speed * pm_swimScale
    }

    PM_Accelerate(&wishdir, wishspeed, pm_wateraccelerate)

    // make sure we can go up slopes easily under water
    if bg.pml.groundPlane && _DotProduct(ps.velocity, bg.pml.groundTrace.plane.normal) < 0 {
        vel = VectorLength(ps.velocity)
        // slide along the ground plane
        // Port-note: Raven passes `pm->ps->velocity` as both the input and the output of `PM_ClipVelocity`. Swift forbids two overlapping `inout` arguments, so the body uses locals and writes the result back.
        var clipIn = ps.velocity
        var clipNormal = bg.pml.groundTrace.plane.normal
        var clipOut = ps.velocity
        PM_ClipVelocity(&clipIn, &clipNormal, &clipOut, OVERCLIP)
        ps.velocity = clipOut

        _ = VectorNormalize(&ps.velocity)
        ps.velocity = ps.velocity * vel
    }

    _ = PM_SlideMove(false)
}

/**
```
===================
PM_FlyVehicleMove

===================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:2924
private func PM_FlyVehicleMove() {
    var i: Int32
    var wishvel = JKAShared.vec3_t(0, 0, 0)
    var wishspeed: Float
    var wishdir = JKAShared.vec3_t(0, 0, 0)
    let scale: Float
    let zVel: Float
    let fmove: Float = 0.0, smove: Float = 0.0
    let ps = pm.ps
    // We don't use these here because we pre-calculate the movedir in the vehicle update anyways, and if
    // you leave this, you get strange motion during boarding (the player can move the vehicle).
    //fmove = pm->cmd.forwardmove;
    //smove = pm->cmd.rightmove;

    // normal slowdown
    if ps.gravity != 0 && ps.velocity[2] < 0 && ps.groundEntityNum == ENTITYNUM_NONE {
        //falling
        zVel = ps.velocity[2]
        PM_Friction()
        ps.velocity[2] = zVel
    } else {
        PM_Friction()
        if ps.velocity[2] < 0 && ps.groundEntityNum != ENTITYNUM_NONE {
            ps.velocity[2] = 0 // ignore slope movement
        }
    }

    scale = PM_CmdScale(pm.cmd)

    // Get The WishVel And WishSpeed
    //-------------------------------
    if ps.clientNum >= MAX_CLIENTS {
        //NPC

        // If The UCmds Were Set, But Never Converted Into A MoveDir, Then Make The WishDir From UCmds
        //--------------------------------------------------------------------------------------------
        if (fmove != 0.0 || smove != 0.0) && VectorCompare(ps.moveDir, vec3_origin) != 0 {
            //gi.Printf("Generating MoveDir\n");
            i = 0
            while i < 3 {
                wishvel[i] = bg.pml.forward[i] * fmove + bg.pml.right[i] * smove
                i += 1
            }

            wishdir = wishvel
            wishspeed = VectorNormalize(&wishdir)
            wishspeed *= scale
        }
        // Otherwise, Use The Move Dir
        //-----------------------------
        else {
            wishspeed = ps.speed
            wishvel = ps.moveDir * ps.speed
            wishdir = ps.moveDir
        }
    } else {
        i = 0
        while i < 3 {
            wishvel[i] = bg.pml.forward[i] * fmove + bg.pml.right[i] * smove
            i += 1
        }
        // when going up or down slopes the wish velocity should Not be zero
    //	wishvel[2] = 0;

        wishdir = wishvel
        wishspeed = VectorNormalize(&wishdir)
        wishspeed *= scale
    }

    // Handle negative speed.
    if wishspeed < 0 {
        wishspeed = wishspeed * -1.0
        wishvel = wishvel * -1.0
        wishdir = wishdir * -1.0
    }

    wishdir = wishvel
    wishspeed = VectorNormalize(&wishdir)

    PM_Accelerate(&wishdir, wishspeed, 100)

    PM_StepSlideMove(true)
}

/**
```
===================
PM_FlyMove

Only with the flight powerup
===================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:3021
private func PM_FlyMove() {
    var i: Int32
    var wishvel = JKAShared.vec3_t(0, 0, 0)
    var wishspeed: Float
    var wishdir = JKAShared.vec3_t(0, 0, 0)
    var scale: Float
    let ps = pm.ps
    // normal slowdown
    PM_Friction()

    scale = PM_CmdScale(pm.cmd)

    if ps.pm_type == PM_SPECTATOR && (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 {
        //turbo boost
        scale *= 10
    }

    //
    // user intentions
    //
    if scale == 0 {
        wishvel[0] = 0
        wishvel[1] = 0
        wishvel[2] = ps.speed * (Float(pm.cmd.upmove) / 127.0)
    } else {
        i = 0
        while i < 3 {
            wishvel[i] = scale * bg.pml.forward[i] * Float(pm.cmd.forwardmove) + scale * bg.pml.right[i] * Float(pm.cmd.rightmove)
            i += 1
        }

        wishvel[2] += scale * Float(pm.cmd.upmove)
    }

    wishdir = wishvel
    wishspeed = VectorNormalize(&wishdir)

    PM_Accelerate(&wishdir, wishspeed, pm_flyaccelerate)

    PM_StepSlideMove(false)
}

/**
```
===================
PM_AirMove

===================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:3068
private func PM_AirMove() {
    var i: Int32
    var wishvel = JKAShared.vec3_t(0, 0, 0)
    let fmove: Float, smove: Float
    var wishdir = JKAShared.vec3_t(0, 0, 0)
    var wishspeed: Float
    var scale: Float
    var accelerate: Float
    var pVeh: JKAMP.Vehicle? = nil
    let ps = pm.ps
    if ps.clientNum >= MAX_CLIENTS {
        let pEnt: JKAMP.BgEntity? = pm_entSelf

        if let pEnt, pEnt.s.NPC_class == CLASS_VEHICLE {
            pVeh = pEnt.m_pVehicle
        }
    }

    if ps.pm_type != PM_SPECTATOR {
        _ = PM_CheckJump()
    }
    PM_Friction()

    fmove = Float(pm.cmd.forwardmove)
    smove = Float(pm.cmd.rightmove)

    scale = Usercmd.scratch(copying: pm.cmd) { cmd in
        PM_CmdScale(cmd)
    }

    // set the movementDir so clients can rotate the legs for strafing
    PM_SetMovementDir()

    // project moves down to flat plane
    bg.pml.forward[2] = 0
    bg.pml.right[2] = 0
    _ = VectorNormalize(&bg.pml.forward)
    _ = VectorNormalize(&bg.pml.right)

    // Port-note: Raven walks `pVeh->m_pVehicleInfo` with no guard. The generated field is optional, so the body binds it here and at the acceleration test below.
    if let m_pVehicleInfo = pVeh?.m_pVehicleInfo, m_pVehicleInfo.hoverHeight > 0 {
        //in a hovering vehicle, have air control
        if true {
            wishspeed = ps.speed
            wishvel = ps.moveDir * ps.speed
            wishdir = ps.moveDir
            scale = 1.0
        }
    } else if gPMDoSlowFall {
        //no air-control
        wishvel = JKAShared.vec3_t(0, 0, 0)
    } else if ps.pm_type == PM_JETPACK {
        //reduced air control while not jetting
        i = 0
        while i < 2 {
            wishvel[i] = bg.pml.forward[i] * fmove + bg.pml.right[i] * smove
            i += 1
        }
        wishvel[2] = 0

        if pm.cmd.upmove <= 0 {
            wishvel = wishvel * 0.8
        } else {
            //if we are jetting then we have more control than usual
            wishvel = wishvel * 2.0
        }
    } else {
        i = 0
        while i < 2 {
            wishvel[i] = bg.pml.forward[i] * fmove + bg.pml.right[i] * smove
            i += 1
        }
        wishvel[2] = 0
    }

    wishdir = wishvel
    wishspeed = VectorNormalize(&wishdir)
    wishspeed *= scale

    accelerate = pm_airaccelerate
    if let m_pVehicleInfo = pVeh?.m_pVehicleInfo, m_pVehicleInfo.type == VH_SPEEDER {
        //speeders have more control in air
        //in mid-air
        accelerate = m_pVehicleInfo.traction
        if bg.pml.groundPlane {
            //on a slope of some kind, shouldn't have much control and should slide a lot
            accelerate *= 0.5
        }
    }
    // not on ground, so little effect on velocity
    PM_Accelerate(&wishdir, wishspeed, accelerate)

    // we may have a ground plane that is very steep, even
    // though we don't have a groundentity
    // slide along the steep plane
    if bg.pml.groundPlane {
        if (ps.pm_flags & PMF_STUCK_TO_WALL) == 0 {
            //don't slide when stuck to a wall
            if PM_GroundSlideOkay(bg.pml.groundTrace.plane.normal[2]) {
                // Port-note: Raven passes `pm->ps->velocity` as both the input and the output of `PM_ClipVelocity`. Swift forbids two overlapping `inout` arguments, so the body uses locals and writes the result back.
                var clipIn = ps.velocity
                var clipNormal = bg.pml.groundTrace.plane.normal
                var clipOut = ps.velocity
                PM_ClipVelocity(&clipIn, &clipNormal, &clipOut, OVERCLIP)
                ps.velocity = clipOut
            }
        }
    }

    if (ps.pm_flags & PMF_STUCK_TO_WALL) != 0 {
        //no grav when stuck to wall
        PM_StepSlideMove(false)
    } else {
        PM_StepSlideMove(true)
    }
}

/**
```
===================
PM_WalkMove

===================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:3305
private func PM_WalkMove() {
    var i: Int32
    var wishvel = JKAShared.vec3_t(0, 0, 0)
    let fmove: Float, smove: Float
    var wishdir = JKAShared.vec3_t(0, 0, 0)
    var wishspeed: Float = 0.0
    let scale: Float
    var accelerate: Float
    let vel: Float
    var npcMovement = false
    let ps = pm.ps
    if pm.waterlevel > 2 && _DotProduct(bg.pml.forward, bg.pml.groundTrace.plane.normal) > 0 {
        // begin swimming
        PM_WaterMove()
        return
    }

    if ps.pm_type != PM_SPECTATOR {
        if PM_CheckJump() {
            // jumped away
            if pm.waterlevel > 1 {
                PM_WaterMove()
            } else {
                PM_AirMove()
            }
            return
        }
    }

    PM_Friction()

    fmove = Float(pm.cmd.forwardmove)
    smove = Float(pm.cmd.rightmove)

    scale = Usercmd.scratch(copying: pm.cmd) { cmd in
        PM_CmdScale(cmd)
    }

    // set the movementDir so clients can rotate the legs for strafing
    PM_SetMovementDir()

    // project moves down to flat plane
    bg.pml.forward[2] = 0
    bg.pml.right[2] = 0

    // project the forward and right directions onto the ground plane
    // Port-note: Raven passes one vector as both the input and the output of `PM_ClipVelocity`. Swift forbids two overlapping `inout` arguments, so the body uses locals and writes the result back.
    var clipForwardIn = bg.pml.forward
    var clipGroundNormal = bg.pml.groundTrace.plane.normal
    var clipForwardOut = bg.pml.forward
    PM_ClipVelocity(&clipForwardIn, &clipGroundNormal, &clipForwardOut, OVERCLIP)
    bg.pml.forward = clipForwardOut
    var clipRightIn = bg.pml.right
    var clipRightOut = bg.pml.right
    PM_ClipVelocity(&clipRightIn, &clipGroundNormal, &clipRightOut, OVERCLIP)
    bg.pml.right = clipRightOut
    //
    _ = VectorNormalize(&bg.pml.forward)
    _ = VectorNormalize(&bg.pml.right)

    // Get The WishVel And WishSpeed
    //-------------------------------
    if ps.clientNum >= MAX_CLIENTS && VectorCompare(ps.moveDir, vec3_origin) == 0 {
        //NPC
        let pEnt: JKAMP.BgEntity? = pm_entSelf

        if let pEnt, pEnt.s.NPC_class == CLASS_VEHICLE {
            // If The UCmds Were Set, But Never Converted Into A MoveDir, Then Make The WishDir From UCmds
            //--------------------------------------------------------------------------------------------
            if (fmove != 0.0 || smove != 0.0) && VectorCompare(ps.moveDir, vec3_origin) != 0 {
                //gi.Printf("Generating MoveDir\n");
                i = 0
                while i < 3 {
                    wishvel[i] = bg.pml.forward[i] * fmove + bg.pml.right[i] * smove
                    i += 1
                }

                wishdir = wishvel
                wishspeed = VectorNormalize(&wishdir)
                wishspeed *= scale
            }
            // Otherwise, Use The Move Dir
            //-----------------------------
            else {
                //wishspeed = pm->ps->speed;
                wishvel = ps.moveDir * ps.speed
                wishdir = wishvel
                wishspeed = VectorNormalize(&wishdir)
            }

            npcMovement = true
        }
    }

    if !npcMovement {
        i = 0
        while i < 3 {
            wishvel[i] = bg.pml.forward[i] * fmove + bg.pml.right[i] * smove
            i += 1
        }
        // when going up or down slopes the wish velocity should Not be zero

        wishdir = wishvel
        wishspeed = VectorNormalize(&wishdir)
        wishspeed *= scale
    }

    // clamp the speed lower if ducking
    if (ps.pm_flags & PMF_DUCKED) != 0 {
        if wishspeed > ps.speed * pm_duckScale {
            wishspeed = ps.speed * pm_duckScale
        }
    } else if (ps.pm_flags & PMF_ROLLING) != 0 && !BG_InRoll(ps, ps.legsAnim)
        && !PM_InRollComplete(ps, ps.legsAnim) {
        if wishspeed > ps.speed * pm_duckScale {
            wishspeed = ps.speed * pm_duckScale
        }
    }

    // clamp the speed lower if wading or walking on the bottom
    if pm.waterlevel != 0 {
        var waterScale: Float

        // C works these two lines in double, because 3.0, 1.0, and 1.0 are double literals.
        waterScale = Float(Double(pm.waterlevel) / 3.0)
        waterScale = Float(1.0 - (1.0 - Double(pm_swimScale)) * Double(waterScale))
        if wishspeed > ps.speed * waterScale {
            wishspeed = ps.speed * waterScale
        }
    }

    // when a player gets hit, they temporarily lose
    // full control, which allows them to be moved a bit
    if pm_flying == FLY_HOVER {
        accelerate = pm_vehicleaccelerate
    } else if (bg.pml.groundTrace.surfaceFlags & SURF_SLICK) != 0 || (ps.pm_flags & PMF_TIME_KNOCKBACK) != 0 {
        accelerate = pm_airaccelerate
    } else {
        accelerate = pm_accelerate
    }

    PM_Accelerate(&wishdir, wishspeed, accelerate)
    /*
    if (pm->ps->clientNum >= MAX_CLIENTS)
    {
#ifdef QAGAME
        Com_Printf("^1S: %f, %f\n", wishspeed, pm->ps->speed);
#else
        Com_Printf("^2C: %f, %f\n", wishspeed, pm->ps->speed);
#endif
    }
    */

    //Com_Printf("velocity = %1.1f %1.1f %1.1f\n", pm->ps->velocity[0], pm->ps->velocity[1], pm->ps->velocity[2]);
    //Com_Printf("velocity1 = %1.1f\n", VectorLength(pm->ps->velocity));

    if (bg.pml.groundTrace.surfaceFlags & SURF_SLICK) != 0 || (ps.pm_flags & PMF_TIME_KNOCKBACK) != 0 {
        ps.velocity[2] -= ps.gravity * bg.pml.frametime
    }

    vel = VectorLength(ps.velocity)

    // slide along the ground plane
    var clipVelIn = ps.velocity
    var clipVelOut = ps.velocity
    PM_ClipVelocity(&clipVelIn, &clipGroundNormal, &clipVelOut, OVERCLIP)
    ps.velocity = clipVelOut

    // don't decrease velocity when going up or down a slope
    _ = VectorNormalize(&ps.velocity)
    ps.velocity = ps.velocity * vel

    // don't do anything if standing still
    if ps.velocity[0] == 0 && ps.velocity[1] == 0 {
        return
    }

    PM_StepSlideMove(false)

    //Com_Printf("velocity2 = %1.1f\n", VectorLength(pm->ps->velocity));
}

/**
```
==============
PM_DeadMove
==============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:3492
private func PM_DeadMove() {
    var forward: Float
    let ps = pm.ps
    if !bg.pml.walking {
        return
    }

    // extra friction

    forward = VectorLength(ps.velocity)
    forward -= 20
    if forward <= 0 {
        ps.velocity = JKAShared.vec3_t(0, 0, 0)
    } else {
        _ = VectorNormalize(&ps.velocity)
        ps.velocity = ps.velocity * forward
    }
}

/**
```
===============
PM_NoclipMove
===============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:3517
private func PM_NoclipMove() {
    let speed: Float
    var drop: Float, friction: Float, control: Float, newspeed: Float
    var i: Int32
    var wishvel = JKAShared.vec3_t(0, 0, 0)
    let fmove: Float, smove: Float
    var wishdir = JKAShared.vec3_t(0, 0, 0)
    var wishspeed: Float
    var scale: Float
    let ps = pm.ps
    ps.viewheight = DEFAULT_VIEWHEIGHT

    // friction

    speed = VectorLength(ps.velocity)
    if speed < 1 {
        ps.velocity = vec3_origin
    } else {
        drop = 0

        // C works this line in double, because 1.5 is a double literal.
        friction = Float(Double(pm_friction) * 1.5) // extra friction
        control = speed < pm_stopspeed ? pm_stopspeed : speed
        drop += control * friction * bg.pml.frametime

        // scale the velocity
        newspeed = speed - drop
        if newspeed < 0 {
            newspeed = 0
        }
        newspeed /= speed

        ps.velocity = ps.velocity * newspeed
    }

    // accelerate
    scale = PM_CmdScale(pm.cmd)
    if (pm.cmd.buttons & BUTTON_ATTACK) != 0 { //turbo boost
        scale *= 10
    }
    if (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 { //turbo boost
        scale *= 10
    }

    fmove = Float(pm.cmd.forwardmove)
    smove = Float(pm.cmd.rightmove)

    i = 0
    while i < 3 {
        wishvel[i] = bg.pml.forward[i] * fmove + bg.pml.right[i] * smove
        i += 1
    }
    wishvel[2] += Float(pm.cmd.upmove)

    wishdir = wishvel
    wishspeed = VectorNormalize(&wishdir)
    wishspeed *= scale

    PM_Accelerate(&wishdir, wishspeed, pm_accelerate)

    // move
    // Port-note: Raven passes `pm->ps->origin` as both the first and the last argument of `VectorMA`. Swift forbids the overlapping `inout`, so the body uses a local and writes the result back.
    var newOrigin = ps.origin
    _VectorMA(ps.origin, bg.pml.frametime, ps.velocity, &newOrigin)
    ps.origin = newOrigin
}

/**
```
================
PM_FootstepForSurface

Returns an event number apropriate for the groundsurface
================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:3587
private func PM_FootstepForSurface() -> Int32 {
    if (bg.pml.groundTrace.surfaceFlags & SURF_NOSTEPS) != 0 {
        return 0
    }
    return (bg.pml.groundTrace.surfaceFlags & MATERIAL_MASK)
}

/// Source: oracle/codemp/game/bg_pmove.c:3597
private func PM_TryRoll() -> Int32 {
    var anim: Int32 = -1
    var fwd = JKAShared.vec3_t(0, 0, 0)
    var right = JKAShared.vec3_t(0, 0, 0)
    var traceto = JKAShared.vec3_t(0, 0, 0)
    var mins = JKAShared.vec3_t(0, 0, 0)
    var maxs = JKAShared.vec3_t(0, 0, 0)
    var fwdAngles = JKAShared.vec3_t(0, 0, 0)
    let ps = pm.ps

    if BG_SaberInAttack(ps.saberMove) || BG_SaberInSpecialAttack(ps.torsoAnim)
        || BG_SpinningSaberAnim(ps.legsAnim)
        || PM_SaberInStart(ps.saberMove) {
        //attacking or spinning (or, if player, starting an attack)
        if PM_CanRollFromSoulCal(ps) {
            //hehe
        } else {
            return 0
        }
    }

    if (ps.weapon != WP_SABER && ps.weapon != WP_MELEE)
        || PM_IsRocketTrooper()
        || BG_HasYsalamiri(pm.gametype, ps)
        || !BG_CanUseFPNow(pm.gametype, ps, pm.cmd.serverTime, FP_LEVITATION) {
        //Not using saber, or can't use jump
        return 0
    }

    if ps.weapon == WP_SABER {
        var saber = BG_MySaber(ps.clientNum, 0)
        if let saber,
            (saber.saberFlags & SFL_NO_ROLLS) != 0 {
            return 0
        }
        saber = BG_MySaber(ps.clientNum, 1)
        if let saber,
            (saber.saberFlags & SFL_NO_ROLLS) != 0 {
            return 0
        }
    }

    mins = JKAShared.vec3_t(pm.mins[0], pm.mins[1], pm.mins[2] + STEPSIZE)
    maxs = JKAShared.vec3_t(pm.maxs[0], pm.maxs[1], Float(ps.crouchheight))

    fwdAngles = JKAShared.vec3_t(0, ps.viewangles[YAW], 0)

    // Raven passes NULL for the third output of `AngleVectors`. The ported function takes it by reference, so the body passes a scratch vector it never reads.
    var scratchUp = JKAShared.vec3_t(0, 0, 0)
    AngleVectors(fwdAngles, &fwd, &right, &scratchUp)

    if pm.cmd.forwardmove != 0 {
        //check forward/backward rolls
        if (ps.pm_flags & PMF_BACKWARDS_RUN) != 0 {
            anim = BOTH_ROLL_B
            _VectorMA(ps.origin, -64, fwd, &traceto)
        } else {
            anim = BOTH_ROLL_F
            _VectorMA(ps.origin, 64, fwd, &traceto)
        }
    } else if pm.cmd.rightmove > 0 {
        //right
        anim = BOTH_ROLL_R
        _VectorMA(ps.origin, 64, right, &traceto)
    } else if pm.cmd.rightmove < 0 {
        //left
        anim = BOTH_ROLL_L
        _VectorMA(ps.origin, -64, right, &traceto)
    }

    if anim != -1 {
        //We want to roll. Perform a trace to see if we can, and if so, send us into one.
        let clear = JKAMP.Trace.scratch { trace in
            pm.runTrace(trace, ps.origin, mins, maxs, traceto, ps.clientNum, CONTENTS_SOLID)
            return trace.fraction >= 1.0
        }
        if clear {
            ps.saberMove = LS_NONE
            return anim
        }
    }
    return 0
}

/// Source: oracle/codemp/game/bg_pmove.c:3684
private func PM_CrashLandEffect() {
    // Port-note: Raven compiles this whole function only for the game module, under `#ifdef QAGAME`. Rule 23 gives no per-function form for that, so the body is here for every consumer, and its one call site takes the game arm.
    var delta: Float
    let ps = pm.ps
    if pm.waterlevel != 0 {
        return
    }
    delta = Q_fabs(bg.pml.previous_velocity[2]) / 10 //VectorLength( pml.previous_velocity );?
    if delta >= 30 {
        var bottom = JKAShared.vec3_t(0, 0, 0)
        var effectID: Int32 = -1
        let material = (bg.pml.groundTrace.surfaceFlags & MATERIAL_MASK)
        bottom = JKAShared.vec3_t(ps.origin[0], ps.origin[1], ps.origin[2] + pm.mins[2] + 1)
        switch material {
        case MATERIAL_MUD:
            effectID = EFFECT_LANDING_MUD

        case MATERIAL_SAND:
            effectID = EFFECT_LANDING_SAND

        case MATERIAL_DIRT:
            effectID = EFFECT_LANDING_DIRT

        case MATERIAL_SNOW:
            effectID = EFFECT_LANDING_SNOW

        case MATERIAL_GRAVEL:
            effectID = EFFECT_LANDING_GRAVEL

        default:
            break
        }

        if effectID != -1 {
            var groundNormal = bg.pml.groundTrace.plane.normal
            _ = G_PlayEffect(effectID, &bottom, &groundNormal)
        }
    }
}

/**
```
=================
PM_CrashLand

Check for hard landings that generate sound events
=================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:3731
private func PM_CrashLand() {
    var delta: Float
    let dist: Float
    let vel: Float, acc: Float
    let t: Float
    let a: Float, b: Float, c: Float, den: Float
    var didRoll = false
    let ps = pm.ps
    // calculate the exact velocity on landing
    dist = ps.origin[2] - bg.pml.previous_origin[2]
    vel = bg.pml.previous_velocity[2]
    acc = -Float(ps.gravity)

    a = acc / 2
    b = vel
    c = -dist

    den = b * b - 4 * a * c
    if den < 0 {
        ps.inAirAnim = false
        return
    }
    // C promotes this line to double, because `sqrt` takes and returns a double.
    t = Float((-Double(b) - sqrt(Double(den))) / Double(2 * a))

    delta = vel + t * acc
    // C promotes this line to double, because 0.0001 is a double literal.
    delta = Float(Double(delta * delta) * 0.0001)

    if bg.consumer == .game {
        PM_CrashLandEffect()
    } else {
    }
    // ducking while falling doubles damage
    if (ps.pm_flags & PMF_DUCKED) != 0 {
        delta *= 2
    }

    if ps.legsAnim == BOTH_A7_KICK_F_AIR
        || ps.legsAnim == BOTH_A7_KICK_B_AIR
        || ps.legsAnim == BOTH_A7_KICK_R_AIR
        || ps.legsAnim == BOTH_A7_KICK_L_AIR {
        var landAnim: Int32 = -1
        switch ps.legsAnim {
        case BOTH_A7_KICK_F_AIR:
            landAnim = BOTH_FORCELAND1

        case BOTH_A7_KICK_B_AIR:
            landAnim = BOTH_FORCELANDBACK1

        case BOTH_A7_KICK_R_AIR:
            landAnim = BOTH_FORCELANDRIGHT1

        case BOTH_A7_KICK_L_AIR:
            landAnim = BOTH_FORCELANDLEFT1

        default:
            break
        }
        if landAnim != -1 {
            if ps.torsoAnim == ps.legsAnim {
                PM_SetAnim(SETANIM_BOTH, landAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
            } else {
                PM_SetAnim(SETANIM_LEGS, landAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
            }
        }
    } else if ps.legsAnim == BOTH_FORCEJUMPLEFT1
        || ps.legsAnim == BOTH_FORCEJUMPRIGHT1
        || ps.legsAnim == BOTH_FORCEJUMPBACK1
        || ps.legsAnim == BOTH_FORCEJUMP1 {
        let fjAnim: Int32
        switch ps.legsAnim {
        case BOTH_FORCEJUMPLEFT1:
            fjAnim = BOTH_LANDLEFT1

        case BOTH_FORCEJUMPRIGHT1:
            fjAnim = BOTH_LANDRIGHT1

        case BOTH_FORCEJUMPBACK1:
            fjAnim = BOTH_LANDBACK1

        default:
            fjAnim = BOTH_LAND1
        }
        PM_SetAnim(SETANIM_BOTH, fjAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
    }
    // decide which landing animation to use
    else if !BG_InRoll(ps, ps.legsAnim) && ps.inAirAnim && ps.m_iVehicleNum == 0 {
        //only play a land animation if we transitioned into an in-air animation while off the ground
        if !BG_SaberInSpecial(ps.saberMove) {
            if (ps.pm_flags & PMF_BACKWARDS_JUMP) != 0 {
                PM_ForceLegsAnim(BOTH_LANDBACK1)
            } else {
                PM_ForceLegsAnim(BOTH_LAND1)
            }
        }
    }

    if ps.weapon != WP_SABER && ps.weapon != WP_MELEE && !PM_IsRocketTrooper() {
        //saber handles its own anims
        //This will push us back into our weaponready stance from the land anim.
        if ps.weapon == WP_DISRUPTOR && ps.zoomMode == 1 {
            PM_StartTorsoAnim(TORSO_WEAPONREADY4)
        } else {
            if ps.weapon == WP_EMPLACED_GUN {
                PM_StartTorsoAnim(BOTH_GUNSIT1)
            } else {
                // Port-note: `WeaponReadyAnim` is a file-scope table of `bg_misc.c`, and rule 3 puts it on `BgState`. The transcriptor of that file adds the property.
                PM_StartTorsoAnim(bg.WeaponReadyAnim[ps.weapon])
            }
        }
    }

    if !BG_InSpecialJump(ps.legsAnim)
        || ps.legsTimer < 1
        || (ps.legsAnim) == BOTH_WALL_RUN_LEFT
        || (ps.legsAnim) == BOTH_WALL_RUN_RIGHT {
        //Only set the timer if we're in an anim that can be interrupted (this would not be, say, a flip)
        if !BG_InRoll(ps, ps.legsAnim) && ps.inAirAnim {
            if !BG_SaberInSpecial(ps.saberMove) || ps.weapon != WP_SABER {
                if ps.legsAnim != BOTH_FORCELAND1
                    && ps.legsAnim != BOTH_FORCELANDBACK1
                    && ps.legsAnim != BOTH_FORCELANDRIGHT1
                    && ps.legsAnim != BOTH_FORCELANDLEFT1 {
                    //don't override if we have started a force land
                    ps.legsTimer = TIMER_LAND
                }
            }
        }
    }

    ps.inAirAnim = false

    if ps.m_iVehicleNum != 0 {
        //don't do fall stuff while on a vehicle
        return
    }

    // never take falling damage if completely underwater
    if pm.waterlevel == 3 {
        return
    }

    // reduce falling damage if there is standing water
    if pm.waterlevel == 2 {
        delta *= 0.25
    }
    if pm.waterlevel == 1 {
        delta *= 0.5
    }

    if delta < 1 {
        return
    }

    if (ps.pm_flags & PMF_DUCKED) != 0 {
        if delta >= 2 && !PM_InOnGroundAnim(ps.legsAnim) && !PM_InKnockDown(ps) && !BG_InRoll(ps, ps.legsAnim)
            && ps.forceHandExtend == HANDEXTEND_NONE {
            //roll!
            var anim = PM_TryRoll()

            if PM_InRollComplete(ps, ps.legsAnim) {
                anim = 0
                ps.legsTimer = 0
                ps.legsAnim = 0
                PM_SetAnim(SETANIM_BOTH, BOTH_LAND1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 150)
                ps.legsTimer = TIMER_LAND
            }

            if anim != 0 {
                //absorb some impact
                ps.legsTimer = 0
                delta /= 3 // /= 2 just cancels out the above delta *= 2 when landing while crouched, the roll itself should absorb a little damage
                ps.legsAnim = 0
                if ps.torsoAnim == BOTH_A7_SOULCAL {
                    //get out of it on torso
                    ps.torsoTimer = 0
                }
                PM_SetAnim(SETANIM_BOTH, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 150)
                didRoll = true
            }
        }
    }

    // SURF_NODAMAGE is used for bounce pads where you don't ever
    // want to take damage or play a crunch sound
    if (bg.pml.groundTrace.surfaceFlags & SURF_NODAMAGE) == 0 {
        if delta > 7 {
            var delta_send = Int32(delta)

            if delta_send > 600 {
                //will never need to know any value above this
                delta_send = 600
            }

            if ps.fd.forceJumpZStart != 0 {
                if Int32(ps.origin[2]) >= Int32(ps.fd.forceJumpZStart) {
                    //was force jumping, landed on higher or same level as when force jump was started
                    if delta_send > 8 {
                        delta_send = 8
                    }
                } else {
                    if delta_send > 8 {
                        let dif = (Int32(ps.fd.forceJumpZStart) - Int32(ps.origin[2]))
                        var dmgLess = Int32(forceJumpHeight[ps.fd.forcePowerLevel[FP_LEVITATION]] - dif)

                        if dmgLess < 0 {
                            dmgLess = 0
                        }

                        // C works the subtraction in double and truncates the result, because 0.3 is a double literal.
                        delta_send = Int32(Double(delta_send) - Double(dmgLess) * 0.3)

                        if delta_send < 8 {
                            delta_send = 8
                        }

                        //Com_Printf("Damage sub: %i\n", (int)((dmgLess*0.1)));
                    }
                }
            }

            if didRoll {
                //Add the appropriate event..
                PM_AddEventWithParm(EV_ROLL, delta_send)
            } else {
                PM_AddEventWithParm(EV_FALL, delta_send)
            }
        } else {
            if didRoll {
                PM_AddEventWithParm(EV_ROLL, 0)
            } else {
                PM_AddEventWithParm(EV_FOOTSTEP, PM_FootstepForSurface())
            }
        }
    }

    // make sure velocity resets so we don't bounce back up again in case we miss the clear elsewhere
    ps.velocity[2] = 0

    // start footstep cycle over
    ps.bobCycle = 0
}

/**
```
=============
PM_CorrectAllSolid
=============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:4009
private func PM_CorrectAllSolid(_ trace: JKAMP.Trace) -> Int32 {
    // Port-note: Raven copies the whole record with `pml.groundTrace = *trace`. The `Trace` view of `pml.groundTrace` is read-only, so the record copy has no Swift form.
    // TODO: Port PM_CorrectAllSolid
    portMissing("PM_CorrectAllSolid", source: "oracle/codemp/game/bg_pmove.c:4009")
}

/**
```
=============
PM_GroundTraceMissed

The ground trace didn't hit a surface, so we are in freefall
=============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:4053
private func PM_GroundTraceMissed() {
    var point = JKAShared.vec3_t(0, 0, 0)
    let ps = pm.ps

    //rww - don't want to do this when handextend_choke, because you can be standing on the ground
    //while still holding your throat.
    if ps.pm_type == PM_FLOAT {
        //we're assuming this is because you're being choked
        let parts = SETANIM_LEGS

        //rww - also don't use SETANIM_FLAG_HOLD, it will cause the legs to float around a bit before going into
        //a proper anim even when on the ground.
        PM_SetAnim(parts, BOTH_CHOKE3, SETANIM_FLAG_OVERRIDE, 100)
    } else if ps.pm_type == PM_JETPACK {
        //jetpacking
        //rww - also don't use SETANIM_FLAG_HOLD, it will cause the legs to float around a bit before going into
        //a proper anim even when on the ground.
        //PM_SetAnim(SETANIM_LEGS,BOTH_FORCEJUMP1,SETANIM_FLAG_OVERRIDE, 100);
    }
    //If the anim is choke3, act like we just went into the air because we aren't in a float
    else if ps.groundEntityNum != ENTITYNUM_NONE || (ps.legsAnim) == BOTH_CHOKE3 {
        // we just transitioned into freefall
        if pm.debugLevel != 0 {
            Com_Printf("%i:lift\n", c_pmove)
        }

        // if they aren't in a jumping animation and the ground is a ways away, force into it
        // if we didn't do the trace, the player would be backflipping down staircases
        point = ps.origin
        point[2] -= 64

        JKAMP.Trace.scratch { trace in
            pm.runTrace(trace, ps.origin, pm.mins, pm.maxs, point, ps.clientNum, pm.tracemask)
            if trace.fraction == 1.0 || ps.pm_type == PM_FLOAT {
                if ps.velocity[2] <= 0 && (ps.pm_flags & PMF_JUMP_HELD) == 0 {
                    //PM_SetAnim(SETANIM_LEGS,BOTH_INAIR1,SETANIM_FLAG_OVERRIDE, 100);
                    PM_SetAnim(SETANIM_LEGS, BOTH_INAIR1, 0, 100)
                    ps.pm_flags &= ~PMF_BACKWARDS_JUMP
                } else if pm.cmd.forwardmove >= 0 {
                    PM_SetAnim(SETANIM_LEGS, BOTH_JUMP1, SETANIM_FLAG_OVERRIDE, 100)
                    ps.pm_flags &= ~PMF_BACKWARDS_JUMP
                } else {
                    PM_SetAnim(SETANIM_LEGS, BOTH_JUMPBACK1, SETANIM_FLAG_OVERRIDE, 100)
                    ps.pm_flags |= PMF_BACKWARDS_JUMP
                }

                ps.inAirAnim = true
            }
        }
    } else if !ps.inAirAnim {
        // if they aren't in a jumping animation and the ground is a ways away, force into it
        // if we didn't do the trace, the player would be backflipping down staircases
        point = ps.origin
        point[2] -= 64

        JKAMP.Trace.scratch { trace in
            pm.runTrace(trace, ps.origin, pm.mins, pm.maxs, point, ps.clientNum, pm.tracemask)
            if trace.fraction == 1.0 || ps.pm_type == PM_FLOAT {
                ps.inAirAnim = true
            }
        }
    }

    if PM_InRollComplete(ps, ps.legsAnim) {
        //Client won't catch an animation restart because it only checks frame against incoming frame, so if you roll when you land after rolling
        //off of something it won't replay the roll anim unless we switch it off in the air. This fixes that.
        PM_SetAnim(SETANIM_BOTH, BOTH_INAIR1, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD, 150)
        ps.inAirAnim = true
    }

    ps.groundEntityNum = ENTITYNUM_NONE
    bg.pml.groundPlane = false
    bg.pml.walking = false
}

/**
```
=============
PM_GroundTrace
=============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:4141
private func PM_GroundTrace() {
    var point = JKAShared.vec3_t(0, 0, 0)
    var minNormal = Float(MIN_WALK_NORMAL)
    let ps = pm.ps

    if ps.clientNum >= MAX_CLIENTS {
        let pEnt = pm_entSelf

        // Port-note: Raven walks `pEnt->m_pVehicle->m_pVehicleInfo` with no guard. Both generated fields are optional, so the body binds both.
        if let pEnt, pEnt.s.NPC_class == CLASS_VEHICLE,
            let m_pVehicle = pEnt.m_pVehicle,
            let m_pVehicleInfo = m_pVehicle.m_pVehicleInfo {
            minNormal = m_pVehicleInfo.maxSlope
        }
    }

    point[0] = ps.origin[0]
    point[1] = ps.origin[1]
    // C promotes this difference to double, because 0.25 is a double literal.
    point[2] = Float(Double(ps.origin[2]) - 0.25)

    // Raven's record lives to the end of the function, so the rest of the body is the closure, and each of his early-outs returns from it.
    JKAMP.Trace.scratch { trace in
        pm.runTrace(trace, ps.origin, pm.mins, pm.maxs, point, ps.clientNum, pm.tracemask)
        // Port-note: Raven copies the whole record with `pml.groundTrace = trace`. The `Trace` view of `pml.groundTrace` is read-only, so the record copy has no Swift form.

        // do something corrective if the trace starts in a solid...
        if trace.allsolid != 0 {
            if PM_CorrectAllSolid(trace) == 0 {
                return
            }
        }

        if ps.pm_type == PM_FLOAT || ps.pm_type == PM_JETPACK {
            PM_GroundTraceMissed()
            bg.pml.groundPlane = false
            bg.pml.walking = false
            return
        }

        // if the trace didn't hit anything, we are in free fall
        if trace.fraction == 1.0 {
            PM_GroundTraceMissed()
            bg.pml.groundPlane = false
            bg.pml.walking = false
            return
        }

        // check if getting thrown off the ground
        if ps.velocity[2] > 0 && _DotProduct(ps.velocity, trace.plane.normal) > 10 {
            if pm.debugLevel != 0 {
                Com_Printf("%i:kickoff\n", c_pmove)
            }
            // go into jump animation
            if pm.cmd.forwardmove >= 0 {
                PM_ForceLegsAnim(BOTH_JUMP1)
                ps.pm_flags &= ~PMF_BACKWARDS_JUMP
            } else {
                PM_ForceLegsAnim(BOTH_JUMPBACK1)
                ps.pm_flags |= PMF_BACKWARDS_JUMP
            }

            ps.groundEntityNum = ENTITYNUM_NONE
            bg.pml.groundPlane = false
            bg.pml.walking = false
            return
        }

        // slopes that are too steep will not be considered onground
        if trace.plane.normal[2] < minNormal {
            if pm.debugLevel != 0 {
                Com_Printf("%i:steep\n", c_pmove)
            }
            ps.groundEntityNum = ENTITYNUM_NONE
            bg.pml.groundPlane = true
            bg.pml.walking = false
            return
        }

        bg.pml.groundPlane = true
        bg.pml.walking = true

        // hitting solid ground will end a waterjump
        if (ps.pm_flags & PMF_TIME_WATERJUMP) != 0 {
            ps.pm_flags &= ~(PMF_TIME_WATERJUMP | PMF_TIME_LAND)
            ps.pm_time = 0
        }

        if ps.groundEntityNum == ENTITYNUM_NONE {
            // just hit the ground
            if pm.debugLevel != 0 {
                Com_Printf("%i:Land\n", c_pmove)
            }

            PM_CrashLand()

            // Port-note: The game arm of Raven's `#ifdef QAGAME` reads `g_entities` and casts a `bgEntity_t *` to `gentity_t *` to board a vehicle. The `Entity` view lives in the game target, which the bg target cannot import.

            // don't do landing time if we were just going down a slope
            if bg.pml.previous_velocity[2] < -200 {
                // don't allow another jump for a little while
                ps.pm_flags |= PMF_TIME_LAND
                ps.pm_time = 250
            }
        }

        // Port-note: `trace.entityNum` is a `short`, and both the store and the call take an `int`, so each needs a widening Raven did not write.
        ps.groundEntityNum = Int32(trace.entityNum)
        ps.lastOnGround = pm.cmd.serverTime

        PM_AddTouchEnt(Int32(trace.entityNum))
    }
}

/**
```
=============
PM_SetWaterLevel
=============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:4285
private func PM_SetWaterLevel() {
    var point = JKAShared.vec3_t(0, 0, 0)
    var cont: Int32
    let sample1: Int32
    let sample2: Int32
    let ps = pm.ps
    //
    // get waterlevel, accounting for ducking
    //
    pm.waterlevel = 0
    pm.watertype = 0

    point[0] = ps.origin[0]
    point[1] = ps.origin[1]
    point[2] = ps.origin[2] + MINS_Z + 1
    // Port-note: Raven calls `pm->pointcontents` with no guard. The generated call gives nil when the stored pointer is nil, so the body binds each result, and the nil path traps.
    let cont0 = pm.runPointcontents(point, ps.clientNum)
    cont = cont0

    if (cont & MASK_WATER) != 0 {
        sample2 = ps.viewheight - MINS_Z
        sample1 = sample2 / 2

        pm.watertype = cont
        pm.waterlevel = 1
        point[2] = ps.origin[2] + MINS_Z + sample1
        let cont1 = pm.runPointcontents(point, ps.clientNum)
        cont = cont1
        if (cont & MASK_WATER) != 0 {
            pm.waterlevel = 2
            point[2] = ps.origin[2] + MINS_Z + sample2
            let cont2 = pm.runPointcontents(point, ps.clientNum)
            cont = cont2
            if (cont & MASK_WATER) != 0 {
                pm.waterlevel = 3
            }
        }
    }

}

/// Source: oracle/codemp/game/bg_pmove.c:4322
func PM_CheckDualForwardJumpDuck() -> Bool {
    var resized = false
    let ps = pm.ps
    if ps.legsAnim == BOTH_JUMPATTACK6 {
        //dynamically reduce bounding box to let character sail over heads of enemies
        if (ps.legsTimer >= 1450
                && PM_AnimLength(0, BOTH_JUMPATTACK6) - ps.legsTimer >= 400)
            || (ps.legsTimer >= 400
                && PM_AnimLength(0, BOTH_JUMPATTACK6) - ps.legsTimer >= 1100) {
            //in a part of the anim that we're pretty much sideways in, raise up the mins
            pm.mins[2] = 0
            ps.pm_flags |= PMF_FIX_MINS
            resized = true
        }
    }
    return resized
}

/// Source: oracle/codemp/game/bg_pmove.c:4341
func PM_CheckFixMins() {
    let ps = pm.ps
    if (ps.pm_flags & PMF_FIX_MINS) != 0 {// pm->mins[2] > DEFAULT_MINS_2 )
        //drop the mins back down
        //do a trace to make sure it's okay
        var end = JKAShared.vec3_t(0, 0, 0)
        var curMins = JKAShared.vec3_t(0, 0, 0)
        var curMaxs = JKAShared.vec3_t(0, 0, 0)

        end = JKAShared.vec3_t(ps.origin[0], ps.origin[1], ps.origin[2] + MINS_Z)
        curMins = JKAShared.vec3_t(pm.mins[0], pm.mins[1], 0)
        curMaxs = JKAShared.vec3_t(pm.maxs[0], pm.maxs[1], Float(ps.standheight))

        JKAMP.Trace.scratch { trace in
            pm.runTrace(trace, ps.origin, curMins, curMaxs, end, ps.clientNum, pm.tracemask)
            if trace.allsolid == 0 && trace.startsolid == 0 {
                //should never start in solid
                if trace.fraction >= 1.0 {
                    //all clear
                    //drop the bottom of my bbox back down
                    pm.mins[2] = Float(MINS_Z)
                    ps.pm_flags &= ~PMF_FIX_MINS
                } else {
                    //move me up so the bottom of my bbox will be where the trace ended, at least
                    //need to trace up, too
                    let updist = ((1.0 - trace.fraction) * -MINS_Z)
                    end[2] = ps.origin[2] + updist
                    pm.runTrace(trace, ps.origin, curMins, curMaxs, end, ps.clientNum, pm.tracemask)
                    if trace.allsolid == 0 && trace.startsolid == 0 {
                        //should never start in solid
                        if trace.fraction >= 1.0 {
                            //all clear
                            //move me up
                            ps.origin[2] += updist
                            //drop the bottom of my bbox back down
                            pm.mins[2] = Float(MINS_Z)
                            ps.pm_flags &= ~PMF_FIX_MINS
                        } else {
                            //crap, no room to expand, so just crouch us
                            if ps.legsAnim != BOTH_JUMPATTACK6
                                || ps.legsTimer <= 200 {
                                //at the end of the anim, and we can't leave ourselves like this
                                //so drop the maxs, put the mins back and move us up
                                pm.maxs[2] += MINS_Z
                                ps.origin[2] -= MINS_Z
                                pm.mins[2] = Float(MINS_Z)
                                //this way we'll be in a crouch when we're done
                                if ps.legsAnim == BOTH_JUMPATTACK6 {
                                    // Raven chains one store, `pm->ps->legsTimer = pm->ps->torsoTimer = 0`, which Swift writes as two.
                                    ps.torsoTimer = 0
                                    ps.legsTimer = 0
                                }
                                ps.pm_flags |= PMF_DUCKED
                                //FIXME: do we need to set a crouch anim here?
                                ps.pm_flags &= ~PMF_FIX_MINS
                            }
                        }
                    }//crap, stuck
                }
            }//crap, stuck!
        }
    }
}

/**
```
==============
PM_CheckDuck

Sets mins, maxs, and pm->ps->viewheight
==============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:4410
private func PM_CheckDuck() {
    let ps = pm.ps
    // Raven's record lives to the end of the function, so the whole body is the closure, and each of his early-outs returns from it.
    JKAMP.Trace.scratch { trace in
        if ps.m_iVehicleNum > 0 && ps.m_iVehicleNum < ENTITYNUM_NONE {
            //riding a vehicle or are a vehicle
            //no ducking or rolling when on a vehicle
            //right?  not even on ones that you just ride on top of?
            ps.pm_flags &= ~PMF_DUCKED
            ps.pm_flags &= ~PMF_ROLLING
            //NOTE: we don't clear the pm->cmd.upmove here because
            //the vehicle code may need it later... but, for riders,
            //it should have already been copied over to the vehicle, right?

            if ps.clientNum >= MAX_CLIENTS {
                return
            }
            // Port-note: Raven walks `pm_entVeh->m_pVehicle->m_pVehicleInfo` with no guard on the last field. The generated field is optional, so the body binds it.
            if let pm_entVeh = pm_entVeh, let m_pVehicle = pm_entVeh.m_pVehicle,
                let m_pVehicleInfo = m_pVehicle.m_pVehicleInfo,
                (m_pVehicleInfo.type == VH_SPEEDER
                 || m_pVehicleInfo.type == VH_ANIMAL) {
                pm.mins[0] = -16
                pm.mins[1] = -16
                pm.mins[2] = Float(MINS_Z)

                pm.maxs[0] = 16
                pm.maxs[1] = 16
                pm.maxs[2] = Float(ps.standheight)//DEFAULT_MAXS_2;
                ps.viewheight = DEFAULT_VIEWHEIGHT

                JKAMP.Trace.scratch { solidTr in
                    pm.runTrace(solidTr, ps.origin, pm.mins, pm.maxs, ps.origin, ps.m_iVehicleNum, pm.tracemask)
                    if solidTr.startsolid != 0 || solidTr.allsolid != 0 || solidTr.fraction != 1.0 {
                        //whoops, can't fit here. Down to 0!
                        pm.mins = JKAShared.vec3_t(0, 0, 0)
                        pm.maxs = JKAShared.vec3_t(0, 0, 0)
                        // Port-note: The game arm of Raven's `#ifdef QAGAME` reads `g_entities` and `level.time` through a `gentity_t *`. The `Entity` view and the level state live in the game target, which the bg target cannot import.
                    }
                }
            }
        } else {
            if ps.clientNum < MAX_CLIENTS {
                pm.mins[0] = -15
                pm.mins[1] = -15

                pm.maxs[0] = 15
                pm.maxs[1] = 15
            }

            if PM_CheckDualForwardJumpDuck() {
                //special anim resizing us
            } else {
                PM_CheckFixMins()

                if pm.mins[2] == 0 {
                    pm.mins[2] = Float(MINS_Z)
                }
            }

            if ps.pm_type == PM_DEAD && ps.clientNum < MAX_CLIENTS {
                pm.maxs[2] = -8
                ps.viewheight = DEAD_VIEWHEIGHT
                return
            }

            if BG_InRoll(ps, ps.legsAnim) && !BG_KickingAnim(ps.legsAnim) {
                pm.maxs[2] = Float(ps.crouchheight) //CROUCH_MAXS_2;
                ps.viewheight = DEFAULT_VIEWHEIGHT
                ps.pm_flags &= ~PMF_DUCKED
                ps.pm_flags |= PMF_ROLLING
                return
            } else if (ps.pm_flags & PMF_ROLLING) != 0 {
                // try to stand up
                pm.maxs[2] = Float(ps.standheight)//DEFAULT_MAXS_2;
                pm.runTrace(trace, ps.origin, pm.mins, pm.maxs, ps.origin, ps.clientNum, pm.tracemask)
                if trace.allsolid == 0 {
                    ps.pm_flags &= ~PMF_ROLLING
                }
            } else if pm.cmd.upmove < 0
                || ps.forceHandExtend == HANDEXTEND_KNOCKDOWN
                || ps.forceHandExtend == HANDEXTEND_PRETHROWN
                || ps.forceHandExtend == HANDEXTEND_POSTTHROWN {
                // duck
                ps.pm_flags |= PMF_DUCKED
            } else {
                // stand up if possible
                if (ps.pm_flags & PMF_DUCKED) != 0 {
                    // try to stand up
                    pm.maxs[2] = Float(ps.standheight)//DEFAULT_MAXS_2;
                    pm.runTrace(trace, ps.origin, pm.mins, pm.maxs, ps.origin, ps.clientNum, pm.tracemask)
                    if trace.allsolid == 0 {
                        ps.pm_flags &= ~PMF_DUCKED
                    }
                }
            }
        }

        if (ps.pm_flags & PMF_DUCKED) != 0 {
            pm.maxs[2] = Float(ps.crouchheight)//CROUCH_MAXS_2;
            ps.viewheight = CROUCH_VIEWHEIGHT
        } else if (ps.pm_flags & PMF_ROLLING) != 0 {
            pm.maxs[2] = Float(ps.crouchheight)//CROUCH_MAXS_2;
            ps.viewheight = DEFAULT_VIEWHEIGHT
        } else {
            pm.maxs[2] = Float(ps.standheight)//DEFAULT_MAXS_2;
            ps.viewheight = DEFAULT_VIEWHEIGHT
        }
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:4559
func PM_Use() {
    let ps = pm.ps
    if ps.useTime > 0 {
        ps.useTime -= 100//pm->cmd.msec;
    }

    if ps.useTime > 0 {
        return
    }

    if (pm.cmd.buttons & BUTTON_USE) == 0 {
        pm.useEvent = 0
        ps.useTime = 0
        return
    }

    pm.useEvent = EV_USE
    ps.useTime = USE_DELAY
}

/// Source: oracle/codemp/game/bg_pmove.c:4579
func PM_WalkingAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_WALK1, //# Normal walk
         BOTH_WALK2, //# Normal walk with saber
         BOTH_WALK_STAFF, //# Normal walk with staff
         BOTH_WALK_DUAL, //# Normal walk with staff
         BOTH_WALK5, //# Tavion taunting Kyle (cin 22)
         BOTH_WALK6, //# Slow walk for Luke (cin 12)
         BOTH_WALK7, //# Fast walk
         BOTH_WALKBACK1, //# Walk1 backwards
         BOTH_WALKBACK2, //# Walk2 backwards
         BOTH_WALKBACK_STAFF, //# Walk backwards with staff
         BOTH_WALKBACK_DUAL: //# Walk backwards with dual
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4600
func PM_RunningAnim(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_RUN1,
         BOTH_RUN2,
         BOTH_RUN_STAFF,
         BOTH_RUN_DUAL,
         BOTH_RUNBACK1,
         BOTH_RUNBACK2,
         BOTH_RUNBACK_STAFF,
         BOTH_RUNBACK_DUAL,
         BOTH_RUN1START, //# Start into full run1
         BOTH_RUN1STOP, //# Stop from full run1
         BOTH_RUNSTRAFE_LEFT1, //# Sidestep left: should loop
         BOTH_RUNSTRAFE_RIGHT1: //# Sidestep right: should loop
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4622
func PM_SwimmingAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_SWIM_IDLE1, //# Swimming Idle 1
         BOTH_SWIMFORWARD, //# Swim forward loop
         BOTH_SWIMBACKWARD: //# Swim backward loop
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4635
func PM_RollingAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_ROLL_F, //# Roll forward
         BOTH_ROLL_B, //# Roll backward
         BOTH_ROLL_L, //# Roll left
         BOTH_ROLL_R: //# Roll right
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4649
func PM_AnglesForSlope(_ yaw: Float, _ slope: JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t) {
    var nvf = JKAShared.vec3_t(0, 0, 0)
    var ovf = JKAShared.vec3_t(0, 0, 0)
    var ovr = JKAShared.vec3_t(0, 0, 0)
    var new_angles = JKAShared.vec3_t(0, 0, 0)
    var pitch: Float
    var mod: Float
    let dot: Float

    angles = JKAShared.vec3_t(0, yaw, 0)
    // Raven passes NULL for the third output of `AngleVectors`. The ported function takes it by reference, so the body passes a scratch vector it never reads.
    var scratchUp = JKAShared.vec3_t(0, 0, 0)
    AngleVectors(angles, &ovf, &ovr, &scratchUp)

    vectoangles(slope, &new_angles)
    pitch = new_angles[PITCH] + 90
    new_angles[ROLL] = 0
    new_angles[PITCH] = 0

    var scratchRight = JKAShared.vec3_t(0, 0, 0)
    AngleVectors(new_angles, &nvf, &scratchRight, &scratchUp)

    mod = _DotProduct(nvf, ovr)

    if mod < 0 {
        mod = -1
    } else {
        mod = 1
    }

    dot = _DotProduct(nvf, ovf)

    angles[YAW] = 0
    angles[PITCH] = dot * pitch
    angles[ROLL] = ((1 - Q_fabs(dot)) * pitch * mod)
}

/// Source: oracle/codemp/game/bg_pmove.c:4677
func PM_FootSlopeTrace(_ pDiff: inout Float, _ pInterval: inout Float) {
    var footLOrg = JKAShared.vec3_t(0, 0, 0), footROrg = JKAShared.vec3_t(0, 0, 0), footLBot = JKAShared.vec3_t(0, 0, 0), footRBot = JKAShared.vec3_t(0, 0, 0)
    var footLPoint = JKAShared.vec3_t(0, 0, 0), footRPoint = JKAShared.vec3_t(0, 0, 0)
    var footMins = JKAShared.vec3_t(0, 0, 0), footMaxs = JKAShared.vec3_t(0, 0, 0)
    var footLSlope = JKAShared.vec3_t(0, 0, 0), footRSlope = JKAShared.vec3_t(0, 0, 0)

    let diff: Float, interval: Float

    var G2Angles = JKAShared.vec3_t(0, 0, 0)
    let ps = pm.ps

    G2Angles = JKAShared.vec3_t(0, ps.viewangles[YAW], 0)

    interval = 4 //?

    MdxaBone.scratch { boltMatrix in
        strap_G2API_GetBoltMatrix(pm.ghoul2, 0, pm.g2Bolts_LFoot, boltMatrix, G2Angles, ps.origin, pm.cmd.serverTime, nil, &pm.modelScale)
        footLPoint[0] = boltMatrix.matrix[0][3]
        footLPoint[1] = boltMatrix.matrix[1][3]
        footLPoint[2] = boltMatrix.matrix[2][3]

        strap_G2API_GetBoltMatrix(pm.ghoul2, 0, pm.g2Bolts_RFoot, boltMatrix, G2Angles, ps.origin, pm.cmd.serverTime, nil, &pm.modelScale)
        footRPoint[0] = boltMatrix.matrix[0][3]
        footRPoint[1] = boltMatrix.matrix[1][3]
        footRPoint[2] = boltMatrix.matrix[2][3]
    }

    //get these on the cgame and store it, save ourselves a ghoul2 construct skel call
    footLOrg = footLPoint
    footROrg = footRPoint

    //step 2: adjust foot tag z height to bottom of bbox+1
    footLOrg[2] = ps.origin[2] + pm.mins[2] + 1
    footROrg[2] = ps.origin[2] + pm.mins[2] + 1
    footLBot = JKAShared.vec3_t(footLOrg[0], footLOrg[1], footLOrg[2] - interval * 10)
    footRBot = JKAShared.vec3_t(footROrg[0], footROrg[1], footROrg[2] - interval * 10)

    //step 3: trace down from each, find difference
    footMins = JKAShared.vec3_t(-3, -3, 0)
    footMaxs = JKAShared.vec3_t(3, 3, 1)

    Trace.scratch { trace in
        pm.runTrace(trace, footLOrg, footMins, footMaxs, footLBot, ps.clientNum, pm.tracemask)
        footLBot = trace.endpos
        _VectorCopy(trace.plane.normal, &footLSlope)

        pm.runTrace(trace, footROrg, footMins, footMaxs, footRBot, ps.clientNum, pm.tracemask)
        footRBot = trace.endpos
        _VectorCopy(trace.plane.normal, &footRSlope)
    }

    diff = footLBot[2] - footRBot[2]

    // Port-note: Raven guards a NULL `pDiff` and a NULL `pInterval` here. Each generated parameter is a plain `inout Float`, so neither guard has a Swift form.
    pDiff = diff
    pInterval = interval
}

/// Source: oracle/codemp/game/bg_pmove.c:4742
func BG_InSlopeAnim(_ anim: Int32) -> Bool {
    switch anim {
    case LEGS_LEFTUP1, //# On a slope with left foot 4 higher than right
         LEGS_LEFTUP2, //# On a slope with left foot 8 higher than right
         LEGS_LEFTUP3, //# On a slope with left foot 12 higher than right
         LEGS_LEFTUP4, //# On a slope with left foot 16 higher than right
         LEGS_LEFTUP5, //# On a slope with left foot 20 higher than right
         LEGS_RIGHTUP1, //# On a slope with RIGHT foot 4 higher than left
         LEGS_RIGHTUP2, //# On a slope with RIGHT foot 8 higher than left
         LEGS_RIGHTUP3, //# On a slope with RIGHT foot 12 higher than left
         LEGS_RIGHTUP4, //# On a slope with RIGHT foot 16 higher than left
         LEGS_RIGHTUP5, //# On a slope with RIGHT foot 20 higher than left
         LEGS_S1_LUP1,
         LEGS_S1_LUP2,
         LEGS_S1_LUP3,
         LEGS_S1_LUP4,
         LEGS_S1_LUP5,
         LEGS_S1_RUP1,
         LEGS_S1_RUP2,
         LEGS_S1_RUP3,
         LEGS_S1_RUP4,
         LEGS_S1_RUP5,
         LEGS_S3_LUP1,
         LEGS_S3_LUP2,
         LEGS_S3_LUP3,
         LEGS_S3_LUP4,
         LEGS_S3_LUP5,
         LEGS_S3_RUP1,
         LEGS_S3_RUP2,
         LEGS_S3_RUP3,
         LEGS_S3_RUP4,
         LEGS_S3_RUP5,
         LEGS_S4_LUP1,
         LEGS_S4_LUP2,
         LEGS_S4_LUP3,
         LEGS_S4_LUP4,
         LEGS_S4_LUP5,
         LEGS_S4_RUP1,
         LEGS_S4_RUP2,
         LEGS_S4_RUP3,
         LEGS_S4_RUP4,
         LEGS_S4_RUP5,
         LEGS_S5_LUP1,
         LEGS_S5_LUP2,
         LEGS_S5_LUP3,
         LEGS_S5_LUP4,
         LEGS_S5_LUP5,
         LEGS_S5_RUP1,
         LEGS_S5_RUP2,
         LEGS_S5_RUP3,
         LEGS_S5_RUP4,
         LEGS_S5_RUP5:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4804
func PM_AdjustStandAnimForSlope() -> Bool {
    var diff: Float = 0
    var interval: Float = 0
    var destAnim: Int32
    var legsAnim: Int32
    //`SLOPERECALCVAR` is Raven's convenience macro for `pm->ps->slopeRecalcTime`.
    let ps = pm.ps
    if pm.ghoul2 == nil {
        //probably just changed models and not quite in sync yet
        return false
    }

    if pm.g2Bolts_LFoot == -1 || pm.g2Bolts_RFoot == -1 {
        //need these bolts!
        return false
    }

    //step 1: find the 2 foot tags
    PM_FootSlopeTrace(&diff, &interval)

    //step 4: based on difference, choose one of the left/right slope-match intervals
    if diff >= interval * 5 {
        destAnim = LEGS_LEFTUP5
    } else if diff >= interval * 4 {
        destAnim = LEGS_LEFTUP4
    } else if diff >= interval * 3 {
        destAnim = LEGS_LEFTUP3
    } else if diff >= interval * 2 {
        destAnim = LEGS_LEFTUP2
    } else if diff >= interval {
        destAnim = LEGS_LEFTUP1
    } else if diff <= interval * -5 {
        destAnim = LEGS_RIGHTUP5
    } else if diff <= interval * -4 {
        destAnim = LEGS_RIGHTUP4
    } else if diff <= interval * -3 {
        destAnim = LEGS_RIGHTUP3
    } else if diff <= interval * -2 {
        destAnim = LEGS_RIGHTUP2
    } else if diff <= interval * -1 {
        destAnim = LEGS_RIGHTUP1
    } else {
        return false
    }

    legsAnim = ps.legsAnim
    //adjust for current legs anim
    switch legsAnim {
    case BOTH_STAND1,
        LEGS_S1_LUP1, LEGS_S1_LUP2, LEGS_S1_LUP3, LEGS_S1_LUP4, LEGS_S1_LUP5,
        LEGS_S1_RUP1, LEGS_S1_RUP2, LEGS_S1_RUP3, LEGS_S1_RUP4, LEGS_S1_RUP5:
        destAnim = LEGS_S1_LUP1 + (destAnim - LEGS_LEFTUP1)

    case BOTH_STAND2, BOTH_SABERFAST_STANCE, BOTH_SABERSLOW_STANCE, BOTH_CROUCH1IDLE, BOTH_CROUCH1,
        LEGS_LEFTUP1,			//# On a slope with left foot 4 higher than right
        LEGS_LEFTUP2,			//# On a slope with left foot 8 higher than right
        LEGS_LEFTUP3,			//# On a slope with left foot 12 higher than right
        LEGS_LEFTUP4,			//# On a slope with left foot 16 higher than right
        LEGS_LEFTUP5,			//# On a slope with left foot 20 higher than right
        LEGS_RIGHTUP1,			//# On a slope with RIGHT foot 4 higher than left
        LEGS_RIGHTUP2,			//# On a slope with RIGHT foot 8 higher than left
        LEGS_RIGHTUP3,			//# On a slope with RIGHT foot 12 higher than left
        LEGS_RIGHTUP4,			//# On a slope with RIGHT foot 16 higher than left
        LEGS_RIGHTUP5:			//# On a slope with RIGHT foot 20 higher than left
        //fine
        break

    case BOTH_STAND3,
        LEGS_S3_LUP1, LEGS_S3_LUP2, LEGS_S3_LUP3, LEGS_S3_LUP4, LEGS_S3_LUP5,
        LEGS_S3_RUP1, LEGS_S3_RUP2, LEGS_S3_RUP3, LEGS_S3_RUP4, LEGS_S3_RUP5:
        destAnim = LEGS_S3_LUP1 + (destAnim - LEGS_LEFTUP1)

    case BOTH_STAND4,
        LEGS_S4_LUP1, LEGS_S4_LUP2, LEGS_S4_LUP3, LEGS_S4_LUP4, LEGS_S4_LUP5,
        LEGS_S4_RUP1, LEGS_S4_RUP2, LEGS_S4_RUP3, LEGS_S4_RUP4, LEGS_S4_RUP5:
        destAnim = LEGS_S4_LUP1 + (destAnim - LEGS_LEFTUP1)

    case BOTH_STAND5,
        LEGS_S5_LUP1, LEGS_S5_LUP2, LEGS_S5_LUP3, LEGS_S5_LUP4, LEGS_S5_LUP5,
        LEGS_S5_RUP1, LEGS_S5_RUP2, LEGS_S5_RUP3, LEGS_S5_RUP4, LEGS_S5_RUP5:
        destAnim = LEGS_S5_LUP1 + (destAnim - LEGS_LEFTUP1)

    case BOTH_STAND6:
        return false

    default:
        return false
    }

    //step 5: based on the chosen interval and the current legsAnim, pick the correct anim
    //step 6: increment/decrement to the dest anim, not instant
    if (legsAnim >= LEGS_LEFTUP1 && legsAnim <= LEGS_LEFTUP5)
        || (legsAnim >= LEGS_S1_LUP1 && legsAnim <= LEGS_S1_LUP5)
        || (legsAnim >= LEGS_S3_LUP1 && legsAnim <= LEGS_S3_LUP5)
        || (legsAnim >= LEGS_S4_LUP1 && legsAnim <= LEGS_S4_LUP5)
        || (legsAnim >= LEGS_S5_LUP1 && legsAnim <= LEGS_S5_LUP5) {
        //already in left-side up
        if destAnim > legsAnim && ps.slopeRecalcTime < pm.cmd.serverTime {
            legsAnim += 1
            ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
        } else if destAnim < legsAnim && ps.slopeRecalcTime < pm.cmd.serverTime {
            legsAnim -= 1
            ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
        } else //if (SLOPERECALCVAR < pm->cmd.serverTime)
        {
            legsAnim = destAnim
        }

        destAnim = legsAnim
    } else if (legsAnim >= LEGS_RIGHTUP1 && legsAnim <= LEGS_RIGHTUP5)
        || (legsAnim >= LEGS_S1_RUP1 && legsAnim <= LEGS_S1_RUP5)
        || (legsAnim >= LEGS_S3_RUP1 && legsAnim <= LEGS_S3_RUP5)
        || (legsAnim >= LEGS_S4_RUP1 && legsAnim <= LEGS_S4_RUP5)
        || (legsAnim >= LEGS_S5_RUP1 && legsAnim <= LEGS_S5_RUP5) {
        //already in right-side up
        if destAnim > legsAnim && ps.slopeRecalcTime < pm.cmd.serverTime {
            legsAnim += 1
            ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
        } else if destAnim < legsAnim && ps.slopeRecalcTime < pm.cmd.serverTime {
            legsAnim -= 1
            ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
        } else //if (SLOPERECALCVAR < pm->cmd.serverTime)
        {
            legsAnim = destAnim
        }

        destAnim = legsAnim
    } else {
        //in a stand of some sort?
        switch legsAnim {
        case BOTH_STAND1, TORSO_WEAPONREADY1, TORSO_WEAPONREADY2, TORSO_WEAPONREADY3, TORSO_WEAPONREADY10:
            if destAnim >= LEGS_S1_LUP1 && destAnim <= LEGS_S1_LUP5 {
                //going into left side up
                destAnim = LEGS_S1_LUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else if destAnim >= LEGS_S1_RUP1 && destAnim <= LEGS_S1_RUP5 {
                //going into right side up
                destAnim = LEGS_S1_RUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else {
                //will never get here
                return false
            }

        case BOTH_STAND2, BOTH_SABERFAST_STANCE, BOTH_SABERSLOW_STANCE, BOTH_CROUCH1IDLE:
            if destAnim >= LEGS_LEFTUP1 && destAnim <= LEGS_LEFTUP5 {
                //going into left side up
                destAnim = LEGS_LEFTUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else if destAnim >= LEGS_RIGHTUP1 && destAnim <= LEGS_RIGHTUP5 {
                //going into right side up
                destAnim = LEGS_RIGHTUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else {
                //will never get here
                return false
            }

        case BOTH_STAND3:
            if destAnim >= LEGS_S3_LUP1 && destAnim <= LEGS_S3_LUP5 {
                //going into left side up
                destAnim = LEGS_S3_LUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else if destAnim >= LEGS_S3_RUP1 && destAnim <= LEGS_S3_RUP5 {
                //going into right side up
                destAnim = LEGS_S3_RUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else {
                //will never get here
                return false
            }

        case BOTH_STAND4:
            if destAnim >= LEGS_S4_LUP1 && destAnim <= LEGS_S4_LUP5 {
                //going into left side up
                destAnim = LEGS_S4_LUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else if destAnim >= LEGS_S4_RUP1 && destAnim <= LEGS_S4_RUP5 {
                //going into right side up
                destAnim = LEGS_S4_RUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else {
                //will never get here
                return false
            }

        case BOTH_STAND5:
            if destAnim >= LEGS_S5_LUP1 && destAnim <= LEGS_S5_LUP5 {
                //going into left side up
                destAnim = LEGS_S5_LUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else if destAnim >= LEGS_S5_RUP1 && destAnim <= LEGS_S5_RUP5 {
                //going into right side up
                destAnim = LEGS_S5_RUP1
                ps.slopeRecalcTime = pm.cmd.serverTime + SLOPE_RECALC_INT
            } else {
                //will never get here
                return false
            }

        case BOTH_STAND6:
            return false

        default:
            return false
        }
    }
    //step 7: set the anim
    //PM_SetAnim( SETANIM_LEGS, destAnim, SETANIM_FLAG_NORMAL, 100 );
    PM_ContinueLegsAnim(destAnim)

    return true
}

//rww - slowly back out of slope leg anims, to prevent skipping between slope anims and general jittering
/// Source: oracle/codemp/game/bg_pmove.c:5107
func PM_LegsSlopeBackTransition(_ desiredAnim: Int32) -> Int32 {
    let ps = pm.ps
    let anim = ps.legsAnim
    var resultingAnim = desiredAnim

    switch anim {
    case LEGS_LEFTUP2,			//# On a slope with left foot 8 higher than right
        LEGS_LEFTUP3,			//# On a slope with left foot 12 higher than right
        LEGS_LEFTUP4,			//# On a slope with left foot 16 higher than right
        LEGS_LEFTUP5,			//# On a slope with left foot 20 higher than right
        LEGS_RIGHTUP2,			//# On a slope with RIGHT foot 8 higher than left
        LEGS_RIGHTUP3,			//# On a slope with RIGHT foot 12 higher than left
        LEGS_RIGHTUP4,			//# On a slope with RIGHT foot 16 higher than left
        LEGS_RIGHTUP5,			//# On a slope with RIGHT foot 20 higher than left
        LEGS_S1_LUP2, LEGS_S1_LUP3, LEGS_S1_LUP4, LEGS_S1_LUP5,
        LEGS_S1_RUP2, LEGS_S1_RUP3, LEGS_S1_RUP4, LEGS_S1_RUP5,
        LEGS_S3_LUP2, LEGS_S3_LUP3, LEGS_S3_LUP4, LEGS_S3_LUP5,
        LEGS_S3_RUP2, LEGS_S3_RUP3, LEGS_S3_RUP4, LEGS_S3_RUP5,
        LEGS_S4_LUP2, LEGS_S4_LUP3, LEGS_S4_LUP4, LEGS_S4_LUP5,
        LEGS_S4_RUP2, LEGS_S4_RUP3, LEGS_S4_RUP4, LEGS_S4_RUP5,
        LEGS_S5_LUP2, LEGS_S5_LUP3, LEGS_S5_LUP4, LEGS_S5_LUP5,
        LEGS_S5_RUP2, LEGS_S5_RUP3, LEGS_S5_RUP4, LEGS_S5_RUP5:
        if ps.slopeRecalcTime < pm.cmd.serverTime {
            resultingAnim = anim - 1
            ps.slopeRecalcTime = pm.cmd.serverTime + 8//SLOPE_RECALC_INT;
        } else {
            resultingAnim = anim
        }
        ps.velocity = JKAShared.vec3_t(0, 0, 0)

    default:
        break
    }

    return resultingAnim
}

/**
```
===============
PM_Footsteps
===============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:5175
private func PM_Footsteps() {
    var bobmove: Float
    let old: Int32
    var footstep: Bool
    var setAnimFlags: Int32 = 0
    let ps = pm.ps
    if (PM_InSaberAnim((ps.legsAnim)) && !BG_SpinningSaberAnim((ps.legsAnim)))
        || (ps.legsAnim) == BOTH_STAND1
        || (ps.legsAnim) == BOTH_STAND1TO2
        || (ps.legsAnim) == BOTH_STAND2TO1
        || (ps.legsAnim) == BOTH_STAND2
        || (ps.legsAnim) == BOTH_SABERFAST_STANCE
        || (ps.legsAnim) == BOTH_SABERSLOW_STANCE
        || (ps.legsAnim) == BOTH_BUTTON_HOLD
        || (ps.legsAnim) == BOTH_BUTTON_RELEASE
        || PM_LandingAnim((ps.legsAnim))
        || PM_PainAnim((ps.legsAnim)) {
        //legs are in a saber anim, and not spinning, be sure to override it
        setAnimFlags |= SETANIM_FLAG_OVERRIDE
    }

    //
    // calculate speed and cycle to be used for
    // all cyclic walking effects
    //
    // C promotes the argument of `sqrt` to double, so the port does the same.
    pm.xyspeed = Float(sqrt(Double(ps.velocity[0] * ps.velocity[0]
        + ps.velocity[1] * ps.velocity[1])))

    if ps.saberMove == LS_SPINATTACK {
        PM_ContinueLegsAnim(ps.torsoAnim)
    } else if ps.groundEntityNum == ENTITYNUM_NONE {

        // airborne leaves position in cycle intact, but doesn't advance
        if pm.waterlevel > 1 {
            if pm.xyspeed > 60 {
                PM_ContinueLegsAnim(BOTH_SWIMFORWARD)
            } else {
                PM_ContinueLegsAnim(BOTH_SWIM_IDLE1)
            }
        }
        return
    }
    // if not trying to move
    else if pm.cmd.forwardmove == 0 && pm.cmd.rightmove == 0 {
        if pm.xyspeed < 5 {
            ps.bobCycle = 0 // start at beginning of cycle again
            if ps.clientNum >= MAX_CLIENTS,
                let pm_entSelf = pm_entSelf,
                pm_entSelf.s.NPC_class == CLASS_RANCOR {
                if (ps.eFlags2 & EF2_USE_ALT_ANIM) != 0 {
                    //holding someone
                    PM_ContinueLegsAnim(BOTH_STAND4)
                    //PM_SetAnim(pm,SETANIM_LEGS,BOTH_STAND4,SETANIM_FLAG_NORMAL);
                } else if (ps.eFlags2 & EF2_ALERTED) != 0 {
                    //have an enemy or have had one since we spawned
                    PM_ContinueLegsAnim(BOTH_STAND2)
                    //PM_SetAnim(pm,SETANIM_LEGS,BOTH_STAND2,SETANIM_FLAG_NORMAL);
                } else {
                    //just stand there
                    PM_ContinueLegsAnim(BOTH_STAND1)
                    //PM_SetAnim(pm,SETANIM_LEGS,BOTH_STAND1,SETANIM_FLAG_NORMAL);
                }
            } else if ps.clientNum >= MAX_CLIENTS,
                let pm_entSelf = pm_entSelf,
                pm_entSelf.s.NPC_class == CLASS_WAMPA {
                if (ps.eFlags2 & EF2_USE_ALT_ANIM) != 0 {
                    //holding a victim
                    PM_ContinueLegsAnim(BOTH_STAND2)
                    //PM_SetAnim(pm,SETANIM_LEGS,BOTH_STAND2,SETANIM_FLAG_NORMAL);
                } else {
                    //not holding a victim
                    PM_ContinueLegsAnim(BOTH_STAND1)
                    //PM_SetAnim(pm,SETANIM_LEGS,BOTH_STAND1,SETANIM_FLAG_NORMAL);
                }
            } else if (ps.pm_flags & PMF_DUCKED) != 0 || (ps.pm_flags & PMF_ROLLING) != 0 {
                if (ps.legsAnim) != BOTH_CROUCH1IDLE {
                    PM_SetAnim(SETANIM_LEGS, BOTH_CROUCH1IDLE, setAnimFlags, 100)
                } else {
                    PM_ContinueLegsAnim(BOTH_CROUCH1IDLE)
                }
            } else {
                if ps.weapon == WP_DISRUPTOR && ps.zoomMode == 1 {
                    ///????  continue legs anim on a torso anim...??!!!
                    //yeah.. the anim has a valid pose for the legs, it uses it (you can't move while using disruptor)
                    PM_ContinueLegsAnim(TORSO_WEAPONREADY4)
                } else {
                    if ps.weapon == WP_SABER && BG_SabersOff(ps) {
                        if !PM_AdjustStandAnimForSlope() {
                            //PM_ContinueLegsAnim( BOTH_STAND1 );
                            PM_ContinueLegsAnim(PM_LegsSlopeBackTransition(BOTH_STAND1))
                        }
                    } else {
                        if ps.weapon != WP_SABER || !PM_AdjustStandAnimForSlope() {
                            if ps.weapon == WP_SABER {
                                PM_ContinueLegsAnim(PM_LegsSlopeBackTransition(PM_GetSaberStance()))
                            } else {
                                PM_ContinueLegsAnim(PM_LegsSlopeBackTransition(bg.WeaponReadyLegsAnim[ps.weapon]))
                            }
                        }
                    }
                }
            }
        }
        return
    }

    footstep = false

    if ps.saberMove == LS_SPINATTACK {
        bobmove = 0.2
        PM_ContinueLegsAnim(ps.torsoAnim)
    } else if (ps.pm_flags & PMF_DUCKED) != 0 {
        var rolled: Int32 = 0

        bobmove = 0.5 // ducked characters bob much faster

        if ((PM_RunningAnim(ps.legsAnim) && VectorLengthSquared(ps.velocity) >= 40000/*200*200*/) || PM_CanRollFromSoulCal(ps))
            && !BG_InRoll(ps, ps.legsAnim) {
            //roll!
            rolled = PM_TryRoll()
        }
        if rolled == 0 {
            //if the roll failed or didn't attempt, do standard crouching anim stuff.
            if (ps.pm_flags & PMF_BACKWARDS_RUN) != 0 {
                if (ps.legsAnim) != BOTH_CROUCH1WALKBACK {
                    PM_SetAnim(SETANIM_LEGS, BOTH_CROUCH1WALKBACK, setAnimFlags, 100)
                } else {
                    PM_ContinueLegsAnim(BOTH_CROUCH1WALKBACK)
                }
            } else {
                if (ps.legsAnim) != BOTH_CROUCH1WALK {
                    PM_SetAnim(SETANIM_LEGS, BOTH_CROUCH1WALK, setAnimFlags, 100)
                } else {
                    PM_ContinueLegsAnim(BOTH_CROUCH1WALK)
                }
            }
        } else {
            //otherwise send us into the roll
            ps.legsTimer = 0
            ps.legsAnim = 0
            PM_SetAnim(SETANIM_BOTH, rolled, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 150)
            PM_AddEventWithParm(EV_ROLL, 0)
            pm.maxs[2] = Float(ps.crouchheight)//CROUCH_MAXS_2;
            ps.viewheight = DEFAULT_VIEWHEIGHT
            ps.pm_flags &= ~PMF_DUCKED
            ps.pm_flags |= PMF_ROLLING
        }
    } else if (ps.pm_flags & PMF_ROLLING) != 0 && !BG_InRoll(ps, ps.legsAnim)
        && !PM_InRollComplete(ps, ps.legsAnim) {
        bobmove = 0.5 // ducked characters bob much faster

        if (ps.pm_flags & PMF_BACKWARDS_RUN) != 0 {
            if (ps.legsAnim) != BOTH_CROUCH1WALKBACK {
                PM_SetAnim(SETANIM_LEGS, BOTH_CROUCH1WALKBACK, setAnimFlags, 100)
            } else {
                PM_ContinueLegsAnim(BOTH_CROUCH1WALKBACK)
            }
        } else {
            if (ps.legsAnim) != BOTH_CROUCH1WALK {
                PM_SetAnim(SETANIM_LEGS, BOTH_CROUCH1WALK, setAnimFlags, 100)
            } else {
                PM_ContinueLegsAnim(BOTH_CROUCH1WALK)
            }
        }
    } else {
        var desiredAnim: Int32 = -1

        if (ps.legsAnim == BOTH_FORCELAND1
            || ps.legsAnim == BOTH_FORCELANDBACK1
            || ps.legsAnim == BOTH_FORCELANDRIGHT1
            || ps.legsAnim == BOTH_FORCELANDLEFT1)
            && ps.legsTimer > 0 {
            //let it finish first
            bobmove = 0.2
        } else if (pm.cmd.buttons & BUTTON_WALKING) == 0 {
            //running
            bobmove = 0.4 // faster speeds bob faster
            if ps.clientNum >= MAX_CLIENTS,
                let pm_entSelf = pm_entSelf,
                pm_entSelf.s.NPC_class == CLASS_WAMPA {
                if (ps.eFlags2 & EF2_USE_ALT_ANIM) != 0 {
                    //full on run, on all fours
                    desiredAnim = BOTH_RUN1
                } else {
                    //regular, upright run
                    desiredAnim = BOTH_RUN2
                }
            } else if ps.clientNum >= MAX_CLIENTS,
                let pm_entSelf = pm_entSelf,
                pm_entSelf.s.NPC_class == CLASS_RANCOR {
                //no run anims
                if (ps.pm_flags & PMF_BACKWARDS_RUN) != 0 {
                    desiredAnim = BOTH_WALKBACK1
                } else {
                    desiredAnim = BOTH_WALK1
                }
            } else if (ps.pm_flags & PMF_BACKWARDS_RUN) != 0 {
                switch ps.fd.saberAnimLevel {
                case SS_STAFF:
                    if ps.saberHolstered > 1 {
                        //saber off
                        desiredAnim = BOTH_RUNBACK1
                    } else {
                        //desiredAnim = BOTH_RUNBACK_STAFF;
                        //hmm.. stuff runback anim is pretty messed up for some reason.
                        desiredAnim = BOTH_RUNBACK2
                    }

                case SS_DUAL:
                    if ps.saberHolstered > 1 {
                        //sabers off
                        desiredAnim = BOTH_RUNBACK1
                    } else {
                        //desiredAnim = BOTH_RUNBACK_DUAL;
                        //and so is the dual
                        desiredAnim = BOTH_RUNBACK2
                    }

                default:
                    if ps.saberHolstered != 0 {
                        //saber off
                        desiredAnim = BOTH_RUNBACK1
                    } else {
                        desiredAnim = BOTH_RUNBACK2
                    }
                }
            } else {
                switch ps.fd.saberAnimLevel {
                case SS_STAFF:
                    if ps.saberHolstered > 1 {
                        //blades off
                        desiredAnim = BOTH_RUN1
                    } else if ps.saberHolstered == 1 {
                        //1 blade on
                        desiredAnim = BOTH_RUN2
                    } else {
                        if (ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
                            desiredAnim = BOTH_RUN1
                        } else {
                            desiredAnim = BOTH_RUN_STAFF
                        }
                    }

                case SS_DUAL:
                    if ps.saberHolstered > 1 {
                        //blades off
                        desiredAnim = BOTH_RUN1
                    } else if ps.saberHolstered == 1 {
                        //1 saber on
                        desiredAnim = BOTH_RUN2
                    } else {
                        desiredAnim = BOTH_RUN_DUAL
                    }

                default:
                    if ps.saberHolstered != 0 {
                        //saber off
                        desiredAnim = BOTH_RUN1
                    } else {
                        desiredAnim = BOTH_RUN2
                    }
                }
            }
            footstep = true
        } else {
            bobmove = 0.2 // walking bobs slow
            if (ps.pm_flags & PMF_BACKWARDS_RUN) != 0 {
                switch ps.fd.saberAnimLevel {
                case SS_STAFF:
                    if ps.saberHolstered > 1 {
                        desiredAnim = BOTH_WALKBACK1
                    } else if ps.saberHolstered != 0 {
                        desiredAnim = BOTH_WALKBACK2
                    } else {
                        desiredAnim = BOTH_WALKBACK_STAFF
                    }

                case SS_DUAL:
                    if ps.saberHolstered > 1 {
                        desiredAnim = BOTH_WALKBACK1
                    } else if ps.saberHolstered != 0 {
                        desiredAnim = BOTH_WALKBACK2
                    } else {
                        desiredAnim = BOTH_WALKBACK_DUAL
                    }

                default:
                    if ps.saberHolstered != 0 {
                        desiredAnim = BOTH_WALKBACK1
                    } else {
                        desiredAnim = BOTH_WALKBACK2
                    }
                }
            } else {
                if ps.weapon == WP_MELEE {
                    desiredAnim = BOTH_WALK1
                } else if BG_SabersOff(ps) {
                    desiredAnim = BOTH_WALK1
                } else {
                    switch ps.fd.saberAnimLevel {
                    case SS_STAFF:
                        if ps.saberHolstered > 1 {
                            desiredAnim = BOTH_WALK1
                        } else if ps.saberHolstered != 0 {
                            desiredAnim = BOTH_WALK2
                        } else {
                            desiredAnim = BOTH_WALK_STAFF
                        }

                    case SS_DUAL:
                        if ps.saberHolstered > 1 {
                            desiredAnim = BOTH_WALK1
                        } else if ps.saberHolstered != 0 {
                            desiredAnim = BOTH_WALK2
                        } else {
                            desiredAnim = BOTH_WALK_DUAL
                        }

                    default:
                        if ps.saberHolstered != 0 {
                            desiredAnim = BOTH_WALK1
                        } else {
                            desiredAnim = BOTH_WALK2
                        }
                    }
                }
            }
        }

        if desiredAnim != -1 {
            let ires = PM_LegsSlopeBackTransition(desiredAnim)

            if (ps.legsAnim) != desiredAnim && ires == desiredAnim {
                PM_SetAnim(SETANIM_LEGS, desiredAnim, setAnimFlags, 100)
            } else {
                PM_ContinueLegsAnim(ires)
            }
        }
    }

    // check for footstep / splash sounds
    old = ps.bobCycle
    ps.bobCycle = Int32(old + bobmove * bg.pml.msec) & 255

    // if we just crossed a cycle boundary, play an apropriate footstep event
    if (((old + 64) ^ (ps.bobCycle + 64)) & 128) != 0 {
        ps.footstepTime = pm.cmd.serverTime + 300
        if pm.waterlevel == 1 {
            // splashing
            PM_AddEvent(EV_FOOTSPLASH)
        } else if pm.waterlevel == 2 {
            // wading / swimming at surface
            PM_AddEvent(EV_SWIM)
        } else if pm.waterlevel == 3 {
            // no sound when completely underwater
        }
    }
}

/**
```
==============
PM_WaterEvents

Generate sound events for entering and leaving water
==============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:5670
private func PM_WaterEvents() {
    // FIXME?
    // Raven declares `impact_splash` under `#ifdef QAGAME`. Swift has no arm-local declaration, so it stands here, and only the game arm reads it.
    var impact_splash = false
    let ps = pm.ps
    //
    // if just entered a water volume, play a sound
    //
    if bg.pml.previous_waterlevel == 0 && pm.waterlevel != 0 {
        if bg.consumer == .game {
            if VectorLengthSquared(ps.velocity) > 40000 {
                impact_splash = true
            }
        }
        PM_AddEvent(EV_WATER_TOUCH)
    }

    //
    // if just completely exited a water volume, play a sound
    //
    if bg.pml.previous_waterlevel != 0 && pm.waterlevel == 0 {
        if bg.consumer == .game {
            if VectorLengthSquared(ps.velocity) > 40000 {
                impact_splash = true
            }
        }
        PM_AddEvent(EV_WATER_LEAVE)
    }

    if bg.consumer == .game {
        if impact_splash {
            //play the splash effect
            Trace.scratch { tr in
                var start: JKAShared.vec3_t, end: JKAShared.vec3_t

                start = ps.origin
                end = ps.origin

                // FIXME: set start and end better
                start[2] += 10
                end[2] -= 40

                pm.runTrace(tr, start, vec3_origin, vec3_origin, end, ps.clientNum, MASK_WATER)

                if tr.fraction < 1.0 {
                    if (tr.contents & CONTENTS_LAVA) != 0 {
                        G_PlayEffect(EFFECT_LAVA_SPLASH, &tr.endpos, &tr.plane.normal)
                    } else if (tr.contents & CONTENTS_SLIME) != 0 {
                        G_PlayEffect(EFFECT_ACID_SPLASH, &tr.endpos, &tr.plane.normal)
                    } else { //must be water
                        G_PlayEffect(EFFECT_WATER_SPLASH, &tr.endpos, &tr.plane.normal)
                    }
                }
            }
        }
    }

    //
    // check for head just going under water
    //
    if bg.pml.previous_waterlevel != 3 && pm.waterlevel == 3 {
        PM_AddEvent(EV_WATER_UNDER)
    }

    //
    // check for head just coming out of water
    //
    if bg.pml.previous_waterlevel == 3 && pm.waterlevel != 3 {
        PM_AddEvent(EV_WATER_CLEAR)
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:5750
func BG_ClearRocketLock(_ ps: JKAMP.PlayerState) {
    // Port-note: Raven's `if (ps)` guard has no Swift form, because the signature takes a non-optional `PlayerState`.
    ps.rocketLockIndex = ENTITYNUM_NONE
    ps.rocketLastValidTime = 0
    ps.rocketLockTime = -1
    ps.rocketTargetTime = 0
}

/**
```
===============
PM_BeginWeaponChange
===============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:5766
func PM_BeginWeaponChange(_ weapon: Int32) {
    let ps = pm.ps
    if weapon <= WP_NONE || weapon >= WP_NUM_WEAPONS {
        return
    }

    if (ps.stats[STAT_WEAPONS] & (1 << weapon)) == 0 {
        return
    }

    if ps.weaponstate == WEAPON_DROPPING {
        return
    }

    // turn of any kind of zooming when weapon switching.
    if ps.zoomMode != 0 {
        ps.zoomMode = 0
        ps.zoomTime = ps.commandTime
    }

    PM_AddEventWithParm(EV_CHANGE_WEAPON, weapon)
    ps.weaponstate = WEAPON_DROPPING
    ps.weaponTime += 200
    //PM_StartTorsoAnim( TORSO_DROPWEAP1 );
    PM_SetAnim(SETANIM_TORSO, TORSO_DROPWEAP1, SETANIM_FLAG_OVERRIDE, 0)

    BG_ClearRocketLock(ps)
}

/**
```
===============
PM_FinishWeaponChange
===============
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:5801
func PM_FinishWeaponChange() {
    var weapon: Int32
    let ps = pm.ps
    // Port-note: Raven writes `weapon = pm->cmd.weapon`, a plain assignment of a `byte` to an `int`. `Promotion.swift` gives operators only, so the read keeps `Int32(...)`.
    weapon = Int32(pm.cmd.weapon)
    if weapon < WP_NONE || weapon >= WP_NUM_WEAPONS {
        weapon = WP_NONE
    }

    if (ps.stats[STAT_WEAPONS] & (1 << weapon)) == 0 {
        weapon = WP_NONE
    }

    if weapon == WP_SABER {
        // Port-note: The generated `PM_SetSaberMove` takes an `Int16`, and Raven's `LS_DRAW` is an `int` case, so the call needs a narrowing Raven did not write.
        PM_SetSaberMove(Int16(LS_DRAW))
    } else {
        //PM_StartTorsoAnim( TORSO_RAISEWEAP1);
        PM_SetAnim(SETANIM_TORSO, TORSO_RAISEWEAP1, SETANIM_FLAG_OVERRIDE, 0)
    }
    ps.weapon = weapon
    ps.weaponstate = WEAPON_RAISING
    ps.weaponTime += 250
}

/// Source: oracle/codemp/game/bg_pmove.c:5832
let MAX_XHAIR_DIST_ACCURACY: Float = 20000.0

/// Source: oracle/codemp/game/bg_pmove.c:5833
func BG_VehTraceFromCamPos(_ camTrace: JKAMP.Trace, _ bgEnt: JKAMP.BgEntity, _ entOrg: JKAShared.vec3_t, _ shotStart: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ newEnd: inout JKAShared.vec3_t, _ shotDir: inout JKAShared.vec3_t, _ bestDist: Float) -> Int32 {
    //NOTE: this MUST stay up to date with the method used in CG_ScanForCrosshairEntity (where it checks the doExtraVehTraceFromViewPos bool)
    var viewDir2End = JKAShared.vec3_t(0, 0, 0)
    var extraEnd = JKAShared.vec3_t(0, 0, 0)
    var camPos = JKAShared.vec3_t(0, 0, 0)

    if bg.consumer == .game {
        // Port-note: Raven walks `bgEnt->m_pVehicle->m_pPilot` with no guard. Both generated fields are optional, so the body binds them, and the nil path makes no call.
        if let m_pVehicle = bgEnt.m_pVehicle, let m_pPilot = m_pVehicle.m_pPilot {
            WP_GetVehicleCamPos(bgEnt, m_pPilot, &camPos)
        }
    } else {
        CG_GetVehicleCamPos(&camPos)
    }

    // Port-note: Raven walks `bgEnt->m_pVehicle->m_pVehicleInfo` with no guard. Both generated fields are optional, so the body binds them, and the nil path returns 0, the value of Raven's miss path.
    guard let m_pVehicleInfo = bgEnt.m_pVehicle?.m_pVehicleInfo else { return 0 }
    let minAutoAimDist = Distance(entOrg, camPos) + (m_pVehicleInfo.length / 2.0) + 200.0

    newEnd = end
    _VectorSubtract(end, camPos, &viewDir2End)
    _ = VectorNormalize(&viewDir2End)
    _VectorMA(camPos, MAX_XHAIR_DIST_ACCURACY, viewDir2End, &extraEnd)

    if bg.consumer == .game {
        trap_Trace(camTrace, camPos, vec3_origin, vec3_origin, extraEnd,
            bgEnt.s.number, CONTENTS_SOLID | CONTENTS_BODY)
    } else {
        pm.runTrace(camTrace, camPos, vec3_origin, vec3_origin, extraEnd,
            bgEnt.s.number, CONTENTS_SOLID | CONTENTS_BODY)
    }

    if camTrace.allsolid == 0
        && camTrace.startsolid == 0
        && camTrace.fraction < 1.0
        && (camTrace.fraction * MAX_XHAIR_DIST_ACCURACY) > minAutoAimDist
        && ((camTrace.fraction * MAX_XHAIR_DIST_ACCURACY) - Distance(entOrg, camPos)) < bestDist {
        //this trace hit *something* that's closer than the thing the main trace hit, so use this result instead
        newEnd = camTrace.endpos
        _VectorSubtract(newEnd, shotStart, &shotDir)
        _ = VectorNormalize(&shotDir)
        // Port-note: `trace_t.entityNum` is Raven's `short`, which C promotes to `int` in this return. Swift has no such promotion, so the body adds `Int32(...)`.
        return (Int32(camTrace.entityNum) + 1)
    }
    return 0
}

/// Source: oracle/codemp/game/bg_pmove.c:5874
func PM_RocketLock(_ lockDist: Float, _ vehicleLock: Bool) {
    // Not really a charge weapon, but we still want to delay fire until the button comes up so that we can
    //	implement our alt-fire locking stuff
    var ang = JKAShared.vec3_t(0, 0, 0)

    var muzzleOffPoint = JKAShared.vec3_t(0, 0, 0)
    var muzzlePoint = JKAShared.vec3_t(0, 0, 0)
    var forward = JKAShared.vec3_t(0, 0, 0)
    var right = JKAShared.vec3_t(0, 0, 0)
    var up = JKAShared.vec3_t(0, 0, 0)
    let ps = pm.ps

    if vehicleLock {
        AngleVectors(ps.viewangles, &forward, &right, &up)
        muzzlePoint = ps.origin
        _VectorMA(muzzlePoint, lockDist, forward, &ang)
    } else {
        AngleVectors(ps.viewangles, &forward, &right, &up)

        // Raven passes NULL for the last two vectors, so these two scratch locals take the write and the body reads neither.
        var nullRight = JKAShared.vec3_t(0, 0, 0)
        var nullUp = JKAShared.vec3_t(0, 0, 0)
        AngleVectors(ps.viewangles, &ang, &nullRight, &nullUp)

        muzzlePoint = ps.origin
        muzzleOffPoint = WP_MuzzlePoint[WP_ROCKET_LAUNCHER]

        _VectorMA(muzzlePoint, muzzleOffPoint[0], forward, &muzzlePoint)
        _VectorMA(muzzlePoint, muzzleOffPoint[1], right, &muzzlePoint)
        muzzlePoint[2] += ps.viewheight + muzzleOffPoint[2]
        ang[0] = muzzlePoint[0] + ang[0] * lockDist
        ang[1] = muzzlePoint[1] + ang[1] * lockDist
        ang[2] = muzzlePoint[2] + ang[2] * lockDist
    }

    Trace.scratch { tr in
        pm.runTrace(tr, muzzlePoint, vec3_origin, vec3_origin, ang, ps.clientNum, MASK_PLAYERSOLID)

        if vehicleLock {//vehicles also do a trace from the camera point if the main one misses
            if tr.fraction >= 1.0 {
                Trace.scratch { camTrace in
                    var newEnd = JKAShared.vec3_t(0, 0, 0)
                    var shotDir = JKAShared.vec3_t(0, 0, 0)
                    // Port-note: Raven hands `PM_BGEntForNum` straight to the call with no guard. The generated return is optional, so the body binds it.
                    if let bgEnt = PM_BGEntForNum(ps.clientNum),
                        BG_VehTraceFromCamPos(camTrace, bgEnt, ps.origin, muzzlePoint, tr.endpos, &newEnd, &shotDir, (tr.fraction * lockDist)) != 0 {
                        // Port-note: Raven copies the whole record with `memcpy( &tr, &camTrace, sizeof(tr) )`. The `Trace` view carries no copy into an existing slot, so the record copy has no Swift form.
                        portMissing("PM_RocketLock: memcpy of trace_t", source: "oracle/codemp/game/bg_pmove.c:5917")
                    }
                }
            }
        }

        // Port-note: Raven's `trace_t.entityNum` is a `short` that C promotes to `int` at each read. `Promotion.swift` carries no `Int16` form, so each read below takes a widening Raven did not write.
        if tr.fraction != 1 && Int32(tr.entityNum) < ENTITYNUM_NONE && Int32(tr.entityNum) != ps.clientNum {
            let bgEnt = PM_BGEntForNum(Int32(tr.entityNum))
            if let bgEnt, (bgEnt.s.powerups & PW_CLOAKED) != 0 {
                ps.rocketLockIndex = ENTITYNUM_NONE
                ps.rocketLockTime = 0
            } else if let bgEnt, (bgEnt.s.eType == ET_PLAYER || bgEnt.s.eType == ET_NPC) {
                if ps.rocketLockIndex == ENTITYNUM_NONE {
                    ps.rocketLockIndex = Int32(tr.entityNum)
                    ps.rocketLockTime = Float(pm.cmd.serverTime)
                } else if ps.rocketLockIndex != Int32(tr.entityNum) && ps.rocketTargetTime < pm.cmd.serverTime {
                    ps.rocketLockIndex = Int32(tr.entityNum)
                    ps.rocketLockTime = Float(pm.cmd.serverTime)
                } else if ps.rocketLockIndex == Int32(tr.entityNum) {
                    if ps.rocketLockTime == -1 {
                        ps.rocketLockTime = ps.rocketLastValidTime
                    }
                }

                if ps.rocketLockIndex == Int32(tr.entityNum) {
                    ps.rocketTargetTime = Float(pm.cmd.serverTime + 500)
                }
            } else if !vehicleLock {
                if ps.rocketTargetTime < pm.cmd.serverTime {
                    ps.rocketLockIndex = ENTITYNUM_NONE
                    ps.rocketLockTime = 0
                }
            }
        } else if ps.rocketTargetTime < pm.cmd.serverTime {
            ps.rocketLockIndex = ENTITYNUM_NONE
            ps.rocketLockTime = 0
        } else {
            if ps.rocketLockTime != -1 {
                ps.rocketLastValidTime = ps.rocketLockTime
            }
            ps.rocketLockTime = -1
        }
    }
}

//---------------------------------------
/// Source: oracle/codemp/game/bg_pmove.c:5980
private func PM_DoChargedWeapons(_ vehicleRocketLock: Bool, _ veh: JKAMP.BgEntity) -> Bool {
    // Port-note: The body reads `g_vehWeaponInfo`, a file-scope table of `bg_vehicles.c`. That name is in no manifest yet, so it has no Swift spelling.
    // Port-note: Raven writes `goto rest` at four places in this body. The restructuring waits until the body can be written.
    // TODO: Port PM_DoChargedWeapons
    portMissing("PM_DoChargedWeapons", source: "oracle/codemp/game/bg_pmove.c:5980")
}

/// Source: oracle/codemp/game/bg_pmove.c:6239
func PM_ItemUsable(_ ps: JKAMP.PlayerState, _ forcedUse: Int32) -> Int32 {
    var fwd = JKAShared.vec3_t(0, 0, 0), fwdorg = JKAShared.vec3_t(0, 0, 0), dest = JKAShared.vec3_t(0, 0, 0), pos = JKAShared.vec3_t(0, 0, 0)
    var yawonly = JKAShared.vec3_t(0, 0, 0)
    var mins = JKAShared.vec3_t(0, 0, 0), maxs = JKAShared.vec3_t(0, 0, 0)
    var trtest = JKAShared.vec3_t(0, 0, 0)
    // Raven assigns his own `forcedUse` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var forcedUse = forcedUse

    if ps.m_iVehicleNum != 0 {
        return 0
    }

    if (ps.pm_flags & PMF_USE_ITEM_HELD) != 0 { //force to let go first
        return 0
    }

    if ps.duelInProgress { //not allowed to use holdables while in a private duel.
        return 0
    }

    if forcedUse == 0 {
        forcedUse = bg_itemlist[ps.stats[STAT_HOLDABLE_ITEM]].giTag
    }

    if !BG_IsItemSelectable(ps, forcedUse) {
        return 0
    }

    switch forcedUse {
    case HI_MEDPAC, HI_MEDPAC_BIG:
        if ps.stats[STAT_HEALTH] >= ps.stats[STAT_MAX_HEALTH] {
            return 0
        }
        if ps.stats[STAT_HEALTH] <= 0
            || (ps.eFlags & EF_DEAD) != 0 {
            return 0
        }

        return 1

    case HI_SEEKER:
        if (ps.eFlags & EF_SEEKERDRONE) != 0 {
            PM_AddEventWithParm(EV_ITEMUSEFAIL, SEEKER_ALREADYDEPLOYED)
            return 0
        }

        return 1

    case HI_SENTRY_GUN:
        if ps.fd.sentryDeployed {
            PM_AddEventWithParm(EV_ITEMUSEFAIL, SENTRY_ALREADYPLACED)
            return 0
        }

        yawonly[ROLL] = 0
        yawonly[PITCH] = 0
        yawonly[YAW] = ps.viewangles[YAW]

        mins = JKAShared.vec3_t(-8, -8, 0)
        maxs = JKAShared.vec3_t(8, 8, 24)

        // Raven passes NULL for the last two outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
        var scratchRight = JKAShared.vec3_t(0, 0, 0)
        var scratchUp = JKAShared.vec3_t(0, 0, 0)
        AngleVectors(yawonly, &fwd, &scratchRight, &scratchUp)

        fwdorg[0] = ps.origin[0] + fwd[0] * 64
        fwdorg[1] = ps.origin[1] + fwd[1] * 64
        fwdorg[2] = ps.origin[2] + fwd[2] * 64

        trtest[0] = fwdorg[0] + fwd[0] * 16
        trtest[1] = fwdorg[1] + fwd[1] * 16
        trtest[2] = fwdorg[2] + fwd[2] * 16

        let noRoom = Trace.scratch { tr in
            pm.runTrace(tr, ps.origin, mins, maxs, trtest, ps.clientNum, MASK_PLAYERSOLID)

            // Port-note: `trace_t.entityNum` is an `Int16` and `clientNum` is an `Int32`. `Promotion.swift` carries no operator between the two, so the compare needs a widening Raven did not write.
            if (tr.fraction != 1 && Int32(tr.entityNum) != ps.clientNum) || tr.startsolid != 0 || tr.allsolid != 0 {
                PM_AddEventWithParm(EV_ITEMUSEFAIL, SENTRY_NOROOM)
                return true
            }

            return false
        }
        if noRoom {
            return 0
        }

        return 1

    case HI_SHIELD:
        mins[0] = -8
        mins[1] = -8
        mins[2] = 0

        maxs[0] = 8
        maxs[1] = 8
        maxs[2] = 8

        // Raven passes NULL for the last two outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
        var scratchRight = JKAShared.vec3_t(0, 0, 0)
        var scratchUp = JKAShared.vec3_t(0, 0, 0)
        AngleVectors(ps.viewangles, &fwd, &scratchRight, &scratchUp)
        fwd[2] = 0
        _VectorMA(ps.origin, 64, fwd, &dest)
        let roomFound = Trace.scratch { tr in
            pm.runTrace(tr, ps.origin, mins, maxs, dest, ps.clientNum, MASK_SHOT)
            if Double(tr.fraction) > 0.9 && tr.startsolid == 0 && tr.allsolid == 0 {
                pos = tr.endpos
                dest = JKAShared.vec3_t(pos[0], pos[1], pos[2] - 4096)
                pm.runTrace(tr, pos, mins, maxs, dest, ps.clientNum, MASK_SOLID)
                if tr.startsolid == 0 && tr.allsolid == 0 {
                    return true
                }
            }

            return false
        }
        if roomFound {
            return 1
        }
        PM_AddEventWithParm(EV_ITEMUSEFAIL, SHIELD_NOROOM)
        return 0

    case HI_JETPACK: //check for stuff here?
        return 1

    case HI_HEALTHDISP:
        return 1

    case HI_AMMODISP:
        return 1

    case HI_EWEB:
        return 1

    case HI_CLOAK: //check for stuff here?
        return 1

    default:
        return 1
    }
}

//cheesy vehicle weapon hackery
/// Source: oracle/codemp/game/bg_pmove.c:6369
func PM_CanSetWeaponAnims() -> Bool {
    let ps = pm.ps
    if ps.m_iVehicleNum != 0 {
        return false
    }

    return true
}

//perform player anim overrides while on vehicle.
/// Source: oracle/codemp/game/bg_pmove.c:6381
func PM_VehicleWeaponAnimate() {
    var iFlags: Int32 = 0, iBlend: Int32 = 0, Anim: Int32 = -1
    let ps = pm.ps
    guard let veh = pm_entVeh,
        let m_pVehicle = veh.m_pVehicle,
        let m_pPilot = m_pVehicle.m_pPilot,
        let pilotPS = m_pPilot.playerState,
        ps.clientNum == pilotPS.clientNum
    else {
        //make sure the vehicle exists, and its pilot is this player
        return
    }

    let pVeh = m_pVehicle

    // Port-note: Raven walks `pVeh->m_pVehicleInfo` with no guard. The generated field is optional, so the body binds it once here.
    guard let m_pVehicleInfo = pVeh.m_pVehicleInfo else {
        portMissing("PM_VehicleWeaponAnimate: pVeh->m_pVehicleInfo is NULL", source: "oracle/codemp/game/bg_pmove.c:6381")
    }

    if m_pVehicleInfo.type == VH_WALKER
        || m_pVehicleInfo.type == VH_FIGHTER {
        //slightly hacky I guess, but whatever.
        return
    }
    // Port-note: Raven writes the label `backAgain:` here and jumps back to it once, from the saber case. Rule 10 turns that jump into a loop that repeats the block.
    backAgain: while true {
        // If they're firing, play the right fire animation.
        if (pm.cmd.buttons & (BUTTON_ATTACK | BUTTON_ALT_ATTACK)) != 0 {
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD
            iBlend = 200

            switch ps.weapon {
            case WP_SABER:
                if (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 {
                    //don't do anything.. I guess.
                    pm.cmd.buttons &= ~BUTTON_ALT_ATTACK
                    continue backAgain
                }
                // If we're already in an attack animation, leave (let it continue).
                if ps.torsoTimer <= 0 {
                    //we'll be starting a new attack
                    PM_AddEvent(EV_SABER_ATTACK)
                }

                //just set it to something so we have a proper trail. This is a stupid
                //hack (much like the rest of this function)
                ps.saberMove = LS_R_TL2BR

                if ps.torsoTimer > 0 && (ps.torsoAnim == BOTH_VS_ATR_S
                        || ps.torsoAnim == BOTH_VS_ATL_S) {
                    /*
                    //FIXME: no need to even call the PM_SetAnim at all in this case
                    Anim = (animNumber_t)pm->ps->torsoAnim;
                    iFlags = SETANIM_FLAG_NORMAL;
                    break;
                    */
                    return
                }

                // Start the attack.
                if pm.cmd.rightmove > 0 { //right side attack
                    Anim = BOTH_VS_ATR_S
                } else if pm.cmd.rightmove < 0 { //left-side attack
                    Anim = BOTH_VS_ATL_S
                } else { //random
                    //FIXME: alternate back and forth or auto-aim?
                    //if ( !Q_irand( 0, 1 ) )
                    if PM_irand_timesync(0, 1) == 0 {
                        Anim = BOTH_VS_ATR_S
                    } else {
                        Anim = BOTH_VS_ATL_S
                    }
                }

                if ps.torsoTimer <= 0 {
                    //restart the anim if we are already in it (and finished)
                    iFlags |= SETANIM_FLAG_RESTART
                }

            case WP_BLASTER:
                // Override the shoot anim.
                if ps.torsoAnim == BOTH_ATTACK3 {
                    if pm.cmd.rightmove > 0 { //right side attack
                        Anim = BOTH_VS_ATR_G
                    } else if pm.cmd.rightmove < 0 { //left side
                        Anim = BOTH_VS_ATL_G
                    } else { //frontal
                        Anim = BOTH_VS_ATF_G
                    }
                }

            default:
                Anim = BOTH_VS_IDLE
            }
        } else if let vehPS = veh.playerState, vehPS.speed < 0,
            m_pVehicleInfo.type == VH_ANIMAL {
            //tauntaun is going backwards
            Anim = BOTH_VT_WALK_REV
            iBlend = 600
        } else if let vehPS = veh.playerState, vehPS.speed < 0,
            m_pVehicleInfo.type == VH_SPEEDER {
            //speeder is going backwards
            Anim = BOTH_VS_REV
            iBlend = 600
        }
        // They're not firing so play the Idle for the weapon.
        else {
            iFlags = SETANIM_FLAG_NORMAL

            switch ps.weapon {
            case WP_SABER:
                if BG_SabersOff(ps) {
                    //saber holstered, normal idle
                    Anim = BOTH_VS_IDLE
                }
                // In the Air.
                //else if ( pVeh->m_ulFlags & VEH_FLYING )
                else if false {
                    iBlend = 800
                    Anim = BOTH_VS_AIR_G
                    iFlags = SETANIM_FLAG_OVERRIDE
                }
                // Crashing.
                //else if ( pVeh->m_ulFlags & VEH_CRASHING )
                else if false {
                    // Port-note: `m_ulFlags` is an `unsigned long` and `VEH_CRASHING` is an `int` case, so the mask needs a widening Raven did not write.
                    pVeh.m_ulFlags &= ~UInt(VEH_CRASHING) // Remove the flag, we are doing the animation.
                    iBlend = 800
                    Anim = BOTH_VS_LAND_SR
                    iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD
                } else {
                    Anim = BOTH_VS_IDLE_SR
                }

            case WP_BLASTER:
                // In the Air.
                //if ( pVeh->m_ulFlags & VEH_FLYING )
                if false {
                    iBlend = 800
                    Anim = BOTH_VS_AIR_G
                    iFlags = SETANIM_FLAG_OVERRIDE
                }
                // Crashing.
                //else if ( pVeh->m_ulFlags & VEH_CRASHING )
                else if false {
                    pVeh.m_ulFlags &= ~UInt(VEH_CRASHING) // Remove the flag, we are doing the animation.
                    iBlend = 800
                    Anim = BOTH_VS_LAND_G
                    iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD
                } else {
                    Anim = BOTH_VS_IDLE_G
                }

            default:
                Anim = BOTH_VS_IDLE
            }
        }
        break backAgain
    }

    if Anim != -1 {
        //override it
        if m_pVehicleInfo.type == VH_ANIMAL {
            //agh.. remap anims for the tauntaun
            switch Anim {
            case BOTH_VS_IDLE:
                if let vehPS = veh.playerState, vehPS.speed > 0 {
                    if vehPS.speed > m_pVehicleInfo.speedMax {
                        //turbo
                        Anim = BOTH_VT_TURBO
                    } else {
                        Anim = BOTH_VT_RUN_FWD
                    }
                } else {
                    Anim = BOTH_VT_IDLE
                }

            case BOTH_VS_ATR_S:
                Anim = BOTH_VT_ATR_S

            case BOTH_VS_ATL_S:
                Anim = BOTH_VT_ATL_S

            case BOTH_VS_ATR_G:
                Anim = BOTH_VT_ATR_G

            case BOTH_VS_ATL_G:
                Anim = BOTH_VT_ATL_G

            case BOTH_VS_ATF_G:
                Anim = BOTH_VT_ATF_G

            case BOTH_VS_IDLE_SL:
                Anim = BOTH_VT_IDLE_S

            case BOTH_VS_IDLE_SR:
                Anim = BOTH_VT_IDLE_S

            case BOTH_VS_IDLE_G:
                Anim = BOTH_VT_IDLE_G

            //should not happen for tauntaun:
            case BOTH_VS_AIR_G, BOTH_VS_LAND_SL, BOTH_VS_LAND_SR, BOTH_VS_LAND_G:
                return

            default:
                break
            }
        }

        PM_SetAnim(SETANIM_BOTH, Anim, iFlags, iBlend)
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:6641
private func PM_Weapon() {
    // Port-note: The game arm of Raven's first `#ifdef QAGAME` casts `pm_entSelf` to `gentity_t *` and reads `inuse` and `client`. The `Entity` view lives in the game target, which the bg target cannot import.
    // Port-note: The cgame arm of the second `#ifdef QAGAME` reads `g_vehWeaponInfo`, a file-scope table of `bg_vehicles.c`. That name is in no manifest yet, so it has no Swift spelling.
    // TODO: Port PM_Weapon
    portMissing("PM_Weapon", source: "oracle/codemp/game/bg_pmove.c:6641")
}

/// Source: oracle/codemp/game/bg_pmove.c:7680
private func PM_Animate() {
    let ps = pm.ps
    if (pm.cmd.buttons & BUTTON_GESTURE) != 0 {
        if ps.m_iVehicleNum != 0 {
            //eh, fine, clear it
            if ps.forceHandExtendTime < pm.cmd.serverTime {
                ps.forceHandExtend = HANDEXTEND_NONE
            }
        }

        if ps.torsoTimer < 1 && ps.forceHandExtend == HANDEXTEND_NONE
            && ps.legsTimer < 1 && ps.weaponTime < 1 && ps.saberLockTime < pm.cmd.serverTime {

            ps.forceHandExtend = HANDEXTEND_TAUNT

            //FIXME: random taunt anims?
            ps.forceDodgeAnim = BOTH_ENGAGETAUNT

            ps.forceHandExtendTime = pm.cmd.serverTime + 1000

            //pm->ps->weaponTime = 100;

            PM_AddEvent(EV_TAUNT)
        }
    }
}

/**
```
================
PM_DropTimers
================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:7748
private func PM_DropTimers() {
    let ps = pm.ps
    // drop misc timing counter
    if ps.pm_time != 0 {
        if bg.pml.msec >= ps.pm_time {
            ps.pm_flags &= ~PMF_ALL_TIMES
            ps.pm_time = 0
        } else {
            ps.pm_time -= bg.pml.msec
        }
    }

    // drop animation counter
    if ps.legsTimer > 0 {
        ps.legsTimer -= bg.pml.msec
        if ps.legsTimer < 0 {
            ps.legsTimer = 0
        }
    }

    if ps.torsoTimer > 0 {
        ps.torsoTimer -= bg.pml.msec
        if ps.torsoTimer < 0 {
            ps.torsoTimer = 0
        }
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:7784
func BG_UnrestrainedPitchRoll(_ ps: JKAMP.PlayerState, _ pVeh: JKAMP.Vehicle) -> Bool {
    // Port-note: Raven guards a NULL `pVeh` here. The view is non-optional, so that half of the guard has no Swift form.
    if bg_fighterAltControl.integer != 0
        && ps.clientNum < MAX_CLIENTS //real client
        && ps.m_iVehicleNum != 0//in a vehicle
        && pVeh.m_pVehicleInfo != nil//valid vehicle info
        && pVeh.m_pVehicleInfo?.type == VH_FIGHTER {//fighter
        //FIXME: specify per vehicle instead of assuming true for all fighters
        //FIXME: map/server setting?
        //can roll and pitch without limitation!
        return true
    }
    return false
}

/**
```
================
PM_UpdateViewAngles

This can be used as another entry point when only the viewangles
are being updated isntead of a full move
================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:7813
func PM_UpdateViewAngles(_ ps: JKAMP.PlayerState, _ cmd: JKAMP.Usercmd) {
    var temp: Int16
    var i: Int32

    if ps.pm_type == PM_INTERMISSION || ps.pm_type == PM_SPINTERMISSION {
        return // no view changes at all
    }

    if ps.pm_type != PM_SPECTATOR && ps.stats[STAT_HEALTH] <= 0 {
        return // no view changes at all
    }

    // circularly clamp the angles with deltas
    i = 0
    while i < 3 {
        // C truncates the `int` sum into the `short`, so the port does the same.
        temp = Int16(truncatingIfNeeded: cmd.angles[i] + ps.delta_angles[i])
        // Port-note: Raven passes a possibly NULL `m_pVehicle` to `BG_UnrestrainedPitchRoll`, which answers false for NULL. The generated field is optional, so the body binds it, and the nil path takes the same arm.
        if let pm_entVeh = pm_entVeh, let m_pVehicle = pm_entVeh.m_pVehicle,
            BG_UnrestrainedPitchRoll(ps, m_pVehicle) {
            //in a fighter
            /*
            if ( i == ROLL )
            {//get roll from vehicle
                ps->viewangles[ROLL] = pm_entVeh->playerState->viewangles[ROLL];//->m_pVehicle->m_vOrientation[ROLL];
                continue;

            }
            */
        } else {
            if i == PITCH {
                // don't let the player look up or down more than 90 degrees
                if temp > 16000 {
                    ps.delta_angles[i] = 16000 - cmd.angles[i]
                    temp = 16000
                } else if temp < -16000 {
                    ps.delta_angles[i] = -16000 - cmd.angles[i]
                    temp = -16000
                }
            }
        }
        ps.viewangles[i] = SHORT2ANGLE(Int32(temp))
        i += 1
    }
}

//-------------------------------------------
/// Source: oracle/codemp/game/bg_pmove.c:8031
func PM_AdjustAttackStates(_ pm: JKAMP.Pmove) {
    var amount: Int32
    let ps = pm.ps
    // Port-note: Raven reads `pm_entSelf->s.NPC_class` with no guard. The state property is optional, so the body binds it, and the nil path takes the same arm.
    if let pm_entSelf = pm_entSelf, pm_entSelf.s.NPC_class != CLASS_VEHICLE,
        ps.m_iVehicleNum != 0 {
        //riding a vehicle
        let veh: JKAMP.BgEntity? = pm_entVeh
        // Port-note: Raven reads `m_pVehicleInfo->type` with no guard, so the body binds the optional field, and the nil path skips the early return.
        if let veh,
            let m_pVehicle = veh.m_pVehicle,
            let m_pVehicleInfo = m_pVehicle.m_pVehicleInfo,
            (m_pVehicleInfo.type == VH_WALKER || m_pVehicleInfo.type == VH_FIGHTER) {
            //riding a walker/fighter
            //not firing, ever
            ps.eFlags &= ~(EF_FIRING | EF_ALT_FIRING)
            return
        }
    }
    // get ammo usage
    if (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 {
        amount = ps.ammo[weaponData[ps.weapon].ammoIndex] - weaponData[ps.weapon].altEnergyPerShot
    } else {
        amount = ps.ammo[weaponData[ps.weapon].ammoIndex] - weaponData[ps.weapon].energyPerShot
    }

    // disruptor alt-fire should toggle the zoom mode, but only bother doing this for the player?
    if ps.weapon == WP_DISRUPTOR && ps.weaponstate == WEAPON_READY {
        if (ps.eFlags & EF_ALT_FIRING) == 0 && (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 /*&&
            pm->cmd.upmove <= 0 && !pm->cmd.forwardmove && !pm->cmd.rightmove*/ {
            // We just pressed the alt-fire key
            if ps.zoomMode == 0 && ps.pm_type != PM_DEAD {
                // not already zooming, so do it now
                ps.zoomMode = 1
                ps.zoomLocked = false
                ps.zoomFov = 80.0//cg_fov.value;
                ps.zoomLockTime = pm.cmd.serverTime + 50
                PM_AddEvent(EV_DISRUPTOR_ZOOMSOUND)
            } else if ps.zoomMode == 1 && ps.zoomLockTime < pm.cmd.serverTime {
                //check for == 1 so we can't turn binoculars off with disruptor alt fire
                // already zooming, so must be wanting to turn it off
                ps.zoomMode = 0
                ps.zoomTime = ps.commandTime
                ps.zoomLocked = false
                PM_AddEvent(EV_DISRUPTOR_ZOOMSOUND)
                ps.weaponTime = 1000
            }
        } else if (pm.cmd.buttons & BUTTON_ALT_ATTACK) == 0 && ps.zoomLockTime < pm.cmd.serverTime {
            // Not pressing zoom any more
            if ps.zoomMode != 0 {
                if ps.zoomMode == 1 && !ps.zoomLocked {
                    //approximate what level the client should be zoomed at based on how long zoom was held
                    ps.zoomFov = ((pm.cmd.serverTime + 50) - ps.zoomLockTime) * 0.035
                    if ps.zoomFov > 50 {
                        ps.zoomFov = 50
                    }
                    if ps.zoomFov < 1 {
                        ps.zoomFov = 1
                    }
                }
                // were zooming in, so now lock the zoom
                ps.zoomLocked = true
            }
        }
        //This seemed like a good idea, but apparently it confuses people. So disabled for now.
        /*
        else if (!(pm->ps->eFlags & EF_ALT_FIRING) && (pm->cmd.buttons & BUTTON_ALT_ATTACK) &&
            (pm->cmd.upmove > 0 || pm->cmd.forwardmove || pm->cmd.rightmove))
        { //if you try to zoom while moving, just convert it into a primary attack
            pm->cmd.buttons &= ~BUTTON_ALT_ATTACK;
            pm->cmd.buttons |= BUTTON_ATTACK;
        }
        */

        /*
        if (pm->cmd.upmove > 0 || pm->cmd.forwardmove || pm->cmd.rightmove)
        {
            if (pm->ps->zoomMode == 1 && pm->ps->zoomLockTime < pm->cmd.serverTime)
            { //check for == 1 so we can't turn binoculars off with disruptor alt fire
                pm->ps->zoomMode = 0;
                pm->ps->zoomTime = pm->ps->commandTime;
                pm->ps->zoomLocked = qfalse;
                PM_AddEvent(EV_DISRUPTOR_ZOOMSOUND);
            }
        }
        */

        if (pm.cmd.buttons & BUTTON_ATTACK) != 0 {
            // If we are zoomed, we should switch the ammo usage to the alt-fire, otherwise, we'll
            //	just use whatever ammo was selected from above
            if ps.zoomMode != 0 {
                amount = ps.ammo[weaponData[ps.weapon].ammoIndex]
                            - weaponData[ps.weapon].altEnergyPerShot
            }
        } else {
            // alt-fire button pressing doesn't use any ammo
            amount = 0
        }
    }

    // set the firing flag for continuous beam weapons, saber will fire even if out of ammo
    if (ps.pm_flags & PMF_RESPAWNED) == 0
            && ps.pm_type != PM_INTERMISSION
            && (pm.cmd.buttons & (BUTTON_ATTACK | BUTTON_ALT_ATTACK)) != 0
            && (amount >= 0 || ps.weapon == WP_SABER) {
        if (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 {
            ps.eFlags |= EF_ALT_FIRING
        } else {
            ps.eFlags &= ~EF_ALT_FIRING
        }

        // This flag should always get set, even when alt-firing
        ps.eFlags |= EF_FIRING
    } else {
        // Clear 'em out
        ps.eFlags &= ~(EF_FIRING | EF_ALT_FIRING)
    }

    // disruptor should convert a main fire to an alt-fire if the gun is currently zoomed
    if ps.weapon == WP_DISRUPTOR {
        if (pm.cmd.buttons & BUTTON_ATTACK) != 0 && ps.zoomMode == 1 && ps.zoomLocked {
            // converting the main fire to an alt-fire
            pm.cmd.buttons |= BUTTON_ALT_ATTACK
            ps.eFlags |= EF_ALT_FIRING
        } else if (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 && ps.zoomMode == 1 && ps.zoomLocked {
            pm.cmd.buttons &= ~BUTTON_ALT_ATTACK
            ps.eFlags &= ~EF_ALT_FIRING
        }
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:8201
func BG_CmdForRoll(_ ps: JKAMP.PlayerState, _ anim: Int32, _ pCmd: JKAMP.Usercmd) {
    // Port-note: Raven's `pCmd->forwardmove = pCmd->rightmove = 0` chain is written as two stores here.
    switch (anim) {
    case BOTH_ROLL_F:
        pCmd.forwardmove = 127
        pCmd.rightmove = 0

    case BOTH_ROLL_B:
        pCmd.forwardmove = -127
        pCmd.rightmove = 0

    case BOTH_ROLL_R:
        pCmd.forwardmove = 0
        pCmd.rightmove = 127

    case BOTH_ROLL_L:
        pCmd.forwardmove = 0
        pCmd.rightmove = -127

    case BOTH_GETUP_BROLL_R:
        pCmd.forwardmove = 0
        pCmd.rightmove = 48
        //NOTE: speed is 400

    case BOTH_GETUP_FROLL_R:
        if ps.legsTimer <= 250 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            pCmd.forwardmove = 0
            pCmd.rightmove = 48
            //NOTE: speed is 400
        }

    case BOTH_GETUP_BROLL_L:
        pCmd.forwardmove = 0
        pCmd.rightmove = -48
        //NOTE: speed is 400

    case BOTH_GETUP_FROLL_L:
        if ps.legsTimer <= 250 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            pCmd.forwardmove = 0
            pCmd.rightmove = -48
            //NOTE: speed is 400
        }

    case BOTH_GETUP_BROLL_B:
        if ps.torsoTimer <= 250 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else if PM_AnimLength(0, ps.legsAnim) - ps.torsoTimer < 350 {
            //beginning of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            //FIXME: ramp down over length of anim
            pCmd.forwardmove = -64
            pCmd.rightmove = 0
            //NOTE: speed is 400
        }

    case BOTH_GETUP_FROLL_B:
        if ps.torsoTimer <= 100 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else if PM_AnimLength(0, ps.legsAnim) - ps.torsoTimer < 200 {
            //beginning of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            //FIXME: ramp down over length of anim
            pCmd.forwardmove = -64
            pCmd.rightmove = 0
            //NOTE: speed is 400
        }

    case BOTH_GETUP_BROLL_F:
        if ps.torsoTimer <= 550 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else if PM_AnimLength(0, ps.legsAnim) - ps.torsoTimer < 150 {
            //beginning of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            pCmd.forwardmove = 64
            pCmd.rightmove = 0
            //NOTE: speed is 400
        }

    case BOTH_GETUP_FROLL_F:
        if ps.torsoTimer <= 100 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            //FIXME: ramp down over length of anim
            pCmd.forwardmove = 64
            pCmd.rightmove = 0
            //NOTE: speed is 400
        }

    default:
        break
    }
    pCmd.upmove = 0
}

/// Source: oracle/codemp/game/bg_pmove.c:8331
func BG_AdjustClientSpeed(_ ps: JKAMP.PlayerState, _ cmd: JKAMP.Usercmd, _ svTime: Int32) {
    var saber: JKAMP.SaberInfo?
    let pmPS = pm.ps
    if ps.clientNum >= MAX_CLIENTS {
        let bgEnt: JKAMP.BgEntity? = pm_entSelf

        if let bgEnt, bgEnt.s.NPC_class == CLASS_VEHICLE {
            //vehicles manage their own speed
            return
        }
    }

    //For prediction, always reset speed back to the last known server base speed
    //If we didn't do this, under lag we'd eventually dwindle speed down to 0 even though
    //that would not be the correct predicted value.
    ps.speed = Float(ps.basespeed)

    if ps.forceHandExtend == HANDEXTEND_DODGE {
        ps.speed = 0
    }

    if ps.forceHandExtend == HANDEXTEND_KNOCKDOWN
        || ps.forceHandExtend == HANDEXTEND_PRETHROWN
        || ps.forceHandExtend == HANDEXTEND_POSTTHROWN {
        ps.speed = 0
    }


    if cmd.forwardmove < 0 && (cmd.buttons & BUTTON_WALKING) == 0 && pmPS.groundEntityNum != ENTITYNUM_NONE {
        //running backwards is slower than running forwards (like SP)
        // Raven wrote no `f` suffix here, so C works the product in double. Every line below with a bare literal does the same.
        ps.speed = Float(Double(ps.speed) * 0.75)
    }

    if (ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 {
        ps.speed = Float(Double(ps.speed) * 0.4)
    }

    if (ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
        ps.speed = Float(Double(ps.speed) * 1.7)
    } else if (ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
        ps.speed = Float(Double(ps.speed) * 1.3)
    } else if ps.fd.forceRageRecoveryTime > svTime {
        ps.speed = Float(Double(ps.speed) * 0.75)
    }

    if pmPS.weapon == WP_DISRUPTOR
        && pmPS.zoomMode == 1 && pmPS.zoomLockTime < pm.cmd.serverTime {
        ps.speed *= 0.5
    }

    if ps.fd.forceGripCripple != 0 {
        if (ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
            ps.speed = Float(Double(ps.speed) * 0.9)
        } else if (ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
            //force speed will help us escape
            ps.speed = Float(Double(ps.speed) * 0.8)
        } else {
            ps.speed = Float(Double(ps.speed) * 0.2)
        }
    }

    if BG_SaberInAttack(ps.saberMove) && cmd.forwardmove < 0 {
        //if running backwards while attacking, don't run as fast.
        switch ps.fd.saberAnimLevel {
        case FORCE_LEVEL_1:
            ps.speed *= 0.75

        case FORCE_LEVEL_2, SS_DUAL, SS_STAFF:
            ps.speed *= 0.60

        case FORCE_LEVEL_3:
            ps.speed *= 0.45

        default:
            break
        }
    } else if BG_SpinningSaberAnim(ps.legsAnim) {
        if ps.fd.saberAnimLevel == FORCE_LEVEL_3 {
            ps.speed *= 0.3
        } else {
            ps.speed *= 0.5
        }
    } else if ps.weapon == WP_SABER && BG_SaberInAttack(ps.saberMove) {
        //if attacking with saber while running, drop your speed
        switch ps.fd.saberAnimLevel {
        case FORCE_LEVEL_2, SS_DUAL, SS_STAFF:
            ps.speed *= 0.85

        case FORCE_LEVEL_3:
            ps.speed *= 0.55

        default:
            break
        }
    } else if ps.weapon == WP_SABER && ps.fd.saberAnimLevel == FORCE_LEVEL_3
        && PM_SaberInTransition(ps.saberMove) {
        //Now, we want to even slow down in transitions for level 3 (since it has chains and stuff now)
        if cmd.forwardmove < 0 {
            ps.speed *= 0.4
        } else {
            ps.speed *= 0.6
        }
    }

    if BG_InRoll(ps, ps.legsAnim) && ps.speed > 50 {
        //can't roll unless you're able to move normally
        if (ps.legsAnim) == BOTH_ROLL_B {
            //backwards roll is pretty fast, should also be slower
            if ps.legsTimer > 800 {
                ps.speed = Float(Double(ps.legsTimer) / 2.5)
            } else {
                ps.speed = Float(Double(ps.legsTimer) / 6.0)//450;
            }
        } else {
            if ps.legsTimer > 800 {
                ps.speed = Float(Double(ps.legsTimer) / 1.5)//450;
            } else {
                ps.speed = Float(Double(ps.legsTimer) / 5.0)//450;
            }
        }
        if ps.speed > 600 {
            ps.speed = 600
        }
        //Automatically slow down as the roll ends.
    }

    saber = BG_MySaber(ps.clientNum, 0)
    if let saber,
        saber.moveSpeedScale != 1.0 {
        ps.speed *= saber.moveSpeedScale
    }
    saber = BG_MySaber(ps.clientNum, 1)
    if let saber,
        saber.moveSpeedScale != 1.0 {
        ps.speed *= saber.moveSpeedScale
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:8512
func BG_InRollAnim(_ cent: JKAMP.EntityState) -> Bool {
    switch (cent.legsAnim) {
    case BOTH_ROLL_F,
         BOTH_ROLL_B,
         BOTH_ROLL_R,
         BOTH_ROLL_L:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:8525
func BG_InKnockDown(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_KNOCKDOWN1,
         BOTH_KNOCKDOWN2,
         BOTH_KNOCKDOWN3,
         BOTH_KNOCKDOWN4,
         BOTH_KNOCKDOWN5:
        return true
    case BOTH_GETUP1,
         BOTH_GETUP2,
         BOTH_GETUP3,
         BOTH_GETUP4,
         BOTH_GETUP5,
         BOTH_FORCE_GETUP_F1,
         BOTH_FORCE_GETUP_F2,
         BOTH_FORCE_GETUP_B1,
         BOTH_FORCE_GETUP_B2,
         BOTH_FORCE_GETUP_B3,
         BOTH_FORCE_GETUP_B4,
         BOTH_FORCE_GETUP_B5,
         BOTH_GETUP_BROLL_B,
         BOTH_GETUP_BROLL_F,
         BOTH_GETUP_BROLL_L,
         BOTH_GETUP_BROLL_R,
         BOTH_GETUP_FROLL_B,
         BOTH_GETUP_FROLL_F,
         BOTH_GETUP_FROLL_L,
         BOTH_GETUP_FROLL_R:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:8562
func BG_InRollES(_ ps: JKAMP.EntityState, _ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_ROLL_F,
         BOTH_ROLL_B,
         BOTH_ROLL_R,
         BOTH_ROLL_L:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:8576
func BG_IK_MoveArm(_ ghoul2: OpaquePointer?, _ lHandBolt: Int32, _ time: Int32, _ ent: JKAMP.EntityState, _ basePose: Int32, _ desiredPos: inout JKAShared.vec3_t, _ ikInProgress: inout Bool, _ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t, _ scale: inout JKAShared.vec3_t, _ blendTime: Int32, _ forceHalt: Bool) {
    // Port-note: The body reads `bgHumanoidAnimations[basePose]`, the animation table of `bg_panimate.c`. That table is still a `TODO: Port global` entry with no Swift name, so the first arm has no spelling.
    // Port-note: Raven passes NULL for the bone name of `strap_G2API_SetBoneIKState`. The generated parameter is a non-optional `String`, so that call has no Swift form.
    // Port-note: Raven passes NULL for the parameter record of `strap_G2API_SetBoneIKState`. The generated parameter is a non-optional `JKAMP.SharedSetBoneIKStateParams`, so that call has no Swift form.
    // TODO: Port BG_IK_MoveArm
    portMissing("BG_IK_MoveArm", source: "oracle/codemp/game/bg_pmove.c:8576")
}

//Adjust the head/neck desired angles
/// Source: oracle/codemp/game/bg_pmove.c:8733
func BG_UpdateLookAngles(_ lookingDebounceTime: Int32, _ lastHeadAngles: inout JKAShared.vec3_t, _ time: Int32, _ lookAngles: inout JKAShared.vec3_t, _ lookSpeed: Float, _ minPitch: Float, _ maxPitch: Float, _ minYaw: Float, _ maxYaw: Float, _ minRoll: Float, _ maxRoll: Float) {
    let fFrameInter: Float = 0.1
    var oldLookAngles = JKAShared.vec3_t(0, 0, 0)
    var lookAnglesDiff = JKAShared.vec3_t(0, 0, 0)
    var ang: Int32 = 0

    if lookingDebounceTime > time {
        //clamp so don't get "Exorcist" effect
        if lookAngles[PITCH] > maxPitch {
            lookAngles[PITCH] = maxPitch
        } else if lookAngles[PITCH] < minPitch {
            lookAngles[PITCH] = minPitch
        }
        if lookAngles[YAW] > maxYaw {
            lookAngles[YAW] = maxYaw
        } else if lookAngles[YAW] < minYaw {
            lookAngles[YAW] = minYaw
        }
        if lookAngles[ROLL] > maxRoll {
            lookAngles[ROLL] = maxRoll
        } else if lookAngles[ROLL] < minRoll {
            lookAngles[ROLL] = minRoll
        }

        //slowly lerp to this new value
        //Remember last headAngles
        oldLookAngles = lastHeadAngles
        lookAnglesDiff = lookAngles - oldLookAngles

        ang = 0
        while ang < 3 {
            lookAnglesDiff[ang] = AngleNormalize180(lookAnglesDiff[ang])
            ang += 1
        }

        if VectorLengthSquared(lookAnglesDiff) != 0 {
            lookAngles[PITCH] = AngleNormalize180(oldLookAngles[PITCH] + (lookAnglesDiff[PITCH] * fFrameInter * lookSpeed))
            lookAngles[YAW] = AngleNormalize180(oldLookAngles[YAW] + (lookAnglesDiff[YAW] * fFrameInter * lookSpeed))
            lookAngles[ROLL] = AngleNormalize180(oldLookAngles[ROLL] + (lookAnglesDiff[ROLL] * fFrameInter * lookSpeed))
        }
    }
    //Remember current lookAngles next time
    lastHeadAngles = lookAngles
}

//for setting visual look (headturn) angles
/// Source: oracle/codemp/game/bg_pmove.c:8790
private func BG_G2ClientNeckAngles(_ ghoul2: OpaquePointer?, _ time: Int32, _ lookAngles: JKAShared.vec3_t, _ headAngles: inout JKAShared.vec3_t, _ neckAngles: inout JKAShared.vec3_t, _ thoracicAngles: inout JKAShared.vec3_t, _ headClampMinAngles: inout JKAShared.vec3_t, _ headClampMaxAngles: inout JKAShared.vec3_t) {
    var lA = JKAShared.vec3_t(0, 0, 0)
    lA = lookAngles
    //clamp the headangles (which should now be relative to the cervical (neck) angles
    if lA[PITCH] < headClampMinAngles[PITCH] {
        lA[PITCH] = headClampMinAngles[PITCH]
    } else if lA[PITCH] > headClampMaxAngles[PITCH] {
        lA[PITCH] = headClampMaxAngles[PITCH]
    }

    if lA[YAW] < headClampMinAngles[YAW] {
        lA[YAW] = headClampMinAngles[YAW]
    } else if lA[YAW] > headClampMaxAngles[YAW] {
        lA[YAW] = headClampMaxAngles[YAW]
    }

    if lA[ROLL] < headClampMinAngles[ROLL] {
        lA[ROLL] = headClampMinAngles[ROLL]
    } else if lA[ROLL] > headClampMaxAngles[ROLL] {
        lA[ROLL] = headClampMaxAngles[ROLL]
    }

    //split it up between the neck and cranium
    // Raven wrote no `f` suffix on 0.4, 0.1, and 0.6, so C works those products in double. The port keeps that.
    if thoracicAngles[PITCH] != 0 {
        //already been set above, blend them
        thoracicAngles[PITCH] = Float((Double(thoracicAngles[PITCH]) + (Double(lA[PITCH]) * 0.4)) * 0.5)
    } else {
        thoracicAngles[PITCH] = Float(Double(lA[PITCH]) * 0.4)
    }
    if thoracicAngles[YAW] != 0 {
        //already been set above, blend them
        thoracicAngles[YAW] = Float((Double(thoracicAngles[YAW]) + (Double(lA[YAW]) * 0.1)) * 0.5)
    } else {
        thoracicAngles[YAW] = Float(Double(lA[YAW]) * 0.1)
    }
    if thoracicAngles[ROLL] != 0 {
        //already been set above, blend them
        thoracicAngles[ROLL] = Float((Double(thoracicAngles[ROLL]) + (Double(lA[ROLL]) * 0.1)) * 0.5)
    } else {
        thoracicAngles[ROLL] = Float(Double(lA[ROLL]) * 0.1)
    }

    neckAngles[PITCH] = lA[PITCH] * 0.2
    neckAngles[YAW] = lA[YAW] * 0.3
    neckAngles[ROLL] = lA[ROLL] * 0.3

    headAngles[PITCH] = Float(Double(lA[PITCH]) * 0.4)
    headAngles[YAW] = Float(Double(lA[YAW]) * 0.6)
    headAngles[ROLL] = Float(Double(lA[ROLL]) * 0.6)

    /* //non-applicable SP code
    if ( G_RidingVehicle( cent->gent ) )// && type == VH_SPEEDER ?
    {//aim torso forward too
        headAngles[YAW] = neckAngles[YAW] = thoracicAngles[YAW] = 0;
    }
    */

    strap_G2API_SetBoneAngles(ghoul2, 0, "cranium", headAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
    strap_G2API_SetBoneAngles(ghoul2, 0, "cervical", neckAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
    strap_G2API_SetBoneAngles(ghoul2, 0, "thoracic", thoracicAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
}

//rww - Finally decided to convert all this stuff to BG form.
/// Source: oracle/codemp/game/bg_pmove.c:8869
private func BG_G2ClientSpineAngles(_ ghoul2: OpaquePointer?, _ motionBolt: Int32, _ cent_lerpOrigin: inout JKAShared.vec3_t, _ cent_lerpAngles: inout JKAShared.vec3_t, _ cent: JKAMP.EntityState, _ time: Int32, _ viewAngles: inout JKAShared.vec3_t, _ ciLegs: Int32, _ ciTorso: Int32, _ angles: JKAShared.vec3_t, _ thoracicAngles: inout JKAShared.vec3_t, _ ulAngles: inout JKAShared.vec3_t, _ llAngles: inout JKAShared.vec3_t, _ modelScale: inout JKAShared.vec3_t, _ tPitchAngle: inout Float, _ tYawAngle: inout Float, _ corrTime: inout Int32) {
    var doCorr: Bool = false

    //*tPitchAngle = viewAngles[PITCH];
    viewAngles[YAW] = AngleDelta(cent_lerpAngles[YAW], angles[YAW])
    //*tYawAngle = viewAngles[YAW];

    if !BG_FlippingAnim(cent.legsAnim) &&
        !BG_SpinningSaberAnim(cent.legsAnim) &&
        !BG_SpinningSaberAnim(cent.torsoAnim) &&
        !BG_InSpecialJump(cent.legsAnim) &&
        !BG_InSpecialJump(cent.torsoAnim) &&
        !BG_InDeathAnim(cent.legsAnim) &&
        !BG_InDeathAnim(cent.torsoAnim) &&
        !BG_InRollES(cent, cent.legsAnim) &&
        !BG_InRollAnim(cent) &&
        !BG_SaberInSpecial(cent.saberMove) &&
        !BG_SaberInSpecialAttack(cent.torsoAnim) &&
        !BG_SaberInSpecialAttack(cent.legsAnim) &&

        !BG_InKnockDown(cent.torsoAnim) &&
        !BG_InKnockDown(cent.legsAnim) &&
        !BG_InKnockDown(ciTorso) &&
        !BG_InKnockDown(ciLegs) &&

        !BG_FlippingAnim(ciLegs) &&
        !BG_SpinningSaberAnim(ciLegs) &&
        !BG_SpinningSaberAnim(ciTorso) &&
        !BG_InSpecialJump(ciLegs) &&
        !BG_InSpecialJump(ciTorso) &&
        !BG_InDeathAnim(ciLegs) &&
        !BG_InDeathAnim(ciTorso) &&
        !BG_SaberInSpecialAttack(ciTorso) &&
        !BG_SaberInSpecialAttack(ciLegs) &&

        (cent.eFlags & EF_DEAD) == 0 &&
        (cent.legsAnim) != (cent.torsoAnim) &&
        (ciLegs) != (ciTorso) &&
        cent.m_iVehicleNum == 0 {
        doCorr = true
    }

    if doCorr {
        //FIXME: no need to do this if legs and torso on are same frame
        //adjust for motion offset
        JKAMP.MdxaBone.scratch { boltMatrix in
            var motionFwd = JKAShared.vec3_t(0, 0, 0)
            var motionAngles = JKAShared.vec3_t(0, 0, 0)
            var motionRt = JKAShared.vec3_t(0, 0, 0)
            var tempAng = JKAShared.vec3_t(0, 0, 0)
            var ang: Int32 = 0

            strap_G2API_GetBoltMatrix_NoRecNoRot(ghoul2, 0, motionBolt, boltMatrix, vec3_origin, cent_lerpOrigin, time, nil, &modelScale)
            //BG_GiveMeVectorFromMatrix( &boltMatrix, NEGATIVE_Y, motionFwd );
            motionFwd[0] = -boltMatrix.matrix[0][1]
            motionFwd[1] = -boltMatrix.matrix[1][1]
            motionFwd[2] = -boltMatrix.matrix[2][1]

            vectoangles(motionFwd, &motionAngles)

            //BG_GiveMeVectorFromMatrix( &boltMatrix, NEGATIVE_X, motionRt );
            motionRt[0] = -boltMatrix.matrix[0][0]
            motionRt[1] = -boltMatrix.matrix[1][0]
            motionRt[2] = -boltMatrix.matrix[2][0]

            vectoangles(motionRt, &tempAng)
            motionAngles[ROLL] = -tempAng[PITCH]

            ang = 0
            while ang < 3 {
                viewAngles[ang] = AngleNormalize180(viewAngles[ang] - AngleNormalize180(motionAngles[ang]))
                ang += 1
            }
        }
    }

    //distribute the angles differently up the spine
    //NOTE: each of these distributions must add up to 1.0f
    thoracicAngles[PITCH] = viewAngles[PITCH] * 0.20
    llAngles[PITCH] = viewAngles[PITCH] * 0.40
    ulAngles[PITCH] = viewAngles[PITCH] * 0.40

    thoracicAngles[YAW] = viewAngles[YAW] * 0.20
    ulAngles[YAW] = viewAngles[YAW] * 0.35
    llAngles[YAW] = viewAngles[YAW] * 0.45

    thoracicAngles[ROLL] = viewAngles[ROLL] * 0.20
    ulAngles[ROLL] = viewAngles[ROLL] * 0.35
    llAngles[ROLL] = viewAngles[ROLL] * 0.45
}

/**
```
==================
CG_SwingAngles
==================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:8997
private func BG_SwingAngles(_ destination: Float, _ swingTolerance: Float, _ clampTolerance: Float, _ speed: Float, _ angle: inout Float, _ swinging: inout Bool, _ frametime: Int32) -> Float {
    var swing: Float
    var move: Float
    var scale: Float

    if !swinging {
        // see if a swing should be started
        swing = AngleSubtract(angle, destination)
        if swing > swingTolerance || swing < -swingTolerance {
            swinging = true
        }
    }

    if !swinging {
        return 0
    }

    // modify the speed depending on the delta
    // so it doesn't seem so linear
    swing = AngleSubtract(destination, angle)
    scale = Q_fabs(swing)
    if scale < swingTolerance * 0.5 {
        scale = 0.5
    } else if scale < swingTolerance {
        scale = 1.0
    } else {
        scale = 2.0
    }

    // swing towards the destination angle
    if swing >= 0 {
        move = frametime * scale * speed
        if move >= swing {
            move = swing
            swinging = false
        }
        angle = AngleMod(angle + move)
    } else if swing < 0 {
        move = frametime * scale * -speed
        if move <= swing {
            move = swing
            swinging = false
        }
        angle = AngleMod(angle + move)
    }

    // clamp to no more than tolerance
    swing = AngleSubtract(destination, angle)
    if swing > clampTolerance {
        angle = AngleMod(destination - (clampTolerance - 1))
    } else if swing < -clampTolerance {
        angle = AngleMod(destination + (clampTolerance - 1))
    }

    return swing
}

//I apologize for this function
/// Source: oracle/codemp/game/bg_pmove.c:9058
func BG_InRoll2(_ es: JKAMP.EntityState) -> Bool {
    switch (es.legsAnim) {
    case BOTH_GETUP_BROLL_B,
         BOTH_GETUP_BROLL_F,
         BOTH_GETUP_BROLL_L,
         BOTH_GETUP_BROLL_R,
         BOTH_GETUP_FROLL_B,
         BOTH_GETUP_FROLL_F,
         BOTH_GETUP_FROLL_L,
         BOTH_GETUP_FROLL_R,
         BOTH_ROLL_F,
         BOTH_ROLL_B,
         BOTH_ROLL_R:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:9082
func BG_G2PlayerAngles(_ ghoul2: OpaquePointer?, _ motionBolt: Int32, _ cent: JKAMP.EntityState, _ time: Int32, _ cent_lerpOrigin: inout JKAShared.vec3_t, _ cent_lerpAngles: inout JKAShared.vec3_t, _ legs: inout [JKAShared.vec3_t], _ legsAngles: inout JKAShared.vec3_t, _ tYawing: inout Bool, _ tPitching: inout Bool, _ lYawing: inout Bool, _ tYawAngle: inout Float, _ tPitchAngle: inout Float, _ lYawAngle: inout Float, _ frametime: Int32, _ turAngles: inout JKAShared.vec3_t, _ modelScale: inout JKAShared.vec3_t, _ ciLegs: Int32, _ ciTorso: Int32, _ corrTime: inout Int32, _ lookAngles: inout JKAShared.vec3_t, _ lastHeadAngles: inout JKAShared.vec3_t, _ lookTime: Int32, _ emplaced: JKAMP.EntityState, _ crazySmoothFactor: inout Int32) {
    var adddir: Int32 = 0
    var degrees_negative: Float = 0
    var degrees_positive: Float = 0
    let lookSpeed: Float = 1.5
    var dir: Int32 = 0
    var i: Int32 = 0
    // Raven's static `movementOffsets` table has no live read, its one use sits inside a comment below.
    var dif: Float = 0
    var dest: Float = 0
    var speed: Float = 0
    var eyeAngles = JKAShared.vec3_t(0, 0, 0)
    var neckAngles = JKAShared.vec3_t(0, 0, 0)
    var velocity = JKAShared.vec3_t(0, 0, 0)
    var torsoAngles = JKAShared.vec3_t(0, 0, 0)
    var headAngles = JKAShared.vec3_t(0, 0, 0)
    var velPos = JKAShared.vec3_t(0, 0, 0)
    var velAng = JKAShared.vec3_t(0, 0, 0)
    var ulAngles = JKAShared.vec3_t(0, 0, 0)
    var llAngles = JKAShared.vec3_t(0, 0, 0)
    var viewAngles = JKAShared.vec3_t(0, 0, 0)
    var angles = JKAShared.vec3_t(0, 0, 0)
    var thoracicAngles = JKAShared.vec3_t(0, 0, 0)
    var headClampMinAngles = JKAShared.vec3_t(-25, -55, -10)
    var headClampMaxAngles = JKAShared.vec3_t(50, 50, 10)

    if cent.m_iVehicleNum != 0 || cent.forceFrame != 0 || BG_SaberLockBreakAnim(cent.legsAnim) || BG_SaberLockBreakAnim(cent.torsoAnim) {
        //a vehicle or riding a vehicle - in either case we don't need to be in here
        var forcedAngles = JKAShared.vec3_t(0, 0, 0)

        forcedAngles = JKAShared.vec3_t(0, 0, 0)
        forcedAngles[YAW] = cent_lerpAngles[YAW]
        forcedAngles[ROLL] = cent_lerpAngles[ROLL]
        AnglesToAxis(forcedAngles, &legs)
        legsAngles = forcedAngles

        if cent.number < MAX_CLIENTS {
            strap_G2API_SetBoneAngles(ghoul2, 0, "lower_lumbar", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
            strap_G2API_SetBoneAngles(ghoul2, 0, "upper_lumbar", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
            strap_G2API_SetBoneAngles(ghoul2, 0, "cranium", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
            strap_G2API_SetBoneAngles(ghoul2, 0, "thoracic", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
            strap_G2API_SetBoneAngles(ghoul2, 0, "cervical", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
        }
        return
    }

    if (time + 2000) < corrTime {
        corrTime = 0
    }

    headAngles = cent_lerpAngles
    headAngles[YAW] = AngleMod(headAngles[YAW])
    legsAngles = JKAShared.vec3_t(0, 0, 0)
    torsoAngles = JKAShared.vec3_t(0, 0, 0)
    // --------- yaw -------------

    // allow yaw to drift a bit
    if ((cent.legsAnim) != BOTH_STAND1)
            || (cent.torsoAnim) != bg.WeaponReadyAnim[cent.weapon] {
        // if not standing still, always point all in the same direction
        //cent->pe.torso.yawing = qtrue;	// always center
        tYawing = true
        //cent->pe.torso.pitching = qtrue;	// always center
        tPitching = true
        //cent->pe.legs.yawing = qtrue;	// always center
        lYawing = true
    }

    // adjust legs for movement dir
    if (cent.eFlags & EF_DEAD) != 0 {
        // don't let dead bodies twitch
        dir = 0
    } else {
        dir = Int32(cent.angles2[YAW])
        if dir < 0 || dir > 7 {
            Com_Error(ERR_DROP, "Bad player movement angle (\(dir))")
        }
    }

    torsoAngles[YAW] = headAngles[YAW]

    //for now, turn torso instantly and let the legs swing to follow
    tYawAngle = torsoAngles[YAW]

    // --------- pitch -------------

    velocity = cent.pos.trDelta

    if BG_InRoll2(cent) {
        //don't affect angles based on vel then
        velocity = JKAShared.vec3_t(0, 0, 0)
    } else if cent.weapon == WP_SABER
        && BG_SaberInSpecial(cent.saberMove) {
        velocity = JKAShared.vec3_t(0, 0, 0)
    }

    speed = VectorNormalize(&velocity)

    if speed == 0 {
        torsoAngles[YAW] = headAngles[YAW]
    }

    // only show a fraction of the pitch angle in the torso
    // Raven wrote no `f` suffix here, so C works the product in double.
    if headAngles[PITCH] > 180 {
        dest = Float(Double(-360 + headAngles[PITCH]) * 0.75)
    } else {
        dest = Float(Double(headAngles[PITCH]) * 0.75)
    }

    if cent.m_iVehicleNum != 0 {
        //swing instantly on vehicles
        tPitchAngle = dest
    } else {
        _ = BG_SwingAngles(dest, 15, 30, 0.1, &tPitchAngle, &tPitching, frametime)
    }
    torsoAngles[PITCH] = tPitchAngle

    // --------- roll -------------

    if speed != 0 {
        var axis: [JKAShared.vec3_t] = [JKAShared.vec3_t(0, 0, 0), JKAShared.vec3_t(0, 0, 0), JKAShared.vec3_t(0, 0, 0)]
        var side: Float

        speed = Float(Double(speed) * 0.05)

        AnglesToAxis(legsAngles, &axis)
        side = speed * _DotProduct(velocity, axis[1])
        legsAngles[ROLL] -= side

        side = speed * _DotProduct(velocity, axis[0])
        legsAngles[PITCH] += side
    }

    //legsAngles[YAW] = headAngles[YAW] + (movementOffsets[ dir ]*speed_dif);

    //rww - crazy velocity-based leg angle calculation
    legsAngles[YAW] = headAngles[YAW]
    velPos[0] = cent_lerpOrigin[0] + velocity[0]
    velPos[1] = cent_lerpOrigin[1] + velocity[1]
    velPos[2] = cent_lerpOrigin[2]// + velocity[2];

    if cent.groundEntityNum == ENTITYNUM_NONE
        || cent.forceFrame != 0
        // Port-note: Raven guards a NULL `emplaced` here. The view is non-optional, so that half of the guard has no Swift form.
        || cent.weapon == WP_EMPLACED_GUN {
        //off the ground, no direction-based leg angles (same if in saberlock)
        velPos = cent_lerpOrigin
    }

    velAng = cent_lerpOrigin - velPos

    if VectorCompare(velAng, vec3_origin) == 0 {
        vectoangles(velAng, &velAng)

        if velAng[YAW] <= legsAngles[YAW] {
            degrees_negative = (legsAngles[YAW] - velAng[YAW])
            degrees_positive = (360 - legsAngles[YAW]) + velAng[YAW]
        } else {
            degrees_negative = legsAngles[YAW] + (360 - velAng[YAW])
            degrees_positive = (velAng[YAW] - legsAngles[YAW])
        }

        if degrees_negative < degrees_positive {
            dif = degrees_negative
            adddir = 0
        } else {
            dif = degrees_positive
            adddir = 1
        }

        if dif > 90 {
            dif = (180 - dif)
        }

        if dif > 60 {
            dif = 60
        }

        //Slight hack for when playing is running backward
        if dir == 3 || dir == 5 {
            dif = -dif
        }

        if adddir != 0 {
            legsAngles[YAW] -= dif
        } else {
            legsAngles[YAW] += dif
        }
    }

    if cent.m_iVehicleNum != 0 {
        //swing instantly on vehicles
        lYawAngle = legsAngles[YAW]
    } else {
        _ = BG_SwingAngles(legsAngles[YAW], /*40*/0, 90, 0.65, &lYawAngle, &lYawing, frametime)
    }
    legsAngles[YAW] = lYawAngle

    /*
    // pain twitch
    CG_AddPainTwitch( cent, torsoAngles );
    */

    legsAngles[ROLL] = 0
    torsoAngles[ROLL] = 0

//	VectorCopy(legsAngles, turAngles);

    // pull the angles back out of the hierarchial chain
    AnglesSubtract(headAngles, torsoAngles, &headAngles)
    AnglesSubtract(torsoAngles, legsAngles, &torsoAngles)

    legsAngles[PITCH] = 0

    if cent.heldByClient != 0 {
        //keep the base angles clear when doing the IK stuff, it doesn't compensate for it.
        //rwwFIXMEFIXME: Store leg angles off and add them to all the fed in angles for G2 functions?
        legsAngles = JKAShared.vec3_t(0, 0, 0)
        legsAngles[YAW] = cent_lerpAngles[YAW]
    }

    turAngles = legsAngles

    AnglesToAxis(legsAngles, &legs)

    viewAngles = cent_lerpAngles
    viewAngles[YAW] = 0
    viewAngles[ROLL] = 0
    viewAngles[PITCH] = Float(Double(viewAngles[PITCH]) * 0.5)

    angles = JKAShared.vec3_t(0, legsAngles[1], 0)

    angles[0] = legsAngles[0]
    if angles[0] > 30 {
        angles[0] = 30
    } else if angles[0] < -30 {
        angles[0] = -30
    }

    // Port-note: Raven guards a NULL `emplaced` here. The view is non-optional, so that half of the guard has no Swift form.
    if cent.weapon == WP_EMPLACED_GUN {
        //if using an emplaced gun, then we want to make sure we're angled to "hold" it right
        var facingAngles = JKAShared.vec3_t(0, 0, 0)

        facingAngles = emplaced.pos.trBase - cent_lerpOrigin
        vectoangles(facingAngles, &facingAngles)

        if emplaced.weapon == WP_NONE {
            //e-web
            legsAngles = facingAngles
            AnglesToAxis(legsAngles, &legs)
        } else {
            //misc emplaced
            let dif = AngleSubtract(cent_lerpAngles[YAW], facingAngles[YAW])

            /*
            if (emplaced->weapon == WP_NONE)
            { //offset is a little bit different for the e-web
                dif -= 16.0f;
            }
            */

            facingAngles = JKAShared.vec3_t(-16.0, -dif, 0.0)

            if cent.legsAnim == BOTH_STRAFE_LEFT1 || cent.legsAnim == BOTH_STRAFE_RIGHT1 {
                //try to adjust so it doesn't look wrong
                // Port-note: Raven guards a NULL `crazySmoothFactor` here. The generated parameter is a plain `inout Int32`, so the guard has no Swift form.
                crazySmoothFactor = time + 1000

                BG_G2ClientSpineAngles(ghoul2, motionBolt, &cent_lerpOrigin, &cent_lerpAngles, cent, time,
                    &viewAngles, ciLegs, ciTorso, angles, &thoracicAngles, &ulAngles, &llAngles, &modelScale,
                    &tPitchAngle, &tYawAngle, &corrTime)
                strap_G2API_SetBoneAngles(ghoul2, 0, "lower_lumbar", llAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
                strap_G2API_SetBoneAngles(ghoul2, 0, "upper_lumbar", ulAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
                strap_G2API_SetBoneAngles(ghoul2, 0, "cranium", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)

                facingAngles = facingAngles + thoracicAngles

                if cent.legsAnim == BOTH_STRAFE_LEFT1 {
                    //this one needs some further correction
                    facingAngles[YAW] -= 32.0
                }
            } else {
                //strap_G2API_SetBoneAngles(ghoul2, 0, "lower_lumbar", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, 0, 0, time);
                //strap_G2API_SetBoneAngles(ghoul2, 0, "upper_lumbar", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, 0, 0, time);
                strap_G2API_SetBoneAngles(ghoul2, 0, "cranium", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
            }

            facingAngles = facingAngles * 0.6
            strap_G2API_SetBoneAngles(ghoul2, 0, "lower_lumbar", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
            facingAngles = facingAngles * 0.8
            strap_G2API_SetBoneAngles(ghoul2, 0, "upper_lumbar", facingAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
            facingAngles = facingAngles * 0.8
            strap_G2API_SetBoneAngles(ghoul2, 0, "thoracic", facingAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)

            //Now we want the head angled toward where we are facing
            facingAngles = JKAShared.vec3_t(0.0, dif, 0.0)
            facingAngles = facingAngles * 0.6
            strap_G2API_SetBoneAngles(ghoul2, 0, "cervical", facingAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)

            return //don't have to bother with the rest then
        }
    }

    BG_G2ClientSpineAngles(ghoul2, motionBolt, &cent_lerpOrigin, &cent_lerpAngles, cent, time,
        &viewAngles, ciLegs, ciTorso, angles, &thoracicAngles, &ulAngles, &llAngles, &modelScale,
        &tPitchAngle, &tYawAngle, &corrTime)

    eyeAngles = cent_lerpAngles

    i = 0
    while i < 3 {
        lookAngles[i] = AngleNormalize180(lookAngles[i])
        eyeAngles[i] = AngleNormalize180(eyeAngles[i])
        i += 1
    }
    AnglesSubtract(lookAngles, eyeAngles, &lookAngles)

    BG_UpdateLookAngles(lookTime, &lastHeadAngles, time, &lookAngles, lookSpeed, -50.0, 50.0, -70.0, 70.0, -30.0, 30.0)

    BG_G2ClientNeckAngles(ghoul2, time, lookAngles, &headAngles, &neckAngles, &thoracicAngles, &headClampMinAngles, &headClampMaxAngles)

    strap_G2API_SetBoneAngles(ghoul2, 0, "lower_lumbar", llAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
    strap_G2API_SetBoneAngles(ghoul2, 0, "upper_lumbar", ulAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
    strap_G2API_SetBoneAngles(ghoul2, 0, "thoracic", thoracicAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
    //strap_G2API_SetBoneAngles(ghoul2, 0, "cervical", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, 0, 0, time);
}

/// Source: oracle/codemp/game/bg_pmove.c:9459
func BG_G2ATSTAngles(_ ghoul2: OpaquePointer?, _ time: Int32, _ cent_lerpAngles: inout JKAShared.vec3_t) {
    //																							up			right		fwd
    strap_G2API_SetBoneAngles(ghoul2, 0, "thoracic", cent_lerpAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, time)
}

/// Source: oracle/codemp/game/bg_pmove.c:9464
private func PM_AdjustAnglesForDualJumpAttack(_ ps: JKAMP.PlayerState, _ ucmd: JKAMP.Usercmd) -> Bool {
    //ucmd->angles[PITCH] = ANGLE2SHORT( ps->viewangles[PITCH] ) - ps->delta_angles[PITCH];
    //ucmd->angles[YAW] = ANGLE2SHORT( ps->viewangles[YAW] ) - ps->delta_angles[YAW];
    return true
}

/// Source: oracle/codemp/game/bg_pmove.c:9474
private func PM_CmdForSaberMoves(_ ucmd: JKAMP.Usercmd) {
    let ps = pm.ps
    //DUAL FORWARD+JUMP+ATTACK
    if (ps.legsAnim == BOTH_JUMPATTACK6
            && ps.saberMove == LS_JUMPATTACK_DUAL)
        || (ps.legsAnim == BOTH_BUTTERFLY_FL1
            && ps.saberMove == LS_JUMPATTACK_STAFF_LEFT)
        || (ps.legsAnim == BOTH_BUTTERFLY_FR1
            && ps.saberMove == LS_JUMPATTACK_STAFF_RIGHT)
        || (ps.legsAnim == BOTH_BUTTERFLY_RIGHT
            && ps.saberMove == LS_BUTTERFLY_RIGHT)
        || (ps.legsAnim == BOTH_BUTTERFLY_LEFT
            && ps.saberMove == LS_BUTTERFLY_LEFT) {
        let aLen = PM_AnimLength(0, BOTH_JUMPATTACK6)

        ucmd.forwardmove = 0
        ucmd.rightmove = 0
        ucmd.upmove = 0

        if ps.legsAnim == BOTH_JUMPATTACK6 {
            //dual stance attack
            if ps.legsTimer >= 100 //not at end
                && (aLen - ps.legsTimer) >= 250 { //not in beginning
                //middle of anim
                //push forward
                ucmd.forwardmove = 127
            }

            if (ps.legsTimer >= 900 //not at end
                    && aLen - ps.legsTimer >= 950) //not in beginning
                || (ps.legsTimer >= 1600
                    && aLen - ps.legsTimer >= 400) { //not in beginning
                //one of the two jumps
                if ps.groundEntityNum != ENTITYNUM_NONE {
                    //still on ground?
                    if ps.groundEntityNum >= MAX_CLIENTS {
                        //jump!
                        ps.velocity[2] = 250//400;
                        ps.fd.forceJumpZStart = ps.origin[2]//so we don't take damage if we land at same height
                        //pm->ps->pm_flags |= PMF_JUMPING;
                        //FIXME: NPCs yell?
                        PM_AddEvent(EV_JUMP)
                        //G_SoundOnEnt( ent, CHAN_BODY, "sound/weapons/force/jump.wav" );
                    }
                } else {
                    //FIXME: if this is the second jump, maybe we should just stop the anim?
                }
            }
        } else {
            //saberstaff attacks
            let aLen = PM_AnimLength(0, ps.legsAnim)
            var lenMin: Float = 1700.0
            var lenMax: Float = 1800.0

            if ps.legsAnim == BOTH_BUTTERFLY_LEFT {
                lenMin = 1200.0
                lenMax = 1400.0
            }

            //FIXME: don't slide off people/obstacles?
            if ps.legsAnim == BOTH_BUTTERFLY_RIGHT
                || ps.legsAnim == BOTH_BUTTERFLY_LEFT {
                if ps.legsTimer > 450 {
                    switch ps.legsAnim {
                    case BOTH_BUTTERFLY_LEFT:
                        ucmd.rightmove = -127

                    case BOTH_BUTTERFLY_RIGHT:
                        ucmd.rightmove = 127

                    default:
                        break
                    }
                }
            } else {
                if ps.legsTimer >= 100 //not at end
                    && aLen - ps.legsTimer >= 250 { //not in beginning
                    //middle of anim
                    //push forward
                    ucmd.forwardmove = 127
                }
            }

            if ps.legsTimer >= lenMin && ps.legsTimer < lenMax {
                //one of the two jumps
                if ps.groundEntityNum != ENTITYNUM_NONE {
                    //still on ground?
                    //jump!
                    if ps.legsAnim == BOTH_BUTTERFLY_LEFT {
                        ps.velocity[2] = 350
                    } else {
                        ps.velocity[2] = 250
                    }
                    ps.fd.forceJumpZStart = ps.origin[2]//so we don't take damage if we land at same height
                    //pm->ps->pm_flags |= PMF_JUMPING;//|PMF_SLOW_MO_FALL;
                    //FIXME: NPCs yell?
                    PM_AddEvent(EV_JUMP)
                    //G_SoundOnEnt( ent, CHAN_BODY, "sound/weapons/force/jump.wav" );
                } else {
                    //FIXME: if this is the second jump, maybe we should just stop the anim?
                }
            }
        }

        if ps.groundEntityNum == ENTITYNUM_NONE {
            //can only turn when your feet hit the ground
            if PM_AdjustAnglesForDualJumpAttack(ps, ucmd) {
                PM_SetPMViewAngle(ps, &ps.viewangles, ucmd)
            }
        }
        //rwwFIXMEFIXME: Bother with bbox resizing like sp?
    }
    //STAFF BACK+JUMP+ATTACK
    else if ps.saberMove == LS_A_BACKFLIP_ATK
        && ps.legsAnim == BOTH_JUMPATTACK7 {
        let aLen = PM_AnimLength(0, BOTH_JUMPATTACK7)

        if ps.legsTimer > 800 //not at end
            && aLen - ps.legsTimer >= 400 { //not in beginning
            //middle of anim
            if ps.groundEntityNum != ENTITYNUM_NONE {
                //still on ground?
                var yawAngles = JKAShared.vec3_t(0, 0, 0)
                var backDir = JKAShared.vec3_t(0, 0, 0)

                //push backwards some?
                yawAngles = JKAShared.vec3_t(0, ps.viewangles[YAW] + 180, 0)
                // Raven passes NULL for the last two outputs of `AngleVectors`. The ported function takes them by reference, so the body passes scratch vectors it never reads.
                var scratchRight = JKAShared.vec3_t(0, 0, 0)
                var scratchUp = JKAShared.vec3_t(0, 0, 0)
                AngleVectors(yawAngles, &backDir, &scratchRight, &scratchUp)
                ps.velocity = backDir * 100

                //jump!
                ps.velocity[2] = 300
                ps.fd.forceJumpZStart = ps.origin[2] //so we don't take damage if we land at same height
                //pm->ps->pm_flags |= PMF_JUMPING;//|PMF_SLOW_MO_FALL;

                //FIXME: NPCs yell?
                PM_AddEvent(EV_JUMP)
                //G_SoundOnEnt( ent, CHAN_BODY, "sound/weapons/force/jump.wav" );
                ucmd.upmove = 0 //clear any actual jump command
            }
        }
        ucmd.forwardmove = 0
        ucmd.rightmove = 0
        ucmd.upmove = 0
    }
    //STAFF/DUAL SPIN ATTACK
    else if ps.saberMove == LS_SPINATTACK
        || ps.saberMove == LS_SPINATTACK_DUAL {
        ucmd.forwardmove = 0
        ucmd.rightmove = 0
        ucmd.upmove = 0
        //lock their viewangles during these attacks.
        PM_SetPMViewAngle(ps, &ps.viewangles, ucmd)
    }
}

//constrain him based on the angles of his vehicle and the caps
/// Source: oracle/codemp/game/bg_pmove.c:9642
func PM_VehicleViewAngles(_ ps: JKAMP.PlayerState, _ veh: JKAMP.BgEntity, _ ucmd: JKAMP.Usercmd) {
    // Port-note: Raven leaves `clampMin` and `clampMax` uninitialized on the turret path, so this port zeroes them, rule 19.
    // Port-note: Raven dereferences `veh->m_pVehicle` and `m_pVehicleInfo` with no guard. The generated fields are optional, so this port returns on nil, rule 19.
    guard let pVeh = veh.m_pVehicle, let pVehInfo = pVeh.m_pVehicleInfo else { return }
    var setAngles = true
    var clampMin = vec3_t(0, 0, 0)
    var clampMax = vec3_t(0, 0, 0)

    if let pilot = veh.m_pVehicle?.m_pPilot,
        pilot.s.number == ps.clientNum {
        //set the pilot's viewangles to the vehicle's viewangles
        if !BG_UnrestrainedPitchRoll(ps, pVeh) {
            //only if not if doing special free-roll/pitch control
            setAngles = true
            clampMin[PITCH] = -pVehInfo.lookPitch
            clampMax[PITCH] = pVehInfo.lookPitch
            clampMin[YAW] = 0
            clampMax[YAW] = 0
            clampMin[ROLL] = -1
            clampMax[ROLL] = -1
        }
    } else {
        //NOTE: passengers can look around freely, UNLESS they're controlling a turret!
        for i in 0..<Int(MAX_VEHICLE_TURRETS) {
            if pVehInfo.turret[i].passengerNum == ps.generic1 {
                //this turret is my station
                //nevermind, don't clamp
                return
                /*
                setAngles = qtrue;
                clampMin[PITCH] = veh->m_pVehicle->m_pVehicleInfo->turret[i].pitchClampUp;
                clampMax[PITCH] = veh->m_pVehicle->m_pVehicleInfo->turret[i].pitchClampDown;
                clampMin[YAW] = veh->m_pVehicle->m_pVehicleInfo->turret[i].yawClampRight;
                clampMax[YAW] = veh->m_pVehicle->m_pVehicleInfo->turret[i].yawClampLeft;
                clampMin[ROLL] = clampMax[ROLL] = 0;
                break;
                */
            }
        }
    }
    if setAngles {
        for i in 0..<3 {
            //clamp viewangles
            if clampMin[i] == -1 || clampMax[i] == -1 {
                //no clamp
            } else if clampMin[i] == 0 && clampMax[i] == 0 {
                //no allowance
                //ps->viewangles[i] = veh->playerState->viewangles[i];
            } else {
                //allowance
                if ps.viewangles[i] > clampMax[i] {
                    ps.viewangles[i] = clampMax[i]
                } else if ps.viewangles[i] < clampMin[i] {
                    ps.viewangles[i] = clampMin[i]
                }
            }
        }

        PM_SetPMViewAngle(ps, &ps.viewangles, ucmd)
    }
}

/**
```
//constrain him based on the angles of his vehicle and the caps
void PM_VehicleViewAngles(playerState_t *ps, bgEntity_t *veh, usercmd_t *ucmd)
{
	Vehicle_t *pVeh = veh->m_pVehicle;

	//now set the viewangles to the vehicle's directly
	ps->viewangles[YAW] = veh->playerState->viewangles[YAW];

	//constrain the viewangles pitch based on the vehicle properties
	if ( !pVeh->m_pVehicleInfo->lookPitch )
	{//not allowed to look up & down!  ....???
		ps->viewangles[PITCH] = veh->playerState->viewangles[PITCH];
	}
	else
	{//clamp
		if (ps->viewangles[PITCH] > pVeh->m_pVehicleInfo->lookPitch)
		{
			ps->viewangles[PITCH] = pVeh->m_pVehicleInfo->lookPitch;
		}
		else if (ps->viewangles[PITCH] < -pVeh->m_pVehicleInfo->lookPitch)
		{
			ps->viewangles[PITCH] = -pVeh->m_pVehicleInfo->lookPitch;
		}
	}

	PM_SetPMViewAngle(ps, ps->viewangles, ucmd);
}
```
*/
//see if a weapon is ok to use on a vehicle
/// Source: oracle/codemp/game/bg_pmove.c:9745
func PM_WeaponOkOnVehicle(_ weapon: Int32) -> Bool {
    //FIXME: check g_vehicleInfo for our vehicle?
    switch weapon {
    //case WP_NONE:
    case WP_MELEE,
         WP_SABER,
         WP_BLASTER:
    //case WP_THERMAL:
        return true
    default:
        break
    }
    return false
}

//do we have a weapon that's ok for using on the vehicle?
/// Source: oracle/codemp/game/bg_pmove.c:9762
func PM_GetOkWeaponForVehicle() -> Int32 {
    var i: Int32 = 0
    let ps = pm.ps
    while i < WP_NUM_WEAPONS {
        if (ps.stats[STAT_WEAPONS] & (1 << i)) != 0
            && PM_WeaponOkOnVehicle(i) {
            //this one's good
            return i
        }

        i += 1
    }

    //oh dear!
    //assert(!"No valid veh weaps");
    return -1
}

//force the vehicle to turn and travel to its forced destination point
/// Source: oracle/codemp/game/bg_pmove.c:9783
func PM_VehForcedTurning(_ veh: JKAMP.BgEntity) {
    var pitchD: Float, yawD: Float
    var dir = JKAShared.vec3_t(0, 0, 0)
    let ps = pm.ps
    // Port-note: Raven reads `veh->playerState->vehTurnaroundIndex` before his own NULL checks. The generated field is optional, so the body binds it, and the nil path returns.
    guard let vehPS = veh.playerState else { return }

    let dst = PM_BGEntForNum(vehPS.vehTurnaroundIndex)

    // Port-note: Raven guards a NULL `veh` here. The view is non-optional, so that half of the guard has no Swift form.
    guard let m_pVehicle = veh.m_pVehicle else {
        return
    }

    guard let dst else {
        //can't find dest ent?
        return
    }

    m_pVehicle.m_ucmd.upmove = 127
    pm.cmd.upmove = 127
    m_pVehicle.m_ucmd.forwardmove = 0
    pm.cmd.forwardmove = 0
    m_pVehicle.m_ucmd.rightmove = 0
    pm.cmd.rightmove = 0

    dir = dst.s.origin - vehPS.origin
    vectoangles(dir, &dir)

    yawD = AngleSubtract(ps.viewangles[YAW], dir[YAW])
    pitchD = AngleSubtract(ps.viewangles[PITCH], dir[PITCH])

    yawD *= 0.6 * bg.pml.frametime
    pitchD *= 0.6 * bg.pml.frametime

    ps.viewangles[YAW] = AngleSubtract(ps.viewangles[YAW], yawD)
    ps.viewangles[PITCH] = AngleSubtract(ps.viewangles[PITCH], pitchD)

    PM_SetPMViewAngle(ps, &ps.viewangles, pm.cmd)
}

/// Source: oracle/codemp/game/bg_pmove.c:9916
func PM_VehFaceHyperspacePoint(_ veh: JKAMP.BgEntity) {
    // Port-note: Raven reads `veh->m_pVehicle->m_vOrientation[i]`. The generated field is an `OpaquePointer?` for Raven's `float *`, and rule 11 keeps a pointer out of a logic target.
    // TODO: Port PM_VehFaceHyperspacePoint
    portMissing("PM_VehFaceHyperspacePoint", source: "oracle/codemp/game/bg_pmove.c:9916")
}

/// Source: oracle/codemp/game/bg_pmove.c:9993
func BG_VehicleAdjustBBoxForOrientation(_ veh: JKAMP.Vehicle, _ origin: inout JKAShared.vec3_t, _ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t, _ clientNum: Int32, _ tracemask: Int32, _ localTrace: ((JKAMP.Trace, JKAShared.vec3_t, JKAShared.vec3_t, JKAShared.vec3_t, JKAShared.vec3_t, Int32, Int32) -> Void)?) {
    // Port-note: Raven guards a NULL `veh` here. The view is non-optional, so that half of the guard has no Swift form.
    // Port-note: Raven walks `veh->m_pVehicleInfo` with no guard. The generated field is optional, so the body binds it and takes Raven's early return where it is NULL.
    guard let m_pVehicleInfo = veh.m_pVehicleInfo else {
        return
    }
    if m_pVehicleInfo.length == 0
        || m_pVehicleInfo.width == 0
        || m_pVehicleInfo.height == 0
        //|| veh->m_LandTrace.fraction < 1.0f )
    {
        return
    } else if m_pVehicleInfo.type != VH_FIGHTER
        //&& veh->m_pVehicleInfo->type != VH_SPEEDER
        && m_pVehicleInfo.type != VH_FLIER {
        //only those types of vehicles have dynamic bboxes, the rest just use a static bbox
        maxs = JKAShared.vec3_t(m_pVehicleInfo.width / 2.0, m_pVehicleInfo.width / 2.0, m_pVehicleInfo.height + DEFAULT_MINS_2)
        mins = JKAShared.vec3_t(m_pVehicleInfo.width / -2.0, m_pVehicleInfo.width / -2.0, Float(DEFAULT_MINS_2))
        return
    } else {
        // Port-note: Raven opens this arm with `AnglesToAxis( veh->m_vOrientation, axis )`. The generated `m_vOrientation` is an `OpaquePointer?` for Raven's `float *`, and rule 11 keeps a pointer out of a logic target, so the rest of this arm has no Swift form.
        portMissing("BG_VehicleAdjustBBoxForOrientation: veh->m_vOrientation", source: "oracle/codemp/game/bg_pmove.c:10020")
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:10092
func PM_MoveForKata(_ ucmd: JKAMP.Usercmd) {
    let ps = pm.ps
    if ps.legsAnim == BOTH_A7_SOULCAL
        && ps.saberMove == LS_STAFF_SOULCAL {
        //forward spinning staff attack
        ucmd.upmove = 0

        if PM_CanRollFromSoulCal(ps) {
            ucmd.upmove = -127
            ucmd.rightmove = 0
            if ucmd.forwardmove < 0 {
                ucmd.forwardmove = 0
            }
        } else {
            ucmd.rightmove = 0
            //FIXME: don't slide off people/obstacles?
            if ps.legsTimer >= 2750 {
                //not at end
                //push forward
                ucmd.forwardmove = 64
            } else {
                ucmd.forwardmove = 0
            }
        }
        if ps.legsTimer >= 2650
            && ps.legsTimer < 2850 {
            //the jump
            if ps.groundEntityNum != ENTITYNUM_NONE {
                //still on ground?
                //jump!
                ps.velocity[2] = 250
                ps.fd.forceJumpZStart = ps.origin[2]//so we don't take damage if we land at same height
            //	pm->ps->pm_flags |= PMF_JUMPING;//|PMF_SLOW_MO_FALL;
                //FIXME: NPCs yell?
                PM_AddEvent(EV_JUMP)
            }
        }
    } else if ps.legsAnim == BOTH_A2_SPECIAL {
        //medium kata
        pm.cmd.rightmove = 0
        pm.cmd.upmove = 0
        if ps.legsTimer < 2700 && ps.legsTimer > 2300 {
            pm.cmd.forwardmove = 127
        } else if ps.legsTimer < 900 && ps.legsTimer > 500 {
            pm.cmd.forwardmove = 127
        } else {
            pm.cmd.forwardmove = 0
        }
    } else if ps.legsAnim == BOTH_A3_SPECIAL {
        //strong kata
        pm.cmd.rightmove = 0
        pm.cmd.upmove = 0
        if ps.legsTimer < 1700 && ps.legsTimer > 1000 {
            pm.cmd.forwardmove = 127
        } else {
            pm.cmd.forwardmove = 0
        }
    } else {
        pm.cmd.forwardmove = 0
        pm.cmd.rightmove = 0
        pm.cmd.upmove = 0
    }
}

/// Source: oracle/codemp/game/bg_pmove.c:10174
func PmoveSingle(_ pmove: JKAMP.Pmove) {
    // Port-note: Raven reads and writes `veh->m_pVehicle->m_vOrientation`. The generated field is an `OpaquePointer?` for Raven's `float *`, and rule 11 keeps a pointer out of a logic target.
    // Port-note: The game arms of two `#ifdef QAGAME` blocks cast a `bgEntity_t *` to `gentity_t *`. The `Entity` view lives in the game target, which the bg target cannot import.
    // TODO: Port PmoveSingle
    portMissing("PmoveSingle", source: "oracle/codemp/game/bg_pmove.c:10174")
}

/**
```
================
Pmove

Can be called by either the server or the client
================
```
*/
/// Source: oracle/codemp/game/bg_pmove.c:11167
func Pmove(_ pmove: JKAMP.Pmove) {
    let finalTime: Int32
    let ps = pmove.ps
    finalTime = pmove.cmd.serverTime

    if finalTime < ps.commandTime {
        return // should not happen
    }

    if finalTime > ps.commandTime + 1000 {
        ps.commandTime = finalTime - 1000
    }

    if ps.fallingToDeath != 0 {
        pmove.cmd.forwardmove = 0
        pmove.cmd.rightmove = 0
        pmove.cmd.upmove = 0
        pmove.cmd.buttons = 0
    }

    ps.pmove_framecount = (ps.pmove_framecount + 1) & ((1 << PS_PMOVEFRAMECOUNTBITS) - 1)

    // chop the move up if it is too long, to prevent framerate
    // dependent behavior
    while ps.commandTime != finalTime {
        var msec: Int32

        msec = finalTime - ps.commandTime

        if pmove.pmove_fixed != 0 {
            if msec > pmove.pmove_msec {
                msec = pmove.pmove_msec
            }
        } else {
            if msec > 66 {
                msec = 66
            }
        }
        pmove.cmd.serverTime = ps.commandTime + msec

        PmoveSingle(pmove)

        if (ps.pm_flags & PMF_JUMP_HELD) != 0 {
            pmove.cmd.upmove = 20
        }
    }
}
