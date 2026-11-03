import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/msg.cpp:19
// TODO: Port global msgHuff
// Raven wrote: static huffman_t msgHuff
// No view for `huffman_t` of `qcommon.h`.

/// Source: oracle/codemp/qcommon/msg.cpp:21
var msgInit: Bool {
    get { world.variables.msgInit }
    set { world.variables.msgInit = newValue }
}

/// Source: oracle/codemp/qcommon/msg.cpp:22
// TODO: Port global fp
// Raven wrote: static FILE *fp=0
// No table row for `FILE *`.

/// Source: oracle/codemp/qcommon/msg.cpp:34
var gLastBitIndex: Int32 {
    get { world.variables.gLastBitIndex }
    set { world.variables.gLastBitIndex = newValue }
}

/// Source: oracle/codemp/qcommon/msg.cpp:37
var oldsize: Int32 {
    get { world.variables.oldsize }
    set { world.variables.oldsize = newValue }
}

/// Source: oracle/codemp/qcommon/msg.cpp:40
// TODO: Port global g_nOverrideChecked
// Raven wrote: bool g_nOverrideChecked = false
// No table row for `bool`.

/// Source: oracle/codemp/qcommon/msg.cpp:126
var overflows: Int32 {
    get { world.variables.overflows }
    set { world.variables.overflows = newValue }
}

/// Source: oracle/codemp/qcommon/msg.cpp:610
// Raven wrote: int kbitmask[32]
let kbitmask: [Int32] = [
    0x00000001, 0x00000003, 0x00000007, 0x0000000F,
    0x0000001F,	0x0000003F,	0x0000007F,	0x000000FF,
    0x000001FF,	0x000003FF,	0x000007FF,	0x00000FFF,
    0x00001FFF,	0x00003FFF,	0x00007FFF,	0x0000FFFF,
    0x0001FFFF,	0x0003FFFF,	0x0007FFFF,	0x000FFFFF,
    0x001FFFFf,	0x003FFFFF,	0x007FFFFF,	0x00FFFFFF,
    0x01FFFFFF,	0x03FFFFFF,	0x07FFFFFF,	0x0FFFFFFF,
    0x1FFFFFFF,	0x3FFFFFFF,	0x7FFFFFFF,
    // Raven wrote 0xFFFFFFFF.
    ~0x00000000,
]

/// Source: oracle/codemp/qcommon/msg.cpp:668
let CM_ANGLE1 = (1 << 0) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:669
let CM_ANGLE2 = (1 << 1) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:670
let CM_ANGLE3 = (1 << 2) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:671
let CM_FORWARD = (1 << 3) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:672
let CM_SIDE = (1 << 4) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:673
let CM_UP = (1 << 5) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:674
let CM_BUTTONS = (1 << 6) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:675
let CM_WEAPON = (1 << 7) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:677
let CM_FORCE = (1 << 8) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:678
let CM_INVEN = (1 << 9) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:859
// TODO: Port global entityStateFields
// Raven wrote: netField_t entityStateFields[]
// No table row for `netField_t[]`.

/// Source: oracle/codemp/qcommon/msg.cpp:1055
let FLOAT_INT_BITS = 13 as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:1056
let FLOAT_INT_BIAS = (1 << (FLOAT_INT_BITS - 1)) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:1410
// TODO: Port global playerStateFields
// Raven wrote: netField_t playerStateFields[]
// No table row for `netField_t[]`.

/// Source: oracle/codemp/qcommon/msg.cpp:1570
// TODO: Port global pilotPlayerStateFields
// Raven wrote: netField_t pilotPlayerStateFields[]
// No table row for `netField_t[]`.

/// Source: oracle/codemp/qcommon/msg.cpp:1736
// TODO: Port global vehPlayerStateFields
// Raven wrote: netField_t vehPlayerStateFields[]
// No table row for `netField_t[]`.

/// Source: oracle/codemp/qcommon/msg.cpp:2002
// TODO: Port global g_netfBitStorage
// Raven wrote: static bitStorage_t *g_netfBitStorage = NULL
// No table row for `bitStorage_t *`.

/// Source: oracle/codemp/qcommon/msg.cpp:2003
// TODO: Port global g_psfBitStorage
// Raven wrote: static bitStorage_t *g_psfBitStorage = NULL
// No table row for `bitStorage_t *`.

