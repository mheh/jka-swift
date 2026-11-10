import Foundation
import Testing

/// A class in this test bundle, so `Bundle(for:)` can find the bundle's directory.
private final class Anchor {}

/// This test runs the built `jampded` executable in its own process.
/// The shell runs Raven's main in an empty directory, so the file system finds no game data.
/// Raven then stops with its own fatal error for the missing `mpdefault.cfg`, at `files_pc.cpp:3022`.
/// So the test proves the product builds, starts, and runs the logic target through FS_Startup.
@Suite(.serialized)
struct JampdedSmokeSuite {
    @Test("jampded runs Raven's main to the fatal error for missing game data")
    func runsToTheMissingGameDataError() throws {
        let server = try #require(Self.builtArtifactPath(named: Self.serverName))

        let process = Process()
        process.executableURL = URL(fileURLWithPath: server)
        let emptyDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: emptyDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: emptyDirectory) }
        process.currentDirectoryURL = emptyDirectory

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        try process.run()
        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()

        // Raven's error names the file, so a stop for any other reason fails here.
        let output = (String(data: stdoutData, encoding: .utf8) ?? "") + (String(data: stderrData, encoding: .utf8) ?? "")
        #expect(process.terminationStatus != 0)
        #expect(output.contains("Couldn't load mpdefault.cfg"))
        #expect(!output.contains("TODO: Port "))
    }

    /// The executable's file name on this platform, as the linker writes it.
    private static var serverName: String {
        #if os(Windows)
        return "jampded.exe"
        #else
        return "jampded"
        #endif
    }

    /// `swift test` builds the executable in the same configuration directory as the test code.
    /// We walk up from the test bundle to find it.
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
