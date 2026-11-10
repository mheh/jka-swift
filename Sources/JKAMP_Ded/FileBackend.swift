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
    public static func fread(_ buffer: Slots<JKAShared.byte>, at offset: Int32, _ size: Int32, _ count: Int32, _ stream: OpaquePointer?) -> Int32 {
        let base = buffer.base + Int(offset)
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
    public static func fwrite(_ buffer: Slots<JKAShared.byte>, at offset: Int32, _ size: Int32, _ count: Int32, _ stream: OpaquePointer?) -> Int32 {
        let base = buffer.base + Int(offset)
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
