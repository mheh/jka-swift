import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/l_script.cpp:69
// Raven wrote: punctuation_t default_punctuations[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/botlib/l_script.cpp:151
var basefolder: JKAShared.CharBuf {
    get { world.variables.basefolder }
    set { world.variables.basefolder = newValue }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:160
func PS_CreatePunctuationTable(_ script: Script, _ punctuations: Slots<Punctuation>) {
    var i: Int32
    var p: Punctuation?
    var lastp: Punctuation?
    var newp: Punctuation

    //get memory for the table
    if script.punctuationtable == nil { script.punctuationtable = Slots(pointers: GetMemory(256 * Int32(UInt.byteCount))!, count: 256) }
    // AI: Raven clears the table through its pointer. The call clears a Slots of bytes over the table.
    Com_Memset(Slots<byte>(scalars: script.punctuationtable!.base, count: 256 * UInt.byteCount), 0, 256 * Int32(UInt.byteCount))
    //add the punctuations in the list to the punctuation table
    i = 0
    while punctuations[i].p != nil {
        newp = punctuations[i]
        lastp = nil
        //sort the punctuations in this table entry on length (longer punctuations first)
        p = script.punctuationtable![UInt32(truncatingIfNeeded: CharBuf(newp.p!)[0] as Int32)]
        while p != nil {
            if strlen(p!.p!) < strlen(newp.p!) {
                newp.next = p
                if lastp != nil {
                    lastp!.next = newp
                } else {
                    script.punctuationtable![UInt32(truncatingIfNeeded: CharBuf(newp.p!)[0] as Int32)] = newp
                }
                break
            } //end if
            lastp = p
            p = p!.next
        } //end for
        if p == nil {
            newp.next = nil
            if lastp != nil {
                lastp!.next = newp
            } else {
                script.punctuationtable![UInt32(truncatingIfNeeded: CharBuf(newp.p!)[0] as Int32)] = newp
            }
        } //end if
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:200
func PunctuationFromNum(_ script: Script, _ num: Int32) -> String {
    var i: Int32

    i = 0
    while script.punctuationsSlots[i].p != nil {
        if script.punctuationsSlots[i].n == num { return script.punctuationsSlots[i].p! }
        i += 1
    } //end for
    return "unkown punctuation"
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:216
func ScriptError(_ script: Script, _ str: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    if (script.flags & SCFL_NOERRORS) != 0 { return }

    strcpy(&text, JKAShared.format(str, args))
    // Port-note: botimport.Print takes Raven's format as an OpaquePointer and has no arguments, so no call can pass his text, row BL1.
    // Raven wrote: botimport.Print(PRT_ERROR, "file %s, line %d: %s\n", script->filename, script->line, text)
    portMissing("ScriptError", source: "oracle/codemp/botlib/l_script.cpp:216")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:242
func ScriptWarning(_ script: Script, _ str: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    if (script.flags & SCFL_NOWARNINGS) != 0 { return }

    strcpy(&text, JKAShared.format(str, args))
    // Port-note: botimport.Print takes Raven's format as an OpaquePointer and has no arguments, so no call can pass his text, row BL1.
    // Raven wrote: botimport.Print(PRT_WARNING, "file %s, line %d: %s\n", script->filename, script->line, text)
    portMissing("ScriptWarning", source: "oracle/codemp/botlib/l_script.cpp:242")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:268
func SetScriptPunctuations(_ script: Script, _ p: Punctuation?) {
    if p != nil {
        PS_CreatePunctuationTable(script, Slots(record: p!))
    } else {
        PS_CreatePunctuationTable(script, default_punctuations)
    }
    if p != nil {
        script.punctuations = p
    } else {
        script.punctuationsSlots = default_punctuations
    }
}

//============================================================================
// Reads spaces, tabs, C-like comments etc.
// When a newline character is found the scripts line counter is increased.
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:285
func PS_ReadWhiteSpace(_ script: Script) -> Int32 {
    while true {
        //skip white space
        while (script.buffer![byte: script.script_p] as Int32) <= Int32(ascii: " ") {
            if (script.buffer![byte: script.script_p] as Int32) == 0 { return 0 }
            if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "\n") { script.line += 1 }
            script.script_p += 1
        } //end while
        //skip comments
        if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "/") {
            //comments //
            if (script.buffer![byte: script.script_p + 1] as Int32) == Int32(ascii: "/") {
                script.script_p += 1
                repeat {
                    script.script_p += 1
                    if (script.buffer![byte: script.script_p] as Int32) == 0 { return 0 }
                } while (script.buffer![byte: script.script_p] as Int32) != Int32(ascii: "\n") //end do
                script.line += 1
                script.script_p += 1
                if (script.buffer![byte: script.script_p] as Int32) == 0 { return 0 }
                continue
            } //end if
            //comments /* */
            else if (script.buffer![byte: script.script_p + 1] as Int32) == Int32(ascii: "*") {
                script.script_p += 1
                repeat {
                    script.script_p += 1
                    if (script.buffer![byte: script.script_p] as Int32) == 0 { return 0 }
                    if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "\n") { script.line += 1 }
                } while !((script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "*") && (script.buffer![byte: script.script_p + 1] as Int32) == Int32(ascii: "/")) //end do
                script.script_p += 1
                if (script.buffer![byte: script.script_p] as Int32) == 0 { return 0 }
                script.script_p += 1
                if (script.buffer![byte: script.script_p] as Int32) == 0 { return 0 }
                continue
            } //end if
        } //end if
        break
    } //end while
    return 1
}

//============================================================================
// Reads an escape character.
//
// Parameter:				script		: script to read from
//								ch				: place to store the read escape character
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:344
func PS_ReadEscapeCharacter(_ script: Script, _ ch: inout JKAShared.CharBuf) -> Int32 {
    var c: Int32
    var val: Int32
    var i: Int32

    //step over the leading '\\'
    script.script_p += 1
    //determine the escape character
    switch (script.buffer![byte: script.script_p] as Int32) {
    case Int32(ascii: "\\"): c = Int32(ascii: "\\")
    case Int32(ascii: "n"): c = Int32(ascii: "\n")
    case Int32(ascii: "r"): c = Int32(ascii: "\r")
    case Int32(ascii: "t"): c = Int32(ascii: "\t")
    case Int32(ascii: "v"): c = Int32(ascii: "\u{0B}")
    case Int32(ascii: "b"): c = Int32(ascii: "\u{08}")
    case Int32(ascii: "f"): c = Int32(ascii: "\u{0C}")
    case Int32(ascii: "a"): c = Int32(ascii: "\u{07}")
    case Int32(ascii: "'"): c = Int32(ascii: "'")
    case Int32(ascii: "\""): c = Int32(ascii: "\"")
    case Int32(ascii: "?"): c = Int32(ascii: "?")
    case Int32(ascii: "x"):
        script.script_p += 1
        i = 0
        val = 0
        while true {
            c = script.buffer![byte: script.script_p]
            if c >= Int32(ascii: "0") && c <= Int32(ascii: "9") {
                c = c - Int32(ascii: "0")
            } else if c >= Int32(ascii: "A") && c <= Int32(ascii: "Z") {
                c = c - Int32(ascii: "A") + 10
            } else if c >= Int32(ascii: "a") && c <= Int32(ascii: "z") {
                c = c - Int32(ascii: "a") + 10
            } else {
                break
            }
            val = (val << 4) + c
            i += 1
            script.script_p += 1
        } //end for
        script.script_p -= 1
        if val > 0xFF {
            ScriptWarning(script, "too large value in escape character")
            val = 0xFF
        } //end if
        c = val
    //end case
    default: //NOTE: decimal ASCII code, NOT octal
        if (script.buffer![byte: script.script_p] as Int32) < Int32(ascii: "0") || (script.buffer![byte: script.script_p] as Int32) > Int32(ascii: "9") {
            ScriptError(script, "unknown escape char")
        }
        i = 0
        val = 0
        while true {
            c = script.buffer![byte: script.script_p]
            if c >= Int32(ascii: "0") && c <= Int32(ascii: "9") {
                c = c - Int32(ascii: "0")
            } else {
                break
            }
            val = val * 10 + c
            i += 1
            script.script_p += 1
        } //end for
        script.script_p -= 1
        if val > 0xFF {
            ScriptWarning(script, "too large value in escape character")
            val = 0xFF
        } //end if
        c = val
    //end default
    } //end switch
    //step over the escape character or the last digit of the number
    script.script_p += 1
    //store the escape character
    ch[0] = c
    //succesfully read escape character
    return 1
}

//============================================================================
// Reads C-like string. Escape characters are interpretted.
// Quotes are included with the string.
// Reads two strings with a white space between them as one string.
//
// Parameter:				script		: script to read from
//								token			: buffer to store the string
// Returns:					qtrue when a string was read succesfully
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:422
func PS_ReadString(_ script: Script, _ token: Token, _ quote: Int32) -> Int32 {
    var len: Int32
    var tmpline: Int32
    var tmpscript_p: Int32

    if quote == Int32(ascii: "\"") {
        token.type = TT_STRING
    } else {
        token.type = TT_LITERAL
    }

    len = 0
    //leading quote
    token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
    len += 1
    script.script_p += 1
    //
    while true {
        //minus 2 because trailing double quote and zero have to be appended
        if len >= MAX_TOKEN - 2 {
            ScriptError(script, "string longer than MAX_TOKEN = %d", MAX_TOKEN)
            return 0
        } //end if
        //if there is an escape character and
        //if escape characters inside a string are allowed
        if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "\\") && (script.flags & SCFL_NOSTRINGESCAPECHARS) == 0 {
            // Port-note: PS_ReadEscapeCharacter takes `ch` as an inout CharBuf, so no call can pass the address of `token->string[len]`, row BL10.
            // Raven wrote: if (!PS_ReadEscapeCharacter(script, &token->string[len])) { token->string[len] = 0; return 0; }
            portMissing("PS_ReadString", source: "oracle/codemp/botlib/l_script.cpp:422")
            len += 1
        } //end if
        //if a trailing quote
        else if (script.buffer![byte: script.script_p] as Int32) == quote {
            //step over the double quote
            script.script_p += 1
            //if white spaces in a string are not allowed
            if (script.flags & SCFL_NOSTRINGWHITESPACES) != 0 { break }
            //
            tmpscript_p = script.script_p
            tmpline = script.line
            //read unusefull stuff between possible two following strings
            if PS_ReadWhiteSpace(script) == 0 {
                script.script_p = tmpscript_p
                script.line = tmpline
                break
            } //end if
            //if there's no leading double qoute
            if (script.buffer![byte: script.script_p] as Int32) != quote {
                script.script_p = tmpscript_p
                script.line = tmpline
                break
            } //end if
            //step over the new leading double quote
            script.script_p += 1
        } //end if
        else {
            if (script.buffer![byte: script.script_p] as Int32) == 0 {
                token.stringBuffer[len] = 0
                ScriptError(script, "missing trailing quote")
                return 0
            } //end if
            if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "\n") {
                token.stringBuffer[len] = 0
                ScriptError(script, "newline inside string %s", token.string)
                return 0
            } //end if
            token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
            len += 1
            script.script_p += 1
        } //end else
    } //end while
    //trailing quote
    token.stringBuffer[len] = quote
    len += 1
    //end string with a zero
    token.stringBuffer[len] = 0
    //the sub type is the length of the string
    token.subtype = len
    return 1
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:511
func PS_ReadName(_ script: Script, _ token: Token) -> Int32 {
    var len: Int32 = 0
    var c: CChar

    token.type = TT_NAME
    repeat {
        token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
        len += 1
        script.script_p += 1
        if len >= MAX_TOKEN {
            ScriptError(script, "name longer than MAX_TOKEN = %d", MAX_TOKEN)
            return 0
        } //end if
        c = script.buffer![byte: script.script_p]
    } while (c >= Int32(ascii: "a") && c <= Int32(ascii: "z")) ||
        (c >= Int32(ascii: "A") && c <= Int32(ascii: "Z")) ||
        (c >= Int32(ascii: "0") && c <= Int32(ascii: "9")) ||
        c == Int32(ascii: "_")
    token.stringBuffer[len] = 0
    //the sub type is the length of the name
    token.subtype = len
    return 1
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:541
func NumberValue(_ string: inout JKAShared.CharBuf, _ subtype: Int32, _ intvalue: inout UInt32, _ floatvalue: inout Double) {
    var dotfound: UInt32 = 0
    // Raven steps his own `string` parameter through its bytes, so the body holds the byte offset of his pointer.
    var stringIndex: Int32 = 0

    intvalue = 0
    floatvalue = 0
    //floating point number
    if (subtype & TT_FLOAT) != 0 {
        while string[stringIndex] != 0 {
            if (string[stringIndex] as Int32) == Int32(ascii: ".") {
                if dotfound != 0 { return }
                dotfound = 10
                stringIndex += 1
            } //end if
            if dotfound != 0 {
                floatvalue = floatvalue + Double((string[stringIndex] as Int32) - Int32(ascii: "0")) /
                    Double(dotfound)
                dotfound *= 10
            } //end if
            else {
                floatvalue = floatvalue * 10.0 + Double((string[stringIndex] as Int32) - Int32(ascii: "0"))
            } //end else
            stringIndex += 1
        } //end while
        intvalue = UInt32(floatvalue)
    } //end if
    else if (subtype & TT_DECIMAL) != 0 {
        while string[stringIndex] != 0 {
            // C converts the `int` digit to `unsigned` at the add.
            intvalue = intvalue * 10 + UInt32(bitPattern: (string[stringIndex] as Int32) - Int32(ascii: "0"))
            stringIndex += 1
        }
        floatvalue = Double(intvalue)
    } //end else if
    else if (subtype & TT_HEX) != 0 {
        //step over the leading 0x or 0X
        stringIndex += 2
        while string[stringIndex] != 0 {
            intvalue <<= 4
            // C converts the `int` digit to `unsigned` at each add.
            if (string[stringIndex] as Int32) >= Int32(ascii: "a") && (string[stringIndex] as Int32) <= Int32(ascii: "f") {
                intvalue += UInt32(bitPattern: (string[stringIndex] as Int32) - Int32(ascii: "a") + 10)
            } else if (string[stringIndex] as Int32) >= Int32(ascii: "A") && (string[stringIndex] as Int32) <= Int32(ascii: "F") {
                intvalue += UInt32(bitPattern: (string[stringIndex] as Int32) - Int32(ascii: "A") + 10)
            } else {
                intvalue += UInt32(bitPattern: (string[stringIndex] as Int32) - Int32(ascii: "0"))
            }
            stringIndex += 1
        } //end while
        floatvalue = Double(intvalue)
    } //end else if
    else if (subtype & TT_OCTAL) != 0 {
        //step over the first zero
        stringIndex += 1
        while string[stringIndex] != 0 {
            // C converts the `int` digit to `unsigned` at the add.
            intvalue = (intvalue << 3) + UInt32(bitPattern: (string[stringIndex] as Int32) - Int32(ascii: "0"))
            stringIndex += 1
        }
        floatvalue = Double(intvalue)
    } //end else if
    else if (subtype & TT_BINARY) != 0 {
        //step over the leading 0b or 0B
        stringIndex += 2
        while string[stringIndex] != 0 {
            // C converts the `int` digit to `unsigned` at the add.
            intvalue = (intvalue << 1) + UInt32(bitPattern: (string[stringIndex] as Int32) - Int32(ascii: "0"))
            stringIndex += 1
        }
        floatvalue = Double(intvalue)
    } //end else if
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:613
func PS_ReadNumber(_ script: Script, _ token: Token) -> Int32 {
    var len: Int32 = 0
    var i: Int32
    var octal: Int32
    var dot: Int32
    var c: CChar
//	unsigned long int intvalue = 0;
//	long double floatvalue = 0;

    token.type = TT_NUMBER
    //check for a hexadecimal number
    if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "0") &&
        ((script.buffer![byte: script.script_p + 1] as Int32) == Int32(ascii: "x") ||
        (script.buffer![byte: script.script_p + 1] as Int32) == Int32(ascii: "X")) {
        token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
        len += 1
        script.script_p += 1
        token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
        len += 1
        script.script_p += 1
        c = script.buffer![byte: script.script_p]
        //hexadecimal
        while (c >= Int32(ascii: "0") && c <= Int32(ascii: "9")) ||
            (c >= Int32(ascii: "a") && c <= Int32(ascii: "f")) ||
            (c >= Int32(ascii: "A") && c <= Int32(ascii: "A")) {
            token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
            len += 1
            script.script_p += 1
            if len >= MAX_TOKEN {
                ScriptError(script, "hexadecimal number longer than MAX_TOKEN = %d", MAX_TOKEN)
                return 0
            } //end if
            c = script.buffer![byte: script.script_p]
        } //end while
        token.subtype |= TT_HEX
    } //end if
    //check for a binary number
    else if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "0") &&
        ((script.buffer![byte: script.script_p + 1] as Int32) == Int32(ascii: "b") ||
        (script.buffer![byte: script.script_p + 1] as Int32) == Int32(ascii: "B")) {
        token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
        len += 1
        script.script_p += 1
        token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
        len += 1
        script.script_p += 1
        c = script.buffer![byte: script.script_p]
        //binary
        while c == Int32(ascii: "0") || c == Int32(ascii: "1") {
            token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
            len += 1
            script.script_p += 1
            if len >= MAX_TOKEN {
                ScriptError(script, "binary number longer than MAX_TOKEN = %d", MAX_TOKEN)
                return 0
            } //end if
            c = script.buffer![byte: script.script_p]
        } //end while
        token.subtype |= TT_BINARY
    } //end if
    else { //decimal or octal integer or floating point number
        octal = 0
        dot = 0
        if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "0") { octal = 1 }
        while true {
            c = script.buffer![byte: script.script_p]
            if c == Int32(ascii: ".") {
                dot = 1
            } else if c == Int32(ascii: "8") || c == Int32(ascii: "9") {
                octal = 0
            } else if c < Int32(ascii: "0") || c > Int32(ascii: "9") {
                break
            }
            token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
            len += 1
            script.script_p += 1
            if len >= MAX_TOKEN - 1 {
                ScriptError(script, "number longer than MAX_TOKEN = %d", MAX_TOKEN)
                return 0
            } //end if
        } //end while
        if octal != 0 {
            token.subtype |= TT_OCTAL
        } else {
            token.subtype |= TT_DECIMAL
        }
        if dot != 0 { token.subtype |= TT_FLOAT }
    } //end else
    i = 0
    while i < 2 {
        c = script.buffer![byte: script.script_p]
        //check for a LONG number
        if (c == Int32(ascii: "l") || c == Int32(ascii: "L")) // bk001204 - brackets
            && (token.subtype & TT_LONG) == 0 {
            script.script_p += 1
            token.subtype |= TT_LONG
        } //end if
        //check for an UNSIGNED number
        else if (c == Int32(ascii: "u") || c == Int32(ascii: "U")) // bk001204 - brackets
            && (token.subtype & (TT_UNSIGNED | TT_FLOAT)) == 0 {
            script.script_p += 1
            token.subtype |= TT_UNSIGNED
        } //end if
        i += 1
    } //end for
    token.stringBuffer[len] = 0
    NumberValue(&token.stringBuffer, token.subtype, &token.intvalue, &token.floatvalue)
    if (token.subtype & TT_FLOAT) == 0 { token.subtype |= TT_INTEGER }
    return 1
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:721
func PS_ReadLiteral(_ script: Script, _ token: Token) -> Int32 {
    // Port-note: Raven's one call, at l_script.cpp:870, is a comment, so the function is dead.
    // TODO: Port PS_ReadLiteral
    portMissing("PS_ReadLiteral", source: "oracle/codemp/botlib/l_script.cpp:721")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:768
func PS_ReadPunctuation(_ script: Script, _ token: Token) -> Int32 {
    var len: Int32
    var p: String
    var punc: Punctuation?

    punc = script.punctuationtable![UInt32(truncatingIfNeeded: script.buffer![byte: script.script_p] as Int32)]
    while punc != nil {
        p = punc!.p!
        len = strlen(p)
        //if the script contains at least as much characters as the punctuation
        if script.script_p + len <= script.end_p {
            //if the script contains the punctuation
            // Port-note: No strncmp form compares the bytes of a Slots of bytes at an offset with a text, so the test of `script_p` has no call, row BL9.
            // Raven wrote: if (!strncmp(script->script_p, p, len))
            portMissing("PS_ReadPunctuation", source: "oracle/codemp/botlib/l_script.cpp:768")
            strncpy(&token.stringBuffer, p, MAX_TOKEN)
            script.script_p += len
            token.type = TT_PUNCTUATION
            //sub type is the number of the punctuation
            token.subtype = punc!.n
            return 1
        } //end if
        punc = punc!.next
    } //end for
    return 0
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:809
func PS_ReadPrimitive(_ script: Script, _ token: Token) -> Int32 {
    var len: Int32

    len = 0
    while (script.buffer![byte: script.script_p] as Int32) > Int32(ascii: " ") && (script.buffer![byte: script.script_p] as Int32) != Int32(ascii: ";") {
        if len >= MAX_TOKEN {
            ScriptError(script, "primitive token longer than MAX_TOKEN = %d", MAX_TOKEN)
            return 0
        } //end if
        token.stringBuffer[len] = (script.buffer![byte: script.script_p] as Int8)
        len += 1
        script.script_p += 1
    } //end while
    // Port-note: Raven writes the NUL one byte past the string when the token fills all MAX_TOKEN bytes.
    // The subscript traps there.
    token.stringBuffer[len] = 0
    //copy the token into the script structure
    script.token.copy(from: token)
    //primitive reading successfull
    return 1
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:835
func PS_ReadToken(_ script: Script, _ token: Token) -> Int32 {
    //if there is a token available (from UnreadToken)
    if script.tokenavailable != 0 {
        script.tokenavailable = 0
        token.copy(from: script.token)
        return 1
    } //end if
    //save script pointer
    script.lastscript_p = script.script_p
    //save line counter
    script.lastline = script.line
    //clear the token stuff
    token.clear()
    //start of the white space
    script.whitespace_p = script.script_p
    token.whitespace_p = script.script_p
    //read unusefull stuff
    if PS_ReadWhiteSpace(script) == 0 { return 0 }
    //end of the white space
    script.endwhitespace_p = script.script_p
    token.endwhitespace_p = script.script_p
    //line the token is on
    token.line = script.line
    //number of lines crossed before token
    token.linescrossed = script.line - script.lastline
    //if there is a leading double quote
    if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "\"") {
        if PS_ReadString(script, token, Int32(ascii: "\"")) == 0 { return 0 }
    } //end if
    //if an literal
    else if (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "'") {
        //if (!PS_ReadLiteral(script, token)) return 0;
        if PS_ReadString(script, token, Int32(ascii: "'")) == 0 { return 0 }
    } //end if
    //if there is a number
    else if ((script.buffer![byte: script.script_p] as Int32) >= Int32(ascii: "0") && (script.buffer![byte: script.script_p] as Int32) <= Int32(ascii: "9")) ||
        ((script.buffer![byte: script.script_p] as Int32) == Int32(ascii: ".") &&
        ((script.buffer![byte: script.script_p + 1] as Int32) >= Int32(ascii: "0") && (script.buffer![byte: script.script_p + 1] as Int32) <= Int32(ascii: "9"))) {
        if PS_ReadNumber(script, token) == 0 { return 0 }
    } //end if
    //if this is a primitive script
    else if (script.flags & SCFL_PRIMITIVE) != 0 {
        return PS_ReadPrimitive(script, token)
    } //end else if
    //if there is a name
    else if ((script.buffer![byte: script.script_p] as Int32) >= Int32(ascii: "a") && (script.buffer![byte: script.script_p] as Int32) <= Int32(ascii: "z")) ||
        ((script.buffer![byte: script.script_p] as Int32) >= Int32(ascii: "A") && (script.buffer![byte: script.script_p] as Int32) <= Int32(ascii: "Z")) ||
        (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "_") || (script.buffer![byte: script.script_p] as Int32) == Int32(ascii: "@") {
        if PS_ReadName(script, token) == 0 { return 0 }
    } //end if
    //check for punctuations
    else if PS_ReadPunctuation(script, token) == 0 {
        ScriptError(script, "can't read token")
        return 0
    } //end if
    //copy the token into the script structure
    script.token.copy(from: token)
    //succesfully read a token
    return 1
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:909
func PS_ExpectTokenString(_ script: Script, _ string: String) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port PS_ExpectTokenString
    portMissing("PS_ExpectTokenString", source: "oracle/codemp/botlib/l_script.cpp:909")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:932
func PS_ExpectTokenType(_ script: Script, _ type: Int32, _ subtype: Int32, _ token: Token) -> Int32 {
    var str = CharBuf(MAX_TOKEN)

    if PS_ReadToken(script, token) == 0 {
        ScriptError(script, "couldn't read expected token")
        return 0
    } //end if

    if token.type != type {
        if type == TT_STRING { strcpy(&str, "string") }
        if type == TT_LITERAL { strcpy(&str, "literal") }
        if type == TT_NUMBER { strcpy(&str, "number") }
        if type == TT_NAME { strcpy(&str, "name") }
        if type == TT_PUNCTUATION { strcpy(&str, "punctuation") }
        ScriptError(script, "expected a %s, found %s", str, token.string)
        return 0
    } //end if
    if token.type == TT_NUMBER {
        if (token.subtype & subtype) != subtype {
            if (subtype & TT_DECIMAL) != 0 { strcpy(&str, "decimal") }
            if (subtype & TT_HEX) != 0 { strcpy(&str, "hex") }
            if (subtype & TT_OCTAL) != 0 { strcpy(&str, "octal") }
            if (subtype & TT_BINARY) != 0 { strcpy(&str, "binary") }
            if (subtype & TT_LONG) != 0 { strcat(&str, " long") }
            if (subtype & TT_UNSIGNED) != 0 { strcat(&str, " unsigned") }
            if (subtype & TT_FLOAT) != 0 { strcat(&str, " float") }
            if (subtype & TT_INTEGER) != 0 { strcat(&str, " integer") }
            ScriptError(script, "expected %s, found %s", str, token.string)
            return 0
        } //end if
    } //end if
    else if token.type == TT_PUNCTUATION {
        if subtype < 0 {
            ScriptError(script, "BUG: wrong punctuation subtype")
            return 0
        } //end if
        if token.subtype != subtype {
            // Port-note: Raven passes the whole record to the %s, so the format reads the text pointer of its first field.
            // The port names that field.
            ScriptError(script, "expected %s, found %s",
                script.punctuationsSlots[subtype].p!, token.string)
            return 0
        } //end if
    } //end else if
    return 1
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:990
func PS_ExpectAnyToken(_ script: Script, _ token: Token) -> Int32 {
    if PS_ReadToken(script, token) == 0 {
        ScriptError(script, "couldn't read expected token")
        return 0
    } //end if
    else {
        return 1
    } //end else
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1008
func PS_CheckTokenString(_ script: Script, _ string: String) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port PS_CheckTokenString
    portMissing("PS_CheckTokenString", source: "oracle/codemp/botlib/l_script.cpp:1008")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1025
func PS_CheckTokenType(_ script: Script, _ type: Int32, _ subtype: Int32, _ token: Token) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port PS_CheckTokenType
    portMissing("PS_CheckTokenType", source: "oracle/codemp/botlib/l_script.cpp:1025")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1047
func PS_SkipUntilString(_ script: Script, _ string: String) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port PS_SkipUntilString
    portMissing("PS_SkipUntilString", source: "oracle/codemp/botlib/l_script.cpp:1047")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1063
func PS_UnreadLastToken(_ script: Script) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port PS_UnreadLastToken
    portMissing("PS_UnreadLastToken", source: "oracle/codemp/botlib/l_script.cpp:1063")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1073
func PS_UnreadToken(_ script: Script, _ token: Token) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port PS_UnreadToken
    portMissing("PS_UnreadToken", source: "oracle/codemp/botlib/l_script.cpp:1073")
}

//============================================================================
// returns the next character of the read white space, returns NULL if none
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1085
func PS_NextWhiteSpaceChar(_ script: Script) -> CChar {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port PS_NextWhiteSpaceChar
    portMissing("PS_NextWhiteSpaceChar", source: "oracle/codemp/botlib/l_script.cpp:1085")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1102
func StripDoubleQuotes(_ string: inout JKAShared.CharBuf) {
    if string[0] == Int32(ascii: "\"") {
        // Port-note: Raven's strcpy copies the text over its own source, which C leaves undefined.
        // The copy reads the bytes after the quote first, so the text moves one byte to the left.
        strcpy(&string, string[1...])
    } //end if
    // Port-note: Raven reads the byte before the text when the text is empty.
    // The subscript traps there.
    if string[strlen(string) - 1] == Int32(ascii: "\"") {
        string[strlen(string) - 1] = 0
    } //end if
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1119
func StripSingleQuotes(_ string: inout JKAShared.CharBuf) {
    if string[0] == Int32(ascii: "'") {
        // Port-note: Raven's strcpy copies the text over its own source, which C leaves undefined.
        // The copy reads the bytes after the quote first, so the text moves one byte to the left.
        strcpy(&string, string[1...])
    } //end if
    // Port-note: Raven reads the byte before the text when the text is empty.
    // The subscript traps there.
    if string[strlen(string) - 1] == Int32(ascii: "'") {
        string[strlen(string) - 1] = 0
    } //end if
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1136
func ReadSignedFloat(_ script: Script) -> Double {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port ReadSignedFloat
    portMissing("ReadSignedFloat", source: "oracle/codemp/botlib/l_script.cpp:1136")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1159
func ReadSignedInt(_ script: Script) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port ReadSignedInt
    portMissing("ReadSignedInt", source: "oracle/codemp/botlib/l_script.cpp:1159")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1182
func SetScriptFlags(_ script: Script, _ flags: Int32) {
    script.flags = flags
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1192
func GetScriptFlags(_ script: Script) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port GetScriptFlags
    portMissing("GetScriptFlags", source: "oracle/codemp/botlib/l_script.cpp:1192")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1202
func ResetScript(_ script: Script) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port ResetScript
    portMissing("ResetScript", source: "oracle/codemp/botlib/l_script.cpp:1202")
}

//============================================================================
// returns true if at the end of the script
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1227
func EndOfScript(_ script: Script) -> Int32 {
    return script.script_p >= script.end_p ? 1 : 0
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1237
func NumLinesCrossed(_ script: Script) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port NumLinesCrossed
    portMissing("NumLinesCrossed", source: "oracle/codemp/botlib/l_script.cpp:1237")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1247
func ScriptSkipTo(_ script: Script, _ value: String) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port ScriptSkipTo
    portMissing("ScriptSkipTo", source: "oracle/codemp/botlib/l_script.cpp:1247")
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1293
func LoadScriptFile(_ filename: String) -> Script? {
    var fp: fileHandle_t
    var pathname = CharBuf(MAX_QPATH)
    var length: Int32

    if strlen(basefolder) != 0 {
        Com_sprintf(&pathname, Int32(pathname.count), "%s/%s", basefolder, filename)
    } else {
        Com_sprintf(&pathname, Int32(pathname.count), "%s", filename)
    }
    // Port-note: botimport.FS_FOpenFile takes the handle out-parameter as an OpaquePointer, so no call can pass the address of `fp`, row BL1.
    // Raven wrote: length = botimport.FS_FOpenFile( pathname, &fp, FS_READ );
    portMissing("LoadScriptFile", source: "oracle/codemp/botlib/l_script.cpp:1293")
    if fp == 0 { return nil }

    let buffer = GetClearedMemory(Int32(Script.byteCount) + length + 1)
    let script = Script(buffer)
    script.clear()
    strcpy(&script.filenameBuffer, filename)
    script.buffer = Slots(scalars: buffer + Script.byteCount, count: Int(length) + 1)
    // AI: Raven stores the NUL before the length. The store follows the length, because the view reads the count of `buffer` from `length`.
    script.length = length
    script.buffer![length] = 0
    //pointer in script buffer
    script.script_p = 0
    //pointer in script buffer before reading token
    script.lastscript_p = 0
    //pointer to end of script buffer
    script.end_p = length
    //set if there's a token available in script->token
    script.tokenavailable = 0
    //
    script.line = 1
    script.lastline = 1
    //
    SetScriptPunctuations(script, nil)
    //
    // Port-note: botimport.FS_Read takes the buffer as an OpaquePointer, so no call can pass the bytes of `script->buffer`, row BL1.
    // Raven wrote: botimport.FS_Read(script->buffer, length, fp);
    portMissing("LoadScriptFile", source: "oracle/codemp/botlib/l_script.cpp:1293")
    botimport.runFS_FCloseFile(fp)
    //
    // Port-note: COM_Compress takes an inout CharBuf, so no call can pass the Slots of bytes of `script->buffer`, row BL11.
    // Raven wrote: script->length = COM_Compress(script->buffer);
    portMissing("LoadScriptFile", source: "oracle/codemp/botlib/l_script.cpp:1293")

    return script
}

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1362
func LoadScriptMemory(_ ptr: String, _ length: Int32, _ name: String) -> Script? {
    let buffer = GetClearedMemory(Int32(Script.byteCount) + length + 1)
    let script = Script(buffer)
    script.clear()
    strcpy(&script.filenameBuffer, name)
    script.buffer = Slots(scalars: buffer + Script.byteCount, count: Int(length) + 1)
    // AI: Raven stores the NUL before the length. The store follows the length, because the view reads the count of `buffer` from `length`.
    script.length = length
    script.buffer![length] = 0
    //pointer in script buffer
    script.script_p = 0
    //pointer in script buffer before reading token
    script.lastscript_p = 0
    //pointer to end of script buffer
    script.end_p = length
    //set if there's a token available in script->token
    script.tokenavailable = 0
    //
    script.line = 1
    script.lastline = 1
    //
    SetScriptPunctuations(script, nil)
    //
    Com_Memcpy(script.buffer!, CharBuf(ptr), length)
    //
    return script
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1398
func FreeScript(_ script: Script) {
    if script.punctuationtable != nil { FreeMemory(OpaquePointer(script.punctuationtable!.base)) }
    FreeMemory(script.handle)
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_script.cpp:1411
func PS_SetBaseFolder(_ path: String) {
    Com_sprintf(&basefolder, Int32(basefolder.count), path)
}
