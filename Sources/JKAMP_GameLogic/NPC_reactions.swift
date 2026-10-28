import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_reactions.c:204
let MIN_PAIN_TIME = 200 as Int32

/// Source: oracle/codemp/game/NPC_reactions.c:42
private func NPC_CheckAttacker(_ other: Entity, _ mod: Int32) {
    //FIXME: I don't see anything in here that would stop teammates from taking a teammate
    //			as an enemy.  Ideally, there would be code before this to prevent that from
    //			happening, but that is presumptuous.

    //valid ent - FIXME: a VALIDENT macro would be nice here

    if other == NPC {
        return
    }

    if !other.inuse {
        return
    }

    //Don't take a target that doesn't want to be
    if (other.flags & FL_NOTARGET) != 0 {
        return
    }

    //	if ( NPC->svFlags & SVF_LOCKEDENEMY )
    //	{//IF LOCKED, CANNOT CHANGE ENEMY!!!!!
    //		return;
    //	}
    //rwwFIXMEFIXME: support this

    //If we haven't taken a target, just get mad
    if NPC!.enemy == nil {
        G_SetEnemy(NPC!, other)
        return
    }

    //we have an enemy, see if he's dead
    if NPC!.enemy!.health <= 0 {
        G_ClearEnemy(NPC!)
        G_SetEnemy(NPC!, other)
        return
    }

    //Don't take the same enemy again
    if other == NPC!.enemy {
        return
    }

    if NPC!.client!.ps.weapon == WP_SABER {
        //I'm a jedi
        if mod == MOD_SABER {
            //I was hit by a saber  FIXME: what if this was a thrown saber?
            //always switch to this enemy if I'm a jedi and hit by another saber
            G_ClearEnemy(NPC!)
            G_SetEnemy(NPC!, other)
            return
        }
    }
    //Special case player interactions
    if other == g_entities[0] {
        //Account for the skill level to skew the results
        var luckThreshold: Float

        switch g_spskill.integer {
        //Easiest difficulty, mild chance of picking up the player
        case 0:
            luckThreshold = 0.9
            //Medium difficulty, half-half chance of picking up the player

        case 1:
            luckThreshold = 0.5
            //Hardest difficulty, always turn on attacking player

        default:
            luckThreshold = 0.0
        }

        //Randomly pick up the target
        // The SDK also declares `random`, so the call names the bg module.
        if JKAMP_BG.random() > luckThreshold {
            G_ClearEnemy(other)
            other.enemy = NPC
        }

        return
    }
}

/// Source: oracle/codemp/game/NPC_reactions.c:133
func NPC_SetPainEvent(_ `self`: Entity) {
    if `self`.NPC == nil || !((`self`.NPC!.aiFlags & NPCAI_DIE_ON_IMPACT) != 0) {
        // no more borg
        //	if( self->client->playerTeam != TEAM_BORG )
        //	{
        //if ( !Q3_TaskIDPending( self, TID_CHAN_VOICE ) )
        if !trap_ICARUS_TaskIDPending(`self`, TID_CHAN_VOICE) && `self`.client != nil {
            //G_AddEvent( self, EV_PAIN, floor((float)self->health/self->max_health*100.0f) );
            G_AddEvent(`self`, EV_PAIN, Int32(floor(Float(`self`.health) / `self`.client!.ps.stats[STAT_MAX_HEALTH] * 100.0)))
            //rwwFIXMEFIXME: Do this properly?
        }
        //	}
    }
}

/// Source: oracle/codemp/game/NPC_reactions.c:157
func NPC_GetPainChance(_ `self`: Entity, _ damage: Int32) -> Float {
    var pain_chance: Float
    if `self`.enemy == nil {
        //surprised, always take pain
        return 1.0
    }

    if `self`.client == nil {
        return 1.0
    }

    //if ( damage > self->max_health/2.0f )
    if damage > `self`.client!.ps.stats[STAT_MAX_HEALTH] / 2.0 {
        return 1.0
    }

    pain_chance = Float((`self`.client!.ps.stats[STAT_MAX_HEALTH] - `self`.health)) / (`self`.client!.ps.stats[STAT_MAX_HEALTH] * 2.0) + Float(damage) / (`self`.client!.ps.stats[STAT_MAX_HEALTH] / 2.0)
    switch g_spskill.integer {
    case 0: //easy
        //return 0.75f;
        break

    case 1: //med
        pain_chance *= 0.5

    default: //hard
        pain_chance *= 0.1
    }
    //Com_Printf( "%s: %4.2f\n", self->NPC_type, pain_chance );
    return pain_chance
}

