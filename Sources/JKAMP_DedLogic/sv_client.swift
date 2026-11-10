import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/sv_client.cpp:701
// AI: Raven declares `msgBuffer` on the stack of SV_SendClientGameState. The function uses one zeroed allocation on the storage class.
var msgBuffer_SV_SendClientGameState: Slots<JKAShared.byte> { world.storage.msgBuffer_SV_SendClientGameState }

/// Source: oracle/codemp/server/sv_client.cpp:823
// AI: Raven declares `msgBuffer` on the stack of SV_SendClientMapChange. The function uses one zeroed allocation on the storage class.
var msgBuffer_SV_SendClientMapChange: Slots<JKAShared.byte> { world.storage.msgBuffer_SV_SendClientMapChange }

/// Source: oracle/codemp/server/sv_client.cpp:1502
let INFO_CHANGE_MIN_INTERVAL = 6000 as Int32

/// Source: oracle/codemp/server/sv_client.cpp:1503
let INFO_CHANGE_MAX_COUNT = 3 as Int32

/// One row of Raven's `ucmds` table, the `ucmd_t` record with the command function as a Swift function.
/// Source: oracle/codemp/server/sv_client.cpp:1537
private struct UcmdRow: Sendable {
    let name: String
    let `func`: @Sendable (Client) -> Void
}

/// Raven's `static ucmd_t ucmds[]`, the server level client commands in Raven's order.
/// Raven's closing `{NULL, NULL}` row marks the end for his walk, and the Swift array's count takes its place.
/// Source: oracle/codemp/server/sv_client.cpp:1542
private let ucmds: [UcmdRow] = [
    UcmdRow(name: "userinfo", func: SV_UpdateUserinfo_f),
    UcmdRow(name: "disconnect", func: SV_Disconnect_f),
    UcmdRow(name: "cp", func: SV_VerifyPaks_f),
    UcmdRow(name: "vdr", func: SV_ResetPureClient_f),
    UcmdRow(name: "download", func: SV_BeginDownload_f),
    UcmdRow(name: "nextdl", func: SV_NextDownload_f),
    UcmdRow(name: "stopdl", func: SV_StopDownload_f),
    UcmdRow(name: "donedl", func: SV_DoneDownload_f),
]

/**
```
=================
SV_GetChallenge

A "getchallenge" OOB command has been received
Returns a challenge number that can be used
in a subsequent connectResponse command.
We do this to prevent denial of service attacks that
flood the server with invalid connection IPs.  With a
challenge, they must give a valid IP address.

If we are authorizing, a challenge request will cause a packet
to be sent to the authorize server.

When an authorizeip is returned, a challenge response will be
sent to that ip.
=================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:31
func SV_GetChallenge(_ from: Netadr) {
    var i: Int32
    var oldest: Int32
    var oldestTime: Int32
    var challenge: Slots<Challenge>

    // ignore if we are in single player
    /*
    if ( Cvar_VariableValue( "g_gametype" ) == GT_SINGLE_PLAYER || Cvar_VariableValue("ui_singlePlayerActive")) {
    return;
    }
    */
    if Cvar_VariableValue("ui_singlePlayerActive") != 0 {
        return
    }

    oldest = 0
    oldestTime = 0x7fffffff

    // see if we already have a challenge for this ip
    challenge = svs.challenges
    i = 0
    while i < MAX_CHALLENGES {
        if !challenge[0].connected && NET_CompareAdr(from, challenge[0].adr) {
            break
        }
        if challenge[0].time < oldestTime {
            oldestTime = challenge[0].time
            oldest = i
        }
        i += 1
        challenge = challenge.suffix(from: 1)
    }

    if i == MAX_CHALLENGES {
        // this is the first time this client has asked for a challenge
        challenge = svs.challenges.slot(at: oldest)

        challenge[0].challenge = ((rand() << 16) ^ rand()) ^ svs.time
        challenge[0].adr = from
        challenge[0].firstTime = svs.time
        challenge[0].time = svs.time
        challenge[0].connected = false
        i = oldest
    }

    // if they are on a lan address, send the challengeResponse immediately
    if Sys_IsLANAddress(from) {
        challenge[0].pingTime = svs.time
        NET_OutOfBandPrint(NS_SERVER, from, "challengeResponse %i", challenge[0].challenge)
        return
    }

    // look up the authorize server's IP

    // if they have been challenging for a long time and we
    // haven't heard anything from the authoirze server, go ahead and
    // let them in, assuming the id server is down


    // otherwise send their ip to the authorize server


    challenge[0].pingTime = svs.time
    NET_OutOfBandPrint(NS_SERVER, challenge[0].adr, "challengeResponse %i", challenge[0].challenge)
}

/// Source: oracle/codemp/server/sv_client.cpp:142
func SV_AuthorizeIpPacket(_ from: Netadr) {
    let challenge: Int32
    var i: Int32
    let s: String
    let r: String
    var ret = CharBuf(1024)

    if !NET_CompareBaseAdr(from, svs.authorizeAddress) {
        Com_Printf("SV_AuthorizeIpPacket: not from authorize server\n")
        return
    }

    challenge = atoi(Cmd_Argv(1))

    i = 0
    while i < MAX_CHALLENGES {
        if svs.challenges[i].challenge == challenge {
            break
        }
        i += 1
    }
    if i == MAX_CHALLENGES {
        Com_Printf("SV_AuthorizeIpPacket: challenge not found\n")
        return
    }

    // send a packet back to the original client
    svs.challenges[i].pingTime = svs.time
    s = Cmd_Argv(2)
    r = Cmd_Argv(3) // reason

    if Q_stricmp(s, "demo") == 0 {
        if Cvar_VariableValue("fs_restrict") != 0 {
            // a demo client connecting to a demo server
            NET_OutOfBandPrint(NS_SERVER, svs.challenges[i].adr, "challengeResponse %i", svs.challenges[i].challenge)
            return
        }
        // they are a demo client trying to connect to a real server
        NET_OutOfBandPrint(NS_SERVER, svs.challenges[i].adr, "print\nServer is not a demo server\n")
        // clear the challenge record so it won't timeout and let them through
        svs.challenges[i].clear()
        return
    }
    if Q_stricmp(s, "accept") == 0 {
        NET_OutOfBandPrint(NS_SERVER, svs.challenges[i].adr, "challengeResponse %i", svs.challenges[i].challenge)
        return
    }
    if Q_stricmp(s, "unknown") == 0 {
        strcpy(&ret, JKAShared.format("print\n%s\n", [r]))
        NET_OutOfBandPrint(NS_SERVER, svs.challenges[i].adr, String(ret))
        // clear the challenge record so it won't timeout and let them through
        svs.challenges[i].clear()
        return
    }

    // authorization failed
    strcpy(&ret, JKAShared.format("print\n%s\n", [r]))
    NET_OutOfBandPrint(NS_SERVER, svs.challenges[i].adr, String(ret))

    // clear the challenge record so it won't timeout and let them through
    svs.challenges[i].clear()
}

