import Foundation

/// This class is the file system stub of the pmove dumpers, which serves the files of one fixture folder by base name.
/// The animation load opens `models/players/_humanoid/animation.cfg`, and the stub gives `<folder>/animation.cfg`.
/// A test installs its three methods over the `trap_FS_FOpenFile`, `trap_FS_Read`, and `trap_FS_FCloseFile` straps.
///
/// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:121
public final class FixtureFiles {
    // MARK: - State

    /// The fixture folder under `Oracle/fixtures/`, for example `pmove`.
    public let folder: String

    /// The open files by handle, each with its bytes and its read position.
    /// Handle 0 is never open, and the dumper has handles 1 through 7.
    private var handles: [(bytes: [UInt8], position: Int)?] = Array(repeating: nil, count: FixtureFiles.handleCount)

    /// This is `MAXH` of the dumper, one more than the count of handles a caller can hold at once.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:129
    static let handleCount = 8

    public init(folder: String) {
        self.folder = folder
    }
}

// MARK: - The file calls

extension FixtureFiles {
    /// This opens the fixture with the base name of `qpath` and returns its length, or -1 when it is missing.
    /// A write mode, a missing file, or no free handle gives -1 and handle 0, as the dumper does.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:132
    public func open(_ qpath: String, _ handle: inout Int32, reading: Bool) -> Int32 {
        guard reading else {
            handle = 0
            return -1
        }
        let base = qpath.split(separator: "/", omittingEmptySubsequences: false).last.map(String.init) ?? qpath
        guard let data = try? OracleData.fixtureData("\(self.folder)/\(base)") else {
            handle = 0
            return -1
        }
        guard let free = (1 ..< Self.handleCount).first(where: { self.handles[$0] == nil }) else {
            handle = 0
            return -1
        }
        self.handles[free] = (Array(data), 0)
        handle = Int32(free)
        return Int32(data.count)
    }

    /// This copies at most `length` bytes from the read position of the file into `buffer`, and moves the position.
    /// A bad handle copies nothing.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:149
    public func read(_ buffer: UnsafeMutableRawPointer?, _ length: Int32, _ handle: Int32) {
        guard let buffer, handle > 0, Int(handle) < Self.handleCount, let file = self.handles[Int(handle)] else { return }
        let count = min(Int(length), file.bytes.count - file.position)
        guard count > 0 else { return }
        file.bytes.withUnsafeBytes { source in
            buffer.copyMemory(from: source.baseAddress! + file.position, byteCount: count)
        }
        self.handles[Int(handle)] = (file.bytes, file.position + count)
    }

    /// This closes the file of `handle`, so a later open can take the handle again.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:156
    public func close(_ handle: Int32) {
        guard handle > 0, Int(handle) < Self.handleCount else { return }
        self.handles[Int(handle)] = nil
    }
}
