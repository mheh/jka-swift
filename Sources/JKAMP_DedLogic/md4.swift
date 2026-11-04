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
func MD4Init(_ context: Md4Ctx) {
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
func MD4Update(_ context: Md4Ctx, _ input: Slots<UInt8>, _ inputLen: UInt32) {
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
        Com_Memcpy(context.buffer.suffix(from: Int(index)), input, Int32(partLen))
        MD4Transform(context.state, context.buffer)

        i = partLen
        while i + 63 < inputLen {
            MD4Transform(context.state, input.suffix(from: Int(i)))
            i += 64
        }

        index = 0
    } else {
        i = 0
    }

    /* Buffer remaining input */
    Com_Memcpy(context.buffer.suffix(from: Int(index)), input.suffix(from: Int(i)), Int32(inputLen - i))
}

/**
```
MD4 finalization. Ends an MD4 message-digest operation, writing the the message digest and zeroizing the context.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:147
func MD4Final(_ digest: Slots<UInt8>, _ context: Md4Ctx) {
    // Port-note: Encode and MD4Update take a `Slots<UInt8>`, and the local `unsigned char bits[8]` has no storage home, so it needs a BYTE_STORAGE_LOCALS row of the next batch.
    // Port-note: `PADDING` is a hand `[UInt8]` on EngineWorld, and MD4Update takes a `Slots<UInt8>`, so `PADDING` needs a Slots home in a row of the next batch.
    // TODO: Port MD4Final
    portMissing("MD4Final", source: "oracle/codemp/qcommon/md4.cpp:147")
}

/**
```
MD4 basic transformation. Transforms state based on block.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:172
private func MD4Transform(_ state: Slots<UInt32>, _ block: Slots<UInt8>) {
    // Port-note: Decode takes a `Slots<UInt32>`, and the local `UINT4 x[16]` has no storage home, so it needs a BYTE_STORAGE_LOCALS row of the next batch.
    // TODO: Port MD4Transform
    portMissing("MD4Transform", source: "oracle/codemp/qcommon/md4.cpp:172")
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
func Com_BlockChecksum(_ buffer: Slots<JKAShared.byte>, _ length: Int32) -> UInt32 {
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
func Com_BlockChecksumKey(_ buffer: Slots<JKAShared.byte>, _ length: Int32, _ key: Int32) -> UInt32 {
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
