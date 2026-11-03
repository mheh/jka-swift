import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_predict.c:10
var cg_pmove: JKAMP.Pmove { world.storage.cg_pmove }

/// Source: oracle/codemp/cgame/cg_predict.c:12
var cg_numSolidEntities: Int32 {
    get { world.variables.cg_numSolidEntities }
    set { world.variables.cg_numSolidEntities = newValue }
}

/// Source: oracle/codemp/cgame/cg_predict.c:13
var cg_solidEntities: Slots<Centity?> { world.storage.cg_solidEntities }

/// Source: oracle/codemp/cgame/cg_predict.c:14
var cg_numTriggerEntities: Int32 {
    get { world.variables.cg_numTriggerEntities }
    set { world.variables.cg_numTriggerEntities = newValue }
}

/// Source: oracle/codemp/cgame/cg_predict.c:15
var cg_triggerEntities: Slots<Centity?> { world.storage.cg_triggerEntities }

/// Source: oracle/codemp/cgame/cg_predict.c:853
var cgSendPSPool: Slots<JKAMP.PlayerState> { world.storage.cgSendPSPool }

/// Source: oracle/codemp/cgame/cg_predict.c:856
var cgSendPS: Slots<JKAMP.PlayerState?> { world.storage.cgSendPS }

/// Source: oracle/codemp/cgame/cg_predict.c:959
var cg_vehPmove: JKAMP.Pmove { world.storage.cg_vehPmove }

/// Source: oracle/codemp/cgame/cg_predict.c:960
var cg_vehPmoveSet: Bool {
    get { world.variables.cg_vehPmoveSet }
    set { world.variables.cg_vehPmoveSet = newValue }
}

//is this client piloting this veh?
/// Source: oracle/codemp/cgame/cg_predict.c:18
private func CG_Piloting(_ vehNum: Int32) -> Bool {
    var veh: Centity?

    if vehNum == 0 {
        return false
    }

    veh = cg_entities[vehNum]

    if veh!.currentState.owner != cg.predictedPlayerState.clientNum {
        //the owner should be the current pilot
        return false
    }

    return true
}

