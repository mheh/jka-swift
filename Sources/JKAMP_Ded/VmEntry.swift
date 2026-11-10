internal import CJKAMP_Ded
import JKAShared

/// The C type of the module's `vmMain` as the module defines it, the command and twelve words.
/// Source: oracle/codemp/game/g_main.c:515
typealias VmMainWords = @convention(c) (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> Int

extension Vm {
    /// This is Raven's `vm->entryPoint( callnum, args[0], ..., args[15] )` of `VM_Call`, a call into the `vmMain` of the loaded module.
    /// A NULL `entryPoint` traps with the field's name, as Raven's call through the pointer would crash.
    // AI: Raven called through the variadic pointer with 16 `int` words. The call takes the fixed type of the export, 12 pointer-wide words, so an address stays whole.
    // Port-note: A variadic call into the fixed vmMain is undefined off x86, and the export reads 12 words, so the last 4 words go nowhere.
    // AI: Raven's pointer returned an `int`. The export returns a pointer-wide word, and the call returns the whole word, the address of a text for GAME_CLIENT_CONNECT.
    @discardableResult
    public func runEntryPoint(_ callNum: Int32, _ args: [Int]) -> Int {
        precondition(self.raw.pointee.entryPoint != nil, "entryPoint is NULL")
        let vmMain = unsafeBitCast(self.raw.pointee.entryPoint, to: VmMainWords.self)
        let r = vmMain(
            Int(callNum),
            args[0],
            args[1],
            args[2],
            args[3],
            args[4],
            args[5],
            args[6],
            args[7],
            args[8],
            args[9],
            args[10],
            args[11]
        )
        return r
    }

    /// Raven's `&vm->entryPoint` of `VM_Create`, the slot that Sys_LoadDll stores the module's vmMain through.
    /// Source: oracle/codemp/qcommon/vm.cpp:518
    // AI: Raven hands the address of the field. The view target gives that address raw, the form of `slotAddress` of NodeSlots.swift, so the logic target does no pointer arithmetic.
    public var entryPointAddress: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(self.raw.pointer(to: \.entryPoint)!)
    }

    /// Raven's `(void *)((int)mem - (int)vm->dataBase)` of `VM_Shifted_Alloc`, the address of a block relative to the data of the module.
    /// A NULL `dataBase`, the form of a dll module, gives the address of the block itself.
    /// Source: oracle/codemp/qcommon/vm.cpp:716
    // Port-note: Raven's `int` casts drop the high half of an address on a 64-bit host, so the difference takes the full width of the address.
    public func shifted(_ mem: OpaquePointer?) -> OpaquePointer? {
        OpaquePointer(bitPattern: Int(bitPattern: UnsafeRawPointer(mem)) &- Int(bitPattern: UnsafeRawPointer(self.raw.pointee.dataBase)))
    }

    /// Raven's `(void *)((int)vm->dataBase + (int)ptr)` of `VM_Shifted_Free`, the block of an address relative to the data of the module.
    /// Source: oracle/codemp/qcommon/vm.cpp:730
    // Port-note: Raven's `int` casts drop the high half of an address on a 64-bit host, so the sum takes the full width of the address.
    public func unshifted(_ ptr: OpaquePointer?) -> OpaquePointer? {
        OpaquePointer(bitPattern: Int(bitPattern: UnsafeRawPointer(self.raw.pointee.dataBase)) &+ Int(bitPattern: UnsafeRawPointer(ptr)))
    }

    /// Raven's `(void *)(vm->dataBase + word)` of VM_ArgPtr, BotVMShift, and VM_ExplicitArgPtr, the address of a word of the module.
    /// A NULL `dataBase`, the form of a dll module, gives the word itself as the address, and a zero sum gives nil.
    /// Source: oracle/codemp/qcommon/vm.cpp:649
    // Port-note: Raven adds an `int` word, which holds an address only on a 32-bit build, so the sum takes the full width of the address.
    public func address(at word: some BinaryInteger) -> UnsafeMutableRawPointer? {
        UnsafeMutableRawPointer(bitPattern: Int(bitPattern: UnsafeRawPointer(self.raw.pointee.dataBase)) &+ Int(word))
    }

    /// Raven's `(char *)VM_ExplicitArgPtr( vm, word )`, the text at the address of a word of the module, and nil for a zero sum.
    /// Source: oracle/codemp/qcommon/vm.cpp:753
    // Port-note: Raven adds an `int` word, which holds an address only on a 32-bit build, so the sum takes the full width of the address.
    public func address(at word: some BinaryInteger) -> String? {
        (self.address(at: word) as UnsafeMutableRawPointer?).map { cString(at: $0) }
    }
}

