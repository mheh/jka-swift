import Foundation
import JKAMP
import JKAShared
import JKAMP_UI
import JKAMP_BG

/// Source: oracle/codemp/ui/ui_atoms.c:10
// Raven wrote: qboolean m_entersound
public let m_entersound: Bool = false

/// Source: oracle/codemp/ui/ui_atoms.c:39
// Raven wrote: qboolean newUI = qfalse
public let newUI: Bool = false

/// Source: oracle/codemp/ui/ui_atoms.c:15
public func Com_Error(_ level: Int32, _ error: String, _ args: any JKAShared.FormatArg...) -> Never {
    var text = CharBuf(1024)

    strcpy(&text, format(error, args))

    trap_Error(va("%s", text))
}

/// Source: oracle/codemp/ui/ui_atoms.c:26
public func Com_Printf(_ msg: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    strcpy(&text, format(msg, args))

    trap_Print(va("%s", text))
}

/**
```
=================
UI_ClampCvar
=================
```
*/
/// Source: oracle/codemp/ui/ui_atoms.c:47
public func UI_ClampCvar(_ min: Float, _ max: Float, _ value: Float) -> Float {
    if value < min { return min }
    if value > max { return max }
    return value
}

/**
```
=================
UI_StartDemoLoop
=================
```
*/
/// Source: oracle/codemp/ui/ui_atoms.c:59
public func UI_StartDemoLoop() {
    trap_Cmd_ExecuteText(EXEC_APPEND, "d1\n")
}

/// Source: oracle/codemp/ui/ui_atoms.c:64
public func UI_Argv(_ arg: Int32) -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var buffer = CharBuf(MAX_STRING_CHARS)

    strcpy(&buffer, trap_Argv(arg, Int32(buffer.count)))

    return String(buffer)
}

/// Source: oracle/codemp/ui/ui_atoms.c:73
public func UI_Cvar_VariableString(_ var_name: String) -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var buffer = CharBuf(MAX_STRING_CHARS)

    strcpy(&buffer, trap_Cvar_VariableStringBuffer(var_name, Int32(buffer.count)))

    return String(buffer)
}

/// Source: oracle/codemp/ui/ui_atoms.c:83
public func UI_SetBestScores(_ newInfo: PostGameInfo, _ postGame: Bool) {
    trap_Cvar_Set("ui_scoreAccuracy", va("%i%%", newInfo.accuracy))
    trap_Cvar_Set("ui_scoreImpressives", va("%i", newInfo.impressives))
    trap_Cvar_Set("ui_scoreExcellents", va("%i", newInfo.excellents))
    trap_Cvar_Set("ui_scoreDefends", va("%i", newInfo.defends))
    trap_Cvar_Set("ui_scoreAssists", va("%i", newInfo.assists))
    trap_Cvar_Set("ui_scoreGauntlets", va("%i", newInfo.gauntlets))
    trap_Cvar_Set("ui_scoreScore", va("%i", newInfo.score))
    trap_Cvar_Set("ui_scorePerfect", va("%i", newInfo.perfects))
    trap_Cvar_Set("ui_scoreTeam", va("%i to %i", newInfo.redScore, newInfo.blueScore))
    trap_Cvar_Set("ui_scoreBase", va("%i", newInfo.baseScore))
    trap_Cvar_Set("ui_scoreTimeBonus", va("%i", newInfo.timeBonus))
    trap_Cvar_Set("ui_scoreSkillBonus", va("%i", newInfo.skillBonus))
    trap_Cvar_Set("ui_scoreShutoutBonus", va("%i", newInfo.shutoutBonus))
    trap_Cvar_Set("ui_scoreTime", va("%02i:%02i", newInfo.time / 60, newInfo.time % 60))
    trap_Cvar_Set("ui_scoreCaptures", va("%i", newInfo.captures))
    if postGame {
        trap_Cvar_Set("ui_scoreAccuracy2", va("%i%%", newInfo.accuracy))
        trap_Cvar_Set("ui_scoreImpressives2", va("%i", newInfo.impressives))
        trap_Cvar_Set("ui_scoreExcellents2", va("%i", newInfo.excellents))
        trap_Cvar_Set("ui_scoreDefends2", va("%i", newInfo.defends))
        trap_Cvar_Set("ui_scoreAssists2", va("%i", newInfo.assists))
        trap_Cvar_Set("ui_scoreGauntlets2", va("%i", newInfo.gauntlets))
        trap_Cvar_Set("ui_scoreScore2", va("%i", newInfo.score))
        trap_Cvar_Set("ui_scorePerfect2", va("%i", newInfo.perfects))
        trap_Cvar_Set("ui_scoreTeam2", va("%i to %i", newInfo.redScore, newInfo.blueScore))
        trap_Cvar_Set("ui_scoreBase2", va("%i", newInfo.baseScore))
        trap_Cvar_Set("ui_scoreTimeBonus2", va("%i", newInfo.timeBonus))
        trap_Cvar_Set("ui_scoreSkillBonus2", va("%i", newInfo.skillBonus))
        trap_Cvar_Set("ui_scoreShutoutBonus2", va("%i", newInfo.shutoutBonus))
        trap_Cvar_Set("ui_scoreTime2", va("%02i:%02i", newInfo.time / 60, newInfo.time % 60))
        trap_Cvar_Set("ui_scoreCaptures2", va("%i", newInfo.captures))
    }
}

