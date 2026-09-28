import Foundation
import JKAMP
import JKAShared

/// Source: oracle/codemp/game/bg_saga.c:17
let SIEGECHAR_TAB = 9 as Int32

/// Source: oracle/codemp/game/bg_saga.c:32
public var siege_info: JKAShared.CharBuf {
    get { bg.variables.siege_info }
    set { bg.variables.siege_info = newValue }
}

/// Source: oracle/codemp/game/bg_saga.c:33
public var siege_valid: Int32 {
    get { bg.variables.siege_valid }
    set { bg.variables.siege_valid = newValue }
}

/// Source: oracle/codemp/game/bg_saga.c:35
var team1Theme: JKAMP.SiegeTeam? {
    get { bg.variables.team1Theme }
    set { bg.variables.team1Theme = newValue }
}

/// Source: oracle/codemp/game/bg_saga.c:36
var team2Theme: JKAMP.SiegeTeam? {
    get { bg.variables.team2Theme }
    set { bg.variables.team2Theme = newValue }
}

/// Source: oracle/codemp/game/bg_saga.c:38
public var bgSiegeClasses: Slots<JKAMP.SiegeClass> { bg.storage.bgSiegeClasses }

/// Source: oracle/codemp/game/bg_saga.c:39
public var bgNumSiegeClasses: Int32 {
    get { bg.variables.bgNumSiegeClasses }
    set { bg.variables.bgNumSiegeClasses = newValue }
}

/// Source: oracle/codemp/game/bg_saga.c:41
var bgSiegeTeams: Slots<JKAMP.SiegeTeam> { bg.storage.bgSiegeTeams }

/// Source: oracle/codemp/game/bg_saga.c:42
public var bgNumSiegeTeams: Int32 {
    get { bg.variables.bgNumSiegeTeams }
    set { bg.variables.bgNumSiegeTeams = newValue }
}

/// Source: oracle/codemp/game/bg_saga.c:45
// TODO: Port global bgSiegeClassFlagNames
// Raven wrote: stringID_table_t bgSiegeClassFlagNames[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saga.c:59
// TODO: Port global StanceTable
// Raven wrote: stringID_table_t StanceTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saga.c:73
// TODO: Port global WPTable
// Raven wrote: stringID_table_t WPTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saga.c:100
// TODO: Port global FPTable
// Raven wrote: stringID_table_t FPTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saga.c:123
// TODO: Port global HoldableTable
// Raven wrote: stringID_table_t HoldableTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saga.c:142
// TODO: Port global PowerupTable
// Raven wrote: stringID_table_t PowerupTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saga.c:748
/// Raven's data table, a hand property of `BgState`.
var classTitles: [String] {
    get { bg.classTitles }
    set { bg.classTitles = newValue }
}

//======================================
//Parsing functions
//======================================
/// Source: oracle/codemp/game/bg_saga.c:168
func BG_SiegeStripTabs(_ buf: inout JKAShared.CharBuf) {
    var i: Int32 = 0
    var i_r: Int32 = 0

    while buf[i] != 0 {
        if buf[i] != SIEGECHAR_TAB {
            //not a tab, just stick it in
            buf[i_r] = buf[i]
        } else {
            //If it's a tab, convert it to a space.
            buf[i_r] = Int32(ascii: " ")
        }

        i_r += 1
        i += 1
    }

    buf[i_r] = 0
}

