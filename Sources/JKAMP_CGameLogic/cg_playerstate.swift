import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_playerstate.c:304
var cgAnnouncerTime: Int32 {
    get { world.variables.cgAnnouncerTime }
    set { world.variables.cgAnnouncerTime = newValue }
}

/**
```
==============
CG_CheckAmmo

If the ammo has gone low enough to generate the warning, play a sound
==============
```
*/
/// Source: oracle/codemp/cgame/cg_playerstate.c:17
func CG_CheckAmmo() {
    // see about how many seconds of ammo we have remaining




    // play a sound on transitions
    //disabled silly ammo warning stuff for now
}

/**
```
==============
CG_DamageFeedback
==============
```
*/
/// Source: oracle/codemp/cgame/cg_playerstate.c:85
func CG_DamageFeedback(_ yawByte: Int32, _ pitchByte: Int32, _ damage: Int32) {
    let left: Float
    var front: Float
    let up: Float
    var kick: Float
    let health: Int32
    let scale: Float
    var dir = vec3_t()
    var angles = vec3_t()
    var dist: Float
    let yaw: Float
    let pitch: Float

    // show the attacking player's head and name in corner
    cg.attackerTime = cg.time

    // the lower on health you are, the greater the view kick will be
    health = cg.snap!.ps.stats[STAT_HEALTH]
    if health < 40 {
        scale = 1
    } else {
        scale = Float(40.0 / Double(health))
    }
    kick = damage * scale

    if kick < 5 {
        kick = 5
    }
    if kick > 10 {
        kick = 10
    }

    // if yaw and pitch are both 255, make the damage always centered (falling, etc)
    if yawByte == 255 && pitchByte == 255 {
        cg.damageX = 0
        cg.damageY = 0
        cg.v_dmg_roll = 0
        cg.v_dmg_pitch = -kick
    } else {
        // positional
        pitch = Float(Double(pitchByte) / 255.0 * 360)
        yaw = Float(Double(yawByte) / 255.0 * 360)

        angles[PITCH] = pitch
        angles[YAW] = yaw
        angles[ROLL] = 0

        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(angles, &dir, &scratchRight, &scratchUp)
        dir = vec3_origin - dir

        front = _DotProduct(dir, cg.refdef.viewaxis[0])
        left = _DotProduct(dir, cg.refdef.viewaxis[1])
        up = _DotProduct(dir, cg.refdef.viewaxis[2])

        dir[0] = front
        dir[1] = left
        dir[2] = 0
        dist = VectorLength(dir)
        if Double(dist) < 0.1 {
            dist = 0.1
        }

        cg.v_dmg_roll = kick * left

        cg.v_dmg_pitch = -kick * front

        if Double(front) <= 0.1 {
            front = 0.1
        }
        cg.damageX = -left / front
        cg.damageY = up / dist
    }

    // clamp the position
    if Double(cg.damageX) > 1.0 {
        cg.damageX = 1.0
    }
    if Double(cg.damageX) < -1.0 {
        cg.damageX = -1.0
    }

    if Double(cg.damageY) > 1.0 {
        cg.damageY = 1.0
    }
    if Double(cg.damageY) < -1.0 {
        cg.damageY = -1.0
    }

    // don't let the screen flashes vary as much
    if kick > 10 {
        kick = 10
    }
    cg.damageValue = kick
    cg.v_dmg_time = Float(cg.time + DAMAGE_TIME)
    cg.damageTime = Float(cg.snap!.serverTime)

    //JLFRUMBLE

    //FF_XboxShake(kick, 500);
}

/**
```
================
CG_Respawn

A respawn happened this snapshot
================
```
*/
/// Source: oracle/codemp/cgame/cg_playerstate.c:199
func CG_Respawn() {
    // no error decay on player movement
    cg.thisFrameTeleport = true

    // display weapons available
    cg.weaponSelectTime = cg.time

    // select the weapon the server says we are using
    cg.weaponSelect = cg.snap!.ps.weapon
}

/**
```
==============
CG_CheckPlayerstateEvents
==============
```
*/
/// Source: oracle/codemp/cgame/cg_playerstate.c:217
func CG_CheckPlayerstateEvents(_ ps: JKAMP.PlayerState, _ ops: JKAMP.PlayerState) {
    var i: Int32
    var event: Int32
    var cent: Centity?

    if ps.externalEvent != 0 && ps.externalEvent != ops.externalEvent {
        cent = cg_entities[ps.clientNum]
        cent!.currentState.event = ps.externalEvent
        cent!.currentState.eventParm = ps.externalEventParm
        CG_EntityEvent(cent!, cent!.lerpOrigin)
    }

    cent = cg_entities[ps.clientNum]
    // go through the predictable events buffer
    i = ps.eventSequence - MAX_PS_EVENTS
    while i < ps.eventSequence {
        // if we have a new predictable event
        if i >= ops.eventSequence || (i > ops.eventSequence - MAX_PS_EVENTS && ps.events[i & (MAX_PS_EVENTS - 1)] != ops.events[i & (MAX_PS_EVENTS - 1)]) {
            event = ps.events[i & (MAX_PS_EVENTS - 1)]
            cent!.currentState.event = event
            cent!.currentState.eventParm = ps.eventParms[i & (MAX_PS_EVENTS - 1)]
            //JLF ADDED to hopefully mark events as player event
            cent!.playerState = ps
            CG_EntityEvent(cent!, cent!.lerpOrigin)

            cg.predictableEvents[i & (MAX_PREDICTED_EVENTS - 1)] = event

            cg.eventSequence += 1
        }
        i += 1
    }
}

