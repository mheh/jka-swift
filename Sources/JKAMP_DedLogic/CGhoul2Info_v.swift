import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's handle to one array of `CGhoul2Info` in `Ghoul2InfoArray`, the ghoul2 instance of an entity.
/// The handle is `mItem`, and every method reaches the array through `TheGhoul2InfoArray()`.
/// Source: oracle/codemp/ghoul2/ghoul2_shared.h:328
final class CGhoul2Info_v {
    var mItem: Int32 = 0	//dont' be bad and muck with this

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:330
    private func InfoArray() -> Ghoul2InfoArray {
        return TheGhoul2InfoArray()
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:335
    private func Alloc() {
        self.mItem = self.InfoArray().New()
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:341
    private func Free() {
        if self.mItem != 0 {
            self.InfoArray().Delete(self.mItem)
            self.mItem = 0
        }
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:350
    // AI: Raven defines a non-const and a const overload, the second at ghoul2_shared.h:355, and each returns a reference to the stored vector.
    // The property reads the stored array of `Ghoul2InfoArray` and writes it back, so `Array.append(model)` writes the stored array, row G2A1.
    private var Array: [CGhoul2Info] {
        get {
            return self.InfoArray().Get(self.mItem)
        }
        set {
            // AI: Raven writes the static empty vector that Get returns for a bad handle. The setter drops that write.
            if self.InfoArray().IsValid(self.mItem) {
                self.InfoArray().mInfos[self.mItem & G2_INDEX_MASK] = newValue
            }
        }
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:362
    init() {
        self.mItem = 0
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:366
    init(_ item: Int32) {
        //be VERY carefull with what you pass in here
        self.mItem = item
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:370
    deinit {
        self.Free() //this had better be taken care of via the clean ghoul2 models call
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:374
    // AI: Raven defines `operator=` from another handle. The method is `copy`.
    func copy(_ other: CGhoul2Info_v) {
        self.mItem = other.mItem
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:378
    // AI: Raven defines `operator=` from the VM side item number. The method is `copy`.
    func copy(_ otherItem: Int32) {	//assigning one from the VM side item number
        self.mItem = otherItem
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:382
    func DeepCopy(_ other: CGhoul2Info_v) {
        self.Free()
        if other.mItem != 0 {
            self.Alloc()
            // AI: Raven assigns `Array()=other.Array()`, a copy of each model by value. The list takes a new instance per model, and `copy` assigns its members.
            self.Array = other.Array.map { model in
                let copy = CGhoul2Info()
                copy.copy(model)
                return copy
            }
            var i: Int32
            i = 0
            while i < self.size() {
                self.Array[i].mBoneCache = nil
                self.Array[i].mTransformedVertsArray = nil
                self.Array[i].mSkelFrameNum = 0
                self.Array[i].mMeshFrameNum = 0
                i += 1
            }
        }
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:399
    // AI: Raven defines a non-const and a const `operator[]`, the second at ghoul2_shared.h:405. The class has one subscript.
    subscript(_ idx: Int32) -> CGhoul2Info {
        get {
            return self.Array[idx]
        }
        set {
            self.Array[idx] = newValue
        }
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:411
    func resize(_ num: Int32) {
        if num != 0 {
            if self.mItem == 0 {
                self.Alloc()
            }
        }
        if self.mItem != 0 || num != 0 {
            // Raven's `Array().resize(num)` constructs each new model and destroys each model past `num`.
            while self.Array.count < num {
                self.Array.append(CGhoul2Info())
            }
            while self.Array.count > num {
                self.Array.removeLast()
            }
        }
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:426
    func clear() {
        self.Free()
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:430
    // AI: Raven appends a copy of the model. The list holds the instance itself, because the one caller hands a new temporary, G2_API.cpp:645.
    func push_back(_ model: CGhoul2Info) {
        if self.mItem == 0 {
            self.Alloc()
        }
        self.Array.append(model)
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:438
    func size() -> Int32 {
        if !self.IsValid() {
            return 0
        }
        return Int32(self.Array.count)
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:446
    func IsValid() -> Bool {
        return self.InfoArray().IsValid(self.mItem)
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:450
    func kill() {
        // this scary method zeros the infovector handle without actually freeing it
        // it is used for some places where a copy is made, but we don't want to go through the trouble
        // of making a deep copy
        self.mItem = 0
    }
}
