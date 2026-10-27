import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_mover.c:24
var pushed: Slots<Pushed> { world.storage.pushed }

/// Source: oracle/codemp/game/g_mover.c:24
/// Raven walks `pushed_p` over `pushed`, so the port holds the index of the slot it points at.
var pushed_pIndex: Int32 {
    get { world.variables.pushed_pIndex }
    set { world.variables.pushed_pIndex = newValue }
}

/// Source: oracle/codemp/game/g_mover.c:26
let MOVER_START_ON = 1 as Int32

/// Source: oracle/codemp/game/g_mover.c:27
let MOVER_FORCE_ACTIVATE = 2 as Int32

/// Source: oracle/codemp/game/g_mover.c:28
let MOVER_CRUSHER = 4 as Int32

/// Source: oracle/codemp/game/g_mover.c:29
let MOVER_TOGGLE = 8 as Int32

/// Source: oracle/codemp/game/g_mover.c:30
let MOVER_LOCKED = 16 as Int32

/// Source: oracle/codemp/game/g_mover.c:31
let MOVER_GOODIE = 32 as Int32

/// Source: oracle/codemp/game/g_mover.c:32
let MOVER_PLAYER_USE = 64 as Int32

/// Source: oracle/codemp/game/g_mover.c:33
let MOVER_INACTIVE = 128 as Int32

/// Source: oracle/codemp/game/g_mover.c:35
// Raven wrote: int BMS_START = 0
let BMS_START: Int32 = 0

/// Source: oracle/codemp/game/g_mover.c:36
// Raven wrote: int BMS_MID = 1
let BMS_MID: Int32 = 1

/// Source: oracle/codemp/game/g_mover.c:37
// Raven wrote: int BMS_END = 2
let BMS_END: Int32 = 2

/// Source: oracle/codemp/game/g_mover.c:1716
let TRAIN_START_ON = 1 as Int32

/// Source: oracle/codemp/game/g_mover.c:1717
let TRAIN_TOGGLE = 2 as Int32

/// Source: oracle/codemp/game/g_mover.c:1718
let TRAIN_BLOCK_STOPS = 4 as Int32

/// Source: oracle/codemp/game/g_mover.c:3243
let FUNC_WALL_OFF = 1 as Int32

/// Source: oracle/codemp/game/g_mover.c:45
func G_PlayDoorLoopSound(_ ent: Entity) {
    if ent.soundSet == nil || ent.soundSet!.isEmpty {
        return
    }

    ent.s.soundSetIndex = G_SoundSetIndex(ent.soundSet!)
    ent.s.loopIsSoundset = true
    ent.s.loopSound = BMS_MID
    /*
    ent->s.soundSetIndex = G_SoundSetIndex(ent->soundSet);
    ent->loopingOnClient = qtrue;
    G_AddEvent(ent, EV_PLAYDOORLOOPSOUND, 0);
    */
}

/// Source: oracle/codemp/game/g_mover.c:68
func G_PlayDoorSound(_ ent: Entity, _ type: Int32) {
    if ent.soundSet == nil || ent.soundSet!.isEmpty {
        return
    }

    ent.s.soundSetIndex = G_SoundSetIndex(ent.soundSet!)

    G_AddEvent(ent, EV_PLAYDOORSOUND, type)
}

/**
```
============
G_TestEntityPosition

============
```
*/
/// Source: oracle/codemp/game/g_mover.c:86
func G_TestEntityPosition(_ ent: Entity) -> Entity? {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Entity? in
        var mask: Int32 = 0

        if ent.clipmask != 0 {
            mask = ent.clipmask
        } else {
            mask = MASK_SOLID
        }
        if ent.client != nil {
            var vMax = vec3_t()
            vMax = ent.r.maxs
            if vMax[2] < 1 {
                vMax[2] = 1
            }
            trap_Trace(tr, ent.client!.ps.origin, ent.r.mins, vMax, ent.client!.ps.origin, ent.s.number, mask)
        } else {
            trap_Trace(tr, ent.s.pos.trBase, ent.r.mins, ent.r.maxs, ent.s.pos.trBase, ent.s.number, mask)
        }

        if tr.startsolid != 0 {
            return g_entities[tr.entityNum]
        }

        return nil
    }
}

/**
```
================
G_CreateRotationMatrix
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:118
func G_CreateRotationMatrix(_ angles: JKAShared.vec3_t, _ matrix: inout [JKAShared.vec3_t]) {
    do {
        var matrix0 = matrix[0]
        var matrix1 = matrix[1]
        var matrix2 = matrix[2]
        AngleVectors(angles, &matrix0, &matrix1, &matrix2)
        matrix[0] = matrix0
        matrix[1] = matrix1
        matrix[2] = matrix2
    }
    VectorInverse(&matrix[1])
}

/**
```
================
G_TransposeMatrix
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:128
func G_TransposeMatrix(_ matrix: inout [JKAShared.vec3_t], _ transpose: inout [JKAShared.vec3_t]) {
    var i: Int32
    var j: Int32
    i = 0
    while i < 3 {
        j = 0
        while j < 3 {
            transpose[i][j] = matrix[j][i]
            j += 1
        }
        i += 1
    }
}

/**
```
================
G_RotatePoint
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:142
func G_RotatePoint(_ point: inout JKAShared.vec3_t, _ matrix: inout [JKAShared.vec3_t]) {
    var tvec = vec3_t()

    tvec = point
    point[0] = _DotProduct(matrix[0], tvec)
    point[1] = _DotProduct(matrix[1], tvec)
    point[2] = _DotProduct(matrix[2], tvec)
}

/// Source: oracle/codemp/game/g_mover.c:159
func G_TryPushingEntity(_ check: Entity, _ pusher: Entity, _ move: JKAShared.vec3_t, _ amove: JKAShared.vec3_t) -> Bool {
    var matrix = [vec3_t](repeating: vec3_t(), count: 3)
    var transpose = [vec3_t](repeating: vec3_t(), count: 3)
    var org = vec3_t()
    var org2 = vec3_t()
    var move2 = vec3_t()
    var block: Entity?

    //This was only serverside not to mention it was never set.
    /*
    // EF_MOVER_STOP will just stop when contacting another entity
    // instead of pushing it, but entities can still ride on top of it
    if ( ( pusher->s.eFlags & EF_MOVER_STOP ) &&
    check->s.groundEntityNum != pusher->s.number ) {
    return qfalse;
    }
    */
    if pusher.s.apos.trType != TR_STATIONARY && (pusher.spawnflags & 16) != 0 && Q_stricmp("func_rotating", pusher.classname!) == 0 {
        //just blow the fuck out of them
        /*
        if ( check->m_pVehicle )
        {
        G_DamageFromKiller( check, check, pusher, NULL, pusher->damage, DAMAGE_NO_KNOCKBACK, MOD_CRUSH );
        }
        else
        */
        do {
            var dir: vec3_t? = nil
            G_Damage(check, pusher, pusher, &dir, nil, pusher.damage, DAMAGE_NO_KNOCKBACK, MOD_CRUSH)
        }
        return true
    }

    // save off the old position
    if pushed_pIndex > MAX_GENTITIES {
        G_Error("pushed_p > &pushed[MAX_GENTITIES]")
    }
    pushed[pushed_pIndex].ent = check
    pushed[pushed_pIndex].origin = check.s.pos.trBase
    pushed[pushed_pIndex].angles = check.s.apos.trBase
    if check.client != nil {
        pushed[pushed_pIndex].deltayaw = Float(check.client!.ps.delta_angles[YAW])
        pushed[pushed_pIndex].origin = check.client!.ps.origin
    }
    pushed_pIndex += 1

    // try moving the contacted entity
    // figure movement due to the pusher's amove
    G_CreateRotationMatrix(amove, &transpose)
    G_TransposeMatrix(&transpose, &matrix)
    if check.client != nil {
        org = check.client!.ps.origin - pusher.r.currentOrigin
    } else {
        org = check.s.pos.trBase - pusher.r.currentOrigin
    }
    org2 = org
    G_RotatePoint(&org2, &matrix)
    move2 = org2 - org
    // add movement
    check.s.pos.trBase = check.s.pos.trBase + move
    check.s.pos.trBase = check.s.pos.trBase + move2
    if check.client != nil {
        check.client!.ps.origin = check.client!.ps.origin + move
        check.client!.ps.origin = check.client!.ps.origin + move2
        // make sure the client's view rotates when on a rotating mover
        check.client!.ps.delta_angles[YAW] += ANGLE2SHORT(amove[YAW])
    }

    // may have pushed them off an edge
    if check.s.groundEntityNum != pusher.s.number {
        check.s.groundEntityNum = ENTITYNUM_NONE //-1;
    }

    block = G_TestEntityPosition(check)
    if block == nil {
        // pushed ok
        if check.client != nil {
            check.r.currentOrigin = check.client!.ps.origin
        } else {
            check.r.currentOrigin = check.s.pos.trBase
        }
        trap_LinkEntity(check)
        return true
    }

    if check.takedamage && check.client == nil && check.s.weapon != 0 && check.r.ownerNum < MAX_CLIENTS && check.health < 500 {
        if check.health > 0 {
            // G_Damage writes its `dir`, so the call passes a copy of `vec3_origin`.
            var dir = vec3_origin
            G_Damage(check, pusher, pusher, &dir, check.r.currentOrigin, 999, 0, MOD_UNKNOWN)
        }
        return false
    }
    // if it is ok to leave in the old position, do it
    // this is only relevent for riding entities, not pushed
    // Sliding trapdoors can cause this.
    check.s.pos.trBase = pushed[pushed_pIndex - 1].origin
    if check.client != nil {
        check.client!.ps.origin = pushed[pushed_pIndex - 1].origin
    }
    check.s.apos.trBase = pushed[pushed_pIndex - 1].angles
    block = G_TestEntityPosition(check)
    if block == nil {
        check.s.groundEntityNum = -1
        pushed_pIndex -= 1
        return true
    }

    // blocked
    return false
}

