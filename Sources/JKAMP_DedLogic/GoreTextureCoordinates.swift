import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/ghoul2/G2_gore.h:9
// AI: Raven defines the bound in G2_gore.h, which no module of the host declares. The file that reads it holds the value as a `let`.
private let MAX_LODS = (8) as Int32

/// Raven's gore texture coordinates of one gore record, one zone block of floats per level of detail.
/// `AllocGoreRecord` makes one, and `DeleteGoreRecord` drops it by its tag.
/// Source: oracle/codemp/ghoul2/G2_gore.h:10
// AI: Raven's destructor at G2_gore.h:22 frees each `tex` block with `Z_Free`. The class drops it, because it only frees memory.
public final class GoreTextureCoordinates {
    var tex: [Slots<Float>?] = [Slots<Float>?](repeating: nil, count: Int(MAX_LODS))

    /// Source: oracle/codemp/ghoul2/G2_gore.h:14
    init() {
        var i: Int32
        i = 0
        while i < MAX_LODS {
            self.tex[i] = nil
            i += 1
        }
    }
}
