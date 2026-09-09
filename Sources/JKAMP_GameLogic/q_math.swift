// Adopted from tools/oracle-closure/skeleton.py, rule 13. The five holdrand stubs moved to Rng in JKAShared and g_local.swift.

import JKAMP
import JKAShared
import JKAMP_Game

/// Source: oracle/codemp/game/q_math.c:126
// TODO: Port signature
// Raven wrote: int Q_rand( int *seed )
// No table row for `int * seed`.
func Q_rand() -> Never {
    // TODO: Port Q_rand
    portMissing("Q_rand", source: "oracle/codemp/game/q_math.c:126")
}

/// Source: oracle/codemp/game/q_math.c:131
// TODO: Port signature
// Raven wrote: float Q_random( int *seed )
// No table row for `int * seed`.
func Q_random() -> Never {
    // TODO: Port Q_random
    portMissing("Q_random", source: "oracle/codemp/game/q_math.c:131")
}

/// Source: oracle/codemp/game/q_math.c:135
// TODO: Port signature
// Raven wrote: float Q_crandom( int *seed )
// No table row for `int * seed`.
func Q_crandom() -> Never {
    // TODO: Port Q_crandom
    portMissing("Q_crandom", source: "oracle/codemp/game/q_math.c:135")
}

/// Source: oracle/codemp/game/q_math.c:279
func ClampChar(_ i: Int32) -> Int8 {
    // TODO: Port ClampChar
    portMissing("ClampChar", source: "oracle/codemp/game/q_math.c:279")
}

/// Source: oracle/codemp/game/q_math.c:289
func ClampShort(_ i: Int32) -> Int16 {
    // TODO: Port ClampShort
    portMissing("ClampShort", source: "oracle/codemp/game/q_math.c:289")
}

// this isn't a real cheap function to call!
/// Source: oracle/codemp/game/q_math.c:301
func DirToByte(_ dir: JKAShared.vec3_t) -> Int32 {
    // TODO: Port DirToByte
    portMissing("DirToByte", source: "oracle/codemp/game/q_math.c:301")
}

/// Source: oracle/codemp/game/q_math.c:324
func ByteToDir(_ b: Int32, _ dir: JKAShared.vec3_t) {
    // TODO: Port ByteToDir
    portMissing("ByteToDir", source: "oracle/codemp/game/q_math.c:324")
}

/// Source: oracle/codemp/game/q_math.c:333
func ColorBytes3(_ r: Float, _ g: Float, _ b: Float) -> UInt32 {
    // TODO: Port ColorBytes3
    portMissing("ColorBytes3", source: "oracle/codemp/game/q_math.c:333")
}

