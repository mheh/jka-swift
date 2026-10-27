import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_svcmds.c:51
let MAX_IPFILTERS = 1024 as Int32

/// Source: oracle/codemp/game/g_svcmds.c:54
var ipFilters: Slots<IpFilter> { world.storage.ipFilters }

/// Source: oracle/codemp/game/g_svcmds.c:55
var numIPFilters: Int32 {
    get { world.variables.numIPFilters }
    set { world.variables.numIPFilters = newValue }
}

/**
```
=================
StringToFilter
=================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:62
private func StringToFilter(_ s: inout JKAShared.CharBuf, _ f: IpFilter) -> Bool {
    var num = CharBuf(128)
    var i: Int32
    var j: Int32
    var b: [UInt8] = [UInt8](repeating: 0, count: 4)
    var m: [UInt8] = [UInt8](repeating: 0, count: 4)
    // Raven steps the pointer `s`, and this index is its byte offset in the buffer.
    var sIndex: Int32 = 0

    i = 0
    while i < 4 {
        b[i] = 0
        m[i] = 0
        i += 1
    }

    i = 0
    while i < 4 {
        if s[sIndex] < Int32(ascii: "0") || s[sIndex] > Int32(ascii: "9") {
            G_Printf("Bad filter address: %s\n", String(s[sIndex...]))
            return false
        }

        j = 0
        while s[sIndex] >= Int32(ascii: "0") && s[sIndex] <= Int32(ascii: "9") {
            num[j] = s[sIndex]
            j += 1
            sIndex += 1
        }
        num[j] = 0
        b[i] = UInt8(truncatingIfNeeded: atoi(num))
        if b[i] != 0 {
            m[i] = 255
        }

        if s[sIndex] == 0 {
            break
        }
        sIndex += 1
        i += 1
    }

    f.mask = UInt32(nativeBytes: m)
    f.compare = UInt32(nativeBytes: b)

    return true
}

/**
```
=================
UpdateIPBans
=================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:109
private func UpdateIPBans() {
    var b: [UInt8] = [UInt8](repeating: 0, count: 4)
    var i: Int32
    var iplist = CharBuf(1024)

    iplist[0] = 0
    i = 0
    while i < numIPFilters {
        if ipFilters[i].compare == 0xffffffff {
            i += 1
            continue
        }

        b = nativeBytes(of: ipFilters[i].compare)
        var ip = CharBuf(Int32(iplist.count) - strlen(iplist))
        Com_sprintf(&ip, Int32(iplist.count) - strlen(iplist), "%i.%i.%i.%i ", Int32(b[0]), Int32(b[1]), Int32(b[2]), Int32(b[3]))
        strcat(&iplist, ip)
        i += 1
    }

    trap_Cvar_Set("g_banIPs", String(iplist))
}

/**
```
=================
G_FilterPacket
=================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:134
func G_FilterPacket(_ from: String) -> Bool {
    let from = CharBuf(from)
    var m: [UInt8] = [UInt8](repeating: 0, count: 4)
    var i: Int32 = 0
    let `in`: UInt32
    var p = TextCursor()

    while i < 4 {
        m[i] = 0
        i += 1
    }

    i = 0
    p = TextCursor(from)
    while p.byte != 0 && i < 4 {
        while p.byte >= Int32(ascii: "0") && p.byte <= Int32(ascii: "9") {
            m[i] = UInt8(truncatingIfNeeded: Int32(m[i]) * 10 + (p.byte - Int32(ascii: "0")))
            p.advance()
        }
        if p.byte == 0 || p.byte == Int32(ascii: ":") {
            break
        }
        i += 1
        p.advance()
    }

    `in` = UInt32(nativeBytes: m)

    i = 0
    while i < numIPFilters {
        if (`in` & ipFilters[i].mask) == ipFilters[i].compare {
            return g_filterBan.integer != 0
        }
        i += 1
    }

    return g_filterBan.integer == 0
}

/**
```
=================
AddIP
=================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:173
func AddIP(_ str: inout JKAShared.CharBuf) {
    var i: Int32

    i = 0
    while i < numIPFilters {
        if ipFilters[i].compare == 0xffffffff {
            break // free spot
        }
        i += 1
    }
    if i == numIPFilters {
        if numIPFilters == MAX_IPFILTERS {
            G_Printf("IP filter list is full\n")
            return
        }
        numIPFilters += 1
    }

    if !StringToFilter(&str, ipFilters[i]) {
        ipFilters[i].compare = 0xffffffff
    }

    UpdateIPBans()
}

/**
```
=================
G_ProcessIPBans
=================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:201
func G_ProcessIPBans() {
    // Port-note: A pointer local `char * s` with no view.
    // Raven wrote: char *s;
    portMissing("G_ProcessIPBans", source: "oracle/codemp/game/g_svcmds.c:201")
    // Port-note: A pointer local `char * t` with no view.
    // Raven wrote: t;
    portMissing("G_ProcessIPBans", source: "oracle/codemp/game/g_svcmds.c:201")
    var str = CharBuf(1024)

    Q_strncpyz(&str, g_banIPs.string, Int32((str).count))

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: for (t = s = g_banIPs.string; *t; /* */ ) { s = strchr(s, ' '); if (!s) break; while (*s == ' ') *s++ = 0; if (*t) AddIP( t ); t = s; }
    portMissing("G_ProcessIPBans", source: "oracle/codemp/game/g_svcmds.c:201")
}

