import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_servercmds.c:1057
let MAX_STRINGED_SV_STRING = 1024 as Int32

/**
```
=================
CG_ParseScores

=================
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:21
private func CG_ParseScores() {
    var i: Int32
    var powerups: Int32
    var readScores: Int32

    cg.numScores = atoi(CG_Argv(1))

    readScores = cg.numScores

    if readScores > MAX_CLIENT_SCORE_SEND {
        readScores = MAX_CLIENT_SCORE_SEND
    }

    if cg.numScores > MAX_CLIENTS {
        cg.numScores = MAX_CLIENTS
    }

    cg.numScores = readScores

    cg.teamScores[0] = atoi(CG_Argv(2))
    cg.teamScores[1] = atoi(CG_Argv(3))

    cg.scores.zero()
    i = 0
    while i < readScores {
        //
        cg.scores[i].client = atoi(CG_Argv(i * 14 + 4))
        cg.scores[i].score = atoi(CG_Argv(i * 14 + 5))
        cg.scores[i].ping = atoi(CG_Argv(i * 14 + 6))
        cg.scores[i].time = atoi(CG_Argv(i * 14 + 7))
        cg.scores[i].scoreFlags = atoi(CG_Argv(i * 14 + 8))
        powerups = atoi(CG_Argv(i * 14 + 9))
        cg.scores[i].accuracy = atoi(CG_Argv(i * 14 + 10))
        cg.scores[i].impressiveCount = atoi(CG_Argv(i * 14 + 11))
        cg.scores[i].excellentCount = atoi(CG_Argv(i * 14 + 12))
        cg.scores[i].guantletCount = atoi(CG_Argv(i * 14 + 13))
        cg.scores[i].defendCount = atoi(CG_Argv(i * 14 + 14))
        cg.scores[i].assistCount = atoi(CG_Argv(i * 14 + 15))
        cg.scores[i].perfect = atoi(CG_Argv(i * 14 + 16)) != 0
        cg.scores[i].captures = atoi(CG_Argv(i * 14 + 17))

        if cg.scores[i].client < 0 || cg.scores[i].client >= MAX_CLIENTS {
            cg.scores[i].client = 0
        }
        cgs.clientinfo[cg.scores[i].client].score = cg.scores[i].score
        cgs.clientinfo[cg.scores[i].client].powerups = powerups

        cg.scores[i].team = cgs.clientinfo[cg.scores[i].client].team
        i += 1
    }
    CG_SetScoreSelection(nil)
}

/**
```
=================
CG_ParseTeamInfo

=================
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:77
private func CG_ParseTeamInfo() {
    var i: Int32
    var client: Int32

    numSortedTeamPlayers = atoi(CG_Argv(1))

    i = 0
    while i < numSortedTeamPlayers {
        client = atoi(CG_Argv(i * 6 + 2))

        sortedTeamPlayers[i] = client

        cgs.clientinfo[client].location = atoi(CG_Argv(i * 6 + 3))
        cgs.clientinfo[client].health = atoi(CG_Argv(i * 6 + 4))
        cgs.clientinfo[client].armor = atoi(CG_Argv(i * 6 + 5))
        cgs.clientinfo[client].curWeapon = atoi(CG_Argv(i * 6 + 6))
        cgs.clientinfo[client].powerups = atoi(CG_Argv(i * 6 + 7))
        i += 1
    }
}

/**
```
================
CG_ParseServerinfo

This is called explicitly when the gamestate is first received,
and whenever the server updates any serverinfo flagged cvars
================
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:105
func CG_ParseServerinfo() {
    let info: String
    let tinfo: String
    let mapname: String

    info = CG_ConfigString(CS_SERVERINFO)

    cgs.debugMelee = atoi(Info_ValueForKey(info, "g_debugMelee")) //trap_Cvar_GetHiddenVarValue("g_iknowkungfu");
    cgs.stepSlideFix = atoi(Info_ValueForKey(info, "g_stepSlideFix"))

    cgs.noSpecMove = atoi(Info_ValueForKey(info, "g_noSpecMove"))

    trap_Cvar_Set("bg_fighterAltControl", Info_ValueForKey(info, "bg_fighterAltControl"))

    cgs.siegeTeamSwitch = atoi(Info_ValueForKey(info, "g_siegeTeamSwitch"))

    cgs.showDuelHealths = atoi(Info_ValueForKey(info, "g_showDuelHealths"))

    cgs.gametype = atoi(Info_ValueForKey(info, "g_gametype"))
    trap_Cvar_Set("g_gametype", va("%i", cgs.gametype))
    cgs.needpass = atoi(Info_ValueForKey(info, "needpass")) != 0
    cgs.jediVmerc = atoi(Info_ValueForKey(info, "g_jediVmerc")) != 0
    cgs.wDisable = atoi(Info_ValueForKey(info, "wdisable"))
    cgs.fDisable = atoi(Info_ValueForKey(info, "fdisable"))
    cgs.dmflags = atoi(Info_ValueForKey(info, "dmflags"))
    cgs.teamflags = atoi(Info_ValueForKey(info, "teamflags"))
    cgs.fraglimit = atoi(Info_ValueForKey(info, "fraglimit"))
    cgs.duel_fraglimit = atoi(Info_ValueForKey(info, "duel_fraglimit"))
    cgs.capturelimit = atoi(Info_ValueForKey(info, "capturelimit"))
    cgs.timelimit = atoi(Info_ValueForKey(info, "timelimit"))
    cgs.maxclients = atoi(Info_ValueForKey(info, "sv_maxclients"))
    mapname = Info_ValueForKey(info, "mapname")

    //rww - You must do this one here, Info_ValueForKey always uses the same memory pointer.
    trap_Cvar_Set("ui_about_mapname", mapname)

    Com_sprintf(&cgs.mapnameBuffer, 64, "maps/%s.bsp", mapname)
    //	Q_strncpyz( cgs.redTeam, Info_ValueForKey( info, "g_redTeam" ), sizeof(cgs.redTeam) );
    //	trap_Cvar_Set("g_redTeam", cgs.redTeam);
    //	Q_strncpyz( cgs.blueTeam, Info_ValueForKey( info, "g_blueTeam" ), sizeof(cgs.blueTeam) );
    //	trap_Cvar_Set("g_blueTeam", cgs.blueTeam);

    trap_Cvar_Set("ui_about_gametype", va("%i", cgs.gametype))
    trap_Cvar_Set("ui_about_fraglimit", va("%i", cgs.fraglimit))
    trap_Cvar_Set("ui_about_duellimit", va("%i", cgs.duel_fraglimit))
    trap_Cvar_Set("ui_about_capturelimit", va("%i", cgs.capturelimit))
    trap_Cvar_Set("ui_about_timelimit", va("%i", cgs.timelimit))
    trap_Cvar_Set("ui_about_maxclients", va("%i", cgs.maxclients))
    trap_Cvar_Set("ui_about_dmflags", va("%i", cgs.dmflags))
    trap_Cvar_Set("ui_about_hostname", Info_ValueForKey(info, "sv_hostname"))
    trap_Cvar_Set("ui_about_needpass", Info_ValueForKey(info, "g_needpass"))
    trap_Cvar_Set("ui_about_botminplayers", Info_ValueForKey(info, "bot_minplayers"))

    //Set the siege teams based on what the server has for overrides.
    trap_Cvar_Set("cg_siegeTeam1", Info_ValueForKey(info, "g_siegeTeam1"))
    trap_Cvar_Set("cg_siegeTeam2", Info_ValueForKey(info, "g_siegeTeam2"))

    tinfo = CG_ConfigString(CS_TERRAINS + 1)
    // Raven's `!tinfo || !*tinfo` tests the pointer and the first byte.
    // The configstring text is never NULL, so both tests read as one.
    if tinfo.isEmpty {
        cg.mInRMG = false
    } else {
        var weather: Int32 = 0

        cg.mInRMG = true
        trap_Cvar_Set("RMG", "1")

        weather = atoi(Info_ValueForKey(info, "RMG_weather"))

        trap_Cvar_Set("RMG_weather", va("%i", weather))

        if weather == 1 || weather == 2 {
            cg.mRMGWeather = true
        } else {
            cg.mRMGWeather = false
        }
    }
}

/**
```
==================
CG_ParseWarmup
==================
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:194
private func CG_ParseWarmup() {
    let info: String
    let warmup: Int32

    info = CG_ConfigString(CS_WARMUP)

    warmup = atoi(info)
    cg.warmupCount = -1

    cg.warmup = warmup
}

/**
```
================
CG_SetConfigValues

Called on load to set the initial values from configure strings
================
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:213
func CG_SetConfigValues() {
    let s: String
    let str: String

    cgs.scores1 = atoi(CG_ConfigString(CS_SCORES1))
    cgs.scores2 = atoi(CG_ConfigString(CS_SCORES2))
    cgs.levelStartTime = atoi(CG_ConfigString(CS_LEVEL_START_TIME))
    if cgs.gametype == GT_CTF || cgs.gametype == GT_CTY {
        s = CG_ConfigString(CS_FLAGSTATUS)
        cgs.redflag = CharBuf(s)[0] - Int32(ascii: "0")
        cgs.blueflag = CharBuf(s)[1] - Int32(ascii: "0")
    }
    cg.warmup = atoi(CG_ConfigString(CS_WARMUP))

    // Track who the jedi master is
    cgs.jediMaster = atoi(CG_ConfigString(CS_CLIENT_JEDIMASTER))
    cgs.duelWinner = atoi(CG_ConfigString(CS_CLIENT_DUELWINNER))

    str = CG_ConfigString(CS_CLIENT_DUELISTS)

    if !str.isEmpty {
        var buf = CharBuf(64)
        var c: Int32 = 0
        var i: Int32 = 0

        while CharBuf(str)[i] != 0 && CharBuf(str)[i] != Int32(ascii: "|") {
            buf[c] = CharBuf(str)[i]
            c += 1
            i += 1
        }
        buf[c] = 0

        cgs.duelist1 = atoi(buf)
        c = 0

        i += 1
        while CharBuf(str)[i] != 0 {
            buf[c] = CharBuf(str)[i]
            c += 1
            i += 1
        }
        buf[c] = 0

        cgs.duelist2 = atoi(buf)
    }
}

/**
```
=====================
CG_ShaderStateChanged
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:269
func CG_ShaderStateChanged() {
    var originalShader = CharBuf(64)
    var newShader = CharBuf(64)
    var timeOffset = CharBuf(16)
    var o: TextCursor
    var n: Int32?
    var t: Int32?

    o = TextCursor(CharBuf(CG_ConfigString(CS_SHADERSTATE)))
    while !o.isNull && o.byte != 0 {
        if let found = strstr(o.buf[o.offset!...], "=") {
            n = o.offset! + found
        } else {
            n = nil
        }
        if n != nil && o.buf[n!] != 0 {
            strncpy(&originalShader, o.buf[o.offset!...], n! - o.offset!)
            originalShader[n! - o.offset!] = 0
            n! += 1
            if let found = strstr(o.buf[n!...], ":") {
                t = n! + found
            } else {
                t = nil
            }
            if t != nil && o.buf[t!] != 0 {
                strncpy(&newShader, o.buf[n!...], t! - n!)
                newShader[t! - n!] = 0
            } else {
                break
            }
            t! += 1
            if let found = strstr(o.buf[t!...], "@") {
                o.offset = t! + found
            } else {
                o.offset = nil
            }
            if !o.isNull {
                strncpy(&timeOffset, o.buf[t!...], o.offset! - t!)
                timeOffset[o.offset! - t!] = 0
                o.advance()
                trap_R_RemapShader(String(originalShader), String(newShader), String(timeOffset))
            }
        } else {
            break
        }
    }
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:310
private func GetCustomSoundForType(_ setType: Int32, _ index: Int32) -> String? {
    switch setType {
    case 1:
        return cg_customSoundNames[index]

    case 2:
        return cg_customCombatSoundNames[index]

    case 3:
        return cg_customExtraSoundNames[index]

    case 4:
        return cg_customJediSoundNames[index]

    case 5:
        return bg_customSiegeSoundNames[index]

    case 6:
        return cg_customDuelSoundNames[index]

    default:
        return nil
    }
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:332
func SetCustomSoundForType(_ ci: ClientInfo, _ setType: Int32, _ index: Int32, _ sfx: JKAShared.sfxHandle_t) {
    switch setType {
    case 1:
        ci.sounds[index] = sfx

    case 2:
        ci.combatSounds[index] = sfx

    case 3:
        ci.extraSounds[index] = sfx

    case 4:
        ci.jediSounds[index] = sfx

    case 5:
        ci.siegeSounds[index] = sfx

    case 6:
        ci.duelSounds[index] = sfx

    default:
        break
    }
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:360
private func CG_RegisterCustomSounds(_ ci: ClientInfo, _ setType: Int32, _ psDir: String) {
    var iTableEntries: Int32 = 0
    var i: Int32

    switch setType {
    case 1:
        iTableEntries = MAX_CUSTOM_SOUNDS

    case 2:
        iTableEntries = MAX_CUSTOM_COMBAT_SOUNDS

    case 3:
        iTableEntries = MAX_CUSTOM_EXTRA_SOUNDS

    case 4:
        iTableEntries = MAX_CUSTOM_JEDI_SOUNDS

    case 5:
        iTableEntries = MAX_CUSTOM_SIEGE_SOUNDS
        fallthrough

    default:
        return
    }

    i = 0
    while i < iTableEntries {
        var hSFX: sfxHandle_t
        var s = GetCustomSoundForType(setType, i).map { TextCursor(CharBuf($0)) } ?? TextCursor()

        if s.isNull {
            break
        }

        s.advance()
        hSFX = trap_S_RegisterSound(va("sound/chars/%s/misc/%s", psDir, s.text))

        if hSFX == 0 {
            var modifiedSound = CharBuf(64)
            var p: Int32? = nil

            strcpy(&modifiedSound, s.text)
            p = strchr(modifiedSound, Int32(ascii: "."))

            if var p {
                var testNumber = CharBuf(2)
                p -= 1

                //before we destroy it.. we want to see if this is actually a number.
                //If it isn't a number then don't try decrementing and registering as
                //it will only cause a disk hit (we don't try precaching such files)
                testNumber[0] = modifiedSound[p]
                testNumber[1] = 0
                if atoi(testNumber) != 0 {
                    modifiedSound[p] = 0

                    strcat(&modifiedSound, "1.wav")

                    hSFX = trap_S_RegisterSound(va("sound/chars/%s/misc/%s", psDir, modifiedSound))
                }
            }
        }

        SetCustomSoundForType(ci, setType, i, hSFX)
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:432
func CG_PrecacheNPCSounds(_ str: String) {
    var sEnd = CharBuf(64)
    var pEnd = CharBuf(64)
    var i: Int32 = 0
    var j: Int32 = 0
    var k: Int32 = 0

    k = 2

    while CharBuf(str)[k] != 0 {
        pEnd[k - 2] = CharBuf(str)[k]
        k += 1
    }
    pEnd[k - 2] = 0

    while i < 4 {
        //It would be better if we knew what type this actually was (extra, combat, jedi, etc).
        //But that would require extra configstring indexing and that is a bad thing.

        while j < MAX_CUSTOM_SOUNDS {
            var s: String? = GetCustomSoundForType(i + 1, j)

            if s != nil && !s!.isEmpty {
                //whatever it is, try registering it under this folder.
                k = 1
                while CharBuf(s!)[k] != 0 {
                    sEnd[k - 1] = CharBuf(s!)[k]
                    k += 1
                }
                sEnd[k - 1] = 0

                trap_S_ShutUp(true)
                trap_S_RegisterSound(va("sound/chars/%s/misc/%s", pEnd, sEnd))
                trap_S_ShutUp(false)
            } else {
                //move onto the next set
                break
            }

            j += 1
        }

        j = 0
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:484
func CG_HandleNPCSounds(_ cent: Centity) {
    if cent.npcClient == nil {
        return
    }

    //standard
    if cent.currentState.csSounds_Std != 0 {
        let s: String = CG_ConfigString(CS_SOUNDS + cent.currentState.csSounds_Std)

        if !s.isEmpty {
            var sEnd = CharBuf(64)
            var i: Int32 = 2
            var j: Int32 = 0

            //Parse past the initial "*" which indicates this is a custom sound, and the $ which indicates
            //it is an NPC custom sound dir.
            while CharBuf(s)[i] != 0 {
                sEnd[j] = CharBuf(s)[i]
                j += 1
                i += 1
            }
            sEnd[j] = 0

            CG_RegisterCustomSounds(cent.npcClient!, 1, String(sEnd))
        }
    } else {
        cent.npcClient!.sounds.fill(0)
    }

    //combat
    if cent.currentState.csSounds_Combat != 0 {
        let s: String = CG_ConfigString(CS_SOUNDS + cent.currentState.csSounds_Combat)

        if !s.isEmpty {
            var sEnd = CharBuf(64)
            var i: Int32 = 2
            var j: Int32 = 0

            //Parse past the initial "*" which indicates this is a custom sound, and the $ which indicates
            //it is an NPC custom sound dir.
            while CharBuf(s)[i] != 0 {
                sEnd[j] = CharBuf(s)[i]
                j += 1
                i += 1
            }
            sEnd[j] = 0

            CG_RegisterCustomSounds(cent.npcClient!, 2, String(sEnd))
        }
    } else {
        cent.npcClient!.combatSounds.fill(0)
    }

    //extra
    if cent.currentState.csSounds_Extra != 0 {
        let s: String = CG_ConfigString(CS_SOUNDS + cent.currentState.csSounds_Extra)

        if !s.isEmpty {
            var sEnd = CharBuf(64)
            var i: Int32 = 2
            var j: Int32 = 0

            //Parse past the initial "*" which indicates this is a custom sound, and the $ which indicates
            //it is an NPC custom sound dir.
            while CharBuf(s)[i] != 0 {
                sEnd[j] = CharBuf(s)[i]
                j += 1
                i += 1
            }
            sEnd[j] = 0

            CG_RegisterCustomSounds(cent.npcClient!, 3, String(sEnd))
        }
    } else {
        cent.npcClient!.extraSounds.fill(0)
    }

    //jedi
    if cent.currentState.csSounds_Jedi != 0 {
        let s: String = CG_ConfigString(CS_SOUNDS + cent.currentState.csSounds_Jedi)

        if !s.isEmpty {
            var sEnd = CharBuf(64)
            var i: Int32 = 2
            var j: Int32 = 0

            //Parse past the initial "*" which indicates this is a custom sound, and the $ which indicates
            //it is an NPC custom sound dir.
            while CharBuf(s)[i] != 0 {
                sEnd[j] = CharBuf(s)[i]
                j += 1
                i += 1
            }
            sEnd[j] = 0

            CG_RegisterCustomSounds(cent.npcClient!, 4, String(sEnd))
        }
    } else {
        cent.npcClient!.jediSounds.fill(0)
    }
}

// nmckenzie: DUEL_HEALTH - fixme - we could really clean this up immensely with some helper functions.
/// Source: oracle/codemp/cgame/cg_servercmds.c:612
func SetDuelistHealthsFromConfigString(_ str: String) {
    var buf = CharBuf(64)
    var c: Int32 = 0
    var i: Int32 = 0

    while CharBuf(str)[i] != 0 && CharBuf(str)[i] != Int32(ascii: "|") {
        buf[c] = CharBuf(str)[i]
        c += 1
        i += 1
    }
    buf[c] = 0

    cgs.duelist1health = atoi(buf)

    c = 0
    i += 1
    while CharBuf(str)[i] != 0 && CharBuf(str)[i] != Int32(ascii: "|") {
        buf[c] = CharBuf(str)[i]
        c += 1
        i += 1
    }
    buf[c] = 0

    cgs.duelist2health = atoi(buf)

    c = 0
    i += 1
    if CharBuf(str)[i] == Int32(ascii: "!") {
        // we only have 2 duelists, apparently.
        cgs.duelist3health = -1
        return
    }

    while CharBuf(str)[i] != 0 && CharBuf(str)[i] != Int32(ascii: "|") {
        buf[c] = CharBuf(str)[i]
        c += 1
        i += 1
    }
    buf[c] = 0

    cgs.duelist3health = atoi(buf)
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:671
private func CG_ConfigStringModified() {
    let str: String
    let num: Int32

    num = atoi(CG_Argv(1))

    // get the gamestate from the client system, which will have the
    // new configstring already integrated
    trap_GetGameState(cgs.gameState)

    // look up the individual string that was modified
    str = CG_ConfigString(num)

    // do something with it if necessary
    if num == CS_MUSIC {
        CG_StartMusic(true)
    } else if num == CS_SERVERINFO {
        CG_ParseServerinfo()
    } else if num == CS_WARMUP {
        CG_ParseWarmup()
    } else if num == CS_SCORES1 {
        cgs.scores1 = atoi(str)
    } else if num == CS_SCORES2 {
        cgs.scores2 = atoi(str)
    } else if num == CS_CLIENT_JEDIMASTER {
        cgs.jediMaster = atoi(str)
    } else if num == CS_CLIENT_DUELWINNER {
        cgs.duelWinner = atoi(str)
    } else if num == CS_CLIENT_DUELISTS {
        var buf = CharBuf(64)
        var c: Int32 = 0
        var i: Int32 = 0

        while CharBuf(str)[i] != 0 && CharBuf(str)[i] != Int32(ascii: "|") {
            buf[c] = CharBuf(str)[i]
            c += 1
            i += 1
        }
        buf[c] = 0

        cgs.duelist1 = atoi(buf)
        c = 0

        i += 1
        while CharBuf(str)[i] != 0 && CharBuf(str)[i] != Int32(ascii: "|") {
            buf[c] = CharBuf(str)[i]
            c += 1
            i += 1
        }
        buf[c] = 0

        cgs.duelist2 = atoi(buf)

        if CharBuf(str)[i] != 0 {
            c = 0
            i += 1

            while CharBuf(str)[i] != 0 {
                buf[c] = CharBuf(str)[i]
                c += 1
                i += 1
            }
            buf[c] = 0

            cgs.duelist3 = atoi(buf)
        }
    } else if num == CS_CLIENT_DUELHEALTHS {
        // nmckenzie: DUEL_HEALTH
        SetDuelistHealthsFromConfigString(str)
    } else if num == CS_LEVEL_START_TIME {
        cgs.levelStartTime = atoi(str)
    } else if num == CS_VOTE_TIME {
        cgs.voteTime = atoi(str)
        cgs.voteModified = true
    } else if num == CS_VOTE_YES {
        cgs.voteYes = atoi(str)
        cgs.voteModified = true
    } else if num == CS_VOTE_NO {
        cgs.voteNo = atoi(str)
        cgs.voteModified = true
    } else if num == CS_VOTE_STRING {
        Q_strncpyz(&cgs.voteStringBuffer, str, 1024)
    } else if num >= CS_TEAMVOTE_TIME && num <= CS_TEAMVOTE_TIME + 1 {
        cgs.teamVoteTime[num - CS_TEAMVOTE_TIME] = atoi(str)
        cgs.teamVoteModified[num - CS_TEAMVOTE_TIME] = true
    } else if num >= CS_TEAMVOTE_YES && num <= CS_TEAMVOTE_YES + 1 {
        cgs.teamVoteYes[num - CS_TEAMVOTE_YES] = atoi(str)
        cgs.teamVoteModified[num - CS_TEAMVOTE_YES] = true
    } else if num >= CS_TEAMVOTE_NO && num <= CS_TEAMVOTE_NO + 1 {
        cgs.teamVoteNo[num - CS_TEAMVOTE_NO] = atoi(str)
        cgs.teamVoteModified[num - CS_TEAMVOTE_NO] = true
    } else if num >= CS_TEAMVOTE_STRING && num <= CS_TEAMVOTE_STRING + 1 {
        // Raven passes sizeof(teamVoteString), 2048, so the NUL pad of row 0 clears row 1 and the pad of row 1 overruns the array.
        // The store bounds the text to its row, and the other row keeps its bytes.
        var teamVoteString = CharBuf(2048)
        Q_strncpyz(&teamVoteString, str, 2048)
        cgs.teamVoteString[num - CS_TEAMVOTE_STRING] = String(teamVoteString)
    } else if num == CS_INTERMISSION {
        cg.intermissionStarted = atoi(str) != 0
    } else if num >= CS_MODELS && num < CS_MODELS + MAX_MODELS {
        var modelName = CharBuf(64)
        strcpy(&modelName, str)
        if strstr(modelName, ".glm") != nil || modelName[0] == Int32(ascii: "$") {
            //Check to see if it has a custom skin attached.
            CG_HandleAppendedSkin(&modelName)
            CG_CacheG2AnimInfo(String(modelName))
        }

        if modelName[0] != Int32(ascii: "$") && modelName[0] != Int32(ascii: "@") {
            //don't register vehicle names and saber names as models.
            cgs.gameModels[num - CS_MODELS] = trap_R_RegisterModel(String(modelName))
        } else {
            cgs.gameModels[num - CS_MODELS] = 0
        }
        // GHOUL2 Insert start
        /*
        } else if ( num >= CS_CHARSKINS && num < CS_CHARSKINS+MAX_CHARSKINS ) {
        cgs.skins[ num-CS_CHARSKINS ] = trap_R_RegisterSkin( str );
        */
        //rww - removed and replaced with CS_G2BONES
        // Ghoul2 Insert end
    } else if num >= CS_SOUNDS && num < CS_SOUNDS + MAX_SOUNDS {
        if CharBuf(str)[0] != Int32(ascii: "*") {
            // player specific sounds don't register here
            cgs.gameSounds[num - CS_SOUNDS] = trap_S_RegisterSound(str)
        } else if CharBuf(str)[1] == Int32(ascii: "$") {
            //an NPC soundset
            CG_PrecacheNPCSounds(str)
        }
    } else if num >= CS_EFFECTS && num < CS_EFFECTS + MAX_FX {
        if CharBuf(str)[0] == Int32(ascii: "*") {
            //it's a special global weather effect
            CG_ParseWeatherEffect(str)
            cgs.gameEffects[num - CS_EFFECTS] = 0
        } else {
            cgs.gameEffects[num - CS_EFFECTS] = trap_FX_RegisterEffect(str)
        }
    } else if num >= CS_SIEGE_STATE && num < CS_SIEGE_STATE + 1 {
        if !str.isEmpty {
            CG_ParseSiegeState(str)
        }
    } else if num >= CS_SIEGE_WINTEAM && num < CS_SIEGE_WINTEAM + 1 {
        if !str.isEmpty {
            cg_siegeWinTeam = atoi(str)
        }
    } else if num >= CS_SIEGE_OBJECTIVES && num < CS_SIEGE_OBJECTIVES + 1 {
        CG_ParseSiegeObjectiveStatus(str)
    } else if num >= CS_SIEGE_TIMEOVERRIDE && num < CS_SIEGE_TIMEOVERRIDE + 1 {
        cg_beatingSiegeTime = atoi(str)
        CG_SetSiegeTimerCvar(cg_beatingSiegeTime)
    } else if num >= CS_PLAYERS && num < CS_PLAYERS + MAX_CLIENTS {
        CG_NewClientInfo(num - CS_PLAYERS, true)
        CG_BuildSpectatorString()
    } else if num == CS_FLAGSTATUS {
        if cgs.gametype == GT_CTF || cgs.gametype == GT_CTY {
            // format is rb where its red/blue, 0 is at base, 1 is taken, 2 is dropped
            cgs.redflag = CharBuf(str)[0] - Int32(ascii: "0")
            cgs.blueflag = CharBuf(str)[1] - Int32(ascii: "0")
        }
    } else if num == CS_SHADERSTATE {
        CG_ShaderStateChanged()
    } else if num >= CS_LIGHT_STYLES && num < CS_LIGHT_STYLES + (MAX_LIGHT_STYLES * 3) {
        CG_SetLightstyle(num - CS_LIGHT_STYLES)
    }
}

