import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_cmds.c:750
var g_dontPenalizeTeam: Bool {
    get { world.variables.g_dontPenalizeTeam }
    set { world.variables.g_dontPenalizeTeam = newValue }
}

/// Source: oracle/codemp/game/g_cmds.c:751
var g_preventTeamBegin: Bool {
    get { world.variables.g_preventTeamBegin }
    set { world.variables.g_preventTeamBegin = newValue }
}

/// Source: oracle/codemp/game/g_cmds.c:1616
let EC = "\u{19}"

/// Raven's `static char line[MAX_STRING_CHARS]` of `ConcatArgs`, a property of `GameWorld`.
/// Source: oracle/codemp/game/g_cmds.c:129
var line: CharBuf {
    get { world.line }
    set { world.line = newValue }
}

/// Source: oracle/codemp/game/g_cmds.c:1812
/// Raven's data table, a hand property of `GameWorld`.
var gc_orders: [String] {
    get { world.gc_orders }
    set { world.gc_orders = newValue }
}

/// Source: oracle/codemp/game/g_cmds.c:1851
/// Raven's data table, a hand property of `GameWorld`.
var gameNames: [String] {
    get { world.gameNames }
    set { world.gameNames = newValue }
}

/**
```
==================
DeathmatchScoreboardMessage

==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:25
func DeathmatchScoreboardMessage(_ ent: Entity) {
    var entry = CharBuf(1024)
    var string = CharBuf(1400)
    var stringlength: Int32
    var i: Int32
    var j: Int32
    var cl: Client?
    var numSorted: Int32
    let scoreFlags: Int32
    var accuracy: Int32
    var perfect: Int32

    // send the latest information on all clients
    string[0] = 0
    stringlength = 0
    scoreFlags = 0

    numSorted = level.numConnectedClients

    if numSorted > MAX_CLIENT_SCORE_SEND {
        numSorted = MAX_CLIENT_SCORE_SEND
    }

    i = 0
    while i < numSorted {
        var ping: Int32

        cl = level.clientsSlots[level.sortedClients[i]]

        if cl!.pers.connected == CON_CONNECTING {
            ping = -1
        } else {
            ping = cl!.ps.ping < 999 ? cl!.ps.ping : 999
        }

        if cl!.accuracy_shots != 0 {
            accuracy = cl!.accuracy_hits * 100 / cl!.accuracy_shots
        } else {
            accuracy = 0
        }
        perfect = (cl!.ps.persistant[PERS_RANK] == 0 && cl!.ps.persistant[PERS_KILLED] == 0) ? 1 : 0

        Com_sprintf(&entry, Int32((entry).count), " %i %i %i %i %i %i %i %i %i %i %i %i %i %i", level.sortedClients[i], cl!.ps.persistant[PERS_SCORE], ping, (level.time - cl!.pers.enterTime) / 60000, scoreFlags, g_entities[level.sortedClients[i]].s.powerups, accuracy, cl!.ps.persistant[PERS_IMPRESSIVE_COUNT], cl!.ps.persistant[PERS_EXCELLENT_COUNT], cl!.ps.persistant[PERS_GAUNTLET_FRAG_COUNT], cl!.ps.persistant[PERS_DEFEND_COUNT], cl!.ps.persistant[PERS_ASSIST_COUNT], perfect, cl!.ps.persistant[PERS_CAPTURES])
        j = strlen(entry)
        if stringlength + j > 1022 {
            break
        }
        strcpy(&string + stringlength, entry)
        stringlength += j
        i += 1
    }

    //still want to know the total # of clients
    i = level.numConnectedClients

    trap_SendServerCommand(ent.s.number, va("scores %i %i %i%s", i, level.teamScores[TEAM_RED], level.teamScores[TEAM_BLUE], string))
}

/**
```
==================
Cmd_Score_f

Request current scoreboard information
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:98
func Cmd_Score_f(_ ent: Entity) {
    DeathmatchScoreboardMessage(ent)
}

/**
```
==================
CheatsOk
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:109
func CheatsOk(_ ent: Entity) -> Bool {
    if g_cheats.integer == 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOCHEATS")))
        return false
    }
    if ent.health <= 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "MUSTBEALIVE")))
        return false
    }
    return true
}

/**
```
==================
ConcatArgs
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:127
func ConcatArgs(_ start: Int32) -> String {
    var i: Int32
    let c: Int32
    var tlen: Int32
    var len: Int32
    var arg = CharBuf(1024)

    len = 0
    c = trap_Argc()
    i = start
    while i < c {
        strcpy(&arg, trap_Argv(i, Int32((arg).count)))
        tlen = strlen(arg)
        if len + tlen >= MAX_STRING_CHARS - 1 {
            break
        }
        strncpy(&line, String(arg), tlen, at: len)
        len += tlen
        if i != c - 1 {
            line[len] = Int32(ascii: " ")
            len += 1
        }
        i += 1
    }

    line[len] = 0

    return String(line)
}

/**
```
==================
SanitizeString

Remove case and control characters
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:161
func SanitizeString(_ `in`: inout JKAShared.CharBuf, _ out: inout JKAShared.CharBuf) {
    var inIndex: Int32 = 0
    var outIndex: Int32 = 0

    while `in`[inIndex] != 0 {
        if `in`[inIndex] == 27 {
            inIndex += 2 // skip color code
            continue
        }
        if `in`[inIndex] < 32 {
            inIndex += 1
            continue
        }
        out[outIndex] = JKAShared.tolower(Int32(UInt8(truncatingIfNeeded: `in`[inIndex])))
        outIndex += 1
        inIndex += 1
    }

    out[outIndex] = 0
}

/**
```
==================
ClientNumberFromString

Returns a player number for either a number or name string
Returns -1 if invalid
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:185
func ClientNumberFromString(_ to: Entity, _ s: inout JKAShared.CharBuf) -> Int32 {
    var clIndex: Int32
    var idnum: Int32
    var s2 = CharBuf(1024)
    var n2 = CharBuf(1024)

    // numeric values are just slot numbers
    if s[0] >= Int32(ascii: "0") && s[0] <= Int32(ascii: "9") {
        idnum = atoi(s)
        if idnum < 0 || idnum >= level.maxclients {
            trap_SendServerCommand(to.s.number, va("print \"Bad client slot: %i\n\"", idnum))
            return -1
        }

        clIndex = idnum
        if level.clientsSlots[clIndex].pers.connected != CON_CONNECTED {
            trap_SendServerCommand(to.s.number, va("print \"Client %i is not active\n\"", idnum))
            return -1
        }
        return idnum
    }

    // check for a name match
    SanitizeString(&s, &s2)
    idnum = 0
    clIndex = 0
    while idnum < level.maxclients {
        if level.clientsSlots[clIndex].pers.connected != CON_CONNECTED {
            idnum += 1
            clIndex += 1
            continue
        }
        SanitizeString(&level.clientsSlots[clIndex].pers.netnameBuffer, &n2)
        if strcmp(n2, s2) == 0 {
            return idnum
        }
        idnum += 1
        clIndex += 1
    }

    trap_SendServerCommand(to.s.number, va("print \"User %s is not on the server\n\"", s))
    return -1
}

/**
```
==================
Cmd_Give_f

Give items to a client
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:230
func Cmd_Give_f(_ cmdent: Entity, _ baseArg: Int32) {
    var name = CharBuf(1024)
    var ent: Entity?
    var it: Gitem?
    var i: Int32 = 0
    var give_all: Bool = false
    var it_ent: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var arg = CharBuf(1024)

        if !CheatsOk(cmdent) {
            return true
        }

        if baseArg != 0 {
            var otherindex = CharBuf(1024)

            strcpy(&otherindex, trap_Argv(1, Int32((otherindex).count)))

            if otherindex[0] == 0 {
                Com_Printf("giveother requires that the second argument be a client index number.\n")
                return true
            }

            i = atoi(otherindex)

            if i < 0 || i >= MAX_CLIENTS {
                Com_Printf("%i is not a client index\n", i)
                return true
            }

            ent = g_entities[i]

            if !ent!.inuse || ent!.client == nil {
                Com_Printf("%i is not an active client\n", i)
                return true
            }
        } else {
            ent = cmdent
        }

        strcpy(&name, trap_Argv(1 + baseArg, Int32((name).count)))

        if Q_stricmp(name, "all") == 0 {
            give_all = true
        } else {
            give_all = false
        }

        if give_all {
            i = 0
            while i < HI_NUM_HOLDABLE {
                ent!.client!.ps.stats[STAT_HOLDABLE_ITEMS] |= (1 << i)
                i += 1
            }
            i = 0
        }

        if give_all || Q_stricmp(name, "health") == 0 {
            if trap_Argc() == 3 + baseArg {
                strcpy(&arg, trap_Argv(2 + baseArg, Int32((arg).count)))
                ent!.health = atoi(arg)
                if ent!.health > ent!.client!.ps.stats[STAT_MAX_HEALTH] {
                    ent!.health = ent!.client!.ps.stats[STAT_MAX_HEALTH]
                }
            } else {
                ent!.health = ent!.client!.ps.stats[STAT_MAX_HEALTH]
            }
            if !give_all {
                return true
            }
        }

        if give_all || Q_stricmp(name, "weapons") == 0 {
            ent!.client!.ps.stats[STAT_WEAPONS] = (1 << (WP_BRYAR_OLD + 1)) - (1 << WP_NONE)
            if !give_all {
                return true
            }
        }

        if !give_all && Q_stricmp(name, "weaponnum") == 0 {
            strcpy(&arg, trap_Argv(2 + baseArg, Int32((arg).count)))
            ent!.client!.ps.stats[STAT_WEAPONS] |= (1 << atoi(arg))
            return true
        }

        if give_all || Q_stricmp(name, "ammo") == 0 {
            var num: Int32 = 999
            if trap_Argc() == 3 + baseArg {
                strcpy(&arg, trap_Argv(2 + baseArg, Int32((arg).count)))
                num = atoi(arg)
            }
            i = 0
            while i < MAX_WEAPONS {
                ent!.client!.ps.ammo[i] = num
                i += 1
            }
            if !give_all {
                return true
            }
        }

        if give_all || Q_stricmp(name, "armor") == 0 {
            if trap_Argc() == 3 + baseArg {
                strcpy(&arg, trap_Argv(2 + baseArg, Int32((arg).count)))
                ent!.client!.ps.stats[STAT_ARMOR] = atoi(arg)
            } else {
                ent!.client!.ps.stats[STAT_ARMOR] = ent!.client!.ps.stats[STAT_MAX_HEALTH]
            }

            if !give_all {
                return true
            }
        }

        if Q_stricmp(name, "excellent") == 0 {
            ent!.client!.ps.persistant[PERS_EXCELLENT_COUNT] += 1
            return true
        }
        if Q_stricmp(name, "impressive") == 0 {
            ent!.client!.ps.persistant[PERS_IMPRESSIVE_COUNT] += 1
            return true
        }
        if Q_stricmp(name, "gauntletaward") == 0 {
            ent!.client!.ps.persistant[PERS_GAUNTLET_FRAG_COUNT] += 1
            return true
        }
        if Q_stricmp(name, "defend") == 0 {
            ent!.client!.ps.persistant[PERS_DEFEND_COUNT] += 1
            return true
        }
        if Q_stricmp(name, "assist") == 0 {
            ent!.client!.ps.persistant[PERS_ASSIST_COUNT] += 1
            return true
        }

        // spawn a specific item right on the player
        if !give_all {
            it = BG_FindItem(String(name))
            if it == nil {
                return true
            }

            it_ent = G_Spawn()
            it_ent!.s.origin = ent!.r.currentOrigin
            it_ent!.classname = it!.classname
            G_SpawnItem(it_ent!, it!)
            FinishSpawningItem(it_ent!)
            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
            Touch_Item(it_ent!, ent!, trace)
            if it_ent!.inuse {
                G_FreeEntity(it_ent!)
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
==================
Cmd_God_f

Sets client to godmode

argv(0) god
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:403
func Cmd_God_f(_ ent: Entity) {
    let msg: String

    if !CheatsOk(ent) {
        return
    }

    ent.flags ^= FL_GODMODE
    if !((ent.flags & FL_GODMODE) != 0) {
        msg = "godmode OFF\n"
    } else {
        msg = "godmode ON\n"
    }

    trap_SendServerCommand(ent.s.number, va("print \"%s\"", msg))
}

/**
```
==================
Cmd_Notarget_f

Sets client to notarget

argv(0) notarget
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:430
func Cmd_Notarget_f(_ ent: Entity) {
    let msg: String

    if !CheatsOk(ent) {
        return
    }

    ent.flags ^= FL_NOTARGET
    if !((ent.flags & FL_NOTARGET) != 0) {
        msg = "notarget OFF\n"
    } else {
        msg = "notarget ON\n"
    }

    trap_SendServerCommand(ent.s.number, va("print \"%s\"", msg))
}

/**
```
==================
Cmd_Noclip_f

argv(0) noclip
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:454
func Cmd_Noclip_f(_ ent: Entity) {
    let msg: String

    if !CheatsOk(ent) {
        return
    }

    if ent.client!.noclip {
        msg = "noclip OFF\n"
    } else {
        msg = "noclip ON\n"
    }
    ent.client!.noclip = !ent.client!.noclip

    trap_SendServerCommand(ent.s.number, va("print \"%s\"", msg))
}

/**
```
==================
Cmd_LevelShot_f

This is just to help generate the level pictures
for the menus.  It goes to the intermission immediately
and sends over a command to the client to resize the view,
hide the scoreboard, and take a special screenshot
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:482
func Cmd_LevelShot_f(_ ent: Entity) {
    if !CheatsOk(ent) {
        return
    }

    // doesn't work in single player
    if g_gametype.integer != 0 {
        trap_SendServerCommand(ent.s.number, "print \"Must be in g_gametype 0 for levelshot\n\"")
        return
    }

    BeginIntermission()
    trap_SendServerCommand(ent.s.number, "clientLevelShot")
}

/**
```
==================
Cmd_TeamTask_f

From TA.
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:506
func Cmd_TeamTask_f(_ ent: Entity) {
    var userinfo = CharBuf(1024)
    var arg = CharBuf(1024)
    let task: Int32
    let client = level.clientsSlots.index(of: ent.client!)

    if trap_Argc() != 2 {
        return
    }
    strcpy(&arg, trap_Argv(1, Int32((arg).count)))
    task = atoi(arg)

    strcpy(&userinfo, trap_GetUserinfo(client, Int32((userinfo).count)))
    Info_SetValueForKey(&userinfo, "teamtask", va("%d", task))
    trap_SetUserinfo(client, String(userinfo))
    ClientUserinfoChanged(client)
}

/// Source: oracle/codemp/game/g_cmds.c:527
func G_CheckTKAutoKickBan(_ ent: Entity) {
    if ent.client == nil || ent.s.number >= MAX_CLIENTS {
        return
    }

    if g_autoKickTKSpammers.integer > 0 || g_autoBanTKSpammers.integer > 0 {
        ent.client!.sess.TKCount += 1
        if g_autoBanTKSpammers.integer > 0 && ent.client!.sess.TKCount >= g_autoBanTKSpammers.integer {
            if !ent.client!.sess.IPstring.isEmpty {
                //ban their IP
                AddIP(&ent.client!.sess.IPstringBuffer)
            }

            trap_SendServerCommand(-1, va("print \"%s %s\n\"", ent.client!.pers.netname, G_GetStringEdString("MP_SVGAME_ADMIN", "TKBAN")))
            //Com_sprintf ( level.voteString, sizeof(level.voteString ), "clientkick %d", ent->s.number );
            //Com_sprintf ( level.voteDisplayString, sizeof(level.voteDisplayString), "kick %s", ent->client->pers.netname );
            //trap_SendConsoleCommand( EXEC_INSERT, va( "banClient %d\n", ent->s.number ) );
            trap_SendConsoleCommand(EXEC_INSERT, va("clientkick %d\n", ent.s.number))
            return
        }
        if g_autoKickTKSpammers.integer > 0 && ent.client!.sess.TKCount >= g_autoKickTKSpammers.integer {
            trap_SendServerCommand(-1, va("print \"%s %s\n\"", ent.client!.pers.netname, G_GetStringEdString("MP_SVGAME_ADMIN", "TKKICK")))
            //Com_sprintf ( level.voteString, sizeof(level.voteString ), "clientkick %d", ent->s.number );
            //Com_sprintf ( level.voteDisplayString, sizeof(level.voteDisplayString), "kick \"%s\"\n", ent->client->pers.netname );
            trap_SendConsoleCommand(EXEC_INSERT, va("clientkick %d\n", ent.s.number))
            return
        }
        //okay, not gone (yet), but warn them...
        if g_autoBanTKSpammers.integer > 0 && (g_autoKickTKSpammers.integer <= 0 || g_autoBanTKSpammers.integer < g_autoKickTKSpammers.integer) {
            //warn about ban
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME_ADMIN", "WARNINGTKBAN")))
        } else if g_autoKickTKSpammers.integer > 0 {
            //warn about kick
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME_ADMIN", "WARNINGTKKICK")))
        }
    }
}

/// Source: oracle/codemp/game/g_cmds.c:583
func Cmd_Kill_f(_ ent: Entity) {
    if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
        return
    }
    if ent.health <= 0 {
        return
    }

    if (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) && level.numPlayingClients > 1 && level.warmupTime == 0 {
        if g_allowDuelSuicide.integer == 0 {
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "ATTEMPTDUELKILL")))
            return
        }
    }

    if g_autoKickKillSpammers.integer > 0 || g_autoBanKillSpammers.integer > 0 {
        ent.client!.sess.killCount += 1
        if g_autoBanKillSpammers.integer > 0 && ent.client!.sess.killCount >= g_autoBanKillSpammers.integer {
            if !ent.client!.sess.IPstring.isEmpty {
                //ban their IP
                AddIP(&ent.client!.sess.IPstringBuffer)
            }

            trap_SendServerCommand(-1, va("print \"%s %s\n\"", ent.client!.pers.netname, G_GetStringEdString("MP_SVGAME_ADMIN", "SUICIDEBAN")))
            //Com_sprintf ( level.voteString, sizeof(level.voteString ), "clientkick %d", ent->s.number );
            //Com_sprintf ( level.voteDisplayString, sizeof(level.voteDisplayString), "kick %s", ent->client->pers.netname );
            //trap_SendConsoleCommand( EXEC_INSERT, va( "banClient %d\n", ent->s.number ) );
            trap_SendConsoleCommand(EXEC_INSERT, va("clientkick %d\n", ent.s.number))
            return
        }
        if g_autoKickKillSpammers.integer > 0 && ent.client!.sess.killCount >= g_autoKickKillSpammers.integer {
            trap_SendServerCommand(-1, va("print \"%s %s\n\"", ent.client!.pers.netname, G_GetStringEdString("MP_SVGAME_ADMIN", "SUICIDEKICK")))
            //Com_sprintf ( level.voteString, sizeof(level.voteString ), "clientkick %d", ent->s.number );
            //Com_sprintf ( level.voteDisplayString, sizeof(level.voteDisplayString), "kick %s", ent->client->pers.netname );
            trap_SendConsoleCommand(EXEC_INSERT, va("clientkick %d\n", ent.s.number))
            return
        }
        //okay, not gone (yet), but warn them...
        if g_autoBanKillSpammers.integer > 0 && (g_autoKickKillSpammers.integer <= 0 || g_autoBanKillSpammers.integer < g_autoKickKillSpammers.integer) {
            //warn about ban
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME_ADMIN", "WARNINGSUICIDEBAN")))
        } else if g_autoKickKillSpammers.integer > 0 {
            //warn about kick
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME_ADMIN", "WARNINGSUICIDEKICK")))
        }
    }
    ent.flags &= ~FL_GODMODE
    ent.health = -999
    ent.client!.ps.stats[STAT_HEALTH] = ent.health
    player_die(ent, ent, ent, 100000, MOD_SUICIDE)
}

/// Source: oracle/codemp/game/g_cmds.c:645
func G_GetDuelWinner(_ client: Client) -> Entity? {
    var wCl: Client?
    var i: Int32

    i = 0
    while i < level.maxclients {
        wCl = level.clientsSlots[i]

        if wCl != nil && wCl != client && wCl!.pers.connected == CON_CONNECTED && wCl!.sess.sessionTeam != TEAM_SPECTATOR {
            return g_entities[wCl!.ps.clientNum]
        }
        i += 1
    }

    return nil
}

/**
```
=================
BroadCastTeamChange

Let everyone know about a team change
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:670
func BroadcastTeamChange(_ client: Client, _ oldTeam: Int32) {
    client.ps.fd.forceDoInit = 1 //every time we change teams make sure our force powers are set right

    if g_gametype.integer == GT_SIEGE {
        //don't announce these things in siege
        return
    }

    if client.sess.sessionTeam == TEAM_RED {
        trap_SendServerCommand(-1, va("cp \"%s" + S_COLOR_WHITE + " %s\n\"", client.pers.netname, G_GetStringEdString("MP_SVGAME", "JOINEDTHEREDTEAM")))
    } else if client.sess.sessionTeam == TEAM_BLUE {
        trap_SendServerCommand(-1, va("cp \"%s" + S_COLOR_WHITE + " %s\n\"", client.pers.netname, G_GetStringEdString("MP_SVGAME", "JOINEDTHEBLUETEAM")))
    } else if client.sess.sessionTeam == TEAM_SPECTATOR && oldTeam != TEAM_SPECTATOR {
        trap_SendServerCommand(-1, va("cp \"%s" + S_COLOR_WHITE + " %s\n\"", client.pers.netname, G_GetStringEdString("MP_SVGAME", "JOINEDTHESPECTATORS")))
    } else if client.sess.sessionTeam == TEAM_FREE {
        if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
            /*
            gentity_t *currentWinner = G_GetDuelWinner(client);

            if (currentWinner && currentWinner->client)
            {
            trap_SendServerCommand( -1, va("cp \"%s" S_COLOR_WHITE " %s %s\n\"",
            currentWinner->client->pers.netname, G_GetStringEdString("MP_SVGAME", "VERSUS"), client->pers.netname));
            }
            else
            {
            trap_SendServerCommand( -1, va("cp \"%s" S_COLOR_WHITE " %s\n\"",
            client->pers.netname, G_GetStringEdString("MP_SVGAME", "JOINEDTHEBATTLE")));
            }
            */
            //NOTE: Just doing a vs. once it counts two players up
        } else {
            trap_SendServerCommand(-1, va("cp \"%s" + S_COLOR_WHITE + " %s\n\"", client.pers.netname, G_GetStringEdString("MP_SVGAME", "JOINEDTHEBATTLE")))
        }
    }

    G_LogPrintf("setteam:  %i %s %s\n", level.clientsSlots.index(of: client), TeamName(oldTeam), TeamName(client.sess.sessionTeam))
}

