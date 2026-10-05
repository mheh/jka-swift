import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_turret_G2.c:11
let SPF_TURRETG2_CANRESPAWN = 4 as Int32

/// Source: oracle/codemp/game/g_turret_G2.c:12
let SPF_TURRETG2_TURBO = 8 as Int32

/// Source: oracle/codemp/game/g_turret_G2.c:13
let SPF_TURRETG2_LEAD_ENEMY = 16 as Int32

/// Source: oracle/codemp/game/g_turret_G2.c:14
let SPF_SHOWONRADAR = 32 as Int32

/// Source: oracle/codemp/game/g_turret_G2.c:16
let ARM_ANGLE_RANGE = 60 as Int32

/// Source: oracle/codemp/game/g_turret_G2.c:17
let HEAD_ANGLE_RANGE = 90 as Int32

/// Source: oracle/codemp/game/g_turret_G2.c:19
let name = "models/map_objects/imp_mine/turret_canon.glm"

/// Source: oracle/codemp/game/g_turret_G2.c:20
let name2 = "models/map_objects/imp_mine/turret_damage.md3"

/// Source: oracle/codemp/game/g_turret_G2.c:21
let name3 = "models/map_objects/wedge/laser_cannon_model.glm"

/// Source: oracle/codemp/game/g_turret_G2.c:318
private let START_DIS = 15 as Int32

//special routine for tracking angles between client and server -rww
/// Source: oracle/codemp/game/g_turret_G2.c:24
func G2Tur_SetBoneAngles(_ ent: Entity, _ bone: String, _ angles: JKAShared.vec3_t) {
    // Port-note: A pointer local `int * thebone` with no view.
    // Raven wrote: int *thebone = &ent->s.boneIndex1;
    portMissing("G2Tur_SetBoneAngles", source: "oracle/codemp/game/g_turret_G2.c:24")
    // Port-note: A pointer local `int * firstFree` with no view.
    // Raven wrote: int *firstFree = NULL;
    portMissing("G2Tur_SetBoneAngles", source: "oracle/codemp/game/g_turret_G2.c:24")
    var i: Int32 = 0
    let boneIndex: Int32 = G_BoneIndex(bone)
    let flags: Int32
    let up: Int32
    let right: Int32
    let forward: Int32
    // Port-note: A pointer local `vec3_t * boneVector` with no view.
    // Raven wrote: vec3_t *boneVector = &ent->s.boneAngles1;
    portMissing("G2Tur_SetBoneAngles", source: "oracle/codemp/game/g_turret_G2.c:24")
    // Port-note: A pointer local `vec3_t * freeBoneVec` with no view.
    // Raven wrote: vec3_t *freeBoneVec = NULL;
    portMissing("G2Tur_SetBoneAngles", source: "oracle/codemp/game/g_turret_G2.c:24")

    // Port-note: A read of `thebone`, a local the draft left as a hole.
    // Raven wrote: while (thebone) { if (!*thebone && !firstFree) { //if the value is 0 then this index is clear, we can use it if we don't find the bone we want already existing. firstFree = thebone; freeBoneVec = boneVector; } else if (*thebone) { if (*thebone == boneIndex) { //this is it break; } } switch (i) { case 0: thebone = &ent->s.boneIndex2; boneVector = &ent->s.boneAngles2; break; case 1: thebone = &ent->s.boneIndex3; boneVector = &ent->s.boneAngles3; break; case 2: thebone = &ent->s.boneIndex4; boneVector = &ent->s.boneAngles4; break; default: thebone = NULL; boneVector = NULL; break; } i++; }
    portMissing("G2Tur_SetBoneAngles", source: "oracle/codemp/game/g_turret_G2.c:24")

    // Port-note: A read of `thebone`, a local the draft left as a hole.
    // Raven wrote: if (!thebone) { //didn't find it, create it if (!firstFree) { //no free bones.. can't do a thing then. Com_Printf("WARNING: NPC has no free bone indexes\n"); return; } thebone = firstFree; *thebone = boneIndex; boneVector = freeBoneVec; }
    portMissing("G2Tur_SetBoneAngles", source: "oracle/codemp/game/g_turret_G2.c:24")

    //If we got here then we have a vector and an index.

    //Copy the angles over the vector in the entitystate, so we can use the corresponding index
    //to set the bone angles on the client.
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: VectorCopy(angles, *boneVector)
    portMissing("G2Tur_SetBoneAngles", source: "oracle/codemp/game/g_turret_G2.c:24")

    //Now set the angles on our server instance if we have one.

    if ent.ghoul2 == nil {
        return
    }

    flags = BONE_ANGLES_POSTMULT
    up = POSITIVE_Y
    right = NEGATIVE_Z
    forward = NEGATIVE_X

    //first 3 bits is forward, second 3 bits is right, third 3 bits is up
    ent.s.boneOrient = ((forward) | (right << 3) | (up << 6))

    trap_G2API_SetBoneAngles(ent.ghoul2, 0, bone, angles, flags, up, right, forward, nil, 100, level.time)
}

