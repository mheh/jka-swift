import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's navigator node, one waypoint with its position, its edges, and its rank table to every other node.
/// The navigator holds the nodes in `m_nodes` and reaches each one by its ID.
/// Source: oracle/codemp/server/NPCNav/navigator.h:70
// AI: Raven's destructor at navigator.cpp:111 frees the edges and the rank array. The class has no deinit.
final class CNode {
    /// Source: oracle/codemp/server/NPCNav/navigator.h:72
    private struct edge_t {
        var ID: Int32 = 0
        var cost: Int32 = 0
        var flags: JKAShared.byte = 0
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:79
    // AI: Raven declares a `vector< edge_t >`. The type is an Array, by rule 17.
    private typealias edge_v = [edge_t]

    private var m_position: JKAShared.vec3_t = JKAShared.vec3_t()
    private var m_flags: Int32 = 0
    private var m_radius: Int32 = 0
    private var m_ID: Int32 = 0

    private var m_edges: edge_v = []

    // AI: Raven holds an `int *` that InitRanks fills with `new int[size]`. The field is an Array.
    private var m_ranks: [Int32] = []
    private var m_numEdges: Int32 = 0

    /**
    ```
    -------------------------
    CNode
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:104
    init() {
        self.m_numEdges = 0
        self.m_radius = 0
        self.m_ranks = []
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:125
    static func Create(_ position: JKAShared.vec3_t, _ flags: Int32, _ radius: Int32, _ ID: Int32) -> CNode? {
        let node = CNode()

        node.m_position = position

        node.m_flags = flags
        node.m_ID = ID
        node.m_radius = radius

        return node
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:144
    static func Create() -> CNode? {
        return CNode()
    }

    /**
    ```
    -------------------------
    AddEdge
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:155
    // AI: Raven defaults flags to EFLAG_NONE of navigator.h, which no module of the host declares. The default is its value, 0.
    func AddEdge(_ ID: Int32, _ cost: Int32, _ flags: Int32 = 0) {
        if self.m_numEdges != 0 {//already have at least 1
            //see if it exists already
            for ei in self.m_edges.indices {
                if self.m_edges[ei].ID == ID {//found it
                    self.m_edges[ei].cost = cost
                    self.m_edges[ei].flags = JKAShared.byte(truncatingIfNeeded: flags)
                    return
                }
            }
        }

        var edge = edge_t()

        edge.ID = ID
        edge.cost = cost
        edge.flags = JKAShared.byte(truncatingIfNeeded: flags)

        self.m_edges.append(edge)

        self.m_numEdges += 1
    }

    /**
    ```
    -------------------------
    AddRank
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:214
    func AddRank(_ ID: Int32, _ rank: Int32) {
        self.m_ranks[ID] = rank
    }

    /**
    ```
    -------------------------
    Draw
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:227
    func Draw(_ showRadius: Bool) {
        //rwwFIXMEFIXME: ...
        /*
        CG_DrawNode( m_position, NODE_NORMAL );
        if( showRadius )
        {
            CG_DrawRadius( m_position, m_radius, NODE_NORMAL );
        }
        */
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:94
    func GetID() -> Int32 {
        return self.m_ID
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:95
    // AI: Raven tests the pointer before VectorCopy. An inout vector is never NULL, so the copy is one assignment.
    func GetPosition(_ position: inout JKAShared.vec3_t) {
        position = self.m_position
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:97
    func GetNumEdges() -> Int32 {
        return self.m_numEdges
    }

    /**
    ```
    -------------------------
    GetEdge
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:191
    func GetEdgeNumToNode(_ ID: Int32) -> Int32 {
        var count: Int32 = 0

        for ei in self.m_edges {
            if ei.ID == ID {
                return count
            }

            count += 1
        }
        return -1
    }

    /**
    ```
    -------------------------
    GetEdge
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:244
    func GetEdge(_ edgeNum: Int32) -> Int32 {
        if edgeNum > self.m_numEdges {
            return -1
        }

        var count: Int32 = 0

        for ei in self.m_edges {
            if count == edgeNum {
                return ei.ID
            }

            count += 1
        }

        return -1
    }

    /**
    ```
    -------------------------
    GetEdgeCost
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:271
    func GetEdgeCost(_ edgeNum: Int32) -> Int32 {
        if edgeNum > self.m_numEdges {
            return Q3_INFINITE // return -1;
        }

        var count: Int32 = 0

        for ei in self.m_edges {
            if count == edgeNum {
                return ei.cost
            }

            count += 1
        }

        return Q3_INFINITE // return -1;
    }

    /**
    ```
    -------------------------
    GetEdgeFlags
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:298
    func GetEdgeFlags(_ edgeNum: Int32) -> JKAShared.byte {
        if edgeNum > self.m_numEdges {
            return 0
        }

        var count: Int32 = 0

        for ei in self.m_edges {
            if count == edgeNum {
                return ei.flags
            }

            count += 1
        }

        return 0
    }

    /**
    ```
    -------------------------
    SetEdgeFlags
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:325
    func SetEdgeFlags(_ edgeNum: Int32, _ newFlags: Int32) {
        if edgeNum > self.m_numEdges {
            return
        }

        var count: Int32 = 0

        for ei in self.m_edges.indices {
            if count == edgeNum {
                self.m_edges[ei].flags = JKAShared.byte(truncatingIfNeeded: newFlags)
                return
            }

            count += 1
        }
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:103
    func GetRadius() -> Int32 {
        return self.m_radius
    }

    /**
    ```
    -------------------------
    InitRanks
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:351
    func InitRanks(_ size: Int32) {
        //Clear it if it's already allocated
        self.m_ranks = []

        self.m_ranks = Array(repeating: -1, count: Int(size))
    }

    /**
    ```
    -------------------------
    GetRank
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:371
    func GetRank(_ ID: Int32) -> Int32 {
        return self.m_ranks[ID]
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:108
    func GetFlags() -> Int32 {
        return self.m_flags
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:109
    func AddFlag(_ newFlag: Int32) {
        self.m_flags |= newFlag
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:110
    func RemoveFlag(_ oldFlag: Int32) {
        self.m_flags &= ~oldFlag
    }

    /**
    ```
    -------------------------
    Save
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:385
    func Save(_ numNodes: Int32, _ file: JKAShared.fileHandle_t) -> Int32 {
        // AI: Raven writes each value through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        var value = CharBuf(Int32.byteCount)

        //Write out the header
        // AI: Raven writes an `unsigned long` of NODE_HEADER_ID of navigator.h, 4 bytes on WinDed. The body writes its value, 'NODE'.
        value.withMutableSlots { $0[int: 0] = 0x4E4F_4445 }
        _ = FS_Write(value, Int32(UInt32.byteCount), file)

        //Write out the basic information
        for i in 0..<3 {
            value.withMutableSlots { $0[float: 0] = self.m_position[i] }
            _ = FS_Write(value, Int32(Float.byteCount), file)
        }

        value.withMutableSlots { $0[int: 0] = self.m_flags }
        _ = FS_Write(value, Int32(Int32.byteCount), file)
        value.withMutableSlots { $0[int: 0] = self.m_ID }
        _ = FS_Write(value, Int32(Int32.byteCount), file)
        value.withMutableSlots { $0[int: 0] = self.m_radius }
        _ = FS_Write(value, Int32(Int32.byteCount), file)

        //Write out the edge information
        value.withMutableSlots { $0[int: 0] = self.m_numEdges }
        _ = FS_Write(value, Int32(Int32.byteCount), file)

        // AI: Raven writes each `edge_t` whole, 12 bytes with ID at 0, cost at 4, and flags at 8. The body writes the same bytes.
        // Port-note: Raven writes the three padding bytes of the record uninitialized. The body writes them as zero.
        var record = CharBuf(12)
        for ei in self.m_edges {
            record.zero()
            record.withMutableSlots {
                $0[int: 0] = ei.ID
                $0[int: 4] = ei.cost
                $0[byte: 8] = ei.flags
            }
            _ = FS_Write(record, 12, file)
        }

        //Write out the node ranks
        value.withMutableSlots { $0[int: 0] = numNodes }
        _ = FS_Write(value, Int32(Int32.byteCount), file)

        var i: Int32 = 0
        while i < numNodes {
            value.withMutableSlots { $0[int: 0] = self.m_ranks[i] }
            _ = FS_Write(value, Int32(Int32.byteCount), file)
            i += 1
        }

        return 1
    }

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:426
    func Load(_ numNodes: Int32, _ file: JKAShared.fileHandle_t) -> Int32 {
        // AI: Raven reads each value through its address. The read fills a CharBuf of the value's bytes, and the body takes the value from it.
        var value = CharBuf(Int32.byteCount)

        // AI: Raven reads an `unsigned long` header, 4 bytes on WinDed.
        _ = FS_Read(&value, Int32(UInt32.byteCount), file)

        //Validate the header
        // AI: Raven compares with NODE_HEADER_ID of navigator.h, which no module of the host declares. The body reads its value, 'NODE'.
        if value.withSlots({ $0[int: 0] }) != 0x4E4F_4445 {
            return 0
        }

        //Get the basic information
        for i in 0..<3 {
            _ = FS_Read(&value, Int32(Float.byteCount), file)
            self.m_position[i] = value.withSlots { $0[float: 0] }
        }

        _ = FS_Read(&value, Int32(Int32.byteCount), file)
        self.m_flags = value.withSlots { $0[int: 0] }
        _ = FS_Read(&value, Int32(Int32.byteCount), file)
        self.m_ID = value.withSlots { $0[int: 0] }
        _ = FS_Read(&value, Int32(Int32.byteCount), file)
        self.m_radius = value.withSlots { $0[int: 0] }

        //Get the edge information
        _ = FS_Read(&value, Int32(Int32.byteCount), file)
        self.m_numEdges = value.withSlots { $0[int: 0] }

        // AI: Raven reads each `edge_t` whole, 12 bytes with ID at 0, cost at 4, and flags at 8. The body takes the three fields from the bytes.
        var record = CharBuf(12)
        var i: Int32 = 0
        while i < self.m_numEdges {
            var edge = edge_t()

            _ = FS_Read(&record, 12, file)
            record.withSlots {
                edge.ID = $0[int: 0]
                edge.cost = $0[int: 4]
                edge.flags = $0[byte: 8]
            }

            self.m_edges.append(edge)
            i += 1
        }

        //Read the node ranks
        _ = FS_Read(&value, Int32(Int32.byteCount), file)
        let numRanks = value.withSlots { $0[int: 0] }

        //Allocate the memory
        self.InitRanks(numRanks)

        i = 0
        while i < numRanks {
            _ = FS_Read(&value, Int32(Int32.byteCount), file)
            self.m_ranks[i] = value.withSlots { $0[int: 0] }
            i += 1
        }

        return 1
    }
}
