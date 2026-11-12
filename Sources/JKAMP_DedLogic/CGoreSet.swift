import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's gore surface, one decal on one surface of a model, with its fade and grow times.
/// `CGoreSet.mGoreRecords` holds these by value.
/// Source: oracle/codemp/ghoul2/G2_gore.h:44
struct SGoreSurface {
    var shader: Int32 = 0
    var mGoreTag: Int32 = 0
    var mDeleteTime: Int32 = 0
    var mFadeTime: Int32 = 0
    var mFadeRGB: Bool = false

    var mGoreGrowStartTime: Int32 = 0
    var mGoreGrowEndTime: Int32 = 0    // set this to -1 to disable growing
    //curscale = (curtime-mGoreGrowStartTime)*mGoreGrowFactor + mGoreGrowOffset;
    var mGoreGrowFactor: Float = 0
    var mGoreGrowOffset: Float = 0
}

/// Raven's gore set of one Ghoul2 model, its gore surfaces by surface index and a reference count.
/// `CGhoul2Info.mGoreSetTag` names the set, and `FindGoreSet` returns it.
/// Source: oracle/codemp/ghoul2/G2_gore.h:59
public final class CGoreSet {
    var mMyGoreSetTag: Int32 = 0
    var mRefCount: UInt8 = 0
    // AI: Raven keys a `multimap<int,SGoreSurface>` by the surface index. The table is a Dictionary of arrays, by the C++ docket.
    var mGoreRecords: [Int32: [SGoreSurface]] = [:] // a map from surface index

    /// Source: oracle/codemp/ghoul2/G2_gore.h:65
    init(_ tag: Int32) {
        self.mMyGoreSetTag = tag
        self.mRefCount = 0
    }

    /// Source: oracle/codemp/ghoul2/G2_misc.cpp:174
    deinit {
        // AI: Raven walks the multimap in the order of its keys. The body walks the sorted keys of the Dictionary, and each array in its order.
        for i in self.mGoreRecords.keys.sorted() {
            for surface in self.mGoreRecords[i]! {
                DeleteGoreRecord(surface.mGoreTag)
            }
        }
    }
}
