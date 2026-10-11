import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/SpeederNPC.c:54
// Raven wrote: #define currentAngles r . currentAngles
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/SpeederNPC.c:55
// Raven wrote: #define currentOrigin r . currentOrigin
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/SpeederNPC.c:56
// Raven wrote: #define mins r . mins
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/SpeederNPC.c:57
// Raven wrote: #define maxs r . maxs
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/SpeederNPC.c:58
extension JKAMP.PlayerState {
    /// Raven's `#define legsAnimTimer legsTimer`, an alias of the field, file-private to this stub.
    fileprivate var legsAnimTimer: Int32 {
        get { self.legsTimer }
        nonmutating set { self.legsTimer = newValue }
    }
}

/// Source: oracle/codemp/game/SpeederNPC.c:59
extension JKAMP.PlayerState {
    /// Raven's `#define torsoAnimTimer torsoTimer`, an alias of the field, file-private to this stub.
    fileprivate var torsoAnimTimer: Int32 {
        get { self.torsoTimer }
        nonmutating set { self.torsoTimer = newValue }
    }
}

/// Source: oracle/codemp/game/SpeederNPC.c:60
// Raven wrote: #define bool qboolean
// Swift has `Bool`, so a body writes it.

/// Source: oracle/codemp/game/SpeederNPC.c:61
// Raven wrote: #define false qfalse
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/SpeederNPC.c:62
// Raven wrote: #define true qtrue
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/SpeederNPC.c:64
// Raven wrote: #define sqrtf sqrt
private func sqrtf(_ x: Float) -> Float {
    x.squareRoot()
}

/// Source: oracle/codemp/game/SpeederNPC.c:65
// Raven wrote: #define Q_flrand flrand
// The module declares `Q_flrand` too, so a body writes `flrand` where Raven wrote `Q_flrand`.

/// Source: oracle/codemp/game/SpeederNPC.c:67
private let MOD_EXPLOSIVE = JKAMP.MOD_SUICIDE

/// Source: oracle/codemp/game/SpeederNPC.c:97
let STRAFERAM_DURATION = 8 as Int32

/// Source: oracle/codemp/game/SpeederNPC.c:98
let STRAFERAM_ANGLE = 8 as Int32

/// Source: oracle/codemp/game/SpeederNPC.c:140
func VEH_StartStrafeRam(_ pVeh: JKAMP.Vehicle, _ Right: Bool, _ Duration: Int32) -> Bool {
    return false
}

// Like a think or move command, this updates various vehicle properties.
/// Source: oracle/codemp/game/SpeederNPC.c:149
private func Update(_ pVeh: JKAMP.Vehicle, _ pUcmd: JKAMP.Usercmd) -> Bool {
    if !g_vehicleInfo[VEHICLE_BASE].runUpdate(pVeh, pUcmd) {
        return false
    }

    // See whether this vehicle should be exploding.
    if pVeh.m_iDieTime != 0 {
        pVeh.m_pVehicleInfo!.runDeathUpdate(pVeh)
    }

    // Update move direction.


    // Check For A Strafe Ram
    //------------------------
    // Started A Strafe
    //------------------

    // Ended A Strafe
    //----------------
    // If It Was A Short Burst, Start The Strafe Ram
    //-----------------------------------------------

    // Otherwise, Clear The Timer
    //----------------------------

    // If Currently In A StrafeRam, Check To See If It Is Done (Timed Out)
    //---------------------------------------------------------------------


    // Exhaust Effects Start And Stop When The Accelerator Is Pressed
    //----------------------------------------------------------------
    // Start It On Each Exhaust Bolt
    //-------------------------------

    // Stop It On Each Exhaust Bolt
    //------------------------------



    // Armor Gone Effects (Fire)
    //---------------------------

    return true
}

