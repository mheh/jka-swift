import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/**
```
//////////////////////////////////////////////////////////////////
// Helper pop_mHeap algorithm class
//////////////////////////////////////////////////////////////////
```
*/
/// Raven's heap order of the navigator edges, the comparator that `CPriorityQueue` hands to `pop_heap` and `push_heap`.
/// The edge of greater cost sorts first, so the heap gives the edge of least cost.
/// Source: oracle/codemp/server/NPCNav/navigator.cpp:2693
final class NodeTotalGreater {
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2696
    // AI: Raven defines `operator()`. The method is `callAsFunction`, so a call reads `NodeTotalGreater()(first, second)`.
    func callAsFunction(_ first: CEdge?, _ second: CEdge?) -> Bool {
        return (first!.m_cost > second!.m_cost)
    }
}
