import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:32
/// Raven's ICARUS game table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var interface_export: interface_export_t {
    world.interface_export
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:45
private func Q3_ReadScript(_ name: String, _ buf: inout JKAShared.TextCursor) -> Int32 {
    return ICARUS_GetScript(va("%s/%s", Q3_SCRIPT_DIR, name), &buf)	//get a (hopefully) cached file
}

/**
```
============
Q3_CenterPrint
  Description	: Prints a message in the center of the screen
  Return type	: static void
  Argument		:  const char *format
  Argument		: ...
============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:59
private func Q3_CenterPrint(_ format: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    strcpy(&text, JKAShared.format(format, args))

    // FIXME: added '!' so you can print something that's hasn't been precached, '@' searches only for precache text
    // this is just a TEMPORARY placeholder until objectives are in!!!  -- dmv 11/26/01

    if (text[0] == Int32(ascii: "@")) || text[0] == Int32(ascii: "!") { // It's a key
        if text[0] == Int32(ascii: "!") {
            SV_SendServerCommand(nil, "cp \"%s\"", text[1...])
            return
        }

        SV_SendServerCommand(nil, "cp \"%s\"", text)
    }

    Q3_DebugPrint(WL_VERBOSE, "%s\n", text) // Just a developers note

    return
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:98
func Q3_TaskIDClear(_ taskID: inout Int32) {
    taskID = -1
}

/**
```
-------------------------
qboolean Q3_TaskIDPending( sharedEntity_t *ent, taskID_t taskType )
-------------------------
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:109
func Q3_TaskIDPending(_ ent: JKAMP.SharedEntity, _ taskType: JKAMP.taskID_t) -> Bool {
    if gSequencers[ent.s.number] == nil || gTaskManagers[ent.s.number] == nil {
        return false
    }

    if taskType < TID_CHAN_VOICE || taskType >= NUM_TIDS {
        return false
    }

    if ent.taskID[taskType] >= 0 { //-1 is none
        return true
    }

    return false
}

/**
```
-------------------------
void Q3_TaskIDComplete( sharedEntity_t *ent, taskID_t taskType )
-------------------------
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:134
func Q3_TaskIDComplete(_ ent: JKAMP.SharedEntity, _ taskType: JKAMP.taskID_t) {
    if taskType < TID_CHAN_VOICE || taskType >= NUM_TIDS {
        return
    }

    if gTaskManagers[ent.s.number] != nil && Q3_TaskIDPending(ent, taskType) {
        //Complete it
        gTaskManagers[ent.s.number]!.Completed(ent.taskID[taskType])

        //See if any other tasks have the name number and clear them so we don't complete more than once
        let clearTask = ent.taskID[taskType]
        var tid: Int32 = 0
        while tid < NUM_TIDS {
            if ent.taskID[tid] == clearTask {
                Q3_TaskIDClear(&ent.taskID[tid])
            }
            tid += 1
        }

        //clear it - should be cleared in for loop above
        //Q3_TaskIDClear( &ent->taskID[taskType] );
    }
    //otherwise, wasn't waiting for a task to complete anyway
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:167
func Q3_TaskIDSet(_ ent: JKAMP.SharedEntity, _ taskType: JKAMP.taskID_t, _ taskID: Int32) {
    if taskType < TID_CHAN_VOICE || taskType >= NUM_TIDS {
        return
    }

    //Might be stomping an old task, so complete and clear previous task if there was one
    Q3_TaskIDComplete(ent, taskType)

    ent.taskID[taskType] = taskID
}

/**
```
============
Q3_CheckStringCounterIncrement
  Description	:
  Return type	: static float
  Argument		: const char *string
============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:189
private func Q3_CheckStringCounterIncrement(_ string: String) -> Float {
    var numString = TextCursor()
    var val: Float = 0.0
    // Raven steps his own `string` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    let string = TextCursor(CharBuf(string))

    if string[0] == Int32(ascii: "+") {
        //We want to increment whatever the value is by whatever follows the +
        if string[1] != 0 {
            numString = string
            numString.advance()
            val = Float(atof(numString.text))
        }
    } else if string[0] == Int32(ascii: "-") {
        //we want to decrement
        if string[1] != 0 {
            numString = string
            numString.advance()
            val = Float(atof(numString.text) * -1)
        }
    }

    return val
}

/**
```
=============
Q3_GetEntityByName

Returns the sequencer of the entity by the given name
=============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:221
private func Q3_GetEntityByName(_ name: String) -> JKAMP.SharedEntity? {
    let ent: JKAMP.SharedEntity?
    var temp = CharBuf(1024)

    if name.isEmpty {
        return nil
    }

    strncpy(&temp, name, Int32(temp.count))
    temp[temp.count - 1] = 0

    // AI: Raven's Q_strupr returns its argument, and the port's returns nothing. The key is the text of the CharBuf after the call.
    Q_strupr(&temp)
    let ei = ICARUS_EntList[String(temp)]

    if ei == nil {
        return nil
    }

    ent = SV_GentityNum(ei!)

    return ent
}

/**
```
=============
Q3_GetTime

Get the current game time
=============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:254
private func Q3_GetTime() -> UInt32 {
    // C converts the `int` time to the `DWORD` return.
    return UInt32(bitPattern: svs.time)
}

/**
```
=============
Q3_PlaySound

Plays a sound from an entity
=============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:313
private func Q3_PlaySound(_ taskID: Int32, _ entID: Int32, _ name: String, _ channel: String) -> Int32 {
    let sharedMem = IcarusPlaySound(sv.mSharedMemoryBytes!.base)

    sharedMem.taskID = taskID
    sharedMem.entID = entID
    sharedMem.name = name
    sharedMem.channel = channel

    return VM_Call(gvm!, GAME_ICARUS_PLAYSOUND)
}

/**
```
============
Q3_SetVar
  Description	:
  Return type	: static void
  Argument		:  int taskID
  Argument		: int entID
  Argument		: const char *type_name
  Argument		: const char *data
============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:337
func Q3_SetVar(_ taskID: Int32, _ entID: Int32, _ type_name: String, _ data: String) {
    let vret: Int32 = Q3_VariableDeclared(type_name)
    var float_data: Float = 0
    var val: Float = 0.0

    if vret != VTYPE_NONE {
        switch vret {
        case VTYPE_FLOAT:
            //Check to see if increment command
            val = Q3_CheckStringCounterIncrement(data)
            if val != 0 {
                Q3_GetFloatVariable(type_name, &float_data)
                float_data += val
            } else {
                float_data = Float(atof(data))
            }
            Q3_SetFloatVariable(type_name, float_data)

        case VTYPE_STRING:
            Q3_SetStringVariable(type_name, data)

        case VTYPE_VECTOR:
            Q3_SetVectorVariable(type_name, data)

        default:
            break
        }

        return
    }

    Q3_DebugPrint(WL_ERROR, "%s variable or field not found!\n", type_name)
}

/**
```
============
Q3_Set
  Description	:
  Return type	: void
  Argument		:  int taskID
  Argument		: int entID
  Argument		: const char *type_name
  Argument		: const char *data
============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:388
private func Q3_Set(_ taskID: Int32, _ entID: Int32, _ type_name: String, _ data: String) {
    let sharedMem = IcarusSet(sv.mSharedMemoryBytes!.base)

    sharedMem.taskID = taskID
    sharedMem.entID = entID
    sharedMem.type_name = type_name
    sharedMem.data = data

    if VM_Call(gvm!, GAME_ICARUS_SET) != 0 {
        gTaskManagers[entID]!.Completed(taskID)
    }
}

/**
```
============
Q3_Evaluate
  Description	:
  Return type	: int
  Argument		:  int p1Type
  Argument		: const char *p1
  Argument		: int p2Type
  Argument		: const char *p2
  Argument		: int operatorType
============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:416
private func Q3_Evaluate(_ p1Type: Int32, _ p1: String, _ p2Type: Int32, _ p2: String, _ operatorType: Int32) -> Int32 {
    var p1Type = p1Type
    var p2Type = p2Type
    var f1: Float = 0, f2: Float = 0
    var v1 = JKAShared.vec3_t(), v2 = JKAShared.vec3_t()
    var c1: String? = nil, c2: String? = nil
    var i1: Int32 = 0, i2: Int32 = 0

    //Always demote to int on float to integer comparisons
    if ((p1Type == TK_FLOAT) && (p2Type == TK_INT)) || ((p1Type == TK_INT) && (p2Type == TK_FLOAT)) {
        p1Type = TK_INT
        p2Type = TK_INT
    }

    //Cannot compare two disimilar types
    if p1Type != p2Type {
        Q3_DebugPrint(WL_ERROR, "Q3_Evaluate comparing two disimilar types!\n")
        return 0
    }

    //Format the parameters
    switch p1Type {
    case TK_FLOAT:
        sscanf(p1, "%f", &f1)
        sscanf(p2, "%f", &f2)

    case TK_INT:
        sscanf(p1, "%d", &i1)
        sscanf(p2, "%d", &i2)

    case TK_VECTOR:
        sscanf(p1, "%f %f %f", &v1)
        sscanf(p2, "%f %f %f", &v2)

    case TK_STRING, TK_IDENTIFIER:
        c1 = p1
        c2 = p2

    default:
        Q3_DebugPrint(WL_WARNING, "Q3_Evaluate unknown type used!\n")
        return 0
    }

    //Compare them and return the result

    //FIXME: YUCK!!!  Better way to do this?

    switch operatorType {

    //
    //	EQUAL TO
    //

    case TK_EQUALS:

        switch p1Type {
        case TK_FLOAT:
            return (f1 == f2 ? 1 : 0)

        case TK_INT:
            return (i1 == i2 ? 1 : 0)

        case TK_VECTOR:
            return VectorCompare(v1, v2)

        case TK_STRING, TK_IDENTIFIER:
            return (stricmp(c1!, c2!) == 0 ? 1 : 0) //NOTENOTE: The script uses proper string comparison logic (ex. ( a == a ) == true )

        default:
            Q3_DebugPrint(WL_ERROR, "Q3_Evaluate unknown type used!\n")
            return 0
        }

    //
    //	GREATER THAN
    //

    case TK_GREATER_THAN:

        switch p1Type {
        case TK_FLOAT:
            return (f1 > f2 ? 1 : 0)

        case TK_INT:
            return (i1 > i2 ? 1 : 0)

        case TK_VECTOR:
            Q3_DebugPrint(WL_ERROR, "Q3_Evaluate vector comparisons of type GREATER THAN cannot be performed!")
            return 0

        case TK_STRING, TK_IDENTIFIER:
            Q3_DebugPrint(WL_ERROR, "Q3_Evaluate string comparisons of type GREATER THAN cannot be performed!")
            return 0

        default:
            Q3_DebugPrint(WL_ERROR, "Q3_Evaluate unknown type used!\n")
            return 0
        }

    //
    //	LESS THAN
    //

    case TK_LESS_THAN:

        switch p1Type {
        case TK_FLOAT:
            return (f1 < f2 ? 1 : 0)

        case TK_INT:
            return (i1 < i2 ? 1 : 0)

        case TK_VECTOR:
            Q3_DebugPrint(WL_ERROR, "Q3_Evaluate vector comparisons of type LESS THAN cannot be performed!")
            return 0

        case TK_STRING, TK_IDENTIFIER:
            Q3_DebugPrint(WL_ERROR, "Q3_Evaluate string comparisons of type LESS THAN cannot be performed!")
            return 0

        default:
            Q3_DebugPrint(WL_ERROR, "Q3_Evaluate unknown type used!\n")
            return 0
        }

    //
    //	NOT
    //

    case TK_NOT: //NOTENOTE: Implied "NOT EQUAL TO"

        switch p1Type {
        case TK_FLOAT:
            return (f1 != f2 ? 1 : 0)

        case TK_INT:
            return (i1 != i2 ? 1 : 0)

        case TK_VECTOR:
            return (VectorCompare(v1, v2) == 0 ? 1 : 0)

        case TK_STRING, TK_IDENTIFIER:
            return stricmp(c1!, c2!)

        default:
            Q3_DebugPrint(WL_ERROR, "Q3_Evaluate unknown type used!\n")
            return 0
        }

    default:
        Q3_DebugPrint(WL_ERROR, "Q3_Evaluate unknown operator used!\n")
    }

    return 0
}

/**
```
-------------------------
Q3_CameraFade
-------------------------
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:618
private func Q3_CameraFade(_ sr: Float, _ sg: Float, _ sb: Float, _ sa: Float, _ dr: Float, _ dg: Float, _ db: Float, _ da: Float, _ duration: Float) {
    Q3_DebugPrint(WL_WARNING, "Q3_CameraFade: NOT SUPPORTED IN MP\n")
}

/**
```
-------------------------
Q3_CameraPath
-------------------------
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:628
private func Q3_CameraPath(_ name: String) {
    Q3_DebugPrint(WL_WARNING, "Q3_CameraPath: NOT SUPPORTED IN MP\n")
}

/**
```
-------------------------
Q3_DebugPrint
-------------------------
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:638
func Q3_DebugPrint(_ level: Int32, _ format: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    //Don't print messages they don't want to see
    //if ( g_ICARUSDebug->integer < level )
    if com_developer == nil || com_developer!.integer == 0 {
        return
    }

    strcpy(&text, JKAShared.format(format, args))

    //Add the color formatting
    switch level {
    case WL_ERROR:
        Com_Printf(S_COLOR_RED + "ERROR: %s", text)

    case WL_WARNING:
        Com_Printf(S_COLOR_YELLOW + "WARNING: %s", text)

    case WL_DEBUG:
        // Port-note: Raven's `entNum` is uninitialized, and he reads a stack value when `sscanf` finds no number.
        // The port starts it at 0, so that print names slot 0.
        var entNum: Int32 = 0
        var buffer = TextCursor()

        sscanf(text, "%d", &entNum)

        if (ICARUS_entFilter >= 0) && (ICARUS_entFilter != entNum) {
            return
        }

        buffer = TextCursor(text)
        buffer.advance(by: 5)

        if (entNum < 0) || (entNum > MAX_GENTITIES) {
            entNum = 0
        }

        Com_Printf(S_COLOR_BLUE + "DEBUG: %s(%d): %s\n", SV_GentityNum(entNum)!.script_targetname ?? "(null)", entNum, buffer.text)

    default:
        Com_Printf(S_COLOR_GREEN + "INFO: %s", text)
    }
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:689
func CGCam_Anything() {
    Q3_DebugPrint(WL_WARNING, "Camera functions NOT SUPPORTED IN MP\n")
}

//These are useless for MP. Just taking it for now since I don't want to remove all calls to this in ICARUS.
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:695
func AppendToSaveGame(_ chid: CUnsignedLong, _ data: OpaquePointer?, _ length: Int32) -> Int32 {
    return 1
}

// Changed by BTO (VV) - Visual C++ 7.1 doesn't allow default args on funcion pointers
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:701
func ReadFromSaveGame(_ chid: CUnsignedLong, _ pvAddress: OpaquePointer?, _ iLength: Int32) -> Int32 {
    return 1
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:706
func CGCam_Enable() {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:711
func CGCam_Disable() {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:716
func CGCam_Zoom(_ FOV: Float, _ duration: Float) {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:721
func CGCam_Pan(_ dest: JKAShared.vec3_t, _ panDirection: JKAShared.vec3_t, _ duration: Float) {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:726
func CGCam_Move(_ dest: JKAShared.vec3_t, _ duration: Float) {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:734
func CGCam_Shake(_ intensity: Float, _ duration: Int32) {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:740
func CGCam_Follow(_ cameraGroup: String, _ speed: Float, _ initLerp: Float) {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:745
func CGCam_Track(_ trackName: String, _ speed: Float, _ initLerp: Float) {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:750
func CGCam_Distance(_ distance: Float, _ initLerp: Float) {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:755
func CGCam_Roll(_ dest: Float, _ duration: Float) {
    CGCam_Anything()
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:762
private func Q3_GetTimeScale() -> UInt32 {
    // C converts the `float` time scale to the `DWORD` return.
    return UInt32(com_timescale!.value)
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:767
private func Q3_Lerp2Pos(_ taskID: Int32, _ entID: Int32, _ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t?, _ duration: Float) {
    let sharedMem = IcarusLerp2Pos(sv.mSharedMemoryBytes!.base)

    sharedMem.taskID = taskID
    sharedMem.entID = entID
    sharedMem.origin = origin

    if angles != nil {
        sharedMem.angles = angles!
        sharedMem.nullAngles = false
    } else {
        sharedMem.nullAngles = true
    }
    sharedMem.duration = duration

    VM_Call(gvm!, GAME_ICARUS_LERP2POS)
    //We do this in case the values are modified in the game. It would be expected by icarus that
    //the values passed in here are modified equally.
    origin = sharedMem.origin

    if angles != nil {
        angles = sharedMem.angles
    }
}

/// A caller that passes a vector for `angles` reaches `Q3_Lerp2Pos` through this forward, and a NULL caller passes the optional.
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:767
private func Q3_Lerp2Pos(_ taskID: Int32, _ entID: Int32, _ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t, _ duration: Float) {
    var optionalAngles: JKAShared.vec3_t? = angles
    defer { angles = optionalAngles! }
    Q3_Lerp2Pos(taskID, entID, &origin, &optionalAngles, duration)
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:797
private func Q3_Lerp2Origin(_ taskID: Int32, _ entID: Int32, _ origin: inout JKAShared.vec3_t, _ duration: Float) {
    let sharedMem = IcarusLerp2Origin(sv.mSharedMemoryBytes!.base)

    sharedMem.taskID = taskID
    sharedMem.entID = entID
    sharedMem.origin = origin
    sharedMem.duration = duration

    VM_Call(gvm!, GAME_ICARUS_LERP2ORIGIN)
    origin = sharedMem.origin
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:810
private func Q3_Lerp2Angles(_ taskID: Int32, _ entID: Int32, _ angles: inout JKAShared.vec3_t, _ duration: Float) {
    let sharedMem = IcarusLerp2Angles(sv.mSharedMemoryBytes!.base)

    sharedMem.taskID = taskID
    sharedMem.entID = entID
    sharedMem.angles = angles
    sharedMem.duration = duration

    VM_Call(gvm!, GAME_ICARUS_LERP2ANGLES)
    angles = sharedMem.angles
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:823
private func Q3_GetTag(_ entID: Int32, _ name: String, _ lookup: Int32, _ info: inout JKAShared.vec3_t) -> Int32 {
    let r: Int32
    let sharedMem = IcarusGetTag(sv.mSharedMemoryBytes!.base)

    sharedMem.entID = entID
    sharedMem.name = name
    sharedMem.lookup = lookup
    sharedMem.info = info

    r = VM_Call(gvm!, GAME_ICARUS_GETTAG)
    info = sharedMem.info
    return r
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:838
private func Q3_Lerp2Start(_ entID: Int32, _ taskID: Int32, _ duration: Float) {
    let sharedMem = IcarusLerp2Start(sv.mSharedMemoryBytes!.base)

    sharedMem.taskID = taskID
    sharedMem.entID = entID
    sharedMem.duration = duration

    VM_Call(gvm!, GAME_ICARUS_LERP2START)
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:849
private func Q3_Lerp2End(_ entID: Int32, _ taskID: Int32, _ duration: Float) {
    let sharedMem = IcarusLerp2End(sv.mSharedMemoryBytes!.base)

    sharedMem.taskID = taskID
    sharedMem.entID = entID
    sharedMem.duration = duration

    VM_Call(gvm!, GAME_ICARUS_LERP2END)
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:860
private func Q3_Use(_ entID: Int32, _ target: String) {
    let sharedMem = IcarusUse(sv.mSharedMemoryBytes!.base)

    sharedMem.entID = entID
    sharedMem.target = target

    VM_Call(gvm!, GAME_ICARUS_USE)
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:870
private func Q3_Kill(_ entID: Int32, _ name: String) {
    let sharedMem = IcarusKill(sv.mSharedMemoryBytes!.base)

    sharedMem.entID = entID
    sharedMem.name = name

    VM_Call(gvm!, GAME_ICARUS_KILL)
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:880
private func Q3_Remove(_ entID: Int32, _ name: String) {
    let sharedMem = IcarusRemove(sv.mSharedMemoryBytes!.base)

    sharedMem.entID = entID
    sharedMem.name = name

    VM_Call(gvm!, GAME_ICARUS_REMOVE)
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:890
private func Q3_Play(_ taskID: Int32, _ entID: Int32, _ type: String, _ name: String) {
    let sharedMem = IcarusPlay(sv.mSharedMemoryBytes!.base)

    sharedMem.taskID = taskID
    sharedMem.entID = entID
    sharedMem.type = type
    sharedMem.name = name

    VM_Call(gvm!, GAME_ICARUS_PLAY)
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:902
private func Q3_GetFloat(_ entID: Int32, _ type: Int32, _ name: String, _ value: inout Float) -> Int32 {
    let r: Int32
    let sharedMem = IcarusGetFloat(sv.mSharedMemoryBytes!.base)

    sharedMem.entID = entID
    sharedMem.type = type
    sharedMem.name = name
    sharedMem.value = 0 //*value;

    r = VM_Call(gvm!, GAME_ICARUS_GETFLOAT)
    value = sharedMem.value
    return r
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:917
private func Q3_GetVector(_ entID: Int32, _ type: Int32, _ name: String, _ value: inout JKAShared.vec3_t) -> Int32 {
    let r: Int32
    let sharedMem = IcarusGetVector(sv.mSharedMemoryBytes!.base)

    sharedMem.entID = entID
    sharedMem.type = type
    sharedMem.name = name
    sharedMem.value = value

    r = VM_Call(gvm!, GAME_ICARUS_GETVECTOR)
    value = sharedMem.value
    return r
}

/// Source: oracle/codemp/icarus/Q3_Interface.cpp:932
private func Q3_GetString(_ entID: Int32, _ type: Int32, _ name: String, _ value: inout String) -> Int32 {
    let r: Int32
    let sharedMem = IcarusGetString(sv.mSharedMemoryBytes!.base)

    sharedMem.entID = entID
    sharedMem.type = type
    sharedMem.name = name

    r = VM_Call(gvm!, GAME_ICARUS_GETSTRING)
    //rww - careful with this, next time shared memory is altered this will get stomped
    value = sharedMem.value
    return r
}

/**
```
============
Interface_Init
  Description	: Inits the interface for the game
  Return type	: void
  Argument		: interface_export_t *pe
============
```
*/
/// Source: oracle/codemp/icarus/Q3_Interface.cpp:956
// AI: Raven takes `interface_export_t *pe`. The parameter is the optional hand class, the form of `ie` of ICARUS_Instance::Create.
func Interface_Init(_ pe: interface_export_t?) {
    //TODO: This is where you link up all your functions to the engine

    //General
    pe!.I_LoadFile				=	Q3_ReadScript
    pe!.I_CenterPrint			=	Q3_CenterPrint
    pe!.I_DPrintf				=	Q3_DebugPrint
    pe!.I_GetEntityByName		=	Q3_GetEntityByName
    pe!.I_GetTime				=	Q3_GetTime
    pe!.I_GetTimeScale			=	Q3_GetTimeScale
    pe!.I_PlaySound				=	Q3_PlaySound
    pe!.I_Lerp2Pos				=	Q3_Lerp2Pos
    pe!.I_Lerp2Origin			=	Q3_Lerp2Origin
    pe!.I_Lerp2Angles			=	Q3_Lerp2Angles
    pe!.I_GetTag				=	Q3_GetTag
    pe!.I_Lerp2Start			=	Q3_Lerp2Start
    pe!.I_Lerp2End				=	Q3_Lerp2End
    pe!.I_Use					=	Q3_Use
    pe!.I_Kill					=	Q3_Kill
    pe!.I_Remove				=	Q3_Remove
    pe!.I_Set					=	Q3_Set
    pe!.I_Random				=	Q_flrand
    pe!.I_Play					=	Q3_Play

    //Camera functions
    pe!.I_CameraEnable			=	CGCam_Enable
    pe!.I_CameraDisable			=	CGCam_Disable
    pe!.I_CameraZoom			=	CGCam_Zoom
    pe!.I_CameraMove			=	CGCam_Move
    pe!.I_CameraPan				=	CGCam_Pan
    pe!.I_CameraRoll			=	CGCam_Roll
    pe!.I_CameraTrack			=	CGCam_Track
    pe!.I_CameraFollow			=	CGCam_Follow
    pe!.I_CameraDistance		=	CGCam_Distance
    pe!.I_CameraShake			=	CGCam_Shake
    pe!.I_CameraFade			=	Q3_CameraFade
    pe!.I_CameraPath			=	Q3_CameraPath

    //Variable information
    pe!.I_GetFloat				=	Q3_GetFloat
    pe!.I_GetVector				=	Q3_GetVector
    pe!.I_GetString				=	Q3_GetString

    pe!.I_Evaluate				=	Q3_Evaluate

    pe!.I_DeclareVariable		=	Q3_DeclareVariable
    pe!.I_FreeVariable			=	Q3_FreeVariable

    //Save / Load functions
    pe!.I_WriteSaveData			=	AppendToSaveGame
    pe!.I_ReadSaveData			=	ReadFromSaveGame
    pe!.I_LinkEntity			=	ICARUS_LinkEntity
}
