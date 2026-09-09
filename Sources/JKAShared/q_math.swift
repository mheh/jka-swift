// q_math.c -- stateless support routines that are included in each code module
// Adopted from tools/oracle-closure/skeleton.py, rule 13. The generator routes the q_math stem here, and the bodies are hand-ported.

import Foundation

/// Source: oracle/codemp/game/q_math.c:7
public let vec3_origin = vec3_t(0, 0, 0)

/// Source: oracle/codemp/game/q_math.c:8
public let axisDefault: [vec3_t] = [vec3_t(1, 0, 0), vec3_t(0, 1, 0), vec3_t(0, 0, 1)]

/// Source: oracle/codemp/game/q_math.c:11
public let colorBlack = vec4_t(0, 0, 0, 1)
/// Source: oracle/codemp/game/q_math.c:12
public let colorRed = vec4_t(1, 0, 0, 1)
/// Source: oracle/codemp/game/q_math.c:13
public let colorGreen = vec4_t(0, 1, 0, 1)
/// Source: oracle/codemp/game/q_math.c:14
public let colorBlue = vec4_t(0, 0, 1, 1)
/// Source: oracle/codemp/game/q_math.c:15
public let colorYellow = vec4_t(1, 1, 0, 1)
/// Source: oracle/codemp/game/q_math.c:16
public let colorMagenta = vec4_t(1, 0, 1, 1)
/// Source: oracle/codemp/game/q_math.c:17
public let colorCyan = vec4_t(0, 1, 1, 1)
/// Source: oracle/codemp/game/q_math.c:18
public let colorWhite = vec4_t(1, 1, 1, 1)
/// Source: oracle/codemp/game/q_math.c:19
public let colorLtGrey = vec4_t(0.75, 0.75, 0.75, 1)
/// Source: oracle/codemp/game/q_math.c:20
public let colorMdGrey = vec4_t(0.5, 0.5, 0.5, 1)
/// Source: oracle/codemp/game/q_math.c:21
public let colorDkGrey = vec4_t(0.25, 0.25, 0.25, 1)
/// Source: oracle/codemp/game/q_math.c:23
public let colorLtBlue = vec4_t(0.367, 0.261, 0.722, 1)
/// Source: oracle/codemp/game/q_math.c:24
public let colorDkBlue = vec4_t(0.199, 0.0, 0.398, 1)

/// Source: oracle/codemp/game/q_math.c:26
public let g_color_table: [vec4_t] = [
    vec4_t(0.0, 0.0, 0.0, 1.0),
    vec4_t(1.0, 0.0, 0.0, 1.0),
    vec4_t(0.0, 1.0, 0.0, 1.0),
    vec4_t(1.0, 1.0, 0.0, 1.0),
    vec4_t(0.0, 0.0, 1.0, 1.0),
    vec4_t(0.0, 1.0, 1.0, 1.0),
    vec4_t(1.0, 0.0, 1.0, 1.0),
    vec4_t(1.0, 1.0, 1.0, 1.0),
]

