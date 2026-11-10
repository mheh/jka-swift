@preconcurrency internal import CJKAMP_Ded
import JKAMP
import JKAShared

/// Raven's entity state field table, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// The offset of a row is a byte offset into the record, Raven's `NETF` or `PSF`.
/// Source: oracle/codemp/qcommon/msg.cpp:859
public nonisolated(unsafe) let entityStateFields: Slots<NetField> = makeEntityStateFields()

/// Raven's player state field table, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// The offset of a row is a byte offset into the record, Raven's `NETF` or `PSF`.
/// Source: oracle/codemp/qcommon/msg.cpp:1410
public nonisolated(unsafe) let playerStateFields: Slots<NetField> = makePlayerStateFields()

/// Raven's pilot player state field table, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// The offset of a row is a byte offset into the record, Raven's `NETF` or `PSF`.
/// Source: oracle/codemp/qcommon/msg.cpp:1570
public nonisolated(unsafe) let pilotPlayerStateFields: Slots<NetField> = makePilotPlayerStateFields()

/// Raven's vehicle player state field table, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// The offset of a row is a byte offset into the record, Raven's `NETF` or `PSF`.
/// Source: oracle/codemp/qcommon/msg.cpp:1736
public nonisolated(unsafe) let vehPlayerStateFields: Slots<NetField> = makeVehPlayerStateFields()

/// Raven's padding table of md4.cpp, the 64 bytes MD4Final appends, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/qcommon/md4.cpp:78
// AI: Raven keeps `PADDING` as a static array of md4.cpp. The port reads the C storage as a Slots of bytes, so MD4Update takes it.
public nonisolated(unsafe) let PADDING: Slots<JKAShared.byte> = makePADDING()

/// Raven's static block for a zone allocation of zero bytes, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:139
public nonisolated(unsafe) let gZeroMalloc: StaticZeroMem = makeGZeroMalloc()

/// Raven's static block of the empty text that CopyString returns, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:141
public nonisolated(unsafe) let gEmptyString: StaticMem = makeGEmptyString()

/// Raven's ten static blocks of the digit texts that CopyString returns, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:143
public nonisolated(unsafe) let gNumberString: Slots<StaticMem> = makeGNumberString()

/// Raven's table of video modes, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/renderer/tr_init.cpp:465
public nonisolated(unsafe) let r_vidModes: Slots<Vidmode> = makeR_vidModes()

/// Raven's punctuations of the script reader, longer ones first, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// PS_CreatePunctuationTable links the rows through their `next` field.
/// Source: oracle/codemp/botlib/l_script.cpp:69
public nonisolated(unsafe) let default_punctuations: Slots<Punctuation> = makeDefault_punctuations()

/// Raven's field table of the item info record, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:123
public nonisolated(unsafe) let iteminfo_fields: Slots<Fielddef> = makeIteminfo_fields()

/// Raven's record of the item info fields, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:136
public nonisolated(unsafe) let iteminfo_struct: Structdef = makeIteminfo_struct()

/// Raven's field table of the weapon info record, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:38
public nonisolated(unsafe) let weaponinfo_fields: Slots<Fielddef> = makeWeaponinfo_fields()

/// Raven's field table of the projectile info record, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:66
public nonisolated(unsafe) let projectileinfo_fields: Slots<Fielddef> = makeProjectileinfo_fields()

/// Raven's record of the weapon info fields, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:86
public nonisolated(unsafe) let weaponinfo_struct: Structdef = makeWeaponinfo_struct()

/// Raven's record of the projectile info fields, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:90
public nonisolated(unsafe) let projectileinfo_struct: Structdef = makeProjectileinfo_struct()

/// Raven's identity matrix of tr_ghoul2.cpp, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:128
public nonisolated(unsafe) let identityMatrix: JKAMP.MdxaBone = makeIdentityMatrix()

/// Raven's static identity matrix of G2API_GetBoltMatrix, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1801
// AI: Raven declares `identityMatrix` static in G2API_GetBoltMatrix. The record is C storage, and its name takes the function name as a suffix.
public nonisolated(unsafe) let identityMatrix_G2API_GetBoltMatrix: JKAMP.MdxaBone = makeIdentityMatrix_G2API_GetBoltMatrix()

/// Raven's static identity matrix `id` of G2_Set_Bone_Angles_Rag, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:1423
// AI: Raven declares `id` static in G2_Set_Bone_Angles_Rag. The record is C storage, and its name takes the function name as a suffix.
public nonisolated(unsafe) let id_G2_Set_Bone_Angles_Rag: JKAMP.MdxaBone = makeId_G2_Set_Bone_Angles_Rag()

/// Raven's static identity matrix `id` of G2_Set_Bone_Angles_IK, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/ghoul2/G2_bones.cpp:4575
// AI: Raven declares `id` static in G2_Set_Bone_Angles_IK. The record is C storage, and its name takes the function name as a suffix.
public nonisolated(unsafe) let id_G2_Set_Bone_Angles_IK: JKAMP.MdxaBone = makeId_G2_Set_Bone_Angles_IK()