/// Raven's `vec3_t` arguments of `VM_Call` in gameCallbacks.cpp, the address of each vector as a word for the life of the body.
/// The module reads the three floats at each word and writes none of them.
/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:8
// AI: Raven passes the address of the caller's vector. The word holds the address of a copy that lives for the body, the `withUnsafePointer` form of the generated trap thunks.
public func withVectorWords<Result>(_ vectors: JKAShared.vec3_t..., body: ([Int]) -> Result) -> Result {
    vectors.withUnsafeBufferPointer { buffer in
        body(buffer.indices.map { Int(bitPattern: buffer.baseAddress! + $0) })
    }
}

/// Raven's `char *` argument of `VM_Call` in RoffSystem.cpp, the address of the text as a word for the life of the body.
/// The module reads the text at the word and writes none of it.
/// Source: oracle/codemp/qcommon/RoffSystem.cpp:957
// AI: Raven passes the address of the caller's buffer. The word holds the address of the buffer for the body, the `withUnsafePointer` form of the generated trap thunks.
public func withTextWord<Result>(_ text: CharBuf, body: (Int) -> Result) -> Result {
    text.withUnsafeRawPointer { buffer in
        body(Int(bitPattern: buffer))
    }
}

/// Raven's `SV_GameSystemCalls`, which the shell installs at its entry, for the thunk that VM_Create stores in `systemCall`.
/// Source: oracle/codemp/server/sv_game.cpp:458
// AI: Raven passes the C function SV_GameSystemCalls to VM_Create. The view target cannot see the logic target, so the shell installs a closure over it, the form of `LoadLibrary`.
// AI: Raven's function returns an `int`. The closure returns the pointer-wide word, the form of VM_Call, so the address of TRAP_STRNCPY stays whole.
public nonisolated(unsafe) var GameSystemCalls: ((Slots<Int32>) -> Int)? = nil

/// The C function over `GameSystemCalls`, the `int (*systemCalls)( int * )` that SV_InitGameProgs hands to VM_Create.
/// It reads the 16 pointer-wide words that VM_DllSyscall of jka_host.c gathers from the module.
/// Source: oracle/codemp/server/sv_game.cpp:1750
// AI: Raven's SV_GameSystemCalls is a C function over `int` words. The thunk gives the words to the Swift body as `Slots(syscallWords:)`.
// AI: The C field `systemCall` of vm_t returns an `int`, so the thunk gives the low half. The shell hands VM_DllSyscall the whole word.
public func SV_GameSystemCallThunk(_ parms: OpaquePointer?) -> Int32 {
    Int32(truncatingIfNeeded: GameSystemCalls!(Slots(syscallWords: UnsafeMutableRawPointer(parms!), count: 16)))
}

extension VmHeader {
    /// Raven's cast `(byte *)header` over the QVM image that FS_ReadFile gave, `count` bytes from the header on.
    /// Source: oracle/codemp/qcommon/vm.cpp:564
    // AI: Raven casts the header pointer to `byte *` and adds an offset. The Slots gives the bytes of the image to the body with no pointer type.
    public func bytes(count: some BinaryInteger) -> Slots<JKAShared.byte> {
        Slots(scalars: UnsafeMutableRawPointer(self.handle), count: Int(count))
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