/// Source: oracle/codemp/ui/ui_atoms.c:118
public func UI_LoadBestScores(_ map: String, _ game: Int32) {
    var fileName = CharBuf(MAX_QPATH)
    var f: fileHandle_t = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    PostGameInfo.scratch { newInfo in
        Com_sprintf(&fileName, MAX_QPATH, "games/%s_%i.game", map, game)
        if trap_FS_FOpenFile(String(fileName), &f, FS_READ) >= 0 {
            var size: Int32 = 0
            // AI: Raven reads `size` through its address. The read fills a CharBuf of its bytes, and the body takes the value from it.
            var sizeBytes = CharBuf(Int32.byteCount)
            trap_FS_Read(&sizeBytes, Int32(Int32.byteCount), f)
            size = sizeBytes.withSlots { $0[int: 0] }
            if size == Int32(PostGameInfo.byteCount) {
                trap_FS_Read(newInfo.handle, Int32(PostGameInfo.byteCount), f)
            }
            trap_FS_FCloseFile(f)
        }
        UI_SetBestScores(newInfo, false)

        Com_sprintf(&fileName, MAX_QPATH, "demos/%s_%d.dm_%d", map, game, Int32(trap_Cvar_VariableValue("protocol")))
        uiInfo.demoAvailable = false
        if trap_FS_FOpenFile(String(fileName), &f, FS_READ) >= 0 {
            uiInfo.demoAvailable = true
            trap_FS_FCloseFile(f)
        }
    }
}

/**
```
===============
UI_ClearScores
===============
```
*/
/// Source: oracle/codemp/ui/ui_atoms.c:147
public func UI_ClearScores() {
    // Raven's record lives to the end of his block, so the block is the closure.
    PostGameInfo.scratch { newInfo in
        var gameList = CharBuf(4096)
        var gameFile = TextCursor()
        var i: Int32
        var len: Int32
        let count: Int32
        var size: Int32
        var f: fileHandle_t = 0

        let filled = trap_FS_GetFileList("games", "game", Int32(gameList.count))
        count = filled.0
        gameList = filled.1

        size = Int32(PostGameInfo.byteCount)
        newInfo.clear()

        if count > 0 {
            gameFile = TextCursor(gameList)
            i = 0
            while i < count {
                len = strlen(gameFile.text)
                if trap_FS_FOpenFile(va("games/%s", gameFile.text), &f, FS_WRITE) >= 0 {
                    // AI: Raven writes `size` through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
                    var sizeBytes = CharBuf(Int32.byteCount)
                    sizeBytes.withMutableSlots { $0[int: 0] = size }
                    trap_FS_Write(&sizeBytes, Int32(Int32.byteCount), f)
                    trap_FS_Write(newInfo.handle, size, f)
                    trap_FS_FCloseFile(f)
                }
                gameFile.advance(by: len + 1)
                i += 1
            }
        }

        UI_SetBestScores(newInfo, false)

    }
}

/// Source: oracle/codemp/ui/ui_atoms.c:178
private func UI_Cache_f() {
    var i: Int32
    Display_CacheAll()
    if trap_Argc() == 2 {
        i = 0
        while i < uiInfo.q3HeadCount {
            trap_Print(va("model %s\n", uiInfo.q3HeadNames[i]))
            i += 1
        }
    }
}

