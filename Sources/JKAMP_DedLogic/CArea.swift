import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's flattened area of a random terrain, a circle on the landscape with its type and its angle.
/// `CCMLandScape.mAreas` holds every area, and the random mission places its instances in them.
/// Source: oracle/codemp/qcommon/cm_landscape.h:42
// AI: Raven's destructor at cm_landscape.h:53 has an empty body. The class has no deinit.
public final class CArea {
    // AI: Raven's GetPosition returns a reference to `mPosition`, and RM_Mission.cpp:1579 writes through it.
    // GetPosition returns a copy, so the field is internal, and a caller that writes the vector writes the field.
    var mPosition = JKAShared.vec3_t()
    private var mRadius: Float = 0
    private var mAngle: Float = 0
    private var mAngleDiff: Float = 0
    private var mType: Int32 = 0
    private var mVillageID: Int32 = 0

    /// Source: oracle/codemp/qcommon/cm_landscape.h:52
    init() {}

    /// Source: oracle/codemp/qcommon/cm_landscape.h:55
    func Init(_ pos: JKAShared.vec3_t, _ radius: Float, _ angle: Float = 0.0, _ type: Int32 = AT_NONE, _ angleDiff: Float = 0.0, _ villageID: Int32 = 0) {
        self.mPosition = pos
        self.mRadius = radius
        self.mAngle = angle
        self.mAngleDiff = angleDiff
        self.mType = type
        self.mVillageID = villageID
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:64
    func GetRadius() -> Float {
        self.mRadius
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:65
    func GetAngle() -> Float {
        self.mAngle
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:66
    func GetAngleDiff() -> Float {
        self.mAngleDiff
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:67
    // AI: Raven returns a reference to `mPosition`. The method returns a copy, and a write goes to the field.
    func GetPosition() -> JKAShared.vec3_t {
        self.mPosition
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:68
    func GetType() -> Int32 {
        self.mType
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:69
    func GetVillageID() -> Int32 {
        self.mVillageID
    }
}
