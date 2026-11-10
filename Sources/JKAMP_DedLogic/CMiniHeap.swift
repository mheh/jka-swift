import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's mini heap, one byte block that hands out space from its start and resets in one step.
/// `G2VertSpaceServer` holds one for the transformed vertices of a Ghoul2 trace.
/// Source: oracle/codemp/qcommon/MiniHeap.h:5
final class CMiniHeap {
    private var mHeap: Slots<JKAShared.byte>? = nil
    private var mCurrentHeap: Slots<JKAShared.byte>? = nil
    private var mSize: Int32 = 0

// reset the heap back to the start
    /// Source: oracle/codemp/qcommon/MiniHeap.h:14
    func ResetHeap() {
        self.mCurrentHeap = self.mHeap
    }

// initialise the heap
    /// Source: oracle/codemp/qcommon/MiniHeap.h:20
    init(_ size: Int32) {
        self.mHeap = Slots<JKAShared.byte>.malloc(size)
        self.mSize = size
        if self.mHeap != nil {
            self.ResetHeap()
        }
    }

// free up the heap
    /// Source: oracle/codemp/qcommon/MiniHeap.h:31
    deinit {
        if let mHeap = self.mHeap {
            mHeap.free()
        }
    }

// give me some space from the heap please
    /// Source: oracle/codemp/qcommon/MiniHeap.h:40
    func MiniHeapAlloc(_ size: Int32) -> Slots<JKAShared.byte>? {
        // AI: Raven subtracts the two heap addresses. The used size is the count of the heap less the count of the tail.
        if size < (self.mSize - Int32(self.mHeap!.count - self.mCurrentHeap!.count)) {
            let tempAddress = self.mCurrentHeap
            self.mCurrentHeap = self.mCurrentHeap!.suffix(from: size)
            return tempAddress
        }
        return nil
    }
}
