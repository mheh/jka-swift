import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/sv_world.cpp:55
let AREA_DEPTH = 4 as Int32

/// Source: oracle/codemp/server/sv_world.cpp:56
let AREA_NODES = 64 as Int32

/// Source: oracle/codemp/server/sv_world.cpp:58
var sv_worldSectors: Slots<WorldSector> { world.storage.sv_worldSectors }

/// Source: oracle/codemp/server/sv_world.cpp:59
var sv_numworldSectors: Int32 {
    get { world.variables.sv_numworldSectors }
    set { world.variables.sv_numworldSectors = newValue }
}

/// Source: oracle/codemp/server/sv_world.cpp:188
let MAX_TOTAL_ENT_LEAFS = 128 as Int32

/// Source: oracle/codemp/server/sv_world.cpp:191
// AI: Raven declares `leafs` on the stack of SV_LinkEntity. The function uses one zeroed allocation on the storage class.
var leafs_SV_LinkEntity: Slots<Int32> { world.storage.sv_world_leafs_SV_LinkEntity }

/// Source: oracle/codemp/server/sv_world.cpp:523
// AI: Raven declares `touchlist` static in SV_ClipMoveToEntities. The function uses one zeroed allocation on the storage class.
var touchlist_SV_ClipMoveToEntities: Slots<Int32> { world.storage.touchlist_SV_ClipMoveToEntities }

/// Source: oracle/codemp/server/sv_world.cpp:872
// AI: Raven declares `touch` on the stack of SV_PointContents. The function uses one zeroed allocation on the storage class.
var touch_SV_PointContents: Slots<Int32> { world.storage.touch_SV_PointContents }

