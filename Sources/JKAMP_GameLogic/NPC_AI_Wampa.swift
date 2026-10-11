import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:5
private let MIN_DISTANCE = 48 as Int32

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:6
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:8
private let MAX_DISTANCE = 1024 as Int32

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:9
private let MAX_DISTANCE_SQR = (MAX_DISTANCE * MAX_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:11
private let LSTATE_CLEAR = 0 as Int32

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:12
private let LSTATE_WAITING = 1 as Int32

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:14
private var enemyDist: Float {
    get { world.variables.NPC_AI_Wampa_enemyDist }
    set { world.variables.NPC_AI_Wampa_enemyDist = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:16
func Wampa_SetBolts(_ `self`: Entity) {
    if `self`.client != nil {
        let ri: RenderInfo? = `self`.client!.renderInfo
        ri!.headBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*head_eyes")
        //ri->cervicalBolt = trap_G2API_AddBolt(self->ghoul2, 0, "neck_bone" );
        //ri->chestBolt = trap_G2API_AddBolt(self->ghoul2, 0, "upper_spine");
        //ri->gutBolt = trap_G2API_AddBolt(self->ghoul2, 0, "mid_spine");
        ri!.torsoBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "lower_spine")
        ri!.crotchBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "rear_bone")
        //ri->elbowLBolt = trap_G2API_AddBolt(self->ghoul2, 0, "*l_arm_elbow");
        //ri->elbowRBolt = trap_G2API_AddBolt(self->ghoul2, 0, "*r_arm_elbow");
        ri!.handLBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_hand")
        ri!.handRBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*r_hand")
        //ri->kneeLBolt = trap_G2API_AddBolt(self->ghoul2, 0, "*hips_l_knee");
        //ri->kneeRBolt = trap_G2API_AddBolt(self->ghoul2, 0, "*hips_r_knee");
        ri!.footLBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_leg_foot")
        ri!.footRBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*r_leg_foot")
    }
}

/**
```
-------------------------
NPC_Wampa_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Wampa.c:43
func NPC_Wampa_Precache() {
    /*
    int i;
    for ( i = 1; i < 4; i ++ )
    {
    G_SoundIndex( va("sound/chars/wampa/growl%d.wav", i) );
    }
    for ( i = 1; i < 3; i ++ )
    {
    G_SoundIndex( va("sound/chars/wampa/snort%d.wav", i) );
    }
    */
    G_SoundIndex("sound/chars/rancor/swipehit.wav")
    //G_SoundIndex( "sound/chars/wampa/chomp.wav" );
}

