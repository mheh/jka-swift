import Foundation
import JKAMP
import JKAShared

/// Source: oracle/codemp/game/bg_slidemove.c:48
let MAX_IMPACT_TURN_ANGLE = 45.0 as Float

/// Source: oracle/codemp/game/bg_slidemove.c:633
let MAX_CLIP_PLANES = 5 as Int32

/// Source: oracle/codemp/game/bg_slidemove.c:49
func PM_VehicleImpact(_ pEnt: JKAMP.BgEntity, _ trace: JKAMP.Trace) {
    // See if the vehicle has crashed into the ground.
    let pSelfVeh: Vehicle? = pEnt.m_pVehicle
    var magnitude: Float = VectorLength(pm.ps.velocity) * pSelfVeh!.m_pVehicleInfo!.mass / 50.0
    var forceSurfDestruction: Bool = false
    let hitEnt: BgEntity? = trace != nil ? pm.entity(at: trace.entityNum) : nil

    if hitEnt == nil || (pSelfVeh != nil && pSelfVeh!.m_pPilot != nil && hitEnt != nil && hitEnt!.s.eType == ET_MISSILE && bgEntityInuse(hitEnt!) && bgEntityOwnerNum(hitEnt!) == pSelfVeh!.m_pPilot!.s.number) {
        //don't hit it
        return
    }

    if pSelfVeh != nil && pSelfVeh!.m_iRemovedSurfaces != 0 {
        //spiralling to our deaths, explode on any solid impact
        if hitEnt!.s.NPC_class == CLASS_VEHICLE {
            //hit another vehicle, explode!
            //Give credit to whoever got me into this death spiral state
            G_DamageFromKiller(pEnt, pSelfVeh!.m_pParentEntity!, hitEnt, &pm.ps.origin, 999999, DAMAGE_NO_ARMOR, MOD_COLLISION)
            return
        } else if VectorCompare(trace.plane.normal, vec3_origin) == 0 && (trace.entityNum == ENTITYNUM_WORLD || bgEntityBmodel(hitEnt!)) {
            //have a valid hit plane and we hit a solid brush
            var moveDir = vec3_t()
            let impactDot: Float
            moveDir = pm.ps.velocity
            VectorNormalize(&moveDir)
            impactDot = _DotProduct(moveDir, trace.plane.normal)
            if impactDot <= -0.7 {
                // Just DIE now
                //Give credit to whoever got me into this death spiral state
                G_DamageFromKiller(pEnt, pSelfVeh!.m_pParentEntity!, hitEnt, &pm.ps.origin, 999999, DAMAGE_NO_ARMOR, MOD_FALLING)
                return
            }
        }
    }

    if trace.entityNum < ENTITYNUM_WORLD && hitEnt!.s.eType == ET_MOVER && hitEnt!.s.apos.trType != TR_STATIONARY && (bgEntitySpawnflags(hitEnt!) & 16) != 0 && Q_stricmp("func_rotating", bgEntityClassname(hitEnt!)!) == 0 {
        //hit a func_rotating that is supposed to destroy anything it touches!
        //guarantee the hit will happen, thereby taking off a piece of the ship
        forceSurfDestruction = true
    } else if (abs(pm.ps.velocity[0]) + abs(pm.ps.velocity[1])) < 100.0 && pm.ps.velocity[2] > -100.0 {
        //we're landing, we're cool
        //FIXME: some sort of landing "thump", not the impactFX
        /*
        if ( pSelfVeh->m_pVehicleInfo->iImpactFX )
        {
        vec3_t up = {0,0,1};
        #ifdef QAGAME
        G_PlayEffectID( pSelfVeh->m_pVehicleInfo->iImpactFX, pm->ps->origin, up );
        #else
        trap_FX_PlayEffectID( pSelfVeh->m_pVehicleInfo->iImpactFX, pm->ps->origin, up, -1, -1 );
        #endif
        }
        */
        //this was annoying me -rww
        //FIXME: this shouldn't even be getting called when the vehicle is at rest!
        if hitEnt != nil && (hitEnt!.s.eType == ET_PLAYER || hitEnt!.s.eType == ET_NPC) && pSelfVeh!.m_pVehicleInfo!.type == VH_FIGHTER {
            //always smack players
        } else {
            return
        }
    }
    if pSelfVeh != nil && (pSelfVeh!.m_pVehicleInfo!.type == VH_SPEEDER || pSelfVeh!.m_pVehicleInfo!.type == VH_FIGHTER) && (magnitude >= 100 || forceSurfDestruction) {
        if pEnt.m_pVehicle!.m_iHitDebounce < pm.cmd.serverTime || forceSurfDestruction {
            //a bit of a hack, may conflict with getting shot, but...
            //FIXME: impact sound and effect should be gotten from g_vehicleInfo...?
            //FIXME: should pass in trace.endpos and trace.plane.normal
            var vehUp = vec3_t()
            var noDamage: Bool = false

            if pSelfVeh!.m_iRemovedSurfaces == 0 && !forceSurfDestruction {
                var turnFromImpact: Bool = false
                var turnHitEnt: Bool = false
                var l: Float = pm.ps.speed * 0.5
                var bounceDir = vec3_t()
                if (trace.entityNum == ENTITYNUM_WORLD || hitEnt!.s.solid == SOLID_BMODEL) && VectorCompare(trace.plane.normal, vec3_origin) == 0 {
                    //bounce off in the opposite direction of the impact
                    if pSelfVeh!.m_pVehicleInfo!.type == VH_SPEEDER {
                        pm.ps.speed *= pml.frametime
                        bounceDir = trace.plane.normal
                    } else if trace.plane.normal[2] >= MIN_LANDING_SLOPE && pSelfVeh!.m_LandTrace.fraction < 1.0 && pm.ps.speed <= MIN_LANDING_SPEED {
                        //could land here, don't bounce off, in fact, return altogether!
                        return
                    } else {
                        if pSelfVeh!.m_pVehicleInfo!.type == VH_FIGHTER {
                            turnFromImpact = true
                        }
                        bounceDir = trace.plane.normal
                    }
                } else if pSelfVeh!.m_pVehicleInfo!.type == VH_FIGHTER {
                    //check for impact with another fighter
                    if hitEnt!.s.NPC_class == CLASS_VEHICLE && hitEnt!.m_pVehicle != nil && hitEnt!.m_pVehicle!.m_pVehicleInfo != nil && hitEnt!.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
                        //two vehicles hit each other, turn away from the impact
                        turnFromImpact = true
                        turnHitEnt = true
                        bounceDir = pm.ps.origin - bgEntityCurrentOrigin(hitEnt!)
                        VectorNormalize(&bounceDir)
                    }
                }
                if turnFromImpact {
                    //bounce off impact surf and turn away
                    var pushDir = vec3_t(0, 0, 0)
                    var turnAwayAngles = vec3_t()
                    var turnDelta = vec3_t()
                    var turnStrength: Float
                    var pitchTurnStrength: Float
                    var yawTurnStrength: Float
                    var moveDir = vec3_t()
                    var bounceDot: Float
                    var turnDivider: Float
                    //bounce
                    if !turnHitEnt {
                        //hit wall
                        pushDir = bounceDir * (pm.ps.speed * 0.25 / pSelfVeh!.m_pVehicleInfo!.mass)
                    } else {
                        //hit another fighter
                        if hitEnt!.playerState != nil {
                            pushDir = bounceDir * ((pm.ps.speed + hitEnt!.playerState!.speed) * 0.5)
                        } else {
                            pushDir = bounceDir * ((pm.ps.speed + hitEnt!.s.speed) * 0.5)
                        }
                        pushDir = pushDir * (l / pSelfVeh!.m_pVehicleInfo!.mass)
                        pushDir = pushDir * 0.1
                    }
                    VectorNormalize2(pm.ps.velocity, &moveDir)
                    bounceDot = _DotProduct(moveDir, bounceDir) * -1
                    if bounceDot < 0.1 {
                        bounceDot = 0.1
                    }
                    pushDir = pushDir * bounceDot
                    pm.ps.velocity = pm.ps.velocity + pushDir
                    //turn
                    turnDivider = (pSelfVeh!.m_pVehicleInfo!.mass / 400.0)
                    if turnHitEnt {
                        //don't turn as much when hit another ship
                        turnDivider *= 4.0
                    }
                    if turnDivider < 0.5 {
                        turnDivider = 0.5
                    }
                    turnStrength = (magnitude / 2000.0)
                    if turnStrength < 0.1 {
                        turnStrength = 0.1
                    } else if turnStrength > 2.0 {
                        turnStrength = 2.0
                    }
                    //get the angles we are going to turn towards
                    vectoangles(bounceDir, &turnAwayAngles)
                    //get the delta from our current angles to those new angles
                    AnglesSubtract(turnAwayAngles, pSelfVeh!.m_vOrientationVector, &turnDelta)
                    //now do pitch
                    if bounceDir[2] == 0 {
                        //shouldn't be any pitch
                    } else {
                        pitchTurnStrength = turnStrength * turnDelta[PITCH]
                        if pitchTurnStrength > MAX_IMPACT_TURN_ANGLE {
                            pitchTurnStrength = MAX_IMPACT_TURN_ANGLE
                        } else if pitchTurnStrength < -MAX_IMPACT_TURN_ANGLE {
                            pitchTurnStrength = -MAX_IMPACT_TURN_ANGLE
                        }
                        //pSelfVeh->m_vOrientation[PITCH] = AngleNormalize180(pSelfVeh->m_vOrientation[PITCH]+pitchTurnStrength/turnDivider*pSelfVeh->m_fTimeModifier);
                        pSelfVeh!.m_vFullAngleVelocity[PITCH] = AngleNormalize180(pSelfVeh!.m_vOrientationVector[PITCH] + pitchTurnStrength / turnDivider * pSelfVeh!.m_fTimeModifier)
                    }
                    //now do yaw
                    if bounceDir[0] == 0 && bounceDir[1] == 0 {
                        //shouldn't be any yaw
                    } else {
                        yawTurnStrength = turnStrength * turnDelta[YAW]
                        if yawTurnStrength > MAX_IMPACT_TURN_ANGLE {
                            yawTurnStrength = MAX_IMPACT_TURN_ANGLE
                        } else if yawTurnStrength < -MAX_IMPACT_TURN_ANGLE {
                            yawTurnStrength = -MAX_IMPACT_TURN_ANGLE
                        }
                        //pSelfVeh->m_vOrientation[ROLL] = AngleNormalize180(pSelfVeh->m_vOrientation[ROLL]-yawTurnStrength/turnDivider*pSelfVeh->m_fTimeModifier);
                        pSelfVeh!.m_vFullAngleVelocity[ROLL] = AngleNormalize180(pSelfVeh!.m_vOrientationVector[ROLL] - yawTurnStrength / turnDivider * pSelfVeh!.m_fTimeModifier)
                    }
                    /*
                    PM_SetPMViewAngle(pm->ps, pSelfVeh->m_vOrientation, &pSelfVeh->m_ucmd);
                    if ( pm_entVeh )
                    {//I'm a vehicle, so pm_entVeh is actually my pilot
                    bgEntity_t *pilot = pm_entVeh;
                    if ( !BG_UnrestrainedPitchRoll( pilot->playerState, pSelfVeh ) )
                    {
                    //set the rider's viewangles to the vehicle's viewangles
                    PM_SetPMViewAngle(pilot->playerState, pSelfVeh->m_vOrientation, &pSelfVeh->m_ucmd);
                    }
                    }
                    */
                    if turnHitEnt && hitEnt!.playerState != nil && !FighterIsLanded(hitEnt!.m_pVehicle!, hitEnt!.playerState!) && !((bgEntitySpawnflags(hitEnt!) & 2) != 0) {
                        l = hitEnt!.playerState!.speed
                        //now bounce *them* away and turn them
                        //flip the bounceDir
                        bounceDir = bounceDir * -1
                        //do bounce
                        pushDir = bounceDir * ((pm.ps.speed + l) * 0.5)
                        pushDir = pushDir * (l * 0.5 / hitEnt!.m_pVehicle!.m_pVehicleInfo!.mass)
                        VectorNormalize2(hitEnt!.playerState!.velocity, &moveDir)
                        bounceDot = _DotProduct(moveDir, bounceDir) * -1
                        if bounceDot < 0.1 {
                            bounceDot = 0.1
                        }
                        pushDir = pushDir * bounceDot
                        hitEnt!.playerState!.velocity = hitEnt!.playerState!.velocity + pushDir
                        //turn
                        turnDivider = (hitEnt!.m_pVehicle!.m_pVehicleInfo!.mass / 400.0)
                        if turnHitEnt {
                            //don't turn as much when hit another ship
                            turnDivider *= 4.0
                        }
                        if turnDivider < 0.5 {
                            turnDivider = 0.5
                        }
                        //get the angles we are going to turn towards
                        vectoangles(bounceDir, &turnAwayAngles)
                        //get the delta from our current angles to those new angles
                        AnglesSubtract(turnAwayAngles, hitEnt!.m_pVehicle!.m_vOrientationVector, &turnDelta)
                        //now do pitch
                        if bounceDir[2] == 0 {
                            //shouldn't be any pitch
                        } else {
                            pitchTurnStrength = turnStrength * turnDelta[PITCH]
                            if pitchTurnStrength > MAX_IMPACT_TURN_ANGLE {
                                pitchTurnStrength = MAX_IMPACT_TURN_ANGLE
                            } else if pitchTurnStrength < -MAX_IMPACT_TURN_ANGLE {
                                pitchTurnStrength = -MAX_IMPACT_TURN_ANGLE
                            }
                            //hitEnt->m_pVehicle->m_vOrientation[PITCH] = AngleNormalize180(hitEnt->m_pVehicle->m_vOrientation[PITCH]+pitchTurnStrength/turnDivider*pSelfVeh->m_fTimeModifier);
                            hitEnt!.m_pVehicle!.m_vFullAngleVelocity[PITCH] = AngleNormalize180(hitEnt!.m_pVehicle!.m_vOrientationVector[PITCH] + pitchTurnStrength / turnDivider * pSelfVeh!.m_fTimeModifier)
                        }
                        //now do yaw
                        if bounceDir[0] == 0 && bounceDir[1] == 0 {
                            //shouldn't be any yaw
                        } else {
                            yawTurnStrength = turnStrength * turnDelta[YAW]
                            if yawTurnStrength > MAX_IMPACT_TURN_ANGLE {
                                yawTurnStrength = MAX_IMPACT_TURN_ANGLE
                            } else if yawTurnStrength < -MAX_IMPACT_TURN_ANGLE {
                                yawTurnStrength = -MAX_IMPACT_TURN_ANGLE
                            }
                            //hitEnt->m_pVehicle->m_vOrientation[ROLL] = AngleNormalize180(hitEnt->m_pVehicle->m_vOrientation[ROLL]-yawTurnStrength/turnDivider*pSelfVeh->m_fTimeModifier);
                            hitEnt!.m_pVehicle!.m_vFullAngleVelocity[ROLL] = AngleNormalize180(hitEnt!.m_pVehicle!.m_vOrientationVector[ROLL] - yawTurnStrength / turnDivider * pSelfVeh!.m_fTimeModifier)
                        }
                        //NOTE: will these angle changes stick or will they be stomped
                        //		when the vehicle goes through its own update and re-grabs
                        //		its angles from its pilot...?  Should we do a
                        //		SetClientViewAngles on the pilot?
                        /*
                        SetClientViewAngle( hitEnt, hitEnt->m_pVehicle->m_vOrientation );
                        if ( hitEnt->m_pVehicle->m_pPilot
                        && ((gentity_t *)hitEnt->m_pVehicle->m_pPilot)->client )
                        {
                        SetClientViewAngle( (gentity_t *)hitEnt->m_pVehicle->m_pPilot, hitEnt->m_pVehicle->m_vOrientation );
                        }
                        */
                    }
                }
            }

            if hitEnt == nil {
                return
            }

            // Raven passes NULL for the first and second outputs of `AngleVectors`.
            // The ported function takes them by reference, so the body passes scratch vectors it never reads.
            var scratchForward = vec3_t()
            var scratchRight = vec3_t()
            AngleVectors(pSelfVeh!.m_vOrientationVector, &scratchForward, &scratchRight, &vehUp)
            if pSelfVeh!.m_pVehicleInfo!.iImpactFX != 0 {
                //G_PlayEffectID( pSelfVeh->m_pVehicleInfo->iImpactFX, pm->ps->origin, vehUp );
                //tempent use bad!
                G_AddEvent(pEnt, EV_PLAY_EFFECT_ID, pSelfVeh!.m_pVehicleInfo!.iImpactFX)
            }
            pEnt.m_pVehicle!.m_iHitDebounce = pm.cmd.serverTime + 200
            magnitude /= pSelfVeh!.m_pVehicleInfo!.toughness * 50.0

            if hitEnt != nil && (hitEnt!.s.eType != ET_TERRAIN || !((bgEntitySpawnflags(hitEnt!) & 1) != 0) || pSelfVeh!.m_pVehicleInfo!.type == VH_FIGHTER) {
                //don't damage the vehicle from terrain that doesn't want to damage vehicles
                var killer: BgEntity? = nil
                if pSelfVeh!.m_pVehicleInfo!.type == VH_FIGHTER {
                    //increase the damage...
                    var mult: Float = (pSelfVeh!.m_vOrientationVector[PITCH] * 0.1)
                    if mult < 1.0 {
                        mult = 1.0
                    }
                    if bgEntityInuse(hitEnt!) && bgEntityTakedamage(hitEnt!) {
                        //if the other guy takes damage, don't hurt us a lot for ramming him
                        //unless it's a vehicle, then we get 1.5 times damage
                        if hitEnt!.s.eType == ET_NPC && hitEnt!.s.NPC_class == CLASS_VEHICLE && hitEnt!.m_pVehicle != nil {
                            mult = 1.5
                        } else {
                            mult = 0.5
                        }
                    }

                    magnitude *= mult
                }
                pSelfVeh!.m_iLastImpactDmg = Int32(magnitude)
                //FIXME: what about proper death credit to the guy who shot you down?
                //FIXME: actually damage part of the ship that impacted?
                if hitEnt!.s.eType == ET_MISSILE {
                    //FIX: NEVER do or take impact damage from a missile...
                    noDamage = true
                    if (hitEnt!.s.eFlags & EF_JETPACK_ACTIVE) != 0 && bgEntityOwnerNum(hitEnt!) < MAX_CLIENTS {
                        //I ran into a missile and died because of the impact, give credit to the missile's owner (PROBLEM: might this ever accidently give improper credit to client 0?)
                        /*
                        if ( ((gentity_t *)hitEnt)->r.ownerNum == pEnt->s.number )
                        {//hit our own missile?  Don't damage ourselves or it... (so we don't kill ourselves!) if it hits *us*, then fine, but not here
                        noDamage = qtrue;
                        }
                        */
                        killer = pm.entity(at: bgEntityOwnerNum(hitEnt!))
                    }
                }
                if !noDamage {
                    // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("PM_VehicleImpact", source: "oracle/codemp/game/bg_slidemove.c:49")
                    var scratchDir = vec3_t()
                    G_Damage(pEnt, (hitEnt), killer != nil ? killer : (hitEnt), &scratchDir, pm.ps.origin, Int32(magnitude * 5), DAMAGE_NO_ARMOR, (hitEnt!.s.NPC_class == CLASS_VEHICLE ? MOD_COLLISION : MOD_FALLING)) //FIXME: MOD_IMPACT
                }

                if pSelfVeh!.m_pVehicleInfo!.surfDestruction != 0 {
                    G_FlyVehicleSurfaceDestruction(pEnt, trace, Int32(magnitude), forceSurfDestruction)
                }

                pSelfVeh!.m_ulFlags |= UInt(bitPattern: Int(VEH_CRASHING))
            }

            if hitEnt != nil && bgEntityInuse(hitEnt!) && bgEntityTakedamage(hitEnt!) {
                //damage this guy because we hit him
                var pmult: Float = 1.0
                var finalD: Int32
                var attackEnt: BgEntity?

                if (hitEnt!.s.eType == ET_PLAYER && hitEnt!.s.number < MAX_CLIENTS) || (hitEnt!.s.eType == ET_NPC && hitEnt!.s.NPC_class != CLASS_VEHICLE) {
                    //probably a humanoid, or something
                    if pSelfVeh!.m_pVehicleInfo!.type == VH_FIGHTER {
                        //player die good.. if me fighter
                        pmult = 2000.0
                    } else {
                        pmult = 40.0
                    }

                    if hitEnt!.playerState != nil && BG_KnockDownable(hitEnt!.playerState!) && G_CanBeEnemy(pEnt, hitEnt!) {
                        //smash!
                        if hitEnt!.playerState!.forceHandExtend != HANDEXTEND_KNOCKDOWN {
                            hitEnt!.playerState!.forceHandExtend = HANDEXTEND_KNOCKDOWN
                            hitEnt!.playerState!.forceHandExtendTime = pm.cmd.serverTime + 1100
                            hitEnt!.playerState!.forceDodgeAnim = 0 //this toggles between 1 and 0, when it's 1 we should play the get up anim
                        }

                        hitEnt!.playerState!.otherKiller = pEnt.s.number
                        hitEnt!.playerState!.otherKillerTime = pm.cmd.serverTime + 5000
                        hitEnt!.playerState!.otherKillerDebounceTime = pm.cmd.serverTime + 100
                        bgSetClientOtherKillerMOD(hitEnt!, MOD_COLLISION)
                        bgSetClientOtherKillerVehWeapon(hitEnt!, 0)
                        bgSetClientOtherKillerWeaponType(hitEnt!, WP_NONE)

                        //add my velocity into his to force him along in the correct direction from impact
                        hitEnt!.playerState!.velocity = hitEnt!.playerState!.velocity + pm.ps.velocity
                        //upward thrust
                        hitEnt!.playerState!.velocity[2] += 200.0
                    }
                }

                if pSelfVeh!.m_pPilot != nil {
                    attackEnt = pSelfVeh!.m_pPilot!
                } else {
                    attackEnt = pEnt
                }

                finalD = Int32(magnitude * pmult)
                if finalD < 1 {
                    finalD = 1
                }
                if !noDamage {
                    // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("PM_VehicleImpact", source: "oracle/codemp/game/bg_slidemove.c:49")
                    var scratchDir2 = vec3_t()
                    G_Damage(hitEnt!, attackEnt, attackEnt, &scratchDir2, pm.ps.origin, finalD, 0, (hitEnt!.s.NPC_class == CLASS_VEHICLE ? MOD_COLLISION : MOD_FALLING)) //FIXME: MOD_IMPACT
                }
            }
            //it doesn't look bad though. could just use predicted events, but I'm too lazy.
        }
    }
}

