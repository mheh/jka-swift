import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's `Maximum(x,y)` of l_utils.h over an `int` and a `float`, which C compares and returns in `float`.
/// Source: oracle/codemp/botlib/l_utils.h:17
private func Maximum(_ x: Int32, _ y: Float) -> Float {
    x > y ? Float(x) : y
}

/// Raven's `Minimum(x,y)` of l_utils.h over an `int` and a `float`, which C compares and returns in `float`.
/// Source: oracle/codemp/botlib/l_utils.h:18
private func Minimum(_ x: Int32, _ y: Float) -> Float {
    x < y ? Float(x) : y
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:43
func FindField(_ defs: Slots<Fielddef>, _ name: String) -> Fielddef? {
    var i: Int32

    i = 0
    while defs[i].name != nil {
        if strcmp(defs[i].name!, name) == 0 { return defs[i] }
        i += 1
    } //end for
    return nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:59
func ReadNumber(_ source: Source, _ fd: Fielddef, _ p: UnsafeMutableRawPointer) -> Bool {
    return Token.scratch { token -> Bool in
        var negative = false
        var intval: Int32, intmin: Int32 = 0, intmax: Int32 = 0
        var floatval: Double

        if PC_ExpectAnyToken(source, token) == 0 { return false }

        //check for minus sign
        if token.type == TT_PUNCTUATION {
            if (fd.type & FT_UNSIGNED) != 0 {
                SourceError(source, "expected unsigned value, found %s", token.string)
                return false
            } //end if
            //if not a minus sign
            if strcmp(token.string, "-") != 0 {
                SourceError(source, "unexpected punctuation %s", token.string)
                return false
            } //end if
            negative = true
            //read the number
            if PC_ExpectAnyToken(source, token) == 0 { return false }
        } //end if
        //check if it is a number
        if token.type != TT_NUMBER {
            SourceError(source, "expected number, found %s", token.string)
            return false
        } //end if
        //check for a float value
        if (token.subtype & TT_FLOAT) != 0 {
            if (fd.type & FT_TYPE) != FT_FLOAT {
                SourceError(source, "unexpected float")
                return false
            } //end if
            floatval = token.floatvalue
            if negative { floatval = -floatval }
            if (fd.type & FT_BOUNDED) != 0 {
                if floatval < Double(fd.floatmin) || floatval > Double(fd.floatmax) {
                    SourceError(source, "float out of range [%f, %f]", fd.floatmin, fd.floatmax)
                    return false
                } //end if
            } //end if
            p[float: 0] = Float(floatval)
            return true
        } //end if
        //
        // C converts the `unsigned long` to the `long` local at the store, with the same bits.
        intval = Int32(bitPattern: token.intvalue)
        if negative { intval = -intval }
        //check bounds
        if (fd.type & FT_TYPE) == FT_CHAR {
            if (fd.type & FT_UNSIGNED) != 0 { intmin = 0; intmax = 255 }
            else { intmin = -128; intmax = 127 }
        } //end if
        if (fd.type & FT_TYPE) == FT_INT {
            if (fd.type & FT_UNSIGNED) != 0 { intmin = 0; intmax = 65535 }
            else { intmin = -32768; intmax = 32767 }
        } //end else if
        if (fd.type & FT_TYPE) == FT_CHAR || (fd.type & FT_TYPE) == FT_INT {
            if (fd.type & FT_BOUNDED) != 0 {
                intmin = Int32(Maximum(intmin, fd.floatmin))
                intmax = Int32(Minimum(intmax, fd.floatmax))
            } //end if
            if intval < intmin || intval > intmax {
                SourceError(source, "value %d out of range [%d, %d]", intval, intmin, intmax)
                return false
            } //end if
        } //end if
        else if (fd.type & FT_TYPE) == FT_FLOAT {
            if (fd.type & FT_BOUNDED) != 0 {
                if intval < fd.floatmin || intval > fd.floatmax {
                    SourceError(source, "value %d out of range [%f, %f]", intval, fd.floatmin, fd.floatmax)
                    return false
                } //end if
            } //end if
        } //end else if
        //store the value
        if (fd.type & FT_TYPE) == FT_CHAR {
            if (fd.type & FT_UNSIGNED) != 0 { p[byte: 0] = Int32(UInt8(truncatingIfNeeded: intval)) }
            else { p[byte: 0] = Int32(Int8(truncatingIfNeeded: intval)) }
        } //end if
        else if (fd.type & FT_TYPE) == FT_INT {
            // AI: Raven stores `(unsigned int) intval` through an `unsigned int *`. The store writes the same bits through the `int` slot.
            if (fd.type & FT_UNSIGNED) != 0 { p[int: 0] = intval }
            else { p[int: 0] = intval }
        } //end else
        else if (fd.type & FT_TYPE) == FT_FLOAT {
            p[float: 0] = Float(intval)
        } //end else
        return true
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:174
func ReadChar(_ source: Source, _ fd: Fielddef, _ p: UnsafeMutableRawPointer) -> Bool {
    return Token.scratch { token -> Bool in
        if PC_ExpectAnyToken(source, token) == 0 { return false }

        //take literals into account
        if token.type == TT_LITERAL {
            StripSingleQuotes(&token.stringBuffer)
            p[byte: 0] = token.stringBuffer[0] as Int32
        } //end if
        else {
            PC_UnreadLastToken(source)
            if !ReadNumber(source, fd, p) { return false }
        } //end if
        return true
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:199
func ReadString(_ source: Source, _ fd: Fielddef, _ p: UnsafeMutableRawPointer) -> Int32 {
    return Token.scratch { token -> Int32 in
        if PC_ExpectTokenType(source, TT_STRING, 0, token) == 0 { return 0 }
        //remove the double quotes
        StripDoubleQuotes(&token.stringBuffer)
        //copy the string
        strncpy(p, token.string, MAX_STRINGFIELD)
        //make sure the string is closed with a zero
        p[byte: MAX_STRINGFIELD - 1] = 0 as Int32
        //
        return 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:219
func ReadStructure(_ source: Source, _ def: Structdef, _ structure: UnsafeMutableRawPointer) -> Int32 {
    return Token.scratch { token -> Int32 in
        var fd: Fielddef?
        var num: Int32

        if PC_ExpectTokenString(source, "{") == 0 { return 0 }
        while true {
            if PC_ExpectAnyToken(source, token) == 0 { return 0 }
            //if end of structure
            if strcmp(token.string, "}") == 0 { break }
            //find the field with the name
            fd = FindField(def.fieldsSlots, token.string)
            if fd == nil {
                SourceError(source, "unknown structure field %s", token.string)
                return 0
            } //end if
            if (fd!.type & FT_ARRAY) != 0 {
                num = fd!.maxarray
                if PC_ExpectTokenString(source, "{") == 0 { return 0 }
            } //end if
            else {
                num = 1
            } //end else
            var p = structure + fd!.offset
            while num > 0 {
                num -= 1
                if (fd!.type & FT_ARRAY) != 0 {
                    if PC_CheckTokenString(source, "}") != 0 { break }
                } //end if
                switch fd!.type & FT_TYPE {
                case FT_CHAR:
                    if !ReadChar(source, fd!, p) { return 0 }
                    p = p + CChar.byteCount
                case FT_INT:
                    if !ReadNumber(source, fd!, p) { return 0 }
                    p = p + Int32.byteCount
                case FT_FLOAT:
                    if !ReadNumber(source, fd!, p) { return 0 }
                    p = p + Float.byteCount
                case FT_STRING:
                    if ReadString(source, fd!, p) == 0 { return 0 }
                    p = p + MAX_STRINGFIELD
                case FT_STRUCT:
                    if fd!.substruct == nil {
                        SourceError(source, "BUG: no sub structure defined")
                        return 0
                    } //end if
                    _ = ReadStructure(source, fd!.substruct!, p)
                    p = p + fd!.substruct!.size
                default:
                    break
                } //end switch
                if (fd!.type & FT_ARRAY) != 0 {
                    if PC_ExpectAnyToken(source, token) == 0 { return 0 }
                    if strcmp(token.string, "}") == 0 { break }
                    if strcmp(token.string, ",") != 0 {
                        SourceError(source, "expected a comma, found %s", token.string)
                        return 0
                    } //end if
                } //end if
            } //end while
        } //end while
        return 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:313
func WriteIndent(_ fp: OpaquePointer?, _ indent: Int32) -> Int32 {
    // WriteStructWithIndent is the one live caller, and its one caller WriteStructure stands only under DEBUG_AI_WEAP.
    // The build does not define DEBUG_AI_WEAP, and the calls of be_ai_weight.cpp:433 to :525 stand under `#if 0`, so this function is dead.
    // Raven assigns his own `indent` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var indent = indent
    var text: CharBuf

    // AI: Raven prints with fprintf and tests for a negative return. The text formats with JKAShared.format, FileBackend.fwrite writes its bytes, and the test reads a short count, because a stream error gives both.
    while indent > 0 {
        indent -= 1
        text = CharBuf(JKAShared.format("\t", []))
        if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
    } //end while
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:327
func WriteFloat(_ fp: OpaquePointer?, _ value: Float) -> Int32 {
    // WriteStructWithIndent is the one live caller, and its one caller WriteStructure stands only under DEBUG_AI_WEAP.
    // The build does not define DEBUG_AI_WEAP, and the calls of be_ai_weight.cpp:433 to :525 stand under `#if 0`, so this function is dead.
    var buf = CharBuf(128)
    var l: Int32
    let text: CharBuf

    strcpy(&buf, JKAShared.format("%f", [value]))
    l = strlen(buf)
    //strip any trailing zeros
    while l > 1 {
        l -= 1
        if buf[l] != Int32(ascii: "0") && buf[l] != Int32(ascii: ".") { break }
        if buf[l] == Int32(ascii: ".") {
            buf[l] = 0
            break
        } //end if
        buf[l] = 0
    } //end while
    //write the float to file
    // AI: Raven prints with fprintf and tests for a negative return. The text formats with JKAShared.format, FileBackend.fwrite writes its bytes, and the test reads a short count, because a stream error gives both.
    text = CharBuf(JKAShared.format("%s", [buf]))
    if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:355
func WriteStructWithIndent(_ fp: OpaquePointer?, _ def: Structdef, _ structure: UnsafeMutableRawPointer, _ indent: Int32) -> Int32 {
    // Port-note: Raven calls this function only from WriteStructure, which no file of either tree calls, so it is dead.
    // Raven assigns his own `indent` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var indent = indent
    var i: Int32, num: Int32
    var p: UnsafeMutableRawPointer
    var fd: Fielddef
    var text: CharBuf

    // AI: Raven prints with fprintf and tests for a negative return. Each text formats with JKAShared.format, FileBackend.fwrite writes its bytes, and the test reads a short count, because a stream error gives both.
    if WriteIndent(fp, indent) == 0 { return 0 }
    text = CharBuf(JKAShared.format("{\r\n", []))
    if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }

    indent += 1
    i = 0
    while def.fieldsSlots[i].name != nil {
        fd = def.fieldsSlots[i]
        if WriteIndent(fp, indent) == 0 { return 0 }
        text = CharBuf(JKAShared.format("%s\t", [fd.name!]))
        if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
        p = structure + fd.offset
        if (fd.type & FT_ARRAY) != 0 {
            num = fd.maxarray
            text = CharBuf(JKAShared.format("{", []))
            if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
        } //end if
        else {
            num = 1
        } //end else
        while num > 0 {
            num -= 1
            switch fd.type & FT_TYPE {
            case FT_CHAR:
                text = CharBuf(JKAShared.format("%d", [p[byte: 0] as Int32]))
                if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
                p = p + CChar.byteCount
            case FT_INT:
                text = CharBuf(JKAShared.format("%d", [p[int: 0]]))
                if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
                p = p + Int32.byteCount
            case FT_FLOAT:
                if WriteFloat(fp, p[float: 0]) == 0 { return 0 }
                p = p + Float.byteCount
            case FT_STRING:
                text = CharBuf(JKAShared.format("\"%s\"", [cString(at: p)]))
                if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
                p = p + MAX_STRINGFIELD
            case FT_STRUCT:
                if WriteStructWithIndent(fp, fd.substruct!, structure, indent) == 0 { return 0 }
                p = p + fd.substruct!.size
            default:
                break
            } //end switch
            if (fd.type & FT_ARRAY) != 0 {
                if num > 0 {
                    text = CharBuf(JKAShared.format(",", []))
                    if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
                } //end if
                else {
                    text = CharBuf(JKAShared.format("}", []))
                    if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
                } //end else
            } //end if
        } //end while
        text = CharBuf(JKAShared.format("\r\n", []))
        if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
        i += 1
    } //end for
    indent -= 1

    if WriteIndent(fp, indent) == 0 { return 0 }
    text = CharBuf(JKAShared.format("}\r\n", []))
    if FileBackend.fwrite(text, at: 0, 1, strlen(text), fp) < strlen(text) { return 0 }
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:441
func WriteStructure(_ fp: OpaquePointer?, _ def: Structdef, _ structure: UnsafeMutableRawPointer) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    return WriteStructWithIndent(fp, def, structure, 0)
}