/// Source: oracle/codemp/game/g_cmds.c:720
func G_PowerDuelCheckFail(_ ent: Entity) -> Bool {
    var loners: Int32 = 0
    var doubles: Int32 = 0

    if ent.client == nil || ent.client!.sess.duelTeam == DUELTEAM_FREE {
        return true
    }

    G_PowerDuelCount(&loners, &doubles, false)

    if ent.client!.sess.duelTeam == DUELTEAM_LONE && loners >= 1 {
        return true
    }

    if ent.client!.sess.duelTeam == DUELTEAM_DOUBLE && doubles >= 2 {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/g_cmds.c:752
func SetTeam(_ ent: Entity, _ s: String) {
    var team: Int32
    let oldTeam: Int32
    var client: Client?
    let clientNum: Int32
    var specState: spectatorState_t
    var specClient: Int32
    let teamLeader: Int32

    //
    // see what change is requested
    //
    client = ent.client

    clientNum = level.clientsSlots.index(of: client!)
    specClient = 0
    specState = SPECTATOR_NOT
    if Q_stricmp(s, "scoreboard") == 0 || Q_stricmp(s, "score") == 0 {
        team = TEAM_SPECTATOR
        specState = SPECTATOR_SCOREBOARD
    } else if Q_stricmp(s, "follow1") == 0 {
        team = TEAM_SPECTATOR
        specState = SPECTATOR_FOLLOW
        specClient = -1
    } else if Q_stricmp(s, "follow2") == 0 {
        team = TEAM_SPECTATOR
        specState = SPECTATOR_FOLLOW
        specClient = -2
    } else if Q_stricmp(s, "spectator") == 0 || Q_stricmp(s, "s") == 0 {
        team = TEAM_SPECTATOR
        specState = SPECTATOR_FREE
    } else if g_gametype.integer >= GT_TEAM {
        // if running a team game, assign player to one of the teams
        specState = SPECTATOR_NOT
        if Q_stricmp(s, "red") == 0 || Q_stricmp(s, "r") == 0 {
            team = TEAM_RED
        } else if Q_stricmp(s, "blue") == 0 || Q_stricmp(s, "b") == 0 {
            team = TEAM_BLUE
        } else {
            // pick the team with the least number of players
            //For now, don't do this. The legalize function will set powers properly now.
            /*
            if (g_forceBasedTeams.integer)
            {
            if (ent->client->ps.fd.forceSide == FORCE_LIGHTSIDE)
            {
            team = TEAM_BLUE;
            }
            else
            {
            team = TEAM_RED;
            }
            }
            else
            {
            */
            team = PickTeam(clientNum)
            //}
        }

        if g_teamForceBalance.integer != 0 && g_trueJedi.integer == 0 {
            var counts: [Int32] = [Int32](repeating: 0, count: 4)

            counts[TEAM_BLUE] = TeamCount(ent.client!.ps.clientNum, TEAM_BLUE)
            counts[TEAM_RED] = TeamCount(ent.client!.ps.clientNum, TEAM_RED)

            // We allow a spread of two
            if team == TEAM_RED && counts[TEAM_RED] - counts[TEAM_BLUE] > 1 {
                //For now, don't do this. The legalize function will set powers properly now.
                /*
                if (g_forceBasedTeams.integer && ent->client->ps.fd.forceSide == FORCE_DARKSIDE)
                {
                trap_SendServerCommand( ent->client->ps.clientNum,
                va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TOOMANYRED_SWITCH")) );
                }
                else
                */
                do {
                    trap_SendServerCommand(ent.client!.ps.clientNum, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TOOMANYRED")))
                }
                return // ignore the request
            }
            if team == TEAM_BLUE && counts[TEAM_BLUE] - counts[TEAM_RED] > 1 {
                //For now, don't do this. The legalize function will set powers properly now.
                /*
                if (g_forceBasedTeams.integer && ent->client->ps.fd.forceSide == FORCE_LIGHTSIDE)
                {
                trap_SendServerCommand( ent->client->ps.clientNum,
                va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TOOMANYBLUE_SWITCH")) );
                }
                else
                */
                do {
                    trap_SendServerCommand(ent.client!.ps.clientNum, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TOOMANYBLUE")))
                }
                return // ignore the request
            }

            // It's ok, the team we are switching to has less or same number of players
        }

        //For now, don't do this. The legalize function will set powers properly now.
        /*
        if (g_forceBasedTeams.integer)
        {
        if (team == TEAM_BLUE && ent->client->ps.fd.forceSide != FORCE_LIGHTSIDE)
        {
        trap_SendServerCommand( ent-g_entities, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "MUSTBELIGHT")) );
        return;
        }
        if (team == TEAM_RED && ent->client->ps.fd.forceSide != FORCE_DARKSIDE)
        {
        trap_SendServerCommand( ent-g_entities, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "MUSTBEDARK")) );
        return;
        }
        }
        */
    } else {
        // force them to spectators if there aren't any spots free
        team = TEAM_FREE
    }

    if g_gametype.integer == GT_SIEGE {
        if client!.tempSpectate >= level.time && team == TEAM_SPECTATOR {
            //sorry, can't do that.
            return
        }

        client!.sess.siegeDesiredTeam = team
        //oh well, just let them go.
        /*
        if (team != TEAM_SPECTATOR)
        { //can't switch to anything in siege unless you want to switch to being a fulltime spectator
        //fill them in on their objectives for this team now
        trap_SendServerCommand(ent-g_entities, va("sb %i", client->sess.siegeDesiredTeam));

        trap_SendServerCommand( ent-g_entities, va("print \"You will be on the selected team the next time the round begins.\n\"") );
        return;
        }
        */
        if client!.sess.sessionTeam != TEAM_SPECTATOR && team != TEAM_SPECTATOR {
            //not a spectator now, and not switching to spec, so you have to wait til you die.
            //trap_SendServerCommand( ent-g_entities, va("print \"You will be on the selected team the next time you respawn.\n\"") );
            let doBegin: Bool
            if ent.client!.tempSpectate >= level.time {
                doBegin = false
            } else {
                doBegin = true
            }

            if doBegin {
                // Kill them so they automatically respawn in the team they wanted.
                if ent.health > 0 {
                    ent.flags &= ~FL_GODMODE
                    ent.health = 0
                    ent.client!.ps.stats[STAT_HEALTH] = ent.health
                    player_die(ent, ent, ent, 100000, MOD_TEAM_CHANGE)
                }
            }

            if ent.client!.sess.sessionTeam != ent.client!.sess.siegeDesiredTeam {
                SetTeamQuick(ent, ent.client!.sess.siegeDesiredTeam, false)
            }

            return
        }
    }

    // override decision if limiting the players
    if (g_gametype.integer == GT_DUEL) && level.numNonSpectatorClients >= 2 {
        team = TEAM_SPECTATOR
    } else if (g_gametype.integer == GT_POWERDUEL) && (level.numPlayingClients >= 3 || G_PowerDuelCheckFail(ent)) {
        team = TEAM_SPECTATOR
    } else if g_maxGameClients.integer > 0 && level.numNonSpectatorClients >= g_maxGameClients.integer {
        team = TEAM_SPECTATOR
    }

    //
    // decide if we will allow the change
    //
    oldTeam = client!.sess.sessionTeam
    if team == oldTeam && team != TEAM_SPECTATOR {
        return
    }

    //
    // execute the team change
    //

    //If it's siege then show the mission briefing for the team you just joined.
    //	if (g_gametype.integer == GT_SIEGE && team != TEAM_SPECTATOR)
    //	{
    //		trap_SendServerCommand(clientNum, va("sb %i", team));
    //	}

    // if the player was dead leave the body
    if client!.ps.stats[STAT_HEALTH] <= 0 && client!.sess.sessionTeam != TEAM_SPECTATOR {
        MaintainBodyQueue(ent)
    }

    // he starts at 'base'
    client!.pers.teamState.state = TEAM_BEGIN
    if oldTeam != TEAM_SPECTATOR {
        // Kill him (makes sure he loses flags, etc)
        ent.flags &= ~FL_GODMODE
        ent.health = 0
        ent.client!.ps.stats[STAT_HEALTH] = ent.health
        g_dontPenalizeTeam = true
        player_die(ent, ent, ent, 100000, MOD_SUICIDE)
        g_dontPenalizeTeam = false
    }
    // they go to the end of the line for tournements
    if team == TEAM_SPECTATOR {
        if (g_gametype.integer != GT_DUEL) || (oldTeam != TEAM_SPECTATOR) {
            //so you don't get dropped to the bottom of the queue for changing skins, etc.
            client!.sess.spectatorTime = level.time
        }
    }

    client!.sess.sessionTeam = team
    client!.sess.spectatorState = specState
    client!.sess.spectatorClient = specClient

    client!.sess.teamLeader = false
    if team == TEAM_RED || team == TEAM_BLUE {
        teamLeader = TeamLeader(team)
        // if there is no team leader or the team leader is a bot and this client is not a bot
        if teamLeader == -1 || (!((g_entities[clientNum].r.svFlags & SVF_BOT) != 0) && (g_entities[teamLeader].r.svFlags & SVF_BOT) != 0) {
            //SetLeader( team, clientNum );
        }
    }
    // make sure there is a team leader on the team the player came from
    if oldTeam == TEAM_RED || oldTeam == TEAM_BLUE {
        CheckTeamLeader(oldTeam)
    }

    BroadcastTeamChange(client!, oldTeam)

    //make a disappearing effect where they were before teleporting them to the appropriate spawn point,
    //if we were not on the spec team
    if oldTeam != TEAM_SPECTATOR {
        let tent: Entity? = G_TempEntity(client!.ps.origin, EV_PLAYER_TELEPORT_OUT)
        tent!.s.clientNum = clientNum
    }

    // get and distribute relevent paramters
    ClientUserinfoChanged(clientNum)

    if !g_preventTeamBegin {
        ClientBegin(clientNum, false)
    }
}

/**
```
=================
StopFollowing

If the client being followed leaves the game, or you just want to drop
to free floating spectator mode
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1032
func StopFollowing(_ ent: Entity) {
    ent.client!.ps.persistant[PERS_TEAM] = TEAM_SPECTATOR
    ent.client!.sess.sessionTeam = TEAM_SPECTATOR
    ent.client!.sess.spectatorState = SPECTATOR_FREE
    ent.client!.ps.pm_flags &= ~PMF_FOLLOW
    ent.r.svFlags &= ~SVF_BOT
    ent.client!.ps.clientNum = ent.s.number
    ent.client!.ps.weapon = WP_NONE
    ent.client!.ps.m_iVehicleNum = 0
    ent.client!.ps.viewangles[ROLL] = 0.0
    ent.client!.ps.forceHandExtend = HANDEXTEND_NONE
    ent.client!.ps.forceHandExtendTime = 0
    ent.client!.ps.zoomMode = 0
    ent.client!.ps.zoomLocked = 0 != 0
    ent.client!.ps.zoomLockTime = 0
    ent.client!.ps.legsAnim = 0
    ent.client!.ps.legsTimer = 0
    ent.client!.ps.torsoAnim = 0
    ent.client!.ps.torsoTimer = 0
}

/**
```
=================
Cmd_Team_f
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1058
func Cmd_Team_f(_ ent: Entity) {
    let oldTeam: Int32
    var s = CharBuf(1024)

    if trap_Argc() != 2 {
        oldTeam = ent.client!.sess.sessionTeam
        switch oldTeam {
        case TEAM_BLUE:
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "PRINTBLUETEAM")))

        case TEAM_RED:
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "PRINTREDTEAM")))

        case TEAM_FREE:
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "PRINTFREETEAM")))

        case TEAM_SPECTATOR:
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "PRINTSPECTEAM")))

        default:
            break
        }
        return
    }

    if ent.client!.switchTeamTime > level.time {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOSWITCH")))
        return
    }

    if gEscaping {
        return
    }

    // if they are playing a tournement game, count as a loss
    if g_gametype.integer == GT_DUEL && ent.client!.sess.sessionTeam == TEAM_FREE {
        //in a tournament game
        //disallow changing teams
        trap_SendServerCommand(ent.s.number, "print \"Cannot switch teams in Duel\n\"")
        return
        //FIXME: why should this be a loss???
        //ent->client->sess.losses++;
    }

    if g_gametype.integer == GT_POWERDUEL {
        //don't let clients change teams manually at all in powerduel, it will be taken care of through automated stuff
        trap_SendServerCommand(ent.s.number, "print \"Cannot switch teams in Power Duel\n\"")
        return
    }

    strcpy(&s, trap_Argv(1, Int32((s).count)))

    SetTeam(ent, String(s))

    ent.client!.switchTeamTime = level.time + 5000
}

/**
```
=================
Cmd_DuelTeam_f
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1119
func Cmd_DuelTeam_f(_ ent: Entity) {
    var oldTeam: Int32
    var s = CharBuf(1024)

    if g_gametype.integer != GT_POWERDUEL {
        //don't bother doing anything if this is not power duel
        return
    }

    /*
    if (ent->client->sess.sessionTeam != TEAM_SPECTATOR)
    {
    trap_SendServerCommand( ent-g_entities, va("print \"You cannot change your duel team unless you are a spectator.\n\""));
    return;
    }
    */

    if trap_Argc() != 2 {
        //No arg so tell what team we're currently on.
        oldTeam = ent.client!.sess.duelTeam
        switch oldTeam {
        case DUELTEAM_FREE:
            trap_SendServerCommand(ent.s.number, va("print \"None\n\""))

        case DUELTEAM_LONE:
            trap_SendServerCommand(ent.s.number, va("print \"Single\n\""))

        case DUELTEAM_DOUBLE:
            trap_SendServerCommand(ent.s.number, va("print \"Double\n\""))

        default:
            break
        }
        return
    }

    if ent.client!.switchDuelTeamTime > level.time {
        //debounce for changing
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOSWITCH")))
        return
    }

    strcpy(&s, trap_Argv(1, Int32((s).count)))

    oldTeam = ent.client!.sess.duelTeam

    if Q_stricmp(s, "free") == 0 {
        ent.client!.sess.duelTeam = DUELTEAM_FREE
    } else if Q_stricmp(s, "single") == 0 {
        ent.client!.sess.duelTeam = DUELTEAM_LONE
    } else if Q_stricmp(s, "double") == 0 {
        ent.client!.sess.duelTeam = DUELTEAM_DOUBLE
    } else {
        trap_SendServerCommand(ent.s.number, va("print \"'%s' not a valid duel team.\n\"", s))
    }

    if oldTeam == ent.client!.sess.duelTeam {
        //didn't actually change, so don't care.
        return
    }

    if ent.client!.sess.sessionTeam != TEAM_SPECTATOR {
        //ok..die
        let curTeam: Int32 = ent.client!.sess.duelTeam
        ent.client!.sess.duelTeam = oldTeam
        var dir: vec3_t? = nil
        G_Damage(ent, ent, ent, &dir, ent.client!.ps.origin, 99999, DAMAGE_NO_PROTECTION, MOD_SUICIDE)
        ent.client!.sess.duelTeam = curTeam
    }
    //reset wins and losses
    ent.client!.sess.wins = 0
    ent.client!.sess.losses = 0

    //get and distribute relevent paramters
    ClientUserinfoChanged(ent.s.number)

    ent.client!.switchDuelTeamTime = level.time + 5000
}

/// Source: oracle/codemp/game/g_cmds.c:1206
func G_TeamForSiegeClass(_ clName: String) -> Int32 {
    var i: Int32 = 0
    var team: Int32 = SIEGETEAM_TEAM1
    var stm: SiegeTeam? = BG_SiegeFindThemeForTeam(team)
    var scl: SiegeClass?

    if stm == nil {
        return 0
    }

    while team <= SIEGETEAM_TEAM2 {
        scl = stm!.classes[i]

        if scl != nil && !scl!.name.isEmpty {
            if Q_stricmp(clName, scl!.name) == 0 {
                return team
            }
        }

        i += 1
        if i >= MAX_SIEGE_CLASSES || i >= stm!.numClasses {
            if team == SIEGETEAM_TEAM2 {
                break
            }
            team = SIEGETEAM_TEAM2
            stm = BG_SiegeFindThemeForTeam(team)
            i = 0
        }
    }

    return 0
}

/**
```
=================
Cmd_SiegeClass_f
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1251
func Cmd_SiegeClass_f(_ ent: Entity) {
    var className = CharBuf(64)
    var team: Int32 = 0
    let preScore: Int32
    var startedAsSpec: Bool = false

    if g_gametype.integer != GT_SIEGE {
        //classes are only valid for this gametype
        return
    }

    if ent.client == nil {
        return
    }

    if trap_Argc() < 1 {
        return
    }

    if ent.client!.switchClassTime > level.time {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOCLASSSWITCH")))
        return
    }

    if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
        startedAsSpec = true
    }

    strcpy(&className, trap_Argv(1, Int32((className).count)))

    team = G_TeamForSiegeClass(String(className))

    if team == 0 {
        //not a valid class name
        return
    }

    if ent.client!.sess.sessionTeam != team {
        //try changing it then
        g_preventTeamBegin = true
        if team == TEAM_RED {
            SetTeam(ent, "red")
        } else if team == TEAM_BLUE {
            SetTeam(ent, "blue")
        }
        g_preventTeamBegin = false

        if ent.client!.sess.sessionTeam != team {
            //failed, oh well
            if ent.client!.sess.sessionTeam != TEAM_SPECTATOR || ent.client!.sess.siegeDesiredTeam != team {
                trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOCLASSTEAM")))
                return
            }
        }
    }

    //preserve 'is score
    preScore = ent.client!.ps.persistant[PERS_SCORE]

    //Make sure the class is valid for the team
    BG_SiegeCheckClassLegality(team, &className)

    //Set the session data
    strcpy(&ent.client!.sess.siegeClassBuffer, className)

    // get and distribute relevent paramters
    ClientUserinfoChanged(ent.s.number)

    if ent.client!.tempSpectate < level.time {
        // Kill him (makes sure he loses flags, etc)
        if ent.health > 0 && !startedAsSpec {
            ent.flags &= ~FL_GODMODE
            ent.health = 0
            ent.client!.ps.stats[STAT_HEALTH] = ent.health
            player_die(ent, ent, ent, 100000, MOD_SUICIDE)
        }

        if ent.client!.sess.sessionTeam == TEAM_SPECTATOR || startedAsSpec {
            //respawn them instantly.
            ClientBegin(ent.s.number, false)
        }
    }
    //set it back after we do all the stuff
    ent.client!.ps.persistant[PERS_SCORE] = preScore

    ent.client!.switchClassTime = level.time + 5000
}

/**
```
=================
Cmd_ForceChanged_f
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1355
func Cmd_ForceChanged_f(_ ent: Entity) {
    var fpChStr = CharBuf(1024)
    let buf: String
    //	Cmd_Kill_f(ent);
    argCheck: do {
        if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
            //if it's a spec, just make the changes now
            //trap_SendServerCommand( ent-g_entities, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "FORCEAPPLIED")) );
            //No longer print it, as the UI calls this a lot.
            WP_InitForcePowers(ent)
            break argCheck
        }

        buf = G_GetStringEdString("MP_SVGAME", "FORCEPOWERCHANGED")

        strcpy(&fpChStr, buf)

        trap_SendServerCommand(ent.s.number, va("print \"%s%s\n\n\"", S_COLOR_GREEN, fpChStr))

        ent.client!.ps.fd.forceDoInit = 1
    }
    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        //If this is duel, don't even bother changing team in relation to this.
        return
    }

    if trap_Argc() > 1 {
        var arg = CharBuf(1024)

        strcpy(&arg, trap_Argv(1, Int32((arg).count)))

        if arg[0] != 0 {
            //if there's an arg, assume it's a combo team command from the UI.
            Cmd_Team_f(ent)
        }
    }
}

/// Source: oracle/codemp/game/g_cmds.c:1396
func G_SetSaber(_ ent: Entity, _ saberNum: Int32, _ saberName: String, _ siegeOverride: Bool) -> Bool {
    let saberName = CharBuf(saberName)
    var truncSaberName = CharBuf(64)
    var i: Int32 = 0

    if !siegeOverride && g_gametype.integer == GT_SIEGE && ent.client!.siegeClass != -1 && (bgSiegeClasses[ent.client!.siegeClass].saberStance != 0 || !bgSiegeClasses[ent.client!.siegeClass].saber1.isEmpty || !bgSiegeClasses[ent.client!.siegeClass].saber2.isEmpty) {
        //don't let it be changed if the siege class has forced any saber-related things
        return false
    }

    while saberName[i] != 0 && i < 64 - 1 {
        truncSaberName[i] = saberName[i]
        i += 1
    }
    truncSaberName[i] = 0

    if saberNum == 0 && (Q_stricmp("none", truncSaberName) == 0 || Q_stricmp("remove", truncSaberName) == 0) {
        //can't remove saber 0 like this
        strcpy(&truncSaberName, "Kyle")
    }

    //Set the saber with the arg given. If the arg is
    //not a valid sabername defaults will be used.
    WP_SetSaber(ent.s.number, ent.client!.saber, saberNum, String(truncSaberName))

    if ent.client!.saber[0].model.isEmpty {
        //should never happen!
        strcpy(&ent.client!.sess.saberTypeBuffer, "none")
    } else {
        strcpy(&ent.client!.sess.saberTypeBuffer, ent.client!.saber[0].name)
    }

    if ent.client!.saber[1].model.isEmpty {
        strcpy(&ent.client!.sess.saber2TypeBuffer, "none")
    } else {
        strcpy(&ent.client!.sess.saber2TypeBuffer, ent.client!.saber[1].name)
    }

    if !WP_SaberStyleValidForSaber(ent.client!.saber[0], ent.client!.saber[1], ent.client!.ps.saberHolstered, ent.client!.ps.fd.saberAnimLevel) {
        WP_UseFirstValidSaberStyle(ent.client!.saber[0], ent.client!.saber[1], ent.client!.ps.saberHolstered, &ent.client!.ps.fd.saberAnimLevel)
        ent.client!.saberCycleQueue = ent.client!.ps.fd.saberAnimLevel
        ent.client!.ps.fd.saberAnimLevelBase = ent.client!.saberCycleQueue
    }

    return true
}

/**
```
=================
Cmd_Follow_f
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1462
func Cmd_Follow_f(_ ent: Entity) {
    let i: Int32
    var arg = CharBuf(1024)

    if trap_Argc() != 2 {
        if ent.client!.sess.spectatorState == SPECTATOR_FOLLOW {
            StopFollowing(ent)
        }
        return
    }

    strcpy(&arg, trap_Argv(1, Int32((arg).count)))
    i = ClientNumberFromString(ent, &arg)
    if i == -1 {
        return
    }

    // can't follow self
    if level.clientsSlots[i] == ent.client {
        return
    }

    // can't follow another spectator
    if level.clientsSlots[i].sess.sessionTeam == TEAM_SPECTATOR {
        return
    }

    // if they are playing a tournement game, count as a loss
    if (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) && ent.client!.sess.sessionTeam == TEAM_FREE {
        //WTF???
        ent.client!.sess.losses += 1
    }

    // first set them to spectator
    if ent.client!.sess.sessionTeam != TEAM_SPECTATOR {
        SetTeam(ent, "spectator")
    }

    ent.client!.sess.spectatorState = SPECTATOR_FOLLOW
    ent.client!.sess.spectatorClient = i
}

/**
```
=================
Cmd_FollowCycle_f
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1510
func Cmd_FollowCycle_f(_ ent: Entity, _ dir: Int32) {
    var clientnum: Int32
    let original: Int32

    // if they are playing a tournement game, count as a loss
    if (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) && ent.client!.sess.sessionTeam == TEAM_FREE {
        //WTF???
        ent.client!.sess.losses += 1
    }
    // first set them to spectator
    if ent.client!.sess.spectatorState == SPECTATOR_NOT {
        SetTeam(ent, "spectator")
    }

    if dir != 1 && dir != -1 {
        G_Error("Cmd_FollowCycle_f: bad dir %i", dir)
    }

    clientnum = ent.client!.sess.spectatorClient
    original = clientnum
    repeat {
        clientnum += dir
        if clientnum >= level.maxclients {
            clientnum = 0
        }
        if clientnum < 0 {
            clientnum = level.maxclients - 1
        }

        // can only follow connected clients
        if level.clientsSlots[clientnum].pers.connected != CON_CONNECTED {
            continue
        }

        // can't follow another spectator
        if level.clientsSlots[clientnum].sess.sessionTeam == TEAM_SPECTATOR {
            continue
        }

        // this is good, we can use it
        ent.client!.sess.spectatorClient = clientnum
        ent.client!.sess.spectatorState = SPECTATOR_FOLLOW
        return
    } while clientnum != original

    // leave it where it was
}

/// Source: oracle/codemp/game/g_cmds.c:1566
private func G_SayTo(_ ent: Entity, _ other: Entity, _ mode: Int32, _ color: Int32, _ name: String, _ message: String, _ locMsg: String?) {
    if !other.inuse {
        return
    }
    if other.client == nil {
        return
    }
    if other.client!.pers.connected != CON_CONNECTED {
        return
    }
    if mode == SAY_TEAM && !OnSameTeam(ent, other) {
        return
    }
    /*
    // no chatting to players in tournements
    if ( (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL)
    && other->client->sess.sessionTeam == TEAM_FREE
    && ent->client->sess.sessionTeam != TEAM_FREE ) {
    //Hmm, maybe some option to do so if allowed?  Or at least in developer mode...
    return;
    }
    */
    //They've requested I take this out.

    if g_gametype.integer == GT_SIEGE && ent.client != nil && (ent.client!.tempSpectate >= level.time || ent.client!.sess.sessionTeam == TEAM_SPECTATOR) && other.client!.sess.sessionTeam != TEAM_SPECTATOR && other.client!.tempSpectate < level.time {
        //siege temp spectators should not communicate to ingame players
        return
    }

    if locMsg != nil {
        trap_SendServerCommand(other.s.number, va("%s \"%s\" \"%s\" \"%c\" \"%s\"", mode == SAY_TEAM ? "ltchat" : "lchat", name, locMsg!, color, message))
    } else {
        trap_SendServerCommand(other.s.number, va("%s \"%s%c%c%s\"", mode == SAY_TEAM ? "tchat" : "chat", name, Q_COLOR_ESCAPE, color, message))
    }
}

/// Source: oracle/codemp/game/g_cmds.c:1618
func G_Say(_ ent: Entity, _ target: Entity?, _ mode: Int32, _ chatText: String) {
    var j: Int32
    var other: Entity?
    var color: Int32
    var name = CharBuf(64)
    // don't let text be too long for malicious reasons
    var text = CharBuf(150)
    var location = CharBuf(64)
    var locMsg = TextCursor()
    // Raven assigns his own `mode` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var mode = mode

    if g_gametype.integer < GT_TEAM && mode == SAY_TEAM {
        mode = SAY_ALL
    }

    switch mode {
    case SAY_TEAM:
        G_LogPrintf("sayteam: %s: %s\n", ent.client!.pers.netname, chatText)
        if Team_GetLocationMsg(ent, &location, Int32((location).count)) {
            Com_sprintf(&name, Int32((name).count), EC + "(%s%c%c" + EC + ")" + EC + ": ", ent.client!.pers.netname, Q_COLOR_ESCAPE, COLOR_WHITE)
            locMsg = TextCursor(location)
        } else {
            Com_sprintf(&name, Int32((name).count), EC + "(%s%c%c" + EC + ")" + EC + ": ", ent.client!.pers.netname, Q_COLOR_ESCAPE, COLOR_WHITE)
        }
        color = COLOR_CYAN

    case SAY_TELL:
        if target != nil && g_gametype.integer >= GT_TEAM && target!.client!.sess.sessionTeam == ent.client!.sess.sessionTeam && Team_GetLocationMsg(ent, &location, Int32((location).count)) {
            Com_sprintf(&name, Int32((name).count), EC + "[%s%c%c" + EC + "]" + EC + ": ", ent.client!.pers.netname, Q_COLOR_ESCAPE, COLOR_WHITE)
            locMsg = TextCursor(location)
        } else {
            Com_sprintf(&name, Int32((name).count), EC + "[%s%c%c" + EC + "]" + EC + ": ", ent.client!.pers.netname, Q_COLOR_ESCAPE, COLOR_WHITE)
        }
        color = COLOR_MAGENTA

    default:
        G_LogPrintf("say: %s: %s\n", ent.client!.pers.netname, chatText)
        Com_sprintf(&name, Int32((name).count), "%s%c%c" + EC + ": ", ent.client!.pers.netname, Q_COLOR_ESCAPE, COLOR_WHITE)
        color = COLOR_GREEN
    }

    Q_strncpyz(&text, chatText, Int32((text).count))

    if let target {
        G_SayTo(ent, target, mode, color, String(name), String(text), locMsg.isNull ? nil : locMsg.text)
        return
    }

    // echo the text to the console
    if g_dedicated.integer != 0 {
        G_Printf("%s%s\n", name, text)
    }

    // send it to all the apropriate clients
    j = 0
    while j < level.maxclients {
        other = g_entities[j]
        G_SayTo(ent, other!, mode, color, String(name), String(text), locMsg.isNull ? nil : locMsg.text)
        j += 1
    }
}

/**
```
==================
Cmd_Say_f
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1695
private func Cmd_Say_f(_ ent: Entity, _ mode: Int32, _ arg0: Bool) {
    let p: String

    if trap_Argc() < 2 && !arg0 {
        return
    }

    if arg0 {
        p = ConcatArgs(0)
    } else {
        p = ConcatArgs(1)
    }

    G_Say(ent, nil, mode, p)
}

/**
```
==================
Cmd_Tell_f
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1719
private func Cmd_Tell_f(_ ent: Entity) {
    let targetNum: Int32
    var target: Entity?
    let p: String
    var arg = CharBuf(1024)

    if trap_Argc() < 2 {
        return
    }

    strcpy(&arg, trap_Argv(1, Int32((arg).count)))
    targetNum = atoi(arg)
    if targetNum < 0 || targetNum >= level.maxclients {
        return
    }

    target = g_entities[targetNum]
    if target == nil || !target!.inuse || target!.client == nil {
        return
    }

    p = ConcatArgs(2)

    G_LogPrintf("tell: %s to %s: %s\n", ent.client!.pers.netname, target!.client!.pers.netname, p)
    G_Say(ent, target, SAY_TELL, p)
    // don't tell to the player self if it was already directed to this player
    // also don't send the chat back to a bot
    if ent != target && !((ent.r.svFlags & SVF_BOT) != 0) {
        G_Say(ent, ent, SAY_TELL, p)
    }
}

//siege voice command
/// Source: oracle/codemp/game/g_cmds.c:1752
private func Cmd_VoiceCommand_f(_ ent: Entity) {
    var te: Entity?
    var arg = CharBuf(1024)
    let s: String
    var i: Int32 = 0

    if g_gametype.integer < GT_TEAM {
        return
    }

    if trap_Argc() < 2 {
        return
    }

    if ent.client!.sess.sessionTeam == TEAM_SPECTATOR || ent.client!.tempSpectate >= level.time {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOVOICECHATASSPEC")))
        return
    }

    strcpy(&arg, trap_Argv(1, Int32((arg).count)))

    if arg[0] == Int32(ascii: "*") {
        //hmm.. don't expect a * to be prepended already. maybe someone is trying to be sneaky.
        return
    }

    s = va("*%s", arg)

    //now, make sure it's a valid sound to be playing like this.. so people can't go around
    //screaming out death sounds or whatever.
    while i < MAX_CUSTOM_SIEGE_SOUNDS {
        if bg_customSiegeSoundNames[i] == nil {
            break
        }
        if Q_stricmp(bg_customSiegeSoundNames[i], s) == 0 {
            //it matches this one, so it's ok
            break
        }
        i += 1
    }

    if i == MAX_CUSTOM_SIEGE_SOUNDS || bg_customSiegeSoundNames[i] == nil {
        //didn't find it in the list
        return
    }

    te = G_TempEntity(vec3_origin, EV_VOICECMD_SOUND)
    te!.s.groundEntityNum = ent.s.number
    te!.s.eventParm = G_SoundIndex(bg_customSiegeSoundNames[i])
    te!.r.svFlags |= SVF_BROADCAST
}

/// Source: oracle/codemp/game/g_cmds.c:1822
func Cmd_GameCommand_f(_ ent: Entity) {
    let player: Int32
    let order: Int32
    var str = CharBuf(1024)

    strcpy(&str, trap_Argv(1, Int32((str).count)))
    player = atoi(str)
    strcpy(&str, trap_Argv(2, Int32((str).count)))
    order = atoi(str)

    if player < 0 || player >= MAX_CLIENTS {
        return
    }
    // Raven tests `order > gc_orders.count`, so an `order` of 7 reads one past the seven rows and the subscript traps there. Rule 19.
    if order < 0 || order > gc_orders.count {
        return
    }
    G_Say(ent, g_entities[player], SAY_TELL, gc_orders[order])
    G_Say(ent, ent, SAY_TELL, gc_orders[order])
}

/**
```
==================
Cmd_Where_f
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1847
func Cmd_Where_f(_ ent: Entity) {
    trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", vtos(ent.s.origin)))
}

/**
```
==================
G_ClientNumberFromName

Finds the client number of the client with the given name
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1871
func G_ClientNumberFromName(_ name: String) -> Int32 {
    var s2 = CharBuf(1024)
    var n2 = CharBuf(1024)
    var i: Int32
    var clIndex: Int32

    // check for a name match
    var buf = CharBuf(name)
    SanitizeString(&buf, &s2)
    i = 0
    clIndex = 0
    while i < level.numConnectedClients {
        SanitizeString(&level.clientsSlots[clIndex].pers.netnameBuffer, &n2)
        if strcmp(n2, s2) == 0 {
            return i
        }
        i += 1
        clIndex += 1
    }

    return -1
}

/**
```
==================
SanitizeString2

Rich's revised version of SanitizeString
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1899
func SanitizeString2(_ `in`: String, _ out: inout JKAShared.CharBuf) {
    let `in` = CharBuf(`in`)
    var i: Int32 = 0
    var r: Int32 = 0

    while `in`[i] != 0 {
        if i >= MAX_NAME_LENGTH - 1 {
            //the ui truncates the name here..
            break
        }

        if `in`[i] == Int32(ascii: "^") {
            if `in`[i + 1] >= 48 && `in`[i + 1] <= 57 {
                //only skip it if there's a number after it for the color
                i += 2
                continue
            } else {
                //just skip the ^
                i += 1
                continue
            }
        }

        if `in`[i] < 32 {
            i += 1
            continue
        }

        out[r] = `in`[i]
        r += 1
        i += 1
    }
    out[r] = 0
}

/**
```
==================
G_ClientNumberFromStrippedName

Same as above, but strips special characters out of the names before comparing.
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:1946
func G_ClientNumberFromStrippedName(_ name: String) -> Int32 {
    var s2 = CharBuf(1024)
    var n2 = CharBuf(1024)
    var i: Int32
    var clIndex: Int32

    // check for a name match
    SanitizeString2(name, &s2)
    i = 0
    clIndex = 0
    while i < level.numConnectedClients {
        SanitizeString2(level.clientsSlots[clIndex].pers.netname, &n2)
        if strcmp(n2, s2) == 0 {
            return i
        }
        i += 1
        clIndex += 1
    }

    return -1
}

/// Source: oracle/codemp/game/g_cmds.c:1974
func Cmd_CallVote_f(_ ent: Entity) {
    var i: Int32
    var arg1 = CharBuf(1024)
    var arg2 = CharBuf(1024)
    //	int		n = 0;
    //	char*	type = NULL;
    var mapName: String? = nil
    let arenaInfo: String?

    if g_allowVote.integer == 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOVOTE")))
        return
    }

    if level.voteTime != 0 || level.voteExecuteTime >= level.time {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "VOTEINPROGRESS")))
        return
    }
    if ent.client!.pers.voteCount >= MAX_VOTE_COUNT {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "MAXVOTES")))
        return
    }

    if g_gametype.integer != GT_DUEL && g_gametype.integer != GT_POWERDUEL {
        if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOSPECVOTE")))
            return
        }
    }

    // make sure it is a valid command to vote on
    strcpy(&arg1, trap_Argv(1, Int32((arg1).count)))
    strcpy(&arg2, trap_Argv(2, Int32((arg2).count)))

    if strchr(arg1, Int32(ascii: ";")) != nil || strchr(arg2, Int32(ascii: ";")) != nil {
        trap_SendServerCommand(ent.s.number, "print \"Invalid vote string.\n\"")
        return
    }

    if Q_stricmp(arg1, "map_restart") == 0 {
    } else if Q_stricmp(arg1, "nextmap") == 0 {
    } else if Q_stricmp(arg1, "map") == 0 {
    } else if Q_stricmp(arg1, "g_gametype") == 0 {
    } else if Q_stricmp(arg1, "kick") == 0 {
    } else if Q_stricmp(arg1, "clientkick") == 0 {
    } else if Q_stricmp(arg1, "g_doWarmup") == 0 {
    } else if Q_stricmp(arg1, "timelimit") == 0 {
    } else if Q_stricmp(arg1, "fraglimit") == 0 {
    } else {
        trap_SendServerCommand(ent.s.number, "print \"Invalid vote string.\n\"")
        trap_SendServerCommand(ent.s.number, "print \"Vote commands are: map_restart, nextmap, map <mapname>, g_gametype <n>, kick <player>, clientkick <clientnum>, g_doWarmup, timelimit <time>, fraglimit <frags>.\n\"")
        return
    }

    // if there is still a vote to be executed
    if level.voteExecuteTime != 0 {
        level.voteExecuteTime = 0
        trap_SendConsoleCommand(EXEC_APPEND, va("%s\n", level.voteString))
    }

    // special case for g_gametype, check for bad values
    if Q_stricmp(arg1, "g_gametype") == 0 {
        i = atoi(arg2)
        if i == GT_SINGLE_PLAYER || i < GT_FFA || i >= GT_MAX_GAME_TYPE {
            trap_SendServerCommand(ent.s.number, "print \"Invalid gametype.\n\"")
            return
        }

        level.votingGametype = true
        level.votingGametypeTo = i

        Com_sprintf(&level.voteStringBuffer, 1024, "%s %d", arg1, i)
        Com_sprintf(&level.voteDisplayStringBuffer, 1024, "%s %s", arg1, gameNames[i])
    } else if Q_stricmp(arg1, "map") == 0 {
        // special case for map changes, we want to reset the nextmap setting
        // this allows a player to change maps, but not upset the map rotation
        var s = CharBuf(1024)

        if !G_DoesMapSupportGametype(String(arg2), trap_Cvar_VariableIntegerValue("g_gametype")) {
            //trap_SendServerCommand( ent-g_entities, "print \"You can't vote for this map, it isn't supported by the current gametype.\n\"" );
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOVOTE_MAPNOTSUPPORTEDBYGAME")))
            return
        }

        strcpy(&s, trap_Cvar_VariableStringBuffer("nextmap", Int32((s).count)))
        if s[0] != 0 {
            Com_sprintf(&level.voteStringBuffer, 1024, "%s %s; set nextmap \"%s\"", arg1, arg2, s)
        } else {
            Com_sprintf(&level.voteStringBuffer, 1024, "%s %s", arg1, arg2)
        }

        arenaInfo = G_GetArenaInfoByMap(String(arg2))
        if arenaInfo != nil {
            mapName = Info_ValueForKey(arenaInfo!, "longname")
        }

        if mapName == nil || mapName!.isEmpty {
            mapName = "ERROR"
        }

        Com_sprintf(&level.voteDisplayStringBuffer, 1024, "map %s", mapName!)
    } else if Q_stricmp(arg1, "clientkick") == 0 {
        let n: Int32 = atoi(arg2)

        if n < 0 || n >= MAX_CLIENTS {
            trap_SendServerCommand(ent.s.number, va("print \"invalid client number %d.\n\"", n))
            return
        }

        if g_entities[n].client!.pers.connected == CON_DISCONNECTED {
            trap_SendServerCommand(ent.s.number, va("print \"there is no client with the client number %d.\n\"", n))
            return
        }

        Com_sprintf(&level.voteStringBuffer, 1024, "%s %s", arg1, arg2)
        Com_sprintf(&level.voteDisplayStringBuffer, 1024, "kick %s", g_entities[n].client!.pers.netname)
    } else if Q_stricmp(arg1, "kick") == 0 {
        var clientid: Int32 = G_ClientNumberFromName(String(arg2))

        if clientid == -1 {
            clientid = G_ClientNumberFromStrippedName(String(arg2))

            if clientid == -1 {
                trap_SendServerCommand(ent.s.number, va("print \"there is no client named '%s' currently on the server.\n\"", arg2))
                return
            }
        }

        Com_sprintf(&level.voteStringBuffer, 1024, "clientkick %d", clientid)
        Com_sprintf(&level.voteDisplayStringBuffer, 1024, "kick %s", g_entities[clientid].client!.pers.netname)
    } else if Q_stricmp(arg1, "nextmap") == 0 {
        var s = CharBuf(1024)

        strcpy(&s, trap_Cvar_VariableStringBuffer("nextmap", Int32((s).count)))
        if s[0] == 0 {
            trap_SendServerCommand(ent.s.number, "print \"nextmap not set.\n\"")
            return
        }
        SiegeClearSwitchData()
        Com_sprintf(&level.voteStringBuffer, 1024, "vstr nextmap")
        Com_sprintf(&level.voteDisplayStringBuffer, 1024, "%s", level.voteString)
    } else {
        Com_sprintf(&level.voteStringBuffer, 1024, "%s \"%s\"", arg1, arg2)
        Com_sprintf(&level.voteDisplayStringBuffer, 1024, "%s", level.voteString)
    }

    trap_SendServerCommand(-1, va("print \"%s^7 %s\n\"", ent.client!.pers.netname, G_GetStringEdString("MP_SVGAME", "PLCALLEDVOTE")))

    // start the voting, the caller autoamtically votes yes
    level.voteTime = level.time
    level.voteYes = 1
    level.voteNo = 0

    i = 0
    while i < level.maxclients {
        level.clientsSlots[i].mGameFlags &= ~UInt32(bitPattern: PSG_VOTED)
        i += 1
    }
    ent.client!.mGameFlags |= UInt32(bitPattern: PSG_VOTED)

    trap_SetConfigstring(CS_VOTE_TIME, va("%i", level.voteTime))
    trap_SetConfigstring(CS_VOTE_STRING, level.voteDisplayString)
    trap_SetConfigstring(CS_VOTE_YES, va("%i", level.voteYes))
    trap_SetConfigstring(CS_VOTE_NO, va("%i", level.voteNo))
}

/**
```
==================
Cmd_Vote_f
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:2163
func Cmd_Vote_f(_ ent: Entity) {
    var msg = CharBuf(64)

    if level.voteTime == 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOVOTEINPROG")))
        return
    }
    if (ent.client!.mGameFlags & UInt32(bitPattern: PSG_VOTED)) != 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "VOTEALREADY")))
        return
    }
    if g_gametype.integer != GT_DUEL && g_gametype.integer != GT_POWERDUEL {
        if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOVOTEASSPEC")))
            return
        }
    }

    trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "PLVOTECAST")))

    ent.client!.mGameFlags |= UInt32(bitPattern: PSG_VOTED)

    strcpy(&msg, trap_Argv(1, Int32((msg).count)))

    if msg[0] == Int32(ascii: "y") || msg[1] == Int32(ascii: "Y") || msg[1] == Int32(ascii: "1") {
        level.voteYes += 1
        trap_SetConfigstring(CS_VOTE_YES, va("%i", level.voteYes))
    } else {
        level.voteNo += 1
        trap_SetConfigstring(CS_VOTE_NO, va("%i", level.voteNo))
    }

    // a majority will be determined in CheckVote, which will also account
    // for players entering or leaving
}

/**
```
==================
Cmd_CallTeamVote_f
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:2206
func Cmd_CallTeamVote_f(_ ent: Entity) {
    var i: Int32
    var targetClientNum: Int32 = ENTITYNUM_NONE
    let team: Int32
    var cs_offset: Int32
    var arg1 = CharBuf(1024)
    var arg2 = CharBuf(1024)

    if g_gametype.integer < GT_TEAM {
        trap_SendServerCommand(ent.s.number, "print \"Cannot call a team vote in a non-team gametype!\n\"")
        return
    }
    team = ent.client!.sess.sessionTeam
    if team == TEAM_RED {
        cs_offset = 0
    } else if team == TEAM_BLUE {
        cs_offset = 1
    } else {
        trap_SendServerCommand(ent.s.number, "print \"Cannot call a team vote if not on a team!\n\"")
        return
    }

    if g_allowTeamVote.integer == 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOVOTE")))
        return
    }

    if level.teamVoteTime[cs_offset] != 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TEAMVOTEALREADY")))
        return
    }
    if ent.client!.pers.teamVoteCount >= MAX_VOTE_COUNT {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "MAXTEAMVOTES")))
        return
    }
    if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOSPECVOTE")))
        return
    }

    // make sure it is a valid command to vote on
    strcpy(&arg1, trap_Argv(1, Int32((arg1).count)))
    arg2[0] = 0
    i = 2
    while i < trap_Argc() {
        if i > 2 {
            strcat(&arg2, " ")
        }
        strcpy(&arg2, trap_Argv(i, Int32((arg2).count) - strlen(arg2)), at: strlen(arg2))
        i += 1
    }

    if strchr(arg1, Int32(ascii: ";")) != nil || strchr(arg2, Int32(ascii: ";")) != nil {
        trap_SendServerCommand(ent.s.number, "print \"Invalid vote string.\n\"")
        return
    }

    if Q_stricmp(arg1, "leader") == 0 || Q_stricmp(arg1, "kick") == 0 {
        var netname = CharBuf(36)
        var target = CharBuf(36)

        if arg2[0] == 0 {
            targetClientNum = ent.client!.ps.clientNum
        } else {
            // numeric values are just slot numbers
            i = 0
            while i < 3 {
                if arg2[i] == 0 || arg2[i] < Int32(ascii: "0") || arg2[i] > Int32(ascii: "9") {
                    break
                }
                i += 1
            }
            if i >= 3 || arg2[i] == 0 {
                targetClientNum = atoi(arg2)
                if targetClientNum < 0 || targetClientNum >= level.maxclients {
                    trap_SendServerCommand(ent.s.number, va("print \"Bad client slot: %i\n\"", targetClientNum))
                    return
                }

                if !g_entities[targetClientNum].inuse {
                    trap_SendServerCommand(ent.s.number, va("print \"Client %i is not active\n\"", targetClientNum))
                    return
                }
            } else {
                Q_strncpyz(&target, String(arg2), Int32((target).count))
                Q_CleanStr(&target)
                i = 0
                while i < level.maxclients {
                    if level.clientsSlots[i].pers.connected == CON_DISCONNECTED {
                        i += 1
                        continue
                    }
                    if level.clientsSlots[i].sess.sessionTeam != team {
                        i += 1
                        continue
                    }
                    Q_strncpyz(&netname, level.clientsSlots[i].pers.netname, Int32((netname).count))
                    Q_CleanStr(&netname)
                    if Q_stricmp(netname, target) == 0 {
                        targetClientNum = i
                        break
                    }
                    i += 1
                }
                if targetClientNum >= level.maxclients {
                    trap_SendServerCommand(ent.s.number, va("print \"%s is not a valid player on your team.\n\"", arg2))
                    return
                }
            }
        }
        if targetClientNum >= MAX_CLIENTS {
            //wtf?
            trap_SendServerCommand(ent.s.number, va("print \"%s is not a valid player on your team.\n\"", arg2))
            return
        }
        if level.clientsSlots[targetClientNum].sess.sessionTeam != ent.client!.sess.sessionTeam {
            //can't call a team vote on someone not on your team!
            trap_SendServerCommand(ent.s.number, va("print \"Cannot call a team vote on someone not on your team (%s).\n\"", level.clientsSlots[targetClientNum].pers.netname))
            return
        }
        //just use the client number
        Com_sprintf(&arg2, Int32((arg2).count), "%d", targetClientNum)
    } else {
        trap_SendServerCommand(ent.s.number, "print \"Invalid vote string.\n\"")
        trap_SendServerCommand(ent.s.number, "print \"Team vote commands are: leader <player on your team> OR kick <player on your team>.\n\"")
        return
    }

    if Q_stricmp("kick", arg1) == 0 {
        //use clientkick and number (so they can't change their name)
        var teamVoteString = CharBuf(1024)
        Com_sprintf(&teamVoteString, 1024, "clientkick %s", arg2)
        level.teamVoteString[cs_offset] = String(teamVoteString)
    } else {
        //just a number
        var teamVoteString = CharBuf(1024)
        Com_sprintf(&teamVoteString, 1024, "%s %s", arg1, arg2)
        level.teamVoteString[cs_offset] = String(teamVoteString)
    }

    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].pers.connected == CON_DISCONNECTED {
            i += 1
            continue
        }
        if level.clientsSlots[i].sess.sessionTeam == team {
            trap_SendServerCommand(i, va("print \"%s called a team vote.\n\"", ent.client!.pers.netname))
        }
        i += 1
    }

    // start the voting, the caller autoamtically votes yes
    level.teamVoteTime[cs_offset] = level.time
    level.teamVoteYes[cs_offset] = 1
    level.teamVoteNo[cs_offset] = 0

    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].sess.sessionTeam == team {
            level.clientsSlots[i].mGameFlags &= ~UInt32(bitPattern: PSG_TEAMVOTED)
        }
        i += 1
    }
    ent.client!.mGameFlags |= UInt32(bitPattern: PSG_TEAMVOTED)

    /*
    if ( !Q_stricmp( "kick", arg1 ) )
    {//if you're voting to kick somebody, make them auto-vote yes
    level.clients[targetClientNum].mGameFlags |= PSG_TEAMVOTED;
    level.teamVoteYes[cs_offset]++;
    }
    */

    trap_SetConfigstring(CS_TEAMVOTE_TIME + cs_offset, va("%i", level.teamVoteTime[cs_offset]))
    trap_SetConfigstring(CS_TEAMVOTE_STRING + cs_offset, level.teamVoteString[cs_offset])
    trap_SetConfigstring(CS_TEAMVOTE_YES + cs_offset, va("%i", level.teamVoteYes[cs_offset]))
    trap_SetConfigstring(CS_TEAMVOTE_NO + cs_offset, va("%i", level.teamVoteNo[cs_offset]))
}

/**
```
==================
Cmd_TeamVote_f
==================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:2370
func Cmd_TeamVote_f(_ ent: Entity) {
    let team: Int32
    var cs_offset: Int32
    var msg = CharBuf(64)

    team = ent.client!.sess.sessionTeam
    if team == TEAM_RED {
        cs_offset = 0
    } else if team == TEAM_BLUE {
        cs_offset = 1
    } else {
        return
    }

    if level.teamVoteTime[cs_offset] == 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOTEAMVOTEINPROG")))
        return
    }
    if (ent.client!.mGameFlags & UInt32(bitPattern: PSG_TEAMVOTED)) != 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TEAMVOTEALREADYCAST")))
        return
    }
    if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOVOTEASSPEC")))
        return
    }

    trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "PLTEAMVOTECAST")))

    ent.client!.mGameFlags |= UInt32(bitPattern: PSG_TEAMVOTED)

    strcpy(&msg, trap_Argv(1, Int32((msg).count)))

    if msg[0] == Int32(ascii: "y") || msg[1] == Int32(ascii: "Y") || msg[1] == Int32(ascii: "1") {
        level.teamVoteYes[cs_offset] += 1
        trap_SetConfigstring(CS_TEAMVOTE_YES + cs_offset, va("%i", level.teamVoteYes[cs_offset]))
    } else {
        level.teamVoteNo[cs_offset] += 1
        trap_SetConfigstring(CS_TEAMVOTE_NO + cs_offset, va("%i", level.teamVoteNo[cs_offset]))
    }

    // a majority will be determined in TeamCheckVote, which will also account
    // for players entering or leaving
}

/**
```
=================
Cmd_SetViewpos_f
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:2419
func Cmd_SetViewpos_f(_ ent: Entity) {
    var origin = vec3_t()
    var angles = vec3_t()
    var buffer = CharBuf(1024)
    var i: Int32

    if g_cheats.integer == 0 {
        trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NOCHEATS")))
        return
    }
    if trap_Argc() != 5 {
        trap_SendServerCommand(ent.s.number, va("print \"usage: setviewpos x y z yaw\n\""))
        return
    }

    angles = vec3_t()
    i = 0
    while i < 3 {
        strcpy(&buffer, trap_Argv(i + 1, Int32((buffer).count)))
        origin[i] = Float(atof(buffer))
        i += 1
    }

    strcpy(&buffer, trap_Argv(4, Int32((buffer).count)))
    angles[YAW] = Float(atof(buffer))

    TeleportPlayer(ent, origin, angles)
}

/**
```
=================
Cmd_Stats_f
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:2452
func Cmd_Stats_f(_ ent: Entity) {
    /*
    int max, n, i;

    max = trap_AAS_PointReachabilityAreaIndex( NULL );

    n = 0;
    for ( i = 0; i < max; i++ ) {
    if ( ent->client->areabits[i >> 3] & (1 << (i & 7)) )
    n++;
    }

    //trap_SendServerCommand( ent-g_entities, va("print \"visited %d of %d areas\n\"", n, max));
    trap_SendServerCommand( ent-g_entities, va("print \"%d%% level coverage\n\"", n * 100 / max));
    */
}

