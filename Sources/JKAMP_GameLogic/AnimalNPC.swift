import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/AnimalNPC.c:53
// Raven wrote: #define currentAngles r . currentAngles
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/AnimalNPC.c:54
// Raven wrote: #define currentOrigin r . currentOrigin
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/AnimalNPC.c:55
// Raven wrote: #define mins r . mins
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/AnimalNPC.c:56
// Raven wrote: #define maxs r . maxs
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/AnimalNPC.c:57
extension JKAMP.PlayerState {
    /// Raven's `#define legsAnimTimer legsTimer`, an alias of the field, file-private to this stub.
    fileprivate var legsAnimTimer: Int32 {
        get { self.legsTimer }
        nonmutating set { self.legsTimer = newValue }
    }
}

/// Source: oracle/codemp/game/AnimalNPC.c:58
extension JKAMP.PlayerState {
    /// Raven's `#define torsoAnimTimer torsoTimer`, an alias of the field, file-private to this stub.
    fileprivate var torsoAnimTimer: Int32 {
        get { self.torsoTimer }
        nonmutating set { self.torsoTimer = newValue }
    }
}

/// Source: oracle/codemp/game/AnimalNPC.c:59
// Raven wrote: #define bool qboolean
// Swift has `Bool`, so a body writes it.

/// Source: oracle/codemp/game/AnimalNPC.c:60
// Raven wrote: #define false qfalse
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/AnimalNPC.c:61
// Raven wrote: #define true qtrue
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/AnimalNPC.c:63
// Raven wrote: #define sqrtf sqrt
private func sqrtf(_ x: Float) -> Float {
    x.squareRoot()
}

/// Source: oracle/codemp/game/AnimalNPC.c:64
// Raven wrote: #define Q_flrand flrand
// The module declares `Q_flrand` too, so a body writes `flrand` where Raven wrote `Q_flrand`.

/// Source: oracle/codemp/game/AnimalNPC.c:66
private let MOD_EXPLOSIVE = JKAMP.MOD_SUICIDE

// Update death sequence.
/// Source: oracle/codemp/game/AnimalNPC.c:97
private func DeathUpdate(_ pVeh: JKAMP.Vehicle) {
    if level.time >= pVeh.m_iDieTime {
        // If the vehicle is not empty.
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
        // Raven wrote: if ( pVeh->m_pVehicleInfo->Inhabited( pVeh ) ) { pVeh->m_pVehicleInfo->EjectAll( pVeh ); } else { // Waste this sucker. }
        portMissing("DeathUpdate", source: "oracle/codemp/game/AnimalNPC.c:97")

        // Die now...
        /*		else
        {
        vec3_t	mins, maxs, bottom;
        trace_t	trace;

        if ( pVeh->m_pVehicleInfo->explodeFX )
        {
        G_PlayEffect( pVeh->m_pVehicleInfo->explodeFX, parent->currentOrigin );
        //trace down and place mark
        VectorCopy( parent->currentOrigin, bottom );
        bottom[2] -= 80;
        gi.trace( &trace, parent->currentOrigin, vec3_origin, vec3_origin, bottom, parent->s.number, CONTENTS_SOLID );
        if ( trace.fraction < 1.0f )
        {
        VectorCopy( trace.endpos, bottom );
        bottom[2] += 2;
        G_PlayEffect( "ships/ship_explosion_mark", trace.endpos );
        }
        }

        parent->takedamage = qfalse;//so we don't recursively damage ourselves
        if ( pVeh->m_pVehicleInfo->explosionRadius > 0 && pVeh->m_pVehicleInfo->explosionDamage > 0 )
        {
        VectorCopy( parent->mins, mins );
        mins[2] = -4;//to keep it off the ground a *little*
        VectorCopy( parent->maxs, maxs );
        VectorCopy( parent->currentOrigin, bottom );
        bottom[2] += parent->mins[2] - 32;
        gi.trace( &trace, parent->currentOrigin, mins, maxs, bottom, parent->s.number, CONTENTS_SOLID );
        G_RadiusDamage( trace.endpos, NULL, pVeh->m_pVehicleInfo->explosionDamage, pVeh->m_pVehicleInfo->explosionRadius, NULL, MOD_EXPLOSIVE );//FIXME: extern damage and radius or base on fuel
        }

        parent->e_ThinkFunc = thinkF_G_FreeEntity;
        parent->nextthink = level.time + FRAMETIME;
        }*/
    }
}

