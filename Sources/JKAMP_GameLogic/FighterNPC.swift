import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/FighterNPC.c:53
// Raven wrote: #define currentAngles r . currentAngles
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/FighterNPC.c:54
// Raven wrote: #define currentOrigin r . currentOrigin
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/FighterNPC.c:55
// Raven wrote: #define mins r . mins
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/FighterNPC.c:56
// Raven wrote: #define maxs r . maxs
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/FighterNPC.c:57
extension JKAMP.PlayerState {
    /// Raven's `#define legsAnimTimer legsTimer`, an alias of the field, file-private to this stub.
    fileprivate var legsAnimTimer: Int32 {
        get { self.legsTimer }
        nonmutating set { self.legsTimer = newValue }
    }
}

/// Source: oracle/codemp/game/FighterNPC.c:58
extension JKAMP.PlayerState {
    /// Raven's `#define torsoAnimTimer torsoTimer`, an alias of the field, file-private to this stub.
    fileprivate var torsoAnimTimer: Int32 {
        get { self.torsoTimer }
        nonmutating set { self.torsoTimer = newValue }
    }
}

/// Source: oracle/codemp/game/FighterNPC.c:59
// Raven wrote: #define bool qboolean
// Swift has `Bool`, so a body writes it.

/// Source: oracle/codemp/game/FighterNPC.c:60
// Raven wrote: #define false qfalse
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/FighterNPC.c:61
// Raven wrote: #define true qtrue
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/FighterNPC.c:63
// Raven wrote: #define sqrtf sqrt
private func sqrtf(_ x: Float) -> Float {
    x.squareRoot()
}

/// Source: oracle/codemp/game/FighterNPC.c:64
// Raven wrote: #define Q_flrand flrand
// The module declares `Q_flrand` too, so a body writes `flrand` where Raven wrote `Q_flrand`.

/// Source: oracle/codemp/game/FighterNPC.c:66
private let MOD_EXPLOSIVE = JKAMP.MOD_SUICIDE

/// Source: oracle/codemp/game/FighterNPC.c:369
let FIGHTER_MIN_TAKEOFF_FRACTION = 0.7 as Float

//this stuff has got to be predicted, so..
/// Source: oracle/codemp/game/FighterNPC.c:99
func BG_FighterUpdate(_ pVeh: JKAMP.Vehicle, _ pUcmd: JKAMP.Usercmd, _ trMins: JKAShared.vec3_t, _ trMaxs: JKAShared.vec3_t, _ gravity: Float, _ traceFunc: ((JKAMP.Trace, JKAShared.vec3_t, JKAShared.vec3_t, JKAShared.vec3_t, JKAShared.vec3_t, Int32, Int32) -> Void)?) -> Bool {
    var bottom = vec3_t()
    var parentPS: PlayerState?
    var isDead: Bool = false
    var i: Int32

    // Make sure the riders are not visible or collidable.
    pVeh.m_pVehicleInfo!.runGhost(pVeh, pVeh.m_pPilot)
    i = 0
    while i < pVeh.m_pVehicleInfo!.maxPassengers {
        pVeh.m_pVehicleInfo!.runGhost(pVeh, pVeh.m_ppPassengers[i])
        i += 1
    }


    parentPS = pVeh.m_pParentEntity!.playerState

    if parentPS == nil {
        Com_Error(ERR_DROP, "NULL PS in BG_FighterUpdate (%s)", pVeh.m_pVehicleInfo!.name!)
        return false
    }

    // If we have a pilot, take out gravity (it's a flying craft...).
    if pVeh.m_pPilot != nil {
        parentPS!.gravity = 0
    } else {
        if pVeh.m_pVehicleInfo!.gravity != 0 {
            parentPS!.gravity = pVeh.m_pVehicleInfo!.gravity
        } else {
            //it doesn't have gravity specified apparently
            parentPS!.gravity = Int32(gravity)
        }
    }

    isDead = Bool(((parentPS!.eFlags & EF_DEAD) != 0))

    /*
    if ( isDead ||
    (pVeh->m_pVehicleInfo->surfDestruction &&
    pVeh->m_iRemovedSurfaces ) )
    {//can't land if dead or spiralling out of control
    pVeh->m_LandTrace.fraction = 1.0f;
    pVeh->m_LandTrace.contents = pVeh->m_LandTrace.surfaceFlags = 0;
    VectorClear( pVeh->m_LandTrace.plane.normal );
    pVeh->m_LandTrace.allsolid = qfalse;
    pVeh->m_LandTrace.startsolid = qfalse;
    }
    else
    {
    */
    //argh, no, I need to have a way to see when they impact the ground while damaged. -rww

    // Check to see if the fighter has taken off yet (if it's a certain height above ground).
    bottom = parentPS!.origin
    bottom[2] -= pVeh.m_pVehicleInfo!.landingHeight

    traceFunc?(pVeh.m_LandTrace, parentPS!.origin, trMins, trMaxs, bottom, pVeh.m_pParentEntity!.s.number, (MASK_NPCSOLID & ~CONTENTS_BODY))
    //}

    return true
}

// Like a think or move command, this updates various vehicle properties.
/// Source: oracle/codemp/game/FighterNPC.c:188
private func Update(_ pVeh: JKAMP.Vehicle, _ pUcmd: JKAMP.Usercmd) -> Bool {
    if !BG_FighterUpdate(pVeh, pUcmd, (pVeh.m_pParentEntity.map { Entity($0) })!.r.mins, (pVeh.m_pParentEntity.map { Entity($0) })!.r.maxs, g_gravity.value, G_VehicleTrace) {
        return false
    }

    if !g_vehicleInfo[VEHICLE_BASE].runUpdate(pVeh, pUcmd) {
        return false
    }

    return true
}

// Board this Vehicle (get on). The first entity to board an empty vehicle becomes the Pilot.
/// Source: oracle/codemp/game/FighterNPC.c:212
private func Board(_ pVeh: JKAMP.Vehicle, _ pEnt: JKAMP.BgEntity) -> Bool {
    if !g_vehicleInfo[VEHICLE_BASE].runBoard(pVeh, pEnt) {
        return false
    }

    // Set the board wait time (they won't be able to do anything, including getting off, for this amount of time).
    pVeh.m_iBoarding = level.time + 1500

    return true
}

// Eject an entity from the vehicle.
/// Source: oracle/codemp/game/FighterNPC.c:224
private func Eject(_ pVeh: JKAMP.Vehicle, _ pEnt: JKAMP.BgEntity, _ forceEject: Bool) -> Bool {
    if g_vehicleInfo[VEHICLE_BASE].runEject(pVeh, pEnt, forceEject) {
        return true
    }

    return false
}

//method of decrementing the given angle based on the given taking variable frame times into account
/// Source: oracle/codemp/game/FighterNPC.c:237
private func PredictedAngularDecrement(_ scale: Float, _ timeMod: Float, _ originalAngle: Float) -> Float {
    var fixedBaseDec: Float = originalAngle * 0.05
    var r: Float = 0.0

    if fixedBaseDec < 0.0 {
        fixedBaseDec = -fixedBaseDec
    }

    fixedBaseDec *= (1.0 + (1.0 - scale))

    if fixedBaseDec < 0.1 {
        //don't increment in incredibly small fractions, it would eat up unnecessary bandwidth.
        fixedBaseDec = 0.1
    }

    fixedBaseDec *= (timeMod * 0.1)
    if originalAngle > 0.0 {
        //subtract
        r = (originalAngle - fixedBaseDec)
        if r < 0.0 {
            r = 0.0
        }
    } else if originalAngle < 0.0 {
        //add
        r = (originalAngle + fixedBaseDec)
        if r > 0.0 {
            r = 0.0
        }
    }

    return r
}

