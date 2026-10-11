import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/**
```
Debug_Printf
```
*/
/// Source: oracle/codemp/game/NPC_misc.c:10
func Debug_Printf(_ cv: JKAMP.VmCvar, _ debugLevel: Int32, _ fmt: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...) {
    var color: String
    var msg = CharBuf(1024)

    if cv.value < debugLevel {
        return
    }

    if debugLevel == DEBUG_LEVEL_DETAIL {
        color = S_COLOR_WHITE
    } else if debugLevel == DEBUG_LEVEL_INFO {
        color = S_COLOR_GREEN
    } else if debugLevel == DEBUG_LEVEL_WARNING {
        color = S_COLOR_YELLOW
    } else if debugLevel == DEBUG_LEVEL_ERROR {
        color = S_COLOR_RED
    } else {
        color = S_COLOR_RED
    }

    strcpy(&msg, JKAShared.format(String(fmt), args))

    Com_Printf("%s%5i:%s", color, level.time, msg)
}

/**
```
Debug_NPCPrintf
```
*/
/// Source: oracle/codemp/game/NPC_misc.c:41
func Debug_NPCPrintf(_ printNPC: Entity, _ cv: JKAMP.VmCvar, _ debugLevel: Int32, _ fmt: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...) {
    var color: Int32
    var msg = CharBuf(1024)

    if cv.value < debugLevel {
        return
    }

    //	if ( debugNPCName.string[0] && Q_stricmp( debugNPCName.string, printNPC->targetname) != 0 )
    //	{
    //		return;
    //	}

    if debugLevel == DEBUG_LEVEL_DETAIL {
        color = COLOR_WHITE
    } else if debugLevel == DEBUG_LEVEL_INFO {
        color = COLOR_GREEN
    } else if debugLevel == DEBUG_LEVEL_WARNING {
        color = COLOR_YELLOW
    } else if debugLevel == DEBUG_LEVEL_ERROR {
        color = COLOR_RED
    } else {
        color = COLOR_RED
    }

    strcpy(&msg, JKAShared.format(String(fmt), args))

    Com_Printf("%c%c%5i (%s) %s", Q_COLOR_ESCAPE, color, level.time, printNPC.targetname!, msg)
}
