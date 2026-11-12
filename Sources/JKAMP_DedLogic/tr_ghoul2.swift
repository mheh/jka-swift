import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:42
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_RenderSurfaces: timing_c { world.G2PerformanceTimer_RenderSurfaces }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:43
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_R_AddGHOULSurfaces: timing_c { world.G2PerformanceTimer_R_AddGHOULSurfaces }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:44
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_G2_TransformGhoulBones: timing_c { world.G2PerformanceTimer_G2_TransformGhoulBones }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:45
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_G2_ProcessGeneratedSurfaceBolts: timing_c { world.G2PerformanceTimer_G2_ProcessGeneratedSurfaceBolts }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:46
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_ProcessModelBoltSurfaces: timing_c { world.G2PerformanceTimer_ProcessModelBoltSurfaces }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:47
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_G2_ConstructGhoulSkeleton: timing_c { world.G2PerformanceTimer_G2_ConstructGhoulSkeleton }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:48
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_RB_SurfaceGhoul: timing_c { world.G2PerformanceTimer_RB_SurfaceGhoul }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:49
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_G2_SetupModelPointers: timing_c { world.G2PerformanceTimer_G2_SetupModelPointers }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:50
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2PerformanceTimer_PreciseFrame: timing_c { world.G2PerformanceTimer_PreciseFrame }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:52
public var G2PerformanceCounter_G2_TransformGhoulBones: Int32 {
    get { world.variables.G2PerformanceCounter_G2_TransformGhoulBones }
    set { world.variables.G2PerformanceCounter_G2_TransformGhoulBones = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:54
public var G2Time_RenderSurfaces: Int32 {
    get { world.variables.G2Time_RenderSurfaces }
    set { world.variables.G2Time_RenderSurfaces = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:55
public var G2Time_R_AddGHOULSurfaces: Int32 {
    get { world.variables.G2Time_R_AddGHOULSurfaces }
    set { world.variables.G2Time_R_AddGHOULSurfaces = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:56
public var G2Time_G2_TransformGhoulBones: Int32 {
    get { world.variables.G2Time_G2_TransformGhoulBones }
    set { world.variables.G2Time_G2_TransformGhoulBones = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:57
public var G2Time_G2_ProcessGeneratedSurfaceBolts: Int32 {
    get { world.variables.G2Time_G2_ProcessGeneratedSurfaceBolts }
    set { world.variables.G2Time_G2_ProcessGeneratedSurfaceBolts = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:58
public var G2Time_ProcessModelBoltSurfaces: Int32 {
    get { world.variables.G2Time_ProcessModelBoltSurfaces }
    set { world.variables.G2Time_ProcessModelBoltSurfaces = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:59
public var G2Time_G2_ConstructGhoulSkeleton: Int32 {
    get { world.variables.G2Time_G2_ConstructGhoulSkeleton }
    set { world.variables.G2Time_G2_ConstructGhoulSkeleton = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:60
public var G2Time_RB_SurfaceGhoul: Int32 {
    get { world.variables.G2Time_RB_SurfaceGhoul }
    set { world.variables.G2Time_RB_SurfaceGhoul = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:61
public var G2Time_G2_SetupModelPointers: Int32 {
    get { world.variables.G2Time_G2_SetupModelPointers }
    set { world.variables.G2Time_G2_SetupModelPointers = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:62
public var G2Time_PreciseFrame: Int32 {
    get { world.variables.G2Time_PreciseFrame }
    set { world.variables.G2Time_PreciseFrame = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:104
// Raven wrote: bool HackadelicOnClient=false
public let HackadelicOnClient: Bool = false // means this is a render traversal

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:128
// Raven wrote: const static mdxaBone_t identityMatrix
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:136
public var worldMatrix: JKAMP.MdxaBone { world.storage.worldMatrix }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:137
public var worldMatrixInv: JKAMP.MdxaBone { world.storage.worldMatrixInv }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:139
// Raven wrote: qhandle_t goreShader=-1
public let goreShader: JKAShared.qhandle_t = -1

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:865
let MAX_RENDER_SURFACES = (2048) as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:866
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var RSStorage: [CRenderableSurface] {
    get { world.RSStorage }
    set { world.RSStorage = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:867
var NextRS: UInt32 {
    get { world.variables.NextRS }
    set { world.variables.NextRS = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1164
private let DEBUG_G2_TIMING = (0) as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1165
let DEBUG_G2_TIMING_RENDER_ONLY = (1) as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1544
// AI: Raven declares `tbone` static in G2_TransformBone. The function uses one zeroed allocation on the storage class.
var tbone_G2_TransformBone: Slots<JKAMP.MdxaBone> { world.storage.tbone_G2_TransformBone }

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1549
var skel: MdxaSkel? {
    get { world.skel }
    set { world.skel = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1550
var offsets: MdxaSkelOffsets? {
    get { world.offsets }
    set { world.offsets = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1552
var j_G2_TransformBone: Int32 {
    get { world.j_G2_TransformBone }
    set { world.j_G2_TransformBone = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1552
var boneListIndex: Int32 {
    get { world.boneListIndex }
    set { world.boneListIndex = newValue }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2071
private let GHOUL2_RAG_STARTED = 0x0010 as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2238
let MDX_TAG_ORIGIN = 2 as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:4469
// Raven wrote: int OldToNewRemapTable[72]
public let OldToNewRemapTable: [Int32] = [
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
public func G2Time_ResetTimers() {
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
public func G2Time_ReportTimers() {
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
    var i: Int32 = 0

    while i < blist.count {
        if blist[i].boneNumber == boneNum {
            return i
        }
        i += 1
    }

    return -1
}

/// The byte size of Raven's `CBoneCache` in the 32-bit build, which `g_Ghoul2Allocations` counts at each new and each delete.
/// The members are `frameSize`, two pointers, three vectors of 16 bytes, the `rootBoneList` pointer, the `rootMatrix` record of 48 bytes,
/// five ints, two bools with padding, and one float: 12 + 48 + 4 + 48 + 20 + 4 + 4.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:572
// AI: Raven takes `sizeof` of the C++ class. The Swift class has no byte size, so the constant holds the byte count of the 32-bit build.
private let sizeofCBoneCache = 140 as Int32

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:569
public func RemoveBoneCache(_ boneCache: CBoneCache?) {
    g_Ghoul2Allocations -= sizeofCBoneCache

    // AI: Raven deletes the cache. ARC frees the cache when the last reference drops, so the body holds no statement.
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:585
// AI: Raven returns a reference to the matrix. The function returns the view of the matrix, the form of `CBoneCache.Eval`.
public func EvalBoneCache(_ index: Int32, _ boneCache: CBoneCache?) -> MdxaBone {
    return boneCache!.Eval(index)
}

//rww - RAGDOLL_BEGIN
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:592
public func G2_GetModA(_ ghoul2: CGhoul2Info) -> MdxaHeader? {
    if ghoul2.mBoneCache == nil {
        return nil
    }

    let boneCache = ghoul2.mBoneCache!
    return boneCache.header
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:603
public func G2_GetBoneDependents(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ tempDependents: Slots<Int32>, _ maxDep: Int32) -> Int32 {
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
public func G2_WasBoneRendered(_ ghoul2: CGhoul2Info, _ boneNum: Int32) -> Bool {
    if ghoul2.mBoneCache == nil {
        return false
    }
    let boneCache = ghoul2.mBoneCache!

    return boneCache.WasRendered(boneNum)
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:656
// AI: Raven takes `mdxaBone_t *&` for the two out pointers. The parameters are `inout MdxaBone?`, the form of a pointer to a record pointer.
public func G2_GetBoneBasepose(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ retBasepose: inout MdxaBone?, _ retBaseposeInv: inout MdxaBone?) {
    if ghoul2.mBoneCache == nil {
        // yikes
        retBasepose = identityMatrix
        retBaseposeInv = identityMatrix
        return
    }
    let boneCache = ghoul2.mBoneCache!

    let skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    offsets = MdxaSkelOffsets(boneCache.header!, byteOffset: MdxaHeader.byteCount)
    skel = MdxaSkel(boneCache.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[boneNum])
    retBasepose = skel.BasePoseMat
    retBaseposeInv = skel.BasePoseMatInv
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:678
public func G2_GetBoneNameFromSkel(_ ghoul2: CGhoul2Info, _ boneNum: Int32) -> String? {
    // Raven declares it at G2_bones.cpp:2607 and calls it from no file of either tree, so it is dead.
    if ghoul2.mBoneCache == nil {
        return nil
    }
    let boneCache = ghoul2.mBoneCache!
    assert(boneCache.mod != nil)
    assert(boneNum >= 0 && boneNum < boneCache.header!.numBones)

    let skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    offsets = MdxaSkelOffsets(boneCache.header!, byteOffset: MdxaHeader.byteCount)
    skel = MdxaSkel(boneCache.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[boneNum])

    return skel.name
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:696
public func G2_RagGetBoneBasePoseMatrixLow(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ boneMatrix: JKAMP.MdxaBone, _ retMatrix: JKAMP.MdxaBone, _ scale: JKAShared.vec3_t) {
    let boneCache = ghoul2.mBoneCache!

    let skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    offsets = MdxaSkelOffsets(boneCache.header!, byteOffset: MdxaHeader.byteCount)
    skel = MdxaSkel(boneCache.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[boneNum])
    Multiply_3x4Matrix(retMatrix, boneMatrix, skel.BasePoseMat)

    if scale[0] != 0 {
        retMatrix.matrix[0][3] *= scale[0]
    }
    if scale[1] != 0 {
        retMatrix.matrix[1][3] *= scale[1]
    }
    if scale[2] != 0 {
        retMatrix.matrix[2][3] *= scale[2]
    }

    // AI: Raven casts each row of four floats to a float pointer for VectorNormalize. The call normalizes the vector accessor of the row.
    _ = VectorNormalize(&retMatrix.matrix[0].vector)
    _ = VectorNormalize(&retMatrix.matrix[1].vector)
    _ = VectorNormalize(&retMatrix.matrix[2].vector)
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:727
// AI: Raven takes `mdxaBone_t *&` for the two out pointers. The parameters are `inout MdxaBone?`, the form of a pointer to a record pointer.
public func G2_GetBoneMatrixLow(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ scale: JKAShared.vec3_t, _ retMatrix: JKAMP.MdxaBone, _ retBasepose: inout MdxaBone?, _ retBaseposeInv: inout MdxaBone?) {
    if ghoul2.mBoneCache == nil {
        retMatrix.copy(from: identityMatrix)
        // yikes
        retBasepose = identityMatrix
        retBaseposeInv = identityMatrix
        return
    }
    MdxaBone.scratch { bolt in
        let boneCache = ghoul2.mBoneCache!

        let skel: MdxaSkel
        let offsets: MdxaSkelOffsets
        offsets = MdxaSkelOffsets(boneCache.header!, byteOffset: MdxaHeader.byteCount)
        skel = MdxaSkel(boneCache.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[boneNum])
        Multiply_3x4Matrix(bolt, boneCache.Eval(boneNum), skel.BasePoseMat) // DEST FIRST ARG
        retBasepose = skel.BasePoseMat
        retBaseposeInv = skel.BasePoseMatInv

        if scale[0] != 0 {
            bolt.matrix[0][3] *= scale[0]
        }
        if scale[1] != 0 {
            bolt.matrix[1][3] *= scale[1]
        }
        if scale[2] != 0 {
            bolt.matrix[2][3] *= scale[2]
        }
        // AI: Raven casts each row of four floats to a float pointer for VectorNormalize. The call normalizes the vector accessor of the row.
        _ = VectorNormalize(&bolt.matrix[0].vector)
        _ = VectorNormalize(&bolt.matrix[1].vector)
        _ = VectorNormalize(&bolt.matrix[2].vector)

        Multiply_3x4Matrix(retMatrix, worldMatrix, bolt)
    }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:780
// AI: Raven takes `mdxaBone_t *&` for the two out pointers. The parameters are `inout MdxaBone?`, the form of a pointer to a record pointer.
public func G2_GetParentBoneMatrixLow(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ scale: JKAShared.vec3_t, _ retMatrix: JKAMP.MdxaBone, _ retBasepose: inout MdxaBone?, _ retBaseposeInv: inout MdxaBone?) -> Int32 {
    // Raven's one call stands in a comment at G2_bones.cpp:1339, so no file of either tree calls it, and it is dead.
    var parent: Int32 = -1
    if ghoul2.mBoneCache != nil {
        let boneCache = ghoul2.mBoneCache!
        assert(boneCache.mod != nil)
        assert(boneNum >= 0 && boneNum < boneCache.header!.numBones)
        parent = boneCache.GetParent(boneNum)
        if parent < 0 || parent >= boneCache.header!.numBones {
            parent = -1
            retMatrix.copy(from: identityMatrix)
            // yikes
            retBasepose = identityMatrix
            retBaseposeInv = identityMatrix
        } else {
            G2_GetBoneMatrixLow(ghoul2, parent, scale, retMatrix, &retBasepose, &retBaseposeInv)
        }
    }
    return parent
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:869
public func AllocRS() -> CRenderableSurface? {
    // Raven's one call, tr_ghoul2.cpp:2660, is in RenderSurfaces under the `#ifndef DEDICATED` of :2520, so the function is dead in the dedicated build.
    let ret: CRenderableSurface = RSStorage[NextRS]
    ret.Init()
    NextRS += 1
    NextRS %= UInt32(MAX_RENDER_SURFACES)
    return ret
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
    // scale the radius if need be
    var largestScale: Float = ent.e.modelScale[0]

    if ent.e.modelScale[1] > largestScale {
        largestScale = ent.e.modelScale[1]
    }
    if ent.e.modelScale[2] > largestScale {
        largestScale = ent.e.modelScale[2]
    }
    if largestScale == 0 {
        largestScale = 1
    }

    // cull bounding sphere
    switch R_CullLocalPointAndRadius(vec3_origin, ent.e.radius * largestScale) {
    case CULL_OUT:
        tr.pc.c_sphere_cull_md3_out += 1
        return CULL_OUT

    case CULL_IN:
        tr.pc.c_sphere_cull_md3_in += 1
        return CULL_IN

    case CULL_CLIP:
        tr.pc.c_sphere_cull_md3_clip += 1
        return CULL_IN

    default:
        break
    }
    return CULL_IN
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
    var i: Int32
    var j: Int32
    var fog: Fog

    if (tr.refdef.rdflags & RDF_NOWORLDMODEL) != 0 {
        return 0
    }

    i = 1
    while i < tr.world!.numfogs {
        fog = tr.world!.fogsSlots[i]
        j = 0
        while j < 3 {
            if ent.e.origin[j] - ent.e.radius >= fog.bounds[1][j] {
                break
            }
            if ent.e.origin[j] + ent.e.radius <= fog.bounds[0][j] {
                break
            }
            j += 1
        }
        if j == 3 {
            return i
        }
        i += 1
    }

    return 0
}

// work out lod for this entity.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:967
private func G2_ComputeLOD(_ ent: TrRefEntity, _ currentModel: Model, _ lodBias: Int32) -> Int32 {
    // Raven's one call is in R_AddGhoulSurfaces under `#ifndef DEDICATED` at tr_ghoul2.cpp:3384, so the function is dead in the dedicated build.
    var lodBias = lodBias
    var flod: Float
    var lodscale: Float
    var projectedRadius: Float
    var lod: Int32

    if currentModel.numLods < 2 {
        // model has only 1 LOD level, skip computations and bias
        return 0
    }

    if r_lodbias!.integer > lodBias {
        lodBias = r_lodbias!.integer
    }

    // scale the radius if need be
    var largestScale: Float = ent.e.modelScale[0]

    if ent.e.modelScale[1] > largestScale {
        largestScale = ent.e.modelScale[1]
    }
    if ent.e.modelScale[2] > largestScale {
        largestScale = ent.e.modelScale[2]
    }
    if largestScale == 0 {
        largestScale = 1
    }

    projectedRadius = ProjectRadius(Float(0.75 * Double(largestScale) * Double(ent.e.radius)), ent.e.origin)
    if projectedRadius != 0 {	//we reduce the radius to make the LOD match other model types which use the actual bound box size
        lodscale = (r_lodscale!.value + r_autolodscalevalue!.value)
        if lodscale > 20 {
            lodscale = 20
        } else if lodscale < 0 {
            lodscale = 0
        }
        flod = 1.0 - projectedRadius * lodscale
    } else {
        // object intersects near view plane, e.g. view weapon
        flod = 0
    }
    flod *= currentModel.numLods
    lod = Int32(flod)

    if lod < 0 {
        lod = 0
    } else if lod >= currentModel.numLods {
        lod = currentModel.numLods - 1
    }

    lod += lodBias

    if lod >= currentModel.numLods {
        lod = currentModel.numLods - 1
    }
    if lod < 0 {
        lod = 0
    }

    return lod
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1048
public func G2_CreateQuaterion(_ mat: JKAMP.MdxaBone, _ quat: inout JKAShared.vec4_t) {
    // Raven calls this function from no file of either tree, so it is dead.
    // this is revised for the 3x4 matrix we use in G2.
    let t: Float = 1 + mat.matrix[0][0] + mat.matrix[1][1] + mat.matrix[2][2]
    var s: Float

    //If the trace of the matrix is greater than zero, then
    //perform an "instant" calculation.
    //Important note wrt. rouning errors:
    //Test if ( T > 0.00000001 ) to avoid large distortions!
    if Double(t) > 0.00000001 {
        s = sqrt(t) * 2
        quat[0] = (mat.matrix[1][2] - mat.matrix[2][1]) / s
        quat[1] = (mat.matrix[2][0] - mat.matrix[0][2]) / s
        quat[2] = (mat.matrix[0][1] - mat.matrix[1][0]) / s
        quat[3] = Float(0.25 * Double(s))
    } else {
        //If the trace of the matrix is equal to zero then identify
        //which major diagonal element has the greatest value.

        //Depending on this, calculate the following:

        if mat.matrix[0][0] > mat.matrix[1][1] && mat.matrix[0][0] > mat.matrix[2][2] {
            // Column 0:
            s = Float(sqrt(1.0 + Double(mat.matrix[0][0]) - Double(mat.matrix[1][1]) - Double(mat.matrix[2][2])) * 2)
            quat[0] = Float(0.25 * Double(s))
            quat[1] = (mat.matrix[0][1] + mat.matrix[1][0]) / s
            quat[2] = (mat.matrix[2][0] + mat.matrix[0][2]) / s
            quat[3] = (mat.matrix[1][2] - mat.matrix[2][1]) / s
        } else if mat.matrix[1][1] > mat.matrix[2][2] {
            // Column 1:
            s = Float(sqrt(1.0 + Double(mat.matrix[1][1]) - Double(mat.matrix[0][0]) - Double(mat.matrix[2][2])) * 2)
            quat[0] = (mat.matrix[0][1] + mat.matrix[1][0]) / s
            quat[1] = Float(0.25 * Double(s))
            quat[2] = (mat.matrix[1][2] + mat.matrix[2][1]) / s
            quat[3] = (mat.matrix[2][0] - mat.matrix[0][2]) / s
        } else {
            // Column 2:
            s = Float(sqrt(1.0 + Double(mat.matrix[2][2]) - Double(mat.matrix[0][0]) - Double(mat.matrix[1][1])) * 2)
            quat[0] = (mat.matrix[2][0] + mat.matrix[0][2]) / s
            quat[1] = (mat.matrix[1][2] + mat.matrix[2][1]) / s
            quat[2] = Float(0.25 * Double(s))
            quat[3] = (mat.matrix[0][1] - mat.matrix[1][0]) / s
        }
    }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1097
public func G2_CreateMatrixFromQuaterion(_ mat: JKAMP.MdxaBone, _ quat: JKAShared.vec4_t) {
    // Raven calls this function from no file of either tree, so it is dead.
    let xx: Float = quat[0] * quat[0]
    let xy: Float = quat[0] * quat[1]
    let xz: Float = quat[0] * quat[2]
    let xw: Float = quat[0] * quat[3]

    let yy: Float = quat[1] * quat[1]
    let yz: Float = quat[1] * quat[2]
    let yw: Float = quat[1] * quat[3]

    let zz: Float = quat[2] * quat[2]
    let zw: Float = quat[2] * quat[3]

    mat.matrix[0][0] = 1 - 2 * (yy + zz)
    mat.matrix[1][0] = 2 * (xy - zw)
    mat.matrix[2][0] = 2 * (xz + yw)

    mat.matrix[0][1] = 2 * (xy + zw)
    mat.matrix[1][1] = 1 - 2 * (xx + zz)
    mat.matrix[2][1] = 2 * (yz - xw)

    mat.matrix[0][2] = 2 * (xz - yw)
    mat.matrix[1][2] = 2 * (yz + xw)
    mat.matrix[2][2] = 1 - 2 * (xx + yy)

    mat.matrix[2][3] = 0
    mat.matrix[1][3] = mat.matrix[2][3]
    mat.matrix[0][3] = mat.matrix[1][3]
}

// nasty little matrix multiply going on here..
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1128
public func Multiply_3x4Matrix(_ out: JKAMP.MdxaBone, _ in2: JKAMP.MdxaBone, _ `in`: JKAMP.MdxaBone) {
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
    let iOffsetToIndex: Int32 = (iFrame * pMDXAHeader.numBones * 3) + (iBone * 3)

    let pIndex = MdxaIndex(pMDXAHeader, byteOffset: pMDXAHeader.ofsFrames + iOffsetToIndex)

    return pIndex.iIndex & 0x00FFFFFF	// this will cause problems for big-endian machines... ;-)
}

/*static inline*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1158
public func UnCompressBone(_ mat: JKAMP.MdxaBone?, _ iBoneIndex: Int32, _ pMDXAHeader: MdxaHeader, _ iFrame: Int32) {
    // AI: Raven indexes the record pointer at `ofsCompBonePool` of the header.
    // The element is the view at that offset plus the pool index times the record size.
    let pCompBonePool = MdxaCompQuatBone(pMDXAHeader, byteOffset: pMDXAHeader.ofsCompBonePool + G2_GetBonePoolIndex(pMDXAHeader, iFrame, iBoneIndex) * Int32(MdxaCompQuatBone.byteCount))
    MC_UnCompressQuat(mat, pCompBonePool.Comp)
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1167
public func G2_TimingModel(_ bone: boneInfo_t, _ currentTime: Int32, _ numFramesInFile: Int32, _ currentFrame: inout Int32, _ newFrame: inout Int32, _ lerp: inout Float) {
    // yes - add in animation speed to current frame
    let animSpeed = bone.animSpeed
    var time: Float
    if bone.pauseTime != 0 {
        time = (bone.pauseTime - bone.startTime) / 50.0
    } else {
        time = (currentTime - bone.startTime) / 50.0
    }
    if time < 0.0 {
        time = 0.0
    }
    var newFrame_g: Float = bone.startFrame + (time * animSpeed)

    let animSize = bone.endFrame - bone.startFrame
    let endFrame = Float(bone.endFrame)
    // we are supposed to be animating right?
    if animSize != 0 {
        // did we run off the end?
        if ((animSpeed > 0.0) && (newFrame_g > endFrame - 1)) ||
            ((animSpeed < 0.0) && (newFrame_g < endFrame + 1))
        {
            // yep - decide what to do
            if (bone.flags & BONE_ANIM_OVERRIDE_LOOP) != 0 {
                // get our new animation frame back within the bounds of the animation set
                if animSpeed < 0.0 {
                    // we don't use this case, or so I am told
                    // if we do, let me know, I need to insure the mod works

                    // should we be creating a virtual frame?
                    if (newFrame_g < endFrame + 1) && (newFrame_g >= endFrame) {
                        // now figure out what we are lerping between
                        // delta is the fraction between this frame and the next, since the new anim is always at a .0f;
                        lerp = Float(endFrame + 1) - newFrame_g
                        // frames are easy to calculate
                        currentFrame = Int32(endFrame)
                        newFrame = bone.startFrame
                    } else {
                        if newFrame_g <= endFrame + 1 {
                            newFrame_g = endFrame + fmod(newFrame_g - endFrame, Float(animSize)) - animSize
                        }
                        // now figure out what we are lerping between
                        // delta is the fraction between this frame and the next, since the new anim is always at a .0f;
                        lerp = (ceil(newFrame_g) - newFrame_g)
                        // frames are easy to calculate
                        currentFrame = Int32(ceil(newFrame_g))
                        // should we be creating a virtual frame?
                        if currentFrame <= endFrame + 1 {
                            newFrame = bone.startFrame
                        } else {
                            newFrame = currentFrame - 1
                        }
                    }
                } else {
                    // should we be creating a virtual frame?
                    if (newFrame_g > endFrame - 1) && (newFrame_g < endFrame) {
                        // now figure out what we are lerping between
                        // delta is the fraction between this frame and the next, since the new anim is always at a .0f;
                        lerp = (newFrame_g - Int32(newFrame_g))
                        // frames are easy to calculate
                        currentFrame = Int32(newFrame_g)
                        newFrame = bone.startFrame
                    } else {
                        if newFrame_g >= endFrame {
                            newFrame_g = endFrame + fmod(newFrame_g - endFrame, Float(animSize)) - animSize
                        }
                        // now figure out what we are lerping between
                        // delta is the fraction between this frame and the next, since the new anim is always at a .0f;
                        lerp = (newFrame_g - Int32(newFrame_g))
                        // frames are easy to calculate
                        currentFrame = Int32(newFrame_g)
                        // should we be creating a virtual frame?
                        if newFrame_g >= endFrame - 1 {
                            newFrame = bone.startFrame
                        } else {
                            newFrame = currentFrame + 1
                        }
                    }
                }
                // sanity check
            } else {
                if (bone.flags & (BONE_ANIM_OVERRIDE_FREEZE)) == (BONE_ANIM_OVERRIDE_FREEZE) {
                    // if we are supposed to reset the default anim, then do so
                    if animSpeed > 0.0 {
                        currentFrame = bone.endFrame - 1
                    } else {
                        currentFrame = bone.endFrame + 1
                    }

                    newFrame = currentFrame
                    lerp = 0
                } else {
                    bone.flags &= ~(BONE_ANIM_TOTAL)
                }
            }
        } else {
            if animSpeed > 0.0 {
                // frames are easy to calculate
                currentFrame = Int32(newFrame_g)

                // figure out the difference between the two frames	- we have to decide what frame and what percentage of that
                // frame we want to display
                lerp = (newFrame_g - currentFrame)

                newFrame = currentFrame + 1
                // are we now on the end frame?
                if newFrame >= Int32(endFrame) {
                    // we only want to lerp with the first frame of the anim if we are looping
                    if (bone.flags & BONE_ANIM_OVERRIDE_LOOP) != 0 {
                        newFrame = bone.startFrame
                    }
                    // if we intend to end this anim or freeze after this, then just keep on the last frame
                    else {
                        newFrame = bone.endFrame - 1
                    }
                }
            } else {
                lerp = (ceil(newFrame_g) - newFrame_g)
                // frames are easy to calculate
                currentFrame = Int32(ceil(newFrame_g))
                if currentFrame > bone.startFrame {
                    currentFrame = bone.startFrame
                    newFrame = currentFrame
                    lerp = 0.0
                } else {
                    newFrame = currentFrame - 1
                    // are we now on the end frame?
                    if newFrame < endFrame + 1 {
                        // we only want to lerp with the first frame of the anim if we are looping
                        if (bone.flags & BONE_ANIM_OVERRIDE_LOOP) != 0 {
                            newFrame = bone.startFrame
                        }
                        // if we intend to end this anim or freeze after this, then just keep on the last frame
                        else {
                            newFrame = bone.endFrame + 1
                        }
                    }
                }
            }
        }
    } else {
        if animSpeed < 0.0 {
            currentFrame = bone.endFrame + 1
        } else {
            currentFrame = bone.endFrame - 1
        }
        if currentFrame < 0 {
            currentFrame = 0
        }
        newFrame = currentFrame
        lerp = 0
    }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1417
public func G2_RagGetAnimMatrix(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ matrix: JKAMP.MdxaBone, _ frame: Int32) {
    MdxaBone.scratch { animMatrix in
        let skel: MdxaSkel
        let pskel: MdxaSkel
        let offsets: MdxaSkelOffsets
        let parent: Int32
        var bListIndex: Int32
        var parentBlistIndex: Int32

        assert(ghoul2.mBoneCache != nil)
        assert(ghoul2.animModel != nil)

        offsets = MdxaSkelOffsets(ghoul2.mBoneCache!.header!, byteOffset: MdxaHeader.byteCount)
        skel = MdxaSkel(ghoul2.mBoneCache!.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[boneNum])

        //find/add the bone in the list
        // Raven tests `!skel->name` and `!skel->name[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if skel.name.isEmpty {
            bListIndex = -1
        } else {
            bListIndex = G2_Find_Bone(ghoul2.animModel!, &ghoul2.mBlist, skel.name)
            if bListIndex == -1 {
                bListIndex = G2_Add_Bone(ghoul2.animModel!, &ghoul2.mBlist, skel.name)
            }
        }

        assert(bListIndex != -1)

        // Port-note: The recursive call can reach the push_back of G2_Add_Bone, and a reallocation leaves Raven's `bone` reference dangling, which C++ leaves undefined.
        // The bone is a class object here, so the two writes below reach the live bone of the list.
        let bone = ghoul2.mBlist[bListIndex]

        if bone.hasAnimFrameMatrix == frame { //already calculated so just grab it
            matrix.copy(from: bone.animFrameMatrix)
            return
        }

        //get the base matrix for the specified frame
        UnCompressBone(animMatrix, boneNum, ghoul2.mBoneCache!.header!, frame)

        parent = skel.parent
        if boneNum > 0 && parent > -1 {
            //recursively call to assure all parent matrices are set up
            G2_RagGetAnimMatrix(ghoul2, parent, matrix, frame)

            //assign the new skel ptr for our parent
            pskel = MdxaSkel(ghoul2.mBoneCache!.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[parent])

            //taking bone matrix for the skeleton frame and parent's animFrameMatrix into account, determine our final animFrameMatrix
            // Raven tests `!pskel->name` and `!pskel->name[0]`.
            // Both read as the same Swift test, so the draft writes it once.
            if pskel.name.isEmpty {
                parentBlistIndex = -1
            } else {
                parentBlistIndex = G2_Find_Bone(ghoul2.animModel!, &ghoul2.mBlist, pskel.name)
                if parentBlistIndex == -1 {
                    parentBlistIndex = G2_Add_Bone(ghoul2.animModel!, &ghoul2.mBlist, pskel.name)
                }
            }

            assert(parentBlistIndex != -1)

            let pbone = ghoul2.mBlist[parentBlistIndex]

            assert(pbone.hasAnimFrameMatrix == frame) //this should have been calc'd in the recursive call

            Multiply_3x4Matrix(bone.animFrameMatrix, pbone.animFrameMatrix, animMatrix)
        } else { //root
            Multiply_3x4Matrix(bone.animFrameMatrix, ghoul2.mBoneCache!.rootMatrix, animMatrix)
            //bone.animFrameMatrix = ghoul2.mBoneCache->mFinalBones[boneNum].boneMatrix;
            //Maybe use this for the root, so that the orientation is in sync with the current
            //root matrix? However this would require constant recalculation of this base
            //skeleton which I currently do not want.
        }

        //never need to figure it out again
        bone.hasAnimFrameMatrix = frame

        matrix.copy(from: bone.animFrameMatrix)
    }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1541
public func G2_TransformBone(_ child: Int32, _ BC: CBoneCache) {
    // Raven's static locals `tbone` and `j` are `tbone_G2_TransformBone` and `j_G2_TransformBone`, because other functions of the file have a static `j`.
    let TB = BC.mBones[child]
// 	mdxaFrame_t		*aFrame=0;
//	mdxaFrame_t		*bFrame=0;
//	mdxaFrame_t		*aoldFrame=0;
//	mdxaFrame_t		*boldFrame=0;
    // Raven's `boneList` is a reference to the list of the cache, and the body only reads it.
    var boneList = BC.rootBoneList
    var angleOverride: Int32 = 0

    // should this bone be overridden by a bone in the bone list?
    boneListIndex = G2_Find_Bone_In_List(&boneList, child)
    if boneListIndex != -1 {
        // we found a bone in the list - we need to override something here.

        // do we override the rotational angles?
        if ((boneList[boneListIndex].flags) & (BONE_ANGLES_TOTAL)) != 0 {
            angleOverride = (boneList[boneListIndex].flags) & (BONE_ANGLES_TOTAL)
        }

        // set blending stuff if we need to
        if (boneList[boneListIndex].flags & BONE_ANIM_BLEND) != 0 {
            let blendTime = Float(BC.incomingTime - boneList[boneListIndex].blendStart)
            // only set up the blend anim if we actually have some blend time left on this bone anim - otherwise we might corrupt some blend higher up the hiearchy
            if blendTime >= 0.0 && blendTime < boneList[boneListIndex].blendTime {
                TB.blendFrame = boneList[boneListIndex].blendFrame
                TB.blendOldFrame = boneList[boneListIndex].blendLerpFrame
                TB.blendLerp = (blendTime / boneList[boneListIndex].blendTime)
                TB.blendMode = true
            } else {
                TB.blendMode = false
            }
        } else if /*r_Ghoul2NoBlend->integer||*/((boneList[boneListIndex].flags) & (BONE_ANIM_OVERRIDE_LOOP | BONE_ANIM_OVERRIDE)) != 0 {
            // turn off blending if we are just doing a straing animation override
            TB.blendMode = false
        }

        // should this animation be overridden by an animation in the bone list?
        if ((boneList[boneListIndex].flags) & (BONE_ANIM_OVERRIDE_LOOP | BONE_ANIM_OVERRIDE)) != 0 {
            G2_TimingModel(boneList[boneListIndex], BC.incomingTime, BC.header!.numFrames, &TB.currentFrame, &TB.newFrame, &TB.backlerp)
        }
        /*
        if ((r_Ghoul2NoLerp->integer)||((boneList[boneListIndex].flags) & (BONE_ANIM_NO_LERP)))
        {
            TB.backlerp = 0.0f;
        }
        */
        //rwwFIXMEFIXME: Use?
    }
    // figure out where the location of the bone animation data is
    assert(TB.newFrame >= 0 && TB.newFrame < BC.header!.numFrames)
    if !(TB.newFrame >= 0 && TB.newFrame < BC.header!.numFrames) {
        TB.newFrame = 0
    }
//	aFrame = (mdxaFrame_t *)((byte *)BC.header + BC.header->ofsFrames + TB.newFrame * BC.frameSize );
    assert(TB.currentFrame >= 0 && TB.currentFrame < BC.header!.numFrames)
    if !(TB.currentFrame >= 0 && TB.currentFrame < BC.header!.numFrames) {
        TB.currentFrame = 0
    }
//	aoldFrame = (mdxaFrame_t *)((byte *)BC.header + BC.header->ofsFrames + TB.currentFrame * BC.frameSize );

    // figure out where the location of the blended animation data is
    assert(!(TB.blendFrame < 0.0 || TB.blendFrame >= (BC.header!.numFrames + 1)))
    if TB.blendFrame < 0.0 || TB.blendFrame >= (BC.header!.numFrames + 1) {
        TB.blendFrame = 0.0
    }
//	bFrame = (mdxaFrame_t *)((byte *)BC.header + BC.header->ofsFrames + (int)TB.blendFrame * BC.frameSize );
    assert(TB.blendOldFrame >= 0 && TB.blendOldFrame < BC.header!.numFrames)
    if !(TB.blendOldFrame >= 0 && TB.blendOldFrame < BC.header!.numFrames) {
        TB.blendOldFrame = 0
    }
//	boldFrame = (mdxaFrame_t *)((byte *)BC.header + BC.header->ofsFrames + TB.blendOldFrame * BC.frameSize );

//	mdxaCompBone_t	*compBonePointer = (mdxaCompBone_t *)((byte *)BC.header + BC.header->ofsCompBonePool);

    assert(child >= 0 && child < BC.header!.numBones)
//	assert(bFrame->boneIndexes[child]>=0);
//	assert(boldFrame->boneIndexes[child]>=0);
//	assert(aFrame->boneIndexes[child]>=0);
//	assert(aoldFrame->boneIndexes[child]>=0);

    // decide where the transformed bone is going

    // AI: Raven casts each record to a float pointer and indexes its 12 floats.
    // Each loop reads and writes the float at byte offset `j * 4` of the record bytes, the form of the record casts of msg.cpp.

    // are we blending with another frame of anim?
    if TB.blendMode {
        let backlerp: Float = TB.blendFrame - Int32(TB.blendFrame)
        let frontlerp: Float = 1.0 - backlerp

// 		MC_UnCompress(tbone[3].matrix,compBonePointer[bFrame->boneIndexes[child]].Comp);
// 		MC_UnCompress(tbone[4].matrix,compBonePointer[boldFrame->boneIndexes[child]].Comp);
        UnCompressBone(tbone_G2_TransformBone[3], child, BC.header!, Int32(TB.blendFrame))
        UnCompressBone(tbone_G2_TransformBone[4], child, BC.header!, TB.blendOldFrame)

        j_G2_TransformBone = 0
        while j_G2_TransformBone < 12 {
            Slots(record: tbone_G2_TransformBone[5]).bytes[float: j_G2_TransformBone * 4] =
                (backlerp * Slots(record: tbone_G2_TransformBone[3]).bytes[float: j_G2_TransformBone * 4])
                + (frontlerp * Slots(record: tbone_G2_TransformBone[4]).bytes[float: j_G2_TransformBone * 4])
            j_G2_TransformBone += 1
        }
    }

    //
    // lerp this bone - use the temp space on the ref entity to put the bone transforms into
    //
    if TB.backlerp == 0 {
// 		MC_UnCompress(tbone[2].matrix,compBonePointer[aoldFrame->boneIndexes[child]].Comp);
        UnCompressBone(tbone_G2_TransformBone[2], child, BC.header!, TB.currentFrame)

        // blend in the other frame if we need to
        if TB.blendMode {
            let blendFrontlerp: Float = 1.0 - TB.blendLerp
            j_G2_TransformBone = 0
            while j_G2_TransformBone < 12 {
                Slots(record: tbone_G2_TransformBone[2]).bytes[float: j_G2_TransformBone * 4] =
                    (TB.blendLerp * Slots(record: tbone_G2_TransformBone[2]).bytes[float: j_G2_TransformBone * 4])
                    + (blendFrontlerp * Slots(record: tbone_G2_TransformBone[5]).bytes[float: j_G2_TransformBone * 4])
                j_G2_TransformBone += 1
            }
        }

        if child == 0 {
            // now multiply by the root matrix, so we can offset this model should we need to
            Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, BC.rootMatrix, tbone_G2_TransformBone[2])
        }
    } else {
        let frontlerp: Float = 1.0 - TB.backlerp
// 		MC_UnCompress(tbone[0].matrix,compBonePointer[aFrame->boneIndexes[child]].Comp);
//		MC_UnCompress(tbone[1].matrix,compBonePointer[aoldFrame->boneIndexes[child]].Comp);
        UnCompressBone(tbone_G2_TransformBone[0], child, BC.header!, TB.newFrame)
        UnCompressBone(tbone_G2_TransformBone[1], child, BC.header!, TB.currentFrame)

        j_G2_TransformBone = 0
        while j_G2_TransformBone < 12 {
            Slots(record: tbone_G2_TransformBone[2]).bytes[float: j_G2_TransformBone * 4] =
                (TB.backlerp * Slots(record: tbone_G2_TransformBone[0]).bytes[float: j_G2_TransformBone * 4])
                + (frontlerp * Slots(record: tbone_G2_TransformBone[1]).bytes[float: j_G2_TransformBone * 4])
            j_G2_TransformBone += 1
        }

        // blend in the other frame if we need to
        if TB.blendMode {
            let blendFrontlerp: Float = 1.0 - TB.blendLerp
            j_G2_TransformBone = 0
            while j_G2_TransformBone < 12 {
                Slots(record: tbone_G2_TransformBone[2]).bytes[float: j_G2_TransformBone * 4] =
                    (TB.blendLerp * Slots(record: tbone_G2_TransformBone[2]).bytes[float: j_G2_TransformBone * 4])
                    + (blendFrontlerp * Slots(record: tbone_G2_TransformBone[5]).bytes[float: j_G2_TransformBone * 4])
                j_G2_TransformBone += 1
            }
        }

        if child == 0 {
            // now multiply by the root matrix, so we can offset this model should we need to
            Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, BC.rootMatrix, tbone_G2_TransformBone[2])
        }
    }
    // figure out where the bone hirearchy info is
    offsets = MdxaSkelOffsets(BC.header!, byteOffset: MdxaHeader.byteCount)
    skel = MdxaSkel(BC.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets!.offsets[child])
//	skel = BC.mSkels[child];
    //rww - removed mSkels

    let parent: Int32 = BC.mFinalBones[child].parent
    assert((parent == -1 && child == 0) || (parent >= 0 && parent < BC.mBones.count))
    if (angleOverride & BONE_ANGLES_REPLACE) != 0 {
        var isRag: Bool = (angleOverride & BONE_ANGLES_RAGDOLL) != 0
        if !isRag { //do the same for ik.. I suppose.
            isRag = (angleOverride & BONE_ANGLES_IK) != 0
        }

        let bone = BC.mFinalBones[child].boneMatrix
        let boneOverride = boneList[boneListIndex]

        if isRag {
            MdxaBone.scratch { temp in
                MdxaBone.scratch { firstPass in
                    // give us the matrix the animation thinks we should have, so we can get the correct X&Y coors
                    Multiply_3x4Matrix(firstPass, BC.mFinalBones[parent].boneMatrix, tbone_G2_TransformBone[2])
                    // this is crazy, we are gonna drive the animation to ID while we are doing post mults to compensate.
                    Multiply_3x4Matrix(temp, firstPass, skel!.BasePoseMat)
                    // AI: Raven casts the record to a float pointer for VectorLength. The call reads the vector accessor of the first row.
                    let matrixScale: Float = VectorLength(temp.matrix[0].vector)
                    // AI: Raven declares `toMatrix` static with the identity initializer.
                    // Every call writes the six floats that change before the read, so the record is a scratch local with the identity values.
                    MdxaBone.scratch { toMatrix in
                        toMatrix.copy(from: identityMatrix)
                        toMatrix.matrix[0][0] = matrixScale
                        toMatrix.matrix[1][1] = matrixScale
                        toMatrix.matrix[2][2] = matrixScale
                        toMatrix.matrix[0][3] = temp.matrix[0][3]
                        toMatrix.matrix[1][3] = temp.matrix[1][3]
                        toMatrix.matrix[2][3] = temp.matrix[2][3]

                        Multiply_3x4Matrix(temp, toMatrix, skel!.BasePoseMatInv) //dest first arg
                    }

                    let blendTime = Float(BC.incomingTime - boneList[boneListIndex].boneBlendStart)
                    let blendLerp: Float = (blendTime / boneList[boneListIndex].boneBlendTime)
                    if blendLerp > 0.0 {
                        // has started
                        if blendLerp > 1.0 {
                            // done
//							Multiply_3x4Matrix(&bone, &BC.mFinalBones[parent].boneMatrix,&temp);
                            bone.copy(from: temp)
                        } else {
//							mdxaBone_t lerp;
                            // now do the blend into the destination
                            let blendFrontlerp: Float = 1.0 - blendLerp
                            j_G2_TransformBone = 0
                            while j_G2_TransformBone < 12 {
                                Slots(record: bone).bytes[float: j_G2_TransformBone * 4] =
                                    (blendLerp * Slots(record: temp).bytes[float: j_G2_TransformBone * 4])
                                    + (blendFrontlerp * Slots(record: tbone_G2_TransformBone[2]).bytes[float: j_G2_TransformBone * 4])
                                j_G2_TransformBone += 1
                            }
//							Multiply_3x4Matrix(&bone, &BC.mFinalBones[parent].boneMatrix,&lerp);
                        }
                    }
                }
            }
        } else {
            MdxaBone.scratch { temp in
                MdxaBone.scratch { firstPass in
                    // give us the matrix the animation thinks we should have, so we can get the correct X&Y coors
                    Multiply_3x4Matrix(firstPass, BC.mFinalBones[parent].boneMatrix, tbone_G2_TransformBone[2])

                    // are we attempting to blend with the base animation? and still within blend time?
                    if boneOverride.boneBlendTime != 0 && (((boneOverride.boneBlendTime + boneOverride.boneBlendStart) < BC.incomingTime)) {
                        // ok, we are supposed to be blending. Work out lerp
                        let blendTime = Float(BC.incomingTime - boneList[boneListIndex].boneBlendStart)
                        let blendLerp: Float = (blendTime / boneList[boneListIndex].boneBlendTime)

                        if blendLerp <= 1 {
                            if blendLerp < 0 {
                                assert(false)
                            }

                            // now work out the matrix we want to get *to* - firstPass is where we are coming *from*
                            Multiply_3x4Matrix(temp, firstPass, skel!.BasePoseMat)

                            // AI: Raven casts the record to a float pointer for VectorLength. The call reads the vector accessor of the first row.
                            let matrixScale: Float = VectorLength(temp.matrix[0].vector)

                            MdxaBone.scratch { newMatrixTemp in
                                if HackadelicOnClient {
                                    var i: Int32 = 0
                                    while i < 3 {
                                        var x: Int32 = 0
                                        while x < 3 {
                                            newMatrixTemp.matrix[i][x] = boneOverride.newMatrix.matrix[i][x] * matrixScale
                                            x += 1
                                        }
                                        i += 1
                                    }

                                    newMatrixTemp.matrix[0][3] = temp.matrix[0][3]
                                    newMatrixTemp.matrix[1][3] = temp.matrix[1][3]
                                    newMatrixTemp.matrix[2][3] = temp.matrix[2][3]
                                } else {
                                    var i: Int32 = 0
                                    while i < 3 {
                                        var x: Int32 = 0
                                        while x < 3 {
                                            newMatrixTemp.matrix[i][x] = boneOverride.matrix.matrix[i][x] * matrixScale
                                            x += 1
                                        }
                                        i += 1
                                    }

                                    newMatrixTemp.matrix[0][3] = temp.matrix[0][3]
                                    newMatrixTemp.matrix[1][3] = temp.matrix[1][3]
                                    newMatrixTemp.matrix[2][3] = temp.matrix[2][3]
                                }

                                Multiply_3x4Matrix(temp, newMatrixTemp, skel!.BasePoseMatInv)
                            }

                            // now do the blend into the destination
                            let blendFrontlerp: Float = 1.0 - blendLerp
                            j_G2_TransformBone = 0
                            while j_G2_TransformBone < 12 {
                                Slots(record: bone).bytes[float: j_G2_TransformBone * 4] =
                                    (blendLerp * Slots(record: temp).bytes[float: j_G2_TransformBone * 4])
                                    + (blendFrontlerp * Slots(record: firstPass).bytes[float: j_G2_TransformBone * 4])
                                j_G2_TransformBone += 1
                            }
                        } else {
                            bone.copy(from: firstPass)
                        }
                    }
                    // no, so just override it directly
                    else {
                        Multiply_3x4Matrix(temp, firstPass, skel!.BasePoseMat)
                        // AI: Raven casts the record to a float pointer for VectorLength. The call reads the vector accessor of the first row.
                        let matrixScale: Float = VectorLength(temp.matrix[0].vector)

                        MdxaBone.scratch { newMatrixTemp in
                            if HackadelicOnClient {
                                var i: Int32 = 0
                                while i < 3 {
                                    var x: Int32 = 0
                                    while x < 3 {
                                        newMatrixTemp.matrix[i][x] = boneOverride.newMatrix.matrix[i][x] * matrixScale
                                        x += 1
                                    }
                                    i += 1
                                }

                                newMatrixTemp.matrix[0][3] = temp.matrix[0][3]
                                newMatrixTemp.matrix[1][3] = temp.matrix[1][3]
                                newMatrixTemp.matrix[2][3] = temp.matrix[2][3]
                            } else {
                                var i: Int32 = 0
                                while i < 3 {
                                    var x: Int32 = 0
                                    while x < 3 {
                                        newMatrixTemp.matrix[i][x] = boneOverride.matrix.matrix[i][x] * matrixScale
                                        x += 1
                                    }
                                    i += 1
                                }

                                newMatrixTemp.matrix[0][3] = temp.matrix[0][3]
                                newMatrixTemp.matrix[1][3] = temp.matrix[1][3]
                                newMatrixTemp.matrix[2][3] = temp.matrix[2][3]
                            }

                            Multiply_3x4Matrix(bone, newMatrixTemp, skel!.BasePoseMatInv)
                        }
                    }
                }
            }
        }
    } else if (angleOverride & BONE_ANGLES_PREMULT) != 0 {
        if (angleOverride & BONE_ANGLES_RAGDOLL) != 0 || (angleOverride & BONE_ANGLES_IK) != 0 {
            MdxaBone.scratch { tmp in
                if child == 0 {
                    if HackadelicOnClient {
                        Multiply_3x4Matrix(tmp, BC.rootMatrix, boneList[boneListIndex].newMatrix)
                    } else {
                        Multiply_3x4Matrix(tmp, BC.rootMatrix, boneList[boneListIndex].matrix)
                    }
                } else {
                    if HackadelicOnClient {
                        Multiply_3x4Matrix(tmp, BC.mFinalBones[parent].boneMatrix, boneList[boneListIndex].newMatrix)
                    } else {
                        Multiply_3x4Matrix(tmp, BC.mFinalBones[parent].boneMatrix, boneList[boneListIndex].matrix)
                    }
                }
                Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, tmp, tbone_G2_TransformBone[2])
            }
        } else {
            if child == 0 {
                // use the in coming root matrix as our basis
                if HackadelicOnClient {
                    Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, BC.rootMatrix, boneList[boneListIndex].newMatrix)
                } else {
                    Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, BC.rootMatrix, boneList[boneListIndex].matrix)
                }
            } else {
                // convert from 3x4 matrix to a 4x4 matrix
                if HackadelicOnClient {
                    Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, BC.mFinalBones[parent].boneMatrix, boneList[boneListIndex].newMatrix)
                } else {
                    Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, BC.mFinalBones[parent].boneMatrix, boneList[boneListIndex].matrix)
                }
            }
        }
    } else if child != 0 {
        // now transform the matrix by it's parent, asumming we have a parent, and we aren't overriding the angles absolutely
        Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, BC.mFinalBones[parent].boneMatrix, tbone_G2_TransformBone[2])
    }

    // now multiply our resulting bone by an override matrix should we need to
    if (angleOverride & BONE_ANGLES_POSTMULT) != 0 {
        MdxaBone.scratch { tempMatrix in
            tempMatrix.copy(from: BC.mFinalBones[child].boneMatrix)
            if HackadelicOnClient {
                Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, tempMatrix, boneList[boneListIndex].newMatrix)
            } else {
                Multiply_3x4Matrix(BC.mFinalBones[child].boneMatrix, tempMatrix, boneList[boneListIndex].matrix)
            }
        }
    }
    /*
    if (r_Ghoul2UnSqash->integer)
    {
        mdxaBone_t tempMatrix;
        Multiply_3x4Matrix(&tempMatrix,&BC.mFinalBones[child].boneMatrix, &skel->BasePoseMat);
        float maxl;
        maxl=VectorLength(&skel->BasePoseMat.matrix[0][0]);
        VectorNormalize(&tempMatrix.matrix[0][0]);
        VectorNormalize(&tempMatrix.matrix[1][0]);
        VectorNormalize(&tempMatrix.matrix[2][0]);

        VectorScale(&tempMatrix.matrix[0][0],maxl,&tempMatrix.matrix[0][0]);
        VectorScale(&tempMatrix.matrix[1][0],maxl,&tempMatrix.matrix[1][0]);
        VectorScale(&tempMatrix.matrix[2][0],maxl,&tempMatrix.matrix[2][0]);
        Multiply_3x4Matrix(&BC.mFinalBones[child].boneMatrix,&tempMatrix,&skel->BasePoseMatInv);
    }
    */
    //rwwFIXMEFIXME: Care?
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2053
public func G2_SetUpBolts(_ header: MdxaHeader, _ ghoul2: CGhoul2Info, _ bonePtr: inout [(Int32, MdxaBone)], _ boltList: inout [boltInfo_t]) {
    // Raven calls this function from no file of either tree, so it is dead.
    var skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    offsets = MdxaSkelOffsets(header, byteOffset: MdxaHeader.byteCount)

    var i: Int32 = 0
    while i < boltList.count {
        if boltList[i].boneNumber != -1 {
            // figure out where the bone hirearchy info is
            skel = MdxaSkel(header, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[boltList[i].boneNumber])
            Multiply_3x4Matrix(boltList[i].position, bonePtr[boltList[i].boneNumber].1, skel.BasePoseMat)
        }
        i += 1
    }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2075
public func G2_TransformGhoulBones(_ rootBoneList: inout [boneInfo_t], _ rootMatrix: JKAMP.MdxaBone, _ ghoul2: CGhoul2Info, _ time: Int32, _ smooth: Bool = true) {
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
public func G2_ProcessSurfaceBolt(_ bonePtr: inout [(Int32, MdxaBone)], _ surface: MdxmSurface?, _ boltNum: Int32, _ boltList: inout [boltInfo_t], _ surfInfo: surfaceInfo_t?, _ mod: Model) {
    // Raven's two callers are G2_ProcessGeneratedSurfaceBolts and ProcessModelBoltSurfaces, which are both dead, so the function is dead too.
    var v: MdxmVertex
    var vert0: MdxmVertex
    var vert1: MdxmVertex
    var vert2: MdxmVertex
    var axes = [vec3_t](repeating: vec3_t(), count: 3)
    var sides = [vec3_t](repeating: vec3_t(), count: 3)
    var pTri = [vec3_t](repeating: vec3_t(), count: 3)
    var d: Float
    var j: Int32
    var k: Int32

    // AI: Raven hands each row of four floats of a bone to DotProduct. Each call below reads the vector accessor of the row.

    // now there are two types of tag surface - model ones and procedural generated types - lets decide which one we have here.
    if surfInfo != nil && surfInfo!.offFlags == G2SURFACEFLAG_GENERATED {
        let surfNumber: Int32 = surfInfo!.genPolySurfaceIndex & 0x0ffff
        let polyNumber: Int32 = (surfInfo!.genPolySurfaceIndex >> 16) & 0x0ffff

        // find original surface our original poly was in.
        let originalSurf = G2_FindSurface(mod, surfNumber, surfInfo!.genLod)!
        // AI: Raven casts the surface address plus `ofsTriangles` to a triangle pointer and indexes it with `polyNumber`.
        // The view is the triangle at that offset plus `polyNumber` times the record size.
        let originalTriangleIndexes = MdxmTriangle(originalSurf, byteOffset: originalSurf.ofsTriangles + polyNumber * Int32(MdxmTriangle.byteCount))

        // get the original polys indexes
        let index0: Int32 = originalTriangleIndexes.indexes[0]
        let index1: Int32 = originalTriangleIndexes.indexes[1]
        let index2: Int32 = originalTriangleIndexes.indexes[2]

        // decide where the original verts are
        // AI: Raven adds a vertex index to a vertex pointer. The view steps by that index times the record size.
        vert0 = MdxmVertex(originalSurf, byteOffset: originalSurf.ofsVerts)
        vert0 = MdxmVertex(vert0, byteOffset: index0 * Int32(MdxmVertex.byteCount))

        vert1 = MdxmVertex(originalSurf, byteOffset: originalSurf.ofsVerts)
        vert1 = MdxmVertex(vert1, byteOffset: index1 * Int32(MdxmVertex.byteCount))

        vert2 = MdxmVertex(originalSurf, byteOffset: originalSurf.ofsVerts)
        vert2 = MdxmVertex(vert2, byteOffset: index2 * Int32(MdxmVertex.byteCount))

        // clear out the triangle verts to be
        pTri[0] = vec3_t()
        pTri[1] = vec3_t()
        pTri[2] = vec3_t()

//		mdxmWeight_t	*w;

        let piBoneRefs = originalSurf.boneReferences

        // now go and transform just the points we need from the surface that was hit originally
//		w = vert0->weights;
        var fTotalWeight: Float = 0.0
        var iNumWeights: Int32 = G2_GetVertWeights(vert0)
        k = 0
        while k < iNumWeights {
            let iBoneIndex: Int32 = G2_GetVertBoneIndex(vert0, k)
            let fBoneWeight: Float = G2_GetVertBoneWeight(vert0, k, &fTotalWeight, iNumWeights)

            pTri[0][0] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[0].vector, vert0.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[0][3])
            pTri[0][1] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[1].vector, vert0.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[1][3])
            pTri[0][2] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[2].vector, vert0.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[2][3])
            k += 1
        }
//		w = vert1->weights;
        fTotalWeight = 0.0
        iNumWeights = G2_GetVertWeights(vert1)
        k = 0
        while k < iNumWeights {
            let iBoneIndex: Int32 = G2_GetVertBoneIndex(vert1, k)
            let fBoneWeight: Float = G2_GetVertBoneWeight(vert1, k, &fTotalWeight, iNumWeights)

            pTri[1][0] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[0].vector, vert1.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[0][3])
            pTri[1][1] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[1].vector, vert1.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[1][3])
            pTri[1][2] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[2].vector, vert1.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[2][3])
            k += 1
        }
//		w = vert2->weights;
        fTotalWeight = 0.0
        iNumWeights = G2_GetVertWeights(vert2)
        k = 0
        while k < iNumWeights {
            let iBoneIndex: Int32 = G2_GetVertBoneIndex(vert2, k)
            let fBoneWeight: Float = G2_GetVertBoneWeight(vert2, k, &fTotalWeight, iNumWeights)

            pTri[2][0] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[0].vector, vert2.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[0][3])
            pTri[2][1] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[1].vector, vert2.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[1][3])
            pTri[2][2] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[2].vector, vert2.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[2][3])
            k += 1
        }

        var normal = vec3_t()
        var up = vec3_t()
        var right = vec3_t()
        var vec0 = vec3_t()
        var vec1 = vec3_t()
        // work out baryCentricK
        let baryCentricK = Float(1.0 - Double(surfInfo!.genBarycentricI + surfInfo!.genBarycentricJ))

        // now we have the model transformed into model space, now generate an origin.
        boltList[boltNum].position.matrix[0][3] = (pTri[0][0] * surfInfo!.genBarycentricI) + (pTri[1][0] * surfInfo!.genBarycentricJ) + (pTri[2][0] * baryCentricK)
        boltList[boltNum].position.matrix[1][3] = (pTri[0][1] * surfInfo!.genBarycentricI) + (pTri[1][1] * surfInfo!.genBarycentricJ) + (pTri[2][1] * baryCentricK)
        boltList[boltNum].position.matrix[2][3] = (pTri[0][2] * surfInfo!.genBarycentricI) + (pTri[1][2] * surfInfo!.genBarycentricJ) + (pTri[2][2] * baryCentricK)

        // generate a normal to this new triangle
        _VectorSubtract(pTri[0], pTri[1], &vec0)
        _VectorSubtract(pTri[2], pTri[1], &vec1)

        CrossProduct(vec0, vec1, &normal)
        _ = VectorNormalize(&normal)

        // forward vector
        boltList[boltNum].position.matrix[0][0] = normal[0]
        boltList[boltNum].position.matrix[1][0] = normal[1]
        boltList[boltNum].position.matrix[2][0] = normal[2]

        // up will be towards point 0 of the original triangle.
        // so lets work it out. Vector is hit point - point 0
        up[0] = boltList[boltNum].position.matrix[0][3] - pTri[0][0]
        up[1] = boltList[boltNum].position.matrix[1][3] - pTri[0][1]
        up[2] = boltList[boltNum].position.matrix[2][3] - pTri[0][2]

        // normalise it
        _ = VectorNormalize(&up)

        // that's the up vector
        boltList[boltNum].position.matrix[0][1] = up[0]
        boltList[boltNum].position.matrix[1][1] = up[1]
        boltList[boltNum].position.matrix[2][1] = up[2]

        // right is always straight

        CrossProduct(normal, up, &right)
        // that's the up vector
        boltList[boltNum].position.matrix[0][2] = right[0]
        boltList[boltNum].position.matrix[1][2] = right[1]
        boltList[boltNum].position.matrix[2][2] = right[2]
    }
    // no, we are looking at a normal model tag
    else {
        let piBoneRefs = surface!.boneReferences

        // whip through and actually transform each vertex
        v = MdxmVertex(surface!, byteOffset: surface!.ofsVerts)
        j = 0
        while j < 3 {
// 			mdxmWeight_t	*w;

            pTri[j] = vec3_t()
 //			w = v->weights;

            let iNumWeights: Int32 = G2_GetVertWeights(v)
            var fTotalWeight: Float = 0.0
            k = 0
            while k < iNumWeights {
                let iBoneIndex: Int32 = G2_GetVertBoneIndex(v, k)
                let fBoneWeight: Float = G2_GetVertBoneWeight(v, k, &fTotalWeight, iNumWeights)

                //bone = bonePtr + piBoneRefs[w->boneIndex];
                pTri[j][0] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[0].vector, v.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[0][3])
                pTri[j][1] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[1].vector, v.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[1][3])
                pTri[j][2] += fBoneWeight * (_DotProduct(bonePtr[piBoneRefs[iBoneIndex]].1.matrix[2].vector, v.vertCoords) + bonePtr[piBoneRefs[iBoneIndex]].1.matrix[2][3])
                k += 1
            }

            // AI: Raven steps the vertex pointer by one record. The view steps by the record size.
            v = MdxmVertex(v, byteOffset: MdxmVertex.byteCount)// = (mdxmVertex_t *)&v->weights[/*v->numWeights*/surface->maxVertBoneWeights];
            j += 1
        }

        // clear out used arrays
        axes.fill(vec3_t())
        sides.fill(vec3_t())

        // work out actual sides of the tag triangle
        j = 0
        while j < 3 {
            sides[j][0] = pTri[(j + 1) % 3][0] - pTri[j][0]
            sides[j][1] = pTri[(j + 1) % 3][1] - pTri[j][1]
            sides[j][2] = pTri[(j + 1) % 3][2] - pTri[j][2]
            j += 1
        }

        // do math trig to work out what the matrix will be from this triangle's translated position
        _ = VectorNormalize2(sides[iG2_TRISIDE_LONGEST], &axes[0])
        _ = VectorNormalize2(sides[iG2_TRISIDE_SHORTEST], &axes[1])

        // project shortest side so that it is exactly 90 degrees to the longer side
        d = _DotProduct(axes[0], axes[1])
        _VectorMA(axes[0], -d, axes[1], &axes[0])
        _ = VectorNormalize2(axes[0], &axes[0])

        CrossProduct(sides[iG2_TRISIDE_LONGEST], sides[iG2_TRISIDE_SHORTEST], &axes[2])
        _ = VectorNormalize2(axes[2], &axes[2])

        // set up location in world space of the origin point in out going matrix
        boltList[boltNum].position.matrix[0][3] = pTri[MDX_TAG_ORIGIN][0]
        boltList[boltNum].position.matrix[1][3] = pTri[MDX_TAG_ORIGIN][1]
        boltList[boltNum].position.matrix[2][3] = pTri[MDX_TAG_ORIGIN][2]

        // copy axis to matrix - do some magic to orient minus Y to positive X and so on so bolt on stuff is oriented correctly
        boltList[boltNum].position.matrix[0][0] = axes[1][0]
        boltList[boltNum].position.matrix[0][1] = axes[0][0]
        boltList[boltNum].position.matrix[0][2] = -axes[2][0]

        boltList[boltNum].position.matrix[1][0] = axes[1][1]
        boltList[boltNum].position.matrix[1][1] = axes[0][1]
        boltList[boltNum].position.matrix[1][2] = -axes[2][1]

        boltList[boltNum].position.matrix[2][0] = axes[1][2]
        boltList[boltNum].position.matrix[2][1] = axes[0][2]
        boltList[boltNum].position.matrix[2][2] = -axes[2][2]
    }
}

// now go through all the generated surfaces that aren't included in the model surface hierarchy and create the correct bolt info for them
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2495
public func G2_ProcessGeneratedSurfaceBolts(_ ghoul2: CGhoul2Info, _ bonePtr: inout [(Int32, MdxaBone)], _ mod_t: Model) {
    // Raven calls this function from no file of either tree, so it is dead.
    G2PerformanceTimer_G2_ProcessGeneratedSurfaceBolts.Start()
    // look through the surfaces off the end of the pre-defined model surfaces
    var i: Int32 = 0
    while i < ghoul2.mSlist.count {
        // only look for bolts if we are actually a generated surface, and not just an overriden one
        if (ghoul2.mSlist[i].offFlags & G2SURFACEFLAG_GENERATED) != 0 {
            // well alrighty then. Lets see if there is a bolt that is attempting to use it
            let boltNum: Int32 = G2_Find_Bolt_Surface_Num(&ghoul2.mBltlist, i, G2SURFACEFLAG_GENERATED)
            // yes - ok, processing time.
            if boltNum != -1 {
                G2_ProcessSurfaceBolt(&bonePtr, nil, boltNum, &ghoul2.mBltlist, ghoul2.mSlist[i], mod_t)
            }
        }
        i += 1
    }
    G2Time_G2_ProcessGeneratedSurfaceBolts += G2PerformanceTimer_G2_ProcessGeneratedSurfaceBolts.End()
}

// Go through the model and deal with just the surfaces that are tagged as bolt on points - this is for the server side skeleton construction
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2739
public func ProcessModelBoltSurfaces(_ surfaceNum: Int32, _ rootSList: inout [surfaceInfo_t], _ bonePtr: inout [(Int32, MdxaBone)], _ currentModel: Model, _ lod: Int32, _ boltList: inout [boltInfo_t]) {
    // Raven's one call is its own recursion at tr_ghoul2.cpp:2786, and no other function calls it, so it is dead.
    G2PerformanceTimer_ProcessModelBoltSurfaces.Start()
    var i: Int32
    var offFlags: Int32 = 0

    // back track and get the surfinfo struct for this surface
    let surface = G2_FindSurface(currentModel, surfaceNum, 0)!
    let surfIndexes = MdxmHierarchyOffsets(currentModel.mdxm!, byteOffset: MdxmHeader.byteCount)
    let surfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surface.thisSurfaceIndex])

    // see if we have an override surface in the surface list
    let surfOverride = G2_FindOverrideSurface(surfaceNum, &rootSList)

    // really, we should use the default flags for this surface unless it's been overriden
    offFlags = Int32(truncatingIfNeeded: surfInfo.flags)

    // set the off flags if we have some
    if surfOverride != nil {
        offFlags = surfOverride!.offFlags
    }

    // is this surface considered a bolt surface?
    if (Int32(truncatingIfNeeded: surfInfo.flags) & G2SURFACEFLAG_ISBOLT) != 0 {
        // well alrighty then. Lets see if there is a bolt that is attempting to use it
        let boltNum: Int32 = G2_Find_Bolt_Surface_Num(&boltList, surfaceNum, 0)
        // yes - ok, processing time.
        if boltNum != -1 {
            G2_ProcessSurfaceBolt(&bonePtr, surface, boltNum, &boltList, surfOverride, currentModel)
        }
    }

    // if we are turning off all descendants, then stop this recursion now
    if (offFlags & G2SURFACEFLAG_NODESCENDANTS) != 0 {
        return
    }

    // now recursively call for the children
    i = 0
    while i < surfInfo.numChildren {
        ProcessModelBoltSurfaces(surfInfo.childIndexes[i], &rootSList, &bonePtr, currentModel, lod, &boltList)
        i += 1
    }

    G2Time_ProcessModelBoltSurfaces += G2PerformanceTimer_ProcessModelBoltSurfaces.End()
}

// build the used bone list so when doing bone transforms we can determine if we need to do it or not
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2796
public func G2_ConstructUsedBoneList(_ CBL: CConstructBoneList) {
    var i: Int32
    var j: Int32
    var offFlags: Int32 = 0

    // back track and get the surfinfo struct for this surface
    let surface = G2_FindSurface(CBL.currentModel, CBL.surfaceNum, 0)!
    let surfIndexes = MdxmHierarchyOffsets(CBL.currentModel!.mdxm!, byteOffset: MdxmHeader.byteCount)
    let surfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surface.thisSurfaceIndex])
    let mod_a = R_GetModelByHandle(CBL.currentModel!.mdxm!.animIndex)!
    let offsets = MdxaSkelOffsets(mod_a.mdxa!, byteOffset: MdxaHeader.byteCount)
    var skel: MdxaSkel
    var childSkel: MdxaSkel

    // see if we have an override surface in the surface list
    let surfOverride = G2_FindOverrideSurface(CBL.surfaceNum, &CBL.rootSList)

    // really, we should use the default flags for this surface unless it's been overriden
    offFlags = Int32(truncatingIfNeeded: surfInfo.flags)

    // set the off flags if we have some
    if surfOverride != nil {
        offFlags = surfOverride!.offFlags
    }

    // if this surface is not off, add it to the shader render list
    if (offFlags & G2SURFACEFLAG_OFF) == 0 {
        let bonesReferenced = surface.boneReferences
        // now whip through the bones this surface uses
        i = 0
        while i < surface.numBoneReferences {
            let iBoneIndex = bonesReferenced[i]
            CBL.boneUsedList![iBoneIndex] = 1

            // now go and check all the descendant bones attached to this bone and see if any have the always flag on them. If so, activate them
            skel = MdxaSkel(mod_a.mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[iBoneIndex])

            // for every child bone...
            j = 0
            while j < skel.numChildren {
                // get the skel data struct for each child bone of the referenced bone
                childSkel = MdxaSkel(mod_a.mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[skel.children[j]])

                // does it have the always on flag on?
                if (Int32(truncatingIfNeeded: childSkel.flags) & G2BONEFLAG_ALWAYSXFORM) != 0 {
                    // yes, make sure it's in the list of bones to be transformed.
                    CBL.boneUsedList![skel.children[j]] = 1
                }
                j += 1
            }

            // now we need to ensure that the parents of this bone are actually active...
            //
            var iParentBone = skel.parent
            while iParentBone != -1 {
                if CBL.boneUsedList![iParentBone] != 0 { // no need to go higher
                    break
                }
                CBL.boneUsedList![iParentBone] = 1
                skel = MdxaSkel(mod_a.mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[iParentBone])
                iParentBone = skel.parent
            }
            i += 1
        }
    } else
    // if we are turning off all descendants, then stop this recursion now
    if (offFlags & G2SURFACEFLAG_NODESCENDANTS) != 0 {
        return
    }

    // now recursively call for the children
    i = 0
    while i < surfInfo.numChildren {
        CBL.surfaceNum = surfInfo.childIndexes[i]
        G2_ConstructUsedBoneList(CBL)
        i += 1
    }
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
// AI: Raven returns `void *`, and every caller casts it to `mdxmSurface_t *`. The function returns that view, the form of G2_FindSurface of G2_misc.cpp.
public func G2_FindSurface_BC(_ mod: Model, _ index: Int32, _ lod: Int32) -> MdxmSurface? {
    // point at first lod list
    // Raven's `current` is a byte pointer, and each read casts it to the record at its address.
    var current = MdxmLOD(mod.mdxm!, byteOffset: mod.mdxm!.ofsLODs)
    var i: Int32

    //walk the lods
    i = 0
    while i < lod {
        let lodData = current
        current = MdxmLOD(current, byteOffset: lodData.ofsEnd)
        i += 1
    }

    // avoid the lod pointer data structure
    let indexes = MdxmLODSurfOffset(current, byteOffset: MdxmLOD.byteCount)
    // we are now looking at the offset array
    return MdxmSurface(indexes, byteOffset: indexes.offsets[index])
}

// these are convenience functions that I can invoked in code. Do NOT change them (because this is a shared file),
//	but if you want to copy the logic out and use your own versions then fine...
//
/// Source: oracle/codemp/renderer/mdx_format.h:290
func G2_GetVertWeights(_ pVert: MdxmVertex) -> Int32 {
    let iNumWeights: Int32 = Int32(truncatingIfNeeded: pVert.uiNmWeightsAndBoneIndexes >> 30) + 1	// 1..4 count

    return iNumWeights
}

/// Source: oracle/codemp/renderer/mdx_format.h:297
func G2_GetVertBoneIndex(_ pVert: MdxmVertex, _ iWeightNum: Int32) -> Int32 {
    let iBoneIndex: Int32 = Int32(truncatingIfNeeded: pVert.uiNmWeightsAndBoneIndexes >> (iG2_BITS_PER_BONEREF * iWeightNum)) & ((1 << iG2_BITS_PER_BONEREF) - 1)

    return iBoneIndex
}

/// Source: oracle/codemp/renderer/mdx_format.h:304
func G2_GetVertBoneWeight(_ pVert: MdxmVertex, _ iWeightNum: Int32, _ fTotalWeight: inout Float, _ iNumWeights: Int32) -> Float {
    let fBoneWeight: Float

    if iWeightNum == iNumWeights - 1 {
        fBoneWeight = 1.0 - fTotalWeight
    } else {
        var iTemp = Int32(pVert.BoneWeightings[iWeightNum])
        iTemp |= Int32(truncatingIfNeeded: pVert.uiNmWeightsAndBoneIndexes >> (iG2_BONEWEIGHT_TOPBITS_SHIFT + (iWeightNum * 2))) & iG2_BONEWEIGHT_TOPBITS_AND

        // AI: Raven multiplies by the macro `fG2_BONEWEIGHT_RECIPROCAL_MULT`, `((float)(1.0f/1023.0f))` of mdx_format.h:60.
        // The generated file has no form for that macro, so the site writes its float quotient.
        fBoneWeight = ((1.0 as Float) / 1023.0) * iTemp
        fTotalWeight += fBoneWeight
    }

    return fBoneWeight
}

// We've come across a surface that's designated as a bolt surface, process it and put it in the appropriate bolt place
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2983
// G2_GetBoltMatrixLow passes NULL for a generated surface, so `surface` is optional, the form of a view parameter that a caller passes NULL to.
public func G2_ProcessSurfaceBolt2(_ boneCache: CBoneCache, _ surface: MdxmSurface?, _ boltNum: Int32, _ boltList: inout [boltInfo_t], _ surfInfo: surfaceInfo_t?, _ mod: Model, _ retMatrix: JKAMP.MdxaBone) {
    var v: MdxmVertex
    var vert0: MdxmVertex
    var vert1: MdxmVertex
    var vert2: MdxmVertex
    var axes = [vec3_t](repeating: vec3_t(), count: 3)
    var sides = [vec3_t](repeating: vec3_t(), count: 3)
    var pTri = [vec3_t](repeating: vec3_t(), count: 3)
    var d: Float
    var j: Int32
    var k: Int32

    // AI: Raven hands each row of four floats of a bone to DotProduct. Each call below reads the vector accessor of the row.

    // now there are two types of tag surface - model ones and procedural generated types - lets decide which one we have here.
    if surfInfo != nil && surfInfo!.offFlags == G2SURFACEFLAG_GENERATED {
        let surfNumber: Int32 = surfInfo!.genPolySurfaceIndex & 0x0ffff
        let polyNumber: Int32 = (surfInfo!.genPolySurfaceIndex >> 16) & 0x0ffff

        // find original surface our original poly was in.
        let originalSurf = G2_FindSurface_BC(mod, surfNumber, surfInfo!.genLod)!
        // AI: Raven casts the surface address plus `ofsTriangles` to a triangle pointer and indexes it with `polyNumber`.
        // The view is the triangle at that offset plus `polyNumber` times the record size.
        let originalTriangleIndexes = MdxmTriangle(originalSurf, byteOffset: originalSurf.ofsTriangles + polyNumber * Int32(MdxmTriangle.byteCount))

        // get the original polys indexes
        let index0: Int32 = originalTriangleIndexes.indexes[0]
        let index1: Int32 = originalTriangleIndexes.indexes[1]
        let index2: Int32 = originalTriangleIndexes.indexes[2]

        // decide where the original verts are
        // AI: Raven adds a vertex index to a vertex pointer. The view steps by that index times the record size.
        vert0 = MdxmVertex(originalSurf, byteOffset: originalSurf.ofsVerts)
        vert0 = MdxmVertex(vert0, byteOffset: index0 * Int32(MdxmVertex.byteCount))

        vert1 = MdxmVertex(originalSurf, byteOffset: originalSurf.ofsVerts)
        vert1 = MdxmVertex(vert1, byteOffset: index1 * Int32(MdxmVertex.byteCount))

        vert2 = MdxmVertex(originalSurf, byteOffset: originalSurf.ofsVerts)
        vert2 = MdxmVertex(vert2, byteOffset: index2 * Int32(MdxmVertex.byteCount))

        // clear out the triangle verts to be
        pTri[0] = vec3_t()
        pTri[1] = vec3_t()
        pTri[2] = vec3_t()
        let piBoneReferences = originalSurf.boneReferences

//		mdxmWeight_t	*w;

        // now go and transform just the points we need from the surface that was hit originally
//		w = vert0->weights;
        var fTotalWeight: Float = 0.0
        var iNumWeights: Int32 = G2_GetVertWeights(vert0)
        k = 0
        while k < iNumWeights {
            let iBoneIndex: Int32 = G2_GetVertBoneIndex(vert0, k)
            let fBoneWeight: Float = G2_GetVertBoneWeight(vert0, k, &fTotalWeight, iNumWeights)

            let bone = boneCache.Eval(piBoneReferences[iBoneIndex])

            pTri[0][0] += fBoneWeight * (_DotProduct(bone.matrix[0].vector, vert0.vertCoords) + bone.matrix[0][3])
            pTri[0][1] += fBoneWeight * (_DotProduct(bone.matrix[1].vector, vert0.vertCoords) + bone.matrix[1][3])
            pTri[0][2] += fBoneWeight * (_DotProduct(bone.matrix[2].vector, vert0.vertCoords) + bone.matrix[2][3])
            k += 1
        }

//		w = vert1->weights;
        fTotalWeight = 0.0
        iNumWeights = G2_GetVertWeights(vert1)
        k = 0
        while k < iNumWeights {
            let iBoneIndex: Int32 = G2_GetVertBoneIndex(vert1, k)
            let fBoneWeight: Float = G2_GetVertBoneWeight(vert1, k, &fTotalWeight, iNumWeights)

            let bone = boneCache.Eval(piBoneReferences[iBoneIndex])

            pTri[1][0] += fBoneWeight * (_DotProduct(bone.matrix[0].vector, vert1.vertCoords) + bone.matrix[0][3])
            pTri[1][1] += fBoneWeight * (_DotProduct(bone.matrix[1].vector, vert1.vertCoords) + bone.matrix[1][3])
            pTri[1][2] += fBoneWeight * (_DotProduct(bone.matrix[2].vector, vert1.vertCoords) + bone.matrix[2][3])
            k += 1
        }

//		w = vert2->weights;
        fTotalWeight = 0.0
        iNumWeights = G2_GetVertWeights(vert2)
        k = 0
        while k < iNumWeights {
            let iBoneIndex: Int32 = G2_GetVertBoneIndex(vert2, k)
            let fBoneWeight: Float = G2_GetVertBoneWeight(vert2, k, &fTotalWeight, iNumWeights)

            let bone = boneCache.Eval(piBoneReferences[iBoneIndex])

            pTri[2][0] += fBoneWeight * (_DotProduct(bone.matrix[0].vector, vert2.vertCoords) + bone.matrix[0][3])
            pTri[2][1] += fBoneWeight * (_DotProduct(bone.matrix[1].vector, vert2.vertCoords) + bone.matrix[1][3])
            pTri[2][2] += fBoneWeight * (_DotProduct(bone.matrix[2].vector, vert2.vertCoords) + bone.matrix[2][3])
            k += 1
        }

        var normal = vec3_t()
        var up = vec3_t()
        var right = vec3_t()
        var vec0 = vec3_t()
        var vec1 = vec3_t()
        // work out baryCentricK
        let baryCentricK = Float(1.0 - Double(surfInfo!.genBarycentricI + surfInfo!.genBarycentricJ))

        // now we have the model transformed into model space, now generate an origin.
        retMatrix.matrix[0][3] = (pTri[0][0] * surfInfo!.genBarycentricI) + (pTri[1][0] * surfInfo!.genBarycentricJ) + (pTri[2][0] * baryCentricK)
        retMatrix.matrix[1][3] = (pTri[0][1] * surfInfo!.genBarycentricI) + (pTri[1][1] * surfInfo!.genBarycentricJ) + (pTri[2][1] * baryCentricK)
        retMatrix.matrix[2][3] = (pTri[0][2] * surfInfo!.genBarycentricI) + (pTri[1][2] * surfInfo!.genBarycentricJ) + (pTri[2][2] * baryCentricK)

        // generate a normal to this new triangle
        _VectorSubtract(pTri[0], pTri[1], &vec0)
        _VectorSubtract(pTri[2], pTri[1], &vec1)

        CrossProduct(vec0, vec1, &normal)
        _ = VectorNormalize(&normal)

        // forward vector
        retMatrix.matrix[0][0] = normal[0]
        retMatrix.matrix[1][0] = normal[1]
        retMatrix.matrix[2][0] = normal[2]

        // up will be towards point 0 of the original triangle.
        // so lets work it out. Vector is hit point - point 0
        up[0] = retMatrix.matrix[0][3] - pTri[0][0]
        up[1] = retMatrix.matrix[1][3] - pTri[0][1]
        up[2] = retMatrix.matrix[2][3] - pTri[0][2]

        // normalise it
        _ = VectorNormalize(&up)

        // that's the up vector
        retMatrix.matrix[0][1] = up[0]
        retMatrix.matrix[1][1] = up[1]
        retMatrix.matrix[2][1] = up[2]

        // right is always straight

        CrossProduct(normal, up, &right)
        // that's the up vector
        retMatrix.matrix[0][2] = right[0]
        retMatrix.matrix[1][2] = right[1]
        retMatrix.matrix[2][2] = right[2]
    }
    // no, we are looking at a normal model tag
    else {
        // whip through and actually transform each vertex
        v = MdxmVertex(surface!, byteOffset: surface!.ofsVerts)
        let piBoneReferences = surface!.boneReferences
        j = 0
        while j < 3 {
// 			mdxmWeight_t	*w;

            pTri[j] = vec3_t()
 //			w = v->weights;

            let iNumWeights: Int32 = G2_GetVertWeights(v)

            var fTotalWeight: Float = 0.0
            k = 0
            while k < iNumWeights {
                let iBoneIndex: Int32 = G2_GetVertBoneIndex(v, k)
                let fBoneWeight: Float = G2_GetVertBoneWeight(v, k, &fTotalWeight, iNumWeights)

                let bone = boneCache.Eval(piBoneReferences[iBoneIndex])

                pTri[j][0] += fBoneWeight * (_DotProduct(bone.matrix[0].vector, v.vertCoords) + bone.matrix[0][3])
                pTri[j][1] += fBoneWeight * (_DotProduct(bone.matrix[1].vector, v.vertCoords) + bone.matrix[1][3])
                pTri[j][2] += fBoneWeight * (_DotProduct(bone.matrix[2].vector, v.vertCoords) + bone.matrix[2][3])
                k += 1
            }

            // AI: Raven steps the vertex pointer by one record. The view steps by the record size.
            v = MdxmVertex(v, byteOffset: MdxmVertex.byteCount)// = (mdxmVertex_t *)&v->weights[/*v->numWeights*/surface->maxVertBoneWeights];
            j += 1
        }

        // clear out used arrays
        axes.fill(vec3_t())
        sides.fill(vec3_t())

        // work out actual sides of the tag triangle
        j = 0
        while j < 3 {
            sides[j][0] = pTri[(j + 1) % 3][0] - pTri[j][0]
            sides[j][1] = pTri[(j + 1) % 3][1] - pTri[j][1]
            sides[j][2] = pTri[(j + 1) % 3][2] - pTri[j][2]
            j += 1
        }

        // do math trig to work out what the matrix will be from this triangle's translated position
        _ = VectorNormalize2(sides[iG2_TRISIDE_LONGEST], &axes[0])
        _ = VectorNormalize2(sides[iG2_TRISIDE_SHORTEST], &axes[1])

        // project shortest side so that it is exactly 90 degrees to the longer side
        d = _DotProduct(axes[0], axes[1])
        _VectorMA(axes[0], -d, axes[1], &axes[0])
        _ = VectorNormalize2(axes[0], &axes[0])

        CrossProduct(sides[iG2_TRISIDE_LONGEST], sides[iG2_TRISIDE_SHORTEST], &axes[2])
        _ = VectorNormalize2(axes[2], &axes[2])

        // set up location in world space of the origin point in out going matrix
        retMatrix.matrix[0][3] = pTri[MDX_TAG_ORIGIN][0]
        retMatrix.matrix[1][3] = pTri[MDX_TAG_ORIGIN][1]
        retMatrix.matrix[2][3] = pTri[MDX_TAG_ORIGIN][2]

        // copy axis to matrix - do some magic to orient minus Y to positive X and so on so bolt on stuff is oriented correctly
        retMatrix.matrix[0][0] = axes[1][0]
        retMatrix.matrix[0][1] = axes[0][0]
        retMatrix.matrix[0][2] = -axes[2][0]

        retMatrix.matrix[1][0] = axes[1][1]
        retMatrix.matrix[1][1] = axes[0][1]
        retMatrix.matrix[1][2] = -axes[2][1]

        retMatrix.matrix[2][0] = axes[1][2]
        retMatrix.matrix[2][1] = axes[0][2]
        retMatrix.matrix[2][2] = -axes[2][2]
    }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3253
public func G2_GetBoltMatrixLow(_ ghoul2: CGhoul2Info, _ boltNum: Int32, _ scale: JKAShared.vec3_t, _ retMatrix: JKAMP.MdxaBone) {
    if ghoul2.mBoneCache == nil {
        retMatrix.copy(from: identityMatrix)
        return
    }
    let boneCache = ghoul2.mBoneCache!
    // Raven's `boltList` is a reference to `ghoul2.mBltlist`, so the call to G2_ProcessSurfaceBolt2 hands the list itself.
    let boltList = ghoul2.mBltlist
    if boltList[boltNum].boneNumber >= 0 {
        let skel: MdxaSkel
        let offsets: MdxaSkelOffsets
        offsets = MdxaSkelOffsets(boneCache.header!, byteOffset: MdxaHeader.byteCount)
        skel = MdxaSkel(boneCache.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[boltList[boltNum].boneNumber])
        Multiply_3x4Matrix(retMatrix, boneCache.EvalUnsmooth(boltList[boltNum].boneNumber), skel.BasePoseMat)
    } else if boltList[boltNum].surfaceNumber >= 0 {
        var surfInfo: surfaceInfo_t? = nil
        do {
            var i: Int32
            i = 0
            while i < ghoul2.mSlist.count {
                let t = ghoul2.mSlist[i]
                if t.surface == boltList[boltNum].surfaceNumber {
                    surfInfo = t
                }
                i += 1
            }
        }
        var surface: MdxmSurface? = nil
        if surfInfo == nil {
            surface = G2_FindSurface_BC(boneCache.mod!, boltList[boltNum].surfaceNumber, 0)
        }
        if surface == nil && surfInfo != nil && surfInfo!.surface < 10000 {
            surface = G2_FindSurface_BC(boneCache.mod!, surfInfo!.surface, 0)
        }
        G2_ProcessSurfaceBolt2(boneCache, surface, boltNum, &ghoul2.mBltlist, surfInfo, boneCache.mod!, retMatrix)
    } else {
        // we have a bolt without a bone or surface, not a huge problem but we ought to at least clear the bolt matrix
        retMatrix.copy(from: identityMatrix)
    }
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3333
private func RootMatrix(_ ghoul2: CGhoul2Info_v, _ time: Int32, _ scale: JKAShared.vec3_t, _ retMatrix: JKAMP.MdxaBone) {
    var i: Int32
    i = 0
    while i < ghoul2.size() {
        if ghoul2[i].mModelindex != -1 && ghoul2[i].mValid {
            if (ghoul2[i].mFlags & GHOUL2_NEWORIGIN) != 0 {
                MdxaBone.scratch { bolt in
                    MdxaBone.scratch { tempMatrix in
                        G2_ConstructGhoulSkeleton(ghoul2, time, false, scale)
                        G2_GetBoltMatrixLow(ghoul2[i], ghoul2[i].mNewOrigin, scale, bolt)
                        tempMatrix.matrix[0][0] = 1.0
                        tempMatrix.matrix[0][1] = 0.0
                        tempMatrix.matrix[0][2] = 0.0
                        tempMatrix.matrix[0][3] = -bolt.matrix[0][3]
                        tempMatrix.matrix[1][0] = 0.0
                        tempMatrix.matrix[1][1] = 1.0
                        tempMatrix.matrix[1][2] = 0.0
                        tempMatrix.matrix[1][3] = -bolt.matrix[1][3]
                        tempMatrix.matrix[2][0] = 0.0
                        tempMatrix.matrix[2][1] = 0.0
                        tempMatrix.matrix[2][2] = 1.0
                        tempMatrix.matrix[2][3] = -bolt.matrix[2][3]
//				Inverse_Matrix(&bolt, &tempMatrix);
                        Multiply_3x4Matrix(retMatrix, tempMatrix, identityMatrix)
                    }
                }
                return
            }
        }
        i += 1
    }
    retMatrix.copy(from: identityMatrix)
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3369
private func bInShadowRange(_ location: JKAShared.vec3_t) -> Bool {
    // Raven's one call is in R_AddGhoulSurfaces under `#ifndef DEDICATED` at tr_ghoul2.cpp:3384, so the function is dead in the dedicated build.
    let c: Float = _DotProduct(tr.viewParms.ori.axis[0], tr.viewParms.ori.origin)
    let dist: Float = _DotProduct(tr.viewParms.ori.axis[0], location) - c

//	return (dist < tr.distanceCull/1.5f);
    return (dist < r_shadowRange!.value)
}

/**
```
==============
R_AddGHOULSurfaces
==============
```
*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3383
public func R_AddGhoulSurfaces(_ ent: TrRefEntity) {
    // Raven's whole body stands under `#ifndef DEDICATED`, so the dedicated build has an empty body.
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3544
public func G2_NeedsRecalc(_ ghlInfo: CGhoul2Info?, _ frameNum: Int32) -> Bool {
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
public func G2_ConstructGhoulSkeleton(_ ghoul2: CGhoul2Info_v, _ frameNum: Int32, _ checkForNewOrigin: Bool, _ scale: JKAShared.vec3_t) {
    G2PerformanceTimer_G2_ConstructGhoulSkeleton.Start()
    var i: Int32 = 0
    var j: Int32 = 0
    var modelCount: Int32 = 0
    MdxaBone.scratch { rootMatrix in
        // AI: Raven declares `int modelList[256]` on the stack. The body reads the forward `modelList_G2_ConstructGhoulSkeleton`.
        modelList_G2_ConstructGhoulSkeleton[255] = 548

        if checkForNewOrigin {
            RootMatrix(ghoul2, frameNum, scale, rootMatrix)
        } else {
            rootMatrix.copy(from: identityMatrix)
        }

        G2_Sort_Models(ghoul2, modelList_G2_ConstructGhoulSkeleton, &modelCount)

        j = 0
        while j < modelCount {
            // get the sorted model to play with
            i = modelList_G2_ConstructGhoulSkeleton[j]

            if ghoul2[i].mValid {
                if j != 0 && ghoul2[i].mModelBoltLink != -1 {
                    let boltMod = (ghoul2[i].mModelBoltLink >> MODEL_SHIFT) & MODEL_AND
                    let boltNum = (ghoul2[i].mModelBoltLink >> BOLT_SHIFT) & BOLT_AND

                    MdxaBone.scratch { bolt in
                        G2_GetBoltMatrixLow(ghoul2[boltMod], boltNum, scale, bolt)
                        G2_TransformGhoulBones(&ghoul2[i].mBlist, bolt, ghoul2[i], frameNum, checkForNewOrigin)
                    }
                } else {
                    G2_TransformGhoulBones(&ghoul2[i].mBlist, rootMatrix, ghoul2[i], frameNum, checkForNewOrigin)
                }
            }
            j += 1
        }
    }
    G2Time_G2_ConstructGhoulSkeleton += G2PerformanceTimer_G2_ConstructGhoulSkeleton.End()
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:4816
public func R_LoadMDXM(_ mod: Model, _ buffer: Slots<JKAShared.byte>, _ mod_name: String, _ bAlreadyCached: inout Bool) -> Bool {
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
public func R_LoadMDXA(_ mod: Model, _ buffer: Slots<JKAShared.byte>, _ mod_name: String, _ bAlreadyCached: inout Bool) -> Bool {
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
