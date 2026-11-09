#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(ucrt)
import ucrt
#endif
import JKAShared

// MARK: - Byte fill at an offset

/// Raven's `Com_Memset( o, val, count )` through a `char *` that points into a buffer at a byte offset.
/// Source: oracle/codemp/qcommon/common.cpp:529
// AI: Raven fills the bytes from a pointer into the buffer. The function takes the buffer and the byte offset of that pointer.
public func Com_Memset(_ buf: inout CharBuf, _ val: Int32, _ count: some BinaryInteger, at offset: some BinaryInteger) {
    var index = Int(offset)
    let end = Int(offset) + Int(count)
    while index < end {
        buf[index] = val
        index += 1
    }
}

// MARK: - The C library under common.cpp

/// The C library functions that common.cpp calls on raw memory and on a `struct tm` pointer.
/// Each call names the C library module of its platform, because the member of the same name hides the C function.
// AI: Raven calls memcpy, memset, localtime, and asctime on raw pointers. The backend makes the calls in the view target.
public enum CommonBackend {
    /// Source: oracle/codemp/qcommon/common.cpp:1817
    public static func memcpy(_ dest: OpaquePointer?, _ src: OpaquePointer?, _ count: CUnsignedLong) {
        #if canImport(Darwin)
        _ = Darwin.memcpy(UnsafeMutableRawPointer(dest), UnsafeRawPointer(src), Int(count))
        #elseif canImport(Glibc)
        _ = Glibc.memcpy(UnsafeMutableRawPointer(dest), UnsafeRawPointer(src), Int(count))
        #elseif canImport(Musl)
        _ = Musl.memcpy(UnsafeMutableRawPointer(dest), UnsafeRawPointer(src), Int(count))
        #elseif canImport(ucrt)
        _ = ucrt.memcpy(UnsafeMutableRawPointer(dest), UnsafeRawPointer(src), Int(count))
        #endif
    }

    /// Source: oracle/codemp/qcommon/common.cpp:1822
    public static func memset(_ dest: OpaquePointer?, _ val: Int32, _ count: CUnsignedLong) {
        #if canImport(Darwin)
        _ = Darwin.memset(UnsafeMutableRawPointer(dest), val, Int(count))
        #elseif canImport(Glibc)
        _ = Glibc.memset(UnsafeMutableRawPointer(dest), val, Int(count))
        #elseif canImport(Musl)
        _ = Musl.memset(UnsafeMutableRawPointer(dest), val, Int(count))
        #elseif canImport(ucrt)
        _ = ucrt.memset(UnsafeMutableRawPointer(dest), val, Int(count))
        #endif
    }

    /// Raven's `asctime( localtime( &aclock ) )`, the text of the local time with its newline.
    /// Source: oracle/codemp/qcommon/common.cpp:176
    public static func asctime(_ aclock: time_t) -> String {
        var clock = aclock
        #if canImport(Darwin)
        return String(cString: Darwin.asctime(Darwin.localtime(&clock)))
        #elseif canImport(Glibc)
        return String(cString: Glibc.asctime(Glibc.localtime(&clock)))
        #elseif canImport(Musl)
        return String(cString: Musl.asctime(Musl.localtime(&clock)))
        #elseif canImport(ucrt)
        return String(cString: ucrt.asctime(ucrt.localtime(&clock)))
        #endif
    }
}
