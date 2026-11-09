import Foundation
internal import CJKAMP_Ded
import JKAShared

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:30
/// A view over one `zoneHeader_t`, the header that Raven's zone puts before each block.
// AI: Raven defines zoneHeader_t inside z_memman_pc.cpp, so no view is generated. The hand view gives the fields that the zone bodies read.
public struct ZoneHeader: Hashable {
    let raw: UnsafeMutablePointer<zoneHeader_t>

    init(raw: UnsafeMutablePointer<zoneHeader_t>) { self.raw = raw }

    /// The size of one header in bytes, Raven's `sizeof(zoneHeader_t)`.
    public static let byteCount = MemoryLayout<zoneHeader_t>.size

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:32
    public var iMagic: Int32 {
        get { self.raw.pointee.iMagic }
        nonmutating set { self.raw.pointee.iMagic = newValue }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:33
    public var eTag: JKAShared.memtag_t {
        get { Int32(self.raw.pointee.eTag) }
        nonmutating set { self.raw.pointee.eTag = CChar(truncatingIfNeeded: newValue) }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:34
    public var iSize: Int32 {
        get { self.raw.pointee.iSize }
        nonmutating set { self.raw.pointee.iSize = newValue }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:35
    public var pNext: ZoneHeader? {
        get { self.raw.pointee.pNext.map { ZoneHeader(raw: $0) } }
        nonmutating set { self.raw.pointee.pNext = newValue?.raw }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:36
    public var pPrev: ZoneHeader? {
        get { self.raw.pointee.pPrev.map { ZoneHeader(raw: $0) } }
        nonmutating set { self.raw.pointee.pPrev = newValue?.raw }
    }
}

// MARK: - Block addresses

extension ZoneHeader {
    /// Raven's `((zoneHeader_t *)pvAddress) - 1`, the header before the block that `Z_Malloc` returned.
    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:315
    // AI: Raven steps a zoneHeader_t pointer back by one record. The initializer does the step in the view target.
    public init(block pvAddress: OpaquePointer) {
        self.raw = UnsafeMutablePointer<zoneHeader_t>(pvAddress) - 1
    }

    /// Raven's `&pMemory[1]`, the block that starts after the header.
    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:306
    // AI: Raven takes the address of the record after the header. The accessor does the step in the view target.
    public var block: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(self.raw + 1)
    }
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:39
/// A view over one `zoneTail_t`, the magic number that Raven's zone puts after each block.
/// The tail starts at any byte, so every read and write is unaligned.
// AI: Raven defines zoneTail_t inside z_memman_pc.cpp, so no view is generated. The hand view gives the one field.
public struct ZoneTail {
    let raw: UnsafeMutableRawPointer

    /// The size of one tail in bytes, Raven's `sizeof(zoneTail_t)`.
    public static let byteCount = MemoryLayout<zoneTail_t>.size

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:41
    public var iMagic: Int32 {
        get { self.raw.loadUnaligned(as: Int32.self) }
        nonmutating set { self.raw.storeBytes(of: newValue, as: Int32.self) }
    }
}

/// Raven's `(zoneTail_t*) ( (char*)pHeader + sizeof(*pHeader) + pHeader->iSize )`, the tail after a block of `iSize` bytes.
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:45
// AI: Raven computes the tail address from the header address and the block size. The function does the computation in the view target.
public func ZoneTailFromHeader(_ pHeader: ZoneHeader) -> ZoneTail {
    ZoneTail(raw: UnsafeMutableRawPointer(pHeader.raw) + ZoneHeader.byteCount + Int(pHeader.iSize))
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:55
/// A view over one `zoneStats_t`, the counts of Raven's zone.
// AI: Raven defines zoneStats_t inside z_memman_pc.cpp, so no view is generated. The hand view gives the fields that the zone bodies read.
public struct ZoneStats {
    let raw: UnsafeMutablePointer<zoneStats_t>

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:57
    public var iCount: Int32 {
        get { self.raw.pointee.iCount }
        nonmutating set { self.raw.pointee.iCount = newValue }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:58
    public var iCurrent: Int32 {
        get { self.raw.pointee.iCurrent }
        nonmutating set { self.raw.pointee.iCurrent = newValue }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:59
    public var iPeak: Int32 {
        get { self.raw.pointee.iPeak }
        nonmutating set { self.raw.pointee.iPeak = newValue }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:64
    public var iSizesPerTag: Slots<Int32> {
        Slots<Int32>(scalars: UnsafeMutableRawPointer(self.raw.pointer(to: \.iSizesPerTag)!), count: Int(TAG_COUNT))
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:65
    public var iCountsPerTag: Slots<Int32> {
        Slots<Int32>(scalars: UnsafeMutableRawPointer(self.raw.pointer(to: \.iCountsPerTag)!), count: Int(TAG_COUNT))
    }
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:69
/// A view over one `zone_t`, the counts and the list head of Raven's zone.
// AI: Raven defines zone_t inside z_memman_pc.cpp, so no view is generated. The hand view gives the two fields.
public struct Zone {
    let raw: UnsafeMutablePointer<zone_t>

    /// One zeroed `zone_t` that the world owns, Raven's `zone_t TheZone = {0}`.
    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:77
    // AI: Raven keeps TheZone at file scope. The world owns one zeroed allocation, the form of an EngineStorage record.
    public static func record() -> Zone {
        let raw = UnsafeMutablePointer<zone_t>.allocate(capacity: 1)
        raw.initialize(to: zone_t())
        return Zone(raw: raw)
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:71
    public var Stats: ZoneStats { ZoneStats(raw: self.raw.pointer(to: \.Stats)!) }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:72
    public var Header: ZoneHeader { ZoneHeader(raw: self.raw.pointer(to: \.Header)!) }

    /// Raven's `memset(&TheZone, 0, sizeof(TheZone))`, every byte of the record to zero.
    public func clear() {
        self.raw.pointee = zone_t()
    }
}

/// The C library allocator under Raven's zone, `malloc`, `calloc`, and `free`, typed to the zone header.
/// A failed allocation is nil, so `Z_Malloc` keeps Raven's recovery loop.
// AI: Raven calls malloc, calloc, and free and casts the result to zoneHeader_t *. The backend gives the header view to the logic target.
public enum ZoneBackend {
    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:186
    public static func malloc(_ size: Int32) -> ZoneHeader? {
        Foundation.malloc(Int(size)).map { ZoneHeader(raw: $0.assumingMemoryBound(to: zoneHeader_t.self)) }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:184
    public static func calloc(_ count: Int32, _ size: Int32) -> ZoneHeader? {
        Foundation.calloc(Int(count), Int(size)).map { ZoneHeader(raw: $0.assumingMemoryBound(to: zoneHeader_t.self)) }
    }

    /// Source: oracle/codemp/qcommon/z_memman_pc.cpp:365
    public static func free(_ pMemory: ZoneHeader) {
        Foundation.free(pMemory.raw)
    }
}
