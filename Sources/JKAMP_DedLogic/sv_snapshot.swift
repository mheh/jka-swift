import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/sv_snapshot.cpp:245
let MAX_SNAPSHOT_ENTITIES = 1024 as Int32

/// Source: oracle/codemp/server/sv_snapshot.cpp:300
var g_svCullDist: Float {
    get { world.variables.g_svCullDist }
    set { world.variables.g_svCullDist = newValue }
}

/// Source: oracle/codemp/server/sv_snapshot.cpp:622
let HEADER_RATE_BYTES = 48 as Int32

/**
```
=============
SV_EmitPacketEntities

Writes a delta update of an entityState_t list to the message.
=============
```
*/
/// Source: oracle/codemp/server/sv_snapshot.cpp:36
private func SV_EmitPacketEntities(_ from: ClientSnapshot, _ to: ClientSnapshot, _ msg: Msg) {
    var oldent: EntityState?
    var newent: EntityState?
    var oldindex: Int32
    var newindex: Int32
    var oldnum: Int32
    var newnum: Int32
    let from_num_entities: Int32

    // generate the delta update
    from_num_entities = from.num_entities

    newent = nil
    oldent = nil
    newindex = 0
    oldindex = 0
    while newindex < to.num_entities || oldindex < from_num_entities {
        if newindex >= to.num_entities {
            newnum = 9999
        } else {
            newent = svs.snapshotEntitiesSlots[(to.first_entity + newindex) % svs.numSnapshotEntities]
            newnum = newent!.number
        }

        if oldindex >= from_num_entities {
            oldnum = 9999
        } else {
            oldent = svs.snapshotEntitiesSlots[(from.first_entity + oldindex) % svs.numSnapshotEntities]
            oldnum = oldent!.number
        }

        if newnum == oldnum {
            // delta update from old position
            // because the force parm is qfalse, this will not result
            // in any bytes being emited if the entity has not changed at all
            MSG_WriteDeltaEntity(msg, oldent!, newent, false)
            oldindex += 1
            newindex += 1
            continue
        }

        if newnum < oldnum {
            // this is a new entity, send it from the baseline
            MSG_WriteDeltaEntity(msg, sv.svEntities[newnum].baseline, newent, true)
            newindex += 1
            continue
        }

        if newnum > oldnum {
            // the old entity isn't present in the new message
            MSG_WriteDeltaEntity(msg, oldent!, nil, true)
            oldindex += 1
            continue
        }
    }

    MSG_WriteBits(msg, (MAX_GENTITIES - 1), GENTITYNUM_BITS) // end of packetentities
}

