import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_missile.c:7
let MISSILE_PRESTEP_TIME = 50 as Int32

/// Source: oracle/codemp/game/g_missile.c:24
func G_ReflectMissile(_ ent: Entity, _ missile: Entity, _ forward: JKAShared.vec3_t) {
    var bounce_dir = vec3_t()
    var i: Int32
    var speed: Float
    var owner: Entity? = ent
    var isowner: Int32 = 0

    if ent.r.ownerNum != 0 {
        owner = g_entities[ent.r.ownerNum]
    }

    if missile.r.ownerNum == ent.s.number {
        //the original owner is bouncing the missile, so don't try to bounce it back at him
        isowner = 1
    }

    //save the original speed
    speed = VectorNormalize(&missile.s.pos.trDelta)

    //if ( ent && owner && owner->NPC && owner->enemy && Q_stricmp( "Tavion", owner->NPC_type ) == 0 && Q_irand( 0, 3 ) )
    if missile.s.weapon != WP_SABER && missile.s.weapon != G2_MODEL_PART && isowner == 0 {
        //bounce back at them if you can
        bounce_dir = g_entities[missile.r.ownerNum].r.currentOrigin - missile.r.currentOrigin
        VectorNormalize(&bounce_dir)
    } else if isowner != 0 {
        //in this case, actually push the missile away from me, and since we're giving boost to our own missile by pushing it, up the velocity
        var missile_dir = vec3_t()

        speed = Float(Double(speed) * 1.5)

        missile_dir = missile.r.currentOrigin - ent.r.currentOrigin
        bounce_dir = missile.s.pos.trDelta
        bounce_dir = bounce_dir * _DotProduct(forward, missile_dir)
        VectorNormalize(&bounce_dir)
    } else {
        var missile_dir = vec3_t()

        missile_dir = ent.r.currentOrigin - missile.r.currentOrigin
        bounce_dir = missile.s.pos.trDelta
        bounce_dir = bounce_dir * _DotProduct(forward, missile_dir)
        VectorNormalize(&bounce_dir)
    }
    i = 0
    while i < 3 {
        bounce_dir[i] += RandFloat(-0.2, 0.2)
        i += 1
    }

    VectorNormalize(&bounce_dir)
    missile.s.pos.trDelta = bounce_dir * speed
    missile.s.pos.trTime = level.time // move a bit on the very first frame
    missile.s.pos.trBase = missile.r.currentOrigin
    if missile.s.weapon != WP_SABER && missile.s.weapon != G2_MODEL_PART {
        //you are mine, now!
        missile.r.ownerNum = ent.s.number
    }
    if missile.s.weapon == WP_ROCKET_LAUNCHER {
        //stop homing
        missile.think = nil
        missile.nextthink = 0
    }
}

/// Source: oracle/codemp/game/g_missile.c:91
func G_DeflectMissile(_ ent: Entity, _ missile: Entity, _ forward: JKAShared.vec3_t) {
    var bounce_dir = vec3_t()
    var i: Int32
    let speed: Float
    var isowner: Int32 = 0
    var missile_dir = vec3_t()

    if missile.r.ownerNum == ent.s.number {
        //the original owner is bouncing the missile, so don't try to bounce it back at him
        isowner = 1
    }

    //save the original speed
    speed = VectorNormalize(&missile.s.pos.trDelta)

    if ent.client != nil {
        //VectorSubtract( ent->r.currentOrigin, missile->r.currentOrigin, missile_dir );
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("G_DeflectMissile", source: "oracle/codemp/game/g_missile.c:91")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("G_DeflectMissile", source: "oracle/codemp/game/g_missile.c:91")
        var scratchUp = vec3_t()
        AngleVectors(ent.client!.ps.viewangles, &missile_dir, &scratchRight, &scratchUp)
        bounce_dir = missile_dir
        //VectorCopy( missile->s.pos.trDelta, bounce_dir );
        bounce_dir = bounce_dir * _DotProduct(forward, missile_dir)
        VectorNormalize(&bounce_dir)
    } else {
        bounce_dir = forward
        VectorNormalize(&bounce_dir)
    }

    i = 0
    while i < 3 {
        bounce_dir[i] += RandFloat(-1.0, 1.0)
        i += 1
    }

    VectorNormalize(&bounce_dir)
    missile.s.pos.trDelta = bounce_dir * speed
    missile.s.pos.trTime = level.time // move a bit on the very first frame
    missile.s.pos.trBase = missile.r.currentOrigin
    if missile.s.weapon != WP_SABER && missile.s.weapon != G2_MODEL_PART {
        //you are mine, now!
        missile.r.ownerNum = ent.s.number
    }
    if missile.s.weapon == WP_ROCKET_LAUNCHER {
        //stop homing
        missile.think = nil
        missile.nextthink = 0
    }
}

