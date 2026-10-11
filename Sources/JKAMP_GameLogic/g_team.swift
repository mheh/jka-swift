import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_team.c:18
var teamgame: Teamgame { world.storage.teamgame }

/// Source: oracle/codemp/game/g_team.c:279
// Raven wrote: static char ctfFlagStatusRemap[] = { '0', '1', '*', '*', '2' }
nonisolated(unsafe) let ctfFlagStatusRemap: JKAShared.CharBuf = { () -> JKAShared.CharBuf in portMissing("ctfFlagStatusRemap", source: "oracle/codemp/game/g_team.c:279") }()

/// Source: oracle/codemp/game/g_team.c:950
let MAX_TEAM_SPAWN_POINTS = 32 as Int32

/// Source: oracle/codemp/game/g_team.c:22
func Team_InitGame() {
    teamgame.clear()

    switch g_gametype.integer {
    case GT_CTF, GT_CTY:
        teamgame.blueStatus = -1 // Invalid to force update
        teamgame.redStatus = teamgame.blueStatus // Invalid to force update
        Team_SetFlagStatus(TEAM_RED, FLAG_ATBASE)
        Team_SetFlagStatus(TEAM_BLUE, FLAG_ATBASE)

    default:
        break
    }
}

/// Source: oracle/codemp/game/g_team.c:37
func OtherTeam(_ team: Int32) -> Int32 {
    if team == TEAM_RED {
        return TEAM_BLUE
    } else if team == TEAM_BLUE {
        return TEAM_RED
    }
    return team
}

/// Source: oracle/codemp/game/g_team.c:45
func TeamName(_ team: Int32) -> String {
    if team == TEAM_RED {
        return "RED"
    } else if team == TEAM_BLUE {
        return "BLUE"
    } else if team == TEAM_SPECTATOR {
        return "SPECTATOR"
    }
    return "FREE"
}

/// Source: oracle/codemp/game/g_team.c:55
func OtherTeamName(_ team: Int32) -> String {
    if team == TEAM_RED {
        return "BLUE"
    } else if team == TEAM_BLUE {
        return "RED"
    } else if team == TEAM_SPECTATOR {
        return "SPECTATOR"
    }
    return "FREE"
}

/// Source: oracle/codemp/game/g_team.c:65
func TeamColorString(_ team: Int32) -> String {
    if team == TEAM_RED {
        return S_COLOR_RED
    } else if team == TEAM_BLUE {
        return S_COLOR_BLUE
    } else if team == TEAM_SPECTATOR {
        return S_COLOR_YELLOW
    }
    return S_COLOR_WHITE
}

//plIndex used to print pl->client->pers.netname
//teamIndex used to print team name
/// Source: oracle/codemp/game/g_team.c:100
func PrintCTFMessage(_ plIndex: Int32, _ teamIndex: Int32, _ ctfMessage: Int32) {
    var te: Entity?
    // Raven assigns his own `plIndex` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var plIndex = plIndex
    // Raven assigns his own `teamIndex` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var teamIndex = teamIndex

    if plIndex == -1 {
        plIndex = MAX_CLIENTS + 1
    }
    if teamIndex == -1 {
        teamIndex = 50
    }

    te = G_TempEntity(vec3_origin, EV_CTFMESSAGE)
    te!.r.svFlags |= SVF_BROADCAST
    te!.s.eventParm = ctfMessage
    te!.s.trickedentindex = plIndex
    if ctfMessage == CTFMESSAGE_PLAYER_CAPTURED_FLAG {
        if teamIndex == TEAM_RED {
            te!.s.trickedentindex2 = TEAM_BLUE
        } else {
            te!.s.trickedentindex2 = TEAM_RED
        }
    } else {
        te!.s.trickedentindex2 = teamIndex
    }
}

/**
```
==============
AddTeamScore

 used for gametype > GT_TEAM
 for gametype GT_TEAM the level.teamScores is updated in AddScore in g_combat.c
==============
```
*/
/// Source: oracle/codemp/game/g_team.c:142
func AddTeamScore(_ origin: JKAShared.vec3_t, _ team: Int32, _ score: Int32) {
    var te: Entity?

    te = G_TempEntity(origin, EV_GLOBAL_TEAM_SOUND)
    te!.r.svFlags |= SVF_BROADCAST

    if team == TEAM_RED {
        if level.teamScores[TEAM_RED] + score == level.teamScores[TEAM_BLUE] {
            //teams are tied sound
            te!.s.eventParm = GTS_TEAMS_ARE_TIED
        } else if level.teamScores[TEAM_RED] <= level.teamScores[TEAM_BLUE] && level.teamScores[TEAM_RED] + score > level.teamScores[TEAM_BLUE] {
            // red took the lead sound
            te!.s.eventParm = GTS_REDTEAM_TOOK_LEAD
        } else {
            // red scored sound
            te!.s.eventParm = GTS_REDTEAM_SCORED
        }
    } else {
        if level.teamScores[TEAM_BLUE] + score == level.teamScores[TEAM_RED] {
            //teams are tied sound
            te!.s.eventParm = GTS_TEAMS_ARE_TIED
        } else if level.teamScores[TEAM_BLUE] <= level.teamScores[TEAM_RED] && level.teamScores[TEAM_BLUE] + score > level.teamScores[TEAM_RED] {
            // blue took the lead sound
            te!.s.eventParm = GTS_BLUETEAM_TOOK_LEAD
        } else {
            // blue scored sound
            te!.s.eventParm = GTS_BLUETEAM_SCORED
        }
    }
    level.teamScores[team] += score
}

