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
    dir = bytedirs[b]
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
```
=====================
PlaneFromPoints

Returns false if the triangle is degenrate.
The normal will point out of the clock for clockwise ordered points
=====================
```
*/
/// Source: oracle/codemp/game/q_math.c:384
public func PlaneFromPoints(_ plane: inout vec4_t, _ a: vec3_t, _ b: vec3_t, _ c: vec3_t) -> Bool {
    var d1 = vec3_t()
    var d2 = vec3_t()
    // Raven builds the normal in the first three elements of `plane` and normalizes them in place.
    // A vec4_t is one value here, so the normal goes through a temporary and is written back before either return.
    var normal = vec3_t()

    _VectorSubtract(b, a, &d1)
    _VectorSubtract(c, a, &d2)
    CrossProduct(d2, d1, &normal)
    let length = VectorNormalize(&normal)
    plane[0] = normal[0]
    plane[1] = normal[1]
    plane[2] = normal[2]
    if length == 0 {
        return false
    }

    plane[3] = _DotProduct(a, normal)
    return true
}

/**
```
===============
RotatePointAroundVector

This is not implemented very well...
===============
```
*/
/// Source: oracle/codemp/game/q_math.c:405
public func RotatePointAroundVector(_ dst: inout vec3_t, _ dir: vec3_t, _ point: vec3_t, _ degrees: Float) {
    var m = [[Float]](repeating: [Float](repeating: 0, count: 3), count: 3)
    var im = m
    var zrot = m
    var tmpmat = m
    var rot = m
    var vr = vec3_t()
    var vup = vec3_t()
    var vf = vec3_t()
    var rad: Float

    vf[0] = dir[0]
    vf[1] = dir[1]
    vf[2] = dir[2]

    PerpendicularVector(&vr, dir)
    CrossProduct(vr, vf, &vup)

    m[0][0] = vr[0]
    m[1][0] = vr[1]
    m[2][0] = vr[2]

    m[0][1] = vup[0]
    m[1][1] = vup[1]
    m[2][1] = vup[2]

    m[0][2] = vf[0]
    m[1][2] = vf[1]
    m[2][2] = vf[2]

    im = m

    im[0][1] = m[1][0]
    im[0][2] = m[2][0]
    im[1][0] = m[0][1]
    im[1][2] = m[2][1]
    im[2][0] = m[0][2]
    im[2][1] = m[1][2]

    zrot[0][0] = 1.0
    zrot[1][1] = 1.0
    zrot[2][2] = 1.0

    // Raven's DEG2RAD multiplies by the double M_PI, so the angle runs in double and rounds once.
    rad = Float(Double(degrees) * Double.pi / 180.0)
    zrot[0][0] = Float(cos(Double(rad)))
    zrot[0][1] = Float(sin(Double(rad)))
    zrot[1][0] = -Float(sin(Double(rad)))
    zrot[1][1] = Float(cos(Double(rad)))

    MatrixMultiply(m, zrot, &tmpmat)
    MatrixMultiply(tmpmat, im, &rot)

    for i in 0 ..< 3 {
        dst[i] = rot[i][0] * point[0] + rot[i][1] * point[1] + rot[i][2] * point[2]
    }
}

/**
```
===============
RotateAroundDirection
===============
```
*/
/// Source: oracle/codemp/game/q_math.c:466
public func RotateAroundDirection(_ axis: inout [vec3_t], _ yaw: Float) {

    // create an arbitrary axis[1]
    // Raven passes two elements of one array to one call, and Swift allows one exclusive access, so each result lands through a local.
    var built = vec3_t()
    PerpendicularVector(&built, axis[0])
    axis[1] = built

    // rotate it around axis[0] by yaw
    if yaw != 0 {
        var temp = vec3_t()

        _VectorCopy(axis[1], &temp)
        var rotated = vec3_t()
        RotatePointAroundVector(&rotated, axis[0], temp, yaw)
        axis[1] = rotated
    }

    // cross to get axis[2]
    var crossed = vec3_t()
    CrossProduct(axis[0], axis[1], &crossed)
    axis[2] = crossed
}

