import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's ICARUS game table, the functions that the sequencers and the task managers call into the game side of the engine.
/// One instance exists, `interface_export` of Q3_Interface.cpp, and `Interface_Init` fills it before `ICARUS_Instance::Create`.
/// Source: oracle/codemp/icarus/interface.h:17
// AI: Raven declares a C struct of function pointers, and only the Swift functions of Q3_Interface.cpp, Q3_Registers.cpp, and GameInterface.cpp fill it.
// C never reads the table, so it is a final class of stored Swift functions, the form of `captureFunc` and `rd_flush`, and nil is Raven's NULL.
final class interface_export_t {
    //General
    // AI: Raven's `void **buf` holds a `char *` cursor into the script. The parameter is the inout TextCursor of Q3_ReadScript.
    var I_LoadFile: ((String, inout JKAShared.TextCursor) -> Int32)? = nil
    var I_CenterPrint: ((String, any JKAShared.FormatArg...) -> Void)? = nil
    var I_DPrintf: ((Int32, String, any JKAShared.FormatArg...) -> Void)? = nil
    var I_GetEntityByName: ((String) -> JKAMP.SharedEntity?)? = nil		//Polls the engine for the sequencer of the entity matching the name passed
    var I_GetTime: (() -> UInt32)? = nil							//Gets the current time
    var I_GetTimeScale: (() -> UInt32)? = nil
    var I_PlaySound: ((Int32, Int32, String, String) -> Int32)? = nil
    var I_Lerp2Pos: ((Int32, Int32, inout JKAShared.vec3_t, inout JKAShared.vec3_t?, Float) -> Void)? = nil
    var I_Lerp2Origin: ((Int32, Int32, inout JKAShared.vec3_t, Float) -> Void)? = nil
    var I_Lerp2Angles: ((Int32, Int32, inout JKAShared.vec3_t, Float) -> Void)? = nil
    var I_GetTag: ((Int32, String, Int32, inout JKAShared.vec3_t) -> Int32)? = nil
    var I_Lerp2Start: ((Int32, Int32, Float) -> Void)? = nil
    var I_Lerp2End: ((Int32, Int32, Float) -> Void)? = nil
    var I_Set: ((Int32, Int32, String, String) -> Void)? = nil
    var I_Use: ((Int32, String) -> Void)? = nil
    var I_Kill: ((Int32, String) -> Void)? = nil
    var I_Remove: ((Int32, String) -> Void)? = nil
    var I_Random: ((Float, Float) -> Float)? = nil
    var I_Play: ((Int32, Int32, String, String) -> Void)? = nil

    //Camera functions
    var I_CameraPan: ((JKAShared.vec3_t, JKAShared.vec3_t, Float) -> Void)? = nil
    var I_CameraMove: ((JKAShared.vec3_t, Float) -> Void)? = nil
    var I_CameraZoom: ((Float, Float) -> Void)? = nil
    var I_CameraRoll: ((Float, Float) -> Void)? = nil
    var I_CameraFollow: ((String, Float, Float) -> Void)? = nil
    var I_CameraTrack: ((String, Float, Float) -> Void)? = nil
    var I_CameraDistance: ((Float, Float) -> Void)? = nil
    var I_CameraFade: ((Float, Float, Float, Float, Float, Float, Float, Float, Float) -> Void)? = nil
    var I_CameraPath: ((String) -> Void)? = nil
    var I_CameraEnable: (() -> Void)? = nil
    var I_CameraDisable: (() -> Void)? = nil
    var I_CameraShake: ((Float, Int32) -> Void)? = nil

    var I_GetFloat: ((Int32, Int32, String, inout Float) -> Int32)? = nil
    var I_GetVector: ((Int32, Int32, String, inout JKAShared.vec3_t) -> Int32)? = nil
    var I_GetString: ((Int32, Int32, String, inout String) -> Int32)? = nil

    var I_Evaluate: ((Int32, String, Int32, String, Int32) -> Int32)? = nil

    var I_DeclareVariable: ((Int32, String) -> Void)? = nil
    var I_FreeVariable: ((String) -> Void)? = nil

    //Save / Load functions

    var I_WriteSaveData: ((CUnsignedLong, Slots<JKAShared.byte>, Int32) -> Int32)? = nil
    // Below changed by BTO (VV). Visual C++ 7.1 compiler no longer allows default args on function pointers. Ack.
    var I_ReadSaveData: ((CUnsignedLong, Slots<JKAShared.byte>, Int32) -> Int32)? = nil
    var I_LinkEntity: ((Int32, CSequencer?, CTaskManager?) -> Int32)? = nil
}