/**
```
==================
SV_WriteSnapshotToClient
==================
```
*/
/// Source: oracle/codemp/server/sv_snapshot.cpp:103
private func SV_WriteSnapshotToClient(_ client: Client, _ msg: Msg) {
    var frame: ClientSnapshot?
    var oldframe: ClientSnapshot?
    var lastframe: Int32
    var i: Int32
    var snapFlags: Int32

    // this is the snapshot we are creating
    frame = client.frames[client.netchan.outgoingSequence & PACKET_MASK]

    // try to use a previous frame as the source for delta compressing the snapshot
    if client.deltaMessage <= 0 || client.state != CS_ACTIVE {
        // client is asking for a retransmit
        oldframe = nil
        lastframe = 0
    } else if client.netchan.outgoingSequence - client.deltaMessage >= (PACKET_BACKUP - 3) {
        // client hasn't gotten a good message through in a long time
        Com_DPrintf("%s: Delta request from out of date packet.\n", client.name)
        oldframe = nil
        lastframe = 0
    } else {
        // we have a valid snapshot to delta from
        oldframe = client.frames[client.deltaMessage & PACKET_MASK]
        lastframe = client.netchan.outgoingSequence - client.deltaMessage

        // the snapshot's entities may still have rolled off the buffer, though
        if oldframe!.first_entity <= svs.nextSnapshotEntities - svs.numSnapshotEntities {
            Com_DPrintf("%s: Delta request from out of date entities.\n", client.name)
            oldframe = nil
            lastframe = 0
        }
    }

    MSG_WriteByte(msg, svc_snapshot)

    // NOTE, MRE: now sent at the start of every message from server to client
    // let the client know which reliable clientCommands we have received
    //MSG_WriteLong( msg, client->lastClientCommand );

    // send over the current server time so the client can drift
    // its view of time to try to match
    MSG_WriteLong(msg, svs.time)

    // what we are delta'ing from
    MSG_WriteByte(msg, lastframe)

    snapFlags = svs.snapFlagServerBit
    if client.rateDelayed {
        snapFlags |= SNAPFLAG_RATE_DELAYED
    }
    if client.state != CS_ACTIVE {
        snapFlags |= SNAPFLAG_NOT_ACTIVE
    }

    MSG_WriteByte(msg, snapFlags)

    // send over the areabits
    MSG_WriteByte(msg, frame!.areabytes)
    MSG_WriteData(msg, frame!.areabits, frame!.areabytes)

    // delta encode the playerstate
    if oldframe != nil {
        MSG_WriteDeltaPlayerstate(msg, oldframe!.ps, frame!.ps)
        if frame!.ps.m_iVehicleNum != 0 {
            //then write the vehicle's playerstate too
            if oldframe!.ps.m_iVehicleNum == 0 {
                //if last frame didn't have vehicle, then the old vps isn't gonna delta
                //properly (because our vps on the client could be anything)
                MSG_WriteDeltaPlayerstate(msg, nil, frame!.vps, true)
            } else {
                MSG_WriteDeltaPlayerstate(msg, oldframe!.vps, frame!.vps, true)
            }
        }
    } else {
        MSG_WriteDeltaPlayerstate(msg, nil, frame!.ps)
        if frame!.ps.m_iVehicleNum != 0 {
            //then write the vehicle's playerstate too
            MSG_WriteDeltaPlayerstate(msg, nil, frame!.vps, true)
        }
    }

    // delta encode the entities
    if oldframe == nil {
        // Port-note: Raven passes a NULL `oldframe`, and SV_EmitPacketEntities takes `from` as a view that is not optional, row N1.
        // Raven wrote: SV_EmitPacketEntities (oldframe, frame, msg)
        portMissing("SV_WriteSnapshotToClient", source: "oracle/codemp/server/sv_snapshot.cpp:103")
    }
    SV_EmitPacketEntities(oldframe!, frame!, msg)

    // padding for rate debugging
    if sv_padPackets!.integer != 0 {
        i = 0
        while i < sv_padPackets!.integer {
            MSG_WriteByte(msg, svc_nop)
            i += 1
        }
    }
}

/**
```
==================
SV_UpdateServerCommandsToClient

(re)send all server commands the client hasn't acknowledged yet
==================
```
*/
/// Source: oracle/codemp/server/sv_snapshot.cpp:225
func SV_UpdateServerCommandsToClient(_ client: Client, _ msg: Msg) {
    var i: Int32

    // write any unacknowledged serverCommands
    i = client.reliableAcknowledge + 1
    while i <= client.reliableSequence {
        MSG_WriteByte(msg, svc_serverCommand)
        MSG_WriteLong(msg, i)
        MSG_WriteString(msg, client.reliableCommands[i & (MAX_RELIABLE_COMMANDS - 1)])
        i += 1
    }
    client.reliableSent = client.reliableSequence
}

/**
```
=======================
SV_QsortEntityNumbers
=======================
```
*/
/// Source: oracle/codemp/server/sv_snapshot.cpp:256
private func SV_QsortEntityNumbers(_ a: OpaquePointer?, _ b: OpaquePointer?) -> Int32 {
    // Port-note: A pointer local `int * ea` with no view, row N3.
    // Raven wrote: int *ea;
    portMissing("SV_QsortEntityNumbers", source: "oracle/codemp/server/sv_snapshot.cpp:256")
    // Port-note: A pointer local `int * eb` with no view, row N3.
    // Raven wrote: eb;
    portMissing("SV_QsortEntityNumbers", source: "oracle/codemp/server/sv_snapshot.cpp:256")

    // Port-note: A store into `ea`, a local the draft left as a hole, row N3.
    // Raven wrote: ea = (int *)a
    portMissing("SV_QsortEntityNumbers", source: "oracle/codemp/server/sv_snapshot.cpp:256")
    // Port-note: A store into `eb`, a local the draft left as a hole, row N3.
    // Raven wrote: eb = (int *)b
    portMissing("SV_QsortEntityNumbers", source: "oracle/codemp/server/sv_snapshot.cpp:256")

    // Port-note: A pointer dereference the draft cannot place, row N3.
    // Raven wrote: if ( *ea == *eb ) { Com_Error( ERR_DROP, "SV_QsortEntityStates: duplicated entity" ); }
    portMissing("SV_QsortEntityNumbers", source: "oracle/codemp/server/sv_snapshot.cpp:256")

    // Port-note: A pointer dereference the draft cannot place, row N3.
    // Raven wrote: if ( *ea < *eb ) { return -1; }
    portMissing("SV_QsortEntityNumbers", source: "oracle/codemp/server/sv_snapshot.cpp:256")

    return 1
}