/// Source: oracle/codemp/game/q_math.c:485
public func vectoangles(_ value1: vec3_t, _ angles: inout vec3_t) {
    var forward: Float
    var yaw: Float
    var pitch: Float

    if value1[1] == 0 && value1[0] == 0 {
        yaw = 0
        if value1[2] > 0 {
            pitch = 90
        } else {
            pitch = 270
        }
    } else {
        // Raven's atan2 and sqrt are the double libm calls and M_PI is the double of math.h.
        if value1[0] != 0 {
            yaw = Float(atan2(Double(value1[1]), Double(value1[0])) * 180 / Double.pi)
        } else if value1[1] > 0 {
            yaw = 90
        } else {
            yaw = 270
        }
        if yaw < 0 {
            yaw += 360
        }

        forward = Float(Double(value1[0] * value1[0] + value1[1] * value1[1]).squareRoot())
        pitch = Float(atan2(Double(value1[2]), Double(forward)) * 180 / Double.pi)
        if pitch < 0 {
            pitch += 360
        }
    }

    angles[PITCH] = -pitch
    angles[YAW] = yaw
    angles[ROLL] = 0
}

/**
```
=================
AnglesToAxis
=================
```
*/
/// Source: oracle/codemp/game/q_math.c:530
public func AnglesToAxis(_ angles: vec3_t, _ axis: inout [vec3_t]) {
    var right = vec3_t()
    var forward = vec3_t()
    var up = vec3_t()

    // angle vectors returns "right" instead of "y axis"
    AngleVectors(angles, &forward, &right, &up)
    axis[0] = forward
    axis[2] = up
    var yAxis = vec3_t()
    _VectorSubtract(vec3_origin, right, &yAxis)
    axis[1] = yAxis
}

/// Source: oracle/codemp/game/q_math.c:538
public func AxisClear(_ axis: inout [vec3_t]) {
    axis[0][0] = 1
    axis[0][1] = 0
    axis[0][2] = 0
    axis[1][0] = 0
    axis[1][1] = 1
    axis[1][2] = 0
    axis[2][0] = 0
    axis[2][1] = 0
    axis[2][2] = 1
}

/// Source: oracle/codemp/game/q_math.c:550
public func AxisCopy(_ `in`: [vec3_t], _ out: inout [vec3_t]) {
    _VectorCopy(`in`[0], &out[0])
    _VectorCopy(`in`[1], &out[1])
    _VectorCopy(`in`[2], &out[2])
}

/// Source: oracle/codemp/game/q_math.c:556
public func ProjectPointOnPlane(_ dst: inout vec3_t, _ p: vec3_t, _ normal: vec3_t) {
    var d: Float
    var n = vec3_t()
    var inv_denom: Float

    inv_denom = _DotProduct(normal, normal)
    assert(Q_fabs(inv_denom) != 0.0)  // bk010122 - zero vectors get here
    inv_denom = 1.0 / inv_denom

    d = _DotProduct(normal, p) * inv_denom

    n[0] = normal[0] * inv_denom
    n[1] = normal[1] * inv_denom
    n[2] = normal[2] * inv_denom

    dst[0] = p[0] - d * n[0]
    dst[1] = p[1] - d * n[1]
    dst[2] = p[2] - d * n[2]
}

/**
```
================
MakeNormalVectors

Given a normalized forward vector, create two
other perpendicular vectors
================
```
*/
/// Source: oracle/codemp/game/q_math.c:587
public func MakeNormalVectors(_ forward: vec3_t, _ right: inout vec3_t, _ up: inout vec3_t) {
    var d: Float

    // this rotate and negate guarantees a vector
    // not colinear with the original
    right[1] = -forward[0]
    right[2] = forward[1]
    right[0] = forward[2]

    d = _DotProduct(right, forward)
    // Raven's VectorMA is the header macro, which writes one element at a time and reads none of the others.
    right[0] = right[0] + forward[0] * -d
    right[1] = right[1] + forward[1] * -d
    right[2] = right[2] + forward[2] * -d
    _ = VectorNormalize(&right)
    CrossProduct(right, forward, &up)
}

/// Source: oracle/codemp/game/q_math.c:603
public func VectorRotate(_ `in`: vec3_t, _ matrix: [vec3_t], _ out: inout vec3_t) {
    out[0] = _DotProduct(`in`, matrix[0])
    out[1] = _DotProduct(`in`, matrix[1])
    out[2] = _DotProduct(`in`, matrix[2])
}

