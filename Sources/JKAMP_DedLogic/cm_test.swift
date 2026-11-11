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
public func CM_PointLeafnum_r(_ p: JKAShared.vec3_t, _ num: Int32, _ local: ClipMap) -> Int32 {
    // Raven assigns his own `num` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var num = num
    var d: Float
    var node: CmNode
    var plane: JKAShared.Cplane

    while num >= 0 {
        node = local.nodesSlots[num]

        plane = node.plane!

        if plane.type < 3 {
            d = p[plane.type] - plane.dist
        } else {
            d = _DotProduct(plane.normal, p) - plane.dist
        }
        if d < 0 {
            num = node.children[1]
        } else {
            num = node.children[0]
        }
    }

    c_pointcontents += 1 // optimize counter

    return -1 - num
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:46
public func CM_PointLeafnum(_ p: JKAShared.vec3_t) -> Int32 {
    if cmg.numNodes == 0 {
        // map not loaded
        return 0
    }
    return CM_PointLeafnum_r(p, 0, cmg)
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:63
public func CM_StoreLeafs(_ ll: LeafList, _ nodenum: Int32) {
    let leafNum: Int32

    leafNum = -1 - nodenum

    // store the lastLeaf even if the list is overflowed
    if cmg.leafsSlots[leafNum].cluster != -1 {
        ll.lastLeaf = leafNum
    }

    if ll.count >= ll.maxcount {
        ll.overflowed = true
        return
    }
    ll.list![ll.count] = leafNum
    ll.count += 1
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:80
public func CM_StoreBrushes(_ ll: LeafList, _ nodenum: Int32) {
    // CM_BoxBrushes is the one function that stores it, and no file of either tree calls CM_BoxBrushes, so it is dead.
    var i: Int32
    var k: Int32
    let leafnum: Int32
    var brushnum: Int32
    let leaf: CLeaf
    var b: Cbrush

    leafnum = -1 - nodenum

    leaf = cmg.leafsSlots[leafnum]

    k = 0
    while k < leaf.numLeafBrushes {
        // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
        // C converts the int to the ptrdiff_t of the field at the add.
        brushnum = cmg.leafbrush(at: leaf.firstLeafBrush + Int(k))
        b = cmg.brushesSlots[brushnum]
        if b.checkcount == cmg.checkcount {
            k += 1
            continue // already checked this brush in another leaf
        }
        b.checkcount = cmg.checkcount
        i = 0
        while i < 3 {
            if b.bounds[0][i] >= ll.bounds[1][i] || b.bounds[1][i] <= ll.bounds[0][i] {
                break
            }
            i += 1
        }
        if i != 3 {
            k += 1
            continue
        }
        if ll.count >= ll.maxcount {
            ll.overflowed = true
            return
        }
        ll.listBrushes![ll.count] = b
        ll.count += 1
        k += 1
    }
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
public func CM_BoxLeafnums_r(_ ll: LeafList, _ nodenum: Int32) {
    // Raven assigns his own `nodenum` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var nodenum = nodenum
    var plane: JKAShared.Cplane
    var node: CmNode
    var s: Int32

    while true {
        if nodenum < 0 {
            ll.runStoreLeafs(nodenum)
            return
        }

        node = cmg.nodesSlots[nodenum]

        plane = node.plane!

        s = BoxOnPlaneSide(ll.bounds[0], ll.bounds[1], plane)
        if s == 1 {
            nodenum = node.children[0]
        } else if s == 2 {
            nodenum = node.children[1]
        } else {
            // go down both
            CM_BoxLeafnums_r(ll, node.children[0])
            nodenum = node.children[1]
        }

    }
}

/**
```
==================
CM_BoxLeafnums
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:168
public func CM_BoxLeafnums(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ boxList: Slots<Int32>, _ listsize: Int32, _ lastLeaf: inout Int32) -> Int32 {
    //rwwRMG - changed to boxList to not conflict with list type
    LeafList.scratch { ll -> Int32 in
        cmg.checkcount += 1

        ll.bounds[0] = mins
        ll.bounds[1] = maxs
        ll.count = 0
        ll.maxcount = listsize
        ll.list = boxList
        ll.storeLeafs = LeafListThunks.CM_StoreLeafs
        ll.lastLeaf = 0
        ll.overflowed = false

        CM_BoxLeafnums_r(ll, 0)

        lastLeaf = ll.lastLeaf
        return ll.count
    }
}

/**
```
==================
CM_BoxBrushes
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:194
public func CM_BoxBrushes(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ boxList: Slots<Cbrush?>, _ listsize: Int32) -> Int32 {
    // Raven calls this function from no file of either tree, so it is dead.
    //rwwRMG - changed to boxList to not conflict with list type
    LeafList.scratch { ll -> Int32 in
        cmg.checkcount += 1

        ll.bounds[0] = mins
        ll.bounds[1] = maxs
        ll.count = 0
        ll.maxcount = listsize
        ll.listBrushes = boxList
        ll.storeLeafs = LeafListThunks.CM_StoreBrushes
        ll.lastLeaf = 0
        ll.overflowed = false

        CM_BoxLeafnums_r(ll, 0)

        return ll.count
    }
}

/**
```
==================
CM_PointContents

==================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:224
public func CM_PointContents(_ p: JKAShared.vec3_t, _ model: JKAShared.clipHandle_t) -> Int32 {
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
        clipm = CM_ClipHandleToModel(model, &local)
        if clipm!.firstNode != -1 {
            leafnum = CM_PointLeafnum_r(p, 0, local!)
            leaf = local!.leafsSlots[leafnum]
        } else {
            leaf = clipm!.leaf
        }
    } else {
        local = cmg
        leafnum = CM_PointLeafnum_r(p, 0, cmg)
        leaf = local!.leafsSlots[leafnum]
    }

    contents = 0
    k = 0
    while k < leaf!.numLeafBrushes {
        // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
        // C converts the int to the ptrdiff_t of the field at the add.
        brushnum = local!.leafbrush(at: leaf!.firstLeafBrush + Int(k))
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
            // AI: Raven reads the class pointer `cmg.landScape` of the C record. The world holds the Swift class as `landScape_cmg`, the C field stays unused.
            if landScape_cmg != nil && (contents & CONTENTS_TERRAIN) != 0 {
                if p[2] < landScape_cmg!.GetWaterHeight() {
                    contents |= landScape_cmg!.GetWaterContents()
                }
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
public func CM_TransformedPointContents(_ p: JKAShared.vec3_t, _ model: JKAShared.clipHandle_t, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t) -> Int32 {
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
public func CM_ClusterPVS(_ cluster: Int32) -> Slots<JKAShared.byte> {
    if cluster < 0 || cluster >= cmg.numClusters || !cmg.vised {
        return cmg.visibility!
    }

    return cmg.visibility!.suffix(from: cluster * cmg.clusterBytes)
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:395
public func CM_FloodArea_r(_ areaNum: Int32, _ floodnum: Int32, _ cm: ClipMap) {
    var i: Int32
    let area: CmArea
    let con: Slots<Int32>

    area = cm.areasSlots[areaNum]

    if area.floodvalid == cm.floodvalid {
        if area.floodnum == floodnum {
            return
        }
        Com_Error(ERR_DROP, "FloodArea_r: reflooded")
    }

    area.floodnum = floodnum
    area.floodvalid = cm.floodvalid
    con = cm.areaPortals!.suffix(from: areaNum * cm.numAreas)
    i = 0
    while i < cm.numAreas {
        if con[i] > 0 {
            CM_FloodArea_r(i, floodnum, cm)
        }
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/cm_test.cpp:448
public func CM_FloodAreaConnections(_ cm: ClipMap) {
    var i: Int32
    var area: CmArea
    var floodnum: Int32

    // all current floods are now invalid
    cm.floodvalid += 1
    floodnum = 0

    i = 0
    while i < cm.numAreas {
        area = cm.areasSlots[i]
        if area.floodvalid == cm.floodvalid {
            i += 1
            continue // already flooded into
        }
        floodnum += 1
        CM_FloodArea_r(i, floodnum, cm)
        i += 1
    }

}

/**
```
====================
CM_AdjustAreaPortalState

====================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:476
public func CM_AdjustAreaPortalState(_ area1: Int32, _ area2: Int32, _ open: Bool) {
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

    CM_FloodAreaConnections(cmg)
}

/**
```
====================
CM_AreasConnected

====================
```
*/
/// Source: oracle/codemp/qcommon/cm_test.cpp:509
public func CM_AreasConnected(_ area1: Int32, _ area2: Int32) -> Bool {
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
public func CM_WriteAreaBits(_ buffer: Slots<UInt8>, _ area: Int32) -> Int32 {
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

/// One static per function this file stores in a `LeafList` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum LeafListThunks {
    /// Source: oracle/codemp/qcommon/cm_test.cpp:80
    static let CM_StoreBrushes: LeafListStoreLeafs = { JKAMP_DedLogic.CM_StoreBrushes(LeafList(handle: $0!), $1) }

    /// Source: oracle/codemp/qcommon/cm_test.cpp:63
    static let CM_StoreLeafs: LeafListStoreLeafs = { JKAMP_DedLogic.CM_StoreLeafs(LeafList(handle: $0!), $1) }
}
