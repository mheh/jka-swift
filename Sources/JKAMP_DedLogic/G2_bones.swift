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

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1233
private let ERS_DYNAMIC = 0 as Int32
private let ERS_SETTLING = 1 as Int32
private let ERS_SETTLED = 2 as Int32

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
    var i: Int32
    var skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    offsets = MdxaSkelOffsets(mod.mdxa!, byteOffset: MdxaHeader.byteCount)
    skel = MdxaSkel(mod.mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[0])

    // look through entire list
    i = 0
    while i < blist.count {
        // if this bone entry has no info in it, bounce over it
        if blist[i].boneNumber == -1 {
            i += 1
            continue
        }

        // figure out what skeletal info structure this bone entry is looking at
        skel = MdxaSkel(mod.mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[blist[i].boneNumber])

        // if name is the same, we found it
        if Q_stricmp(skel.name, boneName) == 0 {
            return i
        }
        i += 1
    }

    // didn't find it
    return -1
}

// we need to add a bone to the list - find a free one and see if we can find a corresponding bone in the gla file
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:72
func G2_Add_Bone(_ mod: Model, _ blist: inout [boneInfo_t], _ boneName: String) -> Int32 {
    var i: Int32
    var x: Int32
    var skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    let tempBone = boneInfo_t()

    //rww - RAGDOLL_BEGIN
    // AI: Raven zeroes the whole record with memset after the constructor.
    // The constructor gives zero to every field but boneNumber, and the body sets boneNumber before the push.
    //rww - RAGDOLL_END

    offsets = MdxaSkelOffsets(mod.mdxa!, byteOffset: MdxaHeader.byteCount)

    // walk the entire list of bones in the gla file for this model and see if any match the name of the bone we want to find
    x = 0
    while x < mod.mdxa!.numBones {
        skel = MdxaSkel(mod.mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[x])
        // if name is the same, we found it
        if Q_stricmp(skel.name, boneName) == 0 {
            break
        }
        x += 1
    }

    // check to see we did actually make a match with a bone in the model
    if x == mod.mdxa!.numBones {
        // didn't find it? Error
        //assert(0);
        return -1
    }

    // look through entire list - see if it's already there first
    i = 0
    while i < blist.count {
        // if this bone entry has info in it, bounce over it
        if blist[i].boneNumber != -1 {
            skel = MdxaSkel(mod.mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[blist[i].boneNumber])
            // if name is the same, we found it
            if Q_stricmp(skel.name, boneName) == 0 {
                return i
            }
        } else {
            // if we found an entry that had a -1 for the bonenumber, then we hit a bone slot that was empty
            blist[i].boneNumber = x
            blist[i].flags = 0
            return i
        }
        i += 1
    }

    // ok, we didn't find an existing bone of that name, or an empty slot. Lets add an entry
    tempBone.boneNumber = x
    tempBone.flags = 0
    blist.append(tempBone)
    return Int32(blist.count) - 1
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
    let boneOverride = blist[index].matrix
    var newAngles = vec3_t()

    MdxaBone.scratch { temp1 in
        MdxaBone.scratch { permutation in
            if (flags & (BONE_ANGLES_PREMULT | BONE_ANGLES_POSTMULT)) != 0 {
                // build us a matrix out of the angles we are fed - but swap y and z because of wacky Quake setup
                var newAngles = vec3_t()

                // determine what axis newAngles Yaw should revolve around
                switch up {
                case NEGATIVE_X:
                    newAngles[1] = angles[2] + 180
                case POSITIVE_X:
                    newAngles[1] = angles[2]
                case NEGATIVE_Y:
                    newAngles[1] = angles[0]
                case POSITIVE_Y:
                    newAngles[1] = angles[0]
                case NEGATIVE_Z:
                    newAngles[1] = angles[1] + 180
                case POSITIVE_Z:
                    newAngles[1] = angles[1]
                default:
                    break
                }

                // determine what axis newAngles pitch should revolve around
                switch left {
                case NEGATIVE_X:
                    newAngles[0] = angles[2]
                case POSITIVE_X:
                    newAngles[0] = angles[2] + 180
                case NEGATIVE_Y:
                    newAngles[0] = angles[0]
                case POSITIVE_Y:
                    newAngles[0] = angles[0] + 180
                case NEGATIVE_Z:
                    newAngles[0] = angles[1]
                case POSITIVE_Z:
                    newAngles[0] = angles[1]
                default:
                    break
                }

                // determine what axis newAngles Roll should revolve around
                switch forward {
                case NEGATIVE_X:
                    newAngles[2] = angles[2]
                case POSITIVE_X:
                    newAngles[2] = angles[2]
                case NEGATIVE_Y:
                    newAngles[2] = angles[0]
                case POSITIVE_Y:
                    newAngles[2] = angles[0] + 180
                case NEGATIVE_Z:
                    newAngles[2] = angles[1]
                case POSITIVE_Z:
                    newAngles[2] = angles[1] + 180
                default:
                    break
                }

                Create_Matrix(newAngles, boneOverride)

                // figure out where the bone hirearchy info is
                // Raven declares `skel` and `offsets` at the top of the function, and only this arm reads them.
                let skel: MdxaSkel
                let offsets: MdxaSkelOffsets
                offsets = MdxaSkelOffsets(mod!.mdxa!, byteOffset: MdxaHeader.byteCount)
                skel = MdxaSkel(mod!.mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[blist[index].boneNumber])

                Multiply_3x4Matrix(temp1, boneOverride, skel.BasePoseMatInv)
                Multiply_3x4Matrix(boneOverride, skel.BasePoseMat, temp1)

            } else {
                newAngles = angles

                // why I should need do this Fuck alone knows. But I do.
                if left == POSITIVE_Y {
                    newAngles[0] += 180
                }

                Create_Matrix(newAngles, temp1)

                permutation.matrix[0][0] = 0
                permutation.matrix[0][1] = 0
                permutation.matrix[0][2] = 0
                permutation.matrix[0][3] = 0
                permutation.matrix[1][0] = 0
                permutation.matrix[1][1] = 0
                permutation.matrix[1][2] = 0
                permutation.matrix[1][3] = 0
                permutation.matrix[2][0] = 0
                permutation.matrix[2][1] = 0
                permutation.matrix[2][2] = 0
                permutation.matrix[2][3] = 0

                // determine what axis newAngles Yaw should revolve around
                switch forward {
                case NEGATIVE_X:
                    permutation.matrix[0][0] = -1		// works
                case POSITIVE_X:
                    permutation.matrix[0][0] = 1		// works
                case NEGATIVE_Y:
                    permutation.matrix[1][0] = -1
                case POSITIVE_Y:
                    permutation.matrix[1][0] = 1
                case NEGATIVE_Z:
                    permutation.matrix[2][0] = -1
                case POSITIVE_Z:
                    permutation.matrix[2][0] = 1
                default:
                    break
                }

                // determine what axis newAngles pitch should revolve around
                switch left {
                case NEGATIVE_X:
                    permutation.matrix[0][1] = -1
                case POSITIVE_X:
                    permutation.matrix[0][1] = 1
                case NEGATIVE_Y:
                    permutation.matrix[1][1] = -1		// works
                case POSITIVE_Y:
                    permutation.matrix[1][1] = 1		// works
                case NEGATIVE_Z:
                    permutation.matrix[2][1] = -1
                case POSITIVE_Z:
                    permutation.matrix[2][1] = 1
                default:
                    break
                }

                // determine what axis newAngles Roll should revolve around
                switch up {
                case NEGATIVE_X:
                    permutation.matrix[0][2] = -1
                case POSITIVE_X:
                    permutation.matrix[0][2] = 1
                case NEGATIVE_Y:
                    permutation.matrix[1][2] = -1
                case POSITIVE_Y:
                    permutation.matrix[1][2] = 1
                case NEGATIVE_Z:
                    permutation.matrix[2][2] = -1		// works
                case POSITIVE_Z:
                    permutation.matrix[2][2] = 1		// works
                default:
                    break
                }

                Multiply_3x4Matrix(boneOverride, temp1, permutation)

            }
        }
    }

    // keep a copy of the matrix in the newmatrix which is actually what we use
    blist[index].newMatrix.copy(from: blist[index].matrix)

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

    // did we find it?
    if (index >= 0) && !((index >= blist.count) || (blist[index].boneNumber == -1)) {

        // are we an animating bone?
        if (blist[index].flags & (BONE_ANIM_OVERRIDE_LOOP | BONE_ANIM_OVERRIDE)) != 0 {
            var lcurrentFrame: Int32 = 0
            var newFrame: Int32 = 0
            var lerp: Float = 0
            G2_TimingModel(blist[index], currentTime, numFrames, &lcurrentFrame, &newFrame, &lerp)

            currentFrame = Float(lcurrentFrame) + lerp
            startFrame = blist[index].startFrame
            endFrame = blist[index].endFrame
            flags = blist[index].flags
            retAnimSpeed = blist[index].animSpeed
            return true
        }
    }
    startFrame = 0
    endFrame = 1
    currentFrame = 0.0
    flags = 0
    retAnimSpeed = 0.0
    return false
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
    var i: Int32
    // Raven's `blist` is a reference to `ghoul2[index].mBlist`.

    // look through entire list
    i = 0
    while i < Int32(ghoul2[index].mBlist.count) {
        // we we a valid bone override?
        if ghoul2[index].mBlist[i].boneNumber != -1 {
            // are we animating?
            if (ghoul2[index].mBlist[i].flags & (BONE_ANIM_OVERRIDE_LOOP | BONE_ANIM_OVERRIDE)) != 0 {
                // yes - add in animation speed to current frame
                let animSpeed: Float = ghoul2[index].mBlist[i].animSpeed
                let endFrame = Float(ghoul2[index].mBlist[i].endFrame)
                var time: Float = (currentTime - ghoul2[index].mBlist[i].startTime) / 50.0
                // are we a paused anim?
                if ghoul2[index].mBlist[i].pauseTime != 0 {
                    time = (ghoul2[index].mBlist[i].pauseTime - ghoul2[index].mBlist[i].startTime) / 50.0
                }
                if time < 0.0 {
                    time = 0.0
                }
                var newFrame_g: Float = ghoul2[index].mBlist[i].startFrame + (time * animSpeed)

                let animSize = Int32(endFrame - ghoul2[index].mBlist[i].startFrame)
                // we are supposed to be animating right?
                if animSize != 0 {
                    // did we run off the end?
                    if ((animSpeed > 0.0) && (newFrame_g > endFrame - 1)) ||
                        ((animSpeed < 0.0) && (newFrame_g < endFrame + 1))
                    {
                        // yep - decide what to do
                        if (ghoul2[index].mBlist[i].flags & BONE_ANIM_OVERRIDE_LOOP) != 0 {
                            // get our new animation frame back within the bounds of the animation set
                            if animSpeed < 0.0 {
                                if newFrame_g <= endFrame + 1 {
                                    newFrame_g = endFrame + fmod(newFrame_g - endFrame, Float(animSize)) - animSize
                                }
                            } else {
                                if newFrame_g >= endFrame {
                                    newFrame_g = endFrame + fmod(newFrame_g - endFrame, Float(animSize)) - animSize
                                }
                            }
                            // figure out new start time
                            let frameTime: Float = newFrame_g - ghoul2[index].mBlist[i].startFrame
                            ghoul2[index].mBlist[i].startTime = currentTime - Int32((frameTime / animSpeed) * 50.0)
                            if ghoul2[index].mBlist[i].startTime > currentTime {
                                ghoul2[index].mBlist[i].startTime = currentTime
                            }
                            assert(ghoul2[index].mBlist[i].startTime <= currentTime)
                            ghoul2[index].mBlist[i].lastTime = ghoul2[index].mBlist[i].startTime
                        } else {
                            if (ghoul2[index].mBlist[i].flags & BONE_ANIM_OVERRIDE_FREEZE) != BONE_ANIM_OVERRIDE_FREEZE {
                                // nope, just stop it. And remove the bone if possible
                                _ = G2_Stop_Bone_Index(&ghoul2[index].mBlist, i, (BONE_ANIM_TOTAL))
                            }
                        }
                    }
                }
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1244
private func G2_Generate_MatrixRag(_ blist: inout [boneInfo_t], _ index: Int32) {


    let bone = blist[index]//.sent;

    bone.matrix.copy(from: bone.ragOverrideMatrix)
    blist[index].newMatrix.copy(from: bone.matrix)
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1267
func G2_Find_Bone_Rag(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneName: String) -> Int32 {
    var i: Int32
    var skel: MdxaSkel
    let offsets: MdxaSkelOffsets

    offsets = MdxaSkelOffsets(ghlInfo!.aHeader!, byteOffset: MdxaHeader.byteCount)
    skel = MdxaSkel(ghlInfo!.aHeader!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[0])

    /*
    model_t			*currentModel;
    model_t			*animModel;
    mdxaHeader_t	*aHeader;

    currentModel = R_GetModelByHandle(RE_RegisterModel(ghlInfo->mFileName));
    assert(currentModel);
    animModel =  R_GetModelByHandle(currentModel->mdxm->animIndex);
    assert(animModel);
    aHeader = animModel->mdxa;
    assert(aHeader);

    offsets = (mdxaSkelOffsets_t *)((byte *)aHeader + sizeof(mdxaHeader_t));
    skel = (mdxaSkel_t *)((byte *)aHeader + sizeof(mdxaHeader_t) + offsets->offsets[0]);
    */

    // look through entire list
    i = 0
    while i < blist.count {
        // if this bone entry has no info in it, bounce over it
        if blist[i].boneNumber == -1 {
            i += 1
            continue
        }

        // figure out what skeletal info structure this bone entry is looking at
        skel = MdxaSkel(ghlInfo!.aHeader!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[blist[i].boneNumber])
        //skel = (mdxaSkel_t *)((byte *)aHeader + sizeof(mdxaHeader_t) + offsets->offsets[blist[i].boneNumber]);

        // if name is the same, we found it
        if Q_stricmp(skel.name, boneName) == 0 {
            return i
        }
        i += 1
    }
    // didn't find it
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1318
// AI: Raven passes ghoul2.mBlist again as blist. The function reads the list through ghoul2, because the bone cache reads the same list.
@discardableResult
private func G2_Set_Bone_Rag(_ mod_a: MdxaHeader, _ boneName: String, _ ghoul2: CGhoul2Info, _ scale: JKAShared.vec3_t, _ origin: JKAShared.vec3_t) -> Int32 {
    // do not change the state of the skeleton here
    var index: Int32 = G2_Find_Bone_Rag(ghoul2, &ghoul2.mBlist, boneName)

    if index == -1 {
        index = G2_Add_Bone(ghoul2.animModel!, &ghoul2.mBlist, boneName)
    }

    if index != -1 {
        let bone = ghoul2.mBlist[index]
        bone.extraVec1 = origin

        G2_GetBoneMatrixLow(ghoul2, bone.boneNumber, scale, bone.originalTrueBoneMatrix, &bone.basepose, &bone.baseposeInv)
//		bone.parentRawBoneIndex=G2_GetParentBoneMatrixLow(ghoul2,bone.boneNumber,scale,bone.parentTrueBoneMatrix,bone.baseposeParent,bone.baseposeInvParent);
        bone.originalOrigin[0] = bone.originalTrueBoneMatrix.matrix[0][3]
        bone.originalOrigin[1] = bone.originalTrueBoneMatrix.matrix[1][3]
        bone.originalOrigin[2] = bone.originalTrueBoneMatrix.matrix[2][3]
    }
    return index
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1349
@discardableResult
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
@discardableResult
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
    if parms != nil {
        parms!.CallRagDollBegin = false
    }
    guard broadsword != nil, broadsword!.integer != 0, let parms = parms else {
        return
    }
    var model: Int32
    model = 0
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
    guard let mod_a = G2_GetModA(ghoul2) else {
        return
    }
    let curTime = G2API_GetTime(0)
    // Raven's `blist` is a reference to `ghoul2.mBlist`.
    // Raven reads `index` only in the `#ifndef DEDICATED` arm and an `#if 0` block, which the dedicated build drops.
    let index = G2_Find_Bone_Rag(ghoul2, &ghoul2.mBlist, "model_root")
    if (ghoul2.mFlags & GHOUL2_RAG_STARTED) != 0 {
        // only going to begin ragdoll once, everything else depends on what happens to the origin
        return
    }

    ghoul2.mFlags |= GHOUL2_RAG_PENDING | GHOUL2_RAG_DONE | GHOUL2_RAG_STARTED  // well anyway we are going live
    parms.CallRagDollBegin = true

    G2_GenerateWorldMatrix(parms.angles, parms.position)
    G2_ConstructGhoulSkeleton(ghoul2V, curTime, false, parms.scale)

    G2_Set_Bone_Rag(mod_a, "model_root", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "pelvis", ghoul2, parms.scale, parms.position)

    G2_Set_Bone_Rag(mod_a, "lower_lumbar", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "upper_lumbar", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "thoracic", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "cranium", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "rhumerus", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "lhumerus", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "rradius", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "lradius", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "rfemurYZ", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "lfemurYZ", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "rtibia", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "ltibia", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "rhand", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "lhand", ghoul2, parms.scale, parms.position)
    //G2_Set_Bone_Rag(mod_a,blist,"rtarsal",ghoul2,parms->scale,parms->position);
    //G2_Set_Bone_Rag(mod_a,blist,"ltarsal",ghoul2,parms->scale,parms->position);
    G2_Set_Bone_Rag(mod_a, "rtalus", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "ltalus", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "rradiusX", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "lradiusX", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "rfemurX", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "lfemurX", ghoul2, parms.scale, parms.position)
    G2_Set_Bone_Rag(mod_a, "ceyebrow", ghoul2, parms.scale, parms.position)

    //int startFrame = 3665, endFrame = 3665+1;
    let startFrame = parms.startFrame
    let endFrame = parms.endFrame

    G2_Set_Bone_Anim_No_BS(ghoul2, mod_a, &ghoul2.mBlist, "upper_lumbar", startFrame, endFrame - 1,
                           BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND,
                           1.0, curTime, Float(startFrame), 150, 0, true)
    G2_Set_Bone_Anim_No_BS(ghoul2, mod_a, &ghoul2.mBlist, "lower_lumbar", startFrame, endFrame - 1,
                           BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND,
                           1.0, curTime, Float(startFrame), 150, 0, true)
    G2_Set_Bone_Anim_No_BS(ghoul2, mod_a, &ghoul2.mBlist, "Motion", startFrame, endFrame - 1,
                           BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND,
                           1.0, curTime, Float(startFrame), 150, 0, true)
//	G2_Set_Bone_Anim_No_BS(ghoul2, mod_a,blist,"model_root",startFrame,endFrame-1,
//		BONE_ANIM_OVERRIDE_FREEZE|BONE_ANIM_BLEND,
//		1.0f,curTime,float(startFrame),150,0,true);
    G2_Set_Bone_Anim_No_BS(ghoul2, mod_a, &ghoul2.mBlist, "lfemurYZ", startFrame, endFrame - 1,
                           BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND,
                           1.0, curTime, Float(startFrame), 150, 0, true)
    G2_Set_Bone_Anim_No_BS(ghoul2, mod_a, &ghoul2.mBlist, "rfemurYZ", startFrame, endFrame - 1,
                           BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND,
                           1.0, curTime, Float(startFrame), 150, 0, true)

    G2_Set_Bone_Anim_No_BS(ghoul2, mod_a, &ghoul2.mBlist, "rhumerus", startFrame, endFrame - 1,
                           BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND,
                           1.0, curTime, Float(startFrame), 150, 0, true)
    G2_Set_Bone_Anim_No_BS(ghoul2, mod_a, &ghoul2.mBlist, "lhumerus", startFrame, endFrame - 1,
                           BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND,
                           1.0, curTime, Float(startFrame), 150, 0, true)

//    should already be set					G2_GenerateWorldMatrix(parms->angles, parms->position);
    G2_ConstructGhoulSkeleton(ghoul2V, curTime, false, parms.scale)

    let fRadScale: Float = 0.3//0.5f;

    var pcjMin: vec3_t
    var pcjMax: vec3_t
    pcjMin = vec3_t(-90.0, -45.0, -45.0)
    pcjMax = vec3_t(90.0, 45.0, 45.0)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "model_root", RAG_PCJ_MODEL_ROOT | RAG_PCJ | RAG_UNSNAPPABLE, 10.0 * fRadScale, pcjMin, pcjMax, 100)
    pcjMin = vec3_t(-45.0, -45.0, -45.0)
    pcjMax = vec3_t(45.0, 45.0, 45.0)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "pelvis", RAG_PCJ_PELVIS | RAG_PCJ | RAG_PCJ_POST_MULT | RAG_UNSNAPPABLE, 10.0 * fRadScale, pcjMin, pcjMax, 100)

    // new base anim, unconscious flop
    let pcjflags: Int32 = RAG_PCJ | RAG_PCJ_POST_MULT//|RAG_EFFECTOR;

    pcjMin = vec3_t(-15.0, -15.0, -15.0)
    pcjMax = vec3_t(15.0, 15.0, 15.0)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "lower_lumbar", pcjflags | RAG_UNSNAPPABLE, 10.0 * fRadScale, pcjMin, pcjMax, 500)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "upper_lumbar", pcjflags | RAG_UNSNAPPABLE, 10.0 * fRadScale, pcjMin, pcjMax, 500)
    pcjMin = vec3_t(-25.0, -25.0, -25.0)
    pcjMax = vec3_t(25.0, 25.0, 25.0)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "thoracic", pcjflags | RAG_EFFECTOR | RAG_UNSNAPPABLE, 12.0 * fRadScale, pcjMin, pcjMax, 500)

    pcjMin = vec3_t(-10.0, -10.0, -90.0)
    pcjMax = vec3_t(10.0, 10.0, 90.0)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "cranium", pcjflags | RAG_BONE_LIGHTWEIGHT | RAG_UNSNAPPABLE, 6.0 * fRadScale, pcjMin, pcjMax, 500)

    let sFactLeg: Float = 1.0
    let sFactArm: Float = 1.0
    let sRadArm: Float = 1.0
    let sRadLeg: Float = 1.0

    pcjMin = vec3_t(-100.0, -40.0, -15.0)
    pcjMax = vec3_t(-15.0, 80.0, 15.0)
    pcjMin = pcjMin * sFactArm
    pcjMax = pcjMax * sFactArm
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "rhumerus", pcjflags | RAG_BONE_LIGHTWEIGHT | RAG_UNSNAPPABLE, (4.0 * sRadArm) * fRadScale, pcjMin, pcjMax, 500)
    pcjMin = vec3_t(-50.0, -80.0, -15.0)
    pcjMax = vec3_t(15.0, 40.0, 15.0)
    pcjMin = pcjMin * sFactArm
    pcjMax = pcjMax * sFactArm
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "lhumerus", pcjflags | RAG_BONE_LIGHTWEIGHT | RAG_UNSNAPPABLE, (4.0 * sRadArm) * fRadScale, pcjMin, pcjMax, 500)

    pcjMin = vec3_t(-25.0, -20.0, -20.0)
    pcjMax = vec3_t(90.0, 20.0, -20.0)
    pcjMin = pcjMin * sFactArm
    pcjMax = pcjMax * sFactArm
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "rradius", pcjflags | RAG_BONE_LIGHTWEIGHT, (3.0 * sRadArm) * fRadScale, pcjMin, pcjMax, 500)
    pcjMin = vec3_t(-90.0, -20.0, -20.0)
    pcjMax = vec3_t(30.0, 20.0, -20.0)
    pcjMin = pcjMin * sFactArm
    pcjMax = pcjMax * sFactArm
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "lradius", pcjflags | RAG_BONE_LIGHTWEIGHT, (3.0 * sRadArm) * fRadScale, pcjMin, pcjMax, 500)


    pcjMin = vec3_t(-80.0, -50.0, -20.0)
    pcjMax = vec3_t(30.0, 5.0, 20.0)
    pcjMin = pcjMin * sFactLeg
    pcjMax = pcjMax * sFactLeg
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "rfemurYZ", pcjflags | RAG_BONE_LIGHTWEIGHT, (6.0 * sRadLeg) * fRadScale, pcjMin, pcjMax, 500)
    pcjMin = vec3_t(-60.0, -5.0, -20.0)
    pcjMax = vec3_t(50.0, 50.0, 20.0)
    pcjMin = pcjMin * sFactLeg
    pcjMax = pcjMax * sFactLeg
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "lfemurYZ", pcjflags | RAG_BONE_LIGHTWEIGHT, (6.0 * sRadLeg) * fRadScale, pcjMin, pcjMax, 500)

    pcjMin = vec3_t(-20.0, -15.0, -15.0)
    pcjMax = vec3_t(100.0, 15.0, 15.0)
    pcjMin = pcjMin * sFactLeg
    pcjMax = pcjMax * sFactLeg
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "rtibia", pcjflags | RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (4.0 * sRadLeg) * fRadScale, pcjMin, pcjMax, 500)
    pcjMin = vec3_t(20.0, -15.0, -15.0)
    pcjMax = vec3_t(100.0, 15.0, 15.0)
    pcjMin = pcjMin * sFactLeg
    pcjMax = pcjMax * sFactLeg
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "ltibia", pcjflags | RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (4.0 * sRadLeg) * fRadScale, pcjMin, pcjMax, 500)


    let sRadEArm: Float = 1.2
    let sRadELeg: Float = 1.2