/// Source: oracle/codemp/game/q_math.c:39
public let bytedirs: [vec3_t] = [
    vec3_t(-0.525731, 0.000000, 0.850651), vec3_t(-0.442863, 0.238856, 0.864188), vec3_t(-0.295242, 0.000000, 0.955423),
    vec3_t(-0.309017, 0.500000, 0.809017), vec3_t(-0.162460, 0.262866, 0.951056), vec3_t(0.000000, 0.000000, 1.000000),
    vec3_t(0.000000, 0.850651, 0.525731), vec3_t(-0.147621, 0.716567, 0.681718), vec3_t(0.147621, 0.716567, 0.681718),
    vec3_t(0.000000, 0.525731, 0.850651), vec3_t(0.309017, 0.500000, 0.809017), vec3_t(0.525731, 0.000000, 0.850651),
    vec3_t(0.295242, 0.000000, 0.955423), vec3_t(0.442863, 0.238856, 0.864188), vec3_t(0.162460, 0.262866, 0.951056),
    vec3_t(-0.681718, 0.147621, 0.716567), vec3_t(-0.809017, 0.309017, 0.500000), vec3_t(-0.587785, 0.425325, 0.688191),
    vec3_t(-0.850651, 0.525731, 0.000000), vec3_t(-0.864188, 0.442863, 0.238856), vec3_t(-0.716567, 0.681718, 0.147621),
    vec3_t(-0.688191, 0.587785, 0.425325), vec3_t(-0.500000, 0.809017, 0.309017), vec3_t(-0.238856, 0.864188, 0.442863),
    vec3_t(-0.425325, 0.688191, 0.587785), vec3_t(-0.716567, 0.681718, -0.147621), vec3_t(-0.500000, 0.809017, -0.309017),
    vec3_t(-0.525731, 0.850651, 0.000000), vec3_t(0.000000, 0.850651, -0.525731), vec3_t(-0.238856, 0.864188, -0.442863),
    vec3_t(0.000000, 0.955423, -0.295242), vec3_t(-0.262866, 0.951056, -0.162460), vec3_t(0.000000, 1.000000, 0.000000),
    vec3_t(0.000000, 0.955423, 0.295242), vec3_t(-0.262866, 0.951056, 0.162460), vec3_t(0.238856, 0.864188, 0.442863),
    vec3_t(0.262866, 0.951056, 0.162460), vec3_t(0.500000, 0.809017, 0.309017), vec3_t(0.238856, 0.864188, -0.442863),
    vec3_t(0.262866, 0.951056, -0.162460), vec3_t(0.500000, 0.809017, -0.309017), vec3_t(0.850651, 0.525731, 0.000000),
    vec3_t(0.716567, 0.681718, 0.147621), vec3_t(0.716567, 0.681718, -0.147621), vec3_t(0.525731, 0.850651, 0.000000),
    vec3_t(0.425325, 0.688191, 0.587785), vec3_t(0.864188, 0.442863, 0.238856), vec3_t(0.688191, 0.587785, 0.425325),
    vec3_t(0.809017, 0.309017, 0.500000), vec3_t(0.681718, 0.147621, 0.716567), vec3_t(0.587785, 0.425325, 0.688191),
    vec3_t(0.955423, 0.295242, 0.000000), vec3_t(1.000000, 0.000000, 0.000000), vec3_t(0.951056, 0.162460, 0.262866),
    vec3_t(0.850651, -0.525731, 0.000000), vec3_t(0.955423, -0.295242, 0.000000), vec3_t(0.864188, -0.442863, 0.238856),
    vec3_t(0.951056, -0.162460, 0.262866), vec3_t(0.809017, -0.309017, 0.500000), vec3_t(0.681718, -0.147621, 0.716567),
    vec3_t(0.850651, 0.000000, 0.525731), vec3_t(0.864188, 0.442863, -0.238856), vec3_t(0.809017, 0.309017, -0.500000),
    vec3_t(0.951056, 0.162460, -0.262866), vec3_t(0.525731, 0.000000, -0.850651), vec3_t(0.681718, 0.147621, -0.716567),
    vec3_t(0.681718, -0.147621, -0.716567), vec3_t(0.850651, 0.000000, -0.525731), vec3_t(0.809017, -0.309017, -0.500000),
    vec3_t(0.864188, -0.442863, -0.238856), vec3_t(0.951056, -0.162460, -0.262866), vec3_t(0.147621, 0.716567, -0.681718),
    vec3_t(0.309017, 0.500000, -0.809017), vec3_t(0.425325, 0.688191, -0.587785), vec3_t(0.442863, 0.238856, -0.864188),
    vec3_t(0.587785, 0.425325, -0.688191), vec3_t(0.688191, 0.587785, -0.425325), vec3_t(-0.147621, 0.716567, -0.681718),
    vec3_t(-0.309017, 0.500000, -0.809017), vec3_t(0.000000, 0.525731, -0.850651), vec3_t(-0.525731, 0.000000, -0.850651),
    vec3_t(-0.442863, 0.238856, -0.864188), vec3_t(-0.295242, 0.000000, -0.955423), vec3_t(-0.162460, 0.262866, -0.951056),
    vec3_t(0.000000, 0.000000, -1.000000), vec3_t(0.295242, 0.000000, -0.955423), vec3_t(0.162460, 0.262866, -0.951056),
    vec3_t(-0.442863, -0.238856, -0.864188), vec3_t(-0.309017, -0.500000, -0.809017), vec3_t(-0.162460, -0.262866, -0.951056),
    vec3_t(0.000000, -0.850651, -0.525731), vec3_t(-0.147621, -0.716567, -0.681718), vec3_t(0.147621, -0.716567, -0.681718),
    vec3_t(0.000000, -0.525731, -0.850651), vec3_t(0.309017, -0.500000, -0.809017), vec3_t(0.442863, -0.238856, -0.864188),
    vec3_t(0.162460, -0.262866, -0.951056), vec3_t(0.238856, -0.864188, -0.442863), vec3_t(0.500000, -0.809017, -0.309017),
    vec3_t(0.425325, -0.688191, -0.587785), vec3_t(0.716567, -0.681718, -0.147621), vec3_t(0.688191, -0.587785, -0.425325),
    vec3_t(0.587785, -0.425325, -0.688191), vec3_t(0.000000, -0.955423, -0.295242), vec3_t(0.000000, -1.000000, 0.000000),
    vec3_t(0.262866, -0.951056, -0.162460), vec3_t(0.000000, -0.850651, 0.525731), vec3_t(0.000000, -0.955423, 0.295242),
    vec3_t(0.238856, -0.864188, 0.442863), vec3_t(0.262866, -0.951056, 0.162460), vec3_t(0.500000, -0.809017, 0.309017),
    vec3_t(0.716567, -0.681718, 0.147621), vec3_t(0.525731, -0.850651, 0.000000), vec3_t(-0.238856, -0.864188, -0.442863),
    vec3_t(-0.500000, -0.809017, -0.309017), vec3_t(-0.262866, -0.951056, -0.162460), vec3_t(-0.850651, -0.525731, 0.000000),
    vec3_t(-0.716567, -0.681718, -0.147621), vec3_t(-0.716567, -0.681718, 0.147621), vec3_t(-0.525731, -0.850651, 0.000000),
    vec3_t(-0.500000, -0.809017, 0.309017), vec3_t(-0.238856, -0.864188, 0.442863), vec3_t(-0.262866, -0.951056, 0.162460),
    vec3_t(-0.864188, -0.442863, 0.238856), vec3_t(-0.809017, -0.309017, 0.500000), vec3_t(-0.688191, -0.587785, 0.425325),
    vec3_t(-0.681718, -0.147621, 0.716567), vec3_t(-0.442863, -0.238856, 0.864188), vec3_t(-0.587785, -0.425325, 0.688191),
    vec3_t(-0.309017, -0.500000, 0.809017), vec3_t(-0.147621, -0.716567, 0.681718), vec3_t(-0.425325, -0.688191, 0.587785),
    vec3_t(-0.162460, -0.262866, 0.951056), vec3_t(0.442863, -0.238856, 0.864188), vec3_t(0.162460, -0.262866, 0.951056),
    vec3_t(0.309017, -0.500000, 0.809017), vec3_t(0.147621, -0.716567, 0.681718), vec3_t(0.000000, -0.525731, 0.850651),
    vec3_t(0.425325, -0.688191, 0.587785), vec3_t(0.587785, -0.425325, 0.688191), vec3_t(0.688191, -0.587785, 0.425325),
    vec3_t(-0.955423, 0.295242, 0.000000), vec3_t(-0.951056, 0.162460, 0.262866), vec3_t(-1.000000, 0.000000, 0.000000),
    vec3_t(-0.850651, 0.000000, 0.525731), vec3_t(-0.955423, -0.295242, 0.000000), vec3_t(-0.951056, -0.162460, 0.262866),
    vec3_t(-0.864188, 0.442863, -0.238856), vec3_t(-0.951056, 0.162460, -0.262866), vec3_t(-0.809017, 0.309017, -0.500000),
    vec3_t(-0.864188, -0.442863, -0.238856), vec3_t(-0.951056, -0.162460, -0.262866), vec3_t(-0.809017, -0.309017, -0.500000),
    vec3_t(-0.681718, 0.147621, -0.716567), vec3_t(-0.681718, -0.147621, -0.716567), vec3_t(-0.850651, 0.000000, -0.525731),
    vec3_t(-0.688191, 0.587785, -0.425325), vec3_t(-0.587785, 0.425325, -0.688191), vec3_t(-0.425325, 0.688191, -0.587785),
    vec3_t(-0.425325, -0.688191, -0.587785), vec3_t(-0.587785, -0.425325, -0.688191), vec3_t(-0.688191, -0.587785, -0.425325),
]