/**
```
==================
SV_DirectConnect

A "connect" OOB command has been received
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:221
func SV_DirectConnect(_ from: Netadr) {
    var userinfo = CharBuf(MAX_INFO_STRING)
    var i: Int32 = 0
    var cl: Client?
    var newcl: Client?
    var ent: SharedEntity?
    var clientNum: Int32 = 0
    var version: Int32 = 0
    var qport: Int32 = 0
    var challenge: Int32 = 0
    var password = ""
    var startIndex: Int32 = 0
    var denied: String?
    var count: Int32 = 0
    var reconnect = false

    // Raven's record lives to the end of his block, so the block is the closure.
    Client.scratch { temp in
        Com_DPrintf("SVC_DirectConnect ()\n")

        Q_strncpyz(&userinfo, Cmd_Argv(1), Int32(userinfo.count))

        version = atoi(Info_ValueForKey(String(userinfo), "protocol"))
        if version != PROTOCOL_VERSION {
            NET_OutOfBandPrint(NS_SERVER, from, "print\nServer uses protocol version %i.\n", PROTOCOL_VERSION)
            Com_DPrintf("    rejected connect from version %i\n", version)
            return
        }

        challenge = atoi(Info_ValueForKey(String(userinfo), "challenge"))
        qport = atoi(Info_ValueForKey(String(userinfo), "qport"))

        // quick reject
        i = 0
        while i < sv_maxclients!.integer {
            cl = svs.clientsSlots[i]

/* This was preventing sv_reconnectlimit from working.  It seems like commenting this
   out has solved the problem.  HOwever, if there is a future problem then it could
   be this.

            if ( cl->state == CS_FREE ) {
                continue;
            }
*/

            if NET_CompareBaseAdr(from, cl!.netchan.remoteAddress)
                && (cl!.netchan.qport == qport
                || from.port == cl!.netchan.remoteAddress.port) {
                if (svs.time - cl!.lastConnectTime)
                    < (sv_reconnectlimit!.integer * 1000) {
                    NET_OutOfBandPrint(NS_SERVER, from, "print\nReconnect rejected : too soon\n")
                    Com_DPrintf("%s:reconnect rejected : too soon\n", NET_AdrToString(from))
                    return
                }
                break
            }
            i += 1
        }

        // see if the challenge is valid (LAN clients don't need to challenge)
        if !NET_IsLocalAddress(from) {
            var ping: Int32 = 0

            i = 0
            while i < MAX_CHALLENGES {
                if NET_CompareAdr(from, svs.challenges[i].adr) {
                    if challenge == svs.challenges[i].challenge {
                        break // good
                    }
                }
                i += 1
            }
            if i == MAX_CHALLENGES {
                NET_OutOfBandPrint(NS_SERVER, from, "print\nNo or bad challenge for address.\n")
                return
            }
            // force the IP key/value pair so the game can filter based on ip
            Info_SetValueForKey(&userinfo, "ip", NET_AdrToString(from))

            ping = svs.time - svs.challenges[i].pingTime
            Com_Printf(SE_GetString("MP_SVGAME", "CLIENT_CONN_WITH_PING"), i, ping) //"Client %i connecting with %i challenge ping\n", i, ping );
            svs.challenges[i].connected = true

            // never reject a LAN client based on ping
            if !Sys_IsLANAddress(from) {
                if sv_minPing!.value != 0 && ping < sv_minPing!.value {
                    // don't let them keep trying until they get a big delay
                    NET_OutOfBandPrint(NS_SERVER, from, va("print\n%s\n", SE_GetString("MP_SVGAME", "SERVER_FOR_HIGH_PING"))) //Server is for high pings only\n" );
                    Com_DPrintf(SE_GetString("MP_SVGAME", "CLIENT_REJECTED_LOW_PING"), i) //"Client %i rejected on a too low ping\n", i);
                    // reset the address otherwise their ping will keep increasing
                    // with each connect message and they'd eventually be able to connect
                    svs.challenges[i].adr.port = 0
                    return
                }
                if sv_maxPing!.value != 0 && ping > sv_maxPing!.value {
                    NET_OutOfBandPrint(NS_SERVER, from, va("print\n%s\n", SE_GetString("MP_SVGAME", "SERVER_FOR_LOW_PING"))) //Server is for low pings only\n" );
                    Com_DPrintf(SE_GetString("MP_SVGAME", "CLIENT_REJECTED_HIGH_PING"), i) //"Client %i rejected on a too high ping\n", i);
                    return
                }
            }
        } else {
            // force the "ip" info key to "localhost"
            Info_SetValueForKey(&userinfo, "ip", "localhost")
        }

        newcl = temp
        newcl!.clear()

        // if there is already a slot for this ip, reuse it
        i = 0
        while i < sv_maxclients!.integer {
            cl = svs.clientsSlots[i]
            if cl!.state == CS_FREE {
                i += 1
                continue
            }
            if NET_CompareBaseAdr(from, cl!.netchan.remoteAddress)
                && (cl!.netchan.qport == qport
                || from.port == cl!.netchan.remoteAddress.port) {
                Com_Printf("%s:reconnect\n", NET_AdrToString(from))
                newcl = cl
                reconnect = true
                // VVFIXME - both SOF2 and Wolf remove this call, claiming it blows away the user's info
                // disconnect the client from the game first so any flags the
                // player might have are dropped
                VM_Call(gvm!, GAME_CLIENT_DISCONNECT, svs.clientsSlots.index(of: newcl!))
                //
                break
            }
            i += 1
        }

        // Port-note: goto gotnewcl. Raven jumps past the slot search when the reconnect loop sets `reconnect`, so the search runs under `!reconnect`.
        if !reconnect {
            // find a client slot
            // if "sv_privateClients" is set > 0, then that number
            // of client slots will be reserved for connections that
            // have "password" set to the value of "sv_privatePassword"
            // Info requests will report the maxclients as if the private
            // slots didn't exist, to prevent people from trying to connect
            // to a full server.
            // This is to allow us to reserve a couple slots here on our
            // servers so we can play without having to kick people.

            // check for privateClient password
            password = Info_ValueForKey(String(userinfo), "password")
            if strcmp(password, sv_privatePassword!.string!) == 0 {
                startIndex = 0
            } else {
                // skip past the reserved slots
                startIndex = sv_privateClients!.integer
            }

            newcl = nil
            i = startIndex
            while i < sv_maxclients!.integer {
                cl = svs.clientsSlots[i]
                if cl!.state == CS_FREE {
                    newcl = cl
                    break
                }
                i += 1
            }

            if newcl == nil {
                if NET_IsLocalAddress(from) {
                    count = 0
                    i = startIndex
                    while i < sv_maxclients!.integer {
                        cl = svs.clientsSlots[i]
                        if cl!.netchan.remoteAddress.type == NA_BOT {
                            count += 1
                        }
                        i += 1
                    }
                    // if they're all bots
                    if count >= sv_maxclients!.integer - startIndex {
                        SV_DropClient(svs.clientsSlots[sv_maxclients!.integer - 1], "only bots on server")
                        newcl = svs.clientsSlots[sv_maxclients!.integer - 1]
                    } else {
                        Com_Error(ERR_FATAL, "server is full on local connect\n")
                    }
                } else {
                    NET_OutOfBandPrint(NS_SERVER, from, va("print\n%s\n", SV_GetStringEdString("MP_SVGAME", "SERVER_IS_FULL")))
                    Com_DPrintf("Rejected a connection.\n")
                    return
                }
            }

            // we got a newcl, so reset the reliableSequence and reliableAcknowledge
            cl!.reliableAcknowledge = 0
            cl!.reliableSequence = 0
        }

        // gotnewcl:

        // build a new connection
        // accept the new client
        // this is the only place a client_t is ever initialized
        newcl!.copy(from: temp)
        clientNum = svs.clientsSlots.index(of: newcl!)
        ent = SV_GentityNum(clientNum)
        newcl!.gentity = ent

        // save the challenge
        newcl!.challenge = challenge

        // save the address
        Netchan_Setup(NS_SERVER, newcl!.netchan, from, qport)

        // save the userinfo
        Q_strncpyz(&newcl!.userinfoBuffer, String(userinfo), Int32(newcl!.userinfoBuffer.count))

        // get the game a chance to reject this connection or modify the userinfo
        // AI: Raven stores the word of VM_Call in the `char *` local `denied` and tests it.
        // The body tests the word in `deniedWord`, and `denied` holds the text that VM_ExplicitArgPtr gives.
        let deniedWord = VM_Call(gvm!, GAME_CLIENT_CONNECT, clientNum, true, false) // firstTime = qtrue
        if deniedWord != 0 {
            // we can't just use VM_ArgPtr, because that is only valid inside a VM_Call
            denied = VM_ExplicitArgPtr(gvm!, deniedWord)

            NET_OutOfBandPrint(NS_SERVER, from, "print\n%s\n", denied ?? "(null)")
            Com_DPrintf("Game rejected a connection: %s.\n", denied ?? "(null)")
            return
        }

        SV_UserinfoChanged(newcl!)

        // update the advertised session
        //

        // send the connect packet to the client
        NET_OutOfBandPrint(NS_SERVER, from, "connectResponse")

        Com_DPrintf("Going from CS_FREE to CS_CONNECTED for %s\n", newcl!.name)

        newcl!.state = CS_CONNECTED
        newcl!.nextSnapshotTime = svs.time
        newcl!.lastPacketTime = svs.time
        newcl!.lastConnectTime = svs.time

        // when we receive the first packet from the client, we will
        // notice that it is from a different serverid and that the
        // gamestate message was not just sent, forcing a retransmit
        newcl!.gamestateMessageNum = -1

        newcl!.lastUserInfoChange = 0 //reset the delay
        newcl!.lastUserInfoCount = 0 //reset the count

        // if this was the first client on the server, or the last client
        // the server can hold, send a heartbeat to the master.
        count = 0
        i = 0
        while i < sv_maxclients!.integer {
            if svs.clientsSlots[i].state >= CS_CONNECTED {
                count += 1
            }
            i += 1
        }
        if count == 1 || count == sv_maxclients!.integer {
            SV_Heartbeat_f()
        }
    }
}