/// Source: oracle/codemp/game/g_cmds.c:2469
func G_ItemUsable(_ ps: JKAMP.PlayerState, _ forcedUse: Int32) -> Int32 {
    var fwd = vec3_t()
    var fwdorg = vec3_t()
    var dest = vec3_t()
    var pos = vec3_t()
    var yawonly = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    var trtest = vec3_t()
    // Raven assigns his own `forcedUse` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var forcedUse = forcedUse
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        if ps.m_iVehicleNum != 0 {
            return 0
        }

        if (ps.pm_flags & PMF_USE_ITEM_HELD) != 0 {
            //force to let go first
            return 0
        }

        if forcedUse == 0 {
            forcedUse = bg_itemlist[ps.stats[STAT_HOLDABLE_ITEM]].giTag
        }

        if !BG_IsItemSelectable(ps, forcedUse) {
            return 0
        }

        switch forcedUse {
        case HI_MEDPAC, HI_MEDPAC_BIG:
            if ps.stats[STAT_HEALTH] >= ps.stats[STAT_MAX_HEALTH] {
                return 0
            }

            if ps.stats[STAT_HEALTH] <= 0 {
                return 0
            }

            return 1

        case HI_SEEKER:
            if (ps.eFlags & EF_SEEKERDRONE) != 0 {
                G_AddEvent(g_entities[ps.clientNum], EV_ITEMUSEFAIL, SEEKER_ALREADYDEPLOYED)
                return 0
            }

            return 1

        case HI_SENTRY_GUN:
            if ps.fd.sentryDeployed {
                G_AddEvent(g_entities[ps.clientNum], EV_ITEMUSEFAIL, SENTRY_ALREADYPLACED)
                return 0
            }

            yawonly[ROLL] = 0
            yawonly[PITCH] = 0
            yawonly[YAW] = ps.viewangles[YAW]

            mins = vec3_t(-8, -8, 0)
            maxs = vec3_t(8, 8, 24)

            // Raven passes NULL for the `right` and `up` outputs, and the scratch locals take the writes.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(yawonly, &fwd, &scratchRight, &scratchUp)

            fwdorg[0] = ps.origin[0] + fwd[0] * 64
            fwdorg[1] = ps.origin[1] + fwd[1] * 64
            fwdorg[2] = ps.origin[2] + fwd[2] * 64

            trtest[0] = fwdorg[0] + fwd[0] * 16
            trtest[1] = fwdorg[1] + fwd[1] * 16
            trtest[2] = fwdorg[2] + fwd[2] * 16

            trap_Trace(tr, ps.origin, mins, maxs, trtest, ps.clientNum, MASK_PLAYERSOLID)

            if (tr.fraction != 1 && tr.entityNum != ps.clientNum) || tr.startsolid != 0 || tr.allsolid != 0 {
                G_AddEvent(g_entities[ps.clientNum], EV_ITEMUSEFAIL, SENTRY_NOROOM)
                return 0
            }

            return 1

        case HI_SHIELD:
            mins[0] = -8
            mins[1] = -8
            mins[2] = 0

            maxs[0] = 8
            maxs[1] = 8
            maxs[2] = 8

            // Raven passes NULL for the `right` and `up` outputs, and the scratch locals take the writes.
            var scratchRight2 = vec3_t()
            var scratchUp2 = vec3_t()
            AngleVectors(ps.viewangles, &fwd, &scratchRight2, &scratchUp2)
            fwd[2] = 0
            _VectorMA(ps.origin, 64, fwd, &dest)
            trap_Trace(tr, ps.origin, mins, maxs, dest, ps.clientNum, MASK_SHOT)
            if Double(tr.fraction) > 0.9 && tr.startsolid == 0 && tr.allsolid == 0 {
                pos = tr.endpos
                dest = vec3_t(pos[0], pos[1], pos[2] - 4096)
                trap_Trace(tr, pos, mins, maxs, dest, ps.clientNum, MASK_SOLID)
                if tr.startsolid == 0 && tr.allsolid == 0 {
                    return 1
                }
            }
            G_AddEvent(g_entities[ps.clientNum], EV_ITEMUSEFAIL, SHIELD_NOROOM)
            return 0

        case HI_JETPACK:
            return 1

        case HI_HEALTHDISP:
            return 1

        case HI_AMMODISP:
            return 1

        case HI_EWEB:
            return 1

        case HI_CLOAK:
            return 1

        default:
            return 1
        }
    }
}

