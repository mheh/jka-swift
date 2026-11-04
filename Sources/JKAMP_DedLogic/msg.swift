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
let kbitmask: [Int32] = { () -> [Int32] in portMissing("kbitmask", source: "oracle/codemp/qcommon/msg.cpp:610") }()

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
let msg_hData: [Int32] = [
    250315, // 0
    41193, // 1
    6292, // 2
    7106, // 3
    3730, // 4
    3750, // 5
    6110, // 6
    23283, // 7
    33317, // 8
    6950, // 9
    7838, // 10
    9714, // 11
    9257, // 12
    17259, // 13
    3949, // 14
    1778, // 15
    8288, // 16
    1604, // 17
    1590, // 18
    1663, // 19
    1100, // 20
    1213, // 21
    1238, // 22
    1134, // 23
    1749, // 24
    1059, // 25
    1246, // 26
    1149, // 27
    1273, // 28
    4486, // 29
    2805, // 30
    3472, // 31
    21819, // 32
    1159, // 33
    1670, // 34
    1066, // 35
    1043, // 36
    1012, // 37
    1053, // 38
    1070, // 39
    1726, // 40
    888, // 41
    1180, // 42
    850, // 43
    960, // 44
    780, // 45
    1752, // 46
    3296, // 47
    10630, // 48
    4514, // 49
    5881, // 50
    2685, // 51
    4650, // 52
    3837, // 53
    2093, // 54
    1867, // 55
    2584, // 56
    1949, // 57
    1972, // 58
    940, // 59
    1134, // 60
    1788, // 61
    1670, // 62
    1206, // 63
    5719, // 64
    6128, // 65
    7222, // 66
    6654, // 67
    3710, // 68
    3795, // 69
    1492, // 70
    1524, // 71
    2215, // 72
    1140, // 73
    1355, // 74
    971, // 75
    2180, // 76
    1248, // 77
    1328, // 78
    1195, // 79
    1770, // 80
    1078, // 81
    1264, // 82
    1266, // 83
    1168, // 84
    965, // 85
    1155, // 86
    1186, // 87
    1347, // 88
    1228, // 89
    1529, // 90
    1600, // 91
    2617, // 92
    2048, // 93
    2546, // 94
    3275, // 95
    2410, // 96
    3585, // 97
    2504, // 98
    2800, // 99
    2675, // 100
    6146, // 101
    3663, // 102
    2840, // 103
    14253, // 104
    3164, // 105
    2221, // 106
    1687, // 107
    3208, // 108
    2739, // 109
    3512, // 110
    4796, // 111
    4091, // 112
    3515, // 113
    5288, // 114
    4016, // 115
    7937, // 116
    6031, // 117
    5360, // 118
    3924, // 119
    4892, // 120
    3743, // 121
    4566, // 122
    4807, // 123
    5852, // 124
    6400, // 125
    6225, // 126
    8291, // 127
    23243, // 128
    7838, // 129
    7073, // 130
    8935, // 131
    5437, // 132
    4483, // 133
    3641, // 134
    5256, // 135
    5312, // 136
    5328, // 137
    5370, // 138
    3492, // 139
    2458, // 140
    1694, // 141
    1821, // 142
    2121, // 143
    1916, // 144
    1149, // 145
    1516, // 146
    1367, // 147
    1236, // 148
    1029, // 149
    1258, // 150
    1104, // 151
    1245, // 152
    1006, // 153
    1149, // 154
    1025, // 155
    1241, // 156
    952, // 157
    1287, // 158
    997, // 159
    1713, // 160
    1009, // 161
    1187, // 162
    879, // 163
    1099, // 164
    929, // 165
    1078, // 166
    951, // 167
    1656, // 168
    930, // 169
    1153, // 170
    1030, // 171
    1262, // 172
    1062, // 173
    1214, // 174
    1060, // 175
    1621, // 176
    930, // 177
    1106, // 178
    912, // 179
    1034, // 180
    892, // 181
    1158, // 182
    990, // 183
    1175, // 184
    850, // 185
    1121, // 186
    903, // 187
    1087, // 188
    920, // 189
    1144, // 190
    1056, // 191
    3462, // 192
    2240, // 193
    4397, // 194
    12136, // 195
    7758, // 196
    1345, // 197
    1307, // 198
    3278, // 199
    1950, // 200
    886, // 201
    1023, // 202
    1112, // 203
    1077, // 204
    1042, // 205
    1061, // 206
    1071, // 207
    1484, // 208
    1001, // 209
    1096, // 210
    915, // 211
    1052, // 212
    995, // 213
    1070, // 214
    876, // 215
    1111, // 216
    851, // 217
    1059, // 218
    805, // 219
    1112, // 220
    923, // 221
    1103, // 222
    817, // 223
    1899, // 224
    1872, // 225
    976, // 226
    841, // 227
    1127, // 228
    956, // 229
    1159, // 230
    950, // 231
    7791, // 232
    954, // 233
    1289, // 234
    933, // 235
    1127, // 236
    3207, // 237
    1020, // 238
    927, // 239
    1355, // 240
    768, // 241
    1040, // 242
    745, // 243
    952, // 244
    805, // 245
    1073, // 246
    740, // 247
    1013, // 248
    805, // 249
    1008, // 250
    796, // 251
    996, // 252
    1057, // 253
    11457, // 254
    13504, // 255
]

