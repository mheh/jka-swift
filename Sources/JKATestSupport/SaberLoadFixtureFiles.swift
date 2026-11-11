import Foundation
import JKAShared

/// This type serves `Oracle/fixtures/` as the engine file system of the saberload dumper.
/// A Raven path `ext_data/sabers/kyle.sab` maps to `Oracle/fixtures/sabers/kyle.sab`, and a handle is a slot from 1 to 63.
///
/// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:95
public final class SaberLoadFixtureFiles {
    /// This is the dumper's `MAXH`, the size of its handle table.
    /// Slot 0 is never a handle, so a full table has 63 open files.
    static let handleCount: Int32 = 64

    private let root: URL
    private var openFiles: [Int32: (bytes: [UInt8], position: Int)] = [:]

    /// This throws when the bundle has no `Oracle/fixtures/` folder.
    public init() throws {
        let root = Bundle.module.resourceURL?
            .appendingPathComponent("Oracle", isDirectory: true)
            .appendingPathComponent("fixtures", isDirectory: true)
        guard let root, FileManager.default.fileExists(atPath: root.path) else {
            throw OracleDataError.missing("fixtures")
        }
        self.root = root
    }
}

// MARK: - The traps

extension SaberLoadFixtureFiles {
    /// This is the dumper's `trap_FS_GetFileList`, the names with the extension in `strcmp` order, each with a trailing NUL.
    /// The count is every name that matched, also a name that did not fit in the buffer.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:102
    public func fileList(_ path: String, _ fileExtension: String, _ bufsize: Int32) -> (Int32, CharBuf) {
        var list = CharBuf(bufsize)
        guard let entries = try? FileManager.default.contentsOfDirectory(atPath: self.url(path).path) else {
            return (0, list)
        }
        // A plain `strcmp` compares unsigned bytes, so the sort compares the UTF-8 bytes.
        let names = entries
            .filter { $0.hasSuffix(fileExtension) }
            .sorted { $0.utf8.lexicographicallyPrecedes($1.utf8) }

        var offset = 0
        for name in names {
            let bytes = Array(name.utf8)
            if offset + bytes.count + 1 > Int(bufsize) {
                break
            }
            for (index, byte) in bytes.enumerated() {
                list[offset + index] = byte
            }
            list[offset + bytes.count] = UInt8(0)
            offset += bytes.count + 1
        }
        return (Int32(names.count), list)
    }

    /// This is the dumper's `trap_FS_FOpenFile`, the length of the file, or -1 and handle 0 when it does not open.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:135
    public func open(_ qpath: String, handle: inout Int32) -> Int32 {
        guard let data = FileManager.default.contents(atPath: self.url(qpath).path) else {
            handle = 0
            return -1
        }
        guard let free = (1 ..< Self.handleCount).first(where: { self.openFiles[$0] == nil }) else {
            handle = 0
            return -1
        }
        self.openFiles[free] = (bytes: [UInt8](data), position: 0)
        handle = free
        return Int32(data.count)
    }

    /// This is the dumper's `trap_FS_Read`, a `fread` of at most `count` bytes from the position of the handle.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:152
    public func read(into buffer: OpaquePointer?, count: Int32, handle: Int32) {
        guard let buffer, var file = self.openFiles[handle] else { return }
        let start = file.position
        let length = min(Int(count), file.bytes.count - start)
        guard length > 0 else { return }
        file.bytes.withUnsafeBytes { source in
            UnsafeMutableRawPointer(buffer).copyMemory(from: source.baseAddress! + start, byteCount: length)
        }
        file.position += length
        self.openFiles[handle] = file
    }

    /// This is the dumper's `trap_FS_FCloseFile`, which frees the slot of the handle.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:161
    public func close(_ handle: Int32) {
        self.openFiles[handle] = nil
    }
}

// MARK: - Paths

extension SaberLoadFixtureFiles {
    /// This is the dumper's `mappath`, which removes a leading `ext_data/` and puts the fixtures folder in its place.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:88
    private func url(_ vpath: String) -> URL {
        let prefix = "ext_data/"
        let relative = vpath.hasPrefix(prefix) ? String(vpath.dropFirst(prefix.count)) : vpath
        return self.root.appendingPathComponent(relative, isDirectory: false)
    }
}
