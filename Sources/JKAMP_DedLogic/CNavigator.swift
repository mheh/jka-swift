import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/NPCNav/navigator.h:40
// AI: Raven declares a `multimap<int, int>`. The type is a Dictionary of arrays, one array of values for each key.
typealias EdgeMultimap = [Int32: [Int32]]

// AI: Raven declares `EdgeMultimapIt`, the iterator of the multimap at navigator.h:41.
// A Dictionary of arrays has no such iterator, so the type drops.

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:961
// AI: Raven declares a `map < int, bool >` for ShowEdges. The type is a Dictionary, by rule 17.
typealias drawMap_m = [Int32: Bool]

/// Raven's NPC navigator, the waypoint graph of the level and the path search over it.
/// One instance exists, `navigator`, and the game reaches it through the `trap_Nav_` calls.
/// Source: oracle/codemp/server/NPCNav/navigator.h:134
// AI: Raven's destructor at navigator.cpp:486 has an empty body. The deinit frees the allocation of `failedEdges`.
final class CNavigator {
    /// Source: oracle/codemp/server/NPCNav/navigator.h:136
    // AI: Raven declares a `vector < CNode * >`. The type is an Array of the optional class, by rule 17.
    private typealias node_v = [CNode?]
    /// Source: oracle/codemp/server/NPCNav/navigator.h:137
    // AI: Raven declares a `list < CEdge >`. The type is an Array, by rule 17.
    private typealias edge_l = [CEdge]

    /// Source: oracle/codemp/server/NPCNav/navigator.h:141
    private struct nodeList_t {
        var nodeID: Int32 = 0
        var distance: UInt32 = 0
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:147
    // AI: Raven declares a `list < nodeList_t >`. The type is an Array, by rule 17.
    private typealias nodeChain_l = [nodeList_t]

    var pathsCalculated: Bool = false

    //rww - made failedEdges private as it doesn't seem to need to be public.
    //And I'd rather shoot myself than have to devise a way of setting/accessing this
    //array via trap calls.
    // AI: Raven holds MAX_FAILED_EDGES `failedEdge_t` records in the class.
    // The instance owns one allocation of the records, zeroed as C zeroes the global `navigator`, and the deinit frees it.
    private let failedEdges: Slots<JKAMP.FailedEdge> = {
        let failedEdges = Slots<JKAMP.FailedEdge>.new(count: MAX_FAILED_EDGES)
        failedEdges.zero(count: MAX_FAILED_EDGES)
        return failedEdges
    }()

    private var m_nodes: node_v = []
    private var m_edgeLookupMap: EdgeMultimap = [:]