/// Raven's behavior state name table of the ICARUS interface, over the C storage of `Sources/CJKAMP_Ded/ded_tables.c`.
/// Source: oracle/codemp/icarus/GameInterface.cpp:592
public nonisolated(unsafe) let BSTable: Slots<StringIDTable> = makeBSTable()

// MARK: - The bind over each C array

private func makeBSTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.BSTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.BSTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

/// The compiler crashes if a global initializer takes the address inline, so each table binds in a function.
private func makeEntityStateFields() -> Slots<NetField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.entityStateFields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.entityStateFields) / NetField.stride
    return Slots(views: base, count: count, stride: NetField.stride)
}

private func makePlayerStateFields() -> Slots<NetField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.playerStateFields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.playerStateFields) / NetField.stride
    return Slots(views: base, count: count, stride: NetField.stride)
}

private func makePilotPlayerStateFields() -> Slots<NetField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.pilotPlayerStateFields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.pilotPlayerStateFields) / NetField.stride
    return Slots(views: base, count: count, stride: NetField.stride)
}

private func makeVehPlayerStateFields() -> Slots<NetField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.vehPlayerStateFields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.vehPlayerStateFields) / NetField.stride
    return Slots(views: base, count: count, stride: NetField.stride)
}

private func makePADDING() -> Slots<JKAShared.byte> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.PADDING) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.PADDING)
    return Slots(scalars: base, count: count)
}

private func makeGZeroMalloc() -> StaticZeroMem {
    StaticZeroMem(withUnsafeMutablePointer(to: &CJKAMP_Ded.gZeroMalloc) { UnsafeMutableRawPointer($0) })
}

private func makeGEmptyString() -> StaticMem {
    StaticMem(withUnsafeMutablePointer(to: &CJKAMP_Ded.gEmptyString) { UnsafeMutableRawPointer($0) })
}

private func makeGNumberString() -> Slots<StaticMem> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.gNumberString) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.gNumberString) / StaticMem.stride
    return Slots(views: base, count: count, stride: StaticMem.stride)
}

private func makeR_vidModes() -> Slots<Vidmode> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.r_vidModes) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.r_vidModes) / Vidmode.stride
    return Slots(views: base, count: count, stride: Vidmode.stride)
}

private func makeDefault_punctuations() -> Slots<Punctuation> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.default_punctuations) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.default_punctuations) / Punctuation.stride
    return Slots(views: base, count: count, stride: Punctuation.stride)
}

private func makeIteminfo_fields() -> Slots<Fielddef> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.iteminfo_fields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.iteminfo_fields) / Fielddef.stride
    return Slots(views: base, count: count, stride: Fielddef.stride)
}

private func makeIteminfo_struct() -> Structdef {
    Structdef(withUnsafeMutablePointer(to: &CJKAMP_Ded.iteminfo_struct) { UnsafeMutableRawPointer($0) })
}

private func makeWeaponinfo_fields() -> Slots<Fielddef> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.weaponinfo_fields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.weaponinfo_fields) / Fielddef.stride
    return Slots(views: base, count: count, stride: Fielddef.stride)
}

private func makeProjectileinfo_fields() -> Slots<Fielddef> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Ded.projectileinfo_fields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Ded.projectileinfo_fields) / Fielddef.stride
    return Slots(views: base, count: count, stride: Fielddef.stride)
}

private func makeWeaponinfo_struct() -> Structdef {
    Structdef(withUnsafeMutablePointer(to: &CJKAMP_Ded.weaponinfo_struct) { UnsafeMutableRawPointer($0) })
}

private func makeProjectileinfo_struct() -> Structdef {
    Structdef(withUnsafeMutablePointer(to: &CJKAMP_Ded.projectileinfo_struct) { UnsafeMutableRawPointer($0) })
}

private func makeIdentityMatrix() -> JKAMP.MdxaBone {
    JKAMP.MdxaBone(withUnsafeMutablePointer(to: &CJKAMP_Ded.identityMatrix) { UnsafeMutableRawPointer($0) })
}

private func makeIdentityMatrix_G2API_GetBoltMatrix() -> JKAMP.MdxaBone {
    JKAMP.MdxaBone(withUnsafeMutablePointer(to: &CJKAMP_Ded.identityMatrix_G2API_GetBoltMatrix) { UnsafeMutableRawPointer($0) })
}

private func makeId_G2_Set_Bone_Angles_Rag() -> JKAMP.MdxaBone {
    JKAMP.MdxaBone(withUnsafeMutablePointer(to: &CJKAMP_Ded.id_G2_Set_Bone_Angles_Rag) { UnsafeMutableRawPointer($0) })
}

private func makeId_G2_Set_Bone_Angles_IK() -> JKAMP.MdxaBone {
    JKAMP.MdxaBone(withUnsafeMutablePointer(to: &CJKAMP_Ded.id_G2_Set_Bone_Angles_IK) { UnsafeMutableRawPointer($0) })
}
