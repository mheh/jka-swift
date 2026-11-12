@preconcurrency internal import CJKAMP_UI
import JKAMP
import JKAShared

/// Raven's server filter table of `ui_main.c`, over the C storage of `Sources/CJKAMP_UI/ui_tables.c`.
/// Source: oracle/codemp/ui/ui_main.c:896
public nonisolated(unsafe) let serverFilters: Slots<ServerFilter> = makeServerFilters()

/// Raven's server status cvar table of `ui_main.c`, with his NULL row last, over the C storage of `Sources/CJKAMP_UI/ui_tables.c`.
/// Source: oracle/codemp/ui/ui_main.c:7883
public nonisolated(unsafe) let serverStatusCvars: Slots<ServerStatusCvar> = makeServerStatusCvars()

/// Raven's key binding table of `ui_shared.c`, over the C storage of `Sources/CJKAMP_UI/ui_tables.c`.
/// Source: oracle/codemp/ui/ui_shared.c:5190
public nonisolated(unsafe) let g_bindings: Slots<Bind> = makeBindings()

/// Raven's item flag table of `ui_shared.c`, with his NULL row last, over the C storage of `Sources/CJKAMP_UI/ui_tables.c`.
/// Source: oracle/codemp/ui/ui_shared.c:157
public nonisolated(unsafe) let itemFlags: Slots<ItemFlagsDef> = makeItemFlags()

// MARK: - The bind over the C array

/// The compiler crashes if a global initializer takes the address inline, so the table binds in a function.
private func makeServerFilters() -> Slots<ServerFilter> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_UI.serverFilters) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_UI.serverFilters) / ServerFilter.stride
    return Slots(views: base, count: count, stride: ServerFilter.stride)
}

private func makeServerStatusCvars() -> Slots<ServerStatusCvar> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_UI.serverStatusCvars) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_UI.serverStatusCvars) / ServerStatusCvar.stride
    return Slots(views: base, count: count, stride: ServerStatusCvar.stride)
}

private func makeBindings() -> Slots<Bind> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_UI.g_bindings) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_UI.g_bindings) / Bind.stride
    return Slots(views: base, count: count, stride: Bind.stride)
}

private func makeItemFlags() -> Slots<ItemFlagsDef> {
    let base = withUnsafeMutablePointer(to: &CJKAMP_UI.itemFlags) { UnsafeMutableRawPointer($0) }
    let count = MemoryLayout.size(ofValue: CJKAMP_UI.itemFlags) / ItemFlagsDef.stride
    return Slots(views: base, count: count, stride: ItemFlagsDef.stride)
}
