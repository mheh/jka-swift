import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_ai_weight.cpp:30
let MAX_INVENTORYVALUE = 999999 as Int32

/// Source: oracle/codemp/botlib/be_ai_weight.cpp:33
let MAX_WEIGHT_FILES = 128 as Int32

/// Source: oracle/codemp/botlib/be_ai_weight.cpp:34
var weightFileList: Slots<Weightconfig?> { world.storage.weightFileList }

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:42
func ReadValue(_ source: Source, _ value: inout Float) -> Int32 {
    Token.scratch { token -> Int32 in
        if PC_ExpectAnyToken(source, token) == 0 { return 0 }
        if strcmp(token.string, "-") == 0 {
            SourceWarning(source, "negative value set to zero\n")
            if PC_ExpectTokenType(source, TT_NUMBER, 0, token) == 0 { return 0 }
        }
        if token.type != TT_NUMBER {
            SourceError(source, "invalid return value %s\n", token.string)
            return 0
        }
        value = Float(token.floatvalue)
        return 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:66
func ReadFuzzyWeight(_ source: Source, _ fs: Fuzzyseperator) -> Int32 {
    if PC_CheckTokenString(source, "balance") != 0 {
        fs.type = WT_BALANCE
        if PC_ExpectTokenString(source, "(") == 0 { return 0 }
        if ReadValue(source, &fs.weight) == 0 { return 0 }
        if PC_ExpectTokenString(source, ",") == 0 { return 0 }
        if ReadValue(source, &fs.minweight) == 0 { return 0 }
        if PC_ExpectTokenString(source, ",") == 0 { return 0 }
        if ReadValue(source, &fs.maxweight) == 0 { return 0 }
        if PC_ExpectTokenString(source, ")") == 0 { return 0 }
    } else {
        fs.type = 0
        if ReadValue(source, &fs.weight) == 0 { return 0 }
        fs.minweight = fs.weight
        fs.maxweight = fs.weight
    }
    if PC_ExpectTokenString(source, ";") == 0 { return 0 }
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:95
func FreeFuzzySeperators_r(_ fs: Fuzzyseperator) {
    if fs.child != nil { FreeFuzzySeperators_r(fs.child!) }
    if fs.next != nil { FreeFuzzySeperators_r(fs.next!) }
    FreeMemory(fs.handle)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:108
func FreeWeightConfig2(_ config: Weightconfig) {
    var i: Int32

    i = 0
    while i < config.numweights {
        FreeFuzzySeperators_r(config.weights[i].firstseperator!)
        // AI: Raven frees the GetMemory block of the name. The field holds a pooled text, so the free drops.
        i += 1
    }
    FreeMemory(config.handle)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:125
func FreeWeightConfig(_ config: Weightconfig) {
    if LibVarGetValue("bot_reloadcharacters") == 0 { return }
    FreeWeightConfig2(config)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:136
func ReadFuzzySeperators_r(_ source: Source) -> Fuzzyseperator? {
    var founddefault: Bool
    var lastfs: Fuzzyseperator?, firstfs: Fuzzyseperator?

    founddefault = false
    firstfs = nil
    lastfs = nil
    if PC_ExpectTokenString(source, "(") == 0 { return nil }
    return Token.scratch { token -> Fuzzyseperator? in
        var newindent: Bool, index: Int32, def: Bool
        var fs: Fuzzyseperator

        if PC_ExpectTokenType(source, TT_NUMBER, TT_INTEGER, token) == 0 { return nil }
        index = Int32(truncatingIfNeeded: token.intvalue)
        if PC_ExpectTokenString(source, ")") == 0 { return nil }
        if PC_ExpectTokenString(source, "{") == 0 { return nil }
        if PC_ExpectAnyToken(source, token) == 0 { return nil }
        repeat {
            def = strcmp(token.string, "default") == 0
            if def || strcmp(token.string, "case") == 0 {
                fs = Fuzzyseperator(GetClearedMemory(UInt32(Fuzzyseperator.byteCount)))
                fs.index = index
                if lastfs != nil {
                    lastfs!.next = fs
                } else {
                    firstfs = fs
                }
                lastfs = fs
                if def {
                    if founddefault {
                        SourceError(source, "switch already has a default\n")
                        FreeFuzzySeperators_r(firstfs!)
                        return nil
                    }
                    fs.value = MAX_INVENTORYVALUE
                    founddefault = true
                } else {
                    if PC_ExpectTokenType(source, TT_NUMBER, TT_INTEGER, token) == 0 {
                        FreeFuzzySeperators_r(firstfs!)
                        return nil
                    }
                    fs.value = Int32(truncatingIfNeeded: token.intvalue)
                }
                if PC_ExpectTokenString(source, ":") == 0 || PC_ExpectAnyToken(source, token) == 0 {
                    FreeFuzzySeperators_r(firstfs!)
                    return nil
                }
                newindent = false
                if strcmp(token.string, "{") == 0 {
                    newindent = true
                    if PC_ExpectAnyToken(source, token) == 0 {
                        FreeFuzzySeperators_r(firstfs!)
                        return nil
                    }
                }
                if strcmp(token.string, "return") == 0 {
                    if ReadFuzzyWeight(source, fs) == 0 {
                        FreeFuzzySeperators_r(firstfs!)
                        return nil
                    }
                } else if strcmp(token.string, "switch") == 0 {
                    fs.child = ReadFuzzySeperators_r(source)
                    if fs.child == nil {
                        FreeFuzzySeperators_r(firstfs!)
                        return nil
                    }
                } else {
                    SourceError(source, "invalid name %s\n", token.string)
                    return nil
                }
                if newindent {
                    if PC_ExpectTokenString(source, "}") == 0 {
                        FreeFuzzySeperators_r(firstfs!)
                        return nil
                    }
                }
            } else {
                // Port-note: Raven passes a NULL `firstfs` here when the first name is invalid, and FreeFuzzySeperators_r returns on NULL.
                // Its parameter is not optional, so the unwrap traps there, row P6 of the bot-ai round.
                FreeFuzzySeperators_r(firstfs!)
                SourceError(source, "invalid name %s\n", token.string)
                return nil
            }
            if PC_ExpectAnyToken(source, token) == 0 {
                FreeFuzzySeperators_r(firstfs!)
                return nil
            }
        } while strcmp(token.string, "}") != 0
        //
        if !founddefault {
            SourceWarning(source, "switch without default\n")
            fs = Fuzzyseperator(GetClearedMemory(UInt32(Fuzzyseperator.byteCount)))
            fs.index = index
            fs.value = MAX_INVENTORYVALUE
            fs.weight = 0
            fs.next = nil
            fs.child = nil
            if lastfs != nil {
                lastfs!.next = fs
            } else {
                firstfs = fs
            }
            lastfs = fs
        }
        //
        return firstfs
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:262
func ReadWeightConfig(_ filename: inout JKAShared.CharBuf) -> Weightconfig? {
    var avail: Int32 = 0, n: Int32
    var fs: Fuzzyseperator?
    var config: Weightconfig? = nil

    if LibVarGetValue("bot_reloadcharacters") == 0 {
        avail = -1
        n = 0
        while n < MAX_WEIGHT_FILES {
            config = weightFileList[n]
            if config == nil {
                if avail == -1 {
                    avail = n
                }
                n += 1
                continue
            }
            if strcmp(filename, config!.filename) == 0 {
                //botimport.Print( PRT_MESSAGE, "retained %s\n", filename );
                return config
            }
            n += 1
        }

        if avail == -1 {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print( PRT_ERROR, "weightFileList was full trying to load %s\n", filename );
            portMissing("ReadWeightConfig", source: "oracle/codemp/botlib/be_ai_weight.cpp:262")
            return nil
        }
    }

    PC_SetBaseFolder(BOTFILESBASEFOLDER)
    guard let source = LoadSourceFile(String(filename)) else {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "counldn't load %s\n", filename);
        portMissing("ReadWeightConfig", source: "oracle/codemp/botlib/be_ai_weight.cpp:262")
        return nil
    }
    //
    config = Weightconfig(GetClearedMemory(UInt32(Weightconfig.byteCount)))
    config!.numweights = 0
    Q_strncpyz(&config!.filenameBuffer, String(filename), Int32(config!.filenameBuffer.count))
    //parse the item config file
    let parsed = Token.scratch { token -> Bool in
        var newindent: Bool

        while PC_ReadToken(source, token) != 0 {
            if strcmp(token.string, "weight") == 0 {
                if config!.numweights >= MAX_WEIGHTS {
                    SourceWarning(source, "too many fuzzy weights\n")
                    break
                }
                if PC_ExpectTokenType(source, TT_STRING, 0, token) == 0 {
                    FreeWeightConfig(config!)
                    FreeSource(source)
                    return false
                }
                StripDoubleQuotes(&token.stringBuffer)
                // AI: Raven copies the text into a GetClearedMemory block. The call stays for the zone count, and the field takes the text.
                _ = GetClearedMemory(UInt32(strlen(token.string) + 1))
                config!.weights[config!.numweights].name = token.string
                if PC_ExpectAnyToken(source, token) == 0 {
                    FreeWeightConfig(config!)
                    FreeSource(source)
                    return false
                }
                newindent = false
                if strcmp(token.string, "{") == 0 {
                    newindent = true
                    if PC_ExpectAnyToken(source, token) == 0 {
                        FreeWeightConfig(config!)
                        FreeSource(source)
                        return false
                    }
                }
                if strcmp(token.string, "switch") == 0 {
                    fs = ReadFuzzySeperators_r(source)
                    if fs == nil {
                        FreeWeightConfig(config!)
                        FreeSource(source)
                        return false
                    }
                    config!.weights[config!.numweights].firstseperator = fs
                } else if strcmp(token.string, "return") == 0 {
                    fs = Fuzzyseperator(GetClearedMemory(UInt32(Fuzzyseperator.byteCount)))
                    fs!.index = 0
                    fs!.value = MAX_INVENTORYVALUE
                    fs!.next = nil
                    fs!.child = nil
                    if ReadFuzzyWeight(source, fs!) == 0 {
                        FreeMemory(fs!.handle)
                        FreeWeightConfig(config!)
                        FreeSource(source)
                        return false
                    }
                    config!.weights[config!.numweights].firstseperator = fs
                } else {
                    SourceError(source, "invalid name %s\n", token.string)
                    FreeWeightConfig(config!)
                    FreeSource(source)
                    return false
                }
                if newindent {
                    if PC_ExpectTokenString(source, "}") == 0 {
                        FreeWeightConfig(config!)
                        FreeSource(source)
                        return false
                    }
                }
                config!.numweights += 1
            } else {
                SourceError(source, "invalid name %s\n", token.string)
                FreeWeightConfig(config!)
                FreeSource(source)
                return false
            }
        }
        return true
    }
    if !parsed { return nil }
    //free the source at the end of a pass
    FreeSource(source)
    //if the file was located in a pak file
    // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
    // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded %s\n", filename);
    portMissing("ReadWeightConfig", source: "oracle/codemp/botlib/be_ai_weight.cpp:262")
    //
    if LibVarGetValue("bot_reloadcharacters") == 0 {
        weightFileList[avail] = config
    }
    //
    return config
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:540
func FindFuzzyWeight(_ wc: Weightconfig, _ name: String) -> Int32 {
    var i: Int32

    i = 0
    while i < wc.numweights {
        if strcmp(wc.weights[i].name!, name) == 0 {
            return i
        }
        i += 1
    }
    return -1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:559
func FuzzyWeight_r(_ inventory: Slots<Int32>, _ fs: Fuzzyseperator) -> Float {
    var scale: Float, w1: Float, w2: Float

    if inventory[fs.index] < fs.value {
        if fs.child != nil {
            return FuzzyWeight_r(inventory, fs.child!)
        } else {
            return fs.weight
        }
    } else if fs.next != nil {
        if inventory[fs.index] < fs.next!.value {
            //first weight
            if fs.child != nil {
                w1 = FuzzyWeight_r(inventory, fs.child!)
            } else {
                w1 = fs.weight
            }
            //second weight
            if fs.next!.child != nil {
                w2 = FuzzyWeight_r(inventory, fs.next!.child!)
            } else {
                w2 = fs.next!.weight
            }
            //the scale factor
            scale = Float((inventory[fs.index] - fs.value) / (fs.next!.value - fs.value))
            //scale between the two weights
            return scale * w1 + (1 - scale) * w2
        }
        return FuzzyWeight_r(inventory, fs.next!)
    }
    return fs.weight
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:593
func FuzzyWeightUndecided_r(_ inventory: Slots<Int32>, _ fs: Fuzzyseperator) -> Float {
    var scale: Float, w1: Float, w2: Float

    if inventory[fs.index] < fs.value {
        if fs.child != nil {
            return FuzzyWeightUndecided_r(inventory, fs.child!)
        } else {
            return fs.minweight + random() * (fs.maxweight - fs.minweight)
        }
    } else if fs.next != nil {
        if inventory[fs.index] < fs.next!.value {
            //first weight
            if fs.child != nil {
                w1 = FuzzyWeightUndecided_r(inventory, fs.child!)
            } else {
                w1 = fs.minweight + random() * (fs.maxweight - fs.minweight)
            }
            //second weight
            if fs.next!.child != nil {
                w2 = FuzzyWeight_r(inventory, fs.next!.child!)
            } else {
                w2 = fs.next!.minweight + random() * (fs.next!.maxweight - fs.next!.minweight)
            }
            //the scale factor
            scale = Float((inventory[fs.index] - fs.value) / (fs.next!.value - fs.value))
            //scale between the two weights
            return scale * w1 + (1 - scale) * w2
        }
        return FuzzyWeightUndecided_r(inventory, fs.next!)
    }
    return fs.weight
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:627
// Port-note: The `int *inventory` crosses as one `inout Int32`, and the body hands it to a `Slots<Int32>` parameter, row P4 of the bot-ai round (docket D16).
func FuzzyWeight(_ inventory: inout Int32, _ wc: Weightconfig, _ weightnum: Int32) -> Float {
    // TODO: Port FuzzyWeight
    portMissing("FuzzyWeight", source: "oracle/codemp/botlib/be_ai_weight.cpp:627")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:658
// Port-note: The `int *inventory` crosses as one `inout Int32`, and the body hands it to a `Slots<Int32>` parameter, row P4 of the bot-ai round (docket D16).
func FuzzyWeightUndecided(_ inventory: inout Int32, _ wc: Weightconfig, _ weightnum: Int32) -> Float {
    // TODO: Port FuzzyWeightUndecided
    portMissing("FuzzyWeightUndecided", source: "oracle/codemp/botlib/be_ai_weight.cpp:658")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:689
func EvolveFuzzySeperator_r(_ fs: Fuzzyseperator) {
    if fs.child != nil {
        EvolveFuzzySeperator_r(fs.child!)
    } else if fs.type == WT_BALANCE {
        //every once in a while an evolution leap occurs, mutation
        // Port-note: The dedicated logic target has no `crandom` of q_shared.h, row P7 of the bot-ai round.
        // Raven wrote: if (random() < 0.01) fs->weight += crandom() * (fs->maxweight - fs->minweight); else fs->weight += crandom() * (fs->maxweight - fs->minweight) * 0.5;
        portMissing("EvolveFuzzySeperator_r", source: "oracle/codemp/botlib/be_ai_weight.cpp:689")
        //modify bounds if necesary because of mutation
        if fs.weight < fs.minweight {
            fs.minweight = fs.weight
        } else if fs.weight > fs.maxweight {
            fs.maxweight = fs.weight
        }
    }
    if fs.next != nil { EvolveFuzzySeperator_r(fs.next!) }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:712
func EvolveWeightConfig(_ config: Weightconfig) {
    var i: Int32

    i = 0
    while i < config.numweights {
        EvolveFuzzySeperator_r(config.weights[i].firstseperator!)
        i += 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:727
func ScaleFuzzySeperator_r(_ fs: Fuzzyseperator, _ scale: Float) {
    if fs.child != nil {
        ScaleFuzzySeperator_r(fs.child!, scale)
    } else if fs.type == WT_BALANCE {
        //
        fs.weight = (fs.maxweight + fs.minweight) * scale
        //get the weight between bounds
        if fs.weight < fs.minweight {
            fs.weight = fs.minweight
        } else if fs.weight > fs.maxweight {
            fs.weight = fs.maxweight
        }
    }
    if fs.next != nil { ScaleFuzzySeperator_r(fs.next!, scale) }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:749
func ScaleWeight(_ config: Weightconfig, _ name: String, _ scale: Float) {
    var scale = scale
    var i: Int32

    if scale < 0 {
        scale = 0
    } else if scale > 1 {
        scale = 1
    }
    i = 0
    while i < config.numweights {
        if strcmp(name, config.weights[i].name!) == 0 {
            ScaleFuzzySeperator_r(config.weights[i].firstseperator!, scale)
            break
        }
        i += 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:770
func ScaleFuzzySeperatorBalanceRange_r(_ fs: Fuzzyseperator, _ scale: Float) {
    if fs.child != nil {
        ScaleFuzzySeperatorBalanceRange_r(fs.child!, scale)
    } else if fs.type == WT_BALANCE {
        let mid = Float(Double(fs.minweight + fs.maxweight) * 0.5)
        //get the weight between bounds
        fs.maxweight = mid + (fs.maxweight - mid) * scale
        fs.minweight = mid + (fs.minweight - mid) * scale
        if fs.maxweight < fs.minweight {
            fs.maxweight = fs.minweight
        }
    }
    if fs.next != nil { ScaleFuzzySeperatorBalanceRange_r(fs.next!, scale) }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:795
func ScaleFuzzyBalanceRange(_ config: Weightconfig, _ scale: Float) {
    var scale = scale
    var i: Int32

    if scale < 0 {
        scale = 0
    } else if scale > 100 {
        scale = 100
    }
    i = 0
    while i < config.numweights {
        ScaleFuzzySeperatorBalanceRange_r(config.weights[i].firstseperator!, scale)
        i += 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:812
func InterbreedFuzzySeperator_r(_ fs1: Fuzzyseperator, _ fs2: Fuzzyseperator, _ fsout: Fuzzyseperator) -> Int32 {
    if fs1.child != nil {
        if fs2.child == nil || fsout.child == nil {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_ERROR, "cannot interbreed weight configs, unequal child\n");
            portMissing("InterbreedFuzzySeperator_r", source: "oracle/codemp/botlib/be_ai_weight.cpp:812")
            return 0
        }
        if InterbreedFuzzySeperator_r(fs2.child!, fs2.child!, fsout.child!) == 0 {
            return 0
        }
    } else if fs1.type == WT_BALANCE {
        if fs2.type != WT_BALANCE || fsout.type != WT_BALANCE {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_ERROR, "cannot interbreed weight configs, unequal balance\n");
            portMissing("InterbreedFuzzySeperator_r", source: "oracle/codemp/botlib/be_ai_weight.cpp:812")
            return 0
        }
        fsout.weight = (fs1.weight + fs2.weight) / 2
        if fsout.weight > fsout.maxweight { fsout.maxweight = fsout.weight }
        if fsout.weight > fsout.minweight { fsout.minweight = fsout.weight }
    }
    if fs1.next != nil {
        if fs2.next == nil || fsout.next == nil {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_ERROR, "cannot interbreed weight configs, unequal next\n");
            portMissing("InterbreedFuzzySeperator_r", source: "oracle/codemp/botlib/be_ai_weight.cpp:812")
            return 0
        }
        if InterbreedFuzzySeperator_r(fs1.next!, fs2.next!, fsout.next!) == 0 {
            return 0
        }
    }
    return 1
}

//===========================================================================
// config1 and config2 are interbreeded and stored in configout
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:859
func InterbreedWeightConfigs(_ config1: Weightconfig, _ config2: Weightconfig, _ configout: Weightconfig) {
    var i: Int32

    if config1.numweights != config2.numweights ||
        config1.numweights != configout.numweights {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "cannot interbreed weight configs, unequal numweights\n");
        portMissing("InterbreedWeightConfigs", source: "oracle/codemp/botlib/be_ai_weight.cpp:859")
        return
    }
    i = 0
    while i < config1.numweights {
        _ = InterbreedFuzzySeperator_r(config1.weights[i].firstseperator!, config2.weights[i].firstseperator!, configout.weights[i].firstseperator!)
        i += 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weight.cpp:883
func BotShutdownWeights() {
    var i: Int32

    i = 0
    while i < MAX_WEIGHT_FILES {
        if weightFileList[i] != nil {
            FreeWeightConfig2(weightFileList[i]!)
            weightFileList[i] = nil
        }
        i += 1
    }
}