/**
```
================
G_BounceMissile

================
```
*/
/// Source: oracle/codemp/game/g_missile.c:148
func G_BounceMissile(_ ent: Entity, _ trace: JKAMP.Trace) {
    var velocity = vec3_t()
    let dot: Float
    let hitTime: Int32

    // reflect the velocity on the trace plane
    hitTime = Int32(level.previousTime + (level.time - level.previousTime) * trace.fraction)
    BG_EvaluateTrajectoryDelta(ent.s.pos, hitTime, &velocity)
    dot = _DotProduct(velocity, trace.plane.normal)
    _VectorMA(velocity, -2 * dot, trace.plane.normal, &ent.s.pos.trDelta)


    if (ent.flags & FL_BOUNCE_SHRAPNEL) != 0 {
        ent.s.pos.trDelta = ent.s.pos.trDelta * 0.25
        ent.s.pos.trType = TR_GRAVITY

        // check for stop
        if Double(trace.plane.normal[2]) > 0.7 && ent.s.pos.trDelta[2] < 40 {
            G_SetOrigin(ent, &trace.endpos)
            ent.nextthink = level.time + 100
            return
        }
    } else if (ent.flags & FL_BOUNCE_HALF) != 0 {
        ent.s.pos.trDelta = ent.s.pos.trDelta * 0.65
        // check for stop
        if Double(trace.plane.normal[2]) > 0.2 && VectorLength(ent.s.pos.trDelta) < 40 {
            G_SetOrigin(ent, &trace.endpos)
            return
        }
    }

    if ent.s.weapon == WP_THERMAL {
        //slight hack for hit sound
        G_Sound(ent, CHAN_BODY, G_SoundIndex(va("sound/weapons/thermal/bounce%i.wav", Q_irand(1, 2))))
    } else if ent.s.weapon == WP_SABER {
        G_Sound(ent, CHAN_BODY, G_SoundIndex(va("sound/weapons/saber/bounce%i.wav", Q_irand(1, 3))))
    } else if ent.s.weapon == G2_MODEL_PART {
        //Limb bounce sound?
    }

    ent.r.currentOrigin = ent.r.currentOrigin + trace.plane.normal
    ent.s.pos.trBase = ent.r.currentOrigin
    ent.s.pos.trTime = level.time

    if ent.bounceCount != -5 {
        ent.bounceCount -= 1
    }
}

/**
```
================
G_ExplodeMissile

Explode a missile without an impact
================
```
*/
/// Source: oracle/codemp/game/g_missile.c:215
func G_ExplodeMissile(_ ent: Entity) {
    var dir = vec3_t()
    var origin = vec3_t()

    BG_EvaluateTrajectory(ent.s.pos, level.time, &origin)
    SnapVector(&origin)
    G_SetOrigin(ent, &origin)

    // we don't have a valid direction, so just point straight up
    dir[1] = 0
    dir[0] = dir[1]
    dir[2] = 1

    ent.s.eType = ET_GENERAL
    G_AddEvent(ent, EV_MISSILE_MISS, DirToByte(dir))

    ent.freeAfterEvent = true

    ent.takedamage = false
    // splash damage
    if ent.splashDamage != 0 {
        //NOTE: vehicle missiles don't have an ent->parent set, so check that here and set it
        if ent.s.eType == ET_MISSILE && (ent.s.eFlags & EF_JETPACK_ACTIVE) != 0 && ent.r.ownerNum < MAX_CLIENTS {
            //set my parent to my owner for purposes of damage credit...
            ent.parent = g_entities[ent.r.ownerNum]
        }
        if G_RadiusDamage(ent.r.currentOrigin, ent.parent!, Float(ent.splashDamage), Float(ent.splashRadius), ent, ent, ent.splashMethodOfDeath) {
            if ent.parent != nil {
                g_entities[ent.parent!.s.number].client!.accuracy_hits += 1
            } else if ent.activator != nil {
                g_entities[ent.activator!.s.number].client!.accuracy_hits += 1
            }
        }
    }

    trap_LinkEntity(ent)
}

/// Source: oracle/codemp/game/g_missile.c:259
func G_RunStuckMissile(_ ent: Entity) {
    if ent.takedamage {
        if ent.s.groundEntityNum >= 0 && ent.s.groundEntityNum < ENTITYNUM_WORLD {
            let other: Entity? = g_entities[ent.s.groundEntityNum]

            if (VectorCompare(vec3_origin, other!.s.pos.trDelta) == 0 && other!.s.pos.trType != TR_STATIONARY) || (VectorCompare(vec3_origin, other!.s.apos.trDelta) == 0 && other!.s.apos.trType != TR_STATIONARY) {
                //thing I stuck to is moving or rotating now, kill me
                // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("G_RunStuckMissile", source: "oracle/codemp/game/g_missile.c:259")
                var scratchDir = vec3_t()
                G_Damage(ent, other, other, &scratchDir, nil, 99999, 0, MOD_CRUSH)
                return
            }
        }
    }
    // check think function
    G_RunThink(ent)
}

