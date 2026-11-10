import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_move.cpp:29
var aassettings: AasSettings { world.storage.aassettings }

/// Source: oracle/codemp/botlib/be_aas_move.cpp:213
/// Raven's data table, a hand property of `EngineWorld`.
var VEC_UP: JKAShared.vec3_t {
    get { world.VEC_UP }
    set { world.VEC_UP = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_move.cpp:214
// Raven wrote: static vec3_t MOVEDIR_UP = {0, 0, 1}
let MOVEDIR_UP: JKAShared.vec3_t = vec3_t(0, 0, 1)

/// Source: oracle/codemp/botlib/be_aas_move.cpp:215
/// Raven's data table, a hand property of `EngineWorld`.
var VEC_DOWN: JKAShared.vec3_t {
    get { world.VEC_DOWN }
    set { world.VEC_DOWN = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_move.cpp:216
// Raven wrote: static vec3_t MOVEDIR_DOWN = {0, 0, -1}
let MOVEDIR_DOWN: JKAShared.vec3_t = vec3_t(0, 0, -1)

/// Source: oracle/codemp/botlib/be_aas_move.cpp:505
// AI: Raven declares `areas` on the stack of AAS_ClientMovementPrediction. The function uses one zeroed allocation on the storage class.
private var areas_AAS_ClientMovementPrediction: Slots<Int32> { world.storage.be_aas_move_areas_AAS_ClientMovementPrediction }

/// Source: oracle/codemp/botlib/be_aas_move.cpp:506
// AI: Raven declares `points` on the stack of AAS_ClientMovementPrediction. The function uses one zeroed allocation on the storage class.
private var points_AAS_ClientMovementPrediction: Slots<JKAShared.vec3_t> { world.storage.be_aas_move_points_AAS_ClientMovementPrediction }

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:39
func AAS_DropToFloor(_ origin: inout JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) -> Int32 {
    var end: vec3_t

    end = origin
    end[2] -= 100
    return BspTrace.scratch { trace -> Int32 in
        trace.copy(from: AAS_Trace(origin, mins, maxs, end, 0, CONTENTS_SOLID))
        if trace.startsolid {
            return 0
        }
        origin = trace.endpos
        return 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:57
func AAS_InitSettings() {
    aassettings.phys_gravitydirection[0] = 0
    aassettings.phys_gravitydirection[1] = 0
    aassettings.phys_gravitydirection[2] = -1
    aassettings.phys_friction = LibVarValue("phys_friction", "6")
    aassettings.phys_stopspeed = LibVarValue("phys_stopspeed", "100")
    aassettings.phys_gravity = LibVarValue("phys_gravity", "800")
    aassettings.phys_waterfriction = LibVarValue("phys_waterfriction", "1")
    aassettings.phys_watergravity = LibVarValue("phys_watergravity", "400")
    aassettings.phys_maxvelocity = LibVarValue("phys_maxvelocity", "320")
    aassettings.phys_maxwalkvelocity = LibVarValue("phys_maxwalkvelocity", "320")
    aassettings.phys_maxcrouchvelocity = LibVarValue("phys_maxcrouchvelocity", "100")
    aassettings.phys_maxswimvelocity = LibVarValue("phys_maxswimvelocity", "150")
    aassettings.phys_walkaccelerate = LibVarValue("phys_walkaccelerate", "10")
    aassettings.phys_airaccelerate = LibVarValue("phys_airaccelerate", "1")
    aassettings.phys_swimaccelerate = LibVarValue("phys_swimaccelerate", "4")
    aassettings.phys_maxstep = LibVarValue("phys_maxstep", "19")
    aassettings.phys_maxsteepness = LibVarValue("phys_maxsteepness", "0.7")
    aassettings.phys_maxwaterjump = LibVarValue("phys_maxwaterjump", "18")
    aassettings.phys_maxbarrier = LibVarValue("phys_maxbarrier", "33")
    aassettings.phys_jumpvel = LibVarValue("phys_jumpvel", "270")
    aassettings.phys_falldelta5 = LibVarValue("phys_falldelta5", "40")
    aassettings.phys_falldelta10 = LibVarValue("phys_falldelta10", "60")
    aassettings.rs_waterjump = LibVarValue("rs_waterjump", "400")
    aassettings.rs_teleport = LibVarValue("rs_teleport", "50")
    aassettings.rs_barrierjump = LibVarValue("rs_barrierjump", "100")
    aassettings.rs_startcrouch = LibVarValue("rs_startcrouch", "300")
    aassettings.rs_startgrapple = LibVarValue("rs_startgrapple", "500")
    aassettings.rs_startwalkoffledge = LibVarValue("rs_startwalkoffledge", "70")
    aassettings.rs_startjump = LibVarValue("rs_startjump", "300")
    aassettings.rs_rocketjump = LibVarValue("rs_rocketjump", "500")
    aassettings.rs_bfgjump = LibVarValue("rs_bfgjump", "500")
    aassettings.rs_jumppad = LibVarValue("rs_jumppad", "250")
    aassettings.rs_aircontrolledjumppad = LibVarValue("rs_aircontrolledjumppad", "300")
    aassettings.rs_funcbob = LibVarValue("rs_funcbob", "300")
    aassettings.rs_startelevator = LibVarValue("rs_startelevator", "50")
    aassettings.rs_falldamage5 = LibVarValue("rs_falldamage5", "300")
    aassettings.rs_falldamage10 = LibVarValue("rs_falldamage10", "500")
    aassettings.rs_maxfallheight = LibVarValue("rs_maxfallheight", "0")
    aassettings.rs_maxjumpfallheight = LibVarValue("rs_maxjumpfallheight", "450")
}

//===========================================================================
// returns qtrue if the bot is against a ladder
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:106
func AAS_AgainstLadder(_ origin: JKAShared.vec3_t) -> Int32 {
    var areanum: Int32
    var i: Int32
    var facenum: Int32
    var side: Int32
    var org: vec3_t
    var plane: AasPlane
    var face: AasFace
    let area: AasArea

    org = origin
    areanum = AAS_PointAreaNum(org)
    if areanum == 0 {
        org[0] += 1
        areanum = AAS_PointAreaNum(org)
        if areanum == 0 {
            org[1] += 1
            areanum = AAS_PointAreaNum(org)
            if areanum == 0 {
                org[0] -= 2
                areanum = AAS_PointAreaNum(org)
                if areanum == 0 {
                    org[1] -= 2
                    areanum = AAS_PointAreaNum(org)
                } //end if
            } //end if
        } //end if
    } //end if
    //if in solid... wrrr shouldn't happen
    if areanum == 0 {
        return 0
    }
    //if not in a ladder area
    if (aasworld.areasettingsSlots[areanum].areaflags & AREA_LADDER) == 0 {
        return 0
    }
    //if a crouch only area
    if (aasworld.areasettingsSlots[areanum].presencetype & PRESENCE_NORMAL) == 0 {
        return 0
    }
    //
    area = aasworld.areasSlots[areanum]
    i = 0
    while i < area.numfaces {
        facenum = aasworld.faceindex![area.firstface + i]
        side = facenum < 0 ? 1 : 0
        face = aasworld.facesSlots[abs(facenum)]
        //if the face isn't a ladder face
        if (face.faceflags & FACE_LADDER) == 0 {
            i += 1
            continue
        }
        //get the plane the face is in
        plane = aasworld.planesSlots[face.planenum ^ side]
        //if the origin is pretty close to the plane
        if abs(_DotProduct(plane.normal, origin) - plane.dist) < 3 {
            if AAS_PointInsideFace(abs(facenum), origin, 0.1) {
                return 1
            }
        } //end if
        i += 1
    } //end for
    return 0
}

//===========================================================================
// returns qtrue if the bot is on the ground
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:168
func AAS_OnGround(_ origin: JKAShared.vec3_t, _ presencetype: Int32, _ passent: Int32) -> Int32 {
    var end: vec3_t
    let up = vec3_t(0, 0, 1)

    end = origin
    end[2] -= 10

    return AasTrace.scratch { trace -> Int32 in
        let plane: AasPlane?

        trace.copy(from: AAS_TraceClientBBox(origin, end, presencetype, passent))

        //if in solid
        if trace.startsolid {
            return 0
        }
        //if nothing hit at all
        if trace.fraction >= 1.0 {
            return 0
        }
        //if too far from the hit plane
        if origin[2] - trace.endpos[2] > 10 {
            return 0
        }
        //check if the plane isn't too steep
        plane = AAS_PlaneFromNum(trace.planenum)
        if _DotProduct(plane!.normal, up) < aassettings.phys_maxsteepness {
            return 0
        }
        //the bot is on the ground
        return 1
    }
}

//===========================================================================
// returns qtrue if a bot at the given position is swimming
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:198
func AAS_Swimming(_ origin: JKAShared.vec3_t) -> Int32 {
    var testorg: vec3_t

    testorg = origin
    testorg[2] -= 2
    if (AAS_PointContents(testorg) & (CONTENTS_LAVA | CONTENTS_SLIME | CONTENTS_WATER)) != 0 {
        return 1
    }
    return 0
}

/// Source: oracle/codemp/botlib/be_aas_move.cpp:218
func AAS_SetMovedir(_ angles: JKAShared.vec3_t, _ movedir: inout JKAShared.vec3_t) {
    // Port-note: Raven calls this function only from a comment, at be_aas_reach.cpp:3516, so it is dead.
    if VectorCompare(angles, VEC_UP) != 0 {
        movedir = MOVEDIR_UP
    } //end if
    else if VectorCompare(angles, VEC_DOWN) != 0 {
        movedir = MOVEDIR_DOWN
    } //end else if
    else {
        // Raven passes NULL for the right and up outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(angles, &movedir, &scratchRight, &scratchUp)
    } //end else
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:239
func AAS_JumpReachRunStart(_ reach: AasReachability, _ runstart: inout JKAShared.vec3_t) {
    var hordir = vec3_t()
    var start: vec3_t
    let cmdmove: vec3_t

    //
    hordir[0] = reach.start[0] - reach.end[0]
    hordir[1] = reach.start[1] - reach.end[1]
    hordir[2] = 0
    _ = VectorNormalize(&hordir)
    //start point
    start = reach.start
    start[2] += 1
    //get command movement
    cmdmove = hordir * 400
    //
    AasClientmove.scratch { move in
        AAS_PredictClientMovement(move, -1, start, PRESENCE_NORMAL, 1, vec3_origin, cmdmove, 1, 2, 0.1, SE_ENTERWATER | SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE | SE_GAP, 0, 0)
        runstart = move.endpos
        //don't enter slime or lava and don't fall from too high
        if (move.stopevent & (SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE)) != 0 {
            runstart = start
        } //end if
    }
}

//===========================================================================
// returns the Z velocity when rocket jumping at the origin
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:273
func AAS_WeaponJumpZVelocity(_ origin: JKAShared.vec3_t, _ radiusdamage: Float) -> Float {
    var start: vec3_t
    var end = vec3_t()
    var forward = vec3_t()
    var right = vec3_t()
    var viewangles = vec3_t()
    let rocketoffset = vec3_t(8, 8, -8)
    let botmins = vec3_t(-16, -16, -24)
    let botmaxs = vec3_t(16, 16, 32)

    //look down (90 degrees)
    viewangles[PITCH] = 90
    viewangles[YAW] = 0
    viewangles[ROLL] = 0
    //get the start point shooting from
    start = origin
    start[2] += 8 //view offset Z
    // Raven passes NULL for the `up` output, and the scratch local takes the write.
    var scratchUp = vec3_t()
    AngleVectors(viewangles, &forward, &right, &scratchUp)
    start[0] += forward[0] * rocketoffset[0] + right[0] * rocketoffset[1]
    start[1] += forward[1] * rocketoffset[0] + right[1] * rocketoffset[1]
    start[2] += forward[2] * rocketoffset[0] + right[2] * rocketoffset[1] + rocketoffset[2]
    //end point of the trace
    _VectorMA(start, 500, forward, &end)
    return BspTrace.scratch { bsptrace -> Float in
        var kvel = vec3_t()
        var v: vec3_t
        var dir: vec3_t
        let mass: Float
        let knockback: Float
        var points: Float

        //trace a line to get the impact point
        bsptrace.copy(from: AAS_Trace(start, nil, nil, end, 1, CONTENTS_SOLID))
        //calculate the damage the bot will get from the rocket impact
        v = botmins + botmaxs
        v[0] = Float(Double(origin[0]) + Double(v[0]) * 0.5)
        v[1] = Float(Double(origin[1]) + Double(v[1]) * 0.5)
        v[2] = Float(Double(origin[2]) + Double(v[2]) * 0.5)
        v = bsptrace.endpos - v
        //
        points = Float(Double(radiusdamage) - 0.5 * Double(VectorLength(v)))
        if points < 0 {
            points = 0
        }
        //the owner of the rocket gets half the damage
        points = Float(Double(points) * 0.5)
        //mass of the bot (p_client.c: PutClientInServer)
        mass = 200
        //knockback is the same as the damage points
        knockback = points
        //direction of the damage (from trace.endpos to bot origin)
        dir = origin - bsptrace.endpos
        _ = VectorNormalize(&dir)
        //damage velocity
        let scale = 1600.0 * Double(Float(knockback)) / Double(mass)
        kvel[0] = Float(Double(dir[0]) * scale) //the rocket jump hack...
        kvel[1] = Float(Double(dir[1]) * scale)
        kvel[2] = Float(Double(dir[2]) * scale)
        //rocket impact velocity + jump velocity
        return kvel[2] + aassettings.phys_jumpvel
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:324
func AAS_RocketJumpZVelocity(_ origin: JKAShared.vec3_t) -> Float {
    //rocket radius damage is 120 (p_weapon.c: Weapon_RocketLauncher_Fire)
    return AAS_WeaponJumpZVelocity(origin, 120)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:335
func AAS_BFGJumpZVelocity(_ origin: JKAShared.vec3_t) -> Float {
    //bfg radius damage is 1000 (p_weapon.c: weapon_bfg_fire)
    return AAS_WeaponJumpZVelocity(origin, 120)
}

//===========================================================================
// applies ground friction to the given velocity
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:347
func AAS_Accelerate(_ velocity: inout JKAShared.vec3_t, _ frametime: Float, _ wishdir: JKAShared.vec3_t, _ wishspeed: Float, _ accel: Float) {
    // q2 style
    var i: Int32
    let addspeed: Float
    var accelspeed: Float
    let currentspeed: Float

    currentspeed = _DotProduct(velocity, wishdir)
    addspeed = wishspeed - currentspeed
    if addspeed <= 0 {
        return
    }
    accelspeed = accel * frametime * wishspeed
    if accelspeed > addspeed {
        accelspeed = addspeed
    }

    i = 0
    while i < 3 {
        velocity[i] += accelspeed * wishdir[i]
        i += 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:373
func AAS_AirControl(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ velocity: JKAShared.vec3_t, _ cmdmove: JKAShared.vec3_t) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var dir = vec3_t()

    dir = end - start
}

//===========================================================================
// applies ground friction to the given velocity
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:386
func AAS_ApplyFriction(_ vel: inout JKAShared.vec3_t, _ friction: Float, _ stopspeed: Float, _ frametime: Float) {
    let speed: Float
    let control: Float
    var newspeed: Float

    //horizontal speed
    speed = sqrt(vel[0] * vel[0] + vel[1] * vel[1])
    if speed != 0 {
        control = speed < stopspeed ? stopspeed : speed
        newspeed = speed - frametime * control * friction
        if newspeed < 0 {
            newspeed = 0
        }
        newspeed /= speed
        vel[0] *= newspeed
        vel[1] *= newspeed
    } //end if
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:409
func AAS_ClipToBBox(_ trace: AasTrace, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ presencetype: Int32, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) -> Int32 {
    var i: Int32
    var j: Int32
    var side: Int32
    var front: Float
    var back: Float
    var frac: Float
    var planedist: Float
    var bboxmins = vec3_t()
    var bboxmaxs = vec3_t()
    let absmins: vec3_t
    let absmaxs: vec3_t
    let dir: vec3_t
    var mid = vec3_t()

    AAS_PresenceTypeBoundingBox(presencetype, &bboxmins, &bboxmaxs)
    absmins = mins - bboxmaxs
    absmaxs = maxs - bboxmins
    //
    trace.endpos = end
    trace.fraction = 1
    i = 0
    while i < 3 {
        if start[i] < absmins[i] && end[i] < absmins[i] {
            return 0
        }
        if start[i] > absmaxs[i] && end[i] > absmaxs[i] {
            return 0
        }
        i += 1
    } //end for
    //check bounding box collision
    dir = end - start
    frac = 1
    i = 0
    while i < 3 {
        //get plane to test collision with for the current axis direction
        if dir[i] > 0 {
            planedist = absmins[i]
        } else {
            planedist = absmaxs[i]
        }
        //calculate collision fraction
        front = start[i] - planedist
        back = end[i] - planedist
        frac = front / (front - back)
        //check if between bounding planes of next axis
        side = i + 1
        if side > 2 {
            side = 0
        }
        mid[side] = start[side] + dir[side] * frac
        if mid[side] > absmins[side] && mid[side] < absmaxs[side] {
            //check if between bounding planes of next axis
            side += 1
            if side > 2 {
                side = 0
            }
            mid[side] = start[side] + dir[side] * frac
            if mid[side] > absmins[side] && mid[side] < absmaxs[side] {
                mid[i] = planedist
                break
            } //end if
        } //end if
        i += 1
    } //end for
    //if there was a collision
    if i != 3 {
        trace.startsolid = false
        trace.fraction = frac
        trace.ent = 0
        trace.planenum = 0
        trace.area = 0
        trace.lastarea = 0
        //trace endpos
        j = 0
        while j < 3 {
            trace.endpos[j] = start[j] + dir[j] * frac
            j += 1
        }
        return 1
    } //end if
    return 0
}

//===========================================================================
// predicts the movement
// assumes regular bounding box sizes
// NOTE: out of water jumping is not included
// NOTE: grappling hook is not included
//
// Parameter:			origin			: origin to start with
//						presencetype	: presence type to start with
//						velocity		: velocity to start with
//						cmdmove			: client command movement
//						cmdframes		: number of frame cmdmove is valid
//						maxframes		: maximum number of predicted frames
//						frametime		: duration of one predicted frame
//						stopevent		: events that stop the prediction
//						stopareanum		: stop as soon as entered this area
// Returns:				aas_clientmove_t
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:488
func AAS_ClientMovementPrediction(_ move: AasClientmove, _ entnum: Int32, _ origin: JKAShared.vec3_t, _ presencetype: Int32, _ onground: Int32, _ velocity: JKAShared.vec3_t, _ cmdmove: JKAShared.vec3_t, _ cmdframes: Int32, _ maxframes: Int32, _ frametime: Float, _ stopevent: Int32, _ stopareanum: Int32, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ visualize: Int32) -> Int32 {
    // Raven assigns his own `presencetype`, `onground`, and `frametime` parameters.
    // A Swift parameter is immutable, so the body takes mutable copies of them.
    var presencetype = presencetype
    var onground = onground
    var frametime = frametime
    let phys_friction: Float
    let phys_stopspeed: Float
    let phys_gravity: Float
    let phys_waterfriction: Float
    let phys_watergravity: Float
    let phys_walkaccelerate: Float
    let phys_airaccelerate: Float
    let phys_swimaccelerate: Float
    let phys_maxwalkvelocity: Float
    let phys_maxcrouchvelocity: Float
    let phys_maxswimvelocity: Float
    let phys_maxstep: Float
    let phys_maxsteepness: Float
    let phys_jumpvel: Float
    var org = vec3_t()
    var end = vec3_t()
    var start = vec3_t()
    var lastorg = vec3_t()
    var frame_test_vel = vec3_t()
    var old_frame_test_vel = vec3_t()
    var left_test_vel = vec3_t()
    let up = vec3_t(0, 0, 1)

    if frametime <= 0 {
        frametime = 0.1
    }
    //
    phys_friction = aassettings.phys_friction
    phys_stopspeed = aassettings.phys_stopspeed
    phys_gravity = aassettings.phys_gravity
    phys_waterfriction = aassettings.phys_waterfriction
    phys_watergravity = aassettings.phys_watergravity
    phys_maxwalkvelocity = aassettings.phys_maxwalkvelocity // * frametime;
    phys_maxcrouchvelocity = aassettings.phys_maxcrouchvelocity // * frametime;
    phys_maxswimvelocity = aassettings.phys_maxswimvelocity // * frametime;
    phys_walkaccelerate = aassettings.phys_walkaccelerate
    phys_airaccelerate = aassettings.phys_airaccelerate
    phys_swimaccelerate = aassettings.phys_swimaccelerate
    phys_maxstep = aassettings.phys_maxstep
    phys_maxsteepness = aassettings.phys_maxsteepness
    phys_jumpvel = aassettings.phys_jumpvel * frametime
    //
    move.clear()
    return AasTrace.scratch { trace -> Int32 in
        AasTrace.scratch { steptrace -> Int32 in
            var friction: Float
            var gravity: Float
            var delta: Float
            var maxvel: Float
            var wishspeed: Float
            var accelerate: Float
            //float velchange, newvel;
            var n: Int32
            var i: Int32
            var j: Int32
            var pc: Int32
            var step: Int32
            var swimming: Int32
            var ax: Int32
            var crouch: Int32
            var event: Int32
            var jump_frame: Int32
            var areanum: Int32
            var numareas: Int32
            var feet: vec3_t
            var stepend: vec3_t
            var wishdir: vec3_t
            var plane: AasPlane?
            var plane2: AasPlane?

            //start at the current origin
            org = origin
            org[2] = Float(Double(org[2]) + 0.25)
            //velocity to test for the first frame
            frame_test_vel = velocity * frametime
            //
            jump_frame = -1
            //predict a maximum of 'maxframes' ahead
            n = 0
            while n < maxframes {
                swimming = AAS_Swimming(org)
                //get gravity depending on swimming or not
                gravity = swimming != 0 ? phys_watergravity : phys_gravity
                //apply gravity at the START of the frame
                frame_test_vel[2] = Float(Double(frame_test_vel[2]) - (Double(gravity) * 0.1 * Double(frametime)))
                //if on the ground or swimming
                if onground != 0 || swimming != 0 {
                    friction = swimming != 0 ? phys_friction : phys_waterfriction
                    //apply friction
                    frame_test_vel = frame_test_vel * (1 / frametime)
                    AAS_ApplyFriction(&frame_test_vel, friction, phys_stopspeed, frametime)
                    frame_test_vel = frame_test_vel * frametime
                } //end if
                crouch = 0
                //apply command movement
                if n < cmdframes {
                    ax = 0
                    maxvel = phys_maxwalkvelocity
                    accelerate = phys_airaccelerate
                    wishdir = cmdmove
                    if onground != 0 {
                        if cmdmove[2] < -300 {
                            crouch = 1
                            maxvel = phys_maxcrouchvelocity
                        } //end if
                        //if not swimming and upmove is positive then jump
                        if swimming == 0 && cmdmove[2] > 1 {
                            //jump velocity minus the gravity for one frame + 5 for safety
                            frame_test_vel[2] = Float(Double(phys_jumpvel) - (Double(gravity) * 0.1 * Double(frametime)) + 5)
                            jump_frame = n
                            //jumping so air accelerate
                            accelerate = phys_airaccelerate
                        } //end if
                        else {
                            accelerate = phys_walkaccelerate
                        } //end else
                        ax = 2
                    } //end if
                    if swimming != 0 {
                        maxvel = phys_maxswimvelocity
                        accelerate = phys_swimaccelerate
                        ax = 3
                    } //end if
                    else {
                        wishdir[2] = 0
                    } //end else
                    //
                    wishspeed = VectorNormalize(&wishdir)
                    if wishspeed > maxvel {
                        wishspeed = maxvel
                    }
                    frame_test_vel = frame_test_vel * (1 / frametime)
                    AAS_Accelerate(&frame_test_vel, frametime, wishdir, wishspeed, accelerate)
                    frame_test_vel = frame_test_vel * frametime
                    /*
                    for (i = 0; i < ax; i++)
                    {
                        velchange = (cmdmove[i] * frametime) - frame_test_vel[i];
                        if (velchange > phys_maxacceleration) velchange = phys_maxacceleration;
                        else if (velchange < -phys_maxacceleration) velchange = -phys_maxacceleration;
                        newvel = frame_test_vel[i] + velchange;
                        //
                        if (frame_test_vel[i] <= maxvel && newvel > maxvel) frame_test_vel[i] = maxvel;
                        else if (frame_test_vel[i] >= -maxvel && newvel < -maxvel) frame_test_vel[i] = -maxvel;
                        else frame_test_vel[i] = newvel;
                    } //end for
                    */
                } //end if
                if crouch != 0 {
                    presencetype = PRESENCE_CROUCH
                } //end if
                else if presencetype == PRESENCE_CROUCH {
                    if (AAS_PointPresenceType(org) & PRESENCE_NORMAL) != 0 {
                        presencetype = PRESENCE_NORMAL
                    } //end if
                } //end else
                //save the current origin
                lastorg = org
                //move linear during one frame
                left_test_vel = frame_test_vel
                j = 0
                repeat {
                    end = org + left_test_vel
                    //trace a bounding box
                    trace.copy(from: AAS_TraceClientBBox(org, end, presencetype, entnum))
                    //
                    //#ifdef AAS_MOVE_DEBUG
                    if visualize != 0 {
                        if trace.startsolid {
                            botimport.runPrint(PRT_MESSAGE, "PredictMovement: start solid\n")
                        }
                        AAS_DebugLine(org, trace.endpos, LINECOLOR_RED)
                    } //end if
                    //#endif //AAS_MOVE_DEBUG
                    //
                    if (stopevent & (SE_ENTERAREA | SE_TOUCHJUMPPAD | SE_TOUCHTELEPORTER | SE_TOUCHCLUSTERPORTAL)) != 0 {
                        numareas = AAS_TraceAreas(org, trace.endpos, areas_AAS_ClientMovementPrediction, points_AAS_ClientMovementPrediction, 20)
                        i = 0
                        while i < numareas {
                            if (stopevent & SE_ENTERAREA) != 0 {
                                if areas_AAS_ClientMovementPrediction[i] == stopareanum {
                                    move.endpos = points_AAS_ClientMovementPrediction[i]
                                    move.velocity = frame_test_vel * (1 / frametime)
                                    move.endarea = areas_AAS_ClientMovementPrediction[i]
                                    move.trace = trace
                                    move.stopevent = SE_ENTERAREA
                                    move.presencetype = presencetype
                                    move.endcontents = 0
                                    move.time = n * frametime
                                    move.frames = n
                                    return 1
                                } //end if
                            } //end if
                            //NOTE: if not the first frame
                            if (stopevent & SE_TOUCHJUMPPAD) != 0 && n != 0 {
                                if (aasworld.areasettingsSlots[areas_AAS_ClientMovementPrediction[i]].contents & AREACONTENTS_JUMPPAD) != 0 {
                                    move.endpos = points_AAS_ClientMovementPrediction[i]
                                    move.velocity = frame_test_vel * (1 / frametime)
                                    move.endarea = areas_AAS_ClientMovementPrediction[i]
                                    move.trace = trace
                                    move.stopevent = SE_TOUCHJUMPPAD
                                    move.presencetype = presencetype
                                    move.endcontents = 0
                                    move.time = n * frametime
                                    move.frames = n
                                    return 1
                                } //end if
                            } //end if
                            if (stopevent & SE_TOUCHTELEPORTER) != 0 {
                                if (aasworld.areasettingsSlots[areas_AAS_ClientMovementPrediction[i]].contents & AREACONTENTS_TELEPORTER) != 0 {
                                    move.endpos = points_AAS_ClientMovementPrediction[i]
                                    move.endarea = areas_AAS_ClientMovementPrediction[i]
                                    move.velocity = frame_test_vel * (1 / frametime)
                                    move.trace = trace
                                    move.stopevent = SE_TOUCHTELEPORTER
                                    move.presencetype = presencetype
                                    move.endcontents = 0
                                    move.time = n * frametime
                                    move.frames = n
                                    return 1
                                } //end if
                            } //end if
                            if (stopevent & SE_TOUCHCLUSTERPORTAL) != 0 {
                                if (aasworld.areasettingsSlots[areas_AAS_ClientMovementPrediction[i]].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
                                    move.endpos = points_AAS_ClientMovementPrediction[i]
                                    move.endarea = areas_AAS_ClientMovementPrediction[i]
                                    move.velocity = frame_test_vel * (1 / frametime)
                                    move.trace = trace
                                    move.stopevent = SE_TOUCHCLUSTERPORTAL
                                    move.presencetype = presencetype
                                    move.endcontents = 0
                                    move.time = n * frametime
                                    move.frames = n
                                    return 1
                                } //end if
                            } //end if
                            i += 1
                        } //end for
                    } //end if
                    //
                    if (stopevent & SE_HITBOUNDINGBOX) != 0 {
                        if AAS_ClipToBBox(trace, org, trace.endpos, presencetype, mins, maxs) != 0 {
                            move.endpos = trace.endpos
                            move.endarea = AAS_PointAreaNum(move.endpos)
                            move.velocity = frame_test_vel * (1 / frametime)
                            move.trace = trace
                            move.stopevent = SE_HITBOUNDINGBOX
                            move.presencetype = presencetype
                            move.endcontents = 0
                            move.time = n * frametime
                            move.frames = n
                            return 1
                        } //end if
                    } //end if
                    //move the entity to the trace end point
                    org = trace.endpos
                    //if there was a collision
                    if trace.fraction < 1.0 {
                        //get the plane the bounding box collided with
                        plane = AAS_PlaneFromNum(trace.planenum)
                        //
                        if (stopevent & SE_HITGROUNDAREA) != 0 {
                            if _DotProduct(plane!.normal, up) > phys_maxsteepness {
                                start = org
                                start[2] = Float(Double(start[2]) + 0.5)
                                if AAS_PointAreaNum(start) == stopareanum {
                                    move.endpos = start
                                    move.endarea = stopareanum
                                    move.velocity = frame_test_vel * (1 / frametime)
                                    move.trace = trace
                                    move.stopevent = SE_HITGROUNDAREA
                                    move.presencetype = presencetype
                                    move.endcontents = 0
                                    move.time = n * frametime
                                    move.frames = n
                                    return 1
                                } //end if
                            } //end if
                        } //end if
                        //assume there's no step
                        step = 0
                        //if it is a vertical plane and the bot didn't jump recently
                        if plane!.normal[2] == 0 && (jump_frame < 0 || n - jump_frame > 2) {
                            //check for a step
                            start[0] = Float(Double(org[0]) + Double(plane!.normal[0]) * -0.25)
                            start[1] = Float(Double(org[1]) + Double(plane!.normal[1]) * -0.25)
                            start[2] = Float(Double(org[2]) + Double(plane!.normal[2]) * -0.25)
                            stepend = start
                            start[2] += phys_maxstep
                            steptrace.copy(from: AAS_TraceClientBBox(start, stepend, presencetype, entnum))
                            //
                            if !steptrace.startsolid {
                                plane2 = AAS_PlaneFromNum(steptrace.planenum)
                                if _DotProduct(plane2!.normal, up) > phys_maxsteepness {
                                    left_test_vel = end - steptrace.endpos
                                    left_test_vel[2] = 0
                                    frame_test_vel[2] = 0
                                    //#ifdef AAS_MOVE_DEBUG
                                    if visualize != 0 {
                                        if steptrace.endpos[2] - org[2] > 0.125 {
                                            start = org
                                            start[2] = steptrace.endpos[2]
                                            AAS_DebugLine(org, start, LINECOLOR_BLUE)
                                        } //end if
                                    } //end if
                                    //#endif //AAS_MOVE_DEBUG
                                    org[2] = steptrace.endpos[2]
                                    step = 1
                                } //end if
                            } //end if
                        } //end if
                        //
                        if step == 0 {
                            //velocity left to test for this frame is the projection
                            //of the current test velocity into the hit plane
                            // VectorMA evaluates its scale once per component, after the store to the component before it.
                            left_test_vel[0] = left_test_vel[0] + plane!.normal[0] * -_DotProduct(left_test_vel, plane!.normal)
                            left_test_vel[1] = left_test_vel[1] + plane!.normal[1] * -_DotProduct(left_test_vel, plane!.normal)
                            left_test_vel[2] = left_test_vel[2] + plane!.normal[2] * -_DotProduct(left_test_vel, plane!.normal)
                            //store the old velocity for landing check
                            old_frame_test_vel = frame_test_vel
                            //test velocity for the next frame is the projection
                            //of the velocity of the current frame into the hit plane
                            frame_test_vel[0] = frame_test_vel[0] + plane!.normal[0] * -_DotProduct(frame_test_vel, plane!.normal)
                            frame_test_vel[1] = frame_test_vel[1] + plane!.normal[1] * -_DotProduct(frame_test_vel, plane!.normal)
                            frame_test_vel[2] = frame_test_vel[2] + plane!.normal[2] * -_DotProduct(frame_test_vel, plane!.normal)
                            //check for a landing on an almost horizontal floor
                            if _DotProduct(plane!.normal, up) > phys_maxsteepness {
                                onground = 1
                            } //end if
                            if (stopevent & SE_HITGROUNDDAMAGE) != 0 {
                                delta = 0
                                if old_frame_test_vel[2] < 0 && frame_test_vel[2] > old_frame_test_vel[2] && onground == 0 {
                                    delta = old_frame_test_vel[2]
                                } //end if
                                else if onground != 0 {
                                    delta = frame_test_vel[2] - old_frame_test_vel[2]
                                } //end else
                                if delta != 0 {
                                    delta = delta * 10
                                    delta = Float(Double(delta * delta) * 0.0001)
                                    if swimming != 0 {
                                        delta = 0
                                    }
                                    // never take falling damage if completely underwater
                                    /*
                                    if (ent->waterlevel == 3) return;
                                    if (ent->waterlevel == 2) delta *= 0.25;
                                    if (ent->waterlevel == 1) delta *= 0.5;
                                    */
                                    if delta > 40 {
                                        move.endpos = org
                                        move.endarea = AAS_PointAreaNum(org)
                                        move.velocity = frame_test_vel
                                        move.trace = trace
                                        move.stopevent = SE_HITGROUNDDAMAGE
                                        move.presencetype = presencetype
                                        move.endcontents = 0
                                        move.time = n * frametime
                                        move.frames = n
                                        return 1
                                    } //end if
                                } //end if
                            } //end if
                        } //end if
                    } //end if
                    //extra check to prevent endless loop
                    j += 1
                    if j > 20 {
                        return 0
                    }
                    //while there is a plane hit
                } while trace.fraction < 1.0
                //if going down
                if frame_test_vel[2] <= 10 {
                    //check for a liquid at the feet of the bot
                    feet = org
                    feet[2] -= 22
                    pc = AAS_PointContents(feet)
                    //get event from pc
                    event = SE_NONE
                    if (pc & CONTENTS_LAVA) != 0 {
                        event |= SE_ENTERLAVA
                    }
                    if (pc & CONTENTS_SLIME) != 0 {
                        event |= SE_ENTERSLIME
                    }
                    if (pc & CONTENTS_WATER) != 0 {
                        event |= SE_ENTERWATER
                    }
                    //
                    areanum = AAS_PointAreaNum(org)
                    if (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_LAVA) != 0 {
                        event |= SE_ENTERLAVA
                    }
                    if (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_SLIME) != 0 {
                        event |= SE_ENTERSLIME
                    }
                    if (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_WATER) != 0 {
                        event |= SE_ENTERWATER
                    }
                    //if in lava or slime
                    if (event & stopevent) != 0 {
                        move.endpos = org
                        move.endarea = areanum
                        move.velocity = frame_test_vel * (1 / frametime)
                        move.stopevent = event & stopevent
                        move.presencetype = presencetype
                        move.endcontents = pc
                        move.time = n * frametime
                        move.frames = n
                        return 1
                    } //end if
                } //end if
                //
                onground = AAS_OnGround(org, presencetype, entnum)
                //if onground and on the ground for at least one whole frame
                if onground != 0 {
                    if (stopevent & SE_HITGROUND) != 0 {
                        move.endpos = org
                        move.endarea = AAS_PointAreaNum(org)
                        move.velocity = frame_test_vel * (1 / frametime)
                        move.trace = trace
                        move.stopevent = SE_HITGROUND
                        move.presencetype = presencetype
                        move.endcontents = 0
                        move.time = n * frametime
                        move.frames = n
                        return 1
                    } //end if
                } //end if
                else if (stopevent & SE_LEAVEGROUND) != 0 {
                    move.endpos = org
                    move.endarea = AAS_PointAreaNum(org)
                    move.velocity = frame_test_vel * (1 / frametime)
                    move.trace = trace
                    move.stopevent = SE_LEAVEGROUND
                    move.presencetype = presencetype
                    move.endcontents = 0
                    move.time = n * frametime
                    move.frames = n
                    return 1
                } //end else if
                else if (stopevent & SE_GAP) != 0 {
                    let stopped = AasTrace.scratch { gaptrace -> Bool in
                        start = org
                        end = start
                        end[2] -= 48 + aassettings.phys_maxbarrier
                        gaptrace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, -1))
                        //if solid is found the bot cannot walk any further and will not fall into a gap
                        if !gaptrace.startsolid {
                            //if it is a gap (lower than one step height)
                            if gaptrace.endpos[2] < org[2] - aassettings.phys_maxstep - 1 {
                                if (AAS_PointContents(end) & CONTENTS_WATER) == 0 {
                                    move.endpos = lastorg
                                    move.endarea = AAS_PointAreaNum(lastorg)
                                    move.velocity = frame_test_vel * (1 / frametime)
                                    move.trace = trace
                                    move.stopevent = SE_GAP
                                    move.presencetype = presencetype
                                    move.endcontents = 0
                                    move.time = n * frametime
                                    move.frames = n
                                    return true
                                } //end if
                            } //end if
                        } //end if
                        return false
                    }
                    if stopped {
                        return 1
                    }
                } //end else if
                n += 1
            } //end for
            //
            move.endpos = org
            move.endarea = AAS_PointAreaNum(org)
            move.velocity = frame_test_vel * (1 / frametime)
            move.stopevent = SE_NONE
            move.presencetype = presencetype
            move.endcontents = 0
            move.time = n * frametime
            move.frames = n
            //
            return 1
        }
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:977
func AAS_PredictClientMovement(_ move: AasClientmove, _ entnum: Int32, _ origin: JKAShared.vec3_t, _ presencetype: Int32, _ onground: Int32, _ velocity: JKAShared.vec3_t, _ cmdmove: JKAShared.vec3_t, _ cmdframes: Int32, _ maxframes: Int32, _ frametime: Float, _ stopevent: Int32, _ stopareanum: Int32, _ visualize: Int32) -> Int32 {
    // Port-note: Raven passes `mins` and `maxs` uninitialized, and the callee reads them only for SE_HITBOUNDINGBOX.
    // No caller of this function sets that event.
    // The locals are zero.
    let mins = vec3_t()
    let maxs = vec3_t()
    return AAS_ClientMovementPrediction(move, entnum, origin, presencetype, onground, velocity, cmdmove, cmdframes, maxframes, frametime, stopevent, stopareanum, mins, maxs, visualize)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:997
func AAS_ClientMovementHitBBox(_ move: AasClientmove, _ entnum: Int32, _ origin: JKAShared.vec3_t, _ presencetype: Int32, _ onground: Int32, _ velocity: JKAShared.vec3_t, _ cmdmove: JKAShared.vec3_t, _ cmdframes: Int32, _ maxframes: Int32, _ frametime: Float, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ visualize: Int32) -> Int32 {
    return AAS_ClientMovementPrediction(move, entnum, origin, presencetype, onground, velocity, cmdmove, cmdframes, maxframes, frametime, SE_HITBOUNDINGBOX, 0, mins, maxs, visualize)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:1016
func AAS_TestMovementPrediction(_ entnum: Int32, _ origin: JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t) {
    // Port-note: Raven calls this function only from a comment of BotExportTest, so it is dead.
    var velocity = vec3_t(), cmdmove = vec3_t()

    velocity = vec3_t()
    if AAS_Swimming(origin) == 0 { dir[2] = 0 }
    _ = VectorNormalize(&dir)
    cmdmove = dir * 400
    cmdmove[2] = 224
    AAS_ClearShownDebugLines()
    AasClientmove.scratch { move in
        AAS_PredictClientMovement(move, entnum, origin, PRESENCE_NORMAL, 1,
                                    velocity, cmdmove, 13, 13, 0.1, SE_HITGROUND, 0, 1)//SE_LEAVEGROUND);
        if (move.stopevent & SE_LEAVEGROUND) != 0 {
            botimport.runPrint(PRT_MESSAGE, "leave ground\n")
        } //end if
    }
}

//===========================================================================
// calculates the horizontal velocity needed to perform a jump from start
// to end
//
// Parameter:			zvel	: z velocity for jump
//						start	: start position of jump
//						end		: end position of jump
//						*speed	: returned speed for jump
// Returns:				qfalse if too high or too far from start to end
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_move.cpp:1045
func AAS_HorizontalVelocityForJump(_ zvel: Float, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ velocity: inout Float) -> Int32 {
    let phys_gravity: Float
    let phys_maxvelocity: Float
    let maxjump: Float
    let height2fall: Float
    let t: Float
    let top: Float
    let dir: vec3_t

    phys_gravity = aassettings.phys_gravity
    phys_maxvelocity = aassettings.phys_maxvelocity

    //maximum height a player can jump with the given initial z velocity
    maxjump = Float(0.5 * Double(phys_gravity) * Double(zvel / phys_gravity) * Double(zvel / phys_gravity))
    //top of the parabolic jump
    top = start[2] + maxjump
    //height the bot will fall from the top
    height2fall = top - end[2]
    //if the goal is to high to jump to
    if height2fall < 0 {
        velocity = phys_maxvelocity
        return 0
    } //end if
    //time a player takes to fall the height
    t = Float(sqrt(Double(height2fall) / (0.5 * Double(phys_gravity))))
    //direction from start to end
    dir = end - start
    //
    if (t + zvel / phys_gravity) == 0.0 {
        velocity = phys_maxvelocity
        return 0
    }
    //calculate horizontal speed
    velocity = sqrt(dir[0] * dir[0] + dir[1] * dir[1]) / (t + zvel / phys_gravity)
    //the horizontal speed must be lower than the max speed
    if velocity > phys_maxvelocity {
        velocity = phys_maxvelocity
        return 0
    } //end if
    return 1
}
