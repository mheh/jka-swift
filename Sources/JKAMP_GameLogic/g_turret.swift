import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_turret.c:126
private let START_DIS = 15 as Int32

//------------------------------------------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:11
func TurretPain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    if `self`.target_ent != nil {
        `self`.target_ent!.health = `self`.health
        if `self`.target_ent!.maxHealth != 0 {
            G_ScaleNetHealth(`self`.target_ent!)
        }
    }

    if attacker.client != nil && attacker.client!.ps.weapon == WP_DEMP2 {
        // The SDK also declares `random`, so the call names the bg module.
        `self`.attackDebounceTime = Int32(level.time + 800 + JKAMP_BG.random() * 500)
        `self`.painDebounceTime = `self`.attackDebounceTime
    }
    if `self`.enemy == nil {
        //react to being hit
        G_SetEnemy(`self`, attacker)
    }
}

//------------------------------------------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:35
func TurretBasePain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    if `self`.target_ent != nil {
        `self`.target_ent!.health = `self`.health
        if `self`.target_ent!.maxHealth != 0 {
            G_ScaleNetHealth(`self`.target_ent!)
        }

        TurretPain(`self`.target_ent!, attacker, damage)
    }
}

//------------------------------------------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:51
func auto_turret_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ meansOfDeath: Int32) {
    var forward = vec3_t(0, 0, 1)
    var pos = vec3_t()

    // Turn off the thinking of the base & use it's targets
    g_entities[`self`.r.ownerNum].think = nil
    g_entities[`self`.r.ownerNum].use = nil

    // clear my data
    `self`.die = nil
    `self`.takedamage = false
    `self`.health = 0
    `self`.s.health = `self`.health
    `self`.s.loopSound = 0
    `self`.s.shouldtarget = false
    //self->s.owner = MAX_CLIENTS; //not owned by any client

    pos = `self`.r.currentOrigin
    pos[2] += `self`.r.maxs[2] * 0.5
    G_PlayEffect(EFFECT_EXPLOSION_TURRET, pos, forward)
    G_PlayEffectID(G_EffectIndex("turret/explode"), pos, forward)

    if `self`.splashDamage > 0 && `self`.splashRadius > 0 {
        G_RadiusDamage(`self`.r.currentOrigin, attacker, Float(`self`.splashDamage), Float(`self`.splashRadius), attacker, nil, MOD_UNKNOWN)
    }

    `self`.s.weapon = 0 // crosshair code uses this to mark crosshair red


    if `self`.s.modelindex2 != 0 {
        // switch to damage model if we should
        `self`.s.modelindex = `self`.s.modelindex2

        if `self`.target_ent != nil && `self`.target_ent!.s.modelindex2 != 0 {
            `self`.target_ent!.s.modelindex = `self`.target_ent!.s.modelindex2
        }

        `self`.s.apos.trBase = `self`.r.currentAngles
        `self`.s.apos.trDelta = vec3_t()

        if `self`.target != nil {
            G_UseTargets(`self`, attacker)
        }
    } else {
        ObjectDie(`self`, inflictor, attacker, damage, meansOfDeath)
    }
}

//------------------------------------------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:112
func bottom_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ meansOfDeath: Int32) {
    if `self`.target_ent != nil && `self`.target_ent!.health > 0 {
        `self`.target_ent!.health = `self`.health
        if `self`.target_ent!.maxHealth != 0 {
            G_ScaleNetHealth(`self`.target_ent!)
        }
        auto_turret_die(`self`.target_ent!, inflictor, attacker, damage, meansOfDeath)
    }
}

