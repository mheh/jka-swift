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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadShaders
    portMissing("CMod_LoadShaders", source: "oracle/codemp/qcommon/cm_load.cpp:29")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadSubmodels
    portMissing("CMod_LoadSubmodels", source: "oracle/codemp/qcommon/cm_load.cpp:109")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadNodes
    portMissing("CMod_LoadNodes", source: "oracle/codemp/qcommon/cm_load.cpp:175")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadBrushes
    portMissing("CMod_LoadBrushes", source: "oracle/codemp/qcommon/cm_load.cpp:229")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadLeafs
    portMissing("CMod_LoadLeafs", source: "oracle/codemp/qcommon/cm_load.cpp:269")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadPlanes
    portMissing("CMod_LoadPlanes", source: "oracle/codemp/qcommon/cm_load.cpp:312")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadLeafBrushes
    portMissing("CMod_LoadLeafBrushes", source: "oracle/codemp/qcommon/cm_load.cpp:353")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadLeafSurfaces
    portMissing("CMod_LoadLeafSurfaces", source: "oracle/codemp/qcommon/cm_load.cpp:380")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadBrushSides
    portMissing("CMod_LoadBrushSides", source: "oracle/codemp/qcommon/cm_load.cpp:407")
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
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadEntityString
    portMissing("CMod_LoadEntityString", source: "oracle/codemp/qcommon/cm_load.cpp:442")
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:454
func CMod_LoadVisibility(_ l: JKAMP.Lump, _ cm: ClipMap) {
    let len: Int32
    // Port-note: A pointer local `byte * buf` with no view.
    // Raven wrote: byte *buf;
    portMissing("CMod_LoadVisibility", source: "oracle/codemp/qcommon/cm_load.cpp:454")

    len = l.filelen
    if len == 0 {
        cm.clusterBytes = (cm.numClusters + 31) & ~31
        // Port-note: Raven reads `cm.visibility`, a `byte *` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.
        // Raven wrote: cm.visibility = (unsigned char *)Hunk_Alloc( cm.clusterBytes, h_high )
        portMissing("CMod_LoadVisibility", source: "oracle/codemp/qcommon/cm_load.cpp:454")
        // Port-note: Raven reads `cm.visibility`, a `byte *` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.
        // Raven wrote: Com_Memset( cm.visibility, 255, cm.clusterBytes )
        portMissing("CMod_LoadVisibility", source: "oracle/codemp/qcommon/cm_load.cpp:454")
        return
    }
    // Port-note: A store into `buf`, a local the draft left as a hole.
    // Raven wrote: buf = cmod_base + l->fileofs
    portMissing("CMod_LoadVisibility", source: "oracle/codemp/qcommon/cm_load.cpp:454")

    cm.vised = true
    // Port-note: Raven reads `cm.visibility`, a `byte *` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.
    // Raven wrote: cm.visibility = (unsigned char *)Hunk_Alloc( len, h_high )
    portMissing("CMod_LoadVisibility", source: "oracle/codemp/qcommon/cm_load.cpp:454")
    // Port-note: An unexposed expression with 2 children.
    // Raven wrote: cm.numClusters = LittleLong( ((int *)buf)[0] )
    portMissing("CMod_LoadVisibility", source: "oracle/codemp/qcommon/cm_load.cpp:454")
    // Port-note: An unexposed expression with 2 children.
    // Raven wrote: cm.clusterBytes = LittleLong( ((int *)buf)[1] )
    portMissing("CMod_LoadVisibility", source: "oracle/codemp/qcommon/cm_load.cpp:454")
    // Port-note: Raven reads `cm.visibility`, a `byte *` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.
    // Raven wrote: Com_Memcpy (cm.visibility, buf + VIS_HEADER, len - VIS_HEADER )
    portMissing("CMod_LoadVisibility", source: "oracle/codemp/qcommon/cm_load.cpp:454")
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:483
func CMod_LoadPatches(_ surfs: JKAMP.Lump, _ verts: JKAMP.Lump, _ cm: ClipMap) {
    // Port-note: Row CM2. Raven reads the lump at `cmod_base + l->fileofs`, and `cmod_base`, the `byte *` of cm_load.cpp:64, has no storage row, so the body waits on the cm_load round.
    // TODO: Port CMod_LoadPatches
    portMissing("CMod_LoadPatches", source: "oracle/codemp/qcommon/cm_load.cpp:483")
}

/// Source: oracle/codemp/qcommon/cm_load.cpp:540
func CM_LumpChecksum(_ lump: JKAMP.Lump) -> UInt32 {
    // Port-note: An unexposed expression with 2 children.
    // Raven wrote: return LittleLong (Com_BlockChecksum (cmod_base + lump->fileofs, lump->filelen))
    portMissing("CM_LumpChecksum", source: "oracle/codemp/qcommon/cm_load.cpp:540")
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

    // Port-note: An unexposed expression with 2 children.
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
private func CM_LoadMap_Actual(_ name: String, _ clientload: Bool, _ checksum: inout Int32, _ cm: ClipMap) {
    // Port-note: Row CM2. Raven reads the BSP through `cmod_base`, the `byte *` of cm_load.cpp:64 with no storage row, and through the static `last_checksum`, so the body waits on the cm_load round.
    // TODO: Port CM_LoadMap_Actual
    portMissing("CM_LoadMap_Actual", source: "oracle/codemp/qcommon/cm_load.cpp:605")
}

// need a wrapper function around this because of multiple returns, need to ensure bool is correct...
//
/// Source: oracle/codemp/qcommon/cm_load.cpp:775
func CM_LoadMap(_ name: String, _ clientload: Bool, _ checksum: inout Int32) {
    gbUsingCachedMapDataRightNow = true // !!!!!!!!!!!!!!!!!!

    // Port-note: CM_LoadMap_Actual carries a signature marker, because the table has no row for `clipMap_t &cm`.
    // Raven wrote: CM_LoadMap_Actual( name, clientload, checksum, cmg );
    portMissing("CM_LoadMap", source: "oracle/codemp/qcommon/cm_load.cpp:775")

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
    // Port-note: CM_ClipHandleToModel carries a signature marker, because the table has no row for `clipMap_t **clipMap`.
    // Raven wrote: cmod = CM_ClipHandleToModel( model ); VectorCopy( cmod->mins, mins ); VectorCopy( cmod->maxs, maxs );
    portMissing("CM_ModelBounds", source: "oracle/codemp/qcommon/cm_load.cpp:1020")
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

    // Port-note: CM_LoadMap_Actual carries a signature marker, because the table has no row for `clipMap_t &cm`.
    // Raven wrote: CM_LoadMap_Actual(name, clientload, &checksum, SubBSP[NumSubBSP] );
    portMissing("CM_LoadSubBSP", source: "oracle/codemp/qcommon/cm_load.cpp:1083")
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
            brushNum = cm!.leafbrushes![i]
            contents |= cm!.brushesSlots[brushNum].contents
            i += 1
        }
    }
    if cmod!.leaf.numLeafSurfaces != 0 {
        var surfaceNum: Int32
        i = cmod!.leaf.firstLeafSurface
        while i < cmod!.leaf.firstLeafSurface + cmod!.leaf.numLeafSurfaces {
            surfaceNum = cm!.leafsurfaces![i]
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
    // Port-note: CM_ModelContents_Actual carries a signature marker, because the table has no row for `clipMap_t *cm`.
    // Raven wrote: if (subBSPIndex < 0) { return CM_ModelContents_Actual(model, NULL); } return CM_ModelContents_Actual(model, &SubBSP[subBSPIndex]);
    portMissing("CM_ModelContents", source: "oracle/codemp/qcommon/cm_load.cpp:1176")
}
