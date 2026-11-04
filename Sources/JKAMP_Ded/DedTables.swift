@preconcurrency internal import CJKAMP_Ded
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

// MARK: - The bind over each C array

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
