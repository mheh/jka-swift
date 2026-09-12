import Foundation
import Testing
import CJKASyscall
import JKAMP_Game

/// A class in this test bundle, so `Bundle(for:)` can find the bundle's directory.
private final class Anchor {}

/// The C shape of the module's `dllEntry`, as `@_cdecl` exports it.
private typealias DllEntryFn = @convention(c) (OpaquePointer) -> Void

/// The C shape of the module's `vmMain`, twelve words after the command.
private typealias VmMainFn = @convention(c) (
    Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int
) -> Int

/// This test drives the built `jampgame` library from outside, the way the engine does.
/// It installs the C recorder as the engine, so `Syscall.transport` inside the test process stays untouched.
@Suite(.serialized)
struct JampgameSmokeSuite {
    @Test("the loaded module answers GAME_INIT with the init line through G_PRINT")
    func gameInitPrintsTheInitLine() throws {
        let library = try #require(Self.builtLibraryPath())

        guard let handle = dlopen(library, RTLD_NOW | RTLD_LOCAL) else {
            Issue.record("dlopen of \(library) failed: \(Self.lastError())")
            return
        }
        // The handle stays open. The Swift runtime keeps the library's metadata after a load, so an unload leaves it unsafe to use.

        guard let entrySymbol = dlsym(handle, "dllEntry") else {
            Issue.record("dlsym of dllEntry failed: \(Self.lastError())")
            return
        }
        guard let mainSymbol = dlsym(handle, "vmMain") else {
            Issue.record("dlsym of vmMain failed: \(Self.lastError())")
            return
        }
        let moduleDllEntry = unsafeBitCast(entrySymbol, to: DllEntryFn.self)
        let moduleVmMain = unsafeBitCast(mainSymbol, to: VmMainFn.self)

        jka_recorder_reset()
        moduleDllEntry(jka_recorder_entry())

        let answer = moduleVmMain(
            Int(GAME_INIT),
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        )

        #expect(answer == 0)
        #expect(jka_recorded_command() == Int(G_PRINT))

        let text = try #require(UnsafePointer<CChar>(bitPattern: Int(jka_recorded_word())))
        #expect(String(cString: text) == "jka-swift jampgame init\n")
    }

    /// The dynamic product's file name on this platform, as the linker writes it.
    private static var libraryName: String {
        #if os(Linux)
        return "libjampgame.so"
        #elseif os(Windows)
        return "jampgame.dll"
        #else
        return "libjampgame.dylib"
        #endif
    }

    /// `swift test` builds the dynamic product in the same configuration directory as the test code, so we walk up from the test bundle.
    /// On macOS the tests run inside the `xctest` host, so the main bundle is the wrong one, and the bundle of a class in this file is the right one.
    /// The walk stops at the first ancestor that holds the library, which keeps a second scratch directory or a release copy out of the answer.
    private static func builtLibraryPath() -> String? {
        var directory = Bundle(for: Anchor.self).bundleURL.standardizedFileURL
        while directory.path != "/" {
            let candidate = directory.appendingPathComponent(Self.libraryName)
            if FileManager.default.fileExists(atPath: candidate.path) {
                return candidate.path
            }
            directory = directory.deletingLastPathComponent()
        }
        return nil
    }

    /// This reads the dynamic loader's message for the failure that just happened.
    private static func lastError() -> String {
        guard let message = dlerror() else { return "dlerror reported no message." }
        return String(cString: message)
    }
}
