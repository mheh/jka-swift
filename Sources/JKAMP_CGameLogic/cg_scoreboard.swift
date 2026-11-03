import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_scoreboard.c:8
let SCOREBOARD_X = (0) as Int32

/// Source: oracle/codemp/cgame/cg_scoreboard.c:10
let SB_HEADER = 86 as Int32

/// Source: oracle/codemp/cgame/cg_scoreboard.c:11
let SB_TOP = (SB_HEADER + 32)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:14
let SB_STATUSBAR = 420 as Int32

/// Source: oracle/codemp/cgame/cg_scoreboard.c:16
let SB_NORMAL_HEIGHT = 25 as Int32

/// Source: oracle/codemp/cgame/cg_scoreboard.c:17
let SB_INTER_HEIGHT = 15 as Int32

/// Source: oracle/codemp/cgame/cg_scoreboard.c:19
let SB_MAXCLIENTS_NORMAL = ((SB_STATUSBAR - SB_TOP) / SB_NORMAL_HEIGHT)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:20
let SB_MAXCLIENTS_INTER = ((SB_STATUSBAR - SB_TOP) / SB_INTER_HEIGHT - 1)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:26
let SB_LEFT_BOTICON_X = (SCOREBOARD_X + 0)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:27
let SB_LEFT_HEAD_X = (SCOREBOARD_X + 32)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:28
let SB_RIGHT_BOTICON_X = (SCOREBOARD_X + 64)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:29
let SB_RIGHT_HEAD_X = (SCOREBOARD_X + 96)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:31
let SB_BOTICON_X = (SCOREBOARD_X + 32)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:32
let SB_HEAD_X = (SCOREBOARD_X + 64)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:34
let SB_SCORELINE_X = 100 as Int32

/// Source: oracle/codemp/cgame/cg_scoreboard.c:35
let SB_SCORELINE_WIDTH = (640 - SB_SCORELINE_X * 2)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:37
let SB_RATING_WIDTH = 0 as Int32

/// Source: oracle/codemp/cgame/cg_scoreboard.c:38
let SB_NAME_X = (SB_SCORELINE_X)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:39
let SB_SCORE_X = (SB_SCORELINE_X + 0.55 * SB_SCORELINE_WIDTH)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:40
let SB_PING_X = (SB_SCORELINE_X + 0.70 * SB_SCORELINE_WIDTH)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:41
let SB_TIME_X = (SB_SCORELINE_X + 0.85 * SB_SCORELINE_WIDTH)

/// Source: oracle/codemp/cgame/cg_scoreboard.c:54
var localClient: Bool {
    get { world.variables.localClient }
    set { world.variables.localClient = newValue }
}

/// Source: oracle/codemp/cgame/cg_scoreboard.c:344
var cg_siegeWinTeam: Int32 {
    get { world.variables.cg_siegeWinTeam }
    set { world.variables.cg_siegeWinTeam = newValue }
}