/**
```
================
G_BounceProjectile
================
```
*/
/// Source: oracle/codemp/game/g_missile.c:284
func G_BounceProjectile(_ start: JKAShared.vec3_t, _ impact: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ endout: inout JKAShared.vec3_t) {
    var v = vec3_t()
    var newv = vec3_t()
    let dot: Float

    v = impact - start
    dot = _DotProduct(v, dir)
    _VectorMA(v, -2 * dot, dir, &newv)

    VectorNormalize(&newv)
    _VectorMA(impact, 8192, newv, &endout)
}

//-----------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_missile.c:298
func CreateMissile(_ org: inout JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ vel: Float, _ life: Int32, _ owner: Entity, _ altFire: Bool) -> Entity? {
    var missile: Entity?

    missile = G_Spawn()

    missile!.nextthink = level.time + life
    missile!.think = Think.G_FreeEntity
    missile!.s.eType = ET_MISSILE
    missile!.r.svFlags = SVF_USE_CURRENT_ORIGIN
    missile!.parent = owner
    missile!.r.ownerNum = owner.s.number

    if altFire {
        missile!.s.eFlags |= EF_ALT_FIRING
    }

    missile!.s.pos.trType = TR_LINEAR
    missile!.s.pos.trTime = level.time // - MISSILE_PRESTEP_TIME;	// NOTENOTE This is a Quake 3 addition over JK2
    missile!.target_ent = nil

    SnapVector(&org)
    missile!.s.pos.trBase = org
    missile!.s.pos.trDelta = dir * vel
    missile!.r.currentOrigin = org
    SnapVector(&missile!.s.pos.trDelta)

    return missile
}

/// Source: oracle/codemp/game/g_missile.c:331
func G_MissileBounceEffect(_ ent: Entity, _ org: JKAShared.vec3_t, _ dir: JKAShared.vec3_t) {
    //FIXME: have an EV_BOUNCE_MISSILE event that checks the s.weapon and does the appropriate effect
    switch ent.s.weapon {
    case WP_BOWCASTER:
        G_PlayEffectID(G_EffectIndex("bowcaster/deflect"), ent.r.currentOrigin, dir)

    case WP_BLASTER, WP_BRYAR_PISTOL:
        G_PlayEffectID(G_EffectIndex("blaster/deflect"), ent.r.currentOrigin, dir)

    default:
        do {
            let te: Entity? = G_TempEntity(org, EV_SABER_BLOCK)
            te!.s.origin = org
            te!.s.angles = dir
            te!.s.eventParm = 0
            te!.s.weapon = 0 //saberNum
            te!.s.legsAnim = 0 //bladeNum
        }
    }
}