/// Source: oracle/codemp/qcommon/msg.cpp:46
func MSG_Init(_ buf: Msg, _ data: OpaquePointer?, _ length: Int32) {
    // TODO: Port MSG_Init
    portMissing("MSG_Init", source: "oracle/codemp/qcommon/msg.cpp:46")
}

/// Source: oracle/codemp/qcommon/msg.cpp:70
func MSG_InitOOB(_ buf: Msg, _ data: OpaquePointer?, _ length: Int32) {
    // TODO: Port MSG_InitOOB
    portMissing("MSG_InitOOB", source: "oracle/codemp/qcommon/msg.cpp:70")
}

/// Source: oracle/codemp/qcommon/msg.cpp:94
func MSG_Clear(_ buf: Msg) {
    // TODO: Port MSG_Clear
    portMissing("MSG_Clear", source: "oracle/codemp/qcommon/msg.cpp:94")
}

/// Source: oracle/codemp/qcommon/msg.cpp:101
func MSG_Bitstream(_ buf: Msg) {
    // TODO: Port MSG_Bitstream
    portMissing("MSG_Bitstream", source: "oracle/codemp/qcommon/msg.cpp:101")
}

/// Source: oracle/codemp/qcommon/msg.cpp:105
func MSG_BeginReading(_ msg: Msg) {
    // TODO: Port MSG_BeginReading
    portMissing("MSG_BeginReading", source: "oracle/codemp/qcommon/msg.cpp:105")
}

/// Source: oracle/codemp/qcommon/msg.cpp:111
func MSG_BeginReadingOOB(_ msg: Msg) {
    // TODO: Port MSG_BeginReadingOOB
    portMissing("MSG_BeginReadingOOB", source: "oracle/codemp/qcommon/msg.cpp:111")
}

// negative bit values include signs
/// Source: oracle/codemp/qcommon/msg.cpp:129
func MSG_WriteBits(_ msg: Msg, _ value: Int32, _ bits: Int32) {
    // TODO: Port MSG_WriteBits
    portMissing("MSG_WriteBits", source: "oracle/codemp/qcommon/msg.cpp:129")
}

/// Source: oracle/codemp/qcommon/msg.cpp:211
func MSG_ReadBits(_ msg: Msg, _ bits: Int32) -> Int32 {
    // TODO: Port MSG_ReadBits
    portMissing("MSG_ReadBits", source: "oracle/codemp/qcommon/msg.cpp:211")
}

