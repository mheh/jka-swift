#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(ucrt)
import ucrt
#endif
internal import CJKAMP_Ded
import JKAMP
import JKAShared

// MARK: - The path separator

/// Raven's `PATH_SEP` of q_shared.h, the separator of an OS path on the platform of the build.
/// Source: oracle/codemp/game/q_shared.h:200
// AI: Raven picks `PATH_SEP` by a platform `#ifdef`, and no branch of the host parse defines it.
// The constant takes the branch of the platform that builds.
#if os(Windows)
public let PATH_SEP = Int32(UInt8(ascii: "\\"))
#else
public let PATH_SEP = Int32(UInt8(ascii: "/"))
#endif

// MARK: - The file handle records

/// Source: oracle/codemp/qcommon/files.h:84
/// A view over one `fileHandleData_t` in C memory.
// AI: Raven defines fileHandleData_t in files.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct FileHandleData: Hashable, HandleView {
    let raw: UnsafeMutablePointer<fileHandleData_t>

    init(raw: UnsafeMutablePointer<fileHandleData_t>) { self.raw = raw }

    /// The slot behind a handle. Rule 11 confines the handle to the view target.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(fileHandleData_t *)p`.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: fileHandleData_t.self) }

    /// The slot as a handle.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes.
    public static let byteCount = MemoryLayout<fileHandleData_t>.size

    /// The distance between two slots of a C array of this type.
    public static let stride = MemoryLayout<fileHandleData_t>.stride

    /// Raven's `fileHandleData_t fsh[MAX_FILE_HANDLES]` of files_common.cpp, one zeroed table that the world owns.
    /// Source: oracle/codemp/qcommon/files_common.cpp:202
    // AI: Raven keeps fsh at file scope. The world owns one zeroed allocation, the form of an EngineStorage table.
    public static func table(count: Int32) -> Slots<FileHandleData> {
        let base = UnsafeMutableRawPointer.allocate(byteCount: Int(count) * FileHandleData.stride, alignment: MemoryLayout<fileHandleData_t>.alignment)
        base.initializeMemory(as: UInt8.self, repeating: 0, count: Int(count) * FileHandleData.stride)
        return Slots(views: base, count: Int(count), stride: FileHandleData.stride)
    }

    /// Raven's `Com_Memset( &fsh[f], 0, sizeof( fsh[f] ) )`, every byte of the slot to zero.
    public func clear() {
        self.raw.pointee = fileHandleData_t()
    }

    /// Source: oracle/codemp/qcommon/files.h:85
    public var handleFiles: Qfile_u {
        Qfile_u(raw: self.raw.pointer(to: \.handleFiles)!)
    }

    /// Source: oracle/codemp/qcommon/files.h:86
    public var handleSync: Bool {
        get { self.raw.pointee.handleSync != qfalse }
        nonmutating set { self.raw.pointee.handleSync = newValue ? qtrue : qfalse }
    }

    /// Source: oracle/codemp/qcommon/files.h:87
    public var baseOffset: Int32 {
        get { self.raw.pointee.baseOffset }
        nonmutating set { self.raw.pointee.baseOffset = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:88
    public var fileSize: Int32 {
        get { self.raw.pointee.fileSize }
        nonmutating set { self.raw.pointee.fileSize = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:89
    public var zipFilePos: Int32 {
        get { self.raw.pointee.zipFilePos }
        nonmutating set { self.raw.pointee.zipFilePos = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:90
    public var zipFile: Bool {
        get { self.raw.pointee.zipFile != qfalse }
        nonmutating set { self.raw.pointee.zipFile = newValue ? qtrue : qfalse }
    }

    /// Source: oracle/codemp/qcommon/files.h:91
    public var streamed: Bool {
        get { self.raw.pointee.streamed != qfalse }
        nonmutating set { self.raw.pointee.streamed = newValue ? qtrue : qfalse }
    }

    /// Source: oracle/codemp/qcommon/files.h:92
    public var name: String {
        get { cString(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.name)!)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.name)!), capacity: Int(CJKAMP_Ded.MAX_ZPATH)) }
    }

    /// Raven's `name` as the buffer a callee writes into, for a `char *` parameter the port spells `inout CharBuf`.
    public var nameBuffer: CharBuf {
        get { charBuf(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.name)!), capacity: Int(CJKAMP_Ded.MAX_ZPATH)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.name)!), capacity: Int(CJKAMP_Ded.MAX_ZPATH)) }
    }
}

