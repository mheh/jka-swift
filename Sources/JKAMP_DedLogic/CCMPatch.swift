import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's collision patch of a terrain, one block of terxels with its corner heights, its bounds, and its brushes.
/// `CCMLandScape.mPatches` holds one per block, and the trace of a terrain brush walks the brushes of each patch.
/// Source: oracle/codemp/qcommon/cm_landscape.h:90
// AI: Raven's destructor at cm_terrain.cpp:112 has an empty body. The class has no deinit.
final class CCMPatch {
    // AI: Raven holds the owner as a pointer. The field is weak, because the landscape holds every patch in its array.
    private weak var owner: CCMLandScape? = nil										// Owning landscape
    private var mHx: Int32 = 0
    private var mHy: Int32 = 0									// Terxel coords of patch
    // AI: Raven points into the height map of the owner at cm_terrain.cpp:538. The field is the Slots over the bytes from that sample.
    private var mHeightMap: Slots<JKAShared.byte>? = nil				 				// Pointer to height map to use
    // AI: Raven declares `byte mCornerHeights[4]`. The field is an Array of the four bytes, rule 17.
    private var mCornerHeights: [JKAShared.byte] = [0, 0, 0, 0] 							// Heights at the corners of the patch
    private var mWorldCoords = JKAShared.vec3_t()				 				// World coordinate offset of this patch.
    private var mBounds: [JKAShared.vec3_t] = [JKAShared.vec3_t(), JKAShared.vec3_t()]									// mins and maxs of the patch for culling
    private var mNumBrushes: Int32 = 0								// number of brushes to collide with in the patch
    // AI: Raven points at the brushes of the patch in the brush block of the owner, cm_terrain.cpp:588, and steps through them.
    // The field is the Slots over the brushes, the form of `facets` of cm_patch.cpp in rulings.py TYPES.
    private var mPatchBrushData: Slots<Cbrush>? = nil							// List of brushes that make up the patch
    private var mSurfaceFlags: Int32 = 0								// surfaceflag of the heightshader
    private var mContentFlags: Int32 = 0								// contents of the heightshader

    // Constructors
    /// Source: oracle/codemp/qcommon/cm_landscape.h:105
    init() {}

    // Accessors
    /// Source: oracle/codemp/qcommon/cm_landscape.h:109
    func GetWorld() -> JKAShared.vec3_t {
        self.mWorldCoords
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:110
    func GetMins() -> JKAShared.vec3_t {
        self.mBounds[0]
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:111
    func GetMaxs() -> JKAShared.vec3_t {
        self.mBounds[1]
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:112
    func GetBounds() -> [JKAShared.vec3_t] {
        self.mBounds
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:113
    func GetHeightMapX() -> Int32 {
        self.mHx
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:114
    func GetHeightMapY() -> Int32 {
        self.mHy
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:115
    // C widens the unsigned byte to `int` at the return.
    func GetHeight(_ corner: Int32) -> Int32 {
        Int32(self.mCornerHeights[corner])
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:116
    func GetNumBrushes() -> Int32 {
        self.mNumBrushes
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:117
    func GetCollisionData() -> Slots<Cbrush>? {
        self.mPatchBrushData
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:119
    func SetSurfaceFlags(_ `in`: Int32) {
        self.mSurfaceFlags = `in`
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:120
    func GetSurfaceFlags() -> Int32 {
        self.mSurfaceFlags
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:121
    func SetContents(_ `in`: Int32) {
        self.mContentFlags = `in`
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:122
    func GetContents() -> Int32 {
        self.mContentFlags
    }

    // Prototypes
    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:524
    // AI: Raven passes the brush block of the owner as `byte *` and casts it to `cbrush_t *` at cm_terrain.cpp:588. The parameter is the Slots over the brushes.
    func Init(_ ls: CCMLandScape?, _ heightX: Int32, _ heightY: Int32, _ world: JKAShared.vec3_t, _ hMap: Slots<JKAShared.byte>?, _ patchBrushData: Slots<Cbrush>?) {
        // TODO: Port CCMPatch::Init
        portMissing("CCMPatch::Init", source: "oracle/codemp/qcommon/cm_terrain.cpp:524")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:223
    func InitPlane(_ side: Cbrushside?, _ plane: JKAShared.Cplane?, _ p0: JKAShared.vec3_t, _ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) {
        // TODO: Port CCMPatch::InitPlane
        portMissing("CCMPatch::InitPlane", source: "oracle/codemp/qcommon/cm_terrain.cpp:223")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:302
    func CreatePatchPlaneData() {
        // TODO: Port CCMPatch::CreatePatchPlaneData
        portMissing("CCMPatch::CreatePatchPlaneData", source: "oracle/codemp/qcommon/cm_terrain.cpp:302")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:272
    // AI: Raven returns a `cbrush_t *` as `void *`, and both callers cast it back at cm_terrain.cpp:461 and :483. The method returns the view, the RETURNS kind `view`.
    func GetAdjacentBrushX(_ x: Int32, _ y: Int32) -> Cbrush? {
        // TODO: Port CCMPatch::GetAdjacentBrushX
        portMissing("CCMPatch::GetAdjacentBrushX", source: "oracle/codemp/qcommon/cm_terrain.cpp:272")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:246
    // AI: Raven returns a `cbrush_t *` as `void *`. The method returns the view, the form of GetAdjacentBrushX.
    func GetAdjacentBrushY(_ x: Int32, _ y: Int32) -> Cbrush? {
        // TODO: Port CCMPatch::GetAdjacentBrushY
        portMissing("CCMPatch::GetAdjacentBrushY", source: "oracle/codemp/qcommon/cm_terrain.cpp:246")
    }
}
