import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:25
private let LSTATE_NONE: Int32 = 0
private let LSTATE_ASLEEP: Int32 = 1
private let LSTATE_WAKEUP: Int32 = 2
private let LSTATE_FIRED0: Int32 = 3
private let LSTATE_FIRED1: Int32 = 4
private let LSTATE_FIRED2: Int32 = 5
private let LSTATE_FIRED3: Int32 = 6
private let LSTATE_FIRED4: Int32 = 7

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:4
private let MIN_MELEE_RANGE = 320 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:5
private let MIN_MELEE_RANGE_SQR = (MIN_MELEE_RANGE * MIN_MELEE_RANGE)

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:7
private let MIN_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:8
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:10
private let TURN_OFF = 0x00000100 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:12
private let LEFT_ARM_HEALTH = 40 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:13
private let RIGHT_ARM_HEALTH = 40 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:14
private let AMMO_POD_HEALTH = 40 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:16
private let BOWCASTER_VELOCITY = 1300 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:17
let BOWCASTER_NPC_DAMAGE_EASY = 12 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:18
let BOWCASTER_NPC_DAMAGE_NORMAL = 24 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:19
let BOWCASTER_NPC_DAMAGE_HARD = 36 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:20
private let BOWCASTER_SIZE = 2 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:21
private let BOWCASTER_SPLASH_DAMAGE = 0 as Int32

/// Source: oracle/codemp/game/NPC_AI_Mark1.c:22
private let BOWCASTER_SPLASH_RADIUS = 0 as Int32