/**
```
=====================
SV_DropClient

Called when the player is totally leaving the server, either willingly
or unwillingly.  This is NOT called if the entire server is quiting
or crashing -- SV_FinalMessage() will handle that
=====================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:580
func SV_DropClient(_ drop: Client, _ reason: String) {
    var i: Int32
    var challenge: Slots<Challenge>

    if drop.state == CS_ZOMBIE {
        return // already dropped
    }

    if drop.gentity == nil || !((drop.gentity!.r.svFlags & SVF_BOT) != 0) {
        // see if we already have a challenge for this ip
        challenge = svs.challenges

        i = 0
        while i < MAX_CHALLENGES {
            if NET_CompareAdr(drop.netchan.remoteAddress, challenge[0].adr) {
                challenge[0].connected = false
                break
            }
            i += 1
            challenge = challenge.suffix(from: 1)
        }
    }

    // Tells all clients to remove the dropped player from their list, if not a bot

    // update the advertised session

    // Kill any download
    SV_CloseDownload(drop)

    // tell everyone why they got dropped
    SV_SendServerCommand(nil, "print \"%s" + S_COLOR_WHITE + " %s\n\"", drop.name, reason)

    Com_DPrintf("Going to CS_ZOMBIE for %s\n", drop.name)
    drop.state = CS_ZOMBIE // become free in a few seconds

    if drop.download != 0 {
        FS_FCloseFile(drop.download)
        drop.download = 0
    }

    // call the prog function for removing a client
    // this will remove the body, among other things
    VM_Call(gvm!, GAME_CLIENT_DISCONNECT, svs.clientsSlots.index(of: drop))

    // add the disconnect command
    SV_SendServerCommand(drop, va("disconnect \"%s\"", reason))

    if drop.netchan.remoteAddress.type == NA_BOT {
        SV_BotFreeClient(svs.clientsSlots.index(of: drop))
    }

    // nuke user info
    SV_SetUserinfo(svs.clientsSlots.index(of: drop), "")

    // if this was the last client on the server, send a heartbeat
    // to the master so it is known the server is empty
    // send a heartbeat now so the master will get up to date info
    // if there is already a slot for this ip, reuse it
    i = 0
    while i < sv_maxclients!.integer {
        if svs.clientsSlots[i].state >= CS_CONNECTED {
            break
        }
        i += 1
    }
    if i == sv_maxclients!.integer {
        SV_Heartbeat_f()
    }
}

/// Source: oracle/codemp/server/sv_client.cpp:668
func SV_WriteRMGAutomapSymbols(_ msg: Msg) {
    // Port-note: Row C. TheRandomMissionManager is an instance of the C++ class CRMManager, which has no port.
    // Raven wrote: int count = TheRandomMissionManager->GetAutomapSymbolCount ( ); ... MSG_WriteShort ( msg, count ); for ( i = 0; i < count; i ++ ) { ... }
    portMissing("SV_WriteRMGAutomapSymbols", source: "oracle/codemp/server/sv_client.cpp:668")
}

/**
```
================
SV_SendClientGameState

Sends the first message from the server to a connected client.
This will be sent on the initial connection and upon each new map load.

It will be resent if the client acknowledges a later message but has
the wrong gamestate.
================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:697
func SV_SendClientGameState(_ client: Client) {
    var start: Int32 = 0
    var base: EntityState?
    // Raven's records live to the end of his block, so the block is the two closures.
    EntityState.scratch { nullstate in
    Msg.scratch { msg in

        // MW - my attempt to fix illegible server message errors caused by
        // packet fragmentation of initial snapshot.
        while client.state != 0 && client.netchan.unsentFragments {
            // send additional message fragments if the last message
            // was too large to send at once

            Com_Printf("[ISM]SV_SendClientGameState() [2] for %s, writing out old fragments\n", client.name)
            SV_Netchan_TransmitNextFragment(client.netchan)
        }

        Com_DPrintf("SV_SendClientGameState() for %s\n", client.name)
        Com_DPrintf("Going from CS_CONNECTED to CS_PRIMED for %s\n", client.name)
        client.state = CS_PRIMED
        client.pureAuthentic = 0

        // when we receive the first packet from the client, we will
        // notice that it is from a different serverid and that the
        // gamestate message was not just sent, forcing a retransmit
        client.gamestateMessageNum = client.netchan.outgoingSequence

        MSG_Init(msg, msgBuffer_SV_SendClientGameState, Int32(msgBuffer_SV_SendClientGameState.count))

        // NOTE, MRE: all server->client messages now acknowledge
        // let the client know which reliable clientCommands we have received
        MSG_WriteLong(msg, client.lastClientCommand)

        // send any server commands waiting to be sent first.
        // we have to do this cause we send the client->reliableSequence
        // with a gamestate and it sets the clc.serverCommandSequence at
        // the client side
        SV_UpdateServerCommandsToClient(client, msg)

        // send the gamestate
        MSG_WriteByte(msg, svc_gamestate)
        MSG_WriteLong(msg, client.reliableSequence)

        // write the configstrings
        start = 0
        while start < MAX_CONFIGSTRINGS {
            if !sv.configstrings[start]!.isEmpty {
                MSG_WriteByte(msg, svc_configstring)
                MSG_WriteShort(msg, start)
                MSG_WriteBigString(msg, sv.configstrings[start]!)
            }
            start += 1
        }

        // write the baselines
        // Raven clears the record with `Com_Memset` here. The scratch slot is zero at entry, so the body drops the call.
        start = 0
        while start < MAX_GENTITIES {
            base = sv.svEntities[start].baseline
            if base!.number == 0 {
                start += 1
                continue
            }
            MSG_WriteByte(msg, svc_baseline)
            MSG_WriteDeltaEntity(msg, nullstate, base, true)
            start += 1
        }

        MSG_WriteByte(msg, svc_EOF)

        MSG_WriteLong(msg, svs.clientsSlots.index(of: client))

        // write the checksum feed
        MSG_WriteLong(msg, sv.checksumFeed)

        //rwwRMG - send info for the terrain
        // Port-note: Row C. TheRandomMissionManager is an instance of the C++ class CRMManager, which has no port, so Raven's test of it has no form.
        // Raven wrote: if ( TheRandomMissionManager ) { z_stream zdata; // Send the height map memset(&zdata, 0, sizeof(z_stream)); deflateInit ( &zdata, Z_MAX_COMPRESSION ); unsigned char heightmap[15000]; zdata.next_out = (unsigned char*)heightmap; zdata.avail_out = 15000; zdata.next_in = TheRandomMissionManager->GetLandScape()->GetHeightMap(); zdata.avail_in = TheRandomMissionManager->GetLandScape()->GetRealArea(); deflate(&zdata, Z_SYNC_FLUSH); MSG_WriteShort ( &msg, (unsigned short)zdata.total_out ); MSG_WriteBits ( &msg, 1, 1 ); MSG_WriteData ( &msg, heightmap, zdata.total_out); deflateEnd(&zdata); // Send the flatten map memset(&zdata, 0, sizeof(z_stream)); deflateInit ( &zdata, Z_MAX_COMPRESSION ); zdata.next_out = (unsigned char*)heightmap; zdata.avail_out = 15000; zdata.next_in = TheRandomMissionManager->GetLandScape()->GetFlattenMap(); zdata.avail_in = TheRandomMissionManager->GetLandScape()->GetRealArea(); deflate(&zdata, Z_SYNC_FLUSH); MSG_WriteShort ( &msg, (unsigned short)zdata.total_out ); MSG_WriteBits ( &msg, 1, 1 ); MSG_WriteData ( &msg, heightmap, zdata.total_out); deflateEnd(&zdata); // Seed is needed for misc ents and noise MSG_WriteLong ( &msg, TheRandomMissionManager->GetLandScape()->get_rand_seed ( ) ); SV_WriteRMGAutomapSymbols ( &msg ); } else { MSG_WriteShort ( &msg, 0 ); }
        portMissing("SV_SendClientGameState", source: "oracle/codemp/server/sv_client.cpp:697")

        // deliver this to the client
        SV_SendMessageToClient(msg, client)
    }
    }
}

/// Source: oracle/codemp/server/sv_client.cpp:820
func SV_SendClientMapChange(_ client: Client) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Msg.scratch { msg in
        MSG_Init(msg, msgBuffer_SV_SendClientMapChange, Int32(msgBuffer_SV_SendClientMapChange.count))

        // NOTE, MRE: all server->client messages now acknowledge
        // let the client know which reliable clientCommands we have received
        MSG_WriteLong(msg, client.lastClientCommand)

        // send any server commands waiting to be sent first.
        // we have to do this cause we send the client->reliableSequence
        // with a gamestate and it sets the clc.serverCommandSequence at
        // the client side
        SV_UpdateServerCommandsToClient(client, msg)

        // send the gamestate
        MSG_WriteByte(msg, svc_mapchange)

        // deliver this to the client
        SV_SendMessageToClient(msg, client)
    }
}

/**
```
==================
SV_ClientEnterWorld
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:943
func SV_ClientEnterWorld(_ client: Client, _ cmd: JKAMP.Usercmd) {
    let clientNum: Int32
    var ent: SharedEntity?

    Com_DPrintf("Going from CS_PRIMED to CS_ACTIVE for %s\n", client.name)
    client.state = CS_ACTIVE

    //update XbOnlineInfo with client

    // set up the entity for the client
    clientNum = svs.clientsSlots.index(of: client)
    ent = SV_GentityNum(clientNum)
    ent!.s.number = clientNum
    client.gentity = ent

    client.lastUserInfoChange = 0 //reset the delay
    client.lastUserInfoCount = 0 //reset the count

    client.deltaMessage = -1
    client.nextSnapshotTime = svs.time // generate a snapshot immediately
    client.lastUsercmd = cmd

    // call the game begin function
    VM_Call(gvm!, GAME_CLIENT_BEGIN, svs.clientsSlots.index(of: client))
}

/// Source: oracle/codemp/server/sv_client.cpp:988
private func SV_CloseDownload(_ cl: Client) {
    var i: Int32

    // EOF
    if cl.download != 0 {
        FS_FCloseFile(cl.download)
    }
    cl.download = 0
    cl.downloadNameBuffer[0] = 0

    // Free the temporary buffer space
    i = 0
    while i < MAX_DOWNLOAD_WINDOW {
        if cl.downloadBlocks[i] != nil {
            Z_Free(OpaquePointer(cl.downloadBlocks[i]!.base))
            cl.downloadBlocks[i] = nil
        }
        i += 1
    }
}

/**
```
==================
SV_StopDownload_f

Abort a download if in progress
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1015
func SV_StopDownload_f(_ cl: Client) {
    if cl.downloadNameBuffer[0] != 0 {
        Com_DPrintf("clientDownload: %d : file \"%s\" aborted\n", svs.clientsSlots.index(of: cl), cl.downloadName)
    }

    SV_CloseDownload(cl)
}

/**
```
==================
SV_DoneDownload_f

Downloads are finished
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1029
func SV_DoneDownload_f(_ cl: Client) {
    Com_DPrintf("clientDownload: %s Done\n", cl.name)
    // resend the game state to update any clients that entered during the download
    SV_SendClientGameState(cl)
}

/**
```
==================
SV_NextDownload_f

The argument will be the last acknowledged block from the client, it should be
the same as cl->downloadClientBlock
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1043
func SV_NextDownload_f(_ cl: Client) {
    let block: Int32 = atoi(Cmd_Argv(1))

    if block == cl.downloadClientBlock {
        Com_DPrintf("clientDownload: %d : client acknowledge of block %d\n", svs.clientsSlots.index(of: cl), block)

        // Find out if we are done.  A zero-length block indicates EOF
        if cl.downloadBlockSize[cl.downloadClientBlock % MAX_DOWNLOAD_WINDOW] == 0 {
            Com_Printf("clientDownload: %d : file \"%s\" completed\n", svs.clientsSlots.index(of: cl), cl.downloadName)
            SV_CloseDownload(cl)
            return
        }

        cl.downloadSendTime = svs.time
        cl.downloadClientBlock += 1
        return
    }
    // We aren't getting an acknowledge for the correct block, drop the client
    // FIXME: this is bad... the client will never parse the disconnect message
    //			because the cgame isn't loaded yet
    SV_DropClient(cl, "broken download")
}

/**
```
==================
SV_BeginDownload_f
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1072
func SV_BeginDownload_f(_ cl: Client) {
    // Kill any existing download
    SV_CloseDownload(cl)

    // cl->downloadName is non-zero now, SV_WriteDownloadToClient will see this and open
    // the file itself
    Q_strncpyz(&cl.downloadNameBuffer, Cmd_Argv(1), 64)
}

/**
```
==================
SV_WriteDownloadToClient

Check to see if the client wants a file, open it if needed and start pumping the client
Fill up msg with data
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1090
func SV_WriteDownloadToClient(_ cl: Client, _ msg: Msg) {
    var curindex: Int32
    var rate: Int32
    var blockspersnap: Int32
    let idPack: Int32
    let missionPack: Int32
    var errorMessage = CharBuf(1024)

    if cl.downloadNameBuffer[0] == 0 {
        return // Nothing being downloaded
    }

    if cl.download == 0 {
        // We open the file here

        Com_Printf("clientDownload: %d : begining \"%s\"\n", svs.clientsSlots.index(of: cl), cl.downloadName)

        missionPack = (FS_idPak(cl.downloadName, "missionpack") ? 1 : 0)
        idPack = (missionPack != 0 || FS_idPak(cl.downloadName, "base") ? 1 : 0)

        // Raven stores the file size inside his test, on the arm that runs when the first two tests fail, so the store runs on that arm here.
        var cannotDownload = sv_allowDownload!.integer == 0 || idPack != 0
        if !cannotDownload {
            cl.downloadSize = FS_SV_FOpenFileRead(cl.downloadName, &cl.download)
            cannotDownload = cl.downloadSize <= 0
        }
        if cannotDownload {
            // cannot auto-download file
            if idPack != 0 {
                Com_Printf("clientDownload: %d : \"%s\" cannot download id pk3 files\n", svs.clientsSlots.index(of: cl), cl.downloadName)
                if missionPack != 0 {
                    Com_sprintf(&errorMessage, Int32(errorMessage.count), "Cannot autodownload Team Arena file \"%s\"\n" + "The Team Arena mission pack can be found in your local game store.", cl.downloadName)
                } else {
                    Com_sprintf(&errorMessage, Int32(errorMessage.count), "Cannot autodownload id pk3 file \"%s\"", cl.downloadName)
                }
            } else if sv_allowDownload!.integer == 0 {
                Com_Printf("clientDownload: %d : \"%s\" download disabled", svs.clientsSlots.index(of: cl), cl.downloadName)
                if sv_pure!.integer != 0 {
                    Com_sprintf(&errorMessage, Int32(errorMessage.count), "Could not download \"%s\" because autodownloading is disabled on the server.\n\n" + "You will need to get this file elsewhere before you " + "can connect to this pure server.\n", cl.downloadName)
                } else {
                    Com_sprintf(&errorMessage, Int32(errorMessage.count), "Could not download \"%s\" because autodownloading is disabled on the server.\n\n" + "Set autodownload to No in your settings and you might be " + "able to connect if you do have the file.\n", cl.downloadName)
                }
            } else {
                Com_Printf("clientDownload: %d : \"%s\" file not found on server\n", svs.clientsSlots.index(of: cl), cl.downloadName)
                Com_sprintf(&errorMessage, Int32(errorMessage.count), "File \"%s\" not found on server for autodownloading.\n", cl.downloadName)
            }
            MSG_WriteByte(msg, svc_download)
            MSG_WriteShort(msg, 0) // client is expecting block zero
            MSG_WriteLong(msg, -1) // illegal file size
            MSG_WriteString(msg, String(errorMessage))

            cl.downloadNameBuffer[0] = 0
            return
        }

        // Init
        cl.downloadXmitBlock = 0
        cl.downloadClientBlock = cl.downloadXmitBlock
        cl.downloadCurrentBlock = cl.downloadClientBlock
        cl.downloadCount = 0
        cl.downloadEOF = false
    }

    // Perform any reads that we need to
    while cl.downloadCurrentBlock - cl.downloadClientBlock < MAX_DOWNLOAD_WINDOW && cl.downloadSize != cl.downloadCount {
        curindex = (cl.downloadCurrentBlock % MAX_DOWNLOAD_WINDOW)

        if cl.downloadBlocks[curindex] == nil {
            // Port-note: Row G13. `downloadBlocks` of client_t holds `unsigned char *` blocks as handles, so the Z_Malloc block has no byte form.
            // Raven wrote: cl->downloadBlocks[curindex] = (unsigned char *)Z_Malloc( MAX_DOWNLOAD_BLKSIZE, TAG_DOWNLOAD, qtrue )
            portMissing("SV_WriteDownloadToClient", source: "oracle/codemp/server/sv_client.cpp:1090")
        }

        // Port-note: Row G13. FS_Read takes a Slots of bytes, and `downloadBlocks` of client_t holds each block as a handle with no byte form.
        // Raven wrote: cl->downloadBlockSize[curindex] = FS_Read( cl->downloadBlocks[curindex], MAX_DOWNLOAD_BLKSIZE, cl->download )
        portMissing("SV_WriteDownloadToClient", source: "oracle/codemp/server/sv_client.cpp:1090")

        if cl.downloadBlockSize[curindex] < 0 {
            // EOF right now
            cl.downloadCount = cl.downloadSize
            break
        }

        cl.downloadCount += cl.downloadBlockSize[curindex]

        // Load in next block
        cl.downloadCurrentBlock += 1
    }

    // Check to see if we have eof condition and add the EOF block
    if cl.downloadCount == cl.downloadSize && !cl.downloadEOF && cl.downloadCurrentBlock - cl.downloadClientBlock < MAX_DOWNLOAD_WINDOW {
        cl.downloadBlockSize[cl.downloadCurrentBlock % MAX_DOWNLOAD_WINDOW] = 0
        cl.downloadCurrentBlock += 1

        cl.downloadEOF = true // We have added the EOF block
    }

    // Loop up to window size times based on how many blocks we can fit in the
    // client snapMsec and rate

    // based on the rate, how many bytes can we fit in the snapMsec time of the client
    // normal rate / snapshotMsec calculation
    rate = cl.rate
    if sv_maxRate!.integer != 0 {
        if sv_maxRate!.integer < 1000 {
            Cvar_Set("sv_MaxRate", "1000")
        }
        if sv_maxRate!.integer < rate {
            rate = sv_maxRate!.integer
        }
    }

    if rate == 0 {
        blockspersnap = 1
    } else {
        blockspersnap = ((rate * cl.snapshotMsec) / 1000 + MAX_DOWNLOAD_BLKSIZE) / MAX_DOWNLOAD_BLKSIZE
    }

    if blockspersnap < 0 {
        blockspersnap = 1
    }

    while true {
        let blocksBefore = blockspersnap
        blockspersnap -= 1
        if blocksBefore == 0 {
            break
        }

        // Write out the next section of the file, if we have already reached our window,
        // automatically start retransmitting

        if cl.downloadClientBlock == cl.downloadCurrentBlock {
            return // Nothing to transmit
        }

        if cl.downloadXmitBlock == cl.downloadCurrentBlock {
            // We have transmitted the complete window, should we start resending?

            //FIXME:  This uses a hardcoded one second timeout for lost blocks
            //the timeout should be based on client rate somehow
            if svs.time - cl.downloadSendTime > 1000 {
                cl.downloadXmitBlock = cl.downloadClientBlock
            } else {
                return
            }
        }

        // Send current block
        curindex = (cl.downloadXmitBlock % MAX_DOWNLOAD_WINDOW)

        MSG_WriteByte(msg, svc_download)
        MSG_WriteShort(msg, cl.downloadXmitBlock)

        // block zero is special, contains file size
        if cl.downloadXmitBlock == 0 {
            MSG_WriteLong(msg, cl.downloadSize)
        }

        MSG_WriteShort(msg, cl.downloadBlockSize[curindex])

        // Write the block
        if cl.downloadBlockSize[curindex] != 0 {
            // Port-note: Row G13. `downloadBlocks` of client_t holds the blocks as handles, and MSG_WriteData takes a Slots of bytes.
            // Raven wrote: MSG_WriteData( msg, cl->downloadBlocks[curindex], cl->downloadBlockSize[curindex] );
            portMissing("SV_WriteDownloadToClient", source: "oracle/codemp/server/sv_client.cpp:1090")
        }

        Com_DPrintf("clientDownload: %d : writing block %d\n", svs.clientsSlots.index(of: cl), cl.downloadXmitBlock)

        // Move on to the next block
        // It will get sent with next snap shot.  The rate will keep us in line.
        cl.downloadXmitBlock += 1

        cl.downloadSendTime = svs.time
    }
}

/// Source: oracle/codemp/server/sv_client.cpp:1265
private func SV_Disconnect_f(_ cl: Client) {
    //	SV_DropClient( cl, "disconnected" );
    SV_DropClient(cl, SV_GetStringEdString("MP_SVGAME", "DISCONNECTED"))
}

/**
```
=================
SV_VerifyPaks_f

If we are pure, disconnect the client if they do no meet the following conditions:

1. the first two checksums match our view of cgame and ui
2. there are no any additional checksums that we do not have

This routine would be a bit simpler with a goto but i abstained

=================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1283
private func SV_VerifyPaks_f(_ cl: Client) {
    var nChkSum1: Int32 = 0
    var nChkSum2: Int32 = 0
    var nClientPaks: Int32
    var nServerPaks: Int32
    var i: Int32
    var j: Int32
    var nCurArg: Int32
    var nClientChkSum: [Int32] = [Int32](repeating: 0, count: 1024)
    var nServerChkSum: [Int32] = [Int32](repeating: 0, count: 1024)
    var pPaks: String
    var pArg: String
    var bGood: Bool = true

    // if we are pure, we "expect" the client to load certain things from
    // certain pk3 files, namely we want the client to have loaded the
    // ui and cgame that we think should be loaded based on the pure setting
    //
    if sv_pure!.integer != 0 {
        bGood = true
        nChkSum2 = 0
        nChkSum1 = nChkSum2
        // we run the game, so determine which cgame and ui the client "should" be running
        //dlls are valid too now -rww
        if Cvar_VariableValue("vm_cgame") != 0 {
            bGood = Bool((FS_FileIsInPAK("vm/cgame.qvm", &nChkSum1) == 1))
        } else {
            bGood = Bool((FS_FileIsInPAK("cgamex86.dll", &nChkSum1) == 1))
        }

        if bGood {
            if Cvar_VariableValue("vm_ui") != 0 {
                bGood = Bool((FS_FileIsInPAK("vm/ui.qvm", &nChkSum2) == 1))
            } else {
                bGood = Bool((FS_FileIsInPAK("uix86.dll", &nChkSum2) == 1))
            }
        }

        nClientPaks = Cmd_Argc()

        // start at arg 1 ( skip cl_paks )
        nCurArg = 1

        // we basically use this while loop to avoid using 'goto' :)
        while bGood {
            // must be at least 6: "cl_paks cgame ui @ firstref ... numChecksums"
            // numChecksums is encoded
            if nClientPaks < 6 {
                bGood = false
                break
            }
            // verify first to be the cgame checksum
            pArg = Cmd_Argv(nCurArg)
            nCurArg += 1
            if CharBuf(pArg)[0] == Int32(ascii: "@") || atoi(pArg) != nChkSum1 {
                bGood = false
                break
            }
            // verify the second to be the ui checksum
            pArg = Cmd_Argv(nCurArg)
            nCurArg += 1
            if CharBuf(pArg)[0] == Int32(ascii: "@") || atoi(pArg) != nChkSum2 {
                bGood = false
                break
            }
            // should be sitting at the delimeter now
            pArg = Cmd_Argv(nCurArg)
            nCurArg += 1
            if CharBuf(pArg)[0] != Int32(ascii: "@") {
                bGood = false
                break
            }
            // store checksums since tokenization is not re-entrant
            i = 0
            while nCurArg < nClientPaks {
                nClientChkSum[i] = atoi(Cmd_Argv(nCurArg))
                nCurArg += 1
                i += 1
            }

            // store number to compare against (minus one cause the last is the number of checksums)
            nClientPaks = i - 1

            // make sure none of the client check sums are the same
            // so the client can't send 5 the same checksums
            i = 0
            while i < nClientPaks {
                j = 0
                while j < nClientPaks {
                    if i == j {
                        j += 1
                        continue
                    }
                    if nClientChkSum[i] == nClientChkSum[j] {
                        bGood = false
                        break
                    }
                    j += 1
                }
                if bGood == false {
                    break
                }
                i += 1
            }
            if bGood == false {
                break
            }

            // get the pure checksums of the pk3 files loaded by the server
            pPaks = FS_LoadedPakPureChecksums()
            Cmd_TokenizeString(pPaks)
            nServerPaks = Cmd_Argc()
            if nServerPaks > 1024 {
                nServerPaks = 1024
            }

            i = 0
            while i < nServerPaks {
                nServerChkSum[i] = atoi(Cmd_Argv(i))
                i += 1
            }

            // check if the client has provided any pure checksums of pk3 files not loaded by the server
            i = 0
            while i < nClientPaks {
                j = 0
                while j < nServerPaks {
                    if nClientChkSum[i] == nServerChkSum[j] {
                        break
                    }
                    j += 1
                }
                if j >= nServerPaks {
                    bGood = false
                    break
                }
                i += 1
            }
            if bGood == false {
                break
            }

            // check if the number of checksums was correct
            nChkSum1 = sv.checksumFeed
            i = 0
            while i < nClientPaks {
                nChkSum1 ^= nClientChkSum[i]
                i += 1
            }
            nChkSum1 ^= nClientPaks
            if nChkSum1 != nClientChkSum[nClientPaks] {
                bGood = false
                break
            }

            // break out
            break
        }

        if bGood {
            cl.pureAuthentic = 1
        } else {
            cl.pureAuthentic = 0
            cl.nextSnapshotTime = -1
            cl.state = CS_ACTIVE
            SV_SendClientSnapshot(cl)
            SV_DropClient(cl, "Unpure client detected. Invalid .PK3 files referenced!")
        }
    }
}

/**
```
=================
SV_ResetPureClient_f
=================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1440
private func SV_ResetPureClient_f(_ cl: Client) {
    cl.pureAuthentic = 0
}

/**
```
=================
SV_UserinfoChanged

Pull specific info from a newly changed userinfo string
into a more C friendly form.
=================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1452
func SV_UserinfoChanged(_ cl: Client) {
    var val: String
    var i: Int32

    // name for C code
    Q_strncpyz(&cl.nameBuffer, Info_ValueForKey(cl.userinfo, "name"), 32)

    // rate command

    // if the client is on the same subnet as the server and we aren't running an
    // internet public server, assume they don't need a rate choke
    if Sys_IsLANAddress(cl.netchan.remoteAddress) && com_dedicated!.integer != 2 {
        cl.rate = 99999 // lans should not rate limit
    } else {
        val = Info_ValueForKey(cl.userinfo, "rate")
        if strlen(val) != 0 {
            i = atoi(val)
            cl.rate = i
            if cl.rate < 1000 {
                cl.rate = 1000
            } else if cl.rate > 90000 {
                cl.rate = 90000
            }
        } else {
            cl.rate = 3000
        }
    }
    val = Info_ValueForKey(cl.userinfo, "handicap")
    if strlen(val) != 0 {
        i = atoi(val)
        if i <= 0 || i > 100 || strlen(val) > 4 {
            Info_SetValueForKey(&cl.userinfoBuffer, "handicap", "100")
        }
    }

    // snaps command
    val = Info_ValueForKey(cl.userinfo, "snaps")
    if strlen(val) != 0 {
        i = atoi(val)
        if i < 1 {
            i = 1
        } else if i > 30 {
            i = 30
        }
        cl.snapshotMsec = 1000 / i
    } else {
        cl.snapshotMsec = 50
    }
}

/**
```
==================
SV_UpdateUserinfo_f
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1510
private func SV_UpdateUserinfo_f(_ cl: Client) {
    Q_strncpyz(&cl.userinfoBuffer, Cmd_Argv(1), 1024)


    //	SV_SendServerCommand(cl, "print \"Warning: Too many info changes, last info ignored\n\"\n");
    do {
        cl.lastUserInfoCount = 0
        cl.lastUserInfoChange = svs.time + INFO_CHANGE_MIN_INTERVAL
    }

    SV_UserinfoChanged(cl)
    // call prog code to allow overrides
    VM_Call(gvm!, GAME_CLIENT_USERINFO_CHANGED, svs.clientsSlots.index(of: cl))
}

/**
```
==================
SV_ExecuteClientCommand

Also called by bot code
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1564
func SV_ExecuteClientCommand(_ cl: Client, _ s: String, _ clientOK: Bool) {
    var uIndex: Int32 = 0

    Cmd_TokenizeString(s)

    // see if it is a server level command
    uIndex = 0
    while uIndex < ucmds.count {
        if strcmp(Cmd_Argv(0), ucmds[uIndex].name) == 0 {
            ucmds[uIndex].func(cl)
            break
        }
        uIndex += 1
    }

    if clientOK {
        // pass unknown strings to the game
        if uIndex == ucmds.count && sv.state == SS_GAME {
            VM_Call(gvm!, GAME_CLIENT_COMMAND, svs.clientsSlots.index(of: cl))
        }
    }
}

/**
```
===============
SV_ClientCommand
===============
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1590
private func SV_ClientCommand(_ cl: Client, _ msg: Msg) -> Bool {
    let seq: Int32
    let s: String
    var clientOk: Bool = true

    seq = MSG_ReadLong(msg)
    s = MSG_ReadString(msg)

    // see if we have already executed it
    if cl.lastClientCommand >= seq {
        return true
    }

    Com_DPrintf("clientCommand: %s : %i : %s\n", cl.name, seq, s)

    // drop the connection if we have somehow lost commands
    if seq > cl.lastClientCommand + 1 {
        Com_Printf("Client %s lost %i clientCommands\n", cl.name, seq - cl.lastClientCommand + 1)
        SV_DropClient(cl, "Lost reliable commands")
        return false
    }

    // malicious users may try using too many string commands
    // to lag other players.  If we decide that we want to stall
    // the command, we will stop processing the rest of the packet,
    // including the usercmd.  This causes flooders to lag themselves
    // but not other people
    // We don't do this when the client hasn't been active yet since its
    // normal to spam a lot of commands when downloading
    if com_cl_running!.integer == 0 && cl.state >= CS_ACTIVE && sv_floodProtect!.integer != 0 && svs.time < cl.nextReliableTime {
        // ignore any other text messages from this client but let them keep playing
        clientOk = false
        Com_DPrintf("client text ignored for %s\n", cl.name)
        //return qfalse;	// stop processing
    }

    // don't allow another command for one second
    cl.nextReliableTime = svs.time + 1000

    SV_ExecuteClientCommand(cl, s, clientOk)

    cl.lastClientCommand = seq
    Com_sprintf(&cl.lastClientCommandStringBuffer, 1024, "%s", s)

    return true // continue procesing
}

/**
```
==================
SV_ClientThink

Also called by bot code
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1652
func SV_ClientThink(_ cl: Client, _ cmd: JKAMP.Usercmd) {
    cl.lastUsercmd = cmd

    if cl.state != CS_ACTIVE {
        return // may have been kicked during the last usercmd
    }

    VM_Call(gvm!, GAME_CLIENT_THINK, svs.clientsSlots.index(of: cl))
}

/**
```
==================
SV_UserMove

The message usually contains all the movement commands
that were in the last three packets, so that the information
in dropped packets can be recovered.

On very fast clients, there may be multiple usercmd packed into
each of the backup packets.
==================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1674
private func SV_UserMove(_ cl: Client, _ msg: Msg, _ delta: Bool) {
    var i: Int32 = 0
    var key: Int32 = 0
    var cmdCount: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Usercmd.scratch { nullcmd -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = Usercmd.scratch(count: 32) { cmds -> Bool in
            var cmd: Usercmd?
            var oldcmd: Usercmd?

            if delta {
                cl.deltaMessage = cl.messageAcknowledge
            } else {
                cl.deltaMessage = -1
            }

            cmdCount = MSG_ReadByte(msg)

            if cmdCount < 1 {
                Com_Printf("cmdCount < 1\n")
                return true
            }

            if cmdCount > MAX_PACKET_USERCMDS {
                Com_Printf("cmdCount > MAX_PACKET_USERCMDS\n")
                return true
            }

            // use the checksum feed in the key
            key = sv.checksumFeed
            // also use the message acknowledge
            key ^= cl.messageAcknowledge
            // also use the last acknowledged server command in the key
            key ^= Com_HashKey(cl.reliableCommands[cl.reliableAcknowledge & (MAX_RELIABLE_COMMANDS - 1)], 32)

            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
            oldcmd = nullcmd
            i = 0
            while i < cmdCount {
                cmd = cmds[i]
                MSG_ReadDeltaUsercmdKey(msg, key, oldcmd!, cmd!)
                oldcmd = cmd
                i += 1
            }

            // save time for ping calculation
            cl.frames[cl.messageAcknowledge & PACKET_MASK].messageAcked = svs.time

            // if this is the first usercmd we have received
            // this gamestate, put the client into the world
            if cl.state == CS_PRIMED {
                SV_ClientEnterWorld(cl, cmds[0])
                // the moves can be processed normaly
            }
            //
            if sv_pure!.integer != 0 && cl.pureAuthentic == 0 {
                SV_DropClient(cl, "Cannot validate pure client!")
                return true
            }

            if cl.state != CS_ACTIVE {
                cl.deltaMessage = -1
                return true
            }

            // usually, the first couple commands will be duplicates
            // of ones we have previously received, but the servertimes
            // in the commands will cause them to be immediately discarded
            i = 0
            while i < cmdCount {
                // if this is a cmd from before a map_restart ignore it
                if cmds[i].serverTime > cmds[cmdCount - 1].serverTime {
                    i += 1
                    continue
                }
                // extremely lagged or cmd from before a map_restart
                //if ( cmds[i].serverTime > svs.time + 3000 ) {
                //	continue;
                //}
                // don't execute if this is an old cmd which is already executed
                // these old cmds are included when cl_packetdup > 0
                if cmds[i].serverTime <= cl.lastUsercmd.serverTime {
                    i += 1
                    continue
                }
                SV_ClientThink(cl, cmds[i])
                i += 1
            }
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
===================
SV_ExecuteClientMessage

Parse a client packet
===================
```
*/
/// Source: oracle/codemp/server/sv_client.cpp:1773
func SV_ExecuteClientMessage(_ cl: Client, _ msg: Msg) {
    var c: Int32
    let serverId: Int32

    MSG_Bitstream(msg)

    serverId = MSG_ReadLong(msg)
    cl.messageAcknowledge = MSG_ReadLong(msg)

    if cl.messageAcknowledge < 0 {
        // usually only hackers create messages like this
        // it is more annoying for them to let them hanging
        //SV_DropClient( cl, "illegible client message" );
        return
    }

    cl.reliableAcknowledge = MSG_ReadLong(msg)

    // NOTE: when the client message is fux0red the acknowledgement numbers
    // can be out of range, this could cause the server to send thousands of server
    // commands which the server thinks are not yet acknowledged in SV_UpdateServerCommandsToClient
    if cl.reliableAcknowledge < cl.reliableSequence - MAX_RELIABLE_COMMANDS {
        // usually only hackers create messages like this
        // it is more annoying for them to let them hanging
        //SV_DropClient( cl, "illegible client message" );
        cl.reliableAcknowledge = cl.reliableSequence
        return
    }
    // if this is a usercmd from a previous gamestate,
    // ignore it or retransmit the current gamestate
    //
    // if the client was downloading, let it stay at whatever serverId and
    // gamestate it was at.  This allows it to keep downloading even when
    // the gamestate changes.  After the download is finished, we'll
    // notice and send it a new game state
    if serverId != sv.serverId && cl.downloadNameBuffer[0] == 0 {
        if serverId == sv.restartedServerId {
            // they just haven't caught the map_restart yet
            return
        }
        // if we can tell that the client has dropped the last
        // gamestate we sent them, resend it
        if cl.messageAcknowledge > cl.gamestateMessageNum {
            Com_DPrintf("%s : dropped gamestate, resending\n", cl.name)
            SV_SendClientGameState(cl)
        }
        return
    }

    // read optional clientCommand strings
    repeat {
        c = MSG_ReadByte(msg)
        if c == clc_EOF {
            break
        }
        if c != clc_clientCommand {
            break
        }
        if !SV_ClientCommand(cl, msg) {
            return // we couldn't execute it because of the flood protection
        }
        if cl.state == CS_ZOMBIE {
            return // disconnect command
        }
    } while 1 != 0

    // read the usercmd_t
    if c == clc_move {
        SV_UserMove(cl, msg, true)
    } else if c == clc_moveNoDelta {
        SV_UserMove(cl, msg, false)
    } else if c != clc_EOF {
        Com_Printf("WARNING: bad command byte for client %i\n", svs.clientsSlots.index(of: cl))
    }
    //	if ( msg->readcount != msg->cursize ) {
    //		Com_Printf( "WARNING: Junk at end of packet for client %i\n", cl - svs.clients );
    //	}
}