//frees all ghoul2 stuff and npc stuff from a centity -rww
/// Source: oracle/codemp/cgame/cg_servercmds.c:863
func CG_KillCEntityG2(_ entNum: Int32) {
    var j: Int32
    var ci: ClientInfo? = nil
    let cent: Centity? = cg_entities[entNum]

    if entNum < MAX_CLIENTS {
        ci = cgs.clientinfo[entNum]
    } else {
        ci = cent!.npcClient
    }

    if ci != nil {
        if ci == cent!.npcClient {
            //never going to be != cent->ghoul2, unless cent->ghoul2 has already been removed (and then this ptr is not valid)
            ci!.ghoul2Model = nil
        } else if ci!.ghoul2Model == cent!.ghoul2 {
            ci!.ghoul2Model = nil
        } else if ci!.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(ci!.ghoul2Model) {
            trap_G2API_CleanGhoul2Models(&ci!.ghoul2Model)
            ci!.ghoul2Model = nil
        }

        //Clean up any weapon instances for custom saber stuff
        j = 0
        while j < MAX_SABERS {
            if ci!.ghoul2Weapons[j] != nil && trap_G2_HaveWeGhoul2Models(ci!.ghoul2Weapons[j]) {
                trap_G2API_CleanGhoul2Models(&ci!.ghoul2Weapons[j])
                ci!.ghoul2Weapons[j] = nil
            }

            j += 1
        }
    }

    if cent!.ghoul2 != nil && trap_G2_HaveWeGhoul2Models(cent!.ghoul2) {
        trap_G2API_CleanGhoul2Models(&cent!.ghoul2)
        cent!.ghoul2 = nil
    }

    if cent!.grip_arm != nil && trap_G2_HaveWeGhoul2Models(cent!.grip_arm) {
        trap_G2API_CleanGhoul2Models(&cent!.grip_arm)
        cent!.grip_arm = nil
    }

    if cent!.frame_hold != nil && trap_G2_HaveWeGhoul2Models(cent!.frame_hold) {
        trap_G2API_CleanGhoul2Models(&cent!.frame_hold)
        cent!.frame_hold = nil
    }

    if cent!.npcClient != nil {
        CG_DestroyNPCClient(&cent!.npcClient)
    }

    cent!.isRagging = false //just in case.
    cent!.ikStatus = false

    cent!.localAnimIndex = 0
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:937
func CG_KillCEntityInstances() {
    var i: Int32 = 0
    var cent: Centity?

    while i < MAX_GENTITIES {
        cent = cg_entities[i]

        if i >= MAX_CLIENTS && cent!.currentState.number == i {
            //do not clear G2 instances on client ents, they are constant
            CG_KillCEntityG2(i)
        }

        cent!.bolt1 = 0
        cent!.bolt2 = 0
        cent!.bolt3 = 0
        cent!.bolt4 = 0

        cent!.bodyHeight = 0 //SABER_LENGTH_MAX;
        //cent->saberExtendTime = 0;

        cent!.boltInfo = 0

        cent!.frame_minus1_refreshed = 0
        cent!.frame_minus2_refreshed = 0
        cent!.dustTrailTime = 0
        cent!.ghoul2weapon = nil
        //cent->torsoBolt = 0;
        cent!.trailTime = 0
        cent!.frame_hold_time = 0
        cent!.frame_hold_refreshed = 0
        cent!.trickAlpha = 0
        cent!.trickAlphaTime = 0
        cent!.turAngles = vec3_t()
        cent!.weapon = 0
        cent!.teamPowerEffectTime = 0
        cent!.teamPowerType = 0 != 0
        cent!.numLoopingSounds = 0

        cent!.localAnimIndex = 0

        i += 1
    }
}

/**
```
===============
CG_MapRestart

The server has issued a map_restart, so the next snapshot
is completely new and should not be interpolated to.

A tournement restart will clear everything, but doesn't
require a reload of all the media
===============
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:994
private func CG_MapRestart() {
    if cg_showmiss.integer != 0 {
        CG_Printf("CG_MapRestart\n")
    }

    trap_R_ClearDecals()
    //FIXME: trap_FX_Reset?

    CG_InitLocalEntities()
    CG_InitMarkPolys()
    CG_ClearParticles()
    CG_KillCEntityInstances()

    // make sure the "3 frags left" warnings play again
    cg.fraglimitWarnings = 0

    cg.timelimitWarnings = 0

    cg.intermissionStarted = false

    cgs.voteTime = 0

    cg.mapRestart = true

    CG_StartMusic(true)

    trap_S_ClearLoopingSounds()

    // we really should clear more parts of cg here and stop sounds

    // play the "fight" sound if this is a restart without warmup
    if cg.warmup == 0 && cgs.gametype != GT_SIEGE && cgs.gametype != GT_POWERDUEL {
        trap_S_StartLocalSound(cgs.media.countFightSound, CHAN_ANNOUNCER)
        CG_CenterPrint(CG_GetStringEdString("MP_SVGAME", "BEGIN_DUEL"), 120, GIANTCHAR_WIDTH * 2)
    }
    /*
    if (cg_singlePlayerActive.integer) {
    trap_Cvar_Set("ui_matchStartTime", va("%i", cg.time));
    if (cg_recordSPDemo.integer && cg_recordSPDemoName.string && *cg_recordSPDemoName.string) {
    trap_SendConsoleCommand(va("set g_synchronousclients 1 ; record %s \n", cg_recordSPDemoName.string));
    }
    }
    */
    trap_Cvar_Set("cg_thirdPerson", "0")
}