/**
```
=================
CG_DrawScoreboard
=================
```
*/
/// Source: oracle/codemp/cgame/cg_scoreboard.c:62
private func CG_DrawClientScore(_ y: Int32, _ score: Score, _ color: inout Float, _ fade: Float, _ largeFormat: Bool) {
    //vec3_t	headAngles;
    var ci: ClientInfo?
    let iconx: Int32
    let headx: Int32
    let scale: Float

    if largeFormat {
        scale = 1.0
    } else {
        scale = 0.75
    }

    if score.client < 0 || score.client >= cgs.maxclients {
        Com_Printf("Bad score->client: %i\n", score.client)
        return
    }

    ci = cgs.clientinfo[score.client]

    iconx = SB_BOTICON_X + (SB_RATING_WIDTH / 2)
    headx = SB_HEAD_X + (SB_RATING_WIDTH / 2)

    // draw the handicap or bot skill marker (unless player has flag)
    if (ci!.powerups & (1 << PW_NEUTRALFLAG)) != 0 {
        if largeFormat {
            CG_DrawFlagModel(Float(iconx), Float(y - (32 - BIGCHAR_HEIGHT) / 2), 32, 32, TEAM_FREE, false)
        } else {
            CG_DrawFlagModel(Float(iconx), Float(y), 16, 16, TEAM_FREE, false)
        }
    } else if (ci!.powerups & (1 << PW_REDFLAG)) != 0 {
        if largeFormat {
            CG_DrawFlagModel(iconx * cgs.screenXScale, y * cgs.screenYScale, 32 * cgs.screenXScale, 32 * cgs.screenYScale, TEAM_RED, false)
        } else {
            CG_DrawFlagModel(iconx * cgs.screenXScale, y * cgs.screenYScale, 32 * cgs.screenXScale, 32 * cgs.screenYScale, TEAM_RED, false)
        }
    } else if (ci!.powerups & (1 << PW_BLUEFLAG)) != 0 {
        if largeFormat {
            CG_DrawFlagModel(iconx * cgs.screenXScale, y * cgs.screenYScale, 32 * cgs.screenXScale, 32 * cgs.screenYScale, TEAM_BLUE, false)
        } else {
            CG_DrawFlagModel(iconx * cgs.screenXScale, y * cgs.screenYScale, 32 * cgs.screenXScale, 32 * cgs.screenYScale, TEAM_BLUE, false)
        }
    } else if cgs.gametype == GT_POWERDUEL && (ci!.duelTeam == DUELTEAM_LONE || ci!.duelTeam == DUELTEAM_DOUBLE) {
        if ci!.duelTeam == DUELTEAM_LONE {
            CG_DrawPic(Float(iconx), Float(y), 32, 32, trap_R_RegisterShaderNoMip("gfx/mp/pduel_icon_lone"))
        } else {
            CG_DrawPic(Float(iconx), Float(y), 32, 32, trap_R_RegisterShaderNoMip("gfx/mp/pduel_icon_double"))
        }
    } else if cgs.gametype == GT_SIEGE {
        //try to draw the shader for this class on the scoreboard
        if ci!.siegeIndex != -1 {
            let scl: SiegeClass? = bgSiegeClasses[ci!.siegeIndex]

            if scl!.classShader != 0 {
                CG_DrawPic(Float(iconx), Float(y), Float(largeFormat ? 24 : 12), Float(largeFormat ? 24 : 12), scl!.classShader)
            }
        }
    } else {
        // draw the wins / losses
        /*
        if ( cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL )
        {
        CG_DrawSmallStringColor( iconx, y + SMALLCHAR_HEIGHT/2, va("%i/%i", ci->wins, ci->losses ), color );
        }
        */
        //rww - in duel, we now show wins/losses in place of "frags". This is because duel now defaults to 1 kill per round.
    }

    // highlight your position
    if score.client == cg.snap!.ps.clientNum {
        var hcolor: [Float] = [Float](repeating: 0, count: 4)
        let rank: Int32

        localClient = true

        if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_SPECTATOR || cgs.gametype >= GT_TEAM {
            rank = -1
        } else {
            rank = cg.snap!.ps.persistant[PERS_RANK] & ~RANK_TIED_FLAG
        }
        if rank == 0 {
            hcolor[0] = 0
            hcolor[1] = 0
            hcolor[2] = 0.7
        } else if rank == 1 {
            hcolor[0] = 0.7
            hcolor[1] = 0
            hcolor[2] = 0
        } else if rank == 2 {
            hcolor[0] = 0.7
            hcolor[1] = 0.7
            hcolor[2] = 0
        } else {
            hcolor[0] = 0.7
            hcolor[1] = 0.7
            hcolor[2] = 0.7
        }

        hcolor[3] = Float(Double(fade) * 0.7)
        CG_FillRect(Float(SB_SCORELINE_X - 5), Float(y + 2), Float(640 - SB_SCORELINE_X * 2 + 10), Float(largeFormat ? SB_NORMAL_HEIGHT : SB_INTER_HEIGHT), vec4_t(hcolor[0], hcolor[1], hcolor[2], hcolor[3]))
    }

    CG_Text_Paint(Float(SB_NAME_X), Float(y), 0.9 * scale, colorWhite, ci!.name, 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)

    if score.ping != -1 {
        if ci!.team != TEAM_SPECTATOR || cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
            if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
                CG_Text_Paint(Float(SB_SCORE_X), Float(y), 1.0 * scale, colorWhite, va("%i/%i", ci!.wins, ci!.losses), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL)
            } else {
                CG_Text_Paint(Float(SB_SCORE_X), Float(y), 1.0 * scale, colorWhite, va("%i", score.score), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL)
            }
        }

        CG_Text_Paint(Float(SB_PING_X), Float(y), 1.0 * scale, colorWhite, va("%i", score.ping), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL)
        CG_Text_Paint(Float(SB_TIME_X), Float(y), 1.0 * scale, colorWhite, va("%i", score.time), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL)
    } else {
        CG_Text_Paint(Float(SB_SCORE_X), Float(y), 1.0 * scale, colorWhite, "-", 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL)
        CG_Text_Paint(Float(SB_PING_X), Float(y), 1.0 * scale, colorWhite, "-", 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL)
        CG_Text_Paint(Float(SB_TIME_X), Float(y), 1.0 * scale, colorWhite, "-", 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL)
    }

    // add the "ready" marker for intermission exiting
    if (cg.snap!.ps.stats[STAT_CLIENTS_READY] & (1 << score.client)) != 0 {
        CG_Text_Paint(Float(SB_NAME_X - 64), Float(y + 2), 0.7 * scale, colorWhite, CG_GetStringEdString("MP_INGAME", "READY"), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    }
}