// MARK: - The C conversions Raven leaves undefined

/// Raven writes `(byte)(r * 255)`, and C leaves a float outside 0 to 255 undefined. Rule 19.
/// This saturates at both ends and turns a NaN into 0, which is the one defined behavior jka-rust also took.
private func colorByte(_ value: Float) -> byte {
    if value.isNaN || value <= 0 {
        return 0
    }
    if value >= 255 {
        return 255
    }
    return byte(value)
}

/// Raven writes `(int)d`, and C leaves a double outside the `int` range undefined. Rule 19.
/// This saturates at both ends and turns a NaN into 0, which is the one defined behavior jka-rust also took.
private func truncateToInt(_ value: Double) -> Int32 {
    if value.isNaN {
        return 0
    }
    if value <= -2_147_483_648.0 {
        return Int32.min
    }
    if value >= 2_147_483_648.0 {
        return Int32.max
    }
    return Int32(value)
}

//==============================================================

/// Source: oracle/codemp/game/q_math.c:126
public func Q_rand(_ seed: inout Int32) -> Int32 {
    seed = (69069 &* seed) &+ 1
    return seed
}

/// Source: oracle/codemp/game/q_math.c:131
public func Q_random(_ seed: inout Int32) -> Float {
    Float(Q_rand(&seed) & 0xffff) / Float(0x10000)
}