/// Source: oracle/codemp/game/g_cmds.c:2595
func Cmd_ToggleSaber_f(_ ent: Entity) {
    if ent.client!.ps.fd.forceGripCripple != 0 {
        //if they are being gripped, don't let them unholster their saber
        if ent.client!.ps.saberHolstered != 0 {
            return
        }
    }

    if ent.client!.ps.saberInFlight {
        if ent.client!.ps.saberEntityNum != 0 {
            //turn it off in midair
            saberKnockDown(g_entities[ent.client!.ps.saberEntityNum], ent, ent)
        }
        return
    }

    if ent.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        return
    }

    if ent.client!.ps.weapon != WP_SABER {
        return
    }

    //	if (ent->client->ps.duelInProgress && !ent->client->ps.saberHolstered)
    //	{
    //		return;
    //	}

    if ent.client!.ps.duelTime >= level.time {
        return
    }

    if ent.client!.ps.saberLockTime >= level.time {
        return
    }

    if ent.client != nil && ent.client!.ps.weaponTime < 1 {
        if ent.client!.ps.saberHolstered == 2 {
            ent.client!.ps.saberHolstered = 0

            if ent.client!.saber[0].soundOn != 0 {
                G_Sound(ent, CHAN_AUTO, ent.client!.saber[0].soundOn)
            }
            if ent.client!.saber[1].soundOn != 0 {
                G_Sound(ent, CHAN_AUTO, ent.client!.saber[1].soundOn)
            }
        } else {
            ent.client!.ps.saberHolstered = 2
            if ent.client!.saber[0].soundOff != 0 {
                G_Sound(ent, CHAN_AUTO, ent.client!.saber[0].soundOff)
            }
            if ent.client!.saber[1].soundOff != 0 && !ent.client!.saber[1].model.isEmpty {
                G_Sound(ent, CHAN_AUTO, ent.client!.saber[1].soundOff)
            }
            //prevent anything from being done for 400ms after holster
            ent.client!.ps.weaponTime = 400
        }
    }
}