/**
```
===============
SV_AddEntToSnapshot
===============
```
*/
/// Source: oracle/codemp/server/sv_snapshot.cpp:279
// TODO: Port signature
// Raven wrote: static void SV_AddEntToSnapshot( svEntity_t *svEnt, sharedEntity_t *gEnt, snapshotEntityNumbers_t *eNums )
// No table row for `snapshotEntityNumbers_t * eNums`.
private func SV_AddEntToSnapshot() -> Never {
    // TODO: Port SV_AddEntToSnapshot
    portMissing("SV_AddEntToSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:279")
}

/// Source: oracle/codemp/server/sv_snapshot.cpp:301
// TODO: Port signature
// Raven wrote: static void SV_AddEntitiesVisibleFromPoint( vec3_t origin, clientSnapshot_t *frame, snapshotEntityNumbers_t *eNums, qboolean portal )
// No table row for `snapshotEntityNumbers_t * eNums`.
private func SV_AddEntitiesVisibleFromPoint() -> Never {
    // TODO: Port SV_AddEntitiesVisibleFromPoint
    portMissing("SV_AddEntitiesVisibleFromPoint", source: "oracle/codemp/server/sv_snapshot.cpp:301")
}

/**
```
=============
SV_BuildClientSnapshot

Decides which entities are going to be visible to the client, and
copies off the playerstate and areabits.

This properly handles multiple recursive portals, but the render
currently doesn't.

For viewing through other player's eyes, clent can be something other than client->gentity
=============
```
*/
/// Source: oracle/codemp/server/sv_snapshot.cpp:513
private func SV_BuildClientSnapshot(_ client: Client) {
    var org = vec3_t()
    var frame: ClientSnapshot?
    // Port-note: A local `snapshotEntityNumbers_t entityNumbers` the table has no type for, row N2.
    // Raven wrote: snapshotEntityNumbers_t entityNumbers;
    portMissing("SV_BuildClientSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:513")
    var i: Int32
    var ent: SharedEntity?
    var state: EntityState?
    var svEnt: SvEntity?
    var clent: SharedEntity?
    var ps: PlayerState?

    // bump the counter used to prevent double adding
    sv.snapshotCounter += 1

    // this is the frame we are creating
    frame = client.frames[client.netchan.outgoingSequence & PACKET_MASK]

    // clear everything in this snapshot
    // Port-note: A read of `entityNumbers`, a local of `snapshotEntityNumbers_t`, which has no view, row N2.
    // Raven wrote: entityNumbers.numSnapshotEntities = 0
    portMissing("SV_BuildClientSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:513")
    frame!.areabits.zero()

    frame!.num_entities = 0

    clent = client.gentity
    if clent == nil || client.state == CS_ZOMBIE {
        return
    }

    // grab the current playerState_t
    ps = SV_GameClientNum(svs.clientsSlots.index(of: client))
    frame!.ps = ps!

    if ps!.m_iVehicleNum != 0 {
        //get the vehicle's playerstate too then
        let veh: SharedEntity? = SV_GentityNum(ps!.m_iVehicleNum)

        if veh != nil && veh!.playerState != nil {
            //Now VMA it and we've got ourselves a playerState
            // Port-note: VM_ArgPtr carries a signature marker for its `void *` return, row N5.
            // Raven wrote: playerState_t *vps = ((playerState_t *)VM_ArgPtr((int)veh->playerState)); frame->vps = *vps;
            portMissing("SV_BuildClientSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:513")
        }
    }

    let clientNum: Int32
    // never send client's own entity, because it can
    // be regenerated from the playerstate
    clientNum = frame!.ps.clientNum
    if clientNum < 0 || clientNum >= MAX_GENTITIES {
        Com_Error(ERR_DROP, "SV_SvEntityForGentity: bad gEnt")
    }
    svEnt = sv.svEntities[clientNum]
    svEnt!.snapshotCounter = sv.snapshotCounter


    // find the client's viewpoint
    org = ps!.origin
    org[2] += ps!.viewheight

    // add all the entities directly visible to the eye, which
    // may include portal entities that merge other viewpoints
    // Port-note: A read of `entityNumbers`, a local of `snapshotEntityNumbers_t`, which has no view, row N2.
    // Raven wrote: SV_AddEntitiesVisibleFromPoint( org, frame, &entityNumbers, qfalse )
    portMissing("SV_BuildClientSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:513")

    // if there were portals visible, there may be out of order entities
    // in the list which will need to be resorted for the delta compression
    // to work correctly.  This also catches the error condition
    // of an entity being included twice.
    // Port-note: The host has no qsort, and SV_QsortEntityNumbers takes two `OpaquePointer?` parameters, rows N2 and N3.
    // Raven wrote: qsort( entityNumbers.snapshotEntities, entityNumbers.numSnapshotEntities, sizeof( entityNumbers.snapshotEntities[0] ), SV_QsortEntityNumbers )
    portMissing("SV_BuildClientSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:513")

    // now that all viewpoint's areabits have been OR'd together, invert
    // all of them to make it a mask vector, which is what the renderer wants
    i = 0
    while i < MAX_MAP_AREA_BYTES / 4 {
        frame!.areabits[int: i * Int32(Int32.byteCount)] = frame!.areabits[int: i * Int32(Int32.byteCount)] ^ -1
        i += 1
    }

    // copy the entity states out
    frame!.num_entities = 0
    frame!.first_entity = svs.nextSnapshotEntities
    // Port-note: A read of `entityNumbers`, a local of `snapshotEntityNumbers_t`, which has no view, row N2.
    // Raven wrote: for ( i = 0 ; i < entityNumbers.numSnapshotEntities ; i++ ) { ent = SV_GentityNum(entityNumbers.snapshotEntities[i]); state = &svs.snapshotEntities[svs.nextSnapshotEntities % svs.numSnapshotEntities]; *state = ent->s; svs.nextSnapshotEntities++; // this should never hit, map should always be restarted first in SV_Frame if ( svs.nextSnapshotEntities >= 0x7FFFFFFE ) { Com_Error(ERR_FATAL, "svs.nextSnapshotEntities wrapped"); } frame->num_entities++; }
    portMissing("SV_BuildClientSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:513")
}