//MP RULE - ALL PROCESSMOVECOMMANDS FUNCTIONS MUST BE BG-COMPATIBLE!!!
//If you really need to violate this rule for SP, then use ifdefs.
//By BG-compatible, I mean no use of game-specific data - ONLY use
//stuff available in the MP bgEntity (in SP, the bgEntity is #defined
//as a gentity, but the MP-compatible access restrictions are based
//on the bgEntity structure in the MP codebase) -rww
// ProcessMoveCommands the Vehicle.
/// Source: oracle/codemp/game/SpeederNPC.c:278
private func ProcessMoveCommands(_ pVeh: JKAMP.Vehicle) {
    /************************************************************************************/
    /*	BEGIN	Here is where we move the vehicle (forward or back or whatever). BEGIN	*/
    /************************************************************************************/
    //Client sets ucmds and such for speed alterations
    var speedInc: Float = 0
    var speedIdleDec: Float = 0
    var speedIdle: Float = 0
    var speedIdleAccel: Float = 0
    var speedMin: Float = 0
    var speedMax: Float = 0
    var parentPS: PlayerState?
    var pilotPS: PlayerState? = nil
    var curTime: Int32 = 0

    parentPS = pVeh.m_pParentEntity!.playerState
    if pVeh.m_pPilot != nil {
        pilotPS = pVeh.m_pPilot!.playerState
    }


    // If we're flying, make us accelerate at 40% (about half) acceleration rate, and restore the pitch
    // to origin (straight) position (at 5% increments).
    if (pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_FLYING))) != 0 {
        speedInc = pVeh.m_pVehicleInfo!.acceleration * pVeh.m_fTimeModifier * 0.4
    } else if parentPS!.m_iVehicleNum == 0 {
        //drifts to a stop
        speedInc = 0
        //pVeh->m_ucmd.forwardmove = 127;
    } else {
        speedInc = pVeh.m_pVehicleInfo!.acceleration * pVeh.m_fTimeModifier
    }
    speedIdleDec = pVeh.m_pVehicleInfo!.decelIdle * pVeh.m_fTimeModifier

    curTime = level.time
    //FIXME: pass in ucmd?  Not sure if this is reliable...



    if (pVeh.m_pPilot != nil && (pVeh.m_ucmd.buttons & BUTTON_ALT_ATTACK) != 0 && pVeh.m_pVehicleInfo!.turboSpeed != 0) {
        if (parentPS != nil && parentPS!.electrifyTime > curTime) || (pVeh.m_pPilot!.playerState != nil && (pVeh.m_pPilot!.playerState!.weapon == WP_MELEE || (pVeh.m_pPilot!.playerState!.weapon == WP_SABER && BG_SabersOff(pVeh.m_pPilot!.playerState!)))) {
            if (curTime - pVeh.m_iTurboTime) > pVeh.m_pVehicleInfo!.turboRecharge {
                pVeh.m_iTurboTime = (curTime + pVeh.m_pVehicleInfo!.turboDuration)
                if pVeh.m_pVehicleInfo!.iTurboStartFX != 0 {
                    var i: Int32 = 0
                    i = 0
                    while (i < MAX_VEHICLE_EXHAUSTS && pVeh.m_iExhaustTag[i] != -1) {
                        if pVeh.m_pParentEntity != nil && pVeh.m_pParentEntity!.ghoul2 != nil && pVeh.m_pParentEntity!.playerState != nil {
                            //fine, I'll use a tempent for this, but only because it's played only once at the start of a turbo.
                            var boltOrg = vec3_t()
                            var boltDir = vec3_t()
                            // Raven's record lives to the end of his block, so the block is the closure.
                            MdxaBone.scratch { boltMatrix in

                                boltDir = vec3_t(0.0, pVeh.m_pParentEntity!.playerState!.viewangles[YAW], 0.0)

                                trap_G2API_GetBoltMatrix(pVeh.m_pParentEntity!.ghoul2, 0, pVeh.m_iExhaustTag[i], boltMatrix, boltDir, pVeh.m_pParentEntity!.playerState!.origin, level.time, nil, &pVeh.m_pParentEntity!.modelScale)
                                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltOrg)
                                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltDir)
                                G_PlayEffectID(pVeh.m_pVehicleInfo!.iTurboStartFX, boltOrg, boltDir)
                            }
                        }
                        i += 1
                    }
                }
                parentPS!.speed = pVeh.m_pVehicleInfo!.turboSpeed // Instantly Jump To Turbo Speed
            }
        }
    }

    // Slide Breaking
    if (pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_SLIDEBREAKING))) != 0 {
        if pVeh.m_ucmd.forwardmove >= 0 {
            pVeh.m_ulFlags &= ~UInt(bitPattern: Int(VEH_SLIDEBREAKING))
        }
        parentPS!.speed = 0
    } else if (curTime > pVeh.m_iTurboTime) && !((pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_FLYING))) != 0) && pVeh.m_ucmd.forwardmove < 0 && abs(pVeh.m_vOrientationVector[ROLL]) > 25.0 {
        pVeh.m_ulFlags |= UInt(bitPattern: Int(VEH_SLIDEBREAKING))
    }


    if curTime < pVeh.m_iTurboTime {
        speedMax = pVeh.m_pVehicleInfo!.turboSpeed
        if parentPS != nil {
            parentPS!.eFlags |= EF_JETPACK_ACTIVE
        }
    } else {
        speedMax = pVeh.m_pVehicleInfo!.speedMax
        if parentPS != nil {
            parentPS!.eFlags &= ~EF_JETPACK_ACTIVE
        }
    }


    speedIdle = pVeh.m_pVehicleInfo!.speedIdle
    speedIdleAccel = pVeh.m_pVehicleInfo!.accelIdle * pVeh.m_fTimeModifier
    speedMin = pVeh.m_pVehicleInfo!.speedMin

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
        if pVeh.m_pVehicleInfo!.strafePerc == 0
            || (0 != 0 && pVeh.m_pParentEntity!.s.number < MAX_CLIENTS) {
            //if in a strafe-capable vehicle, clear strafing unless using alternate control scheme
            //pVeh->m_ucmd.rightmove = 0;
        }
    }

    if parentPS!.speed > speedMax {
        parentPS!.speed = speedMax
    } else if parentPS!.speed < speedMin {
        parentPS!.speed = speedMin
    }

    if parentPS != nil && parentPS!.electrifyTime > curTime {
        parentPS!.speed *= (pVeh.m_fTimeModifier / 60.0)
    }


    /********************************************************************************/
    /*	END Here is where we move the vehicle (forward or back or whatever). END	*/
    /********************************************************************************/
}