/// Source: oracle/codemp/game/NPC_reactions.c:207
func NPC_ChoosePainAnimation(_ `self`: Entity, _ other: Entity, _ point: JKAShared.vec3_t, _ damage: Int32, _ mod: Int32, _ hitLoc: Int32, _ voiceEvent: Int32) {
    var pain_anim: Int32 = -1
    var pain_chance: Float

    //If we've already taken pain, then don't take it again
    if level.time < `self`.painDebounceTime && mod != MOD_MELEE {
        //FIXME: if hit while recoving from losing a saber lock, we should still play a pain anim?
        return
    }

    if `self`.s.weapon == WP_THERMAL && `self`.client!.ps.weaponTime > 0 {
        //don't interrupt thermal throwing anim
        return
    } else if `self`.client!.NPC_class == CLASS_GALAKMECH {
        if hitLoc == HL_GENERIC1 {
            //hit the antenna!
            pain_chance = 1.0
            //	self->s.powerups |= ( 1 << PW_SHOCKED );
            //	self->client->ps.powerups[PW_SHOCKED] = level.time + Q_irand( 500, 2500 );
            //rwwFIXMEFIXME: support for this
        } else if `self`.health > 200 && damage < 100 {
            //	else if ( self->client->ps.powerups[PW_GALAK_SHIELD] )
            //	{//shield up
            //		return;
            //	}
            //rwwFIXMEFIXME: and this
            //have a *lot* of health
            pain_chance = 0.05
        } else {
            //the lower my health and greater the damage, the more likely I am to play a pain anim
            pain_chance = (200.0 - `self`.health) / 100.0 + damage / 50.0
        }
    } else if `self`.client != nil && `self`.client!.playerTeam == NPCTEAM_PLAYER && other.s.number == 0 {
        //ally shot by player always complains
        pain_chance = 1.1
    } else {
        if other.s.weapon == WP_SABER || mod == MOD_CRUSH {
            pain_chance = 1.0 //always take pain from saber
        } else if mod == MOD_MELEE {
            //higher in rank (skill) we are, less likely we are to be fazed by a punch
            pain_chance = 1.0 - ((RANK_CAPTAIN - `self`.NPC!.rank) / Float(UInt32(bitPattern: RANK_CAPTAIN)))
        } else if `self`.client!.NPC_class == CLASS_PROTOCOL {
            pain_chance = 1.0
        } else {
            pain_chance = NPC_GetPainChance(`self`, damage)
        }
        if `self`.client!.NPC_class == CLASS_DESANN {
            pain_chance *= 0.5
        }
    }

    //See if we're going to flinch
    // The SDK also declares `random`, so the call names the bg module.
    if JKAMP_BG.random() < pain_chance {
        let animLength: Int32

        //Pick and play our animation
        if `self`.client!.ps.fd.forceGripBeingGripped < level.time {
            //not being force-gripped or force-drained
            if PM_SpinningAnim(`self`.client!.ps.legsAnim) || BG_SaberInSpecialAttack(`self`.client!.ps.torsoAnim) || PM_InKnockDown(`self`.client!.ps) || PM_RollingAnim(`self`.client!.ps.legsAnim) || (BG_FlippingAnim(`self`.client!.ps.legsAnim) && !PM_InCartwheel(`self`.client!.ps.legsAnim)) {
                //strong attacks, rolls, knockdowns, flips and spins cannot be interrupted by pain
            } else {
                //play an anim
                var parts: Int32

                if `self`.client!.NPC_class == CLASS_GALAKMECH {
                    //only has 1 for now
                    //FIXME: never plays this, it seems...
                    pain_anim = BOTH_PAIN1
                } else if mod == MOD_MELEE {
                    pain_anim = BG_PickAnim(`self`.localAnimIndex, BOTH_PAIN2, BOTH_PAIN3)
                } else if `self`.s.weapon == WP_SABER {
                    //temp HACK: these are the only 2 pain anims that look good when holding a saber
                    pain_anim = BG_PickAnim(`self`.localAnimIndex, BOTH_PAIN2, BOTH_PAIN3)
                }
                /*
                else if ( mod != MOD_ELECTROCUTE )
                {
                pain_anim = G_PickPainAnim( self, point, damage, hitLoc );
                }
                */

                if pain_anim == -1 {
                    pain_anim = BG_PickAnim(`self`.localAnimIndex, BOTH_PAIN1, BOTH_PAIN18)
                }
                `self`.client!.ps.fd.saberAnimLevel = FORCE_LEVEL_1 //next attack must be a quick attack
                `self`.client!.ps.saberMove = LS_READY //don't finish whatever saber move you may have been in
                parts = SETANIM_BOTH
                if BG_CrouchAnim(`self`.client!.ps.legsAnim) || PM_InCartwheel(`self`.client!.ps.legsAnim) {
                    parts = SETANIM_LEGS
                }

                if pain_anim != -1 {
                    NPC_SetAnim(`self`, parts, pain_anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                }
            }
            if voiceEvent != -1 {
                G_AddVoiceEvent(`self`, voiceEvent, Q_irand(2000, 4000))
            } else {
                NPC_SetPainEvent(`self`)
            }
        } else {
            G_AddVoiceEvent(`self`, Q_irand(EV_CHOKE1, EV_CHOKE3), 0)
        }

        //Setup the timing for it
        /*
        if ( mod == MOD_ELECTROCUTE )
        {
        self->painDebounceTime = level.time + 4000;
        }
        */
        animLength = Int32(bgAllAnims[`self`.localAnimIndex].animsSlots[pain_anim].numFrames * abs(Float((bgHumanoidAnimations[pain_anim].frameLerp))))

        `self`.painDebounceTime = level.time + animLength
        `self`.client!.ps.weaponTime = 0
    }
}

/**
```
===============
NPC_Pain
===============
```
*/
/// Source: oracle/codemp/game/NPC_reactions.c:363
func NPC_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    var otherTeam: team_t = TEAM_FREE
    var voiceEvent: Int32 = -1
    let other: Entity? = attacker
    let mod: Int32 = gPainMOD
    let hitLoc: Int32 = gPainHitLoc
    var point = vec3_t()

    point = gPainPoint

    if `self`.NPC == nil {
        return
    }

    if other == nil {
        return
    }

    //or just remove ->pain in player_die?
    if `self`.client!.ps.pm_type == PM_DEAD {
        return
    }

    if other == `self` {
        return
    }

    //MCG: Ignore damage from your own team for now
    if other!.client != nil {
        otherTeam = other!.client!.playerTeam
        //	if ( otherTeam == TEAM_DISGUISE )
        //	{
        //		otherTeam = TEAM_PLAYER;
        //	}
    }

    if `self`.client!.playerTeam != 0 && other!.client != nil && otherTeam == `self`.client!.playerTeam {
        //hit by a teammate
        if other != `self`.enemy && `self` != other!.enemy {
            //we weren't already enemies
            if `self`.enemy != nil || other!.enemy != nil {
                //if one of us actually has an enemy already, it's okay, just an accident OR wasn't hit by player or someone controlled by player OR player hit ally and didn't get 25% chance of getting mad (FIXME:accumulate anger+base on diff?)
                //FIXME: player should have to do a certain amount of damage to ally or hit them several times to make them mad
                //Still run pain and flee scripts
                if `self`.client != nil && `self`.NPC != nil {
                    //Run any pain instructions
                    if `self`.health <= (`self`.client!.ps.stats[STAT_MAX_HEALTH] / 3) && G_ActivateBehavior(`self`, BSET_FLEE) {
                    } else {
                        G_ActivateBehavior(`self`, BSET_PAIN)
                    }
                }
                if damage != -1 {
                    //-1 == don't play pain anim
                    //Set our proper pain animation
                    if Q_irand(0, 1) != 0 {
                        NPC_ChoosePainAnimation(`self`, other!, point, damage, mod, hitLoc, EV_FFWARN)
                    } else {
                        NPC_ChoosePainAnimation(`self`, other!, point, damage, mod, hitLoc, -1)
                    }
                }
                return
            } else if `self`.NPC != nil && other!.s.number == 0 {
                //dammit, stop that!
                if `self`.NPC!.charmedTime != 0 {
                    //mindtricked
                    return
                } else if `self`.NPC!.ffireCount < 3 + ((2 - g_spskill.integer) * 2) {
                    //not mad enough yet
                    //Com_Printf( "chck: %d < %d\n", self->NPC->ffireCount, 3+((2-g_spskill.integer)*2) );
                    if damage != -1 {
                        //-1 == don't play pain anim
                        //Set our proper pain animation
                        if Q_irand(0, 1) != 0 {
                            NPC_ChoosePainAnimation(`self`, other!, point, damage, mod, hitLoc, EV_FFWARN)
                        } else {
                            NPC_ChoosePainAnimation(`self`, other!, point, damage, mod, hitLoc, -1)
                        }
                    }
                    return
                } else if G_ActivateBehavior(`self`, BSET_FFIRE) {
                    //we have a specific script to run, so do that instead
                    return
                } else {
                    //okay, we're going to turn on our ally, we need to set and lock our enemy and put ourselves in a bstate that lets us attack him (and clear any flags that would stop us)
                    `self`.NPC!.blockedSpeechDebounceTime = 0
                    voiceEvent = EV_FFTURN
                    `self`.NPC!.defaultBehavior = BS_DEFAULT
                    `self`.NPC!.tempBehavior = `self`.NPC!.defaultBehavior
                    `self`.NPC!.behaviorState = `self`.NPC!.tempBehavior
                    other!.flags &= ~FL_NOTARGET
                    //self->svFlags &= ~(SVF_IGNORE_ENEMIES|SVF_ICARUS_FREEZE|SVF_NO_COMBAT_SOUNDS);
                    `self`.r.svFlags &= ~SVF_ICARUS_FREEZE
                    G_SetEnemy(`self`, other!)
                    //self->svFlags |= SVF_LOCKEDENEMY; //rwwFIXMEFIXME: proper support for these flags.
                    `self`.NPC!.scriptFlags &= ~(SCF_DONT_FIRE | SCF_CROUCHED | SCF_WALKING | SCF_NO_COMBAT_TALK | SCF_FORCED_MARCH)
                    `self`.NPC!.scriptFlags |= (SCF_CHASE_ENEMIES | SCF_NO_MIND_TRICK)
                    //NOTE: we also stop ICARUS altogether
                    //stop_icarus = qtrue;
                    //rwwFIXMEFIXME: stop icarus?
                    if killPlayerTimer == 0 {
                        killPlayerTimer = level.time + 10000
                    }
                }
            }
        }
    }

    SaveNPCGlobals()
    SetNPCGlobals(`self`)

    //Do extra bits
    if NPCInfo!.ignorePain == false {
        NPCInfo!.confusionTime = 0 //clear any charm or confusion, regardless
        if damage != -1 {
            //-1 == don't play pain anim
            //Set our proper pain animation
            NPC_ChoosePainAnimation(`self`, other!, point, damage, mod, hitLoc, voiceEvent)
        }
        //Check to take a new enemy
        if NPC!.enemy != other && NPC != other {
            //not already mad at them
            NPC_CheckAttacker(other!, mod)
        }
    }

    //Attempt to run any pain instructions
    if `self`.client != nil && `self`.NPC != nil {
        //FIXME: This needs better heuristics perhaps
        if `self`.health <= (`self`.client!.ps.stats[STAT_MAX_HEALTH] / 3) && G_ActivateBehavior(`self`, BSET_FLEE) {
        } else {
            G_ActivateBehavior(`self`, BSET_PAIN)
        }
    }

    //Attempt to fire any paintargets we might have
    if `self`.paintarget != nil && !`self`.paintarget!.isEmpty {
        G_UseTargets2(`self`, other, `self`.paintarget)
    }

    RestoreNPCGlobals()
}