/// Source: oracle/codemp/server/sv_snapshot.cpp:623
private func SV_RateMsec(_ client: Client, _ messageSize: Int32) -> Int32 {
    var rate: Int32
    let rateMsec: Int32
    // Raven assigns his own `messageSize` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var messageSize = messageSize

    // individual messages will never be larger than fragment size
    if messageSize > 1500 {
        messageSize = 1500
    }
    rate = client.rate
    if sv_maxRate!.integer != 0 {
        if sv_maxRate!.integer < 1000 {
            Cvar_Set("sv_MaxRate", "1000")
        }
        if sv_maxRate!.integer < rate {
            rate = sv_maxRate!.integer
        }
    }
    rateMsec = (messageSize + HEADER_RATE_BYTES) * 1000 / rate

    return rateMsec
}

/**
```
=======================
SV_SendMessageToClient

Called by SV_SendClientSnapshot and SV_SendClientGameState
=======================
```
*/
/// Source: oracle/codemp/server/sv_snapshot.cpp:652
func SV_SendMessageToClient(_ msg: Msg, _ client: Client) {
    var rateMsec: Int32

    // MW - my attempt to fix illegible server message errors caused by
    // packet fragmentation of initial snapshot.
    while client.state != 0 && client.netchan.unsentFragments {
        // send additional message fragments if the last message
        // was too large to send at once
        Com_Printf("[ISM]SV_SendClientGameState() [1] for %s, writing out old fragments\n", client.name)
        SV_Netchan_TransmitNextFragment(client.netchan)
    }

    // record information about the message
    client.frames[client.netchan.outgoingSequence & PACKET_MASK].messageSize = msg.cursize
    client.frames[client.netchan.outgoingSequence & PACKET_MASK].messageSent = svs.time
    client.frames[client.netchan.outgoingSequence & PACKET_MASK].messageAcked = -1

    // send the datagram
    SV_Netchan_Transmit(client, msg) //msg->cursize, msg->data );

    // set nextSnapshotTime based on rate and requested number of updates

    // local clients get snapshots every frame
    if client.netchan.remoteAddress.type == NA_LOOPBACK || Sys_IsLANAddress(client.netchan.remoteAddress) {
        client.nextSnapshotTime = svs.time - 1
        return
    }

    // normal rate / snapshotMsec calculation
    rateMsec = SV_RateMsec(client, msg.cursize)

    if rateMsec < client.snapshotMsec {
        // never send more packets than this, no matter what the rate is at
        rateMsec = client.snapshotMsec
        client.rateDelayed = false
    } else {
        client.rateDelayed = true
    }

    client.nextSnapshotTime = svs.time + rateMsec

    // don't pile up empty snapshots while connecting
    if client.state != CS_ACTIVE {
        // a gigantic connection message may have already put the nextSnapshotTime
        // more than a second away, so don't shorten it
        // do shorten if client is downloading
        if client.downloadNameBuffer[0] == 0 && client.nextSnapshotTime < svs.time + 1000 {
            client.nextSnapshotTime = svs.time + 1000
        }
    }
}