// Like a think or move command, this updates various vehicle properties.
/// Source: oracle/codemp/game/AnimalNPC.c:151
private func Update(_ pVeh: JKAMP.Vehicle, _ pUcmd: JKAMP.Usercmd) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
    // Raven wrote: return g_vehicleInfo[VEHICLE_BASE].Update( pVeh, pUcmd )
    portMissing("Update", source: "oracle/codemp/game/AnimalNPC.c:151")
}

//MP RULE - ALL PROCESSMOVECOMMANDS FUNCTIONS MUST BE BG-COMPATIBLE!!!
//If you really need to violate this rule for SP, then use ifdefs.
//By BG-compatible, I mean no use of game-specific data - ONLY use
//stuff available in the MP bgEntity (in SP, the bgEntity is #defined
//as a gentity, but the MP-compatible access restrictions are based
//on the bgEntity structure in the MP codebase) -rww
// ProcessMoveCommands the Vehicle.
/// Source: oracle/codemp/game/AnimalNPC.c:168
private func ProcessMoveCommands(_ pVeh: JKAMP.Vehicle) {
    /************************************************************************************/
    /*	BEGIN	Here is where we move the vehicle (forward or back or whatever). BEGIN	*/
    /************************************************************************************/

    //Client sets ucmds and such for speed alterations
    let speedInc: Float
    let speedIdleDec: Float
    let speedIdle: Float
    let speedIdleAccel: Float
    let speedMin: Float
    var speedMax: Float
    let fWalkSpeedMax: Float
    let curTime: Int32
    let parent: BgEntity? = pVeh.m_pParentEntity
    let parentPS: PlayerState? = parent!.playerState

    curTime = level.time
    //FIXME: pass in ucmd?  Not sure if this is reliable...


    // Bucking so we can't do anything.
    //#ifdef QAGAME //this was in Update above
    //		((gentity_t *)parent)->client->ps.speed = 0;
    //#endif
    speedIdleDec = pVeh.m_pVehicleInfo!.decelIdle * pVeh.m_fTimeModifier
    speedMax = pVeh.m_pVehicleInfo!.speedMax

    speedIdle = pVeh.m_pVehicleInfo!.speedIdle
    speedIdleAccel = pVeh.m_pVehicleInfo!.accelIdle * pVeh.m_fTimeModifier
    speedMin = pVeh.m_pVehicleInfo!.speedMin



    if pVeh.m_pPilot != nil && (pVeh.m_ucmd.buttons & BUTTON_ALT_ATTACK) != 0 && pVeh.m_pVehicleInfo!.turboSpeed != 0 {
        if (curTime - pVeh.m_iTurboTime) > pVeh.m_pVehicleInfo!.turboRecharge {
            pVeh.m_iTurboTime = (curTime + pVeh.m_pVehicleInfo!.turboDuration)
            parentPS!.speed = pVeh.m_pVehicleInfo!.turboSpeed // Instantly Jump To Turbo Speed
        }
    }

    if curTime < pVeh.m_iTurboTime {
        speedMax = pVeh.m_pVehicleInfo!.turboSpeed
    } else {
        speedMax = pVeh.m_pVehicleInfo!.speedMax
    }

    if parentPS!.m_iVehicleNum == 0 {
        //drifts to a stop
        speedInc = speedIdle * pVeh.m_fTimeModifier
        parentPS!.moveDir = vec3_t()
        //m_ucmd.forwardmove = 127;
        parentPS!.speed = 0
    } else {
        speedInc = pVeh.m_pVehicleInfo!.acceleration * pVeh.m_fTimeModifier
    }

    if parentPS!.speed != 0 || parentPS!.groundEntityNum == ENTITYNUM_NONE || pVeh.m_ucmd.forwardmove != 0 || pVeh.m_ucmd.upmove > 0 {
        if pVeh.m_ucmd.forwardmove > 0 && speedInc != 0 {
            parentPS!.speed += speedInc
        } else if pVeh.m_ucmd.forwardmove < 0 {
            if parentPS!.speed > speedIdle {
                parentPS!.speed -= speedInc
            } else if parentPS!.speed > speedMin {
                parentPS!.speed -= speedIdleDec
            }
        } else if parentPS!.speed > 0.0 {
            // No input, so coast to stop.
            parentPS!.speed -= speedIdleDec
            if parentPS!.speed < 0.0 {
                parentPS!.speed = 0.0
            }
        } else if parentPS!.speed < 0.0 {
            parentPS!.speed += speedIdleDec
            if parentPS!.speed > 0.0 {
                parentPS!.speed = 0.0
            }
        }
    } else {
        if pVeh.m_ucmd.forwardmove < 0 {
            pVeh.m_ucmd.forwardmove = 0
        }
        if pVeh.m_ucmd.upmove < 0 {
            pVeh.m_ucmd.upmove = 0
        }

        //pVeh->m_ucmd.rightmove = 0;

        /*if ( !pVeh->m_pVehicleInfo->strafePerc
        || (!g_speederControlScheme->value && !parent->s.number) )
        {//if in a strafe-capable vehicle, clear strafing unless using alternate control scheme
        pVeh->m_ucmd.rightmove = 0;
        }*/
    }

    fWalkSpeedMax = speedMax * 0.275
    if curTime > pVeh.m_iTurboTime && (pVeh.m_ucmd.buttons & BUTTON_WALKING) != 0 && parentPS!.speed > fWalkSpeedMax {
        parentPS!.speed = fWalkSpeedMax
    } else if parentPS!.speed > speedMax {
        parentPS!.speed = speedMax
    } else if parentPS!.speed < speedMin {
        parentPS!.speed = speedMin
    }

    /********************************************************************************/
    /*	END Here is where we move the vehicle (forward or back or whatever). END	*/
    /********************************************************************************/
}

