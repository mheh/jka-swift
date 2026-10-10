#if canImport(Glibc)
import Glibc
#else
import Darwin
#endif
import CJKASyscall
import Foundation

// This loads a jampgame library in its own process and sends GAME_GETITEMINDEXBYTAG through its vmMain.
// The command needs no engine behind the syscalls, so the run proves the load and the dispatch.
// The smoke test runs this executable, so the test binary never loads a second copy of the module's classes.
// Run `swift run jampsmoke <path-to-library>` for a manual smoke run.

/// The C shape of the module's `dllEntry`, as `@_cdecl` exports it.
private typealias DllEntryFn = @convention(c) (OpaquePointer) -> Void

/// The C shape of the module's `vmMain`, twelve words after the command.
private typealias VmMainFn = @convention(c) (
    Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int
) -> Int

/// This reads the dynamic loader's message for the failure that just happened.
private func lastDlError() -> String {
    guard let message = dlerror() else { return "dlerror reported no message." }
    return String(cString: message)
}

/// This ends the run with a failure, after a message to stderr.
private func fail(_ reason: String) -> Never {
    FileHandle.standardError.write(Data(reason.utf8))
    exit(1)
}

guard CommandLine.arguments.count > 1 else {
    fail("jampsmoke needs the library path as argument 1.\n")
}
let libraryPath = CommandLine.arguments[1]

guard let handle = dlopen(libraryPath, RTLD_NOW | RTLD_LOCAL) else {
    fail("dlopen of \(libraryPath) failed: \(lastDlError())\n")
}
// The handle stays open. The Swift runtime keeps a loaded library's metadata, so an unload is unsafe.

guard let entrySymbol = dlsym(handle, "dllEntry") else {
    fail("dlsym of dllEntry failed: \(lastDlError())\n")
}
guard let mainSymbol = dlsym(handle, "vmMain") else {
    fail("dlsym of vmMain failed: \(lastDlError())\n")
}
private let moduleDllEntry = unsafeBitCast(entrySymbol, to: DllEntryFn.self)
private let moduleVmMain = unsafeBitCast(mainSymbol, to: VmMainFn.self)

jka_recorder_reset()
moduleDllEntry(jka_recorder_entry())

// 39 is GAME_GETITEMINDEXBYTAG. This loader links no Swift module of the game, so it cannot spell the constant's name.
// The tag is 1, HI_SEEKER, and the type is 6, IT_HOLDABLE.
// The answer is 4, the row of item_seeker in bg_itemlist.
let answer = moduleVmMain(39, 1, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
let command = jka_recorded_command()
let wordAddress = jka_recorded_word()

print("answer \(answer)")
print("command \(command)")
if wordAddress == 0 {
    print("text")
} else {
    let word = UnsafePointer<CChar>(bitPattern: Int(wordAddress))!
    let text = String(cString: word).replacingOccurrences(of: "\n", with: "\\n")
    print("text \(text)")
}

exit(0)