/// Source: oracle/codemp/game/g_cmds.c:2675
func Cmd_SaberAttackCycle_f(_ ent: Entity) {
    var selectLevel: Int32 = 0
    var usingSiegeStyle: Bool = false

    if ent.client == nil {
        return
    }
    /*
    if (ent->client->ps.weaponTime > 0)
    { //no switching attack level when busy
    return;
    }
    */

    if !ent.client!.saber[0].model.isEmpty && !ent.client!.saber[1].model.isEmpty {
        //no cycling for akimbo
        if WP_SaberCanTurnOffSomeBlades(ent.client!.saber[1]) {
            //can turn second saber off
            if ent.client!.ps.saberHolstered == 1 {
                //have one holstered
                //unholster it
                G_Sound(ent, CHAN_AUTO, ent.client!.saber[1].soundOn)
                ent.client!.ps.saberHolstered = 0
                //g_active should take care of this, but...
                ent.client!.ps.fd.saberAnimLevel = SS_DUAL
            } else if ent.client!.ps.saberHolstered == 0 {
                //have none holstered
                if (ent.client!.saber[1].saberFlags2 & SFL2_NO_MANUAL_DEACTIVATE) != 0 {
                    //can't turn it off manually
                } else if ent.client!.saber[1].bladeStyle2Start > 0 && (ent.client!.saber[1].saberFlags2 & SFL2_NO_MANUAL_DEACTIVATE2) != 0 {
                    //can't turn it off manually
                } else {
                    //turn it off
                    G_Sound(ent, CHAN_AUTO, ent.client!.saber[1].soundOff)
                    ent.client!.ps.saberHolstered = 1
                    //g_active should take care of this, but...
                    ent.client!.ps.fd.saberAnimLevel = SS_FAST
                }
            }

            if d_saberStanceDebug.integer != 0 {
                trap_SendServerCommand(ent.s.number, va("print \"SABERSTANCEDEBUG: Attempted to toggle dual saber blade.\n\""))
            }
            return
        }
    } else if ent.client!.saber[0].numBlades > 1 && WP_SaberCanTurnOffSomeBlades(ent.client!.saber[0]) {
        //use staff stance then.
        if ent.client!.ps.saberHolstered == 1 {
            //second blade off
            if ent.client!.ps.saberInFlight {
                //can't turn second blade back on if it's in the air, you naughty boy!
                if d_saberStanceDebug.integer != 0 {
                    trap_SendServerCommand(ent.s.number, va("print \"SABERSTANCEDEBUG: Attempted to toggle staff blade in air.\n\""))
                }
                return
            }
            //turn it on
            G_Sound(ent, CHAN_AUTO, ent.client!.saber[0].soundOn)
            ent.client!.ps.saberHolstered = 0
            //g_active should take care of this, but...
            if ent.client!.saber[0].stylesForbidden != 0 {
                //have a style we have to use
                WP_UseFirstValidSaberStyle(ent.client!.saber[0], ent.client!.saber[1], ent.client!.ps.saberHolstered, &selectLevel)
                if ent.client!.ps.weaponTime <= 0 {
                    //not busy, set it now
                    ent.client!.ps.fd.saberAnimLevel = selectLevel
                } else {
                    //can't set it now or we might cause unexpected chaining, so queue it
                    ent.client!.saberCycleQueue = selectLevel
                }
            }
        } else if ent.client!.ps.saberHolstered == 0 {
            //both blades on
            if (ent.client!.saber[0].saberFlags2 & SFL2_NO_MANUAL_DEACTIVATE) != 0 {
                //can't turn it off manually
            } else if ent.client!.saber[0].bladeStyle2Start > 0 && (ent.client!.saber[0].saberFlags2 & SFL2_NO_MANUAL_DEACTIVATE2) != 0 {
                //can't turn it off manually
            } else {
                //turn second one off
                G_Sound(ent, CHAN_AUTO, ent.client!.saber[0].soundOff)
                ent.client!.ps.saberHolstered = 1
                //g_active should take care of this, but...
                if ent.client!.saber[0].singleBladeStyle != SS_NONE {
                    if ent.client!.ps.weaponTime <= 0 {
                        //not busy, set it now
                        ent.client!.ps.fd.saberAnimLevel = ent.client!.saber[0].singleBladeStyle
                    } else {
                        //can't set it now or we might cause unexpected chaining, so queue it
                        ent.client!.saberCycleQueue = ent.client!.saber[0].singleBladeStyle
                    }
                }
            }
        }
        if d_saberStanceDebug.integer != 0 {
            trap_SendServerCommand(ent.s.number, va("print \"SABERSTANCEDEBUG: Attempted to toggle staff blade.\n\""))
        }
        return
    }

    if ent.client!.saberCycleQueue != 0 {
        //resume off of the queue if we haven't gotten a chance to update it yet
        selectLevel = ent.client!.saberCycleQueue
    } else {
        selectLevel = ent.client!.ps.fd.saberAnimLevel
    }

    if g_gametype.integer == GT_SIEGE && ent.client!.siegeClass != -1 && bgSiegeClasses[ent.client!.siegeClass].saberStance != 0 {
        //we have a flag of useable stances so cycle through it instead
        var i: Int32 = selectLevel + 1

        usingSiegeStyle = true

        while i != selectLevel {
            //cycle around upward til we hit the next style or end up back on this one
            if i >= SS_NUM_SABER_STYLES {
                //loop back around to the first valid
                i = SS_FAST
            }

            if (bgSiegeClasses[ent.client!.siegeClass].saberStance & (1 << i)) != 0 {
                //we can use this one, select it and break out.
                selectLevel = i
                break
            }
            i += 1
        }

        if d_saberStanceDebug.integer != 0 {
            trap_SendServerCommand(ent.s.number, va("print \"SABERSTANCEDEBUG: Attempted to cycle given class stance.\n\""))
        }
    } else {
        selectLevel += 1
        if selectLevel > ent.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] {
            selectLevel = FORCE_LEVEL_1
        }
        if d_saberStanceDebug.integer != 0 {
            trap_SendServerCommand(ent.s.number, va("print \"SABERSTANCEDEBUG: Attempted to cycle stance normally.\n\""))
        }
    }
    /*
    #ifndef FINAL_BUILD
    switch ( selectLevel )
    {
    case FORCE_LEVEL_1:
    trap_SendServerCommand( ent-g_entities, va("print \"Lightsaber Combat Style: %sfast\n\"", S_COLOR_BLUE) );
    break;
    case FORCE_LEVEL_2:
    trap_SendServerCommand( ent-g_entities, va("print \"Lightsaber Combat Style: %smedium\n\"", S_COLOR_YELLOW) );
    break;
    case FORCE_LEVEL_3:
    trap_SendServerCommand( ent-g_entities, va("print \"Lightsaber Combat Style: %sstrong\n\"", S_COLOR_RED) );
    break;
    }
    #endif
    */
    if !usingSiegeStyle {
        //make sure it's valid, change it if not
        WP_UseFirstValidSaberStyle(ent.client!.saber[0], ent.client!.saber[1], ent.client!.ps.saberHolstered, &selectLevel)
    }

    if ent.client!.ps.weaponTime <= 0 {
        //not busy, set it now
        ent.client!.ps.fd.saberAnimLevel = selectLevel
        ent.client!.ps.fd.saberAnimLevelBase = ent.client!.ps.fd.saberAnimLevel
    } else {
        //can't set it now or we might cause unexpected chaining, so queue it
        ent.client!.saberCycleQueue = selectLevel
        ent.client!.ps.fd.saberAnimLevelBase = ent.client!.saberCycleQueue
    }
}

