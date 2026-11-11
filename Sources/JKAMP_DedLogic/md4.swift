import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/md4.cpp:61
let S11 = 3 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:62
let S12 = 7 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:63
let S13 = 11 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:64
let S14 = 19 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:65
let S21 = 3 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:66
let S22 = 5 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:67
let S23 = 9 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:68
let S24 = 13 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:69
let S31 = 3 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:70
let S32 = 9 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:71
let S33 = 11 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:72
let S34 = 15 as Int32

/// Source: oracle/codemp/qcommon/md4.cpp:78
// Raven wrote: static unsigned char PADDING[64]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/qcommon/md4.cpp:149
// AI: Raven declares `bits` on the stack of MD4Final. The function uses one zeroed allocation on the storage class.
var bits: Slots<JKAShared.byte> { world.storage.bits }

/// Source: oracle/codemp/qcommon/md4.cpp:174
// AI: Raven declares `x` on the stack of MD4Transform. The function uses one zeroed allocation on the storage class.
var x: Slots<UInt32> { world.storage.x }

/// Source: oracle/codemp/qcommon/md4.cpp:269
// AI: Raven declares `digest` on the stack of Com_BlockChecksum and Com_BlockChecksumKey. The functions share one zeroed allocation on the storage class.
var digest: Slots<Int32> { world.storage.digest }

/// Source: oracle/codemp/qcommon/md4.cpp:282
// AI: Raven takes the address of the parameter `key` of Com_BlockChecksumKey. The body copies it into one zeroed slot on the storage class.
var key_Com_BlockChecksumKey: Slots<Int32> { world.storage.key_Com_BlockChecksumKey }

/// Source: oracle/codemp/qcommon/md4.cpp:85
/// Raven's function-like macro `F`, a basic MD4 function.
private func F(_ x: UInt32, _ y: UInt32, _ z: UInt32) -> UInt32 {
    return ((x) & (y)) | ((~x) & (z))
}

/// Source: oracle/codemp/qcommon/md4.cpp:86
/// Raven's function-like macro `G`, a basic MD4 function.
private func G(_ x: UInt32, _ y: UInt32, _ z: UInt32) -> UInt32 {
    return ((x) & (y)) | ((x) & (z)) | ((y) & (z))
}

/// Source: oracle/codemp/qcommon/md4.cpp:87
/// Raven's function-like macro `H`, a basic MD4 function.
private func H(_ x: UInt32, _ y: UInt32, _ z: UInt32) -> UInt32 {
    return (x) ^ (y) ^ (z)
}

/// Source: oracle/codemp/qcommon/md4.cpp:90
/// Raven's function-like macro `ROTATE_LEFT`, a rotate of x left by n bits.
private func ROTATE_LEFT(_ x: UInt32, _ n: Int32) -> UInt32 {
    return ((x) << (n)) | ((x) >> (32 - (n)))
}

/// Source: oracle/codemp/qcommon/md4.cpp:94
/// Raven's function-like macro `FF`, a transformation for round 1.
private func FF(_ a: inout UInt32, _ b: UInt32, _ c: UInt32, _ d: UInt32, _ x: UInt32, _ s: Int32) {
    a = a &+ F(b, c, d) &+ x
    a = ROTATE_LEFT(a, s)
}

/// Source: oracle/codemp/qcommon/md4.cpp:96
/// Raven's function-like macro `GG`, a transformation for round 2.
private func GG(_ a: inout UInt32, _ b: UInt32, _ c: UInt32, _ d: UInt32, _ x: UInt32, _ s: Int32) {
    a = a &+ G(b, c, d) &+ x &+ 0x5a827999
    a = ROTATE_LEFT(a, s)
}

/// Source: oracle/codemp/qcommon/md4.cpp:98
/// Raven's function-like macro `HH`, a transformation for round 3.
private func HH(_ a: inout UInt32, _ b: UInt32, _ c: UInt32, _ d: UInt32, _ x: UInt32, _ s: Int32) {
    a = a &+ H(b, c, d) &+ x &+ 0x6ed9eba1
    a = ROTATE_LEFT(a, s)
}

/**
```
MD4 initialization. Begins an MD4 operation, writing a new context.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:100
public func MD4Init(_ context: Md4Ctx) {
    context.count[0] = 0
    context.count[1] = 0

    /* Load magic initialization constants.*/
    context.state[0] = 0x67452301
    context.state[1] = 0xefcdab89
    context.state[2] = 0x98badcfe
    context.state[3] = 0x10325476
}