//	int rhand=
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "rhand", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (6.0 * sRadEArm) * fRadScale)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "lhand", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (6.0 * sRadEArm) * fRadScale)
    //G2_Set_Bone_Angles_Rag(ghoul2, mod_a,blist,"rtarsal",RAG_EFFECTOR|RAG_BONE_LIGHTWEIGHT,(4.0f*sRadELeg)*fRadScale);
    //G2_Set_Bone_Angles_Rag(ghoul2, mod_a,blist,"ltarsal",RAG_EFFECTOR|RAG_BONE_LIGHTWEIGHT,(4.0f*sRadELeg)*fRadScale);
//	G2_Set_Bone_Angles_Rag(ghoul2, mod_a,blist,"rtibia",RAG_EFFECTOR|RAG_BONE_LIGHTWEIGHT,(4.0f*sRadELeg)*fRadScale);
//	G2_Set_Bone_Angles_Rag(ghoul2, mod_a,blist,"ltibia",RAG_EFFECTOR|RAG_BONE_LIGHTWEIGHT,(4.0f*sRadELeg)*fRadScale);
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "rtalus", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (4.0 * sRadELeg) * fRadScale)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "ltalus", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (4.0 * sRadELeg) * fRadScale)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "rradiusX", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (6.0 * sRadEArm) * fRadScale)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "lradiusX", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (6.0 * sRadEArm) * fRadScale)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "rfemurX", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (10.0 * sRadELeg) * fRadScale)
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "lfemurX", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, (10.0 * sRadELeg) * fRadScale)
    //G2_Set_Bone_Angles_Rag(ghoul2, mod_a,blist,"ceyebrow",RAG_EFFECTOR|RAG_BONE_LIGHTWEIGHT,10.0f*fRadScale);
    G2_Set_Bone_Angles_Rag(ghoul2, mod_a, &ghoul2.mBlist, "ceyebrow", RAG_EFFECTOR | RAG_BONE_LIGHTWEIGHT, 5.0)
