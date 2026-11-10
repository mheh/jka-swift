import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's heap of navigator edges, ordered so the edge of least cost comes off first.
/// The path search of the navigator pushes and pops the edges.
/// Source: oracle/codemp/server/NPCNav/navigator.h:254
// AI: Raven's destructor at navigator.cpp:2705 pops and deletes each edge left in the heap. The class has no deinit.
final class CPriorityQueue {
    // AI: Raven declares a `vector<CEdge*>`. The field is an Array of the optional class, by rule 17.
    private var mHeap: [CEdge?] = []

    /// Source: oracle/codemp/server/NPCNav/navigator.h:259
    init() {}

    /**
    ```
    //////////////////////////////////////////////////////////////////
    // Remove Node And Resort
    //////////////////////////////////////////////////////////////////
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2731
    func Pop() -> CEdge? {
        // TODO: Port CPriorityQueue::Pop
        portMissing("CPriorityQueue::Pop", source: "oracle/codemp/server/NPCNav/navigator.cpp:2731")
    }

    /**
    ```
    //////////////////////////////////////////////////////////////////
    // Standard Iterative Search
    //////////////////////////////////////////////////////////////////
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2716
    func Find(_ npNum: Int32) -> CEdge? {
        // TODO: Port CPriorityQueue::Find
        portMissing("CPriorityQueue::Find", source: "oracle/codemp/server/NPCNav/navigator.cpp:2716")
    }

    /**
    ```
    //////////////////////////////////////////////////////////////////
    // Add New Node And Resort
    //////////////////////////////////////////////////////////////////
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2751
    func Push(_ theEdge: CEdge?) {
        // TODO: Port CPriorityQueue::Push
        portMissing("CPriorityQueue::Push", source: "oracle/codemp/server/NPCNav/navigator.cpp:2751")
    }

    /**
    ```
    //////////////////////////////////////////////////////////////////
    // Find The Node In Question And Resort mHeap Around It
    //////////////////////////////////////////////////////////////////
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2763
    func Update(_ edge: CEdge?) {
        // TODO: Port CPriorityQueue::Update
        portMissing("CPriorityQueue::Update", source: "oracle/codemp/server/NPCNav/navigator.cpp:2763")
    }

    /**
    ```
    //////////////////////////////////////////////////////////////////
    // Just a wrapper for stl empty function.
    //////////////////////////////////////////////////////////////////
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2779
    func Empty() -> Bool {
        // TODO: Port CPriorityQueue::Empty
        portMissing("CPriorityQueue::Empty", source: "oracle/codemp/server/NPCNav/navigator.cpp:2779")
    }
}
