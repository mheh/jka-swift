import Foundation
import Testing

/// A class in this test bundle, so `Bundle(for:)` can find the bundle's directory.
private final class Anchor {}

/// This test runs the built `jampded` executable in its own process.
/// The shell prints the version line of Com_Init and exits 0, so the test proves the product builds and starts.
@Suite(.serialized)
struct JampdedSmokeSuite {
    @Test("jampded prints Raven's version line and exits 0")
    func printsTheVersionLine() throws {
        let server = try #require(Self.builtArtifactPath(named: Self.serverName))

        let process = Process()
        process.executableURL = URL(fileURLWithPath: server)

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
            Issue.record("jampded exited with status \(process.terminationStatus): \(stderrText)")
            return
        }

        let stdoutText = String(data: stdoutData, encoding: .utf8) ?? ""
        let lines = stdoutText.split(separator: "\n", omittingEmptySubsequences: true).map(String.init)

        // The line is Q3_VERSION and CPUSTRING, from oracle/codemp/qcommon/common.cpp:1219.
        #expect(lines == ["(internal)JAmp: v1.0.1.0 \(Self.cpuString)"])
    }

    /// The CPUSTRING of this platform, as the shell picks it.
    private static var cpuString: String {
        #if os(macOS)
        return "MacOSX-other"
        #elseif os(Linux)
        return "linux-other"
        #else
        return "win-x86"
        #endif
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