/// Source: oracle/codemp/game/g_cmds.c:2875
func G_OtherPlayersDueling() -> Bool {
    var i: Int32 = 0
    var ent: Entity?

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.inuse && ent!.client != nil && ent!.client!.ps.duelInProgress {
            return true
        }
        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/g_cmds.c:2894
func Cmd_EngageDuel_f(_ ent: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var forward = vec3_t()
        var fwdOrg = vec3_t()

        if g_privateDuel.integer == 0 {
            return true
        }

        if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
            //rather pointless in this mode..
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NODUEL_GAMETYPE")))
            return true
        }

        //if (g_gametype.integer >= GT_TEAM && g_gametype.integer != GT_SIEGE)
        if g_gametype.integer >= GT_TEAM {
            //no private dueling in team modes
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NODUEL_GAMETYPE")))
            return true
        }

        if ent.client!.ps.duelTime >= level.time {
            return true
        }

        if ent.client!.ps.weapon != WP_SABER {
            return true
        }

        /*
        if (!ent->client->ps.saberHolstered)
        { //must have saber holstered at the start of the duel
        return;
        }
        */
        //NOTE: No longer doing this..

        if ent.client!.ps.saberInFlight {
            return true
        }

        if ent.client!.ps.duelInProgress {
            return true
        }

        //New: Don't let a player duel if he just did and hasn't waited 10 seconds yet (note: If someone challenges him, his duel timer will reset so he can accept)
        if ent.client!.ps.fd.privateDuelTime > level.time {
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "CANTDUEL_JUSTDID")))
            return true
        }

        if G_OtherPlayersDueling() {
            trap_SendServerCommand(ent.s.number, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "CANTDUEL_BUSY")))
            return true
        }

        // Raven passes NULL for the `right` and `up` outputs, and the scratch locals take the writes.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(ent.client!.ps.viewangles, &forward, &scratchRight, &scratchUp)

        fwdOrg[0] = ent.client!.ps.origin[0] + forward[0] * 256
        fwdOrg[1] = ent.client!.ps.origin[1] + forward[1] * 256
        fwdOrg[2] = (ent.client!.ps.origin[2] + ent.client!.ps.viewheight) + forward[2] * 256

        trap_Trace(tr, ent.client!.ps.origin, vec3_origin, vec3_origin, fwdOrg, ent.s.number, MASK_PLAYERSOLID)

        if tr.fraction != 1 && tr.entityNum < MAX_CLIENTS {
            let challenged: Entity? = g_entities[tr.entityNum]

            if challenged == nil || challenged!.client == nil || !challenged!.inuse || challenged!.health < 1 || challenged!.client!.ps.stats[STAT_HEALTH] < 1 || challenged!.client!.ps.weapon != WP_SABER || challenged!.client!.ps.duelInProgress || challenged!.client!.ps.saberInFlight {
                return true
            }

            if g_gametype.integer >= GT_TEAM && OnSameTeam(ent, challenged!) {
                return true
            }

            if challenged!.client!.ps.duelIndex == ent.s.number && challenged!.client!.ps.duelTime >= level.time {
                trap_SendServerCommand(/*challenged-g_entities*/ -1, va("print \"%s %s %s!\n\"", challenged!.client!.pers.netname, G_GetStringEdString("MP_SVGAME", "PLDUELACCEPT"), ent.client!.pers.netname))

                ent.client!.ps.duelInProgress = true
                challenged!.client!.ps.duelInProgress = true

                ent.client!.ps.duelTime = level.time + 2000
                challenged!.client!.ps.duelTime = level.time + 2000

                G_AddEvent(ent, EV_PRIVATE_DUEL, 1)
                G_AddEvent(challenged!, EV_PRIVATE_DUEL, 1)

                //Holster their sabers now, until the duel starts (then they'll get auto-turned on to look cool)

                if ent.client!.ps.saberHolstered == 0 {
                    if ent.client!.saber[0].soundOff != 0 {
                        G_Sound(ent, CHAN_AUTO, ent.client!.saber[0].soundOff)
                    }
                    if ent.client!.saber[1].soundOff != 0 && !ent.client!.saber[1].model.isEmpty {
                        G_Sound(ent, CHAN_AUTO, ent.client!.saber[1].soundOff)
                    }
                    ent.client!.ps.weaponTime = 400
                    ent.client!.ps.saberHolstered = 2
                }
                if challenged!.client!.ps.saberHolstered == 0 {
                    if challenged!.client!.saber[0].soundOff != 0 {
                        G_Sound(challenged!, CHAN_AUTO, challenged!.client!.saber[0].soundOff)
                    }
                    if challenged!.client!.saber[1].soundOff != 0 && !challenged!.client!.saber[1].model.isEmpty {
                        G_Sound(challenged!, CHAN_AUTO, challenged!.client!.saber[1].soundOff)
                    }
                    challenged!.client!.ps.weaponTime = 400
                    challenged!.client!.ps.saberHolstered = 2
                }
            } else {
                //Print the message that a player has been challenged in private, only announce the actual duel initiation in private
                trap_SendServerCommand(challenged!.s.number, va("cp \"%s %s\n\"", ent.client!.pers.netname, G_GetStringEdString("MP_SVGAME", "PLDUELCHALLENGE")))
                trap_SendServerCommand(ent.s.number, va("cp \"%s %s\n\"", G_GetStringEdString("MP_SVGAME", "PLDUELCHALLENGED"), challenged!.client!.pers.netname))
            }

            challenged!.client!.ps.fd.privateDuelTime = 0 //reset the timer in case this player just got out of a duel. He should still be able to accept the challenge.

            ent.client!.ps.forceHandExtend = HANDEXTEND_DUELCHALLENGE
            ent.client!.ps.forceHandExtendTime = level.time + 1000

            ent.client!.ps.duelIndex = challenged!.s.number
            ent.client!.ps.duelTime = level.time + 5000
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_cmds.c:3047
func Cmd_DebugSetSaberMove_f(_ `self`: Entity) {
    let argNum: Int32 = trap_Argc()
    var arg = CharBuf(1024)

    if argNum < 2 {
        return
    }

    strcpy(&arg, trap_Argv(1, Int32((arg).count)))

    if arg[0] == 0 {
        return
    }

    `self`.client!.ps.saberMove = atoi(arg)
    `self`.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE

    if `self`.client!.ps.saberMove >= LS_MOVE_MAX {
        `self`.client!.ps.saberMove = LS_MOVE_MAX - 1
    }

    Com_Printf("Anim for move: %s\n", animTable[saberMoveData[`self`.client!.ps.saberMove].animToUse].name!)
}

/// Source: oracle/codemp/game/g_cmds.c:3075
func Cmd_DebugSetBodyAnim_f(_ `self`: Entity, _ flags: Int32) {
    let argNum: Int32 = trap_Argc()
    var arg = CharBuf(1024)
    var i: Int32 = 0

    if argNum < 2 {
        return
    }

    strcpy(&arg, trap_Argv(1, Int32((arg).count)))

    if arg[0] == 0 {
        return
    }

    while i < MAX_ANIMATIONS {
        if Q_stricmp(String(arg), animTable[i].name!) == 0 {
            break
        }
        i += 1
    }

    if i == MAX_ANIMATIONS {
        Com_Printf("Animation '%s' does not exist\n", arg)
        return
    }

    G_SetAnim(`self`, nil, SETANIM_BOTH, i, flags, 0)

    Com_Printf("Set body anim to %s\n", arg)
}

/// Source: oracle/codemp/game/g_cmds.c:3114
func StandardSetBodyAnim(_ `self`: Entity, _ anim: Int32, _ flags: Int32) {
    G_SetAnim(`self`, nil, SETANIM_BOTH, anim, flags, 0)
}

/// Source: oracle/codemp/game/g_cmds.c:3128
private func G_ClientNumFromNetname(_ name: String) -> Int32 {
    var i: Int32 = 0
    var ent: Entity?

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent!.inuse && ent!.client != nil && Q_stricmp(ent!.client!.pers.netname, name) == 0 {
            return ent!.s.number
        }
        i += 1
    }

    return -1
}

