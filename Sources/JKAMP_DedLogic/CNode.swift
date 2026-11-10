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
        // Port-note: Raven's `unsigned long` header is 8 bytes on this build, and no CharBuf read or write gives an 8-byte word.
        // TODO: Port CNode::Save
        portMissing("CNode::Save", source: "oracle/codemp/server/NPCNav/navigator.cpp:385")
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
        // Port-note: Raven's `unsigned long` header is 8 bytes on this build, and no CharBuf read or write gives an 8-byte word.
        // TODO: Port CNode::Load
        portMissing("CNode::Load", source: "oracle/codemp/server/NPCNav/navigator.cpp:426")
    }
}
