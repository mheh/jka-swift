import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// maximum random choices
/// Source: oracle/codemp/RMG/RM_Mission.h:10
let MAX_RANDOM_CHOICES = 100 as Int32

/// Source: oracle/codemp/qcommon/cm_terrainmap.h:63
let SIDE_NONE = 0 as Int32

/// Source: oracle/codemp/qcommon/cm_terrainmap.h:64
let SIDE_BLUE = 1 as Int32

/// Source: oracle/codemp/qcommon/cm_terrainmap.h:65
let SIDE_RED = 2 as Int32

/// Raven's random mission, its objectives, its instances, and the pickup odds of a random map.
/// CRMManager.LoadMission makes one only when the landscape holds a random terrain, and the dedicated build never makes that terrain.
/// Source: oracle/codemp/RMG/RM_Mission.h:15
final class CRMMission {
    // AI: Raven declares a `list<CRMObjective *>`. The field is an Array of the optional class, rule 17.
    private var mObjectives: [CRMObjective?] = []
    // TODO: Port mInstances
    // Raven wrote: rmInstanceList_t		mInstances;

    // TODO: Port mInstanceFile
    // Raven wrote: CRMInstanceFile			mInstanceFile;
    private var mCurrentObjective: CRMObjective? = nil

    private var mValidNodes: Bool = false
    private var mValidPaths: Bool = false
    private var mValidRivers: Bool = false
    private var mValidWeapons: Bool = false
    private var mValidAmmo: Bool = false
    private var mValidObjectives: Bool = false
    private var mValidInstances: Bool = false

    private var mTimeLimit: Int32 = 0
    private var mMaxInstancePosition: Int32 = 0

    // npc multipliers
    private var mAccuracyMultiplier: Float = 0
    private var mHealthMultiplier: Float = 0

    // % chance that RMG pickup is actually spawned
    private var mPickupHealth: Float = 0
    private var mPickupArmor: Float = 0
    private var mPickupAmmo: Float = 0
    private var mPickupWeapon: Float = 0
    private var mPickupEquipment: Float = 0

    // AI: Raven declares each text a `std::string`. Each field is a String, rule 17.
    private var mDescription: String = ""
    private var mExitScreen: String = ""
    private var mTimeExpiredScreen: String = ""

    // symmetric landscape style
    private var mSymmetric: symmetry_t = 0

    // if set to 1 in the mission file, adds an extra connecting path in symmetric maps
    // to ensure both sides actually do connect
    private var mBackUpPath: Int32 = 0

    private var mDefaultPadding: Int32 = 0

    private var mAreaManager: CRMAreaManager? = nil

    private var mPathManager: CRMPathManager? = nil

