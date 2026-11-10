import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// directions you can proceed from cells 
/// Source: oracle/codemp/RMG/RM_Path.h:24
typealias ERMDir = Int32
let DIR_FIRST: ERMDir = 0
let DIR_N: ERMDir = 0
let DIR_NE: ERMDir = 1
let DIR_E: ERMDir = 2
let DIR_SE: ERMDir = 3
let DIR_S: ERMDir = 4
let DIR_SW: ERMDir = 5
let DIR_W: ERMDir = 6
let DIR_NW: ERMDir = 7
let DIR_MAX: ERMDir = 8
let DIR_ALL: ERMDir = 255

/// Source: oracle/codemp/RMG/RM_Path.h:39
let HALF_DIR_MAX = (DIR_MAX / 2)

// neighbor offsets - easy way to turn a direction into the array position for a neighboring cell or node
/// Source: oracle/codemp/RMG/RM_Path.cpp:211
// AI: Raven declares the static member `int CRMPathManager::neighbor_x[DIR_MAX]`, which no code writes. The table is a file-scope `let`, the form of `kbitmask`.
private let neighbor_x: [Int32] = [0, 1, 1, 1, 0, -1, -1, -1]

/// Source: oracle/codemp/RMG/RM_Path.cpp:212
// AI: Raven declares the static member `int CRMPathManager::neighbor_y[DIR_MAX]`, which no code writes. The table is a file-scope `let`, the form of `kbitmask`.
private let neighbor_y: [Int32] = [-1, -1, 0, 1, 1, 1, 0, -1]

/// Raven's path manager of a random mission, the grid of nodes, the named locations, and the paths and rivers that join the nodes.
/// The mission makes one for its random terrain, and the dedicated build never makes that terrain.
/// Source: oracle/codemp/RMG/RM_Path.h:135
final class CRMPathManager {
    var mXNodes: Int32 = 0	// number of nodes in the x dimension
    var mYNodes: Int32 = 0	// number of nodes in the y dimension

    // AI: Raven declares a `vector<CRMLoc*>`. The field is an Array of the optional class, rule 17.
    private var mLocations: [CRMLoc?] = [] // location, named spots to be placed at nodes
    // AI: Raven declares a `vector<CRMNode*>`. The field is an Array of the optional class, rule 17.
    private var mNodes: [CRMNode?] = []		// nodes, spots on map that *may* be connected by paths
    // AI: Raven declares a `vector<CRMCell>` by value. The field is an Array of the struct, rule 17.
    private var mCells: [CRMCell] = []		// array of cells for doing path generation

    private var mPathCount: Int32 = 0
    private var mRiverCount: Int32 = 0
    private var mMaxDepth: Int32 = 0	// deepest any location wants to be
    private var mDepth: Int32 = 0		// current depth

    private var mCrossed: Bool = false  // used to indicate if paths crossed the imaginary diagonal that cuts symmetric maps in half

    // path style
    private var mPathPoints: Int32 = 0
    private var mPathMinWidth: Float = 0
    private var mPathMaxWidth: Float = 0
    private var mPathDepth: Float = 0
    private var mPathDeviation: Float = 0
    private var mPathBreadth: Float = 0

    // river style
    private var mRiverDepth: Int32 = 0
    private var mRiverPoints: Int32 = 0
    private var mRiverMinWidth: Float = 0
    private var mRiverMaxWidth: Float = 0
    private var mRiverBedDepth: Float = 0
    private var mRiverDeviation: Float = 0
    private var mRiverBreadth: Float = 0
    // AI: Raven declares the bridge name a `std::string`. The field is a String, rule 17.
    private var mRiverBridge: String = ""
    private var mRiverPos = JKAShared.vec3_t()

    private var mTerrain: CRandomTerrain? = nil

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::CRMPathManager
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
    /// Source: oracle/codemp/RMG/RM_Path.cpp:56
    init(_ terrain: CRandomTerrain?) {
        self.mXNodes = 0
        self.mYNodes = 0
        self.mPathCount = 0
        self.mRiverCount = 0
        self.mMaxDepth = 0
        self.mDepth = 0
        self.mPathPoints = 10
        self.mPathMinWidth = 0.02
        self.mPathMaxWidth = 0.04
        self.mPathDepth = 0.3
        self.mPathDeviation = 0.03
        self.mPathBreadth = 5
        self.mRiverDepth = 5
        self.mRiverPoints = 10
        self.mRiverMinWidth = 0.01
        self.mRiverMaxWidth = 0.02
        self.mRiverBedDepth = 1
        self.mRiverDeviation = 0.01
        self.mRiverBreadth = 7
        self.mTerrain = terrain
        self.mCrossed = false
    }