/// Source: oracle/codemp/qcommon/files.h:78
/// A view over one `qfile_ut` in C memory.
// AI: Raven defines qfile_ut in files.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct Qfile_u: Hashable {
    let raw: UnsafeMutablePointer<qfile_ut>

    init(raw: UnsafeMutablePointer<qfile_ut>) { self.raw = raw }

    /// Source: oracle/codemp/qcommon/files.h:79
    public var file: Qfile_gu {
        Qfile_gu(raw: self.raw.pointer(to: \.file)!)
    }

    /// Source: oracle/codemp/qcommon/files.h:80
    public var unique: Bool {
        get { self.raw.pointee.unique != qfalse }
        nonmutating set { self.raw.pointee.unique = newValue ? qtrue : qfalse }
    }
}

/// Source: oracle/codemp/qcommon/files.h:71
/// A view over one `qfile_gut` in C memory, the union of a stdio stream and a zip handle.
// AI: Raven defines qfile_gut in files.h, and no root of the generator reaches it.
// The view is hand work, and `FILE *` is the handle that FileBackend takes.
public struct Qfile_gu: Hashable {
    let raw: UnsafeMutablePointer<qfile_gut>

    init(raw: UnsafeMutablePointer<qfile_gut>) { self.raw = raw }

    /// Source: oracle/codemp/qcommon/files.h:72
    public var o: OpaquePointer? {
        get { self.raw.pointee.o.map { OpaquePointer($0) } }
        nonmutating set { self.raw.pointee.o = newValue.map { UnsafeMutablePointer($0) } }
    }

    /// Source: oracle/codemp/qcommon/files.h:74
    public var z: OpaquePointer? {
        get { self.raw.pointee.z.map { OpaquePointer($0) } }
        nonmutating set { self.raw.pointee.z = newValue.map { UnsafeMutableRawPointer($0) } }
    }
}

// MARK: - The search path records

/// Source: oracle/codemp/qcommon/files.h:63
/// A view over one `searchpath_t` in C memory.
// AI: Raven defines searchpath_t in files.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct Searchpath: Hashable, HandleView {
    let raw: UnsafeMutablePointer<searchpath_t>

    init(raw: UnsafeMutablePointer<searchpath_t>) { self.raw = raw }

    /// The slot behind a handle. Rule 11 confines the handle to the view target.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(searchpath_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: searchpath_t.self) }

    /// The slot as a handle, for `Z_Free`.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes.
    public static let byteCount = MemoryLayout<searchpath_t>.size

    /// The distance between two slots of a C array of this type.
    public static let stride = MemoryLayout<searchpath_t>.stride

    /// Source: oracle/codemp/qcommon/files.h:64
    public var next: Searchpath? {
        get { self.raw.pointee.next.map { Searchpath(raw: $0) } }
        nonmutating set { self.raw.pointee.next = newValue?.raw }
    }

    /// Source: oracle/codemp/qcommon/files.h:66
    public var pack: Pack? {
        get { self.raw.pointee.pack.map { Pack(raw: $0) } }
        nonmutating set { self.raw.pointee.pack = newValue?.raw }
    }

    /// Source: oracle/codemp/qcommon/files.h:67
    public var dir: Directory? {
        get { self.raw.pointee.dir.map { Directory(raw: $0) } }
        nonmutating set { self.raw.pointee.dir = newValue?.raw }
    }
}