//============================================================================

/**
```
** float q_rsqrt( float number )
```
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
```
===============
LerpAngle

===============
```
*/
/// Source: oracle/codemp/game/q_math.c:653
public func LerpAngle(_ from: Float, _ to: Float, _ frac: Float) -> Float {
    var to = to
    var a: Float

    if to - from > 180 {
        to -= 360
    }
    if to - from < -180 {
        to += 360
    }
    a = from + frac * (to - from)

    return a
}

/**
```
=================
AngleSubtract

Always returns a value from -180 to 180
=================
```
*/
/// Source: oracle/codemp/game/q_math.c:675
public func AngleSubtract(_ a1: Float, _ a2: Float) -> Float {
    var a: Float

    a = a1 - a2
    a = Float(fmod(Double(a), 360))  //chop it down quickly, then level it out
    while a > 180 {
        a -= 360
    }
    while a < -180 {
        a += 360
    }
    return a
}

/// Source: oracle/codemp/game/q_math.c:690
public func AnglesSubtract(_ v1: vec3_t, _ v2: vec3_t, _ v3: inout vec3_t) {
    v3[0] = AngleSubtract(v1[0], v2[0])
    v3[1] = AngleSubtract(v1[1], v2[1])
    v3[2] = AngleSubtract(v1[2], v2[2])
}

/// Raven's `65536/360.0` and `360.0/65536` are double literals, so the scale and the product run in double and round once.
/// Source: oracle/codemp/game/q_math.c:697
public func AngleMod(_ a: Float) -> Float {
    var a = a
    a = Float((360.0 / 65536.0) * Double(truncateToInt(Double(a) * (65536.0 / 360.0)) & 65535))
    return a
}

/**
```
=================
AngleNormalize360

returns angle normalized to the range [0 <= angle < 360]
=================
```
*/
/// Source: oracle/codemp/game/q_math.c:710
public func AngleNormalize360(_ angle: Float) -> Float {
    // The constants are double literals, as in AngleMod.
    Float((360.0 / 65536.0) * Double(truncateToInt(Double(angle) * (65536.0 / 360.0)) & 65535))
}

/**
```
=================
AngleNormalize180

returns angle normalized to the range [-180 < angle <= 180]
=================
```
*/
/// Source: oracle/codemp/game/q_math.c:722
public func AngleNormalize180(_ angle: Float) -> Float {
    var angle = AngleNormalize360(angle)
    if angle > 180.0 {
        angle -= 360.0
    }
    return angle
}

/**
```
=================
AngleDelta

returns the normalized delta from angle1 to angle2
=================
```
*/
/// Source: oracle/codemp/game/q_math.c:738
public func AngleDelta(_ angle1: Float, _ angle2: Float) -> Float {
    AngleNormalize180(angle1 - angle2)
}

//============================================================

/**
```
=================
SetPlaneSignbits
=================
```
*/
/// Source: oracle/codemp/game/q_math.c:751
public func SetPlaneSignbits(_ out: inout Plane) {
    var bits: Int32

    // for fast box on planeside test
    bits = 0
    for j in 0 ..< 3 {
        if out.normal[j] < 0 {
            bits |= 1 << j
        }
    }
    out.signbits = byte(bits)
}

