import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/client/client.h:151
let MAX_AUTOMAP_SYMBOLS = 512 as Int32

/// Raven's random mission manager, the mission, its landscape and terrain, and the automap symbols of a random map.
/// One instance exists, `TheRandomMissionManager`, which the G_RMG_INIT arm of SV_GameSystemCalls makes.
/// Source: oracle/codemp/RMG/RM_Manager.h:9
// AI: Raven's static member `mCurObjective` of RM_Manager.h:57 is the forward of RM_Manager.swift over `EngineWorld`, the HAND_VARS form.
final class CRMManager {
    private var mMission: CRMMission? = nil
    private var mLandScape: CCMLandScape? = nil
    private var mTerrain: CRandomTerrain? = nil
    private var mPreviewTimer: Int32 = 0
    private var mCurPriority: Int32 = 0
    private var mUseTimeLimit: Bool = false

    // AI: Raven holds MAX_AUTOMAP_SYMBOLS records by value. The field is the Slots over the records of the C++ `new`, the form of `svs.snapshotEntities`.
    private var mAutomapSymbols: Slots<RmAutomapSymbol> = Slots<RmAutomapSymbol>.new(count: MAX_AUTOMAP_SYMBOLS)
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
        /*	// No player set then nothing more to do
        	if ( mPlayer )
        	{
        		float accuracy;

        		// Calculate the accuracy
        		accuracy  = (float)mPlayer->client->ps.persistant[PERS_SHOTS_HIT];
        		accuracy /= (float)mPlayer->client->ps.persistant[PERS_SHOTS];
        		accuracy *= 100.0f;

        		// set the accuracy cvar
        		gi.Cvar_Set ( "ar_pl_accuracy", va("%d%%",(int)accuracy) );

        		// Set the # of kills cvar
        		gi.Cvar_Set ( "ar_kills", va("%d", mPlayer->client->ps.persistant[PERS_SCORE] ) );

        		int hours;
        		int mins;
        		int seconds;
        		int tens;
        		int millisec = (level.time - level.startTime);

        		seconds = millisec / 1000;
        		hours = seconds / (60 * 60);
        		seconds -= (hours * 60 * 60);
        		mins = seconds / 60;
        		seconds -= mins * 60;
        		tens = seconds / 10;
        		seconds -= tens * 10;

        		gi.Cvar_Set ( "ar_duration", va("%dhr %dmin %dsec", hours, mins, seconds ) );

        		WpnID wpnID = TheWpnSysMgr().GetFavoriteWeapon ( );
        		gi.Cvar_Set ( "ar_fav_wp", CWeaponSystem::GetWpnName ( wpnID ) );

        		// show difficulty
        		char difficulty[MAX_QPATH];
        		gi.Cvar_VariableStringBuffer("g_skill", difficulty, MAX_QPATH);
        		strupr(difficulty);
        		gi.Cvar_Set ( "ar_diff", va("&GENERIC_%s&",difficulty) );

        		// compute rank
        		float compositeRank = 1;
        		int rankMax = 3;  // max rank less 1
        		float timeRank = mUseTimeLimit ? (1.0f - (mins / (float)mMission->GetTimeLimit())) : 0;
        		float killRank = mPlayer->client->ps.persistant[PERS_SCORE] / (float)GetCharacterManager().GetAllSize();
        		killRank = (killRank > 0) ? killRank : 1.0f;
        		float accuRank = (accuracy > 0) ? accuracy*0.01f : 1.0f;
        		float weapRank = 1.0f - CWeaponSystem::GetRank(wpnID);

        		compositeRank = ((timeRank + killRank + accuRank + weapRank) / 3.0f) * rankMax + 1;

        		if (compositeRank > 4)
        			compositeRank = 4;

        		gi.Cvar_Set ( "ar_rank", va("&RMG_RANK%d&",((int)compositeRank)) );
        	}*/
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
        self.mLandScape = nil
        self.mTerrain = nil
        self.mMission = nil
        self.mCurPriority = 1
        self.mUseTimeLimit = false
        self.mAutomapSymbolCount = 0
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
        Com_Printf("... Shutting down TheRandomMissionManager\n")
        if self.mMission != nil {
            // AI: Raven deletes the mission and then clears `mMission`. The store of nil releases the class, and its deinit runs Raven's destructor.
            self.mMission = nil
        }
        // AI: Raven's array of records goes with the class. The records of the C++ `new` need their `delete`.
        self.mAutomapSymbols.delete()
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
        var instances = CharBuf(MAX_QPATH)
        var mission = CharBuf(MAX_QPATH)
        var course = CharBuf(MAX_QPATH)
        var map = CharBuf(MAX_QPATH)
        var temp = CharBuf(MAX_QPATH)

        Com_Printf("--------- Random Mission Manager ---------\n\n")
        Com_Printf("RMG version : 1.01\n\n")

        if self.mTerrain == nil {
            return false
        }

