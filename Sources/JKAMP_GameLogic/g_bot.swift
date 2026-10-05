import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_bot.c:8
var g_numBots: Int32 {
    get { world.variables.g_numBots }
    set { world.variables.g_numBots = newValue }
}

/// Source: oracle/codemp/game/g_bot.c:9
var g_botInfos: [String] {
    get { world.variables.g_botInfos }
    set { world.variables.g_botInfos = newValue }
}

/// Source: oracle/codemp/game/g_bot.c:12
var g_numArenas: Int32 {
    get { world.variables.g_numArenas }
    set { world.variables.g_numArenas = newValue }
}

/// Source: oracle/codemp/game/g_bot.c:13
var g_arenaInfos: [String] {
    get { world.variables.g_arenaInfos }
    set { world.variables.g_arenaInfos = newValue }
}

/// Source: oracle/codemp/game/g_bot.c:16
let BOT_BEGIN_DELAY_BASE = 2000 as Int32

/// Source: oracle/codemp/game/g_bot.c:17
let BOT_BEGIN_DELAY_INCREMENT = 1500 as Int32

/// Source: oracle/codemp/game/g_bot.c:19
let BOT_SPAWN_QUEUE_DEPTH = 16 as Int32

/// Source: oracle/codemp/game/g_bot.c:27
var botSpawnQueue: Slots<BotSpawnQueue> { world.storage.botSpawnQueue }

/// Source: oracle/codemp/game/g_bot.c:29
var bot_minplayers: JKAMP.VmCvar { world.storage.bot_minplayers }

/// Source: oracle/codemp/game/g_bot.c:36
func trap_Cvar_VariableValue(_ var_name: String) -> Float {
    var buf = CharBuf(128)

    strcpy(&buf, trap_Cvar_VariableStringBuffer(var_name, Int32((buf).count)))
    return atof(buf)
}