/// Source: oracle/codemp/game/bg_saga.c:191
public func BG_SiegeGetValueGroup(_ buf: inout JKAShared.CharBuf, _ group: String, _ outbuf: inout JKAShared.CharBuf) -> Int32 {
    var i: Int32 = 0
    var j: Int32
    var checkGroup = CharBuf(4096)
    var isGroup: Bool
    var parseGroups: Int32 = 0

    while buf[i] != 0 {
        if buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "{") && buf[i] != Int32(ascii: "}") && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r") && buf[i] != SIEGECHAR_TAB {
            //we're on a valid character
            if buf[i] == Int32(ascii: "/") && buf[i + 1] == Int32(ascii: "/") {
                //this is a comment, so skip over it
                while buf[i] != 0 && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r") && buf[i] != SIEGECHAR_TAB {
                    i += 1
                }
            } else {
                //parse to the next space/endline/eos and check this value against our group value.
                j = 0

                while buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r") && buf[i] != SIEGECHAR_TAB && buf[i] != Int32(ascii: "{") && buf[i] != 0 {
                    if buf[i] == Int32(ascii: "/") && buf[i + 1] == Int32(ascii: "/") {
                        //hit a comment, break out.
                        break
                    }

                    checkGroup[j] = buf[i]
                    j += 1
                    i += 1
                }
                checkGroup[j] = 0

                //Make sure this is a group as opposed to a globally defined value.
                if buf[i] == Int32(ascii: "/") && buf[i + 1] == Int32(ascii: "/") {
                    //stopped on a comment, so first parse to the end of it.
                    while buf[i] != 0 && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r") {
                        i += 1
                    }
                    while buf[i] == Int32(ascii: "\n") || buf[i] == Int32(ascii: "\r") {
                        i += 1
                    }
                }

                if buf[i] == 0 {
                    Com_Error(ERR_DROP, "Unexpected EOF while looking for group '%s'", group)
                }

                isGroup = false

                while buf[i] != 0 && buf[i] == Int32(ascii: " ") || buf[i] == SIEGECHAR_TAB || buf[i] == Int32(ascii: "\n") || buf[i] == Int32(ascii: "\r") {
                    //parse to the next valid character
                    i += 1
                }

                if buf[i] == Int32(ascii: "{") {
                    //if the next valid character is an opening bracket, then this is indeed a group
                    isGroup = true
                }

                //Is this the one we want?
                if isGroup && Q_stricmp(String(checkGroup), group) == 0 {
                    //guess so. Parse until we hit the { indicating the beginning of the group.
                    while buf[i] != Int32(ascii: "{") && buf[i] != 0 {
                        i += 1
                    }

                    if buf[i] != 0 {
                        //We're at the start of the group now, so parse to the closing bracket.
                        j = 0

                        parseGroups = 0

                        while (buf[i] != Int32(ascii: "}") || parseGroups != 0) && buf[i] != 0 {
                            if buf[i] == Int32(ascii: "{") {
                                //increment for the opening bracket.
                                parseGroups += 1
                            } else if buf[i] == Int32(ascii: "}") {
                                //decrement for the closing bracket
                                parseGroups -= 1
                            }

                            if parseGroups < 0 {
                                //Syntax error, I guess.
                                Com_Error(ERR_DROP, "Found a closing bracket without an opening bracket while looking for group '%s'", group)
                            }

                            if (buf[i] != Int32(ascii: "{") || parseGroups > 1) && (buf[i] != Int32(ascii: "}") || parseGroups > 0) {
                                //don't put the start and end brackets for this group into the output buffer
                                outbuf[j] = buf[i]
                                j += 1
                            }

                            if buf[i] == Int32(ascii: "}") && parseGroups == 0 {
                                //Alright, we can break out now.
                                break
                            }

                            i += 1
                        }
                        outbuf[j] = 0

                        //Verify that we ended up on the closing bracket.
                        if buf[i] != Int32(ascii: "}") {
                            Com_Error(ERR_DROP, "Group '%s' is missing a closing bracket", group)
                        }

                        //Strip the tabs so we're friendly for value parsing.
                        BG_SiegeStripTabs(&outbuf)

                        return 1 //we got it, so return 1.
                    } else {
                        Com_Error(ERR_DROP, "Error parsing group in file, unexpected EOF before opening bracket while looking for group '%s'", group)
                    }
                } else if !isGroup {
                    //if it wasn't a group, parse to the end of the line
                    while buf[i] != 0 && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r") {
                        i += 1
                    }
                } else {
                    //this was a group but we not the one we wanted to find, so parse by it.
                    parseGroups = 0

                    while buf[i] != 0 && (buf[i] != Int32(ascii: "}") || parseGroups != 0) {
                        if buf[i] == Int32(ascii: "{") {
                            parseGroups += 1
                        } else if buf[i] == Int32(ascii: "}") {
                            parseGroups -= 1
                        }

                        if parseGroups < 0 {
                            //Syntax error, I guess.
                            Com_Error(ERR_DROP, "Found a closing bracket without an opening bracket while looking for group '%s'", group)
                        }

                        if buf[i] == Int32(ascii: "}") && parseGroups == 0 {
                            //Alright, we can break out now.
                            break
                        }

                        i += 1
                    }

                    if buf[i] != Int32(ascii: "}") {
                        Com_Error(ERR_DROP, "Found an opening bracket without a matching closing bracket while looking for group '%s'", group)
                    }

                    i += 1
                }
            }
        } else if buf[i] == Int32(ascii: "{") {
            //we're in a group that isn't the one we want, so parse to the end.
            parseGroups = 0

            while buf[i] != 0 && (buf[i] != Int32(ascii: "}") || parseGroups != 0) {
                if buf[i] == Int32(ascii: "{") {
                    parseGroups += 1
                } else if buf[i] == Int32(ascii: "}") {
                    parseGroups -= 1
                }

                if parseGroups < 0 {
                    //Syntax error, I guess.
                    Com_Error(ERR_DROP, "Found a closing bracket without an opening bracket while looking for group '%s'", group)
                }

                if buf[i] == Int32(ascii: "}") && parseGroups == 0 {
                    //Alright, we can break out now.
                    break
                }

                i += 1
            }

            if buf[i] != Int32(ascii: "}") {
                Com_Error(ERR_DROP, "Found an opening bracket without a matching closing bracket while looking for group '%s'", group)
            }
        }

        if buf[i] == 0 {
            break
        }
        i += 1
    }

    return 0 //guess we never found it.
}

