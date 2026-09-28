import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Atst.c:3
private let MIN_MELEE_RANGE = 640 as Int32

/// Source: oracle/codemp/game/NPC_AI_Atst.c:4
private let MIN_MELEE_RANGE_SQR = (MIN_MELEE_RANGE * MIN_MELEE_RANGE)

/// Source: oracle/codemp/game/NPC_AI_Atst.c:6
private let MIN_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC_AI_Atst.c:7
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Atst.c:9
private let TURN_OFF = 0x00000100 as Int32

/// Source: oracle/codemp/game/NPC_AI_Atst.c:11
private let LEFT_ARM_HEALTH = 40 as Int32

/// Source: oracle/codemp/game/NPC_AI_Atst.c:12
private let RIGHT_ARM_HEALTH = 40 as Int32

/**
```
-------------------------
NPC_ATST_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Atst.c:20
func NPC_ATST_Precache() {
    G_SoundIndex("sound/chars/atst/atst_damaged1")
    G_SoundIndex("sound/chars/atst/atst_damaged2")

    //	RegisterItem( BG_FindItemForWeapon( WP_ATST_MAIN ));	//precache the weapon
    //rwwFIXMEFIXME: add this weapon
    RegisterItem(BG_FindItemForWeapon(WP_BOWCASTER)!) //precache the weapon
    RegisterItem(BG_FindItemForWeapon(WP_ROCKET_LAUNCHER)!) //precache the weapon

    G_EffectIndex("env/med_explode2")
    //	G_EffectIndex( "smaller_chunks" );
    G_EffectIndex("blaster/smoke_bolton")
    G_EffectIndex("explosions/droidexplosion1")
}

/// Source: oracle/codemp/game/NPC_AI_Atst.c:66
func G_ATSTCheckPain(_ `self`: Entity, _ other: Entity, _ damage: Int32) {
    //int newBolt;
    //int hitLoc = gPainHitLoc;

    // The SDK also declares `rand`, so the call names the bg module.
    if (JKAMP_BG.rand() & 1) != 0 {
        G_SoundOnEnt(`self`, CHAN_LESS_ATTEN, "sound/chars/atst/atst_damaged1")
    } else {
        G_SoundOnEnt(`self`, CHAN_LESS_ATTEN, "sound/chars/atst/atst_damaged2")
    }

    /*
    if ((hitLoc==HL_ARM_LT) && (self->locationDamage[HL_ARM_LT] > LEFT_ARM_HEALTH))
    {
    if (self->locationDamage[hitLoc] >= LEFT_ARM_HEALTH)	// Blow it up?
    {
    newBolt = trap_G2API_AddBolt( self->ghoul2, 0, "*flash3" );
    if ( newBolt != -1 )
    {
    //				G_PlayEffect( "small_chunks", self->playerModel, self->genericBolt1, self->s.number);
    ATST_PlayEffect( self, trap_G2API_AddBolt(self->ghoul2, 0, "*flash3"), "env/med_explode2" );
    //G_PlayEffectID( G_EffectIndex("blaster/smoke_bolton"), self->playerModel, newBolt, self->s.number);
    //Maybe bother with this some other time.
    }

    NPC_SetSurfaceOnOff( self, "head_light_blaster_cann", TURN_OFF );
    }
    }
    else if ((hitLoc==HL_ARM_RT) && (self->locationDamage[HL_ARM_RT] > RIGHT_ARM_HEALTH))	// Blow it up?
    {
    if (self->locationDamage[hitLoc] >= RIGHT_ARM_HEALTH)
    {
    newBolt = trap_G2API_AddBolt( self->ghoul2, 0, "*flash4" );
    if ( newBolt != -1 )
    {
    //				G_PlayEffect( "small_chunks", self->playerModel, self->genericBolt2, self->s.number);
    ATST_PlayEffect( self, trap_G2API_AddBolt(self->ghoul2, 0, "*flash4"), "env/med_explode2" );
    //G_PlayEffect( "blaster/smoke_bolton", self->playerModel, newBolt, self->s.number);
    }

    NPC_SetSurfaceOnOff( self, "head_concussion_charger", TURN_OFF );
    }
    }
    */
}