/**
```
===============
G_ParseInfos
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:50
func G_ParseInfos(_ buf: inout JKAShared.CharBuf, _ max: Int32, _ infos: inout ArraySlice<String>) -> Int32 {
    var token: String
    var count: Int32
    var key = CharBuf(1024)
    var info = CharBuf(1024)

    count = 0

    while 1 != 0 {
        // Port-note: A cast to `const char **` the draft has no view for.
        // Raven wrote: token = COM_Parse( (const char **)(&buf) )
        portMissing("G_ParseInfos", source: "oracle/codemp/game/g_bot.c:50")
        if token.isEmpty {
            break
        }
        if strcmp(token, "{") != 0 {
            Com_Printf("Missing { in info file\n")
            break
        }

        if count == max {
            Com_Printf("Max infos exceeded\n")
            break
        }

        info[0] = 0
        while 1 != 0 {
            // Port-note: A cast to `const char **` the draft has no view for.
            // Raven wrote: token = COM_ParseExt( (const char **)(&buf), qtrue )
            portMissing("G_ParseInfos", source: "oracle/codemp/game/g_bot.c:50")
            if token.isEmpty {
                Com_Printf("Unexpected end of info file\n")
                break
            }
            if strcmp(token, "}") == 0 {
                break
            }
            Q_strncpyz(&key, token, Int32((key).count))

            // Port-note: A cast to `const char **` the draft has no view for.
            // Raven wrote: token = COM_ParseExt( (const char **)(&buf), qfalse )
            portMissing("G_ParseInfos", source: "oracle/codemp/game/g_bot.c:50")
            if token.isEmpty {
                strcpy(&token, "<NULL>")
            }
            Info_SetValueForKey(&info, String(key), token)
        }
        //NOTE: extra space for arena number
        // Port-note: The draft of this statement did not compile, and the compiler wrote "no 'G_Alloc' candidates produce the expected contextual result type 'String'".
        // Raven wrote: infos[count] = (char *) G_Alloc(strlen(info) + strlen("\\num\\") + strlen(va("%d", MAX_ARENAS)) + 1)
        portMissing("G_ParseInfos", source: "oracle/codemp/game/g_bot.c:50")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Int'".
        // Raven wrote: if (infos[count]) { strcpy(infos[count], info); count++; }
        portMissing("G_ParseInfos", source: "oracle/codemp/game/g_bot.c:50")
    }
    return count
}

/**
```
===============
G_LoadArenasFromFile
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:106
private func G_LoadArenasFromFile(_ filename: String) {
    let len: Int32
    var f: fileHandle_t = 0
    var buf = CharBuf(8192)

    len = trap_FS_FOpenFile(filename, &f, FS_READ)
    if f == 0 {
        trap_Printf(va(S_COLOR_RED + "file not found: %s\n", filename))
        return
    }
    if len >= MAX_ARENAS_TEXT {
        trap_Printf(va(S_COLOR_RED + "file too large: %s is %i, max allowed is %i", filename, len, MAX_ARENAS_TEXT))
        trap_FS_FCloseFile(f)
        return
    }

    trap_FS_Read(&buf, len, f)
    buf[len] = 0
    trap_FS_FCloseFile(f)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Range<Int>'".
    // Raven wrote: g_numArenas += G_ParseInfos( buf, MAX_ARENAS - g_numArenas, &g_arenaInfos[g_numArenas] )
    portMissing("G_LoadArenasFromFile", source: "oracle/codemp/game/g_bot.c:106")
}

/// Source: oracle/codemp/game/g_bot.c:129
func G_GetMapTypeBits(_ type: inout JKAShared.CharBuf) -> Int32 {
    var typeBits: Int32 = 0

    // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'".
    // Raven wrote: if( *type ) { if( strstr( type, "ffa" ) ) { typeBits |= (1 << GT_FFA); typeBits |= (1 << GT_TEAM); } if( strstr( type, "team" ) ) { typeBits |= (1 << GT_TEAM); } if( strstr( type, "holocron" ) ) { typeBits |= (1 << GT_HOLOCRON); } if( strstr( type, "jedimaster" ) ) { typeBits |= (1 << GT_JEDIMASTER); } if( strstr( type, "duel" ) ) { typeBits |= (1 << GT_DUEL); typeBits |= (1 << GT_POWERDUEL); } if( strstr( type, "powerduel" ) ) { typeBits |= (1 << GT_DUEL); typeBits |= (1 << GT_POWERDUEL); } if( strstr( type, "siege" ) ) { typeBits |= (1 << GT_SIEGE); } if( strstr( type, "ctf" ) ) { typeBits |= (1 << GT_CTF); } if( strstr( type, "cty" ) ) { typeBits |= (1 << GT_CTY); } } else { typeBits |= (1 << GT_FFA); }
    portMissing("G_GetMapTypeBits", source: "oracle/codemp/game/g_bot.c:129")

    return typeBits
}

/// Source: oracle/codemp/game/g_bot.c:171
func G_DoesMapSupportGametype(_ mapname: String, _ gametype: Int32) -> Bool {
    var typeBits: Int32 = 0
    var thisLevel: Int32 = -1
    var n: Int32 = 0
    var type: String? = nil

    if g_arenaInfos[0] == nil {
        return false
    }

    if mapname.isEmpty {
        return false
    }

    n = 0
    while n < g_numArenas {
        type = Info_ValueForKey(g_arenaInfos[n], "map")

        if Q_stricmp(mapname, type!) == 0 {
            thisLevel = n
            break
        }
        n += 1
    }

    if thisLevel == -1 {
        return false
    }

    type = Info_ValueForKey(g_arenaInfos[thisLevel], "type")

    // Port-note: Raven passes `type` to `G_GetMapTypeBits`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
    // Raven wrote: typeBits = G_GetMapTypeBits(type)
    portMissing("G_DoesMapSupportGametype", source: "oracle/codemp/game/g_bot.c:171")
    if (typeBits & (1 << gametype)) != 0 {
        //the map in question supports the gametype in question, so..
        return true
    }

    return false
}

//rww - auto-obtain nextmap. I could've sworn Q3 had something like this, but I guess not.
/// Source: oracle/codemp/game/g_bot.c:216
func G_RefreshNextMap(_ gametype: Int32, _ forced: Bool) -> String? {
    var typeBits: Int32 = 0
    var thisLevel: Int32 = 0
    var desiredMap: Int32 = 0
    var n: Int32 = 0
    var type: String? = nil
    var loopingUp: Bool = false
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return VmCvar.scratch { mapname -> String? in

        if g_autoMapCycle.integer == 0 && !forced {
            return nil
        }

        if g_arenaInfos[0] == nil {
            return nil
        }

        trap_Cvar_Register(mapname, "mapname", "", CVAR_SERVERINFO | CVAR_ROM)
        n = 0
        while n < g_numArenas {
            type = Info_ValueForKey(g_arenaInfos[n], "map")

            if Q_stricmp(mapname.string, type!) == 0 {
                thisLevel = n
                break
            }
            n += 1
        }

        desiredMap = thisLevel

        n = thisLevel + 1
        while n != thisLevel {
            //now cycle through the arena list and find the next map that matches the gametype we're in
            if g_arenaInfos[n] == nil || n >= g_numArenas {
                if loopingUp {
                    //this shouldn't happen, but if it does we have a null entry break in the arena file
                    //if this is the case just break out of the loop instead of sticking in an infinite loop
                    break
                }
                n = 0
                loopingUp = true
            }

            type = Info_ValueForKey(g_arenaInfos[n], "type")

            // Port-note: Raven passes `type` to `G_GetMapTypeBits`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
            // Raven wrote: typeBits = G_GetMapTypeBits(type)
            portMissing("G_RefreshNextMap", source: "oracle/codemp/game/g_bot.c:216")
            if (typeBits & (1 << gametype)) != 0 {
                desiredMap = n
                break
            }

            n += 1
        }

        if desiredMap == thisLevel {
            //If this is the only level for this game mode or we just can't find a map for this game mode, then nextmap
            //will always restart.
            trap_Cvar_Set("nextmap", "map_restart 0")
        } else {
            //otherwise we have a valid nextmap to cycle to, so use it.
            type = Info_ValueForKey(g_arenaInfos[desiredMap], "map")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot force unwrap value of non-optional type 'String'".
            // Raven wrote: trap_Cvar_Set( "nextmap", va("map %s", type))
            portMissing("G_RefreshNextMap", source: "oracle/codemp/game/g_bot.c:216")
        }

        return Info_ValueForKey(g_arenaInfos[desiredMap], "map")
    }
}

/**
```
===============
G_LoadArenas
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:295
private func G_LoadArenas() {
    let numdirs: Int32
    var filename = CharBuf(128)
    var dirlist = CharBuf(1024)
    var dirptr = TextCursor()
    var i: Int32
    var n: Int32
    var dirlen: Int32

    g_numArenas = 0

    // get all arenas from .arena files
    let filled = trap_FS_GetFileList("scripts", ".arena", 1024)
    numdirs = filled.0
    dirlist = filled.1
    dirptr = TextCursor(dirlist)
    i = 0
    while i < numdirs {
        dirlen = strlen(dirptr.text)
        strcpy(&filename, "scripts/")
        strcat(&filename, dirptr.text)
        G_LoadArenasFromFile(String(filename))
        i += 1
        dirptr.advance(by: dirlen + 1)
    }
    //	trap_Printf( va( "%i arenas parsed\n", g_numArenas ) );

    n = 0
    while n < g_numArenas {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs)".
        // Raven wrote: Info_SetValueForKey( g_arenaInfos[n], "num", va( "%i", n ) )
        portMissing("G_LoadArenas", source: "oracle/codemp/game/g_bot.c:295")
        n += 1
    }

    G_RefreshNextMap(g_gametype.integer, false)
}

/**
```
===============
G_GetArenaInfoByNumber
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:329
func G_GetArenaInfoByMap(_ map: String) -> String? {
    var n: Int32

    n = 0
    while n < g_numArenas {
        if Q_stricmp(Info_ValueForKey(g_arenaInfos[n], "map"), map) == 0 {
            return g_arenaInfos[n]
        }
        n += 1
    }

    return nil
}

/**
```
===============
G_AddRandomBot
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:373
func G_AddRandomBot(_ team: Int32) {
    var i: Int32
    var n: Int32
    var num: Int32
    var skill: Float
    var value: String
    var netname = CharBuf(36)
    var teamstr: String
    var cl: Client?

    num = 0
    n = 0
    while n < g_numBots {
        value = Info_ValueForKey(g_botInfos[n], "name")
        //
        i = 0
        while i < g_maxclients.integer {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '+' cannot be applied to operands of type 'Client?' and 'Int32'".
            // Raven wrote: cl = level.clients + i
            portMissing("G_AddRandomBot", source: "oracle/codemp/game/g_bot.c:373")
            if cl!.pers.connected != CON_CONNECTED {
                i += 1
                continue
            }
            if !((g_entities[cl!.ps.clientNum].r.svFlags & SVF_BOT) != 0) {
                i += 1
                continue
            }
            if g_gametype.integer == GT_SIEGE {
                if team >= 0 && cl!.sess.siegeDesiredTeam != team {
                    i += 1
                    continue
                }
            } else {
                if team >= 0 && cl!.sess.sessionTeam != team {
                    i += 1
                    continue
                }
            }
            if Q_stricmp(value, cl!.pers.netname) == 0 {
                break
            }
            i += 1
        }
        if i >= g_maxclients.integer {
            num += 1
        }
        n += 1
    }
    // The SDK also declares `random`, so the call names the bg module.
    num = Int32(JKAMP_BG.random() * num)
    n = 0
    while n < g_numBots {
        value = Info_ValueForKey(g_botInfos[n], "name")
        //
        i = 0
        while i < g_maxclients.integer {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '+' cannot be applied to operands of type 'Client?' and 'Int32'".
            // Raven wrote: cl = level.clients + i
            portMissing("G_AddRandomBot", source: "oracle/codemp/game/g_bot.c:373")
            if cl!.pers.connected != CON_CONNECTED {
                i += 1
                continue
            }
            if !((g_entities[cl!.ps.clientNum].r.svFlags & SVF_BOT) != 0) {
                i += 1
                continue
            }
            if g_gametype.integer == GT_SIEGE {
                if team >= 0 && cl!.sess.siegeDesiredTeam != team {
                    i += 1
                    continue
                }
            } else {
                if team >= 0 && cl!.sess.sessionTeam != team {
                    i += 1
                    continue
                }
            }
            if Q_stricmp(value, cl!.pers.netname) == 0 {
                break
            }
            i += 1
        }
        if i >= g_maxclients.integer {
            num -= 1
            if num <= 0 {
                skill = trap_Cvar_VariableValue("g_spSkill")
                if team == TEAM_RED {
                    teamstr = "red"
                } else if team == TEAM_BLUE {
                    teamstr = "blue"
                } else {
                    teamstr = ""
                }
                strncpy(&netname, value, Int32((netname).count) - 1)
                netname[Int32((netname).count) - 1] = 0
                Q_CleanStr(&netname)
                trap_SendConsoleCommand(EXEC_INSERT, va("addbot \"%s\" %f %s %i\n", netname, skill, teamstr, 0))
                return
            }
        }
        n += 1
    }
}

/**
```
===============
G_RemoveRandomBot
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:461
func G_RemoveRandomBot(_ team: Int32) -> Int32 {
    var i: Int32
    var netname = CharBuf(36)
    var cl: Client?

    i = 0
    while i < g_maxclients.integer {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '+' cannot be applied to operands of type 'Client?' and 'Int32'".
        // Raven wrote: cl = level.clients + i
        portMissing("G_RemoveRandomBot", source: "oracle/codemp/game/g_bot.c:461")
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        if !((g_entities[cl!.ps.clientNum].r.svFlags & SVF_BOT) != 0) {
            i += 1
            continue
        }
        if g_gametype.integer == GT_SIEGE {
            if team >= 0 && cl!.sess.siegeDesiredTeam != team {
                i += 1
                continue
            }
        } else {
            if team >= 0 && cl!.sess.sessionTeam != team {
                i += 1
                continue
            }
        }
        strcpy(&netname, cl!.pers.netname)
        Q_CleanStr(&netname)
        trap_SendConsoleCommand(EXEC_INSERT, va("kick \"%s\"\n", netname))
        return 1
        i += 1
    }
    return 0
}

/**
```
===============
G_CountHumanPlayers
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:499
func G_CountHumanPlayers(_ team: Int32) -> Int32 {
    var i: Int32
    var num: Int32
    var cl: Client?

    num = 0
    i = 0
    while i < g_maxclients.integer {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '+' cannot be applied to operands of type 'Client?' and 'Int32'".
        // Raven wrote: cl = level.clients + i
        portMissing("G_CountHumanPlayers", source: "oracle/codemp/game/g_bot.c:499")
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        if (g_entities[cl!.ps.clientNum].r.svFlags & SVF_BOT) != 0 {
            i += 1
            continue
        }
        if team >= 0 && cl!.sess.sessionTeam != team {
            i += 1
            continue
        }
        num += 1
        i += 1
    }
    return num
}

/**
```
===============
G_CountBotPlayers
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:525
func G_CountBotPlayers(_ team: Int32) -> Int32 {
    var i: Int32
    var n: Int32
    var num: Int32
    var cl: Client?

    num = 0
    i = 0
    while i < g_maxclients.integer {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '+' cannot be applied to operands of type 'Client?' and 'Int32'".
        // Raven wrote: cl = level.clients + i
        portMissing("G_CountBotPlayers", source: "oracle/codemp/game/g_bot.c:525")
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        if !((g_entities[cl!.ps.clientNum].r.svFlags & SVF_BOT) != 0) {
            i += 1
            continue
        }
        if g_gametype.integer == GT_SIEGE {
            if team >= 0 && cl!.sess.siegeDesiredTeam != team {
                i += 1
                continue
            }
        } else {
            if team >= 0 && cl!.sess.sessionTeam != team {
                i += 1
                continue
            }
        }
        num += 1
        i += 1
    }
    n = 0
    while n < BOT_SPAWN_QUEUE_DEPTH {
        if botSpawnQueue[n].spawnTime == 0 {
            n += 1
            continue
        }
        if botSpawnQueue[n].spawnTime > level.time {
            n += 1
            continue
        }
        num += 1
        n += 1
    }
    return num
}

/**
```
===============
G_CheckMinimumPlayers
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:569
func G_CheckMinimumPlayers() {
    var minplayers: Int32
    let humanplayers: Int32
    let botplayers: Int32
    // Port-note: A static local `checkminimumplayers_time` a statement reads before it writes, storage that outlives the call.
    // Raven wrote: static int checkminimumplayers_time;
    portMissing("G_CheckMinimumPlayers", source: "oracle/codemp/game/g_bot.c:569")

    if g_gametype.integer == GT_SIEGE {
        return
    }

    if level.intermissiontime != 0 {
        return
    }
    //only check once each 10 seconds
    // Port-note: A read of `checkminimumplayers_time`, a local the draft left as a hole.
    // Raven wrote: if (checkminimumplayers_time > level.time - 10000) { return; }
    portMissing("G_CheckMinimumPlayers", source: "oracle/codemp/game/g_bot.c:569")
    // Port-note: A store into `checkminimumplayers_time`, a local the draft left as a hole.
    // Raven wrote: checkminimumplayers_time = level.time
    portMissing("G_CheckMinimumPlayers", source: "oracle/codemp/game/g_bot.c:569")
    trap_Cvar_Update(bot_minplayers)
    minplayers = bot_minplayers.integer
    if minplayers <= 0 {
        return
    }

    if minplayers > g_maxclients.integer {
        minplayers = g_maxclients.integer
    }

    humanplayers = G_CountHumanPlayers(-1)
    botplayers = G_CountBotPlayers(-1)

    if (humanplayers + botplayers) < minplayers {
        G_AddRandomBot(-1)
    } else if (humanplayers + botplayers) > minplayers && botplayers != 0 {
        // try to remove spectators first
        if G_RemoveRandomBot(TEAM_SPECTATOR) == 0 {
            // just remove the bot that is playing
            G_RemoveRandomBot(-1)
        }
    }

    /*
    if (g_gametype.integer >= GT_TEAM) {
    int humanplayers2, botplayers2;
    if (minplayers >= g_maxclients.integer / 2) {
    minplayers = (g_maxclients.integer / 2) -1;
    }

    humanplayers = G_CountHumanPlayers( TEAM_RED );
    botplayers = G_CountBotPlayers(	TEAM_RED );
    humanplayers2 = G_CountHumanPlayers( TEAM_BLUE );
    botplayers2 = G_CountBotPlayers( TEAM_BLUE );
    //
    if ((humanplayers+botplayers+humanplayers2+botplayers) < minplayers)
    {
    if ((humanplayers+botplayers) < (humanplayers2+botplayers2))
    {
    G_AddRandomBot( TEAM_RED );
    }
    else
    {
    G_AddRandomBot( TEAM_BLUE );
    }
    }
    else if ((humanplayers+botplayers+humanplayers2+botplayers) > minplayers && botplayers)
    {
    if ((humanplayers+botplayers) < (humanplayers2+botplayers2))
    {
    G_RemoveRandomBot( TEAM_BLUE );
    }
    else
    {
    G_RemoveRandomBot( TEAM_RED );
    }
    }
    }
    else if (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) {
    if (minplayers >= g_maxclients.integer) {
    minplayers = g_maxclients.integer-1;
    }
    humanplayers = G_CountHumanPlayers( -1 );
    botplayers = G_CountBotPlayers( -1 );
    //
    if (humanplayers + botplayers < minplayers) {
    G_AddRandomBot( TEAM_FREE );
    } else if (humanplayers + botplayers > minplayers && botplayers) {
    // try to remove spectators first
    if (!G_RemoveRandomBot( TEAM_SPECTATOR )) {
    // just remove the bot that is playing
    G_RemoveRandomBot( -1 );
    }
    }
    }
    else if (g_gametype.integer == GT_FFA) {
    if (minplayers >= g_maxclients.integer) {
    minplayers = g_maxclients.integer-1;
    }
    humanplayers = G_CountHumanPlayers( TEAM_FREE );
    botplayers = G_CountBotPlayers( TEAM_FREE );
    //
    if (humanplayers + botplayers < minplayers) {
    G_AddRandomBot( TEAM_FREE );
    } else if (humanplayers + botplayers > minplayers && botplayers) {
    G_RemoveRandomBot( TEAM_FREE );
    }
    }
    else if (g_gametype.integer == GT_HOLOCRON || g_gametype.integer == GT_JEDIMASTER) {
    if (minplayers >= g_maxclients.integer) {
    minplayers = g_maxclients.integer-1;
    }
    humanplayers = G_CountHumanPlayers( TEAM_FREE );
    botplayers = G_CountBotPlayers( TEAM_FREE );
    //
    if (humanplayers + botplayers < minplayers) {
    G_AddRandomBot( TEAM_FREE );
    } else if (humanplayers + botplayers > minplayers && botplayers) {
    G_RemoveRandomBot( TEAM_FREE );
    }
    }
    */
}