/// Source: oracle/codemp/qcommon/files.h:42
/// A view over one `pack_t` in C memory.
// AI: Raven defines pack_t in files.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct Pack: Hashable, HandleView {
    let raw: UnsafeMutablePointer<pack_t>

    init(raw: UnsafeMutablePointer<pack_t>) { self.raw = raw }

    /// The slot behind a handle. Rule 11 confines the handle to the view target.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(pack_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: pack_t.self) }

    /// The slot as a handle, for `Z_Free`.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes.
    public static let byteCount = MemoryLayout<pack_t>.size

    /// The distance between two slots of a C array of this type.
    public static let stride = MemoryLayout<pack_t>.stride

    /// Source: oracle/codemp/qcommon/files.h:43
    public var pakFilename: String {
        get { cString(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.pakFilename)!)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.pakFilename)!), capacity: Int(JKAMP.MAX_OSPATH)) }
    }

    /// Source: oracle/codemp/qcommon/files.h:44
    public var pakBasename: String {
        get { cString(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.pakBasename)!)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.pakBasename)!), capacity: Int(JKAMP.MAX_OSPATH)) }
    }

    /// Source: oracle/codemp/qcommon/files.h:45
    public var pakGamename: String {
        get { cString(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.pakGamename)!)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.pakGamename)!), capacity: Int(JKAMP.MAX_OSPATH)) }
    }

    /// Raven's `pakGamename` as the buffer a callee writes into, for a `char *` parameter the port spells `inout CharBuf`.
    public var pakGamenameBuffer: CharBuf {
        get { charBuf(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.pakGamename)!), capacity: Int(JKAMP.MAX_OSPATH)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.pakGamename)!), capacity: Int(JKAMP.MAX_OSPATH)) }
    }

    /// Source: oracle/codemp/qcommon/files.h:47
    // AI: Raven names the zip handle `handle`, the name every view gives its own slot.
    // The accessor takes the name `packHandle`, the form of `cvarHandle`.
    public var packHandle: OpaquePointer? {
        get { self.raw.pointee.handle.map { OpaquePointer($0) } }
        nonmutating set { self.raw.pointee.handle = newValue.map { UnsafeMutableRawPointer($0) } }
    }

    /// Source: oracle/codemp/qcommon/files.h:49
    public var checksum: Int32 {
        get { self.raw.pointee.checksum }
        nonmutating set { self.raw.pointee.checksum = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:50
    public var pure_checksum: Int32 {
        get { self.raw.pointee.pure_checksum }
        nonmutating set { self.raw.pointee.pure_checksum = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:51
    public var numfiles: Int32 {
        get { self.raw.pointee.numfiles }
        nonmutating set { self.raw.pointee.numfiles = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:52
    public var referenced: Int32 {
        get { self.raw.pointee.referenced }
        nonmutating set { self.raw.pointee.referenced = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:53
    public var hashSize: Int32 {
        get { self.raw.pointee.hashSize }
        nonmutating set { self.raw.pointee.hashSize = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:54
    /// The table holds `hashSize` slots, and Raven's own index is the one that reads.
    public var hashTable: Slots<FileInPack?>? {
        get { self.raw.pointee.hashTable.map { Slots(pointers: UnsafeMutableRawPointer($0), count: Int(self.raw.pointee.hashSize)) } }
        nonmutating set { self.raw.pointee.hashTable = newValue?.base.assumingMemoryBound(to: UnsafeMutablePointer<fileInPack_t>?.self) }
    }

    /// Source: oracle/codemp/qcommon/files.h:55
    public var buildBuffer: FileInPack? {
        get { self.raw.pointee.buildBuffer.map { FileInPack(raw: $0) } }
        nonmutating set { self.raw.pointee.buildBuffer = newValue?.raw }
    }
}

/// Source: oracle/codemp/qcommon/files.h:58
/// A view over one `directory_t` in C memory.
// AI: Raven defines directory_t in files.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct Directory: Hashable, HandleView {
    let raw: UnsafeMutablePointer<directory_t>

    init(raw: UnsafeMutablePointer<directory_t>) { self.raw = raw }

    /// The slot behind a handle. Rule 11 confines the handle to the view target.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(directory_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: directory_t.self) }

    /// The slot as a handle, for `Z_Free`.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes.
    public static let byteCount = MemoryLayout<directory_t>.size

    /// The distance between two slots of a C array of this type.
    public static let stride = MemoryLayout<directory_t>.stride

    /// Source: oracle/codemp/qcommon/files.h:59
    public var path: String {
        get { cString(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.path)!)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.path)!), capacity: Int(JKAMP.MAX_OSPATH)) }
    }

    /// Raven's `path` as the buffer a callee writes into, for a `char *` parameter the port spells `inout CharBuf`.
    public var pathBuffer: CharBuf {
        get { charBuf(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.path)!), capacity: Int(JKAMP.MAX_OSPATH)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.path)!), capacity: Int(JKAMP.MAX_OSPATH)) }
    }

    /// Source: oracle/codemp/qcommon/files.h:60
    public var gamedir: String {
        get { cString(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.gamedir)!)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.gamedir)!), capacity: Int(JKAMP.MAX_OSPATH)) }
    }

    /// Raven's `gamedir` as the buffer a callee writes into, for a `char *` parameter the port spells `inout CharBuf`.
    public var gamedirBuffer: CharBuf {
        get { charBuf(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.gamedir)!), capacity: Int(JKAMP.MAX_OSPATH)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.gamedir)!), capacity: Int(JKAMP.MAX_OSPATH)) }
    }
}

