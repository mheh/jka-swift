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
/// Raven's data table, a hand property of `EngineWorld`.
var PADDING: [UInt8] {
    get { world.PADDING }
    set { world.PADDING = newValue }
}

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

/// Source: oracle/codemp/qcommon/md4.cpp:43
/// Raven's `MD4_CTX`, a struct of the header text of md4.cpp.
/// It has no C view, because the engine never holds one, so it is a Swift class with Raven's fields.
final class MD4_CTX {
    /// state (ABCD)
    var state = [UInt32](repeating: 0, count: 4)
    /// number of bits, modulo 2^64 (lsb first)
    var count = [UInt32](repeating: 0, count: 2)
    /// input buffer
    var buffer = [UInt8](repeating: 0, count: 64)
}

/**
```
MD4 initialization. Begins an MD4 operation, writing a new context.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:100
func MD4Init(_ context: MD4_CTX) {
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
func MD4Update(_ context: MD4_CTX, _ input: [UInt8], _ inputLen: UInt32) {
    var i: UInt32
    var index: UInt32
    let partLen: UInt32

    /* Compute number of bytes mod 64 */
    index = (context.count[0] >> 3) & 0x3F

    /* Update number of bits */
    context.count[0] = context.count[0] &+ (inputLen << 3)
    if context.count[0] < (inputLen << 3) {
        context.count[1] = context.count[1] &+ 1
    }

    context.count[1] = context.count[1] &+ (inputLen >> 29)

    partLen = 64 - index

    /* Transform as many times as possible.*/
    if inputLen >= partLen {
        // AI: Raven called Com_Memcpy on the context buffer. The Swift buffer is an array, so a loop copies the bytes.
        for k in 0..<partLen {
            context.buffer[index + k] = input[k]
        }
        MD4Transform(&context.state, context.buffer[0..<64])

        i = partLen
        while i + 63 < inputLen {
            MD4Transform(&context.state, input[i..<(i + 64)])
            i += 64
        }

        index = 0
    } else {
        i = 0
    }

    /* Buffer remaining input */
    // AI: Raven called Com_Memcpy on the context buffer. The Swift buffer is an array, so a loop copies the bytes.
    for k in 0..<(inputLen - i) {
        context.buffer[index + k] = input[i + k]
    }
}

/**
```
MD4 finalization. Ends an MD4 message-digest operation, writing the the message digest and zeroizing the context.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:147
func MD4Final(_ digest: inout [UInt8], _ context: MD4_CTX) {
    var bits = [UInt8](repeating: 0, count: 8)
    var index: UInt32
    var padLen: UInt32

    /* Save number of bits */
    Encode(&bits, context.count, 8)

    /* Pad out to 56 mod 64.*/
    index = (context.count[0] >> 3) & 0x3f
    padLen = (index < 56) ? (56 - index) : (120 - index)
    MD4Update(context, PADDING, padLen)

    /* Append length (before padding) */
    MD4Update(context, bits, 8)

    /* Store state in digest */
    Encode(&digest, context.state, 16)

    /* Zeroize sensitive information.*/
    context.state = [UInt32](repeating: 0, count: 4)
    context.count = [UInt32](repeating: 0, count: 2)
    context.buffer = [UInt8](repeating: 0, count: 64)
}

/**
```
MD4 basic transformation. Transforms state based on block.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:172
private func MD4Transform(_ state: inout [UInt32], _ block: ArraySlice<UInt8>) {
    var a = state[0]
    var b = state[1]
    var c = state[2]
    var d = state[3]
    var x = [UInt32](repeating: 0, count: 16)

    Decode(&x, block, 64)

    // Round 1
    FF(&a, b, c, d, x[0], S11)
    FF(&d, a, b, c, x[1], S12)
    FF(&c, d, a, b, x[2], S13)
    FF(&b, c, d, a, x[3], S14)
    FF(&a, b, c, d, x[4], S11)
    FF(&d, a, b, c, x[5], S12)
    FF(&c, d, a, b, x[6], S13)
    FF(&b, c, d, a, x[7], S14)
    FF(&a, b, c, d, x[8], S11)
    FF(&d, a, b, c, x[9], S12)
    FF(&c, d, a, b, x[10], S13)
    FF(&b, c, d, a, x[11], S14)
    FF(&a, b, c, d, x[12], S11)
    FF(&d, a, b, c, x[13], S12)
    FF(&c, d, a, b, x[14], S13)
    FF(&b, c, d, a, x[15], S14)

    // Round 2
    GG(&a, b, c, d, x[0], S21)
    GG(&d, a, b, c, x[4], S22)
    GG(&c, d, a, b, x[8], S23)
    GG(&b, c, d, a, x[12], S24)
    GG(&a, b, c, d, x[1], S21)
    GG(&d, a, b, c, x[5], S22)
    GG(&c, d, a, b, x[9], S23)
    GG(&b, c, d, a, x[13], S24)
    GG(&a, b, c, d, x[2], S21)
    GG(&d, a, b, c, x[6], S22)
    GG(&c, d, a, b, x[10], S23)
    GG(&b, c, d, a, x[14], S24)
    GG(&a, b, c, d, x[3], S21)
    GG(&d, a, b, c, x[7], S22)
    GG(&c, d, a, b, x[11], S23)
    GG(&b, c, d, a, x[15], S24)

    // Round 3
    HH(&a, b, c, d, x[0], S31)
    HH(&d, a, b, c, x[8], S32)
    HH(&c, d, a, b, x[4], S33)
    HH(&b, c, d, a, x[12], S34)
    HH(&a, b, c, d, x[2], S31)
    HH(&d, a, b, c, x[10], S32)
    HH(&c, d, a, b, x[6], S33)
    HH(&b, c, d, a, x[14], S34)
    HH(&a, b, c, d, x[1], S31)
    HH(&d, a, b, c, x[9], S32)
    HH(&c, d, a, b, x[5], S33)
    HH(&b, c, d, a, x[13], S34)
    HH(&a, b, c, d, x[3], S31)
    HH(&d, a, b, c, x[11], S32)
    HH(&c, d, a, b, x[7], S33)
    HH(&b, c, d, a, x[15], S34)

    state[0] = state[0] &+ a
    state[1] = state[1] &+ b
    state[2] = state[2] &+ c
    state[3] = state[3] &+ d

    /* Zeroize sensitive information.*/
    x = [UInt32](repeating: 0, count: 16)
}