/// Source: oracle/codemp/game/g_cmds.c:3148
func TryGrapple(_ ent: Entity) -> Bool {
    if ent.client!.ps.weaponTime > 0 {
        //weapon busy
        return false
    }
    if ent.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        //force power or knockdown or something
        return false
    }
    if ent.client!.grappleState != 0 {
        //already grappling? but weapontime should be > 0 then..
        return false
    }

    if ent.client!.ps.weapon != WP_SABER && ent.client!.ps.weapon != WP_MELEE {
        return false
    }

    if ent.client!.ps.weapon == WP_SABER && ent.client!.ps.saberHolstered == 0 {
        Cmd_ToggleSaber_f(ent)
        if ent.client!.ps.saberHolstered == 0 {
            //must have saber holstered
            return false
        }
    }

    //G_SetAnim(ent, &ent->client->pers.cmd, SETANIM_BOTH, BOTH_KYLE_PA_1, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD, 0);
    G_SetAnim(ent, ent.client!.pers.cmd, SETANIM_BOTH, BOTH_KYLE_GRAB, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
    if ent.client!.ps.torsoAnim == BOTH_KYLE_GRAB {
        //providing the anim set succeeded..
        ent.client!.ps.torsoTimer += 500 //make the hand stick out a little longer than it normally would
        if ent.client!.ps.legsAnim == ent.client!.ps.torsoAnim {
            ent.client!.ps.legsTimer = ent.client!.ps.torsoTimer
        }
        ent.client!.ps.weaponTime = ent.client!.ps.torsoTimer
        return true
    }

    return false
}

