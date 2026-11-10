import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's named location of a random map, with the depth and path count of the node that can hold it.
/// `CRMPathManager.mLocations` holds the locations, and PlaceLocation puts each one at a node.
/// Source: oracle/codemp/RMG/RM_Path.h:75
// named spots on the map, should be placed into nodes
final class CRMLoc {
    // AI: Raven declares the name a `std::string`. The field is a String, rule 17.
    private var mName: String = ""		// name of location
    private var mMinDepth: Int32 = 0
    private var mMaxDepth: Int32 = 0
    private var mMinPaths: Int32 = 0
    private var mMaxPaths: Int32 = 0
    private var mPlaced: Bool = false	// location has been placed at a node

    /// Source: oracle/codemp/RMG/RM_Path.h:87
    init(_ name: String, _ min_depth: Int32, _ max_depth: Int32, _ min_paths: Int32 = 1, _ max_paths: Int32 = 1) {
        self.mMinDepth = min_depth
        self.mMaxDepth = max_depth
        self.mPlaced = false
        self.mMinPaths = min_paths
        self.mMaxPaths = max_paths
        self.mName = name
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:91
    func GetName() -> String {
        self.mName
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:92
    func SetName(_ name: String) {
        self.mName = name
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:94
    func MinDepth() -> Int32 {
        self.mMinDepth
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:95
    func SetMinDepth(_ deep: Int32) {
        self.mMinDepth = deep
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:97
    func MaxDepth() -> Int32 {
        self.mMaxDepth
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:98
    func SetMaxDepth(_ deep: Int32) {
        self.mMaxDepth = deep
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:100
    func MinPaths() -> Int32 {
        self.mMinPaths
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:101
    func SetMinPaths(_ paths: Int32) {
        self.mMinPaths = paths
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:103
    func MaxPaths() -> Int32 {
        self.mMaxPaths
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:104
    func SetMaxPaths(_ paths: Int32) {
        self.mMaxPaths = paths
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:106
    func Placed() -> Bool {
        self.mPlaced
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:107
    func SetPlaced(_ p: Bool) {
        self.mPlaced = p
    }
}