/// Source: oracle/codemp/game/NPC_reactions.c:537
func NPC_Touch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if `self`.NPC == nil {
        return
    }

    SaveNPCGlobals()
    SetNPCGlobals(`self`)

    if `self`.message != nil && `self`.health <= 0 {
        //I am dead and carrying a key
        //if ( other && player && player->health > 0 && other == player )
        if other.client != nil && other.s.number < MAX_CLIENTS {
            //player touched me
            /*
            char *text;
            qboolean	keyTaken;
            //give him my key
            if ( Q_stricmp( "goodie", self->message ) == 0 )
            {//a goodie key
            if ( (keyTaken = INV_GoodieKeyGive( other )) == qtrue )
            {
            text = "cp @SP_INGAME_TOOK_IMPERIAL_GOODIE_KEY";
            G_AddEvent( other, EV_ITEM_PICKUP, (FindItemForInventory( INV_GOODIE_KEY )-bg_itemlist) );
            }
            else
            {
            text = "cp @SP_INGAME_CANT_CARRY_GOODIE_KEY";
            }
            }
            else
            {//a named security key
            if ( (keyTaken = INV_SecurityKeyGive( player, self->message )) == qtrue )
            {
            text = "cp @SP_INGAME_TOOK_IMPERIAL_SECURITY_KEY";
            G_AddEvent( other, EV_ITEM_PICKUP, (FindItemForInventory( INV_SECURITY_KEY )-bg_itemlist) );
            }
            else
            {
            text = "cp @SP_INGAME_CANT_CARRY_SECURITY_KEY";
            }
            }
            */
            //rwwFIXMEFIXME: support for goodie/security keys?
            /*
            if ( keyTaken )
            {//remove my key
            NPC_SetSurfaceOnOff( self, "l_arm_key", 0x00000002 );
            self->message = NULL;
            //FIXME: temp pickup sound
            G_Sound( player, G_SoundIndex( "sound/weapons/key_pkup.wav" ) );
            //FIXME: need some event to pass to cgame for sound/graphic/message?
            }
            //FIXME: temp message
            gi.SendServerCommand( NULL, text );
            */
        }
    }

    if other.client != nil {
        //FIXME:  if pushing against another bot, both ucmd.rightmove = 127???
        //Except if not facing one another...
        if other.health > 0 {
            NPCInfo!.touchedByPlayer = other
        }

        if other == NPCInfo!.goalEntity {
            NPCInfo!.aiFlags |= NPCAI_TOUCHED_GOAL
        }

        if !((other.flags & FL_NOTARGET) != 0) {
            if `self`.client!.enemyTeam != 0 {
                //See if we bumped into an enemy
                if other.client!.playerTeam == `self`.client!.enemyTeam {
                    //bumped into an enemy
                    if NPCInfo!.behaviorState != BS_HUNT_AND_KILL && NPCInfo!.tempBehavior == 0 {
                        //MCG - Begin: checking specific BS mode here, this is bad, a HACK
                        //FIXME: not medics?
                        if NPC!.enemy != other {
                            //not already mad at them
                            G_SetEnemy(NPC!, other)
                        }
                        //				NPCInfo->tempBehavior = BS_HUNT_AND_KILL;
                    }
                }
            }
        }

        //FIXME: do this if player is moving toward me and with a certain dist?
        /*
        if ( other->s.number == 0 && self->client->playerTeam == other->client->playerTeam )
        {
        VectorAdd( self->client->pushVec, other->client->ps.velocity, self->client->pushVec );
        }
        */
    } else {
        //FIXME: check for SVF_NONNPC_ENEMY flag here?
        if other.health > 0 {
            //if ( NPC->enemy == other && (other->svFlags&SVF_NONNPC_ENEMY) )
            if 0 != 0 {
                NPCInfo!.touchedByPlayer = other
            }
        }

        if other == NPCInfo!.goalEntity {
            NPCInfo!.aiFlags |= NPCAI_TOUCHED_GOAL
        }
    }

    RestoreNPCGlobals()
}

