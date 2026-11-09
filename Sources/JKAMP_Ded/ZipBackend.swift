internal import CJKAMP_Ded
import JKAMP
import JKAShared
import JKAZlib

// MARK: - The zip file records

/// Source: oracle/codemp/qcommon/unzip.h:88
/// A view over one `unz_s` in C memory, the state of one open zip file.
// AI: Raven defines unz_s in unzip.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct UnzS: Hashable, HandleView {
    let raw: UnsafeMutablePointer<unz_s>

    init(raw: UnsafeMutablePointer<unz_s>) { self.raw = raw }

    /// The slot behind a handle. Rule 11 confines the handle to the view target.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(unz_s *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: unz_s.self) }

    /// Raven's cast of the `unzFile` handle, `(unz_s *)file`. A body writes this where and only where Raven wrote the cast.
    // AI: Raven's unzFile is a `void *`, which the port holds as an OpaquePointer. The cast reads the record behind it.
    public init(_ file: OpaquePointer) { self.raw = UnsafeMutablePointer(file) }

    /// The slot as a handle, for `Z_Free` and for the `unzFile` that unzOpen returns.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes.
    public static let byteCount = MemoryLayout<unz_s>.size

    /// The distance between two slots of a C array of this type.
    public static let stride = MemoryLayout<unz_s>.stride

    /// Source: oracle/codemp/qcommon/unzip.h:90
    public var file: OpaquePointer? {
        get { self.raw.pointee.file.map { OpaquePointer($0) } }
        nonmutating set { self.raw.pointee.file = newValue.map { UnsafeMutablePointer($0) } }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:91
    public var gi: UnzGlobalInfo {
        UnzGlobalInfo(raw: self.raw.pointer(to: \.gi)!)
    }

    /// Source: oracle/codemp/qcommon/unzip.h:92
    public var byte_before_the_zipfile: CUnsignedLong {
        get { self.raw.pointee.byte_before_the_zipfile }
        nonmutating set { self.raw.pointee.byte_before_the_zipfile = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:93
    public var num_file: CUnsignedLong {
        get { self.raw.pointee.num_file }
        nonmutating set { self.raw.pointee.num_file = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:94
    public var pos_in_central_dir: CUnsignedLong {
        get { self.raw.pointee.pos_in_central_dir }
        nonmutating set { self.raw.pointee.pos_in_central_dir = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:95
    public var current_file_ok: CUnsignedLong {
        get { self.raw.pointee.current_file_ok }
        nonmutating set { self.raw.pointee.current_file_ok = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:96
    public var central_pos: CUnsignedLong {
        get { self.raw.pointee.central_pos }
        nonmutating set { self.raw.pointee.central_pos = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:98
    public var size_central_dir: CUnsignedLong {
        get { self.raw.pointee.size_central_dir }
        nonmutating set { self.raw.pointee.size_central_dir = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:99
    public var offset_central_dir: CUnsignedLong {
        get { self.raw.pointee.offset_central_dir }
        nonmutating set { self.raw.pointee.offset_central_dir = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:102
    public var cur_file_info: UnzFileInfo {
        UnzFileInfo(raw: self.raw.pointer(to: \.cur_file_info)!)
    }

    /// Source: oracle/codemp/qcommon/unzip.h:103
    public var cur_file_info_internal: UnzFileInfoInternal {
        UnzFileInfoInternal(raw: self.raw.pointer(to: \.cur_file_info_internal)!)
    }

    /// Source: oracle/codemp/qcommon/unzip.h:104
    public var pfile_in_zip_read: FileInZipReadInfo? {
        get { self.raw.pointee.pfile_in_zip_read.map { FileInZipReadInfo(raw: $0) } }
        nonmutating set { self.raw.pointee.pfile_in_zip_read = newValue?.raw }
    }
}

/// Source: oracle/codemp/qcommon/unzip.h:27
/// A view over one `unz_global_info` in C memory.
// AI: Raven defines unz_global_info in unzip.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct UnzGlobalInfo: Hashable {
    let raw: UnsafeMutablePointer<unz_global_info>

    init(raw: UnsafeMutablePointer<unz_global_info>) { self.raw = raw }

    /// Source: oracle/codemp/qcommon/unzip.h:29
    public var number_entry: CUnsignedLong {
        get { self.raw.pointee.number_entry }
        nonmutating set { self.raw.pointee.number_entry = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:30
    public var size_comment: CUnsignedLong {
        get { self.raw.pointee.size_comment }
        nonmutating set { self.raw.pointee.size_comment = newValue }
    }
}

/// Source: oracle/codemp/qcommon/unzip.h:35
/// A view over one `unz_file_info` in C memory, the central directory entry of one file.
// AI: Raven defines unz_file_info in unzip.h, and no root of the generator reaches it.
// The view is hand work in the generated form, with the fields that a body of unzip.cpp reads.
public struct UnzFileInfo: Hashable {
    let raw: UnsafeMutablePointer<unz_file_info>

    init(raw: UnsafeMutablePointer<unz_file_info>) { self.raw = raw }

    /// Source: oracle/codemp/qcommon/unzip.h:40
    public var compression_method: CUnsignedLong {
        get { self.raw.pointee.compression_method }
        nonmutating set { self.raw.pointee.compression_method = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:42
    public var crc: CUnsignedLong {
        get { self.raw.pointee.crc }
        nonmutating set { self.raw.pointee.crc = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:43
    public var compressed_size: CUnsignedLong {
        get { self.raw.pointee.compressed_size }
        nonmutating set { self.raw.pointee.compressed_size = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:44
    public var uncompressed_size: CUnsignedLong {
        get { self.raw.pointee.uncompressed_size }
        nonmutating set { self.raw.pointee.uncompressed_size = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:45
    public var size_filename: CUnsignedLong {
        get { self.raw.pointee.size_filename }
        nonmutating set { self.raw.pointee.size_filename = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:46
    public var size_file_extra: CUnsignedLong {
        get { self.raw.pointee.size_file_extra }
        nonmutating set { self.raw.pointee.size_file_extra = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:47
    public var size_file_comment: CUnsignedLong {
        get { self.raw.pointee.size_file_comment }
        nonmutating set { self.raw.pointee.size_file_comment = newValue }
    }
}

/// Source: oracle/codemp/qcommon/unzip.h:57
/// A view over one `unz_file_info_internal` in C memory.
// AI: Raven defines unz_file_info_internal in unzip.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct UnzFileInfoInternal: Hashable {
    let raw: UnsafeMutablePointer<unz_file_info_internal>

    init(raw: UnsafeMutablePointer<unz_file_info_internal>) { self.raw = raw }

    /// Source: oracle/codemp/qcommon/unzip.h:59
    public var offset_curfile: CUnsignedLong {
        get { self.raw.pointee.offset_curfile }
        nonmutating set { self.raw.pointee.offset_curfile = newValue }
    }
}

/// Source: oracle/codemp/qcommon/unzip.h:64
/// A view over one `file_in_zip_read_info_s` in C memory, the read state of the open file in a zip.
// AI: Raven defines file_in_zip_read_info_s in unzip.h, and no root of the generator reaches it. The view is hand work in the generated form.
public struct FileInZipReadInfo: Hashable, HandleView {
    let raw: UnsafeMutablePointer<file_in_zip_read_info_s>

    init(raw: UnsafeMutablePointer<file_in_zip_read_info_s>) { self.raw = raw }

    /// The slot behind a handle. Rule 11 confines the handle to the view target.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(file_in_zip_read_info_s *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: file_in_zip_read_info_s.self) }

    /// The slot as a handle, for `Z_Free`.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes.
    public static let byteCount = MemoryLayout<file_in_zip_read_info_s>.size

    /// The distance between two slots of a C array of this type.
    public static let stride = MemoryLayout<file_in_zip_read_info_s>.stride

    /// The `char *` of a zone block, as the handle that `FileBackend.fread` and `Z_Free` take.
    /// Source: oracle/codemp/qcommon/unzip.h:66
    public var read_buffer: OpaquePointer? {
        get { self.raw.pointee.read_buffer.map { OpaquePointer($0) } }
        nonmutating set { self.raw.pointee.read_buffer = newValue.map { UnsafeMutablePointer($0) } }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:67
    public var stream: ZStream {
        ZStream(raw: self.raw.pointer(to: \.stream)!)
    }

    /// Source: oracle/codemp/qcommon/unzip.h:69
    public var pos_in_zipfile: CUnsignedLong {
        get { self.raw.pointee.pos_in_zipfile }
        nonmutating set { self.raw.pointee.pos_in_zipfile = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:70
    public var stream_initialised: CUnsignedLong {
        get { self.raw.pointee.stream_initialised }
        nonmutating set { self.raw.pointee.stream_initialised = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:72
    public var offset_local_extrafield: CUnsignedLong {
        get { self.raw.pointee.offset_local_extrafield }
        nonmutating set { self.raw.pointee.offset_local_extrafield = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:73
    public var size_local_extrafield: UInt32 {
        get { self.raw.pointee.size_local_extrafield }
        nonmutating set { self.raw.pointee.size_local_extrafield = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:74
    public var pos_local_extrafield: CUnsignedLong {
        get { self.raw.pointee.pos_local_extrafield }
        nonmutating set { self.raw.pointee.pos_local_extrafield = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:76
    public var crc32: CUnsignedLong {
        get { self.raw.pointee.crc32 }
        nonmutating set { self.raw.pointee.crc32 = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:77
    public var crc32_wait: CUnsignedLong {
        get { self.raw.pointee.crc32_wait }
        nonmutating set { self.raw.pointee.crc32_wait = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:78
    public var rest_read_compressed: CUnsignedLong {
        get { self.raw.pointee.rest_read_compressed }
        nonmutating set { self.raw.pointee.rest_read_compressed = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:79
    public var rest_read_uncompressed: CUnsignedLong {
        get { self.raw.pointee.rest_read_uncompressed }
        nonmutating set { self.raw.pointee.rest_read_uncompressed = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:80
    public var file: OpaquePointer? {
        get { self.raw.pointee.file.map { OpaquePointer($0) } }
        nonmutating set { self.raw.pointee.file = newValue.map { UnsafeMutablePointer($0) } }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:81
    public var compression_method: CUnsignedLong {
        get { self.raw.pointee.compression_method }
        nonmutating set { self.raw.pointee.compression_method = newValue }
    }

    /// Source: oracle/codemp/qcommon/unzip.h:82
    public var byte_before_the_zipfile: CUnsignedLong {
        get { self.raw.pointee.byte_before_the_zipfile }
        nonmutating set { self.raw.pointee.byte_before_the_zipfile = newValue }
    }
}

/// Source: oracle/codemp/zlib32/zip.h:129
/// A view over one `z_stream` of Raven's zlib32 in C memory.
/// `ZipBackend` keeps the stream of the system zlib in `istate` and copies the counts and the positions across each call.
// AI: Raven defines z_stream in his zlib32 header, and no root of the generator reaches it.
// The view is hand work in the generated form, and `next_in` and `next_out` are byte Slots of the widest count.
public struct ZStream: Hashable {
    let raw: UnsafeMutablePointer<z_stream>

    init(raw: UnsafeMutablePointer<z_stream>) { self.raw = raw }

    /// Source: oracle/codemp/zlib32/zip.h:131
    public var next_in: Slots<JKAShared.byte>? {
        get { self.raw.pointee.next_in.map { Slots(scalars: UnsafeMutableRawPointer($0), count: Int.max) } }
        nonmutating set { self.raw.pointee.next_in = newValue?.base.assumingMemoryBound(to: UInt8.self) }
    }

    /// Source: oracle/codemp/zlib32/zip.h:132
    public var avail_in: CUnsignedLong {
        get { self.raw.pointee.avail_in }
        nonmutating set { self.raw.pointee.avail_in = newValue }
    }

    /// Source: oracle/codemp/zlib32/zip.h:133
    public var total_in: CUnsignedLong {
        get { self.raw.pointee.total_in }
        nonmutating set { self.raw.pointee.total_in = newValue }
    }

    /// Source: oracle/codemp/zlib32/zip.h:135
    public var next_out: Slots<JKAShared.byte>? {
        get { self.raw.pointee.next_out.map { Slots(scalars: UnsafeMutableRawPointer($0), count: Int.max) } }
        nonmutating set { self.raw.pointee.next_out = newValue?.base.assumingMemoryBound(to: UInt8.self) }
    }

    /// Source: oracle/codemp/zlib32/zip.h:136
    public var avail_out: CUnsignedLong {
        get { self.raw.pointee.avail_out }
        nonmutating set { self.raw.pointee.avail_out = newValue }
    }

    /// Source: oracle/codemp/zlib32/zip.h:137
    public var total_out: CUnsignedLong {
        get { self.raw.pointee.total_out }
        nonmutating set { self.raw.pointee.total_out = newValue }
    }
}

// MARK: - The inflate calls

/// Raven's zlib32 calls of unzip.cpp, `inflateInit`, `inflate`, and `inflateEnd`, over the system zlib.
/// The system stream lives in a C allocation that the `istate` field of Raven's stream holds, and each call copies the four positions and counts across.
/// Each return is the `EStatus` of Raven's zlib32, so the bodies compare it with his `Z_OK` and `Z_STREAM_END`.
// AI: Raven links his own zlib32 with a stream record of its own layout. The port links the system zlib and keeps his record as the one the bodies read.
public enum ZipBackend {
    /// Raven's cast of a `void *` or `char *` buffer to `Byte *`, a byte Slots of `count` bytes over the same memory.
    /// Source: oracle/codemp/qcommon/unzip.cpp:1076
    // AI: Raven casts the buffer to `Byte *` and steps it by hand. The Slots gives the bytes to the body with no pointer type.
    public static func bytes(_ buf: OpaquePointer?, count: some BinaryInteger) -> Slots<JKAShared.byte>? {
        buf.map { Slots(scalars: UnsafeMutableRawPointer($0), count: Int(count)) }
    }

    /// Raven's `inflateInit(&stream, Z_SYNC_FLUSH, 1)`, a raw deflate stream with no zlib header when `noWrap` is 1.
    /// Source: oracle/codemp/zlib32/zip.h:186
    // AI: Raven's zlib32 keeps the flush mode in the stream. The system stream takes Z_SYNC_FLUSH at each inflate call.
    public static func inflateInit(_ strm: ZStream, _ flush: EFlush, _ noWrap: Int32) -> EStatus {
        let (system, status) = SystemInflate.start(raw: noWrap != 0)
        if system != nil {
            strm.raw.pointee.istate = system
            strm.raw.pointee.total_in = 0
            strm.raw.pointee.total_out = 0
        }
        return Self.ravenStatus(status)
    }

    /// Raven's `inflate(&stream)`, which inflates from `next_in` into `next_out` as far as the two counts allow.
    /// Source: oracle/codemp/zlib32/zip.h:187
    public static func inflate(_ strm: ZStream) -> EStatus {
        guard let system = strm.raw.pointee.istate else {
            return Self.ravenStatus(SystemInflate.streamError)
        }
        var nextIn = strm.raw.pointee.next_in
        var availIn = UInt32(truncatingIfNeeded: strm.raw.pointee.avail_in)
        var nextOut = strm.raw.pointee.next_out
        var availOut = UInt32(truncatingIfNeeded: strm.raw.pointee.avail_out)
        let consumedBefore = availIn
        let producedBefore = availOut

        let status = SystemInflate.run(system, &nextIn, &availIn, &nextOut, &availOut)

        strm.raw.pointee.next_in = nextIn
        strm.raw.pointee.avail_in = CUnsignedLong(availIn)
        strm.raw.pointee.total_in &+= CUnsignedLong(consumedBefore - availIn)
        strm.raw.pointee.next_out = nextOut
        strm.raw.pointee.avail_out = CUnsignedLong(availOut)
        strm.raw.pointee.total_out &+= CUnsignedLong(producedBefore - availOut)
        return Self.ravenStatus(status)
    }

    /// Raven's `inflateEnd(&stream)`, which frees the state of the stream.
    /// Source: oracle/codemp/zlib32/zip.h:188
    @discardableResult
    public static func inflateEnd(_ strm: ZStream) -> EStatus {
        guard let system = strm.raw.pointee.istate else {
            return Self.ravenStatus(SystemInflate.streamError)
        }
        let status = SystemInflate.end(system)
        strm.raw.pointee.istate = nil
        return Self.ravenStatus(status)
    }

    /// This maps a status of the system zlib to the `EStatus` of Raven's zlib32, whose numbers differ.
    /// A status that zlib32 has no name for is his `Z_STREAM_ERROR`.
    private static func ravenStatus(_ status: Int32) -> EStatus {
        switch status {
        case SystemInflate.ok:
            return Z_OK

        case SystemInflate.streamEnd:
            return Z_STREAM_END

        case SystemInflate.bufError:
            return Z_BUF_ERROR

        case SystemInflate.dataError:
            return Z_DATA_ERROR

        default:
            return Z_STREAM_ERROR
        }
    }
}