/// Source: oracle/codemp/qcommon/files.h:36
/// A view over one `fileInPack_t` in C memory.
// AI: Raven defines fileInPack_t in files.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct FileInPack: Hashable, HandleView {
    let raw: UnsafeMutablePointer<fileInPack_t>

    init(raw: UnsafeMutablePointer<fileInPack_t>) { self.raw = raw }

    /// The slot behind a handle. Rule 11 confines the handle to the view target.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(fileInPack_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: fileInPack_t.self) }

    /// The slot as a handle, for `Z_Free`.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes.
    public static let byteCount = MemoryLayout<fileInPack_t>.size

    /// The distance between two slots of a C array of this type.
    public static let stride = MemoryLayout<fileInPack_t>.stride

    /// Source: oracle/codemp/qcommon/files.h:37
    public var name: String? {
        get { self.raw.pointee.name.map { cString(at: $0) } }
        nonmutating set { self.raw.pointee.name = StringPool.shared.pointer(for: newValue) }
    }

    /// Source: oracle/codemp/qcommon/files.h:38
    public var pos: CUnsignedLong {
        get { self.raw.pointee.pos }
        nonmutating set { self.raw.pointee.pos = newValue }
    }

    /// Source: oracle/codemp/qcommon/files.h:39
    public var next: FileInPack? {
        get { self.raw.pointee.next.map { FileInPack(raw: $0) } }
        nonmutating set { self.raw.pointee.next = newValue?.raw }
    }
}

// MARK: - The C library streams

/// The C library stream calls under Raven's file system.
/// They are `fopen`, `fread`, `fwrite`, `fseek`, `ftell`, `fflush`, `setvbuf`, `fclose`, `remove`, and `rename`.
/// A stream is the `OpaquePointer?` of the `o` field of `Qfile_gu`, and nil is Raven's NULL `FILE *`.
/// A nil stream traps at `fclose`, `fread`, `fwrite`, `fseek`, `ftell`, and `setvbuf`, because the C library dereferences a NULL `FILE *` there.
/// Each call names the C library module of its platform, because the member of the same name hides the C function.
// AI: Raven calls the C library on a `FILE *`. The backend takes the stream as a handle, so the logic target holds no pointer type.
public enum FileBackend {
    /// Source: oracle/codemp/qcommon/files_pc.cpp:180
    public static func fopen(_ filename: String, _ mode: String) -> OpaquePointer? {
        #if canImport(Darwin)
        let stream = Darwin.fopen(filename, mode)
        #elseif canImport(Glibc)
        let stream = Glibc.fopen(filename, mode)
        #elseif canImport(Musl)
        let stream = Musl.fopen(filename, mode)
        #elseif canImport(ucrt)
        let stream = ucrt.fopen(filename, mode)
        #endif
        return stream.map { OpaquePointer($0) }
    }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:193
    @discardableResult
    public static func fclose(_ stream: OpaquePointer?) -> Int32 {
        #if canImport(Darwin)
        return Darwin.fclose(UnsafeMutablePointer(stream!))
        #elseif canImport(Glibc)
        return Glibc.fclose(UnsafeMutablePointer(stream!))
        #elseif canImport(Musl)
        return Musl.fclose(UnsafeMutablePointer(stream!))
        #elseif canImport(ucrt)
        return ucrt.fclose(UnsafeMutablePointer(stream!))
        #endif
    }