/**
```
==================
CG_CheckChangedPredictableEvents
==================
```
*/
/// Source: oracle/codemp/cgame/cg_playerstate.c:257
func CG_CheckChangedPredictableEvents(_ ps: JKAMP.PlayerState) {
    var i: Int32
    var event: Int32
    var cent: Centity?

    cent = cg_entities[ps.clientNum]
    i = ps.eventSequence - MAX_PS_EVENTS
    while i < ps.eventSequence {
        //
        if i >= cg.eventSequence {
            i += 1
            continue
        }
        // if this event is not further back in than the maximum predictable events we remember
        if i > cg.eventSequence - MAX_PREDICTED_EVENTS {
            // if the new playerstate event is different from a previously predicted one
            if ps.events[i & (MAX_PS_EVENTS - 1)] != cg.predictableEvents[i & (MAX_PREDICTED_EVENTS - 1)] {
                event = ps.events[i & (MAX_PS_EVENTS - 1)]
                cent!.currentState.event = event
                cent!.currentState.eventParm = ps.eventParms[i & (MAX_PS_EVENTS - 1)]
                CG_EntityEvent(cent!, cent!.lerpOrigin)

                cg.predictableEvents[i & (MAX_PREDICTED_EVENTS - 1)] = event

                if cg_showmiss.integer != 0 {
                    CG_Printf("WARNING: changed predicted event\n")
                }
            }
        }
        i += 1
    }
}

