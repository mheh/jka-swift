import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_newDraw.c:324
let PIC_WIDTH = 12 as Int32

/// Source: oracle/codemp/cgame/cg_newDraw.c:7
func CG_GetSelectedPlayer() -> Int32 {
    if cg_currentSelectedPlayer.integer < 0 || cg_currentSelectedPlayer.integer >= numSortedTeamPlayers {
        cg_currentSelectedPlayer.integer = 0
    }
    return cg_currentSelectedPlayer.integer
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:14
func CG_StatusHandle(_ task: Int32) -> JKAShared.qhandle_t {
    var h: qhandle_t = cgs.media.assaultShader
    switch task {
    case TEAMTASK_OFFENSE:
        h = cgs.media.assaultShader

    case TEAMTASK_DEFENSE:
        h = cgs.media.defendShader

    case TEAMTASK_PATROL:
        h = cgs.media.patrolShader

    case TEAMTASK_FOLLOW:
        h = cgs.media.followShader

    case TEAMTASK_CAMP:
        h = cgs.media.campShader

    case TEAMTASK_RETRIEVE:
        h = cgs.media.retrieveShader

    case TEAMTASK_ESCORT:
        h = cgs.media.escortShader

    default:
        h = cgs.media.assaultShader
    }
    return h
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:46
func CG_GetValue(_ ownerDraw: Int32) -> Float {
    var cent: Centity?
    var ci: ClientInfo?
    var ps: PlayerState?

    cent = cg_entities[cg.snap!.ps.clientNum]
    ps = cg.snap!.ps

    switch ownerDraw {
    case CG_SELECTEDPLAYER_ARMOR:
        ci = cgs.clientinfo[sortedTeamPlayers[CG_GetSelectedPlayer()]]
        return Float(ci!.armor)

    case CG_SELECTEDPLAYER_HEALTH:
        ci = cgs.clientinfo[sortedTeamPlayers[CG_GetSelectedPlayer()]]
        return Float(ci!.health)

    case CG_PLAYER_ARMOR_VALUE:
        return Float(ps!.stats[STAT_ARMOR])

    case CG_PLAYER_AMMO_VALUE:
        if cent!.currentState.weapon != 0 {
            return Float(ps!.ammo[weaponData[cent!.currentState.weapon].ammoIndex])
        }

    case CG_PLAYER_SCORE:
        return Float(cg.snap!.ps.persistant[PERS_SCORE])

    case CG_PLAYER_HEALTH:
        return Float(ps!.stats[STAT_HEALTH])

    case CG_RED_SCORE:
        return Float(cgs.scores1)

    case CG_BLUE_SCORE:
        return Float(cgs.scores2)

    case CG_PLAYER_FORCE_VALUE:
        return Float(ps!.fd.forcePower)

    default:
        break
    }
    return -1
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:93
func CG_OtherTeamHasFlag() -> Bool {
    if cgs.gametype == GT_CTF || cgs.gametype == GT_CTY {
        let team: Int32 = cg.snap!.ps.persistant[PERS_TEAM]
        if team == TEAM_RED && cgs.redflag == FLAG_TAKEN {
            return true
        } else if team == TEAM_BLUE && cgs.blueflag == FLAG_TAKEN {
            return true
        } else {
            return false
        }
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:107
func CG_YourTeamHasFlag() -> Bool {
    if cgs.gametype == GT_CTF || cgs.gametype == GT_CTY {
        let team: Int32 = cg.snap!.ps.persistant[PERS_TEAM]
        if team == TEAM_RED && cgs.blueflag == FLAG_TAKEN {
            return true
        } else if team == TEAM_BLUE && cgs.redflag == FLAG_TAKEN {
            return true
        } else {
            return false
        }
    }
    return false
}

// THINKABOUTME: should these be exclusive or inclusive..
//
/// Source: oracle/codemp/cgame/cg_newDraw.c:123
func CG_OwnerDrawVisible(_ flags: Int32) -> Bool {
    if (flags & CG_SHOW_TEAMINFO) != 0 {
        return (cg_currentSelectedPlayer.integer == numSortedTeamPlayers)
    }

    if (flags & CG_SHOW_NOTEAMINFO) != 0 {
        return !(cg_currentSelectedPlayer.integer == numSortedTeamPlayers)
    }

    if (flags & CG_SHOW_OTHERTEAMHASFLAG) != 0 {
        return CG_OtherTeamHasFlag()
    }

    if (flags & CG_SHOW_YOURTEAMHASENEMYFLAG) != 0 {
        return CG_YourTeamHasFlag()
    }

    if (flags & (CG_SHOW_BLUE_TEAM_HAS_REDFLAG | CG_SHOW_RED_TEAM_HAS_BLUEFLAG)) != 0 {
        if (flags & CG_SHOW_BLUE_TEAM_HAS_REDFLAG) != 0 && (cgs.redflag == FLAG_TAKEN || cgs.flagStatus == FLAG_TAKEN_RED) {
            return true
        } else if (flags & CG_SHOW_RED_TEAM_HAS_BLUEFLAG) != 0 && (cgs.blueflag == FLAG_TAKEN || cgs.flagStatus == FLAG_TAKEN_BLUE) {
            return true
        }
        return false
    }

    if (flags & CG_SHOW_ANYTEAMGAME) != 0 {
        if cgs.gametype >= GT_TEAM {
            return true
        }
    }

    if (flags & CG_SHOW_ANYNONTEAMGAME) != 0 {
        if cgs.gametype < GT_TEAM {
            return true
        }
    }

    if (flags & CG_SHOW_CTF) != 0 {
        if cgs.gametype == GT_CTF || cgs.gametype == GT_CTY {
            return true
        }
    }

    if (flags & CG_SHOW_HEALTHCRITICAL) != 0 {
        if cg.snap!.ps.stats[STAT_HEALTH] < 25 {
            return true
        }
    }

    if (flags & CG_SHOW_HEALTHOK) != 0 {
        if cg.snap!.ps.stats[STAT_HEALTH] >= 25 {
            return true
        }
    }

    if (flags & CG_SHOW_SINGLEPLAYER) != 0 {
        if cgs.gametype == GT_SINGLE_PLAYER {
            return true
        }
    }

    if (flags & CG_SHOW_TOURNAMENT) != 0 {
        if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
            return true
        }
    }

    if (flags & CG_SHOW_DURINGINCOMINGVOICE) != 0 {
    }

    if (flags & CG_SHOW_IF_PLAYER_HAS_FLAG) != 0 {
        if cg.snap!.ps.powerups[PW_REDFLAG] != 0 || cg.snap!.ps.powerups[PW_BLUEFLAG] != 0 || cg.snap!.ps.powerups[PW_NEUTRALFLAG] != 0 {
            return true
        }
    }
    return false
}

/// Raven's `static const char *s` of `CG_GetKillerText`, which the world keeps.
/// Source: oracle/codemp/cgame/cg_newDraw.c:205
var s_CG_GetKillerText: String {
    get { world.s_CG_GetKillerText }
    set { world.s_CG_GetKillerText = newValue }
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:204
func CG_GetKillerText() -> String {
    // Raven's static local `s` is the world's `s_CG_GetKillerText`.
    // AI: Raven's `s` points into the va ring, which a later va call writes over. The world keeps a copy of the text.
    if !cg.killerName.isEmpty {
        s_CG_GetKillerText = va("%s %s", CG_GetStringEdString("MP_INGAME", "KILLEDBY"), cg.killerName)
    }
    return s_CG_GetKillerText
}

/// Raven's `static const char *s` of `CG_GetGameStatusText`, which the world keeps.
/// Source: oracle/codemp/cgame/cg_newDraw.c:214
var s_CG_GetGameStatusText: String {
    get { world.s_CG_GetGameStatusText }
    set { world.s_CG_GetGameStatusText = newValue }
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:213
func CG_GetGameStatusText() -> String {
    // Raven's static local `s` is the world's `s_CG_GetGameStatusText`.
    // AI: Raven's `s` points into the va ring, which a later va call writes over. The world keeps a copy of the text.
    if cgs.gametype == GT_POWERDUEL {
        s_CG_GetGameStatusText = ""
    } else if cgs.gametype < GT_TEAM {
        if cg.snap!.ps.persistant[PERS_TEAM] != TEAM_SPECTATOR {
            var sPlaceWith = CharBuf(256)
            strcpy(&sPlaceWith, trap_SP_GetStringTextString("MP_INGAME_PLACE_WITH", Int32((sPlaceWith).count)).1)

            s_CG_GetGameStatusText = va("%s %s %i", CG_PlaceString(cg.snap!.ps.persistant[PERS_RANK] + 1), sPlaceWith, cg.snap!.ps.persistant[PERS_SCORE])
        }
    } else {
        if cg.teamScores[0] == cg.teamScores[1] {
            s_CG_GetGameStatusText = va("%s %i", CG_GetStringEdString("MP_INGAME", "TIEDAT"), cg.teamScores[0])
        } else if cg.teamScores[0] >= cg.teamScores[1] {
            s_CG_GetGameStatusText = va("%s, %i / %i", CG_GetStringEdString("MP_INGAME", "RED_LEADS"), cg.teamScores[0], cg.teamScores[1])
        } else {
            s_CG_GetGameStatusText = va("%s, %i / %i", CG_GetStringEdString("MP_INGAME", "BLUE_LEADS"), cg.teamScores[1], cg.teamScores[0])
        }
    }
    return s_CG_GetGameStatusText
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:242
func CG_GameTypeString() -> String {
    if cgs.gametype == GT_FFA {
        return "Free For All"
    } else if cgs.gametype == GT_HOLOCRON {
        return "Holocron FFA"
    } else if cgs.gametype == GT_JEDIMASTER {
        return "Jedi Master"
    } else if cgs.gametype == GT_TEAM {
        return "Team FFA"
    } else if cgs.gametype == GT_SIEGE {
        return "Siege"
    } else if cgs.gametype == GT_CTF {
        return "Capture the Flag"
    } else if cgs.gametype == GT_CTY {
        return "Capture the Ysalamiri"
    }
    return ""
}

// maxX param is initially an X limit, but is also used as feedback. 0 = text was clipped to fit within, else maxX = next pos
//
/// Source: oracle/codemp/cgame/cg_newDraw.c:267
private func CG_Text_Paint_Limit(_ maxX: inout Float, _ x: Float, _ y: Float, _ scale: Float, _ color: JKAShared.vec4_t, _ text: String, _ adjust: Float, _ limit: Int32, _ iMenuFont: Int32) {
    var bIsTrailingPunctuation: Bool = false

    // this is kinda dirty, but...
    //
    let iFontIndex: Int32 = MenuFontToHandle(iMenuFont)

    //float fMax = *maxX;
    let iPixelLen: Int32 = trap_R_Font_StrLenPixels(text, iFontIndex, scale)
    if x + iPixelLen > maxX {
        // whole text won't fit, so we need to print just the amount that does...
        //  Ok, this is slow and tacky, but only called occasionally, and it works...
        //
        var sTemp = CharBuf(4096)
        var psText = TextCursor(CharBuf(text))
        var psOut: Int32 = 0
        var psOutLastGood: Int32 = psOut
        var uiLetter: UInt32

        while psText.byte != 0 && (x + trap_R_Font_StrLenPixels(String(sTemp), iFontIndex, scale) <= maxX) && psOut < sTemp.count - 1 { // sanity
            var iAdvanceCount: Int32 = 0
            psOutLastGood = psOut

            uiLetter = trap_AnyLanguage_ReadCharFromString(psText.text, &iAdvanceCount, &bIsTrailingPunctuation)
            psText.advance(by: iAdvanceCount)

            if uiLetter > 255 {
                sTemp[psOut] = uiLetter >> 8
                psOut += 1
                sTemp[psOut] = uiLetter & 0xFF
                psOut += 1
            } else {
                sTemp[psOut] = uiLetter & 0xFF
                psOut += 1
            }
        }
        sTemp[psOutLastGood] = 0

        maxX = 0 // feedback
        CG_Text_Paint(x, y, scale, color, String(sTemp), adjust, limit, ITEM_TEXTSTYLE_NORMAL, iMenuFont)
    } else {
        // whole text fits fine, so print it all...
        //
        maxX = x + iPixelLen // feedback the next position, as the caller expects
        CG_Text_Paint(x, y, scale, color, text, adjust, limit, ITEM_TEXTSTYLE_NORMAL, iMenuFont)
    }
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:327
func CG_DrawNewTeamInfo(_ rect: JKAMP.RectDef, _ text_x: Float, _ text_y: Float, _ scale: Float, _ color: JKAShared.vec4_t, _ shader: JKAShared.qhandle_t) {
    var xx: Int32
    var y: Float
    var i: Int32
    var j: Int32
    var len: Int32
    let count: Int32
    var p: String
    var hcolor = vec4_t()
    var pwidth: Float
    var lwidth: Float
    var maxx: Float = 0
    var leftOver: Float
    var ci: ClientInfo?
    var item: Gitem?
    var h: qhandle_t

    // max player name width
    pwidth = 0
    count = (numSortedTeamPlayers > 8) ? 8 : numSortedTeamPlayers
    i = 0
    while i < count {
        ci = cgs.clientinfo[sortedTeamPlayers[i]]
        if ci!.infoValid && ci!.team == cg.snap!.ps.persistant[PERS_TEAM] {
            len = CG_Text_Width(ci!.name, scale, 0)
            if len > pwidth {
                pwidth = Float(len)
            }
        }
        i += 1
    }

    // max location name width
    lwidth = 0
    i = 1
    while i < MAX_LOCATIONS {
        p = CG_GetLocationString(CG_ConfigString(CS_LOCATIONS + i))
        // Raven tests `p` and `*p`.
        // Both read as the same Swift test, so the draft writes it once.
        if !p.isEmpty {
            len = CG_Text_Width(p, scale, 0)
            if len > lwidth {
                lwidth = Float(len)
            }
        }
        i += 1
    }

    y = rect.y

    i = 0
    while i < count {
        ci = cgs.clientinfo[sortedTeamPlayers[i]]
        if ci!.infoValid && ci!.team == cg.snap!.ps.persistant[PERS_TEAM] {
            xx = Int32(rect.x + 1)
            j = 0
            while j <= PW_NUM_POWERUPS {
                if (ci!.powerups & (1 << j)) != 0 {
                    item = BG_FindItemForPowerup(j)

                    if item != nil {
                        CG_DrawPic(Float(xx), y, Float(PIC_WIDTH), Float(PIC_WIDTH), trap_R_RegisterShader(item!.icon!))
                        xx += PIC_WIDTH
                    }
                }
                j += 1
            }

            // FIXME: max of 3 powerups shown properly
            xx = Int32(rect.x + (PIC_WIDTH * 3) + 2)

            CG_GetColorForHealth(ci!.health, ci!.armor, &hcolor)
            trap_R_SetColor(hcolor)
            CG_DrawPic(Float(xx), y + 1, Float(PIC_WIDTH - 2), Float(PIC_WIDTH - 2), cgs.media.heartShader)

            //Com_sprintf (st, sizeof(st), "%3i %3i", ci->health,	ci->armor);
            //CG_Text_Paint(xx, y + text_y, scale, hcolor, st, 0, 0);

            // draw weapon icon
            xx += PIC_WIDTH + 1

            // weapon used is not that useful, use the space for task

            trap_R_SetColor(nil)
            h = CG_StatusHandle(ci!.teamTask)

            if h != 0 {
                CG_DrawPic(Float(xx), y, Float(PIC_WIDTH), Float(PIC_WIDTH), h)
            }

            xx += PIC_WIDTH + 1

            leftOver = rect.w - xx
            maxx = xx + leftOver / 3



            CG_Text_Paint_Limit(&maxx, Float(xx), y + text_y, scale, color, ci!.name, 0, 0, FONT_MEDIUM)

            p = CG_GetLocationString(CG_ConfigString(CS_LOCATIONS + ci!.location))
            // Raven tests `!p` and `!*p`.
            // Both read as the same Swift test, so the draft writes it once.
            if p.isEmpty {
                p = "unknown"
            }

            xx = Int32(Float(xx) + (leftOver / 3 + 2))
            maxx = rect.w - 4

            CG_Text_Paint_Limit(&maxx, Float(xx), y + text_y, scale, color, p, 0, 0, FONT_MEDIUM)
            y += text_y + 2
            if y + text_y + 2 > rect.y + rect.h {
                break
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:437
func CG_DrawTeamSpectators(_ rect: JKAMP.RectDef, _ scale: Float, _ color: JKAShared.vec4_t, _ shader: JKAShared.qhandle_t) {
    if cg.spectatorLen != 0 {
        var maxX: Float = 0

        if cg.spectatorWidth == -1 {
            cg.spectatorWidth = 0
            cg.spectatorPaintX = Int32(rect.x + 1)
            cg.spectatorPaintX2 = -1
        }

        if cg.spectatorOffset > cg.spectatorLen {
            cg.spectatorOffset = 0
            cg.spectatorPaintX = Int32(rect.x + 1)
            cg.spectatorPaintX2 = -1
        }

        if cg.time > cg.spectatorTime {
            cg.spectatorTime = cg.time + 10
            if cg.spectatorPaintX <= rect.x + 2 {
                if cg.spectatorOffset < cg.spectatorLen {
                    cg.spectatorPaintX += CG_Text_Width(String(cg.spectatorListBuffer[cg.spectatorOffset...]), scale, 1) - 1
                    cg.spectatorOffset += 1
                } else {
                    cg.spectatorOffset = 0
                    if cg.spectatorPaintX2 >= 0 {
                        cg.spectatorPaintX = cg.spectatorPaintX2
                    } else {
                        cg.spectatorPaintX = Int32(rect.x + rect.w - 2)
                    }
                    cg.spectatorPaintX2 = -1
                }
            } else {
                cg.spectatorPaintX -= 1
                if cg.spectatorPaintX2 >= 0 {
                    cg.spectatorPaintX2 -= 1
                }
            }
        }

        maxX = rect.x + rect.w - 2
        CG_Text_Paint_Limit(&maxX, Float(cg.spectatorPaintX), rect.y + rect.h - 3, scale, color, String(cg.spectatorListBuffer[cg.spectatorOffset...]), 0, 0, FONT_MEDIUM)
        if cg.spectatorPaintX2 >= 0 {
            var maxX2: Float = rect.x + rect.w - 2
            CG_Text_Paint_Limit(&maxX2, Float(cg.spectatorPaintX2), rect.y + rect.h - 3, scale, color, cg.spectatorList, 0, cg.spectatorOffset, FONT_MEDIUM)
        }
        if cg.spectatorOffset != 0 && maxX > 0 {
            // if we have an offset ( we are skipping the first part of the string ) and we fit the string
            if cg.spectatorPaintX2 == -1 {
                cg.spectatorPaintX2 = Int32(rect.x + rect.w - 2)
            }
        } else {
            cg.spectatorPaintX2 = -1
        }
    }
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:496
func CG_DrawMedal(_ ownerDraw: Int32, _ rect: JKAMP.RectDef, _ scale: Float, _ color: inout JKAShared.vec4_t, _ shader: JKAShared.qhandle_t) {
    let score: Score? = cg.scores[cg.selectedScore]
    var value: Float = 0
    var text: String? = nil
    color[3] = 0.25

    switch ownerDraw {
    case CG_ACCURACY:
        value = Float(score!.accuracy)

    case CG_ASSISTS:
        value = Float(score!.assistCount)

    case CG_DEFEND:
        value = Float(score!.defendCount)

    case CG_EXCELLENT:
        value = Float(score!.excellentCount)

    case CG_IMPRESSIVE:
        value = Float(score!.impressiveCount)

    case CG_PERFECT:
        value = (score!.perfect ? 1 : 0)

    case CG_GAUNTLET:
        value = Float(score!.guantletCount)

    case CG_CAPTURES:
        value = Float(score!.captures)

    default:
        break
    }

    if value > 0 {
        if ownerDraw != CG_PERFECT {
            if ownerDraw == CG_ACCURACY {
                text = va("%i%%", Int32(value))
                if value > 50 {
                    color[3] = 1.0
                }
            } else {
                text = va("%i", Int32(value))
                color[3] = 1.0
            }
        } else {
            if value != 0 {
                color[3] = 1.0
            }
            text = "Wow"
        }
    }

    trap_R_SetColor(color)
    CG_DrawPic(rect.x, rect.y, rect.w, rect.h, shader)

    if text != nil {
        color[3] = 1.0
        value = Float(CG_Text_Width(text!, scale, 0))
        CG_Text_Paint(rect.x + (rect.w - value) / 2, rect.y + rect.h + 10, scale, color, text!, 0, 0, 0, FONT_MEDIUM)
    }
    trap_R_SetColor(nil)
}

//
/// Source: oracle/codemp/cgame/cg_newDraw.c:562
func CG_OwnerDraw(_ x: Float, _ y: Float, _ w: Float, _ h: Float, _ text_x: Float, _ text_y: Float, _ ownerDraw: Int32, _ ownerDrawFlags: Int32, _ align: Int32, _ special: Float, _ scale: Float, _ color: JKAShared.vec4_t, _ shader: JKAShared.qhandle_t, _ textStyle: Int32, _ font: Int32) {
    //Ignore all this, at least for now. May put some stat stuff back in menu files later.


    //if (ownerDrawFlags != 0 && !CG_OwnerDrawVisible(ownerDrawFlags)) {
    //	return;
    //}
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:747
func CG_MouseEvent(_ x: Int32, _ y: Int32) {
    let n: Int32

    if (cg.predictedPlayerState.pm_type == PM_NORMAL || cg.predictedPlayerState.pm_type == PM_JETPACK || cg.predictedPlayerState.pm_type == PM_FLOAT || cg.predictedPlayerState.pm_type == PM_SPECTATOR) && cg.showScores == false {
        trap_Key_SetCatcher(0)
        return
    }

    cgs.cursorX += x
    if cgs.cursorX < 0 {
        cgs.cursorX = 0
    } else if cgs.cursorX > 640 {
        cgs.cursorX = 640
    }

    cgs.cursorY += y
    if cgs.cursorY < 0 {
        cgs.cursorY = 0
    } else if cgs.cursorY > 480 {
        cgs.cursorY = 480
    }

    n = Display_CursorType(cgs.cursorX, cgs.cursorY)
    cgs.activeCursor = 0
    if n == CURSOR_ARROW {
        cgs.activeCursor = cgs.media.selectCursor
    } else if n == CURSOR_SIZER {
        cgs.activeCursor = cgs.media.sizeCursor
    }

    if cgs.capturedItem != nil {
        Display_MouseMove(cgs.capturedItem, x, y)
    } else {
        Display_MouseMove(nil, cgs.cursorX, cgs.cursorY)
    }
}

/**
```
==================
CG_HideTeamMenus
==================
```
*/
/// Source: oracle/codemp/cgame/cg_newDraw.c:789
func CG_HideTeamMenu() {
    Menus_CloseByName("teamMenu")
    Menus_CloseByName("getMenu")
}

/**
```
==================
CG_ShowTeamMenus
==================
```
*/
/// Source: oracle/codemp/cgame/cg_newDraw.c:800
func CG_ShowTeamMenu() {
    Menus_OpenByName("teamMenu")
}

/**
```
==================
CG_EventHandling
==================
 type 0 - no event handling
      1 - team menu
      2 - hud editor
```
*/
/// Source: oracle/codemp/cgame/cg_newDraw.c:816
func CG_EventHandling(_ type: Int32) {
    cgs.eventHandling = type != 0
    if type == CGAME_EVENT_NONE {
        CG_HideTeamMenu()
    } else if type == CGAME_EVENT_TEAMMENU {
        //CG_ShowTeamMenu();
    } else if type == CGAME_EVENT_SCOREBOARD {
    }
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:829
func CG_KeyEvent(_ key: Int32, _ down: Bool) {
    if !down {
        return
    }

    if cg.predictedPlayerState.pm_type == PM_NORMAL || cg.predictedPlayerState.pm_type == PM_JETPACK || cg.predictedPlayerState.pm_type == PM_NORMAL || (cg.predictedPlayerState.pm_type == PM_SPECTATOR && cg.showScores == false) {
        CG_EventHandling(CGAME_EVENT_NONE)
        trap_Key_SetCatcher(0)
        return
    }

    //if (key == trap_Key_GetKey("teamMenu") || !Display_CaptureItem(cgs.cursorX, cgs.cursorY)) {
    // if we see this then we should always be visible
    //  CG_EventHandling(CGAME_EVENT_NONE);
    //  trap_Key_SetCatcher(0);
    //}



    Display_HandleKey(key, down, cgs.cursorX, cgs.cursorY)

    if cgs.capturedItem != nil {
        cgs.capturedItem = nil
    } else {
        if key == A_MOUSE2 && down {
            cgs.capturedItem = Display_CaptureItem(cgs.cursorX, cgs.cursorY)
        }
    }
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:860
func CG_ClientNumFromName(_ p: String) -> Int32 {
    var i: Int32
    i = 0
    while i < cgs.maxclients {
        if cgs.clientinfo[i].infoValid && Q_stricmp(cgs.clientinfo[i].name, p) == 0 {
            return i
        }
        i += 1
    }
    return -1
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:870
func CG_ShowResponseHead() {
    Menus_OpenByName("voiceMenu")
    trap_Cvar_Set("cl_conXOffset", "72")
    cg.voiceTime = cg.time
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:876
func CG_RunMenuScript(_ args: inout JKAShared.TextCursor) {
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:879
func CG_DeferMenuScript(_ args: inout JKAShared.TextCursor) -> Bool {
    return false
}

/// Source: oracle/codemp/cgame/cg_newDraw.c:884
func CG_GetTeamColor(_ color: inout JKAShared.vec4_t) {
    if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_RED {
        (color)[0] = 1.0
        (color)[3] = 0.25
        (color)[2] = 0.0
        (color)[1] = (color)[2]
    } else if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_BLUE {
        (color)[1] = 0.0
        (color)[0] = (color)[1]
        (color)[2] = 1.0
        (color)[3] = 0.25
    } else {
        (color)[2] = 0.0
        (color)[0] = (color)[2]
        (color)[1] = 0.17
        (color)[3] = 0.25
    }
}
