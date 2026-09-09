import Foundation
import Testing
import CJKASyscall
import JKAMP_Game

/// The C shape of the module's `dllEntry`, as `@_cdecl` exports it.
private typealias DllEntryFn = @convention(c) (OpaquePointer) -> Void

/// The C shape of the module's `vmMain`, twelve words after the command.
private typealias VmMainFn = @convention(c) (
    Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int
) -> Int

/// This test drives the built `libjampgame.dylib` from outside, the way the engine does.
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
        defer { dlclose(handle) }

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
            Int(gameExport_t.GAME_INIT.rawValue),
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        )

        #expect(answer == 0)
        #expect(jka_recorded_command() == Int(gameImport_t.G_PRINT.rawValue))

        let text = try #require(UnsafePointer<CChar>(bitPattern: Int(jka_recorded_word())))
        #expect(String(cString: text) == "jka-swift jampgame init\n")
    }

    /// `swift test` builds the dynamic product beside the test bundle, so we walk up from the test binary.
    /// The walk starts at this source file and stops at the first ancestor that holds a `.build` directory.
    private static func builtLibraryPath() -> String? {
        var directory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().standardizedFileURL
        while directory.path != "/" {
            let build = directory.appendingPathComponent(".build")
            if FileManager.default.fileExists(atPath: build.path), let library = Self.libraryInBuild(build) {
                return library
            }
            directory = directory.deletingLastPathComponent()
        }
        return nil
    }

    /// This picks the most recently written `libjampgame.dylib` under `.build/<triple>/<config>/`.
    /// A release gate leaves a second copy, and both hold the same module, so the newest one answers.
    private static func libraryInBuild(_ build: URL) -> String? {
        let manager = FileManager.default
        guard let triples = try? manager.contentsOfDirectory(at: build, includingPropertiesForKeys: nil) else { return nil }

        var newest: (path: String, written: Date)?
        for triple in triples {
            guard let configurations = try? manager.contentsOfDirectory(at: triple, includingPropertiesForKeys: nil) else { continue }
            for configuration in configurations {
                let candidate = configuration.appendingPathComponent("libjampgame.dylib")
                let values = try? candidate.resourceValues(forKeys: [.contentModificationDateKey])
                guard let written = values?.contentModificationDate else { continue }
                if newest == nil || written > newest!.written {
                    newest = (candidate.path, written)
                }
            }
        }
        return newest?.path
    }

    /// This reads the dynamic loader's message for the failure that just happened.
    private static func lastError() -> String {
        guard let message = dlerror() else { return "dlerror reported no message." }
        return String(cString: message)
    }
}
