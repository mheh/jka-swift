import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/RMG/RM_Instance.h:15
let AUTOMAP_NONE = 0 as Int32

/// Source: oracle/codemp/RMG/RM_Instance.h:16
let AUTOMAP_BLD = 1 as Int32

/// Source: oracle/codemp/RMG/RM_Instance.h:17
let AUTOMAP_OBJ = 2 as Int32

/// Source: oracle/codemp/RMG/RM_Instance.h:18
let AUTOMAP_START = 3 as Int32

/// Source: oracle/codemp/RMG/RM_Instance.h:19
let AUTOMAP_END = 4 as Int32

/// Source: oracle/codemp/RMG/RM_Instance.h:20
let AUTOMAP_ENEMY = 5 as Int32

/// Source: oracle/codemp/RMG/RM_Instance.h:21
let AUTOMAP_FRIEND = 6 as Int32

/// Source: oracle/codemp/RMG/RM_Instance.h:22
let AUTOMAP_WALL = 7 as Int32

/// Source: oracle/codemp/RMG/RM_Instance.h:120
// AI: Raven declares a `list<CRMInstance*>`. The type is an Array, by rule 17, and a for-in loop takes the place of `rmInstanceIter_t`.
typealias rmInstanceList_t = [CRMInstance]

/// Raven's instance of a random mission, a bsp, a group, a random choice, or a void that the mission places in an area of the landscape.
/// `CRMInstanceFile.CreateInstance` makes one by the name of its group in the instance file.
/// Source: oracle/codemp/RMG/RM_Instance.h:25
// AI: Raven's CRMInstance is the base of a closed virtual hierarchy. The class holds the base fields, and `kind` holds the fields each subclass adds, rule 17.
// AI: Raven's protected fields are internal, because the extension of each subclass file reads them.
final class CRMInstance {
    /// The subclass of Raven's instance, with the fields that the subclass adds.
    ///
    /// - `bsp`: a `CRMBSPInstance`, a bsp model that the server spawns.
    /// - `group`: a `CRMGroupInstance`, a list of child instances that the group places around its origin.
    /// - `random`: a `CRMRandomInstance`, one child instance that the constructor picks from a weighted list.
    /// - `void`: a `CRMVoidInstance`, an area with no collision that spaces the other instances.
    enum Kind {
        case bsp(CRMBSPInstance)
        case group(CRMGroupInstance)
        case random(CRMRandomInstance)
        case void
    }

    var mFilter = CharBuf(MAX_QPATH)			// filter of entities inside of this
    var mTeamFilter = CharBuf(MAX_QPATH)		// team specific filter

    var mBounds: [JKAShared.vec3_t] = [JKAShared.vec3_t(), JKAShared.vec3_t()]		// Bounding box for instance itself

    var mArea: CRMArea? = nil			// Position of the instance

    var mObjective: CRMObjective? = nil		// Objective associated with this instance

    // optional instance specific strings for objective
    // AI: Raven declares each text a `std::string`. Each field is a String, rule 17.
    var mMessage: String = ""		// message outputed when objective is completed
    var mDescription: String = ""	// description of objective
    var mInfo: String = ""			// more info for objective

    var mSpacingRadius: Float = 0	// Radius to space instances with
    var mFlattenRadius: Float = 0	// Radius to flatten under instances

    var mSpacingLine: Int32 = 0	// Line of spacing radius's, forces locket
    var mLockOrigin: Bool = false	// Origin cant move

    var mSurfaceSprites: Bool = false // allow surface sprites under instance?

    var mAutomapSymbol: Int32 = 0 // show which symbol on automap 0=none

    var mEntityID: Int32 = 0		// id of entity spawned
    var mSide: Int32 = 0			// blue or red side
    var mMirror: Int32 = 0		// mirror origin, angle

    var mFlattenHeight: Int32 = 0	// height to flatten land

    var kind: Kind