/// Source: oracle/codemp/game/q_math.c:135
public func Q_crandom(_ seed: inout Int32) -> Float {
    // Raven's `2.0` and `0.5` are double literals, so the arithmetic runs in double and rounds once at the return.
    Float(2.0 * (Double(Q_random(&seed)) - 0.5))
}

//=======================================================

/// Source: oracle/codemp/game/q_math.c:279
public func ClampChar(_ i: Int32) -> Int8 {
    if i < -128 {
        return -128
    }
    if i > 127 {
        return 127
    }
    return Int8(i)
}

/// Source: oracle/codemp/game/q_math.c:289
public func ClampShort(_ i: Int32) -> Int16 {
    if i < -32768 {
        return -32768
    }
    if i > 0x7fff {
        return 0x7fff
    }
    return Int16(i)
}

// this isn't a real cheap function to call!
/// Raven guards a null `dir`, and a `vec3_t` value cannot be null, so that branch has no Swift form.
/// Source: oracle/codemp/game/q_math.c:301
public func DirToByte(_ dir: vec3_t) -> Int32 {
    var best: Int32
    var d: Float
    var bestd: Float

    bestd = 0
    best = 0
    for i in 0 ..< Int(NUMVERTEXNORMALS) {
        // Raven's `DotProduct` is the header macro, so the sum keeps this scalar order.
        d = dir[0] * bytedirs[i][0] + dir[1] * bytedirs[i][1] + dir[2] * bytedirs[i][2]
        if d > bestd {
            bestd = d
            best = Int32(i)
        }
    }

    return best
}

/// Source: oracle/codemp/game/q_math.c:324
public func ByteToDir(_ b: Int32, _ dir: inout vec3_t) {
    if b < 0 || b >= NUMVERTEXNORMALS {
        dir = vec3_origin
        return
    }
    dir = bytedirs[Int(b)]
}

/// Raven writes three bytes of an uninitialized word and leaves byte 3 as stack garbage. Rule 19.
/// This zeroes byte 3, and the dumper masks it off, so the golden is the same on both sides.
/// Source: oracle/codemp/game/q_math.c:333
public func ColorBytes3(_ r: Float, _ g: Float, _ b: Float) -> UInt32 {
    var i: UInt32 = 0

    i |= UInt32(colorByte(r * 255)) << 0
    i |= UInt32(colorByte(g * 255)) << 8
    i |= UInt32(colorByte(b * 255)) << 16

    return i
}

