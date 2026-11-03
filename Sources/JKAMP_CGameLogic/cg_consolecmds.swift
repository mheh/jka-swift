import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_consolecmds.c:265
/// Raven's data table, a hand property of `CGameWorld`.
var commands: [ConsoleCommandRow] { world.commands }

/// Source: oracle/codemp/cgame/cg_consolecmds.c:13
func CG_TargetCommand_f() {
    let targetNum: Int32
    var test = CharBuf(4)

    targetNum = CG_CrosshairPlayer()
    if targetNum == 0 {
        return
    }

    strcpy(&test, trap_Argv(1, 4))
    trap_SendConsoleCommand(va("gc %i %i", targetNum, atoi(test)))
}

/**
```
=================
CG_SizeUp_f

Keybinding command
=================
```
*/
/// Source: oracle/codemp/cgame/cg_consolecmds.c:35
func CG_SizeUp_f() {
    trap_Cvar_Set("cg_viewsize", va("%i", Int32((cg_viewsize.integer + 10))))
}

/**
```
=================
CG_SizeDown_f

Keybinding command
=================
```
*/
/// Source: oracle/codemp/cgame/cg_consolecmds.c:47
func CG_SizeDown_f() {
    trap_Cvar_Set("cg_viewsize", va("%i", Int32((cg_viewsize.integer - 10))))
}

