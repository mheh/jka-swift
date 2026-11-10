import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// these are also in bg_public.h - argh (rjr)
/// Source: oracle/codemp/botlib/be_aas_def.h:29
// AI: Raven's be_aas_def.h gives these names other values than bg_public.h. The botlib keeps Raven's values as constants of its one reader file, row N2.
private let CS_SCORES = 32 as Int32

/// Source: oracle/codemp/botlib/be_aas_def.h:30
private let CS_MODELS = (CS_SCORES + MAX_CLIENTS) as Int32

/// Source: oracle/codemp/botlib/be_aas_def.h:31
private let CS_SOUNDS = (CS_MODELS + MAX_MODELS) as Int32

/// Source: oracle/codemp/botlib/be_aas_main.cpp:30
var aasworld: Aas { world.storage.aasworld }

/// Source: oracle/codemp/botlib/be_aas_main.cpp:32
var saveroutingcache: Libvar? {
    get { world.variables.saveroutingcache }
    set { world.variables.saveroutingcache = newValue }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:40
func AAS_Error(_ fmt: String, _ args: any JKAShared.FormatArg...) {
    var str = CharBuf(1024)

    strcpy(&str, JKAShared.format(fmt, args))
    botimport.runPrint(PRT_FATAL, String(str))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:56
func AAS_StringFromIndex(_ indexname: inout JKAShared.CharBuf, _ stringindex: inout ArraySlice<String>, _ numindexes: Int32, _ index: Int32) -> String {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port AAS_StringFromIndex
    portMissing("AAS_StringFromIndex", source: "oracle/codemp/botlib/be_aas_main.cpp:56")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:84
func AAS_IndexFromString(_ indexname: inout JKAShared.CharBuf, _ stringindex: inout ArraySlice<String>, _ numindexes: Int32, _ string: inout JKAShared.CharBuf) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port AAS_IndexFromString
    portMissing("AAS_IndexFromString", source: "oracle/codemp/botlib/be_aas_main.cpp:84")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:105
func AAS_ModelFromIndex(_ index: Int32) -> String {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port AAS_ModelFromIndex
    portMissing("AAS_ModelFromIndex", source: "oracle/codemp/botlib/be_aas_main.cpp:105")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:115
func AAS_IndexFromModel(_ modelname: inout JKAShared.CharBuf) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port AAS_IndexFromModel
    portMissing("AAS_IndexFromModel", source: "oracle/codemp/botlib/be_aas_main.cpp:115")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:125
func AAS_UpdateStringIndexes(_ numconfigstrings: Int32, _ configstrings: inout ArraySlice<String>) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port AAS_UpdateStringIndexes
    portMissing("AAS_UpdateStringIndexes", source: "oracle/codemp/botlib/be_aas_main.cpp:125")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:146
func AAS_Loaded() -> Int32 {
    return aasworld.loaded
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:156
func AAS_Initialized() -> Int32 {
    return aasworld.initialized
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:166
func AAS_SetInitialized() {
    aasworld.initialized = 1
    botimport.runPrint(PRT_MESSAGE, "AAS initialized.\n")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:183
func AAS_ContinueInit(_ time: Float) {
    //if no AAS file loaded
    if aasworld.loaded == 0 { return }
    //if AAS is already initialized
    if aasworld.initialized != 0 { return }
    //calculate reachability, if not finished return
    if AAS_ContinueInitReachability(time) != 0 { return }
    //initialize clustering for the new map
    AAS_InitClustering()
    //if reachability has been calculated and an AAS file should be written
    //or there is a forced data optimization
    if aasworld.savefile != 0 || (Int32(LibVarGetValue("forcewrite"))) != 0 {
        //optimize the AAS data
        if (Int32(LibVarValue("aasoptimize", "0"))) != 0 { AAS_Optimize() }
        //save the AAS file
        if AAS_WriteAASFile(&aasworld.filenameBuffer) {
            botimport.runPrint(PRT_MESSAGE, "%s written succesfully\n", aasworld.filename)
        } //end if
        else {
            botimport.runPrint(PRT_ERROR, "couldn't write %s\n", aasworld.filename)
        } //end else
    } //end if
    //initialize the routing
    AAS_InitRouting()
    //at this point AAS is initialized
    AAS_SetInitialized()
}

//===========================================================================
// called at the start of every frame
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:221
func AAS_StartFrame(_ time: Float) -> Int32 {
    aasworld.time = time
    //unlink all entities that were not updated last frame
    AAS_UnlinkInvalidEntities()
    //invalidate the entities
    AAS_InvalidateEntities()
    //initialize AAS
    AAS_ContinueInit(time)
    //
    aasworld.frameroutingupdates = 0
    //
    if bot_developer != 0 {
        if LibVarGetValue("showcacheupdates") != 0 {
            AAS_RoutingInfo()
            LibVarSet("showcacheupdates", "0")
        } //end if
        if LibVarGetValue("showmemoryusage") != 0 {
            PrintUsedMemorySize()
            LibVarSet("showmemoryusage", "0")
        } //end if
        if LibVarGetValue("memorydump") != 0 {
            PrintMemoryLabels()
            LibVarSet("memorydump", "0")
        } //end if
    } //end if
    //
    if saveroutingcache!.value != 0 {
        AAS_WriteRouteCache()
        LibVarSet("saveroutingcache", "0")
    } //end if
    //
    aasworld.numframes += 1
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:267
func AAS_Time() -> Float {
    return aasworld.time
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:277
func AAS_ProjectPointOntoVector(_ point: JKAShared.vec3_t, _ vStart: JKAShared.vec3_t, _ vEnd: JKAShared.vec3_t, _ vProj: inout JKAShared.vec3_t) {
    var pVec = vec3_t(), vec = vec3_t()

    pVec = point - vStart
    vec = vEnd - vStart
    VectorNormalize(&vec)
    // project onto the directional vector for this segment
    _VectorMA(vStart, _DotProduct(pVec, vec), vec, &vProj)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:293
func AAS_LoadFiles(_ mapname: String) -> Int32 {
    var errnum: Int32
    var aasfile = CharBuf(MAX_PATH)
//	char bspfile[MAX_PATH];

    strcpy(&aasworld.mapnameBuffer, mapname)
    //NOTE: first reset the entity links into the AAS areas and BSP leaves
    // the AAS link heap and BSP link heap are reset after respectively the
    // AAS file and BSP file are loaded
    AAS_ResetEntityLinks()
    // load bsp info
    AAS_LoadBSPFile()

    //load the aas file
    Com_sprintf(&aasfile, MAX_PATH, "maps/%s.aas", mapname)
    errnum = AAS_LoadAASFile(&aasfile)
    if errnum != BLERR_NOERROR {
        return errnum
    }

    botimport.runPrint(PRT_MESSAGE, "loaded %s\n", String(aasfile))
    strncpy(&aasworld.filenameBuffer, aasfile, MAX_PATH)
    return BLERR_NOERROR
}

//===========================================================================
// called everytime a map changes
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:324
func AAS_LoadMap(_ mapname: String) -> Int32 {
    var errnum: Int32

    //if no mapname is provided then the string indexes are updated
    //
    aasworld.initialized = 0
    //NOTE: free the routing caches before loading a new map because
    // to free the caches the old number of areas, number of clusters
    // and number of areas in a clusters must be available
    AAS_FreeRoutingCaches()
    //load the map
    errnum = AAS_LoadFiles(mapname)
    if errnum != BLERR_NOERROR {
        aasworld.loaded = 0
        return errnum
    } //end if
    //
    AAS_InitSettings()
    //initialize the AAS link heap for the new map
    AAS_InitAASLinkHeap()
    //initialize the AAS linked entities for the new map
    AAS_InitAASLinkedEntities()
    //initialize reachability for the new map
    AAS_InitReachability()
    //initialize the alternative routing
    AAS_InitAlternativeRouting()
    //everything went ok
    return 0
}

//===========================================================================
// called when the library is first loaded
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:366
func AAS_Setup() -> Int32 {
    aasworld.maxclients = Int32(LibVarValue("maxclients", "128"))
    aasworld.maxentities = Int32(LibVarValue("maxentities", "1024"))
    // as soon as it's set to 1 the routing cache will be saved
    saveroutingcache = LibVar("saveroutingcache", "0")
    //allocate memory for the entities
    if aasworld.entities != nil { FreeMemory(aasworld.entities!.handle) }
    aasworld.entities = AasEntity(GetClearedHunkMemory(aasworld.maxentities * Int32(AasEntity.byteCount)))
    //invalidate all the entities
    AAS_InvalidateEntities()
    //force some recalculations
    //LibVarSet("forceclustering", "1");			//force clustering calculation
    //LibVarSet("forcereachability", "1");		//force reachability calculation
    aasworld.numframes = 0
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:389
func AAS_Shutdown() {
    AAS_ShutdownAlternativeRouting()
    //
    AAS_DumpBSPData()
    //free routing caches
    AAS_FreeRoutingCaches()
    //free aas link heap
    AAS_FreeAASLinkHeap()
    //free aas linked entities
    AAS_FreeAASLinkedEntities()
    //free the aas data
    AAS_DumpAASData()
    //free the entities
    if aasworld.entities != nil { FreeMemory(aasworld.entities!.handle) }
    //clear the aasworld structure
    aasworld.clear()
    //aas has not been initialized
    aasworld.initialized = 0
    //NOTE: as soon as a new .bsp file is loaded the .bsp file memory is
    // freed an reallocated, so there's no need to free that memory here
    //print shutdown
//	botimport.Print(PRT_MESSAGE, "AAS shutdown.\n");
}