/// Source: oracle/codemp/game/q_math.c:343
public func ColorBytes4(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> UInt32 {
    var i: UInt32 = 0

    i |= UInt32(colorByte(r * 255)) << 0
    i |= UInt32(colorByte(g * 255)) << 8
    i |= UInt32(colorByte(b * 255)) << 16
    i |= UInt32(colorByte(a * 255)) << 24

    return i
}

/// Source: oracle/codemp/game/q_math.c:354
public func NormalizeColor(_ `in`: vec3_t, _ out: inout vec3_t) -> Float {
    var max: Float

    max = `in`[0]
    if `in`[1] > max {
        max = `in`[1]
    }
    if `in`[2] > max {
        max = `in`[2]
    }

    if max == 0 {
        out = vec3_t(0, 0, 0)
    } else {
        out[0] = `in`[0] / max
        out[1] = `in`[1] / max
        out[2] = `in`[2] / max
    }
    return max
}

/**
=====================
PlaneFromPoints

Returns false if the triangle is degenrate.
The normal will point out of the clock for clockwise ordered points
=====================
*/
/// Source: oracle/codemp/game/q_math.c:384
public func PlaneFromPoints(_ plane: inout vec4_t, _ a: vec3_t, _ b: vec3_t, _ c: vec3_t) -> Bool {
    // TODO: Port PlaneFromPoints
    portMissing("PlaneFromPoints", source: "oracle/codemp/game/q_math.c:384")
}

/**
===============
RotatePointAroundVector

This is not implemented very well...
===============
*/
/// Source: oracle/codemp/game/q_math.c:405
public func RotatePointAroundVector(_ dst: inout vec3_t, _ dir: vec3_t, _ point: vec3_t, _ degrees: Float) {
    // TODO: Port RotatePointAroundVector
    portMissing("RotatePointAroundVector", source: "oracle/codemp/game/q_math.c:405")
}

/**
===============
RotateAroundDirection
===============
*/
/// Source: oracle/codemp/game/q_math.c:466
public func RotateAroundDirection(_ axis: inout [vec3_t], _ yaw: Float) {
    // TODO: Port RotateAroundDirection
    portMissing("RotateAroundDirection", source: "oracle/codemp/game/q_math.c:466")
}

/// Source: oracle/codemp/game/q_math.c:485
public func vectoangles(_ value1: vec3_t, _ angles: inout vec3_t) {
    // TODO: Port vectoangles
    portMissing("vectoangles", source: "oracle/codemp/game/q_math.c:485")
}

/**
=================
AnglesToAxis
=================
*/
/// Source: oracle/codemp/game/q_math.c:530
public func AnglesToAxis(_ angles: vec3_t, _ axis: inout [vec3_t]) {
    // TODO: Port AnglesToAxis
    portMissing("AnglesToAxis", source: "oracle/codemp/game/q_math.c:530")
}

/// Source: oracle/codemp/game/q_math.c:538
public func AxisClear(_ axis: inout [vec3_t]) {
    // TODO: Port AxisClear
    portMissing("AxisClear", source: "oracle/codemp/game/q_math.c:538")
}

/// Source: oracle/codemp/game/q_math.c:550
public func AxisCopy(_ `in`: [vec3_t], _ out: inout [vec3_t]) {
    // TODO: Port AxisCopy
    portMissing("AxisCopy", source: "oracle/codemp/game/q_math.c:550")
}

/// Source: oracle/codemp/game/q_math.c:556
public func ProjectPointOnPlane(_ dst: inout vec3_t, _ p: vec3_t, _ normal: vec3_t) {
    // TODO: Port ProjectPointOnPlane
    portMissing("ProjectPointOnPlane", source: "oracle/codemp/game/q_math.c:556")
}

/**
================
MakeNormalVectors

Given a normalized forward vector, create two
other perpendicular vectors
================
*/
/// Source: oracle/codemp/game/q_math.c:587
public func MakeNormalVectors(_ forward: vec3_t, _ right: inout vec3_t, _ up: inout vec3_t) {
    // TODO: Port MakeNormalVectors
    portMissing("MakeNormalVectors", source: "oracle/codemp/game/q_math.c:587")
}

/// Source: oracle/codemp/game/q_math.c:603
public func VectorRotate(_ `in`: vec3_t, _ matrix: [vec3_t], _ out: inout vec3_t) {
    // TODO: Port VectorRotate
    portMissing("VectorRotate", source: "oracle/codemp/game/q_math.c:603")
}

//============================================================================

/**
** float q_rsqrt( float number )
*/
/// Raven declares `long i`, and the oracle build normalizes it to 32 bits, at jka-rust/tools/jampgame-oracle/run.sh:87.
/// At 64 bits the read through `*(long *)&y` takes four bytes past the float, which is Raven's undefined behavior. Rule 19.
/// Source: oracle/codemp/game/q_math.c:616
public func Q_rsqrt(_ number: Float) -> Float {
    var i: Int32
    var x2: Float
    var y: Float
    let threehalfs: Float = 1.5

    x2 = number * 0.5
    y = number
    i = Int32(bitPattern: y.bitPattern)             // evil floating point bit level hacking
    i = 0x5f37_59df &- (i >> 1)                     // what the fuck?
    y = Float(bitPattern: UInt32(bitPattern: i))
    y = y * (threehalfs - (x2 * y * y))             // 1st iteration
//	y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed

    return y
}

/// Source: oracle/codemp/game/q_math.c:638
public func Q_fabs(_ f: Float) -> Float {
    var tmp = Int32(bitPattern: f.bitPattern)
    tmp &= 0x7FFF_FFFF
    return Float(bitPattern: UInt32(bitPattern: tmp))
}

//============================================================

/**
===============
LerpAngle

===============
*/
/// Source: oracle/codemp/game/q_math.c:653
public func LerpAngle(_ from: Float, _ to: Float, _ frac: Float) -> Float {
    // TODO: Port LerpAngle
    portMissing("LerpAngle", source: "oracle/codemp/game/q_math.c:653")
}

/**
=================
AngleSubtract

Always returns a value from -180 to 180
=================
*/
/// Source: oracle/codemp/game/q_math.c:675
public func AngleSubtract(_ a1: Float, _ a2: Float) -> Float {
    // TODO: Port AngleSubtract
    portMissing("AngleSubtract", source: "oracle/codemp/game/q_math.c:675")
}

/// Source: oracle/codemp/game/q_math.c:690
public func AnglesSubtract(_ v1: vec3_t, _ v2: vec3_t, _ v3: inout vec3_t) {
    // TODO: Port AnglesSubtract
    portMissing("AnglesSubtract", source: "oracle/codemp/game/q_math.c:690")
}

/// Source: oracle/codemp/game/q_math.c:697
public func AngleMod(_ a: Float) -> Float {
    // TODO: Port AngleMod
    portMissing("AngleMod", source: "oracle/codemp/game/q_math.c:697")
}

/**
=================
AngleNormalize360

returns angle normalized to the range [0 <= angle < 360]
=================
*/
/// Source: oracle/codemp/game/q_math.c:710
public func AngleNormalize360(_ angle: Float) -> Float {
    // TODO: Port AngleNormalize360
    portMissing("AngleNormalize360", source: "oracle/codemp/game/q_math.c:710")
}

/**
=================
AngleNormalize180

returns angle normalized to the range [-180 < angle <= 180]
=================
*/
/// Source: oracle/codemp/game/q_math.c:722
public func AngleNormalize180(_ angle: Float) -> Float {
    // TODO: Port AngleNormalize180
    portMissing("AngleNormalize180", source: "oracle/codemp/game/q_math.c:722")
}

/**
=================
AngleDelta

returns the normalized delta from angle1 to angle2
=================
*/
/// Source: oracle/codemp/game/q_math.c:738
public func AngleDelta(_ angle1: Float, _ angle2: Float) -> Float {
    // TODO: Port AngleDelta
    portMissing("AngleDelta", source: "oracle/codemp/game/q_math.c:738")
}

//============================================================

/**
=================
SetPlaneSignbits
=================
*/
/// Source: oracle/codemp/game/q_math.c:751
public func SetPlaneSignbits(_ out: inout Plane) {
    // TODO: Port SetPlaneSignbits
    portMissing("SetPlaneSignbits", source: "oracle/codemp/game/q_math.c:751")
}

/**
==================
BoxOnPlaneSide

Returns 1, 2, or 1 + 2
==================
*/
/// Source: oracle/codemp/game/q_math.c:809
public func BoxOnPlaneSide(_ emins: vec3_t, _ emaxs: vec3_t, _ p: inout Plane) -> Int32 {
    // TODO: Port BoxOnPlaneSide
    portMissing("BoxOnPlaneSide", source: "oracle/codemp/game/q_math.c:809")
}

/**
=================
RadiusFromBounds
=================
*/
/// Source: oracle/codemp/game/q_math.c:1114
public func RadiusFromBounds(_ mins: vec3_t, _ maxs: vec3_t) -> Float {
    // TODO: Port RadiusFromBounds
    portMissing("RadiusFromBounds", source: "oracle/codemp/game/q_math.c:1114")
}

/// Source: oracle/codemp/game/q_math.c:1129
public func ClearBounds(_ mins: inout vec3_t, _ maxs: inout vec3_t) {
    // TODO: Port ClearBounds
    portMissing("ClearBounds", source: "oracle/codemp/game/q_math.c:1129")
}

/// Source: oracle/codemp/game/q_math.c:1134
public func DistanceHorizontal(_ p1: vec3_t, _ p2: vec3_t) -> vec_t {
    // TODO: Port DistanceHorizontal
    portMissing("DistanceHorizontal", source: "oracle/codemp/game/q_math.c:1134")
}

/// Source: oracle/codemp/game/q_math.c:1141
public func DistanceHorizontalSquared(_ p1: vec3_t, _ p2: vec3_t) -> vec_t {
    // TODO: Port DistanceHorizontalSquared
    portMissing("DistanceHorizontalSquared", source: "oracle/codemp/game/q_math.c:1141")
}

/// Source: oracle/codemp/game/q_math.c:1148
public func AddPointToBounds(_ v: vec3_t, _ mins: inout vec3_t, _ maxs: inout vec3_t) {
    // TODO: Port AddPointToBounds
    portMissing("AddPointToBounds", source: "oracle/codemp/game/q_math.c:1148")
}

/// Source: oracle/codemp/game/q_math.c:1172
public func VectorNormalize(_ v: inout vec3_t) -> vec_t {
    var length: Float
    var ilength: Float

    length = v[0] * v[0] + v[1] * v[1] + v[2] * v[2]
    // Raven writes `sqrt`, which is the double libm call rounded back to float. A float square root double-rounds and diverges from the golden.
    length = Float(Double(length).squareRoot())

    if length != 0 {
        ilength = 1 / length
        v[0] *= ilength
        v[1] *= ilength
        v[2] *= ilength
    }

    return length
}

/// Source: oracle/codemp/game/q_math.c:1188
public func VectorNormalize2(_ v: vec3_t, _ out: inout vec3_t) -> vec_t {
    // TODO: Port VectorNormalize2
    portMissing("VectorNormalize2", source: "oracle/codemp/game/q_math.c:1188")
}

/// Source: oracle/codemp/game/q_math.c:1214
public func _VectorMA(_ veca: vec3_t, _ scale: Float, _ vecb: vec3_t, _ vecc: inout vec3_t) {
    // TODO: Port _VectorMA
    portMissing("_VectorMA", source: "oracle/codemp/game/q_math.c:1214")
}

/// Source: oracle/codemp/game/q_math.c:1221
public func _DotProduct(_ v1: vec3_t, _ v2: vec3_t) -> vec_t {
    // TODO: Port _DotProduct
    portMissing("_DotProduct", source: "oracle/codemp/game/q_math.c:1221")
}

/// Source: oracle/codemp/game/q_math.c:1225
public func _VectorSubtract(_ veca: vec3_t, _ vecb: vec3_t, _ out: inout vec3_t) {
    // TODO: Port _VectorSubtract
    portMissing("_VectorSubtract", source: "oracle/codemp/game/q_math.c:1225")
}

/// Source: oracle/codemp/game/q_math.c:1231
public func _VectorAdd(_ veca: vec3_t, _ vecb: vec3_t, _ out: inout vec3_t) {
    // TODO: Port _VectorAdd
    portMissing("_VectorAdd", source: "oracle/codemp/game/q_math.c:1231")
}

/// Source: oracle/codemp/game/q_math.c:1237
public func _VectorCopy(_ `in`: vec3_t, _ out: inout vec3_t) {
    // TODO: Port _VectorCopy
    portMissing("_VectorCopy", source: "oracle/codemp/game/q_math.c:1237")
}

/// Source: oracle/codemp/game/q_math.c:1243
public func _VectorScale(_ `in`: vec3_t, _ scale: vec_t, _ out: inout vec3_t) {
    // TODO: Port _VectorScale
    portMissing("_VectorScale", source: "oracle/codemp/game/q_math.c:1243")
}

/// Source: oracle/codemp/game/q_math.c:1249
public func Vector4Scale(_ `in`: vec4_t, _ scale: vec_t, _ out: inout vec4_t) {
    // TODO: Port Vector4Scale
    portMissing("Vector4Scale", source: "oracle/codemp/game/q_math.c:1249")
}

/// Source: oracle/codemp/game/q_math.c:1257
public func Q_log2(_ val: Int32) -> Int32 {
    var val = val
    var answer: Int32

    answer = 0
    while true {
        val >>= 1
        if val == 0 {
            break
        }
        answer += 1
    }
    return answer
}

/**
================
MatrixMultiply
================
*/
/// Source: oracle/codemp/game/q_math.c:1293
public func MatrixMultiply(_ in1: [[Float]], _ in2: [[Float]], _ out: inout [[Float]]) {
    // TODO: Port MatrixMultiply
    portMissing("MatrixMultiply", source: "oracle/codemp/game/q_math.c:1293")
}

/// Raven guards each of the three outputs with a null test, and a `vec3_t` value cannot be null.
/// A Swift caller that wants one output passes a scratch vector for the other two.
/// Source: oracle/codemp/game/q_math.c:1315
public func AngleVectors(_ angles: vec3_t, _ forward: inout vec3_t, _ right: inout vec3_t, _ up: inout vec3_t) {
    // TODO: Port AngleVectors
    portMissing("AngleVectors", source: "oracle/codemp/game/q_math.c:1315")
}

/**
** assumes "src" is normalized
*/
/// Source: oracle/codemp/game/q_math.c:1353
public func PerpendicularVector(_ dst: inout vec3_t, _ src: vec3_t) {
    // TODO: Port PerpendicularVector
    portMissing("PerpendicularVector", source: "oracle/codemp/game/q_math.c:1353")
}

/**
** NormalToLatLong
**
** We use two byte encoded normals in some space critical applications.
** Lat = 0 at (1,0,0) to 360 (-1,0,0), encoded in 8-bit sine table format
** Lng = 0 at (0,0,1) to 180 (0,0,-1), encoded in 8-bit sine table format
**
*/
//rwwRMG - added
/// Source: oracle/codemp/game/q_math.c:1394
public func NormalToLatLong(_ normal: vec3_t, _ bytes: inout (byte, byte)) {
    // check for singularities
    if normal[0] == 0 && normal[1] == 0 {
        if normal[2] > 0.0 {
            bytes.0 = 0
            bytes.1 = 0        // lat = 0, long = 0
        } else {
            bytes.0 = 128
            bytes.1 = 0        // lat = 0, long = 128
        }
    } else {
        var a: Int32
        var b: Int32

        // Raven casts `atan2` to a float first, then `RAD2DEG` divides by the double `M_PI`, so the rest runs in double.
        let scale = Double(Float(255.0) / Float(360.0))
        let atanValue = Float(atan2(Double(normal[1]), Double(normal[0])))
        a = truncateToInt(Double(atanValue * 180.0) / Double.pi * scale)
        a &= 0xff

        let acosValue = Float(acos(Double(normal[2])))
        b = truncateToInt(Double(acosValue * 180.0) / Double.pi * scale)
        b &= 0xff

        bytes.0 = byte(b)    // longitude
        bytes.1 = byte(a)    // lattitude
    }
}

/// Source: oracle/codemp/game/q_math.c:1476
public func powf(_ x: Float, _ y: Int32) -> Float {
    var r = x
    var y = y
    y -= 1
    while y > 0 {
        r = r * r
        y -= 1
    }
    return r
}

/**
-------------------------
DotProductNormalize
-------------------------
*/
/// Source: oracle/codemp/game/q_math.c:1508
public func DotProductNormalize(_ inVec1: vec3_t, _ inVec2: vec3_t) -> Float {
    // TODO: Port DotProductNormalize
    portMissing("DotProductNormalize", source: "oracle/codemp/game/q_math.c:1508")
}

/**
-------------------------
G_FindClosestPointOnLineSegment
-------------------------
*/
/// Source: oracle/codemp/game/q_math.c:1524
public func G_FindClosestPointOnLineSegment(_ start: vec3_t, _ end: vec3_t, _ from: vec3_t, _ result: inout vec3_t) -> Bool {
    // TODO: Port G_FindClosestPointOnLineSegment
    portMissing("G_FindClosestPointOnLineSegment", source: "oracle/codemp/game/q_math.c:1524")
}

/// Source: oracle/codemp/game/q_math.c:1606
public func G_PointDistFromLineSegment(_ start: vec3_t, _ end: vec3_t, _ from: vec3_t) -> Float {
    // TODO: Port G_PointDistFromLineSegment
    portMissing("G_PointDistFromLineSegment", source: "oracle/codemp/game/q_math.c:1606")
}
