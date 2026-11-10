import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_interface.cpp:39
var botlibglobals: BotlibGlobals { world.storage.botlibglobals }

/// Source: oracle/codemp/botlib/be_interface.cpp:41
var be_botlib_export: BotlibExport { world.storage.be_botlib_export }

/// Source: oracle/codemp/botlib/be_interface.cpp:42
var botimport: BotlibImport { world.storage.botimport }

/// Source: oracle/codemp/botlib/be_interface.cpp:44
var bot_developer: Int32 {
    get { world.variables.bot_developer }
    set { world.variables.bot_developer = newValue }
}

/// Source: oracle/codemp/botlib/be_interface.cpp:46
var botlibsetup: Int32 {
    get { world.variables.botlibsetup }
    set { world.variables.botlibsetup = newValue }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:60
func Sys_MilliSeconds() -> Int32 {
    // AI: Raven returns the 32-bit `long` quotient as his `int`. The host quotient is 64 bits, and the return keeps its low 32 bits.
    return Int32(truncatingIfNeeded: SysBackend.clock() * 1000 / SysBackend.CLOCKS_PER_SEC)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:70
func ValidClientNumber(_ num: Int32, _ str: inout JKAShared.CharBuf) -> Bool {
    if num < 0 || num > botlibglobals.maxclients {
        //weird: the disabled stuff results in a crash
        botimport.runPrint(PRT_ERROR, "%s: invalid client number %d, [0, %d]\n", str, num, botlibglobals.maxclients)
        return false
    } //end if
    return true
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:87
func ValidEntityNumber(_ num: Int32, _ str: inout JKAShared.CharBuf) -> Bool {
    if num < 0 || num > botlibglobals.maxentities {
        botimport.runPrint(PRT_ERROR, "%s: invalid entity number %d, [0, %d]\n", str, num, botlibglobals.maxentities)
        return false
    } //end if
    return true
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:103
func BotLibSetup(_ str: inout JKAShared.CharBuf) -> Bool {
    if botlibglobals.botlibsetup == 0 {
        botimport.runPrint(PRT_ERROR, "%s: bot library used before being setup\n", str)
        return false
    } //end if
    return true
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:119
func Export_BotLibSetup() -> Int32 {
    var errnum: Int32

    bot_developer = Int32(LibVarGetValue("bot_developer"))
    botlibglobals.clear() // bk001207 - init
    //initialize byte swapping (litte endian etc.)
//	Swap_Init();
    var filename = CharBuf("botlib.log")
    Log_Open(&filename)
    //
//	botimport.Print(PRT_MESSAGE, "------- BotLib Initialization -------\n");
    //
    botlibglobals.maxclients = Int32(LibVarValue("maxclients", "128"))
    botlibglobals.maxentities = Int32(LibVarValue("maxentities", "1024"))

    errnum = AAS_Setup()			//be_aas_main.c
    if errnum != BLERR_NOERROR { return errnum }
    errnum = EA_Setup()			//be_ea.c
    if errnum != BLERR_NOERROR { return errnum }
    /*
	errnum = BotSetupWeaponAI();	//be_ai_weap.c
	if (errnum != BLERR_NOERROR)return errnum;
	errnum = BotSetupGoalAI();		//be_ai_goal.c
	if (errnum != BLERR_NOERROR) return errnum;
	errnum = BotSetupChatAI();		//be_ai_chat.c
	if (errnum != BLERR_NOERROR) return errnum;
	errnum = BotSetupMoveAI();		//be_ai_move.c
	if (errnum != BLERR_NOERROR) return errnum;
	*/
    botlibsetup = 1
    botlibglobals.botlibsetup = 1

    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:159
func Export_BotLibShutdown() -> Int32 {
    var str = CharBuf("BotLibShutdown")
    if !BotLibSetup(&str) { return BLERR_LIBRARYNOTSETUP }
    //DumpFileCRCs();
    //
    BotShutdownChatAI()		//be_ai_chat.c
    BotShutdownMoveAI()		//be_ai_move.c
    BotShutdownGoalAI()		//be_ai_goal.c
    BotShutdownWeaponAI()		//be_ai_weap.c
    BotShutdownWeights()		//be_ai_weight.c
    BotShutdownCharacters()	//be_ai_char.c
    //shud down aas
    AAS_Shutdown()
    //shut down bot elemantary actions
    EA_Shutdown()
    //free all libvars
    LibVarDeAllocAll()
    //remove all global defines from the pre compiler
    PC_RemoveAllGlobalDefines()

    //dump all allocated memory
//	DumpMemory();
    //shut down library log file
    Log_Shutdown()
    //
    botlibsetup = 0
    botlibglobals.botlibsetup = 0
    // print any files still open
    PC_CheckOpenSourceHandles()
    //
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:202
func Export_BotLibVarSet(_ var_name: String, _ value: String) -> Int32 {
    LibVarSet(var_name, value)
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:213
func Export_BotLibVarGet(_ var_name: String, _ value: inout JKAShared.CharBuf, _ size: Int32) -> Int32 {
    let varvalue: String

    varvalue = LibVarGetString(var_name)
    strncpy(&value, varvalue, size - 1)
    value[size - 1] = 0
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:228
func Export_BotLibStartFrame(_ time: Float) -> Int32 {
    var str = CharBuf("BotStartFrame")
    if !BotLibSetup(&str) { return BLERR_LIBRARYNOTSETUP }
    return AAS_StartFrame(time)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:239
func Export_BotLibLoadMap(_ mapname: String) -> Int32 {
    var errnum: Int32

    var str = CharBuf("BotLoadMap")
    if !BotLibSetup(&str) { return BLERR_LIBRARYNOTSETUP }
    //
    botimport.runPrint(PRT_MESSAGE, "------------ Map Loading ------------\n")
    //startup AAS for the current map, model and sound index
    errnum = AAS_LoadMap(mapname)
    if errnum != BLERR_NOERROR { return errnum }
    //initialize the items in the level
    BotInitLevelItems()		//be_ai_goal.h
    BotSetBrushModelTypes()	//be_ai_move.h
    //
    botimport.runPrint(PRT_MESSAGE, "-------------------------------------\n")
    //
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_interface.cpp:269
func Export_BotLibUpdateEntity(_ ent: Int32, _ state: BotEntitystate) -> Int32 {
    var str = CharBuf("BotUpdateEntity")
    if !BotLibSetup(&str) { return BLERR_LIBRARYNOTSETUP }
    if !ValidEntityNumber(ent, &str) { return BLERR_INVALIDENTITYNUMBER }

    return AAS_UpdateEntity(ent, state)
}

/// Source: oracle/codemp/botlib/be_interface.cpp:302
func BotExportTest(_ parm0: Int32, _ parm1: String, _ parm2: JKAShared.vec3_t, _ parm3: JKAShared.vec3_t) -> Int32 {

//	return AAS_PointLight(parm2, NULL, NULL, NULL);

    return 0
}

/**
```
============
Init_AAS_Export
============
```
*/
/// Source: oracle/codemp/botlib/be_interface.cpp:639
private func Init_AAS_Export(_ aas: Aas_export) {
    //--------------------------------------------
    // be_aas_entity.c
    //--------------------------------------------
    aas.AAS_EntityInfo = Aas_exportThunks.AAS_EntityInfo
    //--------------------------------------------
    // be_aas_main.c
    //--------------------------------------------
    aas.AAS_Initialized = Aas_exportThunks.AAS_Initialized
    aas.AAS_PresenceTypeBoundingBox = Aas_exportThunks.AAS_PresenceTypeBoundingBox
    aas.AAS_Time = Aas_exportThunks.AAS_Time
    //--------------------------------------------
    // be_aas_sample.c
    //--------------------------------------------
    aas.AAS_PointAreaNum = Aas_exportThunks.AAS_PointAreaNum
    aas.AAS_PointReachabilityAreaIndex = Aas_exportThunks.AAS_PointReachabilityAreaIndex
    aas.AAS_TraceAreas = Aas_exportThunks.AAS_TraceAreas
    aas.AAS_BBoxAreas = Aas_exportThunks.AAS_BBoxAreas
    aas.AAS_AreaInfo = Aas_exportThunks.AAS_AreaInfo
    //--------------------------------------------
    // be_aas_bspq3.c
    //--------------------------------------------
    aas.AAS_PointContents = Aas_exportThunks.AAS_PointContents
    aas.AAS_NextBSPEntity = Aas_exportThunks.AAS_NextBSPEntity
    aas.AAS_ValueForBSPEpairKey = Aas_exportThunks.AAS_ValueForBSPEpairKey
    aas.AAS_VectorForBSPEpairKey = Aas_exportThunks.AAS_VectorForBSPEpairKey
    aas.AAS_FloatForBSPEpairKey = Aas_exportThunks.AAS_FloatForBSPEpairKey
    aas.AAS_IntForBSPEpairKey = Aas_exportThunks.AAS_IntForBSPEpairKey
    //--------------------------------------------
    // be_aas_reach.c
    //--------------------------------------------
    aas.AAS_AreaReachability = Aas_exportThunks.AAS_AreaReachability
    //--------------------------------------------
    // be_aas_route.c
    //--------------------------------------------
    aas.AAS_AreaTravelTimeToGoalArea = Aas_exportThunks.AAS_AreaTravelTimeToGoalArea
    aas.AAS_EnableRoutingArea = Aas_exportThunks.AAS_EnableRoutingArea
    aas.AAS_PredictRoute = Aas_exportThunks.AAS_PredictRoute
    //--------------------------------------------
    // be_aas_altroute.c
    //--------------------------------------------
    aas.AAS_AlternativeRouteGoals = Aas_exportThunks.AAS_AlternativeRouteGoals
    //--------------------------------------------
    // be_aas_move.c
    //--------------------------------------------
    aas.AAS_Swimming = Aas_exportThunks.AAS_Swimming
    aas.AAS_PredictClientMovement = Aas_exportThunks.AAS_PredictClientMovement
}

/**
```
============
Init_EA_Export
============
```
*/
/// Source: oracle/codemp/botlib/be_interface.cpp:694
private func Init_EA_Export(_ ea: Ea_export) {
    //ClientCommand elementary actions
    ea.EA_Command = Ea_exportThunks.EA_Command
    ea.EA_Say = Ea_exportThunks.EA_Say
    ea.EA_SayTeam = Ea_exportThunks.EA_SayTeam

    ea.EA_Action = Ea_exportThunks.EA_Action
    ea.EA_Gesture = Ea_exportThunks.EA_Gesture
    ea.EA_Talk = Ea_exportThunks.EA_Talk
    ea.EA_Attack = Ea_exportThunks.EA_Attack
    ea.EA_Alt_Attack = Ea_exportThunks.EA_Alt_Attack
    ea.EA_ForcePower = Ea_exportThunks.EA_ForcePower
    ea.EA_Use = Ea_exportThunks.EA_Use
    ea.EA_Respawn = Ea_exportThunks.EA_Respawn
    ea.EA_Crouch = Ea_exportThunks.EA_Crouch
    ea.EA_MoveUp = Ea_exportThunks.EA_MoveUp
    ea.EA_MoveDown = Ea_exportThunks.EA_MoveDown
    ea.EA_MoveForward = Ea_exportThunks.EA_MoveForward
    ea.EA_MoveBack = Ea_exportThunks.EA_MoveBack
    ea.EA_MoveLeft = Ea_exportThunks.EA_MoveLeft
    ea.EA_MoveRight = Ea_exportThunks.EA_MoveRight

    ea.EA_SelectWeapon = Ea_exportThunks.EA_SelectWeapon
    ea.EA_Jump = Ea_exportThunks.EA_Jump
    ea.EA_DelayedJump = Ea_exportThunks.EA_DelayedJump
    ea.EA_Move = Ea_exportThunks.EA_Move
    ea.EA_View = Ea_exportThunks.EA_View
    ea.EA_GetInput = Ea_exportThunks.EA_GetInput
    ea.EA_EndRegular = Ea_exportThunks.EA_EndRegular
    ea.EA_ResetInput = Ea_exportThunks.EA_ResetInput
}

/**
```
============
Init_AI_Export
============
```
*/
/// Source: oracle/codemp/botlib/be_interface.cpp:732
private func Init_AI_Export(_ ai: Ai_export) {
    //-----------------------------------
    // be_ai_char.h
    //-----------------------------------
    ai.BotLoadCharacter = Ai_exportThunks.BotLoadCharacter
    ai.BotFreeCharacter = Ai_exportThunks.BotFreeCharacter
    ai.Characteristic_Float = Ai_exportThunks.Characteristic_Float
    ai.Characteristic_BFloat = Ai_exportThunks.Characteristic_BFloat
    ai.Characteristic_Integer = Ai_exportThunks.Characteristic_Integer
    ai.Characteristic_BInteger = Ai_exportThunks.Characteristic_BInteger
    ai.Characteristic_String = Ai_exportThunks.Characteristic_String
    //-----------------------------------
    // be_ai_chat.h
    //-----------------------------------
    ai.BotAllocChatState = Ai_exportThunks.BotAllocChatState
    ai.BotFreeChatState = Ai_exportThunks.BotFreeChatState
    ai.BotQueueConsoleMessage = Ai_exportThunks.BotQueueConsoleMessage
    ai.BotRemoveConsoleMessage = Ai_exportThunks.BotRemoveConsoleMessage
    ai.BotNextConsoleMessage = Ai_exportThunks.BotNextConsoleMessage
    ai.BotNumConsoleMessages = Ai_exportThunks.BotNumConsoleMessages
    ai.BotInitialChat = Ai_exportThunks.BotInitialChat
    ai.BotNumInitialChats = Ai_exportThunks.BotNumInitialChats
    ai.BotReplyChat = Ai_exportThunks.BotReplyChat
    ai.BotChatLength = Ai_exportThunks.BotChatLength
    ai.BotEnterChat = Ai_exportThunks.BotEnterChat
    ai.BotGetChatMessage = Ai_exportThunks.BotGetChatMessage
    ai.StringContains = Ai_exportThunks.StringContains
    ai.BotFindMatch = Ai_exportThunks.BotFindMatch
    ai.BotMatchVariable = Ai_exportThunks.BotMatchVariable
    ai.UnifyWhiteSpaces = Ai_exportThunks.UnifyWhiteSpaces
    ai.BotReplaceSynonyms = Ai_exportThunks.BotReplaceSynonyms
    ai.BotLoadChatFile = Ai_exportThunks.BotLoadChatFile
    ai.BotSetChatGender = Ai_exportThunks.BotSetChatGender
    ai.BotSetChatName = Ai_exportThunks.BotSetChatName
    //-----------------------------------
    // be_ai_goal.h
    //-----------------------------------
    ai.BotResetGoalState = Ai_exportThunks.BotResetGoalState
    ai.BotResetAvoidGoals = Ai_exportThunks.BotResetAvoidGoals
    ai.BotRemoveFromAvoidGoals = Ai_exportThunks.BotRemoveFromAvoidGoals
    ai.BotPushGoal = Ai_exportThunks.BotPushGoal
    ai.BotPopGoal = Ai_exportThunks.BotPopGoal
    ai.BotEmptyGoalStack = Ai_exportThunks.BotEmptyGoalStack
    ai.BotDumpAvoidGoals = Ai_exportThunks.BotDumpAvoidGoals
    ai.BotDumpGoalStack = Ai_exportThunks.BotDumpGoalStack
    ai.BotGoalName = Ai_exportThunks.BotGoalName
    ai.BotGetTopGoal = Ai_exportThunks.BotGetTopGoal
    ai.BotGetSecondGoal = Ai_exportThunks.BotGetSecondGoal
    ai.BotChooseLTGItem = Ai_exportThunks.BotChooseLTGItem
    ai.BotChooseNBGItem = Ai_exportThunks.BotChooseNBGItem
    ai.BotTouchingGoal = Ai_exportThunks.BotTouchingGoal
    ai.BotItemGoalInVisButNotVisible = Ai_exportThunks.BotItemGoalInVisButNotVisible
    ai.BotGetLevelItemGoal = Ai_exportThunks.BotGetLevelItemGoal
    ai.BotGetNextCampSpotGoal = Ai_exportThunks.BotGetNextCampSpotGoal
    ai.BotGetMapLocationGoal = Ai_exportThunks.BotGetMapLocationGoal
    ai.BotAvoidGoalTime = Ai_exportThunks.BotAvoidGoalTime
    ai.BotSetAvoidGoalTime = Ai_exportThunks.BotSetAvoidGoalTime
    ai.BotInitLevelItems = Ai_exportThunks.BotInitLevelItems
    ai.BotUpdateEntityItems = Ai_exportThunks.BotUpdateEntityItems
    ai.BotLoadItemWeights = Ai_exportThunks.BotLoadItemWeights
    ai.BotFreeItemWeights = Ai_exportThunks.BotFreeItemWeights
    ai.BotInterbreedGoalFuzzyLogic = Ai_exportThunks.BotInterbreedGoalFuzzyLogic
    ai.BotSaveGoalFuzzyLogic = Ai_exportThunks.BotSaveGoalFuzzyLogic
    ai.BotMutateGoalFuzzyLogic = Ai_exportThunks.BotMutateGoalFuzzyLogic
    ai.BotAllocGoalState = Ai_exportThunks.BotAllocGoalState
    ai.BotFreeGoalState = Ai_exportThunks.BotFreeGoalState
    //-----------------------------------
    // be_ai_move.h
    //-----------------------------------
    ai.BotResetMoveState = Ai_exportThunks.BotResetMoveState
    ai.BotMoveToGoal = Ai_exportThunks.BotMoveToGoal
    ai.BotMoveInDirection = Ai_exportThunks.BotMoveInDirection
    ai.BotResetAvoidReach = Ai_exportThunks.BotResetAvoidReach
    ai.BotResetLastAvoidReach = Ai_exportThunks.BotResetLastAvoidReach
    ai.BotReachabilityArea = Ai_exportThunks.BotReachabilityArea
    ai.BotMovementViewTarget = Ai_exportThunks.BotMovementViewTarget
    ai.BotPredictVisiblePosition = Ai_exportThunks.BotPredictVisiblePosition
    ai.BotAllocMoveState = Ai_exportThunks.BotAllocMoveState
    ai.BotFreeMoveState = Ai_exportThunks.BotFreeMoveState
    ai.BotInitMoveState = Ai_exportThunks.BotInitMoveState
    ai.BotAddAvoidSpot = Ai_exportThunks.BotAddAvoidSpot
    //-----------------------------------
    // be_ai_weap.h
    //-----------------------------------
    ai.BotChooseBestFightWeapon = Ai_exportThunks.BotChooseBestFightWeapon
    ai.BotGetWeaponInfo = Ai_exportThunks.BotGetWeaponInfo
    ai.BotLoadWeaponWeights = Ai_exportThunks.BotLoadWeaponWeights
    ai.BotAllocWeaponState = Ai_exportThunks.BotAllocWeaponState
    ai.BotFreeWeaponState = Ai_exportThunks.BotFreeWeaponState
    ai.BotResetWeaponState = Ai_exportThunks.BotResetWeaponState
    //-----------------------------------
    // be_ai_gen.h
    //-----------------------------------
    ai.GeneticParentsAndChildSelection = Ai_exportThunks.GeneticParentsAndChildSelection
}

/**
```
============
GetBotLibAPI
============
```
*/
/// Source: oracle/codemp/botlib/be_interface.cpp:834
func GetBotLibAPI(_ apiVersion: Int32, _ `import`: BotlibImport) -> BotlibExport? {
    // Raven asserts `import` here, and a view parameter is never NULL. // bk001129 - this wasn't set for base/
    botimport.copy(from: `import`)
    assert(botimport.Print != nil)   // bk001129 - pars pro toto

    be_botlib_export.clear()

    if apiVersion != BOTLIB_API_VERSION {
        botimport.runPrint(PRT_ERROR, "Mismatched BOTLIB_API_VERSION: expected %i, got %i\n", BOTLIB_API_VERSION, apiVersion)
        return nil
    }

    Init_AAS_Export(be_botlib_export.aas)
    Init_EA_Export(be_botlib_export.ea)
    Init_AI_Export(be_botlib_export.ai)

    be_botlib_export.BotLibSetup = BotlibExportThunks.Export_BotLibSetup
    be_botlib_export.BotLibShutdown = BotlibExportThunks.Export_BotLibShutdown
    be_botlib_export.BotLibVarSet = BotlibExportThunks.Export_BotLibVarSet
    be_botlib_export.BotLibVarGet = BotlibExportThunks.Export_BotLibVarGet

    be_botlib_export.PC_AddGlobalDefine = BotlibExportThunks.PC_AddGlobalDefine
    be_botlib_export.PC_LoadSourceHandle = BotlibExportThunks.PC_LoadSourceHandle
    be_botlib_export.PC_FreeSourceHandle = BotlibExportThunks.PC_FreeSourceHandle
    be_botlib_export.PC_ReadTokenHandle = BotlibExportThunks.PC_ReadTokenHandle
    be_botlib_export.PC_SourceFileAndLine = BotlibExportThunks.PC_SourceFileAndLine
    be_botlib_export.PC_LoadGlobalDefines = BotlibExportThunks.PC_LoadGlobalDefines
    be_botlib_export.PC_RemoveAllGlobalDefines = BotlibExportThunks.PC_RemoveAllGlobalDefines

    be_botlib_export.BotLibStartFrame = BotlibExportThunks.Export_BotLibStartFrame
    be_botlib_export.BotLibLoadMap = BotlibExportThunks.Export_BotLibLoadMap
    be_botlib_export.BotLibUpdateEntity = BotlibExportThunks.Export_BotLibUpdateEntity
    be_botlib_export.Test = BotlibExportThunks.BotExportTest

    return be_botlib_export
}

/// One static per function this file stores in a `Aas_export` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum Aas_exportThunks {
    /// Source: oracle/codemp/botlib/be_aas_routealt.cpp:82
    static let AAS_AlternativeRouteGoals: Aas_exportAAS_AlternativeRouteGoals = { JKAMP_DedLogic.AAS_AlternativeRouteGoals(vector(at: $0!), $1, vector(at: $2!), $3, $4, Slots(views: $5!, count: Int($6)), $6, $7) }

    /// Source: oracle/codemp/botlib/be_aas_sample.cpp:1346
    static let AAS_AreaInfo: Aas_exportAAS_AreaInfo = { JKAMP_DedLogic.AAS_AreaInfo($0, AasAreainfo(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_aas_reach.cpp:506
    static let AAS_AreaReachability: Aas_exportAAS_AreaReachability = { JKAMP_DedLogic.AAS_AreaReachability($0) }

    /// Source: oracle/codemp/botlib/be_aas_route.cpp:1750
    static let AAS_AreaTravelTimeToGoalArea: Aas_exportAAS_AreaTravelTimeToGoalArea = { JKAMP_DedLogic.AAS_AreaTravelTimeToGoalArea($0, $1.map { vector(at: $0) }, $2, $3) }

    /// Source: oracle/codemp/botlib/be_aas_sample.cpp:1323
    static let AAS_BBoxAreas: Aas_exportAAS_BBoxAreas = { JKAMP_DedLogic.AAS_BBoxAreas(vector(at: $0!), vector(at: $1!), Slots<Int32>(scalars: $2!, count: Int($3)), $3) }

    /// Source: oracle/codemp/botlib/be_aas_route.cpp:291
    static let AAS_EnableRoutingArea: Aas_exportAAS_EnableRoutingArea = { JKAMP_DedLogic.AAS_EnableRoutingArea($0, $1) }

    /// Source: oracle/codemp/botlib/be_aas_entity.cpp:154
    static let AAS_EntityInfo: Aas_exportAAS_EntityInfo = { JKAMP_DedLogic.AAS_EntityInfo($0, AasEntityinfo(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:306
    static let AAS_FloatForBSPEpairKey: Aas_exportAAS_FloatForBSPEpairKey = { ent, key, value in
        let slots = Slots<Float>(scalars: value!, count: 1)
        var number = slots[0]
        let found = JKAMP_DedLogic.AAS_FloatForBSPEpairKey(ent, text(at: key!), &number)
        slots[0] = number
        return found
    }

    /// Source: oracle/codemp/botlib/be_aas_main.cpp:156
    static let AAS_Initialized: Aas_exportAAS_Initialized = { JKAMP_DedLogic.AAS_Initialized() }

    /// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:321
    static let AAS_IntForBSPEpairKey: Aas_exportAAS_IntForBSPEpairKey = { ent, key, value in
        let slots = Slots<Int32>(scalars: value!, count: 1)
        var number = slots[0]
        let found = JKAMP_DedLogic.AAS_IntForBSPEpairKey(ent, text(at: key!), &number)
        slots[0] = number
        return found
    }

    /// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:235
    static let AAS_NextBSPEntity: Aas_exportAAS_NextBSPEntity = { JKAMP_DedLogic.AAS_NextBSPEntity($0) }

    /// Source: oracle/codemp/botlib/be_aas_sample.cpp:196
    static let AAS_PointAreaNum: Aas_exportAAS_PointAreaNum = { JKAMP_DedLogic.AAS_PointAreaNum(vector(at: $0!)) }

    /// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:143
    static let AAS_PointContents: Aas_exportAAS_PointContents = { JKAMP_DedLogic.AAS_PointContents(vector(at: $0!)) }

    /// Source: oracle/codemp/botlib/be_aas_sample.cpp:249
    static let AAS_PointReachabilityAreaIndex: Aas_exportAAS_PointReachabilityAreaIndex = { JKAMP_DedLogic.AAS_PointReachabilityAreaIndex(vector(at: $0!)) }

    /// Source: oracle/codemp/botlib/be_aas_move.cpp:977
    static let AAS_PredictClientMovement: Aas_exportAAS_PredictClientMovement = { JKAMP_DedLogic.AAS_PredictClientMovement(AasClientmove(handle: $0!), $1, vector(at: $2!), $3, $4, vector(at: $5!), vector(at: $6!), $7, $8, $9, $10, $11, $12) }

    /// Source: oracle/codemp/botlib/be_aas_route.cpp:1783
    static let AAS_PredictRoute: Aas_exportAAS_PredictRoute = { JKAMP_DedLogic.AAS_PredictRoute(AasPredictroute(handle: $0!), $1, vector(at: $2!), $3, $4, $5, $6, $7, $8, $9, $10) }

    /// Source: oracle/codemp/botlib/be_aas_sample.cpp:56
    static let AAS_PresenceTypeBoundingBox: Aas_exportAAS_PresenceTypeBoundingBox = { presencetype, mins, maxs in
        var minsValue = vector(at: mins!)
        var maxsValue = vector(at: maxs!)
        JKAMP_DedLogic.AAS_PresenceTypeBoundingBox(presencetype, &minsValue, &maxsValue)
        let minsSlots = Slots<Float>(scalars: mins!, count: 3)
        minsSlots[0] = minsValue[0]
        minsSlots[1] = minsValue[1]
        minsSlots[2] = minsValue[2]
        let maxsSlots = Slots<Float>(scalars: maxs!, count: 3)
        maxsSlots[0] = maxsValue[0]
        maxsSlots[1] = maxsValue[1]
        maxsSlots[2] = maxsValue[2]
    }

    /// Source: oracle/codemp/botlib/be_aas_move.cpp:198
    static let AAS_Swimming: Aas_exportAAS_Swimming = { JKAMP_DedLogic.AAS_Swimming(vector(at: $0!)) }

    /// Source: oracle/codemp/botlib/be_aas_main.cpp:267
    static let AAS_Time: Aas_exportAAS_Time = { JKAMP_DedLogic.AAS_Time() }

    /// Source: oracle/codemp/botlib/be_aas_sample.cpp:709
    static let AAS_TraceAreas: Aas_exportAAS_TraceAreas = { start, end, areas, points, maxareas in
        JKAMP_DedLogic.AAS_TraceAreas(
            vector(at: start!),
            vector(at: end!),
            Slots<Int32>(scalars: areas!, count: Int(maxareas)),
            points.map { Slots<vec3_t>(vectors: $0, count: Int(maxareas)) },
            maxareas
        )
    }

    /// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:262
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let AAS_ValueForBSPEpairKey: Aas_exportAAS_ValueForBSPEpairKey = { _, _, _, _ in portMissing("AAS_ValueForBSPEpairKey", source: "oracle/codemp/botlib/be_aas_bspq3.cpp:262") }

    /// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:285
    static let AAS_VectorForBSPEpairKey: Aas_exportAAS_VectorForBSPEpairKey = { ent, key, v in
        var value = vector(at: v!)
        let found = JKAMP_DedLogic.AAS_VectorForBSPEpairKey(ent, text(at: key!), &value)
        let vSlots = Slots<Float>(scalars: v!, count: 3)
        vSlots[0] = value[0]
        vSlots[1] = value[1]
        vSlots[2] = value[2]
        return found
    }
}

/// One static per function this file stores in a `Ai_export` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum Ai_exportThunks {
    /// Source: oracle/codemp/botlib/be_ai_move.cpp:702
    static let BotAddAvoidSpot: Ai_exportBotAddAvoidSpot = { JKAMP_DedLogic.BotAddAvoidSpot($0, vector(at: $1!), $2, $3) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2878
    static let BotAllocChatState: Ai_exportBotAllocChatState = { JKAMP_DedLogic.BotAllocChatState() }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1715
    static let BotAllocGoalState: Ai_exportBotAllocGoalState = { JKAMP_DedLogic.BotAllocGoalState($0) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:110
    static let BotAllocMoveState: Ai_exportBotAllocMoveState = { JKAMP_DedLogic.BotAllocMoveState() }

    /// Source: oracle/codemp/botlib/be_ai_weap.cpp:445
    static let BotAllocWeaponState: Ai_exportBotAllocWeaponState = { JKAMP_DedLogic.BotAllocWeaponState() }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:781
    static let BotAvoidGoalTime: Ai_exportBotAvoidGoalTime = { JKAMP_DedLogic.BotAvoidGoalTime($0, $1) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2754
    static let BotChatLength: Ai_exportBotChatLength = { JKAMP_DedLogic.BotChatLength($0) }

    /// Source: oracle/codemp/botlib/be_ai_weap.cpp:387
    // Port-note: Row X2. The `int *inventory` has no count beside it, so the thunk has no count for a Slots of the list.
    static let BotChooseBestFightWeapon: Ai_exportBotChooseBestFightWeapon = { _, _ in portMissing("BotChooseBestFightWeapon", source: "oracle/codemp/botlib/be_ai_weap.cpp:387") }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1268
    // Port-note: Row X2. The `int *inventory` has no count beside it, so the thunk has no count for a Slots of the list.
    static let BotChooseLTGItem: Ai_exportBotChooseLTGItem = { _, _, _, _ in portMissing("BotChooseLTGItem", source: "oracle/codemp/botlib/be_ai_goal.cpp:1268") }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1435
    // Port-note: Row X2. The `int *inventory` has no count beside it, so the thunk has no count for a Slots of the list.
    static let BotChooseNBGItem: Ai_exportBotChooseNBGItem = { _, _, _, _, _, _ in portMissing("BotChooseNBGItem", source: "oracle/codemp/botlib/be_ai_goal.cpp:1435") }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:702
    static let BotDumpAvoidGoals: Ai_exportBotDumpAvoidGoals = { JKAMP_DedLogic.BotDumpAvoidGoals($0) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1166
    static let BotDumpGoalStack: Ai_exportBotDumpGoalStack = { JKAMP_DedLogic.BotDumpGoalStack($0) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1221
    static let BotEmptyGoalStack: Ai_exportBotEmptyGoalStack = { JKAMP_DedLogic.BotEmptyGoalStack($0) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2768
    static let BotEnterChat: Ai_exportBotEnterChat = { JKAMP_DedLogic.BotEnterChat($0, $1, $2) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:1417
    // AI: Raven's `unsigned long context` is 32 bits in WinDed. The thunk keeps the low 32 bits of the host's `unsigned long`.
    static let BotFindMatch: Ai_exportBotFindMatch = { JKAMP_DedLogic.BotFindMatch(text(at: $0!), BotMatch(handle: $1!), UInt32(truncatingIfNeeded: $2)) }

    /// Source: oracle/codemp/botlib/be_ai_char.cpp:152
    static let BotFreeCharacter: Ai_exportBotFreeCharacter = { JKAMP_DedLogic.BotFreeCharacter($0) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2898
    static let BotFreeChatState: Ai_exportBotFreeChatState = { JKAMP_DedLogic.BotFreeChatState($0) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1736
    static let BotFreeGoalState: Ai_exportBotFreeGoalState = { JKAMP_DedLogic.BotFreeGoalState($0) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1700
    static let BotFreeItemWeights: Ai_exportBotFreeItemWeights = { JKAMP_DedLogic.BotFreeItemWeights($0) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:130
    static let BotFreeMoveState: Ai_exportBotFreeMoveState = { JKAMP_DedLogic.BotFreeMoveState($0) }

    /// Source: oracle/codemp/botlib/be_ai_weap.cpp:465
    static let BotFreeWeaponState: Ai_exportBotFreeWeaponState = { JKAMP_DedLogic.BotFreeWeaponState($0) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2804
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotGetChatMessage: Ai_exportBotGetChatMessage = { _, _, _ in portMissing("BotGetChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:2804") }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:843
    static let BotGetLevelItemGoal: Ai_exportBotGetLevelItemGoal = { JKAMP_DedLogic.BotGetLevelItemGoal($0, text(at: $1!), BotGoal(handle: $2!)) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:896
    static let BotGetMapLocationGoal: Ai_exportBotGetMapLocationGoal = { JKAMP_DedLogic.BotGetMapLocationGoal(text(at: $0!), BotGoal(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:921
    static let BotGetNextCampSpotGoal: Ai_exportBotGetNextCampSpotGoal = { JKAMP_DedLogic.BotGetNextCampSpotGoal($0, BotGoal(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1251
    static let BotGetSecondGoal: Ai_exportBotGetSecondGoal = { JKAMP_DedLogic.BotGetSecondGoal($0, BotGoal(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1235
    static let BotGetTopGoal: Ai_exportBotGetTopGoal = { JKAMP_DedLogic.BotGetTopGoal($0, BotGoal(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_weap.cpp:371
    static let BotGetWeaponInfo: Ai_exportBotGetWeaponInfo = { JKAMP_DedLogic.BotGetWeaponInfo($0, $1, Weaponinfo(handle: $2!)) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:663
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotGoalName: Ai_exportBotGoalName = { _, _, _ in portMissing("BotGoalName", source: "oracle/codemp/botlib/be_ai_goal.cpp:663") }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:521
    static let BotInitLevelItems: Ai_exportBotInitLevelItems = { JKAMP_DedLogic.BotInitLevelItems() }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:171
    static let BotInitMoveState: Ai_exportBotInitMoveState = { JKAMP_DedLogic.BotInitMoveState($0, BotInitmove(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2475
    static let BotInitialChat: Ai_exportBotInitialChat = { JKAMP_DedLogic.BotInitialChat($0, text(at: $1!), $2, $3.map(text(at:)), $4.map(text(at:)), $5.map(text(at:)), $6.map(text(at:)), $7.map(text(at:)), $8.map(text(at:)), $9.map(text(at:)), $10.map(text(at:))) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:206
    static let BotInterbreedGoalFuzzyLogic: Ai_exportBotInterbreedGoalFuzzyLogic = { JKAMP_DedLogic.BotInterbreedGoalFuzzyLogic($0, $1, $2) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1621
    static let BotItemGoalInVisButNotVisible: Ai_exportBotItemGoalInVisButNotVisible = { JKAMP_DedLogic.BotItemGoalInVisButNotVisible($0, vector(at: $1!), vector(at: $2!), BotGoal(handle: $3!)) }

    /// Source: oracle/codemp/botlib/be_ai_char.cpp:551
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotLoadCharacter: Ai_exportBotLoadCharacter = { _, _ in portMissing("BotLoadCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:551") }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2183
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotLoadChatFile: Ai_exportBotLoadChatFile = { _, _, _ in portMissing("BotLoadChatFile", source: "oracle/codemp/botlib/be_ai_chat.cpp:2183") }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1674
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotLoadItemWeights: Ai_exportBotLoadItemWeights = { _, _ in portMissing("BotLoadItemWeights", source: "oracle/codemp/botlib/be_ai_goal.cpp:1674") }

    /// Source: oracle/codemp/botlib/be_ai_weap.cpp:347
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotLoadWeaponWeights: Ai_exportBotLoadWeaponWeights = { _, _ in portMissing("BotLoadWeaponWeights", source: "oracle/codemp/botlib/be_ai_weap.cpp:347") }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:1451
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotMatchVariable: Ai_exportBotMatchVariable = { _, _, _, _ in portMissing("BotMatchVariable", source: "oracle/codemp/botlib/be_ai_chat.cpp:1451") }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:1214
    static let BotMoveInDirection: Ai_exportBotMoveInDirection = { JKAMP_DedLogic.BotMoveInDirection($0, vector(at: $1!), $2, $3) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:3038
    static let BotMoveToGoal: Ai_exportBotMoveToGoal = { JKAMP_DedLogic.BotMoveToGoal(BotMoveresult(handle: $0!), $1, BotGoal(handle: $2!), $3) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:826
    static let BotMovementViewTarget: Ai_exportBotMovementViewTarget = { movestate, goal, travelflags, lookahead, target in
        var value = vector(at: target!)
        let found = JKAMP_DedLogic.BotMovementViewTarget(movestate, BotGoal(handle: goal!), travelflags, lookahead, &value)
        let targetSlots = Slots<Float>(scalars: target!, count: 3)
        targetSlots[0] = value[0]
        targetSlots[1] = value[1]
        targetSlots[2] = value[2]
        return found
    }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:237
    static let BotMutateGoalFuzzyLogic: Ai_exportBotMutateGoalFuzzyLogic = { JKAMP_DedLogic.BotMutateGoalFuzzyLogic($0, $1) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:350
    static let BotNextConsoleMessage: Ai_exportBotNextConsoleMessage = { JKAMP_DedLogic.BotNextConsoleMessage($0, BotConsolemessage(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:370
    static let BotNumConsoleMessages: Ai_exportBotNumConsoleMessages = { JKAMP_DedLogic.BotNumConsoleMessages($0) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2448
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotNumInitialChats: Ai_exportBotNumInitialChats = { _, _ in portMissing("BotNumInitialChats", source: "oracle/codemp/botlib/be_ai_chat.cpp:2448") }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1207
    static let BotPopGoal: Ai_exportBotPopGoal = { JKAMP_DedLogic.BotPopGoal($0) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:895
    static let BotPredictVisiblePosition: Ai_exportBotPredictVisiblePosition = { origin, areanum, goal, travelflags, target in
        var value = vector(at: target!)
        let found = JKAMP_DedLogic.BotPredictVisiblePosition(vector(at: origin!), areanum, BotGoal(handle: goal!), travelflags, &value)
        let targetSlots = Slots<Float>(scalars: target!, count: 3)
        targetSlots[0] = value[0]
        targetSlots[1] = value[1]
        targetSlots[2] = value[2]
        return found
    }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1186
    static let BotPushGoal: Ai_exportBotPushGoal = { JKAMP_DedLogic.BotPushGoal($0, BotGoal(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:309
    static let BotQueueConsoleMessage: Ai_exportBotQueueConsoleMessage = { JKAMP_DedLogic.BotQueueConsoleMessage($0, $1, text(at: $2!)) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:284
    static let BotReachabilityArea: Ai_exportBotReachabilityArea = { JKAMP_DedLogic.BotReachabilityArea(vector(at: $0!), $1) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:279
    static let BotRemoveConsoleMessage: Ai_exportBotRemoveConsoleMessage = { JKAMP_DedLogic.BotRemoveConsoleMessage($0, $1) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:758
    static let BotRemoveFromAvoidGoals: Ai_exportBotRemoveFromAvoidGoals = { JKAMP_DedLogic.BotRemoveFromAvoidGoals($0, $1) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:744
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotReplaceSynonyms: Ai_exportBotReplaceSynonyms = { _, _ in portMissing("BotReplaceSynonyms", source: "oracle/codemp/botlib/be_ai_chat.cpp:744") }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2597
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let BotReplyChat: Ai_exportBotReplyChat = { _, _, _, _, _, _, _, _, _, _, _, _ in portMissing("BotReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:2597") }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:687
    static let BotResetAvoidGoals: Ai_exportBotResetAvoidGoals = { JKAMP_DedLogic.BotResetAvoidGoals($0) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:3498
    static let BotResetAvoidReach: Ai_exportBotResetAvoidReach = { JKAMP_DedLogic.BotResetAvoidReach($0) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1658
    static let BotResetGoalState: Ai_exportBotResetGoalState = { JKAMP_DedLogic.BotResetGoalState($0) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:3514
    static let BotResetLastAvoidReach: Ai_exportBotResetLastAvoidReach = { JKAMP_DedLogic.BotResetLastAvoidReach($0) }

    /// Source: oracle/codemp/botlib/be_ai_move.cpp:3544
    static let BotResetMoveState: Ai_exportBotResetMoveState = { JKAMP_DedLogic.BotResetMoveState($0) }

    /// Source: oracle/codemp/botlib/be_ai_weap.cpp:424
    static let BotResetWeaponState: Ai_exportBotResetWeaponState = { JKAMP_DedLogic.BotResetWeaponState($0) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:223
    static let BotSaveGoalFuzzyLogic: Ai_exportBotSaveGoalFuzzyLogic = { JKAMP_DedLogic.BotSaveGoalFuzzyLogic($0, text(at: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:804
    static let BotSetAvoidGoalTime: Ai_exportBotSetAvoidGoalTime = { JKAMP_DedLogic.BotSetAvoidGoalTime($0, $1, $2) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2823
    static let BotSetChatGender: Ai_exportBotSetChatGender = { JKAMP_DedLogic.BotSetChatGender($0, $1) }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:2842
    static let BotSetChatName: Ai_exportBotSetChatName = { JKAMP_DedLogic.BotSetChatName($0, text(at: $1!), $2) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:1592
    static let BotTouchingGoal: Ai_exportBotTouchingGoal = { JKAMP_DedLogic.BotTouchingGoal(vector(at: $0!), BotGoal(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_ai_goal.cpp:993
    static let BotUpdateEntityItems: Ai_exportBotUpdateEntityItems = { JKAMP_DedLogic.BotUpdateEntityItems() }

    /// Source: oracle/codemp/botlib/be_ai_char.cpp:656
    static let Characteristic_BFloat: Ai_exportCharacteristic_BFloat = { JKAMP_DedLogic.Characteristic_BFloat($0, $1, $2, $3) }

    /// Source: oracle/codemp/botlib/be_ai_char.cpp:710
    static let Characteristic_BInteger: Ai_exportCharacteristic_BInteger = { JKAMP_DedLogic.Characteristic_BInteger($0, $1, $2, $3) }

    /// Source: oracle/codemp/botlib/be_ai_char.cpp:624
    static let Characteristic_Float: Ai_exportCharacteristic_Float = { JKAMP_DedLogic.Characteristic_Float($0, $1) }

    /// Source: oracle/codemp/botlib/be_ai_char.cpp:679
    static let Characteristic_Integer: Ai_exportCharacteristic_Integer = { JKAMP_DedLogic.Characteristic_Integer($0, $1) }

    /// Source: oracle/codemp/botlib/be_ai_char.cpp:733
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let Characteristic_String: Ai_exportCharacteristic_String = { _, _, _, _ in portMissing("Characteristic_String", source: "oracle/codemp/botlib/be_ai_char.cpp:733") }

    /// Source: oracle/codemp/botlib/be_ai_gen.cpp:73
    static let GeneticParentsAndChildSelection: Ai_exportGeneticParentsAndChildSelection = { numranks, ranks, parent1, parent2, child in
        let parent1Slots = Slots<Int32>(scalars: parent1!, count: 1)
        let parent2Slots = Slots<Int32>(scalars: parent2!, count: 1)
        let childSlots = Slots<Int32>(scalars: child!, count: 1)
        var parent1Value = parent1Slots[0]
        var parent2Value = parent2Slots[0]
        var childValue = childSlots[0]
        let found = JKAMP_DedLogic.GeneticParentsAndChildSelection(numranks, Slots<Float>(scalars: ranks!, count: Int(numranks)), &parent1Value, &parent2Value, &childValue)
        parent1Slots[0] = parent1Value
        parent2Slots[0] = parent2Value
        childSlots[0] = childValue
        return found
    }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:447
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let StringContains: Ai_exportStringContains = { _, _, _ in portMissing("StringContains", source: "oracle/codemp/botlib/be_ai_chat.cpp:447") }

    /// Source: oracle/codemp/botlib/be_ai_chat.cpp:423
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let UnifyWhiteSpaces: Ai_exportUnifyWhiteSpaces = { _ in portMissing("UnifyWhiteSpaces", source: "oracle/codemp/botlib/be_ai_chat.cpp:423") }
}

/// One static per function this file stores in a `BotlibExport` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum BotlibExportThunks {
    /// Source: oracle/codemp/botlib/be_interface.cpp:302
    static let BotExportTest: BotlibExportTest = { JKAMP_DedLogic.BotExportTest($0, text(at: $1!), vector(at: $2!), vector(at: $3!)) }

    /// Source: oracle/codemp/botlib/be_interface.cpp:239
    static let Export_BotLibLoadMap: BotlibExportBotLibLoadMap = { JKAMP_DedLogic.Export_BotLibLoadMap(text(at: $0!)) }

    /// Source: oracle/codemp/botlib/be_interface.cpp:119
    static let Export_BotLibSetup: BotlibExportBotLibSetup = { JKAMP_DedLogic.Export_BotLibSetup() }

    /// Source: oracle/codemp/botlib/be_interface.cpp:159
    static let Export_BotLibShutdown: BotlibExportBotLibShutdown = { JKAMP_DedLogic.Export_BotLibShutdown() }

    /// Source: oracle/codemp/botlib/be_interface.cpp:228
    static let Export_BotLibStartFrame: BotlibExportBotLibStartFrame = { JKAMP_DedLogic.Export_BotLibStartFrame($0) }

    /// Source: oracle/codemp/botlib/be_interface.cpp:269
    static let Export_BotLibUpdateEntity: BotlibExportBotLibUpdateEntity = { JKAMP_DedLogic.Export_BotLibUpdateEntity($0, BotEntitystate(handle: $1!)) }

    /// Source: oracle/codemp/botlib/be_interface.cpp:213
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let Export_BotLibVarGet: BotlibExportBotLibVarGet = { _, _, _ in portMissing("Export_BotLibVarGet", source: "oracle/codemp/botlib/be_interface.cpp:213") }

    /// Source: oracle/codemp/botlib/be_interface.cpp:202
    static let Export_BotLibVarSet: BotlibExportBotLibVarSet = { JKAMP_DedLogic.Export_BotLibVarSet(text(at: $0!), text(at: $1!)) }

    /// Source: oracle/codemp/botlib/l_precomp.cpp:1407
    static let PC_AddGlobalDefine: BotlibExportPC_AddGlobalDefine = { JKAMP_DedLogic.PC_AddGlobalDefine(text(at: $0!)) }

    /// Source: oracle/codemp/botlib/l_precomp.cpp:3214
    static let PC_FreeSourceHandle: BotlibExportPC_FreeSourceHandle = { JKAMP_DedLogic.PC_FreeSourceHandle($0) }

    /// Source: oracle/codemp/botlib/l_precomp.cpp:3226
    static let PC_LoadGlobalDefines: BotlibExportPC_LoadGlobalDefines = { JKAMP_DedLogic.PC_LoadGlobalDefines(text(at: $0!)) }

    /// Source: oracle/codemp/botlib/l_precomp.cpp:3189
    static let PC_LoadSourceHandle: BotlibExportPC_LoadSourceHandle = { JKAMP_DedLogic.PC_LoadSourceHandle(text(at: $0!)) }

    /// Source: oracle/codemp/botlib/l_precomp.cpp:3253
    static let PC_ReadTokenHandle: BotlibExportPC_ReadTokenHandle = { JKAMP_DedLogic.PC_ReadTokenHandle($0, JKAMP.PcToken(handle: $1!)) }

    /// Source: oracle/codemp/botlib/l_precomp.cpp:1447
    static let PC_RemoveAllGlobalDefines: BotlibExportPC_RemoveAllGlobalDefines = { JKAMP_DedLogic.PC_RemoveAllGlobalDefines() }

    /// Source: oracle/codemp/botlib/l_precomp.cpp:3280
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let PC_SourceFileAndLine: BotlibExportPC_SourceFileAndLine = { _, _, _ in portMissing("PC_SourceFileAndLine", source: "oracle/codemp/botlib/l_precomp.cpp:3280") }
}

/// One static per function this file stores in a `Ea_export` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum Ea_exportThunks {
    /// Source: oracle/codemp/botlib/be_ea.cpp:297
    static let EA_Action: Ea_exportEA_Action = { JKAMP_DedLogic.EA_Action($0, $1) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:157
    static let EA_Alt_Attack: Ea_exportEA_Alt_Attack = { JKAMP_DedLogic.EA_Alt_Attack($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:143
    static let EA_Attack: Ea_exportEA_Attack = { JKAMP_DedLogic.EA_Attack($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:119
    // Port-note: Row X2. The Swift parameter is an `inout CharBuf` for a C `char *`, and the host has no thunk form that reads or writes a C buffer into a CharBuf.
    static let EA_Command: Ea_exportEA_Command = { _, _ in portMissing("EA_Command", source: "oracle/codemp/botlib/be_ea.cpp:119") }

    /// Source: oracle/codemp/botlib/be_ea.cpp:269
    static let EA_Crouch: Ea_exportEA_Crouch = { JKAMP_DedLogic.EA_Crouch($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:248
    static let EA_DelayedJump: Ea_exportEA_DelayedJump = { JKAMP_DedLogic.EA_DelayedJump($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:427
    static let EA_EndRegular: Ea_exportEA_EndRegular = { JKAMP_DedLogic.EA_EndRegular($0, $1) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:171
    static let EA_ForcePower: Ea_exportEA_ForcePower = { JKAMP_DedLogic.EA_ForcePower($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:105
    static let EA_Gesture: Ea_exportEA_Gesture = { JKAMP_DedLogic.EA_Gesture($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:454
    static let EA_GetInput: Ea_exportEA_GetInput = { JKAMP_DedLogic.EA_GetInput($0, $1, BotInput(handle: $2!)) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:227
    static let EA_Jump: Ea_exportEA_Jump = { JKAMP_DedLogic.EA_Jump($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:395
    static let EA_Move: Ea_exportEA_Move = { JKAMP_DedLogic.EA_Move($0, vector(at: $1!), $2) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:353
    static let EA_MoveBack: Ea_exportEA_MoveBack = { JKAMP_DedLogic.EA_MoveBack($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:325
    static let EA_MoveDown: Ea_exportEA_MoveDown = { JKAMP_DedLogic.EA_MoveDown($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:339
    static let EA_MoveForward: Ea_exportEA_MoveForward = { JKAMP_DedLogic.EA_MoveForward($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:367
    static let EA_MoveLeft: Ea_exportEA_MoveLeft = { JKAMP_DedLogic.EA_MoveLeft($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:381
    static let EA_MoveRight: Ea_exportEA_MoveRight = { JKAMP_DedLogic.EA_MoveRight($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:311
    static let EA_MoveUp: Ea_exportEA_MoveUp = { JKAMP_DedLogic.EA_MoveUp($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:481
    static let EA_ResetInput: Ea_exportEA_ResetInput = { JKAMP_DedLogic.EA_ResetInput($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:213
    static let EA_Respawn: Ea_exportEA_Respawn = { JKAMP_DedLogic.EA_Respawn($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:35
    static let EA_Say: Ea_exportEA_Say = { JKAMP_DedLogic.EA_Say($0, text(at: $1!)) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:45
    static let EA_SayTeam: Ea_exportEA_SayTeam = { JKAMP_DedLogic.EA_SayTeam($0, text(at: $1!)) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:129
    static let EA_SelectWeapon: Ea_exportEA_SelectWeapon = { JKAMP_DedLogic.EA_SelectWeapon($0, $1) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:185
    static let EA_Talk: Ea_exportEA_Talk = { JKAMP_DedLogic.EA_Talk($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:199
    static let EA_Use: Ea_exportEA_Use = { JKAMP_DedLogic.EA_Use($0) }

    /// Source: oracle/codemp/botlib/be_ea.cpp:413
    static let EA_View: Ea_exportEA_View = { JKAMP_DedLogic.EA_View($0, vector(at: $1!)) }
}