/// Source: oracle/codemp/game/SpeederNPC.c:505
private func ProcessOrientCommands(_ pVeh: JKAMP.Vehicle) {
    /********************************************************************************/
    /*	BEGIN	Here is where make sure the vehicle is properly oriented.	BEGIN	*/
    /********************************************************************************/
    var riderPS: PlayerState?
    var parentPS: PlayerState?

    var angDif: Float

    if pVeh.m_pPilot != nil {
        riderPS = pVeh.m_pPilot!.playerState
    } else {
        riderPS = pVeh.m_pParentEntity!.playerState
    }
    parentPS = pVeh.m_pParentEntity!.playerState

    //pVeh->m_vOrientation[YAW] = 0.0f;//riderPS->viewangles[YAW];
    angDif = AngleSubtract(pVeh.m_vOrientationVector[YAW], riderPS!.viewangles[YAW])
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

        if parentPS!.electrifyTime > pm.cmd.serverTime {
            //do some crazy stuff
            pVeh.m_vOrientationVector[YAW] += (sin(pm.cmd.serverTime / 1000.0) * 3.0) * pVeh.m_fTimeModifier
        }
    }


    // Any ability to change orientation?

    /********************************************************************************/
    /*	END	Here is where make sure the vehicle is properly oriented.	END			*/
    /********************************************************************************/
}

// This function makes sure that the vehicle is properly animated.
/// Source: oracle/codemp/game/SpeederNPC.c:608
private func AnimateVehicle(_ pVeh: JKAMP.Vehicle) {
}