/**
```
==================
BoxOnPlaneSide

Returns 1, 2, or 1 + 2
==================
```
*/
/// Source: oracle/codemp/game/q_math.c:809
public func BoxOnPlaneSide(_ emins: vec3_t, _ emaxs: vec3_t, _ p: inout Plane) -> Int32 {
    var dist1: Float
    var dist2: Float
    var sides: Int32

// fast axial cases
    if p.type < 3 {
        if p.dist <= emins[p.type] {
            return 1
        }
        if p.dist >= emaxs[p.type] {
            return 2
        }
        return 3
    }

// general case
    switch p.signbits {
    case 0:
        dist1 = p.normal[0] * emaxs[0] + p.normal[1] * emaxs[1] + p.normal[2] * emaxs[2]
        dist2 = p.normal[0] * emins[0] + p.normal[1] * emins[1] + p.normal[2] * emins[2]

    case 1:
        dist1 = p.normal[0] * emins[0] + p.normal[1] * emaxs[1] + p.normal[2] * emaxs[2]
        dist2 = p.normal[0] * emaxs[0] + p.normal[1] * emins[1] + p.normal[2] * emins[2]

    case 2:
        dist1 = p.normal[0] * emaxs[0] + p.normal[1] * emins[1] + p.normal[2] * emaxs[2]
        dist2 = p.normal[0] * emins[0] + p.normal[1] * emaxs[1] + p.normal[2] * emins[2]

    case 3:
        dist1 = p.normal[0] * emins[0] + p.normal[1] * emins[1] + p.normal[2] * emaxs[2]
        dist2 = p.normal[0] * emaxs[0] + p.normal[1] * emaxs[1] + p.normal[2] * emins[2]

    case 4:
        dist1 = p.normal[0] * emaxs[0] + p.normal[1] * emaxs[1] + p.normal[2] * emins[2]
        dist2 = p.normal[0] * emins[0] + p.normal[1] * emins[1] + p.normal[2] * emaxs[2]

    case 5:
        dist1 = p.normal[0] * emins[0] + p.normal[1] * emaxs[1] + p.normal[2] * emins[2]
        dist2 = p.normal[0] * emaxs[0] + p.normal[1] * emins[1] + p.normal[2] * emaxs[2]

    case 6:
        dist1 = p.normal[0] * emaxs[0] + p.normal[1] * emins[1] + p.normal[2] * emins[2]
        dist2 = p.normal[0] * emins[0] + p.normal[1] * emaxs[1] + p.normal[2] * emaxs[2]

    case 7:
        dist1 = p.normal[0] * emins[0] + p.normal[1] * emins[1] + p.normal[2] * emins[2]
        dist2 = p.normal[0] * emaxs[0] + p.normal[1] * emaxs[1] + p.normal[2] * emaxs[2]

    default:
        dist1 = 0
        dist2 = 0        // shut up compiler
    }

    sides = 0
    if dist1 >= p.dist {
        sides = 1
    }
    if dist2 < p.dist {
        sides |= 2
    }

    return sides
}

/**
```
=================
RadiusFromBounds
=================
```
*/
/// Source: oracle/codemp/game/q_math.c:1114
public func RadiusFromBounds(_ mins: vec3_t, _ maxs: vec3_t) -> Float {
    var corner = vec3_t()
    var a: Float
    var b: Float

    for i in 0 ..< 3 {
        a = abs(mins[i])
        b = abs(maxs[i])
        corner[i] = a > b ? a : b
    }

    return VectorLength(corner)
}

/// Source: oracle/codemp/game/q_math.c:1129
public func ClearBounds(_ mins: inout vec3_t, _ maxs: inout vec3_t) {
    mins[0] = 99999
    mins[1] = 99999
    mins[2] = 99999
    maxs[0] = -99999
    maxs[1] = -99999
    maxs[2] = -99999
}

/// Source: oracle/codemp/game/q_math.c:1134
public func DistanceHorizontal(_ p1: vec3_t, _ p2: vec3_t) -> vec_t {
    var v = vec3_t()

    _VectorSubtract(p2, p1, &v)
    // Raven writes `sqrt`, the double libm call rounded back to float.
    return Float(Double(v[0] * v[0] + v[1] * v[1]).squareRoot())    //Leave off the z component
}

/// Source: oracle/codemp/game/q_math.c:1141
public func DistanceHorizontalSquared(_ p1: vec3_t, _ p2: vec3_t) -> vec_t {
    var v = vec3_t()

    _VectorSubtract(p2, p1, &v)
    return v[0] * v[0] + v[1] * v[1]    //Leave off the z component
}

/// Source: oracle/codemp/game/q_math.c:1148
public func AddPointToBounds(_ v: vec3_t, _ mins: inout vec3_t, _ maxs: inout vec3_t) {
    if v[0] < mins[0] {
        mins[0] = v[0]
    }
    if v[0] > maxs[0] {
        maxs[0] = v[0]
    }

    if v[1] < mins[1] {
        mins[1] = v[1]
    }
    if v[1] > maxs[1] {
        maxs[1] = v[1]
    }

    if v[2] < mins[2] {
        mins[2] = v[2]
    }
    if v[2] > maxs[2] {
        maxs[2] = v[2]
    }
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
    var length: Float
    var ilength: Float

    length = v[0] * v[0] + v[1] * v[1] + v[2] * v[2]
    // Raven writes `sqrt`, the double libm call rounded back to float.
    length = Float(Double(length).squareRoot())

    if length != 0 {
        ilength = 1 / length
        out[0] = v[0] * ilength
        out[1] = v[1] * ilength
        out[2] = v[2] * ilength
    } else {
        out = vec3_t(0, 0, 0)
    }

    return length
}