/**
```
============
G_MoverPush

Objects need to be moved back on a failed push,
otherwise riders would continue to slide.
If qfalse is returned, *obstacle will be the blocking entity
============
```
*/
/// Source: oracle/codemp/game/g_mover.c:283
func G_MoverPush(_ pusher: Entity, _ move: JKAShared.vec3_t, _ amove: JKAShared.vec3_t, _ obstacle: inout Entity?) -> Bool {
    var i: Int32
    var e: Int32
    var check: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()
    var pIndex: Int32 = 0
    var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
    let listedEntities: Int32
    var totalMins = vec3_t()
    var totalMaxs = vec3_t()

    obstacle = nil


    // mins/maxs are the bounds at the destination
    // totalMins / totalMaxs are the bounds for the entire move
    if pusher.r.currentAngles[0] != 0 || pusher.r.currentAngles[1] != 0 || pusher.r.currentAngles[2] != 0 || amove[0] != 0 || amove[1] != 0 || amove[2] != 0 {
        let radius: Float

        radius = RadiusFromBounds(pusher.r.mins, pusher.r.maxs)
        i = 0
        while i < 3 {
            mins[i] = pusher.r.currentOrigin[i] + move[i] - radius
            maxs[i] = pusher.r.currentOrigin[i] + move[i] + radius
            totalMins[i] = mins[i] - move[i]
            totalMaxs[i] = maxs[i] - move[i]
            i += 1
        }
    } else {
        i = 0
        while i < 3 {
            mins[i] = pusher.r.absmin[i] + move[i]
            maxs[i] = pusher.r.absmax[i] + move[i]
            i += 1
        }

        totalMins = pusher.r.absmin
        totalMaxs = pusher.r.absmax
        i = 0
        while i < 3 {
            if move[i] > 0 {
                totalMaxs[i] += move[i]
            } else {
                totalMins[i] += move[i]
            }
            i += 1
        }
    }

    // unlink the pusher so we don't get it in the entityList
    trap_UnlinkEntity(pusher)

    listedEntities = trap_EntitiesInBox(totalMins, totalMaxs, &entityList, MAX_GENTITIES)

    // move the pusher to it's final position
    pusher.r.currentOrigin = pusher.r.currentOrigin + move
    pusher.r.currentAngles = pusher.r.currentAngles + amove
    trap_LinkEntity(pusher)

    // see if any solid entities are inside the final position
    e = 0
    while e < listedEntities {
        check = g_entities[entityList[e]]

        // only push items and players
        if check!.s.eType != ET_PLAYER && check!.s.eType != ET_NPC && !check!.physicsObject {
            e += 1
            continue
        }

        // if the entity is standing on the pusher, it will definitely be moved
        if check!.s.groundEntityNum != pusher.s.number {
            // see if the ent needs to be tested
            if check!.r.absmin[0] >= maxs[0] || check!.r.absmin[1] >= maxs[1] || check!.r.absmin[2] >= maxs[2] || check!.r.absmax[0] <= mins[0] || check!.r.absmax[1] <= mins[1] || check!.r.absmax[2] <= mins[2] {
                e += 1
                continue
            }
            // see if the ent's bbox is inside the pusher's final position
            // this does allow a fast moving object to pass through a thin entity...
            if G_TestEntityPosition(check!) == nil {
                e += 1
                continue
            }
        }

        // the entity needs to be pushed
        if G_TryPushingEntity(check!, pusher, move, amove) {
            e += 1
            continue
        }

        if pusher.damage != 0 && check!.client != nil && (pusher.spawnflags & 32) != 0 {
            var dir: vec3_t? = nil
            G_Damage(check!, pusher, pusher, &dir, nil, pusher.damage, 0, MOD_CRUSH)
            e += 1
            continue
        }

        if check!.s.eType == ET_BODY || (check!.s.eType == ET_PLAYER && check!.health < 1) {
            //whatever, just crush it
            var dir: vec3_t? = nil
            G_Damage(check!, pusher, pusher, &dir, nil, 999, 0, MOD_CRUSH)
            e += 1
            continue
        }

        // the move was blocked an entity

        // bobbing entities are instant-kill and never get blocked
        if pusher.s.pos.trType == TR_SINE || pusher.s.apos.trType == TR_SINE {
            var dir: vec3_t? = nil
            G_Damage(check!, pusher, pusher, &dir, nil, 99999, 0, MOD_CRUSH)
            e += 1
            continue
        }


        // save off the obstacle so we can call the block function (crush, etc)
        obstacle = check

        // move back any entities we already moved
        // go backwards, so if the same entity was pushed
        // twice, it goes back to the original position
        pIndex = pushed_pIndex - 1
        while pIndex >= 0 {
            pushed[pIndex].ent!.s.pos.trBase = pushed[pIndex].origin
            pushed[pIndex].ent!.s.apos.trBase = pushed[pIndex].angles
            if pushed[pIndex].ent!.client != nil {
                pushed[pIndex].ent!.client!.ps.delta_angles[YAW] = Int32(pushed[pIndex].deltayaw)
                pushed[pIndex].ent!.client!.ps.origin = pushed[pIndex].origin
            }
            trap_LinkEntity(pushed[pIndex].ent!)
            pIndex -= 1
        }
        return false
        e += 1
    }

    return true
}

/**
```
=================
G_MoverTeam
=================
```
*/
/// Source: oracle/codemp/game/g_mover.c:416
func G_MoverTeam(_ ent: Entity) {
    var move = vec3_t()
    var amove = vec3_t()
    var part: Entity?
    var obstacle: Entity?
    var origin = vec3_t()
    var angles = vec3_t()

    obstacle = nil

    // make sure all team slaves can move before commiting
    // any moves or calling any think functions
    // if the move is blocked, all moved objects will be backed out
    pushed_pIndex = 0
    part = ent
    while part != nil {
        // get current position
        BG_EvaluateTrajectory(part!.s.pos, level.time, &origin)
        BG_EvaluateTrajectory(part!.s.apos, level.time, &angles)
        move = origin - part!.r.currentOrigin
        amove = angles - part!.r.currentAngles
        if VectorCompare(move, vec3_origin) == 0 || VectorCompare(amove, vec3_origin) == 0 {
            //actually moved
            if !G_MoverPush(part!, move, amove, &obstacle) {
                break // move was blocked
            }
        }
        part = part!.teamchain
    }

    if part != nil {
        // go back to the previous position
        part = ent
        while part != nil {
            part!.s.pos.trTime += level.time - level.previousTime
            part!.s.apos.trTime += level.time - level.previousTime
            BG_EvaluateTrajectory(part!.s.pos, level.time, &part!.r.currentOrigin)
            BG_EvaluateTrajectory(part!.s.apos, level.time, &part!.r.currentAngles)
            trap_LinkEntity(part!)
            part = part!.teamchain
        }

        // if the pusher has a "blocked" function, call it
        if ent.blocked != nil {
            ent.runBlocked(obstacle)
        }
        return
    }

    // the move succeeded
    part = ent
    while part != nil {
        // call the reached function if time is at or past end point
        if part!.s.pos.trType == TR_LINEAR_STOP || part!.s.pos.trType == TR_NONLINEAR_STOP {
            if level.time >= part!.s.pos.trTime + part!.s.pos.trDuration {
                if part!.reached != nil {
                    part!.runReached()
                }
            }
        }
        part = part!.teamchain
    }
}

/**
```
================
G_RunMover

================
```
*/
/// Source: oracle/codemp/game/g_mover.c:479
func G_RunMover(_ ent: Entity) {
    // if not a team captain, don't do anything, because
    // the captain will handle everything
    if (ent.flags & FL_TEAMSLAVE) != 0 {
        return
    }

    // if stationary at one of the positions, don't move anything
    if ent.s.pos.trType != TR_STATIONARY || ent.s.apos.trType != TR_STATIONARY {
        G_MoverTeam(ent)
    }

    // check think function
    G_RunThink(ent)
}

/// Source: oracle/codemp/game/g_mover.c:511
func CalcTeamDoorCenter(_ ent: Entity, _ center: inout JKAShared.vec3_t) {
    var slavecenter = vec3_t()
    var slave: Entity?

    //Start with our center
    center = ent.r.mins + ent.r.maxs
    center = center * 0.5
    slave = ent.teamchain
    while slave != nil {
        //Find slave's center
        slavecenter = slave!.r.mins + slave!.r.maxs
        slavecenter = slavecenter * 0.5
        //Add that to our own, find middle
        center = center + slavecenter
        center = center * 0.5
        slave = slave!.teamchain
    }
}

/**
```
===============
SetMoverState
===============
```
*/
/// Source: oracle/codemp/game/g_mover.c:535
func SetMoverState(_ ent: Entity, _ moverState: moverState_t, _ time: Int32) {
    var delta = vec3_t()
    var f: Float

    ent.moverState = moverState

    ent.s.pos.trTime = time

    if ent.s.pos.trDuration <= 0 {
        //Don't allow divide by zero!
        ent.s.pos.trDuration = 1
    }

    switch moverState {
    case MOVER_POS1:
        ent.s.pos.trBase = ent.pos1
        ent.s.pos.trType = TR_STATIONARY

    case MOVER_POS2:
        ent.s.pos.trBase = ent.pos2
        ent.s.pos.trType = TR_STATIONARY

    case MOVER_1TO2:
        ent.s.pos.trBase = ent.pos1
        delta = ent.pos2 - ent.pos1
        f = Float(1000.0 / Double(ent.s.pos.trDuration))
        ent.s.pos.trDelta = delta * f
        if ent.alt_fire {
            ent.s.pos.trType = TR_LINEAR_STOP
        } else {
            ent.s.pos.trType = TR_NONLINEAR_STOP
        }

    case MOVER_2TO1:
        ent.s.pos.trBase = ent.pos2
        delta = ent.pos1 - ent.pos2
        f = Float(1000.0 / Double(ent.s.pos.trDuration))
        ent.s.pos.trDelta = delta * f
        if ent.alt_fire {
            ent.s.pos.trType = TR_LINEAR_STOP
        } else {
            ent.s.pos.trType = TR_NONLINEAR_STOP
        }

    default:
        break
    }
    BG_EvaluateTrajectory(ent.s.pos, level.time, &ent.r.currentOrigin)
    trap_LinkEntity(ent)
}

