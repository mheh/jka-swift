import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_strap.c:6
func strap_G2API_GetBoltMatrix(_ ghoul2: OpaquePointer?, _ modelIndex: Int32, _ boltIndex: Int32, _ matrix: JKAMP.MdxaBone, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNum: Int32, _ modelList: UnsafeMutablePointer<Int32>?, _ scale: inout JKAShared.vec3_t) -> Bool {
    return trap_G2API_GetBoltMatrix(ghoul2, modelIndex, boltIndex, matrix, angles, position, frameNum, modelList, &scale)
}

/// Source: oracle/codemp/game/g_strap.c:12
func strap_G2API_GetBoltMatrix_NoReconstruct(_ ghoul2: OpaquePointer?, _ modelIndex: Int32, _ boltIndex: Int32, _ matrix: JKAMP.MdxaBone, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNum: Int32, _ modelList: UnsafeMutablePointer<Int32>?, _ scale: inout JKAShared.vec3_t) -> Bool {
    return trap_G2API_GetBoltMatrix_NoReconstruct(ghoul2, modelIndex, boltIndex, matrix, angles, position, frameNum, modelList, &scale)
}

/// Source: oracle/codemp/game/g_strap.c:18
func strap_G2API_GetBoltMatrix_NoRecNoRot(_ ghoul2: OpaquePointer?, _ modelIndex: Int32, _ boltIndex: Int32, _ matrix: JKAMP.MdxaBone, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNum: Int32, _ modelList: UnsafeMutablePointer<Int32>?, _ scale: inout JKAShared.vec3_t) -> Bool {
    return trap_G2API_GetBoltMatrix_NoRecNoRot(ghoul2, modelIndex, boltIndex, matrix, angles, position, frameNum, modelList, &scale)
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
func strap_G2API_GetBoneAnim(_ ghoul2: OpaquePointer?, _ boneName: String, _ currentTime: Int32, _ currentFrame: inout Float, _ startFrame: inout Int32, _ endFrame: inout Int32, _ flags: inout Int32, _ animSpeed: inout Float, _ modelList: UnsafeMutablePointer<Int32>?, _ modelIndex: Int32) -> Bool {
    return trap_G2API_GetBoneAnim(ghoul2, boneName, currentTime, &currentFrame, &startFrame, &endFrame, &flags, &animSpeed, modelList, modelIndex)
}

/// Source: oracle/codemp/game/g_strap.c:43
func strap_G2API_SetRagDoll(_ ghoul2: OpaquePointer?, _ params: JKAMP.SharedRagDollParams) {
    trap_G2API_SetRagDoll(ghoul2, params)
}

/// Source: oracle/codemp/game/g_strap.c:48
func strap_G2API_AnimateG2Models(_ ghoul2: OpaquePointer?, _ time: Int32, _ params: JKAMP.SharedRagDollUpdateParams) {
    trap_G2API_AnimateG2Models(ghoul2, time, params)
}

/// Source: oracle/codemp/game/g_strap.c:53
func strap_G2API_SetBoneIKState(_ ghoul2: OpaquePointer?, _ time: Int32, _ boneName: String?, _ ikState: Int32, _ params: JKAMP.SharedSetBoneIKStateParams?) -> Bool {
    return trap_G2API_SetBoneIKState(ghoul2, time, boneName, ikState, params)
}

/// Source: oracle/codemp/game/g_strap.c:58
func strap_G2API_IKMove(_ ghoul2: OpaquePointer?, _ time: Int32, _ params: JKAMP.SharedIKMoveParams) -> Bool {
    return trap_G2API_IKMove(ghoul2, time, params)
}

/// Source: oracle/codemp/game/g_strap.c:63
func strap_TrueMalloc(_ ptr: inout OpaquePointer?, _ size: Int32) {
    trap_TrueMalloc(&ptr, size)
}

/// Source: oracle/codemp/game/g_strap.c:68
func strap_TrueFree(_ ptr: inout OpaquePointer?) {
    trap_TrueFree(&ptr)
}
