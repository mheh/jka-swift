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
// TODO: Port global ragBasepose
// Raven wrote: static mdxaBone_t* ragBasepose[MAX_BONES_RAG]
// No table row for `mdxaBone_t *[256]`.

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1215
// TODO: Port global ragBaseposeInv
// Raven wrote: static mdxaBone_t* ragBaseposeInv[MAX_BONES_RAG]
// No table row for `mdxaBone_t *[256]`.

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1216
// TODO: Port global ragBones
// Raven wrote: static mdxaBone_t ragBones[MAX_BONES_RAG]
// No view for `mdxaBone_t` of `q_shared.h`.

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1217
// TODO: Port global ragEffectors
// Raven wrote: static SRagEffector ragEffectors[MAX_BONES_RAG]
// No view for `SRagEffector`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1218
// TODO: Port global ragBoneData
// Raven wrote: static boneInfo_t *ragBoneData[MAX_BONES_RAG]
// No table row for `boneInfo_t *[256]`.

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
// TODO: Port global haveDesiredPelvisOffset
// Raven wrote: static bool haveDesiredPelvisOffset=false
// No table row for `bool`.

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
// TODO: Port global rag
// Raven wrote: static vector<boneInfo_t *> rag
// No view for `std::vector<boneInfo_t *>` of `vector.h`.

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2727
let MAX_GRAVITY_PULL = 256 as Int32

// Given a bone name, see if that bone is already in our bone list - note the model_t pointer that gets passed in here MUST point at the
// gla file, not the glm file type.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:40
// TODO: Port signature
// Raven wrote: int G2_Find_Bone(const model_t *mod, boneInfo_v &blist, const char *boneName)
// No table row for `const model_t * mod`.
func G2_Find_Bone() -> Never {
    // TODO: Port G2_Find_Bone
    portMissing("G2_Find_Bone", source: "oracle/codemp/ghoul2/G2_bones.cpp:40")
}

// we need to add a bone to the list - find a free one and see if we can find a corresponding bone in the gla file
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:72
// TODO: Port signature
// Raven wrote: int G2_Add_Bone (const model_t *mod, boneInfo_v &blist, const char *boneName)
// No table row for `const model_t * mod`.
func G2_Add_Bone() -> Never {
    // TODO: Port G2_Add_Bone
    portMissing("G2_Add_Bone", source: "oracle/codemp/ghoul2/G2_bones.cpp:72")
}

// Given a model handle, and a bone name, we want to remove this bone from the bone override list
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:145
// TODO: Port signature
// Raven wrote: qboolean G2_Remove_Bone_Index ( boneInfo_v &blist, int index)
// No table row for `boneInfo_v & blist`.
func G2_Remove_Bone_Index() -> Never {
    // TODO: Port G2_Remove_Bone_Index
    portMissing("G2_Remove_Bone_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:145")
}

