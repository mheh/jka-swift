import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

//we save from top to boltUsed here. Don't bother saving the position, it gets rebuilt every frame anyway
/// Raven's bolt of one Ghoul2 model, the bone or the surface that a bolt attaches to and its position matrix.
/// `CGhoul2Info.mBltlist` holds one per bolt.
/// Source: oracle/codemp/ghoul2/ghoul2_shared.h:170
final class boltInfo_t {
    var boneNumber: Int32 = -1		// bone number bolt attaches to
    var surfaceNumber: Int32 = -1	// surface number bolt attaches to
    var surfaceType: Int32 = 0	// if we attach to a surface, this tells us if it is an original surface or a generated one - doesn't go across the network
    var boltUsed: Int32 = 0		// nor does this
    var position: MdxaBone		// this does not go across the network

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:176
    // AI: Raven holds `position` by value. The field is the `MdxaBone` view over a slot the instance owns, so the constructor sets the slot.
    init() {
        // TODO: Port boltInfo_t::boltInfo_t
        portMissing("boltInfo_t::boltInfo_t", source: "oracle/codemp/ghoul2/ghoul2_shared.h:176")
    }
}
