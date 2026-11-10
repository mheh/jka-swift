import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's area of a random mission, a circle on the landscape with its spacing, its padding, its confine circle, and its look-at point.
/// `CRMAreaManager.mAreas` holds the areas, and `CRMAreaManager.MoveArea` pushes them apart.
/// Source: oracle/codemp/RMG/RM_Area.h:17
final class CRMArea {
    private var mPaddingSize: Float = 0
    private var mSpacingRadius: Float = 0
    private var mConfineRadius: Float = 0
    private var mRadius: Float = 0
    private var mAngle: Float = 0
    private var mMoveCount: Int32 = 0
    // AI: Raven's GetOrigin returns a pointer to `mOrigin`, and RM_Area.cpp:260, :271, and :329 write through it.
    // GetOrigin returns a copy, so the field is internal, and a caller that writes the vector writes the field.
    var mOrigin = JKAShared.vec3_t()
    private var mConfineOrigin = JKAShared.vec3_t()
    private var mLookAtOrigin = JKAShared.vec3_t()
    private var mCollision: Bool = false
    private var mFlatten: Bool = false
    private var mLookAt: Bool = false
    private var mLockOrigin: Bool = false
    private var mSymmetric: Int32 = 0

    /**
    ```
    ************************************************************************************************
     * CRMArea::CRMArea
     *	constructor
     *
     * inputs:
     *  none
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Area.cpp:29
    init(_ spacingRadius: Float, _ paddingSize: Float, _ confineRadius: Float, _ confineOrigin: JKAShared.vec3_t, _ lookAtOrigin: JKAShared.vec3_t, _ flatten: Bool = true, _ symmetric: Int32 = 0) {
        self.mMoveCount = 0
        self.mAngle = 0
        self.mCollision = true
        self.mConfineRadius = confineRadius
        self.mPaddingSize = paddingSize
        self.mSpacingRadius = spacingRadius
        self.mFlatten = flatten
        self.mLookAt = true
        self.mLockOrigin = false
        self.mSymmetric = symmetric
        self.mRadius = spacingRadius

        _VectorCopy(confineOrigin, &self.mConfineOrigin)
        _VectorCopy(lookAtOrigin, &self.mLookAtOrigin)
    }

    /**
    ```
    ************************************************************************************************
     * CRMArea::LookAt
     *	Angle the area towards the given point
     *
     * inputs:
     *  lookat - the origin to look at
     *
     * return:
     *	the angle in radians that was calculated
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Area.cpp:66
    @discardableResult
    func LookAt(_ lookat: JKAShared.vec3_t) -> Float {
        if self.mLookAt {
            // this area orients itself towards a point
            var a = JKAShared.vec3_t()

            _VectorCopy(lookat, &self.mLookAtOrigin)
            _VectorSubtract(lookat, self.mOrigin, &a)

            self.mAngle = atan2(a[1], a[0])
        }

        return self.mAngle
    }

    /**
    ```
    ************************************************************************************************
     * CRMArea::Mirror
     *	Mirrors the area to the other side of the map.  This includes mirroring the confine origin
     *  and lookat origin
     *
     * inputs:
     *  none
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Area.cpp:93
    func Mirror() {
        self.mOrigin[0] = -self.mOrigin[0]
        self.mOrigin[1] = -self.mOrigin[1]

        self.mConfineOrigin[0] = -self.mConfineOrigin[0]
        self.mConfineOrigin[1] = -self.mConfineOrigin[1]

        self.mLookAtOrigin[0] = -self.mLookAtOrigin[0]
        self.mLookAtOrigin[1] = -self.mLookAtOrigin[1]
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:42
    func SetOrigin(_ origin: JKAShared.vec3_t) {
        _VectorCopy(origin, &self.mOrigin)
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:43
    func SetAngle(_ angle: Float) {
        self.mAngle = angle
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:44
    func SetSymmetric(_ sym: Int32) {
        self.mSymmetric = sym
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:46
    func EnableCollision(_ e: Bool) {
        self.mCollision = e
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:47
    func EnableLookAt(_ la: Bool) {
        self.mLookAt = la
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:50
    func LockOrigin() {
        self.mLockOrigin = true
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:52
    func AddMoveCount() {
        self.mMoveCount += 1
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:53
    func ClearMoveCount() {
        self.mMoveCount = 0
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:55
    func GetPaddingSize() -> Float {
        self.mPaddingSize
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:56
    func GetSpacingRadius() -> Float {
        self.mSpacingRadius
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:57
    func GetRadius() -> Float {
        self.mRadius
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:58
    func GetConfineRadius() -> Float {
        self.mConfineRadius
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:59
    func GetAngle() -> Float {
        self.mAngle
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:60
    func GetMoveCount() -> Int32 {
        self.mMoveCount
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:61
    // AI: Raven returns a pointer to `mOrigin`. The method returns a copy, and a write goes to the field.
    func GetOrigin() -> JKAShared.vec3_t {
        self.mOrigin
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:62
    // AI: Raven returns a pointer to `mConfineOrigin`. The method returns a copy, because no caller writes through it.
    func GetConfineOrigin() -> JKAShared.vec3_t {
        self.mConfineOrigin
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:63
    // AI: Raven returns a pointer to `mLookAtOrigin`. The method returns a copy, because no caller writes through it.
    func GetLookAtOrigin() -> JKAShared.vec3_t {
        self.mLookAtOrigin
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:64
    func GetLookAt() -> Bool {
        self.mLookAt
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:65
    func GetLockOrigin() -> Bool {
        self.mLockOrigin
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:66
    func GetSymmetric() -> Int32 {
        self.mSymmetric
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:68
    func SetRadius(_ r: Float) {
        self.mRadius = r
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:70
    func IsCollisionEnabled() -> Bool {
        self.mCollision
    }

    /// Source: oracle/codemp/RMG/RM_Area.h:71
    func IsFlattened() -> Bool {
        self.mFlatten
    }
}
