import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
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
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/AnimalNPC.c:66
private let MOD_EXPLOSIVE = JKAMP.MOD_SUICIDE

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

    //FIXME: pass in ucmd?  Not sure if this is reliable...
    curTime = pm.cmd.serverTime


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
public func AnimalProcessOri(_ pVeh: JKAMP.Vehicle) {
    ProcessOrientCommands(pVeh)
}

//on the client this function will only set up the process command funcs
/// Source: oracle/codemp/game/AnimalNPC.c:857
public func G_SetAnimalVehicleFunctions(_ pVehInfo: JKAMP.VehicleInfo) {
    //	pVehInfo->ValidateBoard				=		ValidateBoard;
    //	pVehInfo->SetParent					=		SetParent;
    //	pVehInfo->SetPilot					=		SetPilot;
    //	pVehInfo->AddPassenger				=		AddPassenger;
    //	pVehInfo->Animate					=		Animate;
    //	pVehInfo->Board						=		Board;
    //	pVehInfo->Eject						=		Eject;
    //	pVehInfo->EjectAll					=		EjectAll;
    //	pVehInfo->StartDeathDelay			=		StartDeathDelay;
    //	pVehInfo->RegisterAssets			=		RegisterAssets;
    //	pVehInfo->Initialize				=		Initialize;
    //	pVehInfo->UpdateRider				=		UpdateRider;
    pVehInfo.ProcessMoveCommands = VehicleInfoThunks.ProcessMoveCommands
    pVehInfo.ProcessOrientCommands = VehicleInfoThunks.ProcessOrientCommands

    pVehInfo.AttachRiders = VehicleInfoThunks.AttachRidersGeneric
    //	pVehInfo->AttachRiders				=		AttachRiders;
    //	pVehInfo->Ghost						=		Ghost;
    //	pVehInfo->UnGhost					=		UnGhost;
    //	pVehInfo->Inhabited					=		Inhabited;
}

// Create/Allocate a new Animal Vehicle (initializing it as well).
//this is a BG function too in MP so don't un-bg-compatibilify it -rww
/// Source: oracle/codemp/game/AnimalNPC.c:904
public func G_CreateAnimalNPC(_ pVeh: inout JKAMP.Vehicle?, _ strAnimalType: String) {
    // Allocate the Vehicle.
    //these will remain on entities on the client once allocated because the pointer is
    //never stomped. on the server, however, when an ent is freed, the entity struct is
    //memset to 0, so this memory would be lost..
    if pVeh == nil {
        //only allocate a new one if we really have to
        (pVeh) = Vehicle(BG_Alloc(Int32(Vehicle.byteCount)))
    }
    pVeh!.clear()
    pVeh!.m_pVehicleInfo = g_vehicleInfo[BG_VehicleGetIndex(strAnimalType)]
}

/// One static per function this file stores in a `VehicleInfo` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum VehicleInfoThunks {
    /// Source: oracle/codemp/game/bg_vehicleLoad.c:1643
    static let AttachRidersGeneric: VehicleInfoAttachRiders = { JKAMP_BG.AttachRidersGeneric(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/AnimalNPC.c:168
    static let ProcessMoveCommands: VehicleInfoProcessMoveCommands = { JKAMP_CGameLogic.ProcessMoveCommands(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/AnimalNPC.c:338
    static let ProcessOrientCommands: VehicleInfoProcessOrientCommands = { JKAMP_CGameLogic.ProcessOrientCommands(JKAMP.Vehicle(handle: $0!)) }
}
