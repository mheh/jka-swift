import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_combat.c:44
let ANGER_ALERT_RADIUS = 512 as Int32

/// Source: oracle/codemp/game/NPC_combat.c:45
let ANGER_ALERT_SOUND_RADIUS = 256 as Int32

/// Source: oracle/codemp/game/NPC_combat.c:2652
let MIN_AVOID_DOT = 0.75 as Float

/// Source: oracle/codemp/game/NPC_combat.c:2653
let MIN_AVOID_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC_combat.c:2654
let MIN_AVOID_DISTANCE_SQUARED = (MIN_AVOID_DISTANCE * MIN_AVOID_DISTANCE)

/// Source: oracle/codemp/game/NPC_combat.c:2655
let CP_COLLECT_RADIUS = 512.0 as Float

/// Source: oracle/codemp/game/NPC_combat.c:17
func G_ClearEnemy(_ `self`: Entity) {
    NPC_CheckLookTarget(`self`)

    if `self`.enemy != nil {
        if `self`.client != nil && `self`.client!.renderInfo.lookTarget == `self`.enemy!.s.number {
            NPC_ClearLookTarget(`self`)
        }

        if `self`.NPC != nil && `self`.enemy == `self`.NPC!.goalEntity {
            `self`.NPC!.goalEntity = nil
        }
        //FIXME: set last enemy?
    }

    `self`.enemy = nil
}

/// Source: oracle/codemp/game/NPC_combat.c:47
func G_AngerAlert(_ `self`: Entity) {
    if `self`.NPC != nil && (`self`.NPC!.scriptFlags & SCF_NO_GROUPS) != 0 {
        //I'm not a team playa...
        return
    }
    if !TIMER_Done(`self`, "interrogating") {
        //I'm interrogating, don't wake everyone else up yet... FIXME: this may never wake everyone else up, though!
        return
    }
    //FIXME: hmm.... with all the other new alerts now, is this still neccesary or even a good idea...?
    G_AlertTeam(`self`, `self`.enemy!, Float(ANGER_ALERT_RADIUS), Float(ANGER_ALERT_SOUND_RADIUS))
}