/// Source: oracle/codemp/game/q_math.c:343
func ColorBytes4(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> UInt32 {
    // TODO: Port ColorBytes4
    portMissing("ColorBytes4", source: "oracle/codemp/game/q_math.c:343")
}

/// Source: oracle/codemp/game/q_math.c:354
func NormalizeColor(_ `in`: JKAShared.vec3_t, _ out: JKAShared.vec3_t) -> Float {
    // TODO: Port NormalizeColor
    portMissing("NormalizeColor", source: "oracle/codemp/game/q_math.c:354")
}

/**
=====================
PlaneFromPoints

Returns false if the triangle is degenrate.
The normal will point out of the clock for clockwise ordered points
=====================
*/
/// Source: oracle/codemp/game/q_math.c:384
// TODO: Port signature
// Raven wrote: qboolean PlaneFromPoints( vec4_t plane, const vec3_t a, const vec3_t b, const vec3_t c )
// No table row for `vec4_t plane`.
func PlaneFromPoints() -> Never {
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
func RotatePointAroundVector(_ dst: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ point: JKAShared.vec3_t, _ degrees: Float) {
    // TODO: Port RotatePointAroundVector
    portMissing("RotatePointAroundVector", source: "oracle/codemp/game/q_math.c:405")
}

/**
===============
RotateAroundDirection
===============
*/
/// Source: oracle/codemp/game/q_math.c:466
// TODO: Port signature
// Raven wrote: void RotateAroundDirection( vec3_t axis[3], float yaw )
// No table row for `vec3_t[3] axis`.
func RotateAroundDirection() -> Never {
    // TODO: Port RotateAroundDirection
    portMissing("RotateAroundDirection", source: "oracle/codemp/game/q_math.c:466")
}

/// Source: oracle/codemp/game/q_math.c:485
func vectoangles(_ value1: JKAShared.vec3_t, _ angles: JKAShared.vec3_t) {
    // TODO: Port vectoangles
    portMissing("vectoangles", source: "oracle/codemp/game/q_math.c:485")
}

/**
=================
AnglesToAxis
=================
*/
/// Source: oracle/codemp/game/q_math.c:530
// TODO: Port signature
// Raven wrote: void AnglesToAxis( const vec3_t angles, vec3_t axis[3] )
// No table row for `vec3_t[3] axis`.
func AnglesToAxis() -> Never {
    // TODO: Port AnglesToAxis
    portMissing("AnglesToAxis", source: "oracle/codemp/game/q_math.c:530")
}

/// Source: oracle/codemp/game/q_math.c:538
// TODO: Port signature
// Raven wrote: void AxisClear( vec3_t axis[3] )
// No table row for `vec3_t[3] axis`.
func AxisClear() -> Never {
    // TODO: Port AxisClear
    portMissing("AxisClear", source: "oracle/codemp/game/q_math.c:538")
}

/// Source: oracle/codemp/game/q_math.c:550
// TODO: Port signature
// Raven wrote: void AxisCopy( vec3_t in[3], vec3_t out[3] )
// No table row for `vec3_t[3] in`.
func AxisCopy() -> Never {
    // TODO: Port AxisCopy
    portMissing("AxisCopy", source: "oracle/codemp/game/q_math.c:550")
}

/// Source: oracle/codemp/game/q_math.c:556
func ProjectPointOnPlane(_ dst: JKAShared.vec3_t, _ p: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
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
func MakeNormalVectors(_ forward: JKAShared.vec3_t, _ right: JKAShared.vec3_t, _ up: JKAShared.vec3_t) {
    // TODO: Port MakeNormalVectors
    portMissing("MakeNormalVectors", source: "oracle/codemp/game/q_math.c:587")
}

/// Source: oracle/codemp/game/q_math.c:603
// TODO: Port signature
// Raven wrote: void VectorRotate( vec3_t in, vec3_t matrix[3], vec3_t out )
// No table row for `vec3_t[3] matrix`.
func VectorRotate() -> Never {
    // TODO: Port VectorRotate
    portMissing("VectorRotate", source: "oracle/codemp/game/q_math.c:603")
}

/**
** float q_rsqrt( float number )
*/
/// Source: oracle/codemp/game/q_math.c:616
func Q_rsqrt(_ number: Float) -> Float {
    // TODO: Port Q_rsqrt
    portMissing("Q_rsqrt", source: "oracle/codemp/game/q_math.c:616")
}

/// Source: oracle/codemp/game/q_math.c:638
func Q_fabs(_ f: Float) -> Float {
    // TODO: Port Q_fabs
    portMissing("Q_fabs", source: "oracle/codemp/game/q_math.c:638")
}

/**
===============
LerpAngle

===============
*/
/// Source: oracle/codemp/game/q_math.c:653
func LerpAngle(_ from: Float, _ to: Float, _ frac: Float) -> Float {
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
func AngleSubtract(_ a1: Float, _ a2: Float) -> Float {
    // TODO: Port AngleSubtract
    portMissing("AngleSubtract", source: "oracle/codemp/game/q_math.c:675")
}

/// Source: oracle/codemp/game/q_math.c:690
func AnglesSubtract(_ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t, _ v3: JKAShared.vec3_t) {
    // TODO: Port AnglesSubtract
    portMissing("AnglesSubtract", source: "oracle/codemp/game/q_math.c:690")
}

/// Source: oracle/codemp/game/q_math.c:697
func AngleMod(_ a: Float) -> Float {
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
func AngleNormalize360(_ angle: Float) -> Float {
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
func AngleNormalize180(_ angle: Float) -> Float {
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
func AngleDelta(_ angle1: Float, _ angle2: Float) -> Float {
    // TODO: Port AngleDelta
    portMissing("AngleDelta", source: "oracle/codemp/game/q_math.c:738")
}

/**
=================
SetPlaneSignbits
=================
*/
/// Source: oracle/codemp/game/q_math.c:751
func SetPlaneSignbits(_ out: JKAShared.Cplane) {
    // TODO: Port SetPlaneSignbits
    portMissing("SetPlaneSignbits", source: "oracle/codemp/game/q_math.c:751")
}

/// Source: oracle/codemp/game/q_math.c:809
func BoxOnPlaneSide(_ emins: JKAShared.vec3_t, _ emaxs: JKAShared.vec3_t, _ p: JKAShared.Cplane) -> Int32 {
    // TODO: Port BoxOnPlaneSide
    portMissing("BoxOnPlaneSide", source: "oracle/codemp/game/q_math.c:809")
}

/**
=================
RadiusFromBounds
=================
*/
/// Source: oracle/codemp/game/q_math.c:1114
func RadiusFromBounds(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) -> Float {
    // TODO: Port RadiusFromBounds
    portMissing("RadiusFromBounds", source: "oracle/codemp/game/q_math.c:1114")
}

/// Source: oracle/codemp/game/q_math.c:1129
func ClearBounds(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) {
    // TODO: Port ClearBounds
    portMissing("ClearBounds", source: "oracle/codemp/game/q_math.c:1129")
}

/// Source: oracle/codemp/game/q_math.c:1134
func DistanceHorizontal(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Float {
    // TODO: Port DistanceHorizontal
    portMissing("DistanceHorizontal", source: "oracle/codemp/game/q_math.c:1134")
}

/// Source: oracle/codemp/game/q_math.c:1141
func DistanceHorizontalSquared(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Float {
    // TODO: Port DistanceHorizontalSquared
    portMissing("DistanceHorizontalSquared", source: "oracle/codemp/game/q_math.c:1141")
}

/// Source: oracle/codemp/game/q_math.c:1148
func AddPointToBounds(_ v: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) {
    // TODO: Port AddPointToBounds
    portMissing("AddPointToBounds", source: "oracle/codemp/game/q_math.c:1148")
}

/// Source: oracle/codemp/game/q_math.c:1172
func VectorNormalize(_ v: JKAShared.vec3_t) -> Float {
    // TODO: Port VectorNormalize
    portMissing("VectorNormalize", source: "oracle/codemp/game/q_math.c:1172")
}

/// Source: oracle/codemp/game/q_math.c:1188
func VectorNormalize2(_ v: JKAShared.vec3_t, _ out: JKAShared.vec3_t) -> Float {
    // TODO: Port VectorNormalize2
    portMissing("VectorNormalize2", source: "oracle/codemp/game/q_math.c:1188")
}

/// Source: oracle/codemp/game/q_math.c:1214
func _VectorMA(_ veca: JKAShared.vec3_t, _ scale: Float, _ vecb: JKAShared.vec3_t, _ vecc: JKAShared.vec3_t) {
    // TODO: Port _VectorMA
    portMissing("_VectorMA", source: "oracle/codemp/game/q_math.c:1214")
}

/// Source: oracle/codemp/game/q_math.c:1221
func _DotProduct(_ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t) -> Float {
    // TODO: Port _DotProduct
    portMissing("_DotProduct", source: "oracle/codemp/game/q_math.c:1221")
}

/// Source: oracle/codemp/game/q_math.c:1225
func _VectorSubtract(_ veca: JKAShared.vec3_t, _ vecb: JKAShared.vec3_t, _ out: JKAShared.vec3_t) {
    // TODO: Port _VectorSubtract
    portMissing("_VectorSubtract", source: "oracle/codemp/game/q_math.c:1225")
}

/// Source: oracle/codemp/game/q_math.c:1231
func _VectorAdd(_ veca: JKAShared.vec3_t, _ vecb: JKAShared.vec3_t, _ out: JKAShared.vec3_t) {
    // TODO: Port _VectorAdd
    portMissing("_VectorAdd", source: "oracle/codemp/game/q_math.c:1231")
}

/// Source: oracle/codemp/game/q_math.c:1237
func _VectorCopy(_ `in`: JKAShared.vec3_t, _ out: JKAShared.vec3_t) {
    // TODO: Port _VectorCopy
    portMissing("_VectorCopy", source: "oracle/codemp/game/q_math.c:1237")
}

/// Source: oracle/codemp/game/q_math.c:1243
func _VectorScale(_ `in`: JKAShared.vec3_t, _ scale: Float, _ out: JKAShared.vec3_t) {
    // TODO: Port _VectorScale
    portMissing("_VectorScale", source: "oracle/codemp/game/q_math.c:1243")
}

/// Source: oracle/codemp/game/q_math.c:1249
// TODO: Port signature
// Raven wrote: void Vector4Scale( const vec4_t in, vec_t scale, vec4_t out )
// No table row for `const vec4_t in`.
func Vector4Scale() -> Never {
    // TODO: Port Vector4Scale
    portMissing("Vector4Scale", source: "oracle/codemp/game/q_math.c:1249")
}

/// Source: oracle/codemp/game/q_math.c:1257
func Q_log2(_ val: Int32) -> Int32 {
    // TODO: Port Q_log2
    portMissing("Q_log2", source: "oracle/codemp/game/q_math.c:1257")
}

/**
================
MatrixMultiply
================
*/
/// Source: oracle/codemp/game/q_math.c:1293
// TODO: Port signature
// Raven wrote: void MatrixMultiply(float in1[3][3], float in2[3][3], float out[3][3])
// No table row for `float[3][3] in1`.
func MatrixMultiply() -> Never {
    // TODO: Port MatrixMultiply
    portMissing("MatrixMultiply", source: "oracle/codemp/game/q_math.c:1293")
}

/// Source: oracle/codemp/game/q_math.c:1315
func AngleVectors(_ angles: JKAShared.vec3_t, _ forward: JKAShared.vec3_t, _ right: JKAShared.vec3_t, _ up: JKAShared.vec3_t) {
    // TODO: Port AngleVectors
    portMissing("AngleVectors", source: "oracle/codemp/game/q_math.c:1315")
}

/**
** assumes "src" is normalized
*/
/// Source: oracle/codemp/game/q_math.c:1353
func PerpendicularVector(_ dst: JKAShared.vec3_t, _ src: JKAShared.vec3_t) {
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
// TODO: Port signature
// Raven wrote: void NormalToLatLong( const vec3_t normal, byte bytes[2] )
// No table row for `byte[2] bytes`.
func NormalToLatLong() -> Never {
    // TODO: Port NormalToLatLong
    portMissing("NormalToLatLong", source: "oracle/codemp/game/q_math.c:1394")
}

/// Source: oracle/codemp/game/q_math.c:1476
func powf(_ x: Float, _ y: Int32) -> Float {
    // TODO: Port powf
    portMissing("powf", source: "oracle/codemp/game/q_math.c:1476")
}

/// Source: oracle/codemp/game/q_math.c:1508
func DotProductNormalize(_ inVec1: JKAShared.vec3_t, _ inVec2: JKAShared.vec3_t) -> Float {
    // TODO: Port DotProductNormalize
    portMissing("DotProductNormalize", source: "oracle/codemp/game/q_math.c:1508")
}

/// Source: oracle/codemp/game/q_math.c:1524
func G_FindClosestPointOnLineSegment(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ from: JKAShared.vec3_t, _ result: JKAShared.vec3_t) -> Bool {
    // TODO: Port G_FindClosestPointOnLineSegment
    portMissing("G_FindClosestPointOnLineSegment", source: "oracle/codemp/game/q_math.c:1524")
}

/// Source: oracle/codemp/game/q_math.c:1606
func G_PointDistFromLineSegment(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ from: JKAShared.vec3_t) -> Float {
    // TODO: Port G_PointDistFromLineSegment
    portMissing("G_PointDistFromLineSegment", source: "oracle/codemp/game/q_math.c:1606")
}