/// Source: oracle/codemp/game/q_math.c:1214
public func _VectorMA(_ veca: vec3_t, _ scale: Float, _ vecb: vec3_t, _ vecc: inout vec3_t) {
    vecc[0] = veca[0] + scale * vecb[0]
    vecc[1] = veca[1] + scale * vecb[1]
    vecc[2] = veca[2] + scale * vecb[2]
}

/// A SIMD reduction may reassociate, so the sum keeps Raven's scalar order.
/// Source: oracle/codemp/game/q_math.c:1221
public func _DotProduct(_ v1: vec3_t, _ v2: vec3_t) -> vec_t {
    v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2]
}

/// Source: oracle/codemp/game/q_math.c:1225
public func _VectorSubtract(_ veca: vec3_t, _ vecb: vec3_t, _ out: inout vec3_t) {
    out[0] = veca[0] - vecb[0]
    out[1] = veca[1] - vecb[1]
    out[2] = veca[2] - vecb[2]
}

/// Source: oracle/codemp/game/q_math.c:1231
public func _VectorAdd(_ veca: vec3_t, _ vecb: vec3_t, _ out: inout vec3_t) {
    out[0] = veca[0] + vecb[0]
    out[1] = veca[1] + vecb[1]
    out[2] = veca[2] + vecb[2]
}

/// Source: oracle/codemp/game/q_math.c:1237
public func _VectorCopy(_ `in`: vec3_t, _ out: inout vec3_t) {
    out[0] = `in`[0]
    out[1] = `in`[1]
    out[2] = `in`[2]
}

/// Source: oracle/codemp/game/q_math.c:1243
public func _VectorScale(_ `in`: vec3_t, _ scale: vec_t, _ out: inout vec3_t) {
    out[0] = `in`[0] * scale
    out[1] = `in`[1] * scale
    out[2] = `in`[2] * scale
}