/**
```
===============
G_CheckBotSpawn
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:697
func G_CheckBotSpawn() {
    var n: Int32

    G_CheckMinimumPlayers()

    n = 0
    while n < BOT_SPAWN_QUEUE_DEPTH {
        if botSpawnQueue[n].spawnTime == 0 {
            n += 1
            continue
        }
        if botSpawnQueue[n].spawnTime > level.time {
            n += 1
            continue
        }
        ClientBegin(botSpawnQueue[n].clientNum, false)
        botSpawnQueue[n].spawnTime = 0

        /*
        if( g_gametype.integer == GT_SINGLE_PLAYER ) {
        trap_GetUserinfo( botSpawnQueue[n].clientNum, userinfo, sizeof(userinfo) );
        PlayerIntroSound( Info_ValueForKey (userinfo, "model") );
        }
        */
        n += 1
    }
}

/**
```
===============
AddBotToSpawnQueue
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:727
private func AddBotToSpawnQueue(_ clientNum: Int32, _ delay: Int32) {
    var n: Int32

    n = 0
    while n < BOT_SPAWN_QUEUE_DEPTH {
        if botSpawnQueue[n].spawnTime == 0 {
            botSpawnQueue[n].spawnTime = level.time + delay
            botSpawnQueue[n].clientNum = clientNum
            return
        }
        n += 1
    }

    G_Printf(S_COLOR_YELLOW + "Unable to delay spawn\n")
    ClientBegin(clientNum, false)
}

/**
```
===============
G_RemoveQueuedBotBegin

Called on client disconnect to make sure the delayed spawn
doesn't happen on a freed index
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:751
func G_RemoveQueuedBotBegin(_ clientNum: Int32) {
    var n: Int32

    n = 0
    while n < BOT_SPAWN_QUEUE_DEPTH {
        if botSpawnQueue[n].clientNum == clientNum {
            botSpawnQueue[n].spawnTime = 0
            return
        }
        n += 1
    }
}

/**
```
===============
G_BotConnect
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:768
func G_BotConnect(_ clientNum: Int32, _ restart: Bool) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return BotSettings.scratch { settings -> Bool in
        var userinfo = CharBuf(1024)

        strcpy(&userinfo, trap_GetUserinfo(clientNum, Int32((userinfo).count)))

        Q_strncpyz(&settings.personalityfileBuffer, Info_ValueForKey(String(userinfo), "personality"), 144)
        settings.skill = atof(Info_ValueForKey(String(userinfo), "skill"))
        Q_strncpyz(&settings.teamBuffer, Info_ValueForKey(String(userinfo), "team"), 144)

        if BotAISetupClient(clientNum, settings, restart) == 0 {
            trap_DropClient(clientNum, "BotAISetupClient failed")
            return false
        }

        return true
    }
}

/**
```
===============
G_AddBot
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:792
private func G_AddBot(_ name: String, _ skill: Float, _ team: String, _ delay: Int32, _ altname: inout JKAShared.CharBuf) {
    let clientNum: Int32
    let botinfo: String
    var bot: Entity?
    var key: String
    var s: String
    // Port-note: A pointer local `char * botname` with no view.
    // Raven wrote: char *botname;
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    var model: String
    //	char			*headmodel;
    var userinfo = CharBuf(1024)
    var preTeam: Int32 = 0
    // Raven steps his own `team` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var team = TextCursor(CharBuf(team))

    // get the botinfo from bots.txt
    // Port-note: Raven stores `G_GetBotInfoByName( name )`, and the callee hands an optional text back where the target takes a value. A never-null ruling is due.
    // Raven wrote: botinfo = G_GetBotInfoByName( name )
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")

    // create the bot's userinfo
    userinfo[0] = 0

    // Port-note: A store into `botname`, a local the draft left as a hole.
    // Raven wrote: botname = Info_ValueForKey( botinfo, "funname" )
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    // Port-note: A read of `botname`, a local the draft left as a hole.
    // Raven wrote: if( !botname[0] ) { botname = Info_ValueForKey( botinfo, "name" ); }
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    // check for an alternative name
    if altname[0] != 0 {
        // Port-note: A store into `botname`, a local the draft left as a hole.
        // Raven wrote: botname = altname
        portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    }
    // Port-note: A read of `botname`, a local the draft left as a hole.
    // Raven wrote: Info_SetValueForKey( userinfo, "name", botname )
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    Info_SetValueForKey(&userinfo, "rate", "25000")
    Info_SetValueForKey(&userinfo, "snaps", "20")
    Info_SetValueForKey(&userinfo, "skill", va("%1.2f", skill))

    if skill >= 1 && skill < 2 {
        Info_SetValueForKey(&userinfo, "handicap", "50")
    } else if skill >= 2 && skill < 3 {
        Info_SetValueForKey(&userinfo, "handicap", "70")
    } else if skill >= 3 && skill < 4 {
        Info_SetValueForKey(&userinfo, "handicap", "90")
    }

    key = "model"
    model = Info_ValueForKey(botinfo, key)
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if ( !*model ) { model = "kyle/default"; }
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    Info_SetValueForKey(&userinfo, key, model)

    /*	key = "headmodel";
    headmodel = Info_ValueForKey( botinfo, key );
    if ( !*headmodel ) {
    headmodel = model;
    }
    Info_SetValueForKey( userinfo, key, headmodel );
    key = "team_headmodel";
    Info_SetValueForKey( userinfo, key, headmodel );
    */
    key = "gender"
    s = Info_ValueForKey(botinfo, key)
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if ( !*s ) { s = "male"; }
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    Info_SetValueForKey(&userinfo, "sex", s)

    key = "color1"
    s = Info_ValueForKey(botinfo, key)
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if ( !*s ) { s = "4"; }
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    Info_SetValueForKey(&userinfo, key, s)

    key = "color2"
    s = Info_ValueForKey(botinfo, key)
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if ( !*s ) { s = "4"; }
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    Info_SetValueForKey(&userinfo, key, s)

    key = "saber1"
    s = Info_ValueForKey(botinfo, key)
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if ( !*s ) { s = "single_1"; }
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    Info_SetValueForKey(&userinfo, key, s)

    key = "saber2"
    s = Info_ValueForKey(botinfo, key)
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if ( !*s ) { s = "none"; }
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
    Info_SetValueForKey(&userinfo, key, s)

    s = Info_ValueForKey(botinfo, "personality")
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (!*s ) { Info_SetValueForKey( userinfo, "personality", "botfiles/default.jkb" ); } else { Info_SetValueForKey( userinfo, "personality", s ); }
    portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")

    // have the server allocate a client slot
    clientNum = trap_BotAllocateClient()
    if clientNum == -1 {
        //		G_Printf( S_COLOR_RED "Unable to add bot.  All player slots are in use.\n" );
        //		G_Printf( S_COLOR_RED "Start server with more 'open' slots.\n" );
        // Port-note: Raven passes `"MP_SVGAME"` to `G_GetStringEdString`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
        // Raven wrote: trap_SendServerCommand( -1, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "UNABLE_TO_ADD_BOT")))
        portMissing("G_AddBot", source: "oracle/codemp/game/g_bot.c:792")
        return
    }

    // initialize the bot settings
    if team.byte == 0 {
        if g_gametype.integer >= GT_TEAM {
            if PickTeam(clientNum) == TEAM_RED {
                team = TextCursor("red")
            } else {
                team = TextCursor("blue")
            }
        } else {
            team = TextCursor("red")
        }
    }
    //	Info_SetValueForKey( userinfo, "characterfile", Info_ValueForKey( botinfo, "aifile" ) );
    Info_SetValueForKey(&userinfo, "skill", va("%5.2f", skill))
    Info_SetValueForKey(&userinfo, "team", team.text)

    bot = g_entities[clientNum]
    bot!.r.svFlags |= SVF_BOT
    bot!.inuse = true

    // register the userinfo
    trap_SetUserinfo(clientNum, String(userinfo))

    if g_gametype.integer >= GT_TEAM {
        if !team.isNull && Q_stricmp(team.text, "red") == 0 {
            bot!.client!.sess.sessionTeam = TEAM_RED
        } else if !team.isNull && Q_stricmp(team.text, "blue") == 0 {
            bot!.client!.sess.sessionTeam = TEAM_BLUE
        } else {
            bot!.client!.sess.sessionTeam = PickTeam(-1)
        }
    }

    if g_gametype.integer == GT_SIEGE {
        bot!.client!.sess.siegeDesiredTeam = bot!.client!.sess.sessionTeam
        bot!.client!.sess.sessionTeam = TEAM_SPECTATOR
    }

    preTeam = bot!.client!.sess.sessionTeam

    // have it connect to the game as a normal client
    if ClientConnect(clientNum, true, true) != nil {
        return
    }

    if bot!.client!.sess.sessionTeam != preTeam {
        strcpy(&userinfo, trap_GetUserinfo(clientNum, MAX_INFO_STRING))

        if bot!.client!.sess.sessionTeam == TEAM_SPECTATOR {
            bot!.client!.sess.sessionTeam = preTeam
        }

        if bot!.client!.sess.sessionTeam == TEAM_RED {
            team = TextCursor("Red")
        } else {
            if g_gametype.integer == GT_SIEGE {
                if bot!.client!.sess.sessionTeam == TEAM_BLUE {
                    team = TextCursor("Blue")
                } else {
                    team = TextCursor("s")
                }
            } else {
                team = TextCursor("Blue")
            }
        }

        Info_SetValueForKey(&userinfo, "team", team.text)

        trap_SetUserinfo(clientNum, String(userinfo))

        bot!.client!.ps.persistant[PERS_TEAM] = bot!.client!.sess.sessionTeam

        G_ReadSessionData(bot!.client!)
        ClientUserinfoChanged(clientNum)
    }

    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        var loners: Int32 = 0
        var doubles: Int32 = 0

        bot!.client!.sess.duelTeam = 0
        G_PowerDuelCount(&loners, &doubles, true)

        if doubles == 0 || loners > (doubles / 2) {
            bot!.client!.sess.duelTeam = DUELTEAM_DOUBLE
        } else {
            bot!.client!.sess.duelTeam = DUELTEAM_LONE
        }

        bot!.client!.sess.sessionTeam = TEAM_SPECTATOR
        SetTeam(bot!, "s")
    } else {
        if delay == 0 {
            ClientBegin(clientNum, false)
            return
        }

        AddBotToSpawnQueue(clientNum, delay)
    }
}

