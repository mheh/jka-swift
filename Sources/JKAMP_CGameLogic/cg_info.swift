import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_info.c:7
let MAX_LOADING_PLAYER_ICONS = 16 as Int32

/// Source: oracle/codemp/cgame/cg_info.c:8
let MAX_LOADING_ITEM_ICONS = 26 as Int32

/// Source: oracle/codemp/cgame/cg_info.c:109
let UI_INFOFONT = (JKAShared.UI_BIGFONT)

/**
```
======================
CG_LoadingString

======================
```
*/
/// Source: oracle/codemp/cgame/cg_info.c:21
func CG_LoadingString(_ s: String) {
    Q_strncpyz(&cg.infoScreenTextBuffer, s, 1024)

    trap_UpdateScreen()
}

/**
```
===================
CG_LoadingItem
===================
```
*/
/// Source: oracle/codemp/cgame/cg_info.c:32
func CG_LoadingItem(_ itemNum: Int32) {
    var item: Gitem?
    var upperKey = CharBuf(1024)

    item = bg_itemlist[itemNum]

    if item!.classname == nil || item!.classname!.isEmpty {
        //	CG_LoadingString( "Unknown item" );
        return
    }

    strcpy(&upperKey, item!.classname!)
    Q_strupr(&upperKey)
    CG_LoadingString(CG_GetStringEdString("SP_INGAME", String(upperKey)))
}

/**
```
===================
CG_LoadingClient
===================
```
*/
/// Source: oracle/codemp/cgame/cg_info.c:53
func CG_LoadingClient(_ clientNum: Int32) {
    let info: String
    var personality = CharBuf(64)

    info = CG_ConfigString(CS_PLAYERS + clientNum)

    /*
    char			model[MAX_QPATH];
    char			iconName[MAX_QPATH];
    char			*skin;
    if ( loadingPlayerIconCount < MAX_LOADING_PLAYER_ICONS ) {
    Q_strncpyz( model, Info_ValueForKey( info, "model" ), sizeof( model ) );
    skin = Q_strrchr( model, '/' );
    if ( skin ) {
    *skin++ = '\0';
    } else {
    skin = "default";
    }

    Com_sprintf( iconName, MAX_QPATH, "models/players/%s/icon_%s.tga", model, skin );

    loadingPlayerIcons[loadingPlayerIconCount] = trap_R_RegisterShaderNoMip( iconName );
    if ( !loadingPlayerIcons[loadingPlayerIconCount] ) {
    Com_sprintf( iconName, MAX_QPATH, "models/players/characters/%s/icon_%s.tga", model, skin );
    loadingPlayerIcons[loadingPlayerIconCount] = trap_R_RegisterShaderNoMip( iconName );
    }
    if ( !loadingPlayerIcons[loadingPlayerIconCount] ) {
    Com_sprintf( iconName, MAX_QPATH, "models/players/%s/icon_%s.tga", DEFAULT_MODEL, "default" );
    loadingPlayerIcons[loadingPlayerIconCount] = trap_R_RegisterShaderNoMip( iconName );
    }
    if ( loadingPlayerIcons[loadingPlayerIconCount] ) {
    loadingPlayerIconCount++;
    }
    }
    */
    Q_strncpyz(&personality, Info_ValueForKey(info, "n"), Int32((personality).count))
    Q_CleanStr(&personality)

    /*
    if( cgs.gametype == GT_SINGLE_PLAYER ) {
    trap_S_RegisterSound( va( "sound/player/announce/%s.wav", personality ));
    }
    */

    CG_LoadingString(String(personality))
}