/**
```
-------------------------
Wampa_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Wampa.c:66
func Wampa_Idle() {
    NPCInfo!.localState = LSTATE_CLEAR

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons &= ~BUTTON_WALKING
        NPC_MoveToGoal(true)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:78
func Wampa_CheckRoar(_ `self`: Entity) -> Bool {
    if `self`.wait < level.time {
        `self`.wait = Float(level.time + Q_irand(5000, 20000))
        NPC_SetAnim(`self`, SETANIM_BOTH, Q_irand(BOTH_GESTURE1, BOTH_GESTURE2), (SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD))
        TIMER_Set(`self`, "rageTime", `self`.client!.ps.legsTimer)
        return true
    }
    return false
}

/**
```
-------------------------
Wampa_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Wampa.c:94
func Wampa_Patrol() {
    NPCInfo!.localState = LSTATE_CLEAR

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons |= BUTTON_WALKING
        NPC_MoveToGoal(true)
    } else {
        if TIMER_Done(NPC!, "patrolTime") {
            TIMER_Set(NPC!, "patrolTime", Int32(crandom() * 5000 + 5000))
        }
    }

    if NPC_CheckEnemyExt(true) == false {
        Wampa_Idle()
        return
    }
    Wampa_CheckRoar(NPC!)
    TIMER_Set(NPC!, "lookForNewEnemy", Q_irand(5000, 15000))
}

/**
```
-------------------------
Wampa_Move
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Wampa.c:126
func Wampa_Move(_ visible: Bool) {
    if NPCInfo!.localState != LSTATE_WAITING {
        NPCInfo!.goalEntity = NPC!.enemy

        if NPC!.enemy != nil {
            //pick correct movement speed and anim
            //run by default
            ucmd.buttons &= ~BUTTON_WALKING
            if !TIMER_Done(NPC!, "runfar") || !TIMER_Done(NPC!, "runclose") {
                //keep running with this anim & speed for a bit
            } else if !TIMER_Done(NPC!, "walk") {
                //keep walking for a bit
                ucmd.buttons |= BUTTON_WALKING
            } else if visible && enemyDist > 384 && NPCInfo!.stats.runSpeed == 180 {
                //fast run, all fours
                NPCInfo!.stats.runSpeed = 300
                TIMER_Set(NPC!, "runfar", Q_irand(2000, 4000))
            } else if enemyDist > 256 && NPCInfo!.stats.runSpeed == 300 {
                //slow run, upright
                NPCInfo!.stats.runSpeed = 180
                TIMER_Set(NPC!, "runclose", Q_irand(3000, 5000))
            } else if enemyDist < 128 {
                //walk
                NPCInfo!.stats.runSpeed = 180
                ucmd.buttons |= BUTTON_WALKING
                TIMER_Set(NPC!, "walk", Q_irand(4000, 6000))
            }
        }

        if NPCInfo!.stats.runSpeed == 300 {
            //need to use the alternate run - hunched over on all fours
            NPC!.client!.ps.eFlags2 |= EF2_USE_ALT_ANIM
        }
        NPC_MoveToGoal(true)
        NPCInfo!.goalRadius = MAX_DISTANCE // just get us within combat range
    }
}

/// Source: oracle/codemp/game/NPC_AI_Wampa.c:177
func Wampa_Slash(_ boltIndex: Int32, _ backhand: Bool) {
    var radiusEntNums: [Int32] = [Int32](repeating: 0, count: 128)
    let numEnts: Int32
    let radius: Float = 88
    let radiusSquared: Float = (radius * radius)
    var i: Int32
    var boltOrg = vec3_t()
    let damage: Int32 = (backhand) ? Q_irand(10, 15) : Q_irand(20, 30)

    numEnts = NPC_GetEntsNearBolt(&radiusEntNums, radius, boltIndex, &boltOrg)

    i = 0
    while i < numEnts {
        let radiusEnt: Entity? = g_entities[radiusEntNums[i]]
        if !radiusEnt!.inuse {
            i += 1
            continue
        }

        if radiusEnt == NPC {
            //Skip the wampa ent
            i += 1
            continue
        }

        if radiusEnt!.client == nil {
            //must be a client
            i += 1
            continue
        }

        if DistanceSquared(radiusEnt!.r.currentOrigin, boltOrg) <= radiusSquared {
            //smack
            // G_Damage may write `dir`, so the call passes a copy of `vec3_origin`.
            var dir = vec3_origin
            G_Damage(radiusEnt!, NPC, NPC, &dir, radiusEnt!.r.currentOrigin, damage, ((backhand) ? DAMAGE_NO_ARMOR : (DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK)), MOD_MELEE)
            if backhand {
                //actually push the enemy
                var pushDir = vec3_t()
                var angs = vec3_t()
                angs = NPC!.client!.ps.viewangles
                angs[YAW] += flrand(25, 50)
                angs[PITCH] = flrand(-25, -15)
                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight = vec3_t()
                var scratchUp = vec3_t()
                AngleVectors(angs, &pushDir, &scratchRight, &scratchUp)
                if radiusEnt!.client!.NPC_class != CLASS_WAMPA && radiusEnt!.client!.NPC_class != CLASS_RANCOR && radiusEnt!.client!.NPC_class != CLASS_ATST {
                    G_Throw(radiusEnt!, pushDir, 65)
                    if BG_KnockDownable(radiusEnt!.client!.ps) && radiusEnt!.health > 0 && Q_irand(0, 1) != 0 {
                        //do pain on enemy
                        radiusEnt!.client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
                        radiusEnt!.client!.ps.forceDodgeAnim = 0
                        radiusEnt!.client!.ps.forceHandExtendTime = level.time + 1100
                        radiusEnt!.client!.ps.quickerGetup = false
                    }
                }
            } else if radiusEnt!.health <= 0 && radiusEnt!.client != nil {
                //killed them, chance of dismembering
                if Q_irand(0, 1) == 0 {
                    //bite something off
                    let hitLoc: Int32 = Q_irand(G2_MODELPART_HEAD, G2_MODELPART_RLEG)
                    if hitLoc == G2_MODELPART_HEAD {
                        NPC_SetAnim(radiusEnt!, SETANIM_BOTH, BOTH_DEATH17, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    } else if hitLoc == G2_MODELPART_WAIST {
                        NPC_SetAnim(radiusEnt!, SETANIM_BOTH, BOTH_DEATHBACKWARD2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    }
                    G_Dismember(radiusEnt!, NPC!, radiusEnt!.r.currentOrigin, hitLoc, 90, 0, radiusEnt!.client!.ps.torsoAnim, true)
                }
            } else if Q_irand(0, 3) == 0 && radiusEnt!.health > 0 {
                //one out of every 4 normal hits does a knockdown, too
                var pushDir = vec3_t()
                var angs = vec3_t()
                angs = NPC!.client!.ps.viewangles
                angs[YAW] += flrand(25, 50)
                angs[PITCH] = flrand(-25, -15)
                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight2 = vec3_t()
                var scratchUp2 = vec3_t()
                AngleVectors(angs, &pushDir, &scratchRight2, &scratchUp2)
                G_Knockdown(radiusEnt!)
            }
            G_Sound(radiusEnt!, CHAN_WEAPON, G_SoundIndex("sound/chars/rancor/swipehit.wav"))
        }
        i += 1
    }
}

//------------------------------
/// Source: oracle/codemp/game/NPC_AI_Wampa.c:267
func Wampa_Attack(_ distance: Float, _ doCharge: Bool) {
    if !TIMER_Exists(NPC!, "attacking") {
        if Q_irand(0, 2) != 0 && !doCharge {
            //double slash
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            TIMER_Set(NPC!, "attack_dmg", 750)
        } else if doCharge || (distance > 270 && distance < 430 && Q_irand(0, 1) == 0) {
            //leap
            var fwd = vec3_t()
            var yawAng = vec3_t()
            yawAng = vec3_t(0, NPC!.client!.ps.viewangles[YAW], 0)
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            TIMER_Set(NPC!, "attack_dmg", 500)
            // Raven passes NULL for the `right` and `up` outputs.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(yawAng, &fwd, &scratchRight, &scratchUp)
            NPC!.client!.ps.velocity = fwd * (distance * 1.5)
            NPC!.client!.ps.velocity[2] = 150
            NPC!.client!.ps.groundEntityNum = ENTITYNUM_NONE
        } else {
            //backhand
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK3, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            TIMER_Set(NPC!, "attack_dmg", 250)
        }

        // The SDK also declares `random`, so the call names the bg module.
        TIMER_Set(NPC!, "attacking", Int32(NPC!.client!.ps.legsTimer + JKAMP_BG.random() * 200))
        //allow us to re-evaluate our running speed/anim
        TIMER_Set(NPC!, "runfar", -1)
        TIMER_Set(NPC!, "runclose", -1)
        TIMER_Set(NPC!, "walk", -1)
    }

    // Need to do delayed damage since the attack animations encapsulate multiple mini-attacks

    if TIMER_Done2(NPC!, "attack_dmg", true) {
        switch NPC!.client!.ps.legsAnim {
        case BOTH_ATTACK1:
            Wampa_Slash(NPC!.client!.renderInfo.handRBolt, false)
            //do second hit
            TIMER_Set(NPC!, "attack_dmg2", 100)

        case BOTH_ATTACK2:
            Wampa_Slash(NPC!.client!.renderInfo.handRBolt, false)
            TIMER_Set(NPC!, "attack_dmg2", 100)

        case BOTH_ATTACK3:
            Wampa_Slash(NPC!.client!.renderInfo.handLBolt, true)

        default:
            break
        }
    } else if TIMER_Done2(NPC!, "attack_dmg2", true) {
        switch NPC!.client!.ps.legsAnim {
        case BOTH_ATTACK1:
            Wampa_Slash(NPC!.client!.renderInfo.handLBolt, false)

        case BOTH_ATTACK2:
            Wampa_Slash(NPC!.client!.renderInfo.handLBolt, false)

        default:
            break
        }
    }

    // Just using this to remove the attacking flag at the right time
    TIMER_Done2(NPC!, "attacking", true)

    if NPC!.client!.ps.legsAnim == BOTH_ATTACK1 && distance > (NPC!.r.maxs[0] + MIN_DISTANCE) {
        //okay to keep moving
        ucmd.buttons |= BUTTON_WALKING
        Wampa_Move(1 != 0)
    }
}

//----------------------------------
/// Source: oracle/codemp/game/NPC_AI_Wampa.c:344
func Wampa_Combat() {
    // If we cannot see our target or we have somewhere to go, then do that
    if !NPC_ClearLOS(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin) {
        if Q_irand(0, 10) == 0 {
            if Wampa_CheckRoar(NPC!) {
                return
            }
        }
        NPCInfo!.combatMove = true
        NPCInfo!.goalEntity = NPC!.enemy
        NPCInfo!.goalRadius = MAX_DISTANCE // just get us within combat range

        Wampa_Move(0 != 0)
        return
    } else if UpdateGoal() != nil {
        NPCInfo!.combatMove = true
        NPCInfo!.goalEntity = NPC!.enemy
        NPCInfo!.goalRadius = MAX_DISTANCE // just get us within combat range

        Wampa_Move(1 != 0)
        return
    } else {
        enemyDist = Distance(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)
        let distance: Float = enemyDist
        var advance: Bool = distance > (NPC!.r.maxs[0] + MIN_DISTANCE) ? true : false
        var doCharge: Bool = false

        // Sometimes I have problems with facing the enemy I'm attacking, so force the issue so I don't look dumb
        //FIXME: always seems to face off to the left or right?!!!!
        NPC_FaceEnemy(true)


        if advance {
            //have to get closer
            var yawOnlyAngles = vec3_t()
            yawOnlyAngles = vec3_t(0, NPC!.r.currentAngles[YAW], 0)
            if NPC!.enemy!.health > 0 //enemy still alive
                && abs(distance - 350) <= 80 //enemy anywhere from 270 to 430 away
                && InFOV3(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, yawOnlyAngles, 20, 20) {
                //enemy generally in front
                //10% chance of doing charge anim
                if Q_irand(0, 9) == 0 {
                    //go for the charge
                    doCharge = true
                    advance = false
                }
            }
        }

        if (advance || NPCInfo!.localState == LSTATE_WAITING) && TIMER_Done(NPC!, "attacking") {
            // waiting monsters can't attack
            if TIMER_Done2(NPC!, "takingPain", true) {
                NPCInfo!.localState = LSTATE_CLEAR
            } else {
                Wampa_Move(1 != 0)
            }
        } else {
            if Q_irand(0, 20) == 0 {
                //FIXME: only do this if we just damaged them or vice-versa?
                if Wampa_CheckRoar(NPC!) {
                    return
                }
            }
            if Q_irand(0, 1) == 0 {
                //FIXME: base on skill
                Wampa_Attack(distance, doCharge)
            }
        }
    }
}

/**
```
-------------------------
NPC_Wampa_Pain
-------------------------
```
*/
//void NPC_Wampa_Pain( gentity_t *self, gentity_t *inflictor, gentity_t *other, const vec3_t point, int damage, int mod,int hitLoc )
/// Source: oracle/codemp/game/NPC_AI_Wampa.c:433
func NPC_Wampa_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    var hitByWampa: Bool = false
    if attacker.client != nil && attacker.client!.NPC_class == CLASS_WAMPA {
        hitByWampa = true
    }
    if attacker.inuse && attacker != `self`.enemy && !((attacker.flags & FL_NOTARGET) != 0) {
        if (attacker.s.number == 0 && Q_irand(0, 3) == 0) || `self`.enemy == nil || `self`.enemy!.health == 0 || (`self`.enemy!.client != nil && `self`.enemy!.client!.NPC_class == CLASS_WAMPA) || (Q_irand(0, 4) == 0 && DistanceSquared(attacker.r.currentOrigin, `self`.r.currentOrigin) < DistanceSquared(`self`.enemy!.r.currentOrigin, `self`.r.currentOrigin)) {
            //if my enemy is dead (or attacked by player) and I'm not still holding/eating someone, turn on the attacker
            //FIXME: if can't nav to my enemy, take this guy if I can nav to him
            G_SetEnemy(`self`, attacker)
            TIMER_Set(`self`, "lookForNewEnemy", Q_irand(5000, 15000))
            if hitByWampa {
                //stay mad at this Wampa for 2-5 secs before looking for attacker enemies
                TIMER_Set(`self`, "wampaInfight", Q_irand(2000, 5000))
            }
        }
    }
    if (hitByWampa || Q_irand(0, 100) < damage) && `self`.client!.ps.legsAnim != BOTH_GESTURE1 && `self`.client!.ps.legsAnim != BOTH_GESTURE2 && TIMER_Done(`self`, "takingPain") {
        if !Wampa_CheckRoar(`self`) {
            if `self`.client!.ps.legsAnim != BOTH_ATTACK1 && `self`.client!.ps.legsAnim != BOTH_ATTACK2 && `self`.client!.ps.legsAnim != BOTH_ATTACK3 {
                //cant interrupt one of the big attack anims
                if `self`.health > 100 || hitByWampa {
                    TIMER_Remove(`self`, "attacking")

                    `self`.s.angles = `self`.NPC!.lastPathAngles

                    if Q_irand(0, 1) == 0 {
                        NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    } else {
                        NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    }
                    TIMER_Set(`self`, "takingPain", `self`.client!.ps.legsTimer + Q_irand(0, 500))
                    //allow us to re-evaluate our running speed/anim
                    TIMER_Set(`self`, "runfar", -1)
                    TIMER_Set(`self`, "runclose", -1)
                    TIMER_Set(`self`, "walk", -1)

                    if `self`.NPC != nil {
                        `self`.NPC!.localState = LSTATE_WAITING
                    }
                }
            }
        }
    }
}