//match the currrent animation
    if !G2_RagDollSetup(ghoul2, curTime, true, parms.position, false) {
        assert(false, "failed to add any rag bones")
        return
    }
    G2_RagDollCurrentPosition(ghoul2V, model, curTime, parms.angles, parms.position, parms.scale)
    var k: Int32

    let fparms = CRagDollUpdateParams()
    fparms.position = parms.position
    fparms.angles = parms.angles
    fparms.scale = parms.scale
    fparms.velocity = vec3_t()
    fparms.me = parms.me
    fparms.settleFrame = parms.endFrame

    //Guess I don't need to do this, do I?
    G2_ConstructGhoulSkeleton(ghoul2V, curTime, false, parms.scale)

    var dPos: vec3_t
    dPos = parms.position

    k = 0
    while k < /*10*/20 {
        G2_RagDollSettlePositionNumeroTrois(ghoul2V, dPos, fparms, curTime)

        G2_RagDollCurrentPosition(ghoul2V, model, curTime, parms.angles, dPos, parms.scale)
        G2_RagDollMatchPosition()
        G2_RagDollSolve(ghoul2V, model, 1.0 * (1.0 - k / 40.0), curTime, dPos, false)
        k += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2040
func G2_SetRagDollBullet(_ ghoul2: CGhoul2Info, _ rayStart: JKAShared.vec3_t, _ hit: JKAShared.vec3_t) {
    // Raven calls this function from no file of either tree, so it is dead.
    if broadsword == nil || broadsword!.integer == 0 {
        return
    }
    var shotDir: vec3_t
    shotDir = hit - rayStart
    var len: Float = VectorLength(shotDir)
    if len < 1.0 {
        return
    }
    var lenr: Float = 1.0 / len
    shotDir[0] *= lenr
    shotDir[1] *= lenr
    shotDir[2] *= lenr

    var firstOne = false
    if broadsword_kickbones != nil && broadsword_kickbones!.integer != 0 {
        var i: Int32
        let magicFactor13: Int32 = 150 // squared radius multiplier for shot effects
        // Raven's `blist` is a reference to `ghoul2.mBlist`.
        i = Int32(ghoul2.mBlist.count) - 1
        while i >= 0 {
            let bone = ghoul2.mBlist[i]
            if (bone.flags & BONE_ANGLES_TOTAL) != 0 {
                if (bone.flags & BONE_ANGLES_RAGDOLL) != 0 {
                    if !firstOne {
                        firstOne = true
                    }

                    bone.lastShotDir = shotDir
                    var dir: vec3_t
                    dir = bone.lastPosition - hit
                    len = VectorLength(dir)
                    if len < 1.0 {
                        len = 1.0
                    }
                    lenr = 1.0 / len
                    var effect: Float = lenr
                    effect *= magicFactor13 * effect // this is cubed, one of them is absorbed by the next calc
                    bone.velocityEffector[0] = shotDir[0] * (effect + flrand(0.0, 0.05))
                    bone.velocityEffector[1] = shotDir[1] * (effect + flrand(0.0, 0.05))
                    bone.velocityEffector[2] = abs(shotDir[2]) * (effect + flrand(0.0, 0.05))
//					bone.velocityEffector[0]=shotDir[0]*(effect+flrand(0.0f,0.05f))*flrand(-0.1f,3.0f);
//					bone.velocityEffector[1]=shotDir[1]*(effect+flrand(0.0f,0.05f))*flrand(-0.1f,3.0f);
//					bone.velocityEffector[2]=fabs(shotDir[2])*(effect+flrand(0.0f,0.05f))*flrand(-0.1f,3.0f);
                    assert(!shotDir[2].isNaN)
    //				bone.currentAngles[0]+=flrand(-10.0f*lenr,10.0f*lenr);
    //				bone.currentAngles[1]+=flrand(-10.0f*lenr,10.0f*lenr);
    //				bone.currentAngles[2]+=flrand(-10.0f*lenr,10.0f*lenr);
    //				bone.lastAngles[0]+=flrand(-10.0f*lenr,10.0f*lenr);
    //				bone.lastAngles[1]+=flrand(-10.0f*lenr,10.0f*lenr);
    //				bone.lastAngles[2]+=flrand(-10.0f*lenr,10.0f*lenr);

                    // go dynamic
                    bone.firstCollisionTime = G2API_GetTime(0)
//					bone.firstCollisionTime=0;
                    bone.restTime = 0
                }
            }
            i -= 1
        }
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2152
private func G2_RagSetState(_ ghoul2: CGhoul2Info, _ bone: boneInfo_t, _ frameNum: Int32, _ origin: JKAShared.vec3_t, _ resetOrigin: inout Bool) -> Float {
    ragOriginChange = DistanceSquared(origin, bone.extraVec1)
    ragOriginChangeDir = origin - bone.extraVec1

    var decay: Float = 1.0

    let dynamicTime: Int32 = 1000
    let settleTime: Int32 = 1000

    if (ghoul2.mFlags & GHOUL2_RAG_FORCESOLVE) != 0 {
        ragState = ERS_DYNAMIC
        if frameNum > bone.firstCollisionTime + dynamicTime {
            bone.extraVec1 = origin
            if ragOriginChange > 15.0 { //if we moved, or if this bone is still in solid
                bone.firstCollisionTime = frameNum
            } else {
                // settle out
                bone.firstCollisionTime = 0
                bone.restTime = frameNum
                ragState = ERS_SETTLING
            }
        }
    } else if bone.firstCollisionTime > 0 {
        ragState = ERS_DYNAMIC
        if frameNum > bone.firstCollisionTime + dynamicTime {
            bone.extraVec1 = origin
            if ragOriginChange > 15.0 { //if we moved, or if this bone is still in solid
                bone.firstCollisionTime = frameNum
            } else {
                // settle out
                bone.firstCollisionTime = 0
                bone.restTime = frameNum
                ragState = ERS_SETTLING
            }
        }
//decay=0.0f;
    } else if bone.restTime > 0 {
        decay = 1.0 - (frameNum - bone.restTime) / Float(dynamicTime)
        if decay < 0.0 {
            decay = 0.0
        }
        if decay > 1.0 {
            decay = 1.0
        }
        let magicFactor8: Float = 1.0 // Power for decay
        decay = pow(decay, magicFactor8)
        ragState = ERS_SETTLING
        if frameNum > bone.restTime + settleTime {
            bone.extraVec1 = origin
            if ragOriginChange > 15.0 {
                bone.restTime = frameNum
            } else {
                // stop
                bone.restTime = 0
                ragState = ERS_SETTLED
            }
        }
//decay=0.0f;
    } else {
        if (bone.RagFlags & RAG_PCJ_IK_CONTROLLED) != 0 {
            bone.firstCollisionTime = frameNum
            ragState = ERS_DYNAMIC
        } else if ragOriginChange > 15.0 {
            bone.firstCollisionTime = frameNum
            ragState = ERS_DYNAMIC
        } else {
            ragState = ERS_SETTLED
        }
        decay = 0.0
    }
//			ragState=ERS_SETTLED;
//			decay=0.0f;
    return decay
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2254
private func G2_RagDollSetup(_ ghoul2: CGhoul2Info, _ frameNum: Int32, _ resetOrigin: Bool, _ origin: JKAShared.vec3_t, _ anyRendered: Bool) -> Bool {
    var i: Int32
    var minSurvivingBone: Int32 = 10000
    var minSurvivingBoneAt: Int32 = -1
    var minSurvivingBoneAlt: Int32 = 10000
    var minSurvivingBoneAtAlt: Int32 = -1

    assert(ghoul2.mFileName[0] != 0)
    // Raven's `blist` is a reference to `ghoul2.mBlist`.
    rag.removeAll()
    var numRendered: Int32 = 0
    var numNotRendered: Int32 = 0
    var pelvisAt: Int32 = -1
    i = 0
    while i < ghoul2.mBlist.count {
        let bone = ghoul2.mBlist[i]
        if bone.boneNumber >= 0 {
            assert(bone.boneNumber < MAX_BONES_RAG)
            if (bone.flags & BONE_ANGLES_RAGDOLL) != 0 || (bone.flags & BONE_ANGLES_IK) != 0 {
                //rww - this was (!anyRendered) before. Isn't that wrong? (if anyRendered, then wasRendered should be true)
                let wasRendered =
                    (!anyRendered) ||   // offscreeen or something
                    G2_WasBoneRendered(ghoul2, bone.boneNumber)
                if !wasRendered {
                    bone.RagFlags |= RAG_WAS_NOT_RENDERED
                    numNotRendered += 1
                } else {
                    bone.RagFlags &= ~RAG_WAS_NOT_RENDERED
                    bone.RagFlags |= RAG_WAS_EVER_RENDERED
                    numRendered += 1
                }
                if (bone.RagFlags & RAG_PCJ_PELVIS) != 0 {
                    pelvisAt = i
                } else if (bone.RagFlags & RAG_PCJ_MODEL_ROOT) != 0 {
                } else if wasRendered && (bone.RagFlags & RAG_PCJ) != 0 {
                    if minSurvivingBone > bone.boneNumber {
                        minSurvivingBone = bone.boneNumber
                        minSurvivingBoneAt = i
                    }
                } else if wasRendered {
                    if minSurvivingBoneAlt > bone.boneNumber {
                        minSurvivingBoneAlt = bone.boneNumber
                        minSurvivingBoneAtAlt = i
                    }
                }
                if anyRendered &&
                    (bone.RagFlags & RAG_WAS_EVER_RENDERED) != 0 &&
                    (bone.RagFlags & RAG_PCJ_MODEL_ROOT) == 0 &&
                    (bone.RagFlags & RAG_PCJ_PELVIS) == 0 &&
                    !wasRendered &&
                    (bone.RagFlags & RAG_EFFECTOR) != 0 {
                    // this thing was rendered in the past, but wasn't now, although other bones were, lets get rid of it
//					bone.flags &= ~BONE_ANGLES_RAGDOLL;
//					bone.RagFlags = 0;
//OutputDebugString(va("Deleted Effector %d\n",i));
//					continue;
                }
                if rag.count < bone.boneNumber + 1 {
                    // Raven's `resize` fills each new slot with his 0.
                    while rag.count < bone.boneNumber + 1 {
                        rag.append(nil)
                    }
                }
                rag[bone.boneNumber] = bone
                ragBlistIndex[bone.boneNumber] = i

                bone.lastTimeUpdated = frameNum
                if resetOrigin {
                    bone.extraVec1 = origin // this is only done incase a limb is removed
                }
            }
        }
        i += 1
    }
    numRags = 0
    var ragStartTime: Int32 = 0
    i = 0
    while i < rag.count {
        if rag[i] != nil {
            let bone = rag[i]!
            assert(bone.boneNumber >= 0)
            assert(numRags < MAX_BONES_RAG)

            ragStartTime = bone.ragStartTime

            bone.ragIndex = numRags
            ragBoneData[numRags] = bone
            ragEffectors[numRags].radius = bone.radius
            ragEffectors[numRags].weight = bone.weight
            G2_GetBoneBasepose(ghoul2, bone.boneNumber, &bone.basepose, &bone.baseposeInv)
            numRags += 1
        }
        i += 1
    }
    if numRags == 0 {
        return false
    }
    return true
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2403
private func G2_RagDoll(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ params: CRagDollUpdateParams?, _ curTime: Int32) {
    var i: Int32
    if broadsword == nil || broadsword!.integer == 0 {
        return
    }

    guard let params = params else {
        assert(false)
        return
    }

    var dPos: vec3_t
    dPos = params.position

//	params->DebugLine(handPos,handPos2,false);
    let frameNum = G2API_GetTime(0)
    let ghoul2 = ghoul2V[g2Index]
    // Raven's `blist` is a reference to `ghoul2.mBlist`.

    // hack for freezing ragdoll (no idea if it works)

    var decay: Float = 1.0
    var resetOrigin = false
    var anyRendered = false

    // this loop checks for settled
    i = 0
    while i < ghoul2.mBlist.count {
        let bone = ghoul2.mBlist[i]
        if bone.boneNumber >= 0 {
            assert(bone.boneNumber < MAX_BONES_RAG)
            if (bone.flags & BONE_ANGLES_RAGDOLL) != 0 {
                // check for state transitions
                decay = G2_RagSetState(ghoul2, bone, frameNum, dPos, &resetOrigin) // set the current state

                if ragState == ERS_SETTLED {
                    params.RagDollSettled()
                    return
                }
                if G2_WasBoneRendered(ghoul2, bone.boneNumber) {
                    anyRendered = true
                    break
                }
            }
        }
        i += 1
    }
    //int iters=(ragState==ERS_DYNAMIC)?2:1;
    var iters: Int32 = (ragState == ERS_DYNAMIC) ? 4 : 2
    var kicked = false
    if ragOriginChangeDir[2] < -100.0 {
        kicked = true
        //iters*=8;
        iters *= 2 //rww - changed to this.. it was getting up to around 600 traces at times before (which is insane)
    }
    if iters != 0 {
        if !G2_RagDollSetup(ghoul2, frameNum, resetOrigin, dPos, anyRendered) {
            return
        }
        // ok, now our data structures are compact and set up in topological order

        i = 0
        while i < iters {
            G2_RagDollCurrentPosition(ghoul2V, g2Index, frameNum, params.angles, dPos, params.scale)

            if G2_RagDollSettlePositionNumeroTrois(ghoul2V, dPos, params, curTime) {
            }
            //params->position[2] += 16;
            G2_RagDollSolve(ghoul2V, g2Index, decay * 2.0, frameNum, dPos, true, params)
            i += 1
        }
    }

    if params.me != ENTITYNUM_NONE {
        G2_RagDollCurrentPosition(ghoul2V, g2Index, frameNum, params.angles, params.position, params.scale)
//		SV_UnlinkEntity(params->me);
//		params->me->SetMins(BB_SHOOTING_SIZE,ragBoneMins);
//		params->me->SetMaxs(BB_SHOOTING_SIZE,ragBoneMaxs);
//		SV_LinkEntity(params->me);
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2580
private func G2_Get_Bone_Name(_ ghlInfo: CGhoul2Info?, _ blist: inout [boneInfo_t], _ boneNum: Int32) -> String {
    // Raven's three calls have no caller in the dedicated build.
    // The calls at G2_bones.cpp:2625 and :3851 stand under `_DEBUG_BONE_NAMES`, which only `_DEBUG` defines (:2576).
    // The call at :3964 stands in the `#ifndef DEDICATED` arm of G2_BoneSnap, and the dedicated build takes the `return` at :3954.
    var i: Int32
    var skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    offsets = MdxaSkelOffsets(ghlInfo!.aHeader!, byteOffset: MdxaHeader.byteCount)
    skel = MdxaSkel(ghlInfo!.aHeader!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[0])

    // look through entire list
    i = 0
    while i < blist.count {
        // if this bone entry has no info in it, bounce over it
        if blist[i].boneNumber != boneNum {
            i += 1
            continue
        }

        // figure out what skeletal info structure this bone entry is looking at
        skel = MdxaSkel(ghlInfo!.aHeader!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[blist[i].boneNumber])

        return skel.name
    }

    // didn't find it
    return "BONE_NOT_FOUND"
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2609
private func G2_RagDollCurrentPosition(_ ghoul2V: CGhoul2Info_v, _ g2Index: Int32, _ frameNum: Int32, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ scale: JKAShared.vec3_t) {
    let ghoul2 = ghoul2V[g2Index]
    assert(ghoul2.mFileName[0] != 0)
//OutputDebugString(va("angles %f %f %f\n",angles[0],angles[1],angles[2]));
    G2_GenerateWorldMatrix(angles, position)
    G2_ConstructGhoulSkeleton(ghoul2V, frameNum, false, scale)

    var totalWt: Float = 0.0
    var i: Int32
    i = 0
    while i < numRags {
        let bone = ragBoneData[i]!
        G2_GetBoneMatrixLow(ghoul2, bone.boneNumber, scale, ragBones[i], &ragBasepose[i], &ragBaseposeInv[i])

        var k: Int32
        //float cmweight=ragEffectors[numRags].weight;
        let cmweight: Float = 1.0
        k = 0
        while k < 3 {
            ragEffectors[i].currentOrigin[k] = ragBones[i].matrix[k][3]
            if i == 0 {
                // set mins, maxs and cm
                ragBoneCM[k] = ragEffectors[i].currentOrigin[k] * cmweight
                ragBoneMaxs[k] = ragEffectors[i].currentOrigin[k]
                ragBoneMins[k] = ragEffectors[i].currentOrigin[k]
            } else {
                ragBoneCM[k] += ragEffectors[i].currentOrigin[k] * ragEffectors[i].weight
                if ragEffectors[i].currentOrigin[k] > ragBoneMaxs[k] {
                    ragBoneMaxs[k] = ragEffectors[i].currentOrigin[k]
                }
                if ragEffectors[i].currentOrigin[k] < ragBoneMins[k] {
                    ragBoneMins[k] = ragEffectors[i].currentOrigin[k]
                }
            }
            k += 1
        }

        totalWt += cmweight
        i += 1
    }

    assert(totalWt > 0.0)
    var k: Int32
    do {
        let wtInv: Float = 1.0 / totalWt
        k = 0
        while k < 3 {
            ragBoneMaxs[k] -= position[k]
            ragBoneMins[k] -= position[k]
            ragBoneMaxs[k] += 10.0
            ragBoneMins[k] -= 10.0
            ragBoneCM[k] *= wtInv

            ragBoneCM[k] = ragEffectors[0].currentOrigin[k] // use the pelvis
            k += 1
        }
    }
}

/// Source: oracle/codemp/ghoul2/G2_bones.cpp:2683
public func Rag_Trace(_ results: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ passEntityNum: Int32, _ contentmask: Int32, _ eG2TraceType: EG2_Collision, _ useLod: Int32) {
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
    //now returns true if any bone was in solid, otherwise false
    let ignoreNum = params!.me
    // Raven's static locals are scratch, because each call writes them before a read.
    var i: Int32 = 0
    var goalSpot = vec3_t()
    var k: Int32 = 0
    let velocityDampening: Float = 1.0
    let velocityMultiplier: Float = 60.0
    var testMins = vec3_t()
    var testMaxs = vec3_t()
    var velDir = vec3_t()
    var startSolid = false
    var anySolid = false
    var parentOrigin = vec3_t()
    var basePos = vec3_t()
    var entScale = vec3_t()
    var hasDaddy = false
    var hasBasePos = false
    var animPelvisDir = vec3_t()
    var pelvisDir = vec3_t()
    var animPelvisPos = vec3_t()
    var pelvisPos = vec3_t()

    //Maybe customize per-bone?
    let gravity: Float = 3.0
    let mass: Float = 0.09
    let bounce: Float = 0.0//1.3f;
    //Bouncing and stuff unfortunately does not work too well at the moment.
    //Need to keep a seperate "physics origin" or make the filthy solve stuff
    //better.

    var inAir = false

    if params!.velocity[0] != 0 || params!.velocity[1] != 0 || params!.velocity[2] != 0 {
        inAir = true
    }

    if params!.scale[0] == 0 && params!.scale[1] == 0 && params!.scale[2] == 0 {
        entScale = vec3_t(1.0, 1.0, 1.0)
    } else {
        entScale = params!.scale
    }

    if broadsword_ragtobase != nil &&
        broadsword_ragtobase!.integer > 1 {
        //grab the pelvis directions to offset base positions for bones
        G2_RagGetPelvisLumbarOffsets(ghoul2V[0], params, &pelvisPos, &pelvisDir, &animPelvisPos,
                                     &animPelvisDir)

        //don't care about the pitch offsets
        pelvisDir[2] = 0
        animPelvisDir[2] = 0

        /*
        vec3_t upelvisPos, uanimPelvisPos;
        vec3_t blah;
        VectorCopy(pelvisPos, upelvisPos);
        VectorCopy(animPelvisPos, uanimPelvisPos);
        upelvisPos[2] += 64;
        uanimPelvisPos[2] += 64;

        VectorMA(upelvisPos, 32.0f, pelvisDir, blah);
        G2_RagDebugLine(upelvisPos, blah, 50, 0x00ff00, 1);
        VectorMA(uanimPelvisPos, 32.0f, animPelvisDir, blah);
        G2_RagDebugLine(uanimPelvisPos, blah, 50, 0xff0000, 1);
        */

        //just convert to angles now, that's all we'll ever use them for
        vectoangles(pelvisDir, &pelvisDir)
        vectoangles(animPelvisDir, &animPelvisDir)
    }

    Trace.scratch { tr in
        MdxaBone.scratch { worldBaseMatrix in
            i = 0
            while i < numRags {
                let bone = ragBoneData[i]!
                let e = ragEffectors[i]

                if inAir {
                    bone.airTime = curTime + 30
                }

                if (bone.RagFlags & RAG_PCJ_PELVIS) != 0 {
                    goalSpot = vec3_t(params!.position[0], params!.position[1], (params!.position[2] + DEFAULT_MINS_2) + ((bone.radius * entScale[2]) + 2))

                    desiredPelvisOffset = goalSpot - e.currentOrigin
                    haveDesiredPelvisOffset = true
                    bone.lastPosition = e.currentOrigin
                    i += 1
                    continue
                }

                if (bone.RagFlags & RAG_EFFECTOR) == 0 {
                    i += 1
                    continue
                }

                if bone.hasOverGoal { //api call was made to override the goal spot
                    goalSpot = bone.overGoalSpot
                    bone.solidCount = 0
                    k = 0
                    while k < 3 {
                        e.desiredDirection[k] = (goalSpot[k] - e.currentOrigin[k])
                        e.desiredDirection[k] += (velocityMultiplier * bone.velocityEffector[k])
                        bone.velocityEffector[k] *= velocityDampening
                        k += 1
                    }
                    bone.lastPosition = e.currentOrigin

                    i += 1
                    continue
                }

                testMins = vec3_t(-e.radius * entScale[0], -e.radius * entScale[1], -e.radius * entScale[2])
                testMaxs = vec3_t(e.radius * entScale[0], e.radius * entScale[1], e.radius * entScale[2])

                assert(ghoul2V[0].mBoneCache != nil)

                //get the parent bone's position
                hasDaddy = false
                if bone.boneNumber != 0 {
                    assert(ghoul2V[0].animModel != nil)
                    assert(ghoul2V[0].aHeader != nil)

                    if bone.parentBoneIndex == -1 {
                        var skel: MdxaSkel
                        let offsets: MdxaSkelOffsets
                        var bParentIndex: Int32
                        var bParentListIndex: Int32 = -1

                        offsets = MdxaSkelOffsets(ghoul2V[0].aHeader!, byteOffset: MdxaHeader.byteCount)
                        skel = MdxaSkel(ghoul2V[0].aHeader!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[bone.boneNumber])

                        bParentIndex = skel.parent

                        while bParentIndex > 0 { //go upward through hierarchy searching for the first parent that is a rag bone
                            skel = MdxaSkel(ghoul2V[0].aHeader!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[bParentIndex])
                            bParentIndex = skel.parent
                            bParentListIndex = G2_Find_Bone(ghoul2V[0].animModel!, &ghoul2V[0].mBlist, skel.name)

                            if bParentListIndex != -1 {
                                let pbone = ghoul2V[0].mBlist[bParentListIndex]
                                if (pbone.flags & BONE_ANGLES_RAGDOLL) != 0 { //valid rag bone
                                    break
                                }
                            }

                            //didn't work out, reset to -1 again
                            bParentListIndex = -1
                        }

                        bone.parentBoneIndex = bParentListIndex
                    }

                    if bone.parentBoneIndex != -1 {
                        let pbone = ghoul2V[0].mBlist[bone.parentBoneIndex]

                        if (pbone.flags & BONE_ANGLES_RAGDOLL) != 0 { //has origin calculated for us already
                            parentOrigin = ragEffectors[pbone.ragIndex].currentOrigin
                            hasDaddy = true
                        }
                    }
                }

                //get the position this bone would be in if we were in the desired frame
                hasBasePos = false
                if broadsword_ragtobase != nil &&
                    broadsword_ragtobase!.integer != 0 {
                    var v = vec3_t()
                    var a = vec3_t()
                    var f: Float

                    G2_RagGetWorldAnimMatrix(ghoul2V[0], bone, params, worldBaseMatrix)
                    G2API_GiveMeVectorFromMatrix(worldBaseMatrix, ORIGIN, &basePos)

                    if broadsword_ragtobase!.integer > 1 {
                        var fa: Float = AngleNormalize180(animPelvisDir[YAW] - pelvisDir[YAW])
                        let d: Float = fa - bone.offsetRotation

                        if d > 16.0 ||
                            d < -16.0 { //don't update unless x degrees away from the ideal to avoid moving goal spots too much if pelvis rotates
                            bone.offsetRotation = fa
                        } else {
                            fa = bone.offsetRotation
                        }
                        //Rotate the point around the pelvis based on the offsets between pelvis positions
                        v = basePos - animPelvisPos
                        f = VectorLength(v)
                        vectoangles(v, &a)
                        a[YAW] -= fa
                        // Raven passes NULL for `right` and `up`, so the two scratch vectors take the outputs Raven skips.
                        var right = vec3_t()
                        var up = vec3_t()
                        AngleVectors(a, &v, &right, &up)
                        _ = VectorNormalize(&v)
                        _VectorMA(animPelvisPos, f, v, &basePos)

                        //re-orient the position of the bone to the current position of the pelvis
                        v = basePos - animPelvisPos
                        //push the spots outward? (to stretch the skeleton more)
                        //v[0] *= 1.5f;
                        //v[1] *= 1.5f;
                        basePos = pelvisPos + v
                    }
                    hasBasePos = true
                }

                //Are we in solid?
                if hasDaddy {
                    Rag_Trace(tr, e.currentOrigin, testMins, testMaxs, parentOrigin, ignoreNum, RAG_MASK, G2_NOCOLLIDE, 0)
                    //Rag_Trace(&tr, parentOrigin, testMins, testMaxs, e.currentOrigin, ignoreNum, RAG_MASK, G2_NOCOLLIDE, 0);
                } else {
                    Rag_Trace(tr, e.currentOrigin, testMins, testMaxs, params!.position, ignoreNum, RAG_MASK, G2_NOCOLLIDE, 0)
                }

                if tr.startsolid != 0 || tr.allsolid != 0 || tr.fraction != 1.0 { //currently in solid, see what we can do about it
                    var vSub = vec3_t()

                    startSolid = true
                    anySolid = true

                    if hasBasePos {// && bone.solidCount < 32)
                        //only go to the base pos for slightly in solid bones
                        //just use the spot directly
                        goalSpot = basePos
                        goalSpot[2] = (params!.position[2] - 23) - testMins[2]
                        //Com_Printf("%i: %f %f %f\n", bone.boneNumber, basePos[0], basePos[1], basePos[2]);
                    } else { //if deep in solid want to try to rise up out of solid before hinting back to base
                        vSub = e.currentOrigin - params!.position
                        _ = VectorNormalize(&vSub)
                        _VectorMA(params!.position, 40.0, vSub, &goalSpot)

                        //should be 1 unit above the ground taking bounding box sizes into account
                        goalSpot[2] = (params!.position[2] - 23) - testMins[2]
                    }

                    //Trace from the entity origin in the direction between the origin and current bone position to
                    //find a good eventual goal position
                    Rag_Trace(tr, params!.position, testMins, testMaxs, goalSpot, params!.me, RAG_MASK, G2_NOCOLLIDE, 0)
                    goalSpot = tr.endpos
                } else {
                    startSolid = false

                    //Hint the bone back to the base origin
                    if hasDaddy || hasBasePos {
                        if hasBasePos {
                            velDir = basePos - e.currentOrigin
                        } else {
                            velDir = e.currentOrigin - parentOrigin
                        }
                    } else {
                        velDir = e.currentOrigin - params!.position
                    }

                    if VectorLength(velDir) > 2.0 { //don't bother if already close
                        _ = VectorNormalize(&velDir)
                        velDir = velDir * 8.0
                        velDir[2] = 0 //don't want to nudge on Z, the gravity will take care of things.
                        bone.epVelocity = bone.epVelocity + velDir
                    }

                    //Factor the object's velocity into the bone's velocity, by pushing the bone
                    //opposite the velocity to give the apperance the lighter limbs are being "dragged"
                    //behind those of greater mass.
                    if (bone.RagFlags & RAG_BONE_LIGHTWEIGHT) != 0 {
                        var vel: vec3_t
                        var vellen: Float

                        vel = params!.velocity

                        //Scale down since our velocity scale is different from standard game physics
                        vel = vel * 0.5

                        vellen = VectorLength(vel)

                        if vellen > 64.0 { //cap it off
                            vel = vel * (64.0 / vellen)
                        }

                        //Invert the velocity so we go opposite the heavier parts and drag behind
                        VectorInverse(&vel)

                        if vel[2] != 0 { //want to override entirely instead then
                            bone.epVelocity = vel
                        } else {
                            bone.epVelocity = bone.epVelocity + vel
                        }
                    }

                    //We're not in solid so we can apply physics freely now.
                    if !G2_ApplyRealBonePhysics(bone, e, params, &goalSpot, testMins, testMaxs,
                                                gravity, mass, bounce) { //if this is the case then somehow we failed to apply physics/get a good goal spot, just use the ent origin
                        goalSpot = params!.position
                    }
                }

                //Set this now so we know what to do for angle limiting
                if startSolid {
                    bone.solidCount += 1
                } else {
                    bone.solidCount = 0
                }

                //Set the desired direction based on the goal position and other factors.
                k = 0
                while k < 3 {
                    e.desiredDirection[k] = (goalSpot[k] - e.currentOrigin[k])

                    if broadsword_dircap != nil &&
                        broadsword_dircap!.value != 0 {
                        var cap: Float = broadsword_dircap!.value

                        if bone.solidCount > 5 {
                            var solidFactor: Float = bone.solidCount * 0.2

                            if solidFactor > 16.0 { //don't go too high or something ugly might happen
                                solidFactor = 16.0
                            }

                            e.desiredDirection[k] *= solidFactor
                            cap *= 8
                        }

                        if e.desiredDirection[k] > cap {
                            e.desiredDirection[k] = cap
                        } else if e.desiredDirection[k] < -cap {
                            e.desiredDirection[k] = -cap
                        }
                    }

                    e.desiredDirection[k] += (velocityMultiplier * bone.velocityEffector[k])
                    e.desiredDirection[k] += (flrand(-0.75, 0.75) * flrand(-0.75, 0.75))

                    bone.velocityEffector[k] *= velocityDampening
                    k += 1
                }
                bone.lastPosition = e.currentOrigin
                i += 1
            }
        }
    }

    return anySolid
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
    var i: Int32 = 0

    let ghoul2 = ghoul2V[g2Index]

    // Raven's `blist` is a reference to `ghoul2.mBlist`.
    // Raven's eight matrix locals are scratch slots, one closure each, and the closures stay at one indent so the body keeps Raven's shape.
    MdxaBone.scratch { N in
    MdxaBone.scratch { P in
    MdxaBone.scratch { temp1 in
    MdxaBone.scratch { temp2 in
    MdxaBone.scratch { curRot in
    MdxaBone.scratch { curRotInv in
    MdxaBone.scratch(count: 3) { Gs in
    MdxaBone.scratch(count: 3) { Enew in

    // END this is the objective function thing
    i = 0
    while i < numRags {
        // these are used for affecting the end result
        let bone = ragBoneData[i]!
        if (bone.RagFlags & RAG_PCJ) == 0 {
            i += 1
            continue // not an active ragdoll PCJ
        }
                        /* the situation is thus. (the dependent bone is in essence an effector)

                            The effector true bone matrix is:
                                Ecur = ragBones[depIndex] =
                                    EntToWorld * [skeletal heirachy1] *
                                    MyAnimMatrix * ragBasepose[i] * current_rot_matrix * ragBaseposeInv[i] *
                                    [skeletal heirachy2] * EffectorAnimMatrix * ragBasepose[depIndex]

                        My ( sub-i) true bone matrix is:
                                M = ragBones[i] = EntToWorld * [skeletal heirachry1] *
                                MyAnimMatrix * ragBasepose[i] * current_rot_matrix * ragBaseposeInv[i] * ragBasepose[i]

                            Simplifies to:
                                M = ragBones[i] = EntToWorld * [skeletal heirachry1] *
                                MyAnimMatrix * ragBasepose[i] * current_rot_matrix


                            Enew is:

                                Enew = M *
                                    inv(current_rot_matrix) * ragBaseposeInv[i] *
                                    ragBasepose[i] * new_rot_matrix * ragBaseposeInv[i] *
                                    inv(M*ragBaseposeInv[i]) * Ecur

                            We can simplify a bit:

                                Enew = M *
                                    inv(current_rot_matrix) * ragBaseposeInv[i] *
                                    ragBasepose[i] * new_rot_matrix * ragBaseposeInv[i] *
                                    ragBasepose[i] * inv(M) * Ecur

                                Enew =
                                    M * inv(current_rot_matrix) *
                                    new_rot_matrix * inv(M) * Ecur

                            We define P to be:
                                P = M * inv(current_rot_matrix)

                            We define N to be:
                                N = inv(M)

                            then it is just:

                                Enew= P * new_rot_matrix * N * Ecur

                            Ri=new_rot_matrix (for each euler angle)
                            we are gonna use three R's, so will will precompute them as Gi = P * Ri * N


                            and then Enewi= Gi * Ecur

                            we are gonna evaluate Enewi for "goodness" and accumulate changes in delAngles

                        */

        Inverse_Matrix(ragBones[i], N)  // dest 2nd arg

        var k: Int32
        var tAngles: vec3_t
        tAngles = bone.currentAngles
        Create_Matrix(tAngles, curRot)  //dest 2nd arg
        Inverse_Matrix(curRot, curRotInv)  // dest 2nd arg

        Multiply_3x4Matrix(P, ragBones[i], curRotInv) //dest first arg



        if (bone.RagFlags & RAG_PCJ_MODEL_ROOT) != 0 {
            if haveDesiredPelvisOffset {
                let magicFactor12: Float = 0.25 // dampfactor for pelvis pos
                let magicFactor13: Float = 0.20 //controls the speed of the gradient descent (pelvis pos)
                var deltaInEntitySpace = vec3_t()
                TransformPoint(desiredPelvisOffset, &deltaInEntitySpace, N) // dest middle arg
                k = 0
                while k < 3 {
                    let moveTo: Float = bone.velocityRoot[k] + deltaInEntitySpace[k] * magicFactor13
                    bone.velocityRoot[k] = (bone.velocityRoot[k] - moveTo) * magicFactor12 + moveTo
                    /*
                    if (bone.velocityRoot[k]>50.0f)
                    {
                        bone.velocityRoot[k]=50.0f;
                    }
                    if (bone.velocityRoot[k]<-50.0f)
                    {
                        bone.velocityRoot[k]=-50.0f;
                    }
                    */
                    //No -rww
                    bone.ragOverrideMatrix.matrix[k][3] = bone.velocityRoot[k]
                    k += 1
                }
            }
        } else {
            var delAngles: vec3_t
            delAngles = vec3_t()

            k = 0
            while k < 3 {
                tAngles[k] += 0.5
                Create_Matrix(tAngles, temp2)  //dest 2nd arg
                tAngles[k] -= 0.5
                Multiply_3x4Matrix(temp1, P, temp2) //dest first arg
                Multiply_3x4Matrix(Gs[k], temp1, N) //dest first arg

                k += 1
            }

            var allSolidCount: Int32 = 0//bone.solidCount;

            // fixme precompute this
            let numDep = G2_GetBoneDependents(ghoul2, bone.boneNumber, tempDependents, MAX_BONES_RAG)
            var j: Int32
            var numRagDep: Int32 = 0
            j = 0
            while j < numDep {
                //fixme why do this for the special roots?
                // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
                if !(tempDependents[j] >= 0 && tempDependents[j] < rag.count && rag[tempDependents[j]] != nil) {
                    j += 1
                    continue
                }
                let depIndex = rag[tempDependents[j]]!.ragIndex
                assert(depIndex > i) // these are supposed to be topologically sorted
                assert(ragBoneData[depIndex] != nil)
                let depBone = ragBoneData[depIndex]!
                if (depBone.RagFlags & RAG_EFFECTOR) != 0 {						// rag doll effector
                    // this is a dependent of me, and also a rag
                    numRagDep += 1
                    k = 0
                    while k < 3 {
                        Multiply_3x4Matrix(Enew[k], Gs[k], ragBones[depIndex]) //dest first arg
                        var tPosition = vec3_t()
                        tPosition[0] = Enew[k].matrix[0][3]
                        tPosition[1] = Enew[k].matrix[1][3]
                        tPosition[2] = Enew[k].matrix[2][3]

                        var change: vec3_t
                        change = tPosition - ragEffectors[depIndex].currentOrigin // dest is last arg
                        var goodness: Float = _DotProduct(change, ragEffectors[depIndex].desiredDirection)
                        goodness *= depBone.weight
                        delAngles[k] += goodness // keep bigger stuff more out of wall or something
                        k += 1
                    }
                    allSolidCount += depBone.solidCount
                }
                j += 1
            }

            //bone.solidCount = allSolidCount;
            allSolidCount += bone.solidCount

            bone.lastAngles = bone.currentAngles
            //		Update angles
            var magicFactor9: Float = 0.75 // dampfactor for angle changes
            var magicFactor1: Float = 0.40 //controls the speed of the gradient descent
            var magicFactor32: Float = 1.5
            var recip: Float = 0.0
            if numRagDep != 0 {
                recip = sqrt(4.0 / Float(numRagDep))
            }

            if allSolidCount > 32 {
                magicFactor1 = 0.6
            } else if allSolidCount > 10 {
                magicFactor1 = 0.5
            }

            if bone.overGradSpeed != 0 { //api call was made to specify a speed for this bone
                magicFactor1 = bone.overGradSpeed
            }

            let fac: Float = decay * recip * magicFactor1
            assert(fac >= 0.0)
            if ragState == ERS_DYNAMIC {
                magicFactor9 = 0.85 // we don't want this swinging radically, make the whole thing kindof unstable
            }

            //constraint breaks?
            if (bone.RagFlags & RAG_UNSNAPPABLE) != 0 {
                magicFactor32 = 1.0
            }

            k = 0
            while k < 3 {
                bone.currentAngles[k] += delAngles[k] * fac

                bone.currentAngles[k] = (bone.lastAngles[k] - bone.currentAngles[k]) * magicFactor9 + bone.currentAngles[k]
                bone.currentAngles[k] = AngleNormZero(bone.currentAngles[k])
//	bone.currentAngles[k]=flrand(bone.minAngles[k],bone.maxAngles[k]);
                //constraint breaks?
                if limitAngles && (allSolidCount < 32 || (bone.RagFlags & RAG_UNSNAPPABLE) != 0) { //32 tries and still in solid? Then we'll let you move freely
                    if !bone.snapped || (bone.RagFlags & RAG_UNSNAPPABLE) != 0 {
                        //magicFactor32 += (allSolidCount/32);

                        if bone.currentAngles[k] > bone.maxAngles[k] * magicFactor32 {
                            bone.currentAngles[k] = bone.maxAngles[k] * magicFactor32
                        }
                        if bone.currentAngles[k] < bone.minAngles[k] * magicFactor32 {
                            bone.currentAngles[k] = bone.minAngles[k] * magicFactor32
                        }
                    }
                }
                k += 1
            }

            var isSnapped = false
            k = 0
            while k < 3 {
                if bone.currentAngles[k] > bone.maxAngles[k] * magicFactor32 {
                    isSnapped = true
                    break
                }
                if bone.currentAngles[k] < bone.minAngles[k] * magicFactor32 {
                    isSnapped = true
                    break
                }
                k += 1
            }

            if isSnapped != bone.snapped {
                G2_BoneSnap(ghoul2V, bone, params)
                bone.snapped = isSnapped
            }

            Create_Matrix(bone.currentAngles, temp1)
            Multiply_3x4Matrix(temp2, temp1, bone.baseposeInv!)
            Multiply_3x4Matrix(bone.ragOverrideMatrix, bone.basepose!, temp2)
        }
        G2_Generate_MatrixRag(&ghoul2.mBlist, ragBlistIndex[bone.boneNumber])
        i += 1
    }
    }
    }
    }
    }
    }
    }
    }
    }
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
    var i: Int32 = 0

    let ghoul2 = ghoul2V[g2Index]

    // Raven's `blist` is a reference to `ghoul2.mBlist`.
    // Raven's eight matrix locals are scratch slots, one closure each, and the closures stay at one indent so the body keeps Raven's shape.
    MdxaBone.scratch { N in
    MdxaBone.scratch { P in
    MdxaBone.scratch { temp1 in
    MdxaBone.scratch { temp2 in
    MdxaBone.scratch { curRot in
    MdxaBone.scratch { curRotInv in
    MdxaBone.scratch(count: 3) { Gs in
    MdxaBone.scratch(count: 3) { Enew in

    // END this is the objective function thing
    i = 0
    while i < numRags {
        // these are used for affecting the end result
        let bone = ragBoneData[i]!

        if (bone.RagFlags & RAG_PCJ_MODEL_ROOT) != 0 {
            i += 1
            continue
        }

        if (bone.RagFlags & RAG_PCJ_IK_CONTROLLED) == 0 {
            i += 1
            continue
        }

        Inverse_Matrix(ragBones[i], N)  // dest 2nd arg

        var k: Int32
        var tAngles: vec3_t
        tAngles = bone.currentAngles
        Create_Matrix(tAngles, curRot)  //dest 2nd arg
        Inverse_Matrix(curRot, curRotInv)  // dest 2nd arg

        Multiply_3x4Matrix(P, ragBones[i], curRotInv) //dest first arg


        var delAngles: vec3_t
        delAngles = vec3_t()

        k = 0
        while k < 3 {
            tAngles[k] += 0.5
            Create_Matrix(tAngles, temp2)  //dest 2nd arg
            tAngles[k] -= 0.5
            Multiply_3x4Matrix(temp1, P, temp2) //dest first arg
            Multiply_3x4Matrix(Gs[k], temp1, N) //dest first arg
            k += 1
        }

        // fixme precompute this
        let numDep = G2_GetBoneDependents(ghoul2, bone.boneNumber, tempDependents, MAX_BONES_RAG)
        var j: Int32
        var numRagDep: Int32 = 0
        j = 0
        while j < numDep {
            //fixme why do this for the special roots?
            // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
            if !(tempDependents[j] >= 0 && tempDependents[j] < rag.count && rag[tempDependents[j]] != nil) {
                j += 1
                continue
            }
            let depIndex = rag[tempDependents[j]]!.ragIndex
            if ragBoneData[depIndex] == nil {
                j += 1
                continue
            }
            let depBone = ragBoneData[depIndex]!
            if (depBone.RagFlags & RAG_EFFECTOR) != 0 {
                // this is a dependent of me, and also a rag
                numRagDep += 1
                k = 0
                while k < 3 {
                    Multiply_3x4Matrix(Enew[k], Gs[k], ragBones[depIndex]) //dest first arg
                    var tPosition = vec3_t()
                    tPosition[0] = Enew[k].matrix[0][3]
                    tPosition[1] = Enew[k].matrix[1][3]
                    tPosition[2] = Enew[k].matrix[2][3]

                    var change: vec3_t
                    change = tPosition - ragEffectors[depIndex].currentOrigin // dest is last arg
                    var goodness: Float = _DotProduct(change, ragEffectors[depIndex].desiredDirection)
                    goodness *= depBone.weight
                    delAngles[k] += goodness // keep bigger stuff more out of wall or something
                    k += 1
                }
            }
            j += 1
        }

        bone.lastAngles = bone.currentAngles

        //		Update angles
        var magicFactor9: Float = 0.75 // dampfactor for angle changes
        var magicFactor1: Float = bone.ikSpeed //controls the speed of the gradient descent
        let magicFactor32: Float = 1.0
        var recip: Float = 0.0
        var freeThisBone = false

        if magicFactor1 == 0 {
            magicFactor1 = 0.40
        }

        recip = sqrt(4.0 / 1.0)

        let fac: Float = (decay * recip * magicFactor1)
        assert(fac >= 0.0)

        if ragState == ERS_DYNAMIC {
            magicFactor9 = 0.85 // we don't want this swinging radically, make the whole thing kindof unstable
        }


        if bone.maxAngles[0] == 0 && bone.maxAngles[1] == 0 && bone.maxAngles[2] == 0 &&
            bone.minAngles[0] == 0 && bone.minAngles[1] == 0 && bone.minAngles[2] == 0 {
            freeThisBone = true
        }

        k = 0
        while k < 3 {
            bone.currentAngles[k] += delAngles[k] * fac

            bone.currentAngles[k] = (bone.lastAngles[k] - bone.currentAngles[k]) * magicFactor9 + bone.currentAngles[k]
            bone.currentAngles[k] = AngleNormZero(bone.currentAngles[k])
            if limitAngles && !freeThisBone {
                if bone.currentAngles[k] > bone.maxAngles[k] * magicFactor32 {
                    bone.currentAngles[k] = bone.maxAngles[k] * magicFactor32
                }
                if bone.currentAngles[k] < bone.minAngles[k] * magicFactor32 {
                    bone.currentAngles[k] = bone.minAngles[k] * magicFactor32
                }
            }
            k += 1
        }
        Create_Matrix(bone.currentAngles, temp1)
        Multiply_3x4Matrix(temp2, temp1, bone.baseposeInv!)
        Multiply_3x4Matrix(bone.ragOverrideMatrix, bone.basepose!, temp2)

        G2_Generate_MatrixRag(&ghoul2.mBlist, ragBlistIndex[bone.boneNumber])
        i += 1
    }
    }
    }
    }
    }
    }
    }
    }
    }
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

    G2_Set_Bone_Rag(rmod_a!, boneName!, g2, params!.scale, params!.origin)

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
