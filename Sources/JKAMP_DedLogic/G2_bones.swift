import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:431
let DEBUG_PCJ = (0) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:622
private let DEBUG_G2_TIMING = (0) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1163
let MAX_BONES_RAG = (256) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1174
let RAG_MASK = (JKAShared.CONTENTS_SOLID | JKAShared.CONTENTS_TERRAIN)

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1192
private let RAG_PCJ = (0x00001) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1193
let RAG_PCJ_POST_MULT = (0x00002) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1194
let RAG_PCJ_MODEL_ROOT = (0x00004) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1195
let RAG_PCJ_PELVIS = (0x00008) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1196
private let RAG_EFFECTOR = (0x00100) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1197
let RAG_WAS_NOT_RENDERED = (0x01000) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1198
let RAG_WAS_EVER_RENDERED = (0x02000) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1199
let RAG_BONE_LIGHTWEIGHT = (0x04000) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1200
let RAG_PCJ_IK_CONTROLLED = (0x08000) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1201
let RAG_UNSNAPPABLE = (0x10000) as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1205
private let GHOUL2_RAG_STARTED = 0x0010 as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1206
let GHOUL2_RAG_PENDING = 0x0100 as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1207
let GHOUL2_RAG_DONE = 0x0200 as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1208
let GHOUL2_RAG_COLLISION_DURING_DEATH = 0x0400 as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1209
let GHOUL2_RAG_COLLISION_SLIDE = 0x0800 as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1210
private let GHOUL2_RAG_FORCESOLVE = 0x1000 as Int32

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1214
var ragBasepose: Slots<JKAMP.MdxaBone?> { world.storage.ragBasepose }

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1215
var ragBaseposeInv: Slots<JKAMP.MdxaBone?> { world.storage.ragBaseposeInv }

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1216
var ragBones: Slots<JKAMP.MdxaBone> { world.storage.ragBones }

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1217
var ragEffectors: Slots<RagEffector> { world.storage.ragEffectors }

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1218
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var ragBoneData: [boneInfo_t?] {
    get { world.ragBoneData }
    set { world.ragBoneData = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1219
var tempDependents: [Int32] {
    get { world.variables.tempDependents }
    set { world.variables.tempDependents = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1220
var ragBlistIndex: [Int32] {
    get { world.variables.ragBlistIndex }
    set { world.variables.ragBlistIndex = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1221
var numRags: Int32 {
    get { world.variables.numRags }
    set { world.variables.numRags = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1222
var ragBoneMins: JKAShared.vec3_t {
    get { world.variables.ragBoneMins }
    set { world.variables.ragBoneMins = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1223
var ragBoneMaxs: JKAShared.vec3_t {
    get { world.variables.ragBoneMaxs }
    set { world.variables.ragBoneMaxs = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1224
var ragBoneCM: JKAShared.vec3_t {
    get { world.variables.ragBoneCM }
    set { world.variables.ragBoneCM = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1225
var haveDesiredPelvisOffset: Bool {
    get { world.variables.haveDesiredPelvisOffset }
    set { world.variables.haveDesiredPelvisOffset = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1226
var desiredPelvisOffset: JKAShared.vec3_t {
    get { world.variables.desiredPelvisOffset }
    set { world.variables.desiredPelvisOffset = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1227
var ragOriginChange: Float {
    get { world.variables.ragOriginChange }
    set { world.variables.ragOriginChange = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1228
var ragOriginChangeDir: JKAShared.vec3_t {
    get { world.variables.ragOriginChangeDir }
    set { world.variables.ragOriginChangeDir = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1230
// Raven wrote: static vec3_t handPos={0,0,0}
let handPos: JKAShared.vec3_t = JKAShared.vec3_t(0, 0, 0)

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1231
// Raven wrote: static vec3_t handPos2={0,0,0}
let handPos2: JKAShared.vec3_t = JKAShared.vec3_t(0, 0, 0)

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1239
var ragState: Int32 {
    get { world.variables.ragState }
    set { world.variables.ragState = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1241
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var rag: [boneInfo_t?] {
    get { world.rag }
    set { world.rag = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2727
let MAX_GRAVITY_PULL = 256 as Int32

// Given a bone name, see if that bone is already in our bone list - note the model_t pointer that gets passed in here MUST point at the
// gla file, not the glm file type.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:40
func G2_Find_Bone(_ mod: Model, _ blist: inout [boneInfo_t], _ boneName: String) -> Int32 {
    // TODO: Port G2_Find_Bone
    portMissing("G2_Find_Bone", source: "oracle/codemp/ghoul2/G2_bones.cpp:40")
}

// we need to add a bone to the list - find a free one and see if we can find a corresponding bone in the gla file
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:72
func G2_Add_Bone(_ mod: Model, _ blist: inout [boneInfo_t], _ boneName: String) -> Int32 {
    // TODO: Port G2_Add_Bone
    portMissing("G2_Add_Bone", source: "oracle/codemp/ghoul2/G2_bones.cpp:72")
}

// Given a model handle, and a bone name, we want to remove this bone from the bone override list
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:145
func G2_Remove_Bone_Index(_ blist: inout [boneInfo_t], _ index: Int32) -> Bool {
    // TODO: Port G2_Remove_Bone_Index
    portMissing("G2_Remove_Bone_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:145")
}

// given a bone number, see if there is an override bone in the bone list
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:196
func G2_Find_Bone_In_List(_ blist: inout [boneInfo_t], _ boneNum: Int32) -> Int32 {
    // TODO: Port G2_Find_Bone_In_List
    portMissing("G2_Find_Bone_In_List", source: "oracle/codemp/ghoul2/G2_bones.cpp:196")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:212
func G2_Stop_Bone_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ flags: Int32) -> Bool {
    // TODO: Port G2_Stop_Bone_Index
    portMissing("G2_Stop_Bone_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:212")
}

// generate a matrix for a given bone given some new angles for it.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:228
func G2_Generate_Matrix(_ mod: Model?, _ blist: inout [boneInfo_t], _ index: Int32, _ angles: JKAShared.vec4_t?, _ flags: Int32, _ up: JKAMP.Eorientations, _ left: JKAMP.Eorientations, _ forward: JKAMP.Eorientations) {
    // TODO: Port G2_Generate_Matrix
    portMissing("G2_Generate_Matrix", source: "oracle/codemp/ghoul2/G2_bones.cpp:228")
}

// Given a model handle, and a bone name, we want to remove this bone from the bone override list
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:421
func G2_Remove_Bone(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String) -> Bool {
    // TODO: Port G2_Remove_Bone
    portMissing("G2_Remove_Bone", source: "oracle/codemp/ghoul2/G2_bones.cpp:421")
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:435
func G2_Set_Bone_Angles_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ angles: JKAShared.vec4_t?, _ flags: Int32, _ yaw: JKAMP.Eorientations, _ pitch: JKAMP.Eorientations, _ roll: JKAMP.Eorientations, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    // TODO: Port G2_Set_Bone_Angles_Index
    portMissing("G2_Set_Bone_Angles_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:435")
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:477
func G2_Set_Bone_Angles(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ angles: JKAShared.vec4_t?, _ flags: Int32, _ up: JKAMP.Eorientations, _ left: JKAMP.Eorientations, _ forward: JKAMP.Eorientations, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    // TODO: Port G2_Set_Bone_Angles
    portMissing("G2_Set_Bone_Angles", source: "oracle/codemp/ghoul2/G2_bones.cpp:477")
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding - using a matrix directly
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:536
func G2_Set_Bone_Angles_Matrix_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ matrix: JKAMP.MdxaBone, _ flags: Int32, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    // TODO: Port G2_Set_Bone_Angles_Matrix_Index
    portMissing("G2_Set_Bone_Angles_Matrix_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:536")
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding - using a matrix directly
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:567
func G2_Set_Bone_Angles_Matrix(_ fileName: String, _ blist: inout [boneInfo_t], _ boneName: String, _ matrix: JKAMP.MdxaBone, _ flags: Int32, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    // TODO: Port G2_Set_Bone_Angles_Matrix
    portMissing("G2_Set_Bone_Angles_Matrix", source: "oracle/codemp/ghoul2/G2_bones.cpp:567")
}

// given a model, bone name, a bonelist, a start/end frame number, a anim speed and some anim flags, set up or modify an existing bone entry for a new set of anims
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:625
func G2_Set_Bone_Anim_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ startFrame: Int32, _ endFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ setFrame: Float, _ blendTime: Int32, _ numFrames: Int32) -> Bool {
    // TODO: Port G2_Set_Bone_Anim_Index
    portMissing("G2_Set_Bone_Anim_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:625")
}

// given a model, bone name, a bonelist, a start/end frame number, a anim speed and some anim flags, set up or modify an existing bone entry for a new set of anims
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:815
func G2_Set_Bone_Anim(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ startFrame: Int32, _ endFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ setFrame: Float, _ blendTime: Int32) -> Bool {
    // TODO: Port G2_Set_Bone_Anim
    portMissing("G2_Set_Bone_Anim", source: "oracle/codemp/ghoul2/G2_bones.cpp:815")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:849
func G2_Get_Bone_Anim_Range(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ startFrame: inout Int32, _ endFrame: inout Int32) -> Bool {
    // TODO: Port G2_Get_Bone_Anim_Range
    portMissing("G2_Get_Bone_Anim_Range", source: "oracle/codemp/ghoul2/G2_bones.cpp:849")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:872
func G2_Get_Bone_Anim_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ currentTime: Int32, _ currentFrame: inout Float, _ startFrame: inout Int32, _ endFrame: inout Int32, _ flags: inout Int32, _ retAnimSpeed: inout Float, _ modelList: Slots<qhandle_t>?, _ numFrames: Int32) -> Bool {
    // TODO: Port G2_Get_Bone_Anim_Index
    portMissing("G2_Get_Bone_Anim_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:872")
}

// given a model, bonelist and bonename, return the current frame, startframe and endframe of the current animation
// NOTE if we aren't running an animation, then qfalse is returned
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:905
func G2_Get_Bone_Anim(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ currentTime: Int32, _ currentFrame: inout Float, _ startFrame: inout Int32, _ endFrame: inout Int32, _ flags: inout Int32, _ retAnimSpeed: inout Float, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32) -> Bool {
    // TODO: Port G2_Get_Bone_Anim
    portMissing("G2_Get_Bone_Anim", source: "oracle/codemp/ghoul2/G2_bones.cpp:905")
}

// given a model, bonelist and bonename, lets pause an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:936
func G2_Pause_Bone_Anim(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ currentTime: Int32) -> Bool {
    // TODO: Port G2_Pause_Bone_Anim
    portMissing("G2_Pause_Bone_Anim", source: "oracle/codemp/ghoul2/G2_bones.cpp:936")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:971
func G2_IsPaused(_ fileName: String, _ blist: inout [boneInfo_t], _ boneName: String) -> Bool {
    // TODO: Port G2_IsPaused
    portMissing("G2_IsPaused", source: "oracle/codemp/ghoul2/G2_bones.cpp:971")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:993
func G2_Stop_Bone_Anim_Index(_ blist: inout [boneInfo_t], _ index: Int32) -> Bool {
    // TODO: Port G2_Stop_Bone_Anim_Index
    portMissing("G2_Stop_Bone_Anim_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:993")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1009
func G2_Stop_Bone_Anim(_ fileName: String, _ blist: inout [boneInfo_t], _ boneName: String) -> Bool {
    // TODO: Port G2_Stop_Bone_Anim
    portMissing("G2_Stop_Bone_Anim", source: "oracle/codemp/ghoul2/G2_bones.cpp:1009")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1028
func G2_Stop_Bone_Angles_Index(_ blist: inout [boneInfo_t], _ index: Int32) -> Bool {
    // TODO: Port G2_Stop_Bone_Angles_Index
    portMissing("G2_Stop_Bone_Angles_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:1028")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1045
func G2_Stop_Bone_Angles(_ fileName: String, _ blist: inout [boneInfo_t], _ boneName: String) -> Bool {
    // TODO: Port G2_Stop_Bone_Angles
    portMissing("G2_Stop_Bone_Angles", source: "oracle/codemp/ghoul2/G2_bones.cpp:1045")
}

// actually walk the bone list and update each and every bone if we have ended an animation for them.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1065
func G2_Animate_Bone_List(_ ghoul2: CGhoul2Info_v, _ currentTime: Int32, _ index: Int32) {
    // TODO: Port G2_Animate_Bone_List
    portMissing("G2_Animate_Bone_List", source: "oracle/codemp/ghoul2/G2_bones.cpp:1065")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1244
private func G2_Generate_MatrixRag(_ blist: inout [boneInfo_t], _ index: Int32) {
    // TODO: Port G2_Generate_MatrixRag
    portMissing("G2_Generate_MatrixRag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1244")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1267
func G2_Find_Bone_Rag(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String) -> Int32 {
    // TODO: Port G2_Find_Bone_Rag
    portMissing("G2_Find_Bone_Rag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1267")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1318
private func G2_Set_Bone_Rag(_ mod_a: MdxaHeader, _ blist: inout [boneInfo_t], _ boneName: String, _ ghoul2: CGhoul2Info, _ scale: JKAShared.vec3_t, _ origin: JKAShared.vec3_t) -> Int32 {
    // TODO: Port G2_Set_Bone_Rag
    portMissing("G2_Set_Bone_Rag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1318")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1349
private func G2_Set_Bone_Angles_Rag(_ ghoul2: CGhoul2Info, _ mod_a: MdxaHeader, _ blist: inout [boneInfo_t], _ boneName: String, _ flags: Int32, _ radius: Float, _ angleMin: JKAShared.vec3_t, _ angleMax: JKAShared.vec3_t, _ blendTime: Int32 = 500) -> Int32 {
    // TODO: Port G2_Set_Bone_Angles_Rag
    portMissing("G2_Set_Bone_Angles_Rag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1349")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1491
private func G2_RagDollMatchPosition() {
    // Port-note: The globals haveDesiredPelvisOffset, ragBoneData, and ragEffectors have no storage, so the body cannot read them.
    // TODO: Port G2_RagDollMatchPosition
    portMissing("G2_RagDollMatchPosition", source: "oracle/codemp/ghoul2/G2_bones.cpp:1491")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1522
func G2_Set_Bone_Anim_No_BS(_ ghoul2: CGhoul2Info, _ mod: MdxaHeader, _ blist: inout [boneInfo_t], _ boneName: String, _ argStartFrame: Int32, _ argEndFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ setFrame: Float, _ blendTime: Int32, _ creationID: Int32, _ resetBonemap: Bool = true) -> Bool {
    // TODO: Port G2_Set_Bone_Anim_No_BS
    portMissing("G2_Set_Bone_Anim_No_BS", source: "oracle/codemp/ghoul2/G2_bones.cpp:1522")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1573
func G2_ResetRagDoll(_ ghoul2V: CGhoul2Info_v) {
    // TODO: Port G2_ResetRagDoll
    portMissing("G2_ResetRagDoll", source: "oracle/codemp/ghoul2/G2_bones.cpp:1573")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1622
func G2_SetRagDoll(_ ghoul2V: CGhoul2Info_v, _ parms: CRagDollParams?) {
    // TODO: Port G2_SetRagDoll
    portMissing("G2_SetRagDoll", source: "oracle/codemp/ghoul2/G2_bones.cpp:1622")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2040
func G2_SetRagDollBullet(_ ghoul2: CGhoul2Info, _ rayStart: JKAShared.vec3_t, _ hit: JKAShared.vec3_t) {
    // TODO: Port G2_SetRagDollBullet
    portMissing("G2_SetRagDollBullet", source: "oracle/codemp/ghoul2/G2_bones.cpp:2040")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2152
// TODO: Port signature
// Raven wrote: static float G2_RagSetState(CGhoul2Info &ghoul2, boneInfo_t &bone,int frameNum,const vec3_t origin,bool &resetOrigin)
// No table row for `bool & resetOrigin`.
private func G2_RagSetState() -> Never {
    // TODO: Port G2_RagSetState
    portMissing("G2_RagSetState", source: "oracle/codemp/ghoul2/G2_bones.cpp:2152")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2254
private func G2_RagDollSetup(_ ghoul2: CGhoul2Info, _ frameNum: Int32, _ resetOrigin: Bool, _ origin: JKAShared.vec3_t, _ anyRendered: Bool) -> Bool {
    // TODO: Port G2_RagDollSetup
    portMissing("G2_RagDollSetup", source: "oracle/codemp/ghoul2/G2_bones.cpp:2254")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2403
private func G2_RagDoll(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ params: CRagDollUpdateParams?, _ curTime: Int32) {
    // TODO: Port G2_RagDoll
    portMissing("G2_RagDoll", source: "oracle/codemp/ghoul2/G2_bones.cpp:2403")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2580
private func G2_Get_Bone_Name(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneNum: Int32) -> String {
    // TODO: Port G2_Get_Bone_Name
    portMissing("G2_Get_Bone_Name", source: "oracle/codemp/ghoul2/G2_bones.cpp:2580")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2609
private func G2_RagDollCurrentPosition(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ frameNum: Int32, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ scale: JKAShared.vec3_t) {
    // TODO: Port G2_RagDollCurrentPosition
    portMissing("G2_RagDollCurrentPosition", source: "oracle/codemp/ghoul2/G2_bones.cpp:2609")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2683
func Rag_Trace(_ results: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ passEntityNum: Int32, _ contentmask: Int32, _ eG2TraceType: EG2_Collision, _ useLod: Int32) {
    // TODO: Port Rag_Trace
    portMissing("Rag_Trace", source: "oracle/codemp/ghoul2/G2_bones.cpp:2683")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2729
private func G2_BoneOnGround(_ org: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ ignoreNum: Int32) -> Bool {
    // Port-note: Rag_Trace has a signature marker, so the body cannot call it.
    // TODO: Port G2_BoneOnGround
    portMissing("G2_BoneOnGround", source: "oracle/codemp/ghoul2/G2_bones.cpp:2729")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2747
private func G2_ApplyRealBonePhysics(_ bone: boneInfo_t, _ e: RagEffector, _ params: CRagDollUpdateParams?, _ goalSpot: inout JKAShared.vec3_t, _ testMins: JKAShared.vec3_t, _ testMaxs: JKAShared.vec3_t, _ gravity: Float, _ mass: Float, _ bounce: Float) -> Bool {
    // TODO: Port G2_ApplyRealBonePhysics
    portMissing("G2_ApplyRealBonePhysics", source: "oracle/codemp/ghoul2/G2_bones.cpp:2747")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3377
private func G2_RagGetWorldAnimMatrix(_ ghoul2: CGhoul2Info, _ bone: boneInfo_t, _ params: CRagDollUpdateParams?, _ retMatrix: JKAMP.MdxaBone) {
    // TODO: Port G2_RagGetWorldAnimMatrix
    portMissing("G2_RagGetWorldAnimMatrix", source: "oracle/codemp/ghoul2/G2_bones.cpp:3377")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3399
private func G2_RagGetPelvisLumbarOffsets(_ ghoul2: CGhoul2Info, _ params: CRagDollUpdateParams?, _ pos: inout JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t, _ animPos: inout JKAShared.vec3_t, _ animDir: inout JKAShared.vec3_t) {
    // TODO: Port G2_RagGetPelvisLumbarOffsets
    portMissing("G2_RagGetPelvisLumbarOffsets", source: "oracle/codemp/ghoul2/G2_bones.cpp:3399")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3449
private func G2_RagDollSettlePositionNumeroTrois(_ ghoul2V: CGhoul2Info_v, _ currentOrg: JKAShared.vec3_t, _ params: CRagDollUpdateParams?, _ curTime: Int32) -> Bool {
    // TODO: Port G2_RagDollSettlePositionNumeroTrois
    portMissing("G2_RagDollSettlePositionNumeroTrois", source: "oracle/codemp/ghoul2/G2_bones.cpp:3449")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3936
private func AngleNormZero(_ theta: Float) -> Float {
    var ret: Float = fmodf(theta, 360.0)
    if ret < -180.0 {
        ret += 360.0
    } else if ret > 180.0 {
        ret -= 360.0
    }
    return ret
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3951
private func G2_BoneSnap(_ ghoul2V: CGhoul2Info_v, _ bone: boneInfo_t, _ params: CRagDollUpdateParams?) {
    // TODO: Port G2_BoneSnap
    portMissing("G2_BoneSnap", source: "oracle/codemp/ghoul2/G2_bones.cpp:3951")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3970
private func G2_RagDollSolve(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ decay: Float, _ frameNum: Int32, _ currentOrg: JKAShared.vec3_t, _ limitAngles: Bool, _ params: CRagDollUpdateParams? = nil) {
    // TODO: Port G2_RagDollSolve
    portMissing("G2_RagDollSolve", source: "oracle/codemp/ghoul2/G2_bones.cpp:3970")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4257
private func G2_IKReposition(_ currentOrg: JKAShared.vec3_t, _ params: CRagDollUpdateParams?) {
    // TODO: Port G2_IKReposition
    portMissing("G2_IKReposition", source: "oracle/codemp/ghoul2/G2_bones.cpp:4257")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4297
private func G2_IKSolve(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ decay: Float, _ frameNum: Int32, _ currentOrg: JKAShared.vec3_t, _ limitAngles: Bool) {
    // TODO: Port G2_IKSolve
    portMissing("G2_IKSolve", source: "oracle/codemp/ghoul2/G2_bones.cpp:4297")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4453
private func G2_DoIK(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ params: CRagDollUpdateParams?) {
    // TODO: Port G2_DoIK
    portMissing("G2_DoIK", source: "oracle/codemp/ghoul2/G2_bones.cpp:4453")
}

//rww - cut out the entire non-ragdoll section of this..
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4498
// TODO: Port signature
// Raven wrote: void G2_Animate_Bone_List(CGhoul2Info_v &ghoul2, const int currentTime, const int index,CRagDollUpdateParams *params)
// No table row for `CGhoul2Info_v & ghoul2`.
// TODO: Port G2_Animate_Bone_List
// An overload before it holds the empty signature, so this marker has no function until the table shapes its parameters.

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4536
private func G2_Set_Bone_Angles_IK(_ ghoul2: CGhoul2Info, _ mod_a: MdxaHeader, _ blist: inout [boneInfo_t], _ boneName: String, _ flags: Int32, _ radius: Float, _ angleMin: JKAShared.vec3_t, _ angleMax: JKAShared.vec3_t, _ blendTime: Int32 = 500) -> Int32 {
    // TODO: Port G2_Set_Bone_Angles_IK
    portMissing("G2_Set_Bone_Angles_IK", source: "oracle/codemp/ghoul2/G2_bones.cpp:4536")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4609
// TODO: Port signature
// Raven wrote: void G2_InitIK(CGhoul2Info_v &ghoul2V, sharedRagDollUpdateParams_t *parms, int time, const mdxaHeader_t *mod_a, int model)
// No table row for `sharedRagDollUpdateParams_t * parms`.
func G2_InitIK() -> Never {
    // TODO: Port G2_InitIK
    portMissing("G2_InitIK", source: "oracle/codemp/ghoul2/G2_bones.cpp:4609")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4663
// TODO: Port signature
// Raven wrote: qboolean G2_SetBoneIKState(CGhoul2Info_v &ghoul2, int time, const char *boneName, int ikState, sharedSetBoneIKStateParams_t *params)
// No table row for `sharedSetBoneIKStateParams_t * params`.
func G2_SetBoneIKState() -> Never {
    // TODO: Port G2_SetBoneIKState
    portMissing("G2_SetBoneIKState", source: "oracle/codemp/ghoul2/G2_bones.cpp:4663")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4816
// TODO: Port signature
// Raven wrote: qboolean G2_IKMove(CGhoul2Info_v &ghoul2, int time, sharedIKMoveParams_t *params)
// No table row for `sharedIKMoveParams_t * params`.
func G2_IKMove() -> Never {
    // TODO: Port G2_IKMove
    portMissing("G2_IKMove", source: "oracle/codemp/ghoul2/G2_bones.cpp:4816")
}

// set the bone list to all unused so the bone transformation routine ignores it.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4879
func G2_Init_Bone_List(_ blist: inout [boneInfo_t]) {
    // TODO: Port G2_Init_Bone_List
    portMissing("G2_Init_Bone_List", source: "oracle/codemp/ghoul2/G2_bones.cpp:4879")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4884
func G2_RemoveRedundantBoneOverrides(_ blist: inout [boneInfo_t], _ activeBones: Slots<Int32>) {
    // TODO: Port G2_RemoveRedundantBoneOverrides
    portMissing("G2_RemoveRedundantBoneOverrides", source: "oracle/codemp/ghoul2/G2_bones.cpp:4884")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4902
func G2_Get_Bone_Index(_ ghoul2: CGhoul2Info?, _ boneName: String) -> Int32 {
    // TODO: Port G2_Get_Bone_Index
    portMissing("G2_Get_Bone_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:4902")
}
