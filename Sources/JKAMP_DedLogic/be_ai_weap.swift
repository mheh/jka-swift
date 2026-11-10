import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_ai_weap.cpp:38
// Raven wrote: static fielddef_t weaponinfo_fields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/botlib/be_ai_weap.cpp:66
// Raven wrote: static fielddef_t projectileinfo_fields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/botlib/be_ai_weap.cpp:86
// Raven wrote: static structdef_t weaponinfo_struct
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/botlib/be_ai_weap.cpp:90
// Raven wrote: static structdef_t projectileinfo_struct
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/botlib/be_ai_weap.cpp:111
var botweaponstates: Slots<BotWeaponstate?> { world.storage.botweaponstates }

/// Source: oracle/codemp/botlib/be_ai_weap.cpp:112
var weaponconfig: Weaponconfig? {
    get { world.variables.weaponconfig }
    set { world.variables.weaponconfig = newValue }
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:120
func BotValidWeaponNumber(_ weaponnum: Int32) -> Int32 {
    if weaponnum <= 0 || weaponnum > weaponconfig!.numweapons {
        botimport.runPrint(PRT_ERROR, "weapon number out of range\n")
        return 0
    }
    return 1
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:135
func BotWeaponStateFromHandle(_ handle: Int32) -> BotWeaponstate? {
    if handle <= 0 || handle > MAX_CLIENTS {
        botimport.runPrint(PRT_FATAL, "move state handle %d out of range\n", handle)
        return nil
    }
    if botweaponstates[handle] == nil {
        botimport.runPrint(PRT_FATAL, "invalid move state %d\n", handle)
        return nil
    }
    return botweaponstates[handle]
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:181
func LoadWeaponConfig(_ filename: String) -> Weaponconfig? {
    var max_weaponinfo: Int32, max_projectileinfo: Int32
    var path = CharBuf(MAX_PATH)
    var i: Int32, j: Int32
    let wc: Weaponconfig

    max_weaponinfo = Int32(LibVarValue("max_weaponinfo", "32"))
    if max_weaponinfo < 0 {
        botimport.runPrint(PRT_ERROR, "max_weaponinfo = %d\n", max_weaponinfo)
        max_weaponinfo = 32
        LibVarSet("max_weaponinfo", "32")
    }
    max_projectileinfo = Int32(LibVarValue("max_projectileinfo", "32"))
    if max_projectileinfo < 0 {
        botimport.runPrint(PRT_ERROR, "max_projectileinfo = %d\n", max_projectileinfo)
        max_projectileinfo = 32
        LibVarSet("max_projectileinfo", "32")
    }
    strncpy(&path, filename, MAX_PATH)
    PC_SetBaseFolder(BOTFILESBASEFOLDER)
    guard let source = LoadSourceFile(String(path)) else {
        botimport.runPrint(PRT_ERROR, "counldn't load %s\n", String(path))
        return nil
    }
    //initialize weapon config
    // The tables of `max_weaponinfo` weapon infos and `max_projectileinfo` projectile infos follow the record in the block.
    let wcBlock = GetClearedHunkMemory(UInt32(Int32(Weaponconfig.byteCount) + max_weaponinfo * Int32(Weaponinfo.byteCount) + max_projectileinfo * Int32(Projectileinfo.byteCount)))
    wc = Weaponconfig(wcBlock)
    wc.weaponinfo = Weaponinfo(wcBlock + Weaponconfig.byteCount)
    wc.projectileinfo = Projectileinfo(wcBlock + Weaponconfig.byteCount + max_weaponinfo * Int32(Weaponinfo.byteCount))
    wc.numweapons = max_weaponinfo
    wc.numprojectiles = 0
    //parse the source file
    let parsed = Token.scratch { token -> Bool in
        Weaponinfo.scratch { weaponinfo -> Bool in
            while PC_ReadToken(source, token) != 0 {
                if strcmp(token.string, "weaponinfo") == 0 {
                    weaponinfo.clear()
                    // The record crosses to ReadStructure as the raw pointer over its slot, under rule 11.
                    if ReadStructure(source, weaponinfo_struct, UnsafeMutableRawPointer(weaponinfo.handle)) == 0 {
                        FreeMemory(wc.handle)
                        FreeSource(source)
                        return false
                    }
                    if weaponinfo.number < 0 || weaponinfo.number >= max_weaponinfo {
                        botimport.runPrint(PRT_ERROR, "weapon info number %d out of range in %s\n", weaponinfo.number, String(path))
                        FreeMemory(wc.handle)
                        FreeSource(source)
                        return false
                    }
                    wc.weaponinfoSlots[weaponinfo.number].copy(from: weaponinfo)
                    wc.weaponinfoSlots[weaponinfo.number].valid = 1
                } else if strcmp(token.string, "projectileinfo") == 0 {
                    if wc.numprojectiles >= max_projectileinfo {
                        botimport.runPrint(PRT_ERROR, "more than %d projectiles defined in %s\n", max_projectileinfo, String(path))
                        FreeMemory(wc.handle)
                        FreeSource(source)
                        return false
                    }
                    wc.projectileinfoSlots[wc.numprojectiles].clear()
                    // The record crosses to ReadStructure as the raw pointer over its slot, under rule 11.
                    if ReadStructure(source, projectileinfo_struct, UnsafeMutableRawPointer(wc.projectileinfoSlots[wc.numprojectiles].handle)) == 0 {
                        FreeMemory(wc.handle)
                        FreeSource(source)
                        return false
                    }
                    wc.numprojectiles += 1
                } else {
                    botimport.runPrint(PRT_ERROR, "unknown definition %s in %s\n", token.string, String(path))
                    FreeMemory(wc.handle)
                    FreeSource(source)
                    return false
                }
            }
            return true
        }
    }
    if !parsed { return nil }
    FreeSource(source)
    //fix up weapons
    i = 0
    while i < wc.numweapons {
        if wc.weaponinfoSlots[i].valid == 0 {
            i += 1
            continue
        }
        if wc.weaponinfoSlots[i].name.isEmpty {
            botimport.runPrint(PRT_ERROR, "weapon %d has no name in %s\n", i, String(path))
            FreeMemory(wc.handle)
            return nil
        }
        if wc.weaponinfoSlots[i].projectile.isEmpty {
            botimport.runPrint(PRT_ERROR, "weapon %s has no projectile in %s\n", wc.weaponinfoSlots[i].name, String(path))
            FreeMemory(wc.handle)
            return nil
        }
        //find the projectile info and copy it to the weapon info
        j = 0
        while j < wc.numprojectiles {
            if strcmp(wc.projectileinfoSlots[j].name, wc.weaponinfoSlots[i].projectile) == 0 {
                wc.weaponinfoSlots[i].proj = wc.projectileinfoSlots[j]
                break
            }
            j += 1
        }
        if j == wc.numprojectiles {
            botimport.runPrint(PRT_ERROR, "weapon %s uses undefined projectile in %s\n", wc.weaponinfoSlots[i].name, String(path))
            FreeMemory(wc.handle)
            return nil
        }
        i += 1
    }
    if wc.numweapons == 0 {
        botimport.runPrint(PRT_WARNING, "no weapon info loaded\n")
    }
    botimport.runPrint(PRT_MESSAGE, "loaded %s\n", String(path))
    return wc
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:313
func WeaponWeightIndex(_ wwc: Weightconfig, _ wc: Weaponconfig) -> Slots<Int32> {
    var index: Slots<Int32>, i: Int32

    //initialize item weight index
    index = Slots<Int32>(scalars: GetClearedMemory(Int32(Int32.byteCount) * wc.numweapons), count: Int(wc.numweapons))

    i = 0
    while i < wc.numweapons {
        index[i] = FindFuzzyWeight(wwc, wc.weaponinfoSlots[i].name)
        i += 1
    }
    return index
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:332
func BotFreeWeaponWeights(_ weaponstate: Int32) {
    guard let ws = BotWeaponStateFromHandle(weaponstate) else { return }
    if ws.weaponweightconfig != nil { FreeWeightConfig(ws.weaponweightconfig!) }
    if ws.weaponweightindex != nil { FreeMemory(OpaquePointer(ws.weaponweightindex!.base)) }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:347
func BotLoadWeaponWeights(_ weaponstate: Int32, _ filename: inout JKAShared.CharBuf) -> Int32 {
    guard let ws = BotWeaponStateFromHandle(weaponstate) else { return BLERR_CANNOTLOADWEAPONWEIGHTS }
    BotFreeWeaponWeights(weaponstate)
    //
    ws.weaponweightconfig = ReadWeightConfig(&filename)
    if ws.weaponweightconfig == nil {
        botimport.runPrint(PRT_FATAL, "couldn't load weapon config %s\n", String(filename))
        return BLERR_CANNOTLOADWEAPONWEIGHTS
    }
    if weaponconfig == nil { return BLERR_CANNOTLOADWEAPONCONFIG }
    ws.weaponweightindex = WeaponWeightIndex(ws.weaponweightconfig!, weaponconfig!)
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:371
func BotGetWeaponInfo(_ weaponstate: Int32, _ weapon: Int32, _ weaponinfo: Weaponinfo) {
    if BotValidWeaponNumber(weapon) == 0 { return }
    if BotWeaponStateFromHandle(weaponstate) == nil { return }
    if weaponconfig == nil { return }
    weaponinfo.copy(from: weaponconfig!.weaponinfoSlots[weapon])
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:387
func BotChooseBestFightWeapon(_ weaponstate: Int32, _ inventory: Slots<Int32>) -> Int32 {
    var i: Int32, index: Int32, bestweapon: Int32
    var weight: Float, bestweight: Float
    let wc: Weaponconfig?

    guard let ws = BotWeaponStateFromHandle(weaponstate) else { return 0 }
    wc = weaponconfig
    if weaponconfig == nil { return 0 }

    //if the bot has no weapon weight configuration
    if ws.weaponweightconfig == nil { return 0 }

    bestweight = 0
    bestweapon = 0
    i = 0
    while i < wc!.numweapons {
        if wc!.weaponinfoSlots[i].valid == 0 {
            i += 1
            continue
        }
        index = ws.weaponweightindex![i]
        if index < 0 {
            i += 1
            continue
        }
        weight = FuzzyWeight(inventory, ws.weaponweightconfig!, index)
        if weight > bestweight {
            bestweight = weight
            bestweapon = i
        }
        i += 1
    }
    return bestweapon
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:424
func BotResetWeaponState(_ weaponstate: Int32) {
    let weaponweightconfig: Weightconfig?
    let weaponweightindex: Slots<Int32>?

    guard let ws = BotWeaponStateFromHandle(weaponstate) else { return }
    weaponweightconfig = ws.weaponweightconfig
    weaponweightindex = ws.weaponweightindex

    //Com_Memset(ws, 0, sizeof(bot_weaponstate_t));
    ws.weaponweightconfig = weaponweightconfig
    ws.weaponweightindex = weaponweightindex
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:445
func BotAllocWeaponState() -> Int32 {
    var i: Int32

    i = 1
    while i <= MAX_CLIENTS {
        if botweaponstates[i] == nil {
            botweaponstates[i] = BotWeaponstate(GetClearedMemory(UInt32(BotWeaponstate.byteCount)))
            return i
        }
        i += 1
    }
    return 0
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:465
func BotFreeWeaponState(_ handle: Int32) {
    if handle <= 0 || handle > MAX_CLIENTS {
        botimport.runPrint(PRT_FATAL, "move state handle %d out of range\n", handle)
        return
    }
    if botweaponstates[handle] == nil {
        botimport.runPrint(PRT_FATAL, "invalid move state %d\n", handle)
        return
    }
    BotFreeWeaponWeights(handle)
    FreeMemory(botweaponstates[handle]!.handle)
    botweaponstates[handle] = nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:487
func BotSetupWeaponAI() -> Int32 {
    let file: String

    file = LibVarString("weaponconfig", "weapons.c")
    weaponconfig = LoadWeaponConfig(file)
    if weaponconfig == nil {
        botimport.runPrint(PRT_FATAL, "couldn't load the weapon config\n")
        return BLERR_CANNOTLOADWEAPONCONFIG
    }

    //
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_weap.cpp:511
func BotShutdownWeaponAI() {
    var i: Int32

    if weaponconfig != nil { FreeMemory(weaponconfig!.handle) }
    weaponconfig = nil

    i = 1
    while i <= MAX_CLIENTS {
        if botweaponstates[i] != nil {
            BotFreeWeaponState(i)
        }
        i += 1
    }
}