/**
```
==================
CG_CheckLocalSounds
==================
```
*/
/// Source: oracle/codemp/cgame/cg_playerstate.c:311
func CG_CheckLocalSounds(_ ps: JKAMP.PlayerState, _ ops: JKAMP.PlayerState) {
    let highScore: Int32
    let health: Int32
    let armor: Int32
    let reward: Int32

    // don't play the sounds if the player just changed teams
    if ps.persistant[PERS_TEAM] != ops.persistant[PERS_TEAM] {
        return
    }

    // hit changes
    if ps.persistant[PERS_HITS] > ops.persistant[PERS_HITS] {
        armor = ps.persistant[PERS_ATTACKEE_ARMOR] & 0xff
        health = ps.persistant[PERS_ATTACKEE_ARMOR] >> 8

        if armor > health / 2 {
            // We also hit shields along the way, so consider them "pierced".
            //			trap_S_StartLocalSound( cgs.media.shieldPierceSound, CHAN_LOCAL_SOUND );
        } else {
            // Shields didn't really stand in our way.
            //			trap_S_StartLocalSound( cgs.media.hitSound, CHAN_LOCAL_SOUND );
        }

        //FIXME: Hit sounds?
        /*
        if (armor > 50 ) {
        trap_S_StartLocalSound( cgs.media.hitSoundHighArmor, CHAN_LOCAL_SOUND );
        } else if (armor || health > 100) {
        trap_S_StartLocalSound( cgs.media.hitSoundLowArmor, CHAN_LOCAL_SOUND );
        } else {
        trap_S_StartLocalSound( cgs.media.hitSound, CHAN_LOCAL_SOUND );
        }
        */
    } else if ps.persistant[PERS_HITS] < ops.persistant[PERS_HITS] {
        //trap_S_StartLocalSound( cgs.media.hitTeamSound, CHAN_LOCAL_SOUND );
    }

    // health changes of more than -3 should make pain sounds
    if cg_oldPainSounds.integer != 0 {
        if ps.stats[STAT_HEALTH] < (ops.stats[STAT_HEALTH] - 3) {
            if ps.stats[STAT_HEALTH] > 0 {
                CG_PainEvent(cg_entities[cg.predictedPlayerState.clientNum], ps.stats[STAT_HEALTH])
            }
        }
    }

    // if we are going into the intermission, don't start any voices
    if cg.intermissionStarted {
        return
    }

    // reward sounds
    //Com_Printf("capture\n");

    //Com_Printf("impressive\n");
    //Com_Printf("excellent\n");
    //Com_Printf("guantlet frag\n");
    //Com_Printf("defend\n");
    //pushReward(cgs.media.assistSound, cgs.media.medalAssist, ps->persistant[PERS_ASSIST_COUNT]);
    //reward = qtrue;
    //Com_Printf("assist\n");
    // if any of the player event bits changed
    reward = 0
    // lead changes
    if reward == 0 && cgAnnouncerTime < cg.time {
        //
        if cg.warmup == 0 && cgs.gametype != GT_POWERDUEL {
            // never play lead changes during warmup and powerduel
            if ps.persistant[PERS_RANK] != ops.persistant[PERS_RANK] {
                if cgs.gametype < GT_TEAM {
                    /*
                    if (  ps->persistant[PERS_RANK] == 0 ) {
                    CG_AddBufferedSound(cgs.media.takenLeadSound);
                    cgAnnouncerTime = cg.time + 3000;
                    } else if ( ps->persistant[PERS_RANK] == RANK_TIED_FLAG ) {
                    //CG_AddBufferedSound(cgs.media.tiedLeadSound);
                    } else if ( ( ops->persistant[PERS_RANK] & ~RANK_TIED_FLAG ) == 0 ) {
                    //rww - only bother saying this if you have more than 1 kill already.
                    //joining the server and hearing "the force is not with you" is silly.
                    if (ps->persistant[PERS_SCORE] > 0)
                    {
                    CG_AddBufferedSound(cgs.media.lostLeadSound);
                    cgAnnouncerTime = cg.time + 3000;
                    }
                    }
                    */
                }
            }
        }
    }

    // timelimit warnings
    if cgs.timelimit > 0 && cgAnnouncerTime < cg.time {
        let msec: Int32

        msec = cg.time - cgs.levelStartTime
        if !((cg.timelimitWarnings & 4) != 0) && msec > (cgs.timelimit * 60 + 2) * 1000 {
            cg.timelimitWarnings |= 1 | 2 | 4
            //trap_S_StartLocalSound( cgs.media.suddenDeathSound, CHAN_ANNOUNCER );
        } else if !((cg.timelimitWarnings & 2) != 0) && msec > (cgs.timelimit - 1) * 60 * 1000 {
            cg.timelimitWarnings |= 1 | 2
            trap_S_StartLocalSound(cgs.media.oneMinuteSound, CHAN_ANNOUNCER)
            cgAnnouncerTime = cg.time + 3000
        } else if cgs.timelimit > 5 && !((cg.timelimitWarnings & 1) != 0) && msec > (cgs.timelimit - 5) * 60 * 1000 {
            cg.timelimitWarnings |= 1
            trap_S_StartLocalSound(cgs.media.fiveMinuteSound, CHAN_ANNOUNCER)
            cgAnnouncerTime = cg.time + 3000
        }
    }

    // fraglimit warnings
    if cgs.fraglimit > 0 && cgs.gametype < GT_CTF && cgs.gametype != GT_DUEL && cgs.gametype != GT_POWERDUEL && cgs.gametype != GT_SIEGE && cgAnnouncerTime < cg.time {
        highScore = cgs.scores1
        if !((cg.fraglimitWarnings & 4) != 0) && highScore == (cgs.fraglimit - 1) {
            cg.fraglimitWarnings |= 1 | 2 | 4
            CG_AddBufferedSound(cgs.media.oneFragSound)
            cgAnnouncerTime = cg.time + 3000
        } else if cgs.fraglimit > 2 && !((cg.fraglimitWarnings & 2) != 0) && highScore == (cgs.fraglimit - 2) {
            cg.fraglimitWarnings |= 1 | 2
            CG_AddBufferedSound(cgs.media.twoFragSound)
            cgAnnouncerTime = cg.time + 3000
        } else if cgs.fraglimit > 3 && !((cg.fraglimitWarnings & 1) != 0) && highScore == (cgs.fraglimit - 3) {
            cg.fraglimitWarnings |= 1
            CG_AddBufferedSound(cgs.media.threeFragSound)
            cgAnnouncerTime = cg.time + 3000
        }
    }
}

/**
```
===============
CG_TransitionPlayerState

===============
```
*/
/// Source: oracle/codemp/cgame/cg_playerstate.c:495
func CG_TransitionPlayerState(_ ps: JKAMP.PlayerState, _ ops: JKAMP.PlayerState) {
    // check for changing follow mode
    if ps.clientNum != ops.clientNum {
        cg.thisFrameTeleport = true
        // make sure we don't get any unwanted transition effects
        ops.copy(from: ps)
    }

    // damage events (player is getting wounded)
    if ps.damageEvent != ops.damageEvent && ps.damageCount != 0 {
        CG_DamageFeedback(ps.damageYaw, ps.damagePitch, ps.damageCount)
    }

    // respawning
    if ps.persistant[PERS_SPAWN_COUNT] != ops.persistant[PERS_SPAWN_COUNT] {
        CG_Respawn()
    }

    if cg.mapRestart {
        CG_Respawn()
        cg.mapRestart = false
    }

    if cg.snap!.ps.pm_type != PM_INTERMISSION && ps.persistant[PERS_TEAM] != TEAM_SPECTATOR {
        CG_CheckLocalSounds(ps, ops)
    }

    // check for going low on ammo
    CG_CheckAmmo()

    // run events
    CG_CheckPlayerstateEvents(ps, ops)

    // smooth the ducking viewheight change
    if ps.viewheight != ops.viewheight {
        cg.duckChange = Float(ps.viewheight - ops.viewheight)
        cg.duckTime = cg.time
    }
}