/**
```
Encodes input (UINT4) into output (unsigned char). Assumes len is a multiple of 4.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:243
private func Encode(_ output: inout [UInt8], _ input: [UInt32], _ len: UInt32) {
    var i: UInt32 = 0
    var j: UInt32 = 0

    while j < len {
        output[j] = UInt8(truncatingIfNeeded: input[i] & 0xff)
        output[j + 1] = UInt8(truncatingIfNeeded: (input[i] >> 8) & 0xff)
        output[j + 2] = UInt8(truncatingIfNeeded: (input[i] >> 16) & 0xff)
        output[j + 3] = UInt8(truncatingIfNeeded: (input[i] >> 24) & 0xff)
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
private func Decode(_ output: inout [UInt32], _ input: ArraySlice<UInt8>, _ len: UInt32) {
    var i: UInt32 = 0
    var j: UInt32 = 0

    while j < len {
        output[i] = UInt32(input[input.startIndex + j]) | (UInt32(input[input.startIndex + j + 1]) << 8) | (UInt32(input[input.startIndex + j + 2]) << 16) | (UInt32(input[input.startIndex + j + 3]) << 24)
        i += 1
        j += 4
    }
}

/// Source: oracle/codemp/qcommon/md4.cpp:267
func Com_BlockChecksum(_ buffer: OpaquePointer?, _ length: Int32) -> UInt32 {
    var digest = [UInt8](repeating: 0, count: 16)
    let val: UInt32
    let ctx = MD4_CTX()

    MD4Init(ctx)
    // AI: Raven passed the buffer pointer to MD4Update. The Swift update reads a byte slice, so the buffer is copied to bytes first.
    let bytes = [UInt8](UnsafeRawBufferPointer(start: UnsafeRawPointer(buffer), count: Int(length)))
    MD4Update(ctx, bytes, UInt32(bitPattern: length))
    MD4Final(&digest, ctx)

    // AI: Raven read the digest bytes as int digest[4]. The Swift digest is a byte array, so the four words are loaded from it.
    let digestWords = digest.withUnsafeBytes { [UInt32]($0.bindMemory(to: UInt32.self)) }
    val = digestWords[0] ^ digestWords[1] ^ digestWords[2] ^ digestWords[3]

    return val
}

/// Source: oracle/codemp/qcommon/md4.cpp:282
func Com_BlockChecksumKey(_ buffer: OpaquePointer?, _ length: Int32, _ key: Int32) -> UInt32 {
    var digest = [UInt8](repeating: 0, count: 16)
    let val: UInt32
    let ctx = MD4_CTX()

    MD4Init(ctx)
    // AI: Raven passed the address of the int key. The Swift update reads a byte slice, so the four little-endian bytes of the key are copied.
    let keyBytes = withUnsafeBytes(of: key) { [UInt8]($0) }
    MD4Update(ctx, keyBytes, 4)
    let bytes = [UInt8](UnsafeRawBufferPointer(start: UnsafeRawPointer(buffer), count: Int(length)))
    MD4Update(ctx, bytes, UInt32(bitPattern: length))
    MD4Final(&digest, ctx)

    // AI: Raven read the digest bytes as int digest[4]. The Swift digest is a byte array, so the four words are loaded from it.
    let digestWords = digest.withUnsafeBytes { [UInt32]($0.bindMemory(to: UInt32.self)) }
    val = digestWords[0] ^ digestWords[1] ^ digestWords[2] ^ digestWords[3]

    return val
}