//NOTE NOTE NOTE NOTE NOTE NOTE
//I want to keep this function BG too, because it's fairly generic already, and it
//would be nice to have proper prediction of animations. -rww
// This function makes sure that the rider's in this vehicle are properly animated.
/// Source: oracle/codemp/game/SpeederNPC.c:630
private func AnimateRiders(_ pVeh: JKAMP.Vehicle) {
    var Anim: animNumber_t = BOTH_VS_IDLE
    let fSpeedPercToMax: Float
    var iFlags: Int32 = SETANIM_FLAG_NORMAL
    var iBlend: Int32 = 300
    var pilotPS: PlayerState?
    var parentPS: PlayerState?
    let curTime: Int32


    // Boarding animation.
    if pVeh.m_iBoarding != 0 {
        // We've just started moarding, set the amount of time it will take to finish moarding.
        if pVeh.m_iBoarding < 0 {
            let iAnimLen: Int32

            // Boarding from left...
            if pVeh.m_iBoarding == -1 {
                Anim = BOTH_VS_MOUNT_L
            } else if pVeh.m_iBoarding == -2 {
                Anim = BOTH_VS_MOUNT_R
            } else if pVeh.m_iBoarding == -3 {
                Anim = BOTH_VS_MOUNTJUMP_L
            } else if pVeh.m_iBoarding == VEH_MOUNT_THROW_LEFT {
                iBlend = 0
                Anim = BOTH_VS_MOUNTTHROW_R
            } else if pVeh.m_iBoarding == VEH_MOUNT_THROW_RIGHT {
                iBlend = 0
                Anim = BOTH_VS_MOUNTTHROW_L
            }

            // Set the delay time (which happens to be the time it takes for the animation to complete).
            // NOTE: Here I made it so the delay is actually 40% (0.4f) of the animation time.
            iAnimLen = Int32(BG_AnimLength(pVeh.m_pPilot!.localAnimIndex, Anim) * 0.4)
            pVeh.m_iBoarding = BG_GetTime() + iAnimLen
            // Set the animation, which won't be interrupted until it's completed.
            // TODO: But what if he's killed? Should the animation remain persistant???
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD

            BG_SetAnim(pVeh.m_pPilot!.playerState!, bgAllAnims[pVeh.m_pPilot!.localAnimIndex].animsSlots, SETANIM_BOTH, Anim, iFlags, iBlend)
        }



        // Kill Him
        //----------

        // Compute THe Throw Direction As Backwards From The Vehicle's Velocity
        //----------------------------------------------------------------------

        // Now Throw Him Out
        //-------------------

        return
    }

    if 1 != 0 {
        return
    }

    pilotPS = pVeh.m_pPilot!.playerState
    parentPS = pVeh.m_pPilot!.playerState

    curTime = level.time
    //FIXME: pass in ucmd?  Not sure if this is reliable...

    // Percentage of maximum speed relative to current speed.
    fSpeedPercToMax = parentPS!.speed / pVeh.m_pVehicleInfo!.speedMax

    // Going in reverse...
    if pVeh.m_ucmd.forwardmove < 0 && !((pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_SLIDEBREAKING))) != 0) {
        Anim = BOTH_VS_REV
        iBlend = 500
    } else {
        let HasWeapon: Bool = ((pilotPS!.weapon != WP_NONE) && (pilotPS!.weapon != WP_MELEE))
        let Attacking: Bool = (HasWeapon && ((pVeh.m_ucmd.buttons & BUTTON_ATTACK) != 0))
        let Flying: Bool = false
        let Crashing: Bool = false
        var Right: Bool = (pVeh.m_ucmd.rightmove > 0)
        var Left: Bool = (pVeh.m_ucmd.rightmove < 0)
        let Turbo: Bool = (curTime < pVeh.m_iTurboTime)
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
            if (pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_SABERINLEFTHAND))) != 0 && pilotPS!.torsoAnim == BOTH_VS_ATL_TO_R_S {
                pVeh.m_ulFlags &= ~UInt(bitPattern: Int(VEH_SABERINLEFTHAND))
            }
            if !((pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_SABERINLEFTHAND))) != 0) && pilotPS!.torsoAnim == BOTH_VS_ATR_TO_L_S {
                pVeh.m_ulFlags |= UInt(bitPattern: Int(VEH_SABERINLEFTHAND))
            }
            WeaponPose = (pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_SABERINLEFTHAND))) != 0 ? (WPOSE_SABERLEFT) : (WPOSE_SABERRIGHT)
        }


        if Attacking && WeaponPose != 0 {
            // Attack!
            iBlend = 100
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD | SETANIM_FLAG_RESTART

            // Auto Aiming
            //===============================================
            if !Left && !Right {
                // Allow player strafe keys to override
                if pilotPS!.weapon == WP_SABER && !Left && !Right {
                    Left = (WeaponPose == WPOSE_SABERLEFT)
                    Right = !Left
                }
            }


            if Left {
                // Attack Left
                switch WeaponPose {
                case WPOSE_BLASTER:
                    Anim = BOTH_VS_ATL_G
                case WPOSE_SABERLEFT:
                    Anim = BOTH_VS_ATL_S
                case WPOSE_SABERRIGHT:
                    Anim = BOTH_VS_ATR_TO_L_S
                default:
                    break
                }
            } else if Right {
                // Attack Right
                switch WeaponPose {
                case WPOSE_BLASTER:
                    Anim = BOTH_VS_ATR_G
                case WPOSE_SABERLEFT:
                    Anim = BOTH_VS_ATL_TO_R_S
                case WPOSE_SABERRIGHT:
                    Anim = BOTH_VS_ATR_S
                default:
                    break
                }
            } else {
                // Attack Ahead
                switch WeaponPose {
                case WPOSE_BLASTER:
                    Anim = BOTH_VS_ATF_G
                default:
                    break
                }
            }

        } else if Left && (pVeh.m_ucmd.buttons & BUTTON_USE) != 0 {
            // Look To The Left Behind
            iBlend = 400
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD
            switch WeaponPose {
            case WPOSE_SABERLEFT:
                Anim = BOTH_VS_IDLE_SL
            case WPOSE_SABERRIGHT:
                Anim = BOTH_VS_IDLE_SR
            default:
                Anim = BOTH_VS_LOOKLEFT
            }
        } else if Right && (pVeh.m_ucmd.buttons & BUTTON_USE) != 0 {
            // Look To The Right Behind
            iBlend = 400
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD
            switch WeaponPose {
            case WPOSE_SABERLEFT:
                Anim = BOTH_VS_IDLE_SL
            case WPOSE_SABERRIGHT:
                Anim = BOTH_VS_IDLE_SR
            default:
                Anim = BOTH_VS_LOOKRIGHT
            }
        } else if Turbo {
            // Kicked In Turbo
            iBlend = 50
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLDLESS
            Anim = BOTH_VS_TURBO
        } else if Flying {
            // Off the ground in a jump
            iBlend = 800
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD

            switch WeaponPose {
            case WPOSE_NONE:
                Anim = BOTH_VS_AIR
            case WPOSE_BLASTER:
                Anim = BOTH_VS_AIR_G
            case WPOSE_SABERLEFT:
                Anim = BOTH_VS_AIR_SL
            case WPOSE_SABERRIGHT:
                Anim = BOTH_VS_AIR_SR
            default:
                break
            }
        } else if Crashing {
            // Hit the ground!
            iBlend = 100
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLDLESS

            switch WeaponPose {
            case WPOSE_NONE:
                Anim = BOTH_VS_LAND
            case WPOSE_BLASTER:
                Anim = BOTH_VS_LAND_G
            case WPOSE_SABERLEFT:
                Anim = BOTH_VS_LAND_SL
            case WPOSE_SABERRIGHT:
                Anim = BOTH_VS_LAND_SR
            default:
                break
            }
        } else {
            // No Special Moves
            iBlend = 300
            iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLDLESS

            if pVeh.m_vOrientationVector[ROLL] <= -20 {
                // Lean Left
                switch WeaponPose {
                case WPOSE_NONE:
                    Anim = BOTH_VS_LEANL
                case WPOSE_BLASTER:
                    Anim = BOTH_VS_LEANL_G
                case WPOSE_SABERLEFT:
                    Anim = BOTH_VS_LEANL_SL
                case WPOSE_SABERRIGHT:
                    Anim = BOTH_VS_LEANL_SR
                default:
                    break
                }
            } else if pVeh.m_vOrientationVector[ROLL] >= 20 {
                // Lean Right
                switch WeaponPose {
                case WPOSE_NONE:
                    Anim = BOTH_VS_LEANR
                case WPOSE_BLASTER:
                    Anim = BOTH_VS_LEANR_G
                case WPOSE_SABERLEFT:
                    Anim = BOTH_VS_LEANR_SL
                case WPOSE_SABERRIGHT:
                    Anim = BOTH_VS_LEANR_SR
                default:
                    break
                }
            } else {
                // No Lean
                switch WeaponPose {
                case WPOSE_NONE:
                    Anim = BOTH_VS_IDLE
                case WPOSE_BLASTER:
                    Anim = BOTH_VS_IDLE_G
                case WPOSE_SABERLEFT:
                    Anim = BOTH_VS_IDLE_SL
                case WPOSE_SABERRIGHT:
                    Anim = BOTH_VS_IDLE_SR
                default:
                    break
                }
            }
        } // No Special Moves
    }

    iFlags &= ~SETANIM_FLAG_OVERRIDE
    if pVeh.m_pPilot!.playerState!.torsoAnim == Anim {
        pVeh.m_pPilot!.playerState!.torsoTimer = BG_AnimLength(pVeh.m_pPilot!.localAnimIndex, Anim)
    }
    if pVeh.m_pPilot!.playerState!.legsAnim == Anim {
        pVeh.m_pPilot!.playerState!.legsTimer = BG_AnimLength(pVeh.m_pPilot!.localAnimIndex, Anim)
    }
    BG_SetAnim(pVeh.m_pPilot!.playerState!, bgAllAnims[pVeh.m_pPilot!.localAnimIndex].animsSlots, SETANIM_BOTH, Anim, iFlags | SETANIM_FLAG_HOLD, iBlend)
}

