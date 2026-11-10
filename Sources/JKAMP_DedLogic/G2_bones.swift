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
var tempDependents: Slots<Int32> { world.storage.tempDependents }

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
    if index != -1 {
        if (blist[index].flags & BONE_ANGLES_RAGDOLL) != 0 {
            return true // don't accept any calls on ragdoll bones
        }
    }

    // did we find it?
    if index != -1 {
        // check the flags first - if it's still being used Do NOT remove it
        if blist[index].flags == 0 {

            // set this bone to not used
            blist[index].boneNumber = -1

            var newSize = blist.count
            // now look through the list from the back and see if there is a block of -1's we can resize off the end of the list
            var i = blist.count - 1
            while i > -1 {
                if blist[i].boneNumber == -1 {
                    newSize = i
                }
                // once we hit one that isn't a -1, we are done.
                else {
                    break
                }
                i -= 1
            }
            // do we need to resize?
            if newSize != blist.count {
                // yes, so lets do it
                blist.removeSubrange(newSize...)
            }

            return true
        }
    }

//	assert(0);
    // no
    return false
}

// given a bone number, see if there is an override bone in the bone list
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:196
func G2_Find_Bone_In_List(_ blist: inout [boneInfo_t], _ boneNum: Int32) -> Int32 {
    var i: Int32 = 0

    // look through entire list
    while i < blist.count {
        if blist[i].boneNumber == boneNum {
            return i
        }
        i += 1
    }
    return -1
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:212
func G2_Stop_Bone_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ flags: Int32) -> Bool {
    // did we find it?
    if index != -1 {
        blist[index].flags &= ~(flags)
        // try and remove this bone if we can
        return G2_Remove_Bone_Index(&blist, index)
    }

    return false
}

// generate a matrix for a given bone given some new angles for it.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:228
func G2_Generate_Matrix(_ mod: Model?, _ blist: inout [boneInfo_t], _ index: Int32, _ angles: JKAShared.vec3_t, _ flags: Int32, _ up: JKAMP.Eorientations, _ left: JKAMP.Eorientations, _ forward: JKAMP.Eorientations) {
    // TODO: Port G2_Generate_Matrix
    portMissing("G2_Generate_Matrix", source: "oracle/codemp/ghoul2/G2_bones.cpp:228")
}

// Given a model handle, and a bone name, we want to remove this bone from the bone override list
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:421
func G2_Remove_Bone(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String) -> Bool {
    let index: Int32

    index = G2_Find_Bone(ghlInfo!.animModel!, &blist, boneName)

    return G2_Remove_Bone_Index(&blist, index)
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:435
func G2_Set_Bone_Angles_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ angles: JKAShared.vec3_t, _ flags: Int32, _ yaw: JKAMP.Eorientations, _ pitch: JKAMP.Eorientations, _ roll: JKAMP.Eorientations, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
    if (index < 0 || index >= blist.count) || (blist[index].boneNumber == -1) {
        // we are attempting to set a bone override that doesn't exist
        return false
    }

    if index != -1 {
        if (blist[index].flags & BONE_ANGLES_RAGDOLL) != 0 {
            return true // don't accept any calls on ragdoll bones
        }
    }

    if (flags & (BONE_ANGLES_PREMULT | BONE_ANGLES_POSTMULT)) != 0 {
        // you CANNOT call this with an index with these kinds of bone overrides - we need the model details for these kinds of bone angle overrides
        return false
    }

    // yes, so set the angles and flags correctly
    blist[index].flags &= ~(BONE_ANGLES_TOTAL)
    blist[index].flags |= flags
    blist[index].boneBlendStart = currentTime
    blist[index].boneBlendTime = blendTime

    G2_Generate_Matrix(nil, &blist, index, angles, flags, yaw, pitch, roll)
    return true

}

// Given a model handle, and a bone name, we want to set angles specifically for overriding
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:477
func G2_Set_Bone_Angles(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ angles: JKAShared.vec3_t, _ flags: Int32, _ up: JKAMP.Eorientations, _ left: JKAMP.Eorientations, _ forward: JKAMP.Eorientations, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    let mod_m: Model?
    let mod_a: Model?

    mod_m = ghlInfo!.currentModel
    mod_a = ghlInfo!.animModel

    var index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)

    // did we find it?
    if index != -1 {
        if (blist[index].flags & BONE_ANGLES_RAGDOLL) != 0 {
            return true // don't accept any calls on ragdoll bones
        }

        // yes, so set the angles and flags correctly
        blist[index].flags &= ~(BONE_ANGLES_TOTAL)
        blist[index].flags |= flags
        blist[index].boneBlendStart = currentTime
        blist[index].boneBlendTime = blendTime

        G2_Generate_Matrix(mod_a, &blist, index, angles, flags, up, left, forward)
        return true
    }

    // no - lets try and add this bone in
    index = G2_Add_Bone(mod_a!, &blist, boneName)

    // did we find a free one?
    if index != -1 {
        // yes, so set the angles and flags correctly
        blist[index].flags &= ~(BONE_ANGLES_TOTAL)
        blist[index].flags |= flags
        blist[index].boneBlendStart = currentTime
        blist[index].boneBlendTime = blendTime

        G2_Generate_Matrix(mod_a, &blist, index, angles, flags, up, left, forward)
        return true
    }
//	assert(0);
    //Jeese, we don't need an assert here too. There's already a warning in G2_Add_Bone if it fails.

    // no
    return false
}

// Given a model handle, and a bone name, we want to set angles specifically for overriding - using a matrix directly
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:536
func G2_Set_Bone_Angles_Matrix_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ matrix: JKAMP.MdxaBone, _ flags: Int32, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32, _ blendTime: Int32, _ currentTime: Int32) -> Bool {

    // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
    if (index < 0 || index >= blist.count) || (blist[index].boneNumber == -1) {
        // we are attempting to set a bone override that doesn't exist
        return false
    }
    if index != -1 {
        if (blist[index].flags & BONE_ANGLES_RAGDOLL) != 0 {
            return true // don't accept any calls on ragdoll bones
        }
    }
    // yes, so set the angles and flags correctly
    blist[index].flags &= ~(BONE_ANGLES_TOTAL)
    blist[index].flags |= flags
    blist[index].boneBlendStart = currentTime
    blist[index].boneBlendTime = blendTime

    blist[index].matrix.copy(from: matrix)
    blist[index].newMatrix.copy(from: matrix)
    return true

}