/**
```
====================
CG_BuildSolidList

When a new cg.snap has been set, this function builds a sublist
of the entities that are actually solid, to make for more
efficient collision detection
====================
```
*/
/// Source: oracle/codemp/cgame/cg_predict.c:46
func CG_BuildSolidList() {
    var i: Int32
    var cent: Centity?
    var snap: Snapshot?
    var ent: EntityState?
    var difference = vec3_t()
    var dsquared: Float

    cg_numSolidEntities = 0
    cg_numTriggerEntities = 0

    if cg.nextSnap != nil && !cg.nextFrameTeleport && !cg.thisFrameTeleport {
        snap = cg.nextSnap
    } else {
        snap = cg.snap
    }

    i = 0
    while i < snap!.numEntities {
        cent = cg_entities[snap!.entities[i].number]
        ent = cent!.currentState

        if ent!.eType == ET_ITEM || ent!.eType == ET_PUSH_TRIGGER || ent!.eType == ET_TELEPORT_TRIGGER {
            cg_triggerEntities[cg_numTriggerEntities] = cent
            cg_numTriggerEntities += 1
            i += 1
            continue
        }

        if cent!.nextState.solid != 0 {
            cg_solidEntities[cg_numSolidEntities] = cent
            cg_numSolidEntities += 1
            i += 1
            continue
        }
        i += 1
    }

    //rww - Horrible, terrible, awful hack.
    //We don't send your client entity from the server,
    //so it isn't added into the solid list from the snapshot,
    //and in addition, it has no solid data. So we will force
    //adding it in based on a hardcoded player bbox size.
    //This will cause issues if the player box size is ever
    //changed..
    if cg_numSolidEntities < MAX_ENTITIES_IN_SNAPSHOT {
        var playerMins = vec3_t(-15, -15, Float(DEFAULT_MINS_2))
        var playerMaxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))
        var i: Int32
        var j: Int32
        var k: Int32

        i = Int32(playerMaxs[0])
        if i < 1 {
            i = 1
        }
        if i > 255 {
            i = 255
        }

        // z is not symetric
        j = Int32((-playerMins[2]))
        if j < 1 {
            j = 1
        }
        if j > 255 {
            j = 255
        }

        // and z playerMaxs can be negative...
        k = Int32((playerMaxs[2] + 32))
        if k < 1 {
            k = 1
        }
        if k > 255 {
            k = 255
        }

        cg_solidEntities[cg_numSolidEntities] = cg_entities[cg.predictedPlayerState.clientNum]
        cg_solidEntities[cg_numSolidEntities]!.currentState.solid = (k << 16) | (j << 8) | i

        cg_numSolidEntities += 1
    }

    dsquared = Float(5000 + 500)
    dsquared *= dsquared

    i = 0
    while i < cg_numpermanents {
        cent = cg_permanents[i]
        difference = cent!.lerpOrigin - snap!.ps.origin
        if cent!.currentState.eType == ET_TERRAIN || ((difference[0] * difference[0]) + (difference[1] * difference[1]) + (difference[2] * difference[2])) <= dsquared {
            cent!.currentValid = true
            if cent!.nextState.solid != 0 {
                cg_solidEntities[cg_numSolidEntities] = cent
                cg_numSolidEntities += 1
            }
        } else {
            cent!.currentValid = false
        }
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_predict.c:143
private func CG_VehicleClipCheck(_ ignored: Centity, _ trace: JKAMP.Trace) -> Bool {
    if trace.entityNum < 0 || trace.entityNum >= ENTITYNUM_WORLD {
        //it's alright then
        return true
    }

    if ignored.currentState.eType != ET_PLAYER && ignored.currentState.eType != ET_NPC {
        //can't possibly be valid then
        return true
    }

    if ignored.currentState.m_iVehicleNum != 0 {
        //see if the ignore ent is a vehicle/rider - if so, see if the ent we supposedly hit is a vehicle/rider.
        //if they belong to each other, we don't want to collide them.
        let otherguy: Centity? = cg_entities[trace.entityNum]

        if otherguy!.currentState.eType != ET_PLAYER && otherguy!.currentState.eType != ET_NPC {
            //can't possibly be valid then
            return true
        }

        if otherguy!.currentState.m_iVehicleNum != 0 {
            //alright, both of these are either a vehicle or a player who is on a vehicle
            let index: Int32

            if ignored.currentState.eType == ET_PLAYER || (ignored.currentState.eType == ET_NPC && ignored.currentState.NPC_class != CLASS_VEHICLE) {
                //must be a player or NPC riding a vehicle
                index = ignored.currentState.m_iVehicleNum
            } else {
                //a vehicle
                index = ignored.currentState.m_iVehicleNum - 1
            }

            if index == otherguy!.currentState.number {
                //this means we're riding or being ridden by this guy, so don't collide
                return false
            } else {
                //see if I'm hitting one of my own passengers
                if otherguy!.currentState.eType == ET_PLAYER || (otherguy!.currentState.eType == ET_NPC && otherguy!.currentState.NPC_class != CLASS_VEHICLE) {
                    //must be a player or NPC riding a vehicle
                    if otherguy!.currentState.m_iVehicleNum == ignored.currentState.number {
                        //this means we're other guy is riding the ignored ent
                        return false
                    }
                }
            }
        }
    }

    return true
}

/// Source: oracle/codemp/cgame/cg_predict.c:216
private func CG_ClipMoveToEntities(_ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ end: JKAShared.vec3_t, _ skipNumber: Int32, _ mask: Int32, _ tr: JKAMP.Trace, _ g2Check: Bool) {
    var i: Int32 = 0
    var x: Int32 = 0
    var zd: Int32 = 0
    var zu: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = Trace.scratch { oldTrace -> Bool in
            var ent: EntityState?
            var cmodel: clipHandle_t = 0
            var bmins = vec3_t()
            var bmaxs = vec3_t()
            var origin = vec3_t()
            var angles = vec3_t()
            var cent: Centity?
            var ignored: Centity? = nil

            if skipNumber != -1 && skipNumber != ENTITYNUM_NONE {
                ignored = cg_entities[skipNumber]
            }

            i = 0
            while i < cg_numSolidEntities {
                cent = cg_solidEntities[i]
                ent = cent!.currentState

                if ent!.number == skipNumber {
                    i += 1
                    continue
                }

                if ent!.number > MAX_CLIENTS && (ent!.genericenemyindex - MAX_GENTITIES == cg.predictedPlayerState.clientNum || ent!.genericenemyindex - MAX_GENTITIES == cg.predictedVehicleState.clientNum) {
                    //rww - method of keeping objects from colliding in client-prediction (in case of ownership)
                    i += 1
                    continue
                }

                if ent!.solid == SOLID_BMODEL {
                    // special value for bmodel
                    cmodel = trap_CM_InlineModel(ent!.modelindex)
                    angles = cent!.lerpAngles
                    BG_EvaluateTrajectory(cent!.currentState.pos, cg.physicsTime, &origin)
                } else {
                    // encoded bbox
                    x = (ent!.solid & 255)
                    zd = ((ent!.solid >> 8) & 255)
                    zu = ((ent!.solid >> 16) & 255) - 32

                    bmins[1] = Float(-x)
                    bmins[0] = bmins[1]
                    bmaxs[1] = Float(x)
                    bmaxs[0] = bmaxs[1]
                    bmins[2] = Float(-zd)
                    bmaxs[2] = Float(zu)

                    if ent!.eType == ET_NPC && ent!.NPC_class == CLASS_VEHICLE && cent!.m_pVehicle != nil {
                        //try to dynamically adjust his bbox dynamically, if possible
                        // Port-note: A pointer local `float * old` with no view.
                        // Raven wrote: float *old = cent->m_pVehicle->m_vOrientation;
                        portMissing("CG_ClipMoveToEntities", source: "oracle/codemp/cgame/cg_predict.c:216")
                        // Port-note: Raven stores a pointer into the `float *` field with `cent->m_pVehicle->m_vOrientation = &cent->lerpAngles[0]`, and rule 11 keeps a pointer out of a logic target.
                        // Raven wrote: cent->m_pVehicle->m_vOrientation = &cent->lerpAngles[0]
                        portMissing("CG_ClipMoveToEntities", source: "oracle/codemp/cgame/cg_predict.c:216")
                        BG_VehicleAdjustBBoxForOrientation(cent!.m_pVehicle!, &cent!.lerpOrigin, &bmins, &bmaxs, cent!.currentState.number, MASK_PLAYERSOLID, nil)
                        // Port-note: Raven stores a pointer into the `float *` field with `cent->m_pVehicle->m_vOrientation = old`, and rule 11 keeps a pointer out of a logic target.
                        // Raven wrote: cent->m_pVehicle->m_vOrientation = old
                        portMissing("CG_ClipMoveToEntities", source: "oracle/codemp/cgame/cg_predict.c:216")
                    }

                    cmodel = trap_CM_TempBoxModel(bmins, bmaxs)
                    angles = vec3_origin

                    origin = cent!.lerpOrigin
                }


                trap_CM_TransformedBoxTrace(trace, start, end, mins, maxs, cmodel, mask, origin, angles)
                trace.entityNum = Double(trace.fraction) != 1.0 ? ent!.number : ENTITYNUM_NONE

                if g2Check || (ignored != nil && ignored!.currentState.m_iVehicleNum != 0) {
                    //keep these older variables around for a bit, incase we need to replace them in the Ghoul2 Collision check
                    //or in the vehicle owner trace check
                    oldTrace.copy(from: tr)
                }

                if trace.allsolid != 0 || trace.fraction < tr.fraction {
                    trace.entityNum = ent!.number
                    // Port-note: A pointer dereference the draft cannot place.
                    // Raven wrote: *tr = trace
                    portMissing("CG_ClipMoveToEntities", source: "oracle/codemp/cgame/cg_predict.c:216")
                } else if trace.startsolid != 0 {
                    tr.startsolid = 1

                    //rww 12-02-02
                    trace.entityNum = ent!.number
                    tr.entityNum = trace.entityNum
                }
                if tr.allsolid != 0 {
                    if ignored != nil && ignored!.currentState.m_iVehicleNum != 0 {
                        trace.entityNum = ent!.number
                        if CG_VehicleClipCheck(ignored!, trace) {
                            //this isn't our vehicle, we're really stuck
                            return true
                        } else {
                            //it's alright, keep going
                            trace.copy(from: oldTrace)
                            // Port-note: A pointer dereference the draft cannot place.
                            // Raven wrote: *tr = trace
                            portMissing("CG_ClipMoveToEntities", source: "oracle/codemp/cgame/cg_predict.c:216")
                        }
                    } else {
                        return true
                    }
                }

                if g2Check {
                    if trace.entityNum == ent!.number && cent!.ghoul2 != nil {
                        CG_G2TraceCollide(trace, mins, maxs, start, end)

                        if trace.entityNum == ENTITYNUM_NONE {
                            //g2 trace failed, so put it back where it was.
                            trace.copy(from: oldTrace)
                            // Port-note: A pointer dereference the draft cannot place.
                            // Raven wrote: *tr = trace
                            portMissing("CG_ClipMoveToEntities", source: "oracle/codemp/cgame/cg_predict.c:216")
                        }
                    }
                }

                if ignored != nil && ignored!.currentState.m_iVehicleNum != 0 {
                    //see if this is the vehicle we hit
                    let hit: Centity? = cg_entities[trace.entityNum]
                    if !CG_VehicleClipCheck(ignored!, trace) {
                        //looks like it
                        trace.copy(from: oldTrace)
                        // Port-note: A pointer dereference the draft cannot place.
                        // Raven wrote: *tr = trace
                        portMissing("CG_ClipMoveToEntities", source: "oracle/codemp/cgame/cg_predict.c:216")
                    } else if hit!.currentState.eType == ET_MISSILE && hit!.currentState.owner == ignored!.currentState.number {
                        //hack, don't hit own missiles
                        trace.copy(from: oldTrace)
                        // Port-note: A pointer dereference the draft cannot place.
                        // Raven wrote: *tr = trace
                        portMissing("CG_ClipMoveToEntities", source: "oracle/codemp/cgame/cg_predict.c:216")
                    }
                }
                i += 1
            }
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
================
CG_Trace
================
```
*/
/// Source: oracle/codemp/cgame/cg_predict.c:359
func CG_Trace(_ result: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ end: JKAShared.vec3_t, _ skipNumber: Int32, _ mask: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { t in

        trap_CM_BoxTrace(t, start, end, mins, maxs, 0, mask)
        t.entityNum = Double(t.fraction) != 1.0 ? ENTITYNUM_WORLD : ENTITYNUM_NONE
        // check all other solid models
        CG_ClipMoveToEntities(start, mins, maxs, end, skipNumber, mask, t, false)

        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: *result = t
        portMissing("CG_Trace", source: "oracle/codemp/cgame/cg_predict.c:359")
    }
}

/**
```
================
CG_G2Trace
================
```
*/
/// Source: oracle/codemp/cgame/cg_predict.c:376
func CG_G2Trace(_ result: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ end: JKAShared.vec3_t, _ skipNumber: Int32, _ mask: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { t in

        trap_CM_BoxTrace(t, start, end, mins, maxs, 0, mask)
        t.entityNum = Double(t.fraction) != 1.0 ? ENTITYNUM_WORLD : ENTITYNUM_NONE
        // check all other solid models
        CG_ClipMoveToEntities(start, mins, maxs, end, skipNumber, mask, t, true)

        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: *result = t
        portMissing("CG_G2Trace", source: "oracle/codemp/cgame/cg_predict.c:376")
    }
}

/**
```
================
CG_PointContents
================
```
*/
/// Source: oracle/codemp/cgame/cg_predict.c:393
func CG_PointContents(_ point: JKAShared.vec3_t, _ passEntityNum: Int32) -> Int32 {
    var i: Int32
    var ent: EntityState?
    var cent: Centity?
    var cmodel: clipHandle_t
    var contents: Int32

    contents = trap_CM_PointContents(point, 0)

    i = 0
    while i < cg_numSolidEntities {
        cent = cg_solidEntities[i]

        ent = cent!.currentState

        if ent!.number == passEntityNum {
            i += 1
            continue
        }

        if ent!.solid != SOLID_BMODEL {
            // special value for bmodel
            i += 1
            continue
        }

        cmodel = trap_CM_InlineModel(ent!.modelindex)
        if cmodel == 0 {
            i += 1
            continue
        }

        contents |= trap_CM_TransformedPointContents(point, cmodel, ent!.origin, ent!.angles)
        i += 1
    }

    return contents
}

/**
```
========================
CG_InterpolatePlayerState

Generates cg.predictedPlayerState by interpolating between
cg.snap->player_state and cg.nextFrame->player_state
========================
```
*/
/// Source: oracle/codemp/cgame/cg_predict.c:435
private func CG_InterpolatePlayerState(_ grabAngles: Bool) {
    var f: Float = 0
    var i: Int32 = 0
    var out: PlayerState?
    var prev: Snapshot?
    var next: Snapshot?

    out = cg.predictedPlayerState
    prev = cg.snap
    next = cg.nextSnap

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: *out = cg.snap->ps
    portMissing("CG_InterpolatePlayerState", source: "oracle/codemp/cgame/cg_predict.c:435")

    // if we are still allowing local input, short circuit the view angles
    if grabAngles {
        // Raven's record lives to the end of his block, so the block is the closure.
        Usercmd.scratch { cmd in
            var cmdNum: Int32 = 0

            cmdNum = trap_GetCurrentCmdNumber()
            trap_GetUserCmd(cmdNum, cmd)

            PM_UpdateViewAngles(out!, cmd)
        }
    }

    // if the next frame is a teleport, we can't lerp to it
    if cg.nextFrameTeleport {
        return
    }

    if next == nil || next!.serverTime <= prev!.serverTime {
        return
    }

    f = Float((cg.time - prev!.serverTime)) / (next!.serverTime - prev!.serverTime)

    i = next!.ps.bobCycle
    if i < prev!.ps.bobCycle {
        i += 256 // handle wraparound
    }
    out!.bobCycle = Int32(prev!.ps.bobCycle + f * (i - prev!.ps.bobCycle))

    i = 0
    while i < 3 {
        out!.origin[i] = prev!.ps.origin[i] + f * (next!.ps.origin[i] - prev!.ps.origin[i])
        if !grabAngles {
            out!.viewangles[i] = LerpAngle(prev!.ps.viewangles[i], next!.ps.viewangles[i], f)
        }
        out!.velocity[i] = prev!.ps.velocity[i] + f * (next!.ps.velocity[i] - prev!.ps.velocity[i])
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_predict.c:487
private func CG_InterpolateVehiclePlayerState(_ grabAngles: Bool) {
    var f: Float = 0
    var i: Int32 = 0
    var out: PlayerState?
    var prev: Snapshot?
    var next: Snapshot?

    out = cg.predictedVehicleState
    prev = cg.snap
    next = cg.nextSnap

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: *out = cg.snap->vps
    portMissing("CG_InterpolateVehiclePlayerState", source: "oracle/codemp/cgame/cg_predict.c:487")

    // if we are still allowing local input, short circuit the view angles
    if grabAngles {
        // Raven's record lives to the end of his block, so the block is the closure.
        Usercmd.scratch { cmd in
            var cmdNum: Int32 = 0

            cmdNum = trap_GetCurrentCmdNumber()
            trap_GetUserCmd(cmdNum, cmd)

            PM_UpdateViewAngles(out!, cmd)
        }
    }

    // if the next frame is a teleport, we can't lerp to it
    if cg.nextFrameTeleport {
        return
    }

    if next == nil || next!.serverTime <= prev!.serverTime {
        return
    }

    f = Float((cg.time - prev!.serverTime)) / (next!.serverTime - prev!.serverTime)

    i = next!.vps.bobCycle
    if i < prev!.vps.bobCycle {
        i += 256 // handle wraparound
    }
    out!.bobCycle = Int32(prev!.vps.bobCycle + f * (i - prev!.vps.bobCycle))

    i = 0
    while i < 3 {
        out!.origin[i] = prev!.vps.origin[i] + f * (next!.vps.origin[i] - prev!.vps.origin[i])
        if !grabAngles {
            out!.viewangles[i] = LerpAngle(prev!.vps.viewangles[i], next!.vps.viewangles[i], f)
        }
        out!.velocity[i] = prev!.vps.velocity[i] + f * (next!.vps.velocity[i] - prev!.vps.velocity[i])
        i += 1
    }
}

/**
```
===================
CG_TouchItem
===================
```
*/
/// Source: oracle/codemp/cgame/cg_predict.c:544
private func CG_TouchItem(_ cent: Centity) {
    var item: Gitem?

    if cg_predictItems.integer == 0 {
        return
    }
    if !BG_PlayerTouchesItem(cg.predictedPlayerState, cent.currentState, cg.time) {
        return
    }

    if cent.currentState.brokenLimbs != 0 {
        //dropped item
        return
    }

    if (cent.currentState.eFlags & EF_ITEMPLACEHOLDER) != 0 {
        return
    }

    if (cent.currentState.eFlags & EF_NODRAW) != 0 {
        return
    }

    // never pick an item up twice in a prediction
    if cent.miscTime == cg.time {
        return
    }

    if !BG_CanItemBeGrabbed(cgs.gametype, cent.currentState, cg.predictedPlayerState) {
        return // can't hold it
    }

    item = bg_itemlist[cent.currentState.modelindex]

    //Currently there is no reliable way of knowing if the client has touched a certain item before another if they are next to each other, or rather
    //if the server has touched them in the same order. This results often in grabbing an item in the prediction and the server giving you the other
    //item. So for now prediction of armor, health, and ammo is disabled.
    /*
    if (item->giType == IT_ARMOR)
    { //rww - this will be stomped next update, but it's set so that we don't try to pick up two shields in one prediction and have the server cancel one
    //	cg.predictedPlayerState.stats[STAT_ARMOR] += item->quantity;

    //FIXME: This can't be predicted properly at the moment
    return;
    }

    if (item->giType == IT_HEALTH)
    { //same as above, for health
    //	cg.predictedPlayerState.stats[STAT_HEALTH] += item->quantity;

    //FIXME: This can't be predicted properly at the moment
    return;
    }

    if (item->giType == IT_AMMO)
    { //same as above, for ammo
    //	cg.predictedPlayerState.ammo[item->giTag] += item->quantity;

    //FIXME: This can't be predicted properly at the moment
    return;
    }

    if (item->giType == IT_HOLDABLE)
    { //same as above, for holdables
    //	cg.predictedPlayerState.stats[STAT_HOLDABLE_ITEMS] |= (1 << item->giTag);
    }
    */
    // Special case for flags.
    // We don't predict touching our own flag
    if cgs.gametype == GT_CTF || cgs.gametype == GT_CTY {
        if cg.predictedPlayerState.persistant[PERS_TEAM] == TEAM_RED && item!.giTag == PW_REDFLAG {
            return
        }
        if cg.predictedPlayerState.persistant[PERS_TEAM] == TEAM_BLUE && item!.giTag == PW_BLUEFLAG {
            return
        }
    }

    if item!.giType == IT_POWERUP && (item!.giTag == PW_FORCE_ENLIGHTENED_LIGHT || item!.giTag == PW_FORCE_ENLIGHTENED_DARK) {
        if item!.giTag == PW_FORCE_ENLIGHTENED_LIGHT {
            if cg.predictedPlayerState.fd.forceSide != FORCE_LIGHTSIDE {
                return
            }
        } else {
            if cg.predictedPlayerState.fd.forceSide != FORCE_DARKSIDE {
                return
            }
        }
    }


    // grab it
    BG_AddPredictableEventToPlayerstate(EV_ITEM_PICKUP, cent.currentState.number, cg.predictedPlayerState)

    // remove it from the frame so it won't be drawn
    cent.currentState.eFlags |= EF_NODRAW

    // don't touch it again this prediction
    cent.miscTime = cg.time

    // if its a weapon, give them some predicted ammo so the autoswitch will work
    if item!.giType == IT_WEAPON {
        cg.predictedPlayerState.stats[STAT_WEAPONS] |= 1 << item!.giTag
        if cg.predictedPlayerState.ammo[item!.giTag] == 0 {
            cg.predictedPlayerState.ammo[item!.giTag] = 1
        }
    }
}

/**
```
=========================
CG_TouchTriggerPrediction

Predict push triggers and items
=========================
```
*/
/// Source: oracle/codemp/cgame/cg_predict.c:670
private func CG_TouchTriggerPrediction() {
    var i: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var ent: EntityState?
        var cmodel: clipHandle_t = 0
        var cent: Centity?
        var spectator: Bool = false

        // dead clients don't activate triggers
        if cg.predictedPlayerState.stats[STAT_HEALTH] <= 0 {
            return true
        }

        spectator = (cg.predictedPlayerState.pm_type == PM_SPECTATOR)

        if cg.predictedPlayerState.pm_type != PM_NORMAL && cg.predictedPlayerState.pm_type != PM_JETPACK && cg.predictedPlayerState.pm_type != PM_FLOAT && !spectator {
            return true
        }

        i = 0
        while i < cg_numTriggerEntities {
            cent = cg_triggerEntities[i]
            ent = cent!.currentState

            if ent!.eType == ET_ITEM && !spectator {
                CG_TouchItem(cent!)
                i += 1
                continue
            }

            if ent!.solid != SOLID_BMODEL {
                i += 1
                continue
            }

            cmodel = trap_CM_InlineModel(ent!.modelindex)
            if cmodel == 0 {
                i += 1
                continue
            }

            trap_CM_BoxTrace(trace, cg.predictedPlayerState.origin, cg.predictedPlayerState.origin, cg_pmove.mins, cg_pmove.maxs, cmodel, -1)

            if trace.startsolid == 0 {
                i += 1
                continue
            }

            if ent!.eType == ET_TELEPORT_TRIGGER {
                cg.hyperspace = true
            } else if ent!.eType == ET_PUSH_TRIGGER {
                BG_TouchJumpPad(cg.predictedPlayerState, ent!)
            }
            i += 1
        }

        // if we didn't touch a jump pad this pmove frame
        if cg.predictedPlayerState.jumppad_frame != cg.predictedPlayerState.pmove_framecount {
            cg.predictedPlayerState.jumppad_frame = 0
            cg.predictedPlayerState.jumppad_ent = 0
        }
        return false
    }
    if earlyOut {
        return
    }
}

//Assign all the entity playerstate pointers to the corresponding one
//so that we can access playerstate stuff in bg code (and then translate
//it back to entitystate data)
/// Source: oracle/codemp/cgame/cg_predict.c:884
func CG_PmoveClientPointerUpdate() {
    var i: Int32

    // Port-note: Raven's `memset(&cgSendPSPool[0], 0, sizeof(cgSendPSPool))` runs over a size that is not the record's own, and a view's clear() takes the whole record.
    // Raven wrote: memset(&cgSendPSPool[0], 0, sizeof(cgSendPSPool))
    portMissing("CG_PmoveClientPointerUpdate", source: "oracle/codemp/cgame/cg_predict.c:884")

    i = 0
    while i < MAX_GENTITIES {
        cgSendPS[i] = cgSendPSPool[i]

        // These will be invalid at this point on Xbox
        cg_entities[i].playerState = cgSendPS[i]
        i += 1
    }


    // Last .next is already NULL from memset above

    //Set up bg entity data
    // Port-note: The draft of this statement did not compile, and the compiler wrote "initializer 'init(_:)' requires that 'Slots<Centity>' conform to 'HandleView'".
    // Raven wrote: cg_pmove.baseEnt = (bgEntity_t *)cg_entities
    portMissing("CG_PmoveClientPointerUpdate", source: "oracle/codemp/cgame/cg_predict.c:884")
    cg_pmove.entSize = Int32(Centity.byteCount)

    cg_pmove.ghoul2 = nil
}

//check if local client is on an eweb
/// Source: oracle/codemp/cgame/cg_predict.c:920
func CG_UsingEWeb() -> Bool {
    if cg.predictedPlayerState.weapon == WP_EMPLACED_GUN && cg.predictedPlayerState.emplacedIndex != 0 && cg_entities[cg.predictedPlayerState.emplacedIndex].currentState.weapon == WP_NONE {
        return true
    }

    return false
}

/// Source: oracle/codemp/cgame/cg_predict.c:963
func CG_PredictPlayerState() {
    var cmdNum: Int32 = 0
    var current: Int32 = 0
    var i: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = PlayerState.scratch { oldPlayerState -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = PlayerState.scratch { oldVehicleState -> Bool in
            var moved: Bool = false
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives true where Raven returns from the function.
            let earlyOut3 = Usercmd.scratch { oldestCmd -> Bool in
                // Raven's record lives to the end of his block, so the block is the closure.
                // The closure gives true where Raven returns from the function.
                let earlyOut4 = Usercmd.scratch { latestCmd -> Bool in
                    var pEnt: Centity?
                    var ci: ClientInfo?

                    revertES: do {
                        cg.hyperspace = false // will be set if touching a trigger_teleport

                        // if this is the first frame we must guarantee
                        // predictedPlayerState is valid even if there is some
                        // other error condition
                        if !cg.validPPS {
                            cg.validPPS = true
                            cg.predictedPlayerState.copy(from: cg.snap!.ps)
                            if CG_Piloting(cg.snap!.ps.m_iVehicleNum) {
                                cg.predictedVehicleState.copy(from: cg.snap!.vps)
                            }
                        }

                        // demo playback just copies the moves
                        if cg.demoPlayback || (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
                            CG_InterpolatePlayerState(false)
                            if CG_Piloting(cg.predictedPlayerState.m_iVehicleNum) {
                                CG_InterpolateVehiclePlayerState(false)
                            }
                            return true
                        }

                        // non-predicting local movement will grab the latest angles
                        if cg_nopredict.integer != 0 || cg_synchronousClients.integer != 0 || CG_UsingEWeb() {
                            CG_InterpolatePlayerState(true)
                            if CG_Piloting(cg.predictedPlayerState.m_iVehicleNum) {
                                CG_InterpolateVehiclePlayerState(true)
                            }
                            return true
                        }

                        // prepare for pmove
                        cg_pmove.ps = cg.predictedPlayerState
                        cg_pmove.trace = PmoveThunks.CG_Trace
                        cg_pmove.pointcontents = PmoveThunks.CG_PointContents

                        pEnt = cg_entities[cg.predictedPlayerState.clientNum]
                        //rww - bgghoul2
                        if cg_pmove.ghoul2 != pEnt!.ghoul2 {
                            if cg.snap != nil && pEnt!.ghoul2 != nil && !((cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0) && cg.snap!.ps.persistant[PERS_TEAM] != TEAM_SPECTATOR {
                                cg_pmove.ghoul2 = pEnt!.ghoul2
                                cg_pmove.g2Bolts_LFoot = trap_G2API_AddBolt(pEnt!.ghoul2, 0, "*l_leg_foot")
                                cg_pmove.g2Bolts_RFoot = trap_G2API_AddBolt(pEnt!.ghoul2, 0, "*r_leg_foot")
                            } else {
                                cg_pmove.ghoul2 = nil
                            }
                        }

                        ci = cgs.clientinfo[cg.predictedPlayerState.clientNum]

                        //I'll just do this every frame in case the scale changes in realtime (don't need to update the g2 inst for that)
                        cg_pmove.modelScale = pEnt!.modelScale
                        //rww end bgghoul2

                        if cg_pmove.ps.pm_type == PM_DEAD {
                            cg_pmove.tracemask = MASK_PLAYERSOLID & ~CONTENTS_BODY
                        } else {
                            cg_pmove.tracemask = MASK_PLAYERSOLID
                        }
                        if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_SPECTATOR {
                            cg_pmove.tracemask &= ~CONTENTS_BODY // spectators can fly through bodies
                        }
                        cg_pmove.noFootsteps = (cgs.dmflags & DF_NO_FOOTSTEPS) > 0

                        // save the state before the pmove so we can detect transitions
                        oldPlayerState.copy(from: cg.predictedPlayerState)
                        if CG_Piloting(cg.predictedPlayerState.m_iVehicleNum) {
                            oldVehicleState.copy(from: cg.predictedVehicleState)
                        }

                        current = trap_GetCurrentCmdNumber()

                        // if we don't have the commands right after the snapshot, we
                        // can't accurately predict a current position, so just freeze at
                        // the last good position we had
                        cmdNum = current - CMD_BACKUP + 1
                        trap_GetUserCmd(cmdNum, oldestCmd)
                        if oldestCmd.serverTime > cg.snap!.ps.commandTime && oldestCmd.serverTime < cg.time {
                            // special check for map_restart
                            if cg_showmiss.integer != 0 {
                                CG_Printf("exceeded PACKET_BACKUP on commands\n")
                            }
                            return true
                        }

                        // get the latest command so we can know which commands are from previous map_restarts
                        trap_GetUserCmd(current, latestCmd)

                        // get the most recent information we have, even if
                        // the server time is beyond our current cg.time,
                        // because predicted player positions are going to
                        // be ahead of everything else anyway
                        if cg.nextSnap != nil && !cg.nextFrameTeleport && !cg.thisFrameTeleport {
                            cg.nextSnap!.ps.slopeRecalcTime = cg.predictedPlayerState.slopeRecalcTime //this is the only value we want to maintain seperately on server/client
                            cg.predictedPlayerState.copy(from: cg.nextSnap!.ps)
                            if CG_Piloting(cg.nextSnap!.ps.m_iVehicleNum) {
                                cg.predictedVehicleState.copy(from: cg.nextSnap!.vps)
                            }
                            cg.physicsTime = cg.nextSnap!.serverTime
                        } else {
                            cg.snap!.ps.slopeRecalcTime = cg.predictedPlayerState.slopeRecalcTime //this is the only value we want to maintain seperately on server/client
                            cg.predictedPlayerState.copy(from: cg.snap!.ps)
                            if CG_Piloting(cg.snap!.ps.m_iVehicleNum) {
                                cg.predictedVehicleState.copy(from: cg.snap!.vps)
                            }
                            cg.physicsTime = cg.snap!.serverTime
                        }

                        if pmove_msec.integer < 8 {
                            trap_Cvar_Set("pmove_msec", "8")
                        } else if pmove_msec.integer > 33 {
                            trap_Cvar_Set("pmove_msec", "33")
                        }

                        cg_pmove.pmove_fixed = pmove_fixed.integer // | cg_pmove_fixed.integer;
                        cg_pmove.pmove_msec = pmove_msec.integer

                        i = 0
                        while i < MAX_GENTITIES {
                            //Written this way for optimal speed, even though it doesn't look pretty.
                            //(we don't want to spend the time assigning pointers as it does take
                            //a small precious fraction of time and adds up in the loop.. so says
                            //the precision timer!)

                            if cg_entities[i].currentState.eType == ET_PLAYER || cg_entities[i].currentState.eType == ET_NPC {
                                // Need a new playerState_t on Xbox
                                cgSendPS[i]!.origin = cg_entities[i].currentState.pos.trBase
                                cgSendPS[i]!.velocity = cg_entities[i].currentState.pos.trDelta
                                cgSendPS[i]!.saberLockFrame = cg_entities[i].currentState.forceFrame
                                cgSendPS[i]!.legsAnim = cg_entities[i].currentState.legsAnim
                                cgSendPS[i]!.torsoAnim = cg_entities[i].currentState.torsoAnim
                                cgSendPS[i]!.legsFlip = cg_entities[i].currentState.legsFlip
                                cgSendPS[i]!.torsoFlip = cg_entities[i].currentState.torsoFlip
                                cgSendPS[i]!.clientNum = cg_entities[i].currentState.clientNum
                                cgSendPS[i]!.saberMove = cg_entities[i].currentState.saberMove
                            }
                            i += 1
                        }

                        if CG_Piloting(cg.predictedPlayerState.m_iVehicleNum) {
                            cg_entities[cg.predictedPlayerState.clientNum].playerState = cg.predictedPlayerState
                            cg_entities[cg.predictedPlayerState.m_iVehicleNum].playerState = cg.predictedVehicleState

                            //use the player command time, because we are running with the player cmds (this is even the case
                            //on the server)
                            cg.predictedVehicleState.commandTime = cg.predictedPlayerState.commandTime
                        }

                        // run cmds
                        moved = false
                        cmdNum = current - CMD_BACKUP + 1
                        while cmdNum <= current {
                            // get the command
                            trap_GetUserCmd(cmdNum, cg_pmove.cmd)

                            if cg_pmove.pmove_fixed != 0 {
                                PM_UpdateViewAngles(cg_pmove.ps, cg_pmove.cmd)
                            }

                            // don't do anything if the time is before the snapshot player time
                            if cg_pmove.cmd.serverTime <= cg.predictedPlayerState.commandTime {
                                cmdNum += 1
                                continue
                            }

                            // don't do anything if the command was from a previous map_restart
                            if cg_pmove.cmd.serverTime > latestCmd.serverTime {
                                cmdNum += 1
                                continue
                            }

                            // check for a prediction error from last frame
                            // on a lan, this will often be the exact value
                            // from the snapshot, but on a wan we will have
                            // to predict several commands to get to the point
                            // we want to compare
                            if CG_Piloting(oldPlayerState.m_iVehicleNum) && cg.predictedVehicleState.commandTime == oldVehicleState.commandTime {
                                var delta = vec3_t()
                                var len: Float = 0

                                if cg.thisFrameTeleport {
                                    // a teleport will not cause an error decay
                                    cg.predictedError = vec3_t()
                                    if cg_showVehMiss.integer != 0 {
                                        CG_Printf("VEH PredictionTeleport\n")
                                    }
                                    cg.thisFrameTeleport = false
                                } else {
                                    var adjusted = vec3_t()
                                    CG_AdjustPositionForMover(cg.predictedVehicleState.origin, cg.predictedVehicleState.groundEntityNum, cg.physicsTime, cg.oldTime, &adjusted)

                                    if cg_showVehMiss.integer != 0 {
                                        if VectorCompare(oldVehicleState.origin, adjusted) == 0 {
                                            CG_Printf("VEH prediction error\n")
                                        }
                                    }
                                    delta = oldVehicleState.origin - adjusted
                                    len = VectorLength(delta)
                                    if Double(len) > 0.1 {
                                        if cg_showVehMiss.integer != 0 {
                                            CG_Printf("VEH Prediction miss: %f\n", len)
                                        }
                                        if cg_errorDecay.integer != 0 {
                                            var t: Int32 = 0
                                            var f: Float = 0

                                            t = cg.time - cg.predictedErrorTime
                                            f = (cg_errorDecay.value - t) / cg_errorDecay.value
                                            if f < 0 {
                                                f = 0
                                            }
                                            if f > 0 && cg_showVehMiss.integer != 0 {
                                                CG_Printf("VEH Double prediction decay: %f\n", f)
                                            }
                                            cg.predictedError = cg.predictedError * f
                                        } else {
                                            cg.predictedError = vec3_t()
                                        }
                                        cg.predictedError = delta + cg.predictedError
                                        cg.predictedErrorTime = cg.oldTime
                                    }
                                    //
                                    if cg_showVehMiss.integer != 0 {
                                        if VectorCompare(oldVehicleState.vehOrientation, cg.predictedVehicleState.vehOrientation) == 0 {
                                            CG_Printf("VEH orient prediction error\n")
                                            CG_Printf("VEH pitch prediction miss: %f\n", AngleSubtract(oldVehicleState.vehOrientation[0], cg.predictedVehicleState.vehOrientation[0]))
                                            CG_Printf("VEH yaw prediction miss: %f\n", AngleSubtract(oldVehicleState.vehOrientation[1], cg.predictedVehicleState.vehOrientation[1]))
                                            CG_Printf("VEH roll prediction miss: %f\n", AngleSubtract(oldVehicleState.vehOrientation[2], cg.predictedVehicleState.vehOrientation[2]))
                                        }
                                    }
                                }
                            } else if oldPlayerState.m_iVehicleNum == 0 && cg.predictedPlayerState.commandTime == oldPlayerState.commandTime {
                                var delta = vec3_t()
                                var len: Float = 0

                                if cg.thisFrameTeleport {
                                    // a teleport will not cause an error decay
                                    cg.predictedError = vec3_t()
                                    if cg_showmiss.integer != 0 {
                                        CG_Printf("PredictionTeleport\n")
                                    }
                                    cg.thisFrameTeleport = false
                                } else {
                                    var adjusted = vec3_t()
                                    CG_AdjustPositionForMover(cg.predictedPlayerState.origin, cg.predictedPlayerState.groundEntityNum, cg.physicsTime, cg.oldTime, &adjusted)

                                    if cg_showmiss.integer != 0 {
                                        if VectorCompare(oldPlayerState.origin, adjusted) == 0 {
                                            CG_Printf("prediction error\n")
                                        }
                                    }
                                    delta = oldPlayerState.origin - adjusted
                                    len = VectorLength(delta)
                                    if Double(len) > 0.1 {
                                        if cg_showmiss.integer != 0 {
                                            CG_Printf("Prediction miss: %f\n", len)
                                        }
                                        if cg_errorDecay.integer != 0 {
                                            var t: Int32 = 0
                                            var f: Float = 0

                                            t = cg.time - cg.predictedErrorTime
                                            f = (cg_errorDecay.value - t) / cg_errorDecay.value
                                            if f < 0 {
                                                f = 0
                                            }
                                            if f > 0 && cg_showmiss.integer != 0 {
                                                CG_Printf("Double prediction decay: %f\n", f)
                                            }
                                            cg.predictedError = cg.predictedError * f
                                        } else {
                                            cg.predictedError = vec3_t()
                                        }
                                        cg.predictedError = delta + cg.predictedError
                                        cg.predictedErrorTime = cg.oldTime
                                    }
                                }
                            }

                            if cg_pmove.pmove_fixed != 0 {
                                cg_pmove.cmd.serverTime = ((cg_pmove.cmd.serverTime + pmove_msec.integer - 1) / pmove_msec.integer) * pmove_msec.integer
                            }

                            cg_pmove.animationsSlots = bgAllAnims[pEnt!.localAnimIndex].animsSlots
                            cg_pmove.gametype = cgs.gametype

                            cg_pmove.debugMelee = cgs.debugMelee
                            cg_pmove.stepSlideFix = cgs.stepSlideFix
                            cg_pmove.noSpecMove = cgs.noSpecMove

                            cg_pmove.nonHumanoid = (pEnt!.localAnimIndex > 0)

                            if cg.snap != nil && cg.snap!.ps.saberLockTime > cg.time {
                                let blockOpp: Centity? = cg_entities[cg.snap!.ps.saberLockEnemy]

                                if blockOpp != nil {
                                    var lockDir = vec3_t()
                                    var lockAng = vec3_t()

                                    lockDir = blockOpp!.lerpOrigin - cg.snap!.ps.origin
                                    vectoangles(lockDir, &lockAng)

                                    cg_pmove.ps.viewangles = lockAng
                                }
                            }

                            //THIS is pretty much bad, but...
                            cg_pmove.ps.fd.saberAnimLevelBase = cg_pmove.ps.fd.saberAnimLevel
                            if cg_pmove.ps.saberHolstered == 1 {
                                if ci!.saber[0].numBlades > 0 {
                                    cg_pmove.ps.fd.saberAnimLevelBase = SS_STAFF
                                } else if !ci!.saber[1].model.isEmpty {
                                    cg_pmove.ps.fd.saberAnimLevelBase = SS_DUAL
                                }
                            }

                            Pmove(cg_pmove)

                            if CG_Piloting(cg.predictedPlayerState.m_iVehicleNum) && cg.predictedPlayerState.pm_type != PM_INTERMISSION {
                                //we're riding a vehicle, let's predict it
                                let veh: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
                                var x: Int32 = 0
                                var zd: Int32 = 0
                                var zu: Int32 = 0

                                if veh!.m_pVehicle != nil {
                                    //make sure pointer is set up to go to our predicted state
                                    // Port-note: Raven stores a pointer into the `float *` field with `veh->m_pVehicle->m_vOrientation = &cg.predictedVehicleState.vehOrientation[0]`, and rule 11 keeps a pointer out of a logic target.
                                    // Raven wrote: veh->m_pVehicle->m_vOrientation = &cg.predictedVehicleState.vehOrientation[0]
                                    portMissing("CG_PredictPlayerState", source: "oracle/codemp/cgame/cg_predict.c:963")

                                    //keep this updated based on what the playerstate says
                                    veh!.m_pVehicle!.m_iRemovedSurfaces = cg.predictedVehicleState.vehSurfaces

                                    trap_GetUserCmd(cmdNum, veh!.m_pVehicle!.m_ucmd)

                                    if (veh!.m_pVehicle!.m_ucmd.buttons & BUTTON_TALK) != 0 {
                                        //forced input if "chat bubble" is up
                                        veh!.m_pVehicle!.m_ucmd.buttons = BUTTON_TALK
                                        veh!.m_pVehicle!.m_ucmd.forwardmove = 0
                                        veh!.m_pVehicle!.m_ucmd.rightmove = 0
                                        veh!.m_pVehicle!.m_ucmd.upmove = 0
                                    }
                                    cg_vehPmove.ps = cg.predictedVehicleState
                                    cg_vehPmove.animationsSlots = bgAllAnims[veh!.localAnimIndex].animsSlots

                                    cg_vehPmove.cmd.copy(from: veh!.m_pVehicle!.m_ucmd)
                                    /*
                                    cg_vehPmove.cmd.rightmove = 0; //no vehicle can move right/left
                                    cg_vehPmove.cmd.upmove = 0; //no vehicle can move up/down
                                    */

                                    cg_vehPmove.gametype = cgs.gametype
                                    cg_vehPmove.ghoul2 = veh!.ghoul2

                                    cg_vehPmove.nonHumanoid = (veh!.localAnimIndex > 0)

                                    /*
                                    x = (veh->currentState.solid & 255);
                                    zd = (veh->currentState.solid & 255);
                                    zu = (veh->currentState.solid & 255) - 32;

                                    cg_vehPmove.mins[0] = cg_vehPmove.mins[1] = -x;
                                    cg_vehPmove.maxs[0] = cg_vehPmove.maxs[1] = x;
                                    cg_vehPmove.mins[2] = -zd;
                                    cg_vehPmove.maxs[2] = zu;
                                    */
                                    //I think this was actually wrong.. just copy-pasted from id code. Oh well.
                                    x = (veh!.currentState.solid) & 255
                                    zd = (veh!.currentState.solid >> 8) & 255
                                    zu = (veh!.currentState.solid >> 15) & 255

                                    zu -= 32 //I don't quite get the reason for this.
                                    zd = -zd

                                    //z/y must be symmetrical (blah)
                                    cg_vehPmove.mins[1] = Float(-x)
                                    cg_vehPmove.mins[0] = cg_vehPmove.mins[1]
                                    cg_vehPmove.maxs[1] = Float(x)
                                    cg_vehPmove.maxs[0] = cg_vehPmove.maxs[1]
                                    cg_vehPmove.mins[2] = Float(zd)
                                    cg_vehPmove.maxs[2] = Float(zu)

                                    cg_vehPmove.modelScale = veh!.modelScale

                                    if !cg_vehPmoveSet {
                                        //do all the one-time things
                                        cg_vehPmove.trace = PmoveThunks.CG_Trace
                                        cg_vehPmove.pointcontents = PmoveThunks.CG_PointContents
                                        cg_vehPmove.tracemask = MASK_PLAYERSOLID
                                        cg_vehPmove.debugLevel = 0
                                        cg_vehPmove.g2Bolts_LFoot = -1
                                        cg_vehPmove.g2Bolts_RFoot = -1

                                        // Port-note: The draft of this statement did not compile, and the compiler wrote "initializer 'init(_:)' requires that 'Slots<Centity>' conform to 'HandleView'".
                                        // Raven wrote: cg_vehPmove.baseEnt = (bgEntity_t *)cg_entities
                                        portMissing("CG_PredictPlayerState", source: "oracle/codemp/cgame/cg_predict.c:963")
                                        cg_vehPmove.entSize = Int32(Centity.byteCount)

                                        cg_vehPmoveSet = true
                                    }

                                    cg_vehPmove.noFootsteps = (cgs.dmflags & DF_NO_FOOTSTEPS) > 0
                                    cg_vehPmove.pmove_fixed = pmove_fixed.integer
                                    cg_vehPmove.pmove_msec = pmove_msec.integer

                                    cg_entities[cg.predictedPlayerState.clientNum].playerState = cg.predictedPlayerState
                                    veh!.playerState = cg.predictedVehicleState

                                    //update boarding value sent from server. boarding is not predicted, but no big deal
                                    veh!.m_pVehicle!.m_iBoarding = (cg.predictedVehicleState.vehBoarding ? 1 : 0)

                                    Pmove(cg_vehPmove)
                                    /*
                                    if ( !cg_paused.integer )
                                    {
                                    Com_Printf( "%d - PITCH change %4.2f\n", cg.time, AngleSubtract(veh->m_pVehicle->m_vOrientation[0],veh->m_pVehicle->m_vPrevOrientation[0]) );
                                    }
                                    */
                                    if cg_showVehBounds.integer != 0 {
                                        var NPCDEBUG_RED = vec3_t(1.0, 0.0, 0.0)
                                        var absmin = vec3_t()
                                        var absmax = vec3_t()
                                        absmin = cg_vehPmove.ps.origin + cg_vehPmove.mins
                                        absmax = cg_vehPmove.ps.origin + cg_vehPmove.maxs
                                        CG_Cube(absmin, absmax, NPCDEBUG_RED, 0.25)
                                    }
                                }
                            }

                            moved = true

                            // add push trigger movement effects
                            CG_TouchTriggerPrediction()

                            // check for predictable events that changed from previous predictions
                            //CG_CheckChangedPredictableEvents(&cg.predictedPlayerState);
                            cmdNum += 1
                        }

                        if cg_showmiss.integer > 1 {
                            CG_Printf("[%i : %i] ", cg_pmove.cmd.serverTime, cg.time)
                        }

                        if !moved {
                            if cg_showmiss.integer != 0 {
                                CG_Printf("not moved\n")
                            }
                            break revertES
                        }

                        if CG_Piloting(cg.predictedPlayerState.m_iVehicleNum) {
                            CG_AdjustPositionForMover(cg.predictedVehicleState.origin, cg.predictedVehicleState.groundEntityNum, cg.physicsTime, cg.time, &cg.predictedVehicleState.origin)
                        } else {
                            // adjust for the movement of the groundentity
                            CG_AdjustPositionForMover(cg.predictedPlayerState.origin, cg.predictedPlayerState.groundEntityNum, cg.physicsTime, cg.time, &cg.predictedPlayerState.origin)
                        }

                        if cg_showmiss.integer != 0 {
                            if cg.predictedPlayerState.eventSequence > oldPlayerState.eventSequence + MAX_PS_EVENTS {
                                CG_Printf("WARNING: dropped event\n")
                            }
                        }

                        // fire events and other transition triggered things
                        CG_TransitionPlayerState(cg.predictedPlayerState, oldPlayerState)

                        if cg_showmiss.integer != 0 {
                            if cg.eventSequence > cg.predictedPlayerState.eventSequence {
                                CG_Printf("WARNING: double event\n")
                                cg.eventSequence = cg.predictedPlayerState.eventSequence
                            }
                        }

                        if cg.predictedPlayerState.m_iVehicleNum != 0 && !CG_Piloting(cg.predictedPlayerState.m_iVehicleNum) {
                            //a passenger on this vehicle, bolt them in
                            let veh: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
                            //VectorCopy(veh->lerpAngles, cg.predictedPlayerState.viewangles);
                            cg.predictedPlayerState.origin = veh!.lerpOrigin
                        }

                    }
                    if CG_Piloting(cg.predictedPlayerState.m_iVehicleNum) {
                        let veh: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]

                        if veh!.m_pVehicle != nil {
                            //switch ptr back for this ent in case we stop riding it
                            // Port-note: Raven stores a pointer into the `float *` field with `veh->m_pVehicle->m_vOrientation = &cgSendPS[veh->currentState.number]->vehOrientation[0]`, and rule 11 keeps a pointer out of a logic target.
                            // Raven wrote: veh->m_pVehicle->m_vOrientation = &cgSendPS[veh->currentState.number]->vehOrientation[0]
                            portMissing("CG_PredictPlayerState", source: "oracle/codemp/cgame/cg_predict.c:963")
                        }

                        cg_entities[cg.predictedPlayerState.clientNum].playerState = cgSendPS[cg.predictedPlayerState.clientNum]
                        veh!.playerState = cgSendPS[veh!.currentState.number]
                    }

                    //copy some stuff back into the entstates to help actually "predict" them if applicable
                    i = 0
                    while i < MAX_GENTITIES {
                        if cg_entities[i].currentState.eType == ET_PLAYER || cg_entities[i].currentState.eType == ET_NPC {
                            cg_entities[i].currentState.torsoAnim = cgSendPS[i]!.torsoAnim
                            cg_entities[i].currentState.legsAnim = cgSendPS[i]!.legsAnim
                            cg_entities[i].currentState.forceFrame = cgSendPS[i]!.saberLockFrame
                            cg_entities[i].currentState.saberMove = cgSendPS[i]!.saberMove
                        }
                        i += 1
                    }
                    return false
                }
                if earlyOut4 {
                    return true
                }
                return false
            }
            if earlyOut3 {
                return true
            }
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// One static per function this file stores in a `Pmove` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum PmoveThunks {
    /// Source: oracle/codemp/cgame/cg_predict.c:393
    static let CG_PointContents: PmovePointcontents = { JKAMP_CGameLogic.CG_PointContents(vector(at: $0!), $1) }

    /// Source: oracle/codemp/cgame/cg_predict.c:359
    static let CG_Trace: PmoveTrace = { result, start, mins, maxs, end, skipNumber, mask in
        JKAMP_CGameLogic.CG_Trace(
            Trace(handle: result!),
            vector(at: start!),
            mins.map { vector(at: $0) },
            maxs.map { vector(at: $0) },
            vector(at: end!),
            skipNumber,
            mask
        )
    }
}
