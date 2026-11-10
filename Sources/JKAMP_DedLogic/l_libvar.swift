import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/l_libvar.cpp:20
var libvarlist: Libvar? {
    get { world.variables.libvarlist }
    set { world.variables.libvarlist = newValue }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:28
func LibVarStringValue(_ string: inout JKAShared.CharBuf) -> Float {
    var dotfound: Int32 = 0
    var value: Float = 0
    // Raven steps the pointer `string` through the text, and the walk is a byte offset into the buffer.
    var stringIndex: Int32 = 0

    while string[stringIndex] != 0 {
        if string[stringIndex] < Int32(ascii: "0") || string[stringIndex] > Int32(ascii: "9") {
            if dotfound != 0 || string[stringIndex] != Int32(ascii: ".") {
                return 0
            } //end if
            else {
                dotfound = 10
                stringIndex += 1
            } //end if
        } //end if
        if dotfound != 0 {
            value = value + Float(string[stringIndex] - Int32(ascii: "0")) / Float(dotfound)
            dotfound *= 10
        } //end if
        else {
            value = Float(Double(value) * 10.0 + Double(Float(string[stringIndex] - Int32(ascii: "0"))))
        } //end else
        stringIndex += 1
    } //end while
    return value
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:66
func LibVarAlloc(_ var_name: String) -> Libvar? {
    let v: Libvar

    // AI: Raven points the name at the bytes after the record. The setter keeps the text in the string pool, so those bytes stay unused.
    v = Libvar(GetMemory(Int32(Libvar.byteCount) + strlen(var_name) + 1)!)
    v.clear()
    v.name = var_name
    //add the variable in the list
    v.next = libvarlist
    libvarlist = v
    return v
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:85
func LibVarDeAlloc(_ v: Libvar) {
    // AI: Raven frees the GetMemory block of the text. The text is a String in the pool, so the free drops.
    FreeMemory(v.handle)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:96
func LibVarDeAllocAll() {
    var v: Libvar?

    v = libvarlist
    while v != nil {
        libvarlist = libvarlist!.next
        LibVarDeAlloc(v!)
        v = libvarlist
    } //end for
    libvarlist = nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:113
func LibVarGet(_ var_name: String) -> Libvar? {
    var v: Libvar?

    v = libvarlist
    while v != nil {
        if Q_stricmp(v!.name, var_name) == 0 {
            return v
        } //end if
        v = v!.next
    } //end for
    return nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:132
func LibVarGetString(_ var_name: String) -> String {
    let v: Libvar?

    v = LibVarGet(var_name)
    if let v {
        return v.string!
    } //end if
    else {
        return ""
    } //end else
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:152
func LibVarGetValue(_ var_name: String) -> Float {
    let v: Libvar?

    v = LibVarGet(var_name)
    if let v {
        return v.value
    } //end if
    else {
        return 0
    } //end else
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:172
func LibVar(_ var_name: String, _ value: String) -> Libvar? {
    var v: Libvar?
    v = LibVarGet(var_name)
    if v != nil { return v }
    //create new variable
    v = LibVarAlloc(var_name)
    //variable string
    // AI: Raven copies the text into the GetMemory block. The call stays for the count, and the setter keeps the text in the string pool.
    _ = GetMemory(strlen(value) + 1)
    v!.string = value
    //the value
    var string = CharBuf(v!.string!)
    v!.value = LibVarStringValue(&string)
    //variable is modified
    v!.modified = true
    //
    return v
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:195
func LibVarString(_ var_name: String, _ value: String) -> String {
    let v: Libvar?

    v = LibVar(var_name, value)
    return v!.string!
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:208
func LibVarValue(_ var_name: String, _ value: String) -> Float {
    let v: Libvar?

    v = LibVar(var_name, value)
    return v!.value
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:221
func LibVarSet(_ var_name: String, _ value: String) {
    var v: Libvar?

    v = LibVarGet(var_name)
    if v != nil {
        // AI: Raven frees the GetMemory block of the old text. The text is a String in the pool, so the free drops.
    } //end if
    else {
        v = LibVarAlloc(var_name)
    } //end else
    //variable string
    // AI: Raven copies the text into the GetMemory block. The call stays for the count, and the setter keeps the text in the string pool.
    _ = GetMemory(strlen(value) + 1)
    v!.string = value
    //the value
    var string = CharBuf(v!.string!)
    v!.value = LibVarStringValue(&string)
    //variable is modified
    v!.modified = true
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:248
func LibVarChanged(_ var_name: String) -> Bool {
    let v: Libvar?

    v = LibVarGet(var_name)
    if let v {
        return v.modified
    } //end if
    else {
        return false
    } //end else
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_libvar.cpp:268
func LibVarSetNotModified(_ var_name: String) {
    let v: Libvar?

    v = LibVarGet(var_name)
    if let v {
        v.modified = false
    } //end if
}