/**
```
-------------------------
NPC_Mark1_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:50
func NPC_Mark1_Precache() {
    G_SoundIndex("sound/chars/mark1/misc/mark1_wakeup")
    G_SoundIndex("sound/chars/mark1/misc/shutdown")
    G_SoundIndex("sound/chars/mark1/misc/walk")
    G_SoundIndex("sound/chars/mark1/misc/run")
    G_SoundIndex("sound/chars/mark1/misc/death1")
    G_SoundIndex("sound/chars/mark1/misc/death2")
    G_SoundIndex("sound/chars/mark1/misc/anger")
    G_SoundIndex("sound/chars/mark1/misc/mark1_fire")
    G_SoundIndex("sound/chars/mark1/misc/mark1_pain")
    G_SoundIndex("sound/chars/mark1/misc/mark1_explo")

    //	G_EffectIndex( "small_chunks");
    G_EffectIndex("env/med_explode2")
    G_EffectIndex("explosions/probeexplosion1")
    G_EffectIndex("blaster/smoke_bolton")
    G_EffectIndex("bryar/muzzle_flash")
    G_EffectIndex("explosions/droidexplosion1")

    RegisterItem(BG_FindItemForAmmo(AMMO_METAL_BOLTS)!)
    RegisterItem(BG_FindItemForAmmo(AMMO_BLASTER)!)
    RegisterItem(BG_FindItemForWeapon(WP_BOWCASTER)!)
    RegisterItem(BG_FindItemForWeapon(WP_BRYAR_PISTOL)!)
}

/**
```
-------------------------
NPC_Mark1_Part_Explode
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:81
func NPC_Mark1_Part_Explode(_ `self`: Entity, _ bolt: Int32) {
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

    //G_PlayEffectID( G_EffectIndex("blaster/smoke_bolton"), self->playerModel, bolt, self->s.number );
}

/**
```
-------------------------
Mark1_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:109
func Mark1_Idle() {
    NPC_BSIdle()

    NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_SLEEP1, SETANIM_FLAG_NORMAL)
}

/**
```
-------------------------
Mark1Dead_FireRocket
- Shoot the left weapon, the multi-blaster
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:123
func Mark1Dead_FireRocket() {
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        var muzzle1 = vec3_t()
        var muzzle_dir = vec3_t()
        var missile: Entity?

        let damage: Int32 = 50
        let bolt: Int32 = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash5")

        trap_G2API_GetBoltMatrix(NPC!.ghoul2, 0, bolt, boltMatrix, NPC!.r.currentAngles, NPC!.r.currentOrigin, level.time, nil, &NPC!.modelScale)

        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &muzzle1)
        BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &muzzle_dir)

        G_PlayEffectID(G_EffectIndex("bryar/muzzle_flash"), muzzle1, muzzle_dir)

        G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/mark1/misc/mark1_fire"))

        missile = CreateMissile(&muzzle1, muzzle_dir, Float(BOWCASTER_VELOCITY), 10000, NPC!, false)

        missile!.classname = "bowcaster_proj"
        missile!.s.weapon = WP_BOWCASTER

        missile!.r.maxs = vec3_t(Float(BOWCASTER_SIZE), Float(BOWCASTER_SIZE), Float(BOWCASTER_SIZE))
        missile!.r.mins = missile!.r.maxs * -1

        missile!.damage = damage
        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        //missile->methodOfDeath = MOD_ENERGY;
        missile!.methodOfDeath = MOD_ROCKET
        missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
        missile!.splashDamage = BOWCASTER_SPLASH_DAMAGE
        missile!.splashRadius = BOWCASTER_SPLASH_RADIUS

        // we don't want it to bounce
        missile!.bounceCount = 0
    }
}

/**
```
-------------------------
Mark1Dead_FireBlaster
- Shoot the left weapon, the multi-blaster
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:171
func Mark1Dead_FireBlaster() {
    var muzzle1 = vec3_t()
    var muzzle_dir = vec3_t()
    var missile: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        var bolt: Int32 = 0

        bolt = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash1")

        trap_G2API_GetBoltMatrix(NPC!.ghoul2, 0, bolt, boltMatrix, NPC!.r.currentAngles, NPC!.r.currentOrigin, level.time, nil, &NPC!.modelScale)

        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &muzzle1)
        BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &muzzle_dir)

        G_PlayEffectID(G_EffectIndex("bryar/muzzle_flash"), muzzle1, muzzle_dir)

        missile = CreateMissile(&muzzle1, muzzle_dir, 1600, 10000, NPC!, false)

        G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/mark1/misc/mark1_fire"))

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
Mark1_die
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:209
func Mark1_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32, _ dFlags: Int32, _ hitLoc: Int32) {
    /*
    int	anim;

    // Is he dead already?
    anim = self->client->ps.legsAnim;
    if (((anim==BOTH_DEATH1) || (anim==BOTH_DEATH2)) && (self->client->ps.torsoTimer<=0))
    {	// This is because self->health keeps getting zeroed out. HL_NONE acts as health in this case.
    self->locationDamage[HL_NONE] += damage;
    if (self->locationDamage[HL_NONE] > 50)
    {
    DeathFX(self);
    self->client->ps.eFlags |= EF_NODRAW;
    self->contents = CONTENTS_CORPSE;
    // G_FreeEntity( self ); // Is this safe?  I can't see why we'd mark it nodraw and then just leave it around??
    self->e_ThinkFunc = thinkF_G_FreeEntity;
    self->nextthink = level.time + FRAMETIME;
    }
    return;
    }
    */

    G_Sound(`self`, CHAN_AUTO, G_SoundIndex(va("sound/chars/mark1/misc/death%d.wav", Q_irand(1, 2))))

    // Choose a death anim
    if Q_irand(1, 10) > 5 {
        NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_DEATH2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    } else {
        NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_DEATH1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    }
}