/// Source: oracle/codemp/game/g_missile.c:362
func G_MissileImpact(_ ent: Entity, _ trace: JKAMP.Trace) {
    var other: Entity?
    var hitClient: Bool = false
    var isKnockedSaber: Bool = false

    killProj: do {
        other = g_entities[trace.entityNum]

        // check for bounce
        if !other!.takedamage && (ent.bounceCount > 0 || ent.bounceCount == -5) && (ent.flags & (FL_BOUNCE | FL_BOUNCE_HALF)) != 0 {
            G_BounceMissile(ent, trace)
            G_AddEvent(ent, EV_GRENADE_BOUNCE, 0)
            return
        } else if ent.neverFree && ent.s.weapon == WP_SABER && (ent.flags & FL_BOUNCE_HALF) != 0 {
            //this is a knocked-away saber
            if ent.bounceCount > 0 || ent.bounceCount == -5 {
                G_BounceMissile(ent, trace)
                G_AddEvent(ent, EV_GRENADE_BOUNCE, 0)
                return
            }

            isKnockedSaber = true
        }

        // I would glom onto the FL_BOUNCE code section above, but don't feel like risking breaking something else
        if (!other!.takedamage && (ent.bounceCount > 0 || ent.bounceCount == -5) && (ent.flags & (FL_BOUNCE_SHRAPNEL)) != 0) || ((trace.surfaceFlags & SURF_FORCEFIELD) != 0 && ent.splashDamage == 0 && ent.splashRadius == 0 && (ent.bounceCount > 0 || ent.bounceCount == -5)) {
            G_BounceMissile(ent, trace)

            if ent.bounceCount < 1 {
                ent.flags &= ~FL_BOUNCE_SHRAPNEL
            }
            return
        }

        /*
        if ( !other->takedamage && ent->s.weapon == WP_THERMAL && !ent->alt_fire )
        {//rolling thermal det - FIXME: make this an eFlag like bounce & stick!!!
        //G_BounceRollMissile( ent, trace );
        if ( ent->owner && ent->owner->s.number == 0 )
        {
        G_MissileAddAlerts( ent );
        }
        //gi.linkentity( ent );
        return;
        }
        */

        if (other!.r.contents & CONTENTS_LIGHTSABER) != 0 && !isKnockedSaber {
            //hit this person's saber, so..
            let otherOwner: Entity? = g_entities[other!.r.ownerNum]

            if otherOwner!.takedamage && otherOwner!.client != nil && otherOwner!.client!.ps.duelInProgress && otherOwner!.client!.ps.duelIndex != ent.r.ownerNum {
                break killProj
            }
        } else if !isKnockedSaber {
            if other!.takedamage && other!.client != nil && other!.client!.ps.duelInProgress && other!.client!.ps.duelIndex != ent.r.ownerNum {
                break killProj
            }
        }

        if (other!.flags & FL_DMG_BY_HEAVY_WEAP_ONLY) != 0 {
            if ent.methodOfDeath != MOD_REPEATER_ALT && ent.methodOfDeath != MOD_ROCKET && ent.methodOfDeath != MOD_FLECHETTE_ALT_SPLASH && ent.methodOfDeath != MOD_ROCKET_HOMING && ent.methodOfDeath != MOD_THERMAL && ent.methodOfDeath != MOD_THERMAL_SPLASH && ent.methodOfDeath != MOD_TRIP_MINE_SPLASH && ent.methodOfDeath != MOD_TIMED_MINE_SPLASH && ent.methodOfDeath != MOD_DET_PACK_SPLASH && ent.methodOfDeath != MOD_VEHICLE && ent.methodOfDeath != MOD_CONC && ent.methodOfDeath != MOD_CONC_ALT && ent.methodOfDeath != MOD_SABER && ent.methodOfDeath != MOD_TURBLAST && ent.methodOfDeath != MOD_TARGET_LASER {
                var fwd = vec3_t()

                fwd = trace.plane.normal

                G_DeflectMissile(other!, ent, fwd)
                G_MissileBounceEffect(ent, ent.r.currentOrigin, fwd)
                return
            }
        }

        if (other!.flags & FL_SHIELDED) != 0 && ent.s.weapon != WP_ROCKET_LAUNCHER && ent.s.weapon != WP_THERMAL && ent.s.weapon != WP_TRIP_MINE && ent.s.weapon != WP_DET_PACK && ent.s.weapon != WP_DEMP2 && ent.s.weapon != WP_EMPLACED_GUN && ent.methodOfDeath != MOD_REPEATER_ALT && ent.methodOfDeath != MOD_FLECHETTE_ALT_SPLASH && ent.methodOfDeath != MOD_TURBLAST && ent.methodOfDeath != MOD_TARGET_LASER && ent.methodOfDeath != MOD_VEHICLE && ent.methodOfDeath != MOD_CONC && ent.methodOfDeath != MOD_CONC_ALT && !((ent.dflags & DAMAGE_HEAVY_WEAP_CLASS) != 0) {
            var fwd = vec3_t()

            if other!.client != nil {
                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("G_MissileImpact", source: "oracle/codemp/game/g_missile.c:362")
                var scratchRight = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("G_MissileImpact", source: "oracle/codemp/game/g_missile.c:362")
                var scratchUp = vec3_t()
                AngleVectors(other!.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)
            } else {
                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("G_MissileImpact", source: "oracle/codemp/game/g_missile.c:362")
                var scratchRight2 = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("G_MissileImpact", source: "oracle/codemp/game/g_missile.c:362")
                var scratchUp2 = vec3_t()
                AngleVectors(other!.r.currentAngles, &fwd, &scratchRight2, &scratchUp2)
            }

            G_DeflectMissile(other!, ent, fwd)
            G_MissileBounceEffect(ent, ent.r.currentOrigin, fwd)
            return
        }

        if other!.takedamage && other!.client != nil && ent.s.weapon != WP_ROCKET_LAUNCHER && ent.s.weapon != WP_THERMAL && ent.s.weapon != WP_TRIP_MINE && ent.s.weapon != WP_DET_PACK && ent.s.weapon != WP_DEMP2 && ent.methodOfDeath != MOD_REPEATER_ALT && ent.methodOfDeath != MOD_FLECHETTE_ALT_SPLASH && ent.methodOfDeath != MOD_CONC && ent.methodOfDeath != MOD_CONC_ALT && other!.client!.ps.saberBlockTime < level.time && !isKnockedSaber && WP_SaberCanBlock(other!, ent.r.currentOrigin, 0, 0, true, 0) != 0 {
            //only block one projectile per 200ms (to prevent giant swarms of projectiles being blocked)
            var fwd = vec3_t()
            var te: Entity?
            var otherDefLevel: Int32 = other!.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE]

            te = G_TempEntity(ent.r.currentOrigin, EV_SABER_BLOCK)
            te!.s.origin = ent.r.currentOrigin
            te!.s.angles = trace.plane.normal
            te!.s.eventParm = 0
            te!.s.weapon = 0 //saberNum
            te!.s.legsAnim = 0 //bladeNum

            /*if (other->client->ps.velocity[2] > 0 ||
            other->client->pers.cmd.forwardmove ||
            other->client->pers.cmd.rightmove)
            */
            if other!.client!.ps.velocity[2] > 0 || other!.client!.pers.cmd.forwardmove < 0 {
                otherDefLevel -= 1
                if otherDefLevel < 0 {
                    otherDefLevel = 0
                }
            }

            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("G_MissileImpact", source: "oracle/codemp/game/g_missile.c:362")
            var scratchRight3 = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("G_MissileImpact", source: "oracle/codemp/game/g_missile.c:362")
            var scratchUp3 = vec3_t()
            AngleVectors(other!.client!.ps.viewangles, &fwd, &scratchRight3, &scratchUp3)
            if otherDefLevel == FORCE_LEVEL_1 {
                //if def is only level 1, instead of deflecting the shot it should just die here
            } else if otherDefLevel == FORCE_LEVEL_2 {
                G_DeflectMissile(other!, ent, fwd)
            } else {
                G_ReflectMissile(other!, ent, fwd)
            }
            other!.client!.ps.saberBlockTime = level.time + (350 - (otherDefLevel * 100)) //200;

            //For jedi AI
            other!.client!.ps.saberEventFlags |= SEF_DEFLECTED

            if otherDefLevel == FORCE_LEVEL_3 {
                other!.client!.ps.saberBlockTime = 0 //^_^
            }

            if otherDefLevel == FORCE_LEVEL_1 {
                break killProj
            }
            return
        } else if (other!.r.contents & CONTENTS_LIGHTSABER) != 0 && !isKnockedSaber {
            //hit this person's saber, so..
            let otherOwner: Entity? = g_entities[other!.r.ownerNum]

            if otherOwner!.takedamage && otherOwner!.client != nil && ent.s.weapon != WP_ROCKET_LAUNCHER && ent.s.weapon != WP_THERMAL && ent.s.weapon != WP_TRIP_MINE && ent.s.weapon != WP_DET_PACK && ent.s.weapon != WP_DEMP2 && ent.methodOfDeath != MOD_REPEATER_ALT && ent.methodOfDeath != MOD_FLECHETTE_ALT_SPLASH && ent.methodOfDeath != MOD_CONC && ent.methodOfDeath != MOD_CONC_ALT {
                //for now still deflect even if saberBlockTime >= level.time because it hit the actual saber
                var fwd = vec3_t()
                var te: Entity?
                var otherDefLevel: Int32 = otherOwner!.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE]

                //in this case, deflect it even if we can't actually block it because it hit our saber
                //WP_SaberCanBlock(otherOwner, ent->r.currentOrigin, 0, 0, qtrue, 0);
                if otherOwner!.client != nil && otherOwner!.client!.ps.weaponTime <= 0 {
                    WP_SaberBlockNonRandom(otherOwner!, ent.r.currentOrigin, true)
                }

                te = G_TempEntity(ent.r.currentOrigin, EV_SABER_BLOCK)
                te!.s.origin = ent.r.currentOrigin
                te!.s.angles = trace.plane.normal
                te!.s.eventParm = 0
                te!.s.weapon = 0 //saberNum
                te!.s.legsAnim = 0 //bladeNum

                /*if (otherOwner->client->ps.velocity[2] > 0 ||
                otherOwner->client->pers.cmd.forwardmove ||
                otherOwner->client->pers.cmd.rightmove)*/
                if otherOwner!.client!.ps.velocity[2] > 0 || otherOwner!.client!.pers.cmd.forwardmove < 0 {
                    otherDefLevel -= 1
                    if otherDefLevel < 0 {
                        otherDefLevel = 0
                    }
                }

                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("G_MissileImpact", source: "oracle/codemp/game/g_missile.c:362")
                var scratchRight4 = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("G_MissileImpact", source: "oracle/codemp/game/g_missile.c:362")
                var scratchUp4 = vec3_t()
                AngleVectors(otherOwner!.client!.ps.viewangles, &fwd, &scratchRight4, &scratchUp4)

                if otherDefLevel == FORCE_LEVEL_1 {
                    //if def is only level 1, instead of deflecting the shot it should just die here
                } else if otherDefLevel == FORCE_LEVEL_2 {
                    G_DeflectMissile(otherOwner!, ent, fwd)
                } else {
                    G_ReflectMissile(otherOwner!, ent, fwd)
                }
                otherOwner!.client!.ps.saberBlockTime = level.time + (350 - (otherDefLevel * 100)) //200;

                //For jedi AI
                otherOwner!.client!.ps.saberEventFlags |= SEF_DEFLECTED

                if otherDefLevel == FORCE_LEVEL_3 {
                    otherOwner!.client!.ps.saberBlockTime = 0 //^_^
                }

                if otherDefLevel == FORCE_LEVEL_1 {
                    break killProj
                }
                return
            }
        }

        // check for sticking
        if !other!.takedamage && (ent.s.eFlags & EF_MISSILE_STICK) != 0 {
            laserTrapStick(ent, &trace.endpos, trace.plane.normal)
            G_AddEvent(ent, EV_MISSILE_STICK, 0)
            return
        }

        // impact damage
        if other!.takedamage && !isKnockedSaber {
            // FIXME: wrong damage direction?
            if ent.damage != 0 {
                var velocity = vec3_t()
                var didDmg: Bool = false

                if LogAccuracyHit(other!, g_entities[ent.r.ownerNum]) {
                    g_entities[ent.r.ownerNum].client!.accuracy_hits += 1
                    hitClient = true
                }
                BG_EvaluateTrajectoryDelta(ent.s.pos, level.time, &velocity)
                if VectorLength(velocity) == 0 {
                    velocity[2] = 1 // stepped on a grenade
                }

                if ent.s.weapon == WP_BOWCASTER || ent.s.weapon == WP_FLECHETTE || ent.s.weapon == WP_ROCKET_LAUNCHER {
                    if ent.s.weapon == WP_FLECHETTE && (ent.s.eFlags & EF_ALT_FIRING) != 0 {
                        ent.runThink()
                    } else {
                        G_Damage(other!, ent, g_entities[ent.r.ownerNum], &velocity, ent.r.currentOrigin, ent.damage, DAMAGE_HALF_ABSORB, ent.methodOfDeath)
                        didDmg = true
                    }
                } else {
                    G_Damage(other!, ent, g_entities[ent.r.ownerNum], &velocity, ent.r.currentOrigin, ent.damage, 0, ent.methodOfDeath)
                    didDmg = true
                }

                if didDmg && other != nil && other!.client != nil {
                    //What I'm wondering is why this isn't in the NPC pain funcs. But this is what SP does, so whatever.
                    let npc_class: class_t = other!.client!.NPC_class

                    // If we are a robot and we aren't currently doing the full body electricity...
                    if npc_class == CLASS_SEEKER || npc_class == CLASS_PROBE || npc_class == CLASS_MOUSE || npc_class == CLASS_GONK || npc_class == CLASS_R2D2 || npc_class == CLASS_R5D2 || npc_class == CLASS_REMOTE || npc_class == CLASS_MARK1 || npc_class == CLASS_MARK2 || npc_class == CLASS_INTERROGATOR || npc_class == CLASS_ATST || npc_class == CLASS_SENTRY {
                        // special droid only behaviors
                        if other!.client!.ps.electrifyTime < level.time + 100 {
                            // ... do the effect for a split second for some more feedback
                            other!.client!.ps.electrifyTime = level.time + 450
                        }
                        //FIXME: throw some sparks off droids,too
                    }
                }
            }

            if ent.s.weapon == WP_DEMP2 {
                //a hit with demp2 decloaks people, disables ships
                if other != nil && other!.client != nil && other!.client!.NPC_class == CLASS_VEHICLE {
                    //hit a vehicle
                    if other!.m_pVehicle != nil && other!.m_pVehicle!.m_pVehicleInfo != nil && (other!.m_pVehicle!.m_pVehicleInfo!.type == VH_SPEEDER || (other!.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER && ent.classname != nil && Q_stricmp("vehicle_proj", ent.classname!) == 0)) && !FighterIsLanded(other!.m_pVehicle!, other!.client!.ps) && !((other!.spawnflags & 2) != 0) {
                        //vehicles hit by "ion cannons" lose control
                        if other!.client!.ps.electrifyTime > level.time {
                            //add onto it
                            //FIXME: extern the length of the "out of control" time?
                            other!.client!.ps.electrifyTime += Q_irand(200, 500)
                            if other!.client!.ps.electrifyTime > level.time + 4000 {
                                //cap it
                                other!.client!.ps.electrifyTime = level.time + 4000
                            }
                        } else {
                            //start it
                            //FIXME: extern the length of the "out of control" time?
                            other!.client!.ps.electrifyTime = level.time + Q_irand(200, 500)
                        }
                    }
                } else if other != nil && other!.client != nil && other!.client!.ps.powerups[PW_CLOAKED] != 0 {
                    Jedi_Decloak(other!)
                    if ent.methodOfDeath == MOD_DEMP2_ALT {
                        //direct hit with alt disables cloak forever
                        //permanently disable the saboteur's cloak
                        other!.client!.cloakToggleTime = Q3_INFINITE
                    } else {
                        //temp disable
                        other!.client!.cloakToggleTime = level.time + Q_irand(3000, 10000)
                    }
                }
            }
        }
    }
    // is it cheaper in bandwidth to just remove this ent and create a new
    // one, rather than changing the missile into the explosion?

    if other!.takedamage && other!.client != nil && !isKnockedSaber {
        G_AddEvent(ent, EV_MISSILE_HIT, DirToByte(trace.plane.normal))
        ent.s.otherEntityNum = other!.s.number
    } else if (trace.surfaceFlags & SURF_METALSTEPS) != 0 {
        G_AddEvent(ent, EV_MISSILE_MISS_METAL, DirToByte(trace.plane.normal))
    } else if ent.s.weapon != G2_MODEL_PART && !isKnockedSaber {
        G_AddEvent(ent, EV_MISSILE_MISS, DirToByte(trace.plane.normal))
    }

    if !isKnockedSaber {
        ent.freeAfterEvent = true

        // change over to a normal entity right at the point of impact
        ent.s.eType = ET_GENERAL
    }

    SnapVectorTowards(&trace.endpos, ent.s.pos.trBase) // save net bandwidth

    G_SetOrigin(ent, &trace.endpos)

    ent.takedamage = false
    // splash damage (doesn't apply to person directly hit)
    if ent.splashDamage != 0 {
        if G_RadiusDamage(trace.endpos, ent.parent!, Float(ent.splashDamage), Float(ent.splashRadius), other, ent, ent.splashMethodOfDeath) {
            if !hitClient && g_entities[ent.r.ownerNum].client != nil {
                g_entities[ent.r.ownerNum].client!.accuracy_hits += 1
            }
        }
    }

    if ent.s.weapon == G2_MODEL_PART {
        ent.freeAfterEvent = false //it will free itself
    }

    trap_LinkEntity(ent)
}

