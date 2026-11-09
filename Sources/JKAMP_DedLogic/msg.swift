import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/msg.cpp:19
var msgHuff: Huffman { world.storage.msgHuff }

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
var g_nOverrideChecked: Bool {
    get { world.variables.g_nOverrideChecked }
    set { world.variables.g_nOverrideChecked = newValue }
}

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
// Raven wrote: netField_t entityStateFields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/qcommon/msg.cpp:1055
let FLOAT_INT_BITS = 13 as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:1056
let FLOAT_INT_BIAS = (1 << (FLOAT_INT_BITS - 1)) as Int32

/// Source: oracle/codemp/qcommon/msg.cpp:1410
// Raven wrote: netField_t playerStateFields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/qcommon/msg.cpp:1570
// Raven wrote: netField_t pilotPlayerStateFields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/qcommon/msg.cpp:1736
// Raven wrote: netField_t vehPlayerStateFields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/qcommon/msg.cpp:2002
var g_netfBitStorage: BitStorage? {
    get { world.variables.g_netfBitStorage }
    set { world.variables.g_netfBitStorage = newValue }
}

/// Source: oracle/codemp/qcommon/msg.cpp:2003
var g_psfBitStorage: BitStorage? {
    get { world.variables.g_psfBitStorage }
    set { world.variables.g_psfBitStorage = newValue }
}

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
func MSG_Init(_ buf: Msg, _ data: Slots<JKAShared.byte>, _ length: Int32) {
    if !g_nOverrideChecked {
        //Check for netf overrides
        MSG_CheckNETFPSFOverrides(false)

        //Then for psf overrides
        MSG_CheckNETFPSFOverrides(true)

        g_nOverrideChecked = true
    }

    if !msgInit {
        MSG_initHuffman()
    }

    buf.clear()
    buf.data = data
    buf.maxsize = length
}

/// Source: oracle/codemp/qcommon/msg.cpp:70
func MSG_InitOOB(_ buf: Msg, _ data: Slots<JKAShared.byte>, _ length: Int32) {
    if !g_nOverrideChecked {
        //Check for netf overrides
        MSG_CheckNETFPSFOverrides(false)

        //Then for psf overrides
        MSG_CheckNETFPSFOverrides(true)

        g_nOverrideChecked = true
    }

    if !msgInit {
        MSG_initHuffman()
    }
    buf.clear()
    buf.data = data
    buf.maxsize = length
    buf.oob = true
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
    var value = value
    var bits = bits
    var i: Int32

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
    // AI: Raven casts the address of a byte of `data` to a word pointer. The word subscripts of the byte Slots read and write the word at that offset.
    if msg.oob {
        if bits == 8 {
            msg.data![byte: msg.cursize] = value
            msg.cursize += 1
            msg.bit += 8
        } else if bits == 16 {
            msg.data![ushort: msg.cursize] = value
            msg.cursize += 2
            msg.bit += 16
        } else if bits == 32 {
            msg.data![int: msg.cursize] = value
            msg.cursize += 4
            msg.bit += 8
        } else {
            Com_Error(ERR_DROP, "can't read %d bits\n", bits)
        }
    } else {
        // Raven's mask is an `unsigned int`, so the shift is logical.
        value &= Int32(bitPattern: 0xffffffff >> (32 - bits))
        if (bits & 7) != 0 {
            var nbits: Int32
            nbits = bits & 7
            i = 0
            while i < nbits {
                Huff_putBit((value & 1), msg.data!, &msg.bit)
                value = (value >> 1)
                i += 1
            }
            bits = bits - nbits
        }
        if bits != 0 {
            i = 0
            while i < bits {
                Huff_offsetTransmit(msgHuff.compressor, (value & 0xff), msg.data!, &msg.bit)
                value = (value >> 8)
                i += 8
            }
        }
        msg.cursize = (msg.bit >> 3) + 1
    }
}

