import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's arguments of `G2_ConstructUsedBoneList`, the root surface, the used bone list to fill, and the model's lists.
/// G2_surfaces.cpp and tr_ghoul2.cpp each define the class with the same text, so one class serves both.
/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:18
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:142
public final class CConstructBoneList {
    public var surfaceNum: Int32 = 0
    public var boneUsedList: Slots<Int32>? = nil
    // AI: Raven holds references to the caller's `surfaceInfo_v` and `boneInfo_v`.
    // The fields hold the arrays, because `G2_ConstructUsedBoneList` only reads them.
    public var rootSList: [surfaceInfo_t] = []
    public var currentModel: Model? = nil
    public var boneList: [boneInfo_t] = []

    /// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:27
    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:151
    public init(
        _ initsurfaceNum: Int32,
        _ initboneUsedList: Slots<Int32>?,
        _ initrootSList: [surfaceInfo_t],
        _ initcurrentModel: Model?,
        _ initboneList: [boneInfo_t]
    ) {
        self.surfaceNum = initsurfaceNum
        self.boneUsedList = initboneUsedList
        self.rootSList = initrootSList
        self.currentModel = initcurrentModel
        self.boneList = initboneList
    }
}