/// Source: oracle/codemp/qcommon/msg.cpp:2202
let STAT_WEAPONS = 4 as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:2958
// Raven wrote: int msg_hData[256]
// Q3 TA freq. table.
let msg_hData: [Int32] = [
    250315,			// 0
    41193,			// 1
    6292,			// 2
    7106,			// 3
    3730,			// 4
    3750,			// 5
    6110,			// 6
    23283,			// 7
    33317,			// 8
    6950,			// 9
    7838,			// 10
    9714,			// 11
    9257,			// 12
    17259,			// 13
    3949,			// 14
    1778,			// 15
    8288,			// 16
    1604,			// 17
    1590,			// 18
    1663,			// 19
    1100,			// 20
    1213,			// 21
    1238,			// 22
    1134,			// 23
    1749,			// 24
    1059,			// 25
    1246,			// 26
    1149,			// 27
    1273,			// 28
    4486,			// 29
    2805,			// 30
    3472,			// 31
    21819,			// 32
    1159,			// 33
    1670,			// 34
    1066,			// 35
    1043,			// 36
    1012,			// 37
    1053,			// 38
    1070,			// 39
    1726,			// 40
    888,			// 41
    1180,			// 42
    850,			// 43
    960,			// 44
    780,			// 45
    1752,			// 46
    3296,			// 47
    10630,			// 48
    4514,			// 49
    5881,			// 50
    2685,			// 51
    4650,			// 52
    3837,			// 53
    2093,			// 54
    1867,			// 55
    2584,			// 56
    1949,			// 57
    1972,			// 58
    940,			// 59
    1134,			// 60
    1788,			// 61
    1670,			// 62
    1206,			// 63
    5719,			// 64
    6128,			// 65
    7222,			// 66
    6654,			// 67
    3710,			// 68
    3795,			// 69
    1492,			// 70
    1524,			// 71
    2215,			// 72
    1140,			// 73
    1355,			// 74
    971,			// 75
    2180,			// 76
    1248,			// 77
    1328,			// 78
    1195,			// 79
    1770,			// 80
    1078,			// 81
    1264,			// 82
    1266,			// 83
    1168,			// 84
    965,			// 85
    1155,			// 86
    1186,			// 87
    1347,			// 88
    1228,			// 89
    1529,			// 90
    1600,			// 91
    2617,			// 92
    2048,			// 93
    2546,			// 94
    3275,			// 95
    2410,			// 96
    3585,			// 97
    2504,			// 98
    2800,			// 99
    2675,			// 100
    6146,			// 101
    3663,			// 102
    2840,			// 103
    14253,			// 104
    3164,			// 105
    2221,			// 106
    1687,			// 107
    3208,			// 108
    2739,			// 109
    3512,			// 110
    4796,			// 111
    4091,			// 112
    3515,			// 113
    5288,			// 114
    4016,			// 115
    7937,			// 116
    6031,			// 117
    5360,			// 118
    3924,			// 119
    4892,			// 120
    3743,			// 121
    4566,			// 122
    4807,			// 123
    5852,			// 124
    6400,			// 125
    6225,			// 126
    8291,			// 127
    23243,			// 128
    7838,			// 129
    7073,			// 130
    8935,			// 131
    5437,			// 132
    4483,			// 133
    3641,			// 134
    5256,			// 135
    5312,			// 136
    5328,			// 137
    5370,			// 138
    3492,			// 139
    2458,			// 140
    1694,			// 141
    1821,			// 142
    2121,			// 143
    1916,			// 144
    1149,			// 145
    1516,			// 146
    1367,			// 147
    1236,			// 148
    1029,			// 149
    1258,			// 150
    1104,			// 151
    1245,			// 152
    1006,			// 153
    1149,			// 154
    1025,			// 155
    1241,			// 156
    952,			// 157
    1287,			// 158
    997,			// 159
    1713,			// 160
    1009,			// 161
    1187,			// 162
    879,			// 163
    1099,			// 164
    929,			// 165
    1078,			// 166
    951,			// 167
    1656,			// 168
    930,			// 169
    1153,			// 170
    1030,			// 171
    1262,			// 172
    1062,			// 173
    1214,			// 174
    1060,			// 175
    1621,			// 176
    930,			// 177
    1106,			// 178
    912,			// 179
    1034,			// 180
    892,			// 181
    1158,			// 182
    990,			// 183
    1175,			// 184
    850,			// 185
    1121,			// 186
    903,			// 187
    1087,			// 188
    920,			// 189
    1144,			// 190
    1056,			// 191
    3462,			// 192
    2240,			// 193
    4397,			// 194
    12136,			// 195
    7758,			// 196
    1345,			// 197
    1307,			// 198
    3278,			// 199
    1950,			// 200
    886,			// 201
    1023,			// 202
    1112,			// 203
    1077,			// 204
    1042,			// 205
    1061,			// 206
    1071,			// 207
    1484,			// 208
    1001,			// 209
    1096,			// 210
    915,			// 211
    1052,			// 212
    995,			// 213
    1070,			// 214
    876,			// 215
    1111,			// 216
    851,			// 217
    1059,			// 218
    805,			// 219
    1112,			// 220
    923,			// 221
    1103,			// 222
    817,			// 223
    1899,			// 224
    1872,			// 225
    976,			// 226
    841,			// 227
    1127,			// 228
    956,			// 229
    1159,			// 230
    950,			// 231
    7791,			// 232
    954,			// 233
    1289,			// 234
    933,			// 235
    1127,			// 236
    3207,			// 237
    1020,			// 238
    927,			// 239
    1355,			// 240
    768,			// 241
    1040,			// 242
    745,			// 243
    952,			// 244
    805,			// 245
    1073,			// 246
    740,			// 247
    1013,			// 248
    805,			// 249
    1008,			// 250
    796,			// 251
    996,			// 252
    1057,			// 253
    11457,			// 254
    13504,			// 255
]

