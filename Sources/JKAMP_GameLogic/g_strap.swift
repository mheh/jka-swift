import JKAMP
import JKAShared
import JKAMP_Game

/// Source: oracle/codemp/game/g_strap.c:6
// TODO: Port signature
// Raven wrote: qboolean strap_G2API_GetBoltMatrix(void *ghoul2, const int modelIndex, const int boltIndex, mdxaBone_t *matrix, const vec3_t angles, const vec3_t position, const int frameNum, qhandle_t *modelList, vec3_t scale)
// No table row for `mdxaBone_t * matrix`.
func strap_G2API_GetBoltMatrix() -> Never {
    // TODO: Port strap_G2API_GetBoltMatrix
    portMissing("strap_G2API_GetBoltMatrix", source: "oracle/codemp/game/g_strap.c:6")
}

/// Source: oracle/codemp/game/g_strap.c:12
// TODO: Port signature
// Raven wrote: qboolean strap_G2API_GetBoltMatrix_NoReconstruct(void *ghoul2, const int modelIndex, const int boltIndex, mdxaBone_t *matrix, const vec3_t angles, const vec3_t position, const int frameNum, qhandle_t *modelList, vec3_t scale)
// No table row for `mdxaBone_t * matrix`.
func strap_G2API_GetBoltMatrix_NoReconstruct() -> Never {
    // TODO: Port strap_G2API_GetBoltMatrix_NoReconstruct
    portMissing("strap_G2API_GetBoltMatrix_NoReconstruct", source: "oracle/codemp/game/g_strap.c:12")
}

/// Source: oracle/codemp/game/g_strap.c:18
// TODO: Port signature
// Raven wrote: qboolean strap_G2API_GetBoltMatrix_NoRecNoRot(void *ghoul2, const int modelIndex, const int boltIndex, mdxaBone_t *matrix, const vec3_t angles, const vec3_t position, const int frameNum, qhandle_t *modelList, vec3_t scale)
// No table row for `mdxaBone_t * matrix`.
func strap_G2API_GetBoltMatrix_NoRecNoRot() -> Never {
    // TODO: Port strap_G2API_GetBoltMatrix_NoRecNoRot
    portMissing("strap_G2API_GetBoltMatrix_NoRecNoRot", source: "oracle/codemp/game/g_strap.c:18")
}

/// Source: oracle/codemp/game/g_strap.c:24
func strap_G2API_SetBoneAngles(_ ghoul2: OpaquePointer?, _ modelIndex: Int32, _ boneName: String, _ angles: JKAShared.vec3_t, _ flags: Int32, _ up: Int32, _ right: Int32, _ forward: Int32, _ modelList: UnsafeMutablePointer<Int32>?, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    return trap_G2API_SetBoneAngles(ghoul2, modelIndex, boneName, angles, flags, up, right, forward, modelList, blendTime, currentTime)
}

/// Source: oracle/codemp/game/g_strap.c:31
func strap_G2API_SetBoneAnim(_ ghoul2: OpaquePointer?, _ modelIndex: Int32, _ boneName: String, _ startFrame: Int32, _ endFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ setFrame: Float, _ blendTime: Int32) -> Bool {
    return trap_G2API_SetBoneAnim(ghoul2, modelIndex, boneName, startFrame, endFrame, flags, animSpeed, currentTime, setFrame, blendTime)
}

/// Source: oracle/codemp/game/g_strap.c:37
func strap_G2API_GetBoneAnim(_ ghoul2: OpaquePointer?, _ boneName: String, _ currentTime: Int32, _ currentFrame: inout Float, _ startFrame: inout Int32, _ endFrame: inout Int32, _ flags: inout Int32, _ animSpeed: inout Float, _ modelList: inout Int32, _ modelIndex: Int32) -> Bool {
    return trap_G2API_GetBoneAnim(ghoul2, boneName, currentTime, &currentFrame, &startFrame, &endFrame, &flags, &animSpeed, &modelList, modelIndex)
}

/// Source: oracle/codemp/game/g_strap.c:43
// TODO: Port signature
// Raven wrote: void strap_G2API_SetRagDoll(void *ghoul2, sharedRagDollParams_t *params)
// No table row for `sharedRagDollParams_t * params`.
func strap_G2API_SetRagDoll() -> Never {
    // TODO: Port strap_G2API_SetRagDoll
    portMissing("strap_G2API_SetRagDoll", source: "oracle/codemp/game/g_strap.c:43")
}

/// Source: oracle/codemp/game/g_strap.c:48
// TODO: Port signature
// Raven wrote: void strap_G2API_AnimateG2Models(void *ghoul2, int time, sharedRagDollUpdateParams_t *params)
// No table row for `sharedRagDollUpdateParams_t * params`.
func strap_G2API_AnimateG2Models() -> Never {
    // TODO: Port strap_G2API_AnimateG2Models
    portMissing("strap_G2API_AnimateG2Models", source: "oracle/codemp/game/g_strap.c:48")
}

/// Source: oracle/codemp/game/g_strap.c:53
// TODO: Port signature
// Raven wrote: qboolean strap_G2API_SetBoneIKState(void *ghoul2, int time, const char *boneName, int ikState, sharedSetBoneIKStateParams_t *params)
// No table row for `sharedSetBoneIKStateParams_t * params`.
func strap_G2API_SetBoneIKState() -> Never {
    // TODO: Port strap_G2API_SetBoneIKState
    portMissing("strap_G2API_SetBoneIKState", source: "oracle/codemp/game/g_strap.c:53")
}

/// Source: oracle/codemp/game/g_strap.c:58
// TODO: Port signature
// Raven wrote: qboolean strap_G2API_IKMove(void *ghoul2, int time, sharedIKMoveParams_t *params)
// No table row for `sharedIKMoveParams_t * params`.
func strap_G2API_IKMove() -> Never {
    // TODO: Port strap_G2API_IKMove
    portMissing("strap_G2API_IKMove", source: "oracle/codemp/game/g_strap.c:58")
}

/// Source: oracle/codemp/game/g_strap.c:63
// TODO: Port signature
// Raven wrote: void strap_TrueMalloc(void **ptr, int size)
// No table row for `void ** ptr`.
func strap_TrueMalloc() -> Never {
    // TODO: Port strap_TrueMalloc
    portMissing("strap_TrueMalloc", source: "oracle/codemp/game/g_strap.c:63")
}

/// Source: oracle/codemp/game/g_strap.c:68
// TODO: Port signature
// Raven wrote: void strap_TrueFree(void **ptr)
// No table row for `void ** ptr`.
func strap_TrueFree() -> Never {
    // TODO: Port strap_TrueFree
    portMissing("strap_TrueFree", source: "oracle/codemp/game/g_strap.c:68")
}