/// Source: oracle/codemp/game/NPC_reactions.c:661
func NPC_TempLookTarget(_ `self`: Entity, _ lookEntNum: Int32, _ minLookTime: Int32, _ maxLookTime: Int32) {
    // Raven assigns his own `minLookTime` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var minLookTime = minLookTime
    // Raven assigns his own `maxLookTime` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var maxLookTime = maxLookTime
    if `self`.client == nil {
        return
    }

    if (`self`.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
        //lookTarget is set by and to the monster that's holding you, no other operations can change that
        return
    }

    if minLookTime == 0 {
        minLookTime = 1000
    }

    if maxLookTime == 0 {
        maxLookTime = 1000
    }

    if !NPC_CheckLookTarget(`self`) {
        //Not already looking at something else
        //Look at him for 1 to 3 seconds
        NPC_SetLookTarget(`self`, lookEntNum, level.time + Q_irand(minLookTime, maxLookTime))
    }
}

/// Source: oracle/codemp/game/NPC_reactions.c:690
func NPC_Respond(_ `self`: Entity, _ userNum: Int32) {
    var event: Int32 = -1
    /*

    if ( Q_irand( 0, 1 ) )
    {
    event = Q_irand(EV_RESPOND1, EV_RESPOND3);
    }
    else
    {
    event = Q_irand(EV_BUSY1, EV_BUSY3);
    }
    */

    if Q_irand(0, 1) == 0 {
        //set looktarget to them for a second or two
        NPC_TempLookTarget(`self`, userNum, 1000, 3000)
    }

    //some last-minute hacked in responses
    switch `self`.client!.NPC_class {
    case CLASS_JAN:
        if `self`.enemy != nil {
            if Q_irand(0, 2) == 0 {
                event = Q_irand(EV_CHASE1, EV_CHASE3)
            } else if Q_irand(0, 1) != 0 {
                event = Q_irand(EV_OUTFLANK1, EV_OUTFLANK2)
            } else {
                event = Q_irand(EV_COVER1, EV_COVER5)
            }
        } else if Q_irand(0, 2) == 0 {
            event = EV_SUSPICIOUS4
        } else if Q_irand(0, 1) == 0 {
            event = EV_SOUND1
        } else {
            event = EV_CONFUSE1
        }

    case CLASS_LANDO:
        if `self`.enemy != nil {
            if Q_irand(0, 2) == 0 {
                event = Q_irand(EV_CHASE1, EV_CHASE3)
            } else if Q_irand(0, 1) != 0 {
                event = Q_irand(EV_OUTFLANK1, EV_OUTFLANK2)
            } else {
                event = Q_irand(EV_COVER1, EV_COVER5)
            }
        } else if Q_irand(0, 6) == 0 {
            event = EV_SIGHT2
        } else if Q_irand(0, 5) == 0 {
            event = EV_GIVEUP4
        } else if Q_irand(0, 4) > 1 {
            event = Q_irand(EV_SOUND1, EV_SOUND3)
        } else {
            event = Q_irand(EV_JDETECTED1, EV_JDETECTED2)
        }

    case CLASS_LUKE:
        if `self`.enemy != nil {
            event = EV_COVER1
        } else {
            event = Q_irand(EV_SOUND1, EV_SOUND3)
        }

    case CLASS_JEDI:
        if `self`.enemy == nil {
            /*
            if ( !(self->svFlags&SVF_IGNORE_ENEMIES)
            && (self->NPC->scriptFlags&SCF_LOOK_FOR_ENEMIES)
            && self->client->enemyTeam == TEAM_ENEMY )
            */
            if 0 != 0 {
                event = Q_irand(EV_ANGER1, EV_ANGER3)
            } else {
                event = Q_irand(EV_TAUNT1, EV_TAUNT2)
            }
        }

    case CLASS_PRISONER:
        if `self`.enemy != nil {
            if Q_irand(0, 1) != 0 {
                event = Q_irand(EV_CHASE1, EV_CHASE3)
            } else {
                event = Q_irand(EV_OUTFLANK1, EV_OUTFLANK2)
            }
        } else {
            event = Q_irand(EV_SOUND1, EV_SOUND3)
        }

    case CLASS_REBEL:
        if `self`.enemy != nil {
            if Q_irand(0, 2) == 0 {
                event = Q_irand(EV_CHASE1, EV_CHASE3)
            } else {
                event = Q_irand(EV_DETECTED1, EV_DETECTED5)
            }
        } else {
            event = Q_irand(EV_SOUND1, EV_SOUND3)
        }

    case CLASS_BESPIN_COP:
        if Q_stricmp("bespincop", `self`.NPC_type!) == 0 {
            //variant 1
            if `self`.enemy != nil {
                if Q_irand(0, 9) > 6 {
                    event = Q_irand(EV_CHASE1, EV_CHASE3)
                } else if Q_irand(0, 6) > 4 {
                    event = Q_irand(EV_OUTFLANK1, EV_OUTFLANK2)
                } else {
                    event = Q_irand(EV_COVER1, EV_COVER5)
                }
            } else if Q_irand(0, 3) == 0 {
                event = Q_irand(EV_SIGHT2, EV_SIGHT3)
            } else if Q_irand(0, 1) == 0 {
                event = Q_irand(EV_SOUND1, EV_SOUND3)
            } else if Q_irand(0, 2) == 0 {
                event = EV_LOST1
            } else if Q_irand(0, 1) == 0 {
                event = EV_ESCAPING2
            } else {
                event = EV_GIVEUP4
            }
        } else {
            //variant2
            if `self`.enemy != nil {
                if Q_irand(0, 9) > 6 {
                    event = Q_irand(EV_CHASE1, EV_CHASE3)
                } else if Q_irand(0, 6) > 4 {
                    event = Q_irand(EV_OUTFLANK1, EV_OUTFLANK2)
                } else {
                    event = Q_irand(EV_COVER1, EV_COVER5)
                }
            } else if Q_irand(0, 3) == 0 {
                event = Q_irand(EV_SIGHT1, EV_SIGHT2)
            } else if Q_irand(0, 1) == 0 {
                event = Q_irand(EV_SOUND1, EV_SOUND3)
            } else if Q_irand(0, 2) == 0 {
                event = EV_LOST1
            } else if Q_irand(0, 1) == 0 {
                event = EV_GIVEUP3
            } else {
                event = EV_CONFUSE1
            }
        }

    case CLASS_R2D2: // droid
        G_Sound(`self`, CHAN_AUTO, G_SoundIndex(va("sound/chars/r2d2/misc/r2d2talk0%d.wav", Q_irand(1, 3))))

    case CLASS_R5D2: // droid
        G_Sound(`self`, CHAN_AUTO, G_SoundIndex(va("sound/chars/r5d2/misc/r5talk%d.wav", Q_irand(1, 4))))

    case CLASS_MOUSE: // droid
        G_Sound(`self`, CHAN_AUTO, G_SoundIndex(va("sound/chars/mouse/misc/mousego%d.wav", Q_irand(1, 3))))

    case CLASS_GONK: // droid
        G_Sound(`self`, CHAN_AUTO, G_SoundIndex(va("sound/chars/gonk/misc/gonktalk%d.wav", Q_irand(1, 2))))

    default:
        break
    }

    if event != -1 {
        //hack here because we reuse some "combat" and "extra" sounds
        let addFlag: Bool = (`self`.NPC!.scriptFlags & SCF_NO_COMBAT_TALK) != 0
        `self`.NPC!.scriptFlags &= ~SCF_NO_COMBAT_TALK

        G_AddVoiceEvent(`self`, event, 3000)

        if addFlag {
            `self`.NPC!.scriptFlags |= SCF_NO_COMBAT_TALK
        }
    }
}

