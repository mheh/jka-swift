import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_load.cpp:29
let BOX_BRUSHES = 1 as Int32

/// Source: oracle/codemp/qcommon/cm_load.cpp:30
let BOX_SIDES = 6 as Int32

/// Source: oracle/codemp/qcommon/cm_load.cpp:31
let BOX_LEAFS = 2 as Int32

/// Source: oracle/codemp/qcommon/cm_load.cpp:32
let BOX_PLANES = 12 as Int32

/// Source: oracle/codemp/qcommon/cm_load.cpp:37
var cmg: ClipMap { world.storage.cmg }

/// Source: oracle/codemp/qcommon/cm_load.cpp:38
var c_pointcontents: Int32 {
    get { world.variables.c_pointcontents }
    set { world.variables.c_pointcontents = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:39
var c_traces: Int32 {
    get { world.variables.c_traces }
    set { world.variables.c_traces = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:39
var c_brush_traces: Int32 {
    get { world.variables.c_brush_traces }
    set { world.variables.c_brush_traces = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:39
var c_patch_traces: Int32 {
    get { world.variables.c_patch_traces }
    set { world.variables.c_patch_traces = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:42
var cmod_base: Slots<JKAShared.byte>? {
    get { world.variables.cmod_base }
    set { world.variables.cmod_base = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:45
var cm_noAreas: JKAMP.Cvar? {
    get { world.variables.cm_noAreas }
    set { world.variables.cm_noAreas = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:46
var cm_noCurves: JKAMP.Cvar? {
    get { world.variables.cm_noCurves }
    set { world.variables.cm_noCurves = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:47
var cm_playerCurveClip: JKAMP.Cvar? {
    get { world.variables.cm_playerCurveClip }
    set { world.variables.cm_playerCurveClip = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:50
var box_model: Cmodel { world.storage.box_model }

/// Source: oracle/codemp/qcommon/cm_load.cpp:51
var box_planes: JKAShared.Cplane? {
    get { world.variables.box_planes }
    set { world.variables.box_planes = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:52
var box_brush: Cbrush? {
    get { world.variables.box_brush }
    set { world.variables.box_brush = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:60
var SubBSP: Slots<ClipMap> { world.storage.SubBSP }

/// Source: oracle/codemp/qcommon/cm_load.cpp:61
var NumSubBSP: Int32 {
    get { world.variables.NumSubBSP }
    set { world.variables.NumSubBSP = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:61
var TotalSubModels: Int32 {
    get { world.variables.TotalSubModels }
    set { world.variables.TotalSubModels = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:453
let VIS_HEADER = 8 as Int32

/// Source: oracle/codemp/qcommon/cm_load.cpp:482
let MAX_PATCH_VERTS = 1024 as Int32

/// Source: oracle/codemp/qcommon/cm_load.cpp:568
var gpvCachedMapDiskImage: OpaquePointer? {
    get { world.variables.gpvCachedMapDiskImage }
    set { world.variables.gpvCachedMapDiskImage = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:569
var gsCachedMapDiskImage: JKAShared.CharBuf {
    get { world.variables.gsCachedMapDiskImage }
    set { world.variables.gsCachedMapDiskImage = newValue }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:570
var gbUsingCachedMapDataRightNow: Bool {
    get { world.variables.gbUsingCachedMapDataRightNow }
    set { world.variables.gbUsingCachedMapDataRightNow = newValue }
}

/**
```
=================
CMod_LoadShaders
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:76
func CMod_LoadShaders(_ l: JKAMP.Lump, _ cm: ClipMap) {
    let `in`: Slots<Dshader>
    var i: Int32
    let count: Int32
    var out: CmShader

    // AI: Raven walks the `dshader_t *` from the lump base. The Slots holds the records of the lump, and the index `i` takes the place of the walk.
    `in` = Slots<Dshader>(cmod_base!.suffix(from: l.fileofs), count: l.filelen / Int32(Dshader.byteCount))
    if l.filelen % Int32(Dshader.byteCount) != 0 {
        Com_Error(ERR_DROP, "CMod_LoadShaders: funny lump size")
    }
    count = l.filelen / Int32(Dshader.byteCount)

    if count < 1 {
        Com_Error(ERR_DROP, "Map with no shaders")
    }
    cm.shaders = CmShader(Hunk_Alloc((1 + count) * Int32(CmShader.byteCount), h_high))
    cm.numShaders = count

    i = 0
    while i < count {
        out = cm.shadersSlots[i]
        Q_strncpyz(&out.shaderBuffer, `in`[i].shader, MAX_QPATH)
        out.contentFlags = `in`[i].contentFlags
        out.surfaceFlags = `in`[i].surfaceFlags
        i += 1
    }
}

/**
```
=================
CMod_LoadSubmodels
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:109
func CMod_LoadSubmodels(_ l: JKAMP.Lump, _ cm: ClipMap) {
    let `in`: Slots<Dmodel>
    var out: Cmodel
    var i: Int32
    var j: Int32
    let count: Int32

    // AI: Raven walks the `dmodel_t *` from the lump base. The Slots holds the records of the lump, and the index `i` takes the place of the walk.
    `in` = Slots<Dmodel>(cmod_base!.suffix(from: l.fileofs), count: l.filelen / Int32(Dmodel.byteCount))
    if l.filelen % Int32(Dmodel.byteCount) != 0 {
        Com_Error(ERR_DROP, "CMod_LoadSubmodels: funny lump size")
    }
    count = l.filelen / Int32(Dmodel.byteCount)

    if count < 1 {
        Com_Error(ERR_DROP, "Map with no models")
    }
    cm.cmodels = Cmodel(Hunk_Alloc(count * Int32(Cmodel.byteCount), h_high))
    cm.numSubModels = count

    if count > MAX_SUBMODELS {
        Com_Error(ERR_DROP, "MAX_SUBMODELS exceeded")
    }

    i = 0
    while i < count {
        out = cm.cmodelsSlots[i]

        j = 0
        while j < 3 {
            // spread the mins / maxs by a pixel
            out.mins[j] = `in`[i].mins[j] - 1
            out.maxs[j] = `in`[i].maxs[j] + 1
            j += 1
        }

        //rwwRMG - sof2 doesn't have to add this &cm == &cmg check.
        //Are they getting leaf data elsewhere? (the reason this needs to be done is
        //in sub bsp instances the first brush model isn't necessary a world model and might be
        //real architecture)
        if i == 0 && cm == cmg {
            out.firstNode = 0
            i += 1
            continue // world model doesn't need other info
        }

        // make a "leaf" just to hold the model's brushes and surfaces
        out.firstNode = -1

        // make a "leaf" just to hold the model's brushes and surfaces
        out.leaf.numLeafBrushes = `in`[i].numBrushes
        var indexes = Slots<Int32>(scalars: Hunk_Alloc(out.leaf.numLeafBrushes * 4, h_high), count: Int(out.leaf.numLeafBrushes))
        // AI: Raven subtracts two hunk pointers. The view gives the word distance from the table, so the leaf keeps his number.
        out.leaf.firstLeafBrush = cm.leafbrushes(indexes)
        j = 0
        while j < out.leaf.numLeafBrushes {
            indexes[j] = `in`[i].firstBrush + j
            j += 1
        }

        out.leaf.numLeafSurfaces = `in`[i].numSurfaces
        indexes = Slots<Int32>(scalars: Hunk_Alloc(out.leaf.numLeafSurfaces * 4, h_high), count: Int(out.leaf.numLeafSurfaces))
        // AI: Raven subtracts two hunk pointers. The view gives the word distance from the table, so the leaf keeps his number.
        out.leaf.firstLeafSurface = cm.leafsurfaces(indexes)
        j = 0
        while j < out.leaf.numLeafSurfaces {
            indexes[j] = `in`[i].firstSurface + j
            j += 1
        }
        i += 1
    }
}

/**
```
=================
CMod_LoadNodes

=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:175
func CMod_LoadNodes(_ l: JKAMP.Lump, _ cm: ClipMap) {
    let `in`: Slots<Dnode>
    var child: Int32
    var out: CmNode
    var i: Int32
    var j: Int32
    let count: Int32

    // AI: Raven walks the `dnode_t *` from the lump base. The Slots holds the records of the lump, and the index `i` takes the place of the walk.
    `in` = Slots<Dnode>(cmod_base!.suffix(from: l.fileofs), count: l.filelen / Int32(Dnode.byteCount))
    if l.filelen % Int32(Dnode.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }
    count = l.filelen / Int32(Dnode.byteCount)

    if count < 1 {
        Com_Error(ERR_DROP, "Map has no nodes")
    }
    cm.nodes = CmNode(Hunk_Alloc(count * Int32(CmNode.byteCount), h_high))
    cm.numNodes = count

    i = 0
    while i < count {
        out = cm.nodesSlots[i]
        out.plane = cm.planesSlots[`in`[i].planeNum]
        j = 0
        while j < 2 {
            child = `in`[i].children[j]
            out.children[j] = child
            j += 1
        }
        i += 1
    }

}

/**
```
=================
CM_BoundBrush

=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:211
func CM_BoundBrush(_ b: Cbrush) {
    b.bounds[0][0] = -b.sidesSlots[0].plane!.dist
    b.bounds[1][0] = b.sidesSlots[1].plane!.dist

    b.bounds[0][1] = -b.sidesSlots[2].plane!.dist
    b.bounds[1][1] = b.sidesSlots[3].plane!.dist

    b.bounds[0][2] = -b.sidesSlots[4].plane!.dist
    b.bounds[1][2] = b.sidesSlots[5].plane!.dist
}

/**
```
=================
CMod_LoadBrushes

=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:229
func CMod_LoadBrushes(_ l: JKAMP.Lump, _ cm: ClipMap) {
    let `in`: Slots<Dbrush>
    var out: Cbrush
    var i: Int32
    let count: Int32

    // AI: Raven walks the `dbrush_t *` from the lump base. The Slots holds the records of the lump, and the index `i` takes the place of the walk.
    `in` = Slots<Dbrush>(cmod_base!.suffix(from: l.fileofs), count: l.filelen / Int32(Dbrush.byteCount))
    if l.filelen % Int32(Dbrush.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }
    count = l.filelen / Int32(Dbrush.byteCount)

    cm.brushes = Cbrush(Hunk_Alloc((BOX_BRUSHES + count) * Int32(Cbrush.byteCount), h_high))
    cm.numBrushes = count

    i = 0
    while i < count {
        out = cm.brushesSlots[i]
        out.sides = cm.brushsidesSlots[`in`[i].firstSide]
        out.numsides = `in`[i].numSides

        out.shaderNum = `in`[i].shaderNum
        if out.shaderNum < 0 || out.shaderNum >= cm.numShaders {
            Com_Error(ERR_DROP, "CMod_LoadBrushes: bad shaderNum: %i", out.shaderNum)
        }
        out.contents = cm.shadersSlots[out.shaderNum].contentFlags

        // Landscapes are set up afterwards in the entity spawning
        //out->landscape = NULL;	//the memory was cleared already by hunk_alloc
        //out->checkcount=0;

        CM_BoundBrush(out)
        i += 1
    }

}

/**
```
=================
CMod_LoadLeafs
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:269
func CMod_LoadLeafs(_ l: JKAMP.Lump, _ cm: ClipMap) {
    var i: Int32
    var out: CLeaf
    let `in`: Slots<Dleaf>
    let count: Int32

    // AI: Raven walks the `dleaf_t *` from the lump base. The Slots holds the records of the lump, and the index `i` takes the place of the walk.
    `in` = Slots<Dleaf>(cmod_base!.suffix(from: l.fileofs), count: l.filelen / Int32(Dleaf.byteCount))
    if l.filelen % Int32(Dleaf.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }
    count = l.filelen / Int32(Dleaf.byteCount)

    if count < 1 {
        Com_Error(ERR_DROP, "Map with no leafs")
    }

    cm.leafs = CLeaf(Hunk_Alloc((BOX_LEAFS + count) * Int32(CLeaf.byteCount), h_high))
    cm.numLeafs = count

    i = 0
    while i < count {
        out = cm.leafsSlots[i]
        out.cluster = `in`[i].cluster
        out.area = `in`[i].area
        out.firstLeafBrush = `in`[i].firstLeafBrush
        out.numLeafBrushes = `in`[i].numLeafBrushes
        out.firstLeafSurface = `in`[i].firstLeafSurface
        out.numLeafSurfaces = `in`[i].numLeafSurfaces

        if out.cluster >= cm.numClusters {
            cm.numClusters = out.cluster + 1
        }
        if out.area >= cm.numAreas {
            cm.numAreas = out.area + 1
        }
        i += 1
    }

    cm.areas = CArea(Hunk_Alloc(cm.numAreas * Int32(CArea.byteCount), h_high))
    cm.areaPortals = Slots(scalars: Hunk_Alloc(cm.numAreas * cm.numAreas * Int32(Int32.byteCount), h_high), count: Int(cm.numAreas * cm.numAreas))
}

/**
```
=================
CMod_LoadPlanes
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:312
func CMod_LoadPlanes(_ l: JKAMP.Lump, _ cm: ClipMap) {
    var i: Int32
    var j: Int32
    var out: Cplane
    let `in`: Slots<Dplane>
    let count: Int32
    var bits: Int32

    // AI: Raven walks the `dplane_t *` from the lump base. The Slots holds the records of the lump, and the index `i` takes the place of the walk.
    `in` = Slots<Dplane>(cmod_base!.suffix(from: l.fileofs), count: l.filelen / Int32(Dplane.byteCount))
    if l.filelen % Int32(Dplane.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }
    count = l.filelen / Int32(Dplane.byteCount)

    if count < 1 {
        Com_Error(ERR_DROP, "Map with no planes")
    }
    cm.planes = Cplane(Hunk_Alloc((BOX_PLANES + count) * Int32(Cplane.byteCount), h_high))
    cm.numPlanes = count

    i = 0
    while i < count {
        out = cm.planesSlots[i]
        bits = 0
        j = 0
        while j < 3 {
            out.normal[j] = `in`[i].normal[j]
            if out.normal[j] < 0 {
                bits |= 1 << j
            }
            j += 1
        }

        out.dist = `in`[i].dist
        out.type = PlaneTypeForNormal(out.normal)
        out.signbits = bits
        i += 1
    }
}

/**
```
=================
CMod_LoadLeafBrushes
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:353
func CMod_LoadLeafBrushes(_ l: JKAMP.Lump, _ cm: ClipMap) {
    var i: Int32
    let `in`: Slots<JKAShared.byte>
    let count: Int32

    // AI: Raven walks an `int *` from the lump base. The body reads the word at byte offset `i * 4` of the lump, and the index `i` takes the place of the walk.
    `in` = cmod_base!.suffix(from: l.fileofs)
    if l.filelen % Int32(Int32.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }
    count = l.filelen / Int32(Int32.byteCount)

    cm.leafbrushes = Slots(scalars: Hunk_Alloc((count + BOX_BRUSHES) * Int32(Int32.byteCount), h_high), count: Int(count + BOX_BRUSHES))
    cm.numLeafBrushes = count

    i = 0
    while i < count {
        cm.leafbrushes![i] = `in`[int: i * Int32(Int32.byteCount)]
        i += 1
    }
}

/**
```
=================
CMod_LoadLeafSurfaces
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:380
func CMod_LoadLeafSurfaces(_ l: JKAMP.Lump, _ cm: ClipMap) {
    var i: Int32
    let `in`: Slots<JKAShared.byte>
    let count: Int32

    // AI: Raven walks an `int *` from the lump base. The body reads the word at byte offset `i * 4` of the lump, and the index `i` takes the place of the walk.
    `in` = cmod_base!.suffix(from: l.fileofs)
    if l.filelen % Int32(Int32.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }
    count = l.filelen / Int32(Int32.byteCount)

    cm.leafsurfaces = Slots(scalars: Hunk_Alloc(count * Int32(Int32.byteCount), h_high), count: Int(count))
    cm.numLeafSurfaces = count

    i = 0
    while i < count {
        cm.leafsurfaces![i] = `in`[int: i * Int32(Int32.byteCount)]
        i += 1
    }
}

/**
```
=================
CMod_LoadBrushSides
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:407
func CMod_LoadBrushSides(_ l: JKAMP.Lump, _ cm: ClipMap) {
    var i: Int32
    var out: Cbrushside
    let `in`: Slots<Dbrushside>
    let count: Int32
    var num: Int32

    // AI: Raven walks the `dbrushside_t *` from the lump base. The Slots holds the records of the lump, and the index `i` takes the place of the walk.
    `in` = Slots<Dbrushside>(cmod_base!.suffix(from: l.fileofs), count: l.filelen / Int32(Dbrushside.byteCount))
    if l.filelen % Int32(Dbrushside.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }
    count = l.filelen / Int32(Dbrushside.byteCount)

    cm.brushsides = Cbrushside(Hunk_Alloc((BOX_SIDES + count) * Int32(Cbrushside.byteCount), h_high))
    cm.numBrushSides = count

    i = 0
    while i < count {
        out = cm.brushsidesSlots[i]
        num = `in`[i].planeNum
        out.plane = cm.planesSlots[num]
        out.shaderNum = `in`[i].shaderNum
        if out.shaderNum < 0 || out.shaderNum >= cm.numShaders {
            Com_Error(ERR_DROP, "CMod_LoadBrushSides: bad shaderNum: %i", out.shaderNum)
        }
        i += 1
    }
}

/**
```
=================
CMod_LoadEntityString
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:442
func CMod_LoadEntityString(_ l: JKAMP.Lump, _ cm: ClipMap) {
    // AI: Raven copies the lump into a hunk block that `entityString` points at. The call stays for the zone count, and the text goes through a CharBuf into the string pool.
    _ = Hunk_Alloc(l.filelen, h_high)
    cm.numEntityChars = l.filelen
    var entityString = CharBuf(l.filelen)
    Com_Memcpy(&entityString, cmod_base!.suffix(from: l.fileofs), l.filelen)
    cm.entityString = String(entityString)
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:454
func CMod_LoadVisibility(_ l: JKAMP.Lump, _ cm: ClipMap) {
    let len: Int32
    let buf: Slots<JKAShared.byte>

    len = l.filelen
    if len == 0 {
        cm.clusterBytes = (cm.numClusters + 31) & ~31
        cm.visibility = Slots(scalars: Hunk_Alloc(cm.clusterBytes, h_high), count: Int(cm.clusterBytes))
        Com_Memset(cm.visibility!, 255, cm.clusterBytes)
        return
    }
    buf = cmod_base!.suffix(from: l.fileofs)

    cm.vised = true
    cm.visibility = Slots(scalars: Hunk_Alloc(len, h_high), count: Int(len))
    cm.numClusters = buf[int: 0]
    cm.clusterBytes = buf[int: 4]
    Com_Memcpy(cm.visibility!, buf.suffix(from: VIS_HEADER), len - VIS_HEADER)
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:483
func CMod_LoadPatches(_ surfs: JKAMP.Lump, _ verts: JKAMP.Lump, _ cm: ClipMap) {
    let dv: Slots<DrawVert>
    var dv_p: Int32
    let `in`: Slots<Dsurface>
    let count: Int32
    var i: Int32
    var j: Int32
    var c: Int32
    var patch: CPatch
    var points = [JKAShared.vec3_t](repeating: vec3_t(), count: Int(MAX_PATCH_VERTS))
    var width: Int32
    var height: Int32
    var shaderNum: Int32

    // AI: Raven walks the `dsurface_t *` from the lump base. The Slots holds the records of the lump, and the index `i` takes the place of the walk.
    `in` = Slots<Dsurface>(cmod_base!.suffix(from: surfs.fileofs), count: surfs.filelen / Int32(Dsurface.byteCount))
    if surfs.filelen % Int32(Dsurface.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }
    count = surfs.filelen / Int32(Dsurface.byteCount)
    cm.numSurfaces = count
    cm.surfaces = Slots(pointers: Hunk_Alloc(cm.numSurfaces * Int32(OpaquePointer.byteCount), h_high), count: Int(cm.numSurfaces))

    dv = Slots<DrawVert>(cmod_base!.suffix(from: verts.fileofs), count: verts.filelen / Int32(DrawVert.byteCount))
    if verts.filelen % Int32(DrawVert.byteCount) != 0 {
        Com_Error(ERR_DROP, "MOD_LoadBmodel: funny lump size")
    }

    // scan through all the surfaces, but only load patches,
    // not planar faces
    i = 0
    while i < count {
        if `in`[i].surfaceType != MST_PATCH {
            i += 1
            continue // ignore other surfaces
        }
        // FIXME: check for non-colliding patches

        patch = CPatch(Hunk_Alloc(Int32(CPatch.byteCount), h_high))
        cm.surfaces![i] = patch

        // load the full drawverts onto the stack
        width = `in`[i].patchWidth
        height = `in`[i].patchHeight
        c = width * height
        if c > MAX_PATCH_VERTS {
            Com_Error(ERR_DROP, "ParseMesh: MAX_PATCH_VERTS")
        }

        dv_p = `in`[i].firstVert
        j = 0
        while j < c {
            points[j][0] = dv[dv_p].xyz[0]
            points[j][1] = dv[dv_p].xyz[1]
            points[j][2] = dv[dv_p].xyz[2]
            j += 1
            dv_p += 1
        }

        shaderNum = `in`[i].shaderNum
        patch.contents = cm.shadersSlots[shaderNum].contentFlags
        patch.surfaceFlags = cm.shadersSlots[shaderNum].surfaceFlags

        // create the internal facet structure
        // Port-note: CM_GeneratePatchCollide takes `points` as one `inout vec3_t`, and Raven passes the array `vec3_t points[MAX_PATCH_VERTS]`.
        // Raven wrote: patch->pc = CM_GeneratePatchCollide( width, height, points );
        portMissing("CMod_LoadPatches", source: "oracle/codemp/qcommon/cm_load.cpp:483")
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:540
func CM_LumpChecksum(_ lump: JKAMP.Lump) -> UInt32 {
    return Com_BlockChecksum(cmod_base!.suffix(from: lump.fileofs), lump.filelen)
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:544
func CM_Checksum(_ header: Dheader) -> UInt32 {
    var checksums: [UInt32] = [UInt32](repeating: 0, count: 16)
    checksums[0] = CM_LumpChecksum(header.lumps[LUMP_SHADERS])
    checksums[1] = CM_LumpChecksum(header.lumps[LUMP_LEAFS])
    checksums[2] = CM_LumpChecksum(header.lumps[LUMP_LEAFBRUSHES])
    checksums[3] = CM_LumpChecksum(header.lumps[LUMP_LEAFSURFACES])
    checksums[4] = CM_LumpChecksum(header.lumps[LUMP_PLANES])
    checksums[5] = CM_LumpChecksum(header.lumps[LUMP_BRUSHSIDES])
    checksums[6] = CM_LumpChecksum(header.lumps[LUMP_BRUSHES])
    checksums[7] = CM_LumpChecksum(header.lumps[LUMP_MODELS])
    checksums[8] = CM_LumpChecksum(header.lumps[LUMP_NODES])
    checksums[9] = CM_LumpChecksum(header.lumps[LUMP_SURFACES])
    checksums[10] = CM_LumpChecksum(header.lumps[LUMP_DRAWVERTS])

    // Port-note: Com_BlockChecksum takes a Slots of bytes, and the local `unsigned checksums[16]` is a Swift Array with no Slots form. The function has no caller, rule 20.
    // Raven wrote: return LittleLong(Com_BlockChecksum(checksums, 11 * 4))
    portMissing("CM_Checksum", source: "oracle/codemp/qcommon/cm_load.cpp:544")
}

// called in response to a "devmapbsp blah" or "devmapall blah" command, do NOT use inside CM_Load unless you pass in qtrue
//
// new bool return used to see if anything was freed, used during z_malloc failure re-try
//
/// Source: oracle/codemp/qcommon/cm_load.cpp:576
func CM_DeleteCachedMap(_ bGuaranteedOkToDelete: Bool) -> Bool {
    var bActuallyFreedSomething: Bool = false

    if bGuaranteedOkToDelete || !gbUsingCachedMapDataRightNow {
        // dump cached disk image...
        //
        if gpvCachedMapDiskImage != nil {
            Z_Free(gpvCachedMapDiskImage)
            gpvCachedMapDiskImage = nil

            bActuallyFreedSomething = true
        }
        gsCachedMapDiskImage[0] = 0

        // force map loader to ignore cached internal BSP structures for next level CM_LoadMap() call...
        //
        cmg.nameBuffer[0] = 0
    }

    return bActuallyFreedSomething
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:605
private func CM_LoadMap_Actual(_ name: String, _ clientload: Bool, _ checksum: inout Int32, _ cm: ClipMap) { //rwwRMG - function needs heavy modification
    var buf: Slots<JKAShared.byte>?
    var origName = CharBuf(MAX_OSPATH)
    var newBuff: OpaquePointer? = nil

    Dheader.scratch { header in
        var i: Int32

        if name.isEmpty {
            Com_Error(ERR_DROP, "CM_LoadMap: NULL name")
        }

        cm_noAreas = Cvar_Get("cm_noAreas", "0", CVAR_CHEAT)
        cm_noCurves = Cvar_Get("cm_noCurves", "0", CVAR_CHEAT)
        cm_playerCurveClip = Cvar_Get("cm_playerCurveClip", "1", CVAR_ARCHIVE | CVAR_CHEAT)
        Com_DPrintf("CM_LoadMap( %s, %i )\n", name, clientload ? 1 : 0)

        if strcmp(cm.name, name) == 0 && clientload {
            // C converts the unsigned checksum to `int` at the store.
            checksum = Int32(bitPattern: last_checksum)
            return
        }

        strcpy(&origName, name)

        if cm == cmg {
            // free old stuff
            CM_ClearMap()
            CM_ClearLevelPatches()
        }

        // free old stuff
        cm.clear()

        if name.isEmpty {
            cm.numLeafs = 1
            cm.numClusters = 1
            cm.numAreas = 1
            cm.cmodels = Cmodel(Hunk_Alloc(Int32(Cmodel.byteCount), h_high))
            checksum = 0
            return
        }

        //
        // load the file
        //
        //rww - Doesn't this sort of defeat the purpose? We're clearing it even if the map is the same as the last one!
        //Not touching it though in case I'm just overlooking something.
        if gpvCachedMapDiskImage != nil && cm == cmg { // MP code: this'll only be NZ if we got an ERR_DROP during last map load,
            //	so it's really just a safety measure.
            Z_Free(gpvCachedMapDiskImage)
            gpvCachedMapDiskImage = nil
        }

        //
        // load the file into a buffer that we either discard as usual at the bottom, or if we've got enough memory
        //	then keep it long enough to save the renderer re-loading it (if not dedicated server),
        //	then discard it after that...
        //
        buf = nil
        var h: JKAShared.fileHandle_t = 0
        let iBSPLen: Int32 = FS_FOpenFileRead(name, &h, false)
        if h != 0 {
            let block = Z_Malloc(iBSPLen, TAG_BSP_DISKIMAGE)
            // AI: Raven stores the `void *` of the block in `newBuff`. The store is the handle of the block.
            newBuff = OpaquePointer(block)
            // AI: Raven hands the `void *` of the block to FS_Read. The call hands the Slots over the `iBSPLen` bytes of the block.
            FS_Read(Slots(scalars: block, count: Int(iBSPLen)), iBSPLen, h)
            FS_FCloseFile(h)

            buf = Slots(scalars: block, count: Int(iBSPLen)) // so the rest of the code works as normal
            if cm == cmg {
                gpvCachedMapDiskImage = newBuff
                newBuff = nil
            }

            // carry on as before...
            //
        }

        if buf == nil {
            Com_Error(ERR_DROP, "Couldn't load %s", name)
        }

        last_checksum = Com_BlockChecksum(buf!, iBSPLen)
        // C converts the unsigned checksum to `int` at the store.
        checksum = Int32(bitPattern: last_checksum)

        header.copy(from: Slots<Dheader>(buf!, count: 1)[0])
        i = 0
        while i < Int32(Dheader.byteCount) / 4 {
            Slots(record: header).bytes[int: i * 4] = Slots(record: header).bytes[int: i * 4]
            i += 1
        }

        if header.version != BSP_VERSION {
            Z_Free(gpvCachedMapDiskImage)
            gpvCachedMapDiskImage = nil

            Com_Error(ERR_DROP, "CM_LoadMap: %s has wrong version number (%i should be %i)", name, header.version, BSP_VERSION)
        }

        cmod_base = buf

        // load into heap
        CMod_LoadShaders(header.lumps[LUMP_SHADERS], cm)
        CMod_LoadLeafs(header.lumps[LUMP_LEAFS], cm)
        CMod_LoadLeafBrushes(header.lumps[LUMP_LEAFBRUSHES], cm)
        CMod_LoadLeafSurfaces(header.lumps[LUMP_LEAFSURFACES], cm)
        CMod_LoadPlanes(header.lumps[LUMP_PLANES], cm)
        CMod_LoadBrushSides(header.lumps[LUMP_BRUSHSIDES], cm)
        CMod_LoadBrushes(header.lumps[LUMP_BRUSHES], cm)
        CMod_LoadSubmodels(header.lumps[LUMP_MODELS], cm)
        CMod_LoadNodes(header.lumps[LUMP_NODES], cm)
        CMod_LoadEntityString(header.lumps[LUMP_ENTITIES], cm)
        CMod_LoadVisibility(header.lumps[LUMP_VISIBILITY], cm)
        CMod_LoadPatches(header.lumps[LUMP_SURFACES], header.lumps[LUMP_DRAWVERTS], cm)

        TotalSubModels += cm.numSubModels

        if cm == cmg {
            // Load in the shader text - return instantly if already loaded
            CM_LoadShaderText(false)
            CM_InitBoxHull()
            CM_SetupShaderProperties()
        }

        // I hope we can lose this crap soon
        //
        // if we've got enough memory, and it's not a dedicated-server, then keep the loaded map binary around
        //	for the renderer to chew on... (but not if this gets ported to a big-endian machine, because some of the
        //	map data will have been Little-Long'd, but some hasn't).
        //
        if Sys_LowPhysicalMemory()
            || com_dedicated!.integer != 0
        //		|| we're on a big-endian machine
        {
            Z_Free(gpvCachedMapDiskImage)
            gpvCachedMapDiskImage = nil
        } else {
            // ... do nothing, and let the renderer free it after it's finished playing with it...
            //
        }

        CM_FloodAreaConnections(cm)

        // allow this to be cached if it is loaded by the server
        if !clientload {
            Q_strncpyz(&cm.nameBuffer, String(origName), MAX_QPATH)
        }
    }
}

/// Raven's `static unsigned last_checksum` of `CM_LoadMap_Actual`.
/// Source: oracle/codemp/qcommon/cm_load.cpp:610
var last_checksum: UInt32 {
    get { world.last_checksum }
    set { world.last_checksum = newValue }
}

// need a wrapper function around this because of multiple returns, need to ensure bool is correct...
//
/// Source: oracle/codemp/qcommon/cm_load.cpp:775
func CM_LoadMap(_ name: String, _ clientload: Bool, _ checksum: inout Int32) {
    gbUsingCachedMapDataRightNow = true // !!!!!!!!!!!!!!!!!!

    CM_LoadMap_Actual(name, clientload, &checksum, cmg)

    gbUsingCachedMapDataRightNow = false // !!!!!!!!!!!!!!!!!!
}

/**
```
==================
CM_ClearMap
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:791
func CM_ClearMap() {
    var i: Int32

    CM_ShutdownShaderProperties()
    //	MAT_Shutdown();

    // Port-note: Row CM6. `TheRandomMissionManager` of RM_Manager.cpp:23 is a `CRMManager *` of the C++ track, so the stem of stage E5 gives it no storage.
    // Raven wrote: if (TheRandomMissionManager) { delete TheRandomMissionManager; TheRandomMissionManager = 0; }
    portMissing("CM_ClearMap", source: "oracle/codemp/qcommon/cm_load.cpp:791")

    if cmg.landScape != nil {
        // Port-note: Row CM6. `CCMLandScape` of cm_landscape.h:135 is a class of the C++ track, and stage E5 gives its destructor no Swift name.
        // Raven wrote: delete cmg.landScape;
        portMissing("CM_ClearMap", source: "oracle/codemp/qcommon/cm_load.cpp:791")
        cmg.landScape = nil
    }

    cmg.clear()
    CM_ClearLevelPatches()

    i = 0
    while i < NumSubBSP {
        SubBSP[i].clear()
        i += 1
    }
    NumSubBSP = 0
    TotalSubModels = 0
}

/**
```
==================
CM_ClipHandleToModel
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:828
func CM_ClipHandleToModel(_ handle: JKAShared.clipHandle_t, _ clipMap: inout ClipMap?) -> Cmodel? {
    var i: Int32
    var count: Int32

    if handle < 0 {
        Com_Error(ERR_DROP, "CM_ClipHandleToModel: bad handle %i", handle)
    }
    if handle < cmg.numSubModels {
        clipMap = cmg
        return cmg.cmodelsSlots[handle]
    }
    if handle == BOX_MODEL_HANDLE {
        clipMap = cmg
        return box_model
    }

    count = cmg.numSubModels
    i = 0
    while i < NumSubBSP {
        if handle < count + SubBSP[i].numSubModels {
            clipMap = SubBSP[i]
            return SubBSP[i].cmodelsSlots[handle - count]
        }
        count += SubBSP[i].numSubModels
        i += 1
    }

    if handle < MAX_SUBMODELS {
        Com_Error(ERR_DROP, "CM_ClipHandleToModel: bad handle %i < %i < %i", cmg.numSubModels, handle, MAX_SUBMODELS)
    }
    Com_Error(ERR_DROP, "CM_ClipHandleToModel: bad handle %i", handle + MAX_SUBMODELS)

    return nil
}

/**
```
==================
CM_InlineModel
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:882
func CM_InlineModel(_ index: Int32) -> JKAShared.clipHandle_t {
    if index < 0 || index >= TotalSubModels {
        Com_Error(ERR_DROP, "CM_InlineModel: bad number: %d > %d", index, TotalSubModels)
    }
    return index
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:890
func CM_NumClusters() -> Int32 {
    return cmg.numClusters
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:894
func CM_NumInlineModels() -> Int32 {
    return cmg.numSubModels
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:898
func CM_EntityString() -> String {
    return cmg.entityString!
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:902
func CM_SubBSPEntityString(_ index: Int32) -> String {
    return SubBSP[index].entityString!
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:907
func CM_LeafCluster(_ leafnum: Int32) -> Int32 {
    if leafnum < 0 || leafnum >= cmg.numLeafs {
        Com_Error(ERR_DROP, "CM_LeafCluster: bad number")
    }
    return cmg.leafsSlots[leafnum].cluster
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:914
func CM_LeafArea(_ leafnum: Int32) -> Int32 {
    if leafnum < 0 || leafnum >= cmg.numLeafs {
        Com_Error(ERR_DROP, "CM_LeafArea: bad number")
    }
    return cmg.leafsSlots[leafnum].area
}

/**
```
===================
CM_InitBoxHull

Set up the planes and nodes so that the six floats of a bounding box
can just be stored out and get a proper clipping hull structure.
===================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:932
func CM_InitBoxHull() {
    var i: Int32
    var side: Int32
    var p: Cplane?
    var s: Cbrushside?

    box_planes = cmg.planesSlots[cmg.numPlanes]

    box_brush = cmg.brushesSlots[cmg.numBrushes]
    box_brush!.numsides = 6
    box_brush!.sides = cmg.brushsidesSlots[cmg.numBrushSides]
    box_brush!.contents = CONTENTS_BODY

    box_model.firstNode = -1
    box_model.leaf.numLeafBrushes = 1
    //	box_model.leaf.firstLeafBrush = cmg.numBrushes;
    box_model.leaf.firstLeafBrush = cmg.numLeafBrushes
    cmg.leafbrushes![cmg.numLeafBrushes] = cmg.numBrushes

    i = 0
    while i < 6 {
        side = i & 1

        // brush sides
        s = cmg.brushsidesSlots[cmg.numBrushSides + i]
        s!.plane = cmg.planesSlots[cmg.numPlanes + i * 2 + side]
        s!.shaderNum = cmg.numShaders

        // planes
        p = box_planes![i * 2]
        p!.type = i >> 1
        p!.signbits = 0
        p!.normal = vec3_t()
        p!.normal[i >> 1] = 1

        p = box_planes![i * 2 + 1]
        p!.type = 3 + (i >> 1)
        p!.signbits = 0
        p!.normal = vec3_t()
        p!.normal[i >> 1] = -1

        // AI: Raven hands the `cplane_t *` to SetPlaneSignbits. The value function of q_math takes the plane read out of the slot, and `apply` writes it back.
        var plane = p!.plane
        SetPlaneSignbits(&plane)
        p!.apply(plane)
        i += 1
    }
}

/**
```
===================
CM_TempBoxModel

To keep everything totally uniform, bounding boxes are turned into small
BSP trees instead of being compared directly.
Capsules are handled differently though.
===================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:987
func CM_TempBoxModel(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ capsule: Int32) -> JKAShared.clipHandle_t {
    box_model.mins = mins
    box_model.maxs = maxs

    if capsule != 0 {
        return CAPSULE_MODEL_HANDLE
    }

    box_planes![0].dist = maxs[0]
    box_planes![1].dist = -maxs[0]
    box_planes![2].dist = mins[0]
    box_planes![3].dist = -mins[0]
    box_planes![4].dist = maxs[1]
    box_planes![5].dist = -maxs[1]
    box_planes![6].dist = mins[1]
    box_planes![7].dist = -mins[1]
    box_planes![8].dist = maxs[2]
    box_planes![9].dist = -maxs[2]
    box_planes![10].dist = mins[2]
    box_planes![11].dist = -mins[2]

    box_brush!.bounds[0] = mins
    box_brush!.bounds[1] = maxs

    return BOX_MODEL_HANDLE
}

/**
```
===================
CM_ModelBounds
===================
```
*/
/// Source: oracle/codemp/qcommon/cm_load.cpp:1020
func CM_ModelBounds(_ model: JKAShared.clipHandle_t, _ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t) {
    var cmod: Cmodel?

    // AI: Raven passes no `clipMap`, the default NULL of the declaration. The call hands a local that the body drops, because the parameter has no default.
    var clipMap: ClipMap? = nil
    cmod = CM_ClipHandleToModel(model, &clipMap)
    mins = cmod!.mins
    maxs = cmod!.maxs
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:1036
// TODO: Port signature
// Raven wrote: CCMLandScape *CM_RegisterTerrain(const char *config, bool server)
// No table row for the return `CCMLandScape *`.
func CM_RegisterTerrain() -> Never {
    // TODO: Port CM_RegisterTerrain
    portMissing("CM_RegisterTerrain", source: "oracle/codemp/qcommon/cm_load.cpp:1036")
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:1065
func CM_ShutdownTerrain(_ terrainId: JKAShared.thandle_t) {
    var landscape: OpaquePointer?

    landscape = cmg.landScape

    if landscape != nil {
        // Port-note: Row CM6. `CCMLandScape` of cm_landscape.h:135 is a class of the C++ track, and stage E5 gives its methods no Swift name.
        // Raven wrote: landscape->DecreaseRefCount(); if(landscape->GetRefCount() <= 0) { delete landscape; cmg.landScape = NULL; }
        portMissing("CM_ShutdownTerrain", source: "oracle/codemp/qcommon/cm_load.cpp:1065")
    }
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:1083
func CM_LoadSubBSP(_ name: String, _ clientload: Bool) -> Int32 {
    var i: Int32
    var checksum: Int32 = 0
    var count: Int32

    count = cmg.numSubModels
    i = 0
    while i < NumSubBSP {
        if strcasecmp(name, SubBSP[i].name) == 0 {
            return count
        }
        count += SubBSP[i].numSubModels
        i += 1
    }

    if NumSubBSP == MAX_SUB_BSP {
        Com_Error(ERR_DROP, "CM_LoadSubBSP: too many unique sub BSPs")
    }

    CM_LoadMap_Actual(name, clientload, &checksum, SubBSP[NumSubBSP])
    NumSubBSP += 1

    return count
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:1110
func CM_FindSubBSP(_ modelIndex: Int32) -> Int32 {
    var i: Int32
    var count: Int32

    count = cmg.numSubModels
    if modelIndex < count {
        // belongs to the main bsp
        return -1
    }

    i = 0
    while i < NumSubBSP {
        count += SubBSP[i].numSubModels
        if modelIndex < count {
            return i
        }
        i += 1
    }
    return -1
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:1132
func CM_GetWorldBounds(_ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t) {
    mins = cmg.cmodelsSlots[0].mins
    maxs = cmg.cmodelsSlots[0].maxs
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:1138
func CM_ModelContents_Actual(_ model: JKAShared.clipHandle_t, _ cm: ClipMap?) -> Int32 {
    var cmod: Cmodel?
    var contents: Int32 = 0
    var i: Int32
    // Raven assigns his own `cm` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var cm = cm

    if cm == nil {
        cm = cmg
    }

    cmod = CM_ClipHandleToModel(model, &cm)

    //MCG ADDED - return the contents, too
    if cmod!.leaf.numLeafBrushes != 0 {
        var brushNum: Int32
        i = cmod!.leaf.firstLeafBrush
        while i < cmod!.leaf.firstLeafBrush + cmod!.leaf.numLeafBrushes {
            // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
            brushNum = cm!.leafbrush(at: i)
            contents |= cm!.brushesSlots[brushNum].contents
            i += 1
        }
    }
    if cmod!.leaf.numLeafSurfaces != 0 {
        var surfaceNum: Int32
        i = cmod!.leaf.firstLeafSurface
        while i < cmod!.leaf.firstLeafSurface + cmod!.leaf.numLeafSurfaces {
            // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
            surfaceNum = cm!.leafsurface(at: i)
            if cm!.surfaces![surfaceNum] != nil { //HERNH? How could we have a null surf within our cmod->leaf.numLeafSurfaces?
                contents |= cm!.surfaces![surfaceNum]!.contents
            }
            i += 1
        }
    }
    return contents
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:1176
func CM_ModelContents(_ model: JKAShared.clipHandle_t, _ subBSPIndex: Int32) -> Int32 {
    if subBSPIndex < 0 {
        return CM_ModelContents_Actual(model, nil)
    }

    return CM_ModelContents_Actual(model, SubBSP[subBSPIndex])
}
