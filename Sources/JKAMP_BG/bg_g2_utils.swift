import Foundation
import JKAMP
import JKAShared

/// Source: oracle/codemp/game/bg_g2_utils.c:100
let MAX_VARIANTS = 8 as Int32

/// Source: oracle/codemp/game/bg_g2_utils.c:25
public func BG_AttachToRancor(_ ghoul2: OpaquePointer?, _ rancYaw: Float, _ rancOrigin: inout JKAShared.vec3_t, _ time: Int32, _ modelList: Slots<qhandle_t>?, _ modelScale: inout JKAShared.vec3_t, _ inMouth: Bool, _ out_origin: inout JKAShared.vec3_t, _ out_angles: inout JKAShared.vec3_t, _ out_axis: inout [JKAShared.vec3_t]?) {
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        var boltIndex: Int32 = 0
        var rancAngles = vec3_t()
        var temp_angles = vec3_t()
        // Getting the bolt here
        if inMouth {
            //in mouth
            boltIndex = trap_G2API_AddBolt(ghoul2, 0, "jaw_bone")
        } else {
            //in right hand
            boltIndex = trap_G2API_AddBolt(ghoul2, 0, "*r_hand")
        }
        rancAngles = vec3_t(0, rancYaw, 0)
        trap_G2API_GetBoltMatrix(ghoul2, 0, boltIndex, boltMatrix, rancAngles, rancOrigin, time, modelList, &modelScale)
        // Storing ent position, bolt position, and bolt axis
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &out_origin)
        if out_axis != nil {
            if inMouth {
                //in mouth
                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_Z, &out_axis![0])
                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &out_axis![1])
                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_X, &out_axis![2])
            } else {
                //in hand
                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &out_axis![0])
                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_X, &out_axis![1])
                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_Z, &out_axis![2])
            }
            //FIXME: this is messing up our axis and turning us inside-out?
            vectoangles(out_axis![0], &out_angles)
            vectoangles(out_axis![2], &temp_angles)
            out_angles[ROLL] = -temp_angles[PITCH]
        } else {
            var temp_axis = [vec3_t](repeating: vec3_t(), count: 3)
            if inMouth {
                //in mouth
                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_Z, &temp_axis[0])
                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_X, &temp_axis[2])
            } else {
                //in hand
                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &temp_axis[0])
                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_Z, &temp_axis[2])
            }
            //FIXME: this is messing up our axis and turning us inside-out?
            vectoangles(temp_axis[0], &out_angles)
            vectoangles(temp_axis[2], &temp_angles)
            out_angles[ROLL] = -temp_angles[PITCH]
        }
    }
}

/// A caller that passes an axis for `out_axis` reaches `BG_AttachToRancor` through this forward, and a NULL caller passes the optional.
/// Source: oracle/codemp/game/bg_g2_utils.c:25
public func BG_AttachToRancor(_ ghoul2: OpaquePointer?, _ rancYaw: Float, _ rancOrigin: inout JKAShared.vec3_t, _ time: Int32, _ modelList: Slots<qhandle_t>?, _ modelScale: inout JKAShared.vec3_t, _ inMouth: Bool, _ out_origin: inout JKAShared.vec3_t, _ out_angles: inout JKAShared.vec3_t, _ out_axis: inout [JKAShared.vec3_t]) {
    var optionalAxis: [JKAShared.vec3_t]? = out_axis
    defer { out_axis = optionalAxis! }
    BG_AttachToRancor(ghoul2, rancYaw, &rancOrigin, time, modelList, &modelScale, inMouth, &out_origin, &out_angles, &optionalAxis)
}

/// Source: oracle/codemp/game/bg_g2_utils.c:101
public func BG_GetRootSurfNameWithVariant(_ ghoul2: OpaquePointer?, _ rootSurfName: String, _ returnSurfName: inout JKAShared.CharBuf, _ returnSize: Int32) -> Bool {
    if ghoul2 == nil || trap_G2API_GetSurfaceRenderStatus(ghoul2, 0, rootSurfName) == 0 {
        //see if the basic name without variants is on
        Q_strncpyz(&returnSurfName, rootSurfName, returnSize)
        return true
    } else {
        //check variants
        var i: Int32
        i = 0
        while i < MAX_VARIANTS {
            Com_sprintf(&returnSurfName, returnSize, "%s%c", rootSurfName, Int32(ascii: "a") + i)
            if trap_G2API_GetSurfaceRenderStatus(ghoul2, 0, String(returnSurfName)) == 0 {
                return true
            }
            i += 1
        }
    }
    Q_strncpyz(&returnSurfName, rootSurfName, returnSize)
    return false
}