/// Source: oracle/codemp/game/q_math.c:1249
public func Vector4Scale(_ `in`: vec4_t, _ scale: vec_t, _ out: inout vec4_t) {
    out[0] = `in`[0] * scale
    out[1] = `in`[1] * scale
    out[2] = `in`[2] * scale
    out[3] = `in`[3] * scale
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
```
================
MatrixMultiply
================
```
*/
/// Source: oracle/codemp/game/q_math.c:1293
public func MatrixMultiply(_ in1: [[Float]], _ in2: [[Float]], _ out: inout [[Float]]) {
    out[0][0] = in1[0][0] * in2[0][0] + in1[0][1] * in2[1][0] +
                in1[0][2] * in2[2][0]
    out[0][1] = in1[0][0] * in2[0][1] + in1[0][1] * in2[1][1] +
                in1[0][2] * in2[2][1]
    out[0][2] = in1[0][0] * in2[0][2] + in1[0][1] * in2[1][2] +
                in1[0][2] * in2[2][2]
    out[1][0] = in1[1][0] * in2[0][0] + in1[1][1] * in2[1][0] +
                in1[1][2] * in2[2][0]
    out[1][1] = in1[1][0] * in2[0][1] + in1[1][1] * in2[1][1] +
                in1[1][2] * in2[2][1]
    out[1][2] = in1[1][0] * in2[0][2] + in1[1][1] * in2[1][2] +
                in1[1][2] * in2[2][2]
    out[2][0] = in1[2][0] * in2[0][0] + in1[2][1] * in2[1][0] +
                in1[2][2] * in2[2][0]
    out[2][1] = in1[2][0] * in2[0][1] + in1[2][1] * in2[1][1] +
                in1[2][2] * in2[2][1]
    out[2][2] = in1[2][0] * in2[0][2] + in1[2][1] * in2[1][2] +
                in1[2][2] * in2[2][2]
}

/// Raven guards each of the three outputs with a null test, and a `vec3_t` value cannot be null.
/// A Swift caller that wants one output passes a scratch vector for the other two.
/// Source: oracle/codemp/game/q_math.c:1315
public func AngleVectors(_ angles: vec3_t, _ forward: inout vec3_t, _ right: inout vec3_t, _ up: inout vec3_t) {
    var angle: Float
    var sr: Float
    var sp: Float
    var sy: Float
    var cr: Float
    var cp: Float
    var cy: Float
    // static to help MS compiler fp bugs
    // Raven marks the six temporaries static, and each is written before it is read, so a local holds the same value.

    // M_PI is the double of math.h, so each angle runs in double and rounds once. sin and cos are the double libm calls.
    angle = Float(Double(angles[YAW]) * (Double.pi * 2 / 360))
    sy = Float(sin(Double(angle)))
    cy = Float(cos(Double(angle)))
    angle = Float(Double(angles[PITCH]) * (Double.pi * 2 / 360))
    sp = Float(sin(Double(angle)))
    cp = Float(cos(Double(angle)))
    angle = Float(Double(angles[ROLL]) * (Double.pi * 2 / 360))
    sr = Float(sin(Double(angle)))
    cr = Float(cos(Double(angle)))

    forward[0] = cp * cy
    forward[1] = cp * sy
    forward[2] = -sp

    right[0] = (-1 * sr * sp * cy + -1 * cr * -sy)
    right[1] = (-1 * sr * sp * sy + -1 * cr * cy)
    right[2] = -1 * sr * cp

    up[0] = (cr * sp * cy + -sr * -sy)
    up[1] = (cr * sp * sy + -sr * cy)
    up[2] = cr * cp
}

/**
```
** assumes "src" is normalized
```
*/
/// Source: oracle/codemp/game/q_math.c:1353
public func PerpendicularVector(_ dst: inout vec3_t, _ src: vec3_t) {
    var pos: Int
    var minelem: Float = 1.0
    var tempvec = vec3_t()

    /*
    ** find the smallest magnitude axially aligned vector
    */
    pos = 0
    for i in 0 ..< 3 {
        if abs(src[i]) < minelem {
            pos = i
            minelem = abs(src[i])
        }
    }
    tempvec[0] = 0.0
    tempvec[1] = 0.0
    tempvec[2] = 0.0
    tempvec[pos] = 1.0

    /*
    ** project the point onto the plane defined by src
    */
    ProjectPointOnPlane(&dst, tempvec, src)

    /*
    ** normalize the result
    */
    _ = VectorNormalize(&dst)
}

/**
```
** NormalToLatLong
**
** We use two byte encoded normals in some space critical applications.
** Lat = 0 at (1,0,0) to 360 (-1,0,0), encoded in 8-bit sine table format
** Lng = 0 at (0,0,1) to 180 (0,0,-1), encoded in 8-bit sine table format
**
```
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
```
-------------------------
DotProductNormalize
-------------------------
```
*/
/// Source: oracle/codemp/game/q_math.c:1508
public func DotProductNormalize(_ inVec1: vec3_t, _ inVec2: vec3_t) -> Float {
    var v1 = vec3_t()
    var v2 = vec3_t()

    _ = VectorNormalize2(inVec1, &v1)
    _ = VectorNormalize2(inVec2, &v2)

    return _DotProduct(v1, v2)
}

/**
```
-------------------------
G_FindClosestPointOnLineSegment
-------------------------
```
*/
/// Source: oracle/codemp/game/q_math.c:1524
public func G_FindClosestPointOnLineSegment(_ start: vec3_t, _ end: vec3_t, _ from: vec3_t, _ result: inout vec3_t) -> Bool {
    var vecStart2From = vec3_t()
    var vecStart2End = vec3_t()
    var vecEnd2Start = vec3_t()
    var vecEnd2From = vec3_t()
    var distEnd2From: Float
    var distEnd2Result: Float
    var theta: Float
    var cos_theta: Float
    var dot: Float

    //Find the perpendicular vector to vec from start to end
    _VectorSubtract(from, start, &vecStart2From)
    _VectorSubtract(end, start, &vecStart2End)

    dot = DotProductNormalize(vecStart2From, vecStart2End)

    if dot <= 0 {
        //The perpendicular would be beyond or through the start point
        _VectorCopy(start, &result)
        return false
    }

    if dot == 1 {
        //parallel, closer of 2 points will be the target
        if VectorLengthSquared(vecStart2From) < VectorLengthSquared(vecStart2End) {
            _VectorCopy(from, &result)
        } else {
            _VectorCopy(end, &result)
        }
        return false
    }

    //Try other end
    _VectorSubtract(from, end, &vecEnd2From)
    _VectorSubtract(start, end, &vecEnd2Start)

    dot = DotProductNormalize(vecEnd2From, vecEnd2Start)

    if dot <= 0 {
        //The perpendicular would be beyond or through the start point
        _VectorCopy(end, &result)
        return false
    }

    if dot == 1 {
        //parallel, closer of 2 points will be the target
        if VectorLengthSquared(vecEnd2From) < VectorLengthSquared(vecEnd2Start) {
            _VectorCopy(from, &result)
        } else {
            _VectorCopy(end, &result)
        }
        return false
    }

    //		      /|
    //		  c  / |
    //		    /  |a
    //	theta  /)__|
    //		      b
    //cos(theta) = b / c
    //solve for b
    //b = cos(theta) * c

    //angle between vecs end2from and end2start, should be between 0 and 90
    theta = 90 * (1 - dot)//theta

    //Get length of side from End2Result using sine of theta
    distEnd2From = VectorLength(vecEnd2From)//c
    cos_theta = Float(cos(Double(theta) * Double.pi / 180.0))//cos(theta)
    distEnd2Result = cos_theta * distEnd2From//b

    //Extrapolate to find result
    _ = VectorNormalize(&vecEnd2Start)
    // Raven's VectorMA is the header macro, which multiplies the vector by the scale.
    result[0] = end[0] + vecEnd2Start[0] * distEnd2Result
    result[1] = end[1] + vecEnd2Start[1] * distEnd2Result
    result[2] = end[2] + vecEnd2Start[2] * distEnd2Result

    //perpendicular intersection is between the 2 endpoints
    return true
}

/// Source: oracle/codemp/game/q_math.c:1606
public func G_PointDistFromLineSegment(_ start: vec3_t, _ end: vec3_t, _ from: vec3_t) -> Float {
    var vecStart2From = vec3_t()
    var vecStart2End = vec3_t()
    var vecEnd2Start = vec3_t()
    var vecEnd2From = vec3_t()
    var intersection = vec3_t()
    var distEnd2From: Float
    var distStart2From: Float
    var distEnd2Result: Float
    var theta: Float
    var cos_theta: Float
    var dot: Float

    //Find the perpendicular vector to vec from start to end
    _VectorSubtract(from, start, &vecStart2From)
    _VectorSubtract(end, start, &vecStart2End)
    _VectorSubtract(from, end, &vecEnd2From)
    _VectorSubtract(start, end, &vecEnd2Start)

    dot = DotProductNormalize(vecStart2From, vecStart2End)

    distStart2From = Distance(start, from)
    distEnd2From = Distance(end, from)

    if dot <= 0 {
        //The perpendicular would be beyond or through the start point
        return distStart2From
    }

    if dot == 1 {
        //parallel, closer of 2 points will be the target
        return distStart2From < distEnd2From ? distStart2From : distEnd2From
    }

    //Try other end

    dot = DotProductNormalize(vecEnd2From, vecEnd2Start)

    if dot <= 0 {
        //The perpendicular would be beyond or through the end point
        return distEnd2From
    }

    if dot == 1 {
        //parallel, closer of 2 points will be the target
        return distStart2From < distEnd2From ? distStart2From : distEnd2From
    }

    //		      /|
    //		  c  / |
    //		    /  |a
    //	theta  /)__|
    //		      b
    //cos(theta) = b / c
    //solve for b
    //b = cos(theta) * c

    //angle between vecs end2from and end2start, should be between 0 and 90
    theta = 90 * (1 - dot)//theta

    //Get length of side from End2Result using sine of theta
    cos_theta = Float(cos(Double(theta) * Double.pi / 180.0))//cos(theta)
    distEnd2Result = cos_theta * distEnd2From//b

    //Extrapolate to find result
    _ = VectorNormalize(&vecEnd2Start)
    // Raven's VectorMA is the header macro, which multiplies the vector by the scale.
    intersection[0] = end[0] + vecEnd2Start[0] * distEnd2Result
    intersection[1] = end[1] + vecEnd2Start[1] * distEnd2Result
    intersection[2] = end[2] + vecEnd2Start[2] * distEnd2Result

    //perpendicular intersection is between the 2 endpoints, return dist to it from from
    return Distance(intersection, from)
}

// MARK: - The header twins of q_shared.h

// q_math.c guards these eight with `#ifdef __LCC__`, so the native build takes the `static ID_INLINE` twin of q_shared.h.
// The twin is the live code, and it lands here because it is one body with the file it belongs to.
// The `_XBOX` asm branches are dropped, because the plain C branch is the one a native build compiles.

/// Source: oracle/codemp/game/q_shared.h:1453
public func VectorCompare(_ v1: vec3_t, _ v2: vec3_t) -> Int32 {
    if v1[0] != v2[0] || v1[1] != v2[1] || v1[2] != v2[2] {
        return 0
    }
    return 1
}

/// Source: oracle/codemp/game/q_shared.h:1460
public func VectorLength(_ v: vec3_t) -> vec_t {
    // Raven writes `(vec_t)sqrt(..)`. The sum is float, and sqrt is the double libm call rounded back to float.
    Float(Double(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]).squareRoot())
}