/**
```
================
MatchTeam

All entities in a mover team will move from pos1 to pos2
in the same amount of time
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:600
func MatchTeam(_ teamLeader: Entity, _ moverState: Int32, _ time: Int32) {
    var slave: Entity?

    slave = teamLeader
    while slave != nil {
        SetMoverState(slave!, moverState_t(moverState), time)
        slave = slave!.teamchain
    }
}

/**
```
================
ReturnToPos1
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:615
func ReturnToPos1(_ ent: Entity) {
    ent.think = nil
    ent.nextthink = 0
    ent.s.time = level.time

    MatchTeam(ent, MOVER_2TO1, level.time)

    // starting sound
    G_PlayDoorLoopSound(ent)
    G_PlayDoorSound(ent, BMS_START) //??
}

/// Source: oracle/codemp/game/g_mover.c:634
func Reached_BinaryMover(_ ent: Entity) {
    // stop the looping sound
    ent.s.loopSound = 0
    ent.s.loopIsSoundset = false

    if ent.moverState == MOVER_1TO2 {
        //reached open
        var doorcenter = vec3_t()

        // reached pos2
        SetMoverState(ent, MOVER_POS2, level.time)

        CalcTeamDoorCenter(ent, &doorcenter)

        // play sound
        G_PlayDoorSound(ent, BMS_END)

        if ent.wait < 0 {
            //Done for good
            ent.think = nil
            ent.nextthink = 0
            ent.use = nil
        } else {
            // return to pos1 after a delay
            ent.think = Think.ReturnToPos1
            if (ent.spawnflags & 8) != 0 {
                //Toggle, keep think, wait for next use?
                ent.nextthink = -1
            } else {
                ent.nextthink = Int32(level.time + ent.wait)
            }
        }

        // fire targets
        if ent.activator == nil {
            ent.activator = ent
        }
        G_UseTargets2(ent, ent.activator!, ent.opentarget!)
    } else if ent.moverState == MOVER_2TO1 {
        //closed
        var doorcenter = vec3_t()

        // reached pos1
        SetMoverState(ent, MOVER_POS1, level.time)

        CalcTeamDoorCenter(ent, &doorcenter)

        // play sound
        G_PlayDoorSound(ent, BMS_END)

        // close areaportals
        if ent.teammaster == ent || ent.teammaster == nil {
            trap_AdjustAreaPortalState(ent, false)
        }
        G_UseTargets2(ent, ent.activator!, ent.closetarget!)
    } else {
        G_Error("Reached_BinaryMover: bad moverState")
    }
}

/**
```
================
Use_BinaryMover_Go
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:710
func Use_BinaryMover_Go(_ ent: Entity) {
    var total: Int32
    var partial: Int32
    //	gentity_t	*other = ent->enemy;
    let activator: Entity? = ent.activator

    ent.activator = activator

    if ent.moverState == MOVER_POS1 {
        var doorcenter = vec3_t()

        // start moving 50 msec later, becase if this was player
        // triggered, level.time hasn't been advanced yet
        MatchTeam(ent, MOVER_1TO2, level.time + 50)

        CalcTeamDoorCenter(ent, &doorcenter)

        // starting sound
        G_PlayDoorLoopSound(ent)
        G_PlayDoorSound(ent, BMS_START)
        ent.s.time = level.time

        // open areaportal
        if ent.teammaster == ent || ent.teammaster == nil {
            trap_AdjustAreaPortalState(ent, true)
        }
        G_UseTargets(ent, ent.activator)
        return
    }

    // if all the way up, just delay before coming down
    if ent.moverState == MOVER_POS2 {
        //have to do this because the delay sets our think to Use_BinaryMover_Go
        ent.think = Think.ReturnToPos1
        if (ent.spawnflags & 8) != 0 {
            //TOGGLE doors don't use wait!
            ent.nextthink = level.time + FRAMETIME
        } else {
            ent.nextthink = Int32(level.time + ent.wait)
        }
        G_UseTargets2(ent, ent.activator!, ent.target2!)
        return
    }

    // only partway down before reversing
    if ent.moverState == MOVER_2TO1 {
        if ent.s.pos.trType == TR_NONLINEAR_STOP {
            var curDelta = vec3_t()
            var fPartial: Float
            total = ent.s.pos.trDuration - 50
            curDelta = ent.r.currentOrigin - ent.pos1
            fPartial = VectorLength(curDelta) / VectorLength(ent.s.pos.trDelta)
            curDelta = ent.s.pos.trDelta * fPartial
            fPartial /= ent.s.pos.trDuration
            fPartial /= 0.001
            fPartial = acos(fPartial)
            fPartial = RAD2DEG(fPartial)
            fPartial = (90.0 - fPartial) / 90.0 * ent.s.pos.trDuration
            partial = Int32(total - floor(fPartial))
        } else {
            total = ent.s.pos.trDuration
            partial = level.time - ent.s.pos.trTime
        }

        if partial > total {
            partial = total
        }
        ent.s.pos.trTime = level.time - (total - partial) //ent->s.time;

        MatchTeam(ent, MOVER_1TO2, ent.s.pos.trTime)

        G_PlayDoorSound(ent, BMS_START)

        return
    }

    // only partway up before reversing
    if ent.moverState == MOVER_1TO2 {
        if ent.s.pos.trType == TR_NONLINEAR_STOP {
            var curDelta = vec3_t()
            var fPartial: Float
            total = ent.s.pos.trDuration - 50
            curDelta = ent.r.currentOrigin - ent.pos2
            fPartial = VectorLength(curDelta) / VectorLength(ent.s.pos.trDelta)
            curDelta = ent.s.pos.trDelta * fPartial
            fPartial /= ent.s.pos.trDuration
            fPartial /= 0.001
            fPartial = acos(fPartial)
            fPartial = RAD2DEG(fPartial)
            fPartial = (90.0 - fPartial) / 90.0 * ent.s.pos.trDuration
            partial = Int32(total - floor(fPartial))
        } else {
            total = ent.s.pos.trDuration
            partial = level.time - ent.s.pos.trTime
        }
        if partial > total {
            partial = total
        }

        ent.s.pos.trTime = level.time - (total - partial) //ent->s.time;
        MatchTeam(ent, MOVER_2TO1, ent.s.pos.trTime)

        G_PlayDoorSound(ent, BMS_START)

        return
    }
}

/// Source: oracle/codemp/game/g_mover.c:830
func UnLockDoors(_ ent: Entity) {
    //noise?
    //go through and unlock the door and all the slaves
    var slave: Entity? = ent
    repeat {
        // want to allow locked toggle doors, so keep the targetname
        if !((slave!.spawnflags & MOVER_TOGGLE) != 0) {
            slave!.targetname = nil //not usable ever again
        }
        slave!.spawnflags &= ~MOVER_LOCKED
        slave!.s.frame = 1 //second stage of anim
        slave = slave!.teamchain
    } while slave != nil
}

/// Source: oracle/codemp/game/g_mover.c:846
func LockDoors(_ ent: Entity) {
    //noise?
    //go through and lock the door and all the slaves
    var slave: Entity? = ent
    repeat {
        slave!.spawnflags |= MOVER_LOCKED
        slave!.s.frame = 0 //first stage of anim
        slave = slave!.teamchain
    } while slave != nil
}

/**
```
================
Use_BinaryMover
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:863
func Use_BinaryMover(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    if ent.use == nil {
        //I cannot be used anymore, must be a door with a wait of -1 that's opened.
        return
    }

    // only the master should be used
    if (ent.flags & FL_TEAMSLAVE) != 0 {
        Use_BinaryMover(ent.teammaster!, other, activator)
        return
    }

    if (ent.flags & FL_INACTIVE) != 0 {
        return
    }

    if (ent.spawnflags & MOVER_LOCKED) != 0 {
        //a locked door, unlock it
        UnLockDoors(ent)
        return
    }

    G_ActivateBehavior(ent, BSET_USE)

    ent.enemy = other
    ent.activator = activator
    if ent.delay != 0 {
        ent.think = Think.Use_BinaryMover_Go
        ent.nextthink = level.time + ent.delay
    } else {
        Use_BinaryMover_Go(ent)
    }
}

/**
```
================
InitMover

"pos1", "pos2", and "speed" should be set before calling,
so the movement delta can be calculated
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:913
func InitMoverTrData(_ ent: Entity) {
    var move = vec3_t()
    let distance: Float

    ent.s.pos.trType = TR_STATIONARY
    ent.s.pos.trBase = ent.pos1

    // calculate time to reach second position from speed
    move = ent.pos2 - ent.pos1
    distance = VectorLength(move)
    if ent.speed == 0 {
        ent.speed = 100
    }
    ent.s.pos.trDelta = move * ent.speed
    ent.s.pos.trDuration = Int32(distance * 1000 / ent.speed)
    if ent.s.pos.trDuration <= 0 {
        ent.s.pos.trDuration = 1
    }
}

/// Source: oracle/codemp/game/g_mover.c:936
func InitMover(_ ent: Entity) {
    var light: Float = 0
    var color = vec3_t()
    let lightSet: Bool
    let colorSet: Bool

    // if the "model2" key is set, use a seperate model
    // for drawing, but clip against the brushes
    if ent.model2 != nil {
        if strstr(ent.model2!, ".glm") != nil {
            //for now, not supported in MP.
            ent.s.modelindex2 = 0
        } else {
            ent.s.modelindex2 = G_ModelIndex(ent.model2!)
        }
    }

    // if the "color" or "light" keys are set, setup constantLight
    lightSet = G_SpawnFloat("light", "100", &light)
    colorSet = G_SpawnVector("color", "1 1 1", &color)
    if lightSet || colorSet {
        var r: Int32
        var g: Int32
        var b: Int32
        var i: Int32

        r = Int32(color[0] * 255)
        if r > 255 {
            r = 255
        }
        g = Int32(color[1] * 255)
        if g > 255 {
            g = 255
        }
        b = Int32(color[2] * 255)
        if b > 255 {
            b = 255
        }
        i = Int32(light / 4)
        if i > 255 {
            i = 255
        }
        ent.s.constantLight = r | (g << 8) | (b << 16) | (i << 24)
    }

    ent.use = Use.Use_BinaryMover
    ent.reached = Reached.Reached_BinaryMover

    ent.moverState = MOVER_POS1
    ent.r.svFlags = SVF_USE_CURRENT_ORIGIN
    if (ent.spawnflags & MOVER_INACTIVE) != 0 {
        // Make it inactive
        ent.flags |= FL_INACTIVE
    }
    if (ent.spawnflags & MOVER_PLAYER_USE) != 0 {
        //Can be used by the player's BUTTON_USE
        ent.r.svFlags |= SVF_PLAYER_USABLE
    }
    ent.s.eType = ET_MOVER
    ent.r.currentOrigin = ent.pos1
    trap_LinkEntity(ent)

    InitMoverTrData(ent)
}

/**
```
================
Blocked_Door
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:1018
func Blocked_Door(_ ent: Entity, _ other: Entity) {
    if ent.damage != 0 {
        var dir: vec3_t? = nil
        G_Damage(other, ent, ent, &dir, nil, ent.damage, 0, MOD_CRUSH)
    }
    if (ent.spawnflags & MOVER_CRUSHER) != 0 {
        return // crushers don't reverse
    }

    // reverse direction
    Use_BinaryMover(ent, ent, other)
}

/**
```
================
Touch_DoorTriggerSpectator
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:1037
private func Touch_DoorTriggerSpectator(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    var i: Int32 = 0
    var axis: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in
        var pMins = vec3_t()
        var pMaxs = vec3_t()
        var origin = vec3_t()
        var dir = vec3_t()
        var angles = vec3_t()

        axis = ent.count
        dir = vec3_t()
        if abs(other.s.origin[axis] - ent.r.absmax[axis]) < abs(other.s.origin[axis] - ent.r.absmin[axis]) {
            origin[axis] = ent.r.absmin[axis] - 10
            dir[axis] = -1
        } else {
            origin[axis] = ent.r.absmax[axis] + 10
            dir[axis] = 1
        }
        i = 0
        while i < 3 {
            if i == axis {
                i += 1
                continue
            }
            origin[i] = Float(Double(ent.r.absmin[i] + ent.r.absmax[i]) * 0.5)
            i += 1
        }

        vectoangles(dir, &angles)

        pMins = vec3_t(-15.0, -15.0, Float(DEFAULT_MINS_2))
        pMaxs = vec3_t(15.0, 15.0, Float(DEFAULT_MAXS_2))
        trap_Trace(tr, origin, pMins, pMaxs, origin, other.s.number, other.clipmask)
        if tr.startsolid == 0 && tr.allsolid == 0 && tr.fraction == 1.0 && tr.entityNum == ENTITYNUM_NONE {
            TeleportPlayer(other, origin, angles)
        }
    }
}

/**
```
================
Touch_DoorTrigger
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:1078
func Touch_DoorTrigger(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    var relockEnt: Entity? = nil

    if other.client != nil && other.client!.sess.sessionTeam == TEAM_SPECTATOR {
        // if the door is not open and not opening
        if ent.parent!.moverState != MOVER_1TO2 && ent.parent!.moverState != MOVER_POS2 {
            Touch_DoorTriggerSpectator(ent, other, trace)
        }
        return
    }

    if ent.genericValue14 == 0 && (ent.parent == nil || ent.parent!.genericValue14 == 0) {
        if other.client != nil && other.s.number >= MAX_CLIENTS && other.s.eType == ET_NPC && other.s.NPC_class == CLASS_VEHICLE {
            //doors don't open for vehicles
            return
        }

        if other.client != nil && other.s.number < MAX_CLIENTS && other.client!.ps.m_iVehicleNum != 0 {
            //can't open a door while on a vehicle
            return
        }
    }

    if (ent.flags & FL_INACTIVE) != 0 {
        return
    }

    if (ent.parent!.spawnflags & MOVER_LOCKED) != 0 {
        //don't even try to use the door if it's locked
        if ent.parent!.alliedTeam == 0 || other.client == nil || other.client!.sess.sessionTeam != ent.parent!.alliedTeam {
            return
        } else {
            //temporarily unlock us while we call Use_BinaryMover (so it doesn't unlock all the doors in this team)
            if (ent.parent!.flags & FL_TEAMSLAVE) != 0 {
                relockEnt = ent.parent!.teammaster
            } else {
                relockEnt = ent.parent
            }
            if relockEnt != nil {
                relockEnt!.spawnflags &= ~MOVER_LOCKED
            }
        }
    }

    if ent.parent!.moverState != MOVER_1TO2 {
        //Door is not already opening
        //if ( ent->parent->moverState == MOVER_POS1 || ent->parent->moverState == MOVER_2TO1 )
        //{//only check these if closed or closing

        //If door is closed, opening or open, check this
        Use_BinaryMover(ent.parent!, ent, other)
    }
    if relockEnt != nil {
        //re-lock us
        relockEnt!.spawnflags |= MOVER_LOCKED
    }

    /*
    //Old style
    if ( ent->parent->moverState != MOVER_1TO2 ) {
    Use_BinaryMover( ent->parent, ent, other );
    }
    */
}

/**
```
======================
Think_SpawnNewDoorTrigger

All of the parts of a door have been spawned, so create
a trigger that encloses all of them
======================
```
*/
/// Source: oracle/codemp/game/g_mover.c:1168
func Think_SpawnNewDoorTrigger(_ ent: Entity) {
    var other: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()
    var i: Int32
    var best: Int32

    // set all of the slaves as shootable
    if ent.takedamage {
        other = ent
        while other != nil {
            other!.takedamage = true
            other = other!.teamchain
        }
    }

    // find the bounds of everything on the team
    mins = ent.r.absmin
    maxs = ent.r.absmax

    other = ent.teamchain
    while other != nil {
        AddPointToBounds(other!.r.absmin, &mins, &maxs)
        AddPointToBounds(other!.r.absmax, &mins, &maxs)
        other = other!.teamchain
    }

    // find the thinnest axis, which will be the one we expand
    best = 0
    i = 1
    while i < 3 {
        if maxs[i] - mins[i] < maxs[best] - mins[best] {
            best = i
        }
        i += 1
    }
    maxs[best] += 120
    mins[best] -= 120

    // create a trigger with this size
    other = G_Spawn()
    other!.r.mins = mins
    other!.r.maxs = maxs
    other!.parent = ent
    other!.r.contents = CONTENTS_TRIGGER
    other!.touch = Touch.Touch_DoorTrigger
    trap_LinkEntity(other!)
    other!.classname = "trigger_door"
    // remember the thinnest axis
    other!.count = best

    MatchTeam(ent, ent.moverState, level.time)
}

