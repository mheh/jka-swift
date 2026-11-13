import Foundation
import JKAMP
import JKAShared
import JKAMP_UI
import JKAMP_BG

/// Source: oracle/codemp/ui/ui_force.c:15
public var uiForceSide: Int32 {
    get { world.variables.uiForceSide }
    set { world.variables.uiForceSide = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:16
public var uiJediNonJedi: Int32 {
    get { world.variables.uiJediNonJedi }
    set { world.variables.uiJediNonJedi = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:17
public var uiForceRank: Int32 {
    get { world.variables.uiForceRank }
    set { world.variables.uiForceRank = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:18
public var uiMaxRank: Int32 {
    get { world.variables.uiMaxRank }
    set { world.variables.uiMaxRank = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:19
// Raven wrote: int uiMaxPoints = 20
public let uiMaxPoints: Int32 = 20

/// Source: oracle/codemp/ui/ui_force.c:20
public var uiForceUsed: Int32 {
    get { world.variables.uiForceUsed }
    set { world.variables.uiForceUsed = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:21
public var uiForceAvailable: Int32 {
    get { world.variables.uiForceAvailable }
    set { world.variables.uiForceAvailable = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:25
public var gTouchedForce: Bool {
    get { world.variables.gTouchedForce }
    set { world.variables.gTouchedForce = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:26
public var ui_freeSaber: JKAMP.VmCvar { world.storage.ui_freeSaber }

/// Source: oracle/codemp/ui/ui_force.c:26
public var ui_forcePowerDisable: JKAMP.VmCvar { world.storage.ui_forcePowerDisable }

/// Source: oracle/codemp/ui/ui_force.c:32
/// Raven's data table, a hand property of `UIWorld`.
public var uiForcePowersDisabled: [Bool] {
    get { world.uiForcePowersDisabled }
    set { world.uiForcePowersDisabled = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:53
/// Raven's data table, a hand property of `UIWorld`.
public var uiForcePowersRank: [Int32] {
    get { world.uiForcePowersRank }
    set { world.uiForcePowersRank = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:74
// Raven wrote: int uiForcePowerDarkLight[NUM_FORCE_POWERS]
public let uiForcePowerDarkLight: [Int32] = //0 == neutral
[ //nothing should be usable at rank 0..
    FORCE_LIGHTSIDE,//FP_HEAL,//instant
    0,//FP_LEVITATION,//hold/duration
    0,//FP_SPEED,//duration
    0,//FP_PUSH,//hold/duration
    0,//FP_PULL,//hold/duration
    FORCE_LIGHTSIDE,//FP_TELEPATHY,//instant
    FORCE_DARKSIDE,//FP_GRIP,//hold/duration
    FORCE_DARKSIDE,//FP_LIGHTNING,//hold/duration
    FORCE_DARKSIDE,//FP_RAGE,//duration
    FORCE_LIGHTSIDE,//FP_PROTECT,//duration
    FORCE_LIGHTSIDE,//FP_ABSORB,//duration
    FORCE_LIGHTSIDE,//FP_TEAM_HEAL,//instant
    FORCE_DARKSIDE,//FP_TEAM_FORCE,//instant
    FORCE_DARKSIDE,//FP_DRAIN,//hold/duration
    0,//FP_SEE,//duration
    0,//FP_SABER_OFFENSE,
    0,//FP_SABER_DEFENSE,
    0//FP_SABERTHROW,
        //NUM_FORCE_POWERS
]

/// Source: oracle/codemp/ui/ui_force.c:97
public var uiForceStarShaders: [[Int32]] {
    get { world.variables.uiForceStarShaders }
    set { world.variables.uiForceStarShaders = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:98
public var uiSaberColorShaders: [Int32] {
    get { world.variables.uiSaberColorShaders }
    set { world.variables.uiSaberColorShaders = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:1081
public var gCustRank: Int32 {
    get { world.variables.gCustRank }
    set { world.variables.gCustRank = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:1082
public var gCustSide: Int32 {
    get { world.variables.gCustSide }
    set { world.variables.gCustSide = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:1084
/// Raven's data table, a hand property of `UIWorld`.
public var gCustPowersRank: [Int32] {
    get { world.gCustPowersRank }
    set { world.gCustPowersRank = newValue }
}

/// Source: oracle/codemp/ui/ui_force.c:99
public func UI_InitForceShaders() {
    uiForceStarShaders[0][0] = trap_R_RegisterShaderNoMip("forcestar0")
    uiForceStarShaders[0][1] = trap_R_RegisterShaderNoMip("forcestar0")
    uiForceStarShaders[1][0] = trap_R_RegisterShaderNoMip("forcecircle1")
    uiForceStarShaders[1][1] = trap_R_RegisterShaderNoMip("forcestar1")
    uiForceStarShaders[2][0] = trap_R_RegisterShaderNoMip("forcecircle2")
    uiForceStarShaders[2][1] = trap_R_RegisterShaderNoMip("forcestar2")
    uiForceStarShaders[3][0] = trap_R_RegisterShaderNoMip("forcecircle3")
    uiForceStarShaders[3][1] = trap_R_RegisterShaderNoMip("forcestar3")
    uiForceStarShaders[4][0] = trap_R_RegisterShaderNoMip("forcecircle4")
    uiForceStarShaders[4][1] = trap_R_RegisterShaderNoMip("forcestar4")
    uiForceStarShaders[5][0] = trap_R_RegisterShaderNoMip("forcecircle5")
    uiForceStarShaders[5][1] = trap_R_RegisterShaderNoMip("forcestar5")
    uiForceStarShaders[6][0] = trap_R_RegisterShaderNoMip("forcecircle6")
    uiForceStarShaders[6][1] = trap_R_RegisterShaderNoMip("forcestar6")
    uiForceStarShaders[7][0] = trap_R_RegisterShaderNoMip("forcecircle7")
    uiForceStarShaders[7][1] = trap_R_RegisterShaderNoMip("forcestar7")
    uiForceStarShaders[8][0] = trap_R_RegisterShaderNoMip("forcecircle8")
    uiForceStarShaders[8][1] = trap_R_RegisterShaderNoMip("forcestar8")

    uiSaberColorShaders[SABER_RED] = trap_R_RegisterShaderNoMip("menu/art/saber_red")
    uiSaberColorShaders[SABER_ORANGE] = trap_R_RegisterShaderNoMip("menu/art/saber_orange")
    uiSaberColorShaders[SABER_YELLOW] = trap_R_RegisterShaderNoMip("menu/art/saber_yellow")
    uiSaberColorShaders[SABER_GREEN] = trap_R_RegisterShaderNoMip("menu/art/saber_green")
    uiSaberColorShaders[SABER_BLUE] = trap_R_RegisterShaderNoMip("menu/art/saber_blue")
    uiSaberColorShaders[SABER_PURPLE] = trap_R_RegisterShaderNoMip("menu/art/saber_purple")
}

// Draw the stars spent on the current force power
/// Source: oracle/codemp/ui/ui_force.c:129
public func UI_DrawForceStars(_ rect: JKAMP.RectDef, _ scale: Float, _ color: JKAShared.vec4_t, _ textStyle: Int32, _ forceindex: Int32, _ val: Int32, _ min: Int32, _ max: Int32) {
    // Raven assigns his own `val` parameter.
    // A Swift parameter is immutable, so the body takes a mutable copy of it.
    var val = val
    var i: Int32
    let pad: Int32 = 4
    var xPos: Int32
    let width: Int32 = 16
    var starcolor: Int32

    if val < min || val > max {
        val = min
    }

    if 1 != 0 {	// if (val)
        xPos = Int32(rect.x)

        i = FORCE_LEVEL_1
        while i <= max {
            starcolor = bgForcePowerCost[forceindex][i]

            if uiForcePowersDisabled[forceindex] {
                let grColor = vec4_t(0.2, 0.2, 0.2, 1.0)
                trap_R_SetColor(grColor)
            }

            if val >= i {
                // Draw a star.
                UI_DrawHandlePic(Float(xPos), rect.y + 6, Float(width), Float(width), uiForceStarShaders[starcolor][1])
            } else {
                // Draw a circle.
                UI_DrawHandlePic(Float(xPos), rect.y + 6, Float(width), Float(width), uiForceStarShaders[starcolor][0])
            }

            if uiForcePowersDisabled[forceindex] {
                trap_R_SetColor(nil)
            }

            xPos += width + pad
            i += 1
        }
    }
}

// Set the client's force power layout.
/// Source: oracle/codemp/ui/ui_force.c:174
public func UI_UpdateClientForcePowers(_ teamArg: String?) {
    trap_Cvar_Set(
        "forcepowers",
        va(
            "%i-%i-%i%i%i%i%i%i%i%i%i%i%i%i%i%i%i%i%i%i",
            uiForceRank,
            uiForceSide,
            uiForcePowersRank[0],
            uiForcePowersRank[1],
            uiForcePowersRank[2],
            uiForcePowersRank[3],
            uiForcePowersRank[4],
            uiForcePowersRank[5],
            uiForcePowersRank[6],
            uiForcePowersRank[7],
            uiForcePowersRank[8],
            uiForcePowersRank[9],
            uiForcePowersRank[10],
            uiForcePowersRank[11],
            uiForcePowersRank[12],
            uiForcePowersRank[13],
            uiForcePowersRank[14],
            uiForcePowersRank[15],
            uiForcePowersRank[16],
            uiForcePowersRank[17]
        )
    )

    if gTouchedForce {
        if teamArg != nil && !teamArg!.isEmpty {
            trap_Cmd_ExecuteText(EXEC_APPEND, va("forcechanged \"%s\"\n", teamArg!))
        } else {
            trap_Cmd_ExecuteText(EXEC_APPEND, "forcechanged\n")
        }
    }

    gTouchedForce = false
}

/// Source: oracle/codemp/ui/ui_force.c:200
public func UI_TranslateFCFIndex(_ index: Int32) -> Int32 {
    if uiForceSide == FORCE_LIGHTSIDE {
        return index - uiInfo.forceConfigLightIndexBegin
    }

    return index - uiInfo.forceConfigDarkIndexBegin
}

/// Source: oracle/codemp/ui/ui_force.c:210
public func UI_SaveForceTemplate() {
    let selectedName = UI_Cvar_VariableString("ui_SaveFCF")
    var fcfString = CharBuf(512)
    var forceStringValue = CharBuf(4)
    var f: fileHandle_t = 0
    var strPlace: Int32 = 0
    var forcePlace: Int32 = 0
    var i: Int32 = 0
    var foundFeederItem = false

    if selectedName.isEmpty {
        Com_Printf("You did not provide a name for the template.\n")
        return
    }

    if uiForceSide == FORCE_LIGHTSIDE {
        //write it into the light side folder
        trap_FS_FOpenFile(va("forcecfg/light/%s.fcf", selectedName), &f, FS_WRITE)
    } else {
        //if it isn't light it must be dark
        trap_FS_FOpenFile(va("forcecfg/dark/%s.fcf", selectedName), &f, FS_WRITE)
    }

    if f == 0 {
        Com_Printf("There was an error writing the template file (read-only?).\n")
        return
    }

    Com_sprintf(&fcfString, Int32((fcfString).count), "%i-%i-", uiForceRank, uiForceSide)
    strPlace = strlen(fcfString)

    while forcePlace < NUM_FORCE_POWERS {
        Com_sprintf(&forceStringValue, Int32((forceStringValue).count), "%i", uiForcePowersRank[forcePlace])
        //Just use the force digit even if multiple digits. Shouldn't be longer than 1.
        fcfString[strPlace] = forceStringValue[0]
        strPlace += 1
        forcePlace += 1
    }
    fcfString[strPlace] = Int32(ascii: "\n")
    fcfString[strPlace + 1] = 0

    trap_FS_Write(&fcfString, strlen(fcfString), f)
    trap_FS_FCloseFile(f)

    Com_Printf("Template saved as \"%s\".\n", selectedName)

    //Now, update the FCF list
    UI_LoadForceConfig_List()

    //Then, scroll through and select the template for the file we just saved
    while i < uiInfo.forceConfigCount {
        if Q_stricmp(uiInfo.forceConfigNames[i], selectedName) == 0 {
            if (uiForceSide == FORCE_LIGHTSIDE && uiInfo.forceConfigSide[i])
                || (uiForceSide == FORCE_DARKSIDE && !uiInfo.forceConfigSide[i]) {
                Menu_SetFeederSelection(nil, FEEDER_FORCECFG, UI_TranslateFCFIndex(i), nil)
                foundFeederItem = true
            }
        }

        i += 1
    }

    //Else, go back to 0
    if !foundFeederItem {
        Menu_SetFeederSelection(nil, FEEDER_FORCECFG, 0, nil)
    }
}

/// Source: oracle/codemp/ui/ui_force.c:290
public func UpdateForceUsed() {
    var curpower: Int32
    var currank: Int32
    var menu: MenuDef?

    // Currently we don't make a distinction between those that wish to play Jedi of lower than maximum skill.
    uiForceRank = uiMaxRank

    uiForceUsed = 0
    uiForceAvailable = forceMasteryPoints[uiForceRank]

    // Make sure that we have one freebie in jump.
    if uiForcePowersRank[FP_LEVITATION] < 1 {
        uiForcePowersRank[FP_LEVITATION] = 1
    }

    if UI_TrueJediEnabled() {
        //true jedi mode is set
        if uiJediNonJedi == -1 {
            var x: Int32 = 0
            var clear = false
            var update = false
            uiJediNonJedi = FORCE_NONJEDI
            while x < NUM_FORCE_POWERS {
                //if any force power is set, we must be a jedi
                if x == FP_LEVITATION || x == FP_SABER_OFFENSE {
                    if uiForcePowersRank[x] > 1 {
                        uiJediNonJedi = FORCE_JEDI
                        break
                    } else if uiForcePowersRank[x] > 0 {
                        clear = true
                    }
                } else if uiForcePowersRank[x] > 0 {
                    uiJediNonJedi = FORCE_JEDI
                    break
                }
                x += 1
            }
            if uiJediNonJedi == FORCE_JEDI {
                if uiForcePowersRank[FP_SABER_OFFENSE] < 1 {
                    uiForcePowersRank[FP_SABER_OFFENSE] = 1
                    update = true
                }
            } else if clear {
                x = 0
                while x < NUM_FORCE_POWERS {
                    //clear all force
                    uiForcePowersRank[x] = 0
                    x += 1
                }
                update = true
            }
            if update {
                var myTeam: Int32
                myTeam = Int32(trap_Cvar_VariableValue("ui_myteam"))
                if myTeam != TEAM_SPECTATOR {
                    UI_UpdateClientForcePowers(UI_TeamName(myTeam))//will cause him to respawn, if it's been 5 seconds since last one
                } else {
                    UI_UpdateClientForcePowers(nil)//just update powers
                }
            }
        }
    }

    menu = Menus_FindByName("ingame_playerforce")
    // Set the cost of the saberattack according to whether its free.
    if ui_freeSaber.integer != 0 {
        // Make saber free
        bgForcePowerCost[FP_SABER_OFFENSE][FORCE_LEVEL_1] = 0
        bgForcePowerCost[FP_SABER_DEFENSE][FORCE_LEVEL_1] = 0
        // Make sure that we have one freebie in saber if applicable.
        if uiForcePowersRank[FP_SABER_OFFENSE] < 1 {
            uiForcePowersRank[FP_SABER_OFFENSE] = 1
        }
        if uiForcePowersRank[FP_SABER_DEFENSE] < 1 {
            uiForcePowersRank[FP_SABER_DEFENSE] = 1
        }
        if let menu {
            Menu_ShowItemByName(menu, "setFP_SABER_DEFENSE", true)
            Menu_ShowItemByName(menu, "setfp_saberthrow", true)
            Menu_ShowItemByName(menu, "effectentry", true)
            Menu_ShowItemByName(menu, "effectfield", true)
            Menu_ShowItemByName(menu, "nosaber", false)
        }
    } else {
        // Make saber normal cost
        bgForcePowerCost[FP_SABER_OFFENSE][FORCE_LEVEL_1] = 1
        bgForcePowerCost[FP_SABER_DEFENSE][FORCE_LEVEL_1] = 1
        // Also, check if there is no saberattack.  If there isn't, there had better not be any defense or throw!
        if uiForcePowersRank[FP_SABER_OFFENSE] < 1 {
            uiForcePowersRank[FP_SABER_DEFENSE] = 0
            uiForcePowersRank[FP_SABERTHROW] = 0
            if let menu {
                Menu_ShowItemByName(menu, "setfp_saberdefend", false)
                Menu_ShowItemByName(menu, "setfp_saberthrow", false)
                Menu_ShowItemByName(menu, "effectentry", false)
                Menu_ShowItemByName(menu, "effectfield", false)
                Menu_ShowItemByName(menu, "nosaber", true)
            }
        } else {
            if let menu {
                Menu_ShowItemByName(menu, "setfp_saberdefend", true)
                Menu_ShowItemByName(menu, "setfp_saberthrow", true)
                Menu_ShowItemByName(menu, "effectentry", true)
                Menu_ShowItemByName(menu, "effectfield", true)
                Menu_ShowItemByName(menu, "nosaber", false)
            }
        }
    }

    // Make sure that we're still legal.
    curpower = 0
    while curpower < NUM_FORCE_POWERS {
        // Make sure that our ranks are within legal limits.
        if uiForcePowersRank[curpower] < 0 {
            uiForcePowersRank[curpower] = 0
        } else if uiForcePowersRank[curpower] >= NUM_FORCE_POWER_LEVELS {
            uiForcePowersRank[curpower] = (NUM_FORCE_POWER_LEVELS - 1)
        }

        currank = FORCE_LEVEL_1
        while currank <= uiForcePowersRank[curpower] {
            // Check on this force power
            if uiForcePowersRank[curpower] > 0 {
                // Do not charge the player for the one freebie in jump, or if there is one in saber.
                if (curpower == FP_LEVITATION && currank == FORCE_LEVEL_1)
                    || (curpower == FP_SABER_OFFENSE && currank == FORCE_LEVEL_1 && ui_freeSaber.integer != 0)
                    || (curpower == FP_SABER_DEFENSE && currank == FORCE_LEVEL_1 && ui_freeSaber.integer != 0) {
                    // Do nothing (written this way for clarity)
                } else {
                    // Check if we can accrue the cost of this power.
                    if bgForcePowerCost[curpower][currank] > uiForceAvailable {
                        // We can't afford this power.  Break to the next one.
                        // Remove this power from the player's roster.
                        uiForcePowersRank[curpower] = currank - 1
                        break
                    } else {
                        // Sure we can afford it.
                        uiForceUsed += bgForcePowerCost[curpower][currank]
                        uiForceAvailable -= bgForcePowerCost[curpower][currank]
                    }
                }
            }
            currank += 1
        }
        curpower += 1
    }

}

//Mostly parts of other functions merged into one another.
//Puts the current UI stuff into a string, legalizes it, and then reads it back out.
/// Source: oracle/codemp/ui/ui_force.c:465
public func UI_ReadLegalForce() {
    var fcfString = CharBuf(512)
    var forceStringValue = CharBuf(4)
    var strPlace: Int32 = 0
    var forcePlace: Int32 = 0
    var i: Int32 = 0
    var singleBuf = CharBuf(64)
    var info = CharBuf(MAX_INFO_VALUE)
    var c: Int32 = 0
    var iBuf: Int32 = 0
    var forcePowerRank: Int32 = 0
    var currank: Int32 = 0
    var forceTeam: Int32 = 0
    var updateForceLater = false

    //First, stick them into a string.
    Com_sprintf(&fcfString, Int32((fcfString).count), "%i-%i-", uiForceRank, uiForceSide)
    strPlace = strlen(fcfString)

    while forcePlace < NUM_FORCE_POWERS {
        Com_sprintf(&forceStringValue, Int32((forceStringValue).count), "%i", uiForcePowersRank[forcePlace])
        //Just use the force digit even if multiple digits. Shouldn't be longer than 1.
        fcfString[strPlace] = forceStringValue[0]
        strPlace += 1
        forcePlace += 1
    }
    fcfString[strPlace] = Int32(ascii: "\n")
    fcfString[strPlace + 1] = 0

    info[0] = 0
    let (_, text) = trap_GetConfigString(CS_SERVERINFO, Int32((info).count))
    strcpy(&info, text)

    if atoi(Info_ValueForKey(String(info), "g_forceBasedTeams")) != 0 {
        switch Int32(trap_Cvar_VariableValue("ui_myteam")) {
        case TEAM_RED:
            forceTeam = FORCE_DARKSIDE
        case TEAM_BLUE:
            forceTeam = FORCE_LIGHTSIDE
        default:
            break
        }
    }
    //Second, legalize them.
    if !BG_LegalizedForcePowers(&fcfString, uiMaxRank, ui_freeSaber.integer != 0, forceTeam, atoi(Info_ValueForKey(String(info), "g_gametype")), 0) {
        //if they were illegal, we should refresh them.
        updateForceLater = true
    }

    //Lastly, put them back into the UI storage from the legalized string
    i = 0

    while fcfString[i] != 0 && fcfString[i] != Int32(ascii: "-") {
        singleBuf[c] = fcfString[i]
        c += 1
        i += 1
    }
    singleBuf[c] = 0
    c = 0
    i += 1

    iBuf = atoi(singleBuf)

    if iBuf > uiMaxRank || iBuf < 0 {
        //this force config uses a rank level higher than our currently restricted level.. so we can't use it
        //FIXME: Print a message indicating this to the user
        //	return;
    }

    uiForceRank = iBuf

    while fcfString[i] != 0 && fcfString[i] != Int32(ascii: "-") {
        singleBuf[c] = fcfString[i]
        c += 1
        i += 1
    }
    singleBuf[c] = 0
    c = 0
    i += 1

    uiForceSide = atoi(singleBuf)

    if uiForceSide != FORCE_LIGHTSIDE
        && uiForceSide != FORCE_DARKSIDE {
        uiForceSide = FORCE_LIGHTSIDE
        return
    }

    //clear out the existing powers
    while c < NUM_FORCE_POWERS {
        uiForcePowersRank[c] = 0
        c += 1
    }
    uiForceUsed = 0
    uiForceAvailable = forceMasteryPoints[uiForceRank]
    gTouchedForce = true

    c = 0
    while fcfString[i] != 0 && c < NUM_FORCE_POWERS {
        singleBuf[0] = fcfString[i]
        singleBuf[1] = 0
        iBuf = atoi(singleBuf)	// So, that means that Force Power "c" wants to be set to rank "iBuf".

        if iBuf < 0 {
            iBuf = 0
        }

        forcePowerRank = iBuf

        if forcePowerRank > FORCE_LEVEL_3 || forcePowerRank < 0 {
            //err..  not correct
            c += 1
            i += 1
            continue  // skip this power
        }

        if uiForcePowerDarkLight[c] != 0 && uiForcePowerDarkLight[c] != uiForceSide {
            //Apparently the user has crafted a force config that has powers that don't fit with the config's side.
            c += 1
            i += 1
            continue  // skip this power
        }

        // Accrue cost for each assigned rank for this power.
        currank = FORCE_LEVEL_1
        while currank <= forcePowerRank {
            if bgForcePowerCost[c][currank] > uiForceAvailable {
                // Break out, we can't afford any more power.
                break
            }
            // Pay for this rank of this power.
            uiForceUsed += bgForcePowerCost[c][currank]
            uiForceAvailable -= bgForcePowerCost[c][currank]

            uiForcePowersRank[c] += 1
            currank += 1
        }
        c += 1
        i += 1
    }

    if uiForcePowersRank[FP_LEVITATION] < 1 {
        uiForcePowersRank[FP_LEVITATION] = 1
    }
    if uiForcePowersRank[FP_SABER_OFFENSE] < 1 && ui_freeSaber.integer != 0 {
        uiForcePowersRank[FP_SABER_OFFENSE] = 1
    }
    if uiForcePowersRank[FP_SABER_DEFENSE] < 1 && ui_freeSaber.integer != 0 {
        uiForcePowersRank[FP_SABER_DEFENSE] = 1
    }

    UpdateForceUsed()

    if updateForceLater {
        gTouchedForce = true
        UI_UpdateClientForcePowers(nil)
    }
}

/// Source: oracle/codemp/ui/ui_force.c:631
public func UI_UpdateForcePowers() {
    // Port-note: Raven walks the static buffer of `UI_Cvar_VariableString`, and his walk reads the byte past the NUL, a stale byte.
    // The port copies the text into a zeroed buffer of that size, so the byte past the NUL is 0.
    var forcePowers = CharBuf(MAX_STRING_CHARS)
    strcpy(&forcePowers, UI_Cvar_VariableString("forcepowers"))
    var readBuf = CharBuf(256)
    var i: Int32 = 0
    var i_f: Int32 = 0
    var i_r: Int32 = 0

    uiForceSide = 0

    // Port-note: Raven's `goto validitycheck` is a `break` out of the labeled block `validitycheck` here.
    validitycheck: do {
        if forcePowers[0] != 0 {
            while forcePowers[i] != 0 {
                i_r = 0

                while forcePowers[i] != 0 && forcePowers[i] != Int32(ascii: "-") && i_r < 255 {
                    readBuf[i_r] = forcePowers[i]
                    i_r += 1
                    i += 1
                }
                readBuf[i_r] = 0
                if i_r >= 255 || forcePowers[i] == 0 || forcePowers[i] != Int32(ascii: "-") {
                    uiForceSide = 0
                    break validitycheck
                }
                uiForceRank = atoi(readBuf)
                i_r = 0

                if uiForceRank > uiMaxRank {
                    uiForceRank = uiMaxRank
                }

                i += 1

                while forcePowers[i] != 0 && forcePowers[i] != Int32(ascii: "-") && i_r < 255 {
                    readBuf[i_r] = forcePowers[i]
                    i_r += 1
                    i += 1
                }
                readBuf[i_r] = 0
                if i_r >= 255 || forcePowers[i] == 0 || forcePowers[i] != Int32(ascii: "-") {
                    uiForceSide = 0
                    break validitycheck
                }
                uiForceSide = atoi(readBuf)
                i_r = 0

                i += 1

                i_f = FP_HEAL

                while forcePowers[i] != 0 && i_f < NUM_FORCE_POWERS {
                    readBuf[0] = forcePowers[i]
                    readBuf[1] = 0
                    uiForcePowersRank[i_f] = atoi(readBuf)

                    if i_f == FP_LEVITATION
                        && uiForcePowersRank[i_f] < 1 {
                        uiForcePowersRank[i_f] = 1
                    }

                    if i_f == FP_SABER_OFFENSE
                        && uiForcePowersRank[i_f] < 1
                        && ui_freeSaber.integer != 0 {
                        uiForcePowersRank[i_f] = 1
                    }

                    if i_f == FP_SABER_DEFENSE
                        && uiForcePowersRank[i_f] < 1
                        && ui_freeSaber.integer != 0 {
                        uiForcePowersRank[i_f] = 1
                    }

                    i_f += 1
                    i += 1
                }

                if i_f < NUM_FORCE_POWERS {
                    //info for all the powers wasn't there..
                    uiForceSide = 0
                    break validitycheck
                }
                i += 1
            }
        }
    }

    if uiForceSide == 0 {
        uiForceSide = 1
        uiForceRank = 1
        i = 0
        while i < NUM_FORCE_POWERS {
            if i == FP_LEVITATION {
                uiForcePowersRank[i] = 1
            } else if i == FP_SABER_OFFENSE && ui_freeSaber.integer != 0 {
                uiForcePowersRank[i] = 1
            } else if i == FP_SABER_DEFENSE && ui_freeSaber.integer != 0 {
                uiForcePowersRank[i] = 1
            } else {
                uiForcePowersRank[i] = 0
            }

            i += 1
        }

        UI_UpdateClientForcePowers(nil)
    }

    UpdateForceUsed()
}

/// Source: oracle/codemp/ui/ui_force.c:762
public func UI_SkinColor_HandleKey(_ flags: Int32, _ special: inout Float, _ key: Int32, _ num: Int32, _ min: Int32, _ max: Int32, _ type: Int32) -> Bool {
    // Raven assigns his own `num` parameter.
    // A Swift parameter is immutable, so the body takes a mutable copy of it.
    var num = num
    if key == A_MOUSE1 || key == A_MOUSE2 || key == A_ENTER || key == A_KP_ENTER {
        var i: Int32 = num

        if key == A_MOUSE2 {
            i -= 1
        } else {
            i += 1
        }

        if i < min {
            i = max
        } else if i > max {
            i = min
        }

        num = i

        uiSkinColor = num

        uiHoldSkinColor = uiSkinColor

        UI_FeederSelection(Float(FEEDER_Q3HEADS), uiInfo.q3SelectedHead, nil)

        return true
    }
    return false
}

/// Source: oracle/codemp/ui/ui_force.c:802
public func UI_ForceSide_HandleKey(_ flags: Int32, _ special: inout Float, _ key: Int32, _ num: Int32, _ min: Int32, _ max: Int32, _ type: Int32) -> Bool {
    // Raven assigns his own `num` parameter.
    // A Swift parameter is immutable, so the body takes a mutable copy of it.
    var num = num
    var info = CharBuf(MAX_INFO_VALUE)

    info[0] = 0
    let (_, text) = trap_GetConfigString(CS_SERVERINFO, Int32((info).count))
    strcpy(&info, text)

    if atoi(Info_ValueForKey(String(info), "g_forceBasedTeams")) != 0 {
        switch Int32(trap_Cvar_VariableValue("ui_myteam")) {
        case TEAM_RED:
            return false
        case TEAM_BLUE:
            return false
        default:
            break
        }
    }

    if key == A_MOUSE1 || key == A_MOUSE2 || key == A_ENTER || key == A_KP_ENTER {
        var i: Int32 = num
        var x: Int32 = 0

        //update the feeder item selection, it might be different depending on side
        Menu_SetFeederSelection(nil, FEEDER_FORCECFG, 0, nil)

        if key == A_MOUSE2 {
            i -= 1
        } else {
            i += 1
        }

        if i < min {
            i = max
        } else if i > max {
            i = min
        }

        num = i

        uiForceSide = num

        // Resetting power ranks based on if light or dark side is chosen
        while x < NUM_FORCE_POWERS {
            if uiForcePowerDarkLight[x] != 0 && uiForceSide != uiForcePowerDarkLight[x] {
                uiForcePowersRank[x] = 0
            }
            x += 1
        }

        UpdateForceUsed()

        gTouchedForce = true
        return true
    }
    return false
}

/// Source: oracle/codemp/ui/ui_force.c:870
public func UI_JediNonJedi_HandleKey(_ flags: Int32, _ special: inout Float, _ key: Int32, _ num: Int32, _ min: Int32, _ max: Int32, _ type: Int32) -> Bool {
    // Raven assigns his own `num` parameter.
    // A Swift parameter is immutable, so the body takes a mutable copy of it.
    var num = num
    var info = CharBuf(MAX_INFO_VALUE)

    info[0] = 0
    let (_, text) = trap_GetConfigString(CS_SERVERINFO, Int32((info).count))
    strcpy(&info, text)

    if !UI_TrueJediEnabled() {
        //true jedi mode is not set
        return false
    }

    if key == A_MOUSE1 || key == A_MOUSE2 || key == A_ENTER || key == A_KP_ENTER {
        var i: Int32 = num
        var x: Int32 = 0

        if key == A_MOUSE2 {
            i -= 1
        } else {
            i += 1
        }

        if i < min {
            i = max
        } else if i > max {
            i = min
        }

        num = i

        uiJediNonJedi = num

        // Resetting power ranks based on if light or dark side is chosen
        if num == 0 {
            //not a jedi?
            let myTeam = Int32(trap_Cvar_VariableValue("ui_myteam"))
            while x < NUM_FORCE_POWERS {
                //clear all force powers
                uiForcePowersRank[x] = 0
                x += 1
            }
            if myTeam != TEAM_SPECTATOR {
                UI_UpdateClientForcePowers(UI_TeamName(myTeam))//will cause him to respawn, if it's been 5 seconds since last one
            } else {
                UI_UpdateClientForcePowers(nil)//just update powers
            }
        } else if num != 0 {
            //a jedi, set the minimums, hopefuly they know to set the rest!
            if uiForcePowersRank[FP_LEVITATION] < FORCE_LEVEL_1 {
                //force jump 1 minimum
                uiForcePowersRank[FP_LEVITATION] = FORCE_LEVEL_1
            }
            if uiForcePowersRank[FP_SABER_OFFENSE] < FORCE_LEVEL_1 {
                //saber attack 1, minimum
                uiForcePowersRank[FP_SABER_OFFENSE] = FORCE_LEVEL_1
            }
        }

        UpdateForceUsed()

        gTouchedForce = true
        return true
    }
    return false
}

/// Source: oracle/codemp/ui/ui_force.c:947
public func UI_ForceMaxRank_HandleKey(_ flags: Int32, _ special: inout Float, _ key: Int32, _ num: Int32, _ min: Int32, _ max: Int32, _ type: Int32) -> Bool {
    // Raven assigns his own `num` parameter.
    // A Swift parameter is immutable, so the body takes a mutable copy of it.
    var num = num
    if key == A_MOUSE1 || key == A_MOUSE2 || key == A_ENTER || key == A_KP_ENTER {
        var i: Int32 = num

        if key == A_MOUSE2 {
            i -= 1
        } else {
            i += 1
        }

        if i < min {
            i = max
        } else if i > max {
            i = min
        }

        num = i

        uiMaxRank = num

        trap_Cvar_Set("g_maxForceRank", va("%i", num))

        // The update force used will remove overallocated powers automatically.
        UpdateForceUsed()

        gTouchedForce = true

        return true
    }
    return false
}

// This function will either raise or lower a power by one rank.
/// Source: oracle/codemp/ui/ui_force.c:989
public func UI_ForcePowerRank_HandleKey(_ flags: Int32, _ special: inout Float, _ key: Int32, _ num: Int32, _ min: Int32, _ max: Int32, _ type: Int32) -> Bool {
    // Raven assigns his own `min` parameter.
    // A Swift parameter is immutable, so the body takes a mutable copy of it.
    var min = min
    var raising: Bool

    if key == A_MOUSE1 || key == A_MOUSE2 || key == A_ENTER || key == A_KP_ENTER || key == A_BACKSPACE {
        var forcepower: Int32
        var rank: Int32

        //this will give us the index as long as UI_FORCE_RANK is always one below the first force rank index
        forcepower = (type - UI_FORCE_RANK) - 1

        //the power is disabled on the server
        if uiForcePowersDisabled[forcepower] {
            return true
        }

        // If we are not on the same side as a power, or if we are not of any rank at all.
        if uiForcePowerDarkLight[forcepower] != 0 && uiForceSide != uiForcePowerDarkLight[forcepower] {
            return true
        } else if forcepower == FP_SABER_DEFENSE || forcepower == FP_SABERTHROW {
            // Saberdefend and saberthrow can't be bought if there is no saberattack
            if uiForcePowersRank[FP_SABER_OFFENSE] < 1 {
                return true
            }
        }

        if type == UI_FORCE_RANK_LEVITATION {
            min += 1
        }
        if type == UI_FORCE_RANK_SABERATTACK && ui_freeSaber.integer != 0 {
            min += 1
        }
        if type == UI_FORCE_RANK_SABERDEFEND && ui_freeSaber.integer != 0 {
            min += 1
        }

        if key == A_MOUSE2 || key == A_BACKSPACE {
            // Lower a point.
            if uiForcePowersRank[forcepower] <= min {
                return true
            }
            raising = false
        } else {
            // Raise a point.
            if uiForcePowersRank[forcepower] >= max {
                return true
            }
            raising = true
        }

        if raising {
            // Check if we can accrue the cost of this power.
            rank = uiForcePowersRank[forcepower] + 1
            if bgForcePowerCost[forcepower][rank] > uiForceAvailable {
                // We can't afford this power.  Abandon ship.
                return true
            } else {
                // Sure we can afford it.
                uiForceUsed += bgForcePowerCost[forcepower][rank]
                uiForceAvailable -= bgForcePowerCost[forcepower][rank]
                uiForcePowersRank[forcepower] = rank
            }
        } else {
            // Lower the point.
            rank = uiForcePowersRank[forcepower]
            uiForceUsed -= bgForcePowerCost[forcepower][rank]
            uiForceAvailable += bgForcePowerCost[forcepower][rank]
            uiForcePowersRank[forcepower] -= 1
        }

        UpdateForceUsed()

        gTouchedForce = true

        return true
    }
    return false
}

/**
```
=================
UI_ForceConfigHandle
=================
```
*/
/// Source: oracle/codemp/ui/ui_force.c:1110
public func UI_ForceConfigHandle(_ oldindex: Int32, _ newindex: Int32) {
    // Raven assigns his own `newindex` parameter.
    // A Swift parameter is immutable, so the body takes a mutable copy of it.
    var newindex = newindex
    var f: fileHandle_t = 0
    var len: Int32 = 0
    var i: Int32 = 0
    var c: Int32 = 0
    var iBuf: Int32 = 0
    var forcePowerRank: Int32
    var currank: Int32
    var fcfBuffer = CharBuf(8192)
    var singleBuf = CharBuf(64)
    var info = CharBuf(MAX_INFO_VALUE)
    var forceTeam: Int32 = 0

    if oldindex == 0 {
        //switching out from custom config, so first shove the current values into the custom storage
        i = 0

        while i < NUM_FORCE_POWERS {
            gCustPowersRank[i] = uiForcePowersRank[i]
            i += 1
        }
        gCustRank = uiForceRank
        gCustSide = uiForceSide
    }

    if newindex == 0 {
        //switching back to custom, shove the values back in from the custom storage
        i = 0
        uiForceUsed = 0
        gTouchedForce = true

        while i < NUM_FORCE_POWERS {
            uiForcePowersRank[i] = gCustPowersRank[i]
            uiForceUsed += uiForcePowersRank[i]
            i += 1
        }
        uiForceRank = gCustRank
        uiForceSide = gCustSide

        UpdateForceUsed()
        return
    }

    //If we made it here, we want to load in a new config
    if uiForceSide == FORCE_LIGHTSIDE {
        //we should only be displaying lightside configs, so.. look in the light folder
        newindex += uiInfo.forceConfigLightIndexBegin
        if newindex >= uiInfo.forceConfigCount {
            return
        }
        len = trap_FS_FOpenFile(va("forcecfg/light/%s.fcf", uiInfo.forceConfigNames[newindex]), &f, FS_READ)
    } else {
        //else dark
        newindex += uiInfo.forceConfigDarkIndexBegin
        if newindex >= uiInfo.forceConfigCount || newindex > uiInfo.forceConfigLightIndexBegin {
            //dark gets read in before light
            return
        }
        len = trap_FS_FOpenFile(va("forcecfg/dark/%s.fcf", uiInfo.forceConfigNames[newindex]), &f, FS_READ)
    }

    if len <= 0 {
        //This should not have happened. But, before we quit out, attempt searching the other light/dark folder for the file.
        if uiForceSide == FORCE_LIGHTSIDE {
            len = trap_FS_FOpenFile(va("forcecfg/dark/%s.fcf", uiInfo.forceConfigNames[newindex]), &f, FS_READ)
        } else {
            len = trap_FS_FOpenFile(va("forcecfg/light/%s.fcf", uiInfo.forceConfigNames[newindex]), &f, FS_READ)
        }

        if len <= 0 {
            //still failure? Oh well.
            return
        }
    }

    if len >= 8192 {
        return
    }

    trap_FS_Read(&fcfBuffer, len, f)
    fcfBuffer[len] = 0
    trap_FS_FCloseFile(f)

    i = 0

    info[0] = 0
    let (_, text) = trap_GetConfigString(CS_SERVERINFO, Int32((info).count))
    strcpy(&info, text)

    if atoi(Info_ValueForKey(String(info), "g_forceBasedTeams")) != 0 {
        switch Int32(trap_Cvar_VariableValue("ui_myteam")) {
        case TEAM_RED:
            forceTeam = FORCE_DARKSIDE
        case TEAM_BLUE:
            forceTeam = FORCE_LIGHTSIDE
        default:
            break
        }
    }

    BG_LegalizedForcePowers(&fcfBuffer, uiMaxRank, ui_freeSaber.integer != 0, forceTeam, atoi(Info_ValueForKey(String(info), "g_gametype")), 0)
    //legalize the config based on the max rank

    //now that we're done with the handle, it's time to parse our force data out of the string
    //we store strings in rank-side-xxxxxxxxx format (where the x's are individual force power levels)
    while fcfBuffer[i] != 0 && fcfBuffer[i] != Int32(ascii: "-") {
        singleBuf[c] = fcfBuffer[i]
        c += 1
        i += 1
    }
    singleBuf[c] = 0
    c = 0
    i += 1

    iBuf = atoi(singleBuf)

    if iBuf > uiMaxRank || iBuf < 0 {
        //this force config uses a rank level higher than our currently restricted level.. so we can't use it
        //FIXME: Print a message indicating this to the user
        return
    }

    uiForceRank = iBuf

    while fcfBuffer[i] != 0 && fcfBuffer[i] != Int32(ascii: "-") {
        singleBuf[c] = fcfBuffer[i]
        c += 1
        i += 1
    }
    singleBuf[c] = 0
    c = 0
    i += 1

    uiForceSide = atoi(singleBuf)

    if uiForceSide != FORCE_LIGHTSIDE
        && uiForceSide != FORCE_DARKSIDE {
        uiForceSide = FORCE_LIGHTSIDE
        return
    }

    //clear out the existing powers
    while c < NUM_FORCE_POWERS {
        /*
		if (c==FP_LEVITATION)
		{
			uiForcePowersRank[c]=1;
		}
		else if (c==FP_SABER_OFFENSE && ui_freeSaber.integer)
		{
			uiForcePowersRank[c]=1;
		}
		else if (c==FP_SABER_DEFENSE && ui_freeSaber.integer)
		{
			uiForcePowersRank[c]=1;
		}
		else
		{
			uiForcePowersRank[c] = 0;
		}
		*/
        //rww - don't need to do these checks. Just trust whatever the saber config says.
        uiForcePowersRank[c] = 0
        c += 1
    }
    uiForceUsed = 0
    uiForceAvailable = forceMasteryPoints[uiForceRank]
    gTouchedForce = true

    c = 0
    while fcfBuffer[i] != 0 && c < NUM_FORCE_POWERS {
        singleBuf[0] = fcfBuffer[i]
        singleBuf[1] = 0
        iBuf = atoi(singleBuf)	// So, that means that Force Power "c" wants to be set to rank "iBuf".

        if iBuf < 0 {
            iBuf = 0
        }

        forcePowerRank = iBuf

        if forcePowerRank > FORCE_LEVEL_3 || forcePowerRank < 0 {
            //err..  not correct
            c += 1
            i += 1
            continue  // skip this power
        }

        if uiForcePowerDarkLight[c] != 0 && uiForcePowerDarkLight[c] != uiForceSide {
            //Apparently the user has crafted a force config that has powers that don't fit with the config's side.
            c += 1
            i += 1
            continue  // skip this power
        }

        // Accrue cost for each assigned rank for this power.
        currank = FORCE_LEVEL_1
        while currank <= forcePowerRank {
            if bgForcePowerCost[c][currank] > uiForceAvailable {
                // Break out, we can't afford any more power.
                break
            }
            // Pay for this rank of this power.
            uiForceUsed += bgForcePowerCost[c][currank]
            uiForceAvailable -= bgForcePowerCost[c][currank]

            uiForcePowersRank[c] += 1
            currank += 1
        }
        c += 1
        i += 1
    }

    if uiForcePowersRank[FP_LEVITATION] < 1 {
        uiForcePowersRank[FP_LEVITATION] = 1
    }
    if uiForcePowersRank[FP_SABER_OFFENSE] < 1 && ui_freeSaber.integer != 0 {
        uiForcePowersRank[FP_SABER_OFFENSE] = 1
    }
    if uiForcePowersRank[FP_SABER_DEFENSE] < 1 && ui_freeSaber.integer != 0 {
        uiForcePowersRank[FP_SABER_DEFENSE] = 1
    }

    UpdateForceUsed()
}