/// Source: oracle/codemp/game/g_team.c:187
func OnSameTeam(_ ent1: Entity, _ ent2: Entity) -> Bool {
    if ent1.client == nil || ent2.client == nil {
        return false
    }

    if g_gametype.integer == GT_POWERDUEL {
        if ent1.client!.sess.duelTeam == ent2.client!.sess.duelTeam {
            return true
        }

        return false
    }

    if g_gametype.integer == GT_SINGLE_PLAYER {
        var ent1IsBot: Bool = false
        var ent2IsBot: Bool = false

        if (ent1.r.svFlags & SVF_BOT) != 0 {
            ent1IsBot = true
        }
        if (ent2.r.svFlags & SVF_BOT) != 0 {
            ent2IsBot = true
        }

        if (ent1IsBot && ent2IsBot) || (!ent1IsBot && !ent2IsBot) {
            return true
        }
        return false
    }

    if g_gametype.integer < GT_TEAM {
        return false
    }

    if ent1.s.eType == ET_NPC && ent1.s.NPC_class == CLASS_VEHICLE && ent1.client != nil && ent1.client!.sess.sessionTeam != TEAM_FREE && ent2.client != nil && ent1.client!.sess.sessionTeam == ent2.client!.sess.sessionTeam {
        return true
    }
    if ent2.s.eType == ET_NPC && ent2.s.NPC_class == CLASS_VEHICLE && ent2.client != nil && ent2.client!.sess.sessionTeam != TEAM_FREE && ent1.client != nil && ent2.client!.sess.sessionTeam == ent1.client!.sess.sessionTeam {
        return true
    }

    if ent1.client!.sess.sessionTeam == TEAM_FREE && ent2.client!.sess.sessionTeam == TEAM_FREE && ent1.s.eType == ET_NPC && ent2.s.eType == ET_NPC {
        //NPCs don't do normal team rules
        return false
    }

    if ent1.s.eType == ET_NPC && ent2.s.eType == ET_PLAYER {
        if G_CheckVehicleNPCTeamDamage(ent1) {
            //hit an NPC that is in a vehicle - a droid?
            if ent1.client!.sess.sessionTeam == ent2.client!.sess.sessionTeam || ent1.teamnodmg == ent2.client!.sess.sessionTeam {
                return true
            }
        }
        return false
    } else if ent1.s.eType == ET_PLAYER && ent2.s.eType == ET_NPC {
        return false
    }

    if ent1.client!.sess.sessionTeam == ent2.client!.sess.sessionTeam {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/g_team.c:281
func Team_SetFlagStatus(_ team: Int32, _ status: JKAMP.flagStatus_t) {
    var modified: Bool = false

    switch team {
    case TEAM_RED:
        if teamgame.redStatus != status {
            teamgame.redStatus = status
            modified = true
        }

    case TEAM_BLUE:
        if teamgame.blueStatus != status {
            teamgame.blueStatus = status
            modified = true
        }

    case TEAM_FREE:
        if teamgame.flagStatus != status {
            teamgame.flagStatus = status
            modified = true
        }

    default:
        break
    }

    if modified {
        var st = CharBuf(4)

        if g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY {
            st[0] = ctfFlagStatusRemap[teamgame.redStatus]
            st[1] = ctfFlagStatusRemap[teamgame.blueStatus]
            st[2] = 0
        }

        trap_SetConfigstring(CS_FLAGSTATUS, String(st))
    }
}

/// Source: oracle/codemp/game/g_team.c:320
func Team_CheckDroppedItem(_ dropped: Entity) {
    if dropped.item!.giTag == PW_REDFLAG {
        Team_SetFlagStatus(TEAM_RED, FLAG_DROPPED)
    } else if dropped.item!.giTag == PW_BLUEFLAG {
        Team_SetFlagStatus(TEAM_BLUE, FLAG_DROPPED)
    } else if dropped.item!.giTag == PW_NEUTRALFLAG {
        Team_SetFlagStatus(TEAM_FREE, FLAG_DROPPED)
    }
}

/**
```
================
Team_ForceGesture
================
```
*/
/// Source: oracle/codemp/game/g_team.c:337
func Team_ForceGesture(_ team: Int32) {
    var i: Int32
    var ent: Entity?

    i = 0
    while i < MAX_CLIENTS {
        ent = g_entities[i]
        if !ent!.inuse {
            i += 1
            continue
        }
        if ent!.client == nil {
            i += 1
            continue
        }
        if ent!.client!.sess.sessionTeam != team {
            i += 1
            continue
        }
        //
        ent!.flags |= FL_FORCE_GESTURE
        i += 1
    }
}

/**
```
================
Team_FragBonuses

Calculate the bonuses for flag defense, flag carrier defense, etc.
Note that bonuses are not cumulative.  You get one, they are in importance
order.
================
```
*/
/// Source: oracle/codemp/game/g_team.c:363
func Team_FragBonuses(_ targ: Entity, _ inflictor: Entity, _ attacker: Entity) {
    var i: Int32
    var entIndex: Int32 = 0
    let flag_pw: Int32
    let enemy_flag_pw: Int32
    let otherteam: Int32
    let tokens: Int32
    var flag: Entity?
    var carrierIndex: Int32 = 0
    var c: String
    var v1 = vec3_t()
    var v2 = vec3_t()
    var team: Int32

    // no bonus for fragging yourself or team mates
    if targ.client == nil || attacker.client == nil || targ == attacker || OnSameTeam(targ, attacker) {
        return
    }

    team = targ.client!.sess.sessionTeam
    otherteam = OtherTeam(targ.client!.sess.sessionTeam)
    if otherteam < 0 {
        return // whoever died isn't on a team
    }

    // same team, if the flag at base, check to he has the enemy flag
    if team == TEAM_RED {
        flag_pw = PW_REDFLAG
        enemy_flag_pw = PW_BLUEFLAG
    } else {
        flag_pw = PW_BLUEFLAG
        enemy_flag_pw = PW_REDFLAG
    }

    // did the attacker frag the flag carrier?
    tokens = 0
    if targ.client!.ps.powerups[enemy_flag_pw] != 0 {
        attacker.client!.pers.teamState.lastfraggedcarrier = Float(level.time)
        AddScore(attacker, targ.r.currentOrigin, CTF_FRAG_CARRIER_BONUS)
        attacker.client!.pers.teamState.fragcarrier += 1
        //PrintMsg(NULL, "%s" S_COLOR_WHITE " fragged %s's flag carrier!\n",
        //	attacker->client->pers.netname, TeamName(team));
        PrintCTFMessage(attacker.s.number, team, CTFMESSAGE_FRAGGED_FLAG_CARRIER)

        // the target had the flag, clear the hurt carrier
        // field on the other team
        i = 0
        while i < g_maxclients.integer {
            entIndex = i
            if g_entities[entIndex].inuse && g_entities[entIndex].client!.sess.sessionTeam == otherteam {
                g_entities[entIndex].client!.pers.teamState.lasthurtcarrier = 0
            }
            i += 1
        }
        return
    }

    // did the attacker frag a head carrier? other->client->ps.generic1
    if tokens != 0 {
        attacker.client!.pers.teamState.lastfraggedcarrier = Float(level.time)
        AddScore(attacker, targ.r.currentOrigin, CTF_FRAG_CARRIER_BONUS * tokens * tokens)
        attacker.client!.pers.teamState.fragcarrier += 1
        //PrintMsg(NULL, "%s" S_COLOR_WHITE " fragged %s's skull carrier!\n",
        //	attacker->client->pers.netname, TeamName(team));

        // the target had the flag, clear the hurt carrier
        // field on the other team
        i = 0
        while i < g_maxclients.integer {
            entIndex = i
            if g_entities[entIndex].inuse && g_entities[entIndex].client!.sess.sessionTeam == otherteam {
                g_entities[entIndex].client!.pers.teamState.lasthurtcarrier = 0
            }
            i += 1
        }
        return
    }

    if targ.client!.pers.teamState.lasthurtcarrier != 0 && level.time - targ.client!.pers.teamState.lasthurtcarrier < CTF_CARRIER_DANGER_PROTECT_TIMEOUT && attacker.client!.ps.powerups[flag_pw] == 0 {
        // attacker is on the same team as the flag carrier and
        // fragged a guy who hurt our flag carrier
        AddScore(attacker, targ.r.currentOrigin, CTF_CARRIER_DANGER_PROTECT_BONUS)

        attacker.client!.pers.teamState.carrierdefense += 1
        targ.client!.pers.teamState.lasthurtcarrier = 0

        attacker.client!.ps.persistant[PERS_DEFEND_COUNT] += 1
        team = attacker.client!.sess.sessionTeam
        attacker.client!.rewardTime = level.time + REWARD_SPRITE_TIME

        return
    }

    if targ.client!.pers.teamState.lasthurtcarrier != 0 && level.time - targ.client!.pers.teamState.lasthurtcarrier < CTF_CARRIER_DANGER_PROTECT_TIMEOUT {
        // attacker is on the same team as the skull carrier and
        AddScore(attacker, targ.r.currentOrigin, CTF_CARRIER_DANGER_PROTECT_BONUS)

        attacker.client!.pers.teamState.carrierdefense += 1
        targ.client!.pers.teamState.lasthurtcarrier = 0

        attacker.client!.ps.persistant[PERS_DEFEND_COUNT] += 1
        team = attacker.client!.sess.sessionTeam
        attacker.client!.rewardTime = level.time + REWARD_SPRITE_TIME

        return
    }

    // flag and flag carrier area defense bonuses

    // we have to find the flag and carrier entities

    // find the flag
    switch attacker.client!.sess.sessionTeam {
    case TEAM_RED:
        c = "team_CTF_redflag"

    case TEAM_BLUE:
        c = "team_CTF_blueflag"

    default:
        return
    }
    // find attacker's team's flag carrier
    i = 0
    while i < g_maxclients.integer {
        carrierIndex = i
        if g_entities[carrierIndex].inuse && g_entities[carrierIndex].client!.ps.powerups[flag_pw] != 0 {
            break
        }
        carrierIndex = 0
        i += 1
    }
    flag = nil
    flag = G_Find(flag, \.classname, c)
    while let f = flag {
        if (f.flags & FL_DROPPED_ITEM) == 0 {
            break
        }
        flag = G_Find(f, \.classname, c)
    }

    if flag == nil {
        return // can't find attacker's flag
    }

    // ok we have the attackers flag and a pointer to the carrier

    // check to see if we are defending the base's flag
    v1 = targ.r.currentOrigin - flag!.r.currentOrigin
    v2 = attacker.r.currentOrigin - flag!.r.currentOrigin

    if ((VectorLength(v1) < CTF_TARGET_PROTECT_RADIUS && trap_InPVS(flag!.r.currentOrigin, targ.r.currentOrigin)) || (VectorLength(v2) < CTF_TARGET_PROTECT_RADIUS && trap_InPVS(flag!.r.currentOrigin, attacker.r.currentOrigin))) && attacker.client!.sess.sessionTeam != targ.client!.sess.sessionTeam {
        // we defended the base flag
        AddScore(attacker, targ.r.currentOrigin, CTF_FLAG_DEFENSE_BONUS)
        attacker.client!.pers.teamState.basedefense += 1

        attacker.client!.ps.persistant[PERS_DEFEND_COUNT] += 1
        attacker.client!.rewardTime = level.time + REWARD_SPRITE_TIME

        return
    }

    if g_entities[carrierIndex] != nil && g_entities[carrierIndex] != attacker {
        v1 = targ.r.currentOrigin - g_entities[carrierIndex].r.currentOrigin
        v1 = attacker.r.currentOrigin - g_entities[carrierIndex].r.currentOrigin

        if ((VectorLength(v1) < CTF_ATTACKER_PROTECT_RADIUS && trap_InPVS(g_entities[carrierIndex].r.currentOrigin, targ.r.currentOrigin)) || (VectorLength(v2) < CTF_ATTACKER_PROTECT_RADIUS && trap_InPVS(g_entities[carrierIndex].r.currentOrigin, attacker.r.currentOrigin))) && attacker.client!.sess.sessionTeam != targ.client!.sess.sessionTeam {
            AddScore(attacker, targ.r.currentOrigin, CTF_CARRIER_PROTECT_BONUS)
            attacker.client!.pers.teamState.carrierdefense += 1

            attacker.client!.ps.persistant[PERS_DEFEND_COUNT] += 1
            attacker.client!.rewardTime = level.time + REWARD_SPRITE_TIME

            return
        }
    }
}

/**
```
================
Team_CheckHurtCarrier

Check to see if attacker hurt the flag carrier.  Needed when handing out bonuses for assistance to flag
carrier defense.
================
```
*/
/// Source: oracle/codemp/game/g_team.c:544
func Team_CheckHurtCarrier(_ targ: Entity, _ attacker: Entity) {
    let flag_pw: Int32

    if targ.client == nil || attacker.client == nil {
        return
    }

    if targ.client!.sess.sessionTeam == TEAM_RED {
        flag_pw = PW_BLUEFLAG
    } else {
        flag_pw = PW_REDFLAG
    }

    // flags
    if targ.client!.ps.powerups[flag_pw] != 0 && targ.client!.sess.sessionTeam != attacker.client!.sess.sessionTeam {
        attacker.client!.pers.teamState.lasthurtcarrier = Float(level.time)
    }

    // skulls
    if targ.client!.ps.generic1 != 0 && targ.client!.sess.sessionTeam != attacker.client!.sess.sessionTeam {
        attacker.client!.pers.teamState.lasthurtcarrier = Float(level.time)
    }
}

/// Source: oracle/codemp/game/g_team.c:568
func Team_ResetFlag(_ team: Int32) -> Entity? {
    var c: String
    var ent: Entity?
    var rent: Entity? = nil

    switch team {
    case TEAM_RED:
        c = "team_CTF_redflag"

    case TEAM_BLUE:
        c = "team_CTF_blueflag"

    case TEAM_FREE:
        c = "team_CTF_neutralflag"

    default:
        return nil
    }

    ent = nil
    while let next = G_Find(ent, \.classname, c) {
        ent = next
        if (ent!.flags & FL_DROPPED_ITEM) != 0 {
            G_FreeEntity(ent!)
        } else {
            rent = ent
            RespawnItem(ent!)
        }
    }

    Team_SetFlagStatus(team, FLAG_ATBASE)

    return rent
}

/// Source: oracle/codemp/game/g_team.c:601
func Team_ResetFlags() {
    if g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY {
        Team_ResetFlag(TEAM_RED)
        Team_ResetFlag(TEAM_BLUE)
    }
}

/// Source: oracle/codemp/game/g_team.c:608
func Team_ReturnFlagSound(_ ent: Entity, _ team: Int32) {
    var te: Entity?

    if ent == nil {
        G_Printf("Warning:  NULL passed to Team_ReturnFlagSound\n")
        return
    }

    te = G_TempEntity(ent.s.pos.trBase, EV_GLOBAL_TEAM_SOUND)
    if team == TEAM_BLUE {
        te!.s.eventParm = GTS_RED_RETURN
    } else {
        te!.s.eventParm = GTS_BLUE_RETURN
    }
    te!.r.svFlags |= SVF_BROADCAST
}

/// Source: oracle/codemp/game/g_team.c:626
func Team_TakeFlagSound(_ ent: Entity, _ team: Int32) {
    var te: Entity?

    if ent == nil {
        G_Printf("Warning:  NULL passed to Team_TakeFlagSound\n")
        return
    }

    // only play sound when the flag was at the base
    // or not picked up the last 10 seconds
    switch team {
    case TEAM_RED:
        if teamgame.blueStatus != FLAG_ATBASE {
            if teamgame.blueTakenTime > level.time - 10000 {
                return
            }
        }
        teamgame.blueTakenTime = level.time

    case TEAM_BLUE:
        if teamgame.redStatus != FLAG_ATBASE {
            if teamgame.redTakenTime > level.time - 10000 {
                return
            }
        }
        teamgame.redTakenTime = level.time

    default:
        break
    }

    te = G_TempEntity(ent.s.pos.trBase, EV_GLOBAL_TEAM_SOUND)
    if team == TEAM_BLUE {
        te!.s.eventParm = GTS_RED_TAKEN
    } else {
        te!.s.eventParm = GTS_BLUE_TAKEN
    }
    te!.r.svFlags |= SVF_BROADCAST
}

/// Source: oracle/codemp/game/g_team.c:664
func Team_CaptureFlagSound(_ ent: Entity, _ team: Int32) {
    var te: Entity?

    if ent == nil {
        G_Printf("Warning:  NULL passed to Team_CaptureFlagSound\n")
        return
    }

    te = G_TempEntity(ent.s.pos.trBase, EV_GLOBAL_TEAM_SOUND)
    if team == TEAM_BLUE {
        te!.s.eventParm = GTS_BLUE_CAPTURE
    } else {
        te!.s.eventParm = GTS_RED_CAPTURE
    }
    te!.r.svFlags |= SVF_BROADCAST
}

/// Source: oracle/codemp/game/g_team.c:682
func Team_ReturnFlag(_ team: Int32) {
    Team_ReturnFlagSound(Team_ResetFlag(team)!, team)
    if team == TEAM_FREE {
        //PrintMsg(NULL, "The flag has returned!\n" );
    } else {
        //flag should always have team in normal CTF
        //PrintMsg(NULL, "The %s flag has returned!\n", TeamName(team));
        PrintCTFMessage(-1, team, CTFMESSAGE_FLAG_RETURNED)
    }
}

/// Source: oracle/codemp/game/g_team.c:693
func Team_FreeEntity(_ ent: Entity) {
    if ent.item!.giTag == PW_REDFLAG {
        Team_ReturnFlag(TEAM_RED)
    } else if ent.item!.giTag == PW_BLUEFLAG {
        Team_ReturnFlag(TEAM_BLUE)
    } else if ent.item!.giTag == PW_NEUTRALFLAG {
        Team_ReturnFlag(TEAM_FREE)
    }
}

/**
```
==============
Team_DroppedFlagThink

Automatically set in Launch_Item if the item is one of the flags

Flags are unique in that if they are dropped, the base flag must be respawned when they time out
==============
```
*/
/// Source: oracle/codemp/game/g_team.c:714
func Team_DroppedFlagThink(_ ent: Entity) {
    var team: Int32 = TEAM_FREE

    if ent.item!.giTag == PW_REDFLAG {
        team = TEAM_RED
    } else if ent.item!.giTag == PW_BLUEFLAG {
        team = TEAM_BLUE
    } else if ent.item!.giTag == PW_NEUTRALFLAG {
        team = TEAM_FREE
    }

    Team_ReturnFlagSound(Team_ResetFlag(team)!, team)
    // Reset Flag will delete this entity
}

/**
```
==============
Team_DroppedFlagThink
==============
```
*/
/// Source: oracle/codemp/game/g_team.c:737
func Team_TouchOurFlag(_ ent: Entity, _ other: Entity, _ team: Int32) -> Int32 {
    var i: Int32
    var player: Entity?
    let cl: Client? = other.client
    let enemy_flag: Int32

    if cl!.sess.sessionTeam == TEAM_RED {
        enemy_flag = PW_BLUEFLAG
    } else {
        enemy_flag = PW_REDFLAG
    }

    if (ent.flags & FL_DROPPED_ITEM) != 0 {
        // hey, its not home.  return it by teleporting it back
        //PrintMsg( NULL, "%s" S_COLOR_WHITE " returned the %s flag!\n",
        //	cl->pers.netname, TeamName(team));
        PrintCTFMessage(other.s.number, team, CTFMESSAGE_PLAYER_RETURNED_FLAG)

        AddScore(other, ent.r.currentOrigin, CTF_RECOVERY_BONUS)
        other.client!.pers.teamState.flagrecovery += 1
        other.client!.pers.teamState.lastreturnedflag = Float(level.time)
        //ResetFlag will remove this entity!  We must return zero
        Team_ReturnFlagSound(Team_ResetFlag(team)!, team)
        return 0
    }

    // the flag is at home base.  if the player has the enemy
    // flag, he's just won!
    if cl!.ps.powerups[enemy_flag] == 0 {
        return 0 // We don't have the flag
    }
    //PrintMsg( NULL, "%s" S_COLOR_WHITE " captured the %s flag!\n", cl->pers.netname, TeamName(OtherTeam(team)));
    PrintCTFMessage(other.s.number, team, CTFMESSAGE_PLAYER_CAPTURED_FLAG)

    cl!.ps.powerups[enemy_flag] = 0

    teamgame.last_flag_capture = Float(level.time)
    teamgame.last_capture_team = team

    // Increase the team's score
    AddTeamScore(ent.s.pos.trBase, other.client!.sess.sessionTeam, 1)
    //	Team_ForceGesture(other->client->sess.sessionTeam);
    //rww - don't really want to do this now. Mainly because performing a gesture disables your upper torso animations until it's done and you can't fire

    other.client!.pers.teamState.captures += 1
    other.client!.rewardTime = level.time + REWARD_SPRITE_TIME
    other.client!.ps.persistant[PERS_CAPTURES] += 1

    // other gets another 10 frag bonus
    AddScore(other, ent.r.currentOrigin, CTF_CAPTURE_BONUS)

    Team_CaptureFlagSound(ent, team)

    // Ok, let's do the player loop, hand out the bonuses
    i = 0
    while i < g_maxclients.integer {
        player = g_entities[i]
        if !player!.inuse {
            i += 1
            continue
        }

        if player!.client!.sess.sessionTeam != cl!.sess.sessionTeam {
            player!.client!.pers.teamState.lasthurtcarrier = -5
        } else if player!.client!.sess.sessionTeam == cl!.sess.sessionTeam {
            if player != other {
                AddScore(player!, ent.r.currentOrigin, CTF_TEAM_BONUS)
            }
            // award extra points for capture assists
            if player!.client!.pers.teamState.lastreturnedflag + CTF_RETURN_FLAG_ASSIST_TIMEOUT > level.time {
                AddScore(player!, ent.r.currentOrigin, CTF_RETURN_FLAG_ASSIST_BONUS)
                other.client!.pers.teamState.assists += 1

                player!.client!.ps.persistant[PERS_ASSIST_COUNT] += 1
                player!.client!.rewardTime = level.time + REWARD_SPRITE_TIME
            } else if player!.client!.pers.teamState.lastfraggedcarrier + CTF_FRAG_CARRIER_ASSIST_TIMEOUT > level.time {
                AddScore(player!, ent.r.currentOrigin, CTF_FRAG_CARRIER_ASSIST_BONUS)
                other.client!.pers.teamState.assists += 1
                player!.client!.ps.persistant[PERS_ASSIST_COUNT] += 1
                player!.client!.rewardTime = level.time + REWARD_SPRITE_TIME
            }
        }
        i += 1
    }
    Team_ResetFlags()

    CalculateRanks()

    return 0 // Do not respawn this automatically
}

/// Source: oracle/codemp/game/g_team.c:827
func Team_TouchEnemyFlag(_ ent: Entity, _ other: Entity, _ team: Int32) -> Int32 {
    let cl: Client? = other.client

    //PrintMsg (NULL, "%s" S_COLOR_WHITE " got the %s flag!\n",
    //	other->client->pers.netname, TeamName(team));
    PrintCTFMessage(other.s.number, team, CTFMESSAGE_PLAYER_GOT_FLAG)

    if team == TEAM_RED {
        cl!.ps.powerups[PW_REDFLAG] = INT_MAX // flags never expire
    } else {
        cl!.ps.powerups[PW_BLUEFLAG] = INT_MAX // flags never expire
    }

    Team_SetFlagStatus(team, FLAG_TAKEN)

    AddScore(other, ent.r.currentOrigin, CTF_FLAG_BONUS)
    cl!.pers.teamState.flagsince = Float(level.time)
    Team_TakeFlagSound(ent, team)

    return -1 // Do not respawn this automatically, but do delete it if it was FL_DROPPED
}

/// Source: oracle/codemp/game/g_team.c:848
func Pickup_Team(_ ent: Entity, _ other: Entity) -> Int32 {
    var team: Int32
    let cl: Client? = other.client

    // figure out what team this flag is
    if strcmp(ent.classname!, "team_CTF_redflag") == 0 {
        team = TEAM_RED
    } else if strcmp(ent.classname!, "team_CTF_blueflag") == 0 {
        team = TEAM_BLUE
    } else if strcmp(ent.classname!, "team_CTF_neutralflag") == 0 {
        team = TEAM_FREE
    } else {
        //		PrintMsg ( other, "Don't know what team the flag is on.\n");
        return 0
    }
    // GT_CTF
    if team == cl!.sess.sessionTeam {
        return Team_TouchOurFlag(ent, other, team)
    }
    return Team_TouchEnemyFlag(ent, other, team)
}

/**
```
===========
Team_GetLocation

Report a location for the player. Uses placed nearby target_location entities
============
```
*/
/// Source: oracle/codemp/game/g_team.c:880
func Team_GetLocation(_ ent: Entity) -> Entity? {
    var eloc: Entity?
    var best: Entity?
    var bestlen: Float
    var len: Float
    var origin = vec3_t()

    best = nil
    bestlen = Float(3 * 8192.0 * 8192.0)

    origin = ent.r.currentOrigin

    eloc = level.locationHead
    while eloc != nil {
        len = (origin[0] - eloc!.r.currentOrigin[0]) * (origin[0] - eloc!.r.currentOrigin[0]) + (origin[1] - eloc!.r.currentOrigin[1]) * (origin[1] - eloc!.r.currentOrigin[1]) + (origin[2] - eloc!.r.currentOrigin[2]) * (origin[2] - eloc!.r.currentOrigin[2])

        if len > bestlen {
            eloc = eloc!.nextTrain
            continue
        }

        if !trap_InPVS(origin, eloc!.r.currentOrigin) {
            eloc = eloc!.nextTrain
            continue
        }

        bestlen = len
        best = eloc
        eloc = eloc!.nextTrain
    }

    return best
}

/**
```
===========
Team_GetLocation

Report a location for the player. Uses placed nearby target_location entities
============
```
*/
/// Source: oracle/codemp/game/g_team.c:919
func Team_GetLocationMsg(_ ent: Entity, _ loc: inout JKAShared.CharBuf, _ loclen: Int32) -> Bool {
    var best: Entity?

    best = Team_GetLocation(ent)

    if best == nil {
        return false
    }

    if best!.count != 0 {
        if best!.count < 0 {
            best!.count = 0
        }
        if best!.count > 7 {
            best!.count = 7
        }
        Com_sprintf(&loc, loclen, "%c%c%s" + S_COLOR_WHITE, Q_COLOR_ESCAPE, best!.count + Int32(ascii: "0"), best!.message!)
    } else {
        Com_sprintf(&loc, loclen, "%s", best!.message!)
    }

    return true
}

/// Source: oracle/codemp/game/g_team.c:951
func SelectRandomTeamSpawnPoint(_ teamstate: Int32, _ team: JKAMP.team_t, _ siegeClass: Int32) -> Entity? {
    var spot: Entity?
    var count: Int32
    var selection: Int32
    var spots = [Entity?](repeating: nil, count: Int(MAX_TEAM_SPAWN_POINTS))
    var classname: String
    var mustBeEnabled: Bool = false

    if g_gametype.integer == GT_SIEGE {
        if team == SIEGETEAM_TEAM1 {
            classname = "info_player_siegeteam1"
        } else {
            classname = "info_player_siegeteam2"
        }

        mustBeEnabled = true //siege spawn points need to be "enabled" to be used (because multiple spawnpoint sets can be placed at once)
    } else {
        if teamstate == TEAM_BEGIN {
            if team == TEAM_RED {
                classname = "team_CTF_redplayer"
            } else if team == TEAM_BLUE {
                classname = "team_CTF_blueplayer"
            } else {
                return nil
            }
        } else {
            if team == TEAM_RED {
                classname = "team_CTF_redspawn"
            } else if team == TEAM_BLUE {
                classname = "team_CTF_bluespawn"
            } else {
                return nil
            }
        }
    }
    count = 0

    spot = nil

    while let next = G_Find(spot, \.classname, classname) {
        spot = next
        if SpotWouldTelefrag(spot!) {
            continue
        }

        if mustBeEnabled && spot!.genericValue1 == 0 {
            //siege point that's not enabled, can't use it
            continue
        }

        spots[count] = spot
        count += 1
        if count == MAX_TEAM_SPAWN_POINTS {
            break
        }
    }

    if count == 0 {
        // no spots that won't telefrag
        return G_Find(nil, \.classname, classname)
    }

    if g_gametype.integer == GT_SIEGE && siegeClass >= 0 && !bgSiegeClasses[siegeClass].name.isEmpty {
        //out of the spots found, see if any have an idealclass to match our class name
        var classSpots = [Entity?](repeating: nil, count: Int(MAX_TEAM_SPAWN_POINTS))
        var classCount: Int32 = 0
        var i: Int32 = 0

        while i < count {
            if spots[i] != nil && spots[i]!.idealclass != nil && !spots[i]!.idealclass!.isEmpty && Q_stricmp(spots[i]!.idealclass!, bgSiegeClasses[siegeClass].name) == 0 {
                //this spot's idealclass matches the class name
                classSpots[classCount] = spots[i]
                classCount += 1
            }
            i += 1
        }

        if classCount > 0 {
            //found at least one
            // The SDK also declares `rand`, so the call names the bg module.
            selection = JKAMP_BG.rand() % classCount
            return spots[selection]
        }
    }

    // The SDK also declares `rand`, so the call names the bg module.
    selection = JKAMP_BG.rand() % count
    return spots[selection]
}

/**
```
===========
SelectCTFSpawnPoint

============
```
*/
/// Source: oracle/codemp/game/g_team.c:1049
func SelectCTFSpawnPoint(_ team: JKAMP.team_t, _ teamstate: Int32, _ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t) -> Entity? {
    var spot: Entity?

    spot = SelectRandomTeamSpawnPoint(teamstate, team, -1)

    if spot == nil {
        return SelectSpawnPoint(vec3_origin, &origin, &angles, team)
    }

    origin = spot!.s.origin
    origin[2] += 9
    angles = spot!.s.angles

    return spot
}

/**
```
===========
SelectSiegeSpawnPoint

============
```
*/
/// Source: oracle/codemp/game/g_team.c:1071
func SelectSiegeSpawnPoint(_ siegeClass: Int32, _ team: JKAMP.team_t, _ teamstate: Int32, _ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t) -> Entity? {
    var spot: Entity?

    spot = SelectRandomTeamSpawnPoint(teamstate, team, siegeClass)

    if spot == nil {
        return SelectSpawnPoint(vec3_origin, &origin, &angles, team)
    }

    origin = spot!.s.origin
    origin[2] += 9
    angles = spot!.s.angles

    return spot
}

/// Source: oracle/codemp/game/g_team.c:1089
private func SortClients(_ a: Int32, _ b: Int32) -> Int32 {
    return a - b
}

/**
```
==================
TeamplayLocationsMessage

Format:
	clientNum location health armor weapon powerups

==================
```
*/
/// Source: oracle/codemp/game/g_team.c:1103
func TeamplayInfoMessage(_ ent: Entity) {
    var entry = CharBuf(1024)
    var string = CharBuf(8192)
    var stringlength: Int32
    var i: Int32
    var j: Int32
    var playerIndex: Int32 = 0
    var cnt: Int32
    var h: Int32
    var a: Int32
    var clients: [Int32] = [Int32](repeating: 0, count: 32)

    if !ent.client!.pers.teamInfo {
        return
    }

    // figure out what client should be on the display
    // we are limited to 8, but we want to use the top eight players
    // but in client order (so they don't keep changing position on the overlay)
    i = 0
    cnt = 0
    while i < g_maxclients.integer && cnt < TEAM_MAXOVERLAY {
        playerIndex = level.sortedClients[i]
        if g_entities[playerIndex].inuse && g_entities[playerIndex].client!.sess.sessionTeam == ent.client!.sess.sessionTeam {
            // Port-note: A ++ inside an expression.
            // Raven wrote: clients[cnt++] = level.sortedClients[i]
            portMissing("TeamplayInfoMessage", source: "oracle/codemp/game/g_team.c:1103")
        }
        i += 1
    }

    // We have the top eight players, sort them by clientNum
    qsort(&clients, cnt, SortClients)

    // send the latest information on all clients
    string[0] = 0
    stringlength = 0

    i = 0
    cnt = 0
    while i < g_maxclients.integer && cnt < TEAM_MAXOVERLAY {
        playerIndex = i
        if g_entities[playerIndex].inuse && g_entities[playerIndex].client!.sess.sessionTeam == ent.client!.sess.sessionTeam {
            h = g_entities[playerIndex].client!.ps.stats[STAT_HEALTH]
            a = g_entities[playerIndex].client!.ps.stats[STAT_ARMOR]
            if h < 0 {
                h = 0
            }
            if a < 0 {
                a = 0
            }

            Com_sprintf(&entry, Int32((entry).count), " %i %i %i %i %i %i", i, g_entities[playerIndex].client!.pers.teamState.location, h, a, g_entities[playerIndex].client!.ps.weapon, g_entities[playerIndex].s.powerups)
            j = strlen(entry)
            if stringlength + j > Int32((string).count) {
                break
            }
            strcpy(&string + stringlength, entry)
            stringlength += j
            cnt += 1
        }
        i += 1
    }

    trap_SendServerCommand(ent.s.number, va("tinfo %i %s", cnt, string))
}

/// Source: oracle/codemp/game/g_team.c:1161
func CheckTeamStatus() {
    var i: Int32
    var loc: Entity?
    var entIndex: Int32 = 0

    if level.time - level.lastTeamLocationTime > TEAM_LOCATION_UPDATE_TIME {
        level.lastTeamLocationTime = level.time

        i = 0
        while i < g_maxclients.integer {
            entIndex = i

            if g_entities[entIndex].client == nil {
                i += 1
                continue
            }

            if g_entities[entIndex].client!.pers.connected != CON_CONNECTED {
                i += 1
                continue
            }

            if g_entities[entIndex].inuse && (g_entities[entIndex].client!.sess.sessionTeam == TEAM_RED || g_entities[entIndex].client!.sess.sessionTeam == TEAM_BLUE) {
                loc = Team_GetLocation(g_entities[entIndex])
                if loc != nil {
                    g_entities[entIndex].client!.pers.teamState.location = loc!.health
                } else {
                    g_entities[entIndex].client!.pers.teamState.location = 0
                }
            }
            i += 1
        }

        i = 0
        while i < g_maxclients.integer {
            entIndex = i

            if g_entities[entIndex].client!.pers.connected != CON_CONNECTED {
                i += 1
                continue
            }

            if g_entities[entIndex].inuse && (g_entities[entIndex].client!.sess.sessionTeam == TEAM_RED || g_entities[entIndex].client!.sess.sessionTeam == TEAM_BLUE) {
                TeamplayInfoMessage(g_entities[entIndex])
            }
            i += 1
        }
    }
}

/**
```
QUAKED team_CTF_redplayer (1 0 0) (-16 -16 -16) (16 16 32)
Only in CTF games.  Red players spawn here at game start.
```
*/
/// Source: oracle/codemp/game/g_team.c:1209
func SP_team_CTF_redplayer(_ ent: Entity) {
}

/**
```
QUAKED team_CTF_blueplayer (0 0 1) (-16 -16 -16) (16 16 32)
Only in CTF games.  Blue players spawn here at game start.
```
*/
/// Source: oracle/codemp/game/g_team.c:1216
func SP_team_CTF_blueplayer(_ ent: Entity) {
}

/**
```
QUAKED team_CTF_redspawn (1 0 0) (-16 -16 -24) (16 16 32)
potential spawning position for red team in CTF games.
Targets will be fired when someone spawns in on them.
```
*/
/// Source: oracle/codemp/game/g_team.c:1224
func SP_team_CTF_redspawn(_ ent: Entity) {
}

/**
```
QUAKED team_CTF_bluespawn (0 0 1) (-16 -16 -24) (16 16 32)
potential spawning position for blue team in CTF games.
Targets will be fired when someone spawns in on them.
```
*/
/// Source: oracle/codemp/game/g_team.c:1231
func SP_team_CTF_bluespawn(_ ent: Entity) {
}