/// Source: oracle/codemp/game/g_turret_G2.c:125
func turretG2_set_models(_ `self`: Entity, _ dying: Bool) {
    if dying {
        if !((`self`.spawnflags & SPF_TURRETG2_TURBO) != 0) {
            `self`.s.modelindex = G_ModelIndex(name2)
            `self`.s.modelindex2 = G_ModelIndex(name)
        }

        trap_G2API_RemoveGhoul2Model(`self`.ghoul2, 0)
        G_KillG2Queue(`self`.s.number)
        `self`.s.modelGhoul2 = 0
        /*
        trap_G2API_InitGhoul2Model( &self->ghoul2,
        name2,
        0, //base->s.modelindex,
        //note, this is not the same kind of index - this one's referring to the actual
        //index of the model in the g2 instance, whereas modelindex is the index of a
        //configstring -rww
        0,
        0,
        0,
        0);
        */
    } else {
        if !((`self`.spawnflags & SPF_TURRETG2_TURBO) != 0) {
            `self`.s.modelindex = G_ModelIndex(name)
            `self`.s.modelindex2 = G_ModelIndex(name2)
            //set the new onw
            trap_G2API_InitGhoul2Model(&`self`.ghoul2, name, 0, 0, 0, 0, 0)
        } else {
            `self`.s.modelindex = G_ModelIndex(name3)
            //set the new onw
            trap_G2API_InitGhoul2Model(&`self`.ghoul2, name3, 0, 0, 0, 0, 0)
        }

        `self`.s.modelGhoul2 = 1
        if (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 {
            //larger
            `self`.s.g2radius = 128
        } else {
            `self`.s.g2radius = 80
        }

        if (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 {
            //different pitch bone and muzzle flash points
            G2Tur_SetBoneAngles(`self`, "pitch", vec3_origin)
            `self`.genericValue11 = trap_G2API_AddBolt(`self`.ghoul2, 0, "*muzzle1")
            `self`.genericValue12 = trap_G2API_AddBolt(`self`.ghoul2, 0, "*muzzle2")
        } else {
            G2Tur_SetBoneAngles(`self`, "Bone_body", vec3_origin)
            `self`.genericValue11 = trap_G2API_AddBolt(`self`.ghoul2, 0, "*flash03")
        }
    }
}

//------------------------------------------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:210
func TurretG2Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    if `self`.paintarget != nil && !`self`.paintarget!.isEmpty {
        if `self`.genericValue8 < level.time {
            G_UseTargets2(`self`, `self`, `self`.paintarget!)
            `self`.genericValue8 = level.time + `self`.genericValue4
        }
    }

    if attacker.client != nil && attacker.client!.ps.weapon == WP_DEMP2 {
        // The SDK also declares `random`, so the call names the bg module.
        `self`.attackDebounceTime = Int32(level.time + 2000 + JKAMP_BG.random() * 500)
        `self`.painDebounceTime = `self`.attackDebounceTime
    }
    if `self`.enemy == nil {
        //react to being hit
        G_SetEnemy(`self`, attacker)
    }
    //self->s.health = self->health;
    //mmm..yes..bad.
}

//------------------------------------------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:236
func turretG2_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ meansOfDeath: Int32) {
    var forward = vec3_t(0, 0, -1)
    var pos = vec3_t()

    // Turn off the thinking of the base & use it's targets
    //self->think = NULL;
    `self`.use = nil

    // clear my data
    `self`.die = nil
    `self`.pain = nil
    `self`.takedamage = false
    `self`.health = 0
    `self`.s.health = `self`.health
    `self`.s.loopSound = 0
    `self`.s.shouldtarget = false
    //self->s.owner = MAX_CLIENTS; //not owned by any client

    if attacker.s.number < MAX_CLIENTS && !OnSameTeam(attacker, `self`) {
        //give them a point for the kill
        AddScore(attacker, `self`.r.currentOrigin, 1)
        //should we send an obit?  nah...
    }

    // hack the effect angle so that explode death can orient the effect properly
    if (`self`.spawnflags & 2) != 0 {
        forward = vec3_t(0, 0, 1)
    }

    //	VectorCopy( self->r.currentOrigin, self->s.pos.trBase );

    _VectorMA(`self`.r.currentOrigin, 12, forward, &pos)
    G_PlayEffect(EFFECT_EXPLOSION_TURRET, pos, forward)

    if `self`.splashDamage > 0 && `self`.splashRadius > 0 {
        G_RadiusDamage(`self`.r.currentOrigin, attacker, Float(`self`.splashDamage), Float(`self`.splashRadius), attacker, nil, MOD_UNKNOWN)
    }

    if (`self`.s.eFlags & EF_SHADER_ANIM) != 0 {
        `self`.s.frame = 1 // black
    }

    `self`.s.weapon = 0 // crosshair code uses this to mark crosshair red

    if `self`.s.modelindex2 != 0 {
        // switch to damage model if we should
        turretG2_set_models(`self`, true)

        `self`.s.apos.trBase = `self`.r.currentAngles
        `self`.s.apos.trDelta = vec3_t()

        if `self`.target != nil {
            G_UseTargets(`self`, attacker)
        }

        if (`self`.spawnflags & SPF_TURRETG2_CANRESPAWN) != 0 {
            //respawn
            if `self`.health < 1 && `self`.genericValue5 == 0 {
                //we are dead, set our respawn delay if we have one
                `self`.genericValue5 = level.time + `self`.count
            }
        }
    } else {
        ObjectDie(`self`, inflictor, attacker, damage, meansOfDeath)
    }
}

