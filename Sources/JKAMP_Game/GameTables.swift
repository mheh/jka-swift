@preconcurrency internal import CJKAMP_Game
import JKAShared

/// Raven's ICARUS set name table, over the C storage of `Sources/CJKAMP_Game/g_tables.c`.
/// Source: oracle/codemp/game/g_ICARUScb.c:52
public nonisolated(unsafe) let setTable: Slots<StringIDTable> = makeSetTable()

/// Raven's NPC team name table, over the C storage of `Sources/CJKAMP_Game/g_tables.c`.
/// Source: oracle/codemp/game/NPC_stats.c:14
public nonisolated(unsafe) let TeamTable: Slots<StringIDTable> = makeTeamTable()

/// Raven's NPC class name table, over the C storage of `Sources/CJKAMP_Game/g_tables.c`.
/// Source: oracle/codemp/game/NPC_stats.c:24
public nonisolated(unsafe) let ClassTable: Slots<StringIDTable> = makeClassTable()

/// Raven's behavior state name table, over the C storage of `Sources/CJKAMP_Game/g_tables.c`.
/// Source: oracle/codemp/game/NPC_stats.c:88
public nonisolated(unsafe) let BSTable: Slots<StringIDTable> = makeBSTable()

/// Raven's behavior script name table, over the C storage of `Sources/CJKAMP_Game/g_tables.c`.
/// Source: oracle/codemp/game/NPC_stats.c:106
public nonisolated(unsafe) let BSETTable: Slots<StringIDTable> = makeBSETTable()

/// Raven's spawn key field table, over the C storage of `Sources/CJKAMP_Game/g_tables.c`.
/// The offset of a row is a byte offset into `gentity_t`, Raven's `FOFS`.
/// Source: oracle/codemp/game/g_spawn.c:54
public nonisolated(unsafe) let fields: Slots<BgField> = makeFields()

// MARK: - The bind over each C array

/// The compiler crashes if a global initializer takes the address inline, so each table binds in a function.
private func makeSetTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Game.setTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Game.setTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeTeamTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Game.TeamTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Game.TeamTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeClassTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Game.ClassTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Game.ClassTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeBSTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Game.BSTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Game.BSTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeBSETTable() -> Slots<StringIDTable> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Game.BSETTable) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Game.BSETTable) / StringIDTable.stride
    return Slots(views: base, count: count, stride: StringIDTable.stride)
}

private func makeFields() -> Slots<BgField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_Game.fields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_Game.fields) / BgField.stride
    return Slots(views: base, count: count, stride: BgField.stride)
}