/// Source: oracle/codemp/game/bg_saga.c:408
public func BG_SiegeGetPairedValue(_ buf: inout JKAShared.CharBuf, _ key: String, _ outbuf: inout JKAShared.CharBuf) -> Int32 {
    var i: Int32 = 0
    var j: Int32
    var k: Int32
    var checkKey = CharBuf(4096)

    while buf[i] != 0 {
        if buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "{") && buf[i] != Int32(ascii: "}") && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r") {
            //we're on a valid character
            if buf[i] == Int32(ascii: "/") && buf[i + 1] == Int32(ascii: "/") {
                //this is a comment, so skip over it
                while buf[i] != 0 && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r") {
                    i += 1
                }
            } else {
                //parse to the next space/endline/eos and check this value against our key value.
                j = 0

                while buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r") && buf[i] != SIEGECHAR_TAB && buf[i] != 0 {
                    if buf[i] == Int32(ascii: "/") && buf[i + 1] == Int32(ascii: "/") {
                        //hit a comment, break out.
                        break
                    }

                    checkKey[j] = buf[i]
                    j += 1
                    i += 1
                }
                checkKey[j] = 0

                k = i

                while buf[k] != 0 && (buf[k] == Int32(ascii: " ") || buf[k] == Int32(ascii: "\n") || buf[k] == Int32(ascii: "\r")) {
                    k += 1
                }

                if buf[k] == Int32(ascii: "{") {
                    //this is not the start of a value but rather of a group. We don't want to look in subgroups so skip over the whole thing.
                    var openB: Int32 = 0

                    while buf[i] != 0 && (buf[i] != Int32(ascii: "}") || openB != 0) {
                        if buf[i] == Int32(ascii: "{") {
                            openB += 1
                        } else if buf[i] == Int32(ascii: "}") {
                            openB -= 1
                        }

                        if openB < 0 {
                            Com_Error(ERR_DROP, "Unexpected closing bracket (too many) while parsing to end of group '%s'", checkKey)
                        }

                        if buf[i] == Int32(ascii: "}") && openB == 0 {
                            //this is the end of the group
                            break
                        }
                        i += 1
                    }

                    if buf[i] == Int32(ascii: "}") {
                        i += 1
                    }
                } else {
                    //Is this the one we want?
                    if buf[i] != Int32(ascii: "/") || buf[i + 1] != Int32(ascii: "/") {
                        //make sure we didn't stop on a comment, if we did then this is considered an error in the file.
                        if Q_stricmp(String(checkKey), key) == 0 {
                            //guess so. Parse along to the next valid character, then put that into the output buffer and return 1.
                            while (buf[i] == Int32(ascii: " ") || buf[i] == Int32(ascii: "\n") || buf[i] == Int32(ascii: "\r") || buf[i] == SIEGECHAR_TAB) && buf[i] != 0 {
                                i += 1
                            }

                            if buf[i] != 0 {
                                //We're at the start of the value now.
                                var parseToQuote: Bool = false

                                if buf[i] == Int32(ascii: "\"") {
                                    //if the value is in quotes, then stop at the next quote instead of ' '
                                    i += 1
                                    parseToQuote = true
                                }

                                j = 0
                                while ((!parseToQuote && buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "\n") && buf[i] != Int32(ascii: "\r")) || (parseToQuote && buf[i] != Int32(ascii: "\""))) {
                                    if buf[i] == Int32(ascii: "/") && buf[i + 1] == Int32(ascii: "/") {
                                        //hit a comment after the value? This isn't an ideal way to be writing things, but we'll support it anyway.
                                        break
                                    }
                                    outbuf[j] = buf[i]
                                    j += 1
                                    i += 1

                                    if buf[i] == 0 {
                                        if parseToQuote {
                                            Com_Error(ERR_DROP, "Unexpected EOF while looking for endquote, error finding paired value for '%s'", key)
                                        } else {
                                            Com_Error(ERR_DROP, "Unexpected EOF while looking for space or endline, error finding paired value for '%s'", key)
                                        }
                                    }
                                }
                                outbuf[j] = 0

                                return 1 //we got it, so return 1.
                            } else {
                                Com_Error(ERR_DROP, "Error parsing file, unexpected EOF while looking for valud '%s'", key)
                            }
                        } else {
                            //if that wasn't the desired key, then make sure we parse to the end of the line, so we don't mistake a value for a key
                            while buf[i] != 0 && buf[i] != Int32(ascii: "\n") {
                                i += 1
                            }
                        }
                    } else {
                        Com_Error(ERR_DROP, "Error parsing file, found comment, expected value for '%s'", key)
                    }
                }
            }
        }

        if buf[i] == 0 {
            break
        }
        i += 1
    }

    return 0 //guess we never found it.
}

