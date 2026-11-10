import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/ghoul2/G2_API.cpp:34
var g_Ghoul2Allocations: Int32 {
    get { world.variables.g_Ghoul2Allocations }
    set { world.variables.g_Ghoul2Allocations = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:35
var g_G2ServerAlloc: Int32 {
    get { world.variables.g_G2ServerAlloc }
    set { world.variables.g_G2ServerAlloc = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:36
var g_G2ClientAlloc: Int32 {
    get { world.variables.g_G2ClientAlloc }
    set { world.variables.g_G2ClientAlloc = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:37
var g_G2AllocServer: Int32 {
    get { world.variables.g_G2AllocServer }
    set { world.variables.g_G2AllocServer = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:42
let MAX_TRACKED_ALLOC = 4096 as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:43
var g_G2AllocTrackInit: Bool {
    get { world.variables.g_G2AllocTrackInit }
    set { world.variables.g_G2AllocTrackInit = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:44
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var g_G2AllocTrack: [CGhoul2Info_v?] {
    get { world.g_G2AllocTrack }
    set { world.g_G2AllocTrack = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:159
let NUM_G2T_TIME = (2) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:160
var G2TimeBases: [Int32] {
    get { world.variables.G2TimeBases }
    set { world.variables.G2TimeBases = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:304
let MAX_G2_MODELS = (1024) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:305
let G2_MODEL_BITS = (10) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:308
let G2_INDEX_MASK = (MAX_G2_MODELS - 1)

/// Source: oracle/codemp/ghoul2/G2_API.cpp:477
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var singleton: Ghoul2InfoArray? {
    get { world.singleton }
    set { world.singleton = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:992
private let GHOUL2_RAG_STARTED = 0x0010 as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:993
private let GHOUL2_RAG_FORCESOLVE = 0x1000 as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1469
private let RAG_PCJ = (0x00001) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1470
private let RAG_EFFECTOR = (0x00100) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1724
var gG2_GBMNoReconstruct: Bool {
    get { world.variables.gG2_GBMNoReconstruct }
    set { world.variables.gG2_GBMNoReconstruct = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1725
var gG2_GBMUseSPMethod: Bool {
    get { world.variables.gG2_GBMUseSPMethod }
    set { world.variables.gG2_GBMUseSPMethod = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:46
func G2_DEBUG_InitPtrTracker() {
    // TODO: Port G2_DEBUG_InitPtrTracker
    portMissing("G2_DEBUG_InitPtrTracker", source: "oracle/codemp/ghoul2/G2_API.cpp:46")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:52
func G2_DEBUG_ReportLeaks() {
    // TODO: Port G2_DEBUG_ReportLeaks
    portMissing("G2_DEBUG_ReportLeaks", source: "oracle/codemp/ghoul2/G2_API.cpp:52")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:83
func G2_DEBUG_ShovePtrInTracker(_ g2: CGhoul2Info_v?) {
    // TODO: Port G2_DEBUG_ShovePtrInTracker
    portMissing("G2_DEBUG_ShovePtrInTracker", source: "oracle/codemp/ghoul2/G2_API.cpp:83")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:119
func G2_DEBUG_RemovePtrFromTracker(_ g2: CGhoul2Info_v?) {
    // TODO: Port G2_DEBUG_RemovePtrFromTracker
    portMissing("G2_DEBUG_RemovePtrFromTracker", source: "oracle/codemp/ghoul2/G2_API.cpp:119")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:162
func G2API_SetTime(_ currentTime: Int32, _ clock: Int32) {
    G2TimeBases[clock] = currentTime
    if G2TimeBases[1] > G2TimeBases[0] + 200 {
        G2TimeBases[1] = 0 // use server time instead
        return
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:179
func G2API_GetTime(_ argTime: Int32) -> Int32 {
    var ret = G2TimeBases[1]
    if ret == 0 {
        ret = G2TimeBases[0]
    }

    return ret
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:200
func G2API_AttachInstanceToEntNum(_ ghoul2: CGhoul2Info_v, _ entityNum: Int32, _ server: Bool) {
    // TODO: Port G2API_AttachInstanceToEntNum
    portMissing("G2API_AttachInstanceToEntNum", source: "oracle/codemp/ghoul2/G2_API.cpp:200")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:214
func G2API_ClearAttachedInstance(_ entityNum: Int32) {
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:221
func G2API_CleanEntAttachments() {
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:239
func G2API_OverrideServerWithClientData(_ serverInstance: CGhoul2Info?) -> Bool {
    // TODO: Port G2API_OverrideServerWithClientData
    portMissing("G2API_OverrideServerWithClientData", source: "oracle/codemp/ghoul2/G2_API.cpp:239")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:478
func TheGhoul2InfoArray() -> Ghoul2InfoArray {
    // TODO: Port TheGhoul2InfoArray
    portMissing("TheGhoul2InfoArray", source: "oracle/codemp/ghoul2/G2_API.cpp:478")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:487
func Ghoul2InfoArray_Free() {
    // TODO: Port Ghoul2InfoArray_Free
    portMissing("Ghoul2InfoArray_Free", source: "oracle/codemp/ghoul2/G2_API.cpp:487")
}

// this is the ONLY function to read entity states directly
/// Source: oracle/codemp/ghoul2/G2_API.cpp:496
func G2API_CleanGhoul2Models(_ ghoul2Ptr: inout CGhoul2Info_v?) {
    // TODO: Port G2API_CleanGhoul2Models
    portMissing("G2API_CleanGhoul2Models", source: "oracle/codemp/ghoul2/G2_API.cpp:496")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:570
func G2_ShouldRegisterServer() -> Bool {
    if currentVM != nil && currentVM == gvm {
        if com_cl_running != nil && com_cl_running!.integer != 0 &&
            Com_TheHunkMarkHasBeenMade() && ShaderHashTableExists() { //if the hunk has been marked then we are now loading client assets so don't load on server.
            return false
        }

        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:585
func G2API_PrecacheGhoul2Model(_ fileName: String) -> JKAShared.qhandle_t {
    if G2_ShouldRegisterServer() {
        return RE_RegisterServerModel(fileName)
    } else {
        return RE_RegisterModel(fileName)
    }
}

// initialise all that needs to be on a new Ghoul II model
/// Source: oracle/codemp/ghoul2/G2_API.cpp:601
func G2API_InitGhoul2Model(_ ghoul2Ptr: inout CGhoul2Info_v?, _ fileName: String, _ modelIndex: Int32, _ customSkin: JKAShared.qhandle_t, _ customShader: JKAShared.qhandle_t, _ modelFlags: Int32 = 0, _ lodBias: Int32 = 0) -> Int32 {
    // TODO: Port G2API_InitGhoul2Model
    portMissing("G2API_InitGhoul2Model", source: "oracle/codemp/ghoul2/G2_API.cpp:601")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:670
func G2API_SetLodBias(_ ghlInfo: CGhoul2Info?, _ lodBias: Int32) -> Bool {
    // TODO: Port G2API_SetLodBias
    portMissing("G2API_SetLodBias", source: "oracle/codemp/ghoul2/G2_API.cpp:670")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:681
func G2API_SetSkin(_ ghlInfo: CGhoul2Info?, _ customSkin: JKAShared.qhandle_t, _ renderSkin: JKAShared.qhandle_t) -> Bool {
    // TODO: Port G2API_SetSkin
    portMissing("G2API_SetSkin", source: "oracle/codemp/ghoul2/G2_API.cpp:681")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:696
func G2API_SetShader(_ ghlInfo: CGhoul2Info?, _ customShader: JKAShared.qhandle_t) -> Bool {
    // TODO: Port G2API_SetShader
    portMissing("G2API_SetShader", source: "oracle/codemp/ghoul2/G2_API.cpp:696")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:706
func G2API_SetSurfaceOnOff(_ ghoul2: CGhoul2Info_v, _ surfaceName: String, _ flags: Int32) -> Bool {
    // TODO: Port G2API_SetSurfaceOnOff
    portMissing("G2API_SetSurfaceOnOff", source: "oracle/codemp/ghoul2/G2_API.cpp:706")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:724
func G2API_GetSurfaceOnOff(_ ghlInfo: CGhoul2Info?, _ surfaceName: String) -> Int32 {
    // TODO: Port G2API_GetSurfaceOnOff
    portMissing("G2API_GetSurfaceOnOff", source: "oracle/codemp/ghoul2/G2_API.cpp:724")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:733
func G2API_SetRootSurface(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ surfaceName: String) -> Bool {
    // TODO: Port G2API_SetRootSurface
    portMissing("G2API_SetRootSurface", source: "oracle/codemp/ghoul2/G2_API.cpp:733")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:743
func G2API_AddSurface(_ ghlInfo: CGhoul2Info?, _ surfaceNumber: Int32, _ polyNumber: Int32, _ BarycentricI: Float, _ BarycentricJ: Float, _ lod: Int32) -> Int32 {
    // TODO: Port G2API_AddSurface
    portMissing("G2API_AddSurface", source: "oracle/codemp/ghoul2/G2_API.cpp:743")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:754
func G2API_RemoveSurface(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Bool {
    // TODO: Port G2API_RemoveSurface
    portMissing("G2API_RemoveSurface", source: "oracle/codemp/ghoul2/G2_API.cpp:754")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:765
func G2API_GetParentSurface(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Int32 {
    // TODO: Port G2API_GetParentSurface
    portMissing("G2API_GetParentSurface", source: "oracle/codemp/ghoul2/G2_API.cpp:765")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:774
func G2API_GetSurfaceRenderStatus(_ ghlInfo: CGhoul2Info?, _ surfaceName: String) -> Int32 {
    // TODO: Port G2API_GetSurfaceRenderStatus
    portMissing("G2API_GetSurfaceRenderStatus", source: "oracle/codemp/ghoul2/G2_API.cpp:774")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:783
func G2API_HasGhoul2ModelOnIndex(_ ghlRemove: inout CGhoul2Info_v?, _ modelIndex: Int32) -> Bool {
    // TODO: Port G2API_HasGhoul2ModelOnIndex
    portMissing("G2API_HasGhoul2ModelOnIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:783")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:795
func G2API_RemoveGhoul2Model(_ ghlRemove: inout CGhoul2Info_v?, _ modelIndex: Int32) -> Bool {
    // TODO: Port G2API_RemoveGhoul2Model
    portMissing("G2API_RemoveGhoul2Model", source: "oracle/codemp/ghoul2/G2_API.cpp:795")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:877
func G2API_RemoveGhoul2Models(_ ghlRemove: inout CGhoul2Info_v?) -> Bool {
    // TODO: Port G2API_RemoveGhoul2Models
    portMissing("G2API_RemoveGhoul2Models", source: "oracle/codemp/ghoul2/G2_API.cpp:877")
}

//check if a bone exists on skeleton without actually adding to the bone list -rww
/// Source: oracle/codemp/ghoul2/G2_API.cpp:963
func G2API_DoesBoneExist(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    // TODO: Port G2API_DoesBoneExist
    portMissing("G2API_DoesBoneExist", source: "oracle/codemp/ghoul2/G2_API.cpp:963")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:996
func G2API_SetBoneAnimIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32, _ AstartFrame: Int32, _ AendFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ AsetFrame: Float, _ blendTime: Int32) -> Bool {
    // TODO: Port G2API_SetBoneAnimIndex
    portMissing("G2API_SetBoneAnimIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:996")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1066
func G2API_SetBoneAnim(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boneName: String, _ AstartFrame: Int32, _ AendFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ AsetFrame: Float, _ blendTime: Int32 = -1) -> Bool {
    // TODO: Port G2API_SetBoneAnim
    portMissing("G2API_SetBoneAnim", source: "oracle/codemp/ghoul2/G2_API.cpp:1066")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1140
func G2API_GetBoneAnim(_ ghlInfo: CGhoul2Info?, _ boneName: String, _ currentTime: Int32, _ currentFrame: inout Float, _ startFrame: inout Int32, _ endFrame: inout Int32, _ flags: inout Int32, _ animSpeed: inout Float, _ modelList: inout Int32) -> Bool {
    // TODO: Port G2API_GetBoneAnim
    portMissing("G2API_GetBoneAnim", source: "oracle/codemp/ghoul2/G2_API.cpp:1140")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1191
func G2API_GetAnimRange(_ ghlInfo: CGhoul2Info?, _ boneName: String, _ startFrame: inout Int32, _ endFrame: inout Int32) -> Bool {
    // TODO: Port G2API_GetAnimRange
    portMissing("G2API_GetAnimRange", source: "oracle/codemp/ghoul2/G2_API.cpp:1191")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1225
func G2API_PauseBoneAnim(_ ghlInfo: CGhoul2Info?, _ boneName: String, _ currentTime: Int32) -> Bool {
    // TODO: Port G2API_PauseBoneAnim
    portMissing("G2API_PauseBoneAnim", source: "oracle/codemp/ghoul2/G2_API.cpp:1225")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1234
func G2API_IsPaused(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    // TODO: Port G2API_IsPaused
    portMissing("G2API_IsPaused", source: "oracle/codemp/ghoul2/G2_API.cpp:1234")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1243
func G2API_StopBoneAnimIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Bool {
    // TODO: Port G2API_StopBoneAnimIndex
    portMissing("G2API_StopBoneAnimIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:1243")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1252
func G2API_StopBoneAnim(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    // TODO: Port G2API_StopBoneAnim
    portMissing("G2API_StopBoneAnim", source: "oracle/codemp/ghoul2/G2_API.cpp:1252")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1261
func G2API_SetBoneAnglesIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32, _ angles: JKAShared.vec3_t, _ flags: Int32, _ yaw: JKAMP.Eorientations, _ pitch: JKAMP.Eorientations, _ roll: JKAMP.Eorientations, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    // TODO: Port G2API_SetBoneAnglesIndex
    portMissing("G2API_SetBoneAnglesIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:1261")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1298
func G2API_SetBoneAngles(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boneName: String, _ angles: JKAShared.vec3_t, _ flags: Int32, _ up: JKAMP.Eorientations, _ left: JKAMP.Eorientations, _ forward: JKAMP.Eorientations, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    // TODO: Port G2API_SetBoneAngles
    portMissing("G2API_SetBoneAngles", source: "oracle/codemp/ghoul2/G2_API.cpp:1298")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1339
func G2API_SetBoneAnglesMatrixIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32, _ matrix: JKAMP.MdxaBone, _ flags: Int32, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    // TODO: Port G2API_SetBoneAnglesMatrixIndex
    portMissing("G2API_SetBoneAnglesMatrixIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:1339")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1351
func G2API_SetBoneAnglesMatrix(_ ghlInfo: CGhoul2Info?, _ boneName: String, _ matrix: JKAMP.MdxaBone, _ flags: Int32, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32 = 0, _ currentTime: Int32 = 0) -> Bool {
    // TODO: Port G2API_SetBoneAnglesMatrix
    portMissing("G2API_SetBoneAnglesMatrix", source: "oracle/codemp/ghoul2/G2_API.cpp:1351")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1363
func G2API_StopBoneAnglesIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Bool {
    // TODO: Port G2API_StopBoneAnglesIndex
    portMissing("G2API_StopBoneAnglesIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:1363")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1374
func G2API_StopBoneAngles(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    // TODO: Port G2API_StopBoneAngles
    portMissing("G2API_StopBoneAngles", source: "oracle/codemp/ghoul2/G2_API.cpp:1374")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1386
func G2API_AbsurdSmoothing(_ ghoul2: CGhoul2Info_v, _ status: Bool) {
    // TODO: Port G2API_AbsurdSmoothing
    portMissing("G2API_AbsurdSmoothing", source: "oracle/codemp/ghoul2/G2_API.cpp:1386")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1404
func G2API_SetRagDoll(_ ghoul2: CGhoul2Info_v, _ parms: CRagDollParams?) {
    // TODO: Port G2API_SetRagDoll
    portMissing("G2API_SetRagDoll", source: "oracle/codemp/ghoul2/G2_API.cpp:1404")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1410
func G2API_ResetRagDoll(_ ghoul2: CGhoul2Info_v) {
    // TODO: Port G2API_ResetRagDoll
    portMissing("G2API_ResetRagDoll", source: "oracle/codemp/ghoul2/G2_API.cpp:1410")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1416
func G2API_RemoveBone(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    // TODO: Port G2API_RemoveBone
    portMissing("G2API_RemoveBone", source: "oracle/codemp/ghoul2/G2_API.cpp:1416")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1434
func G2API_AnimateG2Models(_ ghoul2: CGhoul2Info_v, _ AcurrentTime: Int32, _ params: CRagDollUpdateParams?) {
    // TODO: Port G2API_AnimateG2Models
    portMissing("G2API_AnimateG2Models", source: "oracle/codemp/ghoul2/G2_API.cpp:1434")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1472
private func G2_GetRagBoneConveniently(_ ghoul2: CGhoul2Info_v, _ boneName: String) -> boneInfo_t? {
    // TODO: Port G2_GetRagBoneConveniently
    portMissing("G2_GetRagBoneConveniently", source: "oracle/codemp/ghoul2/G2_API.cpp:1472")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1499
func G2API_RagPCJConstraint(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ min: JKAShared.vec3_t, _ max: JKAShared.vec3_t) -> Bool {
    // TODO: Port G2API_RagPCJConstraint
    portMissing("G2API_RagPCJConstraint", source: "oracle/codemp/ghoul2/G2_API.cpp:1499")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1519
func G2API_RagPCJGradientSpeed(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ speed: Float) -> Bool {
    // TODO: Port G2API_RagPCJGradientSpeed
    portMissing("G2API_RagPCJGradientSpeed", source: "oracle/codemp/ghoul2/G2_API.cpp:1519")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1538
func G2API_RagEffectorGoal(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ pos: JKAShared.vec3_t) -> Bool {
    // TODO: Port G2API_RagEffectorGoal
    portMissing("G2API_RagEffectorGoal", source: "oracle/codemp/ghoul2/G2_API.cpp:1538")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1564
func G2API_GetRagBonePos(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ pos: JKAShared.vec3_t, _ entAngles: JKAShared.vec3_t, _ entPos: JKAShared.vec3_t, _ entScale: JKAShared.vec3_t) -> Bool {
    // TODO: Port G2API_GetRagBonePos
    portMissing("G2API_GetRagBonePos", source: "oracle/codemp/ghoul2/G2_API.cpp:1564")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1569
func G2API_RagEffectorKick(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ velocity: JKAShared.vec3_t) -> Bool {
    // TODO: Port G2API_RagEffectorKick
    portMissing("G2API_RagEffectorKick", source: "oracle/codemp/ghoul2/G2_API.cpp:1569")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1590
func G2API_RagForceSolve(_ ghoul2: CGhoul2Info_v, _ force: Bool) -> Bool {
    // TODO: Port G2API_RagForceSolve
    portMissing("G2API_RagForceSolve", source: "oracle/codemp/ghoul2/G2_API.cpp:1590")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1613
// TODO: Port signature
// Raven wrote: qboolean G2API_SetBoneIKState(CGhoul2Info_v &ghoul2, int time, const char *boneName, int ikState, sharedSetBoneIKStateParams_t *params)
// No table row for `sharedSetBoneIKStateParams_t * params`.
func G2API_SetBoneIKState() -> Never {
    // TODO: Port G2API_SetBoneIKState
    portMissing("G2API_SetBoneIKState", source: "oracle/codemp/ghoul2/G2_API.cpp:1613")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1619
// TODO: Port signature
// Raven wrote: qboolean G2API_IKMove(CGhoul2Info_v &ghoul2, int time, sharedIKMoveParams_t *params)
// No table row for `sharedIKMoveParams_t * params`.
func G2API_IKMove() -> Never {
    // TODO: Port G2API_IKMove
    portMissing("G2API_IKMove", source: "oracle/codemp/ghoul2/G2_API.cpp:1619")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1624
func G2API_RemoveBolt(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Bool {
    // TODO: Port G2API_RemoveBolt
    portMissing("G2API_RemoveBolt", source: "oracle/codemp/ghoul2/G2_API.cpp:1624")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1633
func G2API_AddBolt(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boneName: String) -> Int32 {
    // TODO: Port G2API_AddBolt
    portMissing("G2API_AddBolt", source: "oracle/codemp/ghoul2/G2_API.cpp:1633")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1648
func G2API_AddBoltSurfNum(_ ghlInfo: CGhoul2Info?, _ surfIndex: Int32) -> Int32 {
    // TODO: Port G2API_AddBoltSurfNum
    portMissing("G2API_AddBoltSurfNum", source: "oracle/codemp/ghoul2/G2_API.cpp:1648")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1658
func G2API_AttachG2Model(_ ghoul2From: CGhoul2Info_v, _ modelFrom: Int32, _ ghoul2To: CGhoul2Info_v, _ toBoltIndex: Int32, _ toModel: Int32) -> Bool {
    // TODO: Port G2API_AttachG2Model
    portMissing("G2API_AttachG2Model", source: "oracle/codemp/ghoul2/G2_API.cpp:1658")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1684
func G2API_SetBoltInfo(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boltInfo: Int32) {
    // TODO: Port G2API_SetBoltInfo
    portMissing("G2API_SetBoltInfo", source: "oracle/codemp/ghoul2/G2_API.cpp:1684")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1695
func G2API_DetachG2Model(_ ghlInfo: CGhoul2Info?) -> Bool {
    // TODO: Port G2API_DetachG2Model
    portMissing("G2API_DetachG2Model", source: "oracle/codemp/ghoul2/G2_API.cpp:1695")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1705
func G2API_AttachEnt(_ boltInfo: inout Int32, _ ghlInfoTo: CGhoul2Info?, _ toBoltIndex: Int32, _ entNum: Int32, _ toModelNum: Int32) -> Bool {
    // TODO: Port G2API_AttachEnt
    portMissing("G2API_AttachEnt", source: "oracle/codemp/ghoul2/G2_API.cpp:1705")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1727
func G2API_GetBoltMatrix_SPMethod(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boltIndex: Int32, _ matrix: JKAMP.MdxaBone, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNum: Int32, _ modelList: Slots<qhandle_t>?, _ scale: JKAShared.vec3_t) -> Bool {
    // TODO: Port G2API_GetBoltMatrix_SPMethod
    portMissing("G2API_GetBoltMatrix_SPMethod", source: "oracle/codemp/ghoul2/G2_API.cpp:1727")
}

//qboolean G2API_GetBoltMatrix(CGhoul2Info_v &ghoul2, const int modelIndex, const int boltIndex, mdxaBone_t *matrix, const vec3_t angles,
//							 const vec3_t position, const int AframeNum, qhandle_t *modelList, const vec3_t scale )
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1795
func G2API_GetBoltMatrix(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boltIndex: Int32, _ matrix: JKAMP.MdxaBone, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNum: Int32, _ modelList: Slots<qhandle_t>?, _ scale: JKAShared.vec3_t) -> Bool {
    // TODO: Port G2API_GetBoltMatrix
    portMissing("G2API_GetBoltMatrix", source: "oracle/codemp/ghoul2/G2_API.cpp:1795")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1903
func G2API_ListSurfaces(_ ghlInfo: CGhoul2Info?) {
    // TODO: Port G2API_ListSurfaces
    portMissing("G2API_ListSurfaces", source: "oracle/codemp/ghoul2/G2_API.cpp:1903")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1911
func G2API_ListBones(_ ghlInfo: CGhoul2Info?, _ frame: Int32) {
    // TODO: Port G2API_ListBones
    portMissing("G2API_ListBones", source: "oracle/codemp/ghoul2/G2_API.cpp:1911")
}

// decide if we have Ghoul2 models associated with this ghoul list or not
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1920
func G2API_HaveWeGhoul2Models(_ ghoul2: CGhoul2Info_v) -> Bool {
    // TODO: Port G2API_HaveWeGhoul2Models
    portMissing("G2API_HaveWeGhoul2Models", source: "oracle/codemp/ghoul2/G2_API.cpp:1920")
}

// run through the Ghoul2 models and set each of the mModel values to the correct one from the cgs.gameModel offset lsit
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1937
func G2API_SetGhoul2ModelIndexes(_ ghoul2: CGhoul2Info_v, _ modelList: Slots<qhandle_t>?, _ skinList: Slots<qhandle_t>?) {
    // TODO: Port G2API_SetGhoul2ModelIndexes
    portMissing("G2API_SetGhoul2ModelIndexes", source: "oracle/codemp/ghoul2/G2_API.cpp:1937")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1962
func G2API_GetAnimFileNameIndex(_ modelIndex: JKAShared.qhandle_t) -> String {
    // TODO: Port G2API_GetAnimFileNameIndex
    portMissing("G2API_GetAnimFileNameIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:1962")
}

/**
```
***********************************************************************************************
 * G2API_GetAnimFileName
 *    obtains the name of a model's .gla (animation) file
 *
 * Input
 *    pointer to list of CGhoul2Info's, WraithID of specific model in that list
 *
 * Output
 *    true if a good filename was obtained, false otherwise
 *
 ***********************************************************************************************
```
*/
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1979
func G2API_GetAnimFileName(_ ghlInfo: CGhoul2Info?, _ filename: inout JKAShared.TextCursor) -> Bool {
    // TODO: Port G2API_GetAnimFileName
    portMissing("G2API_GetAnimFileName", source: "oracle/codemp/ghoul2/G2_API.cpp:1979")
}

/**
```
=======================
SV_QsortEntityNumbers
=======================
```
*/
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1993
private func QsortDistance(_ a: CollisionRecord?, _ b: CollisionRecord?) -> Int32 {
    // TODO: Port QsortDistance
    portMissing("QsortDistance", source: "oracle/codemp/ghoul2/G2_API.cpp:1993")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2003
private func G2_NeedRetransform(_ g2: CGhoul2Info?, _ frameNum: Int32) -> Bool {
    // TODO: Port G2_NeedRetransform
    portMissing("G2_NeedRetransform", source: "oracle/codemp/ghoul2/G2_API.cpp:2003")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2035
func G2API_CollisionDetectCache(_ collRecMap: Slots<CollisionRecord>, _ ghoul2: CGhoul2Info_v, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNumber: Int32, _ entNum: Int32, _ rayStart: JKAShared.vec3_t, _ rayEnd: JKAShared.vec3_t, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ traceFlags: Int32, _ useLod: Int32, _ fRadius: Float) {
    // TODO: Port G2API_CollisionDetectCache
    portMissing("G2API_CollisionDetectCache", source: "oracle/codemp/ghoul2/G2_API.cpp:2035")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2124
func G2API_CollisionDetect(_ collRecMap: Slots<CollisionRecord>, _ ghoul2: CGhoul2Info_v, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNumber: Int32, _ entNum: Int32, _ rayStart: JKAShared.vec3_t, _ rayEnd: JKAShared.vec3_t, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ traceFlags: Int32, _ useLod: Int32, _ fRadius: Float) {
    // TODO: Port G2API_CollisionDetect
    portMissing("G2API_CollisionDetect", source: "oracle/codemp/ghoul2/G2_API.cpp:2124")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2175
func G2API_SetGhoul2ModelFlags(_ ghlInfo: CGhoul2Info?, _ flags: Int32) -> Bool {
    // TODO: Port G2API_SetGhoul2ModelFlags
    portMissing("G2API_SetGhoul2ModelFlags", source: "oracle/codemp/ghoul2/G2_API.cpp:2175")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2186
func G2API_GetGhoul2ModelFlags(_ ghlInfo: CGhoul2Info?) -> Int32 {
    // TODO: Port G2API_GetGhoul2ModelFlags
    portMissing("G2API_GetGhoul2ModelFlags", source: "oracle/codemp/ghoul2/G2_API.cpp:2186")
}

// given a boltmatrix, return in vec a normalised vector for the axis requested in flags
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2196
func G2API_GiveMeVectorFromMatrix(_ boltMatrix: JKAMP.MdxaBone, _ flags: JKAMP.Eorientations, _ vec: inout JKAShared.vec3_t) {
    // TODO: Port G2API_GiveMeVectorFromMatrix
    portMissing("G2API_GiveMeVectorFromMatrix", source: "oracle/codemp/ghoul2/G2_API.cpp:2196")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2239
func G2API_CopyGhoul2Instance(_ g2From: CGhoul2Info_v, _ g2To: CGhoul2Info_v, _ modelIndex: Int32) -> Int32 {
    // TODO: Port G2API_CopyGhoul2Instance
    portMissing("G2API_CopyGhoul2Instance", source: "oracle/codemp/ghoul2/G2_API.cpp:2239")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2282
func G2API_CopySpecificG2Model(_ ghoul2From: CGhoul2Info_v, _ modelFrom: Int32, _ ghoul2To: CGhoul2Info_v, _ modelTo: Int32) {
    // TODO: Port G2API_CopySpecificG2Model
    portMissing("G2API_CopySpecificG2Model", source: "oracle/codemp/ghoul2/G2_API.cpp:2282")
}

// This version will automatically copy everything about this model, and make a new one if necessary.
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2330
func G2API_DuplicateGhoul2Instance(_ g2From: CGhoul2Info_v, _ g2To: inout CGhoul2Info_v?) {
    // TODO: Port G2API_DuplicateGhoul2Instance
    portMissing("G2API_DuplicateGhoul2Instance", source: "oracle/codemp/ghoul2/G2_API.cpp:2330")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2360
func G2API_GetSurfaceName(_ ghlInfo: CGhoul2Info?, _ surfNumber: Int32) -> String {
    // TODO: Port G2API_GetSurfaceName
    portMissing("G2API_GetSurfaceName", source: "oracle/codemp/ghoul2/G2_API.cpp:2360")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2403
func G2API_GetSurfaceIndex(_ ghlInfo: CGhoul2Info?, _ surfaceName: String) -> Int32 {
    // TODO: Port G2API_GetSurfaceIndex
    portMissing("G2API_GetSurfaceIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:2403")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2412
func G2API_GetGLAName(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32) -> String? {
    // TODO: Port G2API_GetGLAName
    portMissing("G2API_GetGLAName", source: "oracle/codemp/ghoul2/G2_API.cpp:2412")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2428
func G2API_SetNewOrigin(_ ghoul2: CGhoul2Info_v, _ boltIndex: Int32) -> Bool {
    // TODO: Port G2API_SetNewOrigin
    portMissing("G2API_SetNewOrigin", source: "oracle/codemp/ghoul2/G2_API.cpp:2428")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2463
func G2API_GetBoneIndex(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Int32 {
    // TODO: Port G2API_GetBoneIndex
    portMissing("G2API_GetBoneIndex", source: "oracle/codemp/ghoul2/G2_API.cpp:2463")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2472
func G2API_SaveGhoul2Models(_ ghoul2: CGhoul2Info_v, _ buffer: inout JKAShared.TextCursor, _ size: inout Int32) -> Bool {
    // TODO: Port G2API_SaveGhoul2Models
    portMissing("G2API_SaveGhoul2Models", source: "oracle/codemp/ghoul2/G2_API.cpp:2472")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2477
func G2API_LoadGhoul2Models(_ ghoul2: CGhoul2Info_v, _ buffer: inout JKAShared.CharBuf) {
    // TODO: Port G2API_LoadGhoul2Models
    portMissing("G2API_LoadGhoul2Models", source: "oracle/codemp/ghoul2/G2_API.cpp:2477")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2482
func G2API_FreeSaveBuffer(_ buffer: inout JKAShared.CharBuf) {
    // AI: Raven frees the zone block with Z_Free. The CharBuf owns its bytes, so the body frees nothing.
}

// this is kinda sad, but I need to call the destructor in this module (exe), not the game.dll...
//
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2489
func G2API_LoadSaveCodeDestructGhoul2Info(_ ghoul2: CGhoul2Info_v) {
    // TODO: Port G2API_LoadSaveCodeDestructGhoul2Info
    portMissing("G2API_LoadSaveCodeDestructGhoul2Info", source: "oracle/codemp/ghoul2/G2_API.cpp:2489")
}

//see if surfs have any shader info...
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2499
func G2API_SkinlessModel(_ g2: CGhoul2Info?) -> Bool {
    // TODO: Port G2API_SkinlessModel
    portMissing("G2API_SkinlessModel", source: "oracle/codemp/ghoul2/G2_API.cpp:2499")
}

//way of seeing how many marks are on a model currently -rww
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2534
func G2API_GetNumGoreMarks(_ g2: CGhoul2Info?) -> Int32 {
    // TODO: Port G2API_GetNumGoreMarks
    portMissing("G2API_GetNumGoreMarks", source: "oracle/codemp/ghoul2/G2_API.cpp:2534")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2549
func G2API_ClearSkinGore(_ ghoul2: CGhoul2Info_v) {
    // TODO: Port G2API_ClearSkinGore
    portMissing("G2API_ClearSkinGore", source: "oracle/codemp/ghoul2/G2_API.cpp:2549")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2563
func G2API_Ghoul2Size(_ ghoul2: CGhoul2Info_v) -> Int32 {
    // TODO: Port G2API_Ghoul2Size
    portMissing("G2API_Ghoul2Size", source: "oracle/codemp/ghoul2/G2_API.cpp:2563")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2569
// TODO: Port signature
// Raven wrote: void G2API_AddSkinGore(CGhoul2Info_v &ghoul2,SSkinGoreData &gore)
// No table row for `SSkinGoreData & gore`.
func G2API_AddSkinGore() -> Never {
    // TODO: Port G2API_AddSkinGore
    portMissing("G2API_AddSkinGore", source: "oracle/codemp/ghoul2/G2_API.cpp:2569")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2606
func G2_TestModelPointers(_ ghlInfo: CGhoul2Info?) -> Bool {
    // TODO: Port G2_TestModelPointers
    portMissing("G2_TestModelPointers", source: "oracle/codemp/ghoul2/G2_API.cpp:2606")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2675
func G2_SetupModelPointers(_ ghlInfo: CGhoul2Info?) -> Bool {
    // TODO: Port G2_SetupModelPointers
    portMissing("G2_SetupModelPointers", source: "oracle/codemp/ghoul2/G2_API.cpp:2675")
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2773
// TODO: Port signature
// Raven wrote: qboolean G2_SetupModelPointers(CGhoul2Info_v &ghoul2) // returns true if any model is properly set up
// No table row for `CGhoul2Info_v & ghoul2`.
// TODO: Port G2_SetupModelPointers
// An overload before it holds the empty signature, so this marker has no function until the table shapes its parameters.