/**
```
================
SV_ClipHandleForEntity

Returns a headnode that can be used for testing or clipping to a
given entity.  If the entity is a bsp model, the headnode will
be returned, otherwise a custom box tree will be constructed.
================
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:19
func SV_ClipHandleForEntity(_ ent: JKAMP.SharedEntity) -> JKAShared.clipHandle_t {
    if ent.r.bmodel {
        // explicit hulls in the BSP model
        return CM_InlineModel(ent.s.modelindex)
    }
    if (ent.r.svFlags & SVF_CAPSULE) != 0 {
        // create a temp capsule from bounding box sizes
        return CM_TempBoxModel(ent.r.mins, ent.r.maxs, 1)
    }

    // create a temp tree from bounding box sizes
    return CM_TempBoxModel(ent.r.mins, ent.r.maxs, 0)
}

/**
```
===============
SV_SectorList_f
===============
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:67
func SV_SectorList_f() {
    var i: Int32
    var c: Int32
    var sec: WorldSector
    var ent: SvEntity?

    i = 0
    while i < AREA_NODES {
        sec = sv_worldSectors[i]

        c = 0
        ent = sec.entities
        while ent != nil {
            c += 1
            ent = ent!.nextEntityInWorldSector
        }
        Com_Printf("sector %i: %i entities\n", i, c)
        i += 1
    }
}

/**
```
===============
SV_CreateworldSector

Builds a uniformly subdivided tree for the given world size
===============
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:90
func SV_CreateworldSector(_ depth: Int32, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) -> WorldSector? {
    let anode: WorldSector
    var size = vec3_t()
    var mins1 = vec3_t()
    var maxs1 = vec3_t()
    var mins2 = vec3_t()
    var maxs2 = vec3_t()

    anode = sv_worldSectors[sv_numworldSectors]
    sv_numworldSectors += 1

    if depth == AREA_DEPTH {
        anode.axis = -1
        anode.children[1] = nil
        anode.children[0] = anode.children[1]
        return anode
    }

    size = maxs - mins
    if size[0] > size[1] {
        anode.axis = 0
    } else {
        anode.axis = 1
    }

    anode.dist = Float(0.5 * Double(maxs[anode.axis] + mins[anode.axis]))
    mins1 = mins
    mins2 = mins
    maxs1 = maxs
    maxs2 = maxs

    mins2[anode.axis] = anode.dist
    maxs1[anode.axis] = mins2[anode.axis]

    anode.children[0] = SV_CreateworldSector(depth + 1, mins2, maxs2)
    anode.children[1] = SV_CreateworldSector(depth + 1, mins1, maxs1)

    return anode
}

/**
```
===============
SV_ClearWorld

===============
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:131
func SV_ClearWorld() {
    let h: clipHandle_t
    var mins = vec3_t()
    var maxs = vec3_t()

    sv_worldSectors.zero()
    sv_numworldSectors = 0

    // get world map bounds
    h = CM_InlineModel(0)
    CM_ModelBounds(h, &mins, &maxs)
    SV_CreateworldSector(0, mins, maxs)
}

/**
```
===============
SV_UnlinkEntity

===============
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:151
func SV_UnlinkEntity(_ gEnt: JKAMP.SharedEntity) {
    var ent: SvEntity?
    var scan: SvEntity?
    let ws: WorldSector?

    ent = SV_SvEntityForGentity(gEnt)

    gEnt.r.linked = false

    ws = ent!.worldSector
    if ws == nil {
        return // not linked in anywhere
    }
    ent!.worldSector = nil

    if ws!.entities == ent {
        ws!.entities = ent!.nextEntityInWorldSector
        return
    }

    scan = ws!.entities
    while scan != nil {
        if scan!.nextEntityInWorldSector == ent {
            scan!.nextEntityInWorldSector = ent!.nextEntityInWorldSector
            return
        }
        scan = scan!.nextEntityInWorldSector
    }

    Com_Printf("WARNING: SV_UnlinkEntity: not found in worldSector\n")
}

/// Source: oracle/codemp/server/sv_world.cpp:189
func SV_LinkEntity(_ gEnt: JKAMP.SharedEntity) {
    var node: WorldSector
    var cluster: Int32
    let num_leafs: Int32
    var i: Int32
    var j: Int32
    var k: Int32
    var area: Int32
    var lastLeaf: Int32 = 0
    var ent: SvEntity?

    ent = SV_SvEntityForGentity(gEnt)

    if ent!.worldSector != nil {
        SV_UnlinkEntity(gEnt) // unlink from old position
    }

    // encode the size into the entityState_t for client prediction
    if gEnt.r.bmodel {
        gEnt.s.solid = SOLID_BMODEL // a solid_box will never create this value
    } else if (gEnt.r.contents & (CONTENTS_SOLID | CONTENTS_BODY)) != 0 {
        // assume that x/y are equal and symetric
        i = Int32(gEnt.r.maxs[0])
        if i < 1 {
            i = 1
        }
        if i > 255 {
            i = 255
        }

        // z is not symetric
        j = Int32((-gEnt.r.mins[2]))
        if j < 1 {
            j = 1
        }
        if j > 255 {
            j = 255
        }

        // and z maxs can be negative...
        k = Int32((gEnt.r.maxs[2] + 32))
        if k < 1 {
            k = 1
        }
        if k > 255 {
            k = 255
        }

        gEnt.s.solid = (k << 16) | (j << 8) | i

        if gEnt.s.solid == SOLID_BMODEL {
            //yikes, this would make everything explode violently.
            gEnt.s.solid = (k << 16) | (j << 8) | i - 1
        }
    } else {
        gEnt.s.solid = 0
    }

    // get the position

    // set the abs box
    if gEnt.r.bmodel && (gEnt.r.currentAngles[0] != 0 || gEnt.r.currentAngles[1] != 0 || gEnt.r.currentAngles[2] != 0) {
        // expand for rotation
        let max: Float
        var i: Int32

        max = RadiusFromBounds(gEnt.r.mins, gEnt.r.maxs)
        i = 0
        while i < 3 {
            gEnt.r.absmin[i] = gEnt.r.currentOrigin[i] - max
            gEnt.r.absmax[i] = gEnt.r.currentOrigin[i] + max
            i += 1
        }
    } else {
        // normal
        gEnt.r.absmin = gEnt.r.currentOrigin + gEnt.r.mins
        gEnt.r.absmax = gEnt.r.currentOrigin + gEnt.r.maxs
    }

    // because movement is clipped an epsilon away from an actual edge,
    // we must fully check even when bounding boxes don't quite touch
    gEnt.r.absmin[0] -= 1
    gEnt.r.absmin[1] -= 1
    gEnt.r.absmin[2] -= 1
    gEnt.r.absmax[0] += 1
    gEnt.r.absmax[1] += 1
    gEnt.r.absmax[2] += 1

    // link to PVS leafs
    ent!.numClusters = 0
    ent!.lastCluster = 0
    ent!.areanum = -1
    ent!.areanum2 = -1

    //get all leafs, including solids
    num_leafs = CM_BoxLeafnums(gEnt.r.absmin, gEnt.r.absmax, leafs_SV_LinkEntity, MAX_TOTAL_ENT_LEAFS, &lastLeaf)

    // if none of the leafs were inside the map, the
    // entity is outside the world and can be considered unlinked
    if num_leafs == 0 {
        return
    }

    // set areas, even from clusters that don't fit in the entity array
    i = 0
    while i < num_leafs {
        area = CM_LeafArea(leafs_SV_LinkEntity[i])
        if area != -1 {
            // doors may legally straggle two areas,
            // but nothing should evern need more than that
            if ent!.areanum != -1 && ent!.areanum != area {
                if ent!.areanum2 != -1 && ent!.areanum2 != area && sv.state == SS_LOADING {
                    Com_DPrintf("Object %i touching 3 areas at %f %f %f\n", gEnt.s.number, gEnt.r.absmin[0], gEnt.r.absmin[1], gEnt.r.absmin[2])
                }
                ent!.areanum2 = area
            } else {
                ent!.areanum = area
            }
        }
        i += 1
    }

    // store as many explicit clusters as we can
    ent!.numClusters = 0
    i = 0
    while i < num_leafs {
        cluster = CM_LeafCluster(leafs_SV_LinkEntity[i])
        if cluster != -1 {
            ent!.clusternums[ent!.numClusters] = cluster
            ent!.numClusters += 1
            if ent!.numClusters == MAX_ENT_CLUSTERS {
                break
            }
        }
        i += 1
    }

    // store off a last cluster if we need to
    if i != num_leafs {
        ent!.lastCluster = CM_LeafCluster(lastLeaf)
    }

    gEnt.r.linkcount += 1

    // find the first world sector node that the ent's box crosses
    node = sv_worldSectors[0]
    while 1 != 0 {
        if node.axis == -1 {
            break
        }
        if gEnt.r.absmin[node.axis] > node.dist {
            node = node.children[0]!
        } else if gEnt.r.absmax[node.axis] < node.dist {
            node = node.children[1]!
        } else {
            break // crosses the node
        }
    }

    // link it in
    ent!.worldSector = node
    ent!.nextEntityInWorldSector = node.entities
    node.entities = ent

    gEnt.r.linked = true
}

/**
```
====================
SV_AreaEntities_r

====================
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:373
func SV_AreaEntities_r(_ node: Slots<WorldSector>, _ ap: AreaParms) {
    var check: SvEntity?
    var next: SvEntity?
    var gcheck: SharedEntity?

    check = node[0].entities
    while check != nil {
        next = check!.nextEntityInWorldSector

        gcheck = SV_GEntityForSvEntity(check!)

        if gcheck!.r.absmin[0] > ap.maxs[0]
            || gcheck!.r.absmin[1] > ap.maxs[1]
            || gcheck!.r.absmin[2] > ap.maxs[2]
            || gcheck!.r.absmax[0] < ap.mins[0]
            || gcheck!.r.absmax[1] < ap.mins[1]
            || gcheck!.r.absmax[2] < ap.mins[2] {
            check = next
            continue
        }

        if ap.count == ap.maxcount {
            Com_DPrintf("SV_AreaEntities: MAXCOUNT\n")
            return
        }

        ap.list![ap.count] = sv.svEntities.index(of: check!)
        ap.count += 1
        check = next
    }

    if node[0].axis == -1 {
        return // terminal node
    }

    // recurse down both sides
    if ap.maxs[node[0].axis] > node[0].dist {
        SV_AreaEntities_r(Slots(record: node[0].children[0]!), ap)
    }
    if ap.mins[node[0].axis] < node[0].dist {
        SV_AreaEntities_r(Slots(record: node[0].children[1]!), ap)
    }
}

/**
```
================
SV_AreaEntities
================
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:421
func SV_AreaEntities(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ entityList: Slots<Int32>, _ maxcount: Int32) -> Int32 {
    return AreaParms.scratch { ap in
        // AI: Raven stores the address of the caller's vector. The record holds a copy of the vector, which the body only reads.
        ap.mins = mins
        ap.maxs = maxs
        ap.list = entityList
        ap.count = 0
        ap.maxcount = maxcount

        SV_AreaEntities_r(sv_worldSectors, ap)

        return ap.count
    }
}

/**
```
====================
SV_ClipToEntity

====================
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:470
func SV_ClipToEntity(_ trace: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ entityNum: Int32, _ contentmask: Int32, _ capsule: Int32) {
    var touch: SharedEntity?
    let clipHandle: clipHandle_t
    // AI: Raven points `origin` and `angles` at vectors of the entity and only reads them. Each local holds a copy of the vector.
    let origin: vec3_t
    var angles: vec3_t

    touch = SV_GentityNum(entityNum)

    trace.clear()

    // if it doesn't have any brushes of a type we
    // are looking for, ignore it
    if !((contentmask & touch!.r.contents) != 0) {
        trace.fraction = 1.0
        return
    }

    // might intersect, so do an exact clip
    clipHandle = SV_ClipHandleForEntity(touch!)

    origin = touch!.r.currentOrigin
    angles = touch!.r.currentAngles

    if !touch!.r.bmodel {
        angles = vec3_origin // boxes don't rotate
    }

    CM_TransformedBoxTrace(trace, start, end, mins, maxs, clipHandle, contentmask, origin, angles, capsule)

    if trace.fraction < 1 {
        trace.entityNum = touch!.s.number
    }
}

/// Source: oracle/codemp/server/sv_world.cpp:513
private func VectorDistance(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Float {
    var dir = vec3_t()

    dir = p2 - p1
    return VectorLength(dir)
}

/// Source: oracle/codemp/server/sv_world.cpp:522
private func SV_ClipMoveToEntities(_ clip: Moveclip) {
    let num: Int32
    var touch: SharedEntity?
    var passOwnerNum: Int32
    var thisOwnerShared: Int32 = 1

    num = SV_AreaEntities(clip.boxmins, clip.boxmaxs, touchlist_SV_ClipMoveToEntities, MAX_GENTITIES)

    if clip.passEntityNum != ENTITYNUM_NONE {
        passOwnerNum = (SV_GentityNum(clip.passEntityNum))!.r.ownerNum
        if passOwnerNum == ENTITYNUM_NONE {
            passOwnerNum = -1
        }
    } else {
        passOwnerNum = -1
    }

    if (SV_GentityNum(clip.passEntityNum)!.r.svFlags & SVF_OWNERNOTSHARED) != 0 {
        thisOwnerShared = 0
    }

    // Raven's two records live to the end of the function, so the rest of the body is the closures.
    Trace.scratch { trace in
        Trace.scratch { oldTrace in
            var i: Int32
            var clipHandle: clipHandle_t
            // AI: Raven points `origin` and `angles` at vectors of the entity and only reads them. Each local holds a copy of the vector.
            var origin: vec3_t
            var angles: vec3_t

            i = 0
            while i < num {
                if clip.trace.allsolid != 0 {
                    return
                }
                touch = SV_GentityNum(touchlist_SV_ClipMoveToEntities[i])

                // see if we should ignore this entity
                if clip.passEntityNum != ENTITYNUM_NONE {
                    if touchlist_SV_ClipMoveToEntities[i] == clip.passEntityNum {
                        i += 1
                        continue // don't clip against the pass entity
                    }
                    if touch!.r.ownerNum == clip.passEntityNum {
                        if (touch!.r.svFlags & SVF_OWNERNOTSHARED) != 0 {
                            if clip.contentmask != (MASK_SHOT | CONTENTS_LIGHTSABER) && clip.contentmask != (MASK_SHOT) {
                                //it's not a laser hitting the other "missile", don't care then
                                i += 1
                                continue
                            }
                        } else {
                            i += 1
                            continue // don't clip against own missiles
                        }
                    }
                    if touch!.r.ownerNum == passOwnerNum && (touch!.r.svFlags & SVF_OWNERNOTSHARED) == 0 && thisOwnerShared != 0 {
                        i += 1
                        continue // don't clip against other missiles from our owner
                    }

                    if touch!.s.eType == ET_MISSILE && (touch!.r.svFlags & SVF_OWNERNOTSHARED) == 0 && touch!.r.ownerNum == passOwnerNum {
                        //blah, hack
                        i += 1
                        continue
                    }
                }

                // if it doesn't have any brushes of a type we
                // are looking for, ignore it
                if (clip.contentmask & touch!.r.contents) == 0 {
                    i += 1
                    continue
                }

                if (clip.contentmask == (MASK_SHOT | CONTENTS_LIGHTSABER) || clip.contentmask == MASK_SHOT) && (touch!.r.contents > 0 && (touch!.r.contents & CONTENTS_NOSHOT) != 0) {
                    i += 1
                    continue
                }

                // might intersect, so do an exact clip
                clipHandle = SV_ClipHandleForEntity(touch!)

                origin = touch!.r.currentOrigin
                angles = touch!.r.currentAngles

                if !touch!.r.bmodel {
                    angles = vec3_origin // boxes don't rotate
                }

                CM_TransformedBoxTrace(trace, clip.start, clip.end, clip.mins, clip.maxs, clipHandle, clip.contentmask, origin, angles, clip.capsule)

                if (clip.traceFlags & G2TRFLAG_DOGHOULTRACE) != 0 {
                    // keep these older variables around for a bit, incase we need to replace them in the Ghoul2 Collision check
                    oldTrace.copy(from: clip.trace)
                }

                if trace.allsolid != 0 {
                    clip.trace.allsolid = 1
                    trace.entityNum = touch!.s.number
                } else if trace.startsolid != 0 {
                    clip.trace.startsolid = 1
                    trace.entityNum = touch!.s.number

                    //rww - added this because we want to get the number of an ent even if our trace starts inside it.
                    clip.trace.entityNum = touch!.s.number
                }

                if trace.fraction < clip.trace.fraction {
                    var oldStart: byte

                    // make sure we keep a startsolid from a previous trace
                    oldStart = byte(truncatingIfNeeded: clip.trace.startsolid)

                    trace.entityNum = touch!.s.number
                    clip.trace = trace
                    clip.trace.startsolid = clip.trace.startsolid | Int32(oldStart)
                }
                /*
                Ghoul2 Insert Start
                */
                //rww - since this is multiplayer and we don't have the luxury of violating networking rules in horrible ways,
                //this must be done somewhat differently.
                if (clip.traceFlags & G2TRFLAG_DOGHOULTRACE) != 0 && trace.entityNum == touch!.s.number && touch!.ghoul2 != nil
                    && ((clip.traceFlags & G2TRFLAG_HITCORPSES) != 0 || (touch!.s.eFlags & EF_DEAD) == 0) {
                    //standard behavior will be to ignore g2 col on dead ents, but if traceFlags is set to allow, then we'll try g2 col on EF_DEAD people too.
                    // Port-note: Row Z6. The static `G2Trace_t G2Trace` has no storage, and `touch->ghoul2` is a word with no form as the Swift class `CGhoul2Info_v`.
                    // Raven wrote: static G2Trace_t G2Trace; ... the Ghoul2 collision test of sv_world.cpp:692 to :782, with oldTrace and VectorDistance.
                    portMissing("SV_ClipMoveToEntities", source: "oracle/codemp/server/sv_world.cpp:522")
                }
                /*
                Ghoul2 Insert End
                */
                i += 1
            }
        }
    }
}

