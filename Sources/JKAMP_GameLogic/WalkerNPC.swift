import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/WalkerNPC.c:53
// Raven wrote: #define currentAngles r . currentAngles
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/WalkerNPC.c:54
// Raven wrote: #define currentOrigin r . currentOrigin
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/WalkerNPC.c:55
// Raven wrote: #define mins r . mins
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/WalkerNPC.c:56
// Raven wrote: #define maxs r . maxs
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/WalkerNPC.c:57
extension JKAMP.PlayerState {
    /// Raven's `#define legsAnimTimer legsTimer`, an alias of the field, file-private to this stub.
    fileprivate var legsAnimTimer: Int32 {
        get { self.legsTimer }
        nonmutating set { self.legsTimer = newValue }
    }
}

/// Source: oracle/codemp/game/WalkerNPC.c:58
extension JKAMP.PlayerState {
    /// Raven's `#define torsoAnimTimer torsoTimer`, an alias of the field, file-private to this stub.
    fileprivate var torsoAnimTimer: Int32 {
        get { self.torsoTimer }
        nonmutating set { self.torsoTimer = newValue }
    }
}

/// Source: oracle/codemp/game/WalkerNPC.c:59
// Raven wrote: #define bool qboolean
// Swift has `Bool`, so a body writes it.

/// Source: oracle/codemp/game/WalkerNPC.c:60
// Raven wrote: #define false qfalse
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/WalkerNPC.c:61
// Raven wrote: #define true qtrue
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/WalkerNPC.c:63
// Raven wrote: #define sqrtf sqrt
private func sqrtf(_ x: Float) -> Float {
    x.squareRoot()
}

/// Source: oracle/codemp/game/WalkerNPC.c:64
// Raven wrote: #define Q_flrand flrand
// The module declares `Q_flrand` too, so a body writes `flrand` where Raven wrote `Q_flrand`.

/// Source: oracle/codemp/game/WalkerNPC.c:66
private let MOD_EXPLOSIVE = JKAMP.MOD_SUICIDE

/// Source: oracle/codemp/game/WalkerNPC.c:84
private func RegisterAssets(_ pVeh: JKAMP.Vehicle) {
    //atst uses turret weapon
    RegisterItem(BG_FindItemForWeapon(WP_TURRET)!)
    // PUT SOMETHING HERE...

    //call the standard RegisterAssets now
    g_vehicleInfo[VEHICLE_BASE].runRegisterAssets(pVeh)
}

// Board this Vehicle (get on). The first entity to board an empty vehicle becomes the Pilot.
/// Source: oracle/codemp/game/WalkerNPC.c:106
private func Board(_ pVeh: JKAMP.Vehicle, _ pEnt: JKAMP.BgEntity) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
    // Raven wrote: if ( !g_vehicleInfo[VEHICLE_BASE].Board( pVeh, pEnt ) ) return false
    portMissing("Board", source: "oracle/codemp/game/WalkerNPC.c:106")

    // Set the board wait time (they won't be able to do anything, including getting off, for this amount of time).
    pVeh.m_iBoarding = level.time + 1500

    return true
}

