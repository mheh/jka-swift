import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:8
private let VELOCITY_DECAY = 0.7 as Float

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:10
private let MIN_MELEE_RANGE = 320 as Int32

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:11
private let MIN_MELEE_RANGE_SQR = (MIN_MELEE_RANGE * MIN_MELEE_RANGE)

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:13
private let MIN_DISTANCE = 80 as Int32

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:14
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:16
let SEEKER_STRAFE_VEL = 100 as Int32

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:17
let SEEKER_STRAFE_DIS = 200 as Int32

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:18
let SEEKER_UPWARD_PUSH = 32 as Int32

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:20
let SEEKER_FORWARD_BASE_SPEED = 10 as Int32

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:21
let SEEKER_FORWARD_MULTIPLIER = 2 as Int32

/// Source: oracle/codemp/game/NPC_AI_Seeker.c:23
let SEEKER_SEEK_RADIUS = 1024 as Int32

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:26
func NPC_Seeker_Precache() {
    G_SoundIndex("sound/chars/seeker/misc/fire.wav")
    G_SoundIndex("sound/chars/seeker/misc/hiss.wav")
    G_EffectIndex("env/small_explode")
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:34
func NPC_Seeker_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    if !((`self`.NPC!.aiFlags & NPCAI_CUSTOM_GRAVITY) != 0) {
        //void G_Damage( gentity_t *targ, gentity_t *inflictor, gentity_t *attacker, vec3_t dir, vec3_t point, int damage, int dflags, int mod, int hitLoc=HL_NONE );
        // Port-note: A cast to `float *` the draft has no view for.
        // Raven wrote: G_Damage( self, NULL, NULL, (float*)vec3_origin, (float*)vec3_origin, 999, 0, MOD_FALLING )
        portMissing("NPC_Seeker_Pain", source: "oracle/codemp/game/NPC_AI_Seeker.c:34")
    }

    SaveNPCGlobals()
    SetNPCGlobals(`self`)
    Seeker_Strafe()
    RestoreNPCGlobals()
    NPC_Pain(`self`, attacker, damage)
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:49
func Seeker_MaintainHeight() {
    var dif: Float

    // Update our angles regardless
    NPC_UpdateAngles(true, true)

    // If we have an enemy, we should try to hover at or a little below enemy eye level
    if NPC!.enemy != nil {
        if TIMER_Done(NPC!, "heightChange") {
            var difFactor: Float

            TIMER_Set(NPC!, "heightChange", Q_irand(1000, 3000))

            // Find the height difference
            dif = (NPC!.enemy!.r.currentOrigin[2] + flrand(NPC!.enemy!.r.maxs[2] / 2, NPC!.enemy!.r.maxs[2] + 8)) - NPC!.r.currentOrigin[2]

            difFactor = 1.0
            if NPC!.client!.NPC_class == CLASS_BOBAFETT {
                if TIMER_Done(NPC!, "flameTime") {
                    difFactor = 10.0
                }
            }

            // cap to prevent dramatic height shifts
            if abs(dif) > 2 * difFactor {
                if abs(dif) > 24 * difFactor {
                    dif = (dif < 0 ? -24 * difFactor : 24 * difFactor)
                }

                NPC!.client!.ps.velocity[2] = (NPC!.client!.ps.velocity[2] + dif) / 2
            }
            if NPC!.client!.NPC_class == CLASS_BOBAFETT {
                NPC!.client!.ps.velocity[2] *= flrand(0.85, 3.0)
            }
        }
    } else {
        var goal: Entity? = nil

        if NPCInfo!.goalEntity != nil {
            goal = NPCInfo!.goalEntity
        } else {
            goal = NPCInfo!.lastGoalEntity
        }
        if goal != nil {
            dif = goal!.r.currentOrigin[2] - NPC!.r.currentOrigin[2]

            if abs(dif) > 24 {
                ucmd.upmove = (ucmd.upmove < 0 ? -4 : 4)
            } else {
                if NPC!.client!.ps.velocity[2] != 0 {
                    NPC!.client!.ps.velocity[2] *= VELOCITY_DECAY

                    if abs(NPC!.client!.ps.velocity[2]) < 2 {
                        NPC!.client!.ps.velocity[2] = 0
                    }
                }
            }
        }
    }

    // Apply friction
    if NPC!.client!.ps.velocity[0] != 0 {
        NPC!.client!.ps.velocity[0] *= VELOCITY_DECAY

        if abs(NPC!.client!.ps.velocity[0]) < 1 {
            NPC!.client!.ps.velocity[0] = 0
        }
    }

    if NPC!.client!.ps.velocity[1] != 0 {
        NPC!.client!.ps.velocity[1] *= VELOCITY_DECAY

        if abs(NPC!.client!.ps.velocity[1]) < 1 {
            NPC!.client!.ps.velocity[1] = 0
        }
    }
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:151
func Seeker_Strafe() {
    var side: Int32 = 0
    var end = vec3_t()
    var right = vec3_t()
    var dir = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in

        // The SDK also declares `random`, so the call names the bg module.
        if JKAMP_BG.random() > 0.7 || NPC!.enemy == nil || NPC!.enemy!.client == nil {
            // Do a regular style strafe
            // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("Seeker_Strafe", source: "oracle/codemp/game/NPC_AI_Seeker.c:151")
            var scratchForward = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("Seeker_Strafe", source: "oracle/codemp/game/NPC_AI_Seeker.c:151")
            var scratchUp = vec3_t()
            AngleVectors(NPC!.client!.renderInfo.eyeAngles, &scratchForward, &right, &scratchUp)

            // Pick a random strafe direction, then check to see if doing a strafe would be
            //	reasonably valid
            // The SDK also declares `rand`, so the call names the bg module.
            side = (JKAMP_BG.rand() & 1) != 0 ? -1 : 1
            _VectorMA(NPC!.r.currentOrigin, Float(SEEKER_STRAFE_DIS * side), right, &end)

            // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
            portMissing("Seeker_Strafe", source: "oracle/codemp/game/NPC_AI_Seeker.c:151")
            // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
            portMissing("Seeker_Strafe", source: "oracle/codemp/game/NPC_AI_Seeker.c:151")
            trap_Trace(tr, NPC!.r.currentOrigin, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SOLID)

            // Close enough
            if tr.fraction > 0.9 {
                var vel: Float = Float(SEEKER_STRAFE_VEL)
                var upPush: Float = Float(SEEKER_UPWARD_PUSH)
                if NPC!.client!.NPC_class != CLASS_BOBAFETT {
                    G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/seeker/misc/hiss"))
                } else {
                    vel *= 3.0
                    upPush *= 4.0
                }
                _VectorMA(NPC!.client!.ps.velocity, vel * side, right, &NPC!.client!.ps.velocity)
                // Add a slight upward push
                NPC!.client!.ps.velocity[2] += upPush

                // The SDK also declares `random`, so the call names the bg module.
                NPCInfo!.standTime = Int32(level.time + 1000 + JKAMP_BG.random() * 500)
            }
        } else {
            var stDis: Float = 0

            // Do a strafe to try and keep on the side of their enemy
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("Seeker_Strafe", source: "oracle/codemp/game/NPC_AI_Seeker.c:151")
            var scratchUp2 = vec3_t()
            AngleVectors(NPC!.enemy!.client!.renderInfo.eyeAngles, &dir, &right, &scratchUp2)

            // Pick a random side
            // The SDK also declares `rand`, so the call names the bg module.
            side = (JKAMP_BG.rand() & 1) != 0 ? -1 : 1
            stDis = Float(SEEKER_STRAFE_DIS)
            if NPC!.client!.NPC_class == CLASS_BOBAFETT {
                stDis *= 2.0
            }
            _VectorMA(NPC!.enemy!.r.currentOrigin, stDis * side, right, &end)

            // then add a very small bit of random in front of/behind the player action
            _VectorMA(end, crandom() * 25, dir, &end)

            // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
            portMissing("Seeker_Strafe", source: "oracle/codemp/game/NPC_AI_Seeker.c:151")
            // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
            portMissing("Seeker_Strafe", source: "oracle/codemp/game/NPC_AI_Seeker.c:151")
            trap_Trace(tr, NPC!.r.currentOrigin, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SOLID)

            // Close enough
            if tr.fraction > 0.9 {
                var dis: Float = 0
                var upPush: Float = 0

                dir = tr.endpos - NPC!.r.currentOrigin
                dir[2] = Float(Double(dir[2]) * 0.25) // do less upward change
                dis = VectorNormalize(&dir)

                // Try to move the desired enemy side
                _VectorMA(NPC!.client!.ps.velocity, dis, dir, &NPC!.client!.ps.velocity)

                upPush = Float(SEEKER_UPWARD_PUSH)
                if NPC!.client!.NPC_class != CLASS_BOBAFETT {
                    G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/seeker/misc/hiss"))
                } else {
                    upPush *= 4.0
                }

                // Add a slight upward push
                NPC!.client!.ps.velocity[2] += upPush

                // The SDK also declares `random`, so the call names the bg module.
                NPCInfo!.standTime = Int32(level.time + 2500 + JKAMP_BG.random() * 500)
            }
        }
    }
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:242
func Seeker_Hunt(_ visible: Bool, _ advance: Bool) {
    var distance: Float = 0
    let speed: Float
    var forward = vec3_t()

    NPC_FaceEnemy(true)

    // If we're not supposed to stand still, pursue the player
    if NPCInfo!.standTime < level.time {
        // Only strafe when we can see the player
        if visible {
            Seeker_Strafe()
            return
        }
    }

    // If we don't want to advance, stop here
    if advance == false {
        return
    }

    // Only try and navigate if the player is visible
    if visible == false {
        // Move towards our goal
        NPCInfo!.goalEntity = NPC!.enemy
        NPCInfo!.goalRadius = 24

        // Get our direction from the navigator if we can't see our target
        if NPC_GetMoveDirection(&forward, &distance) == false {
            return
        }
    } else {
        forward = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
        distance = VectorNormalize(&forward)
    }

    speed = Float(SEEKER_FORWARD_BASE_SPEED + SEEKER_FORWARD_MULTIPLIER * g_spskill.integer)
    _VectorMA(NPC!.client!.ps.velocity, speed, forward, &NPC!.client!.ps.velocity)
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:290
func Seeker_Fire() {
    var dir = vec3_t()
    var enemy_org = vec3_t()
    var muzzle = vec3_t()
    var missile: Entity?

    CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &enemy_org)
    dir = enemy_org - NPC!.r.currentOrigin
    VectorNormalize(&dir)

    // move a bit forward in the direction we shall shoot in so that the bolt doesn't poke out the other side of the seeker
    _VectorMA(NPC!.r.currentOrigin, 15, dir, &muzzle)

    missile = CreateMissile(&muzzle, dir, 1000, 10000, NPC!, false)

    G_PlayEffectID(G_EffectIndex("blaster/muzzle_flash"), NPC!.r.currentOrigin, dir)

    missile!.classname = "blaster"
    missile!.s.weapon = WP_BLASTER

    missile!.damage = 5
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = MOD_BLASTER
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
    if NPC!.r.ownerNum < ENTITYNUM_NONE {
        missile!.r.ownerNum = NPC!.r.ownerNum
    }
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:320
func Seeker_Ranged(_ visible: Bool, _ advance: Bool) {
    if NPC!.client!.NPC_class != CLASS_BOBAFETT {
        if NPC!.count > 0 {
            if TIMER_Done(NPC!, "attackDelay") {
                TIMER_Set(NPC!, "attackDelay", Q_irand(250, 2500))
                Seeker_Fire()
                NPC!.count -= 1
            }
        } else {
            // out of ammo, so let it die...give it a push up so it can fall more and blow up on impact
            //		NPC->client->ps.gravity = 900;
            //		NPC->svFlags &= ~SVF_CUSTOM_GRAVITY;
            //		NPC->client->ps.velocity[2] += 16;
            // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("Seeker_Ranged", source: "oracle/codemp/game/NPC_AI_Seeker.c:320")
            var scratchDir = vec3_t()
            G_Damage(NPC!, NPC, NPC, &scratchDir, nil, 999, 0, MOD_UNKNOWN)
        }
    }

    if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        Seeker_Hunt(visible, advance)
    }
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:350
func Seeker_Attack() {
    let distance: Float
    let visible: Bool
    var advance: Bool

    // Always keep a good height off the ground
    Seeker_MaintainHeight()

    // Rate our distance to the target, and our visibilty
    distance = DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)
    visible = NPC_ClearLOS4(NPC!.enemy!)
    advance = Bool((distance > MIN_DISTANCE_SQR))

    if NPC!.client!.NPC_class == CLASS_BOBAFETT {
        advance = Bool((distance > (200.0 * 200.0)))
    }

    // If we cannot see our target, move to see it
    if visible == false {
        if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
            Seeker_Hunt(visible, advance)
            return
        }
    }

    Seeker_Ranged(visible, advance)
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:383
func Seeker_FindEnemy() {
    let numFound: Int32
    var dis: Float
    var bestDis: Float = Float(SEEKER_SEEK_RADIUS * SEEKER_SEEK_RADIUS + 1)
    var mins = vec3_t()
    var maxs = vec3_t()
    var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
    var ent: Entity?
    var best: Entity? = nil
    var i: Int32

    maxs = vec3_t(Float(SEEKER_SEEK_RADIUS), Float(SEEKER_SEEK_RADIUS), Float(SEEKER_SEEK_RADIUS))
    mins = maxs * -1

    numFound = trap_EntitiesInBox(mins, maxs, &entityList, MAX_GENTITIES)

    i = 0
    while i < numFound {
        ent = g_entities[entityList[i]]

        if ent!.s.number == NPC!.s.number || ent!.client == nil || ent!.health <= 0 || !ent!.inuse {
            i += 1
            continue
        }

        if ent!.client!.playerTeam == NPC!.client!.playerTeam || ent!.client!.playerTeam == NPCTEAM_NEUTRAL {
            i += 1
            continue
        }

        // try to find the closest visible one
        if !NPC_ClearLOS4(ent!) {
            i += 1
            continue
        }

        dis = DistanceHorizontalSquared(NPC!.r.currentOrigin, ent!.r.currentOrigin)

        if dis <= bestDis {
            bestDis = dis
            best = ent
        }
        i += 1
    }

    if best != nil {
        // used to offset seekers around a circle so they don't occupy the same spot.  This is not a fool-proof method.
        // The SDK also declares `random`, so the call names the bg module.
        NPC!.random = JKAMP_BG.random() * 6.3 // roughly 2pi

        NPC!.enemy = best
    }
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:439
func Seeker_FollowOwner() {
    let dis: Float
    var minDistSqr: Float
    var pt = vec3_t()
    var dir = vec3_t()
    var owner: Entity? = g_entities[NPC!.s.owner]

    Seeker_MaintainHeight()

    if NPC!.client!.NPC_class == CLASS_BOBAFETT {
        owner = NPC!.enemy
    }
    if owner == nil || owner == NPC || owner!.client == nil {
        return
    }
    //rwwFIXMEFIXME: Care about all clients not just 0
    dis = DistanceHorizontalSquared(NPC!.r.currentOrigin, owner!.r.currentOrigin)

    minDistSqr = Float(MIN_DISTANCE_SQR)

    if NPC!.client!.NPC_class == CLASS_BOBAFETT {
        if TIMER_Done(NPC!, "flameTime") {
            minDistSqr = Float(200 * 200)
        }
    }

    if dis < minDistSqr {
        // generally circle the player closely till we take an enemy..this is our target point
        if NPC!.client!.NPC_class == CLASS_BOBAFETT {
            pt[0] = owner!.r.currentOrigin[0] + cos(level.time * 0.001 + NPC!.random) * 250
            pt[1] = owner!.r.currentOrigin[1] + sin(level.time * 0.001 + NPC!.random) * 250
            if NPC!.client!.jetPackTime < level.time {
                pt[2] = NPC!.r.currentOrigin[2] - 64
            } else {
                pt[2] = owner!.r.currentOrigin[2] + 200
            }
        } else {
            pt[0] = owner!.r.currentOrigin[0] + cos(level.time * 0.001 + NPC!.random) * 56
            pt[1] = owner!.r.currentOrigin[1] + sin(level.time * 0.001 + NPC!.random) * 56
            pt[2] = owner!.r.currentOrigin[2] + 40
        }

        dir = pt - NPC!.r.currentOrigin
        _VectorMA(NPC!.client!.ps.velocity, 0.8, dir, &NPC!.client!.ps.velocity)
    } else {
        if NPC!.client!.NPC_class != CLASS_BOBAFETT {
            if TIMER_Done(NPC!, "seekerhiss") {
                // The SDK also declares `random`, so the call names the bg module.
                TIMER_Set(NPC!, "seekerhiss", Int32(1000 + JKAMP_BG.random() * 1000))
                G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/seeker/misc/hiss"))
            }
        }

        // Hey come back!
        NPCInfo!.goalEntity = owner
        NPCInfo!.goalRadius = 32
        NPC_MoveToGoal(true)
        NPC!.parent = owner
    }

    if NPCInfo!.enemyCheckDebounceTime < level.time {
        // check twice a second to find a new enemy
        Seeker_FindEnemy()
        NPCInfo!.enemyCheckDebounceTime = level.time + 500
    }

    NPC_UpdateAngles(true, true)
}

//------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Seeker.c:523
func NPC_BSSeeker_Default() {
    /*
    if ( in_camera )
    {
    if ( NPC->client->NPC_class != CLASS_BOBAFETT )
    {
    // cameras make me commit suicide....
    G_Damage( NPC, NPC, NPC, NULL, NULL, 999, 0, MOD_UNKNOWN );
    }
    }
    */
    //N/A for MP.
    if NPC!.r.ownerNum < ENTITYNUM_NONE {
        let owner: Entity? = g_entities[0]
        if owner!.health <= 0 || (owner!.client != nil && owner!.client!.pers.connected == CON_DISCONNECTED) {
            //owner is dead or gone
            //remove me
            // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("NPC_BSSeeker_Default", source: "oracle/codemp/game/NPC_AI_Seeker.c:523")
            var scratchDir = vec3_t()
            G_Damage(NPC!, nil, nil, &scratchDir, nil, 10000, DAMAGE_NO_PROTECTION, MOD_TELEFRAG)
            return
        }
    }

    if NPC!.random == 0.0 {
        // used to offset seekers around a circle so they don't occupy the same spot.  This is not a fool-proof method.
        // The SDK also declares `random`, so the call names the bg module.
        NPC!.random = JKAMP_BG.random() * 6.3 // roughly 2pi
    }

    if NPC!.enemy != nil && NPC!.enemy!.health != 0 && NPC!.enemy!.inuse {
        if NPC!.client!.NPC_class != CLASS_BOBAFETT && (NPC!.enemy!.s.number == 0 || (NPC!.enemy!.client != nil && NPC!.enemy!.client!.NPC_class == CLASS_SEEKER)) {
            //hacked to never take the player as an enemy, even if the player shoots at it
            NPC!.enemy = nil
        } else {
            Seeker_Attack()
            if NPC!.client!.NPC_class == CLASS_BOBAFETT {
                Boba_FireDecide()
            }
            return
        }
    }

    // In all other cases, follow the player and look for enemies to take on
    Seeker_FollowOwner()
}