/**
```
-------------------------
Mark1_dying
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:250
func Mark1_dying(_ `self`: Entity) {
    var num: Int32
    let newBolt: Int32

    if `self`.client!.ps.torsoTimer > 0 {
        if TIMER_Done(`self`, "dyingExplosion") {
            num = Q_irand(1, 3)

            // Find place to generate explosion
            if num == 1 {
                num = Q_irand(8, 10)
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, va("*flash%d", num))
                NPC_Mark1_Part_Explode(`self`, newBolt)
            } else {
                num = Q_irand(1, 6)
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, va("*torso_tube%d", num))
                NPC_Mark1_Part_Explode(`self`, newBolt)
                NPC_SetSurfaceOnOff(`self`, va("torso_tube%d", num), TURN_OFF)
            }

            TIMER_Set(`self`, "dyingExplosion", Q_irand(300, 1000))
        }


        //		int		dir;
        //		vec3_t	right;

        // Shove to the side
        //		AngleVectors( self->client->renderInfo.eyeAngles, NULL, right, NULL );
        //		VectorMA( self->client->ps.velocity, -80, right, self->client->ps.velocity );

        // See which weapons are there
        // Randomly fire blaster
        if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "l_arm") == 0 {
            if Q_irand(1, 5) == 1 {
                SaveNPCGlobals()
                SetNPCGlobals(`self`)
                Mark1Dead_FireBlaster()
                RestoreNPCGlobals()
            }
        }

        // Randomly fire rocket
        if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "r_arm") == 0 {
            if Q_irand(1, 10) == 1 {
                SaveNPCGlobals()
                SetNPCGlobals(`self`)
                Mark1Dead_FireRocket()
                RestoreNPCGlobals()
            }
        }
    }
}

/**
```
-------------------------
NPC_Mark1_Pain
- look at what was hit and see if it should be removed from the model.
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:320
func NPC_Mark1_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    var newBolt: Int32
    var i: Int32
    let chance: Int32
    let hitLoc: Int32 = gPainHitLoc

    NPC_Pain(`self`, attacker, damage)

    G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/chars/mark1/misc/mark1_pain"))

    // Hit in the CHEST???
    if hitLoc == HL_CHEST {
        chance = Q_irand(1, 4)

        if (chance == 1) && (damage > 5) {
            NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
        }
    } else if (hitLoc == HL_ARM_LT) && (`self`.locationDamage[HL_ARM_LT] > LEFT_ARM_HEALTH) {
        // Hit in the left arm?
        if `self`.locationDamage[hitLoc] >= LEFT_ARM_HEALTH {
            newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*flash3")
            if newBolt != -1 {
                NPC_Mark1_Part_Explode(`self`, newBolt)
            }

            NPC_SetSurfaceOnOff(`self`, "l_arm", TURN_OFF)
        }
    } else if (hitLoc == HL_ARM_RT) && (`self`.locationDamage[HL_ARM_RT] > RIGHT_ARM_HEALTH) {
        // Hit in the right arm?
        if `self`.locationDamage[hitLoc] >= RIGHT_ARM_HEALTH {
            newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*flash4")
            if newBolt != -1 {
                //				G_PlayEffect( "small_chunks", self->playerModel, self->genericBolt2, self->s.number);
                NPC_Mark1_Part_Explode(`self`, newBolt)
            }

            NPC_SetSurfaceOnOff(`self`, "r_arm", TURN_OFF)
        }
    } else {
        // Check ammo pods
        i = 0
        while i < 6 {
            if (hitLoc == HL_GENERIC1 + i) && (`self`.locationDamage[HL_GENERIC1 + i] > AMMO_POD_HEALTH) {
                if `self`.locationDamage[hitLoc] >= AMMO_POD_HEALTH {
                    newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, va("*torso_tube%d", (i + 1)))
                    if newBolt != -1 {
                        NPC_Mark1_Part_Explode(`self`, newBolt)
                    }
                    NPC_SetSurfaceOnOff(`self`, va("torso_tube%d", (i + 1)), TURN_OFF)
                    NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                    break
                }
            }
            i += 1
        }
    }

    // Are both guns shot off?
    if (trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "l_arm") > 0) && (trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "r_arm") > 0) {
        var dir: vec3_t? = nil
        G_Damage(`self`, nil, nil, &dir, nil, `self`.health, 0, MOD_UNKNOWN)
    }
}

/**
```
-------------------------
Mark1_Hunt
- look for enemy.
-------------------------`
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:404
func Mark1_Hunt() {
    if NPCInfo!.goalEntity == nil {
        NPCInfo!.goalEntity = NPC!.enemy
    }

    NPC_FaceEnemy(true)

    NPCInfo!.combatMove = true
    NPC_MoveToGoal(true)
}

/**
```
-------------------------
Mark1_FireBlaster
- Shoot the left weapon, the multi-blaster
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:424
func Mark1_FireBlaster() {
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
        var bolt: Int32 = 0

        // Which muzzle to fire from?
        if (NPCInfo!.localState <= LSTATE_FIRED0) || (NPCInfo!.localState == LSTATE_FIRED4) {
            NPCInfo!.localState = LSTATE_FIRED1
            bolt = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash1")
        } else if NPCInfo!.localState == LSTATE_FIRED1 {
            NPCInfo!.localState = LSTATE_FIRED2
            bolt = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash2")
        } else if NPCInfo!.localState == LSTATE_FIRED2 {
            NPCInfo!.localState = LSTATE_FIRED3
            bolt = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash3")
        } else {
            NPCInfo!.localState = LSTATE_FIRED4
            bolt = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash4")
        }

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

        G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/mark1/misc/mark1_fire"))

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
Mark1_BlasterAttack
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:495
func Mark1_BlasterAttack(_ advance: Bool) {
    var chance: Int32

    if TIMER_Done(NPC!, "attackDelay") {
        chance = Q_irand(1, 5)

        NPCInfo!.burstCount += 1

        if NPCInfo!.burstCount < 3 {
            chance = 2 // Force it to keep firing.
        } else if NPCInfo!.burstCount > 12 {
            NPCInfo!.burstCount = 0
            chance = 1 // Force it to stop firing.
        }

        // Stop firing.
        if chance == 1 {
            NPCInfo!.burstCount = 0
            TIMER_Set(NPC!, "attackDelay", Q_irand(1000, 3000))
            NPC!.client!.ps.torsoTimer = 0 // Just in case the firing anim is running.
        } else {
            if TIMER_Done(NPC!, "attackDelay2") {
                TIMER_Set(NPC!, "attackDelay2", Q_irand(50, 50))
                Mark1_FireBlaster()
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            }
            return
        }
    } else if advance {
        if NPC!.client!.ps.torsoAnim == BOTH_ATTACK1 {
            NPC!.client!.ps.torsoTimer = 0 // Just in case the firing anim is running.
        }
        Mark1_Hunt()
    } else {
        if NPC!.client!.ps.torsoAnim == BOTH_ATTACK1 {
            NPC!.client!.ps.torsoTimer = 0 // Just in case the firing anim is running.
        }
    }
}

/**
```
-------------------------
Mark1_FireRocket
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:555
func Mark1_FireRocket() {
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        var muzzle1 = vec3_t()
        var enemy_org1 = vec3_t()
        var delta1 = vec3_t()
        var angleToEnemy1 = vec3_t()
        var forward = vec3_t()
        var vright = vec3_t()
        var up = vec3_t()
        let bolt: Int32 = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash5")
        var missile: Entity?

        let damage: Int32 = 50

        trap_G2API_GetBoltMatrix(NPC!.ghoul2, 0, bolt, boltMatrix, NPC!.r.currentAngles, NPC!.r.currentOrigin, level.time, nil, &NPC!.modelScale)

        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &muzzle1)

        //	G_PlayEffect( "blaster/muzzle_flash", muzzle1 );

        CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &enemy_org1)
        delta1 = enemy_org1 - muzzle1
        vectoangles(delta1, &angleToEnemy1)
        AngleVectors(angleToEnemy1, &forward, &vright, &up)

        G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/mark1/misc/mark1_fire"))

        missile = CreateMissile(&muzzle1, forward, Float(BOWCASTER_VELOCITY), 10000, NPC!, false)

        missile!.classname = "bowcaster_proj"
        missile!.s.weapon = WP_BOWCASTER

        missile!.r.maxs = vec3_t(Float(BOWCASTER_SIZE), Float(BOWCASTER_SIZE), Float(BOWCASTER_SIZE))
        missile!.r.mins = missile!.r.maxs * -1

        missile!.damage = damage
        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.methodOfDeath = MOD_ROCKET
        missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
        missile!.splashDamage = BOWCASTER_SPLASH_DAMAGE
        missile!.splashRadius = BOWCASTER_SPLASH_RADIUS

        // we don't want it to bounce
        missile!.bounceCount = 0
    }
}

/**
```
-------------------------
Mark1_RocketAttack
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:606
func Mark1_RocketAttack(_ advance: Bool) {
    if TIMER_Done(NPC!, "attackDelay") {
        TIMER_Set(NPC!, "attackDelay", Q_irand(1000, 3000))
        NPC_SetAnim(NPC!, SETANIM_TORSO, BOTH_ATTACK2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
        Mark1_FireRocket()
    } else if advance {
        Mark1_Hunt()
    }
}

/**
```
-------------------------
Mark1_AttackDecision
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:625
func Mark1_AttackDecision() {
    let blasterTest: Int32
    let rocketTest: Int32
    let distance: Float
    var distRate: distance_e
    let visible: Bool
    let advance: Bool

    //randomly talk
    if TIMER_Done(NPC!, "patrolNoise") {
        if TIMER_Done(NPC!, "angerNoise") {
            //			G_Sound( NPC, G_SoundIndex(va("sound/chars/mark1/misc/talk%d.wav",	Q_irand(1, 4))));
            TIMER_Set(NPC!, "patrolNoise", Q_irand(4000, 10000))
        }
    }

    // Enemy is dead or he has no enemy.
    if (NPC!.enemy!.health < 1) || (NPC_CheckEnemyExt(false) == false) {
        NPC!.enemy = nil
        return
    }

    // Rate our distance to the target and visibility
    distance = Float(Int32(DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)))
    distRate = (distance > MIN_MELEE_RANGE_SQR) ? DIST_LONG : DIST_MELEE
    visible = NPC_ClearLOS4(NPC!.enemy!)
    advance = Bool((distance > MIN_DISTANCE_SQR))

    // If we cannot see our target, move to see it
    if (!visible) || (!NPC_FaceEnemy(true)) {
        Mark1_Hunt()
        return
    }

    // See if the side weapons are there
    blasterTest = trap_G2API_GetSurfaceRenderStatus(NPC!.ghoul2, 0, "l_arm")
    rocketTest = trap_G2API_GetSurfaceRenderStatus(NPC!.ghoul2, 0, "r_arm")

    // It has both side weapons
    if blasterTest == 0 && rocketTest == 0 {
    } else if blasterTest != -1 && blasterTest != 0 {
        distRate = DIST_LONG
    } else if rocketTest != -1 && rocketTest != 0 {
        distRate = DIST_MELEE
    } else {
        NPC!.health = 0
        NPC!.client!.ps.stats[STAT_HEALTH] = 0
        //GEntity_DieFunc(NPC, NPC, NPC, 100, MOD_UNKNOWN);
        if NPC!.die != nil {
            NPC!.runDie(NPC, NPC, 100, MOD_UNKNOWN)
        }
    }

    // We can see enemy so shoot him if timers let you.
    NPC_FaceEnemy(true)

    if distRate == DIST_MELEE {
        Mark1_BlasterAttack(advance)
    } else if distRate == DIST_LONG {
        Mark1_RocketAttack(advance)
    }
}

/**
```
-------------------------
Mark1_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:711
func Mark1_Patrol() {
    if NPC_CheckPlayerTeamStealth() {
        G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/mark1/misc/mark1_wakeup"))
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
        //		if (TIMER_Done(NPC,"patrolNoise"))
        //		{
        //			G_Sound( NPC, G_SoundIndex(va("sound/chars/mark1/misc/talk%d.wav",	Q_irand(1, 4))));
        //
        //			TIMER_Set( NPC, "patrolNoise", Q_irand( 2000, 4000 ) );
        //		}
    }
}

/**
```
-------------------------
NPC_BSMark1_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Mark1.c:747
func NPC_BSMark1_Default() {
    //NPC->e_DieFunc = dieF_Mark1_die;

    if NPC!.enemy != nil {
        NPCInfo!.goalEntity = NPC!.enemy
        Mark1_AttackDecision()
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        Mark1_Patrol()
    } else {
        Mark1_Idle()
    }
}
