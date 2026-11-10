import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's random terrain of a landscape, the height grid and the paths that carve it.
/// CreateRandomTerrain makes one for a `random_` height map, and only a client build calls it, so the dedicated build never makes one.
/// Source: oracle/codemp/qcommon/cm_randomterrain.h:51
final class CRandomTerrain {
    private var mLandScape: CCMLandScape? = nil
    private var mWidth: Int32 = 0
    private var mHeight: Int32 = 0
    private var mArea: Int32 = 0
    private var mBorder: Int32 = 0
    // AI: Raven holds the height map of the landscape as `byte *`. The field is the Slots over the bytes, the form of `mHeightMap` of CCMLandScape.
    private var mGrid: Slots<JKAShared.byte>? = nil
    // AI: Raven declares MAX_RANDOM_PATHS pointers by value. The field is an Array of the optional class, rule 17.
    private var mPaths: [CPathInfo?] = [CPathInfo?](repeating: nil, count: Int(MAX_RANDOM_PATHS))

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:563
    init() {
        // AI: Raven zeroes the MAX_RANDOM_PATHS pointers with memset. The field initializer already gives nil pointers, so the call drops.
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:568
    deinit {
        self.Shutdown()
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:69
    func GetLandScape() -> CCMLandScape? {
        self.mLandScape
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:70
    func GetBounds() -> [JKAShared.vec3_t] {
        self.mLandScape!.GetBounds()
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:71
    func rand_seed(_ seed: Int32) {
        self.mLandScape!.rand_seed(seed)
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:72
    // C converts the `unsigned long` of the landscape to the `int` return by its bits.
    func get_rand_seed() -> Int32 {
        Int32(bitPattern: self.mLandScape!.get_rand_seed())
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:73
    func flrand(_ min: Float, _ max: Float) -> Float {
        self.mLandScape!.flrand(min, max)
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:74
    func irand(_ min: Int32, _ max: Int32) -> Int32 {
        self.mLandScape!.irand(min, max)
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:573
    func Init(_ landscape: CCMLandScape?, _ grid: Slots<JKAShared.byte>?, _ width: Int32, _ height: Int32) {
        self.Shutdown()
        self.mLandScape = landscape
        self.mWidth = width
        self.mHeight = height
        self.mArea = self.mWidth * self.mHeight
        self.mBorder = (width + height) >> 6
        self.mGrid = grid
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:600
    func Shutdown() {
        self.ClearPaths()
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:605
    func CreatePath(_ PathID: Int32, _ ConnectedID: Int32, _ CreationFlags: UInt32, _ numPoints: Int32, _ bx: Float, _ by: Float, _ ex: Float, _ ey: Float, _ minWidth: Float, _ maxWidth: Float, _ depth: Float, _ deviation: Float, _ breadth: Float) -> Bool {
        // The dedicated build never makes a CRandomTerrain, so it never calls this method.
        var connected: CPathInfo? = nil

        if PathID < 0 || PathID >= MAX_RANDOM_PATHS || self.mPaths[PathID] != nil {
            return false
        }

        if ConnectedID >= 0 && ConnectedID < MAX_RANDOM_PATHS {
            connected = self.mPaths[ConnectedID]
        }

        self.mPaths[PathID] = CPathInfo(self.mLandScape, numPoints, bx, by, ex, ey,
            minWidth, maxWidth, depth, deviation, breadth,
            connected, CreationFlags)

        return true
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:628
    @discardableResult
    func GetPathInfo(_ PathNum: Int32, _ PercentInto: Float, _ Coord: inout JKAShared.vec4_t, _ Vector: inout JKAShared.vec4_t) -> Bool {
        // The dedicated build never makes a CRandomTerrain, so it never calls this method.
        if PathNum < 0 || PathNum >= MAX_RANDOM_PATHS || self.mPaths[PathNum] == nil {
            return false
        }

        self.mPaths[PathNum]!.GetInfo(PercentInto, &Coord, &Vector)

        return true
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:640
    func ParseGenerate(_ GenerateFile: String) {
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:644
    func Smooth() {
        // The dedicated build never makes a CRandomTerrain, so it never calls this method.
        // Scale down to 1/4 size then back up to smooth out the terrain
        var temp: Slots<JKAShared.byte>?
        var x: Int32
        var y: Int32
        var o: Int32

        temp = self.mLandScape!.GetFlattenMap()

        // Copy over anything in the flatten map
        o = 0
        while o < self.mHeight * self.mWidth {
            if temp![o] > 0 {
                self.mGrid![o] = temp![o] & 0x7F
            }
            o += 1
        }

        temp = Slots<JKAShared.byte>(scalars: Z_Malloc(self.mWidth * self.mHeight, TAG_RESAMPLE), count: Int(self.mWidth * self.mHeight))
        var total: UInt32
        var count: UInt32
        x = 1
        while x < self.mWidth - 1 {
            y = 1
            while y < self.mHeight - 1 {
                total = 0
                count = 2

                // Left
                // C widens the unsigned byte to `unsigned` at the add.
                total += UInt32(self.mGrid![((y) * self.mWidth) + (x - 1)])
                count += 1

                // Right
                // C widens the unsigned byte to `unsigned` at the add.
                total += UInt32(self.mGrid![((y) * self.mWidth) + (x + 1)])
                count += 1

                // Up
                // C widens the unsigned byte to `unsigned` at the add.
                total += UInt32(self.mGrid![((y - 1) * self.mWidth) + (x)])
                count += 1

                // Down
                // C widens the unsigned byte to `unsigned` at the add.
                total += UInt32(self.mGrid![((y + 1) * self.mWidth) + (x)])
                count += 1

                // Up-Left
                // C widens the unsigned byte to `unsigned` at the add.
                total += UInt32(self.mGrid![((y - 1) * self.mWidth) + (x - 1)])
                count += 1

                // Down-Left
                // C widens the unsigned byte to `unsigned` at the add.
                total += UInt32(self.mGrid![((y + 1) * self.mWidth) + (x - 1)])
                count += 1

                // Up-Right
                // C widens the unsigned byte to `unsigned` at the add.
                total += UInt32(self.mGrid![((y - 1) * self.mWidth) + (x + 1)])
                count += 1

                // Down-Right
                // C widens the unsigned byte to `unsigned` at the add.
                total += UInt32(self.mGrid![((y + 1) * self.mWidth) + (x + 1)])
                count += 1

                // C widens the unsigned byte to `unsigned` at the multiply.
                total += UInt32(self.mGrid![((y) * self.mWidth) + (x)]) * 2

                // C converts the `unsigned` quotient to the unsigned byte by its low bits at the store.
                temp![((y) * self.mWidth) + (x)] = JKAShared.byte(truncatingIfNeeded: total / count)
                y += 1
            }
            x += 1
        }

        // AI: Raven calls memcpy on the two pointers. Com_Memcpy over the two Slots copies the same bytes.
        Com_Memcpy(self.mGrid!, temp!, self.mWidth * self.mHeight)

        // AI: Raven frees the `byte *` of the zone block. The call frees the handle of the block.
        Z_Free(OpaquePointer(temp!.base))

        /* Uncomment to see the symmetry line on the map

        	for ( x = 0; x < mWidth; x ++ )
        	{
        		mGrid[x * mWidth + x] = 255;
        	}
        */
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:770
    func Generate(_ symmetric: Int32) {
        // Raven calls this method only from a client build, so it is dead.
        // TODO: Port CRandomTerrain::Generate
        portMissing("CRandomTerrain::Generate", source: "oracle/codemp/qcommon/cm_randomterrain.cpp:770")
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:584
    func ClearPaths() {
        var i: Int32

        i = 0
        while i < MAX_RANDOM_PATHS {
            if self.mPaths[i] != nil {
                // AI: Raven deletes the path and zeroes the pointer. The store of nil releases the class, and its deinit runs Raven's destructor.
                self.mPaths[i] = nil
            }
            i += 1
        }

        // AI: Raven zeroes the MAX_RANDOM_PATHS pointers with memset. The store of a nil-filled array clears them.
        self.mPaths = [CPathInfo?](repeating: nil, count: Int(MAX_RANDOM_PATHS))
    }
}
