import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/**
```
===============
SV_SetConfigstring

===============
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:25
public func SV_SetConfigstring(_ index: Int32, _ val: String) {
    var len: Int32
    var i: Int32
    let maxChunkSize: Int32 = MAX_STRING_CHARS - 24
    var client: Slots<Client>
    // Raven steps his own `val` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var val = TextCursor(CharBuf(val))

    if index < 0 || index >= MAX_CONFIGSTRINGS {
        Com_Error(ERR_DROP, "SV_SetConfigstring: bad index %i\n", index)
    }


    // don't bother broadcasting an update if no change
    if strcmp(val.text, sv.configstrings[index]!) == 0 {
        return
    }

    // change the string in sv
    // AI: Raven frees the zone copy of the old string. The slot holds a string of the pool, which the pool keeps, so the free drops.
    sv.configstrings[index] = CopyString(val.text)

    // send it to all the clients if we aren't
    // spawning a new server
    if sv.state == SS_GAME || sv.restarting {
        // send the data to all relevent clients
        i = 0
        client = svs.clientsSlots
        while i < sv_maxclients!.integer {
            if client[0].state < CS_PRIMED {
                i += 1
                client = client.suffix(from: 1)
                continue
            }
            // do not always send server info to all clients
            if index == CS_SERVERINFO && client[0].gentity != nil && (client[0].gentity!.r.svFlags & SVF_NOSERVERINFO) != 0 {
                i += 1
                client = client.suffix(from: 1)
                continue
            }

            len = strlen(val.text)
            if len >= maxChunkSize {
                var sent: Int32 = 0
                var remaining: Int32 = len
                var cmd: String
                var buf = CharBuf(1024)

                while remaining > 0 {
                    if sent == 0 {
                        cmd = "bcs0"
                    } else if remaining < maxChunkSize {
                        cmd = "bcs2"
                    } else {
                        cmd = "bcs1"
                    }
                    Q_strncpyz(&buf, TextCursor(val.buf, at: sent).text, maxChunkSize)

                    SV_SendServerCommand(client[0], "%s %i \"%s\"\n", cmd, index, buf)

                    sent += (maxChunkSize - 1)
                    remaining -= (maxChunkSize - 1)
                }
            } else {
                // standard cs, just send it
                SV_SendServerCommand(client[0], "cs %i \"%s\"\n", index, val.text)
            }
            i += 1
            client = client.suffix(from: 1)
        }
    }
}

/**
```
===============
SV_GetConfigstring

===============
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:101
public func SV_GetConfigstring(_ index: Int32, _ buffer: inout JKAShared.CharBuf, _ bufferSize: Int32) {
    var bufferIndex: Int32 = 0
    if bufferSize < 1 {
        Com_Error(ERR_DROP, "SV_GetConfigstring: bufferSize == %i", bufferSize)
    }
    if index < 0 || index >= MAX_CONFIGSTRINGS {
        Com_Error(ERR_DROP, "SV_GetConfigstring: bad index %i\n", index)
    }
    if sv.configstrings[index] == nil {
        buffer[bufferIndex + 0] = 0
        return
    }

    Q_strncpyz(&buffer, sv.configstrings[index]!, bufferSize)
}

/**
```
================
SV_AddConfigstring

================
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:123
public func SV_AddConfigstring(_ name: String, _ start: Int32, _ max: Int32) -> Int32 {
    var i: Int32
    // Raven steps his own `name` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var name = TextCursor(CharBuf(name))

    if name[0] == 0 {
        return 0
    }

    if name[0] == Int32(ascii: "/") || name[0] == Int32(ascii: "\\") {
        name.advance()

        if name[0] == 0 {
            return 0
        }
    }

    i = 1
    while i < max {
        if sv.configstrings[start + i]!.isEmpty {
            // Didn't find it
            SV_SetConfigstring((start + i), name.text)
            break
        } else if Q_stricmp(sv.configstrings[start + i]!, name.text) == 0 {
            return i
        }
        i += 1
    }

    return 0
}

/**
```
===============
SV_SetUserinfo

===============
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:168
public func SV_SetUserinfo(_ index: Int32, _ val: String) {
    // Raven steps his own `val` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var val = TextCursor(CharBuf(val))
    if index < 0 || index >= sv_maxclients!.integer {
        Com_Error(ERR_DROP, "SV_SetUserinfo: bad index %i\n", index)
    }


    Q_strncpyz(&svs.clientsSlots[index].userinfoBuffer, val.text, 1024)
    Q_strncpyz(&svs.clientsSlots[index].nameBuffer, Info_ValueForKey(val.text, "name"), 32)
}

/**
```
===============
SV_GetUserinfo

===============
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:189
public func SV_GetUserinfo(_ index: Int32, _ buffer: inout JKAShared.CharBuf, _ bufferSize: Int32) {
    if bufferSize < 1 {
        Com_Error(ERR_DROP, "SV_GetUserinfo: bufferSize == %i", bufferSize)
    }
    if index < 0 || index >= sv_maxclients!.integer {
        Com_Error(ERR_DROP, "SV_GetUserinfo: bad index %i\n", index)
    }
    Q_strncpyz(&buffer, svs.clientsSlots[index].userinfo, bufferSize)
}

/**
```
================
SV_CreateBaseline

Entity baselines are used to compress non-delta messages
to the clients -- only the fields that differ from the
baseline will be transmitted
================
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:209
public func SV_CreateBaseline() {
    var svent: SharedEntity?
    var entnum: Int32

    entnum = 1
    while entnum < sv.num_entities {
        svent = SV_GentityNum(entnum)
        if !svent!.r.linked {
            entnum += 1
            continue
        }
        svent!.s.number = entnum

        //
        // take current state as baseline
        //
        sv.svEntities[entnum].baseline = svent!.s
        entnum += 1
    }
}

/**
```
===============
SV_BoundMaxClients

===============
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:234
public func SV_BoundMaxClients(_ minimum: Int32) {
    // get the current maxclients value
    Cvar_Get("sv_maxclients", "8", 0)

    sv_maxclients!.modified = false

    if sv_maxclients!.integer < minimum {
        Cvar_Set("sv_maxclients", va("%i", minimum))
    } else if sv_maxclients!.integer > MAX_CLIENTS {
        Cvar_Set("sv_maxclients", va("%i", MAX_CLIENTS))
    }
}

/**
```
===============
SV_Startup

Called when a host starts a map when it wasn't running
one before.  Successive map or map_restart commands will
NOT cause this to be called, unless the game is exited to
the menu system first.
===============
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:258
public func SV_Startup() {
    if svs.initialized {
        Com_Error(ERR_FATAL, "SV_Startup: svs.initialized")
    }
    SV_BoundMaxClients(1)

    svs.clients = Client(Z_Malloc(Int32(Client.byteCount) * sv_maxclients!.integer, TAG_CLIENTS, true))
    if com_dedicated!.integer != 0 {
        svs.numSnapshotEntities = sv_maxclients!.integer * PACKET_BACKUP * 64
        Cvar_Set("r_ghoul2animsmooth", "0")
        Cvar_Set("r_ghoul2unsqashaftersmooth", "0")
    } else {
        // we don't need nearly as many when playing locally
        svs.numSnapshotEntities = sv_maxclients!.integer * 4 * 64
    }
    svs.initialized = true

    Cvar_Set("sv_running", "1")
}

/// Source: oracle/codemp/server/sv_init.cpp:284
public func SV_InitSV() {
    // clear out most of the sv struct
    sv.clear()
    sv.mLocalSubBSPIndex = -1
}

/**
```
==================
SV_ChangeMaxClients
==================
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:299
public func SV_ChangeMaxClients() {
    let oldMaxClients: Int32
    var i: Int32
    let oldClients: Slots<Client>
    var count: Int32

    // get the highest client number in use
    count = 0
    i = 0
    while i < sv_maxclients!.integer {
        if svs.clientsSlots[i].state >= CS_CONNECTED {
            if i > count {
                count = i
            }
        }
        i += 1
    }
    count += 1

    oldMaxClients = sv_maxclients!.integer
    // never go below the highest client number in use
    SV_BoundMaxClients(count)
    // if still the same
    if sv_maxclients!.integer == oldMaxClients {
        return
    }

    oldClients = Slots<Client>(Hunk_AllocateTempMemory(count * Int32(Client.byteCount)), count: count)
    // copy the clients to hunk memory
    i = 0
    while i < count {
        if svs.clientsSlots[i].state >= CS_CONNECTED {
            oldClients[i] = svs.clientsSlots[i]
        } else {
            oldClients[i].clear()
        }
        i += 1
    }

    // free old clients arrays
    // AI: Raven hands the record pointer to Z_Free. The call hands the handle of the view, because Z_Free takes the raw address.
    Z_Free(svs.clients?.handle)

    // allocate new clients
    svs.clients = Client(Z_Malloc(sv_maxclients!.integer * Int32(Client.byteCount), TAG_CLIENTS, true))
    svs.clientsSlots.zero(count: sv_maxclients!.integer)

    // copy the clients over
    i = 0
    while i < count {
        if oldClients[i].state >= CS_CONNECTED {
            svs.clientsSlots[i] = oldClients[i]
        }
        i += 1
    }

    // free the old clients on the hunk
    // AI: Raven hands the record pointer to Hunk_FreeTempMemory. The call hands the handle of the first record, because the function takes the raw address.
    Hunk_FreeTempMemory(oldClients[0].handle)

    // allocate new snapshot entities
    if com_dedicated!.integer != 0 {
        svs.numSnapshotEntities = sv_maxclients!.integer * PACKET_BACKUP * 64
    } else {
        // we don't need nearly as many when playing locally
        svs.numSnapshotEntities = sv_maxclients!.integer * 4 * 64
    }
}

/**
```
================
SV_ClearServer
================
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:365
public func SV_ClearServer() {
    var i: Int32

    i = 0
    while i < MAX_CONFIGSTRINGS {
        if sv.configstrings[i] != nil {
            // AI: Raven frees the zone copy of each string. The slot holds a string of the pool, which the pool keeps, so the free drops.
        }
        i += 1
    }

    //	CM_ClearMap();

    /*
    Ghoul2 Insert Start
    */

    // nope, can't do this anymore.. sv contains entitystates with STL in them.
    //	memset (&sv, 0, sizeof(sv));
    SV_InitSV()
    /*
    Ghoul2 Insert End
    */
    //	Com_Memset (&sv, 0, sizeof(sv));
}

