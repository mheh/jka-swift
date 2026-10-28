import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:53
private let LSTATE_NONE: Int32 = 0
private let LSTATE_UNDERFIRE: Int32 = 1
private let LSTATE_INVESTIGATE: Int32 = 2

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:20
private let MAX_VIEW_DIST = 1024 as Int32

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:21
private let MAX_VIEW_SPEED = 250 as Int32

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:22
private let MAX_LIGHT_INTENSITY = 255 as Int32

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:23
private let MIN_LIGHT_THRESHOLD = 0.1 as Double

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:24
let ST_MIN_LIGHT_THRESHOLD = 30 as Int32

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:25
let ST_MAX_LIGHT_THRESHOLD = 180 as Int32

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:26
private let DISTANCE_THRESHOLD = 0.075 as Float

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:28
private let DISTANCE_SCALE = 0.35 as Float

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:29
private let FOV_SCALE = 0.40 as Float

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:30
private let LIGHT_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:32
private let SPEED_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:33
let TURNING_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:35
private let REALIZE_THRESHOLD = 0.6 as Float

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:36
private let CAUTIOUS_THRESHOLD = (REALIZE_THRESHOLD * 0.75)

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:40
var enemyLOS: Bool {
    get { world.variables.enemyLOS }
    set { world.variables.enemyLOS = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:41
var enemyCS: Bool {
    get { world.variables.enemyCS }
    set { world.variables.enemyCS = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:42
var enemyInFOV: Bool {
    get { world.variables.enemyInFOV }
    set { world.variables.enemyInFOV = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:43
var hitAlly: Bool {
    get { world.variables.hitAlly }
    set { world.variables.hitAlly = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:44
var faceEnemy: Bool {
    get { world.variables.faceEnemy }
    set { world.variables.faceEnemy = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:45
var move: Bool {
    get { world.variables.move }
    set { world.variables.move = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:46
var shoot: Bool {
    get { world.variables.shoot }
    set { world.variables.shoot = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:47
private var enemyDist: Float {
    get { world.variables.NPC_AI_Stormtrooper_enemyDist }
    set { world.variables.NPC_AI_Stormtrooper_enemyDist = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:48
var impactPos: JKAShared.vec3_t {
    get { world.variables.impactPos }
    set { world.variables.impactPos = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:50
var groupSpeechDebounceTime: [Int32] {
    get { world.variables.groupSpeechDebounceTime }
    set { world.variables.groupSpeechDebounceTime = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:764
private let MAX_CHECK_THRESHOLD = 1 as Int32

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:60
func ST_AggressionAdjust(_ `self`: Entity, _ change: Int32) {
    let upper_threshold: Int32
    let lower_threshold: Int32

    `self`.NPC!.stats.aggression += change

    //FIXME: base this on initial NPC stats
    if `self`.client!.playerTeam == NPCTEAM_PLAYER {
        //good guys are less aggressive
        upper_threshold = 7
        lower_threshold = 1
    } else {
        //bad guys are more aggressive
        upper_threshold = 10
        lower_threshold = 3
    }

    if `self`.NPC!.stats.aggression > upper_threshold {
        `self`.NPC!.stats.aggression = upper_threshold
    } else if `self`.NPC!.stats.aggression < lower_threshold {
        `self`.NPC!.stats.aggression = lower_threshold
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:88
func ST_ClearTimers(_ ent: Entity) {
    TIMER_Set(ent, "chatter", 0)
    TIMER_Set(ent, "duck", 0)
    TIMER_Set(ent, "stand", 0)
    TIMER_Set(ent, "shuffleTime", 0)
    TIMER_Set(ent, "sleepTime", 0)
    TIMER_Set(ent, "enemyLastVisible", 0)
    TIMER_Set(ent, "roamTime", 0)
    TIMER_Set(ent, "hideTime", 0)
    TIMER_Set(ent, "attackDelay", 0) //FIXME: Slant for difficulty levels
    TIMER_Set(ent, "stick", 0)
    TIMER_Set(ent, "scoutTime", 0)
    TIMER_Set(ent, "flee", 0)
    TIMER_Set(ent, "interrogating", 0)
    TIMER_Set(ent, "verifyCP", 0)
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:124
private func ST_Speech(_ `self`: Entity, _ speechType: Int32, _ failChance: Float) {
    // The SDK also declares `random`, so the call names the bg module.
    if JKAMP_BG.random() < failChance {
        return
    }

    if failChance >= 0 {
        //a negative failChance makes it always talk
        if `self`.NPC!.group != nil {
            //group AI speech debounce timer
            if `self`.NPC!.group!.speechDebounceTime > level.time {
                return
            }
            /*
            else if ( !self->NPC->group->enemy )
            {
            if ( groupSpeechDebounceTime[self->client->playerTeam] > level.time )
            {
            return;
            }
            }
            */
        } else if !TIMER_Done(`self`, "chatter") {
            //personal timer
            return
        } else if groupSpeechDebounceTime[`self`.client!.playerTeam] > level.time {
            //for those not in group AI
            //FIXME: let certain speech types interrupt others?  Let closer NPCs interrupt farther away ones?
            return
        }
    }

    if `self`.NPC!.group != nil {
        //So they don't all speak at once...
        //FIXME: if they're not yet mad, they have no group, so distracting a group of them makes them all speak!
        `self`.NPC!.group!.speechDebounceTime = level.time + Q_irand(2000, 4000)
    } else {
        TIMER_Set(`self`, "chatter", Q_irand(2000, 4000))
    }
    groupSpeechDebounceTime[`self`.client!.playerTeam] = level.time + Q_irand(2000, 4000)

    if `self`.NPC!.blockedSpeechDebounceTime > level.time {
        return
    }

    switch speechType {
    case SPEECH_CHASE:
        G_AddVoiceEvent(`self`, Q_irand(EV_CHASE1, EV_CHASE3), 2000)

    case SPEECH_CONFUSED:
        G_AddVoiceEvent(`self`, Q_irand(EV_CONFUSE1, EV_CONFUSE3), 2000)

    case SPEECH_COVER:
        G_AddVoiceEvent(`self`, Q_irand(EV_COVER1, EV_COVER5), 2000)

    case SPEECH_DETECTED:
        G_AddVoiceEvent(`self`, Q_irand(EV_DETECTED1, EV_DETECTED5), 2000)

    case SPEECH_GIVEUP:
        G_AddVoiceEvent(`self`, Q_irand(EV_GIVEUP1, EV_GIVEUP4), 2000)

    case SPEECH_LOOK:
        G_AddVoiceEvent(`self`, Q_irand(EV_LOOK1, EV_LOOK2), 2000)

    case SPEECH_LOST:
        G_AddVoiceEvent(`self`, EV_LOST1, 2000)

    case SPEECH_OUTFLANK:
        G_AddVoiceEvent(`self`, Q_irand(EV_OUTFLANK1, EV_OUTFLANK2), 2000)

    case SPEECH_ESCAPING:
        G_AddVoiceEvent(`self`, Q_irand(EV_ESCAPING1, EV_ESCAPING3), 2000)

    case SPEECH_SIGHT:
        G_AddVoiceEvent(`self`, Q_irand(EV_SIGHT1, EV_SIGHT3), 2000)

    case SPEECH_SOUND:
        G_AddVoiceEvent(`self`, Q_irand(EV_SOUND1, EV_SOUND3), 2000)

    case SPEECH_SUSPICIOUS:
        G_AddVoiceEvent(`self`, Q_irand(EV_SUSPICIOUS1, EV_SUSPICIOUS5), 2000)

    case SPEECH_YELL:
        G_AddVoiceEvent(`self`, Q_irand(EV_ANGER1, EV_ANGER3), 2000)

    case SPEECH_PUSHED:
        G_AddVoiceEvent(`self`, Q_irand(EV_PUSHED1, EV_PUSHED3), 2000)

    default:
        break
    }

    `self`.NPC!.blockedSpeechDebounceTime = level.time + 2000
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:227
func ST_MarkToCover(_ `self`: Entity) {
    if `self`.NPC == nil {
        return
    }
    `self`.NPC!.localState = LSTATE_UNDERFIRE
    TIMER_Set(`self`, "attackDelay", Q_irand(500, 2500))
    ST_AggressionAdjust(`self`, -3)
    if `self`.NPC!.group != nil && `self`.NPC!.group!.numGroup > 1 {
        ST_Speech(`self`, SPEECH_COVER, 0) //FIXME: flee sound?
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:242
func ST_StartFlee(_ `self`: Entity, _ enemy: Entity, _ dangerPoint: JKAShared.vec3_t, _ dangerLevel: Int32, _ minTime: Int32, _ maxTime: Int32) {
    if `self`.NPC == nil {
        return
    }
    G_StartFlee(`self`, enemy, dangerPoint, dangerLevel, minTime, maxTime)
    if `self`.NPC!.group != nil && `self`.NPC!.group!.numGroup > 1 {
        ST_Speech(`self`, SPEECH_COVER, 0) //FIXME: flee sound?
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:260
func NPC_ST_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    `self`.NPC!.localState = LSTATE_UNDERFIRE

    TIMER_Set(`self`, "duck", -1)
    TIMER_Set(`self`, "hideTime", -1)
    TIMER_Set(`self`, "stand", 2000)

    NPC_Pain(`self`, attacker, damage)

    if damage == 0 && `self`.health > 0 {
        //FIXME: better way to know I was pushed
        G_AddVoiceEvent(`self`, Q_irand(EV_PUSHED1, EV_PUSHED3), 2000)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:282
private func ST_HoldPosition() {
    if NPCInfo!.squadState == SQUAD_RETREAT {
        TIMER_Set(NPC!, "flee", -level.time)
    }
    TIMER_Set(NPC!, "verifyCP", Q_irand(1000, 3000)) //don't look for another one for a few seconds
    NPC_FreeCombatPoint(NPCInfo!.combatPoint, true)
    //NPCInfo->combatPoint = -1;//???
    if !trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
        //don't have a script waiting for me to get to my point, okay to stop trying and stand
        AI_GroupUpdateSquadstates(NPCInfo!.group!, NPC!, SQUAD_STAND_AND_SHOOT)
        NPCInfo!.goalEntity = nil
    }

    /*if ( TIMER_Done( NPC, "stand" ) )
    {//FIXME: what if can't shoot from this pos?
    TIMER_Set( NPC, "duck", Q_irand( 2000, 4000 ) );
    }
    */
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:304
func NPC_ST_SayMovementSpeech() {
    if NPCInfo!.movementSpeech == 0 {
        return
    }
    if NPCInfo!.group != nil && NPCInfo!.group!.commander != nil && NPCInfo!.group!.commander!.client != nil && NPCInfo!.group!.commander!.client!.NPC_class == CLASS_IMPERIAL && Q_irand(0, 3) == 0 {
        //imperial (commander) gives the order
        ST_Speech(NPCInfo!.group!.commander!, NPCInfo!.movementSpeech, NPCInfo!.movementSpeechChance)
    } else {
        //really don't want to say this unless we can actually get there...
        ST_Speech(NPC!, NPCInfo!.movementSpeech, NPCInfo!.movementSpeechChance)
    }

    NPCInfo!.movementSpeech = 0
    NPCInfo!.movementSpeechChance = 0.0
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:327
func NPC_ST_StoreMovementSpeech(_ speech: Int32, _ chance: Float) {
    NPCInfo!.movementSpeech = speech
    NPCInfo!.movementSpeechChance = chance
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:338
private func ST_Move() -> Bool {
    var moved: Bool = false
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return NavInfo.scratch { info -> Bool in

        NPCInfo!.combatMove = true //always move straight toward our goal

        moved = NPC_MoveToGoal(true)

        //Get the move info
        NAV_GetLastMove(info)

        //FIXME: if we bump into another one of our guys and can't get around him, just stop!
        //If we hit our target, then stop and fire!
        if (info.flags & NIF_COLLISION) != 0 {
            if info.blocker == NPC!.enemy {
                ST_HoldPosition()
            }
        }

        //If our move failed, then reset
        if moved == false {
            //FIXME: if we're going to a combat point, need to pick a different one
            if !trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
                //can't transfer movegoal or stop when a script we're running is waiting to complete
                if info.blocker != nil && info.blocker!.NPC != nil && NPCInfo!.group != nil && info.blocker!.NPC!.group == NPCInfo!.group {
                    //dammit, something is in our way
                    //see if it's one of ours
                    var j: Int32 = 0

                    j = 0
                    while j < NPCInfo!.group!.numGroup {
                        if NPCInfo!.group!.member[j].number == NPCInfo!.blockingEntNum {
                            //we're being blocked by one of our own, pass our goal onto them and I'll stand still
                            ST_TransferMoveGoal(NPC!, g_entities[NPCInfo!.group!.member[j].number])
                            break
                        }
                        j += 1
                    }
                }

                ST_HoldPosition()
            }
        } else {
            //First time you successfully move, say what it is you're doing
            NPC_ST_SayMovementSpeech()
        }

        return moved
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:399
private func NPC_ST_SleepShuffle() {
    //Play an awake script if we have one
    if G_ActivateBehavior(NPC!, BSET_AWAKE) {
        return
    }

    //Automate some movement and noise
    if TIMER_Done(NPC!, "shuffleTime") {
        //TODO: Play sleeping shuffle animation

        //int	soundIndex = Q_irand( 0, 1 );

        /*
        switch ( soundIndex )
        {
        case 0:
        G_Sound( NPC, G_SoundIndex("sound/chars/imperialsleeper1/scav4/hunh.mp3") );
        break;

        case 1:
        G_Sound( NPC, G_SoundIndex("sound/chars/imperialsleeper3/scav4/tryingtosleep.wav") );
        break;
        }
        */

        TIMER_Set(NPC!, "shuffleTime", 4000)
        TIMER_Set(NPC!, "sleepTime", 2000)
        return
    }

    //They made another noise while we were stirring, see if we can see them
    if TIMER_Done(NPC!, "sleepTime") {
        NPC_CheckPlayerTeamStealth()
        TIMER_Set(NPC!, "sleepTime", 2000)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:447
func NPC_BSST_Sleep() {
    let alertEvent: Int32 = NPC_CheckAlertEvents(false, true, -1, false, AEL_MINOR)

    //There is an event we heard
    if alertEvent >= 0 {
        //See if it was enough to wake us up
        if level.alertEvents[alertEvent].level == AEL_DISCOVERED && (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            //rwwFIXMEFIXME: Care about all clients not just 0
            if g_entities[0].health > 0 {
                G_SetEnemy(NPC!, g_entities[0])
                return
            }
        }

        //Otherwise just stir a bit
        NPC_ST_SleepShuffle()
        return
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:476
func NPC_CheckEnemyStealth(_ target: Entity) -> Bool {
    var target_dist: Float
    var minDist: Float = 40
    var maxViewDist: Float
    let clearLOS: Bool

    //In case we aquired one some other way
    if NPC!.enemy != nil {
        return true
    }

    //Ignore notarget
    if (target.flags & FL_NOTARGET) != 0 {
        return false
    }

    if target.health <= 0 {
        return false
    }

    if target.client!.ps.weapon == WP_SABER && target.client!.ps.saberHolstered == 0 && !target.client!.ps.saberInFlight {
        //if target has saber in hand and activated, we wake up even sooner even if not facing him
        minDist = 100
    }

    target_dist = DistanceSquared(target.r.currentOrigin, NPC!.r.currentOrigin)

    //If the target is this close, then wake up regardless
    if !((target.client!.ps.pm_flags & PMF_DUCKED) != 0) && (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 && (target_dist) < (minDist * minDist) {
        G_SetEnemy(NPC!, target)
        NPCInfo!.enemyLastSeenTime = level.time
        TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
        return true
    }

    maxViewDist = Float(MAX_VIEW_DIST)

    if NPCInfo!.stats.visrange > maxViewDist {
        //FIXME: should we always just set maxViewDist to this?
        maxViewDist = NPCInfo!.stats.visrange
    }

    if target_dist > (maxViewDist * maxViewDist) {
        //out of possible visRange
        return false
    }

    //Check FOV first
    if InFOV(target, NPC!, NPCInfo!.stats.hfov, NPCInfo!.stats.vfov) == false {
        return false
    }

    //clearLOS = ( target->client->ps.leanofs ) ? NPC_ClearLOS5( target->client->renderInfo.eyePoint ) : NPC_ClearLOS4( target );
    clearLOS = NPC_ClearLOS4(target)

    //Now check for clear line of vision
    if clearLOS {
        var targ_org = vec3_t()
        var hAngle_perc: Float
        var vAngle_perc: Float
        let target_speed: Float
        let target_crouching: Int32
        let dist_rating: Float
        var speed_rating: Float
        let turning_rating: Float
        let light_level: Float
        let FOV_perc: Float
        var vis_rating: Float
        let dist_influence: Float
        let fov_influence: Float
        let light_influence: Float
        var target_rating: Float
        let contents: Int32
        let realize: Float
        let cautious: Float

        if target.client!.NPC_class == CLASS_ATST {
            //can't miss 'em!
            G_SetEnemy(NPC!, target)
            TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
            return true
        }
        targ_org = vec3_t(target.r.currentOrigin[0], target.r.currentOrigin[1], target.r.currentOrigin[2] + target.r.maxs[2] - 4)
        hAngle_perc = NPC_GetHFOVPercentage(targ_org, NPC!.client!.renderInfo.eyePoint, NPC!.client!.renderInfo.eyeAngles, Float(NPCInfo!.stats.hfov))
        vAngle_perc = NPC_GetVFOVPercentage(targ_org, NPC!.client!.renderInfo.eyePoint, NPC!.client!.renderInfo.eyeAngles, Float(NPCInfo!.stats.vfov))

        //Scale them vertically some, and horizontally pretty harshly
        vAngle_perc *= vAngle_perc //( vAngle_perc * vAngle_perc );
        hAngle_perc *= (hAngle_perc * hAngle_perc)

        //Cap our vertical vision severely
        //if ( vAngle_perc <= 0.3f ) // was 0.5f
        //	return qfalse;

        //Assess the player's current status
        target_dist = Distance(target.r.currentOrigin, NPC!.r.currentOrigin)

        target_speed = VectorLength(target.client!.ps.velocity)
        target_crouching = ((target.client!.pers.cmd.upmove < 0) ? 1 : 0)
        dist_rating = (target_dist / maxViewDist)
        speed_rating = (target_speed / MAX_VIEW_SPEED)
        turning_rating = 5.0 //AngleDelta( target->client->ps.viewangles[PITCH], target->lastAngles[PITCH] )/180.0f + AngleDelta( target->client->ps.viewangles[YAW], target->lastAngles[YAW] )/180.0f;
        light_level = Float((255 / MAX_LIGHT_INTENSITY)) //( target->lightLevel / MAX_LIGHT_INTENSITY );
        FOV_perc = 1.0 - (hAngle_perc + vAngle_perc) * 0.5 //FIXME: Dunno about the average...
        vis_rating = 0.0

        //Too dark
        if Double(light_level) < MIN_LIGHT_THRESHOLD {
            return false
        }

        //Too close?
        if dist_rating < DISTANCE_THRESHOLD {
            G_SetEnemy(NPC!, target)
            TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
            return true
        }

        //Out of range
        if dist_rating > 1.0 {
            return false
        }

        //Cap our speed checks
        if speed_rating > 1.0 {
            speed_rating = 1.0
        }


        //Calculate the distance, fov and light influences
        //...Visibilty linearly wanes over distance
        dist_influence = DISTANCE_SCALE * ((1.0 - dist_rating))
        //...As the percentage out of the FOV increases, straight perception suffers on an exponential scale
        fov_influence = FOV_SCALE * (1.0 - FOV_perc)
        //...Lack of light hides, abundance of light exposes
        light_influence = (light_level - 0.5) * LIGHT_SCALE

        //Calculate our base rating
        target_rating = dist_influence + fov_influence + light_influence

        //Now award any final bonuses to this number
        contents = trap_PointContents(targ_org, target.s.number)
        if (contents & CONTENTS_WATER) != 0 {
            let myContents: Int32 = trap_PointContents(NPC!.client!.renderInfo.eyePoint, NPC!.s.number)
            if !((myContents & CONTENTS_WATER) != 0) {
                //I'm not in water
                if NPC!.client!.NPC_class == CLASS_SWAMPTROOPER {
                    //these guys can see in in/through water pretty well
                    vis_rating = 0.10 //10% bonus
                } else {
                    vis_rating = 0.35 //35% bonus
                }
            } else {
                //else, if we're both in water
                if NPC!.client!.NPC_class == CLASS_SWAMPTROOPER {
                    //I can see him just fine
                } else {
                    vis_rating = 0.15 //15% bonus
                }
            }
        } else {
            //not in water
            if (contents & CONTENTS_FOG) != 0 {
                vis_rating = 0.15 //15% bonus
            }
        }

        target_rating *= (1.0 - vis_rating)

        //...Motion draws the eye quickly
        target_rating += speed_rating * SPEED_SCALE
        target_rating += turning_rating * TURNING_SCALE
        //FIXME: check to see if they're animating, too?  But can we do something as simple as frame != oldframe?

        //...Smaller targets are harder to indentify
        if target_crouching != 0 {
            target_rating *= 0.9 //10% bonus
        }

        //If he's violated the threshold, then realize him
        //float difficulty_scale = 1.0f + (2.0f-g_spskill.value);//if playing on easy, 20% harder to be seen...?
        if NPC!.client!.NPC_class == CLASS_SWAMPTROOPER {
            //swamptroopers can see much better
            realize = Float(CAUTIOUS_THRESHOLD)
            cautious = Float(CAUTIOUS_THRESHOLD) * 0.75
        } else {
            realize = Float(REALIZE_THRESHOLD)
            cautious = Float(CAUTIOUS_THRESHOLD) * 0.75
        }

        if target_rating > realize && (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            G_SetEnemy(NPC!, target)
            NPCInfo!.enemyLastSeenTime = level.time
            TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
            return true
        }

        //If he's above the caution threshold, then realize him in a few seconds unless he moves to cover
        if target_rating > cautious && !((NPCInfo!.scriptFlags & SCF_IGNORE_ALERTS) != 0) {
            //FIXME: ambushing guys should never talk
            if TIMER_Done(NPC!, "enemyLastVisible") {
                //If we haven't already, start the counter
                let lookTime: Int32 = Q_irand(4500, 8500)
                //NPCInfo->timeEnemyLastVisible = level.time + 2000;
                TIMER_Set(NPC!, "enemyLastVisible", lookTime)
                //TODO: Play a sound along the lines of, "Huh?  What was that?"
                ST_Speech(NPC!, SPEECH_SIGHT, 0)
                NPC_TempLookTarget(NPC!, target.s.number, lookTime, lookTime)
                //FIXME: set desired yaw and pitch towards this guy?
            } else if TIMER_Get(NPC!, "enemyLastVisible") <= level.time + 500 && (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
                if NPCInfo!.rank < RANK_LT && Q_irand(0, 2) == 0 {
                    let interrogateTime: Int32 = Q_irand(2000, 4000)
                    ST_Speech(NPC!, SPEECH_SUSPICIOUS, 0)
                    TIMER_Set(NPC!, "interrogating", interrogateTime)
                    G_SetEnemy(NPC!, target)
                    NPCInfo!.enemyLastSeenTime = level.time
                    TIMER_Set(NPC!, "attackDelay", interrogateTime)
                    TIMER_Set(NPC!, "stand", interrogateTime)
                } else {
                    G_SetEnemy(NPC!, target)
                    NPCInfo!.enemyLastSeenTime = level.time
                    //FIXME: ambush guys (like those popping out of water) shouldn't delay...
                    TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
                    TIMER_Set(NPC!, "stand", Q_irand(500, 2500))
                }
                return true
            }

            return false
        }
    }

    return false
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:727
func NPC_CheckPlayerTeamStealth() -> Bool {
    /*
    //NOTENOTE: For now, all stealh checks go against the player, since
    //			he is the main focus.  Squad members and rivals do not
    //			fall into this category and will be ignored.

    NPC_CheckEnemyStealth( &g_entities[0] );	//Change this pointer to assess other entities
    */
    var enemy: Entity?
    var i: Int32

    i = 0
    while i < ENTITYNUM_WORLD {
        enemy = g_entities[i]

        if !enemy!.inuse {
            i += 1
            continue
        }

        if enemy != nil && enemy!.client != nil && NPC_ValidEnemy(enemy) && enemy!.client!.playerTeam == NPC!.client!.enemyTeam {
            if NPC_CheckEnemyStealth(enemy!) {
                return true
            }
        }
        i += 1
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:766
private func NPC_ST_InvestigateEvent(_ eventID: Int32, _ extraSuspicious: Bool) -> Bool {
    //If they've given themselves away, just take them as an enemy
    if NPCInfo!.confusionTime < level.time {
        if level.alertEvents[eventID].level == AEL_DISCOVERED && (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            NPCInfo!.lastAlertID = level.alertEvents[eventID].ID
            if level.alertEvents[eventID].owner == nil || level.alertEvents[eventID].owner!.client == nil || level.alertEvents[eventID].owner!.health <= 0 || level.alertEvents[eventID].owner!.client!.playerTeam != NPC!.client!.enemyTeam {
                //not an enemy
                return false
            }
            //FIXME: what if can't actually see enemy, don't know where he is... should we make them just become very alert and start looking for him?  Or just let combat AI handle this... (act as if you lost him)
            //ST_Speech( NPC, SPEECH_CHARGE, 0 );
            G_SetEnemy(NPC!, level.alertEvents[eventID].owner!)
            NPCInfo!.enemyLastSeenTime = level.time
            TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
            if level.alertEvents[eventID].type == AET_SOUND {
                //heard him, didn't see him, stick for a bit
                TIMER_Set(NPC!, "roamTime", Q_irand(500, 2500))
            }
            return true
        }
    }

    //don't look at the same alert twice
    if level.alertEvents[eventID].ID == NPCInfo!.lastAlertID {
        return false
    }
    NPCInfo!.lastAlertID = level.alertEvents[eventID].ID

    //Must be ready to take another sound event
    /*
    if ( NPCInfo->investigateSoundDebounceTime > level.time )
    {
    return qfalse;
    }
    */

    if level.alertEvents[eventID].type == AET_SIGHT {
        //sight alert, check the light level
        if level.alertEvents[eventID].light < Q_irand(ST_MIN_LIGHT_THRESHOLD, ST_MAX_LIGHT_THRESHOLD) {
            //below my threshhold of potentially seeing
            return false
        }
    }

    //Save the position for movement (if necessary)
    NPCInfo!.investigateGoal = level.alertEvents[eventID].position

    //First awareness of it
    NPCInfo!.investigateCount += (extraSuspicious) ? 2 : 1

    //Clamp the value
    if NPCInfo!.investigateCount > 4 {
        NPCInfo!.investigateCount = 4
    }

    //See if we should walk over and investigate
    if level.alertEvents[eventID].level > AEL_MINOR && NPCInfo!.investigateCount > 1 && (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        //make it so they can walk right to this point and look at it rather than having to use combatPoints
        if G_ExpandPointToBBox(&NPCInfo!.investigateGoal, NPC!.r.mins, NPC!.r.maxs, NPC!.s.number, ((NPC!.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP)) {
            //we were able to move the investigateGoal to a point in which our bbox would fit
            //drop the goal to the ground so we can get at it
            var end = vec3_t()
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { trace in
                end = NPCInfo!.investigateGoal
                end[2] -= 512 //FIXME: not always right?  What if it's even higher, somehow?
                trap_Trace(trace, NPCInfo!.investigateGoal, NPC!.r.mins, NPC!.r.maxs, end, ENTITYNUM_NONE, ((NPC!.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP))
                if trace.fraction >= 1.0 {
                    //too high to even bother
                    //FIXME: look at them???
                } else {
                    NPCInfo!.investigateGoal = trace.endpos
                    NPC_SetMoveGoal(NPC!, NPCInfo!.investigateGoal, 16, true, -1, nil)
                    NPCInfo!.localState = LSTATE_INVESTIGATE
                }
            }
        } else {
            let id: Int32 = NPC_FindCombatPoint(NPCInfo!.investigateGoal, NPCInfo!.investigateGoal, NPCInfo!.investigateGoal, CP_INVESTIGATE | CP_HAS_ROUTE, 0, -1)

            if id != -1 {
                NPC_SetMoveGoal(NPC!, level.combatPoints[id].origin, 16, true, id, nil)
                NPCInfo!.localState = LSTATE_INVESTIGATE
            }
        }
        //Say something
        //FIXME: only if have others in group... these should be responses?
        if NPCInfo!.investigateDebounceTime + NPCInfo!.pauseTime > level.time {
            //was already investigating
            if NPCInfo!.group != nil && NPCInfo!.group!.commander != nil && NPCInfo!.group!.commander!.client != nil && NPCInfo!.group!.commander!.client!.NPC_class == CLASS_IMPERIAL && Q_irand(0, 3) == 0 {
                ST_Speech(NPCInfo!.group!.commander!, SPEECH_LOOK, 0) //FIXME: "I'll go check it out" type sounds
            } else {
                ST_Speech(NPC!, SPEECH_LOOK, 0) //FIXME: "I'll go check it out" type sounds
            }
        } else {
            if level.alertEvents[eventID].type == AET_SIGHT {
                ST_Speech(NPC!, SPEECH_SIGHT, 0)
            } else if level.alertEvents[eventID].type == AET_SOUND {
                ST_Speech(NPC!, SPEECH_SOUND, 0)
            }
        }
        //Setup the debounce info
        NPCInfo!.investigateDebounceTime = NPCInfo!.investigateCount * 5000
        NPCInfo!.investigateSoundDebounceTime = level.time + 2000
        NPCInfo!.pauseTime = level.time
    } else {
        //just look?
        //Say something
        if level.alertEvents[eventID].type == AET_SIGHT {
            ST_Speech(NPC!, SPEECH_SIGHT, 0)
        } else if level.alertEvents[eventID].type == AET_SOUND {
            ST_Speech(NPC!, SPEECH_SOUND, 0)
        }
        //Setup the debounce info
        NPCInfo!.investigateDebounceTime = NPCInfo!.investigateCount * 1000
        NPCInfo!.investigateSoundDebounceTime = level.time + 1000
        NPCInfo!.pauseTime = level.time
        NPCInfo!.investigateGoal = level.alertEvents[eventID].position
    }

    if level.alertEvents[eventID].level >= AEL_DANGER {
        NPCInfo!.investigateDebounceTime = Q_irand(500, 2500)
    }

    //Start investigating
    NPCInfo!.tempBehavior = BS_INVESTIGATE
    return true
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:927
private func ST_OffsetLook(_ offset: Float, _ out: inout JKAShared.vec3_t) {
    var angles = vec3_t()
    var forward = vec3_t()
    var temp = vec3_t()

    GetAnglesForDirection(NPC!.r.currentOrigin, NPCInfo!.investigateGoal, &angles)
    angles[YAW] += offset
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    // Raven passes NULL for the right and up outputs.
    AngleVectors(angles, &forward, &scratchRight, &scratchUp)
    _VectorMA(NPC!.r.currentOrigin, 64, forward, &out)

    CalcEntitySpot(NPC!, SPOT_HEAD, &temp)
    out[2] = temp[2]
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:946
private func ST_LookAround() {
    var lookPos = vec3_t()
    let perc: Float = Float((level.time - NPCInfo!.pauseTime)) / Float(NPCInfo!.investigateDebounceTime)

    //Keep looking at the spot
    if Double(perc) < 0.25 {
        lookPos = NPCInfo!.investigateGoal
    } else if perc < 0.5 {
        ST_OffsetLook(0.0, &lookPos)
    } else if perc < 0.75 {
        ST_OffsetLook(45.0, &lookPos)
    } else {
        ST_OffsetLook(-45.0, &lookPos)
    }

    NPC_FacePosition(lookPos, true)
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:978
func NPC_BSST_Investigate() {
    //get group- mainly for group speech debouncing, but may use for group scouting/investigating AI, too
    AI_GetGroup(NPC!)

    if (NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0 {
        WeaponThink(true)
    }

    if NPCInfo!.confusionTime < level.time {
        if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            //Look for an enemy
            if NPC_CheckPlayerTeamStealth() {
                //NPCInfo->behaviorState	= BS_HUNT_AND_KILL;//should be auto now
                ST_Speech(NPC!, SPEECH_DETECTED, 0)
                NPCInfo!.tempBehavior = BS_DEFAULT
                NPC_UpdateAngles(true, true)
                return
            }
        }
    }

    if !((NPCInfo!.scriptFlags & SCF_IGNORE_ALERTS) != 0) {
        let alertEvent: Int32 = NPC_CheckAlertEvents(true, true, NPCInfo!.lastAlertID, false, AEL_MINOR)

        //There is an event to look at
        if alertEvent >= 0 {
            if NPCInfo!.confusionTime < level.time {
                if NPC_CheckForDanger(alertEvent) {
                    //running like hell
                    ST_Speech(NPC!, SPEECH_COVER, 0) //FIXME: flee sound?
                    return
                }
            }

            if level.alertEvents[alertEvent].ID != NPCInfo!.lastAlertID {
                NPC_ST_InvestigateEvent(alertEvent, true)
            }
        }
    }

    //If we're done looking, then just return to what we were doing
    if (NPCInfo!.investigateDebounceTime + NPCInfo!.pauseTime) < level.time {
        NPCInfo!.tempBehavior = BS_DEFAULT
        NPCInfo!.goalEntity = UpdateGoal()

        NPC_UpdateAngles(true, true)
        //Say something
        ST_Speech(NPC!, SPEECH_GIVEUP, 0)
        return
    }

    //FIXME: else, look for new alerts

    //See if we're searching for the noise's origin
    if NPCInfo!.localState == LSTATE_INVESTIGATE && (NPCInfo!.goalEntity != nil) {
        //See if we're there
        if NAV_HitNavGoal(NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPCInfo!.goalEntity!.r.currentOrigin, 32, FlyingCreature(NPC!)) == false {
            ucmd.buttons |= BUTTON_WALKING

            //Try and move there
            if NPC_MoveToGoal(true) {
                //Bump our times
                NPCInfo!.investigateDebounceTime = NPCInfo!.investigateCount * 5000
                NPCInfo!.pauseTime = level.time

                NPC_UpdateAngles(true, true)
                return
            }
        }

        //Otherwise we're done or have given up
        //Say something
        //ST_Speech( NPC, SPEECH_LOOK, 0.33f );
        NPCInfo!.localState = LSTATE_NONE
    }

    //Look around
    ST_LookAround()
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1077
func NPC_BSST_Patrol() {
    //FIXME: pick up on bodies of dead buddies?

    //get group- mainly for group speech debouncing, but may use for group scouting/investigating AI, too
    AI_GetGroup(NPC!)

    if NPCInfo!.confusionTime < level.time {
        //Look for any enemies
        if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            if NPC_CheckPlayerTeamStealth() {
                //NPCInfo->behaviorState = BS_HUNT_AND_KILL;//should be auto now
                //NPC_AngerSound();
                NPC_UpdateAngles(true, true)
                return
            }
        }
    }

    if !((NPCInfo!.scriptFlags & SCF_IGNORE_ALERTS) != 0) {
        let alertEvent: Int32 = NPC_CheckAlertEvents(true, true, -1, false, AEL_MINOR)

        //There is an event to look at
        if alertEvent >= 0 {
            if NPC_ST_InvestigateEvent(alertEvent, false) {
                //actually going to investigate it
                NPC_UpdateAngles(true, true)
                return
            }
        }
    }

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons |= BUTTON_WALKING
        //ST_Move( NPCInfo->goalEntity );
        NPC_MoveToGoal(true)
    } else {
        if NPC!.client!.NPC_class != CLASS_IMPERIAL && NPC!.client!.NPC_class != CLASS_IMPWORKER {
            //imperials do not look around
            if TIMER_Done(NPC!, "enemyLastVisible") {
                //nothing suspicious, look around
                if Q_irand(0, 30) == 0 {
                    NPCInfo!.desiredYaw = NPC!.s.angles[1] + Q_irand(-90, 90)
                }
                if Q_irand(0, 30) == 0 {
                    NPCInfo!.desiredPitch = Float(Q_irand(-20, 20))
                }
            }
        }
    }

    NPC_UpdateAngles(true, true)
    //TEMP hack for Imperial stand anim
    if NPC!.client!.NPC_class == CLASS_IMPERIAL || NPC!.client!.NPC_class == CLASS_IMPWORKER {
        //hack
        if ucmd.forwardmove != 0 || ucmd.rightmove != 0 || ucmd.upmove != 0 {
            //moving

            if (NPC!.client!.ps.torsoTimer <= 0) || (NPC!.client!.ps.torsoAnim == BOTH_STAND4) {
                if (ucmd.buttons & BUTTON_WALKING) != 0 && !((NPCInfo!.scriptFlags & SCF_RUNNING) != 0) {
                    //not running, only set upper anim
                    //  No longer overrides scripted anims
                    NPC_SetAnim(NPC!, SETANIM_TORSO, BOTH_STAND4, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    NPC!.client!.ps.torsoTimer = 200
                }
            }
        } else {
            //standing still, set both torso and legs anim
            //  No longer overrides scripted anims
            if (NPC!.client!.ps.torsoTimer <= 0 || (NPC!.client!.ps.torsoAnim == BOTH_STAND4)) && (NPC!.client!.ps.legsTimer <= 0 || (NPC!.client!.ps.legsAnim == BOTH_STAND4)) {
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_STAND4, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                NPC!.client!.ps.legsTimer = 200
                NPC!.client!.ps.torsoTimer = NPC!.client!.ps.legsTimer
            }
        }
        //FIXME: this is a disgusting hack that is supposed to make the Imperials start with their weapon holstered- need a better way
        if NPC!.client!.ps.weapon != WP_NONE {
            ChangeWeapon(NPC!, WP_NONE)
            NPC!.client!.ps.weapon = WP_NONE
            NPC!.client!.ps.weaponstate = WEAPON_READY
            /*
            if ( NPC->weaponModel[0] > 0 )
            {
            gi.G2API_RemoveGhoul2Model( NPC->ghoul2, NPC->weaponModel[0] );
            NPC->weaponModel[0] = -1;
            }
            */
            //rwwFIXMEFIXME: Do this?
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1212
private func ST_CheckMoveState() {
    if trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
        //moving toward a goal that a script is waiting on, so don't stop for anything!
        move = true
    } else if NPCInfo!.squadState == SQUAD_SCOUT {
        //See if we're a scout
        //If we're supposed to stay put, then stand there and fire
        if TIMER_Done(NPC!, "stick") == false {
            move = false
            return
        }

        //Otherwise, if we can see our target, just shoot
        if enemyLOS {
            if enemyCS {
                //if we're going after our enemy, we can stop now
                if NPCInfo!.goalEntity == NPC!.enemy {
                    AI_GroupUpdateSquadstates(NPCInfo!.group!, NPC!, SQUAD_STAND_AND_SHOOT)
                    move = false
                    return
                }
            }
        } else {
            //Move to find our target
            faceEnemy = false
        }

        /*
        if ( TIMER_Done( NPC, "scoutTime" ) )
        {//we can't scout to him, someone else give it a try
        AI_GroupUpdateSquadstates( NPCInfo->group, NPC, SQUAD_STAND_AND_SHOOT );
        TIMER_Set( NPC, "roamTime", Q_irand( 1000, 2000 ) );
        move = qfalse;
        return;
        }
        */

        //ucmd.buttons |= BUTTON_CAREFUL;
    } else if NPCInfo!.squadState == SQUAD_RETREAT {
        //See if we're running away
        if NPCInfo!.goalEntity != nil {
            faceEnemy = false
        } else {
            //um, lost our goal?  Just stand and shoot, then
            NPCInfo!.squadState = SQUAD_STAND_AND_SHOOT
        }
    } else if NPCInfo!.squadState == SQUAD_TRANSITION {
        //see if we're heading to some other combatPoint
        //ucmd.buttons |= BUTTON_CAREFUL;
        if NPCInfo!.goalEntity == nil {
            //um, lost our goal?  Just stand and shoot, then
            NPCInfo!.squadState = SQUAD_STAND_AND_SHOOT
        }
    } else if NPCInfo!.squadState == SQUAD_POINT {
        //see if we're at point, duck and fire
        if TIMER_Done(NPC!, "stick") {
            AI_GroupUpdateSquadstates(NPCInfo!.group!, NPC!, SQUAD_STAND_AND_SHOOT)
            return
        }

        move = false
        return
    } else if NPCInfo!.squadState == SQUAD_STAND_AND_SHOOT {
        //see if we're just standing around
        //from this squadState we can transition to others?
        move = false
        return
    } else if NPCInfo!.squadState == SQUAD_COVER {
        //see if we're hiding
        //Should we duck?
        move = false
        return
    } else if NPCInfo!.squadState == SQUAD_IDLE {
        //see if we're just standing around
        if NPCInfo!.goalEntity == nil {
            move = false
            return
        }
    } else {
        //??
        //invalid squadState!
    }

    //See if we're moving towards a goal, not the enemy
    if (NPCInfo!.goalEntity != NPC!.enemy) && (NPCInfo!.goalEntity != nil) {
        //Did we make it?
        if NAV_HitNavGoal(NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPCInfo!.goalEntity!.r.currentOrigin, 16, FlyingCreature(NPC!)) || (!trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) && NPCInfo!.squadState == SQUAD_SCOUT && enemyLOS && enemyDist <= 10000) {
            //either hit our navgoal or our navgoal was not a crucial (scripted) one (maybe a combat point) and we're scouting and found our enemy
            var newSquadState: Int32 = SQUAD_STAND_AND_SHOOT
            //we got where we wanted to go, set timers based on why we were running
            switch NPCInfo!.squadState {
            case SQUAD_RETREAT: //was running away
                //done fleeing, obviously
                TIMER_Set(NPC!, "duck", (NPC!.client!.pers.maxHealth - NPC!.health) * 100)
                TIMER_Set(NPC!, "hideTime", Q_irand(3000, 7000))
                TIMER_Set(NPC!, "flee", -level.time)
                newSquadState = SQUAD_COVER

            case SQUAD_TRANSITION: //was heading for a combat point
                TIMER_Set(NPC!, "hideTime", Q_irand(2000, 4000))

            case SQUAD_SCOUT: //was running after player
                break

            default:
                break
            }
            AI_GroupUpdateSquadstates(NPCInfo!.group!, NPC!, newSquadState)
            NPC_ReachedGoal()
            //don't attack right away
            TIMER_Set(NPC!, "attackDelay", Q_irand(250, 500)) //FIXME: Slant for difficulty levels
            //don't do something else just yet
            TIMER_Set(NPC!, "roamTime", Q_irand(1000, 4000))
            return
        }

        //keep going, hold of roamTimer until we get there
        TIMER_Set(NPC!, "roamTime", Q_irand(4000, 8000))
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1360
func ST_ResolveBlockedShot(_ hit: Int32) {
    let stuckTime: Int32
    //figure out how long we intend to stand here, max
    if TIMER_Get(NPC!, "roamTime") > TIMER_Get(NPC!, "stick") {
        stuckTime = TIMER_Get(NPC!, "roamTime") - level.time
    } else {
        stuckTime = TIMER_Get(NPC!, "stick") - level.time
    }

    if TIMER_Done(NPC!, "duck") {
        //we're not ducking
        if AI_GroupContainsEntNum(NPCInfo!.group!, hit) {
            let member: Entity? = g_entities[hit]
            if TIMER_Done(member!, "duck") {
                //they aren't ducking
                if TIMER_Done(member!, "stand") {
                    //they're not being forced to stand
                    //tell them to duck at least as long as I'm not moving
                    TIMER_Set(member!, "duck", stuckTime)
                    return
                }
            }
        }
    } else {
        //maybe we should stand
        if TIMER_Done(NPC!, "stand") {
            //stand for as long as we'll be here
            TIMER_Set(NPC!, "stand", stuckTime)
            return
        }
    }
    //Hmm, can't resolve this by telling them to duck or telling me to stand
    //We need to move!
    TIMER_Set(NPC!, "roamTime", -1)
    TIMER_Set(NPC!, "stick", -1)
    TIMER_Set(NPC!, "duck", -1)
    TIMER_Set(NPC!, "attakDelay", Q_irand(1000, 3000))
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1411
private func ST_CheckFireState() {
    if enemyCS {
        //if have a clear shot, always try
        return
    }

    if NPCInfo!.squadState == SQUAD_RETREAT || NPCInfo!.squadState == SQUAD_TRANSITION || NPCInfo!.squadState == SQUAD_SCOUT {
        //runners never try to fire at the last pos
        return
    }

    if VectorCompare(NPC!.client!.ps.velocity, vec3_origin) == 0 {
        //if moving at all, don't do this
        return
    }

    //See if we should continue to fire on their last position
    //!TIMER_Done( NPC, "stick" ) ||
    if !hitAlly && enemyInFOV && NPCInfo!.enemyLastSeenTime > 0 && NPCInfo!.group != nil && (NPCInfo!.group!.numState[SQUAD_RETREAT] > 0 || NPCInfo!.group!.numState[SQUAD_TRANSITION] > 0 || NPCInfo!.group!.numState[SQUAD_SCOUT] > 0) {
        if level.time - NPCInfo!.enemyLastSeenTime < 10000 && (NPCInfo!.group == nil || level.time - NPCInfo!.group!.lastSeenEnemyTime < 10000) {
            if Q_irand(0, 10) == 0 {
                //Fire on the last known position
                var muzzle = vec3_t()
                var dir = vec3_t()
                var angles = vec3_t()
                var tooClose: Bool = false
                var tooFar: Bool = false
                var distThreshold: Float = 0
                var dist: Float = 0

                CalcEntitySpot(NPC!, SPOT_HEAD, &muzzle)
                if VectorCompare(impactPos, vec3_origin) != 0 {
                    //never checked ShotEntity this frame, so must do a trace...
                    // Raven's record lives to the end of his block, so the block is the closure.
                    Trace.scratch { tr in
                        //vec3_t	mins = {-2,-2,-2}, maxs = {2,2,2};
                        var forward = vec3_t()
                        var end = vec3_t()
                        var scratchRight = vec3_t()
                        var scratchUp = vec3_t()
                        // Raven passes NULL for the right and up outputs.
                        AngleVectors(NPC!.client!.ps.viewangles, &forward, &scratchRight, &scratchUp)
                        _VectorMA(muzzle, 8192, forward, &end)
                        trap_Trace(tr, muzzle, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SHOT)
                        impactPos = tr.endpos
                    }
                }

                //see if impact would be too close to me
                distThreshold = 16384
                switch NPC!.s.weapon {
                case WP_ROCKET_LAUNCHER, WP_FLECHETTE, WP_THERMAL, WP_TRIP_MINE, WP_DET_PACK:
                    distThreshold = 65536

                case WP_REPEATER:
                    if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                        distThreshold = 65536
                    }

                default:
                    break
                }

                dist = DistanceSquared(impactPos, muzzle)

                if dist < distThreshold {
                    //impact would be too close to me
                    tooClose = true
                } else if level.time - NPCInfo!.enemyLastSeenTime > 5000 || (NPCInfo!.group != nil && level.time - NPCInfo!.group!.lastSeenEnemyTime > 5000) {
                    //we've haven't seen them in the last 5 seconds
                    //see if it's too far from where he is
                    distThreshold = 65536
                    switch NPC!.s.weapon {
                    case WP_ROCKET_LAUNCHER, WP_FLECHETTE, WP_THERMAL, WP_TRIP_MINE, WP_DET_PACK:
                        distThreshold = 262144

                    case WP_REPEATER:
                        if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                            distThreshold = 262144
                        }

                    default:
                        break
                    }
                    dist = DistanceSquared(impactPos, NPCInfo!.enemyLastSeenLocation)
                    if dist > distThreshold {
                        //impact would be too far from enemy
                        tooFar = true
                    }
                }

                if !tooClose && !tooFar {
                    //okay too shoot at last pos
                    dir = NPCInfo!.enemyLastSeenLocation - muzzle
                    VectorNormalize(&dir)
                    vectoangles(dir, &angles)

                    NPCInfo!.desiredYaw = angles[YAW]
                    NPCInfo!.desiredPitch = angles[PITCH]

                    shoot = true
                    faceEnemy = false
                    //AI_GroupUpdateSquadstates( NPCInfo->group, NPC, SQUAD_STAND_AND_SHOOT );
                    return
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1536
func ST_TrackEnemy(_ `self`: Entity, _ enemyPos: JKAShared.vec3_t) {
    //clear timers
    TIMER_Set(`self`, "attackDelay", Q_irand(1000, 2000))
    //TIMER_Set( self, "duck", -1 );
    TIMER_Set(`self`, "stick", Q_irand(500, 1500))
    TIMER_Set(`self`, "stand", -1)
    TIMER_Set(`self`, "scoutTime", TIMER_Get(`self`, "stick") - level.time + Q_irand(5000, 10000))
    //leave my combat point
    NPC_FreeCombatPoint(`self`.NPC!.combatPoint, false)
    //go after his last seen pos
    NPC_SetMoveGoal(`self`, enemyPos, 16, false, -1, nil)
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1550
func ST_ApproachEnemy(_ `self`: Entity) -> Int32 {
    TIMER_Set(`self`, "attackDelay", Q_irand(250, 500))
    //TIMER_Set( self, "duck", -1 );
    TIMER_Set(`self`, "stick", Q_irand(1000, 2000))
    TIMER_Set(`self`, "stand", -1)
    TIMER_Set(`self`, "scoutTime", TIMER_Get(`self`, "stick") - level.time + Q_irand(5000, 10000))
    //leave my combat point
    NPC_FreeCombatPoint(`self`.NPC!.combatPoint, false)
    //return the relevant combat point flags
    return (CP_CLEAR | CP_CLOSEST)
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1563
func ST_HuntEnemy(_ `self`: Entity) {
    //TIMER_Set( NPC, "attackDelay", Q_irand( 250, 500 ) );//Disabled this for now, guys who couldn't hunt would never attack
    //TIMER_Set( NPC, "duck", -1 );
    TIMER_Set(NPC!, "stick", Q_irand(250, 1000))
    TIMER_Set(NPC!, "stand", -1)
    TIMER_Set(NPC!, "scoutTime", TIMER_Get(NPC!, "stick") - level.time + Q_irand(5000, 10000))
    //leave my combat point
    NPC_FreeCombatPoint(NPCInfo!.combatPoint, false)
    //go directly after the enemy
    if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        `self`.NPC!.goalEntity = NPC!.enemy
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1579
func ST_TransferTimers(_ `self`: Entity, _ other: Entity) {
    TIMER_Set(other, "attackDelay", TIMER_Get(`self`, "attackDelay") - level.time)
    TIMER_Set(other, "duck", TIMER_Get(`self`, "duck") - level.time)
    TIMER_Set(other, "stick", TIMER_Get(`self`, "stick") - level.time)
    TIMER_Set(other, "scoutTime", TIMER_Get(`self`, "scout") - level.time)
    TIMER_Set(other, "roamTime", TIMER_Get(`self`, "roamTime") - level.time)
    TIMER_Set(other, "stand", TIMER_Get(`self`, "stand") - level.time)
    TIMER_Set(`self`, "attackDelay", -1)
    TIMER_Set(`self`, "duck", -1)
    TIMER_Set(`self`, "stick", -1)
    TIMER_Set(`self`, "scoutTime", -1)
    TIMER_Set(`self`, "roamTime", -1)
    TIMER_Set(`self`, "stand", -1)
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1595
func ST_TransferMoveGoal(_ `self`: Entity, _ other: Entity) {
    if trap_ICARUS_TaskIDPending(`self`, TID_MOVE_NAV) {
        //can't transfer movegoal when a script we're running is waiting to complete
        return
    }
    if `self`.NPC!.combatPoint != -1 {
        //I've got a combatPoint I'm going to, give it to him
        other.NPC!.combatPoint = `self`.NPC!.combatPoint
        `self`.NPC!.lastFailedCombatPoint = other.NPC!.combatPoint
        `self`.NPC!.combatPoint = -1
    } else {
        //I must be going for a goal, give that to him instead
        if `self`.NPC!.goalEntity == `self`.NPC!.tempGoal {
            NPC_SetMoveGoal(other, `self`.NPC!.tempGoal!.r.currentOrigin, `self`.NPC!.goalRadius, ((`self`.NPC!.tempGoal!.flags & FL_NAVGOAL) != 0 ? true : false), -1, nil)
        } else {
            other.NPC!.goalEntity = `self`.NPC!.goalEntity
        }
    }
    //give him my squadstate
    AI_GroupUpdateSquadstates(`self`.NPC!.group!, other, NPCInfo!.squadState)

    //give him my timers and clear mine
    ST_TransferTimers(`self`, other)

    //now make me stand around for a second or two at least
    AI_GroupUpdateSquadstates(`self`.NPC!.group!, `self`, SQUAD_STAND_AND_SHOOT)
    TIMER_Set(`self`, "stand", Q_irand(1000, 3000))
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1628
func ST_GetCPFlags() -> Int32 {
    var cpFlags: Int32 = 0
    if NPC != nil && NPCInfo!.group != nil {
        if NPC == NPCInfo!.group!.commander && NPC!.client!.NPC_class == CLASS_IMPERIAL {
            //imperials hang back and give orders
            if NPCInfo!.group!.numGroup > 1 && Q_irand(-3, NPCInfo!.group!.numGroup) > 1 {
                //FIXME: make sure he;s giving orders with these lines
                if Q_irand(0, 1) != 0 {
                    ST_Speech(NPC!, SPEECH_CHASE, 0.5)
                } else {
                    ST_Speech(NPC!, SPEECH_YELL, 0.5)
                }
            }
            cpFlags = (CP_CLEAR | CP_COVER | CP_AVOID | CP_SAFE | CP_RETREAT)
        } else if NPCInfo!.group!.morale < 0 {
            //hide
            cpFlags = (CP_COVER | CP_AVOID | CP_SAFE | CP_RETREAT)
        } else if NPCInfo!.group!.morale < NPCInfo!.group!.numGroup {
            //morale is low for our size
            let moraleDrop: Int32 = NPCInfo!.group!.numGroup - NPCInfo!.group!.morale
            if moraleDrop < -6 {
                //flee (no clear shot needed)
                cpFlags = (CP_FLEE | CP_RETREAT | CP_COVER | CP_AVOID | CP_SAFE)
            } else if moraleDrop < -3 {
                //retreat (no clear shot needed)
                cpFlags = (CP_RETREAT | CP_COVER | CP_AVOID | CP_SAFE)
            } else if moraleDrop < 0 {
                //cover (no clear shot needed)
                cpFlags = (CP_COVER | CP_AVOID | CP_SAFE)
            }
        } else {
            let moraleBoost: Int32 = NPCInfo!.group!.morale - NPCInfo!.group!.numGroup
            if moraleBoost > 20 {
                //charge to any one and outflank (no cover needed)
                cpFlags = (CP_CLEAR | CP_FLANK | CP_APPROACH_ENEMY)
            } else if moraleBoost > 15 {
                //charge to closest one (no cover needed)
                cpFlags = (CP_CLEAR | CP_CLOSEST | CP_APPROACH_ENEMY)
            } else if moraleBoost > 10 {
                //charge closer (no cover needed)
                cpFlags = (CP_CLEAR | CP_APPROACH_ENEMY)
            }
        }
    }
    if cpFlags == 0 {
        //at some medium level of morale
        switch Q_irand(0, 3) {
        case 0: //just take the nearest one
            cpFlags = (CP_CLEAR | CP_COVER | CP_NEAREST)

        case 1: //take one closer to the enemy
            cpFlags = (CP_CLEAR | CP_COVER | CP_APPROACH_ENEMY)

        case 2: //take the one closest to the enemy
            cpFlags = (CP_CLEAR | CP_COVER | CP_CLOSEST | CP_APPROACH_ENEMY)

        case 3: //take the one on the other side of the enemy
            cpFlags = (CP_CLEAR | CP_COVER | CP_FLANK | CP_APPROACH_ENEMY)

        default:
            break
        }
    }
    if NPC != nil && (NPCInfo!.scriptFlags & SCF_USE_CP_NEAREST) != 0 {
        cpFlags &= ~(CP_FLANK | CP_APPROACH_ENEMY | CP_CLOSEST)
        cpFlags |= CP_NEAREST
    }
    return cpFlags
}

/**
```
-------------------------
ST_Commander

  Make decisions about who should go where, etc.

FIXME: leader (group-decision-making) AI?
FIXME: need alternate routes!
FIXME: more group voice interaction
FIXME: work in pairs?

-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:1724
func ST_Commander() {
    var i: Int32
    var j: Int32
    var cp: Int32
    var cpFlags_org: Int32
    var cpFlags: Int32
    let group: AIGroupInfo? = NPCInfo!.group
    var member: Entity?
    var runner: Bool = false
    var enemyLost: Bool = false
    var enemyProtected: Bool = false
    var scouting: Bool = false
    var squadState: Int32
    let curMemberNum: Int32
    let lastMemberNum: Int32
    var avoidDist: Float

    group!.processed = true

    if group!.enemy == nil || group!.enemy!.client == nil {
        //hmm, no enemy...?!
        return
    }

    //FIXME: have this group commander check the enemy group (if any) and see if they have
    //		superior numbers.  If they do, fall back rather than advance.  If you have
    //		superior numbers, advance on them.
    //FIXME: find the group commander and have him occasionally give orders when there is speech
    //FIXME: start fleeing when only a couple of you vs. a lightsaber, possibly give up if the only one left

    SaveNPCGlobals()

    if group!.lastSeenEnemyTime < level.time - 180000 {
        //dissolve the group
        ST_Speech(NPC!, SPEECH_LOST, 0.0)
        group!.enemy!.waypoint = NAV_FindClosestWaypointForEnt(group!.enemy!, WAYPOINT_NONE)
        i = 0
        while i < group!.numGroup {
            member = g_entities[group!.member[i].number]
            SetNPCGlobals(member!)
            if trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
                //running somewhere that a script requires us to go, don't break from that
                i += 1
                continue
            }
            if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) {
                //not allowed to move on my own
                i += 1
                continue
            }
            //Lost enemy for three minutes?  go into search mode?
            G_ClearEnemy(NPC!)
            NPC!.waypoint = NAV_FindClosestWaypointForEnt(NPC!, group!.enemy!.waypoint)
            if NPC!.waypoint == WAYPOINT_NONE {
                NPCInfo!.behaviorState = BS_DEFAULT //BS_PATROL;
            } else if group!.enemy!.waypoint == WAYPOINT_NONE || (trap_Nav_GetPathCost(NPC!.waypoint, group!.enemy!.waypoint) >= Q3_INFINITE) {
                NPC_BSSearchStart(NPC!.waypoint, BS_SEARCH)
            } else {
                NPC_BSSearchStart(group!.enemy!.waypoint, BS_SEARCH)
            }
            i += 1
        }
        group!.enemy = nil
        RestoreNPCGlobals()
        return
    }


    //See if anyone in our group is not alerted and alert them
    /*
    for ( i = 0; i < group->numGroup; i++ )
    {
    member = &g_entities[group->member[i].number];
    if ( !member->enemy )
    {//he's not mad, so get him mad
    //Have his buddy tell him to get mad
    if ( group->member[i].closestBuddy != ENTITYNUM_NONE )
    {
    buddy = &g_entities[group->member[i].closestBuddy];
    if ( buddy->enemy == group->enemy )
    {
    SetNPCGlobals( buddy );
    ST_Speech( NPC, SPEECH_CHARGE, 0.7f );
    }
    }
    SetNPCGlobals( member );
    G_SetEnemy( member, group->enemy );
    }
    }
    */
    //Okay, everyone is mad

    //see if anyone is running
    if group!.numState[SQUAD_SCOUT] > 0 || group!.numState[SQUAD_TRANSITION] > 0 || group!.numState[SQUAD_RETREAT] > 0 {
        //someone is running
        runner = true
    }

    if group!.lastSeenEnemyTime > level.time - 32000 && group!.lastSeenEnemyTime < level.time - 30000 {
        //no-one has seen the enemy for 30 seconds// and no-one is running after him
        if group!.commander != nil && Q_irand(0, 1) == 0 {
            ST_Speech(group!.commander!, SPEECH_ESCAPING, 0.0)
        } else {
            ST_Speech(NPC!, SPEECH_ESCAPING, 0.0)
        }
        //don't say this again
        NPCInfo!.blockedSpeechDebounceTime = level.time + 3000
    }

    if group!.lastSeenEnemyTime < level.time - 10000 {
        //no-one has seen the enemy for at least 10 seconds!  Should send a scout
        enemyLost = true
    }

    if group!.lastClearShotTime < level.time - 5000 {
        //no-one has had a clear shot for 5 seconds!
        enemyProtected = true
    }

    //Go through the list:

    //Everyone should try to get to a combat point if possible
    if d_asynchronousGroupAI.integer != 0 {
        //do one member a turn
        group!.activeMemberNum += 1
        if group!.activeMemberNum >= group!.numGroup {
            group!.activeMemberNum = 0
        }
        curMemberNum = group!.activeMemberNum
        lastMemberNum = curMemberNum + 1
    } else {
        curMemberNum = 0
        lastMemberNum = group!.numGroup
    }
    i = curMemberNum
    while i < lastMemberNum {
        //reset combat point flags
        cp = -1
        cpFlags = 0
        squadState = SQUAD_IDLE
        avoidDist = 0
        scouting = false

        //get the next guy
        member = g_entities[group!.member[i].number]
        if member!.enemy == nil {
            //don't include guys that aren't angry
            i += 1
            continue
        }
        SetNPCGlobals(member!)

        if !TIMER_Done(NPC!, "flee") {
            //running away
            i += 1
            continue
        }

        if trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
            //running somewhere that a script requires us to go
            i += 1
            continue
        }

        if NPC!.s.weapon == WP_NONE && NPCInfo!.goalEntity != nil && NPCInfo!.goalEntity == NPCInfo!.tempGoal && NPCInfo!.goalEntity!.enemy != nil && NPCInfo!.goalEntity!.enemy!.s.eType == ET_ITEM {
            //running to pick up a gun, don't do other logic
            i += 1
            continue
        }

        //see if this member should start running (only if have no officer... FIXME: should always run from AEL_DANGER_GREAT?)
        if group!.commander == nil || group!.commander!.NPC!.rank < RANK_ENSIGN {
            if NPC_CheckForDanger(NPC_CheckAlertEvents(true, true, -1, false, AEL_DANGER)) {
                //going to run
                ST_Speech(NPC!, SPEECH_COVER, 0)
                i += 1
                continue
            }
        }

        if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) {
            //not allowed to do combat-movement
            i += 1
            continue
        }

        //check the local state
        if NPCInfo!.squadState != SQUAD_RETREAT {
            //not already retreating
            if NPC!.client!.ps.weapon == WP_NONE {
                //weaponless, should be hiding
                if NPCInfo!.goalEntity == nil || NPCInfo!.goalEntity!.enemy == nil || NPCInfo!.goalEntity!.enemy!.s.eType != ET_ITEM {
                    //not running after a pickup
                    if TIMER_Done(NPC!, "hideTime") || (DistanceSquared(group!.enemy!.r.currentOrigin, NPC!.r.currentOrigin) < 65536 && NPC_ClearLOS4(NPC!.enemy!)) {
                        //done hiding or enemy near and can see us
                        //er, start another flee I guess?
                        NPC_StartFlee(NPC!.enemy!, NPC!.enemy!.r.currentOrigin, AEL_DANGER_GREAT, 5000, 10000)
                    }
                }
                i += 1
                continue
            }
            if TIMER_Done(NPC!, "roamTime") && TIMER_Done(NPC!, "hideTime") && NPC!.health > 10 && !trap_InPVS(group!.enemy!.r.currentOrigin, NPC!.r.currentOrigin) {
                //cant even see enemy
                //better go after him
                cpFlags |= (CP_CLEAR | CP_COVER)
            } else if NPCInfo!.localState == LSTATE_UNDERFIRE {
                //we've been shot
                switch group!.enemy!.client!.ps.weapon {
                case WP_SABER:
                    if DistanceSquared(group!.enemy!.r.currentOrigin, NPC!.r.currentOrigin) < 65536 {
                        cpFlags |= (CP_AVOID_ENEMY | CP_COVER | CP_AVOID | CP_RETREAT)
                        if group!.commander == nil || group!.commander!.NPC!.rank < RANK_ENSIGN {
                            squadState = SQUAD_RETREAT
                        }
                        avoidDist = 256
                    }

                default:
                    cpFlags |= (CP_COVER)
                }
                if NPC!.health <= 10 {
                    if group!.commander == nil || group!.commander!.NPC!.rank < RANK_ENSIGN {
                        cpFlags |= (CP_FLEE | CP_AVOID | CP_RETREAT)
                        squadState = SQUAD_RETREAT
                    }
                }
            } else {
                //not hit, see if there are other reasons we should run
                if trap_InPVS(NPC!.r.currentOrigin, group!.enemy!.r.currentOrigin) {
                    //in the same room as enemy
                    if NPC!.client!.ps.weapon == WP_ROCKET_LAUNCHER && DistanceSquared(group!.enemy!.r.currentOrigin, NPC!.r.currentOrigin) < MIN_ROCKET_DIST_SQUARED && NPCInfo!.squadState != SQUAD_TRANSITION {
                        //too close for me to fire my weapon and I'm not already on the move
                        cpFlags |= (CP_AVOID_ENEMY | CP_CLEAR | CP_AVOID)
                        avoidDist = 256
                    } else {
                        switch group!.enemy!.client!.ps.weapon {
                        case WP_SABER:
                            //if ( group->enemy->client->ps.SaberLength() > 0 )
                            if group!.enemy!.client!.ps.saberHolstered == 0 {
                                if DistanceSquared(group!.enemy!.r.currentOrigin, NPC!.r.currentOrigin) < 65536 {
                                    if TIMER_Done(NPC!, "hideTime") {
                                        if NPCInfo!.squadState != SQUAD_TRANSITION {
                                            //not already moving: FIXME: we need to see if where we're going is good now?
                                            cpFlags |= (CP_AVOID_ENEMY | CP_CLEAR | CP_AVOID)
                                            avoidDist = 256
                                        }
                                    }
                                }
                            }
                            fallthrough

                        default:
                            break
                        }
                    }
                }
            }
        }

        if cpFlags == 0 {
            //okay, we have no new enemy-driven reason to run... let's use tactics now
            if runner && NPCInfo!.combatPoint != -1 {
                //someone is running and we have a combat point already
                if NPCInfo!.squadState != SQUAD_SCOUT && NPCInfo!.squadState != SQUAD_TRANSITION && NPCInfo!.squadState != SQUAD_RETREAT {
                    //it's not us
                    if TIMER_Done(NPC!, "verifyCP") && DistanceSquared(NPC!.r.currentOrigin, level.combatPoints[NPCInfo!.combatPoint].origin) > 64 * 64 {
                        //1 - 3 seconds have passed since you chose a CP, see if you're there since, for some reason, you've stopped running...
                        //uh, WTF, we're not on our combat point?
                        //er, try again, I guess?
                        cp = NPCInfo!.combatPoint
                        cpFlags |= ST_GetCPFlags()
                    } else {
                        //cover them
                        //stop ducking
                        TIMER_Set(NPC!, "duck", -1)
                        //start shooting
                        TIMER_Set(NPC!, "attackDelay", -1)
                        //AI should take care of the rest - fire at enemy
                    }
                } else {
                    //we're running
                    //see if we're blocked
                    if (NPCInfo!.aiFlags & NPCAI_BLOCKED) != 0 {
                        //dammit, something is in our way
                        //see if it's one of ours
                        j = 0
                        while j < group!.numGroup {
                            if group!.member[j].number == NPCInfo!.blockingEntNum {
                                //we're being blocked by one of our own, pass our goal onto them and I'll stand still
                                ST_TransferMoveGoal(NPC!, g_entities[group!.member[j].number])
                                break
                            }
                            j += 1
                        }
                    }
                    //we don't need to do anything else
                    i += 1
                    continue
                }
            } else {
                //okay no-one is running, use some tactics
                if NPCInfo!.combatPoint != -1 {
                    //we have a combat point we're supposed to be running to
                    if NPCInfo!.squadState != SQUAD_SCOUT && NPCInfo!.squadState != SQUAD_TRANSITION && NPCInfo!.squadState != SQUAD_RETREAT {
                        //but we're not running
                        if TIMER_Done(NPC!, "verifyCP") {
                            //1 - 3 seconds have passed since you chose a CP, see if you're there since, for some reason, you've stopped running...
                            if DistanceSquared(NPC!.r.currentOrigin, level.combatPoints[NPCInfo!.combatPoint].origin) > 64 * 64 {
                                //uh, WTF, we're not on our combat point?
                                //er, try again, I guess?
                                cp = NPCInfo!.combatPoint
                                cpFlags |= ST_GetCPFlags()
                            }
                        }
                    }
                }
                if enemyLost {
                    //if no-one has seen the enemy for a while, send a scout
                    //ask where he went
                    if group!.numState[SQUAD_SCOUT] <= 0 {
                        scouting = true
                        NPC_ST_StoreMovementSpeech(SPEECH_CHASE, 0.0)
                    }
                    //Since no-one else has done this, I should be the closest one, so go after him...
                    ST_TrackEnemy(NPC!, group!.enemyLastSeenPos)
                    //set me into scout mode
                    AI_GroupUpdateSquadstates(group!, NPC!, SQUAD_SCOUT)
                    //we're not using a cp, so we need to set runner to true right here
                    runner = true
                } else if enemyProtected {
                    //if no-one has a clear shot at the enemy, someone should go after him
                    //FIXME: if I'm in an area where no safe combat points have a clear shot at me, they don't come after me... they should anyway, though after some extra hesitation.
                    //ALSO: seem to give up when behind an area portal?
                    //since no-one else here has done this, I should be the closest one
                    if TIMER_Done(NPC!, "roamTime") && Q_irand(0, group!.numGroup) == 0 {
                        //only do this if we're ready to move again and we feel like it
                        cpFlags |= ST_ApproachEnemy(NPC!)
                        //set me into scout mode
                        AI_GroupUpdateSquadstates(group!, NPC!, SQUAD_SCOUT)
                    }
                } else {
                    //group can see and has been shooting at the enemy
                    //see if we should do something fancy?

                    do {
                        //we're ready to move
                        if NPCInfo!.combatPoint == -1 {
                            //we're not on a combat point
                            if 1 != 0 {
                                //we should go for a combat point
                                cpFlags |= ST_GetCPFlags()
                            } else {
                                TIMER_Set(NPC!, "stick", Q_irand(2000, 4000))
                                TIMER_Set(NPC!, "roamTime", Q_irand(1000, 3000))
                            }
                        } else if TIMER_Done(NPC!, "roamTime") {
                            //we are already on a combat point
                            if i == 0 {
                                //we're the closest
                                if (group!.morale - group!.numGroup > 0) && Q_irand(0, 4) == 0 {
                                    //try to outflank him
                                    cpFlags |= (CP_CLEAR | CP_COVER | CP_FLANK | CP_APPROACH_ENEMY)
                                } else if (group!.morale - group!.numGroup < 0) {
                                    //better move!
                                    cpFlags |= ST_GetCPFlags()
                                } else {
                                    //If we're point, then get down
                                    TIMER_Set(NPC!, "roamTime", Q_irand(2000, 5000))
                                    TIMER_Set(NPC!, "stick", Q_irand(2000, 5000))
                                    //FIXME: what if we can't shoot from a ducked pos?
                                    TIMER_Set(NPC!, "duck", Q_irand(3000, 4000))
                                    AI_GroupUpdateSquadstates(group!, NPC!, SQUAD_POINT)
                                }
                            } else if i == group!.numGroup - 1 {
                                //farthest from the enemy
                                if (group!.morale - group!.numGroup < 0) {
                                    //low morale, just hang here
                                    TIMER_Set(NPC!, "roamTime", Q_irand(2000, 5000))
                                    TIMER_Set(NPC!, "stick", Q_irand(2000, 5000))
                                } else if (group!.morale - group!.numGroup > 0) {
                                    //try to move in on the enemy
                                    cpFlags |= ST_ApproachEnemy(NPC!)
                                    //set me into scout mode
                                    AI_GroupUpdateSquadstates(group!, NPC!, SQUAD_SCOUT)
                                } else {
                                    //use normal decision making process
                                    cpFlags |= ST_GetCPFlags()
                                }
                            } else {
                                //someone in-between
                                if (group!.morale - group!.numGroup < 0) || Q_irand(0, 4) == 0 {
                                    //do something
                                    cpFlags |= ST_GetCPFlags()
                                } else {
                                    TIMER_Set(NPC!, "stick", Q_irand(2000, 4000))
                                    TIMER_Set(NPC!, "roamTime", Q_irand(2000, 4000))
                                }
                            }
                        }
                    }
                    if cpFlags == 0 {
                        //still not moving
                        //see if we should say something?
                        /*
                        if ( NPC->attackDebounceTime < level.time - 2000 )
                        {//we, personally, haven't shot for 2 seconds
                        //maybe yell at the enemy?
                        ST_Speech( NPC, SPEECH_CHARGE, 0.9f );
                        }
                        */

                        //see if we should do other fun stuff
                        //toy with ducking
                        if TIMER_Done(NPC!, "duck") {
                            //not ducking
                            if TIMER_Done(NPC!, "stand") {
                                //don't have to keep standing
                                if NPCInfo!.combatPoint == -1 || (level.combatPoints[NPCInfo!.combatPoint].flags & CPF_DUCK) != 0 {
                                    //okay to duck here
                                    if Q_irand(0, 3) == 0 {
                                        TIMER_Set(NPC!, "duck", Q_irand(1000, 3000))
                                    }
                                }
                            }
                        }
                        //FIXME: what about CPF_LEAN?
                    }
                }
            }
        }

        //clear the local state
        NPCInfo!.localState = LSTATE_NONE

        if (NPCInfo!.scriptFlags & SCF_USE_CP_NEAREST) != 0 {
            cpFlags &= ~(CP_FLANK | CP_APPROACH_ENEMY | CP_CLOSEST)
            cpFlags |= CP_NEAREST
        }
        //Assign combat points
        if cpFlags != 0 {
            //we want to run to a combat point
            /*
            if ( NPCInfo->combatPoint != -1 )
            {//if we're on a combat point, we obviously don't want the one we're closest to
            cpFlags |= CP_AVOID;
            }
            */

            if group!.enemy!.client!.ps.weapon == WP_SABER && group!.enemy!.client!.ps.saberHolstered == 0 {
                //we obviously want to avoid the enemy if he has a saber
                cpFlags |= CP_AVOID_ENEMY
                avoidDist = 256
            }

            //remember what we *wanted* to do...
            cpFlags_org = cpFlags

            //now get a combat point
            if cp == -1 {
                //may have had sone set above
                cp = NPC_FindCombatPoint(NPC!.r.currentOrigin, NPC!.r.currentOrigin, group!.enemy!.r.currentOrigin, cpFlags | CP_HAS_ROUTE, avoidDist, NPCInfo!.lastFailedCombatPoint)
            }
            while cp == -1 && cpFlags != CP_ANY {
                //start "OR"ing out certain flags to see if we can find *any* point
                if (cpFlags & CP_INVESTIGATE) != 0 {
                    //don't need to investigate
                    cpFlags &= ~CP_INVESTIGATE
                } else if (cpFlags & CP_SQUAD) != 0 {
                    //don't need to stick to squads
                    cpFlags &= ~CP_SQUAD
                } else if (cpFlags & CP_DUCK) != 0 {
                    //don't need to duck
                    cpFlags &= ~CP_DUCK
                } else if (cpFlags & CP_NEAREST) != 0 {
                    //don't need closest one to me
                    cpFlags &= ~CP_NEAREST
                } else if (cpFlags & CP_FLANK) != 0 {
                    //don't need to flank enemy
                    cpFlags &= ~CP_FLANK
                } else if (cpFlags & CP_SAFE) != 0 {
                    //don't need one that hasn't been shot at recently
                    cpFlags &= ~CP_SAFE
                } else if (cpFlags & CP_CLOSEST) != 0 {
                    //don't need to get closest to enemy
                    cpFlags &= ~CP_CLOSEST
                    //but let's try to approach at least
                    cpFlags |= CP_APPROACH_ENEMY
                } else if (cpFlags & CP_APPROACH_ENEMY) != 0 {
                    //don't need to approach enemy
                    cpFlags &= ~CP_APPROACH_ENEMY
                } else if (cpFlags & CP_COVER) != 0 {
                    //don't need cover
                    cpFlags &= ~CP_COVER
                    //but let's pick one that makes us duck
                    cpFlags |= CP_DUCK
                } else if (cpFlags & CP_CLEAR) != 0 {
                    //don't need a clear shot to enemy
                    cpFlags &= ~CP_CLEAR
                } else if (cpFlags & CP_AVOID_ENEMY) != 0 {
                    //don't need to avoid enemy
                    cpFlags &= ~CP_AVOID_ENEMY
                } else if (cpFlags & CP_RETREAT) != 0 {
                    //don't need to retreat
                    cpFlags &= ~CP_RETREAT
                } else if (cpFlags & CP_FLEE) != 0 {
                    //don't need to flee
                    cpFlags &= ~CP_FLEE
                    //but at least avoid enemy and pick one that gives cover
                    cpFlags |= (CP_COVER | CP_AVOID_ENEMY)
                } else if (cpFlags & CP_AVOID) != 0 {
                    //okay, even pick one right by me
                    cpFlags &= ~CP_AVOID
                } else {
                    cpFlags = CP_ANY
                }
                //now try again
                cp = NPC_FindCombatPoint(NPC!.r.currentOrigin, NPC!.r.currentOrigin, group!.enemy!.r.currentOrigin, cpFlags | CP_HAS_ROUTE, avoidDist, -1)
            }
            //see if we got a valid one
            if cp != -1 {
                //found a combat point
                //let others know that someone is now running
                runner = true
                //don't change course again until we get to where we're going
                TIMER_Set(NPC!, "roamTime", Q3_INFINITE)
                TIMER_Set(NPC!, "verifyCP", Q_irand(1000, 3000)) //don't make sure you're in your CP for 1 - 3 seconds
                NPC_SetCombatPoint(cp)
                NPC_SetMoveGoal(NPC!, level.combatPoints[cp].origin, 8, true, cp, nil)
                //okay, try a move right now to see if we can even get there

                //if ( ST_Move() )
                do {
                    //we actually can get to it, so okay to say you're going there.
                    //FIXME: Hmm... any way we can store this move info so we don't have to do it again
                    //		when our turn to think comes up?

                    //set us up so others know we're on the move
                    if squadState != SQUAD_IDLE {
                        AI_GroupUpdateSquadstates(group!, NPC!, squadState)
                    } else if (cpFlags & CP_FLEE) != 0 {
                        //outright running for your life
                        AI_GroupUpdateSquadstates(group!, NPC!, SQUAD_RETREAT)
                    } else {
                        //any other kind of transition between combat points
                        AI_GroupUpdateSquadstates(group!, NPC!, SQUAD_TRANSITION)
                    }

                    //unless we're trying to flee, walk slowly
                    if !((cpFlags_org & CP_FLEE) != 0) {
                        //ucmd.buttons |= BUTTON_CAREFUL;
                    }

                    /*
                    if ( scouting )
                    {//successfully chasing enemy
                    ST_Speech( NPC, SPEECH_CHASE, 0.0f );
                    //don't say this again
                    //group->speechDebounceTime = level.time + 5000;
                    }
                    //flanking:
                    else */
                    if (cpFlags & CP_FLANK) != 0 {
                        if group!.numGroup > 1 {
                            NPC_ST_StoreMovementSpeech(SPEECH_OUTFLANK, -1)
                        }
                    } else {
                        //okay, let's cheat
                        if group!.numGroup > 1 {
                            var dot: Float = 1.0
                            if Q_irand(0, 3) == 0 {
                                //25% of the time, see if we're flanking the enemy
                                var eDir2Me = vec3_t()
                                var eDir2CP = vec3_t()

                                eDir2Me = NPC!.r.currentOrigin - group!.enemy!.r.currentOrigin
                                VectorNormalize(&eDir2Me)

                                eDir2CP = level.combatPoints[NPCInfo!.combatPoint].origin - group!.enemy!.r.currentOrigin
                                VectorNormalize(&eDir2CP)

                                dot = _DotProduct(eDir2Me, eDir2CP)
                            }

                            if Double(dot) < 0.4 {
                                //flanking!
                                NPC_ST_StoreMovementSpeech(SPEECH_OUTFLANK, -1)
                            } else if Q_irand(0, 10) == 0 {
                                //regular movement
                                NPC_ST_StoreMovementSpeech(SPEECH_YELL, 0.2) //was SPEECH_COVER
                            }
                        }
                    }
                    /*
                    else if ( cpFlags & CP_CLOSEST || cpFlags & CP_APPROACH_ENEMY )
                    {
                    if ( group->numGroup > 1 )
                    {
                    NPC_ST_StoreMovementSpeech( SPEECH_CHASE, 0.4f );
                    }
                    }
                    */
                }
            } else if NPCInfo!.squadState == SQUAD_SCOUT {
                //we couldn't find a combatPoint by the player, so just go after him directly
                ST_HuntEnemy(NPC!)
                //set me into scout mode
                AI_GroupUpdateSquadstates(group!, NPC!, SQUAD_SCOUT)
                //AI should take care of rest
            }
        }
        i += 1
    }

    RestoreNPCGlobals()
    return
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:2409
func NPC_BSST_Attack() {
    var enemyDir = vec3_t()
    var shootDir = vec3_t()
    let dot: Float

    //Don't do anything if we're hurt
    if NPC!.painDebounceTime > level.time {
        NPC_UpdateAngles(true, true)
        return
    }

    //NPC_CheckEnemy( qtrue, qfalse );
    //If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false {
        NPC!.enemy = nil
        if NPC!.client!.playerTeam == NPCTEAM_PLAYER {
            NPC_BSPatrol()
        } else {
            NPC_BSST_Patrol() //FIXME: or patrol?
        }
        return
    }

    //FIXME: put some sort of delay into the guys depending on how they saw you...?

    //Get our group info
    if TIMER_Done(NPC!, "interrogating") {
        AI_GetGroup(NPC!) //, 45, 512, NPC->enemy );
    } else {
        //FIXME: when done interrogating, I should send out a team alert!
    }

    if NPCInfo!.group != nil {
        //I belong to a squad of guys - we should *always* have a group
        if !NPCInfo!.group!.processed {
            //I'm the first ent in my group, I'll make the command decisions
            ST_Commander()
        }
    } else if TIMER_Done(NPC!, "flee") && NPC_CheckForDanger(NPC_CheckAlertEvents(true, true, -1, false, AEL_DANGER)) {
        //not already fleeing, and going to run
        ST_Speech(NPC!, SPEECH_COVER, 0)
        NPC_UpdateAngles(true, true)
        return
    }

    if NPC!.enemy == nil {
        //WTF?  somehow we lost our enemy?
        NPC_BSST_Patrol() //FIXME: or patrol?
        return
    }

    enemyInFOV = false
    enemyCS = enemyInFOV
    enemyLOS = enemyCS
    move = true
    faceEnemy = false
    shoot = false
    hitAlly = false
    impactPos = vec3_t()
    enemyDist = DistanceSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)

    enemyDir = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
    VectorNormalize(&enemyDir)
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    // Raven passes NULL for the right and up outputs.
    AngleVectors(NPC!.client!.ps.viewangles, &shootDir, &scratchRight, &scratchUp)
    dot = _DotProduct(enemyDir, shootDir)
    if dot > 0.5 || (enemyDist * (1.0 - dot)) < 10000 {
        //enemy is in front of me or they're very close and not behind me
        enemyInFOV = true
    }

    if enemyDist < MIN_ROCKET_DIST_SQUARED {
        //enemy within 128
        if (NPC!.client!.ps.weapon == WP_FLECHETTE || NPC!.client!.ps.weapon == WP_REPEATER) && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
            //shooting an explosive, but enemy too close, switch to primary fire
            NPCInfo!.scriptFlags &= ~SCF_ALT_FIRE
            //FIXME: we can never go back to alt-fire this way since, after this, we don't know if we were initially supposed to use alt-fire or not...
        }
    } else if enemyDist > 65536 {
        if NPC!.client!.ps.weapon == WP_DISRUPTOR {
            //sniping... should be assumed
            if !((NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0) {
                //use primary fire
                NPCInfo!.scriptFlags |= SCF_ALT_FIRE
                //reset fire-timing variables
                NPC_ChangeWeapon(WP_DISRUPTOR)
                NPC_UpdateAngles(true, true)
                return
            }
        }
    }

    //can we see our target?
    if NPC_ClearLOS4(NPC!.enemy!) {
        AI_GroupUpdateEnemyLastSeen(NPCInfo!.group!, NPC!.enemy!.r.currentOrigin)
        NPCInfo!.enemyLastSeenTime = level.time
        enemyLOS = true

        if NPC!.client!.ps.weapon == WP_NONE {
            enemyCS = false //not true, but should stop us from firing
            NPC_AimAdjust(-1) //adjust aim worse longer we have no weapon
        } else {
            //can we shoot our target?
            if (NPC!.client!.ps.weapon == WP_ROCKET_LAUNCHER || (NPC!.client!.ps.weapon == WP_FLECHETTE && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0)) && enemyDist < MIN_ROCKET_DIST_SQUARED {
                enemyCS = false //not true, but should stop us from firing
                hitAlly = true //us!
                //FIXME: if too close, run away!
            } else if enemyInFOV {
                //if enemy is FOV, go ahead and check for shooting
                let hit: Int32 = NPC_ShotEntity(NPC!.enemy!, &impactPos)
                let hitEnt: Entity? = g_entities[hit]

                if hit == NPC!.enemy!.s.number || (hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.enemyTeam) || (hitEnt != nil && hitEnt!.takedamage && ((hitEnt!.r.svFlags & SVF_GLASS_BRUSH) != 0 || hitEnt!.health < 40 || NPC!.s.weapon == WP_EMPLACED_GUN)) {
                    //can hit enemy or enemy ally or will hit glass or other minor breakable (or in emplaced gun), so shoot anyway
                    AI_GroupUpdateClearShotTime(NPCInfo!.group!)
                    enemyCS = true
                    NPC_AimAdjust(2) //adjust aim better longer we have clear shot at enemy
                    NPCInfo!.enemyLastSeenLocation = NPC!.enemy!.r.currentOrigin
                } else {
                    //Hmm, have to get around this bastard
                    NPC_AimAdjust(1) //adjust aim better longer we can see enemy
                    ST_ResolveBlockedShot(hit)
                    if hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.playerTeam {
                        //would hit an ally, don't fire!!!
                        hitAlly = true
                    } else {
                        //Check and see where our shot *would* hit... if it's not close to the enemy (within 256?), then don't fire
                    }
                }
            } else {
                enemyCS = false //not true, but should stop us from firing
            }
        }
    } else if trap_InPVS(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin) {
        NPCInfo!.enemyLastSeenTime = level.time
        faceEnemy = true
        NPC_AimAdjust(-1) //adjust aim worse longer we cannot see enemy
    }

    if NPC!.client!.ps.weapon == WP_NONE {
        faceEnemy = false
        shoot = false
    } else {
        if enemyLOS {
            //FIXME: no need to face enemy if we're moving to some other goal and he's too far away to shoot?
            faceEnemy = true
        }
        if enemyCS {
            shoot = true
        }
    }

    //Check for movement to take care of
    ST_CheckMoveState()

    //See if we should override shooting decision with any special considerations
    ST_CheckFireState()

    if faceEnemy {
        //face the enemy
        NPC_FaceEnemy(true)
    }

    if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) {
        //not supposed to chase my enemies
        if NPCInfo!.goalEntity == NPC!.enemy {
            //goal is my entity, so don't move
            move = false
        }
    }

    if NPC!.client!.ps.weaponTime > 0 && NPC!.s.weapon == WP_ROCKET_LAUNCHER {
        move = false
    }

    if move {
        //move toward goal
        if NPCInfo!.goalEntity != nil {
            move = ST_Move()
        } else {
            move = false
        }
    }

    if !move {
        if !TIMER_Done(NPC!, "duck") {
            ucmd.upmove = -127
        }
        //FIXME: what about leaning?
    } else {
        //stop ducking!
        TIMER_Set(NPC!, "duck", -1)
    }

    if !TIMER_Done(NPC!, "flee") {
        //running away
        faceEnemy = false
    }

    //FIXME: check scf_face_move_dir here?

    if !faceEnemy {
        //we want to face in the dir we're running
        if !move {
            //if we haven't moved, we should look in the direction we last looked?
            NPCInfo!.lastPathAngles = NPC!.client!.ps.viewangles
        }
        NPCInfo!.desiredYaw = NPCInfo!.lastPathAngles[YAW]
        NPCInfo!.desiredPitch = 0
        NPC_UpdateAngles(true, true)
        if move {
            //don't run away and shoot
            shoot = false
        }
    }

    if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 {
        shoot = false
    }

    if NPC!.enemy != nil && NPC!.enemy!.enemy != nil {
        if NPC!.enemy!.s.weapon == WP_SABER && NPC!.enemy!.enemy!.s.weapon == WP_SABER {
            //don't shoot at an enemy jedi who is fighting another jedi, for fear of injuring one or causing rogue blaster deflections (a la Obi Wan/Vader duel at end of ANH)
            shoot = false
        }
    }
    //FIXME: don't shoot right away!
    if NPC!.client!.ps.weaponTime > 0 {
        if NPC!.s.weapon == WP_ROCKET_LAUNCHER {
            if !enemyLOS || !enemyCS {
                //cancel it
                NPC!.client!.ps.weaponTime = 0
            } else {
                //delay our next attempt
                TIMER_Set(NPC!, "attackDelay", Q_irand(3000, 5000))
            }
        }
    } else if shoot {
        //try to shoot if it's time
        if TIMER_Done(NPC!, "attackDelay") {
            if !((NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0) {
                WeaponThink(true)
            }
            //NASTY
            if NPC!.s.weapon == WP_ROCKET_LAUNCHER && (ucmd.buttons & BUTTON_ATTACK) != 0 && !move && g_spskill.integer > 1 && Q_irand(0, 3) == 0 {
                //every now and then, shoot a homing rocket
                ucmd.buttons &= ~BUTTON_ATTACK
                ucmd.buttons |= BUTTON_ALT_ATTACK
                NPC!.client!.ps.weaponTime = Q_irand(1000, 2500)
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Stormtrooper.c:2726
func NPC_BSST_Default() {
    if (NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0 {
        WeaponThink(true)
    }

    if NPC!.enemy == nil {
        //don't have an enemy, look for one
        NPC_BSST_Patrol()
    } else {
        //have an enemy
        NPC_CheckGetNewWeapon()
        NPC_BSST_Attack()
    }
}