/// Source: oracle/codemp/cgame/cg_info.c:110
func CG_DrawInformation() {
    var s: String
    let info: String
    let sysInfo: String
    var y: Int32
    var value: Int32
    let valueNOFP: Int32
    var levelshot: qhandle_t
    var buf = CharBuf(1024)
    let iPropHeight: Int32 = 18

    info = CG_ConfigString(CS_SERVERINFO)
    sysInfo = CG_ConfigString(CS_SYSTEMINFO)

    s = Info_ValueForKey(info, "mapname")
    levelshot = trap_R_RegisterShaderNoMip(va("levelshots/%s", s))
    if levelshot == 0 {
        levelshot = trap_R_RegisterShaderNoMip("menu/art/unknownmap_mp")
    }
    trap_R_SetColor(nil)
    CG_DrawPic(0, 0, Float(SCREEN_WIDTH), Float(SCREEN_HEIGHT), levelshot)

    CG_LoadBar()

    // draw the icons of things as they are loaded
    //	CG_DrawLoadingIcons();

    // the first 150 rows are reserved for the client connection
    // screen to write into
    if !cg.infoScreenText.isEmpty {
        let psLoading: String = CG_GetStringEdString("MENUS", "LOADING_MAPNAME")
        UI_DrawProportionalString(320, 128 - 32, va(psLoading, cg.infoScreenText), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
    } else {
        let psAwaitingSnapshot: String = CG_GetStringEdString("MENUS", "AWAITING_SNAPSHOT")
        UI_DrawProportionalString(320, 128 - 32, psAwaitingSnapshot, UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
    }

    // draw info string information

    y = 180 - 32

    // don't print server lines if playing a local game
    strcpy(&buf, trap_Cvar_VariableStringBuffer("sv_running", Int32((buf).count)))
    if atoi(buf) == 0 {
        // server hostname
        Q_strncpyz(&buf, Info_ValueForKey(info, "sv_hostname"), 1024)
        Q_CleanStr(&buf)
        UI_DrawProportionalString(320, y, String(buf), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

        // pure server
        s = Info_ValueForKey(sysInfo, "sv_pure")
        if CharBuf(s)[0] == Int32(ascii: "1") {
            let psPure: String = CG_GetStringEdString("MP_INGAME", "PURE_SERVER")
            UI_DrawProportionalString(320, y, psPure, UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        }

        // server-specific message of the day
        s = CG_ConfigString(CS_MOTD)
        if !s.isEmpty {
            UI_DrawProportionalString(320, y, s, UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        }

        do {
            // display global MOTD at bottom (mirrors ui_main UI_DrawConnectScreen
            var motdString = CharBuf(1024)
            strcpy(&motdString, trap_Cvar_VariableStringBuffer("cl_motdString", Int32((motdString).count)))

            if motdString[0] != 0 {
                UI_DrawProportionalString(320, 425, String(motdString), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            }
        }

        // some extra space after hostname and motd
        y += 10
    }

    // map-specific message (long map name)
    s = CG_ConfigString(CS_MESSAGE)
    if !s.isEmpty {
        UI_DrawProportionalString(320, y, s, UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
    }

    // cheats warning
    s = Info_ValueForKey(sysInfo, "sv_cheats")
    if CharBuf(s)[0] == Int32(ascii: "1") {
        UI_DrawProportionalString(320, y, CG_GetStringEdString("MP_INGAME", "CHEATSAREENABLED"), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
    }

    // game type
    switch cgs.gametype {
    case GT_FFA:
        s = CG_GetStringEdString("MENUS", "FREE_FOR_ALL") //"Free For All";

    case GT_HOLOCRON:
        s = CG_GetStringEdString("MENUS", "HOLOCRON_FFA") //"Holocron FFA";

    case GT_JEDIMASTER:
        s = CG_GetStringEdString("MENUS", "SAGA") //"Jedi Master";??

    case GT_SINGLE_PLAYER:
        s = CG_GetStringEdString("MENUS", "SAGA") //"Team FFA";

    case GT_DUEL:
        s = CG_GetStringEdString("MENUS", "DUEL") //"Team FFA";

    case GT_POWERDUEL:
        s = CG_GetStringEdString("MENUS", "POWERDUEL") //"Team FFA";

    case GT_TEAM:
        s = CG_GetStringEdString("MENUS", "TEAM_FFA") //"Team FFA";

    case GT_SIEGE:
        s = CG_GetStringEdString("MENUS", "SIEGE") //"Siege";

    case GT_CTF:
        s = CG_GetStringEdString("MENUS", "CAPTURE_THE_FLAG") //"Capture the Flag";

    case GT_CTY:
        s = CG_GetStringEdString("MENUS", "CAPTURE_THE_YSALIMARI") //"Capture the Ysalamiri";

    default:
        s = CG_GetStringEdString("MENUS", "SAGA") //"Team FFA";
    }
    UI_DrawProportionalString(320, y, s, UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
    y += iPropHeight

    if cgs.gametype != GT_SIEGE {
        value = atoi(Info_ValueForKey(info, "timelimit"))
        if value != 0 {
            UI_DrawProportionalString(320, y, va("%s %i", CG_GetStringEdString("MP_INGAME", "TIMELIMIT"), value), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        }

        if cgs.gametype < GT_CTF {
            value = atoi(Info_ValueForKey(info, "fraglimit"))
            if value != 0 {
                UI_DrawProportionalString(320, y, va("%s %i", CG_GetStringEdString("MP_INGAME", "FRAGLIMIT"), value), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
                y += iPropHeight
            }

            if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
                value = atoi(Info_ValueForKey(info, "duel_fraglimit"))
                if value != 0 {
                    UI_DrawProportionalString(320, y, va("%s %i", CG_GetStringEdString("MP_INGAME", "WINLIMIT"), value), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
                    y += iPropHeight
                }
            }
        }
    }

    if cgs.gametype >= GT_CTF {
        value = atoi(Info_ValueForKey(info, "capturelimit"))
        if value != 0 {
            UI_DrawProportionalString(320, y, va("%s %i", CG_GetStringEdString("MP_INGAME", "CAPTURELIMIT"), value), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        }
    }

    if cgs.gametype >= GT_TEAM {
        value = atoi(Info_ValueForKey(info, "g_forceBasedTeams"))
        if value != 0 {
            UI_DrawProportionalString(320, y, CG_GetStringEdString("MP_INGAME", "FORCEBASEDTEAMS"), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        }
    }

    if cgs.gametype != GT_SIEGE {
        valueNOFP = atoi(Info_ValueForKey(info, "g_forcePowerDisable"))

        value = atoi(Info_ValueForKey(info, "g_maxForceRank"))
        if value != 0 && valueNOFP == 0 && (value < NUM_FORCE_MASTERY_LEVELS) {
            var fmStr = CharBuf(1024)

            strcpy(&fmStr, trap_SP_GetStringTextString("MP_INGAME_MAXFORCERANK", Int32((fmStr).count)).1)

            UI_DrawProportionalString(320, y, va("%s %s", fmStr, CG_GetStringEdString("MP_INGAME", forceMasteryLevels[value])), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        } else if valueNOFP == 0 {
            var fmStr = CharBuf(1024)
            strcpy(&fmStr, trap_SP_GetStringTextString("MP_INGAME_MAXFORCERANK", Int32((fmStr).count)).1)

            UI_DrawProportionalString(320, y, va("%s %s", fmStr, CG_GetStringEdString("MP_INGAME", forceMasteryLevels[7])), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        }

        if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
            value = atoi(Info_ValueForKey(info, "g_duelWeaponDisable"))
        } else {
            value = atoi(Info_ValueForKey(info, "g_weaponDisable"))
        }
        if cgs.gametype != GT_JEDIMASTER && value != 0 {
            UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "SABERONLYSET")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        }

        if valueNOFP != 0 {
            UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "NOFPSET")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
            y += iPropHeight
        }
    }

    // Display the rules based on type
    y += iPropHeight
    switch cgs.gametype {
    case GT_FFA:
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_FFA_1")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

    case GT_HOLOCRON:
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_HOLO_1")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_HOLO_2")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

    case GT_JEDIMASTER:
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_JEDI_1")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_JEDI_2")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

    case GT_SINGLE_PLAYER:
        break

    case GT_DUEL:
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_DUEL_1")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_DUEL_2")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

    case GT_POWERDUEL:
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_POWERDUEL_1")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_POWERDUEL_2")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

    case GT_TEAM:
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_TEAM_1")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_TEAM_2")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

    case GT_SIEGE:
        break

    case GT_CTF:
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_CTF_1")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_CTF_2")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

    case GT_CTY:
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_CTY_1")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight
        UI_DrawProportionalString(320, y, va("%s", CG_GetStringEdString("MP_INGAME", "RULES_CTY_2")), UI_CENTER | UI_INFOFONT | UI_DROPSHADOW, colorWhite)
        y += iPropHeight

    default:
        break
    }
}

/**
```
===================
CG_LoadBar
===================
```
*/
/// Source: oracle/codemp/cgame/cg_info.c:439
func CG_LoadBar() {
    let numticks: Int32 = 9
    let tickwidth: Int32 = 40
    let tickheight: Int32 = 8
    let tickpadx: Int32 = 20
    let tickpady: Int32 = 12
    let capwidth: Int32 = 8
    let barwidth: Int32 = numticks * tickwidth + tickpadx * 2 + capwidth * 2
    let barleft: Int32 = ((640 - barwidth) / 2)
    let barheight: Int32 = tickheight + tickpady * 2
    let bartop: Int32 = 480 - barheight
    let capleft: Int32 = barleft + tickpadx
    let tickleft: Int32 = capleft + capwidth
    let ticktop: Int32 = bartop + tickpady

    trap_R_SetColor(colorWhite)
    // Draw background
    CG_DrawPic(Float(barleft), Float(bartop), Float(barwidth), Float(barheight), cgs.media.loadBarLEDSurround)

    // Draw left cap (backwards)
    CG_DrawPic(Float(tickleft), Float(ticktop), Float(-capwidth), Float(tickheight), cgs.media.loadBarLEDCap)

    // Draw bar
    CG_DrawPic(Float(tickleft), Float(ticktop), Float(tickwidth * cg.loadLCARSStage), Float(tickheight), cgs.media.loadBarLED)

    // Draw right cap
    CG_DrawPic(Float(tickleft + tickwidth * cg.loadLCARSStage), Float(ticktop), Float(capwidth), Float(tickheight), cgs.media.loadBarLEDCap)
}
