import Foundation
import Testing
import CJKAMP

/// A class in this test bundle, so `Bundle(for:)` can find the bundle's directory.
private final class Anchor {}

/// This test runs the `jampsmoke` loader in its own process, the way the engine loads a module.
/// The loader does the dlopen, so the built `ui` library never loads into this test process.
/// The loader sends `UI_GETAPIVERSION`, so the test proves the load and the dispatch.
/// It does not send `UI_INIT`, because `_UI_Init` needs the engine behind the syscalls.
@Suite(.serialized)
struct UiSmokeSuite {
    @Test("the loaded module answers UI_GETAPIVERSION with version 7")
    func apiVersionAnswersSeven() throws {
        let library = try #require(Self.builtArtifactPath(named: Self.libraryName))
        let loader = try #require(Self.builtArtifactPath(named: Self.loaderName))

        let process = Process()
        process.executableURL = URL(fileURLWithPath: loader)
        // The loader sends UI_GETAPIVERSION after dllEntry, and Raven's arm answers UI_API_VERSION.
        process.arguments = [
            library,
            String(UI_GETAPIVERSION.rawValue),
            "7",
        ]

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

        // The arm returns the version and makes no syscall.
        // The default arm answers -1, so the answer 7 proves the UI_GETAPIVERSION arm.
        #expect(UI_GETAPIVERSION.rawValue == 0)
        #expect(UI_API_VERSION == 7)
        #expect(lines == [
            "answer 7",
            "command 0",
            "text",
        ])
    }

    /// The dynamic product's file name on this platform, as the linker writes it.
    private static var libraryName: String {
        #if os(Linux)
        return "libui.so"
        #elseif os(Windows)
        return "ui.dll"
        #else
        return "libui.dylib"
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
