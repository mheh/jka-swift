@preconcurrency internal import CJKAMP_CGame
import JKAMP
import JKAShared

/// Raven's spawn key field table of the cgame, over the C storage of `Sources/CJKAMP_CGame/cg_tables.c`.
/// The offset of a row is a byte offset into `cgSpawnEnt_t`, Raven's `CGFOFS`.
/// Source: oracle/codemp/cgame/cg_main.c:3393
public nonisolated(unsafe) let cg_spawnFields: Slots<BgField> = makeSpawnFields()

/// Raven's key binding table of `ui_shared.c`, over the C storage of `Sources/CJKAMP_CGame/cg_tables.c`.
/// Source: oracle/codemp/ui/ui_shared.c:5190
public nonisolated(unsafe) let g_bindings: Slots<Bind> = makeBindings()

/// Raven's item flag table of `ui_shared.c`, with his NULL row last, over the C storage of `Sources/CJKAMP_CGame/cg_tables.c`.
/// Source: oracle/codemp/ui/ui_shared.c:157
public nonisolated(unsafe) let itemFlags: Slots<ItemFlagsDef> = makeItemFlags()

// MARK: - The bind over the C array

/// The compiler crashes if a global initializer takes the address inline, so the table binds in a function.
private func makeSpawnFields() -> Slots<BgField> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_CGame.cg_spawnFields) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_CGame.cg_spawnFields) / BgField.stride
    return Slots(views: base, count: count, stride: BgField.stride)
}

private func makeBindings() -> Slots<Bind> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_CGame.g_bindings) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_CGame.g_bindings) / Bind.stride
    return Slots(views: base, count: count, stride: Bind.stride)
}

private func makeItemFlags() -> Slots<ItemFlagsDef> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_CGame.itemFlags) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_CGame.itemFlags) / ItemFlagsDef.stride
    return Slots(views: base, count: count, stride: ItemFlagsDef.stride)
}
