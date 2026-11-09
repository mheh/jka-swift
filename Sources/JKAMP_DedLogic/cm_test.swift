import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/**
```
==================
CM_PointLeafnum_r

==================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:16
// TODO: Port signature
// Raven wrote: int CM_PointLeafnum_r( const vec3_t p, int num, clipMap_t *local )
// No table row for `clipMap_t * local`.
func CM_PointLeafnum_r() -> Never {
    // TODO: Port CM_PointLeafnum_r
    portMissing("CM_PointLeafnum_r", source: "oracle/codemp/qcommon/cm_test.cpp:16")
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:46
func CM_PointLeafnum(_ p: JKAShared.vec3_t) -> Int32 {
    if cmg.numNodes == 0 {
        // map not loaded
        return 0
    }
    // Port-note: CM_PointLeafnum_r carries a signature marker, row T6.
    // Raven wrote: return CM_PointLeafnum_r (p, 0, &cmg)
    portMissing("CM_PointLeafnum", source: "oracle/codemp/qcommon/cm_test.cpp:46")
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:63
// TODO: Port signature
// Raven wrote: void CM_StoreLeafs( leafList_t *ll, int nodenum )
// No table row for `leafList_t * ll`.
func CM_StoreLeafs() -> Never {
    // TODO: Port CM_StoreLeafs
    portMissing("CM_StoreLeafs", source: "oracle/codemp/qcommon/cm_test.cpp:63")
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:80
// TODO: Port signature
// Raven wrote: void CM_StoreBrushes( leafList_t *ll, int nodenum )
// No table row for `leafList_t * ll`.
func CM_StoreBrushes() -> Never {
    // TODO: Port CM_StoreBrushes
    portMissing("CM_StoreBrushes", source: "oracle/codemp/qcommon/cm_test.cpp:80")
}

/**
```
=============
CM_BoxLeafnums

Fills in a list of all the leafs touched
=============
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:130
// TODO: Port signature
// Raven wrote: void CM_BoxLeafnums_r( leafList_t *ll, int nodenum )
// No table row for `leafList_t * ll`.
func CM_BoxLeafnums_r() -> Never {
    // TODO: Port CM_BoxLeafnums_r
    portMissing("CM_BoxLeafnums_r", source: "oracle/codemp/qcommon/cm_test.cpp:130")
}

/**
```
==================
CM_BoxLeafnums
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:168
func CM_BoxLeafnums(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ boxList: inout Int32, _ listsize: Int32, _ lastLeaf: inout Int32) -> Int32 {
    //rwwRMG - changed to boxList to not conflict with list type
    // Port-note: A local `leafList_t ll` has no view, row T4.
    // Raven wrote: leafList_t ll;
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")

    cmg.checkcount += 1

    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: VectorCopy( mins, ll.bounds[0] )
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: VectorCopy( maxs, ll.bounds[1] )
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: ll.count = 0
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: ll.maxcount = listsize
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
    // Port-note: A read of `ll`, a local the draft left as a hole. The `int *boxList` parameter is one `inout Int32`, row T4.
    // Raven wrote: ll.list = boxList
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: ll.storeLeafs = CM_StoreLeafs
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: ll.lastLeaf = 0
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: ll.overflowed = qfalse
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")

    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: CM_BoxLeafnums_r( &ll, 0 )
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")

    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: *lastLeaf = ll.lastLeaf
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
    // Port-note: A read of `ll`, a local the draft left as a hole.
    // Raven wrote: return ll.count
    portMissing("CM_BoxLeafnums", source: "oracle/codemp/qcommon/cm_test.cpp:168")
}

/**
```
==================
CM_BoxBrushes
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:194
// TODO: Port signature
// Raven wrote: int CM_BoxBrushes( const vec3_t mins, const vec3_t maxs, cbrush_t **boxList, int listsize )
// No table row for `cbrush_t ** boxList`.
func CM_BoxBrushes() -> Never {
    // TODO: Port CM_BoxBrushes
    portMissing("CM_BoxBrushes", source: "oracle/codemp/qcommon/cm_test.cpp:194")
}

/**
```
==================
CM_PointContents

==================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:224
func CM_PointContents(_ p: JKAShared.vec3_t, _ model: JKAShared.clipHandle_t) -> Int32 {
    var leafnum: Int32
    var i: Int32
    var k: Int32
    var brushnum: Int32
    var leaf: CLeaf?
    var b: Cbrush
    var contents: Int32
    var d: Float
    var clipm: Cmodel?
    var local: ClipMap?

    if cmg.numNodes == 0 {
        // map not loaded
        return 0
    }

    if model != 0 {
        // Port-note: CM_ClipHandleToModel carries a signature marker, row CM3 of the cm_load round.
        // Raven wrote: clipm = CM_ClipHandleToModel( model, &local )
        portMissing("CM_PointContents", source: "oracle/codemp/qcommon/cm_test.cpp:224")
        if clipm!.firstNode != -1 {
            // Port-note: CM_PointLeafnum_r carries a signature marker, row T6.
            // Raven wrote: leafnum = CM_PointLeafnum_r (p, 0, local)
            portMissing("CM_PointContents", source: "oracle/codemp/qcommon/cm_test.cpp:224")
            leaf = local!.leafsSlots[leafnum]
        } else {
            leaf = clipm!.leaf
        }
    } else {
        local = cmg
        // Port-note: CM_PointLeafnum_r carries a signature marker, row T6.
        // Raven wrote: leafnum = CM_PointLeafnum_r (p, 0, &cmg)
        portMissing("CM_PointContents", source: "oracle/codemp/qcommon/cm_test.cpp:224")
        leaf = local!.leafsSlots[leafnum]
    }

    contents = 0
    k = 0
    while k < leaf!.numLeafBrushes {
        brushnum = local!.leafbrushes![leaf!.firstLeafBrush + k]
        b = local!.brushesSlots[brushnum]

        // see if the point is in the brush
        i = 0
        while i < b.numsides {
            d = _DotProduct(p, b.sides![i].plane!.normal)
            // FIXME test for Cash
            //			if ( d >= b->sides[i].plane->dist ) {
            if d > b.sides![i].plane!.dist {
                break
            }
            i += 1
        }

        if i == b.numsides {
            contents |= b.contents
            if cmg.landScape != nil && (contents & CONTENTS_TERRAIN) != 0 {
                // Port-note: The methods of CCMLandScape have no Swift name, row CM6 of the cm_load round.
                // Raven wrote: if(p[2] < cmg.landScape->GetWaterHeight()) { contents |= cmg.landScape->GetWaterContents(); }
                portMissing("CM_PointContents", source: "oracle/codemp/qcommon/cm_test.cpp:224")
            }
        }
        k += 1
    }

    return contents
}

/**
```
==================
CM_TransformedPointContents

Handles offseting and rotation of the end points for moving and
rotating entities
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:306
func CM_TransformedPointContents(_ p: JKAShared.vec3_t, _ model: JKAShared.clipHandle_t, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t) -> Int32 {
    var p_l = vec3_t()
    var temp = vec3_t()
    var forward = vec3_t()
    var right = vec3_t()
    var up = vec3_t()

    // subtract origin offset
    p_l = p - origin

    // rotate start and end into the models frame of reference
    if model != BOX_MODEL_HANDLE && (angles[0] != 0 || angles[1] != 0 || angles[2] != 0) {
        AngleVectors(angles, &forward, &right, &up)

        temp = p_l
        p_l[0] = _DotProduct(temp, forward)
        p_l[1] = -_DotProduct(temp, right)
        p_l[2] = _DotProduct(temp, up)
    }

    return CM_PointContents(p_l, model)
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:351
// TODO: Port signature
// Raven wrote: byte *CM_ClusterPVS (int cluster)
// No table row for the return `byte *`.
func CM_ClusterPVS() -> Never {
    // TODO: Port CM_ClusterPVS
    portMissing("CM_ClusterPVS", source: "oracle/codemp/qcommon/cm_test.cpp:351")
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:395
// TODO: Port signature
// Raven wrote: void CM_FloodArea_r( int areaNum, int floodnum, clipMap_t &cm )
// No table row for `clipMap_t & cm`.
func CM_FloodArea_r() -> Never {
    // TODO: Port CM_FloodArea_r
    portMissing("CM_FloodArea_r", source: "oracle/codemp/qcommon/cm_test.cpp:395")
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:448
// TODO: Port signature
// Raven wrote: void CM_FloodAreaConnections( clipMap_t &cm )
// No table row for `clipMap_t & cm`.
func CM_FloodAreaConnections() -> Never {
    // TODO: Port CM_FloodAreaConnections
    portMissing("CM_FloodAreaConnections", source: "oracle/codemp/qcommon/cm_test.cpp:448")
}

/**
```
====================
CM_AdjustAreaPortalState

====================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:476
func CM_AdjustAreaPortalState(_ area1: Int32, _ area2: Int32, _ open: Bool) {
    if area1 < 0 || area2 < 0 {
        return
    }

    if area1 >= cmg.numAreas || area2 >= cmg.numAreas {
        Com_Error(ERR_DROP, "CM_ChangeAreaPortalState: bad area number")
    }

    if open {
        cmg.areaPortals![area1 * cmg.numAreas + area2] += 1
        cmg.areaPortals![area2 * cmg.numAreas + area1] += 1
    } else {
        cmg.areaPortals![area1 * cmg.numAreas + area2] -= 1
        cmg.areaPortals![area2 * cmg.numAreas + area1] -= 1
        if cmg.areaPortals![area2 * cmg.numAreas + area1] < 0 {
            Com_Error(ERR_DROP, "CM_AdjustAreaPortalState: negative reference count")
        }
    }

    // Port-note: CM_FloodAreaConnections carries a signature marker, row T6.
    // Raven wrote: CM_FloodAreaConnections (cmg)
    portMissing("CM_AdjustAreaPortalState", source: "oracle/codemp/qcommon/cm_test.cpp:476")
}

/**
```
====================
CM_AreasConnected

====================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:509
func CM_AreasConnected(_ area1: Int32, _ area2: Int32) -> Bool {
    if cm_noAreas!.integer != 0 {
        return true
    }

    if area1 < 0 || area2 < 0 {
        return false
    }

    if area1 >= cmg.numAreas || area2 >= cmg.numAreas {
        Com_Error(ERR_DROP, "area >= cmg.numAreas")
    }

    if cmg.areasSlots[area1].floodnum == cmg.areasSlots[area2].floodnum {
        return true
    }
    return false
}

/**
```
=================
CM_WriteAreaBits

Writes a bit vector of all the areas
that are in the same flood as the area parameter
Returns the number of bytes needed to hold all the bits.

The bits are OR'd in, so you can CM_WriteAreaBits from multiple
viewpoints and get the union of all visible areas.

This is used to cull non-visible entities from snapshots
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:545
func CM_WriteAreaBits(_ buffer: Slots<UInt8>, _ area: Int32) -> Int32 {
    var i: Int32
    let floodnum: Int32
    let bytes: Int32

    bytes = (cmg.numAreas + 7) >> 3

    if cm_noAreas!.integer != 0 || area == -1 {
        // for debugging, send everything
        Com_Memset(buffer, 255, bytes)
    } else {
        floodnum = cmg.areasSlots[area].floodnum
        i = 0
        while i < cmg.numAreas {
            if cmg.areasSlots[i].floodnum == floodnum || area == -1 {
                buffer[byte: i >> 3] |= 1 << (i & 7)
            }
            i += 1
        }
    }

    return bytes
}