/// Source: oracle/codemp/game/SpeederNPC.c:1044
func G_SetSpeederVehicleFunctions(_ pVehInfo: JKAMP.VehicleInfo) {
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
    //	pVehInfo->DeathUpdate				=		DeathUpdate;
    //	pVehInfo->RegisterAssets			=		RegisterAssets;
    //	pVehInfo->Initialize				=		Initialize;
    pVehInfo.Update = VehicleInfoThunks.Update
    //	pVehInfo->UpdateRider				=		UpdateRider;

    //shared
    pVehInfo.ProcessMoveCommands = VehicleInfoThunks.ProcessMoveCommands
    pVehInfo.ProcessOrientCommands = VehicleInfoThunks.ProcessOrientCommands

    //	pVehInfo->AttachRiders				=		AttachRiders;
    //	pVehInfo->Ghost						=		Ghost;
    //	pVehInfo->UnGhost					=		UnGhost;
    //	pVehInfo->Inhabited					=		Inhabited;
}

// Create/Allocate a new Animal Vehicle (initializing it as well).
/// Source: oracle/codemp/game/SpeederNPC.c:1092
func G_CreateSpeederNPC(_ pVeh: inout JKAMP.Vehicle?, _ strType: String) {
    //these will remain on entities on the client once allocated because the pointer is
    //never stomped. on the server, however, when an ent is freed, the entity struct is
    //memset to 0, so this memory would be lost..
    G_AllocateVehicleObject(&pVeh)
    pVeh!.clear()
    pVeh!.m_pVehicleInfo = g_vehicleInfo[BG_VehicleGetIndex(strType)]
    // Allocate the Vehicle.
}

/// One static per function this file stores in a `VehicleInfo` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum VehicleInfoThunks {
    /// Source: oracle/codemp/game/SpeederNPC.c:630
    static let AnimateRiders: VehicleInfoAnimateRiders = { JKAMP_GameLogic.AnimateRiders(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/SpeederNPC.c:608
    static let AnimateVehicle: VehicleInfoAnimateVehicle = { JKAMP_GameLogic.AnimateVehicle(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/SpeederNPC.c:278
    static let ProcessMoveCommands: VehicleInfoProcessMoveCommands = { JKAMP_GameLogic.ProcessMoveCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/SpeederNPC.c:505
    static let ProcessOrientCommands: VehicleInfoProcessOrientCommands = { JKAMP_GameLogic.ProcessOrientCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/SpeederNPC.c:149
    static let Update: VehicleInfoUpdate = { JKAMP_GameLogic.Update(JKAMP.Vehicle(handle: $0!), JKAMP.Usercmd(handle: $1!)) ? 1 : 0 }
}
