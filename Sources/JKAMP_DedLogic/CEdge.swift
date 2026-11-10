import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's navigator edge, one connection between two nodes and its cost.
/// The navigator and its priority queue hold edges by reference.
/// Source: oracle/codemp/server/NPCNav/navigator.h:50
// AI: Raven's destructor at navigator.cpp:94 has an empty body. The class has no deinit.
final class CEdge {
    var m_first: Int32 = 0
    var m_second: Int32 = 0
    var m_cost: Int32 = 0

    /**
    ```
    -------------------------
    CEdge
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:82
    init() {
        // TODO: Port CEdge::CEdge
        portMissing("CEdge::CEdge", source: "oracle/codemp/server/NPCNav/navigator.cpp:82")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:87
    init(_ first: Int32, _ second: Int32, _ cost: Int32) {
        // TODO: Port CEdge::CEdge
        portMissing("CEdge::CEdge", source: "oracle/codemp/server/NPCNav/navigator.cpp:87")
    }
}
