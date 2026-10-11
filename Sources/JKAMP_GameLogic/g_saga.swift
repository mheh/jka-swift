import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_saga.c:15
let SIEGEITEM_STARTOFFRADAR = 8 as Int32

/// Source: oracle/codemp/game/g_saga.c:17
var team1: JKAShared.CharBuf {
    get { world.variables.team1 }
    set { world.variables.team1 = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:18
var team2: JKAShared.CharBuf {
    get { world.variables.team2 }
    set { world.variables.team2 = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:20
var g_siegePersistant: JKAMP.SiegePers { world.storage.g_siegePersistant }

/// Source: oracle/codemp/game/g_saga.c:22
var imperial_goals_required: Int32 {
    get { world.variables.imperial_goals_required }
    set { world.variables.imperial_goals_required = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:23
var imperial_goals_completed: Int32 {
    get { world.variables.imperial_goals_completed }
    set { world.variables.imperial_goals_completed = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:24
var rebel_goals_required: Int32 {
    get { world.variables.rebel_goals_required }
    set { world.variables.rebel_goals_required = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:25
var rebel_goals_completed: Int32 {
    get { world.variables.rebel_goals_completed }
    set { world.variables.rebel_goals_completed = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:27
var imperial_time_limit: Int32 {
    get { world.variables.imperial_time_limit }
    set { world.variables.imperial_time_limit = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:28
var rebel_time_limit: Int32 {
    get { world.variables.rebel_time_limit }
    set { world.variables.rebel_time_limit = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:30
var gImperialCountdown: Int32 {
    get { world.variables.gImperialCountdown }
    set { world.variables.gImperialCountdown = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:31
var gRebelCountdown: Int32 {
    get { world.variables.gRebelCountdown }
    set { world.variables.gRebelCountdown = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:33
var rebel_attackers: Int32 {
    get { world.variables.rebel_attackers }
    set { world.variables.rebel_attackers = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:34
var imperial_attackers: Int32 {
    get { world.variables.imperial_attackers }
    set { world.variables.imperial_attackers = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:36
var gSiegeRoundBegun: Bool {
    get { world.variables.gSiegeRoundBegun }
    set { world.variables.gSiegeRoundBegun = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:37
var gSiegeRoundEnded: Bool {
    get { world.variables.gSiegeRoundEnded }
    set { world.variables.gSiegeRoundEnded = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:38
var gSiegeRoundWinningTeam: Int32 {
    get { world.variables.gSiegeRoundWinningTeam }
    set { world.variables.gSiegeRoundWinningTeam = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:39
var gSiegeBeginTime: Int32 {
    get { world.variables.gSiegeBeginTime }
    set { world.variables.gSiegeBeginTime = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:41
var g_preroundState: Int32 {
    get { world.variables.g_preroundState }
    set { world.variables.g_preroundState = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:46
var gParseObjectives: JKAShared.CharBuf {
    get { world.variables.gParseObjectives }
    set { world.variables.gParseObjectives = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:47
var gObjectiveCfgStr: JKAShared.CharBuf {
    get { world.variables.gObjectiveCfgStr }
    set { world.variables.gObjectiveCfgStr = newValue }
}

/// Source: oracle/codemp/game/g_saga.c:1336
let SIEGE_ITEM_RESPAWN_TIME = 20000 as Int32

//go through all classes on a team and register their
//weapons and items for precaching.
/// Source: oracle/codemp/game/g_saga.c:51
func G_SiegeRegisterWeaponsAndHoldables(_ team: Int32) {
    let stm: SiegeTeam? = BG_SiegeFindThemeForTeam(team)

    if stm != nil {
        var i: Int32 = 0
        var scl: SiegeClass?
        while i < stm!.numClasses {
            scl = stm!.classes[i]

            if scl != nil {
                var j: Int32 = 0
                while j < WP_NUM_WEAPONS {
                    if (scl!.weapons & (1 << j)) != 0 {
                        //we use this weapon so register it.
                        RegisterItem(BG_FindItemForWeapon(j)!)
                    }
                    j += 1
                }
                j = 0
                while j < HI_NUM_HOLDABLE {
                    if (scl!.invenItems & (1 << j)) != 0 {
                        //we use this item so register it.
                        RegisterItem(BG_FindItemForHoldable(j)!)
                    }
                    j += 1
                }
            }
            i += 1
        }
    }
}

//tell clients that this team won and print it on their scoreboard for intermission
//or whatever.
/// Source: oracle/codemp/game/g_saga.c:91
func SiegeSetCompleteData(_ team: Int32) {
    trap_SetConfigstring(CS_SIEGE_WINTEAM, va("%i", team))
}

/// Source: oracle/codemp/game/g_saga.c:96
func InitSiegeMode() {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = VmCvar.scratch { mapname -> Bool in
        var levelname = CharBuf(512)
        var teamIcon = CharBuf(128)
        var goalreq = CharBuf(64)
        var teams = CharBuf(2048)
        var objective = CharBuf(16384)
        var objecStr = CharBuf(8192)
        var len: Int32 = 0
        var i: Int32 = 0
        //	int				j = 0;
        var objectiveNumTeam1: Int32 = 0
        var objectiveNumTeam2: Int32 = 0
        var f: fileHandle_t = 0

        failure: do {
            if g_gametype.integer != GT_SIEGE {
                break failure
            }

            //reset
            SiegeSetCompleteData(0)

            //get pers data in case it existed from last level
            if g_siegeTeamSwitch.integer != 0 {
                trap_SiegePersGet(g_siegePersistant)
                if g_siegePersistant.beatingTime {
                    trap_SetConfigstring(CS_SIEGE_TIMEOVERRIDE, va("%i", g_siegePersistant.lastTime))
                } else {
                    trap_SetConfigstring(CS_SIEGE_TIMEOVERRIDE, "0")
                }
            } else {
                //hmm, ok, nothing.
                trap_SetConfigstring(CS_SIEGE_TIMEOVERRIDE, "0")
            }

            imperial_goals_completed = 0
            rebel_goals_completed = 0

            trap_Cvar_Register(mapname, "mapname", "", CVAR_SERVERINFO | CVAR_ROM)

            Com_sprintf(&levelname, Int32((levelname).count), "maps/%s.siege\0", mapname.string)

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

            //See if players should be specs or ingame preround
            if BG_SiegeGetPairedValue(String(siege_info), "preround_state", &teams) != 0 {
                if teams[0] != 0 {
                    g_preroundState = atoi(teams)
                }
            }

            if BG_SiegeGetValueGroup(String(siege_info), "Teams", &teams) != 0 {
                if !g_siegeTeam1.string.isEmpty && Q_stricmp(g_siegeTeam1.string, "none") != 0 {
                    //check for override
                    strcpy(&team1, g_siegeTeam1.string)
                } else {
                    //otherwise use level default
                    BG_SiegeGetPairedValue(String(teams), "team1", &team1)
                }

                if !g_siegeTeam2.string.isEmpty && Q_stricmp(g_siegeTeam2.string, "none") != 0 {
                    //check for override
                    strcpy(&team2, g_siegeTeam2.string)
                } else {
                    //otherwise use level default
                    BG_SiegeGetPairedValue(String(teams), "team2", &team2)
                }
            } else {
                G_Error("Siege teams not defined")
            }

            if BG_SiegeGetValueGroup(String(siege_info), String(team2), &gParseObjectives) != 0 {
                if BG_SiegeGetPairedValue(String(gParseObjectives), "TeamIcon", &teamIcon) != 0 {
                    trap_Cvar_Set("team2_icon", String(teamIcon))
                }

                if BG_SiegeGetPairedValue(String(gParseObjectives), "RequiredObjectives", &goalreq) != 0 {
                    rebel_goals_required = atoi(goalreq)
                }
                if BG_SiegeGetPairedValue(String(gParseObjectives), "Timed", &goalreq) != 0 {
                    rebel_time_limit = atoi(goalreq) * 1000
                    if g_siegeTeamSwitch.integer != 0 && g_siegePersistant.beatingTime {
                        gRebelCountdown = level.time + g_siegePersistant.lastTime
                    } else {
                        gRebelCountdown = level.time + rebel_time_limit
                    }
                }
                if BG_SiegeGetPairedValue(String(gParseObjectives), "attackers", &goalreq) != 0 {
                    rebel_attackers = atoi(goalreq)
                }
            }

            if BG_SiegeGetValueGroup(String(siege_info), String(team1), &gParseObjectives) != 0 {
                if BG_SiegeGetPairedValue(String(gParseObjectives), "TeamIcon", &teamIcon) != 0 {
                    trap_Cvar_Set("team1_icon", String(teamIcon))
                }

                if BG_SiegeGetPairedValue(String(gParseObjectives), "RequiredObjectives", &goalreq) != 0 {
                    imperial_goals_required = atoi(goalreq)
                }
                if BG_SiegeGetPairedValue(String(gParseObjectives), "Timed", &goalreq) != 0 {
                    if rebel_time_limit != 0 {
                        Com_Printf("Tried to set imperial time limit, but there's already a rebel time limit!\nOnly one team can have a time limit.\n")
                    } else {
                        imperial_time_limit = atoi(goalreq) * 1000
                        if g_siegeTeamSwitch.integer != 0 && g_siegePersistant.beatingTime {
                            gImperialCountdown = level.time + g_siegePersistant.lastTime
                        } else {
                            gImperialCountdown = level.time + imperial_time_limit
                        }
                    }
                }
                if BG_SiegeGetPairedValue(String(gParseObjectives), "attackers", &goalreq) != 0 {
                    imperial_attackers = atoi(goalreq)
                }
            }

            //Load the player class types
            BG_SiegeLoadClasses(nil)

            if bgNumSiegeClasses == 0 {
                //We didn't find any?!
                G_Error("Couldn't find any player classes for Siege")
            }

            /*
            //We could probably just see what teams are used on this level,
            //then see what classes are used by those teams, and then precache
            //all weapons for said classes. However, I'm just going to do them
            //all for now.
            while (i < bgNumSiegeClasses)
            {
            cl = &bgSiegeClasses[i];
            j = 0;

            while (j < WP_NUM_WEAPONS)
            {
            if (cl->weapons & (1 << j))
            { //we use this weapon so register it.
            RegisterItem(BG_FindItemForWeapon(j));
            }

            j++;
            }

            i++;
            }
            */
            //Ok, I'm adding inventory item precaching now, so I'm finally going to optimize this
            //to only do weapons/items for the current teams used on the level.

            //Now load the teams since we have class data.
            BG_SiegeLoadTeams()

            if bgNumSiegeTeams == 0 {
                //React same as with classes.
                G_Error("Couldn't find any player teams for Siege")
            }

            //Get and set the team themes for each team. This will control which classes can be
            //used on each team.
            if BG_SiegeGetValueGroup(String(siege_info), String(team1), &gParseObjectives) != 0 {
                if BG_SiegeGetPairedValue(String(gParseObjectives), "UseTeam", &goalreq) != 0 {
                    BG_SiegeSetTeamTheme(SIEGETEAM_TEAM1, String(goalreq))
                }

                //Now count up the objectives for this team.
                i = 1
                strcpy(&objecStr, va("Objective%i", i))
                while BG_SiegeGetValueGroup(String(gParseObjectives), String(objecStr), &objective) != 0 {
                    objectiveNumTeam1 += 1
                    i += 1
                    strcpy(&objecStr, va("Objective%i", i))
                }
            }
            if BG_SiegeGetValueGroup(String(siege_info), String(team2), &gParseObjectives) != 0 {
                if BG_SiegeGetPairedValue(String(gParseObjectives), "UseTeam", &goalreq) != 0 {
                    BG_SiegeSetTeamTheme(SIEGETEAM_TEAM2, String(goalreq))
                }

                //Now count up the objectives for this team.
                i = 1
                strcpy(&objecStr, va("Objective%i", i))
                while BG_SiegeGetValueGroup(String(gParseObjectives), String(objecStr), &objective) != 0 {
                    objectiveNumTeam2 += 1
                    i += 1
                    strcpy(&objecStr, va("Objective%i", i))
                }
            }

            //Set the configstring to show status of all current objectives
            strcpy(&gObjectiveCfgStr, "t1")
            while objectiveNumTeam1 > 0 {
                //mark them all as not completed since we just initialized
                Q_strcat(&gObjectiveCfgStr, 1024, "-0")
                objectiveNumTeam1 -= 1
            }
            //Finished doing team 1's objectives, now do team 2's
            Q_strcat(&gObjectiveCfgStr, 1024, "|t2")
            while objectiveNumTeam2 > 0 {
                Q_strcat(&gObjectiveCfgStr, 1024, "-0")
                objectiveNumTeam2 -= 1
            }

            //And finally set the actual config string
            trap_SetConfigstring(CS_SIEGE_OBJECTIVES, String(gObjectiveCfgStr))

            //precache saber data for classes that use sabers on both teams
            BG_PrecacheSabersForSiegeTeam(SIEGETEAM_TEAM1)
            BG_PrecacheSabersForSiegeTeam(SIEGETEAM_TEAM2)

            G_SiegeRegisterWeaponsAndHoldables(SIEGETEAM_TEAM1)
            G_SiegeRegisterWeaponsAndHoldables(SIEGETEAM_TEAM2)

            return true

        }
        siege_valid = 0
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_saga.c:375
func G_SiegeSetObjectiveComplete(_ team: Int32, _ objective: Int32, _ failIt: Bool) {
    var p: Int32? = nil
    var onObjective: Int32 = 0

    if team == SIEGETEAM_TEAM1 {
        p = strstr(gObjectiveCfgStr, "t1")
    } else if team == SIEGETEAM_TEAM2 {
        p = strstr(gObjectiveCfgStr, "t2")
    }

    if p == nil {
        return
    }

    //Parse from the beginning of this team's objectives until we get to the desired objective
    //number.
    while p != nil && gObjectiveCfgStr[p!] != 0 && gObjectiveCfgStr[p!] != Int32(ascii: "|") {
        if gObjectiveCfgStr[p!] == Int32(ascii: "-") {
            onObjective += 1
        }

        if onObjective == objective {
            //this is the one we want
            //Move to the next char, the status of this objective
            p! += 1

            //Now change it from '0' to '1' if we are completeing the objective
            //or vice versa if the objective has been taken away
            if failIt {
                gObjectiveCfgStr[p!] = Int32(ascii: "0")
            } else {
                gObjectiveCfgStr[p!] = Int32(ascii: "1")
            }
            break
        }

        p! += 1
    }

    //Now re-update the configstring.
    trap_SetConfigstring(CS_SIEGE_OBJECTIVES, String(gObjectiveCfgStr))
}

//Returns qtrue if objective complete currently, otherwise qfalse
/// Source: oracle/codemp/game/g_saga.c:430
func G_SiegeGetCompletionStatus(_ team: Int32, _ objective: Int32) -> Bool {
    var p: Int32? = nil
    var onObjective: Int32 = 0

    if team == SIEGETEAM_TEAM1 {
        p = strstr(gObjectiveCfgStr, "t1")
    } else if team == SIEGETEAM_TEAM2 {
        p = strstr(gObjectiveCfgStr, "t2")
    }

    if p == nil {
        return false
    }

    //Parse from the beginning of this team's objectives until we get to the desired objective
    //number.
    while p != nil && gObjectiveCfgStr[p!] != 0 && gObjectiveCfgStr[p!] != Int32(ascii: "|") {
        if gObjectiveCfgStr[p!] == Int32(ascii: "-") {
            onObjective += 1
        }

        if onObjective == objective {
            //this is the one we want
            //Move to the next char, the status of this objective
            p! += 1

            //return qtrue if it's '1', qfalse if it's anything else
            if gObjectiveCfgStr[p!] == Int32(ascii: "1") {
                return true
            } else {
                return false
            }
            break
        }

        p! += 1
    }

    return false
}

/// Source: oracle/codemp/game/g_saga.c:482
func UseSiegeTarget(_ other: Entity, _ en: Entity, _ target: String) {
    //actually use the player which triggered the object which triggered the siege objective to trigger the target
    var t: Entity?
    var ent: Entity?

    if en.client == nil {
        //looks like we don't have access to a player, so just use the activating entity
        ent = other
    } else {
        ent = en
    }



    t = nil
    while let next = G_Find(t, \.targetname, target) {
        t = next
        if t!.s.number == ent!.s.number {
            G_Printf("WARNING: Entity used itself.\n")
        } else {
            if t!.use != nil {
                GlobalUse(t!, ent!, ent)
            }
        }
        if !ent!.inuse {
            G_Printf("entity was removed while using targets\n")
            return
        }
    }
}

/// Source: oracle/codemp/game/g_saga.c:528
func SiegeBroadcast_OBJECTIVECOMPLETE(_ team: Int32, _ client: Int32, _ objective: Int32) {
    var te: Entity?
    var nomatter = vec3_t()

    nomatter = vec3_t()

    te = G_TempEntity(nomatter, EV_SIEGE_OBJECTIVECOMPLETE)
    te!.r.svFlags |= SVF_BROADCAST
    te!.s.eventParm = team
    te!.s.weapon = client
    te!.s.trickedentindex = objective
}

/// Source: oracle/codemp/game/g_saga.c:542
func SiegeBroadcast_ROUNDOVER(_ winningteam: Int32, _ winningclient: Int32) {
    var te: Entity?
    var nomatter = vec3_t()

    nomatter = vec3_t()

    te = G_TempEntity(nomatter, EV_SIEGE_ROUNDOVER)
    te!.r.svFlags |= SVF_BROADCAST
    te!.s.eventParm = winningteam
    te!.s.weapon = winningclient
}

/// Source: oracle/codemp/game/g_saga.c:555
func BroadcastObjectiveCompletion(_ team: Int32, _ objective: Int32, _ final: Int32, _ client: Int32) {
    if client != ENTITYNUM_NONE && g_entities[client].client != nil && g_entities[client].client!.sess.sessionTeam == team {
        //guy who completed this objective gets points, providing he's on the opposing team
        AddScore(g_entities[client], g_entities[client].client!.ps.origin, SIEGE_POINTS_OBJECTIVECOMPLETED)
    }

    SiegeBroadcast_OBJECTIVECOMPLETE(team, client, objective)
    //G_Printf("Broadcast goal completion team %i objective %i final %i\n", team, objective, final);
}

/// Source: oracle/codemp/game/g_saga.c:566
func AddSiegeWinningTeamPoints(_ team: Int32, _ winner: Int32) {
    var i: Int32 = 0
    var ent: Entity?

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && ent!.client!.sess.sessionTeam == team {
            if i == winner {
                AddScore(ent!, ent!.client!.ps.origin, SIEGE_POINTS_TEAMWONROUND + SIEGE_POINTS_FINALOBJECTIVECOMPLETED)
            } else {
                AddScore(ent!, ent!.client!.ps.origin, SIEGE_POINTS_TEAMWONROUND)
            }
        }

        i += 1
    }
}

/// Source: oracle/codemp/game/g_saga.c:591
func SiegeClearSwitchData() {
    g_siegePersistant.clear()
    trap_SiegePersSet(g_siegePersistant)
}

/// Source: oracle/codemp/game/g_saga.c:597
func SiegeDoTeamAssign() {
    var i: Int32 = 0
    var ent: Entity?

    //yeah, this is great...
    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent!.inuse && ent!.client != nil && ent!.client!.pers.connected == CON_CONNECTED {
            //a connected client, switch his frickin teams around
            if ent!.client!.sess.siegeDesiredTeam == SIEGETEAM_TEAM1 {
                ent!.client!.sess.siegeDesiredTeam = SIEGETEAM_TEAM2
            } else if ent!.client!.sess.siegeDesiredTeam == SIEGETEAM_TEAM2 {
                ent!.client!.sess.siegeDesiredTeam = SIEGETEAM_TEAM1
            }

            if ent!.client!.sess.sessionTeam == SIEGETEAM_TEAM1 {
                SetTeamQuick(ent!, SIEGETEAM_TEAM2, false)
            } else if ent!.client!.sess.sessionTeam == SIEGETEAM_TEAM2 {
                SetTeamQuick(ent!, SIEGETEAM_TEAM1, false)
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_saga.c:632
func SiegeTeamSwitch(_ winTeam: Int32, _ winTime: Int32) {
    trap_SiegePersGet(g_siegePersistant)
    if g_siegePersistant.beatingTime {
        //was already in "switched" mode, change back
        //announce the winning team.
        //either the first team won again, or the second
        //team beat the time set by the initial team. In any
        //case the winTeam here is the overall winning team.
        SiegeSetCompleteData(winTeam)
        SiegeClearSwitchData()
    } else {
        //go into "beat their time" mode
        g_siegePersistant.beatingTime = true
        g_siegePersistant.lastTeam = winTeam
        g_siegePersistant.lastTime = winTime

        trap_SiegePersSet(g_siegePersistant)
    }
}

/// Source: oracle/codemp/game/g_saga.c:654
func SiegeRoundComplete(_ winningteam: Int32, _ winningclient: Int32) {
    var nomatter = vec3_t()
    var teamstr = CharBuf(1024)
    var originalWinningClient: Int32 = winningclient
    // Raven assigns his own `winningclient` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var winningclient = winningclient

    //G_Printf("Team %i won\n", winningteam);

    if winningclient != ENTITYNUM_NONE && g_entities[winningclient].client != nil && g_entities[winningclient].client!.sess.sessionTeam != winningteam {
        //this person just won the round for the other team..
        winningclient = ENTITYNUM_NONE
    }

    nomatter = vec3_t()

    SiegeBroadcast_ROUNDOVER(winningteam, winningclient)

    AddSiegeWinningTeamPoints(winningteam, winningclient)

    //Instead of exiting like this, fire off a target, and let it handle things.
    //Can be a script or whatever the designer wants.
    if winningteam == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    trap_SetConfigstring(CS_SIEGE_STATE, va("3|%i", level.time)) //ended
    gSiegeRoundBegun = false
    gSiegeRoundEnded = true
    gSiegeRoundWinningTeam = winningteam

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &gParseObjectives) != 0 {
        if BG_SiegeGetPairedValue(String(gParseObjectives), "roundover_target", &teamstr) == 0 {
            //didn't find the name of the thing to target upon win, just logexit now then.
            LogExit("Objectives completed")
            return
        }

        if originalWinningClient == ENTITYNUM_NONE {
            //oh well, just find something active and use it then.
            var i: Int32 = 0
            var ent: Entity?

            while i < MAX_CLIENTS {
                ent = g_entities[i]

                if ent!.inuse {
                    //sure, you'll do.
                    originalWinningClient = ent!.s.number
                    break
                }

                i += 1
            }
        }
        G_UseTargets2(g_entities[originalWinningClient], g_entities[originalWinningClient], String(teamstr))
    }

    if g_siegeTeamSwitch.integer != 0 && (imperial_time_limit != 0 || rebel_time_limit != 0) {
        //handle stupid team switching crap
        var time: Int32 = 0
        if imperial_time_limit != 0 {
            time = imperial_time_limit - (gImperialCountdown - level.time)
        } else if rebel_time_limit != 0 {
            time = rebel_time_limit - (gRebelCountdown - level.time)
        }

        if time < 1 {
            time = 1
        }
        SiegeTeamSwitch(winningteam, time)
    } else {
        //assure it's clear for next round
        SiegeClearSwitchData()
    }
}

/// Source: oracle/codemp/game/g_saga.c:744
func G_ValidateSiegeClassForTeam(_ ent: Entity, _ team: Int32) {
    var scl: SiegeClass?
    var stm: SiegeTeam?
    var newClassIndex: Int32 = -1
    if ent.client!.siegeClass == -1 {
        //uh.. sure.
        return
    }

    scl = bgSiegeClasses[ent.client!.siegeClass]

    stm = BG_SiegeFindThemeForTeam(team)
    if stm != nil {
        var i: Int32 = 0

        while i < stm!.numClasses {
            //go through the team and see its valid classes, can we find one that matches our current player class?
            if stm!.classes[i] != nil {
                if Q_stricmp(scl!.name, stm!.classes[i]!.name) == 0 {
                    //the class we're using is already ok for this team.
                    return
                }
                if stm!.classes[i]!.playerClass == scl!.playerClass || newClassIndex == -1 {
                    newClassIndex = i
                }
            }
            i += 1
        }

        if newClassIndex != -1 {
            //ok, let's find it in the global class array
            ent.client!.siegeClass = BG_SiegeFindClassIndexByName(stm!.classes[newClassIndex]!.name)
            strcpy(&ent.client!.sess.siegeClassBuffer, stm!.classes[newClassIndex]!.name)
        }
    }
}

//bypass most of the normal checks in SetTeam
/// Source: oracle/codemp/game/g_saga.c:787
func SetTeamQuick(_ ent: Entity, _ team: Int32, _ doBegin: Bool) {
    var userinfo = CharBuf(1024)

    strcpy(&userinfo, trap_GetUserinfo(ent.s.number, Int32((userinfo).count)))

    if g_gametype.integer == GT_SIEGE {
        G_ValidateSiegeClassForTeam(ent, team)
    }

    ent.client!.sess.sessionTeam = team

    if team == TEAM_SPECTATOR {
        ent.client!.sess.spectatorState = SPECTATOR_FREE
        Info_SetValueForKey(&userinfo, "team", "s")
    } else {
        ent.client!.sess.spectatorState = SPECTATOR_NOT
        if team == TEAM_RED {
            Info_SetValueForKey(&userinfo, "team", "r")
        } else if team == TEAM_BLUE {
            Info_SetValueForKey(&userinfo, "team", "b")
        } else {
            Info_SetValueForKey(&userinfo, "team", "?")
        }
    }

    trap_SetUserinfo(ent.s.number, String(userinfo))

    ent.client!.sess.spectatorClient = 0

    ent.client!.pers.teamState.state = TEAM_BEGIN

    ClientUserinfoChanged(ent.s.number)

    if doBegin {
        ClientBegin(ent.s.number, false)
    }
}

/// Source: oracle/codemp/game/g_saga.c:836
func SiegeRespawn(_ ent: Entity) {
    var tent: Entity?

    if ent.client!.sess.sessionTeam != ent.client!.sess.siegeDesiredTeam {
        SetTeamQuick(ent, ent.client!.sess.siegeDesiredTeam, true)
    } else {
        ClientSpawn(ent)
        // add a teleportation effect
        tent = G_TempEntity(ent.client!.ps.origin, EV_PLAYER_TELEPORT_IN)
        tent!.s.clientNum = ent.s.clientNum
    }
}

/// Source: oracle/codemp/game/g_saga.c:853
func SiegeBeginRound(_ entNum: Int32) {
    //entNum is just used as something to fire targets from.
    var targname = CharBuf(1024)

    if g_preroundState == 0 {
        //if players are not ingame on round start then respawn them now
        var i: Int32 = 0
        var ent: Entity?
        var spawnEnt: Bool = false

        //respawn everyone now
        while i < MAX_CLIENTS {
            ent = g_entities[i]

            if ent!.inuse && ent!.client != nil {
                if ent!.client!.sess.sessionTeam != TEAM_SPECTATOR && !((ent!.client!.ps.pm_flags & PMF_FOLLOW) != 0) {
                    //not a spec, just respawn them
                    spawnEnt = true
                } else if ent!.client!.sess.sessionTeam == TEAM_SPECTATOR && (ent!.client!.sess.siegeDesiredTeam == TEAM_RED || ent!.client!.sess.siegeDesiredTeam == TEAM_BLUE) {
                    //spectator but has a desired team
                    spawnEnt = true
                }
            }

            if spawnEnt {
                SiegeRespawn(ent!)

                spawnEnt = false
            }
            i += 1
        }
    }

    //Now check if there's something to fire off at the round start, if so do it.
    if BG_SiegeGetPairedValue(String(siege_info), "roundbegin_target", &targname) != 0 {
        if targname[0] != 0 {
            G_UseTargets2(g_entities[entNum], g_entities[entNum], String(targname))
        }
    }

    trap_SetConfigstring(CS_SIEGE_STATE, va("0|%i", level.time)) //we're ready to g0g0g0
}

/// Source: oracle/codemp/game/g_saga.c:905
func SiegeCheckTimers() {
    var i: Int32 = 0
    var ent: Entity?
    var numTeam1: Int32 = 0
    var numTeam2: Int32 = 0

    if g_gametype.integer != GT_SIEGE {
        return
    }

    if level.intermissiontime != 0 {
        return
    }

    if gSiegeRoundEnded {
        return
    }

    if !gSiegeRoundBegun {
        //check if anyone is active on this team - if not, keep the timer set up.
        i = 0

        while i < MAX_CLIENTS {
            ent = g_entities[i]

            if ent != nil && ent!.inuse && ent!.client != nil && ent!.client!.pers.connected == CON_CONNECTED && ent!.client!.sess.siegeDesiredTeam == SIEGETEAM_TEAM1 {
                numTeam1 += 1
            }
            i += 1
        }

        i = 0

        while i < MAX_CLIENTS {
            ent = g_entities[i]

            if ent != nil && ent!.inuse && ent!.client != nil && ent!.client!.pers.connected == CON_CONNECTED && ent!.client!.sess.siegeDesiredTeam == SIEGETEAM_TEAM2 {
                numTeam2 += 1
            }
            i += 1
        }

        if g_siegeTeamSwitch.integer != 0 && g_siegePersistant.beatingTime {
            gImperialCountdown = level.time + g_siegePersistant.lastTime
            gRebelCountdown = level.time + g_siegePersistant.lastTime
        } else {
            gImperialCountdown = level.time + imperial_time_limit
            gRebelCountdown = level.time + rebel_time_limit
        }
    }

    if imperial_time_limit != 0 {
        //team1
        if gImperialCountdown < level.time {
            SiegeRoundComplete(SIEGETEAM_TEAM2, ENTITYNUM_NONE)
            imperial_time_limit = 0
            return
        }
    }

    if rebel_time_limit != 0 {
        //team2
        if gRebelCountdown < level.time {
            SiegeRoundComplete(SIEGETEAM_TEAM1, ENTITYNUM_NONE)
            rebel_time_limit = 0
            return
        }
    }

    if !gSiegeRoundBegun {
        if numTeam1 == 0 || numTeam2 == 0 {
            //don't have people on both teams yet.
            gSiegeBeginTime = level.time + SIEGE_ROUND_BEGIN_TIME
            trap_SetConfigstring(CS_SIEGE_STATE, "1") //"waiting for players on both teams"
        } else if gSiegeBeginTime < level.time {
            //mark the round as having begun
            gSiegeRoundBegun = true
            SiegeBeginRound(i) //perform any round start tasks
        } else if gSiegeBeginTime > (level.time + SIEGE_ROUND_BEGIN_TIME) {
            gSiegeBeginTime = level.time + SIEGE_ROUND_BEGIN_TIME
        } else {
            trap_SetConfigstring(CS_SIEGE_STATE, va("2|%i", gSiegeBeginTime - SIEGE_ROUND_BEGIN_TIME)) //getting ready to begin
        }
    }
}

/// Source: oracle/codemp/game/g_saga.c:1015
func SiegeObjectiveCompleted(_ team: Int32, _ objective: Int32, _ final: Int32, _ client: Int32) {
    let goals_completed: Int32
    let goals_required: Int32

    if gSiegeRoundEnded {
        return
    }

    //Update the configstring status
    G_SiegeSetObjectiveComplete(team, objective, false)

    if final != -1 {
        if team == SIEGETEAM_TEAM1 {
            imperial_goals_completed += 1
        } else {
            rebel_goals_completed += 1
        }
    }

    if team == SIEGETEAM_TEAM1 {
        goals_completed = imperial_goals_completed
        goals_required = imperial_goals_required
    } else {
        goals_completed = rebel_goals_completed
        goals_required = rebel_goals_required
    }

    if final == 1 || goals_completed >= goals_required {
        SiegeRoundComplete(team, client)
    } else {
        BroadcastObjectiveCompletion(team, objective, final, client)
    }
}

/// Source: oracle/codemp/game/g_saga.c:1060
func siegeTriggerUse(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    var teamstr = CharBuf(64)
    var objectivestr = CharBuf(64)
    var desiredobjective = CharBuf(16384)
    var clUser: Int32 = ENTITYNUM_NONE
    var final: Int32 = 0
    var i: Int32 = 0

    if siege_valid == 0 {
        return
    }

    if !((ent.s.eFlags & EF_RADAROBJECT) != 0) {
        //toggle radar on and exit if it is not showing up already
        ent.s.eFlags |= EF_RADAROBJECT
        return
    }

    if activator.client != nil {
        //activator will hopefully be the person who triggered this event
        clUser = activator.s.number
    }

    if ent.side == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &gParseObjectives) != 0 {
        Com_sprintf(&objectivestr, Int32((objectivestr).count), "Objective%i", ent.objective)

        if BG_SiegeGetValueGroup(String(gParseObjectives), String(objectivestr), &desiredobjective) != 0 {
            if BG_SiegeGetPairedValue(String(desiredobjective), "final", &teamstr) != 0 {
                final = atoi(teamstr)
            }

            if BG_SiegeGetPairedValue(String(desiredobjective), "target", &teamstr) != 0 {
                while teamstr[i] != 0 {
                    if teamstr[i] == Int32(ascii: "\r") || teamstr[i] == Int32(ascii: "\n") {
                        teamstr[i] = 0
                    }

                    i += 1
                }
                UseSiegeTarget(other, activator, String(teamstr))
            }

            if ent.target != nil && !ent.target!.isEmpty {
                //use this too
                UseSiegeTarget(other, activator, ent.target!)
            }

            SiegeObjectiveCompleted(ent.side, ent.objective, final, clUser)
        }
    }
}

/**
```
QUAKED info_siege_objective (1 0 1) (-16 -16 -24) (16 16 32) ? x x STARTOFFRADAR
STARTOFFRADAR - start not displaying on radar, don't display until used.

"objective" - specifies the objective to complete upon activation
"side" - set to 1 to specify an imperial goal, 2 to specify rebels
"icon" - icon that represents the objective on the radar
```
*/
/// Source: oracle/codemp/game/g_saga.c:1137
func SP_info_siege_objective(_ ent: Entity) {
    var s: String = ""

    if siege_valid == 0 || g_gametype.integer != GT_SIEGE {
        G_FreeEntity(ent)
        return
    }

    ent.use = Use.siegeTriggerUse
    G_SpawnInt("objective", "0", &ent.objective)
    G_SpawnInt("side", "0", &ent.side)

    if ent.objective == 0 || ent.side == 0 {
        //j00 fux0red something up
        G_FreeEntity(ent)
        G_Printf("ERROR: info_siege_objective without an objective or side value\n")
        return
    }

    //Set it up to be drawn on radar
    if !((ent.spawnflags & SIEGEITEM_STARTOFFRADAR) != 0) {
        ent.s.eFlags |= EF_RADAROBJECT
    }

    //All clients want to know where it is at all times for radar
    ent.r.svFlags |= SVF_BROADCAST

    G_SpawnString("icon", "", &s)

    if !s.isEmpty {
        // We have an icon, so index it now.  We are reusing the genericenemyindex
        // variable rather than adding a new one to the entity state.
        ent.s.genericenemyindex = G_IconIndex(s)
    }

    ent.s.brokenLimbs = ent.side
    ent.s.frame = ent.objective
    trap_LinkEntity(ent)
}

/// Source: oracle/codemp/game/g_saga.c:1182
func SiegeIconUse(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    //toggle it on and off
    if (ent.s.eFlags & EF_RADAROBJECT) != 0 {
        ent.s.eFlags &= ~EF_RADAROBJECT
        ent.r.svFlags &= ~SVF_BROADCAST
    } else {
        ent.s.eFlags |= EF_RADAROBJECT
        ent.r.svFlags |= SVF_BROADCAST
    }
}

/**
```
QUAKED info_siege_radaricon (1 0 1) (-16 -16 -24) (16 16 32) ?
Used to arbitrarily display radar icons at placed location. Can be used
to toggle on and off.

"icon" - icon that represents the objective on the radar
"startoff" - if 1 start off
```
*/
/// Source: oracle/codemp/game/g_saga.c:1203
func SP_info_siege_radaricon(_ ent: Entity) {
    var s: String = ""
    var i: Int32 = 0

    if siege_valid == 0 || g_gametype.integer != GT_SIEGE {
        G_FreeEntity(ent)
        return
    }

    G_SpawnInt("startoff", "0", &i)

    if i == 0 {
        //start on then
        ent.s.eFlags |= EF_RADAROBJECT
        ent.r.svFlags |= SVF_BROADCAST
    }

    G_SpawnString("icon", "", &s)
    if s.isEmpty {
        //that's the whole point of the entity
        Com_Error(ERR_DROP, "misc_siege_radaricon without an icon")
        return
    }

    ent.use = Use.SiegeIconUse

    ent.s.genericenemyindex = G_IconIndex(s)

    trap_LinkEntity(ent)
}

/// Source: oracle/codemp/game/g_saga.c:1236
func decompTriggerUse(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    var final: Int32 = 0
    var teamstr = CharBuf(1024)
    var objectivestr = CharBuf(64)
    var desiredobjective = CharBuf(16384)

    if gSiegeRoundEnded {
        return
    }

    if !G_SiegeGetCompletionStatus(ent.side, ent.objective) {
        //if it's not complete then there's nothing to do here
        return
    }

    //Update the configstring status
    G_SiegeSetObjectiveComplete(ent.side, ent.objective, true)

    //Find out if this objective counts toward the final objective count
    if ent.side == SIEGETEAM_TEAM1 {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team1))
    } else {
        Com_sprintf(&teamstr, Int32((teamstr).count), String(team2))
    }

    if BG_SiegeGetValueGroup(String(siege_info), String(teamstr), &gParseObjectives) != 0 {
        Com_sprintf(&objectivestr, Int32((objectivestr).count), "Objective%i", ent.objective)

        if BG_SiegeGetValueGroup(String(gParseObjectives), String(objectivestr), &desiredobjective) != 0 {
            if BG_SiegeGetPairedValue(String(desiredobjective), "final", &teamstr) != 0 {
                final = atoi(teamstr)
            }
        }
    }

    //Subtract the goal num if applicable
    if final != -1 {
        if ent.side == SIEGETEAM_TEAM1 {
            imperial_goals_completed -= 1
        } else {
            rebel_goals_completed -= 1
        }
    }
}

/**
```
QUAKED info_siege_decomplete (1 0 1) (-16 -16 -24) (16 16 32)
"objective" - specifies the objective to decomplete upon activation
"side" - set to 1 to specify an imperial (team1) goal, 2 to specify rebels (team2)
```
*/
/// Source: oracle/codemp/game/g_saga.c:1297
func SP_info_siege_decomplete(_ ent: Entity) {
    if siege_valid == 0 || g_gametype.integer != GT_SIEGE {
        G_FreeEntity(ent)
        return
    }

    ent.use = Use.decompTriggerUse
    G_SpawnInt("objective", "0", &ent.objective)
    G_SpawnInt("side", "0", &ent.side)

    if ent.objective == 0 || ent.side == 0 {
        //j00 fux0red something up
        G_FreeEntity(ent)
        G_Printf("ERROR: info_siege_objective_decomplete without an objective or side value\n")
        return
    }
}

/// Source: oracle/codemp/game/g_saga.c:1317
func siegeEndUse(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    LogExit("Round ended")
}

/**
```
QUAKED target_siege_end (1 0 1) (-16 -16 -24) (16 16 32)
Do a logexit for siege when used.
```
*/
/// Source: oracle/codemp/game/g_saga.c:1325
func SP_target_siege_end(_ ent: Entity) {
    if siege_valid == 0 || g_gametype.integer != GT_SIEGE {
        G_FreeEntity(ent)
        return
    }

    ent.use = Use.siegeEndUse
}

/// Source: oracle/codemp/game/g_saga.c:1338
func SiegeItemRemoveOwner(_ ent: Entity, _ carrier: Entity) {
    ent.genericValue2 = 0 //Remove picked-up flag

    ent.genericValue8 = ENTITYNUM_NONE //Mark entity carrying us as none

    carrier.client!.holdingObjectiveItem = 0 //The carrier is no longer carrying us
    carrier.r.svFlags &= ~SVF_BROADCAST
}

/// Source: oracle/codemp/game/g_saga.c:1351
private func SiegeItemRespawnEffect(_ ent: Entity, _ newOrg: JKAShared.vec3_t) {
    var upAng = vec3_t()

    if ent.target5 != nil && !ent.target5!.isEmpty {
        G_UseTargets2(ent, ent, ent.target5!)
    }

    if ent.genericValue10 == 0 {
        //no respawn effect
        return
    }

    upAng = vec3_t(0, 0, 1)

    //Play it once on the current origin, and once on the origin we're respawning to.
    G_PlayEffectID(ent.genericValue10, ent.r.currentOrigin, upAng)
    G_PlayEffectID(ent.genericValue10, newOrg, upAng)
}

/// Source: oracle/codemp/game/g_saga.c:1372
private func SiegeItemRespawnOnOriginalSpot(_ ent: Entity, _ carrier: Entity?) {
    SiegeItemRespawnEffect(ent, ent.pos1)
    G_SetOrigin(ent, &ent.pos1)
    // Port-note: Raven passes the optional `carrier` to `SiegeItemRemoveOwner`, whose `carrier` parameter takes a value. A never-null ruling is due.
    // Raven wrote: SiegeItemRemoveOwner(ent, carrier)
    portMissing("SiegeItemRespawnOnOriginalSpot", source: "oracle/codemp/game/g_saga.c:1372")

    // Stop the item from flashing on the radar
    ent.s.time2 = 0
}

/// Source: oracle/codemp/game/g_saga.c:1382
func SiegeItemThink(_ ent: Entity) {
    var carrier: Entity? = nil

    if ent.genericValue12 != 0 {
        //recharge health
        if ent.health > 0 && ent.health < ent.maxHealth && ent.genericValue14 < level.time {
            ent.genericValue14 = level.time + ent.genericValue13
            ent.health += ent.genericValue12
            if ent.health > ent.maxHealth {
                ent.health = ent.maxHealth
            }
        }
    }

    if ent.genericValue8 != ENTITYNUM_NONE {
        //Just keep sticking it on top of the owner. We need it in the same PVS as him so it will render bolted onto him properly.
        carrier = g_entities[ent.genericValue8]

        if carrier!.inuse && carrier!.client != nil {
            ent.r.currentOrigin = carrier!.client!.ps.origin
            trap_LinkEntity(ent)
        }
    } else if ent.genericValue1 != 0 {
        //this means we want to run physics on the object
        G_RunExPhys(ent, ent.radius, ent.mass, ent.random, false, nil, 0)
    }

    //Bolt us to whoever is carrying us if a client
    if ent.genericValue8 < MAX_CLIENTS {
        ent.s.boltToPlayer = ent.genericValue8 + 1
    } else {
        ent.s.boltToPlayer = 0
    }


    if carrier != nil {
        var carrier: Entity? = g_entities[ent.genericValue8]

        //This checking can be a bit iffy on the death stuff, but in theory we should always
        //get a think in before the default minimum respawn time is exceeded.
        if !carrier!.inuse || carrier!.client == nil || (carrier!.client!.sess.sessionTeam != SIEGETEAM_TEAM1 && carrier!.client!.sess.sessionTeam != SIEGETEAM_TEAM2) || (carrier!.client!.ps.pm_flags & PMF_FOLLOW) != 0 {
            //respawn on the original spot
            SiegeItemRespawnOnOriginalSpot(ent, nil)
        } else if carrier!.health < 1 {
            //The carrier died so pop out where he is (unless in nodrop).
            if ent.target6 != nil && !ent.target6!.isEmpty {
                G_UseTargets2(ent, ent, ent.target6!)
            }

            if (trap_PointContents(carrier!.client!.ps.origin, carrier!.s.number) & CONTENTS_NODROP) != 0 {
                //In nodrop land, go back to the original spot.
                SiegeItemRespawnOnOriginalSpot(ent, carrier)
            } else {
                G_SetOrigin(ent, &carrier!.client!.ps.origin)
                ent.epVelocity[0] = Float(Q_irand(-80, 80))
                ent.epVelocity[1] = Float(Q_irand(-80, 80))
                ent.epVelocity[2] = Float(Q_irand(40, 80))

                //We're in a nonstandard place, so if we go this long without being touched,
                //assume we may not be reachable and respawn on the original spot.
                ent.genericValue9 = level.time + SIEGE_ITEM_RESPAWN_TIME

                SiegeItemRemoveOwner(ent, carrier!)
            }
        }
    }

    if ent.genericValue9 != 0 && ent.genericValue9 < level.time {
        //time to respawn on the original spot then
        SiegeItemRespawnEffect(ent, ent.pos1)
        G_SetOrigin(ent, &ent.pos1)
        ent.genericValue9 = 0

        // stop flashing on radar
        ent.s.time2 = 0
    }

    ent.nextthink = level.time + FRAMETIME / 2
}

/// Source: oracle/codemp/game/g_saga.c:1477
func SiegeItemTouch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if !other.inuse || other.client == nil || other.s.eType == ET_NPC {
        if trace.startsolid != 0 {
            //let me out! (ideally this should not happen, but such is life)
            var escapePos = vec3_t()
            escapePos = `self`.r.currentOrigin
            escapePos[2] += 1.0

            //I hope you weren't stuck in the ceiling.
            G_SetOrigin(`self`, &escapePos)
        }
        return
    }

    if other.health < 1 {
        //dead people can't pick us up.
        return
    }

    if other.client!.holdingObjectiveItem != 0 {
        //this guy's already carrying a siege item
        return
    }

    if other.client!.ps.pm_type == PM_SPECTATOR {
        //spectators don't pick stuff up
        return
    }

    if `self`.genericValue2 != 0 {
        //Am I already picked up?
        return
    }

    if `self`.genericValue6 == other.client!.sess.sessionTeam {
        //Set to not be touchable by players on this team.
        return
    }

    if !gSiegeRoundBegun {
        //can't pick it up if round hasn't started yet
        return
    }

    if `self`.noise_index != 0 {
        //play the pickup noise.
        G_Sound(other, CHAN_AUTO, `self`.noise_index)
    }

    `self`.genericValue2 = 1 //Mark it as picked up.

    other.client!.holdingObjectiveItem = `self`.s.number
    other.r.svFlags |= SVF_BROADCAST //broadcast player while he carries this
    `self`.genericValue8 = other.s.number //Keep the index so we know who is "carrying" us

    `self`.genericValue9 = 0 //So it doesn't think it has to respawn.

    if `self`.target2 != nil && !`self`.target2!.isEmpty && (`self`.genericValue4 == 0 || `self`.genericValue5 == 0) {
        //fire the target for pickup, if it's set to fire every time, or set to only fire the first time and the first time has not yet occured.
        G_UseTargets2(`self`, `self`, `self`.target2!)
        `self`.genericValue5 = 1 //mark it as having been picked up
    }

    // time2 set to -1 will blink the item on the radar indefinately
    `self`.s.time2 = Int32(bitPattern: 0xFFFFFFFF)
}

/// Source: oracle/codemp/game/g_saga.c:1547
func SiegeItemPain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    // Time 2 is used to pulse the radar icon to show its under attack
    `self`.s.time2 = level.time
}

/// Source: oracle/codemp/game/g_saga.c:1553
func SiegeItemDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ meansOfDeath: Int32) {
    `self`.takedamage = false //don't die more than once

    if `self`.genericValue3 != 0 {
        //An indexed effect to play on death
        var upAng = vec3_t()

        upAng = vec3_t(0, 0, 1)
        G_PlayEffectID(`self`.genericValue3, `self`.r.currentOrigin, upAng)
    }

    `self`.neverFree = false
    `self`.think = Think.G_FreeEntity
    `self`.nextthink = level.time

    //Fire off the death target if we've got one.
    if `self`.target4 != nil && !`self`.target4!.isEmpty {
        G_UseTargets2(`self`, `self`, `self`.target4!)
    }
}

/// Source: oracle/codemp/game/g_saga.c:1576
func SiegeItemUse(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    //once used, become active
    if (ent.spawnflags & SIEGEITEM_STARTOFFRADAR) != 0 {
        //start showing on radar
        ent.s.eFlags |= EF_RADAROBJECT

        if !((ent.s.eFlags & EF_NODRAW) != 0) {
            //we've nothing else to do here
            return
        }
    } else {
        //make sure it's showing up
        ent.s.eFlags |= EF_RADAROBJECT
    }

    if ent.genericValue11 != 0 || !ent.takedamage {
        //We want to be able to walk into it to pick it up then.
        ent.r.contents = CONTENTS_TRIGGER
        ent.clipmask = CONTENTS_SOLID | CONTENTS_TERRAIN
        if ent.genericValue11 != 0 {
            ent.touch = Touch.SiegeItemTouch
        }
    } else {
        //Make it solid.
        ent.r.contents = MASK_PLAYERSOLID
        ent.clipmask = MASK_PLAYERSOLID
    }

    ent.think = Think.SiegeItemThink
    ent.nextthink = level.time + FRAMETIME / 2

    //take off nodraw
    ent.s.eFlags &= ~EF_NODRAW

    if ent.paintarget != nil && !ent.paintarget!.isEmpty {
        //want to be on this guy's origin now then
        let targ = G_Find(nil, \.targetname, ent.paintarget!)

        if targ != nil && targ!.inuse {
            G_SetOrigin(ent, &targ!.r.currentOrigin)
            trap_LinkEntity(ent)
        }
    }
}

/**
```
QUAKED misc_siege_item (1 0 1) (-16 -16 -24) (16 16 32) ? x x STARTOFFRADAR
STARTOFFRADAR - start not displaying on radar, don't display until used.

"model"				Name of model to use for the object
"mins"				Actual mins of the object. Careful not to place it into a solid,
					as these new mins will not be reflected visually in the editor.
					Default value is "-16 -16 -24".
"maxs"				Same as above for maxs. Default value is "16 16 32".
"targetname"		If it has a targetname, it will only spawn upon being used.
"target2"			Target to fire upon pickup. If none, nothing will happen.
"pickuponlyonce"	If non-0, target2 will only be fired on the first pickup. If the item is
					dropped and picked up again later, the target will not be fired off on
					the sequential pickup. Default value is 1.
"target3"			Target to fire upon delivery of the item to the goal point.
					If none, nothing will happen. (but you should always want something to happen)
"health"			If > 0, object can be damaged and will die once health reaches 0. Default is 0.
"showhealth"		if health > 0, will show a health meter for this item
"teamowner"			Which team owns this item, used only for deciding what color to make health meter
"target4"			Target to fire upon death, if damageable. Default is none.
"deathfx"			Effect to play on death, if damageable. Default is none.
"canpickup"			If non-0, item can be picked up. Otherwise it will just be solid and sit on the
					ground. Default is 1.
"pickupsound"		Sound to play on pickup, if any.
"goaltarget"		Must be the targetname of a trigger_multi/trigger_once. Once a player carrying
					this object is brought inside the specified trigger, then that trigger will be
					allowed to fire. Ideally it will target a siege objective or something like that.
"usephysics"		If non-0, run standard physics on the object. Default is 1.
"mass"				If usephysics, this will be the factored object mass. Default is 0.09.
"gravity"			If usephysics, this will be the factored gravitational pull. Default is 3.0.
"bounce"			If usephysics, this will be the factored bounce amount. Default is 1.3.
"teamnotouch"		If 1 don't let team 1 pickup, if 2 don't let team 2. By default both teams
					can pick this object up and carry it around until death.
"teamnocomplete"	Same values as above, but controls if this object can be taken into the objective
					area by said team.
"respawnfx"			Plays this effect when respawning (e.g. it is left in an unknown area too long
					and goes back to the original spot). If this is not specified there will be
					no effect. (expected format is .efx file)
"paintarget"		plop self on top of this guy's origin when we are used (only applies if the siege
					item has a targetname)
"noradar"			if non-0 this thing will not show up on radar

"forcelimit"		if non-0, while carrying this item, the carrier's force powers will be crippled.
"target5"			target to fire when respawning.
"target6"			target to fire when dropped by someone carrying this item.

"icon"				icon that represents the gametype item on the radar

health charge things only work with showhealth 1 on siege items that take damage.
"health_chargeamt"	if non-0 will recharge this much health every...
"health_chargerate"	...this many milliseconds
```
*/
/// Source: oracle/codemp/game/g_saga.c:1676
func SP_misc_siege_item(_ ent: Entity) {
    var canpickup: Int32 = 0
    var noradar: Int32 = 0
    var s: String = ""

    if siege_valid == 0 || g_gametype.integer != GT_SIEGE {
        G_FreeEntity(ent)
        return
    }

    if ent.model == nil || ent.model!.isEmpty {
        G_Error("You must specify a model for misc_siege_item types.")
    }

    G_SpawnInt("canpickup", "1", &canpickup)
    G_SpawnInt("usephysics", "1", &ent.genericValue1)

    if ent.genericValue1 != 0 {
        //if we're using physics we want lerporigin smoothing
        ent.s.eFlags |= EF_CLIENTSMOOTH
    }

    G_SpawnInt("noradar", "0", &noradar)
    //Want it to always show up as a goal object on radar
    if noradar == 0 && !((ent.spawnflags & SIEGEITEM_STARTOFFRADAR) != 0) {
        ent.s.eFlags |= EF_RADAROBJECT
    }

    //All clients want to know where it is at all times for radar
    ent.r.svFlags |= SVF_BROADCAST

    G_SpawnInt("pickuponlyonce", "1", &ent.genericValue4)

    G_SpawnInt("teamnotouch", "0", &ent.genericValue6)
    G_SpawnInt("teamnocomplete", "0", &ent.genericValue7)

    //Get default physics values.
    G_SpawnFloat("mass", "0.09", &ent.mass)
    G_SpawnFloat("gravity", "3.0", &ent.radius)
    G_SpawnFloat("bounce", "1.3", &ent.random)

    G_SpawnString("pickupsound", "", &s)

    if !s.isEmpty {
        //We have a pickup sound, so index it now.
        ent.noise_index = G_SoundIndex(s)
    }

    G_SpawnString("deathfx", "", &s)

    if !s.isEmpty {
        //We have a death effect, so index it now.
        ent.genericValue3 = G_EffectIndex(s)
    }

    G_SpawnString("respawnfx", "", &s)

    if !s.isEmpty {
        //We have a respawn effect, so index it now.
        ent.genericValue10 = G_EffectIndex(s)
    }

    G_SpawnString("icon", "", &s)

    if !s.isEmpty {
        // We have an icon, so index it now.  We are reusing the genericenemyindex
        // variable rather than adding a new one to the entity state.
        ent.s.genericenemyindex = G_IconIndex(s)
    }

    ent.s.modelindex = G_ModelIndex(ent.model!)

    //Is the model a ghoul2 model?
    // Port-note: Raven reads `ent->model[strlen(ent->model) - 4]` through a `char *` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.
    // Raven wrote: if (!Q_stricmp(&ent->model[strlen(ent->model) - 4], ".glm")) { //apparently so. ent->s.modelGhoul2 = 1; }
    portMissing("SP_misc_siege_item", source: "oracle/codemp/game/g_saga.c:1676")

    ent.s.eType = ET_GENERAL

    //Set the mins/maxs with default values.
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec3_t' (aka 'SIMD3<Float>') to expected argument type 'Float'".
    // Raven wrote: G_SpawnVector("mins", "-16 -16 -24", ent->r.mins)
    portMissing("SP_misc_siege_item", source: "oracle/codemp/game/g_saga.c:1676")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec3_t' (aka 'SIMD3<Float>') to expected argument type 'Float'".
    // Raven wrote: G_SpawnVector("maxs", "16 16 32", ent->r.maxs)
    portMissing("SP_misc_siege_item", source: "oracle/codemp/game/g_saga.c:1676")

    ent.pos1 = ent.s.origin //store off the initial origin for respawning
    G_SetOrigin(ent, &ent.s.origin)

    ent.r.currentAngles = ent.s.angles
    ent.s.apos.trBase = ent.s.angles

    G_SpawnInt("forcelimit", "0", &ent.genericValue15)

    if ent.health > 0 {
        //If it has health, it can be killed.
        var t: Int32 = 0

        ent.pain = Pain.SiegeItemPain
        ent.die = Die.SiegeItemDie
        ent.takedamage = true

        G_SpawnInt("showhealth", "0", &t)
        if t != 0 {
            //a non-0 maxhealth value will mean we want to show the health on the hud
            ent.maxHealth = ent.health
            G_ScaleNetHealth(ent)

            G_SpawnInt("health_chargeamt", "0", &ent.genericValue12)
            G_SpawnInt("health_chargerate", "0", &ent.genericValue13)
        }
    } else {
        //Otherwise no.
        ent.takedamage = false
    }

    if (ent.spawnflags & SIEGEITEM_STARTOFFRADAR) != 0 {
        ent.use = Use.SiegeItemUse
    } else if ent.targetname != nil && !ent.targetname!.isEmpty {
        ent.s.eFlags |= EF_NODRAW //kind of hacky, but whatever
        ent.genericValue11 = canpickup
        ent.use = Use.SiegeItemUse
        ent.s.eFlags &= ~EF_RADAROBJECT
    }

    if (ent.targetname == nil || ent.targetname!.isEmpty) || (ent.spawnflags & SIEGEITEM_STARTOFFRADAR) != 0 {
        if canpickup != 0 || !ent.takedamage {
            //We want to be able to walk into it to pick it up then.
            ent.r.contents = CONTENTS_TRIGGER
            ent.clipmask = CONTENTS_SOLID | CONTENTS_TERRAIN
            if canpickup != 0 {
                ent.touch = Touch.SiegeItemTouch
            }
        } else {
            //Make it solid.
            ent.r.contents = MASK_PLAYERSOLID
            ent.clipmask = MASK_PLAYERSOLID
        }

        ent.think = Think.SiegeItemThink
        ent.nextthink = level.time + FRAMETIME / 2
    }

    ent.genericValue8 = ENTITYNUM_NONE //initialize the carrier to none

    ent.neverFree = true //never free us unless we specifically request it.

    trap_LinkEntity(ent)
}

//sends extra data about other client's in this client's PVS
//used for support guy etc.
//with this formatting:
//sxd 16,999,999,999|17,999,999,999
//assumed max 2 chars for cl num, 3 chars per ammo/health/maxhealth, even a single string full of
//info for all 32 clients should not get much past 450 bytes, which is well within a
//reasonable range. We don't need to send anything about the max ammo or current weapon, because
//currentState.weapon can be checked for the ent in question on the client. -rww
/// Source: oracle/codemp/game/g_saga.c:1845
func G_SiegeClientExData(_ msgTarg: Entity) {
    var ent: Entity?
    var count: Int32 = 0
    var i: Int32 = 0
    var str = CharBuf(1024)
    var scratch = CharBuf(1024)

    while i < level.num_entities && count < MAX_EXDATA_ENTS_TO_SEND {
        ent = g_entities[i]

        if ent!.inuse && ent!.client != nil && msgTarg.s.number != ent!.s.number && ent!.s.eType == ET_PLAYER && msgTarg.client!.sess.sessionTeam == ent!.client!.sess.sessionTeam && trap_InPVS(msgTarg.client!.ps.origin, ent!.client!.ps.origin) {
            //another client in the same pvs, send his jive
            if count != 0 {
                //append a seperating space if we are not the first in the list
                Q_strcat(&str, Int32((str).count), " ")
            } else {
                //otherwise create the prepended chunk
                strcpy(&str, "sxd ")
            }

            //append the stats
            Com_sprintf(&scratch, Int32((scratch).count), "%i|%i|%i|%i", ent!.s.number, ent!.client!.ps.stats[STAT_HEALTH], ent!.client!.ps.stats[STAT_MAX_HEALTH], ent!.client!.ps.ammo[weaponData[ent!.client!.ps.weapon].ammoIndex])
            Q_strcat(&str, Int32((str).count), String(scratch))
            count += 1
        }
        i += 1
    }

    if count == 0 {
        //nothing to send
        return
    }

    //send the string to him
    trap_SendServerCommand(msgTarg.s.number, String(str))
}