/**
```
=================
CG_RemoveChatEscapeChar
=================
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:1045
private func CG_RemoveChatEscapeChar(_ text: inout JKAShared.CharBuf) {
    var i: Int32
    var l: Int32
    var textIndex: Int32 = 0

    l = 0
    i = 0
    while text[textIndex + i] != 0 {
        if text[textIndex + i] == Int32(ascii: "\u{19}") {
            i += 1
            continue
        }
        text[textIndex + l] = text[textIndex + i]
        l += 1
        i += 1
    }
    text[textIndex + l] = 0
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:1059
func CG_CheckSVStringEdRef(_ buf: inout JKAShared.CharBuf, _ str: String) {
    //I don't really like doing this. But it utilizes the system that was already in place.
    var i: Int32 = 0
    var b: Int32 = 0
    var strLen: Int32 = 0
    var gotStrip: Bool = false
    var bufIndex: Int32 = 0

    if str.isEmpty {
        strcpy(&buf, str, at: bufIndex)
        return
    }

    strcpy(&buf, str, at: bufIndex)

    strLen = strlen(str)

    if strLen >= MAX_STRINGED_SV_STRING {
        return
    }

    while i < strLen && CharBuf(str)[i] != 0 {
        gotStrip = false

        if CharBuf(str)[i] == Int32(ascii: "@") && (i + 1) < strLen {
            if CharBuf(str)[i + 1] == Int32(ascii: "@") && (i + 2) < strLen {
                if CharBuf(str)[i + 2] == Int32(ascii: "@") && (i + 3) < strLen {
                    //@@@ should mean to insert a StringEd reference here, so insert it into buf at the current place
                    var stringRef = CharBuf(1024)
                    var r: Int32 = 0

                    while i < strLen && CharBuf(str)[i] == Int32(ascii: "@") {
                        i += 1
                    }

                    while i < strLen && CharBuf(str)[i] != 0 && CharBuf(str)[i] != Int32(ascii: " ") && CharBuf(str)[i] != Int32(ascii: ":") && CharBuf(str)[i] != Int32(ascii: ".") && CharBuf(str)[i] != Int32(ascii: "\n") {
                        stringRef[r] = CharBuf(str)[i]
                        r += 1
                        i += 1
                    }
                    stringRef[r] = 0

                    buf[bufIndex + b] = 0
                    Q_strcat(&buf, MAX_STRINGED_SV_STRING, CG_GetStringEdString("MP_SVGAME", String(stringRef)), at: bufIndex)
                    b = strlen(buf)
                }
            }
        }

        if !gotStrip {
            buf[bufIndex + b] = CharBuf(str)[i]
            b += 1
        }
        i += 1
    }

    buf[bufIndex + b] = 0
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:1128
private func CG_BodyQueueCopy(_ cent: Centity, _ clientNum: Int32, _ knownWeapon: Int32) {
    var source: Centity?
    var anim: Animation?
    let animSpeed: Float
    let flags: Int32 = BONE_ANIM_OVERRIDE_FREEZE
    var ci: ClientInfo?

    if cent.ghoul2 != nil {
        trap_G2API_CleanGhoul2Models(&cent.ghoul2)
    }

    if clientNum < 0 || clientNum >= MAX_CLIENTS {
        return
    }

    source = cg_entities[clientNum]
    ci = cgs.clientinfo[clientNum]

    if source == nil {
        return
    }

    if source!.ghoul2 == nil {
        return
    }

    cent.isRagging = false //reset in case it's still set from another body that was in this cent slot.
    cent.ownerRagging = source!.isRagging //if the owner was in ragdoll state, then we want to go into it too right away.


    cent.bodyFadeTime = 0
    cent.bodyHeight = 0

    cent.dustTrailTime = source!.dustTrailTime

    trap_G2API_DuplicateGhoul2Instance(source!.ghoul2, &cent.ghoul2)

    if source!.isRagging {
        //just reset it now.
        source!.isRagging = false
        trap_G2API_SetRagDoll(source!.ghoul2, nil) //calling with null parms resets to no ragdoll.
    }

    //either force the weapon from when we died or remove it if it was a dropped weapon
    if knownWeapon > WP_BRYAR_PISTOL && trap_G2API_HasGhoul2ModelOnIndex((cent.ghoul2), 1) {
        trap_G2API_RemoveGhoul2Model(&(cent.ghoul2), 1)
    } else if trap_G2API_HasGhoul2ModelOnIndex((cent.ghoul2), 1) {
        trap_G2API_CopySpecificGhoul2Model(CG_G2WeaponInstance(cent, knownWeapon), 0, cent.ghoul2, 1)
    }

    if !cent.ownerRagging {
        var aNum: Int32
        let eFrame: Int32
        var fallBack: Bool = false

        //anim = &bgAllAnims[cent->localAnimIndex].anims[ cent->currentState.torsoAnim ];
        if !BG_InDeathAnim(source!.currentState.torsoAnim) {
            //then just snap the corpse into a default
            anim = bgAllAnims[source!.localAnimIndex].animsSlots[BOTH_DEAD1]
            fallBack = true
        } else {
            anim = bgAllAnims[source!.localAnimIndex].animsSlots[source!.currentState.torsoAnim]
        }
        animSpeed = 50.0 / anim!.frameLerp

        if !fallBack {
            //this will just set us to the last frame of the animation, in theory
            aNum = cgs.clientinfo[source!.currentState.number].frame + 1

            while aNum >= anim!.firstFrame + anim!.numFrames {
                aNum -= 1
            }

            if aNum < anim!.firstFrame - 1 {
                //wrong animation...?
                aNum = (anim!.firstFrame + anim!.numFrames) - 1
            }
        } else {
            aNum = anim!.firstFrame
        }

        eFrame = anim!.firstFrame + anim!.numFrames

        //if (!cgs.clientinfo[source->currentState.number].frame || (cent->currentState.torsoAnim) != (source->currentState.torsoAnim) )
        //{
        //	aNum = (anim->firstFrame+anim->numFrames)-1;
        //}

        trap_G2API_SetBoneAnim(cent.ghoul2, 0, "upper_lumbar", aNum, eFrame, flags, animSpeed, cg.time, -1, 150)
        trap_G2API_SetBoneAnim(cent.ghoul2, 0, "model_root", aNum, eFrame, flags, animSpeed, cg.time, -1, 150)
        trap_G2API_SetBoneAnim(cent.ghoul2, 0, "Motion", aNum, eFrame, flags, animSpeed, cg.time, -1, 150)
    }

    //After we create the bodyqueue, regenerate any limbs on the real instance
    if source!.torsoBolt != 0 {
        CG_ReattachLimb(source!)
    }
}

/// Source: oracle/codemp/cgame/cg_servercmds.c:1257
private func CG_ServerCommand() {
    let cmd: String
    var text = CharBuf(150)
    var IRCG: Bool = false

    cmd = CG_Argv(0)

    if cmd.isEmpty {
        // server claimed the command
        return
    }

    // never seems to get used -Ste







    if strcmp(cmd, "sxd") == 0 {
        //siege extended data, contains extra info certain classes may want to know about other clients
        CG_ParseSiegeExtendedData()
        return
    }

    if strcmp(cmd, "sb") == 0 {
        //siege briefing display
        CG_SiegeBriefingDisplay(atoi(CG_Argv(1)), 0)
        return
    }

    if strcmp(cmd, "scl") == 0 {
        //if (!( trap_Key_GetCatcher() & KEYCATCH_UI ))
        //Well, I want it to come up even if the briefing display is up.
        do {
            trap_OpenUIMenu(UIMENU_CLASSSEL) //UIMENU_CLASSSEL
        }
        return
    }

    if strcmp(cmd, "spc") == 0 {
        trap_Cvar_Set("ui_myteam", "3")
        trap_OpenUIMenu(UIMENU_PLAYERCONFIG) //UIMENU_CLASSSEL
        return
    }

    if strcmp(cmd, "nfr") == 0 {
        //"nfr" == "new force rank" (want a short string)
        var doMenu: Int32 = 0
        var setTeam: Int32 = 0
        var newRank: Int32 = 0

        if trap_Argc() < 3 {
            return
        }

        newRank = atoi(CG_Argv(1))
        doMenu = atoi(CG_Argv(2))
        setTeam = atoi(CG_Argv(3))

        trap_Cvar_Set("ui_rankChange", va("%i", newRank))

        trap_Cvar_Set("ui_myteam", va("%i", setTeam))

        if !((trap_Key_GetCatcher() & KEYCATCH_UI) != 0) && doMenu != 0 {
            trap_OpenUIMenu(UIMENU_PLAYERCONFIG)
        }

        return
    }

    if strcmp(cmd, "kg2") == 0 {
        //Kill a ghoul2 instance in this slot.
        //If it has been occupied since this message was sent somehow, the worst that can (should) happen
        //is the instance will have to reinit with its current info.
        var indexNum: Int32 = 0
        let argNum: Int32 = trap_Argc()
        var i: Int32 = 1

        if argNum < 1 {
            return
        }

        while i < argNum {
            indexNum = atoi(CG_Argv(i))

            if cg_entities[indexNum].ghoul2 != nil && trap_G2_HaveWeGhoul2Models(cg_entities[indexNum].ghoul2) {
                if indexNum < MAX_CLIENTS {
                    //You try to do very bad thing!
                    return
                }

                CG_KillCEntityG2(indexNum)
            }

            i += 1
        }

        return
    }

    if strcmp(cmd, "kls") == 0 {
        //kill looping sounds
        var indexNum: Int32 = 0
        let argNum: Int32 = trap_Argc()
        var clent: Centity? = nil
        var trackerent: Centity? = nil

        if argNum < 1 {
            return
        }

        indexNum = atoi(CG_Argv(1))

        if indexNum != -1 {
            clent = cg_entities[indexNum]
        }

        if argNum >= 2 {
            indexNum = atoi(CG_Argv(2))

            if indexNum != -1 {
                trackerent = cg_entities[indexNum]
            }
        }

        if clent != nil {
            CG_S_StopLoopingSound(clent!.currentState.number, -1)
        }
        if trackerent != nil {
            CG_S_StopLoopingSound(trackerent!.currentState.number, -1)
        }

        return
    }

    if strcmp(cmd, "ircg") == 0 {
        //this means param 2 is the body index and we want to copy to bodyqueue on it
        IRCG = true
    }

    if strcmp(cmd, "rcg") == 0 || IRCG {
        //rcg - Restore Client Ghoul (make sure limbs are reattached and ragdoll state is reset - this must be done reliably)
        var indexNum: Int32 = 0
        let argNum: Int32 = trap_Argc()
        var clent: Centity?

        if argNum < 1 {
            return
        }

        indexNum = atoi(CG_Argv(1))
        if indexNum < 0 || indexNum >= MAX_CLIENTS {
            return
        }

        clent = cg_entities[indexNum]

        //assert(clent->ghoul2);
        if clent!.ghoul2 == nil {
            //this can happen while connecting as a client
            return
        }


        if IRCG {
            var bodyIndex: Int32 = 0
            var weaponIndex: Int32 = 0
            var side: Int32 = 0
            var body: Centity?

            bodyIndex = atoi(CG_Argv(2))
            weaponIndex = atoi(CG_Argv(3))
            side = atoi(CG_Argv(4))

            body = cg_entities[bodyIndex]

            if side != 0 {
                body!.teamPowerType = true //light side
            } else {
                body!.teamPowerType = false //dark side
            }

            CG_BodyQueueCopy(body!, clent!.currentState.number, weaponIndex)
        }

        //reattach any missing limbs
        if clent!.torsoBolt != 0 {
            CG_ReattachLimb(clent!)
        }

        //make sure ragdoll state is reset
        if clent!.isRagging {
            clent!.isRagging = false
            trap_G2API_SetRagDoll(clent!.ghoul2, nil) //calling with null parms resets to no ragdoll.
        }

        //clear all the decals as well
        trap_G2API_ClearSkinGore(clent!.ghoul2)

        clent!.weapon = 0
        clent!.ghoul2weapon = nil //force a weapon reinit

        return
    }

    if strcmp(cmd, "cp") == 0 {
        var strEd = CharBuf(1024)
        CG_CheckSVStringEdRef(&strEd, CG_Argv(1))
        CG_CenterPrint(String(strEd), Int32(Double(SCREEN_HEIGHT) * 0.30), BIGCHAR_WIDTH)
        return
    }

    if strcmp(cmd, "cps") == 0 {
        var strEd = CharBuf(1024)
        var x = TextCursor(CharBuf(CG_Argv(1)))
        if x[0] == Int32(ascii: "@") {
            x.advance()
        }
        strcpy(&strEd, trap_SP_GetStringTextString(x.text, MAX_STRINGED_SV_STRING).1)
        CG_CenterPrint(String(strEd), Int32(Double(SCREEN_HEIGHT) * 0.20), BIGCHAR_WIDTH)
        return
    }

    if strcmp(cmd, "cs") == 0 {
        CG_ConfigStringModified()
        return
    }

    if strcmp(cmd, "print") == 0 {
        var strEd = CharBuf(1024)
        CG_CheckSVStringEdRef(&strEd, CG_Argv(1))
        CG_Printf("%s", strEd)
        return
    }

    if strcmp(cmd, "chat") == 0 {
        if cg_teamChatsOnly.integer == 0 {
            trap_S_StartLocalSound(cgs.media.talkSound, CHAN_LOCAL_SOUND)
            Q_strncpyz(&text, CG_Argv(1), MAX_SAY_TEXT)
            CG_RemoveChatEscapeChar(&text)
            CG_ChatBox_AddString(&text)
            CG_Printf("*%s\n", text)
        }
        return
    }

    if strcmp(cmd, "tchat") == 0 {
        trap_S_StartLocalSound(cgs.media.talkSound, CHAN_LOCAL_SOUND)
        Q_strncpyz(&text, CG_Argv(1), MAX_SAY_TEXT)
        CG_RemoveChatEscapeChar(&text)
        CG_ChatBox_AddString(&text)
        CG_Printf("*%s\n", text)

        return
    }

    //chat with location, possibly localized.
    if strcmp(cmd, "lchat") == 0 {
        if cg_teamChatsOnly.integer == 0 {
            var name = CharBuf(1024)
            var loc = CharBuf(1024)
            var color = CharBuf(8)
            var message = CharBuf(1024)

            if trap_Argc() < 4 {
                return
            }

            strcpy(&name, CG_Argv(1))
            strcpy(&loc, CG_Argv(2))
            strcpy(&color, CG_Argv(3))
            strcpy(&message, CG_Argv(4))

            if loc[0] == Int32(ascii: "@") {
                //get localized text
                strcpy(&loc, trap_SP_GetStringTextString(String(loc[1...]), MAX_STRING_CHARS).1)
            }

            trap_S_StartLocalSound(cgs.media.talkSound, CHAN_LOCAL_SOUND)
            //Q_strncpyz( text, CG_Argv(1), MAX_SAY_TEXT );
            Com_sprintf(&text, MAX_SAY_TEXT, "%s<%s>^%s%s", name, loc, color, message)
            CG_RemoveChatEscapeChar(&text)
            CG_ChatBox_AddString(&text)
            CG_Printf("*%s\n", text)
        }
        return
    }
    if strcmp(cmd, "ltchat") == 0 {
        var name = CharBuf(1024)
        var loc = CharBuf(1024)
        var color = CharBuf(8)
        var message = CharBuf(1024)

        if trap_Argc() < 4 {
            return
        }

        strcpy(&name, CG_Argv(1))
        strcpy(&loc, CG_Argv(2))
        strcpy(&color, CG_Argv(3))
        strcpy(&message, CG_Argv(4))

        if loc[0] == Int32(ascii: "@") {
            //get localized text
            strcpy(&loc, trap_SP_GetStringTextString(String(loc[1...]), MAX_STRING_CHARS).1)
        }

        trap_S_StartLocalSound(cgs.media.talkSound, CHAN_LOCAL_SOUND)
        //Q_strncpyz( text, CG_Argv(1), MAX_SAY_TEXT );
        Com_sprintf(&text, MAX_SAY_TEXT, "%s<%s> ^%s%s", name, loc, color, message)
        CG_RemoveChatEscapeChar(&text)
        CG_ChatBox_AddString(&text)
        CG_Printf("*%s\n", text)

        return
    }

    if strcmp(cmd, "scores") == 0 {
        CG_ParseScores()
        return
    }

    if strcmp(cmd, "tinfo") == 0 {
        CG_ParseTeamInfo()
        return
    }

    if strcmp(cmd, "map_restart") == 0 {
        CG_MapRestart()
        return
    }

    if Q_stricmp(cmd, "remapShader") == 0 {
        if trap_Argc() == 4 {
            trap_R_RemapShader(CG_Argv(1), CG_Argv(2), CG_Argv(3))
        }
    }

    // loaddeferred can be both a servercmd and a consolecmd
    if strcmp(cmd, "loaddefered") == 0 {
        // FIXME: spelled wrong, but not changing for demo
        CG_LoadDeferredPlayers()
        return
    }

    // clientLevelShot is sent before taking a special screenshot for
    // the menu system during development
    if strcmp(cmd, "clientLevelShot") == 0 {
        cg.levelShot = true
        return
    }

    CG_Printf("Unknown client game command: %s\n", cmd)
}

/**
```
====================
CG_ExecuteNewServerCommands

Execute all of the server commands that were received along
with this this snapshot.
====================
```
*/
/// Source: oracle/codemp/cgame/cg_servercmds.c:1681
func CG_ExecuteNewServerCommands(_ latestSequence: Int32) {
    while cgs.serverCommandSequence < latestSequence {
        cgs.serverCommandSequence += 1
        if trap_GetServerCommand(cgs.serverCommandSequence) {
            CG_ServerCommand()
        }
    }
}
