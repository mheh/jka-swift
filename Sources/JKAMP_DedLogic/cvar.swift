import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cvar.cpp:6
var cvar_vars: JKAMP.Cvar? {
    get { world.variables.cvar_vars }
    set { world.variables.cvar_vars = newValue }
}

/// Source: oracle/codemp/qcommon/cvar.cpp:7
var cvar_cheats: JKAMP.Cvar? {
    get { world.variables.cvar_cheats }
    set { world.variables.cvar_cheats = newValue }
}

/// Source: oracle/codemp/qcommon/cvar.cpp:8
var cvar_modifiedFlags: Int32 {
    get { world.variables.cvar_modifiedFlags }
    set { world.variables.cvar_modifiedFlags = newValue }
}

/// Source: oracle/codemp/qcommon/cvar.cpp:10
let MAX_CVARS = 1224 as Int32

/// Source: oracle/codemp/qcommon/cvar.cpp:11
var cvar_indexes: Slots<JKAMP.Cvar> { world.storage.cvar_indexes }

/// Source: oracle/codemp/qcommon/cvar.cpp:12
var cvar_numIndexes: Int32 {
    get { world.variables.cvar_numIndexes }
    set { world.variables.cvar_numIndexes = newValue }
}

/// Source: oracle/codemp/qcommon/cvar.cpp:14
private let FILE_HASH_SIZE = 256 as Int32

/// Source: oracle/codemp/qcommon/cvar.cpp:15
private var hashTable: Slots<JKAMP.Cvar?> { world.storage.cvar_hashTable }

/// Source: oracle/codemp/qcommon/cvar.cpp:20
var lastMemPool: String {
    get { world.variables.lastMemPool }
    set { world.variables.lastMemPool = newValue }
}

/// Source: oracle/codemp/qcommon/cvar.cpp:21
var memPoolSize: Int32 {
    get { world.variables.memPoolSize }
    set { world.variables.memPoolSize = newValue }
}

//If the string came from the memory pool, don't really free it.  The entire
//memory pool will be wiped during the next level load.
/// Source: oracle/codemp/qcommon/cvar.cpp:26
// Raven wrote: static void Cvar_FreeString(char *string)
// Not ported: the string pool holds every cvar string, and each caller drops the free under an AI line.