    private var mLandScape: CRandomTerrain? = nil

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:28
    init(_ landscape: CRandomTerrain?) {
        self.mCurrentObjective = nil
        self.mValidPaths = false
        self.mValidRivers = false
        self.mValidNodes = false
        self.mValidWeapons = false
        self.mValidAmmo = false
        self.mValidObjectives = false
        self.mValidInstances = false
        self.mTimeLimit = 0
        self.mMaxInstancePosition = 1
        self.mAccuracyMultiplier = 1.0
        self.mHealthMultiplier = 1.0
        self.mPickupHealth = 1.0
        self.mPickupArmor = 1.0
        self.mPickupAmmo = 1.0
        self.mPickupWeapon = 1.0
        self.mPickupEquipment = 1.0

        self.mDefaultPadding = 0
        self.mSymmetric = SYMMETRY_NONE

        //	mCheckedEnts.clear();

        self.mLandScape = landscape

        // cut down the possible area that is 'legal' for area manager to use by 20%
        var land_min = JKAShared.vec3_t()
        var land_max = JKAShared.vec3_t()

        land_min[0] = self.mLandScape!.GetBounds()[0][0] + (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * 0.1
        land_min[1] = self.mLandScape!.GetBounds()[0][1] + (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * 0.1
        land_min[2] = self.mLandScape!.GetBounds()[0][2] + (self.mLandScape!.GetBounds()[1][2] - self.mLandScape!.GetBounds()[0][2]) * 0.1

        land_max[0] = self.mLandScape!.GetBounds()[1][0] - (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * 0.1
        land_max[1] = self.mLandScape!.GetBounds()[1][1] - (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * 0.1
        land_max[2] = self.mLandScape!.GetBounds()[1][2] - (self.mLandScape!.GetBounds()[1][2] - self.mLandScape!.GetBounds()[0][2]) * 0.1

        // Create a new area manager for the landscape
        self.mAreaManager = CRMAreaManager(land_min, land_max)

        // Create a new path manager
        self.mPathManager = CRMPathManager(self.mLandScape)
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:85
    deinit {
        //	mCheckedEnts.clear();

        // Cleanup the objectives
        // AI: Raven deletes each objective through the iterator. The clear below frees them.
        self.mObjectives.removeAll()

        // Cleanup the instances
        // Port-note: The class holds no `mInstances`, because CRMInstance has no Swift class, because the repo has no form for its virtual hierarchy.
        // Raven wrote: for (iit = mInstances.begin(); iit != mInstances.end(); iit++) { delete (*iit); }
        portMissing("CRMMission::~CRMMission", source: "oracle/codemp/RMG/RM_Mission.cpp:85")

        // AI: Raven deletes the path manager and the area manager. Setting each field to nil frees it.
        self.mPathManager = nil
        self.mAreaManager = nil
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1362
    func Load(_ mission: String, _ instances: String, _ difficulty: String) -> Bool {
        // TODO: Port CRMMission::Load
        portMissing("CRMMission::Load", source: "oracle/codemp/RMG/RM_Mission.cpp:1362")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1438
    @discardableResult
    func Spawn(_ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        // TODO: Port CRMMission::Spawn
        portMissing("CRMMission::Spawn", source: "oracle/codemp/RMG/RM_Mission.cpp:1438")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1711
    func Preview(_ from: JKAShared.vec3_t) {
        // TODO: Port CRMMission::Preview
        portMissing("CRMMission::Preview", source: "oracle/codemp/RMG/RM_Mission.cpp:1711")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:128
    func FindObjective(_ name: String) -> CRMObjective? {
        // AI: Raven walks `mObjectives` with an iterator. The walk is a for-in over the Array, the form of `mAreas` of CCMLandScape.
        for it in self.mObjectives {
            // Does it match?
            if Q_stricmp(it!.GetName(), name) == 0 {
                return (it)
            }
        }

        // Not found
        return nil
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:72
    func GetCurrentObjective() -> CRMObjective? {
        self.mCurrentObjective
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1602
    func CompleteMission() {
        Cvar_Set("cl_paused", "1")

        //	AddText(va("killserver; menu %s\n", mExitScreen.c_str()));
        return
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1620
    func FailedMission(_ TimeExpired: Bool) {
        Cvar_Set("cl_paused", "1")

        if TimeExpired {
            //		AddText(va("killserver; menu %s\n", mTimeExpiredScreen.c_str()));
        }
        return
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1642
    func CompleteObjective(_ objective: CRMObjective?) {
        // Raven assigns his own `objective` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
        var objective = objective

        // Set the object as completed
        if objective != nil {
            objective!.Complete(true)

            // Set the completed text for the objective
            //		gi.Cvar_Set( va("ar_obj_subcom0_%i", objective->GetOrderIndex ( )), "&OBJECTIVES_COMPLETE&", CVAR_OBJECTIVE) ;

            /*		CEntity *tent = G_TempEntity( vec3_origin, EV_SUB_PRINT );
            		tent->s.time2 = gi.SP_GetStringID ( objective->GetMessage ( ) );
            		tent->r.svFlags |= SVF_BROADCAST;
            		G_AddTempEntity(tent);

            		if (objective->CompleteSoundID())
            			G_SoundBroadcast( tent, objective->CompleteSoundID());
            */
        }

        self.mCurrentObjective = nil

        // Find the next objective
        // AI: Raven walks `mObjectives` with an iterator. The walk is a for-in over the Array, the form of `mAreas` of CCMLandScape.
        for it in self.mObjectives {
            objective = it

            // Skip completed objectives
            if objective!.IsCompleted() {
                continue
            }

            // Find the objective with the lowest priority
            if self.mCurrentObjective != nil && objective!.GetPriority() > self.mCurrentObjective!.GetPriority() {
                continue
            }

            // Found one
            self.mCurrentObjective = objective
        }

        if nil != self.mCurrentObjective {
            //		Cvar_SetValue ("ar_cur_objective", mCurrentObjective->GetOrderIndex ( ), CVAR_OBJECTIVE);

            self.mCurrentObjective!.Activate()
        } else {
            // Set the completed text for the objective
            //		Cvar_Set( "ar_obj_maincom0", "&OBJECTIVES_COMPLETE&", CVAR_OBJECTIVE) ;
        }
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:78
    func GetTimeLimit() -> Int32 {
        self.mTimeLimit
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:79
    func GetMaxInstancePosition() -> Int32 {
        self.mMaxInstancePosition
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:80
    func GetDescription() -> String {
        self.mDescription
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:81
    func GetExitScreen() -> String {
        self.mExitScreen
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:82
    func GetSymmetric() -> Int32 {
        self.mSymmetric
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:83
    func GetBackUpPath() -> Int32 {
        self.mBackUpPath
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:84
    func GetDefaultPadding() -> Int32 {
        self.mDefaultPadding
    }

    //	void			CreateMap				( void );

    /// Source: oracle/codemp/RMG/RM_Mission.h:88
    func DenyPickupHealth() -> Bool {
        self.mLandScape!.flrand(0.0, 1.0) > self.mPickupHealth
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:89
    func DenyPickupArmor() -> Bool {
        self.mLandScape!.flrand(0.0, 1.0) > self.mPickupArmor
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:90
    func DenyPickupAmmo() -> Bool {
        self.mLandScape!.flrand(0.0, 1.0) > self.mPickupAmmo
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:91
    func DenyPickupWeapon() -> Bool {
        self.mLandScape!.flrand(0.0, 1.0) > self.mPickupWeapon
    }

    /// Source: oracle/codemp/RMG/RM_Mission.h:92
    func DenyPickupEquipment() -> Bool {
        self.mLandScape!.flrand(0.0, 1.0) > self.mPickupEquipment
    }

    //	void			PurgeUnlinkedTriggers	( );
    //	void			PurgeTrigger			( CEntity* trigger );

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:145
    private func MirrorPos(_ pos: inout JKAShared.vec3_t) {
        pos[0] = 1.0 - pos[0]
        pos[1] = 1.0 - pos[1]
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1189
    private func ParseRandom(_ randomGroup: CGPGroup?) -> CGPGroup? {
        if nil == randomGroup {
            return nil
        }

        var group: CGPGroup?
        var groups = [CGPGroup?](repeating: nil, count: Int(MAX_RANDOM_CHOICES))
        var numGroups: Int32

        // Build a list of the groups one can be chosen
        numGroups = 0
        group = randomGroup!.GetSubGroups()
        while group != nil {
            if Q_stricmp(group!.GetName(), "random_choice") != 0 {
                group = group!.GetNext()
                continue
            }

            var weight = atoi(group!.FindPairValue("random_weight", "1")!)
            while weight > 0 {
                weight -= 1
                // Port-note: Raven writes past `groups` when the weights add up to more than MAX_RANDOM_CHOICES, undefined.
                // The Array index traps there, rule 19.
                groups[numGroups] = group
                numGroups += 1
            }
            assert(numGroups <= MAX_RANDOM_CHOICES)
            group = group!.GetNext()
        }

        // No groups!
        if numGroups == 0 {
            return randomGroup
        }

        // Now choose a group to parse
        return groups[self.mLandScape!.irand(0, numGroups - 1)]
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:163
    private func ParseOrigin(_ originGroup: CGPGroup?, _ origin: inout JKAShared.vec3_t, _ lookat: inout JKAShared.vec3_t, _ flattenHeight: inout Int32) -> Bool {
        let szNodeName: String
        var mins = JKAShared.vec3_t()
        var maxs = JKAShared.vec3_t()

        // AI: Raven tests the `int *` for NULL. An inout Int32 is never NULL, so the test drops.
        flattenHeight = 66

        // If no group was given then use 0,0,0
        if nil == originGroup {
            _VectorCopy(vec3_origin, &origin)
            return false
        }

        // See if attaching to a named node
        szNodeName = originGroup!.FindPairValue("node", "")!
        if strlen(szNodeName) != 0 {
            let node: CRMNode?
            // Find the node being attached to
            node = self.mPathManager!.FindNodeByName(szNodeName)
            if node != nil {
                // AI: Raven tests the `int *` for NULL. An inout Int32 is never NULL, so the test drops.
                if node!.GetFlattenHeight() == -1 {
                    node!.SetFlattenHeight(40 + self.mLandScape!.irand(0, 40))
                }

                flattenHeight = node!.GetFlattenHeight()

                _VectorCopy(node!.GetPos(), &origin)

                _VectorCopy(origin, &lookat)

                var dir: Int32
                let rnd_offset = self.mLandScape!.irand(0, DIR_MAX - 1)
                dir = 0
                while dir < DIR_MAX {
                    let d = (dir + rnd_offset) % DIR_MAX
                    if node!.PathExist(d) != 0 {
                        var tmp_pt = JKAShared.vec4_t()
                        var tmp_dir = JKAShared.vec4_t()
                        // C converts the `float` path id to the `int` local at the store.
                        let pathID = Int32(node!.GetPath(d))
                        self.mLandScape!.GetPathInfo(pathID, 0.1, &tmp_pt, &tmp_dir)
                        lookat[0] = tmp_pt[0]
                        lookat[1] = tmp_pt[1]
                        lookat[2] = 0
                        return true
                    }
                    dir += 1
                }
                return true
            }
        }

        mins[0] = Float(atof(originGroup!.FindPairValue("left", ".1")!))
        mins[1] = Float(atof(originGroup!.FindPairValue("top", ".1")!))
        maxs[0] = Float(atof(originGroup!.FindPairValue("right", ".9")!))
        maxs[1] = Float(atof(originGroup!.FindPairValue("bottom", ".9")!))

        origin[0] = self.mLandScape!.flrand(mins[0], maxs[0])
        lookat[0] = origin[0]
        origin[1] = self.mLandScape!.flrand(mins[1], maxs[1])
        lookat[1] = origin[1]
        origin[2] = 0
        lookat[2] = origin[2]

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:248
    private func ParseNodes(_ group: CGPGroup?) -> Bool {
        // If NULL that means this particular difficulty level has no named nodes
        if nil == group || self.mValidNodes {
            return true
        }

        // Raven assigns his own `group` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
        var group = group

        // how many nodes spaced over map?
        let x_cells: Int32
        let y_cells: Int32

        x_cells = atoi(group!.FindPairValue("x_cells", "3")!)
        y_cells = atoi(group!.FindPairValue("y_cells", "3")!)

        self.mPathManager!.CreateArray(x_cells, y_cells)

        // Loop through all the nodes and generate each as specified
        group = group!.GetSubGroups()
        while group != nil {
            // C converts each `double` result to the `int` local at the store.
            let min_depth = Int32(atof(group!.FindPairValue("min_depth", "0")!))
            let max_depth = Int32(atof(group!.FindPairValue("max_depth", "5")!))
            let min_paths = atoi(group!.FindPairValue("min_paths", "1")!)
            let max_paths = atoi(group!.FindPairValue("max_paths", "1")!)

            self.mPathManager!.CreateLocation(group!.GetName(), min_depth, max_depth, min_paths, max_paths)
            group = group!.GetNext()
        }

        self.mValidNodes = true
        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:294
    private func ParsePaths(_ group: CGPGroup?) -> Bool {
        // If NULL that means this particular difficulty level has no paths
        if nil == group || self.mValidPaths {
            return true
        }

        // path style info
        let depth: Float
        let deviation: Float
        let breadth: Float
        let minwidth: Float
        let maxwidth: Float
        let points: Int32

        points = atoi(group!.FindPairValue("points", "10")!)
        depth = Float(atof(group!.FindPairValue("depth", ".31")!))
        deviation = Float(atof(group!.FindPairValue("deviation", ".025")!))
        breadth = Float(atof(group!.FindPairValue("breadth", "5")!))
        minwidth = Float(atof(group!.FindPairValue("minwidth", ".03")!))
        maxwidth = Float(atof(group!.FindPairValue("maxwidth", ".05")!))

        self.mPathManager!.SetPathStyle(points, minwidth, maxwidth, depth, deviation, breadth)

        if !self.mValidPaths {
            // we must create paths
            self.mPathManager!.GeneratePaths(self.mSymmetric)
            self.mValidPaths = true
        }

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:340
    private func ParseRivers(_ group: CGPGroup?) -> Bool {
        // If NULL that means this particular difficulty level has no rivers
        if nil == group || self.mValidRivers {
            return true
        }

        // river style info
        let maxdepth: Int32
        let beddepth: Float
        let deviation: Float
        let breadth: Float
        let minwidth: Float
        let maxwidth: Float
        let points: Int32
        let bridge_name: String

        maxdepth = atoi(group!.FindPairValue("maxpathdepth", "5")!)
        points = atoi(group!.FindPairValue("points", "10")!)
        beddepth = Float(atof(group!.FindPairValue("depth", "1")!))
        deviation = Float(atof(group!.FindPairValue("deviation", ".03")!))
        breadth = Float(atof(group!.FindPairValue("breadth", "7")!))
        minwidth = Float(atof(group!.FindPairValue("minwidth", ".01")!))
        maxwidth = Float(atof(group!.FindPairValue("maxwidth", ".03")!))
        bridge_name = group!.FindPairValue("bridge", "")!

        self.mPathManager!.SetRiverStyle(maxdepth, points, minwidth, maxwidth, beddepth, deviation, breadth, bridge_name)

        if !self.mValidRivers &&
            beddepth < 1 {						// use a depth of 1 if we don't want any rivers
            // we must create rivers
            self.mPathManager!.GenerateRivers()
            self.mValidRivers = true
        }

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:379
    private func PlaceBridges() {
        // TODO: Port CRMMission::PlaceBridges
        portMissing("CRMMission::PlaceBridges", source: "oracle/codemp/RMG/RM_Mission.cpp:379")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:450
    // TODO: Port signature
    // Raven wrote: void CRMMission::PlaceWallInstance(CRMInstance*	instance, float xpos, float ypos, float zpos, int x, int y, float angle)
    // No table row for `CRMInstance* instance`.
    private func PlaceWallInstance() -> Never {
        // TODO: Port CRMMission::PlaceWallInstance
        portMissing("CRMMission::PlaceWallInstance", source: "oracle/codemp/RMG/RM_Mission.cpp:450")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1236
    private func ParseDifficulty(_ difficulty: CGPGroup?) -> Bool {
        // If a null difficulty then stop the recursion.  Make sure to
        // return true here so the parsing doesnt fail
        if nil == difficulty {
            return true
        }
        // is map supposed to be symmetric?
        self.mSymmetric = atoi(difficulty!.GetParent()!.FindPairValue("symmetric", "0")!)
        self.mBackUpPath = atoi(difficulty!.GetParent()!.FindPairValue("backuppath", "0")!)
        if self.mSymmetric != 0 {
            // pick between the 2 starting corners -- yes this is a hack
            self.mSymmetric = SYMMETRY_TOPLEFT
            if TheRandomMissionManager!.GetLandScape()!.irand(0, 1) != 0 {
                self.mSymmetric = SYMMETRY_BOTTOMRIGHT
            }
        }

        self.mDefaultPadding = atoi(difficulty!.GetParent()!.FindPairValue("padding", "0")!)

        // Parse the nodes
        if !self.ParseNodes(self.ParseRandom(difficulty!.FindSubGroup("nodes"))) {
            return false
        }

        // Parse the paths
        if !self.ParsePaths(self.ParseRandom(difficulty!.FindSubGroup("paths"))) {
            return false
        }

        // Parse the rivers
        if !self.ParseRivers(self.ParseRandom(difficulty!.FindSubGroup("rivers"))) {
            return false
        }

        // Handle inherited properties
        if !self.ParseDifficulty(difficulty!.GetParent()!.FindSubGroup(difficulty!.FindPairValue("inherit", "")!)) {
            return false
        }

        /*
        	// parse the player's outfit (weapons and ammo)
        	if ( !ParseOutfit( ParseRandom ( difficulty->FindSubGroup ( "outfit" ) ) ) )
        	{
        		// Its ok to fail parsing weapons as long as weapons have
        		// already been parsed at some point
        		if ( !ParseWeapons ( ParseRandom ( difficulty->FindSubGroup ( "weapons" ) ) ) )
        		{
        			if ( !mValidWeapons )
        			{
        				return false;
        			}
        		}

        		// Its ok to fail parsing ammo as long as ammo have
        		// already been parsed at some point
        		if ( !ParseAmmo ( ParseRandom ( difficulty->FindSubGroup ( "ammo" ) ) ) )
        		{
        			if ( !mValidAmmo)
        			{
        				return false;
        			}
        		}
        	}

        	// Its ok to fail parsing objectives as long as objectives have
        	// already been parsed at some point
        	if ( !ParseObjectives ( ParseRandom ( difficulty->FindSubGroup ( "objectives" ) ) ) )
        	{
        		if ( !mValidObjectives )
        		{
        			return false;
        		}
        	}
        */

        // Set the cvars with the available values
        Cvar_Set("mi_health", difficulty!.FindPairValue("health", "100")!)
        Cvar_Set("mi_armor", difficulty!.FindPairValue("armor", "0")!)

        // Parse out the timelimit
        self.mTimeLimit = atoi(difficulty!.FindPairValue("timelimit", "0")!)

        // NPC multipliers
        self.mAccuracyMultiplier = Float(atof(difficulty!.FindPairValue("npcaccuracy", "1")!))
        self.mHealthMultiplier = Float(atof(difficulty!.FindPairValue("npchealth", "1")!))

        // keep only some of RMG pickups 1 = 100%
        self.mPickupHealth = Float(atof(difficulty!.FindPairValue("pickup_health", "1")!))
        self.mPickupArmor = Float(atof(difficulty!.FindPairValue("pickup_armor", "1")!))
        self.mPickupAmmo = Float(atof(difficulty!.FindPairValue("pickup_ammo", "1")!))
        self.mPickupWeapon = Float(atof(difficulty!.FindPairValue("pickup_weapon", "1")!))
        self.mPickupEquipment = Float(atof(difficulty!.FindPairValue("pickup_equipment", "1")!))

        // Its ok to fail parsing instances as long as instances have
        // already been parsed at some point
        if !self.ParseInstances(self.ParseRandom(difficulty!.FindSubGroup("instances"))) {
            if !self.mValidInstances {
                return false
            }
        }

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1090
    private func ParseWeapons(_ weapons: CGPGroup?) -> Bool {
        /*	CGPValue*	weapon;
        	WpnID		id;

        	// No weapons, no success
        	if ( NULL == weapons )
        	{
        		return false;
        	}

        	if (0 == gi.Cvar_VariableIntegerValue("ar_wpnselect"))
        	{
        		// Make sure the weapon cvars are all reset so weapons from the last map or
        		// another difficulty level wont carry over
        		CWeaponSystem::ClearWpnCvars (TheWpnSysHelper());

        		id     = NULL_WpnID;
        		weapon = weapons->GetPairs ( );

        		// Loop through the weapons listed and grant them to the player
        		while ( weapon )
        		{
        			// Grab the weapons ID
        			id = CWeaponSystem::GetWpnID ( weapon->GetName ( ) );

        			// Now set the weapon cvar with the given data
        			TheWpnSysHelper().CvarSet ( CWeaponSystem::GetWpnCvar ( id ), weapon->GetTopValue ( ) );

        			// Move on to the next weapon
        			weapon = (CGPValue*)weapon->GetNext();
        		}

        		// If we found at least one weapon then ready the last one in the list
        		if ( NULL_WpnID != id )
        		{
        			TheWpnSysHelper().CvarSet("wp_righthand", va("%i/%i/0/0",id,CWeaponSystem::GetClipSize ( id )), CVAR_MISC );
        		}
        	}
        */
        self.mValidWeapons = true

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1040
    private func ParseAmmo(_ ammos: CGPGroup?) -> Bool {
        /*	CGPValue* ammo;

        	// No weapons, no success
        	if ( NULL == ammos )
        	{
        		return false;
        	}

        	if (0 == gi.Cvar_VariableIntegerValue("ar_wpnselect"))
        	{
        		// Make sure the ammo cvars are all reset so ammo from the last map or
        		// another difficulty level wont carry over
        		CWeaponSystem::ClearAmmoCvars (TheWpnSysHelper());

        		ammo = ammos->GetPairs ( );

        		// Loop through the weapons listed and grant them to the player
        		while ( ammo )
        		{
        			// Grab the weapons ID
        			AmmoID id = CWeaponSystem::GetAmmoID ( ammo->GetName ( ) );

        			// Now set the weapon cvar with the given data
        			TheWpnSysHelper().CvarSet ( CWeaponSystem::GetAmmoCvar ( id ), ammo->GetTopValue ( ), CVAR_AMMO );

        			// Move on to the next weapon
        			ammo = (CGPValue*)ammo->GetNext();
        		}
        	}
        */
        self.mValidAmmo = true

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1147
    private func ParseOutfit(_ outfit: CGPGroup?) -> Bool {
        if nil == outfit {
            return false
        }

        /*	// Its ok to fail parsing weapons as long as weapons have
        	// already been parsed at some point
        	if ( !ParseWeapons ( ParseRandom ( outfit->FindSubGroup ( "weapons" ) ) ) )
        	{
        		if ( !mValidWeapons )
        		{
        			return false;
        		}
        	}

        	// Its ok to fail parsing ammo as long as ammo have
        	// already been parsed at some point
        	if ( !ParseAmmo ( ParseRandom ( outfit->FindSubGroup ( "ammo" ) ) ) )
        	{
        		if ( !mValidAmmo)
        		{
        			return false;
        		}
        	}
        */
        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1000
    private func ParseObjectives(_ group: CGPGroup?) -> Bool {
        // If NULL that means this particular difficulty level has no objectives
        if nil == group {
            return true
        }

        // Raven assigns his own `group` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
        var group = group

        // Loop through all the objectives in the mission and add each
        // to the master list of objectives
        group = group!.GetSubGroups()
        while group != nil {
            let objective: CRMObjective?

            // Create the new objective
            objective = CRMObjective(group)

            self.mObjectives.append(objective)
            group = group!.GetNext()
        }

        self.mValidObjectives = true

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:886
    @discardableResult
    private func ParseInstance(_ group: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseInstance
        portMissing("CRMMission::ParseInstance", source: "oracle/codemp/RMG/RM_Mission.cpp:886")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:966
    private func ParseInstances(_ group: CGPGroup?) -> Bool {
        // If NULL that means this particular difficulty level has no instances
        if nil == group {
            return true
        }

        // Raven assigns his own `group` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
        var group = group

        // Loop through all the instances in the mission and add each
        // to the master list of instances
        group = group!.GetSubGroups()
        while group != nil {
            self.ParseInstance(group)
            group = group!.GetNext()
        }

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:737
    private func ParseInstancesOnPath(_ group: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseInstancesOnPath
        portMissing("CRMMission::ParseInstancesOnPath", source: "oracle/codemp/RMG/RM_Mission.cpp:737")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:485
    private func ParseWallRect(_ group: CGPGroup?, _ side: Int32) -> Bool {
        // TODO: Port CRMMission::ParseWallRect
        portMissing("CRMMission::ParseWallRect", source: "oracle/codemp/RMG/RM_Mission.cpp:485")
    }

    //	void			SpawnNPCTriggers		( CCMLandScape* landscape );
    //	void			AttachNPCTriggers		( CCMLandScape* landscape );
}