/**
```
-------------------------
NPC_BSWampa_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Wampa.c:506
func NPC_BSWampa_Default() {
    NPC!.client!.ps.eFlags2 &= ~EF2_USE_ALT_ANIM
    //NORMAL ANIMS
    //	stand1 = normal stand
    //	walk1 = normal, non-angry walk
    //	walk2 = injured
    //	run1 = far away run
    //	run2 = close run
    //VICTIM ANIMS
    //	grabswipe = melee1 - sweep out and grab
    //	stand2 attack = attack4 - while holding victim, swipe at him
    //	walk3_drag = walk5 - walk with drag
    //	stand2 = hold victim
    //	stand2to1 = drop victim
    if !TIMER_Done(NPC!, "rageTime") {
        //do nothing but roar first time we see an enemy
        NPC_FaceEnemy(true)
        return
    }
    if NPC!.enemy != nil {
        if !TIMER_Done(NPC!, "attacking") {
            //in middle of attack
            //face enemy
            NPC_FaceEnemy(true)
            //continue attack logic
            enemyDist = Distance(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)
            Wampa_Attack(enemyDist, false)
            return
        } else {
            if TIMER_Done(NPC!, "angrynoise") {
                G_Sound(NPC!, CHAN_VOICE, G_SoundIndex(va("sound/chars/wampa/misc/anger%d.wav", Q_irand(1, 2))))

                TIMER_Set(NPC!, "angrynoise", Q_irand(5000, 10000))
            }
            //else, if he's in our hand, we eat, else if he's on the ground, we keep attacking his dead body for a while
            if NPC!.enemy!.client != nil && NPC!.enemy!.client!.NPC_class == CLASS_WAMPA {
                //got mad at another Wampa, look for a valid enemy
                if TIMER_Done(NPC!, "wampaInfight") {
                    NPC_CheckEnemyExt(true)
                }
            } else {
                if ValidEnemy(NPC!.enemy!) == false {
                    TIMER_Remove(NPC!, "lookForNewEnemy") //make them look again right now
                    if !NPC!.enemy!.inuse || level.time - NPC!.enemy!.s.time > Q_irand(10000, 15000) {
                        //it's been a while since the enemy died, or enemy is completely gone, get bored with him
                        NPC!.enemy = nil
                        Wampa_Patrol()
                        NPC_UpdateAngles(true, true)
                        //just lost my enemy
                        if (NPC!.spawnflags & 2) != 0 {
                            //search around me if I don't have an enemy
                            NPC_BSSearchStart(NPC!.waypoint, BS_SEARCH)
                            NPCInfo!.tempBehavior = BS_DEFAULT
                        } else if (NPC!.spawnflags & 1) != 0 {
                            //wander if I don't have an enemy
                            NPC_BSSearchStart(NPC!.waypoint, BS_WANDER)
                            NPCInfo!.tempBehavior = BS_DEFAULT
                        }
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
            Wampa_Combat()
            return
        }
    } else {
        if TIMER_Done(NPC!, "idlenoise") {
            G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/wampa/misc/anger3.wav"))

            TIMER_Set(NPC!, "idlenoise", Q_irand(2000, 4000))
        }
        if (NPC!.spawnflags & 2) != 0 {
            //search around me if I don't have an enemy
            if NPCInfo!.homeWp == WAYPOINT_NONE {
                //no homewap, initialize the search behavior
                NPC_BSSearchStart(WAYPOINT_NONE, BS_SEARCH)
                NPCInfo!.tempBehavior = BS_DEFAULT
            }
            ucmd.buttons |= BUTTON_WALKING
            NPC_BSSearch() //this automatically looks for enemies
        } else if (NPC!.spawnflags & 1) != 0 {
            //wander if I don't have an enemy
            if NPCInfo!.homeWp == WAYPOINT_NONE {
                //no homewap, initialize the wander behavior
                NPC_BSSearchStart(WAYPOINT_NONE, BS_WANDER)
                NPCInfo!.tempBehavior = BS_DEFAULT
            }
            ucmd.buttons |= BUTTON_WALKING
            NPC_BSWander()
            if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
                if NPC_CheckEnemyExt(true) == false {
                    Wampa_Idle()
                } else {
                    Wampa_CheckRoar(NPC!)
                    TIMER_Set(NPC!, "lookForNewEnemy", Q_irand(5000, 15000))
                }
            }
        } else {
            if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
                Wampa_Patrol()
            } else {
                Wampa_Idle()
            }
        }
    }

    NPC_UpdateAngles(true, true)
}
