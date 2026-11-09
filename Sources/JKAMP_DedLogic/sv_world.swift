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
    // TODO: Port SV_CreateworldSector
    portMissing("SV_CreateworldSector", source: "oracle/codemp/server/sv_world.cpp:90")
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
    // Port-note: SV_CreateworldSector carries a signature marker, because the table has no row for `worldSector_t *`, row W1.
    // Raven wrote: SV_CreateworldSector( 0, mins, maxs )
    portMissing("SV_ClearWorld", source: "oracle/codemp/server/sv_world.cpp:131")
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
    var leafs: [Int32] = [Int32](repeating: 0, count: 128)
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
    // Port-note: CM_BoxLeafnums takes `boxList` as one `inout Int32`, and Raven hands it the array `leafs` to fill, row W2.
    // Raven wrote: num_leafs = CM_BoxLeafnums( gEnt->r.absmin, gEnt->r.absmax, leafs, MAX_TOTAL_ENT_LEAFS, &lastLeaf )
    portMissing("SV_LinkEntity", source: "oracle/codemp/server/sv_world.cpp:189")

    // if none of the leafs were inside the map, the
    // entity is outside the world and can be considered unlinked
    if num_leafs == 0 {
        return
    }

    // set areas, even from clusters that don't fit in the entity array
    i = 0
    while i < num_leafs {
        area = CM_LeafArea(leafs[i])
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
        cluster = CM_LeafCluster(leafs[i])
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
    // TODO: Port SV_AreaEntities_r
    portMissing("SV_AreaEntities_r", source: "oracle/codemp/server/sv_world.cpp:373")
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
    // Port-note: A local `areaParms_t ap` the table has no type for, row W1.
    // Raven wrote: areaParms_t ap;
    portMissing("SV_AreaEntities", source: "oracle/codemp/server/sv_world.cpp:421")

    // Port-note: A read of `ap`, a local the draft left as a hole, row W1.
    // Raven wrote: ap.mins = mins
    portMissing("SV_AreaEntities", source: "oracle/codemp/server/sv_world.cpp:421")
    // Port-note: A read of `ap`, a local the draft left as a hole, row W1.
    // Raven wrote: ap.maxs = maxs
    portMissing("SV_AreaEntities", source: "oracle/codemp/server/sv_world.cpp:421")
    // Port-note: Raven stores `entityList` into `ap.list`, an `int *` field of `areaParms_t`, which has no view, rows W1 and W2.
    // Raven wrote: ap.list = entityList
    portMissing("SV_AreaEntities", source: "oracle/codemp/server/sv_world.cpp:421")
    // Port-note: A read of `ap`, a local the draft left as a hole, row W1.
    // Raven wrote: ap.count = 0
    portMissing("SV_AreaEntities", source: "oracle/codemp/server/sv_world.cpp:421")
    // Port-note: A read of `ap`, a local the draft left as a hole, row W1.
    // Raven wrote: ap.maxcount = maxcount
    portMissing("SV_AreaEntities", source: "oracle/codemp/server/sv_world.cpp:421")

    // Port-note: A read of `ap`, a local the draft left as a hole, row W1.
    // Raven wrote: SV_AreaEntities_r( sv_worldSectors, &ap )
    portMissing("SV_AreaEntities", source: "oracle/codemp/server/sv_world.cpp:421")

    // Port-note: A read of `ap`, a local the draft left as a hole, row W1.
    // Raven wrote: return ap.count
    portMissing("SV_AreaEntities", source: "oracle/codemp/server/sv_world.cpp:421")
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
    // TODO: Port SV_ClipMoveToEntities
    portMissing("SV_ClipMoveToEntities", source: "oracle/codemp/server/sv_world.cpp:522")
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
    // Port-note: A local `moveclip_t clip` the table has no type for, row W1.
    // Raven wrote: moveclip_t clip;
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    var i: Int32
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

    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: Com_Memset ( &clip, 0, sizeof ( moveclip_t ) )
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")

    // clip to world
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: CM_BoxTrace( &clip.trace, start, end, mins, maxs, 0, contentmask, capsule )
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: clip.trace.entityNum = clip.trace.fraction != 1.0 ? ENTITYNUM_WORLD : ENTITYNUM_NONE
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: if ( clip.trace.fraction == 0 ) { *results = clip.trace; return; // blocked immediately by the world }
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")

    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: clip.contentmask = contentmask
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    /*
    Ghoul2 Insert Start
    */
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: VectorCopy( start, clip.start )
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: clip.traceFlags = traceFlags
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: clip.useLod = useLod
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    /*
    Ghoul2 Insert End
    */
    //	VectorCopy( clip.trace.endpos, clip.end );
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: VectorCopy( end, clip.end )
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: clip.mins = mins
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: clip.maxs = maxs
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: clip.passEntityNum = passEntityNum
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: clip.capsule = capsule
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")

    // create the bounding box of the entire move
    // we can limit it to the part of the move not
    // already clipped off by the world, which can be
    // a significant savings for line of sight and shot traces
    i = 0
    while i < 3 {
        if end[i] > start[i] {
            // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
            // Raven wrote: clip.boxmins[i] = clip.start[i] + clip.mins[i] - 1
            portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
            // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
            // Raven wrote: clip.boxmaxs[i] = clip.end[i] + clip.maxs[i] + 1
            portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
        } else {
            // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
            // Raven wrote: clip.boxmins[i] = clip.end[i] + clip.mins[i] - 1
            portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
            // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
            // Raven wrote: clip.boxmaxs[i] = clip.start[i] + clip.maxs[i] + 1
            portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
        }
        i += 1
    }

    // clip to other solid entities
    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: SV_ClipMoveToEntities ( &clip )
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")

    // Port-note: A read of `clip`, a local the draft left as a hole, row W1.
    // Raven wrote: *results = clip.trace
    portMissing("SV_Trace", source: "oracle/codemp/server/sv_world.cpp:803")
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
    var touch: [Int32] = [Int32](repeating: 0, count: 1024)
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
    // Port-note: SV_AreaEntities takes `entityList` as one `inout Int32`, and Raven hands it the array `touch` to fill, row W2.
    // Raven wrote: num = SV_AreaEntities( p, p, touch, MAX_GENTITIES )
    portMissing("SV_PointContents", source: "oracle/codemp/server/sv_world.cpp:871")

    i = 0
    while i < num {
        if touch[i] == passEntityNum {
            i += 1
            continue
        }
        hit = SV_GentityNum(touch[i])
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