/**
```
-------------------------
NPC_ATST_Pain
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Atst.c:119
func NPC_ATST_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    G_ATSTCheckPain(`self`, attacker, damage)
    NPC_Pain(`self`, attacker, damage)
}

/**
```
-------------------------
ATST_Hunt
-------------------------`
```
*/
/// Source: oracle/codemp/game/NPC_AI_Atst.c:130
func ATST_Hunt(_ visible: Bool, _ advance: Bool) {
    if NPCInfo!.goalEntity == nil {
        //hunt
        NPCInfo!.goalEntity = NPC!.enemy
    }

    NPCInfo!.combatMove = true

    NPC_MoveToGoal(true)
}

/**
```
-------------------------
ATST_Ranged
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Atst.c:149
func ATST_Ranged(_ visible: Bool, _ advance: Bool, _ altAttack: Bool) {
    if TIMER_Done(NPC!, "atkDelay") && visible {
        TIMER_Set(NPC!, "atkDelay", Q_irand(500, 3000))

        if altAttack {
            ucmd.buttons |= BUTTON_ATTACK | BUTTON_ALT_ATTACK
        } else {
            ucmd.buttons |= BUTTON_ATTACK
        }
    }

    if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        ATST_Hunt(visible, advance)
    }
}

/**
```
-------------------------
ATST_Attack
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Atst.c:177
func ATST_Attack() {
    var altAttack: Bool = false
    let blasterTest: Int32
    let chargerTest: Int32
    let weapon: Int32
    let distance: Float
    let distRate: distance_e
    let visible: Bool
    let advance: Bool

    if NPC_CheckEnemyExt(false) == false {
        NPC!.enemy = nil
        return
    }

    NPC_FaceEnemy(true)

    // Rate our distance to the target, and our visibilty
    distance = Float(Int32(DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)))
    distRate = (distance > MIN_MELEE_RANGE_SQR) ? DIST_LONG : DIST_MELEE
    visible = NPC_ClearLOS4(NPC!.enemy!)
    advance = Bool((distance > MIN_DISTANCE_SQR))

    // If we cannot see our target, move to see it
    if visible == false {
        if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
            ATST_Hunt(visible, advance)
            return
        }
    }

    // Decide what type of attack to do
    switch distRate {
    case DIST_MELEE:
        //		NPC_ChangeWeapon( WP_ATST_MAIN );
        break

    case DIST_LONG:
        //		NPC_ChangeWeapon( WP_ATST_SIDE );
        //rwwFIXMEFIXME: make atst weaps work.

        // See if the side weapons are there
        blasterTest = trap_G2API_GetSurfaceRenderStatus(NPC!.ghoul2, 0, "head_light_blaster_cann")
        chargerTest = trap_G2API_GetSurfaceRenderStatus(NPC!.ghoul2, 0, "head_concussion_charger")

        // It has both side weapons
        if blasterTest != -1 && !((blasterTest & TURN_OFF) != 0) && chargerTest != -1 && !((chargerTest & TURN_OFF) != 0) {
            weapon = Q_irand(0, 1) // 0 is blaster, 1 is charger (ALT SIDE)

            if weapon != 0 {
                altAttack = true
            } else {
                altAttack = false
            }
        } else if blasterTest != -1 && !((blasterTest & TURN_OFF) != 0) {
            altAttack = false
        } else if chargerTest != -1 && !((chargerTest & TURN_OFF) != 0) {
            altAttack = true
        } else {
            NPC_ChangeWeapon(WP_NONE)
        }

    default:
        break
    }

    NPC_FaceEnemy(true)

    ATST_Ranged(visible, advance, altAttack)
}

/**
```
-------------------------
ATST_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Atst.c:271
func ATST_Patrol() {
    if NPC_CheckPlayerTeamStealth() {
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
    }
}

/**
```
-------------------------
ATST_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Atst.c:297
func ATST_Idle() {
    NPC_BSIdle()

    NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_STAND1, SETANIM_FLAG_NORMAL)
}

/**
```
-------------------------
NPC_BSDroid_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Atst.c:310
func NPC_BSATST_Default() {
    if NPC!.enemy != nil {
        if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
            NPCInfo!.goalEntity = NPC!.enemy
        }
        ATST_Attack()
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        ATST_Patrol()
    } else {
        ATST_Idle()
    }
}