//MP RULE - ALL PROCESSMOVECOMMANDS FUNCTIONS MUST BE BG-COMPATIBLE!!!
//If you really need to violate this rule for SP, then use ifdefs.
//By BG-compatible, I mean no use of game-specific data - ONLY use
//stuff available in the MP bgEntity (in SP, the bgEntity is #defined
//as a gentity, but the MP-compatible access restrictions are based
//on the bgEntity structure in the MP codebase) -rww
// ProcessMoveCommands the Vehicle.
/// Source: oracle/codemp/game/WalkerNPC.c:129
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
    let parent: BgEntity? = pVeh.m_pParentEntity
    let parentPS: PlayerState? = parent!.playerState

    speedIdleDec = pVeh.m_pVehicleInfo!.decelIdle * pVeh.m_fTimeModifier
    speedMax = pVeh.m_pVehicleInfo!.speedMax

    speedIdle = pVeh.m_pVehicleInfo!.speedIdle
    speedIdleAccel = pVeh.m_pVehicleInfo!.accelIdle * pVeh.m_fTimeModifier
    speedMin = pVeh.m_pVehicleInfo!.speedMin

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

        pVeh.m_ucmd.rightmove = 0

        /*if ( !pVeh->m_pVehicleInfo->strafePerc
        || (!g_speederControlScheme->value && !parent->s.number) )
        {//if in a strafe-capable vehicle, clear strafing unless using alternate control scheme
        pVeh->m_ucmd.rightmove = 0;
        }*/
    }

    if parentPS != nil && parentPS!.electrifyTime > pm.cmd.serverTime {
        speedMax *= 0.5
    }

    fWalkSpeedMax = speedMax * 0.275
    if (pVeh.m_ucmd.buttons & BUTTON_WALKING) != 0 && parentPS!.speed > fWalkSpeedMax {
        parentPS!.speed = fWalkSpeedMax
    } else if parentPS!.speed > speedMax {
        parentPS!.speed = speedMax
    } else if parentPS!.speed < speedMin {
        parentPS!.speed = speedMin
    }

    if parentPS!.stats[STAT_HEALTH] <= 0 {
        //don't keep moving while you're dying!
        parentPS!.speed = 0
    }

    /********************************************************************************/
    /*	END Here is where we move the vehicle (forward or back or whatever). END	*/
    /********************************************************************************/
}