/**
```
=================
Svcmd_AddIP_f
=================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:226
func Svcmd_AddIP_f() {
    var str = CharBuf(1024)

    if trap_Argc() < 2 {
        G_Printf("Usage:  addip <ip-mask>\n")
        return
    }

    strcpy(&str, trap_Argv(1, Int32((str).count)))

    AddIP(&str)
}

/**
```
=================
Svcmd_RemoveIP_f
=================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:246
func Svcmd_RemoveIP_f() {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = IpFilter.scratch { f -> Bool in
        var i: Int32 = 0
        var str = CharBuf(1024)

        if trap_Argc() < 2 {
            G_Printf("Usage:  sv removeip <ip-mask>\n")
            return true
        }

        strcpy(&str, trap_Argv(1, Int32((str).count)))

        if !StringToFilter(&str, f) {
            return true
        }

        i = 0
        while i < numIPFilters {
            if ipFilters[i].mask == f.mask && ipFilters[i].compare == f.compare {
                ipFilters[i].compare = 0xffffffff
                G_Printf("Removed.\n")

                UpdateIPBans()
                return true
            }
            i += 1
        }

        G_Printf("Didn't find %s.\n", str)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_svcmds.c:276
func Svcmd_ListIPs_f() {
    var i: Int32
    var str: String
    var b: [UInt8] = [UInt8](repeating: 0, count: 4)

    G_Printf("%d IP slots used.\n", numIPFilters)
    i = 0
    while i < numIPFilters {
        G_Printf("%d: ", i)
        if ipFilters[i].compare == 0xffffffff {
            G_Printf("unused\n")
        } else {
            b = nativeBytes(of: ipFilters[i].compare)
            str = va("%i.%i.%i.%i \n", Int32(b[0]), Int32(b[1]), Int32(b[2]), Int32(b[3]))
            G_Printf("%s\n", str)
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_svcmds.c:299
func G_SaveBanIP() {
    //save out all the banned IPs
    var i: Int32
    var str: String
    var fh: fileHandle_t = 0
    var b: [UInt8] = [UInt8](repeating: 0, count: 4)

    trap_FS_FOpenFile("banip.txt", &fh, FS_WRITE)
    if fh == 0 {
        G_Printf("G_SaveBanIP - ERROR: can't open banip.txt\n")
        return
    }

    str = va("%d \n", numIPFilters)
    trap_FS_Write(str, strlen(str), fh)
    i = 0
    while i < numIPFilters {
        if ipFilters[i].compare == 0xffffffff {
            str = "unused \n"
            trap_FS_Write(str, strlen(str), fh)
        } else {
            b = nativeBytes(of: ipFilters[i].compare)
            str = va("%i.%i.%i.%i \n", Int32(b[0]), Int32(b[1]), Int32(b[2]), Int32(b[3]))
            trap_FS_Write(str, strlen(str), fh)
        }
        i += 1
    }

    trap_FS_FCloseFile(fh)
}

/// Source: oracle/codemp/game/g_svcmds.c:333
func G_LoadIPBans() {
    //load in all the banned IPs
    var i: Int32
    let len: Int32
    var p = TextCursor()
    var token: String
    var fh: fileHandle_t = 0
    var banIPBuffer = CharBuf(32768)
    var banIPFile = CharBuf(64)

    len = trap_FS_FOpenFile("banip.txt", &fh, FS_READ)
    if fh == 0 {
        G_Printf("G_LoadBanIP - ERROR: can't open banip.txt\n")
        return
    }

    trap_FS_Read(&banIPBuffer, len, fh)
    banIPBuffer[len] = 0
    trap_FS_FCloseFile(fh)
    p = TextCursor(banIPBuffer)
    COM_BeginParseSession(String(banIPFile))

    token = COM_ParseExt(&p, true)
    numIPFilters = atoi(token)

    i = 0
    while i < numIPFilters {
        token = COM_ParseExt(&p, true)
        //have an ip
        if Q_stricmp("unused", token) == 0 {
            ipFilters[i].compare = 0xffffffff
        } else {
            var tokenBuf = CharBuf(token)
            StringToFilter(&tokenBuf, ipFilters[i])
        }
        i += 1
    }
}

/**
```
===================
Svcmd_EntityList_f
===================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:386
func Svcmd_EntityList_f() {
    var e: Int32
    var checkIndex: Int32 = 0

    checkIndex = 1
    e = 1
    while e < level.num_entities {
        if !g_entities[checkIndex].inuse {
            e += 1
            checkIndex += 1
            continue
        }
        G_Printf("%3i:", e)
        switch g_entities[checkIndex].s.eType {
        case ET_GENERAL:
            G_Printf("ET_GENERAL          ")

        case ET_PLAYER:
            G_Printf("ET_PLAYER           ")

        case ET_ITEM:
            G_Printf("ET_ITEM             ")

        case ET_MISSILE:
            G_Printf("ET_MISSILE          ")

        case ET_MOVER:
            G_Printf("ET_MOVER            ")

        case ET_BEAM:
            G_Printf("ET_BEAM             ")

        case ET_PORTAL:
            G_Printf("ET_PORTAL           ")

        case ET_SPEAKER:
            G_Printf("ET_SPEAKER          ")

        case ET_PUSH_TRIGGER:
            G_Printf("ET_PUSH_TRIGGER     ")

        case ET_TELEPORT_TRIGGER:
            G_Printf("ET_TELEPORT_TRIGGER ")

        case ET_INVISIBLE:
            G_Printf("ET_INVISIBLE        ")

        case ET_NPC:
            G_Printf("ET_NPC              ")

        default:
            G_Printf("%3i                 ", g_entities[checkIndex].s.eType)
        }

        if g_entities[checkIndex].classname != nil {
            G_Printf("%s", g_entities[checkIndex].classname!)
        }
        G_Printf("\n")
        e += 1
        checkIndex += 1
    }
}

/// Source: oracle/codemp/game/g_svcmds.c:445
func ClientForString(_ s: String) -> Client? {
    let s = CharBuf(s)
    var cl: Client?
    var i: Int32
    let idnum: Int32

    // numeric values are just slot numbers
    if s[0] >= Int32(ascii: "0") && s[0] <= Int32(ascii: "9") {
        idnum = atoi(s)
        if idnum < 0 || idnum >= level.maxclients {
            Com_Printf("Bad client slot: %i\n", idnum)
            return nil
        }

        cl = level.clientsSlots[idnum]
        if cl!.pers.connected == CON_DISCONNECTED {
            G_Printf("Client %i is not connected\n", idnum)
            return nil
        }
        return cl
    }

    // check for a name match
    i = 0
    while i < level.maxclients {
        cl = level.clientsSlots[i]
        if cl!.pers.connected == CON_DISCONNECTED {
            i += 1
            continue
        }
        if Q_stricmp(cl!.pers.netname, String(s)) == 0 {
            return cl
        }
        i += 1
    }

    G_Printf("User %s is not on the server\n", s)

    return nil
}

/**
```
===================
Svcmd_ForceTeam_f

forceteam <player> <team>
===================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:489
func Svcmd_ForceTeam_f() {
    var cl: Client?
    var str = CharBuf(1024)

    // find the player
    strcpy(&str, trap_Argv(1, Int32((str).count)))
    cl = ClientForString(String(str))
    if cl == nil {
        return
    }

    // set the team
    strcpy(&str, trap_Argv(2, Int32((str).count)))
    SetTeam(g_entities[level.clientsSlots.index(of: cl!)], String(str))
}

/**
```
=================
ConsoleCommand

=================
```
*/
/// Source: oracle/codemp/game/g_svcmds.c:513
public func ConsoleCommand() -> Bool {
    var cmd = CharBuf(1024)

    strcpy(&cmd, trap_Argv(0, Int32((cmd).count)))

    if Q_stricmp(cmd, "entitylist") == 0 {
        Svcmd_EntityList_f()
        return true
    }

    if Q_stricmp(cmd, "forceteam") == 0 {
        Svcmd_ForceTeam_f()
        return true
    }

    if Q_stricmp(cmd, "game_memory") == 0 {
        Svcmd_GameMem_f()
        return true
    }

    if Q_stricmp(cmd, "addbot") == 0 {
        Svcmd_AddBot_f()
        return true
    }

    if Q_stricmp(cmd, "botlist") == 0 {
        Svcmd_BotList_f()
        return true
    }

    /*	if (Q_stricmp (cmd, "abort_podium") == 0) {
    Svcmd_AbortPodium_f();
    return qtrue;
    }
    */
    if Q_stricmp(cmd, "addip") == 0 {
        Svcmd_AddIP_f()
        return true
    }

    if Q_stricmp(cmd, "removeip") == 0 {
        Svcmd_RemoveIP_f()
        return true
    }

    if Q_stricmp(cmd, "listip") == 0 {
        Svcmd_ListIPs_f()
        //trap_SendConsoleCommand( EXEC_NOW, "g_banIPs\n" );
        return true
    }

    if g_dedicated.integer != 0 {
        if Q_stricmp(cmd, "say") == 0 {
            trap_SendServerCommand(-1, va("print \"server: %s\n\"", ConcatArgs(1)))
            return true
        }
        // everything else will also be printed as a say command
        trap_SendServerCommand(-1, va("print \"server: %s\n\"", ConcatArgs(0)))
        return true
    }

    return false
}