/// Source: oracle/codemp/game/bg_slidemove.c:559
func PM_GroundSlideOkay(_ zNormal: Float) -> Bool {
    if zNormal > 0 {
        if pm.ps.velocity[2] > 0 {
            if pm.ps.legsAnim == BOTH_WALL_RUN_RIGHT || pm.ps.legsAnim == BOTH_WALL_RUN_LEFT || pm.ps.legsAnim == BOTH_WALL_RUN_RIGHT_STOP || pm.ps.legsAnim == BOTH_WALL_RUN_LEFT_STOP || pm.ps.legsAnim == BOTH_FORCEWALLRUNFLIP_START || pm.ps.legsAnim == BOTH_FORCELONGLEAP_START || pm.ps.legsAnim == BOTH_FORCELONGLEAP_ATTACK || pm.ps.legsAnim == BOTH_FORCELONGLEAP_LAND || BG_InReboundJump(pm.ps.legsAnim) {
                return false
            }
        }
    }
    return true
}

/// Source: oracle/codemp/game/bg_slidemove.c:590
func PM_ClientImpact(_ trace: JKAMP.Trace) -> Bool {
    //don't try to predict this
    var traceEnt: BgEntity?
    let otherEntityNum: Int32 = trace.entityNum

    if pm_entSelf == nil {
        return false
    }

    if otherEntityNum >= ENTITYNUM_WORLD {
        return false
    }

    traceEnt = pm.entity(at: otherEntityNum)

    if VectorLength(pm.ps.velocity) >= 100 && pm_entSelf!.s.NPC_class != CLASS_VEHICLE && pm.ps.lastOnGround + 100 < bgLevelTime() {
        Client_CheckImpactBBrush((pm_entSelf)!, pm.entity(at: otherEntityNum))
    }

    if traceEnt == nil || !((bgEntityContents(traceEnt!) & pm.tracemask) != 0) {
        //it's dead or not in my way anymore, don't clip against it
        return true
    }

    return false
}