/**
```
================
G_RunMissile
================
```
*/
/// Source: oracle/codemp/game/g_missile.c:808
func G_RunMissile(_ ent: Entity) {
    var origin = vec3_t()
    var groundSpot = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var passent: Int32 = 0
        var isKnockedSaber: Bool = false

        passthrough: do {
            if ent.neverFree && ent.s.weapon == WP_SABER && (ent.flags & FL_BOUNCE_HALF) != 0 {
                isKnockedSaber = true
                ent.s.pos.trType = TR_GRAVITY
            }

            // get current position
            BG_EvaluateTrajectory(ent.s.pos, level.time, &origin)

            // if this missile bounced off an invulnerability sphere
            if ent.target_ent != nil {
                passent = ent.target_ent!.s.number
            } else {
                // ignore interactions with the missile owner
                if (ent.r.svFlags & SVF_OWNERNOTSHARED) != 0 && (ent.s.eFlags & EF_JETPACK_ACTIVE) != 0 {
                    //A vehicle missile that should be solid to its owner
                    //I don't care about hitting my owner
                    passent = ent.s.number
                } else {
                    passent = ent.r.ownerNum
                }
            }
            // trace a line from the previous position to the current position
            if d_projectileGhoul2Collision.integer != 0 {
                trap_G2Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, origin, passent, ent.clipmask, G2TRFLAG_DOGHOULTRACE | G2TRFLAG_GETSURFINDEX | G2TRFLAG_THICK | G2TRFLAG_HITCORPSES, g_g2TraceLod.integer)

                if Double(tr.fraction) != 1.0 && tr.entityNum < ENTITYNUM_WORLD {
                    let g2Hit: Entity? = g_entities[tr.entityNum]

                    if g2Hit!.inuse && g2Hit!.client != nil && g2Hit!.ghoul2 != nil {
                        //since we used G2TRFLAG_GETSURFINDEX, tr.surfaceFlags will actually contain the index of the surface on the ghoul2 model we collided with.
                        g2Hit!.client!.g2LastSurfaceHit = tr.surfaceFlags
                        g2Hit!.client!.g2LastSurfaceTime = level.time
                    }

                    if g2Hit!.ghoul2 != nil {
                        tr.surfaceFlags = 0 //clear the surface flags after, since we actually care about them in here.
                    }
                }
            } else {
                trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, origin, passent, ent.clipmask)
            }

            if tr.startsolid != 0 || tr.allsolid != 0 {
                // make sure the tr.entityNum is set to the entity we're stuck in
                trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, ent.r.currentOrigin, passent, ent.clipmask)
                tr.fraction = 0
            } else {
                ent.r.currentOrigin = tr.endpos
            }

            if ent.passThroughNum != 0 && tr.entityNum == (ent.passThroughNum - 1) {
                ent.r.currentOrigin = origin
                trap_LinkEntity(ent)
                break passthrough
            }

            trap_LinkEntity(ent)

            if ent.s.weapon == G2_MODEL_PART && ent.bounceCount == 0 {
                var lowerOrg = vec3_t()
                // Raven's record lives to the end of his block, so the block is the closure.
                Trace.scratch { trG in

                    lowerOrg = ent.r.currentOrigin
                    lowerOrg[2] -= 1
                    trap_Trace(trG, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, lowerOrg, passent, ent.clipmask)

                    groundSpot = trG.endpos

                    if trG.startsolid == 0 && trG.allsolid == 0 && trG.entityNum == ENTITYNUM_WORLD {
                        ent.s.groundEntityNum = trG.entityNum
                    } else {
                        ent.s.groundEntityNum = ENTITYNUM_NONE
                    }
                }
            }

            if tr.fraction != 1 {
                // never explode or bounce on sky
                if (tr.surfaceFlags & SURF_NOIMPACT) != 0 {
                    // If grapple, reset owner
                    if ent.parent != nil && ent.parent!.client != nil && ent.parent!.client!.hook == ent {
                        ent.parent!.client!.hook = nil
                    }

                    if (ent.s.weapon == WP_SABER && ent.isSaberEntity) || isKnockedSaber {
                        G_RunThink(ent)
                        return true
                    } else if ent.s.weapon != G2_MODEL_PART {
                        G_FreeEntity(ent)
                        return true
                    }
                }

                /*
                gentity_t *evEnt = G_TempEntity(ent->r.currentOrigin, EV_GHOUL2_MARK);

                evEnt->s.owner = tr.entityNum; //the entity the mark should be placed on
                evEnt->s.weapon = ent->s.weapon; //the weapon used (to determine mark type)
                VectorCopy(ent->r.currentOrigin, evEnt->s.origin); //the point of impact

                //origin2 gets the predicted trajectory-based position.
                BG_EvaluateTrajectory( &ent->s.pos, level.time, evEnt->s.origin2 );

                //If they are the same, there will be problems.
                if (VectorCompare(evEnt->s.origin, evEnt->s.origin2))
                {
                evEnt->s.origin2[2] += 2; //whatever, at least it won't mess up.
                }
                */
                //ok, let's try adding it to the missile ent instead (tempents bad!)

                //copy current pos to s.origin, and current projected traj to origin2

                //the index for whoever we are hitting

                if ent.s.weapon > WP_NONE && ent.s.weapon < WP_NUM_WEAPONS && (tr.entityNum < MAX_CLIENTS || g_entities[tr.entityNum].s.eType == ET_NPC) {
                    //player or NPC, try making a mark on him
                    //copy current pos to s.origin, and current projected traj to origin2
                    ent.s.origin = ent.r.currentOrigin
                    BG_EvaluateTrajectory(ent.s.pos, level.time, &ent.s.origin2)

                    if VectorCompare(ent.s.origin, ent.s.origin2) != 0 {
                        ent.s.origin2[2] += 2.0 //whatever, at least it won't mess up.
                    }
                }

                G_MissileImpact(ent, tr)

                if tr.entityNum == ent.s.otherEntityNum {
                    //if the impact event other and the trace ent match then it's ok to do the g2 mark
                    ent.s.trickedentindex = 1
                }

                if ent.s.eType != ET_MISSILE && ent.s.weapon != G2_MODEL_PART {
                    return true // exploded
                }
            }

        }
        if ent.s.pos.trType == TR_STATIONARY && (ent.s.eFlags & EF_MISSILE_STICK) != 0 {
            //stuck missiles should check some special stuff
            G_RunStuckMissile(ent)
            return true
        }

        if ent.s.weapon == G2_MODEL_PART {
            if ent.s.groundEntityNum == ENTITYNUM_WORLD {
                ent.s.pos.trType = TR_LINEAR
                ent.s.pos.trDelta = vec3_t()
                ent.s.pos.trTime = level.time

                ent.s.pos.trBase = groundSpot
                ent.r.currentOrigin = groundSpot

                if ent.s.apos.trType != TR_STATIONARY {
                    ent.s.apos.trType = TR_STATIONARY
                    ent.s.apos.trTime = level.time

                    ent.s.apos.trBase[ROLL] = 0
                    ent.s.apos.trBase[PITCH] = 0
                }
            }
        }

        // check think function after bouncing
        G_RunThink(ent)
        return false
    }
    if earlyOut {
        return
    }
}