/// Source: oracle/codemp/qcommon/msg.cpp:280
func MSG_WriteChar(_ sb: Msg, _ c: Int32) {
    // TODO: Port MSG_WriteChar
    portMissing("MSG_WriteChar", source: "oracle/codemp/qcommon/msg.cpp:280")
}

/// Source: oracle/codemp/qcommon/msg.cpp:289
func MSG_WriteByte(_ sb: Msg, _ c: Int32) {
    // TODO: Port MSG_WriteByte
    portMissing("MSG_WriteByte", source: "oracle/codemp/qcommon/msg.cpp:289")
}

/// Source: oracle/codemp/qcommon/msg.cpp:298
func MSG_WriteData(_ buf: Msg, _ data: OpaquePointer?, _ length: Int32) {
    // TODO: Port MSG_WriteData
    portMissing("MSG_WriteData", source: "oracle/codemp/qcommon/msg.cpp:298")
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
    // TODO: Port MSG_WriteShort
    portMissing("MSG_WriteShort", source: "oracle/codemp/qcommon/msg.cpp:305")
}

/// Source: oracle/codemp/qcommon/msg.cpp:314
func MSG_WriteLong(_ sb: Msg, _ c: Int32) {
    // TODO: Port MSG_WriteLong
    portMissing("MSG_WriteLong", source: "oracle/codemp/qcommon/msg.cpp:314")
}

/// Source: oracle/codemp/qcommon/msg.cpp:318
func MSG_WriteFloat(_ sb: Msg, _ f: Float) {
    // TODO: Port MSG_WriteFloat
    portMissing("MSG_WriteFloat", source: "oracle/codemp/qcommon/msg.cpp:318")
}

/// Source: oracle/codemp/qcommon/msg.cpp:328
func MSG_WriteString(_ sb: Msg, _ s: String) {
    // TODO: Port MSG_WriteString
    portMissing("MSG_WriteString", source: "oracle/codemp/qcommon/msg.cpp:328")
}

/// Source: oracle/codemp/qcommon/msg.cpp:356
func MSG_WriteBigString(_ sb: Msg, _ s: String) {
    // TODO: Port MSG_WriteBigString
    portMissing("MSG_WriteBigString", source: "oracle/codemp/qcommon/msg.cpp:356")
}

/// Source: oracle/codemp/qcommon/msg.cpp:385
func MSG_WriteAngle(_ sb: Msg, _ f: Float) {
    // TODO: Port MSG_WriteAngle
    portMissing("MSG_WriteAngle", source: "oracle/codemp/qcommon/msg.cpp:385")
}

/// Source: oracle/codemp/qcommon/msg.cpp:389
func MSG_WriteAngle16(_ sb: Msg, _ f: Float) {
    // TODO: Port MSG_WriteAngle16
    portMissing("MSG_WriteAngle16", source: "oracle/codemp/qcommon/msg.cpp:389")
}

// returns -1 if no more characters are available
/// Source: oracle/codemp/qcommon/msg.cpp:401
func MSG_ReadChar(_ msg: Msg) -> Int32 {
    // TODO: Port MSG_ReadChar
    portMissing("MSG_ReadChar", source: "oracle/codemp/qcommon/msg.cpp:401")
}

/// Source: oracle/codemp/qcommon/msg.cpp:412
func MSG_ReadByte(_ msg: Msg) -> Int32 {
    // TODO: Port MSG_ReadByte
    portMissing("MSG_ReadByte", source: "oracle/codemp/qcommon/msg.cpp:412")
}

/// Source: oracle/codemp/qcommon/msg.cpp:422
func MSG_ReadShort(_ msg: Msg) -> Int32 {
    // TODO: Port MSG_ReadShort
    portMissing("MSG_ReadShort", source: "oracle/codemp/qcommon/msg.cpp:422")
}

/// Source: oracle/codemp/qcommon/msg.cpp:433
func MSG_ReadLong(_ msg: Msg) -> Int32 {
    // TODO: Port MSG_ReadLong
    portMissing("MSG_ReadLong", source: "oracle/codemp/qcommon/msg.cpp:433")
}