/// Source: oracle/codemp/game/NPC_combat.c:67
func G_TeamEnemy(_ `self`: Entity) -> Bool {
    //FIXME: Probably a better way to do this, is a linked list of your teammates already available?
    var i: Int32
    var ent: Entity?

    if `self`.client == nil || `self`.client!.playerTeam == TEAM_FREE {
        return false
    }
    if `self`.NPC != nil && (`self`.NPC!.scriptFlags & SCF_NO_GROUPS) != 0 {
        //I'm not a team playa...
        return false
    }

    i = 1
    while i < level.num_entities {
        ent = g_entities[i]

        if ent == `self` {
            i += 1
            continue
        }

        if ent!.health <= 0 {
            i += 1
            continue
        }

        if ent!.client == nil {
            i += 1
            continue
        }

        if ent!.client!.playerTeam != `self`.client!.playerTeam {
            //ent is not on my team
            i += 1
            continue
        }

        if ent!.enemy != nil {
            //they have an enemy
            if ent!.enemy!.client == nil || ent!.enemy!.client!.playerTeam != `self`.client!.playerTeam {
                //the ent's enemy is either a normal ent or is a player/NPC that is not on my team
                return true
            }
        }
        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/NPC_combat.c:117
func G_AttackDelay(_ `self`: Entity, _ enemy: Entity) {
    if `self`.client != nil && `self`.NPC != nil {
        //delay their attack based on how far away they're facing from enemy
        var fwd = vec3_t()
        var dir = vec3_t()
        var attDelay: Int32

        dir = `self`.client!.renderInfo.eyePoint - enemy.r.currentOrigin //purposely backwards
        VectorNormalize(&dir)
        // Raven passes NULL for the `right` and `up` outputs, and the callee skips the write to each.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(`self`.client!.renderInfo.eyeAngles, &fwd, &scratchRight, &scratchUp)
        //dir[2] = fwd[2] = 0;//ignore z diff?

        attDelay = (4 - g_spskill.integer) * 500 //initial: from 1000ms delay on hard to 2000ms delay on easy
        if `self`.client!.playerTeam == NPCTEAM_PLAYER {
            //invert
            attDelay = 2000 - attDelay
        }
        attDelay = Int32(Float(attDelay) + floor((_DotProduct(fwd, dir) + 1.0) * 2000.0)) //add up to 4000ms delay if they're facing away

        //FIXME: should distance matter, too?

        //Now modify the delay based on NPC_class, weapon, and team
        //NOTE: attDelay should be somewhere between 1000 to 6000 milliseconds
        switch `self`.client!.NPC_class {
        case CLASS_IMPERIAL:
            attDelay += Q_irand(500, 1500)

        case CLASS_STORMTROOPER:
            if `self`.NPC!.rank >= RANK_LT {
                //officers shoot even sooner
                attDelay -= Q_irand(500, 1500)
            } else {
                //normal stormtroopers don't have as fast reflexes as officers
                attDelay -= Q_irand(0, 1000)
            }

        case CLASS_SWAMPTROOPER:
            attDelay -= Q_irand(1000, 2000)

        case CLASS_IMPWORKER:
            attDelay += Q_irand(1000, 2500)

        case CLASS_TRANDOSHAN:
            attDelay -= Q_irand(500, 1500)

        case CLASS_JAN, CLASS_LANDO, CLASS_PRISONER, CLASS_REBEL:
            attDelay -= Q_irand(500, 1500)

        case CLASS_GALAKMECH, CLASS_ATST:
            attDelay -= Q_irand(1000, 2000)

        case CLASS_REELO, CLASS_UGNAUGHT, CLASS_JAWA:
            return

        case CLASS_MINEMONSTER, CLASS_MURJJ:
            return

        case CLASS_INTERROGATOR, CLASS_PROBE, CLASS_MARK1, CLASS_MARK2, CLASS_SENTRY:
            return

        case CLASS_REMOTE, CLASS_SEEKER:
            return

        default:
            break
        }

        switch `self`.s.weapon {
        case WP_NONE, WP_SABER:
            return

        case WP_BRYAR_PISTOL:
            break

        case WP_BLASTER:
            if (`self`.NPC!.scriptFlags & SCF_ALT_FIRE) != 0 {
                //rapid-fire blasters
                attDelay += Q_irand(0, 500)
            } else {
                //regular blaster
                attDelay -= Q_irand(0, 500)
            }

        case WP_BOWCASTER:
            attDelay += Q_irand(0, 500)

        case WP_REPEATER:
            if !((`self`.NPC!.scriptFlags & SCF_ALT_FIRE) != 0) {
                //rapid-fire blasters
                attDelay += Q_irand(0, 500)
            }

        case WP_FLECHETTE:
            attDelay += Q_irand(500, 1500)

        case WP_ROCKET_LAUNCHER:
            attDelay += Q_irand(500, 1500)
            //		case WP_BLASTER_PISTOL:	// apparently some enemy only version of the blaster
            //			attDelay -= Q_irand( 500, 1500 );
            //			break;
            //rwwFIXMEFIXME: Have this weapon for NPCs?

        case WP_DISRUPTOR:
            return

        case WP_THERMAL:
            return

        case WP_STUN_BATON:
            return

        case WP_EMPLACED_GUN:
            return

        case WP_TURRET:
            return
            break

        default:
            break
        }

        if `self`.client!.playerTeam == NPCTEAM_PLAYER {
            //clamp it
            if attDelay > 2000 {
                attDelay = 2000
            }
        }

        //don't shoot right away
        if attDelay > 4000 + ((2 - g_spskill.integer) * 3000) {
            attDelay = 4000 + ((2 - g_spskill.integer) * 3000)
        }
        TIMER_Set(`self`, "attackDelay", attDelay) //Q_irand( 1500, 4500 ) );
        //don't move right away either
        if attDelay > 4000 {
            attDelay = 4000 - Q_irand(500, 1500)
        } else {
            attDelay -= Q_irand(500, 1500)
        }

        TIMER_Set(`self`, "roamTime", attDelay) //was Q_irand( 1000, 3500 );
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:312
func G_ForceSaberOn(_ ent: Entity) {
    if ent.client!.ps.saberInFlight {
        //alright, can't turn it on now in any case, so forget it.
        return
    }

    if ent.client!.ps.saberHolstered == 0 {
        //it's already on!
        return
    }

    if ent.client!.ps.weapon != WP_SABER {
        //This probably should never happen. But if it does we'll just return without complaining.
        return
    }

    //Well then, turn it on.
    ent.client!.ps.saberHolstered = 0

    if ent.client!.saber[0].soundOn != 0 {
        G_Sound(ent, CHAN_AUTO, ent.client!.saber[0].soundOn)
    }
    if ent.client!.saber[1].soundOn != 0 {
        G_Sound(ent, CHAN_AUTO, ent.client!.saber[1].soundOn)
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:349
func G_SetEnemy(_ `self`: Entity, _ enemy: Entity) {
    var event: Int32 = 0

    //Must be valid
    if enemy == nil {
        return
    }

    //Must be valid
    if !enemy.inuse {
        return
    }

    //Don't take the enemy if in notarget
    if (enemy.flags & FL_NOTARGET) != 0 {
        return
    }

    if `self`.NPC == nil {
        `self`.enemy = enemy
        return
    }

    if `self`.NPC!.confusionTime > level.time {
        //can't pick up enemies if confused
        return
    }


    //	if ( enemy->client && enemy->client->playerTeam == TEAM_DISGUISE )
    //	{//unmask the player
    //		enemy->client->playerTeam = TEAM_PLAYER;
    //	}

    if `self`.client != nil && `self`.NPC != nil && enemy.client != nil && enemy.client!.playerTeam == `self`.client!.playerTeam {
        //Probably a damn script!
        if `self`.NPC!.charmedTime > level.time {
            //Probably a damn script!
            return
        }
    }

    if `self`.NPC != nil && `self`.client != nil && `self`.client!.ps.weapon == WP_SABER {
        //when get new enemy, set a base aggression based on what that enemy is using, how far they are, etc.
        NPC_Jedi_RateNewEnemy(`self`, enemy)
    }

    //NOTE: this is not necessarily true!
    //self->NPC->enemyLastSeenTime = level.time;

    if `self`.enemy == nil {
        //TEMP HACK: turn on our saber
        if `self`.health > 0 {
            G_ForceSaberOn(`self`)
        }

        //FIXME: Have to do this to prevent alert cascading
        G_ClearEnemy(`self`)
        `self`.enemy = enemy

        //Special case- if player is being hunted by his own people, set their enemy team correctly
        if `self`.client!.playerTeam == NPCTEAM_PLAYER && enemy.s.number == 0 {
            `self`.client!.enemyTeam = NPCTEAM_PLAYER
        }

        //If have an anger script, run that instead of yelling
        if G_ActivateBehavior(`self`, BSET_ANGER) {
        } else if `self`.client != nil && enemy.client != nil && `self`.client!.playerTeam != enemy.client!.playerTeam {
            //FIXME: Use anger when entire team has no enemy.
            //		 Basically, you're first one to notice enemies
            //if ( self->forcePushTime < level.time ) // not currently being pushed
            if 1 != 0 {
                if !G_TeamEnemy(`self`) {
                    //team did not have an enemy previously
                    event = Q_irand(EV_ANGER1, EV_ANGER3)
                }
            }

            if event != 0 {
                //yell
                G_AddVoiceEvent(`self`, event, 2000)
            }
        }

        if `self`.s.weapon == WP_BLASTER || `self`.s.weapon == WP_REPEATER || `self`.s.weapon == WP_THERMAL || `self`.s.weapon == WP_BOWCASTER {
            //Hmm, how about sniper and bowcaster?
            //When first get mad, aim is bad
            //Hmm, base on game difficulty, too?  Rank?
            if `self`.client!.playerTeam == NPCTEAM_PLAYER {
                G_AimSet(`self`, Q_irand(`self`.NPC!.stats.aim - (5 * (g_spskill.integer)), `self`.NPC!.stats.aim - g_spskill.integer))
            } else {
                var minErr: Int32 = 3
                var maxErr: Int32 = 12
                if `self`.client!.NPC_class == CLASS_IMPWORKER {
                    minErr = 15
                    maxErr = 30
                } else if `self`.client!.NPC_class == CLASS_STORMTROOPER && `self`.NPC != nil && `self`.NPC!.rank <= RANK_CREWMAN {
                    minErr = 5
                    maxErr = 15
                }

                G_AimSet(`self`, Q_irand(`self`.NPC!.stats.aim - (maxErr * (3 - g_spskill.integer)), `self`.NPC!.stats.aim - (minErr * (3 - g_spskill.integer))))
            }
        }

        //Alert anyone else in the area
        if Q_stricmp("desperado", `self`.NPC_type!) != 0 && Q_stricmp("paladin", `self`.NPC_type!) != 0 {
            //special holodeck enemies exception
            if `self`.client!.ps.fd.forceGripBeingGripped < level.time {
                //gripped people can't call for help
                G_AngerAlert(`self`)
            }
        }

        //Stormtroopers don't fire right away!
        G_AttackDelay(`self`, enemy)

        //rwwFIXMEFIXME: Deal with this some other way.
        /*
        //FIXME: this is a disgusting hack that is supposed to make the Imperials start with their weapon holstered- need a better way
        if ( self->client->ps.weapon == WP_NONE && !Q_strncmp( self->NPC_type, "imp", 3 ) && !(self->NPC->scriptFlags & SCF_FORCED_MARCH)  )
        {
        if ( self->client->ps.stats[STAT_WEAPONS] & ( 1 << WP_BLASTER ) )
        {
        ChangeWeapon( self, WP_BLASTER );
        self->client->ps.weapon = WP_BLASTER;
        self->client->ps.weaponstate = WEAPON_READY;
        G_CreateG2AttachedWeaponModel( self, weaponData[WP_BLASTER].weaponMdl, self->handRBolt, 0 );
        }
        else if ( self->client->ps.stats[STAT_WEAPONS] & ( 1 << WP_BLASTER_PISTOL ) )
        {
        ChangeWeapon( self, WP_BLASTER_PISTOL );
        self->client->ps.weapon = WP_BLASTER_PISTOL;
        self->client->ps.weaponstate = WEAPON_READY;
        G_CreateG2AttachedWeaponModel( self, weaponData[WP_BLASTER_PISTOL].weaponMdl, self->handRBolt, 0 );
        }
        }
        */
        return
    }

    //Otherwise, just picking up another enemy

    if event != 0 {
        G_AddVoiceEvent(`self`, event, 2000)
    }

    //Take the enemy
    G_ClearEnemy(`self`)
    `self`.enemy = enemy
}

/// Source: oracle/codemp/game/NPC_combat.c:570
func ChangeWeapon(_ ent: Entity, _ newWeapon: Int32) {
    if ent.client == nil || ent.NPC == nil {
        return
    }

    ent.client!.ps.weapon = newWeapon
    ent.client!.pers.cmd.weapon = newWeapon
    ent.NPC!.shotTime = 0
    ent.NPC!.burstCount = 0
    ent.NPC!.attackHold = 0
    ent.NPC!.currentAmmo = ent.client!.ps.ammo[weaponData[newWeapon].ammoIndex]

    switch newWeapon {
    case WP_BRYAR_PISTOL:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        ent.NPC!.burstSpacing = 1000 //attackdebounce
        /*
        case WP_BLASTER_PISTOL:
        ent->NPC->aiFlags &= ~NPCAI_BURST_WEAPON;
        //	ent->NPC->burstSpacing = 1000;//attackdebounce
        if ( g_spskill.integer == 0 )
        ent->NPC->burstSpacing = 1000;//attack debounce
        else if ( g_spskill.integer == 1 )
        ent->NPC->burstSpacing = 750;//attack debounce
        else
        ent->NPC->burstSpacing = 500;//attack debounce
        break;
        */
        //rwwFIXMEFIXME: support WP_BLASTER_PISTOL and WP_BOT_LASER
        /*
        case WP_BOT_LASER://probe attack
        ent->NPC->aiFlags &= ~NPCAI_BURST_WEAPON;
        //	ent->NPC->burstSpacing = 600;//attackdebounce
        if ( g_spskill.integer == 0 )
        ent->NPC->burstSpacing = 600;//attack debounce
        else if ( g_spskill.integer == 1 )
        ent->NPC->burstSpacing = 400;//attack debounce
        else
        ent->NPC->burstSpacing = 200;//attack debounce
        break;
        */

    case WP_SABER:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        ent.NPC!.burstSpacing = 0 //attackdebounce

    case WP_DISRUPTOR:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        if (ent.NPC!.scriptFlags & SCF_ALT_FIRE) != 0 {
            switch g_spskill.integer {
            case 0:
                ent.NPC!.burstSpacing = 2500 //attackdebounce

            case 1:
                ent.NPC!.burstSpacing = 2000 //attackdebounce

            case 2:
                ent.NPC!.burstSpacing = 1500 //attackdebounce

            default:
                break
            }
        } else {
            ent.NPC!.burstSpacing = 1000 //attackdebounce
        }

    case WP_BOWCASTER:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        //	ent->NPC->burstSpacing = 1000;//attackdebounce
        if g_spskill.integer == 0 {
            ent.NPC!.burstSpacing = 1000 //attack debounce
        } else if g_spskill.integer == 1 {
            ent.NPC!.burstSpacing = 750 //attack debounce
        } else {
            ent.NPC!.burstSpacing = 500 //attack debounce
        }

    case WP_REPEATER:
        if (ent.NPC!.scriptFlags & SCF_ALT_FIRE) != 0 {
            ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
            ent.NPC!.burstSpacing = 2000 //attackdebounce
        } else {
            ent.NPC!.aiFlags |= NPCAI_BURST_WEAPON
            ent.NPC!.burstMin = 3
            ent.NPC!.burstMean = 6
            ent.NPC!.burstMax = 10
            if g_spskill.integer == 0 {
                ent.NPC!.burstSpacing = 1500 //attack debounce
            } else if g_spskill.integer == 1 {
                ent.NPC!.burstSpacing = 1000 //attack debounce
            } else {
                ent.NPC!.burstSpacing = 500 //attack debounce
            }
        }

    case WP_DEMP2:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        ent.NPC!.burstSpacing = 1000 //attackdebounce

    case WP_FLECHETTE:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        if (ent.NPC!.scriptFlags & SCF_ALT_FIRE) != 0 {
            ent.NPC!.burstSpacing = 2000 //attackdebounce
        } else {
            ent.NPC!.burstSpacing = 1000 //attackdebounce
        }

    case WP_ROCKET_LAUNCHER:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        //	ent->NPC->burstSpacing = 2500;//attackdebounce
        if g_spskill.integer == 0 {
            ent.NPC!.burstSpacing = 2500 //attack debounce
        } else if g_spskill.integer == 1 {
            ent.NPC!.burstSpacing = 2000 //attack debounce
        } else {
            ent.NPC!.burstSpacing = 1500 //attack debounce
        }

    case WP_THERMAL:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        //	ent->NPC->burstSpacing = 3000;//attackdebounce
        if g_spskill.integer == 0 {
            ent.NPC!.burstSpacing = 3000 //attack debounce
        } else if g_spskill.integer == 1 {
            ent.NPC!.burstSpacing = 2500 //attack debounce
        } else {
            ent.NPC!.burstSpacing = 2000 //attack debounce
        }
        /*
        case WP_SABER:
        ent->NPC->aiFlags |= NPCAI_BURST_WEAPON;
        ent->NPC->burstMin = 5;//0.5 sec
        ent->NPC->burstMean = 10;//1 second
        ent->NPC->burstMax = 20;//3 seconds
        ent->NPC->burstSpacing = 2000;//2 seconds
        ent->NPC->attackHold = 1000;//Hold attack button for a 1-second burst
        break;
        case WP_TRICORDER:
        ent->NPC->aiFlags |= NPCAI_BURST_WEAPON;
        ent->NPC->burstMin = 5;
        ent->NPC->burstMean = 10;
        ent->NPC->burstMax = 30;
        ent->NPC->burstSpacing = 1000;
        break;
        */

    case WP_BLASTER:
        if (ent.NPC!.scriptFlags & SCF_ALT_FIRE) != 0 {
            ent.NPC!.aiFlags |= NPCAI_BURST_WEAPON
            ent.NPC!.burstMin = 3
            ent.NPC!.burstMean = 3
            ent.NPC!.burstMax = 3
            if g_spskill.integer == 0 {
                ent.NPC!.burstSpacing = 1500 //attack debounce
            } else if g_spskill.integer == 1 {
                ent.NPC!.burstSpacing = 1000 //attack debounce
            } else {
                ent.NPC!.burstSpacing = 500 //attack debounce
            }
        } else {
            ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
            if g_spskill.integer == 0 {
                ent.NPC!.burstSpacing = 1000 //attack debounce
            } else if g_spskill.integer == 1 {
                ent.NPC!.burstSpacing = 750 //attack debounce
            } else {
                ent.NPC!.burstSpacing = 500 //attack debounce
            }
            //	ent->NPC->burstSpacing = 1000;//attackdebounce
        }

    case WP_STUN_BATON:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
        ent.NPC!.burstSpacing = 1000 //attackdebounce
        /*
        case WP_ATST_MAIN:
        case WP_ATST_SIDE:
        ent->NPC->aiFlags &= ~NPCAI_BURST_WEAPON;
        //	ent->NPC->burstSpacing = 1000;//attackdebounce
        if ( g_spskill.integer == 0 )
        ent->NPC->burstSpacing = 1000;//attack debounce
        else if ( g_spskill.integer == 1 )
        ent->NPC->burstSpacing = 750;//attack debounce
        else
        ent->NPC->burstSpacing = 500;//attack debounce
        break;
        */
        //rwwFIXMEFIXME: support for atst weaps

    case WP_EMPLACED_GUN:
        //FIXME: give some designer-control over this?
        if ent.client != nil && ent.client!.NPC_class == CLASS_REELO {
            ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
            ent.NPC!.burstSpacing = 1000 //attack debounce
            //		if ( g_spskill.integer == 0 )
            //			ent->NPC->burstSpacing = 300;//attack debounce
            //		else if ( g_spskill.integer == 1 )
            //			ent->NPC->burstSpacing = 200;//attack debounce
            //		else
            //			ent->NPC->burstSpacing = 100;//attack debounce
        } else {
            ent.NPC!.aiFlags |= NPCAI_BURST_WEAPON
            ent.NPC!.burstMin = 2 // 3 shots, really
            ent.NPC!.burstMean = 2
            ent.NPC!.burstMax = 2

            if ent.parent != nil {
                if g_spskill.integer == 0 {
                    ent.NPC!.burstSpacing = Int32(ent.parent!.wait + 400) //attack debounce
                    ent.NPC!.burstMax = 1 // two shots
                    ent.NPC!.burstMin = ent.NPC!.burstMax // two shots
                } else if g_spskill.integer == 1 {
                    ent.NPC!.burstSpacing = Int32(ent.parent!.wait + 200) //attack debounce
                } else {
                    ent.NPC!.burstSpacing = Int32(ent.parent!.wait) //attack debounce
                }
            } else {
                if g_spskill.integer == 0 {
                    ent.NPC!.burstSpacing = 1200 //attack debounce
                    ent.NPC!.burstMax = 1 // two shots
                    ent.NPC!.burstMin = ent.NPC!.burstMax // two shots
                } else if g_spskill.integer == 1 {
                    ent.NPC!.burstSpacing = 1000 //attack debounce
                } else {
                    ent.NPC!.burstSpacing = 800 //attack debounce
                }
            }
        }

    default:
        ent.NPC!.aiFlags &= ~NPCAI_BURST_WEAPON
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:844
func NPC_ChangeWeapon(_ newWeapon: Int32) {
    /*
    qboolean	changing = qfalse;
    if ( newWeapon != NPC->client->ps.weapon )
    {
    changing = qtrue;
    }
    if ( changing && NPC->weaponModel[0] > 9 )
    {
    trap_G2API_RemoveGhoul2Model( NPC->ghoul2, NPC->weaponModel[0] );
    }
    ChangeWeapon( NPC, newWeapon );
    if ( changing && NPC->client->ps.weapon != WP_NONE )
    {
    if ( NPC->client->ps.weapon == WP_SABER )
    {
    G_CreateG2AttachedWeaponModel( NPC, NPC->client->ps.saber[0].model, NPC->handRBolt, 0 );
    if ( NPC->client->ps.dualSabers )
    {
    G_CreateG2AttachedWeaponModel( NPC, NPC->client->ps.saber[1].model, NPC->handLBolt, 0 );
    }
    }
    else
    {
    G_CreateG2AttachedWeaponModel( NPC, weaponData[NPC->client->ps.weapon].weaponMdl, NPC->handRBolt, 0 );
    }
    }*/
    //rwwFIXMEFIXME: Change the same way as players, all this stuff is just crazy.
}

/**
```
void NPC_ApplyWeaponFireDelay(void)
How long, if at all, in msec the actual fire should delay from the time the attack was started
```
*/
/// Source: oracle/codemp/game/NPC_combat.c:878
func NPC_ApplyWeaponFireDelay() {
    if NPC!.attackDebounceTime > level.time {
        //Just fired, if attacking again, must be a burst fire, so don't add delay
        //NOTE: Borg AI uses attackDebounceTime "incorrectly", so this will always return for them!
        return
    }

    switch client!.ps.weapon {
    /*
    case WP_BOT_LASER:
    NPCInfo->burstCount = 0;
    client->ps.weaponTime = 500;
    break;
    */
    case WP_THERMAL:
        if client!.ps.clientNum != 0 {
            //NPCs delay...
            //FIXME: player should, too, but would feel weird in 1st person, even though it
            //			would look right in 3rd person.  Really should have a wind-up anim
            //			for player as he holds down the fire button to throw, then play
            //			the actual throw when he lets go...
            client!.ps.weaponTime = 700
        }

    case WP_STUN_BATON:
        //if ( !PM_DroidMelee( client->NPC_class ) )
        if 1 != 0 {
            //FIXME: should be unique per melee anim
            client!.ps.weaponTime = 300
        }

    default:
        client!.ps.weaponTime = 0
    }
}

/**
```
-------------------------
ShootThink
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_combat.c:925
func ShootThink() {
    var delay: Int32

    ucmd.buttons &= ~BUTTON_ATTACK
    /*
    if ( enemyVisibility != VIS_SHOOT)
    return;
    */

    if client!.ps.weapon == WP_NONE {
        return
    }

    if client!.ps.weaponstate != WEAPON_READY && client!.ps.weaponstate != WEAPON_FIRING && client!.ps.weaponstate != WEAPON_IDLE {
        return
    }

    if level.time < NPCInfo!.shotTime {
        return
    }

    ucmd.buttons |= BUTTON_ATTACK

    NPCInfo!.currentAmmo = client!.ps.ammo[weaponData[client!.ps.weapon].ammoIndex] // checkme

    NPC_ApplyWeaponFireDelay()

    if (NPCInfo!.aiFlags & NPCAI_BURST_WEAPON) != 0 {
        if NPCInfo!.burstCount == 0 {
            NPCInfo!.burstCount = Q_irand(NPCInfo!.burstMin, NPCInfo!.burstMax)
            /*
            NPCInfo->burstCount = erandom( NPCInfo->burstMean );
            if ( NPCInfo->burstCount < NPCInfo->burstMin )
            {
            NPCInfo->burstCount = NPCInfo->burstMin;
            }
            else if ( NPCInfo->burstCount > NPCInfo->burstMax )
            {
            NPCInfo->burstCount = NPCInfo->burstMax;
            }
            */
            delay = 0
        } else {
            NPCInfo!.burstCount -= 1
            if NPCInfo!.burstCount == 0 {
                delay = NPCInfo!.burstSpacing
            } else {
                delay = 0
            }
        }

        if delay == 0 {
            // HACK: dirty little emplaced bits, but is done because it would otherwise require some sort of new variable...
            if client!.ps.weapon == WP_EMPLACED_GUN {
                if NPC!.parent != nil {
                    if g_spskill.integer == 0 {
                        delay = Int32(NPC!.parent!.random + 150)
                    } else if g_spskill.integer == 1 {
                        delay = Int32(NPC!.parent!.random + 100)
                    } else {
                        delay = Int32(NPC!.parent!.random)
                    }
                } else {
                    if g_spskill.integer == 0 {
                        delay = 350
                    } else if g_spskill.integer == 1 {
                        delay = 300
                    } else {
                        delay = 200
                    }
                }
            }
        }
    } else {
        delay = NPCInfo!.burstSpacing
    }

    NPCInfo!.shotTime = level.time + delay
    NPC!.attackDebounceTime = level.time + NPC_AttackDebounceForWeapon()
}

/**
```
static void WeaponThink( qboolean inCombat )
FIXME makes this so there's a delay from event that caused us to check to actually doing it

Added: hacks for Borg
```
*/
/// Source: oracle/codemp/game/NPC_combat.c:1036
func WeaponThink(_ inCombat: Bool) {
    if client!.ps.weaponstate == WEAPON_RAISING || client!.ps.weaponstate == WEAPON_DROPPING {
        ucmd.weapon = client!.ps.weapon
        ucmd.buttons &= ~BUTTON_ATTACK
        return
    }

    //MCG - Begin
    //For now, no-one runs out of ammo
    if NPC!.client!.ps.ammo[weaponData[client!.ps.weapon].ammoIndex] < 10 {
        Add_Ammo(NPC!, client!.ps.weapon, 100)
    }

    /*if ( NPC->playerTeam == TEAM_BORG )
    {//HACK!!!
    if(!(NPC->client->ps.stats[STAT_WEAPONS] & ( 1 << WP_BORG_WEAPON )))
    NPC->client->ps.stats[STAT_WEAPONS] |= ( 1 << WP_BORG_WEAPON );

    if ( client->ps.weapon != WP_BORG_WEAPON )
    {
    NPC_ChangeWeapon( WP_BORG_WEAPON );
    Add_Ammo (NPC, client->ps.weapon, 10);
    NPCInfo->currentAmmo = client->ps.ammo[client->ps.weapon];
    }
    }
    else */

    /*if ( NPC->client->playerTeam == TEAM_SCAVENGERS )
    {//HACK!!!
    if(!(NPC->client->ps.stats[STAT_WEAPONS] & ( 1 << WP_BLASTER )))
    NPC->client->ps.stats[STAT_WEAPONS] |= ( 1 << WP_BLASTER );

    if ( client->ps.weapon != WP_BLASTER )

    {
    NPC_ChangeWeapon( WP_BLASTER );
    Add_Ammo (NPC, client->ps.weapon, 10);
    //			NPCInfo->currentAmmo = client->ps.ammo[client->ps.weapon];
    NPCInfo->currentAmmo = client->ps.ammo[weaponData[client->ps.weapon].ammoIndex];	// checkme
    }
    }
    else*/
    //MCG - End
    do {
        // if the gun in our hands is out of ammo, we need to change
        /*if ( client->ps.ammo[client->ps.weapon] == 0 )
        {
        NPCInfo->aiFlags |= NPCAI_CHECK_WEAPON;
        }

        if ( NPCInfo->aiFlags & NPCAI_CHECK_WEAPON )
        {
        NPCInfo->aiFlags &= ~NPCAI_CHECK_WEAPON;
        bestWeapon = ChooseBestWeapon();
        if ( bestWeapon != client->ps.weapon )
        {
        NPC_ChangeWeapon( bestWeapon );
        }
        }*/
    }

    ucmd.weapon = client!.ps.weapon
    ShootThink()
}

/// Source: oracle/codemp/game/NPC_combat.c:1109
func HaveWeapon(_ weapon: Int32) -> Bool {
    return (client!.ps.stats[STAT_WEAPONS] & (1 << weapon)) != 0
}

/// Source: oracle/codemp/game/NPC_combat.c:1114
func EntIsGlass(_ check: Entity) -> Bool {
    if check.classname != nil && Q_stricmp("func_breakable", check.classname!) == 0 && check.count == 1 && check.health <= 100 {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/NPC_combat.c:1126
func ShotThroughGlass(_ tr: JKAMP.Trace, _ target: Entity, _ spot: JKAShared.vec3_t, _ mask: Int32) -> Bool {
    let hit: Entity? = g_entities[tr.entityNum]
    if hit != target && EntIsGlass(hit!) {
        //ok to shoot through breakable glass
        let skip: Int32 = hit!.s.number
        var muzzle = vec3_t()

        muzzle = tr.endpos
        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("ShotThroughGlass", source: "oracle/codemp/game/NPC_combat.c:1126")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("ShotThroughGlass", source: "oracle/codemp/game/NPC_combat.c:1126")
        trap_Trace(tr, muzzle, vec3_origin, vec3_origin, spot, skip, mask)
        return true
    }

    return false
}

/**
```
CanShoot
determine if NPC can directly target enemy

this function does not check teams, invulnerability, notarget, etc....

Added: If can't shoot center, try head, if not, see if it's close enough to try anyway.
```
*/
/// Source: oracle/codemp/game/NPC_combat.c:1150
func CanShoot(_ ent: Entity, _ shooter: Entity) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var muzzle = vec3_t()
        var spot = vec3_t()
        var diff = vec3_t()
        var traceEnt: Entity?

        CalcEntitySpot(shooter, SPOT_WEAPON, &muzzle)
        CalcEntitySpot(ent, SPOT_ORIGIN, &spot) //FIXME preferred target locations for some weapons (feet for R/L)

        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("CanShoot", source: "oracle/codemp/game/NPC_combat.c:1150")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("CanShoot", source: "oracle/codemp/game/NPC_combat.c:1150")
        trap_Trace(tr, muzzle, vec3_origin, vec3_origin, spot, shooter.s.number, MASK_SHOT)
        traceEnt = g_entities[tr.entityNum]

        // point blank, baby!
        if tr.startsolid != 0 && shooter.NPC != nil && shooter.NPC!.touchedByPlayer != nil {
            traceEnt = shooter.NPC!.touchedByPlayer
        }

        if ShotThroughGlass(tr, ent, spot, MASK_SHOT) {
            traceEnt = g_entities[tr.entityNum]
        }

        // shot is dead on
        if traceEnt == ent {
            return true
        } else {
            //MCG - Begin
            //ok, can't hit them in center, try their head
            CalcEntitySpot(ent, SPOT_HEAD, &spot)
            // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
            portMissing("CanShoot", source: "oracle/codemp/game/NPC_combat.c:1150")
            // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
            portMissing("CanShoot", source: "oracle/codemp/game/NPC_combat.c:1150")
            trap_Trace(tr, muzzle, vec3_origin, vec3_origin, spot, shooter.s.number, MASK_SHOT)
            traceEnt = g_entities[tr.entityNum]
            if traceEnt == ent {
                return true
            }
        }

        //Actually, we should just check to fire in dir we're facing and if it's close enough,
        //and we didn't hit someone on our own team, shoot
        diff = spot - tr.endpos
        // The SDK also declares `random`, so the call names the bg module.
        if VectorLength(diff) < JKAMP_BG.random() * 32 {
            return true
        }
        //MCG - End
        // shot would hit a non-client
        if traceEnt!.client == nil {
            return false
        }

        // shot is blocked by another player

        // he's already dead, so go ahead
        if traceEnt!.health <= 0 {
            return true
        }

        // don't deliberately shoot a teammate
        if traceEnt!.client != nil && (traceEnt!.client!.playerTeam == shooter.client!.playerTeam) {
            return false
        }

        // he's just in the wrong place, go ahead
        return true
    }
}

/**
```
void NPC_CheckPossibleEnemy( gentity_t *other, visibility_t vis )

Added: hacks for scripted NPCs
```
*/
/// Source: oracle/codemp/game/NPC_combat.c:1229
func NPC_CheckPossibleEnemy(_ other: Entity, _ vis: visibility_t) {
    // is he is already our enemy?
    if other == NPC!.enemy {
        return
    }

    if (other.flags & FL_NOTARGET) != 0 {
        return
    }

    // we already have an enemy and this guy is in our FOV, see if this guy would be better
    if NPC!.enemy != nil && vis == VIS_FOV {
        if NPCInfo!.enemyLastSeenTime - level.time < 2000 {
            return
        }
        if enemyVisibility == VIS_UNKNOWN {
            enemyVisibility = NPC_CheckVisibility(NPC!.enemy!, CHECK_360 | CHECK_FOV)
        }
        if enemyVisibility == VIS_FOV {
            return
        }
    }

    if NPC!.enemy == nil {
        //only take an enemy if you don't have one yet
        G_SetEnemy(NPC!, other)
    }

    if vis == VIS_FOV {
        NPCInfo!.enemyLastSeenTime = level.time
        NPCInfo!.enemyLastSeenLocation = other.r.currentOrigin
        NPCInfo!.enemyLastHeardTime = 0
        NPCInfo!.enemyLastHeardLocation = vec3_t()
    } else {
        NPCInfo!.enemyLastSeenTime = 0
        NPCInfo!.enemyLastSeenLocation = vec3_t()
        NPCInfo!.enemyLastHeardTime = level.time
        NPCInfo!.enemyLastHeardLocation = other.r.currentOrigin
    }
}

/**
```
int NPC_AttackDebounceForWeapon (void)

DOES NOT control how fast you can fire
Only makes you keep your weapon up after you fire
```
*/
/// Source: oracle/codemp/game/NPC_combat.c:1288
func NPC_AttackDebounceForWeapon() -> Int32 {
    switch NPC!.client!.ps.weapon {
    /*
    case WP_BLASTER://scav rifle
    return 1000;
    break;
    case WP_BRYAR_PISTOL://prifle
    return 3000;
    break;
    case WP_SABER:
    return 100;
    break;
    case WP_TRICORDER:
    return 0;//tricorder
    break;
    */
    case WP_SABER:
        return 0
        /*
        case WP_BOT_LASER:
        if ( g_spskill.integer == 0 )
        return 2000;
        if ( g_spskill.integer == 1 )
        return 1500;
        return 1000;
        break;
        */
        //rwwFIXMEFIXME: support

    default:
        return NPCInfo!.burstSpacing //was 100 by default
    }
}

//FIXME: need a mindist for explosive weapons
/// Source: oracle/codemp/game/NPC_combat.c:1334
func NPC_MaxDistSquaredForWeapon() -> Float {
    if NPCInfo!.stats.shootDistance > 0 {
        //overrides default weapon dist
        return NPCInfo!.stats.shootDistance * NPCInfo!.stats.shootDistance
    }

    switch NPC!.s.weapon {
    case WP_BLASTER:
        return Float(1024 * 1024) //should be shorter?

    case WP_BRYAR_PISTOL:
        return Float(1024 * 1024)
        /*
        case WP_BLASTER_PISTOL://prifle
        return 1024 * 1024;
        break;
        */

    case WP_DISRUPTOR:
        if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
            return Float((4096 * 4096))
        } else {
            return Float(1024 * 1024)
        }
        /*
        case WP_SABER:
        return 1024 * 1024;
        break;
        case WP_TRICORDER:
        return 0;//tricorder
        break;
        */

    case WP_SABER:
        if NPC!.client != nil && NPC!.client!.saber[0].blade[0].lengthMax != 0 {
            //FIXME: account for whether enemy and I are heading towards each other!
            return Float((Double(NPC!.client!.saber[0].blade[0].lengthMax) + Double(NPC!.r.maxs[0]) * 1.5) * (Double(NPC!.client!.saber[0].blade[0].lengthMax) + Double(NPC!.r.maxs[0]) * 1.5))
        } else {
            return Float(48 * 48)
        }

    default:
        return Float(1024 * 1024) //was 0
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:1400
func ValidEnemy(_ ent: Entity) -> Bool {
    if ent == nil {
        return false
    }

    if ent == NPC {
        return false
    }

    //if team_free, maybe everyone is an enemy?
    //if ( !NPC->client->enemyTeam )
    //	return qfalse;

    if !((ent.flags & FL_NOTARGET) != 0) {
        if ent.health > 0 {
            if ent.client == nil {
                return true
            } else if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
                //don't go after spectators
                return false
            } else {
                var entTeam: Int32 = TEAM_FREE
                if ent.NPC != nil && ent.client != nil {
                    entTeam = ent.client!.playerTeam
                } else if ent.client != nil {
                    if ent.client!.sess.sessionTeam == TEAM_BLUE {
                        entTeam = NPCTEAM_PLAYER
                    } else if ent.client!.sess.sessionTeam == TEAM_RED {
                        entTeam = NPCTEAM_ENEMY
                    } else {
                        entTeam = NPCTEAM_NEUTRAL
                    }
                }
                if entTeam == NPCTEAM_FREE || NPC!.client!.enemyTeam == NPCTEAM_FREE || entTeam == NPC!.client!.enemyTeam {
                    if entTeam != NPC!.client!.playerTeam {
                        return true
                    }
                }
            }
        }
    }

    return false
}

/// Source: oracle/codemp/game/NPC_combat.c:1462
func NPC_EnemyTooFar(_ enemy: Entity, _ dist: Float, _ toShoot: Bool) -> Bool {
    var vec = vec3_t()
    // Raven assigns his own `dist` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var dist = dist


    if !toShoot {
        //Not trying to actually press fire button with this check
        if NPC!.client!.ps.weapon == WP_SABER {
            //Just have to get to him
            return false
        }
    }


    if dist == 0 {
        vec = NPC!.r.currentOrigin - enemy.r.currentOrigin
        dist = VectorLengthSquared(vec)
    }

    if dist > NPC_MaxDistSquaredForWeapon() {
        return true
    }

    return false
}

/**
```
NPC_PickEnemy

Randomly picks a living enemy from the specified team and returns it

FIXME: For now, you MUST specify an enemy team

If you specify choose closest, it will find only the closest enemy

If you specify checkVis, it will return and enemy that is visible

If you specify findPlayersFirst, it will try to find players first

You can mix and match any of those options (example: find closest visible players first)

FIXME: this should go through the snapshot and find the closest enemy
```
*/
/// Source: oracle/codemp/game/NPC_combat.c:1505
func NPC_PickEnemy(_ closestTo: Entity, _ enemyTeam: Int32, _ checkVis: Bool, _ findPlayersFirst: Bool, _ findClosest: Bool) -> Entity? {
    var num_choices: Int32 = 0
    var choice: [Int32] = [Int32](repeating: 0, count: 128)
    var newenemy: Entity? = nil
    var closestEnemy: Entity? = nil
    var entNum: Int32
    var diff = vec3_t()
    var relDist: Float
    var bestDist: Float = Float(Q3_INFINITE)
    var failed: Bool = false
    var visChecks: Int32 = (CHECK_360 | CHECK_FOV | CHECK_VISRANGE)
    var minVis: Int32 = VIS_FOV

    if enemyTeam == NPCTEAM_NEUTRAL {
        return nil
    }

    if NPCInfo!.behaviorState == BS_STAND_AND_SHOOT || NPCInfo!.behaviorState == BS_HUNT_AND_KILL {
        //Formations guys don't require inFov to pick up a target
        //These other behavior states are active battle states and should not
        //use FOV.  FOV checks are for enemies who are patrolling, guarding, etc.
        visChecks &= ~CHECK_FOV
        minVis = VIS_360
    }

    if findPlayersFirst {
        //try to find a player first
        newenemy = g_entities[0]
        if newenemy!.client != nil && !((newenemy!.flags & FL_NOTARGET) != 0) && !((newenemy!.s.eFlags & EF_NODRAW) != 0) {
            if newenemy!.health > 0 {
                if NPC_ValidEnemy(newenemy!) {
                    //FIXME:  check for range and FOV or vis?
                    if newenemy != NPC!.lastEnemy {
                        //Make sure we're not just going back and forth here
                        if trap_InPVS(newenemy!.r.currentOrigin, NPC!.r.currentOrigin) {
                            if NPCInfo!.behaviorState == BS_INVESTIGATE || NPCInfo!.behaviorState == BS_PATROL {
                                if NPC!.enemy == nil {
                                    if !InVisrange(newenemy!) {
                                        failed = true
                                    } else if NPC_CheckVisibility(newenemy!, CHECK_360 | CHECK_FOV | CHECK_VISRANGE) != VIS_FOV {
                                        failed = true
                                    }
                                }
                            }

                            if !failed {
                                diff = closestTo.r.currentOrigin - newenemy!.r.currentOrigin
                                relDist = VectorLengthSquared(diff)
                                if newenemy!.client!.hiddenDist > 0 {
                                    if relDist > newenemy!.client!.hiddenDist * newenemy!.client!.hiddenDist {
                                        //out of hidden range
                                        if VectorLengthSquared(newenemy!.client!.hiddenDir) != 0 {
                                            //They're only hidden from a certain direction, check
                                            var dot: Float
                                            VectorNormalize(&diff)
                                            dot = _DotProduct(newenemy!.client!.hiddenDir, diff)
                                            if Double(dot) > 0.5 {
                                                //I'm not looking in the right dir toward them to see them
                                                failed = true
                                            } else {
                                                // Port-note: Raven passes `"%s saw %s trying to hide - hiddenDir %s targetDir %s dot %f\n"` to `Debug_Printf`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                                                // Raven wrote: Debug_Printf(&debugNPCAI, DEBUG_LEVEL_INFO, "%s saw %s trying to hide - hiddenDir %s targetDir %s dot %f\n", NPC->targetname, newenemy->targetname, vtos(newenemy->client->hiddenDir), vtos(diff), dot )
                                                portMissing("NPC_PickEnemy", source: "oracle/codemp/game/NPC_combat.c:1505")
                                            }
                                        } else {
                                            failed = true
                                        }
                                    } else {
                                        // Port-note: Raven passes `"%s saw %s trying to hide - hiddenDist %f\n"` to `Debug_Printf`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                                        // Raven wrote: Debug_Printf(&debugNPCAI, DEBUG_LEVEL_INFO, "%s saw %s trying to hide - hiddenDist %f\n", NPC->targetname, newenemy->targetname, newenemy->client->hiddenDist )
                                        portMissing("NPC_PickEnemy", source: "oracle/codemp/game/NPC_combat.c:1505")
                                    }
                                }

                                if !failed {
                                    if findClosest {
                                        if relDist < bestDist {
                                            if !NPC_EnemyTooFar(newenemy!, relDist, false) {
                                                if checkVis {
                                                    if NPC_CheckVisibility(newenemy!, visChecks) == minVis {
                                                        bestDist = relDist
                                                        closestEnemy = newenemy
                                                    }
                                                } else {
                                                    bestDist = relDist
                                                    closestEnemy = newenemy
                                                }
                                            }
                                        }
                                    } else if !NPC_EnemyTooFar(newenemy!, 0, false) {
                                        if checkVis {
                                            if NPC_CheckVisibility(newenemy!, CHECK_360 | CHECK_FOV | CHECK_VISRANGE) == VIS_FOV {
                                                choice[num_choices] = newenemy!.s.number
                                                num_choices += 1
                                            }
                                        } else {
                                            choice[num_choices] = newenemy!.s.number
                                            num_choices += 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    if findClosest && closestEnemy != nil {
        return closestEnemy
    }

    if num_choices != 0 {
        return g_entities[choice[rand() % num_choices]]
    }

    /*
    //FIXME: used to have an option to look *only* for the player... now...?  Still need it?
    if ( enemyTeam == TEAM_PLAYER )
    {//couldn't find the player
    return NULL;
    }
    */

    num_choices = 0
    bestDist = Float(Q3_INFINITE)
    closestEnemy = nil

    entNum = 0
    while entNum < level.num_entities {
        newenemy = g_entities[entNum]

        if newenemy != NPC && newenemy!.client != nil && !((newenemy!.flags & FL_NOTARGET) != 0) && !((newenemy!.s.eFlags & EF_NODRAW) != 0) {
            if newenemy!.health > 0 {
                if (newenemy!.client != nil && NPC_ValidEnemy(newenemy!)) || (newenemy!.client == nil && newenemy!.alliedTeam == enemyTeam) {
                    //FIXME:  check for range and FOV or vis?
                    if NPC!.client!.playerTeam == NPCTEAM_PLAYER && enemyTeam == NPCTEAM_PLAYER {
                        //player allies turning on ourselves?  How?
                        if newenemy!.s.number != 0 {
                            //only turn on the player, not other player allies
                            entNum += 1
                            continue
                        }
                    }

                    if newenemy != NPC!.lastEnemy {
                        //Make sure we're not just going back and forth here
                        if !trap_InPVS(newenemy!.r.currentOrigin, NPC!.r.currentOrigin) {
                            entNum += 1
                            continue
                        }

                        if NPCInfo!.behaviorState == BS_INVESTIGATE || NPCInfo!.behaviorState == BS_PATROL {
                            if NPC!.enemy == nil {
                                if !InVisrange(newenemy!) {
                                    entNum += 1
                                    continue
                                } else if NPC_CheckVisibility(newenemy!, CHECK_360 | CHECK_FOV | CHECK_VISRANGE) != VIS_FOV {
                                    entNum += 1
                                    continue
                                }
                            }
                        }

                        diff = closestTo.r.currentOrigin - newenemy!.r.currentOrigin
                        relDist = VectorLengthSquared(diff)
                        if newenemy!.client != nil && newenemy!.client!.hiddenDist > 0 {
                            if relDist > newenemy!.client!.hiddenDist * newenemy!.client!.hiddenDist {
                                //out of hidden range
                                if VectorLengthSquared(newenemy!.client!.hiddenDir) != 0 {
                                    //They're only hidden from a certain direction, check
                                    var dot: Float

                                    VectorNormalize(&diff)
                                    dot = _DotProduct(newenemy!.client!.hiddenDir, diff)
                                    if Double(dot) > 0.5 {
                                        //I'm not looking in the right dir toward them to see them
                                        entNum += 1
                                        continue
                                    } else {
                                        // Port-note: Raven passes `"%s saw %s trying to hide - hiddenDir %s targetDir %s dot %f\n"` to `Debug_Printf`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                                        // Raven wrote: Debug_Printf(&debugNPCAI, DEBUG_LEVEL_INFO, "%s saw %s trying to hide - hiddenDir %s targetDir %s dot %f\n", NPC->targetname, newenemy->targetname, vtos(newenemy->client->hiddenDir), vtos(diff), dot )
                                        portMissing("NPC_PickEnemy", source: "oracle/codemp/game/NPC_combat.c:1505")
                                    }
                                } else {
                                    entNum += 1
                                    continue
                                }
                            } else {
                                // Port-note: Raven passes `"%s saw %s trying to hide - hiddenDist %f\n"` to `Debug_Printf`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                                // Raven wrote: Debug_Printf(&debugNPCAI, DEBUG_LEVEL_INFO, "%s saw %s trying to hide - hiddenDist %f\n", NPC->targetname, newenemy->targetname, newenemy->client->hiddenDist )
                                portMissing("NPC_PickEnemy", source: "oracle/codemp/game/NPC_combat.c:1505")
                            }
                        }

                        if findClosest {
                            if relDist < bestDist {
                                if !NPC_EnemyTooFar(newenemy!, relDist, false) {
                                    if checkVis {
                                        //FIXME: NPCs need to be able to pick up other NPCs behind them,
                                        //but for now, commented out because it was picking up enemies it shouldn't
                                        //if ( NPC_CheckVisibility ( newenemy, CHECK_360|CHECK_VISRANGE ) >= VIS_360 )
                                        if NPC_CheckVisibility(newenemy!, visChecks) == minVis {
                                            bestDist = relDist
                                            closestEnemy = newenemy
                                        }
                                    } else {
                                        bestDist = relDist
                                        closestEnemy = newenemy
                                    }
                                }
                            }
                        } else if !NPC_EnemyTooFar(newenemy!, 0, false) {
                            if checkVis {
                                //if( NPC_CheckVisibility ( newenemy, CHECK_360|CHECK_FOV|CHECK_VISRANGE ) == VIS_FOV )
                                if NPC_CheckVisibility(newenemy!, CHECK_360 | CHECK_VISRANGE) >= VIS_360 {
                                    choice[num_choices] = newenemy!.s.number
                                    num_choices += 1
                                }
                            } else {
                                choice[num_choices] = newenemy!.s.number
                                num_choices += 1
                            }
                        }
                    }
                }
            }
        }
        entNum += 1
    }


    if findClosest {
        //FIXME: you can pick up an enemy around a corner this way.
        return closestEnemy
    }

    if num_choices == 0 {
        return nil
    }

    return g_entities[choice[rand() % num_choices]]
}

/// Source: oracle/codemp/game/NPC_combat.c:1804
func NPC_PickAlly(_ facingEachOther: Bool, _ range: Float, _ ignoreGroup: Bool, _ movingOnly: Bool) -> Entity? {
    var ally: Entity? = nil
    var closestAlly: Entity? = nil
    var entNum: Int32
    var diff = vec3_t()
    var relDist: Float
    var bestDist: Float = range

    entNum = 0
    while entNum < level.num_entities {
        ally = g_entities[entNum]

        if ally!.client != nil {
            if ally!.health > 0 {
                if ally!.client != nil && (ally!.client!.playerTeam == NPC!.client!.playerTeam || NPC!.client!.playerTeam == NPCTEAM_ENEMY) {
                    //if on same team or if player is disguised as your team
                    if ignoreGroup {
                        if ally == NPC!.client!.leader {
                            //reject
                            entNum += 1
                            continue
                        }
                        if ally!.client != nil && ally!.client!.leader != nil && ally!.client!.leader == NPC {
                            //reject
                            entNum += 1
                            continue
                        }
                    }

                    if !trap_InPVS(ally!.r.currentOrigin, NPC!.r.currentOrigin) {
                        entNum += 1
                        continue
                    }

                    if movingOnly && ally!.client != nil && NPC!.client != nil {
                        //They have to be moving relative to each other
                        if DistanceSquared(ally!.client!.ps.velocity, NPC!.client!.ps.velocity) == 0 {
                            entNum += 1
                            continue
                        }
                    }

                    diff = NPC!.r.currentOrigin - ally!.r.currentOrigin
                    relDist = VectorNormalize(&diff)
                    if relDist < bestDist {
                        if facingEachOther {
                            var vf = vec3_t()
                            var dot: Float

                            // Raven passes NULL for the `right` and `up` outputs, and the callee skips the write to each.
                            var scratchRight = vec3_t()
                            var scratchUp = vec3_t()
                            AngleVectors(ally!.client!.ps.viewangles, &vf, &scratchRight, &scratchUp)
                            VectorNormalize(&vf)
                            dot = _DotProduct(diff, vf)

                            if Double(dot) < 0.5 {
                                //Not facing in dir to me
                                entNum += 1
                                continue
                            }
                            //He's facing me, am I facing him?
                            // Raven passes NULL for the `right` and `up` outputs, and the callee skips the write to each.
                            var scratchRight2 = vec3_t()
                            var scratchUp2 = vec3_t()
                            AngleVectors(NPC!.client!.ps.viewangles, &vf, &scratchRight2, &scratchUp2)
                            VectorNormalize(&vf)
                            dot = _DotProduct(diff, vf)

                            if Double(dot) > -0.5 {
                                //I'm not facing opposite of dir to me
                                entNum += 1
                                continue
                            }
                            //I am facing him
                        }

                        if NPC_CheckVisibility(ally!, CHECK_360 | CHECK_VISRANGE) >= VIS_360 {
                            bestDist = relDist
                            closestAlly = ally
                        }
                    }
                }
            }
        }
        entNum += 1
    }


    return closestAlly
}

/// Source: oracle/codemp/game/NPC_combat.c:1895
func NPC_CheckEnemy(_ findNew: Bool, _ tooFarOk: Bool, _ setEnemy: Bool) -> Entity? {
    var forcefindNew: Bool = false
    var closestTo: Entity?
    var newEnemy: Entity? = nil
    //FIXME: have a "NPCInfo->persistance" we can set to determine how long to try to shoot
    //someone we can't hit?  Rather than hard-coded 10?

    //FIXME they shouldn't recognize enemy's death instantly

    //TEMP FIX:
    //if(NPC->enemy->client)
    //{
    //	NPC->enemy->health = NPC->enemy->client->ps.stats[STAT_HEALTH];
    //}

    if NPC!.enemy != nil {
        if !NPC!.enemy!.inuse {
            if setEnemy {
                G_ClearEnemy(NPC!)
            }
        }
    }

    //if ( NPC->svFlags & SVF_IGNORE_ENEMIES )
    if 0 != 0 {
        //We're ignoring all enemies for now
        if setEnemy {
            G_ClearEnemy(NPC!)
        }
        return nil
    }

    //rwwFIXMEFIXME: support for this flag
    /*
    if ( NPC->svFlags & SVF_LOCKEDENEMY )
    {//keep this enemy until dead
    if ( NPC->enemy )
    {
    if ( (!NPC->NPC && !(NPC->svFlags & SVF_NONNPC_ENEMY) ) || NPC->enemy->health > 0 )
    {//Enemy never had health (a train or info_not_null, etc) or did and is now dead (NPCs, turrets, etc)
    return NULL;
    }
    }
    NPC->svFlags &= ~SVF_LOCKEDENEMY;
    }
    */

    if NPC!.enemy != nil {
        if NPC_EnemyTooFar(NPC!.enemy!, 0, false) {
            if findNew {
                //See if there is a close one and take it if so, else keep this one
                forcefindNew = true
            } else if !tooFarOk {
                if setEnemy {
                    G_ClearEnemy(NPC!)
                }
            }
        } else if !trap_InPVS(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin) {
            //FIXME: should this be a line-of site check?
            //FIXME: a lot of things check PVS AGAIN when deciding whether
            //or not to shoot, redundant!
            //Should we lose the enemy?
            //FIXME: if lose enemy, run lostenemyscript
            if NPC!.enemy!.client != nil && NPC!.enemy!.client!.hiddenDist != 0 {
                //He ducked into shadow while we weren't looking
                //Drop enemy and see if we should search for him
                NPC_LostEnemyDecideChase()
            } else {
                //If we're not chasing him, we need to lose him
                //NOTE: since we no longer have bStates, really, this logic doesn't work, so never give him up

                /*
                switch( NPCInfo->behaviorState )
                {
                case BS_HUNT_AND_KILL:
                //Okay to lose PVS, we're chasing them
                break;
                case BS_RUN_AND_SHOOT:
                //FIXME: only do this if !(NPCInfo->scriptFlags&SCF_CHASE_ENEMY)
                //If he's not our goalEntity, we're running somewhere else, so lose him
                if ( NPC->enemy != NPCInfo->goalEntity )
                {
                G_ClearEnemy( NPC );
                }
                break;
                default:
                //We're not chasing him, so lose him as an enemy
                G_ClearEnemy( NPC );
                break;
                }
                */
            }
        }
    }

    if NPC!.enemy != nil {
        if NPC!.enemy!.health <= 0 || (NPC!.enemy!.flags & FL_NOTARGET) != 0 {
            if setEnemy {
                G_ClearEnemy(NPC!)
            }
        }
    }

    closestTo = NPC
    //FIXME: check your defendEnt, if you have one, see if their enemy is different
    //than yours, or, if they don't have one, pick the closest enemy to THEM?
    if NPCInfo!.defendEnt != nil {
        //Trying to protect someone
        if NPCInfo!.defendEnt!.health > 0 {
            //Still alive, We presume we're close to them, navigation should handle this?
            if NPCInfo!.defendEnt!.enemy != nil {
                //They were shot or acquired an enemy
                if NPC!.enemy != NPCInfo!.defendEnt!.enemy {
                    //They have a different enemy, take it!
                    newEnemy = NPCInfo!.defendEnt!.enemy
                    if setEnemy {
                        G_SetEnemy(NPC!, NPCInfo!.defendEnt!.enemy!)
                    }
                }
            } else if NPC!.enemy == nil {
                //We don't have an enemy, so find closest to defendEnt
                closestTo = NPCInfo!.defendEnt
            }
        }
    }

    if NPC!.enemy == nil || (NPC!.enemy != nil && NPC!.enemy!.health <= 0) || forcefindNew {
        //FIXME: NPCs that are moving after an enemy should ignore the can't hit enemy counter- that should only be for NPCs that are standing still
        //NOTE: cantHitEnemyCounter >= 100 means we couldn't hit enemy for a full
        //	10 seconds, so give up.  This means even if we're chasing him, we would
        //	try to find another enemy after 10 seconds (assuming the cantHitEnemyCounter
        //	is allowed to increment in a chasing bState)
        var foundenemy: Bool = false

        if !findNew {
            if setEnemy {
                NPC!.lastEnemy = NPC!.enemy
                G_ClearEnemy(NPC!)
            }
            return nil
        }

        //If enemy dead or unshootable, look for others on out enemy's team
        if NPC!.client!.enemyTeam != NPCTEAM_NEUTRAL {
            //NOTE:  this only checks vis if can't hit enemy for 10 tries, which I suppose
            //			means they need to find one that in more than just PVS
            //newenemy = NPC_PickEnemy( closestTo, NPC->client->enemyTeam, (NPC->cantHitEnemyCounter > 10), qfalse, qtrue );//3rd parm was (NPC->enemyTeam == TEAM_STARFLEET)
            //For now, made it so you ALWAYS have to check VIS
            newEnemy = NPC_PickEnemy(closestTo!, NPC!.client!.enemyTeam, true, false, true) //3rd parm was (NPC->enemyTeam == TEAM_STARFLEET)
            if newEnemy != nil {
                foundenemy = true
                if setEnemy {
                    G_SetEnemy(NPC!, newEnemy!)
                }
            }
        }

        if !forcefindNew {
            if !foundenemy {
                if setEnemy {
                    NPC!.lastEnemy = NPC!.enemy
                    G_ClearEnemy(NPC!)
                }
            }

            NPC!.cantHitEnemyCounter = 0
        }
        //FIXME: if we can't find any at all, go into INdependant NPC AI, pursue and kill
    }

    if NPC!.enemy != nil && NPC!.enemy!.client != nil {
        if NPC!.enemy!.client!.playerTeam != 0 {
            //			assert( NPC->client->playerTeam != NPC->enemy->client->playerTeam);
            if NPC!.client!.playerTeam != NPC!.enemy!.client!.playerTeam {
                NPC!.client!.enemyTeam = NPC!.enemy!.client!.playerTeam
            }
        }
    }
    return newEnemy
}

/// Source: oracle/codemp/game/NPC_combat.c:2110
func NPC_ClearShot(_ ent: Entity) -> Bool {
    var muzzle = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in

        if (NPC == nil) || (ent == nil) {
            return false
        }

        CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)

        // add aim error
        // use weapon instead of specific npc types, although you could add certain npc classes if you wanted
        //	if ( NPC->client->playerTeam == TEAM_SCAVENGERS )
        if NPC!.s.weapon == WP_BLASTER {
            var mins = vec3_t(-2, -2, -2)
            var maxs = vec3_t(2, 2, 2)

            trap_Trace(tr, muzzle, mins, maxs, ent.r.currentOrigin, NPC!.s.number, MASK_SHOT)
        } else {
            // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
            portMissing("NPC_ClearShot", source: "oracle/codemp/game/NPC_combat.c:2110")
            // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
            portMissing("NPC_ClearShot", source: "oracle/codemp/game/NPC_combat.c:2110")
            trap_Trace(tr, muzzle, vec3_origin, vec3_origin, ent.r.currentOrigin, NPC!.s.number, MASK_SHOT)
        }

        if tr.startsolid != 0 || tr.allsolid != 0 {
            return false
        }

        if tr.entityNum == ent.s.number {
            return true
        }

        return false
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:2152
func NPC_ShotEntity(_ ent: Entity, _ impactPos: inout JKAShared.vec3_t) -> Int32 {
    var muzzle = vec3_t()
    var targ = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        if (NPC == nil) || (ent == nil) {
            return 0
        }

        if NPC!.s.weapon == WP_THERMAL {
            //thermal aims from slightly above head
            //FIXME: what about low-angle shots, rolling the thermal under something?
            var angles = vec3_t()
            var forward = vec3_t()
            var end = vec3_t()

            CalcEntitySpot(NPC!, SPOT_HEAD, &muzzle)
            angles = vec3_t(0, NPC!.client!.ps.viewangles[1], 0)
            // Raven passes NULL for the `right` and `up` outputs, and the callee skips the write to each.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(angles, &forward, &scratchRight, &scratchUp)
            _VectorMA(muzzle, 8, forward, &end)
            end[2] += 24
            trap_Trace(tr, muzzle, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SHOT)
            muzzle = tr.endpos
        } else {
            CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)
        }
        CalcEntitySpot(ent, SPOT_CHEST, &targ)

        // add aim error
        // use weapon instead of specific npc types, although you could add certain npc classes if you wanted
        //	if ( NPC->client->playerTeam == TEAM_SCAVENGERS )
        if NPC!.s.weapon == WP_BLASTER {
            var mins = vec3_t(-2, -2, -2)
            var maxs = vec3_t(2, 2, 2)

            trap_Trace(tr, muzzle, mins, maxs, targ, NPC!.s.number, MASK_SHOT)
        } else {
            // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
            portMissing("NPC_ShotEntity", source: "oracle/codemp/game/NPC_combat.c:2152")
            // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
            portMissing("NPC_ShotEntity", source: "oracle/codemp/game/NPC_combat.c:2152")
            trap_Trace(tr, muzzle, vec3_origin, vec3_origin, targ, NPC!.s.number, MASK_SHOT)
        }
        //FIXME: if using a bouncing weapon like the bowcaster, should we check the reflection of the wall, too?
        //they want to know *where* the hit would be, too
        impactPos = tr.endpos
        /* // NPCs should be able to shoot even if the muzzle would be inside their target
        if ( tr.startsolid || tr.allsolid )
        {
        return ENTITYNUM_NONE;
        }
        */
        return tr.entityNum
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:2208
func NPC_EvaluateShot(_ hit: Int32, _ glassOK: Bool) -> Bool {
    if NPC!.enemy == nil {
        return false
    }

    if hit == NPC!.enemy!.s.number || (g_entities[hit] != nil && (g_entities[hit].r.svFlags & SVF_GLASS_BRUSH) != 0) {
        //can hit enemy or will hit glass, so shoot anyway
        return true
    }
    return false
}

/// Source: oracle/codemp/game/NPC_combat.c:2228
func NPC_CheckAttack(_ scale: Float) -> Bool {
    // Raven assigns his own `scale` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var scale = scale
    if scale == 0 {
        scale = 1.0
    }

    if (Float(NPCInfo!.stats.aggression)) * scale < flrand(0, 4) {
        return false
    }

    if NPCInfo!.shotTime > level.time {
        return false
    }

    return true
}

/// Source: oracle/codemp/game/NPC_combat.c:2250
func NPC_CheckDefend(_ scale: Float) -> Bool {
    // Raven assigns his own `scale` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var scale = scale
    if scale == 0 {
        scale = 1.0
    }

    // The SDK also declares `random`, so the call names the bg module.
    if Float((NPCInfo!.stats.evasion)) > JKAMP_BG.random() * 4 * scale {
        return true
    }

    return false
}

//NOTE: BE SURE TO CHECK PVS BEFORE THIS!
/// Source: oracle/codemp/game/NPC_combat.c:2263
func NPC_CheckCanAttack(_ attack_scale: Float, _ stationary: Bool) -> Bool {
    var delta = vec3_t()
    var forward = vec3_t()
    var angleToEnemy = vec3_t()
    var hitspot = vec3_t()
    var muzzle = vec3_t()
    var diff = vec3_t()
    var enemy_org = vec3_t()
    var distanceToEnemy: Float = 0
    var attack_ok: Bool = false
    //	qboolean	duck_ok = qfalse;
    var dead_on: Bool = false
    var aim_off: Float = 0
    let max_aim_off: Float = 128 - (16 * Float(NPCInfo!.stats.aim))
    // Raven assigns his own `attack_scale` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var attack_scale = attack_scale
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var traceEnt: Entity? = nil

        if (NPC!.enemy!.flags & FL_NOTARGET) != 0 {
            return false
        }

        //FIXME: only check to see if should duck if that provides cover from the
        //enemy!!!
        if attack_scale == 0 {
            attack_scale = 1.0
        }
        //Yaw to enemy
        CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &enemy_org)
        NPC_AimWiggle(&enemy_org)

        CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)

        delta = enemy_org - muzzle
        vectoangles(delta, &angleToEnemy)
        distanceToEnemy = VectorNormalize(&delta)

        NPC!.NPC!.desiredYaw = angleToEnemy[YAW]
        NPC_UpdateFiringAngles(false, true)

        if NPC_EnemyTooFar(NPC!.enemy!, distanceToEnemy * distanceToEnemy, true) {
            //Too far away?  Do not attack
            return false
        }

        if client!.ps.weaponTime > 0 {
            //already waiting for a shot to fire
            NPC!.NPC!.desiredPitch = angleToEnemy[PITCH]
            NPC_UpdateFiringAngles(true, false)
            return false
        }

        if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 {
            return false
        }

        NPCInfo!.enemyLastVisibility = enemyVisibility
        //See if they're in our FOV and we have a clear shot to them
        enemyVisibility = NPC_CheckVisibility(NPC!.enemy!, CHECK_360 | CHECK_FOV) ////CHECK_PVS|

        if enemyVisibility >= VIS_FOV {
            //He's in our FOV

            attack_ok = true
            //CalcEntitySpot( NPC->enemy, SPOT_HEAD, enemy_head);

            //Check to duck
            if NPC!.enemy!.client != nil {
                if NPC!.enemy!.enemy == NPC {
                    if (NPC!.enemy!.client!.buttons & BUTTON_ATTACK) != 0 {
                        //FIXME: determine if enemy fire angles would hit me or get close
                        if NPC_CheckDefend(1.0) {
                            //duck and don't shoot
                            attack_ok = false
                            ucmd.upmove = -127
                        }
                    }
                }
            }

            if attack_ok {
                //are we gonna hit him
                //NEW: use actual forward facing
                // Raven passes NULL for the `right` and `up` outputs, and the callee skips the write to each.
                var scratchRight = vec3_t()
                var scratchUp = vec3_t()
                AngleVectors(client!.ps.viewangles, &forward, &scratchRight, &scratchUp)
                _VectorMA(muzzle, distanceToEnemy, forward, &hitspot)
                // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                portMissing("NPC_CheckCanAttack", source: "oracle/codemp/game/NPC_combat.c:2263")
                // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                portMissing("NPC_CheckCanAttack", source: "oracle/codemp/game/NPC_combat.c:2263")
                trap_Trace(tr, muzzle, vec3_origin, vec3_origin, hitspot, NPC!.s.number, MASK_SHOT)
                ShotThroughGlass(tr, NPC!.enemy!, hitspot, MASK_SHOT)
                /*
                //OLD: trace regardless of facing
                trap_Trace ( &tr, muzzle, NULL, NULL, enemy_org, NPC->s.number, MASK_SHOT );
                ShotThroughGlass(&tr, NPC->enemy, enemy_org, MASK_SHOT);
                */

                traceEnt = g_entities[tr.entityNum]

                /*
                if( traceEnt != NPC->enemy &&//FIXME: if someone on our team is in the way, suggest that they duck if possible
                (!traceEnt || !traceEnt->client || !NPC->client->enemyTeam || NPC->client->enemyTeam != traceEnt->client->playerTeam) )
                {//no, so shoot for somewhere between the head and torso
                //NOTE: yes, I know this looks weird, but it works
                enemy_org[0] += 0.3*Q_flrand(NPC->enemy->r.mins[0], NPC->enemy->r.maxs[0]);
                enemy_org[1] += 0.3*Q_flrand(NPC->enemy->r.mins[1], NPC->enemy->r.maxs[1]);
                enemy_org[2] -= NPC->enemy->r.maxs[2]*Q_flrand(0.0f, 1.0f);

                attack_scale *= 0.75;
                trap_Trace ( &tr, muzzle, NULL, NULL, enemy_org, NPC->s.number, MASK_SHOT );
                ShotThroughGlass(&tr, NPC->enemy, enemy_org, MASK_SHOT);
                traceEnt = &g_entities[tr.entityNum];
                }
                */

                hitspot = tr.endpos

                if traceEnt == NPC!.enemy || (traceEnt!.client != nil && NPC!.client!.enemyTeam != 0 && NPC!.client!.enemyTeam == traceEnt!.client!.playerTeam) {
                    dead_on = true
                } else {
                    attack_scale = Float(Double(attack_scale) * 0.5)
                    if NPC!.client!.playerTeam != 0 {
                        if traceEnt != nil && traceEnt!.client != nil && traceEnt!.client!.playerTeam != 0 {
                            if NPC!.client!.playerTeam == traceEnt!.client!.playerTeam {
                                //Don't shoot our own team
                                attack_ok = false
                            }
                        }
                    }
                }
            }

            if attack_ok {
                //ok, now adjust pitch aim
                delta = hitspot - muzzle
                vectoangles(delta, &angleToEnemy)
                NPC!.NPC!.desiredPitch = angleToEnemy[PITCH]
                NPC_UpdateFiringAngles(true, false)

                if !dead_on {
                    //We're not going to hit him directly, try a suppressing fire
                    //see if where we're going to shoot is too far from his origin
                    if traceEnt != nil && (traceEnt!.health <= 30 || EntIsGlass(traceEnt!)) {
                        //easy to kill - go for it
                        //if(traceEnt->die == ExplodeDeath_Wait && traceEnt->splashDamage)
                        if 0 != 0 {
                            //going to explode, don't shoot if close to self
                            diff = NPC!.r.currentOrigin - traceEnt!.r.currentOrigin
                            if VectorLengthSquared(diff) < traceEnt!.splashRadius * traceEnt!.splashRadius {
                                //Too close to shoot!
                                attack_ok = false
                            } else {
                                //Hey, it might kill him, do it!
                                attack_scale *= 2 //
                            }
                        }
                    } else {
                        // Raven passes NULL for the `right` and `up` outputs, and the callee skips the write to each.
                        var scratchRight2 = vec3_t()
                        var scratchUp2 = vec3_t()
                        AngleVectors(client!.ps.viewangles, &forward, &scratchRight2, &scratchUp2)
                        _VectorMA(muzzle, distanceToEnemy, forward, &hitspot)
                        diff = hitspot - enemy_org
                        aim_off = VectorLength(diff)
                        // The SDK also declares `random`, so the call names the bg module.
                        if aim_off > JKAMP_BG.random() * max_aim_off {
                            attack_scale = Float(Double(attack_scale) * 0.75)
                            //see if where we're going to shoot is too far from his head
                            diff = hitspot - enemy_org
                            aim_off = VectorLength(diff)
                            // The SDK also declares `random`, so the call names the bg module.
                            if aim_off > JKAMP_BG.random() * max_aim_off {
                                attack_ok = false
                            }
                        }
                        attack_scale *= (max_aim_off - aim_off + 1) / max_aim_off
                    }
                }
            }
        } else {
            //Update pitch anyway
            NPC!.NPC!.desiredPitch = angleToEnemy[PITCH]
            NPC_UpdateFiringAngles(true, false)
        }

        if attack_ok {
            if NPC_CheckAttack(attack_scale) {
                //check aggression to decide if we should shoot
                enemyVisibility = VIS_SHOOT
                WeaponThink(true)
            } else {
                attack_ok = false
            }
        }

        return attack_ok
    }
}

//========================================================================================
//OLD id-style hunt and kill
//========================================================================================
/**
```
IdealDistance

determines what the NPC's ideal distance from it's enemy should
be in the current situation
```
*/
/// Source: oracle/codemp/game/NPC_combat.c:2475
func IdealDistance(_ `self`: Entity) -> Float {
    var ideal: Float

    ideal = Float(225 - 20 * NPCInfo!.stats.aggression)
    switch NPC!.s.weapon {
    case WP_ROCKET_LAUNCHER:
        ideal += 200

    case WP_THERMAL:
        ideal += 50
        /*	case WP_TRICORDER:
        ideal = 0;
        break;
        */
        //	case WP_BLASTER_PISTOL:

    default:
        break
    }

    return ideal
}

/// Source: oracle/codemp/game/NPC_combat.c:2516
func SP_point_combat(_ `self`: Entity) {
    if level.numCombatPoints >= MAX_COMBAT_POINTS {
        Com_Printf(S_COLOR_RED + "ERROR:  Too many combat points, limit is %d\n", MAX_COMBAT_POINTS)
        G_FreeEntity(`self`)
        return
    }

    `self`.s.origin[2] = Float(Double(`self`.s.origin[2]) + 0.125)
    G_SetOrigin(`self`, &`self`.s.origin)
    trap_LinkEntity(`self`)

    if G_CheckInSolid(`self`, true) {
        Com_Printf(S_COLOR_RED + "ERROR: combat point at %s in solid!\n", vtos(`self`.r.currentOrigin))
    }

    level.combatPoints[level.numCombatPoints].origin = `self`.r.currentOrigin

    level.combatPoints[level.numCombatPoints].flags = `self`.spawnflags
    level.combatPoints[level.numCombatPoints].occupied = false

    level.numCombatPoints += 1

    G_FreeEntity(`self`)
}

/// Source: oracle/codemp/game/NPC_combat.c:2548
func CP_FindCombatPointWaypoints() {
    var i: Int32

    i = 0
    while i < level.numCombatPoints {
        level.combatPoints[i].waypoint = NAV_FindClosestWaypointForPoint2(&level.combatPoints[i].origin)
        if level.combatPoints[i].waypoint == WAYPOINT_NONE {
            Com_Printf(S_COLOR_RED + "ERROR: Combat Point at %s has no waypoint!\n", vtos(level.combatPoints[i].origin))
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:2575
private func NPC_CollectCombatPoints(_ origin: JKAShared.vec3_t, _ radius: Float, _ points: Slots<CombatPt>, _ flags: Int32) -> Int32 {
    let radiusSqr: Float = (radius * radius)
    var distance: Float
    var bestDistance: Float = Float(Q3_INFINITE)
    var bestPoint: Int32 = 0
    var numPoints: Int32 = 0
    var i: Int32

    //Collect all nearest
    i = 0
    while i < level.numCombatPoints {
        if numPoints >= MAX_COMBAT_POINTS {
            break
        }

        //Must be vacant
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Bool' and 'Int'".
        // Raven wrote: if ( level.combatPoints[i].occupied == (int) qtrue ) continue
        portMissing("NPC_CollectCombatPoints", source: "oracle/codemp/game/NPC_combat.c:2575")

        //If we want a duck space, make sure this is one
        if (flags & CP_DUCK) != 0 && (level.combatPoints[i].flags & CPF_DUCK) != 0 {
            i += 1
            continue
        }

        //If we want a duck space, make sure this is one
        if (flags & CP_FLEE) != 0 && (level.combatPoints[i].flags & CPF_FLEE) != 0 {
            i += 1
            continue
        }

        ///Make sure this is an investigate combat point
        if (flags & CP_INVESTIGATE) != 0 && (level.combatPoints[i].flags & CPF_INVESTIGATE) != 0 {
            i += 1
            continue
        }

        //Squad points are only valid if we're looking for them
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'".
        // Raven wrote: if ( ( level.combatPoints[i].flags & CPF_SQUAD ) && ( ( flags & CP_SQUAD ) == qfalse ) ) continue
        portMissing("NPC_CollectCombatPoints", source: "oracle/codemp/game/NPC_combat.c:2575")

        if (flags & CP_NO_PVS) != 0 {
            //must not be within PVS of mu current origin
            if trap_InPVS(origin, level.combatPoints[i].origin) {
                i += 1
                continue
            }
        }

        if (flags & CP_HORZ_DIST_COLL) != 0 {
            distance = DistanceHorizontalSquared(origin, level.combatPoints[i].origin)
        } else {
            distance = DistanceSquared(origin, level.combatPoints[i].origin)
        }

        if distance < radiusSqr {
            if distance < bestDistance {
                bestDistance = distance
                bestPoint = numPoints
            }

            points[numPoints].dist = distance
            points[numPoints].index = i
            numPoints += 1
        }
        i += 1
    }

    return numPoints //bestPoint;
}

/// Source: oracle/codemp/game/NPC_combat.c:2657
func NPC_FindCombatPoint(_ position: JKAShared.vec3_t, _ avoidPosition: JKAShared.vec3_t, _ enemyPosition: JKAShared.vec3_t, _ flags: Int32, _ avoidDist: Float, _ ignorePoint: Int32) -> Int32 {
    // Port-note: A local `combatPt_t[512] points` the table has no type for.
    // Raven wrote: combatPt_t points[MAX_COMBAT_POINTS];
    portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
    var best: Int32 = -1
    var cost: Int32 = 0
    var bestCost: Int32 = Q3_INFINITE
    var waypoint: Int32 = WAYPOINT_NONE
    var dist: Float = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var collRad: Float = CP_COLLECT_RADIUS
        var numPoints: Int32 = 0
        var j: Int32 = 0
        var modifiedAvoidDist: Float = avoidDist

        if modifiedAvoidDist <= 0 {
            modifiedAvoidDist = Float(MIN_AVOID_DISTANCE_SQUARED)
        } else {
            modifiedAvoidDist *= modifiedAvoidDist
        }

        if (flags & CP_HAS_ROUTE) != 0 || (flags & CP_NEAREST) != 0 {
            //going to be doing macro nav tests
            if NPC!.waypoint == WAYPOINT_NONE {
                waypoint = NAV_GetNearestNode(NPC!, NPC!.lastWaypoint)
            } else {
                waypoint = NPC!.waypoint
            }
        }

        //Collect our nearest points
        if (flags & CP_NO_PVS) != 0 {
            //much larger radius since most will be dropped?
            collRad = CP_COLLECT_RADIUS * 4
        }
        // Port-note: A read of `points`, a local the draft left as a hole.
        // Raven wrote: numPoints = NPC_CollectCombatPoints( enemyPosition, collRad, points, flags )
        portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")


        j = 0
        while j < numPoints {
            //const int i = (*cpi).second;
            // Port-note: A read of `points`, a local the draft left as a hole.
            // Raven wrote: const int i = points[j].index;
            portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
            // Port-note: A read of `points`, a local the draft left as a hole.
            // Raven wrote: const float pdist = points[j].dist;
            portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")

            //Must not be one we want to ignore
            // Port-note: A read of `i`, a local the draft left as a hole.
            // Raven wrote: if ( i == ignorePoint ) continue
            portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")

            //FIXME: able to mark certain ones as too dangerous to go to for now?  Like a tripmine/thermal/detpack is near or something?
            //If we need a cover point, check this point
            // Port-note: A read of `i`, a local the draft left as a hole.
            // Raven wrote: if ( ( flags & CP_COVER ) && ( NPC_ClearLOS( level.combatPoints[i].origin, enemyPosition ) == qtrue ) )//Used to use NPC->enemy continue
            portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")

            //Need a clear LOS to our target... and be within shot range to enemy position (FIXME: make this a separate CS_ flag? and pass in a range?)
            if (flags & CP_CLEAR) != 0 {
                // Port-note: A read of `i`, a local the draft left as a hole.
                // Raven wrote: if ( NPC_ClearLOS3( level.combatPoints[i].origin, NPC->enemy ) == qfalse ) { continue; }
                portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                if NPC!.s.weapon == WP_THERMAL {
                    //horizontal
                    // Port-note: A read of `i`, a local the draft left as a hole.
                    // Raven wrote: dist = DistanceHorizontalSquared( level.combatPoints[i].origin, NPC->enemy->r.currentOrigin )
                    portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                } else {
                    //actual
                    // Port-note: A read of `i`, a local the draft left as a hole.
                    // Raven wrote: dist = DistanceSquared( level.combatPoints[i].origin, NPC->enemy->r.currentOrigin )
                    portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                }
                if dist > (NPCInfo!.stats.visrange * NPCInfo!.stats.visrange) {
                    j += 1
                    continue
                }
            }

            //Avoid this position?
            // Port-note: A read of `i`, a local the draft left as a hole.
            // Raven wrote: if ( ( flags & CP_AVOID ) && ( DistanceSquared( level.combatPoints[i].origin, position ) < modifiedAvoidDist ) )//was using MIN_AVOID_DISTANCE_SQUARED, not passed in modifiedAvoidDist continue
            portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")

            //Try to find a point closer to the enemy than where we are
            if (flags & CP_APPROACH_ENEMY) != 0 {
                if (flags & CP_HORZ_DIST_COLL) != 0 {
                    // Port-note: A read of `pdist`, a local the draft left as a hole.
                    // Raven wrote: if ( pdist > DistanceHorizontalSquared( position, enemyPosition ) ) { continue; }
                    portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                } else {
                    // Port-note: A read of `pdist`, a local the draft left as a hole.
                    // Raven wrote: if ( pdist > DistanceSquared( position, enemyPosition ) ) { continue; }
                    portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                }
            }
            //Try to find a point farther from the enemy than where we are
            if (flags & CP_RETREAT) != 0 {
                if (flags & CP_HORZ_DIST_COLL) != 0 {
                    // Port-note: A read of `pdist`, a local the draft left as a hole.
                    // Raven wrote: if ( pdist < DistanceHorizontalSquared( position, enemyPosition ) ) {//it's closer, don't use it continue; }
                    portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                } else {
                    // Port-note: A read of `pdist`, a local the draft left as a hole.
                    // Raven wrote: if ( pdist < DistanceSquared( position, enemyPosition ) ) {//it's closer, don't use it continue; }
                    portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                }
            }

            //We want a point on other side of the enemy from current pos
            if (flags & CP_FLANK) != 0 {
                var eDir2Me = vec3_t()
                var eDir2CP = vec3_t()
                var dot: Float = 0

                eDir2Me = position - enemyPosition
                VectorNormalize(&eDir2Me)

                // Port-note: A read of `i`, a local the draft left as a hole.
                // Raven wrote: VectorSubtract( level.combatPoints[i].origin, enemyPosition, eDir2CP )
                portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                VectorNormalize(&eDir2CP)

                dot = _DotProduct(eDir2Me, eDir2CP)

                //Not far enough behind enemy from current pos
                if Double(dot) >= 0.4 {
                    j += 1
                    continue
                }
            }

            //See if we're trying to avoid our enemy
            //FIXME: this needs to check for the waypoint you'll be taking to get to that combat point
            if (flags & CP_AVOID_ENEMY) != 0 {
                var eDir = vec3_t()
                var gDir = vec3_t()
                var wpOrg = vec3_t()
                var dot: Float = 0

                eDir = position - enemyPosition
                VectorNormalize(&eDir)

                /*
                NAV_FindClosestWaypointForEnt( NPC, level.combatPoints[i].waypoint );
                if ( NPC->waypoint != WAYPOINT_NONE && NPC->waypoint != level.combatPoints[i].waypoint )
                {
                trap_Nav_GetNodePosition( NPC->waypoint, wpOrg );
                }
                else
                */
                do {
                    // Port-note: A read of `i`, a local the draft left as a hole.
                    // Raven wrote: VectorCopy( level.combatPoints[i].origin, wpOrg )
                    portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
                }
                gDir = position - wpOrg
                VectorNormalize(&gDir)

                dot = _DotProduct(gDir, eDir)

                //Don't want to run at enemy
                if dot >= MIN_AVOID_DOT {
                    j += 1
                    continue
                }

                //Can't be too close to the enemy
                if DistanceSquared(wpOrg, enemyPosition) < modifiedAvoidDist {
                    j += 1
                    continue
                }
            }

            //Okay, now make sure it's not blocked
            // Port-note: A read of `i`, a local the draft left as a hole.
            // Raven wrote: trap_Trace( &tr, level.combatPoints[i].origin, NPC->r.mins, NPC->r.maxs, level.combatPoints[i].origin, NPC->s.number, NPC->clipmask )
            portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
            if tr.allsolid != 0 || tr.startsolid != 0 {
                j += 1
                continue
            }

            //we must have a route to the combat point
            if (flags & CP_HAS_ROUTE) != 0 {
                /*
                if ( level.combatPoints[i].waypoint == WAYPOINT_NONE )
                {
                level.combatPoints[i].waypoint = NAV_FindClosestWaypointForPoint( level.combatPoints[i].origin );
                }
                */

                // Port-note: A read of `i`, a local the draft left as a hole.
                // Raven wrote: if ( waypoint == WAYPOINT_NONE || level.combatPoints[i].waypoint == WAYPOINT_NONE || trap_Nav_GetBestNodeAltRoute2( waypoint, level.combatPoints[i].waypoint, NODE_NONE ) == WAYPOINT_NONE ) {//can't possibly have a route to any OR can't possibly have a route to this one OR don't have a route to this one if ( !NAV_ClearPathToPoint( NPC, NPC->r.mins, NPC->r.maxs, level.combatPoints[i].origin, NPC->clipmask, ENTITYNUM_NONE ) ) {//don't even have a clear straight path to this one continue; } }
                portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
            }

            //We want the one with the shortest path from current pos
            // Port-note: A read of `i`, a local the draft left as a hole.
            // Raven wrote: if ( flags & CP_NEAREST && waypoint != WAYPOINT_NONE && level.combatPoints[i].waypoint != WAYPOINT_NONE ) { cost = trap_Nav_GetPathCost( waypoint, level.combatPoints[i].waypoint ); if ( cost < bestCost ) { bestCost = cost; best = i; } continue; }
            portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")

            //we want the combat point closest to the enemy
            //if ( flags & CP_CLOSEST )
            //they are sorted by this distance, so the first one to get this far is the closest
            // Port-note: A read of `i`, a local the draft left as a hole.
            // Raven wrote: return i
            portMissing("NPC_FindCombatPoint", source: "oracle/codemp/game/NPC_combat.c:2657")
            j += 1
        }

        return best
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:2882
func NPC_FindSquadPoint(_ position: JKAShared.vec3_t) -> Int32 {
    var dist: Float
    var nearestDist: Float = Float(WORLD_SIZE) * Float(WORLD_SIZE)
    var nearestPoint: Int32 = -1
    var i: Int32

    //float			playerDist = DistanceSquared( g_entities[0].currentOrigin, NPC->r.currentOrigin );

    i = 0
    while i < level.numCombatPoints {
        //Squad points are only valid if we're looking for them
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'".
        // Raven wrote: if ( ( level.combatPoints[i].flags & CPF_SQUAD ) == qfalse ) continue
        portMissing("NPC_FindSquadPoint", source: "oracle/codemp/game/NPC_combat.c:2882")

        //Must be vacant
        if level.combatPoints[i].occupied == true {
            i += 1
            continue
        }

        dist = DistanceSquared(position, level.combatPoints[i].origin)

        //The point cannot take us past the player
        //if ( dist > ( playerDist * DotProduct( dirToPlayer, playerDir ) ) )	//FIXME: Retain this
        //	continue;

        //See if this is closer than the others
        if dist < nearestDist {
            nearestPoint = i
            nearestDist = dist
        }
        i += 1
    }

    return nearestPoint
}

/// Source: oracle/codemp/game/NPC_combat.c:2923
func NPC_ReserveCombatPoint(_ combatPointID: Int32) -> Bool {
    //Make sure it's valid
    if combatPointID > level.numCombatPoints {
        return false
    }

    //Make sure it's not already occupied
    if level.combatPoints[combatPointID].occupied {
        return false
    }

    //Reserve it
    level.combatPoints[combatPointID].occupied = true

    return true
}

/// Source: oracle/codemp/game/NPC_combat.c:2945
func NPC_FreeCombatPoint(_ combatPointID: Int32, _ failed: Bool) -> Bool {
    if failed {
        //remember that this one failed for us
        NPCInfo!.lastFailedCombatPoint = combatPointID
    }
    //Make sure it's valid
    if combatPointID > level.numCombatPoints {
        return false
    }

    //Make sure it's currently occupied
    if level.combatPoints[combatPointID].occupied == false {
        return false
    }

    //Free it
    level.combatPoints[combatPointID].occupied = false

    return true
}

/// Source: oracle/codemp/game/NPC_combat.c:2971
func NPC_SetCombatPoint(_ combatPointID: Int32) -> Bool {
    //Free a combat point if we already have one
    if NPCInfo!.combatPoint != -1 {
        NPC_FreeCombatPoint(NPCInfo!.combatPoint, false)
    }

    if NPC_ReserveCombatPoint(combatPointID) == false {
        return false
    }

    NPCInfo!.combatPoint = combatPointID

    return true
}

/// Source: oracle/codemp/game/NPC_combat.c:2988
func NPC_SearchForWeapons() -> Entity? {
    var foundIndex: Int32 = 0
    var bestFound: Entity? = nil
    var dist: Float
    var bestDist: Float = Float(Q3_INFINITE)
    var i: Int32
    //	for ( found = g_entities; found < &g_entities[globals.num_entities] ; found++)
    i = 0
    while i < level.num_entities {
        //		if ( !found->inuse )
        //		{
        //			continue;
        //		}
        if !g_entities[i].inuse {
            i += 1
            continue
        }

        foundIndex = i

        //FIXME: Also look for ammo_racks that have weapons on them?
        if g_entities[foundIndex].s.eType != ET_ITEM {
            i += 1
            continue
        }
        if g_entities[foundIndex].item!.giType != IT_WEAPON {
            i += 1
            continue
        }
        if (g_entities[foundIndex].s.eFlags & EF_NODRAW) != 0 {
            i += 1
            continue
        }
        if CheckItemCanBePickedUpByNPC(g_entities[foundIndex], NPC!) {
            if trap_InPVS(g_entities[foundIndex].r.currentOrigin, NPC!.r.currentOrigin) {
                dist = DistanceSquared(g_entities[foundIndex].r.currentOrigin, NPC!.r.currentOrigin)
                if dist < bestDist {
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "type 'Int32' cannot be used as a boolean; test for '== 0' instead"
                    portMissing("NPC_SearchForWeapons", source: "oracle/codemp/game/NPC_combat.c:2988")
                    // if !trap_Nav_GetBestPathBetweenEnts(NPC!, g_entities[foundIndex], NF_CLEAR_PATH)
                    //     || trap_Nav_GetBestNodeAltRoute2(NPC!.waypoint, g_entities[foundIndex].waypoint, NODE_NONE) == WAYPOINT_NONE {
                    //     //can't possibly have a route to any OR can't possibly have a route to this one OR don't have a route to this one
                    //     if NAV_ClearPathToPoint(NPC!, NPC!.r.mins, NPC!.r.maxs, g_entities[foundIndex].r.currentOrigin, NPC!.clipmask, ENTITYNUM_NONE) {
                    //         //have a clear straight path to this one
                    //         bestDist = dist
                    //         bestFound = g_entities[foundIndex]
                    //     }
                    // } else {
                    //     //can nav to it
                    //     bestDist = dist
                    //     bestFound = g_entities[foundIndex]
                    // }
                }
            }
        }
        i += 1
    }

    return bestFound
}

/// Source: oracle/codemp/game/NPC_combat.c:3047
func NPC_SetPickUpGoal(_ foundWeap: Entity) {
    var org = vec3_t()

    //NPCInfo->goalEntity = foundWeap;
    org = foundWeap.r.currentOrigin
    org[2] += 24 - (foundWeap.r.mins[2] * -1) //adjust the origin so that I am on the ground
    NPC_SetMoveGoal(NPC!, org, Int32(Double(foundWeap.r.maxs[0]) * 0.75), false, -1, foundWeap)
    NPCInfo!.tempGoal!.waypoint = foundWeap.waypoint
    NPCInfo!.tempBehavior = BS_DEFAULT
    NPCInfo!.squadState = SQUAD_TRANSITION
}

/// Source: oracle/codemp/game/NPC_combat.c:3060
func NPC_CheckGetNewWeapon() {
    if NPC!.s.weapon == WP_NONE && NPC!.enemy != nil {
        //if running away because dropped weapon...
        if NPCInfo!.goalEntity != nil && NPCInfo!.goalEntity == NPCInfo!.tempGoal && NPCInfo!.goalEntity!.enemy != nil && !NPCInfo!.goalEntity!.enemy!.inuse {
            //maybe was running at a weapon that was picked up
            NPCInfo!.goalEntity = nil
        }
        if TIMER_Done(NPC!, "panic") && NPCInfo!.goalEntity == nil {
            //need a weapon, any lying around?
            let foundWeap: Entity? = NPC_SearchForWeapons()
            if foundWeap != nil {
                //try to nav to it
                /*
                if ( !trap_Nav_GetBestPathBetweenEnts( NPC, foundWeap, NF_CLEAR_PATH )
                || trap_Nav_GetBestNodeAltRoute( NPC->waypoint, foundWeap->waypoint ) == WAYPOINT_NONE )
                {//can't possibly have a route to any OR can't possibly have a route to this one OR don't have a route to this one
                if ( !NAV_ClearPathToPoint( NPC, NPC->r.mins, NPC->r.maxs, foundWeap->r.currentOrigin, NPC->clipmask, ENTITYNUM_NONE ) )
                {//don't even have a clear straight path to this one
                }
                else
                {
                NPC_SetPickUpGoal( foundWeap );
                }
                }
                else
                */
                do {
                    NPC_SetPickUpGoal(foundWeap!)
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:3098
func NPC_AimAdjust(_ change: Int32) {
    if !TIMER_Exists(NPC!, "aimDebounce") {
        var debounce: Int32 = 500 + (3 - g_spskill.integer) * 100
        TIMER_Set(NPC!, "aimDebounce", Q_irand(debounce, debounce + 1000))
        //int debounce = 1000+(3-g_spskill.integer)*500;
        //TIMER_Set( NPC, "aimDebounce", Q_irand( debounce, debounce+2000 ) );
        return
    }
    if TIMER_Done(NPC!, "aimDebounce") {
        let debounce: Int32

        NPCInfo!.currentAim += change
        if NPCInfo!.currentAim > NPCInfo!.stats.aim {
            //can never be better than max aim
            NPCInfo!.currentAim = NPCInfo!.stats.aim
        } else if NPCInfo!.currentAim < -30 {
            //can never be worse than this
            NPCInfo!.currentAim = -30
        }

        //Com_Printf( "%s new aim = %d\n", NPC->NPC_type, NPCInfo->currentAim );

        debounce = 500 + (3 - g_spskill.integer) * 100
        TIMER_Set(NPC!, "aimDebounce", Q_irand(debounce, debounce + 1000))
        //int debounce = 1000+(3-g_spskill.integer)*500;
        //TIMER_Set( NPC, "aimDebounce", Q_irand( debounce, debounce+2000 ) );
    }
}

/// Source: oracle/codemp/game/NPC_combat.c:3131
func G_AimSet(_ `self`: Entity, _ aim: Int32) {
    if `self`.NPC != nil {
        let debounce: Int32

        `self`.NPC!.currentAim = aim
        //Com_Printf( "%s new aim = %d\n", self->NPC_type, self->NPC->currentAim );

        debounce = 500 + (3 - g_spskill.integer) * 100
        TIMER_Set(`self`, "aimDebounce", Q_irand(debounce, debounce + 1000))
        //	int debounce = 1000+(3-g_spskill.integer)*500;
        //	TIMER_Set( self, "aimDebounce", Q_irand( debounce,debounce+2000 ) );
    }
}
