import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

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
    // TODO: Port mSymmetric
    // Raven wrote: symmetry_t				mSymmetric;

    // if set to 1 in the mission file, adds an extra connecting path in symmetric maps
    // to ensure both sides actually do connect
    private var mBackUpPath: Int32 = 0

    private var mDefaultPadding: Int32 = 0

    // TODO: Port mAreaManager
    // Raven wrote: CRMAreaManager*			mAreaManager;

    // TODO: Port mPathManager
    // Raven wrote: CRMPathManager*			mPathManager;

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
        // Port-note: The class holds no `mSymmetric`, because `symmetry_t` of RM_Headers.h:29 has no Swift type.
        // Raven wrote: mSymmetric = SYMMETRY_NONE;
        portMissing("CRMMission::CRMMission", source: "oracle/codemp/RMG/RM_Mission.cpp:28")

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
        // Port-note: The class holds no `mAreaManager`, because `CRMAreaManager` has no Swift class.
        // Raven wrote: mAreaManager = new CRMAreaManager ( land_min, land_max );
        portMissing("CRMMission::CRMMission", source: "oracle/codemp/RMG/RM_Mission.cpp:28")

        // Create a new path manager
        // Port-note: The class holds no `mPathManager`, because `CRMPathManager` has no Swift class.
        // Raven wrote: mPathManager = new CRMPathManager ( mLandScape );
        portMissing("CRMMission::CRMMission", source: "oracle/codemp/RMG/RM_Mission.cpp:28")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:85
    deinit {
        //	mCheckedEnts.clear();

        // Cleanup the objectives
        // AI: Raven deletes each objective through the iterator. The clear below frees them.
        self.mObjectives.removeAll()

        // Cleanup the instances
        // Port-note: The class holds no `mInstances`, `mPathManager`, or `mAreaManager`, because their classes have no Swift class.
        // Raven wrote: for (iit = mInstances.begin(); iit != mInstances.end(); iit++) { delete (*iit); } if (mPathManager) { delete mPathManager; mPathManager = 0; } if (mAreaManager) { delete mAreaManager; mAreaManager = 0; }
        portMissing("CRMMission::~CRMMission", source: "oracle/codemp/RMG/RM_Mission.cpp:85")
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
        // Port-note: The class holds no `mSymmetric`, because `symmetry_t` of RM_Headers.h:29 has no Swift type.
        // Raven wrote: int GetSymmetric (void) { return mSymmetric; }
        // TODO: Port CRMMission::GetSymmetric
        portMissing("CRMMission::GetSymmetric", source: "oracle/codemp/RMG/RM_Mission.h:82")
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
        // TODO: Port CRMMission::ParseRandom
        portMissing("CRMMission::ParseRandom", source: "oracle/codemp/RMG/RM_Mission.cpp:1189")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:163
    // TODO: Port signature
    // Raven wrote: bool CRMMission::ParseOrigin ( CGPGroup* originGroup, vec3_t origin, vec3_t lookat, int* flattenHeight )
    // No table row for `int* flattenHeight`.
    private func ParseOrigin() -> Never {
        // TODO: Port CRMMission::ParseOrigin
        portMissing("CRMMission::ParseOrigin", source: "oracle/codemp/RMG/RM_Mission.cpp:163")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:248
    private func ParseNodes(_ group: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseNodes
        portMissing("CRMMission::ParseNodes", source: "oracle/codemp/RMG/RM_Mission.cpp:248")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:294
    private func ParsePaths(_ group: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParsePaths
        portMissing("CRMMission::ParsePaths", source: "oracle/codemp/RMG/RM_Mission.cpp:294")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:340
    private func ParseRivers(_ group: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseRivers
        portMissing("CRMMission::ParseRivers", source: "oracle/codemp/RMG/RM_Mission.cpp:340")
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
        // TODO: Port CRMMission::ParseDifficulty
        portMissing("CRMMission::ParseDifficulty", source: "oracle/codemp/RMG/RM_Mission.cpp:1236")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1090
    private func ParseWeapons(_ weapons: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseWeapons
        portMissing("CRMMission::ParseWeapons", source: "oracle/codemp/RMG/RM_Mission.cpp:1090")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1040
    private func ParseAmmo(_ ammos: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseAmmo
        portMissing("CRMMission::ParseAmmo", source: "oracle/codemp/RMG/RM_Mission.cpp:1040")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1147
    private func ParseOutfit(_ outfit: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseOutfit
        portMissing("CRMMission::ParseOutfit", source: "oracle/codemp/RMG/RM_Mission.cpp:1147")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:1000
    private func ParseObjectives(_ group: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseObjectives
        portMissing("CRMMission::ParseObjectives", source: "oracle/codemp/RMG/RM_Mission.cpp:1000")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:886
    private func ParseInstance(_ group: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseInstance
        portMissing("CRMMission::ParseInstance", source: "oracle/codemp/RMG/RM_Mission.cpp:886")
    }

    /// Source: oracle/codemp/RMG/RM_Mission.cpp:966
    private func ParseInstances(_ group: CGPGroup?) -> Bool {
        // TODO: Port CRMMission::ParseInstances
        portMissing("CRMMission::ParseInstances", source: "oracle/codemp/RMG/RM_Mission.cpp:966")
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