// Given a model handle, and a bone name, we want to set angles specifically for overriding - using a matrix directly
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:567
func G2_Set_Bone_Angles_Matrix(_ fileName: String, _ blist: inout [boneInfo_t], _ boneName: String, _ matrix: JKAMP.MdxaBone, _ flags: Int32, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    let mod_m: Model?
    if fileName.isEmpty {
        mod_m = R_GetModelByHandle(modelList![modelIndex])
    } else {
        mod_m = R_GetModelByHandle(RE_RegisterModel(fileName))
    }
    let mod_a = R_GetModelByHandle(mod_m!.mdxm!.animIndex)
    var index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)

    if index != -1 {
        if (blist[index].flags & BONE_ANGLES_RAGDOLL) != 0 {
            return true // don't accept any calls on ragdoll bones
        }
    }

    // did we find it?
    if index != -1 {
        // yes, so set the angles and flags correctly
        blist[index].flags &= ~(BONE_ANGLES_TOTAL)
        blist[index].flags |= flags

        blist[index].matrix.copy(from: matrix)
        blist[index].newMatrix.copy(from: matrix)
        return true
    }

    // no - lets try and add this bone in
    index = G2_Add_Bone(mod_a!, &blist, boneName)

    // did we find a free one?
    if index != -1 {
        // yes, so set the angles and flags correctly
        blist[index].flags &= ~(BONE_ANGLES_TOTAL)
        blist[index].flags |= flags

        blist[index].matrix.copy(from: matrix)
        blist[index].newMatrix.copy(from: matrix)
        return true
    }

    // no
    return false
}

// given a model, bone name, a bonelist, a start/end frame number, a anim speed and some anim flags, set up or modify an existing bone entry for a new set of anims
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:625
func G2_Set_Bone_Anim_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ startFrame: Int32, _ endFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ setFrame: Float, _ blendTime: Int32, _ numFrames: Int32) -> Bool {
    var modFlags: Int32 = flags

    // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
    if (index < 0 || index >= blist.count) || (blist[index].boneNumber == -1) {
        // we are attempting to set a bone override that doesn't exist
        return false
    }

    if index != -1 {
        if (blist[index].flags & BONE_ANGLES_RAGDOLL) != 0 {
            return true // don't accept any calls on ragdoll bones
        }

        //mark it for needing a transform for the cached trace transform stuff
        blist[index].flags |= BONE_NEED_TRANSFORM
    }

    if (flags & BONE_ANIM_BLEND) != 0 {
        var currentFrame: Float = 0
        var animSpeed: Float = 0
        var startFrame: Int32 = 0
        var endFrame: Int32 = 0
        var flags: Int32 = 0
        // figure out where we are now
        if G2_Get_Bone_Anim_Index(&blist, index, currentTime, &currentFrame, &startFrame, &endFrame, &flags, &animSpeed, nil, numFrames) {
            if blist[index].blendStart == currentTime {	//we're replacing a blend in progress which hasn't started
                // set the amount of time it's going to take to blend this anim with the last frame of the last one
                blist[index].blendTime = blendTime
            } else {
                if animSpeed < 0.0 {
                    blist[index].blendFrame = floor(currentFrame)
                    blist[index].blendLerpFrame = Int32(floor(currentFrame))
                } else {
                    blist[index].blendFrame = currentFrame
                    blist[index].blendLerpFrame = Int32(currentFrame + 1)

                    // cope with if the lerp frame is actually off the end of the anim
                    if blist[index].blendFrame >= endFrame {
                        // we only want to lerp with the first frame of the anim if we are looping
                        if (blist[index].flags & BONE_ANIM_OVERRIDE_LOOP) != 0 {
                            blist[index].blendFrame = Float(startFrame)
                        }
                        // if we intend to end this anim or freeze after this, then just keep on the last frame
                        else {
                        //	assert(endFrame>0);
                            if endFrame <= 0 {
                                blist[index].blendLerpFrame = 0
                            } else {
                                blist[index].blendFrame = Float(endFrame - 1)
                            }
                        }
                    }

                    // cope with if the lerp frame is actually off the end of the anim
                    if blist[index].blendLerpFrame >= endFrame {
                        // we only want to lerp with the first frame of the anim if we are looping
                        if (blist[index].flags & BONE_ANIM_OVERRIDE_LOOP) != 0 {
                            blist[index].blendLerpFrame = startFrame
                        }
                        // if we intend to end this anim or freeze after this, then just keep on the last frame
                        else {
                        //	assert(endFrame>0);
                            if endFrame <= 0 {
                                blist[index].blendLerpFrame = 0
                            } else {
                                blist[index].blendLerpFrame = endFrame - 1
                            }
                        }
                    }
                }
                // set the amount of time it's going to take to blend this anim with the last frame of the last one
                blist[index].blendTime = blendTime
                blist[index].blendStart = currentTime

            }
        }
        // hmm, we weren't animating on this bone. In which case disable the blend
        else {
            blist[index].blendLerpFrame = 0
            blist[index].blendFrame = 0
            blist[index].blendTime = 0
            modFlags &= ~(BONE_ANIM_BLEND)
        }
    } else {
        blist[index].blendLerpFrame = 0
        blist[index].blendFrame = 0
        blist[index].blendStart = 0
        blist[index].blendTime = 0
        // we aren't blending, so remove the option to do so
        modFlags &= ~BONE_ANIM_BLEND
    }
    // yes, so set the anim data and flags correctly
    blist[index].endFrame = endFrame
    blist[index].startFrame = startFrame
    blist[index].animSpeed = animSpeed
    blist[index].pauseTime = 0
    // start up the animation:)
    if setFrame != -1 {
        // Port-note: With an animation speed of 0, Raven converts an infinite or NaN start time to `int`, which C leaves undefined.
        // The body saturates the value and reads a NaN as 0, the conversion of truncateToInt in q_math.swift.
        blist[index].startTime = truncateToInt(Double(currentTime) - ((Double(setFrame - Float(startFrame)) * 50.0) / Double(animSpeed)))
        blist[index].lastTime = blist[index].startTime
    } else {
        blist[index].startTime = currentTime
        blist[index].lastTime = blist[index].startTime
    }
    blist[index].flags &= ~(BONE_ANIM_TOTAL)
    if blist[index].flags < 0 {
        blist[index].flags = 0
    }
    blist[index].flags |= modFlags

    return true

}