/// Source: oracle/codemp/game/WalkerNPC.c:254
func WalkerYawAdjust(_ pVeh: JKAMP.Vehicle, _ riderPS: JKAMP.PlayerState, _ parentPS: JKAMP.PlayerState) {
    var angDif: Float = AngleSubtract(pVeh.m_vOrientationVector[YAW], riderPS.viewangles[YAW])

    if parentPS.speed != 0 {
        var s: Float = parentPS.speed
        let maxDif: Float = pVeh.m_pVehicleInfo!.turningSpeed * 1.5

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

//MP RULE - ALL PROCESSORIENTCOMMANDS FUNCTIONS MUST BE BG-COMPATIBLE!!!
//If you really need to violate this rule for SP, then use ifdefs.
//By BG-compatible, I mean no use of game-specific data - ONLY use
//stuff available in the MP bgEntity (in SP, the bgEntity is #defined
//as a gentity, but the MP-compatible access restrictions are based
//on the bgEntity structure in the MP codebase) -rww
// ProcessOrientCommands the Vehicle.
/// Source: oracle/codemp/game/WalkerNPC.c:316
private func ProcessOrientCommands(_ pVeh: JKAMP.Vehicle) {
    /********************************************************************************/
    /*	BEGIN	Here is where make sure the vehicle is properly oriented.	BEGIN	*/
    /********************************************************************************/
    let speed: Float
    let parent: BgEntity? = pVeh.m_pParentEntity
    var parentPS: PlayerState?
    var riderPS: PlayerState?

    var rider: BgEntity? = nil
    if parent!.s.owner != ENTITYNUM_NONE {
        rider = PM_BGEntForNum(parent!.s.owner) //&g_entities[parent->r.ownerNum];
    }

    if rider == nil {
        rider = parent
    }

    parentPS = parent!.playerState
    riderPS = rider!.playerState

    speed = VectorLength(parentPS!.velocity)

    // If the player is the rider...
    if rider!.s.number < MAX_CLIENTS {
        //FIXME: use the vehicle's turning stat in this calc
        WalkerYawAdjust(pVeh, riderPS!, parentPS!)
        //FighterPitchAdjust(pVeh, riderPS, parentPS);
        pVeh.m_vOrientationVector[PITCH] = riderPS!.viewangles[PITCH]
    } else {
        var turnSpeed: Float = pVeh.m_pVehicleInfo!.turningSpeed
        if !pVeh.m_pVehicleInfo!.turnWhenStopped && parentPS!.speed == 0 {
            //can't turn when not moving
            //FIXME: or ramp up to max turnSpeed?
            turnSpeed = 0.0
        }
        if rider!.s.eType == ET_NPC {
            //help NPCs out some
            turnSpeed *= 2.0
            if parentPS!.speed > 200.0 {
                turnSpeed += turnSpeed * parentPS!.speed / 200.0 * 0.05
            }
        }
        turnSpeed *= pVeh.m_fTimeModifier

        //default control scheme: strafing turns, mouselook aims
        if pVeh.m_ucmd.rightmove < 0 {
            pVeh.m_vOrientationVector[YAW] += turnSpeed
        } else if pVeh.m_ucmd.rightmove > 0 {
            pVeh.m_vOrientationVector[YAW] -= turnSpeed
        }

        if pVeh.m_pVehicleInfo!.malfunctionArmorLevel != 0 && pVeh.m_iArmor <= pVeh.m_pVehicleInfo!.malfunctionArmorLevel {
            //damaged badly
        }
    }

    /********************************************************************************/
    /*	END	Here is where make sure the vehicle is properly oriented.	END			*/
    /********************************************************************************/
}

// This function makes sure that the vehicle is properly animated.
/// Source: oracle/codemp/game/WalkerNPC.c:415
private func AnimateVehicle(_ pVeh: JKAMP.Vehicle) {
    var Anim: animNumber_t = BOTH_STAND1
    var iFlags: Int32 = SETANIM_FLAG_NORMAL
    var iBlend: Int32 = 300
    let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
    let fSpeedPercToMax: Float

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

    // Following is redundant to g_vehicles.c
    //	if ( pVeh->m_iBoarding )
    //	{
    //		//we have no boarding anim
    //		if (pVeh->m_iBoarding < level.time)
    //		{ //we are on now
    //			pVeh->m_iBoarding = 0;
    //		}
    //		else
    //		{
    //			return;
    //		}
    //	}

    // Percentage of maximum speed relative to current speed.
    //float fSpeed = VectorLength( client->ps.velocity );
    fSpeedPercToMax = parent!.client!.ps.speed / pVeh.m_pVehicleInfo!.speedMax

    // If we're moving...
    if fSpeedPercToMax > 0.0 {
        let fYawDelta: Float

        iBlend = 300
        iFlags = SETANIM_FLAG_OVERRIDE
        fYawDelta = pVeh.m_vPrevOrientation[YAW] - pVeh.m_vOrientationVector[YAW]

        // NOTE: Mikes suggestion for fixing the stuttering walk (left/right) is to maintain the
        // current frame between animations. I have no clue how to do this and have to work on other
        // stuff so good luck to him :-p AReis

        // If we're walking (or our speed is less than .275%)...
        if (pVeh.m_ucmd.buttons & BUTTON_WALKING) != 0 || fSpeedPercToMax < 0.275 {
            // Make them lean if we're turning.
            /*if ( fYawDelta < -0.0001f )
            {
            Anim = BOTH_VT_WALK_FWD_L;
            }
            else if ( fYawDelta > 0.0001 )
            {
            Anim = BOTH_VT_WALK_FWD_R;
            }
            else*/
            do {
                Anim = BOTH_WALK1
            }
        } else {
            // otherwise we're running.
            // Make them lean if we're turning.
            /*if ( fYawDelta < -0.0001f )
            {
            Anim = BOTH_VT_RUN_FWD_L;
            }
            else if ( fYawDelta > 0.0001 )
            {
            Anim = BOTH_VT_RUN_FWD_R;
            }
            else*/
            do {
                Anim = BOTH_RUN1
            }
        }
    } else {
        // Going in reverse...
        if fSpeedPercToMax < -0.018 {
            iFlags = SETANIM_FLAG_NORMAL
            Anim = BOTH_WALKBACK1
            iBlend = 500
        } else {
            //int iChance = Q_irand( 0, 20000 );

            // Every once in a while buck or do a different idle...
            iFlags = SETANIM_FLAG_NORMAL | SETANIM_FLAG_RESTART | SETANIM_FLAG_HOLD
            iBlend = 600
            if parent!.client!.ps.m_iVehicleNum != 0 {
                //occupado
                Anim = BOTH_STAND1
            } else {
                //wide open for you, baby
                Anim = BOTH_STAND2
            }
        }
    }

    Vehicle_SetAnim(parent!, SETANIM_LEGS, Anim, iFlags, iBlend)
}

//on the client this function will only set up the process command funcs
/// Source: oracle/codemp/game/WalkerNPC.c:547
func G_SetWalkerVehicleFunctions(_ pVehInfo: JKAMP.VehicleInfo) {
    pVehInfo.AnimateVehicle = VehicleInfoThunks.AnimateVehicle
    //	pVehInfo->AnimateRiders				=		AnimateRiders;
    //	pVehInfo->ValidateBoard				=		ValidateBoard;
    //	pVehInfo->SetParent					=		SetParent;
    //	pVehInfo->SetPilot					=		SetPilot;
    //	pVehInfo->AddPassenger				=		AddPassenger;
    //	pVehInfo->Animate					=		Animate;
    pVehInfo.Board = VehicleInfoThunks.Board
    //	pVehInfo->Eject						=		Eject;
    //	pVehInfo->EjectAll					=		EjectAll;
    //	pVehInfo->StartDeathDelay			=		StartDeathDelay;
    //	pVehInfo->DeathUpdate				=		DeathUpdate;
    pVehInfo.RegisterAssets = VehicleInfoThunks.RegisterAssets
    //	pVehInfo->Initialize				=		Initialize;
    //	pVehInfo->Update					=		Update;
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
/// Source: oracle/codemp/game/WalkerNPC.c:594
func G_CreateWalkerNPC(_ pVeh: inout JKAMP.Vehicle?, _ strAnimalType: String) {
    // Allocate the Vehicle.
    //these will remain on entities on the client once allocated because the pointer is
    //never stomped. on the server, however, when an ent is freed, the entity struct is
    //memset to 0, so this memory would be lost..
    G_AllocateVehicleObject(&pVeh)
    // Port-note: Raven's `memset(*pVeh, 0, sizeof(Vehicle_t))` runs over a size that is not the record's own, and a view's clear() takes the whole record.
    // Raven wrote: memset(*pVeh, 0, sizeof(Vehicle_t))
    portMissing("G_CreateWalkerNPC", source: "oracle/codemp/game/WalkerNPC.c:594")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Vehicle?' must be unwrapped to refer to member 'm_pVehicleInfo' of wrapped base type 'Vehicle'".
    // Raven wrote: (*pVeh)->m_pVehicleInfo = &g_vehicleInfo[BG_VehicleGetIndex( strAnimalType )]
    portMissing("G_CreateWalkerNPC", source: "oracle/codemp/game/WalkerNPC.c:594")
}

/// One static per function this file stores in a `VehicleInfo` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum VehicleInfoThunks {
    /// Source: oracle/codemp/game/WalkerNPC.c:415
    static let AnimateVehicle: VehicleInfoAnimateVehicle = { JKAMP_GameLogic.AnimateVehicle(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/WalkerNPC.c:106
    static let Board: VehicleInfoBoard = { JKAMP_GameLogic.Board(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/WalkerNPC.c:129
    static let ProcessMoveCommands: VehicleInfoProcessMoveCommands = { JKAMP_GameLogic.ProcessMoveCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/WalkerNPC.c:316
    static let ProcessOrientCommands: VehicleInfoProcessOrientCommands = { JKAMP_GameLogic.ProcessOrientCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/WalkerNPC.c:84
    static let RegisterAssets: VehicleInfoRegisterAssets = { JKAMP_GameLogic.RegisterAssets(JKAMP.Vehicle(handle: $0!)) }
}
