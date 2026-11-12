import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's table of every ghoul2 instance, one array of `CGhoul2Info` per slot, with an id per slot and a list of the free slots.
/// A `CGhoul2Info_v` handle is the id, and `TheGhoul2InfoArray()` returns the one instance.
/// Source: oracle/codemp/ghoul2/G2_API.cpp:310
// AI: Raven declares the interface IGhoul2InfoArray at ghoul2_shared.h:316, and this class is its one implementation.
// The class stands for both, and the generator spells `IGhoul2InfoArray &` as `Ghoul2InfoArray`.
public final class Ghoul2InfoArray {
    // AI: Raven's Get returns a reference to one vector of `mInfos`, and the callers write through it.
    // `Get` returns a copy, so the field is internal, and the setter of `CGhoul2Info_v.Array` writes the stored vector here.
    var mInfos: [[CGhoul2Info]] = [[CGhoul2Info]](repeating: [], count: MAX_G2_MODELS)
    private var mIds: [Int32] = [Int32](repeating: 0, count: MAX_G2_MODELS)
    // AI: Raven holds a `list<int>`. The field is an Array, by the C++ docket.
    private var mFreeIndecies: [Int32] = []

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:315
    private func DeleteLow(_ idx: Int32) {
        do {
            var model: Int32
            model = 0
            while model < self.mInfos[idx].count {
                if self.mInfos[idx][model].mBoneCache != nil {
                    RemoveBoneCache(self.mInfos[idx][model].mBoneCache)
                    self.mInfos[idx][model].mBoneCache = nil
                }
                model += 1
            }
        }
        self.mInfos[idx].removeAll()

        if (self.mIds[idx] >> G2_MODEL_BITS) > (1 << (31 - G2_MODEL_BITS)) {
            self.mIds[idx] = MAX_G2_MODELS + idx //rollover reset id to minimum value
            self.mFreeIndecies.append(idx)
        } else {
            // Port-note: Raven's add overflows a signed int after about two million deletes of one slot, which C leaves undefined.
            // The add wraps at 32 bits, as the x86 build does.
            self.mIds[idx] &+= MAX_G2_MODELS
            self.mFreeIndecies.insert(idx, at: 0)
        }
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:342
    init() {
        var i: Int32
        i = 0
        while i < MAX_G2_MODELS {
            self.mIds[i] = MAX_G2_MODELS + i
            self.mFreeIndecies.append(i)
            i += 1
        }
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:386
    func New() -> Int32 {
        if self.mFreeIndecies.isEmpty {
            Com_Error(ERR_FATAL, "Out of ghoul2 info slots")

        }
        // gonna pull from the front, doing a
        let idx = self.mFreeIndecies[0]
        self.mFreeIndecies.removeFirst()
        return self.mIds[idx]
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:399
    func IsValid(_ handle: Int32) -> Bool {
        if handle == 0 {
            return false
        }
        if self.mIds[handle & G2_INDEX_MASK] != handle { // not a valid handle, could be old
            return false
        }
        return true
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:413
    func Delete(_ handle: Int32) {
        if handle == 0 {
            return
        }
        if self.mIds[handle & G2_INDEX_MASK] == handle {
            self.DeleteLow(handle & G2_INDEX_MASK)
        }
    }

    /// Source: oracle/codemp/ghoul2/G2_API.cpp:427
    // AI: Raven defines a non-const and a const overload, the second at G2_API.cpp:440. The class has one method.
    func Get(_ handle: Int32) -> [CGhoul2Info] {
        if handle <= 0 || (handle & G2_INDEX_MASK) < 0 || (handle & G2_INDEX_MASK) >= MAX_G2_MODELS || self.mIds[handle & G2_INDEX_MASK] != handle {
            // AI: Raven clears a static empty vector and returns it by reference. The method returns an empty Array.
            return []
        }
        return self.mInfos[handle & G2_INDEX_MASK]
    }
}
