import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/ai_main.c:41
let MAX_PATH = 144 as Int32

/// Source: oracle/codemp/game/ai_main.c:43
let BOT_THINK_TIME = 0 as Int32

/// Source: oracle/codemp/game/ai_main.c:46
var botstates: Slots<BotState?> { world.storage.botstates }

/// Source: oracle/codemp/game/ai_main.c:48
var numbots: Int32 {
    get { world.variables.numbots }
    set { world.variables.numbots = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:50
// Raven wrote: float floattime
let floattime: Float = 0

/// Source: oracle/codemp/game/ai_main.c:52
var regularupdate_time: Float {
    get { world.variables.regularupdate_time }
    set { world.variables.regularupdate_time = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:59
var gBotEventTracker: Slots<Boteventtracker> { world.storage.gBotEventTracker }

/// Source: oracle/codemp/game/ai_main.c:62
var bot_forcepowers: JKAMP.VmCvar { world.storage.bot_forcepowers }

/// Source: oracle/codemp/game/ai_main.c:63
var bot_forgimmick: JKAMP.VmCvar { world.storage.bot_forgimmick }

/// Source: oracle/codemp/game/ai_main.c:64
var bot_honorableduelacceptance: JKAMP.VmCvar { world.storage.bot_honorableduelacceptance }

/// Source: oracle/codemp/game/ai_main.c:65
var bot_pvstype: JKAMP.VmCvar { world.storage.bot_pvstype }

/// Source: oracle/codemp/game/ai_main.c:66
var bot_normgpath: JKAMP.VmCvar { world.storage.bot_normgpath }

/// Source: oracle/codemp/game/ai_main.c:68
var bot_getinthecarrr: JKAMP.VmCvar { world.storage.bot_getinthecarrr }

/// Source: oracle/codemp/game/ai_main.c:76
var bot_attachments: JKAMP.VmCvar { world.storage.bot_attachments }

/// Source: oracle/codemp/game/ai_main.c:77
var bot_camp: JKAMP.VmCvar { world.storage.bot_camp }

/// Source: oracle/codemp/game/ai_main.c:79
var bot_wp_info: JKAMP.VmCvar { world.storage.bot_wp_info }

/// Source: oracle/codemp/game/ai_main.c:80
var bot_wp_edit: JKAMP.VmCvar { world.storage.bot_wp_edit }

/// Source: oracle/codemp/game/ai_main.c:81
var bot_wp_clearweight: JKAMP.VmCvar { world.storage.bot_wp_clearweight }

/// Source: oracle/codemp/game/ai_main.c:82
var bot_wp_distconnect: JKAMP.VmCvar { world.storage.bot_wp_distconnect }

/// Source: oracle/codemp/game/ai_main.c:83
var bot_wp_visconnect: JKAMP.VmCvar { world.storage.bot_wp_visconnect }

/// Source: oracle/codemp/game/ai_main.c:86
var flagRed: JKAMP.Wpobject? {
    get { world.variables.flagRed }
    set { world.variables.flagRed = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:87
var oFlagRed: JKAMP.Wpobject? {
    get { world.variables.oFlagRed }
    set { world.variables.oFlagRed = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:88
var flagBlue: JKAMP.Wpobject? {
    get { world.variables.flagBlue }
    set { world.variables.flagBlue = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:89
var oFlagBlue: JKAMP.Wpobject? {
    get { world.variables.oFlagBlue }
    set { world.variables.oFlagBlue = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:91
var eFlagRed: Entity? {
    get { world.variables.eFlagRed }
    set { world.variables.eFlagRed = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:92
var droppedRedFlag: Entity? {
    get { world.variables.droppedRedFlag }
    set { world.variables.droppedRedFlag = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:93
var eFlagBlue: Entity? {
    get { world.variables.eFlagBlue }
    set { world.variables.eFlagBlue = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:94
var droppedBlueFlag: Entity? {
    get { world.variables.droppedBlueFlag }
    set { world.variables.droppedBlueFlag = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:96
// Raven wrote: char *ctfStateNames[]
let ctfStateNames: [String] = { () -> [String] in portMissing("ctfStateNames", source: "oracle/codemp/game/ai_main.c:96") }()

/// Source: oracle/codemp/game/ai_main.c:106
/// Raven's data table, a hand property of `GameWorld`.
var ctfStateDescriptions: [String] {
    get { world.ctfStateDescriptions }
    set { world.ctfStateDescriptions = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:115
/// Raven's data table, a hand property of `GameWorld`.
var siegeStateDescriptions: [String] {
    get { world.siegeStateDescriptions }
    set { world.siegeStateDescriptions = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:121
/// Raven's data table, a hand property of `GameWorld`.
var teamplayStateDescriptions: [String] {
    get { world.teamplayStateDescriptions }
    set { world.teamplayStateDescriptions = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:1551
let STRAFEAROUND_RIGHT = 1 as Int32

/// Source: oracle/codemp/game/ai_main.c:1552
let STRAFEAROUND_LEFT = 2 as Int32

/// Source: oracle/codemp/game/ai_main.c:7485
var gUpdateVars: Int32 {
    get { world.variables.gUpdateVars }
    set { world.variables.gUpdateVars = newValue }
}

/// Source: oracle/codemp/game/ai_main.c:128
func BotStraightTPOrderCheck(_ ent: Entity, _ ordernum: Int32, _ bs: BotState) {
    switch ordernum {
    case 0:
        if bs.squadLeader == ent {
            bs.teamplayState = 0
            bs.squadLeader = nil
        }

    case TEAMPLAYSTATE_FOLLOWING:
        bs.teamplayState = ordernum
        bs.isSquadLeader = 0
        bs.squadLeader = ent
        bs.wpDestSwitchTime = 0

    case TEAMPLAYSTATE_ASSISTING:
        bs.teamplayState = ordernum
        bs.isSquadLeader = 0
        bs.squadLeader = ent
        bs.wpDestSwitchTime = 0

    default:
        bs.teamplayState = ordernum
    }
}

/// Source: oracle/codemp/game/ai_main.c:157
func BotSelectWeapon(_ client: Int32, _ weapon: Int32) {
    if weapon <= WP_NONE {
        //		assert(0);
        return
    }
    trap_EA_SelectWeapon(client, weapon)
}

/// Source: oracle/codemp/game/ai_main.c:167
func BotReportStatus(_ bs: BotState) {
    if g_gametype.integer == GT_TEAM {
        trap_EA_SayTeam(bs.client, teamplayStateDescriptions[bs.teamplayState])
    } else if g_gametype.integer == GT_SIEGE {
        trap_EA_SayTeam(bs.client, siegeStateDescriptions[bs.siegeState])
    } else if g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY {
        trap_EA_SayTeam(bs.client, ctfStateDescriptions[bs.ctfState])
    }
}

//accept a team order from a player
/// Source: oracle/codemp/game/ai_main.c:184
func BotOrder(_ ent: Entity, _ clientnum: Int32, _ ordernum: Int32) {
    var stateMin: Int32 = 0
    var stateMax: Int32 = 0
    var i: Int32 = 0

    if ent.client == nil || !ent.client!.sess.teamLeader {
        return
    }

    if clientnum != -1 && botstates[clientnum] == nil {
        return
    }

    if clientnum != -1 && !OnSameTeam(ent, g_entities[clientnum]) {
        return
    }

    if g_gametype.integer != GT_CTF && g_gametype.integer != GT_CTY && g_gametype.integer != GT_SIEGE && g_gametype.integer != GT_TEAM {
        return
    }

    if g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY {
        stateMin = CTFSTATE_NONE
        stateMax = CTFSTATE_MAXCTFSTATES
    } else if g_gametype.integer == GT_SIEGE {
        stateMin = SIEGESTATE_NONE
        stateMax = SIEGESTATE_MAXSIEGESTATES
    } else if g_gametype.integer == GT_TEAM {
        stateMin = TEAMPLAYSTATE_NONE
        stateMax = TEAMPLAYSTATE_MAXTPSTATES
    }

    if (ordernum < stateMin && ordernum != -1) || ordernum >= stateMax {
        return
    }

    if clientnum != -1 {
        if ordernum == -1 {
            BotReportStatus(botstates[clientnum]!)
        } else {
            BotStraightTPOrderCheck(ent, ordernum, botstates[clientnum]!)
            botstates[clientnum]!.state_Forced = ordernum
            botstates[clientnum]!.chatObject = ent
            botstates[clientnum]!.chatAltObject = nil
            if BotDoChat(botstates[clientnum]!, "OrderAccepted", 1) != 0 {
                botstates[clientnum]!.chatTeam = 1
            }
        }
    } else {
        while i < MAX_CLIENTS {
            if botstates[i] != nil && OnSameTeam(ent, g_entities[i]) {
                if ordernum == -1 {
                    BotReportStatus(botstates[i]!)
                } else {
                    BotStraightTPOrderCheck(ent, ordernum, botstates[i]!)
                    botstates[i]!.state_Forced = ordernum
                    botstates[i]!.chatObject = ent
                    botstates[i]!.chatAltObject = nil
                    if BotDoChat(botstates[i]!, "OrderAccepted", 0) != 0 {
                        botstates[i]!.chatTeam = 1
                    }
                }
            }

            i += 1
        }
    }
}

//See if bot is mindtricked by the client in question
/// Source: oracle/codemp/game/ai_main.c:279
func BotMindTricked(_ botClient: Int32, _ enemyClient: Int32) -> Int32 {
    var fd: Forcedata?

    if g_entities[enemyClient].client == nil {
        return 0
    }

    fd = g_entities[enemyClient].client!.ps.fd

    if fd == nil {
        return 0
    }

    if botClient > 47 {
        if (fd!.forceMindtrickTargetIndex4 & (1 << (botClient - 48))) != 0 {
            return 1
        }
    } else if botClient > 31 {
        if (fd!.forceMindtrickTargetIndex3 & (1 << (botClient - 32))) != 0 {
            return 1
        }
    } else if botClient > 15 {
        if (fd!.forceMindtrickTargetIndex2 & (1 << (botClient - 16))) != 0 {
            return 1
        }
    } else {
        if (fd!.forceMindtrickTargetIndex & (1 << botClient)) != 0 {
            return 1
        }
    }

    return 0
}

/// Source: oracle/codemp/game/ai_main.c:332
func BotAI_Print(_ type: Int32, _ fmt: String, _ args: any JKAShared.FormatArg...) {
    return
}

/// Source: oracle/codemp/game/ai_main.c:336
func IsTeamplay() -> Int32 {
    if g_gametype.integer < GT_TEAM {
        return 0
    }

    return 1
}

/**
```
==================
BotAI_GetClientState
==================
```
*/
/// Source: oracle/codemp/game/ai_main.c:351
func BotAI_GetClientState(_ clientNum: Int32, _ state: JKAMP.PlayerState) -> Int32 {
    var ent: Entity?

    ent = g_entities[clientNum]
    if !ent!.inuse {
        return 0
    }
    if ent!.client == nil {
        return 0
    }

    state.copy(from: ent!.client!.ps)
    return 1
}

/**
```
==================
BotAI_GetEntityState
==================
```
*/
/// Source: oracle/codemp/game/ai_main.c:371
func BotAI_GetEntityState(_ entityNum: Int32, _ state: JKAMP.EntityState) -> Int32 {
    var ent: Entity?

    ent = g_entities[entityNum]
    state.clear()
    if !ent!.inuse {
        return 0
    }
    if !ent!.r.linked {
        return 0
    }
    if (ent!.r.svFlags & SVF_NOCLIENT) != 0 {
        return 0
    }
    state.copy(from: ent!.s)
    return 1
}

/**
```
==================
BotAI_GetSnapshotEntity
==================
```
*/
/// Source: oracle/codemp/game/ai_main.c:388
func BotAI_GetSnapshotEntity(_ clientNum: Int32, _ sequence: Int32, _ state: JKAMP.EntityState) -> Int32 {
    let entNum: Int32

    entNum = trap_BotGetSnapshotEntity(clientNum, sequence)
    if entNum == -1 {
        state.clear()
        return -1
    }

    BotAI_GetEntityState(entNum, state)

    return sequence + 1
}

/**
```
==============
BotEntityInfo
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:407
// Raven wrote: void BotEntityInfo(int entnum, aas_entityinfo_t *info)
// Not ported: no caller in the module, and the botlib record it forwards belongs to the engine, which the module reaches through trap_AAS_EntityInfo alone. A view over aas_entityinfo_t of be_aas.h is the fallback if a ported body calls it.

/**
```
==============
NumBots
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:416
func NumBots() -> Int32 {
    return numbots
}

/**
```
==============
AngleDifference
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:425
func AngleDifference(_ ang1: Float, _ ang2: Float) -> Float {
    var diff: Float

    diff = ang1 - ang2
    if ang1 > ang2 {
        if Double(diff) > 180.0 {
            diff = Float(Double(diff) - 360.0)
        }
    } else {
        if Double(diff) < -180.0 {
            diff = Float(Double(diff) + 360.0)
        }
    }
    return diff
}

/**
```
==============
BotChangeViewAngle
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:443
func BotChangeViewAngle(_ angle: Float, _ ideal_angle: Float, _ speed: Float) -> Float {
    var move: Float
    // Raven assigns his own `angle` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var angle = angle
    // Raven assigns his own `ideal_angle` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var ideal_angle = ideal_angle

    angle = AngleMod(angle)
    ideal_angle = AngleMod(ideal_angle)
    if angle == ideal_angle {
        return angle
    }
    move = ideal_angle - angle
    if ideal_angle > angle {
        if Double(move) > 180.0 {
            move = Float(Double(move) - 360.0)
        }
    } else {
        if Double(move) < -180.0 {
            move = Float(Double(move) + 360.0)
        }
    }
    if move > 0 {
        if move > speed {
            move = speed
        }
    } else {
        if move < -speed {
            move = -speed
        }
    }
    return AngleMod(angle + move)
}

/**
```
==============
BotChangeViewAngles
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:470
func BotChangeViewAngles(_ bs: BotState, _ thinktime: Float) {
    var diff: Float
    var factor: Float
    var maxchange: Float
    var anglespeed: Float
    var disired_speed: Float
    var i: Int32

    if bs.ideal_viewangles[PITCH] > 180 {
        bs.ideal_viewangles[PITCH] -= 360
    }

    if bs.currentEnemy != nil && bs.frame_Enemy_Vis != 0 {
        if bs.settings.skill <= 1 {
            factor = (bs.skills.turnspeed_combat * 0.4) * bs.settings.skill
        } else if bs.settings.skill <= 2 {
            factor = (bs.skills.turnspeed_combat * 0.6) * bs.settings.skill
        } else if bs.settings.skill <= 3 {
            factor = (bs.skills.turnspeed_combat * 0.8) * bs.settings.skill
        } else {
            factor = bs.skills.turnspeed_combat * bs.settings.skill
        }
    } else {
        factor = bs.skills.turnspeed
    }

    if factor > 1 {
        factor = 1
    }
    if Double(factor) < 0.001 {
        factor = 0.001
    }

    maxchange = bs.skills.maxturn

    //if (maxchange < 240) maxchange = 240;
    maxchange *= thinktime
    i = 0
    while i < 2 {
        bs.viewangles[i] = AngleMod(bs.viewangles[i])
        bs.ideal_viewangles[i] = AngleMod(bs.ideal_viewangles[i])
        diff = AngleDifference(bs.viewangles[i], bs.ideal_viewangles[i])
        disired_speed = diff * factor
        bs.viewanglespeed[i] += (bs.viewanglespeed[i] - disired_speed)
        if bs.viewanglespeed[i] > 180 {
            bs.viewanglespeed[i] = maxchange
        }
        if bs.viewanglespeed[i] < -180 {
            bs.viewanglespeed[i] = -maxchange
        }
        anglespeed = bs.viewanglespeed[i]
        if anglespeed > maxchange {
            anglespeed = maxchange
        }
        if anglespeed < -maxchange {
            anglespeed = -maxchange
        }
        bs.viewangles[i] += anglespeed
        bs.viewangles[i] = AngleMod(bs.viewangles[i])
        bs.viewanglespeed[i] = Float(Double(bs.viewanglespeed[i]) * 0.45 * Double(1 - factor))
        i += 1
    }
    if bs.viewangles[PITCH] > 180 {
        bs.viewangles[PITCH] -= 360
    }
    trap_EA_View(bs.client, &bs.viewangles)
}

/**
```
==============
BotInputToUserCommand
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:537
func BotInputToUserCommand(_ bi: BotInput, _ ucmd: JKAMP.Usercmd, _ delta_angles: [Int32], _ time: Int32, _ useTime: Int32) {
    var angles = vec3_t()
    var forward = vec3_t()
    var right = vec3_t()
    var temp: Int16
    var j: Int32

    //clear the whole structure
    ucmd.clear()
    //
    //Com_Printf("dir = %f %f %f speed = %f\n", bi->dir[0], bi->dir[1], bi->dir[2], bi->speed);
    //the duration for the user command in milli seconds
    ucmd.serverTime = time
    //
    if (bi.actionflags & ACTION_DELAYEDJUMP) != 0 {
        bi.actionflags |= ACTION_JUMP
        bi.actionflags &= ~ACTION_DELAYEDJUMP
    }
    //set the buttons
    if (bi.actionflags & ACTION_RESPAWN) != 0 {
        ucmd.buttons = BUTTON_ATTACK
    }
    if (bi.actionflags & ACTION_ATTACK) != 0 {
        ucmd.buttons |= BUTTON_ATTACK
    }
    if (bi.actionflags & ACTION_ALT_ATTACK) != 0 {
        ucmd.buttons |= BUTTON_ALT_ATTACK
    }
    //	if (bi->actionflags & ACTION_TALK) ucmd->buttons |= BUTTON_TALK;
    if (bi.actionflags & ACTION_GESTURE) != 0 {
        ucmd.buttons |= BUTTON_GESTURE
    }
    if (bi.actionflags & ACTION_USE) != 0 {
        ucmd.buttons |= BUTTON_USE_HOLDABLE
    }
    if (bi.actionflags & ACTION_WALK) != 0 {
        ucmd.buttons |= BUTTON_WALKING
    }

    if (bi.actionflags & ACTION_FORCEPOWER) != 0 {
        ucmd.buttons |= BUTTON_FORCEPOWER
    }

    if useTime < level.time && Q_irand(1, 10) < 5 {
        //for now just hit use randomly in case there's something useable around
        ucmd.buttons |= BUTTON_USE
    }
    // Here's an interesting bit.  The bots in TA used buttons to do additional gestures.
    // I ripped them out because I didn't want too many buttons given the fact that I was already adding some for JK2.
    // We can always add some back in if we want though.

    if bi.weapon == WP_NONE {
        //		Com_Printf("WARNING: Bot tried to use WP_NONE!\n");
        bi.weapon = WP_BRYAR_PISTOL
    }

    //
    ucmd.weapon = bi.weapon
    //set the view angles
    //NOTE: the ucmd->angles are the angles WITHOUT the delta angles
    ucmd.angles[PITCH] = ANGLE2SHORT(bi.viewangles[PITCH])
    ucmd.angles[YAW] = ANGLE2SHORT(bi.viewangles[YAW])
    ucmd.angles[ROLL] = ANGLE2SHORT(bi.viewangles[ROLL])
    //subtract the delta angles
    j = 0
    while j < 3 {
        temp = Int16(truncatingIfNeeded: ucmd.angles[j] - delta_angles[j])
        ucmd.angles[j] = Int32(temp)
        j += 1
    }
    //NOTE: movement is relative to the REAL view angles
    //get the horizontal forward and right vector
    //get the pitch in the range [-180, 180]
    if bi.dir[2] != 0 {
        angles[PITCH] = bi.viewangles[PITCH]
    } else {
        angles[PITCH] = 0
    }
    angles[YAW] = bi.viewangles[YAW]
    angles[ROLL] = 0
    // Raven passes NULL for the `up` output, and AngleVectors skips the write for a NULL output.
    var scratchUp = vec3_t()
    AngleVectors(angles, &forward, &right, &scratchUp)
    //bot input speed is in the range [0, 400]
    bi.speed = bi.speed * 127 / 400
    //set the view independent movement
    ucmd.forwardmove = Int32(_DotProduct(forward, bi.dir) * bi.speed)
    ucmd.rightmove = Int32(_DotProduct(right, bi.dir) * bi.speed)
    ucmd.upmove = Int32(abs(Int32((forward[2]))) * bi.dir[2] * bi.speed)
    //normal keyboard movement
    if (bi.actionflags & ACTION_MOVEFORWARD) != 0 {
        ucmd.forwardmove += 127
    }
    if (bi.actionflags & ACTION_MOVEBACK) != 0 {
        ucmd.forwardmove -= 127
    }
    if (bi.actionflags & ACTION_MOVELEFT) != 0 {
        ucmd.rightmove -= 127
    }
    if (bi.actionflags & ACTION_MOVERIGHT) != 0 {
        ucmd.rightmove += 127
    }
    //jump/moveup
    if (bi.actionflags & ACTION_JUMP) != 0 {
        ucmd.upmove += 127
    }
    //crouch/movedown
    if (bi.actionflags & ACTION_CROUCH) != 0 {
        ucmd.upmove -= 127
    }
    //
    //Com_Printf("forward = %d right = %d up = %d\n", ucmd.forwardmove, ucmd.rightmove, ucmd.upmove);
    //Com_Printf("ucmd->serverTime = %d\n", ucmd->serverTime);
}

/**
```
==============
BotUpdateInput
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:633
func BotUpdateInput(_ bs: BotState, _ time: Int32, _ elapsed_time: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    BotInput.scratch { bi in
        var j: Int32 = 0

        //add the delta angles to the bot's current view angles
        j = 0
        while j < 3 {
            bs.viewangles[j] = AngleMod(bs.viewangles[j] + SHORT2ANGLE(bs.cur_ps.delta_angles[j]))
            j += 1
        }
        //change the bot view angles
        BotChangeViewAngles(bs, Float(elapsed_time) / 1000)
        //retrieve the bot input
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'BotInput' to expected argument type 'OpaquePointer'".
        // Raven wrote: trap_EA_GetInput(bs->client, (float) time / 1000, &bi)
        portMissing("BotUpdateInput", source: "oracle/codemp/game/ai_main.c:633")
        //respawn hack
        if (bi.actionflags & ACTION_RESPAWN) != 0 {
            if (bs.lastucmd.buttons & BUTTON_ATTACK) != 0 {
                bi.actionflags &= ~(ACTION_RESPAWN | ACTION_ATTACK)
            }
        }
        //convert the bot input to a usercmd
        BotInputToUserCommand(bi, bs.lastucmd, Array(bs.cur_ps.delta_angles), time, bs.noUseTime)
        //subtract the delta angles
        j = 0
        while j < 3 {
            bs.viewangles[j] = AngleMod(bs.viewangles[j] - SHORT2ANGLE(bs.cur_ps.delta_angles[j]))
            j += 1
        }
    }
}

/**
```
==============
BotAIRegularUpdate
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:662
func BotAIRegularUpdate() {
    if regularupdate_time < floattime {
        trap_BotUpdateEntityItems()
        regularupdate_time = Float(Double(floattime) + 0.3)
    }
}

/**
```
==============
RemoveColorEscapeSequences
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:674
func RemoveColorEscapeSequences(_ text: inout JKAShared.CharBuf) {
    var i: Int32
    var l: Int32

    l = 0
    i = 0
    while text[i] != 0 {
        if Q_IsColorString(text, at: Int(i)) {
            i += 1
            i += 1
            continue
        }
        if text[i] > 0x7E {
            i += 1
            continue
        }
        text[l] = text[i]
        l += 1
        i += 1
    }
    text[l] = 0
}

/**
```
==============
BotAI
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:696
func BotAI(_ client: Int32, _ thinktime: Float) -> Int32 {
    var bs: BotState?
    var buf = CharBuf(1024)
    // Port-note: A pointer local `char * args` with no view.
    // Raven wrote: args;
    portMissing("BotAI", source: "oracle/codemp/game/ai_main.c:696")
    var j: Int32

    trap_EA_ResetInput(client)
    //
    bs = botstates[client]
    if bs == nil || bs!.inuse == 0 {
        BotAI_Print(PRT_FATAL, "BotAI: client %d is not setup\n", client)
        return 0
    }

    //retrieve the current client state
    BotAI_GetClientState(client, bs!.cur_ps)

    //retrieve any waiting server commands
    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type '(Int32, String)' and 'Int'".
    // Raven wrote: while( trap_BotGetServerCommand(client, buf, sizeof(buf)) ) { //have buf point to the command and args to the command arguments args = strchr( buf, ' '); if (!args) continue; *args++ = '\0'; //remove color espace sequences from the arguments RemoveColorEscapeSequences( args ); if (!Q_stricmp(buf, "cp ")) { /*CenterPrintf*/ } else if (!Q_stricmp(buf, "cs")) { /*ConfigStringModified*/ } else if (!Q_stricmp(buf, "scores")) { /*FIXME: parse scores?*/ } else if (!Q_stricmp(buf, "clientLevelShot")) { /*ignore*/ } }
    portMissing("BotAI", source: "oracle/codemp/game/ai_main.c:696")
    //add the delta angles to the bot's current view angles
    j = 0
    while j < 3 {
        bs!.viewangles[j] = AngleMod(bs!.viewangles[j] + SHORT2ANGLE(bs!.cur_ps.delta_angles[j]))
        j += 1
    }
    //increase the local time of the bot
    bs!.ltime += thinktime
    //
    bs!.thinktime = thinktime
    //origin of the bot
    bs!.origin = bs!.cur_ps.origin
    //eye coordinates of the bot
    bs!.eye = bs!.cur_ps.origin
    bs!.eye[2] += bs!.cur_ps.viewheight
    //get the area the bot is in

    StandardBotAI(bs!, thinktime)



    //subtract the delta angles
    j = 0
    while j < 3 {
        bs!.viewangles[j] = AngleMod(bs!.viewangles[j] - SHORT2ANGLE(bs!.cur_ps.delta_angles[j]))
        j += 1
    }
    //everything was ok
    return 1
}

/**
```
==================
BotScheduleBotThink
==================
```
*/
/// Source: oracle/codemp/game/ai_main.c:778
func BotScheduleBotThink() {
    var i: Int32
    var botnum: Int32

    botnum = 0

    i = 0
    while i < MAX_CLIENTS {
        if botstates[i] == nil || botstates[i]!.inuse == 0 {
            i += 1
            continue
        }
        //initialize the bot think residual time
        botstates[i]!.botthink_residual = BOT_THINK_TIME * botnum / numbots
        botnum += 1
        i += 1
    }
}

/// Source: oracle/codemp/game/ai_main.c:793
func PlayersInGame() -> Int32 {
    var i: Int32 = 0
    var ent: Entity?
    var pl: Int32 = 0

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && ent!.client!.pers.connected == CON_CONNECTED {
            pl += 1
        }

        i += 1
    }

    return pl
}

/**
```
==============
BotAISetupClient
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:819
func BotAISetupClient(_ client: Int32, _ settings: BotSettings, _ restart: Bool) -> Int32 {
    var bs: BotState?

    if botstates[client] == nil {
        botstates[client] = BotState(B_Alloc(Int32(BotState.byteCount))) //G_Alloc(sizeof(bot_state_t));
    }
    //rww - G_Alloc bad! B_Alloc good.

    botstates[client]!.clear()

    bs = botstates[client]

    if bs != nil && bs!.inuse != 0 {
        BotAI_Print(PRT_FATAL, "BotAISetupClient: client %d already setup\n", client)
        return 0
    }

    bs!.settings.copy(from: settings)

    bs!.client = client //need to know the client number before doing personality stuff

    //initialize weapon weight defaults..
    bs!.botWeaponWeights[WP_NONE] = 0
    bs!.botWeaponWeights[WP_STUN_BATON] = 1
    bs!.botWeaponWeights[WP_SABER] = 10
    bs!.botWeaponWeights[WP_BRYAR_PISTOL] = 11
    bs!.botWeaponWeights[WP_BLASTER] = 12
    bs!.botWeaponWeights[WP_DISRUPTOR] = 13
    bs!.botWeaponWeights[WP_BOWCASTER] = 14
    bs!.botWeaponWeights[WP_REPEATER] = 15
    bs!.botWeaponWeights[WP_DEMP2] = 16
    bs!.botWeaponWeights[WP_FLECHETTE] = 17
    bs!.botWeaponWeights[WP_ROCKET_LAUNCHER] = 18
    bs!.botWeaponWeights[WP_THERMAL] = 14
    bs!.botWeaponWeights[WP_TRIP_MINE] = 0
    bs!.botWeaponWeights[WP_DET_PACK] = 0
    bs!.botWeaponWeights[WP_MELEE] = 1

    BotUtilizePersonality(bs!)

    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        bs!.botWeaponWeights[WP_SABER] = 13
    }

    //allocate a goal state
    bs!.gs = trap_BotAllocGoalState(client)

    //allocate a weapon state
    bs!.ws = trap_BotAllocWeaponState()

    bs!.inuse = 1
    bs!.entitynum = client
    bs!.setupcount = 4
    bs!.entergame_time = floattime
    bs!.ms = trap_BotAllocMoveState()
    numbots += 1

    //NOTE: reschedule the bot thinking
    BotScheduleBotThink()

    if PlayersInGame() != 0 {
        //don't talk to yourself
        BotDoChat(bs!, "GeneralGreetings", 0)
    }

    return 1
}

/**
```
==============
BotAIShutdownClient
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:891
func BotAIShutdownClient(_ client: Int32, _ restart: Bool) -> Int32 {
    var bs: BotState?

    bs = botstates[client]
    if bs == nil || bs!.inuse == 0 {
        //BotAI_Print(PRT_ERROR, "BotAIShutdownClient: client %d already shutdown\n", client);
        return 0
    }

    trap_BotFreeMoveState(bs!.ms)
    //free the goal state`
    trap_BotFreeGoalState(bs!.gs)
    //free the weapon weights
    trap_BotFreeWeaponState(bs!.ws)
    //
    //clear the bot state
    bs!.clear()
    //set the inuse flag to qfalse
    bs!.inuse = 0
    //there's one bot less
    numbots -= 1
    //everything went ok
    return 1
}

/**
```
==============
BotResetState

called when a bot enters the intermission or observer mode and
when the level is changed
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:924
func BotResetState(_ bs: BotState) {
    var client: Int32 = 0
    var entitynum: Int32 = 0
    var inuse: Int32 = 0
    var movestate: Int32 = 0
    var goalstate: Int32 = 0
    var weaponstate: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    BotSettings.scratch { settings in
        // Raven's record lives to the end of his block, so the block is the closure.
        PlayerState.scratch { ps in
            var entergame_time: Float = 0

            //save some things that should not be reset here
            settings.copy(from: bs.settings)
            ps.copy(from: bs.cur_ps)
            inuse = bs.inuse
            client = bs.client
            entitynum = bs.entitynum
            movestate = bs.ms
            goalstate = bs.gs
            weaponstate = bs.ws
            entergame_time = bs.entergame_time
            //reset the whole state
            bs.clear()
            //copy back some state stuff that should not be reset
            bs.ms = movestate
            bs.gs = goalstate
            bs.ws = weaponstate
            bs.cur_ps.copy(from: ps)
            bs.settings.copy(from: settings)
            bs.inuse = inuse
            bs.client = client
            bs.entitynum = entitynum
            bs.entergame_time = entergame_time
            //reset several states
            if bs.ms != 0 {
                trap_BotResetMoveState(bs.ms)
            }
            if bs.gs != 0 {
                trap_BotResetGoalState(bs.gs)
            }
            if bs.ws != 0 {
                trap_BotResetWeaponState(bs.ws)
            }
            if bs.gs != 0 {
                trap_BotResetAvoidGoals(bs.gs)
            }
            if bs.ms != 0 {
                trap_BotResetAvoidReach(bs.ms)
            }
        }
    }
}

/**
```
==============
BotAILoadMap
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:966
func BotAILoadMap(_ restart: Int32) -> Int32 {
    var i: Int32

    i = 0
    while i < MAX_CLIENTS {
        if botstates[i] != nil && botstates[i]!.inuse != 0 {
            BotResetState(botstates[i]!)
            botstates[i]!.setupcount = 4
        }
        i += 1
    }

    return 1
}

//standard visibility check
/// Source: oracle/codemp/game/ai_main.c:982
func OrgVisible(_ org1: JKAShared.vec3_t, _ org2: JKAShared.vec3_t, _ ignore: Int32) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        trap_Trace(tr, org1, vec3_origin, vec3_origin, org2, ignore, MASK_SOLID)

        if tr.fraction == 1 {
            return 1
        }

        return 0
    }
}

//special waypoint visibility check
/// Source: oracle/codemp/game/ai_main.c:997
func WPOrgVisible(_ bot: Entity, _ org1: JKAShared.vec3_t, _ org2: JKAShared.vec3_t, _ ignore: Int32) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var ownent: Entity?

        trap_Trace(tr, org1, vec3_origin, vec3_origin, org2, ignore, MASK_SOLID)

        if tr.fraction == 1 {
            trap_Trace(tr, org1, vec3_origin, vec3_origin, org2, ignore, MASK_PLAYERSOLID)

            if tr.fraction != 1 && tr.entityNum != ENTITYNUM_NONE && g_entities[tr.entityNum].s.eType == ET_SPECIAL {
                if g_entities[tr.entityNum].parent != nil && g_entities[tr.entityNum].parent!.client != nil {
                    ownent = g_entities[tr.entityNum].parent

                    if OnSameTeam(bot, ownent!) || bot.s.number == ownent!.s.number {
                        return 1
                    }
                }
                return 2
            }

            return 1
        }

        return 0
    }
}

//visibility check with hull trace
/// Source: oracle/codemp/game/ai_main.c:1029
func OrgVisibleBox(_ org1: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ org2: JKAShared.vec3_t, _ ignore: Int32) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        if g_RMG.integer != 0 {
            trap_Trace(tr, org1, vec3_origin, vec3_origin, org2, ignore, MASK_SOLID)
        } else {
            trap_Trace(tr, org1, mins, maxs, org2, ignore, MASK_SOLID)
        }

        if tr.fraction == 1 && tr.startsolid == 0 && tr.allsolid == 0 {
            return 1
        }

        return 0
    }
}

//see if there's a func_* ent under the given pos.
//kind of badly done, but this shouldn't happen
//often.
/// Source: oracle/codemp/game/ai_main.c:1053
func CheckForFunc(_ org: JKAShared.vec3_t, _ ignore: Int32) -> Int32 {
    var fent: Entity?
    var under = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        under = org

        under[2] -= 64

        trap_Trace(tr, org, vec3_origin, vec3_origin, under, ignore, MASK_SOLID)

        if tr.fraction == 1 {
            return 0
        }

        fent = g_entities[tr.entityNum]

        if fent == nil {
            return 0
        }

        if strstr(fent!.classname!, "func_") != nil {
            return 1 //there's a func brush here
        }

        return 0
    }
}

//perform pvs check based on rmg or not
/// Source: oracle/codemp/game/ai_main.c:1086
func BotPVSCheck(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Bool {
    if g_RMG.integer != 0 && bot_pvstype.integer != 0 {
        var subPoint = vec3_t()
        subPoint = p1 - p2

        if VectorLength(subPoint) > 5000 {
            return false
        }
        return true
    }

    return trap_InPVS(p1, p2)
}

//get the index to the nearest visible waypoint in the global trail
/// Source: oracle/codemp/game/ai_main.c:1104
func GetNearestVisibleWP(_ org: JKAShared.vec3_t, _ ignore: Int32) -> Int32 {
    var i: Int32
    var bestdist: Float
    var flLen: Float
    var bestindex: Int32
    var a = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()

    i = 0
    if g_RMG.integer != 0 {
        bestdist = 300
    } else {
        bestdist = 800 //99999;
        //don't trace over 800 units away to avoid GIANT HORRIBLE SPEED HITS ^_^
    }
    bestindex = -1

    mins[0] = -15
    mins[1] = -15
    mins[2] = -1
    maxs[0] = 15
    maxs[1] = 15
    maxs[2] = 1

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
            a = org - gWPArray[i]!.origin
            flLen = VectorLength(a)

            if flLen < bestdist && (g_RMG.integer != 0 || BotPVSCheck(org, gWPArray[i]!.origin)) && OrgVisibleBox(org, mins, maxs, gWPArray[i]!.origin, ignore) != 0 {
                bestdist = flLen
                bestindex = i
            }
        }

        i += 1
    }

    return bestindex
}

//see if this is a valid waypoint to pick up in our
//current state (whatever that may be)
/// Source: oracle/codemp/game/ai_main.c:1157
func PassWayCheck(_ bs: BotState, _ windex: Int32) -> Int32 {
    if gWPArray[windex] == nil || gWPArray[windex]!.inuse == 0 {
        //bad point index
        return 0
    }

    if g_RMG.integer != 0 {
        if (gWPArray[windex]!.flags & WPFLAG_RED_FLAG) != 0 || (gWPArray[windex]!.flags & WPFLAG_BLUE_FLAG) != 0 {
            //red or blue flag, we'd like to get here
            return 1
        }
    }

    if bs.wpDirection != 0 && (gWPArray[windex]!.flags & WPFLAG_ONEWAY_FWD) != 0 {
        //we're not travelling in a direction on the trail that will allow us to pass this point
        return 0
    } else if bs.wpDirection == 0 && (gWPArray[windex]!.flags & WPFLAG_ONEWAY_BACK) != 0 {
        //we're not travelling in a direction on the trail that will allow us to pass this point
        return 0
    }

    if bs.wpCurrent != nil && gWPArray[windex]!.forceJumpTo != 0 && gWPArray[windex]!.origin[2] > (bs.wpCurrent!.origin[2] + 64) && bs.cur_ps.fd.forcePowerLevel[FP_LEVITATION] < gWPArray[windex]!.forceJumpTo {
        //waypoint requires force jump level greater than our current one to pass
        return 0
    }

    return 1
}

//tally up the distance between two waypoints
/// Source: oracle/codemp/game/ai_main.c:1193
func TotalTrailDistance(_ start: Int32, _ end: Int32, _ bs: BotState) -> Float {
    var beginat: Int32
    let endat: Int32
    var distancetotal: Float

    distancetotal = 0

    if start > end {
        beginat = end
        endat = start
    } else {
        beginat = start
        endat = end
    }

    while beginat < endat {
        if beginat >= gWPNum || gWPArray[beginat] == nil || gWPArray[beginat]!.inuse == 0 {
            //invalid waypoint index
            return -1
        }

        if g_RMG.integer == 0 {
            if (end > start && (gWPArray[beginat]!.flags & WPFLAG_ONEWAY_BACK) != 0) || (start > end && (gWPArray[beginat]!.flags & WPFLAG_ONEWAY_FWD) != 0) {
                //a one-way point, this means this path cannot be travelled to the final point
                return -1
            }
        }




        distancetotal += gWPArray[beginat]!.disttonext

        beginat += 1
    }

    return distancetotal
}

//see if there's a route shorter than our current one to get
//to the final destination we currently desire
/// Source: oracle/codemp/game/ai_main.c:1263
func CheckForShorterRoutes(_ bs: BotState, _ newwpindex: Int32) {
    var bestlen: Float
    var checklen: Float
    var bestindex: Int32
    var i: Int32
    var fj: Int32

    i = 0
    fj = 0

    if bs.wpDestination == nil {
        return
    }

    //set our traversal direction based on the index of the point
    if newwpindex < bs.wpDestination!.index {
        bs.wpDirection = 0
    } else if newwpindex > bs.wpDestination!.index {
        bs.wpDirection = 1
    }

    //can't switch again yet
    if bs.wpSwitchTime > level.time {
        return
    }

    //no neighboring points to check off of
    if gWPArray[newwpindex]!.neighbornum == 0 {
        return
    }

    //get the trail distance for our wp
    bestindex = newwpindex
    bestlen = TotalTrailDistance(newwpindex, bs.wpDestination!.index, bs)

    while i < gWPArray[newwpindex]!.neighbornum {
        //now go through the neighbors and check the distance to the desired point from each neighbor
        checklen = TotalTrailDistance(gWPArray[newwpindex]!.neighbors[i].num, bs.wpDestination!.index, bs)

        if checklen < bestlen - 64 || bestlen == -1 {
            //this path covers less distance, let's take it instead
            if bs.cur_ps.fd.forcePowerLevel[FP_LEVITATION] >= gWPArray[newwpindex]!.neighbors[i].forceJumpTo {
                bestlen = checklen
                bestindex = gWPArray[newwpindex]!.neighbors[i].num

                if gWPArray[newwpindex]!.neighbors[i].forceJumpTo != 0 {
                    fj = gWPArray[newwpindex]!.neighbors[i].forceJumpTo
                } else {
                    fj = 0
                }
            }
        }

        i += 1
    }

    if bestindex != newwpindex && bestindex != -1 {
        //we found a path we want to switch to, let's do it
        bs.wpCurrent = gWPArray[bestindex]
        bs.wpSwitchTime = Float(level.time + 3000)

        if fj != 0 {
            //do we have to force jump to get to this neighbor?
            bs.forceJumpChargeTime = level.time + 1000
            bs.beStill = Float(level.time + 1000)
            bs.forceJumping = Float(bs.forceJumpChargeTime)
        }
    }
}

//check for flags on the waypoint we're currently travelling to
//and perform the desired behavior based on the flag
/// Source: oracle/codemp/game/ai_main.c:1353
func WPConstantRoutine(_ bs: BotState) {
    if bs.wpCurrent == nil {
        return
    }

    if (bs.wpCurrent!.flags & WPFLAG_DUCK) != 0 {
        //duck while travelling to this point
        bs.duckTime = Float(level.time + 100)
    }

    if (bs.wpCurrent!.flags & WPFLAG_JUMP) != 0 {
        //jump while travelling to this point
        var heightDif: Float = (bs.wpCurrent!.origin[2] - bs.origin[2] + 16)

        if bs.origin[2] + 16 >= bs.wpCurrent!.origin[2] {
            //don't need to jump, we're already higher than this point
            heightDif = 0
        }

        if heightDif > 40 && (bs.cur_ps.fd.forcePowersKnown & (1 << FP_LEVITATION)) != 0 && (bs.cur_ps.fd.forceJumpCharge < (forceJumpStrength[bs.cur_ps.fd.forcePowerLevel[FP_LEVITATION]] - 100) || bs.cur_ps.groundEntityNum == ENTITYNUM_NONE) {
            //alright, let's jump
            bs.forceJumpChargeTime = level.time + 1000
            if bs.cur_ps.groundEntityNum != ENTITYNUM_NONE && bs.jumpPrep < (level.time - 300) {
                bs.jumpPrep = Float(level.time + 700)
            }
            bs.beStill = Float(level.time + 300)
            bs.jumpTime = 0

            if bs.wpSeenTime < (level.time + 600) {
                bs.wpSeenTime = Float(level.time + 600)
            }
        } else if heightDif > 64 && !((bs.cur_ps.fd.forcePowersKnown & (1 << FP_LEVITATION)) != 0) {
            //this point needs force jump to reach and we don't have it
            //Kill the current point and turn around
            bs.wpCurrent = nil
            if bs.wpDirection != 0 {
                bs.wpDirection = 0
            } else {
                bs.wpDirection = 1
            }

            return
        }
    }

    if bs.wpCurrent!.forceJumpTo != 0 {
        var heightDif: Float = (bs.wpCurrent!.origin[2] - bs.origin[2] + 16)

        if bs.origin[2] + 16 >= bs.wpCurrent!.origin[2] {
            //then why exactly would we be force jumping?
            heightDif = 0
        }

        if bs.cur_ps.fd.forceJumpCharge < (forceJumpStrength[bs.cur_ps.fd.forcePowerLevel[FP_LEVITATION]] - 100) {
            bs.forceJumpChargeTime = level.time + 200
        }
    }
}

//check if our ctf state is to guard the base
/// Source: oracle/codemp/game/ai_main.c:1432
func BotCTFGuardDuty(_ bs: BotState) -> Bool {
    if g_gametype.integer != GT_CTF && g_gametype.integer != GT_CTY {
        return false
    }

    if bs.ctfState == CTFSTATE_DEFENDER {
        return true
    }

    return false
}

//when we reach the waypoint we are travelling to,
//this function will be called. We will perform any
//checks for flags on the current wp and activate
//any "touch" events based on that.
/// Source: oracle/codemp/game/ai_main.c:1452
func WPTouchRoutine(_ bs: BotState) {
    let lastNum: Int32

    if bs.wpCurrent == nil {
        return
    }

    bs.wpTravelTime = Float(level.time + 10000)

    if (bs.wpCurrent!.flags & WPFLAG_NOMOVEFUNC) != 0 {
        //don't try to use any nearby map objects for a little while
        bs.noUseTime = level.time + 4000
    }

    //handled elsewhere.
    if (bs.wpCurrent!.flags & WPFLAG_JUMP) != 0 && bs.wpCurrent!.forceJumpTo == 0 {
        //jump if we're flagged to but not if this indicates a force jump point. Force jumping is
        //handled elsewhere.
        bs.jumpTime = Float(level.time + 100)
    }

    if bs.isCamper != 0 && bot_camp.integer != 0 && (BotIsAChickenWuss(bs) != 0 || BotCTFGuardDuty(bs) || bs.isCamper == 2) && ((bs.wpCurrent!.flags & WPFLAG_SNIPEORCAMP) != 0 || (bs.wpCurrent!.flags & WPFLAG_SNIPEORCAMPSTAND) != 0) && bs.cur_ps.weapon != WP_SABER && bs.cur_ps.weapon != WP_MELEE && bs.cur_ps.weapon != WP_STUN_BATON {
        //if we're a camper and a chicken then camp
        if bs.wpDirection != 0 {
            lastNum = bs.wpCurrent!.index + 1
        } else {
            lastNum = bs.wpCurrent!.index - 1
        }

        if gWPArray[lastNum] != nil && gWPArray[lastNum]!.inuse != 0 && gWPArray[lastNum]!.index != 0 && bs.isCamping < level.time {
            // The SDK also declares `rand`, so the call names the bg module.
            bs.isCamping = Float(level.time + JKAMP_BG.rand() % 15000 + 30000)
            bs.wpCamping = bs.wpCurrent
            bs.wpCampingTo = gWPArray[lastNum]

            if (bs.wpCurrent!.flags & WPFLAG_SNIPEORCAMPSTAND) != 0 {
                bs.campStanding = true
            } else {
                bs.campStanding = false
            }
        }
    } else if (bs.cur_ps.weapon == WP_SABER || bs.cur_ps.weapon == WP_STUN_BATON || bs.cur_ps.weapon == WP_MELEE) && bs.isCamping > level.time {
        //don't snipe/camp with a melee weapon, that would be silly
        bs.isCamping = 0
        bs.wpCampingTo = nil
        bs.wpCamping = nil
    }

    if bs.wpDestination != nil {
        if bs.wpCurrent!.index == bs.wpDestination!.index {
            bs.wpDestination = nil

            if bs.runningLikeASissy != 0 {
                //this obviously means we're scared and running, so we'll want to keep our navigational priorities less delayed
                bs.destinationGrabTime = Float(level.time + 500)
            } else {
                bs.destinationGrabTime = Float(level.time + 3500)
            }
        } else {
            CheckForShorterRoutes(bs, bs.wpCurrent!.index)
        }
    }
}

//could also slowly lerp toward, but for now
//just copying straight over.
/// Source: oracle/codemp/game/ai_main.c:1543
func MoveTowardIdealAngles(_ bs: BotState) {
    bs.ideal_viewangles = bs.goalAngles
}

//do some trace checks for strafing to get an idea of where we
//are and if we should move to avoid obstacles.
/// Source: oracle/codemp/game/ai_main.c:1556
func BotTrace_Strafe(_ bs: BotState, _ traceto: JKAShared.vec3_t) -> Int32 {
    var playerMins = vec3_t(-15, -15, -8)
    var playerMaxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))
    var from = vec3_t()
    var to = vec3_t()
    var dirAng = vec3_t()
    var dirDif = vec3_t()
    var forward = vec3_t()
    var right = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        if bs.cur_ps.groundEntityNum == ENTITYNUM_NONE {
            //don't do this in the air, it can be.. dangerous.
            return 0
        }

        dirAng = traceto - bs.origin
        VectorNormalize(&dirAng)
        vectoangles(dirAng, &dirAng)

        if AngleDifference(bs.viewangles[YAW], dirAng[YAW]) > 60 || AngleDifference(bs.viewangles[YAW], dirAng[YAW]) < -60 {
            //If we aren't facing the direction we're going here, then we've got enough excuse to be too stupid to strafe around anyway
            return 0
        }

        from = bs.origin
        to = traceto

        dirDif = to - from
        VectorNormalize(&dirDif)
        vectoangles(dirDif, &dirDif)

        // Raven passes NULL for the `right` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(dirDif, &forward, &scratchRight, &scratchUp)

        to[0] = from[0] + forward[0] * 32
        to[1] = from[1] + forward[1] * 32
        to[2] = from[2] + forward[2] * 32

        trap_Trace(tr, from, playerMins, playerMaxs, to, bs.client, MASK_PLAYERSOLID)

        if tr.fraction == 1 {
            return 0
        }

        // Raven passes NULL for the `forward` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchForward = vec3_t()
        var scratchUp2 = vec3_t()
        AngleVectors(dirAng, &scratchForward, &right, &scratchUp2)

        from[0] += right[0] * 32
        from[1] += right[1] * 32
        from[2] += right[2] * 16

        to[0] += right[0] * 32
        to[1] += right[1] * 32
        to[2] += right[2] * 32

        trap_Trace(tr, from, playerMins, playerMaxs, to, bs.client, MASK_PLAYERSOLID)

        if tr.fraction == 1 {
            return STRAFEAROUND_RIGHT
        }

        from[0] -= right[0] * 64
        from[1] -= right[1] * 64
        from[2] -= right[2] * 64

        to[0] -= right[0] * 64
        to[1] -= right[1] * 64
        to[2] -= right[2] * 64

        trap_Trace(tr, from, playerMins, playerMaxs, to, bs.client, MASK_PLAYERSOLID)

        if tr.fraction == 1 {
            return STRAFEAROUND_LEFT
        }

        return 0
    }
}

//Similar to the trace check, but we want to trace to see
//if there's anything we can jump over.
/// Source: oracle/codemp/game/ai_main.c:1638
func BotTrace_Jump(_ bs: BotState, _ traceto: JKAShared.vec3_t) -> Int32 {
    var mins = vec3_t()
    var maxs = vec3_t()
    var a = vec3_t()
    var fwd = vec3_t()
    var traceto_mod = vec3_t()
    var tracefrom_mod = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var orTr: Int32 = 0

        a = traceto - bs.origin
        vectoangles(a, &a)

        // Raven passes NULL for the `right` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(a, &fwd, &scratchRight, &scratchUp)

        traceto_mod[0] = bs.origin[0] + fwd[0] * 4
        traceto_mod[1] = bs.origin[1] + fwd[1] * 4
        traceto_mod[2] = bs.origin[2] + fwd[2] * 4

        mins[0] = -15
        mins[1] = -15
        mins[2] = -18
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 32

        trap_Trace(tr, bs.origin, mins, maxs, traceto_mod, bs.client, MASK_PLAYERSOLID)

        if tr.fraction == 1 {
            return 0
        }

        orTr = tr.entityNum

        tracefrom_mod = bs.origin

        tracefrom_mod[2] += 41
        traceto_mod[2] += 41

        mins[0] = -15
        mins[1] = -15
        mins[2] = 0
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 8

        trap_Trace(tr, tracefrom_mod, mins, maxs, traceto_mod, bs.client, MASK_PLAYERSOLID)

        if tr.fraction == 1 {
            if orTr >= 0 && orTr < MAX_CLIENTS && botstates[orTr] != nil && botstates[orTr]!.jumpTime > level.time {
                return 0 //so bots don't try to jump over each other at the same time
            }

            if bs.currentEnemy != nil && bs.currentEnemy!.s.number == orTr && (BotGetWeaponRange(bs) == BWEAPONRANGE_SABER || BotGetWeaponRange(bs) == BWEAPONRANGE_MELEE) {
                return 0
            }

            return 1
        }

        return 0
    }
}

//And yet another check to duck under any obstacles.
/// Source: oracle/codemp/game/ai_main.c:1702
func BotTrace_Duck(_ bs: BotState, _ traceto: JKAShared.vec3_t) -> Int32 {
    var mins = vec3_t()
    var maxs = vec3_t()
    var a = vec3_t()
    var fwd = vec3_t()
    var traceto_mod = vec3_t()
    var tracefrom_mod = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        a = traceto - bs.origin
        vectoangles(a, &a)

        // Raven passes NULL for the `right` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(a, &fwd, &scratchRight, &scratchUp)

        traceto_mod[0] = bs.origin[0] + fwd[0] * 4
        traceto_mod[1] = bs.origin[1] + fwd[1] * 4
        traceto_mod[2] = bs.origin[2] + fwd[2] * 4

        mins[0] = -15
        mins[1] = -15
        mins[2] = -23
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 8

        trap_Trace(tr, bs.origin, mins, maxs, traceto_mod, bs.client, MASK_PLAYERSOLID)

        if tr.fraction != 1 {
            return 0
        }

        tracefrom_mod = bs.origin

        tracefrom_mod[2] += 31 //33;
        traceto_mod[2] += 31 //33;

        mins[0] = -15
        mins[1] = -15
        mins[2] = 0
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 32

        trap_Trace(tr, tracefrom_mod, mins, maxs, traceto_mod, bs.client, MASK_PLAYERSOLID)

        if tr.fraction != 1 {
            return 1
        }

        return 0
    }
}

//check of the potential enemy is a valid one
/// Source: oracle/codemp/game/ai_main.c:1753
func PassStandardEnemyChecks(_ bs: BotState, _ en: Entity) -> Int32 {
    if en.client == nil {
        //not a client, don't care about him
        return 0
    }

    if en.health < 1 {
        //he's already dead
        return 0
    }

    if !en.takedamage {
        //a client that can't take damage?
        return 0
    }

    if bs.doingFallback && (gLevelFlags & LEVELFLAG_IGNOREINFALLBACK) != 0 {
        //we screwed up in our nav routines somewhere and we've reverted to a fallback state to
        //try to get back on the trail. If the level specifies to ignore enemies in this state,
        //then ignore them.
        return 0
    }

    if en.client!.ps.pm_type == PM_INTERMISSION || en.client!.ps.pm_type == PM_SPECTATOR || en.client!.sess.sessionTeam == TEAM_SPECTATOR {
        //don't attack spectators
        return 0
    }

    if en.client!.pers.connected == 0 {
        //a "zombie" client?
        return 0
    }

    if en.s.solid == 0 {
        //shouldn't happen
        return 0
    }

    if bs.client == en.s.number {
        //don't attack yourself
        return 0
    }

    if OnSameTeam(g_entities[bs.client], en) {
        //don't attack teammates
        return 0
    }

    if BotMindTricked(bs.client, en.s.number) != 0 {
        if bs.currentEnemy != nil && bs.currentEnemy!.s.number == en.s.number {
            //if mindtricked by this enemy, then be less "aware" of them, even though
            //we know they're there.
            var vs = vec3_t()
            var vLen: Float = 0

            vs = bs.origin - en.client!.ps.origin
            vLen = VectorLength(vs)

            if vLen > 64 {
                return 0
            }
        }
    }

    if en.client!.ps.duelInProgress && en.client!.ps.duelIndex != bs.client {
        //don't attack duelists unless you're dueling them
        return 0
    }

    if bs.cur_ps.duelInProgress && en.s.number != bs.cur_ps.duelIndex {
        //ditto, the other way around
        return 0
    }

    if g_gametype.integer == GT_JEDIMASTER && !en.client!.ps.isJediMaster && !bs.cur_ps.isJediMaster {
        //rules for attacking non-JM in JM mode
        var vs = vec3_t()
        var vLen: Float = 0

        if g_friendlyFire.integer == 0 {
            //can't harm non-JM in JM mode if FF is off
            return 0
        }

        vs = bs.origin - en.client!.ps.origin
        vLen = VectorLength(vs)

        if vLen > 350 {
            return 0
        }
    }

    return 1
}

//Notifies the bot that he has taken damage from "attacker".
/// Source: oracle/codemp/game/ai_main.c:1861
func BotDamageNotification(_ bot: Client, _ attacker: Entity) {
    var bs: BotState?
    var bs_a: BotState?
    var i: Int32

    if attacker.client == nil {
        return
    }

    if bot.ps.clientNum >= MAX_CLIENTS {
        //an NPC.. do nothing for them.
        return
    }

    if attacker.s.number >= MAX_CLIENTS {
        //if attacker is an npc also don't care I suppose.
        return
    }

    bs_a = botstates[attacker.s.number]

    if bs_a != nil {
        //if the client attacking us is a bot as well
        bs_a!.lastAttacked = g_entities[bot.ps.clientNum]
        i = 0

        while i < MAX_CLIENTS {
            if botstates[i] != nil && i != bs_a!.client && botstates[i]!.lastAttacked == g_entities[bot.ps.clientNum] {
                botstates[i]!.lastAttacked = nil
            }

            i += 1
        }
    } else {
        i = 0

        while i < MAX_CLIENTS {
            if botstates[i] != nil && botstates[i]!.lastAttacked == g_entities[bot.ps.clientNum] {
                botstates[i]!.lastAttacked = nil
            }

            i += 1
        }
    }

    bs = botstates[bot.ps.clientNum]

    if bs == nil {
        return
    }

    bs!.lastHurt = attacker

    if bs!.currentEnemy != nil {
        //we don't care about the guy attacking us if we have an enemy already
        return
    }

    if PassStandardEnemyChecks(bs!, attacker) == 0 {
        //the person that hurt us is not a valid enemy
        return
    }

    if PassLovedOneCheck(bs!, attacker) != 0 {
        //the person that hurt us is the one we love!
        bs!.currentEnemy = attacker
        bs!.enemySeenTime = Float(level.time + ENEMY_FORGET_MS)
    }
}

//perform cheap "hearing" checks based on the event catching
//system
/// Source: oracle/codemp/game/ai_main.c:1945
func BotCanHear(_ bs: BotState, _ en: Entity, _ endist: Float) -> Int32 {
    var minlen: Float

    checkStep: do {
        if en.client == nil {
            return 0
        }

        if en.client != nil && en.client!.ps.otherSoundTime > level.time {
            //they made a noise in recent time
            minlen = en.client!.ps.otherSoundLen
            break checkStep
        }

        if en.client != nil && en.client!.ps.footstepTime > level.time {
            //they made a footstep
            minlen = 256
            break checkStep
        }

        if gBotEventTracker[en.s.number].eventTime < level.time {
            //no recent events to check
            return 0
        }

        switch gBotEventTracker[en.s.number].events[gBotEventTracker[en.s.number].eventSequence & (MAX_PS_EVENTS - 1)] {
        case EV_GLOBAL_SOUND:
            minlen = 256

        case EV_FIRE_WEAPON, EV_ALT_FIRE, EV_SABER_ATTACK:
            minlen = 512

        case EV_STEP_4, EV_STEP_8, EV_STEP_12, EV_STEP_16, EV_FOOTSTEP, EV_FOOTSTEP_METAL, EV_FOOTWADE:
            minlen = 256

        case EV_JUMP, EV_ROLL:
            minlen = 256

        default:
            minlen = 999999
        }
    }
    if BotMindTricked(bs.client, en.s.number) != 0 {
        //if mindtricked by this person, cut down on the minlen so they can't "hear" as well
        minlen /= 4
    }

    if endist <= minlen {
        //we heard it
        return 1
    }

    return 0
}

//check for new events
/// Source: oracle/codemp/game/ai_main.c:2013
func UpdateEventTracker() {
    var i: Int32

    i = 0

    while i < MAX_CLIENTS {
        if gBotEventTracker[i].eventSequence != level.clientsSlots[i].ps.eventSequence {
            //updated event
            gBotEventTracker[i].eventSequence = level.clientsSlots[i].ps.eventSequence
            gBotEventTracker[i].events[0] = level.clientsSlots[i].ps.events[0]
            gBotEventTracker[i].events[1] = level.clientsSlots[i].ps.events[1]
            gBotEventTracker[i].eventTime = Float(Double(level.time) + 0.5)
        }

        i += 1
    }
}

//check if said angles are within our fov
/// Source: oracle/codemp/game/ai_main.c:2034
func InFieldOfVision(_ viewangles: JKAShared.vec3_t, _ fov: Float, _ angles: inout JKAShared.vec3_t) -> Int32 {
    var i: Int32
    var diff: Float
    var angle: Float

    i = 0
    while i < 2 {
        angle = AngleMod(viewangles[i])
        angles[i] = AngleMod(angles[i])
        diff = angles[i] - angle
        if angles[i] > angle {
            if Double(diff) > 180.0 {
                diff = Float(Double(diff) - 360.0)
            }
        } else {
            if Double(diff) < -180.0 {
                diff = Float(Double(diff) + 360.0)
            }
        }
        if diff > 0 {
            if Double(diff) > Double(fov) * 0.5 {
                return 0
            }
        } else {
            if Double(diff) < -Double(fov) * 0.5 {
                return 0
            }
        }
        i += 1
    }
    return 1
}

//We cannot hurt the ones we love. Unless of course this
//function says we can.
/// Source: oracle/codemp/game/ai_main.c:2078
func PassLovedOneCheck(_ bs: BotState, _ ent: Entity) -> Int32 {
    var i: Int32
    var loved: BotState?

    if bs.lovednum == 0 {
        return 1
    }

    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        //There is no love in 1-on-1
        return 1
    }

    i = 0

    if botstates[ent.s.number] == nil {
        //not a bot
        return 1
    }

    if bot_attachments.integer == 0 {
        return 1
    }

    loved = botstates[ent.s.number]

    while i < bs.lovednum {
        if strcmp(level.clientsSlots[loved!.client].pers.netname, bs.loved[i].name) == 0 {
            if IsTeamplay() == 0 && bs.loved[i].level < 2 {
                //if FFA and level of love is not greater than 1, just don't care
                return 1
            } else if IsTeamplay() != 0 && !OnSameTeam(g_entities[bs.client], g_entities[loved!.client]) && bs.loved[i].level < 2 {
                //is teamplay, but not on same team and level < 2
                return 1
            } else {
                return 0
            }
        }

        i += 1
    }

    return 1
}

//standard check to find a new enemy.
/// Source: oracle/codemp/game/ai_main.c:2134
func ScanForEnemies(_ bs: BotState) -> Int32 {
    var a = vec3_t()
    var distcheck: Float
    var closest: Float
    var bestindex: Int32
    var i: Int32
    var hasEnemyDist: Float = 0
    var noAttackNonJM: Bool = false

    closest = 999999
    i = 0
    bestindex = -1

    if bs.currentEnemy != nil {
        //only switch to a new enemy if he's significantly closer
        hasEnemyDist = bs.frame_Enemy_Len
    }

    if bs.currentEnemy != nil && bs.currentEnemy!.client != nil && bs.currentEnemy!.client!.ps.isJediMaster {
        //The Jedi Master must die.
        return -1
    }

    if g_gametype.integer == GT_JEDIMASTER {
        if G_ThereIsAMaster() && !bs.cur_ps.isJediMaster {
            //if friendly fire is on in jedi master we can attack people that bug us
            if g_friendlyFire.integer == 0 {
                noAttackNonJM = true
            } else {
                closest = 128 //only get mad at people if they get close enough to you to anger you, or hurt you
            }
        }
    }

    while i <= MAX_CLIENTS {
        if i != bs.client && g_entities[i].client != nil && !OnSameTeam(g_entities[bs.client], g_entities[i]) && PassStandardEnemyChecks(bs, g_entities[i]) != 0 && BotPVSCheck(g_entities[i].client!.ps.origin, bs.eye) && PassLovedOneCheck(bs, g_entities[i]) != 0 {
            a = g_entities[i].client!.ps.origin - bs.eye
            distcheck = VectorLength(a)
            vectoangles(a, &a)

            if g_entities[i].client!.ps.isJediMaster {
                //make us think the Jedi Master is close so we'll attack him above all
                distcheck = 1
            }

            if distcheck < closest && ((InFieldOfVision(bs.viewangles, 90, &a) != 0 && BotMindTricked(bs.client, i) == 0) || BotCanHear(bs, g_entities[i], distcheck) != 0) && OrgVisible(bs.eye, g_entities[i].client!.ps.origin, -1) != 0 {
                if BotMindTricked(bs.client, i) != 0 {
                    if distcheck < 256 || (level.time - g_entities[i].client!.dangerTime) < 100 {
                        if hasEnemyDist == 0 || distcheck < (hasEnemyDist - 128) {
                            //if we have an enemy, only switch to closer if he is 128+ closer to avoid flipping out
                            if !noAttackNonJM || g_entities[i].client!.ps.isJediMaster {
                                closest = distcheck
                                bestindex = i
                            }
                        }
                    }
                } else {
                    if hasEnemyDist == 0 || distcheck < (hasEnemyDist - 128) {
                        //if we have an enemy, only switch to closer if he is 128+ closer to avoid flipping out
                        if !noAttackNonJM || g_entities[i].client!.ps.isJediMaster {
                            closest = distcheck
                            bestindex = i
                        }
                    }
                }
            }
        }
        i += 1
    }

    return bestindex
}

/// Source: oracle/codemp/game/ai_main.c:2222
func WaitingForNow(_ bs: BotState, _ goalpos: JKAShared.vec3_t) -> Int32 {
    //checks if the bot is doing something along the lines of waiting for an elevator to raise up
    var xybot = vec3_t()
    var xywp = vec3_t()
    var a = vec3_t()

    if bs.wpCurrent == nil {
        return 0
    }

    if Int32(goalpos[0]) != Int32(bs.wpCurrent!.origin[0]) || Int32(goalpos[1]) != Int32(bs.wpCurrent!.origin[1]) || Int32(goalpos[2]) != Int32(bs.wpCurrent!.origin[2]) {
        return 0
    }

    xybot = bs.origin
    xywp = bs.wpCurrent!.origin

    xybot[2] = 0
    xywp[2] = 0

    a = xybot - xywp

    if VectorLength(a) < 16 && bs.frame_Waypoint_Len > 100 {
        if CheckForFunc(bs.origin, bs.client) != 0 {
            return 1 //we're probably standing on an elevator and riding up/down. Or at least we hope so.
        }
    } else if VectorLength(a) < 64 && bs.frame_Waypoint_Len > 64 && CheckForFunc(bs.origin, bs.client) != 0 {
        bs.noUseTime = level.time + 2000
    }

    return 0
}

//get an ideal distance for us to be at in relation to our opponent
//based on our weapon.
/// Source: oracle/codemp/game/ai_main.c:2264
func BotGetWeaponRange(_ bs: BotState) -> Int32 {
    switch bs.cur_ps.weapon {
    case WP_STUN_BATON, WP_MELEE:
        return BWEAPONRANGE_MELEE

    case WP_SABER:
        return BWEAPONRANGE_SABER

    case WP_BRYAR_PISTOL:
        return BWEAPONRANGE_MID

    case WP_BLASTER:
        return BWEAPONRANGE_MID

    case WP_DISRUPTOR:
        return BWEAPONRANGE_MID

    case WP_BOWCASTER:
        return BWEAPONRANGE_LONG

    case WP_REPEATER:
        return BWEAPONRANGE_MID

    case WP_DEMP2:
        return BWEAPONRANGE_LONG

    case WP_FLECHETTE:
        return BWEAPONRANGE_LONG

    case WP_ROCKET_LAUNCHER:
        return BWEAPONRANGE_LONG

    case WP_THERMAL:
        return BWEAPONRANGE_LONG

    case WP_TRIP_MINE:
        return BWEAPONRANGE_LONG

    case WP_DET_PACK:
        return BWEAPONRANGE_LONG

    default:
        return BWEAPONRANGE_MID
    }
}

//see if we want to run away from the opponent for whatever reason
/// Source: oracle/codemp/game/ai_main.c:2301
func BotIsAChickenWuss(_ bs: BotState) -> Int32 {
    let bWRange: Int32

    jmPass: do {
        if (gLevelFlags & LEVELFLAG_IMUSTNTRUNAWAY) != 0 {
            //The level says we mustn't run away!
            return 0
        }

        if g_gametype.integer == GT_SINGLE_PLAYER {
            //"coop" (not really)
            return 0
        }

        if g_gametype.integer == GT_JEDIMASTER && !bs.cur_ps.isJediMaster {
            //Then you may know no fear.
            //Well, unless he's strong.
            if bs.currentEnemy != nil && bs.currentEnemy!.client != nil && bs.currentEnemy!.client!.ps.isJediMaster && bs.currentEnemy!.health > 40 && bs.cur_ps.weapon < WP_ROCKET_LAUNCHER {
                //explosive weapons are most effective against the Jedi Master
                break jmPass
            }
            return 0
        }

        if g_gametype.integer == GT_CTF && bs.currentEnemy != nil && bs.currentEnemy!.client != nil {
            if bs.currentEnemy!.client!.ps.powerups[PW_REDFLAG] != 0 || bs.currentEnemy!.client!.ps.powerups[PW_BLUEFLAG] != 0 {
                //don't be afraid of flag carriers, they must die!
                return 0
            }
        }

    }
    if bs.chickenWussCalculationTime > level.time {
        return 2 //don't want to keep going between two points...
    }

    if (bs.cur_ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
        //don't run while raging
        return 0
    }

    if g_gametype.integer == GT_JEDIMASTER && !bs.cur_ps.isJediMaster {
        //be frightened of the jedi master? I guess in this case.
        return 1
    }

    bs.chickenWussCalculationTime = Float(level.time + MAX_CHICKENWUSS_TIME)

    if g_entities[bs.client].health < BOT_RUN_HEALTH {
        //we're low on health, let's get away
        return 1
    }

    bWRange = BotGetWeaponRange(bs)

    if bWRange == BWEAPONRANGE_MELEE || bWRange == BWEAPONRANGE_SABER {
        if bWRange != BWEAPONRANGE_SABER || bs.saberSpecialist == 0 {
            //run away if we're using melee, or if we're using a saber and not a "saber specialist"
            return 1
        }
    }

    if bs.cur_ps.weapon == WP_BRYAR_PISTOL {
        //the bryar is a weak weapon, so just try to find a new one if it's what you're having to use
        return 1
    }

    if bs.currentEnemy != nil && bs.currentEnemy!.client != nil && bs.currentEnemy!.client!.ps.weapon == WP_SABER && bs.frame_Enemy_Len < 512 && bs.cur_ps.weapon != WP_SABER {
        //if close to an enemy with a saber and not using a saber, then try to back off
        return 1
    }

    if (level.time - bs.cur_ps.electrifyTime) < 16000 {
        //lightning is dangerous.
        return 1
    }

    //didn't run, reset the timer
    bs.chickenWussCalculationTime = 0

    return 0
}

//look for "bad things". bad things include detpacks, thermal detonators,
//and other dangerous explodey items.
/// Source: oracle/codemp/game/ai_main.c:2395
func GetNearestBadThing(_ bs: BotState) -> Entity? {
    var i: Int32 = 0
    var glen: Float = 0
    var hold = vec3_t()
    var bestindex: Int32 = 0
    var bestdist: Float = 800
    var foundindex: Int32 = 0
    var factor: Float = 0
    var ent: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Entity? in

        while i < level.num_entities {
            ent = g_entities[i]

            if (ent != nil && ent!.client == nil && ent!.inuse && ent!.damage != 0 && ent!.s.weapon != 0 && ent!.splashDamage != 0) || (ent != nil && ent!.genericValue5 == 1000 && ent!.inuse && ent!.health > 0 && ent!.genericValue3 != bs.client && g_entities[ent!.genericValue3].client != nil && !OnSameTeam(g_entities[bs.client], g_entities[ent!.genericValue3])) {
                //try to escape from anything with a non-0 s.weapon and non-0 damage. This hopefully only means dangerous projectiles.
                //Or a sentry gun if bolt_Head == 1000. This is a terrible hack, yes.
                hold = bs.origin - ent!.r.currentOrigin
                glen = VectorLength(hold)

                if ent!.s.weapon != WP_THERMAL && ent!.s.weapon != WP_FLECHETTE && ent!.s.weapon != WP_DET_PACK && ent!.s.weapon != WP_TRIP_MINE {
                    factor = 0.5

                    if ent!.s.weapon != 0 && glen <= 256 && bs.settings.skill > 2 {
                        //it's a projectile so push it away
                        bs.doForcePush = level.time + 700
                        //G_Printf("PUSH PROJECTILE\n");
                    }
                } else {
                    factor = 1
                }

                if ent!.s.weapon == WP_ROCKET_LAUNCHER && (ent!.r.ownerNum == bs.client || (ent!.r.ownerNum > 0 && ent!.r.ownerNum < MAX_CLIENTS && g_entities[ent!.r.ownerNum].client != nil && OnSameTeam(g_entities[bs.client], g_entities[ent!.r.ownerNum]))) {
                    //don't be afraid of your own rockets or your teammates' rockets
                    factor = 0
                }

                if glen < bestdist * factor && BotPVSCheck(bs.origin, ent!.s.pos.trBase) {
                    trap_Trace(tr, bs.origin, vec3_origin, vec3_origin, ent!.s.pos.trBase, bs.client, MASK_SOLID)

                    if tr.fraction == 1 || tr.entityNum == ent!.s.number {
                        bestindex = i
                        bestdist = glen
                        foundindex = 1
                    }
                }
            }

            if ent != nil && ent!.client == nil && ent!.inuse && ent!.damage != 0 && ent!.s.weapon != 0 && ent!.r.ownerNum < MAX_CLIENTS && ent!.r.ownerNum >= 0 {
                //if we're in danger of a projectile belonging to someone and don't have an enemy, set the enemy to them
                let projOwner: Entity? = g_entities[ent!.r.ownerNum]

                if projOwner != nil && projOwner!.inuse && projOwner!.client != nil {
                    if bs.currentEnemy == nil {
                        if PassStandardEnemyChecks(bs, projOwner!) != 0 {
                            if PassLovedOneCheck(bs, projOwner!) != 0 {
                                hold = bs.origin - ent!.r.currentOrigin
                                glen = VectorLength(hold)

                                if glen < 512 {
                                    bs.currentEnemy = projOwner
                                    bs.enemySeenTime = Float(level.time + ENEMY_FORGET_MS)
                                }
                            }
                        }
                    }
                }
            }

            i += 1
        }

        if foundindex != 0 {
            bs.dontGoBack = Float(level.time + 1500)
            return g_entities[bestindex]
        } else {
            return nil
        }
    }
}

//Keep our CTF priorities on defending our team's flag
/// Source: oracle/codemp/game/ai_main.c:2507
func BotDefendFlag(_ bs: BotState) -> Int32 {
    var flagPoint: Wpobject?
    var a = vec3_t()

    if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
        flagPoint = flagRed
    } else if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_BLUE {
        flagPoint = flagBlue
    } else {
        return 0
    }

    if flagPoint == nil {
        return 0
    }

    a = bs.origin - flagPoint!.origin

    if VectorLength(a) > BASE_GUARD_DISTANCE {
        bs.wpDestination = flagPoint
    }

    return 1
}

//Keep our CTF priorities on getting the other team's flag
/// Source: oracle/codemp/game/ai_main.c:2541
func BotGetEnemyFlag(_ bs: BotState) -> Int32 {
    var flagPoint: Wpobject?
    var a = vec3_t()

    if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
        flagPoint = flagBlue
    } else if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_BLUE {
        flagPoint = flagRed
    } else {
        return 0
    }

    if flagPoint == nil {
        return 0
    }

    a = bs.origin - flagPoint!.origin

    if VectorLength(a) > BASE_GETENEMYFLAG_DISTANCE {
        bs.wpDestination = flagPoint
    }

    return 1
}

//Our team's flag is gone, so try to get it back
/// Source: oracle/codemp/game/ai_main.c:2575
func BotGetFlagBack(_ bs: BotState) -> Int32 {
    var i: Int32 = 0
    var myFlag: Int32 = 0
    var foundCarrier: Int32 = 0
    var tempInt: Int32 = 0
    var ent: Entity? = nil
    var usethisvec = vec3_t()

    if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
        myFlag = PW_REDFLAG
    } else {
        myFlag = PW_BLUEFLAG
    }

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && ent!.client!.ps.powerups[myFlag] != 0 && !OnSameTeam(g_entities[bs.client], ent!) {
            foundCarrier = 1
            break
        }

        i += 1
    }

    if foundCarrier == 0 {
        return 0
    }

    if ent == nil {
        return 0
    }

    if bs.wpDestSwitchTime < level.time {
        if ent!.client != nil {
            usethisvec = ent!.client!.ps.origin
        } else {
            usethisvec = ent!.s.origin
        }

        tempInt = GetNearestVisibleWP(usethisvec, 0)

        if tempInt != -1 && TotalTrailDistance(bs.wpCurrent!.index, tempInt, bs) != -1 {
            bs.wpDestination = gWPArray[tempInt]
            bs.wpDestSwitchTime = Float(level.time + Q_irand(1000, 5000))
        }
    }

    return 1
}

//Someone else on our team has the enemy flag, so try to get
//to their assistance
/// Source: oracle/codemp/game/ai_main.c:2641
func BotGuardFlagCarrier(_ bs: BotState) -> Int32 {
    var i: Int32 = 0
    var enemyFlag: Int32 = 0
    var foundCarrier: Int32 = 0
    var tempInt: Int32 = 0
    var ent: Entity? = nil
    var usethisvec = vec3_t()

    if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
        enemyFlag = PW_BLUEFLAG
    } else {
        enemyFlag = PW_REDFLAG
    }

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && ent!.client!.ps.powerups[enemyFlag] != 0 && OnSameTeam(g_entities[bs.client], ent!) {
            foundCarrier = 1
            break
        }

        i += 1
    }

    if foundCarrier == 0 {
        return 0
    }

    if ent == nil {
        return 0
    }

    if bs.wpDestSwitchTime < level.time {
        if ent!.client != nil {
            usethisvec = ent!.client!.ps.origin
        } else {
            usethisvec = ent!.s.origin
        }

        tempInt = GetNearestVisibleWP(usethisvec, 0)

        if tempInt != -1 && TotalTrailDistance(bs.wpCurrent!.index, tempInt, bs) != -1 {
            bs.wpDestination = gWPArray[tempInt]
            bs.wpDestSwitchTime = Float(level.time + Q_irand(1000, 5000))
        }
    }

    return 1
}

//We have the flag, let's get it home.
/// Source: oracle/codemp/game/ai_main.c:2706
func BotGetFlagHome(_ bs: BotState) -> Int32 {
    var flagPoint: Wpobject?
    var a = vec3_t()

    if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
        flagPoint = flagRed
    } else if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_BLUE {
        flagPoint = flagBlue
    } else {
        return 0
    }

    if flagPoint == nil {
        return 0
    }

    a = bs.origin - flagPoint!.origin

    if VectorLength(a) > BASE_FLAGWAIT_DISTANCE {
        bs.wpDestination = flagPoint
    }

    return 1
}

/// Source: oracle/codemp/game/ai_main.c:2739
func GetNewFlagPoint(_ wp: JKAMP.Wpobject, _ flagEnt: Entity, _ team: Int32) {
    //get the nearest possible waypoint to the flag since it's not in its original position
    var i: Int32 = 0
    var a = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    var bestdist: Float = 0
    var testdist: Float = 0
    var bestindex: Int32 = 0
    var foundindex: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        mins[0] = -15
        mins[1] = -15
        mins[2] = -5
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 5

        a = wp.origin - flagEnt.s.pos.trBase

        bestdist = VectorLength(a)

        if bestdist <= WP_KEEP_FLAG_DIST {
            trap_Trace(tr, wp.origin, mins, maxs, flagEnt.s.pos.trBase, flagEnt.s.number, MASK_SOLID)

            if tr.fraction == 1 {
                //this point is good
                return true
            }
        }

        while i < gWPNum {
            a = gWPArray[i]!.origin - flagEnt.s.pos.trBase
            testdist = VectorLength(a)

            if testdist < bestdist {
                trap_Trace(tr, gWPArray[i]!.origin, mins, maxs, flagEnt.s.pos.trBase, flagEnt.s.number, MASK_SOLID)

                if tr.fraction == 1 {
                    foundindex = 1
                    bestindex = i
                    bestdist = testdist
                }
            }

            i += 1
        }

        if foundindex != 0 {
            if team == TEAM_RED {
                flagRed = gWPArray[bestindex]
            } else {
                flagBlue = gWPArray[bestindex]
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

//See if our CTF state should take priority in our nav routines
/// Source: oracle/codemp/game/ai_main.c:2804
func CTFTakesPriority(_ bs: BotState) -> Int32 {
    var ent: Entity? = nil
    var enemyFlag: Int32 = 0
    var myFlag: Int32 = 0
    var enemyHasOurFlag: Int32 = 0
    var weHaveEnemyFlag: Int32 = 0
    var numOnMyTeam: Int32 = 0
    var numOnEnemyTeam: Int32 = 0
    var numAttackers: Int32 = 0
    var numDefenders: Int32 = 0
    var i: Int32 = 0
    let idleWP: Int32
    var dosw: Int32 = 0
    var dest_sw: Wpobject? = nil


    success: do {
        if g_gametype.integer != GT_CTF && g_gametype.integer != GT_CTY {
            return 0
        }

        if bs.cur_ps.weapon == WP_BRYAR_PISTOL && (level.time - bs.lastDeadTime) < BOT_MAX_WEAPON_GATHER_TIME {
            //get the nearest weapon laying around base before heading off for battle
            idleWP = GetBestIdleGoal(bs)

            if idleWP != -1 && gWPArray[idleWP] != nil && gWPArray[idleWP]!.inuse != 0 {
                if bs.wpDestSwitchTime < level.time {
                    bs.wpDestination = gWPArray[idleWP]
                }
                return 1
            }
        } else if bs.cur_ps.weapon == WP_BRYAR_PISTOL && (level.time - bs.lastDeadTime) < BOT_MAX_WEAPON_CHASE_CTF && bs.wpDestination != nil && bs.wpDestination!.weight != 0 {
            dest_sw = bs.wpDestination
            dosw = 1
        }

        if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
            myFlag = PW_REDFLAG
        } else {
            myFlag = PW_BLUEFLAG
        }

        if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
            enemyFlag = PW_BLUEFLAG
        } else {
            enemyFlag = PW_REDFLAG
        }

        if flagRed == nil || flagBlue == nil || flagRed!.inuse == 0 || flagBlue!.inuse == 0 || eFlagRed == nil || eFlagBlue == nil {
            return 0
        }



        if droppedRedFlag != nil && (droppedRedFlag!.flags & FL_DROPPED_ITEM) != 0 {
            GetNewFlagPoint(flagRed!, droppedRedFlag!, TEAM_RED)
        } else {
            flagRed = oFlagRed
        }

        if droppedBlueFlag != nil && (droppedBlueFlag!.flags & FL_DROPPED_ITEM) != 0 {
            GetNewFlagPoint(flagBlue!, droppedBlueFlag!, TEAM_BLUE)
        } else {
            flagBlue = oFlagBlue
        }

        if bs.ctfState == 0 {
            return 0
        }

        i = 0

        while i < MAX_CLIENTS {
            ent = g_entities[i]

            if ent != nil && ent!.client != nil {
                if ent!.client!.ps.powerups[enemyFlag] != 0 && OnSameTeam(g_entities[bs.client], ent!) {
                    weHaveEnemyFlag = 1
                } else if ent!.client!.ps.powerups[myFlag] != 0 && !OnSameTeam(g_entities[bs.client], ent!) {
                    enemyHasOurFlag = 1
                }

                if OnSameTeam(g_entities[bs.client], ent!) {
                    numOnMyTeam += 1
                } else {
                    numOnEnemyTeam += 1
                }

                if botstates[ent!.s.number] != nil {
                    if botstates[ent!.s.number]!.ctfState == CTFSTATE_ATTACKER || botstates[ent!.s.number]!.ctfState == CTFSTATE_RETRIEVAL {
                        numAttackers += 1
                    } else {
                        numDefenders += 1
                    }
                } else {
                    //assume real players to be attackers in our logic
                    numAttackers += 1
                }
            }
            i += 1
        }

        if bs.cur_ps.powerups[enemyFlag] != 0 {
            if (numOnMyTeam < 2 || numAttackers == 0) && enemyHasOurFlag != 0 {
                bs.ctfState = CTFSTATE_RETRIEVAL
            } else {
                bs.ctfState = CTFSTATE_GETFLAGHOME
            }
        } else if bs.ctfState == CTFSTATE_GETFLAGHOME {
            bs.ctfState = 0
        }

        if bs.state_Forced != 0 {
            bs.ctfState = bs.state_Forced
        }

        if bs.ctfState == CTFSTATE_DEFENDER {
            if BotDefendFlag(bs) != 0 {
                break success
            }
        }

        if bs.ctfState == CTFSTATE_ATTACKER {
            if BotGetEnemyFlag(bs) != 0 {
                break success
            }
        }

        if bs.ctfState == CTFSTATE_RETRIEVAL {
            if BotGetFlagBack(bs) != 0 {
                break success
            } else {
                //can't find anyone on another team being a carrier, so ignore this priority
                bs.ctfState = 0
            }
        }

        if bs.ctfState == CTFSTATE_GUARDCARRIER {
            if BotGuardFlagCarrier(bs) != 0 {
                break success
            } else {
                //can't find anyone on our team being a carrier, so ignore this priority
                bs.ctfState = 0
            }
        }

        if bs.ctfState == CTFSTATE_GETFLAGHOME {
            if BotGetFlagHome(bs) != 0 {
                break success
            }
        }

        return 0

    }
    if dosw != 0 {
        //allow ctf code to run, but if after a particular item then keep going after it
        bs.wpDestination = dest_sw
    }

    return 1
}

/// Source: oracle/codemp/game/ai_main.c:3036
func EntityVisibleBox(_ org1: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ org2: JKAShared.vec3_t, _ ignore: Int32, _ ignore2: Int32) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        trap_Trace(tr, org1, mins ?? vec3_origin, maxs ?? vec3_origin, org2, ignore, MASK_SOLID)

        if tr.fraction == 1 && tr.startsolid == 0 && tr.allsolid == 0 {
            return 1
        } else if tr.entityNum != ENTITYNUM_NONE && tr.entityNum == ignore2 {
            return 1
        }

        return 0
    }
}

//Get the closest objective for siege and go after it
/// Source: oracle/codemp/game/ai_main.c:3055
func Siege_TargetClosestObjective(_ bs: BotState, _ flag: Int32) -> Int32 {
    var i: Int32 = 0
    var bestindex: Int32 = -1
    var testdistance: Float = 0
    var bestdistance: Float = 999999999
    var goalent: Entity?
    var a = vec3_t()
    var dif = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()

    hasPoint: do {
        mins[0] = -1
        mins[1] = -1
        mins[2] = -1

        maxs[0] = 1
        maxs[1] = 1
        maxs[2] = 1

        if bs.wpDestination != nil && (bs.wpDestination!.flags & flag) != 0 && bs.wpDestination!.associated_entity != ENTITYNUM_NONE && g_entities[bs.wpDestination!.associated_entity].use != nil {
            break hasPoint
        }

        while i < gWPNum {
            if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && (gWPArray[i]!.flags & flag) != 0 && gWPArray[i]!.associated_entity != ENTITYNUM_NONE && g_entities[gWPArray[i]!.associated_entity].use != nil {
                a = gWPArray[i]!.origin - bs.origin
                testdistance = VectorLength(a)

                if testdistance < bestdistance {
                    bestdistance = testdistance
                    bestindex = i
                }
            }

            i += 1
        }

        if bestindex != -1 {
            bs.wpDestination = gWPArray[bestindex]
        } else {
            return 0
        }
    }
    goalent = g_entities[bs.wpDestination!.associated_entity]

    if goalent == nil {
        return 0
    }

    a = bs.origin - bs.wpDestination!.origin

    testdistance = VectorLength(a)

    dif[0] = (goalent!.r.absmax[0] + goalent!.r.absmin[0]) / 2
    dif[1] = (goalent!.r.absmax[1] + goalent!.r.absmin[1]) / 2
    dif[2] = (goalent!.r.absmax[2] + goalent!.r.absmin[2]) / 2
    //brush models can have tricky origins, so this is our hacky method of getting the center point

    if goalent!.takedamage && testdistance < BOT_MIN_SIEGE_GOAL_SHOOT && EntityVisibleBox(bs.origin, mins, maxs, dif, bs.client, goalent!.s.number) != 0 {
        bs.shootGoal = goalent
        bs.touchGoal = nil
    } else if goalent!.use != nil && testdistance < BOT_MIN_SIEGE_GOAL_TRAVEL {
        bs.shootGoal = nil
        bs.touchGoal = goalent
    } else {
        //don't know how to handle this goal object!
        bs.shootGoal = nil
        bs.touchGoal = nil
    }

    if BotGetWeaponRange(bs) == BWEAPONRANGE_MELEE || BotGetWeaponRange(bs) == BWEAPONRANGE_SABER {
        bs.shootGoal = nil //too risky
    }

    if bs.touchGoal != nil {
        //G_Printf("Please, master, let me touch it!\n");
        bs.goalPosition = dif
    }

    return 1
}

/// Source: oracle/codemp/game/ai_main.c:3154
func Siege_DefendFromAttackers(_ bs: BotState) {
    //this may be a little cheap, but the best way to find our defending point is probably
    //to just find the nearest person on the opposing team since they'll most likely
    //be on offense in this situation
    var wpClose: Int32 = -1
    var i: Int32 = 0
    var testdist: Float = 999999
    var bestindex: Int32 = -1
    var bestdist: Float = 999999
    var ent: Entity?
    var a = vec3_t()

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && ent!.client!.sess.sessionTeam != g_entities[bs.client].client!.sess.sessionTeam && ent!.health > 0 && ent!.client!.sess.sessionTeam != TEAM_SPECTATOR {
            a = ent!.client!.ps.origin - bs.origin

            testdist = VectorLength(a)

            if testdist < bestdist {
                bestindex = i
                bestdist = testdist
            }
        }

        i += 1
    }

    if bestindex == -1 {
        return
    }

    wpClose = GetNearestVisibleWP(g_entities[bestindex].client!.ps.origin, -1)

    if wpClose != -1 && gWPArray[wpClose] != nil && gWPArray[wpClose]!.inuse != 0 {
        bs.wpDestination = gWPArray[wpClose]
        bs.destinationGrabTime = Float(level.time + 10000)
    }
}

//how many defenders on our team?
/// Source: oracle/codemp/game/ai_main.c:3202
func Siege_CountDefenders(_ bs: BotState) -> Int32 {
    var i: Int32 = 0
    var num: Int32 = 0
    var ent: Entity?
    var bot: BotState?

    while i < MAX_CLIENTS {
        ent = g_entities[i]
        bot = botstates[i]

        if ent != nil && ent!.client != nil && bot != nil {
            if bot!.siegeState == SIEGESTATE_DEFENDER && ent!.client!.sess.sessionTeam == g_entities[bs.client].client!.sess.sessionTeam {
                num += 1
            }
        }

        i += 1
    }

    return num
}

//how many other players on our team?
/// Source: oracle/codemp/game/ai_main.c:3230
func Siege_CountTeammates(_ bs: BotState) -> Int32 {
    var i: Int32 = 0
    var num: Int32 = 0
    var ent: Entity?

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil {
            if ent!.client!.sess.sessionTeam == g_entities[bs.client].client!.sess.sessionTeam {
                num += 1
            }
        }

        i += 1
    }

    return num
}

//see if siege objective completion should take priority in our
//nav routines.
/// Source: oracle/codemp/game/ai_main.c:3256
func SiegeTakesPriority(_ bs: BotState) -> Int32 {
    var attacker: Int32 = 0
    var flagForDefendableObjective: Int32 = 0
    var flagForAttackableObjective: Int32 = 0
    var defenders: Int32 = 0
    var teammates: Int32 = 0
    var idleWP: Int32 = 0
    var dest_sw: Wpobject? = nil
    var dosw: Int32 = 0
    var bcl: Client?
    var dif = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        if g_gametype.integer != GT_SIEGE {
            return 0
        }

        bcl = g_entities[bs.client].client

        if bcl == nil {
            return 0
        }

        if bs.cur_ps.weapon == WP_BRYAR_PISTOL && (level.time - bs.lastDeadTime) < BOT_MAX_WEAPON_GATHER_TIME {
            //get the nearest weapon laying around base before heading off for battle
            idleWP = GetBestIdleGoal(bs)

            if idleWP != -1 && gWPArray[idleWP] != nil && gWPArray[idleWP]!.inuse != 0 {
                if bs.wpDestSwitchTime < level.time {
                    bs.wpDestination = gWPArray[idleWP]
                }
                return 1
            }
        } else if bs.cur_ps.weapon == WP_BRYAR_PISTOL && (level.time - bs.lastDeadTime) < BOT_MAX_WEAPON_CHASE_TIME && bs.wpDestination != nil && bs.wpDestination!.weight != 0 {
            dest_sw = bs.wpDestination
            dosw = 1
        }

        if bcl!.sess.sessionTeam == SIEGETEAM_TEAM1 {
            attacker = imperial_attackers
            flagForDefendableObjective = WPFLAG_SIEGE_REBELOBJ
            flagForAttackableObjective = WPFLAG_SIEGE_IMPERIALOBJ
        } else {
            attacker = rebel_attackers
            flagForDefendableObjective = WPFLAG_SIEGE_IMPERIALOBJ
            flagForAttackableObjective = WPFLAG_SIEGE_REBELOBJ
        }

        if attacker != 0 {
            bs.siegeState = SIEGESTATE_ATTACKER
        } else {
            bs.siegeState = SIEGESTATE_DEFENDER
            defenders = Siege_CountDefenders(bs)
            teammates = Siege_CountTeammates(bs)

            if defenders > teammates / 3 && teammates > 1 {
                //devote around 1/4 of our team to completing our own side goals even if we're a defender.
                //If we have no side goals we will realize that later on and join the defenders
                bs.siegeState = SIEGESTATE_ATTACKER
            }
        }

        if bs.state_Forced != 0 {
            bs.siegeState = bs.state_Forced
        }

        if bs.siegeState == SIEGESTATE_ATTACKER {
            if Siege_TargetClosestObjective(bs, flagForAttackableObjective) == 0 {
                //looks like we have no goals other than to keep the other team from completing objectives
                Siege_DefendFromAttackers(bs)
                if bs.shootGoal != nil {
                    dif[0] = (bs.shootGoal!.r.absmax[0] + bs.shootGoal!.r.absmin[0]) / 2
                    dif[1] = (bs.shootGoal!.r.absmax[1] + bs.shootGoal!.r.absmin[1]) / 2
                    dif[2] = (bs.shootGoal!.r.absmax[2] + bs.shootGoal!.r.absmin[2]) / 2

                    if !BotPVSCheck(bs.origin, dif) {
                        bs.shootGoal = nil
                    } else {
                        trap_Trace(tr, bs.origin, vec3_origin, vec3_origin, dif, bs.client, MASK_SOLID)

                        if tr.fraction != 1 && tr.entityNum != bs.shootGoal!.s.number {
                            bs.shootGoal = nil
                        }
                    }
                }
            }
        } else if bs.siegeState == SIEGESTATE_DEFENDER {
            Siege_DefendFromAttackers(bs)
            if bs.shootGoal != nil {
                dif[0] = (bs.shootGoal!.r.absmax[0] + bs.shootGoal!.r.absmin[0]) / 2
                dif[1] = (bs.shootGoal!.r.absmax[1] + bs.shootGoal!.r.absmin[1]) / 2
                dif[2] = (bs.shootGoal!.r.absmax[2] + bs.shootGoal!.r.absmin[2]) / 2

                if !BotPVSCheck(bs.origin, dif) {
                    bs.shootGoal = nil
                } else {
                    trap_Trace(tr, bs.origin, vec3_origin, vec3_origin, dif, bs.client, MASK_SOLID)

                    if tr.fraction != 1 && tr.entityNum != bs.shootGoal!.s.number {
                        bs.shootGoal = nil
                    }
                }
            }
        } else {
            //get busy!
            Siege_TargetClosestObjective(bs, flagForAttackableObjective)
            if bs.shootGoal != nil {
                dif[0] = (bs.shootGoal!.r.absmax[0] + bs.shootGoal!.r.absmin[0]) / 2
                dif[1] = (bs.shootGoal!.r.absmax[1] + bs.shootGoal!.r.absmin[1]) / 2
                dif[2] = (bs.shootGoal!.r.absmax[2] + bs.shootGoal!.r.absmin[2]) / 2

                if !BotPVSCheck(bs.origin, dif) {
                    bs.shootGoal = nil
                } else {
                    trap_Trace(tr, bs.origin, vec3_origin, vec3_origin, dif, bs.client, MASK_SOLID)

                    if tr.fraction != 1 && tr.entityNum != bs.shootGoal!.s.number {
                        bs.shootGoal = nil
                    }
                }
            }
        }

        if dosw != 0 {
            //allow siege objective code to run, but if after a particular item then keep going after it
            bs.wpDestination = dest_sw
        }

        return 1
    }
}

//see if jedi master priorities should take priority in our nav
//routines.
/// Source: oracle/codemp/game/ai_main.c:3424
func JMTakesPriority(_ bs: BotState) -> Int32 {
    var i: Int32 = 0
    var wpClose: Int32 = -1
    var theImportantEntity: Entity? = nil

    if g_gametype.integer != GT_JEDIMASTER {
        return 0
    }

    if bs.cur_ps.isJediMaster {
        return 0
    }

    //jmState becomes the index for the one who carries the saber. If jmState is -1 then the saber is currently
    //without an owner
    bs.jmState = -1

    while i < MAX_CLIENTS {
        if g_entities[i].client != nil && g_entities[i].inuse && g_entities[i].client!.ps.isJediMaster {
            bs.jmState = i
            break
        }

        i += 1
    }

    if bs.jmState != -1 {
        theImportantEntity = g_entities[bs.jmState]
    } else {
        theImportantEntity = gJMSaberEnt
    }

    if theImportantEntity != nil && theImportantEntity!.inuse && bs.destinationGrabTime < level.time {
        if theImportantEntity!.client != nil {
            wpClose = GetNearestVisibleWP(theImportantEntity!.client!.ps.origin, theImportantEntity!.s.number)
        } else {
            wpClose = GetNearestVisibleWP(theImportantEntity!.r.currentOrigin, theImportantEntity!.s.number)
        }

        if wpClose != -1 && gWPArray[wpClose] != nil && gWPArray[wpClose]!.inuse != 0 {
            /*
            Com_Printf("BOT GRABBED IDEAL JM LOCATION\n");
            if (bs->wpDestination != gWPArray[wpClose])
            {
            Com_Printf("IDEAL WAS NOT ALREADY IDEAL\n");

            if (!bs->wpDestination)
            {
            Com_Printf("IDEAL WAS NULL\n");
            }
            }
            */
            bs.wpDestination = gWPArray[wpClose]
            bs.destinationGrabTime = Float(level.time + 4000)
        }
    }

    return 1
}

//see if we already have an item/powerup/etc. that is associated
//with this waypoint.
/// Source: oracle/codemp/game/ai_main.c:3500
func BotHasAssociated(_ bs: BotState, _ wp: JKAMP.Wpobject) -> Int32 {
    var `as`: Entity?

    if wp.associated_entity == ENTITYNUM_NONE {
        //make it think this is an item we have so we don't go after nothing
        return 1
    }

    `as` = g_entities[wp.associated_entity]

    if `as` == nil || `as`!.item == nil {
        return 0
    }

    if `as`!.item!.giType == IT_WEAPON {
        if (bs.cur_ps.stats[STAT_WEAPONS] & (1 << `as`!.item!.giTag)) != 0 {
            return 1
        }

        return 0
    } else if `as`!.item!.giType == IT_HOLDABLE {
        if (bs.cur_ps.stats[STAT_HOLDABLE_ITEMS] & (1 << `as`!.item!.giTag)) != 0 {
            return 1
        }

        return 0
    } else if `as`!.item!.giType == IT_POWERUP {
        if bs.cur_ps.powerups[`as`!.item!.giTag] != 0 {
            return 1
        }

        return 0
    } else if `as`!.item!.giType == IT_AMMO {
        if bs.cur_ps.ammo[`as`!.item!.giTag] > 10 {
            return 1
        }

        return 0
    }

    return 0
}

//we don't really have anything we want to do right now,
//let's just find the best thing to do given the current
//situation.
/// Source: oracle/codemp/game/ai_main.c:3559
func GetBestIdleGoal(_ bs: BotState) -> Int32 {
    var i: Int32 = 0
    var highestweight: Int32 = 0
    var desiredindex: Int32 = -1
    var dist_to_weight: Int32 = 0
    var traildist: Int32

    if bs.wpCurrent == nil {
        return -1
    }

    if bs.isCamper != 2 {
        if bs.randomNavTime < level.time {
            if Q_irand(1, 10) < 5 {
                bs.randomNav = 1
            } else {
                bs.randomNav = 0
            }

            bs.randomNavTime = level.time + Q_irand(5000, 15000)
        }
    }

    if bs.randomNav != 0 {
        //stop looking for items and/or camping on them
        return -1
    }

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && (gWPArray[i]!.flags & WPFLAG_GOALPOINT) != 0 && gWPArray[i]!.weight > highestweight && BotHasAssociated(bs, gWPArray[i]!) == 0 {
            traildist = Int32(TotalTrailDistance(bs.wpCurrent!.index, i, bs))

            if traildist != -1 {
                dist_to_weight = Int32(traildist) / 10000
                dist_to_weight = Int32((gWPArray[i]!.weight) - dist_to_weight)

                if dist_to_weight > highestweight {
                    highestweight = dist_to_weight
                    desiredindex = i
                }
            }
        }

        i += 1
    }

    return desiredindex
}

//go through the list of possible priorities for navigating
//and work out the best destination point.
/// Source: oracle/codemp/game/ai_main.c:3625
func GetIdealDestination(_ bs: BotState) {
    var tempInt: Int32
    let cWPIndex: Int32
    let bChicken: Int32
    var idleWP: Int32
    var distChange: Float
    var plusLen: Float
    var minusLen: Float
    var usethisvec = vec3_t()
    var a = vec3_t()
    var badthing: Entity?



    if bs.wpCurrent == nil {
        return
    }

    if (level.time - bs.escapeDirTime) > 4000 {
        badthing = GetNearestBadThing(bs)
    } else {
        badthing = nil
    }

    if badthing != nil && badthing!.inuse && badthing!.health > 0 && badthing!.takedamage {
        bs.dangerousObject = badthing
    } else {
        bs.dangerousObject = nil
    }

    if badthing == nil && bs.wpDestIgnoreTime > level.time {
        return
    }

    if badthing == nil && bs.dontGoBack > level.time {
        if bs.wpDestination != nil {
            bs.wpStoreDest = bs.wpDestination
        }
        bs.wpDestination = nil
        return
    } else if badthing == nil && bs.wpStoreDest != nil {
        //after we finish running away, switch back to our original destination
        bs.wpDestination = bs.wpStoreDest
        bs.wpStoreDest = nil
    }

    if badthing != nil && bs.wpCamping != nil {
        bs.wpCamping = nil
    }

    if bs.wpCamping != nil {
        bs.wpDestination = bs.wpCamping
        return
    }

    if badthing == nil && CTFTakesPriority(bs) != 0 {
        if bs.ctfState != 0 {
            bs.runningToEscapeThreat = 1
        }
        return
    } else if badthing == nil && SiegeTakesPriority(bs) != 0 {
        if bs.siegeState != 0 {
            bs.runningToEscapeThreat = 1
        }
        return
    } else if badthing == nil && JMTakesPriority(bs) != 0 {
        bs.runningToEscapeThreat = 1
    }

    if badthing != nil {
        bs.runningLikeASissy = level.time + 100

        if bs.wpDestination != nil {
            bs.wpStoreDest = bs.wpDestination
        }
        bs.wpDestination = nil

        if bs.wpDirection != 0 {
            tempInt = bs.wpCurrent!.index + 1
        } else {
            tempInt = bs.wpCurrent!.index - 1
        }

        if gWPArray[tempInt] != nil && gWPArray[tempInt]!.inuse != 0 && bs.escapeDirTime < level.time {
            a = badthing!.s.pos.trBase - bs.wpCurrent!.origin
            plusLen = VectorLength(a)
            a = badthing!.s.pos.trBase - gWPArray[tempInt]!.origin
            minusLen = VectorLength(a)

            if plusLen < minusLen {
                if bs.wpDirection != 0 {
                    bs.wpDirection = 0
                } else {
                    bs.wpDirection = 1
                }

                bs.wpCurrent = gWPArray[tempInt]

                bs.escapeDirTime = Float(level.time + Q_irand(500, 1000)) //Q_irand(1000, 1400);

                //G_Printf("Escaping from scary bad thing [%s]\n", badthing->classname);
            }
        }
        //G_Printf("Run away run away run away!\n");
        return
    }

    distChange = 0 //keep the compiler from complaining

    tempInt = BotGetWeaponRange(bs)

    if tempInt == BWEAPONRANGE_MELEE {
        distChange = 1
    } else if tempInt == BWEAPONRANGE_SABER {
        distChange = 1
    } else if tempInt == BWEAPONRANGE_MID {
        distChange = 128
    } else if tempInt == BWEAPONRANGE_LONG {
        distChange = 300
    }

    if bs.revengeEnemy != nil && bs.revengeEnemy!.health > 0 && bs.revengeEnemy!.client != nil && (bs.revengeEnemy!.client!.pers.connected == CA_ACTIVE || bs.revengeEnemy!.client!.pers.connected == CA_AUTHORIZING) {
        //if we hate someone, always try to get to them
        if bs.wpDestSwitchTime < level.time {
            if bs.revengeEnemy!.client != nil {
                usethisvec = bs.revengeEnemy!.client!.ps.origin
            } else {
                usethisvec = bs.revengeEnemy!.s.origin
            }

            tempInt = GetNearestVisibleWP(usethisvec, 0)

            if tempInt != -1 && TotalTrailDistance(bs.wpCurrent!.index, tempInt, bs) != -1 {
                bs.wpDestination = gWPArray[tempInt]
                bs.wpDestSwitchTime = Float(level.time + Q_irand(5000, 10000))
            }
        }
    } else if bs.squadLeader != nil && bs.squadLeader!.health > 0 && bs.squadLeader!.client != nil && (bs.squadLeader!.client!.pers.connected == CA_ACTIVE || bs.squadLeader!.client!.pers.connected == CA_AUTHORIZING) {
        if bs.wpDestSwitchTime < level.time {
            if bs.squadLeader!.client != nil {
                usethisvec = bs.squadLeader!.client!.ps.origin
            } else {
                usethisvec = bs.squadLeader!.s.origin
            }

            tempInt = GetNearestVisibleWP(usethisvec, 0)

            if tempInt != -1 && TotalTrailDistance(bs.wpCurrent!.index, tempInt, bs) != -1 {
                bs.wpDestination = gWPArray[tempInt]
                bs.wpDestSwitchTime = Float(level.time + Q_irand(5000, 10000))
            }
        }
    } else if bs.currentEnemy != nil {
        if bs.currentEnemy!.client != nil {
            usethisvec = bs.currentEnemy!.client!.ps.origin
        } else {
            usethisvec = bs.currentEnemy!.s.origin
        }

        bChicken = BotIsAChickenWuss(bs)
        bs.runningToEscapeThreat = bChicken

        if bs.frame_Enemy_Len < distChange || (bChicken != 0 && bChicken != 2) {
            cWPIndex = bs.wpCurrent!.index

            if bs.frame_Enemy_Len > 400 {
                //good distance away, start running toward a good place for an item or powerup or whatever
                idleWP = GetBestIdleGoal(bs)

                if idleWP != -1 && gWPArray[idleWP] != nil && gWPArray[idleWP]!.inuse != 0 {
                    bs.wpDestination = gWPArray[idleWP]
                }
            } else if gWPArray[cWPIndex - 1] != nil && gWPArray[cWPIndex - 1]!.inuse != 0 && gWPArray[cWPIndex + 1] != nil && gWPArray[cWPIndex + 1]!.inuse != 0 {
                a = gWPArray[cWPIndex + 1]!.origin - usethisvec
                plusLen = VectorLength(a)
                a = gWPArray[cWPIndex - 1]!.origin - usethisvec
                minusLen = VectorLength(a)

                if minusLen > plusLen {
                    bs.wpDestination = gWPArray[cWPIndex - 1]
                } else {
                    bs.wpDestination = gWPArray[cWPIndex + 1]
                }
            }
        } else if bChicken != 2 && bs.wpDestSwitchTime < level.time {
            tempInt = GetNearestVisibleWP(usethisvec, 0)

            if tempInt != -1 && TotalTrailDistance(bs.wpCurrent!.index, tempInt, bs) != -1 {
                bs.wpDestination = gWPArray[tempInt]

                if g_gametype.integer == GT_SINGLE_PLAYER {
                    //be more aggressive
                    bs.wpDestSwitchTime = Float(level.time + Q_irand(300, 1000))
                } else {
                    bs.wpDestSwitchTime = Float(level.time + Q_irand(1000, 5000))
                }
            }
        }
    }

    if bs.wpDestination == nil && bs.wpDestSwitchTime < level.time {
        //G_Printf("I need something to do\n");
        idleWP = GetBestIdleGoal(bs)

        if idleWP != -1 && gWPArray[idleWP] != nil && gWPArray[idleWP]!.inuse != 0 {
            bs.wpDestination = gWPArray[idleWP]
        }
    }
}

//commander CTF AI - tell other bots in the so-called
//"squad" what to do.
/// Source: oracle/codemp/game/ai_main.c:3911
func CommanderBotCTFAI(_ bs: BotState) {
    var i: Int32 = 0
    var ent: Entity?
    var squadmates: Int32 = 0
    var squad = [Entity?](repeating: nil, count: Int(MAX_CLIENTS))
    var defendAttackPriority: Int32 = 0
    var guardDefendPriority: Int32 = 0
    var attackRetrievePriority: Int32 = 0
    var myFlag: Int32 = 0
    var enemyFlag: Int32 = 0
    var enemyHasOurFlag: Int32 = 0
    var weHaveEnemyFlag: Int32 = 0
    var numOnMyTeam: Int32 = 0
    var numOnEnemyTeam: Int32 = 0
    var numAttackers: Int32 = 0
    var numDefenders: Int32 = 0

    if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
        myFlag = PW_REDFLAG
    } else {
        myFlag = PW_BLUEFLAG
    }

    if level.clientsSlots[bs.client].sess.sessionTeam == TEAM_RED {
        enemyFlag = PW_BLUEFLAG
    } else {
        enemyFlag = PW_REDFLAG
    }

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil {
            if ent!.client!.ps.powerups[enemyFlag] != 0 && OnSameTeam(g_entities[bs.client], ent!) {
                weHaveEnemyFlag = 1
            } else if ent!.client!.ps.powerups[myFlag] != 0 && !OnSameTeam(g_entities[bs.client], ent!) {
                enemyHasOurFlag = 1
            }

            if OnSameTeam(g_entities[bs.client], ent!) {
                numOnMyTeam += 1
            } else {
                numOnEnemyTeam += 1
            }

            if botstates[ent!.s.number] != nil {
                if botstates[ent!.s.number]!.ctfState == CTFSTATE_ATTACKER || botstates[ent!.s.number]!.ctfState == CTFSTATE_RETRIEVAL {
                    numAttackers += 1
                } else {
                    numDefenders += 1
                }
            } else {
                //assume real players to be attackers in our logic
                numAttackers += 1
            }
        }
        i += 1
    }

    i = 0

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && botstates[i] != nil && botstates[i]!.squadLeader != nil && botstates[i]!.squadLeader!.s.number == bs.client && i != bs.client {
            squad[squadmates] = ent
            squadmates += 1
        }

        i += 1
    }

    squad[squadmates] = g_entities[bs.client]
    squadmates += 1

    i = 0

    if enemyHasOurFlag != 0 && weHaveEnemyFlag == 0 {
        //start off with an attacker instead of a retriever if we don't have the enemy flag yet so that they can't capture it first.
        //after that we focus on getting our flag back.
        attackRetrievePriority = 1
    }

    while i < squadmates {
        if squad[i] != nil && squad[i]!.client != nil && botstates[squad[i]!.s.number] != nil {
            if botstates[squad[i]!.s.number]!.ctfState != CTFSTATE_GETFLAGHOME {
                //never tell a bot to stop trying to bring the flag to the base
                if defendAttackPriority != 0 {
                    if weHaveEnemyFlag != 0 {
                        if guardDefendPriority != 0 {
                            botstates[squad[i]!.s.number]!.ctfState = CTFSTATE_GUARDCARRIER
                            guardDefendPriority = 0
                        } else {
                            botstates[squad[i]!.s.number]!.ctfState = CTFSTATE_DEFENDER
                            guardDefendPriority = 1
                        }
                    } else {
                        botstates[squad[i]!.s.number]!.ctfState = CTFSTATE_DEFENDER
                    }
                    defendAttackPriority = 0
                } else {
                    if enemyHasOurFlag != 0 {
                        if attackRetrievePriority != 0 {
                            botstates[squad[i]!.s.number]!.ctfState = CTFSTATE_ATTACKER
                            attackRetrievePriority = 0
                        } else {
                            botstates[squad[i]!.s.number]!.ctfState = CTFSTATE_RETRIEVAL
                            attackRetrievePriority = 1
                        }
                    } else {
                        botstates[squad[i]!.s.number]!.ctfState = CTFSTATE_ATTACKER
                    }
                    defendAttackPriority = 1
                }
            } else if (numOnMyTeam < 2 || numAttackers == 0) && enemyHasOurFlag != 0 {
                //I'm the only one on my team who will attack and the enemy has my flag, I have to go after him
                botstates[squad[i]!.s.number]!.ctfState = CTFSTATE_RETRIEVAL
            }
        }

        i += 1
    }
}

//similar to ctf ai, for siege
/// Source: oracle/codemp/game/ai_main.c:4077
func CommanderBotSiegeAI(_ bs: BotState) {
    var i: Int32 = 0
    var squadmates: Int32 = 0
    var commanded: Int32 = 0
    var teammates: Int32 = 0
    var squad = [Entity?](repeating: nil, count: Int(MAX_CLIENTS))
    var ent: Entity?
    var bst: BotState?

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && OnSameTeam(g_entities[bs.client], ent!) && botstates[ent!.s.number] != nil {
            bst = botstates[ent!.s.number]

            if bst != nil && bst!.isSquadLeader == 0 && bst!.state_Forced == 0 {
                squad[squadmates] = ent
                squadmates += 1
            } else if bst != nil && bst!.isSquadLeader == 0 && bst!.state_Forced != 0 {
                //count them as commanded
                commanded += 1
            }
        }

        if ent != nil && ent!.client != nil && OnSameTeam(g_entities[bs.client], ent!) {
            teammates += 1
        }

        i += 1
    }

    if squadmates == 0 {
        return
    }

    //tell squad mates to do what I'm doing, up to half of team, let the other half make their own decisions
    i = 0

    while i < squadmates && squad[i] != nil {
        bst = botstates[squad[i]!.s.number]

        if commanded > teammates / 2 {
            break
        }

        if bst != nil {
            bst!.state_Forced = bs.siegeState
            bst!.siegeState = bs.siegeState
            commanded += 1
        }

        i += 1
    }
}

//teamplay ffa squad ai
/// Source: oracle/codemp/game/ai_main.c:4143
func BotDoTeamplayAI(_ bs: BotState) {
    if bs.state_Forced != 0 {
        bs.teamplayState = bs.state_Forced
    }

    if bs.teamplayState == TEAMPLAYSTATE_REGROUP {
        //force to find a new leader
        bs.squadLeader = nil
        bs.isSquadLeader = 0
    }
}

//like ctf and siege commander ai, instruct the squad
/// Source: oracle/codemp/game/ai_main.c:4158
func CommanderBotTeamplayAI(_ bs: BotState) {
    var i: Int32 = 0
    var squadmates: Int32 = 0
    var teammates: Int32 = 0
    var teammate_indanger: Int32 = -1
    var teammate_helped: Int32 = 0
    var foundsquadleader: Int32 = 0
    var worsthealth: Int32 = 50
    var squad = [Entity?](repeating: nil, count: Int(MAX_CLIENTS))
    var ent: Entity?
    var bst: BotState?

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && OnSameTeam(g_entities[bs.client], ent!) && botstates[ent!.s.number] != nil {
            bst = botstates[ent!.s.number]

            if foundsquadleader != 0 && bst != nil && bst!.isSquadLeader != 0 {
                //never more than one squad leader
                bst!.isSquadLeader = 0
            }

            if bst != nil && bst!.isSquadLeader == 0 {
                squad[squadmates] = ent
                squadmates += 1
            } else if bst != nil {
                foundsquadleader = 1
            }
        }

        if ent != nil && ent!.client != nil && OnSameTeam(g_entities[bs.client], ent!) {
            teammates += 1

            if ent!.health < worsthealth {
                teammate_indanger = ent!.s.number
                worsthealth = ent!.health
            }
        }

        i += 1
    }

    if squadmates == 0 {
        return
    }

    i = 0

    while i < squadmates && squad[i] != nil {
        bst = botstates[squad[i]!.s.number]

        if bst != nil && bst!.state_Forced == 0 {
            //only order if this guy is not being ordered directly by the real player team leader
            if teammate_indanger >= 0 && teammate_helped == 0 {
                //send someone out to help whoever needs help most at the moment
                bst!.teamplayState = TEAMPLAYSTATE_ASSISTING
                bst!.squadLeader = g_entities[teammate_indanger]
                teammate_helped = 1
            } else if (teammate_indanger == -1 || teammate_helped != 0) && bst!.teamplayState == TEAMPLAYSTATE_ASSISTING {
                //no teammates need help badly, but this guy is trying to help them anyway, so stop
                bst!.teamplayState = TEAMPLAYSTATE_FOLLOWING
                bst!.squadLeader = g_entities[bs.client]
            }

            if bs.squadRegroupInterval < level.time && Q_irand(1, 10) < 5 {
                //every so often tell the squad to regroup for the sake of variation
                if bst!.teamplayState == TEAMPLAYSTATE_FOLLOWING {
                    bst!.teamplayState = TEAMPLAYSTATE_REGROUP
                }

                bs.isSquadLeader = 0
                bs.squadCannotLead = level.time + 500
                bs.squadRegroupInterval = level.time + Q_irand(45000, 65000)
            }
        }

        i += 1
    }
}

//pick which commander ai to use based on gametype
/// Source: oracle/codemp/game/ai_main.c:4252
func CommanderBotAI(_ bs: BotState) {
    if g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY {
        CommanderBotCTFAI(bs)
    } else if g_gametype.integer == GT_SIEGE {
        CommanderBotSiegeAI(bs)
    } else if g_gametype.integer == GT_TEAM {
        CommanderBotTeamplayAI(bs)
    }
}

//close range combat routines
/// Source: oracle/codemp/game/ai_main.c:4269
func MeleeCombatHandling(_ bs: BotState) {
    var usethisvec = vec3_t()
    var downvec = vec3_t()
    var midorg = vec3_t()
    var a = vec3_t()
    var fwd = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var en_down: Int32 = 0
        var me_down: Int32 = 0
        var mid_down: Int32 = 0

        if bs.currentEnemy == nil {
            return true
        }

        if bs.currentEnemy!.client != nil {
            usethisvec = bs.currentEnemy!.client!.ps.origin
        } else {
            usethisvec = bs.currentEnemy!.s.origin
        }

        if bs.meleeStrafeTime < level.time {
            if bs.meleeStrafeDir != 0 {
                bs.meleeStrafeDir = 0
            } else {
                bs.meleeStrafeDir = 1
            }

            bs.meleeStrafeTime = Float(level.time + Q_irand(500, 1800))
        }

        mins[0] = -15
        mins[1] = -15
        mins[2] = -24
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 32

        downvec = usethisvec
        downvec[2] -= 4096

        trap_Trace(tr, usethisvec, mins, maxs, downvec, -1, MASK_SOLID)

        en_down = Int32(tr.endpos[2])

        downvec = bs.origin
        downvec[2] -= 4096

        trap_Trace(tr, bs.origin, mins, maxs, downvec, -1, MASK_SOLID)

        me_down = Int32(tr.endpos[2])

        a = usethisvec - bs.origin
        vectoangles(a, &a)
        // Raven passes NULL for the `right` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(a, &fwd, &scratchRight, &scratchUp)

        midorg[0] = bs.origin[0] + fwd[0] * bs.frame_Enemy_Len / 2
        midorg[1] = bs.origin[1] + fwd[1] * bs.frame_Enemy_Len / 2
        midorg[2] = bs.origin[2] + fwd[2] * bs.frame_Enemy_Len / 2

        downvec = midorg
        downvec[2] -= 4096

        trap_Trace(tr, midorg, mins, maxs, downvec, -1, MASK_SOLID)

        mid_down = Int32(tr.endpos[2])

        if me_down == en_down && en_down == mid_down {
            bs.goalPosition = usethisvec
        }
        return false
    }
    if earlyOut {
        return
    }
}

//saber combat routines (it's simple, but it works)
/// Source: oracle/codemp/game/ai_main.c:4354
func SaberCombatHandling(_ bs: BotState) {
    var usethisvec = vec3_t()
    var downvec = vec3_t()
    var midorg = vec3_t()
    var a = vec3_t()
    var fwd = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var en_down: Int32 = 0
        var me_down: Int32 = 0
        var mid_down: Int32 = 0

        if bs.currentEnemy == nil {
            return true
        }

        if bs.currentEnemy!.client != nil {
            usethisvec = bs.currentEnemy!.client!.ps.origin
        } else {
            usethisvec = bs.currentEnemy!.s.origin
        }

        if bs.meleeStrafeTime < level.time {
            if bs.meleeStrafeDir != 0 {
                bs.meleeStrafeDir = 0
            } else {
                bs.meleeStrafeDir = 1
            }

            bs.meleeStrafeTime = Float(level.time + Q_irand(500, 1800))
        }

        mins[0] = -15
        mins[1] = -15
        mins[2] = -24
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 32

        downvec = usethisvec
        downvec[2] -= 4096

        trap_Trace(tr, usethisvec, mins, maxs, downvec, -1, MASK_SOLID)

        en_down = Int32(tr.endpos[2])

        if tr.startsolid != 0 || tr.allsolid != 0 {
            en_down = 1
            me_down = 2
        } else {
            downvec = bs.origin
            downvec[2] -= 4096

            trap_Trace(tr, bs.origin, mins, maxs, downvec, -1, MASK_SOLID)

            me_down = Int32(tr.endpos[2])

            if tr.startsolid != 0 || tr.allsolid != 0 {
                en_down = 1
                me_down = 2
            }
        }

        a = usethisvec - bs.origin
        vectoangles(a, &a)
        // Raven passes NULL for the `right` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(a, &fwd, &scratchRight, &scratchUp)

        midorg[0] = bs.origin[0] + fwd[0] * bs.frame_Enemy_Len / 2
        midorg[1] = bs.origin[1] + fwd[1] * bs.frame_Enemy_Len / 2
        midorg[2] = bs.origin[2] + fwd[2] * bs.frame_Enemy_Len / 2

        downvec = midorg
        downvec[2] -= 4096

        trap_Trace(tr, midorg, mins, maxs, downvec, -1, MASK_SOLID)

        mid_down = Int32(tr.endpos[2])

        if me_down == en_down && en_down == mid_down {
            if usethisvec[2] > (bs.origin[2] + 32) && bs.currentEnemy!.client != nil && bs.currentEnemy!.client!.ps.groundEntityNum == ENTITYNUM_NONE {
                bs.jumpTime = Float(level.time + 100)
            }

            if bs.frame_Enemy_Len > 128 {
                //be ready to attack
                bs.saberDefending = 0
                bs.saberDefendDecideTime = level.time + Q_irand(1000, 2000)
            } else {
                if bs.saberDefendDecideTime < level.time {
                    if bs.saberDefending != 0 {
                        bs.saberDefending = 0
                    } else {
                        bs.saberDefending = 1
                    }

                    bs.saberDefendDecideTime = level.time + Q_irand(500, 2000)
                }
            }

            if bs.frame_Enemy_Len < 54 {
                bs.goalPosition = bs.origin
                bs.saberBFTime = 0
            } else {
                bs.goalPosition = usethisvec
            }

            if bs.currentEnemy != nil && bs.currentEnemy!.client != nil {
                if !BG_SaberInSpecial(bs.currentEnemy!.client!.ps.saberMove) && bs.frame_Enemy_Len > 90 && bs.saberBFTime > level.time && bs.saberBTime > level.time && bs.beStill < level.time && bs.saberSTime < level.time {
                    bs.beStill = Float(level.time + Q_irand(500, 1000))
                    bs.saberSTime = level.time + Q_irand(1200, 1800)
                } else if bs.currentEnemy!.client!.ps.weapon == WP_SABER && bs.frame_Enemy_Len < 80 && (Q_irand(1, 10) < 8 && bs.saberBFTime < level.time) || bs.saberBTime > level.time || BG_SaberInKata(bs.currentEnemy!.client!.ps.saberMove) || bs.currentEnemy!.client!.ps.saberMove == LS_SPINATTACK || bs.currentEnemy!.client!.ps.saberMove == LS_SPINATTACK_DUAL {
                    var vs = vec3_t()
                    var groundcheck = vec3_t()
                    var idealDist: Int32 = 0
                    var checkIncr: Int32 = 0

                    vs = bs.origin - usethisvec
                    VectorNormalize(&vs)

                    if BG_SaberInKata(bs.currentEnemy!.client!.ps.saberMove) || bs.currentEnemy!.client!.ps.saberMove == LS_SPINATTACK || bs.currentEnemy!.client!.ps.saberMove == LS_SPINATTACK_DUAL {
                        idealDist = 256
                    } else {
                        idealDist = 64
                    }

                    while checkIncr < idealDist {
                        bs.goalPosition[0] = bs.origin[0] + vs[0] * checkIncr
                        bs.goalPosition[1] = bs.origin[1] + vs[1] * checkIncr
                        bs.goalPosition[2] = bs.origin[2] + vs[2] * checkIncr

                        if bs.saberBTime < level.time {
                            bs.saberBFTime = level.time + Q_irand(900, 1300)
                            bs.saberBTime = level.time + Q_irand(300, 700)
                        }

                        groundcheck = bs.goalPosition

                        groundcheck[2] -= 64

                        trap_Trace(tr, bs.goalPosition, vec3_origin, vec3_origin, groundcheck, bs.client, MASK_SOLID)

                        if tr.fraction == 1.0 {
                            //don't back off of a ledge
                            bs.goalPosition = usethisvec
                            break
                        }
                        checkIncr += 64
                    }
                } else if bs.currentEnemy!.client!.ps.weapon == WP_SABER && bs.frame_Enemy_Len >= 75 {
                    bs.saberBFTime = level.time + Q_irand(700, 1300)
                    bs.saberBTime = 0
                }
            }

            /*AngleVectors(bs->viewangles, NULL, fwd, NULL);

            if (bs->meleeStrafeDir)
            {
            bs->goalPosition[0] += fwd[0]*16;
            bs->goalPosition[1] += fwd[1]*16;
            bs->goalPosition[2] += fwd[2]*16;
            }
            else
            {
            bs->goalPosition[0] -= fwd[0]*16;
            bs->goalPosition[1] -= fwd[1]*16;
            bs->goalPosition[2] -= fwd[2]*16;
            }*/
        } else if bs.frame_Enemy_Len <= 56 {
            bs.doAttack = 1
            bs.saberDefending = 0
        }
        return false
    }
    if earlyOut {
        return
    }
}

//should we be "leading" our aim with this weapon? And if
//so, by how much?
/// Source: oracle/codemp/game/ai_main.c:4570
func BotWeaponCanLead(_ bs: BotState) -> Float {
    let weap: Int32 = bs.cur_ps.weapon

    if weap == WP_BRYAR_PISTOL {
        return 0.5
    }
    if weap == WP_BLASTER {
        return 0.35
    }
    if weap == WP_BOWCASTER {
        return 0.5
    }
    if weap == WP_REPEATER {
        return 0.45
    }
    if weap == WP_THERMAL {
        return 0.5
    }
    if weap == WP_DEMP2 {
        return 0.35
    }
    if weap == WP_ROCKET_LAUNCHER {
        return 0.7
    }

    return 0
}

//offset the desired view angles with aim leading in mind
/// Source: oracle/codemp/game/ai_main.c:4607
func BotAimLeading(_ bs: BotState, _ headlevel: JKAShared.vec3_t, _ leadAmount: Float) {
    var x: Int32
    var predictedSpot = vec3_t()
    var movementVector = vec3_t()
    var a = vec3_t()
    var ang = vec3_t()
    var vtotal: Float

    if bs.currentEnemy == nil || bs.currentEnemy!.client == nil {
        return
    }

    if bs.frame_Enemy_Len == 0 {
        return
    }

    vtotal = 0

    if bs.currentEnemy!.client!.ps.velocity[0] < 0 {
        vtotal += -bs.currentEnemy!.client!.ps.velocity[0]
    } else {
        vtotal += bs.currentEnemy!.client!.ps.velocity[0]
    }

    if bs.currentEnemy!.client!.ps.velocity[1] < 0 {
        vtotal += -bs.currentEnemy!.client!.ps.velocity[1]
    } else {
        vtotal += bs.currentEnemy!.client!.ps.velocity[1]
    }

    if bs.currentEnemy!.client!.ps.velocity[2] < 0 {
        vtotal += -bs.currentEnemy!.client!.ps.velocity[2]
    } else {
        vtotal += bs.currentEnemy!.client!.ps.velocity[2]
    }

    //G_Printf("Leadin target with a velocity total of %f\n", vtotal);

    movementVector = bs.currentEnemy!.client!.ps.velocity

    VectorNormalize(&movementVector)

    x = Int32(bs.frame_Enemy_Len * leadAmount) //hardly calculated with an exact science, but it works

    if vtotal > 400 {
        vtotal = 400
    }

    if vtotal != 0 {
        x = Int32((Double(bs.frame_Enemy_Len) * 0.9) * Double(leadAmount) * (Double(vtotal) * 0.0012)) //hardly calculated with an exact science, but it works
    } else {
        x = Int32((Double(bs.frame_Enemy_Len) * 0.9) * Double(leadAmount)) //hardly calculated with an exact science, but it works
    }

    predictedSpot[0] = headlevel[0] + (movementVector[0] * x)
    predictedSpot[1] = headlevel[1] + (movementVector[1] * x)
    predictedSpot[2] = headlevel[2] + (movementVector[2] * x)

    a = predictedSpot - bs.eye
    vectoangles(a, &ang)
    bs.goalAngles = ang
}

//wobble our aim around based on our sk1llz
/// Source: oracle/codemp/game/ai_main.c:4687
func BotAimOffsetGoalAngles(_ bs: BotState) {
    var i: Int32
    var accVal: Float
    i = 0

    if bs.skills.perfectaim != 0 {
        return
    }

    if bs.aimOffsetTime > level.time {
        if bs.aimOffsetAmtYaw != 0 {
            bs.goalAngles[YAW] += bs.aimOffsetAmtYaw
        }

        if bs.aimOffsetAmtPitch != 0 {
            bs.goalAngles[PITCH] += bs.aimOffsetAmtPitch
        }

        while i <= 2 {
            if bs.goalAngles[i] > 360 {
                bs.goalAngles[i] -= 360
            }

            if bs.goalAngles[i] < 0 {
                bs.goalAngles[i] += 360
            }

            i += 1
        }
        return
    }

    accVal = bs.skills.accuracy / bs.settings.skill

    if bs.currentEnemy != nil && BotMindTricked(bs.client, bs.currentEnemy!.s.number) != 0 {
        //having to judge where they are by hearing them, so we should be quite inaccurate here
        accVal *= 7

        if accVal < 30 {
            accVal = 30
        }
    }

    if bs.revengeEnemy != nil && bs.revengeHateLevel != 0 && bs.currentEnemy == bs.revengeEnemy {
        //bot becomes more skilled as anger level raises
        accVal = accVal / bs.revengeHateLevel
    }

    if bs.currentEnemy != nil && bs.frame_Enemy_Vis != 0 {
        //assume our goal is aiming at the enemy, seeing as he's visible and all
        if bs.currentEnemy!.s.pos.trDelta[0] == 0 && bs.currentEnemy!.s.pos.trDelta[1] == 0 && bs.currentEnemy!.s.pos.trDelta[2] == 0 {
            accVal = 0 //he's not even moving, so he shouldn't really be hard to hit.
        } else {
            accVal = Float(Double(accVal) + Double(accVal) * 0.25) //if he's moving he's this much harder to hit
        }

        if g_entities[bs.client].s.pos.trDelta[0] != 0 || g_entities[bs.client].s.pos.trDelta[1] != 0 || g_entities[bs.client].s.pos.trDelta[2] != 0 {
            accVal = Float(Double(accVal) + Double(accVal) * 0.15) //make it somewhat harder to aim if we're moving also
        }
    }

    if accVal > 90 {
        accVal = 90
    }
    if accVal < 1 {
        accVal = 0
    }

    if accVal == 0 {
        bs.aimOffsetAmtYaw = 0
        bs.aimOffsetAmtPitch = 0
        return
    }

    // The SDK also declares `rand`, so the call names the bg module.
    if JKAMP_BG.rand() % 10 <= 5 {
        // The SDK also declares `rand`, so the call names the bg module.
        bs.aimOffsetAmtYaw = Float(JKAMP_BG.rand() % Int32(accVal))
    } else {
        // The SDK also declares `rand`, so the call names the bg module.
        bs.aimOffsetAmtYaw = Float(-(JKAMP_BG.rand() % Int32(accVal)))
    }

    // The SDK also declares `rand`, so the call names the bg module.
    if JKAMP_BG.rand() % 10 <= 5 {
        // The SDK also declares `rand`, so the call names the bg module.
        bs.aimOffsetAmtPitch = Float(JKAMP_BG.rand() % Int32(accVal))
    } else {
        // The SDK also declares `rand`, so the call names the bg module.
        bs.aimOffsetAmtPitch = Float(-(JKAMP_BG.rand() % Int32(accVal)))
    }

    // The SDK also declares `rand`, so the call names the bg module.
    bs.aimOffsetTime = Float(level.time + JKAMP_BG.rand() % 500 + 200)
}

//do we want to alt fire with this weapon?
/// Source: oracle/codemp/game/ai_main.c:4804
func ShouldSecondaryFire(_ bs: BotState) -> Int32 {
    let weap: Int32
    let dif: Int32
    var rTime: Float

    weap = bs.cur_ps.weapon

    if bs.cur_ps.ammo[weaponData[weap].ammoIndex] < weaponData[weap].altEnergyPerShot {
        return 0
    }

    if bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT && bs.cur_ps.weapon == WP_ROCKET_LAUNCHER {
        let heldTime: Float = Float((level.time - bs.cur_ps.weaponChargeTime))

        rTime = bs.cur_ps.rocketLockTime

        if rTime < 1 {
            rTime = bs.cur_ps.rocketLastValidTime
        }

        if heldTime > 5000 {
            //just give up and release it if we can't manage a lock in 5 seconds
            return 2
        }

        if rTime > 0 {
            dif = Int32((level.time - rTime) / (1200.0 / 16.0))

            if dif >= 10 {
                return 2
            } else if bs.frame_Enemy_Len > 250 {
                return 1
            }
        } else if bs.frame_Enemy_Len > 250 {
            return 1
        }
    } else if (bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT) && (level.time - bs.cur_ps.weaponChargeTime) > bs.altChargeTime {
        return 2
    } else if bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT {
        return 1
    }

    if weap == WP_BRYAR_PISTOL && bs.frame_Enemy_Len < 300 {
        return 1
    } else if weap == WP_BOWCASTER && bs.frame_Enemy_Len > 300 {
        return 1
    } else if weap == WP_REPEATER && bs.frame_Enemy_Len < 600 && bs.frame_Enemy_Len > 250 {
        return 1
    } else if weap == WP_BLASTER && bs.frame_Enemy_Len < 300 {
        return 1
    } else if weap == WP_ROCKET_LAUNCHER && bs.frame_Enemy_Len > 250 {
        return 1
    }

    return 0
}

//standard weapon combat routines
/// Source: oracle/codemp/game/ai_main.c:4885
func CombatBotAI(_ bs: BotState, _ thinktime: Float) -> Int32 {
    var eorg = vec3_t()
    var a = vec3_t()
    let secFire: Int32
    var fovcheck: Float

    if bs.currentEnemy == nil {
        return 0
    }

    if bs.currentEnemy!.client != nil {
        eorg = bs.currentEnemy!.client!.ps.origin
    } else {
        eorg = bs.currentEnemy!.s.origin
    }

    a = eorg - bs.eye
    vectoangles(a, &a)

    if BotGetWeaponRange(bs) == BWEAPONRANGE_SABER {
        if bs.frame_Enemy_Len <= SABER_ATTACK_RANGE {
            bs.doAttack = 1
        }
    } else if BotGetWeaponRange(bs) == BWEAPONRANGE_MELEE {
        if bs.frame_Enemy_Len <= MELEE_ATTACK_RANGE {
            bs.doAttack = 1
        }
    } else {
        if bs.cur_ps.weapon == WP_THERMAL || bs.cur_ps.weapon == WP_ROCKET_LAUNCHER {
            //be careful with the hurty weapons
            fovcheck = 40

            if bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT && bs.cur_ps.weapon == WP_ROCKET_LAUNCHER {
                //if we're charging the weapon up then we can hold fire down within a normal fov
                fovcheck = 60
            }
        } else {
            fovcheck = 60
        }

        if bs.cur_ps.weaponstate == WEAPON_CHARGING || bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT {
            fovcheck = 160
        }

        if bs.frame_Enemy_Len < 128 {
            fovcheck *= 2
        }

        if InFieldOfVision(bs.viewangles, fovcheck, &a) != 0 {
            if bs.cur_ps.weapon == WP_THERMAL {
                if ((level.time - bs.cur_ps.weaponChargeTime) < (bs.frame_Enemy_Len * 2) && (level.time - bs.cur_ps.weaponChargeTime) < 4000 && bs.frame_Enemy_Len > 64) || (bs.cur_ps.weaponstate != WEAPON_CHARGING && bs.cur_ps.weaponstate != WEAPON_CHARGING_ALT) {
                    if bs.cur_ps.weaponstate != WEAPON_CHARGING && bs.cur_ps.weaponstate != WEAPON_CHARGING_ALT {
                        if bs.frame_Enemy_Len > 512 && bs.frame_Enemy_Len < 800 {
                            bs.doAltAttack = 1
                            //bs->doAttack = 1;
                        } else {
                            bs.doAttack = 1
                            //bs->doAltAttack = 1;
                        }
                    }

                    if bs.cur_ps.weaponstate == WEAPON_CHARGING {
                        bs.doAttack = 1
                    } else if bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT {
                        bs.doAltAttack = 1
                    }
                }
            } else {
                secFire = ShouldSecondaryFire(bs)

                if bs.cur_ps.weaponstate != WEAPON_CHARGING_ALT && bs.cur_ps.weaponstate != WEAPON_CHARGING {
                    bs.altChargeTime = Q_irand(500, 1000)
                }

                if secFire == 1 {
                    bs.doAltAttack = 1
                } else if secFire == 0 {
                    if bs.cur_ps.weapon != WP_THERMAL {
                        if bs.cur_ps.weaponstate != WEAPON_CHARGING || bs.altChargeTime > (level.time - bs.cur_ps.weaponChargeTime) {
                            bs.doAttack = 1
                        }
                    } else {
                        bs.doAttack = 1
                    }
                }

                if secFire == 2 {
                    //released a charge
                    return 1
                }
            }
        }
    }

    return 0
}

//we messed up and got off the normal path, let's fall
//back to jumping around and turning in random
//directions off walls to see if we can get back to a
//good place.
/// Source: oracle/codemp/game/ai_main.c:5029
func BotFallbackNavigation(_ bs: BotState) -> Int32 {
    var b_angle = vec3_t()
    var fwd = vec3_t()
    var trto = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        if bs.currentEnemy != nil && bs.frame_Enemy_Vis != 0 {
            return 2 //we're busy
        }

        mins[0] = -15
        mins[1] = -15
        mins[2] = 0
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 32

        bs.goalAngles[PITCH] = 0
        bs.goalAngles[ROLL] = 0

        b_angle = bs.goalAngles

        // Raven passes NULL for the `right` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(b_angle, &fwd, &scratchRight, &scratchUp)

        trto[0] = bs.origin[0] + fwd[0] * 16
        trto[1] = bs.origin[1] + fwd[1] * 16
        trto[2] = bs.origin[2] + fwd[2] * 16

        trap_Trace(tr, bs.origin, mins, maxs, trto, ENTITYNUM_NONE, MASK_SOLID)

        if tr.fraction == 1 {
            bs.goalPosition = trto
            return 1 //success!
        } else {
            // The SDK also declares `rand`, so the call names the bg module.
            bs.goalAngles[YAW] = Float(JKAMP_BG.rand() % 360)
        }

        return 0
    }
}

/// Source: oracle/codemp/game/ai_main.c:5072
func BotTryAnotherWeapon(_ bs: BotState) -> Int32 {
    //out of ammo, resort to the first weapon we come across that has ammo
    var i: Int32

    i = 1

    while i < WP_NUM_WEAPONS {
        if bs.cur_ps.ammo[weaponData[i].ammoIndex] >= weaponData[i].energyPerShot && (bs.cur_ps.stats[STAT_WEAPONS] & (1 << i)) != 0 {
            bs.virtualWeapon = i
            BotSelectWeapon(bs.client, i)
            //bs->cur_ps.weapon = i;
            //level.clients[bs->client].ps.weapon = i;
            return 1
        }

        i += 1
    }

    if bs.cur_ps.weapon != 1 && bs.virtualWeapon != 1 {
        //should always have this.. shouldn't we?
        bs.virtualWeapon = 1
        BotSelectWeapon(bs.client, 1)
        //bs->cur_ps.weapon = 1;
        //level.clients[bs->client].ps.weapon = 1;
        return 1
    }

    return 0
}

//is this weapon available to us?
/// Source: oracle/codemp/game/ai_main.c:5106
func BotWeaponSelectable(_ bs: BotState, _ weapon: Int32) -> Bool {
    if weapon == WP_NONE {
        return false
    }

    if bs.cur_ps.ammo[weaponData[weapon].ammoIndex] >= weaponData[weapon].energyPerShot && (bs.cur_ps.stats[STAT_WEAPONS] & (1 << weapon)) != 0 {
        return true
    }

    return false
}

//select the best weapon we can
/// Source: oracle/codemp/game/ai_main.c:5123
func BotSelectIdealWeapon(_ bs: BotState) -> Int32 {
    var i: Int32
    var bestweight: Int32 = -1
    var bestweapon: Int32 = 0

    i = 0

    while i < WP_NUM_WEAPONS {
        if bs.cur_ps.ammo[weaponData[i].ammoIndex] >= weaponData[i].energyPerShot && bs.botWeaponWeights[i] > bestweight && (bs.cur_ps.stats[STAT_WEAPONS] & (1 << i)) != 0 {
            if i == WP_THERMAL {
                //special case..
                if bs.currentEnemy != nil && bs.frame_Enemy_Len < 700 {
                    bestweight = Int32(bs.botWeaponWeights[i])
                    bestweapon = i
                }
            } else {
                bestweight = Int32(bs.botWeaponWeights[i])
                bestweapon = i
            }
        }

        i += 1
    }

    if bs.currentEnemy != nil && bs.frame_Enemy_Len < 300 && (bestweapon == WP_BRYAR_PISTOL || bestweapon == WP_BLASTER || bestweapon == WP_BOWCASTER) && (bs.cur_ps.stats[STAT_WEAPONS] & (1 << WP_SABER)) != 0 {
        bestweapon = WP_SABER
        bestweight = 1
    }

    if bs.currentEnemy != nil && bs.frame_Enemy_Len > 300 && bs.currentEnemy!.client != nil && bs.currentEnemy!.client!.ps.weapon != WP_SABER && (bestweapon == WP_SABER) {
        //if the enemy is far away, and we have our saber selected, see if we have any good distance weapons instead
        if BotWeaponSelectable(bs, WP_DISRUPTOR) {
            bestweapon = WP_DISRUPTOR
            bestweight = 1
        } else if BotWeaponSelectable(bs, WP_ROCKET_LAUNCHER) {
            bestweapon = WP_ROCKET_LAUNCHER
            bestweight = 1
        } else if BotWeaponSelectable(bs, WP_BOWCASTER) {
            bestweapon = WP_BOWCASTER
            bestweight = 1
        } else if BotWeaponSelectable(bs, WP_BLASTER) {
            bestweapon = WP_BLASTER
            bestweight = 1
        } else if BotWeaponSelectable(bs, WP_REPEATER) {
            bestweapon = WP_REPEATER
            bestweight = 1
        } else if BotWeaponSelectable(bs, WP_DEMP2) {
            bestweapon = WP_DEMP2
            bestweight = 1
        }
    }

    //assert(bs->cur_ps.weapon > 0 && bestweapon > 0);

    if bestweight != -1 && bs.cur_ps.weapon != bestweapon && bs.virtualWeapon != bestweapon {
        bs.virtualWeapon = bestweapon
        BotSelectWeapon(bs.client, bestweapon)
        //bs->cur_ps.weapon = bestweapon;
        //level.clients[bs->client].ps.weapon = bestweapon;
        return 1
    }

    //assert(bs->cur_ps.weapon > 0);

    return 0
}

//check/select the chosen weapon
/// Source: oracle/codemp/game/ai_main.c:5216
func BotSelectChoiceWeapon(_ bs: BotState, _ weapon: Int32, _ doselection: Int32) -> Int32 {
    //if !doselection then bot will only check if he has the specified weapon and return 1 (yes) or 0 (no)
    var i: Int32
    var hasit: Int32 = 0

    i = 0

    while i < WP_NUM_WEAPONS {
        if bs.cur_ps.ammo[weaponData[i].ammoIndex] > weaponData[i].energyPerShot && i == weapon && (bs.cur_ps.stats[STAT_WEAPONS] & (1 << i)) != 0 {
            hasit = 1
            break
        }

        i += 1
    }

    if hasit != 0 && bs.cur_ps.weapon != weapon && doselection != 0 && bs.virtualWeapon != weapon {
        bs.virtualWeapon = weapon
        BotSelectWeapon(bs.client, weapon)
        //bs->cur_ps.weapon = weapon;
        //level.clients[bs->client].ps.weapon = weapon;
        return 2
    }

    if hasit != 0 {
        return 1
    }

    return 0
}

//override our standard weapon choice with a melee weapon
/// Source: oracle/codemp/game/ai_main.c:5254
func BotSelectMelee(_ bs: BotState) -> Int32 {
    if bs.cur_ps.weapon != 1 && bs.virtualWeapon != 1 {
        bs.virtualWeapon = 1
        BotSelectWeapon(bs.client, 1)
        //bs->cur_ps.weapon = 1;
        //level.clients[bs->client].ps.weapon = 1;
        return 1
    }

    return 0
}

//See if we our in love with the potential bot.
/// Source: oracle/codemp/game/ai_main.c:5269
func GetLoveLevel(_ bs: BotState, _ love: BotState) -> Int32 {
    var i: Int32 = 0
    var lname: String? = nil

    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        //There is no love in 1-on-1
        return 0
    }

    if g_entities[love.client].client == nil {
        return 0
    }

    if bs.lovednum == 0 {
        return 0
    }

    if bot_attachments.integer == 0 {
        return 1
    }

    lname = g_entities[love.client].client!.pers.netname

    if lname == nil {
        return 0
    }

    while i < bs.lovednum {
        if strcmp(bs.loved[i].name, lname!) == 0 {
            return bs.loved[i].level
        }

        i += 1
    }

    return 0
}

//Our loved one was killed. We must become infuriated!
/// Source: oracle/codemp/game/ai_main.c:5315
func BotLovedOneDied(_ bs: BotState, _ loved: BotState, _ lovelevel: Int32) {
    if loved.lastHurt == nil || loved.lastHurt!.client == nil || loved.lastHurt!.s.number == loved.client {
        return
    }

    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        //There is no love in 1-on-1
        return
    }

    if IsTeamplay() == 0 {
        if lovelevel < 2 {
            return
        }
    } else if OnSameTeam(g_entities[bs.client], loved.lastHurt!) {
        //don't hate teammates no matter what
        return
    }

    if loved.client == loved.lastHurt!.s.number {
        return
    }

    if bs.client == loved.lastHurt!.s.number {
        //oops!
        return
    }

    if bot_attachments.integer == 0 {
        return
    }

    if PassLovedOneCheck(bs, loved.lastHurt!) == 0 {
        //a loved one killed a loved one.. you cannot hate them
        bs.chatObject = loved.lastHurt
        bs.chatAltObject = g_entities[loved.client]
        BotDoChat(bs, "LovedOneKilledLovedOne", 0)
        return
    }

    if bs.revengeEnemy == loved.lastHurt {
        if bs.revengeHateLevel < bs.loved_death_thresh {
            bs.revengeHateLevel += 1

            if bs.revengeHateLevel == bs.loved_death_thresh {
                //broke into the highest anger level
                //CHAT: Hatred section
                bs.chatObject = loved.lastHurt
                bs.chatAltObject = nil
                BotDoChat(bs, "Hatred", 1)
            }
        }
    } else if bs.revengeHateLevel < bs.loved_death_thresh - 1 {
        //only switch hatred if we don't hate the existing revenge-enemy too much
        //CHAT: BelovedKilled section
        bs.chatObject = g_entities[loved.client]
        bs.chatAltObject = loved.lastHurt
        BotDoChat(bs, "BelovedKilled", 0)
        bs.revengeHateLevel = 0
        bs.revengeEnemy = loved.lastHurt
    }
}

/// Source: oracle/codemp/game/ai_main.c:5390
func BotDeathNotify(_ bs: BotState) {
    //in case someone has an emotional attachment to us, we'll notify them
    var i: Int32 = 0
    var ltest: Int32 = 0

    while i < MAX_CLIENTS {
        if botstates[i] != nil && botstates[i]!.lovednum != 0 {
            ltest = 0
            while ltest < botstates[i]!.lovednum {
                if strcmp(level.clientsSlots[bs.client].pers.netname, botstates[i]!.loved[ltest].name) == 0 {
                    BotLovedOneDied(botstates[i]!, bs, botstates[i]!.loved[ltest].level)
                    break
                }

                ltest += 1
            }
        }

        i += 1
    }
}

//perform strafe trace checks
/// Source: oracle/codemp/game/ai_main.c:5417
func StrafeTracing(_ bs: BotState) {
    var mins = vec3_t()
    var maxs = vec3_t()
    var right = vec3_t()
    var rorg = vec3_t()
    var drorg = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in

        mins[0] = -15
        mins[1] = -15
        //mins[2] = -24;
        mins[2] = -22
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 32

        // Raven passes NULL for the `forward` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchForward = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(bs.viewangles, &scratchForward, &right, &scratchUp)

        if bs.meleeStrafeDir != 0 {
            rorg[0] = bs.origin[0] - right[0] * 32
            rorg[1] = bs.origin[1] - right[1] * 32
            rorg[2] = bs.origin[2] - right[2] * 32
        } else {
            rorg[0] = bs.origin[0] + right[0] * 32
            rorg[1] = bs.origin[1] + right[1] * 32
            rorg[2] = bs.origin[2] + right[2] * 32
        }

        trap_Trace(tr, bs.origin, mins, maxs, rorg, bs.client, MASK_SOLID)

        if tr.fraction != 1 {
            bs.meleeStrafeDisable = Float(level.time + Q_irand(500, 1500))
        }

        drorg = rorg

        drorg[2] -= 32

        trap_Trace(tr, rorg, vec3_origin, vec3_origin, drorg, bs.client, MASK_SOLID)

        if tr.fraction == 1 {
            //this may be a dangerous ledge, so don't strafe over it just in case
            bs.meleeStrafeDisable = Float(level.time + Q_irand(500, 1500))
        }
    }
}

//doing primary weapon fire
/// Source: oracle/codemp/game/ai_main.c:5466
func PrimFiring(_ bs: BotState) -> Int32 {
    if bs.cur_ps.weaponstate != WEAPON_CHARGING && bs.doAttack != 0 {
        return 1
    }

    if bs.cur_ps.weaponstate == WEAPON_CHARGING && bs.doAttack == 0 {
        return 1
    }

    return 0
}

//should we keep our primary weapon from firing?
/// Source: oracle/codemp/game/ai_main.c:5484
func KeepPrimFromFiring(_ bs: BotState) -> Int32 {
    if bs.cur_ps.weaponstate != WEAPON_CHARGING && bs.doAttack != 0 {
        bs.doAttack = 0
    }

    if bs.cur_ps.weaponstate == WEAPON_CHARGING && bs.doAttack == 0 {
        bs.doAttack = 1
    }

    return 0
}

//doing secondary weapon fire
/// Source: oracle/codemp/game/ai_main.c:5502
func AltFiring(_ bs: BotState) -> Int32 {
    if bs.cur_ps.weaponstate != WEAPON_CHARGING_ALT && bs.doAltAttack != 0 {
        return 1
    }

    if bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT && bs.doAltAttack == 0 {
        return 1
    }

    return 0
}

//should we keep our alt from firing?
/// Source: oracle/codemp/game/ai_main.c:5520
func KeepAltFromFiring(_ bs: BotState) -> Int32 {
    if bs.cur_ps.weaponstate != WEAPON_CHARGING_ALT && bs.doAltAttack != 0 {
        bs.doAltAttack = 0
    }

    if bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT && bs.doAltAttack == 0 {
        bs.doAltAttack = 1
    }

    return 0
}

//Try not to shoot our friends in the back. Or in the face. Or anywhere, really.
/// Source: oracle/codemp/game/ai_main.c:5538
func CheckForFriendInLOF(_ bs: BotState) -> Entity? {
    var fwd = vec3_t()
    var trfrom = vec3_t()
    var trto = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    var trent: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Entity? in

        mins[0] = -3
        mins[1] = -3
        mins[2] = -3

        maxs[0] = 3
        maxs[1] = 3
        maxs[2] = 3

        // Raven passes NULL for the `right` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(bs.viewangles, &fwd, &scratchRight, &scratchUp)

        trfrom = bs.eye

        trto[0] = trfrom[0] + fwd[0] * 2048
        trto[1] = trfrom[1] + fwd[1] * 2048
        trto[2] = trfrom[2] + fwd[2] * 2048

        trap_Trace(tr, trfrom, mins, maxs, trto, bs.client, MASK_PLAYERSOLID)

        if tr.fraction != 1 && tr.entityNum <= MAX_CLIENTS {
            trent = g_entities[tr.entityNum]

            if trent != nil && trent!.client != nil {
                if IsTeamplay() != 0 && OnSameTeam(g_entities[bs.client], trent!) {
                    return trent
                }

                if botstates[trent!.s.number] != nil && GetLoveLevel(bs, botstates[trent!.s.number]!) > 1 {
                    return trent
                }
            }
        }

        return nil
    }
}

/// Source: oracle/codemp/game/ai_main.c:5585
func BotScanForLeader(_ bs: BotState) {
    //bots will only automatically obtain a leader if it's another bot using this method.
    var i: Int32 = 0
    var ent: Entity?

    if bs.isSquadLeader != 0 {
        return
    }

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && botstates[i] != nil && botstates[i]!.isSquadLeader != 0 && bs.client != i {
            if OnSameTeam(g_entities[bs.client], ent!) {
                bs.squadLeader = ent
                break
            }
            if GetLoveLevel(bs, botstates[i]!) > 1 && IsTeamplay() == 0 {
                //ignore love status regarding squad leaders if we're in teamplay
                bs.squadLeader = ent
                break
            }
        }

        i += 1
    }
}

//w3rd to the p33pz.
/// Source: oracle/codemp/game/ai_main.c:5618
func BotReplyGreetings(_ bs: BotState) {
    var i: Int32 = 0
    var numhello: Int32 = 0

    while i < MAX_CLIENTS {
        if botstates[i] != nil && botstates[i]!.canChat != 0 && i != bs.client {
            botstates[i]!.chatObject = g_entities[bs.client]
            botstates[i]!.chatAltObject = nil
            if BotDoChat(botstates[i]!, "ResponseGreetings", 0) != 0 {
                numhello += 1
            }
        }

        if numhello > 3 {
            //don't let more than 4 bots say hello at once
            return
        }

        i += 1
    }
}

//try to move in to grab a nearby flag
/// Source: oracle/codemp/game/ai_main.c:5647
func CTFFlagMovement(_ bs: BotState) {
    var diddrop: Int32 = 0
    var desiredDrop: Entity? = nil
    var a = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        mins[0] = -15
        mins[1] = -15
        mins[2] = -7
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 7

        if bs.wantFlag != nil && (bs.wantFlag!.flags & FL_DROPPED_ITEM) != 0 {
            if bs.staticFlagSpot[0] == bs.wantFlag!.s.pos.trBase[0] && bs.staticFlagSpot[1] == bs.wantFlag!.s.pos.trBase[1] && bs.staticFlagSpot[2] == bs.wantFlag!.s.pos.trBase[2] {
                a = bs.origin - bs.wantFlag!.s.pos.trBase

                if VectorLength(a) <= BOT_FLAG_GET_DISTANCE {
                    bs.goalPosition = bs.wantFlag!.s.pos.trBase
                    return true
                } else {
                    bs.wantFlag = nil
                }
            } else {
                bs.wantFlag = nil
            }
        } else if bs.wantFlag != nil {
            bs.wantFlag = nil
        }

        if flagRed != nil && flagBlue != nil {
            if bs.wpDestination == flagRed || bs.wpDestination == flagBlue {
                if bs.wpDestination == flagRed && droppedRedFlag != nil && (droppedRedFlag!.flags & FL_DROPPED_ITEM) != 0 && droppedRedFlag!.classname != nil && strcmp(droppedRedFlag!.classname!, "freed") != 0 {
                    desiredDrop = droppedRedFlag
                    diddrop = 1
                }
                if bs.wpDestination == flagBlue && droppedBlueFlag != nil && (droppedBlueFlag!.flags & FL_DROPPED_ITEM) != 0 && droppedBlueFlag!.classname != nil && strcmp(droppedBlueFlag!.classname!, "freed") != 0 {
                    desiredDrop = droppedBlueFlag
                    diddrop = 1
                }

                if diddrop != 0 && desiredDrop != nil {
                    a = bs.origin - desiredDrop!.s.pos.trBase

                    if VectorLength(a) <= BOT_FLAG_GET_DISTANCE {
                        trap_Trace(tr, bs.origin, mins, maxs, desiredDrop!.s.pos.trBase, bs.client, MASK_SOLID)

                        if tr.fraction == 1 || tr.entityNum == desiredDrop!.s.number {
                            bs.goalPosition = desiredDrop!.s.pos.trBase
                            bs.staticFlagSpot = desiredDrop!.s.pos.trBase
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

//see if we want to make our detpacks blow up
/// Source: oracle/codemp/game/ai_main.c:5726
func BotCheckDetPacks(_ bs: BotState) {
    var dp: Entity? = nil
    var myDet: Entity? = nil
    var a = vec3_t()
    let enLen: Float
    let myLen: Float

    stillmadeit: do {
        while let next = G_Find(dp, \.classname, "detpack") {
            dp = next
            if dp != nil && dp!.parent != nil && dp!.parent!.s.number == bs.client {
                myDet = dp
                break
            }
        }

        if myDet == nil {
            return
        }

        if bs.currentEnemy == nil || bs.currentEnemy!.client == nil || bs.frame_Enemy_Vis == 0 {
            //require the enemy to be visilbe just to be fair..

            //unless..
            if bs.currentEnemy != nil && bs.currentEnemy!.client != nil && (level.time - bs.plantContinue) < 5000 {
                //it's a fresh plant (within 5 seconds) so we should be able to guess
                break stillmadeit
            }
            return
        }

    }

    a = bs.currentEnemy!.client!.ps.origin - myDet!.s.pos.trBase
    enLen = VectorLength(a)

    a = bs.origin - myDet!.s.pos.trBase
    myLen = VectorLength(a)

    if enLen > myLen {
        return
    }

    if enLen < BOT_PLANT_BLOW_DISTANCE && OrgVisible(bs.currentEnemy!.client!.ps.origin, myDet!.s.pos.trBase, bs.currentEnemy!.s.number) != 0 {
        //we could just call the "blow all my detpacks" function here, but I guess that's cheating.
        bs.plantKillEmAll = level.time + 500
    }
}

//see if it would be beneficial at this time to use one of our inv items
/// Source: oracle/codemp/game/ai_main.c:5780
func BotUseInventoryItem(_ bs: BotState) -> Int32 {
    wantuseitem: do {
        if (bs.cur_ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_MEDPAC)) != 0 {
            if g_entities[bs.client].health <= 75 {
                bs.cur_ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(HI_MEDPAC, IT_HOLDABLE)
                break wantuseitem
            }
        }
        if (bs.cur_ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_MEDPAC_BIG)) != 0 {
            if g_entities[bs.client].health <= 50 {
                bs.cur_ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(HI_MEDPAC_BIG, IT_HOLDABLE)
                break wantuseitem
            }
        }
        if (bs.cur_ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_SEEKER)) != 0 {
            if bs.currentEnemy != nil && bs.frame_Enemy_Vis != 0 {
                bs.cur_ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(HI_SEEKER, IT_HOLDABLE)
                break wantuseitem
            }
        }
        if (bs.cur_ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_SENTRY_GUN)) != 0 {
            if bs.currentEnemy != nil && bs.frame_Enemy_Vis != 0 {
                bs.cur_ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(HI_SENTRY_GUN, IT_HOLDABLE)
                break wantuseitem
            }
        }
        if (bs.cur_ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_SHIELD)) != 0 {
            if bs.currentEnemy != nil && bs.frame_Enemy_Vis != 0 && bs.runningToEscapeThreat != 0 {
                //this will (hopefully) result in the bot placing the shield down while facing
                //the enemy and running away
                bs.cur_ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(HI_SHIELD, IT_HOLDABLE)
                break wantuseitem
            }
        }

        return 0

    }
    level.clientsSlots[bs.client].ps.stats[STAT_HOLDABLE_ITEM] = bs.cur_ps.stats[STAT_HOLDABLE_ITEM]

    return 1
}

//trace forward to see if we can plant a detpack or something
/// Source: oracle/codemp/game/ai_main.c:5833
func BotSurfaceNear(_ bs: BotState) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var fwd = vec3_t()

        // Raven passes NULL for the `right` and `up` outputs, and AngleVectors skips the write for a NULL output.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(bs.viewangles, &fwd, &scratchRight, &scratchUp)

        fwd[0] = bs.origin[0] + (fwd[0] * 64)
        fwd[1] = bs.origin[1] + (fwd[1] * 64)
        fwd[2] = bs.origin[2] + (fwd[2] * 64)

        trap_Trace(tr, bs.origin, vec3_origin, vec3_origin, fwd, bs.client, MASK_SOLID)

        if tr.fraction != 1 {
            return 1
        }

        return 0
    }
}

//could we block projectiles from the weapon potentially with a light saber?
/// Source: oracle/codemp/game/ai_main.c:5855
func BotWeaponBlockable(_ weapon: Int32) -> Int32 {
    switch weapon {
    case WP_STUN_BATON, WP_MELEE:
        return 0

    case WP_DISRUPTOR:
        return 0

    case WP_DEMP2:
        return 0

    case WP_ROCKET_LAUNCHER:
        return 0

    case WP_THERMAL:
        return 0

    case WP_TRIP_MINE:
        return 0

    case WP_DET_PACK:
        return 0

    default:
        return 1
    }
}

//movement overrides
/// Source: oracle/codemp/game/ai_main.c:5883
func Bot_SetForcedMovement(_ bot: Int32, _ forward: Int32, _ right: Int32, _ up: Int32) {
    var bs: BotState?

    bs = botstates[bot]

    if bs == nil {
        //not a bot
        return
    }

    if forward != -1 {
        if bs!.forceMove_Forward != 0 {
            bs!.forceMove_Forward = 0
        } else {
            bs!.forceMove_Forward = forward
        }
    }
    if right != -1 {
        if bs!.forceMove_Right != 0 {
            bs!.forceMove_Right = 0
        } else {
            bs!.forceMove_Right = right
        }
    }
    if up != -1 {
        if bs!.forceMove_Up != 0 {
            bs!.forceMove_Up = 0
        } else {
            bs!.forceMove_Up = up
        }
    }
}

//the main AI loop.
//please don't be too frightened.
/// Source: oracle/codemp/game/ai_main.c:5931
func StandardBotAI(_ bs: BotState, _ thinktime: Float) {
    let wp: Int32
    let enemy: Int32
    let desiredIndex: Int32
    let goalWPIndex: Int32
    var doingFallback: Int32 = 0
    var fjHalt: Int32
    var a = vec3_t()
    var ang = vec3_t()
    var headlevel = vec3_t()
    var eorg = vec3_t()
    var noz_x = vec3_t()
    var noz_y = vec3_t()
    var dif = vec3_t()
    var a_fo = vec3_t()
    var reaction: Float
    let bLeadAmount: Float
    var meleestrafe: Int32 = 0
    var useTheForce: Int32 = 0
    var forceHostile: Int32 = 0
    var cBAI: Int32 = 0
    var friendInLOF: Entity? = nil
    let mLen: Float
    var visResult: Int32 = 0
    var selResult: Int32 = 0
    var mineSelect: Int32 = 0
    var detSelect: Int32 = 0
    var preFrameGAngles = vec3_t()

    if gDeactivated != 0 {
        bs.wpCurrent = nil
        bs.currentEnemy = nil
        bs.wpDestination = nil
        bs.wpDirection = 0
        return
    }

    if g_entities[bs.client].inuse && g_entities[bs.client].client != nil && g_entities[bs.client].client!.sess.sessionTeam == TEAM_SPECTATOR {
        bs.wpCurrent = nil
        bs.currentEnemy = nil
        bs.wpDestination = nil
        bs.wpDirection = 0
        return
    }


    if bot_getinthecarrr.integer != 0 {
        //stupid vehicle debug, I tire of having to connect another client to test passengers.
        let botEnt: Entity? = g_entities[bs.client]

        if botEnt!.inuse && botEnt!.client != nil && botEnt!.client!.ps.m_iVehicleNum != 0 {
            //in a vehicle, so...
            bs.noUseTime = level.time + 5000

            if bot_getinthecarrr.integer != 2 {
                trap_EA_MoveForward(bs.client)

                if bot_getinthecarrr.integer == 3 {
                    //use alt fire
                    trap_EA_Alt_Attack(bs.client)
                }
            }
        } else {
            //find one, get in
            var i: Int32 = 0
            var vehicle: Entity? = nil
            //find the nearest, manned vehicle
            while i < MAX_GENTITIES {
                vehicle = g_entities[i]

                if vehicle!.inuse && vehicle!.client != nil && vehicle!.s.eType == ET_NPC && vehicle!.s.NPC_class == CLASS_VEHICLE && vehicle!.m_pVehicle != nil && (vehicle!.client!.ps.m_iVehicleNum != 0 || bot_getinthecarrr.integer == 2) {
                    //ok, this is a vehicle, and it has a pilot/passengers
                    break
                }
                i += 1
            }
            if i != MAX_GENTITIES && vehicle != nil {
                //broke before end so we must've found something
                var v = vec3_t()

                v = vehicle!.client!.ps.origin - bs.origin
                VectorNormalize(&v)
                vectoangles(v, &bs.goalAngles)
                MoveTowardIdealAngles(bs)
                trap_EA_Move(bs.client, &v, 5000.0)

                if bs.noUseTime < (level.time - 400) {
                    bs.noUseTime = level.time + 500
                }
            }
        }

        return
    }

    if bot_forgimmick.integer != 0 {
        bs.wpCurrent = nil
        bs.currentEnemy = nil
        bs.wpDestination = nil
        bs.wpDirection = 0

        if bot_forgimmick.integer == 2 {
            //for debugging saber stuff, this is handy
            trap_EA_Attack(bs.client)
        }

        if bot_forgimmick.integer == 3 {
            //for testing cpu usage moving around rmg terrain without AI
            var mdir = vec3_t()

            mdir = bs.origin - vec3_origin
            VectorNormalize(&mdir)
            trap_EA_Attack(bs.client)
            trap_EA_Move(bs.client, &mdir, 5000)
        }

        if bot_forgimmick.integer == 4 {
            //constantly move toward client 0
            if g_entities[0].client != nil && g_entities[0].inuse {
                var mdir = vec3_t()

                mdir = g_entities[0].client!.ps.origin - bs.origin
                VectorNormalize(&mdir)
                trap_EA_Move(bs.client, &mdir, 5000)
            }
        }

        if bs.forceMove_Forward != 0 {
            if bs.forceMove_Forward > 0 {
                trap_EA_MoveForward(bs.client)
            } else {
                trap_EA_MoveBack(bs.client)
            }
        }
        if bs.forceMove_Right != 0 {
            if bs.forceMove_Right > 0 {
                trap_EA_MoveRight(bs.client)
            } else {
                trap_EA_MoveLeft(bs.client)
            }
        }
        if bs.forceMove_Up != 0 {
            trap_EA_Jump(bs.client)
        }
        return
    }

    if bs.lastDeadTime == 0 {
        //just spawned in?
        bs.lastDeadTime = level.time
    }

    if g_entities[bs.client].health < 1 {
        bs.lastDeadTime = level.time

        if bs.deathActivitiesDone == 0 && bs.lastHurt != nil && bs.lastHurt!.client != nil && bs.lastHurt!.s.number != bs.client {
            BotDeathNotify(bs)
            if PassLovedOneCheck(bs, bs.lastHurt!) != 0 {
                //CHAT: Died
                bs.chatObject = bs.lastHurt
                bs.chatAltObject = nil
                BotDoChat(bs, "Died", 0)
            } else if PassLovedOneCheck(bs, bs.lastHurt!) == 0 && botstates[bs.lastHurt!.s.number] != nil && PassLovedOneCheck(botstates[bs.lastHurt!.s.number]!, g_entities[bs.client]) != 0 {
                //killed by a bot that I love, but that does not love me
                bs.chatObject = bs.lastHurt
                bs.chatAltObject = nil
                BotDoChat(bs, "KilledOnPurposeByLove", 0)
            }

            bs.deathActivitiesDone = 1
        }

        bs.wpCurrent = nil
        bs.currentEnemy = nil
        bs.wpDestination = nil
        bs.wpCamping = nil
        bs.wpCampingTo = nil
        bs.wpStoreDest = nil
        bs.wpDestIgnoreTime = 0
        bs.wpDestSwitchTime = 0
        bs.wpSeenTime = 0
        bs.wpDirection = 0

        // The SDK also declares `rand`, so the call names the bg module.
        if JKAMP_BG.rand() % 10 < 5 && (bs.doChat == 0 || bs.chatTime < level.time) {
            trap_EA_Attack(bs.client)
        }

        return
    }

    preFrameGAngles = bs.goalAngles

    bs.doAttack = 0
    bs.doAltAttack = 0
    //reset the attack states

    if bs.isSquadLeader != 0 {
        CommanderBotAI(bs)
    } else {
        BotDoTeamplayAI(bs)
    }

    if bs.currentEnemy == nil {
        bs.frame_Enemy_Vis = 0
    }

    if bs.revengeEnemy != nil && bs.revengeEnemy!.client != nil && bs.revengeEnemy!.client!.pers.connected != CA_ACTIVE && bs.revengeEnemy!.client!.pers.connected != CA_AUTHORIZING {
        bs.revengeEnemy = nil
        bs.revengeHateLevel = 0
    }

    if bs.currentEnemy != nil && bs.currentEnemy!.client != nil && bs.currentEnemy!.client!.pers.connected != CA_ACTIVE && bs.currentEnemy!.client!.pers.connected != CA_AUTHORIZING {
        bs.currentEnemy = nil
    }

    fjHalt = 0

    if bs.forceJumpChargeTime > level.time {
        useTheForce = 1
        forceHostile = 0
    }

    if bs.currentEnemy != nil && bs.currentEnemy!.client != nil && bs.frame_Enemy_Vis != 0 && bs.forceJumpChargeTime < level.time {
        a_fo = bs.currentEnemy!.client!.ps.origin - bs.eye
        vectoangles(a_fo, &a_fo)

        //do this above all things
        if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_PUSH)) != 0 && (bs.doForcePush > level.time || bs.cur_ps.fd.forceGripBeingGripped > level.time) && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_PUSH]][FP_PUSH] {
            level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_PUSH
            useTheForce = 1
            forceHostile = 1
        } else if bs.cur_ps.fd.forceSide == FORCE_DARKSIDE {
            //try dark side powers
            //in order of priority top to bottom
            if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_GRIP)) != 0 && (bs.cur_ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 && InFieldOfVision(bs.viewangles, 50, &a_fo) != 0 {
                //already gripping someone, so hold it
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_GRIP
                useTheForce = 1
                forceHostile = 1
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_LIGHTNING)) != 0 && bs.frame_Enemy_Len < FORCE_LIGHTNING_RADIUS && level.clientsSlots[bs.client].ps.fd.forcePower > 50 && InFieldOfVision(bs.viewangles, 50, &a_fo) != 0 {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_LIGHTNING
                useTheForce = 1
                forceHostile = 1
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_GRIP)) != 0 && bs.frame_Enemy_Len < MAX_GRIP_DISTANCE && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_GRIP]][FP_GRIP] && InFieldOfVision(bs.viewangles, 50, &a_fo) != 0 {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_GRIP
                useTheForce = 1
                forceHostile = 1
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_RAGE)) != 0 && g_entities[bs.client].health < 25 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_RAGE]][FP_RAGE] {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_RAGE
                useTheForce = 1
                forceHostile = 0
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_DRAIN)) != 0 && bs.frame_Enemy_Len < MAX_DRAIN_DISTANCE && level.clientsSlots[bs.client].ps.fd.forcePower > 50 && InFieldOfVision(bs.viewangles, 50, &a_fo) != 0 && bs.currentEnemy!.client!.ps.fd.forcePower > 10 && bs.currentEnemy!.client!.ps.fd.forceSide == FORCE_LIGHTSIDE {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_DRAIN
                useTheForce = 1
                forceHostile = 1
            }
        } else if bs.cur_ps.fd.forceSide == FORCE_LIGHTSIDE {
            //try light side powers
            if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_ABSORB)) != 0 && bs.cur_ps.fd.forceGripCripple != 0 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_ABSORB]][FP_ABSORB] {
                //absorb to get out
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_ABSORB
                useTheForce = 1
                forceHostile = 0
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_ABSORB)) != 0 && bs.cur_ps.electrifyTime >= level.time && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_ABSORB]][FP_ABSORB] {
                //absorb lightning
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_ABSORB
                useTheForce = 1
                forceHostile = 0
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_TELEPATHY)) != 0 && bs.frame_Enemy_Len < MAX_TRICK_DISTANCE && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_TELEPATHY]][FP_TELEPATHY] && InFieldOfVision(bs.viewangles, 50, &a_fo) != 0 && !((bs.currentEnemy!.client!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0) {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_TELEPATHY
                useTheForce = 1
                forceHostile = 1
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_ABSORB)) != 0 && g_entities[bs.client].health < 75 && bs.currentEnemy!.client!.ps.fd.forceSide == FORCE_DARKSIDE && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_ABSORB]][FP_ABSORB] {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_ABSORB
                useTheForce = 1
                forceHostile = 0
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_PROTECT)) != 0 && g_entities[bs.client].health < 35 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_PROTECT]][FP_PROTECT] {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_PROTECT
                useTheForce = 1
                forceHostile = 0
            }
        }

        if useTheForce == 0 {
            //try neutral powers
            if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_PUSH)) != 0 && bs.cur_ps.fd.forceGripBeingGripped > level.time && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_PUSH]][FP_PUSH] && InFieldOfVision(bs.viewangles, 50, &a_fo) != 0 {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_PUSH
                useTheForce = 1
                forceHostile = 1
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_SPEED)) != 0 && g_entities[bs.client].health < 25 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_SPEED]][FP_SPEED] {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_SPEED
                useTheForce = 1
                forceHostile = 0
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_SEE)) != 0 && BotMindTricked(bs.client, bs.currentEnemy!.s.number) != 0 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_SEE]][FP_SEE] {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_SEE
                useTheForce = 1
                forceHostile = 0
            } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_PULL)) != 0 && bs.frame_Enemy_Len < 256 && level.clientsSlots[bs.client].ps.fd.forcePower > 75 && InFieldOfVision(bs.viewangles, 50, &a_fo) != 0 {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_PULL
                useTheForce = 1
                forceHostile = 1
            }
        }
    }

    if useTheForce == 0 {
        //try powers that we don't care if we have an enemy for
        if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_HEAL)) != 0 && g_entities[bs.client].health < 50 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_HEAL]][FP_HEAL] && bs.cur_ps.fd.forcePowerLevel[FP_HEAL] > FORCE_LEVEL_1 {
            level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_HEAL
            useTheForce = 1
            forceHostile = 0
        } else if (bs.cur_ps.fd.forcePowersKnown & (1 << FP_HEAL)) != 0 && g_entities[bs.client].health < 50 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_HEAL]][FP_HEAL] && bs.currentEnemy == nil && bs.isCamping > level.time {
            //only meditate and heal if we're camping
            level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_HEAL
            useTheForce = 1
            forceHostile = 0
        }
    }

    if useTheForce != 0 && forceHostile != 0 {
        if bs.currentEnemy != nil && bs.currentEnemy!.client != nil && ForcePowerUsableOn(g_entities[bs.client], bs.currentEnemy!, level.clientsSlots[bs.client].ps.fd.forcePowerSelected) == 0 {
            useTheForce = 0
            forceHostile = 0
        }
    }

    doingFallback = 0

    bs.deathActivitiesDone = 0

    if BotUseInventoryItem(bs) != 0 {
        // The SDK also declares `rand`, so the call names the bg module.
        if JKAMP_BG.rand() % 10 < 5 {
            trap_EA_Use(bs.client)
        }
    }

    if bs.cur_ps.ammo[weaponData[bs.cur_ps.weapon].ammoIndex] < weaponData[bs.cur_ps.weapon].energyPerShot {
        if BotTryAnotherWeapon(bs) != 0 {
            return
        }
    } else {
        if bs.currentEnemy != nil && bs.lastVisibleEnemyIndex == bs.currentEnemy!.s.number && bs.frame_Enemy_Vis != 0 && bs.forceWeaponSelect != 0 {
            bs.forceWeaponSelect = 0
        }

        if bs.plantContinue > level.time {
            bs.doAttack = 1
            bs.destinationGrabTime = 0
        }

        if bs.forceWeaponSelect == 0 && bs.cur_ps.hasDetPackPlanted && bs.plantKillEmAll > level.time {
            bs.forceWeaponSelect = WP_DET_PACK
        }

        if bs.forceWeaponSelect != 0 {
            selResult = BotSelectChoiceWeapon(bs, bs.forceWeaponSelect, 1)
        }

        if selResult != 0 {
            if selResult == 2 {
                //newly selected
                return
            }
        } else if BotSelectIdealWeapon(bs) != 0 {
            return
        }
    }
    /*if (BotSelectMelee(bs))
    {
    return;
    }*/

    reaction = bs.skills.reflex / bs.settings.skill

    if reaction < 0 {
        reaction = 0
    }
    if reaction > 2000 {
        reaction = 2000
    }

    if bs.currentEnemy == nil {
        bs.timeToReact = level.time + reaction
    }

    if bs.cur_ps.weapon == WP_DET_PACK && bs.cur_ps.hasDetPackPlanted && bs.plantKillEmAll > level.time {
        bs.doAltAttack = 1
    }

    if bs.wpCamping != nil {
        if bs.isCamping < level.time {
            bs.wpCamping = nil
            bs.isCamping = 0
        }

        if bs.currentEnemy != nil && bs.frame_Enemy_Vis != 0 {
            bs.wpCamping = nil
            bs.isCamping = 0
        }
    }

    if bs.wpCurrent != nil && (bs.wpSeenTime < level.time || bs.wpTravelTime < level.time) {
        bs.wpCurrent = nil
    }

    if bs.currentEnemy != nil {
        if bs.enemySeenTime < level.time || PassStandardEnemyChecks(bs, bs.currentEnemy!) == 0 {
            if bs.revengeEnemy == bs.currentEnemy && bs.currentEnemy!.health < 1 && bs.lastAttacked != nil && bs.lastAttacked == bs.currentEnemy {
                //CHAT: Destroyed hated one [KilledHatedOne section]
                bs.chatObject = bs.revengeEnemy
                bs.chatAltObject = nil
                BotDoChat(bs, "KilledHatedOne", 1)
                bs.revengeEnemy = nil
                bs.revengeHateLevel = 0
            } else if bs.currentEnemy!.health < 1 && PassLovedOneCheck(bs, bs.currentEnemy!) != 0 && bs.lastAttacked != nil && bs.lastAttacked == bs.currentEnemy {
                //CHAT: Killed
                bs.chatObject = bs.currentEnemy
                bs.chatAltObject = nil
                BotDoChat(bs, "Killed", 0)
            }

            bs.currentEnemy = nil
        }
    }

    if bot_honorableduelacceptance.integer != 0 {
        if bs.currentEnemy != nil && bs.currentEnemy!.client != nil && bs.cur_ps.weapon == WP_SABER && g_privateDuel.integer != 0 && bs.frame_Enemy_Vis != 0 && bs.frame_Enemy_Len < 400 && bs.currentEnemy!.client!.ps.weapon == WP_SABER && bs.currentEnemy!.client!.ps.saberHolstered != 0 {
            var e_ang_vec = vec3_t()

            e_ang_vec = bs.currentEnemy!.client!.ps.origin - bs.eye

            if InFieldOfVision(bs.viewangles, 100, &e_ang_vec) != 0 {
                //Our enemy has his saber holstered and has challenged us to a duel, so challenge him back
                if bs.cur_ps.saberHolstered == 0 {
                    Cmd_ToggleSaber_f(g_entities[bs.client])
                } else {
                    if bs.currentEnemy!.client!.ps.duelIndex == bs.client && bs.currentEnemy!.client!.ps.duelTime > level.time && !bs.cur_ps.duelInProgress {
                        Cmd_EngageDuel_f(g_entities[bs.client])
                    }
                }

                bs.doAttack = 0
                bs.doAltAttack = 0
                bs.botChallengingTime = level.time + 100
                bs.beStill = Float(level.time + 100)
            }
        }
    }
    //Apparently this "allows you to cheese" when fighting against bots. I'm not sure why you'd want to con bots
    //into an easy kill, since they're bots and all. But whatever.

    if bs.wpCurrent == nil {
        wp = GetNearestVisibleWP(bs.origin, bs.client)

        if wp != -1 {
            bs.wpCurrent = gWPArray[wp]
            bs.wpSeenTime = Float(level.time + 1500)
            bs.wpTravelTime = Float(level.time + 10000) //never take more than 10 seconds to travel to a waypoint
        }
    }

    if bs.enemySeenTime < level.time || bs.frame_Enemy_Vis == 0 || bs.currentEnemy == nil || bs.currentEnemy != nil {
        enemy = ScanForEnemies(bs)

        if enemy != -1 {
            bs.currentEnemy = g_entities[enemy]
            bs.enemySeenTime = Float(level.time + ENEMY_FORGET_MS)
        }
    }

    if bs.squadLeader == nil && bs.isSquadLeader == 0 {
        BotScanForLeader(bs)
    }

    if bs.squadLeader == nil && bs.squadCannotLead < level.time {
        //if still no leader after scanning, then become a squad leader
        bs.isSquadLeader = 1
    }

    if bs.isSquadLeader != 0 && bs.squadLeader != nil {
        //we don't follow anyone if we are a leader
        bs.squadLeader = nil
    }

    //ESTABLISH VISIBILITIES AND DISTANCES FOR THE WHOLE FRAME HERE
    if bs.wpCurrent != nil {
        if g_RMG.integer != 0 {
            //this is somewhat hacky, but in RMG we don't really care about vertical placement because points are scattered across only the terrain.
            var vecB = vec3_t()
            var vecC = vec3_t()

            vecB[0] = bs.origin[0]
            vecB[1] = bs.origin[1]
            vecB[2] = bs.origin[2]

            vecC[0] = bs.wpCurrent!.origin[0]
            vecC[1] = bs.wpCurrent!.origin[1]
            vecC[2] = vecB[2]


            a = vecC - vecB
        } else {
            a = bs.wpCurrent!.origin - bs.origin
        }
        bs.frame_Waypoint_Len = VectorLength(a)

        visResult = WPOrgVisible(g_entities[bs.client], bs.origin, bs.wpCurrent!.origin, bs.client)

        if visResult == 2 {
            bs.frame_Waypoint_Vis = 0
            bs.wpSeenTime = 0
            bs.wpDestination = nil
            bs.wpDestIgnoreTime = Float(level.time + 5000)

            if bs.wpDirection != 0 {
                bs.wpDirection = 0
            } else {
                bs.wpDirection = 1
            }
        } else if visResult != 0 {
            bs.frame_Waypoint_Vis = 1
        } else {
            bs.frame_Waypoint_Vis = 0
        }
    }

    if bs.currentEnemy != nil {
        if bs.currentEnemy!.client != nil {
            eorg = bs.currentEnemy!.client!.ps.origin
            eorg[2] += bs.currentEnemy!.client!.ps.viewheight
        } else {
            eorg = bs.currentEnemy!.s.origin
        }

        a = eorg - bs.eye
        bs.frame_Enemy_Len = VectorLength(a)

        if OrgVisible(bs.eye, eorg, bs.client) != 0 {
            bs.frame_Enemy_Vis = 1
            bs.lastEnemySpotted = eorg
            bs.hereWhenSpotted = bs.origin
            bs.lastVisibleEnemyIndex = bs.currentEnemy!.s.number
            //VectorCopy(bs->eye, bs->lastEnemySpotted);
            bs.hitSpotted = 0
        } else {
            bs.frame_Enemy_Vis = 0
        }
    } else {
        bs.lastVisibleEnemyIndex = ENTITYNUM_NONE
    }
    //END

    if bs.frame_Enemy_Vis != 0 {
        bs.enemySeenTime = Float(level.time + ENEMY_FORGET_MS)
    }

    if bs.wpCurrent != nil {
        var wpTouchDist: Int32 = BOT_WPTOUCH_DISTANCE
        WPConstantRoutine(bs)

        if bs.wpCurrent == nil {
            //WPConstantRoutine has the ability to nullify the waypoint if it fails certain checks, so..
            return
        }

        if (bs.wpCurrent!.flags & WPFLAG_WAITFORFUNC) != 0 {
            if CheckForFunc(bs.wpCurrent!.origin, -1) == 0 {
                bs.beStill = Float(level.time + 500) //no func brush under.. wait
            }
        }
        if (bs.wpCurrent!.flags & WPFLAG_NOMOVEFUNC) != 0 {
            if CheckForFunc(bs.wpCurrent!.origin, -1) != 0 {
                bs.beStill = Float(level.time + 500) //func brush under.. wait
            }
        }

        if bs.frame_Waypoint_Vis != 0 || (bs.wpCurrent!.flags & WPFLAG_NOVIS) != 0 {
            if g_RMG.integer != 0 {
                bs.wpSeenTime = Float(level.time + 5000) //if we lose sight of the point, we have 1.5 seconds to regain it before we drop it
            } else {
                bs.wpSeenTime = Float(level.time + 1500) //if we lose sight of the point, we have 1.5 seconds to regain it before we drop it
            }
        }
        bs.goalPosition = bs.wpCurrent!.origin
        if bs.wpDirection != 0 {
            goalWPIndex = bs.wpCurrent!.index - 1
        } else {
            goalWPIndex = bs.wpCurrent!.index + 1
        }

        if bs.wpCamping != nil {
            a = bs.wpCampingTo!.origin - bs.origin
            vectoangles(a, &ang)
            bs.goalAngles = ang

            a = bs.origin - bs.wpCamping!.origin
            if VectorLength(a) < 64 {
                bs.goalPosition = bs.wpCamping!.origin
                bs.beStill = Float(level.time + 1000)

                if !bs.campStanding {
                    bs.duckTime = Float(level.time + 1000)
                }
            }
        } else if gWPArray[goalWPIndex] != nil && gWPArray[goalWPIndex]!.inuse != 0 && !((gLevelFlags & LEVELFLAG_NOPOINTPREDICTION) != 0) {
            a = gWPArray[goalWPIndex]!.origin - bs.origin
            vectoangles(a, &ang)
            bs.goalAngles = ang
        } else {
            a = bs.wpCurrent!.origin - bs.origin
            vectoangles(a, &ang)
            bs.goalAngles = ang
        }

        if bs.destinationGrabTime < level.time {
            GetIdealDestination(bs)
        }

        if bs.wpCurrent != nil && bs.wpDestination != nil {
            if TotalTrailDistance(bs.wpCurrent!.index, bs.wpDestination!.index, bs) == -1 {
                bs.wpDestination = nil
                bs.destinationGrabTime = Float(level.time + 10000)
            }
        }

        if g_RMG.integer != 0 {
            if bs.frame_Waypoint_Vis != 0 {
                if bs.wpCurrent != nil && bs.wpCurrent!.flags == 0 {
                    wpTouchDist *= 3
                }
            }
        }

        if bs.frame_Waypoint_Len < wpTouchDist || (g_RMG.integer != 0 && bs.frame_Waypoint_Len < wpTouchDist * 2) {
            WPTouchRoutine(bs)

            if bs.wpDirection == 0 {
                desiredIndex = bs.wpCurrent!.index + 1
            } else {
                desiredIndex = bs.wpCurrent!.index - 1
            }

            if gWPArray[desiredIndex] != nil && gWPArray[desiredIndex]!.inuse != 0 && desiredIndex < gWPNum && desiredIndex >= 0 && PassWayCheck(bs, desiredIndex) != 0 {
                bs.wpCurrent = gWPArray[desiredIndex]
            } else {
                if bs.wpDestination != nil {
                    bs.wpDestination = nil
                    bs.destinationGrabTime = Float(level.time + 10000)
                }

                if bs.wpDirection != 0 {
                    bs.wpDirection = 0
                } else {
                    bs.wpDirection = 1
                }
            }
        }
    } else {
        /*if (g_gametype.integer == GT_DUEL)*/
        do {
            //helps them get out of messy situations
            /*if ((level.time - bs->forceJumpChargeTime) > 3500)
            {
            bs->forceJumpChargeTime = level.time + 2000;
            trap_EA_MoveForward(bs->client);
            }
            */
            bs.jumpTime = Float(level.time + 1500)
            bs.jumpHoldTime = Float(level.time + 1500)
            bs.jDelay = 0
        }
        doingFallback = BotFallbackNavigation(bs)
    }

    if g_RMG.integer != 0 {
        //for RMG if the bot sticks around an area too long, jump around randomly some to spread to a new area (horrible hacky method)
        var vSubDif = vec3_t()

        vSubDif = bs.origin - bs.lastSignificantAreaChange
        if VectorLength(vSubDif) > 1500 {
            bs.lastSignificantAreaChange = bs.origin
            bs.lastSignificantChangeTime = level.time + 20000
        }

        if bs.lastSignificantChangeTime < level.time {
            bs.iHaveNoIdeaWhereIAmGoing = level.time + 17000
        }
    }

    if bs.iHaveNoIdeaWhereIAmGoing > level.time && bs.currentEnemy == nil {
        bs.goalAngles = preFrameGAngles
        bs.wpCurrent = nil
        bs.wpSwitchTime = Float(level.time + 150)
        doingFallback = BotFallbackNavigation(bs)
        bs.jumpTime = Float(level.time + 150)
        bs.jumpHoldTime = Float(level.time + 150)
        bs.jDelay = 0
        bs.lastSignificantChangeTime = level.time + 25000
    }

    if bs.wpCurrent != nil && g_RMG.integer != 0 {
        var doJ: Bool = false

        if bs.wpCurrent!.origin[2] - 192 > bs.origin[2] {
            doJ = true
        } else if (bs.wpTravelTime - level.time) < 5000 && bs.wpCurrent!.origin[2] - 64 > bs.origin[2] {
            doJ = true
        } else if (bs.wpTravelTime - level.time) < 7000 && (bs.wpCurrent!.flags & WPFLAG_RED_FLAG) != 0 {
            if (level.time - bs.jumpTime) > 200 {
                bs.jumpTime = Float(level.time + 100)
                bs.jumpHoldTime = Float(level.time + 100)
                bs.jDelay = 0
            }
        } else if (bs.wpTravelTime - level.time) < 7000 && (bs.wpCurrent!.flags & WPFLAG_BLUE_FLAG) != 0 {
            if (level.time - bs.jumpTime) > 200 {
                bs.jumpTime = Float(level.time + 100)
                bs.jumpHoldTime = Float(level.time + 100)
                bs.jDelay = 0
            }
        } else if bs.wpCurrent!.index > 0 {
            if (bs.wpTravelTime - level.time) < 7000 {
                if (gWPArray[bs.wpCurrent!.index - 1]!.flags & WPFLAG_RED_FLAG) != 0 || (gWPArray[bs.wpCurrent!.index - 1]!.flags & WPFLAG_BLUE_FLAG) != 0 {
                    if (level.time - bs.jumpTime) > 200 {
                        bs.jumpTime = Float(level.time + 100)
                        bs.jumpHoldTime = Float(level.time + 100)
                        bs.jDelay = 0
                    }
                }
            }
        }

        if doJ {
            bs.jumpTime = Float(level.time + 1500)
            bs.jumpHoldTime = Float(level.time + 1500)
            bs.jDelay = 0
        }
    }

    if doingFallback != 0 {
        bs.doingFallback = true
    } else {
        bs.doingFallback = false
    }

    if bs.timeToReact < level.time && bs.currentEnemy != nil && Double(bs.enemySeenTime) > Double(level.time) + (Double(ENEMY_FORGET_MS) - (Double(ENEMY_FORGET_MS) * 0.2)) {
        if bs.frame_Enemy_Vis != 0 {
            cBAI = CombatBotAI(bs, thinktime)
        } else if bs.cur_ps.weaponstate == WEAPON_CHARGING_ALT {
            //keep charging in case we see him again before we lose track of him
            bs.doAltAttack = 1
        } else if bs.cur_ps.weaponstate == WEAPON_CHARGING {
            //keep charging in case we see him again before we lose track of him
            bs.doAttack = 1
        }

        if bs.destinationGrabTime > level.time + 100 {
            bs.destinationGrabTime = Float(level.time + 100) //assures that we will continue staying within a general area of where we want to be in a combat situation
        }

        if bs.currentEnemy!.client != nil {
            headlevel = bs.currentEnemy!.client!.ps.origin
            headlevel[2] += bs.currentEnemy!.client!.ps.viewheight
        } else {
            headlevel = bs.currentEnemy!.client!.ps.origin
        }

        if bs.frame_Enemy_Vis == 0 {
            //if (!bs->hitSpotted && VectorLength(a) > 256)
            if OrgVisible(bs.eye, bs.lastEnemySpotted, -1) != 0 {
                headlevel = bs.lastEnemySpotted
                a = headlevel - bs.eye
                vectoangles(a, &ang)
                bs.goalAngles = ang

                if bs.cur_ps.weapon == WP_FLECHETTE && bs.cur_ps.weaponstate == WEAPON_READY && bs.currentEnemy != nil && bs.currentEnemy!.client != nil {
                    mLen = (VectorLength(a) > 128 ? 1 : 0)
                    if mLen > 128 && mLen < 1024 {
                        a = bs.currentEnemy!.client!.ps.origin - bs.lastEnemySpotted

                        if VectorLength(a) < 300 {
                            bs.doAltAttack = 1
                        }
                    }
                }
            }
        } else {
            bLeadAmount = BotWeaponCanLead(bs)
            if (bs.skills.accuracy / bs.settings.skill) <= 8 && bLeadAmount != 0 {
                BotAimLeading(bs, headlevel, bLeadAmount)
            } else {
                a = headlevel - bs.eye
                vectoangles(a, &ang)
                bs.goalAngles = ang
            }

            BotAimOffsetGoalAngles(bs)
        }
    }

    if bs.cur_ps.saberInFlight {
        bs.saberThrowTime = level.time + Q_irand(4000, 10000)
    }

    if bs.currentEnemy != nil {
        if BotGetWeaponRange(bs) == BWEAPONRANGE_SABER {
            var saberRange: Int32 = SABER_ATTACK_RANGE

            a_fo = bs.currentEnemy!.client!.ps.origin - bs.eye
            vectoangles(a_fo, &a_fo)

            if bs.saberPowerTime < level.time {
                //Don't just use strong attacks constantly, switch around a bit
                if Q_irand(1, 10) <= 5 {
                    bs.saberPower = true
                } else {
                    bs.saberPower = false
                }

                bs.saberPowerTime = level.time + Q_irand(3000, 15000)
            }

            if g_entities[bs.client].client!.ps.fd.saberAnimLevel != SS_STAFF && g_entities[bs.client].client!.ps.fd.saberAnimLevel != SS_DUAL {
                if bs.currentEnemy!.health > 75 && g_entities[bs.client].client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] > 2 {
                    if g_entities[bs.client].client!.ps.fd.saberAnimLevel != SS_STRONG && bs.saberPower {
                        //if we are up against someone with a lot of health and we have a strong attack available, then h4q them
                        Cmd_SaberAttackCycle_f(g_entities[bs.client])
                    }
                } else if bs.currentEnemy!.health > 40 && g_entities[bs.client].client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] > 1 {
                    if g_entities[bs.client].client!.ps.fd.saberAnimLevel != SS_MEDIUM {
                        //they're down on health a little, use level 2 if we can
                        Cmd_SaberAttackCycle_f(g_entities[bs.client])
                    }
                } else {
                    if g_entities[bs.client].client!.ps.fd.saberAnimLevel != SS_FAST {
                        //they've gone below 40 health, go at them with quick attacks
                        Cmd_SaberAttackCycle_f(g_entities[bs.client])
                    }
                }
            }

            if g_gametype.integer == GT_SINGLE_PLAYER {
                saberRange *= 3
            }

            if bs.frame_Enemy_Len <= saberRange {
                SaberCombatHandling(bs)

                if bs.frame_Enemy_Len < 80 {
                    meleestrafe = 1
                }
            } else if bs.saberThrowTime < level.time && !bs.cur_ps.saberInFlight && (bs.cur_ps.fd.forcePowersKnown & (1 << FP_SABERTHROW)) != 0 && InFieldOfVision(bs.viewangles, 30, &a_fo) != 0 && bs.frame_Enemy_Len < BOT_SABER_THROW_RANGE && bs.cur_ps.fd.saberAnimLevel != SS_STAFF {
                bs.doAltAttack = 1
                bs.doAttack = 0
            } else if bs.cur_ps.saberInFlight && bs.frame_Enemy_Len > 300 && bs.frame_Enemy_Len < BOT_SABER_THROW_RANGE {
                bs.doAltAttack = 1
                bs.doAttack = 0
            }
        } else if BotGetWeaponRange(bs) == BWEAPONRANGE_MELEE {
            if bs.frame_Enemy_Len <= MELEE_ATTACK_RANGE {
                MeleeCombatHandling(bs)
                meleestrafe = 1
            }
        }
    }

    if doingFallback != 0 && bs.currentEnemy != nil {
        bs.goalPosition = bs.origin
    }

    if bs.forceJumping > level.time {
        noz_x = bs.origin
        noz_y = bs.goalPosition

        noz_x[2] = noz_y[2]

        noz_x = noz_x - noz_y

        if VectorLength(noz_x) < 32 {
            fjHalt = 1
        }
    }

    if bs.doChat != 0 && bs.chatTime > level.time && (bs.currentEnemy == nil || bs.frame_Enemy_Vis == 0) {
        return
    } else if bs.doChat != 0 && bs.currentEnemy != nil && bs.frame_Enemy_Vis != 0 {
        //bs->chatTime = level.time + bs->chatTime_stored;
        bs.doChat = 0 //do we want to keep the bot waiting to chat until after the enemy is gone?
        bs.chatTeam = 0
    } else if bs.doChat != 0 && bs.chatTime <= level.time {
        if bs.chatTeam != 0 {
            trap_EA_SayTeam(bs.client, bs.currentChat)
            bs.chatTeam = 0
        } else {
            trap_EA_Say(bs.client, bs.currentChat)
        }
        if bs.doChat == 2 {
            BotReplyGreetings(bs)
        }
        bs.doChat = 0
    }

    CTFFlagMovement(bs)

    if bs.shootGoal != nil && bs.shootGoal!.health > 0 && bs.shootGoal!.takedamage {
        dif[0] = (bs.shootGoal!.r.absmax[0] + bs.shootGoal!.r.absmin[0]) / 2
        dif[1] = (bs.shootGoal!.r.absmax[1] + bs.shootGoal!.r.absmin[1]) / 2
        dif[2] = (bs.shootGoal!.r.absmax[2] + bs.shootGoal!.r.absmin[2]) / 2

        if bs.currentEnemy == nil || bs.frame_Enemy_Len > 256 {
            //if someone is close then don't stop shooting them for this
            a = dif - bs.eye
            vectoangles(a, &a)
            bs.goalAngles = a

            if InFieldOfVision(bs.viewangles, 30, &a) != 0 && EntityVisibleBox(bs.origin, nil, nil, dif, bs.client, bs.shootGoal!.s.number) != 0 {
                bs.doAttack = 1
            }
        }
    }

    if bs.cur_ps.hasDetPackPlanted {
        //check if our enemy gets near it and detonate if he does
        BotCheckDetPacks(bs)
    } else if bs.currentEnemy != nil && bs.lastVisibleEnemyIndex == bs.currentEnemy!.s.number && bs.frame_Enemy_Vis == 0 && bs.plantTime < level.time && bs.doAttack == 0 && bs.doAltAttack == 0 {
        a = bs.origin - bs.hereWhenSpotted

        if bs.plantDecided > level.time || (bs.frame_Enemy_Len < BOT_PLANT_DISTANCE * 2 && VectorLength(a) < BOT_PLANT_DISTANCE) {
            mineSelect = BotSelectChoiceWeapon(bs, WP_TRIP_MINE, 0)
            detSelect = BotSelectChoiceWeapon(bs, WP_DET_PACK, 0)
            if bs.cur_ps.hasDetPackPlanted {
                detSelect = 0
            }

            if bs.plantDecided > level.time && bs.forceWeaponSelect != 0 && bs.cur_ps.weapon == bs.forceWeaponSelect {
                bs.doAttack = 1
                bs.plantDecided = 0
                bs.plantTime = level.time + BOT_PLANT_INTERVAL
                bs.plantContinue = level.time + 500
                bs.beStill = Float(level.time + 500)
            } else if mineSelect != 0 || detSelect != 0 {
                if BotSurfaceNear(bs) != 0 {
                    if mineSelect == 0 {
                        //if no mines use detpacks, otherwise use mines
                        mineSelect = WP_DET_PACK
                    } else {
                        mineSelect = WP_TRIP_MINE
                    }

                    detSelect = BotSelectChoiceWeapon(bs, mineSelect, 1)

                    if detSelect != 0 && detSelect != 2 {
                        //We have it and it is now our weapon
                        bs.plantDecided = level.time + 1000
                        bs.forceWeaponSelect = mineSelect
                        return
                    } else if detSelect == 2 {
                        bs.forceWeaponSelect = mineSelect
                        return
                    }
                }
            }
        }
    } else if bs.plantContinue < level.time {
        bs.forceWeaponSelect = 0
    }

    if g_gametype.integer == GT_JEDIMASTER && !bs.cur_ps.isJediMaster && bs.jmState == -1 && gJMSaberEnt != nil && gJMSaberEnt!.inuse {
        var saberLen = vec3_t()
        var fSaberLen: Float = 0

        saberLen = bs.origin - gJMSaberEnt!.r.currentOrigin
        fSaberLen = VectorLength(saberLen)

        if fSaberLen < 256 {
            if OrgVisible(bs.origin, gJMSaberEnt!.r.currentOrigin, bs.client) != 0 {
                bs.goalPosition = gJMSaberEnt!.r.currentOrigin
            }
        }
    }

    if bs.beStill < level.time && WaitingForNow(bs, bs.goalPosition) == 0 && fjHalt == 0 {
        bs.goalMovedir = bs.goalPosition - bs.origin
        VectorNormalize(&bs.goalMovedir)

        if bs.jumpTime > level.time && bs.jDelay < level.time && level.clientsSlots[bs.client].pers.cmd.upmove > 0 {
            //	trap_EA_Move(bs->client, bs->origin, 5000);
            bs.beStill = Float(level.time + 200)
        } else {
            trap_EA_Move(bs.client, &bs.goalMovedir, 5000)
        }

        if meleestrafe != 0 {
            StrafeTracing(bs)
        }

        if bs.meleeStrafeDir != 0 && meleestrafe != 0 && bs.meleeStrafeDisable < level.time {
            trap_EA_MoveRight(bs.client)
        } else if meleestrafe != 0 && bs.meleeStrafeDisable < level.time {
            trap_EA_MoveLeft(bs.client)
        }

        if BotTrace_Jump(bs, bs.goalPosition) != 0 {
            bs.jumpTime = Float(level.time + 100)
        } else if BotTrace_Duck(bs, bs.goalPosition) != 0 {
            bs.duckTime = Float(level.time + 100)
        } else {
            let strafeAround: Int32 = BotTrace_Strafe(bs, bs.goalPosition)

            if strafeAround == STRAFEAROUND_RIGHT {
                trap_EA_MoveRight(bs.client)
            } else if strafeAround == STRAFEAROUND_LEFT {
                trap_EA_MoveLeft(bs.client)
            }
        }
    }

    if bs.forceJumpChargeTime > level.time {
        bs.jumpTime = 0
    }

    if bs.jumpPrep > level.time {
        bs.forceJumpChargeTime = 0
    }

    if bs.forceJumpChargeTime > level.time {
        bs.jumpHoldTime = Float(((bs.forceJumpChargeTime - level.time) / 2) + level.time)
        bs.forceJumpChargeTime = 0
    }

    if bs.jumpHoldTime > level.time {
        bs.jumpTime = bs.jumpHoldTime
    }

    if bs.jumpTime > level.time && bs.jDelay < level.time {
        if bs.jumpHoldTime > level.time {
            trap_EA_Jump(bs.client)
            if bs.wpCurrent != nil {
                if (bs.wpCurrent!.origin[2] - bs.origin[2]) < 64 {
                    trap_EA_MoveForward(bs.client)
                }
            } else {
                trap_EA_MoveForward(bs.client)
            }
            if g_entities[bs.client].client!.ps.groundEntityNum == ENTITYNUM_NONE {
                g_entities[bs.client].client!.ps.pm_flags |= PMF_JUMP_HELD
            }
        } else if !((bs.cur_ps.pm_flags & PMF_JUMP_HELD) != 0) {
            trap_EA_Jump(bs.client)
        }
    }

    if bs.duckTime > level.time {
        trap_EA_Crouch(bs.client)
    }

    if bs.dangerousObject != nil && bs.dangerousObject!.inuse && bs.dangerousObject!.health > 0 && bs.dangerousObject!.takedamage && (bs.frame_Enemy_Vis == 0 || bs.currentEnemy == nil) && (BotGetWeaponRange(bs) == BWEAPONRANGE_MID || BotGetWeaponRange(bs) == BWEAPONRANGE_LONG) && bs.cur_ps.weapon != WP_DET_PACK && bs.cur_ps.weapon != WP_TRIP_MINE && bs.shootGoal == nil {
        let danLen: Float

        a = bs.dangerousObject!.r.currentOrigin - bs.eye

        danLen = VectorLength(a)

        if danLen > 256 {
            vectoangles(a, &a)
            bs.goalAngles = a

            if Q_irand(1, 10) < 5 {
                bs.goalAngles[YAW] += Q_irand(0, 3)
                bs.goalAngles[PITCH] += Q_irand(0, 3)
            } else {
                bs.goalAngles[YAW] -= Q_irand(0, 3)
                bs.goalAngles[PITCH] -= Q_irand(0, 3)
            }

            if InFieldOfVision(bs.viewangles, 30, &a) != 0 && EntityVisibleBox(bs.origin, nil, nil, bs.dangerousObject!.r.currentOrigin, bs.client, bs.dangerousObject!.s.number) != 0 {
                bs.doAttack = 1
            }
        }
    }

    if PrimFiring(bs) != 0 || AltFiring(bs) != 0 {
        friendInLOF = CheckForFriendInLOF(bs)

        if friendInLOF != nil {
            if PrimFiring(bs) != 0 {
                KeepPrimFromFiring(bs)
            }
            if AltFiring(bs) != 0 {
                KeepAltFromFiring(bs)
            }
            if useTheForce != 0 && forceHostile != 0 {
                useTheForce = 0
            }

            if useTheForce == 0 && friendInLOF!.client != nil {
                //we have a friend here and are not currently using force powers, see if we can help them out
                if friendInLOF!.health <= 50 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_TEAM_HEAL]][FP_TEAM_HEAL] {
                    level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_TEAM_HEAL
                    useTheForce = 1
                    forceHostile = 0
                } else if friendInLOF!.client!.ps.fd.forcePower <= 50 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_TEAM_FORCE]][FP_TEAM_FORCE] {
                    level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_TEAM_FORCE
                    useTheForce = 1
                    forceHostile = 0
                }
            }
        }
    } else if g_gametype.integer >= GT_TEAM {
        //still check for anyone to help..
        friendInLOF = CheckForFriendInLOF(bs)

        if useTheForce == 0 && friendInLOF != nil {
            if friendInLOF!.health <= 50 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_TEAM_HEAL]][FP_TEAM_HEAL] {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_TEAM_HEAL
                useTheForce = 1
                forceHostile = 0
            } else if friendInLOF!.client!.ps.fd.forcePower <= 50 && level.clientsSlots[bs.client].ps.fd.forcePower > forcePowerNeeded[level.clientsSlots[bs.client].ps.fd.forcePowerLevel[FP_TEAM_FORCE]][FP_TEAM_FORCE] {
                level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_TEAM_FORCE
                useTheForce = 1
                forceHostile = 0
            }
        }
    }

    if bs.doAttack != 0 && bs.cur_ps.weapon == WP_DET_PACK && bs.cur_ps.hasDetPackPlanted {
        //maybe a bit hackish, but bots only want to plant one of these at any given time to avoid complications
        bs.doAttack = 0
    }

    if bs.doAttack != 0 && bs.cur_ps.weapon == WP_SABER && bs.saberDefending != 0 && bs.currentEnemy != nil && bs.currentEnemy!.client != nil && BotWeaponBlockable(bs.currentEnemy!.client!.ps.weapon) != 0 {
        bs.doAttack = 0
    }

    if bs.cur_ps.saberLockTime > level.time {
        // The SDK also declares `rand`, so the call names the bg module.
        if JKAMP_BG.rand() % 10 < 5 {
            bs.doAttack = 1
        } else {
            bs.doAttack = 0
        }
    }

    if bs.botChallengingTime > level.time {
        bs.doAttack = 0
        bs.doAltAttack = 0
    }

    if bs.cur_ps.weapon == WP_SABER && bs.cur_ps.saberInFlight && bs.cur_ps.saberEntityNum == 0 {
        //saber knocked away, keep trying to get it back
        bs.doAttack = 1
        bs.doAltAttack = 0
    }

    if bs.doAttack != 0 {
        trap_EA_Attack(bs.client)
    } else if bs.doAltAttack != 0 {
        trap_EA_Alt_Attack(bs.client)
    }

    if useTheForce != 0 && forceHostile != 0 && bs.botChallengingTime > level.time {
        useTheForce = 0
    }

    if useTheForce != 0 {
        if bs.forceJumpChargeTime > level.time {
            level.clientsSlots[bs.client].ps.fd.forcePowerSelected = FP_LEVITATION
            trap_EA_ForcePower(bs.client)
        } else {
            if bot_forcepowers.integer != 0 && g_forcePowerDisable.integer == 0 {
                trap_EA_ForcePower(bs.client)
            }
        }
    }

    MoveTowardIdealAngles(bs)
}

