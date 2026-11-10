import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/NPCNav/navigator.h:40
// AI: Raven declares a `multimap<int, int>`. The type is a Dictionary of arrays, one array of values for each key.
typealias EdgeMultimap = [Int32: [Int32]]

// AI: Raven declares `EdgeMultimapIt`, the iterator of the multimap at navigator.h:41. A Dictionary of arrays has no such iterator, so the type drops.

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
    // AI: Raven holds MAX_FAILED_EDGES `failedEdge_t` records in the class, and MAX_FAILED_EDGES of navigator.h is 32, which no module of the host declares.
    // The instance owns one allocation of the 32 records, zeroed as C zeroes the global `navigator`, and the deinit frees it.
    private let failedEdges: Slots<JKAMP.FailedEdge> = {
        let failedEdges = Slots<JKAMP.FailedEdge>.new(count: 32)
        failedEdges.zero(count: 32)
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
        // TODO: Port CNavigator::CNavigator
        portMissing("CNavigator::CNavigator", source: "oracle/codemp/server/NPCNav/navigator.cpp:478")
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
        // TODO: Port CNavigator::Init
        portMissing("CNavigator::Init", source: "oracle/codemp/server/NPCNav/navigator.cpp:572")
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
        // TODO: Port CNavigator::Free
        portMissing("CNavigator::Free", source: "oracle/codemp/server/NPCNav/navigator.cpp:583")
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
        // TODO: Port CNavigator::Load
        portMissing("CNavigator::Load", source: "oracle/codemp/server/NPCNav/navigator.cpp:602")
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
        // TODO: Port CNavigator::Save
        portMissing("CNavigator::Save", source: "oracle/codemp/server/NPCNav/navigator.cpp:665")
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
        // TODO: Port CNavigator::AddRawPoint
        portMissing("CNavigator::AddRawPoint", source: "oracle/codemp/server/NPCNav/navigator.cpp:710")
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
        // TODO: Port CNavigator::CalculatePaths
        portMissing("CNavigator::CalculatePaths", source: "oracle/codemp/server/NPCNav/navigator.cpp:884")
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
        // TODO: Port CNavigator::HardConnect
        portMissing("CNavigator::HardConnect", source: "oracle/codemp/server/NPCNav/navigator.cpp:1113")
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
        // TODO: Port CNavigator::ShowNodes
        portMissing("CNavigator::ShowNodes", source: "oracle/codemp/server/NPCNav/navigator.cpp:916")
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
        // TODO: Port CNavigator::ShowEdges
        portMissing("CNavigator::ShowEdges", source: "oracle/codemp/server/NPCNav/navigator.cpp:963")
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
        // TODO: Port CNavigator::ShowPath
        portMissing("CNavigator::ShowPath", source: "oracle/codemp/server/NPCNav/navigator.cpp:1632")
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
        // TODO: Port CNavigator::GetNearestNode
        portMissing("CNavigator::GetNearestNode", source: "oracle/codemp/server/NPCNav/navigator.cpp:1514")
    }

    /**
    ```
    -------------------------
    GetBestNode
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2377
    // AI: Raven defaults rejectID to NODE_NONE of navigator.h, which no module of the host declares. The default is its value, -1.
    func GetBestNode(_ startID: Int32, _ endID: Int32, _ rejectID: Int32 = -1) -> Int32 {
        // TODO: Port CNavigator::GetBestNode
        portMissing("CNavigator::GetBestNode", source: "oracle/codemp/server/NPCNav/navigator.cpp:2377")
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
        // TODO: Port CNavigator::GetNodePosition
        portMissing("CNavigator::GetNodePosition", source: "oracle/codemp/server/NPCNav/navigator.cpp:2444")
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
        // TODO: Port CNavigator::GetNodeNumEdges
        portMissing("CNavigator::GetNodeNumEdges", source: "oracle/codemp/server/NPCNav/navigator.cpp:2463")
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
        // TODO: Port CNavigator::GetNodeEdge
        portMissing("CNavigator::GetNodeEdge", source: "oracle/codemp/server/NPCNav/navigator.cpp:2481")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:182
    // Raven declares this method in navigator.h and defines no body for it.
    func GetNodeLeadDistance(_ nodeID: Int32) -> Float {
        // TODO: Port CNavigator::GetNodeLeadDistance
        portMissing("CNavigator::GetNodeLeadDistance", source: "oracle/codemp/server/NPCNav/navigator.h:182")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.h:184
    func GetNumNodes() -> Int32 {
        // TODO: Port CNavigator::GetNumNodes
        portMissing("CNavigator::GetNumNodes", source: "oracle/codemp/server/NPCNav/navigator.h:184")
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
        // TODO: Port CNavigator::Connected
        portMissing("CNavigator::Connected", source: "oracle/codemp/server/NPCNav/navigator.cpp:2499")
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
        // TODO: Port CNavigator::GetPathCost
        portMissing("CNavigator::GetPathCost", source: "oracle/codemp/server/NPCNav/navigator.cpp:2536")
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
        // TODO: Port CNavigator::GetEdgeCost
        portMissing("CNavigator::GetEdgeCost", source: "oracle/codemp/server/NPCNav/navigator.cpp:2621")
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
        // TODO: Port CNavigator::GetProjectedNode
        portMissing("CNavigator::GetProjectedNode", source: "oracle/codemp/server/NPCNav/navigator.cpp:2643")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1724
    func CheckFailedNodes(_ ent: JKAMP.SharedEntity?) {
        // TODO: Port CNavigator::CheckFailedNodes
        portMissing("CNavigator::CheckFailedNodes", source: "oracle/codemp/server/NPCNav/navigator.cpp:1724")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1768
    func AddFailedNode(_ ent: JKAMP.SharedEntity?, _ nodeID: Int32) {
        // TODO: Port CNavigator::AddFailedNode
        portMissing("CNavigator::AddFailedNode", source: "oracle/codemp/server/NPCNav/navigator.cpp:1768")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1801
    func NodeFailed(_ ent: JKAMP.SharedEntity?, _ nodeID: Int32) -> Bool {
        // TODO: Port CNavigator::NodeFailed
        portMissing("CNavigator::NodeFailed", source: "oracle/codemp/server/NPCNav/navigator.cpp:1801")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1813
    func NodesAreNeighbors(_ startID: Int32, _ endID: Int32) -> Bool {
        // TODO: Port CNavigator::NodesAreNeighbors
        portMissing("CNavigator::NodesAreNeighbors", source: "oracle/codemp/server/NPCNav/navigator.cpp:1813")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1835
    func ClearFailedEdge(_ failedEdge: JKAMP.FailedEdge?) {
        // TODO: Port CNavigator::ClearFailedEdge
        portMissing("CNavigator::ClearFailedEdge", source: "oracle/codemp/server/NPCNav/navigator.cpp:1835")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1867
    func ClearAllFailedEdges() {
        // TODO: Port CNavigator::ClearAllFailedEdges
        portMissing("CNavigator::ClearAllFailedEdges", source: "oracle/codemp/server/NPCNav/navigator.cpp:1867")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1876
    func EdgeFailed(_ startID: Int32, _ endID: Int32) -> Int32 {
        // TODO: Port CNavigator::EdgeFailed
        portMissing("CNavigator::EdgeFailed", source: "oracle/codemp/server/NPCNav/navigator.cpp:1876")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1925
    func AddFailedEdge(_ entID: Int32, _ startID: Int32, _ endID: Int32) {
        // TODO: Port CNavigator::AddFailedEdge
        portMissing("CNavigator::AddFailedEdge", source: "oracle/codemp/server/NPCNav/navigator.cpp:1925")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2057
    func CheckFailedEdge(_ failedEdge: JKAMP.FailedEdge?) -> Bool {
        // TODO: Port CNavigator::CheckFailedEdge
        portMissing("CNavigator::CheckFailedEdge", source: "oracle/codemp/server/NPCNav/navigator.cpp:2057")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2144
    func CheckAllFailedEdges() {
        // TODO: Port CNavigator::CheckAllFailedEdges
        portMissing("CNavigator::CheckAllFailedEdges", source: "oracle/codemp/server/NPCNav/navigator.cpp:2144")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2170
    func RouteBlocked(_ startID: Int32, _ testEdgeID: Int32, _ endID: Int32, _ rejectRank: Int32) -> Bool {
        // TODO: Port CNavigator::RouteBlocked
        portMissing("CNavigator::RouteBlocked", source: "oracle/codemp/server/NPCNav/navigator.cpp:2170")
    }

    /**
    ```
    -------------------------
    GetBestNodeAltRoute
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:2261
    // AI: Raven defaults rejectID to NODE_NONE of navigator.h, which no module of the host declares. The default is its value, -1.
    func GetBestNodeAltRoute(_ startID: Int32, _ endID: Int32, _ pathCost: inout Int32, _ rejectID: Int32 = -1) -> Int32 {
        // TODO: Port CNavigator::GetBestNodeAltRoute
        portMissing("CNavigator::GetBestNodeAltRoute", source: "oracle/codemp/server/NPCNav/navigator.cpp:2261")
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
    // AI: Raven defaults rejectID to NODE_NONE of navigator.h, which no module of the host declares. The default is its value, -1.
    func GetBestNodeAltRoute(_ startID: Int32, _ endID: Int32, _ rejectID: Int32 = -1) -> Int32 {
        // TODO: Port CNavigator::GetBestNodeAltRoute
        portMissing("CNavigator::GetBestNodeAltRoute", source: "oracle/codemp/server/NPCNav/navigator.cpp:2366")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1320
    func GetBestPathBetweenEnts(_ ent: JKAMP.SharedEntity?, _ goal: JKAMP.SharedEntity?, _ flags: Int32) -> Int32 {
        // TODO: Port CNavigator::GetBestPathBetweenEnts
        portMissing("CNavigator::GetBestPathBetweenEnts", source: "oracle/codemp/server/NPCNav/navigator.cpp:1320")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1029
    func GetNodeRadius(_ nodeID: Int32) -> Int32 {
        // TODO: Port CNavigator::GetNodeRadius
        portMissing("CNavigator::GetNodeRadius", source: "oracle/codemp/server/NPCNav/navigator.cpp:1029")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1036
    func CheckBlockedEdges() {
        // TODO: Port CNavigator::CheckBlockedEdges
        portMissing("CNavigator::CheckBlockedEdges", source: "oracle/codemp/server/NPCNav/navigator.cpp:1036")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1688
    func ClearCheckedNodes() {
        // TODO: Port CNavigator::ClearCheckedNodes
        portMissing("CNavigator::ClearCheckedNodes", source: "oracle/codemp/server/NPCNav/navigator.cpp:1688")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1693
    func CheckedNode(_ wayPoint: Int32, _ ent: Int32) -> JKAShared.byte {
        // TODO: Port CNavigator::CheckedNode
        portMissing("CNavigator::CheckedNode", source: "oracle/codemp/server/NPCNav/navigator.cpp:1693")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:1709
    func SetCheckedNode(_ wayPoint: Int32, _ ent: Int32, _ value: JKAShared.byte) {
        // TODO: Port CNavigator::SetCheckedNode
        portMissing("CNavigator::SetCheckedNode", source: "oracle/codemp/server/NPCNav/navigator.cpp:1709")
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
        // TODO: Port CNavigator::FlagAllNodes
        portMissing("CNavigator::FlagAllNodes", source: "oracle/codemp/server/NPCNav/navigator.cpp:496")
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
        // TODO: Port CNavigator::TestNodePath
        portMissing("CNavigator::TestNodePath", source: "oracle/codemp/server/NPCNav/navigator.cpp:1150")
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
        // TODO: Port CNavigator::TestNodeLOS
        portMissing("CNavigator::TestNodeLOS", source: "oracle/codemp/server/NPCNav/navigator.cpp:1171")
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
        // TODO: Port CNavigator::TestBestFirst
        portMissing("CNavigator::TestBestFirst", source: "oracle/codemp/server/NPCNav/navigator.cpp:1182")
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
        // TODO: Port CNavigator::CollectNearestNodes
        portMissing("CNavigator::CollectNearestNodes", source: "oracle/codemp/server/NPCNav/navigator.cpp:1249")
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
        // TODO: Port CNavigator::GetChar
        portMissing("CNavigator::GetChar", source: "oracle/codemp/server/NPCNav/navigator.cpp:512")
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
        // TODO: Port CNavigator::GetInt
        portMissing("CNavigator::GetInt", source: "oracle/codemp/server/NPCNav/navigator.cpp:527")
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
        // TODO: Port CNavigator::GetFloat
        portMissing("CNavigator::GetFloat", source: "oracle/codemp/server/NPCNav/navigator.cpp:542")
    }

    /**
    ```
    -------------------------
    GetLong
    -------------------------
    ```
    */
    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:557
    private func GetLong(_ file: JKAShared.fileHandle_t) -> CLong {
        // TODO: Port CNavigator::GetLong
        portMissing("CNavigator::GetLong", source: "oracle/codemp/server/NPCNav/navigator.cpp:557")
    }

    /// Source: oracle/codemp/server/NPCNav/navigator.cpp:757
    private func SetEdgeCost(_ ID1: Int32, _ ID2: Int32, _ cost: Int32) {
        // TODO: Port CNavigator::SetEdgeCost
        portMissing("CNavigator::SetEdgeCost", source: "oracle/codemp/server/NPCNav/navigator.cpp:757")
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
        // TODO: Port CNavigator::GetEdgeCost
        portMissing("CNavigator::GetEdgeCost", source: "oracle/codemp/server/NPCNav/navigator.cpp:734")
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
        // TODO: Port CNavigator::AddNodeEdges
        portMissing("CNavigator::AddNodeEdges", source: "oracle/codemp/server/NPCNav/navigator.cpp:788")
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
        // TODO: Port CNavigator::CalculatePath
        portMissing("CNavigator::CalculatePath", source: "oracle/codemp/server/NPCNav/navigator.cpp:814")
    }
}