/// Source: oracle/codemp/game/FighterNPC.c:276
func FighterIsInSpace(_ gParent: Entity) -> Bool {
    if gParent.client != nil && gParent.client!.inSpaceIndex != 0 && gParent.client!.inSpaceIndex < ENTITYNUM_WORLD {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/FighterNPC.c:289
func FighterOverValidLandingSurface(_ pVeh: JKAMP.Vehicle) -> Bool {
    if pVeh.m_LandTrace.fraction < 1.0 && pVeh.m_LandTrace.plane.normal[2] >= MIN_LANDING_SLOPE {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/FighterNPC.c:300
func FighterIsLanded(_ pVeh: JKAMP.Vehicle, _ parentPS: JKAMP.PlayerState) -> Bool {
    if FighterOverValidLandingSurface(pVeh) && parentPS.speed == 0 {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/FighterNPC.c:310
func FighterIsLanding(_ pVeh: JKAMP.Vehicle, _ parentPS: JKAMP.PlayerState) -> Bool {
    if FighterOverValidLandingSurface(pVeh)
        //only do this check on GAME side, because if it's CGAME, it's being predicted, and it's only predicted if the local client is the driver
        && pVeh.m_pVehicleInfo!.runInhabited(pVeh) //has to have a driver in order to be capable of landing
        && (pVeh.m_ucmd.forwardmove < 0 || pVeh.m_ucmd.upmove < 0) //decelerating or holding crouch button
        && parentPS.speed <= MIN_LANDING_SPEED {
        //going slow enough to start landing - was using pVeh->m_pVehicleInfo->speedIdle, but that's still too fast
        return true
    }
    return false
}

/// Source: oracle/codemp/game/FighterNPC.c:325
func FighterIsLaunching(_ pVeh: JKAMP.Vehicle, _ parentPS: JKAMP.PlayerState) -> Bool {
    if FighterOverValidLandingSurface(pVeh)
        //only do this check on GAME side, because if it's CGAME, it's being predicted, and it's only predicted if the local client is the driver
        && pVeh.m_pVehicleInfo!.runInhabited(pVeh) //has to have a driver in order to be capable of landing
        && pVeh.m_ucmd.upmove > 0 //trying to take off
        && parentPS.speed <= 200.0 {
        //going slow enough to start landing - was using pVeh->m_pVehicleInfo->speedIdle, but that's still too fast
        return true
    }
    return false
}

/// Source: oracle/codemp/game/FighterNPC.c:340
func FighterSuspended(_ pVeh: JKAMP.Vehicle, _ parentPS: JKAMP.PlayerState) -> Bool {
    if pVeh.m_pPilot == nil && parentPS.speed == 0 && pVeh.m_ucmd.forwardmove <= 0 && pVeh.m_pParentEntity != nil && ((pVeh.m_pParentEntity.map { Entity($0) })!.spawnflags & 2) != 0 {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/FighterNPC.c:370
private func ProcessMoveCommands(_ pVeh: JKAMP.Vehicle) {
    /************************************************************************************/
    /*	BEGIN	Here is where we move the vehicle (forward or back or whatever). BEGIN	*/
    /************************************************************************************/

    //Client sets ucmds and such for speed alterations
    var speedInc: Float
    var speedIdleDec: Float
    let speedIdle: Float
    let speedIdleAccel: Float
    let speedMin: Float
    var speedMax: Float
    let parent: BgEntity? = pVeh.m_pParentEntity
    var isLandingOrLaunching: Bool = false
    /*
    #ifndef _JK2MP//SP
    int curTime = level.time;
    #elif QAGAME//MP GAME
    int curTime = level.time;
    #elif CGAME//MP CGAME
    //FIXME: pass in ucmd?  Not sure if this is reliable...
    int curTime = pm->cmd.serverTime;
    #endif
    */
    //this function should only be called from pmove.. if it gets called elsehwere,
    //obviously this will explode.
    let curTime: Int32 = pm.cmd.serverTime

    let parentPS: PlayerState? = parent!.playerState

    if parentPS!.hyperSpaceTime != 0 && curTime - parentPS!.hyperSpaceTime < HYPERSPACE_TIME {
        //Going to Hyperspace
        //totally override movement
        let timeFrac: Float = (Float((curTime - parentPS!.hyperSpaceTime))) / HYPERSPACE_TIME
        if timeFrac < HYPERSPACE_TELEPORT_FRAC {
            //for first half, instantly jump to top speed!
            if !((parentPS!.eFlags2 & EF2_HYPERSPACE) != 0) {
                //waiting to face the right direction, do nothing
                parentPS!.speed = 0.0
            } else {
                if parentPS!.speed < HYPERSPACE_SPEED {
                    //just started hyperspace
                    //MIKE: This is going to play the sound twice for the predicting client, I suggest using
                    //a predicted event or only doing it game-side. -rich
                    //G_EntitySound( ((gentity_t *)(pVeh->m_pParentEntity)), CHAN_LOCAL, pVeh->m_pVehicleInfo->soundHyper );
                }

                parentPS!.speed = HYPERSPACE_SPEED
            }
        } else {
            //slow from top speed to 200...
            parentPS!.speed = 200.0 + ((1.0 - timeFrac) * (1.0 / HYPERSPACE_TELEPORT_FRAC) * (HYPERSPACE_SPEED - 200.0))
            //don't mess with acceleration, just pop to the high velocity
            if VectorLength(parentPS!.velocity) < parentPS!.speed {
                parentPS!.velocity = parentPS!.moveDir * parentPS!.speed
            }
        }
        return
    }

    if pVeh.m_iDropTime >= curTime {
        //no speed, just drop
        parentPS!.speed = 0.0
        parentPS!.gravity = 800
        return
    }

    isLandingOrLaunching = (FighterIsLanding(pVeh, parentPS!) || FighterIsLaunching(pVeh, parentPS!))

    // If we are hitting the ground, just allow the fighter to go up and down.
    if isLandingOrLaunching && (pVeh.m_ucmd.forwardmove <= 0 || pVeh.m_LandTrace.fraction <= FIGHTER_MIN_TAKEOFF_FRACTION) {
        //FIXME: if start to move forward and fly over something low while still going relatively slow, you may try to land even though you don't mean to...
        //float fInvFrac = 1.0f - pVeh->m_LandTrace.fraction;

        if pVeh.m_ucmd.upmove > 0 {
            if parentPS!.velocity[2] <= 0 && pVeh.m_pVehicleInfo!.soundTakeOff != 0 {
                //taking off for the first time
                G_EntitySound(((pVeh.m_pParentEntity).map { Entity($0) })!, CHAN_AUTO, pVeh.m_pVehicleInfo!.soundTakeOff)
            }
            parentPS!.velocity[2] += pVeh.m_pVehicleInfo!.acceleration * pVeh.m_fTimeModifier // * ( /*fInvFrac **/ 1.5f );
        } else if pVeh.m_ucmd.upmove < 0 {
            parentPS!.velocity[2] -= pVeh.m_pVehicleInfo!.acceleration * pVeh.m_fTimeModifier // * ( /*fInvFrac **/ 1.8f );
        } else if pVeh.m_ucmd.forwardmove < 0 {
            if pVeh.m_LandTrace.fraction != 0.0 {
                parentPS!.velocity[2] -= pVeh.m_pVehicleInfo!.acceleration * pVeh.m_fTimeModifier
            }

            if pVeh.m_LandTrace.fraction <= FIGHTER_MIN_TAKEOFF_FRACTION {
                //pVeh->m_pParentEntity->client->ps.velocity[0] *= pVeh->m_LandTrace.fraction;
                //pVeh->m_pParentEntity->client->ps.velocity[1] *= pVeh->m_LandTrace.fraction;

                //remember to always base this stuff on the time modifier! otherwise, you create
                //framerate-dependancy issues and break prediction in MP -rww
                //parentPS->velocity[2] *= pVeh->m_LandTrace.fraction;
                //it's not an angle, but hey
                parentPS!.velocity[2] = PredictedAngularDecrement(pVeh.m_LandTrace.fraction, pVeh.m_fTimeModifier * 5.0, parentPS!.velocity[2])

                parentPS!.speed = 0
            }
        }

        // Make sure they don't pitch as they near the ground.
        //pVeh->m_vOrientation[PITCH] *= 0.7f;
        pVeh.m_vOrientationVector[PITCH] = PredictedAngularDecrement(0.7, pVeh.m_fTimeModifier * 10.0, pVeh.m_vOrientationVector[PITCH])

        return
    }

    if (pVeh.m_ucmd.upmove > 0) && pVeh.m_pVehicleInfo!.turboSpeed != 0 {
        if (curTime - pVeh.m_iTurboTime) > pVeh.m_pVehicleInfo!.turboRecharge {
            pVeh.m_iTurboTime = (curTime + pVeh.m_pVehicleInfo!.turboDuration)

            //NOTE: turbo sound can't be part of effect if effect is played on every muzzle!
            if pVeh.m_pVehicleInfo!.soundTurbo != 0 {
                G_EntitySound(((pVeh.m_pParentEntity).map { Entity($0) })!, CHAN_AUTO, pVeh.m_pVehicleInfo!.soundTurbo)
            }
        }
    }
    speedInc = pVeh.m_pVehicleInfo!.acceleration * pVeh.m_fTimeModifier
    if curTime < pVeh.m_iTurboTime {
        //going turbo speed
        speedMax = pVeh.m_pVehicleInfo!.turboSpeed
        //double our acceleration
        //speedInc *= 2.0f;
        //no no no! this would el breako el predictiono! we want the following... -rww
        speedInc = (pVeh.m_pVehicleInfo!.acceleration * 2.0) * pVeh.m_fTimeModifier

        //force us to move forward
        pVeh.m_ucmd.forwardmove = 127
        //add flag to let cgame know to draw the iTurboFX effect
        parentPS!.eFlags |= EF_JETPACK_ACTIVE
    } else {
        /*
        //FIXME: if turbotime is up and we're waiting for it to recharge, should our max speed drop while we recharge?
        else if ( (curTime - pVeh->m_iTurboTime)<3000 )
        {//still waiting for the recharge
        speedMax = pVeh->m_pVehicleInfo->speedMax*0.75;
        }
        */
        //normal max speed
        speedMax = pVeh.m_pVehicleInfo!.speedMax
        if (parentPS!.eFlags & EF_JETPACK_ACTIVE) != 0 {
            //stop cgame from playing the turbo exhaust effect
            parentPS!.eFlags &= ~EF_JETPACK_ACTIVE
        }
    }
    speedIdleDec = pVeh.m_pVehicleInfo!.decelIdle * pVeh.m_fTimeModifier
    speedIdle = pVeh.m_pVehicleInfo!.speedIdle
    speedIdleAccel = pVeh.m_pVehicleInfo!.accelIdle * pVeh.m_fTimeModifier
    speedMin = pVeh.m_pVehicleInfo!.speedMin

    if (parentPS!.brokenLimbs & (1 << SHIPSURF_DAMAGE_BACK_HEAVY)) != 0 {
        //engine has taken heavy damage
        speedMax *= 0.8 //at 80% speed
    } else if (parentPS!.brokenLimbs & (1 << SHIPSURF_DAMAGE_BACK_LIGHT)) != 0 {
        //engine has taken light damage
        speedMax *= 0.6 //at 60% speed
    }

    if pVeh.m_iRemovedSurfaces != 0 || parentPS!.electrifyTime >= curTime {
        //go out of control
        parentPS!.speed += speedInc
        //Why set forwardmove?  PMove code doesn't use it... does it?
        pVeh.m_ucmd.forwardmove = 127
    } else if FighterSuspended(pVeh, parentPS!) {
        parentPS!.speed = 0
        pVeh.m_ucmd.forwardmove = 0
    } else if !pVeh.m_pVehicleInfo!.runInhabited(pVeh) && parentPS!.speed > 0 {
        //pilot jumped out while we were moving forward (not landing or landed) so just keep the throttle locked
        //Why set forwardmove?  PMove code doesn't use it... does it?
        pVeh.m_ucmd.forwardmove = 127
    } else if (parentPS!.speed != 0 || parentPS!.groundEntityNum == ENTITYNUM_NONE || pVeh.m_ucmd.forwardmove != 0 || pVeh.m_ucmd.upmove > 0) && pVeh.m_LandTrace.fraction >= 0.05 {
        if pVeh.m_ucmd.forwardmove > 0 && speedInc != 0 {
            parentPS!.speed += speedInc
            pVeh.m_ucmd.forwardmove = 127
        } else if pVeh.m_ucmd.forwardmove < 0 || pVeh.m_ucmd.upmove < 0 {
            //decelerating or braking
            if pVeh.m_ucmd.upmove < 0 {
                //braking (trying to land?), slow down faster
                if pVeh.m_ucmd.forwardmove != 0 {
                    //decelerator + brakes
                    speedInc += pVeh.m_pVehicleInfo!.braking
                    speedIdleDec += pVeh.m_pVehicleInfo!.braking
                } else {
                    //just brakes
                    speedIdleDec = pVeh.m_pVehicleInfo!.braking
                    speedInc = speedIdleDec
                }
            }
            if parentPS!.speed > speedIdle {
                parentPS!.speed -= speedInc
            } else if parentPS!.speed > speedMin {
                if FighterOverValidLandingSurface(pVeh) {
                    //there's ground below us and we're trying to slow down, slow down faster
                    parentPS!.speed -= speedInc
                } else {
                    parentPS!.speed -= speedIdleDec
                    if parentPS!.speed < MIN_LANDING_SPEED {
                        //unless you can land, don't drop below the landing speed!!!  This way you can't come to a dead stop in mid-air
                        parentPS!.speed = Float(MIN_LANDING_SPEED)
                    }
                }
            }
            if pVeh.m_pVehicleInfo!.type == VH_FIGHTER {
                pVeh.m_ucmd.forwardmove = 127
            } else if speedMin >= 0 {
                pVeh.m_ucmd.forwardmove = 0
            }
        }
        //else not accel, decel or braking
        else if pVeh.m_pVehicleInfo!.throttleSticks != 0 {
            //we're using a throttle that sticks at current speed
            if parentPS!.speed <= MIN_LANDING_SPEED {
                //going less than landing speed
                if FighterOverValidLandingSurface(pVeh) {
                    //close to ground and not going very fast
                    //slow to a stop if within landing height and not accel/decel/braking
                    if parentPS!.speed > 0 {
                        //slow down
                        parentPS!.speed -= speedIdleDec
                    } else if parentPS!.speed < 0 {
                        //going backwards, slow down
                        parentPS!.speed += speedIdleDec
                    }
                } else {
                    //not over a valid landing surf, but going too slow
                    //speed up to idle speed if not over a valid landing surf and not accel/decel/braking
                    if parentPS!.speed < speedIdle {
                        parentPS!.speed += speedIdleAccel
                        if parentPS!.speed > speedIdle {
                            parentPS!.speed = speedIdle
                        }
                    }
                }
            }
        } else {
            //then speed up or slow down to idle speed
            //accelerate to cruising speed only, otherwise, just coast
            // If they've launched, apply some constant motion.
            if (pVeh.m_LandTrace.fraction >= 1.0 //no ground
                || pVeh.m_LandTrace.plane.normal[2] < MIN_LANDING_SLOPE) //or can't land on ground below us
                && speedIdle > 0 {
                //not above ground and have an idle speed
                //float fSpeed = pVeh->m_pParentEntity->client->ps.speed;
                if parentPS!.speed < speedIdle {
                    parentPS!.speed += speedIdleAccel
                    if parentPS!.speed > speedIdle {
                        parentPS!.speed = speedIdle
                    }
                } else if parentPS!.speed > 0 {
                    //slow down
                    parentPS!.speed -= speedIdleDec

                    if parentPS!.speed < speedIdle {
                        parentPS!.speed = speedIdle
                    }
                }
            } else {
                //either close to ground or no idle speed
                //slow to a stop if no idle speed or within landing height and not accel/decel/braking
                if parentPS!.speed > 0 {
                    //slow down
                    parentPS!.speed -= speedIdleDec
                } else if parentPS!.speed < 0 {
                    //going backwards, slow down
                    parentPS!.speed += speedIdleDec
                }
            }
        }
    } else {
        if pVeh.m_ucmd.forwardmove < 0 {
            pVeh.m_ucmd.forwardmove = 0
        }
        if pVeh.m_ucmd.upmove < 0 {
            pVeh.m_ucmd.upmove = 0
        }
    }

    //STRAFING==============================================================================
    if pVeh.m_pVehicleInfo!.strafePerc != 0
        //only do this check on GAME side, because if it's CGAME, it's being predicted, and it's only predicted if the local client is the driver
        && pVeh.m_pVehicleInfo!.runInhabited(pVeh) //has to have a driver in order to be capable of landing
        && pVeh.m_iRemovedSurfaces == 0
        && parentPS!.electrifyTime < curTime
        && parentPS!.vehTurnaroundTime < curTime
        && (pVeh.m_LandTrace.fraction >= 1.0 //no grounf
            || pVeh.m_LandTrace.plane.normal[2] < MIN_LANDING_SLOPE //can't land here
            || parentPS!.speed > MIN_LANDING_SPEED) //going too fast to land
        && pVeh.m_ucmd.rightmove != 0 {
        //strafe
        var vAngles = vec3_t()
        var vRight = vec3_t()
        var strafeSpeed: Float = (pVeh.m_pVehicleInfo!.strafePerc * speedMax) * 5.0
        vAngles = pVeh.m_vOrientationVector
        vAngles[ROLL] = 0
        vAngles[PITCH] = vAngles[ROLL]
        // Raven passes NULL for the `forward` and `up` outputs.
        var scratchForward = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(vAngles, &scratchForward, &vRight, &scratchUp)

        if pVeh.m_ucmd.rightmove > 0 {
            //strafe right
            //FIXME: this will probably make it possible to cheat and
            //		go faster than max speed if you keep turning and strafing...
            if parentPS!.hackingTime > -MAX_STRAFE_TIME {
                //can strafe right for 2 seconds
                let curStrafeSpeed: Float = _DotProduct(parentPS!.velocity, vRight)
                if curStrafeSpeed > 0.0 {
                    //if > 0, already strafing right
                    strafeSpeed -= curStrafeSpeed //so it doesn't add up
                }
                if strafeSpeed > 0 {
                    _VectorMA(parentPS!.velocity, strafeSpeed * pVeh.m_fTimeModifier, vRight, &parentPS!.velocity)
                }
                parentPS!.hackingTime = Int32(parentPS!.hackingTime - 50 * pVeh.m_fTimeModifier)
            }
        } else {
            //strafe left
            if parentPS!.hackingTime < MAX_STRAFE_TIME {
                //can strafe left for 2 seconds
                let curStrafeSpeed: Float = _DotProduct(parentPS!.velocity, vRight)
                if curStrafeSpeed < 0.0 {
                    //if < 0, already strafing left
                    strafeSpeed += curStrafeSpeed //so it doesn't add up
                }
                if strafeSpeed > 0 {
                    _VectorMA(parentPS!.velocity, -strafeSpeed * pVeh.m_fTimeModifier, vRight, &parentPS!.velocity)
                }
                parentPS!.hackingTime = Int32(parentPS!.hackingTime + 50 * pVeh.m_fTimeModifier)
            }
        }
        //strafing takes away from forward speed?  If so, strafePerc above should use speedMax
        //parentPS->speed *= (1.0f-pVeh->m_pVehicleInfo->strafePerc);
    } else {
        //if ( parentPS->hackingTime )
        if parentPS!.hackingTime > 0 {
            parentPS!.hackingTime = Int32(parentPS!.hackingTime - 50 * pVeh.m_fTimeModifier)
            if parentPS!.hackingTime < 0 {
                parentPS!.hackingTime = 0
            }
        } else if parentPS!.hackingTime < 0 {
            parentPS!.hackingTime = Int32(parentPS!.hackingTime + 50 * pVeh.m_fTimeModifier)
            if parentPS!.hackingTime > 0 {
                parentPS!.hackingTime = 0
            }
        }
    }
    //STRAFING==============================================================================

    if parentPS!.speed > speedMax {
        parentPS!.speed = speedMax
    } else if parentPS!.speed < speedMin {
        parentPS!.speed = speedMin
    }

    if (pVeh.m_vOrientationVector[PITCH] * 0.1) > 10.0 {
        //pitched downward, increase speed more and more based on our tilt
        if FighterIsInSpace(parent.map { Entity($0) }!) {
            //in space, do nothing with speed base on pitch...
        } else {
            //really should only do this when on a planet
            var mult: Float = pVeh.m_vOrientationVector[PITCH] * 0.1
            if mult < 1.0 {
                mult = 1.0
            }
            parentPS!.speed = PredictedAngularDecrement(mult, pVeh.m_fTimeModifier * 10.0, parentPS!.speed)
        }
    }

    if pVeh.m_iRemovedSurfaces != 0 || parentPS!.electrifyTime >= curTime {
        //going down
        if FighterIsInSpace(parent.map { Entity($0) }!) {
            //we're in a valid trigger_space brush
            //simulate randomness
            if !((parent!.s.number & 3) != 0) {
                //even multiple of 3, don't do anything
                parentPS!.gravity = 0
            } else if !((parent!.s.number & 2) != 0) {
                //even multiple of 2, go up
                parentPS!.gravity = -500
                parentPS!.velocity[2] = 80.0
            } else {
                //odd number, go down
                parentPS!.gravity = 500
                parentPS!.velocity[2] = -80.0
            }
        } else {
            //over a planet
            parentPS!.gravity = 500
            parentPS!.velocity[2] = -80.0
        }
    } else if FighterSuspended(pVeh, parentPS!) {
        parentPS!.gravity = 0
    } else if (parentPS!.speed == 0 || parentPS!.speed < speedIdle) && pVeh.m_ucmd.upmove <= 0 {
        //slowing down or stopped and not trying to take off
        if FighterIsInSpace(parent.map { Entity($0) }!) {
            //we're in space, stopping doesn't make us drift downward
            if FighterOverValidLandingSurface(pVeh) {
                //well, there's something below us to land on, so go ahead and lower us down to it
                parentPS!.gravity = Int32((speedIdle - parentPS!.speed) / 4)
            }
        } else {
            //over a planet
            parentPS!.gravity = Int32((speedIdle - parentPS!.speed) / 4)
        }
    } else {
        parentPS!.gravity = 0
    }

    /********************************************************************************/
    /*	END Here is where we move the vehicle (forward or back or whatever). END	*/
    /********************************************************************************/
}

/// Source: oracle/codemp/game/FighterNPC.c:890
private func FighterWingMalfunctionCheck(_ pVeh: JKAMP.Vehicle, _ parentPS: JKAMP.PlayerState) {
    var mPitchOverride: Float = 1.0
    var mYawOverride: Float = 1.0
    BG_VehicleTurnRateForSpeed(pVeh, parentPS.speed, &mPitchOverride, &mYawOverride)
    //check right wing damage
    if (parentPS.brokenLimbs & (1 << SHIPSURF_DAMAGE_RIGHT_HEAVY)) != 0 {
        //right wing has taken heavy damage
        pVeh.m_vOrientationVector[ROLL] = Float(Double(pVeh.m_vOrientationVector[ROLL]) + (sin(Double(pVeh.m_ucmd.serverTime) * 0.001) + 1.0) * Double(pVeh.m_fTimeModifier) * Double(mYawOverride) * 50.0)
    } else if (parentPS.brokenLimbs & (1 << SHIPSURF_DAMAGE_RIGHT_LIGHT)) != 0 {
        //right wing has taken light damage
        pVeh.m_vOrientationVector[ROLL] = Float(Double(pVeh.m_vOrientationVector[ROLL]) + (sin(Double(pVeh.m_ucmd.serverTime) * 0.001) + 1.0) * Double(pVeh.m_fTimeModifier) * Double(mYawOverride) * 12.5)
    }

    //check left wing damage
    if (parentPS.brokenLimbs & (1 << SHIPSURF_DAMAGE_LEFT_HEAVY)) != 0 {
        //left wing has taken heavy damage
        pVeh.m_vOrientationVector[ROLL] = Float(Double(pVeh.m_vOrientationVector[ROLL]) - (sin(Double(pVeh.m_ucmd.serverTime) * 0.001) + 1.0) * Double(pVeh.m_fTimeModifier) * Double(mYawOverride) * 50.0)
    } else if (parentPS.brokenLimbs & (1 << SHIPSURF_DAMAGE_LEFT_LIGHT)) != 0 {
        //left wing has taken light damage
        pVeh.m_vOrientationVector[ROLL] = Float(Double(pVeh.m_vOrientationVector[ROLL]) - (sin(Double(pVeh.m_ucmd.serverTime) * 0.001) + 1.0) * Double(pVeh.m_fTimeModifier) * Double(mYawOverride) * 12.5)
    }
}

/// Source: oracle/codemp/game/FighterNPC.c:917
private func FighterNoseMalfunctionCheck(_ pVeh: JKAMP.Vehicle, _ parentPS: JKAMP.PlayerState) {
    var mPitchOverride: Float = 1.0
    var mYawOverride: Float = 1.0
    BG_VehicleTurnRateForSpeed(pVeh, parentPS.speed, &mPitchOverride, &mYawOverride)
    //check nose damage
    if (parentPS.brokenLimbs & (1 << SHIPSURF_DAMAGE_FRONT_HEAVY)) != 0 {
        //nose has taken heavy damage
        //pitch up and down over time
        pVeh.m_vOrientationVector[PITCH] = Float(Double(pVeh.m_vOrientationVector[PITCH]) + sin(Double(pVeh.m_ucmd.serverTime) * 0.001) * Double(pVeh.m_fTimeModifier) * Double(mPitchOverride) * 50.0)
    } else if (parentPS.brokenLimbs & (1 << SHIPSURF_DAMAGE_FRONT_LIGHT)) != 0 {
        //nose has taken heavy damage
        //pitch up and down over time
        pVeh.m_vOrientationVector[PITCH] = Float(Double(pVeh.m_vOrientationVector[PITCH]) + sin(Double(pVeh.m_ucmd.serverTime) * 0.001) * Double(pVeh.m_fTimeModifier) * Double(mPitchOverride) * 20.0)
    }
}

/// Source: oracle/codemp/game/FighterNPC.c:935
private func FighterDamageRoutine(_ pVeh: JKAMP.Vehicle, _ parent: JKAMP.BgEntity, _ parentPS: JKAMP.PlayerState, _ riderPS: JKAMP.PlayerState, _ isDead: Bool) {
    if pVeh.m_iRemovedSurfaces == 0 {
        //still in one piece
        if pVeh.m_pParentEntity != nil && isDead {
            //death spiral
            pVeh.m_ucmd.upmove = 0
            //FIXME: don't bias toward pitching down when not in space
            /*
            if ( FighterIsInSpace( pVeh->m_pParentEntity ) )
            {
            }
            else
            */
            if !((pVeh.m_pParentEntity!.s.number % 3) != 0) {
                //NOT everyone should do this
                pVeh.m_vOrientationVector[PITCH] += pVeh.m_fTimeModifier
                if !BG_UnrestrainedPitchRoll(riderPS, pVeh) {
                    if pVeh.m_vOrientationVector[PITCH] > 60.0 {
                        pVeh.m_vOrientationVector[PITCH] = 60.0
                    }
                }
            } else if !((pVeh.m_pParentEntity!.s.number % 2) != 0) {
                pVeh.m_vOrientationVector[PITCH] -= pVeh.m_fTimeModifier
                if !BG_UnrestrainedPitchRoll(riderPS, pVeh) {
                    if pVeh.m_vOrientationVector[PITCH] > -60.0 {
                        pVeh.m_vOrientationVector[PITCH] = -60.0
                    }
                }
            }
            if (pVeh.m_pParentEntity!.s.number % 2) != 0 {
                pVeh.m_vOrientationVector[YAW] += pVeh.m_fTimeModifier
                pVeh.m_vOrientationVector[ROLL] += pVeh.m_fTimeModifier * 4.0
            } else {
                pVeh.m_vOrientationVector[YAW] -= pVeh.m_fTimeModifier
                pVeh.m_vOrientationVector[ROLL] -= pVeh.m_fTimeModifier * 4.0
            }
        }
        return
    }

    //if we get into here we have at least one broken piece
    pVeh.m_ucmd.upmove = 0

    //if you're off the ground and not suspended, pitch down
    //FIXME: not in space!
    if pVeh.m_LandTrace.fraction >= 0.1 {
        if !FighterSuspended(pVeh, parentPS) {
            //pVeh->m_ucmd.forwardmove = 0;
            //FIXME: don't bias towards pitching down when in space...
            if !((pVeh.m_pParentEntity!.s.number % 3) != 0) {
                //NOT everyone should do this
                pVeh.m_vOrientationVector[PITCH] += pVeh.m_fTimeModifier
                if !BG_UnrestrainedPitchRoll(riderPS, pVeh) {
                    if pVeh.m_vOrientationVector[PITCH] > 60.0 {
                        pVeh.m_vOrientationVector[PITCH] = 60.0
                    }
                }
            } else if !((pVeh.m_pParentEntity!.s.number % 4) != 0) {
                pVeh.m_vOrientationVector[PITCH] -= pVeh.m_fTimeModifier
                if !BG_UnrestrainedPitchRoll(riderPS, pVeh) {
                    if pVeh.m_vOrientationVector[PITCH] > -60.0 {
                        pVeh.m_vOrientationVector[PITCH] = -60.0
                    }
                }
            }
            //else: just keep going forward
        }
    }
    if pVeh.m_LandTrace.fraction < 1.0 {
        //if you land at all when pieces of your ship are missing, then die
        let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
        G_DamageFromKiller(parent!, parent!, nil, parent!.client!.ps.origin, 999999, DAMAGE_NO_ARMOR, MOD_SUICIDE)
    }

    if ((pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_C) != 0 || (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_D) != 0) && ((pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_E) != 0 || (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_F) != 0) {
        //wings on both side broken
        var factor: Float = 2.0
        if (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_E) != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_F) != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_C) != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_D) != 0 {
            //all wings broken
            factor *= 2.0
        }

        if !((pVeh.m_pParentEntity!.s.number % 2) != 0) || !((pVeh.m_pParentEntity!.s.number % 6) != 0) {
            //won't yaw, so increase roll factor
            factor *= 4.0
        }

        pVeh.m_vOrientationVector[ROLL] += (pVeh.m_fTimeModifier * factor) //do some spiralling
    } else if (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_C) != 0 || (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_D) != 0 {
        //left wing broken
        var factor: Float = 2.0
        if (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_C) != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_D) != 0 {
            //if both are broken..
            factor *= 2.0
        }

        if !((pVeh.m_pParentEntity!.s.number % 2) != 0) || !((pVeh.m_pParentEntity!.s.number % 6) != 0) {
            //won't yaw, so increase roll factor
            factor *= 4.0
        }

        pVeh.m_vOrientationVector[ROLL] += factor * pVeh.m_fTimeModifier
    } else if (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_E) != 0 || (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_F) != 0 {
        //right wing broken
        var factor: Float = 2.0
        if (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_E) != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_F) != 0 {
            //if both are broken..
            factor *= 2.0
        }

        if !((pVeh.m_pParentEntity!.s.number % 2) != 0) || !((pVeh.m_pParentEntity!.s.number % 6) != 0) {
            //won't yaw, so increase roll factor
            factor *= 4.0
        }

        pVeh.m_vOrientationVector[ROLL] -= factor * pVeh.m_fTimeModifier
    }
}

/// Source: oracle/codemp/game/FighterNPC.c:1299
func FighterYawAdjust(_ pVeh: JKAMP.Vehicle, _ riderPS: JKAMP.PlayerState, _ parentPS: JKAMP.PlayerState) {
    var angDif: Float = AngleSubtract(pVeh.m_vOrientationVector[YAW], riderPS.viewangles[YAW])

    if parentPS.speed != 0 {
        var s: Float = parentPS.speed
        let maxDif: Float = pVeh.m_pVehicleInfo!.turningSpeed * 0.8

        if s < 0.0 {
            s = -s
        }
        angDif *= s / pVeh.m_pVehicleInfo!.speedMax
        if angDif > maxDif {
            angDif = maxDif
        } else if angDif < -maxDif {
            angDif = -maxDif
        }
        pVeh.m_vOrientationVector[YAW] = AngleNormalize180(pVeh.m_vOrientationVector[YAW] - angDif * (pVeh.m_fTimeModifier * 0.2))
    }
}

/// Source: oracle/codemp/game/FighterNPC.c:1325
func FighterPitchAdjust(_ pVeh: JKAMP.Vehicle, _ riderPS: JKAMP.PlayerState, _ parentPS: JKAMP.PlayerState) {
    var angDif: Float = AngleSubtract(pVeh.m_vOrientationVector[PITCH], riderPS.viewangles[PITCH])

    if parentPS.speed != 0 {
        var s: Float = parentPS.speed
        let maxDif: Float = pVeh.m_pVehicleInfo!.turningSpeed * 0.8

        if s < 0.0 {
            s = -s
        }
        angDif *= s / pVeh.m_pVehicleInfo!.speedMax
        if angDif > maxDif {
            angDif = maxDif
        } else if angDif < -maxDif {
            angDif = -maxDif
        }
        pVeh.m_vOrientationVector[PITCH] = AngleNormalize360(pVeh.m_vOrientationVector[PITCH] - angDif * (pVeh.m_fTimeModifier * 0.2))
    }
}

/// Source: oracle/codemp/game/FighterNPC.c:1352
func FighterPitchClamp(_ pVeh: JKAMP.Vehicle, _ riderPS: JKAMP.PlayerState, _ parentPS: JKAMP.PlayerState, _ curTime: Int32) {
    if !BG_UnrestrainedPitchRoll(riderPS, pVeh) {
        //cap pitch reasonably
        if pVeh.m_pVehicleInfo!.pitchLimit != -1 && pVeh.m_iRemovedSurfaces == 0 && parentPS.electrifyTime < curTime {
            if pVeh.m_vOrientationVector[PITCH] > pVeh.m_pVehicleInfo!.pitchLimit {
                pVeh.m_vOrientationVector[PITCH] = pVeh.m_pVehicleInfo!.pitchLimit
            } else if pVeh.m_vOrientationVector[PITCH] < -pVeh.m_pVehicleInfo!.pitchLimit {
                pVeh.m_vOrientationVector[PITCH] = -pVeh.m_pVehicleInfo!.pitchLimit
            }
        }
    }
}

//MP RULE - ALL PROCESSORIENTCOMMANDS FUNCTIONS MUST BE BG-COMPATIBLE!!!
//If you really need to violate this rule for SP, then use ifdefs.
//By BG-compatible, I mean no use of game-specific data - ONLY use
//stuff available in the MP bgEntity (in SP, the bgEntity is #defined
//as a gentity, but the MP-compatible access restrictions are based
//on the bgEntity structure in the MP codebase) -rww
// ProcessOrientCommands the Vehicle.
/// Source: oracle/codemp/game/FighterNPC.c:1381
private func ProcessOrientCommands(_ pVeh: JKAMP.Vehicle) {
    /********************************************************************************/
    /*	BEGIN	Here is where make sure the vehicle is properly oriented.	BEGIN	*/
    /********************************************************************************/

    let parent: BgEntity? = pVeh.m_pParentEntity
    var parentPS: PlayerState?
    var riderPS: PlayerState?
    let angleTimeMod: Float
    let groundFraction: Float = 0.1
    var curRoll: Float = 0.0
    var isDead: Bool = false
    var isLandingOrLanded: Bool = false
    let curTime: Int32 = level.time
    //FIXME: pass in ucmd?  Not sure if this is reliable...

    var rider: BgEntity? = nil
    if parent!.s.owner != ENTITYNUM_NONE {
        rider = PM_BGEntForNum(parent!.s.owner) //&g_entities[parent->r.ownerNum];
    }

    if rider == nil {
        rider = parent
    }

    parentPS = parent!.playerState
    riderPS = rider!.playerState
    isDead = Bool(((parentPS!.eFlags & EF_DEAD) != 0))


    //VectorCopy( riderPS->viewangles, pVeh->m_vOrientation );
    //VectorCopy( riderPS->viewangles, parentPS->viewangles );
    //VectorCopy( riderPS->viewangles, pVeh->m_vOrientation );
    //VectorCopy( riderPS->viewangles, parentPS->viewangles );


    if parentPS!.hyperSpaceTime != 0 && (curTime - parentPS!.hyperSpaceTime) < HYPERSPACE_TIME {
        //Going to Hyperspace
        pVeh.m_vOrientationVector = riderPS!.viewangles
        parentPS!.viewangles = riderPS!.viewangles
        return
    }


    if pVeh.m_iDropTime >= curTime {
        //you can only YAW during this
        pVeh.m_vOrientationVector[YAW] = riderPS!.viewangles[YAW]
        parentPS!.viewangles[YAW] = pVeh.m_vOrientationVector[YAW]
        return
    }

    angleTimeMod = pVeh.m_fTimeModifier

    if isDead || parentPS!.electrifyTime >= curTime || (pVeh.m_pVehicleInfo!.surfDestruction != 0 && pVeh.m_iRemovedSurfaces != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_C) != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_D) != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_E) != 0 && (pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_F) != 0) {
        //do some special stuff for when all the wings are torn off
        FighterDamageRoutine(pVeh, parent!, parentPS!, riderPS!, isDead)
        pVeh.m_vOrientationVector[ROLL] = AngleNormalize180(pVeh.m_vOrientationVector[ROLL])
        return
    }

    if !BG_UnrestrainedPitchRoll(riderPS!, pVeh) {
        pVeh.m_vOrientationVector[ROLL] = PredictedAngularDecrement(0.95, angleTimeMod * 2.0, pVeh.m_vOrientationVector[ROLL])
    }

    isLandingOrLanded = (FighterIsLanding(pVeh, parentPS!) || FighterIsLanded(pVeh, parentPS!))

    if !isLandingOrLanded {
        //don't do this stuff while landed.. I guess. I don't want ships spinning in place, looks silly.
        var m: Int32 = 0
        var aVelDif: Float
        var dForVel: Float

        FighterWingMalfunctionCheck(pVeh, parentPS!)

        while m < 3 {
            aVelDif = pVeh.m_vFullAngleVelocity[m]

            if aVelDif != 0.0 {
                dForVel = (aVelDif * 0.1) * pVeh.m_fTimeModifier
                if dForVel > 1.0 || dForVel < -1.0 {
                    pVeh.m_vOrientationVector[m] += dForVel
                    pVeh.m_vOrientationVector[m] = AngleNormalize180(pVeh.m_vOrientationVector[m])
                    if m == PITCH {
                        //don't pitch downward into ground even more.
                        if pVeh.m_vOrientationVector[m] > 90.0 && (pVeh.m_vOrientationVector[m] - dForVel) < 90.0 {
                            pVeh.m_vOrientationVector[m] = 90.0
                            pVeh.m_vFullAngleVelocity[m] = -pVeh.m_vFullAngleVelocity[m]
                        }
                    }
                    pVeh.m_vFullAngleVelocity[m] -= dForVel
                } else {
                    pVeh.m_vFullAngleVelocity[m] = 0.0
                }
            }

            m += 1
        }
    } else {
        //clear decr/incr angles once landed.
        pVeh.m_vFullAngleVelocity = vec3_t()
    }

    curRoll = pVeh.m_vOrientationVector[ROLL]

    // If we're landed, we shouldn't be able to do anything but take off.
    if isLandingOrLanded && pVeh.m_iRemovedSurfaces == 0 && parentPS!.electrifyTime < curTime {
        if parentPS!.speed > 0.0 {
            //Uh... what?  Why?
            if pVeh.m_LandTrace.fraction < 0.3 {
                pVeh.m_vOrientationVector[PITCH] = 0.0
            } else {
                pVeh.m_vOrientationVector[PITCH] = PredictedAngularDecrement(0.83, angleTimeMod * 10.0, pVeh.m_vOrientationVector[PITCH])
            }
        }
        if pVeh.m_LandTrace.fraction > 0.1 || pVeh.m_LandTrace.plane.normal[2] < MIN_LANDING_SLOPE {
            //off the ground, at least (or not on a valid landing surf)
            // Dampen the turn rate based on the current height.
            FighterYawAdjust(pVeh, riderPS!, parentPS!)
        }
    } else if (pVeh.m_iRemovedSurfaces != 0 || parentPS!.electrifyTime >= curTime) && (!((pVeh.m_pParentEntity!.s.number % 2) != 0) || !((pVeh.m_pParentEntity!.s.number % 6) != 0)) {
        //no yaw control
    } else if pVeh.m_pPilot != nil && pVeh.m_pPilot!.s.number < MAX_CLIENTS && parentPS!.speed > 0.0 {
        if BG_UnrestrainedPitchRoll(riderPS!, pVeh) {
            pVeh.m_vOrientationVector = riderPS!.viewangles
            parentPS!.viewangles = riderPS!.viewangles
            //BG_ExternThisSoICanRecompileInDebug( pVeh, riderPS );

            curRoll = pVeh.m_vOrientationVector[ROLL]

            FighterNoseMalfunctionCheck(pVeh, parentPS!)

            //VectorCopy( pVeh->m_vOrientation, parentPS->viewangles );
        } else {
            /*
            float fTurnAmt[3];
            //PITCH
            fTurnAmt[PITCH] = riderPS->viewangles[PITCH] * 0.08f;
            //YAW
            fTurnAmt[YAW] = riderPS->viewangles[YAW] * 0.065f;
            fTurnAmt[YAW] *= fTurnAmt[YAW];
            // Dampen the turn rate based on the current height.
            if ( riderPS->viewangles[YAW] < 0 )
            {//must keep it negative because squaring a negative makes it positive
            fTurnAmt[YAW] = -fTurnAmt[YAW];
            }
            fTurnAmt[YAW] *= pVeh->m_LandTrace.fraction;
            //ROLL
            fTurnAmt[2] = 0.0f;
            */

            //Actal YAW
            /*
            pVeh->m_vOrientation[ROLL] = curRoll;
            FighterRollAdjust(pVeh, riderPS, parentPS);
            curRoll = pVeh->m_vOrientation[ROLL];
            */
            FighterYawAdjust(pVeh, riderPS!, parentPS!)

            // If we are not hitting the ground, allow the fighter to pitch up and down.
            if !FighterOverValidLandingSurface(pVeh) || parentPS!.speed > MIN_LANDING_SPEED {
                var fYawDelta: Float

                FighterPitchAdjust(pVeh, riderPS!, parentPS!)

                FighterNoseMalfunctionCheck(pVeh, parentPS!)

                // Adjust the roll based on the turn amount and dampen it a little.
                fYawDelta = AngleSubtract(pVeh.m_vOrientationVector[YAW], pVeh.m_vPrevOrientation[YAW]) //pVeh->m_vOrientation[YAW] - pVeh->m_vPrevOrientation[YAW];
                if fYawDelta > 8.0 {
                    fYawDelta = 8.0
                } else if fYawDelta < -8.0 {
                    fYawDelta = -8.0
                }
                curRoll -= fYawDelta
                curRoll = PredictedAngularDecrement(0.93, angleTimeMod * 2.0, curRoll)

                //cap it reasonably
                //NOTE: was hardcoded to 40.0f, now using extern data
                if pVeh.m_pVehicleInfo!.rollLimit != -1 {
                    if curRoll > pVeh.m_pVehicleInfo!.rollLimit {
                        curRoll = pVeh.m_pVehicleInfo!.rollLimit
                    } else if curRoll < -pVeh.m_pVehicleInfo!.rollLimit {
                        curRoll = -pVeh.m_pVehicleInfo!.rollLimit
                    }
                }
            }
        }
    }

    // If you are directly impacting the ground, even out your pitch.
    if isLandingOrLanded {
        //only if capable of landing
        if !isDead && parentPS!.electrifyTime < curTime && (pVeh.m_pVehicleInfo!.surfDestruction == 0 || pVeh.m_iRemovedSurfaces == 0) {
            //not crashing or spiralling out of control...
            if pVeh.m_vOrientationVector[PITCH] > 0 {
                pVeh.m_vOrientationVector[PITCH] = PredictedAngularDecrement(0.2, angleTimeMod * 10.0, pVeh.m_vOrientationVector[PITCH])
            } else {
                pVeh.m_vOrientationVector[PITCH] = PredictedAngularDecrement(0.75, angleTimeMod * 10.0, pVeh.m_vOrientationVector[PITCH])
            }
        }
    }


    /*
    //NOTE: all this is redundant now since we have the FighterDamageRoutine func...
    #ifdef _JK2MP //...yeah. Need to send armor across net for prediction to work.
    if ( isDead )
    #else
    if ( pVeh->m_iArmor <= 0 )
    #endif
    {//going to explode
    //FIXME: maybe make it erratically jerk or spin or start and stop?
    #ifndef _JK2MP
    if ( g_speederControlScheme->value > 0 || !rider || rider->s.number )
    #else
    if (1)
    #endif
    {
    pVeh->m_ucmd.rightmove = Q_irand( -64, 64 );
    }
    else
    {
    pVeh->m_ucmd.rightmove = 0;
    }
    pVeh->m_ucmd.forwardmove = Q_irand( -32, 127 );
    pVeh->m_ucmd.upmove = Q_irand( -127, 127 );
    pVeh->m_vOrientation[YAW] += Q_flrand( -10, 10 );
    pVeh->m_vOrientation[PITCH] += pVeh->m_fTimeModifier;
    if ( pVeh->m_vOrientation[PITCH] > 60.0f )
    {
    pVeh->m_vOrientation[PITCH] = 60.0f;
    }
    if ( pVeh->m_LandTrace.fraction != 0.0f )
    {
    parentPS->velocity[2] -= pVeh->m_pVehicleInfo->acceleration * pVeh->m_fTimeModifier;
    }
    }
    */
    // If no one is in this vehicle and it's up in the sky, pitch it forward as it comes tumbling down.
    if !pVeh.m_pVehicleInfo!.runInhabited(pVeh) && pVeh.m_LandTrace.fraction >= groundFraction && !FighterIsInSpace(parent.map { Entity($0) }!) && !FighterSuspended(pVeh, parentPS!) {
        pVeh.m_ucmd.upmove = 0
        //pVeh->m_ucmd.forwardmove = 0;
        pVeh.m_vOrientationVector[PITCH] += pVeh.m_fTimeModifier
        if !BG_UnrestrainedPitchRoll(riderPS!, pVeh) {
            if pVeh.m_vOrientationVector[PITCH] > 60.0 {
                pVeh.m_vOrientationVector[PITCH] = 60.0
            }
        }
    }

    if parentPS!.hackingTime == 0 {
        //use that roll
        pVeh.m_vOrientationVector[ROLL] = curRoll
        //NOTE: this seems really backwards...
        if pVeh.m_vOrientationVector[ROLL] != 0 {
            //continually adjust the yaw based on the roll..
            if (pVeh.m_iRemovedSurfaces != 0 || parentPS!.electrifyTime >= curTime) && (!((pVeh.m_pParentEntity!.s.number % 2) != 0) || !((pVeh.m_pParentEntity!.s.number % 6) != 0)) {
                //leave YAW alone
            } else {
                if !BG_UnrestrainedPitchRoll(riderPS!, pVeh) {
                    pVeh.m_vOrientationVector[YAW] -= ((pVeh.m_vOrientationVector[ROLL]) * 0.05) * pVeh.m_fTimeModifier
                }
            }
        }
    } else {
        //add in strafing roll
        let strafeRoll: Float = (parentPS!.hackingTime / MAX_STRAFE_TIME) * pVeh.m_pVehicleInfo!.rollLimit
        let strafeDif: Float = AngleSubtract(strafeRoll, pVeh.m_vOrientationVector[ROLL])
        pVeh.m_vOrientationVector[ROLL] += (strafeDif * 0.1) * pVeh.m_fTimeModifier
        if !BG_UnrestrainedPitchRoll(riderPS!, pVeh) {
            //cap it reasonably
            if pVeh.m_pVehicleInfo!.rollLimit != -1 && pVeh.m_iRemovedSurfaces == 0 && parentPS!.electrifyTime < curTime {
                if pVeh.m_vOrientationVector[ROLL] > pVeh.m_pVehicleInfo!.rollLimit {
                    pVeh.m_vOrientationVector[ROLL] = pVeh.m_pVehicleInfo!.rollLimit
                } else if pVeh.m_vOrientationVector[ROLL] < -pVeh.m_pVehicleInfo!.rollLimit {
                    pVeh.m_vOrientationVector[ROLL] = -pVeh.m_pVehicleInfo!.rollLimit
                }
            }
        }
    }

    if pVeh.m_pVehicleInfo!.surfDestruction != 0 {
        FighterDamageRoutine(pVeh, parent!, parentPS!, riderPS!, isDead)
    }
    pVeh.m_vOrientationVector[ROLL] = AngleNormalize180(pVeh.m_vOrientationVector[ROLL])

    /********************************************************************************/
    /*	END	Here is where make sure the vehicle is properly oriented.	END			*/
    /********************************************************************************/
}

