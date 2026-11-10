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
    // AI: Raven defines a non-const and a const overload, the second at ghoul2_shared.h:355. The class has one method.
    private func Array() -> [CGhoul2Info] {
        return self.InfoArray().Get(self.mItem)
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
    // Port-note: Raven assigns `Array()=other.Array()`, a copy of each CGhoul2Info by value into the slot of `mItem`.
    // `Array()` returns a copy of the list, and CGhoul2Info is a class with no copy, so the body has no form.
    func DeepCopy(_ other: CGhoul2Info_v) {
        // TODO: Port CGhoul2Info_v::DeepCopy
        portMissing("CGhoul2Info_v::DeepCopy", source: "oracle/codemp/ghoul2/ghoul2_shared.h:382")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:399
    // AI: Raven defines a non-const and a const `operator[]`, the second at ghoul2_shared.h:405. The class has one subscript.
    subscript(_ idx: Int32) -> CGhoul2Info {
        return self.Array()[idx]
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:411
    // Port-note: Raven resizes the list that `Array()` returns by reference, and the Swift `Array()` returns a copy.
    func resize(_ num: Int32) {
        // TODO: Port CGhoul2Info_v::resize
        portMissing("CGhoul2Info_v::resize", source: "oracle/codemp/ghoul2/ghoul2_shared.h:411")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:426
    func clear() {
        self.Free()
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:430
    // Port-note: Raven appends a copy of the model to the list that `Array()` returns by reference, and the Swift `Array()` returns a copy.
    func push_back(_ model: CGhoul2Info) {
        // TODO: Port CGhoul2Info_v::push_back
        portMissing("CGhoul2Info_v::push_back", source: "oracle/codemp/ghoul2/ghoul2_shared.h:430")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:438
    func size() -> Int32 {
        if !self.IsValid() {
            return 0
        }
        return Int32(self.Array().count)
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
