#if canImport(Glibc)
import Glibc
#else
import Darwin
#endif
import CJKASyscall
import Foundation

// This loads a module library in its own process and sends one command through its vmMain.
// The caller picks a command that needs no engine behind the syscalls, so the run proves the load and the dispatch.
// The smoke tests run this executable, so the test binary never loads a second copy of the module's classes.
// Run `swift run jampsmoke <path-to-library> <command> <expected answer> [words]` for a manual smoke run.
// For the game, `39 4 1 6` sends GAME_GETITEMINDEXBYTAG with tag 1, HI_SEEKER, and type 6, IT_HOLDABLE, and expects row 4, item_seeker.
// For the cgame, `5 -1` sends CG_LAST_ATTACKER, and a fresh world has no attacker.
// For the ui, `0 7` sends UI_GETAPIVERSION, and the answer is Raven's UI_API_VERSION.

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

guard CommandLine.arguments.count > 3 else {
    fail("jampsmoke needs the library path, the command number, and the expected answer.\n")
}
let libraryPath = CommandLine.arguments[1]
// This loader links no Swift module of a game, so the caller spells the command as its number.
guard let commandNumber = Int(CommandLine.arguments[2]), let expected = Int(CommandLine.arguments[3]) else {
    fail("jampsmoke needs the command number and the expected answer as integers.\n")
}
// The words after the answer are the command's arguments, and a missing word is 0.
var words = CommandLine.arguments.dropFirst(4).compactMap { Int($0) }
guard words.count == CommandLine.arguments.count - 4, words.count <= 12 else {
    fail("jampsmoke takes at most 12 integer words after the expected answer.\n")
}
words += Array(repeating: 0, count: 12 - words.count)

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

let answer = moduleVmMain(
    commandNumber,
    words[0],
    words[1],
    words[2],
    words[3],
    words[4],
    words[5],
    words[6],
    words[7],
    words[8],
    words[9],
    words[10],
    words[11]
)
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

guard answer == expected else {
    fail("vmMain answered \(answer) to command \(commandNumber), and the caller expected \(expected).\n")
}
exit(0)
