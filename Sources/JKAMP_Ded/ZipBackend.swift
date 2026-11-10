internal import CJKAMP_Ded
import JKAMP
import JKAShared
import JKAZlib

// MARK: - The zip file records

extension UnzS {
    /// Raven's cast of the `unzFile` handle, `(unz_s *)file`. A body writes this where and only where Raven wrote the cast.
    // AI: Raven's unzFile is a `void *`, which the port holds as an OpaquePointer. The cast reads the record behind it.
    public init(_ file: OpaquePointer) { self.init(handle: file) }
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
    public static func inflateInit(_ strm: Z_stream, _ flush: EFlush, _ noWrap: Int32) -> EStatus {
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
    public static func inflate(_ strm: Z_stream) -> EStatus {
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
    public static func inflateEnd(_ strm: Z_stream) -> EStatus {
        guard let system = strm.raw.pointee.istate else {
            return Self.ravenStatus(SystemInflate.streamError)
        }
        let status = SystemInflate.end(system)
        strm.raw.pointee.istate = nil
        return Self.ravenStatus(status)
    }

    // MARK: - The deflate calls

    /// Raven's `deflateInit(&stream, level)`, a raw deflate stream with no zlib header when `noWrap` is 1.
    /// The system stream lives in the `dstate` field of Raven's stream, the twin of `istate` of the inflate calls.
    /// Source: oracle/codemp/zlib32/zip.h:178
    @discardableResult
    public static func deflateInit(_ strm: Z_stream, _ level: ELevel, _ noWrap: Int32 = 0) -> EStatus {
        let (system, status) = SystemDeflate.start(level: level, raw: noWrap != 0)
        if system != nil {
            strm.raw.pointee.dstate = system
            strm.raw.pointee.total_in = 0
            strm.raw.pointee.total_out = 0
        }
        return Self.ravenStatus(status)
    }

    /// Raven's `deflate(&stream, flush)`, which deflates from `next_in` into `next_out` as far as the two counts allow.
    /// Source: oracle/codemp/zlib32/zip.h:180
    // AI: Raven's zlib32 takes the flush mode at each call. The system stream takes Z_SYNC_FLUSH, the one mode Raven's callers pass.
    @discardableResult
    public static func deflate(_ strm: Z_stream, _ flush: EFlush) -> EStatus {
        guard let system = strm.raw.pointee.dstate else {
            return Self.ravenStatus(SystemDeflate.streamError)
        }
        var nextIn = strm.raw.pointee.next_in
        var availIn = UInt32(truncatingIfNeeded: strm.raw.pointee.avail_in)
        var nextOut = strm.raw.pointee.next_out
        var availOut = UInt32(truncatingIfNeeded: strm.raw.pointee.avail_out)
        let consumedBefore = availIn
        let producedBefore = availOut

        let status = SystemDeflate.run(system, &nextIn, &availIn, &nextOut, &availOut)

        strm.raw.pointee.next_in = nextIn
        strm.raw.pointee.avail_in = CUnsignedLong(availIn)
        strm.raw.pointee.total_in &+= CUnsignedLong(consumedBefore - availIn)
        strm.raw.pointee.next_out = nextOut
        strm.raw.pointee.avail_out = CUnsignedLong(availOut)
        strm.raw.pointee.total_out &+= CUnsignedLong(producedBefore - availOut)
        return Self.ravenStatus(status)
    }

    /// Raven's `deflateEnd(&stream)`, which frees the state of the stream.
    /// Source: oracle/codemp/zlib32/zip.h:181
    @discardableResult
    public static func deflateEnd(_ strm: Z_stream) -> EStatus {
        guard let system = strm.raw.pointee.dstate else {
            return Self.ravenStatus(SystemDeflate.streamError)
        }
        let status = SystemDeflate.end(system)
        strm.raw.pointee.dstate = nil
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
