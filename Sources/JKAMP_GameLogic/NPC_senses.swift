import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_senses.c:864
let MAX_INTEREST_DIST = (256 * 256) as Int32

/**
```
qboolean G_ClearLineOfSight(const vec3_t point1, const vec3_t point2, int ignore, int clipmask)

returns true if can see from point 1 to 2, even through glass (1 pane)- doesn't work with portals
```
*/
/// Source: oracle/codemp/game/NPC_senses.c:11
func G_ClearLineOfSight(_ point1: JKAShared.vec3_t, _ point2: JKAShared.vec3_t, _ ignore: Int32, _ clipmask: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var hit: Entity?

        trap_Trace(tr, point1, vec3_origin, vec3_origin, point2, ignore, clipmask)
        if Double(tr.fraction) == 1.0 {
            return true
        }

        hit = g_entities[tr.entityNum]
        if EntIsGlass(hit!) {
            var newpoint1 = vec3_t()
            newpoint1 = tr.endpos
            trap_Trace(tr, newpoint1, vec3_origin, vec3_origin, point2, hit!.s.number, clipmask)

            if Double(tr.fraction) == 1.0 {
                return true
            }
        }

        return false
    }
}

/**
```
CanSee
determine if NPC can see an entity

This is a straight line trace check.  This function does not look at PVS or FOV,
or take any AI related factors (for example, the NPC's reaction time) into account

FIXME do we need fat and thin version of this?
```
*/
/// Source: oracle/codemp/game/NPC_senses.c:47
func CanSee(_ ent: Entity) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var eyes = vec3_t()
        var spot = vec3_t()

        CalcEntitySpot(NPC!, SPOT_HEAD_LEAN, &eyes)

        CalcEntitySpot(ent, SPOT_ORIGIN, &spot)
        trap_Trace(tr, eyes, vec3_origin, vec3_origin, spot, NPC!.s.number, MASK_OPAQUE)
        ShotThroughGlass(tr, ent, spot, MASK_OPAQUE)
        if Double(tr.fraction) == 1.0 {
            return true
        }

        CalcEntitySpot(ent, SPOT_HEAD, &spot)
        trap_Trace(tr, eyes, vec3_origin, vec3_origin, spot, NPC!.s.number, MASK_OPAQUE)
        ShotThroughGlass(tr, ent, spot, MASK_OPAQUE)
        if Double(tr.fraction) == 1.0 {
            return true
        }

        CalcEntitySpot(ent, SPOT_LEGS, &spot)
        trap_Trace(tr, eyes, vec3_origin, vec3_origin, spot, NPC!.s.number, MASK_OPAQUE)
        ShotThroughGlass(tr, ent, spot, MASK_OPAQUE)
        if Double(tr.fraction) == 1.0 {
            return true
        }

        return false
    }
}

/// Source: oracle/codemp/game/NPC_senses.c:82
func InFront(_ spot: JKAShared.vec3_t, _ from: JKAShared.vec3_t, _ fromAngles: JKAShared.vec3_t, _ threshHold: Float) -> Bool {
    var dir = vec3_t()
    var forward = vec3_t()
    var angles = vec3_t()
    let dot: Float

    dir = spot - from
    dir[2] = 0
    VectorNormalize(&dir)

    angles = fromAngles
    angles[0] = 0
    // Raven passes NULL for the `right` and `up` outputs, so the call passes scratch locals.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(angles, &forward, &scratchRight, &scratchUp)

    dot = _DotProduct(dir, forward)

    return (dot > threshHold)
}

