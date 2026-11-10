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
        let edge = self.mHeap.first!

        //pop_mHeap will move the node at the front to the position N
        //and then sort the mHeap to make positions 1 through N-1 correct
        //(STL makes no assumptions about your data and doesn't want to change
        //the size of the container.)
        pop_heap(&self.mHeap, self.mHeap.count, NodeTotalGreater())

        //pop_back() will actually remove the last element from the mHeap
        //now the mHeap is sorted for positions 1 through N
        self.mHeap.removeLast()

        return (edge)
    }

    /**
    ```
    //////////////////////////////////////////////////////////////////
    // Standard Iterative Search
    //////////////////////////////////////////////////////////////////
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2716
    // Port-note: Rule 20. No file calls Find, because CalculatePath at navigator.cpp:814 calls only Push and Pop.
    func Find(_ npNum: Int32) -> CEdge? {
        for HeapIter in self.mHeap {
            if HeapIter!.m_first == npNum {
                return HeapIter
            }
        }
        return nil
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
        //Pushes the node onto the back of the mHeap
        self.mHeap.append(theEdge)

        //Sorts the new element into the mHeap
        push_heap(&self.mHeap, self.mHeap.count, NodeTotalGreater())
    }

    /**
    ```
    //////////////////////////////////////////////////////////////////
    // Find The Node In Question And Resort mHeap Around It
    //////////////////////////////////////////////////////////////////
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2763
    // Port-note: Rule 20. No file calls Update, because CalculatePath at navigator.cpp:814 calls only Push and Pop.
    func Update(_ edge: CEdge?) {
        var i = 0
        while i != self.mHeap.count {
            if self.mHeap[i]!.m_first == edge!.m_first {
                //Found node - resort from this position in the mHeap
                //(its total value was changed before this function was called)
                push_heap(&self.mHeap, i + 1, NodeTotalGreater())
                return
            }
            i += 1
        }
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
        return self.mHeap.isEmpty
    }

    /// Raven's `std::push_heap` of the MSVC library over the elements `0 ..< last`.
    /// It holds the last element and moves the hole up while the parent compares before the held element, then stores the held element.
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2757
    // AI: Raven calls std::push_heap of the MSVC C++ library. The function follows the Dinkumware steps of that call, so edges of equal cost keep that order.
    // Port-note: The step order is from the library's published algorithm, and it is not checked against Raven's binary.
    private func push_heap(_ heap: inout [CEdge?], _ last: Int, _ comp: NodeTotalGreater) {
        let value = heap[last - 1]
        var holeIndex = last - 1
        let topIndex = 0
        var parent = (holeIndex - 1) / 2
        while holeIndex > topIndex && comp(heap[parent], value) {
            heap[holeIndex] = heap[parent]
            holeIndex = parent
            parent = (holeIndex - 1) / 2
        }
        heap[holeIndex] = value
    }

    /// Raven's `std::pop_heap` of the MSVC library over the elements `0 ..< last`.
    /// It holds the last element, stores the first in the last place, and moves the hole down to a leaf through the preferred child.
    /// The held element then moves up from that leaf by the `push_heap` step.
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2737
    // AI: Raven calls std::pop_heap of the MSVC C++ library. The function follows the Dinkumware steps of that call, so edges of equal cost keep that order.
    // Port-note: The step order is from the library's published algorithm, and it is not checked against Raven's binary.
    private func pop_heap(_ heap: inout [CEdge?], _ last: Int, _ comp: NodeTotalGreater) {
        let len = last - 1
        let value = heap[len]
        heap[len] = heap[0]
        var holeIndex = 0
        let topIndex = 0
        var secondChild = 2 * holeIndex + 2
        while secondChild < len {
            if comp(heap[secondChild], heap[secondChild - 1]) {
                secondChild -= 1
            }
            heap[holeIndex] = heap[secondChild]
            holeIndex = secondChild
            secondChild = 2 * secondChild + 2
        }
        if secondChild == len {
            heap[holeIndex] = heap[secondChild - 1]
            holeIndex = secondChild - 1
        }
        var parent = (holeIndex - 1) / 2
        while holeIndex > topIndex && comp(heap[parent], value) {
            heap[holeIndex] = heap[parent]
            holeIndex = parent
            parent = (holeIndex - 1) / 2
        }
        heap[holeIndex] = value
    }
}
