import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's gore surface, one decal on one surface of a model, with its fade and grow times.
/// `CGoreSet.mGoreRecords` holds these by value.
/// Source: oracle/codemp/ghoul2/G2_gore.h:44
public struct SGoreSurface {
    public var shader: Int32 = 0
    public var mGoreTag: Int32 = 0
    public var mDeleteTime: Int32 = 0
    public var mFadeTime: Int32 = 0
    public var mFadeRGB: Bool = false

    public var mGoreGrowStartTime: Int32 = 0
    public var mGoreGrowEndTime: Int32 = 0    // set this to -1 to disable growing
    //curscale = (curtime-mGoreGrowStartTime)*mGoreGrowFactor + mGoreGrowOffset;
    public var mGoreGrowFactor: Float = 0
    public var mGoreGrowOffset: Float = 0
}

/// Raven's gore set of one Ghoul2 model, its gore surfaces by surface index and a reference count.
/// `CGhoul2Info.mGoreSetTag` names the set, and `FindGoreSet` returns it.
/// Source: oracle/codemp/ghoul2/G2_gore.h:59
public final class CGoreSet {
    public var mMyGoreSetTag: Int32 = 0
    public var mRefCount: UInt8 = 0
    // AI: Raven keys a `multimap<int,SGoreSurface>` by the surface index. The table is a Dictionary of arrays, by the C++ docket.
    public var mGoreRecords: [Int32: [SGoreSurface]] = [:] // a map from surface index

    /// Source: oracle/codemp/ghoul2/G2_gore.h:65
    public init(_ tag: Int32) {
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
