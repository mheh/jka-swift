import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's area manager of a random mission, the areas inside the legal bounds of the landscape.
/// `CRMMission` makes one over the landscape bounds less 10 percent on each side, and `MoveArea` pushes apart the areas that collide.
/// Source: oracle/codemp/RMG/RM_Area.h:76
final class CRMAreaManager {
    // AI: Raven declares `rmAreaVector_t`, a `vector<CRMArea*>`. The field is an Array of the optional class, rule 17.
    private var mAreas: [CRMArea?] = []
    private var mMins = JKAShared.vec3_t()
    private var mMaxs = JKAShared.vec3_t()
    private var mWidth: Float = 0
    private var mHeight: Float = 0

    /**
    ```
    ************************************************************************************************
     * CRMAreaManager::CRMAreaManager
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
    /// Source: oracle/codemp/RMG/RM_Area.cpp:116
    init(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) {
        _VectorCopy(mins, &self.mMins)
        _VectorCopy(maxs, &self.mMaxs)

        self.mWidth = self.mMaxs[0] - self.mMins[0]
        self.mHeight = self.mMaxs[1] - self.mMins[1]
    }

    /**
    ```
    ************************************************************************************************
     * CRMAreaManager::~CRMAreaManager
     *	Removes all managed areas
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
    /// Source: oracle/codemp/RMG/RM_Area.cpp:136
    deinit {
        // AI: Raven deletes each area from the last index to the first. The clear below frees them.
        self.mAreas.removeAll()
    }

    /**
    ```
    ************************************************************************************************
     * CRMAreaManager::MoveArea
     *	Moves an area within the area manager thus shifting any other areas as needed
     *
     * inputs:
     *  area   - area to be moved
     *  origin - new origin to attempt to move to
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Area.cpp:160
    func MoveArea(_ movedArea: CRMArea?, _ origin: inout JKAShared.vec3_t) {
        var index: Int32
        var size: Int32

        // Increment the addcount (this is for infinite protection)
        movedArea!.AddMoveCount()

        // Infinite recursion prevention
        if movedArea!.GetMoveCount() > 250 {
            //		assert ( 0 );
            movedArea!.EnableCollision(false)
            return
        }

        // First set the area's origin, This may cause it to be in collision with
        // another area but that will get fixed later
        movedArea!.SetOrigin(origin)

        // when symmetric we want to ensure that no instances end up on the "other" side of the imaginary diaganol that cuts the map in two
        // mSymmetric tells us which side of the map is legal
        if movedArea!.GetSymmetric() != 0 {
            let bounds = TheRandomMissionManager!.GetLandScape()!.GetBounds()

            var point = JKAShared.vec3_t()
            var dir = JKAShared.vec3_t()
            var tang = JKAShared.vec3_t()
            var push: Bool
            var len: Float

            _VectorSubtract(movedArea!.GetOrigin(), bounds[0], &point)
            _VectorSubtract(bounds[1], bounds[0], &dir)
            _ = VectorNormalize(&dir)

            dir[2] = 0
            point[2] = 0
            _VectorMA(bounds[0], _DotProduct(point, dir), dir, &tang)
            _VectorSubtract(movedArea!.GetOrigin(), tang, &dir)

            dir[2] = 0
            push = false
            len = VectorNormalize(&dir)

            if len < movedArea!.GetRadius() {
                if movedArea!.GetLockOrigin() {
                    movedArea!.EnableCollision(false)
                    return
                }

                // Raven's VectorMA is the header macro of q_shared.h:1367, which evaluates the scale and its irand once per element.
                // C converts the `float` radius to the `int` parameter of irand, and the `int` result to `float` at the add.
                point[0] = point[0] + dir[0] * ((movedArea!.GetSpacingRadius() - len) + Float(TheRandomMissionManager!.GetLandScape()!.irand(10, Int32(movedArea!.GetSpacingRadius()))))
                point[1] = point[1] + dir[1] * ((movedArea!.GetSpacingRadius() - len) + Float(TheRandomMissionManager!.GetLandScape()!.irand(10, Int32(movedArea!.GetSpacingRadius()))))
                point[2] = point[2] + dir[2] * ((movedArea!.GetSpacingRadius() - len) + Float(TheRandomMissionManager!.GetLandScape()!.irand(10, Int32(movedArea!.GetSpacingRadius()))))
                origin[0] = point[0] + bounds[0][0]
                origin[1] = point[1] + bounds[0][1]
                movedArea!.SetOrigin(origin)
            }

            switch movedArea!.GetSymmetric() {
            case SYMMETRY_TOPLEFT:
                if origin[1] > origin[0] {
                    movedArea!.Mirror()
                }

            case SYMMETRY_BOTTOMRIGHT:
                if origin[1] < origin[0] {
                    movedArea!.Mirror()
                }

            default:
                // unknown symmetry type
                assert(false)
            }
        }

        // Confine to area unless we are being pushed back by the same guy who pushed us last time (infinite loop)
        if movedArea!.GetConfineRadius() != 0 {
            if movedArea!.GetMoveCount() < 25 {
                var cdiff = JKAShared.vec3_t()
                var cdist: Float

                _VectorSubtract(movedArea!.GetOrigin(), movedArea!.GetConfineOrigin(), &cdiff)
                cdiff[2] = 0
                cdist = VectorLength(cdiff)

                if cdist + movedArea!.GetSpacingRadius() > movedArea!.GetConfineRadius() {
                    cdist = movedArea!.GetConfineRadius() - movedArea!.GetSpacingRadius()
                    _ = VectorNormalize(&cdiff)

                    // AI: Raven writes through the pointer that GetOrigin returns. The write goes to the field.
                    _VectorMA(movedArea!.GetConfineOrigin(), cdist, cdiff, &movedArea!.mOrigin)
                }
            } else {
                index = 0
            }
        }

        // See if it fell off the world in the x direction
        // AI: Raven writes through the pointer that GetOrigin returns. Each write below goes to the field.
        // C converts the `int` result of irand to `float` at the subtract and the add.
        if movedArea!.GetOrigin()[0] + movedArea!.GetSpacingRadius() > self.mMaxs[0] {
            movedArea!.mOrigin[0] = self.mMaxs[0] - movedArea!.GetSpacingRadius() - Float(TheRandomMissionManager!.GetLandScape()!.irand(10, 200))
        } else if movedArea!.GetOrigin()[0] - movedArea!.GetSpacingRadius() < self.mMins[0] {
            movedArea!.mOrigin[0] = self.mMins[0] + movedArea!.GetSpacingRadius() + Float(TheRandomMissionManager!.GetLandScape()!.irand(10, 200))
        }

        // See if it fell off the world in the y direction
        if movedArea!.GetOrigin()[1] + movedArea!.GetSpacingRadius() > self.mMaxs[1] {
            movedArea!.mOrigin[1] = self.mMaxs[1] - movedArea!.GetSpacingRadius() - Float(TheRandomMissionManager!.GetLandScape()!.irand(10, 200))
        } else if movedArea!.GetOrigin()[1] - movedArea!.GetSpacingRadius() < self.mMins[1] {
            movedArea!.mOrigin[1] = self.mMins[1] + movedArea!.GetSpacingRadius() + Float(TheRandomMissionManager!.GetLandScape()!.irand(10, 200))
        }

        // Look at what we need to look at
        movedArea!.LookAt(movedArea!.GetLookAtOrigin())

        // Dont collide against things that have no collision
        //	if ( !movedArea->IsCollisionEnabled ( ) )
        //	{
        //		return;
        //	}

        // See if its colliding
        index = 0
        // C converts the `size_t` count to the `int` local.
        size = Int32(self.mAreas.count)
        while index < size {
            let area = self.mAreas[index]
            var diff = JKAShared.vec3_t()
            var newOrigin = JKAShared.vec3_t()
            var dist: Float
            var targetdist: Float

            // Skip the one that was moved in the first place
            if area === movedArea {
                index += 1
                continue
            }

            if area!.GetLockOrigin() && movedArea!.GetLockOrigin() {
                index += 1
                continue
            }

            // Dont collide against things that have no collision
            if !area!.IsCollisionEnabled() {
                index += 1
                continue
            }

            // Grab the distance between the two
            // only want the horizontal distance -- dmv
            //dist		= Distance ( movedArea->GetOrigin ( ), area->GetOrigin ( ));
            var maOrigin = JKAShared.vec3_t()
            var aOrigin = JKAShared.vec3_t()
            _VectorCopy(movedArea!.GetOrigin(), &maOrigin)
            _VectorCopy(area!.GetOrigin(), &aOrigin)
            aOrigin[2] = 0
            maOrigin[2] = aOrigin[2]
            dist = Distance(maOrigin, aOrigin)
            // Raven's maximum is the header macro of q_shared.h:1355.
            targetdist = movedArea!.GetSpacingRadius() + area!.GetSpacingRadius() + (movedArea!.GetPaddingSize() > area!.GetPaddingSize() ? movedArea!.GetPaddingSize() : area!.GetPaddingSize())

            if dist == 0 {
                // AI: Raven writes through the pointer that GetOrigin returns. Each write goes to the field.
                // C converts the `int` result of irand to `float` by the cast.
                area!.mOrigin[0] += (50 * Float(TheRandomMissionManager!.GetLandScape()!.irand(0, 99)) / 100.0)
                area!.mOrigin[1] += (50 * Float(TheRandomMissionManager!.GetLandScape()!.irand(0, 99)) / 100.0)

                _VectorCopy(area!.GetOrigin(), &aOrigin)
                aOrigin[2] = 0

                dist = Distance(maOrigin, aOrigin)
            }

            // Are they are enough apart?
            if dist >= targetdist {
                index += 1
                continue
            }

            // Dont move a step if locked
            if area!.GetLockOrigin() {
                // AI: Raven passes the pointer to the area's own origin. The call passes a copy, because the inout parameter cannot alias the field that MoveArea writes.
                var areaOrigin = area!.GetOrigin()
                self.MoveArea(area, &areaOrigin)
                index += 1
                continue
            }

            // we got a collision, move the guy we hit
            _VectorSubtract(area!.GetOrigin(), movedArea!.GetOrigin(), &diff)
            diff[2] = 0
            _ = VectorNormalize(&diff)

            // Push by the difference in the distance and no-collide radius
            _VectorMA(area!.GetOrigin(), targetdist - dist + 1, diff, &newOrigin)

            // Move the area now
            self.MoveArea(area, &newOrigin)
            index += 1
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMAreaManager::CreateArea
     *	Creates an area and adds it to the list of managed areas
     *
     * inputs:
     *  none
     *
     * return:
     *	a pointer to the newly added area class
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Area.cpp:375
    @discardableResult
    func CreateArea(_ origin: inout JKAShared.vec3_t, _ spacingRadius: Float, _ spacingLine: Int32, _ paddingSize: Float, _ confineRadius: Float, _ confineOrigin: JKAShared.vec3_t, _ lookAtOrigin: JKAShared.vec3_t, _ flatten: Bool = true, _ collide: Bool = true, _ lockorigin: Bool = false, _ symmetric: Int32 = 0) -> CRMArea? {
        let area: CRMArea? = CRMArea(spacingRadius, paddingSize, confineRadius, confineOrigin, lookAtOrigin, flatten, symmetric)

        if lockorigin || spacingLine != 0 {
            area!.LockOrigin()
        }

        if origin[0] != lookAtOrigin[0] || origin[1] != lookAtOrigin[1] {
            area!.EnableLookAt(true)
        }

        // First add the area to the list
        self.mAreas.append(area)

        area!.EnableCollision(collide)

        // Set the real radius which is used for center line detection
        if spacingLine != 0 {
            // C converts the `int` count to `float` at the multiply.
            area!.SetRadius(spacingRadius + Float(spacingLine - 1) * spacingRadius)
        }

        // Now move the area around
        self.MoveArea(area, &origin)

        if (origin[0] != lookAtOrigin[0] || origin[1] != lookAtOrigin[1]) {
            var i: Int32
            var linedir = JKAShared.vec3_t()
            var dir = JKAShared.vec3_t()
            let up = JKAShared.vec3_t(0, 0, 1)

            _VectorSubtract(lookAtOrigin, origin, &dir)
            _ = VectorNormalize(&dir)
            dir[2] = 0
            CrossProduct(dir, up, &linedir)

            i = 0
            while i < spacingLine - 1 {
                var linearea: CRMArea?
                var lineorigin = JKAShared.vec3_t()

                linearea = CRMArea(spacingRadius, paddingSize, 0, vec3_origin, vec3_origin, false, symmetric)
                linearea!.LockOrigin()
                linearea!.EnableCollision(collide)

                // C converts the `int` index to `float` at the multiply.
                _VectorMA(origin, spacingRadius + (spacingRadius * 2 * Float(i)), linedir, &lineorigin)
                self.mAreas.append(linearea)
                self.MoveArea(linearea, &lineorigin)

                linearea = CRMArea(spacingRadius, paddingSize, 0, vec3_origin, vec3_origin, false, symmetric)
                linearea!.LockOrigin()
                linearea!.EnableCollision(collide)

                // C converts the `int` index to `float` at the multiply.
                _VectorMA(origin, -spacingRadius - (spacingRadius * 2 * Float(i)), linedir, &lineorigin)
                self.mAreas.append(linearea)
                self.MoveArea(linearea, &lineorigin)
                i += 1
            }
        }

        // Return it for convienience
        return area
    }

    /**
    ```
    ************************************************************************************************
     * CRMAreaManager::EnumArea
     *	Allows for enumeration through the area list. If an invalid index is given then NULL will
     *  be returned;
     *
     * inputs:
     *  index - current enumeration index
     *
     * return:
     *	requested area class pointer or NULL if the index was invalid
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Area.cpp:464
    func EnumArea(_ index: Int32) -> CRMArea? {
        // This isnt an assertion case because there is no size method for
        // the area manager so the areas are enumerated until NULL is returned.
        if index < 0 || index >= self.mAreas.count {
            return nil
        }

        return self.mAreas[index]
    }
}
