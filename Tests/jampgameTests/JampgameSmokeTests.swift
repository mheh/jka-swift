import Foundation
import Testing
import CJKAMP_Game

/// A class in this test bundle, so `Bundle(for:)` can find the bundle's directory.
private final class Anchor {}

/// This test runs the `jampsmoke` loader in its own process, the way the engine loads a module.
/// The loader does the dlopen, so the built `jampgame` library never loads into this test process.
@Suite(.serialized)
struct JampgameSmokeSuite {
    @Test("the loaded module answers GAME_INIT with the init line through G_PRINT")
    func gameInitPrintsTheInitLine() throws {
        let library = try #require(Self.builtArtifactPath(named: Self.libraryName))
        let loader = try #require(Self.builtArtifactPath(named: Self.loaderName))

        let process = Process()
        process.executableURL = URL(fileURLWithPath: loader)
        process.arguments = [library]

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        try process.run()
        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()

        let stderrText = String(data: stderrData, encoding: .utf8) ?? ""
        guard process.terminationStatus == 0 else {
            Issue.record("jampsmoke exited with status \(process.terminationStatus): \(stderrText)")
            return
        }

        let stdoutText = String(data: stdoutData, encoding: .utf8) ?? ""
        let lines = stdoutText.split(separator: "\n", omittingEmptySubsequences: true).map(String.init)

        #expect(lines == [
            "answer 0",
            "command \(G_PRINT.rawValue)",
            "text jka-swift jampgame init\\n",
        ])
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

    /// The loader executable's file name on this platform, as the linker writes it.
    private static var loaderName: String {
        #if os(Windows)
        return "jampsmoke.exe"
        #else
        return "jampsmoke"
        #endif
    }

    /// `swift test` builds the product and the loader in the same configuration directory as the test code.
    /// We walk up from the test bundle to find them.
    /// On macOS the tests run inside the `xctest` host, so the main bundle is the wrong one, and the bundle of a class in this file is the right one.
    /// The walk stops at the first ancestor that holds the named file, which keeps a second scratch directory or a release copy out of the answer.
    private static func builtArtifactPath(named name: String) -> String? {
        var directory = Bundle(for: Anchor.self).bundleURL.standardizedFileURL
        while directory.path != "/" {
            let candidate = directory.appendingPathComponent(name)
            if FileManager.default.fileExists(atPath: candidate.path) {
                return candidate.path
            }
            directory = directory.deletingLastPathComponent()
        }
        return nil
    }
}
