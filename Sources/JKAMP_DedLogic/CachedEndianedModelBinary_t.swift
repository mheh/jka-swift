import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's cached model file, the disk image, its size, the shader requests to fill, and the level and pak checksum it came from.
/// `CachedModels` of tr_model.cpp holds one per model name.
/// Source: oracle/codemp/renderer/tr_model.cpp:48
public final class CachedEndianedModelBinary_t {
    var pModelDiskImage: Slots<JKAShared.byte>? = nil
    var iAllocSize: Int32 = 0		// may be useful for mem-query, but I don't actually need it
    // AI: Raven holds a `vector<pair<int,int>>`, ShaderRegisterData_t of tr_model.cpp:47. The field is an Array of pairs, by the C++ docket.
    var ShaderRegisterData: [(Int32, Int32)] = []
    var iLastLevelUsedOn: Int32 = -1
    var iPAKFileCheckSum: Int32 = -1	// else -1 if not from PAK

    /// Source: oracle/codemp/renderer/tr_model.cpp:57
    init() {
        self.pModelDiskImage = nil
        self.iAllocSize = 0
        self.ShaderRegisterData.removeAll()
        self.iLastLevelUsedOn = -1
        self.iPAKFileCheckSum = -1
    }
}
