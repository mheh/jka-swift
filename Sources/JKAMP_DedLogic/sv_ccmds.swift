import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/sv_ccmds.cpp:789
/// Raven's data table, a hand property of `EngineWorld`.
var forceToggleNamePrints: [String] {
    get { world.forceToggleNamePrints }
    set { world.forceToggleNamePrints = newValue }
}

/// Source: oracle/codemp/server/sv_ccmds.cpp:16
public func SV_GetStringEdString(_ refSection: String, _ refName: String) -> String {
    /*
    static char text[1024]={0};
    trap_SP_GetStringTextString(va("%s_%s", refSection, refName), text, sizeof(text));
    return text;
    */

    //Well, it would've been lovely doing it the above way, but it would mean mixing
    //languages for the client depending on what the server is. So we'll mark this as
    //a stringed reference with @@@ and send the refname to the client, and when it goes
    //to print it will get scanned for the stringed reference indication and dealt with
    //properly.
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var text = CharBuf(1024)
    Com_sprintf(&text, Int32((text).count), "@@@%s", refName)
    return String(text)
}

/**
```
==================
SV_GetPlayerByName

Returns the player with name from Cmd_Argv(1)
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:43
private func SV_GetPlayerByName() -> Client? {
    var cl: Slots<Client>
    var i: Int32
    let s: String
    var cleanName = CharBuf(64)

    // make sure server is running
    if com_sv_running!.integer == 0 {
        return nil
    }

    if Cmd_Argc() < 2 {
        Com_Printf("No player specified.\n")
        return nil
    }

    s = Cmd_Argv(1)

    // check for a name match
    i = 0
    cl = svs.clientsSlots
    while i < sv_maxclients!.integer {
        if cl[0].state == 0 {
            i += 1
            cl = cl.suffix(from: 1)
            continue
        }
        if Q_stricmp(cl[0].name, s) == 0 {
            return cl[0]
        }

        Q_strncpyz(&cleanName, cl[0].name, Int32((cleanName).count))
        Q_CleanStr(&cleanName)
        if Q_stricmp(String(cleanName), s) == 0 {
            return cl[0]
        }
        i += 1
        cl = cl.suffix(from: 1)
    }

    Com_Printf("Player %s is not on the server\n", s)

    return nil
}

/**
```
==================
SV_GetPlayerByNum

Returns the player with idnum from Cmd_Argv(1)
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:89
private func SV_GetPlayerByNum() -> Client? {
    var cl: Client?
    var i: Int32
    let idnum: Int32
    let s: String

    // make sure server is running
    if com_sv_running!.integer == 0 {
        return nil
    }

    if Cmd_Argc() < 2 {
        Com_Printf("No player specified.\n")
        return nil
    }

    s = Cmd_Argv(1)

    i = 0
    while CharBuf(s)[i] != 0 {
        if CharBuf(s)[i] < Int32(ascii: "0") || CharBuf(s)[i] > Int32(ascii: "9") {
            Com_Printf("Bad slot number: %s\n", s)
            return nil
        }
        i += 1
    }
    idnum = atoi(s)
    if idnum < 0 || idnum >= sv_maxclients!.integer {
        Com_Printf("Bad client slot: %i\n", idnum)
        return nil
    }

    cl = svs.clientsSlots[idnum]
    if cl!.state == 0 {
        Com_Printf("Client %i is not active\n", idnum)
        return nil
    }
    return cl
}

/**
```
==================
SV_Map_f

Restart the server on a different map
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:138
private func SV_Map_f() {
    var cmd: TextCursor
    let map: String
    var killBots: Bool
    var cheat: Bool
    var expanded = CharBuf(64)
    var mapname = CharBuf(64)

    map = Cmd_Argv(1)

    // make sure the level exists before trying to change, so that
    // a typo at the server console won't end the game
    if strchr(map, Int32(ascii: "\\")) != nil {
        Com_Printf("Can't have mapnames with a \\\n")
        return
    }

    Com_sprintf(&expanded, Int32((expanded).count), "maps/%s.bsp", map)
    var buffer: CharBuf? = nil
    if FS_ReadFile(String(expanded), &buffer) == -1 {
        Com_Printf("Can't find map %s\n", expanded)
        return
    }

    // force latched values to get set
    Cvar_Get("g_gametype", "0", CVAR_SERVERINFO | CVAR_LATCH)

    cmd = TextCursor(CharBuf(Cmd_Argv(0)))
    if Q_stricmpn(cmd.text, "sp", 2) == 0 {
        Cvar_SetValue("g_gametype", Float(GT_SINGLE_PLAYER))
        Cvar_SetValue("g_doWarmup", 0)
        // may not set sv_maxclients directly, always set latched
        Cvar_SetLatched("sv_maxclients", "8")
        cmd.advance(by: 2)
        cheat = false
        killBots = true
    } else {
        if Q_stricmpn(cmd.text, "devmap", 6) == 0 || Q_stricmp(cmd.text, "spdevmap") == 0 {
            cheat = true
            killBots = true
        } else {
            cheat = false
            killBots = false
        }
        /*
        if( sv_gametype->integer == GT_SINGLE_PLAYER ) {
        Cvar_SetValue( "g_gametype", GT_FFA );
        }
        */
    }

    // save the map name here cause on a map restart we reload the jampconfig.cfg
    // and thus nuke the arguments of the map command
    Q_strncpyz(&mapname, map, Int32((mapname).count))

    var eForceReload: ForceReload_e = eForceReload_NOTHING

    //	if ( !Q_stricmp( cmd, "devmapbsp") ) {	// not relevant in MP codebase
    //		eForceReload = eForceReload_BSP;
    //	}
    //	else
    if Q_stricmp(cmd.text, "devmapmdl") == 0 {
        eForceReload = eForceReload_MODELS
    } else if Q_stricmp(cmd.text, "devmapall") == 0 {
        eForceReload = eForceReload_ALL
    }

    // start up the map
    SV_SpawnServer(String(mapname), killBots, eForceReload)

    // set the cheat value
    // if the level was started with "map <levelname>", then
    // cheats will not be allowed.  If started with "devmap <levelname>"
    // then cheats will be allowed
    if cheat {
        Cvar_Set("sv_cheats", "1")
    } else {
        Cvar_Set("sv_cheats", "0")
    }
}