/// Source: oracle/codemp/qcommon/msg.cpp:444
func MSG_ReadFloat(_ msg: Msg) -> Float {
    // TODO: Port MSG_ReadFloat
    portMissing("MSG_ReadFloat", source: "oracle/codemp/qcommon/msg.cpp:444")
}

/// Source: oracle/codemp/qcommon/msg.cpp:459
func MSG_ReadString(_ msg: Msg) -> String {
    // TODO: Port MSG_ReadString
    portMissing("MSG_ReadString", source: "oracle/codemp/qcommon/msg.cpp:459")
}

/// Source: oracle/codemp/qcommon/msg.cpp:497
func MSG_ReadBigString(_ msg: Msg) -> String {
    // TODO: Port MSG_ReadBigString
    portMissing("MSG_ReadBigString", source: "oracle/codemp/qcommon/msg.cpp:497")
}

/// Source: oracle/codemp/qcommon/msg.cpp:521
func MSG_ReadStringLine(_ msg: Msg) -> String {
    // TODO: Port MSG_ReadStringLine
    portMissing("MSG_ReadStringLine", source: "oracle/codemp/qcommon/msg.cpp:521")
}

/// Source: oracle/codemp/qcommon/msg.cpp:544
func MSG_ReadAngle16(_ msg: Msg) -> Float {
    // TODO: Port MSG_ReadAngle16
    portMissing("MSG_ReadAngle16", source: "oracle/codemp/qcommon/msg.cpp:544")
}

/// Source: oracle/codemp/qcommon/msg.cpp:548
func MSG_ReadData(_ msg: Msg, _ data: OpaquePointer?, _ len: Int32) {
    // TODO: Port MSG_ReadData
    portMissing("MSG_ReadData", source: "oracle/codemp/qcommon/msg.cpp:548")
}

/// Source: oracle/codemp/qcommon/msg.cpp:567
func MSG_WriteDelta(_ msg: Msg, _ oldV: Int32, _ newV: Int32, _ bits: Int32) {
    // TODO: Port MSG_WriteDelta
    portMissing("MSG_WriteDelta", source: "oracle/codemp/qcommon/msg.cpp:567")
}

/// Source: oracle/codemp/qcommon/msg.cpp:576
func MSG_ReadDelta(_ msg: Msg, _ oldV: Int32, _ bits: Int32) -> Int32 {
    // TODO: Port MSG_ReadDelta
    portMissing("MSG_ReadDelta", source: "oracle/codemp/qcommon/msg.cpp:576")
}

/// Source: oracle/codemp/qcommon/msg.cpp:583
func MSG_WriteDeltaFloat(_ msg: Msg, _ oldV: Float, _ newV: Float) {
    // TODO: Port MSG_WriteDeltaFloat
    portMissing("MSG_WriteDeltaFloat", source: "oracle/codemp/qcommon/msg.cpp:583")
}

/// Source: oracle/codemp/qcommon/msg.cpp:592
func MSG_ReadDeltaFloat(_ msg: Msg, _ oldV: Float) -> Float {
    // TODO: Port MSG_ReadDeltaFloat
    portMissing("MSG_ReadDeltaFloat", source: "oracle/codemp/qcommon/msg.cpp:592")
}

/// Source: oracle/codemp/qcommon/msg.cpp:621
func MSG_WriteDeltaKey(_ msg: Msg, _ key: Int32, _ oldV: Int32, _ newV: Int32, _ bits: Int32) {
    // TODO: Port MSG_WriteDeltaKey
    portMissing("MSG_WriteDeltaKey", source: "oracle/codemp/qcommon/msg.cpp:621")
}

/// Source: oracle/codemp/qcommon/msg.cpp:632
func MSG_ReadDeltaKey(_ msg: Msg, _ key: Int32, _ oldV: Int32, _ bits: Int32) -> Int32 {
    // TODO: Port MSG_ReadDeltaKey
    portMissing("MSG_ReadDeltaKey", source: "oracle/codemp/qcommon/msg.cpp:632")
}