/// Source: oracle/codemp/game/q_shared.h:1491
public func VectorLengthSquared(_ v: vec3_t) -> vec_t {
    v[0] * v[0] + v[1] * v[1] + v[2] * v[2]
}

/// Source: oracle/codemp/game/q_shared.h:1520
public func Distance(_ p1: vec3_t, _ p2: vec3_t) -> vec_t {
    var v = vec3_t()

    _VectorSubtract(p2, p1, &v)
    return VectorLength(v)
}

/// Source: oracle/codemp/game/q_shared.h:1527
public func DistanceSquared(_ p1: vec3_t, _ p2: vec3_t) -> vec_t {
    var v = vec3_t()

    _VectorSubtract(p2, p1, &v)
    return v[0] * v[0] + v[1] * v[1] + v[2] * v[2]
}

// fast vector normalize routine that does not check to make sure
// that length != 0, nor does it return length, uses rsqrt approximation
/// Source: oracle/codemp/game/q_shared.h:1536
public func VectorNormalizeFast(_ v: inout vec3_t) {
    var ilength: Float

    ilength = Q_rsqrt(_DotProduct(v, v))

    v[0] *= ilength
    v[1] *= ilength
    v[2] *= ilength
}

/// Source: oracle/codemp/game/q_shared.h:1547
public func VectorInverse(_ v: inout vec3_t) {
    v[0] = -v[0]
    v[1] = -v[1]
    v[2] = -v[2]
}