    /// Raven's `fread( buf, size, count, f )`, where `buf` is `offset` bytes past the start of `buffer`.
    /// The count C returns as `size_t` narrows to `int` at Raven's store, so the call returns `Int32`.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:1047
    // AI: Raven steps a byte pointer through the buffer.
    // The call takes the buffer and the byte offset, so the logic target does no pointer arithmetic.
    public static func fread(_ buffer: OpaquePointer?, at offset: Int32, _ size: Int32, _ count: Int32, _ stream: OpaquePointer?) -> Int32 {
        let base = UnsafeMutableRawPointer(buffer!) + Int(offset)
        #if canImport(Darwin)
        let read = Darwin.fread(base, Int(size), Int(count), UnsafeMutablePointer(stream!))
        #elseif canImport(Glibc)
        let read = Glibc.fread(base, Int(size), Int(count), UnsafeMutablePointer(stream!))
        #elseif canImport(Musl)
        let read = Musl.fread(base, Int(size), Int(count), UnsafeMutablePointer(stream!))
        #elseif canImport(ucrt)
        let read = ucrt.fread(base, Int(size), Int(count), UnsafeMutablePointer(stream!))
        #endif
        return Int32(truncatingIfNeeded: read)
    }

    /// Raven's `fread` into a `char` array, the bytes of a `CharBuf` from `offset` on.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:1953
    // AI: Raven reads into his `char` array through a pointer. The call takes the caller's CharBuf and the byte offset.
    public static func fread(_ buffer: inout CharBuf, at offset: Int32, _ size: Int32, _ count: Int32, _ stream: OpaquePointer?) -> Int32 {
        precondition(Int(offset) + Int(size) * Int(count) <= buffer.count, "fread past the end of the CharBuf")
        let read = buffer.withUnsafeMutableRawPointer { base in
            #if canImport(Darwin)
            Darwin.fread(base + Int(offset), Int(size), Int(count), UnsafeMutablePointer(stream!))
            #elseif canImport(Glibc)
            Glibc.fread(base + Int(offset), Int(size), Int(count), UnsafeMutablePointer(stream!))
            #elseif canImport(Musl)
            Musl.fread(base + Int(offset), Int(size), Int(count), UnsafeMutablePointer(stream!))
            #elseif canImport(ucrt)
            ucrt.fread(base + Int(offset), Int(size), Int(count), UnsafeMutablePointer(stream!))
            #endif
        }
        return Int32(truncatingIfNeeded: read)
    }

    /// Raven's `fwrite( buf, size, count, f )`, where `buf` is `offset` bytes past the start of `buffer`.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:1099
    // AI: Raven steps a byte pointer through the buffer.
    // The call takes the buffer and the byte offset, so the logic target does no pointer arithmetic.
    public static func fwrite(_ buffer: OpaquePointer?, at offset: Int32, _ size: Int32, _ count: Int32, _ stream: OpaquePointer?) -> Int32 {
        let base = UnsafeMutableRawPointer(buffer!) + Int(offset)
        #if canImport(Darwin)
        let written = Darwin.fwrite(base, Int(size), Int(count), UnsafeMutablePointer(stream!))
        #elseif canImport(Glibc)
        let written = Glibc.fwrite(base, Int(size), Int(count), UnsafeMutablePointer(stream!))
        #elseif canImport(Musl)
        let written = Musl.fwrite(base, Int(size), Int(count), UnsafeMutablePointer(stream!))
        #elseif canImport(ucrt)
        let written = ucrt.fwrite(base, Int(size), Int(count), UnsafeMutablePointer(stream!))
        #endif
        return Int32(truncatingIfNeeded: written)
    }