//start an animation on model_root both server side and client side
/// Source: oracle/codemp/game/g_turret_G2.c:321
func TurboLaser_SetBoneAnim(_ eweb: Entity, _ startFrame: Int32, _ endFrame: Int32) {
    //set info on the entity so it knows to start the anim on the client next snapshot.
    eweb.s.eFlags |= EF_G2ANIMATING

    if eweb.s.torsoAnim == startFrame && eweb.s.legsAnim == endFrame {
        //already playing this anim, let's flag it to restart
        eweb.s.torsoFlip = !eweb.s.torsoFlip
    } else {
        eweb.s.torsoAnim = startFrame
        eweb.s.legsAnim = endFrame
    }

    //now set the animation on the server ghoul2 instance.
    trap_G2API_SetBoneAnim(eweb.ghoul2, 0, "model_root", startFrame, endFrame, (BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND), 1.0, level.time, -1, 100)
}

//----------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:344
private func turretG2_fire(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t) {
    var org = vec3_t()
    var ang = vec3_t()
    var bolt: Entity?

    if (trap_PointContents(start, ent.s.number) & MASK_SHOT) != 0 {
        return
    }

    _VectorMA(start, Float(-START_DIS), dir, &org) // dumb....

    if ent.random != 0 {
        vectoangles(dir, &ang)
        ang[PITCH] += flrand(-ent.random, ent.random)
        ang[YAW] += flrand(-ent.random, ent.random)
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("turretG2_fire", source: "oracle/codemp/game/g_turret_G2.c:344")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("turretG2_fire", source: "oracle/codemp/game/g_turret_G2.c:344")
        var scratchUp = vec3_t()
        AngleVectors(ang, &dir, &scratchRight, &scratchUp)
    }

    vectoangles(dir, &ang)

    if (ent.spawnflags & SPF_TURRETG2_TURBO) != 0 {
        //muzzle flash
        G_PlayEffectID(ent.genericValue13, org, ang)
        WP_FireTurboLaserMissile(ent, &start, dir)
        if ent.alt_fire {
            TurboLaser_SetBoneAnim(ent, 2, 3)
        } else {
            TurboLaser_SetBoneAnim(ent, 0, 1)
        }
    } else {
        G_PlayEffectID(G_EffectIndex("blaster/muzzle_flash"), org, ang)
        bolt = G_Spawn()

        bolt!.classname = "turret_proj"
        bolt!.nextthink = level.time + 10000
        bolt!.think = Think.G_FreeEntity
        bolt!.s.eType = ET_MISSILE
        bolt!.s.weapon = WP_BLASTER
        bolt!.r.ownerNum = ent.s.number
        bolt!.damage = ent.damage
        bolt!.alliedTeam = ent.alliedTeam
        bolt!.teamnodmg = ent.teamnodmg
        bolt!.dflags = (DAMAGE_NO_KNOCKBACK | DAMAGE_HEAVY_WEAP_CLASS) // Don't push them around, or else we are constantly re-aiming
        bolt!.splashDamage = ent.splashDamage
        bolt!.splashRadius = ent.splashDamage
        bolt!.methodOfDeath = MOD_TARGET_LASER //MOD_ENERGY;
        bolt!.splashMethodOfDeath = MOD_TARGET_LASER //MOD_ENERGY;
        bolt!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
        //bolt->trigger_formation = qfalse;		// don't draw tail on first frame

        bolt!.r.maxs = vec3_t(1.5, 1.5, 1.5)
        bolt!.r.mins = bolt!.r.maxs * -1
        bolt!.s.pos.trType = TR_LINEAR
        bolt!.s.pos.trTime = level.time
        bolt!.s.pos.trBase = start
        bolt!.s.pos.trDelta = dir * ent.mass
        SnapVector(&bolt!.s.pos.trDelta) // save net bandwidth
        bolt!.r.currentOrigin = start
    }
}