/**
```
==================
SV_Trace

Moves the given mins/maxs volume through the world from start to end.
passEntityNum and entities owned by passEntityNum are explicitly not checked.
==================
```
*/
/**
```
Ghoul2 Insert Start
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:803
func SV_Trace(_ results: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ end: JKAShared.vec3_t, _ passEntityNum: Int32, _ contentmask: Int32, _ capsule: Int32, _ traceFlags: Int32, _ useLod: Int32) {
    /*
    Ghoul2 Insert End
    */
    // Raven assigns his own `mins` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var mins = mins
    // Raven assigns his own `maxs` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var maxs = maxs

    if mins == nil {
        mins = vec3_origin
    }
    if maxs == nil {
        maxs = vec3_origin
    }

    // Raven's record lives to the end of the function, so the rest of the body is the closure.
    Moveclip.scratch { clip in
        var i: Int32

        // clip to world
        CM_BoxTrace(clip.trace, start, end, mins, maxs, 0, contentmask, capsule)
        clip.trace.entityNum = clip.trace.fraction != 1.0 ? ENTITYNUM_WORLD : ENTITYNUM_NONE
        if clip.trace.fraction == 0 {
            results.copy(from: clip.trace)
            return // blocked immediately by the world
        }

        clip.contentmask = contentmask
        /*
        Ghoul2 Insert Start
        */
        clip.start = start
        clip.traceFlags = traceFlags
        clip.useLod = useLod
        /*
        Ghoul2 Insert End
        */
        //	VectorCopy( clip.trace.endpos, clip.end );
        clip.end = end
        // AI: Raven stores the address of the caller's vector. The record holds a copy of the vector, which the body only reads.
        clip.mins = mins!
        clip.maxs = maxs!
        clip.passEntityNum = passEntityNum
        clip.capsule = capsule

        // create the bounding box of the entire move
        // we can limit it to the part of the move not
        // already clipped off by the world, which can be
        // a significant savings for line of sight and shot traces
        i = 0
        while i < 3 {
            if end[i] > start[i] {
                clip.boxmins[i] = clip.start[i] + clip.mins[i] - 1
                clip.boxmaxs[i] = clip.end[i] + clip.maxs[i] + 1
            } else {
                clip.boxmins[i] = clip.end[i] + clip.mins[i] - 1
                clip.boxmaxs[i] = clip.start[i] + clip.maxs[i] + 1
            }
            i += 1
        }

        // clip to other solid entities
        SV_ClipMoveToEntities(clip)

        results.copy(from: clip.trace)
    }
}

