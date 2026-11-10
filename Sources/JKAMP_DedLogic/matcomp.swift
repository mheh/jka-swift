
import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/matcomp.c:7
// Raven wrote: #define MC_MASK_X ( ( 1 << ( MC_BITS_X ) ) - 1 )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:8
// Raven wrote: #define MC_MASK_Y ( ( 1 << ( MC_BITS_Y ) ) - 1 )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:9
// Raven wrote: #define MC_MASK_Z ( ( 1 << ( MC_BITS_Z ) ) - 1 )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:10
// Raven wrote: #define MC_MASK_VECT ( ( 1 << ( MC_BITS_VECT ) ) - 1 )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:12
// Raven wrote: #define MC_SCALE_VECT ( 1.0f / ( float ) ( ( 1 << ( MC_BITS_VECT - 1 ) ) - 2 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:14
let MC_POS_X = (0) as Int32

/// Source: oracle/codemp/renderer/matcomp.c:15
let MC_SHIFT_X = (0) as Int32

/// Source: oracle/codemp/renderer/matcomp.c:17
// Raven wrote: #define MC_POS_Y ( ( ( ( MC_BITS_X ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:18
// Raven wrote: #define MC_SHIFT_Y ( ( ( ( MC_BITS_X ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:20
// Raven wrote: #define MC_POS_Z ( ( ( ( MC_BITS_X + MC_BITS_Y ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:21
// Raven wrote: #define MC_SHIFT_Z ( ( ( ( MC_BITS_X + MC_BITS_Y ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:23
// Raven wrote: #define MC_POS_V11 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:24
// Raven wrote: #define MC_SHIFT_V11 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:26
// Raven wrote: #define MC_POS_V12 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:27
// Raven wrote: #define MC_SHIFT_V12 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:29
// Raven wrote: #define MC_POS_V13 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 2 ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:30
// Raven wrote: #define MC_SHIFT_V13 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 2 ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:32
// Raven wrote: #define MC_POS_V21 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 3 ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:33
// Raven wrote: #define MC_SHIFT_V21 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 3 ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:35
// Raven wrote: #define MC_POS_V22 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 4 ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:36
// Raven wrote: #define MC_SHIFT_V22 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 4 ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:38
// Raven wrote: #define MC_POS_V23 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 5 ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:39
// Raven wrote: #define MC_SHIFT_V23 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 5 ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:41
// Raven wrote: #define MC_POS_V31 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 6 ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:42
// Raven wrote: #define MC_SHIFT_V31 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 6 ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:44
// Raven wrote: #define MC_POS_V32 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 7 ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:45
// Raven wrote: #define MC_SHIFT_V32 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 7 ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:47
// Raven wrote: #define MC_POS_V33 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 8 ) ) / 8 ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:48
// Raven wrote: #define MC_SHIFT_V33 ( ( ( ( MC_BITS_X + MC_BITS_Y + MC_BITS_Z + MC_BITS_VECT * 8 ) % 8 ) ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/matcomp.c:50
func MC_Compress(_ mat: [[Float]], _ _comp: Slots<UInt8>) {
    // TODO: Port MC_Compress
    portMissing("MC_Compress", source: "oracle/codemp/renderer/matcomp.c:50")
}

/// Source: oracle/codemp/renderer/matcomp.c:163
func MC_UnCompress(_ mat: [[Float]], _ comp: Slots<UInt8>) {
    // TODO: Port MC_UnCompress
    portMissing("MC_UnCompress", source: "oracle/codemp/renderer/matcomp.c:163")
}

/// Source: oracle/codemp/renderer/matcomp.c:219
func MC_UnCompressQuat(_ mat: JKAMP.MdxaBone?, _ comp: Slots<UInt8>) {
    var w: Float, x: Float, y: Float, z: Float, f: Float
    let fTx: Float
    let fTy: Float
    let fTz: Float
    let fTwx: Float
    let fTwy: Float
    let fTwz: Float
    let fTxx: Float
    let fTxy: Float
    let fTxz: Float
    let fTyy: Float
    let fTyz: Float
    let fTzz: Float

    // AI: Raven walks an `unsigned short *` over the bytes of `comp`. The walk is the byte offset `pwIn`, and each read takes the two bytes at it.
    var pwIn: Int32 = 0

    // C converts each `unsigned short` to `float` at the store.
    w = Float(comp[ushort: pwIn])
    pwIn += 2
    w /= 16383.0
    w -= 2.0
    x = Float(comp[ushort: pwIn])
    pwIn += 2
    x /= 16383.0
    x -= 2.0
    y = Float(comp[ushort: pwIn])
    pwIn += 2
    y /= 16383.0
    y -= 2.0
    z = Float(comp[ushort: pwIn])
    pwIn += 2
    z /= 16383.0
    z -= 2.0

    fTx  = 2.0 * x
    fTy  = 2.0 * y
    fTz  = 2.0 * z
    fTwx = fTx * w
    fTwy = fTy * w
    fTwz = fTz * w
    fTxx = fTx * x
    fTxy = fTy * x
    fTxz = fTz * x
    fTyy = fTy * y
    fTyz = fTz * y
    fTzz = fTz * z

    // rot...
    //
    mat!.matrix[0][0] = 1.0 - (fTyy + fTzz)
    mat!.matrix[0][1] = fTxy - fTwz
    mat!.matrix[0][2] = fTxz + fTwy
    mat!.matrix[1][0] = fTxy + fTwz
    mat!.matrix[1][1] = 1.0 - (fTxx + fTzz)
    mat!.matrix[1][2] = fTyz - fTwx
    mat!.matrix[2][0] = fTxz - fTwy
    mat!.matrix[2][1] = fTyz + fTwx
    mat!.matrix[2][2] = 1.0 - (fTxx + fTyy)

    // xlat...
    //
    // C converts each `unsigned short` to `float` at the store.
    f = Float(comp[ushort: pwIn])
    pwIn += 2
    f /= 64
    f -= 512
    mat!.matrix[0][3] = f

    f = Float(comp[ushort: pwIn])

    pwIn += 2
    f /= 64
    f -= 512
    mat!.matrix[1][3] = f

    f = Float(comp[ushort: pwIn])
    f /= 64
    f -= 512
    mat!.matrix[2][3] = f
}