/// Source: oracle/codemp/qcommon/msg.cpp:639
func MSG_WriteDeltaKeyFloat(_ msg: Msg, _ key: Int32, _ oldV: Float, _ newV: Float) {
    // TODO: Port MSG_WriteDeltaKeyFloat
    portMissing("MSG_WriteDeltaKeyFloat", source: "oracle/codemp/qcommon/msg.cpp:639")
}

/// Source: oracle/codemp/qcommon/msg.cpp:648
func MSG_ReadDeltaKeyFloat(_ msg: Msg, _ key: Int32, _ oldV: Float) -> Float {
    // TODO: Port MSG_ReadDeltaKeyFloat
    portMissing("MSG_ReadDeltaKeyFloat", source: "oracle/codemp/qcommon/msg.cpp:648")
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
    // TODO: Port MSG_WriteDeltaUsercmd
    portMissing("MSG_WriteDeltaUsercmd", source: "oracle/codemp/qcommon/msg.cpp:685")
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
    // TODO: Port MSG_ReadDeltaUsercmd
    portMissing("MSG_ReadDeltaUsercmd", source: "oracle/codemp/qcommon/msg.cpp:714")
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
    // TODO: Port MSG_WriteDeltaUsercmdKey
    portMissing("MSG_WriteDeltaUsercmdKey", source: "oracle/codemp/qcommon/msg.cpp:740")
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
    // TODO: Port MSG_ReadDeltaUsercmdKey
    portMissing("MSG_ReadDeltaUsercmdKey", source: "oracle/codemp/qcommon/msg.cpp:786")
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
    // TODO: Port MSG_WriteDeltaEntity
    portMissing("MSG_WriteDeltaEntity", source: "oracle/codemp/qcommon/msg.cpp:1069")
}

/// Source: oracle/codemp/qcommon/msg.cpp:1228
func MSG_ReadDeltaEntity(_ msg: Msg, _ from: JKAMP.EntityState, _ to: JKAMP.EntityState, _ number: Int32) {
    // TODO: Port MSG_ReadDeltaEntity
    portMissing("MSG_ReadDeltaEntity", source: "oracle/codemp/qcommon/msg.cpp:1228")
}

//rww - Check the overrides files to see if the mod wants anything changed
/// Source: oracle/codemp/qcommon/msg.cpp:2006
func MSG_CheckNETFPSFOverrides(_ psfOverrides: Bool) {
    // TODO: Port MSG_CheckNETFPSFOverrides
    portMissing("MSG_CheckNETFPSFOverrides", source: "oracle/codemp/qcommon/msg.cpp:2006")
}

/// Source: oracle/codemp/qcommon/msg.cpp:2213
func MSG_WriteDeltaPlayerstate(_ msg: Msg, _ from: JKAMP.PlayerState?, _ to: JKAMP.PlayerState, _ isVehiclePS: Bool) {
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
    // TODO: Port MSG_ReadDeltaPlayerstate
    portMissing("MSG_ReadDeltaPlayerstate", source: "oracle/codemp/qcommon/msg.cpp:2455")
}

/// Source: oracle/codemp/qcommon/msg.cpp:3219
func MSG_initHuffman() {
    // TODO: Port MSG_initHuffman
    portMissing("MSG_initHuffman", source: "oracle/codemp/qcommon/msg.cpp:3219")
}

/// Source: oracle/codemp/qcommon/msg.cpp:3274
func MSG_shutdownHuffman() {
    // TODO: Port MSG_shutdownHuffman
    portMissing("MSG_shutdownHuffman", source: "oracle/codemp/qcommon/msg.cpp:3274")
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
    // TODO: Port MSG_ReportChangeVectors_f
    portMissing("MSG_ReportChangeVectors_f", source: "oracle/codemp/qcommon/msg.cpp:3291")
}
