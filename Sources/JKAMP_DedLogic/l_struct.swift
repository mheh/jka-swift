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
        // Port-note: No strncpy takes a raw destination, so the text has no form into the `char [MAX_STRINGFIELD]` field at `p`, row BL3.
        // Raven wrote: strncpy((char *) p, token.string, MAX_STRINGFIELD)
        portMissing("ReadString", source: "oracle/codemp/botlib/l_struct.cpp:207")
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
    // Port-note: FileBackend has no fprintf, so no call writes the tab to the stream, row BL2.
    // TODO: Port WriteIndent
    portMissing("WriteIndent", source: "oracle/codemp/botlib/l_struct.cpp:313")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_struct.cpp:327
func WriteFloat(_ fp: OpaquePointer?, _ value: Float) -> Int32 {
    // Port-note: FileBackend has no fprintf, so no call writes the text of the float to the stream, row BL2.
    // TODO: Port WriteFloat
    portMissing("WriteFloat", source: "oracle/codemp/botlib/l_struct.cpp:327")
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
    // TODO: Port WriteStructWithIndent
    portMissing("WriteStructWithIndent", source: "oracle/codemp/botlib/l_struct.cpp:355")
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
    // TODO: Port WriteStructure
    portMissing("WriteStructure", source: "oracle/codemp/botlib/l_struct.cpp:441")
}
