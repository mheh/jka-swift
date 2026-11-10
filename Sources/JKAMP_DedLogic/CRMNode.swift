import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's node of a random map, one spot that paths can join, with a name when a location stands there.
/// `CRMPathManager.mNodes` holds the nodes in a grid of `mXNodes` by `mYNodes`.
/// Source: oracle/codemp/RMG/RM_Path.h:41
final class CRMNode {
    // AI: Raven declares the name a `std::string`. The field is a String, rule 17.
    private var mName: String = ""					// name of node - "" if not used yet
    private var mPos = JKAShared.vec3_t()					// where node is
    private var mPathID: [Int32] = Array(repeating: 0, count: Int(DIR_MAX)) 		// path id's that lead from this node
    private var mAreaPointPlaced: Bool = false		// false if no area point here yet.

    private var mFlattenHeight: Int32 = 0

    /**
    ```
    ***********************************************************************************************
     * CRMNode::CRMNode
     *	constructor
     *
     * inputs:
     *  none
     *
     * return:
     *	none
     *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Path.cpp:27
    init() {
        var i: Int32

        self.mFlattenHeight = -1

        self.mPos[0] = 0
        self.mPos[1] = 0
        self.mPos[2] = 0

        // no paths
        i = 0
        while i < DIR_MAX {
            self.mPathID[i] = -1
            i += 1
        }

        self.mAreaPointPlaced = false
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:56
    func IsLocation() -> Bool {
        strlen(self.mName) > 0
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:57
    func GetName() -> String {
        self.mName
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:58
    // AI: Raven returns a reference to `mPos`. The method returns a copy, because every caller only reads the vector.
    func GetPos() -> JKAShared.vec3_t {
        self.mPos
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:59
    // C converts the `bool` of the compare to the `float` return.
    func PathExist(_ dir: Int32) -> Float {
        (self.mPathID[dir % DIR_MAX] != -1) ? 1 : 0
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:60
    // C converts the `int` path id to the `float` return.
    func GetPath(_ dir: Int32) -> Float {
        Float(self.mPathID[dir % DIR_MAX])
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:61
    func AreaPoint() -> Bool {
        self.mAreaPointPlaced
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:63
    func SetName(_ name: String) {
        self.mName = name
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:64
    func SetPos(_ v: JKAShared.vec3_t) {
        self.mPos = v
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:65
    func SetPath(_ dir: Int32, _ id: Int32) {
        self.mPathID[dir % DIR_MAX] = id
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:66
    func SetAreaPoint(_ ap: Bool) {
        self.mAreaPointPlaced = ap
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:68
    func SetFlattenHeight(_ flattenHeight: Int32) {
        self.mFlattenHeight = flattenHeight
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:69
    func GetFlattenHeight() -> Int32 {
        self.mFlattenHeight
    }
}