//======================================
//Class loading functions
//======================================
/// Source: oracle/codemp/game/bg_saga.c:571
func BG_SiegeTranslateForcePowers(_ buf: inout JKAShared.CharBuf, _ siegeClass: JKAMP.SiegeClass) {
    var checkPower = CharBuf(1024)
    var checkLevel = CharBuf(256)
    var l: Int32 = 0
    var k: Int32 = 0
    var j: Int32 = 0
    var i: Int32 = 0
    var parsedLevel: Int32 = 0
    var allPowers: Bool = false
    var noPowers: Bool = false

    if Q_stricmp(buf, "FP_ALL") == 0 {
        //this is a special case, just give us all the powers on level 3
        allPowers = true
    }

    if buf[0] == Int32(ascii: "0") && buf[1] == 0 {
        //no powers then
        noPowers = true
    }

    //First clear out the powers, or in the allPowers case, give us all level 3.
    while i < NUM_FORCE_POWERS {
        if allPowers {
            siegeClass.forcePowerLevels[i] = FORCE_LEVEL_3
        } else {
            siegeClass.forcePowerLevels[i] = 0
        }
        i += 1
    }

    if allPowers || noPowers {
        //we're done now then.
        return
    }

    i = 0
    while buf[i] != 0 {
        //parse through the list which is seperated by |, and add all the weapons into a bitflag
        if buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "|") {
            j = 0

            while buf[i] != 0 && buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "|") && buf[i] != Int32(ascii: ",") {
                checkPower[j] = buf[i]
                j += 1
                i += 1
            }
            checkPower[j] = 0

            if buf[i] == Int32(ascii: ",") {
                //parse the power level
                i += 1
                l = 0
                while buf[i] != 0 && buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "|") {
                    checkLevel[l] = buf[i]
                    l += 1
                    i += 1
                }
                checkLevel[l] = 0
                parsedLevel = atoi(checkLevel)

                //keep sane limits on the powers
                if parsedLevel < 0 {
                    parsedLevel = 0
                }
                if parsedLevel > FORCE_LEVEL_5 {
                    parsedLevel = FORCE_LEVEL_5
                }
            } else {
                //if it's not there, assume level 3 I guess.
                parsedLevel = 3
            }

            if checkPower[0] != 0 {
                //Got the name, compare it against the weapon table strings.
                k = 0

                if Q_stricmp(checkPower, "FP_JUMP") == 0 {
                    //haqery
                    strcpy(&checkPower, "FP_LEVITATION")
                }

                while FPTable[k].id != -1 && !FPTable[k].name!.string.isEmpty {
                    if Q_stricmp(String(checkPower), FPTable[k].name!.string) == 0 {
                        //found it, add the weapon into the weapons value
                        siegeClass.forcePowerLevels[k] = parsedLevel
                        break
                    }
                    k += 1
                }
            }
        }

        if buf[i] == 0 {
            break
        }
        i += 1
    }
}

//Used for the majority of generic val parsing stuff. buf should be the value string,
//table should be the appropriate string/id table. If bitflag is qtrue then the
//values are accumulated into a bitflag. If bitflag is qfalse then the first value
//is returned as a directly corresponding id and no further parsing is done.
/// Source: oracle/codemp/game/bg_saga.c:688
func BG_SiegeTranslateGenericTable(_ buf: inout JKAShared.CharBuf, _ table: Slots<JKAShared.StringIDTable>, _ bitflag: Bool) -> Int32 {
    var items: Int32 = 0
    var checkItem = CharBuf(1024)
    var i: Int32 = 0
    var j: Int32 = 0
    var k: Int32 = 0

    if buf[0] == Int32(ascii: "0") && buf[1] == 0 {
        //special case, no items.
        return 0
    }

    while buf[i] != 0 {
        //Using basically the same parsing method as we do for weapons and forcepowers.
        if buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "|") {
            j = 0

            while buf[i] != 0 && buf[i] != Int32(ascii: " ") && buf[i] != Int32(ascii: "|") {
                checkItem[j] = buf[i]
                j += 1
                i += 1
            }
            checkItem[j] = 0

            if checkItem[0] != 0 {
                k = 0

                while table[k].name != nil && !table[k].name!.string.isEmpty {
                    //go through the list and check the parsed flag name against the hardcoded names
                    if Q_stricmp(String(checkItem), table[k].name!.string) == 0 {
                        //Got it, so add the value into our items value.
                        if bitflag {
                            items |= (1 << table[k].id)
                        } else {
                            //return the value directly then.
                            return table[k].id
                        }
                        break
                    }
                    k += 1
                }
            }
        }

        if buf[i] == 0 {
            break
        }

        i += 1
    }
    return items
}