/**
```
=======================
UI_CalcPostGameStats
=======================
```
*/
/// Source: oracle/codemp/ui/ui_atoms.c:194
private func UI_CalcPostGameStats() {
    // Raven's record lives to the end of his block, so the block is the closure.
    PostGameInfo.scratch { oldInfo in
        // Raven's record lives to the end of his block, so the block is the closure.
        PostGameInfo.scratch { newInfo in
            var map = CharBuf(MAX_QPATH)
            var fileName = CharBuf(MAX_QPATH)
            var info = CharBuf(MAX_INFO_STRING)
            var f: fileHandle_t = 0
            var size: Int32
            let game: Int32
            let time: Int32
            let adjustedTime: Int32
            var newHigh = false

            let filled = trap_GetConfigString(CS_SERVERINFO, Int32(info.count))
            strcpy(&info, filled.1)
            Q_strncpyz(&map, Info_ValueForKey(String(info), "mapname"), Int32(map.count))
            game = atoi(Info_ValueForKey(String(info), "g_gametype"))

            // compose file name
            Com_sprintf(&fileName, MAX_QPATH, "games/%s_%i.game", map, game)
            // see if we have one already
            oldInfo.clear()
            if trap_FS_FOpenFile(String(fileName), &f, FS_READ) >= 0 {
                // if so load it
                size = 0
                // AI: Raven reads `size` through its address. The read fills a CharBuf of its bytes, and the body takes the value from it.
                var sizeBytes = CharBuf(Int32.byteCount)
                trap_FS_Read(&sizeBytes, Int32(Int32.byteCount), f)
                size = sizeBytes.withSlots { $0[int: 0] }
                if size == Int32(PostGameInfo.byteCount) {
                    trap_FS_Read(oldInfo.handle, Int32(PostGameInfo.byteCount), f)
                }
                trap_FS_FCloseFile(f)
            }

            newInfo.accuracy = atoi(UI_Argv(3))
            newInfo.impressives = atoi(UI_Argv(4))
            newInfo.excellents = atoi(UI_Argv(5))
            newInfo.defends = atoi(UI_Argv(6))
            newInfo.assists = atoi(UI_Argv(7))
            newInfo.gauntlets = atoi(UI_Argv(8))
            newInfo.baseScore = atoi(UI_Argv(9))
            newInfo.perfects = atoi(UI_Argv(10))
            newInfo.redScore = atoi(UI_Argv(11))
            newInfo.blueScore = atoi(UI_Argv(12))
            time = atoi(UI_Argv(13))
            newInfo.captures = atoi(UI_Argv(14))

            newInfo.time = Int32((time - trap_Cvar_VariableValue("ui_matchStartTime")) / 1000)
            adjustedTime = uiInfo.mapList[ui_currentMap.integer].timeToBeat[game]
            if newInfo.time < adjustedTime {
                newInfo.timeBonus = (adjustedTime - newInfo.time) * 10
            } else {
                newInfo.timeBonus = 0
            }

            if newInfo.redScore > newInfo.blueScore && newInfo.blueScore <= 0 {
                newInfo.shutoutBonus = 100
            } else {
                newInfo.shutoutBonus = 0
            }

            newInfo.skillBonus = Int32(trap_Cvar_VariableValue("g_spSkill"))
            if newInfo.skillBonus <= 0 {
                newInfo.skillBonus = 1
            }
            newInfo.score = newInfo.baseScore + newInfo.shutoutBonus + newInfo.timeBonus
            newInfo.score *= newInfo.skillBonus

            // see if the score is higher for this one
            newHigh = (newInfo.redScore > newInfo.blueScore && newInfo.score > oldInfo.score)

            if newHigh {
                // if so write out the new one
                uiInfo.newHighScoreTime = uiInfo.uiDC.realTime + 20000
                if trap_FS_FOpenFile(String(fileName), &f, FS_WRITE) >= 0 {
                    size = Int32(PostGameInfo.byteCount)
                    // AI: Raven writes `size` through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
                    var sizeBytes = CharBuf(Int32.byteCount)
                    sizeBytes.withMutableSlots { $0[int: 0] = size }
                    trap_FS_Write(&sizeBytes, Int32(Int32.byteCount), f)
                    trap_FS_Write(newInfo.handle, Int32(PostGameInfo.byteCount), f)
                    trap_FS_FCloseFile(f)
                }
            }

            if newInfo.time < oldInfo.time {
                uiInfo.newBestTime = uiInfo.uiDC.realTime + 20000
            }

            // put back all the ui overrides
            trap_Cvar_Set("capturelimit", UI_Cvar_VariableString("ui_saveCaptureLimit"))
            trap_Cvar_Set("fraglimit", UI_Cvar_VariableString("ui_saveFragLimit"))
            trap_Cvar_Set("duel_fraglimit", UI_Cvar_VariableString("ui_saveDuelLimit"))
            trap_Cvar_Set("cg_drawTimer", UI_Cvar_VariableString("ui_drawTimer"))
            trap_Cvar_Set("g_doWarmup", UI_Cvar_VariableString("ui_doWarmup"))
            trap_Cvar_Set("g_Warmup", UI_Cvar_VariableString("ui_Warmup"))
            trap_Cvar_Set("sv_pure", UI_Cvar_VariableString("ui_pure"))
            trap_Cvar_Set("g_friendlyFire", UI_Cvar_VariableString("ui_friendlyFire"))

            UI_SetBestScores(newInfo, true)
            UI_ShowPostGame(newHigh)


        }
    }
}

