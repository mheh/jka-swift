import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's random mission manager, the mission, its landscape and terrain, and the automap symbols of a random map.
/// One instance exists, `TheRandomMissionManager`, which the G_RMG_INIT arm of SV_GameSystemCalls makes.
/// Source: oracle/codemp/RMG/RM_Manager.h:9
// AI: Raven's static member `mCurObjective` of RM_Manager.h:57 is the forward of RM_Manager.swift over `EngineWorld`, the HAND_VARS form.
final class CRMManager {
    // TODO: Port mMission
    // Raven wrote: CRMMission*				mMission;
    private var mLandScape: CCMLandScape? = nil
    // TODO: Port mTerrain
    // Raven wrote: CRandomTerrain*			mTerrain;
    private var mPreviewTimer: Int32 = 0
    private var mCurPriority: Int32 = 0
    private var mUseTimeLimit: Bool = false

    // TODO: Port mAutomapSymbols
    // Raven wrote: rmAutomapSymbol_t		mAutomapSymbols[MAX_AUTOMAP_SYMBOLS];
    private var mAutomapSymbolCount: Int32 = 0

    /**
    ```
    ************************************************************************************************
     * CRMManager::UpdateStatisticCvars
     *	Updates the statistic cvars with data from the game
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
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:243
    private func UpdateStatisticCvars() {
        // TODO: Port CRMManager::UpdateStatisticCvars
        portMissing("CRMManager::UpdateStatisticCvars", source: "oracle/codemp/RMG/RM_Manager.cpp:243")
    }

    // Constructors
    /**
    ```
    ************************************************************************************************
     * CRMManager::CRMManager
     *	constructor
     *
     * inputs:
     *
     * return:
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:34
    init() {
        // TODO: Port CRMManager::CRMManager
        portMissing("CRMManager::CRMManager", source: "oracle/codemp/RMG/RM_Manager.cpp:34")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::~CRMManager
     *	destructor
     *
     * inputs:
     *
     * return:
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:53
    deinit {
        // TODO: Port CRMManager::~CRMManager
        portMissing("CRMManager::~CRMManager", source: "oracle/codemp/RMG/RM_Manager.cpp:53")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::LoadMission
     *	Loads the mission using the mission name stored in the ar_mission cvar
     *
     * inputs:
     *	none
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:96
    func LoadMission(_ IsServer: Bool) -> Bool {
        // TODO: Port CRMManager::LoadMission
        portMissing("CRMManager::LoadMission", source: "oracle/codemp/RMG/RM_Manager.cpp:96")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::Preview
     *	previews the random mission genration information
     *
     * inputs:
     *  from:  origin being previed from
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:391
    func SpawnMission(_ IsServer: Bool) -> Bool {
        // TODO: Port CRMManager::SpawnMission
        portMissing("CRMManager::SpawnMission", source: "oracle/codemp/RMG/RM_Manager.cpp:391")
    }

    // Accessors
    /**
    ```
    ************************************************************************************************
     * CRMManager::SetLandscape
     *	Sets the landscape and terrain object used to load a mission
     *
     * inputs:
     *	landscape - landscape object
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:79
    func SetLandScape(_ landscape: CCMLandScape?) {
        // TODO: Port CRMManager::SetLandScape
        portMissing("CRMManager::SetLandScape", source: "oracle/codemp/RMG/RM_Manager.cpp:79")
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:36
    func SetCurPriority(_ priority: Int32) {
        self.mCurPriority = priority
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:38
    // TODO: Port signature
    // Raven wrote: CRandomTerrain*	GetTerrain		(void)	{ return mTerrain; }
    // No table row for the return `CRandomTerrain *`.
    func GetTerrain() -> Never {
        // TODO: Port CRMManager::GetTerrain
        portMissing("CRMManager::GetTerrain", source: "oracle/codemp/RMG/RM_Manager.h:38")
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:39
    func GetLandScape() -> CCMLandScape? {
        self.mLandScape
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:40
    // TODO: Port signature
    // Raven wrote: CRMMission*		GetMission		(void)  { return mMission; }
    // No table row for the return `CRMMission *`.
    func GetMission() -> Never {
        // TODO: Port CRMManager::GetMission
        portMissing("CRMManager::GetMission", source: "oracle/codemp/RMG/RM_Manager.h:40")
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:41
    func GetCurPriority() -> Int32 {
        self.mCurPriority
    }

    /// Source: oracle/codemp/RMG/RM_Manager.cpp:400
    func AddAutomapSymbol(_ type: Int32, _ origin: JKAShared.vec3_t, _ side: Int32) {
        // TODO: Port CRMManager::AddAutomapSymbol
        portMissing("CRMManager::AddAutomapSymbol", source: "oracle/codemp/RMG/RM_Manager.cpp:400")
    }

    /// Source: oracle/codemp/RMG/RM_Manager.cpp:413
    func GetAutomapSymbolCount() -> Int32 {
        // TODO: Port CRMManager::GetAutomapSymbolCount
        portMissing("CRMManager::GetAutomapSymbolCount", source: "oracle/codemp/RMG/RM_Manager.cpp:413")
    }

    /// Source: oracle/codemp/RMG/RM_Manager.cpp:418
    // TODO: Port signature
    // Raven wrote: rmAutomapSymbol_t* CRMManager::GetAutomapSymbol ( int index )
    // No table row for the return `rmAutomapSymbol_t *`.
    func GetAutomapSymbol() -> Never {
        // TODO: Port CRMManager::GetAutomapSymbol
        portMissing("CRMManager::GetAutomapSymbol", source: "oracle/codemp/RMG/RM_Manager.cpp:418")
    }

    /**
    ```
    /*
    void CRMManager::WriteAutomapSymbols ( msg_t* msg )
    {
    	rmAutomapSymbolIter_t it;
    
    	MSG_WriteShort ( msg, (unsigned long)mAutomapSymbols.size() );
    
    	for(it = mAutomapSymbols.begin(); it != mAutomapSymbols.end(); it++)
    	{
    		CRMAutomapSymbol* symbol = (CRMAutomapSymbol*) *it;
    
    		MSG_WriteByte ( msg, (unsigned char) symbol->mType );
    		MSG_WriteByte ( msg, (unsigned char) symbol->mSide );
    		MSG_WriteLong ( msg, (long) symbol->mOrigin[0] );
    		MSG_WriteLong ( msg, (long) symbol->mOrigin[1] );
    	}
    }
    */
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:442
    // TODO: Port signature
    // Raven wrote: void CRMManager::ProcessAutomapSymbols ( int count, rmAutomapSymbol_t* symbols )
    // No table row for `rmAutomapSymbol_t *`.
    static func ProcessAutomapSymbols() -> Never {
        // TODO: Port CRMManager::ProcessAutomapSymbols
        portMissing("CRMManager::ProcessAutomapSymbols", source: "oracle/codemp/RMG/RM_Manager.cpp:442")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::Preview
     *	previews the random mission genration information
     *
     * inputs:
     *  from:  origin being previed from
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:365
    func Preview(_ from: JKAShared.vec3_t) {
        // TODO: Port CRMManager::Preview
        portMissing("CRMManager::Preview", source: "oracle/codemp/RMG/RM_Manager.cpp:365")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::IsMissionComplete
     *	Determines whether or not all the arioche objectives have been met
     *
     * inputs:
     *  none
     *
     * return:
     *	true: all objectives have been completed
     *  false: one or more of the objectives has not been met
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:192
    func IsMissionComplete() -> Bool {
        // TODO: Port CRMManager::IsMissionComplete
        portMissing("CRMManager::IsMissionComplete", source: "oracle/codemp/RMG/RM_Manager.cpp:192")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::HasTimeExpired
     *	Determines whether or not the time limit (if one) has expired
     *
     * inputs:
     *  none
     *
     * return:
     *	true: time limit has expired
     *  false: time limit has not expired
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:214
    func HasTimeExpired() -> Bool {
        // TODO: Port CRMManager::HasTimeExpired
        portMissing("CRMManager::HasTimeExpired", source: "oracle/codemp/RMG/RM_Manager.cpp:214")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::CompleteObjective
     *	Marks the given objective as completed
     *
     * inputs:
     *  obj:  objective to set as completed
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:347
    func CompleteObjective(_ obj: CRMObjective?) {
        // TODO: Port CRMManager::CompleteObjective
        portMissing("CRMManager::CompleteObjective", source: "oracle/codemp/RMG/RM_Manager.cpp:347")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::CompleteMission
     *	Does end-of-mission stuff (pause game, end screen, return to menu)
     *    <Description>                                                                             *
     * Input                                                                                        *
     *    <Variable>: <Description>                                                                 *
     * Output / Return                                                                              *
     *    <Variable>: <Description>                                                                 *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:313
    func CompleteMission() {
        // TODO: Port CRMManager::CompleteMission
        portMissing("CRMManager::CompleteMission", source: "oracle/codemp/RMG/RM_Manager.cpp:313")
    }

    /**
    ```
    ************************************************************************************************
     * CRMManager::FailedMission
     *	Does end-of-mission stuff (pause game, end screen, return to menu)
     *    <Description>                                                                             *
     * Input                                                                                        *
     *    TimeExpired: indicates if the reason failed was because of time
     * Output / Return                                                                              *
     *    <Variable>: <Description>                                                                 *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Manager.cpp:329
    func FailedMission(_ TimeExpired: Bool) {
        // TODO: Port CRMManager::FailedMission
        portMissing("CRMManager::FailedMission", source: "oracle/codemp/RMG/RM_Manager.cpp:329")
    }
}