    /**
    ```
    ************************************************************************************************
     * CRMInstance::CRMInstance
     *	constructs a instnace object using the given parser group
     *
     * inputs:
     *  instance:  parser group containing information about the instance
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Instance.cpp:18
    // AI: Raven's constructor of each subclass runs this one first. The `kind` parameter is the subclass that the convenience initializer of its file makes.
    init(_ instGroup: CGPGroup?, _ instFile: CRMInstanceFile, _ kind: Kind) {
        self.kind = kind

        self.mObjective = nil
        self.mSpacingRadius = 0
        self.mFlattenRadius = 0
        self.mFilter[0] = 0
        self.mTeamFilter[0] = 0
        self.mArea = nil
        self.mAutomapSymbol = 0
        self.mEntityID = 0
        self.mSide = 0
        self.mMirror = 0
        self.mFlattenHeight = 66
        self.mSpacingLine = 0
        self.mSurfaceSprites = true
        self.mLockOrigin = false
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:62
    // AI: Raven's virtual destructor runs the destructor of the subclass and then the empty body of the base. The deinit runs the arm of the subclass.
    deinit {
        switch self.kind {
        case .bsp, .void:
            break

        case .group:
            self.CRMGroupInstance_deinit()

        case .random:
            self.CRMRandomInstance_deinit()
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:64
    func IsValid() -> Bool {
        switch self.kind {
        case .bsp, .group, .void:
            return true

        case .random(let random):
            return self.CRMRandomInstance_IsValid(random)
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:66
    @discardableResult
    func PreSpawn(_ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        switch self.kind {
        case .bsp, .void:
            return self.CRMInstance_PreSpawn(terrain, IsServer)

        case .group(let group):
            return self.CRMGroupInstance_PreSpawn(group, terrain, IsServer)

        case .random(let random):
            return self.CRMRandomInstance_PreSpawn(random, terrain, IsServer)
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMInstance::PreSpawn
     *	Prepares the instance for spawning by flattening the ground under it
     *
     * inputs:
     *  landscape: landscape the instance will be spawned on
     *
     * return:
     *	true: spawn preparation successful
     *  false: spawn preparation failed
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMInstance::PreSpawn`, the base body that a subclass calls by its qualified name.
    /// Source: oracle/codemp/RMG/RM_Instance.cpp:47
    func CRMInstance_PreSpawn(_ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        var origin = JKAShared.vec3_t()
        let area = CArea()

        _VectorCopy(self.GetOrigin(), &origin)

        if self.mMirror != 0 {
            origin[0] = TheRandomMissionManager!.GetLandScape()!.GetBounds()[0][0] + TheRandomMissionManager!.GetLandScape()!.GetBounds()[1][0] - origin[0]
            origin[1] = TheRandomMissionManager!.GetLandScape()!.GetBounds()[0][1] + TheRandomMissionManager!.GetLandScape()!.GetBounds()[1][1] - origin[1]
        }

        let terxelSize = terrain!.GetLandScape()!.GetTerxelSize()
        let bounds = terrain!.GetLandScape()!.GetBounds()

        // Align the instance to the center of a terxel
        origin[0] = bounds[0][0] + Int32((origin[0] - bounds[0][0] + terxelSize[0] / 2) / terxelSize[0]) * terxelSize[0]
        origin[1] = bounds[0][1] + Int32((origin[1] - bounds[0][1] + terxelSize[1] / 2) / terxelSize[1]) * terxelSize[1]


        // This is BAD - By copying the mirrored origin back into the instance, you've now mirrored the original instance
        // so when anything from this point on looks at the instance they'll be looking at a mirrored version but will be expecting the original
        // so later in the spawn functions the instance will be re-mirrored, because it thinks the mInstances have not been changed
        //	VectorCopy(origin, GetOrigin());

        // Flatten the area below the instance
        if self.GetFlattenRadius() != 0 {
            area.Init(origin, self.GetFlattenRadius(), 0.0, AT_NONE, 0, 0)
            terrain!.GetLandScape()!.FlattenArea(area, self.mFlattenHeight | (self.mSurfaceSprites ? 0 : 0x80), false, true, true)
        }

        return true
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:67
    @discardableResult
    func Spawn(_ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        switch self.kind {
        case .bsp(let bsp):
            return self.CRMBSPInstance_Spawn(bsp, terrain, IsServer)

        case .group(let group):
            return self.CRMGroupInstance_Spawn(group, terrain, IsServer)

        case .random(let random):
            return self.CRMRandomInstance_Spawn(random, terrain, IsServer)

        case .void:
            return false
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMInstance::PostSpawn
     *	Finishes the spawn by linking any objectives into the world that are associated with it
     *
     * inputs:
     *  landscape: landscape the instance was spawned on
     *
     * return:
     *	true: post spawn successfull
     *  false: post spawn failed
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Instance.cpp:95
    @discardableResult
    func PostSpawn(_ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        switch self.kind {
        case .bsp, .group, .random, .void:
            if self.mObjective != nil {
                return self.mObjective!.Link()
            }

            return true
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:70
    func Preview(_ from: JKAShared.vec3_t) {
        switch self.kind {
        case .bsp, .random, .void:
            self.CRMInstance_Preview(from)

        case .group(let group):
            self.CRMGroupInstance_Preview(group, from)
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMInstance::Preview
     *	Renderings debug information about the instance
     *
     * inputs:
     *  none
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMInstance::Preview`, the base body that a subclass calls by its qualified name.
    /// Source: oracle/codemp/RMG/RM_Instance.cpp:161
    func CRMInstance_Preview(_ from: JKAShared.vec3_t) {
        /*	CEntity				*tent;

        	// Add a cylindar for the whole settlement
        	tent = G_TempEntity( GetOrigin(), EV_DEBUG_CYLINDER );
        	VectorCopy( GetOrigin(), tent->s.origin2 );
        	tent->s.pos.trBase[2] += 40;
        	tent->s.origin2[2] += 50;
        	tent->s.time = 1050 + ((int)(GetSpacingRadius())<<16);
        	tent->s.time2 = GetPreviewColor ( );
        	G_AddTempEntity(tent);

        	// Origin line
        	tent = G_TempEntity( GetOrigin ( ), EV_DEBUG_LINE );
        	VectorCopy( GetOrigin(), tent->s.origin2 );
        	tent->s.origin2[2] += 400;
        	tent->s.time = 1050;
        	tent->s.weapon = 10;
        	tent->s.time2 = (255<<24) + (255<<16) + (255<<8) + 255;
        	G_AddTempEntity(tent);

        	if ( GetFlattenRadius ( ) )
        	{
        		// Add a cylindar for the whole settlement
        		tent = G_TempEntity( GetOrigin(), EV_DEBUG_CYLINDER );
        		VectorCopy( GetOrigin(), tent->s.origin2 );
        		tent->s.pos.trBase[2] += 40;
        		tent->s.origin2[2] += 50;
        		tent->s.time = 1050 + ((int)(GetFlattenRadius ( ))<<16);
        		tent->s.time2 = (255<<24) + (80<<16) +(80<<8) + 80;
        		G_AddTempEntity(tent);
        	}
        */
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:72
    func SetArea(_ amanager: CRMAreaManager?, _ area: CRMArea?) {
        switch self.kind {
        case .bsp:
            self.CRMInstance_SetArea(amanager, area)

        case .group(let group):
            self.CRMGroupInstance_SetArea(group, amanager, area)

        case .random(let random):
            self.CRMRandomInstance_SetArea(random, amanager, area)

        case .void:
            self.CRMVoidInstance_SetArea(amanager, area)
        }
    }