// This function makes sure that the vehicle is properly animated.
/// Source: oracle/codemp/game/FighterNPC.c:1836
private func AnimateVehicle(_ pVeh: JKAMP.Vehicle) {
    var Anim: Int32 = -1
    let iFlags: Int32 = SETANIM_FLAG_NORMAL
    let iBlend: Int32 = 300
    var isLanding: Bool = false
    var isLanded: Bool = false
    let parentPS: PlayerState? = pVeh.m_pParentEntity!.playerState
    //nothing
    let curTime: Int32 = level.time
    //FIXME: pass in ucmd?  Not sure if this is reliable...

    if parentPS!.hyperSpaceTime != 0 && curTime - parentPS!.hyperSpaceTime < HYPERSPACE_TIME {
        //Going to Hyperspace
        //close the wings (FIXME: makes sense on X-Wing, not Shuttle?)
        if (pVeh.m_ulFlags & CUnsignedLong(bitPattern: CLong(VEH_WINGSOPEN))) != 0 {
            pVeh.m_ulFlags &= ~CUnsignedLong(bitPattern: CLong(VEH_WINGSOPEN))
            Anim = BOTH_WINGS_CLOSE
        }
    } else {
        isLanding = FighterIsLanding(pVeh, parentPS!)
        isLanded = FighterIsLanded(pVeh, parentPS!)

        // if we're above launch height (way up in the air)...
        if !isLanding && !isLanded {
            if !((pVeh.m_ulFlags & CUnsignedLong(bitPattern: CLong(VEH_WINGSOPEN))) != 0) {
                pVeh.m_ulFlags |= CUnsignedLong(bitPattern: CLong(VEH_WINGSOPEN))
                pVeh.m_ulFlags &= ~CUnsignedLong(bitPattern: CLong(VEH_GEARSOPEN))
                Anim = BOTH_WINGS_OPEN
            }
        } else {
            // otherwise we're below launch height and still taking off.
            if (pVeh.m_ucmd.forwardmove < 0 || pVeh.m_ucmd.upmove < 0 || isLanded) && pVeh.m_LandTrace.fraction <= 0.4 && pVeh.m_LandTrace.plane.normal[2] >= MIN_LANDING_SLOPE {
                //already landed or trying to land and close to ground
                // Open gears.
                if !((pVeh.m_ulFlags & CUnsignedLong(bitPattern: CLong(VEH_GEARSOPEN))) != 0) {
                    if pVeh.m_pVehicleInfo!.soundLand != 0 {
                        //just landed?
                        G_EntitySound(((pVeh.m_pParentEntity).map { Entity($0) })!, CHAN_AUTO, pVeh.m_pVehicleInfo!.soundLand)
                        //trap_S_StartSound( NULL, pVeh->m_pParentEntity->s.number, CHAN_AUTO, pVeh->m_pVehicleInfo->soundLand );
                    }
                    pVeh.m_ulFlags |= CUnsignedLong(bitPattern: CLong(VEH_GEARSOPEN))
                    Anim = BOTH_GEARS_OPEN
                }
            } else {
                //trying to take off and almost halfway off the ground
                // Close gears (if they're open).
                if (pVeh.m_ulFlags & CUnsignedLong(bitPattern: CLong(VEH_GEARSOPEN))) != 0 {
                    pVeh.m_ulFlags &= ~CUnsignedLong(bitPattern: CLong(VEH_GEARSOPEN))
                    Anim = BOTH_GEARS_CLOSE
                    //iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD;
                } else {
                    // If gears are closed, and we are below launch height, close the wings.
                    if (pVeh.m_ulFlags & CUnsignedLong(bitPattern: CLong(VEH_WINGSOPEN))) != 0 {
                        pVeh.m_ulFlags &= ~CUnsignedLong(bitPattern: CLong(VEH_WINGSOPEN))
                        Anim = BOTH_WINGS_CLOSE
                    }
                }
            }
        }
    }

    if Anim != -1 {
        BG_SetAnim(pVeh.m_pParentEntity!.playerState!, bgAllAnims[pVeh.m_pParentEntity!.localAnimIndex].animsSlots, SETANIM_BOTH, Anim, iFlags, iBlend)
    }
}

