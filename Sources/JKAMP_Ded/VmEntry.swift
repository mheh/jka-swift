internal import CJKAMP_Ded
import JKAShared

/// The C type of the module's `vmMain` as the module defines it, the command and twelve words.
/// Source: oracle/codemp/game/g_main.c:515
typealias VmMainWords = @convention(c) (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> Int

extension Vm {
    /// This is Raven's `vm->entryPoint( callnum, args[0], ..., args[15] )` of `VM_Call`, a call into the `vmMain` of the loaded module.
    /// A NULL `entryPoint` traps with the field's name, as Raven's call through the pointer would crash.
    // AI: Raven called through the variadic pointer with 16 words. The call takes the fixed type of the export, 12 words that each widen to the word of the export.
    // Port-note: A variadic call into the fixed vmMain is undefined off x86, and the export reads 12 words, so the last 4 words go nowhere.
    // AI: Raven's pointer returned an `int`. The export returns a pointer-wide word, and the call returns the whole word, the address of a text for GAME_CLIENT_CONNECT.
    @discardableResult
    public func runEntryPoint(_ callNum: Int32, _ args: [Int32]) -> Int {
        precondition(self.raw.pointee.entryPoint != nil, "entryPoint is NULL")
        let vmMain = unsafeBitCast(self.raw.pointee.entryPoint, to: VmMainWords.self)
        let r = vmMain(
            Int(callNum),
            Int(args[0]),
            Int(args[1]),
            Int(args[2]),
            Int(args[3]),
            Int(args[4]),
            Int(args[5]),
            Int(args[6]),
            Int(args[7]),
            Int(args[8]),
            Int(args[9]),
            Int(args[10]),
            Int(args[11])
        )
        return r
    }

    /// Raven's `&vm->entryPoint` of `VM_Create`, the slot that Sys_LoadDll stores the module's vmMain through.
    /// Source: oracle/codemp/qcommon/vm.cpp:518
    // AI: Raven hands the address of the field. The view target gives that address raw, the form of `slotAddress` of NodeSlots.swift, so the logic target does no pointer arithmetic.
    public var entryPointAddress: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(self.raw.pointer(to: \.entryPoint)!)
    }
}

/// Raven's `LoadLibrary`, `GetProcAddress`, and `dllEntry( systemcalls )` of Sys_LoadDll, which the shell installs at its entry.
/// It loads the library at the path, stores the module's vmMain through the slot, and returns the library handle or nil.
/// Source: oracle/codemp/null/win_main.cpp:784
// AI: Raven calls the Win32 loader in Sys_LoadDll. The logic target cannot import CJKAHost, so the shell installs a closure over `jka_load_dll`, the form of `sharedChannel`.
public nonisolated(unsafe) var LoadLibrary: ((String, UnsafeMutableRawPointer) -> OpaquePointer?)? = nil

/// The tail of the module library name of Sys_LoadDll, the arch and the library extension of the build, so `jampgame` loads `jampgamearm64.dylib` on Apple arm64.
/// Source: oracle/codemp/null/win_main.cpp:795
// AI: Raven writes the literal tail `x86.dll`. The tail takes the arch and the extension of the platform that builds, the names of tools/host-referee.sh.
#if arch(arm64)
private let DLL_ARCH = "arm64"
#elseif arch(x86_64)
private let DLL_ARCH = "x86_64"
#else
private let DLL_ARCH = "x86"
#endif
#if os(macOS)
public let DLL_SUFFIX = DLL_ARCH + ".dylib"
#elseif os(Windows)
public let DLL_SUFFIX = DLL_ARCH + ".dll"
#else
public let DLL_SUFFIX = DLL_ARCH + ".so"
#endif
