import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_ai_char.cpp:30
private let MAX_CHARACTERISTICS = 80 as Int32

/// Source: oracle/codemp/botlib/be_ai_char.cpp:32
let CT_INTEGER = 1 as Int32

/// Source: oracle/codemp/botlib/be_ai_char.cpp:33
let CT_FLOAT = 2 as Int32

/// Source: oracle/codemp/botlib/be_ai_char.cpp:34
let CT_STRING = 3 as Int32

/// Source: oracle/codemp/botlib/be_ai_char.cpp:36
let DEFAULT_CHARACTER = "bots/default_c.c"

/// Source: oracle/codemp/botlib/be_ai_char.cpp:60
var botcharacters: Slots<BotCharacter?> { world.storage.botcharacters }

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:68
func BotCharacterFromHandle(_ handle: Int32) -> BotCharacter? {
    if handle <= 0 || handle > MAX_CLIENTS {
        botimport.runPrint(PRT_FATAL, "character handle %d out of range\n", handle)
        return nil
    }
    if botcharacters[handle] == nil {
        botimport.runPrint(PRT_FATAL, "invalid character %d\n", handle)
        return nil
    }
    return botcharacters[handle]
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:88
func BotDumpCharacter(_ ch: BotCharacter) {
    var i: Int32

    Log_Write("%s", ch.filename)
    // Port-note: Raven passes the float `skill` to a `%d`, which reads the bits of a double as an int, undefined.
    // The port passes the integer part of the skill.
    Log_Write("skill %d\n", Int32(ch.skill))
    Log_Write("{\n")
    i = 0
    while i < MAX_CHARACTERISTICS {
        switch ch.c[i].type {
        case CT_INTEGER: Log_Write(" %4d %d\n", i, ch.c[i].value.integer)
        case CT_FLOAT: Log_Write(" %4d %f\n", i, ch.c[i].value._float)
        case CT_STRING: Log_Write(" %4d %s\n", i, ch.c[i].value.string!)
        default: break
        } //end case
        i += 1
    }
    Log_Write("}\n")
}

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:112
func BotFreeCharacterStrings(_ ch: BotCharacter) {
    var i: Int32

    i = 0
    while i < MAX_CHARACTERISTICS {
        if Int32(ch.c[i].type) == CT_STRING {
            // AI: Raven frees the GetMemory block of the text. The field holds a pooled text, so the free drops.
        }
        i += 1
    }
}

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:130
func BotFreeCharacter2(_ handle: Int32) {
    if handle <= 0 || handle > MAX_CLIENTS {
        botimport.runPrint(PRT_FATAL, "character handle %d out of range\n", handle)
        return
    }
    if botcharacters[handle] == nil {
        botimport.runPrint(PRT_FATAL, "invalid character %d\n", handle)
        return
    }
    BotFreeCharacterStrings(botcharacters[handle]!)
    FreeMemory(botcharacters[handle]!.handle)
    botcharacters[handle] = nil
}

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:152
func BotFreeCharacter(_ handle: Int32) {
    if LibVarGetValue("bot_reloadcharacters") == 0 { return }
    BotFreeCharacter2(handle)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:163
func BotDefaultCharacteristics(_ ch: BotCharacter, _ defaultch: BotCharacter) {
    var i: Int32

    i = 0
    while i < MAX_CHARACTERISTICS {
        if ch.c[i].type != 0 {
            i += 1
            continue
        }
        //
        if Int32(defaultch.c[i].type) == CT_FLOAT {
            ch.c[i].type = CT_FLOAT
            ch.c[i].value._float = defaultch.c[i].value._float
        } else if Int32(defaultch.c[i].type) == CT_INTEGER {
            ch.c[i].type = CT_INTEGER
            ch.c[i].value.integer = defaultch.c[i].value.integer
        } else if Int32(defaultch.c[i].type) == CT_STRING {
            ch.c[i].type = CT_STRING
            // AI: Raven copies the text into a GetMemory block. The call stays for the zone count, and the field takes the text.
            _ = GetMemory(strlen(defaultch.c[i].value.string!) + 1)
            ch.c[i].value.string = defaultch.c[i].value.string
        }
        i += 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:195
func BotLoadCharacterFromFile(_ charfile: inout JKAShared.CharBuf, _ skill: Int32) -> BotCharacter? {
    var foundcharacter: Bool
    let ch: BotCharacter

    foundcharacter = false
    //a bot character is parsed in two phases
    PC_SetBaseFolder(BOTFILESBASEFOLDER)
    guard let source = LoadSourceFile(String(charfile)) else {
        botimport.runPrint(PRT_ERROR, "counldn't load %s\n", String(charfile))
        return nil
    }
    ch = BotCharacter(GetClearedMemory(UInt32(Int32(BotCharacter.byteCount) + MAX_CHARACTERISTICS * Int32(BotCharacteristic.byteCount))))
    strcpy(&ch.filenameBuffer, charfile)
    return Token.scratch { token -> BotCharacter? in
        var indent: Int32, index: Int32

        while PC_ReadToken(source, token) != 0 {
            if strcmp(token.string, "skill") == 0 {
                if PC_ExpectTokenType(source, TT_NUMBER, 0, token) == 0 {
                    FreeSource(source)
                    BotFreeCharacterStrings(ch)
                    FreeMemory(ch.handle)
                    return nil
                }
                if PC_ExpectTokenString(source, "{") == 0 {
                    FreeSource(source)
                    BotFreeCharacterStrings(ch)
                    FreeMemory(ch.handle)
                    return nil
                }
                //if it's the correct skill
                // C converts the int to an unsigned long at the compare.
                if skill < 0 || token.intvalue == UInt32(bitPattern: skill) {
                    foundcharacter = true
                    ch.skill = Float(token.intvalue)
                    while PC_ExpectAnyToken(source, token) != 0 {
                        if strcmp(token.string, "}") == 0 { break }
                        if token.type != TT_NUMBER || (token.subtype & TT_INTEGER) == 0 {
                            SourceError(source, "expected integer index, found %s\n", token.string)
                            FreeSource(source)
                            BotFreeCharacterStrings(ch)
                            FreeMemory(ch.handle)
                            return nil
                        }
                        // C converts the unsigned long to an int.
                        index = Int32(bitPattern: token.intvalue)
                        if index < 0 || index > MAX_CHARACTERISTICS {
                            SourceError(source, "characteristic index out of range [0, %d]\n", MAX_CHARACTERISTICS)
                            FreeSource(source)
                            BotFreeCharacterStrings(ch)
                            FreeMemory(ch.handle)
                            return nil
                        }
                        // Port-note: Raven's test lets index MAX_CHARACTERISTICS through and reads one characteristic past the block, undefined.
                        // The Slots of `c` traps there.
                        if ch.c[index].type != 0 {
                            SourceError(source, "characteristic %d already initialized\n", index)
                            FreeSource(source)
                            BotFreeCharacterStrings(ch)
                            FreeMemory(ch.handle)
                            return nil
                        }
                        if PC_ExpectAnyToken(source, token) == 0 {
                            FreeSource(source)
                            BotFreeCharacterStrings(ch)
                            FreeMemory(ch.handle)
                            return nil
                        }
                        if token.type == TT_NUMBER {
                            if (token.subtype & TT_FLOAT) != 0 {
                                ch.c[index].value._float = Float(token.floatvalue)
                                ch.c[index].type = CT_FLOAT
                            } else {
                                // C converts the unsigned long to an int.
                                ch.c[index].value.integer = Int32(bitPattern: token.intvalue)
                                ch.c[index].type = CT_INTEGER
                            }
                        } else if token.type == TT_STRING {
                            StripDoubleQuotes(&token.stringBuffer)
                            // AI: Raven copies the text into a GetMemory block. The call stays for the zone count, and the field takes the text.
                            _ = GetMemory(strlen(token.string) + 1)
                            ch.c[index].value.string = token.string
                            ch.c[index].type = CT_STRING
                        } else {
                            SourceError(source, "expected integer, float or string, found %s\n", token.string)
                            FreeSource(source)
                            BotFreeCharacterStrings(ch)
                            FreeMemory(ch.handle)
                            return nil
                        }
                    }
                    break
                } else {
                    indent = 1
                    while indent != 0 {
                        if PC_ExpectAnyToken(source, token) == 0 {
                            FreeSource(source)
                            BotFreeCharacterStrings(ch)
                            FreeMemory(ch.handle)
                            return nil
                        }
                        if strcmp(token.string, "{") == 0 {
                            indent += 1
                        } else if strcmp(token.string, "}") == 0 {
                            indent -= 1
                        }
                    }
                }
            } else {
                SourceError(source, "unknown definition %s\n", token.string)
                FreeSource(source)
                BotFreeCharacterStrings(ch)
                FreeMemory(ch.handle)
                return nil
            }
        }
        FreeSource(source)
        //
        if !foundcharacter {
            BotFreeCharacterStrings(ch)
            FreeMemory(ch.handle)
            return nil
        }
        return ch
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:345
func BotFindCachedCharacter(_ charfile: String, _ skill: Float) -> Int32 {
    var handle: Int32

    handle = 1
    while handle <= MAX_CLIENTS {
        if botcharacters[handle] == nil {
            handle += 1
            continue
        }
        if strcmp(botcharacters[handle]!.filename, charfile) == 0 &&
            (skill < 0 || Double(abs(botcharacters[handle]!.skill - skill)) < 0.01) {
            return handle
        }
        handle += 1
    }
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:366
func BotLoadCachedCharacter(_ charfile: inout JKAShared.CharBuf, _ skill: Float, _ reload: Int32) -> Int32 {
    var handle: Int32, cachedhandle: Int32, intskill: Int32
    var ch: BotCharacter? = nil

    //find a free spot for a character
    handle = 1
    while handle <= MAX_CLIENTS {
        if botcharacters[handle] == nil { break }
        handle += 1
    }
    if handle > MAX_CLIENTS { return 0 }
    //try to load a cached character with the given skill
    if reload == 0 {
        cachedhandle = BotFindCachedCharacter(String(charfile), skill)
        if cachedhandle != 0 {
            botimport.runPrint(PRT_MESSAGE, "loaded cached skill %f from %s\n", skill, String(charfile))
            return cachedhandle
        }
    }
    //
    intskill = Int32(Double(skill) + 0.5)
    //try to load the character with the given skill
    ch = BotLoadCharacterFromFile(&charfile, intskill)
    if ch != nil {
        botcharacters[handle] = ch
        //
        botimport.runPrint(PRT_MESSAGE, "loaded skill %d from %s\n", intskill, String(charfile))
        return handle
    }
    //
    botimport.runPrint(PRT_WARNING, "couldn't find skill %d in %s\n", intskill, String(charfile))
    //
    if reload == 0 {
        //try to load a cached default character with the given skill
        cachedhandle = BotFindCachedCharacter(DEFAULT_CHARACTER, skill)
        if cachedhandle != 0 {
            botimport.runPrint(PRT_MESSAGE, "loaded cached default skill %d from %s\n", intskill, String(charfile))
            return cachedhandle
        }
    }
    //try to load the default character with the given skill
    var defaultcharacter = CharBuf(DEFAULT_CHARACTER)
    ch = BotLoadCharacterFromFile(&defaultcharacter, intskill)
    if ch != nil {
        botcharacters[handle] = ch
        botimport.runPrint(PRT_MESSAGE, "loaded default skill %d from %s\n", intskill, String(charfile))
        return handle
    }
    //
    if reload == 0 {
        //try to load a cached character with any skill
        cachedhandle = BotFindCachedCharacter(String(charfile), -1)
        if cachedhandle != 0 {
            botimport.runPrint(PRT_MESSAGE, "loaded cached skill %f from %s\n", botcharacters[cachedhandle]!.skill, String(charfile))
            return cachedhandle
        }
    }
    //try to load a character with any skill
    ch = BotLoadCharacterFromFile(&charfile, -1)
    if ch != nil {
        botcharacters[handle] = ch
        botimport.runPrint(PRT_MESSAGE, "loaded skill %f from %s\n", ch!.skill, String(charfile))
        return handle
    }
    //
    if reload == 0 {
        //try to load a cached character with any skill
        cachedhandle = BotFindCachedCharacter(DEFAULT_CHARACTER, -1)
        if cachedhandle != 0 {
            botimport.runPrint(PRT_MESSAGE, "loaded cached default skill %f from %s\n", botcharacters[cachedhandle]!.skill, String(charfile))
            return cachedhandle
        }
    }
    //try to load a character with any skill
    ch = BotLoadCharacterFromFile(&defaultcharacter, -1)
    if ch != nil {
        botcharacters[handle] = ch
        botimport.runPrint(PRT_MESSAGE, "loaded default skill %f from %s\n", ch!.skill, String(charfile))
        return handle
    }
    //
    botimport.runPrint(PRT_WARNING, "couldn't load any skill from %s\n", String(charfile))
    //couldn't load any character
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:479
func BotLoadCharacterSkill(_ charfile: inout JKAShared.CharBuf, _ skill: Float) -> Int32 {
    var ch: Int32, defaultch: Int32

    var defaultcharacter = CharBuf(DEFAULT_CHARACTER)
    defaultch = BotLoadCachedCharacter(&defaultcharacter, skill, 0)
    ch = BotLoadCachedCharacter(&charfile, skill, Int32(LibVarGetValue("bot_reloadcharacters")))

    if defaultch != 0 && ch != 0 {
        BotDefaultCharacteristics(botcharacters[ch]!, botcharacters[defaultch]!)
    }

    return ch
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:499
func BotInterpolateCharacters(_ handle1: Int32, _ handle2: Int32, _ desiredskill: Float) -> Int32 {
    let out: BotCharacter
    var i: Int32, handle: Int32
    var scale: Float

    let ch1 = BotCharacterFromHandle(handle1)
    let ch2 = BotCharacterFromHandle(handle2)
    guard let ch1, let ch2 else { return 0 }
    //find a free spot for a character
    handle = 1
    while handle <= MAX_CLIENTS {
        if botcharacters[handle] == nil { break }
        handle += 1
    }
    if handle > MAX_CLIENTS { return 0 }
    out = BotCharacter(GetClearedMemory(UInt32(Int32(BotCharacter.byteCount) + MAX_CHARACTERISTICS * Int32(BotCharacteristic.byteCount))))
    out.skill = desiredskill
    strcpy(&out.filenameBuffer, ch1.filename)
    botcharacters[handle] = out

    scale = Float(desiredskill - ch1.skill) / (ch2.skill - ch1.skill)
    i = 0
    while i < MAX_CHARACTERISTICS {
        //
        if Int32(ch1.c[i].type) == CT_FLOAT && Int32(ch2.c[i].type) == CT_FLOAT {
            out.c[i].type = CT_FLOAT
            out.c[i].value._float = ch1.c[i].value._float + (ch2.c[i].value._float - ch1.c[i].value._float) * scale
        } else if Int32(ch1.c[i].type) == CT_INTEGER {
            out.c[i].type = CT_INTEGER
            out.c[i].value.integer = ch1.c[i].value.integer
        } else if Int32(ch1.c[i].type) == CT_STRING {
            out.c[i].type = CT_STRING
            // AI: Raven copies the text into a GetMemory block. The call stays for the zone count, and the field takes the text.
            _ = GetMemory(strlen(ch1.c[i].value.string!) + 1)
            out.c[i].value.string = ch1.c[i].value.string
        }
        i += 1
    }
    return handle
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:551
func BotLoadCharacter(_ charfile: inout JKAShared.CharBuf, _ skill: Float) -> Int32 {
    var skill = skill
    var firstskill: Int32, secondskill: Int32, handle: Int32

    //make sure the skill is in the valid range
    if skill < 1.0 {
        skill = 1.0
    } else if skill > 5.0 {
        skill = 5.0
    }
    //skill 1, 4 and 5 should be available in the character files
    if skill == 1.0 || skill == 4.0 || skill == 5.0 {
        return BotLoadCharacterSkill(&charfile, skill)
    }
    //check if there's a cached skill
    handle = BotFindCachedCharacter(String(charfile), skill)
    if handle != 0 {
        botimport.runPrint(PRT_MESSAGE, "loaded cached skill %f from %s\n", skill, String(charfile))
        return handle
    }
    if skill < 4.0 {
        //load skill 1 and 4
        firstskill = BotLoadCharacterSkill(&charfile, 1)
        if firstskill == 0 { return 0 }
        secondskill = BotLoadCharacterSkill(&charfile, 4)
        if secondskill == 0 { return firstskill }
    } else {
        //load skill 4 and 5
        firstskill = BotLoadCharacterSkill(&charfile, 4)
        if firstskill == 0 { return 0 }
        secondskill = BotLoadCharacterSkill(&charfile, 5)
        if secondskill == 0 { return firstskill }
    }
    //interpolate between the two skills
    handle = BotInterpolateCharacters(firstskill, secondskill, skill)
    if handle == 0 { return 0 }
    //write the character to the log file
    BotDumpCharacter(botcharacters[handle]!)
    //
    return handle
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:600
func CheckCharacteristicIndex(_ character: Int32, _ index: Int32) -> Int32 {
    guard let ch = BotCharacterFromHandle(character) else { return 0 }
    if index < 0 || index >= MAX_CHARACTERISTICS {
        botimport.runPrint(PRT_ERROR, "characteristic %d does not exist\n", index)
        return 0
    }
    if ch.c[index].type == 0 {
        botimport.runPrint(PRT_ERROR, "characteristic %d is not initialized\n", index)
        return 0
    }
    return 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:624
func Characteristic_Float(_ character: Int32, _ index: Int32) -> Float {
    guard let ch = BotCharacterFromHandle(character) else { return 0 }
    //check if the index is in range
    if CheckCharacteristicIndex(character, index) == 0 { return 0 }
    //an integer will be converted to a float
    if Int32(ch.c[index].type) == CT_INTEGER {
        return Float(ch.c[index].value.integer)
    }
    //floats are just returned
    else if Int32(ch.c[index].type) == CT_FLOAT {
        return ch.c[index].value._float
    }
    //cannot convert a string pointer to a float
    else {
        botimport.runPrint(PRT_ERROR, "characteristic %d is not a float\n", index)
        return 0
    }
//	return 0;
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:656
func Characteristic_BFloat(_ character: Int32, _ index: Int32, _ min: Float, _ max: Float) -> Float {
    let value: Float

    if BotCharacterFromHandle(character) == nil { return 0 }
    if min > max {
        botimport.runPrint(PRT_ERROR, "cannot bound characteristic %d between %f and %f\n", index, min, max)
        return 0
    }
    value = Characteristic_Float(character, index)
    if value < min { return min }
    if value > max { return max }
    return value
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:679
func Characteristic_Integer(_ character: Int32, _ index: Int32) -> Int32 {
    guard let ch = BotCharacterFromHandle(character) else { return 0 }
    //check if the index is in range
    if CheckCharacteristicIndex(character, index) == 0 { return 0 }
    //an integer will just be returned
    if Int32(ch.c[index].type) == CT_INTEGER {
        return ch.c[index].value.integer
    }
    //floats are casted to integers
    else if Int32(ch.c[index].type) == CT_FLOAT {
        return Int32(ch.c[index].value._float)
    } else {
        botimport.runPrint(PRT_ERROR, "characteristic %d is not a integer\n", index)
        return 0
    }
//	return 0;
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:710
func Characteristic_BInteger(_ character: Int32, _ index: Int32, _ min: Int32, _ max: Int32) -> Int32 {
    let value: Int32

    if BotCharacterFromHandle(character) == nil { return 0 }
    if min > max {
        botimport.runPrint(PRT_ERROR, "cannot bound characteristic %d between %d and %d\n", index, min, max)
        return 0
    }
    value = Characteristic_Integer(character, index)
    if value < min { return min }
    if value > max { return max }
    return value
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:733
func Characteristic_String(_ character: Int32, _ index: Int32, _ buf: inout JKAShared.CharBuf, _ size: Int32) {
    guard let ch = BotCharacterFromHandle(character) else { return }
    //check if the index is in range
    if CheckCharacteristicIndex(character, index) == 0 { return }
    //an integer will be converted to a float
    if Int32(ch.c[index].type) == CT_STRING {
        strncpy(&buf, ch.c[index].value.string!, size - 1)
        buf[size - 1] = 0
        return
    } else {
        botimport.runPrint(PRT_ERROR, "characteristic %d is not a string\n", index)
        return
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_char.cpp:761
func BotShutdownCharacters() {
    var handle: Int32

    handle = 1
    while handle <= MAX_CLIENTS {
        if botcharacters[handle] != nil {
            BotFreeCharacter2(handle)
        }
        handle += 1
    }
}