/// Raven's `static char string[MAX_STRING_CHARS]` of `MSG_ReadString`, a property of `EngineWorld`.
/// Source: oracle/codemp/qcommon/msg.cpp:460
var string_MSG_ReadString: CharBuf {
    get { world.string_MSG_ReadString }
    set { world.string_MSG_ReadString = newValue }
}

/// Raven's `static char string[BIG_INFO_STRING]` of `MSG_ReadBigString`, a property of `EngineWorld`.
/// Source: oracle/codemp/qcommon/msg.cpp:498
var string_MSG_ReadBigString: CharBuf {
    get { world.string_MSG_ReadBigString }
    set { world.string_MSG_ReadBigString = newValue }
}

/// Raven's `static char string[MAX_STRING_CHARS]` of `MSG_ReadStringLine`, a property of `EngineWorld`.
/// Source: oracle/codemp/qcommon/msg.cpp:522
var string_MSG_ReadStringLine: CharBuf {
    get { world.string_MSG_ReadStringLine }
    set { world.string_MSG_ReadStringLine = newValue }
}

/// Source: oracle/codemp/qcommon/msg.cpp:46
// TODO: Port signature
// Raven wrote: void MSG_Init( msg_t *buf, byte *data, int length )
// No table row for `byte * data`.
func MSG_Init() -> Never {
    // TODO: Port MSG_Init
    portMissing("MSG_Init", source: "oracle/codemp/qcommon/msg.cpp:46")
}

/// Source: oracle/codemp/qcommon/msg.cpp:70
// TODO: Port signature
// Raven wrote: void MSG_InitOOB( msg_t *buf, byte *data, int length )
// No table row for `byte * data`.
func MSG_InitOOB() -> Never {
    // TODO: Port MSG_InitOOB
    portMissing("MSG_InitOOB", source: "oracle/codemp/qcommon/msg.cpp:70")
}

/// Source: oracle/codemp/qcommon/msg.cpp:94
func MSG_Clear(_ buf: Msg) {
    buf.cursize = 0
    buf.overflowed = false
    buf.bit = 0					//<- in bits
}

/// Source: oracle/codemp/qcommon/msg.cpp:101
func MSG_Bitstream(_ buf: Msg) {
    buf.oob = false
}

/// Source: oracle/codemp/qcommon/msg.cpp:105
func MSG_BeginReading(_ msg: Msg) {
    msg.readcount = 0
    msg.bit = 0
    msg.oob = false
}

/// Source: oracle/codemp/qcommon/msg.cpp:111
func MSG_BeginReadingOOB(_ msg: Msg) {
    msg.readcount = 0
    msg.bit = 0
    msg.oob = true
}

// negative bit values include signs
/// Source: oracle/codemp/qcommon/msg.cpp:129
func MSG_WriteBits(_ msg: Msg, _ value: Int32, _ bits: Int32) {
    var bits = bits

    oldsize += bits

    // this isn't an exact overflow check, but close enough
    if msg.maxsize - msg.cursize < 4 {
        msg.overflowed = true
        return
    }

    if bits == 0 || bits < -31 || bits > 32 {
        Com_Error(ERR_DROP, "MSG_WriteBits: bad bits %i", bits)
    }

    // check for overflows
    if bits != 32 {
        if bits > 0 {
            if value > ((1 << bits) - 1) || value < 0 {
                overflows += 1
//				Com_Printf ("MSG_WriteBits: overflow writing %d in %d bits [index %i]\n", value, bits, gLastBitIndex);
            }
        } else {
            let r: Int32

            // Port-note: Raven shifts by the negative count `bits-1` here, which C leaves undefined.
            // Swift shifts right for a negative count and gives 0, and only the count `overflows`, which nothing reads, sees it.
            r = 1 << (bits - 1)

            if value > r - 1 || value < -r {
                overflows += 1
//				Com_Printf ("MSG_WriteBits: overflow writing %d in %d bits [index %i]\n", value, bits, gLastBitIndex);
            }
        }
    }
    if bits < 0 {
        bits = -bits
    }
    // Raven indexes the bytes behind `data`, and the raw pointer over that buffer is the index, under rule 11.
    if msg.oob {
        if bits == 8 {
            UnsafeMutableRawPointer(msg.data!)[byte: msg.cursize] = value
            msg.cursize += 1
            msg.bit += 8
        } else if bits == 16 {
            UnsafeMutableRawPointer(msg.data!)[ushort: msg.cursize] = value
            msg.cursize += 2
            msg.bit += 16
        } else if bits == 32 {
            UnsafeMutableRawPointer(msg.data!)[int: msg.cursize] = value
            msg.cursize += 4
            msg.bit += 8
        } else {
            Com_Error(ERR_DROP, "can't read %d bits\n", bits)
        }
    } else {
        // Port-note: Huff_putBit and Huff_offsetTransmit have no mapped signature in huffman.swift, and msgHuff has no view of `huffman_t`.
        portMissing("MSG_WriteBits", source: "oracle/codemp/qcommon/msg.cpp:188")
    }
}