/**
```
================
SV_TouchCGame

  touch the cgame.vm so that a pure client can load it if it's in a seperate pk3
================
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:396
public func SV_TouchCGame() {
    var f: fileHandle_t = 0
    var filename = CharBuf(64)

    if Cvar_VariableValue("vm_cgame") != 0 {
        Com_sprintf(&filename, Int32((filename).count), "vm/%s.qvm", "cgame")
    } else {
        Com_sprintf(&filename, Int32((filename).count), "cgamex86.dll")
    }
    FS_FOpenFileRead(String(filename), &f, false)
    if f != 0 {
        FS_FCloseFile(f)
    }
}

/// Source: oracle/codemp/server/sv_init.cpp:414
public func SV_SendMapChange() {
    var i: Int32

    if svs.clients != nil {
        i = 0
        while i < sv_maxclients!.integer {
            if svs.clientsSlots[i].state >= CS_CONNECTED {
                if svs.clientsSlots[i].netchan.remoteAddress.type != NA_BOT {
                    SV_SendClientMapChange(svs.clientsSlots[i])
                }
            }
            i += 1
        }
    }
}

/// Source: oracle/codemp/server/sv_init.cpp:472
public func SV_SpawnServer(_ server: String, _ killBots: Bool, _ eForceReload: JKAMP.ForceReload_e) {
    var i: Int32
    var checksum: Int32 = 0
    var isBot: Bool
    var systemInfo = CharBuf(16384)
    var p: String

    SV_SendMapChange()

    RE_RegisterMedia_LevelLoadBegin(server, eForceReload)

    // shut down the existing game if it is running
    SV_ShutdownGameProgs()

    Com_Printf("------ Server Initialization ------\n")
    Com_Printf("Server: %s\n", server)

    /*
    Ghoul2 Insert Start
    */
    // de allocate the snapshot entities
    if svs.snapshotEntities != nil {
        svs.snapshotEntitiesSlots.delete()
        svs.snapshotEntities = nil
    }
    /*
    Ghoul2 Insert End
    */

    SV_SendMapChange()

    // disable vsync during load for speed

    // if not running a dedicated server CL_MapLoading will connect the client to the server
    // also print some status stuff
    CL_MapLoading()

    // make sure all the client stuff is unloaded

    CM_ClearMap()

    //	extern qboolean RE_RegisterImages_LevelLoadEnd(void);
    //	RE_RegisterImages_LevelLoadEnd();

    // clear the whole hunk because we're (re)loading the server
    Hunk_Clear()


    R_InitSkins()
    R_InitShaders(true)

    //Useful for memory debugging.  Please don't delete.  Comment out if
    //necessary.

    // init client structures and svs.numSnapshotEntities
    if Cvar_VariableValue("sv_running") == 0 {
        SV_Startup()
    } else {
        // check for maxclients change
        if sv_maxclients!.modified {
            SV_ChangeMaxClients()
        }
    }

    SV_SendMapChange()

    /*
    Ghoul2 Insert Start
    */
    // clear out those shaders, images and Models as long as this
    // isnt a dedicated server.
    /*
    if ( !com_dedicated->integer )
    {
    #ifndef DEDICATED
    R_InitImages();

    R_InitShaders();

    R_ModelInit();
    #endif
    }
    else
    */
    if com_dedicated!.integer != 0 {
        R_SVModelInit()
    }

    SV_SendMapChange()

    // clear pak references
    FS_ClearPakReferences(0)

    /*
    Ghoul2 Insert Start
    */
    // allocate the snapshot entities on the hunk
    //	svs.snapshotEntities = (struct entityState_s *)Hunk_Alloc( sizeof(entityState_t)*svs.numSnapshotEntities, h_high );
    svs.nextSnapshotEntities = 0

    // allocate the snapshot entities
    svs.snapshotEntitiesSlots = Slots<EntityState>.new(count: svs.numSnapshotEntities)
    // we CAN afford to do this here, since we know the STL vectors in Ghoul2 are empty
    svs.snapshotEntitiesSlots.zero(count: svs.numSnapshotEntities)

    /*
    Ghoul2 Insert End
    */

    // toggle the server bit so clients can detect that a
    // server has changed
    svs.snapFlagServerBit ^= SNAPFLAG_SERVERCOUNT

    // set nextmap to the same map, but it may be overriden
    // by the game startup or another console command
    Cvar_Set("nextmap", "map_restart 0")
    //	Cvar_Set( "nextmap", va("map %s", server) );

    // wipe the entire per-level structure
    SV_ClearServer()
    i = 0
    while i < MAX_CONFIGSTRINGS {
        sv.configstrings[i] = CopyString("")
        i += 1
    }

    //rww - RAGDOLL_BEGIN
    G2API_SetTime(svs.time, 0)
    //rww - RAGDOLL_END

    // make sure we are not paused
    Cvar_Set("cl_paused", "0")

    // get a new checksum feed and restart the file system
    srand(Com_Milliseconds())
    sv.checksumFeed = ((rand() << 16) ^ rand()) ^ Com_Milliseconds()
    FS_Restart(sv.checksumFeed)

    //	RE_LoadWorldMap(va("maps/%s.bsp", server));

    // Start up voice system if it isn't running yet. (ie, if we're on syslink)
    CM_LoadMap(va("maps/%s.bsp", server), false, &checksum)

    SV_SendMapChange()

    // set serverinfo visible name
    Cvar_Set("mapname", server)

    Cvar_Set("sv_mapChecksum", va("%i", checksum))

    // serverid should be different each time
    sv.serverId = com_frameTime
    sv.restartedServerId = sv.serverId
    Cvar_Set("sv_serverid", va("%i", sv.serverId))

    // clear physics interaction links
    SV_ClearWorld()

    // media configstring setting should be done during
    // the loading stage, so connected clients don't have
    // to load during actual gameplay
    sv.state = SS_LOADING

    // load and spawn all other entities
    SV_InitGameProgs()

    // don't allow a map_restart if game is modified
    sv_gametype!.modified = false

    // run a few frames to allow everything to settle
    i = 0
    while i < 3 {
        //rww - RAGDOLL_BEGIN
        G2API_SetTime(svs.time, 0)
        //rww - RAGDOLL_END
        VM_Call(gvm!, GAME_RUN_FRAME, svs.time)
        SV_BotFrame(svs.time)
        svs.time += 100
        i += 1
    }
    //rww - RAGDOLL_BEGIN
    G2API_SetTime(svs.time, 0)
    //rww - RAGDOLL_END

    // create a baseline for more efficient communications
    SV_CreateBaseline()

    i = 0
    while i < sv_maxclients!.integer {
        // send the new gamestate to all connected clients
        if svs.clientsSlots[i].state >= CS_CONNECTED {
            var denied: String?

            if svs.clientsSlots[i].netchan.remoteAddress.type == NA_BOT {
                if killBots {
                    SV_DropClient(svs.clientsSlots[i], "")
                    i += 1
                    continue
                }
                isBot = true
            } else {
                isBot = false
            }

            // connect the client again
            denied = VM_ExplicitArgPtr(gvm!, VM_Call(gvm!, GAME_CLIENT_CONNECT, i, false, isBot)) // firstTime = qfalse
            if denied != nil {
                // this generally shouldn't happen, because the client
                // was connected before the level change
                SV_DropClient(svs.clientsSlots[i], denied!)
            } else {
                if !isBot {
                    // when we get the next packet from a connected client,
                    // the new gamestate will be sent
                    svs.clientsSlots[i].state = CS_CONNECTED
                } else {
                    let client: Client
                    let ent: SharedEntity

                    client = svs.clientsSlots[i]
                    client.state = CS_ACTIVE
                    ent = SV_GentityNum(i)!
                    ent.s.number = i
                    client.gentity = ent

                    client.deltaMessage = -1
                    client.nextSnapshotTime = svs.time // generate a snapshot immediately

                    VM_Call(gvm!, GAME_CLIENT_BEGIN, i)
                }
            }
        }
        i += 1
    }

    // run another frame to allow things to look at all the players
    VM_Call(gvm!, GAME_RUN_FRAME, svs.time)
    SV_BotFrame(svs.time)
    svs.time += 100
    //rww - RAGDOLL_BEGIN
    G2API_SetTime(svs.time, 0)
    //rww - RAGDOLL_END

    if sv_pure!.integer != 0 {
        // the server sends these to the clients so they will only
        // load pk3s also loaded at the server
        p = FS_LoadedPakChecksums()
        Cvar_Set("sv_paks", p)
        if strlen(p) == 0 {
            Com_Printf("WARNING: sv_pure set but no PK3 files loaded\n")
        }
        p = FS_LoadedPakNames()
        Cvar_Set("sv_pakNames", p)

        // if a dedicated pure server we need to touch the cgame because it could be in a
        // seperate pk3 file and the client will need to load the latest cgame.qvm
        if com_dedicated!.integer != 0 {
            SV_TouchCGame()
        }
    } else {
        Cvar_Set("sv_paks", "")
        Cvar_Set("sv_pakNames", "")
    }
    // the server sends these to the clients so they can figure
    // out which pk3s should be auto-downloaded
    p = FS_ReferencedPakChecksums()
    Cvar_Set("sv_referencedPaks", p)
    p = FS_ReferencedPakNames()
    Cvar_Set("sv_referencedPakNames", p)

    // save systeminfo and serverinfo strings
    Q_strncpyz(&systemInfo, Cvar_InfoString_Big(CVAR_SYSTEMINFO), Int32((systemInfo).count))
    cvar_modifiedFlags &= ~CVAR_SYSTEMINFO
    SV_SetConfigstring(CS_SYSTEMINFO, String(systemInfo))

    SV_SetConfigstring(CS_SERVERINFO, Cvar_InfoString(CVAR_SERVERINFO))
    cvar_modifiedFlags &= ~CVAR_SERVERINFO

    // any media configstring setting now should issue a warning
    // and any configstring changes should be reliably transmitted
    // to all clients
    sv.state = SS_GAME

    // send a heartbeat now so the master will get up to date info
    SV_Heartbeat_f()

    Hunk_SetMark()

    // AI: Raven ends the spawn here. The fork's referee resets its frame index, opens the record or replay file, and prints REF READY.
    SVRef_MapSpawned(server)

    /* MrE: 2000-09-13: now called in CL_DownloadsComplete
    // don't call when running dedicated
    if ( !com_dedicated->integer ) {
    // note that this is called after setting the hunk mark with Hunk_SetMark
    CL_StartHunkUsers();
    }
    */
}