// given a model, bone name, a bonelist, a start/end frame number, a anim speed and some anim flags, set up or modify an existing bone entry for a new set of anims
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:815
func G2_Set_Bone_Anim(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ startFrame: Int32, _ endFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ setFrame: Float, _ blendTime: Int32) -> Bool {
    let mod_a = ghlInfo!.animModel

    var index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)
    if index == -1 {
        index = G2_Add_Bone(mod_a!, &blist, boneName)
    }

    if index != -1 {
        if (blist[index].flags & BONE_ANGLES_RAGDOLL) != 0 {
            return true // don't accept any calls on ragdoll bones
        }
    }

    if index != -1 {
        return G2_Set_Bone_Anim_Index(&blist, index, startFrame, endFrame, flags, animSpeed, currentTime, setFrame, blendTime, ghlInfo!.aHeader!.numFrames)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:849
func G2_Get_Bone_Anim_Range(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ startFrame: inout Int32, _ endFrame: inout Int32) -> Bool {
    let mod_a = ghlInfo!.animModel
    let index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)

    // did we find it?
    if index != -1 {
        // are we an animating bone?
        if (blist[index].flags & (BONE_ANIM_OVERRIDE_LOOP | BONE_ANIM_OVERRIDE)) != 0 {
            startFrame = blist[index].startFrame
            endFrame = blist[index].endFrame
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:872
func G2_Get_Bone_Anim_Index(_ blist: inout [boneInfo_t], _ index: Int32, _ currentTime: Int32, _ currentFrame: inout Float, _ startFrame: inout Int32, _ endFrame: inout Int32, _ flags: inout Int32, _ retAnimSpeed: inout Float, _ modelList: Slots<qhandle_t>?, _ numFrames: Int32) -> Bool {
    // Port-note: G2_TimingModel has a signature marker, so the body cannot call it.
    // TODO: Port G2_Get_Bone_Anim_Index
    portMissing("G2_Get_Bone_Anim_Index", source: "oracle/codemp/ghoul2/G2_bones.cpp:872")
}

// given a model, bonelist and bonename, return the current frame, startframe and endframe of the current animation
// NOTE if we aren't running an animation, then qfalse is returned
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:905
func G2_Get_Bone_Anim(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ currentTime: Int32, _ currentFrame: inout Float, _ startFrame: inout Int32, _ endFrame: inout Int32, _ flags: inout Int32, _ retAnimSpeed: inout Float, _ modelList: Slots<qhandle_t>?, _ modelIndex: Int32) -> Bool {
    let mod_a = ghlInfo!.animModel

    var index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)

    if index == -1 {
        index = G2_Add_Bone(mod_a!, &blist, boneName)

        if index == -1 {
            return false
        }
    }

    if G2_Get_Bone_Anim_Index(&blist, index, currentTime, &currentFrame, &startFrame, &endFrame, &flags, &retAnimSpeed, modelList, ghlInfo!.aHeader!.numFrames) {
        return true
    }

    return false
}

// given a model, bonelist and bonename, lets pause an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:936
func G2_Pause_Bone_Anim(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String, _ currentTime: Int32) -> Bool {
    let mod_a = ghlInfo!.animModel

    let index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)

    // did we find it?
    if index != -1 {
        // are we pausing or un pausing?
        if blist[index].pauseTime != 0 {
            var startFrame: Int32 = 0
            var endFrame: Int32 = 0
            var flags: Int32 = 0
            var currentFrame: Float = 0
            var animSpeed: Float = 0

            // Swift refuses a read of `blist` in the call that passes it `inout`, so the pause time is a local.
            let pauseTime = blist[index].pauseTime
            // figure out what frame we are on now
            G2_Get_Bone_Anim(ghlInfo, &blist, boneName, pauseTime, &currentFrame, &startFrame, &endFrame, &flags, &animSpeed, nil, 0)
            // reset start time so we are actually on this frame right now
            G2_Set_Bone_Anim(ghlInfo, &blist, boneName, startFrame, endFrame, flags, animSpeed, currentTime, currentFrame, 0)
            // no pausing anymore
            blist[index].pauseTime = 0
        }
        // ahh, just pausing, the easy bit
        else {
            blist[index].pauseTime = currentTime
        }

        return true
    }

    return false
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:971
func G2_IsPaused(_ fileName: String, _ blist: inout [boneInfo_t], _ boneName: String) -> Bool {
    let mod_m = R_GetModelByHandle(RE_RegisterModel(fileName))
    let mod_a = R_GetModelByHandle(mod_m!.mdxm!.animIndex)
    let index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)

    // did we find it?
    if index != -1 {
        // are we paused?
        if blist[index].pauseTime != 0 {
            // yup. paused.
            return true
        }
        return false
    }

    return false
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:993
func G2_Stop_Bone_Anim_Index(_ blist: inout [boneInfo_t], _ index: Int32) -> Bool {

    // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
    if (index < 0 || index >= blist.count) || (blist[index].boneNumber == -1) {
        // we are attempting to set a bone override that doesn't exist
        return false
    }

    blist[index].flags &= ~(BONE_ANIM_TOTAL)
    // try and remove this bone if we can
    return G2_Remove_Bone_Index(&blist, index)
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1009
func G2_Stop_Bone_Anim(_ fileName: String, _ blist: inout [boneInfo_t], _ boneName: String) -> Bool {
    let mod_m = R_GetModelByHandle(RE_RegisterModel(fileName))
    let mod_a = R_GetModelByHandle(mod_m!.mdxm!.animIndex)
    let index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)

    // did we find it?
    if index != -1 {
        blist[index].flags &= ~(BONE_ANIM_TOTAL)
        // try and remove this bone if we can
        return G2_Remove_Bone_Index(&blist, index)
    }

    return false
}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1028
func G2_Stop_Bone_Angles_Index(_ blist: inout [boneInfo_t], _ index: Int32) -> Bool {

    // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
    if (index < 0 || index >= blist.count) || (blist[index].boneNumber == -1) {
        // we are attempting to set a bone override that doesn't exist
        return false
    }

    blist[index].flags &= ~(BONE_ANGLES_TOTAL)
    // try and remove this bone if we can
    return G2_Remove_Bone_Index(&blist, index)

}

// given a model, bonelist and bonename, lets stop an anim if it's playing.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1045
func G2_Stop_Bone_Angles(_ fileName: String, _ blist: inout [boneInfo_t], _ boneName: String) -> Bool {
    let mod_m = R_GetModelByHandle(RE_RegisterModel(fileName))
    let mod_a = R_GetModelByHandle(mod_m!.mdxm!.animIndex)
    let index: Int32 = G2_Find_Bone(mod_a!, &blist, boneName)

    // did we find it?
    if index != -1 {
        blist[index].flags &= ~(BONE_ANGLES_TOTAL)
        // try and remove this bone if we can
        return G2_Remove_Bone_Index(&blist, index)
    }

    return false
}

// actually walk the bone list and update each and every bone if we have ended an animation for them.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1065
func G2_Animate_Bone_List(_ ghoul2: CGhoul2Info_v, _ currentTime: Int32, _ index: Int32) {
    // Raven calls only the overload with the CRagDollUpdateParams parameter, at G2_API.cpp:1450, so this overload is dead.
    // TODO: Port G2_Animate_Bone_List
    portMissing("G2_Animate_Bone_List", source: "oracle/codemp/ghoul2/G2_bones.cpp:1065")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1244
private func G2_Generate_MatrixRag(_ blist: inout [boneInfo_t], _ index: Int32) {


    let bone = blist[index]//.sent;

    bone.matrix.copy(from: bone.ragOverrideMatrix)
    blist[index].newMatrix.copy(from: bone.matrix)
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1267
func G2_Find_Bone_Rag(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String) -> Int32 {
    // TODO: Port G2_Find_Bone_Rag
    portMissing("G2_Find_Bone_Rag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1267")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1318
private func G2_Set_Bone_Rag(_ mod_a: MdxaHeader, _ blist: inout [boneInfo_t], _ boneName: String, _ ghoul2: CGhoul2Info, _ scale: JKAShared.vec3_t, _ origin: JKAShared.vec3_t) -> Int32 {
    // Port-note: G2_GetBoneMatrixLow has a signature marker, so the body cannot call it.
    // TODO: Port G2_Set_Bone_Rag
    portMissing("G2_Set_Bone_Rag", source: "oracle/codemp/ghoul2/G2_bones.cpp:1318")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1349
private func G2_Set_Bone_Angles_Rag(_ ghoul2: CGhoul2Info, _ mod_a: MdxaHeader, _ blist: inout [boneInfo_t], _ boneName: String, _ flags: Int32, _ radius: Float, _ angleMin: JKAShared.vec3_t? = nil, _ angleMax: JKAShared.vec3_t? = nil, _ blendTime: Int32 = 500) -> Int32 {
    var index: Int32 = G2_Find_Bone_Rag(ghoul2, &blist, boneName)

    if index == -1 {
        index = G2_Add_Bone(ghoul2.animModel!, &blist, boneName)
    }
    if index != -1 {
        let bone = blist[index]
        bone.flags &= ~(BONE_ANGLES_TOTAL)
        bone.flags |= BONE_ANGLES_RAGDOLL
        if (flags & RAG_PCJ) != 0 {
            if (flags & RAG_PCJ_POST_MULT) != 0 {
                bone.flags |= BONE_ANGLES_POSTMULT
            } else if (flags & RAG_PCJ_MODEL_ROOT) != 0 {
                bone.flags |= BONE_ANGLES_PREMULT
//				bone.flags |= BONE_ANGLES_POSTMULT;
            } else {
                assert(false, "Invalid RAG PCJ\n")
            }
        }
        bone.ragStartTime = G2API_GetTime(0)
        bone.boneBlendStart = bone.ragStartTime
        bone.boneBlendTime = blendTime
        bone.radius = radius
        bone.weight = 1.0

        //init the others to valid values
        bone.epGravFactor = 0
        bone.epVelocity = vec3_t()
        bone.solidCount = 0
        bone.physicsSettled = false
        bone.snapped = false

        bone.parentBoneIndex = -1

        bone.offsetRotation = 0.0

        bone.overGradSpeed = 0.0
        bone.overGoalSpot = vec3_t()
        bone.hasOverGoal = false
        bone.hasAnimFrameMatrix = -1

//		bone.weight=pow(radius,1.7f); //cubed was too harsh
//		bone.weight=radius*radius*radius;
        if angleMin != nil && angleMax != nil {
            bone.minAngles = angleMin!
            bone.maxAngles = angleMax!
        } else {
            bone.minAngles = bone.currentAngles // I guess this isn't a rag pcj then
            bone.maxAngles = bone.currentAngles
        }
        if bone.lastTimeUpdated == 0 {
            bone.ragOverrideMatrix.copy(from: id_G2_Set_Bone_Angles_Rag)
            bone.anglesOffset = vec3_t()
            bone.positionOffset = vec3_t()
            bone.velocityEffector = vec3_t()  // this is actually a velocity now
            bone.velocityRoot = vec3_t()  // this is actually a velocity now
            bone.lastPosition = vec3_t()
            bone.lastShotDir = vec3_t()
            bone.lastContents = 0
            // if this is non-zero, we are in a dynamic state
            bone.firstCollisionTime = bone.ragStartTime
            // if this is non-zero, we are in a settling state
            bone.restTime = 0
            // if they are both zero, we are in a settled state

            bone.firstTime = 0

            bone.RagFlags = flags
            bone.DependentRagIndexMask = 0

            G2_Generate_MatrixRag(&blist, index) // set everything to th id

            if (flags & RAG_PCJ_MODEL_ROOT) != 0 ||
                (flags & RAG_PCJ_PELVIS) != 0 ||
                (flags & RAG_PCJ) == 0 {
                bone.currentAngles = vec3_t()
            } else {
                var k: Int32 = 0
                while k < 3 {
                    var scalar = flrand(-1.0, 1.0)
                    scalar *= flrand(-1.0, 1.0) * flrand(-1.0, 1.0)
                    // this is a heavily central distribution
                    // center it on .5 (and make it small)
                    scalar *= 0.5
                    scalar += 0.5

                    bone.currentAngles[k] = (bone.minAngles[k] - bone.maxAngles[k]) * scalar + bone.maxAngles[k]
                    k += 1
                }
            }
//			VectorClear(bone.currentAngles);
            bone.lastAngles = bone.currentAngles
        }
    }
    return index
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1491
private func G2_RagDollMatchPosition() {
    haveDesiredPelvisOffset = false
    var i: Int32 = 0
    while i < numRags {
        let bone = ragBoneData[i]!
        let e = ragEffectors[i]

        // Raven's `desiredPos` is a reference to `e.desiredOrigin`.
        // we will save this

        if 0 != 0 && (bone.RagFlags & RAG_PCJ_PELVIS) != 0 {
            // just move to quake origin
            e.desiredOrigin = bone.originalOrigin
            desiredPelvisOffset = e.desiredOrigin - e.currentOrigin // last arg is dest
            haveDesiredPelvisOffset = true
            bone.lastPosition = e.currentOrigin // last arg is dest
            i += 1
            continue
        }

        if (bone.RagFlags & RAG_EFFECTOR) == 0 {
            i += 1
            continue
        }
        e.desiredOrigin = bone.originalOrigin
        e.desiredDirection = e.desiredOrigin - e.currentOrigin
        bone.lastPosition = e.currentOrigin // last arg is dest
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1522
func G2_Set_Bone_Anim_No_BS(_ ghoul2: CGhoul2Info, _ mod: MdxaHeader, _ blist: inout [boneInfo_t], _ boneName: String, _ argStartFrame: Int32, _ argEndFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ setFrame: Float, _ blendTime: Int32, _ creationID: Int32, _ resetBonemap: Bool = true) -> Bool {
    var index: Int32 = G2_Find_Bone_Rag(ghoul2, &blist, boneName)
    var modFlags: Int32 = flags

    let startFrame: Int32 = argStartFrame
    let endFrame: Int32 = argEndFrame

    if index != -1 {
        blist[index].blendLerpFrame = 0
        blist[index].blendFrame = 0
        blist[index].blendStart = 0
        blist[index].blendTime = 0
        modFlags &= ~(BONE_ANIM_BLEND)

        blist[index].endFrame = endFrame
        blist[index].startFrame = startFrame
        blist[index].animSpeed = animSpeed
        blist[index].pauseTime = 0
//		blist[index].boneMap = NULL;
//		blist[index].lastTime = blist[index].startTime = (currentTime - (((setFrame - (float)startFrame) * 50.0)/ animSpeed));
        blist[index].flags &= ~(BONE_ANIM_TOTAL)
        blist[index].flags |= modFlags

        return true
    }

    index = G2_Add_Bone(ghoul2.animModel!, &blist, boneName)

    if index != -1 {
        blist[index].blendLerpFrame = 0
        blist[index].blendFrame = 0
        blist[index].blendTime = 0
        modFlags &= ~(BONE_ANIM_BLEND)
        blist[index].endFrame = endFrame
        blist[index].startFrame = startFrame
        blist[index].animSpeed = animSpeed
        blist[index].pauseTime = 0
//		blist[index].boneMap = NULL;
//		blist[index].lastTime = blist[index].startTime = (currentTime - (((setFrame - (float)startFrame) * 50.0f)/ animSpeed));
        blist[index].flags &= ~(BONE_ANIM_TOTAL)
        blist[index].flags |= modFlags

        return true
    }

    return false
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1573
func G2_ResetRagDoll(_ ghoul2V: CGhoul2Info_v) {
    var model: Int32 = 0

    while model < ghoul2V.size() {
        if ghoul2V[model].mModelindex != -1 {
            break
        }
        model += 1
    }

    if model == ghoul2V.size() {
        return
    }

    let ghoul2 = ghoul2V[model]

    if (ghoul2.mFlags & GHOUL2_RAG_STARTED) == 0 { //no use in doing anything if we aren't ragging
        return
    }

    // Raven's `blist` is a reference to `ghoul2.mBlist`.
    //Eh, screw it. Ragdoll does a lot of terrible things to the bones that probably aren't directly reversible, so just reset it all.
    G2_Init_Bone_List(&ghoul2.mBlist)
    ghoul2.mFlags &= ~(GHOUL2_RAG_PENDING | GHOUL2_RAG_DONE | GHOUL2_RAG_STARTED)
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1622
func G2_SetRagDoll(_ ghoul2V: CGhoul2Info_v, _ parms: CRagDollParams?) {
    // TODO: Port G2_SetRagDoll
    portMissing("G2_SetRagDoll", source: "oracle/codemp/ghoul2/G2_bones.cpp:1622")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2040
func G2_SetRagDollBullet(_ ghoul2: CGhoul2Info, _ rayStart: JKAShared.vec3_t, _ hit: JKAShared.vec3_t) {
    // Raven calls this function from no file of either tree, so it is dead.
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
    // Port-note: G2_GetBoneBasepose has a signature marker, so the body cannot call it.
    // TODO: Port G2_RagDollSetup
    portMissing("G2_RagDollSetup", source: "oracle/codemp/ghoul2/G2_bones.cpp:2254")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2403
private func G2_RagDoll(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ params: CRagDollUpdateParams?, _ curTime: Int32) {
    // Port-note: G2_RagSetState has a signature marker, so the body cannot call it.
    // TODO: Port G2_RagDoll
    portMissing("G2_RagDoll", source: "oracle/codemp/ghoul2/G2_bones.cpp:2403")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2580
private func G2_Get_Bone_Name(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneNum: Int32) -> String {
    // The callers sit under _DEBUG_BONE_NAMES and the #ifndef DEDICATED arm of G2_BoneSnap, which the build drops, so it is dead.
    // TODO: Port G2_Get_Bone_Name
    portMissing("G2_Get_Bone_Name", source: "oracle/codemp/ghoul2/G2_bones.cpp:2580")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2609
private func G2_RagDollCurrentPosition(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ frameNum: Int32, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ scale: JKAShared.vec3_t) {
    // Port-note: G2_GetBoneMatrixLow has a signature marker, so the body cannot call it.
    // TODO: Port G2_RagDollCurrentPosition
    portMissing("G2_RagDollCurrentPosition", source: "oracle/codemp/ghoul2/G2_bones.cpp:2609")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2683
func Rag_Trace(_ results: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ passEntityNum: Int32, _ contentmask: Int32, _ eG2TraceType: EG2_Collision, _ useLod: Int32) {
    results.entityNum = ENTITYNUM_NONE
    //SV_Trace(results, start, mins, maxs, end, passEntityNum, contentmask, eG2TraceType, useLod);
    CM_BoxTrace(results, start, end, mins, maxs, 0, contentmask, 0)
    results.entityNum = Double(results.fraction) != 1.0 ? ENTITYNUM_WORLD : ENTITYNUM_NONE
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2729
private func G2_BoneOnGround(_ org: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ ignoreNum: Int32) -> Bool {
    return Trace.scratch { tr -> Bool in
        var gSpot: vec3_t

        gSpot = org
        gSpot[2] -= 1.0 //seems reasonable to me

        Rag_Trace(tr, org, mins, maxs, gSpot, ignoreNum, RAG_MASK, G2_NOCOLLIDE, 0)

        if tr.fraction != 1.0 && tr.startsolid == 0 && tr.allsolid == 0 { //not in solid, and hit something. Guess it's ground.
            return true
        }

        return false
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2747
private func G2_ApplyRealBonePhysics(_ bone: boneInfo_t, _ e: RagEffector, _ params: CRagDollUpdateParams?, _ goalSpot: inout JKAShared.vec3_t, _ testMins: JKAShared.vec3_t, _ testMaxs: JKAShared.vec3_t, _ gravity: Float, _ mass: Float, _ bounce: Float) -> Bool {
    return Trace.scratch { tr -> Bool in
        var projectedOrigin = vec3_t()
        var vNorm = vec3_t()
        var ground: vec3_t
        let velScaling: Float = 0.1
        var vTotal: Float = 0.0
        var boneOnGround = false

        if bone.physicsSettled { //then we have no need to continue
            return true
        }

        if gravity != 0 { //factor it in before we do anything.
            ground = e.currentOrigin
            ground[2] -= 1.0

            Rag_Trace(tr, e.currentOrigin, testMins, testMaxs, ground, params!.me, RAG_MASK, G2_NOCOLLIDE, 0)

            if tr.entityNum == ENTITYNUM_NONE {
                boneOnGround = false
            } else {
                boneOnGround = true
            }

            if !boneOnGround {
                if params!.velocity[2] == 0 { //only increase gravitational pull once the actual entity is still
                    bone.epGravFactor += gravity
                }

                if bone.epGravFactor > MAX_GRAVITY_PULL { //cap it off if needed
                    bone.epGravFactor = Float(MAX_GRAVITY_PULL)
                }

                bone.epVelocity[2] -= bone.epGravFactor
            } else { //if we're sitting on something then reset the gravity factor.
                bone.epGravFactor = 0
            }
        } else {
            boneOnGround = G2_BoneOnGround(e.currentOrigin, testMins, testMaxs, params!.me)
        }

        if bone.epVelocity[0] == 0 && bone.epVelocity[1] == 0 && bone.epVelocity[2] == 0 { //nothing to do if we have no velocity even after gravity.
            goalSpot = e.currentOrigin
            return true
        }

        //get the projected origin based on velocity.
        _VectorMA(e.currentOrigin, velScaling, bone.epVelocity, &projectedOrigin)

        //scale it down based on mass
        bone.epVelocity = bone.epVelocity * (1.0 - mass)

        vNorm = bone.epVelocity
        vTotal = VectorNormalize(&vNorm)

        if vTotal < 1 && boneOnGround { //we've pretty much stopped moving anyway, just clear it out then.
            bone.epVelocity = vec3_t()
            bone.epGravFactor = 0
            goalSpot = e.currentOrigin
            return true
        }

        Rag_Trace(tr, e.currentOrigin, testMins, testMaxs, projectedOrigin, params!.me, RAG_MASK, G2_NOCOLLIDE, 0)

        if tr.startsolid != 0 || tr.allsolid != 0 { //can't go anywhere from here
            return false
        }

        //Go ahead and set it to the trace endpoint regardless of what it hit
        goalSpot = tr.endpos

        if tr.fraction == 1.0 { //Nothing was in the way.
            return true
        }

        if bounce != 0 {
            vTotal *= bounce //scale it by bounce

            vNorm = tr.plane.normal * vTotal //scale the trace plane normal by the bounce factor

            if vNorm[2] > 0 {
                bone.epGravFactor -= vNorm[2] * (1.0 - mass) //The lighter it is the more gravity will be reduced by bouncing vertically.
                if bone.epGravFactor < 0 {
                    bone.epGravFactor = 0
                }
            }

            bone.epVelocity = bone.epVelocity + vNorm //add it into the existing velocity.

            //I suppose it could be sort of neat to make a game callback here to actual do stuff
            //when bones slam into things. But it could be slow too.
            /*
            if (tr.entityNum != ENTITYNUM_NONE && ent->touch)
            { //then call the touch function
                ent->touch(ent, &g_entities[tr.entityNum], &tr);
            }
            */
        } else { //if no bounce, kill when it hits something.
            bone.epVelocity[0] = 0
            bone.epVelocity[1] = 0

            if gravity == 0 {
                bone.epVelocity[2] = 0
            }
        }
        return true
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3377
private func G2_RagGetWorldAnimMatrix(_ ghoul2: CGhoul2Info, _ bone: boneInfo_t, _ params: CRagDollUpdateParams?, _ retMatrix: JKAMP.MdxaBone) {
    // Raven's two static matrices are scratch, because each call writes them before a read.
    MdxaBone.scratch { trueBaseMatrix in
        MdxaBone.scratch { baseBoneMatrix in

            //get matrix for the settleFrame to use as an ideal
            G2_RagGetAnimMatrix(ghoul2, bone.boneNumber, trueBaseMatrix, params!.settleFrame)

            G2_RagGetBoneBasePoseMatrixLow(ghoul2, bone.boneNumber, trueBaseMatrix, baseBoneMatrix, params!.scale)

            //Use params to multiply world coordinate/dir matrix into the
            //bone matrix and give us a useable world position
            Multiply_3x4Matrix(retMatrix, worldMatrix, baseBoneMatrix)
        }
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3399
private func G2_RagGetPelvisLumbarOffsets(_ ghoul2: CGhoul2Info, _ params: CRagDollUpdateParams?, _ pos: inout JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t, _ animPos: inout JKAShared.vec3_t, _ animDir: inout JKAShared.vec3_t) {
    // Raven's static matrices `final` and `x` are scratch, because each call writes them before a read.
    // The static pointers `unused1` and `unused2` have no read, so they have no line.
    MdxaBone.scratch { `final` in
        MdxaBone.scratch { x in
            //static vec3_t lumbarPos;

            let boneIndex: Int32 = G2_Find_Bone(ghoul2.animModel!, &ghoul2.mBlist, "pelvis")

            G2_RagGetWorldAnimMatrix(ghoul2, ghoul2.mBlist[boneIndex], params, `final`)
            G2API_GiveMeVectorFromMatrix(`final`, ORIGIN, &animPos)
            G2API_GiveMeVectorFromMatrix(`final`, POSITIVE_X, &animDir)

            //We have the anim matrix pelvis pos now, so get the normal one as well
            //G2_GetRagBoneMatrixLow(ghoul2, boneIndex, x);
            let bolt: Int32 = G2_Add_Bolt(ghoul2, &ghoul2.mBltlist, &ghoul2.mSlist, "pelvis")
            G2_GetBoltMatrixLow(ghoul2, bolt, params!.scale, x)
            Multiply_3x4Matrix(`final`, worldMatrix, x)
            G2API_GiveMeVectorFromMatrix(`final`, ORIGIN, &pos)
            G2API_GiveMeVectorFromMatrix(`final`, POSITIVE_X, &dir)

            /*
            //now get lumbar
            boneIndex = G2_Find_Bone(ghoul2.animModel, ghoul2.mBlist, "lower_lumbar");
            assert(boneIndex != -1);

            G2_RagGetWorldAnimMatrix(ghoul2, ghoul2.mBlist[boneIndex], params, final);
            G2API_GiveMeVectorFromMatrix(&final, ORIGIN, lumbarPos);

            VectorSubtract(animPos, lumbarPos, animDir);
            VectorNormalize(animDir);

            //We have the anim matrix lumbar dir now, so get the normal one as well
            G2_GetBoneMatrixLow(ghoul2, boneIndex, params->scale, final, unused1, unused2);
            G2API_GiveMeVectorFromMatrix(&final, ORIGIN, lumbarPos);

            VectorSubtract(pos, lumbarPos, dir);
            VectorNormalize(dir);
            */
        }
    }
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
    return
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:3970
private func G2_RagDollSolve(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ decay: Float, _ frameNum: Int32, _ currentOrg: JKAShared.vec3_t, _ limitAngles: Bool, _ params: CRagDollUpdateParams? = nil) {
    // TODO: Port G2_RagDollSolve
    portMissing("G2_RagDollSolve", source: "oracle/codemp/ghoul2/G2_bones.cpp:3970")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4257
private func G2_IKReposition(_ currentOrg: JKAShared.vec3_t, _ params: CRagDollUpdateParams?) {
    var i: Int32

    i = 0
    while i < numRags {
        let bone = ragBoneData[i]!
        let e = ragEffectors[i]

        if (bone.RagFlags & RAG_EFFECTOR) == 0 {
            i += 1
            continue
        }

        //Most effectors are not going to be PCJ, so this is not appplicable.
        //The actual desired angle of the PCJ is factored around the desired
        //directions of the effectors which are dependant on it.
        /*
        if (!(bone.RagFlags & RAG_PCJ_IK_CONTROLLED))
        {
            continue;
        }
        */

        var k: Int32
        let magicFactor12: Float = 0.8 // dampening of velocity applied
        let magicFactor16: Float = 10.0 // effect multiplier of velocity applied
        k = 0
        while k < 3 {
            e.desiredDirection[k] = bone.ikPosition[k] - e.currentOrigin[k]
            e.desiredDirection[k] += magicFactor16 * bone.velocityEffector[k]
            e.desiredDirection[k] += flrand(-0.75, 0.75) * flrand(-0.75, 0.75)
            bone.velocityEffector[k] *= magicFactor12
            k += 1
        }
        bone.lastPosition = e.currentOrigin // last arg is dest
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4297
private func G2_IKSolve(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ decay: Float, _ frameNum: Int32, _ currentOrg: JKAShared.vec3_t, _ limitAngles: Bool) {
    // TODO: Port G2_IKSolve
    portMissing("G2_IKSolve", source: "oracle/codemp/ghoul2/G2_bones.cpp:4297")
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4453
private func G2_DoIK(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ params: CRagDollUpdateParams?) {
    var i: Int32

    guard let params else {
        return
    }

    let frameNum: Int32 = G2API_GetTime(0)
    let ghoul2 = ghoul2V[g2Index]

    let decay: Float = 1.0
    let resetOrigin = false
    let anyRendered = false

    let iters: Int32 = 12 //since we don't trace or anything, we can afford this.

    if iters != 0 {
        if !G2_RagDollSetup(ghoul2, frameNum, resetOrigin, params.position, anyRendered) {
            return
        }

        // ok, now our data structures are compact and set up in topological order
        i = 0
        while i < iters {
            G2_RagDollCurrentPosition(ghoul2V, g2Index, frameNum, params.angles, params.position, params.scale)

            G2_IKReposition(params.position, params)

            G2_IKSolve(ghoul2V, g2Index, decay * 2.0, frameNum, params.position, true)
            i += 1
        }
    }

    if params.me != ENTITYNUM_NONE {
        G2_RagDollCurrentPosition(ghoul2V, g2Index, frameNum, params.angles, params.position, params.scale)
    }
}

//rww - cut out the entire non-ragdoll section of this..
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4498
func G2_Animate_Bone_List(_ ghoul2: CGhoul2Info_v, _ currentTime: Int32, _ index: Int32, _ params: CRagDollUpdateParams?) {
    var i: Int32 = 0
    var anyRagDoll = false
    var anyIK = false
    while i < Int32(ghoul2[index].mBlist.count) {
        if ghoul2[index].mBlist[i].boneNumber != -1 {
            if (ghoul2[index].mBlist[i].flags & BONE_ANGLES_RAGDOLL) != 0 {
                if (ghoul2[index].mBlist[i].RagFlags & RAG_PCJ_IK_CONTROLLED) != 0 {
                    anyIK = true
                }
                anyRagDoll = true

                if anyIK && anyRagDoll {
                    break
                }
            }
        }
        i += 1
    }
    if index == 0 && params != nil {
        if anyIK { //we use ragdoll params so we know what our current position, etc. is.
            G2_DoIK(ghoul2, 0, params)
        } else {
            G2_RagDoll(ghoul2, 0, params, currentTime)
        }
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4536
private func G2_Set_Bone_Angles_IK(_ ghoul2: CGhoul2Info, _ mod_a: MdxaHeader?, _ blist: inout [boneInfo_t], _ boneName: String, _ flags: Int32, _ radius: Float, _ angleMin: JKAShared.vec3_t? = nil, _ angleMax: JKAShared.vec3_t? = nil, _ blendTime: Int32 = 500) -> Int32 {
    var index: Int32 = G2_Find_Bone_Rag(ghoul2, &blist, boneName)

    if index == -1 {
        index = G2_Add_Bone(ghoul2.animModel!, &blist, boneName)
    }
    if index != -1 {
        let bone = blist[index]
        bone.flags |= BONE_ANGLES_IK
        bone.flags &= ~BONE_ANGLES_RAGDOLL

        bone.ragStartTime = G2API_GetTime(0)
        bone.radius = radius
        bone.weight = 1.0

        if angleMin != nil && angleMax != nil {
            bone.minAngles = angleMin!
            bone.maxAngles = angleMax!
        } else {
            bone.minAngles = bone.currentAngles // I guess this isn't a rag pcj then
            bone.maxAngles = bone.currentAngles
        }
        if bone.lastTimeUpdated == 0 {
            bone.ragOverrideMatrix.copy(from: id_G2_Set_Bone_Angles_IK)
            bone.anglesOffset = vec3_t()
            bone.positionOffset = vec3_t()
            bone.velocityEffector = vec3_t()  // this is actually a velocity now
            bone.velocityRoot = vec3_t()  // this is actually a velocity now
            bone.lastPosition = vec3_t()
            bone.lastShotDir = vec3_t()
            bone.lastContents = 0
            // if this is non-zero, we are in a dynamic state
            bone.firstCollisionTime = bone.ragStartTime
            // if this is non-zero, we are in a settling state
            bone.restTime = 0
            // if they are both zero, we are in a settled state

            bone.firstTime = 0

            bone.RagFlags = flags
            bone.DependentRagIndexMask = 0

            G2_Generate_MatrixRag(&blist, index) // set everything to th id

            bone.currentAngles = vec3_t()
            bone.lastAngles = bone.currentAngles
        }
    }
    return index
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4609
func G2_InitIK(_ ghoul2V: CGhoul2Info_v, _ parms: SharedRagDollUpdateParams, _ time: Int32, _ mod_a: MdxaHeader?, _ model: Int32) {
    let ghoul2 = ghoul2V[model]
    let curTime = time
    // Raven's `blist` is a reference to `ghoul2.mBlist`.

    G2_GenerateWorldMatrix(parms.angles, parms.position)
    G2_ConstructGhoulSkeleton(ghoul2V, curTime, false, parms.scale)

    // new base anim, unconscious flop
    var pcjFlags: Int32
    //Only need the standard effectors for this.
    pcjFlags = RAG_PCJ | RAG_PCJ_POST_MULT | RAG_EFFECTOR

    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "rhand", pcjFlags, 6.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "lhand", pcjFlags, 6.0)
//	G2_Set_Bone_Angles_IK(ghoul2, mod_a,blist,"rtarsal",pcjFlags,4.0f);
//	G2_Set_Bone_Angles_IK(ghoul2, mod_a,blist,"ltarsal",pcjFlags,4.0f);
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "rtibia", pcjFlags, 4.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "ltibia", pcjFlags, 4.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "rtalus", pcjFlags, 4.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "ltalus", pcjFlags, 4.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "rradiusX", pcjFlags, 6.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "lradiusX", pcjFlags, 6.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "rfemurX", pcjFlags, 10.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "lfemurX", pcjFlags, 10.0)
    G2_Set_Bone_Angles_IK(ghoul2, mod_a, &ghoul2.mBlist, "ceyebrow", pcjFlags, 10.0)
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4663
func G2_SetBoneIKState(_ ghoul2: CGhoul2Info_v, _ time: Int32, _ boneName: String?, _ ikState: Int32, _ params: SharedSetBoneIKStateParams?) -> Bool {
    let mod_a: Model?
    let g2index: Int32 = 0
    let curTime = time
    let g2 = ghoul2[g2index]
    let rmod_a = G2_GetModA(g2)

    // Raven's `blist` is a reference to `g2.mBlist`.
    mod_a = g2.animModel

    if boneName == nil { //null bonename param means it's time to init the ik stuff on this instance
        if ikState == IKS_NONE { //this means we want to reset the IK state completely.. run through the bone list, and reset all the appropriate flags
            var i: Int32 = 0
            while i < g2.mBlist.count { //we can't use this method for ragdoll. However, since we expect them to set their anims/angles again on the PCJ
              //limb after they reset it gameside, it's reasonable for IK bones.
                let bone = g2.mBlist[i]
                if bone.boneNumber != -1 {
                    bone.flags &= ~BONE_ANGLES_RAGDOLL
                    bone.flags &= ~BONE_ANGLES_IK
                    bone.RagFlags = 0
                    bone.lastTimeUpdated = 0
                }
                i += 1
            }
            return true
        }
        assert(params != nil)

        if params == nil {
            return false
        }

        SharedRagDollUpdateParams.scratch { sRDUP in
            sRDUP.me = 0
            sRDUP.angles = params!.angles
            sRDUP.position = params!.origin
            sRDUP.scale = params!.scale
            sRDUP.velocity = vec3_t()
            G2_InitIK(ghoul2, sRDUP, curTime, rmod_a, g2index)
        }
        return true
    }

    if rmod_a == nil || mod_a == nil {
        return false
    }

    var index: Int32 = G2_Find_Bone(mod_a!, &g2.mBlist, boneName!)

    if index == -1 {
        index = G2_Add_Bone(mod_a!, &g2.mBlist, boneName!)
    }

    if index == -1 { //couldn't find or add the bone..
        return false
    }

    let bone = g2.mBlist[index]

    if ikState == IKS_NONE { //remove the bone from the list then, so it has to reinit. I don't think this should hurt anything since
      //we don't store bone index handles gameside anywhere.
        if (bone.flags & BONE_ANGLES_RAGDOLL) == 0 { //you can't set the ik state to none if it's not a rag/ik bone.
            return false
        }
        //bone.flags = 0;
        //G2_Remove_Bone_Index(blist, index);
        //actually, I want to keep it on the rag list, and remove it as an IK bone instead.
        bone.flags &= ~BONE_ANGLES_RAGDOLL
        bone.flags |= BONE_ANGLES_IK
        bone.RagFlags &= ~RAG_PCJ_IK_CONTROLLED
        return true
    }

    //need params if we're not resetting.
    if params == nil {
        assert(false)
        return false
    }

    if (bone.flags & BONE_ANGLES_RAGDOLL) != 0 { //otherwise if the bone is already flagged as rag, then we can't set it again. (non-active ik bones will be BONE_ANGLES_IK, active are considered rag)
        return false
    }
    G2_GenerateWorldMatrix(params!.angles, params!.origin)
    G2_ConstructGhoulSkeleton(ghoul2, curTime, false, params!.scale)

    var pcjFlags: Int32 = RAG_PCJ | RAG_PCJ_IK_CONTROLLED | RAG_PCJ_POST_MULT | RAG_EFFECTOR

    if params!.pcjOverrides != 0 {
        pcjFlags = params!.pcjOverrides
    }

    bone.ikSpeed = 0.4
    bone.ikPosition = vec3_t()

    G2_Set_Bone_Rag(rmod_a!, &g2.mBlist, boneName!, g2, params!.scale, params!.origin)

    let startFrame = params!.startFrame
    let endFrame = params!.endFrame

    if bone.startFrame != startFrame || bone.endFrame != endFrame || params!.forceAnimOnBone { //if it's already on this anim leave it alone, to allow smooth transitions into IK on the current anim if it is so desired.
        G2_Set_Bone_Anim_No_BS(g2, rmod_a!, &g2.mBlist, boneName!, startFrame, endFrame - 1,
            BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND,
            1.0, curTime, Float(startFrame), 150, 0, true)
    }

    G2_ConstructGhoulSkeleton(ghoul2, curTime, false, params!.scale)

    bone.lastTimeUpdated = 0
    G2_Set_Bone_Angles_Rag(g2, rmod_a!, &g2.mBlist, boneName!, pcjFlags, params!.radius, params!.pcjMins, params!.pcjMaxs, params!.blendTime)

    if !G2_RagDollSetup(g2, curTime, true, params!.origin, false) {
        assert(false, "failed to add any rag bones")
        return false
    }

    return true
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4816
func G2_IKMove(_ ghoul2: CGhoul2Info_v, _ time: Int32, _ params: SharedIKMoveParams) -> Bool {
    let g2index: Int32 = 0
    let curTime = time
    let g2 = ghoul2[g2index]

    //rwwFIXMEFIXME: Doing this on all bones at the moment, fix this later?
    if !G2_RagDollSetup(g2, curTime, true, params.origin, false) { //changed models, possibly.
        return false
    }

    var i: Int32 = 0
    while i < numRags {
        let bone = ragBoneData[i]!

        //if (bone.boneNumber == blist[index].boneNumber)
        do {
            bone.ikPosition = params.desiredOrigin
            bone.ikSpeed = params.movementSpeed
        }
        i += 1
    }
    return true
}

// set the bone list to all unused so the bone transformation routine ignores it.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4879
func G2_Init_Bone_List(_ blist: inout [boneInfo_t]) {
    blist.removeAll()
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4884
func G2_RemoveRedundantBoneOverrides(_ blist: inout [boneInfo_t], _ activeBones: Slots<Int32>) {
    var i: Int32

    // walk the surface list, removing surface overrides or generated surfaces that are pointing at surfaces that aren't active anymore
    i = 0
    while i < blist.count {
        if blist[i].boneNumber != -1 {
            if activeBones[blist[i].boneNumber] == 0 {
                blist[i].flags = 0
                G2_Remove_Bone_Index(&blist, i)
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4902
func G2_Get_Bone_Index(_ ghoul2: CGhoul2Info?, _ boneName: String) -> Int32 {
    let mod_m = R_GetModelByHandle(RE_RegisterModel(String(ghoul2!.mFileName)))
    let mod_a = R_GetModelByHandle(mod_m!.mdxm!.animIndex)

    return (G2_Find_Bone(mod_a!, &ghoul2!.mBlist, boneName))
}