/**
```
===============
Svcmd_AddBot_f
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:1041
func Svcmd_AddBot_f() {
    let skill: Float
    let delay: Int32
    var name = CharBuf(1024)
    var altname = CharBuf(1024)
    var string = CharBuf(1024)
    var team = CharBuf(1024)

    // are bots enabled?
    if trap_Cvar_VariableIntegerValue("bot_enable") == 0 {
        return
    }

    // name
    strcpy(&name, trap_Argv(1, Int32((name).count)))
    if name[0] == 0 {
        trap_Printf("Usage: Addbot <botname> [skill 1-5] [team] [msec delay] [altname]\n")
        return
    }

    // skill
    strcpy(&string, trap_Argv(2, Int32((string).count)))
    if string[0] == 0 {
        skill = 4
    } else {
        skill = atof(string)
    }

    // team
    strcpy(&team, trap_Argv(3, Int32((team).count)))

    // delay
    strcpy(&string, trap_Argv(4, Int32((string).count)))
    if string[0] == 0 {
        delay = 0
    } else {
        delay = atoi(string)
    }

    // alternative name
    strcpy(&altname, trap_Argv(5, Int32((altname).count)))

    G_AddBot(String(name), skill, String(team), delay, &altname)

    // if this was issued during gameplay and we are playing locally,
    // go ahead and load the bot's media immediately
    if level.time - level.startTime > 1000 && trap_Cvar_VariableIntegerValue("cl_running") != 0 {
        trap_SendServerCommand(-1, "loaddefered\n") // FIXME: spelled wrong, but not changing for demo
    }
}

/**
```
===============
Svcmd_BotList_f
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:1100
func Svcmd_BotList_f() {
    var i: Int32
    var name = CharBuf(1024)
    var funname = CharBuf(1024)
    var model = CharBuf(1024)
    var personality = CharBuf(1024)

    trap_Printf("^1name             model            personality              funname\n")
    i = 0
    while i < g_numBots {
        strcpy(&name, Info_ValueForKey(g_botInfos[i], "name"))
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if ( !*name ) { strcpy(name, "Padawan"); }
        portMissing("Svcmd_BotList_f", source: "oracle/codemp/game/g_bot.c:1100")
        strcpy(&funname, Info_ValueForKey(g_botInfos[i], "funname"))
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if ( !*funname ) { strcpy(funname, ""); }
        portMissing("Svcmd_BotList_f", source: "oracle/codemp/game/g_bot.c:1100")
        strcpy(&model, Info_ValueForKey(g_botInfos[i], "model"))
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if ( !*model ) { strcpy(model, "kyle/default"); }
        portMissing("Svcmd_BotList_f", source: "oracle/codemp/game/g_bot.c:1100")
        strcpy(&personality, Info_ValueForKey(g_botInfos[i], "personality"))
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if (!*personality ) { strcpy(personality, "botfiles/kyle.jkb"); }
        portMissing("Svcmd_BotList_f", source: "oracle/codemp/game/g_bot.c:1100")
        trap_Printf(va("%-16s %-16s %-20s %-20s\n", name, model, personality, funname))
        i += 1
    }
}

/**
```
===============
G_LoadBotsFromFile
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:1194
private func G_LoadBotsFromFile(_ filename: String) {
    let len: Int32
    var f: fileHandle_t = 0
    var buf = CharBuf(8192)

    len = trap_FS_FOpenFile(filename, &f, FS_READ)
    if f == 0 {
        trap_Printf(va(S_COLOR_RED + "file not found: %s\n", filename))
        return
    }
    if len >= MAX_BOTS_TEXT {
        trap_Printf(va(S_COLOR_RED + "file too large: %s is %i, max allowed is %i", filename, len, MAX_BOTS_TEXT))
        trap_FS_FCloseFile(f)
        return
    }

    trap_FS_Read(&buf, len, f)
    buf[len] = 0
    trap_FS_FCloseFile(f)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Range<Int>'".
    // Raven wrote: g_numBots += G_ParseInfos( buf, MAX_BOTS - g_numBots, &g_botInfos[g_numBots] )
    portMissing("G_LoadBotsFromFile", source: "oracle/codemp/game/g_bot.c:1194")
}

/**
```
===============
G_LoadBots
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:1222
private func G_LoadBots() {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = VmCvar.scratch { botsFile -> Bool in
        var numdirs: Int32 = 0
        var filename = CharBuf(128)
        var dirlist = CharBuf(1024)
        var dirptr = TextCursor()
        var i: Int32 = 0
        var dirlen: Int32 = 0

        if trap_Cvar_VariableIntegerValue("bot_enable") == 0 {
            return true
        }

        g_numBots = 0

        trap_Cvar_Register(botsFile, "g_botsFile", "", CVAR_INIT | CVAR_ROM)
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if( *botsFile.string ) { G_LoadBotsFromFile(botsFile.string); } else { //G_LoadBotsFromFile("scripts/bots.txt"); G_LoadBotsFromFile("botfiles/bots.txt"); }
        portMissing("G_LoadBots", source: "oracle/codemp/game/g_bot.c:1222")

        // get all bots from .bot files
        let filled = trap_FS_GetFileList("scripts", ".bot", 1024)
        numdirs = filled.0
        dirlist = filled.1
        dirptr = TextCursor(dirlist)
        i = 0
        while i < numdirs {
            dirlen = strlen(dirptr.text)
            strcpy(&filename, "scripts/")
            strcat(&filename, dirptr.text)
            G_LoadBotsFromFile(String(filename))
            i += 1
            dirptr.advance(by: dirlen + 1)
        }
        //	trap_Printf( va( "%i bots parsed\n", g_numBots ) );
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
===============
G_GetBotInfoByNumber
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:1265
func G_GetBotInfoByNumber(_ num: Int32) -> String? {
    if num < 0 || num >= g_numBots {
        trap_Printf(va(S_COLOR_RED + "Invalid bot number: %i\n", num))
        return nil
    }
    return g_botInfos[num]
}

/**
```
===============
G_GetBotInfoByName
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:1279
func G_GetBotInfoByName(_ name: String) -> String? {
    var n: Int32
    var value: String

    n = 0
    while n < g_numBots {
        value = Info_ValueForKey(g_botInfos[n], "name")
        if Q_stricmp(value, name) == 0 {
            return g_botInfos[n]
        }
        n += 1
    }

    return nil
}

/**
```
===============
G_InitBots
===============
```
*/
/// Source: oracle/codemp/game/g_bot.c:1302
func G_InitBots(_ restart: Bool) {
    G_LoadBots()
    G_LoadArenas()

    trap_Cvar_Register(bot_minplayers, "bot_minplayers", "0", CVAR_SERVERINFO)

    //rww - new bot route stuff
    LoadPath_ThisLevel()
    //end rww
}