/// Source: oracle/codemp/game/bg_saga.c:759
func BG_SiegeParseClassFile(_ filename: String, _ descBuffer: JKAMP.SiegeClassDesc?) {
    var f: fileHandle_t = 0
    let len: Int32
    var i: Int32
    var classInfo = CharBuf(4096)
    var parseBuf = CharBuf(4096)

    len = trap_FS_FOpenFile(filename, &f, FS_READ)

    if f == 0 || len >= 4096 {
        return
    }

    trap_FS_Read(&classInfo, len, f)

    trap_FS_FCloseFile(f)

    classInfo[len] = 0

    //first get the description if we have a buffer for it
    if descBuffer != nil {
        if BG_SiegeGetPairedValue(&classInfo, "description", &descBuffer!.descBuffer) == 0 {
            strcpy(&descBuffer!.descBuffer, "DESCRIPTION UNAVAILABLE")
        }

        //Hit this assert?  Memory has already been trashed.  Increase
        //SIEGE_CLASS_DESC_LEN.
    }

    // Raven passes `classInfo` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy.
    do {
        var classInfoIn0 = classInfo
        BG_SiegeGetValueGroup(&classInfoIn0, "ClassInfo", &classInfo)
    }

    //Parse name
    if BG_SiegeGetPairedValue(&classInfo, "name", &parseBuf) != 0 {
        strcpy(&bgSiegeClasses[bgNumSiegeClasses].nameBuffer, parseBuf)
    } else {
        Com_Error(ERR_DROP, "Siege class without name entry")
    }

    //Parse forced model
    if BG_SiegeGetPairedValue(&classInfo, "model", &parseBuf) != 0 {
        strcpy(&bgSiegeClasses[bgNumSiegeClasses].forcedModelBuffer, parseBuf)
    } else {
        //It's ok if there isn't one, it's optional.
        bgSiegeClasses[bgNumSiegeClasses].forcedModel = ""
    }

    //Parse forced skin
    if BG_SiegeGetPairedValue(&classInfo, "skin", &parseBuf) != 0 {
        strcpy(&bgSiegeClasses[bgNumSiegeClasses].forcedSkinBuffer, parseBuf)
    } else {
        //It's ok if there isn't one, it's optional.
        bgSiegeClasses[bgNumSiegeClasses].forcedSkin = ""
    }

    //Parse first saber
    if BG_SiegeGetPairedValue(&classInfo, "saber1", &parseBuf) != 0 {
        strcpy(&bgSiegeClasses[bgNumSiegeClasses].saber1Buffer, parseBuf)
    } else {
        //It's ok if there isn't one, it's optional.
        bgSiegeClasses[bgNumSiegeClasses].saber1 = ""
    }

    //Parse second saber
    if BG_SiegeGetPairedValue(&classInfo, "saber2", &parseBuf) != 0 {
        strcpy(&bgSiegeClasses[bgNumSiegeClasses].saber2Buffer, parseBuf)
    } else {
        //It's ok if there isn't one, it's optional.
        bgSiegeClasses[bgNumSiegeClasses].saber2 = ""
    }

    //Parse forced saber stance
    if BG_SiegeGetPairedValue(&classInfo, "saberstyle", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].saberStance = BG_SiegeTranslateGenericTable(&parseBuf, StanceTable, true)
    } else {
        //It's ok if there isn't one, it's optional.
        bgSiegeClasses[bgNumSiegeClasses].saberStance = 0
    }

    //Parse forced saber color
    if BG_SiegeGetPairedValue(&classInfo, "sabercolor", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].forcedSaberColor = atoi(parseBuf)
        bgSiegeClasses[bgNumSiegeClasses].hasForcedSaberColor = true
    } else {
        //It's ok if there isn't one, it's optional.
        bgSiegeClasses[bgNumSiegeClasses].hasForcedSaberColor = false
    }

    //Parse forced saber2 color
    if BG_SiegeGetPairedValue(&classInfo, "saber2color", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].forcedSaber2Color = atoi(parseBuf)
        bgSiegeClasses[bgNumSiegeClasses].hasForcedSaber2Color = true
    } else {
        //It's ok if there isn't one, it's optional.
        bgSiegeClasses[bgNumSiegeClasses].hasForcedSaber2Color = false
    }

    //Parse weapons
    if BG_SiegeGetPairedValue(&classInfo, "weapons", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].weapons = BG_SiegeTranslateGenericTable(&parseBuf, WPTable, true)
    } else {
        Com_Error(ERR_DROP, "Siege class without weapons entry")
    }

    if !((bgSiegeClasses[bgNumSiegeClasses].weapons & (1 << WP_SABER)) != 0) {
        //make sure it has melee if there's no saber
        bgSiegeClasses[bgNumSiegeClasses].weapons |= (1 << WP_MELEE)

        //always give them this too if they are not a saber user
        //bgSiegeClasses[bgNumSiegeClasses].weapons |= (1 << WP_BRYAR_PISTOL);
    }

    //Parse forcepowers
    if BG_SiegeGetPairedValue(&classInfo, "forcepowers", &parseBuf) != 0 {
        BG_SiegeTranslateForcePowers(&parseBuf, bgSiegeClasses[bgNumSiegeClasses])
    } else {
        //fine, clear out the powers.
        i = 0
        while i < NUM_FORCE_POWERS {
            bgSiegeClasses[bgNumSiegeClasses].forcePowerLevels[i] = 0
            i += 1
        }
    }

    //Parse classflags
    if BG_SiegeGetPairedValue(&classInfo, "classflags", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].classflags = BG_SiegeTranslateGenericTable(&parseBuf, bgSiegeClassFlagNames, true)
    } else {
        //fine, we'll 0 it.
        bgSiegeClasses[bgNumSiegeClasses].classflags = 0
    }

    //Parse maxhealth
    if BG_SiegeGetPairedValue(&classInfo, "maxhealth", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].maxhealth = atoi(parseBuf)
    } else {
        //It's alright, just default to 100 then.
        bgSiegeClasses[bgNumSiegeClasses].maxhealth = 100
    }

    //Parse starthealth
    if BG_SiegeGetPairedValue(&classInfo, "starthealth", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].starthealth = atoi(parseBuf)
    } else {
        //It's alright, just default to 100 then.
        bgSiegeClasses[bgNumSiegeClasses].starthealth = bgSiegeClasses[bgNumSiegeClasses].maxhealth
    }


    //Parse startarmor
    if BG_SiegeGetPairedValue(&classInfo, "maxarmor", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].maxarmor = atoi(parseBuf)
    } else {
        //It's alright, just default to 0 then.
        bgSiegeClasses[bgNumSiegeClasses].maxarmor = 0
    }

    //Parse startarmor
    if BG_SiegeGetPairedValue(&classInfo, "startarmor", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].startarmor = atoi(parseBuf)
        if bgSiegeClasses[bgNumSiegeClasses].maxarmor == 0 {
            //if they didn't specify a damn max armor then use this.
            bgSiegeClasses[bgNumSiegeClasses].maxarmor = bgSiegeClasses[bgNumSiegeClasses].startarmor
        }
    } else {
        //default to maxarmor.
        bgSiegeClasses[bgNumSiegeClasses].startarmor = bgSiegeClasses[bgNumSiegeClasses].maxarmor
    }

    //Parse speed (this is a multiplier value)
    if BG_SiegeGetPairedValue(&classInfo, "speed", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].speed = atof(parseBuf)
    } else {
        //It's alright, just default to 1 then.
        bgSiegeClasses[bgNumSiegeClasses].speed = 1.0
    }

    //Parse shader for ui to use
    if BG_SiegeGetPairedValue(&classInfo, "uishader", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].uiPortraitShader = 0
        bgSiegeClasses[bgNumSiegeClasses].uiPortraitBuffer.zero()
    } else {
        //I guess this is an essential.. we don't want to render bad shaders or anything.
        Com_Error(ERR_DROP, "Siege class without uishader entry")
    }

    //Parse shader for ui to use
    if BG_SiegeGetPairedValue(&classInfo, "class_shader", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].classShader = 0
        //Com_Error( ERR_DROP, "ERROR: could not find class_shader %s for class %s\n", parseBuf, bgSiegeClasses[bgNumSiegeClasses].name );
        // A very hacky way to determine class . . .
        do {
            // Find the base player class based on the icon name - very bad, I know.
            let titleLength: Int32
            var i: Int32
            var arrayTitleLength: Int32
            var holdBuf = TextCursor()

            titleLength = strlen(parseBuf)
            i = 0
            while i < SPC_MAX {
                // Back up
                arrayTitleLength = strlen(classTitles[i])
                if arrayTitleLength > titleLength {
                    break
                }

                holdBuf = TextCursor(parseBuf, at: (titleLength - arrayTitleLength))
                if strcmp(holdBuf.text, classTitles[i]) == 0 {
                    bgSiegeClasses[bgNumSiegeClasses].playerClass = i
                    break
                }
                i += 1
            }

            // In case the icon name doesn't match up
            if i >= SPC_MAX {
                bgSiegeClasses[bgNumSiegeClasses].playerClass = SPC_INFANTRY
            }
        }
    } else {
        //No entry!  Bad bad bad
        //Com_Error( ERR_DROP, "ERROR: no class_shader defined for class %s\n", bgSiegeClasses[bgNumSiegeClasses].name );
        Com_Printf("ERROR: no class_shader defined for class %s\n", bgSiegeClasses[bgNumSiegeClasses].name)
    }

    //Parse holdable items to use
    if BG_SiegeGetPairedValue(&classInfo, "holdables", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].invenItems = BG_SiegeTranslateGenericTable(&parseBuf, HoldableTable, true)
    } else {
        //Just don't start out with any then.
        bgSiegeClasses[bgNumSiegeClasses].invenItems = 0
    }

    //Parse powerups to use
    if BG_SiegeGetPairedValue(&classInfo, "powerups", &parseBuf) != 0 {
        bgSiegeClasses[bgNumSiegeClasses].powerups = BG_SiegeTranslateGenericTable(&parseBuf, PowerupTable, true)
    } else {
        //Just don't start out with any then.
        bgSiegeClasses[bgNumSiegeClasses].powerups = 0
    }

    //A successful read.
    bgNumSiegeClasses += 1
}

