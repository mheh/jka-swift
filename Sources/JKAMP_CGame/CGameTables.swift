@preconcurrency internal import CJKAMP_CGame
import JKAMP
import JKAShared

/// Raven's spawn key field table of the cgame, over the C storage of `Sources/CJKAMP_CGame/cg_tables.c`.
/// The offset of a row is a byte offset into `cgSpawnEnt_t`, Raven's `CGFOFS`.
/// Source: oracle/codemp/cgame/cg_main.c:3393
public nonisolated(unsafe) let cg_spawnFields: Slots<BgField> = makeSpawnFields()

// MARK: - The bind over the C array

/// The compiler crashes if a global initializer takes the address inline, so the table binds in a function.
private func makeSpawnFields() -> Slots<BgField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_CGame.cg_spawnFields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_CGame.cg_spawnFields) / BgField.stride
    return Slots(views: base, count: count, stride: BgField.stride)
}