/**
```
================
SV_MapRestart_f

Completely restarts a level, but doesn't send a new gamestate to the clients.
This allows fair starts with variable load times.
================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:234
private func SV_MapRestart_f() {
    var i: Int32
    var client: Client?
    var denied: String?
    var isBot: Bool
    let delay: Int32

    // make sure we aren't restarting twice in the same frame
    if com_frameTime == sv.serverId {
        return
    }

    // make sure server is running
    if com_sv_running!.integer == 0 {
        Com_Printf("Server is not running.\n")
        return
    }

    if sv.restartTime != 0 {
        return
    }

    if Cmd_Argc() > 1 {
        delay = atoi(Cmd_Argv(1))
    } else {
        delay = 5
    }
    if delay != 0 {
        sv.restartTime = svs.time + delay * 1000
        SV_SetConfigstring(CS_WARMUP, va("%i", sv.restartTime))
        return
    }

    // check for changes in variables that can't just be restarted
    // check for maxclients change
    if sv_maxclients!.modified || sv_gametype!.modified {
        var mapname = CharBuf(64)

        Com_Printf("variable change -- restarting.\n")
        // restart the map the slow way
        Q_strncpyz(&mapname, Cvar_VariableString("mapname"), Int32((mapname).count))

        SV_SpawnServer(String(mapname), false, eForceReload_NOTHING)
        return
    }

    // toggle the server bit so clients can detect that a
    // map_restart has happened
    svs.snapFlagServerBit ^= SNAPFLAG_SERVERCOUNT

    // generate a new serverid
    sv.restartedServerId = sv.serverId
    sv.serverId = com_frameTime
    Cvar_Set("sv_serverid", va("%i", sv.serverId))

    // reset all the vm data in place without changing memory allocation
    // note that we do NOT set sv.state = SS_LOADING, so configstrings that
    // had been changed from their default values will generate broadcast updates
    sv.state = SS_LOADING
    sv.restarting = true

    SV_RestartGameProgs()

    // run a few frames to allow everything to settle
    i = 0
    while i < 3 {
        VM_Call(gvm!, GAME_RUN_FRAME, svs.time)
        svs.time += 100
        i += 1
    }

    sv.state = SS_GAME
    sv.restarting = false

    // connect and begin all the clients
    i = 0
    while i < sv_maxclients!.integer {
        client = svs.clientsSlots[i]

        // send the new gamestate to all connected clients
        if client!.state < CS_CONNECTED {
            i += 1
            continue
        }

        if client!.netchan.remoteAddress.type == NA_BOT {
            isBot = true
        } else {
            isBot = false
        }

        // add the map_restart command
        SV_AddServerCommand(client!, "map_restart\n")

        // connect the client again, without the firstTime flag
        denied = VM_ExplicitArgPtr(gvm!, VM_Call(gvm!, GAME_CLIENT_CONNECT, i, false, isBot))
        if denied != nil {
            // this generally shouldn't happen, because the client
            // was connected before the level change
            SV_DropClient(client!, denied!)
            Com_Printf("SV_MapRestart_f(%d): dropped client %i - denied!\n", delay, i) // bk010125
            i += 1
            continue
        }

        client!.state = CS_ACTIVE

        SV_ClientEnterWorld(client!, client!.lastUsercmd)
        i += 1
    }

    // run another frame to allow things to look at all the players
    VM_Call(gvm!, GAME_RUN_FRAME, svs.time)
    svs.time += 100
}

/**
```
==================
SV_GetPlayerByName

Returns the player with name from Cmd_Argv(1)
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:354
private func SV_GetPlayerByFedName(_ name: String) -> Client? {
    var cl: Slots<Client>
    var i: Int32
    var cleanName = CharBuf(64)

    // make sure server is running
    if com_sv_running!.integer == 0 {
        return nil
    }

    // check for a name match
    i = 0
    cl = svs.clientsSlots
    while i < sv_maxclients!.integer {
        if cl[0].state == 0 {
            i += 1
            cl = cl.suffix(from: 1)
            continue
        }
        if Q_stricmp(cl[0].name, name) == 0 {
            return cl[0]
        }

        Q_strncpyz(&cleanName, cl[0].name, Int32((cleanName).count))
        Q_CleanStr(&cleanName)
        if Q_stricmp(String(cleanName), name) == 0 {
            return cl[0]
        }
        i += 1
        cl = cl.suffix(from: 1)
    }

    return nil
}

/// Source: oracle/codemp/server/sv_ccmds.cpp:389
private func SV_KickByName(_ name: String) {
    var cl: Client?
    var i: Int32

    // make sure server is running
    if com_sv_running!.integer == 0 {
        return
    }

    cl = SV_GetPlayerByFedName(name)
    if cl == nil {
        if Q_stricmp(name, "all") == 0 {
            i = 0
            cl = svs.clients
            while i < sv_maxclients!.integer {
                if cl!.state == 0 {
                    i += 1
                    cl = svs.clientsSlots[i]
                    continue
                }
                if cl!.netchan.remoteAddress.type == NA_LOOPBACK {
                    i += 1
                    cl = svs.clientsSlots[i]
                    continue
                }
                SV_DropClient(cl!, SV_GetStringEdString("MP_SVGAME", "WAS_KICKED")) // "was kicked" );
                cl!.lastPacketTime = svs.time // in case there is a funny zombie
                i += 1
                cl = svs.clientsSlots[i]
            }
        } else if Q_stricmp(name, "allbots") == 0 {
            i = 0
            cl = svs.clients
            while i < sv_maxclients!.integer {
                if cl!.state == 0 {
                    i += 1
                    cl = svs.clientsSlots[i]
                    continue
                }
                if cl!.netchan.remoteAddress.type != NA_BOT {
                    i += 1
                    cl = svs.clientsSlots[i]
                    continue
                }
                SV_DropClient(cl!, SV_GetStringEdString("MP_SVGAME", "WAS_KICKED")) // "was kicked" );
                cl!.lastPacketTime = svs.time // in case there is a funny zombie
                i += 1
                cl = svs.clientsSlots[i]
            }
        }
        return
    }
    if cl!.netchan.remoteAddress.type == NA_LOOPBACK {
        //		SV_SendServerCommand(NULL, "print \"%s\"", "Cannot kick host player\n");
        SV_SendServerCommand(nil, "print \"%s\"", SV_GetStringEdString("MP_SVGAME", "CANNOT_KICK_HOST"))
        return
    }

    SV_DropClient(cl!, SV_GetStringEdString("MP_SVGAME", "WAS_KICKED")) // "was kicked" );
    cl!.lastPacketTime = svs.time // in case there is a funny zombie
}

/**
```
==================
SV_Kick_f

Kick a user off of the server  FIXME: move to game
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:455
private func SV_Kick_f() {
    var cl: Client?
    var i: Int32

    // make sure server is running
    if com_sv_running!.integer == 0 {
        Com_Printf("Server is not running.\n")
        return
    }

    if Cmd_Argc() != 2 {
        Com_Printf("Usage: kick <player name>\nkick all = kick everyone\nkick allbots = kick all bots\n")
        return
    }

    if Q_stricmp(Cmd_Argv(1), "Padawan") == 0 {
        //if you try to kick the default name, also try to kick ""
        SV_KickByName("")
    }

    cl = SV_GetPlayerByName()
    if cl == nil {
        if Q_stricmp(Cmd_Argv(1), "all") == 0 {
            i = 0
            cl = svs.clients
            while i < sv_maxclients!.integer {
                if cl!.state == 0 {
                    i += 1
                    cl = svs.clientsSlots[i]
                    continue
                }
                if cl!.netchan.remoteAddress.type == NA_LOOPBACK {
                    i += 1
                    cl = svs.clientsSlots[i]
                    continue
                }
                SV_DropClient(cl!, SV_GetStringEdString("MP_SVGAME", "WAS_KICKED")) // "was kicked" );
                cl!.lastPacketTime = svs.time // in case there is a funny zombie
                i += 1
                cl = svs.clientsSlots[i]
            }
        } else if Q_stricmp(Cmd_Argv(1), "allbots") == 0 {
            i = 0
            cl = svs.clients
            while i < sv_maxclients!.integer {
                if cl!.state == 0 {
                    i += 1
                    cl = svs.clientsSlots[i]
                    continue
                }
                if cl!.netchan.remoteAddress.type != NA_BOT {
                    i += 1
                    cl = svs.clientsSlots[i]
                    continue
                }
                SV_DropClient(cl!, SV_GetStringEdString("MP_SVGAME", "WAS_KICKED")) // "was kicked" );
                cl!.lastPacketTime = svs.time // in case there is a funny zombie
                i += 1
                cl = svs.clientsSlots[i]
            }
        }
        return
    }
    if cl!.netchan.remoteAddress.type == NA_LOOPBACK {
        //		SV_SendServerCommand(NULL, "print \"%s\"", "Cannot kick host player\n");
        SV_SendServerCommand(nil, "print \"%s\"", SV_GetStringEdString("MP_SVGAME", "CANNOT_KICK_HOST"))
        return
    }

    SV_DropClient(cl!, SV_GetStringEdString("MP_SVGAME", "WAS_KICKED")) // "was kicked" );
    cl!.lastPacketTime = svs.time // in case there is a funny zombie
}

/**
```
==================
SV_KickNum_f

Kick a user off of the server  FIXME: move to game
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:636
private func SV_KickNum_f() {
    var cl: Client?

    // make sure server is running
    if com_sv_running!.integer == 0 {
        Com_Printf("Server is not running.\n")
        return
    }

    if Cmd_Argc() != 2 {
        Com_Printf("Usage: kicknum <client number>\n")
        return
    }

    cl = SV_GetPlayerByNum()
    if cl == nil {
        return
    }
    if cl!.netchan.remoteAddress.type == NA_LOOPBACK {
        //		SV_SendServerCommand(NULL, "print \"%s\"", "Cannot kick host player\n");
        SV_SendServerCommand(nil, "print \"%s\"", SV_GetStringEdString("MP_SVGAME", "CANNOT_KICK_HOST"))
        return
    }

    SV_DropClient(cl!, SV_GetStringEdString("MP_SVGAME", "WAS_KICKED")) // "was kicked" );
    cl!.lastPacketTime = svs.time // in case there is a funny zombie
}

/**
```
================
SV_Status_f
================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:669
private func SV_Status_f() {
    var i: Int32
    var cl: Slots<Client>
    var ps: PlayerState?
    var s: String
    var ping: Int32
    var state = CharBuf(32)
    var avoidTruncation: Bool = false

    // make sure server is running
    if com_sv_running!.integer == 0 {
        Com_Printf(SE_GetString("STR_SERVER_SERVER_NOT_RUNNING"))
        return
    }

    if Cmd_Argc() > 1 {
        if Q_stricmp("notrunc", Cmd_Argv(1)) == 0 {
            avoidTruncation = true
        }
    }

    Com_Printf("map: %s\n", sv_mapname!.string!)

    Com_Printf("num score ping name            lastmsg address               qport rate\n")
    Com_Printf("--- ----- ---- --------------- ------- --------------------- ----- -----\n")
    i = 0
    cl = svs.clientsSlots
    while i < sv_maxclients!.integer {
        if cl[0].state == 0 {
            i += 1
            cl = cl.suffix(from: 1)
            continue
        }

        if cl[0].state == CS_CONNECTED {
            strcpy(&state, "CNCT ")
        } else if cl[0].state == CS_ZOMBIE {
            strcpy(&state, "ZMBI ")
        } else {
            ping = cl[0].ping < 9999 ? cl[0].ping : 9999
            strcpy(&state, JKAShared.format("%4i", [ping]))
        }

        ps = SV_GameClientNum(i)
        s = NET_AdrToString(cl[0].netchan.remoteAddress)

        if !avoidTruncation {
            Com_Printf("%3i %5i %s %-15.15s %7i %21s %5i %5i\n", i, ps!.persistant[PERS_SCORE], state, cl[0].name, svs.time - cl[0].lastPacketTime, s, cl[0].netchan.qport, cl[0].rate)
        } else {
            Com_Printf("%3i %5i %s %s %7i %21s %5i %5i\n", i, ps!.persistant[PERS_SCORE], state, cl[0].name, svs.time - cl[0].lastPacketTime, s, cl[0].netchan.qport, cl[0].rate)
        }
        i += 1
        cl = cl.suffix(from: 1)
    }
    Com_Printf("\n")
}

/**
```
==================
SV_ConSay_f
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:757
private func SV_ConSay_f() {
    var p: CharBuf
    var pIndex: Int32 = 0
    var text = CharBuf(1024)

    if com_dedicated!.integer == 0 {
        Com_Printf("Server is not dedicated.\n")
        return
    }

    // make sure server is running
    if com_sv_running!.integer == 0 {
        Com_Printf("Server is not running.\n")
        return
    }

    if Cmd_Argc() < 2 {
        return
    }

    strcpy(&text, "Server: ")
    // AI: Raven writes the NUL into the static buffer that Cmd_Args returns. The body writes it into a copy of that text, which no later read needs.
    p = CharBuf(Cmd_Args())

    if p[pIndex] == Int32(ascii: "\"") {
        pIndex += 1
        p[pIndex + strlen(p[pIndex...]) - 1] = 0
    }

    strcat(&text, String(p[pIndex...]))

    SV_SendServerCommand(nil, "chat \"%s\n\"", text)
}

/**
```
==================
SV_ForceToggle_f
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:817
public func SV_ForceToggle_f() {
    var i: Int32 = 0
    var fpDisabled: Int32 = Int32(Cvar_VariableValue("g_forcePowerDisable"))
    var targetPower: Int32 = 0
    var powerDisabled: String = "Enabled"

    if Cmd_Argc() < 2 {
        //no argument supplied, spit out a list of force powers and their numbers
        while i < NUM_FORCE_POWERS {
            if (fpDisabled & (1 << i)) != 0 {
                powerDisabled = "Disabled"
            } else {
                powerDisabled = "Enabled"
            }

            Com_Printf(va("%i - %s - Status: %s\n", i, forceToggleNamePrints[i], powerDisabled))
            i += 1
        }

        Com_Printf("Example usage: forcetoggle 3\n(toggles PUSH)\n")
        return
    }

    targetPower = atoi(Cmd_Argv(1))

    if targetPower < 0 || targetPower >= NUM_FORCE_POWERS {
        Com_Printf("Specified a power that does not exist.\nExample usage: forcetoggle 3\n(toggles PUSH)\n")
        return
    }

    if (fpDisabled & (1 << targetPower)) != 0 {
        powerDisabled = "enabled"
        fpDisabled &= ~(1 << targetPower)
    } else {
        powerDisabled = "disabled"
        fpDisabled |= (1 << targetPower)
    }

    Cvar_Set("g_forcePowerDisable", va("%i", fpDisabled))

    Com_Printf("%s has been %s.\n", forceToggleNamePrints[targetPower], powerDisabled)
}

/**
```
==================
SV_Heartbeat_f

Also called by SV_DropClient, SV_DirectConnect, and SV_SpawnServer
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:876
public func SV_Heartbeat_f() {
    svs.nextHeartbeatTime = -9999999
}

/**
```
===========
SV_Serverinfo_f

Examine the serverinfo string
===========
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:888
private func SV_Serverinfo_f() {
    Com_Printf("Server info settings:\n")
    Info_Print(Cvar_InfoString(CVAR_SERVERINFO))
    if com_sv_running!.integer == 0 {
        Com_Printf("Server is not running.\n")
    }
}

/**
```
===========
SV_Systeminfo_f

Examine or change the serverinfo string
===========
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:904
private func SV_Systeminfo_f() {
    Com_Printf("System info settings:\n")
    Info_Print(Cvar_InfoString(CVAR_SYSTEMINFO))
}

/**
```
===========
SV_DumpUser_f

Examine all a users info strings FIXME: move to game
===========
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:917
private func SV_DumpUser_f() {
    var cl: Client?

    // make sure server is running
    if com_sv_running!.integer == 0 {
        Com_Printf("Server is not running.\n")
        return
    }

    if Cmd_Argc() != 2 {
        Com_Printf("Usage: info <userid>\n")
        return
    }

    cl = SV_GetPlayerByName()
    if cl == nil {
        return
    }

    Com_Printf("userinfo\n")
    Com_Printf("--------\n")
    Info_Print(cl!.userinfo)
}

/**
```
=================
SV_KillServer
=================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:947
private func SV_KillServer_f() {
    SV_Shutdown("killserver")
}

/**
```
==================
SV_AddOperatorCommands
==================
```
*/
/// Raven's `static qboolean initialized` of `SV_AddOperatorCommands`, a property of `EngineWorld`.
/// Source: oracle/codemp/server/sv_ccmds.cpp:959
var initialized_SV_AddOperatorCommands: Bool {
    get { world.initialized_SV_AddOperatorCommands }
    set { world.initialized_SV_AddOperatorCommands = newValue }
}