/**
```
=================
UI_ConsoleCommand
=================
```
*/
/// Source: oracle/codemp/ui/ui_atoms.c:296
public func UI_ConsoleCommand(_ realTime: Int32) -> Bool {
    let cmd: String

    uiInfo.uiDC.frameTime = realTime - uiInfo.uiDC.realTime
    uiInfo.uiDC.realTime = realTime

    cmd = UI_Argv(0)

    // ensure minimum menu data is available
    //Menu_Cache();

    if Q_stricmp(cmd, "ui_test") == 0 {
        UI_ShowPostGame(true)
    }

    if Q_stricmp(cmd, "ui_report") == 0 {
        UI_Report()
        return true
    }

    if Q_stricmp(cmd, "ui_load") == 0 {
        UI_Load()
        return true
    }

    if Q_stricmp(cmd, "ui_opensiegemenu") == 0 {
        if trap_Cvar_VariableValue("g_gametype") == GT_SIEGE {
            Menus_CloseAll()
            if Menus_ActivateByName(UI_Argv(1)) != nil {
                trap_Key_SetCatcher(KEYCATCH_UI)
            }
        }
        return true
    }

    if Q_stricmp(cmd, "ui_openmenu") == 0 {
        //if ( trap_Cvar_VariableValue ( "developer" ) )
        do {
            Menus_CloseAll()
            if Menus_ActivateByName(UI_Argv(1)) != nil {
                trap_Key_SetCatcher(KEYCATCH_UI)
            }
            return true
        }
    }

    /*
	if ( Q_stricmp (cmd, "remapShader") == 0 ) {
		if (trap_Argc() == 4) {
			char shader1[MAX_QPATH];
			char shader2[MAX_QPATH];
			Q_strncpyz(shader1, UI_Argv(1), sizeof(shader1));
			Q_strncpyz(shader2, UI_Argv(2), sizeof(shader2));
			trap_R_RemapShader(shader1, shader2, UI_Argv(3));
			return qtrue;
		}
	}
	*/

    if Q_stricmp(cmd, "postgame") == 0 {
        UI_CalcPostGameStats()
        return true
    }

    if Q_stricmp(cmd, "ui_cache") == 0 {
        UI_Cache_f()
        return true
    }

    if Q_stricmp(cmd, "ui_teamOrders") == 0 {
        //UI_TeamOrdersMenu_f();
        return true
    }


    if Q_stricmp(cmd, "ui_cdkey") == 0 {
        //UI_CDKeyMenu_f();
        return true
    }

    return false
}

/**
```
=================
UI_Shutdown
=================
```
*/
/// Source: oracle/codemp/ui/ui_atoms.c:389
public func UI_Shutdown() {
}

