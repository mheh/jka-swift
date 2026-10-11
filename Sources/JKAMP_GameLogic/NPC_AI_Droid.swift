import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Droid.c:10
private let LSTATE_NONE: Int32 = 0
private let LSTATE_BACKINGUP: Int32 = 1
private let LSTATE_SPINNING: Int32 = 2
private let LSTATE_PAIN: Int32 = 3
private let LSTATE_DROP: Int32 = 4

/// Source: oracle/codemp/game/NPC_AI_Droid.c:7
private let TURN_OFF = 0x00000100 as Int32

/**
```
-------------------------
R2D2_PartsMove
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:24
func R2D2_PartsMove() {
    // Front 'eye' lense
    if TIMER_Done(NPC!, "eyeDelay") {
        NPC!.pos1[1] = AngleNormalize360(NPC!.pos1[1])

        NPC!.pos1[0] += Q_irand(-20, 20) // Roll
        NPC!.pos1[1] = Float(Q_irand(-20, 20))
        NPC!.pos1[2] = Float(Q_irand(-20, 20))

        /*
        if (NPC->genericBone1)
        {
        gi.G2API_SetBoneAnglesIndex( &NPC->ghoul2[NPC->playerModel], NPC->genericBone1, NPC->pos1, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, NULL );
        }
        */
        NPC_SetBoneAngles(NPC!, "f_eye", NPC!.pos1)


        TIMER_Set(NPC!, "eyeDelay", Q_irand(100, 1000))
    }
}