    /// Source: oracle/codemp/RMG/RM_Path.cpp:64
    deinit {
        // AI: Raven deletes each location through the index. The clear below frees them.
        self.mLocations.removeAll()

        // AI: Raven deletes each node through the index. The clear below frees them.
        self.mNodes.removeAll()
    }

    /// Source: oracle/codemp/RMG/RM_Path.cpp:114
    func ClearCells(_ x_nodes: Int32, _ y_nodes: Int32) {
        var x: Int32
        var y: Int32

        // clear cell array - used for generating paths
        let empty = CRMCell()
        x = 0
        while x < x_nodes * y_nodes {
            if x >= self.mCells.count {
                self.mCells.append(empty)
            } else {
                self.mCells[x] = empty
            }
            x += 1
        }

        // set borders of world
        y = 0
        while y < y_nodes {
            self.mCells[y * x_nodes].SetBorder(DIR_W)
            self.mCells[y * x_nodes].SetBorder(DIR_SW)
            self.mCells[y * x_nodes].SetBorder(DIR_NW)
            self.mCells[y * x_nodes + x_nodes - 1].SetBorder(DIR_E)
            self.mCells[y * x_nodes + x_nodes - 1].SetBorder(DIR_NE)
            self.mCells[y * x_nodes + x_nodes - 1].SetBorder(DIR_SE)
            y += 1
        }

        x = 0
        while x < x_nodes {
            self.mCells[x].SetBorder(DIR_N)
            self.mCells[x].SetBorder(DIR_NE)
            self.mCells[x].SetBorder(DIR_NW)
            self.mCells[(y_nodes - 1) * x_nodes + x].SetBorder(DIR_S)
            self.mCells[(y_nodes - 1) * x_nodes + x].SetBorder(DIR_SE)
            self.mCells[(y_nodes - 1) * x_nodes + x].SetBorder(DIR_SW)
            x += 1
        }
    }

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::CreateArray
     *	Create array of nodes that are spaced over the landscape.
     *	Create array of cells, which is used to determine how nodes are connected.
     *
     * inputs:
     *  x_nodes, y_nodes - how many nodes in each dimension to layout
     *
     * return:
     *	true if the node array was created, false if we have a problem
     *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Path.cpp:162
    @discardableResult
    func CreateArray(_ x_nodes: Int32, _ y_nodes: Int32) -> Bool {
        self.mXNodes = x_nodes
        self.mYNodes = y_nodes

        // fill node array with positions that are spaced over the landscape
        var x: Int32
        var y: Int32

        // dump existing nodes
        // AI: Raven deletes each node through the index. The clear below frees them.
        self.mNodes.removeAll()
        // Raven's `mNodes.resize(mXNodes * mYNodes, NULL)` appends NULL until the size is the count.
        while self.mNodes.count < self.mXNodes * self.mYNodes {
            self.mNodes.append(nil)
        }

        // add a small amount of random jitter to spots chosen
        let x_rnd: Float = 0.2 / (self.mXNodes + 1)
        let y_rnd: Float = 0.2 / (self.mYNodes + 1)

        x = 0
        while x < self.mXNodes {
            let cell_x: Float = (x + 1.0) / (self.mXNodes + 1)
            //		float cell_x = (x + 2.0f) / (mXNodes+3);

            y = 0
            while y < self.mYNodes {
                var pos = JKAShared.vec3_t()
                let pnode: CRMNode? = CRMNode()
                self.mNodes[x + y * self.mXNodes] = pnode

                let cell_y: Float = (y + 1.0) / (self.mYNodes + 1)
                //			float cell_y = (y + 2.0f) / (mYNodes+3);

                pos[0] = TheRandomMissionManager!.GetLandScape()!.flrand(cell_x - x_rnd, cell_x + x_rnd)
                pos[1] = TheRandomMissionManager!.GetLandScape()!.flrand(cell_y - y_rnd, cell_y + y_rnd)
                pos[2] = 0

                self.SetNodePos(x, y, pos)
                y += 1
            }
            x += 1
        }

        self.ClearCells(self.mXNodes, self.mYNodes)

        return true
    }

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::FindNodeByName
     *	Finds the managed node with the matching case-insensivity name
     *
     * inputs:
     *  name - name of the node to find
     *
     * return:
     *	a pointer to the found node or NULL if the node couldn't be found
     *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Path.cpp:448
    func FindNodeByName(_ name: String) -> CRMNode? {
        var j: Int32

        // C converts the `size_t` size to the `int` index.
        j = Int32(self.mNodes.count) - 1
        while j >= 0 {
            if Q_stricmp(name, self.mNodes[j]!.GetName()) == 0 {
                return self.mNodes[j]
            }
            j -= 1
        }
        return nil
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:185
    func Node(_ x: Int32, _ y: Int32) -> CRMNode? {
        self.mNodes[x + y * self.mXNodes]
    }

    /// Source: oracle/codemp/RMG/RM_Path.cpp:83
    func CreateLocation(_ name: String, _ min_depth: Int32, _ max_depth: Int32, _ min_paths: Int32 = 1, _ max_paths: Int32 = 1) {
        // Raven assigns his own `max_depth` and `max_paths` parameters. A Swift parameter is immutable, so the body takes a mutable copy of each.
        var max_depth = max_depth
        var max_paths = max_paths
        var i: Int32

        // sanity checks -- dmv
        if max_paths < min_paths {
            Com_Printf("[CreateLocation()] ERROR : max_paths < min_paths :: set max_paths = min_paths\n")
            max_paths = min_paths
        }
        if max_depth < min_depth {
            Com_Printf("[CreateLocation()] ERROR : max_depth < min_depth :: set max_depth = min_depth\n")
            max_depth = min_depth
        }

        // C converts the `size_t` size to the `int` index.
        i = Int32(self.mLocations.count) - 1
        while i >= 0 {
            if Q_stricmp(name, self.mLocations[i]!.GetName()) == 0 {
                self.mLocations[i]!.SetMinDepth(min_depth)
                self.mLocations[i]!.SetMaxDepth(max_depth)
                self.mLocations[i]!.SetMinPaths(min_paths)
                self.mLocations[i]!.SetMaxPaths(max_paths)
                return
            }
            i -= 1
        }

        let pLoc: CRMLoc? = CRMLoc(name, min_depth, max_depth, min_paths, max_paths)
        self.mLocations.append(pLoc)
        self.mMaxDepth = max(self.mMaxDepth, max_depth)
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:189
    // AI: Raven returns a reference to the position of the node. The method returns a copy, because every caller only reads the vector.
    func GetNodePos(_ x: Int32, _ y: Int32) -> JKAShared.vec3_t {
        self.mNodes[x + y * self.mXNodes]!.GetPos()
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:190
    func SetNodePos(_ x: Int32, _ y: Int32, _ pos: JKAShared.vec3_t) {
        self.mNodes[x + y * self.mXNodes]!.SetPos(pos)
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:191
    func GetPathCount() -> Int32 {
        self.mPathCount
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:192
    func GetRiverCount() -> Int32 {
        self.mRiverCount
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:193
    func GetRiverDepth() -> Float {
        self.mRiverBedDepth
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:194
    func GetPathDepth() -> Float {
        self.mPathDepth
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:195
    func GetBridgeName() -> String {
        self.mRiverBridge
    }

    /// Source: oracle/codemp/RMG/RM_Path.cpp:521
    // AI: Raven returns a reference to `mRiverPos`. The method returns a copy, because every caller only reads the vector.
    func GetRiverPos(_ x: Int32, _ y: Int32) -> JKAShared.vec3_t {
        self.mRiverPos[0] = Float(x + 1.0) / Float(self.mXNodes + 2)
        self.mRiverPos[1] = Float(y + 1.0) / Float(self.mYNodes + 2)
        return self.mRiverPos
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:198
    // AI: Raven returns a reference to one cell of `mCells`. The method returns a copy, and a caller that writes the cell writes the element of `mCells`.
    func Cell(_ x: Int32, _ y: Int32) -> CRMCell {
        self.mCells[x + y * self.mXNodes]
    }

    /// Source: oracle/codemp/RMG/RM_Path.h:199
    // AI: Raven returns a reference to one cell of `mCells`. The method returns a copy, and a caller that writes the cell writes the element of `mCells`.
    func RiverCell(_ x: Int32, _ y: Int32) -> CRMCell {
        self.mCells[x + y * (self.mXNodes + 1)]
    }

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::PlaceLocation
     * This method is used to determine if a named location should be placed at this node.
     *
     * inputs:
     *  c_x, c_y - cell to examine
     *
     * return:
     *	none
     *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Path.cpp:225
    func PlaceLocation(_ c_x: Int32, _ c_y: Int32) {
        if !self.Node(c_x, c_y)!.IsLocation() {
            // not currently a location

            // how many paths lead to this cell?
            var count_paths: Int32 = 0
            var i: Int32

            i = 0
            while i < DIR_MAX {
                if self.Node(c_x, c_y)!.PathExist(i) != 0 {
                    count_paths += 1
                }
                i += 1
            }

            var deepest_depth: Int32 = -1
            var deepest_loc: Int32 = -1
            // C converts the `size_t` size to the `int` index.
            i = Int32(self.mLocations.count) - 1
            while i >= 0 {
                if !self.mLocations[i]!.Placed() &&					// node has not been placed
                    self.mLocations[i]!.MinDepth() <= self.mDepth &&		// our current depth is in the proper range
                    self.mLocations[i]!.MaxDepth() >= self.mDepth &&
                    self.mLocations[i]!.MinPaths() <= count_paths && // our path count is in the proper range
                    self.mLocations[i]!.MaxPaths() >= count_paths &&
                    self.mLocations[i]!.MaxDepth() > deepest_depth	// and this is the deepest location of the ones that match
                {
                    deepest_loc = i
                    deepest_depth = self.mLocations[i]!.MaxDepth()
                }
                i -= 1
            }

            if deepest_loc >= 0 && deepest_loc < self.mLocations.count {
                // found a location to place at this node / cell
                let name = self.mLocations[deepest_loc]!.GetName()
                self.Node(c_x, c_y)!.SetName(name)
                self.mLocations[deepest_loc]!.SetPlaced(true)

                // need a new max depth
                var max_depth: Int32 = -1
                // C converts the `size_t` size to the `int` index.
                i = Int32(self.mLocations.count) - 1
                while i >= 0 {
                    // figure out new max depth based on the max depth of unplaced locations
                    if !self.mLocations[i]!.Placed() &&	   			// node has not been placed
                        self.mLocations[i]!.MaxDepth() > max_depth	// and this is the deepest
                    {
                        max_depth = self.mLocations[i]!.MaxDepth()
                    }
                    i -= 1
                }
                self.mMaxDepth = max_depth
            }
        }
    }

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::PathVisit
     * This method is called recursively to create a network of nodes connected with paths.
     *
     * inputs:
     *  c_x, c_y - cell to visit
     *
     * return:
     *	none
     *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Path.cpp:287
    func PathVisit(_ c_x: Int32, _ c_y: Int32) {
        // does this cell have any neighbors with all walls intact?
        var i: Int32
        var off: Int32

        // look at neighbors in random order
        off = TheRandomMissionManager!.GetLandScape()!.irand(DIR_FIRST, DIR_MAX - 1)

        self.mDepth += 1	// track our depth of recursion

        i = DIR_FIRST
        while i < DIR_MAX && self.mDepth <= self.mMaxDepth {
            let d: Int32 = (i + off) % DIR_MAX
            if !self.Cell(c_x, c_y).Border(d) {
                // we can move this way, since no border
                let new_c_x: Int32 = c_x + neighbor_x[d]
                let new_c_y: Int32 = c_y + neighbor_y[d]
                if self.Cell(new_c_x, new_c_y).Wall() == DIR_ALL {
                    // we have a new cell that has not been visited!
                    var new_dir: Int32
                    // d is the direction relative to the current cell
                    // new_dir is the direction relative to the next cell (N becomes S, NE becomes SW, etc...)
                    if d < HALF_DIR_MAX {
                        new_dir = d + HALF_DIR_MAX
                    } else {
                        new_dir = d - HALF_DIR_MAX
                    }

                    // knock down walls
                    // AI: Raven writes through the reference that Cell returns. The write goes to the element of `mCells`.
                    self.mCells[c_x + c_y * self.mXNodes].RemoveWall(d)
                    // AI: Raven writes through the reference that Cell returns. The write goes to the element of `mCells`.
                    self.mCells[new_c_x + new_c_y * self.mXNodes].RemoveWall(new_dir) //DIR_MAX - d);

                    // set path id
                    self.Node(c_x, c_y)!.SetPath(d, self.mPathCount)
                    self.Node(new_c_x, new_c_y)!.SetPath(new_dir, self.mPathCount) //DIR_MAX - d, mPathCount);

                    // create path between cells
                    self.mTerrain!.CreatePath(
                        self.mPathCount,
                        -1,
                        0,
                        self.mPathPoints,
                        self.GetNodePos(c_x, c_y)[0],
                        self.GetNodePos(c_x, c_y)[1],
                        self.GetNodePos(new_c_x, new_c_y)[0],
                        self.GetNodePos(new_c_x, new_c_y)[1],
                        self.mPathMinWidth,
                        self.mPathMaxWidth,
                        self.mPathDepth,
                        self.mPathDeviation,
                        self.mPathBreadth
                    )
                    self.mPathCount += 1

                    // flatten a small spot
                    let area = CArea()
                    let flat_radius: Float = self.mPathMaxWidth *
                        abs(TheRandomMissionManager!.GetLandScape()!.GetBounds()[1][0] - TheRandomMissionManager!.GetLandScape()!.GetBounds()[0][0])
                    area.Init(self.GetNodePos(c_x, c_y), flat_radius, 0.0, AT_NONE, 0, 0)
                    // C converts the `float` height to the `int` parameter.
                    TheRandomMissionManager!.GetLandScape()!.FlattenArea(area, Int32(255 * self.mPathDepth), false, true, true)

                    // recurse
                    self.PathVisit(new_c_x, new_c_y)
                }
            }
            i += 1
        }

        self.mDepth -= 1

        // NOTE: *whoop* hack alert, the first time this is reached, it should be the very last placed node.
        if !self.mCrossed && TheRandomMissionManager!.GetMission()!.GetSymmetric() != 0 &&
            TheRandomMissionManager!.GetMission()!.GetBackUpPath() != 0
        {
            self.mCrossed = true

            let directionSet: [[Int32]] = [[DIR_NW, DIR_W, DIR_SW], [DIR_N, -1, DIR_S], [DIR_NE, DIR_E, DIR_SE]]
            let ncx: Int32 = (self.mXNodes - 1) - c_x
            let ncy: Int32 = (self.mYNodes - 1) - c_y

            var x_delta: Int32 = ncx - c_x
            var y_delta: Int32 = ncy - c_y

            if x_delta < -1 {
                x_delta = -1
            } else if x_delta > 1 {
                x_delta = 1
            }

            if y_delta < -1 {
                y_delta = -1
            } else if y_delta > 1 {
                y_delta = 1
            }

            // make sure the mirror is actually in a different position than then un-mirrored node
            if x_delta != 0 || y_delta != 0 {

                // Port-note: Raven indexes the 3 by 3 table with a delta of -1, 0, or 1, so a delta of -1 reads outside the row or the table.
                // C leaves that read undefined, and the Swift subscript traps there.
                let d: Int32 = directionSet[x_delta][y_delta]
                var new_dir: Int32
                // d is the direction relative to the current cell
                // new_dir is the direction relative to the next cell (N becomes S, NE becomes SW, etc...)
                if d < HALF_DIR_MAX {
                    new_dir = d + HALF_DIR_MAX
                } else {
                    new_dir = d - HALF_DIR_MAX
                }

                //NOTE: Knocking down these walls will cause instances to be created on this new artificial path
                // Since this path could span more than just the normal 1 cell, these walls being knocked down are not exactly correct... but get the job done

                // knock down walls
                // AI: Raven writes through the reference that Cell returns. The write goes to the element of `mCells`.
                self.mCells[c_x + c_y * self.mXNodes].RemoveWall(d)
                // AI: Raven writes through the reference that Cell returns. The write goes to the element of `mCells`.
                self.mCells[ncx + ncy * self.mXNodes].RemoveWall(new_dir) //DIR_MAX - d);

                // set path id
                self.Node(c_x, c_y)!.SetPath(d, self.mPathCount)
                self.Node(ncx, ncy)!.SetPath(new_dir, self.mPathCount) //DIR_MAX - d, mPathCount);

                // create an artificial path that crosses over to connect the symmetric and non-symmetric map parts
                self.mTerrain!.CreatePath(
                    self.mPathCount,
                    -1,
                    0,
                    self.mPathPoints,
                    self.GetNodePos(c_x, c_y)[0],
                    self.GetNodePos(c_x, c_y)[1],
                    self.GetNodePos(ncx, ncy)[0],
                    self.GetNodePos(ncx, ncy)[1],
                    self.mPathMinWidth,
                    self.mPathMaxWidth,
                    self.mPathDepth,
                    self.mPathDeviation,
                    self.mPathBreadth
                )
                self.mPathCount += 1

            }
        }

        self.PlaceLocation(c_x, c_y)
    }

    /// Source: oracle/codemp/RMG/RM_Path.cpp:528
    func RiverVisit(_ c_x: Int32, _ c_y: Int32) {
        // does this cell have any neighbors with all walls intact?
        var i: Int32
        var off: Int32

        // look at neighbors in random order
        off = TheRandomMissionManager!.GetLandScape()!.irand(DIR_FIRST, DIR_MAX - 1)

        self.mDepth += 1	// track our depth of recursion

        i = DIR_FIRST
        while i < DIR_MAX && self.mDepth <= self.mMaxDepth {
            let d: Int32 = (i + off) % DIR_MAX
            if !self.Cell(c_x, c_y).Border(d) {
                // we can move this way, since no border
                let new_c_x: Int32 = c_x + neighbor_x[d]
                let new_c_y: Int32 = c_y + neighbor_y[d]
                if self.RiverCell(new_c_x, new_c_y).Wall() == DIR_ALL {
                    // we have a new cell that has not been visited!

                    var new_dir: Int32
                    // d is the direction relative to the current cell
                    // new_dir is the direction relative to the next cell (N becomes S, NE becomes SW, etc...)
                    if d < HALF_DIR_MAX {
                        new_dir = d + HALF_DIR_MAX
                    } else {
                        new_dir = d - HALF_DIR_MAX
                    }
                    // knock down walls
                    // AI: Raven writes through the reference that RiverCell returns. The write goes to the element of `mCells`.
                    self.mCells[c_x + c_y * (self.mXNodes + 1)].RemoveWall(d)
                    // AI: Raven writes through the reference that RiverCell returns. The write goes to the element of `mCells`.
                    self.mCells[new_c_x + new_c_y * (self.mXNodes + 1)].RemoveWall(new_dir) //DIR_MAX - d);

                    // create river between cells
                    self.mTerrain!.CreatePath(
                        self.mPathCount,
                        -1,
                        0,
                        self.mRiverPoints,
                        self.GetRiverPos(c_x, c_y)[0],
                        self.GetRiverPos(c_x, c_y)[1],
                        self.GetRiverPos(new_c_x, new_c_y)[0],
                        self.GetRiverPos(new_c_x, new_c_y)[1],
                        self.mRiverMinWidth,
                        self.mRiverMaxWidth,
                        self.mRiverBedDepth,
                        self.mRiverDeviation,
                        self.mRiverBreadth
                    )
                    self.mPathCount += 1

                    // flatten a small spot
                    let area = CArea()
                    let flat_radius: Float = self.mRiverMinWidth *
                        abs(TheRandomMissionManager!.GetLandScape()!.GetBounds()[1][0] - TheRandomMissionManager!.GetLandScape()!.GetBounds()[0][0])
                    area.Init(self.GetRiverPos(c_x, c_y), flat_radius, 0.0, AT_NONE, 0, 0)
                    // C converts the `float` height to the `int` parameter.
                    TheRandomMissionManager!.GetLandScape()!.FlattenArea(area, Int32(255 * self.mRiverBedDepth), false, true, true)

                    // recurse
                    self.RiverVisit(new_c_x, new_c_y)
                }
            }
            i += 2
        }

        //	--mDepth;
    }

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::SetPathStyle
     *	sets style for all paths
     *
     * inputs:
     *  settings for paths that are created
     *
     * return:
     *	none
     *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Path.cpp:472
    func SetPathStyle(
        _ points: Int32 = 10,
        _ minwidth: Float = 0.01,
        _ maxwidth: Float = 0.05,
        _ depth: Float = 0.3,
        _ deviation: Float = 0.2,
        _ breadth: Float = 5
    ) {
        // save path style
        self.mPathPoints = points
        self.mPathMinWidth = minwidth
        self.mPathMaxWidth = maxwidth
        self.mPathDepth = depth
        self.mPathDeviation = deviation
        self.mPathBreadth = breadth
    }

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::SetRiverStyle
     *	sets style for all rivers
     *
     * inputs:
     *  settings for river paths that are created
     *
     * return:
     *	none
     *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Path.cpp:501
    func SetRiverStyle(
        _ depth: Int32 = 5,
        _ points: Int32 = 10,
        _ minwidth: Float = 0.01,
        _ maxwidth: Float = 0.03,
        _ beddepth: Float = 0.0,
        _ deviation: Float = 0.25,
        _ breadth: Float = 7,
        _ bridge_name: String = ""
    ) {
        // save river style
        self.mRiverDepth = depth
        self.mRiverPoints = points
        self.mRiverMinWidth = minwidth
        self.mRiverMaxWidth = maxwidth
        self.mRiverBedDepth = beddepth
        self.mRiverDeviation = deviation
        self.mRiverBreadth = breadth
        self.mRiverBridge = bridge_name
    }

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::GeneratePaths
     *	Creates all paths
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
    /// Source: oracle/codemp/RMG/RM_Path.cpp:670
    func GeneratePaths(_ symmetric: symmetry_t = SYMMETRY_NONE) {
        var cell_x: Int32 = 0
        var cell_y: Int32 = 0

        switch symmetric {
        case SYMMETRY_TOPLEFT:
            cell_x = self.mXNodes - 1
            cell_y = 0

        case SYMMETRY_BOTTOMRIGHT:
            cell_x = 0
            cell_y = self.mYNodes - 1

        default:
            // choose starting cell along an edge
            switch TheRandomMissionManager!.GetLandScape()!.irand(0, 7) {
            case 0:
                cell_x = self.mXNodes / 2
            case 1:
                cell_x = self.mXNodes - 1
            case 2:
                cell_x = self.mXNodes - 1
                cell_y = self.mYNodes / 2
            case 3:
                cell_x = self.mXNodes - 1
                cell_y = self.mYNodes - 1
            case 4:
                cell_x = self.mXNodes / 2
                cell_y = self.mYNodes - 1
            case 5:
                cell_y = self.mYNodes - 1
            case 6:
                cell_y = self.mYNodes / 2
            default:
                break
            }
        }

        // visit the first cell
        self.PathVisit(cell_x, cell_y)
    }

    /**
    ```
    ***********************************************************************************************
     * CRMPathManager::GenerateRivers
     *	Creates a river which intersects the main path
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
    /// Source: oracle/codemp/RMG/RM_Path.cpp:605
    func GenerateRivers() {
        if self.mRiverBedDepth == 1 {
            // no rivers
            return
        }

        self.mMaxDepth = self.mRiverDepth
        self.mDepth = 0

        var cell_x: Int32 = 0
        var cell_y: Int32 = 0

        // choose starting cell along an edge
        let edge: Int32 = TheRandomMissionManager!.GetLandScape()!.irand(0, 7)
        switch edge {
        case 0:
            cell_x = self.mXNodes / 2
            cell_y = 0
        case 1:
            cell_x = self.mXNodes
            cell_y = 0
        case 2:
            cell_x = self.mXNodes
            cell_y = self.mYNodes / 2
        case 3:
            cell_x = self.mXNodes
            cell_y = self.mYNodes
        case 4:
            cell_x = self.mXNodes / 2
            cell_y = self.mYNodes
        case 5:
            cell_x = 0
            cell_y = self.mYNodes
        case 6:
            cell_x = 0
            cell_y = self.mYNodes / 2
        case 7:
            cell_x = 0
            cell_y = 0
        default:
            break
        }

        self.ClearCells(self.mXNodes + 1, self.mYNodes + 1)

        self.mRiverCount = self.mPathCount

        // visit the first cell
        self.RiverVisit(cell_x, cell_y)

        self.mRiverCount = self.mPathCount - self.mRiverCount

        return
    }
}