/**
```
MD4 block update operation. Continues an MD4 message-digest operation, processing another message block, and updating the context.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:112
public func MD4Update(_ context: Md4Ctx, _ input: Slots<UInt8>, _ inputLen: UInt32) {
    var i: UInt32
    var index: UInt32
    let partLen: UInt32

    /* Compute number of bytes mod 64 */
    index = UInt32((context.count[0] >> 3) & 0x3F)

    /* Update number of bits */
    context.count[0] &+= (UINT4(inputLen) << 3)
    if (context.count[0]) < (UINT4(inputLen) << 3) {
        context.count[1] &+= 1
    }

    context.count[1] &+= (UINT4(inputLen) >> 29)

    partLen = 64 - index

    /* Transform as many times as possible.*/
    if inputLen >= partLen {
        Com_Memcpy(context.buffer.suffix(from: index), input, partLen)
        MD4Transform(context.state, context.buffer)

        i = partLen
        while i + 63 < inputLen {
            MD4Transform(context.state, input.suffix(from: i))
            i += 64
        }

        index = 0
    } else {
        i = 0
    }

    /* Buffer remaining input */
    Com_Memcpy(context.buffer.suffix(from: index), input.suffix(from: i), inputLen - i)
}

/**
```
MD4 finalization. Ends an MD4 message-digest operation, writing the the message digest and zeroizing the context.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:147
public func MD4Final(_ digest: Slots<UInt8>, _ context: Md4Ctx) {
    // AI: Raven declares `unsigned char bits[8]` on his stack. The body uses the zeroed allocation of the storage class through the `bits` forward.
    let index: UInt32
    let padLen: UInt32

    /* Save number of bits */
    Encode(bits, context.count, 8)

    /* Pad out to 56 mod 64.*/
    index = UInt32((context.count[0] >> 3) & 0x3f)
    padLen = (index < 56) ? (56 - index) : (120 - index)
    MD4Update(context, PADDING, padLen)

    /* Append length (before padding) */
    MD4Update(context, bits, 8)

    /* Store state in digest */
    Encode(digest, context.state, 16)

    /* Zeroize sensitive information.*/
    context.clear()
}

/**
```
MD4 basic transformation. Transforms state based on block.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:172
private func MD4Transform(_ state: Slots<UInt32>, _ block: Slots<UInt8>) {
    var a: UINT4 = state[0]
    var b: UINT4 = state[1]
    var c: UINT4 = state[2]
    var d: UINT4 = state[3]
    // AI: Raven declares `UINT4 x[16]` on his stack. The body uses the zeroed allocation of the storage class through the `x` forward.

    Decode(x, block, 64)

    /* Round 1 */
    FF(&a, b, c, d, x[0], S11) /* 1 */
    FF(&d, a, b, c, x[1], S12) /* 2 */
    FF(&c, d, a, b, x[2], S13) /* 3 */
    FF(&b, c, d, a, x[3], S14) /* 4 */
    FF(&a, b, c, d, x[4], S11) /* 5 */
    FF(&d, a, b, c, x[5], S12) /* 6 */
    FF(&c, d, a, b, x[6], S13) /* 7 */
    FF(&b, c, d, a, x[7], S14) /* 8 */
    FF(&a, b, c, d, x[8], S11) /* 9 */
    FF(&d, a, b, c, x[9], S12) /* 10 */
    FF(&c, d, a, b, x[10], S13) /* 11 */
    FF(&b, c, d, a, x[11], S14) /* 12 */
    FF(&a, b, c, d, x[12], S11) /* 13 */
    FF(&d, a, b, c, x[13], S12) /* 14 */
    FF(&c, d, a, b, x[14], S13) /* 15 */
    FF(&b, c, d, a, x[15], S14) /* 16 */

    /* Round 2 */
    GG(&a, b, c, d, x[0], S21) /* 17 */
    GG(&d, a, b, c, x[4], S22) /* 18 */
    GG(&c, d, a, b, x[8], S23) /* 19 */
    GG(&b, c, d, a, x[12], S24) /* 20 */
    GG(&a, b, c, d, x[1], S21) /* 21 */
    GG(&d, a, b, c, x[5], S22) /* 22 */
    GG(&c, d, a, b, x[9], S23) /* 23 */
    GG(&b, c, d, a, x[13], S24) /* 24 */
    GG(&a, b, c, d, x[2], S21) /* 25 */
    GG(&d, a, b, c, x[6], S22) /* 26 */
    GG(&c, d, a, b, x[10], S23) /* 27 */
    GG(&b, c, d, a, x[14], S24) /* 28 */
    GG(&a, b, c, d, x[3], S21) /* 29 */
    GG(&d, a, b, c, x[7], S22) /* 30 */
    GG(&c, d, a, b, x[11], S23) /* 31 */
    GG(&b, c, d, a, x[15], S24) /* 32 */

    /* Round 3 */
    HH(&a, b, c, d, x[0], S31) /* 33 */
    HH(&d, a, b, c, x[8], S32) /* 34 */
    HH(&c, d, a, b, x[4], S33) /* 35 */
    HH(&b, c, d, a, x[12], S34) /* 36 */
    HH(&a, b, c, d, x[2], S31) /* 37 */
    HH(&d, a, b, c, x[10], S32) /* 38 */
    HH(&c, d, a, b, x[6], S33) /* 39 */
    HH(&b, c, d, a, x[14], S34) /* 40 */
    HH(&a, b, c, d, x[1], S31) /* 41 */
    HH(&d, a, b, c, x[9], S32) /* 42 */
    HH(&c, d, a, b, x[5], S33) /* 43 */
    HH(&b, c, d, a, x[13], S34) /* 44 */
    HH(&a, b, c, d, x[3], S31) /* 45 */
    HH(&d, a, b, c, x[11], S32) /* 46 */
    HH(&c, d, a, b, x[7], S33) /* 47 */
    HH(&b, c, d, a, x[15], S34) /* 48 */

    state[0] &+= a
    state[1] &+= b
    state[2] &+= c
    state[3] &+= d

    /* Zeroize sensitive information.*/
    x.zero()
}