/**
```
================
return a hash value for the filename
================
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:41
private func generateHashValue(_ fname: String) -> CLong {
    var i: Int32
    var hash: CLong
    var letter: Int8

    hash = 0
    i = 0
    let bytes = CharBuf(fname)
    while bytes[i] != 0 {
        let byte: UInt8 = bytes[i]
        // Foundation also declares tolower, so the qualifier picks the C-locale form of JKAShared.
        letter = Int8(truncatingIfNeeded: JKAShared.tolower(Int32(byte)))
        hash += CLong(letter) * CLong(i + 119)
        i += 1
    }
    hash &= CLong(FILE_HASH_SIZE - 1)
    return hash
}

/**
```
============
Cvar_ValidateString
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:62
private func Cvar_ValidateString(_ s: String) -> Bool {
    if strchr(s, Int32(ascii: "\\")) != nil {
        return false
    }
    if strchr(s, Int32(ascii: "\"")) != nil {
        return false
    }
    if strchr(s, Int32(ascii: ";")) != nil {
        return false
    }
    return true
}

/**
```
============
Cvar_FindVar
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:83
private func Cvar_FindVar(_ var_name: String) -> JKAMP.Cvar? {
    var v: JKAMP.Cvar?
    var hash: CLong

    hash = generateHashValue(var_name)

    v = hashTable[hash]
    while let current = v {
        if Q_stricmp(var_name, current.name) == 0 {
            return current
        }
        v = current.hashNext
    }

    return nil
}

/**
```
============
Cvar_VariableValue
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:103
func Cvar_VariableValue(_ var_name: String) -> Float {
    guard let v = Cvar_FindVar(var_name) else { return 0 }
    return v.value
}

/**
```
============
Cvar_VariableIntegerValue
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:118
func Cvar_VariableIntegerValue(_ var_name: String) -> Int32 {
    guard let v = Cvar_FindVar(var_name) else { return 0 }
    return v.integer
}

/**
```
============
Cvar_VariableString
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:133
func Cvar_VariableString(_ var_name: String) -> String {
    guard let v = Cvar_FindVar(var_name) else { return "" }
    return v.string!
}

/**
```
============
Cvar_VariableStringBuffer
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:148
func Cvar_VariableStringBuffer(_ var_name: String, _ buffer: inout JKAShared.CharBuf, _ bufsize: Int32) {
    if let v = Cvar_FindVar(var_name) {
        Q_strncpyz(&buffer, v.string!, bufsize)
    } else {
        buffer[0] = 0
    }
}

/**
```
============
Cvar_CommandCompletion
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:166
func Cvar_CommandCompletion(_ callback: ((String) -> Void)?) {
    var cvar = cvar_vars
    while let current = cvar {
        defer { cvar = current.next }
        // Do not show internal cvars.
        if current.flags & CVAR_INTERNAL != 0 {
            continue
        }
        callback!(current.name!)
    }
}

/**
```
============
Cvar_Get

If the variable already exists, the value will not be set unless CVAR_ROM
The flags will be or'ed in if the variable exists.
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:188
func Cvar_Get(_ var_name: String, _ var_value: String, _ flags: Int32) -> JKAMP.Cvar? {
    var var_name = var_name
    var hash: CLong

    if !Cvar_ValidateString(var_name) {
        Com_Printf("invalid cvar name string: %s\n", var_name)
        var_name = "BADNAME"
    }

    if let v = Cvar_FindVar(var_name) {
        // If the C code now gives a variable that the user already set a value for, the new value becomes the reset value.
        if v.flags & CVAR_USER_CREATED != 0 && flags & CVAR_USER_CREATED == 0 && !var_value.isEmpty {
            v.flags &= ~CVAR_USER_CREATED
            // AI: Raven frees the old reset string here. The view pools every string, so the free goes.
            v.resetString = CopyString(var_value)

            // ZOID: this must be set, so cvars the game sets as SERVERINFO go to clients.
            cvar_modifiedFlags |= flags
        }

        v.flags |= flags
        // Only one non-empty reset string is allowed without a warning.
        if v.resetString!.isEmpty {
            // We do not have a reset string yet.
            // AI: Raven frees the old reset string here. The view pools every string, so the free goes.
            v.resetString = CopyString(var_value)
        } else if !var_value.isEmpty && strcmp(v.resetString!, var_value) != 0 {
            Com_DPrintf("Warning: cvar \"%s\" given initial values: \"%s\" and \"%s\"\n", var_name, v.resetString!, var_value)
        }
        // If we have a latched string, take that value now.
        if let s = v.latchedString {
            v.latchedString = nil  // Otherwise Cvar_Set2 frees it.
            _ = Cvar_Set2(var_name, s, true)
            // AI: Raven frees the latched string here. The view pools every string, so the free goes.
        }

        return v
    }

    // Allocate a new cvar.
    if cvar_numIndexes >= MAX_CVARS {
        Com_Error(ERR_FATAL, "MAX_CVARS")
    }
    let v = cvar_indexes[cvar_numIndexes]
    cvar_numIndexes += 1
    v.name = CopyString(var_name)
    v.string = CopyString(var_value)
    v.modified = true
    v.modificationCount = 1
    v.value = Float(atof(v.string!))
    v.integer = atoi(v.string!)
    v.resetString = CopyString(var_value)

    // Link the variable in.
    v.next = cvar_vars
    cvar_vars = v

    v.flags = flags

    hash = generateHashValue(var_name)
    v.hashNext = hashTable[hash]
    hashTable[hash] = v

    return v
}

/**
```
============
Cvar_Set2
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:287
func Cvar_Set2(_ var_name: String, _ value: String?, _ force: Bool) -> JKAMP.Cvar? {
    var var_name = var_name
    var value = value

    if !Cvar_ValidateString(var_name) {
        Com_Printf("invalid cvar name string: %s\n", var_name)
        var_name = "BADNAME"
    }

    guard let v = Cvar_FindVar(var_name) else {
        guard let value else { return nil }
        // Create it.
        if !force {
            return Cvar_Get(var_name, value, CVAR_USER_CREATED)
        } else {
            return Cvar_Get(var_name, value, 0)
        }
    }

    // Do not show the update when the cvar is internal.
    if v.flags & CVAR_INTERNAL == 0 {
        Com_DPrintf("Cvar_Set2: %s %s\n", var_name, value ?? "(null)")
    }

    if value == nil {
        value = v.resetString
    }
    let newValue = value!

    if strcmp(newValue, v.string!) == 0 {
        return v
    }
    // Record the kinds of cvars that changed: userinfo, archive, serverinfo, systeminfo.
    cvar_modifiedFlags |= v.flags

    if !force {
        if v.flags & CVAR_ROM != 0 {
            Com_Printf("%s is read only.\n", var_name)
            return v
        }

        if v.flags & CVAR_INIT != 0 {
            Com_Printf("%s is write protected.\n", var_name)
            return v
        }

        if v.flags & CVAR_LATCH != 0 {
            if let latched = v.latchedString {
                if strcmp(newValue, latched) == 0 {
                    return v
                }
                // AI: Raven frees the latched string here. The view pools every string, so the free goes.
            } else {
                if strcmp(newValue, v.string!) == 0 {
                    return v
                }
            }

            Com_Printf("%s will be changed upon restarting.\n", var_name)
            v.latchedString = CopyString(newValue)
            v.modified = true
            v.modificationCount += 1
            return v
        }

        if v.flags & CVAR_CHEAT != 0 && cvar_cheats!.integer == 0 {
            Com_Printf("%s is cheat protected.\n", var_name)
            return v
        }
    } else {
        if v.latchedString != nil {
            // AI: Raven frees the latched string here. The view pools every string, so the free goes.
            v.latchedString = nil
        }
    }

    if strcmp(newValue, v.string!) == 0 {
        return v  // The value did not change.
    }

    v.modified = true
    v.modificationCount += 1

    // AI: Raven frees the old value string here. The view pools every string, so the free goes.

    v.string = CopyString(newValue)
    v.value = Float(atof(v.string!))
    v.integer = atoi(v.string!)

    return v
}

/**
```
============
Cvar_Set
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:402
func Cvar_Set(_ var_name: String, _ value: String) {
    _ = Cvar_Set2(var_name, value, true)
}

/**
```
============
Cvar_SetLatched
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:411
func Cvar_SetLatched(_ var_name: String, _ value: String) {
    _ = Cvar_Set2(var_name, value, false)
}

/**
```
============
Cvar_SetValue
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:420
func Cvar_SetValue(_ var_name: String, _ value: Float) {
    var val = CharBuf(32)

    // Port-note: C is undefined when the value is outside the Int32 range, and Swift traps there.
    if value == Float(Int32(value)) {
        Com_sprintf(&val, 32, "%i", Int32(value))
    } else {
        Com_sprintf(&val, 32, "%f", value)
    }
    Cvar_Set(var_name, String(val))
}

/**
```
============
Cvar_Reset
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:437
func Cvar_Reset(_ var_name: String) {
    _ = Cvar_Set2(var_name, nil, false)
}

/**
```
============
Cvar_SetCheatState

Any testing variables will be reset to the safe values
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:449
func Cvar_SetCheatState() {
    // Set all default vars to the safe value.
    var v = cvar_vars
    while let current = v {
        if current.flags & CVAR_CHEAT != 0 {
            // A CVAR_LATCHED and CVAR_CHEAT var can escape the reset here, because its latchedString differs.
            if current.latchedString != nil {
                // AI: Raven frees the latched string here. The view pools every string, so the free goes.
                current.latchedString = nil
            }
            if strcmp(current.resetString!, current.string!) != 0 {
                Cvar_Set(current.name!, current.resetString!)
            }
        }
        v = current.next
    }
}

/**
```
============
Cvar_Command

Handles variable inspection and changing from the console
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:476
func Cvar_Command() -> Bool {
    // Check variables.
    guard let v = Cvar_FindVar(Cmd_Argv(0)) else { return false }

    // Print or set the variable.
    if Cmd_Argc() == 1 {
        Com_Printf("\"%s\" is:\"%s" + S_COLOR_WHITE + "\" default:\"%s" + S_COLOR_WHITE + "\"\n", v.name!, v.string!, v.resetString!)
        if let latched = v.latchedString {
            Com_Printf("latched: \"%s\"\n", latched)
        }
        return true
    }

    // JFM: toggle test.
    let value = Cmd_Argv(1)
    if value.hasPrefix("!") {  // toggle
        var buff = CharBuf(5)
        // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of buff.
        Com_sprintf(&buff, 5, "%i", v.value == 0 ? 1 : 0)
        _ = Cvar_Set2(v.name!, String(buff), false)  // Toggle the value.
    } else {
        _ = Cvar_Set2(v.name!, value, false)  // Set the value when forcing is not necessary.
    }

    return true
}

/**
```
============
Cvar_Toggle_f

Toggles a cvar for easy single key binding
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:525
func Cvar_Toggle_f() {
    var v: Int32

    if Cmd_Argc() != 2 {
        Com_Printf("usage: toggle <variable>\n")
        return
    }

    v = Int32(Cvar_VariableValue(Cmd_Argv(1)))
    v = v == 0 ? 1 : 0

    _ = Cvar_Set2(Cmd_Argv(1), va("%i", v), false)
}

/**
```
============
Cvar_Set_f

Allows setting and defining of arbitrary cvars from console, even if they
weren't declared in C code.
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:547
func Cvar_Set_f() {
    var c: Int32
    var l: Int32
    var len: Int32
    var combined = CharBuf(MAX_STRING_TOKENS)

    c = Cmd_Argc()
    if c < 3 {
        Com_Printf("usage: set <variable> <value>\n")
        return
    }

    combined[0] = 0
    l = 0
    for i in 2..<c {
        // Port-note: Raven takes strlen of `Cmd_Argv(i) + 1`, one byte past the start, so len is the length less one. An empty argument reads past its NUL in C, and here it gives -1.
        len = strlen(Cmd_Argv(i)) - 1
        if l + len >= MAX_STRING_TOKENS - 2 {
            break
        }
        Q_strcat(&combined, MAX_STRING_TOKENS, Cmd_Argv(i))
        if i != c - 1 {
            Q_strcat(&combined, MAX_STRING_TOKENS, " ")
        }
        l += len
    }
    _ = Cvar_Set2(Cmd_Argv(1), String(combined), false)
}

/**
```
============
Cvar_SetU_f

As Cvar_Set, but also flags it as userinfo
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:580
func Cvar_SetU_f() {
    if Cmd_Argc() != 3 {
        Com_Printf("usage: setu <variable> <value>\n")
        return
    }
    Cvar_Set_f()
    guard let v = Cvar_FindVar(Cmd_Argv(1)) else { return }
    v.flags |= CVAR_USERINFO
}

/**
```
============
Cvar_SetS_f

As Cvar_Set, but also flags it as userinfo
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:602
func Cvar_SetS_f() {
    if Cmd_Argc() != 3 {
        Com_Printf("usage: sets <variable> <value>\n")
        return
    }
    Cvar_Set_f()
    guard let v = Cvar_FindVar(Cmd_Argv(1)) else { return }
    v.flags |= CVAR_SERVERINFO
}

/**
```
============
Cvar_SetA_f

As Cvar_Set, but also flags it as archived
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:624
func Cvar_SetA_f() {
    if Cmd_Argc() != 3 {
        Com_Printf("usage: seta <variable> <value>\n")
        return
    }
    Cvar_Set_f()
    guard let v = Cvar_FindVar(Cmd_Argv(1)) else { return }
    v.flags |= CVAR_ARCHIVE
}

/**
```
============
Cvar_Reset_f
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:644
func Cvar_Reset_f() {
    if Cmd_Argc() != 2 {
        Com_Printf("usage: reset <variable>\n")
        return
    }
    Cvar_Reset(Cmd_Argv(1))
}

/**
```
============
Cvar_WriteVariables

Appends lines containing "set variable value" for all variables
with the archive flag set to qtrue.
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:660
func Cvar_WriteVariables(_ f: JKAShared.fileHandle_t) {
    var buffer = CharBuf(1024)

    var v = cvar_vars
    while let current = v {
        if current.flags & CVAR_ARCHIVE != 0 {
            // Write the latched value, also when it is not in effect yet.
            if let latched = current.latchedString {
                Com_sprintf(&buffer, 1024, "seta %s \"%s\"\n", current.name!, latched)
            } else {
                Com_sprintf(&buffer, 1024, "seta %s \"%s\"\n", current.name!, current.string!)
            }
            FS_Printf(f, "%s", String(buffer))
        }
        v = current.next
    }
}

/**
```
============
Cvar_List_f
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:687
func Cvar_List_f() {
    var i: Int32
    var match: String?

    if Cmd_Argc() > 1 {
        match = Cmd_Argv(1)
    } else {
        match = nil
    }

    i = 0
    var v = cvar_vars
    while let current = v {
        defer {
            v = current.next
            i += 1
        }
        // Do not show internal cvars.
        if current.flags & CVAR_INTERNAL != 0 {
            continue
        }

        if let match {
            var filter = CharBuf(match)
            var name = CharBuf(current.name!)
            if Com_Filter(&filter, &name, 0) == 0 { continue }
        }

        Com_Printf(current.flags & CVAR_SERVERINFO != 0 ? "S" : " ")
        Com_Printf(current.flags & CVAR_USERINFO != 0 ? "U" : " ")
        Com_Printf(current.flags & CVAR_ROM != 0 ? "R" : " ")
        Com_Printf(current.flags & CVAR_INIT != 0 ? "I" : " ")
        Com_Printf(current.flags & CVAR_ARCHIVE != 0 ? "A" : " ")
        Com_Printf(current.flags & CVAR_LATCH != 0 ? "L" : " ")
        Com_Printf(current.flags & CVAR_CHEAT != 0 ? "C" : " ")

        Com_Printf(" %s \"%s\"\n", current.name!, current.string!)
    }

    Com_Printf("\n%i total cvars\n", i)
    Com_Printf("%i cvar indexes\n", cvar_numIndexes)
}

/**
```
============
Cvar_Restart_f

Resets all cvars to their hardcoded values
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:759
func Cvar_Restart_f() {
    // AI: Raven walks a `cvar_t **prev` link. The body holds the previous cvar, and nil stands for the head cvar_vars.
    var prev: JKAMP.Cvar? = nil
    while true {
        guard let v = prev == nil ? cvar_vars : prev!.next else { break }

        // Do not change rom values, or some communication between modules breaks (com_cl_running, for example).
        if v.flags & (CVAR_ROM | CVAR_INIT | CVAR_NORESTART) != 0 {
            prev = v
            continue
        }

        // Throw out all variables the user created.
        if v.flags & CVAR_USER_CREATED != 0 {
            if let prev {
                prev.next = v.next
            } else {
                cvar_vars = v.next
            }
            // AI: Raven frees name, string, latchedString, and resetString here. The view pools every string, so the frees go.
            // Clear the var completely, because we cannot remove the index from the list.
            Com_Memset(v.handle, 0, CUnsignedLong(MemoryLayout<OpaquePointer>.size))
            continue
        }

        Cvar_Set(v.name!, v.resetString!)

        prev = v
    }
}

/**
```
=====================
Cvar_InfoString
=====================
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:811
func Cvar_InfoString(_ bit: Int32) -> String {
    // AI: Raven fills a static `char info[MAX_INFO_STRING]` and returns it. The body fills a local buffer and returns its String.
    var info = CharBuf(MAX_INFO_STRING)

    info[0] = 0

    var v = cvar_vars
    while let current = v {
        if current.flags & CVAR_INTERNAL == 0 && current.flags & bit != 0 {
            Info_SetValueForKey(&info, current.name!, current.string!)
        }
        v = current.next
    }

    return String(info)
}

/**
```
=====================
Cvar_InfoString_Big

  handles large info strings ( CS_SYSTEMINFO )
=====================
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:854
func Cvar_InfoString_Big(_ bit: Int32) -> String {
    // AI: Raven fills a static `char info[BIG_INFO_STRING]` and returns it. The body fills a local buffer and returns its String.
    var info = CharBuf(BIG_INFO_STRING)

    info[0] = 0

    var v = cvar_vars
    while let current = v {
        if current.flags & CVAR_INTERNAL == 0 && current.flags & bit != 0 {
            Info_SetValueForKey_Big(&info, current.name!, current.string!)
        }
        v = current.next
    }

    return String(info)
}

/**
```
=====================
Cvar_InfoStringBuffer
=====================
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:878
func Cvar_InfoStringBuffer(_ bit: Int32, _ buff: inout JKAShared.CharBuf, _ buffsize: Int32) {
    Q_strncpyz(&buff, Cvar_InfoString(bit), buffsize)
}

/**
```
=====================
Cvar_Register

basically a slightly modified Cvar_Get for the interpreted modules
=====================
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:889
func Cvar_Register(_ vmCvar: JKAMP.VmCvar?, _ varName: String, _ defaultValue: String, _ flags: Int32) {
    let cv: JKAMP.Cvar?

    cv = Cvar_Get(varName, defaultValue, flags)
    guard let vmCvar else { return }
    vmCvar.cvarHandle = cvar_indexes.index(of: cv!)
    vmCvar.modificationCount = -1
    Cvar_Update(vmCvar)
}

/**
```
=====================
Cvar_Register

updates an interpreted modules' version of a cvar
=====================
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:909
func Cvar_Update(_ vmCvar: JKAMP.VmCvar) {
    let cv: JKAMP.Cvar

    if UInt32(bitPattern: vmCvar.cvarHandle) >= cvar_numIndexes {
        Com_Error(ERR_DROP, "Cvar_Update: handle out of range")
    }

    cv = cvar_indexes[vmCvar.cvarHandle]

    if cv.modificationCount == vmCvar.modificationCount {
        return
    }
    guard let string = cv.string else {
        return  // The variable might have been cleared by a cvar_restart.
    }
    vmCvar.modificationCount = cv.modificationCount
    if strlen(string) + 1 > MAX_CVAR_VALUE_STRING {
        Com_Error(ERR_DROP, "Cvar_Update: src %s length %d exceeds MAX_CVAR_VALUE_STRING", string, strlen(string), MAX_CVAR_VALUE_STRING)
    }
    // Q_strncpyz pads with zeros and makes the last byte of the destination zero.
    Q_strncpyz(&vmCvar.stringBuffer, string, MAX_CVAR_VALUE_STRING)

    vmCvar.value = cv.value
    vmCvar.integer = cv.integer
}

/**
```
============
Cvar_Init

Reads in all archived cvars
============
```
*/
/// Source: oracle/codemp/qcommon/cvar.cpp:951
func Cvar_Init() {
    cvar_cheats = Cvar_Get("sv_cheats", "0", CVAR_ROM | CVAR_SYSTEMINFO)

    Cmd_AddCommand("toggle", Cvar_Toggle_f)
    Cmd_AddCommand("set", Cvar_Set_f)
    Cmd_AddCommand("sets", Cvar_SetS_f)
    Cmd_AddCommand("setu", Cvar_SetU_f)
    Cmd_AddCommand("seta", Cvar_SetA_f)
    Cmd_AddCommand("reset", Cvar_Reset_f)
    Cmd_AddCommand("cvarlist", Cvar_List_f)
    Cmd_AddCommand("cvar_restart", Cvar_Restart_f)
}

/// Source: oracle/codemp/qcommon/cvar.cpp:965
// Raven wrote: static void Cvar_Realloc(char **string, char *memPool, int &memPoolUsed)
// Not ported: the string pool holds every cvar string, so the memory pool it copies into does not exist, and Cvar_Defrag is a no-op.

//Turns many small allocation blocks into one big one.
/// Source: oracle/codemp/qcommon/cvar.cpp:979
func Cvar_Defrag() {
    // TODO: Port Cvar_Defrag
    // AI: Raven copies every cvar string into one Z_Malloc block. The string pool holds every string, so the defrag is a no-op.
}