// Count the number of like base classes
/// Source: oracle/codemp/game/bg_saga.c:1071
func BG_SiegeCountBaseClass(_ team: Int32, _ classIndex: Int32) -> Int32 {
    var count: Int32 = 0
    var i: Int32
    var stm: SiegeTeam?

    stm = BG_SiegeFindThemeForTeam(team)
    if stm == nil {
        return (0)
    }

    i = 0
    while i < stm!.numClasses {
        if stm!.classes[i]!.playerClass == classIndex {
            count += 1
        }
        i += 1
    }
    return (count)
}

/// Source: oracle/codemp/game/bg_saga.c:1094
func BG_GetUIPortraitFile(_ team: Int32, _ classIndex: Int32, _ cntIndex: Int32) -> String? {
    var count: Int32 = 0
    var i: Int32
    var stm: SiegeTeam?

    stm = BG_SiegeFindThemeForTeam(team)
    if stm == nil {
        return nil
    }

    // Loop through all the classes for this team
    i = 0
    while i < stm!.numClasses {
        // does it match the base class?
        if stm!.classes[i]!.playerClass == classIndex {
            if count == cntIndex {
                return (stm!.classes[i]!.uiPortrait)
            }
            count += 1
        }
        i += 1
    }

    return nil
}

/// Source: oracle/codemp/game/bg_saga.c:1123
func BG_GetUIPortrait(_ team: Int32, _ classIndex: Int32, _ cntIndex: Int32) -> Int32 {
    var count: Int32 = 0
    var i: Int32
    var stm: SiegeTeam?

    stm = BG_SiegeFindThemeForTeam(team)
    if stm == nil {
        return (0)
    }

    // Loop through all the classes for this team
    i = 0
    while i < stm!.numClasses {
        // does it match the base class?
        if stm!.classes[i]!.playerClass == classIndex {
            if count == cntIndex {
                return (stm!.classes[i]!.uiPortraitShader)
            }
            count += 1
        }
        i += 1
    }

    return (0)
}

