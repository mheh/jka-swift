import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's gore texture coordinates of one gore record, one zone block of floats per level of detail.
/// `AllocGoreRecord` makes one, and `DeleteGoreRecord` drops it by its tag.
/// Source: oracle/codemp/ghoul2/G2_gore.h:10
// AI: Raven's destructor at G2_gore.h:22 frees each `tex` block with `Z_Free`. The class drops it, because it only frees memory.
final class GoreTextureCoordinates {
    // AI: Raven sizes the array with `MAX_LODS` of G2_gore.h:9, which has no Swift name. The count is its value, 8.
    var tex: [Slots<Float>?] = [Slots<Float>?](repeating: nil, count: 8)

    /// Source: oracle/codemp/ghoul2/G2_gore.h:14
    init() {
        var i: Int32
        i = 0
        // AI: Raven loops to `MAX_LODS`, which has no Swift name. The bound is its value, 8.
        while i < 8 {
            self.tex[i] = nil
            i += 1
        }
    }
}