/**
```
=================
CG_TeamScoreboard
=================
```
*/
/// Source: oracle/codemp/cgame/cg_scoreboard.c:232
private func CG_TeamScoreboard(_ y: Int32, _ team: JKAMP.team_t, _ fade: Float, _ maxClients: Int32, _ lineHeight: Int32, _ countOnly: Bool) -> Int32 {
    var i: Int32
    var score: Score?
    var color: [Float] = [Float](repeating: 0, count: 4)
    var count: Int32
    var ci: ClientInfo?

    color[2] = 1.0
    color[1] = color[2]
    color[0] = color[1]
    color[3] = fade

    count = 0
    i = 0
    while i < cg.numScores && count < maxClients {
        score = cg.scores[i]
        ci = cgs.clientinfo[score!.client]

        if team != ci!.team {
            i += 1
            continue
        }

        if !countOnly {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '[Float]' to expected argument type 'Float'".
            // Raven wrote: CG_DrawClientScore( y + lineHeight * count, score, color, fade, lineHeight == SB_NORMAL_HEIGHT )
            portMissing("CG_TeamScoreboard", source: "oracle/codemp/cgame/cg_scoreboard.c:232")
        }

        count += 1
        i += 1
    }

    return count
}

/// Source: oracle/codemp/cgame/cg_scoreboard.c:263
func CG_GetClassCount(_ team: JKAMP.team_t, _ siegeClass: Int32) -> Int32 {
    var i: Int32 = 0
    var count: Int32 = 0
    var ci: ClientInfo?
    var scl: SiegeClass?

    i = 0
    while i < cgs.maxclients {
        ci = cgs.clientinfo[i]

        if (!ci!.infoValid) || (team != ci!.team) {
            i += 1
            continue
        }

        scl = bgSiegeClasses[ci!.siegeIndex]

        // Correct class?
        if siegeClass != scl!.classShader {
            i += 1
            continue
        }

        count += 1
        i += 1
    }

    return count
}

