import JKAShared
import JKAMP

extension Syscall {
    /// This packs typed words for one ui import and sends it through the transport.
    /// The variadic list is the trap's arguments in Raven's order.
    @discardableResult
    public static func call(_ command: uiImport_t, _ words: any SyscallWord...) -> Int {
        self.call(Int(command), words.map(\.word))
    }
}

/// This registers a shader with no mipmaps, and a name that starts with `*` names the cvar that holds the shader name.
/// An empty cvar registers the name as Raven wrote it, with its `*`.
/// Source: oracle/codemp/ui/ui_syscalls.c:151
@discardableResult
public func trap_R_RegisterShaderNoMip(_ name: String) -> JKAShared.qhandle_t {
    if name.hasPrefix("*") {
        let buf = trap_Cvar_VariableStringBuffer(String(name.dropFirst()), 1024)
        if !buf.isEmpty {
            let word = withCString(buf) { buf in
                Syscall.call(UI_R_REGISTERSHADERNOMIP, buf)
            }
            return JKAShared.qhandle_t(truncatingIfNeeded: word)
        }
    }
    let word = withCString(name) { name in
        Syscall.call(UI_R_REGISTERSHADERNOMIP, name)
    }
    return JKAShared.qhandle_t(truncatingIfNeeded: word)
}