// This is really getting ugly - looking to get the base class (within a class) based on the index passed in
/// Source: oracle/codemp/game/bg_saga.c:1153
func BG_GetClassOnBaseClass(_ team: Int32, _ classIndex: Int32, _ cntIndex: Int32) -> JKAMP.SiegeClass? {
    var count: Int32 = 0
    var i: Int32
    var stm: SiegeTeam?

    stm = BG_SiegeFindThemeForTeam(team)
    if stm == nil {
        return nil
    }

    // Loop through all the classes for this team
    i = 0
    while i < stm!.numClasses {
        // does it match the base class?
        if stm!.classes[i]!.playerClass == classIndex {
            if count == cntIndex {
                return (stm!.classes[i])
            }
            count += 1
        }
        i += 1
    }

    return nil
}

/// Source: oracle/codemp/game/bg_saga.c:1181
public func BG_SiegeLoadClasses(_ descBuffer: Slots<JKAMP.SiegeClassDesc>?) {
    let numFiles: Int32
    var filelen: Int32
    var filelist = CharBuf(4096)
    var filename = CharBuf(64)
    var fileptr = TextCursor()
    var i: Int32
    // Raven assigns his own `descBuffer` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var descBuffer = descBuffer

    bgNumSiegeClasses = 0

    let filled = trap_FS_GetFileList("ext_data/Siege/Classes", ".scl", 4096)
    numFiles = filled.0
    filelist = filled.1
    fileptr = TextCursor(filelist)

    i = 0
    while i < numFiles {
        filelen = strlen(fileptr.text)
        strcpy(&filename, "ext_data/Siege/Classes/")
        strcat(&filename, fileptr.text)

        if descBuffer != nil {
            BG_SiegeParseClassFile(String(filename), descBuffer![i])
        } else {
            BG_SiegeParseClassFile(String(filename), nil)
        }
        i += 1
        fileptr.advance(by: filelen + 1)
    }
}

//======================================
//Team loading functions
//======================================
/// Source: oracle/codemp/game/bg_saga.c:1219
func BG_SiegeFindClassByName(_ classname: String) -> JKAMP.SiegeClass? {
    var i: Int32 = 0

    while i < bgNumSiegeClasses {
        if Q_stricmp(bgSiegeClasses[i].name, classname) == 0 {
            //found it
            return bgSiegeClasses[i]
        }
        i += 1
    }

    return nil
}

/// Source: oracle/codemp/game/bg_saga.c:1235
func BG_SiegeParseTeamFile(_ filename: String) {
    var f: fileHandle_t = 0
    let len: Int32
    var teamInfo = CharBuf(2048)
    var parseBuf = CharBuf(1024)
    var lookString = CharBuf(256)
    var i: Int32 = 1
    var success: Bool = true

    len = trap_FS_FOpenFile(filename, &f, FS_READ)

    if f == 0 || len >= 2048 {
        return
    }

    trap_FS_Read(&teamInfo, len, f)

    trap_FS_FCloseFile(f)

    teamInfo[len] = 0

    if BG_SiegeGetPairedValue(&teamInfo, "name", &parseBuf) != 0 {
        strcpy(&bgSiegeTeams[bgNumSiegeTeams].nameBuffer, parseBuf)
    } else {
        Com_Error(ERR_DROP, "Siege team with no name definition")
    }

    //I don't entirely like doing things this way but it's the easiest way.
    bgSiegeTeams[bgNumSiegeTeams].friendlyShader = 0

    bgSiegeTeams[bgNumSiegeTeams].numClasses = 0

    // Raven passes `teamInfo` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy.
    var teamInfoIn0 = teamInfo
    if BG_SiegeGetValueGroup(&teamInfoIn0, "Classes", &teamInfo) != 0 {
        while success && i < MAX_SIEGE_CLASSES {
            //keep checking for group values named class# up to MAX_SIEGE_CLASSES until we can't find one.
            strcpy(&lookString, va("class%i", i))

            success = BG_SiegeGetPairedValue(&teamInfo, String(lookString), &parseBuf) != 0

            if !success {
                break
            }

            bgSiegeTeams[bgNumSiegeTeams].classes[bgSiegeTeams[bgNumSiegeTeams].numClasses] = BG_SiegeFindClassByName(String(parseBuf))

            if bgSiegeTeams[bgNumSiegeTeams].classes[bgSiegeTeams[bgNumSiegeTeams].numClasses] == nil {
                Com_Error(ERR_DROP, "Invalid class specified: '%s'", parseBuf)
            }

            bgSiegeTeams[bgNumSiegeTeams].numClasses += 1

            i += 1
        }
    }

    if bgSiegeTeams[bgNumSiegeTeams].numClasses == 0 {
        Com_Error(ERR_DROP, "Team defined with no allowable classes\n")
    }

    //If we get here then it was a success, so increment the team number
    bgNumSiegeTeams += 1
}