/// Source: oracle/codemp/cgame/cg_scoreboard.c:294
func CG_GetTeamNonScoreCount(_ team: JKAMP.team_t) -> Int32 {
    var i: Int32 = 0
    var count: Int32 = 0
    var ci: ClientInfo?

    i = 0
    while i < cgs.maxclients {
        ci = cgs.clientinfo[i]

        if (!ci!.infoValid) || (team != ci!.team && team != ci!.siegeDesiredTeam) {
            i += 1
            continue
        }

        count += 1
        i += 1
    }

    return count
}

/// Source: oracle/codemp/cgame/cg_scoreboard.c:314
func CG_GetTeamCount(_ team: JKAMP.team_t, _ maxClients: Int32) -> Int32 {
    var i: Int32 = 0
    var count: Int32 = 0
    var ci: ClientInfo?
    var score: Score?

    i = 0
    while i < cg.numScores && count < maxClients {
        score = cg.scores[i]
        ci = cgs.clientinfo[score!.client]

        if team != ci!.team {
            i += 1
            continue
        }

        count += 1
        i += 1
    }

    return count
}

/// Source: oracle/codemp/cgame/cg_scoreboard.c:345
func CG_DrawOldScoreboard() -> Bool {
    var x: Int32
    var y: Int32
    let w: Int32
    var i: Int32
    var n1: Int32
    var n2: Int32
    let fade: Float
    let fadeColor: vec4_t?
    var s: String
    var maxClients: Int32
    let lineHeight: Int32
    let topBorderSize: Int32
    let bottomBorderSize: Int32

    // don't draw amuthing if the menu or console is up
    if cg_paused.integer != 0 {
        cg.deferredPlayerLoading = 0
        return false
    }

    // don't draw scoreboard during death while warmup up
    if cg.warmup != 0 && !cg.showScores {
        return false
    }

    if cg.showScores || cg.predictedPlayerState.pm_type == PM_DEAD || cg.predictedPlayerState.pm_type == PM_INTERMISSION {
        fade = 1.0
        fadeColor = colorWhite
    } else {
        fadeColor = CG_FadeColor(cg.scoreFadeTime, FADE_TIME)

        if fadeColor == nil {
            // next time scoreboard comes up, don't print killer
            cg.deferredPlayerLoading = 0
            cg.killerName = ""
            return false
        }
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: fade = *fadeColor
        portMissing("CG_DrawOldScoreboard", source: "oracle/codemp/cgame/cg_scoreboard.c:345")
    }

    // fragged by ... line
    // or if in intermission and duel, prints the winner of the duel round
    if (cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL) && cgs.duelWinner != -1 && cg.predictedPlayerState.pm_type == PM_INTERMISSION {
        s = va("%s^7 %s", cgs.clientinfo[cgs.duelWinner].name, CG_GetStringEdString("MP_INGAME", "DUEL_WINS"))
        /*w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
        x = ( SCREEN_WIDTH - w ) / 2;
        y = 40;
        CG_DrawBigString( x, y, s, fade );
        */
        x = (SCREEN_WIDTH) / 2
        y = 40
        CG_Text_Paint(Float(x - CG_Text_Width(s, 1.0, FONT_MEDIUM) / 2), Float(y), 1.0, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    } else if (cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL) && cgs.duelist1 != -1 && cgs.duelist2 != -1 && cg.predictedPlayerState.pm_type == PM_INTERMISSION {
        if cgs.gametype == GT_POWERDUEL && cgs.duelist3 != -1 {
            s = va("%s^7 %s %s^7 %s %s", cgs.clientinfo[cgs.duelist1].name, CG_GetStringEdString("MP_INGAME", "SPECHUD_VERSUS"), cgs.clientinfo[cgs.duelist2].name, CG_GetStringEdString("MP_INGAME", "AND"), cgs.clientinfo[cgs.duelist3].name)
        } else {
            s = va("%s^7 %s %s", cgs.clientinfo[cgs.duelist1].name, CG_GetStringEdString("MP_INGAME", "SPECHUD_VERSUS"), cgs.clientinfo[cgs.duelist2].name)
        }
        /*w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
        x = ( SCREEN_WIDTH - w ) / 2;
        y = 40;
        CG_DrawBigString( x, y, s, fade );
        */
        x = (SCREEN_WIDTH) / 2
        y = 40
        CG_Text_Paint(Float(x - CG_Text_Width(s, 1.0, FONT_MEDIUM) / 2), Float(y), 1.0, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    } else if !cg.killerName.isEmpty {
        s = va("%s %s", CG_GetStringEdString("MP_INGAME", "KILLEDBY"), cg.killerName)
        /*w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
        x = ( SCREEN_WIDTH - w ) / 2;
        y = 40;
        CG_DrawBigString( x, y, s, fade );
        */
        x = (SCREEN_WIDTH) / 2
        y = 40
        CG_Text_Paint(Float(x - CG_Text_Width(s, 1.0, FONT_MEDIUM) / 2), Float(y), 1.0, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    }

    // current rank
    if cgs.gametype == GT_POWERDUEL {
        //do nothing?
    } else if cgs.gametype < GT_TEAM {
        if cg.snap!.ps.persistant[PERS_TEAM] != TEAM_SPECTATOR {
            var sPlace = CharBuf(256)
            var sOf = CharBuf(256)
            var sWith = CharBuf(256)

            strcpy(&sPlace, trap_SP_GetStringTextString("MP_INGAME_PLACE", Int32((sPlace).count)).1)
            strcpy(&sOf, trap_SP_GetStringTextString("MP_INGAME_OF", Int32((sOf).count)).1)
            strcpy(&sWith, trap_SP_GetStringTextString("MP_INGAME_WITH", Int32((sWith).count)).1)

            s = va("%s %s (%s %i) %s %i", CG_PlaceString(cg.snap!.ps.persistant[PERS_RANK] + 1), sPlace, sOf, cg.numScores, sWith, cg.snap!.ps.persistant[PERS_SCORE])
            w = CG_DrawStrlen(s) * BIGCHAR_WIDTH
            x = (SCREEN_WIDTH) / 2
            y = 60
            //CG_DrawBigString( x, y, s, fade );
            UI_DrawProportionalString(x, y, s, UI_CENTER | UI_DROPSHADOW, colorTable[CT_WHITE])
        }
    } else if cgs.gametype != GT_SIEGE {
        if cg.teamScores[0] == cg.teamScores[1] {
            s = va("%s %i", CG_GetStringEdString("MP_INGAME", "TIEDAT"), cg.teamScores[0])
        } else if cg.teamScores[0] >= cg.teamScores[1] {
            s = va("%s, %i / %i", CG_GetStringEdString("MP_INGAME", "RED_LEADS"), cg.teamScores[0], cg.teamScores[1])
        } else {
            s = va("%s, %i / %i", CG_GetStringEdString("MP_INGAME", "BLUE_LEADS"), cg.teamScores[1], cg.teamScores[0])
        }

        x = (SCREEN_WIDTH) / 2
        y = 60

        CG_Text_Paint(Float(x - CG_Text_Width(s, 1.0, FONT_MEDIUM) / 2), Float(y), 1.0, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    } else if cgs.gametype == GT_SIEGE && (cg_siegeWinTeam == 1 || cg_siegeWinTeam == 2) {
        if cg_siegeWinTeam == 1 {
            s = va("%s", CG_GetStringEdString("MP_INGAME", "SIEGETEAM1WIN"))
        } else {
            s = va("%s", CG_GetStringEdString("MP_INGAME", "SIEGETEAM2WIN"))
        }

        x = (SCREEN_WIDTH) / 2
        y = 60

        CG_Text_Paint(Float(x - CG_Text_Width(s, 1.0, FONT_MEDIUM) / 2), Float(y), 1.0, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    }

    // scoreboard
    y = SB_HEADER

    CG_DrawPic(Float(SB_SCORELINE_X - 40), Float(y - 5), Float(SB_SCORELINE_WIDTH + 80), 40, trap_R_RegisterShaderNoMip("gfx/menus/menu_buttonback.tga"))

    CG_Text_Paint(Float(SB_NAME_X), Float(y), 1.0, colorWhite, CG_GetStringEdString("MP_INGAME", "NAME"), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
        var sWL = CharBuf(100)
        strcpy(&sWL, trap_SP_GetStringTextString("MP_INGAME_W_L", Int32((sWL).count)).1)

        CG_Text_Paint(Float(SB_SCORE_X), Float(y), 1.0, colorWhite, String(sWL), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    } else {
        CG_Text_Paint(Float(SB_SCORE_X), Float(y), 1.0, colorWhite, CG_GetStringEdString("MP_INGAME", "SCORE"), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    }
    CG_Text_Paint(Float(SB_PING_X), Float(y), 1.0, colorWhite, CG_GetStringEdString("MP_INGAME", "PING"), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)
    CG_Text_Paint(Float(SB_TIME_X), Float(y), 1.0, colorWhite, CG_GetStringEdString("MP_INGAME", "TIME"), 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_MEDIUM)

    y = SB_TOP

    // If there are more than SB_MAXCLIENTS_NORMAL, use the interleaved scores
    if cg.numScores > SB_MAXCLIENTS_NORMAL {
        maxClients = SB_MAXCLIENTS_INTER
        lineHeight = SB_INTER_HEIGHT
        topBorderSize = 8
        bottomBorderSize = 16
    } else {
        maxClients = SB_MAXCLIENTS_NORMAL
        lineHeight = SB_NORMAL_HEIGHT
        topBorderSize = 8
        bottomBorderSize = 8
    }

    localClient = false


    //I guess this should end up being able to display 19 clients at once.
    //In a team game, if there are 9 or more clients on the team not in the lead,
    //we only want to show 10 of the clients on the team in the lead, so that we
    //have room to display the clients in the lead on the losing team.

    //I guess this can be accomplished simply by printing the first teams score with a maxClients
    //value passed in related to how many players are on both teams.
    if cgs.gametype >= GT_TEAM {
        //
        // teamplay scoreboard
        //
        y += lineHeight / 2

        if cg.teamScores[0] >= cg.teamScores[1] {
            var team1MaxCl: Int32 = CG_GetTeamCount(TEAM_RED, maxClients)
            var team2MaxCl: Int32 = CG_GetTeamCount(TEAM_BLUE, maxClients)

            if team1MaxCl > 10 && (team1MaxCl + team2MaxCl) > maxClients {
                team1MaxCl -= team2MaxCl
                //subtract as many as you have to down to 10, once we get there
                //we just set it to 10

                if team1MaxCl < 10 {
                    team1MaxCl = 10
                }
            }

            team2MaxCl = (maxClients - team1MaxCl) //team2 can display however many is left over after team1's display

            n1 = CG_TeamScoreboard(y, TEAM_RED, fade, team1MaxCl, lineHeight, true)
            CG_DrawTeamBackground(SB_SCORELINE_X - 5, y - topBorderSize, 640 - SB_SCORELINE_X * 2 + 10, n1 * lineHeight + bottomBorderSize, 0.33, TEAM_RED)
            CG_TeamScoreboard(y, TEAM_RED, fade, team1MaxCl, lineHeight, false)
            y += (n1 * lineHeight) + BIGCHAR_HEIGHT

            //maxClients -= n1;

            n2 = CG_TeamScoreboard(y, TEAM_BLUE, fade, team2MaxCl, lineHeight, true)
            CG_DrawTeamBackground(SB_SCORELINE_X - 5, y - topBorderSize, 640 - SB_SCORELINE_X * 2 + 10, n2 * lineHeight + bottomBorderSize, 0.33, TEAM_BLUE)
            CG_TeamScoreboard(y, TEAM_BLUE, fade, team2MaxCl, lineHeight, false)
            y += (n2 * lineHeight) + BIGCHAR_HEIGHT

            //maxClients -= n2;

            maxClients -= (team1MaxCl + team2MaxCl)
        } else {
            var team1MaxCl: Int32 = CG_GetTeamCount(TEAM_BLUE, maxClients)
            var team2MaxCl: Int32 = CG_GetTeamCount(TEAM_RED, maxClients)

            if team1MaxCl > 10 && (team1MaxCl + team2MaxCl) > maxClients {
                team1MaxCl -= team2MaxCl
                //subtract as many as you have to down to 10, once we get there
                //we just set it to 10

                if team1MaxCl < 10 {
                    team1MaxCl = 10
                }
            }

            team2MaxCl = (maxClients - team1MaxCl) //team2 can display however many is left over after team1's display

            n1 = CG_TeamScoreboard(y, TEAM_BLUE, fade, team1MaxCl, lineHeight, true)
            CG_DrawTeamBackground(SB_SCORELINE_X - 5, y - topBorderSize, 640 - SB_SCORELINE_X * 2 + 10, n1 * lineHeight + bottomBorderSize, 0.33, TEAM_BLUE)
            CG_TeamScoreboard(y, TEAM_BLUE, fade, team1MaxCl, lineHeight, false)
            y += (n1 * lineHeight) + BIGCHAR_HEIGHT

            //maxClients -= n1;

            n2 = CG_TeamScoreboard(y, TEAM_RED, fade, team2MaxCl, lineHeight, true)
            CG_DrawTeamBackground(SB_SCORELINE_X - 5, y - topBorderSize, 640 - SB_SCORELINE_X * 2 + 10, n2 * lineHeight + bottomBorderSize, 0.33, TEAM_RED)
            CG_TeamScoreboard(y, TEAM_RED, fade, team2MaxCl, lineHeight, false)
            y += (n2 * lineHeight) + BIGCHAR_HEIGHT

            //maxClients -= n2;

            maxClients -= (team1MaxCl + team2MaxCl)
        }
        n1 = CG_TeamScoreboard(y, TEAM_SPECTATOR, fade, maxClients, lineHeight, false)
        y += (n1 * lineHeight) + BIGCHAR_HEIGHT
    } else {
        //
        // free for all scoreboard
        //
        n1 = CG_TeamScoreboard(y, TEAM_FREE, fade, maxClients, lineHeight, false)
        y += (n1 * lineHeight) + BIGCHAR_HEIGHT
        n2 = CG_TeamScoreboard(y, TEAM_SPECTATOR, fade, maxClients - n1, lineHeight, false)
        y += (n2 * lineHeight) + BIGCHAR_HEIGHT
    }

    if !localClient {
        // draw local client at the bottom
        i = 0
        while i < cg.numScores {
            if cg.scores[i].client == cg.snap!.ps.clientNum {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t?' (aka 'Optional<SIMD4<Float>>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawClientScore( y, &cg.scores[i], fadeColor, fade, lineHeight == SB_NORMAL_HEIGHT )
                portMissing("CG_DrawOldScoreboard", source: "oracle/codemp/cgame/cg_scoreboard.c:345")
                break
            }
            i += 1
        }
    }

    // load any models that have been deferred
    // Port-note: A ++ inside an expression.
    // Raven wrote: if ( ++cg.deferredPlayerLoading > 10 ) { CG_LoadDeferredPlayers(); }
    portMissing("CG_DrawOldScoreboard", source: "oracle/codemp/cgame/cg_scoreboard.c:345")

    return true
}
