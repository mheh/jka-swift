import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_entity.cpp:29
private let MASK_SOLID = JKAShared.CONTENTS_PLAYERCLIP

//FIXME: these might change
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:32
private let ET_GENERAL = 0 as Int32
private let ET_PLAYER = 1 as Int32
private let ET_ITEM = 2 as Int32
private let ET_MISSILE = 3 as Int32
private let ET_MOVER = 4 as Int32

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:46
public func AAS_UpdateEntity(_ entnum: Int32, _ state: BotEntitystate) -> Int32 {
    var relink: Int32
    let ent: AasEntity
    var absmins = vec3_t(), absmaxs = vec3_t()

    if aasworld.loaded == 0 {
        botimport.runPrint(PRT_MESSAGE, "AAS_UpdateEntity: not loaded\n")
        return BLERR_NOAASFILE
    } //end if

    ent = aasworld.entitiesSlots[entnum]

    ent.i.update_time = AAS_Time() - ent.i.ltime
    ent.i.type = state.type
    ent.i.flags = state.flags
    ent.i.ltime = AAS_Time()
    ent.i.lastvisorigin = ent.i.origin
    ent.i.old_origin = state.old_origin
    ent.i.solid = state.solid
    ent.i.groundent = state.groundent
    ent.i.modelindex = state.modelindex
    ent.i.modelindex2 = state.modelindex2
    ent.i.frame = state.frame
    ent.i.event = state.event
    ent.i.eventParm = state.eventParm
    ent.i.powerups = state.powerups
    ent.i.weapon = state.weapon
    ent.i.legsAnim = state.legsAnim
    ent.i.torsoAnim = state.torsoAnim
    //number of the entity
    ent.i.number = entnum
    //updated so set valid flag
    ent.i.valid = 1
    //link everything the first frame
    if aasworld.numframes == 1 { relink = 1 }
    else { relink = 0 }
    //
    if ent.i.solid == SOLID_BSP {
        //if the angles of the model changed
        if VectorCompare(state.angles, ent.i.angles) == 0 {
            ent.i.angles = state.angles
            relink = 1
        } //end if
        //get the mins and maxs of the model
        //FIXME: rotate mins and maxs
        // Raven passes NULL for the `origin` output, and the scratch local takes the write.
        var scratchOrigin = vec3_t()
        AAS_BSPModelMinsMaxsOrigin(ent.i.modelindex, ent.i.angles, &ent.i.mins, &ent.i.maxs, &scratchOrigin)
    } //end if
    else if ent.i.solid == SOLID_BBOX {
        //if the bounding box size changed
        if VectorCompare(state.mins, ent.i.mins) == 0 ||
                VectorCompare(state.maxs, ent.i.maxs) == 0 {
            ent.i.mins = state.mins
            ent.i.maxs = state.maxs
            relink = 1
        } //end if
        ent.i.angles = state.angles
    } //end if
    //if the origin changed
    if VectorCompare(state.origin, ent.i.origin) == 0 {
        ent.i.origin = state.origin
        relink = 1
    } //end if
    //if the entity should be relinked
    if relink != 0 {
        //don't link the world model
        if entnum != ENTITYNUM_WORLD {
            //absolute mins and maxs
            absmins = ent.i.mins + ent.i.origin
            absmaxs = ent.i.maxs + ent.i.origin
            //unlink the entity
            AAS_UnlinkFromAreas(ent.areas)
            //relink the entity to the AAS areas (use the larges bbox)
            ent.areas = AAS_LinkEntityClientBBox(absmins, absmaxs, entnum, PRESENCE_NORMAL)
            //unlink the entity from the BSP leaves
            AAS_UnlinkFromBSPLeaves(ent.leaves)
            //link the entity to the world BSP tree
            ent.leaves = AAS_BSPLinkEntity(absmins, absmaxs, entnum, 0)
        } //end if
    } //end if
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:154
public func AAS_EntityInfo(_ entnum: Int32, _ info: AasEntityinfo) {
    if aasworld.initialized == 0 {
        botimport.runPrint(PRT_FATAL, "AAS_EntityInfo: aasworld not initialized\n")
        info.clear()
        return
    } //end if

    if entnum < 0 || entnum >= aasworld.maxentities {
        botimport.runPrint(PRT_FATAL, "AAS_EntityInfo: entnum %d out of range\n", entnum)
        info.clear()
        return
    } //end if

    info.copy(from: aasworld.entitiesSlots[entnum].i)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:178
public func AAS_EntityOrigin(_ entnum: Int32, _ origin: inout JKAShared.vec3_t) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    if entnum < 0 || entnum >= aasworld.maxentities {
        botimport.runPrint(PRT_FATAL, "AAS_EntityOrigin: entnum %d out of range\n", entnum)
        origin = vec3_t()
        return
    } //end if

    origin = aasworld.entitiesSlots[entnum].i.origin
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:195
public func AAS_EntityModelindex(_ entnum: Int32) -> Int32 {
    if entnum < 0 || entnum >= aasworld.maxentities {
        botimport.runPrint(PRT_FATAL, "AAS_EntityModelindex: entnum %d out of range\n", entnum)
        return 0
    } //end if
    return aasworld.entitiesSlots[entnum].i.modelindex
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:210
public func AAS_EntityType(_ entnum: Int32) -> Int32 {
    if aasworld.initialized == 0 { return 0 }

    if entnum < 0 || entnum >= aasworld.maxentities {
        botimport.runPrint(PRT_FATAL, "AAS_EntityType: entnum %d out of range\n", entnum)
        return 0
    } //end if
    return aasworld.entitiesSlots[entnum].i.type
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:227
public func AAS_EntityModelNum(_ entnum: Int32) -> Int32 {
    if aasworld.initialized == 0 { return 0 }

    if entnum < 0 || entnum >= aasworld.maxentities {
        botimport.runPrint(PRT_FATAL, "AAS_EntityModelNum: entnum %d out of range\n", entnum)
        return 0
    } //end if
    return aasworld.entitiesSlots[entnum].i.modelindex
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:244
public func AAS_OriginOfMoverWithModelNum(_ modelnum: Int32, _ origin: inout JKAShared.vec3_t) -> Int32 {
    var i: Int32
    var ent: AasEntity

    i = 0
    while i < aasworld.maxentities {
        ent = aasworld.entitiesSlots[i]
        if ent.i.type == ET_MOVER {
            if ent.i.modelindex == modelnum {
                origin = ent.i.origin
                return 1
            } //end if
        } //end if
        i += 1
    } //end for
    return 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:269
public func AAS_EntitySize(_ entnum: Int32, _ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    let ent: AasEntity

    if aasworld.initialized == 0 { return }

    if entnum < 0 || entnum >= aasworld.maxentities {
        botimport.runPrint(PRT_FATAL, "AAS_EntitySize: entnum %d out of range\n", entnum)
        return
    } //end if

    ent = aasworld.entitiesSlots[entnum]
    mins = ent.i.mins
    maxs = ent.i.maxs
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:291
public func AAS_EntityBSPData(_ entnum: Int32, _ entdata: BspEntdata) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    let ent: AasEntity

    ent = aasworld.entitiesSlots[entnum]
    entdata.origin = ent.i.origin
    entdata.angles = ent.i.angles
    entdata.absmins = ent.i.origin + ent.i.mins
    entdata.absmaxs = ent.i.origin + ent.i.maxs
    entdata.solid = ent.i.solid
    entdata.modelnum = ent.i.modelindex - 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:309
public func AAS_ResetEntityLinks() {
    var i: Int32
    i = 0
    while i < aasworld.maxentities {
        aasworld.entitiesSlots[i].areas = nil
        aasworld.entitiesSlots[i].leaves = nil
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:324
public func AAS_InvalidateEntities() {
    var i: Int32
    i = 0
    while i < aasworld.maxentities {
        aasworld.entitiesSlots[i].i.valid = 0
        aasworld.entitiesSlots[i].i.number = i
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:339
public func AAS_UnlinkInvalidEntities() {
    var i: Int32
    var ent: AasEntity

    i = 0
    while i < aasworld.maxentities {
        ent = aasworld.entitiesSlots[i]
        if ent.i.valid == 0 {
            AAS_UnlinkFromAreas(ent.areas)
            ent.areas = nil
            AAS_UnlinkFromBSPLeaves(ent.leaves)
            ent.leaves = nil
        } //end for
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:362
public func AAS_NearestEntity(_ origin: JKAShared.vec3_t, _ modelindex: Int32) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var i: Int32, bestentnum: Int32
    var dist: Float, bestdist: Float
    var ent: AasEntity
    var dir = vec3_t()

    bestentnum = 0
    bestdist = 99999
    i = 0
    while i < aasworld.maxentities {
        ent = aasworld.entitiesSlots[i]
        if ent.i.modelindex != modelindex {
            i += 1
            continue
        }
        dir = ent.i.origin - origin
        if abs(dir[0]) < 40 {
            if abs(dir[1]) < 40 {
                dist = VectorLength(dir)
                if dist < bestdist {
                    bestdist = dist
                    bestentnum = i
                } //end if
            } //end if
        } //end if
        i += 1
    } //end for
    return bestentnum
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:397
public func AAS_BestReachableEntityArea(_ entnum: Int32) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    let ent: AasEntity

    ent = aasworld.entitiesSlots[entnum]
    return AAS_BestReachableLinkArea(ent.areas)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_entity.cpp:410
public func AAS_NextEntity(_ entnum: Int32) -> Int32 {
    var entnum = entnum
    if aasworld.loaded == 0 { return 0 }

    if entnum < 0 { entnum = -1 }
    while true {
        entnum += 1
        if !(entnum < aasworld.maxentities) { break }
        if aasworld.entitiesSlots[entnum].i.valid != 0 { return entnum }
    } //end while
    return 0
}