/// Source: oracle/codemp/server/sv_init.cpp:803
public func SV_Init() {
    SV_AddOperatorCommands()

    // serverinfo vars
    Cvar_Get("dmflags", "0", CVAR_SERVERINFO)
    Cvar_Get("fraglimit", "20", CVAR_SERVERINFO)
    Cvar_Get("timelimit", "0", CVAR_SERVERINFO)
    Cvar_Get("capturelimit", "0", CVAR_SERVERINFO)

    // Get these to establish them and to make sure they have a default before the menus decide to stomp them.
    Cvar_Get("g_maxHolocronCarry", "3", CVAR_SERVERINFO)
    Cvar_Get("g_privateDuel", "1", CVAR_SERVERINFO)
    Cvar_Get("g_saberLocking", "1", CVAR_SERVERINFO)
    Cvar_Get("g_maxForceRank", "6", CVAR_SERVERINFO)
    Cvar_Get("duel_fraglimit", "10", CVAR_SERVERINFO)
    Cvar_Get("g_forceBasedTeams", "0", CVAR_SERVERINFO)
    Cvar_Get("g_duelWeaponDisable", "1", CVAR_SERVERINFO)

    sv_gametype = Cvar_Get("g_gametype", "0", CVAR_SERVERINFO | CVAR_LATCH)
    sv_needpass = Cvar_Get("g_needpass", "0", CVAR_SERVERINFO | CVAR_ROM)
    Cvar_Get("sv_keywords", "", CVAR_SERVERINFO)
    Cvar_Get("protocol", va("%i", PROTOCOL_VERSION), CVAR_SERVERINFO | CVAR_ROM)
    sv_mapname = Cvar_Get("mapname", "nomap", CVAR_SERVERINFO | CVAR_ROM)
    sv_privateClients = Cvar_Get("sv_privateClients", "0", CVAR_SERVERINFO)
    sv_hostname = Cvar_Get("sv_hostname", "*Jedi*", CVAR_SERVERINFO | CVAR_ARCHIVE)
    sv_maxclients = Cvar_Get("sv_maxclients", "8", CVAR_SERVERINFO | CVAR_LATCH)
    sv_maxRate = Cvar_Get("sv_maxRate", "0", CVAR_ARCHIVE | CVAR_SERVERINFO)
    sv_minPing = Cvar_Get("sv_minPing", "0", CVAR_ARCHIVE | CVAR_SERVERINFO)
    sv_maxPing = Cvar_Get("sv_maxPing", "0", CVAR_ARCHIVE | CVAR_SERVERINFO)
    sv_floodProtect = Cvar_Get("sv_floodProtect", "1", CVAR_ARCHIVE | CVAR_SERVERINFO)
    // systeminfo
    Cvar_Get("sv_cheats", "0", CVAR_SYSTEMINFO | CVAR_ROM)
    sv_serverid = Cvar_Get("sv_serverid", "0", CVAR_SYSTEMINFO | CVAR_ROM)
    sv_pure = Cvar_Get("sv_pure", "1", CVAR_SYSTEMINFO)
    Cvar_Get("sv_paks", "", CVAR_SYSTEMINFO | CVAR_ROM)
    Cvar_Get("sv_pakNames", "", CVAR_SYSTEMINFO | CVAR_ROM)
    Cvar_Get("sv_referencedPaks", "", CVAR_SYSTEMINFO | CVAR_ROM)
    Cvar_Get("sv_referencedPakNames", "", CVAR_SYSTEMINFO | CVAR_ROM)

    // server vars
    sv_rconPassword = Cvar_Get("rconPassword", "", CVAR_TEMP)
    sv_privatePassword = Cvar_Get("sv_privatePassword", "", CVAR_TEMP)
    sv_fps = Cvar_Get("sv_fps", "20", CVAR_TEMP)
    sv_timeout = Cvar_Get("sv_timeout", "200", CVAR_TEMP)
    sv_zombietime = Cvar_Get("sv_zombietime", "2", CVAR_TEMP)
    Cvar_Get("nextmap", "", CVAR_TEMP)

    sv_allowDownload = Cvar_Get("sv_allowDownload", "0", CVAR_SERVERINFO)
    sv_master[0] = Cvar_Get("sv_master1", MASTER_SERVER_NAME, 0)
    sv_master[1] = Cvar_Get("sv_master2", "", CVAR_ARCHIVE)
    sv_master[2] = Cvar_Get("sv_master3", "", CVAR_ARCHIVE)
    sv_master[3] = Cvar_Get("sv_master4", "", CVAR_ARCHIVE)
    sv_master[4] = Cvar_Get("sv_master5", "", CVAR_ARCHIVE)
    sv_reconnectlimit = Cvar_Get("sv_reconnectlimit", "3", 0)
    sv_showghoultraces = Cvar_Get("sv_showghoultraces", "0", 0)
    sv_showloss = Cvar_Get("sv_showloss", "0", 0)
    sv_padPackets = Cvar_Get("sv_padPackets", "0", 0)
    sv_killserver = Cvar_Get("sv_killserver", "0", 0)
    sv_mapChecksum = Cvar_Get("sv_mapChecksum", "", CVAR_ROM)

    //	sv_debugserver = Cvar_Get ("sv_debugserver", "0", 0);

    // initialize bot cvars so they are listed and can be set before loading the botlib
    SV_BotInitCvars()

    // init the botlib here because we need the pre-compiler in the UI
    SV_BotInitBotLib()

    // AI: Raven registers no referee. The fork's SVRef_Init registers its five cvars and three commands here.
    SVRef_Init()

    // Only allocated once, no point in moving it around and fragmenting
    // create a heap for Ghoul2 to use for game side model vertex transforms used in collision detection
    G2VertSpaceServer = CMiniHeap_singleton
}