/// Source: oracle/codemp/qcommon/msg.cpp:211
func MSG_ReadBits(_ msg: Msg, _ bits: Int32) -> Int32 {
    var bits = bits
    var value: Int32
    var get: Int32 = 0
    let sgn: Bool
    var i: Int32
    var nbits: Int32
    value = 0

    if bits < 0 {
        bits = -bits
        sgn = true
    } else {
        sgn = false
    }

    // AI: Raven casts the address of a byte of `data` to a word pointer. The word subscripts of the byte Slots read and write the word at that offset.
    if msg.oob {
        if bits == 8 {
            value = Int32(msg.data![byte: msg.readcount] as UInt8)
            msg.readcount += 1
            msg.bit += 8
        } else if bits == 16 {
            value = msg.data![ushort: msg.readcount]
            msg.readcount += 2
            msg.bit += 16
        } else if bits == 32 {
            value = msg.data![int: msg.readcount]
            msg.readcount += 4
            msg.bit += 32
        } else {
            Com_Error(ERR_DROP, "can't read %d bits\n", bits)
        }
    } else {
        nbits = 0
        if (bits & 7) != 0 {
            nbits = bits & 7
            i = 0
            while i < nbits {
                value |= (Huff_getBit(msg.data!, &msg.bit) << i)
                i += 1
            }
            bits = bits - nbits
        }
        if bits != 0 {
            i = 0
            while i < bits {
                Huff_offsetReceive(msgHuff.decompressor.tree!, &get, msg.data!, &msg.bit)
                value |= (get << (i + nbits))
                i += 8
            }
        }
        msg.readcount = (msg.bit >> 3) + 1
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
func MSG_WriteData(_ buf: Msg, _ data: Slots<JKAShared.byte>, _ length: Int32) {
    var i: Int32
    // AI: Raven casts `void *data` to a byte pointer. The parameter is a Slots of bytes, and the byte subscript reads it at the index.
    i = 0
    while i < length {
        MSG_WriteByte(buf, Int32(data[byte: i] as UInt8))
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/msg.cpp:298
// Port-note: The overload of the MSG_WriteData row, for the text and the char buffers Raven hands to `const void *data`, msg.cpp:330 to :358.
// AI: Raven casts every caller's `char *` to `const void *`. A CharBuf overload takes the text, and the string literals type to it.
func MSG_WriteData(_ buf: Msg, _ data: CharBuf, _ length: Int32) {
    var i: Int32 = 0
    while i < length {
        // Raven reads `((byte *)data)[i]`, unsigned, so a byte of 0x80 or more does not count as an overflow at msg.cpp:147.
        MSG_WriteByte(buf, Int32(data[i] as UInt8))
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
    // Raven also tests `s` for NULL here. A String is never NULL, so that arm has no Swift form.
    var l: Int32
    var string = CharBuf(MAX_STRING_CHARS)

    l = strlen(s)
    if l >= MAX_STRING_CHARS {
        Com_Printf("MSG_WriteString: MAX_STRING_CHARS")
        MSG_WriteData(sb, "", 1)
        return
    }
    Q_strncpyz(&string, s, Int32(string.count))

// eurofix: eliminating this means you can chat in european languages. WTF are "old clients" anyway?	-ste
//
//		// get rid of 0xff chars, because old clients don't like them
//		for ( int i = 0 ; i < l ; i++ ) {
//			if ( ((byte *)string)[i] > 127 ) {
//				string[i] = '.';
//			}
//		}

    MSG_WriteData(sb, string, l + 1)
}

/// Source: oracle/codemp/qcommon/msg.cpp:356
func MSG_WriteBigString(_ sb: Msg, _ s: String) {
    // Raven also tests `s` for NULL here. A String is never NULL, so that arm has no Swift form.
    var l: Int32
    var string = CharBuf(BIG_INFO_STRING)

    l = strlen(s)
    if l >= BIG_INFO_STRING {
        Com_Printf("MSG_WriteString: BIG_INFO_STRING")
        MSG_WriteData(sb, "", 1)
        return
    }
    Q_strncpyz(&string, s, Int32(string.count))

// eurofix: remove this so we can chat in european languages...	-ste
/*
		// get rid of 0xff chars, because old clients don't like them
		for ( int i = 0 ; i < l ; i++ ) {
			if ( ((byte *)string)[i] > 127 ) {
				string[i] = '.';
			}
		}
*/

    MSG_WriteData(sb, string, l + 1)
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
func MSG_ReadData(_ msg: Msg, _ data: Slots<JKAShared.byte>, _ len: Int32) {
    var i: Int32

    // AI: Raven casts `void *data` to a byte pointer. The parameter is a Slots of bytes, and the byte subscript writes it at the index.
    i = 0
    while i < len {
        data[byte: i] = MSG_ReadByte(msg)
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
    var i: Int32
    var lc: Int32
    var numFields: Int32
    var field: NetField
    var trunc: Int32
    var fullFloat: Float
    var fromF: Slots<JKAShared.byte>
    var toF: Slots<JKAShared.byte>

    numFields = Int32(entityStateFields.count)

    // all fields should be 32 bits to avoid any compiler packing issues
    // the "number" field is not part of the field list
    // if this assert fails, someone added a field to the entityState_t
    // struct without updating the message fields

    // a NULL to is a delta remove message
    guard let to else {
        MSG_WriteBits(msg, from.number, GENTITYNUM_BITS)
        MSG_WriteBits(msg, 1, 1)
        return
    }

    if to.number < 0 || to.number >= MAX_GENTITIES {
        Com_Error(ERR_FATAL, "MSG_WriteDeltaEntity: Bad entity number: %i", to.number)
    }

    // AI: Raven casts the record to a byte pointer and adds the field offset. The bytes of the record view give the Slots tail from that offset.
    lc = 0
    // build the change vector as bytes so it is endien independent
    // TODO: OPTIMIZE: How about we do this in reverse order so we can
    // just break out at the first changed field we find?
    i = 0
    while i < numFields {
        field = entityStateFields[i]
        fromF = Slots(record: from).bytes.suffix(from: field.offset)
        toF = Slots(record: to).bytes.suffix(from: field.offset)
        if fromF[int: 0] != toF[int: 0] {
            lc = i + 1
            field.mCount += 1
        }
        i += 1
    }

    if lc == 0 {
        // nothing at all changed
        if !force {
            return		// nothing at all
        }
        // write two bits for no change
        MSG_WriteBits(msg, to.number, GENTITYNUM_BITS)
        MSG_WriteBits(msg, 0, 1)		// not removed
        MSG_WriteBits(msg, 0, 1)		// no delta
        return
    }

    MSG_WriteBits(msg, to.number, GENTITYNUM_BITS)
    MSG_WriteBits(msg, 0, 1)			// not removed
    MSG_WriteBits(msg, 1, 1)			// we have a delta

    MSG_WriteByte(msg, lc)	// # of changes

    oldsize += numFields

    i = 0
    while i < lc {
        field = entityStateFields[i]
        fromF = Slots(record: from).bytes.suffix(from: field.offset)
        toF = Slots(record: to).bytes.suffix(from: field.offset)

        if fromF[int: 0] == toF[int: 0] {
            MSG_WriteBits(msg, 0, 1)	// no change
            i += 1
            continue
        }

        MSG_WriteBits(msg, 1, 1)	// changed

        if field.bits == 0 {
            // float
            fullFloat = toF[float: 0]
            trunc = Int32(fullFloat)

            if fullFloat == 0.0 {
                MSG_WriteBits(msg, 0, 1)
                oldsize += FLOAT_INT_BITS
            } else {
                MSG_WriteBits(msg, 1, 1)
                if trunc == fullFloat && trunc + FLOAT_INT_BIAS >= 0 && trunc + FLOAT_INT_BIAS < (1 << FLOAT_INT_BITS) {
                    // send as small integer
                    MSG_WriteBits(msg, 0, 1)
                    MSG_WriteBits(msg, trunc + FLOAT_INT_BIAS, FLOAT_INT_BITS)
                } else {
                    // send as full floating point value
                    MSG_WriteBits(msg, 1, 1)
                    MSG_WriteBits(msg, toF[int: 0], 32)
                }
            }
        } else {
            if toF[int: 0] == 0 {
                MSG_WriteBits(msg, 0, 1)
            } else {
                MSG_WriteBits(msg, 1, 1)
                // integer
                MSG_WriteBits(msg, toF[int: 0], field.bits)
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/msg.cpp:1228
func MSG_ReadDeltaEntity(_ msg: Msg, _ from: JKAMP.EntityState, _ to: JKAMP.EntityState, _ number: Int32) {
    var i: Int32
    var lc: Int32
    var numFields: Int32
    var field: NetField
    var fromF: Slots<JKAShared.byte>
    var toF: Slots<JKAShared.byte>
    var print: Int32
    var trunc: Int32
    var startBit: Int32
    var endBit: Int32

    if number < 0 || number >= MAX_GENTITIES {
        Com_Error(ERR_DROP, "Bad delta entity number: %i", number)
    }

    startBit = msg.bit

    // check for a remove
    if MSG_ReadBits(msg, 1) == 1 {
        to.clear()
        to.number = MAX_GENTITIES - 1
        if cl_shownet!.integer >= 2 || cl_shownet!.integer == -1 {
            Com_Printf("%3i: #%-3i remove\n", msg.readcount, number)
        }
        return
    }

    // check for no delta
    if MSG_ReadBits(msg, 1) == 0 {
        to.copy(from: from)
        to.number = number
        return
    }

    numFields = Int32(entityStateFields.count)
    lc = MSG_ReadByte(msg)

    // shownet 2/3 will interleave with other printed info, -1 will
    // just print the delta records`
    if cl_shownet!.integer >= 2 || cl_shownet!.integer == -1 {
        print = 1
        if sv.state != 0 {
            Com_Printf("%3i: #%-3i (%s) ", msg.readcount, number, SV_GentityNum(number)!.classname ?? "(null)")
        } else {
            Com_Printf("%3i: #%-3i ", msg.readcount, number)
        }
    } else {
        print = 0
    }

    to.number = number

    // AI: Raven casts the record to a byte pointer and adds the field offset. The bytes of the record view give the Slots tail from that offset.
    i = 0
    while i < lc {
        field = entityStateFields[i]
        fromF = Slots(record: from).bytes.suffix(from: field.offset)
        toF = Slots(record: to).bytes.suffix(from: field.offset)

        if MSG_ReadBits(msg, 1) == 0 {
            // no change
            toF[int: 0] = fromF[int: 0]
        } else {
            if field.bits == 0 {
                // float
                if MSG_ReadBits(msg, 1) == 0 {
                    toF[float: 0] = 0.0
                } else {
                    if MSG_ReadBits(msg, 1) == 0 {
                        // integral float
                        trunc = MSG_ReadBits(msg, FLOAT_INT_BITS)
                        // bias to allow equal parts positive and negative
                        trunc -= FLOAT_INT_BIAS
                        toF[float: 0] = Float(trunc)
                        if print != 0 {
                            Com_Printf("%s:%i ", field.name ?? "(null)", trunc)
                        }
                    } else {
                        // full floating point value
                        toF[int: 0] = MSG_ReadBits(msg, 32)
                        if print != 0 {
                            Com_Printf("%s:%f ", field.name ?? "(null)", toF[float: 0])
                        }
                    }
                }
            } else {
                if MSG_ReadBits(msg, 1) == 0 {
                    toF[int: 0] = 0
                } else {
                    // integer
                    toF[int: 0] = MSG_ReadBits(msg, field.bits)
                    if print != 0 {
                        Com_Printf("%s:%i ", field.name ?? "(null)", toF[int: 0])
                    }
                }
            }
        }
        i += 1
    }
    i = lc
    while i < numFields {
        field = entityStateFields[i]
        fromF = Slots(record: from).bytes.suffix(from: field.offset)
        toF = Slots(record: to).bytes.suffix(from: field.offset)
        // no change
        toF[int: 0] = fromF[int: 0]
        i += 1
    }

    if print != 0 {
        endBit = msg.bit
        Com_Printf(" (%i bits)\n", endBit - startBit)
    }
}

//rww - Check the overrides files to see if the mod wants anything changed
/// Source: oracle/codemp/qcommon/msg.cpp:2006
func MSG_CheckNETFPSFOverrides(_ psfOverrides: Bool) {
    var fileName: String
    var numFields: Int32

    // Raven's `bitStorage_t **bitStorage` names `g_psfBitStorage` or `g_netfBitStorage`, so the statements after the choice take the chosen variable.
    // The locals that only those statements read are declared inside, because a nested function cannot capture a local before its first store.
    func withBitStorage(_ bitStorage: inout BitStorage?) {
        var overrideFile = CharBuf(4096)
        var entryName = CharBuf(4096)
        var bits = CharBuf(4096)
        var ibits: Int32
        var i: Int32 = 0
        var j: Int32
        var len: Int32
        var f: JKAShared.fileHandle_t = 0

        if bitStorage != nil {
            //if we have saved off the defaults before we want to stuff them all back in now
            var restore = bitStorage

            while i < numFields {
                if psfOverrides {
                    playerStateFields[i].bits = restore!.bits
                } else {
                    entityStateFields[i].bits = restore!.bits
                }

                i += 1
                restore = restore!.next
            }
        }

        len = FS_FOpenFileRead(va("ext_data/MP/%s", fileName), &f, false)

        if f == 0 {
            //silently exit since this file is not needed to proceed.
            return
        }

        if len >= 4096 {
            Com_Printf("WARNING: %s is >= 4096 bytes and is being ignored\n", fileName)
            FS_FCloseFile(f)
            return
        }

        //Get contents of the file
        _ = FS_Read(&overrideFile, len, f)
        FS_FCloseFile(f)

        //because FS_Read does not do this for us.
        overrideFile[len] = 0

        //If we haven't saved off the initial stuff yet then stuff it all into
        //a list.
        if bitStorage == nil {
            // Raven walks a `bitStorage_t **` from the head variable to each new record's `next`.
            // The walk keeps the last record, so each new record goes into the head or into that record's `next`.
            var last: BitStorage? = nil
            i = 0

            while i < numFields {
                //Alloc memory for this new ptr
                let node = BitStorage(Z_Malloc(Int32(BitStorage.byteCount), TAG_GENERAL, true))
                if let last {
                    last.next = node
                } else {
                    bitStorage = node
                }

                if psfOverrides {
                    node.bits = playerStateFields[i].bits
                } else {
                    node.bits = entityStateFields[i].bits
                }

                //Point to the ->next of the existing current ptr
                last = node
                i += 1
            }
        }

        i = 0
        //Now parse through. Lines beginning with ; are disabled.
        while overrideFile[i] != 0 {
            if overrideFile[i] == Int32(ascii: ";") {
                //parse to end of the line
                while overrideFile[i] != Int32(ascii: "\n") {
                    i += 1
                }
            }

            if overrideFile[i] != Int32(ascii: ";") &&
                overrideFile[i] != Int32(ascii: "\n") &&
                overrideFile[i] != Int32(ascii: "\r") {
                //on a valid char I guess, parse it
                j = 0

                while overrideFile[i] != 0 && overrideFile[i] != Int32(ascii: ",") {
                    entryName[j] = overrideFile[i]
                    j += 1
                    i += 1
                }
                entryName[j] = 0

                if overrideFile[i] == 0 {
                    //just give up, this shouldn't happen
                    Com_Printf("WARNING: Parsing error for %s\n", fileName)
                    return
                }

                while overrideFile[i] == Int32(ascii: ",") || overrideFile[i] == Int32(ascii: " ") {
                    //parse to the start of the value
                    i += 1
                }

                j = 0
                while overrideFile[i] != Int32(ascii: "\n") && overrideFile[i] != Int32(ascii: "\r") {
                    //now read the value in
                    bits[j] = overrideFile[i]
                    j += 1
                    i += 1
                }
                bits[j] = 0

                if bits[0] != 0 {
                    if strcmp(bits, "GENTITYNUM_BITS") == 0 {
                        //special case
                        ibits = GENTITYNUM_BITS
                    } else {
                        ibits = atoi(bits)
                    }

                    j = 0

                    //Now go through all the fields and see if we can find a match
                    while j < numFields {
                        if psfOverrides {
                            //check psf fields
                            if strcmp(playerStateFields[j].name!, entryName) == 0 {
                                //found it, set the bits
                                playerStateFields[j].bits = ibits
                                break
                            }
                        } else {
                            //otherwise check netf fields
                            if strcmp(entityStateFields[j].name!, entryName) == 0 {
                                //found it, set the bits
                                entityStateFields[j].bits = ibits
                                break
                            }
                        }
                        j += 1
                    }

                    if j == numFields {
                        //failed to find the value
                        Com_Printf("WARNING: Value '%s' from %s is not valid\n", entryName, fileName)
                    }
                } else {
                    //also should not happen
                    Com_Printf("WARNING: Parsing error for %s\n", fileName)
                    return
                }
            }

            i += 1
        }
    }

    if psfOverrides {
        //do PSF overrides instead of NETF
        fileName = "psf_overrides.txt"
        numFields = Int32(playerStateFields.count)
        withBitStorage(&g_psfBitStorage)
    } else {
        fileName = "netf_overrides.txt"
        numFields = Int32(entityStateFields.count)
        withBitStorage(&g_netfBitStorage)
    }
}

/// Source: oracle/codemp/qcommon/msg.cpp:2213
func MSG_WriteDeltaPlayerstate(_ msg: Msg, _ from: JKAMP.PlayerState?, _ to: JKAMP.PlayerState, _ isVehiclePS: Bool = false) {
    var from = from

    PlayerState.scratch { dummy in
        var i: Int32
        var statsbits: Int32
        var persistantbits: Int32
        var ammobits: Int32
        var powerupbits: Int32
        var numFields: Int32
        var c: Int32
        var field: NetField
        var PSFields = playerStateFields
        var fromF: Slots<JKAShared.byte>
        var toF: Slots<JKAShared.byte>
        var fullFloat: Float
        var trunc: Int32
        var lc: Int32

        if from == nil {
            from = dummy
            dummy.clear()
        }

        c = msg.cursize

//=====_OPTIMIZED_VEHICLE_NETWORKING=======================================================================
        if isVehiclePS {//a vehicle playerstate
            numFields = Int32(vehPlayerStateFields.count)
            PSFields = vehPlayerStateFields
        } else {//regular client playerstate
            if to.m_iVehicleNum != 0 && (to.eFlags & EF_NODRAW) != 0 {//pilot riding *inside* a vehicle!
                MSG_WriteBits(msg, 1, 1)	// Pilot player state
                numFields = Int32(pilotPlayerStateFields.count) - 82
                PSFields = pilotPlayerStateFields
            } else {//normal client
                MSG_WriteBits(msg, 0, 1)	// Normal player state
                numFields = Int32(playerStateFields.count)
            }
        }
//=====_OPTIMIZED_VEHICLE_NETWORKING=======================================================================

        // AI: Raven casts the record to a byte pointer and adds the field offset. The bytes of the record view give the Slots tail from that offset.
        lc = 0
        i = 0
        while i < numFields {
            field = PSFields[i]
            fromF = Slots(record: from!).bytes.suffix(from: field.offset)
            toF = Slots(record: to).bytes.suffix(from: field.offset)
            if fromF[int: 0] != toF[int: 0] {
                lc = i + 1
                field.mCount += 1
            }
            i += 1
        }

        MSG_WriteByte(msg, lc)	// # of changes

        gLastBitIndex = lc

        oldsize += numFields - lc

        i = 0
        while i < lc {
            field = PSFields[i]
            fromF = Slots(record: from!).bytes.suffix(from: field.offset)
            toF = Slots(record: to).bytes.suffix(from: field.offset)

            if fromF[int: 0] == toF[int: 0] {
                MSG_WriteBits(msg, 0, 1)	// no change
                i += 1
                continue
            }

            MSG_WriteBits(msg, 1, 1)	// changed

            if field.bits == 0 {
                // float
                fullFloat = toF[float: 0]
                trunc = Int32(fullFloat)

                if trunc == fullFloat && trunc + FLOAT_INT_BIAS >= 0 && trunc + FLOAT_INT_BIAS < (1 << FLOAT_INT_BITS) {
                    // send as small integer
                    MSG_WriteBits(msg, 0, 1)
                    MSG_WriteBits(msg, trunc + FLOAT_INT_BIAS, FLOAT_INT_BITS)
                } else {
                    // send as full floating point value
                    MSG_WriteBits(msg, 1, 1)
                    MSG_WriteBits(msg, toF[int: 0], 32)
                }
            } else {
                // integer
                MSG_WriteBits(msg, toF[int: 0], field.bits)
            }
            i += 1
        }
        c = msg.cursize - c


        //
        // send the arrays
        //
        statsbits = 0
        i = 0
        while i < 16 {
            if to.stats[i] != from!.stats[i] {
                statsbits |= 1 << i
            }
            i += 1
        }
        persistantbits = 0
        i = 0
        while i < 16 {
            if to.persistant[i] != from!.persistant[i] {
                persistantbits |= 1 << i
            }
            i += 1
        }
        ammobits = 0
        i = 0
        while i < 16 {
            if to.ammo[i] != from!.ammo[i] {
                ammobits |= 1 << i
            }
            i += 1
        }
        powerupbits = 0
        i = 0
        while i < 16 {
            if to.powerups[i] != from!.powerups[i] {
                powerupbits |= 1 << i
            }
            i += 1
        }

        if statsbits == 0 && persistantbits == 0 && ammobits == 0 && powerupbits == 0 {
            MSG_WriteBits(msg, 0, 1)	// no change
            oldsize += 4
            return
        }
        MSG_WriteBits(msg, 1, 1)	// changed

        if statsbits != 0 {
            MSG_WriteBits(msg, 1, 1)	// changed
            MSG_WriteShort(msg, statsbits)
            i = 0
            while i < 16 {
                if (statsbits & (1 << i)) != 0 {
                    if i == STAT_WEAPONS { //ugly.. but we're gonna need it anyway -rww
                        //(just send this one in MAX_WEAPONS bits, so that we can add up to MAX_WEAPONS weaps without hassle)
                        MSG_WriteBits(msg, to.stats[i], MAX_WEAPONS)
                    } else {
                        MSG_WriteShort(msg, to.stats[i])
                    }
                }
                i += 1
            }
        } else {
            MSG_WriteBits(msg, 0, 1)	// no change
        }


        if persistantbits != 0 {
            MSG_WriteBits(msg, 1, 1)	// changed
            MSG_WriteShort(msg, persistantbits)
            i = 0
            while i < 16 {
                if (persistantbits & (1 << i)) != 0 {
                    MSG_WriteShort(msg, to.persistant[i])
                }
                i += 1
            }
        } else {
            MSG_WriteBits(msg, 0, 1)	// no change
        }


        if ammobits != 0 {
            MSG_WriteBits(msg, 1, 1)	// changed
            MSG_WriteShort(msg, ammobits)
            i = 0
            while i < 16 {
                if (ammobits & (1 << i)) != 0 {
                    MSG_WriteShort(msg, to.ammo[i])
                }
                i += 1
            }
        } else {
            MSG_WriteBits(msg, 0, 1)	// no change
        }


        if powerupbits != 0 {
            MSG_WriteBits(msg, 1, 1)	// changed
            MSG_WriteShort(msg, powerupbits)
            i = 0
            while i < 16 {
                if (powerupbits & (1 << i)) != 0 {
                    MSG_WriteLong(msg, to.powerups[i])
                }
                i += 1
            }
        } else {
            MSG_WriteBits(msg, 0, 1)	// no change
        }
    }
}

/**
```
===================
MSG_ReadDeltaPlayerstate
===================
```
*/
/// Source: oracle/codemp/qcommon/msg.cpp:2455
func MSG_ReadDeltaPlayerstate(_ msg: Msg, _ from: JKAMP.PlayerState, _ to: JKAMP.PlayerState, _ isVehiclePS: Bool = false) {
    var i: Int32
    var lc: Int32
    var bits: Int32
    var field: NetField
    var PSFields = playerStateFields
    var numFields: Int32
    var startBit: Int32
    var endBit: Int32
    var print: Int32
    var fromF: Slots<JKAShared.byte>
    var toF: Slots<JKAShared.byte>
    var trunc: Int32

    to.copy(from: from)

    if msg.bit == 0 {
        startBit = msg.readcount * 8 - GENTITYNUM_BITS
    } else {
        startBit = (msg.readcount - 1) * 8 + msg.bit - GENTITYNUM_BITS
    }

    // shownet 2/3 will interleave with other printed info, -2 will
    // just print the delta records
    if cl_shownet!.integer >= 2 || cl_shownet!.integer == -2 {
        print = 1
        Com_Printf("%3i: playerstate ", msg.readcount)
    } else {
        print = 0
    }

//=====_OPTIMIZED_VEHICLE_NETWORKING=======================================================================
    if isVehiclePS {//a vehicle playerstate
        numFields = Int32(vehPlayerStateFields.count)
        PSFields = vehPlayerStateFields
    } else {
        let isPilot: Int32 = MSG_ReadBits(msg, 1)
        if isPilot != 0 {//pilot riding *inside* a vehicle!
            numFields = Int32(pilotPlayerStateFields.count) - 82
            PSFields = pilotPlayerStateFields
        } else {//normal client
            numFields = Int32(playerStateFields.count)
        }
    }
//=====_OPTIMIZED_VEHICLE_NETWORKING=======================================================================

    lc = MSG_ReadByte(msg)

    // AI: Raven casts the record to a byte pointer and adds the field offset. The bytes of the record view give the Slots tail from that offset.
    i = 0
    while i < lc {
        field = PSFields[i]
        fromF = Slots(record: from).bytes.suffix(from: field.offset)
        toF = Slots(record: to).bytes.suffix(from: field.offset)

        if MSG_ReadBits(msg, 1) == 0 {
            // no change
            toF[int: 0] = fromF[int: 0]
        } else {
            if field.bits == 0 {
                // float
                if MSG_ReadBits(msg, 1) == 0 {
                    // integral float
                    trunc = MSG_ReadBits(msg, FLOAT_INT_BITS)
                    // bias to allow equal parts positive and negative
                    trunc -= FLOAT_INT_BIAS
                    toF[float: 0] = Float(trunc)
                    if print != 0 {
                        Com_Printf("%s:%i ", field.name ?? "(null)", trunc)
                    }
                } else {
                    // full floating point value
                    toF[int: 0] = MSG_ReadBits(msg, 32)
                    if print != 0 {
                        Com_Printf("%s:%f ", field.name ?? "(null)", toF[float: 0])
                    }
                }
            } else {
                // integer
                toF[int: 0] = MSG_ReadBits(msg, field.bits)
                if print != 0 {
                    Com_Printf("%s:%i ", field.name ?? "(null)", toF[int: 0])
                }
            }
        }
        i += 1
    }
    i = lc
    while i < numFields {
        field = PSFields[i]
        fromF = Slots(record: from).bytes.suffix(from: field.offset)
        toF = Slots(record: to).bytes.suffix(from: field.offset)
        // no change
        toF[int: 0] = fromF[int: 0]
        i += 1
    }

    // read the arrays
    if MSG_ReadBits(msg, 1) != 0 {
        // parse stats
        if MSG_ReadBits(msg, 1) != 0 {
            // Raven's `LOG(x)` macro of this file expands at each site, because the stub has no function for it.
            if cl_shownet!.integer == 4 { Com_Printf("%s ", "PS_STATS") }
            bits = MSG_ReadShort(msg)
            i = 0
            while i < 16 {
                if (bits & (1 << i)) != 0 {
                    if i == STAT_WEAPONS { //ugly.. but we're gonna need it anyway -rww
                        to.stats[i] = MSG_ReadBits(msg, MAX_WEAPONS)
                    } else {
                        to.stats[i] = MSG_ReadShort(msg)
                    }
                }
                i += 1
            }
        }

        // parse persistant stats
        if MSG_ReadBits(msg, 1) != 0 {
            if cl_shownet!.integer == 4 { Com_Printf("%s ", "PS_PERSISTANT") }
            bits = MSG_ReadShort(msg)
            i = 0
            while i < 16 {
                if (bits & (1 << i)) != 0 {
                    to.persistant[i] = MSG_ReadShort(msg)
                }
                i += 1
            }
        }

        // parse ammo
        if MSG_ReadBits(msg, 1) != 0 {
            if cl_shownet!.integer == 4 { Com_Printf("%s ", "PS_AMMO") }
            bits = MSG_ReadShort(msg)
            i = 0
            while i < 16 {
                if (bits & (1 << i)) != 0 {
                    to.ammo[i] = MSG_ReadShort(msg)
                }
                i += 1
            }
        }

        // parse powerups
        if MSG_ReadBits(msg, 1) != 0 {
            if cl_shownet!.integer == 4 { Com_Printf("%s ", "PS_POWERUPS") }
            bits = MSG_ReadShort(msg)
            i = 0
            while i < 16 {
                if (bits & (1 << i)) != 0 {
                    to.powerups[i] = MSG_ReadLong(msg)
                }
                i += 1
            }
        }
    }

    if print != 0 {
        if msg.bit == 0 {
            endBit = msg.readcount * 8 - GENTITYNUM_BITS
        } else {
            endBit = (msg.readcount - 1) * 8 + msg.bit - GENTITYNUM_BITS
        }
        Com_Printf(" (%i bits)\n", endBit - startBit)
    }
}

/// Source: oracle/codemp/qcommon/msg.cpp:3219
func MSG_initHuffman() {
    var i: Int32
    var j: Int32

    msgInit = true
    Huff_Init(msgHuff)
    i = 0
    while i < 256 {
        j = 0
        while j < msg_hData[i] {
            Huff_addRef(msgHuff.compressor, Int32(UInt8(truncatingIfNeeded: i)))			// Do update
            Huff_addRef(msgHuff.decompressor, Int32(UInt8(truncatingIfNeeded: i)))			// Do update
            j += 1
        }
        i += 1
    }
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
    var numFields: Int32
    var i: Int32
    var field: NetField

    numFields = Int32(entityStateFields.count)

    Com_Printf("Entity State Fields:\n")
    i = 0
    while i < numFields {
        field = entityStateFields[i]
        // The `%d` of Raven's format reads the unsigned count as an `int`.
        Com_Printf("%s\t\t%d\n", field.name ?? "(null)", Int32(bitPattern: field.mCount))
        field.mCount = 0
        i += 1
    }

    Com_Printf("\nPlayer State Fields:\n")
    numFields = Int32(playerStateFields.count)
    i = 0
    while i < numFields {
        field = playerStateFields[i]
        Com_Printf("%s\t\t%d\n", field.name ?? "(null)", Int32(bitPattern: field.mCount))
        field.mCount = 0
        i += 1
    }
}