/// Source: oracle/codemp/game/g_mover.c:1217
func Think_MatchTeam(_ ent: Entity) {
    MatchTeam(ent, ent.moverState, level.time)
}

/// Source: oracle/codemp/game/g_mover.c:1222
public func G_EntIsDoor(_ entityNum: Int32) -> Bool {
    var ent: Entity?

    if entityNum < 0 || entityNum >= ENTITYNUM_WORLD {
        return false
    }

    ent = g_entities[entityNum]
    if ent != nil && Q_stricmp("func_door", ent!.classname!) == 0 {
        //blocked by a door
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_mover.c:1239
func G_FindDoorTrigger(_ ent: Entity) -> Entity? {
    var owner: Entity? = nil
    var door: Entity? = ent
    if (door!.flags & FL_TEAMSLAVE) != 0 {
        //not the master door, get the master door
        while door!.teammaster != nil && (door!.flags & FL_TEAMSLAVE) != 0 {
            door = door!.teammaster
        }
    }
    if door!.targetname != nil {
        //find out what is targeting it
        //FIXME: if ent->targetname, check what kind of trigger/ent is targetting it?  If a normal trigger (active, etc), then it's okay?
        while let next = G_Find(owner, \.target, door!.targetname) {
            owner = next
            if owner != nil && (owner!.r.contents & CONTENTS_TRIGGER) != 0 {
                return owner
            }
        }
        owner = nil
        while let next = G_Find(owner, \.target2, door!.targetname) {
            owner = next
            if owner != nil && (owner!.r.contents & CONTENTS_TRIGGER) != 0 {
                return owner
            }
        }
    }

    owner = nil
    while let next = G_Find(owner, \.classname, "trigger_door") {
        owner = next
        if owner!.parent == door {
            return owner
        }
    }

    return nil
}

/// Source: oracle/codemp/game/g_mover.c:1282
public func G_EntIsUnlockedDoor(_ entityNum: Int32) -> Bool {
    if entityNum < 0 || entityNum >= ENTITYNUM_WORLD {
        return false
    }

    if G_EntIsDoor(entityNum) {
        var ent: Entity? = g_entities[entityNum]
        var owner: Entity? = nil
        if (ent!.flags & FL_TEAMSLAVE) != 0 {
            //not the master door, get the master door
            while ent!.teammaster != nil && (ent!.flags & FL_TEAMSLAVE) != 0 {
                ent = ent!.teammaster
            }
        }
        if ent!.targetname != nil {
            //find out what is targetting it
            owner = nil
            //FIXME: if ent->targetname, check what kind of trigger/ent is targetting it?  If a normal trigger (active, etc), then it's okay?
            while let next = G_Find(owner, \.target, ent!.targetname) {
                owner = next
                if Q_stricmp("trigger_multiple", owner!.classname!) == 0 {
                    //FIXME: other triggers okay too?
                    if !((owner!.flags & FL_INACTIVE) != 0) {
                        return true
                    }
                }
            }
            owner = nil
            while let next = G_Find(owner, \.target2, ent!.targetname) {
                owner = next
                if Q_stricmp("trigger_multiple", owner!.classname!) == 0 {
                    //FIXME: other triggers okay too?
                    if !((owner!.flags & FL_INACTIVE) != 0) {
                        return true
                    }
                }
            }
            return false
        } else {
            //check the door's auto-created trigger instead
            owner = G_FindDoorTrigger(ent!)
            if owner != nil && (owner!.flags & FL_INACTIVE) != 0 {
                //owning auto-created trigger is inactive
                return false
            }
        }
        if !((ent!.flags & FL_INACTIVE) != 0) && ent!.health == 0 && !((ent!.spawnflags & MOVER_PLAYER_USE) != 0) && !((ent!.spawnflags & MOVER_FORCE_ACTIVATE) != 0) && !((ent!.spawnflags & MOVER_LOCKED) != 0) {
            return true
        }
    }
    return false
}

/**
```
QUAKED func_door (0 .5 .8) ? START_OPEN FORCE_ACTIVATE CRUSHER TOGGLE LOCKED x PLAYER_USE INACTIVE
START_OPEN	the door to moves to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not useful for touch or takedamage doors).
FORCE_ACTIVATE	Can only be activated by a force push or pull
CRUSHER		?
TOGGLE		wait in both the start and end states for a trigger event - does NOT work on Trek doors.
LOCKED		Starts locked, with the shader animmap at the first frame and inactive.  Once used, the animmap changes to the second frame and the door operates normally.  Note that you cannot use the door again after this.
PLAYER_USE	Player can use it with the use button
INACTIVE	must be used by a target_activate before it can be used

"target"     Door fires this when it starts moving from it's closed position to its open position.
"opentarget" Door fires this after reaching its "open" position
"target2"    Door fires this when it starts moving from it's open position to its closed position.
"closetarget" Door fires this after reaching its "closed" position
"model2"	.md3 model to also draw
"angle"		determines the opening direction
"targetname" if set, no touch field will be spawned and a remote button or trigger field activates the door.
"speed"		movement speed (100 default)
"wait"		wait before returning (3 default, -1 = never return)
"delay"		when used, how many seconds to wait before moving - default is none
"lip"		lip remaining at end of move (8 default)
"dmg"		damage to inflict when blocked (2 default, set to negative for no damage)
"color"		constantLight color
"light"		constantLight radius
"health"	if set, the door must be shot open
"linear"	set to 1 and it will move linearly rather than with acceleration (default is 0)
"teamallow" even if locked, this team can always open and close it just by walking up to it
	0 - none (locked to everyone)
	1 - red
	2 - blue
"vehopen"	if non-0, vehicles/players riding vehicles can open
```
*/
/// Source: oracle/codemp/game/g_mover.c:1380
func SP_func_door(_ ent: Entity) {
    var abs_movedir = vec3_t()
    let distance: Float
    var size = vec3_t()
    var lip: Float = 0

    G_SpawnInt("vehopen", "0", &ent.genericValue14)

    ent.blocked = Blocked.Blocked_Door

    // default speed of 400
    if ent.speed == 0 {
        ent.speed = 400
    }

    // default wait of 2 seconds
    if ent.wait == 0 {
        ent.wait = 2
    }
    ent.wait *= 1000

    ent.delay *= 1000

    // default lip of 8 units
    G_SpawnFloat("lip", "8", &lip)

    // default damage of 2 points
    G_SpawnInt("dmg", "2", &ent.damage)
    if ent.damage < 0 {
        ent.damage = 0
    }

    G_SpawnInt("teamallow", "0", &ent.alliedTeam)

    // first position at start
    ent.pos1 = ent.s.origin

    // calculate second position
    trap_SetBrushModel(ent, ent.model!)
    G_SetMovedir(&ent.s.angles, &ent.movedir)
    abs_movedir[0] = abs(ent.movedir[0])
    abs_movedir[1] = abs(ent.movedir[1])
    abs_movedir[2] = abs(ent.movedir[2])
    size = ent.r.maxs - ent.r.mins
    distance = _DotProduct(abs_movedir, size) - lip
    _VectorMA(ent.pos1, distance, ent.movedir, &ent.pos2)

    // if "start_open", reverse position 1 and 2
    if (ent.spawnflags & 1) != 0 {
        var temp = vec3_t()

        temp = ent.pos2
        ent.pos2 = ent.s.origin
        ent.pos1 = temp
    }

    if (ent.spawnflags & MOVER_LOCKED) != 0 {
        //a locked door, set up as locked until used directly
        ent.s.eFlags |= EF_SHADER_ANIM //use frame-controlled shader anim
        ent.s.frame = 0 //first stage of anim
    }
    InitMover(ent)

    ent.nextthink = level.time + FRAMETIME

    if !((ent.flags & FL_TEAMSLAVE) != 0) {
        var health: Int32 = 0

        G_SpawnInt("health", "0", &health)

        if health != 0 {
            ent.takedamage = true
        }

        if !((ent.spawnflags & MOVER_LOCKED) != 0) && (ent.targetname != nil || health != 0 || (ent.spawnflags & MOVER_PLAYER_USE) != 0 || (ent.spawnflags & MOVER_FORCE_ACTIVATE) != 0) {
            // non touch/shoot doors
            ent.think = Think.Think_MatchTeam

            if (ent.spawnflags & MOVER_FORCE_ACTIVATE) != 0 {
                //so we know it's push/pullable on the client
                ent.s.bolt1 = 1
            }
        } else {
            //locked doors still spawn a trigger
            ent.think = Think.Think_SpawnNewDoorTrigger
        }
    }
}

/**
```
==============
Touch_Plat

Don't allow decent if a living player is on it
===============
```
*/
/// Source: oracle/codemp/game/g_mover.c:1489
func Touch_Plat(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if other.client == nil || other.client!.ps.stats[STAT_HEALTH] <= 0 {
        return
    }

    // delay return-to-pos1 by one second
    if ent.moverState == MOVER_POS2 {
        ent.nextthink = level.time + 1000
    }
}

/**
```
==============
Touch_PlatCenterTrigger

If the plat is at the bottom position, start it going up
===============
```
*/
/// Source: oracle/codemp/game/g_mover.c:1507
func Touch_PlatCenterTrigger(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if other.client == nil {
        return
    }

    if ent.parent!.moverState == MOVER_POS1 {
        Use_BinaryMover(ent.parent!, ent, other)
    }
}

/**
```
================
SpawnPlatTrigger

Spawn a trigger in the middle of the plat's low position
Elevator cars require that the trigger extend through the entire low position,
not just sit on top of it.
================
```
*/
/// Source: oracle/codemp/game/g_mover.c:1527
func SpawnPlatTrigger(_ ent: Entity) {
    var trigger: Entity?
    var tmin = vec3_t()
    var tmax = vec3_t()

    // the middle trigger will be a thin trigger just
    // above the starting position
    trigger = G_Spawn()
    trigger!.touch = Touch.Touch_PlatCenterTrigger
    trigger!.r.contents = CONTENTS_TRIGGER
    trigger!.parent = ent

    tmin[0] = ent.pos1[0] + ent.r.mins[0] + 33
    tmin[1] = ent.pos1[1] + ent.r.mins[1] + 33
    tmin[2] = ent.pos1[2] + ent.r.mins[2]

    tmax[0] = ent.pos1[0] + ent.r.maxs[0] - 33
    tmax[1] = ent.pos1[1] + ent.r.maxs[1] - 33
    tmax[2] = ent.pos1[2] + ent.r.maxs[2] + 8

    if tmax[0] <= tmin[0] {
        tmin[0] = Float(Double(ent.pos1[0]) + Double(ent.r.mins[0] + ent.r.maxs[0]) * 0.5)
        tmax[0] = tmin[0] + 1
    }
    if tmax[1] <= tmin[1] {
        tmin[1] = Float(Double(ent.pos1[1]) + Double(ent.r.mins[1] + ent.r.maxs[1]) * 0.5)
        tmax[1] = tmin[1] + 1
    }

    trigger!.r.mins = tmin
    trigger!.r.maxs = tmax

    trap_LinkEntity(trigger!)
}

/**
```
QUAKED func_plat (0 .5 .8) ? x x x x x x PLAYER_USE INACTIVE
PLAYER_USE	Player can use it with the use button
INACTIVE	must be used by a target_activate before it can be used

Plats are always drawn in the extended position so they will light correctly.

"lip"		default 8, protrusion above rest position
"height"	total height of movement, defaults to model height
"speed"		overrides default 200.
"dmg"		overrides default 2
"model2"	.md3 model to also draw
"color"		constantLight color
"light"		constantLight radius
```
*/
/// Source: oracle/codemp/game/g_mover.c:1576
func SP_func_plat(_ ent: Entity) {
    var lip: Float = 0
    var height: Float = 0

    //	ent->sound1to2 = ent->sound2to1 = G_SoundIndex("sound/movers/plats/pt1_strt.wav");
    //	ent->soundPos1 = ent->soundPos2 = G_SoundIndex("sound/movers/plats/pt1_end.wav");

    ent.s.angles = vec3_t()

    G_SpawnFloat("speed", "200", &ent.speed)
    G_SpawnInt("dmg", "2", &ent.damage)
    G_SpawnFloat("wait", "1", &ent.wait)
    G_SpawnFloat("lip", "8", &lip)

    ent.wait = 1000

    // create second position
    trap_SetBrushModel(ent, ent.model!)

    if !G_SpawnFloat("height", "0", &height) {
        height = (ent.r.maxs[2] - ent.r.mins[2]) - lip
    }

    // pos1 is the rest (bottom) position, pos2 is the top
    ent.pos2 = ent.s.origin
    ent.pos1 = ent.pos2
    ent.pos1[2] -= height

    InitMover(ent)

    // touch function keeps the plat from returning while
    // a live player is standing on it
    ent.touch = Touch.Touch_Plat

    ent.blocked = Blocked.Blocked_Door

    ent.parent = ent // so it can be treated as a door

    // spawn the trigger if one hasn't been custom made
    if ent.targetname == nil {
        SpawnPlatTrigger(ent)
    }
}

/**
```
==============
Touch_Button

===============
```
*/
/// Source: oracle/codemp/game/g_mover.c:1633
func Touch_Button(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace?) {
    if other.client == nil {
        return
    }

    if ent.moverState == MOVER_POS1 {
        Use_BinaryMover(ent, other, other)
    }
}

/**
```
QUAKED func_button (0 .5 .8) ? x x x x x x PLAYER_USE INACTIVE
PLAYER_USE	Player can use it with the use button
INACTIVE	must be used by a target_activate before it can be used

When a button is touched, it moves some distance in the direction of it's angle, triggers all of it's targets, waits some time, then returns to it's original position where it can be triggered again.

"model2"	.md3 model to also draw
"angle"		determines the opening direction
"target"	all entities with a matching targetname will be used
"speed"		override the default 40 speed
"wait"		override the default 1 second wait (-1 = never return)
"lip"		override the default 4 pixel lip remaining at end of move
"health"	if set, the button must be killed instead of touched
"color"		constantLight color
"light"		constantLight radius
```
*/
/// Source: oracle/codemp/game/g_mover.c:1660
func SP_func_button(_ ent: Entity) {
    var abs_movedir = vec3_t()
    let distance: Float
    var size = vec3_t()
    var lip: Float = 0

    //	ent->sound1to2 = G_SoundIndex("sound/movers/switches/butn2.wav");

    if ent.speed == 0 {
        ent.speed = 40
    }

    if ent.wait == 0 {
        ent.wait = 1
    }
    ent.wait *= 1000

    // first position
    ent.pos1 = ent.s.origin

    // calculate second position
    trap_SetBrushModel(ent, ent.model!)

    G_SpawnFloat("lip", "4", &lip)

    G_SetMovedir(&ent.s.angles, &ent.movedir)
    abs_movedir[0] = abs(ent.movedir[0])
    abs_movedir[1] = abs(ent.movedir[1])
    abs_movedir[2] = abs(ent.movedir[2])
    size = ent.r.maxs - ent.r.mins
    distance = abs_movedir[0] * size[0] + abs_movedir[1] * size[1] + abs_movedir[2] * size[2] - lip
    _VectorMA(ent.pos1, distance, ent.movedir, &ent.pos2)

    if ent.health != 0 {
        // shootable button
        ent.takedamage = true
    } else {
        // touchable button
        ent.touch = Touch.Touch_Button
    }

    InitMover(ent)
}

/**
```
===============
Think_BeginMoving

The wait time at a corner has completed, so start moving again
===============
```
*/
/// Source: oracle/codemp/game/g_mover.c:1727
func Think_BeginMoving(_ ent: Entity) {
    G_PlayDoorSound(ent, BMS_START)
    G_PlayDoorLoopSound(ent)
    ent.s.pos.trTime = level.time
    ent.s.pos.trType = TR_LINEAR_STOP
}

/**
```
===============
Reached_Train
===============
```
*/
/// Source: oracle/codemp/game/g_mover.c:1739
func Reached_Train(_ ent: Entity) {
    var next: Entity?
    var speed: Float
    var move = vec3_t()
    let length: Float

    // copy the apropriate values
    next = ent.nextTrain
    if next == nil || next!.nextTrain == nil {
        return // just stop
    }

    // fire all other targets
    G_UseTargets(next!, nil)

    // set the new trajectory
    ent.nextTrain = next!.nextTrain
    ent.pos1 = next!.s.origin
    ent.pos2 = next!.nextTrain!.s.origin

    // if the path_corner has a speed, use that
    if next!.speed != 0 {
        speed = next!.speed
    } else {
        // otherwise use the train's speed
        speed = ent.speed
    }
    if speed < 1 {
        speed = 1
    }

    // calculate duration
    move = ent.pos2 - ent.pos1
    length = VectorLength(move)

    ent.s.pos.trDuration = Int32(length * 1000 / speed)

    // start it going
    SetMoverState(ent, MOVER_1TO2, level.time)

    G_PlayDoorSound(ent, BMS_END)

    // if there is a "wait" value on the target, don't start moving yet
    if next!.wait != 0 {
        ent.s.loopSound = 0
        ent.s.loopIsSoundset = false
        ent.nextthink = Int32(level.time + next!.wait * 1000)
        ent.think = Think.Think_BeginMoving
        ent.s.pos.trType = TR_STATIONARY
    } else {
        G_PlayDoorLoopSound(ent)
    }
}

/**
```
===============
Think_SetupTrainTargets

Link all the corners together
===============
```
*/
/// Source: oracle/codemp/game/g_mover.c:1802
func Think_SetupTrainTargets(_ ent: Entity) {
    var path: Entity?
    var next: Entity?
    var start: Entity?

    ent.nextTrain = G_Find(nil, \.targetname, ent.target)
    if ent.nextTrain == nil {
        Com_Printf("func_train at %s with an unfound target\n", vtos(ent.r.absmin))
        //Free me?`
        return
    }

    //FIXME: this can go into an infinite loop if last path_corner doesn't link to first
    //path_corner, like so:
    // t1---->t2---->t3
    //         ^      |
    //          \_____|
    start = nil
    path = ent.nextTrain
    while path != start {
        if start == nil {
            start = path
        }

        if path!.target == nil {
            //			gi.Printf( "Train corner at %s without a target\n",
            //				vtos(path->s.origin) );
            //end of path
            break
        }

        // find a path_corner among the targets
        // there may also be other targets that get fired when the corner
        // is reached
        next = nil
        repeat {
            next = G_Find(next, \.targetname, path!.target)
            if next == nil {
                //				gi.Printf( "Train corner at %s without a target path_corner\n",
                //					vtos(path->s.origin) );
                //end of path
                break
            }
        } while strcmp(next!.classname!, "path_corner") != 0

        if next != nil {
            path!.nextTrain = next
        } else {
            break
        }
        path = next
    }

    if ent.targetname == nil || (ent.spawnflags & 1) != 0 {
        // start the train moving from the first corner
        Reached_Train(ent)
    } else {
        G_SetOrigin(ent, &ent.s.origin)
    }
}

/**
```
QUAKED path_corner (.5 .3 0) (-8 -8 -8) (8 8 8)
Train path corners.
Target: next path corner and other targets to fire
"speed" speed to move to the next corner
"wait" seconds to wait before behining move to next corner
```
*/
/// Source: oracle/codemp/game/g_mover.c:1873
func SP_path_corner(_ `self`: Entity) {
    if `self`.targetname == nil {
        G_Printf("path_corner with no targetname at %s\n", vtos(`self`.s.origin))
        G_FreeEntity(`self`)
        return
    }
    // path corners don't need to be linked in
}

/**
```
QUAKED func_train (0 .5 .8) ? START_ON TOGGLE BLOCK_STOPS ? ? CRUSH_THROUGH PLAYER_USE INACTIVE
A train is a mover that moves between path_corner target points.
Trains MUST HAVE AN ORIGIN BRUSH.
The train spawns at the first target it is pointing at.
CRUSH_THROUGH spawnflag combined with a dmg value will make the train pass through
entities and damage them on contact as well.
"model2"	.md3 model to also draw
"speed"		default 100
"dmg"		default	2
"target"	next path corner
"color"		constantLight color
"light"		constantLight radius
```
*/
/// Source: oracle/codemp/game/g_mover.c:1897
func SP_func_train(_ `self`: Entity) {
    `self`.s.angles = vec3_t()

    if (`self`.spawnflags & TRAIN_BLOCK_STOPS) != 0 {
        `self`.damage = 0
    } else {
        if `self`.damage == 0 {
            `self`.damage = 2
        }
    }

    if `self`.speed == 0 {
        `self`.speed = 100
    }

    if `self`.target == nil {
        G_Printf("func_train without a target at %s\n", vtos(`self`.r.absmin))
        G_FreeEntity(`self`)
        return
    }

    trap_SetBrushModel(`self`, `self`.model!)
    InitMover(`self`)

    `self`.reached = Reached.Reached_Train

    // start trains on the second frame, to make sure their targets have had
    // a chance to spawn
    `self`.nextthink = level.time + FRAMETIME
    `self`.think = Think.Think_SetupTrainTargets
}

/**
```
QUAKED func_static (0 .5 .8) ? F_PUSH F_PULL SWITCH_SHADER CRUSHER IMPACT x PLAYER_USE INACTIVE BROADCAST
F_PUSH		Will be used when you Force-Push it
F_PULL		Will be used when you Force-Pull it
SWITCH_SHADER	Toggle the shader anim frame between 1 and 2 when used
CRUSHER		Make it do damage when it's blocked
IMPACT		Make it do damage when it hits any entity
PLAYER_USE	Player can use it with the use button
INACTIVE	must be used by a target_activate before it can be used
BROADCAST   don't ever use this, it's evil

A bmodel that just sits there, doing nothing.  Can be used for conditional walls and models.
"model2"	.md3 model to also draw
"model2scale"	percent of normal scale (on all x y and z axii) to scale the model2 if there is one. 100 is normal scale, min is 1 (100 times smaller than normal), max is 1000 (ten times normal).
"color"		constantLight color
"light"		constantLight radius
"dmg"		how much damage to do when it crushes (use with CRUSHER spawnflag)
"linear" set to 1 and it will move linearly rather than with acceleration (default is 0)
```
*/
/// Source: oracle/codemp/game/g_mover.c:1956
func SP_func_static(_ ent: Entity) {
    var test: Int32 = 0
    trap_SetBrushModel(ent, ent.model!)

    ent.pos1 = ent.s.origin
    ent.pos2 = ent.s.origin

    InitMover(ent)

    ent.use = Use.func_static_use
    ent.reached = nil

    G_SetOrigin(ent, &ent.s.origin)
    G_SetAngles(ent, ent.s.angles)

    if (ent.spawnflags & 2048) != 0 {
        // yes this is very very evil, but for now (pre-alpha) it's a solution
        ent.r.svFlags |= SVF_BROADCAST // I need to rotate something that is huge and it's touching too many area portals...
    }

    if (ent.spawnflags & 4) != 0 {
        ent.s.eFlags |= EF_SHADER_ANIM //use frame-controlled shader anim
        ent.s.frame = 0 //first stage of anim
    }

    if (ent.spawnflags & 1) != 0 || (ent.spawnflags & 2) != 0 {
        //so we know it's push/pullable on the client
        ent.s.bolt1 = 1
    }

    G_SpawnInt("model2scale", "0", &ent.s.iModelScale)
    if ent.s.iModelScale < 0 {
        //NOTE: -1 scale is x -100% (so -3 is 300%)
        ent.s.legsFlip = true //treat it as a scalar
        ent.s.iModelScale = -ent.s.iModelScale
    } else if ent.s.iModelScale > 1023 {
        ent.s.iModelScale = 1023
    }

    G_SpawnInt("hyperspace", "0", &test)
    if test != 0 {
        ent.r.svFlags |= SVF_BROADCAST // I need to rotate something that is huge and it's touching too many area portals...
        ent.s.eFlags2 |= EF2_HYPERSPACE
    }

    trap_LinkEntity(ent)

    if level.mBSPInstanceDepth != 0 {
        // this means that this guy will never be updated, moved, changed, etc.
        ent.s.eFlags = EF_PERMANENT
    }
}

/// Source: oracle/codemp/game/g_mover.c:2021
func func_static_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(`self`, BSET_USE)

    if (`self`.spawnflags & 4) != 0 {
        `self`.s.frame = `self`.s.frame != 0 ? 0 : 1 //toggle frame
    }
    G_UseTargets(`self`, activator)
}

/// Source: oracle/codemp/game/g_mover.c:2040
func func_rotating_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if `self`.s.apos.trType == TR_LINEAR {
        `self`.s.apos.trType = TR_STATIONARY
        // stop the sound if it stops moving
        `self`.s.loopSound = 0
        `self`.s.loopIsSoundset = false
        // play stop sound too?
        if `self`.soundSet != nil && !`self`.soundSet!.isEmpty {
            `self`.s.soundSetIndex = G_SoundSetIndex(`self`.soundSet!)
            G_AddEvent(`self`, EV_BMODEL_SOUND, BMS_END)
        }
    } else {
        if `self`.soundSet != nil && !`self`.soundSet!.isEmpty {
            `self`.s.soundSetIndex = G_SoundSetIndex(`self`.soundSet!)
            G_AddEvent(`self`, EV_BMODEL_SOUND, BMS_START)
            `self`.s.loopSound = BMS_MID
            `self`.s.loopIsSoundset = true
        }
        `self`.s.apos.trType = TR_LINEAR
    }
}

