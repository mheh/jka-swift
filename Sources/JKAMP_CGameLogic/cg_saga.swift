import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_saga.c:15
public var cgSiegeRoundState: Int32 {
    get { world.variables.cgSiegeRoundState }
    set { world.variables.cgSiegeRoundState = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:16
public var cgSiegeRoundTime: Int32 {
    get { world.variables.cgSiegeRoundTime }
    set { world.variables.cgSiegeRoundTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:18
var team1: JKAShared.CharBuf {
    get { world.variables.team1 }
    set { world.variables.team1 = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:19
var team2: JKAShared.CharBuf {
    get { world.variables.team2 }
    set { world.variables.team2 = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:21
public var team1Timed: Int32 {
    get { world.variables.team1Timed }
    set { world.variables.team1Timed = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:22
public var team2Timed: Int32 {
    get { world.variables.team2Timed }
    set { world.variables.team2Timed = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:24
public var cgSiegeTeam1PlShader: Int32 {
    get { world.variables.cgSiegeTeam1PlShader }
    set { world.variables.cgSiegeTeam1PlShader = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:25
public var cgSiegeTeam2PlShader: Int32 {
    get { world.variables.cgSiegeTeam2PlShader }
    set { world.variables.cgSiegeTeam2PlShader = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:27
var cgParseObjectives: JKAShared.CharBuf {
    get { world.variables.cgParseObjectives }
    set { world.variables.cgParseObjectives = newValue }
}

/// Source: oracle/codemp/cgame/cg_saga.c:984
public var cg_siegeExtendedData: Slots<SiegeExtended> { world.storage.cg_siegeExtendedData }

/// Source: oracle/codemp/cgame/cg_saga.c:35
public func CG_PrecacheSiegeObjectiveAssetsForTeam(_ myTeam: Int32) {
    var teamstr = CharBuf(64)
    var objstr = CharBuf(256)
    var foundobjective = CharBuf(16384)

    if siege_valid == 0 {
        CG_Error("Siege data does not exist on client!\n")
        return
    }

    if myTeam == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &cgParseObjectives) != 0 {
        var i: Int32 = 1
        while i < 32 {
            //eh, just try 32 I guess
            Com_sprintf(&objstr, Int32((objstr).count), "Objective%i", i)

            if BG_SiegeGetValueGroup(String(cgParseObjectives), String(objstr), &foundobjective) != 0 {
                var str = CharBuf(64)

                if BG_SiegeGetPairedValue(String(foundobjective), "sound_team1", &str) != 0 {
                    trap_S_RegisterSound(String(str))
                }
                if BG_SiegeGetPairedValue(String(foundobjective), "sound_team2", &str) != 0 {
                    trap_S_RegisterSound(String(str))
                }
                if BG_SiegeGetPairedValue(String(foundobjective), "objgfx", &str) != 0 {
                    trap_R_RegisterShaderNoMip(String(str))
                }
                if BG_SiegeGetPairedValue(String(foundobjective), "mapicon", &str) != 0 {
                    trap_R_RegisterShaderNoMip(String(str))
                }
                if BG_SiegeGetPairedValue(String(foundobjective), "litmapicon", &str) != 0 {
                    trap_R_RegisterShaderNoMip(String(str))
                }
                if BG_SiegeGetPairedValue(String(foundobjective), "donemapicon", &str) != 0 {
                    trap_R_RegisterShaderNoMip(String(str))
                }
            } else {
                //no more
                break
            }
            i += 1
        }
    }
}

/// Source: oracle/codemp/cgame/cg_saga.c:101
public func CG_PrecachePlayersForSiegeTeam(_ team: Int32) {
    var stm: SiegeTeam?
    var i: Int32 = 0

    stm = BG_SiegeFindThemeForTeam(team)

    if stm == nil {
        //invalid team/no theme for team?
        return
    }

    while i < stm!.numClasses {
        let scl: SiegeClass? = stm!.classes[i]

        if !scl!.forcedModel.isEmpty {
            // Raven's record lives to the end of his block, so the block is the closure.
            ClientInfo.scratch { fake in

                fake.clear()
                strcpy(&fake.modelNameBuffer, scl!.forcedModel)

                trap_R_RegisterModel(va("models/players/%s/model.glm", scl!.forcedModel))
                if !scl!.forcedSkin.isEmpty {
                    trap_R_RegisterSkin(va("models/players/%s/model_%s.skin", scl!.forcedModel, scl!.forcedSkin))
                    strcpy(&fake.skinNameBuffer, scl!.forcedSkin)
                } else {
                    strcpy(&fake.skinNameBuffer, "default")
                }

                //precache the sounds for the model...
                CG_LoadCISounds(fake, true)
            }
        }

        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_saga.c:143
public func CG_InitSiegeMode() {
    var levelname = CharBuf(64)
    var btime = CharBuf(1024)
    var teams = CharBuf(2048)
    var teamInfo = CharBuf(16384)
    var len: Int32 = 0
    var i: Int32 = 0
    var j: Int32 = 0
    var cl: SiegeClass?
    var sTeam: SiegeTeam?
    var f: fileHandle_t = 0
    var teamIcon = CharBuf(128)

    failure: do {
        if cgs.gametype != GT_SIEGE {
            break failure
        }

        Com_sprintf(&levelname, Int32((levelname).count), "%s\0", cgs.mapname)

        i = strlen(levelname) - 1

        while i > 0 && levelname[i] != 0 && levelname[i] != Int32(ascii: ".") {
            i -= 1
        }

        if i == 0 {
            break failure
        }

        levelname[i] = 0 //kill the ".bsp"

        Com_sprintf(&levelname, Int32((levelname).count), "%s.siege\0", levelname)

        if levelname[0] == 0 {
            break failure
        }

        len = trap_FS_FOpenFile(String(levelname), &f, FS_READ)

        if f == 0 || len >= MAX_SIEGE_INFO_SIZE {
            break failure
        }

        trap_FS_Read(&siege_info, len, f)

        trap_FS_FCloseFile(f)

        siege_valid = 1

        if BG_SiegeGetValueGroup(String(siege_info), "Teams", &teams) != 0 {
            var buf = CharBuf(1024)

            strcpy(&buf, trap_Cvar_VariableStringBuffer("cg_siegeTeam1", 1024))
            if buf[0] != 0 && Q_stricmp(buf, "none") != 0 {
                strcpy(&team1, buf)
            } else {
                BG_SiegeGetPairedValue(String(teams), "team1", &team1)
            }

            if team1[0] == Int32(ascii: "@") {
                //it's a damn stringed reference.
                var b = CharBuf(256)
                strcpy(&b, trap_SP_GetStringTextString(String(team1[1...]), 256).1)
                trap_Cvar_Set("cg_siegeTeam1Name", String(b))
            } else {
                trap_Cvar_Set("cg_siegeTeam1Name", String(team1))
            }

            strcpy(&buf, trap_Cvar_VariableStringBuffer("cg_siegeTeam2", 1024))
            if buf[0] != 0 && Q_stricmp(buf, "none") != 0 {
                strcpy(&team2, buf)
            } else {
                BG_SiegeGetPairedValue(String(teams), "team2", &team2)
            }

            if team2[0] == Int32(ascii: "@") {
                //it's a damn stringed reference.
                var b = CharBuf(256)
                strcpy(&b, trap_SP_GetStringTextString(String(team2[1...]), 256).1)
                trap_Cvar_Set("cg_siegeTeam2Name", String(b))
            } else {
                trap_Cvar_Set("cg_siegeTeam2Name", String(team2))
            }
        } else {
            CG_Error("Siege teams not defined")
        }

        if BG_SiegeGetValueGroup(String(siege_info), String(team1), &teamInfo) != 0 {
            if BG_SiegeGetPairedValue(String(teamInfo), "TeamIcon", &teamIcon) != 0 {
                trap_Cvar_Set("team1_icon", String(teamIcon))
            }

            if BG_SiegeGetPairedValue(String(teamInfo), "Timed", &btime) != 0 {
                team1Timed = atoi(btime) * 1000
                CG_SetSiegeTimerCvar(team1Timed)
            } else {
                team1Timed = 0
            }
        } else {
            CG_Error("No team entry for '%s'\n", team1)
        }

        if BG_SiegeGetPairedValue(String(siege_info), "mapgraphic", &teamInfo) != 0 {
            trap_Cvar_Set("siege_mapgraphic", String(teamInfo))
        } else {
            trap_Cvar_Set("siege_mapgraphic", "gfx/mplevels/siege1_hoth")
        }

        if BG_SiegeGetPairedValue(String(siege_info), "missionname", &teamInfo) != 0 {
            trap_Cvar_Set("siege_missionname", String(teamInfo))
        } else {
            trap_Cvar_Set("siege_missionname", " ")
        }

        if BG_SiegeGetValueGroup(String(siege_info), String(team2), &teamInfo) != 0 {
            if BG_SiegeGetPairedValue(String(teamInfo), "TeamIcon", &teamIcon) != 0 {
                trap_Cvar_Set("team2_icon", String(teamIcon))
            }

            if BG_SiegeGetPairedValue(String(teamInfo), "Timed", &btime) != 0 {
                team2Timed = atoi(btime) * 1000
                CG_SetSiegeTimerCvar(team2Timed)
            } else {
                team2Timed = 0
            }
        } else {
            CG_Error("No team entry for '%s'\n", team2)
        }

        //Load the player class types
        BG_SiegeLoadClasses(nil)

        if bgNumSiegeClasses == 0 {
            //We didn't find any?!
            CG_Error("Couldn't find any player classes for Siege")
        }

        //Now load the teams since we have class data.
        BG_SiegeLoadTeams()

        if bgNumSiegeTeams == 0 {
            //React same as with classes.
            CG_Error("Couldn't find any player teams for Siege")
        }

        //Get and set the team themes for each team. This will control which classes can be
        //used on each team.
        if BG_SiegeGetValueGroup(String(siege_info), String(team1), &teamInfo) != 0 {
            if BG_SiegeGetPairedValue(String(teamInfo), "UseTeam", &btime) != 0 {
                BG_SiegeSetTeamTheme(SIEGETEAM_TEAM1, String(btime))
            }
            if BG_SiegeGetPairedValue(String(teamInfo), "FriendlyShader", &btime) != 0 {
                cgSiegeTeam1PlShader = trap_R_RegisterShaderNoMip(String(btime))
            } else {
                cgSiegeTeam1PlShader = 0
            }
        }
        if BG_SiegeGetValueGroup(String(siege_info), String(team2), &teamInfo) != 0 {
            if BG_SiegeGetPairedValue(String(teamInfo), "UseTeam", &btime) != 0 {
                BG_SiegeSetTeamTheme(SIEGETEAM_TEAM2, String(btime))
            }
            if BG_SiegeGetPairedValue(String(teamInfo), "FriendlyShader", &btime) != 0 {
                cgSiegeTeam2PlShader = trap_R_RegisterShaderNoMip(String(btime))
            } else {
                cgSiegeTeam2PlShader = 0
            }
        }

        //Now go through the classes used by the loaded teams and try to precache
        //any forced models or forced skins.
        i = SIEGETEAM_TEAM1

        while i <= SIEGETEAM_TEAM2 {
            j = 0
            sTeam = BG_SiegeFindThemeForTeam(i)

            if sTeam == nil {
                i += 1
                continue
            }

            //Get custom team shaders while we're at it.
            if i == SIEGETEAM_TEAM1 {
                cgSiegeTeam1PlShader = sTeam!.friendlyShader
            } else if i == SIEGETEAM_TEAM2 {
                cgSiegeTeam2PlShader = sTeam!.friendlyShader
            }

            while j < sTeam!.numClasses {
                cl = sTeam!.classes[j]

                if !cl!.forcedModel.isEmpty {
                    //This class has a forced model, so precache it.
                    trap_R_RegisterModel(va("models/players/%s/model.glm", cl!.forcedModel))

                    if !cl!.forcedSkin.isEmpty {
                        //also has a forced skin, precache it.
                        var useSkinName: String

                        if strchr(cl!.forcedSkin, Int32(ascii: "|")) != nil {
                            //three part skin
                            useSkinName = va("models/players/%s/|%s", cl!.forcedModel, cl!.forcedSkin)
                        } else {
                            useSkinName = va("models/players/%s/model_%s.skin", cl!.forcedModel, cl!.forcedSkin)
                        }

                        trap_R_RegisterSkin(useSkinName)
                    }
                }

                j += 1
            }
            i += 1
        }

        //precache saber data for classes that use sabers on both teams
        BG_PrecacheSabersForSiegeTeam(SIEGETEAM_TEAM1)
        BG_PrecacheSabersForSiegeTeam(SIEGETEAM_TEAM2)

        CG_PrecachePlayersForSiegeTeam(SIEGETEAM_TEAM1)
        CG_PrecachePlayersForSiegeTeam(SIEGETEAM_TEAM2)

        CG_PrecachePlayersForSiegeTeam(SIEGETEAM_TEAM1)
        CG_PrecachePlayersForSiegeTeam(SIEGETEAM_TEAM2)

        CG_PrecacheSiegeObjectiveAssetsForTeam(SIEGETEAM_TEAM1)
        CG_PrecacheSiegeObjectiveAssetsForTeam(SIEGETEAM_TEAM2)

        return
    }
    siege_valid = 0
}

/// Source: oracle/codemp/cgame/cg_saga.c:433
private func CG_SiegeObjectiveBuffer(_ team: Int32, _ objective: Int32) -> String? {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var buf = CharBuf(8192)
    var teamstr = CharBuf(1024)

    if team == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &cgParseObjectives) != 0 {
        //found the team group
        if BG_SiegeGetValueGroup(String(cgParseObjectives), va("Objective%i", objective), &buf) != 0 {
            //found the objective group
            return String(buf)
        }
    }

    return nil
}

/// Source: oracle/codemp/cgame/cg_saga.c:458
public func CG_ParseSiegeObjectiveStatus(_ str: String) {
    var i: Int32 = 0
    var team: Int32 = SIEGETEAM_TEAM1
    var cvarName: String
    var s: String? = nil
    var objectiveNum: Int32 = 0

    if str.isEmpty {
        return
    }

    while CharBuf(str)[i] != 0 {
        if CharBuf(str)[i] == Int32(ascii: "|") {
            //switch over to team2, this is the next section
            team = SIEGETEAM_TEAM2
            objectiveNum = 0
        } else if CharBuf(str)[i] == Int32(ascii: "-") {
            objectiveNum += 1
            i += 1

            cvarName = va("team%i_objective%i", team, objectiveNum)
            if CharBuf(str)[i] == Int32(ascii: "1") {
                //it's completed
                trap_Cvar_Set(cvarName, "1")
            } else {
                //otherwise assume it is not
                trap_Cvar_Set(cvarName, "0")
            }

            s = CG_SiegeObjectiveBuffer(team, objectiveNum)
            if s != nil && !s!.isEmpty {
                //now set the description and graphic cvars to by read by the menu
                var buffer = CharBuf(8192)

                cvarName = va("team%i_objective%i_longdesc", team, objectiveNum)
                if BG_SiegeGetPairedValue(s!, "objdesc", &buffer) != 0 {
                    trap_Cvar_Set(cvarName, String(buffer))
                } else {
                    trap_Cvar_Set(cvarName, "UNSPECIFIED")
                }

                cvarName = va("team%i_objective%i_gfx", team, objectiveNum)
                if BG_SiegeGetPairedValue(s!, "objgfx", &buffer) != 0 {
                    trap_Cvar_Set(cvarName, String(buffer))
                } else {
                    trap_Cvar_Set(cvarName, "UNSPECIFIED")
                }

                cvarName = va("team%i_objective%i_mapicon", team, objectiveNum)
                if BG_SiegeGetPairedValue(s!, "mapicon", &buffer) != 0 {
                    trap_Cvar_Set(cvarName, String(buffer))
                } else {
                    trap_Cvar_Set(cvarName, "UNSPECIFIED")
                }

                cvarName = va("team%i_objective%i_litmapicon", team, objectiveNum)
                if BG_SiegeGetPairedValue(s!, "litmapicon", &buffer) != 0 {
                    trap_Cvar_Set(cvarName, String(buffer))
                } else {
                    trap_Cvar_Set(cvarName, "UNSPECIFIED")
                }

                cvarName = va("team%i_objective%i_donemapicon", team, objectiveNum)
                if BG_SiegeGetPairedValue(s!, "donemapicon", &buffer) != 0 {
                    trap_Cvar_Set(cvarName, String(buffer))
                } else {
                    trap_Cvar_Set(cvarName, "UNSPECIFIED")
                }

                cvarName = va("team%i_objective%i_mappos", team, objectiveNum)
                if BG_SiegeGetPairedValue(s!, "mappos", &buffer) != 0 {
                    trap_Cvar_Set(cvarName, String(buffer))
                } else {
                    trap_Cvar_Set(cvarName, "0 0 32 32")
                }
            }
        }
        i += 1
    }

    if cg.predictedPlayerState.persistant[PERS_TEAM] != TEAM_SPECTATOR {
        //update menu cvars
        CG_SiegeBriefingDisplay(cg.predictedPlayerState.persistant[PERS_TEAM], 1)
    }
}

/// Source: oracle/codemp/cgame/cg_saga.c:568
public func CG_SiegeRoundOver(_ ent: Centity, _ won: Int32) {
    let myTeam: Int32
    var teamstr = CharBuf(64)
    var appstring = CharBuf(1024)
    var soundstr = CharBuf(1024)
    var success: Int32 = 0
    var ps: PlayerState? = nil

    if siege_valid == 0 {
        CG_Error("ERROR: Siege data does not exist on client!\n")
        return
    }

    if cg.snap != nil {
        //this should always be true, if it isn't though use the predicted ps as a fallback
        ps = cg.snap!.ps
    } else {
        ps = cg.predictedPlayerState
    }

    if ps == nil {
        return
    }

    myTeam = ps!.persistant[PERS_TEAM]

    if myTeam == TEAM_SPECTATOR {
        return
    }

    if myTeam == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &cgParseObjectives) != 0 {
        if won == myTeam {
            success = BG_SiegeGetPairedValue(String(cgParseObjectives), "wonround", &appstring)
        } else {
            success = BG_SiegeGetPairedValue(String(cgParseObjectives), "lostround", &appstring)
        }

        if success != 0 {
            CG_DrawSiegeMessage(String(appstring), 0)
        }

        appstring[0] = 0
        soundstr[0] = 0

        if myTeam == won {
            Com_sprintf(&teamstr, Int32((teamstr).count), "roundover_sound_wewon")
        } else {
            Com_sprintf(&teamstr, Int32((teamstr).count), "roundover_sound_welost")
        }

        if BG_SiegeGetPairedValue(String(cgParseObjectives), String(teamstr), &appstring) != 0 {
            Com_sprintf(&soundstr, Int32((soundstr).count), String(appstring))
        }
        /*
        else
        {
        if (myTeam != won)
        {
        Com_sprintf(soundstr, sizeof(soundstr), DEFAULT_LOSE_ROUND);
        }
        else
        {
        Com_sprintf(soundstr, sizeof(soundstr), DEFAULT_WIN_ROUND);
        }
        }
        */

        if soundstr[0] != 0 {
            trap_S_StartLocalSound(trap_S_RegisterSound(String(soundstr)), CHAN_ANNOUNCER)
        }
    }
}

/// Source: oracle/codemp/cgame/cg_saga.c:667
public func CG_SiegeGetObjectiveDescription(_ team: Int32, _ objective: Int32, _ buffer: inout JKAShared.CharBuf) {
    var teamstr = CharBuf(1024)
    var objectiveStr = CharBuf(8192)
    var bufferIndex: Int32 = 0

    buffer[bufferIndex + 0] = 0 //set to 0 ahead of time in case we fail to find the objective group/name

    if team == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &cgParseObjectives) != 0 {
        //found the team group
        if BG_SiegeGetValueGroup(String(cgParseObjectives), va("Objective%i", objective), &objectiveStr) != 0 {
            //found the objective group
            //Parse the name right into the buffer.
            BG_SiegeGetPairedValue(String(objectiveStr), "goalname", &buffer)
        }
    }
}

/// Source: oracle/codemp/cgame/cg_saga.c:693
public func CG_SiegeGetObjectiveFinal(_ team: Int32, _ objective: Int32) -> Int32 {
    var finalStr = CharBuf(64)
    var teamstr = CharBuf(1024)
    var objectiveStr = CharBuf(8192)

    if team == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &cgParseObjectives) != 0 {
        //found the team group
        if BG_SiegeGetValueGroup(String(cgParseObjectives), va("Objective%i", objective), &objectiveStr) != 0 {
            //found the objective group
            //Parse the name right into the buffer.
            BG_SiegeGetPairedValue(String(objectiveStr), "final", &finalStr)
            return (atoi(finalStr))
        }
    }
    return 0
}

/// Source: oracle/codemp/cgame/cg_saga.c:720
public func CG_SiegeBriefingDisplay(_ team: Int32, _ dontshow: Int32) {
    var teamstr = CharBuf(64)
    var briefing = CharBuf(8192)
    var properValue = CharBuf(1024)
    var objectiveDesc = CharBuf(1024)
    var i: Int32 = 1
    var useTeam: Int32 = team
    var primary: Bool = false

    if siege_valid == 0 {
        return
    }

    if team == TEAM_SPECTATOR {
        return
    }

    if team == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if useTeam != SIEGETEAM_TEAM1 && useTeam != SIEGETEAM_TEAM2 {
        //This shouldn't be happening. But just fall back to team 2 anyway.
        useTeam = SIEGETEAM_TEAM2
    }

    trap_Cvar_Set(va("siege_primobj_inuse"), "0")

    while i < 16 {
        //do up to 16 objectives I suppose
        //Get the value for this objective on this team
        //Now set the cvar for the menu to display.

        //primary = (CG_SiegeGetObjectiveFinal(useTeam, i)>-1)?qtrue:qfalse;
        primary = (CG_SiegeGetObjectiveFinal(useTeam, i) > 0) ? true : false

        properValue[0] = 0
        strcpy(&properValue, trap_Cvar_VariableStringBuffer(va("team%i_objective%i", useTeam, i), 1024))
        if primary {
            trap_Cvar_Set(va("siege_primobj"), String(properValue))
        } else {
            trap_Cvar_Set(va("siege_objective%i", i), String(properValue))
        }

        //Now set the long desc cvar for the menu to display.
        properValue[0] = 0
        strcpy(&properValue, trap_Cvar_VariableStringBuffer(va("team%i_objective%i_longdesc", useTeam, i), 1024))
        if primary {
            trap_Cvar_Set(va("siege_primobj_longdesc"), String(properValue))
        } else {
            trap_Cvar_Set(va("siege_objective%i_longdesc", i), String(properValue))
        }

        //Now set the gfx cvar for the menu to display.
        properValue[0] = 0
        strcpy(&properValue, trap_Cvar_VariableStringBuffer(va("team%i_objective%i_gfx", useTeam, i), 1024))
        if primary {
            trap_Cvar_Set(va("siege_primobj_gfx"), String(properValue))
        } else {
            trap_Cvar_Set(va("siege_objective%i_gfx", i), String(properValue))
        }

        //Now set the mapicon cvar for the menu to display.
        properValue[0] = 0
        strcpy(&properValue, trap_Cvar_VariableStringBuffer(va("team%i_objective%i_mapicon", useTeam, i), 1024))
        if primary {
            trap_Cvar_Set(va("siege_primobj_mapicon"), String(properValue))
        } else {
            trap_Cvar_Set(va("siege_objective%i_mapicon", i), String(properValue))
        }

        //Now set the mappos cvar for the menu to display.
        properValue[0] = 0
        strcpy(&properValue, trap_Cvar_VariableStringBuffer(va("team%i_objective%i_mappos", useTeam, i), 1024))
        if primary {
            trap_Cvar_Set(va("siege_primobj_mappos"), String(properValue))
        } else {
            trap_Cvar_Set(va("siege_objective%i_mappos", i), String(properValue))
        }

        //Now set the description cvar for the objective
        CG_SiegeGetObjectiveDescription(useTeam, i, &objectiveDesc)

        if objectiveDesc[0] != 0 {
            //found a valid objective description
            if primary {
                trap_Cvar_Set(va("siege_primobj_desc"), String(objectiveDesc))
                //this one is marked not in use because it gets primobj
                trap_Cvar_Set(va("siege_objective%i_inuse", i), "0")
                trap_Cvar_Set(va("siege_primobj_inuse"), "1")

                trap_Cvar_Set(va("team%i_objective%i_inuse", useTeam, i), "1")
            } else {
                trap_Cvar_Set(va("siege_objective%i_desc", i), String(objectiveDesc))
                trap_Cvar_Set(va("siege_objective%i_inuse", i), "2")
                trap_Cvar_Set(va("team%i_objective%i_inuse", useTeam, i), "2")
            }
        } else {
            //didn't find one, so set the "inuse" cvar to 0 for the objective and mark it non-complete.
            trap_Cvar_Set(va("siege_objective%i_inuse", i), "0")
            trap_Cvar_Set(va("siege_objective%i", i), "0")
            trap_Cvar_Set(va("team%i_objective%i_inuse", useTeam, i), "0")
            trap_Cvar_Set(va("team%i_objective%i", useTeam, i), "0")

            trap_Cvar_Set(va("siege_objective%i_mappos", i), "")
            trap_Cvar_Set(va("team%i_objective%i_mappos", useTeam, i), "")
            trap_Cvar_Set(va("siege_objective%i_gfx", i), "")
            trap_Cvar_Set(va("team%i_objective%i_gfx", useTeam, i), "")
            trap_Cvar_Set(va("siege_objective%i_mapicon", i), "")
            trap_Cvar_Set(va("team%i_objective%i_mapicon", useTeam, i), "")
        }

        i += 1
    }

    if dontshow != 0 {
        return
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &cgParseObjectives) != 0 {
        if BG_SiegeGetPairedValue(String(cgParseObjectives), "briefing", &briefing) != 0 {
            CG_DrawSiegeMessage(String(briefing), 1)
        }
    }
}

/// Source: oracle/codemp/cgame/cg_saga.c:878
public func CG_SiegeObjectiveCompleted(_ ent: Centity, _ won: Int32, _ objectivenum: Int32) {
    let myTeam: Int32
    var teamstr = CharBuf(64)
    var objstr = CharBuf(256)
    var foundobjective = CharBuf(16384)
    var appstring = CharBuf(1024)
    var soundstr = CharBuf(1024)
    var success: Int32 = 0
    var ps: PlayerState? = nil

    if siege_valid == 0 {
        CG_Error("Siege data does not exist on client!\n")
        return
    }

    if cg.snap != nil {
        //this should always be true, if it isn't though use the predicted ps as a fallback
        ps = cg.snap!.ps
    } else {
        ps = cg.predictedPlayerState
    }

    if ps == nil {
        return
    }

    myTeam = ps!.persistant[PERS_TEAM]

    if myTeam == TEAM_SPECTATOR {
        return
    }

    if won == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &cgParseObjectives) != 0 {
        Com_sprintf(&objstr, Int32((objstr).count), "Objective%i", objectivenum)

        if BG_SiegeGetValueGroup(String(cgParseObjectives), String(objstr), &foundobjective) != 0 {
            if myTeam == SIEGETEAM_TEAM1 {
                success = BG_SiegeGetPairedValue(String(foundobjective), "message_team1", &appstring)
            } else {
                success = BG_SiegeGetPairedValue(String(foundobjective), "message_team2", &appstring)
            }

            if success != 0 {
                CG_DrawSiegeMessageNonMenu(String(appstring))
            }

            appstring[0] = 0
            soundstr[0] = 0

            if myTeam == SIEGETEAM_TEAM1 {
                Com_sprintf(&teamstr, Int32((teamstr).count), "sound_team1")
            } else {
                Com_sprintf(&teamstr, Int32((teamstr).count), "sound_team2")
            }

            if BG_SiegeGetPairedValue(String(foundobjective), String(teamstr), &appstring) != 0 {
                Com_sprintf(&soundstr, Int32((soundstr).count), String(appstring))
            }
            /*
            else
            {
            if (myTeam != won)
            {
            Com_sprintf(soundstr, sizeof(soundstr), DEFAULT_LOSE_OBJECTIVE);
            }
            else
            {
            Com_sprintf(soundstr, sizeof(soundstr), DEFAULT_WIN_OBJECTIVE);
            }
            }
            */

            if soundstr[0] != 0 {
                trap_S_StartLocalSound(trap_S_RegisterSound(String(soundstr)), CHAN_ANNOUNCER)
            }
        }
    }
}

//parse a single extended siege data entry
/// Source: oracle/codemp/cgame/cg_saga.c:987
public func CG_ParseSiegeExtendedDataEntry(_ conStr: String) {
    var s = CharBuf(1024)
    var str = TextCursor(CharBuf(conStr))
    var argParses: Int32 = 0
    var i: Int32
    var maxAmmo: Int32 = 0
    var clNum: Int32 = -1
    var health: Int32 = 1
    var maxhealth: Int32 = 1
    var ammo: Int32 = 1
    var cent: Centity?

    if conStr.isEmpty {
        return
    }

    // Raven steps past the NUL when an entry has fewer than four fields, and his next test reads the byte after it.
    // The cursor reads 0 past the end of the text, so the walk stops there.
    while str.byte != 0 && argParses < 4 {
        i = 0
        while str.byte != 0 && str.byte != Int32(ascii: "|") {
            s[i] = str.byte
            i += 1
            str.advance()
        }
        s[i] = 0
        switch argParses {
        case 0:
            clNum = atoi(s)

        case 1:
            health = atoi(s)

        case 2:
            maxhealth = atoi(s)

        case 3:
            ammo = atoi(s)

        default:
            break
        }
        argParses += 1
        str.advance()
    }

    if clNum < 0 || clNum >= MAX_CLIENTS {
        return
    }

    cg_siegeExtendedData[clNum].health = health
    cg_siegeExtendedData[clNum].maxhealth = maxhealth
    cg_siegeExtendedData[clNum].ammo = ammo

    cent = cg_entities[clNum]

    maxAmmo = ammoData[weaponData[cent!.currentState.weapon].ammoIndex].max
    if (cent!.currentState.eFlags & EF_DOUBLE_AMMO) != 0 {
        maxAmmo = Int32(Float(maxAmmo) * 2.0)
    }
    if ammo >= 0 && ammo <= maxAmmo {
        //assure the weapon number is valid and not over max
        //keep the weapon so if it changes before our next ext data update we'll know
        //that the ammo is not applicable.
        cg_siegeExtendedData[clNum].weapon = cent!.currentState.weapon
    } else {
        //not valid? Oh well, just invalidate the weapon too then so we don't display ammo
        cg_siegeExtendedData[clNum].weapon = -1
    }

    cg_siegeExtendedData[clNum].lastUpdated = cg.time
}

//parse incoming siege data, see counterpart in g_saga.c
/// Source: oracle/codemp/cgame/cg_saga.c:1063
public func CG_ParseSiegeExtendedData() {
    let numEntries: Int32 = trap_Argc()
    var i: Int32 = 0

    if numEntries < 1 {
        return
    }

    while i < numEntries {
        CG_ParseSiegeExtendedDataEntry(CG_Argv(i + 1))
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_saga.c:1081
public func CG_SetSiegeTimerCvar(_ msec: Int32) {
    var seconds: Int32
    let mins: Int32
    let tens: Int32

    seconds = msec / 1000
    mins = seconds / 60
    seconds -= mins * 60
    tens = seconds / 10
    seconds -= tens * 10

    trap_Cvar_Set("ui_siegeTimer", va("%i:%i%i", mins, tens, seconds))
}
