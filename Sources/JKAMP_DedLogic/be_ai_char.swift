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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "character handle %d out of range\n", handle);
        portMissing("BotCharacterFromHandle", source: "oracle/codemp/botlib/be_ai_char.cpp:68")
        return nil
    }
    if botcharacters[handle] == nil {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "invalid character %d\n", handle);
        portMissing("BotCharacterFromHandle", source: "oracle/codemp/botlib/be_ai_char.cpp:68")
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

    var fmt = CharBuf("%s")
    Log_Write(&fmt, ch.filename)
    var fmt2 = CharBuf("skill %d\n")
    // Port-note: Raven passes the float `skill` to a `%d`, which reads the bits of a double as an int, undefined.
    // The port passes the integer part of the skill.
    Log_Write(&fmt2, Int32(ch.skill))
    var fmt3 = CharBuf("{\n")
    Log_Write(&fmt3)
    i = 0
    while i < MAX_CHARACTERISTICS {
        // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
        // Raven wrote: switch(ch->c[i].type) { case CT_INTEGER: Log_Write(" %4d %d\n", i, ch->c[i].value.integer); break; case CT_FLOAT: Log_Write(" %4d %f\n", i, ch->c[i].value._float); break; case CT_STRING: Log_Write(" %4d %s\n", i, ch->c[i].value.string); break; }
        portMissing("BotDumpCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:88")
        i += 1
    }
    var fmt4 = CharBuf("}\n")
    Log_Write(&fmt4)
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
            // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
            // Raven wrote: FreeMemory(ch->c[i].value.string);
            portMissing("BotFreeCharacterStrings", source: "oracle/codemp/botlib/be_ai_char.cpp:112")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "character handle %d out of range\n", handle);
        portMissing("BotFreeCharacter2", source: "oracle/codemp/botlib/be_ai_char.cpp:130")
        return
    }
    if botcharacters[handle] == nil {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "invalid character %d\n", handle);
        portMissing("BotFreeCharacter2", source: "oracle/codemp/botlib/be_ai_char.cpp:130")
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
            ch.c[i].type = CChar(CT_FLOAT)
            // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
            // Raven wrote: ch->c[i].value._float = defaultch->c[i].value._float;
            portMissing("BotDefaultCharacteristics", source: "oracle/codemp/botlib/be_ai_char.cpp:163")
        } else if Int32(defaultch.c[i].type) == CT_INTEGER {
            ch.c[i].type = CChar(CT_INTEGER)
            // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
            // Raven wrote: ch->c[i].value.integer = defaultch->c[i].value.integer;
            portMissing("BotDefaultCharacteristics", source: "oracle/codemp/botlib/be_ai_char.cpp:163")
        } else if Int32(defaultch.c[i].type) == CT_STRING {
            ch.c[i].type = CChar(CT_STRING)
            // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
            // Raven wrote: ch->c[i].value.string = (char *) GetMemory(strlen(defaultch->c[i].value.string)+1); strcpy(ch->c[i].value.string, defaultch->c[i].value.string);
            portMissing("BotDefaultCharacteristics", source: "oracle/codemp/botlib/be_ai_char.cpp:163")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "counldn't load %s\n", charfile);
        portMissing("BotLoadCharacterFromFile", source: "oracle/codemp/botlib/be_ai_char.cpp:195")
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
                        index = Int32(truncatingIfNeeded: token.intvalue)
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
                                // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
                                // Raven wrote: ch->c[index].value._float = token.floatvalue;
                                portMissing("BotLoadCharacterFromFile", source: "oracle/codemp/botlib/be_ai_char.cpp:195")
                                ch.c[index].type = CChar(CT_FLOAT)
                            } else {
                                // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
                                // Raven wrote: ch->c[index].value.integer = token.intvalue;
                                portMissing("BotLoadCharacterFromFile", source: "oracle/codemp/botlib/be_ai_char.cpp:195")
                                ch.c[index].type = CChar(CT_INTEGER)
                            }
                        } else if token.type == TT_STRING {
                            StripDoubleQuotes(&token.stringBuffer)
                            // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
                            // Raven wrote: ch->c[index].value.string = (char *)GetMemory(strlen(token.string)+1); strcpy(ch->c[index].value.string, token.string);
                            portMissing("BotLoadCharacterFromFile", source: "oracle/codemp/botlib/be_ai_char.cpp:195")
                            ch.c[index].type = CChar(CT_STRING)
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
            (skill < 0 || abs(Double(botcharacters[handle]!.skill - skill)) < 0.01) {
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
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded cached skill %f from %s\n", skill, charfile);
            portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded skill %d from %s\n", intskill, charfile);
        portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
        return handle
    }
    //
    // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
    // Raven wrote: botimport.Print(PRT_WARNING, "couldn't find skill %d in %s\n", intskill, charfile);
    portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
    //
    if reload == 0 {
        //try to load a cached default character with the given skill
        cachedhandle = BotFindCachedCharacter(DEFAULT_CHARACTER, skill)
        if cachedhandle != 0 {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded cached default skill %d from %s\n", intskill, charfile);
            portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
            return cachedhandle
        }
    }
    //try to load the default character with the given skill
    var defaultcharacter = CharBuf(DEFAULT_CHARACTER)
    ch = BotLoadCharacterFromFile(&defaultcharacter, intskill)
    if ch != nil {
        botcharacters[handle] = ch
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded default skill %d from %s\n", intskill, charfile);
        portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
        return handle
    }
    //
    if reload == 0 {
        //try to load a cached character with any skill
        cachedhandle = BotFindCachedCharacter(String(charfile), -1)
        if cachedhandle != 0 {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded cached skill %f from %s\n", botcharacters[cachedhandle]->skill, charfile);
            portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
            return cachedhandle
        }
    }
    //try to load a character with any skill
    ch = BotLoadCharacterFromFile(&charfile, -1)
    if ch != nil {
        botcharacters[handle] = ch
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded skill %f from %s\n", ch->skill, charfile);
        portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
        return handle
    }
    //
    if reload == 0 {
        //try to load a cached character with any skill
        cachedhandle = BotFindCachedCharacter(DEFAULT_CHARACTER, -1)
        if cachedhandle != 0 {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded cached default skill %f from %s\n", botcharacters[cachedhandle]->skill, charfile);
            portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
            return cachedhandle
        }
    }
    //try to load a character with any skill
    ch = BotLoadCharacterFromFile(&defaultcharacter, -1)
    if ch != nil {
        botcharacters[handle] = ch
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded default skill %f from %s\n", ch->skill, charfile);
        portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
        return handle
    }
    //
    // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
    // Raven wrote: botimport.Print(PRT_WARNING, "couldn't load any skill from %s\n", charfile);
    portMissing("BotLoadCachedCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:366")
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
            out.c[i].type = CChar(CT_FLOAT)
            // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
            // Raven wrote: out->c[i].value._float = ch1->c[i].value._float + (ch2->c[i].value._float - ch1->c[i].value._float) * scale;
            portMissing("BotInterpolateCharacters", source: "oracle/codemp/botlib/be_ai_char.cpp:499")
        } else if Int32(ch1.c[i].type) == CT_INTEGER {
            out.c[i].type = CChar(CT_INTEGER)
            // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
            // Raven wrote: out->c[i].value.integer = ch1->c[i].value.integer;
            portMissing("BotInterpolateCharacters", source: "oracle/codemp/botlib/be_ai_char.cpp:499")
        } else if Int32(ch1.c[i].type) == CT_STRING {
            out.c[i].type = CChar(CT_STRING)
            // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
            // Raven wrote: out->c[i].value.string = (char *) GetMemory(strlen(ch1->c[i].value.string)+1); strcpy(out->c[i].value.string, ch1->c[i].value.string);
            portMissing("BotInterpolateCharacters", source: "oracle/codemp/botlib/be_ai_char.cpp:499")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded cached skill %f from %s\n", skill, charfile);
        portMissing("BotLoadCharacter", source: "oracle/codemp/botlib/be_ai_char.cpp:551")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "characteristic %d does not exist\n", index);
        portMissing("CheckCharacteristicIndex", source: "oracle/codemp/botlib/be_ai_char.cpp:600")
        return 0
    }
    if ch.c[index].type == 0 {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "characteristic %d is not initialized\n", index);
        portMissing("CheckCharacteristicIndex", source: "oracle/codemp/botlib/be_ai_char.cpp:600")
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
        // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
        // Raven wrote: return (float) ch->c[index].value.integer;
        portMissing("Characteristic_Float", source: "oracle/codemp/botlib/be_ai_char.cpp:624")
    }
    //floats are just returned
    else if Int32(ch.c[index].type) == CT_FLOAT {
        // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
        // Raven wrote: return ch->c[index].value._float;
        portMissing("Characteristic_Float", source: "oracle/codemp/botlib/be_ai_char.cpp:624")
    }
    //cannot convert a string pointer to a float
    else {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "characteristic %d is not a float\n", index);
        portMissing("Characteristic_Float", source: "oracle/codemp/botlib/be_ai_char.cpp:624")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "cannot bound characteristic %d between %f and %f\n", index, min, max);
        portMissing("Characteristic_BFloat", source: "oracle/codemp/botlib/be_ai_char.cpp:656")
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
        // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
        // Raven wrote: return ch->c[index].value.integer;
        portMissing("Characteristic_Integer", source: "oracle/codemp/botlib/be_ai_char.cpp:679")
    }
    //floats are casted to integers
    else if Int32(ch.c[index].type) == CT_FLOAT {
        // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
        // Raven wrote: return (int) ch->c[index].value._float;
        portMissing("Characteristic_Integer", source: "oracle/codemp/botlib/be_ai_char.cpp:679")
    } else {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "characteristic %d is not a integer\n", index);
        portMissing("Characteristic_Integer", source: "oracle/codemp/botlib/be_ai_char.cpp:679")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "cannot bound characteristic %d between %d and %d\n", index, min, max);
        portMissing("Characteristic_BInteger", source: "oracle/codemp/botlib/be_ai_char.cpp:710")
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
        // Port-note: The union `value` of `bot_characteristic_t` has no accessor in its view, row P2 of the bot-ai round.
        // Raven wrote: strncpy(buf, ch->c[index].value.string, size-1);
        portMissing("Characteristic_String", source: "oracle/codemp/botlib/be_ai_char.cpp:733")
        buf[size - 1] = 0
        return
    } else {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "characteristic %d is not a string\n", index);
        portMissing("Characteristic_String", source: "oracle/codemp/botlib/be_ai_char.cpp:733")
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