/// Source: oracle/codemp/ui/ui_atoms.c:393
public func UI_DrawNamedPic(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ picname: String) {
    let hShader: JKAShared.qhandle_t

    hShader = trap_R_RegisterShaderNoMip(picname)
    trap_R_DrawStretchPic(x, y, width, height, 0, 0, 1, 1, hShader)
}

/// Source: oracle/codemp/ui/ui_atoms.c:400
public func UI_DrawHandlePic(_ x: Float, _ y: Float, _ w: Float, _ h: Float, _ hShader: JKAShared.qhandle_t) {
    var w = w
    var h = h
    let s0: Float
    let s1: Float
    let t0: Float
    let t1: Float

    if w < 0 { // flip about vertical
        w = -w
        s0 = 1
        s1 = 0
    } else {
        s0 = 0
        s1 = 1
    }

    if h < 0 { // flip about horizontal
        h = -h
        t0 = 1
        t1 = 0
    } else {
        t0 = 0
        t1 = 1
    }

    trap_R_DrawStretchPic(x, y, w, h, s0, t0, s1, t1, hShader)
}

/**
```
================
UI_FillRect

Coordinates are 640*480 virtual values
=================
```
*/
/// Source: oracle/codemp/ui/ui_atoms.c:436
public func UI_FillRect(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ color: JKAShared.vec4_t?) {
    trap_R_SetColor(color)

    trap_R_DrawStretchPic(x, y, width, height, 0, 0, 0, 0, uiInfo.uiDC.whiteShader)

    trap_R_SetColor(nil)
}

/// Source: oracle/codemp/ui/ui_atoms.c:444
public func UI_DrawSides(_ x: Float, _ y: Float, _ w: Float, _ h: Float) {
    trap_R_DrawStretchPic(x, y, 1, h, 0, 0, 0, 0, uiInfo.uiDC.whiteShader)
    trap_R_DrawStretchPic(x + w - 1, y, 1, h, 0, 0, 0, 0, uiInfo.uiDC.whiteShader)
}

/// Source: oracle/codemp/ui/ui_atoms.c:449
public func UI_DrawTopBottom(_ x: Float, _ y: Float, _ w: Float, _ h: Float) {
    trap_R_DrawStretchPic(x, y, w, 1, 0, 0, 0, 0, uiInfo.uiDC.whiteShader)
    trap_R_DrawStretchPic(x, y + h - 1, w, 1, 0, 0, 0, 0, uiInfo.uiDC.whiteShader)
}

/**
```
================
UI_DrawRect

Coordinates are 640*480 virtual values
=================
```
*/
/// Source: oracle/codemp/ui/ui_atoms.c:460
public func UI_DrawRect(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ color: JKAShared.vec4_t?) {
    trap_R_SetColor(color)

    UI_DrawTopBottom(x, y, width, height)
    UI_DrawSides(x, y, width, height)

    trap_R_SetColor(nil)
}

/// Source: oracle/codemp/ui/ui_atoms.c:469
public func UI_SetColor(_ rgba: JKAShared.vec4_t?) {
    trap_R_SetColor(rgba)
}

/// Source: oracle/codemp/ui/ui_atoms.c:473
public func UI_UpdateScreen() {
    trap_UpdateScreen()
}

/// Source: oracle/codemp/ui/ui_atoms.c:478
public func UI_DrawTextBox(_ x: Int32, _ y: Int32, _ width: Int32, _ lines: Int32) {
    UI_FillRect(Float(x + BIGCHAR_WIDTH / 2), Float(y + BIGCHAR_HEIGHT / 2), Float((width + 1) * BIGCHAR_WIDTH), Float((lines + 1) * BIGCHAR_HEIGHT), colorBlack)
    UI_DrawRect(Float(x + BIGCHAR_WIDTH / 2), Float(y + BIGCHAR_HEIGHT / 2), Float((width + 1) * BIGCHAR_WIDTH), Float((lines + 1) * BIGCHAR_HEIGHT), colorWhite)
}

/// Source: oracle/codemp/ui/ui_atoms.c:484
public func UI_CursorInRect(_ x: Int32, _ y: Int32, _ width: Int32, _ height: Int32) -> Bool {
    if uiInfo.uiDC.cursorx < x ||
        uiInfo.uiDC.cursory < y ||
        uiInfo.uiDC.cursorx > x + width ||
        uiInfo.uiDC.cursory > y + height {
        return false
    }

    return true
}