/// Source: oracle/codemp/game/bg_slidemove.c:634
func PM_SlideMove(_ gravity: Bool) -> Bool {
    var bumpcount: Int32 = 0
    var numbumps: Int32 = 0
    var dir = vec3_t()
    var d: Float = 0
    var numplanes: Int32 = 0
    var normal = vec3_t()
    var planes = [vec3_t](repeating: vec3_t(), count: 5)
    var primal_velocity = vec3_t()
    var clipVelocity = vec3_t()
    var i: Int32 = 0
    var j: Int32 = 0
    var k: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        var end = vec3_t()
        var time_left: Float = 0
        var into: Float = 0
        var endVelocity = vec3_t()
        var endClipVelocity = vec3_t()
        //qboolean	damageSelf = qtrue;

        numbumps = 4

        primal_velocity = pm.ps.velocity

        if gravity {
            endVelocity = pm.ps.velocity
            endVelocity[2] -= pm.ps.gravity * pml.frametime
            pm.ps.velocity[2] = Float((Double(pm.ps.velocity[2]) + Double(endVelocity[2])) * 0.5)
            primal_velocity[2] = endVelocity[2]
            if pml.groundPlane {
                if PM_GroundSlideOkay(pml.groundTrace.plane.normal[2]) {
                    // slide along the ground plane
                    // Raven passes `pm.ps.velocity` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy. The last one writes back after the call, because a view's setter keeps the in-copy otherwise.
                    do {
                        var velocityIn0 = pm.ps.velocity
                        var velocityOut2 = pm.ps.velocity
                        PM_ClipVelocity(&velocityIn0, &pml.groundTrace.plane.normal, &velocityOut2, OVERCLIP)
                        pm.ps.velocity = velocityOut2
                    }
                }
            }
        }

        time_left = pml.frametime

        // never turn against the ground plane
        if pml.groundPlane {
            numplanes = 1
            planes[0] = pml.groundTrace.plane.normal
            if !PM_GroundSlideOkay(planes[0][2]) {
                planes[0][2] = 0
                VectorNormalize(&planes[0])
            }
        } else {
            numplanes = 0
        }

        // never turn against original velocity
        VectorNormalize2(pm.ps.velocity, &planes[numplanes])
        numplanes += 1

        bumpcount = 0
        while bumpcount < numbumps {
            // calculate position we are trying to move to
            _VectorMA(pm.ps.origin, time_left, pm.ps.velocity, &end)

            // see if we can make it there
            pm.runTrace(trace, pm.ps.origin, pm.mins, pm.maxs, end, pm.ps.clientNum, pm.tracemask)

            if trace.allsolid != 0 {
                // entity is completely trapped in another solid
                pm.ps.velocity[2] = 0 // don't build up falling damage, but allow sideways acceleration
                return true
            }

            if trace.fraction > 0 {
                // actually covered some distance
                pm.ps.origin = trace.endpos
            }

            if trace.fraction == 1 {
                break // moved the entire distance
            }

            // save entity for contact
            PM_AddTouchEnt(trace.entityNum)

            if pm.ps.clientNum >= MAX_CLIENTS {
                let pEnt: BgEntity? = pm_entSelf

                if pEnt != nil && pEnt!.s.eType == ET_NPC && pEnt!.s.NPC_class == CLASS_VEHICLE && pEnt!.m_pVehicle != nil {
                    //do vehicle impact stuff then
                    PM_VehicleImpact(pEnt!, trace)
                }
            } else {
                if PM_ClientImpact(trace) {
                    bumpcount += 1
                    continue
                }
            }

            time_left -= time_left * trace.fraction

            if numplanes >= MAX_CLIP_PLANES {
                // this shouldn't really happen
                pm.ps.velocity = vec3_t()
                return true
            }

            normal = trace.plane.normal

            if !PM_GroundSlideOkay(normal[2]) {
                //wall-running
                //never push up off a sloped wall
                normal[2] = 0
                VectorNormalize(&normal)
            }
            //
            // if this is the same plane we hit before, nudge velocity
            // out along it, which fixes some epsilon issues with
            // non-axial planes
            //
            if !((pm.ps.pm_flags & PMF_STUCK_TO_WALL) != 0) {
                //no sliding if stuck to wall!
                i = 0
                while i < numplanes {
                    if VectorCompare(normal, planes[i]) != 0 {
                        //DotProduct( normal, planes[i] ) > 0.99 ) {
                        pm.ps.velocity = normal + pm.ps.velocity
                        break
                    }
                    i += 1
                }
                if i < numplanes {
                    bumpcount += 1
                    continue
                }
            }
            planes[numplanes] = normal
            numplanes += 1

            //
            // modify velocity so it parallels all of the clip planes
            //

            // find a plane that it enters
            i = 0
            while i < numplanes {
                into = _DotProduct(pm.ps.velocity, planes[i])
                if into >= 0.1 {
                    i += 1
                    continue // move doesn't interact with the plane
                }

                // see how hard we are hitting things
                if -into > pml.impactSpeed {
                    pml.impactSpeed = -into
                }

                // slide along the plane
                PM_ClipVelocity(&pm.ps.velocity, &planes[i], &clipVelocity, OVERCLIP)

                // slide along the plane
                PM_ClipVelocity(&endVelocity, &planes[i], &endClipVelocity, OVERCLIP)

                // see if there is a second plane that the new move enters
                j = 0
                while j < numplanes {
                    if j == i {
                        j += 1
                        continue
                    }
                    if _DotProduct(clipVelocity, planes[j]) >= 0.1 {
                        j += 1
                        continue // move doesn't interact with the plane
                    }

                    // try clipping the move to the plane
                    // Raven passes `clipVelocity` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy.
                    do {
                        var clipVelocityIn0 = clipVelocity
                        PM_ClipVelocity(&clipVelocityIn0, &planes[j], &clipVelocity, OVERCLIP)
                    }
                    // Raven passes `endClipVelocity` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy.
                    do {
                        var endClipVelocityIn0 = endClipVelocity
                        PM_ClipVelocity(&endClipVelocityIn0, &planes[j], &endClipVelocity, OVERCLIP)
                    }

                    // see if it goes back into the first clip plane
                    if _DotProduct(clipVelocity, planes[i]) >= 0 {
                        j += 1
                        continue
                    }

                    // slide the original velocity along the crease
                    CrossProduct(planes[i], planes[j], &dir)
                    VectorNormalize(&dir)
                    d = _DotProduct(dir, pm.ps.velocity)
                    clipVelocity = dir * d

                    CrossProduct(planes[i], planes[j], &dir)
                    VectorNormalize(&dir)
                    d = _DotProduct(dir, endVelocity)
                    endClipVelocity = dir * d

                    // see if there is a third plane the the new move enters
                    k = 0
                    while k < numplanes {
                        if k == i || k == j {
                            k += 1
                            continue
                        }
                        if _DotProduct(clipVelocity, planes[k]) >= 0.1 {
                            k += 1
                            continue // move doesn't interact with the plane
                        }

                        // stop dead at a triple plane interaction
                        pm.ps.velocity = vec3_t()
                        return true
                        k += 1
                    }
                    j += 1
                }

                // if we have fixed all interactions, try another move
                pm.ps.velocity = clipVelocity
                endVelocity = endClipVelocity
                break
                i += 1
            }
            bumpcount += 1
        }

        if gravity {
            pm.ps.velocity = endVelocity
        }

        // don't change velocity if in a timer (FIXME: is this correct?)
        if pm.ps.pm_time != 0 {
            pm.ps.velocity = primal_velocity
        }

        return (bumpcount != 0)
    }
}