//----------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:129
private func turret_fire(_ ent: Entity, _ start: JKAShared.vec3_t, _ dir: JKAShared.vec3_t) {
    var org = vec3_t()
    var bolt: Entity?

    if (trap_PointContents(start, ent.s.number) & MASK_SHOT) != 0 {
        return
    }

    _VectorMA(start, Float(-START_DIS), dir, &org) // dumb....
    G_PlayEffectID(ent.genericValue13, org, dir)

    bolt = G_Spawn()

    //use a custom shot effect
    bolt!.s.otherEntityNum2 = ent.genericValue14
    //use a custom impact effect
    bolt!.s.emplacedOwner = ent.genericValue15

    bolt!.classname = "turret_proj"
    bolt!.nextthink = level.time + 10000
    bolt!.think = Think.G_FreeEntity
    bolt!.s.eType = ET_MISSILE
    bolt!.s.weapon = WP_EMPLACED_GUN
    bolt!.r.ownerNum = ent.s.number
    bolt!.damage = ent.damage
    bolt!.alliedTeam = ent.alliedTeam
    bolt!.teamnodmg = ent.teamnodmg
    //bolt->dflags = DAMAGE_NO_KNOCKBACK;// | DAMAGE_HEAVY_WEAP_CLASS;		// Don't push them around, or else we are constantly re-aiming
    bolt!.splashDamage = ent.damage
    bolt!.splashRadius = 100
    bolt!.methodOfDeath = MOD_TARGET_LASER
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

    bolt!.parent = ent
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:179
func turret_head_think(_ `self`: Entity) {
    let top: Entity? = g_entities[`self`.r.ownerNum]
    if top == nil {
        return
    }
    if `self`.painDebounceTime > level.time {
        var v_up = vec3_t()
        v_up = vec3_t(0, 0, 1)
        G_PlayEffect(EFFECT_SPARKS, `self`.r.currentOrigin, v_up)
        if Q_irand(0, 3) != 0 {
            //25% chance of still firing
            return
        }
    }
    // if it's time to fire and we have an enemy, then gun 'em down!  pushDebounce time controls next fire time
    if `self`.enemy != nil && `self`.setTime < level.time && `self`.attackDebounceTime < level.time {
        var fwd = vec3_t()
        var org = vec3_t()
        // set up our next fire time
        `self`.setTime = Int32(level.time + `self`.wait)

        /*
        mdxaBone_t	boltMatrix;

        // Getting the flash bolt here
        gi.G2API_GetBoltMatrix( self->ghoul2, self->playerModel,
        self->torsoBolt,
        &boltMatrix, self->r.currentAngles, self->r.currentOrigin, (cg.time?cg.time:level.time),
        NULL, self->s.modelScale );

        gi.G2API_GiveMeVectorFromMatrix( boltMatrix, ORIGIN, org );
        gi.G2API_GiveMeVectorFromMatrix( boltMatrix, POSITIVE_Y, fwd );
        */
        org = top!.r.currentOrigin
        org[2] += top!.r.maxs[2] - 8
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("turret_head_think", source: "oracle/codemp/game/g_turret.c:179")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("turret_head_think", source: "oracle/codemp/game/g_turret.c:179")
        var scratchUp = vec3_t()
        AngleVectors(top!.r.currentAngles, &fwd, &scratchRight, &scratchUp)

        _VectorMA(org, Float(START_DIS), fwd, &org)

        turret_fire(top!, org, fwd)
        `self`.fly_sound_debounce_time = level.time //used as lastShotTime
    }
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:228
private func turret_aim(_ `self`: Entity) {
    var enemyDir = vec3_t()
    var org = vec3_t()
    var org2 = vec3_t()
    var desiredAngles = vec3_t()
    var setAngle = vec3_t()
    var diffYaw: Float = 0.0
    var diffPitch: Float = 0.0
    var turnSpeed: Float
    let pitchCap: Float = 40.0
    let top: Entity? = g_entities[`self`.r.ownerNum]
    if top == nil {
        return
    }

    // move our gun base yaw to where we should be at this time....
    BG_EvaluateTrajectory(top!.s.apos, level.time, &top!.r.currentAngles)
    top!.r.currentAngles[YAW] = AngleNormalize180(top!.r.currentAngles[YAW])
    top!.r.currentAngles[PITCH] = AngleNormalize180(top!.r.currentAngles[PITCH])
    turnSpeed = top!.speed

    if `self`.painDebounceTime > level.time {
        desiredAngles[YAW] = top!.r.currentAngles[YAW] + flrand(-45, 45)
        desiredAngles[PITCH] = top!.r.currentAngles[PITCH] + flrand(-10, 10)

        if desiredAngles[PITCH] < -pitchCap {
            desiredAngles[PITCH] = -pitchCap
        } else if desiredAngles[PITCH] > pitchCap {
            desiredAngles[PITCH] = pitchCap
        }

        diffYaw = AngleSubtract(desiredAngles[YAW], top!.r.currentAngles[YAW])
        diffPitch = AngleSubtract(desiredAngles[PITCH], top!.r.currentAngles[PITCH])
        turnSpeed = flrand(-5, 5)
    } else if `self`.enemy != nil {
        // ...then we'll calculate what new aim adjustments we should attempt to make this frame
        // Aim at enemy
        org = `self`.enemy!.r.currentOrigin
        org[2] += `self`.enemy!.r.maxs[2] * 0.5
        if `self`.enemy!.s.eType == ET_NPC && `self`.enemy!.s.NPC_class == CLASS_VEHICLE && `self`.enemy!.m_pVehicle != nil && `self`.enemy!.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
            //hack!
            org[2] += 32.0
        }
        /*
        mdxaBone_t	boltMatrix;

        // Getting the "eye" here
        gi.G2API_GetBoltMatrix( self->ghoul2, self->playerModel,
        self->torsoBolt,
        &boltMatrix, self->r.currentAngles, self->s.origin, (cg.time?cg.time:level.time),
        NULL, self->s.modelScale );

        gi.G2API_GiveMeVectorFromMatrix( boltMatrix, ORIGIN, org2 );
        */
        org2 = top!.r.currentOrigin

        enemyDir = org - org2
        vectoangles(enemyDir, &desiredAngles)
        desiredAngles[PITCH] = AngleNormalize180(desiredAngles[PITCH])

        if desiredAngles[PITCH] < -pitchCap {
            desiredAngles[PITCH] = -pitchCap
        } else if desiredAngles[PITCH] > pitchCap {
            desiredAngles[PITCH] = pitchCap
        }

        diffYaw = AngleSubtract(desiredAngles[YAW], top!.r.currentAngles[YAW])
        diffPitch = AngleSubtract(desiredAngles[PITCH], top!.r.currentAngles[PITCH])
    } else {
        //FIXME: Pan back and forth in original facing
        // no enemy, so make us slowly sweep back and forth as if searching for a new one
        desiredAngles[YAW] = sin(level.time * 0.0001 + top!.count)
        desiredAngles[YAW] *= 60.0
        desiredAngles[YAW] += `self`.s.angles[YAW]
        desiredAngles[YAW] = AngleNormalize180(desiredAngles[YAW])
        diffYaw = AngleSubtract(desiredAngles[YAW], top!.r.currentAngles[YAW])
        diffPitch = AngleSubtract(0, top!.r.currentAngles[PITCH])
        turnSpeed = 1.0
    }

    if diffYaw != 0 {
        // cap max speed....
        if abs(diffYaw) > turnSpeed {
            diffYaw = (diffYaw >= 0 ? turnSpeed : -turnSpeed)
        }
    }
    if diffPitch != 0 {
        if abs(diffPitch) > turnSpeed {
            // cap max speed
            diffPitch = (diffPitch > 0.0 ? turnSpeed : -turnSpeed)
        }
    }
    // ...then set up our desired yaw
    setAngle = vec3_t(diffPitch, diffYaw, 0)

    top!.s.apos.trBase = top!.r.currentAngles
    top!.s.apos.trDelta = setAngle * Float((1000 / FRAMETIME))
    top!.s.apos.trTime = level.time
    top!.s.apos.trType = TR_LINEAR_STOP
    top!.s.apos.trDuration = FRAMETIME

    if diffYaw != 0 || diffPitch != 0 {
        top!.s.loopSound = G_SoundIndex("sound/vehicles/weapons/hoth_turret/turn.wav")
    } else {
        top!.s.loopSound = 0
    }
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:355
private func turret_turnoff(_ `self`: Entity) {
    let top: Entity? = g_entities[`self`.r.ownerNum]
    if top != nil {
        //still have a top
        //stop it from rotating
        top!.s.apos.trBase = top!.r.currentAngles
        top!.s.apos.trDelta = vec3_t()
        top!.s.apos.trTime = level.time
        top!.s.apos.trType = TR_STATIONARY
    }

    `self`.s.loopSound = 0
    // shut-down sound
    //G_Sound( self, CHAN_BODY, G_SoundIndex( "sound/chars/turret/shutdown.wav" ));

    // Clear enemy
    `self`.enemy = nil
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:377
private func turret_sleep(_ `self`: Entity) {
    if `self`.enemy == nil {
        // we don't need to play sound
        return
    }

    // make turret play ping sound for 5 seconds
    `self`.aimDebounceTime = level.time + 5000

    // Clear enemy
    `self`.enemy = nil
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:394
private func turret_find_enemies(_ `self`: Entity) -> Bool {
    var found: Bool = false
    var i: Int32 = 0
    var count: Int32 = 0
    var bestDist: Float = `self`.radius * `self`.radius
    var enemyDist: Float = 0
    var enemyDir = vec3_t()
    var org = vec3_t()
    var org2 = vec3_t()
    // Port-note: A local `gentity_t *[1024] entity_list` the table has no type for.
    // Raven wrote: gentity_t *entity_list[MAX_GENTITIES];
    portMissing("turret_find_enemies", source: "oracle/codemp/game/g_turret.c:394")
    var target: Entity?
    var bestTarget: Entity? = nil
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        let top: Entity? = g_entities[`self`.r.ownerNum]
        if top == nil {
            return false
        }

        if `self`.aimDebounceTime > level.time {
            // We were active and alert, i.e. had an enemy in the last 3 secs
            if `self`.timestamp < level.time {
                //G_Sound(self, CHAN_BODY, G_SoundIndex( "sound/chars/turret/ping.wav" ));
                `self`.timestamp = level.time + 1000
            }
        }

        org2 = top!.r.currentOrigin

        // Port-note: A read of `entity_list`, a local the draft left as a hole.
        // Raven wrote: count = G_RadiusList( org2, self->radius, self, qtrue, entity_list )
        portMissing("turret_find_enemies", source: "oracle/codemp/game/g_turret.c:394")

        i = 0
        while i < count {
            // Port-note: A read of `entity_list`, a local the draft left as a hole.
            // Raven wrote: target = entity_list[i]
            portMissing("turret_find_enemies", source: "oracle/codemp/game/g_turret.c:394")

            if target!.client == nil {
                // only attack clients
                i += 1
                continue
            }
            if target == `self` || !target!.takedamage || target!.health <= 0 || (target!.flags & FL_NOTARGET) != 0 {
                i += 1
                continue
            }
            if target!.client!.sess.sessionTeam == TEAM_SPECTATOR {
                i += 1
                continue
            }
            if `self`.alliedTeam != 0 {
                if target!.client != nil {
                    if target!.client!.sess.sessionTeam == `self`.alliedTeam {
                        // A bot/client/NPC we don't want to shoot
                        i += 1
                        continue
                    }
                } else if target!.teamnodmg == `self`.alliedTeam {
                    // An ent we don't want to shoot
                    i += 1
                    continue
                }
            }
            if !trap_InPVS(org2, target!.r.currentOrigin) {
                i += 1
                continue
            }

            org = target!.r.currentOrigin
            org[2] += target!.r.maxs[2] * 0.5

            // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
            portMissing("turret_find_enemies", source: "oracle/codemp/game/g_turret.c:394")
            // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
            portMissing("turret_find_enemies", source: "oracle/codemp/game/g_turret.c:394")
            trap_Trace(tr, org2, vec3_origin, vec3_origin, org, `self`.s.number, MASK_SHOT)

            if tr.allsolid == 0 && tr.startsolid == 0 && (Double(tr.fraction) == 1.0 || tr.entityNum == target!.s.number) {
                // Only acquire if have a clear shot, Is it in range and closer than our best?
                enemyDir = target!.r.currentOrigin - top!.r.currentOrigin
                enemyDist = VectorLengthSquared(enemyDir)

                if enemyDist < bestDist || (Q_stricmp("atst_vehicle", target!.NPC_type!) == 0 && bestTarget != nil && Q_stricmp("atst_vehicle", bestTarget!.NPC_type!) != 0) {
                    if `self`.attackDebounceTime < level.time {
                        // We haven't fired or acquired an enemy in the last 2 seconds-start-up sound
                        //G_Sound( self, CHAN_BODY, G_SoundIndex( "sound/chars/turret/startup.wav" ));

                        // Wind up turrets for a bit
                        `self`.attackDebounceTime = level.time + 1400
                    }

                    bestTarget = target
                    bestDist = enemyDist
                    found = true
                }
            }
            i += 1
        }

        if found {
            G_SetEnemy(`self`, bestTarget!)
            // Port-note: No operator between the operands, the text there is ``.
            // Raven wrote: if ( VALIDSTRING( self->target2 )) { G_UseTargets2( self, self, self->target2 ); }
            portMissing("turret_find_enemies", source: "oracle/codemp/game/g_turret.c:394")
        }

        return found
    }
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:505
func turret_base_think(_ `self`: Entity) {
    var turnOff: Bool = true
    var enemyDist: Float = 0
    var enemyDir = vec3_t()
    var org = vec3_t()
    var org2 = vec3_t()

    if (`self`.spawnflags & 1) != 0 {
        // not turned on
        turret_turnoff(`self`)

        // No target
        `self`.flags |= FL_NOTARGET
        `self`.nextthink = -1 //never think again
        return
    } else {
        // I'm all hot and bothered
        `self`.flags &= ~FL_NOTARGET
        //remember to keep thinking!
        `self`.nextthink = level.time + FRAMETIME
    }

    if `self`.enemy == nil {
        if turret_find_enemies(`self`) {
            turnOff = false
        }
    } else if `self`.enemy!.client != nil && `self`.enemy!.client!.sess.sessionTeam == TEAM_SPECTATOR {
        //don't keep going after spectators
        `self`.enemy = nil
    } else {
        //FIXME: remain single-minded or look for a new enemy every now and then?
        if `self`.enemy!.health > 0 {
            // enemy is alive
            enemyDir = `self`.enemy!.r.currentOrigin - `self`.r.currentOrigin
            enemyDist = VectorLengthSquared(enemyDir)

            if enemyDist < (`self`.radius * `self`.radius) {
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
                        portMissing("turret_base_think", source: "oracle/codemp/game/g_turret.c:505")
                        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                        portMissing("turret_base_think", source: "oracle/codemp/game/g_turret.c:505")
                        trap_Trace(tr, org2, vec3_origin, vec3_origin, org, `self`.s.number, MASK_SHOT)

                        if tr.allsolid == 0 && tr.startsolid == 0 && tr.entityNum == `self`.enemy!.s.number {
                            turnOff = false // Can see our enemy
                        }
                    }
                }
            }
        }

        turret_head_think(`self`)
    }

    if turnOff {
        if `self`.bounceCount < level.time {
            turret_sleep(`self`)
        }
    } else {
        // keep our enemy for a minimum of 2 seconds from now
        // The SDK also declares `random`, so the call names the bg module.
        `self`.bounceCount = Int32(level.time + 2000 + JKAMP_BG.random() * 150)
    }

    turret_aim(`self`)
}

//-----------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:604
func turret_base_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    // Toggle on and off
    `self`.spawnflags = (`self`.spawnflags ^ 1)

    /*
    if (( self->s.eFlags & EF_SHADER_ANIM ) && ( self->spawnflags & 1 )) // Start_Off
    {
    self->s.frame = 1; // black
    }
    else
    {
    self->s.frame = 0; // glow
    }
    */
}

/**
```
QUAKED misc_turret (1 0 0) (-48 -48 0) (48 48 144) START_OFF
Large 2-piece turbolaser turret

  START_OFF - Starts off

  radius - How far away an enemy can be for it to pick it up (default 1024)
  wait	- Time between shots (default 300 ms)
  dmg	- How much damage each shot does (default 100)
  health - How much damage it can take before exploding (default 3000)
  speed - how fast it turns (default 10)

  splashDamage - How much damage the explosion does (300)
  splashRadius - The radius of the explosion (128)

  shotspeed - speed at which projectiles will move

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

"icon" - icon that represents the objective on the radar
```
*/
//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:663
func SP_misc_turret(_ base: Entity) {
    var s: String = ""

    base.s.modelindex2 = G_ModelIndex("models/map_objects/hoth/turret_bottom.md3")
    base.s.modelindex = G_ModelIndex("models/map_objects/hoth/turret_base.md3")
    //base->playerModel = gi.G2API_InitGhoul2Model( base->ghoul2, "models/map_objects/imp_mine/turret_canon.glm", base->s.modelindex );
    //base->s.radius = 80.0f;

    //gi.G2API_SetBoneAngles( &base->ghoul2[base->playerModel], "Bone_body", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_Y, POSITIVE_Z, POSITIVE_X, NULL );
    //base->torsoBolt = gi.G2API_AddBolt( &base->ghoul2[base->playerModel], "*flash03" );

    G_SpawnString("icon", "", &s)
    if !s.isEmpty {
        // We have an icon, so index it now.  We are reusing the genericenemyindex
        // variable rather than adding a new one to the entity state.
        base.s.genericenemyindex = G_IconIndex(s)
    }

    G_SetAngles(base, base.s.angles)
    G_SetOrigin(base, &base.s.origin)

    base.r.contents = CONTENTS_BODY

    base.r.maxs = vec3_t(32.0, 32.0, 128.0)
    base.r.mins = vec3_t(-32.0, -32.0, 0.0)

    base.use = Use.turret_base_use
    base.think = Think.turret_base_think
    // don't start working right away
    base.nextthink = level.time + FRAMETIME * 5

    trap_LinkEntity(base)

    if !turret_base_spawn_top(base) {
        G_FreeEntity(base)
    }
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_turret.c:706
func turret_base_spawn_top(_ base: Entity) -> Bool {
    var org = vec3_t()
    var t: Int32 = 0

    let top: Entity? = G_Spawn()
    if top == nil {
        return false
    }

    top!.s.modelindex = G_ModelIndex("models/map_objects/hoth/turret_top_new.md3")
    top!.s.modelindex2 = G_ModelIndex("models/map_objects/hoth/turret_top.md3")
    G_SetAngles(top!, base.s.angles)
    org = base.s.origin
    org[2] += 128
    G_SetOrigin(top!, &org)

    base.r.ownerNum = top!.s.number
    top!.r.ownerNum = base.s.number

    if base.team != nil && !base.team!.isEmpty && base.teamnodmg == 0 {
        base.teamnodmg = atoi(base.team!)
    }
    base.team = nil
    top!.teamnodmg = base.teamnodmg
    top!.alliedTeam = base.alliedTeam

    base.s.eType = ET_GENERAL

    // Set up our explosion effect for the ExplodeDeath code....
    G_EffectIndex("turret/explode")
    G_EffectIndex("sparks/spark_exp_nosnd")
    G_EffectIndex("turret/hoth_muzzle_flash")

    // this is really the pitch angle.....
    top!.speed = 0

    // this is a random time offset for the no-enemy-search-around-mode
    // The SDK also declares `random`, so the call names the bg module.
    top!.count = Int32(JKAMP_BG.random() * 9000)

    if base.health == 0 {
        base.health = 3000
    }
    top!.health = base.health

    G_SpawnInt("showhealth", "0", &t)

    if t != 0 {
        //a non-0 maxhealth value will mean we want to show the health on the hud
        top!.maxHealth = base.health //acts as "maxhealth"
        G_ScaleNetHealth(top!)

        base.maxHealth = base.health
        G_ScaleNetHealth(base)
    }

    base.takedamage = true
    base.pain = Pain.TurretBasePain
    base.die = Die.bottom_die

    //design specified shot speed
    G_SpawnFloat("shotspeed", "1100", &base.mass)
    top!.mass = base.mass

    //even if we don't want to show health, let's at least light the crosshair up properly over ourself
    if top!.s.teamowner == 0 {
        top!.s.teamowner = top!.alliedTeam
    }

    base.alliedTeam = top!.alliedTeam
    base.s.teamowner = top!.s.teamowner

    base.s.shouldtarget = true
    top!.s.shouldtarget = true

    //link them to each other
    base.target_ent = top
    top!.target_ent = base

    //top->s.owner = MAX_CLIENTS; //not owned by any client

    // search radius
    if base.radius == 0 {
        base.radius = 1024
    }
    top!.radius = base.radius

    // How quickly to fire
    if base.wait == 0 {
        // The SDK also declares `random`, so the call names the bg module.
        base.wait = 300 + JKAMP_BG.random() * 55
    }
    top!.wait = base.wait

    if base.splashDamage == 0 {
        base.splashDamage = 300
    }
    top!.splashDamage = base.splashDamage

    if base.splashRadius == 0 {
        base.splashRadius = 128
    }
    top!.splashRadius = base.splashRadius

    // how much damage each shot does
    if base.damage == 0 {
        base.damage = 100
    }
    top!.damage = base.damage

    // how fast it turns
    if base.speed == 0 {
        base.speed = 20
    }
    top!.speed = base.speed

    top!.r.maxs = vec3_t(48.0, 48.0, 16.0)
    top!.r.mins = vec3_t(-48.0, -48.0, 0.0)
    // Precache moving sounds
    //G_SoundIndex( "sound/chars/turret/startup.wav" );
    //G_SoundIndex( "sound/chars/turret/shutdown.wav" );
    //G_SoundIndex( "sound/chars/turret/ping.wav" );
    G_SoundIndex("sound/vehicles/weapons/hoth_turret/turn.wav")
    top!.genericValue13 = G_EffectIndex("turret/hoth_muzzle_flash")
    top!.genericValue14 = G_EffectIndex("turret/hoth_shot")
    top!.genericValue15 = G_EffectIndex("turret/hoth_impact")

    top!.r.contents = CONTENTS_BODY

    //base->max_health = base->health;
    top!.takedamage = true
    top!.pain = Pain.TurretPain
    top!.die = Die.auto_turret_die

    top!.material = MAT_METAL
    //base->r.svFlags |= SVF_NO_TELEPORT|SVF_NONNPC_ENEMY|SVF_SELF_ANIMATING;

    // Register this so that we can use it for the missile effect
    RegisterItem(BG_FindItemForWeapon(WP_EMPLACED_GUN)!)

    // But set us as a turret so that we can be identified as a turret
    top!.s.weapon = WP_EMPLACED_GUN

    trap_LinkEntity(top!)
    return true
}