/**
```
-------------------------
NPC_BSDroid_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:53
func Droid_Idle() {
    //	VectorCopy( NPCInfo->investigateGoal, lookPos );

    //	NPC_FacePosition( lookPos );
}

/**
```
-------------------------
R2D2_TurnAnims
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:65
func R2D2_TurnAnims() {
    let turndelta: Float
    let anim: Int32

    turndelta = AngleDelta(NPC!.r.currentAngles[YAW], NPCInfo!.desiredYaw)

    if (abs(turndelta) > 20) && ((NPC!.client!.NPC_class == CLASS_R2D2) || (NPC!.client!.NPC_class == CLASS_R5D2)) {
        anim = NPC!.client!.ps.legsAnim
        if turndelta < 0 {
            if anim != BOTH_TURN_LEFT1 {
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_TURN_LEFT1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            }
        } else {
            if anim != BOTH_TURN_RIGHT1 {
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_TURN_RIGHT1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            }
        }
    } else {
        NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_RUN1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    }
}

/**
```
-------------------------
Droid_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:102
func Droid_Patrol() {
    NPC!.pos1[1] = AngleNormalize360(NPC!.pos1[1])

    if NPC!.client != nil && NPC!.client!.NPC_class != CLASS_GONK {
        if NPC!.client!.NPC_class != CLASS_R5D2 {
            //he doesn't have an eye.
            R2D2_PartsMove() // Get his eye moving.
        }
        R2D2_TurnAnims()
    }

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons |= BUTTON_WALKING
        NPC_MoveToGoal(true)

        if NPC!.client != nil && NPC!.client!.NPC_class == CLASS_MOUSE {
            NPCInfo!.desiredYaw = Float(Double(NPCInfo!.desiredYaw) + sin(Double(level.time) * 0.5) * 25) // Weaves side to side a little

            if TIMER_Done(NPC!, "patrolNoise") {
                G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/mouse/misc/mousego%d.wav", Q_irand(1, 3)))

                TIMER_Set(NPC!, "patrolNoise", Q_irand(2000, 4000))
            }
        } else if NPC!.client != nil && NPC!.client!.NPC_class == CLASS_R2D2 {
            if TIMER_Done(NPC!, "patrolNoise") {
                G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/r2d2/misc/r2d2talk0%d.wav", Q_irand(1, 3)))

                TIMER_Set(NPC!, "patrolNoise", Q_irand(2000, 4000))
            }
        } else if NPC!.client != nil && NPC!.client!.NPC_class == CLASS_R5D2 {
            if TIMER_Done(NPC!, "patrolNoise") {
                G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/r5d2/misc/r5talk%d.wav", Q_irand(1, 4)))

                TIMER_Set(NPC!, "patrolNoise", Q_irand(2000, 4000))
            }
        }
        if NPC!.client != nil && NPC!.client!.NPC_class == CLASS_GONK {
            if TIMER_Done(NPC!, "patrolNoise") {
                G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/gonk/misc/gonktalk%d.wav", Q_irand(1, 2)))

                TIMER_Set(NPC!, "patrolNoise", Q_irand(2000, 4000))
            }
        }
        //		else
        //		{
        //			R5D2_LookAround();
        //		}
    }

    NPC_UpdateAngles(true, true)
}

/**
```
-------------------------
Droid_Run
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:175
func Droid_Run() {
    R2D2_PartsMove()

    if NPCInfo!.localState == LSTATE_BACKINGUP {
        ucmd.forwardmove = -127
        NPCInfo!.desiredYaw += 5

        NPCInfo!.localState = LSTATE_NONE // So he doesn't constantly backup.
    } else {
        ucmd.forwardmove = 64
        //If we have somewhere to go, then do that
        if UpdateGoal() != nil {
            if NPC_MoveToGoal(false) {
                NPCInfo!.desiredYaw = Float(Double(NPCInfo!.desiredYaw) + sin(Double(level.time) * 0.5) * 5) // Weaves side to side a little
            }
        }
    }

    NPC_UpdateAngles(true, true)
}

/**
```
-------------------------
void Droid_Spin( void )
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:207
func Droid_Spin() {
    var dir = vec3_t(0, 0, 1)

    R2D2_TurnAnims()


    // Head is gone, spin and spark
    if NPC!.client!.NPC_class == CLASS_R5D2 || NPC!.client!.NPC_class == CLASS_R2D2 {
        // No head?
        if trap_G2API_GetSurfaceRenderStatus(NPC!.ghoul2, 0, "head") > 0 {
            if TIMER_Done(NPC!, "smoke") && !TIMER_Done(NPC!, "droidsmoketotal") {
                TIMER_Set(NPC!, "smoke", 100)
                G_PlayEffectID(G_EffectIndex("volumetric/droid_smoke"), NPC!.r.currentOrigin, dir)
            }

            if TIMER_Done(NPC!, "droidspark") {
                TIMER_Set(NPC!, "droidspark", Q_irand(100, 500))
                G_PlayEffectID(G_EffectIndex("sparks/spark"), NPC!.r.currentOrigin, dir)
            }

            ucmd.forwardmove = Q_irand(-64, 64)

            if TIMER_Done(NPC!, "roam") {
                TIMER_Set(NPC!, "roam", Q_irand(250, 1000))
                NPCInfo!.desiredYaw = Float(Q_irand(0, 360)) // Go in random directions
            }
        } else {
            if TIMER_Done(NPC!, "roam") {
                NPCInfo!.localState = LSTATE_NONE
            } else {
                NPCInfo!.desiredYaw = AngleNormalize360(NPCInfo!.desiredYaw + 40) // Spin around
            }
        }
    } else {
        if TIMER_Done(NPC!, "roam") {
            NPCInfo!.localState = LSTATE_NONE
        } else {
            NPCInfo!.desiredYaw = AngleNormalize360(NPCInfo!.desiredYaw + 40) // Spin around
        }
    }

    NPC_UpdateAngles(true, true)
}

/**
```
-------------------------
NPC_BSDroid_Pain
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:273
func NPC_Droid_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    let other: Entity? = attacker
    var anim: Int32
    let mod: Int32 = gPainMOD
    var pain_chance: Float

    `self`.s.angles = `self`.NPC!.lastPathAngles

    if `self`.client!.NPC_class == CLASS_R5D2 {
        pain_chance = NPC_GetPainChance(`self`, damage)

        // Put it in pain
        // The SDK also declares `random`, so the call names the bg module.
        if mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT || JKAMP_BG.random() < pain_chance {
            // Health is between 0-30 or was hit by a DEMP2 so pop his head
            if `self`.s.m_iVehicleNum == 0 && (`self`.health < 30 || mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT) {
                if !((`self`.spawnflags & 2) != 0) {
                    if (`self`.NPC!.localState != LSTATE_SPINNING) && (trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "head") == 0) {
                        NPC_SetSurfaceOnOff(`self`, "head", TURN_OFF)

                        if `self`.client!.ps.m_iVehicleNum != 0 {
                            var up = vec3_t()
                            // Raven passes NULL for the `forward` and `right` outputs.
                            var scratchForward = vec3_t()
                            var scratchRight = vec3_t()
                            AngleVectors(`self`.r.currentAngles, &scratchForward, &scratchRight, &up)
                            G_PlayEffectID(G_EffectIndex("chunks/r5d2head_veh"), `self`.r.currentOrigin, up)
                        } else {
                            G_PlayEffectID(G_EffectIndex("small_chunks"), `self`.r.currentOrigin, vec3_origin)
                            G_PlayEffectID(G_EffectIndex("chunks/r5d2head"), `self`.r.currentOrigin, vec3_origin)
                        }

                        //self->s.powerups |= ( 1 << PW_SHOCKED );
                        //self->client->ps.powerups[PW_SHOCKED] = level.time + 3000;
                        `self`.client!.ps.electrifyTime = level.time + 3000

                        TIMER_Set(`self`, "droidsmoketotal", 5000)
                        TIMER_Set(`self`, "droidspark", 100)
                        `self`.NPC!.localState = LSTATE_SPINNING
                    }
                }
            } else {
                // Just give him normal pain for a little while
                anim = `self`.client!.ps.legsAnim

                if anim == BOTH_STAND2 {
                    anim = BOTH_PAIN1
                } else {
                    anim = BOTH_PAIN2
                }

                NPC_SetAnim(`self`, SETANIM_BOTH, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

                // Spin around in pain
                `self`.NPC!.localState = LSTATE_SPINNING
                TIMER_Set(`self`, "roam", Q_irand(1000, 2000))
            }
        }
    } else if `self`.client!.NPC_class == CLASS_MOUSE {
        if mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT {
            `self`.NPC!.localState = LSTATE_SPINNING
            //self->s.powerups |= ( 1 << PW_SHOCKED );
            //self->client->ps.powerups[PW_SHOCKED] = level.time + 3000;
            `self`.client!.ps.electrifyTime = level.time + 3000
        } else {
            `self`.NPC!.localState = LSTATE_BACKINGUP
        }

        `self`.NPC!.scriptFlags &= ~SCF_LOOK_FOR_ENEMIES
    } else if (`self`.client!.NPC_class == CLASS_R2D2) {
        pain_chance = NPC_GetPainChance(`self`, damage)

        // The SDK also declares `random`, so the call names the bg module.
        if mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT || JKAMP_BG.random() < pain_chance {
            // Health is between 0-30 or was hit by a DEMP2 so pop his head
            if `self`.s.m_iVehicleNum == 0 && (`self`.health < 30 || mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT) {
                if !((`self`.spawnflags & 2) != 0) {
                    if (`self`.NPC!.localState != LSTATE_SPINNING) && (trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "head") == 0) {
                        NPC_SetSurfaceOnOff(`self`, "head", TURN_OFF)

                        if `self`.client!.ps.m_iVehicleNum != 0 {
                            var up = vec3_t()
                            // Raven passes NULL for the `forward` and `right` outputs.
                            var scratchForward2 = vec3_t()
                            var scratchRight2 = vec3_t()
                            AngleVectors(`self`.r.currentAngles, &scratchForward2, &scratchRight2, &up)
                            G_PlayEffectID(G_EffectIndex("chunks/r2d2head_veh"), `self`.r.currentOrigin, up)
                        } else {
                            G_PlayEffectID(G_EffectIndex("small_chunks"), `self`.r.currentOrigin, vec3_origin)
                            G_PlayEffectID(G_EffectIndex("chunks/r2d2head"), `self`.r.currentOrigin, vec3_origin)
                        }

                        //self->s.powerups |= ( 1 << PW_SHOCKED );
                        //self->client->ps.powerups[PW_SHOCKED] = level.time + 3000;
                        `self`.client!.ps.electrifyTime = level.time + 3000

                        TIMER_Set(`self`, "droidsmoketotal", 5000)
                        TIMER_Set(`self`, "droidspark", 100)
                        `self`.NPC!.localState = LSTATE_SPINNING
                    }
                }
            } else {
                // Just give him normal pain for a little while
                anim = `self`.client!.ps.legsAnim

                if anim == BOTH_STAND2 {
                    anim = BOTH_PAIN1
                } else {
                    anim = BOTH_PAIN2
                }

                NPC_SetAnim(`self`, SETANIM_BOTH, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

                // Spin around in pain
                `self`.NPC!.localState = LSTATE_SPINNING
                TIMER_Set(`self`, "roam", Q_irand(1000, 2000))
            }
        }
    } else if `self`.client!.NPC_class == CLASS_INTERROGATOR && (mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT) && other != nil {
        var dir = vec3_t()

        dir = `self`.r.currentOrigin - other!.r.currentOrigin
        VectorNormalize(&dir)

        _VectorMA(`self`.client!.ps.velocity, 550, dir, &`self`.client!.ps.velocity)
        `self`.client!.ps.velocity[2] -= 127
    }

    NPC_Pain(`self`, attacker, damage)
}

/**
```
-------------------------
Droid_Pain
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:442
func Droid_Pain() {
    if TIMER_Done(NPC!, "droidpain") {
        NPCInfo!.localState = LSTATE_NONE
    }
}

/**
```
-------------------------
NPC_Mouse_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:455
func NPC_Mouse_Precache() {
    var i: Int32

    i = 1
    while i < 4 {
        G_SoundIndex(va("sound/chars/mouse/misc/mousego%d.wav", i))
        i += 1
    }

    G_EffectIndex("env/small_explode")
    G_SoundIndex("sound/chars/mouse/misc/death1")
    G_SoundIndex("sound/chars/mouse/misc/mouse_lp")
}

/**
```
-------------------------
NPC_R5D2_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:474
func NPC_R5D2_Precache() {
    var i: Int32

    i = 1
    while i < 5 {
        G_SoundIndex(va("sound/chars/r5d2/misc/r5talk%d.wav", i))
        i += 1
    }
    //G_SoundIndex( "sound/chars/r5d2/misc/falling1.wav" );
    G_SoundIndex("sound/chars/mark2/misc/mark2_explo") // ??
    G_SoundIndex("sound/chars/r2d2/misc/r2_move_lp2.wav")
    G_EffectIndex("env/med_explode")
    G_EffectIndex("volumetric/droid_smoke")
    G_EffectIndex("sparks/spark")
    G_EffectIndex("chunks/r5d2head")
    G_EffectIndex("chunks/r5d2head_veh")
}

/**
```
-------------------------
NPC_R2D2_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:497
func NPC_R2D2_Precache() {
    var i: Int32

    i = 1
    while i < 4 {
        G_SoundIndex(va("sound/chars/r2d2/misc/r2d2talk0%d.wav", i))
        i += 1
    }
    //G_SoundIndex( "sound/chars/r2d2/misc/falling1.wav" );
    G_SoundIndex("sound/chars/mark2/misc/mark2_explo") // ??
    G_SoundIndex("sound/chars/r2d2/misc/r2_move_lp.wav")
    G_EffectIndex("env/med_explode")
    G_EffectIndex("volumetric/droid_smoke")
    G_EffectIndex("sparks/spark")
    G_EffectIndex("chunks/r2d2head")
    G_EffectIndex("chunks/r2d2head_veh")
}

/**
```
-------------------------
NPC_Gonk_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:520
func NPC_Gonk_Precache() {
    G_SoundIndex("sound/chars/gonk/misc/gonktalk1.wav")
    G_SoundIndex("sound/chars/gonk/misc/gonktalk2.wav")

    G_SoundIndex("sound/chars/gonk/misc/death1.wav")
    G_SoundIndex("sound/chars/gonk/misc/death2.wav")
    G_SoundIndex("sound/chars/gonk/misc/death3.wav")

    G_EffectIndex("env/med_explode")
}

/**
```
-------------------------
NPC_Protocol_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:537
func NPC_Protocol_Precache() {
    G_SoundIndex("sound/chars/mark2/misc/mark2_explo")
    G_EffectIndex("env/med_explode")
}

/**
```
-------------------------
NPC_BSDroid_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Droid.c:597
func NPC_BSDroid_Default() {
    if NPCInfo!.localState == LSTATE_SPINNING {
        Droid_Spin()
    } else if NPCInfo!.localState == LSTATE_PAIN {
        Droid_Pain()
    } else if NPCInfo!.localState == LSTATE_DROP {
        NPC_UpdateAngles(true, true)
        ucmd.upmove = Int32(crandom() * 64)
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        Droid_Patrol()
    } else {
        Droid_Run()
    }
}