/// Source: oracle/codemp/game/g_mover.c:2133
func SP_func_rotating(_ ent: Entity) {
    var spinangles = vec3_t()
    if ent.health != 0 {
        let sav_spawnflags: Int32 = ent.spawnflags
        ent.spawnflags = 0
        SP_func_breakable(ent)
        ent.spawnflags = sav_spawnflags
    } else {
        trap_SetBrushModel(ent, ent.model!)
        InitMover(ent)

        ent.s.pos.trBase = ent.s.origin
        ent.r.currentOrigin = ent.s.pos.trBase
        ent.r.currentAngles = ent.s.apos.trBase

        trap_LinkEntity(ent)
    }

    G_SpawnInt("model2scale", "0", &ent.s.iModelScale)
    if ent.s.iModelScale < 0 {
        //NOTE: -1 scale is x -100% (so -3 is 300%)
        ent.s.legsFlip = true //treat it as a scalar
        ent.s.iModelScale = -ent.s.iModelScale
    } else if ent.s.iModelScale > 1023 {
        ent.s.iModelScale = 1023
    }

    if G_SpawnVector("spinangles", "0 0 0", &spinangles) {
        ent.speed = VectorLength(spinangles)
        // set the axis of rotation
        ent.s.apos.trDelta = spinangles
    } else {
        if ent.speed == 0 {
            ent.speed = 100
        }
        // set the axis of rotation
        if (ent.spawnflags & 4) != 0 {
            ent.s.apos.trDelta[2] = ent.speed
        } else if (ent.spawnflags & 8) != 0 {
            ent.s.apos.trDelta[0] = ent.speed
        } else {
            ent.s.apos.trDelta[1] = ent.speed
        }
    }
    ent.s.apos.trType = TR_LINEAR

    if ent.damage == 0 {
        if (ent.spawnflags & 16) != 0 {
            ent.damage = 10000
        } else {
            ent.damage = 2
        }
    }
    if (ent.spawnflags & 2) != 0 {
        //show up on Radar at close range and play impact sound when close...?  Range based on my size
        ent.s.speed = Distance(ent.r.absmin, ent.r.absmax) * 0.5
        ent.s.eFlags |= EF_RADAROBJECT
    }
}

