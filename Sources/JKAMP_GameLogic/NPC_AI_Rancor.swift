import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:10
private let MIN_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:11
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:13
private let MAX_DISTANCE = 1024 as Int32

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:14
private let MAX_DISTANCE_SQR = (MAX_DISTANCE * MAX_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:16
private let LSTATE_CLEAR = 0 as Int32

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:17
private let LSTATE_WAITING = 1 as Int32

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:19
func Rancor_SetBolts(_ `self`: Entity) {
    if `self`.client != nil {
        let ri: RenderInfo? = `self`.client!.renderInfo
        ri!.handRBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*r_hand")
        ri!.handLBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_hand")
        ri!.headBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*head_eyes")
        ri!.torsoBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "jaw_bone")
    }
}

/**
```
-------------------------
NPC_Rancor_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Rancor.c:36
func NPC_Rancor_Precache() {
    var i: Int32
    i = 1
    while i < 3 {
        G_SoundIndex(va("sound/chars/rancor/snort_%d.wav", i))
        i += 1
    }
    G_SoundIndex("sound/chars/rancor/swipehit.wav")
    G_SoundIndex("sound/chars/rancor/chomp.wav")
}

/**
```
-------------------------
Rancor_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Rancor.c:53
func Rancor_Idle() {
    NPCInfo!.localState = LSTATE_CLEAR

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons &= ~BUTTON_WALKING
        NPC_MoveToGoal(true)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:66
func Rancor_CheckRoar(_ `self`: Entity) -> Bool {
    if `self`.wait == 0 {
        //haven't ever gotten mad yet
        `self`.wait = 1 //do this only once
        `self`.client!.ps.eFlags2 |= EF2_ALERTED
        NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_STAND1TO2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
        TIMER_Set(`self`, "rageTime", `self`.client!.ps.legsTimer)
        return true
    }
    return false
}

/**
```
-------------------------
Rancor_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Rancor.c:83
func Rancor_Patrol() {
    NPCInfo!.localState = LSTATE_CLEAR

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons &= ~BUTTON_WALKING
        NPC_MoveToGoal(true)
    } else {
        if TIMER_Done(NPC!, "patrolTime") {
            TIMER_Set(NPC!, "patrolTime", Int32(crandom() * 5000 + 5000))
        }
    }

    if NPC_CheckEnemyExt(true) == false {
        Rancor_Idle()
        return
    }
    Rancor_CheckRoar(NPC!)
    TIMER_Set(NPC!, "lookForNewEnemy", Q_irand(5000, 15000))
}

/**
```
-------------------------
Rancor_Move
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Rancor.c:115
func Rancor_Move(_ visible: Bool) {
    if NPCInfo!.localState != LSTATE_WAITING {
        NPCInfo!.goalEntity = NPC!.enemy
        if !NPC_MoveToGoal(true) {
            NPCInfo!.consecutiveBlockedMoves += 1
        } else {
            NPCInfo!.consecutiveBlockedMoves = 0
        }
        NPCInfo!.goalRadius = MAX_DISTANCE // just get us within combat range
    }
}

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:140
func Rancor_DropVictim(_ `self`: Entity) {
    //FIXME: if Rancor dies, it should drop its victim.
    //FIXME: if Rancor is removed, it must remove its victim.
    if `self`.activator != nil {
        if `self`.activator!.client != nil {
            `self`.activator!.client!.ps.eFlags2 &= ~EF2_HELD_BY_MONSTER
            `self`.activator!.client!.ps.hasLookTarget = false
            `self`.activator!.client!.ps.lookTarget = ENTITYNUM_NONE
            `self`.activator!.client!.ps.viewangles[ROLL] = 0
            SetClientViewAngle(`self`.activator!, `self`.activator!.client!.ps.viewangles)
            `self`.activator!.r.currentAngles[ROLL] = 0
            `self`.activator!.r.currentAngles[PITCH] = `self`.activator!.r.currentAngles[ROLL]
            G_SetAngles(`self`.activator!, `self`.activator!.r.currentAngles)
        }
        if `self`.activator!.health <= 0 {
            //if ( self->activator->s.number )
            do {
                //never free player
                if `self`.count == 1 {
                    //in my hand, just drop them
                    if `self`.activator!.client != nil {
                        `self`.activator!.client!.ps.torsoTimer = 0
                        `self`.activator!.client!.ps.legsTimer = `self`.activator!.client!.ps.torsoTimer
                        //FIXME: ragdoll?
                    }
                } else {
                    if `self`.activator!.client != nil {
                        `self`.activator!.client!.ps.eFlags |= EF_NODRAW //so his corpse doesn't drop out of me...
                    }
                    //G_FreeEntity( self->activator );
                }
            }
        } else {
            if `self`.activator!.NPC != nil {
                //start thinking again
                `self`.activator!.NPC!.nextBStateThink = level.time
            }
            //clear their anim and let them fall
            `self`.activator!.client!.ps.torsoTimer = 0
            `self`.activator!.client!.ps.legsTimer = `self`.activator!.client!.ps.torsoTimer
        }
        if `self`.enemy == `self`.activator {
            `self`.enemy = nil
        }
        `self`.activator = nil
    }
    `self`.count = 0 //drop him
}

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:196
func Rancor_Swing(_ tryGrab: Bool) {
    var radiusEntNums: [Int32] = [Int32](repeating: 0, count: 128)
    let numEnts: Int32
    let radius: Float = 88
    let radiusSquared: Float = (radius * radius)
    var i: Int32
    var boltOrg = vec3_t()

    numEnts = NPC_GetEntsNearBolt(&radiusEntNums, radius, NPC!.client!.renderInfo.handRBolt, &boltOrg)

    i = 0
    while i < numEnts {
        let radiusEnt: Entity? = g_entities[radiusEntNums[i]]
        if !radiusEnt!.inuse {
            i += 1
            continue
        }

        if radiusEnt == NPC {
            //Skip the rancor ent
            i += 1
            continue
        }

        if radiusEnt!.client == nil {
            //must be a client
            i += 1
            continue
        }

        if (radiusEnt!.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
            //can't be one already being held
            i += 1
            continue
        }

        if DistanceSquared(radiusEnt!.r.currentOrigin, boltOrg) <= radiusSquared {
            if tryGrab && NPC!.count != 1 && radiusEnt!.client!.NPC_class != CLASS_RANCOR && radiusEnt!.client!.NPC_class != CLASS_GALAKMECH && radiusEnt!.client!.NPC_class != CLASS_ATST && radiusEnt!.client!.NPC_class != CLASS_GONK && radiusEnt!.client!.NPC_class != CLASS_R2D2 && radiusEnt!.client!.NPC_class != CLASS_R5D2 && radiusEnt!.client!.NPC_class != CLASS_MARK1 && radiusEnt!.client!.NPC_class != CLASS_MARK2 && radiusEnt!.client!.NPC_class != CLASS_MOUSE && radiusEnt!.client!.NPC_class != CLASS_PROBE && radiusEnt!.client!.NPC_class != CLASS_SEEKER && radiusEnt!.client!.NPC_class != CLASS_REMOTE && radiusEnt!.client!.NPC_class != CLASS_SENTRY && radiusEnt!.client!.NPC_class != CLASS_INTERROGATOR && radiusEnt!.client!.NPC_class != CLASS_VEHICLE {
                //grab
                if NPC!.count == 2 {
                    //have one in my mouth, remove him
                    TIMER_Remove(NPC!, "clearGrabbed")
                    Rancor_DropVictim(NPC!)
                }
                NPC!.enemy = radiusEnt //make him my new best friend
                radiusEnt!.client!.ps.eFlags2 |= EF2_HELD_BY_MONSTER
                //FIXME: this makes it so that the victim can't hit us with shots!  Just use activator or something
                radiusEnt!.client!.ps.hasLookTarget = true
                radiusEnt!.client!.ps.lookTarget = NPC!.s.number
                NPC!.activator = radiusEnt //remember him
                NPC!.count = 1 //in my hand
                //wait to attack
                TIMER_Set(NPC!, "attacking", NPC!.client!.ps.legsTimer + Q_irand(500, 2500))
                if radiusEnt!.health > 0 && radiusEnt!.pain != nil {
                    //do pain on enemy
                    radiusEnt!.runPain(NPC, 100)
                    //GEntity_PainFunc( radiusEnt, NPC, NPC, radiusEnt->r.currentOrigin, 0, MOD_CRUSH );
                } else if radiusEnt!.client != nil {
                    radiusEnt!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                    radiusEnt!.client!.ps.forceHandExtendTime = 0
                    NPC_SetAnim(radiusEnt!, SETANIM_BOTH, BOTH_SWIM_IDLE1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                }
            } else {
                //smack
                var pushDir = vec3_t()
                var angs = vec3_t()

                G_Sound(radiusEnt!, CHAN_AUTO, G_SoundIndex("sound/chars/rancor/swipehit.wav"))
                //actually push the enemy
                /*
                //VectorSubtract( radiusEnt->r.currentOrigin, boltOrg, pushDir );
                VectorSubtract( radiusEnt->r.currentOrigin, NPC->r.currentOrigin, pushDir );
                pushDir[2] = Q_flrand( 100, 200 );
                VectorNormalize( pushDir );
                */
                angs = NPC!.client!.ps.viewangles
                angs[YAW] += flrand(25, 50)
                angs[PITCH] = flrand(-25, -15)
                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight = vec3_t()
                var scratchUp = vec3_t()
                AngleVectors(angs, &pushDir, &scratchRight, &scratchUp)
                if radiusEnt!.client!.NPC_class != CLASS_RANCOR && radiusEnt!.client!.NPC_class != CLASS_ATST {
                    // G_Damage may write `dir`, so the call passes a copy of `vec3_origin`.
                    var dir = vec3_origin
                    G_Damage(radiusEnt!, NPC, NPC, &dir, radiusEnt!.r.currentOrigin, Q_irand(25, 40), DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK, MOD_MELEE)
                    G_Throw(radiusEnt!, pushDir, 250)
                    if radiusEnt!.health > 0 {
                        //do pain on enemy
                        G_Knockdown(radiusEnt!) //, NPC, pushDir, 100, qtrue );
                    }
                }
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:308
func Rancor_Smash() {
    var radiusEntNums: [Int32] = [Int32](repeating: 0, count: 128)
    let numEnts: Int32
    let radius: Float = 128
    let halfRadSquared: Float = ((radius / 2) * (radius / 2))
    let radiusSquared: Float = (radius * radius)
    var distSq: Float
    var i: Int32
    var boltOrg = vec3_t()

    AddSoundEvent(NPC!, NPC!.r.currentOrigin, 512, AEL_DANGER, false) //, qtrue );

    numEnts = NPC_GetEntsNearBolt(&radiusEntNums, radius, NPC!.client!.renderInfo.handLBolt, &boltOrg)

    i = 0
    while i < numEnts {
        let radiusEnt: Entity? = g_entities[radiusEntNums[i]]
        if !radiusEnt!.inuse {
            i += 1
            continue
        }

        if radiusEnt == NPC {
            //Skip the rancor ent
            i += 1
            continue
        }

        if radiusEnt!.client == nil {
            //must be a client
            i += 1
            continue
        }

        if (radiusEnt!.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
            //can't be one being held
            i += 1
            continue
        }

        distSq = DistanceSquared(radiusEnt!.r.currentOrigin, boltOrg)
        if distSq <= radiusSquared {
            G_Sound(radiusEnt!, CHAN_AUTO, G_SoundIndex("sound/chars/rancor/swipehit.wav"))
            if distSq < halfRadSquared {
                //close enough to do damage, too
                // G_Damage may write `dir`, so the call passes a copy of `vec3_origin`.
                var dir = vec3_origin
                G_Damage(radiusEnt!, NPC, NPC, &dir, radiusEnt!.r.currentOrigin, Q_irand(10, 25), DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK, MOD_MELEE)
            }
            if radiusEnt!.health > 0 && radiusEnt!.client != nil && radiusEnt!.client!.NPC_class != CLASS_RANCOR && radiusEnt!.client!.NPC_class != CLASS_ATST {
                if distSq < halfRadSquared || radiusEnt!.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                    //within range of my fist or withing ground-shaking range and not in the air
                    G_Knockdown(radiusEnt!) //, NPC, vec3_origin, 100, qtrue );
                }
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:369
func Rancor_Bite() {
    var radiusEntNums: [Int32] = [Int32](repeating: 0, count: 128)
    let numEnts: Int32
    let radius: Float = 100
    let radiusSquared: Float = (radius * radius)
    var i: Int32
    var boltOrg = vec3_t()

    numEnts = NPC_GetEntsNearBolt(&radiusEntNums, radius, NPC!.client!.renderInfo.crotchBolt, &boltOrg) //was gutBolt?

    i = 0
    while i < numEnts {
        let radiusEnt: Entity? = g_entities[radiusEntNums[i]]
        if !radiusEnt!.inuse {
            i += 1
            continue
        }

        if radiusEnt == NPC {
            //Skip the rancor ent
            i += 1
            continue
        }

        if radiusEnt!.client == nil {
            //must be a client
            i += 1
            continue
        }

        if (radiusEnt!.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
            //can't be one already being held
            i += 1
            continue
        }

        if DistanceSquared(radiusEnt!.r.currentOrigin, boltOrg) <= radiusSquared {
            // G_Damage may write `dir`, so the call passes a copy of `vec3_origin`.
            var dir = vec3_origin
            G_Damage(radiusEnt!, NPC, NPC, &dir, radiusEnt!.r.currentOrigin, Q_irand(15, 30), DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK, MOD_MELEE)
            if radiusEnt!.health <= 0 && radiusEnt!.client != nil {
                //killed them, chance of dismembering
                if Q_irand(0, 1) == 0 {
                    //bite something off
                    let hitLoc: Int32 = Q_irand(G2_MODELPART_HEAD, G2_MODELPART_RLEG)
                    if hitLoc == G2_MODELPART_HEAD {
                        NPC_SetAnim(radiusEnt!, SETANIM_BOTH, BOTH_DEATH17, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    } else if hitLoc == G2_MODELPART_WAIST {
                        NPC_SetAnim(radiusEnt!, SETANIM_BOTH, BOTH_DEATHBACKWARD2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    }
                    //radiusEnt->client->dismembered = qfalse;
                    //FIXME: the limb should just disappear, cuz I ate it
                    G_Dismember(radiusEnt!, NPC!, radiusEnt!.r.currentOrigin, hitLoc, 90, 0, radiusEnt!.client!.ps.torsoAnim, true)
                    //G_DoDismemberment( radiusEnt, radiusEnt->r.currentOrigin, MOD_SABER, 1000, hitLoc, qtrue );
                }
            }
            G_Sound(radiusEnt!, CHAN_AUTO, G_SoundIndex("sound/chars/rancor/chomp.wav"))
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:431
func Rancor_Attack(_ distance: Float, _ doCharge: Bool) {
    if !TIMER_Exists(NPC!, "attacking") {
        if NPC!.count == 2 && NPC!.activator != nil {
        } else if NPC!.count == 1 && NPC!.activator != nil {
            //holding enemy
            if NPC!.activator!.health > 0 && Q_irand(0, 1) != 0 {
                //quick bite
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                TIMER_Set(NPC!, "attack_dmg", 450)
            } else {
                //full eat
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK3, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                TIMER_Set(NPC!, "attack_dmg", 900)
                //Make victim scream in fright
                if NPC!.activator!.health > 0 && NPC!.activator!.client != nil {
                    G_AddEvent(NPC!.activator!, Q_irand(EV_DEATH1, EV_DEATH3), 0)
                    NPC_SetAnim(NPC!.activator!, SETANIM_TORSO, BOTH_FALLDEATH1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    if NPC!.activator!.NPC != nil {
                        //no more thinking for you
                        TossClientItems(NPC!)
                        NPC!.activator!.NPC!.nextBStateThink = Q3_INFINITE
                    }
                }
            }
        } else if NPC!.enemy!.health > 0 && doCharge {
            //charge
            var fwd = vec3_t()
            var yawAng = vec3_t()
            yawAng = vec3_t(0, NPC!.client!.ps.viewangles[YAW], 0)
            // Raven passes NULL for the `right` and `up` outputs.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(yawAng, &fwd, &scratchRight, &scratchUp)
            NPC!.client!.ps.velocity = fwd * (distance * 1.5)
            NPC!.client!.ps.velocity[2] = 150
            NPC!.client!.ps.groundEntityNum = ENTITYNUM_NONE

            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_MELEE2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            TIMER_Set(NPC!, "attack_dmg", 1250)
        } else if Q_irand(0, 1) == 0 {
            //smash
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_MELEE1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            TIMER_Set(NPC!, "attack_dmg", 1000)
        } else {
            //try to grab
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            TIMER_Set(NPC!, "attack_dmg", 1000)
        }

        // The SDK also declares `random`, so the call names the bg module.
        TIMER_Set(NPC!, "attacking", Int32(NPC!.client!.ps.legsTimer + JKAMP_BG.random() * 200))
    }

    // Need to do delayed damage since the attack animations encapsulate multiple mini-attacks

    if TIMER_Done2(NPC!, "attack_dmg", true) {
        var shakePos = vec3_t()
        switch NPC!.client!.ps.legsAnim {
        case BOTH_MELEE1:
            Rancor_Smash()
            G_GetBoltPosition(NPC!, NPC!.client!.renderInfo.handLBolt, &shakePos, 0)
            G_ScreenShake(shakePos, nil, 4.0, 1000, false)

        case BOTH_MELEE2:
            Rancor_Bite()
            TIMER_Set(NPC!, "attack_dmg2", 450)

        case BOTH_ATTACK1:
            if NPC!.count == 1 && NPC!.activator != nil {
                // G_Damage may write `dir`, so the call passes a copy of `vec3_origin`.
                var dir = vec3_origin
                G_Damage(NPC!.activator!, NPC, NPC, &dir, NPC!.activator!.r.currentOrigin, Q_irand(25, 40), DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK, MOD_MELEE)
                if NPC!.activator!.health <= 0 {
                    //killed him
                    //make it look like we bit his head off
                    //NPC->activator->client->dismembered = qfalse;
                    G_Dismember(NPC!.activator!, NPC!, NPC!.activator!.r.currentOrigin, G2_MODELPART_HEAD, 90, 0, NPC!.activator!.client!.ps.torsoAnim, true)
                    //G_DoDismemberment( NPC->activator, NPC->activator->r.currentOrigin, MOD_SABER, 1000, HL_HEAD, qtrue );
                    NPC!.activator!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                    NPC!.activator!.client!.ps.forceHandExtendTime = 0
                    NPC_SetAnim(NPC!.activator!, SETANIM_BOTH, BOTH_SWIM_IDLE1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                }
                G_Sound(NPC!.activator!, CHAN_AUTO, G_SoundIndex("sound/chars/rancor/chomp.wav"))
            }

        case BOTH_ATTACK2:
            //try to grab
            Rancor_Swing(true)

        case BOTH_ATTACK3:
            if NPC!.count == 1 && NPC!.activator != nil {
                //cut in half
                if NPC!.activator!.client != nil {
                    //NPC->activator->client->dismembered = qfalse;
                    G_Dismember(NPC!.activator!, NPC!, NPC!.activator!.r.currentOrigin, G2_MODELPART_WAIST, 90, 0, NPC!.activator!.client!.ps.torsoAnim, true)
                    //G_DoDismemberment( NPC->activator, NPC->enemy->r.currentOrigin, MOD_SABER, 1000, HL_WAIST, qtrue );
                }
                //KILL
                // G_Damage may write `dir`, so the call passes a copy of `vec3_origin`.
                var dir = vec3_origin
                G_Damage(NPC!.activator!, NPC, NPC, &dir, NPC!.activator!.r.currentOrigin, NPC!.enemy!.health + 10, DAMAGE_NO_PROTECTION | DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK | DAMAGE_NO_HIT_LOC, MOD_MELEE)
                if NPC!.activator!.client != nil {
                    NPC!.activator!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                    NPC!.activator!.client!.ps.forceHandExtendTime = 0
                    NPC_SetAnim(NPC!.activator!, SETANIM_BOTH, BOTH_SWIM_IDLE1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                }
                TIMER_Set(NPC!, "attack_dmg2", 1350)
                G_Sound(NPC!.activator!, CHAN_AUTO, G_SoundIndex("sound/chars/rancor/swipehit.wav"))
                G_AddEvent(NPC!.activator!, EV_JUMP, NPC!.activator!.health)
            }

        default:
            break
        }
    } else if TIMER_Done2(NPC!, "attack_dmg2", true) {
        switch NPC!.client!.ps.legsAnim {
        case BOTH_MELEE1:
            break

        case BOTH_MELEE2:
            Rancor_Bite()

        case BOTH_ATTACK1:
            break

        case BOTH_ATTACK2:
            break

        case BOTH_ATTACK3:
            if NPC!.count == 1 && NPC!.activator != nil {
                //swallow victim
                G_Sound(NPC!.activator!, CHAN_AUTO, G_SoundIndex("sound/chars/rancor/chomp.wav"))
                //FIXME: sometimes end up with a live one in our mouths?
                //just make sure they're dead
                if NPC!.activator!.health > 0 {
                    //cut in half
                    //NPC->activator->client->dismembered = qfalse;
                    G_Dismember(NPC!.activator!, NPC!, NPC!.activator!.r.currentOrigin, G2_MODELPART_WAIST, 90, 0, NPC!.activator!.client!.ps.torsoAnim, true)
                    //G_DoDismemberment( NPC->activator, NPC->enemy->r.currentOrigin, MOD_SABER, 1000, HL_WAIST, qtrue );
                    //KILL
                    // G_Damage may write `dir`, so the call passes a copy of `vec3_origin`.
                    var dir = vec3_origin
                    G_Damage(NPC!.activator!, NPC, NPC, &dir, NPC!.activator!.r.currentOrigin, NPC!.enemy!.health + 10, DAMAGE_NO_PROTECTION | DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK | DAMAGE_NO_HIT_LOC, MOD_MELEE)
                    NPC!.activator!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                    NPC!.activator!.client!.ps.forceHandExtendTime = 0
                    NPC_SetAnim(NPC!.activator!, SETANIM_BOTH, BOTH_SWIM_IDLE1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    G_AddEvent(NPC!.activator!, EV_JUMP, NPC!.activator!.health)
                }
                if NPC!.activator!.client != nil {
                    //*sigh*, can't get tags right, just remove them?
                    NPC!.activator!.client!.ps.eFlags |= EF_NODRAW
                }
                NPC!.count = 2
                TIMER_Set(NPC!, "clearGrabbed", 2600)
            }

        default:
            break
        }
    } else if NPC!.client!.ps.legsAnim == BOTH_ATTACK2 {
        if NPC!.client!.ps.legsTimer >= 1200 && NPC!.client!.ps.legsTimer <= 1350 {
            if Q_irand(0, 2) != 0 {
                Rancor_Swing(false)
            } else {
                Rancor_Swing(true)
            }
        } else if NPC!.client!.ps.legsTimer >= 1100 && NPC!.client!.ps.legsTimer <= 1550 {
            Rancor_Swing(true)
        }
    }

    // Just using this to remove the attacking flag at the right time
    TIMER_Done2(NPC!, "attacking", true)
}

//----------------------------------
/// Source: oracle/codemp/game/NPC_AI_Rancor.c:617
func Rancor_Combat() {
    if NPC!.count != 0 {
        //holding my enemy
        if TIMER_Done2(NPC!, "takingPain", true) {
            NPCInfo!.localState = LSTATE_CLEAR
        } else {
            Rancor_Attack(0, false)
        }
        NPC_UpdateAngles(true, true)
        return
    }
    // If we cannot see our target or we have somewhere to go, then do that
    if !NPC_ClearLOS4(NPC!.enemy!) {
        NPCInfo!.combatMove = true
        NPCInfo!.goalEntity = NPC!.enemy
        NPCInfo!.goalRadius = MIN_DISTANCE //MAX_DISTANCE;	// just get us within combat range

        if !NPC_MoveToGoal(true) {
            //couldn't go after him?  Look for a new one
            TIMER_Set(NPC!, "lookForNewEnemy", 0)
            NPCInfo!.consecutiveBlockedMoves += 1
        } else {
            NPCInfo!.consecutiveBlockedMoves = 0
        }
        return
    }

    // Sometimes I have problems with facing the enemy I'm attacking, so force the issue so I don't look dumb
    NPC_FaceEnemy(true)

    do {
        let distance: Float
        var advance: Bool
        var doCharge: Bool

        distance = Distance(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)
        advance = Bool((distance > (NPC!.r.maxs[0] + MIN_DISTANCE) ? true : false))
        doCharge = false

        if advance {
            //have to get closer
            var yawOnlyAngles = vec3_t()
            yawOnlyAngles = vec3_t(0, NPC!.r.currentAngles[YAW], 0)
            if NPC!.enemy!.health > 0 && abs(distance - 250) <= 80 && InFOV3(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, yawOnlyAngles, 30, 30) {
                if Q_irand(0, 9) == 0 {
                    //go for the charge
                    doCharge = true
                    advance = false
                }
            }
        }

        if (advance) && TIMER_Done(NPC!, "attacking") {
            if TIMER_Done2(NPC!, "takingPain", true) {
                NPCInfo!.localState = LSTATE_CLEAR
            } else {
                Rancor_Move(1 != 0)
            }
        } else {
            Rancor_Attack(distance, doCharge)
        }
    }
}

/**
```
-------------------------
NPC_Rancor_Pain
-------------------------
```
*/
//void NPC_Rancor_Pain( gentity_t *self, gentity_t *inflictor, gentity_t *other, const vec3_t point, int damage, int mod,int hitLoc )
/// Source: oracle/codemp/game/NPC_AI_Rancor.c:703
func NPC_Rancor_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    var hitByRancor: Bool = false
    if attacker.client != nil && attacker.client!.NPC_class == CLASS_RANCOR {
        hitByRancor = true
    }
    if attacker.inuse && attacker != `self`.enemy && !((attacker.flags & FL_NOTARGET) != 0) {
        if `self`.count == 0 {
            if (attacker.s.number == 0 && Q_irand(0, 3) == 0) || `self`.enemy == nil || `self`.enemy!.health == 0 || (`self`.enemy!.client != nil && `self`.enemy!.client!.NPC_class == CLASS_RANCOR) || (`self`.NPC != nil && `self`.NPC!.consecutiveBlockedMoves >= 10 && DistanceSquared(attacker.r.currentOrigin, `self`.r.currentOrigin) < DistanceSquared(`self`.enemy!.r.currentOrigin, `self`.r.currentOrigin)) {
                //if my enemy is dead (or attacked by player) and I'm not still holding/eating someone, turn on the attacker
                //FIXME: if can't nav to my enemy, take this guy if I can nav to him
                G_SetEnemy(`self`, attacker)
                TIMER_Set(`self`, "lookForNewEnemy", Q_irand(5000, 15000))
                if hitByRancor {
                    //stay mad at this Rancor for 2-5 secs before looking for attacker enemies
                    TIMER_Set(`self`, "rancorInfight", Q_irand(2000, 5000))
                }
            }
        }
    }
    if (hitByRancor || (`self`.count == 1 && `self`.activator != nil && Q_irand(0, 4) == 0) || Q_irand(0, 200) < damage) && `self`.client!.ps.legsAnim != BOTH_STAND1TO2 && TIMER_Done(`self`, "takingPain") {
        if !Rancor_CheckRoar(`self`) {
            if `self`.client!.ps.legsAnim != BOTH_MELEE1 && `self`.client!.ps.legsAnim != BOTH_MELEE2 && `self`.client!.ps.legsAnim != BOTH_ATTACK2 {
                //cant interrupt one of the big attack anims
                /*
                if ( self->count != 1
                || attacker == self->activator
                || (self->client->ps.legsAnim != BOTH_ATTACK1&&self->client->ps.legsAnim != BOTH_ATTACK3) )
                */
                do {
                    //if going to bite our victim, only victim can interrupt that anim
                    if `self`.health > 100 || hitByRancor {
                        TIMER_Remove(`self`, "attacking")

                        `self`.s.angles = `self`.NPC!.lastPathAngles

                        if `self`.count == 1 {
                            NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                        } else {
                            NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                        }
                        TIMER_Set(`self`, "takingPain", `self`.client!.ps.legsTimer + Q_irand(0, 500))

                        if `self`.NPC != nil {
                            `self`.NPC!.localState = LSTATE_WAITING
                        }
                    }
                }
            }
        }
        //let go
        /*
        if ( !Q_irand( 0, 3 ) && self->count == 1 )
        {
        Rancor_DropVictim( self );
        }
        */
    }
}

/// Source: oracle/codemp/game/NPC_AI_Rancor.c:784
func Rancor_CheckDropVictim() {
    var mins = vec3_t()
    var maxs = vec3_t()
    var start = vec3_t()
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in

        mins = vec3_t(NPC!.activator!.r.mins[0] - 1, NPC!.activator!.r.mins[1] - 1, 0)
        maxs = vec3_t(NPC!.activator!.r.maxs[0] + 1, NPC!.activator!.r.maxs[1] + 1, 1)
        start = vec3_t(NPC!.activator!.r.currentOrigin[0], NPC!.activator!.r.currentOrigin[1], NPC!.activator!.r.absmin[2])
        end = vec3_t(NPC!.activator!.r.currentOrigin[0], NPC!.activator!.r.currentOrigin[1], NPC!.activator!.r.absmax[2] - 1)

        trap_Trace(trace, start, mins, maxs, end, NPC!.activator!.s.number, NPC!.activator!.clipmask)
        if trace.allsolid == 0 && trace.startsolid == 0 && trace.fraction >= 1.0 {
            Rancor_DropVictim(NPC!)
        }
    }
}

//if he's stepping on things then crush them -rww
/// Source: oracle/codemp/game/NPC_AI_Rancor.c:805
func Rancor_Crush() {
    var crush: Entity?

    if NPC == nil || NPC!.client == nil || NPC!.client!.ps.groundEntityNum >= ENTITYNUM_WORLD {
        //nothing to crush
        return
    }

    crush = g_entities[NPC!.client!.ps.groundEntityNum]
    if crush!.inuse && crush!.client != nil && crush!.localAnimIndex == 0 {
        //a humanoid, smash them good.
        var dir: vec3_t? = nil
        G_Damage(crush!, NPC, NPC, &dir, NPC!.r.currentOrigin, 200, 0, MOD_CRUSH)
    }
}

/**
```
-------------------------
NPC_BSRancor_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Rancor.c:828
func NPC_BSRancor_Default() {
    AddSightEvent(NPC!, NPC!.r.currentOrigin, 1024, AEL_DANGER_GREAT, 50)

    Rancor_Crush()

    NPC!.client!.ps.eFlags2 &= ~(EF2_USE_ALT_ANIM | EF2_GENERIC_NPC_FLAG)
    if NPC!.count != 0 {
        //holding someone
        NPC!.client!.ps.eFlags2 |= EF2_USE_ALT_ANIM
        if NPC!.count == 2 {
            //in my mouth
            NPC!.client!.ps.eFlags2 |= EF2_GENERIC_NPC_FLAG
        }
    } else {
        NPC!.client!.ps.eFlags2 &= ~(EF2_USE_ALT_ANIM | EF2_GENERIC_NPC_FLAG)
    }

    if TIMER_Done2(NPC!, "clearGrabbed", true) {
        Rancor_DropVictim(NPC!)
    } else if NPC!.client!.ps.legsAnim == BOTH_PAIN2 && NPC!.count == 1 && NPC!.activator != nil {
        if Q_irand(0, 3) == 0 {
            Rancor_CheckDropVictim()
        }
    }
    if !TIMER_Done(NPC!, "rageTime") {
        //do nothing but roar first time we see an enemy
        AddSoundEvent(NPC!, NPC!.r.currentOrigin, 1024, AEL_DANGER_GREAT, false) //, qfalse );
        NPC_FaceEnemy(true)
        return
    }
    if NPC!.enemy != nil {
        /*
        if ( NPC->enemy->client //enemy is a client
        && (NPC->enemy->client->NPC_class == CLASS_UGNAUGHT || NPC->enemy->client->NPC_class == CLASS_JAWA )//enemy is a lowly jawa or ugnaught
        && NPC->enemy->enemy != NPC//enemy's enemy is not me
        && (!NPC->enemy->enemy || !NPC->enemy->enemy->client || NPC->enemy->enemy->client->NPC_class!=CLASS_RANCOR) )//enemy's enemy is not a client or is not a rancor (which is as scary as me anyway)
        {//they should be scared of ME and no-one else
        G_SetEnemy( NPC->enemy, NPC );
        }
        */
        if TIMER_Done(NPC!, "angrynoise") {
            G_Sound(NPC!, CHAN_AUTO, G_SoundIndex(va("sound/chars/rancor/misc/anger%d.wav", Q_irand(1, 3))))

            TIMER_Set(NPC!, "angrynoise", Q_irand(5000, 10000))
        } else {
            AddSoundEvent(NPC!, NPC!.r.currentOrigin, 512, AEL_DANGER_GREAT, false) //, qfalse );
        }
        if NPC!.count == 2 && NPC!.client!.ps.legsAnim == BOTH_ATTACK3 {
            //we're still chewing our enemy up
            NPC_UpdateAngles(true, true)
            return
        }
        //else, if he's in our hand, we eat, else if he's on the ground, we keep attacking his dead body for a while
        if NPC!.enemy!.client != nil && NPC!.enemy!.client!.NPC_class == CLASS_RANCOR {
            //got mad at another Rancor, look for a valid enemy
            if TIMER_Done(NPC!, "rancorInfight") {
                NPC_CheckEnemyExt(true)
            }
        } else if NPC!.count == 0 {
            if ValidEnemy(NPC!.enemy!) == false {
                TIMER_Remove(NPC!, "lookForNewEnemy") //make them look again right now
                if !NPC!.enemy!.inuse || level.time - NPC!.enemy!.s.time > Q_irand(10000, 15000) {
                    //it's been a while since the enemy died, or enemy is completely gone, get bored with him
                    NPC!.enemy = nil
                    Rancor_Patrol()
                    NPC_UpdateAngles(true, true)
                    return
                }
            }
            if TIMER_Done(NPC!, "lookForNewEnemy") {
                var newEnemy: Entity?
                let sav_enemy: Entity? = NPC!.enemy
                NPC!.enemy = nil
                newEnemy = NPC_CheckEnemy(NPCInfo!.confusionTime < level.time, false, false)
                NPC!.enemy = sav_enemy
                if newEnemy != nil && newEnemy != sav_enemy {
                    //picked up a new enemy!
                    NPC!.lastEnemy = NPC!.enemy
                    G_SetEnemy(NPC!, newEnemy!)
                    //hold this one for at least 5-15 seconds
                    TIMER_Set(NPC!, "lookForNewEnemy", Q_irand(5000, 15000))
                } else {
                    //look again in 2-5 secs
                    TIMER_Set(NPC!, "lookForNewEnemy", Q_irand(2000, 5000))
                }
            }
        }
        Rancor_Combat()
    } else {
        if TIMER_Done(NPC!, "idlenoise") {
            G_Sound(NPC!, CHAN_AUTO, G_SoundIndex(va("sound/chars/rancor/snort_%d.wav", Q_irand(1, 2))))

            TIMER_Set(NPC!, "idlenoise", Q_irand(2000, 4000))
            AddSoundEvent(NPC!, NPC!.r.currentOrigin, 384, AEL_DANGER, false) //, qfalse );
        }
        if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            Rancor_Patrol()
        } else {
            Rancor_Idle()
        }
    }

    NPC_UpdateAngles(true, true)
}
