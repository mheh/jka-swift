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
        // TODO: Port CGhoul2Info_v::Alloc
        portMissing("CGhoul2Info_v::Alloc", source: "oracle/codemp/ghoul2/ghoul2_shared.h:335")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:341
    private func Free() {
        // TODO: Port CGhoul2Info_v::Free
        portMissing("CGhoul2Info_v::Free", source: "oracle/codemp/ghoul2/ghoul2_shared.h:341")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:350
    // AI: Raven defines a non-const and a const overload, the second at ghoul2_shared.h:355, and each returns a reference to the stored vector.
    // The property forwards to the stored array of `Ghoul2InfoArray` with a getter and a setter, so `Array.append(model)` writes the stored array.
    private var Array: [CGhoul2Info] {
        get {
            // TODO: Port CGhoul2Info_v::Array
            portMissing("CGhoul2Info_v::Array", source: "oracle/codemp/ghoul2/ghoul2_shared.h:350")
        }
        set {
            // TODO: Port CGhoul2Info_v::Array
            portMissing("CGhoul2Info_v::Array", source: "oracle/codemp/ghoul2/ghoul2_shared.h:350")
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
        // TODO: Port CGhoul2Info_v::~CGhoul2Info_v
        portMissing("CGhoul2Info_v::~CGhoul2Info_v", source: "oracle/codemp/ghoul2/ghoul2_shared.h:370")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:374
    // AI: Raven defines `operator=` from another handle. The method is `copy`.
    func copy(_ other: CGhoul2Info_v) {
        // TODO: Port CGhoul2Info_v::operator=
        portMissing("CGhoul2Info_v::operator=", source: "oracle/codemp/ghoul2/ghoul2_shared.h:374")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:378
    // AI: Raven defines `operator=` from the VM side item number. The method is `copy`.
    func copy(_ otherItem: Int32) {	//assigning one from the VM side item number
        // TODO: Port CGhoul2Info_v::operator=
        portMissing("CGhoul2Info_v::operator=", source: "oracle/codemp/ghoul2/ghoul2_shared.h:378")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:382
    func DeepCopy(_ other: CGhoul2Info_v) {
        // TODO: Port CGhoul2Info_v::DeepCopy
        portMissing("CGhoul2Info_v::DeepCopy", source: "oracle/codemp/ghoul2/ghoul2_shared.h:382")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:399
    // AI: Raven defines a non-const and a const `operator[]`, the second at ghoul2_shared.h:405. The class has one subscript.
    subscript(_ idx: Int32) -> CGhoul2Info {
        // TODO: Port CGhoul2Info_v::operator[]
        portMissing("CGhoul2Info_v::operator[]", source: "oracle/codemp/ghoul2/ghoul2_shared.h:399")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:411
    func resize(_ num: Int32) {
        // TODO: Port CGhoul2Info_v::resize
        portMissing("CGhoul2Info_v::resize", source: "oracle/codemp/ghoul2/ghoul2_shared.h:411")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:426
    func clear() {
        // TODO: Port CGhoul2Info_v::clear
        portMissing("CGhoul2Info_v::clear", source: "oracle/codemp/ghoul2/ghoul2_shared.h:426")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:430
    func push_back(_ model: CGhoul2Info) {
        // TODO: Port CGhoul2Info_v::push_back
        portMissing("CGhoul2Info_v::push_back", source: "oracle/codemp/ghoul2/ghoul2_shared.h:430")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:438
    func size() -> Int32 {
        // TODO: Port CGhoul2Info_v::size
        portMissing("CGhoul2Info_v::size", source: "oracle/codemp/ghoul2/ghoul2_shared.h:438")
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:446
    func IsValid() -> Bool {
        return self.InfoArray().IsValid(self.mItem)
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:450
    func kill() {
        // TODO: Port CGhoul2Info_v::kill
        portMissing("CGhoul2Info_v::kill", source: "oracle/codemp/ghoul2/ghoul2_shared.h:450")
    }
}