/**
```
=============
CG_Viewpos_f

Debugging command to print the current position
=============
```
*/
/// Source: oracle/codemp/cgame/cg_consolecmds.c:59
func CG_Viewpos_f() {
    CG_Printf("%s (%i %i %i) : %i\n", cgs.mapname, Int32(cg.refdef.vieworg[0]), Int32(cg.refdef.vieworg[1]), Int32(cg.refdef.vieworg[2]), Int32(cg.refdef.viewangles[YAW]))
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:66
func CG_ScoresDown_f() {
    CG_BuildSpectatorString()
    if cg.scoresRequestTime + 2000 < cg.time {
        // the scores are more than two seconds out of data,
        // so request new ones
        cg.scoresRequestTime = cg.time
        trap_SendClientCommand("score")

        // leave the current scores up if they were already
        // displayed, but if this is the first hit, clear them out
        if !cg.showScores {
            cg.showScores = true
            cg.numScores = 0
        }
    } else {
        // show the cached contents even if they just pressed if it
        // is within two seconds
        cg.showScores = true
    }
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:88
func CG_ScoresUp_f() {
    if cg.showScores {
        cg.showScores = false
        cg.scoreFadeTime = cg.time
    }
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:98
func CG_scrollScoresDown_f() {
    if menuScoreboard != nil && cg.scoreBoardShowing {
        Menu_ScrollFeeder(menuScoreboard!, FEEDER_SCOREBOARD, true)
        Menu_ScrollFeeder(menuScoreboard!, FEEDER_REDTEAM_LIST, true)
        Menu_ScrollFeeder(menuScoreboard!, FEEDER_BLUETEAM_LIST, true)
    }
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:107
func CG_scrollScoresUp_f() {
    if menuScoreboard != nil && cg.scoreBoardShowing {
        Menu_ScrollFeeder(menuScoreboard!, FEEDER_SCOREBOARD, false)
        Menu_ScrollFeeder(menuScoreboard!, FEEDER_REDTEAM_LIST, false)
        Menu_ScrollFeeder(menuScoreboard!, FEEDER_BLUETEAM_LIST, false)
    }
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:116
func CG_spWin_f() {
    trap_Cvar_Set("cg_cameraOrbit", "2")
    trap_Cvar_Set("cg_cameraOrbitDelay", "35")
    trap_Cvar_Set("cg_thirdPerson", "1")
    trap_Cvar_Set("cg_thirdPersonAngle", "0")
    trap_Cvar_Set("cg_thirdPersonRange", "100")
    CG_AddBufferedSound(cgs.media.winnerSound)
    //trap_S_StartLocalSound(cgs.media.winnerSound, CHAN_ANNOUNCER);
    CG_CenterPrint(CG_GetStringEdString("MP_INGAME", "YOU_WIN"), Int32(Double(SCREEN_HEIGHT) * 0.30), 0)
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:127
func CG_spLose_f() {
    trap_Cvar_Set("cg_cameraOrbit", "2")
    trap_Cvar_Set("cg_cameraOrbitDelay", "35")
    trap_Cvar_Set("cg_thirdPerson", "1")
    trap_Cvar_Set("cg_thirdPersonAngle", "0")
    trap_Cvar_Set("cg_thirdPersonRange", "100")
    CG_AddBufferedSound(cgs.media.loserSound)
    //trap_S_StartLocalSound(cgs.media.loserSound, CHAN_ANNOUNCER);
    CG_CenterPrint(CG_GetStringEdString("MP_INGAME", "YOU_LOSE"), Int32(Double(SCREEN_HEIGHT) * 0.30), 0)
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:139
func CG_TellTarget_f() {
    let clientNum: Int32
    var command = CharBuf(128)
    var message = CharBuf(128)

    clientNum = CG_CrosshairPlayer()
    if clientNum == -1 {
        return
    }

    strcpy(&message, trap_Args(128))
    Com_sprintf(&command, 128, "tell %i %s", clientNum, message)
    trap_SendClientCommand(String(command))
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:154
func CG_TellAttacker_f() {
    let clientNum: Int32
    var command = CharBuf(128)
    var message = CharBuf(128)

    clientNum = CG_LastAttacker()
    if clientNum == -1 {
        return
    }

    strcpy(&message, trap_Args(128))
    Com_sprintf(&command, 128, "tell %i %s", clientNum, message)
    trap_SendClientCommand(String(command))
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:176
func CG_StartOrbit_f() {
    var `var` = CharBuf(1024)

    strcpy(&`var`, trap_Cvar_VariableStringBuffer("developer", Int32((`var`).count)))
    if atoi(`var`) == 0 {
        return
    }
    if cg_cameraOrbit.value != 0 {
        trap_Cvar_Set("cg_cameraOrbit", "0")
        trap_Cvar_Set("cg_thirdPerson", "0")
    } else {
        trap_Cvar_Set("cg_cameraOrbit", "5")
        trap_Cvar_Set("cg_thirdPerson", "1")
        trap_Cvar_Set("cg_thirdPersonAngle", "0")
        trap_Cvar_Set("cg_thirdPersonRange", "100")
    }
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:195
func CG_SiegeBriefing_f() {
    let team: Int32

    if cgs.gametype != GT_SIEGE {
        //Cannot be displayed unless in this gametype
        return
    }

    team = cg.predictedPlayerState.persistant[PERS_TEAM]

    if team != SIEGETEAM_TEAM1 && team != SIEGETEAM_TEAM2 {
        //cannot be displayed if not on a valid team
        return
    }

    CG_SiegeBriefingDisplay(team, 0)
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:215
func CG_SiegeCvarUpdate_f() {
    let team: Int32

    if cgs.gametype != GT_SIEGE {
        //Cannot be displayed unless in this gametype
        return
    }

    team = cg.predictedPlayerState.persistant[PERS_TEAM]

    if team != SIEGETEAM_TEAM1 && team != SIEGETEAM_TEAM2 {
        //cannot be displayed if not on a valid team
        return
    }

    CG_SiegeBriefingDisplay(team, 1)
}

/// Source: oracle/codemp/cgame/cg_consolecmds.c:234
func CG_SiegeCompleteCvarUpdate_f() {
    if cgs.gametype != GT_SIEGE {
        //Cannot be displayed unless in this gametype
        return
    }

    // Set up cvars for both teams
    CG_SiegeBriefingDisplay(SIEGETEAM_TEAM1, 1)
    CG_SiegeBriefingDisplay(SIEGETEAM_TEAM2, 1)
}

/**
```
=================
CG_ConsoleCommand

The string has been tokenized and can be retrieved with
Cmd_Argc() / Cmd_Argv()
=================
```
*/
/// Source: oracle/codemp/cgame/cg_consolecmds.c:309
public func CG_ConsoleCommand() -> Bool {
    let cmd: String
    var i: Int32

    cmd = CG_Argv(0)

    i = 0
    while i < commands.count {
        if Q_stricmp(cmd, commands[i].cmd) == 0 {
            commands[i].function()
            return true
        }
        i += 1
    }

    return false
}

/**
```
=================
CG_InitConsoleCommands

Let the client system know about all of our commands
so it can perform tab completion
=================
```
*/
/// Source: oracle/codemp/cgame/cg_consolecmds.c:334
func CG_InitConsoleCommands() {
    var i: Int32

    i = 0
    while i < commands.count {
        trap_AddCommand(commands[i].cmd)
        i += 1
    }

    //
    // the game server will interpret these commands, which will be automatically
    // forwarded to the server after they are not recognized locally
    //
    trap_AddCommand("forcechanged")
    trap_AddCommand("sv_invnext")
    trap_AddCommand("sv_invprev")
    trap_AddCommand("sv_forcenext")
    trap_AddCommand("sv_forceprev")
    trap_AddCommand("sv_saberswitch")
    trap_AddCommand("engage_duel")
    trap_AddCommand("force_heal")
    trap_AddCommand("force_speed")
    trap_AddCommand("force_throw")
    trap_AddCommand("force_pull")
    trap_AddCommand("force_distract")
    trap_AddCommand("force_rage")
    trap_AddCommand("force_protect")
    trap_AddCommand("force_absorb")
    trap_AddCommand("force_healother")
    trap_AddCommand("force_forcepowerother")
    trap_AddCommand("force_seeing")
    trap_AddCommand("use_seeker")
    trap_AddCommand("use_field")
    trap_AddCommand("use_bacta")
    trap_AddCommand("use_electrobinoculars")
    trap_AddCommand("zoom")
    trap_AddCommand("use_sentry")
    trap_AddCommand("bot_order")
    trap_AddCommand("saberAttackCycle")
    trap_AddCommand("kill")
    trap_AddCommand("say")
    trap_AddCommand("say_team")
    trap_AddCommand("tell")
    trap_AddCommand("give")
    trap_AddCommand("god")
    trap_AddCommand("notarget")
    trap_AddCommand("noclip")
    trap_AddCommand("team")
    trap_AddCommand("follow")
    trap_AddCommand("levelshot")
    trap_AddCommand("addbot")
    trap_AddCommand("setviewpos")
    trap_AddCommand("callvote")
    trap_AddCommand("vote")
    trap_AddCommand("callteamvote")
    trap_AddCommand("teamvote")
    trap_AddCommand("stats")
    trap_AddCommand("teamtask")
    trap_AddCommand("loaddefered") // spelled wrong, but not changing for demo
}
