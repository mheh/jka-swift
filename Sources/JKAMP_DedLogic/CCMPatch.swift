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
        var min: Int32
        var max: Int32
        var x: Int32
        var y: Int32
        var height: Int32

        // Set owning landscape
        self.owner = ls

        // Store the base of the top left corner
        self.mWorldCoords = world

        // Store pointer to first byte of the height data for this patch.
        self.mHx = heightX
        self.mHy = heightY
        self.mHeightMap = hMap!.suffix(from: (heightY * self.owner!.GetRealWidth()) + heightX)

        // Calculate the bounds for culling
        // Use the dimensions 1 terxel outside the patch to allow for sloping of edge terxels
        min = 256
        max = -1
        y = heightY - 1
        while y < heightY + self.owner!.GetTerxels() + 1 {
            if y >= 0 {
                x = heightX - 1
                while x < heightX + self.owner!.GetTerxels() + 1 {
                    if x >= 0 {
                        // C widens the unsigned byte to `int` at the store.
                        height = Int32(hMap![(y * self.owner!.GetRealWidth()) + x])

                        if height > max {
                            max = height
                        }
                        if height < min {
                            min = height
                        }
                    }
                    x += 1
                }
            }
            y += 1
        }

        // Mins
        self.mBounds[0][0] = world[0]
        self.mBounds[0][1] = world[1]
        self.mBounds[0][2] = world[2] + (min * self.owner!.GetTerxelSize()[2])

        // Maxs
        self.mBounds[1][0] = world[0] + (self.owner!.GetPatchSize()[0])
        self.mBounds[1][1] = world[1] + (self.owner!.GetPatchSize()[1])
        self.mBounds[1][2] = world[2] + (max * self.owner!.GetTerxelSize()[2])

        // Corner heights
        self.mCornerHeights[0] = self.mHeightMap![0]
        self.mCornerHeights[1] = self.mHeightMap![self.owner!.GetTerxels()]
        self.mCornerHeights[2] = self.mHeightMap![self.owner!.GetTerxels() * self.owner!.GetRealWidth()]
        self.mCornerHeights[3] = self.mHeightMap![(self.owner!.GetTerxels() * self.owner!.GetRealWidth()) + self.owner!.GetTerxels()]

        // Set the surfaceFlags using average height (may want a more complex algo here)
        self.mSurfaceFlags = self.owner!.GetSurfaceFlags((min + max) >> 1)
        self.mContentFlags = self.owner!.GetContentFlags((min + max) >> 1)

        // Set base of brush data from big array
        self.mPatchBrushData = patchBrushData
        self.CreatePatchPlaneData()
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:223
    func InitPlane(_ side: Cbrushside?, _ plane: JKAShared.Cplane?, _ p0: JKAShared.vec3_t, _ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) {
        var dx = JKAShared.vec3_t()
        var dy = JKAShared.vec3_t()

        dx = p1 - p0
        dy = p2 - p0
        CrossProduct(dx, dy, &plane!.normal)
        VectorNormalize(&plane!.normal)

        plane!.dist = _DotProduct(p0, plane!.normal)
        plane!.type = PlaneTypeForNormal(plane!.normal)
        // AI: Raven hands the `cplane_t *` to SetPlaneSignbits. The value function of q_math takes the plane read out of the slot, and `apply` writes it back.
        var signPlane = plane!.plane
        SetPlaneSignbits(&signPlane)
        plane!.apply(signPlane)

        side!.plane = plane
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:302
    func CreatePatchPlaneData() {
        var realWidth: Int32
        var x: Int32
        var y: Int32
        var i: Int32
        var j: Int32
        var brush: Slots<Cbrush>
        var side: Slots<Cbrushside>
        var plane: Slots<JKAShared.Cplane>
        var coords: Slots<JKAShared.vec3_t>?
        var localCoords = [JKAShared.vec3_t](repeating: JKAShared.vec3_t(), count: 8)

        self.mNumBrushes = self.owner!.GetTerxels() * self.owner!.GetTerxels() * 2
        realWidth = self.owner!.GetRealWidth()
        coords = self.owner!.GetCoords()

        brush = self.mPatchBrushData!
        // AI: Raven casts the bytes after the brushes to a side pointer and a plane pointer with no bound.
        // Each Slots takes the count of its part of the patch block, the size of cm_terrain.cpp:214.
        side = Slots<Cbrushside>(self.mPatchBrushData!.suffix(from: self.mNumBrushes).base, count: self.mNumBrushes * BRUSH_SIDES_PER_TERXEL * 2)
        plane = Slots<JKAShared.Cplane>(side.suffix(from: self.mNumBrushes * BRUSH_SIDES_PER_TERXEL * 2).base, count: self.mNumBrushes * BRUSH_SIDES_PER_TERXEL * 2)
        y = self.mHy
        while y < self.mHy + self.owner!.GetTerxels() {
            x = self.mHx
            while x < self.mHx + self.owner!.GetTerxels() {
                var offsets = [Int32](repeating: 0, count: 4)

                if ((x + y) & 1) != 0 {
                    offsets[0] = (y * realWidth) + x				// TL
                    offsets[1] = (y * realWidth) + x + 1			// TR
                    offsets[2] = ((y + 1) * realWidth) + x			// BL
                    offsets[3] = ((y + 1) * realWidth) + x + 1		// BR
                } else {
                    offsets[2] = (y * realWidth) + x				// TL
                    offsets[0] = (y * realWidth) + x + 1			// TR
                    offsets[3] = ((y + 1) * realWidth) + x			// BL
                    offsets[1] = ((y + 1) * realWidth) + x + 1		// BR
                }

                i = 0
                while i < 4 {
                    localCoords[i] = coords![offsets[i]]
                    localCoords[i + 4] = coords![offsets[i]]
                    // Set z of base of brush to bottom of landscape brush
                    localCoords[i + 4][2] = self.owner!.GetMins()[2]
                    i += 1
                }

                // Set the bounds of the terxel
                brush[0].bounds[0] = JKAShared.vec3_t(Float(MAX_WORLD_COORD), Float(MAX_WORLD_COORD), Float(MAX_WORLD_COORD))
                brush[0].bounds[1] = JKAShared.vec3_t(Float(MIN_WORLD_COORD), Float(MIN_WORLD_COORD), Float(MIN_WORLD_COORD))

                i = 0
                while i < 8 {
                    j = 0
                    while j < 3 {
                        // mins
                        if localCoords[i][j] < brush[0].bounds[0][j] {
                            brush[0].bounds[0][j] = localCoords[i][j]
                        }
                        // maxs
                        if localCoords[i][j] > brush[0].bounds[1][j] {
                            brush[0].bounds[1][j] = localCoords[i][j]
                        }
                        j += 1
                    }
                    i += 1
                }
                // Raven's VectorDec and VectorInc macros of q_shared.h expand here, because the port has no function for them.
                brush[0].bounds[0][0] -= 1.0
                brush[0].bounds[0][1] -= 1.0
                brush[0].bounds[0][2] -= 1.0
                brush[0].bounds[1][0] += 1.0
                brush[0].bounds[1][1] += 1.0
                brush[0].bounds[1][2] += 1.0
                brush[1].bounds[0] = brush[0].bounds[0]
                brush[1].bounds[1] = brush[0].bounds[1]

                brush[0].contents = self.mContentFlags
                brush[1].contents = self.mContentFlags

                // Set up sides of the brushes
                brush[0].numsides = 5
                brush[0].sides = side[0]
                brush[1].numsides = 5
                brush[1].sides = side[8]

                // Create the planes of the 2 triangles that make up the tops of the brushes
                self.InitPlane(side[0], plane[0], localCoords[0], localCoords[1], localCoords[2])
                self.InitPlane(side[8], plane[8], localCoords[3], localCoords[2], localCoords[1])

                // Create the bottom face of the brushes
                self.InitPlane(side[1], plane[1], localCoords[4], localCoords[6], localCoords[5])
                self.InitPlane(side[9], plane[9], localCoords[7], localCoords[5], localCoords[6])

                // Create the 3 vertical faces
                self.InitPlane(side[2], plane[2], localCoords[0], localCoords[2], localCoords[4])
                self.InitPlane(side[10], plane[10], localCoords[3], localCoords[1], localCoords[7])

                self.InitPlane(side[3], plane[3], localCoords[0], localCoords[4], localCoords[1])
                self.InitPlane(side[11], plane[11], localCoords[3], localCoords[7], localCoords[2])

                self.InitPlane(side[4], plane[4], localCoords[2], localCoords[1], localCoords[6])
                self.InitPlane(side[12], plane[12], localCoords[5], localCoords[1], localCoords[6])

                var V: Float = _DotProduct(plane[8].normal, localCoords[0]) - plane[8].dist

                if V < 0 {
                    self.InitPlane(brush[0].sidesSlots[brush[0].numsides], plane[brush[0].numsides], localCoords[3], localCoords[2], localCoords[1])
                    brush[0].numsides += 1

                    self.InitPlane(brush[1].sidesSlots[brush[1].numsides], plane[8 + brush[1].numsides], localCoords[0], localCoords[1], localCoords[2])
                    brush[1].numsides += 1
                }

                // Determine if we need to smooth the brush transition from the brush above us
                if y > 0 && y < self.owner!.GetPatchHeight() - 1 {
                    let abovebrush: Cbrush? = self.GetAdjacentBrushY(x, y)
                    let aboveplane: JKAShared.Cplane? = abovebrush!.sides!.plane

                    V = _DotProduct(aboveplane!.normal, ((y + x) & 1) != 0 ? (localCoords[2]) : (localCoords[1])) - aboveplane!.dist

                    if V < 0 {
                        brush[0].sidesSlots[brush[0].numsides].copy(from: abovebrush!.sides!)
                        brush[0].numsides += 1

                        abovebrush!.sidesSlots[abovebrush!.numsides].copy(from: side[0])
                        abovebrush!.numsides += 1
                    }
                }

                // Determine if we need to smooth the brush transition from the brush to the left of us
                if x > 0 && x < self.owner!.GetPatchWidth() - 1 {
                    let abovebrush: Cbrush? = self.GetAdjacentBrushX(x, y)

                    let aboveplane: JKAShared.Cplane? = abovebrush!.sides!.plane

                    V = _DotProduct(aboveplane!.normal, localCoords[1]) - aboveplane!.dist

                    if V < 0 {
                        if ((x + y) & 1) != 0 {
                            brush[0].sidesSlots[brush[0].numsides].copy(from: abovebrush!.sides!)
                            brush[0].numsides += 1

                            abovebrush!.sidesSlots[abovebrush!.numsides].copy(from: side[0])
                            abovebrush!.numsides += 1
                        } else {
                            brush[1].sidesSlots[brush[1].numsides].copy(from: abovebrush!.sides!)
                            brush[1].numsides += 1

                            abovebrush!.sidesSlots[abovebrush!.numsides].copy(from: side[8])
                            abovebrush!.numsides += 1
                        }
                    }
                }

                // Increment to next terxel
                brush = brush.suffix(from: 2)
                side = side.suffix(from: 16)
                plane = plane.suffix(from: 16)
                x += 1
            }
            y += 1
        }
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:272
    // AI: Raven returns a `cbrush_t *` as `void *`, and both callers cast it back at cm_terrain.cpp:461 and :483. The method returns the view, the RETURNS kind `view`.
    func GetAdjacentBrushX(_ x: Int32, _ y: Int32) -> Cbrush? {
        let xo1: Int32 = x % self.owner!.GetTerxels()
        let xo2: Int32 = (x - 1) % self.owner!.GetTerxels()
        let yo: Int32 = y % self.owner!.GetTerxels()
        var patch: CCMPatch?

        // Different patch
        if xo2 > xo1 {
            patch = self.owner!.GetPatch((x - 1) / self.owner!.GetTerxels(), y / self.owner!.GetTerxels())
        } else {
            patch = self
        }

        var brush: Slots<Cbrush>

        brush = patch!.mPatchBrushData!
        brush = brush.suffix(from: (yo * self.owner!.GetTerxels() + xo2) * 2)

        if ((x + y) & 1) == 0 {
            brush = brush.suffix(from: 1)
        }

        return brush[0]
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:246
    // AI: Raven returns a `cbrush_t *` as `void *`. The method returns the view, the form of GetAdjacentBrushX.
    func GetAdjacentBrushY(_ x: Int32, _ y: Int32) -> Cbrush? {
        let yo1: Int32 = y % self.owner!.GetTerxels()
        let yo2: Int32 = (y - 1) % self.owner!.GetTerxels()
        let xo: Int32 = x % self.owner!.GetTerxels()
        var patch: CCMPatch?

        // Different patch
        if yo2 > yo1 {
            patch = self.owner!.GetPatch(x / self.owner!.GetTerxels(), (y - 1) / self.owner!.GetTerxels())
        } else {
            patch = self
        }

        var brush: Slots<Cbrush>

        brush = patch!.mPatchBrushData!
        brush = brush.suffix(from: (yo2 * self.owner!.GetTerxels() + xo) * 2)
        brush = brush.suffix(from: 1)

        return brush[0]
    }
}
