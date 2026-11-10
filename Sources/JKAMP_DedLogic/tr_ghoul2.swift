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
let HackadelicOnClient: Bool = { () -> Bool in portMissing("HackadelicOnClient", source: "oracle/codemp/renderer/tr_ghoul2.cpp:104") }()

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
    // TODO: Port G2_Find_Bone_ByNum
    portMissing("G2_Find_Bone_ByNum", source: "oracle/codemp/renderer/tr_ghoul2.cpp:112")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:569
func RemoveBoneCache(_ boneCache: CBoneCache?) {
    // TODO: Port RemoveBoneCache
    portMissing("RemoveBoneCache", source: "oracle/codemp/renderer/tr_ghoul2.cpp:569")
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
    // TODO: Port G2_GetModA
    portMissing("G2_GetModA", source: "oracle/codemp/renderer/tr_ghoul2.cpp:592")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:603
func G2_GetBoneDependents(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ tempDependents: inout Int32, _ maxDep: Int32) -> Int32 {
    // TODO: Port G2_GetBoneDependents
    portMissing("G2_GetBoneDependents", source: "oracle/codemp/renderer/tr_ghoul2.cpp:603")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:645
func G2_WasBoneRendered(_ ghoul2: CGhoul2Info, _ boneNum: Int32) -> Bool {
    // TODO: Port G2_WasBoneRendered
    portMissing("G2_WasBoneRendered", source: "oracle/codemp/renderer/tr_ghoul2.cpp:645")
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
    // TODO: Port G2_GetBoneNameFromSkel
    portMissing("G2_GetBoneNameFromSkel", source: "oracle/codemp/renderer/tr_ghoul2.cpp:678")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:696
func G2_RagGetBoneBasePoseMatrixLow(_ ghoul2: CGhoul2Info, _ boneNum: Int32, _ boneMatrix: JKAMP.MdxaBone, _ retMatrix: JKAMP.MdxaBone, _ scale: JKAShared.vec3_t) {
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
    // TODO: Port R_GComputeFogNum
    portMissing("R_GComputeFogNum", source: "oracle/codemp/renderer/tr_ghoul2.cpp:939")
}

// work out lod for this entity.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:967
private func G2_ComputeLOD(_ ent: TrRefEntity, _ currentModel: Model, _ lodBias: Int32) -> Int32 {
    // TODO: Port G2_ComputeLOD
    portMissing("G2_ComputeLOD", source: "oracle/codemp/renderer/tr_ghoul2.cpp:967")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1048
func G2_CreateQuaterion(_ mat: JKAMP.MdxaBone, _ quat: inout JKAShared.vec4_t) {
    // TODO: Port G2_CreateQuaterion
    portMissing("G2_CreateQuaterion", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1048")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1097
func G2_CreateMatrixFromQuaterion(_ mat: JKAMP.MdxaBone, _ quat: JKAShared.vec4_t) {
    // TODO: Port G2_CreateMatrixFromQuaterion
    portMissing("G2_CreateMatrixFromQuaterion", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1097")
}

// nasty little matrix multiply going on here..
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1128
func Multiply_3x4Matrix(_ out: JKAMP.MdxaBone, _ in2: JKAMP.MdxaBone, _ `in`: JKAMP.MdxaBone) {
    // TODO: Port Multiply_3x4Matrix
    portMissing("Multiply_3x4Matrix", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1128")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1148
private func G2_GetBonePoolIndex(_ pMDXAHeader: MdxaHeader, _ iFrame: Int32, _ iBone: Int32) -> Int32 {
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
    // TODO: Port G2_RagGetAnimMatrix
    portMissing("G2_RagGetAnimMatrix", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1417")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:1541
func G2_TransformBone(_ child: Int32, _ BC: CBoneCache) {
    // TODO: Port G2_TransformBone
    portMissing("G2_TransformBone", source: "oracle/codemp/renderer/tr_ghoul2.cpp:1541")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2053
func G2_SetUpBolts(_ header: MdxaHeader, _ ghoul2: CGhoul2Info, _ bonePtr: inout [(Int32, MdxaBone)], _ boltList: inout [boltInfo_t]) {
    // TODO: Port G2_SetUpBolts
    portMissing("G2_SetUpBolts", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2053")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2075
func G2_TransformGhoulBones(_ rootBoneList: inout [boneInfo_t], _ rootMatrix: JKAMP.MdxaBone, _ ghoul2: CGhoul2Info, _ time: Int32, _ smooth: Bool = true) {
    // TODO: Port G2_TransformGhoulBones
    portMissing("G2_TransformGhoulBones", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2075")
}

// We've come across a surface that's designated as a bolt surface, process it and put it in the appropriate bolt place
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2246
func G2_ProcessSurfaceBolt(_ bonePtr: inout [(Int32, MdxaBone)], _ surface: MdxmSurface?, _ boltNum: Int32, _ boltList: inout [boltInfo_t], _ surfInfo: surfaceInfo_t?, _ mod: Model) {
    // TODO: Port G2_ProcessSurfaceBolt
    portMissing("G2_ProcessSurfaceBolt", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2246")
}

// now go through all the generated surfaces that aren't included in the model surface hierarchy and create the correct bolt info for them
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2495
func G2_ProcessGeneratedSurfaceBolts(_ ghoul2: CGhoul2Info, _ bonePtr: inout [(Int32, MdxaBone)], _ mod_t: Model) {
    // TODO: Port G2_ProcessGeneratedSurfaceBolts
    portMissing("G2_ProcessGeneratedSurfaceBolts", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2495")
}

// Go through the model and deal with just the surfaces that are tagged as bolt on points - this is for the server side skeleton construction
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2739
func ProcessModelBoltSurfaces(_ surfaceNum: Int32, _ rootSList: inout [surfaceInfo_t], _ bonePtr: inout [(Int32, MdxaBone)], _ currentModel: Model, _ lod: Int32, _ boltList: inout [boltInfo_t]) {
    // TODO: Port ProcessModelBoltSurfaces
    portMissing("ProcessModelBoltSurfaces", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2739")
}

// build the used bone list so when doing bone transforms we can determine if we need to do it or not
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2796
func G2_ConstructUsedBoneList(_ CBL: CConstructBoneList) {
    // TODO: Port G2_ConstructUsedBoneList
    portMissing("G2_ConstructUsedBoneList", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2796")
}

// NOTE!! This assumes at least one model will NOT have a parent. If it does - we are screwed
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:2881
private func G2_Sort_Models(_ ghoul2: CGhoul2Info_v, _ modelList: Slots<Int32>, _ modelCount: inout Int32) {
    // TODO: Port G2_Sort_Models
    portMissing("G2_Sort_Models", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2881")
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
    // TODO: Port G2_ProcessSurfaceBolt2
    portMissing("G2_ProcessSurfaceBolt2", source: "oracle/codemp/renderer/tr_ghoul2.cpp:2983")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3253
func G2_GetBoltMatrixLow(_ ghoul2: CGhoul2Info, _ boltNum: Int32, _ scale: JKAShared.vec3_t, _ retMatrix: JKAMP.MdxaBone) {
    // TODO: Port G2_GetBoltMatrixLow
    portMissing("G2_GetBoltMatrixLow", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3253")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3333
private func RootMatrix(_ ghoul2: CGhoul2Info_v, _ time: Int32, _ scale: JKAShared.vec3_t, _ retMatrix: JKAMP.MdxaBone) {
    // TODO: Port RootMatrix
    portMissing("RootMatrix", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3333")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3369
private func bInShadowRange(_ location: JKAShared.vec3_t) -> Bool {
    // Port-note: The global tr has no view, so the body cannot read tr.viewParms.ori.
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
    // TODO: Port R_AddGhoulSurfaces
    portMissing("R_AddGhoulSurfaces", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3383")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3544
func G2_NeedsRecalc(_ ghlInfo: CGhoul2Info?, _ frameNum: Int32) -> Bool {
    // TODO: Port G2_NeedsRecalc
    portMissing("G2_NeedsRecalc", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3544")
}

/**
```
==============
G2_ConstructGhoulSkeleton - builds a complete skeleton for all ghoul models in a CGhoul2Info_v class	- using LOD 0
==============
```
*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:3570
func G2_ConstructGhoulSkeleton(_ ghoul2: CGhoul2Info_v, _ frameNum: Int32, _ checkForNewOrigin: Bool, _ scale: JKAShared.vec3_t) {
    // TODO: Port G2_ConstructGhoulSkeleton
    portMissing("G2_ConstructGhoulSkeleton", source: "oracle/codemp/renderer/tr_ghoul2.cpp:3570")
}

/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:4816
// TODO: Port signature
// Raven wrote: qboolean R_LoadMDXM( model_t *mod, void *buffer, const char *mod_name, qboolean &bAlreadyCached )
// No table row for `qboolean & bAlreadyCached`.
func R_LoadMDXM() -> Never {
    // TODO: Port R_LoadMDXM
    portMissing("R_LoadMDXM", source: "oracle/codemp/renderer/tr_ghoul2.cpp:4816")
}

/**
```
=================
R_LoadMDXA - load a Ghoul 2 animation file
=================
```
*/
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:5256
// TODO: Port signature
// Raven wrote: qboolean R_LoadMDXA( model_t *mod, void *buffer, const char *mod_name, qboolean &bAlreadyCached )
// No table row for `qboolean & bAlreadyCached`.
func R_LoadMDXA() -> Never {
    // TODO: Port R_LoadMDXA
    portMissing("R_LoadMDXA", source: "oracle/codemp/renderer/tr_ghoul2.cpp:5256")
}
