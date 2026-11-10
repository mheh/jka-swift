import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:42
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_RenderSurfaces: timing_c { world.G2PerformanceTimer_RenderSurfaces }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:43
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_R_AddGHOULSurfaces: timing_c { world.G2PerformanceTimer_R_AddGHOULSurfaces }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:44
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_G2_TransformGhoulBones: timing_c { world.G2PerformanceTimer_G2_TransformGhoulBones }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:45
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_G2_ProcessGeneratedSurfaceBolts: timing_c { world.G2PerformanceTimer_G2_ProcessGeneratedSurfaceBolts }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:46
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_ProcessModelBoltSurfaces: timing_c { world.G2PerformanceTimer_ProcessModelBoltSurfaces }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:47
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_G2_ConstructGhoulSkeleton: timing_c { world.G2PerformanceTimer_G2_ConstructGhoulSkeleton }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:48
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_RB_SurfaceGhoul: timing_c { world.G2PerformanceTimer_RB_SurfaceGhoul }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:49
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_G2_SetupModelPointers: timing_c { world.G2PerformanceTimer_G2_SetupModelPointers }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:50
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var G2PerformanceTimer_PreciseFrame: timing_c { world.G2PerformanceTimer_PreciseFrame }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:52
var G2PerformanceCounter_G2_TransformGhoulBones: Int32 {
    get { world.variables.G2PerformanceCounter_G2_TransformGhoulBones }
    set { world.variables.G2PerformanceCounter_G2_TransformGhoulBones = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:54
var G2Time_RenderSurfaces: Int32 {
    get { world.variables.G2Time_RenderSurfaces }
    set { world.variables.G2Time_RenderSurfaces = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:55
var G2Time_R_AddGHOULSurfaces: Int32 {
    get { world.variables.G2Time_R_AddGHOULSurfaces }
    set { world.variables.G2Time_R_AddGHOULSurfaces = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:56
var G2Time_G2_TransformGhoulBones: Int32 {
    get { world.variables.G2Time_G2_TransformGhoulBones }
    set { world.variables.G2Time_G2_TransformGhoulBones = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:57
var G2Time_G2_ProcessGeneratedSurfaceBolts: Int32 {
    get { world.variables.G2Time_G2_ProcessGeneratedSurfaceBolts }
    set { world.variables.G2Time_G2_ProcessGeneratedSurfaceBolts = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:58
var G2Time_ProcessModelBoltSurfaces: Int32 {
    get { world.variables.G2Time_ProcessModelBoltSurfaces }
    set { world.variables.G2Time_ProcessModelBoltSurfaces = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:59
var G2Time_G2_ConstructGhoulSkeleton: Int32 {
    get { world.variables.G2Time_G2_ConstructGhoulSkeleton }
    set { world.variables.G2Time_G2_ConstructGhoulSkeleton = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:60
var G2Time_RB_SurfaceGhoul: Int32 {
    get { world.variables.G2Time_RB_SurfaceGhoul }
    set { world.variables.G2Time_RB_SurfaceGhoul = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:61
var G2Time_G2_SetupModelPointers: Int32 {
    get { world.variables.G2Time_G2_SetupModelPointers }
    set { world.variables.G2Time_G2_SetupModelPointers = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:62
var G2Time_PreciseFrame: Int32 {
    get { world.variables.G2Time_PreciseFrame }
    set { world.variables.G2Time_PreciseFrame = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:104
// Raven wrote: bool HackadelicOnClient=false
let HackadelicOnClient: Bool = false // means this is a render traversal

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:128
// Raven wrote: const static mdxaBone_t identityMatrix
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:136
var worldMatrix: JKAMP.MdxaBone { world.storage.worldMatrix }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:137
var worldMatrixInv: JKAMP.MdxaBone { world.storage.worldMatrixInv }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:139
// Raven wrote: qhandle_t goreShader=-1
let goreShader: JKAShared.qhandle_t = -1

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:865
let MAX_RENDER_SURFACES = (2048) as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:866
// TODO: Port global RSStorage
// Raven wrote: static CRenderableSurface RSStorage[MAX_RENDER_SURFACES]
// No view for `CRenderableSurface` of `tr_local.h`.

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:867
var NextRS: UInt32 {
    get { world.variables.NextRS }
    set { world.variables.NextRS = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1164
private let DEBUG_G2_TIMING = (0) as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1165
let DEBUG_G2_TIMING_RENDER_ONLY = (1) as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2071
private let GHOUL2_RAG_STARTED = 0x0010 as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2238
let MDX_TAG_ORIGIN = 2 as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:4469
// Raven wrote: int OldToNewRemapTable[72]
let OldToNewRemapTable: [Int32] = [
    0,// Bone 0:   "model_root":           Parent: ""  (index -1)
    1,// Bone 1:   "pelvis":               Parent: "model_root"  (index 0)
    2,// Bone 2:   "Motion":               Parent: "pelvis"  (index 1)
    3,// Bone 3:   "lfemurYZ":             Parent: "pelvis"  (index 1)
    4,// Bone 4:   "lfemurX":              Parent: "pelvis"  (index 1)
    5,// Bone 5:   "ltibia":               Parent: "pelvis"  (index 1)
    6,// Bone 6:   "ltalus":               Parent: "pelvis"  (index 1)
    6,// Bone 7:   "ltarsal":              Parent: "pelvis"  (index 1)
    7,// Bone 8:   "rfemurYZ":             Parent: "pelvis"  (index 1)
    8,// Bone 9:   "rfemurX":	            Parent: "pelvis"  (index 1)
    9,// Bone10:   "rtibia":	            Parent: "pelvis"  (index 1)
    10,// Bone11:   "rtalus":	            Parent: "pelvis"  (index 1)
    10,// Bone12:   "rtarsal":              Parent: "pelvis"  (index 1)
    11,// Bone13:   "lower_lumbar":         Parent: "pelvis"  (index 1)
    12,// Bone14:   "upper_lumbar":	        Parent: "lower_lumbar"  (index 13)
    13,// Bone15:   "thoracic":	            Parent: "upper_lumbar"  (index 14)
    14,// Bone16:   "cervical":	            Parent: "thoracic"  (index 15)
    15,// Bone17:   "cranium":              Parent: "cervical"  (index 16)
    16,// Bone18:   "ceyebrow":	            Parent: "face_always_"  (index 71)
    17,// Bone19:   "jaw":                  Parent: "face_always_"  (index 71)
    18,// Bone20:   "lblip2":	            Parent: "face_always_"  (index 71)
    19,// Bone21:   "leye":		            Parent: "face_always_"  (index 71)
    20,// Bone22:   "rblip2":	            Parent: "face_always_"  (index 71)
    21,// Bone23:   "ltlip2":               Parent: "face_always_"  (index 71)
    22,// Bone24:   "rtlip2":	            Parent: "face_always_"  (index 71)
    23,// Bone25:   "reye":		            Parent: "face_always_"  (index 71)
    24,// Bone26:   "rclavical":            Parent: "thoracic"  (index 15)
    25,// Bone27:   "rhumerus":             Parent: "thoracic"  (index 15)
    26,// Bone28:   "rhumerusX":            Parent: "thoracic"  (index 15)
    27,// Bone29:   "rradius":              Parent: "thoracic"  (index 15)
    28,// Bone30:   "rradiusX":             Parent: "thoracic"  (index 15)
    29,// Bone31:   "rhand":                Parent: "thoracic"  (index 15)
    29,// Bone32:   "mc7":                  Parent: "thoracic"  (index 15)
    34,// Bone33:   "r_d5_j1":              Parent: "thoracic"  (index 15)
    35,// Bone34:   "r_d5_j2":              Parent: "thoracic"  (index 15)
    35,// Bone35:   "r_d5_j3":              Parent: "thoracic"  (index 15)
    30,// Bone36:   "r_d1_j1":              Parent: "thoracic"  (index 15)
    31,// Bone37:   "r_d1_j2":              Parent: "thoracic"  (index 15)
    31,// Bone38:   "r_d1_j3":              Parent: "thoracic"  (index 15)
    32,// Bone39:   "r_d2_j1":              Parent: "thoracic"  (index 15)
    33,// Bone40:   "r_d2_j2":              Parent: "thoracic"  (index 15)
    33,// Bone41:   "r_d2_j3":              Parent: "thoracic"  (index 15)
    32,// Bone42:   "r_d3_j1":			    Parent: "thoracic"  (index 15)
    33,// Bone43:   "r_d3_j2":		        Parent: "thoracic"  (index 15)
    33,// Bone44:   "r_d3_j3":              Parent: "thoracic"  (index 15)
    34,// Bone45:   "r_d4_j1":              Parent: "thoracic"  (index 15)
    35,// Bone46:   "r_d4_j2":	            Parent: "thoracic"  (index 15)
    35,// Bone47:   "r_d4_j3":		        Parent: "thoracic"  (index 15)
    36,// Bone48:   "rhang_tag_bone":	    Parent: "thoracic"  (index 15)
    37,// Bone49:   "lclavical":            Parent: "thoracic"  (index 15)
    38,// Bone50:   "lhumerus":	            Parent: "thoracic"  (index 15)
    39,// Bone51:   "lhumerusX":	        Parent: "thoracic"  (index 15)
    40,// Bone52:   "lradius":	            Parent: "thoracic"  (index 15)
    41,// Bone53:   "lradiusX":	            Parent: "thoracic"  (index 15)
    42,// Bone54:   "lhand":	            Parent: "thoracic"  (index 15)
    42,// Bone55:   "mc5":		            Parent: "thoracic"  (index 15)
    43,// Bone56:   "l_d5_j1":	            Parent: "thoracic"  (index 15)
    44,// Bone57:   "l_d5_j2":	            Parent: "thoracic"  (index 15)
    44,// Bone58:   "l_d5_j3":	            Parent: "thoracic"  (index 15)
    43,// Bone59:   "l_d4_j1":	            Parent: "thoracic"  (index 15)
    44,// Bone60:   "l_d4_j2":	            Parent: "thoracic"  (index 15)
    44,// Bone61:   "l_d4_j3":	            Parent: "thoracic"  (index 15)
    45,// Bone62:   "l_d3_j1":	            Parent: "thoracic"  (index 15)
    46,// Bone63:   "l_d3_j2":	            Parent: "thoracic"  (index 15)
    46,// Bone64:   "l_d3_j3":	            Parent: "thoracic"  (index 15)
    45,// Bone65:   "l_d2_j1":	            Parent: "thoracic"  (index 15)
    46,// Bone66:   "l_d2_j2":	            Parent: "thoracic"  (index 15)
    46,// Bone67:   "l_d2_j3":	            Parent: "thoracic"  (index 15)
    47,// Bone68:   "l_d1_j1":				Parent: "thoracic"  (index 15)
    48,// Bone69:   "l_d1_j2":	            Parent: "thoracic"  (index 15)
    48,// Bone70:   "l_d1_j3":				Parent: "thoracic"  (index 15)
    52// Bone71:   "face_always_":			Parent: "cranium"  (index 17)
]

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:64
func G2Time_ResetTimers() {
    G2Time_RenderSurfaces = 0
    G2Time_R_AddGHOULSurfaces = 0
    G2Time_G2_TransformGhoulBones = 0
    G2Time_G2_ProcessGeneratedSurfaceBolts = 0
    G2Time_ProcessModelBoltSurfaces = 0
    G2Time_G2_ConstructGhoulSkeleton = 0
    G2Time_RB_SurfaceGhoul = 0
    G2Time_G2_SetupModelPointers = 0
    G2Time_PreciseFrame = 0
    G2PerformanceCounter_G2_TransformGhoulBones = 0
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:78
func G2Time_ReportTimers() {
    Com_Printf(
        "\n---------------------------------\nRenderSurfaces: %i\nR_AddGhoulSurfaces: %i\nG2_TransformGhoulBones: %i\nG2_ProcessGeneratedSurfaceBolts: %i\nProcessModelBoltSurfaces: %i\nG2_ConstructGhoulSkeleton: %i\nRB_SurfaceGhoul: %i\nG2_SetupModelPointers: %i\n\nPrecise frame time: %i\nTransformGhoulBones calls: %i\n---------------------------------\n\n",
        G2Time_RenderSurfaces,
        G2Time_R_AddGHOULSurfaces,
        G2Time_G2_TransformGhoulBones,
        G2Time_G2_ProcessGeneratedSurfaceBolts,
        G2Time_ProcessModelBoltSurfaces,
        G2Time_G2_ConstructGhoulSkeleton,
        G2Time_RB_SurfaceGhoul,
        G2Time_G2_SetupModelPointers,
        G2Time_PreciseFrame,
        G2PerformanceCounter_G2_TransformGhoulBones
    )
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:112
private func G2_Find_Bone_ByNum(_ mod: Model, _ blist: inout [boneInfo_t], _ boneNum: Int32) -> Int32 {
    // Raven's one call stands inside `#if 0` at tr_ghoul2.cpp:274, so the function is dead.
    // TODO: Port G2_Find_Bone_ByNum
    portMissing("G2_Find_Bone_ByNum", source: "oracle/codemp/renderer/tr_ghoul2.cpp:112")
}

/// The byte size of Raven's `CBoneCache` in the 32-bit build, which `g_Ghoul2Allocations` counts at each new and each delete.
/// The members are `frameSize`, two pointers, three vectors of 16 bytes, five ints, two bools with padding, and one float: 12 + 48 + 20 + 4 + 4.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:572
// AI: Raven takes `sizeof` of the C++ class. The Swift class has no byte size, so the constant holds the byte count of the 32-bit build.
private let sizeofCBoneCache = 88 as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:569
func RemoveBoneCache(_ boneCache: CBoneCache?) {
    g_Ghoul2Allocations -= sizeofCBoneCache

    // AI: Raven deletes the cache. ARC frees the cache when the last reference drops, so the body holds no statement.
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:585
// TODO: Port signature
// Raven wrote: const mdxaBone_t &EvalBoneCache(int index,CBoneCache *boneCache)
// No table row for the return `const mdxaBone_t &`.
func EvalBoneCache() -> Never {
    // TODO: Port EvalBoneCache
    portMissing("EvalBoneCache", source: "oracle/codemp/renderer/tr_ghoul2.cpp:585")
}

//rww - RAGDOLL_BEGIN
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:592
func G2_GetModA(_ ghoul2: CGhoul2Info) -> MdxaHeader? {
    if ghoul2.mBoneCache == nil {
        return nil
    }

    let boneCache = ghoul2.mBoneCache!
    return boneCache.header
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:603
func G2_GetBoneDependents(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ tempDependents: Slots<Int32>, _ maxDep: Int32) -> Int32 {
    var tempDependents = tempDependents
    var maxDep = maxDep
    // fixme, these should be precomputed
    if ghoul2.mBoneCache == nil || maxDep == 0 {
        return 0
    }

    let boneCache = ghoul2.mBoneCache!
    let skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    offsets = MdxaSkelOffsets(boneCache.header!, byteOffset: MdxaHeader.byteCount)
    skel = MdxaSkel(boneCache.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[boneNum])
    var i: Int32
    var ret: Int32 = 0
    i = 0
    while i < skel.numChildren {
        if maxDep == 0 {
            return i // number added
        }
        tempDependents[0] = skel.children[i]
        assert(tempDependents[0] > 0 && tempDependents[0] < boneCache.header!.numBones)
        maxDep -= 1
        tempDependents = tempDependents.suffix(from: 1)
        ret += 1
        i += 1
    }
    i = 0
    while i < skel.numChildren {
        let num = G2_GetBoneDependents(ghoul2, skel.children[i], tempDependents, maxDep)
        tempDependents = tempDependents.suffix(from: num)
        ret += num
        maxDep -= num
        assert(maxDep >= 0)
        if maxDep == 0 {
            break
        }
        i += 1
    }
    return ret
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:645
func G2_WasBoneRendered(_ ghoul2: CGhoul2Info, _ boneNum: Int32) -> Bool {
    if ghoul2.mBoneCache == nil {
        return false
    }
    let boneCache = ghoul2.mBoneCache!

    return boneCache.WasRendered(boneNum)
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:656
// TODO: Port signature
// Raven wrote: void G2_GetBoneBasepose(CGhoul2Info &ghoul2,int boneNum,mdxaBone_t *&retBasepose,mdxaBone_t *&retBaseposeInv)
// No table row for `mdxaBone_t *& retBasepose`.
func G2_GetBoneBasepose() -> Never {
    // TODO: Port G2_GetBoneBasepose
    portMissing("G2_GetBoneBasepose", source: "oracle/codemp/renderer/tr_ghoul2.cpp:656")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:678
func G2_GetBoneNameFromSkel(_ ghoul2: CGhoul2Info, _ boneNum: Int32) -> String? {
    // Port-note: Raven casts a record at a byte offset of `boneCache.header`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_GetBoneNameFromSkel
    portMissing("G2_GetBoneNameFromSkel", source: "oracle/codemp/renderer/tr_ghoul2.cpp:678")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:696
func G2_RagGetBoneBasePoseMatrixLow(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ boneMatrix: JKAMP.MdxaBone, _ retMatrix: JKAMP.MdxaBone, _ scale: JKAShared.vec3_t) {
    // Port-note: Raven casts a record at a byte offset of `boneCache.header`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_RagGetBoneBasePoseMatrixLow
    portMissing("G2_RagGetBoneBasePoseMatrixLow", source: "oracle/codemp/renderer/tr_ghoul2.cpp:696")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:727
// TODO: Port signature
// Raven wrote: void G2_GetBoneMatrixLow(CGhoul2Info &ghoul2,int boneNum,const vec3_t scale,mdxaBone_t &retMatrix,mdxaBone_t *&retBasepose,mdxaBone_t *&retBaseposeInv)
// No table row for `mdxaBone_t *& retBasepose`.
func G2_GetBoneMatrixLow() -> Never {
    // TODO: Port G2_GetBoneMatrixLow
    portMissing("G2_GetBoneMatrixLow", source: "oracle/codemp/renderer/tr_ghoul2.cpp:727")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:780
// TODO: Port signature
// Raven wrote: int G2_GetParentBoneMatrixLow(CGhoul2Info &ghoul2,int boneNum,const vec3_t scale,mdxaBone_t &retMatrix,mdxaBone_t *&retBasepose,mdxaBone_t *&retBaseposeInv)
// No table row for `mdxaBone_t *& retBasepose`.
func G2_GetParentBoneMatrixLow() -> Never {
    // TODO: Port G2_GetParentBoneMatrixLow
    portMissing("G2_GetParentBoneMatrixLow", source: "oracle/codemp/renderer/tr_ghoul2.cpp:780")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:869
func AllocRS() -> CRenderableSurface? {
    // Raven's one call is in RenderSurfaces under `#ifndef DEDICATED` at tr_ghoul2.cpp:2520, so the function is dead in the dedicated build.
    // TODO: Port AllocRS
    portMissing("AllocRS", source: "oracle/codemp/renderer/tr_ghoul2.cpp:869")
}

/**
```
=============
R_ACullModel
=============
```
*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:896
private func R_GCullModel(_ ent: TrRefEntity) -> Int32 {
    // Raven's one call is in R_AddGhoulSurfaces under `#ifndef DEDICATED` at tr_ghoul2.cpp:3384, so the function is dead in the dedicated build.
    // TODO: Port R_GCullModel
    portMissing("R_GCullModel", source: "oracle/codemp/renderer/tr_ghoul2.cpp:896")
}

/**
```
=================
R_AComputeFogNum

=================
```
*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:939
private func R_GComputeFogNum(_ ent: TrRefEntity) -> Int32 {
    // Raven's one call is in R_AddGhoulSurfaces under `#ifndef DEDICATED` at tr_ghoul2.cpp:3384, so the function is dead in the dedicated build.
    // TODO: Port R_GComputeFogNum
    portMissing("R_GComputeFogNum", source: "oracle/codemp/renderer/tr_ghoul2.cpp:939")
}

// work out lod for this entity.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:967
private func G2_ComputeLOD(_ ent: TrRefEntity, _ currentModel: Model, _ lodBias: Int32) -> Int32 {
    // Raven's one call is in R_AddGhoulSurfaces under `#ifndef DEDICATED` at tr_ghoul2.cpp:3384, so the function is dead in the dedicated build.
    // TODO: Port G2_ComputeLOD
    portMissing("G2_ComputeLOD", source: "oracle/codemp/renderer/tr_ghoul2.cpp:967")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1048
func G2_CreateQuaterion(_ mat: JKAMP.MdxaBone, _ quat: inout JKAShared.vec4_t) {
    // Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port G2_CreateQuaterion
    portMissing("G2_CreateQuaterion", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1048")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1097
func G2_CreateMatrixFromQuaterion(_ mat: JKAMP.MdxaBone, _ quat: JKAShared.vec4_t) {
    // Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port G2_CreateMatrixFromQuaterion
    portMissing("G2_CreateMatrixFromQuaterion", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1097")
}

// nasty little matrix multiply going on here..
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1128
func Multiply_3x4Matrix(_ out: JKAMP.MdxaBone, _ in2: JKAMP.MdxaBone, _ `in`: JKAMP.MdxaBone) {
    // first row of out
    out.matrix[0][0] = (in2.matrix[0][0] * `in`.matrix[0][0]) + (in2.matrix[0][1] * `in`.matrix[1][0]) + (in2.matrix[0][2] * `in`.matrix[2][0])
    out.matrix[0][1] = (in2.matrix[0][0] * `in`.matrix[0][1]) + (in2.matrix[0][1] * `in`.matrix[1][1]) + (in2.matrix[0][2] * `in`.matrix[2][1])
    out.matrix[0][2] = (in2.matrix[0][0] * `in`.matrix[0][2]) + (in2.matrix[0][1] * `in`.matrix[1][2]) + (in2.matrix[0][2] * `in`.matrix[2][2])
    out.matrix[0][3] = (in2.matrix[0][0] * `in`.matrix[0][3]) + (in2.matrix[0][1] * `in`.matrix[1][3]) + (in2.matrix[0][2] * `in`.matrix[2][3]) + in2.matrix[0][3]
    // second row of outf out
    out.matrix[1][0] = (in2.matrix[1][0] * `in`.matrix[0][0]) + (in2.matrix[1][1] * `in`.matrix[1][0]) + (in2.matrix[1][2] * `in`.matrix[2][0])
    out.matrix[1][1] = (in2.matrix[1][0] * `in`.matrix[0][1]) + (in2.matrix[1][1] * `in`.matrix[1][1]) + (in2.matrix[1][2] * `in`.matrix[2][1])
    out.matrix[1][2] = (in2.matrix[1][0] * `in`.matrix[0][2]) + (in2.matrix[1][1] * `in`.matrix[1][2]) + (in2.matrix[1][2] * `in`.matrix[2][2])
    out.matrix[1][3] = (in2.matrix[1][0] * `in`.matrix[0][3]) + (in2.matrix[1][1] * `in`.matrix[1][3]) + (in2.matrix[1][2] * `in`.matrix[2][3]) + in2.matrix[1][3]
    // third row of out  out
    out.matrix[2][0] = (in2.matrix[2][0] * `in`.matrix[0][0]) + (in2.matrix[2][1] * `in`.matrix[1][0]) + (in2.matrix[2][2] * `in`.matrix[2][0])
    out.matrix[2][1] = (in2.matrix[2][0] * `in`.matrix[0][1]) + (in2.matrix[2][1] * `in`.matrix[1][1]) + (in2.matrix[2][2] * `in`.matrix[2][1])
    out.matrix[2][2] = (in2.matrix[2][0] * `in`.matrix[0][2]) + (in2.matrix[2][1] * `in`.matrix[1][2]) + (in2.matrix[2][2] * `in`.matrix[2][2])
    out.matrix[2][3] = (in2.matrix[2][0] * `in`.matrix[0][3]) + (in2.matrix[2][1] * `in`.matrix[1][3]) + (in2.matrix[2][2] * `in`.matrix[2][3]) + in2.matrix[2][3]
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1148
private func G2_GetBonePoolIndex(_ pMDXAHeader: MdxaHeader, _ iFrame: Int32, _ iBone: Int32) -> Int32 {
    // Port-note: Raven casts a record at a byte offset of `pMDXAHeader`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_GetBonePoolIndex
    portMissing("G2_GetBonePoolIndex", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1148")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1158
// TODO: Port signature
// Raven wrote: void UnCompressBone(float mat[3][4], int iBoneIndex, const mdxaHeader_t *pMDXAHeader, int iFrame)
// No table row for `float[3][4] mat`.
func UnCompressBone() -> Never {
    // TODO: Port UnCompressBone
    portMissing("UnCompressBone", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1158")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1167
// TODO: Port signature
// Raven wrote: void G2_TimingModel(boneInfo_t &bone,int currentTime,int numFramesInFile,int &currentFrame,int &newFrame,float &lerp)
// No table row for `int & currentFrame`.
func G2_TimingModel() -> Never {
    // TODO: Port G2_TimingModel
    portMissing("G2_TimingModel", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1167")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1417
func G2_RagGetAnimMatrix(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ matrix: JKAMP.MdxaBone, _ frame: Int32) {
    // Port-note: Raven casts a record at a byte offset of `ghoul2.mBoneCache->header`, and the view target has no accessor for a view at a byte offset.
    // Port-note: The body calls UnCompressBone, which keeps its signature marker.
    // TODO: Port G2_RagGetAnimMatrix
    portMissing("G2_RagGetAnimMatrix", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1417")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1541
func G2_TransformBone(_ child: Int32, _ BC: CBoneCache) {
    // Port-note: Raven casts a record at a byte offset of `BC.header`, and the view target has no accessor for a view at a byte offset.
    // Port-note: The body calls G2_TimingModel and UnCompressBone, which keep their signature markers.
    // TODO: Port G2_TransformBone
    portMissing("G2_TransformBone", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1541")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2053
func G2_SetUpBolts(_ header: MdxaHeader, _ ghoul2: CGhoul2Info, _ bonePtr: inout [(Int32, MdxaBone)], _ boltList: inout [boltInfo_t]) {
    // Port-note: Raven casts a record at a byte offset of `header`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_SetUpBolts
    portMissing("G2_SetUpBolts", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2053")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2075
func G2_TransformGhoulBones(_ rootBoneList: inout [boneInfo_t], _ rootMatrix: JKAMP.MdxaBone, _ ghoul2: CGhoul2Info, _ time: Int32, _ smooth: Bool = true) {
    G2PerformanceTimer_G2_TransformGhoulBones.Start()
    G2PerformanceCounter_G2_TransformGhoulBones += 1

    /*
    model_t			*currentModel;
    model_t			*animModel;
    mdxaHeader_t	*aHeader;

    //currentModel = R_GetModelByHandle(RE_RegisterModel(ghoul2.mFileName));
    currentModel = R_GetModelByHandle(ghoul2.mModel);
    assert(currentModel);
    assert(currentModel->mdxm);

    animModel =  R_GetModelByHandle(currentModel->mdxm->animIndex);
    assert(animModel);
    aHeader = animModel->mdxa;
    assert(aHeader);
    */
    let currentModel = ghoul2.currentModel
    let aHeader = ghoul2.aHeader

    assert(ghoul2.aHeader != nil)
    assert(ghoul2.currentModel != nil)
    assert(ghoul2.currentModel!.mdxm != nil)
    if aHeader!.numBones == 0 {
        assert(false) // this would be strange
        return
    }
    if ghoul2.mBoneCache == nil {
        ghoul2.mBoneCache = CBoneCache(currentModel, aHeader)

        g_Ghoul2Allocations += sizeofCBoneCache
    }
    ghoul2.mBoneCache!.mod = currentModel
    ghoul2.mBoneCache!.header = aHeader
    assert(ghoul2.mBoneCache!.mBones.count == aHeader!.numBones)

    ghoul2.mBoneCache!.mSmoothingActive = false
    ghoul2.mBoneCache!.mUnsquash = false

    // master smoothing control
    if HackadelicOnClient && smooth && com_dedicated!.integer == 0 {
        ghoul2.mBoneCache!.mLastTouch = ghoul2.mBoneCache!.mLastLastTouch
        /*
        float val=r_Ghoul2AnimSmooth->value;
        if (smooth&&val>0.0f&&val<1.0f)
        {
        //	if (HackadelicOnClient)
        //	{
                ghoul2.mBoneCache->mLastTouch=ghoul2.mBoneCache->mLastLastTouch;
        //	}

            ghoul2.mBoneCache->mSmoothFactor=val;
            ghoul2.mBoneCache->mSmoothingActive=true;
            if (r_Ghoul2UnSqashAfterSmooth->integer)
            {
                ghoul2.mBoneCache->mUnsquash=true;
            }
        }
        else
        {
            ghoul2.mBoneCache->mSmoothFactor=1.0f;
        }
        */

        // master smoothing control
        var val: Float = r_Ghoul2AnimSmooth!.value
        if val > 0.0 && val < 1.0 {
            //if (ghoul2.mFlags&GHOUL2_RESERVED_FOR_RAGDOLL)
            if (ghoul2.mFlags & GHOUL2_CRAZY_SMOOTH) != 0 {
                val = 0.9
            } else if (ghoul2.mFlags & GHOUL2_RAG_STARTED) != 0 {
                var k: Int32
                k = 0
                while k < rootBoneList.count {
                    let bone = rootBoneList[k]
                    if (bone.flags & BONE_ANGLES_RAGDOLL) != 0 {
                        if bone.firstCollisionTime != 0 &&
                            bone.firstCollisionTime > time - 250 &&
                            bone.firstCollisionTime < time
                        {
                            val = 0.9 //(val+0.8f)/2.0f;
                        } else if bone.airTime > time {
                            val = 0.2
                        } else {
                            val = 0.8
                        }
                        break
                    }
                    k += 1
                }
            }

//			ghoul2.mBoneCache->mSmoothFactor=(val + 1.0f-pow(1.0f-val,50.0f/dif))/2.0f;  // meaningless formula
            ghoul2.mBoneCache!.mSmoothFactor = val // meaningless formula
            ghoul2.mBoneCache!.mSmoothingActive = true

            if r_Ghoul2UnSqashAfterSmooth!.integer != 0 {
                ghoul2.mBoneCache!.mUnsquash = true
            }
        }
    } else {
        ghoul2.mBoneCache!.mSmoothFactor = 1.0
    }

    ghoul2.mBoneCache!.mCurrentTouch += 1

//rww - RAGDOLL_BEGIN
    if HackadelicOnClient {
        ghoul2.mBoneCache!.mLastLastTouch = ghoul2.mBoneCache!.mCurrentTouch
        ghoul2.mBoneCache!.mCurrentTouchRender = ghoul2.mBoneCache!.mCurrentTouch
    } else {
        ghoul2.mBoneCache!.mCurrentTouchRender = 0
    }
//rww - RAGDOLL_END

    ghoul2.mBoneCache!.frameSize = 0 // can be deleted in new G2 format	//(int)( &((mdxaFrame_t *)0)->boneIndexes[ ghoul2.aHeader->numBones ] );

    // AI: Raven stores `&rootBoneList`. The cache stores `ghoul2`, because all four callers pass that instance's `mBlist`.
    ghoul2.mBoneCache!.rootBoneListOwner = ghoul2
    ghoul2.mBoneCache!.rootMatrix.copy(from: rootMatrix)
    ghoul2.mBoneCache!.incomingTime = time

    let TB = ghoul2.mBoneCache!.Root()
    TB.newFrame = 0
    TB.currentFrame = 0
    TB.backlerp = 0.0
    TB.blendFrame = 0
    TB.blendOldFrame = 0
    TB.blendMode = false
    TB.blendLerp = 0

    G2Time_G2_TransformGhoulBones += G2PerformanceTimer_G2_TransformGhoulBones.End()
}

// We've come across a surface that's designated as a bolt surface, process it and put it in the appropriate bolt place
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2246
func G2_ProcessSurfaceBolt(_ bonePtr: inout [(Int32, MdxaBone)], _ surface: MdxmSurface?, _ boltNum: Int32, _ boltList: inout [boltInfo_t], _ surfInfo: surfaceInfo_t?, _ mod: Model) {
    // Port-note: The body calls G2_FindSurface, which keeps its signature marker.
    // Port-note: Raven casts a record at a byte offset of `originalSurf`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_ProcessSurfaceBolt
    portMissing("G2_ProcessSurfaceBolt", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2246")
}

// now go through all the generated surfaces that aren't included in the model surface hierarchy and create the correct bolt info for them
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2495
func G2_ProcessGeneratedSurfaceBolts(_ ghoul2: CGhoul2Info, _ bonePtr: inout [(Int32, MdxaBone)], _ mod_t: Model) {
    // Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port G2_ProcessGeneratedSurfaceBolts
    portMissing("G2_ProcessGeneratedSurfaceBolts", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2495")
}

// Go through the model and deal with just the surfaces that are tagged as bolt on points - this is for the server side skeleton construction
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2739
func ProcessModelBoltSurfaces(_ surfaceNum: Int32, _ rootSList: inout [surfaceInfo_t], _ bonePtr: inout [(Int32, MdxaBone)], _ currentModel: Model, _ lod: Int32, _ boltList: inout [boltInfo_t]) {
    // Port-note: The body calls G2_FindSurface, which keeps its signature marker.
    // Port-note: Raven casts a record at a byte offset of `currentModel->mdxm`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port ProcessModelBoltSurfaces
    portMissing("ProcessModelBoltSurfaces", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2739")
}

// build the used bone list so when doing bone transforms we can determine if we need to do it or not
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2796
func G2_ConstructUsedBoneList(_ CBL: CConstructBoneList) {
    // Port-note: The body calls G2_FindSurface, which keeps its signature marker.
    // Port-note: Raven casts a record at a byte offset of `CBL.currentModel->mdxm`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_ConstructUsedBoneList
    portMissing("G2_ConstructUsedBoneList", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2796")
}

// NOTE!! This assumes at least one model will NOT have a parent. If it does - we are screwed
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2881
private func G2_Sort_Models(_ ghoul2: CGhoul2Info_v, _ modelList: Slots<Int32>, _ modelCount: inout Int32) {
    var startPoint: Int32
    var endPoint: Int32
    var i: Int32
    var boltTo: Int32
    var j: Int32

    modelCount = 0

    // first walk all the possible ghoul2 models, and stuff the out array with those with no parents
    i = 0
    while i < ghoul2.size() {
        // have a ghoul model here?
        if ghoul2[i].mModelindex == -1 {
            i += 1
            continue
        }

        if !ghoul2[i].mValid {
            i += 1
            continue
        }

        // are we attached to anything?
        if ghoul2[i].mModelBoltLink == -1 {
            // no, insert us first
            modelList[modelCount] = i
            modelCount += 1
        }
        i += 1
    }

    startPoint = 0
    endPoint = modelCount

    // now, using that list of parentless models, walk the descendant tree for each of them, inserting the descendents in the list
    while startPoint != endPoint {
        i = 0
        while i < ghoul2.size() {
            // have a ghoul model here?
            if ghoul2[i].mModelindex == -1 {
                i += 1
                continue
            }

            if !ghoul2[i].mValid {
                i += 1
                continue
            }

            // what does this model think it's attached to?
            if ghoul2[i].mModelBoltLink != -1 {
                boltTo = (ghoul2[i].mModelBoltLink >> MODEL_SHIFT) & MODEL_AND
                // is it any of the models we just added to the list?
                j = startPoint
                while j < endPoint {
                    // is this my parent model?
                    if boltTo == modelList[j] {
                        // yes, insert into list and exit now
                        modelList[modelCount] = i
                        modelCount += 1
                        break
                    }
                    j += 1
                }
            }
            i += 1
        }
        // update start and end points
        startPoint = endPoint
        endPoint = modelCount
    }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2952
// TODO: Port signature
// Raven wrote: void *G2_FindSurface_BC(const model_s *mod, int index, int lod)
// No table row for the return `void *`.
func G2_FindSurface_BC() -> Never {
    // TODO: Port G2_FindSurface_BC
    portMissing("G2_FindSurface_BC", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2952")
}

// We've come across a surface that's designated as a bolt surface, process it and put it in the appropriate bolt place
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2983
func G2_ProcessSurfaceBolt2(_ boneCache: CBoneCache, _ surface: MdxmSurface, _ boltNum: Int32, _ boltList: inout [boltInfo_t], _ surfInfo: surfaceInfo_t?, _ mod: Model, _ retMatrix: JKAMP.MdxaBone) {
    // Port-note: The body calls G2_FindSurface_BC, which keeps its signature marker.
    // Port-note: Raven casts a record at a byte offset of `originalSurf`, and the view target has no accessor for a view at a byte offset.
    // TODO: Port G2_ProcessSurfaceBolt2
    portMissing("G2_ProcessSurfaceBolt2", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2983")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3253
func G2_GetBoltMatrixLow(_ ghoul2: CGhoul2Info, _ boltNum: Int32, _ scale: JKAShared.vec3_t, _ retMatrix: JKAMP.MdxaBone) {
    // Port-note: The file-scope `identityMatrix` has no storage.
    // Port-note: Raven casts a record at a byte offset of `boneCache.header`, and the view target has no accessor for a view at a byte offset.
    // Port-note: The body calls G2_FindSurface_BC, which keeps its signature marker.
    // TODO: Port G2_GetBoltMatrixLow
    portMissing("G2_GetBoltMatrixLow", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3253")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3333
private func RootMatrix(_ ghoul2: CGhoul2Info_v, _ time: Int32, _ scale: JKAShared.vec3_t, _ retMatrix: JKAMP.MdxaBone) {
    // Port-note: The file-scope `identityMatrix` has no storage.
    // TODO: Port RootMatrix
    portMissing("RootMatrix", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3333")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3369
private func bInShadowRange(_ location: JKAShared.vec3_t) -> Bool {
    // Raven's one call is in R_AddGhoulSurfaces under `#ifndef DEDICATED` at tr_ghoul2.cpp:3384, so the function is dead in the dedicated build.
    // TODO: Port bInShadowRange
    portMissing("bInShadowRange", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3369")
}

/**
```
==============
R_AddGHOULSurfaces
==============
```
*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3383
func R_AddGhoulSurfaces(_ ent: TrRefEntity) {
    // Raven's whole body stands under `#ifndef DEDICATED`, so the dedicated build has an empty body.
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3544
func G2_NeedsRecalc(_ ghlInfo: CGhoul2Info?, _ frameNum: Int32) -> Bool {
    G2_SetupModelPointers(ghlInfo)
    // not sure if I still need this test, probably
    if ghlInfo!.mSkelFrameNum != frameNum ||
        ghlInfo!.mBoneCache == nil ||
        ghlInfo!.mBoneCache!.mod != ghlInfo!.currentModel
    {
        ghlInfo!.mSkelFrameNum = frameNum
        return true
    }
    return false
}

/**
```
==============
G2_ConstructGhoulSkeleton - builds a complete skeleton for all ghoul models in a CGhoul2Info_v class	- using LOD 0
==============
```
*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3579
// AI: Raven declares `modelList` on the stack of G2_ConstructGhoulSkeleton. The function uses one zeroed allocation on the storage class.
var modelList_G2_ConstructGhoulSkeleton: Slots<Int32> { world.storage.modelList_G2_ConstructGhoulSkeleton }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3570
func G2_ConstructGhoulSkeleton(_ ghoul2: CGhoul2Info_v, _ frameNum: Int32, _ checkForNewOrigin: Bool, _ scale: JKAShared.vec3_t) {
    // Port-note: The file-scope `identityMatrix` has no storage, and the local `int modelList[256]` has no `Slots<Int32>` storage for G2_Sort_Models.
    // TODO: Port G2_ConstructGhoulSkeleton
    portMissing("G2_ConstructGhoulSkeleton", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3570")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:4816
func R_LoadMDXM(_ mod: Model, _ buffer: Slots<JKAShared.byte>, _ mod_name: String, _ bAlreadyCached: inout Bool) -> Bool {
    var i: Int32
    var l: Int32
    var j: Int32
    var pinmodel: MdxmHeader
    var mdxm: MdxmHeader
    var lod: MdxmLOD
    var surf: MdxmSurface
    var version: Int32
    var size: Int32
    var surfInfo: MdxmSurfHierarchy

    pinmodel = MdxmHeader(buffer.base)
    //
    // read some fields from the binary, but only LittleLong() them when we know this wasn't an already-cached model...
    //
    version = pinmodel.version
    size = pinmodel.ofsEnd

    // Raven's two LittleLong calls under `if (!bAlreadyCached)` have no line, because LittleLong of the WinDed arm is its argument.

    if version != MDXM_VERSION {
        Com_Printf(S_COLOR_YELLOW + "R_LoadMDXM: %s has wrong version (%i should be %i)\n",
                   mod_name, version, MDXM_VERSION)
        return false
    }

    mod.type = MOD_MDXM
    mod.dataSize += size

    var bAlreadyFound = false
    mdxm = MdxmHeader(/*Hunk_Alloc( size );*/ RE_RegisterModels_Malloc(size, buffer, mod_name, &bAlreadyFound, TAG_MODEL_GLM).base)
    mod.mdxm = mdxm

    assert(bAlreadyCached == bAlreadyFound)

    if !bAlreadyFound {
        // horrible new hackery, if !bAlreadyFound then we've just done a tag-morph, so we need to set the
        //	bool reference passed into this function to true, to tell the caller NOT to do an FS_Freefile since
        //	we've hijacked that memory block...
        //
        // Aaaargh. Kill me now...
        //
        bAlreadyCached = true
        assert(mdxm == MdxmHeader(buffer.base))
        //		memcpy( mdxm, buffer, size );	// and don't do this now, since it's the same thing

        // Raven's seven LL calls have no line, because LittleLong of the WinDed arm is its argument.
    }

    // first up, go load in the animation file we need that has the skeletal animation info for this model
    mdxm.animIndex = RE_RegisterModel(va("%s.gla", mdxm.animName))

    if mdxm.animIndex == 0 {
        Com_Printf(S_COLOR_YELLOW + "R_LoadMDXM: missing animation file %s for mesh %s\n", mdxm.animName, mdxm.name)
        return false
    }

    mod.numLods = mdxm.numLODs - 1 //copy this up to the model for ease of use - it wil get inced after this.

    if bAlreadyFound {
        return true // All done. Stop, go no further, do not LittleLong(), do not pass Go...
    }

    var isAnOldModelFile = false
    if mdxm.numBones == 72 && strstr(mdxm.animName, "_humanoid") != nil {
        isAnOldModelFile = true
    }

    surfInfo = MdxmSurfHierarchy(mdxm, byteOffset: mdxm.ofsSurfHierarchy)
    i = 0
    while i < mdxm.numSurfaces {
        // Raven's LL calls of the two counts have no line, because LittleLong of the WinDed arm is its argument.

        Q_strlwr(&surfInfo.nameBuffer) //just in case
        // Port-note: Raven reads before the buffer when the surface name has fewer than four bytes. The cursor reads the empty text there.
        if strcmp(TextCursor(surfInfo.nameBuffer, at: strlen(surfInfo.name) - 4).text, "_off") == 0 {
            surfInfo.nameBuffer[strlen(surfInfo.name) - 4] = 0 //remove "_off" from name
        }

        // Raven's LL call of each child index has no line, because LittleLong of the WinDed arm is its argument.
        surfInfo.shaderIndex = 0
        // AI: Raven hands the addresses of the two fields. The call hands their byte distances from the disk image, which the callee stores.
        RE_RegisterModels_StoreShaderRequest(mod_name, surfInfo.shader(buffer), surfInfo.shaderIndex(buffer))

        // find the next surface
        surfInfo = MdxmSurfHierarchy(surfInfo, byteOffset: MdxmSurfHierarchy.byteCount(childIndexes: surfInfo.numChildren))
        i += 1
    }

    // swap all the LOD's	(we need to do the middle part of this even for intel, because of shader reg and err-check)
    lod = MdxmLOD(mdxm, byteOffset: mdxm.ofsLODs)
    l = 0
    while l < mdxm.numLODs {
        var triCount: Int32 = 0

        // swap all the surfaces
        surf = MdxmSurface(lod, byteOffset: Int32(MdxmLOD.byteCount) + (mdxm.numSurfaces * Int32(MdxmLODSurfOffset.byteCount)))
        i = 0
        while i < mdxm.numSurfaces {
            // Raven's LL calls of the counts and offsets have no line, because LittleLong of the WinDed arm is its argument.

            triCount += surf.numTriangles

            if surf.numVerts > SHADER_MAX_VERTEXES {
                Com_Error(ERR_DROP, "R_LoadMDXM: %s has more than %i verts on a surface (%i)",
                          mod_name, SHADER_MAX_VERTEXES, surf.numVerts)
            }
            if surf.numTriangles * 3 > SHADER_MAX_INDEXES {
                Com_Error(ERR_DROP, "R_LoadMDXM: %s has more than %i triangles on a surface (%i)",
                          mod_name, SHADER_MAX_INDEXES / 3, surf.numTriangles)
            }

            // change to surface identifier
            surf.ident = SF_MDX
            // register the shaders

            if isAnOldModelFile {
                let boneRef = surf.boneReferences
                j = 0
                while j < surf.numBoneReferences {
                    assert(boneRef[j] >= 0 && boneRef[j] < 72)
                    if boneRef[j] >= 0 && boneRef[j] < 72 {
                        boneRef[j] = OldToNewRemapTable[boneRef[j]]
                    } else {
                        boneRef[j] = 0
                    }
                    j += 1
                }
            }
            // find the next surface
            surf = MdxmSurface(surf, byteOffset: surf.ofsEnd)
            i += 1
        }
        // find the next LOD
        lod = MdxmLOD(lod, byteOffset: lod.ofsEnd)
        l += 1
    }
    return true
}

/**
```
=================
R_LoadMDXA - load a Ghoul 2 animation file
=================
```
*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:5256
func R_LoadMDXA(_ mod: Model, _ buffer: Slots<JKAShared.byte>, _ mod_name: String, _ bAlreadyCached: inout Bool) -> Bool {
    var pinmodel: MdxaHeader
    var mdxa: MdxaHeader
    var version: Int32
    var size: Int32

    pinmodel = MdxaHeader(buffer.base)
    //
    // read some fields from the binary, but only LittleLong() them when we know this wasn't an already-cached model...
    //
    version = pinmodel.version
    size = pinmodel.ofsEnd

    // Raven's two LittleLong calls under `if (!bAlreadyCached)` have no line, because LittleLong of the WinDed arm is its argument.

    if version != MDXA_VERSION {
        Com_Printf(S_COLOR_YELLOW + "R_LoadMDXA: %s has wrong version (%i should be %i)\n",
                   mod_name, version, MDXA_VERSION)
        return false
    }

    mod.type = MOD_MDXA
    mod.dataSize += size

    var bAlreadyFound = false

    mdxa = MdxaHeader(/*Hunk_Alloc( size );*/ RE_RegisterModels_Malloc(size, buffer, mod_name, &bAlreadyFound, TAG_MODEL_GLA).base)
    mod.mdxa = mdxa

    assert(bAlreadyCached == bAlreadyFound) // I should probably eliminate 'bAlreadyFound', but wtf?

    if !bAlreadyFound {
        // horrible new hackery, if !bAlreadyFound then we've just done a tag-morph, so we need to set the
        //	bool reference passed into this function to true, to tell the caller NOT to do an FS_Freefile since
        //	we've hijacked that memory block...
        //
        // Aaaargh. Kill me now...
        //
        bAlreadyCached = true
        assert(mdxa == MdxaHeader(buffer.base))
        //		memcpy( mdxa, buffer, size );	// and don't do this now, since it's the same thing

        // Raven's six LL calls have no line, because LittleLong of the WinDed arm is its argument.
    }

    if mdxa.numFrames < 1 {
        Com_Printf(S_COLOR_YELLOW + "R_LoadMDXA: %s has no frames\n", mod_name)
        return false
    }

    if bAlreadyFound {
        return true // All done, stop here, do not LittleLong() etc. Do not pass go...
    }

    return true
}
