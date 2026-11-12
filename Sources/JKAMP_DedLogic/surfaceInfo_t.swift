import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// we save the whole surfaceInfo_t struct
/// Raven's surface override of one Ghoul2 model, an off flag or a generated surface at a hit point.
/// `CGhoul2Info.mSlist` holds one per override.
/// Source: oracle/codemp/ghoul2/ghoul2_shared.h:38
public final class surfaceInfo_t {
    var offFlags: Int32 = 0		// what the flags are for this model
    var surface: Int32 = 0		// index into array held inside the model definition of pointers to the actual surface data loaded in - used by both client and game
    var genBarycentricJ: Float = 0	// point 0 barycentric coors
    var genBarycentricI: Float = 0	// point 1 barycentric coors - point 2 is 1 - point0 - point1
    var genPolySurfaceIndex: Int32 = 0 // used to point back to the original surface and poly if this is a generated surface
    var genLod: Int32 = 0			// used to determine original lod of original surface and poly hit location

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:47
    init() {
        self.offFlags = 0
        self.surface = 0
        self.genBarycentricJ = 0
        self.genBarycentricI = 0
        self.genPolySurfaceIndex = 0
        self.genLod = 0
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:38
    // AI: Raven copies the struct by value with the compiler's `operator=`. The method is `copy`, a memberwise assign in Raven's member order.
    func copy(_ other: surfaceInfo_t) {
        self.offFlags = other.offFlags
        self.surface = other.surface
        self.genBarycentricJ = other.genBarycentricJ
        self.genBarycentricI = other.genBarycentricI
        self.genPolySurfaceIndex = other.genPolySurfaceIndex
        self.genLod = other.genLod
    }
}