/// Source: oracle/codemp/game/q_shared.h:1553
public func CrossProduct(_ v1: vec3_t, _ v2: vec3_t, _ cross: inout vec3_t) {
    cross[0] = v1[1] * v2[2] - v1[2] * v2[1]
    cross[1] = v1[2] * v2[0] - v1[0] * v2[2]
    cross[2] = v1[0] * v2[1] - v1[1] * v2[0]
}

/// Pitiful attempt to reduce _ftol2 calls.
/// Source: oracle/codemp/game/q_shared.h:1408
public func SnapVector(_ v: inout vec3_t) {
    v[0] = Float(Int32(v[0]))
    v[1] = Float(Int32(v[1]))
    v[2] = Float(Int32(v[2]))
}

/// Source: oracle/codemp/game/q_shared.h:1972
public func ANGLE2SHORT(_ x: Float) -> Int32 {
    Int32(x * 65536 / 360) & 65535
}

/// Source: oracle/codemp/game/q_shared.h:1973
public func SHORT2ANGLE(_ x: Int32) -> Float {
    // Raven's 360.0 is a double literal, so the multiply runs in double and narrows to float once, on return.
    Float(Double(x) * (360.0 / 65536))
}

/// Source: oracle/codemp/game/q_shared.h:1856
public func PlaneTypeForNormal(_ x: vec3_t) -> Int32 {
    if x[0] == 1.0 {
        return PLANE_X
    }
    if x[1] == 1.0 {
        return PLANE_Y
    }
    if x[2] == 1.0 {
        return PLANE_Z
    }
    return PLANE_NON_AXIAL
}
