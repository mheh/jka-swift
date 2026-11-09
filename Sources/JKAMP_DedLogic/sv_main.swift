import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/sv_main.cpp:10
var svs: ServerStatic { world.storage.svs }

/// Source: oracle/codemp/server/sv_main.cpp:11
var sv: Server { world.storage.sv }

/// Source: oracle/codemp/server/sv_main.cpp:12
var gvm: Vm? {
    get { world.variables.gvm }
    set { world.variables.gvm = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:14
var sv_fps: JKAMP.Cvar? {
    get { world.variables.sv_fps }
    set { world.variables.sv_fps = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:15
var sv_timeout: JKAMP.Cvar? {
    get { world.variables.sv_timeout }
    set { world.variables.sv_timeout = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:16
var sv_zombietime: JKAMP.Cvar? {
    get { world.variables.sv_zombietime }
    set { world.variables.sv_zombietime = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:17
var sv_rconPassword: JKAMP.Cvar? {
    get { world.variables.sv_rconPassword }
    set { world.variables.sv_rconPassword = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:18
var sv_privatePassword: JKAMP.Cvar? {
    get { world.variables.sv_privatePassword }
    set { world.variables.sv_privatePassword = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:19
var sv_maxclients: JKAMP.Cvar? {
    get { world.variables.sv_maxclients }
    set { world.variables.sv_maxclients = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:20
var sv_privateClients: JKAMP.Cvar? {
    get { world.variables.sv_privateClients }
    set { world.variables.sv_privateClients = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:21
var sv_hostname: JKAMP.Cvar? {
    get { world.variables.sv_hostname }
    set { world.variables.sv_hostname = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:23
var sv_allowDownload: JKAMP.Cvar? {
    get { world.variables.sv_allowDownload }
    set { world.variables.sv_allowDownload = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:24
var sv_master: Slots<JKAMP.Cvar?> { world.storage.sv_master }

/// Source: oracle/codemp/server/sv_main.cpp:26
var sv_reconnectlimit: JKAMP.Cvar? {
    get { world.variables.sv_reconnectlimit }
    set { world.variables.sv_reconnectlimit = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:27
var sv_showghoultraces: JKAMP.Cvar? {
    get { world.variables.sv_showghoultraces }
    set { world.variables.sv_showghoultraces = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:28
var sv_showloss: JKAMP.Cvar? {
    get { world.variables.sv_showloss }
    set { world.variables.sv_showloss = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:29
var sv_padPackets: JKAMP.Cvar? {
    get { world.variables.sv_padPackets }
    set { world.variables.sv_padPackets = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:30
var sv_killserver: JKAMP.Cvar? {
    get { world.variables.sv_killserver }
    set { world.variables.sv_killserver = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:31
var sv_mapname: JKAMP.Cvar? {
    get { world.variables.sv_mapname }
    set { world.variables.sv_mapname = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:32
var sv_mapChecksum: JKAMP.Cvar? {
    get { world.variables.sv_mapChecksum }
    set { world.variables.sv_mapChecksum = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:33
var sv_serverid: JKAMP.Cvar? {
    get { world.variables.sv_serverid }
    set { world.variables.sv_serverid = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:34
var sv_maxRate: JKAMP.Cvar? {
    get { world.variables.sv_maxRate }
    set { world.variables.sv_maxRate = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:35
var sv_minPing: JKAMP.Cvar? {
    get { world.variables.sv_minPing }
    set { world.variables.sv_minPing = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:36
var sv_maxPing: JKAMP.Cvar? {
    get { world.variables.sv_maxPing }
    set { world.variables.sv_maxPing = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:37
var sv_gametype: JKAMP.Cvar? {
    get { world.variables.sv_gametype }
    set { world.variables.sv_gametype = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:38
var sv_pure: JKAMP.Cvar? {
    get { world.variables.sv_pure }
    set { world.variables.sv_pure = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:39
var sv_floodProtect: JKAMP.Cvar? {
    get { world.variables.sv_floodProtect }
    set { world.variables.sv_floodProtect = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:40
var sv_needpass: JKAMP.Cvar? {
    get { world.variables.sv_needpass }
    set { world.variables.sv_needpass = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:191
let NEW_RESOLVE_DURATION = 86400000 as Int32

/// Source: oracle/codemp/server/sv_main.cpp:192
var g_lastResolveTime: [Int32] {
    get { world.variables.g_lastResolveTime }
    set { world.variables.g_lastResolveTime = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:220
let HEARTBEAT_MSEC = 300 * 1000 as Int32

/// Source: oracle/codemp/server/sv_main.cpp:221
let HEARTBEAT_GAME = "QuakeArena-1"

/// Source: oracle/codemp/server/sv_main.cpp:494
let SV_OUTPUTBUF_LENGTH = (JKAMP_Ded.MAX_MSGLEN - 16)

/// Raven's `static char string[1024]` of `SV_ExpandNewlines`, a property of `EngineWorld`.
/// Source: oracle/codemp/server/sv_main.cpp:60
var string_SV_ExpandNewlines: CharBuf {
    get { world.string_SV_ExpandNewlines }
    set { world.string_SV_ExpandNewlines = newValue }
}

/**
```
===============
SV_ExpandNewlines

Converts newlines to "\n" so a line prints nicer
===============
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:59
func SV_ExpandNewlines(_ `in`: inout JKAShared.CharBuf) -> String {
    // Raven's static local `string` is `string_SV_ExpandNewlines`, because msg.cpp has three static locals of the name.
    var l: Int32
    var inIndex: Int32 = 0

    l = 0
    while `in`[inIndex] as Int32 != 0 && l < string_SV_ExpandNewlines.count - 3 {
        if `in`[inIndex] == Int32(ascii: "\n") {
            string_SV_ExpandNewlines[l] = Int32(ascii: "\\")
            l += 1
            string_SV_ExpandNewlines[l] = Int32(ascii: "n")
            l += 1
        } else {
            string_SV_ExpandNewlines[l] = `in`[inIndex] as Int32
            l += 1
        }
        inIndex += 1
    }
    string_SV_ExpandNewlines[l] = 0

    return String(string_SV_ExpandNewlines)
}

/**
```
======================
SV_ReplacePendingServerCommands

  This is ugly
======================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:85
func SV_ReplacePendingServerCommands(_ client: Client, _ cmd: String) -> Int32 {
    var i: Int32
    var index: Int32
    var csnum1: Int32 = 0
    var csnum2: Int32 = 0

    i = client.reliableSent + 1
    while i <= client.reliableSequence {
        index = i & (MAX_RELIABLE_COMMANDS - 1)
        //
        if Q_strncmp(cmd, client.reliableCommands[index], strlen("cs")) == 0 {
            sscanf(cmd, "cs %i", &csnum1)
            sscanf(client.reliableCommands[index], "cs %i", &csnum2)
            if csnum1 == csnum2 {
                client.reliableCommands[index] = cmd
                /*
                if ( client->netchan.remoteAddress.type != NA_BOT ) {
                Com_Printf( "WARNING: client %i removed double pending config string %i: %s\n", client-svs.clients, csnum1, cmd );
                }
                */
                return 1
            }
        }
        i += 1
    }
    return 0
}

/**
```
======================
SV_AddServerCommand

The given command will be transmitted to the client, and is guaranteed to
not have future snapshot_t executed before it is executed
======================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:116
func SV_AddServerCommand(_ client: Client, _ cmd: String) {
    let index: Int32
    var i: Int32

    // this is very ugly but it's also a waste to for instance send multiple config string updates
    // for the same config string index in one snapshot
    //	if ( SV_ReplacePendingServerCommands( client, cmd ) ) {
    //		return;
    //	}

    client.reliableSequence += 1
    // if we would be losing an old command that hasn't been acknowledged,
    // we must drop the connection
    // we check == instead of >= so a broadcast print added by SV_DropClient()
    // doesn't cause a recursive drop client
    if client.reliableSequence - client.reliableAcknowledge == MAX_RELIABLE_COMMANDS + 1 {
        Com_Printf("===== pending server commands =====\n")
        i = client.reliableAcknowledge + 1
        while i <= client.reliableSequence {
            Com_Printf("cmd %5d: %s\n", i, client.reliableCommands[i & (MAX_RELIABLE_COMMANDS - 1)])
            i += 1
        }
        Com_Printf("cmd %5d: %s\n", i, cmd)
        SV_DropClient(client, "Server command overflow")
        return
    }
    index = client.reliableSequence & (MAX_RELIABLE_COMMANDS - 1)
    client.reliableCommands[index] = cmd
}

/**
```
=================
SV_SendServerCommand

Sends a reliable command string to be interpreted by
the client game module: "cp", "print", "chat", etc
A NULL client will broadcast to all clients
=================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:153
func SV_SendServerCommand(_ cl: Client?, _ fmt: String, _ args: any JKAShared.FormatArg...) {
    var message = CharBuf(MAX_MSGLEN)
    var client: Slots<Client>
    var j: Int32

    strcpy(&message, JKAShared.format(fmt, args))

    if cl != nil {
        SV_AddServerCommand(cl!, String(message))
        return
    }

    // hack to echo broadcast prints to console
    if com_dedicated!.integer != 0 && strncmp(String(message), "print", 5) == 0 {
        Com_Printf("broadcast: %s\n", SV_ExpandNewlines(&message))
    }

    // send the data to all relevent clients
    j = 0
    client = svs.clientsSlots
    while j < sv_maxclients!.integer {
        if client[0].state < CS_PRIMED {
            j += 1
            client = client.suffix(from: 1)
            continue
        }
        SV_AddServerCommand(client[0], String(message))
        j += 1
        client = client.suffix(from: 1)
    }
}

/// Source: oracle/codemp/server/sv_main.cpp:194
private func SV_MasterNeedsResolving(_ server: Int32, _ time: Int32) -> Bool {
    //refresh every so often regardless of if the actual address was modified -rww
    if g_lastResolveTime[server] > time {
        //time flowed backwards?
        return true
    }

    if (time - g_lastResolveTime[server]) > NEW_RESOLVE_DURATION {
        //it's time again
        return true
    }

    return false
}

/// Raven's `static netadr_t adr[MAX_MASTER_SERVERS]` of `SV_MasterHeartbeat`, a property of `EngineWorld`.
/// Source: oracle/codemp/server/sv_main.cpp:223
var adr: Slots<Netadr> { world.adr }

/// Source: oracle/codemp/server/sv_main.cpp:222
func SV_MasterHeartbeat() {
    var i: Int32
    let time: Int32

    // "dedicated 1" is for lan play, "dedicated 2" is for inet public play
    if com_dedicated == nil || com_dedicated!.integer != 2 {
        return // only dedicated servers send heartbeats
    }

    // if not time yet, don't send anything
    if svs.time < svs.nextHeartbeatTime {
        return
    }
    svs.nextHeartbeatTime = svs.time + HEARTBEAT_MSEC

    //we need to use this instead of svs.time since svs.time resets over map changes (or rather
    //every time the game restarts), and we don't really need to resolve every map change
    time = Com_Milliseconds()

    // send to group masters
    i = 0
    while i < MAX_MASTER_SERVERS {
        if sv_master[i]!.string!.isEmpty {
            i += 1
            continue
        }

        // see if we haven't already resolved the name
        // resolving usually causes hitches on win95, so only
        // do it when needed
        if sv_master[i]!.modified || SV_MasterNeedsResolving(i, time) {
            sv_master[i]!.modified = false

            g_lastResolveTime[i] = time

            Com_Printf("Resolving %s\n", sv_master[i]!.string!)
            if !NET_StringToAdr(sv_master[i]!.string!, adr[i]) {
                // if the address failed to resolve, clear it
                // so we don't take repeated dns hits
                Com_Printf("Couldn't resolve address: %s\n", sv_master[i]!.string!)
                Cvar_Set(sv_master[i]!.name!, "")
                sv_master[i]!.modified = false
                i += 1
                continue
            }
            if strstr(":", sv_master[i]!.string!) == nil {
                adr[i].port = Int32(BigShort(Int16(truncatingIfNeeded: PORT_MASTER)))
            }
            Com_Printf("%s resolved to %i.%i.%i.%i:%i\n", sv_master[i]!.string!, adr[i].ip[0], adr[i].ip[1], adr[i].ip[2], adr[i].ip[3], Int32(BigShort(Int16(truncatingIfNeeded: adr[i].port))))
        }


        Com_Printf("Sending heartbeat to %s\n", sv_master[i]!.string!)
        // this command should be changed if the server info / status format
        // ever incompatably changes
        NET_OutOfBandPrint(NS_SERVER, adr[i], "heartbeat %s\n", HEARTBEAT_GAME)
        i += 1
    }
}

/**
```
=================
SV_MasterShutdown

Informs all masters that this server is going down
=================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:288
func SV_MasterShutdown() {
    // send a hearbeat right now
    svs.nextHeartbeatTime = -9999
    SV_MasterHeartbeat()

    // send it again to minimize chance of drops
    svs.nextHeartbeatTime = -9999
    SV_MasterHeartbeat()

    // when the master tries to poll the server, it won't respond, so
    // it will be removed from the list
}

/**
```
================
SVC_Status

Responds with all the info that qplug or qspy can see about the server
and all connected players.  Used for getting detailed information after
the simple info query.
================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:320
func SVC_Status(_ from: Netadr) {
    var player = CharBuf(1024)
    var status = CharBuf(49152)
    var i: Int32
    var cl: Client?
    var ps: PlayerState?
    var statusLength: Int32
    var playerLength: Int32
    var infostring = CharBuf(1024)

    // ignore if we are in single player
    /*
    if ( Cvar_VariableValue( "g_gametype" ) == GT_SINGLE_PLAYER ) {
    return;
    }
    */

    strcpy(&infostring, Cvar_InfoString(CVAR_SERVERINFO))

    // echo back the parameter to status. so master servers can use it as a challenge
    // to prevent timed spoofed reply packets that add ghost servers
    Info_SetValueForKey(&infostring, "challenge", Cmd_Argv(1))

    // add "demo" to the sv_keywords if restricted
    if Cvar_VariableValue("fs_restrict") != 0 {
        var keywords = CharBuf(1024)

        Com_sprintf(&keywords, Int32((keywords).count), "demo %s", Info_ValueForKey(String(infostring), "sv_keywords"))
        Info_SetValueForKey(&infostring, "sv_keywords", String(keywords))
    }

    status[0] = 0
    statusLength = 0

    i = 0
    while i < sv_maxclients!.integer {
        cl = svs.clientsSlots[i]
        if cl!.state >= CS_CONNECTED {
            ps = SV_GameClientNum(i)
            Com_sprintf(&player, Int32((player).count), "%i %i \"%s\"\n", ps!.persistant[PERS_SCORE], cl!.ping, cl!.name)
            playerLength = strlen(player)
            if statusLength + playerLength >= Int32((status).count) {
                break // can't hold any more
            }
            strcpy(&status, player, at: statusLength)
            statusLength += playerLength
        }
        i += 1
    }

    NET_OutOfBandPrint(NS_SERVER, from, "statusResponse\n%s\n%s", infostring, status)
}

/**
```
================
SVC_Info

Responds with a short info message that should be enough to determine
if a user is interested in a server to do a full status
================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:381
func SVC_Info(_ from: Netadr) {
    var i: Int32
    var count: Int32
    let wDisable: Int32
    let gamedir: String
    var infostring = CharBuf(1024)

    // ignore if we are in single player
    /*
    if ( Cvar_VariableValue( "g_gametype" ) == GT_SINGLE_PLAYER || Cvar_VariableValue("ui_singlePlayerActive")) {
    return;
    }
    */

    // don't send system link info if in Xbox Live

    if Cvar_VariableValue("ui_singlePlayerActive") != 0 {
        return
    }

    // don't count privateclients
    count = 0
    i = sv_privateClients!.integer
    while i < sv_maxclients!.integer {
        if svs.clientsSlots[i].state >= CS_CONNECTED {
            count += 1
        }
        i += 1
    }

    infostring[0] = 0

    // echo back the parameter to status. so servers can use it as a challenge
    // to prevent timed spoofed reply packets that add ghost servers
    Info_SetValueForKey(&infostring, "challenge", Cmd_Argv(1))

    Info_SetValueForKey(&infostring, "protocol", va("%i", PROTOCOL_VERSION))
    Info_SetValueForKey(&infostring, "hostname", sv_hostname!.string!)
    Info_SetValueForKey(&infostring, "mapname", sv_mapname!.string!)
    Info_SetValueForKey(&infostring, "clients", va("%i", count))
    Info_SetValueForKey(&infostring, "sv_maxclients", va("%i", sv_maxclients!.integer - sv_privateClients!.integer))
    Info_SetValueForKey(&infostring, "gametype", va("%i", sv_gametype!.integer))
    Info_SetValueForKey(&infostring, "needpass", va("%i", sv_needpass!.integer))
    Info_SetValueForKey(&infostring, "truejedi", va("%i", Cvar_VariableIntegerValue("g_jediVmerc")))
    if sv_gametype!.integer == GT_DUEL || sv_gametype!.integer == GT_POWERDUEL {
        wDisable = Cvar_VariableIntegerValue("g_duelWeaponDisable")
    } else {
        wDisable = Cvar_VariableIntegerValue("g_weaponDisable")
    }
    Info_SetValueForKey(&infostring, "wdisable", va("%i", wDisable))
    Info_SetValueForKey(&infostring, "fdisable", va("%i", Cvar_VariableIntegerValue("g_forcePowerDisable")))
    //Info_SetValueForKey( infostring, "pure", va("%i", sv_pure->integer ) );

    if sv_minPing!.integer != 0 {
        Info_SetValueForKey(&infostring, "minPing", va("%i", sv_minPing!.integer))
    }
    if sv_maxPing!.integer != 0 {
        Info_SetValueForKey(&infostring, "maxPing", va("%i", sv_maxPing!.integer))
    }
    gamedir = Cvar_VariableString("fs_game")
    if CharBuf(gamedir)[0] != 0 {
        Info_SetValueForKey(&infostring, "game", gamedir)
    }

    // Include Xbox specific networking info



    NET_OutOfBandPrint(NS_SERVER, from, "infoResponse\n%s", infostring)
}

/**
```
================
SVC_FlushRedirect

================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:477
func SV_FlushRedirect(_ outputbuf: String) {
    NET_OutOfBandPrint(NS_SERVER, svs.redirectAddress, "print\n%s", outputbuf)
}

/**
```
===============
SVC_RemoteCommand

An rcon packet arrived from the network.
Shift down the remaining args
Redirect all printfs
===============
```
*/
/// Raven's `static unsigned int lasttime` of `SVC_RemoteCommand`, a property of `EngineWorld`.
/// Source: oracle/codemp/server/sv_main.cpp:496
var lasttime: UInt32 {
    get { world.lasttime }
    set { world.lasttime = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:490
func SVC_RemoteCommand(_ from: Netadr, _ msg: Msg) {
    let valid: Bool
    var i: UInt32
    let time: UInt32
    var remaining = CharBuf(1024)
    var sv_outputbuf = CharBuf(SV_OUTPUTBUF_LENGTH)

    time = UInt32(bitPattern: Com_Milliseconds())
    // AI: Raven adds in `unsigned int`, which wraps at 32 bits. The sum is `&+`, the same wrap.
    if time < (lasttime &+ 500) {
        return
    }
    lasttime = time

    if strlen(sv_rconPassword!.string!) == 0 || strcmp(Cmd_Argv(1), sv_rconPassword!.string!) != 0 {
        valid = false
        Com_DPrintf("Bad rcon from %s:\n%s\n", NET_AdrToString(from), Cmd_Argv(2))
    } else {
        valid = true
        Com_DPrintf("Rcon from %s:\n%s\n", NET_AdrToString(from), Cmd_Argv(2))
    }

    // start redirecting all print outputs to the packet
    svs.redirectAddress = from
    // AI: Raven hands SV_FlushRedirect, which takes the `char *` buffer. The closure hands the text of the buffer to it.
    Com_BeginRedirect(&sv_outputbuf, SV_OUTPUTBUF_LENGTH, { outputbuf in SV_FlushRedirect(String(outputbuf)) })

    if strlen(sv_rconPassword!.string!) == 0 {
        Com_Printf("No rconpassword set.\n")
    } else if !valid {
        Com_Printf("Bad rconpassword.\n")
    } else {
        remaining[0] = 0

        i = 2
        while i < Cmd_Argc() {
            strcat(&remaining, Cmd_Argv(Int32(bitPattern: i)))
            strcat(&remaining, " ")
            i += 1
        }

        Cmd_ExecuteString(String(remaining))
    }

    Com_EndRedirect()
}

/**
```
=================
SV_ConnectionlessPacket

A connectionless packet has four leading 0xff
characters to distinguish it from a game channel.
Clients that are in the game can still send
connectionless packets.
=================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:545
func SV_ConnectionlessPacket(_ from: Netadr, _ msg: Msg) {
    let s: String
    let c: String

    MSG_BeginReadingOOB(msg)
    MSG_ReadLong(msg) // skip the -1 marker

    // AI: Raven compares the text at `&msg->data[4]` in place. The seven bytes go into a buffer first, and the compare reads the buffer.
    var connect = CharBuf(7)
    Com_Memcpy(&connect, msg.data!.suffix(from: 4), 7)
    if Q_strncmp("connect", connect, 7) == 0 {
        Huff_Decompress(msg, 12)
    }

    s = MSG_ReadStringLine(msg)
    Cmd_TokenizeString(s)

    c = Cmd_Argv(0)
    Com_DPrintf("SV packet %s : %s\n", NET_AdrToString(from), c)

    if Q_stricmp(c, "getstatus") == 0 {
        SVC_Status(from)
    } else if Q_stricmp(c, "getinfo") == 0 {
        SVC_Info(from)
    } else if Q_stricmp(c, "getchallenge") == 0 {
        SV_GetChallenge(from)
    } else if Q_stricmp(c, "connect") == 0 {
        SV_DirectConnect(from)
    } else if Q_stricmp(c, "ipAuthorize") == 0 {
        SV_AuthorizeIpPacket(from)
    } else if Q_stricmp(c, "rcon") == 0 {
        SVC_RemoteCommand(from, msg)
    } else if Q_stricmp(c, "disconnect") == 0 {
        // if a client starts up a local server, we may see some spurious
        // server disconnect messages when their new server sees our final
        // sequenced messages to the old client
    } else {
        Com_DPrintf("bad connectionless packet from %s:\n%s\n", NET_AdrToString(from), s)
    }
}

/**
```
=================
SV_ReadPackets
=================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:594
func SV_PacketEvent(_ from: Netadr, _ msg: Msg) {
    var i: Int32
    var cl: Slots<Client>
    let qport: Int32

    // check for connectionless packet (0xffffffff) first
    if msg.cursize >= 4 && msg.data![int: 0] == -1 {
        SV_ConnectionlessPacket(from, msg)
        return
    }

    // read the qport out of the message so we can fix up
    // stupid address translating routers
    MSG_BeginReadingOOB(msg)
    MSG_ReadLong(msg) // sequence number
    qport = MSG_ReadShort(msg) & 0xffff

    // find which client the message is from
    i = 0
    cl = svs.clientsSlots
    while i < sv_maxclients!.integer {
        if cl[0].state == CS_FREE {
            i += 1
            cl = cl.suffix(from: 1)
            continue
        }
        if !NET_CompareBaseAdr(from, cl[0].netchan.remoteAddress) {
            i += 1
            cl = cl.suffix(from: 1)
            continue
        }
        // it is possible to have multiple clients from a single IP
        // address, so they are differentiated by the qport variable
        if cl[0].netchan.qport != qport {
            i += 1
            cl = cl.suffix(from: 1)
            continue
        }

        // the IP port can't be used to differentiate them, because
        // some address translating routers periodically change UDP
        // port assignments
        if cl[0].netchan.remoteAddress.port != from.port {
            Com_Printf("SV_ReadPackets: fixing up a translated port\n")
            cl[0].netchan.remoteAddress.port = from.port
        }

        // make sure it is a valid, in sequence packet
        if SV_Netchan_Process(cl[0], msg) {
            // zombie clients still need to do the Netchan_Process
            // to make sure they don't need to retransmit the final
            // reliable message, but they don't do any other processing
            if cl[0].state != CS_ZOMBIE {
                cl[0].lastPacketTime = svs.time // don't timeout
                SV_ExecuteClientMessage(cl[0], msg)
            }
        }
        return
    }

    // if we received a sequenced packet from an address we don't reckognize,
    // send an out of band disconnect packet to it
    NET_OutOfBandPrint(NS_SERVER, from, "disconnect")
}

/**
```
===================
SV_CalcPings

Updates the cl->ping variables
===================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:659
func SV_CalcPings() {
    var i: Int32
    var j: Int32
    var cl: Client?
    var total: Int32
    var count: Int32
    var delta: Int32
    var ps: PlayerState?

    i = 0
    while i < sv_maxclients!.integer {
        cl = svs.clientsSlots[i]
        if cl!.state != CS_ACTIVE {
            cl!.ping = 999
            i += 1
            continue
        }
        if cl!.gentity == nil {
            cl!.ping = 999
            i += 1
            continue
        }
        if (cl!.gentity!.r.svFlags & SVF_BOT) != 0 {
            cl!.ping = 0
            i += 1
            continue
        }

        total = 0
        count = 0
        j = 0
        while j < PACKET_BACKUP {
            if cl!.frames[j].messageAcked <= 0 {
                j += 1
                continue
            }
            delta = cl!.frames[j].messageAcked - cl!.frames[j].messageSent
            count += 1
            total += delta
            j += 1
        }
        if count == 0 {
            cl!.ping = 999
        } else {
            cl!.ping = total / count
            if cl!.ping > 999 {
                cl!.ping = 999
            }
        }

        // let the game dll know about the ping
        ps = SV_GameClientNum(i)
        ps!.ping = cl!.ping
        i += 1
    }
}

/**
```
==================
SV_CheckTimeouts

If a packet has not been received from a client for timeout->integer
seconds, drop the conneciton.  Server time is used instead of
realtime to avoid dropping the local client while debugging.

When a client is normally dropped, the client_t goes into a zombie state
for a few seconds to make sure any final reliable message gets resent
if necessary
==================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:719
func SV_CheckTimeouts() {
    var i: Int32
    var cl: Slots<Client>
    let droppoint: Int32
    let zombiepoint: Int32

    droppoint = svs.time - 1000 * sv_timeout!.integer
    zombiepoint = svs.time - 1000 * sv_zombietime!.integer

    i = 0
    cl = svs.clientsSlots
    while i < sv_maxclients!.integer {
        // message times may be wrong across a changelevel
        if cl[0].lastPacketTime > svs.time {
            cl[0].lastPacketTime = svs.time
        }

        if cl[0].state == CS_ZOMBIE && cl[0].lastPacketTime < zombiepoint {
            Com_DPrintf("Going from CS_ZOMBIE to CS_FREE for %s\n", cl[0].name)
            cl[0].state = CS_FREE // can now be reused
            i += 1
            cl = cl.suffix(from: 1)
            continue
        }
        if cl[0].state >= CS_CONNECTED && cl[0].lastPacketTime < droppoint {
            // wait several frames so a debugger session doesn't
            // cause a timeout
            cl[0].timeoutCount += 1
            if cl[0].timeoutCount > 5 {
                SV_DropClient(cl[0], "timed out")
                cl[0].state = CS_FREE // don't bother with zombie state
            }
        } else {
            cl[0].timeoutCount = 0
        }
        i += 1
        cl = cl.suffix(from: 1)
    }
}

/**
```
==================
SV_CheckPaused
==================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:759
func SV_CheckPaused() -> Bool {
    var count: Int32
    var cl: Slots<Client>
    var i: Int32

    if cl_paused!.integer == 0 {
        return false
    }

    // only pause if there is just a single client connected
    count = 0
    i = 0
    cl = svs.clientsSlots
    while i < sv_maxclients!.integer {
        if cl[0].state >= CS_CONNECTED && cl[0].netchan.remoteAddress.type != NA_BOT {
            count += 1
        }
        i += 1
        cl = cl.suffix(from: 1)
    }

    if count > 1 {
        // don't pause
        sv_paused!.integer = 0
        return false
    }

    sv_paused!.integer = 1
    return true
}

/**
```
==================
SV_CheckCvars
==================
```
*/
/// Raven's `static int lastMod` of `SV_CheckCvars`, a property of `EngineWorld`.
/// Source: oracle/codemp/server/sv_main.cpp:792
var lastMod: Int32 {
    get { world.lastMod }
    set { world.lastMod = newValue }
}

/// Source: oracle/codemp/server/sv_main.cpp:791
func SV_CheckCvars() {
    var changed: Bool = false

    if sv_hostname!.modificationCount != lastMod {
        var hostname = CharBuf(MAX_INFO_STRING)
        var c: Int32 = 0
        lastMod = sv_hostname!.modificationCount
        strcpy(&hostname, sv_hostname!.string!)
        while hostname[c] as Int32 != 0 {
            if (hostname[c] == Int32(ascii: "\\")) || (hostname[c] == Int32(ascii: ";")) || (hostname[c] == Int32(ascii: "\"")) {
                hostname[c] = Int32(ascii: ".")
                changed = true
            }
            c += 1
        }
        if changed {
            Cvar_Set("sv_hostname", String(hostname))
        }
    }
}

/**
```
==================
SV_Frame

Player movement occurs as a result of packet events, which
happen before SV_Frame is called
==================
```
*/
/// Source: oracle/codemp/server/sv_main.cpp:826
func SV_Frame(_ msec: Int32) {
    let frameMsec: Int32
    let startTime: Int32

    // the menu kills the server with this cvar
    if sv_killserver!.integer != 0 {
        SV_Shutdown("Server was killed.\n")
        Cvar_Set("sv_killserver", "0")
        return
    }

    if com_sv_running!.integer == 0 {
        return
    }

    // allow pause if only the local client is connected
    if SV_CheckPaused() {
        return
    }

    // if it isn't time for the next frame, do nothing
    if sv_fps!.integer < 1 {
        Cvar_Set("sv_fps", "10")
    }
    frameMsec = 1000 / sv_fps!.integer

    sv.timeResidual += msec

    if com_dedicated!.integer == 0 {
        SV_BotFrame(svs.time + sv.timeResidual)
    }

    if com_dedicated!.integer != 0 && sv.timeResidual < frameMsec && (com_timescale == nil || com_timescale!.value >= 1) {
        // NET_Sleep will give the OS time slices until either get a packet
        // or time enough for a server frame has gone by
        NET_Sleep(frameMsec - sv.timeResidual)
        return
    }

    // if time is about to hit the 32nd bit, kick all clients
    // and clear sv.time, rather
    // than checking for negative time wraparound everywhere.
    // 2giga-milliseconds = 23 days, so it won't be too often
    if svs.time > 0x70000000 {
        SV_Shutdown("Restarting server due to time wrapping")
        //Cbuf_AddText( "vstr nextmap\n" );
        Cbuf_AddText("map_restart 0\n")
        return
    }
    // this can happen considerably earlier when lots of clients play and the map doesn't change
    if svs.nextSnapshotEntities >= 0x7FFFFFFE - svs.numSnapshotEntities {
        SV_Shutdown("Restarting server due to numSnapshotEntities wrapping")
        //Cbuf_AddText( "vstr nextmap\n" );
        Cbuf_AddText("map_restart 0\n")
        return
    }

    if sv.restartTime != 0 && svs.time >= sv.restartTime {
        sv.restartTime = 0
        Cbuf_AddText("map_restart 0\n")
        return
    }

    // update infostrings if anything has been changed
    if (cvar_modifiedFlags & CVAR_SERVERINFO) != 0 {
        SV_SetConfigstring(CS_SERVERINFO, Cvar_InfoString(CVAR_SERVERINFO))
        cvar_modifiedFlags &= ~CVAR_SERVERINFO
    }
    if (cvar_modifiedFlags & CVAR_SYSTEMINFO) != 0 {
        SV_SetConfigstring(CS_SYSTEMINFO, Cvar_InfoString_Big(CVAR_SYSTEMINFO))
        cvar_modifiedFlags &= ~CVAR_SYSTEMINFO
    }

    if com_speeds!.integer != 0 {
        startTime = Sys_Milliseconds()
    } else {
        startTime = 0 // quite a compiler warning
    }

    // update ping based on the all received frames
    SV_CalcPings()

    if com_dedicated!.integer != 0 {
        SV_BotFrame(svs.time)
    }

    // run the game simulation in chunks
    while sv.timeResidual >= frameMsec {
        sv.timeResidual -= frameMsec
        svs.time += frameMsec

        // let everything in the world think and move
        VM_Call(gvm!, GAME_RUN_FRAME, svs.time)
    }

    //rww - RAGDOLL_BEGIN
    G2API_SetTime(svs.time, 0)
    //rww - RAGDOLL_END

    if com_speeds!.integer != 0 {
        time_game = Sys_Milliseconds() - startTime
    }

    // check timeouts
    SV_CheckTimeouts()

    // send messages back to the clients
    SV_SendClientMessages()

    SV_CheckCvars()

    // send a heartbeat to the master if needed
    SV_MasterHeartbeat()
}
