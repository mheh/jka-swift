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
    // TODO: Port AAS_Error
    portMissing("AAS_Error", source: "oracle/codemp/botlib/be_aas_main.cpp:40")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:56
func AAS_StringFromIndex(_ indexname: inout JKAShared.CharBuf, _ stringindex: inout ArraySlice<String>, _ numindexes: Int32, _ index: Int32) -> String {
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
    // TODO: Port AAS_Loaded
    portMissing("AAS_Loaded", source: "oracle/codemp/botlib/be_aas_main.cpp:146")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:156
func AAS_Initialized() -> Int32 {
    // TODO: Port AAS_Initialized
    portMissing("AAS_Initialized", source: "oracle/codemp/botlib/be_aas_main.cpp:156")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:166
func AAS_SetInitialized() {
    // TODO: Port AAS_SetInitialized
    portMissing("AAS_SetInitialized", source: "oracle/codemp/botlib/be_aas_main.cpp:166")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:183
func AAS_ContinueInit(_ time: Float) {
    // TODO: Port AAS_ContinueInit
    portMissing("AAS_ContinueInit", source: "oracle/codemp/botlib/be_aas_main.cpp:183")
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
    // TODO: Port AAS_StartFrame
    portMissing("AAS_StartFrame", source: "oracle/codemp/botlib/be_aas_main.cpp:221")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:267
func AAS_Time() -> Float {
    // TODO: Port AAS_Time
    portMissing("AAS_Time", source: "oracle/codemp/botlib/be_aas_main.cpp:267")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:277
func AAS_ProjectPointOntoVector(_ point: JKAShared.vec3_t, _ vStart: JKAShared.vec3_t, _ vEnd: JKAShared.vec3_t, _ vProj: inout JKAShared.vec3_t) {
    // TODO: Port AAS_ProjectPointOntoVector
    portMissing("AAS_ProjectPointOntoVector", source: "oracle/codemp/botlib/be_aas_main.cpp:277")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:293
func AAS_LoadFiles(_ mapname: String) -> Int32 {
    // TODO: Port AAS_LoadFiles
    portMissing("AAS_LoadFiles", source: "oracle/codemp/botlib/be_aas_main.cpp:293")
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
    // TODO: Port AAS_LoadMap
    portMissing("AAS_LoadMap", source: "oracle/codemp/botlib/be_aas_main.cpp:324")
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
    // TODO: Port AAS_Setup
    portMissing("AAS_Setup", source: "oracle/codemp/botlib/be_aas_main.cpp:366")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_main.cpp:389
func AAS_Shutdown() {
    // TODO: Port AAS_Shutdown
    portMissing("AAS_Shutdown", source: "oracle/codemp/botlib/be_aas_main.cpp:389")
}