/// Source: oracle/codemp/qcommon/msg.cpp:211
func MSG_ReadBits(_ msg: Msg, _ bits: Int32) -> Int32 {
    var bits = bits
    var value: Int32
    let sgn: Bool
    value = 0

    if bits < 0 {
        bits = -bits
        sgn = true
    } else {
        sgn = false
    }

    // Raven indexes the bytes behind `data`, and the raw pointer over that buffer is the index, under rule 11.
    if msg.oob {
        if bits == 8 {
            value = Int32(UnsafeMutableRawPointer(msg.data!)[byte: msg.readcount] as UInt8)
            msg.readcount += 1
            msg.bit += 8
        } else if bits == 16 {
            value = UnsafeMutableRawPointer(msg.data!)[ushort: msg.readcount]
            msg.readcount += 2
            msg.bit += 16
        } else if bits == 32 {
            value = UnsafeMutableRawPointer(msg.data!)[int: msg.readcount]
            msg.readcount += 4
            msg.bit += 32
        } else {
            Com_Error(ERR_DROP, "can't read %d bits\n", bits)
        }
    } else {
        // Port-note: Huff_getBit and Huff_offsetReceive have no mapped signature in huffman.swift, and msgHuff has no view of `huffman_t`.
        portMissing("MSG_ReadBits", source: "oracle/codemp/qcommon/msg.cpp:244")
    }
    if sgn {
        if (value & (1 << (bits - 1))) != 0 {
            value |= -1 ^ ((1 << bits) - 1)
        }
    }

    return value
}

/// Source: oracle/codemp/qcommon/msg.cpp:280
func MSG_WriteChar(_ sb: Msg, _ c: Int32) {
    MSG_WriteBits(sb, c, 8)
}

/// Source: oracle/codemp/qcommon/msg.cpp:289
func MSG_WriteByte(_ sb: Msg, _ c: Int32) {
    MSG_WriteBits(sb, c, 8)
}