    /// Raven's `CRMInstance::SetArea`, the base body that a subclass calls by its qualified name.
    /// Source: oracle/codemp/RMG/RM_Instance.h:72
    func CRMInstance_SetArea(_ amanager: CRMAreaManager?, _ area: CRMArea?) {
        self.mArea = area
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:73
    func SetFilter(_ filter: String) {
        switch self.kind {
        case .bsp, .void:
            self.CRMInstance_SetFilter(filter)

        case .group(let group):
            self.CRMGroupInstance_SetFilter(group, filter)

        case .random(let random):
            self.CRMRandomInstance_SetFilter(random, filter)
        }
    }

    /// Raven's `CRMInstance::SetFilter`, the base body that a subclass calls by its qualified name.
    /// Source: oracle/codemp/RMG/RM_Instance.h:73
    func CRMInstance_SetFilter(_ filter: String) {
        strcpy(&self.mFilter, filter)
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:74
    func SetTeamFilter(_ teamFilter: String) {
        switch self.kind {
        case .bsp, .void:
            self.CRMInstance_SetTeamFilter(teamFilter)

        case .group(let group):
            self.CRMGroupInstance_SetTeamFilter(group, teamFilter)

        case .random(let random):
            self.CRMRandomInstance_SetTeamFilter(random, teamFilter)
        }
    }

    /// Raven's `CRMInstance::SetTeamFilter`, the base body that a subclass calls by its qualified name.
    /// Source: oracle/codemp/RMG/RM_Instance.h:74
    func CRMInstance_SetTeamFilter(_ teamFilter: String) {
        strcpy(&self.mTeamFilter, teamFilter)
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:75
    func SetObjective(_ obj: CRMObjective?) {
        self.mObjective = obj
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:76
    func GetObjective() -> CRMObjective? {
        self.mObjective
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:77
    func HasObjective() -> Bool {
        self.mObjective != nil
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:78
    func GetAutomapSymbol() -> Int32 {
        self.mAutomapSymbol
    }

    /// Source: oracle/codemp/RMG/RM_Instance.cpp:105
    func DrawAutomapSymbol() {
        TheRandomMissionManager!.AddAutomapSymbol(self.GetAutomapSymbol(), self.GetOrigin(), self.GetSide())
        /*
        	// draw proper symbol on map for instance
        	switch (GetAutomapSymbol())
        	{
        		default:
        		case AUTOMAP_NONE:
        			if (HasObjective())
        				CM_TM_AddObjective(GetOrigin()[0], GetOrigin()[1], GetSide());
        			break;
        		case AUTOMAP_BLD:
        			CM_TM_AddBuilding(GetOrigin()[0], GetOrigin()[1], GetSide());
        			if (HasObjective())
        				CM_TM_AddObjective(GetOrigin()[0], GetOrigin()[1], GetSide());
        			break;
        		case AUTOMAP_OBJ:
        			CM_TM_AddObjective(GetOrigin()[0], GetOrigin()[1], GetSide());
        			break;
        		case AUTOMAP_START:
        			CM_TM_AddStart(GetOrigin()[0], GetOrigin()[1], GetSide());
        			break;
        		case AUTOMAP_END:
        			CM_TM_AddEnd(GetOrigin()[0], GetOrigin()[1], GetSide());
        			break;
        		case AUTOMAP_ENEMY:
        			if (HasObjective())
        				CM_TM_AddObjective(GetOrigin()[0], GetOrigin()[1]);
        			if (1 == Cvar_VariableIntegerValue("rmg_automapshowall"))
        				CM_TM_AddNPC(GetOrigin()[0], GetOrigin()[1], false);
        			break;
        		case AUTOMAP_FRIEND:
        			if (HasObjective())
        				CM_TM_AddObjective(GetOrigin()[0], GetOrigin()[1]);
        			if (1 == Cvar_VariableIntegerValue("rmg_automapshowall"))
        				CM_TM_AddNPC(GetOrigin()[0], GetOrigin()[1], true);
        			break;
        		case AUTOMAP_WALL:
        			CM_TM_AddWallRect(GetOrigin()[0], GetOrigin()[1], GetSide());
        			break;
        	}
        */
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:80
    func GetMessage() -> String {
        self.mMessage
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:81
    func GetDescription() -> String {
        self.mDescription
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:82
    func GetInfo() -> String {
        self.mInfo
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:83
    func SetMessage(_ msg: String) {
        self.mMessage = msg
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:84
    func SetDescription(_ desc: String) {
        self.mDescription = desc
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:85
    func SetInfo(_ info: String) {
        self.mInfo = info
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:86
    func SetSide(_ side: Int32) {
        self.mSide = side
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:87
    func GetSide() -> Int32 {
        self.mSide
    }

    // NOTE: should consider making SetMirror also set all other variables that need flipping
    // like the origin and Side, etc... Otherwise an Instance may have had it's origin flipped
    // but then later will have mMirror set to false, but the origin is still flipped. So any functions
    // that look at the instance later will see mMirror set to false, but not realize the origin has ALREADY been flipped
    /// Source: oracle/codemp/RMG/RM_Instance.h:93
    func SetMirror(_ mirror: Int32) {
        switch self.kind {
        case .bsp, .void:
            self.CRMInstance_SetMirror(mirror)

        case .group(let group):
            self.CRMGroupInstance_SetMirror(group, mirror)

        case .random(let random):
            self.CRMRandomInstance_SetMirror(random, mirror)
        }
    }

    /// Raven's `CRMInstance::SetMirror`, the base body that a subclass calls by its qualified name.
    /// Source: oracle/codemp/RMG/RM_Instance.h:93
    func CRMInstance_SetMirror(_ mirror: Int32) {
        self.mMirror = mirror
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:94
    func GetMirror() -> Int32 {
        self.mMirror
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:96
    func GetSurfaceSprites() -> Bool {
        switch self.kind {
        case .bsp, .group, .random, .void:
            return self.mSurfaceSprites
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:98
    func GetLockOrigin() -> Bool {
        switch self.kind {
        case .bsp, .group, .void:
            return self.mLockOrigin

        case .random(let random):
            return self.CRMRandomInstance_GetLockOrigin(random)
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:99
    func GetSpacingLine() -> Int32 {
        switch self.kind {
        case .bsp, .group, .void:
            return self.mSpacingLine

        case .random(let random):
            return self.CRMRandomInstance_GetSpacingLine(random)
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:101
    func GetPreviewColor() -> Int32 {
        switch self.kind {
        case .bsp:
            return self.CRMBSPInstance_GetPreviewColor()

        case .group:
            return self.CRMGroupInstance_GetPreviewColor()

        case .random(let random):
            return self.CRMRandomInstance_GetPreviewColor(random)

        case .void:
            return 0
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:102
    func GetSpacingRadius() -> Float {
        switch self.kind {
        case .bsp, .void:
            return self.mSpacingRadius

        case .group:
            return self.CRMGroupInstance_GetSpacingRadius()

        case .random(let random):
            return self.CRMRandomInstance_GetSpacingRadius(random)
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:103
    func GetFlattenRadius() -> Float {
        switch self.kind {
        case .bsp, .void:
            return self.mFlattenRadius

        case .group:
            return self.CRMGroupInstance_GetFlattenRadius()

        case .random(let random):
            return self.CRMRandomInstance_GetFlattenRadius(random)
        }
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:104
    func GetFilter() -> String {
        String(self.mFilter)
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:105
    func GetTeamFilter() -> String {
        String(self.mTeamFilter)
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:107
    func GetArea() -> CRMArea {
        self.mArea!
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:108
    // AI: Raven returns the pointer of `mArea->GetOrigin()`. The method returns a copy, and a write goes to `mArea!.mOrigin`, the form of CRMArea.GetOrigin.
    func GetOrigin() -> JKAShared.vec3_t {
        self.mArea!.GetOrigin()
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:109
    func GetAngle() -> Float {
        self.mArea!.GetAngle()
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:110
    func SetAngle(_ ang: Float) {
        self.mArea!.SetAngle(ang)
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:111
    func GetBounds() -> [JKAShared.vec3_t] {
        (self.mBounds)
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:113
    func SetFlattenHeight(_ height: Int32) {
        self.mFlattenHeight = height
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:114
    func GetFlattenHeight() -> Int32 {
        self.mFlattenHeight
    }

    /// Source: oracle/codemp/RMG/RM_Instance.h:116
    func SetSpacingRadius(_ spacing: Float) {
        self.mSpacingRadius = spacing
    }
}
