import Foundation
import JKAMP
import JKAShared
import JKAMP_UI
import JKAMP_BG

/// Source: oracle/codemp/ui/ui_gameinfo.c:15
public var ui_numBots: Int32 {
    get { world.variables.ui_numBots }
    set { world.variables.ui_numBots = newValue }
}

/// Source: oracle/codemp/ui/ui_gameinfo.c:16
var ui_botInfos: [String] {
    get { world.variables.ui_botInfos }
    set { world.variables.ui_botInfos = newValue }
}

/// Source: oracle/codemp/ui/ui_gameinfo.c:18
var ui_numArenas: Int32 {
    get { world.variables.ui_numArenas }
    set { world.variables.ui_numArenas = newValue }
}

/// Source: oracle/codemp/ui/ui_gameinfo.c:19
var ui_arenaInfos: [String] {
    get { world.variables.ui_arenaInfos }
    set { world.variables.ui_arenaInfos = newValue }
}

/**
```
===============
UI_ParseInfos
===============
```
*/
/// Source: oracle/codemp/ui/ui_gameinfo.c:26
public func UI_ParseInfos(_ buf: inout JKAShared.CharBuf, _ max: Int32, _ infos: inout ArraySlice<String>) -> Int32 {
    var buf = TextCursor(buf)
    var token: String
    var count: Int32
    var key = CharBuf(1024)
    var info = CharBuf(1024)

    count = 0

    while 1 != 0 {
        token = COM_Parse(&buf)
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
            token = COM_ParseExt(&buf, true)
            if token.isEmpty {
                Com_Printf("Unexpected end of info file\n")
                break
            }
            if strcmp(token, "}") == 0 {
                break
            }
            Q_strncpyz(&key, token, Int32((key).count))

            token = COM_ParseExt(&buf, false)
            if token.isEmpty {
                strcpy(&token, "<NULL>")
            }
            Info_SetValueForKey(&info, String(key), token)
        }
        //NOTE: extra space for arena number
        // Port-note: The guide has no form for the NULL test of an allocator result, so the body tests the result of UI_Alloc in place of Raven's slot.
        if UI_Alloc(strlen(info) + strlen("\\num\\") + strlen(va("%d", MAX_ARENAS)) + 1) != nil {
            infos[infos.startIndex + count] = String(info)
            if trap_Cvar_VariableValue("com_buildScript") != 0 {
                let botFile: String = Info_ValueForKey(String(info), "personality")
                if !botFile.isEmpty {
                    var fh: Int32 = 0
                    trap_FS_FOpenFile(botFile, &fh, FS_READ)
                    if fh != 0 {
                        trap_FS_FCloseFile(fh)
                    }
                }
            }
            count += 1
        }
    }
    return count
}

/**
```
===============
UI_LoadArenasFromFile
===============
```
*/
/// Source: oracle/codemp/ui/ui_gameinfo.c:97
private func UI_LoadArenasFromFile(_ filename: String) {
    let len: Int32
    var f: fileHandle_t = 0
    var buf = CharBuf(8192)

    len = trap_FS_FOpenFile(filename, &f, FS_READ)
    if f == 0 {
        trap_Print(va(S_COLOR_RED + "file not found: %s\n", filename))
        return
    }
    if len >= MAX_ARENAS_TEXT {
        trap_Print(va(S_COLOR_RED + "file too large: %s is %i, max allowed is %i", filename, len, MAX_ARENAS_TEXT))
        trap_FS_FCloseFile(f)
        return
    }

    trap_FS_Read(&buf, len, f)
    buf[len] = 0
    trap_FS_FCloseFile(f)

    ui_numArenas += UI_ParseInfos(&buf, MAX_ARENAS - ui_numArenas, &ui_arenaInfos[Int(ui_numArenas)...])
}

/**
```
===============
UI_LoadArenas
===============
```
*/
/// Source: oracle/codemp/ui/ui_gameinfo.c:125
public func UI_LoadArenas() {
    var numdirs: Int32 = 0
    var filename = CharBuf(128)
    var dirlist = CharBuf(1024)
    var dirptr = TextCursor()
    var i: Int32 = 0
    var n: Int32 = 0
    var dirlen: Int32 = 0
    var type: CharBuf

    ui_numArenas = 0
    uiInfo.mapCount = 0

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
        UI_LoadArenasFromFile(String(filename))
        i += 1
        dirptr.advance(by: dirlen + 1)
    }
    //	trap_Print( va( "%i arenas parsed\n", ui_numArenas ) );
    if UI_OutOfMemory() {
        trap_Print(S_COLOR_YELLOW + "WARNING: not anough memory in pool to load all arenas\n")
    }

    n = 0
    while n < ui_numArenas {
        // determine type

        uiInfo.mapList[uiInfo.mapCount].cinematic = -1
        uiInfo.mapList[uiInfo.mapCount].mapLoadName = String_Alloc(Info_ValueForKey(ui_arenaInfos[n], "map"))
        uiInfo.mapList[uiInfo.mapCount].mapName = String_Alloc(Info_ValueForKey(ui_arenaInfos[n], "longname"))
        uiInfo.mapList[uiInfo.mapCount].levelShot = -1
        uiInfo.mapList[uiInfo.mapCount].imageName = String_Alloc(va("levelshots/%s", uiInfo.mapList[uiInfo.mapCount].mapLoadName ?? "(null)"))
        uiInfo.mapList[uiInfo.mapCount].typeBits = 0

        type = CharBuf(Info_ValueForKey(ui_arenaInfos[n], "type"))
        // if no type specified, it will be treated as "ffa"
        if type[0] != 0 {
            if strstr(type, "ffa") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_FFA)
            }
            if strstr(type, "team") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_TEAM)
            }
            if strstr(type, "holocron") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_HOLOCRON)
            }
            if strstr(type, "jedimaster") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_JEDIMASTER)
            }
            if strstr(type, "duel") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_DUEL)
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_POWERDUEL)
            }
            if strstr(type, "powerduel") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_DUEL)
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_POWERDUEL)
            }
            if strstr(type, "siege") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_SIEGE)
            }
            if strstr(type, "ctf") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_CTF)
            }
            if strstr(type, "cty") != nil {
                uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_CTY)
            }
        } else {
            uiInfo.mapList[uiInfo.mapCount].typeBits |= (1 << GT_FFA)
        }

        uiInfo.mapCount += 1
        if uiInfo.mapCount >= MAX_MAPS {
            break
        }
        n += 1
    }
}