/// Source: oracle/codemp/qcommon/msg.cpp:298
func MSG_WriteData(_ buf: Msg, _ data: OpaquePointer?, _ length: Int32) {
    var i: Int32
    // Raven reads the caller's bytes through `(byte *)data`, and the raw pointer over that buffer is the read, under rule 11.
    i = 0
    while i < length {
        MSG_WriteByte(buf, Int32(UnsafeMutableRawPointer(data!)[byte: i] as UInt8))
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/msg.cpp:305
func MSG_WriteShort(_ sb: Msg, _ c: Int32) {
    MSG_WriteBits(sb, c, 16)
}

/// Source: oracle/codemp/qcommon/msg.cpp:314
func MSG_WriteLong(_ sb: Msg, _ c: Int32) {
    MSG_WriteBits(sb, c, 32)
}

/// Source: oracle/codemp/qcommon/msg.cpp:318
func MSG_WriteFloat(_ sb: Msg, _ f: Float) {
    // Raven's union `dat` reads the float's bits as an int, and the bit pattern is that read.
    MSG_WriteBits(sb, Int32(bitPattern: f.bitPattern), 32)
}

/// Source: oracle/codemp/qcommon/msg.cpp:328
func MSG_WriteString(_ sb: Msg, _ s: String) {
    // Port-note: Raven hands a `char` buffer and the literal `""` to `MSG_WriteData`, whose `const void *data` is an `OpaquePointer?`.
    // No shape passes a `CharBuf` or a `String` there.
    // TODO: Port MSG_WriteString
    portMissing("MSG_WriteString", source: "oracle/codemp/qcommon/msg.cpp:328")
}

/// Source: oracle/codemp/qcommon/msg.cpp:356
func MSG_WriteBigString(_ sb: Msg, _ s: String) {
    // Port-note: Raven hands a `char` buffer and the literal `""` to `MSG_WriteData`, whose `const void *data` is an `OpaquePointer?`.
    // No shape passes a `CharBuf` or a `String` there.
    // TODO: Port MSG_WriteBigString
    portMissing("MSG_WriteBigString", source: "oracle/codemp/qcommon/msg.cpp:356")
}

/// Source: oracle/codemp/qcommon/msg.cpp:385
func MSG_WriteAngle(_ sb: Msg, _ f: Float) {
    MSG_WriteByte(sb, Int32(f * 256 / 360) & 255)
}

/// Source: oracle/codemp/qcommon/msg.cpp:389
func MSG_WriteAngle16(_ sb: Msg, _ f: Float) {
    MSG_WriteShort(sb, ANGLE2SHORT(f))
}

// returns -1 if no more characters are available
/// Source: oracle/codemp/qcommon/msg.cpp:401
func MSG_ReadChar(_ msg: Msg) -> Int32 {
    var c: Int32

    c = Int32(Int8(truncatingIfNeeded: MSG_ReadBits(msg, 8)))
    if msg.readcount > msg.cursize {
        c = -1
    }

    return c
}

/// Source: oracle/codemp/qcommon/msg.cpp:412
func MSG_ReadByte(_ msg: Msg) -> Int32 {
    var c: Int32

    c = Int32(UInt8(truncatingIfNeeded: MSG_ReadBits(msg, 8)))
    if msg.readcount > msg.cursize {
        c = -1
    }

    return c
}

/// Source: oracle/codemp/qcommon/msg.cpp:422
func MSG_ReadShort(_ msg: Msg) -> Int32 {
    var c: Int32

    c = Int32(Int16(truncatingIfNeeded: MSG_ReadBits(msg, 16)))
    if msg.readcount > msg.cursize {
        c = -1
    }

    return c
}

/// Source: oracle/codemp/qcommon/msg.cpp:433
func MSG_ReadLong(_ msg: Msg) -> Int32 {
    var c: Int32

    c = MSG_ReadBits(msg, 32)
    if msg.readcount > msg.cursize {
        c = -1
    }

    return c
}

/// Source: oracle/codemp/qcommon/msg.cpp:444
func MSG_ReadFloat(_ msg: Msg) -> Float {
    // Raven's union `dat` reads the int's bits as a float, and the bit pattern is that read.
    var dat: Float

    dat = Float(bitPattern: UInt32(bitPattern: MSG_ReadBits(msg, 32)))
    if msg.readcount > msg.cursize {
        dat = -1
    }

    return dat
}

/// Source: oracle/codemp/qcommon/msg.cpp:459
func MSG_ReadString(_ msg: Msg) -> String {
    // Raven's static local `string` is `string_MSG_ReadString`, because three functions of the file share the name.
    var l: Int32
    var c: Int32

    l = 0
    repeat {
        c = MSG_ReadByte(msg)		// use ReadByte so -1 is out of bounds
        if c == -1 || c == 0 {
            break
        }
        // translate all fmt spec to avoid crash bugs
        if c == Int32(ascii: "%") {
            c = Int32(ascii: ".")
        }
// eurofix: remove this so we can chat in european languages...	-ste
//
//		// don't allow higher ascii values
//		if ( c > 127 ) {
//			c = '.';
//		}

        string_MSG_ReadString[l] = c
        l += 1
    } while l <= string_MSG_ReadString.count - 1

    // some bonus protection, shouldn't occur cause server doesn't write such things
    if l <= string_MSG_ReadString.count - 1 {
        string_MSG_ReadString[l] = 0
    } else {
        string_MSG_ReadString[string_MSG_ReadString.count - 1] = 0
    }

    return String(string_MSG_ReadString)
}

/// Source: oracle/codemp/qcommon/msg.cpp:497
func MSG_ReadBigString(_ msg: Msg) -> String {
    // Raven's static local `string` is `string_MSG_ReadBigString`, because three functions of the file share the name.
    var l: Int32
    var c: Int32

    l = 0
    repeat {
        c = MSG_ReadByte(msg)		// use ReadByte so -1 is out of bounds
        if c == -1 || c == 0 {
            break
        }
        // translate all fmt spec to avoid crash bugs
        if c == Int32(ascii: "%") {
            c = Int32(ascii: ".")
        }

        string_MSG_ReadBigString[l] = c
        l += 1
    } while l < string_MSG_ReadBigString.count - 1

    string_MSG_ReadBigString[l] = 0

    return String(string_MSG_ReadBigString)
}

/// Source: oracle/codemp/qcommon/msg.cpp:521
func MSG_ReadStringLine(_ msg: Msg) -> String {
    // Raven's static local `string` is `string_MSG_ReadStringLine`, because three functions of the file share the name.
    var l: Int32
    var c: Int32

    l = 0
    repeat {
        c = MSG_ReadByte(msg)		// use ReadByte so -1 is out of bounds
        if c == -1 || c == 0 || c == Int32(ascii: "\n") {
            break
        }
        // translate all fmt spec to avoid crash bugs
        if c == Int32(ascii: "%") {
            c = Int32(ascii: ".")
        }
        string_MSG_ReadStringLine[l] = c
        l += 1
    } while l < string_MSG_ReadStringLine.count - 1

    string_MSG_ReadStringLine[l] = 0

    return String(string_MSG_ReadStringLine)
}

/// Source: oracle/codemp/qcommon/msg.cpp:544
func MSG_ReadAngle16(_ msg: Msg) -> Float {
    return SHORT2ANGLE(MSG_ReadShort(msg))
}

/// Source: oracle/codemp/qcommon/msg.cpp:548
func MSG_ReadData(_ msg: Msg, _ data: OpaquePointer?, _ len: Int32) {
    var i: Int32

    // Raven writes the caller's bytes through `(byte *)data`, and the raw pointer over that buffer is the write, under rule 11.
    i = 0
    while i < len {
        UnsafeMutableRawPointer(data!)[byte: i] = MSG_ReadByte(msg)
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/msg.cpp:567
func MSG_WriteDelta(_ msg: Msg, _ oldV: Int32, _ newV: Int32, _ bits: Int32) {
    if oldV == newV {
        MSG_WriteBits(msg, 0, 1)
        return
    }
    MSG_WriteBits(msg, 1, 1)
    MSG_WriteBits(msg, newV, bits)
}

/// Source: oracle/codemp/qcommon/msg.cpp:576
func MSG_ReadDelta(_ msg: Msg, _ oldV: Int32, _ bits: Int32) -> Int32 {
    if MSG_ReadBits(msg, 1) != 0 {
        return MSG_ReadBits(msg, bits)
    }
    return oldV
}

/// Source: oracle/codemp/qcommon/msg.cpp:583
func MSG_WriteDeltaFloat(_ msg: Msg, _ oldV: Float, _ newV: Float) {
    if oldV == newV {
        MSG_WriteBits(msg, 0, 1)
        return
    }
    MSG_WriteBits(msg, 1, 1)
    MSG_WriteBits(msg, Int32(bitPattern: newV.bitPattern), 32)
}

/// Source: oracle/codemp/qcommon/msg.cpp:592
func MSG_ReadDeltaFloat(_ msg: Msg, _ oldV: Float) -> Float {
    if MSG_ReadBits(msg, 1) != 0 {
        let newV: Float

        newV = Float(bitPattern: UInt32(bitPattern: MSG_ReadBits(msg, 32)))
        return newV
    }
    return oldV
}

/// Source: oracle/codemp/qcommon/msg.cpp:621
func MSG_WriteDeltaKey(_ msg: Msg, _ key: Int32, _ oldV: Int32, _ newV: Int32, _ bits: Int32) {
    if oldV == newV {
        MSG_WriteBits(msg, 0, 1)
        return
    }
    MSG_WriteBits(msg, 1, 1)
    MSG_WriteBits(msg, (newV ^ key) & ((1 << bits) - 1), bits)
}

/// Source: oracle/codemp/qcommon/msg.cpp:632
func MSG_ReadDeltaKey(_ msg: Msg, _ key: Int32, _ oldV: Int32, _ bits: Int32) -> Int32 {
    if MSG_ReadBits(msg, 1) != 0 {
        return MSG_ReadBits(msg, bits) ^ (key & kbitmask[bits])
    }
    return oldV
}

/// Source: oracle/codemp/qcommon/msg.cpp:639
func MSG_WriteDeltaKeyFloat(_ msg: Msg, _ key: Int32, _ oldV: Float, _ newV: Float) {
    if oldV == newV {
        MSG_WriteBits(msg, 0, 1)
        return
    }
    MSG_WriteBits(msg, 1, 1)
    MSG_WriteBits(msg, (Int32(bitPattern: newV.bitPattern)) ^ key, 32)
}

/// Source: oracle/codemp/qcommon/msg.cpp:648
func MSG_ReadDeltaKeyFloat(_ msg: Msg, _ key: Int32, _ oldV: Float) -> Float {
    if MSG_ReadBits(msg, 1) != 0 {
        let newV: Float

        newV = Float(bitPattern: UInt32(bitPattern: MSG_ReadBits(msg, 32) ^ key))
        return newV
    }
    return oldV
}

/**
```
=====================
MSG_WriteDeltaUsercmd
=====================
```
*/
/// Source: oracle/codemp/qcommon/msg.cpp:685
func MSG_WriteDeltaUsercmd(_ msg: Msg, _ from: JKAMP.Usercmd, _ to: JKAMP.Usercmd) {
    if to.serverTime - from.serverTime < 256 {
        MSG_WriteBits(msg, 1, 1)
        MSG_WriteBits(msg, to.serverTime - from.serverTime, 8)
    } else {
        MSG_WriteBits(msg, 0, 1)
        MSG_WriteBits(msg, to.serverTime, 32)
    }
    MSG_WriteDelta(msg, from.angles[0], to.angles[0], 16)
    MSG_WriteDelta(msg, from.angles[1], to.angles[1], 16)
    MSG_WriteDelta(msg, from.angles[2], to.angles[2], 16)
    MSG_WriteDelta(msg, from.forwardmove, to.forwardmove, 8)
    MSG_WriteDelta(msg, from.rightmove, to.rightmove, 8)
    MSG_WriteDelta(msg, from.upmove, to.upmove, 8)
    MSG_WriteDelta(msg, from.buttons, to.buttons, 16)
    MSG_WriteDelta(msg, from.weapon, to.weapon, 8)

    MSG_WriteDelta(msg, from.forcesel, to.forcesel, 8)
    MSG_WriteDelta(msg, from.invensel, to.invensel, 8)

    MSG_WriteDelta(msg, from.generic_cmd, to.generic_cmd, 8)
}

/**
```
=====================
MSG_ReadDeltaUsercmd
=====================
```
*/
/// Source: oracle/codemp/qcommon/msg.cpp:714
func MSG_ReadDeltaUsercmd(_ msg: Msg, _ from: JKAMP.Usercmd, _ to: JKAMP.Usercmd) {
    if MSG_ReadBits(msg, 1) != 0 {
        to.serverTime = from.serverTime + MSG_ReadBits(msg, 8)
    } else {
        to.serverTime = MSG_ReadBits(msg, 32)
    }
    to.angles[0] = MSG_ReadDelta(msg, from.angles[0], 16)
    to.angles[1] = MSG_ReadDelta(msg, from.angles[1], 16)
    to.angles[2] = MSG_ReadDelta(msg, from.angles[2], 16)
    to.forwardmove = MSG_ReadDelta(msg, from.forwardmove, 8)
    to.rightmove = MSG_ReadDelta(msg, from.rightmove, 8)
    to.upmove = MSG_ReadDelta(msg, from.upmove, 8)
    to.buttons = MSG_ReadDelta(msg, from.buttons, 16)
    to.weapon = MSG_ReadDelta(msg, from.weapon, 8)

    to.forcesel = MSG_ReadDelta(msg, from.forcesel, 8)
    to.invensel = MSG_ReadDelta(msg, from.invensel, 8)

    to.generic_cmd = MSG_ReadDelta(msg, from.generic_cmd, 8)
}

/**
```
=====================
MSG_WriteDeltaUsercmd
=====================
```
*/
/// Source: oracle/codemp/qcommon/msg.cpp:740
func MSG_WriteDeltaUsercmdKey(_ msg: Msg, _ key: Int32, _ from: JKAMP.Usercmd, _ to: JKAMP.Usercmd) {
    var key = key
    if to.serverTime - from.serverTime < 256 {
        MSG_WriteBits(msg, 1, 1)
        MSG_WriteBits(msg, to.serverTime - from.serverTime, 8)
    } else {
        MSG_WriteBits(msg, 0, 1)
        MSG_WriteBits(msg, to.serverTime, 32)
    }
    if from.angles[0] == to.angles[0] &&
        from.angles[1] == to.angles[1] &&
        from.angles[2] == to.angles[2] &&
        from.forwardmove == to.forwardmove &&
        from.rightmove == to.rightmove &&
        from.upmove == to.upmove &&
        from.buttons == to.buttons &&
        from.weapon == to.weapon &&
        from.forcesel == to.forcesel &&
        from.invensel == to.invensel &&
        from.generic_cmd == to.generic_cmd {
        MSG_WriteBits(msg, 0, 1)				// no change
        oldsize += 7
        return
    }
    key ^= to.serverTime
    MSG_WriteBits(msg, 1, 1)
    MSG_WriteDeltaKey(msg, key, from.angles[0], to.angles[0], 16)
    MSG_WriteDeltaKey(msg, key, from.angles[1], to.angles[1], 16)
    MSG_WriteDeltaKey(msg, key, from.angles[2], to.angles[2], 16)
    MSG_WriteDeltaKey(msg, key, from.forwardmove, to.forwardmove, 8)
    MSG_WriteDeltaKey(msg, key, from.rightmove, to.rightmove, 8)
    MSG_WriteDeltaKey(msg, key, from.upmove, to.upmove, 8)
    MSG_WriteDeltaKey(msg, key, from.buttons, to.buttons, 16)
    MSG_WriteDeltaKey(msg, key, from.weapon, to.weapon, 8)

    MSG_WriteDeltaKey(msg, key, from.forcesel, to.forcesel, 8)
    MSG_WriteDeltaKey(msg, key, from.invensel, to.invensel, 8)

    MSG_WriteDeltaKey(msg, key, from.generic_cmd, to.generic_cmd, 8)
}

/**
```
=====================
MSG_ReadDeltaUsercmd
=====================
```
*/
/// Source: oracle/codemp/qcommon/msg.cpp:786
func MSG_ReadDeltaUsercmdKey(_ msg: Msg, _ key: Int32, _ from: JKAMP.Usercmd, _ to: JKAMP.Usercmd) {
    var key = key
    if MSG_ReadBits(msg, 1) != 0 {
        to.serverTime = from.serverTime + MSG_ReadBits(msg, 8)
    } else {
        to.serverTime = MSG_ReadBits(msg, 32)
    }
    if MSG_ReadBits(msg, 1) != 0 {
        key ^= to.serverTime
        to.angles[0] = MSG_ReadDeltaKey(msg, key, from.angles[0], 16)
        to.angles[1] = MSG_ReadDeltaKey(msg, key, from.angles[1], 16)
        to.angles[2] = MSG_ReadDeltaKey(msg, key, from.angles[2], 16)
        to.forwardmove = MSG_ReadDeltaKey(msg, key, from.forwardmove, 8)
        to.rightmove = MSG_ReadDeltaKey(msg, key, from.rightmove, 8)
        to.upmove = MSG_ReadDeltaKey(msg, key, from.upmove, 8)
        to.buttons = MSG_ReadDeltaKey(msg, key, from.buttons, 16)
        to.weapon = MSG_ReadDeltaKey(msg, key, from.weapon, 8)

        to.forcesel = MSG_ReadDeltaKey(msg, key, from.forcesel, 8)
        to.invensel = MSG_ReadDeltaKey(msg, key, from.invensel, 8)

        to.generic_cmd = MSG_ReadDeltaKey(msg, key, from.generic_cmd, 8)
    } else {
        to.angles[0] = from.angles[0]
        to.angles[1] = from.angles[1]
        to.angles[2] = from.angles[2]
        to.forwardmove = from.forwardmove
        to.rightmove = from.rightmove
        to.upmove = from.upmove
        to.buttons = from.buttons
        to.weapon = from.weapon

        to.forcesel = from.forcesel
        to.invensel = from.invensel

        to.generic_cmd = from.generic_cmd
    }
}

/**
```
==================
MSG_WriteDeltaEntity

Writes part of a packetentities message, including the entity number.
Can delta from either a baseline or a previous packet_entity
If to is NULL, a remove entity update will be sent
If force is not set, then nothing at all will be generated if the entity is
identical, under the assumption that the in-order delta code will catch it.
==================
```
*/
/// Source: oracle/codemp/qcommon/msg.cpp:1069
func MSG_WriteDeltaEntity(_ msg: Msg, _ from: JKAMP.EntityState, _ to: JKAMP.EntityState?, _ force: Bool) {
    // Port-note: The body walks the netField tables, which are not C storage yet, and `netField_t` has no view.
    // TODO: Port MSG_WriteDeltaEntity
    portMissing("MSG_WriteDeltaEntity", source: "oracle/codemp/qcommon/msg.cpp:1069")
}

/// Source: oracle/codemp/qcommon/msg.cpp:1228
func MSG_ReadDeltaEntity(_ msg: Msg, _ from: JKAMP.EntityState, _ to: JKAMP.EntityState, _ number: Int32) {
    // Port-note: The body walks the netField tables, which are not C storage yet, and `netField_t` has no view.
    // TODO: Port MSG_ReadDeltaEntity
    portMissing("MSG_ReadDeltaEntity", source: "oracle/codemp/qcommon/msg.cpp:1228")
}

//rww - Check the overrides files to see if the mod wants anything changed
/// Source: oracle/codemp/qcommon/msg.cpp:2006
func MSG_CheckNETFPSFOverrides(_ psfOverrides: Bool) {
    // Port-note: The body walks the netField tables, which are not C storage yet, and `netField_t` has no view.
    // The body also needs `bitStorage_t`, which has no view, and `Z_Malloc`, which has no mapped signature.
    // TODO: Port MSG_CheckNETFPSFOverrides
    portMissing("MSG_CheckNETFPSFOverrides", source: "oracle/codemp/qcommon/msg.cpp:2006")
}

/// Source: oracle/codemp/qcommon/msg.cpp:2213
func MSG_WriteDeltaPlayerstate(_ msg: Msg, _ from: JKAMP.PlayerState?, _ to: JKAMP.PlayerState, _ isVehiclePS: Bool) {
    // Port-note: The body walks the netField tables, which are not C storage yet, and `netField_t` has no view.
    // TODO: Port MSG_WriteDeltaPlayerstate
    portMissing("MSG_WriteDeltaPlayerstate", source: "oracle/codemp/qcommon/msg.cpp:2213")
}

/**
```
===================
MSG_ReadDeltaPlayerstate
===================
```
*/
/// Source: oracle/codemp/qcommon/msg.cpp:2455
func MSG_ReadDeltaPlayerstate(_ msg: Msg, _ from: JKAMP.PlayerState, _ to: JKAMP.PlayerState, _ isVehiclePS: Bool) {
    // Port-note: The body walks the netField tables, which are not C storage yet, and `netField_t` has no view.
    // TODO: Port MSG_ReadDeltaPlayerstate
    portMissing("MSG_ReadDeltaPlayerstate", source: "oracle/codemp/qcommon/msg.cpp:2455")
}

/// Source: oracle/codemp/qcommon/msg.cpp:3219
func MSG_initHuffman() {
    // Port-note: Huff_Init and Huff_addRef have no mapped signature in huffman.swift, and msgHuff has no view of `huffman_t`.
    // TODO: Port MSG_initHuffman
    portMissing("MSG_initHuffman", source: "oracle/codemp/qcommon/msg.cpp:3219")
}

/// Source: oracle/codemp/qcommon/msg.cpp:3274
func MSG_shutdownHuffman() {
}

/**
```
=================
MSG_ReportChangeVectors_f

Prints out a table from the current statistics for copying to code
=================
```
*/
/// Source: oracle/codemp/qcommon/msg.cpp:3291
func MSG_ReportChangeVectors_f() {
    // Port-note: The body walks the netField tables, which are not C storage yet, and `netField_t` has no view.
    // TODO: Port MSG_ReportChangeVectors_f
    portMissing("MSG_ReportChangeVectors_f", source: "oracle/codemp/qcommon/msg.cpp:3291")
}