/**
```
=============
SV_PointContents
=============
```
*/
/// Source: oracle/codemp/server/sv_world.cpp:871
func SV_PointContents(_ p: JKAShared.vec3_t, _ passEntityNum: Int32) -> Int32 {
    var hit: SharedEntity?
    var i: Int32
    let num: Int32
    var contents: Int32
    var c2: Int32
    var clipHandle: clipHandle_t
    // AI: Raven points `angles` at a vector of the entity and only reads it. The local holds a copy of the vector.
    var angles: vec3_t

    // get base contents from world
    contents = CM_PointContents(p, 0)

    // or in contents from all the other entities
    num = SV_AreaEntities(p, p, touch_SV_PointContents, MAX_GENTITIES)

    i = 0
    while i < num {
        if touch_SV_PointContents[i] == passEntityNum {
            i += 1
            continue
        }
        hit = SV_GentityNum(touch_SV_PointContents[i])
        // might intersect, so do an exact clip
        clipHandle = SV_ClipHandleForEntity(hit!)
        angles = hit!.s.angles
        if !hit!.r.bmodel {
            angles = vec3_origin // boxes don't rotate
        }

        c2 = CM_TransformedPointContents(p, clipHandle, hit!.s.origin, hit!.s.angles)

        contents |= c2
        i += 1
    }

    return contents
}