/**
```
==================
PM_StepSlideMove

==================
```
*/
/// Source: oracle/codemp/game/bg_slidemove.c:861
func PM_StepSlideMove(_ gravity: Bool) {
    var start_o = vec3_t()
    var start_v = vec3_t()
    var down_o = vec3_t()
    var down_v = vec3_t()
    // Raven assigns his own `gravity` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var gravity = gravity
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        //	float		down_dist, up_dist;
        //	vec3_t		delta, delta2;
        var up = vec3_t()
        var down = vec3_t()
        var stepSize: Float = 0
        var isGiant: Bool = false
        var pEnt: BgEntity?
        var skipStep: Bool = false

        start_o = pm.ps.origin
        start_v = pm.ps.velocity

        if BG_InReboundHold(pm.ps.legsAnim) {
            gravity = false
        }

        if !PM_SlideMove(gravity) {
            return true // we got exactly where we wanted to go first try
        }

        pEnt = pm_entSelf

        if pm.ps.clientNum >= MAX_CLIENTS {
            if pEnt != nil && pEnt!.s.NPC_class == CLASS_VEHICLE && pEnt!.m_pVehicle != nil && pEnt!.m_pVehicle!.m_pVehicleInfo!.hoverHeight > 0 {
                return true
            }
        }

        down = start_o
        down[2] -= STEPSIZE
        pm.runTrace(trace, start_o, pm.mins, pm.maxs, down, pm.ps.clientNum, pm.tracemask)
        up = vec3_t(0, 0, 1)
        // never step up when you still have up velocity
        if pm.ps.velocity[2] > 0 && (trace.fraction == 1.0 || _DotProduct(trace.plane.normal, up) < 0.7) {
            return true
        }

        down_o = pm.ps.origin
        down_v = pm.ps.velocity

        up = start_o

        if pm.ps.clientNum >= MAX_CLIENTS {
            // apply ground friction, even if on ladder
            if pEnt != nil && pEnt!.s.NPC_class == CLASS_ATST || (pEnt!.s.NPC_class == CLASS_VEHICLE && pEnt!.m_pVehicle != nil && pEnt!.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER) {
                //AT-STs can step high
                up[2] += 66.0
                isGiant = true
            } else if pEnt != nil && pEnt!.s.NPC_class == CLASS_RANCOR {
                //also can step up high
                up[2] += 64.0
                isGiant = true
            } else {
                up[2] += STEPSIZE
            }
        } else {
            up[2] += STEPSIZE
        }

        // test the player position if they were a stepheight higher
        pm.runTrace(trace, start_o, pm.mins, pm.maxs, up, pm.ps.clientNum, pm.tracemask)
        if trace.allsolid != 0 {
            if pm.debugLevel != 0 {
                Com_Printf("%i:bend can't step\n", c_pmove)
            }
            return true // can't step up
        }

        stepSize = trace.endpos[2] - start_o[2]
        // try slidemove from this position
        pm.ps.origin = trace.endpos
        pm.ps.velocity = start_v

        PM_SlideMove(gravity)

        // push down the final amount
        down = pm.ps.origin
        down[2] -= stepSize
        pm.runTrace(trace, pm.ps.origin, pm.mins, pm.maxs, down, pm.ps.clientNum, pm.tracemask)

        if pm.stepSlideFix != 0 {
            if pm.ps.clientNum < MAX_CLIENTS && trace.plane.normal[2] < MIN_WALK_NORMAL {
                //normal players cannot step up slopes that are too steep to walk on!
                var stepVec = vec3_t()
                //okay, the step up ends on a slope that it too steep to step up onto,
                //BUT:
                //If the step looks like this:
                //  (B)\__
                //        \_____(A)
                //Then it might still be okay, so we figure out the slope of the entire move
                //from (A) to (B) and if that slope is walk-upabble, then it's okay
                stepVec = trace.endpos - down_o
                VectorNormalize(&stepVec)
                if stepVec[2] > (1.0 - MIN_WALK_NORMAL) {
                    skipStep = true
                }
            }
        }

        if trace.allsolid == 0 && !skipStep {
            if pm.ps.clientNum >= MAX_CLIENTS && isGiant && trace.entityNum < MAX_CLIENTS && pEnt != nil && pEnt!.s.NPC_class == CLASS_RANCOR {
                //Rancor don't step on clients
                if pm.stepSlideFix != 0 {
                    pm.ps.origin = down_o
                    pm.ps.velocity = down_v
                } else {
                    pm.ps.origin = start_o
                    pm.ps.velocity = start_v
                }
            } else {
                /*
                else if ( pm->ps->clientNum >= MAX_CLIENTS//NPC
                && isGiant
                && trace.entityNum < MAX_CLIENTS
                && pEnt
                && pEnt->s.NPC_class == CLASS_ATST
                && OnSameTeam( pEnt, traceEnt) )
                {//NPC AT-ST's don't step up on allies
                VectorCopy (start_o, pm->ps->origin);
                VectorCopy (start_v, pm->ps->velocity);
                }
                */
                pm.ps.origin = trace.endpos
                if pm.stepSlideFix != 0 {
                    if trace.fraction < 1.0 {
                        // Raven passes `pm.ps.velocity` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy. The last one writes back after the call, because a view's setter keeps the in-copy otherwise.
                        do {
                            var velocityIn0 = pm.ps.velocity
                            var velocityOut2 = pm.ps.velocity
                            PM_ClipVelocity(&velocityIn0, &trace.plane.normal, &velocityOut2, OVERCLIP)
                            pm.ps.velocity = velocityOut2
                        }
                    }
                }
            }
        } else {
            if pm.stepSlideFix != 0 {
                pm.ps.origin = down_o
                pm.ps.velocity = down_v
            }
        }
        if pm.stepSlideFix == 0 {
            if trace.fraction < 1.0 {
                // Raven passes `pm.ps.velocity` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy. The last one writes back after the call, because a view's setter keeps the in-copy otherwise.
                do {
                    var velocityIn0 = pm.ps.velocity
                    var velocityOut2 = pm.ps.velocity
                    PM_ClipVelocity(&velocityIn0, &trace.plane.normal, &velocityOut2, OVERCLIP)
                    pm.ps.velocity = velocityOut2
                }
            }
        }

        // if the down trace can trace back to the original position directly, don't step
        // use the original move
        do {
            // use the step move
            var delta: Float = 0

            delta = pm.ps.origin[2] - start_o[2]
            if delta > 2 {
                if delta < 7 {
                    PM_AddEvent(EV_STEP_4)
                } else if delta < 11 {
                    PM_AddEvent(EV_STEP_8)
                } else if delta < 15 {
                    PM_AddEvent(EV_STEP_12)
                } else {
                    PM_AddEvent(EV_STEP_16)
                }
            }
            if pm.debugLevel != 0 {
                Com_Printf("%i:stepped\n", c_pmove)
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}