    /// Raven's `fwrite` from a `char` array, the bytes of a `CharBuf` from `offset` on.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:1099
    // AI: Raven writes his `char` array through a pointer. The call takes the caller's CharBuf and the byte offset.
    public static func fwrite(_ buffer: CharBuf, at offset: Int32, _ size: Int32, _ count: Int32, _ stream: OpaquePointer?) -> Int32 {
        precondition(Int(offset) + Int(size) * Int(count) <= buffer.count, "fwrite past the end of the CharBuf")
        let written = buffer.withUnsafeRawPointer { base in
            #if canImport(Darwin)
            Darwin.fwrite(base + Int(offset), Int(size), Int(count), UnsafeMutablePointer(stream!))
            #elseif canImport(Glibc)
            Glibc.fwrite(base + Int(offset), Int(size), Int(count), UnsafeMutablePointer(stream!))
            #elseif canImport(Musl)
            Musl.fwrite(base + Int(offset), Int(size), Int(count), UnsafeMutablePointer(stream!))
            #elseif canImport(ucrt)
            ucrt.fwrite(base + Int(offset), Int(size), Int(count), UnsafeMutablePointer(stream!))
            #endif
        }
        return Int32(truncatingIfNeeded: written)
    }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:1183
    @discardableResult
    public static func fseek(_ stream: OpaquePointer?, _ offset: CLong, _ whence: Int32) -> Int32 {
        #if canImport(Darwin)
        return Darwin.fseek(UnsafeMutablePointer(stream!), offset, whence)
        #elseif canImport(Glibc)
        return Glibc.fseek(UnsafeMutablePointer(stream!), offset, whence)
        #elseif canImport(Musl)
        return Musl.fseek(UnsafeMutablePointer(stream!), offset, whence)
        #elseif canImport(ucrt)
        return ucrt.fseek(UnsafeMutablePointer(stream!), offset, whence)
        #endif
    }

    /// The position C returns as `long` narrows to `int` at Raven's store, so the call returns `Int32`.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:123
    public static func ftell(_ stream: OpaquePointer?) -> Int32 {
        #if canImport(Darwin)
        let position = Darwin.ftell(UnsafeMutablePointer(stream!))
        #elseif canImport(Glibc)
        let position = Glibc.ftell(UnsafeMutablePointer(stream!))
        #elseif canImport(Musl)
        let position = Musl.ftell(UnsafeMutablePointer(stream!))
        #elseif canImport(ucrt)
        let position = ucrt.ftell(UnsafeMutablePointer(stream!))
        #endif
        return Int32(truncatingIfNeeded: position)
    }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:3129
    @discardableResult
    public static func fflush(_ stream: OpaquePointer?) -> Int32 {
        #if canImport(Darwin)
        return Darwin.fflush(UnsafeMutablePointer(stream))
        #elseif canImport(Glibc)
        return Glibc.fflush(UnsafeMutablePointer(stream))
        #elseif canImport(Musl)
        return Musl.fflush(UnsafeMutablePointer(stream))
        #elseif canImport(ucrt)
        return ucrt.fflush(UnsafeMutablePointer(stream))
        #endif
    }

    /// Raven's `setvbuf( file, NULL, mode, size )`, which lets the C library own the buffer.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:104
    @discardableResult
    public static func setvbuf(_ stream: OpaquePointer?, _ buffer: OpaquePointer?, _ mode: Int32, _ size: Int32) -> Int32 {
        precondition(buffer == nil, "setvbuf takes the NULL buffer that Raven passes")
        #if canImport(Darwin)
        return Darwin.setvbuf(UnsafeMutablePointer(stream!), nil, mode, Int(size))
        #elseif canImport(Glibc)
        return Glibc.setvbuf(UnsafeMutablePointer(stream!), nil, mode, Int(size))
        #elseif canImport(Musl)
        return Musl.setvbuf(UnsafeMutablePointer(stream!), nil, mode, Int(size))
        #elseif canImport(ucrt)
        return ucrt.setvbuf(UnsafeMutablePointer(stream!), nil, mode, Int(size))
        #endif
    }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:214
    @discardableResult
    public static func remove(_ filename: String) -> Int32 {
        #if canImport(Darwin)
        return Darwin.remove(filename)
        #elseif canImport(Glibc)
        return Glibc.remove(filename)
        #elseif canImport(Musl)
        return Musl.remove(filename)
        #elseif canImport(ucrt)
        return ucrt.remove(filename)
        #endif
    }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:417
    public static func rename(_ old: String, _ new: String) -> Int32 {
        #if canImport(Darwin)
        return Darwin.rename(old, new)
        #elseif canImport(Glibc)
        return Glibc.rename(old, new)
        #elseif canImport(Musl)
        return Musl.rename(old, new)
        #elseif canImport(ucrt)
        return ucrt.rename(old, new)
        #endif
    }
}