// given a bone number, see if there is an override bone in the bone list
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:196
// TODO: Port signature
// Raven wrote: int G2_Find_Bone_In_List(boneInfo_v &blist, const int boneNum)
// No table row for `boneInfo_v & blist`.
func G2_Find_Bone_In_List() -> Never {
    // TODO: Port G2_Find_Bone_In_List
    portMissing("G2_Find_Bone_In_List", source: "oracle/codemp/ghoul2/G2_bones.cpp:196")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:212
// TODO: Port signature
// Raven wrote: qboolean G2_Stop_Bone_Index( boneInfo_v &blist, int index, int flags)
// No table row for `boneInfo_v & blist`.
func G2_Stop_Bone_Index() -> Never {
    // TODO: Port G2_Stop_Bone_Index
    portMissing("G2_Stop_Bone_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:212")
}

// generate a matrix for a given bone given some new angles for it.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:228
// TODO: Port signature
// Raven wrote: void G2_Generate_Matrix(const model_t *mod, boneInfo_v &blist, int index, const float *angles, int flags, const Eorientations up, const Eorientations left, const Eorientations forward)
// No table row for `const model_t * mod`.
func G2_Generate_Matrix() -> Never {
    // TODO: Port G2_Generate_Matrix
    portMissing("G2_Generate_Matrix", source: "oracle/codemp/ghoul2/G2_bones.cpp:228")
}

// Given a model handle, and a bone name, we want to remove this bone from the bone override list
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:421
// TODO: Port signature
// Raven wrote: qboolean G2_Remove_Bone (CGhoul2Info *ghlInfo, boneInfo_v &blist, const char *boneName)
// No table row for `CGhoul2Info * ghlInfo`.
func G2_Remove_Bone() -> Never {
    // TODO: Port G2_Remove_Bone
    portMissing("G2_Remove_Bone", source: "oracle/codemp/ghoul2/G2_bones.cpp:421")
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:435
// TODO: Port signature
// Raven wrote: qboolean G2_Set_Bone_Angles_Index( boneInfo_v &blist, const int index, const float *angles, const int flags, const Eorientations yaw, const Eorientations pitch, const Eorientations roll, qhandle_t *modelList, const int modelIndex, const int blendTime, const int currentTime)
// No table row for `boneInfo_v & blist`.
func G2_Set_Bone_Angles_Index() -> Never {
    // TODO: Port G2_Set_Bone_Angles_Index
    portMissing("G2_Set_Bone_Angles_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:435")
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:477
// TODO: Port signature
// Raven wrote: qboolean G2_Set_Bone_Angles(CGhoul2Info *ghlInfo, boneInfo_v &blist, const char *boneName, const float *angles, const int flags, const Eorientations up, const Eorientations left, const Eorientations forward, qhandle_t *modelList, const int modelIndex, const int blendTime, const int currentTime)
// No table row for `CGhoul2Info * ghlInfo`.
func G2_Set_Bone_Angles() -> Never {
    // TODO: Port G2_Set_Bone_Angles
    portMissing("G2_Set_Bone_Angles", source: "oracle/codemp/ghoul2/G2_bones.cpp:477")
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding - using a matrix directly
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:536
// TODO: Port signature
// Raven wrote: qboolean G2_Set_Bone_Angles_Matrix_Index(boneInfo_v &blist, const int index, const mdxaBone_t &matrix, const int flags, qhandle_t *modelList, const int modelIndex, const int blendTime, const int currentTime)
// No table row for `boneInfo_v & blist`.
func G2_Set_Bone_Angles_Matrix_Index() -> Never {
    // TODO: Port G2_Set_Bone_Angles_Matrix_Index
    portMissing("G2_Set_Bone_Angles_Matrix_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:536")
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding - using a matrix directly
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:567
// TODO: Port signature
// Raven wrote: qboolean G2_Set_Bone_Angles_Matrix(const char *fileName, boneInfo_v &blist, const char *boneName, const mdxaBone_t &matrix, const int flags, qhandle_t *modelList, const int modelIndex, const int blendTime, const int currentTime)
// No table row for `boneInfo_v & blist`.
func G2_Set_Bone_Angles_Matrix() -> Never {
    // TODO: Port G2_Set_Bone_Angles_Matrix
    portMissing("G2_Set_Bone_Angles_Matrix", source: "oracle/codemp/ghoul2/G2_bones.cpp:567")
}

// given a model, bone name, a bonelist, a start/end frame number, a anim speed and some anim flags, set up or modify an existing bone entry for a new set of anims
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:625
// TODO: Port signature
// Raven wrote: qboolean G2_Set_Bone_Anim_Index( boneInfo_v &blist, const int index, const int startFrame, const int endFrame, const int flags, const float animSpeed, const int currentTime, const float setFrame, const int blendTime, const int numFrames)
// No table row for `boneInfo_v & blist`.
func G2_Set_Bone_Anim_Index() -> Never {
    // TODO: Port G2_Set_Bone_Anim_Index
    portMissing("G2_Set_Bone_Anim_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:625")
}

// given a model, bone name, a bonelist, a start/end frame number, a anim speed and some anim flags, set up or modify an existing bone entry for a new set of anims
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:815
// TODO: Port signature
// Raven wrote: qboolean G2_Set_Bone_Anim(CGhoul2Info *ghlInfo, boneInfo_v &blist, const char *boneName, const int startFrame, const int endFrame, const int flags, const float animSpeed, const int currentTime, const float setFrame, const int blendTime)
// No table row for `CGhoul2Info * ghlInfo`.
func G2_Set_Bone_Anim() -> Never {
    // TODO: Port G2_Set_Bone_Anim
    portMissing("G2_Set_Bone_Anim", source: "oracle/codemp/ghoul2/G2_bones.cpp:815")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:849
// TODO: Port signature
// Raven wrote: qboolean G2_Get_Bone_Anim_Range(CGhoul2Info *ghlInfo, boneInfo_v &blist, const char *boneName, int *startFrame, int *endFrame)
// No table row for `CGhoul2Info * ghlInfo`.
func G2_Get_Bone_Anim_Range() -> Never {
    // TODO: Port G2_Get_Bone_Anim_Range
    portMissing("G2_Get_Bone_Anim_Range", source: "oracle/codemp/ghoul2/G2_bones.cpp:849")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:872
// TODO: Port signature
// Raven wrote: qboolean G2_Get_Bone_Anim_Index( boneInfo_v &blist, const int index, const int currentTime, float *currentFrame, int *startFrame, int *endFrame, int *flags, float *retAnimSpeed, qhandle_t *modelList, int numFrames)
// No table row for `boneInfo_v & blist`.
func G2_Get_Bone_Anim_Index() -> Never {
    // TODO: Port G2_Get_Bone_Anim_Index
    portMissing("G2_Get_Bone_Anim_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:872")
}

// given a model, bonelist and bonename, return the current frame, startframe and endframe of the current animation
// NOTE if we aren't running an animation, then qfalse is returned
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:905
// TODO: Port signature
// Raven wrote: qboolean G2_Get_Bone_Anim(CGhoul2Info *ghlInfo, boneInfo_v &blist, const char *boneName, const int currentTime, float *currentFrame, int *startFrame, int *endFrame, int *flags, float *retAnimSpeed, qhandle_t *modelList, int modelIndex)
// No table row for `CGhoul2Info * ghlInfo`.
func G2_Get_Bone_Anim() -> Never {
    // TODO: Port G2_Get_Bone_Anim
    portMissing("G2_Get_Bone_Anim", source: "oracle/codemp/ghoul2/G2_bones.cpp:905")
}

// given a model, bonelist and bonename, lets pause an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:936
// TODO: Port signature
// Raven wrote: qboolean G2_Pause_Bone_Anim(CGhoul2Info *ghlInfo, boneInfo_v &blist, const char *boneName, const int currentTime)
// No table row for `CGhoul2Info * ghlInfo`.
func G2_Pause_Bone_Anim() -> Never {
    // TODO: Port G2_Pause_Bone_Anim
    portMissing("G2_Pause_Bone_Anim", source: "oracle/codemp/ghoul2/G2_bones.cpp:936")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:971
// TODO: Port signature
// Raven wrote: qboolean G2_IsPaused(const char *fileName, boneInfo_v &blist, const char *boneName)
// No table row for `boneInfo_v & blist`.
func G2_IsPaused() -> Never {
    // TODO: Port G2_IsPaused
    portMissing("G2_IsPaused", source: "oracle/codemp/ghoul2/G2_bones.cpp:971")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:993
// TODO: Port signature
// Raven wrote: qboolean G2_Stop_Bone_Anim_Index(boneInfo_v &blist, const int index)
// No table row for `boneInfo_v & blist`.
func G2_Stop_Bone_Anim_Index() -> Never {
    // TODO: Port G2_Stop_Bone_Anim_Index
    portMissing("G2_Stop_Bone_Anim_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:993")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1009
// TODO: Port signature
// Raven wrote: qboolean G2_Stop_Bone_Anim(const char *fileName, boneInfo_v &blist, const char *boneName)
// No table row for `boneInfo_v & blist`.
func G2_Stop_Bone_Anim() -> Never {
    // TODO: Port G2_Stop_Bone_Anim
    portMissing("G2_Stop_Bone_Anim", source: "oracle/codemp/ghoul2/G2_bones.cpp:1009")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1028
// TODO: Port signature
// Raven wrote: qboolean G2_Stop_Bone_Angles_Index(boneInfo_v &blist, const int index)
// No table row for `boneInfo_v & blist`.
func G2_Stop_Bone_Angles_Index() -> Never {
    // TODO: Port G2_Stop_Bone_Angles_Index
    portMissing("G2_Stop_Bone_Angles_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:1028")
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1045
// TODO: Port signature
// Raven wrote: qboolean G2_Stop_Bone_Angles(const char *fileName, boneInfo_v &blist, const char *boneName)
// No table row for `boneInfo_v & blist`.
func G2_Stop_Bone_Angles() -> Never {
    // TODO: Port G2_Stop_Bone_Angles
    portMissing("G2_Stop_Bone_Angles", source: "oracle/codemp/ghoul2/G2_bones.cpp:1045")
}

// actually walk the bone list and update each and every bone if we have ended an animation for them.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1065
// TODO: Port signature
// Raven wrote: void G2_Animate_Bone_List(CGhoul2Info_v &ghoul2, const int currentTime, const int index )
// No table row for `CGhoul2Info_v & ghoul2`.
func G2_Animate_Bone_List() -> Never {
    // TODO: Port G2_Animate_Bone_List
    portMissing("G2_Animate_Bone_List", source: "oracle/codemp/ghoul2/G2_bones.cpp:1065")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1244
// TODO: Port signature
// Raven wrote: static void G2_Generate_MatrixRag( // caution this must not be called before the whole skeleton is "remembered" boneInfo_v &blist, int index)
// No table row for `boneInfo_v & blist`.
private func G2_Generate_MatrixRag() -> Never {
    // TODO: Port G2_Generate_MatrixRag
    portMissing("G2_Generate_MatrixRag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1244")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1267
// TODO: Port signature
// Raven wrote: int G2_Find_Bone_Rag(CGhoul2Info *ghlInfo, boneInfo_v &blist, const char *boneName)
// No table row for `CGhoul2Info * ghlInfo`.
func G2_Find_Bone_Rag() -> Never {
    // TODO: Port G2_Find_Bone_Rag
    portMissing("G2_Find_Bone_Rag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1267")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1318
// TODO: Port signature
// Raven wrote: static int G2_Set_Bone_Rag(const mdxaHeader_t *mod_a, boneInfo_v &blist, const char *boneName, CGhoul2Info &ghoul2, const vec3_t scale, const vec3_t origin)
// No table row for `const mdxaHeader_t * mod_a`.
private func G2_Set_Bone_Rag() -> Never {
    // TODO: Port G2_Set_Bone_Rag
    portMissing("G2_Set_Bone_Rag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1318")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1349
// TODO: Port signature
// Raven wrote: static int G2_Set_Bone_Angles_Rag( CGhoul2Info &ghoul2, const mdxaHeader_t *mod_a, boneInfo_v &blist, const char *boneName, const int flags, const float radius, const vec3_t angleMin=0, const vec3_t angleMax=0, const int blendTime=500)
// No table row for `CGhoul2Info & ghoul2`.
private func G2_Set_Bone_Angles_Rag() -> Never {
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
// TODO: Port signature
// Raven wrote: qboolean G2_Set_Bone_Anim_No_BS(CGhoul2Info &ghoul2, const mdxaHeader_t *mod,boneInfo_v &blist, const char *boneName, const int argStartFrame, const int argEndFrame, const int flags, const float animSpeed, const int currentTime, const float setFrame, const int blendTime, const int creationID, bool resetBonemap=true)
// No table row for `CGhoul2Info & ghoul2`.
func G2_Set_Bone_Anim_No_BS() -> Never {
    // TODO: Port G2_Set_Bone_Anim_No_BS
    portMissing("G2_Set_Bone_Anim_No_BS", source: "oracle/codemp/ghoul2/G2_bones.cpp:1522")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1573
// TODO: Port signature
// Raven wrote: void G2_ResetRagDoll(CGhoul2Info_v &ghoul2V)
// No table row for `CGhoul2Info_v & ghoul2V`.
func G2_ResetRagDoll() -> Never {
    // TODO: Port G2_ResetRagDoll
    portMissing("G2_ResetRagDoll", source: "oracle/codemp/ghoul2/G2_bones.cpp:1573")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1622
// TODO: Port signature
// Raven wrote: void G2_SetRagDoll(CGhoul2Info_v &ghoul2V,CRagDollParams *parms)
// No table row for `CGhoul2Info_v & ghoul2V`.
func G2_SetRagDoll() -> Never {
    // TODO: Port G2_SetRagDoll
    portMissing("G2_SetRagDoll", source: "oracle/codemp/ghoul2/G2_bones.cpp:1622")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2040
// TODO: Port signature
// Raven wrote: void G2_SetRagDollBullet(CGhoul2Info &ghoul2,const vec3_t rayStart,const vec3_t hit)
// No table row for `CGhoul2Info & ghoul2`.
func G2_SetRagDollBullet() -> Never {
    // TODO: Port G2_SetRagDollBullet
    portMissing("G2_SetRagDollBullet", source: "oracle/codemp/ghoul2/G2_bones.cpp:2040")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2152
// TODO: Port signature
// Raven wrote: static float G2_RagSetState(CGhoul2Info &ghoul2, boneInfo_t &bone,int frameNum,const vec3_t origin,bool &resetOrigin)
// No table row for `CGhoul2Info & ghoul2`.
private func G2_RagSetState() -> Never {
    // TODO: Port G2_RagSetState
    portMissing("G2_RagSetState", source: "oracle/codemp/ghoul2/G2_bones.cpp:2152")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2254
// TODO: Port signature
// Raven wrote: static bool G2_RagDollSetup(CGhoul2Info &ghoul2,int frameNum,bool resetOrigin,const vec3_t origin,bool anyRendered)
// No table row for `CGhoul2Info & ghoul2`.
private func G2_RagDollSetup() -> Never {
    // TODO: Port G2_RagDollSetup
    portMissing("G2_RagDollSetup", source: "oracle/codemp/ghoul2/G2_bones.cpp:2254")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2403
// TODO: Port signature
// Raven wrote: static void G2_RagDoll(CGhoul2Info_v &ghoul2V,int g2Index,CRagDollUpdateParams *params, int curTime)
// No table row for `CGhoul2Info_v & ghoul2V`.
private func G2_RagDoll() -> Never {
    // TODO: Port G2_RagDoll
    portMissing("G2_RagDoll", source: "oracle/codemp/ghoul2/G2_bones.cpp:2403")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2580
// TODO: Port signature
// Raven wrote: static inline char *G2_Get_Bone_Name(CGhoul2Info *ghlInfo, boneInfo_v &blist, int boneNum)
// No table row for `CGhoul2Info * ghlInfo`.
private func G2_Get_Bone_Name() -> Never {
    // TODO: Port G2_Get_Bone_Name
    portMissing("G2_Get_Bone_Name", source: "oracle/codemp/ghoul2/G2_bones.cpp:2580")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2609
// TODO: Port signature
// Raven wrote: static void G2_RagDollCurrentPosition(CGhoul2Info_v &ghoul2V,int g2Index,int frameNum,const vec3_t angles,const vec3_t position,const vec3_t scale)
// No table row for `CGhoul2Info_v & ghoul2V`.
private func G2_RagDollCurrentPosition() -> Never {
    // TODO: Port G2_RagDollCurrentPosition
    portMissing("G2_RagDollCurrentPosition", source: "oracle/codemp/ghoul2/G2_bones.cpp:2609")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2683
// TODO: Port signature
// Raven wrote: void Rag_Trace( trace_t *results, const vec3_t start, const vec3_t mins, const vec3_t maxs, const vec3_t end, const int passEntityNum, const int contentmask, const EG2_Collision eG2TraceType, const int useLod )
// No table row for `const EG2_Collision eG2TraceType`.
func Rag_Trace() -> Never {
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
// TODO: Port signature
// Raven wrote: static inline bool G2_ApplyRealBonePhysics(boneInfo_t &bone, SRagEffector &e, CRagDollUpdateParams *params, vec3_t goalSpot, const vec3_t testMins, const vec3_t testMaxs, const float gravity, const float mass, const float bounce)
// No table row for `boneInfo_t & bone`.
private func G2_ApplyRealBonePhysics() -> Never {
    // TODO: Port G2_ApplyRealBonePhysics
    portMissing("G2_ApplyRealBonePhysics", source: "oracle/codemp/ghoul2/G2_bones.cpp:2747")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3377
// TODO: Port signature
// Raven wrote: static inline void G2_RagGetWorldAnimMatrix(CGhoul2Info &ghoul2, boneInfo_t &bone, CRagDollUpdateParams *params, mdxaBone_t &retMatrix)
// No table row for `CGhoul2Info & ghoul2`.
private func G2_RagGetWorldAnimMatrix() -> Never {
    // TODO: Port G2_RagGetWorldAnimMatrix
    portMissing("G2_RagGetWorldAnimMatrix", source: "oracle/codemp/ghoul2/G2_bones.cpp:3377")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3399
// TODO: Port signature
// Raven wrote: static inline void G2_RagGetPelvisLumbarOffsets(CGhoul2Info &ghoul2, CRagDollUpdateParams *params, vec3_t pos, vec3_t dir, vec3_t animPos, vec3_t animDir)
// No table row for `CGhoul2Info & ghoul2`.
private func G2_RagGetPelvisLumbarOffsets() -> Never {
    // TODO: Port G2_RagGetPelvisLumbarOffsets
    portMissing("G2_RagGetPelvisLumbarOffsets", source: "oracle/codemp/ghoul2/G2_bones.cpp:3399")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3449
// TODO: Port signature
// Raven wrote: static bool G2_RagDollSettlePositionNumeroTrois(CGhoul2Info_v &ghoul2V, const vec3_t currentOrg, CRagDollUpdateParams *params, int curTime)
// No table row for `CGhoul2Info_v & ghoul2V`.
private func G2_RagDollSettlePositionNumeroTrois() -> Never {
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
// TODO: Port signature
// Raven wrote: static inline void G2_BoneSnap(CGhoul2Info_v &ghoul2V, boneInfo_t &bone, CRagDollUpdateParams *params)
// No table row for `CGhoul2Info_v & ghoul2V`.
private func G2_BoneSnap() -> Never {
    // TODO: Port G2_BoneSnap
    portMissing("G2_BoneSnap", source: "oracle/codemp/ghoul2/G2_bones.cpp:3951")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3970
// TODO: Port signature
// Raven wrote: static void G2_RagDollSolve(CGhoul2Info_v &ghoul2V,int g2Index,float decay,int frameNum,const vec3_t currentOrg,bool limitAngles,CRagDollUpdateParams *params)
// No table row for `CGhoul2Info_v & ghoul2V`.
private func G2_RagDollSolve() -> Never {
    // TODO: Port G2_RagDollSolve
    portMissing("G2_RagDollSolve", source: "oracle/codemp/ghoul2/G2_bones.cpp:3970")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4257
// TODO: Port signature
// Raven wrote: static void G2_IKReposition(const vec3_t currentOrg,CRagDollUpdateParams *params)
// No table row for `CRagDollUpdateParams * params`.
private func G2_IKReposition() -> Never {
    // TODO: Port G2_IKReposition
    portMissing("G2_IKReposition", source: "oracle/codemp/ghoul2/G2_bones.cpp:4257")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4297
// TODO: Port signature
// Raven wrote: static void G2_IKSolve(CGhoul2Info_v &ghoul2V,int g2Index,float decay,int frameNum,const vec3_t currentOrg,bool limitAngles)
// No table row for `CGhoul2Info_v & ghoul2V`.
private func G2_IKSolve() -> Never {
    // TODO: Port G2_IKSolve
    portMissing("G2_IKSolve", source: "oracle/codemp/ghoul2/G2_bones.cpp:4297")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4453
// TODO: Port signature
// Raven wrote: static void G2_DoIK(CGhoul2Info_v &ghoul2V,int g2Index,CRagDollUpdateParams *params)
// No table row for `CGhoul2Info_v & ghoul2V`.
private func G2_DoIK() -> Never {
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
// TODO: Port signature
// Raven wrote: static int G2_Set_Bone_Angles_IK( CGhoul2Info &ghoul2, const mdxaHeader_t *mod_a, boneInfo_v &blist, const char *boneName, const int flags, const float radius, const vec3_t angleMin=0, const vec3_t angleMax=0, const int blendTime=500)
// No table row for `CGhoul2Info & ghoul2`.
private func G2_Set_Bone_Angles_IK() -> Never {
    // TODO: Port G2_Set_Bone_Angles_IK
    portMissing("G2_Set_Bone_Angles_IK", source: "oracle/codemp/ghoul2/G2_bones.cpp:4536")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4609
// TODO: Port signature
// Raven wrote: void G2_InitIK(CGhoul2Info_v &ghoul2V, sharedRagDollUpdateParams_t *parms, int time, const mdxaHeader_t *mod_a, int model)
// No table row for `CGhoul2Info_v & ghoul2V`.
func G2_InitIK() -> Never {
    // TODO: Port G2_InitIK
    portMissing("G2_InitIK", source: "oracle/codemp/ghoul2/G2_bones.cpp:4609")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4663
// TODO: Port signature
// Raven wrote: qboolean G2_SetBoneIKState(CGhoul2Info_v &ghoul2, int time, const char *boneName, int ikState, sharedSetBoneIKStateParams_t *params)
// No table row for `CGhoul2Info_v & ghoul2`.
func G2_SetBoneIKState() -> Never {
    // TODO: Port G2_SetBoneIKState
    portMissing("G2_SetBoneIKState", source: "oracle/codemp/ghoul2/G2_bones.cpp:4663")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4816
// TODO: Port signature
// Raven wrote: qboolean G2_IKMove(CGhoul2Info_v &ghoul2, int time, sharedIKMoveParams_t *params)
// No table row for `CGhoul2Info_v & ghoul2`.
func G2_IKMove() -> Never {
    // TODO: Port G2_IKMove
    portMissing("G2_IKMove", source: "oracle/codemp/ghoul2/G2_bones.cpp:4816")
}

// set the bone list to all unused so the bone transformation routine ignores it.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4879
// TODO: Port signature
// Raven wrote: void G2_Init_Bone_List(boneInfo_v &blist)
// No table row for `boneInfo_v & blist`.
func G2_Init_Bone_List() -> Never {
    // TODO: Port G2_Init_Bone_List
    portMissing("G2_Init_Bone_List", source: "oracle/codemp/ghoul2/G2_bones.cpp:4879")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4884
// TODO: Port signature
// Raven wrote: void G2_RemoveRedundantBoneOverrides(boneInfo_v &blist, int *activeBones)
// No table row for `boneInfo_v & blist`.
func G2_RemoveRedundantBoneOverrides() -> Never {
    // TODO: Port G2_RemoveRedundantBoneOverrides
    portMissing("G2_RemoveRedundantBoneOverrides", source: "oracle/codemp/ghoul2/G2_bones.cpp:4884")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4902
// TODO: Port signature
// Raven wrote: int G2_Get_Bone_Index(CGhoul2Info *ghoul2, const char *boneName)
// No table row for `CGhoul2Info * ghoul2`.
func G2_Get_Bone_Index() -> Never {
    // TODO: Port G2_Get_Bone_Index
    portMissing("G2_Get_Bone_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:4902")
}