//MP RULE - ALL PROCESSORIENTCOMMANDS FUNCTIONS MUST BE BG-COMPATIBLE!!!
//If you really need to violate this rule for SP, then use ifdefs.
//By BG-compatible, I mean no use of game-specific data - ONLY use
//stuff available in the MP bgEntity (in SP, the bgEntity is #defined
//as a gentity, but the MP-compatible access restrictions are based
//on the bgEntity structure in the MP codebase) -rww
// ProcessOrientCommands the Vehicle.
/// Source: oracle/codemp/game/AnimalNPC.c:338
private func ProcessOrientCommands(_ pVeh: JKAMP.Vehicle) {
    /********************************************************************************/
    /*	BEGIN	Here is where make sure the vehicle is properly oriented.	BEGIN	*/
    /********************************************************************************/
    let parent: BgEntity? = pVeh.m_pParentEntity
    var parentPS: PlayerState?
    var riderPS: PlayerState?

    var rider: BgEntity? = nil
    if parent!.s.owner != ENTITYNUM_NONE {
        rider = PM_BGEntForNum(parent!.s.owner) //&g_entities[parent->r.ownerNum];
    }

    // Bucking so we can't do anything.

    if rider == nil {
        rider = parent
    }



    parentPS = parent!.playerState
    riderPS = rider!.playerState

    if rider != nil {
        var angDif: Float = AngleSubtract(pVeh.m_vOrientationVector[YAW], riderPS!.viewangles[YAW])
        if parentPS != nil && parentPS!.speed != 0 {
            var s: Float = parentPS!.speed
            let maxDif: Float = pVeh.m_pVehicleInfo!.turningSpeed * 4.0
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


    /*	speed = VectorLength( parentPS->velocity );

    // If the player is the rider...
    if ( rider->s.number < MAX_CLIENTS )
    {//FIXME: use the vehicle's turning stat in this calc
    pVeh->m_vOrientation[YAW] = riderPS->viewangles[YAW];
    }
    else
    {
    float turnSpeed = pVeh->m_pVehicleInfo->turningSpeed;
    if ( !pVeh->m_pVehicleInfo->turnWhenStopped
    && !parentPS->speed )//FIXME: or !pVeh->m_ucmd.forwardmove?
    {//can't turn when not moving
    //FIXME: or ramp up to max turnSpeed?
    turnSpeed = 0.0f;
    }
    #ifdef _JK2MP
    if (rider->s.eType == ET_NPC)
    #else
    if ( !rider || rider->NPC )
    #endif
    {//help NPCs out some
    turnSpeed *= 2.0f;
    #ifdef _JK2MP
    if (parentPS->speed > 200.0f)
    #else
    if ( parent->client->ps.speed > 200.0f )
    #endif
    {
    turnSpeed += turnSpeed * parentPS->speed/200.0f*0.05f;
    }
    }
    turnSpeed *= pVeh->m_fTimeModifier;

    //default control scheme: strafing turns, mouselook aims
    if ( pVeh->m_ucmd.rightmove < 0 )
    {
    pVeh->m_vOrientation[YAW] += turnSpeed;
    }
    else if ( pVeh->m_ucmd.rightmove > 0 )
    {
    pVeh->m_vOrientation[YAW] -= turnSpeed;
    }

    if ( pVeh->m_pVehicleInfo->malfunctionArmorLevel && pVeh->m_iArmor <= pVeh->m_pVehicleInfo->malfunctionArmorLevel )
    {//damaged badly
    }
    }*/

    /********************************************************************************/
    /*	END	Here is where make sure the vehicle is properly oriented.	END			*/
    /********************************************************************************/
}

/// Source: oracle/codemp/game/AnimalNPC.c:467
func AnimalProcessOri(_ pVeh: JKAMP.Vehicle) {
    ProcessOrientCommands(pVeh)
}

/// Source: oracle/codemp/game/AnimalNPC.c:474
private func AnimateVehicle(_ pVeh: JKAMP.Vehicle) {
    var Anim: animNumber_t = BOTH_VT_IDLE
    var iFlags: Int32 = SETANIM_FLAG_NORMAL
    var iBlend: Int32 = 300
    let pilot: Entity? = pVeh.m_pPilot.map { Entity($0) }
    let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
    var pilotPS: PlayerState?
    var parentPS: PlayerState?
    let fSpeedPercToMax: Float

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int' to type 'PlayerState'".
    // Raven wrote: pilotPS = (pilot)?(pilot->playerState):(0)
    portMissing("AnimateVehicle", source: "oracle/codemp/game/AnimalNPC.c:474")
    parentPS = parent!.playerState

    // We're dead (boarding is reused here so I don't have to make another variable :-).
    if parent!.health <= 0 {
        /*
        if ( pVeh->m_iBoarding != -999 )	// Animate the death just once!
        {
        pVeh->m_iBoarding = -999;
        iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD;

        // FIXME! Why do you keep repeating over and over!!?!?!? Bastard!
        //Vehicle_SetAnim( parent, SETANIM_LEGS, BOTH_VT_DEATH1, iFlags, iBlend );
        }
        */
        return
    }

    // If they're bucking, play the animation and leave...
    if parent!.client!.ps.legsAnim == BOTH_VT_BUCK {
        // Done with animation? Erase the flag.
        if parent!.client!.ps.legsTimer <= 0 {
            pVeh.m_ulFlags &= ~UInt(bitPattern: Int(VEH_BUCKING))
        } else {
            return
        }
    } else if (pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_BUCKING))) != 0 {
        iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD
        Anim = BOTH_VT_BUCK
        iBlend = 500
        Vehicle_SetAnim(parent!, SETANIM_LEGS, BOTH_VT_BUCK, iFlags, iBlend)
        return
    }

    // Boarding animation.
    if pVeh.m_iBoarding != 0 {
        // We've just started boarding, set the amount of time it will take to finish boarding.
        if pVeh.m_iBoarding < 0 {
            let iAnimLen: Int32

            // Boarding from left...
            if pVeh.m_iBoarding == -1 {
                Anim = BOTH_VT_MOUNT_L
            } else if pVeh.m_iBoarding == -2 {
                Anim = BOTH_VT_MOUNT_R
            } else if pVeh.m_iBoarding == -3 {
                Anim = BOTH_VT_MOUNT_B
            }

            // Set the delay time (which happens to be the time it takes for the animation to complete).
            // NOTE: Here I made it so the delay is actually 70% (0.7f) of the animation time.
            iAnimLen = Int32(BG_AnimLength(parent!.localAnimIndex, Anim) * 0.7)
            pVeh.m_iBoarding = level.time + iAnimLen

            // Set the animation, which won't be interrupted until it's completed.
            // TODO: But what if he's killed? Should the animation remain persistant???
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD

            Vehicle_SetAnim(parent!, SETANIM_LEGS, Anim, iFlags, iBlend)
            if pilot != nil {
                Vehicle_SetAnim(pilot!, SETANIM_BOTH, Anim, iFlags, iBlend)
            }
            return
        } else if pVeh.m_iBoarding <= level.time {
            // Otherwise we're done.
            pVeh.m_iBoarding = 0
        }
    }

    // Percentage of maximum speed relative to current speed.
    //float fSpeed = VectorLength( client->ps.velocity );
    fSpeedPercToMax = parent!.client!.ps.speed / pVeh.m_pVehicleInfo!.speedMax


    // Going in reverse...
    if fSpeedPercToMax < -0.01 {
        Anim = BOTH_VT_WALK_REV
        iBlend = 600
    } else {
        let Turbo: Bool = (fSpeedPercToMax > 0.0 && level.time < pVeh.m_iTurboTime)
        let Walking: Bool = (fSpeedPercToMax > 0.0 && ((pVeh.m_ucmd.buttons & BUTTON_WALKING) != 0 || fSpeedPercToMax <= 0.275))
        let Running: Bool = (fSpeedPercToMax > 0.275)


        // Remove Crashing Flag
        //----------------------
        pVeh.m_ulFlags &= ~UInt(bitPattern: Int(VEH_CRASHING))

        if Turbo {
            // Kicked In Turbo
            iBlend = 50
            iFlags = SETANIM_FLAG_OVERRIDE
            Anim = BOTH_VT_TURBO
        } else {
            // No Special Moves
            iBlend = 300
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLDLESS
            Anim = (Walking) ? (BOTH_VT_WALK_FWD) : ((Running) ? (BOTH_VT_RUN_FWD) : (BOTH_VT_IDLE1))
        }
    }
    Vehicle_SetAnim(parent!, SETANIM_LEGS, Anim, iFlags, iBlend)
}