/**
```
Encodes input (UINT4) into output (unsigned char). Assumes len is a multiple of 4.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:243
private func Encode(_ output: Slots<UInt8>, _ input: Slots<UInt32>, _ len: UInt32) {
    var i: UInt32
    var j: UInt32

    i = 0
    j = 0
    while j < len {
        output[j] = UInt8(truncatingIfNeeded: (input[i] & 0xff))
        output[j + 1] = UInt8(truncatingIfNeeded: ((input[i] >> 8) & 0xff))
        output[j + 2] = UInt8(truncatingIfNeeded: ((input[i] >> 16) & 0xff))
        output[j + 3] = UInt8(truncatingIfNeeded: ((input[i] >> 24) & 0xff))
        i += 1
        j += 4
    }
}

/**
```
Decodes input (unsigned char) into output (UINT4). Assumes len is a multiple of 4.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:257
private func Decode(_ output: Slots<UInt32>, _ input: Slots<UInt8>, _ len: UInt32) {
    var i: UInt32
    var j: UInt32

    i = 0
    j = 0
    while j < len {
        output[i] = (UINT4(input[j])) | ((UINT4(input[j + 1])) << 8) | ((UINT4(input[j + 2])) << 16) | ((UINT4(input[j + 3])) << 24)
        i += 1
        j += 4
    }
}

/// Source: oracle/codemp/qcommon/md4.cpp:267
public func Com_BlockChecksum(_ buffer: Slots<JKAShared.byte>, _ length: Int32) -> UInt32 {
    // AI: Raven declares `int digest[4]` on his stack. The body uses the zeroed allocation of the storage class through the `digest` forward.
    var val: UInt32 = 0
    return Md4Ctx.scratch { ctx -> UInt32 in
        MD4Init(ctx)
        MD4Update(ctx, buffer, UInt32(bitPattern: length))
        MD4Final(digest.bytes, ctx)

        val = UInt32(bitPattern: digest[0]) ^ UInt32(bitPattern: digest[1]) ^ UInt32(bitPattern: digest[2]) ^ UInt32(bitPattern: digest[3])

        return val
    }
}

/// Source: oracle/codemp/qcommon/md4.cpp:282
public func Com_BlockChecksumKey(_ buffer: Slots<JKAShared.byte>, _ length: Int32, _ key: Int32) -> UInt32 {
    // AI: Raven declares `int digest[4]` on his stack. The body uses the zeroed allocation of the storage class through the `digest` forward.
    var val: UInt32 = 0
    return Md4Ctx.scratch { ctx -> UInt32 in
        MD4Init(ctx)
        // AI: Raven hands on the address of `key`. The body copies `key` into its storage slot and hands on the bytes of the slot.
        key_Com_BlockChecksumKey[0] = key
        MD4Update(ctx, key_Com_BlockChecksumKey.bytes, 4)
        MD4Update(ctx, buffer, UInt32(bitPattern: length))
        MD4Final(digest.bytes, ctx)

        val = UInt32(bitPattern: digest[0]) ^ UInt32(bitPattern: digest[1]) ^ UInt32(bitPattern: digest[2]) ^ UInt32(bitPattern: digest[3])

        return val
    }
}