/// Source: oracle/codemp/game/bg_saga.c:1314
public func BG_SiegeLoadTeams() {
    let numFiles: Int32
    var filelen: Int32
    var filelist = CharBuf(4096)
    var filename = CharBuf(64)
    var fileptr = TextCursor()
    var i: Int32

    bgNumSiegeTeams = 0

    let filled = trap_FS_GetFileList("ext_data/Siege/Teams", ".team", 4096)
    numFiles = filled.0
    filelist = filled.1
    fileptr = TextCursor(filelist)

    i = 0
    while i < numFiles {
        filelen = strlen(fileptr.text)
        strcpy(&filename, "ext_data/Siege/Teams/")
        strcat(&filename, fileptr.text)
        BG_SiegeParseTeamFile(String(filename))
        i += 1
        fileptr.advance(by: filelen + 1)
    }
}

//======================================
//Misc/utility functions
//======================================
/// Source: oracle/codemp/game/bg_saga.c:1344
public func BG_SiegeFindThemeForTeam(_ team: Int32) -> JKAMP.SiegeTeam? {
    if team == SIEGETEAM_TEAM1 {
        return team1Theme
    } else if team == SIEGETEAM_TEAM2 {
        return team2Theme
    }

    return nil
}

/// Source: oracle/codemp/game/bg_saga.c:1363
public func BG_PrecacheSabersForSiegeTeam(_ team: Int32) {
    var t: SiegeTeam?
    // Raven's record lives to the end of his block, so the block is the closure.
    SaberInfo.scratch { saber in
        var saberName: String? = nil
        var sNum: Int32 = 0

        t = BG_SiegeFindThemeForTeam(team)

        if t != nil {
            var i: Int32 = 0

            while i < t!.numClasses {
                sNum = 0

                while sNum < MAX_SABERS {
                    switch sNum {
                    case 0:
                        saberName = t!.classes[i]!.saber1

                    case 1:
                        saberName = t!.classes[i]!.saber2

                    default:
                        saberName = nil
                    }

                    if saberName != nil && !saberName!.isEmpty {
                        WP_SaberParseParms(saberName!, saber)
                        if Q_stricmp(saberName!, saber.name) == 0 {
                            //found the matching saber
                            if !saber.model.isEmpty {
                                BG_ModelCache(saber.model, nil)
                            }
                        }
                    }

                    sNum += 1
                }

                i += 1
            }
        }
    }
}

/// Source: oracle/codemp/game/bg_saga.c:1416
public func BG_SiegeCheckClassLegality(_ team: Int32, _ classname: inout JKAShared.CharBuf) -> Bool {
    var i: Int32 = 0

    // Raven points `teamPtr` at one of the file-scope variables, and the statements after his choice run over the one he chose.
    // The chosen variable crosses as an inout parameter, and each arm of the choice calls the nested function with its own variable.
    func withTeamPtr(_ teamPtr: inout SiegeTeam?) -> Bool {
        // Raven's NULL test on teamPtr has no form here, because the draft crosses the chosen variable itself.
        if teamPtr == nil {
            //Well, guess the class is ok, seeing as there is no team theme to begin with.
            return true
        }

        //See if the class is listed on the team
        while i < teamPtr!.numClasses {
            if Q_stricmp(String(classname), teamPtr!.classes[i]!.name) == 0 {
                //found it, so it's alright
                return true
            }
            i += 1
        }

        //Didn't find it, so copy the name of the first valid class over it.
        strcpy(&classname, teamPtr!.classes[0]!.name)

        return false
    }
    if team == SIEGETEAM_TEAM1 {
        return withTeamPtr(&team1Theme)
    } else if team == SIEGETEAM_TEAM2 {
        return withTeamPtr(&team2Theme)
    } else {
        //spectator? Whatever, you're legal then.
        return true
    }
}

/// Source: oracle/codemp/game/bg_saga.c:1455
func BG_SiegeFindTeamForTheme(_ themeName: String) -> JKAMP.SiegeTeam? {
    var i: Int32 = 0

    while i < bgNumSiegeTeams {
        if !bgSiegeTeams[i].name.isEmpty && Q_stricmp(bgSiegeTeams[i].name, themeName) == 0 {
            //this is what we're looking for
            return bgSiegeTeams[i]
        }

        i += 1
    }

    return nil
}

/// Source: oracle/codemp/game/bg_saga.c:1473
public func BG_SiegeSetTeamTheme(_ team: Int32, _ themeName: String) {
    // Raven points `teamPtr` at one of the file-scope variables, and the statements after his choice run over the one he chose.
    // The chosen variable crosses as an inout parameter, and each arm of the choice calls the nested function with its own variable.
    func withTeamPtr(_ teamPtr: inout SiegeTeam?) {
        teamPtr = BG_SiegeFindTeamForTheme(themeName)
    }
    if team == SIEGETEAM_TEAM1 {
        withTeamPtr(&team1Theme)
    } else {
        withTeamPtr(&team2Theme)
    }
}

/// Source: oracle/codemp/game/bg_saga.c:1489
public func BG_SiegeFindClassIndexByName(_ classname: String) -> Int32 {
    var i: Int32 = 0

    while i < bgNumSiegeClasses {
        if Q_stricmp(bgSiegeClasses[i].name, classname) == 0 {
            //found it
            return i
        }
        i += 1
    }

    return -1
}