/// Source: oracle/codemp/server/sv_ccmds.cpp:958
public func SV_AddOperatorCommands() {
    // Raven's static local `initialized` is `initialized_SV_AddOperatorCommands`, because navigator.cpp has a static local of the name.

    if initialized_SV_AddOperatorCommands {
        return
    }
    initialized_SV_AddOperatorCommands = true

    Cmd_AddCommand("heartbeat", SV_Heartbeat_f)
    Cmd_AddCommand("kick", SV_Kick_f)

    Cmd_AddCommand("clientkick", SV_KickNum_f)
    Cmd_AddCommand("status", SV_Status_f)
    Cmd_AddCommand("serverinfo", SV_Serverinfo_f)
    Cmd_AddCommand("systeminfo", SV_Systeminfo_f)
    Cmd_AddCommand("dumpuser", SV_DumpUser_f)
    Cmd_AddCommand("map_restart", SV_MapRestart_f)
    Cmd_AddCommand("sectorlist", SV_SectorList_f)
    Cmd_AddCommand("map", SV_Map_f)
    Cmd_AddCommand("devmap", SV_Map_f)
    Cmd_AddCommand("spmap", SV_Map_f)
    Cmd_AddCommand("spdevmap", SV_Map_f)
    //	Cmd_AddCommand ("devmapbsp", SV_Map_f);	// not used in MP codebase, no server BSP_cacheing
    Cmd_AddCommand("devmapmdl", SV_Map_f)
    Cmd_AddCommand("devmapall", SV_Map_f)
    Cmd_AddCommand("killserver", SV_KillServer_f)
    //	if( com_dedicated->integer )
    do {
        Cmd_AddCommand("svsay", SV_ConSay_f)
    }

    Cmd_AddCommand("forcetoggle", SV_ForceToggle_f)
}

/**
```
==================
SV_RemoveOperatorCommands
==================
```
*/
/// Source: oracle/codemp/server/sv_ccmds.cpp:1003
public func SV_RemoveOperatorCommands() {
    // removing these won't let the server start again
}