/**
```
QUAKED func_bobbing (0 .5 .8) ? X_AXIS Y_AXIS x x x x PLAYER_USE INACTIVE
Normally bobs on the Z axis
"model2"	.md3 model to also draw
"height"	amplitude of bob (32 default)
"speed"		seconds to complete a bob cycle (4 default)
"phase"		the 0.0 to 1.0 offset in the cycle to start at
"dmg"		damage to inflict when blocked (2 default)
"color"		constantLight color
"light"		constantLight radius
```
*/
/// Source: oracle/codemp/game/g_mover.c:2231
func SP_func_bobbing(_ ent: Entity) {
    var height: Float = 0
    var phase: Float = 0

    G_SpawnFloat("speed", "4", &ent.speed)
    G_SpawnFloat("height", "32", &height)
    G_SpawnInt("dmg", "2", &ent.damage)
    G_SpawnFloat("phase", "0", &phase)

    trap_SetBrushModel(ent, ent.model!)
    InitMover(ent)

    ent.s.pos.trBase = ent.s.origin
    ent.r.currentOrigin = ent.s.origin

    ent.s.pos.trDuration = Int32(ent.speed * 1000)
    ent.s.pos.trTime = Int32(ent.s.pos.trDuration * phase)
    ent.s.pos.trType = TR_SINE

    // set the axis of bobbing
    if (ent.spawnflags & 1) != 0 {
        ent.s.pos.trDelta[0] = height
    } else if (ent.spawnflags & 2) != 0 {
        ent.s.pos.trDelta[1] = height
    } else {
        ent.s.pos.trDelta[2] = height
    }
}

/**
```
QUAKED func_pendulum (0 .5 .8) ? x x x x x x PLAYER_USE INACTIVE
You need to have an origin brush as part of this entity.
Pendulums always swing north / south on unrotated models.  Add an angles field to the model to allow rotation in other directions.
Pendulum frequency is a physical constant based on the length of the beam and gravity.
"model2"	.md3 model to also draw
"speed"		the number of degrees each way the pendulum swings, (30 default)
"phase"		the 0.0 to 1.0 offset in the cycle to start at
"dmg"		damage to inflict when blocked (2 default)
"color"		constantLight color
"light"		constantLight radius
```
*/
/// Source: oracle/codemp/game/g_mover.c:2280
func SP_func_pendulum(_ ent: Entity) {
    let freq: Float
    var length: Float
    var phase: Float = 0
    var speed: Float = 0

    G_SpawnFloat("speed", "30", &speed)
    G_SpawnInt("dmg", "2", &ent.damage)
    G_SpawnFloat("phase", "0", &phase)

    trap_SetBrushModel(ent, ent.model!)

    // find pendulum length
    length = abs(ent.r.mins[2])
    if length < 8 {
        length = 8
    }

    freq = Float(1 / (M_PI * 2) * sqrt(Double(g_gravity.value / (3 * length))))

    ent.s.pos.trDuration = Int32((1000 / freq))

    InitMover(ent)

    ent.s.pos.trBase = ent.s.origin
    ent.r.currentOrigin = ent.s.origin

    ent.s.apos.trBase = ent.s.angles

    ent.s.apos.trDuration = Int32(1000 / freq)
    ent.s.apos.trTime = Int32(ent.s.apos.trDuration * phase)
    ent.s.apos.trType = TR_SINE
    ent.s.apos.trDelta[2] = speed
}

/**
```
===============================================================================

BREAKABLE BRUSH

===============================================================================
```
*/
//---------------------------------------------------
/// Source: oracle/codemp/game/g_mover.c:2323
private func CacheChunkEffects(_ material: JKAMP.material_t) {
    switch material {
    case MAT_GLASS:
        G_EffectIndex("chunks/glassbreak")

    case MAT_GLASS_METAL:
        G_EffectIndex("chunks/glassbreak")
        G_EffectIndex("chunks/metalexplode")

    case MAT_ELECTRICAL, MAT_ELEC_METAL:
        G_EffectIndex("chunks/sparkexplode")

    case MAT_METAL, MAT_METAL2, MAT_METAL3, MAT_CRATE1, MAT_CRATE2:
        G_EffectIndex("chunks/metalexplode")

    case MAT_GRATE1:
        G_EffectIndex("chunks/grateexplode")

    case MAT_DRK_STONE,
         MAT_LT_STONE,
         MAT_GREY_STONE,
         MAT_WHITE_METAL, // what is this crap really supposed to be??
         MAT_SNOWY_ROCK:
        G_EffectIndex("chunks/rockbreaklg")
        G_EffectIndex("chunks/rockbreakmed")

    case MAT_ROPE:
        G_EffectIndex("chunks/ropebreak")

    default:
        break
    }
}

/// Source: oracle/codemp/game/g_mover.c:2363
func G_MiscModelExplosion(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ size: Int32, _ chunkType: JKAMP.material_t) {
    var te: Entity?
    var mid = vec3_t()

    mid = mins + maxs
    mid = mid * 0.5

    te = G_TempEntity(mid, EV_MISC_MODEL_EXP)

    te!.s.origin2 = maxs
    te!.s.angles2 = mins
    te!.s.time = size
    te!.s.eventParm = chunkType
}

/// Source: oracle/codemp/game/g_mover.c:2379
func G_Chunks(_ owner: Int32, _ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ speed: Float, _ numChunks: Int32, _ chunkType: JKAMP.material_t, _ customChunk: Int32, _ baseScale: Float) {
    let te: Entity? = G_TempEntity(origin, EV_DEBRIS)

    //Now it's time to cram everything horribly into the entitystate of an event entity.
    te!.s.owner = owner
    te!.s.origin = origin
    te!.s.angles = normal
    te!.s.origin2 = maxs
    te!.s.angles2 = mins
    te!.s.speed = speed
    te!.s.eventParm = numChunks
    te!.s.trickedentindex = chunkType
    te!.s.modelindex = customChunk
    te!.s.apos.trBase[0] = baseScale
}

//--------------------------------------
/// Source: oracle/codemp/game/g_mover.c:2398
func funcBBrushDieGo(_ `self`: Entity) {
    var org = vec3_t()
    var dir = vec3_t()
    var up = vec3_t()
    let attacker: Entity? = `self`.enemy
    var scale: Float
    var i: Int32
    var numChunks: Int32
    var size: Int32 = 0
    let chunkType: material_t = `self`.material

    // if a missile is stuck to us, blow it up so we don't look dumb
    i = 0
    while i < MAX_GENTITIES {
        if g_entities[i].s.groundEntityNum == `self`.s.number && (g_entities[i].s.eFlags & EF_MISSILE_STICK) != 0 {
            var dir: vec3_t? = nil
            G_Damage(g_entities[i], `self`, `self`, &dir, nil, 99999, 0, MOD_CRUSH) //?? MOD?
        }
        i += 1
    }

    //So chunks don't get stuck inside me
    `self`.s.solid = 0
    `self`.r.contents = 0
    `self`.clipmask = 0
    trap_LinkEntity(`self`)

    up = vec3_t(0, 0, 1)

    if `self`.target != nil && attacker != nil {
        G_UseTargets(`self`, attacker)
    }

    org = `self`.r.absmax - `self`.r.absmin // size

    // The SDK also declares `random`, so the call names the bg module.
    numChunks = Int32(JKAMP_BG.random() * 6 + 18)

    // This formula really has no logical basis other than the fact that it seemed to be the closest to yielding the results that I wanted.
    // Volume is length * width * height...then break that volume down based on how many chunks we have
    scale = sqrt(sqrt(org[0] * org[1] * org[2])) * 1.75

    if scale > 48 {
        size = 2
    } else if scale > 24 {
        size = 1
    }

    scale = scale / numChunks

    if `self`.radius > 0.0 {
        // designer wants to scale number of chunks, helpful because the above scale code is far from perfect
        //	I do this after the scale calculation because it seems that the chunk size generally seems to be very close, it's just the number of chunks is a bit weak
        numChunks = Int32(numChunks * `self`.radius)
    }

    _VectorMA(`self`.r.absmin, 0.5, org, &org)
    org = `self`.r.absmin + `self`.r.absmax
    org = org * 0.5

    if attacker != nil && attacker!.client != nil {
        dir = org - attacker!.r.currentOrigin
        VectorNormalize(&dir)
    } else {
        dir = up
    }

    if !((`self`.spawnflags & 2048) != 0) {
        // we are allowed to explode
        G_MiscModelExplosion(`self`.r.absmin, `self`.r.absmax, size, chunkType)
    }

    if `self`.genericValue15 != 0 {
        //a custom effect to play
        var ang = vec3_t()
        ang = vec3_t(0.0, 1.0, 0.0)
        G_PlayEffectID(`self`.genericValue15, org, ang)
    }

    if `self`.splashDamage > 0 && `self`.splashRadius > 0 {
        var te: Entity?
        //explode
        G_RadiusDamage(org, `self`, Float(`self`.splashDamage), Float(`self`.splashRadius), `self`, nil, MOD_UNKNOWN)

        te = G_TempEntity(org, EV_GENERAL_SOUND)
        te!.s.eventParm = G_SoundIndex("sound/weapons/explosions/cargoexplode.wav")
    }

    //FIXME: base numChunks off size?
    G_Chunks(`self`.s.number, org, dir, `self`.r.absmin, `self`.r.absmax, 300, numChunks, chunkType, 0, (scale * `self`.mass))

    trap_AdjustAreaPortalState(`self`, true)
    `self`.think = Think.G_FreeEntity
    `self`.nextthink = level.time + 50
    //G_FreeEntity( self );
}

