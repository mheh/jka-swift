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
// TODO: Port signature
// Raven wrote: void MD4Update (MD4_CTX *context, const unsigned char *input, unsigned int inputLen)
// No table row for `const unsigned char * input`.
func MD4Update() -> Never {
    // Port-note: The table has no row for Raven's `unsigned char` pointer and array parameters, so this stub waits on that row for its signature.
    // TODO: Port MD4Update
    portMissing("MD4Update", source: "oracle/codemp/qcommon/md4.cpp:112")
}

/**
```
MD4 finalization. Ends an MD4 message-digest operation, writing the the message digest and zeroizing the context.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:147
// TODO: Port signature
// Raven wrote: void MD4Final (unsigned char digest[16], MD4_CTX *context)
// No table row for `unsigned char[16] digest`.
func MD4Final() -> Never {
    // Port-note: The table has no row for Raven's `unsigned char` pointer and array parameters, so this stub waits on that row for its signature.
    // TODO: Port MD4Final
    portMissing("MD4Final", source: "oracle/codemp/qcommon/md4.cpp:147")
}

/**
```
MD4 basic transformation. Transforms state based on block.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:172
// TODO: Port signature
// Raven wrote: static void MD4Transform (UINT4 state[4], const unsigned char block[64])
// No table row for `const unsigned char[64] block`.
private func MD4Transform() -> Never {
    // Port-note: The table has no row for Raven's `unsigned char` pointer and array parameters, so this stub waits on that row for its signature.
    // TODO: Port MD4Transform
    portMissing("MD4Transform", source: "oracle/codemp/qcommon/md4.cpp:172")
}

/**
```
Encodes input (UINT4) into output (unsigned char). Assumes len is a multiple of 4.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:243
// TODO: Port signature
// Raven wrote: static void Encode (unsigned char *output, UINT4 *input, unsigned int len)
// No table row for `unsigned char * output`.
private func Encode() -> Never {
    // Port-note: The table has no row for Raven's `unsigned char` pointer and array parameters, so this stub waits on that row for its signature.
    // TODO: Port Encode
    portMissing("Encode", source: "oracle/codemp/qcommon/md4.cpp:243")
}

/**
```
Decodes input (unsigned char) into output (UINT4). Assumes len is a multiple of 4.
```
*/
/// Source: oracle/codemp/qcommon/md4.cpp:257
// TODO: Port signature
// Raven wrote: static void Decode (UINT4 *output, const unsigned char *input, unsigned int len)
// No table row for `const unsigned char * input`.
private func Decode() -> Never {
    // Port-note: The table has no row for Raven's `unsigned char` pointer and array parameters, so this stub waits on that row for its signature.
    // TODO: Port Decode
    portMissing("Decode", source: "oracle/codemp/qcommon/md4.cpp:257")
}

/// Source: oracle/codemp/qcommon/md4.cpp:267
func Com_BlockChecksum(_ buffer: OpaquePointer?, _ length: Int32) -> UInt32 {
    // Port-note: The body calls MD4Update and MD4Final, which wait on the table row for Raven's `unsigned char` pointer and array parameters.
    // TODO: Port Com_BlockChecksum
    portMissing("Com_BlockChecksum", source: "oracle/codemp/qcommon/md4.cpp:267")
}

/// Source: oracle/codemp/qcommon/md4.cpp:282
func Com_BlockChecksumKey(_ buffer: OpaquePointer?, _ length: Int32, _ key: Int32) -> UInt32 {
    // Port-note: The body calls MD4Update and MD4Final, which wait on the table row for Raven's `unsigned char` pointer and array parameters.
    // TODO: Port Com_BlockChecksumKey
    portMissing("Com_BlockChecksumKey", source: "oracle/codemp/qcommon/md4.cpp:282")
}