/// Raven's `static int local_time` of `BotAIStartFrame`, a property of `GameWorld`.
/// Source: oracle/codemp/game/ai_main.c:7495
var local_time: Int32 { get { world.local_time } set { world.local_time = newValue } }

/// Raven's `static int lastbotthink_time` of `BotAIStartFrame`, a property of `GameWorld`.
/// Source: oracle/codemp/game/ai_main.c:7497
var lastbotthink_time: Int32 { get { world.lastbotthink_time } set { world.lastbotthink_time = newValue } }

/**
```
==================
BotAIStartFrame
==================
```
*/
/// Source: oracle/codemp/game/ai_main.c:7492
public func BotAIStartFrame(_ time: Int32) -> Int32 {
    var i: Int32
    let elapsed_time: Int32
    let thinktime: Int32
    var botlib_residual: Int32

    if gUpdateVars < level.time {
        trap_Cvar_Update(bot_pvstype)
        trap_Cvar_Update(bot_camp)
        trap_Cvar_Update(bot_attachments)
        trap_Cvar_Update(bot_forgimmick)
        trap_Cvar_Update(bot_honorableduelacceptance)
        trap_Cvar_Update(bot_getinthecarrr)
        gUpdateVars = level.time + 1000
    }

    G_CheckBotSpawn()

    //rww - addl bot frame functions
    if gBotEdit != 0 {
        trap_Cvar_Update(bot_wp_info)
        BotWaypointRender()
    }

    UpdateEventTracker()
    //end rww

    //cap the bot think time
    //if the bot think time changed we should reschedule the bots
    if BOT_THINK_TIME != lastbotthink_time {
        lastbotthink_time = BOT_THINK_TIME
        BotScheduleBotThink()
    }

    elapsed_time = time - local_time
    local_time = time

    if elapsed_time > BOT_THINK_TIME {
        thinktime = elapsed_time
    } else {
        thinktime = BOT_THINK_TIME
    }

    // execute scheduled bot AI
    i = 0
    while i < MAX_CLIENTS {
        if botstates[i] == nil || botstates[i]!.inuse == 0 {
            i += 1
            continue
        }
        //
        botstates[i]!.botthink_residual += elapsed_time
        //
        if botstates[i]!.botthink_residual >= thinktime {
            botstates[i]!.botthink_residual -= thinktime

            if g_entities[i].client!.pers.connected == CON_CONNECTED {
                BotAI(i, Float(thinktime) / 1000)
            }
        }
        i += 1
    }

    // execute bot user commands every frame
    i = 0
    while i < MAX_CLIENTS {
        if botstates[i] == nil || botstates[i]!.inuse == 0 {
            i += 1
            continue
        }
        if g_entities[i].client!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }

        BotUpdateInput(botstates[i]!, time, elapsed_time)
        trap_BotUserCommand(botstates[i]!.client, botstates[i]!.lastucmd)
        i += 1
    }

    return 1
}

