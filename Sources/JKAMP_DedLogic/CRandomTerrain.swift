import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:11
private let NOISE_SIZE = 256 as Int32

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:12
private let NOISE_MASK = (NOISE_SIZE - 1)

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:14
// AI: Raven declares `static float noiseTable[NOISE_SIZE]`, which only CM_NoiseInit under `#if 0` writes. The table is a file-scope `let` of zeros, the form of `neighbor_x`.
private let noiseTable = [Float](repeating: 0, count: Int(NOISE_SIZE))

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:15
// AI: Raven declares `static int noisePerm[NOISE_SIZE]`, which only CM_NoiseInit under `#if 0` writes. The table is a file-scope `let` of zeros, the form of `neighbor_x`.
private let noisePerm = [Int32](repeating: 0, count: Int(NOISE_SIZE))

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:35
private func GetNoiseValue(_ x: Int32, _ y: Int32, _ z: Int32, _ t: Int32) -> Float {
    // Raven's INDEX and VAL macros of this file expand here, because the port has no function for them.
    let index = noisePerm[(Int32(x) + noisePerm[(Int32(y) + noisePerm[(Int32(z) + noisePerm[Int32(t) & NOISE_MASK]) & NOISE_MASK]) & NOISE_MASK]) & NOISE_MASK]

    return noiseTable[index]
}

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:51
private func CM_NoiseGet4f(_ x: Float, _ y: Float, _ z: Float, _ t: Float) -> Float {
    var i: Int32
    let ix: Int32
    let iy: Int32
    let iz: Int32
    let it: Int32
    let fx: Float
    let fy: Float
    let fz: Float
    let ft: Float
    var front = [Float](repeating: 0, count: 4)
    var back = [Float](repeating: 0, count: 4)
    var fvalue: Float
    var bvalue: Float
    var value = [Float](repeating: 0, count: 2)
    let finalvalue: Float

    ix = Int32(floor(x))
    fx = x - ix
    iy = Int32(floor(y))
    fy = y - iy
    iz = Int32(floor(z))
    fz = z - iz
    it = Int32(floor(t))
    ft = t - it

    i = 0
    while i < 2 {
        front[0] = GetNoiseValue(ix, iy, iz, it + i)
        front[1] = GetNoiseValue(ix + 1, iy, iz, it + i)
        front[2] = GetNoiseValue(ix, iy + 1, iz, it + i)
        front[3] = GetNoiseValue(ix + 1, iy + 1, iz, it + i)

        back[0] = GetNoiseValue(ix, iy, iz + 1, it + i)
        back[1] = GetNoiseValue(ix + 1, iy, iz + 1, it + i)
        back[2] = GetNoiseValue(ix, iy + 1, iz + 1, it + i)
        back[3] = GetNoiseValue(ix + 1, iy + 1, iz + 1, it + i)

        // Raven's LERP macro of this file expands at each site, because the port has no function for it.
        fvalue = (front[0] * (1.0 - fx) + front[1] * fx) * (1.0 - fy) + (front[2] * (1.0 - fx) + front[3] * fx) * fy
        bvalue = (back[0] * (1.0 - fx) + back[1] * fx) * (1.0 - fy) + (back[2] * (1.0 - fx) + back[3] * fx) * fy

        value[i] = fvalue * (1.0 - fz) + bvalue * fz
        i += 1
    }

    finalvalue = value[0] * (1.0 - ft) + value[1] * ft
    return finalvalue
}

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

        // Port-note: Rule 19. The loop below never writes the border bytes of the block, and Raven's Z_Malloc does not zero it, so his memcpy puts unset bytes in the border of `mGrid`.
        // The Swift Z_Malloc calls malloc for a block that is not zeroed, so the port asks for a zeroed block, and the border becomes 0.
        temp = Slots<JKAShared.byte>(scalars: Z_Malloc(self.mWidth * self.mHeight, TAG_RESAMPLE, true), count: Int(self.mWidth * self.mHeight))
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
        // The dedicated build never makes a CRandomTerrain, so it never calls this method.
        var i: Int32
        var j: Int32
        var x: Int32
        var y: Int32

        // Clear out all existing data
        // AI: Raven calls memset on the pointer. Com_Memset over the Slots sets the same bytes.
        Com_Memset(self.mGrid!, 255, self.mArea)

        // make landscape a little bumpy
        let t1 = self.mLandScape!.flrand(0, 2)

        /*
        	CM_NoiseInit(mLandScape);

        	for (y = 0; y < mHeight; y++)
        		for (x = 0; x < mWidth; x++)
        		{
        			i = x + y*mWidth;
        			byte val = (byte)Com_Clamp(0, 255, (int)(220 + (CM_NoiseGet4f( x*0.25, y*0.25, 0, t3 ) * 20)) + (CM_NoiseGet4f( x*0.5, y*0.5, 0, t2 ) * 15));
        			mGrid[i] = val;
        		}
        */

        // Port-note: Raven reads `mPaths[MAX_RANDOM_PATHS]` past the array when every path is set, undefined.
        // The Array index traps there, rule 19.
        i = 0
        while self.mPaths[i] != nil {
            self.mPaths[i]!.DrawPath(self.mGrid, self.mWidth, self.mHeight)
            i += 1
        }

        y = 0
        while y < self.mHeight {
            x = 0
            while x < self.mWidth {
                i = x + y * self.mWidth
                // C widens the byte and the `int` coordinates to `float`, truncates the sum to `int`, and converts the clamp to the byte.
                let val = JKAShared.byte(Com_Clamp(0, 255, Float(Int32(Int32(self.mGrid![i]) + (CM_NoiseGet4f(Float(x), Float(y), 0, t1) * 5)))))
                self.mGrid![i] = val
                x += 1
            }
            y += 1
        }

        // if symmetric, do this now
        if symmetric != 0 {
            assert(self.mWidth == self.mHeight) // must be square

            y = 0
            while y < self.mHeight {
                x = 0
                while x < (self.mWidth - y) {
                    i = x + y * self.mWidth
                    j = (self.mWidth - 1 - x) + (self.mHeight - 1 - y) * self.mWidth
                    let val = self.mGrid![i] < self.mGrid![j] ? self.mGrid![i] : self.mGrid![j]
                    self.mGrid![j] = val
                    self.mGrid![i] = self.mGrid![j]
                    x += 1
                }
                y += 1
            }
        }
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