/**
```
=================
ClientCommand
=================
```
*/
/// Source: oracle/codemp/game/g_cmds.c:3202
public func ClientCommand(_ clientNum: Int32) {
    var entIndex: Int32 = 0
    var cmd = CharBuf(1024)

    entIndex = clientNum
    if g_entities[entIndex].client == nil {
        return // not fully in game yet
    }


    strcpy(&cmd, trap_Argv(0, Int32((cmd).count)))

    //rww - redirect bot commands
    if strstr(cmd, "bot_") != nil && AcceptBotCommand(String(cmd), g_entities[entIndex]) != 0 {
        return
    }
    //end rww

    if Q_stricmp(cmd, "say") == 0 {
        Cmd_Say_f(g_entities[entIndex], SAY_ALL, false)
        return
    }
    if Q_stricmp(cmd, "say_team") == 0 {
        if g_gametype.integer < GT_TEAM {
            //not a team game, just refer to regular say.
            Cmd_Say_f(g_entities[entIndex], SAY_ALL, false)
        } else {
            Cmd_Say_f(g_entities[entIndex], SAY_TEAM, false)
        }
        return
    }
    if Q_stricmp(cmd, "tell") == 0 {
        Cmd_Tell_f(g_entities[entIndex])
        return
    }

    //note: these voice_cmds come from the ui/jamp/ingame_voicechat.menu menu file...
    //		the strings are in strings/English/menus.str and all start with "VC_"
    if Q_stricmp(cmd, "voice_cmd") == 0 {
        Cmd_VoiceCommand_f(g_entities[entIndex])
        return
    }

    if Q_stricmp(cmd, "score") == 0 {
        Cmd_Score_f(g_entities[entIndex])
        return
    }

    // ignore all other commands when at intermission
    if level.intermissiontime != 0 {
        var giveError: Bool = false
        //rwwFIXMEFIXME: This is terrible, write it differently

        if Q_stricmp(cmd, "give") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "giveother") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "god") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "notarget") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "noclip") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "kill") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "teamtask") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "levelshot") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "follow") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "follownext") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "followprev") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "team") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "duelteam") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "siegeclass") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "forcechanged") == 0 {
            //special case: still update force change
            Cmd_ForceChanged_f(g_entities[entIndex])
            return
        } else if Q_stricmp(cmd, "where") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "callvote") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "vote") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "callteamvote") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "teamvote") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "gc") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "setviewpos") == 0 {
            giveError = true
        } else if Q_stricmp(cmd, "stats") == 0 {
            giveError = true
        }

        if giveError {
            trap_SendServerCommand(clientNum, va("print \"%s (%s) \n\"", G_GetStringEdString("MP_SVGAME", "CANNOT_TASK_INTERMISSION"), cmd))
        } else {
            Cmd_Say_f(g_entities[entIndex], 0, true)
        }
        return
    }

    if Q_stricmp(cmd, "give") == 0 {
        Cmd_Give_f(g_entities[entIndex], 0)
    } else if Q_stricmp(cmd, "giveother") == 0 {
        //for debugging pretty much
        Cmd_Give_f(g_entities[entIndex], 1)
    } else if Q_stricmp(cmd, "t_use") == 0 && CheatsOk(g_entities[entIndex]) {
        //debug use map object
        if trap_Argc() > 1 {
            var sArg = CharBuf(1024)
            var targ: Entity?

            strcpy(&sArg, trap_Argv(1, Int32((sArg).count)))
            targ = G_Find(nil, \.targetname, String(sArg))

            while targ != nil {
                if targ!.use != nil {
                    targ!.runUse(g_entities[entIndex], g_entities[entIndex])
                }
                targ = G_Find(targ, \.targetname, String(sArg))
            }
        }
    } else if Q_stricmp(cmd, "god") == 0 {
        Cmd_God_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "notarget") == 0 {
        Cmd_Notarget_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "noclip") == 0 {
        Cmd_Noclip_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "NPC") == 0 && CheatsOk(g_entities[entIndex]) {
        Cmd_NPC_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "kill") == 0 {
        Cmd_Kill_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "teamtask") == 0 {
        Cmd_TeamTask_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "levelshot") == 0 {
        Cmd_LevelShot_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "follow") == 0 {
        Cmd_Follow_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "follownext") == 0 {
        Cmd_FollowCycle_f(g_entities[entIndex], 1)
    } else if Q_stricmp(cmd, "followprev") == 0 {
        Cmd_FollowCycle_f(g_entities[entIndex], -1)
    } else if Q_stricmp(cmd, "team") == 0 {
        Cmd_Team_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "duelteam") == 0 {
        Cmd_DuelTeam_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "siegeclass") == 0 {
        Cmd_SiegeClass_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "forcechanged") == 0 {
        Cmd_ForceChanged_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "where") == 0 {
        Cmd_Where_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "callvote") == 0 {
        Cmd_CallVote_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "vote") == 0 {
        Cmd_Vote_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "callteamvote") == 0 {
        Cmd_CallTeamVote_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "teamvote") == 0 {
        Cmd_TeamVote_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "gc") == 0 {
        Cmd_GameCommand_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "setviewpos") == 0 {
        Cmd_SetViewpos_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "stats") == 0 {
        Cmd_Stats_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "killother") == 0 && CheatsOk(g_entities[entIndex]) {
        /*
        else if (Q_stricmp (cmd, "kylesmash") == 0)
        {
        TryGrapple(ent);
        }
        */
        //for convenient powerduel testing in release
        if trap_Argc() > 1 {
            var sArg = CharBuf(1024)
            var entNum: Int32 = 0

            strcpy(&sArg, trap_Argv(1, Int32((sArg).count)))

            entNum = G_ClientNumFromNetname(String(sArg))

            if entNum >= 0 && entNum < MAX_GENTITIES {
                let kEnt: Entity? = g_entities[entNum]

                if kEnt!.inuse && kEnt!.client != nil {
                    kEnt!.flags &= ~FL_GODMODE
                    kEnt!.health = -999
                    kEnt!.client!.ps.stats[STAT_HEALTH] = kEnt!.health
                    player_die(kEnt!, kEnt!, kEnt!, 100000, MOD_SUICIDE)
                }
            }
        }
    } else if Q_stricmp(cmd, "thedestroyer") == 0 && CheatsOk(g_entities[entIndex]) && g_entities[entIndex] != nil && g_entities[entIndex].client != nil && g_entities[entIndex].client!.ps.saberHolstered != 0 && g_entities[entIndex].client!.ps.weapon == WP_SABER {
        Cmd_ToggleSaber_f(g_entities[entIndex])

        if g_entities[entIndex].client!.ps.saberHolstered == 0 {
        }
    } else if Q_stricmp(cmd, "debugBMove_Forward") == 0 && CheatsOk(g_entities[entIndex]) {
        //begin bot debug cmds
        let arg: Int32 = 4000
        var bCl: Int32 = 0
        var sarg = CharBuf(1024)

        strcpy(&sarg, trap_Argv(1, Int32((sarg).count)))

        bCl = atoi(sarg)
        Bot_SetForcedMovement(bCl, arg, -1, -1)
    } else if Q_stricmp(cmd, "debugBMove_Back") == 0 && CheatsOk(g_entities[entIndex]) {
        let arg: Int32 = -4000
        var bCl: Int32 = 0
        var sarg = CharBuf(1024)

        strcpy(&sarg, trap_Argv(1, Int32((sarg).count)))

        bCl = atoi(sarg)
        Bot_SetForcedMovement(bCl, arg, -1, -1)
    } else if Q_stricmp(cmd, "debugBMove_Right") == 0 && CheatsOk(g_entities[entIndex]) {
        let arg: Int32 = 4000
        var bCl: Int32 = 0
        var sarg = CharBuf(1024)

        strcpy(&sarg, trap_Argv(1, Int32((sarg).count)))

        bCl = atoi(sarg)
        Bot_SetForcedMovement(bCl, -1, arg, -1)
    } else if Q_stricmp(cmd, "debugBMove_Left") == 0 && CheatsOk(g_entities[entIndex]) {
        let arg: Int32 = -4000
        var bCl: Int32 = 0
        var sarg = CharBuf(1024)

        strcpy(&sarg, trap_Argv(1, Int32((sarg).count)))

        bCl = atoi(sarg)
        Bot_SetForcedMovement(bCl, -1, arg, -1)
    } else if Q_stricmp(cmd, "debugBMove_Up") == 0 && CheatsOk(g_entities[entIndex]) {
        let arg: Int32 = 4000
        var bCl: Int32 = 0
        var sarg = CharBuf(1024)

        strcpy(&sarg, trap_Argv(1, Int32((sarg).count)))

        bCl = atoi(sarg)
        Bot_SetForcedMovement(bCl, -1, -1, arg)
    } else if Q_stricmp(cmd, "debugSetSaberMove") == 0 {
        //end bot debug cmds
        Cmd_DebugSetSaberMove_f(g_entities[entIndex])
    } else if Q_stricmp(cmd, "debugSetBodyAnim") == 0 {
        Cmd_DebugSetBodyAnim_f(g_entities[entIndex], SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    } else if Q_stricmp(cmd, "debugDismemberment") == 0 {
        Cmd_Kill_f(g_entities[entIndex])
        if g_entities[entIndex].health < 1 {
            var arg = CharBuf(1024)
            var iArg: Int32 = 0

            if trap_Argc() > 1 {
                strcpy(&arg, trap_Argv(1, Int32((arg).count)))

                if arg[0] != 0 {
                    iArg = atoi(arg)
                }
            }

            DismembermentByNum(g_entities[entIndex], iArg)
        }
    } else if Q_stricmp(cmd, "debugDropSaber") == 0 {
        if g_entities[entIndex].client!.ps.weapon == WP_SABER && g_entities[entIndex].client!.ps.saberEntityNum != 0 && !g_entities[entIndex].client!.ps.saberInFlight {
            saberKnockOutOfHand(g_entities[g_entities[entIndex].client!.ps.saberEntityNum], g_entities[entIndex], vec3_origin)
        }
    } else if Q_stricmp(cmd, "debugKnockMeDown") == 0 {
        if BG_KnockDownable(g_entities[entIndex].client!.ps) {
            g_entities[entIndex].client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
            g_entities[entIndex].client!.ps.forceDodgeAnim = 0
            if trap_Argc() > 1 {
                g_entities[entIndex].client!.ps.forceHandExtendTime = level.time + 1100
                g_entities[entIndex].client!.ps.quickerGetup = false
            } else {
                g_entities[entIndex].client!.ps.forceHandExtendTime = level.time + 700
                g_entities[entIndex].client!.ps.quickerGetup = true
            }
        }
    } else if Q_stricmp(cmd, "debugSaberSwitch") == 0 {
        var targ: Entity? = nil

        if trap_Argc() > 1 {
            var arg = CharBuf(1024)

            strcpy(&arg, trap_Argv(1, Int32((arg).count)))

            if arg[0] != 0 {
                let x: Int32 = atoi(arg)

                if x >= 0 && x < MAX_CLIENTS {
                    targ = g_entities[x]
                }
            }
        }

        if targ != nil && targ!.inuse && targ!.client != nil {
            Cmd_ToggleSaber_f(targ!)
        }
    } else if Q_stricmp(cmd, "debugIKGrab") == 0 {
        var targ: Entity? = nil

        if trap_Argc() > 1 {
            var arg = CharBuf(1024)

            strcpy(&arg, trap_Argv(1, Int32((arg).count)))

            if arg[0] != 0 {
                let x: Int32 = atoi(arg)

                if x >= 0 && x < MAX_CLIENTS {
                    targ = g_entities[x]
                }
            }
        }

        if targ != nil && targ!.inuse && targ!.client != nil && g_entities[entIndex].s.number != targ!.s.number {
            targ!.client!.ps.heldByClient = g_entities[entIndex].s.number + 1
        }
    } else if Q_stricmp(cmd, "debugIKBeGrabbedBy") == 0 {
        var targ: Entity? = nil

        if trap_Argc() > 1 {
            var arg = CharBuf(1024)

            strcpy(&arg, trap_Argv(1, Int32((arg).count)))

            if arg[0] != 0 {
                let x: Int32 = atoi(arg)

                if x >= 0 && x < MAX_CLIENTS {
                    targ = g_entities[x]
                }
            }
        }

        if targ != nil && targ!.inuse && targ!.client != nil && g_entities[entIndex].s.number != targ!.s.number {
            g_entities[entIndex].client!.ps.heldByClient = targ!.s.number + 1
        }
    } else if Q_stricmp(cmd, "debugIKRelease") == 0 {
        var targ: Entity? = nil

        if trap_Argc() > 1 {
            var arg = CharBuf(1024)

            strcpy(&arg, trap_Argv(1, Int32((arg).count)))

            if arg[0] != 0 {
                let x: Int32 = atoi(arg)

                if x >= 0 && x < MAX_CLIENTS {
                    targ = g_entities[x]
                }
            }
        }

        if targ != nil && targ!.inuse && targ!.client != nil {
            targ!.client!.ps.heldByClient = 0
        }
    } else if Q_stricmp(cmd, "debugThrow") == 0 {
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut = Trace.scratch { tr -> Bool in
            var tTo = vec3_t()
            var fwd = vec3_t()

            if g_entities[entIndex].client!.ps.weaponTime > 0 || g_entities[entIndex].client!.ps.forceHandExtend != HANDEXTEND_NONE || g_entities[entIndex].client!.ps.groundEntityNum == ENTITYNUM_NONE || g_entities[entIndex].health < 1 {
                return true
            }

            // Raven passes NULL for the `right` and `up` outputs, and the scratch locals take the writes.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(g_entities[entIndex].client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)
            tTo[0] = g_entities[entIndex].client!.ps.origin[0] + fwd[0] * 32
            tTo[1] = g_entities[entIndex].client!.ps.origin[1] + fwd[1] * 32
            tTo[2] = g_entities[entIndex].client!.ps.origin[2] + fwd[2] * 32

            trap_Trace(tr, g_entities[entIndex].client!.ps.origin, vec3_origin, vec3_origin, tTo, g_entities[entIndex].s.number, MASK_PLAYERSOLID)

            if tr.fraction != 1 {
                let other: Entity? = g_entities[tr.entityNum]

                if other!.inuse && other!.client != nil && other!.client!.ps.forceHandExtend == HANDEXTEND_NONE && other!.client!.ps.groundEntityNum != ENTITYNUM_NONE && other!.health > 0 && Int32(g_entities[entIndex].client!.ps.origin[2]) == Int32(other!.client!.ps.origin[2]) {
                    let pDif: Float = 40.0
                    var entAngles = vec3_t()
                    var entDir = vec3_t()
                    var otherAngles = vec3_t()
                    var otherDir = vec3_t()
                    var intendedOrigin = vec3_t()
                    var boltOrg = vec3_t()
                    var pBoltOrg = vec3_t()
                    var tAngles = vec3_t()
                    var vDif = vec3_t()
                    var fwd = vec3_t()
                    var right = vec3_t()
                    // Raven's record lives to the end of his block, so the block is the closure.
                    Trace.scratch { tr in
                        // Raven's record lives to the end of his block, so the block is the closure.
                        Trace.scratch { tr2 in

                            otherDir = other!.client!.ps.origin - g_entities[entIndex].client!.ps.origin
                            entAngles = g_entities[entIndex].client!.ps.viewangles
                            entAngles[YAW] = vectoyaw(otherDir)
                            SetClientViewAngle(g_entities[entIndex], entAngles)

                            g_entities[entIndex].client!.ps.forceHandExtend = HANDEXTEND_PRETHROW
                            g_entities[entIndex].client!.ps.forceHandExtendTime = level.time + 5000

                            g_entities[entIndex].client!.throwingIndex = other!.s.number
                            g_entities[entIndex].client!.doingThrow = level.time + 5000
                            g_entities[entIndex].client!.beingThrown = 0

                            entDir = g_entities[entIndex].client!.ps.origin - other!.client!.ps.origin
                            otherAngles = other!.client!.ps.viewangles
                            otherAngles[YAW] = vectoyaw(entDir)
                            SetClientViewAngle(other!, otherAngles)

                            other!.client!.ps.forceHandExtend = HANDEXTEND_PRETHROWN
                            other!.client!.ps.forceHandExtendTime = level.time + 5000

                            other!.client!.throwingIndex = g_entities[entIndex].s.number
                            other!.client!.beingThrown = level.time + 5000
                            other!.client!.doingThrow = 0

                            //Doing this now at a stage in the throw, isntead of initially.
                            //other->client->ps.heldByClient = ent->s.number+1;

                            G_EntitySound(other!, CHAN_VOICE, G_SoundIndex("*pain100.wav"))
                            G_EntitySound(g_entities[entIndex], CHAN_VOICE, G_SoundIndex("*jump1.wav"))
                            G_Sound(other!, CHAN_AUTO, G_SoundIndex("sound/movers/objects/objectHit.wav"))

                            //see if we can move to be next to the hand.. if it's not clear, break the throw.
                            tAngles = vec3_t()
                            tAngles[YAW] = g_entities[entIndex].client!.ps.viewangles[YAW]
                            pBoltOrg = g_entities[entIndex].client!.ps.origin
                            // Raven passes NULL for the `up` output, and the scratch local takes the write.
                            var scratchUp2 = vec3_t()
                            AngleVectors(tAngles, &fwd, &right, &scratchUp2)
                            boltOrg[0] = pBoltOrg[0] + fwd[0] * 8 + right[0] * pDif
                            boltOrg[1] = pBoltOrg[1] + fwd[1] * 8 + right[1] * pDif
                            boltOrg[2] = pBoltOrg[2]

                            vDif = boltOrg - pBoltOrg
                            VectorNormalize(&vDif)

                            other!.client!.ps.velocity = vec3_t()
                            intendedOrigin[0] = pBoltOrg[0] + vDif[0] * pDif
                            intendedOrigin[1] = pBoltOrg[1] + vDif[1] * pDif
                            intendedOrigin[2] = other!.client!.ps.origin[2]

                            trap_Trace(tr, intendedOrigin, other!.r.mins, other!.r.maxs, intendedOrigin, other!.s.number, other!.clipmask)
                            trap_Trace(tr2, g_entities[entIndex].client!.ps.origin, g_entities[entIndex].r.mins, g_entities[entIndex].r.maxs, intendedOrigin, g_entities[entIndex].s.number, CONTENTS_SOLID)

                            if Double(tr.fraction) == 1.0 && tr.startsolid == 0 && Double(tr2.fraction) == 1.0 && tr2.startsolid == 0 {
                                other!.client!.ps.origin = intendedOrigin
                            } else {
                                //if the guy can't be put here then it's time to break the throw off.
                                var oppDir = vec3_t()
                                let strength: Int32 = 4

                                other!.client!.ps.heldByClient = 0
                                other!.client!.beingThrown = 0
                                g_entities[entIndex].client!.doingThrow = 0

                                g_entities[entIndex].client!.ps.forceHandExtend = HANDEXTEND_NONE
                                G_EntitySound(g_entities[entIndex], CHAN_VOICE, G_SoundIndex("*pain25.wav"))

                                other!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                                oppDir = other!.client!.ps.origin - g_entities[entIndex].client!.ps.origin
                                VectorNormalize(&oppDir)
                                other!.client!.ps.velocity[0] = oppDir[0] * (strength * 40)
                                other!.client!.ps.velocity[1] = oppDir[1] * (strength * 40)
                                other!.client!.ps.velocity[2] = 150

                                oppDir = g_entities[entIndex].client!.ps.origin - other!.client!.ps.origin
                                VectorNormalize(&oppDir)
                                g_entities[entIndex].client!.ps.velocity[0] = oppDir[0] * (strength * 40)
                                g_entities[entIndex].client!.ps.velocity[1] = oppDir[1] * (strength * 40)
                                g_entities[entIndex].client!.ps.velocity[2] = 150
                            }
                        }
                    }
                }
            }
            return false
        }
        if earlyOut {
            return
        }
    } else if Q_stricmp(cmd, "debugShipDamage") == 0 {
        //stress it. Yes, this will take a while. If it doesn't explode miserably in the process.
        var arg = CharBuf(1024)
        var arg2 = CharBuf(1024)
        var shipSurf: Int32 = 0
        var damageLevel: Int32 = 0

        strcpy(&arg, trap_Argv(1, Int32((arg).count)))
        strcpy(&arg2, trap_Argv(2, Int32((arg2).count)))
        shipSurf = SHIPSURF_FRONT + atoi(arg)
        damageLevel = atoi(arg2)

        G_SetVehDamageFlags(g_entities[g_entities[entIndex].s.m_iVehicleNum], shipSurf, damageLevel)
    } else {
        if Q_stricmp(cmd, "addbot") == 0 {
            //because addbot isn't a recognized command unless you're the server, but it is in the menus regardless
            //			trap_SendServerCommand( clientNum, va("print \"You can only add bots as the server.\n\"" ) );
            trap_SendServerCommand(clientNum, va("print \"%s.\n\"", G_GetStringEdString("MP_SVGAME", "ONLY_ADD_BOTS_AS_SERVER")))
        } else {
            trap_SendServerCommand(clientNum, va("print \"unknown cmd %s\n\"", cmd))
        }
    }
}