/// Source: oracle/codemp/game/NPC_senses.c:109
func InFOV3(_ spot: JKAShared.vec3_t, _ from: JKAShared.vec3_t, _ fromAngles: JKAShared.vec3_t, _ hFOV: Int32, _ vFOV: Int32) -> Bool {
    var deltaVector = vec3_t()
    var angles = vec3_t()
    var deltaAngles = vec3_t()

    deltaVector = spot - from
    vectoangles(deltaVector, &angles)

    deltaAngles[PITCH] = AngleDelta(fromAngles[PITCH], angles[PITCH])
    deltaAngles[YAW] = AngleDelta(fromAngles[YAW], angles[YAW])

    if abs(deltaAngles[PITCH]) <= vFOV && abs(deltaAngles[YAW]) <= hFOV {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/NPC_senses.c:129
func InFOV2(_ origin: JKAShared.vec3_t, _ from: Entity, _ hFOV: Int32, _ vFOV: Int32) -> Bool {
    var fromAngles = vec3_t()
    var eyes = vec3_t()

    if from.client != nil {
        fromAngles = from.client!.ps.viewangles
    } else {
        fromAngles = from.s.angles
    }

    CalcEntitySpot(from, SPOT_HEAD, &eyes)

    return InFOV3(origin, eyes, fromAngles, hFOV, vFOV)
}

/// Source: oracle/codemp/game/NPC_senses.c:149
func InFOV(_ ent: Entity, _ from: Entity, _ hFOV: Int32, _ vFOV: Int32) -> Bool {
    var eyes = vec3_t()
    var spot = vec3_t()
    var deltaVector = vec3_t()
    var angles = vec3_t()
    var fromAngles = vec3_t()
    var deltaAngles = vec3_t()

    if from.client != nil {
        if VectorCompare(from.client!.renderInfo.eyeAngles, vec3_origin) == 0 {
            //Actual facing of tag_head!
            //NOTE: Stasis aliens may have a problem with this?
            fromAngles = from.client!.renderInfo.eyeAngles
        } else {
            fromAngles = from.client!.ps.viewangles
        }
    } else {
        fromAngles = from.s.angles
    }

    CalcEntitySpot(from, SPOT_HEAD_LEAN, &eyes)

    CalcEntitySpot(ent, SPOT_ORIGIN, &spot)
    deltaVector = spot - eyes

    vectoangles(deltaVector, &angles)
    deltaAngles[PITCH] = AngleDelta(fromAngles[PITCH], angles[PITCH])
    deltaAngles[YAW] = AngleDelta(fromAngles[YAW], angles[YAW])
    if abs(deltaAngles[PITCH]) <= vFOV && abs(deltaAngles[YAW]) <= hFOV {
        return true
    }

    CalcEntitySpot(ent, SPOT_HEAD, &spot)
    deltaVector = spot - eyes
    vectoangles(deltaVector, &angles)
    deltaAngles[PITCH] = AngleDelta(fromAngles[PITCH], angles[PITCH])
    deltaAngles[YAW] = AngleDelta(fromAngles[YAW], angles[YAW])
    if abs(deltaAngles[PITCH]) <= vFOV && abs(deltaAngles[YAW]) <= hFOV {
        return true
    }

    CalcEntitySpot(ent, SPOT_LEGS, &spot)
    deltaVector = spot - eyes
    vectoangles(deltaVector, &angles)
    deltaAngles[PITCH] = AngleDelta(fromAngles[PITCH], angles[PITCH])
    deltaAngles[YAW] = AngleDelta(fromAngles[YAW], angles[YAW])
    if abs(deltaAngles[PITCH]) <= vFOV && abs(deltaAngles[YAW]) <= hFOV {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/NPC_senses.c:210
func InVisrange(_ ent: Entity) -> Bool {
    //FIXME: make a calculate visibility for ents that takes into account
    //lighting, movement, turning, crouch/stand up, other anims, hide brushes, etc.
    var eyes = vec3_t()
    var spot = vec3_t()
    var deltaVector = vec3_t()
    let visrange: Float = (NPCInfo!.stats.visrange * NPCInfo!.stats.visrange)

    CalcEntitySpot(NPC!, SPOT_HEAD_LEAN, &eyes)

    CalcEntitySpot(ent, SPOT_ORIGIN, &spot)
    deltaVector = spot - eyes

    /*if(ent->client)
    {
    float	vel, avel;
    if(ent->client->ps.velocity[0] || ent->client->ps.velocity[1] || ent->client->ps.velocity[2])
    {
    vel = VectorLength(ent->client->ps.velocity);
    if(vel > 128)
    {
    visrange += visrange * (vel/256);
    }
    }

    if(ent->avelocity[0] || ent->avelocity[1] || ent->avelocity[2])
    {//FIXME: shouldn't they need to have line of sight to you to detect this?
    avel = VectorLength(ent->avelocity);
    if(avel > 15)
    {
    visrange += visrange * (avel/60);
    }
    }
    }*/

    if VectorLengthSquared(deltaVector) > visrange {
        return false
    }

    return true
}

/// Source: oracle/codemp/game/NPC_senses.c:257
func NPC_CheckVisibility(_ ent: Entity, _ flags: Int32) -> visibility_t {
    // flags should never be 0
    if flags == 0 {
        return VIS_NOT
    }

    // check PVS
    if (flags & CHECK_PVS) != 0 {
        if !trap_InPVS(ent.r.currentOrigin, NPC!.r.currentOrigin) {
            return VIS_NOT
        }
    }
    if !((flags & (CHECK_360 | CHECK_FOV | CHECK_SHOOT)) != 0) {
        return VIS_PVS
    }

    // check within visrange
    if (flags & CHECK_VISRANGE) != 0 {
        if !InVisrange(ent) {
            return VIS_PVS
        }
    }

    // check 360 degree visibility
    //Meaning has to be a direct line of site
    if (flags & CHECK_360) != 0 {
        if !CanSee(ent) {
            return VIS_PVS
        }
    }
    if !((flags & (CHECK_FOV | CHECK_SHOOT)) != 0) {
        return VIS_360
    }

    // check FOV
    if (flags & CHECK_FOV) != 0 {
        if !InFOV(ent, NPC!, NPCInfo!.stats.hfov, NPCInfo!.stats.vfov) {
            return VIS_360
        }
    }

    if !((flags & CHECK_SHOOT) != 0) {
        return VIS_FOV
    }

    // check shootability
    if (flags & CHECK_SHOOT) != 0 {
        if !CanShoot(ent, NPC!) {
            return VIS_FOV
        }
    }

    return VIS_SHOOT
}

/**
```
-------------------------
NPC_CheckSoundEvents
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_senses.c:332
private func G_CheckSoundEvents(_ `self`: Entity, _ maxHearDist: Float, _ ignoreAlert: Int32, _ mustHaveOwner: Bool, _ minAlertLevel: Int32) -> Int32 {
    var bestEvent: Int32 = -1
    var bestAlert: Int32 = -1
    var bestTime: Int32 = -1
    var i: Int32
    var dist: Float
    var radius: Float
    // Raven assigns his own `maxHearDist` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var maxHearDist = maxHearDist

    maxHearDist *= maxHearDist

    i = 0
    while i < level.numAlertEvents {
        //are we purposely ignoring this alert?
        if i == ignoreAlert {
            i += 1
            continue
        }
        //We're only concerned about sounds
        if level.alertEvents[i].type != AET_SOUND {
            i += 1
            continue
        }
        //must be at least this noticable
        if level.alertEvents[i].level < minAlertLevel {
            i += 1
            continue
        }
        //must have an owner?
        if mustHaveOwner && level.alertEvents[i].owner == nil {
            i += 1
            continue
        }
        //Must be within range
        dist = DistanceSquared(level.alertEvents[i].position, `self`.r.currentOrigin)

        //can't hear it
        if dist > maxHearDist {
            i += 1
            continue
        }

        radius = level.alertEvents[i].radius * level.alertEvents[i].radius
        if dist > radius {
            i += 1
            continue
        }

        if level.alertEvents[i].addLight != 0 {
            //a quiet sound, must have LOS to hear it
            if G_ClearLOS5(`self`, level.alertEvents[i].position) == false {
                //no LOS, didn't hear it
                i += 1
                continue
            }
        }

        //See if this one takes precedence over the previous one
        if level.alertEvents[i].level >= bestAlert || (level.alertEvents[i].level == bestAlert && level.alertEvents[i].timestamp >= bestTime) {
            //NOTE: equal is better because it's later in the array
            bestEvent = i
            bestAlert = level.alertEvents[i].level
            bestTime = level.alertEvents[i].timestamp
        }
        i += 1
    }

    return bestEvent
}

/// Source: oracle/codemp/game/NPC_senses.c:388
func G_GetLightLevel(_ pos: JKAShared.vec3_t, _ fromDir: JKAShared.vec3_t) -> Float {
    /*
    vec3_t	ambient={0}, directed, lightDir;

    cgi_R_GetLighting( pos, ambient, directed, lightDir );
    lightLevel = VectorLength( ambient ) + (VectorLength( directed )*DotProduct( lightDir, fromDir ));
    */
    let lightLevel: Float
    //rwwFIXMEFIXME: ...this is evil. We can possibly read from the server BSP data, or load the lightmap along
    //with collision data and whatnot, but is it worth it?
    lightLevel = 255

    return lightLevel
}

/**
```
-------------------------
NPC_CheckSightEvents
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_senses.c:408
private func G_CheckSightEvents(_ `self`: Entity, _ hFOV: Int32, _ vFOV: Int32, _ maxSeeDist: Float, _ ignoreAlert: Int32, _ mustHaveOwner: Bool, _ minAlertLevel: Int32) -> Int32 {
    var bestEvent: Int32 = -1
    var bestAlert: Int32 = -1
    var bestTime: Int32 = -1
    var i: Int32
    var dist: Float
    var radius: Float
    // Raven assigns his own `maxSeeDist` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var maxSeeDist = maxSeeDist

    maxSeeDist *= maxSeeDist
    i = 0
    while i < level.numAlertEvents {
        //are we purposely ignoring this alert?
        if i == ignoreAlert {
            i += 1
            continue
        }
        //We're only concerned about sounds
        if level.alertEvents[i].type != AET_SIGHT {
            i += 1
            continue
        }
        //must be at least this noticable
        if level.alertEvents[i].level < minAlertLevel {
            i += 1
            continue
        }
        //must have an owner?
        if mustHaveOwner && level.alertEvents[i].owner == nil {
            i += 1
            continue
        }

        //Must be within range
        dist = DistanceSquared(level.alertEvents[i].position, `self`.r.currentOrigin)

        //can't see it
        if dist > maxSeeDist {
            i += 1
            continue
        }

        radius = level.alertEvents[i].radius * level.alertEvents[i].radius
        if dist > radius {
            i += 1
            continue
        }

        //Must be visible
        if InFOV2(level.alertEvents[i].position, `self`, hFOV, vFOV) == false {
            i += 1
            continue
        }

        if G_ClearLOS5(`self`, level.alertEvents[i].position) == false {
            i += 1
            continue
        }

        //FIXME: possibly have the light level at this point affect the
        //			visibility/alert level of this event?  Would also
        //			need to take into account how bright the event
        //			itself is.  A lightsaber would stand out more
        //			in the dark... maybe pass in a light level that
        //			is added to the actual light level at this position?

        //See if this one takes precedence over the previous one
        if level.alertEvents[i].level >= bestAlert || (level.alertEvents[i].level == bestAlert && level.alertEvents[i].timestamp >= bestTime) {
            //NOTE: equal is better because it's later in the array
            bestEvent = i
            bestAlert = level.alertEvents[i].level
            bestTime = level.alertEvents[i].timestamp
        }
        i += 1
    }

    return bestEvent
}

/// Source: oracle/codemp/game/NPC_senses.c:478
func G_CheckAlertEvents(_ `self`: Entity, _ checkSight: Bool, _ checkSound: Bool, _ maxSeeDist: Float, _ maxHearDist: Float, _ ignoreAlert: Int32, _ mustHaveOwner: Bool, _ minAlertLevel: Int32) -> Int32 {
    var bestSoundEvent: Int32 = -1
    var bestSightEvent: Int32 = -1
    var bestSoundAlert: Int32 = -1
    var bestSightAlert: Int32 = -1

    if g_entities[0] == nil || g_entities[0].health <= 0 {
        //player is dead
        return -1
    }

    //get sound event
    bestSoundEvent = G_CheckSoundEvents(`self`, maxHearDist, ignoreAlert, mustHaveOwner, minAlertLevel)
    //get sound event alert level
    if bestSoundEvent >= 0 {
        bestSoundAlert = level.alertEvents[bestSoundEvent].level
    }

    //get sight event
    if `self`.NPC != nil {
        bestSightEvent = G_CheckSightEvents(`self`, `self`.NPC!.stats.hfov, `self`.NPC!.stats.vfov, maxSeeDist, ignoreAlert, mustHaveOwner, minAlertLevel)
    } else {
        bestSightEvent = G_CheckSightEvents(`self`, 80, 80, maxSeeDist, ignoreAlert, mustHaveOwner, minAlertLevel) //FIXME: look at cg_view to get more accurate numbers?
    }
    //get sight event alert level
    if bestSightEvent >= 0 {
        bestSightAlert = level.alertEvents[bestSightEvent].level
    }

    //return the one that has a higher alert (or sound if equal)
    //FIXME:	This doesn't take the distance of the event into account

    if bestSightEvent >= 0 && bestSightAlert > bestSoundAlert {
        //valid best sight event, more important than the sound event
        //get the light level of the alert event for this checker
        var eyePoint = vec3_t()
        var sightDir = vec3_t()
        //get eye point
        CalcEntitySpot(`self`, SPOT_HEAD_LEAN, &eyePoint)
        sightDir = level.alertEvents[bestSightEvent].position - eyePoint
        level.alertEvents[bestSightEvent].light = level.alertEvents[bestSightEvent].addLight + G_GetLightLevel(level.alertEvents[bestSightEvent].position, sightDir)
        //return the sight event
        return bestSightEvent
    }
    //return the sound event
    return bestSoundEvent
}

/// Source: oracle/codemp/game/NPC_senses.c:532
func NPC_CheckAlertEvents(_ checkSight: Bool, _ checkSound: Bool, _ ignoreAlert: Int32, _ mustHaveOwner: Bool, _ minAlertLevel: Int32) -> Int32 {
    return G_CheckAlertEvents(NPC!, checkSight, checkSound, NPCInfo!.stats.visrange, NPCInfo!.stats.earshot, ignoreAlert, mustHaveOwner, minAlertLevel)
}

/// Source: oracle/codemp/game/NPC_senses.c:537
func G_CheckForDanger(_ `self`: Entity, _ alertEvent: Int32) -> Bool {
    //FIXME: more bStates need to call this?
    if alertEvent == -1 {
        return false
    }

    if level.alertEvents[alertEvent].level >= AEL_DANGER {
        //run away!
        if level.alertEvents[alertEvent].owner == nil || level.alertEvents[alertEvent].owner!.client == nil || (level.alertEvents[alertEvent].owner != `self` && level.alertEvents[alertEvent].owner!.client!.playerTeam != `self`.client!.playerTeam) {
            if `self`.NPC != nil {
                if (`self`.NPC!.scriptFlags & SCF_DONT_FLEE) != 0 {
                    //can't flee
                    return false
                } else {
                    NPC_StartFlee(level.alertEvents[alertEvent].owner!, level.alertEvents[alertEvent].position, level.alertEvents[alertEvent].level, 3000, 6000)
                    return true
                }
            } else {
                return true
            }
        }
    }
    return false
}

/// Source: oracle/codemp/game/NPC_senses.c:568
func NPC_CheckForDanger(_ alertEvent: Int32) -> Bool {
    //FIXME: more bStates need to call this?
    return G_CheckForDanger(NPC!, alertEvent)
}

/// Source: oracle/codemp/game/NPC_senses.c:579
func AddSoundEvent(_ owner: Entity, _ position: JKAShared.vec3_t, _ radius: Float, _ alertLevel: alertEventLevel_e, _ needLOS: Bool) {
    //FIXME: Handle this in another manner?
    if level.numAlertEvents >= MAX_ALERT_EVENTS {
        if !RemoveOldestAlert() {
            //how could that fail?
            return
        }
    }

    if owner == nil && alertLevel < AEL_DANGER {
        return
    }

    //FIXME: if owner is not a player or player ally, and there are no player allies present,
    //			perhaps we don't need to store the alert... unless we want the player to
    //			react to enemy alert events in some way?

    level.alertEvents[level.numAlertEvents].position = position

    level.alertEvents[level.numAlertEvents].radius = radius
    level.alertEvents[level.numAlertEvents].level = alertLevel
    level.alertEvents[level.numAlertEvents].type = AET_SOUND
    level.alertEvents[level.numAlertEvents].owner = owner
    if needLOS {
        //a very low-level sound, when check this sound event, check for LOS
        level.alertEvents[level.numAlertEvents].addLight = 1 //will force an LOS trace on this sound
    } else {
        level.alertEvents[level.numAlertEvents].addLight = 0 //will force an LOS trace on this sound
    }
    level.alertEvents[level.numAlertEvents].ID = level.curAlertID
    level.curAlertID += 1
    level.alertEvents[level.numAlertEvents].timestamp = level.time

    level.numAlertEvents += 1
}

/// Source: oracle/codemp/game/NPC_senses.c:623
func AddSightEvent(_ owner: Entity, _ position: JKAShared.vec3_t, _ radius: Float, _ alertLevel: alertEventLevel_e, _ addLight: Float) {
    //FIXME: Handle this in another manner?
    if level.numAlertEvents >= MAX_ALERT_EVENTS {
        if !RemoveOldestAlert() {
            //how could that fail?
            return
        }
    }

    if owner == nil && alertLevel < AEL_DANGER {
        return
    }

    //FIXME: if owner is not a player or player ally, and there are no player allies present,
    //			perhaps we don't need to store the alert... unless we want the player to
    //			react to enemy alert events in some way?

    level.alertEvents[level.numAlertEvents].position = position

    level.alertEvents[level.numAlertEvents].radius = radius
    level.alertEvents[level.numAlertEvents].level = alertLevel
    level.alertEvents[level.numAlertEvents].type = AET_SIGHT
    level.alertEvents[level.numAlertEvents].owner = owner
    level.alertEvents[level.numAlertEvents].addLight = addLight //will get added to actual light at that point when it's checked
    level.alertEvents[level.numAlertEvents].ID = level.curAlertID
    level.curAlertID += 1
    level.alertEvents[level.numAlertEvents].timestamp = level.time

    level.numAlertEvents += 1
}

/// Source: oracle/codemp/game/NPC_senses.c:660
func ClearPlayerAlertEvents() {
    let curNumAlerts: Int32 = level.numAlertEvents
    var i: Int32
    //loop through them all (max 32)
    i = 0
    while i < curNumAlerts {
        //see if the event is old enough to delete
        if level.alertEvents[i].timestamp != 0 && level.alertEvents[i].timestamp + ALERT_CLEAR_TIME < level.time {
            //this event has timed out
            //drop the count
            level.numAlertEvents -= 1
            //shift the rest down
            if level.numAlertEvents > 0 {
                //still have more in the array
                if (i + 1) < MAX_ALERT_EVENTS {
                    var j = i
                    while j < MAX_ALERT_EVENTS - 1 {
                        level.alertEvents[j] = level.alertEvents[j + 1]
                        j += 1
                    }
                }
            } else {
                //just clear this one... or should we clear the whole array?
                level.alertEvents[i].clear()
            }
        }
        i += 1
    }
    //make sure this never drops below zero... if it does, something very very bad happened

    if eventClearTime < level.time {
        //this is just a 200ms debouncer so things that generate constant alerts (like corpses and missiles) add an alert every 200 ms
        eventClearTime = level.time + ALERT_CLEAR_TIME
    }
}

/// Source: oracle/codemp/game/NPC_senses.c:695
func RemoveOldestAlert() -> Bool {
    var oldestEvent: Int32 = -1
    var oldestTime: Int32 = Q3_INFINITE
    var i: Int32
    //loop through them all (max 32)
    i = 0
    while i < level.numAlertEvents {
        //see if the event is old enough to delete
        if level.alertEvents[i].timestamp < oldestTime {
            oldestEvent = i
            oldestTime = level.alertEvents[i].timestamp
        }
        i += 1
    }
    if oldestEvent != -1 {
        //drop the count
        level.numAlertEvents -= 1
        //shift the rest down
        if level.numAlertEvents > 0 {
            //still have more in the array
            if (oldestEvent + 1) < MAX_ALERT_EVENTS {
                var j = oldestEvent
                while j < MAX_ALERT_EVENTS - 1 {
                    level.alertEvents[j] = level.alertEvents[j + 1]
                    j += 1
                }
            }
        } else {
            //just clear this one... or should we clear the whole array?
            level.alertEvents[oldestEvent].clear()
        }
    }
    //make sure this never drops below zero... if it does, something very very bad happened
    //return true is have room for one now
    return (level.numAlertEvents < MAX_ALERT_EVENTS)
}

// Position to position
/// Source: oracle/codemp/game/NPC_senses.c:739
func G_ClearLOS(_ `self`: Entity, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var traceCount: Int32 = 0

        //FIXME: ENTITYNUM_NONE ok?
        trap_Trace(tr, start, vec3_origin, vec3_origin, end, ENTITYNUM_NONE, CONTENTS_OPAQUE)
        while Double(tr.fraction) < 1.0 && traceCount < 3 {
            //can see through 3 panes of glass
            if tr.entityNum < ENTITYNUM_WORLD {
                if g_entities[tr.entityNum] != nil && (g_entities[tr.entityNum].r.svFlags & SVF_GLASS_BRUSH) != 0 {
                    //can see through glass, trace again, ignoring me
                    trap_Trace(tr, tr.endpos, vec3_origin, vec3_origin, end, tr.entityNum, MASK_OPAQUE)
                    traceCount += 1
                    continue
                }
            }
            return false
        }

        if Double(tr.fraction) == 1.0 {
            return true
        }

        return false
    }
}

//Entity to position
/// Source: oracle/codemp/game/NPC_senses.c:767
func G_ClearLOS2(_ `self`: Entity, _ ent: Entity, _ end: JKAShared.vec3_t) -> Bool {
    var eyes = vec3_t()

    CalcEntitySpot(ent, SPOT_HEAD_LEAN, &eyes)

    return G_ClearLOS(`self`, eyes, end)
}

//Position to entity
/// Source: oracle/codemp/game/NPC_senses.c:777
func G_ClearLOS3(_ `self`: Entity, _ start: JKAShared.vec3_t, _ ent: Entity) -> Bool {
    var spot = vec3_t()

    //Look for the chest first
    CalcEntitySpot(ent, SPOT_ORIGIN, &spot)

    if G_ClearLOS(`self`, start, spot) {
        return true
    }

    //Look for the head next
    CalcEntitySpot(ent, SPOT_HEAD_LEAN, &spot)

    if G_ClearLOS(`self`, start, spot) {
        return true
    }

    return false
}

//NPC's eyes to entity
/// Source: oracle/codemp/game/NPC_senses.c:797
func G_ClearLOS4(_ `self`: Entity, _ ent: Entity) -> Bool {
    var eyes = vec3_t()

    //Calculate my position
    CalcEntitySpot(`self`, SPOT_HEAD_LEAN, &eyes)

    return G_ClearLOS3(`self`, eyes, ent)
}

//NPC's eyes to position
/// Source: oracle/codemp/game/NPC_senses.c:808
func G_ClearLOS5(_ `self`: Entity, _ end: JKAShared.vec3_t) -> Bool {
    var eyes = vec3_t()

    //Calculate the my position
    CalcEntitySpot(`self`, SPOT_HEAD_LEAN, &eyes)

    return G_ClearLOS(`self`, eyes, end)
}

/// Source: oracle/codemp/game/NPC_senses.c:824
func NPC_GetHFOVPercentage(_ spot: JKAShared.vec3_t, _ from: JKAShared.vec3_t, _ facing: JKAShared.vec3_t, _ hFOV: Float) -> Float {
    var deltaVector = vec3_t()
    var angles = vec3_t()
    let delta: Float

    deltaVector = spot - from

    vectoangles(deltaVector, &angles)

    delta = abs(AngleDelta(facing[YAW], angles[YAW]))

    if delta > hFOV {
        return 0.0
    }

    return ((hFOV - delta) / hFOV)
}

/// Source: oracle/codemp/game/NPC_senses.c:847
func NPC_GetVFOVPercentage(_ spot: JKAShared.vec3_t, _ from: JKAShared.vec3_t, _ facing: JKAShared.vec3_t, _ vFOV: Float) -> Float {
    var deltaVector = vec3_t()
    var angles = vec3_t()
    let delta: Float

    deltaVector = spot - from

    vectoangles(deltaVector, &angles)

    delta = abs(AngleDelta(facing[PITCH], angles[PITCH]))

    if delta > vFOV {
        return 0.0
    }

    return ((vFOV - delta) / vFOV)
}

/// Source: oracle/codemp/game/NPC_senses.c:871
func G_FindLocalInterestPoint(_ `self`: Entity) -> Int32 {
    var i: Int32
    var bestPoint: Int32 = ENTITYNUM_NONE
    var dist: Float
    var bestDist: Float = Float(Q3_INFINITE)
    var diffVec = vec3_t()
    var eyes = vec3_t()

    CalcEntitySpot(`self`, SPOT_HEAD_LEAN, &eyes)
    i = 0
    while i < level.numInterestPoints {
        //Don't ignore portals?  If through a portal, need to look at portal!
        if trap_InPVS(level.interestPoints[i].origin, eyes) {
            diffVec = level.interestPoints[i].origin - eyes
            if (abs(diffVec[0]) + abs(diffVec[1])) / 2 < 48 && abs(diffVec[2]) > (abs(diffVec[0]) + abs(diffVec[1])) / 2 {
                //Too close to look so far up or down
                i += 1
                continue
            }
            dist = VectorLengthSquared(diffVec)
            //Some priority to more interesting points
            //dist -= ((int)level.interestPoints[i].lookMode * 5) * ((int)level.interestPoints[i].lookMode * 5);
            if dist < MAX_INTEREST_DIST && dist < bestDist {
                if G_ClearLineOfSight(eyes, level.interestPoints[i].origin, `self`.s.number, MASK_OPAQUE) {
                    bestDist = dist
                    bestPoint = i
                }
            }
        }
        i += 1
    }
    if bestPoint != ENTITYNUM_NONE && level.interestPoints[bestPoint].target != nil {
        G_UseTargets2(`self`, `self`, level.interestPoints[bestPoint].target!)
    }
    return bestPoint
}

/// Source: oracle/codemp/game/NPC_senses.c:915
func SP_target_interest(_ `self`: Entity) {
    //FIXME: rename point_interest
    if level.numInterestPoints >= MAX_INTEREST_POINTS {
        Com_Printf("ERROR:  Too many interest points, limit is %d\n", MAX_INTEREST_POINTS)
        G_FreeEntity(`self`)
        return
    }

    level.interestPoints[level.numInterestPoints].origin = `self`.r.currentOrigin

    if `self`.target != nil && !`self`.target!.isEmpty {
        level.interestPoints[level.numInterestPoints].target = G_NewString(`self`.target!)
    }

    level.numInterestPoints += 1

    G_FreeEntity(`self`)
}
