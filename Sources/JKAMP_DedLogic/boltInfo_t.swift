import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

//we save from top to boltUsed here. Don't bother saving the position, it gets rebuilt every frame anyway
/// Raven's bolt of one Ghoul2 model, the bone or the surface that a bolt attaches to and its position matrix.
/// `CGhoul2Info.mBltlist` holds one per bolt.
/// Source: oracle/codemp/ghoul2/ghoul2_shared.h:170
final class boltInfo_t {
    // AI: Raven holds `position` by value. The instance owns one allocation of the record, and the field is the view of the slot.
    // A store is `copy(from:)`, Raven's `=`. Raven leaves the record unset, and the allocation zeroes it.
    private let mdxaBones: Slots<MdxaBone> = {
        let mdxaBones = Slots<MdxaBone>.new(count: 1)
        mdxaBones.zero(count: 1)
        return mdxaBones
    }()

    var boneNumber: Int32 = -1		// bone number bolt attaches to
    var surfaceNumber: Int32 = -1	// surface number bolt attaches to
    var surfaceType: Int32 = 0	// if we attach to a surface, this tells us if it is an original surface or a generated one - doesn't go across the network
    var boltUsed: Int32 = 0		// nor does this
    var position: MdxaBone { self.mdxaBones[0] }		// this does not go across the network

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:176
    init() {}

    deinit {
        self.mdxaBones.delete()
    }
}
