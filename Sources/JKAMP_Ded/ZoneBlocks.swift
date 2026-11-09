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
import JKAShared

// MARK: - Block addresses

extension ZoneHeader {
    /// Raven's `((zoneHeader_t *)pvAddress) - 1`, the header before the block that `Z_Malloc` returned.
    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:315
    // AI: Raven steps a zoneHeader_t pointer back by one record. The initializer does the step in the view target.
    public init(block pvAddress: OpaquePointer) {
        self.init(raw: UnsafeMutablePointer<zoneHeader_t>(pvAddress) - 1)
    }

    /// Raven's `&pMemory[1]`, the block that starts after the header.
    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:306
    // AI: Raven takes the address of the record after the header. The accessor does the step in the view target.
    public var block: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(self.raw + 1)
    }
}

/// Raven's `(zoneTail_t*) ( (char*)pHeader + sizeof(*pHeader) + pHeader->iSize )`, the tail after a block of `iSize` bytes.
/// The tail starts at any byte, as Raven's does.
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:45
// AI: Raven computes the tail address from the header address and the block size. The function does the computation in the view target.
public func ZoneTailFromHeader(_ pHeader: ZoneHeader) -> ZoneTail {
    ZoneTail(UnsafeMutableRawPointer(pHeader.raw) + ZoneHeader.byteCount + Int(pHeader.iSize))
}

/// The C library allocator under Raven's zone, `malloc`, `calloc`, and `free`, typed to the zone header.
/// A failed allocation is nil, so `Z_Malloc` keeps Raven's recovery loop.
/// Each call names the C library module of its platform, because the member of the same name hides the C function.
// AI: Raven calls malloc, calloc, and free and casts the result to zoneHeader_t *. The backend gives the header view to the logic target.
public enum ZoneBackend {
    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:186
    public static func malloc(_ size: Int32) -> ZoneHeader? {
        #if canImport(Darwin)
        let block = Darwin.malloc(Int(size))
        #elseif canImport(Glibc)
        let block = Glibc.malloc(Int(size))
        #elseif canImport(Musl)
        let block = Musl.malloc(Int(size))
        #elseif canImport(ucrt)
        let block = ucrt.malloc(Int(size))
        #endif
        return block.map { ZoneHeader($0) }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:184
    public static func calloc(_ count: Int32, _ size: Int32) -> ZoneHeader? {
        #if canImport(Darwin)
        let block = Darwin.calloc(Int(count), Int(size))
        #elseif canImport(Glibc)
        let block = Glibc.calloc(Int(count), Int(size))
        #elseif canImport(Musl)
        let block = Musl.calloc(Int(count), Int(size))
        #elseif canImport(ucrt)
        let block = ucrt.calloc(Int(count), Int(size))
        #endif
        return block.map { ZoneHeader($0) }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:365
    public static func free(_ pMemory: ZoneHeader) {
        #if canImport(Darwin)
        Darwin.free(pMemory.raw)
        #elseif canImport(Glibc)
        Glibc.free(pMemory.raw)
        #elseif canImport(Musl)
        Musl.free(pMemory.raw)
        #elseif canImport(ucrt)
        ucrt.free(pMemory.raw)
        #endif
    }
}
