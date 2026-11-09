// An `internal import` still loads the C module into every client, and a client that also loads CJKAMP_Ded then fails on the two `struct z_stream_s` records.
@_implementationOnly import CJKAZlib

/// The inflate calls of the system zlib, for `ZipBackend` of the dedicated server view target.
/// The stream of the system zlib is a C allocation behind an `OpaquePointer`, and every position and count crosses as a value.
/// Each status is the system zlib's number, and `ZipBackend` maps it to the `EStatus` of Raven's zlib32.
// AI: Raven links his own zlib32. The port links the system zlib, whose `struct z_stream_s` clashes with his, so the calls stand in this module alone.
public enum SystemInflate {
    /// The system `Z_OK`.
    public static let ok = Z_OK

    /// The system `Z_STREAM_END`.
    public static let streamEnd = Z_STREAM_END

    /// The system `Z_BUF_ERROR`.
    public static let bufError = Z_BUF_ERROR

    /// The system `Z_DATA_ERROR`.
    public static let dataError = Z_DATA_ERROR

    /// The system `Z_STREAM_ERROR`.
    public static let streamError = Z_STREAM_ERROR

    /// This allocates a system stream and starts it, a raw deflate stream with no zlib header when `raw` is true.
    /// The stream is nil when the start fails, and the status says why.
    public static func start(raw: Bool) -> (stream: OpaquePointer?, status: Int32) {
        let stream = UnsafeMutablePointer<z_stream>.allocate(capacity: 1)
        stream.initialize(to: z_stream())
        let windowBits = raw ? -MAX_WBITS : MAX_WBITS
        let status = inflateInit2_(stream, windowBits, zlibVersion(), Int32(MemoryLayout<z_stream>.size))
        if status != Z_OK {
            stream.deallocate()
            return (nil, status)
        }
        return (OpaquePointer(stream), status)
    }

    /// This runs one `inflate` with `Z_SYNC_FLUSH` and moves the four positions and counts as the call moved them.
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
        let status = inflate(system, Z_SYNC_FLUSH)
        nextIn = system.pointee.next_in
        availIn = system.pointee.avail_in
        nextOut = system.pointee.next_out
        availOut = system.pointee.avail_out
        return status
    }

    /// This ends the system stream and frees its allocation.
    public static func end(_ stream: OpaquePointer) -> Int32 {
        let system = UnsafeMutablePointer<z_stream>(stream)
        let status = inflateEnd(system)
        system.deallocate()
        return status
    }
}
