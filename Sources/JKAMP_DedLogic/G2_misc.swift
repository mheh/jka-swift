import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:29
let GORE_TAG_UPPER = (256) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:30
let GORE_TAG_MASK = (~255) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:32
var CurrentTag: Int32 {
    get { world.variables.CurrentTag }
    set { world.variables.CurrentTag = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:33
var CurrentTagUpper: Int32 {
    get { world.variables.CurrentTagUpper }
    set { world.variables.CurrentTagUpper = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:35
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var GoreRecords: [Int32: GoreTextureCoordinates] {
    get { world.GoreRecords }
    set { world.GoreRecords = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:36
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var GoreTagsTemp: [[Int32]: Int32] {
    get { world.GoreTagsTemp }
    set { world.GoreTagsTemp = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:38
var goreModelIndex: Int32 {
    get { world.variables.goreModelIndex }
    set { world.variables.goreModelIndex = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:40
var cg_g2MarksAllModels: JKAMP.Cvar? {
    get { world.variables.cg_g2MarksAllModels }
    set { world.variables.cg_g2MarksAllModels = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:56
let MAX_GORE_RECORDS = (500) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:124
var CurrentGoreSet: Int32 {
    get { world.variables.CurrentGoreSet }
    set { world.variables.CurrentGoreSet = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:125
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var GoreSets: [Int32: CGoreSet] {
    get { world.GoreSets }
    set { world.GoreSets = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:792
let MAX_GORE_VERTS = (3000) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:793
// TODO: Port global GoreVerts
// Raven wrote: static SVertexTemp GoreVerts[MAX_GORE_VERTS]
// No view for `SVertexTemp`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:794
var GoreIndexCopy: [Int32] {
    get { world.variables.GoreIndexCopy }
    set { world.variables.GoreIndexCopy = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:795
var GoreTouch: Int32 {
    get { world.variables.GoreTouch }
    set { world.variables.GoreTouch = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:797
let MAX_GORE_INDECIES = (6000) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:798
var GoreIndecies: [Int32] {
    get { world.variables.GoreIndecies }
    set { world.variables.GoreIndecies = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:800
let GORE_MARGIN = (0.0) as Float

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1715
// Raven wrote: #define SURFACE_SAVE_BLOCK_SIZE sizeof ( surfaceInfo_t )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1716
// Raven wrote: #define BOLT_SAVE_BLOCK_SIZE ( sizeof ( boltInfo_t ) - sizeof ( mdxaBone_t ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1717
// Raven wrote: #define BONE_SAVE_BLOCK_SIZE sizeof ( boneInfo_t )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:43
private func DestroyGoreTexCoordinates(_ tag: Int32) {
    let gTC = FindGoreRecord(tag)
    if gTC == nil {
        return
    }
    // AI: Raven runs the destructor of the record, which frees its `tex` blocks. The class has no destructor, so the call drops.
    //I don't know what's going on here, it should call the destructor for
    //this when it erases the record but sometimes it doesn't. -rww
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:58
func AllocGoreRecord() -> Int32 {
    while GoreRecords.count > MAX_GORE_RECORDS {
        // AI: Raven reads the first record of an ordered map. The Dictionary has no order, so the body takes the least tag.
        let tagHigh = GoreRecords.keys.min()! & GORE_TAG_MASK
        var it: Int32

        it = GoreRecords.keys.min()!

        // AI: Raven runs the destructor of the record here. The class has no destructor, so the call drops.
        GoreRecords[it] = nil
        while GoreRecords.count != 0 {
            if (GoreRecords.keys.min()! & GORE_TAG_MASK) != tagHigh {
                break
            }
            it = GoreRecords.keys.min()!

            // AI: Raven runs the destructor of the record here. The class has no destructor, so the call drops.
            GoreRecords[it] = nil
        }
    }
    let ret = CurrentTag
    GoreRecords[CurrentTag] = GoreTextureCoordinates()
    CurrentTag += 1
    return ret
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:96
func ResetGoreTag() {
    GoreTagsTemp.removeAll()
    CurrentTag = CurrentTagUpper
    CurrentTagUpper += GORE_TAG_UPPER
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:103
func FindGoreRecord(_ tag: Int32) -> GoreTextureCoordinates? {
    if let i = GoreRecords[tag] {
        return i
    }
    return nil
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:113
// TODO: Port signature
// Raven wrote: void *G2_GetGoreRecord(int tag)
// No table row for the return `void *`.
func G2_GetGoreRecord() -> Never {
    // TODO: Port G2_GetGoreRecord
    portMissing("G2_GetGoreRecord", source: "oracle/codemp/ghoul2/G2_misc.cpp:113")
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:118
func DeleteGoreRecord(_ tag: Int32) {
    DestroyGoreTexCoordinates(tag)
    GoreRecords[tag] = nil
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:127
func FindGoreSet(_ goreSetTag: Int32) -> CGoreSet? {
    if let f = GoreSets[goreSetTag] {
        return f
    }
    return nil
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:142
func NewGoreSet() -> CGoreSet? {
    let ret = CGoreSet(CurrentGoreSet)
    CurrentGoreSet += 1
    GoreSets[ret.mMyGoreSetTag] = ret
    ret.mRefCount = 1
    return ret
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:153
func DeleteGoreSet(_ goreSetTag: Int32) {
    if let f = GoreSets[goreSetTag] {
        if f.mRefCount == 0 || f.mRefCount - 1 == 0 {
            // AI: Raven deletes the set and then erases its entry. The body erases the entry, and the deinit runs when the last reference goes.
            GoreSets[goreSetTag] = nil
        } else {
            f.mRefCount -= 1
        }
    }
}

// assorted Ghoul 2 functions.
// list all surfaces associated with a model
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:279
func G2_List_Model_Surfaces(_ fileName: String) {
    // Port-note: Raven casts a record at a byte offset of `mod_m->mdxm`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_List_Model_Surfaces
    portMissing("G2_List_Model_Surfaces", source: "oracle/codemp/ghoul2/G2_misc.cpp:279")
}

// list all bones associated with a model
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:307
func G2_List_Model_Bones(_ fileName: String, _ frame: Int32) {
    // Port-note: Raven casts a record at a byte offset of `header`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_List_Model_Bones
    portMissing("G2_List_Model_Bones", source: "oracle/codemp/ghoul2/G2_misc.cpp:307")
}

/**
```
***********************************************************************************************
 * G2_GetAnimFileName
 *    obtain the .gla filename for a model
 *
 * Input
 *    filename of model
 *
 * Output
 *    true if we successfully obtained a filename, false otherwise
 *
 ***********************************************************************************************
```
*/
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:356
func G2_GetAnimFileName(_ fileName: String, _ filename: inout JKAShared.TextCursor) -> Bool {
    // find the model we want
    let mod = R_GetModelByHandle(RE_RegisterModel(fileName))

    if let mod, let mdxm = mod.mdxm, !mdxm.animName.isEmpty {
        filename = TextCursor(mdxm.animNameBuffer)
        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:376
func G2_DecideTraceLod(_ ghoul2: CGhoul2Info, _ useLod: Int32) -> Int32 {
    var returnLod = useLod

    // if we are overriding the LOD at top level, then we can afford to only check this level of model
    if ghoul2.mLodBias > returnLod {
        returnLod = ghoul2.mLodBias
    }
//	assert(G2_MODEL_OK(&ghoul2));

    //what about r_lodBias?

    // now ensure that we haven't selected a lod that doesn't exist for this model
    if returnLod >= ghoul2.currentModel!.mdxm!.numLODs {
        returnLod = ghoul2.currentModel!.mdxm!.numLODs - 1
    }

    return returnLod
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:404
func R_TransformEachSurface(_ surface: MdxmSurface, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ TransformedVertsArray: inout Int32, _ boneCache: CBoneCache?) {
    // Port-note: Raven casts a record at a byte offset of `surface`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port R_TransformEachSurface
    portMissing("R_TransformEachSurface", source: "oracle/codemp/ghoul2/G2_misc.cpp:404")
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:517
func G2_TransformSurfaces(_ surfaceNum: Int32, _ rootSList: inout [surfaceInfo_t], _ boneCache: CBoneCache?, _ currentModel: Model, _ lod: Int32, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ TransformedVertArray: inout Int32, _ secondTimeAround: Bool) {
    // Port-note: The body calls G2_FindSurface, which keeps its signature marker.
    // Port-note: Raven casts a record at a byte offset of `currentModel->mdxm`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_TransformSurfaces
    portMissing("G2_TransformSurfaces", source: "oracle/codemp/ghoul2/G2_misc.cpp:517")
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:560
func G2_TransformModel(_ ghoul2: CGhoul2Info_v, _ frameNum: Int32, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ useLod: Int32, _ ApplyGore: Bool) {
    // Port-note: G2_TransformSurfaces takes `int *TransformedVertArray` as `inout Int32`, and the field `mTransformedVertsArray` is `Slots<Int32>?`, so the call has no form.
    // Port-note: Raven casts the `char *` of MiniHeapAlloc to `int *` and clears `numSurfaces * 4` bytes of it, and the body has no form for the cast or the partial memset.
    // TODO: Port G2_TransformModel
    portMissing("G2_TransformModel", source: "oracle/codemp/ghoul2/G2_misc.cpp:560")
}

// work out how much space a triangle takes
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:665
private func G2_AreaOfTri(_ A: JKAShared.vec3_t, _ B: JKAShared.vec3_t, _ C: JKAShared.vec3_t) -> Float {
    var cross = JKAShared.vec3_t()
    var ab = JKAShared.vec3_t()
    var cb = JKAShared.vec3_t()
    ab = A - B
    cb = C - B

    CrossProduct(ab, cb, &cross)

    return VectorLength(cross)
}

// actually determine the S and T of the coordinate we hit in a given poly
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:677
// TODO: Port signature
// Raven wrote: static void G2_BuildHitPointST( const vec3_t A, const float SA, const float TA, const vec3_t B, const float SB, const float TB, const vec3_t C, const float SC, const float TC, const vec3_t P, float *s, float *t,float &bary_i,float &bary_j)
// No table row for `float & bary_i`.
private func G2_BuildHitPointST() -> Never {
    // TODO: Port G2_BuildHitPointST
    portMissing("G2_BuildHitPointST", source: "oracle/codemp/ghoul2/G2_misc.cpp:677")
}

// routine that works out given a ray whether or not it hits a poly
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:709
func G2_SegmentTriangleTest(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ A: JKAShared.vec3_t, _ B: JKAShared.vec3_t, _ C: JKAShared.vec3_t, _ backFaces: Bool, _ frontFaces: Bool, _ returnedPoint: inout JKAShared.vec3_t, _ returnedNormal: inout JKAShared.vec3_t, _ denom: inout Float) -> Bool {
    let tiny: Float = 1E-10
    var returnedNormalT = JKAShared.vec3_t()
    var edgeAC = JKAShared.vec3_t()

    edgeAC = C - A
    returnedNormalT = B - A

    CrossProduct(returnedNormalT, edgeAC, &returnedNormal)

    var ray = JKAShared.vec3_t()
    ray = end - start

    denom = _DotProduct(ray, returnedNormal)

    if abs(denom) < tiny ||        // triangle parallel to ray
        (!backFaces && denom > 0) ||		// not accepting back faces
        (!frontFaces && denom < 0)		//not accepting front faces
    {
        return false
    }

    var toPlane = JKAShared.vec3_t()
    toPlane = A - start

    let t: Float = _DotProduct(toPlane, returnedNormal) / denom

    if t < 0.0 || t > 1.0 {
        return false // off segment
    }

    ray = ray * t

    returnedPoint = ray + start

    var edgePA = JKAShared.vec3_t()
    edgePA = A - returnedPoint

    var edgePB = JKAShared.vec3_t()
    edgePB = B - returnedPoint

    var edgePC = JKAShared.vec3_t()
    edgePC = C - returnedPoint

    var temp = JKAShared.vec3_t()

    CrossProduct(edgePA, edgePB, &temp)
    if _DotProduct(temp, returnedNormal) < 0.0 {
        return false // off triangle
    }

    CrossProduct(edgePC, edgePA, &temp)
    if _DotProduct(temp, returnedNormal) < 0.0 {
        return false // off triangle
    }

    CrossProduct(edgePB, edgePC, &temp)
    if _DotProduct(temp, returnedNormal) < 0.0 {
        return false // off triangle
    }
    return true
}

// now we at poly level, check each model space transformed poly against the model world transfomed ray
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:804
func G2_GorePolys(_ surface: MdxmSurface, _ TS: CTraceSurface, _ surfInfo: MdxmSurfHierarchy) {
    // Port-note: Raven casts a record at a byte offset of `surface`, and the view target has no accessor for a view at a byte offset.
    // Port-note: Raven casts the `int` of `TS.TransformedVertsArray` back to a `float *`, and `GoreVerts` has no storage.
    // TODO: Port G2_GorePolys
    portMissing("G2_GorePolys", source: "oracle/codemp/ghoul2/G2_misc.cpp:804")
}

// now we're at poly level, check each model space transformed poly against the model world transfomed ray
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1092
private func G2_TracePolys(_ surface: MdxmSurface, _ surfInfo: MdxmSurfHierarchy, _ TS: CTraceSurface) -> Bool {
    // Port-note: Raven casts a record at a byte offset of `surface`, and the view target has no accessor for a view at a byte offset.
    // Port-note: Raven casts the `int` of `TS.TransformedVertsArray` back to a `float *`, and the body calls G2_BuildHitPointST, which keeps its signature marker.
    // TODO: Port G2_TracePolys
    portMissing("G2_TracePolys", source: "oracle/codemp/ghoul2/G2_misc.cpp:1092")
}

// now we're at poly level, check each model space transformed poly against the model world transfomed ray
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1222
private func G2_RadiusTracePolys(_ surface: MdxmSurface, _ TS: CTraceSurface) -> Bool {
    // Port-note: Raven casts a record at a byte offset of `surface`, and the view target has no accessor for a view at a byte offset.
    // Port-note: Raven casts the `int` of `TS.TransformedVertsArray` back to a `float *`, and `GoreVerts` has no storage.
    // TODO: Port G2_RadiusTracePolys
    portMissing("G2_RadiusTracePolys", source: "oracle/codemp/ghoul2/G2_misc.cpp:1222")
}

// look at a surface and then do the trace on each poly
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1428
private func G2_TraceSurfaces(_ TS: CTraceSurface) {
    // Port-note: The body calls G2_FindSurface, which keeps its signature marker.
    // Port-note: Raven casts a record at a byte offset of `TS.currentModel->mdxm`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_TraceSurfaces
    portMissing("G2_TraceSurfaces", source: "oracle/codemp/ghoul2/G2_misc.cpp:1428")
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1514
// TODO: Port signature
// Raven wrote: void G2_TraceModels(CGhoul2Info_v &ghoul2, vec3_t rayStart, vec3_t rayEnd, CollisionRecord_t *collRecMap, int entNum, int eG2TraceType, int useLod, float fRadius, float ssize,float tsize,float theta,int shader, SSkinGoreData *gore, qboolean skipIfLODNotMatch) #else void G2_TraceModels(CGhoul2Info_v &ghoul2, vec3_t rayStart, vec3_t rayEnd, CollisionRecord_t *collRecMap, int entNum, int eG2TraceType, int useLod, float fRadius) #endif
// No table row for `SSkinGoreData * gore`.
func G2_TraceModels() -> Never {
    // TODO: Port G2_TraceModels
    portMissing("G2_TraceModels", source: "oracle/codemp/ghoul2/G2_misc.cpp:1514")
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1613
func TransformPoint(_ `in`: JKAShared.vec3_t, _ out: inout JKAShared.vec3_t, _ mat: JKAMP.MdxaBone) {
    var i: Int32 = 0
    while i < 3 {
        out[i] = `in`[0] * mat.matrix[i][0] + `in`[1] * mat.matrix[i][1] + `in`[2] * mat.matrix[i][2]
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1620
func TransformAndTranslatePoint(_ `in`: JKAShared.vec3_t, _ out: inout JKAShared.vec3_t, _ mat: JKAMP.MdxaBone) {

    var i: Int32 = 0
    while i < 3 {
        out[i] = `in`[0] * mat.matrix[i][0] + `in`[1] * mat.matrix[i][1] + `in`[2] * mat.matrix[i][2] + mat.matrix[i][3]
        i += 1
    }
}

// create a matrix using a set of angles
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1630
func Create_Matrix(_ angle: JKAShared.vec4_t?, _ matrix: JKAMP.MdxaBone) {
    // Port-note: The signature gives `const float *angle` as `vec4_t?`, and AnglesToAxis takes a `vec3_t`, the type every caller passes.
    // TODO: Port Create_Matrix
    portMissing("Create_Matrix", source: "oracle/codemp/ghoul2/G2_misc.cpp:1630")
}

// given a matrix, generate the inverse of that matrix
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1656
func Inverse_Matrix(_ src: JKAMP.MdxaBone, _ dest: JKAMP.MdxaBone) {
    var i: Int32
    var j: Int32

    i = 0
    while i < 3 {
        j = 0
        while j < 3 {
            dest.matrix[i][j] = src.matrix[j][i]
            j += 1
        }
        i += 1
    }
    i = 0
    while i < 3 {
        dest.matrix[i][3] = 0
        j = 0
        while j < 3 {
            dest.matrix[i][3] -= dest.matrix[i][j] * src.matrix[j][3]
            j += 1
        }
        i += 1
    }
}

// generate the world matrix for a given set of angles and origin - called from lots of places
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1678
func G2_GenerateWorldMatrix(_ angles: JKAShared.vec3_t, _ origin: JKAShared.vec3_t) {
    // Port-note: Create_Matrix takes `angle` as `vec4_t?`, and Raven passes the `vec3_t` angles, so the call has no form.
    // TODO: Port G2_GenerateWorldMatrix
    portMissing("G2_GenerateWorldMatrix", source: "oracle/codemp/ghoul2/G2_misc.cpp:1678")
}

// go away and determine what the pointer for a specific surface definition within the model definition is
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1689
func G2_FindSurface(_ mod_t: Model?, _ index: Int32, _ lod: Int32) -> MdxmSurface? {
    // Port-note: Raven reads the offset table through `mdxmLODSurfOffset_t`, and that record has no view.
    // TODO: Port G2_FindSurface
    portMissing("G2_FindSurface", source: "oracle/codemp/ghoul2/G2_misc.cpp:1689")
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1719
func G2_SaveGhoul2Models(_ ghoul2: CGhoul2Info_v, _ buffer: inout JKAShared.TextCursor, _ size: inout Int32) -> Bool {
    // Port-note: Raven copies the bytes of `CGhoul2Info` from `mModelindex` to `mTransformedVertsArray`, and of `surfaceInfo_t`, `boneInfo_t`, and `boltInfo_t`, into a zone block.
    // The Swift classes have no byte layout, and `char **buffer` is a `TextCursor`, so the body has no form.
    // TODO: Port G2_SaveGhoul2Models
    portMissing("G2_SaveGhoul2Models", source: "oracle/codemp/ghoul2/G2_misc.cpp:1719")
}

// have to free space malloced in the save system here because the game DLL can't.
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1812
func G2_FreeSaveBuffer(_ buffer: inout JKAShared.CharBuf) {
    // AI: Raven frees the zone block of the save buffer with Z_Free. The CharBuf owns its bytes, so the body frees nothing.
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1817
func G2_FindConfigStringSpace(_ name: String, _ start: Int32, _ max: Int32) -> Int32 {
    var s = CharBuf(MAX_STRING_CHARS)
    var i: Int32
    i = 1
    while i < max {
        SV_GetConfigstring(start + i, &s, Int32(s.count))
        if s[0] == 0 {
            break
        }
        if Q_stricmp(String(s), name) == 0 {
            return i
        }
        i += 1
    }

    SV_SetConfigstring(start + i, name)
    return i
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1841
func G2_LoadGhoul2Model(_ ghoul2: CGhoul2Info_v, _ buffer: inout JKAShared.CharBuf) {
    // Port-note: Raven copies bytes of the buffer into `CGhoul2Info` from `mModelindex` to `mTransformedVertsArray`, and into `surfaceInfo_t`, `boneInfo_t`, and `boltInfo_t`.
    // The Swift classes have no byte layout, so the body has no form.
    // TODO: Port G2_LoadGhoul2Model
    portMissing("G2_LoadGhoul2Model", source: "oracle/codemp/ghoul2/G2_misc.cpp:1841")
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1912
func G2_LerpAngles(_ ghoul2: CGhoul2Info_v, _ nextGhoul2: CGhoul2Info_v, _ interpolation: Float) {
    // Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port G2_LerpAngles
    portMissing("G2_LerpAngles", source: "oracle/codemp/ghoul2/G2_misc.cpp:1912")
}