/// Source: oracle/codemp/game/g_mover.c:2500
func funcBBrushDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    `self`.takedamage = false //stop chain reaction runaway loops

    `self`.enemy = attacker

    if `self`.delay != 0 {
        `self`.think = Think.funcBBrushDieGo
        `self`.nextthink = Int32(level.time + floor(`self`.delay * 1000.0))
        return
    }

    funcBBrushDieGo(`self`)
}

/// Source: oracle/codemp/game/g_mover.c:2516
func funcBBrushUse(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(`self`, BSET_USE)
    if (`self`.spawnflags & 64) != 0 {
        //Using it doesn't break it, makes it use it's targets
        if `self`.target != nil && !`self`.target!.isEmpty {
            G_UseTargets(`self`, activator)
        }
    } else {
        funcBBrushDie(`self`, other, activator, `self`.health, MOD_UNKNOWN)
    }
}

/// Source: oracle/codemp/game/g_mover.c:2532
func funcBBrushPain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    if `self`.painDebounceTime > level.time {
        return
    }

    if `self`.paintarget != nil && !`self`.paintarget!.isEmpty {
        if `self`.activator == nil {
            if attacker.inuse && attacker.client != nil {
                G_UseTargets2(`self`, attacker, `self`.paintarget!)
            }
        } else {
            G_UseTargets2(`self`, `self`.activator!, `self`.paintarget!)
        }
    }

    G_ActivateBehavior(`self`, BSET_PAIN)

    if `self`.material == MAT_DRK_STONE || `self`.material == MAT_LT_STONE || `self`.material == MAT_GREY_STONE || `self`.material == MAT_SNOWY_ROCK {
        var org = vec3_t()
        var dir = vec3_t()
        let scale: Float
        var numChunks: Int32
        org = `self`.r.absmax - `self`.r.absmin // size
        // This formula really has no logical basis other than the fact that it seemed to be the closest to yielding the results that I wanted.
        // Volume is length * width * height...then break that volume down based on how many chunks we have
        scale = VectorLength(org) / 100.0
        _VectorMA(`self`.r.absmin, 0.5, org, &org)
        org = `self`.r.absmin + `self`.r.absmax
        org = org * 0.5
        if attacker != nil && attacker.client != nil {
            dir = attacker.r.currentOrigin - org
            VectorNormalize(&dir)
        } else {
            dir = vec3_t(0, 0, 1)
        }
        numChunks = Q_irand(1, 3)
        if `self`.radius > 0.0 {
            // designer wants to scale number of chunks, helpful because the above scale code is far from perfect
            //	I do this after the scale calculation because it seems that the chunk size generally seems to be very close, it's just the number of chunks is a bit weak
            numChunks = Int32(ceil(numChunks * `self`.radius))
        }
        G_Chunks(`self`.s.number, org, dir, `self`.r.absmin, `self`.r.absmax, 300, numChunks, `self`.material, 0, (scale * `self`.mass))
    }

    if `self`.wait == -1 {
        `self`.pain = nil
        return
    }

    `self`.painDebounceTime = Int32(level.time + `self`.wait)
}

/// Source: oracle/codemp/game/g_mover.c:2599
private func InitBBrush(_ ent: Entity) {
    var light: Float = 0
    var color = vec3_t()
    let lightSet: Bool
    let colorSet: Bool

    ent.pos1 = ent.s.origin

    trap_SetBrushModel(ent, ent.model!)

    ent.die = Die.funcBBrushDie

    ent.flags |= FL_BBRUSH

    //This doesn't have to be an svFlag, can just be a flag.
    //And it might not be needed anyway.
    //ent->r.svFlags |= SVF_BBRUSH;


    // if the "model2" key is set, use a seperate model
    // for drawing, but clip against the brushes
    if ent.model2 != nil && !ent.model2!.isEmpty {
        ent.s.modelindex2 = G_ModelIndex(ent.model2!)
    }

    // if the "color" or "light" keys are set, setup constantLight
    lightSet = G_SpawnFloat("light", "100", &light)
    colorSet = G_SpawnVector("color", "1 1 1", &color)
    if lightSet || colorSet {
        var r: Int32
        var g: Int32
        var b: Int32
        var i: Int32

        r = Int32(color[0] * 255)
        if r > 255 {
            r = 255
        }
        g = Int32(color[1] * 255)
        if g > 255 {
            g = 255
        }
        b = Int32(color[2] * 255)
        if b > 255 {
            b = 255
        }
        i = Int32(light / 4)
        if i > 255 {
            i = 255
        }
        ent.s.constantLight = r | (g << 8) | (b << 16) | (i << 24)
    }

    if (ent.spawnflags & 128) != 0 {
        //Can be used by the player's BUTTON_USE
        ent.r.svFlags |= SVF_PLAYER_USABLE
    }

    ent.s.eType = ET_MOVER
    trap_LinkEntity(ent)

    ent.s.pos.trType = TR_STATIONARY
    ent.s.pos.trBase = ent.pos1
}

/// Source: oracle/codemp/game/g_mover.c:2663
func funcBBrushTouch(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
}

/**
```
QUAKED func_breakable (0 .8 .5) ? INVINCIBLE IMPACT CRUSHER THIN SABERONLY HEAVY_WEAP USE_NOT_BREAK PLAYER_USE NO_EXPLOSION
INVINCIBLE - can only be broken by being used
IMPACT - does damage on impact
CRUSHER - won't reverse movement when hit an obstacle
THIN - can be broken by impact damage, like glass
SABERONLY - only takes damage from sabers
HEAVY_WEAP - only takes damage by a heavy weapon, like an emplaced gun or AT-ST gun.
USE_NOT_BREAK - Using it doesn't make it break, still can be destroyed by damage
PLAYER_USE - Player can use it with the use button
NO_EXPLOSION - Does not play an explosion effect, though will still create chunks if specified

When destroyed, fires it's trigger and chunks and plays sound "noise" or sound for type if no noise specified

"targetname" entities with matching target will fire it
"paintarget" target to fire when hit (but not destroyed)
"wait"		how long minimum to wait between firing paintarget each time hit
"delay"		When killed or used, how long (in seconds) to wait before blowing up (none by default)
"model2"	.md3 model to also draw
"target"	all entities with a matching targetname will be used when this is destoryed
"health"	default is 10
"numchunks" Multiplies the number of chunks spawned.  Chunk code tries to pick a good volume of chunks, but you can alter this to scale the number of spawned chunks. (default 1)  (.5) is half as many chunks, (2) is twice as many chunks
"chunksize"	scales up/down the chunk size by this number (default is 1)
"playfx"	path of effect to play on death

"showhealth" if non-0, will display the health bar on the hud when the crosshair is over this ent (in siege)
"teamowner" in siege this will specify which team this thing is "owned" by. To that team the crosshair will
highlight green, to the other team it will highlight red.

Damage: default is none
"splashDamage" - damage to do
"splashRadius" - radius for above damage

"team" - If set, only this team can trip this trigger
	0 - any
	1 - red
	2 - blue

Don't know if these work:
"color"		constantLight color
"light"		constantLight radius

"material" - default is "0 - MAT_METAL" - choose from this list:
0 = MAT_METAL		(basic blue-grey scorched-DEFAULT)
1 = MAT_GLASS
2 = MAT_ELECTRICAL	(sparks only)
3 = MAT_ELEC_METAL	(METAL2 chunks and sparks)
4 =	MAT_DRK_STONE	(brown stone chunks)
5 =	MAT_LT_STONE	(tan stone chunks)
6 =	MAT_GLASS_METAL (glass and METAL2 chunks)
7 = MAT_METAL2		(electronic type of metal)
8 = MAT_NONE		(no chunks)
9 = MAT_GREY_STONE	(grey colored stone)
10 = MAT_METAL3		(METAL and METAL2 chunk combo)
11 = MAT_CRATE1		(yellow multi-colored crate chunks)
12 = MAT_GRATE1		(grate chunks--looks horrible right now)
13 = MAT_ROPE		(for yavin_trial, no chunks, just wispy bits )
14 = MAT_CRATE2		(red multi-colored crate chunks)
15 = MAT_WHITE_METAL (white angular chunks for Stu, NS_hideout )
16 = MAT_SNOWY_ROCK	 (mix of gray and brown rocks)

Applicable only during Siege gametype:
teamnodmg - if 1, team 1 can't damage this. If 2, team 2 can't damage this.
```
*/
/// Source: oracle/codemp/game/g_mover.c:2731
func SP_func_breakable(_ `self`: Entity) {
    var t: Int32 = 0
    var s: String = ""

    G_SpawnString("playfx", "", &s)

    if !s.isEmpty {
        //should we play a special death effect?
        `self`.genericValue15 = G_EffectIndex(s)
    } else {
        `self`.genericValue15 = 0
    }

    if !((`self`.spawnflags & 1) != 0) {
        if `self`.health == 0 {
            `self`.health = 10
        }
    }

    G_SpawnInt("showhealth", "0", &t)

    if t != 0 {
        //a non-0 maxhealth value will mean we want to show the health on the hud
        `self`.maxHealth = `self`.health
        G_ScaleNetHealth(`self`)
    }

    //NOTE: g_spawn.c does this automatically now
    //G_SpawnInt( "teamowner", "0", &t );
    //self->s.teamowner = t;

    if (`self`.spawnflags & 16) != 0 {
        `self`.flags |= FL_DMG_BY_SABER_ONLY
    } else if (`self`.spawnflags & 32) != 0 {
        `self`.flags |= FL_DMG_BY_HEAVY_WEAP_ONLY
    }

    if `self`.health != 0 {
        `self`.takedamage = true
    }

    G_SoundIndex("sound/weapons/explosions/cargoexplode.wav") //precaching
    G_SpawnFloat("radius", "1", &`self`.radius) // used to scale chunk code if desired by a designer
    G_SpawnInt("material", "0", &`self`.material)

    G_SpawnInt("splashDamage", "0", &`self`.splashDamage)
    G_SpawnInt("splashRadius", "0", &`self`.splashRadius)

    CacheChunkEffects(`self`.material)

    `self`.use = Use.funcBBrushUse

    //if ( self->paintarget )
    do {
        `self`.pain = Pain.funcBBrushPain
    }

    `self`.touch = Touch.funcBBrushTouch

    /*
    if ( self->team && self->team[0] )
    {
    self->alliedTeam = TranslateTeamName( self->team );
    if(self->alliedTeam == TEAM_FREE)
    {
    G_Error("team name %s not recognized\n", self->team);
    }
    }
    */
    if `self`.team != nil && !`self`.team!.isEmpty && g_gametype.integer == GT_SIEGE && `self`.teamnodmg == 0 {
        `self`.teamnodmg = atoi(`self`.team!)
    }
    `self`.team = nil
    if `self`.model == nil {
        G_Error("func_breakable with NULL model\n")
    }
    InitBBrush(`self`)

    if `self`.radius == 0 {
        //numchunks multiplier
        `self`.radius = 1.0
    }
    if `self`.mass == 0 {
        //chunksize multiplier
        `self`.mass = 1.0
    }
    `self`.genericValue4 = 1 //so damage sys knows it's a bbrush
}

