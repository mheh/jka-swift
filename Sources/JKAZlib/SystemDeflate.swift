// An `internal import` still loads the C module into every client, and a client that also loads CJKAMP_Ded then fails on the two `struct z_stream_s` records.
@_implementationOnly import CJKAZlib

/// The deflate calls of the system zlib, for `ZipBackend` of the dedicated server view target.
/// The stream of the system zlib is a C allocation behind an `OpaquePointer`, and every position and count crosses as a value.
/// Each status is the system zlib's number, and `ZipBackend` maps it to the `EStatus` of Raven's zlib32.
// AI: Raven links his own zlib32. The port links the system zlib, whose `struct z_stream_s` clashes with his, so the calls stand in this module alone.
public enum SystemDeflate {
    /// The system `Z_OK`.
    public static let ok = Z_OK

    /// The system `Z_STREAM_END`.
    public static let streamEnd = Z_STREAM_END

    /// The system `Z_BUF_ERROR`.
    public static let bufError = Z_BUF_ERROR

    /// The system `Z_STREAM_ERROR`.
    public static let streamError = Z_STREAM_ERROR

    /// This allocates a system stream and starts it at `level`, a raw deflate stream with no zlib header when `raw` is true.
    /// The levels 0 to 9 of Raven's `ELevel` are the levels 0 to 9 of the system zlib, so `level` crosses as it stands.
    /// The stream is nil when the start fails, and the status says why.
    public static func start(level: Int32, raw: Bool) -> (stream: OpaquePointer?, status: Int32) {
        // The runtime keeps one type record per C struct name, and Raven's `struct z_stream_s` of zip.h is 80 bytes against the 112 of the system.
        // A generic allocate can take the size of Raven's record, so the block takes the size the compiler gives this module and starts at zero.
        let block = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<z_stream>.size, alignment: MemoryLayout<z_stream>.alignment)
        block.initializeMemory(as: UInt8.self, repeating: 0, count: MemoryLayout<z_stream>.size)
        let stream = block.bindMemory(to: z_stream.self, capacity: 1)
        let windowBits = raw ? -MAX_WBITS : MAX_WBITS
        // The memory level 8 is the level that `deflateInit` of the system zlib gives.
        let memLevel: Int32 = 8
        let status = deflateInit2_(stream, level, Z_DEFLATED, windowBits, memLevel, Z_DEFAULT_STRATEGY, zlibVersion(), Int32(MemoryLayout<z_stream>.size))
        if status != Z_OK {
            stream.deallocate()
            return (nil, status)
        }
        return (OpaquePointer(stream), status)
    }

    /// This runs one `deflate` with `Z_SYNC_FLUSH` and moves the four positions and counts as the call moved them.
    public static func run(
        _ stream: OpaquePointer,
        _ nextIn: inout UnsafeMutablePointer<UInt8>?,
        _ availIn: inout UInt32,
        _ nextOut: inout UnsafeMutablePointer<UInt8>?,
        _ availOut: inout UInt32
    ) -> Int32 {
        let system = UnsafeMutablePointer<z_stream>(stream)
        system.pointee.next_in = nextIn
        system.pointee.avail_in = availIn
        system.pointee.next_out = nextOut
        system.pointee.avail_out = availOut
        let status = deflate(system, Z_SYNC_FLUSH)
        nextIn = system.pointee.next_in
        availIn = system.pointee.avail_in
        nextOut = system.pointee.next_out
        availOut = system.pointee.avail_out
        return status
    }

    /// This ends the system stream and frees its allocation.
    public static func end(_ stream: OpaquePointer) -> Int32 {
        let system = UnsafeMutablePointer<z_stream>(stream)
        let status = deflateEnd(system)
        system.deallocate()
        return status
    }
}