        // Grab the arioche variables
        Cvar_VariableStringBuffer("rmg_usetimelimit", &temp, MAX_QPATH)
        if Q_stricmp(temp, "yes") == 0 {
            self.mUseTimeLimit = true
        }
        Cvar_VariableStringBuffer("rmg_instances", &instances, MAX_QPATH)
        Cvar_VariableStringBuffer("RMG_mission", &temp, MAX_QPATH)
        Cvar_VariableStringBuffer("rmg_map", &map, MAX_QPATH)
        // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of mission.
        Com_sprintf(&mission, MAX_QPATH, "%s_%s", temp, map)
        Cvar_VariableStringBuffer("rmg_course", &course, MAX_QPATH)

        // dump existing mission, if any
        if self.mMission != nil {
            // AI: Raven deletes the mission and then clears `mMission`. The store of nil releases the class, and its deinit runs Raven's destructor.
            self.mMission = nil
        }

        // Create a new mission file
        self.mMission = CRMMission(self.mTerrain)

        if IsServer {
            // Load the mission using the arioche variables
            if !self.mMission!.Load(String(mission), String(instances), String(course)) {
                return false
            }

            // set the names of the teams
            let parser = CGenericParser2()
            var root: CGPGroup?

            Cvar_VariableStringBuffer("RMG_terrain", &temp, MAX_QPATH)

            // Create the parser for the mission file
            if Com_ParseTextFile(va("ext_data/rmg/%s.teams", temp), parser) {
                root = parser.GetBaseParseGroup().GetSubGroups()
                if 0 == Q_stricmp(root!.GetName(), "teams") {
                    /*
                    SV_SetConfigstring( CS_GAMETYPE_REDTEAM, root->FindPairValue ( "red", "marine" ));
                    SV_SetConfigstring( CS_GAMETYPE_BLUETEAM, root->FindPairValue ( "blue", "thug" ));
                    */
                    //rwwFIXMEFIXME: Do we care about this?
                }
                parser.Clean()
            }
        }

        // Must have a valid landscape before we can spawn the mission
        assert(self.mLandScape != nil)

        Com_Printf("------------------------------------------\n")

        return true
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
        // Spawn the mission
        self.mMission!.Spawn(self.mTerrain, IsServer)

        return true
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
        self.mLandScape = landscape
        self.mTerrain = landscape!.GetRandomTerrain()
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:36
    func SetCurPriority(_ priority: Int32) {
        self.mCurPriority = priority
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:38
    func GetTerrain() -> CRandomTerrain? {
        self.mTerrain
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:39
    func GetLandScape() -> CCMLandScape? {
        self.mLandScape
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:40
    func GetMission() -> CRMMission? {
        self.mMission
    }

    /// Source: oracle/codemp/RMG/RM_Manager.h:41
    func GetCurPriority() -> Int32 {
        self.mCurPriority
    }

    /// Source: oracle/codemp/RMG/RM_Manager.cpp:400
    func AddAutomapSymbol(_ type: Int32, _ origin: JKAShared.vec3_t, _ side: Int32) {
        if type == 0 {
            return
        }

        self.mAutomapSymbols[self.mAutomapSymbolCount].mType = type
        self.mAutomapSymbols[self.mAutomapSymbolCount].mSide = side
        self.mAutomapSymbols[self.mAutomapSymbolCount].mOrigin = origin
        self.mAutomapSymbolCount += 1
    }

    /// Source: oracle/codemp/RMG/RM_Manager.cpp:413
    func GetAutomapSymbolCount() -> Int32 {
        return self.mAutomapSymbolCount
    }

    /// Source: oracle/codemp/RMG/RM_Manager.cpp:418
    func GetAutomapSymbol(_ index: Int32) -> RmAutomapSymbol? {
        return self.mAutomapSymbols[index]
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
        // Its body and its two callers at RM_Mission.cpp:1508 and :1512 stand under `#ifndef DEDICATED`, so the function is dead in the dedicated build.
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
        // Dont bother if we havent reached our timer yet
        /*	if ( level.time < mPreviewTimer )
        	{
        		return;
        	}

        	// Let the mission do all the previewing
        	mMission->Preview ( from );

        	// Another second
        	mPreviewTimer = level.time + 1000;*/
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
        if nil == self.mMission!.GetCurrentObjective() {
            return true
        }

        return false
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
        /*	if (mMission->GetTimeLimit() == 0 || !mUseTimeLimit)
        	{	// no time limit set
        		return false;
        	}

        	if (mMission->GetTimeLimit() * 1000 * 60 > level.time - level.startTime)
        	{	// we are still under our time limit
        		return false;
        	}

        	// over our time limit!
        	return true;*/

        return false
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
        assert(obj != nil)

        self.mMission!.CompleteObjective(obj)
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
        self.UpdateStatisticCvars()

        self.mMission!.CompleteMission()
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
        self.UpdateStatisticCvars()

        self.mMission!.FailedMission(TimeExpired)
    }
}
