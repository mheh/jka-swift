import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's mini heap, one byte block that hands out space from its start and resets in one step.
/// `G2VertSpaceServer` holds one for the transformed vertices of a Ghoul2 trace.
/// Source: oracle/codemp/qcommon/MiniHeap.h:5
// AI: Raven's destructor at MiniHeap.h:31 frees `mHeap`. The class drops it, because it only frees memory.
final class CMiniHeap {
    private var mHeap: Slots<JKAShared.byte>? = nil
    private var mCurrentHeap: Slots<JKAShared.byte>? = nil
    private var mSize: Int32 = 0

// reset the heap back to the start
    /// Source: oracle/codemp/qcommon/MiniHeap.h:14
    func ResetHeap() {
        // TODO: Port CMiniHeap::ResetHeap
        portMissing("CMiniHeap::ResetHeap", source: "oracle/codemp/qcommon/MiniHeap.h:14")
    }

// initialise the heap
    /// Source: oracle/codemp/qcommon/MiniHeap.h:20
    init(_ size: Int32) {
        // TODO: Port CMiniHeap::CMiniHeap
        portMissing("CMiniHeap::CMiniHeap", source: "oracle/codemp/qcommon/MiniHeap.h:20")
    }

// give me some space from the heap please
    /// Source: oracle/codemp/qcommon/MiniHeap.h:40
    func MiniHeapAlloc(_ size: Int32) -> Slots<JKAShared.byte>? {
        // TODO: Port CMiniHeap::MiniHeapAlloc
        portMissing("CMiniHeap::MiniHeapAlloc", source: "oracle/codemp/qcommon/MiniHeap.h:40")
    }
}
