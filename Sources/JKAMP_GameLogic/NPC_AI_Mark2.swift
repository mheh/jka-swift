import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:19
private let LSTATE_NONE: Int32 = 0
private let LSTATE_DROPPINGDOWN: Int32 = 1
private let LSTATE_DOWN: Int32 = 2
private let LSTATE_RISINGUP: Int32 = 3

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:5
private let AMMO_POD_HEALTH = 1 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:6
private let TURN_OFF = 0x00000100 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:8
private let VELOCITY_DECAY = 0.25 as Double

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:9
private let MAX_DISTANCE = 256 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:10
private let MAX_DISTANCE_SQR = (MAX_DISTANCE * MAX_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:11
private let MIN_DISTANCE = 24 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:12
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Mark2.c:27
func NPC_Mark2_Precache() {
    G_SoundIndex("sound/chars/mark2/misc/mark2_explo") // blows up on death
    G_SoundIndex("sound/chars/mark2/misc/mark2_pain")
    G_SoundIndex("sound/chars/mark2/misc/mark2_fire")
    G_SoundIndex("sound/chars/mark2/misc/mark2_move_lp")

    G_EffectIndex("explosions/droidexplosion1")
    G_EffectIndex("env/med_explode2")
    G_EffectIndex("blaster/smoke_bolton")
    G_EffectIndex("bryar/muzzle_flash")

    RegisterItem(BG_FindItemForWeapon(WP_BRYAR_PISTOL)!)
    RegisterItem(BG_FindItemForAmmo(AMMO_METAL_BOLTS)!)
    RegisterItem(BG_FindItemForAmmo(AMMO_POWERCELL)!)
    RegisterItem(BG_FindItemForAmmo(AMMO_BLASTER)!)
}

/**
```
-------------------------
NPC_Mark2_Part_Explode
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:50
func NPC_Mark2_Part_Explode(_ `self`: Entity, _ bolt: Int32) {
    if bolt >= 0 {
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in
            var org = vec3_t()
            var dir = vec3_t()

            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, bolt, boltMatrix, `self`.r.currentAngles, `self`.r.currentOrigin, level.time, nil, &`self`.modelScale)

            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &org)
            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &dir)

            G_PlayEffectID(G_EffectIndex("env/med_explode2"), org, dir)
            G_PlayEffectID(G_EffectIndex("blaster/smoke_bolton"), org, dir)
        }
    }

    //G_PlayEffectID( G_EffectIndex("blaster/smoke_bolton"), self->playerModel, bolt, self->s.number);

    `self`.count += 1 // Count of pods blown off
}

/**
```
-------------------------
NPC_Mark2_Pain
- look at what was hit and see if it should be removed from the model.
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:80
func NPC_Mark2_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    var newBolt: Int32
    var i: Int32
    let hitLoc: Int32 = gPainHitLoc

    NPC_Pain(`self`, attacker, damage)

    i = 0
    while i < 3 {
        if (hitLoc == HL_GENERIC1 + i) && (`self`.locationDamage[HL_GENERIC1 + i] > AMMO_POD_HEALTH) {
            if `self`.locationDamage[hitLoc] >= AMMO_POD_HEALTH {
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, va("torso_canister%d", (i + 1)))
                if newBolt != -1 {
                    NPC_Mark2_Part_Explode(`self`, newBolt)
                }
                NPC_SetSurfaceOnOff(`self`, va("torso_canister%d", (i + 1)), TURN_OFF)
                break
            }
        }
        i += 1
    }

    G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/chars/mark2/misc/mark2_pain"))

    // If any pods were blown off, kill him
    if `self`.count > 0 {
        // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NPC_Mark2_Pain", source: "oracle/codemp/game/NPC_AI_Mark2.c:80")
        var scratchDir = vec3_t()
        G_Damage(`self`, nil, nil, &scratchDir, nil, `self`.health, DAMAGE_NO_PROTECTION, MOD_UNKNOWN)
    }
}

/**
```
-------------------------
Mark2_Hunt
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:118
func Mark2_Hunt() {
    if NPCInfo!.goalEntity == nil {
        NPCInfo!.goalEntity = NPC!.enemy
    }

    // Turn toward him before moving towards him.
    NPC_FaceEnemy(true)

    NPCInfo!.combatMove = true
    NPC_MoveToGoal(true)
}

/**
```
-------------------------
Mark2_FireBlaster
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:137
func Mark2_FireBlaster(_ advance: Bool) {
    var muzzle1 = vec3_t()
    var enemy_org1 = vec3_t()
    var delta1 = vec3_t()
    var angleToEnemy1 = vec3_t()
    var forward = vec3_t()
    var vright = vec3_t()
    var up = vec3_t()
    var muzzle = vec3_t()
    var missile: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        let bolt: Int32 = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash")

        trap_G2API_GetBoltMatrix(NPC!.ghoul2, 0, bolt, boltMatrix, NPC!.r.currentAngles, NPC!.r.currentOrigin, level.time, nil, &NPC!.modelScale)

        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &muzzle1)

        if NPC!.health != 0 {
            CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &enemy_org1)
            delta1 = enemy_org1 - muzzle1
            vectoangles(delta1, &angleToEnemy1)
            AngleVectors(angleToEnemy1, &forward, &vright, &up)
        } else {
            AngleVectors(NPC!.r.currentAngles, &forward, &vright, &up)
        }

        G_PlayEffectID(G_EffectIndex("bryar/muzzle_flash"), muzzle1, forward)

        G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/mark2/misc/mark2_fire"))

        missile = CreateMissile(&muzzle1, forward, 1600, 10000, NPC!, false)

        missile!.classname = "bryar_proj"
        missile!.s.weapon = WP_BRYAR_PISTOL

        missile!.damage = 1
        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.methodOfDeath = MOD_BRYAR_PISTOL
        missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
    }
}

/**
```
-------------------------
Mark2_BlasterAttack
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:186
func Mark2_BlasterAttack(_ advance: Bool) {
    if TIMER_Done(NPC!, "attackDelay") {
        if NPCInfo!.localState == LSTATE_NONE {
            TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2000))
        } else {
            TIMER_Set(NPC!, "attackDelay", Q_irand(100, 500))
        }
        Mark2_FireBlaster(advance)
        return
    } else if advance {
        Mark2_Hunt()
    }
}

/**
```
-------------------------
Mark2_AttackDecision
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:212
func Mark2_AttackDecision() {
    let distance: Float
    let visible: Bool
    let advance: Bool

    NPC_FaceEnemy(true)

    distance = Float(Int32(DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)))
    visible = NPC_ClearLOS4(NPC!.enemy!)
    advance = Bool((distance > MIN_DISTANCE_SQR))

    // He's been ordered to get up
    if NPCInfo!.localState == LSTATE_RISINGUP {
        NPC!.flags &= ~FL_SHIELDED
        NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_RUN1START, SETANIM_FLAG_HOLD | SETANIM_FLAG_OVERRIDE)
        if (NPC!.client!.ps.legsTimer <= 0) && NPC!.client!.ps.torsoAnim == BOTH_RUN1START {
            NPCInfo!.localState = LSTATE_NONE // He's up again.
        }
        return
    }

    // If we cannot see our target, move to see it
    if (!visible) || (!NPC_FaceEnemy(true)) {
        // If he's going down or is down, make him get up
        if (NPCInfo!.localState == LSTATE_DOWN) || (NPCInfo!.localState == LSTATE_DROPPINGDOWN) {
            if TIMER_Done(NPC!, "downTime") {
                NPCInfo!.localState = LSTATE_RISINGUP
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_RUN1STOP, SETANIM_FLAG_HOLD | SETANIM_FLAG_OVERRIDE)
                TIMER_Set(NPC!, "runTime", Q_irand(3000, 8000)) // So he runs for a while before testing to see if he should drop down.
            }
        } else {
            Mark2_Hunt()
        }
        return
    }

    // He's down but he could advance if he wants to.
    if (advance) && (TIMER_Done(NPC!, "downTime")) && (NPCInfo!.localState == LSTATE_DOWN) {
        NPCInfo!.localState = LSTATE_RISINGUP
        NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_RUN1STOP, SETANIM_FLAG_HOLD | SETANIM_FLAG_OVERRIDE)
        TIMER_Set(NPC!, "runTime", Q_irand(3000, 8000)) // So he runs for a while before testing to see if he should drop down.
    }

    NPC_FaceEnemy(true)

    // Dropping down to shoot
    if NPCInfo!.localState == LSTATE_DROPPINGDOWN {
        NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_RUN1STOP, SETANIM_FLAG_HOLD | SETANIM_FLAG_OVERRIDE)
        TIMER_Set(NPC!, "downTime", Q_irand(3000, 9000))

        if (NPC!.client!.ps.legsTimer <= 0) && NPC!.client!.ps.torsoAnim == BOTH_RUN1STOP {
            NPC!.flags |= FL_SHIELDED
            NPCInfo!.localState = LSTATE_DOWN
        }
    } else if NPCInfo!.localState == LSTATE_DOWN {
        // He's down and shooting
        NPC!.flags |= FL_SHIELDED //only damagable by lightsabers and missiles

        Mark2_BlasterAttack(false)
    } else if TIMER_Done(NPC!, "runTime") {
        NPCInfo!.localState = LSTATE_DROPPINGDOWN
    } else if advance {
        // We can see enemy so shoot him if timer lets you.
        Mark2_BlasterAttack(advance)
    }
}

/**
```
-------------------------
Mark2_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:303
func Mark2_Patrol() {
    if NPC_CheckPlayerTeamStealth() {
        //		G_Sound( NPC, G_SoundIndex("sound/chars/mark1/misc/anger.wav"));
        NPC_UpdateAngles(true, true)
        return
    }

    //If we have somewhere to go, then do that
    if NPC!.enemy == nil {
        if UpdateGoal() != nil {
            ucmd.buttons |= BUTTON_WALKING
            NPC_MoveToGoal(true)
            NPC_UpdateAngles(true, true)
        }

        //randomly talk
        if TIMER_Done(NPC!, "patrolNoise") {
            //			G_Sound( NPC, G_SoundIndex(va("sound/chars/mark1/misc/talk%d.wav",	Q_irand(1, 4))));

            TIMER_Set(NPC!, "patrolNoise", Q_irand(2000, 4000))
        }
    }
}

/**
```
-------------------------
Mark2_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:337
func Mark2_Idle() {
    NPC_BSIdle()
}

/**
```
-------------------------
NPC_BSMark2_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark2.c:347
func NPC_BSMark2_Default() {
    if NPC!.enemy != nil {
        NPCInfo!.goalEntity = NPC!.enemy
        Mark2_AttackDecision()
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        Mark2_Patrol()
    } else {
        Mark2_Idle()
    }
}