//rwwFIXMEFIXME: This is all going to have to be predicted I think, or it will feel awful
//and lagged
// This function makes sure that the rider's in this vehicle are properly animated.
/// Source: oracle/codemp/game/AnimalNPC.c:620
private func AnimateRiders(_ pVeh: JKAMP.Vehicle) {
    var Anim: animNumber_t = BOTH_VT_IDLE
    var iFlags: Int32 = SETANIM_FLAG_NORMAL
    var iBlend: Int32 = 500
    let pilot: Entity? = pVeh.m_pPilot.map { Entity($0) }
    let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
    var pilotPS: PlayerState?
    var parentPS: PlayerState?
    let fSpeedPercToMax: Float

    pilotPS = pVeh.m_pPilot!.playerState
    parentPS = pVeh.m_pPilot!.playerState

    // Boarding animation.
    if pVeh.m_iBoarding != 0 {
        return
    }

    // Percentage of maximum speed relative to current speed.
    fSpeedPercToMax = parent!.client!.ps.speed / pVeh.m_pVehicleInfo!.speedMax

    // Going in reverse...
    if 0 != 0 {
        Anim = BOTH_VT_WALK_REV
        iBlend = 600
    } else {
        let HasWeapon: Bool = ((pilotPS!.weapon != WP_NONE) && (pilotPS!.weapon != WP_MELEE))
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '_' to expected argument type 'Bool'".
        // Raven wrote: bool Attacking = (HasWeapon && !!(pVeh->m_ucmd.buttons&BUTTON_ATTACK));
        portMissing("AnimateRiders", source: "oracle/codemp/game/AnimalNPC.c:620")
        var Right: Bool = (pVeh.m_ucmd.rightmove > 0)
        var Left: Bool = (pVeh.m_ucmd.rightmove < 0)
        let Turbo: Bool = (fSpeedPercToMax > 0.0 && level.time < pVeh.m_iTurboTime)
        let Walking: Bool = (fSpeedPercToMax > 0.0 && ((pVeh.m_ucmd.buttons & BUTTON_WALKING) != 0 || fSpeedPercToMax <= 0.275))
        let Running: Bool = (fSpeedPercToMax > 0.275)
        var WeaponPose: EWeaponPose = WPOSE_NONE


        // Remove Crashing Flag
        //----------------------
        pVeh.m_ulFlags &= ~UInt(bitPattern: Int(VEH_CRASHING))


        // Put Away Saber When It Is Not Active
        //--------------------------------------


        // Don't Interrupt Attack Anims
        //------------------------------
        if pilotPS!.weaponTime > 0 {
            return
        }

        // Compute The Weapon Pose
        //--------------------------
        if pilotPS!.weapon == WP_BLASTER {
            WeaponPose = WPOSE_BLASTER
        } else if pilotPS!.weapon == WP_SABER {
            if (pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_SABERINLEFTHAND))) != 0 && pilotPS!.torsoAnim == BOTH_VT_ATL_TO_R_S {
                pVeh.m_ulFlags &= ~UInt(bitPattern: Int(VEH_SABERINLEFTHAND))
            }
            if !((pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_SABERINLEFTHAND))) != 0) && pilotPS!.torsoAnim == BOTH_VT_ATR_TO_L_S {
                pVeh.m_ulFlags |= UInt(bitPattern: Int(VEH_SABERINLEFTHAND))
            }
            WeaponPose = (pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_SABERINLEFTHAND))) != 0 ? (WPOSE_SABERLEFT) : (WPOSE_SABERRIGHT)
        }


        // Port-note: A read of `Attacking`, a local the draft left as a hole.
        // Raven wrote: if (Attacking && WeaponPose) {// Attack! iBlend = 100; iFlags = SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD|SETANIM_FLAG_RESTART; if (Turbo) { Right = true; Left = false; } // Auto Aiming //=============================================== if (!Left && !Right) // Allow player strafe keys to override { #ifndef _JK2MP if (pVeh->m_pPilot->enemy) { vec3_t toEnemy; float toEnemyDistance; vec3_t actorRight; float actorRightDot; VectorSubtract(pVeh->m_pPilot->currentOrigin, pVeh->m_pPilot->enemy->currentOrigin, toEnemy); toEnemyDistance = VectorNormalize(toEnemy); AngleVectors(pVeh->m_pParentEntity->currentAngles, 0, actorRight, 0); actorRightDot = DotProduct(toEnemy, actorRight); if (fabsf(actorRightDot)>0.5f || pilotPS->weapon==WP_SABER) { Left = (actorRightDot>0.0f); Right = !Left; } else { Right = Left = false; } } else #endif if (pilotPS->weapon==WP_SABER && !Left && !Right) { Left = (WeaponPose==WPOSE_SABERLEFT); Right = !Left; } } if (Left) {// Attack Left switch(WeaponPose) { case WPOSE_BLASTER: Anim = BOTH_VT_ATL_G; break; case WPOSE_SABERLEFT: Anim = BOTH_VT_ATL_S; break; case WPOSE_SABERRIGHT: Anim = BOTH_VT_ATR_TO_L_S; break; default: assert(0); } } else if (Right) {// Attack Right switch(WeaponPose) { case WPOSE_BLASTER: Anim = BOTH_VT_ATR_G; break; case WPOSE_SABERLEFT: Anim = BOTH_VT_ATL_TO_R_S; break; case WPOSE_SABERRIGHT: Anim = BOTH_VT_ATR_S; break; default: assert(0); } } else {// Attack Ahead switch(WeaponPose) { case WPOSE_BLASTER: Anim = BOTH_VT_ATF_G; break; default: assert(0); } } } else if (Turbo) {// Kicked In Turbo iBlend = 50; iFlags = SETANIM_FLAG_OVERRIDE; Anim = BOTH_VT_TURBO; } else {// No Special Moves iBlend = 300; iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLDLESS; if (WeaponPose==WPOSE_NONE) { if (Walking) { Anim = BOTH_VT_WALK_FWD; } else if (Running) { Anim = BOTH_VT_RUN_FWD; } else { Anim = BOTH_VT_IDLE1;//(Q_irand(0,1)==0)?(BOTH_VT_IDLE):(BOTH_VT_IDLE1); } } else { switch(WeaponPose) { case WPOSE_BLASTER: Anim = BOTH_VT_IDLE_G; break; case WPOSE_SABERLEFT: Anim = BOTH_VT_IDLE_SL; break; case WPOSE_SABERRIGHT: Anim = BOTH_VT_IDLE_SR; break; default: assert(0); } } }
        portMissing("AnimateRiders", source: "oracle/codemp/game/AnimalNPC.c:620")
    }

    Vehicle_SetAnim(pilot!, SETANIM_BOTH, Anim, iFlags, iBlend)
}

