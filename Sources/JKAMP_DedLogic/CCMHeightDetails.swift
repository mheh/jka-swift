import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's surface details of one terrain height, the contents and the surface flags of the shader at that height.
/// `CCMLandScape.mHeightDetails` holds one per height, HEIGHT_RESOLUTION in all.
/// Source: oracle/codemp/qcommon/cm_landscape.h:75
// AI: Raven's destructor at cm_landscape.h:82 has an empty body. The class has no deinit.
final class CCMHeightDetails {
    private var mContents: Int32 = 0
    private var mSurfaceFlags: Int32 = 0

    /// Source: oracle/codemp/qcommon/cm_landscape.h:81
    init() {}

    // Accessors
    /// Source: oracle/codemp/qcommon/cm_landscape.h:85
    func GetSurfaceFlags() -> Int32 {
        self.mSurfaceFlags
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:86
    func GetContents() -> Int32 {
        self.mContents
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:87
    func SetFlags(_ con: Int32, _ sf: Int32) {
        self.mContents = con
        self.mSurfaceFlags = sf
    }
}