/// Source: oracle/codemp/game/NPC_reactions.c:950
func NPC_UseResponse(_ `self`: Entity, _ user: Entity, _ useWhenDone: Bool) {
    if `self`.NPC == nil || `self`.client == nil {
        return
    }

    if user.s.number != 0 {
        //not used by the player
        if useWhenDone {
            G_ActivateBehavior(`self`, BSET_USE)
        }
        return
    }

    if user.client != nil && `self`.client!.playerTeam != user.client!.playerTeam && `self`.client!.playerTeam != NPCTEAM_NEUTRAL {
        //only those on the same team react
        if useWhenDone {
            G_ActivateBehavior(`self`, BSET_USE)
        }
        return
    }

    if `self`.NPC!.blockedSpeechDebounceTime > level.time {
        //I'm not responding right now
        return
    }

    /*
    if ( gi.VoiceVolume[self->s.number] )
    {//I'm talking already
    if ( !useWhenDone )
    {//you're not trying to use me
    return;
    }
    }
    */
    //rwwFIXMEFIXME: Support for this?

    if useWhenDone {
        G_ActivateBehavior(`self`, BSET_USE)
    } else {
        NPC_Respond(`self`, user.s.number)
    }
}

/// Source: oracle/codemp/game/NPC_reactions.c:1008
func NPC_Use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if `self`.client!.ps.pm_type == PM_DEAD {
        //or just remove ->pain in player_die?
        return
    }

    SaveNPCGlobals()
    SetNPCGlobals(`self`)

    if `self`.client != nil && `self`.NPC != nil {
        // If this is a vehicle, let the other guy board it. Added 12/14/02 by AReis.
        if `self`.client!.NPC_class == CLASS_VEHICLE {
            let pVeh: Vehicle? = `self`.m_pVehicle

            if pVeh != nil && pVeh!.m_pVehicleInfo != nil {
                //if I used myself, eject everyone on me
                if other == `self` {
                    pVeh!.m_pVehicleInfo!.runEjectAll(pVeh)
                } else if other.s.owner == `self`.s.number {
                    // If other is already riding this vehicle (self), eject him.
                    pVeh!.m_pVehicleInfo!.runEject(pVeh, BgEntity(other), false)
                } else {
                    // Otherwise board this vehicle.
                    pVeh!.m_pVehicleInfo!.runBoard(pVeh, BgEntity(other))
                }
            }
        } else if Jedi_WaitingAmbush(NPC!) {
            Jedi_Ambush(NPC!)
        }
        //Run any use instructions
        if activator.s.number == 0 && `self`.client!.NPC_class == CLASS_GONK {
            // must be using the gonk, so attempt to give battery power.
            // NOTE: this will steal up to MAX_BATTERIES for the activator, leaving the residual on the gonk for potential later use.
            //			Add_Batteries( activator, &self->client->ps.batteryCharge );
            //rwwFIXMEFIXME: support for this?
        }
        // Not using MEDICs anymore
        /*
        if ( self->NPC->behaviorState == BS_MEDIC_HIDE && activator->client )
        {//Heal me NOW, dammit!
        if ( activator->health < activator->client->ps.stats[STAT_MAX_HEALTH] )
        {//person needs help
        if ( self->NPC->eventualGoal != activator )
        {//not my current patient already
        NPC_TakePatient( activator );
        G_ActivateBehavior( self, BSET_USE );
        }
        }
        else if ( !self->enemy && activator->s.number == 0 && !gi.VoiceVolume[self->s.number] && !(self->NPC->scriptFlags&SCF_NO_RESPONSE) )
        {//I don't have an enemy and I'm not talking and I was used by the player
        NPC_UseResponse( self, other, qfalse );
        }
        }
        */
        //		else if ( self->behaviorSet[BSET_USE] )
        if `self`.behaviorSet[BSET_USE] != nil {
            NPC_UseResponse(`self`, other, true)
        } else if `self`.enemy == nil && activator.s.number == 0 && !((`self`.NPC!.scriptFlags & SCF_NO_RESPONSE) != 0) {
            //		else if ( isMedic( self ) )
            //		{//Heal me NOW, dammit!
            //			NPC_TakePatient( activator );
            //		}
            //I don't have an enemy and I'm not talking and I was used by the player
            NPC_UseResponse(`self`, other, false)
        }
    }

    RestoreNPCGlobals()
}