//on the client this function will only set up the process command funcs
/// Source: oracle/codemp/game/AnimalNPC.c:857
func G_SetAnimalVehicleFunctions(_ pVehInfo: JKAMP.VehicleInfo) {
    pVehInfo.AnimateVehicle = VehicleInfoThunks.AnimateVehicle
    pVehInfo.AnimateRiders = VehicleInfoThunks.AnimateRiders
    //	pVehInfo->ValidateBoard				=		ValidateBoard;
    //	pVehInfo->SetParent					=		SetParent;
    //	pVehInfo->SetPilot					=		SetPilot;
    //	pVehInfo->AddPassenger				=		AddPassenger;
    //	pVehInfo->Animate					=		Animate;
    //	pVehInfo->Board						=		Board;
    //	pVehInfo->Eject						=		Eject;
    //	pVehInfo->EjectAll					=		EjectAll;
    //	pVehInfo->StartDeathDelay			=		StartDeathDelay;
    pVehInfo.DeathUpdate = VehicleInfoThunks.DeathUpdate
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
//this is a BG function too in MP so don't un-bg-compatibilify it -rww
/// Source: oracle/codemp/game/AnimalNPC.c:904
func G_CreateAnimalNPC(_ pVeh: inout JKAMP.Vehicle?, _ strAnimalType: String) {
    // Allocate the Vehicle.
    //these will remain on entities on the client once allocated because the pointer is
    //never stomped. on the server, however, when an ent is freed, the entity struct is
    //memset to 0, so this memory would be lost..
    G_AllocateVehicleObject(&pVeh)
    // Port-note: Raven's `memset(*pVeh, 0, sizeof(Vehicle_t))` runs over a size that is not the record's own, and a view's clear() takes the whole record.
    // Raven wrote: memset(*pVeh, 0, sizeof(Vehicle_t))
    portMissing("G_CreateAnimalNPC", source: "oracle/codemp/game/AnimalNPC.c:904")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Vehicle?' must be unwrapped to refer to member 'm_pVehicleInfo' of wrapped base type 'Vehicle'".
    // Raven wrote: (*pVeh)->m_pVehicleInfo = &g_vehicleInfo[BG_VehicleGetIndex( strAnimalType )]
    portMissing("G_CreateAnimalNPC", source: "oracle/codemp/game/AnimalNPC.c:904")
}

/// One static per function this file stores in a `VehicleInfo` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum VehicleInfoThunks {
    /// Source: oracle/codemp/game/AnimalNPC.c:620
    static let AnimateRiders: VehicleInfoAnimateRiders = { JKAMP_GameLogic.AnimateRiders(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/AnimalNPC.c:474
    static let AnimateVehicle: VehicleInfoAnimateVehicle = { JKAMP_GameLogic.AnimateVehicle(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/AnimalNPC.c:97
    static let DeathUpdate: VehicleInfoDeathUpdate = { JKAMP_GameLogic.DeathUpdate(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/AnimalNPC.c:168
    static let ProcessMoveCommands: VehicleInfoProcessMoveCommands = { JKAMP_GameLogic.ProcessMoveCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/AnimalNPC.c:338
    static let ProcessOrientCommands: VehicleInfoProcessOrientCommands = { JKAMP_GameLogic.ProcessOrientCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/AnimalNPC.c:151
    static let Update: VehicleInfoUpdate = { JKAMP_GameLogic.Update(JKAMP.Vehicle(handle: $0!), JKAMP.Usercmd(handle: $1!)) ? 1 : 0 }
}