    /**
    ```
    -------------------------
    CNavigator
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:478
    init() {
        if d_altRoutes == nil || d_patched == nil {
            NAV_CvarInit()
        }
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:486
    deinit {
        self.failedEdges.delete()
    }

    /**
    ```
    -------------------------
    Init
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:572
    func Init() {
        self.Free()
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:583
    func Free() {
        // AI: Raven deletes each node in a loop. Emptying the array frees them.
        self.m_nodes.removeAll()
        self.m_edgeLookupMap.removeAll()
    }

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:602
    func Load(_ filename: String, _ checksum: Int32) -> Bool {
        var file: JKAShared.fileHandle_t = 0

        //Attempt to load the file
        _ = FS_FOpenFileByMode(va("maps/%s.nav", filename), &file, FS_READ)

        //See if we succeeded
        if file == 0 {
            return false
        }

        //Check the header id
        let navID = self.GetLong(file)

        // AI: Raven compares with NAV_HEADER_ID of navigator.h, which no module of the host declares. The body reads its value, 'JNV5'.
        if navID != 0x4A4E_5635 {
            FS_FCloseFile(file)
            return false
        }

        //Check the checksum to see if this file is out of date
        let check = self.GetInt(file)

        if check != checksum {
            FS_FCloseFile(file)
            return false
        }

        let numNodes = self.GetInt(file)

        var i: Int32 = 0
        while i < numNodes {
            let node = CNode.Create()

            if node!.Load(numNodes, file) == 0 {
                FS_FCloseFile(file)
                return false
            }

            self.m_nodes.append(node)
            i += 1
        }

        //read in the failed edges
        // AI: Raven reads `sizeof( failedEdges )`. The body reads the bytes of the records, the form of ClearAllFailedEdges.
        _ = FS_Read(self.failedEdges.bytes, Int32(JKAMP.FailedEdge.byteCount * Int(MAX_FAILED_EDGES)), file)
        var j: Int32 = 0
        while j < MAX_FAILED_EDGES {
            self.m_edgeLookupMap[self.failedEdges[j].startID, default: []].append(j)
            j += 1
        }

        FS_FCloseFile(file)

        return true
    }

    /**
    ```
    -------------------------
    Save
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:665
    func Save(_ filename: String, _ checksum: Int32) -> Bool {
        var file: JKAShared.fileHandle_t = 0

        //Attempt to load the file
        _ = FS_FOpenFileByMode(va("maps/%s.nav", filename), &file, FS_WRITE)

        if file == 0 {
            return false
        }

        // AI: Raven writes each value through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        var value = CharBuf(Int32.byteCount)

        //Write out the header id
        // AI: Raven writes an `unsigned long` of NAV_HEADER_ID of navigator.h, 4 bytes on WinDed. The body writes its value, 'JNV5'.
        value.withMutableSlots { $0[int: 0] = 0x4A4E_5635 }
        _ = FS_Write(value, Int32(UInt32.byteCount), file)

        //Write out the checksum
        value.withMutableSlots { $0[int: 0] = checksum }
        _ = FS_Write(value, Int32(Int32.byteCount), file)

        let numNodes = Int32(self.m_nodes.count)

        //Write out the number of nodes to follow
        value.withMutableSlots { $0[int: 0] = numNodes }
        _ = FS_Write(value, Int32(Int32.byteCount), file)

        //Write out all the nodes
        for ni in self.m_nodes {
            _ = ni!.Save(numNodes, file)
        }

        //write out failed edges
        // AI: Raven writes `sizeof( failedEdges )`. The body writes the bytes of the 32 records, the form of ClearAllFailedEdges.
        _ = FS_Write(self.failedEdges.bytes, Int32(JKAMP.FailedEdge.byteCount * Int(MAX_FAILED_EDGES)), file)

        FS_FCloseFile(file)

        return true
    }

    /**
    ```
    -------------------------
    AddRawPoint
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:710
    func AddRawPoint(_ point: JKAShared.vec3_t, _ flags: Int32, _ radius: Int32) -> Int32 {
        let node = CNode.Create(point, flags, radius, Int32(self.m_nodes.count))

        if node == nil {
            Com_Error(ERR_DROP, "Error adding node!\n")
        }

        //TODO: Validate the position
        //TODO: Correct stuck waypoints

        self.m_nodes.append(node)

        return node!.GetID()
    }

    /**
    ```
    -------------------------
    CalculatePaths
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:884
    func CalculatePaths(_ recalc: Bool = false) {
        var i: Int32 = 0
        while i < self.m_nodes.count {
            //Allocate the needed memory
            self.m_nodes[i]!.InitRanks(Int32(self.m_nodes.count))
            i += 1
        }

        i = 0
        while i < self.m_nodes.count {
            self.CalculatePath(self.m_nodes[i])
            i += 1
        }

        if !recalc {	//Mike says doesn't need to happen on recalc
            GNavCallback_CP_FindCombatPointWaypoints()
        }

        self.pathsCalculated = true
    }

    /**
    ```
    -------------------------
    HardConnect
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1113
    func HardConnect(_ first: Int32, _ second: Int32) {
        let start: CNode?
        let end: CNode?

        start = self.m_nodes[first]
        end = self.m_nodes[second]

        var p1 = vec3_t()
        var p2 = vec3_t()

        start!.GetPosition(&p1)
        end!.GetPosition(&p2)

        // Raven's record lives to the end of his function, so the rest of the function is the closure.
        Trace.scratch { trace in
            var flags: Int32 = EFLAG_NONE

            SV_Trace(trace, p1, wpMins, wpMaxs, p2, ENTITYNUM_NONE, JKAShared.MASK_SOLID | CONTENTS_BOTCLIP | CONTENTS_MONSTERCLIP, 0, 0, 10)

            let cost = Int32(Distance(p1, p2))

            if trace.fraction != 1.0 || trace.startsolid == 1 || trace.allsolid == 1 {
                flags |= EFLAG_BLOCKED
            }

            start!.AddEdge(second, cost, flags)
            end!.AddEdge(first, cost, flags)
        }
    }

    /**
    ```
    -------------------------
    ShowNodes
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:916
    func ShowNodes() {
        var position = vec3_t()
        var showRadius: Bool
        var dist: Float
        var radius: Float

        for ni in self.m_nodes {
            ni!.GetPosition(&position)

            showRadius = false
            //if( NAVDEBUG_showRadius )
            if false {
                dist = DistanceSquared(SV_GentityNum(0)!.r.currentOrigin, position)
                radius = Float(ni!.GetRadius())
                // if player within node radius or 256, draw radius (sometimes the radius is really small, so we check for 256 to catch everything)
                if (dist <= radius * radius) || dist <= 65536 {
                    showRadius = true
                }
            } else {
                dist = DistanceSquared(SV_GentityNum(0)!.r.currentOrigin, position)
            }
            if dist < 1048576 {
                if SV_inPVS(SV_GentityNum(0)!.r.currentOrigin, position) {
                    ni!.Draw(showRadius)
                }
            }
        }
    }

    /**
    ```
    -------------------------
    ShowEdges
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:963
    func ShowEdges() {
        var start = vec3_t()
        var end = vec3_t()

        var drawMap: [drawMap_m]

        drawMap = Array(repeating: [:], count: self.m_nodes.count)

        for ni in self.m_nodes {
            ni!.GetPosition(&start)
            if DistanceSquared(SV_GentityNum(0)!.r.currentOrigin, start) >= 1048576 {
                continue
            }

            if !SV_inPVS(SV_GentityNum(0)!.r.currentOrigin, start) {
                continue
            }

            //Attempt to draw each connection
            var i: Int32 = 0
            while i < ni!.GetNumEdges() {
                let id = ni!.GetEdge(i)

                if id == -1 {
                    i += 1
                    continue
                }

                //Already drawn?
                if drawMap[ni!.GetID()][id] != nil {
                    i += 1
                    continue
                }

                //BYTE flags = (*ni)->GetEdgeFlags( i );

                let node = self.m_nodes[id]

                node!.GetPosition(&end)

                //Set this as drawn
                drawMap[id][ni!.GetID()] = true

                if DistanceSquared(SV_GentityNum(0)!.r.currentOrigin, end) >= 1048576 {
                    i += 1
                    continue
                }

                if !SV_inPVS(SV_GentityNum(0)!.r.currentOrigin, end) {
                    i += 1
                    continue
                }

                /*
                if ( EdgeFailed( id, (*ni)->GetID() ) != -1 )//flags & EFLAG_FAILED )
                    CG_DrawEdge( start, end, EDGE_FAILED );
                else if ( flags & EFLAG_BLOCKED )
                    CG_DrawEdge( start, end, EDGE_BLOCKED );
                else
                    CG_DrawEdge( start, end, EDGE_NORMAL );
                */
                //rwwFIXMEFIXME: ...
                i += 1
            }
        }
    }

    /**
    ```
    -------------------------
    ShowPath
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1632
    func ShowPath(_ start: Int32, _ end: Int32) {
        //Validate the start position
        if (start < 0) || (start >= self.m_nodes.count) {
            return
        }

        //Validate the end position
        if (end < 0) || (end >= self.m_nodes.count) {
            return
        }

        let startNode = self.m_nodes[start]
        let endNode = self.m_nodes[end]

        var moveNode = startNode
        var testNode: CNode? = nil

        var bestNode: Int32
        var startPos = vec3_t()
        var endPos = vec3_t()

        var runAway: Int32 = 0

        //Draw out our path
        while moveNode !== endNode {
            bestNode = self.GetBestNode(moveNode!.GetID(), end)

            //Some nodes may be fragmented
            if bestNode == -1 {
                Com_Printf("No connection possible between node %d and %d\n", start, end)
                return
            }

            //This is our next node on the path
            testNode = self.m_nodes[bestNode]

            //Get their origins
            moveNode!.GetPosition(&startPos)
            testNode!.GetPosition(&endPos)

            //Draw the edge
            //rwwFIXMEFIXME: ...
            //CG_DrawEdge( startPos, endPos, EDGE_PATH );

            //Take a new best node
            moveNode = testNode

            if runAway > 64 {
                Com_Printf("Potential Run-away path!\n")
                return
            }
            runAway += 1
        }
    }

    /**
    ```
    -------------------------
    GetNearestWaypoint
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1514
    func GetNearestNode(_ ent: JKAMP.SharedEntity?, _ lastID: Int32, _ flags: Int32, _ targetID: Int32) -> Int32 {
        var bestNode: Int32 = NODE_NONE
        //Must have nodes
        if self.m_nodes.count == 0 {
            return NODE_NONE
        }

        if targetID == NODE_NONE {
            //Try and find an early match using our last node
            bestNode = self.TestBestFirst(ent, lastID, flags)

            if bestNode != NODE_NONE {
                return bestNode
            }
        }//else can't rely on testing last, we want best to targetID

        /////////////////////////////////////////////////

        var nodeChain = nodeChain_l()

        //Collect all nodes within a certain radius
        _ = self.CollectNearestNodes(ent!.r.currentOrigin, NODE_COLLECT_RADIUS, NODE_COLLECT_MAX, &nodeChain)

        var position = vec3_t()
        var radius: Int32
        var dist: Int32
        var bestDist: Int32 = Q3_INFINITE
        var node: CNode?

        //Look through all nodes
        for nci in nodeChain {
            node = self.m_nodes[nci.nodeID]

            node!.GetPosition(&position)

            radius = node!.GetRadius()

            if self.NodeFailed(ent, nci.nodeID) {
                continue
            }
            //Are we within the known clear radius of this node?
            // C converts the `int` square to `unsigned` for the compare.
            if nci.distance < UInt32(bitPattern: radius * radius) {
                //Do a z-difference sanity check
                if abs(position[2] - ent!.r.currentOrigin[2]) < MAX_Z_DELTA {
                    //Found one
                    return nci.nodeID
                }
            }

            //We're not *within* this node, so...
            if self.CheckedNode(nci.nodeID, ent!.s.number) == CHECKED_FAILED {
                continue
            } else if self.CheckedNode(nci.nodeID, ent!.s.number) == CHECKED_FAILED {
                continue
            } else {
                //Do we need a clear path?
                if (flags & NF_CLEAR_PATH) != 0 {
                    if self.TestNodePath(ent, ENTITYNUM_NONE, position, false) == 0 {//qtrue?
                        self.SetCheckedNode(nci.nodeID, ent!.s.number, CHECKED_FAILED)
                        continue
                    }
                }

                //Do we need a clear line of sight?
                /*
                if ( flags & NF_CLEAR_LOS )
                {
                    if ( TestNodeLOS( ent, position ) == false )
                    {
                        nodeChecked[(*nci).nodeID][ent->s.number] = CHECKED_FAILED;
                        continue;
                    }
                }
                */
                self.SetCheckedNode(nci.nodeID, ent!.s.number, CHECKED_PASSED)
            }

            if targetID != WAYPOINT_NONE {//we want to find the one with the shortest route here
                // C converts the unsigned cost to `int` at the store.
                dist = Int32(bitPattern: self.GetPathCost(nci.nodeID, targetID))
                if dist < bestDist {
                    bestDist = dist
                    bestNode = nci.nodeID
                }
            } else {//first one we find is fine
                bestNode = nci.nodeID
                break
            }
        }

        //Found one, we're done
        return bestNode
    }

    /**
    ```
    -------------------------
    GetBestNode
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2377
    func GetBestNode(_ startID: Int32, _ endID: Int32, _ rejectID: Int32 = NODE_NONE) -> Int32 {
        //Validate the start position
        if (startID < 0) || (startID >= self.m_nodes.count) {
            return WAYPOINT_NONE
        }

        //Validate the end position
        if (endID < 0) || (endID >= self.m_nodes.count) {
            return WAYPOINT_NONE
        }

        if startID == endID {
            return startID
        }

        let start = self.m_nodes[startID]
        let end = self.m_nodes[endID]

        var bestNode: Int32 = -1
        var bestRank: Int32 = Q3_INFINITE
        var testRank: Int32
        var rejectRank: Int32 = 0

        if rejectID != WAYPOINT_NONE {
            var i: Int32 = 0
            while i < start!.GetNumEdges() {
                if start!.GetEdge(i) == rejectID {
                    rejectRank = end!.GetRank(start!.GetEdge(i))
                    break
                }
                i += 1
            }
        }

        var i: Int32 = 0
        while i < start!.GetNumEdges() {
            let edgeID = start!.GetEdge(i)

            //Found one
            if edgeID == endID {
                return edgeID
            }

            testRank = end!.GetRank(edgeID)

            //Found one
            if testRank <= rejectRank {
                i += 1
                continue
            }

            //No possible connection
            if testRank == NODE_NONE {
                return NODE_NONE
            }

            //Found a better one
            if testRank < bestRank {
                bestNode = edgeID
                bestRank = testRank
            }
            i += 1
        }

        return bestNode
    }

    /**
    ```
    -------------------------
    GetNodePosition
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2444
    func GetNodePosition(_ nodeID: Int32, _ out: inout JKAShared.vec3_t) -> Int32 {
        //Validate the number
        if (nodeID < 0) || (nodeID >= self.m_nodes.count) {
            return 0
        }

        let node = self.m_nodes[nodeID]

        node!.GetPosition(&out)

        return 1
    }

    /**
    ```
    -------------------------
    GetNodeNumEdges
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2463
    func GetNodeNumEdges(_ nodeID: Int32) -> Int32 {
        if (nodeID < 0) || (nodeID >= self.m_nodes.count) {
            return -1
        }

        let node = self.m_nodes[nodeID]

        return node!.GetNumEdges()
    }

    /**
    ```
    -------------------------
    GetNodeEdge
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2481
    func GetNodeEdge(_ nodeID: Int32, _ edge: Int32) -> Int32 {
        if (nodeID < 0) || (nodeID >= self.m_nodes.count) {
            return -1
        }

        let node = self.m_nodes[nodeID]

        return node!.GetEdge(edge)
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:182
    // Port-note: Rule 20. Raven declares this method in navigator.h, defines no body for it, and no file calls it, so it keeps its marker.
    func GetNodeLeadDistance(_ nodeID: Int32) -> Float {
        // TODO: Port CNavigator::GetNodeLeadDistance
        portMissing("CNavigator::GetNodeLeadDistance", source: "oracle/codemp/server/NPCNav/navigator.h:182")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:184
    func GetNumNodes() -> Int32 {
        return Int32(self.m_nodes.count)
    }

    /**
    ```
    -------------------------
    Connected
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2499
    func Connected(_ startID: Int32, _ endID: Int32) -> Bool {
        //Validate the start position
        if (startID < 0) || (startID >= self.m_nodes.count) {
            return false
        }

        //Validate the end position
        if (endID < 0) || (endID >= self.m_nodes.count) {
            return false
        }

        if startID == endID {
            return true
        }

        let start = self.m_nodes[startID]
        let end = self.m_nodes[endID]

        var i: Int32 = 0
        while i < start!.GetNumEdges() {
            let edgeID = start!.GetEdge(i)

            //Found one
            if edgeID == endID {
                return true
            }

            if (end!.GetRank(edgeID)) != NODE_NONE {
                return true
            }
            i += 1
        }

        return false
    }

    /**
    ```
    -------------------------
    GetPathCost
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2536
    func GetPathCost(_ startID: Int32, _ endID: Int32) -> UInt32 {
        //Validate the start position
        if (startID < 0) || (startID >= self.m_nodes.count) {
            return UInt32(Q3_INFINITE) // return 0;
        }

        //Validate the end position
        if (endID < 0) || (endID >= self.m_nodes.count) {
            return UInt32(Q3_INFINITE) // return 0;
        }

        let startNode = self.m_nodes[startID]

        if startNode!.GetNumEdges() == 0 {//WTF?  Solitary waypoint!  Bad designer!
            return UInt32(Q3_INFINITE) // return 0;
        }

        let endNode = self.m_nodes[endID]

        var moveNode = startNode

        var bestNode: Int32
        var pathCost: Int32 = 0
        var bestCost: Int32

        var bestRank: Int32
        var testRank: Int32

        var dontScrewUp: Int32 = 0

        //Draw out our path
        while moveNode !== endNode {
            bestRank = WORLD_SIZE
            bestNode = -1
            bestCost = 0

            var i: Int32 = 0
            while i < moveNode!.GetNumEdges() {
                let edgeID = moveNode!.GetEdge(i)

                //Done
                if edgeID == endID {
                    // Port-note: Raven's `int` sum can pass INT_MAX on a path through failed edges, which C leaves undefined. The sum wraps.
                    // C converts the `int` sum to the unsigned return.
                    return UInt32(bitPattern: pathCost &+ moveNode!.GetEdgeCost(i))
                }

                testRank = endNode!.GetRank(edgeID)

                //No possible connection
                if testRank == NODE_NONE {
                    return UInt32(Q3_INFINITE) // return 0;
                }

                //Found a better one
                if testRank < bestRank {
                    bestNode = edgeID
                    bestRank = testRank
                    bestCost = moveNode!.GetEdgeCost(i)
                }
                i += 1
            }

            // Port-note: Raven's `int` sum can pass INT_MAX on a path through failed edges, which C leaves undefined. The sum wraps.
            pathCost = pathCost &+ bestCost

            //Take a new best node
            moveNode = self.m_nodes[bestNode]
            dontScrewUp += 1

            if dontScrewUp > 40000 {//ok, I think something probably screwed up.
                break
            }
        }

        // C converts the `int` sum to the unsigned return.
        return UInt32(bitPattern: pathCost)
    }

    /**
    ```
    -------------------------
    GetEdgeCost
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2621
    func GetEdgeCost(_ startID: Int32, _ endID: Int32) -> UInt32 {
        //Validate the start position
        if (startID < 0) || (startID >= self.m_nodes.count) {
            return UInt32(Q3_INFINITE) // return 0;
        }

        //Validate the end position
        if (endID < 0) || (endID >= self.m_nodes.count) {
            return UInt32(Q3_INFINITE) // return 0;
        }

        let start = self.m_nodes[startID]
        let end = self.m_nodes[endID]

        // C converts the `int` cost to the unsigned return.
        return UInt32(bitPattern: self.GetEdgeCost(start, end))
    }

    /**
    ```
    -------------------------
    GetProjectedNode
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2643
    func GetProjectedNode(_ origin: JKAShared.vec3_t, _ nodeID: Int32) -> Int32 {
        //Validate the start position
        if (nodeID < 0) || (nodeID >= self.m_nodes.count) {
            return NODE_NONE
        }

        let node = self.m_nodes[nodeID]
        var tempNode: CNode?

        var bestDot: Float = 0.0
        var bestNode: Int32 = NODE_NONE

        var targetDir = vec3_t()
        var basePos = vec3_t()
        var tempDir = vec3_t()
        var tempPos = vec3_t()
        var dot: Float

        //Setup our target direction
        node!.GetPosition(&basePos)

        targetDir = origin - basePos
        _ = VectorNormalize(&targetDir)

        //Go through all the edges
        var i: Int32 = 0
        while i < node!.GetNumEdges() {
            tempNode = self.m_nodes[node!.GetEdge(i)]
            tempNode!.GetPosition(&tempPos)

            tempDir = tempPos - basePos
            _ = VectorNormalize(&tempDir)	//FIXME: Retain the length here if you want it

            dot = _DotProduct(targetDir, tempDir)

            if dot < 0.0 {
                i += 1
                continue
            }

            if dot > bestDot {
                bestDot = dot
                bestNode = tempNode!.GetID()
            }
            i += 1
        }

        return bestNode
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1724
    func CheckFailedNodes(_ ent: JKAMP.SharedEntity?) {
        var nodePos = vec3_t()
        var j: Int32

        //Must have nodes
        if self.m_nodes.count == 0 {
            return
        }

        if ent!.failedWaypointCheckTime != 0 && ent!.failedWaypointCheckTime < svs.time {
            var failed: Int32 = 0
            //do this only once every 1 second
            j = 0
            while j < MAX_FAILED_NODES {
                if ent!.failedWaypoints[j] != 0 {
                    failed += 1
                    //-1 because 0 is a valid node but also the default, so we add one when we add one
                    self.m_nodes[ent!.failedWaypoints[j] - 1]!.GetPosition(&nodePos)
                    if !GNavCallback_NAV_ClearPathToPoint(ent!, ent!.r.mins, ent!.r.maxs, nodePos, (CONTENTS_SOLID | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP), ENTITYNUM_NONE) {//no path clear of architecture, so clear this since we can't check against entities
                        ent!.failedWaypoints[j] = 0
                        failed -= 1
                    } else if GNavCallback_NAV_ClearPathToPoint(ent!, ent!.r.mins, ent!.r.maxs, nodePos, CONTENTS_BODY, ENTITYNUM_NONE) {
                        //have clear architectural path, now check against ents only
                        //clear of ents, too, so all clear, clear this one out
                        ent!.failedWaypoints[j] = 0
                        failed -= 1
                    }
                }
                j += 1
            }
            if failed == 0 {
                ent!.failedWaypointCheckTime = 0
            } else {
                ent!.failedWaypointCheckTime = svs.time + CHECK_FAILED_EDGE_INTERVAL + Q_irand(0, 1000)
            }
        }
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1768
    func AddFailedNode(_ ent: JKAMP.SharedEntity?, _ nodeID: Int32) {
        var j: Int32 = 0
        while j < MAX_FAILED_NODES {
            if ent!.failedWaypoints[j] == 0 {
                ent!.failedWaypoints[j] = nodeID + 1//+1 because 0 is the default value and that's a valid node, so we take the +1 out when we check the node above
                if ent!.failedWaypointCheckTime == 0 {
                    ent!.failedWaypointCheckTime = svs.time + CHECK_FAILED_EDGE_INTITIAL
                }
                return
            }
            if ent!.failedWaypoints[j] == nodeID + 1 {//already have this one marked as failed
                return
            }
            j += 1
        }
        if j == MAX_FAILED_NODES {//check not needed, but...
            //ran out of failed nodes, get rid of first one, shift rest up
            j = 0
            while j < MAX_FAILED_NODES - 1 {
                ent!.failedWaypoints[j] = ent!.failedWaypoints[j + 1]
                j += 1
            }
        }
        ent!.failedWaypoints[MAX_FAILED_NODES - 1] = nodeID + 1
        if ent!.failedWaypointCheckTime == 0 {
            ent!.failedWaypointCheckTime = svs.time + CHECK_FAILED_EDGE_INTITIAL
        }
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1801
    func NodeFailed(_ ent: JKAMP.SharedEntity?, _ nodeID: Int32) -> Bool {
        var j: Int32 = 0
        while j < MAX_FAILED_NODES {
            if (ent!.failedWaypoints[j] - 1) == nodeID {
                return true
            }
            j += 1
        }
        return false
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1813
    func NodesAreNeighbors(_ startID: Int32, _ endID: Int32) -> Bool {
        //See if these 2 are neighbors
        if startID == endID {
            return false
        }

        let start = self.m_nodes[startID]
        var nextID: Int32 = -1
        //NOTE: we only check start because we assume all connections are 2-way
        var i: Int32 = 0
        while i < start!.GetNumEdges() {
            nextID = start!.GetEdge(i)
            if nextID == endID {
                return true
            }
            i += 1
        }
        //not neighbors
        return false
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1835
    func ClearFailedEdge(_ failedEdge: JKAMP.FailedEdge?) {
        if failedEdge == nil {
            return
        }

        //clear the edge failed flags
        /*
        CNode *node = m_nodes[failedEdge->startID];
        int edgeNum = node->GetEdgeNumToNode( failedEdge->endID );
        int	flags;
        if ( edgeNum != -1 )
        {
            flags = node->GetEdgeFlags( edgeNum )&~EFLAG_FAILED;
            node->SetEdgeFlags( edgeNum, flags );
        }
        node = m_nodes[failedEdge->endID];
        edgeNum = node->GetEdgeNumToNode( failedEdge->startID );
        if ( edgeNum != -1 )
        {
            flags = node->GetEdgeFlags( edgeNum )&~EFLAG_FAILED;
            node->SetEdgeFlags( edgeNum, flags );
        }
        */
        //clear failedEdge info
        self.SetEdgeCost(failedEdge!.startID, failedEdge!.endID, -1)
        failedEdge!.endID = WAYPOINT_NONE
        failedEdge!.startID = failedEdge!.endID
        failedEdge!.entID = ENTITYNUM_NONE
        failedEdge!.checkTime = 0
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1867
    func ClearAllFailedEdges() {
        // AI: Raven calls memset over `sizeof( failedEdges )`. The body calls Com_Memset over the bytes of the records, the form of cm_test.swift:456.
        Com_Memset(self.failedEdges.bytes, WAYPOINT_NONE, JKAMP.FailedEdge.byteCount * Int(MAX_FAILED_EDGES))
        var j: Int32 = 0
        while j < MAX_FAILED_EDGES {
            self.ClearFailedEdge(self.failedEdges[j])
            j += 1
        }
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1876
    func EdgeFailed(_ startID: Int32, _ endID: Int32) -> Int32 {
        //OPTIMIZED WAY  (bjg 01/02)
        //find in lookup map
        // AI: Raven walks the equal_range of the multimap. The body walks the Array of the key, which holds the values in their insert order.
        for value in self.m_edgeLookupMap[startID] ?? [] {
            if self.failedEdges[value].endID == endID {
                return value
            }
        }
        for value in self.m_edgeLookupMap[endID] ?? [] {
            if self.failedEdges[value].endID == startID {
                return value
            }
        }

        return -1

        //Old way (linear search)
        /*
        for ( int j = 0; j < MAX_FAILED_EDGES; j++ )
        {
            if ( failedEdges[j].startID == startID )
            {
                if ( failedEdges[j].endID == endID )
                {
                    return j;
                }
            }
            else if ( failedEdges[j].startID == endID )
            {
                if ( failedEdges[j].endID == startID )
                {
                    return j;
                }
            }
        }
        return -1;
        */
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1925
    func AddFailedEdge(_ entID: Int32, _ startID: Int32, _ endID: Int32) {
        var j: Int32 //, nextID;

        //Must have nodes
        if self.m_nodes.count == 0 {
            return
        }

        if d_patched!.integer != 0 {//use patch-style navigation
            if startID == endID {//not an edge!
                return
            }
        }

        //Validate the ent number
        if (entID < 0) || (entID > ENTITYNUM_NONE) {
            Com_Printf(S_COLOR_RED + "NAV ERROR: envalid ent %d\n", entID)
            return
        }

        //Validate the start position
        if (startID < 0) || (startID >= self.m_nodes.count) {
            Com_Printf(S_COLOR_RED + "NAV ERROR: tried to fail invalid waypoint %d\n", startID)
            return
        }

        //Validate the end position
        if (endID < 0) || (endID >= self.m_nodes.count) {
            Com_Printf(S_COLOR_RED + "NAV ERROR: tried to fail invalid waypoint %d\n", endID)
            return
        }

        //First see if we already have this one
        j = self.EdgeFailed(startID, endID)
        if j != -1 {
            //just remember this guy instead
            self.failedEdges[j].entID = entID
            return
        }

        //Okay, new one, find an empty slot
        j = 0
        while j < MAX_FAILED_EDGES {
            if self.failedEdges[j].startID == WAYPOINT_NONE {
                self.failedEdges[j].startID = startID
                self.failedEdges[j].endID = endID
                //Check one second from now to see if it's clear
                self.failedEdges[j].checkTime = svs.time + CHECK_FAILED_EDGE_INTERVAL + Q_irand(0, 1000)

                self.m_edgeLookupMap[startID, default: []].append(j)

                /*
                //DISABLED this for now, makes people stand around too long when
                //			collision avoidance just wasn't at it's best but path is clear
                CNode *start = m_nodes[startID];
                CNode *end = m_nodes[endID];

                for ( int i = 0; i < start->GetNumEdges(); i++ )
                {
                    nextID = start->GetEdge(i);

                    if ( EdgeFailed( startID, nextID ) != -1 )
                    {
                        //This edge blocked, check next
                        continue;
                    }

                    if ( nextID == endID || end->GetRank( nextID ) >= 0 )
                    {//neighbor of or route to end
                        //There's an alternate route, so don't check this one for 10 seconds
                        failedEdges[j].checkTime = svs.time + CHECK_FAILED_EDGE_INTITIAL;
                        break;
                    }
                }
                */

                //Remember who needed it
                self.failedEdges[j].entID = entID

                //set the edge failed flags
                /*
                CNode *node = m_nodes[startID];
                int edgeNum = node->GetEdgeNumToNode( endID );
                int	flags;
                if ( edgeNum != -1 )
                {
                    flags = node->GetEdgeFlags( edgeNum )|EFLAG_FAILED;
                    node->SetEdgeFlags( edgeNum, flags );
                }
                node = m_nodes[endID];
                edgeNum = node->GetEdgeNumToNode( startID );
                if ( edgeNum != -1 )
                {
                    flags = node->GetEdgeFlags( edgeNum )|EFLAG_FAILED;
                    node->SetEdgeFlags( edgeNum, flags );
                }
                */

                //stuff the index to this one in our lookup map

                //now recalc all the paths!
                if self.pathsCalculated {
                    //reconnect the nodes and mark every node's flag NF_RECALC
                    //Com_Printf( S_COLOR_CYAN"%d marking all nodes for recalc\n", svs.time );
                    self.SetEdgeCost(startID, endID, Q3_INFINITE)
                    self.FlagAllNodes(NF_RECALC)
                }
                return
            }
            j += 1
        }

        Com_Printf(S_COLOR_RED + "NAV ERROR: too many blocked waypoint connections (%d)!!!\n", j)
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2057
    func CheckFailedEdge(_ failedEdge: JKAMP.FailedEdge?) -> Bool {
        if failedEdge == nil {
            return false
        }

        //Every 1 second, see if our failed edges are clear
        if failedEdge!.checkTime < svs.time {
            if failedEdge!.startID != WAYPOINT_NONE {
                var start = vec3_t()
                var end = vec3_t()
                var mins = vec3_t()
                var maxs = vec3_t()
                let ignore: Int32
                let clipmask: Int32
                let ent = SV_GentityNum(failedEdge!.entID) //(failedEdge->entID<ENTITYNUM_WORLD)?&g_entities[failedEdge->entID]:NULL;
                var hitEntNum: Int32

                if ent == nil || /*!ent->inuse || !ent->client || ent->health <= 0*/ (ent!.s.eType != ET_PLAYER && ent!.s.eType != ET_NPC)
                    || (ent!.s.eFlags & EF_DEAD) != 0 {
                    mins = vec3_t(-15, -15, Float(DEFAULT_MINS_2 + STEPSIZE))
                    maxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))
                    ignore = ENTITYNUM_NONE
                    clipmask = MASK_NPCSOLID
                } else {
                    mins = ent!.r.mins
                    mins[2] += STEPSIZE
                    maxs = ent!.r.maxs
                    ignore = failedEdge!.entID
                    clipmask = JKAShared.MASK_SOLID//ent->clipmask; //rwwFIXMEFIXME: share clipmask?
                }

                if maxs[2] < mins[2] {//don't invert bounding box
                    maxs[2] = mins[2]
                }

                self.m_nodes[failedEdge!.startID]!.GetPosition(&start)
                self.m_nodes[failedEdge!.endID]!.GetPosition(&end)

                //See if it's NAV_ClearPath...

                //Test if they're even conceivably close to one another
                if !SV_inPVS(start, end) {
                    return false
                }

                // Raven's record lives to the end of his block, and no line after the trace reads it.
                // The closure gives the hit entity, or nil where Raven returns for a solid start.
                let traced = Trace.scratch { trace -> Int32? in
                    SV_Trace(trace, start, mins, maxs, end, ignore, clipmask | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP, 0, 0, 10)//NOTE: should we really always include monsterclip (physically blocks NPCs) and botclip (do not enter)?

                    if trace.startsolid == 1 || trace.allsolid == 1 {
                        return nil
                    }
                    return trace.entityNum
                }
                if traced == nil {
                    return false
                }
                hitEntNum = traced!

                //if we did hit something, see if it's just an auto-door and allow it
                if hitEntNum != ENTITYNUM_NONE && GNavCallback_G_EntIsUnlockedDoor(hitEntNum) {
                    hitEntNum = ENTITYNUM_NONE
                } else if hitEntNum == failedEdge!.entID {//don't hit the person who initially marked the edge failed
                    hitEntNum = ENTITYNUM_NONE
                }
                if hitEntNum == ENTITYNUM_NONE {
                    //If so, clear it
                    self.ClearFailedEdge(failedEdge)
                    return true
                } else {
                    //Check again in one second
                    failedEdge!.checkTime = svs.time + CHECK_FAILED_EDGE_INTERVAL + Q_irand(0, 1000)
                }
            }
        }
        return false
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2144
    func CheckAllFailedEdges() {
        var failedEdge: JKAMP.FailedEdge
        var clearedAny = false

        //Must have nodes
        if self.m_nodes.count == 0 {
            return
        }

        var j: Int32 = 0
        while j < MAX_FAILED_EDGES {
            failedEdge = self.failedEdges[j]

            clearedAny = self.CheckFailedEdge(failedEdge) ? true : clearedAny
            j += 1
        }
        if clearedAny {//need to recalc the paths
            if self.pathsCalculated {
                //reconnect the nodes and mark every node's flag NF_RECALC
                //Com_Printf( S_COLOR_CYAN"%d marking all nodes for recalc\n", svs.time );
                self.FlagAllNodes(NF_RECALC)
            }
        }
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2170
    func RouteBlocked(_ startID: Int32, _ testEdgeID: Int32, _ endID: Int32, _ rejectRank: Int32) -> Bool {
        var nextID: Int32
        var edgeID: Int32
        var lastID: Int32
        var bestNextID: Int32 = NODE_NONE
        var bestRank = rejectRank
        var testRank: Int32
        var allEdgesFailed: Bool
        let end: CNode?
        var next: CNode?

        if self.EdgeFailed(startID, testEdgeID) != -1 {
            return true
        }

        if testEdgeID == endID {//Neighbors, checked out, all clear
            return false
        }

        //Okay, first edge is clear, now check rest of route!
        end = self.m_nodes[endID]
        nextID = testEdgeID
        lastID = startID

        while true {
            next = self.m_nodes[nextID]
            allEdgesFailed = true

            var i: Int32 = 0
            while i < next!.GetNumEdges() {
                edgeID = next!.GetEdge(i)

                if edgeID == lastID {//Don't backtrack
                    i += 1
                    continue
                }

                if edgeID == startID {//Don't loop around
                    i += 1
                    continue
                }

                if self.EdgeFailed(nextID, edgeID) != -1 {
                    //This edge blocked, check next
                    i += 1
                    continue
                }

                if edgeID == endID {//We got there all clear!
                    return false
                }

                //Still going...
                testRank = end!.GetRank(edgeID)

                if testRank < 0 {//No route this way
                    i += 1
                    continue
                }

                //Is the rank good enough?
                if testRank < bestRank {
                    bestNextID = edgeID
                    bestRank = testRank
                    allEdgesFailed = false
                }
                i += 1
            }

            if allEdgesFailed {
                //This route has no clear way of getting to end
                return true
            } else {
                lastID = nextID
                nextID = bestNextID
            }
        }
    }

    /**
    ```
    -------------------------
    GetBestNodeAltRoute
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2261
    func GetBestNodeAltRoute(_ startID: Int32, _ endID: Int32, _ pathCost: inout Int32, _ rejectID: Int32 = NODE_NONE) -> Int32 {
        //Must have nodes
        if self.m_nodes.count == 0 {
            return WAYPOINT_NONE
        }

        //Validate the start position
        if (startID < 0) || (startID >= self.m_nodes.count) {
            return WAYPOINT_NONE
        }

        //Validate the end position
        if (endID < 0) || (endID >= self.m_nodes.count) {
            return WAYPOINT_NONE
        }

        //Is it the same node?
        if startID == endID {
            if d_altRoutes!.integer == 0 || self.EdgeFailed(startID, endID) == -1 {
                return startID
            } else {
                return WAYPOINT_NONE
            }
        }

        let start = self.m_nodes[startID]

        var bestNode: Int32 = -1
        var bestRank: Int32 = Q3_INFINITE
        var testRank: Int32
        var rejectRank: Int32 = Q3_INFINITE
        var bestCost: Int32 = Q3_INFINITE

        pathCost = 0

        //Find the minimum rank of the edge(s) we want to reject as paths
        if rejectID != WAYPOINT_NONE {
            var i: Int32 = 0
            while i < start!.GetNumEdges() {
                if start!.GetEdge(i) == rejectID {
                    // C converts the unsigned cost to `int` at the store.
                    rejectRank = Int32(bitPattern: self.GetPathCost(startID, endID))//end->GetRank( start->GetEdge(i) );
                    break
                }
                i += 1
            }
        }

        var i: Int32 = 0
        while i < start!.GetNumEdges() {
            let edgeID = start!.GetEdge(i)

            // C converts the unsigned cost to `int` at the store.
            testRank = Int32(bitPattern: self.GetPathCost(edgeID, endID))//end->GetRank( edgeID );

            //Make sure it's not worse than our reject rank
            if testRank >= rejectRank {
                i += 1
                continue
            }

            //Found one
            if edgeID == endID {
                if d_altRoutes!.integer == 0 || !self.RouteBlocked(startID, edgeID, endID, rejectRank) {
                    pathCost += start!.GetEdgeCost(i)
                    return edgeID
                } else {//this is blocked, can't consider it
                    i += 1
                    continue
                }
            }

            //No possible connection
            if testRank == NODE_NONE {
                pathCost = Q3_INFINITE
                return NODE_NONE
            }

            //Found a better one
            if testRank < bestRank {
                //FIXME: make sure all the edges down from startID through edgeID to endID
                //		does NOT include a failedEdge...
                if d_altRoutes!.integer == 0 || !self.RouteBlocked(startID, edgeID, endID, rejectRank) {
                    bestNode = edgeID
                    bestRank = testRank
                    bestCost = start!.GetEdgeCost(i) + testRank
                }
            }
            i += 1
        }

        pathCost = bestCost

        return bestNode
    }

    /**
    ```
    -------------------------
    GetBestNodeAltRoute
    overloaded so you don't have to pass a pathCost int pointer in
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2366
    func GetBestNodeAltRoute(_ startID: Int32, _ endID: Int32, _ rejectID: Int32 = NODE_NONE) -> Int32 {
        var junk: Int32 = 0
        return self.GetBestNodeAltRoute(startID, endID, &junk, rejectID)
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1320
    func GetBestPathBetweenEnts(_ ent: JKAMP.SharedEntity?, _ goal: JKAMP.SharedEntity?, _ flags: Int32) -> Int32 {
        //Must have nodes
        if self.m_nodes.count == 0 {
            return NODE_NONE
        }

        var nodeChain = nodeChain_l()
        var nodeChain2 = nodeChain_l()

        //Collect all nodes within a certain radius
        _ = self.CollectNearestNodes(ent!.r.currentOrigin, NODE_COLLECT_RADIUS, NODE_COLLECT_MAX, &nodeChain)
        _ = self.CollectNearestNodes(goal!.r.currentOrigin, NODE_COLLECT_RADIUS, NODE_COLLECT_MAX, &nodeChain2)

        var position = vec3_t()
        var position2 = vec3_t()
        var radius: Int32
        var cost: Int32
        var pathCost: Int32 = 0
        var bestCost: Int32 = Q3_INFINITE
        var node: CNode?
        var node2: CNode?
        var nodeNum: Int32
        var nodeNum2: Int32
        var nextNode: Int32 = NODE_NONE
        var bestNode: Int32 = NODE_NONE
        var nodeFlags: Int32 = 0
        //	bool				recalc = false;

        ent!.waypoint = NODE_NONE
        goal!.waypoint = NODE_NONE

        //Look through all nodes
        for nci in nodeChain {
            node = self.m_nodes[nci.nodeID]
            nodeNum = nci.nodeID

            node!.GetPosition(&position)

            if self.CheckedNode(nodeNum, ent!.s.number) == CHECKED_FAILED {//already checked this node against ent and it failed
                continue
            }
            if self.CheckedNode(nodeNum, ent!.s.number) == CHECKED_PASSED {//already checked this node against ent and it passed
            } else {//haven't checked this node against ent yet
                if self.NodeFailed(ent, nodeNum) {
                    self.SetCheckedNode(nodeNum, ent!.s.number, CHECKED_FAILED)
                    continue
                }
                //okay, since we only have to do this once, let's check to see if this node is even usable (could help us short-circuit a whole loop of the dest nodes)
                radius = node!.GetRadius()

                //If we're not within the known clear radius of this node OR out of Z height range...
                // C converts the `int` square to `unsigned` for the compare.
                if nci.distance >= UInt32(bitPattern: radius * radius) || (abs(position[2] - ent!.r.currentOrigin[2]) >= MAX_Z_DELTA) {
                    //We're not *within* this node, so check clear path, etc.

                    //FIXME: any way to call G_FindClosestPointOnLineSegment and see if I can at least get to the waypoint's path
                    if (flags & NF_CLEAR_PATH) != 0 {//|| flags & NF_CLEAR_LOS )
                        //need a clear path or LOS
                        if !SV_inPVS(ent!.r.currentOrigin, position) {//not even potentially clear
                            self.SetCheckedNode(nodeNum, ent!.s.number, CHECKED_FAILED)
                            continue
                        }
                    }

                    //Do we need a clear path?
                    if (flags & NF_CLEAR_PATH) != 0 {
                        if self.TestNodePath(ent, goal!.s.number, position, true) == 0 {
                            self.SetCheckedNode(nodeNum, ent!.s.number, CHECKED_FAILED)
                            continue
                        }
                    }
                }//otherwise, inside the node so it must be clear (?)
                self.SetCheckedNode(nodeNum, ent!.s.number, CHECKED_PASSED)
            }

            if d_altRoutes!.integer != 0 {
                //calc the paths for this node if they're out of date
                nodeFlags = node!.GetFlags()
                if (nodeFlags & NF_RECALC) != 0 {
                    //Com_Printf( S_COLOR_CYAN"%d recalcing paths from node %d\n", svs.time, nodeNum );
                    self.CalculatePath(node)
                }
            }

            for nci2 in nodeChain2 {
                node2 = self.m_nodes[nci2.nodeID]
                nodeNum2 = nci2.nodeID
                if d_altRoutes!.integer != 0 {
                    //calc the paths for this node if they're out of date
                    nodeFlags = node2!.GetFlags()
                    if (nodeFlags & NF_RECALC) != 0 {
                        //Com_Printf( S_COLOR_CYAN"%d recalcing paths from node %d\n", svs.time, nodeNum2 );
                        self.CalculatePath(node2)
                    }
                }

                node2!.GetPosition(&position2)
                //Okay, first get the entire path cost, including distance to first node from ents' positions
                cost = Int32(floor(Distance(ent!.r.currentOrigin, position) + Distance(goal!.r.currentOrigin, position2)))

                if d_altRoutes!.integer != 0 {
                    nextNode = self.GetBestNodeAltRoute(nci.nodeID, nci2.nodeID, &pathCost, bestNode)
                    cost += pathCost
                } else {
                    // C converts the unsigned cost to `int` at the add.
                    cost += Int32(bitPattern: self.GetPathCost(nci.nodeID, nci2.nodeID))
                }

                if cost >= bestCost {
                    continue
                }

                //okay, this is the shortest path we've found yet, check clear path, etc.
                if self.CheckedNode(nodeNum2, goal!.s.number) == CHECKED_FAILED {//already checked this node against goal and it failed
                    continue
                }
                if self.CheckedNode(nodeNum2, goal!.s.number) == CHECKED_PASSED {//already checked this node against goal and it passed
                } else {//haven't checked this node against goal yet
                    if self.NodeFailed(goal, nodeNum2) {
                        self.SetCheckedNode(nodeNum2, goal!.s.number, CHECKED_FAILED)
                        continue
                    }
                    radius = node2!.GetRadius()

                    //If we're not within the known clear radius of this node OR out of Z height range...
                    // C converts the `int` square to `unsigned` for the compare.
                    if nci2.distance >= UInt32(bitPattern: radius * radius) || (abs(position2[2] - goal!.r.currentOrigin[2]) >= MAX_Z_DELTA) {
                        //We're not *within* this node, so check clear path, etc.

                        if (flags & NF_CLEAR_PATH) != 0 {//|| flags & NF_CLEAR_LOS )
                            //need a clear path or LOS
                            if !SV_inPVS(goal!.r.currentOrigin, position2) {//not even potentially clear
                                self.SetCheckedNode(nodeNum2, goal!.s.number, CHECKED_FAILED)
                                continue
                            }
                        }
                        //Do we need a clear path?
                        if (flags & NF_CLEAR_PATH) != 0 {
                            if self.TestNodePath(goal, ent!.s.number, position2, false) == 0 {//qtrue?
                                self.SetCheckedNode(nodeNum2, goal!.s.number, CHECKED_FAILED)
                                continue
                            }
                        }
                    }//otherwise, inside the node so it must be clear (?)
                    self.SetCheckedNode(nodeNum2, goal!.s.number, CHECKED_PASSED)
                }

                bestCost = cost
                bestNode = nextNode
                ent!.waypoint = nci.nodeID
                goal!.waypoint = nci2.nodeID
            }
        }

        if d_altRoutes!.integer == 0 {//bestNode would not have been set by GetBestNodeAltRoute above, so get it here
            if ent!.waypoint != NODE_NONE && goal!.waypoint != NODE_NONE {//have 2 valid waypoints which means a valid path
                bestNode = self.GetBestNodeAltRoute(ent!.waypoint, goal!.waypoint, &bestCost, NODE_NONE)
            }
        }
        return bestNode
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1029
    func GetNodeRadius(_ nodeID: Int32) -> Int32 {
        if self.m_nodes.count == 0 {
            return 0
        }
        return self.m_nodes[nodeID]!.GetRadius()
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1036
    func CheckBlockedEdges() {
        var start: CNode?
        var end: CNode?
        var p1 = vec3_t()
        var p2 = vec3_t()
        var flags: Int32
        var first: Int32
        var second: Int32
        var failed: Bool
        var edgeNum: Int32

        //Go through all edges and test the ones that were blocked
        for ni in self.m_nodes {
            //Attempt to draw each connection
            edgeNum = 0
            while edgeNum < ni!.GetNumEdges() {
                flags = Int32(ni!.GetEdgeFlags(edgeNum))
                if (flags & EFLAG_BLOCKED) != 0 {
                    first = ni!.GetID()
                    second = ni!.GetEdge(edgeNum)
                    start = self.m_nodes[first]
                    end = self.m_nodes[second]
                    failed = false

                    start!.GetPosition(&p1)
                    end!.GetPosition(&p2)

                    // Raven's record lives to the end of his function, and only this block reads it, so the block is the closure.
                    Trace.scratch { trace in
                        //FIXME: can't we just store the trace.entityNum from the HardConnect trace?  So we don't have to do another trace here...
                        SV_Trace(trace, p1, wpMins, wpMaxs, p2, ENTITYNUM_NONE, JKAShared.MASK_SOLID | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP, 0, 0, 10)

                        if trace.entityNum < ENTITYNUM_WORLD && (trace.fraction < 1.0 || trace.startsolid == 1 || trace.allsolid == 1) {//could be assumed, since failed before
                            if GNavCallback_G_EntIsDoor(trace.entityNum) {//door
                                if !GNavCallback_G_EntIsUnlockedDoor(trace.entityNum) {//locked door
                                    failed = true
                                }
                            } else {
                                if GNavCallback_G_EntIsBreakable(trace.entityNum) {//do same for breakable brushes/models/glass?
                                    failed = true
                                } else if GNavCallback_G_EntIsRemovableUsable(trace.entityNum) {
                                    failed = true
                                } else if trace.allsolid != 0 || trace.startsolid != 0 {//FIXME: the entitynum would be none here, so how do we know if this is stuck inside an ent or the world?
                                } else {//FIXME: what about func_plats and scripted movers?
                                }
                            }
                        }
                    }

                    if failed {
                        //could add the EFLAG_FAILED to the two edges, but we stopped doing that since it was pointless
                        self.AddFailedEdge(ENTITYNUM_NONE, first, second)
                    }
                }
                edgeNum += 1
            }
        }
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1688
    func ClearCheckedNodes() {
        CheckedNodes.removeAll()
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1693
    func CheckedNode(_ wayPoint: Int32, _ ent: Int32) -> JKAShared.byte {
        //assert(wayPoint>=0&&wayPoint<MAX_STORED_WAYPOINTS);
        if wayPoint < 0 || wayPoint >= MAX_STORED_WAYPOINTS {
            return CHECKED_NO
        }
        assert(ent >= 0 && ent < MAX_GENTITIES)
        if let f = CheckedNodes[wayPoint * MAX_GENTITIES + ent] {
            return f
        }
        return CHECKED_NO
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1709
    func SetCheckedNode(_ wayPoint: Int32, _ ent: Int32, _ value: JKAShared.byte) {
        //assert(wayPoint>=0&&wayPoint<MAX_STORED_WAYPOINTS);
        if wayPoint < 0 || wayPoint >= MAX_STORED_WAYPOINTS {
            return
        }
        assert(ent >= 0 && ent < MAX_GENTITIES)
        assert(value == CHECKED_FAILED || value == CHECKED_PASSED)
        CheckedNodes[wayPoint * MAX_GENTITIES + ent] = value
    }

    /**
    ```
    -------------------------
    FlagAllNodes
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:496
    func FlagAllNodes(_ newFlag: Int32) {
        for ni in self.m_nodes {
            ni!.AddFlag(newFlag)
        }
    }

    /**
    ```
    -------------------------
    TestNodePath
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1150
    private func TestNodePath(_ ent: JKAMP.SharedEntity?, _ okToHitEntNum: Int32, _ position: JKAShared.vec3_t, _ includeEnts: Bool) -> Int32 {
        //rwwFIXMEFIXME: Share clipmask?
        var clipmask: Int32 = JKAShared.MASK_SOLID//ent->clipmask;

        if !includeEnts {
            clipmask &= ~CONTENTS_BODY
        }
        //Check the path
        if GNavCallback_NAV_ClearPathToPoint(ent!, ent!.r.mins, ent!.r.maxs, position, clipmask, okToHitEntNum) == false {
            return 0
        }

        return 1
    }

    /**
    ```
    -------------------------
    TestNodeLOS
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1171
    private func TestNodeLOS(_ ent: JKAMP.SharedEntity?, _ position: JKAShared.vec3_t) -> Int32 {
        return GNavCallback_NPC_ClearLOS(ent!, position) ? 1 : 0
    }

    /**
    ```
    -------------------------
    TestBestFirst
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1182
    private func TestBestFirst(_ ent: JKAMP.SharedEntity?, _ lastID: Int32, _ flags: Int32) -> Int32 {
        //Must be a valid one to begin with
        if lastID == NODE_NONE {
            return NODE_NONE
        }

        // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
        if lastID < 0 || lastID >= self.m_nodes.count {
            return NODE_NONE
        }

        //Get the info
        var nodePos = vec3_t()
        let node = self.m_nodes[lastID]
        var testNode: CNode?
        let numEdges = node!.GetNumEdges()
        var dist: Float

        node!.GetPosition(&nodePos)

        //Setup our last node as our root, and search for a closer one according to its edges
        var bestNode: Int32 = (self.TestNodePath(ent, ENTITYNUM_NONE, nodePos, true) != 0) ? lastID : NODE_NONE
        var bestDist: Float = (bestNode == NODE_NONE) ? Float(Q3_INFINITE) : DistanceSquared(ent!.r.currentOrigin, nodePos)

        //Test all these edges first
        var i: Int32 = 0
        while i < numEdges {
            //Get this node and its distance
            testNode = self.m_nodes[node!.GetEdge(i)]

            if self.NodeFailed(ent, testNode!.GetID()) {
                i += 1
                continue
            }

            testNode!.GetPosition(&nodePos)

            dist = DistanceSquared(ent!.r.currentOrigin, nodePos)

            //Test against current best
            if dist < bestDist {
                //See if this node is valid
                if self.CheckedNode(testNode!.GetID(), ent!.s.number) == CHECKED_PASSED || self.TestNodePath(ent, ENTITYNUM_NONE, nodePos, true) != 0 {
                    bestDist = dist
                    bestNode = testNode!.GetID()
                    self.SetCheckedNode(testNode!.GetID(), ent!.s.number, CHECKED_PASSED)
                } else {
                    self.SetCheckedNode(testNode!.GetID(), ent!.s.number, CHECKED_FAILED)
                }
            }
            i += 1
        }

        return bestNode
    }

    /**
    ```
    -------------------------
    CollectNearestNodes
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1249
    private func CollectNearestNodes(_ origin: JKAShared.vec3_t, _ radius: Int32, _ maxCollect: Int32, _ nodeChain: inout nodeChain_l) -> Int32 {
        var dist: Float
        var position = vec3_t()
        var collected: Int32 = 0
        var added = false

        //Get a distance rating for each node in the system
        for ni in self.m_nodes {
            //If we've got our quota, then stop looking
            //Get the distance to the node
            ni!.GetPosition(&position)
            dist = DistanceSquared(position, origin)

            //Must be within our radius range
            if dist > Float(radius * radius) {
                continue
            }

            var nChain = nodeList_t()

            //Always add the first node
            if nodeChain.count == 0 {
                nChain.nodeID = ni!.GetID()
                nChain.distance = UInt32(dist)

                nodeChain.insert(nChain, at: nodeChain.startIndex)
                continue
            }

            added = false

            //Compare it to what we already have
            for nci in nodeChain.indices {
                //If we're less, than this entry, then insert before it
                if dist < Float(nodeChain[nci].distance) {
                    nChain.nodeID = ni!.GetID()
                    nChain.distance = UInt32(dist)

                    nodeChain.insert(nChain, at: nci)
                    collected = Int32(nodeChain.count)
                    added = true

                    //If we've hit our collection limit, throw off the oldest one
                    if nodeChain.count > maxCollect {
                        nodeChain.removeLast()
                    }

                    break
                }
            }

            //Otherwise, always pad out the collection if possible so we don't miss anything
            if (added == false) && (nodeChain.count < maxCollect) {
                nChain.nodeID = ni!.GetID()
                nChain.distance = UInt32(dist)

                nodeChain.append(nChain)
            }
        }

        return collected
    }

    /**
    ```
    -------------------------
    GetChar
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:512
    private func GetChar(_ file: JKAShared.fileHandle_t) -> CChar {
        // AI: Raven reads into a `char` local through its address. The local is a CharBuf of the one byte, and the read gives the `char` of it.
        var value = CharBuf(CChar.byteCount)

        _ = FS_Read(&value, Int32(CChar.byteCount), file)

        return value[0]
    }

    /**
    ```
    -------------------------
    GetInt
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:527
    private func GetInt(_ file: JKAShared.fileHandle_t) -> Int32 {
        // AI: Raven reads into an `int` local through its address. The local is a CharBuf of the four bytes, and the read gives the `int` of them.
        var value = CharBuf(Int32.byteCount)

        _ = FS_Read(&value, Int32(Int32.byteCount), file)

        return value.withSlots { $0[int: 0] }
    }

    /**
    ```
    -------------------------
    GetFloat
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:542
    private func GetFloat(_ file: JKAShared.fileHandle_t) -> Float {
        // AI: Raven reads into a `float` local through its address. The local is a CharBuf of the four bytes, and the read gives the `float` of them.
        var value = CharBuf(Float.byteCount)

        _ = FS_Read(&value, Int32(Float.byteCount), file)

        return value.withSlots { $0[float: 0] }
    }

    /**
    ```
    -------------------------
    GetLong
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:557
    private func GetLong(_ file: JKAShared.fileHandle_t) -> Int32 {
        // AI: Raven reads a `long` local through its address, 4 bytes on WinDed. The local is a CharBuf of the four bytes, and the read gives the `long` of them.
        var value = CharBuf(Int32.byteCount)

        _ = FS_Read(&value, Int32(Int32.byteCount), file)

        return value.withSlots { $0[int: 0] }
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:757
    private func SetEdgeCost(_ ID1: Int32, _ ID2: Int32, _ cost: Int32) {
        if (ID1 == -1) || (ID2 == -1) {//not valid nodes, must have come from the ClearAllFailedEdges initization-type calls
            return
        }

        let node1 = self.m_nodes[ID1]
        let node2 = self.m_nodes[ID2]

        // Raven writes his own `cost` parameter, so the body takes a copy of it.
        var cost = cost

        if cost == -1 {//they want us to calc it
            //FIXME: can we just remember this instead of recalcing every time?
            var pos1 = vec3_t()
            var pos2 = vec3_t()

            node1!.GetPosition(&pos1)
            node2!.GetPosition(&pos2)
            cost = Int32(Distance(pos1, pos2))
        }

        //set it
        node1!.AddEdge(ID2, cost)
        node2!.AddEdge(ID1, cost)
    }

    /**
    ```
    -------------------------
    GetEdgeCost
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:734
    private func GetEdgeCost(_ first: CNode?, _ second: CNode?) -> Int32 {
        var start = vec3_t()
        var end = vec3_t()
        var mins = vec3_t()
        var maxs = vec3_t()

        //Setup the player size
        mins = vec3_t(-8, -8, -8)
        maxs = vec3_t(8, 8, 8)

        //Setup the points
        first!.GetPosition(&start)
        second!.GetPosition(&end)

        // Raven's record lives to the end of his function, so the rest of the function is the closure.
        return Trace.scratch { trace -> Int32 in
            SV_Trace(trace, start, mins, maxs, end, ENTITYNUM_NONE, JKAShared.MASK_SOLID, 0, 0, 10)

            if trace.fraction < 1.0 || trace.allsolid != 0 || trace.startsolid != 0 {
                return Q3_INFINITE // return -1;
            }

            //Connection successful, return the cost
            return Int32(Distance(start, end))
        }
    }

    /**
    ```
    -------------------------
    AddNodeEdges
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:788
    // AI: Raven passes a `bool *` array that CalculatePath allocates with `new bool[]`. The parameter is an inout Array.
    private func AddNodeEdges(_ node: CNode?, _ addDist: Int32, _ edgeList: inout edge_l, _ checkedNodes: inout [Bool]) {
        //Add all edge
        var i: Int32 = 0
        while i < node!.GetNumEdges() {
            //Make sure we don't add an old edge twice
            if checkedNodes[node!.GetEdge(i)] == true {
                i += 1
                continue
            }

            //Get the node
            let nextNode = self.m_nodes[node!.GetEdge(i)]

            //This node has now been checked
            checkedNodes[nextNode!.GetID()] = true

            //Add it to the list
            edgeList.append(CEdge(nextNode!.GetID(), node!.GetID(), addDist + (node!.GetEdgeCost(i))))
            i += 1
        }
    }

    /**
    ```
    -------------------------
    CalculatePath
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:814
    private func CalculatePath(_ node: CNode?) {
        var curRank: Int32 = 0

        let pathList = CPriorityQueue()
        var checked: [JKAShared.byte]

        //Init the completion table
        // Raven's memset clears the table, and a new Array starts at zero.
        checked = Array(repeating: 0, count: self.m_nodes.count)

        //Mark this node as checked
        checked[node!.GetID()] = 1
        node!.AddRank(node!.GetID(), curRank)
        curRank += 1

        //Add all initial nodes
        var i: Int32 = 0
        while i < node!.GetNumEdges() {
            let nextNode = self.m_nodes[node!.GetEdge(i)]

            checked[nextNode!.GetID()] = 1

            pathList.Push(CEdge(nextNode!.GetID(), nextNode!.GetID(), node!.GetEdgeCost(i)))
            i += 1
        }

        var minDist: Float
        var test: CEdge?

        //Now flood fill all the others
        while !pathList.Empty() {
            minDist = Float(Q3_INFINITE)
            test = pathList.Pop()

            let testNode = self.m_nodes[test!.m_first]

            node!.AddRank(testNode!.GetID(), curRank)
            curRank += 1

            //Add in all the new edges
            i = 0
            while i < testNode!.GetNumEdges() {
                let addNode = self.m_nodes[testNode!.GetEdge(i)]

                if checked[addNode!.GetID()] != 0 {
                    i += 1
                    continue
                }

                let newDist = test!.m_cost + testNode!.GetEdgeCost(i)
                pathList.Push(CEdge(addNode!.GetID(), test!.m_second, newDist))

                checked[addNode!.GetID()] = 1
                i += 1
            }
            // AI: Raven deletes each popped edge, then the queue and the table. Dropping the references frees them.
        }

        node!.RemoveFlag(NF_RECALC)
    }
}