/// Source: oracle/codemp/server/sv_snapshot.cpp:719
func SV_SendClientSnapshot(_ client: Client) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Msg.scratch { msg -> Bool in

        if !client.sentGamedir {
            //rww - if this is the case then make sure there is an svc_setgame sent before this snap
            var i: Int32 = 0

            // Port-note: Raven's stack buffer `byte msg_buf[MAX_MSGLEN]` has no storage home for the `Slots<byte>` of MSG_Init, row N4.
            // Raven wrote: MSG_Init (&msg, msg_buf, sizeof(msg_buf))
            portMissing("SV_SendClientSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:719")

            //have to include this for each message.
            MSG_WriteLong(msg, client.lastClientCommand)

            MSG_WriteByte(msg, svc_setgame)

            let string = CharBuf(fs_gamedirvar!.string!)
            while string[i] != 0 {
                MSG_WriteByte(msg, string[i])
                i += 1
            }
            MSG_WriteByte(msg, 0)

            // MW - my attempt to fix illegible server message errors caused by
            // packet fragmentation of initial snapshot.
            //rww - reusing this code here
            while client.state != 0 && client.netchan.unsentFragments {
                // send additional message fragments if the last message
                // was too large to send at once
                Com_Printf("[ISM]SV_SendClientGameState() [1] for %s, writing out old fragments\n", client.name)
                SV_Netchan_TransmitNextFragment(client.netchan)
            }

            // record information about the message
            client.frames[client.netchan.outgoingSequence & PACKET_MASK].messageSize = msg.cursize
            client.frames[client.netchan.outgoingSequence & PACKET_MASK].messageSent = svs.time
            client.frames[client.netchan.outgoingSequence & PACKET_MASK].messageAcked = -1

            // send the datagram
            SV_Netchan_Transmit(client, msg) //msg->cursize, msg->data );

            client.sentGamedir = true
        }

        // build the snapshot
        SV_BuildClientSnapshot(client)

        // bots need to have their snapshots build, but
        // the query them directly without needing to be sent
        if client.gentity != nil && (client.gentity!.r.svFlags & SVF_BOT) != 0 {
            return true
        }

        // Port-note: Raven's stack buffer `byte msg_buf[MAX_MSGLEN]` has no storage home for the `Slots<byte>` of MSG_Init, row N4.
        // Raven wrote: MSG_Init (&msg, msg_buf, sizeof(msg_buf))
        portMissing("SV_SendClientSnapshot", source: "oracle/codemp/server/sv_snapshot.cpp:719")
        msg.allowoverflow = true

        // NOTE, MRE: all server->client messages now acknowledge
        // let the client know which reliable clientCommands we have received
        MSG_WriteLong(msg, client.lastClientCommand)

        // (re)send any reliable server commands
        SV_UpdateServerCommandsToClient(client, msg)

        // send over all the relevant entityState_t
        // and the playerState_t
        SV_WriteSnapshotToClient(client, msg)

        // Add any download data if the client is downloading
        SV_WriteDownloadToClient(client, msg)

        // check for overflow
        if msg.overflowed {
            Com_Printf("WARNING: msg overflowed for %s\n", client.name)
            MSG_Clear(msg)
        }

        SV_SendMessageToClient(msg, client)
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
=======================
SV_SendClientMessages
=======================
```
*/
/// Source: oracle/codemp/server/sv_snapshot.cpp:806
func SV_SendClientMessages() {
    var i: Int32
    var c: Slots<Client>

    // send a message to each connected client
    i = 0
    c = svs.clientsSlots
    while i < sv_maxclients!.integer {
        if c[0].state == 0 {
            i += 1
            c = c.suffix(from: 1)
            continue // not connected
        }

        if svs.time < c[0].nextSnapshotTime {
            i += 1
            c = c.suffix(from: 1)
            continue // not time yet
        }

        // send additional message fragments if the last message
        // was too large to send at once
        if c[0].netchan.unsentFragments {
            c[0].nextSnapshotTime = svs.time + SV_RateMsec(c[0], c[0].netchan.unsentLength - c[0].netchan.unsentFragmentStart)
            SV_Netchan_TransmitNextFragment(c[0].netchan)
            i += 1
            c = c.suffix(from: 1)
            continue
        }

        // generate and send a new message
        SV_SendClientSnapshot(c[0])
        i += 1
        c = c.suffix(from: 1)
    }
}
