import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's table of every ghoul2 instance, one array of `CGhoul2Info` per slot, with an id per slot and a list of the free slots.
/// A `CGhoul2Info_v` handle is the id, and `TheGhoul2InfoArray()` returns the one instance.
/// Source: oracle/codemp/ghoul2/G2_API.cpp:310
// AI: Raven declares the interface IGhoul2InfoArray at ghoul2_shared.h:316, and this class is its one implementation.
// The class stands for both, and the generator spells `IGhoul2InfoArray &` as `Ghoul2InfoArray`.
final class Ghoul2InfoArray {
    // AI: Raven's Get returns a reference to one vector of `mInfos`, and the callers write through it.
    // `Get` returns a copy, so the field is internal, and the setter of `CGhoul2Info_v.Array` writes the stored vector here.
    var mInfos: [[CGhoul2Info]] = [[CGhoul2Info]](repeating: [], count: MAX_G2_MODELS)
    private var mIds: [Int32] = [Int32](repeating: 0, count: MAX_G2_MODELS)
    // AI: Raven holds a `list<int>`. The field is an Array, by the C++ docket.
    private var mFreeIndecies: [Int32] = []

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:315
    private func DeleteLow(_ idx: Int32) {
        // TODO: Port Ghoul2InfoArray::DeleteLow
        portMissing("Ghoul2InfoArray::DeleteLow", source: "oracle/codemp/ghoul2/G2_API.cpp:315")
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:342
    init() {
        // TODO: Port Ghoul2InfoArray::Ghoul2InfoArray
        portMissing("Ghoul2InfoArray::Ghoul2InfoArray", source: "oracle/codemp/ghoul2/G2_API.cpp:342")
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:386
    func New() -> Int32 {
        // TODO: Port Ghoul2InfoArray::New
        portMissing("Ghoul2InfoArray::New", source: "oracle/codemp/ghoul2/G2_API.cpp:386")
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:399
    func IsValid(_ handle: Int32) -> Bool {
        // TODO: Port Ghoul2InfoArray::IsValid
        portMissing("Ghoul2InfoArray::IsValid", source: "oracle/codemp/ghoul2/G2_API.cpp:399")
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:413
    func Delete(_ handle: Int32) {
        // TODO: Port Ghoul2InfoArray::Delete
        portMissing("Ghoul2InfoArray::Delete", source: "oracle/codemp/ghoul2/G2_API.cpp:413")
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:427
    // AI: Raven defines a non-const and a const overload, the second at G2_API.cpp:440. The class has one method.
    func Get(_ handle: Int32) -> [CGhoul2Info] {
        // TODO: Port Ghoul2InfoArray::Get
        portMissing("Ghoul2InfoArray::Get", source: "oracle/codemp/ghoul2/G2_API.cpp:427")
    }
}
