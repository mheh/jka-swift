import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_randomterrain.h:11
let SPLINE_MERGE_SIZE: Int32 = 3
/// Source: oracle/codemp/qcommon/cm_randomterrain.h:12
let CIRCLE_STAMP_SIZE: Int32 = 128

/// Source: oracle/codemp/qcommon/cm_randomterrain.h:45
let MAX_RANDOM_PATHS: Int32 = 30

// Path Creation Flags
/// Source: oracle/codemp/qcommon/cm_randomterrain.h:48
let PATH_CREATION_CONNECT_FRONT: Int32 = 0x00000001

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:159
let BIG: Double = 1.0e12

/// Raven's spline path over a random terrain, its control points with their widths, and the circle stamp that carves it.
/// CRandomTerrain.CreatePath makes one, and only a client build calls that method, so the dedicated build never makes one.
/// Source: oracle/codemp/qcommon/cm_randomterrain.h:15
final class CPathInfo {
    // AI: Raven allocates the points, the work points, and the weights with malloc. Each field is an Array, rule 9.
    private var mPoints: [JKAShared.vec4_t] = []
    private var mWork: [JKAShared.vec4_t] = []
    private var mWeights: [JKAShared.vec_t] = []
    private var mNumPoints: Int32 = 0
    private var mMinWidth: Float = 0
    private var mMaxWidth: Float = 0
    private var mInc: Float = 0
    private var mDepth: Float = 0
    private var mBreadth: Float = 0
    private var mDeviation: Float = 0
    // AI: Raven holds CIRCLE_STAMP_SIZE rows of CIRCLE_STAMP_SIZE bytes by value. The field is an Array of rows, the form of `gridPlanes` in cm_patch.swift.
    private var mCircleStamp: [[JKAShared.byte]] = [[JKAShared.byte]](repeating: [JKAShared.byte](repeating: 0, count: Int(CIRCLE_STAMP_SIZE)), count: Int(CIRCLE_STAMP_SIZE))

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:367
    private func CreateCircle() {
        var x: Int32
        var y: Int32
        var r: Float
        var d: Float

        // AI: Raven zeroes the stamp with memset. The store of a zeroed grid clears it.
        self.mCircleStamp = [[JKAShared.byte]](repeating: [JKAShared.byte](repeating: 0, count: Int(CIRCLE_STAMP_SIZE)), count: Int(CIRCLE_STAMP_SIZE))
        // C converts the `int` size to `float` at the store.
        r = Float(CIRCLE_STAMP_SIZE)
        x = 0
        while x < CIRCLE_STAMP_SIZE {
            y = 0
            while y < CIRCLE_STAMP_SIZE {
                d = sqrt(Float(x * x + y * y))
                if d > r {
                    self.mCircleStamp[y][x] = 255
                } else {
                    // C converts the `float` result to the unsigned byte at the store.
                    // JKAShared's M_PI is the float of Raven's macro at q_shared.h:548, and the qualifier breaks the tie with the double of Foundation.
                    self.mCircleStamp[y][x] = JKAShared.byte(pow(sin(d / r * JKAShared.M_PI / 2), self.mBreadth) * 255)
                }
                y += 1
            }
            x += 1
        }
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:391
    private func Stamp(_ x: Int32, _ y: Int32, _ size: Int32, _ depth: Int32, _ Data: Slots<JKAShared.byte>?, _ DataWidth: Int32, _ DataHeight: Int32) {
        //	int xPos;
        //	float yPos;
        var dx: Int32
        var dy: Int32
        var fx: Int32
        var fy: Int32
        var offset: Float
        var value: JKAShared.byte
        var invDepth: JKAShared.byte

        offset = Float(CIRCLE_STAMP_SIZE - 1) / size
        // C converts the `int` difference to the unsigned byte by its low bits.
        invDepth = JKAShared.byte(truncatingIfNeeded: 255 - depth)

        dx = -size
        while dx <= size {
            dy = -size
            while dy <= size {
                var d: Float

                // C converts the `int` sum to `float` at the store.
                d = Float(dx * dx + dy * dy)
                if d > size * size {
                    dy += 1
                    continue
                }

                fx = x + dx
                if fx < 2 || fx > DataWidth - 2 {
                    dy += 1
                    continue
                }

                fy = y + dy
                if fy < 2 || fy > DataHeight - 2 {
                    dy += 1
                    continue
                }

                // C widens the unsigned byte to `float` at the multiply, and converts the `float` result to the unsigned byte at the store.
                value = JKAShared.byte(pow(sin(d / (size * size) * JKAShared.M_PI / 2), self.mBreadth) * Float(invDepth) + depth)
                if value < Data![(fy * DataWidth) + fx] {
                    Data![(fy * DataWidth) + fx] = value
                }
                dy += 1
            }
            dx += 1
        }
        /*

        		fx = x + dx;
        		if (fx < 2 || fx > DataWidth-2)
        		{
        			continue;
        		}
        		xPos = abs((int)(dx*offset));
        		yPos = offset*size + offset;
        		for(dy = -size; dy < 0; dy++)
        		{
        			yPos -= offset;
        			fy = y + dy;
        			if (fy < 2 || fy > DataHeight-2)
        			{
        				continue;
        			}

        			value = (invDepth * mCircleStamp[(int)yPos][xPos] / 256) + depth;
        			if (value < Data[(fy * DataWidth) + fx])
        			{
        				Data[(fy * DataWidth) + fx] = value;
        			}
        		}

        		yPos = -offset;
        		for(; dy <= size; dy++)
        		{
        			yPos += offset;

        			fy = y + dy;
        			if (fy < 2 || fy > DataHeight-2)
        			{
        				continue;
        			}

        			value = (invDepth * mCircleStamp[(int)yPos][xPos] / 256) + depth;
        			if (value < Data[(fy * DataWidth) + fx])
        			{
        				Data[(fy * DataWidth) + fx] = value;
        			}
        		}
        	}
        */
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:178
    init(_ landscape: CCMLandScape?, _ numPoints: Int32, _ bx: Float, _ by: Float, _ ex: Float, _ ey: Float, _ minWidth: Float, _ maxWidth: Float, _ depth: Float, _ deviation: Float, _ breadth: Float, _ Connected: CPathInfo?, _ CreationFlags: UInt32) {
        var i: Int32
        var numConnected: Int32
        var index: Int32
        var position: Float
        var goal: Float
        var deltaGoal: Float
        //	float	random, delta;
        var horizontal: Bool
        var point: JKAShared.vec4_t
        var currentWidth: Float
        var currentPosition: Float
        var testPoint = JKAShared.vec2_t()
        var percPoint = JKAShared.vec2_t()
        var diffPoint = JKAShared.vec2_t()
        var normalizedPath = JKAShared.vec2_t()
        var distance: Float
        var length: Float

        self.mNumPoints = numPoints
        self.mMinWidth = minWidth
        self.mMaxWidth = maxWidth
        self.mDepth = depth
        self.mDeviation = deviation
        self.mBreadth = breadth

        self.CreateCircle()

        numConnected = -1
        if Connected != nil {
            // we are connecting to an existing spline
            numConnected = Connected!.GetNumPoints()
            if numConnected >= SPLINE_MERGE_SIZE {
                // plenty of points to choose from
                self.mNumPoints += SPLINE_MERGE_SIZE
            } else {
                // the existing spline doesn't have enough points
                self.mNumPoints += numConnected
            }
        }

        // AI: Raven allocates each block with malloc and leaves it undefined. Each array starts zeroed.
        self.mPoints = [JKAShared.vec4_t](repeating: JKAShared.vec4_t(), count: Int(self.mNumPoints))
        self.mWork = [JKAShared.vec4_t](repeating: JKAShared.vec4_t(), count: Int(self.mNumPoints + 1))
        self.mWeights = [JKAShared.vec_t](repeating: 0, count: Int(self.mNumPoints + 1))

        length = sqrt((ex - bx) * (ex - bx) + (ey - by) * (ey - by))
        if abs(ex - bx) >= abs(ey - by) {
            // this appears to be a horizontal path
            self.mInc = 1.0 / abs(ex - bx)
            horizontal = true
            position = by
            goal = ey
            deltaGoal = (ey - by) / (numPoints - 1)
        } else {
            // this appears to be a vertical path
            self.mInc = 1.0 / abs(ey - by)
            horizontal = false
            position = bx
            goal = ex
            deltaGoal = (ex - bx) / (numPoints - 1)
        }
        normalizedPath[0] = (ex - bx)
        normalizedPath[1] = (ey - by)
        Vector2Normalize(&normalizedPath)
        // approx calculate how much we need to iterate through the spline to hit every point
        self.mInc /= 16

        currentWidth = landscape!.flrand(minWidth, maxWidth)
        currentPosition = 0.0

        i = 0
        while i < self.mNumPoints {
            // weights are evenly distributed
            self.mWeights[i] = Float(i) / (self.mNumPoints - 1)

            if i < numConnected && i < SPLINE_MERGE_SIZE {
                // we are connecting to an existing spline, so copy over the first few points
                // C converts the `int` flag to `unsigned` at the and.
                if (CreationFlags & UInt32(PATH_CREATION_CONNECT_FRONT)) != 0 {
                    // copy from the front
                    index = i
                } else {
                    // copy from the end
                    index = numConnected - SPLINE_MERGE_SIZE + i
                }
                point = Connected!.GetPoint(index)
                self.mPoints[i][0] = point[0]
                self.mPoints[i][1] = point[1]
                self.mPoints[i][3] = point[3]
            } else {
                if horizontal {
                    // we appear to be going horizontal, so spread the randomness across the vertical
                    self.mPoints[i][0] = ((ex - bx) * currentPosition) + bx
                    self.mPoints[i][1] = position
                } else {
                    // we appear to be going vertical, so spread the randomness across the horizontal
                    self.mPoints[i][0] = position
                    self.mPoints[i][1] = ((ey - by) * currentPosition) + by
                }
                // C adds in `double`, because `1.0` is a double, and converts the sum to `float` at the store.
                currentPosition = Float(Double(currentPosition) + 1.0 / Double(numPoints - 1))

                // set the width of the spline
                self.mPoints[i][3] = currentWidth
                currentWidth += landscape!.flrand(-0.10, 0.10)
                if currentWidth < minWidth {
                    currentWidth = minWidth
                } else if currentWidth > maxWidth {
                    currentWidth = maxWidth
                }

                // see how far we are from the goal
                /*			delta = (goal - position) * currentPosition;
                			// calculate the randomness we are allowed at this place
                			random = landscape->flrand(-mDeviation/1.0, mDeviation/1.0) * (1.0 - currentPosition);
                			position += delta + random;*/

                if i == self.mNumPoints - 2 {
                    // -2 because we are calculating for the next point
                    position = goal
                } else {
                    if i == 0 {
                        position += deltaGoal + landscape!.flrand(-self.mDeviation / 10.0, self.mDeviation / 10.0)
                    } else {
                        position += deltaGoal + landscape!.flrand(-self.mDeviation * 1.5, self.mDeviation * 1.5)
                    }
                }

                // C compares and adds in `double`, because `0.9` and `0.1` are doubles, and converts each sum to `float` at the store.
                if Double(position) > 0.9 {
                    // too far over, so move back a bit
                    position = Float(0.9 - Double(landscape!.flrand(0.02, 0.1)))
                }
                if Double(position) < 0.1 {
                    // too near, so move bakc a bit
                    position = Float(0.1 + Double(landscape!.flrand(0.02, 0.1)))
                }

                // check our deviation from the straight line to the end
                if horizontal {
                    testPoint[0] = ((ex - bx) * currentPosition) + bx
                    testPoint[1] = position
                } else {
                    testPoint[0] = position
                    testPoint[1] = ((ey - by) * currentPosition) + by
                }
                // dot product of the normal of the path to the point we are at
                distance = ((testPoint[0] - bx) * normalizedPath[0]) + ((testPoint[1] - by) * normalizedPath[1])
                // find the perpendicular place that is intersected by the point and the path
                percPoint[0] = (distance * normalizedPath[0]) + bx
                percPoint[1] = (distance * normalizedPath[1]) + by
                // calculate the difference between the perpendicular point and the test point
                diffPoint[0] = testPoint[0] - percPoint[0]
                diffPoint[1] = testPoint[1] - percPoint[1]
                // calculate the distance
                distance = sqrt((diffPoint[0] * diffPoint[0]) + (diffPoint[1] * diffPoint[1]))
                if distance > self.mDeviation {
                    // we are beyond our allowed deviation, so head back
                    if horizontal {
                        position = (ey - by) * currentPosition + by
                    } else {
                        position = (ex - bx) * currentPosition + bx
                    }
                    position += landscape!.flrand(-self.mDeviation / 2.0, self.mDeviation / 2.0)
                }
            }
            i += 1
        }
        // C converts the `double` of BIG to `float` at the store.
        self.mWeights[self.mNumPoints] = Float(BIG)
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:360
    deinit {
        // AI: Raven frees the three blocks with free. Emptying the arrays frees them.
        self.mWeights = []
        self.mWork = []
        self.mPoints = []
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:36
    func GetNumPoints() -> Int32 {
        self.mNumPoints
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:37
    // AI: Raven returns a pointer into `mPoints`. The method returns a copy of the point, because the one caller only reads it.
    func GetPoint(_ index: Int32) -> JKAShared.vec4_t {
        self.mPoints[index]
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.h:38
    func GetWidth(_ index: Int32) -> Float {
        self.mPoints[index][3]
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:480
    func GetInfo(_ PercentInto: Float, _ Coord: inout JKAShared.vec4_t, _ Vector: inout JKAShared.vec4_t) {
        var before = JKAShared.vec4_t()
        var after = JKAShared.vec4_t()
        var testPercent: Float

        // C converts the `size_t` quotient of the two sizes to the `int` parameter.
        DialASpline(PercentInto, self.mWeights, self.mPoints, Int32(JKAShared.vec4_t.byteCount / JKAShared.vec_t.byteCount), self.mNumPoints - 1, &self.mWork, 2, true, &Coord)

        // C subtracts in `double`, because `0.01` is a double, and converts the difference to `float` at the store.
        testPercent = Float(Double(PercentInto) - 0.01)
        if testPercent < 0 {
            testPercent = 0
        }
        DialASpline(testPercent, self.mWeights, self.mPoints, Int32(JKAShared.vec4_t.byteCount / JKAShared.vec_t.byteCount), self.mNumPoints - 1, &self.mWork, 2, true, &before)

        // C adds in `double`, because `0.01` is a double, and converts the sum to `float` at the store.
        testPercent = Float(Double(PercentInto) + 0.01)
        if testPercent > 1.0 {
            testPercent = 1.0
        }
        DialASpline(testPercent, self.mWeights, self.mPoints, Int32(JKAShared.vec4_t.byteCount / JKAShared.vec_t.byteCount), self.mNumPoints - 1, &self.mWork, 2, true, &after)

        Coord[2] = self.mDepth

        Vector[0] = after[0] - before[0]
        Vector[1] = after[1] - before[1]
    }

    /// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:507
    func DrawPath(_ Data: Slots<JKAShared.byte>?, _ DataWidth: Int32, _ DataHeight: Int32) {
        var t: Float
        var val = JKAShared.vec4_t()
        var vector = JKAShared.vec4_t()	//, perp;
        var size: Int32
        var inc: Float
        var x: Int32
        var y: Int32
        var lastX: Int32
        var lastY: Int32
        var depth: Float

        inc = self.mInc / DataWidth

        lastY = -999
        lastX = lastY

        t = 0.0
        while t <= 1.0 {
            self.GetInfo(t, &val, &vector)

            /*		perp[0] = -vector[1];
            		perp[1] = vector[0];

            		if (fabs(perp[0]) > fabs(perp[1]))
            		{
            			perp[1] /= fabs(perp[0]);
            			perp[0] /= fabs(perp[0]);
            		}
            		else
            		{
            			perp[0] /= fabs(perp[1]);
            			perp[1] /= fabs(perp[1]);
            		}
            */
            // C converts each `float` product to `int` at the store.
            x = Int32(val[0] * DataWidth)
            y = Int32(val[1] * DataHeight)

            if x == lastX && y == lastY {
                t += inc
                continue
            }

            lastX = x
            lastY = y

            // C converts the `float` product to `int` at the store.
            size = Int32(val[3] * DataWidth)

            depth = self.mDepth * 255.0

            self.Stamp(x, y, size, Int32(depth), Data, DataWidth, DataHeight)
            t += inc
        }
    }
}

/****** lincrv.c ******/
/* Ken Shoemake, 1994 */

/* Perform a generic vector unary operation. */
// Raven wrote: #define V_Op(vdst,gets,vsrc,n) {register int V_i;\
//     for(V_i=(n)-1;V_i>=0;V_i--) (vdst)[V_i] gets ((vsrc)[V_i]);}

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:105
private func lerp(_ t: Float, _ a0: Float, _ a1: Float, _ p0: JKAShared.vec4_t, _ p1: JKAShared.vec4_t, _ m: Int32, _ p: inout JKAShared.vec4_t) {
    let t0: Float = (a1 - t) / (a1 - a0)
    let t1: Float = 1 - t0
    var i: Int32

    i = m - 1
    while i >= 0 {
        p[i] = t0 * p0[i] + t1 * p1[i]
        i -= 1
    }
}

/* DialASpline(t,a,p,m,n,work,Cn,interp,val) computes a point val at parameter
    t on a spline with knot values a and control points p. The curve will have
    Cn continuity, and if interp is TRUE it will interpolate the control points.
    Possibilities include Langrange interpolants, Bezier curves, Catmull-Rom
    interpolating splines, and B-spline curves. Points have m coordinates, and
    n+1 of them are provided. The work array must have room for n+1 points.
 */
/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:119
// AI: Raven passes `a`, `p`, and `work` as pointers to the caller's blocks. Each is the caller's array, and `work` is `inout`, because the function writes it.
@discardableResult
private func DialASpline(_ t: Float, _ a: [Float], _ p: [JKAShared.vec4_t], _ m: Int32, _ n: Int32, _ work: inout [JKAShared.vec4_t], _ Cn: UInt32, _ interp: Bool, _ val: inout JKAShared.vec4_t) -> Int32 {
    // Raven assigns his own `Cn` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var Cn = Cn
    var i: Int32
    var j: Int32
    var k: Int32
    var h: Int32
    var lo: Int32
    var hi: Int32

    // C does the `Cn` arithmetic below in `unsigned` and stores each result in an `int`.
    // Each site converts `Cn` by its bits, and the wrapping operators give the same `int`.
    if Cn > UInt32(bitPattern: n - 1) {
        Cn = UInt32(bitPattern: n - 1)       /* Anything greater gives one polynomial */
    }
    k = 0
    while t > a[k] {
        k += 1    /* Find enclosing knot interval */
    }
    h = k
    while t == a[k] {
        k += 1    /* May want to use fewer legs */
    }
    if k > n {
        k = n
        if h > k {
            h = k
        }
    }
    h = 1 &+ Int32(bitPattern: Cn) &- (k - h)
    k -= 1
    lo = k &- Int32(bitPattern: Cn)
    hi = k + 1 &+ Int32(bitPattern: Cn)

    if interp {
        /* Lagrange interpolation steps */
        var drop: Int32 = 0
        if lo < 0 {
            lo = 0
            drop = drop &+ (Int32(bitPattern: Cn) &- k)
            if UInt32(bitPattern: hi - lo) < Cn {
                drop = drop &+ (Int32(bitPattern: Cn) &- hi)
                hi = Int32(bitPattern: Cn)
            }
        }
        if hi > n {
            hi = n
            drop = drop &+ (k + 1 &+ Int32(bitPattern: Cn) &- n)
            if UInt32(bitPattern: hi - lo) < Cn {
                drop = drop &+ (lo &- (n &- Int32(bitPattern: Cn)))
                lo = n &- Int32(bitPattern: Cn)
            }
        }
        i = lo
        while i <= hi {
            // Raven's V_Op macro of this file expands at each site, because the port has no function for it.
            var V_i: Int32 = m - 1
            while V_i >= 0 {
                work[i][V_i] = p[i][V_i]
                V_i -= 1
            }
            i += 1
        }
        j = 1
        while UInt32(bitPattern: j) <= Cn {
            i = lo
            while i <= hi - j {
                lerp(t, a[i], a[i + j], work[i], work[i + 1], m, &work[i])
                i += 1
            }
            j += 1
        }
        h = 1 &+ Int32(bitPattern: Cn) &- drop
    } else {
        /* Prepare for B-spline steps */
        if lo < 0 {
            h += lo
            lo = 0
        }
        i = lo
        while i <= lo + h {
            var V_i: Int32 = m - 1
            while V_i >= 0 {
                work[i][V_i] = p[i][V_i]
                V_i -= 1
            }
            i += 1
        }
        if h < 0 {
            h = 0
        }
    }
    j = 0
    while j < h {
        let tmp: Int32 = 1 &+ Int32(bitPattern: Cn) &- j
        i = h - 1
        while i >= j {
            lerp(t, a[lo + i], a[lo + i + tmp], work[lo + i], work[lo + i + 1], m, &work[lo + i + 1])
            i -= 1
        }
        j += 1
    }
    var V_i: Int32 = m - 1
    while V_i >= 0 {
        val[V_i] = work[lo + h][V_i]
        V_i -= 1
    }
    return (k)
}

/// Source: oracle/codemp/qcommon/cm_randomterrain.cpp:161
@discardableResult
private func Vector2Normalize(_ v: inout JKAShared.vec2_t) -> JKAShared.vec_t {
    var length: Float
    var ilength: Float

    length = v[0] * v[0] + v[1] * v[1]
    length = sqrt(length)

    if length != 0 {
        ilength = 1 / length
        v[0] *= ilength
        v[1] *= ilength
    }

    return length
}
