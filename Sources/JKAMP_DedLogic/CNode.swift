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
        // TODO: Port CNode::CNode
        portMissing("CNode::CNode", source: "oracle/codemp/server/NPCNav/navigator.cpp:104")
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
        // TODO: Port CNode::Create
        portMissing("CNode::Create", source: "oracle/codemp/server/NPCNav/navigator.cpp:125")
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
        // TODO: Port CNode::Create
        portMissing("CNode::Create", source: "oracle/codemp/server/NPCNav/navigator.cpp:144")
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
        // TODO: Port CNode::AddEdge
        portMissing("CNode::AddEdge", source: "oracle/codemp/server/NPCNav/navigator.cpp:155")
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
        // TODO: Port CNode::AddRank
        portMissing("CNode::AddRank", source: "oracle/codemp/server/NPCNav/navigator.cpp:214")
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
        // TODO: Port CNode::Draw
        portMissing("CNode::Draw", source: "oracle/codemp/server/NPCNav/navigator.cpp:227")
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
        // TODO: Port CNode::GetEdgeNumToNode
        portMissing("CNode::GetEdgeNumToNode", source: "oracle/codemp/server/NPCNav/navigator.cpp:191")
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
        // TODO: Port CNode::GetEdge
        portMissing("CNode::GetEdge", source: "oracle/codemp/server/NPCNav/navigator.cpp:244")
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
        // TODO: Port CNode::GetEdgeCost
        portMissing("CNode::GetEdgeCost", source: "oracle/codemp/server/NPCNav/navigator.cpp:271")
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
        // TODO: Port CNode::GetEdgeFlags
        portMissing("CNode::GetEdgeFlags", source: "oracle/codemp/server/NPCNav/navigator.cpp:298")
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
        // TODO: Port CNode::SetEdgeFlags
        portMissing("CNode::SetEdgeFlags", source: "oracle/codemp/server/NPCNav/navigator.cpp:325")
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
        // TODO: Port CNode::InitRanks
        portMissing("CNode::InitRanks", source: "oracle/codemp/server/NPCNav/navigator.cpp:351")
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
        // TODO: Port CNode::GetRank
        portMissing("CNode::GetRank", source: "oracle/codemp/server/NPCNav/navigator.cpp:371")
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
        // TODO: Port CNode::Load
        portMissing("CNode::Load", source: "oracle/codemp/server/NPCNav/navigator.cpp:426")
    }
}