/**
```
===============
UI_LoadBotsFromFile
===============
```
*/
/// Source: oracle/codemp/ui/ui_gameinfo.c:210
private func UI_LoadBotsFromFile(_ filename: String) {
    let len: Int32
    var f: fileHandle_t = 0
    var buf = CharBuf(8192)
    let stopMark: Int32?

    len = trap_FS_FOpenFile(filename, &f, FS_READ)
    if f == 0 {
        trap_Print(va(S_COLOR_RED + "file not found: %s\n", filename))
        return
    }
    if len >= MAX_BOTS_TEXT {
        trap_Print(va(S_COLOR_RED + "file too large: %s is %i, max allowed is %i", filename, len, MAX_BOTS_TEXT))
        trap_FS_FCloseFile(f)
        return
    }

    trap_FS_Read(&buf, len, f)
    buf[len] = 0

    stopMark = strstr(buf, "@STOPHERE")

    //This bot is in place as a mark for modview's bot viewer.
    //If we hit it just stop and trace back to the beginning of the bot define and cut the string off.
    //This is only done in the UI and not the game so that "test" bots can be added manually and still
    //not show up in the menu.
    if stopMark != nil {
        var startPoint: Int32 = stopMark!

        // Port-note: Raven reads before the start of buf when no { comes before the mark, which is undefined.
        // The CharBuf index traps there.
        while buf[startPoint] != Int32(ascii: "{") {
            startPoint -= 1
        }

        buf[startPoint] = 0
    }

    trap_FS_FCloseFile(f)

    COM_Compress(&buf)

    ui_numBots += UI_ParseInfos(&buf, MAX_BOTS - ui_numBots, &ui_botInfos[Int(ui_numBots)...])
}

/**
```
===============
UI_LoadBots
===============
```
*/
/// Source: oracle/codemp/ui/ui_gameinfo.c:260
public func UI_LoadBots() {
    // Raven's record lives to the end of his block, so the block is the closure.
    VmCvar.scratch { botsFile in
        var numdirs: Int32 = 0
        var filename = CharBuf(128)
        var dirlist = CharBuf(1024)
        var dirptr = TextCursor()
        var i: Int32 = 0
        var dirlen: Int32 = 0

        ui_numBots = 0

        trap_Cvar_Register(botsFile, "g_botsFile", "", CVAR_INIT | CVAR_ROM)
        if !botsFile.string.isEmpty {
            UI_LoadBotsFromFile(botsFile.string)
        } else {
            UI_LoadBotsFromFile("botfiles/bots.txt")
        }

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
            UI_LoadBotsFromFile(String(filename))
            i += 1
            dirptr.advance(by: dirlen + 1)
        }
        //	trap_Print( va( "%i bots parsed\n", ui_numBots ) );
    }
}

/**
```
===============
UI_GetBotInfoByNumber
===============
```
*/
/// Source: oracle/codemp/ui/ui_gameinfo.c:297
public func UI_GetBotInfoByNumber(_ num: Int32) -> String? {
    if num < 0 || num >= ui_numBots {
        trap_Print(va(S_COLOR_RED + "Invalid bot number: %i\n", num))
        return nil
    }
    return ui_botInfos[num]
}

/**
```
===============
UI_GetBotInfoByName
===============
```
*/
/// Source: oracle/codemp/ui/ui_gameinfo.c:311
public func UI_GetBotInfoByName(_ name: String) -> String? {
    var n: Int32
    var value: String

    n = 0
    while n < ui_numBots {
        value = Info_ValueForKey(ui_botInfos[n], "name")
        if Q_stricmp(value, name) == 0 {
            return ui_botInfos[n]
        }
        n += 1
    }

    return nil
}

/// Source: oracle/codemp/ui/ui_gameinfo.c:325
public func UI_GetNumBots() -> Int32 {
    return ui_numBots
}

/// Source: oracle/codemp/ui/ui_gameinfo.c:330
public func UI_GetBotNameByNumber(_ num: Int32) -> String {
    let info: String? = UI_GetBotInfoByNumber(num)
    if info != nil {
        return Info_ValueForKey(info!, "name")
    }
    return "Kyle"
}