/// Source: oracle/codemp/game/NPC_reactions.c:1095
func NPC_CheckPlayerAim() {
    //FIXME: need appropriate dialogue
    /*
    gentity_t *player = &g_entities[0];

    if ( player && player->client && player->client->ps.weapon > (int)(WP_NONE) && player->client->ps.weapon < (int)(WP_TRICORDER) )
    {//player has a weapon ready
    if ( g_crosshairEntNum == NPC->s.number && level.time - g_crosshairEntTime < 200
    && g_crosshairSameEntTime >= 3000 && g_crosshairEntDist < 256 )
    {//if the player holds the crosshair on you for a few seconds
    //ask them what the fuck they're doing
    G_AddVoiceEvent( NPC, Q_irand( EV_FF_1A, EV_FF_1C ), 0 );
    }
    }
    */
}

/// Source: oracle/codemp/game/NPC_reactions.c:1113
func NPC_CheckAllClear() {
    //FIXME: need to make this happen only once after losing enemies, not over and over again
    /*
    if ( NPC->client && !NPC->enemy && level.time - teamLastEnemyTime[NPC->client->playerTeam] > 10000 )
    {//Team hasn't seen an enemy in 10 seconds
    if ( !Q_irand( 0, 2 ) )
    {
    G_AddVoiceEvent( NPC, Q_irand(EV_SETTLE1, EV_SETTLE3), 3000 );
    }
    }
    */
}