// This function makes sure that the rider's in this vehicle are properly animated.
/// Source: oracle/codemp/game/FighterNPC.c:1938
private func AnimateRiders(_ pVeh: JKAMP.Vehicle) {
}

/// Source: oracle/codemp/game/FighterNPC.c:1948
func G_SetFighterVehicleFunctions(_ pVehInfo: JKAMP.VehicleInfo) {
    pVehInfo.AnimateVehicle = VehicleInfoThunks.AnimateVehicle
    pVehInfo.AnimateRiders = VehicleInfoThunks.AnimateRiders
    //	pVehInfo->ValidateBoard				=		ValidateBoard;
    //	pVehInfo->SetParent					=		SetParent;
    //	pVehInfo->SetPilot					=		SetPilot;
    //	pVehInfo->AddPassenger				=		AddPassenger;
    //	pVehInfo->Animate					=		Animate;
    pVehInfo.Board = VehicleInfoThunks.Board
    pVehInfo.Eject = VehicleInfoThunks.Eject
    //	pVehInfo->EjectAll					=		EjectAll;
    //	pVehInfo->StartDeathDelay			=		StartDeathDelay;
    //	pVehInfo->DeathUpdate				=		DeathUpdate;
    //	pVehInfo->RegisterAssets			=		RegisterAssets;
    //	pVehInfo->Initialize				=		Initialize;
    pVehInfo.Update = VehicleInfoThunks.Update
    //	pVehInfo->UpdateRider				=		UpdateRider;
    pVehInfo.ProcessMoveCommands = VehicleInfoThunks.ProcessMoveCommands
    pVehInfo.ProcessOrientCommands = VehicleInfoThunks.ProcessOrientCommands

    //	pVehInfo->AttachRiders				=		AttachRiders;
    //	pVehInfo->Ghost						=		Ghost;
    //	pVehInfo->UnGhost					=		UnGhost;
    //	pVehInfo->Inhabited					=		Inhabited;
}

