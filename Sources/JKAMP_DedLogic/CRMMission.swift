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
    private var mInstances: rmInstanceList_t = []

    private let mInstanceFile = CRMInstanceFile()
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
        // AI: Raven deletes each instance through the iterator. The clear of the Array releases each instance, and its deinit runs Raven's destructor.
        self.mInstances.removeAll()

        // AI: Raven deletes the path manager and the area manager. Setting each field to nil frees it.
        self.mPathManager = nil
        self.mAreaManager = nil
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1362
    func Load(_ mission: String, _ instances: String, _ difficulty: String) -> Bool {
        let parser = CGenericParser2()
        let root: CGPGroup?

        // Create the parser for the mission file
        if !Com_ParseTextFile(va("ext_data/rmg/%s.mission", mission), parser) {
            if !Com_ParseTextFile(va("ext_data/arioche/%s.mission", mission), parser) {
                Com_Printf("ERROR: Failed to open mission file '%s'\n", mission)
                return false
            }
        }

        // Grab the root parser groop and make sure its mission, otherwise this
        // isnt a valid mission file
        root = parser.GetBaseParseGroup().GetSubGroups()
        // Port-note: Raven calls GetName through NULL when the file holds no root group, undefined.
        // The unwrap traps there, rule 19.
        if Q_stricmp(root!.GetName(), "mission") != 0 {
            Com_Printf("ERROR: '%s' is not a valid mission file\n", mission)
            parser.Clean()
            return false
        }

        // Grab the mission description and set the cvar for it
        self.mDescription = root!.FindPairValue("description", "<MISSION DESCRIPTION MISSING>")!
        //	Cvar_Set("ar_obj_main0",mDescription.c_str(), CVAR_OBJECTIVE);
        //	Cvar_Set("ar_obj_maincom0", "&OBJECTIVES_INPROGRESS&", CVAR_OBJECTIVE);
        //	Cvar_SetValue ("ar_cur_objective", 0, CVAR_OBJECTIVE);

        // AI: Raven reads the "info" pair into the local `mInfo` that no line reads. The local drops.
        //	Cvar_Set("ar_obj_info0",mInfo.c_str(), CVAR_OBJECTIVE);

        self.mExitScreen = root!.FindPairValue("exitScreen", "<EXIT SCREEN MISSING>")!
        self.mTimeExpiredScreen = root!.FindPairValue("TimeExpiredScreen", "<TIME EXPIRED SCREEN MISSING>")!

        // Open the instance file for the specified instances
        if !self.mInstanceFile.Open(instances) {
            Com_Printf("ERROR: Could not open instance file '%s'\n", instances)
            return false
        }

        // Start at one and readjust each time we see and instance
        // with a higher value
        self.mMaxInstancePosition = 1

        // Now parse the specified difficulty level
        if !self.ParseDifficulty(root!.FindSubGroup(difficulty)) {
            return false
        }

        // Generate the terrain now
        self.mLandScape!.Generate(self.mSymmetric)

        // Cleanup
        parser.Clean()

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1438
    @discardableResult
    func Spawn(_ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        var areaIndex: Int32
        var area: CRMArea?

        if IsServer {
            // Prespawn all instances, this is mainly for flattening
            for instance in self.mInstances {
                // Pre-Spawn
                instance.PreSpawn(terrain, IsServer)

                if self.mSymmetric != 0 {
                    instance.SetMirror(1)
                    instance.PreSpawn(terrain, IsServer)
                    instance.SetMirror(0)
                }
            }

            self.mLandScape!.Smooth()

            // place bridges
            self.PlaceBridges()
        }
        // Raven copies the height map, the flatten map, and the seed of the client here under `#ifndef DEDICATED`, so the dedicated build has no line.

        self.mLandScape!.GetLandScape()!.UpdatePatches()

        if IsServer {
            // Spawn all instances
            for instance in self.mInstances {
                // Spawn
                instance.Spawn(terrain, IsServer)
                instance.PostSpawn(terrain, IsServer)

                if self.mSymmetric != 0 {
                    // spawn the mirror version
                    instance.SetMirror(1)
                    instance.Spawn(terrain, IsServer)
                    instance.PostSpawn(terrain, IsServer)
                    instance.SetMirror(0)
                }
            }
        }

        // create automap
        if com_dedicated!.integer == 0 {
            // Raven creates the automap here under `#ifndef DEDICATED`, so the dedicated build has no line.
        }

        // make sure to write out after the mirror happens so red side is displayed on map
        if 1 == Cvar_VariableIntegerValue("rmg_saveautomap") {
            // write out automap for test purposes
            var seed = CharBuf(MAX_QPATH)
            var terrainName = CharBuf(MAX_QPATH)
            var missionName = CharBuf(MAX_QPATH)
            Cvar_VariableStringBuffer("RMG_seed", &seed, MAX_QPATH)
            Cvar_VariableStringBuffer("RMG_terrain", &terrainName, MAX_QPATH)
            Cvar_VariableStringBuffer("RMG_mission", &missionName, MAX_QPATH)

            // Raven draws each automap symbol and saves the automap image here under `#ifndef DEDICATED`, so the dedicated build has no line.
            // Raven writes `return false` after this call, which `Com_Error` never reaches.
            Com_Error(ERR_DROP, "RMG Automap written.")
        }

        //	// draw player start on automap
        //	CEntity	*spot = NULL;
        //	spot = entitySystem->GetEntityFromClassname( spot, "info_player_start");
        //	if (spot)
        //	{
        //		gi.CM_TM_AddStart(spot->GetOrigin()[0], spot->GetOrigin()[1]);
        //	}

        // Spawn NPC triggers now
        //	SpawnNPCTriggers ( mLandScape );

        // Restory all the NPC's accuracies to the template accuracies times the
        // multiplier
        //	INPCEnt::RestoreTemplate ( mAccuracyMultiplier, mHealthMultiplier );

        if IsServer {
            // Little trick to set the current objective to the first in the list
            self.CompleteObjective(nil)

            // Iterate through the areas and add each to the landscapes list, this is sorta hacky
            // but bridges the game / common gap
            areaIndex = 0
            area = self.mAreaManager!.EnumArea(areaIndex)
            while nil != area {
                // Dont bother adding it to the list if collision isnt enabled
                if !area!.IsCollisionEnabled() {
                    areaIndex += 1
                    area = self.mAreaManager!.EnumArea(areaIndex)
                    continue
                }

                let newarea = CArea()
                newarea.Init(area!.GetOrigin(), area!.GetSpacingRadius(), 0, area!.IsFlattened() ? AT_FLAT : AT_NONE)
                self.mLandScape!.GetLandScape()!.SaveArea(newarea)

                if self.mSymmetric != 0 {
                    let newarea = CArea()
                    newarea.Init(area!.GetOrigin(), area!.GetSpacingRadius(), 0, area!.IsFlattened() ? AT_FLAT : AT_NONE)
                    newarea.mPosition[0] = self.mLandScape!.GetBounds()[0][0] + self.mLandScape!.GetBounds()[1][0] - newarea.GetPosition()[0]
                    newarea.mPosition[1] = self.mLandScape!.GetBounds()[0][1] + self.mLandScape!.GetBounds()[1][1] - newarea.GetPosition()[1]
                    self.mLandScape!.GetLandScape()!.SaveArea(newarea)
                }
                areaIndex += 1
                area = self.mAreaManager!.EnumArea(areaIndex)
            }

            self.mInstanceFile.Close()
        }

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1711
    func Preview(_ from: JKAShared.vec3_t) {
        // Look for settlements close to the player and put up some debug stuff
        for instance in self.mInstances {
            var a = JKAShared.vec3_t()
            var b = JKAShared.vec3_t()

            _VectorCopy(from, &a)
            _VectorCopy(instance.GetOrigin(), &b)

            a[2] = 0
            b[2] = 0

            // Skip stuff thats too far away
            if Distance(a, b) > 2000 {
                continue
            }

            instance.Preview(from)
        }
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
    @discardableResult
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
        if !self.mValidRivers || strlen(self.mPathManager!.GetBridgeName()) < 1 {
            return
        }

        var max_bridges: Int32 = 0
        var path: Int32
        var t: Float
        let river_depth = self.mLandScape!.GetLandScape()!.GetWaterHeight()
        var pos = JKAShared.vec3_t()
        var lastpos = JKAShared.vec3_t()
        var bounds: [JKAShared.vec3_t] = [JKAShared.vec3_t(), JKAShared.vec3_t()]
        bounds[0] = JKAShared.vec3_t(0, 0, 0)
        bounds[1] = JKAShared.vec3_t(0, 0, 0)

        // walk along paths looking for dips
        path = 0
        while path < self.mPathManager!.GetPathCount() {
            var tmp_pt = JKAShared.vec4_t()
            var tmp_dir = JKAShared.vec4_t()
            var new_water = true

            self.mLandScape!.GetPathInfo(path, 0, &tmp_pt, &tmp_dir)
            lastpos[0] = self.mLandScape!.GetBounds()[0][0] + (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * tmp_pt[0]
            lastpos[1] = self.mLandScape!.GetBounds()[0][1] + (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * tmp_pt[1]
            lastpos[2] = self.mLandScape!.GetBounds()[0][2] + (self.mLandScape!.GetBounds()[1][2] - self.mLandScape!.GetBounds()[0][2]) * tmp_pt[2]
            _ = self.mLandScape!.GetLandScape()!.GetWorldHeight(&lastpos, bounds, true)

            let delta: Float = 0.05
            t = delta
            while t < 1.0 {
                self.mLandScape!.GetPathInfo(path, t, &tmp_pt, &tmp_dir)
                pos[0] = self.mLandScape!.GetBounds()[0][0] + (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * tmp_pt[0]
                pos[1] = self.mLandScape!.GetBounds()[0][1] + (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * tmp_pt[1]
                pos[2] = self.mLandScape!.GetBounds()[0][2] + (self.mLandScape!.GetBounds()[1][2] - self.mLandScape!.GetBounds()[0][2]) * tmp_pt[2]
                _ = self.mLandScape!.GetLandScape()!.GetWorldHeight(&pos, bounds, true)

                if new_water &&
                    lastpos[2] < river_depth &&
                    pos[2] < river_depth &&
                    pos[2] > lastpos[2] {
                    // add a bridge
                    if max_bridges < 3 {
                        let area: CRMArea?
                        let instance: CRMInstance?

                        max_bridges += 1

                        // create a single bridge
                        lastpos[2] = self.mLandScape!.GetBounds()[0][2] + (self.mLandScape!.GetBounds()[1][2] - self.mLandScape!.GetBounds()[0][2]) * self.mPathManager!.GetPathDepth()
                        instance = self.mInstanceFile.CreateInstance(self.mPathManager!.GetBridgeName())

                        if nil != instance {
                            // Set the area
                            // C converts the `int` padding to the `float` parameter.
                            area = self.mAreaManager!.CreateArea(&lastpos, instance!.GetSpacingRadius(), instance!.GetSpacingLine(), Float(self.GetDefaultPadding()), 0, vec3_origin, pos, instance!.GetFlattenRadius() != 0 ? true : false, false, instance!.GetLockOrigin())
                            area!.EnableLookAt(false)

                            instance!.SetArea(self.mAreaManager, area)
                            self.mInstances.append(instance!)
                            new_water = false
                        }
                    }
                } else if pos[2] > river_depth {
                    // hit land again
                    new_water = true
                }
                _VectorCopy(pos, &lastpos)
                t += delta
            }
            path += 1
        }
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:450
    private func PlaceWallInstance(_ instance: CRMInstance?, _ xpos: Float, _ ypos: Float, _ zpos: Float, _ x: Int32, _ y: Int32, _ angle: Float) {
        if nil == instance {
            return
        }

        let spacing = instance!.GetSpacingRadius()
        let area: CRMArea?
        var origin = JKAShared.vec3_t()

        // C converts each `int` cell to `float` at the multiply.
        origin[0] = xpos + spacing * Float(x)
        origin[1] = ypos + spacing * Float(y)
        origin[2] = zpos

        // Set the area of position
        // AI: Raven passes `origin` as the origin that CreateArea moves and as the look-at origin.
        // The call passes a copy as the look-at origin, because the inout parameter cannot alias it, and MoveArea writes the origin only for a symmetric area.
        let lookAtOrigin = origin
        // C converts the `int` padding to the `float` parameter.
        area = self.mAreaManager!.CreateArea(&origin, (spacing / 2.1), 0, Float(self.GetDefaultPadding()), 0, vec3_origin, lookAtOrigin, instance!.GetFlattenRadius() != 0 ? true : false, false, instance!.GetLockOrigin())
        area!.EnableLookAt(false)
        area!.SetAngle(angle)
        instance!.SetArea(self.mAreaManager, area)

        self.mInstances.append(instance!)
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
        let area: CRMArea?
        let instance: CRMInstance?
        let spacing: Float
        var origin = JKAShared.vec3_t()
        // Port-note: Raven reads `lookat` uninitialized below when the group has no "origin" sub group, because ParseOrigin then writes only `origin`, undefined.
        // The local starts at zero, rule 19.
        var lookat = JKAShared.vec3_t()
        var flattenHeight: Int32 = 0

        // create fences / walls

        // Create the instance using the instance file helper class
        instance = self.mInstanceFile.CreateInstance(group!.GetName())

        // Failed to create, not good
        if nil == instance {
            return false
        }

        // If a spacing radius was specified then override the one thats
        // in the instance
        spacing = Float(atof(group!.FindPairValue("spacing", "0")!))
        if spacing != 0 {
            instance!.SetSpacingRadius(spacing)
        }

        instance!.SetFilter(group!.FindPairValue("filter", "")!)
        instance!.SetTeamFilter(group!.FindPairValue("teamfilter", "")!)

        if strstr(instance!.GetTeamFilter(), "red") != nil {
            instance!.SetSide(SIDE_RED)
        } else if strstr(instance!.GetTeamFilter(), "blue") != nil {
            instance!.SetSide(SIDE_BLUE)
        }

        //	ParseWallRect(group, instance->GetSide());

        // Get its origin now
        self.ParseOrigin(group!.FindSubGroup("origin"), &origin, &lookat, &flattenHeight)
        origin[0] = self.mLandScape!.GetBounds()[0][0] + (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * origin[0]
        origin[1] = self.mLandScape!.GetBounds()[0][1] + (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * origin[1]
        origin[2] = self.mLandScape!.GetBounds()[0][2] + (self.mLandScape!.GetBounds()[1][2] - self.mLandScape!.GetBounds()[0][2]) * origin[2]

        lookat[0] = self.mLandScape!.GetBounds()[0][0] + (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * lookat[0]
        lookat[1] = self.mLandScape!.GetBounds()[0][1] + (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * lookat[1]
        lookat[2] = self.mLandScape!.GetBounds()[0][2] + (self.mLandScape!.GetBounds()[1][2] - self.mLandScape!.GetBounds()[0][2]) * lookat[2]

        // Fixed height?  (used for bridges)
        if atoi(group!.FindPairValue("nodrop", "0")!) == 0 {
            origin[2] = self.mLandScape!.GetBounds()[1][2] + 100
        }

        // Set the area of position
        // C converts the `int` padding to the `float` parameter.
        area = self.mAreaManager!.CreateArea(&origin, instance!.GetSpacingRadius(), instance!.GetSpacingLine(), Float(self.GetDefaultPadding()), 0, vec3_origin, lookat, instance!.GetFlattenRadius() != 0 ? true : false, true, instance!.GetLockOrigin(), self.mSymmetric)
        instance!.SetArea(self.mAreaManager, area)
        instance!.SetFlattenHeight(flattenHeight)

        self.mInstances.append(instance!)

        // create defenses?
        self.ParseInstancesOnPath(group)

        return true
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
    @discardableResult
    private func ParseInstancesOnPath(_ group: CGPGroup?) -> Bool {
        var defenseGroup: CGPGroup?
        defenseGroup = group!.GetSubGroups()
        while defenseGroup != nil {
            if Q_stricmp(defenseGroup!.GetName(), "defenses") == 0 ||
                Q_stricmp(defenseGroup!.GetName(), "instanceonpath") == 0 {
                let defName = defenseGroup!.FindPairValue("instance", "")!
                if strlen(defName) != 0 {
                    let minpos: Float
                    let maxpos: Float
                    let mincount: Int32
                    let maxcount: Int32

                    // how far along path does this get placed?
                    minpos = Float(atof(defenseGroup!.FindPairValue("minposition", "0.5")!))
                    maxpos = Float(atof(defenseGroup!.FindPairValue("maxposition", "0.5")!))
                    mincount = atoi(defenseGroup!.FindPairValue("mincount", "1")!)
                    maxcount = atoi(defenseGroup!.FindPairValue("maxcount", "1")!)

                    let nodename: String
                    let originGroup = group!.FindSubGroup("origin")
                    if originGroup != nil {
                        nodename = originGroup!.FindPairValue("node", "")!
                        if strlen(nodename) != 0 {
                            let node: CRMNode?
                            // Find the node being attached to
                            node = self.mPathManager!.FindNodeByName(nodename)
                            if node != nil {
                                var dir: Int32
                                // look at each connection from this node to others, if there is a path, create a defense
                                dir = 0
                                while dir < DIR_MAX {
                                    if node!.PathExist(dir) != 0 {
                                        // path leads out of this node
                                        var area: CRMArea?
                                        var instance: CRMInstance?
                                        var spacing: Float
                                        var origin = JKAShared.vec3_t()
                                        var lookat = JKAShared.vec3_t()
                                        var tmp_pt = JKAShared.vec4_t()
                                        var tmp_dir = JKAShared.vec4_t()
                                        var n: Int32
                                        let num_insts = self.mLandScape!.irand(mincount, maxcount)
                                        // C converts the `float` path id to the `int` local at the store.
                                        let pathID = Int32(node!.GetPath(dir))

                                        if 0 == num_insts {
                                            dir += 1
                                            continue
                                        }

                                        // C converts the `int` count to `float` at the divide.
                                        let posdelta = (maxpos - minpos) / Float(num_insts)

                                        n = 0
                                        while n < num_insts {
                                            instance = self.mInstanceFile.CreateInstance(defName)
                                            // Failed to create, not good
                                            if nil == instance {
                                                n += 1
                                                continue
                                            }
                                            // If a spacing radius was specified then override the one thats
                                            // in the instance
                                            spacing = Float(atof(defenseGroup!.FindPairValue("spacing", "0")!))
                                            if spacing != 0 {
                                                instance!.SetSpacingRadius(spacing)
                                            }

                                            instance!.SetFilter(group!.FindPairValue("filter", "")!)
                                            instance!.SetTeamFilter(group!.FindPairValue("teamfilter", "")!)

                                            if strstr(instance!.GetTeamFilter(), "red") != nil {
                                                instance!.SetSide(SIDE_RED)
                                            } else if strstr(instance!.GetTeamFilter(), "blue") != nil {
                                                instance!.SetSide(SIDE_BLUE)
                                            }

                                            // C converts the `int` index to `float` at each multiply.
                                            let pos_along_path = self.mLandScape!.flrand(minpos + posdelta * Float(n), minpos + posdelta * Float(n + 1))
                                            let look_along_path = Float(atof(defenseGroup!.FindPairValue("pathalign", "1")!))
                                            self.mLandScape!.GetPathInfo(pathID, pos_along_path, &tmp_pt, &tmp_dir)
                                            origin[0] = tmp_pt[0]
                                            origin[1] = tmp_pt[1]

                                            self.mLandScape!.GetPathInfo(pathID, look_along_path, &tmp_dir, &tmp_pt)
                                            lookat[0] = tmp_pt[0]
                                            lookat[1] = tmp_pt[1]

                                            origin[0] = self.mLandScape!.GetBounds()[0][0] + (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * origin[0]
                                            origin[1] = self.mLandScape!.GetBounds()[0][1] + (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * origin[1]
                                            origin[2] = self.mLandScape!.GetBounds()[0][2]

                                            // look at a point along the path at this location
                                            lookat[0] = self.mLandScape!.GetBounds()[0][0] + (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * lookat[0]
                                            lookat[1] = self.mLandScape!.GetBounds()[0][1] + (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * lookat[1]
                                            lookat[2] = 0

                                            // Fixed height?  (used for bridges)
                                            if atoi(group!.FindPairValue("nodrop", "0")!) == 0 {
                                                origin[2] = self.mLandScape!.GetBounds()[1][2] + 100
                                            }

                                            // Set the area of position
                                            // AI: Raven passes `origin` as the origin that CreateArea moves and as the confine origin.
                                            // The call passes a copy as the confine origin, because the inout parameter cannot alias it, and the area copies the confine origin before MoveArea runs.
                                            let confineOrigin = origin
                                            // C converts the `int` padding to the `float` parameter.
                                            area = self.mAreaManager!.CreateArea(&origin, instance!.GetSpacingRadius(), instance!.GetSpacingLine(), Float(self.GetDefaultPadding()), 0, confineOrigin, lookat, instance!.GetFlattenRadius() != 0 ? true : false, true, instance!.GetLockOrigin(), self.mSymmetric)
                                            area!.EnableLookAt(false)

                                            if node!.GetFlattenHeight() == -1 {
                                                node!.SetFlattenHeight(66 + self.mLandScape!.irand(0, 40))
                                            }
                                            instance!.SetFlattenHeight(node!.GetFlattenHeight())

                                            instance!.SetArea(self.mAreaManager, area)

                                            self.mInstances.append(instance!)
                                            n += 1
                                        }
                                    }
                                    dir += 1
                                }
                            }
                        }
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            }
            defenseGroup = defenseGroup!.GetNext()
        }

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:485
    private func ParseWallRect(_ group: CGPGroup?, _ side: Int32) -> Bool {
        // Port-note: Raven calls FindSubGroup through `group` before its NULL test, undefined when `group` is NULL.
        // The unwrap traps there, rule 19.
        let wallGroup = group!.FindSubGroup("wallrect")

        // If NULL that means this particular instance has no wall rect
        if nil == group || nil == wallGroup {
            return true
        }

        let wallName = wallGroup!.FindPairValue("wall_instance", "")
        let cornerName = wallGroup!.FindPairValue("corner_instance", "")
        let towerName = wallGroup!.FindPairValue("tower_instance", "")
        let gateName = wallGroup!.FindPairValue("gate_instance", "")
        let ripName = wallGroup!.FindPairValue("rip_instance", "")

        if nil != wallName {
            let xcount = atoi(wallGroup!.FindPairValue("xcount", "0")!)
            let ycount = atoi(wallGroup!.FindPairValue("ycount", "0")!)

            var gateCount = atoi(wallGroup!.FindPairValue("gate_count", "1")!)
            let gateMin = atoi(wallGroup!.FindPairValue("gate_min", "0")!)
            let gateMax = atoi(wallGroup!.FindPairValue("gate_max", "0")!)

            var ripCount = atoi(wallGroup!.FindPairValue("rip_count", "0")!)
            let ripMin = atoi(wallGroup!.FindPairValue("rip_min", "0")!)
            let ripMax = atoi(wallGroup!.FindPairValue("rip_max", "0")!)

            var towerCount = atoi(wallGroup!.FindPairValue("tower_count", "0")!)
            let towerMin = atoi(wallGroup!.FindPairValue("tower_min", "0")!)
            let towerMax = atoi(wallGroup!.FindPairValue("tower_max", "0")!)

            if gateMin != gateMax {
                gateCount = self.mLandScape!.irand(gateMin, gateMax)
            }

            if ripMin != ripMax {
                ripCount = self.mLandScape!.irand(ripMin, ripMax)
            }

            if towerMin != towerMax {
                towerCount = self.mLandScape!.irand(towerMin, towerMax)
            }

            if nil == gateName {
                gateCount = 0
            }

            if nil == towerName {
                towerCount = 0
            }

            if nil == ripName {
                ripCount = 0
            }

            let nodename: String
            let originGroup = group!.FindSubGroup("origin")
            if originGroup != nil {
                nodename = originGroup!.FindPairValue("node", "")!
                if strlen(nodename) != 0 {
                    let node: CRMNode?
                    // Find the node being attached to
                    node = self.mPathManager!.FindNodeByName(nodename)
                    if node != nil {
                        var instance: CRMInstance?
                        var x: Int32
                        var y: Int32
                        let halfx = xcount / 2
                        let halfy = ycount / 2
                        let xpos = self.mLandScape!.GetBounds()[0][0] + (self.mLandScape!.GetBounds()[1][0] - self.mLandScape!.GetBounds()[0][0]) * node!.GetPos()[0]
                        let ypos = self.mLandScape!.GetBounds()[0][1] + (self.mLandScape!.GetBounds()[1][1] - self.mLandScape!.GetBounds()[0][1]) * node!.GetPos()[1]
                        let zpos = self.mLandScape!.GetBounds()[1][2] + 100
                        var angle: Float = 0
                        var lastGate: Int32 = 0
                        var lastRip: Int32 = 0

                        // Port-note: Raven calls SetSide through NULL when CreateInstance finds no instance of the name, undefined.
                        // Each `instance!` before a PlaceWallInstance of this block traps there, rule 19.

                        // corners
                        x = -halfx
                        y = -halfy
                        if towerCount > 3 ||
                            (towerCount > 0 && self.mLandScape!.irand(1, 2) == 1) {
                            towerCount -= 1
                            instance = self.mInstanceFile.CreateInstance(towerName!)
                        } else {
                            instance = self.mInstanceFile.CreateInstance(cornerName!)
                        }
                        angle = DEG2RAD(90)
                        instance!.SetSide(side)
                        self.PlaceWallInstance(instance, xpos, ypos, zpos, x, y, angle)

                        x = halfx
                        y = -halfy
                        if towerCount > 3 ||
                            (towerCount > 0 && self.mLandScape!.irand(1, 2) == 1) {
                            towerCount -= 1
                            instance = self.mInstanceFile.CreateInstance(towerName!)
                        } else {
                            instance = self.mInstanceFile.CreateInstance(cornerName!)
                        }
                        angle = DEG2RAD(180)
                        instance!.SetSide(side)
                        self.PlaceWallInstance(instance, xpos, ypos, zpos, x, y, angle)

                        x = halfx
                        y = halfy
                        if towerCount > 3 ||
                            (towerCount > 0 && self.mLandScape!.irand(1, 2) == 1) {
                            towerCount -= 1
                            instance = self.mInstanceFile.CreateInstance(towerName!)
                        } else {
                            instance = self.mInstanceFile.CreateInstance(cornerName!)
                        }
                        angle = DEG2RAD(270)
                        instance!.SetSide(side)
                        self.PlaceWallInstance(instance, xpos, ypos, zpos, x, y, angle)

                        x = -halfx
                        y = halfy
                        if towerCount > 3 ||
                            (towerCount > 0 && self.mLandScape!.irand(1, 2) == 1) {
                            towerCount -= 1
                            instance = self.mInstanceFile.CreateInstance(towerName!)
                        } else {
                            instance = self.mInstanceFile.CreateInstance(cornerName!)
                        }
                        angle = DEG2RAD(0)
                        instance!.SetSide(side)
                        self.PlaceWallInstance(instance, xpos, ypos, zpos, x, y, angle)

                        // walls
                        angle = DEG2RAD(0)
                        x = -halfx + 1
                        while x <= halfx - 1 {
                            if lastGate < 1 && gateCount > 0 && self.mLandScape!.irand(1, (halfx + halfy) / gateCount) == 1 {
                                // gate
                                gateCount -= 1
                                lastGate = 3
                                instance = self.mInstanceFile.CreateInstance(gateName!)
                            } else if lastRip < 1 && ripCount > 0 && self.mLandScape!.irand(1, (halfx + halfy) / ripCount) == 1 {
                                // damaged fence
                                ripCount -= 1
                                lastRip = 3
                                instance = self.mInstanceFile.CreateInstance(ripName!)
                            } else {
                                // just a wall
                                instance = self.mInstanceFile.CreateInstance(wallName!)
                                lastRip -= 1
                                lastGate -= 1
                            }
                            instance!.SetSide(side)
                            self.PlaceWallInstance(instance, xpos, ypos, zpos, x, -halfy, angle)
                            x += 1
                        }
                        x = -halfx + 1
                        while x <= halfx - 1 {
                            if lastGate < 1 && gateCount > 0 && self.mLandScape!.irand(1, (halfx + halfy) / gateCount) == 1 {
                                // gate
                                gateCount -= 1
                                lastGate = 3
                                instance = self.mInstanceFile.CreateInstance(gateName!)
                            } else if lastRip < 1 && ripCount > 0 && self.mLandScape!.irand(1, (halfx + halfy) / ripCount) == 1 {
                                // damaged fence
                                ripCount -= 1
                                lastRip = 3
                                instance = self.mInstanceFile.CreateInstance(ripName!)
                            } else {
                                // just a wall
                                instance = self.mInstanceFile.CreateInstance(wallName!)
                                lastRip -= 1
                                lastGate -= 1
                            }
                            instance!.SetSide(side)
                            self.PlaceWallInstance(instance, xpos, ypos, zpos, x, halfy, angle)
                            x += 1
                        }

                        angle = DEG2RAD(90)
                        y = -halfy + 1
                        while y <= halfy - 1 {
                            if lastGate < 1 && gateCount > 0 && self.mLandScape!.irand(1, (halfx + halfy) / gateCount) == 1 {
                                // gate
                                gateCount -= 1
                                lastGate = 3
                                instance = self.mInstanceFile.CreateInstance(gateName!)
                            } else if lastRip < 1 && ripCount > 0 && self.mLandScape!.irand(1, (halfx + halfy) / ripCount) == 1 {
                                // damaged fence
                                ripCount -= 1
                                lastRip = 3
                                instance = self.mInstanceFile.CreateInstance(ripName!)
                            } else {
                                // just a wall
                                instance = self.mInstanceFile.CreateInstance(wallName!)
                                lastRip -= 1
                                lastGate -= 1
                            }
                            instance!.SetSide(side)
                            self.PlaceWallInstance(instance, xpos, ypos, zpos, -halfx, y, angle)
                            y += 1
                        }
                        y = -halfy + 1
                        while y <= halfy - 1 {
                            if lastGate < 1 && gateCount > 0 && self.mLandScape!.irand(1, (halfx + halfy) / gateCount) == 1 {
                                // gate
                                gateCount -= 1
                                lastGate = 3
                                instance = self.mInstanceFile.CreateInstance(gateName!)
                            } else if lastRip < 1 && ripCount > 0 && self.mLandScape!.irand(1, (halfx + halfy) / ripCount) == 1 {
                                // damaged fence
                                ripCount -= 1
                                lastRip = 3
                                instance = self.mInstanceFile.CreateInstance(ripName!)
                            } else {
                                // just a wall
                                instance = self.mInstanceFile.CreateInstance(wallName!)
                                lastRip -= 1
                                lastGate -= 1
                            }
                            instance!.SetSide(side)
                            self.PlaceWallInstance(instance, xpos, ypos, zpos, halfx, y, angle)
                            y += 1
                        }
                    }
                }
            }
        } else {
            return false
        }

        return true
    }

    //	void			SpawnNPCTriggers		( CCMLandScape* landscape );
    //	void			AttachNPCTriggers		( CCMLandScape* landscape );
}