/**
```
==================
SV_FinalMessage

Used by SV_Shutdown to send a final message to all
connected clients before the server goes down.  The messages are sent immediately,
not just stuck on the outgoing message list, because the server is going
to totally exit after returning from this function.
==================
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:899
public func SV_FinalMessage(_ message: String) {
    var i: Int32
    var j: Int32
    var cl: Slots<Client>

    // send it twice, ignoring rate
    j = 0
    while j < 2 {
        i = 0
        cl = svs.clientsSlots
        while i < sv_maxclients!.integer {
            if cl[0].state >= CS_CONNECTED {
                // don't send a disconnect to a local client
                if cl[0].netchan.remoteAddress.type != NA_LOOPBACK {
                    SV_SendServerCommand(cl[0], "print \"%s\"", message)
                    SV_SendServerCommand(cl[0], "disconnect")
                }
                // force a snapshot to be sent
                cl[0].nextSnapshotTime = -1
                SV_SendClientSnapshot(cl[0])
            }
            i += 1
            cl = cl.suffix(from: 1)
        }
        j += 1
    }
}

/**
```
================
SV_Shutdown

Called when each game quits,
before Sys_Quit or Sys_Error
================
```
*/
/// Source: oracle/codemp/server/sv_init.cpp:929
public func SV_Shutdown(_ finalmsg: String) {
    if com_sv_running == nil || com_sv_running!.integer == 0 {
        return
    }

    //	Com_Printf( "----- Server Shutdown -----\n" );

    if svs.clients != nil && !com_errorEntered {
        SV_FinalMessage(finalmsg)
    }

    // AI: Raven has no referee to stop. The fork's SVRef_ServerShutdown closes the record file and frees the replay here.
    SVRef_ServerShutdown()

    SV_RemoveOperatorCommands()
    SV_MasterShutdown()
    SV_ShutdownGameProgs()
    /*
    Ghoul2 Insert Start
    */
    // de allocate the snapshot entities
    if svs.snapshotEntities != nil {
        svs.snapshotEntitiesSlots.delete()
        svs.snapshotEntities = nil
    }

    // free current level
    SV_ClearServer()
    CM_ClearMap() //jfm: add a clear here since it's commented out in clearServer.  This prevents crashing cmShaderTable on exit.

    // free server static data
    if svs.clients != nil {
        // AI: Raven hands the record pointer to Z_Free. The call hands the handle of the view, because Z_Free takes the raw address.
        Z_Free(svs.clients!.handle)
    }
    svs.clear()

    Cvar_Set("sv_running", "0")
    Cvar_Set("ui_singlePlayerActive", "0")

    //	Com_Printf( "---------------------------\n" );

    // If we were advertising on Live, remove the listing. This also unregisters
    // the server's key. SysLink keys are never unregistered, so we don't do anything
    // special here for them.

    // Tear down voice now if we're on system link (Live keeps it active)

    // Wipe our player list - this is important

    // disconnect any local clients
    CL_Disconnect(false)
}