/// Source: oracle/codemp/game/g_turret_G2.c:414
func turretG2_respawn(_ `self`: Entity) {
    `self`.use = Use.turretG2_base_use
    `self`.pain = Pain.TurretG2Pain
    `self`.die = Die.turretG2_die
    `self`.takedamage = true
    `self`.s.shouldtarget = true
    //self->s.owner = MAX_CLIENTS; //not owned by any client
    if (`self`.s.eFlags & EF_SHADER_ANIM) != 0 {
        `self`.s.frame = 0 // normal
    }
    `self`.s.weapon = WP_TURRET // crosshair code uses this to mark crosshair red

    turretG2_set_models(`self`, false)
    `self`.health = `self`.genericValue6
    `self`.s.health = `self`.health
    if `self`.maxHealth != 0 {
        G_ScaleNetHealth(`self`)
    }
    `self`.genericValue5 = 0 //clear this now
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:437
func turretG2_head_think(_ `self`: Entity) {
    // if it's time to fire and we have an enemy, then gun 'em down!  pushDebounce time controls next fire time
    if `self`.enemy != nil && `self`.setTime < level.time && `self`.attackDebounceTime < level.time {
        var fwd = vec3_t()
        var org = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in

            // set up our next fire time
            `self`.setTime = Int32(level.time + `self`.wait)

            // Getting the flash bolt here
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, (`self`.alt_fire ? `self`.genericValue12 : `self`.genericValue11), boltMatrix, `self`.r.currentAngles, `self`.r.currentOrigin, level.time, nil, &`self`.modelScale)
            if (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 {
                `self`.alt_fire = !`self`.alt_fire
            }

            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &org)
            //BG_GiveMeVectorFromMatrix( &boltMatrix, POSITIVE_Y, fwd );
            if (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 {
                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_X, &fwd)
            } else {
                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_X, &fwd)
            }

            _VectorMA(org, Float(START_DIS), fwd, &org)

            turretG2_fire(`self`, &org, &fwd)
            `self`.fly_sound_debounce_time = level.time //used as lastShotTime
        }
    }
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:485
private func turretG2_aim(_ `self`: Entity) {
    var enemyDir = vec3_t()
    var org = vec3_t()
    var org2 = vec3_t()
    var desiredAngles = vec3_t()
    var setAngle = vec3_t()
    var diffYaw: Float = 0.0
    var diffPitch: Float = 0.0
    let maxYawSpeed: Float = (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 ? 30.0 : 14.0
    let maxPitchSpeed: Float = (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 ? 15.0 : 3.0

    // move our gun base yaw to where we should be at this time....
    BG_EvaluateTrajectory(`self`.s.apos, level.time, &`self`.r.currentAngles)
    `self`.r.currentAngles[YAW] = AngleNormalize360(`self`.r.currentAngles[YAW])
    `self`.speed = AngleNormalize360(`self`.speed)

    if `self`.enemy != nil {
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in
            // ...then we'll calculate what new aim adjustments we should attempt to make this frame
            // Aim at enemy
            if `self`.enemy!.client != nil {
                org = `self`.enemy!.client!.renderInfo.eyePoint
            } else {
                org = `self`.enemy!.r.currentOrigin
            }
            if (`self`.spawnflags & 2) != 0 {
                org[2] -= 15
            } else {
                org[2] -= 5
            }

            if (`self`.spawnflags & SPF_TURRETG2_LEAD_ENEMY) != 0 {
                //we want to lead them a bit
                var diff = vec3_t()
                var velocity = vec3_t()
                var dist: Float = 0
                diff = org - `self`.s.origin
                dist = VectorNormalize(&diff)
                if `self`.enemy!.client != nil {
                    velocity = `self`.enemy!.client!.ps.velocity
                } else {
                    velocity = `self`.enemy!.s.pos.trDelta
                }
                _VectorMA(org, (dist / `self`.mass), velocity, &org)
            }

            // Getting the "eye" here
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, (`self`.alt_fire ? `self`.genericValue12 : `self`.genericValue11), boltMatrix, `self`.r.currentAngles, `self`.s.origin, level.time, nil, &`self`.modelScale)

            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &org2)

            enemyDir = org - org2
            vectoangles(enemyDir, &desiredAngles)

            diffYaw = AngleSubtract(`self`.r.currentAngles[YAW], desiredAngles[YAW])
            diffPitch = AngleSubtract(`self`.speed, desiredAngles[PITCH])
        }
    } else {
        // no enemy, so make us slowly sweep back and forth as if searching for a new one
        //		diffYaw = sin( level.time * 0.0001f + self->count ) * 5.0f;	// don't do this for now since it can make it go into walls.
    }

    if diffYaw != 0 {
        // cap max speed....
        if abs(diffYaw) > maxYawSpeed {
            diffYaw = (diffYaw >= 0 ? maxYawSpeed : -maxYawSpeed)
        }

        // ...then set up our desired yaw
        setAngle = vec3_t(0.0, diffYaw, 0.0)

        `self`.s.apos.trBase = `self`.r.currentAngles
        `self`.s.apos.trDelta = setAngle * -5
        `self`.s.apos.trTime = level.time
        `self`.s.apos.trType = TR_LINEAR
    }

    if diffPitch != 0 {
        if abs(diffPitch) > maxPitchSpeed {
            // cap max speed
            `self`.speed += (diffPitch > 0.0) ? -maxPitchSpeed : maxPitchSpeed
        } else {
            // small enough, so just add half the diff so we smooth out the stopping
            `self`.speed -= (diffPitch) //desiredAngles[PITCH];
        }

        // Note that this is NOT interpolated, so it will be less smooth...On the other hand, it does use Ghoul2 to blend, so it may smooth it out a bit?
        if (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 {
            if (`self`.spawnflags & 2) != 0 {
                desiredAngles = vec3_t(0.0, 0.0, -`self`.speed)
            } else {
                desiredAngles = vec3_t(0.0, 0.0, `self`.speed)
            }
            G2Tur_SetBoneAngles(`self`, "pitch", desiredAngles)
        } else {
            if (`self`.spawnflags & 2) != 0 {
                desiredAngles = vec3_t(`self`.speed, 0.0, 0.0)
            } else {
                desiredAngles = vec3_t(-`self`.speed, 0.0, 0.0)
            }
            G2Tur_SetBoneAngles(`self`, "Bone_body", desiredAngles)
        }
        /*
        trap_G2API_SetBoneAngles( self->ghoul2,
        0,
        "Bone_body",
        desiredAngles,
        BONE_ANGLES_POSTMULT,
        POSITIVE_Y,
        POSITIVE_Z,
        POSITIVE_X,
        NULL,
        100,
        level.time );
        */
    }

    if diffYaw != 0 || diffPitch != 0 {
        //FIXME: turbolaser sounds
        if (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 {
            `self`.s.loopSound = G_SoundIndex("sound/vehicles/weapons/turbolaser/turn.wav")
        } else {
            `self`.s.loopSound = G_SoundIndex("sound/chars/turret/move.wav")
        }
    } else {
        `self`.s.loopSound = 0
    }
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:651
private func turretG2_turnoff(_ `self`: Entity) {
    if `self`.enemy == nil {
        // we don't need to turnoff
        return
    }
    if (`self`.spawnflags & SPF_TURRETG2_TURBO) != 0 {
        TurboLaser_SetBoneAnim(`self`, 4, 5)
    }
    // shut-down sound
    if !((`self`.spawnflags & SPF_TURRETG2_TURBO) != 0) {
        G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/chars/turret/shutdown.wav"))
    }

    // make turret play ping sound for 5 seconds
    `self`.aimDebounceTime = level.time + 5000

    // Clear enemy
    `self`.enemy = nil
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:677
private func turretG2_find_enemies(_ `self`: Entity) -> Bool {
    var found: Bool = false
    var i: Int32 = 0
    var count: Int32 = 0
    var bestDist: Float = `self`.radius * `self`.radius
    var enemyDist: Float = 0
    var enemyDir = vec3_t()
    var org = vec3_t()
    var org2 = vec3_t()
    var foundClient: Bool = false
    // Port-note: A local `gentity_t *[1024] entity_list` the table has no type for.
    // Raven wrote: gentity_t *entity_list[MAX_GENTITIES];
    portMissing("turretG2_find_enemies", source: "oracle/codemp/game/g_turret_G2.c:677")
    var target: Entity?
    var bestTarget: Entity? = nil

    if `self`.aimDebounceTime > level.time {
        // We were active and alert, i.e. had an enemy in the last 3 secs
        if `self`.painDebounceTime < level.time {
            if !((`self`.spawnflags & SPF_TURRETG2_TURBO) != 0) {
                G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/chars/turret/ping.wav"))
            }
            `self`.painDebounceTime = level.time + 1000
        }
    }

    org2 = `self`.r.currentOrigin
    if (`self`.spawnflags & 2) != 0 {
        org2[2] += 20
    } else {
        org2[2] -= 20
    }

    // Port-note: A read of `entity_list`, a local the draft left as a hole.
    // Raven wrote: count = G_RadiusList( org2, self->radius, self, qtrue, entity_list )
    portMissing("turretG2_find_enemies", source: "oracle/codemp/game/g_turret_G2.c:677")

    // Port-note: Raven's block leaves a loop outside the record's scope, and the closure cannot.
    // Raven wrote: for ( i = 0; i < count; i++ ) { trace_t tr; target = entity_list[i]; if ( !target->client ) { // only attack clients if ( !(target->flags&FL_BBRUSH)//not a breakable brush || !target->takedamage//is a bbrush, but invincible || (target->NPC_targetname&&self->targetname&&Q_stricmp(target->NPC_targetname,self->targetname)!=0) )//not in invicible bbrush, but can only be broken by an NPC that is not me { continue; } //else: we will shoot at bbrushes! } if ( target == self || !target->takedamage || target->health <= 0 || ( target->flags & FL_NOTARGET )) { continue; } if ( target->client && target->client->sess.sessionTeam == TEAM_SPECTATOR ) { continue; } if ( self->alliedTeam ) { if ( target->client ) { if ( target->client->sess.sessionTeam == self->alliedTeam ) { // A bot/client/NPC we don't want to shoot continue; } } else if ( target->teamnodmg == self->alliedTeam ) { // An ent we don't want to shoot continue; } } if ( !trap_InPVS( org2, target->r.currentOrigin )) { continue; } if ( target->client ) { VectorCopy( target->client->renderInfo.eyePoint, org ); } else { VectorCopy( target->r.currentOrigin, org ); } if ( self->spawnflags & 2 ) { org[2] -= 15; } else { org[2] += 5; } trap_Trace( &tr, org2, NULL, NULL, org, self->s.number, MASK_SHOT ); if ( !tr.allsolid && !tr.startsolid && ( tr.fraction == 1.0 || tr.entityNum == target->s.number )) { // Only acquire if have a clear shot, Is it in range and closer than our best? VectorSubtract( target->r.currentOrigin, self->r.currentOrigin, enemyDir ); enemyDist = VectorLengthSquared( enemyDir ); if ( enemyDist < bestDist || (target->client && !foundClient))// all things equal, keep current { if ( self->attackDebounceTime < level.time ) { // We haven't fired or acquired an enemy in the last 2 seconds-start-up sound if ( !(self->spawnflags&SPF_TURRETG2_TURBO) ) { G_Sound( self, CHAN_BODY, G_SoundIndex( "sound/chars/turret/startup.wav" )); } // Wind up turrets for a bit self->attackDebounceTime = level.time + 1400; } bestTarget = target; bestDist = enemyDist; found = qtrue; if ( target->client ) {//prefer clients over non-clients foundClient = qtrue; } } } }
    portMissing("turretG2_find_enemies", source: "oracle/codemp/game/g_turret_G2.c:677")

    if found {
        /*
        if ( !self->enemy )
        {//just aquired one
        AddSoundEvent( bestTarget, self->r.currentOrigin, 256, AEL_DISCOVERED );
        AddSightEvent( bestTarget, self->r.currentOrigin, 512, AEL_DISCOVERED, 20 );
        }
        */
        G_SetEnemy(`self`, bestTarget!)
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: if ( VALIDSTRING( self->target2 )) { G_UseTargets2( self, self, self->target2 ); }
        portMissing("turretG2_find_enemies", source: "oracle/codemp/game/g_turret_G2.c:677")
    }

    return found
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:829
func turretG2_base_think(_ `self`: Entity) {
    var turnOff: Bool = true
    var enemyDist: Float = 0
    var enemyDir = vec3_t()
    var org = vec3_t()
    var org2 = vec3_t()

    `self`.nextthink = level.time + FRAMETIME

    if `self`.health <= 0 {
        //dead
        if (`self`.spawnflags & SPF_TURRETG2_CANRESPAWN) != 0 {
            //can respawn
            if `self`.genericValue5 != 0 && `self`.genericValue5 < level.time {
                //we are dead, see if it's time to respawn
                turretG2_respawn(`self`)
            }
        }
        return
    } else if (`self`.spawnflags & 1) != 0 {
        // not turned on
        turretG2_turnoff(`self`)
        turretG2_aim(`self`)

        // No target
        `self`.flags |= FL_NOTARGET
        return
    } else {
        // I'm all hot and bothered
        `self`.flags &= ~FL_NOTARGET
    }

    if `self`.enemy != nil {
        if `self`.enemy!.health < 0 || !`self`.enemy!.inuse {
            `self`.enemy = nil
        }
    }

    if `self`.last_move_time < level.time {
        //MISNOMER: used a enemy recalcing debouncer
        if turretG2_find_enemies(`self`) {
            //found one
            turnOff = false
            if `self`.enemy!.client != nil {
                //hold on to clients for a min of 3 seconds
                `self`.last_move_time = level.time + 3000
            } else {
                //hold less
                `self`.last_move_time = level.time + 500
            }
        }
    }

    if `self`.enemy != nil {
        if `self`.enemy!.client != nil && `self`.enemy!.client!.sess.sessionTeam == TEAM_SPECTATOR {
            //don't keep going after spectators
            `self`.enemy = nil
        } else {
            //FIXME: remain single-minded or look for a new enemy every now and then?
            // enemy is alive
            enemyDir = `self`.enemy!.r.currentOrigin - `self`.r.currentOrigin
            enemyDist = VectorLengthSquared(enemyDir)

            if enemyDist < `self`.radius * `self`.radius {
                // was in valid radius
                if trap_InPVS(`self`.r.currentOrigin, `self`.enemy!.r.currentOrigin) {
                    // Every now and again, check to see if we can even trace to the enemy
                    // Raven's record lives to the end of his block, so the block is the closure.
                    Trace.scratch { tr in

                        if `self`.enemy!.client != nil {
                            org = `self`.enemy!.client!.renderInfo.eyePoint
                        } else {
                            org = `self`.enemy!.r.currentOrigin
                        }
                        org2 = `self`.r.currentOrigin
                        if (`self`.spawnflags & 2) != 0 {
                            org2[2] += 10
                        } else {
                            org2[2] -= 10
                        }
                        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                        portMissing("turretG2_base_think", source: "oracle/codemp/game/g_turret_G2.c:829")
                        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                        portMissing("turretG2_base_think", source: "oracle/codemp/game/g_turret_G2.c:829")
                        trap_Trace(tr, org2, vec3_origin, vec3_origin, org, `self`.s.number, MASK_SHOT)

                        if tr.allsolid == 0 && tr.startsolid == 0 && tr.entityNum == `self`.enemy!.s.number {
                            turnOff = false // Can see our enemy
                        }
                    }
                }
            }
        }
    }

    if turnOff {
        if `self`.bounceCount < level.time {
            turretG2_turnoff(`self`)
        }
    } else {
        // keep our enemy for a minimum of 2 seconds from now
        // The SDK also declares `random`, so the call names the bg module.
        `self`.bounceCount = Int32(level.time + 2000 + JKAMP_BG.random() * 150)
    }

    turretG2_aim(`self`)
    if !turnOff {
        turretG2_head_think(`self`)
    }
}

//-----------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:959
func turretG2_base_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    // Toggle on and off
    `self`.spawnflags = (`self`.spawnflags ^ 1)

    if (`self`.s.eFlags & EF_SHADER_ANIM) != 0 && (`self`.spawnflags & 1) != 0 {
        `self`.s.frame = 1 // black
    } else {
        `self`.s.frame = 0 // glow
    }
}

/**
```
QUAKED misc_turretG2 (1 0 0) (-8 -8 -22) (8 8 0) START_OFF UPSIDE_DOWN CANRESPAWN TURBO LEAD SHOWRADAR

Turret that hangs from the ceiling, will aim and shoot at enemies

  START_OFF - Starts off
  UPSIDE_DOWN - make it rest on a surface/floor instead of hanging from the ceiling
  CANRESPAWN - will respawn after being killed (use count)
  TURBO - Big-ass, Boxy Death Star Turbo Laser version
  LEAD - Turret will aim ahead of moving targets ("lead" them)
  SHOWRADAR - show on radar

  radius - How far away an enemy can be for it to pick it up (default 512)
  wait	- Time between shots (default 150 ms)
  dmg	- How much damage each shot does (default 5)
  health - How much damage it can take before exploding (default 100)
  count - if CANRESPAWN spawnflag, decides how long it is before gun respawns (in ms) - defaults to 20000 (20 seconds)

  paintarget - target to fire off upon being hurt
  painwait - ms to wait between firing off pain targets

  random - random error (in degrees) of projectile direction when it comes out of the muzzle (default is 2)

  shotspeed - the speed of the missile it fires travels at (default is 1100 for regular turrets, 20000 for TURBOLASERS)

  splashDamage - How much damage the explosion does
  splashRadius - The radius of the explosion

  targetname - Toggles it on/off
  target - What to use when destroyed
  target2 - What to use when it decides to start shooting at an enemy

  showhealth - set to 1 to show health bar on this entity when crosshair is over it

  teamowner - crosshair shows green for this team, red for opposite team
	0 - none
	1 - red
	2 - blue

  alliedTeam - team that this turret won't target
	0 - none
	1 - red
	2 - blue

  teamnodmg - team that turret does not take damage from
	0 - none
	1 - red
	2 - blue

  customscale - custom scaling size. 100 is normal size, 1024 is the max scaling. this will change the bounding box size, so be careful of starting in solid!

"icon" - icon that represents the objective on the radar
```
*/
//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:1029
func SP_misc_turretG2(_ base: Entity) {
    var customscaleVal: Int32 = 0
    var s: String = ""

    turretG2_set_models(base, false)

    G_SpawnInt("painwait", "0", &base.genericValue4)
    base.genericValue8 = 0

    G_SpawnInt("customscale", "0", &customscaleVal)
    base.s.iModelScale = customscaleVal
    if base.s.iModelScale != 0 {
        if base.s.iModelScale > 1023 {
            base.s.iModelScale = 1023
        }
        base.modelScale[2] = base.s.iModelScale / 100.0
        base.modelScale[1] = base.modelScale[2]
        base.modelScale[0] = base.modelScale[1]
    }

    G_SpawnString("icon", "", &s)
    if !s.isEmpty {
        // We have an icon, so index it now.  We are reusing the genericenemyindex
        // variable rather than adding a new one to the entity state.
        base.s.genericenemyindex = G_IconIndex(s)
    }

    finish_spawning_turretG2(base)

    if (base.spawnflags & 1) != 0 {
        base.s.frame = 1 // black
    } else {
        base.s.frame = 0 // glow
    }
    if !((base.spawnflags & SPF_TURRETG2_TURBO) != 0) {
        base.s.eFlags |= EF_SHADER_ANIM
    }

    if (base.spawnflags & SPF_SHOWONRADAR) != 0 {
        base.s.eFlags |= EF_RADAROBJECT
    }
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret_G2.c:1084
func finish_spawning_turretG2(_ base: Entity) {
    var fwd = vec3_t()
    var t: Int32 = 0

    if (base.spawnflags & 2) != 0 {
        base.s.angles[ROLL] += 180
        base.s.origin[2] -= 22.0
    }

    G_SetAngles(base, base.s.angles)
    // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("finish_spawning_turretG2", source: "oracle/codemp/game/g_turret_G2.c:1084")
    var scratchRight = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("finish_spawning_turretG2", source: "oracle/codemp/game/g_turret_G2.c:1084")
    var scratchUp = vec3_t()
    AngleVectors(base.r.currentAngles, &fwd, &scratchRight, &scratchUp)

    G_SetOrigin(base, &base.s.origin)

    base.s.eType = ET_GENERAL

    if base.team != nil && !base.team!.isEmpty && base.teamnodmg == 0 {
        base.teamnodmg = atoi(base.team!)
    }
    base.team = nil

    // Set up our explosion effect for the ExplodeDeath code....
    G_EffectIndex("turret/explode")
    G_EffectIndex("sparks/spark_exp_nosnd")

    base.use = Use.turretG2_base_use
    base.pain = Pain.TurretG2Pain

    // don't start working right away
    base.think = Think.turretG2_base_think
    base.nextthink = level.time + FRAMETIME * 5

    // this is really the pitch angle.....
    base.speed = 0

    // respawn time defaults to 20 seconds
    if (base.spawnflags & SPF_TURRETG2_CANRESPAWN) != 0 && base.count == 0 {
        base.count = 20000
    }

    G_SpawnFloat("shotspeed", "0", &base.mass)
    if (base.spawnflags & SPF_TURRETG2_TURBO) != 0 {
        if base.random == 0 {
            //error worked into projectile direction
            base.random = 2.0
        }

        if base.mass == 0 {
            //misnomer: speed of projectile
            base.mass = 20000
        }

        if base.health == 0 {
            base.health = 2000
        }

        // search radius
        if base.radius == 0 {
            base.radius = 32768
        }

        // How quickly to fire
        if base.wait == 0 {
            base.wait = 1000 // + random() * 500;
        }

        if base.splashDamage == 0 {
            base.splashDamage = 200
        }

        if base.splashRadius == 0 {
            base.splashRadius = 500
        }

        // how much damage each shot does
        if base.damage == 0 {
            base.damage = 500
        }

        if (base.spawnflags & SPF_TURRETG2_TURBO) != 0 {
            base.r.maxs = vec3_t(64.0, 64.0, 30.0)
            base.r.mins = vec3_t(-64.0, -64.0, -30.0)
        }
        //start in "off" anim
        TurboLaser_SetBoneAnim(base, 4, 5)
        if g_gametype.integer == GT_SIEGE {
            //FIXME: designer-specified?
            //FIXME: put on other entities, too, particularly siege objectives and bbrushes...
            base.s.eFlags2 |= EF2_BRACKET_ENTITY
        }
    } else {
        if base.random == 0 {
            //error worked into projectile direction
            base.random = 2.0
        }

        if base.mass == 0 {
            //misnomer: speed of projectile
            base.mass = 1100
        }

        if base.health == 0 {
            base.health = 100
        }

        // search radius
        if base.radius == 0 {
            base.radius = 512
        }

        // How quickly to fire
        if base.wait == 0 {
            // The SDK also declares `random`, so the call names the bg module.
            base.wait = 150 + JKAMP_BG.random() * 55
        }

        if base.splashDamage == 0 {
            base.splashDamage = 10
        }

        if base.splashRadius == 0 {
            base.splashRadius = 25
        }

        // how much damage each shot does
        if base.damage == 0 {
            base.damage = 5
        }

        if (base.spawnflags & 2) != 0 {
            //upside-down, invert r.mins and maxe
            base.r.maxs = vec3_t(10.0, 10.0, 30.0)
            base.r.mins = vec3_t(-10.0, -10.0, 0.0)
        } else {
            base.r.maxs = vec3_t(10.0, 10.0, 0.0)
            base.r.mins = vec3_t(-10.0, -10.0, -30.0)
        }
    }

    //stash health off for respawn.  NOTE: cannot use maxhealth because that might not be set if not showing the health bar
    base.genericValue6 = base.health

    G_SpawnInt("showhealth", "0", &t)
    if t != 0 {
        //a non-0 maxhealth value will mean we want to show the health on the hud
        base.maxHealth = base.health
        G_ScaleNetHealth(base)
        base.s.shouldtarget = true
        //base->s.owner = MAX_CLIENTS; //not owned by any client
    }

    if base.s.iModelScale != 0 {
        //let's scale the bbox too...
        let fScale: Float = base.s.iModelScale / 100.0
        base.r.mins = base.r.mins * fScale
        base.r.maxs = base.r.maxs * fScale
    }

    // Precache special FX and moving sounds
    if (base.spawnflags & SPF_TURRETG2_TURBO) != 0 {
        base.genericValue13 = G_EffectIndex("turret/turb_muzzle_flash")
        base.genericValue14 = G_EffectIndex("turret/turb_shot")
        base.genericValue15 = G_EffectIndex("turret/turb_impact")
        //FIXME: Turbo Laser Cannon sounds!
        G_SoundIndex("sound/vehicles/weapons/turbolaser/turn.wav")
    } else {
        G_SoundIndex("sound/chars/turret/startup.wav")
        G_SoundIndex("sound/chars/turret/shutdown.wav")
        G_SoundIndex("sound/chars/turret/ping.wav")
        G_SoundIndex("sound/chars/turret/move.wav")
    }

    base.r.contents = CONTENTS_BODY | CONTENTS_PLAYERCLIP | CONTENTS_MONSTERCLIP | CONTENTS_SHOTCLIP

    //base->max_health = base->health;
    base.takedamage = true
    base.die = Die.turretG2_die

    base.material = MAT_METAL
    //base->r.svFlags |= SVF_NO_TELEPORT|SVF_NONNPC_ENEMY|SVF_SELF_ANIMATING;

    // Register this so that we can use it for the missile effect
    RegisterItem(BG_FindItemForWeapon(WP_BLASTER)!)

    // But set us as a turret so that we can be identified as a turret
    base.s.weapon = WP_TURRET

    trap_LinkEntity(base)
}