/// Source: oracle/codemp/game/g_mover.c:2831
public func G_EntIsBreakable(_ entityNum: Int32) -> Bool {
    var ent: Entity?

    if entityNum < 0 || entityNum >= ENTITYNUM_WORLD {
        return false
    }

    ent = g_entities[entityNum]
    if (ent!.r.svFlags & SVF_GLASS_BRUSH) != 0 {
        return true
    }
    /*
    if ( (ent->svFlags&SVF_BBRUSH) )
    {
    return qtrue;
    }
    */
    if Q_stricmp("func_breakable", ent!.classname!) == 0 {
        return true
    }

    if Q_stricmp("misc_model_breakable", ent!.classname!) == 0 {
        return true
    }
    if Q_stricmp("misc_maglock", ent!.classname!) == 0 {
        return true
    }

    return false
}

/**
```
===============================================================================

GLASS

===============================================================================
```
*/
/// Source: oracle/codemp/game/g_mover.c:2875
func GlassDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    var te: Entity?
    var dif = vec3_t()

    if `self`.genericValue5 != 0 {
        //was already destroyed, do not retrigger it
        return
    }

    `self`.genericValue5 = 1

    dif[0] = (`self`.r.absmax[0] + `self`.r.absmin[0]) / 2
    dif[1] = (`self`.r.absmax[1] + `self`.r.absmin[1]) / 2
    dif[2] = (`self`.r.absmax[2] + `self`.r.absmin[2]) / 2

    G_UseTargets(`self`, attacker)

    `self`.splashRadius = 40 // ?? some random number, maybe it's ok?

    te = G_TempEntity(dif, EV_GLASS_SHATTER)
    te!.s.genericenemyindex = `self`.s.number
    te!.s.origin = `self`.pos1
    te!.s.angles = `self`.pos2
    te!.s.trickedentindex = Int32(`self`.splashRadius)
    te!.s.pos.trTime = Int32(`self`.genericValue3)

    G_FreeEntity(`self`)
}

/// Source: oracle/codemp/game/g_mover.c:2905
func GlassDie_Old(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    var te: Entity?
    var dif = vec3_t()

    dif[0] = (`self`.r.absmax[0] + `self`.r.absmin[0]) / 2
    dif[1] = (`self`.r.absmax[1] + `self`.r.absmin[1]) / 2
    dif[2] = (`self`.r.absmax[2] + `self`.r.absmin[2]) / 2

    G_UseTargets(`self`, attacker)

    te = G_TempEntity(dif, EV_GLASS_SHATTER)
    te!.s.genericenemyindex = `self`.s.number
    te!.s.origin = `self`.r.maxs
    te!.s.angles = `self`.r.mins

    G_FreeEntity(`self`)
}

/// Source: oracle/codemp/game/g_mover.c:2924
func GlassPain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    //G_Printf("Mr. Glass says: PLZ NO IT HURTS\n");
    //Make "cracking" sound?
}

/// Source: oracle/codemp/game/g_mover.c:2930
func GlassUse(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    var temp1 = vec3_t()
    var temp2 = vec3_t()

    //no direct object to blame for the break, so fill the values with whatever
    temp1 = `self`.r.mins + `self`.r.maxs
    temp1 = temp1 * 0.5

    temp2 = other.r.mins + other.r.maxs
    temp2 = temp2 * 0.5

    `self`.pos2 = temp1 - temp2
    `self`.pos1 = temp1

    VectorNormalize(&`self`.pos2)
    `self`.pos2 = `self`.pos2 * 390

    GlassDie(`self`, other, activator, 100, MOD_UNKNOWN)
}

/**
```
QUAKED func_glass (0 .5 .8) ? x x x x x x PLAYER_USE INACTIVE
Breakable glass
"model2"	.md3 model to also draw
"color"		constantLight color
"light"		constantLight radius
"maxshards"	Max number of shards to spawn on glass break
```
*/
/// Source: oracle/codemp/game/g_mover.c:2957
func SP_func_glass(_ ent: Entity) {
    trap_SetBrushModel(ent, ent.model!)
    InitMover(ent)

    ent.r.svFlags = SVF_GLASS_BRUSH

    ent.s.pos.trBase = ent.s.origin
    ent.r.currentOrigin = ent.s.origin
    if ent.health == 0 {
        ent.health = 1
    }

    G_SpawnInt("maxshards", "0", &ent.genericValue3)

    ent.genericValue1 = 0

    ent.genericValue4 = 1

    ent.moverState = MOVER_POS1

    if (ent.spawnflags & 1) != 0 {
        ent.takedamage = false
    } else {
        ent.takedamage = true
    }

    ent.die = Die.GlassDie
    ent.use = Use.GlassUse
    ent.pain = Pain.GlassPain
}

/// Source: oracle/codemp/game/g_mover.c:2995
func func_wait_return_solid(_ `self`: Entity) {
    //once a frame, see if it's clear.
    `self`.clipmask = CONTENTS_BODY
    if !((`self`.spawnflags & 16) != 0) || G_TestEntityPosition(`self`) == nil {
        trap_SetBrushModel(`self`, `self`.model!)
        InitMover(`self`)
        `self`.s.pos.trBase = `self`.s.origin
        `self`.r.currentOrigin = `self`.s.origin
        `self`.r.svFlags &= ~SVF_NOCLIENT
        `self`.s.eFlags &= ~EF_NODRAW
        `self`.use = Use.func_usable_use
        `self`.clipmask = 0
        if `self`.target2 != nil && !`self`.target2!.isEmpty {
            G_UseTargets2(`self`, `self`.activator!, `self`.target2!)
        }
        //FIXME: Animations?
        /*if ( self->s.eFlags & EF_ANIM_ONCE )
        {//Start our anim
        self->s.frame = 0;
        }*/
    } else {
        `self`.clipmask = 0
        `self`.think = Think.func_wait_return_solid
        `self`.nextthink = level.time + FRAMETIME
    }
}

/// Source: oracle/codemp/game/g_mover.c:3027
func func_usable_think(_ `self`: Entity) {
    if (`self`.spawnflags & 8) != 0 {
        `self`.r.svFlags |= SVF_PLAYER_USABLE //Replace the usable flag
        `self`.use = Use.func_usable_use
        `self`.think = nil
    }
}

/// Source: oracle/codemp/game/g_mover.c:3037
public func G_EntIsRemovableUsable(_ entNum: Int32) -> Bool {
    let ent: Entity? = g_entities[entNum]
    if ent!.classname != nil && Q_stricmp("func_usable", ent!.classname!) == 0 {
        if !((ent!.s.eFlags & EF_SHADER_ANIM) != 0) && !((ent!.spawnflags & 8) != 0) && ent!.targetname != nil {
            //not just a shader-animator and not ALWAYS_ON, so it must be removable somehow
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/game/g_mover.c:3050
func func_usable_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    //Toggle on and off
    G_ActivateBehavior(`self`, BSET_USE)
    if (`self`.s.eFlags & EF_SHADER_ANIM) != 0 {
        //animate shader when used
        `self`.s.frame += 1 //inc frame
        if `self`.s.frame > `self`.genericValue5 {
            //wrap around
            `self`.s.frame = 0
        }
        if `self`.target != nil && !`self`.target!.isEmpty {
            G_UseTargets(`self`, activator)
        }
    } else if (`self`.spawnflags & 8) != 0 {
        //ALWAYS_ON
        //Remove the ability to use the entity directly
        `self`.r.svFlags &= ~SVF_PLAYER_USABLE
        //also remove ability to call any use func at all!
        `self`.use = nil

        if `self`.target != nil && !`self`.target!.isEmpty {
            G_UseTargets(`self`, activator)
        }

        if `self`.wait != 0 {
            `self`.think = Think.func_usable_think
            `self`.nextthink = Int32(level.time + (`self`.wait * 1000))
        }

        return
    } else if `self`.count == 0 {
        //become solid again
        `self`.count = 1
        func_wait_return_solid(`self`)
    } else {
        `self`.s.solid = 0
        `self`.r.contents = 0
        `self`.clipmask = 0
        `self`.r.svFlags |= SVF_NOCLIENT
        `self`.s.eFlags |= EF_NODRAW
        `self`.count = 0

        if `self`.target != nil && !`self`.target!.isEmpty {
            G_UseTargets(`self`, activator)
        }
        `self`.think = nil
        `self`.nextthink = -1
    }
}

/// Source: oracle/codemp/game/g_mover.c:3108
func func_usable_pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    GlobalUse(`self`, attacker, attacker)
}

/// Source: oracle/codemp/game/g_mover.c:3113
func func_usable_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    `self`.takedamage = false
    GlobalUse(`self`, inflictor, attacker)
}

/// Source: oracle/codemp/game/g_mover.c:3140
func SP_func_usable(_ `self`: Entity) {
    trap_SetBrushModel(`self`, `self`.model!)
    InitMover(`self`)
    `self`.s.pos.trBase = `self`.s.origin
    `self`.r.currentOrigin = `self`.s.origin
    `self`.pos1 = `self`.s.origin

    G_SpawnInt("endframe", "0", &`self`.genericValue5)

    if `self`.model2 != nil && !`self`.model2!.isEmpty {
        if strstr(`self`.model2!, ".glm") != nil {
            //for now, not supported in MP.
            `self`.s.modelindex2 = 0
        } else {
            `self`.s.modelindex2 = G_ModelIndex(`self`.model2!)
        }
    }

    `self`.count = 1
    if (`self`.spawnflags & 1) != 0 {
        `self`.s.solid = 0
        `self`.r.contents = 0
        `self`.clipmask = 0
        `self`.r.svFlags |= SVF_NOCLIENT
        `self`.s.eFlags |= EF_NODRAW
        `self`.count = 0
    }

    //FIXME: Animation?
    /*
    if (self->spawnflags & 2)
    {
    self->s.eFlags |= EF_ANIM_ALLFAST;
    }

    if (self->spawnflags & 4)
    {//FIXME: need to be able to do change to something when it's done?  Or not be usable until it's done?
    self->s.eFlags |= EF_ANIM_ONCE;
    }
    */

    `self`.use = Use.func_usable_use

    if `self`.health != 0 {
        `self`.takedamage = true
        `self`.die = Die.func_usable_die
        `self`.pain = Pain.func_usable_pain
    }

    if `self`.genericValue5 > 0 {
        `self`.s.frame = 0
        `self`.s.eFlags |= EF_SHADER_ANIM
        `self`.s.time = `self`.genericValue5 + 1
    }

    trap_LinkEntity(`self`)
}

//static -slc
/// Source: oracle/codemp/game/g_mover.c:3215
func use_wall(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(ent, BSET_USE)

    // Not there so make it there
    if !((ent.r.contents & CONTENTS_SOLID) != 0) {
        ent.r.svFlags &= ~SVF_NOCLIENT
        ent.s.eFlags &= ~EF_NODRAW
        ent.r.contents = CONTENTS_SOLID
        if !((ent.spawnflags & 1) != 0) {
            //START_OFF doesn't effect area portals
            trap_AdjustAreaPortalState(ent, false)
        }
    } else {
        // Make it go away
        ent.r.contents = 0
        ent.r.svFlags |= SVF_NOCLIENT
        ent.s.eFlags |= EF_NODRAW
        if !((ent.spawnflags & 1) != 0) {
            //START_OFF doesn't effect area portals
            trap_AdjustAreaPortalState(ent, true)
        }
    }
}

/**
```
QUAKED func_wall (0 .5 .8) ? START_OFF x x x x x PLAYER_USE INACTIVE
PLAYER_USE	Player can use it with the use button
INACTIVE	must be used by a target_activate before it can be used

A bmodel that just sits there, doing nothing.  Can be used for conditional walls and models.
"model2"	.md3 model to also draw
"color"		constantLight color
"light"		constantLight radius

START_OFF - the wall will not be there
```
*/
/// Source: oracle/codemp/game/g_mover.c:3256
func SP_func_wall(_ ent: Entity) {
    trap_SetBrushModel(ent, ent.model!)

    ent.pos1 = ent.s.origin
    ent.pos2 = ent.s.origin

    InitMover(ent)
    ent.s.pos.trBase = ent.s.origin
    ent.r.currentOrigin = ent.s.origin

    // it must be START_OFF
    if (ent.spawnflags & FUNC_WALL_OFF) != 0 {
        ent.r.contents = 0
        ent.r.svFlags |= SVF_NOCLIENT
        ent.s.eFlags |= EF_NODRAW
    }

    ent.use = Use.use_wall

    trap_LinkEntity(ent)
}
