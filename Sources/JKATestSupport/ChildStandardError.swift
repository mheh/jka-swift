import Foundation

/// This type carries the standard error of an exit test's child process to the parent through a file.
/// Swift Testing returns no result for an exit test that fails, so an observed `standardErrorContent` is lost when a trap message matters.
/// The child sends its standard error to a file at a path the parent picks, and the parent reads the file after the child ends.
public enum ChildStandardError {
    /// This returns a new file path in the temporary folder, which the parent captures into the exit test.
    public static func newPath() -> String {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("jka-swift-child-stderr-\(UUID().uuidString).txt", isDirectory: false)
            .path
    }

    /// The child calls this first, so a later `fatalError` or `Com_Printf` text goes to the file.
    /// If the file does not open, the standard error stays where it was.
    public static func redirect(to path: String) {
        let fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0o644)
        guard fd >= 0 else { return }
        dup2(fd, STDERR_FILENO)
        close(fd)
    }

    /// This reads the text of the file and removes the file.
    /// A missing file gives an empty text.
    public static func take(_ path: String) -> String {
        let text = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
        try? FileManager.default.removeItem(atPath: path)
        return text
    }
}