/**
```
==============
BotAISetup
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:7575
func BotAISetup(_ restart: Int32) -> Int32 {
    //rww - new bot cvars..
    trap_Cvar_Register(bot_forcepowers, "bot_forcepowers", "1", CVAR_CHEAT)
    trap_Cvar_Register(bot_forgimmick, "bot_forgimmick", "0", CVAR_CHEAT)
    trap_Cvar_Register(bot_honorableduelacceptance, "bot_honorableduelacceptance", "0", CVAR_CHEAT)
    trap_Cvar_Register(bot_pvstype, "bot_pvstype", "1", CVAR_CHEAT)
    trap_Cvar_Register(bot_getinthecarrr, "bot_getinthecarrr", "0", 0)


    trap_Cvar_Register(bot_attachments, "bot_attachments", "1", 0)
    trap_Cvar_Register(bot_camp, "bot_camp", "1", 0)

    trap_Cvar_Register(bot_wp_info, "bot_wp_info", "1", 0)
    trap_Cvar_Register(bot_wp_edit, "bot_wp_edit", "0", CVAR_CHEAT)
    trap_Cvar_Register(bot_wp_clearweight, "bot_wp_clearweight", "1", 0)
    trap_Cvar_Register(bot_wp_distconnect, "bot_wp_distconnect", "1", 0)
    trap_Cvar_Register(bot_wp_visconnect, "bot_wp_visconnect", "1", 0)

    trap_Cvar_Update(bot_forcepowers)
    //end rww

    //if the game is restarted for a tournament
    if restart != 0 {
        return 1
    }

    //initialize the bot states
    botstates.zero()

    if trap_BotLibSetup() == 0 {
        return 0 //wts?!
    }

    return 1
}

/**
```
==============
BotAIShutdown
==============
```
*/
/// Source: oracle/codemp/game/ai_main.c:7623
func BotAIShutdown(_ restart: Int32) -> Int32 {
    var i: Int32

    //if the game is restarted for a tournament
    if restart != 0 {
        //shutdown all the bots in the botlib
        i = 0
        while i < MAX_CLIENTS {
            if botstates[i] != nil && botstates[i]!.inuse != 0 {
                BotAIShutdownClient(botstates[i]!.client, restart != 0)
            }
            i += 1
        }
        //don't shutdown the bot library
    } else {
        trap_BotLibShutdown()
    }
    return 1
}
