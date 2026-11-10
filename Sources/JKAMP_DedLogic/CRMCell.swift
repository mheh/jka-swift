import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's cell of the path grid, a bit per direction for the world border and a bit per direction for a wall.
/// `CRMPathManager.mCells` holds these by value, and PathVisit and RiverVisit knock down the walls.
/// Source: oracle/codemp/RMG/RM_Path.h:114
// cells are used for figuring out node connections / paths
struct CRMCell {
    private var border: Int32 = 0
    private var wall: Int32 = 0

    /// Source: oracle/codemp/RMG/RM_Path.h:121
    init() {
        self.border = 0
        self.wall = DIR_ALL
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:123
    func Border() -> Int32 {
        self.border
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:124
    func Wall() -> Int32 {
        self.wall
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:125
    func Border(_ dir: Int32) -> Bool {
        (self.border & (1 << dir)) != 0
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:126
    func Wall(_ dir: Int32) -> Bool {
        (self.wall & (1 << dir)) != 0
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:127
    mutating func SetBorder(_ dir: Int32) {
        self.border |= (1 << dir)
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:128
    mutating func SetWall(_ dir: Int32) {
        self.wall |= (1 << dir)
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:129
    mutating func RemoveWall(_ dir: Int32) {
        self.wall &= ~(1 << dir)
    }
}
