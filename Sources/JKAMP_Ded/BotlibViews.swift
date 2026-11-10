@preconcurrency internal import CJKAMP_Ded
import JKAShared

// MARK: - The travel time and cache tables of the AAS world

extension Aas {
    /// Raven's `aasworld.areatraveltimes[i][l]`, the travel times from each reversed link of area `i` to its reachability `l`, with no bound.
    /// Source: oracle/codemp/botlib/be_aas_route.cpp:568
    // AI: Raven indexes a three-level pointer table in one block. The accessor steps the two pointer levels in the view target, row N6.
    public func areatraveltimes(_ i: Int32, _ l: Int32) -> Slots<UInt16> {
        Slots(scalars: UnsafeMutableRawPointer(self.raw.pointee.areatraveltimes![Int(i)]![Int(l)]!), count: Int.max)
    }

    /// Raven's `aasworld.areatraveltimes[i] = (unsigned short **) ptr`, the row of reachability pointers of area `i` at a byte of the block.
    /// Source: oracle/codemp/botlib/be_aas_route.cpp:521
    // AI: Raven stores a cast of a byte pointer into the table. The function does the store in the view target, row N6.
    public func setAreatraveltimes(_ i: Int32, to block: UnsafeMutableRawPointer) {
        self.raw.pointee.areatraveltimes![Int(i)] = block.assumingMemoryBound(to: UnsafeMutablePointer<UInt16>?.self)
    }

    /// Raven's `aasworld.areatraveltimes[i][l] = (unsigned short *) ptr`, the travel times of reachability `l` of area `i` at a byte of the block.
    /// Source: oracle/codemp/botlib/be_aas_route.cpp:526
    // AI: Raven stores a cast of a byte pointer into the table. The function does the store in the view target, row N6.
    public func setAreatraveltimes(_ i: Int32, _ l: Int32, to block: UnsafeMutableRawPointer) {
        self.raw.pointee.areatraveltimes![Int(i)]![Int(l)] = block.assumingMemoryBound(to: UInt16.self)
    }

    /// Raven's `aasworld.clusterareacache[i][j]`, the first routing cache of area `j` of cluster `i`, or nil.
    /// Source: oracle/codemp/botlib/be_aas_route.cpp:242
    // AI: Raven indexes a two-level pointer table in one block. The accessor steps the pointer level in the view target, row N6.
    public func clusterareacache(_ i: Int32, _ j: Int32) -> AasRoutingcache? {
        self.raw.pointee.clusterareacache![Int(i)]![Int(j)].map { AasRoutingcache(handle: OpaquePointer($0)) }
    }

    /// Raven's `aasworld.clusterareacache[i][j] = cache`, the store of the first routing cache of area `j` of cluster `i`.
    /// Source: oracle/codemp/botlib/be_aas_route.cpp:247
    // AI: Raven stores through a two-level pointer table. The function does the store in the view target, row N6.
    public func setClusterareacache(_ i: Int32, _ j: Int32, to cache: AasRoutingcache?) {
        self.raw.pointee.clusterareacache![Int(i)]![Int(j)] = cache.map { UnsafeMutablePointer<aas_routingcache_t>($0.handle) }
    }

    /// Raven's `aasworld.clusterareacache[i] = (aas_routingcache_t **) ptr`, the row of cache pointers of cluster `i` at a byte of the block.
    /// Source: oracle/codemp/botlib/be_aas_route.cpp:792
    // AI: Raven stores a cast of a byte pointer into the table. The function does the store in the view target, row N6.
    public func setClusterareacache(_ i: Int32, to block: UnsafeMutableRawPointer) {
        self.raw.pointee.clusterareacache![Int(i)] = block.assumingMemoryBound(to: UnsafeMutablePointer<aas_routingcache_t>?.self)
    }
}

// MARK: - The word before a botlib block

extension Slots where Element == UInt32 {
    /// Raven's `(unsigned long int *) ((char *) ptr - sizeof(unsigned long int))`, the identifier word before a block of GetMemory.
    /// The word has the 32 bits of WinDed, the width of the botlib's `unsigned long`.
    /// Source: oracle/codemp/botlib/l_memory.cpp:410
    // AI: Raven steps a byte pointer back by one word. The initializer does the step in the view target, the form of ZoneHeader(block:), row D12.
    public init(wordBefore block: OpaquePointer) {
        self.init(scalars: UnsafeMutableRawPointer(block) - MemoryLayout<UInt32>.stride, count: 1)
    }
}