// Create/Allocate a new Animal Vehicle (initializing it as well).
/// Source: oracle/codemp/game/FighterNPC.c:1994
func G_CreateFighterNPC(_ pVeh: inout JKAMP.Vehicle?, _ strType: String) {
    // Allocate the Vehicle.
    //these will remain on entities on the client once allocated because the pointer is
    //never stomped. on the server, however, when an ent is freed, the entity struct is
    //memset to 0, so this memory would be lost..
    G_AllocateVehicleObject(&pVeh)
    pVeh!.clear()
    pVeh!.m_pVehicleInfo = g_vehicleInfo[BG_VehicleGetIndex(strType)]
}

/// One static per function this file stores in a `VehicleInfo` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum VehicleInfoThunks {
    /// Source: oracle/codemp/game/FighterNPC.c:1938
    static let AnimateRiders: VehicleInfoAnimateRiders = { JKAMP_GameLogic.AnimateRiders(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/FighterNPC.c:1836
    static let AnimateVehicle: VehicleInfoAnimateVehicle = { JKAMP_GameLogic.AnimateVehicle(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/FighterNPC.c:212
    static let Board: VehicleInfoBoard = { JKAMP_GameLogic.Board(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/FighterNPC.c:224
    static let Eject: VehicleInfoEject = { JKAMP_GameLogic.Eject(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!), $2 != 0) ? 1 : 0 }

    /// Source: oracle/codemp/game/FighterNPC.c:370
    static let ProcessMoveCommands: VehicleInfoProcessMoveCommands = { JKAMP_GameLogic.ProcessMoveCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/FighterNPC.c:1381
    static let ProcessOrientCommands: VehicleInfoProcessOrientCommands = { JKAMP_GameLogic.ProcessOrientCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/FighterNPC.c:188
    static let Update: VehicleInfoUpdate = { JKAMP_GameLogic.Update(JKAMP.Vehicle(handle: $0!), JKAMP.Usercmd(handle: $1!)) ? 1 : 0 }
}
