import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_vehicles.c:24
// Raven wrote: #define currentAngles r . currentAngles
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/g_vehicles.c:25
// Raven wrote: #define currentOrigin r . currentOrigin
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/g_vehicles.c:26
// Raven wrote: #define mins r . mins
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/g_vehicles.c:27
// Raven wrote: #define maxs r . maxs
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/g_vehicles.c:28
extension JKAMP.PlayerState {
    /// Raven's `#define legsAnimTimer legsTimer`, an alias of the field, file-private to this stub.
    fileprivate var legsAnimTimer: Int32 {
        get { self.legsTimer }
        nonmutating set { self.legsTimer = newValue }
    }
}

/// Source: oracle/codemp/game/g_vehicles.c:29
extension JKAMP.PlayerState {
    /// Raven's `#define torsoAnimTimer torsoTimer`, an alias of the field, file-private to this stub.
    fileprivate var torsoAnimTimer: Int32 {
        get { self.torsoTimer }
        nonmutating set { self.torsoTimer = newValue }
    }
}

/// Source: oracle/codemp/game/g_vehicles.c:30
// Raven wrote: #define bool qboolean
// Swift has `Bool`, so a body writes it.

/// Source: oracle/codemp/game/g_vehicles.c:31
// Raven wrote: #define false qfalse
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/g_vehicles.c:32
// Raven wrote: #define true qtrue
// Swift has the keyword, so a body writes it as is.

/// Source: oracle/codemp/game/g_vehicles.c:34
// Raven wrote: #define sqrtf sqrt
private func sqrtf(_ x: Float) -> Float {
    x.squareRoot()
}

/// Source: oracle/codemp/game/g_vehicles.c:36
private let MOD_EXPLOSIVE = JKAMP.MOD_SUICIDE

/// Source: oracle/codemp/game/g_vehicles.c:2927
private let TURN_ON = 0x00000000 as Int32

/// Source: oracle/codemp/game/g_vehicles.c:2928
private let TURN_OFF = 0x00000100 as Int32

/// Source: oracle/codemp/game/g_vehicles.c:91
func Vehicle_SetAnim(_ ent: Entity, _ setAnimParts: Int32, _ anim: Int32, _ setAnimFlags: Int32, _ iBlend: Int32) {
    BG_SetAnim(ent.client!.ps, bgAllAnims[ent.localAnimIndex].animsSlots, setAnimParts, anim, setAnimFlags, iBlend)
    ent.s.legsAnim = ent.client!.ps.legsAnim
}

/// Source: oracle/codemp/game/g_vehicles.c:102
func G_VehicleTrace(_ results: JKAMP.Trace, _ start: JKAShared.vec3_t, _ tMins: JKAShared.vec3_t, _ tMaxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ passEntityNum: Int32, _ contentmask: Int32) {
    trap_Trace(results, start, tMins, tMaxs, end, passEntityNum, contentmask)
}

/// Source: oracle/codemp/game/g_vehicles.c:111
func G_IsRidingVehicle(_ pEnt: Entity) -> JKAMP.Vehicle? {
    let ent: Entity? = pEnt

    if ent != nil && ent!.client != nil && ent!.client!.NPC_class != CLASS_VEHICLE && ent!.s.m_iVehicleNum != 0 {
        return g_entities[ent!.s.m_iVehicleNum].m_pVehicle
    }
    return nil
}

/// Source: oracle/codemp/game/g_vehicles.c:124
func G_CanJumpToEnemyVeh(_ pVeh: JKAMP.Vehicle, _ pUcmd: JKAMP.Usercmd) -> Float {
    // If There Is An Enemy And We Are At The Same Z Height
    //------------------------------------------------------


    // If The Enemy Is Riding Another Vehicle
    //----------------------------------------

    // If He Is Close Enough And Going The Same Speed
    //------------------------------------------------
    // If He Is Either To The Left Or Right Of Me
    //--------------------------------------------
    // If We Are Both Going About The Same Direction
    //-----------------------------------------------
    return 0.0
}

// Spawn this vehicle into the world.
/// Source: oracle/codemp/game/g_vehicles.c:186
func G_VehicleSpawn(_ `self`: Entity) {
    let yaw: Float
    var vehEnt: Entity?

    `self`.s.origin = `self`.r.currentOrigin

    trap_LinkEntity(`self`)

    if `self`.count == 0 {
        `self`.count = 1
    }

    //save this because self gets removed in next func
    yaw = `self`.s.angles[YAW]

    vehEnt = NPC_Spawn_Do(`self`)

    if vehEnt == nil {
        return //return NULL;
    }

    vehEnt!.s.angles[YAW] = yaw
    if vehEnt!.m_pVehicle!.m_pVehicleInfo!.type != VH_ANIMAL {
        vehEnt!.NPC!.behaviorState = BS_CINEMATIC
    }

    if (vehEnt!.spawnflags & 1) != 0 {
        //die without pilot
        if vehEnt!.damage == 0 {
            //default 10 sec
            vehEnt!.damage = 10000
        }
        if vehEnt!.speed == 0 {
            //default 512 units
            vehEnt!.speed = 512.0
        }
        vehEnt!.m_pVehicle!.m_iPilotTime = level.time + vehEnt!.damage
    }
    //return vehEnt;
}

// Attachs an entity to the vehicle it's riding (it's owner).
/// Source: oracle/codemp/game/g_vehicles.c:247
func G_AttachToVehicle(_ pEnt: Entity, _ ucmd: inout JKAMP.Usercmd?) {
    var vehEnt: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var ent: Entity?
        var crotchBolt: Int32 = 0


        ent = pEnt

        vehEnt = g_entities[ent!.r.ownerNum]
        ent!.waypoint = vehEnt!.waypoint // take the veh's waypoint as your own

        if vehEnt!.m_pVehicle == nil {
            return true
        }

        crotchBolt = trap_G2API_AddBolt(vehEnt!.ghoul2, 0, "*driver")

        // Get the driver tag.
        trap_G2API_GetBoltMatrix(vehEnt!.ghoul2, 0, crotchBolt, boltMatrix, vehEnt!.m_pVehicle!.m_vOrientationVector, vehEnt!.r.currentOrigin, level.time, nil, &vehEnt!.modelScale)
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &ent!.client!.ps.origin)
        G_SetOrigin(ent!, &ent!.client!.ps.origin)
        trap_LinkEntity(ent!)
        // Get the driver tag.
        return false
    }
    if earlyOut {
        return
    }
}

// Animate the vehicle and it's riders.
/// Source: oracle/codemp/game/g_vehicles.c:481
func Animate(_ pVeh: JKAMP.Vehicle) {
    // Validate a pilot rider.
    if pVeh.m_pPilot != nil {
        if pVeh.m_pVehicleInfo!.AnimateRiders != nil {
            pVeh.m_pVehicleInfo!.runAnimateRiders(pVeh)
        }
    }

    pVeh.m_pVehicleInfo!.runAnimateVehicle(pVeh)
}

// Determine whether this entity is able to board this vehicle or not.
/// Source: oracle/codemp/game/g_vehicles.c:496
func ValidateBoard(_ pVeh: JKAMP.Vehicle, _ pEnt: JKAMP.BgEntity) -> Bool {
    // Determine where the entity is entering the vehicle from (left, right, or back).
    var vVehToEnt = vec3_t()
    var vVehDir = vec3_t()
    let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
    let ent: Entity? = Entity(pEnt)
    var vVehAngles = vec3_t()
    let fDot: Float

    if pVeh.m_iDieTime > 0 {
        return false
    }

    if pVeh.m_pPilot != nil {
        //already have a driver!
        if pVeh.m_pVehicleInfo!.type == VH_FIGHTER {
            //I know, I know, this should by in the fighters's validateboard()
            //can never steal a fighter from it's pilot
            if pVeh.m_iNumPassengers < pVeh.m_pVehicleInfo!.maxPassengers {
                return true
            } else {
                return false
            }
        } else if pVeh.m_pVehicleInfo!.type == VH_WALKER {
            //I know, I know, this should by in the walker's validateboard()
            if ent!.client == nil || ent!.client!.ps.groundEntityNum != parent!.s.number {
                //can only steal an occupied AT-ST if you're on top (by the hatch)
                return false
            }
        } else if pVeh.m_pVehicleInfo!.type == VH_SPEEDER {
            //you can only steal the bike from the driver if you landed on the driver or bike
            return (pVeh.m_iBoarding == VEH_MOUNT_THROW_LEFT || pVeh.m_iBoarding == VEH_MOUNT_THROW_RIGHT)
        }
    } else if pVeh.m_pVehicleInfo!.type == VH_FIGHTER {
        // Yes, you shouldn't have put this here (you 'should' have made an 'overriden' ValidateBoard func), but in this
        // instance it's more than adequate (which is why I do it too :-). Making a whole other function for this is silly.
        // If you're a fighter, you allow everyone to enter you from all directions.
        return true
    }

    // Clear out all orientation axis except for the yaw.
    vVehAngles = vec3_t(0, parent!.r.currentAngles[YAW], 0)

    // Vector from Entity to Vehicle.
    vVehToEnt = ent!.r.currentOrigin - parent!.r.currentOrigin
    vVehToEnt[2] = 0
    VectorNormalize(&vVehToEnt)

    // Get the right vector.
    // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("ValidateBoard", source: "oracle/codemp/game/g_vehicles.c:496")
    var scratchForward = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("ValidateBoard", source: "oracle/codemp/game/g_vehicles.c:496")
    var scratchUp = vec3_t()
    AngleVectors(vVehAngles, &scratchForward, &vVehDir, &scratchUp)
    VectorNormalize(&vVehDir)

    // Find the angle between the vehicle right vector and the vehicle to entity vector.
    fDot = _DotProduct(vVehToEnt, vVehDir)

    // If the entity is within a certain angle to the left of the vehicle...
    if fDot >= 0.5 {
        // Right board.
        pVeh.m_iBoarding = -2
    } else if fDot <= -0.5 {
        // Left board.
        pVeh.m_iBoarding = -1
    } else {
        // Maybe they're trying to board from the back...
        // The forward vector of the vehicle.
        //	AngleVectors( vVehAngles, vVehDir, NULL, NULL );
        //	VectorNormalize( vVehDir );

        // Find the angle between the vehicle forward and the vehicle to entity vector.
        //	fDot = DotProduct( vVehToEnt, vVehDir );

        // If the entity is within a certain angle behind the vehicle...
        //if ( fDot <= -0.85f )
        do {
            // Jump board.
            pVeh.m_iBoarding = -3
        }
    }

    // If for some reason we couldn't board, leave...
    if pVeh.m_iBoarding > -1 {
        return false
    }

    return true
}

// Board this Vehicle (get on). The first entity to board an empty vehicle becomes the Pilot.
/// Source: oracle/codemp/game/g_vehicles.c:630
private func Board(_ pVeh: JKAMP.Vehicle, _ pEnt: JKAMP.BgEntity) -> Bool {
    var vPlayerDir = vec3_t()
    let ent: Entity? = Entity(pEnt)
    let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }

    // If it's not a valid entity, OR if the vehicle is blowing up (it's dead), OR it's not
    // empty, OR we're already being boarded, OR the person trying to get on us is already
    // in a vehicle (that was a fun bug :-), leave!
    // Port-note: No operator between the operands, the text there is `|| #ifdef _JK2MP`.
    // Raven wrote: if ( !ent || parent->health <= 0 /*|| !( parent->client->ps.eFlags & EF_EMPTY_VEHICLE )*/ || (pVeh->m_iBoarding > 0) || #ifdef _JK2MP ( ent->client->ps.m_iVehicleNum ) ) #else ( ent->s.m_iVehicleNum != 0 ) ) #endif return false
    portMissing("Board", source: "oracle/codemp/game/g_vehicles.c:630")

    // Bucking so we can't do anything (NOTE: Should probably be a better name since fighters don't buck...).
    if (pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_BUCKING))) != 0 {
        return false
    }

    // Validate the entity's ability to board this vehicle.
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
    // Raven wrote: if ( !pVeh->m_pVehicleInfo->ValidateBoard( pVeh, pEnt ) ) return false
    portMissing("Board", source: "oracle/codemp/game/g_vehicles.c:630")

    // FIXME FIXME!!! Ask Mike monday where ent->client->ps.eFlags might be getting changed!!! It is always 0 (when it should
    // be 1024) so a person riding a vehicle is able to ride another vehicle!!!!!!!!

    // Tell everybody their status.
    // ALWAYS let the player be the pilot.
    if ent!.s.number < MAX_CLIENTS {
        pVeh.m_pOldPilot = pVeh.m_pPilot


        if pVeh.m_pPilot == nil {
            //become the pilot, if there isn't one now
            pVeh.m_pVehicleInfo!.runSetPilot(pVeh, ent.map { BgEntity($0) })
        } else if pVeh.m_iNumPassengers < pVeh.m_pVehicleInfo!.maxPassengers {
            // If we're not yet full...
            var i: Int32
            // Find an empty slot and put that passenger here.
            i = 0
            while i < pVeh.m_pVehicleInfo!.maxPassengers {
                if pVeh.m_ppPassengers[i] == nil {
                    pVeh.m_ppPassengers[i] = ent.map { BgEntity($0) }
                    //Server just needs to tell client which passengernum he is
                    if ent!.client != nil {
                        ent!.client!.ps.generic1 = i + 1
                    }
                    break
                }
                i += 1
            }
            pVeh.m_iNumPassengers += 1
        } else {
            // We're full, sorry...
            return false
        }
        ent!.s.m_iVehicleNum = parent!.s.number
        if ent!.client != nil {
            ent!.client!.ps.m_iVehicleNum = ent!.s.m_iVehicleNum
        }
        if pVeh.m_pPilot == ent.map { BgEntity($0) } {
            parent!.r.ownerNum = ent!.s.number
            parent!.s.owner = parent!.r.ownerNum //for prediction
        }

        do {
            let gParent: Entity? = parent
            if (gParent!.spawnflags & 2) != 0 {
                //was being suspended
                gParent!.spawnflags &= ~2 //SUSPENDED - clear this spawnflag, no longer docked, okay to free-fall if not in space
                //gParent->client->ps.eFlags &= ~EF_RADAROBJECT;
                G_Sound(gParent!, CHAN_AUTO, G_SoundIndex("sound/vehicles/common/release.wav"))
                if gParent!.fly_sound_debounce_time != 0 {
                    //we should drop like a rock for a few seconds
                    pVeh.m_iDropTime = level.time + gParent!.fly_sound_debounce_time
                }
            }
        }


        //FIXME: rider needs to look in vehicle's direction when he gets in
        // Clear these since they're used to turn the vehicle now.
        /*SetClientViewAngle( ent, pVeh->m_vOrientation );
        memset( &parent->client->usercmd, 0, sizeof( usercmd_t ) );
        memset( &pVeh->m_ucmd, 0, sizeof( usercmd_t ) );
        VectorClear( parent->client->ps.viewangles );
        VectorClear( parent->client->ps.delta_angles );*/

        // Set the looping sound only when there is a pilot (when the vehicle is "on").
        if pVeh.m_pVehicleInfo!.soundLoop != 0 {
            parent!.s.loopSound = pVeh.m_pVehicleInfo!.soundLoop
            parent!.client!.ps.loopSound = parent!.s.loopSound
        }
    } else {
        // If there's no pilot, try to drive this vehicle.
        if pVeh.m_pPilot == nil {
            pVeh.m_pVehicleInfo!.runSetPilot(pVeh, ent.map { BgEntity($0) })
            // TODO: Set pilot should do all this stuff....
            parent!.r.ownerNum = ent!.s.number
            parent!.s.owner = parent!.r.ownerNum //for prediction
            // TODO: Set pilot should do all this stuff....
            // Set the looping sound only when there is a pilot (when the vehicle is "on").
            if pVeh.m_pVehicleInfo!.soundLoop != 0 {
                parent!.s.loopSound = pVeh.m_pVehicleInfo!.soundLoop
                parent!.client!.ps.loopSound = parent!.s.loopSound
            }

            parent!.client!.ps.speed = 0
            pVeh.m_ucmd.clear()
        } else if pVeh.m_iNumPassengers < pVeh.m_pVehicleInfo!.maxPassengers {
            // If we're not yet full...
            var i: Int32
            // Find an empty slot and put that passenger here.
            i = 0
            while i < pVeh.m_pVehicleInfo!.maxPassengers {
                if pVeh.m_ppPassengers[i] == nil {
                    pVeh.m_ppPassengers[i] = ent.map { BgEntity($0) }
                    //Server just needs to tell client which passengernum he is
                    if ent!.client != nil {
                        ent!.client!.ps.generic1 = i + 1
                    }
                    break
                }
                i += 1
            }
            pVeh.m_iNumPassengers += 1
        } else {
            // We're full, sorry...
            return false
        }
    }

    // Make sure the entity knows it's in a vehicle.
    ent!.client!.ps.m_iVehicleNum = parent!.s.number
    ent!.r.ownerNum = parent!.s.number
    ent!.s.owner = ent!.r.ownerNum //for prediction
    if pVeh.m_pPilot == ent.map { BgEntity($0) } {
        parent!.client!.ps.m_iVehicleNum = ent!.s.number + 1 //always gonna be under MAX_CLIENTS so no worries about 1 byte overflow
    }

    //memset( &ent->client->usercmd, 0, sizeof( usercmd_t ) );

    //FIXME: no saber or weapons if numHands = 2, should switch to speeder weapon, no attack anim on player
    if pVeh.m_pVehicleInfo!.numHands == 2 {
        //switch to vehicle weapon
    }

    if pVeh.m_pVehicleInfo!.hideRider {
        //hide the rider
        pVeh.m_pVehicleInfo!.runGhost(pVeh, ent.map { BgEntity($0) })
    }

    // Play the start sounds
    if pVeh.m_pVehicleInfo!.soundOn != 0 {
        G_Sound(parent!, CHAN_AUTO, pVeh.m_pVehicleInfo!.soundOn)
        // NOTE: Use this type so it's spatialized and updates play origin as bike moves - MCG
    }


    vPlayerDir = pVeh.m_vOrientationVector
    vPlayerDir[ROLL] = 0
    SetClientViewAngle(ent!, vPlayerDir)

    return true
}

/// Source: oracle/codemp/game/g_vehicles.c:874
func VEH_TryEject(_ pVeh: JKAMP.Vehicle, _ parent: Entity, _ ent: Entity, _ ejectDir: Int32, _ vExitPos: inout JKAShared.vec3_t) -> Bool {
    var fBias: Float = 0
    var fVehDiag: Float = 0
    var fEntDiag: Float = 0
    var oldOwner: Int32 = 0
    var vEntMins = vec3_t()
    var vEntMaxs = vec3_t()
    var vVehLeaveDir = vec3_t()
    var vVehAngles = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { m_ExitTrace -> Bool in

        // Make sure that the entity is not 'stuck' inside the vehicle (since their bboxes will now intersect).
        // This makes the entity leave the vehicle from the right side.
        vVehAngles = vec3_t(0, parent.r.currentAngles[YAW], 0)
        switch ejectDir {
        // Left.
        case VEH_EJECT_LEFT:
            // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchForward = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchUp = vec3_t()
            AngleVectors(vVehAngles, &scratchForward, &vVehLeaveDir, &scratchUp)
            vVehLeaveDir[0] = -vVehLeaveDir[0]
            vVehLeaveDir[1] = -vVehLeaveDir[1]
            vVehLeaveDir[2] = -vVehLeaveDir[2]
            // Right.

        case VEH_EJECT_RIGHT:
            // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchForward2 = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchUp2 = vec3_t()
            AngleVectors(vVehAngles, &scratchForward2, &vVehLeaveDir, &scratchUp2)
            // Front.

        case VEH_EJECT_FRONT:
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchRight = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchUp3 = vec3_t()
            AngleVectors(vVehAngles, &vVehLeaveDir, &scratchRight, &scratchUp3)
            // Rear.

        case VEH_EJECT_REAR:
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchRight2 = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchUp4 = vec3_t()
            AngleVectors(vVehAngles, &vVehLeaveDir, &scratchRight2, &scratchUp4)
            vVehLeaveDir[0] = -vVehLeaveDir[0]
            vVehLeaveDir[1] = -vVehLeaveDir[1]
            vVehLeaveDir[2] = -vVehLeaveDir[2]
            // Top.

        case VEH_EJECT_TOP:
            // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchForward3 = vec3_t()
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("VEH_TryEject", source: "oracle/codemp/game/g_vehicles.c:874")
            var scratchRight3 = vec3_t()
            AngleVectors(vVehAngles, &scratchForward3, &scratchRight3, &vVehLeaveDir)
            // Bottom?.

        case VEH_EJECT_BOTTOM:
            break

        default:
            break
        }
        VectorNormalize(&vVehLeaveDir)
        //NOTE: not sure why following line was needed - MCG
        //pVeh->m_EjectDir = VEH_EJECT_LEFT;

        // Since (as of this time) the collidable geometry of the entity is just an axis
        // aligned box, we need to get the diagonal length of it in case we come out on that side.
        // Diagonal Length == squareroot( squared( Sidex / 2 ) + squared( Sidey / 2 ) );

        // TODO: DO diagonal for entity.

        fBias = 1.0
        if pVeh.m_pVehicleInfo!.type == VH_WALKER {
            //hacktastic!
            fBias += 0.2
        }
        vExitPos = ent.r.currentOrigin
        fVehDiag = sqrt((parent.r.maxs[0] * parent.r.maxs[0]) + (parent.r.maxs[1] * parent.r.maxs[1]))
        vEntMaxs = ent.r.maxs
        if ent.s.number < MAX_CLIENTS {
            //for some reason, in MP, player client mins and maxs are never stored permanently, just set to these hardcoded numbers in PMove
            vEntMaxs[0] = 15
            vEntMaxs[1] = 15
        }
        fEntDiag = sqrt((vEntMaxs[0] * vEntMaxs[0]) + (vEntMaxs[1] * vEntMaxs[1]))
        vVehLeaveDir[0] *= (fVehDiag + fEntDiag) * fBias // x
        vVehLeaveDir[1] *= (fVehDiag + fEntDiag) * fBias // y
        vVehLeaveDir[2] *= (fVehDiag + fEntDiag) * fBias
        vExitPos = vExitPos + vVehLeaveDir

        //we actually could end up *not* getting off if the trace fails...
        // Check to see if this new position is a valid place for our entity to go.
        vEntMins = vec3_t(-15.0, -15.0, Float(DEFAULT_MINS_2))
        vEntMaxs = vec3_t(15.0, 15.0, Float(DEFAULT_MAXS_2))
        oldOwner = ent.r.ownerNum
        ent.r.ownerNum = ENTITYNUM_NONE
        G_VehicleTrace(m_ExitTrace, ent.r.currentOrigin, vEntMins, vEntMaxs, vExitPos, ent.s.number, ent.clipmask)
        ent.r.ownerNum = oldOwner

        if m_ExitTrace.allsolid != 0 || m_ExitTrace.startsolid != 0 {
            return false
        }
        // If the trace hit something, we can't go there!
        if m_ExitTrace.fraction < 1.0 {
            //not totally clear
            //		if ( (parent->clipmask&ent->r.contents) )//vehicle could actually get stuck on body
            do {
                //the trace hit the vehicle, don't let them get out, just in case
                return false
            }
            //otherwise, use the trace.endpos
            vExitPos = m_ExitTrace.endpos
        }
        return true
    }
}

/// Source: oracle/codemp/game/g_vehicles.c:989
func G_EjectDroidUnit(_ pVeh: JKAMP.Vehicle, _ kill: Bool) {
    pVeh.m_pDroidUnit!.s.m_iVehicleNum = ENTITYNUM_NONE
    pVeh.m_pDroidUnit!.s.owner = ENTITYNUM_NONE
    //	pVeh->m_pDroidUnit->s.otherEntityNum2 = ENTITYNUM_NONE;
    do {
        let droidEnt: Entity? = pVeh.m_pDroidUnit.map { Entity($0) }
        droidEnt!.flags &= ~FL_UNDYING
        droidEnt!.r.ownerNum = ENTITYNUM_NONE
        if droidEnt!.client != nil {
            droidEnt!.client!.ps.m_iVehicleNum = ENTITYNUM_NONE
        }
        if kill {
            //Kill them, too
            //FIXME: proper origin, MOD and attacker (for credit/death message)?  Get from vehicle?
            G_MuteSound(droidEnt!.s.number, CHAN_VOICE)
            // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("G_EjectDroidUnit", source: "oracle/codemp/game/g_vehicles.c:989")
            var scratchDir = vec3_t()
            G_Damage(droidEnt!, nil, nil, &scratchDir, droidEnt!.s.origin, 10000, 0, MOD_SUICIDE) //FIXME: proper MOD?  Get from vehicle?
        }
    }
    pVeh.m_pDroidUnit = nil
}

// Eject the pilot from the vehicle.
/// Source: oracle/codemp/game/g_vehicles.c:1019
private func Eject(_ pVeh: JKAMP.Vehicle, _ pEnt: JKAMP.BgEntity, _ forceEject: Bool) -> Bool {
    var parent: Entity?
    var vExitPos = vec3_t()
    let ent: Entity? = Entity(pEnt)
    let firstEjectDir: Int32

    var taintedRider: Bool = false
    var deadRider: Bool = false

    getItOutOfMe: do {
        if pEnt == pVeh.m_pDroidUnit {
            G_EjectDroidUnit(pVeh, false)
            return true
        }

        if ent != nil {
            if !ent!.inuse || ent!.client == nil || ent!.client!.pers.connected != CON_CONNECTED {
                taintedRider = true
                parent = pVeh.m_pParentEntity.map { Entity($0) }
                break getItOutOfMe
            } else if ent!.health < 1 {
                deadRider = true
            }
        }

        // Validate.
        if ent == nil {
            return false
        }
        if !forceEject {
            if !(pVeh.m_iBoarding == 0 || pVeh.m_iBoarding == -999 || (pVeh.m_iBoarding < -3 && pVeh.m_iBoarding >= -9)) {
                deadRider = true
                pVeh.m_iBoarding = 0
                pVeh.m_bWasBoarding = false
            }
        }


        parent = pVeh.m_pParentEntity.map { Entity($0) }

        //Try ejecting in every direction
        if pVeh.m_EjectDir < VEH_EJECT_LEFT {
            pVeh.m_EjectDir = VEH_EJECT_LEFT
        } else if pVeh.m_EjectDir > VEH_EJECT_BOTTOM {
            pVeh.m_EjectDir = VEH_EJECT_BOTTOM
        }
        firstEjectDir = pVeh.m_EjectDir
        while !VEH_TryEject(pVeh, parent!, ent!, pVeh.m_EjectDir, &vExitPos) {
            pVeh.m_EjectDir += 1
            if pVeh.m_EjectDir > VEH_EJECT_BOTTOM {
                pVeh.m_EjectDir = VEH_EJECT_LEFT
            }
            if pVeh.m_EjectDir == firstEjectDir {
                //they all failed
                if !deadRider {
                    //if he's dead.. just shove him in solid, who cares.
                    return false
                }
                if forceEject {
                    //we want to always get out, just eject him here
                    vExitPos = ent!.r.currentOrigin
                    break
                } else {
                    //can't eject
                    return false
                }
            }
        }

        // Move them to the exit position.
        G_SetOrigin(ent!, &vExitPos)
        ent!.client!.ps.origin = ent!.r.currentOrigin
        trap_LinkEntity(ent!)

        // If it's the player, stop overrides.
        if ent!.s.number < MAX_CLIENTS {
        }

    }

    // If he's the pilot...
    if pVeh.m_pPilot.map { Entity($0) } == ent {
        var j: Int32 = 0

        pVeh.m_pPilot = nil
        parent!.r.ownerNum = ENTITYNUM_NONE
        parent!.s.owner = parent!.r.ownerNum //for prediction

        //keep these current angles
        //SetClientViewAngle( parent, pVeh->m_vOrientation );
        parent!.client!.pers.cmd.clear()

        //keep these current angles
        //SetClientViewAngle( parent, pVeh->m_vOrientation );
        pVeh.m_ucmd.clear()

        while j < pVeh.m_iNumPassengers {
            if pVeh.m_ppPassengers[j] != nil {
                var k: Int32 = 1
                pVeh.m_pVehicleInfo!.runSetPilot(pVeh, pVeh.m_ppPassengers[j])
                parent!.r.ownerNum = pVeh.m_ppPassengers[j]!.s.number
                parent!.s.owner = parent!.r.ownerNum //for prediction
                parent!.client!.ps.m_iVehicleNum = pVeh.m_ppPassengers[j]!.s.number + 1

                //rearrange the passenger slots now..
                //Server just needs to tell client he's not a passenger anymore
                if (pVeh.m_ppPassengers[j].map { Entity($0) })!.client != nil {
                    (pVeh.m_ppPassengers[j].map { Entity($0) })!.client!.ps.generic1 = 0
                }
                pVeh.m_ppPassengers[j] = nil
                while k < pVeh.m_iNumPassengers {
                    if pVeh.m_ppPassengers[k - 1] == nil {
                        //move down
                        pVeh.m_ppPassengers[k - 1] = pVeh.m_ppPassengers[k]
                        pVeh.m_ppPassengers[k] = nil
                        //Server just needs to tell client which passenger he is
                        if (pVeh.m_ppPassengers[k - 1].map { Entity($0) })!.client != nil {
                            (pVeh.m_ppPassengers[k - 1].map { Entity($0) })!.client!.ps.generic1 = k
                        }
                    }
                    k += 1
                }
                pVeh.m_iNumPassengers -= 1

                break
            }
            j += 1
        }
    } else if ent == pVeh.m_pOldPilot.map { Entity($0) } {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int' to type 'BgEntity'".
        // Raven wrote: pVeh->m_pOldPilot = 0
        portMissing("Eject", source: "oracle/codemp/game/g_vehicles.c:1019")
    } else {
        var i: Int32
        // Look for this guy in the passenger list.
        i = 0
        while i < pVeh.m_pVehicleInfo!.maxPassengers {
            // If we found him...
            if pVeh.m_ppPassengers[i].map { Entity($0) } == ent {
                //Server just needs to tell client he's not a passenger anymore
                if (pVeh.m_ppPassengers[i].map { Entity($0) })!.client != nil {
                    (pVeh.m_ppPassengers[i].map { Entity($0) })!.client!.ps.generic1 = 0
                }
                pVeh.m_ppPassengers[i] = nil
                pVeh.m_iNumPassengers -= 1
                break
            }
            i += 1
        }

        // Didn't find him, can't eject because they aren't in the vehicle (hopefully)!
        if i == pVeh.m_pVehicleInfo!.maxPassengers {
            return false
        }
    }

    if !taintedRider {
        if pVeh.m_pVehicleInfo!.hideRider {
            pVeh.m_pVehicleInfo!.runUnGhost(pVeh, ent.map { BgEntity($0) })
        }
    }

    // If the vehicle now has no pilot...
    if pVeh.m_pPilot == nil {
        parent!.s.loopSound = 0
        parent!.client!.ps.loopSound = parent!.s.loopSound
        // Completely empty vehicle...?
        if pVeh.m_iNumPassengers == 0 {
            parent!.client!.ps.m_iVehicleNum = 0
        }
    }

    if taintedRider {
        //you can go now
        pVeh.m_iBoarding = level.time + 1000
        return true
    }

    // Client not in a vehicle.
    ent!.client!.ps.m_iVehicleNum = 0
    ent!.r.ownerNum = ENTITYNUM_NONE
    ent!.s.owner = ent!.r.ownerNum //for prediction

    ent!.client!.ps.viewangles[PITCH] = 0.0
    ent!.client!.ps.viewangles[ROLL] = 0.0
    ent!.client!.ps.viewangles[YAW] = pVeh.m_vOrientationVector[YAW]
    SetClientViewAngle(ent!, ent!.client!.ps.viewangles)

    if ent!.client!.solidHack != 0 {
        ent!.client!.solidHack = 0
        ent!.r.contents = CONTENTS_BODY
    }
    ent!.s.m_iVehicleNum = 0

    // Jump out.
    /*	if ( ent->client->ps.velocity[2] < JUMP_VELOCITY )
    {
    ent->client->ps.velocity[2] = JUMP_VELOCITY;
    }
    else
    {
    ent->client->ps.velocity[2] += JUMP_VELOCITY;
    }*/

    // Make sure entity is facing the direction it got off at.

    //if was using vehicle weapon, remove it and switch to normal weapon when hop out...
    if ent!.client!.ps.weapon == WP_NONE {
        //FIXME: check against this vehicle's gun from the g_vehicleInfo table
        //remove the vehicle's weapon from me
        //ent->client->ps.stats[STAT_WEAPONS] &= ~( 1 << WP_EMPLACED_GUN );
        //ent->client->ps.ammo[weaponData[WP_EMPLACED_GUN].ammoIndex] = 0;//maybe store this ammo on the vehicle before clearing it?
        //switch back to a normal weapon we're carrying

        //FIXME: store the weapon we were using when we got on and restore that when hop off
        /*		if ( (ent->client->ps.stats[STAT_WEAPONS]&(1<<WP_SABER)) )
        {
        CG_ChangeWeapon( WP_SABER );
        }
        else
        {//go through all weapons and switch to highest held
        for ( int checkWp = WP_NUM_WEAPONS-1; checkWp > WP_NONE; checkWp-- )
        {
        if ( (ent->client->ps.stats[STAT_WEAPONS]&(1<<checkWp)) )
        {
        CG_ChangeWeapon( checkWp );
        }
        }
        if ( checkWp == WP_NONE )
        {
        CG_ChangeWeapon( WP_NONE );
        }
        }*/
    } else {
        //FIXME: if they have their saber out:
        //if dualSabers, add the second saber into the left hand
        //saber[0] has more than one blade, turn them all on
        //NOTE: this is because you're only allowed to use your first saber's first blade on a vehicle
    }

    /*	if ( !ent->s.number && ent->client->ps.weapon != WP_SABER
    && cg_gunAutoFirst.value )
    {
    gi.cvar_set( "cg_thirdperson", "0" );
    }*/
    BG_SetLegsAnimTimer(ent!.client!.ps, 0)
    BG_SetTorsoAnimTimer(ent!.client!.ps, 0)

    // Set how long until this vehicle can be boarded again.
    pVeh.m_iBoarding = level.time + 1000

    return true
}

// Eject all the inhabitants of this vehicle.
/// Source: oracle/codemp/game/g_vehicles.c:1377
func EjectAll(_ pVeh: JKAMP.Vehicle) -> Bool {
    // TODO: Setup a default escape for ever vehicle type.

    pVeh.m_EjectDir = VEH_EJECT_TOP
    // Make sure no other boarding calls exist. We MUST exit.
    pVeh.m_iBoarding = 0
    pVeh.m_bWasBoarding = false

    // Throw them off.
    if pVeh.m_pPilot != nil {
        let pilot: Entity? = pVeh.m_pPilot.map { Entity($0) }
        pVeh.m_pVehicleInfo!.runEject(pVeh, pVeh.m_pPilot, true)
        if pVeh.m_pVehicleInfo!.killRiderOnDeath && pilot != nil {
            //Kill them, too
            //FIXME: proper origin, MOD and attacker (for credit/death message)?  Get from vehicle?
            G_MuteSound(pilot!.s.number, CHAN_VOICE)
            // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("EjectAll", source: "oracle/codemp/game/g_vehicles.c:1377")
            var scratchDir = vec3_t()
            G_Damage(pilot!, nil, nil, &scratchDir, pilot!.s.origin, 10000, 0, MOD_SUICIDE)
        }
    }
    if pVeh.m_pOldPilot != nil {
        let pilot: Entity? = pVeh.m_pOldPilot.map { Entity($0) }
        pVeh.m_pVehicleInfo!.runEject(pVeh, pVeh.m_pOldPilot, true)
        if pVeh.m_pVehicleInfo!.killRiderOnDeath && pilot != nil {
            //Kill them, too
            //FIXME: proper origin, MOD and attacker (for credit/death message)?  Get from vehicle?
            G_MuteSound(pilot!.s.number, CHAN_VOICE)
            // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("EjectAll", source: "oracle/codemp/game/g_vehicles.c:1377")
            var scratchDir2 = vec3_t()
            G_Damage(pilot!, nil, nil, &scratchDir2, pilot!.s.origin, 10000, 0, MOD_SUICIDE)
        }
    }
    if pVeh.m_iNumPassengers != 0 {
        var i: Int32

        i = 0
        while i < pVeh.m_pVehicleInfo!.maxPassengers {
            if pVeh.m_ppPassengers[i] != nil {
                let rider: Entity? = pVeh.m_ppPassengers[i].map { Entity($0) }
                pVeh.m_pVehicleInfo!.runEject(pVeh, pVeh.m_ppPassengers[i], true)
                if pVeh.m_pVehicleInfo!.killRiderOnDeath && rider != nil {
                    //Kill them, too
                    //FIXME: proper origin, MOD and attacker (for credit/death message)?  Get from vehicle?
                    G_MuteSound(rider!.s.number, CHAN_VOICE)
                    // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("EjectAll", source: "oracle/codemp/game/g_vehicles.c:1377")
                    var scratchDir3 = vec3_t()
                    G_Damage(rider!, nil, nil, &scratchDir3, rider!.s.origin, 10000, 0, MOD_SUICIDE) //FIXME: proper MOD?  Get from vehicle?
                }
            }
            i += 1
        }
        pVeh.m_iNumPassengers = 0
    }

    if pVeh.m_pDroidUnit != nil {
        G_EjectDroidUnit(pVeh, pVeh.m_pVehicleInfo!.killRiderOnDeath)
    }

    return true
}

// Start a delay until the vehicle explodes.
/// Source: oracle/codemp/game/g_vehicles.c:1451
private func StartDeathDelay(_ pVeh: JKAMP.Vehicle, _ iDelayTimeOverride: Int32) {
    let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }

    if iDelayTimeOverride != 0 {
        pVeh.m_iDieTime = level.time + iDelayTimeOverride
    } else {
        pVeh.m_iDieTime = level.time + pVeh.m_pVehicleInfo!.explosionDelay
    }

    if pVeh.m_pVehicleInfo!.flammable {
        parent!.s.loopSound = G_SoundIndex("sound/vehicles/common/fire_lp.wav")
        parent!.client!.ps.loopSound = parent!.s.loopSound
    }
    // Armor Gone Effects (Fire)
    //---------------------------
}

// Decide whether to explode the vehicle or not.
/// Source: oracle/codemp/game/g_vehicles.c:1485
private func DeathUpdate(_ pVeh: JKAMP.Vehicle) {
    let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }

    if level.time >= pVeh.m_iDieTime {
        // If the vehicle is not empty.
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
        // Raven wrote: if ( pVeh->m_pVehicleInfo->Inhabited( pVeh ) ) { #ifndef _JK2MP if (pVeh->m_pPilot) { pVeh->m_pPilot->client->noRagTime = -1; // no ragdoll for you } #endif pVeh->m_pVehicleInfo->EjectAll( pVeh ); #ifdef _JK2MP if ( pVeh->m_pVehicleInfo->Inhabited( pVeh ) ) { //if we've still got people in us, just kill the bastards if ( pVeh->m_pPilot ) { //FIXME: does this give proper credit to the enemy who shot you down? G_Damage((gentity_t *)pVeh->m_pPilot, (gentity_t *)pVeh->m_pParentEntity, (gentity_t *)pVeh->m_pParentEntity, NULL, pVeh->m_pParentEntity->playerState->origin, 999, DAMAGE_NO_PROTECTION, MOD_EXPLOSIVE); } if ( pVeh->m_iNumPassengers ) { int i; for ( i = 0; i < pVeh->m_pVehicleInfo->maxPassengers; i++ ) { if ( pVeh->m_ppPassengers[i] ) { //FIXME: does this give proper credit to the enemy who shot you down? G_Damage((gentity_t *)pVeh->m_ppPassengers[i], (gentity_t *)pVeh->m_pParentEntity, (gentity_t *)pVeh->m_pParentEntity, NULL, pVeh->m_pParentEntity->playerState->origin, 999, DAMAGE_NO_PROTECTION, MOD_EXPLOSIVE); } } } } #endif }
        portMissing("DeathUpdate", source: "oracle/codemp/game/g_vehicles.c:1485")

        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
        // Raven wrote: if ( !pVeh->m_pVehicleInfo->Inhabited( pVeh ) ) { //explode now as long as we managed to kick everyone out vec3_t lMins, lMaxs, bottom; trace_t trace; #ifndef _JK2MP // Kill All Client Side Looping Effects //-------------------------------------- if (pVeh->m_pVehicleInfo->iExhaustFX) { for (int i=0; (i<MAX_VEHICLE_EXHAUSTS && pVeh->m_iExhaustTag[i]!=-1); i++) { G_StopEffect(pVeh->m_pVehicleInfo->iExhaustFX, parent->playerModel, pVeh->m_iExhaustTag[i], parent->s.number); } } if (pVeh->m_pVehicleInfo->iArmorLowFX) { G_StopEffect(pVeh->m_pVehicleInfo->iArmorLowFX, parent->playerModel, parent->crotchBolt, parent->s.number); } if (pVeh->m_pVehicleInfo->iArmorGoneFX) { G_StopEffect(pVeh->m_pVehicleInfo->iArmorGoneFX, parent->playerModel, parent->crotchBolt, parent->s.number); } //-------------------------------------- #endif if ( pVeh->m_pVehicleInfo->iExplodeFX ) { #ifdef _JK2MP vec3_t fxAng; VectorSet(fxAng, -90.0f, 0.0f, 0.0f); G_PlayEffectID( pVeh->m_pVehicleInfo->iExplodeFX, parent->currentOrigin, fxAng ); #else G_PlayEffect( pVeh->m_pVehicleInfo->iExplodeFX, parent->currentOrigin, vec3_origin ); #endif //trace down and place mark VectorCopy( parent->currentOrigin, bottom ); bottom[2] -= 80; G_VehicleTrace( &trace, parent->currentOrigin, vec3_origin, vec3_origin, bottom, parent->s.number, CONTENTS_SOLID ); if ( trace.fraction < 1.0f ) { VectorCopy( trace.endpos, bottom ); bottom[2] += 2; #ifdef _JK2MP VectorSet(fxAng, -90.0f, 0.0f, 0.0f); G_PlayEffectID( G_EffectIndex("ships/ship_explosion_mark"), trace.endpos, fxAng ); #else G_PlayEffect( "ships/ship_explosion_mark", trace.endpos ); #endif } } parent->takedamage = qfalse;//so we don't recursively damage ourselves if ( pVeh->m_pVehicleInfo->explosionRadius > 0 && pVeh->m_pVehicleInfo->explosionDamage > 0 ) { VectorCopy( parent->mins, lMins ); lMins[2] = -4;//to keep it off the ground a *little* VectorCopy( parent->maxs, lMaxs ); VectorCopy( parent->currentOrigin, bottom ); bottom[2] += parent->mins[2] - 32; G_VehicleTrace( &trace, parent->currentOrigin, lMins, lMaxs, bottom, parent->s.number, CONTENTS_SOLID ); #ifdef _JK2MP G_RadiusDamage( trace.endpos, parent, pVeh->m_pVehicleInfo->explosionDamage, pVeh->m_pVehicleInfo->explosionRadius, NULL, NULL, MOD_VEH_EXPLOSION );//FIXME: extern damage and radius or base on fuel #else G_RadiusDamage( trace.endpos, NULL, pVeh->m_pVehicleInfo->explosionDamage, pVeh->m_pVehicleInfo->explosionRadius, NULL, MOD_EXPLOSIVE );//FIXME: extern damage and radius or base on fuel #endif } #ifdef _JK2MP parent->think = G_FreeEntity; #else parent->e_ThinkFunc = thinkF_G_FreeEntity; #endif parent->nextthink = level.time + FRAMETIME; }
        portMissing("DeathUpdate", source: "oracle/codemp/game/g_vehicles.c:1485")
    }
}

// Register all the assets used by this vehicle.
/// Source: oracle/codemp/game/g_vehicles.c:1619
private func RegisterAssets(_ pVeh: JKAMP.Vehicle) {
}

// Initialize the vehicle.
/// Source: oracle/codemp/game/g_vehicles.c:1626
func Initialize(_ pVeh: JKAMP.Vehicle) -> Bool {
    let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
    var i: Int32 = 0

    if parent == nil || parent!.client == nil {
        return false
    }

    parent!.client!.ps.m_iVehicleNum = 0
    parent!.s.m_iVehicleNum = 0
    do {
        pVeh.m_iArmor = pVeh.m_pVehicleInfo!.armor
        parent!.client!.ps.stats[STAT_HEALTH] = pVeh.m_iArmor
        parent!.health = parent!.client!.ps.stats[STAT_HEALTH]
        parent!.NPC!.stats.health = parent!.health
        parent!.client!.ps.stats[STAT_MAX_HEALTH] = parent!.NPC!.stats.health
        parent!.client!.pers.maxHealth = parent!.client!.ps.stats[STAT_MAX_HEALTH]
        pVeh.m_iShields = pVeh.m_pVehicleInfo!.shields
        G_VehUpdateShields(parent!)
        parent!.client!.ps.stats[STAT_ARMOR] = pVeh.m_iShields
    }
    parent!.mass = Float(pVeh.m_pVehicleInfo!.mass)
    //initialize the ammo to max
    i = 0
    while i < MAX_VEHICLE_WEAPONS {
        pVeh.weaponStatus[i].ammo = pVeh.m_pVehicleInfo!.weapon[i].ammoMax
        parent!.client!.ps.ammo[i] = pVeh.weaponStatus[i].ammo
        i += 1
    }
    i = 0
    while i < MAX_VEHICLE_TURRETS {
        pVeh.turretStatus[i].nextMuzzle = (pVeh.m_pVehicleInfo!.turret[i].iMuzzle[i] - 1)
        pVeh.turretStatus[i].ammo = pVeh.m_pVehicleInfo!.turret[i].iAmmoMax
        parent!.client!.ps.ammo[MAX_VEHICLE_WEAPONS + i] = pVeh.turretStatus[i].ammo
        if pVeh.m_pVehicleInfo!.turret[i].bAI {
            //they're going to be finding enemies, init this to NONE
            pVeh.turretStatus[i].enemyEntNum = ENTITYNUM_NONE
        }
        i += 1
    }
    //begin stopped...?
    parent!.client!.ps.speed = 0

    pVeh.m_vOrientationVector = vec3_t()
    pVeh.m_vOrientationVector[YAW] = parent!.s.angles[YAW]

    if pVeh.m_pVehicleInfo!.gravity != 0 && pVeh.m_pVehicleInfo!.gravity != g_gravity.value {
        //not normal gravity
        if parent!.NPC != nil {
            parent!.NPC!.aiFlags |= NPCAI_CUSTOM_GRAVITY
        }
        parent!.client!.ps.gravity = pVeh.m_pVehicleInfo!.gravity
    }

    if pVeh.m_pVehicleInfo!.maxPassengers > 0 {
        var i: Int32

        // Allocate an array of entity pointers.
        i = 0
        while i < pVeh.m_pVehicleInfo!.maxPassengers {
            pVeh.m_ppPassengers[i] = nil
            i += 1
        }
    }

    pVeh.m_iNumPassengers = 0
    /*
    if ( pVeh->m_iVehicleTypeID == VH_FIGHTER )
    {
    pVeh->m_ulFlags = VEH_GEARSOPEN;
    }
    else
    */
    //why?! -rww
    do {
        pVeh.m_ulFlags = 0
    }
    pVeh.m_fTimeModifier = 1.0
    pVeh.m_iBoarding = 0
    pVeh.m_bWasBoarding = false
    pVeh.m_pOldPilot = nil
    pVeh.m_vBoardingVelocity = vec3_t()
    pVeh.m_pPilot = nil
    pVeh.m_ucmd.clear()
    pVeh.m_iDieTime = 0
    pVeh.m_EjectDir = VEH_EJECT_LEFT

    //pVeh->m_iDriverTag = -1;
    //pVeh->m_iLeftExhaustTag = -1;
    //pVeh->m_iRightExhaustTag = -1;
    //pVeh->m_iGun1Tag = -1;
    //pVeh->m_iGun1Bone = -1;
    //pVeh->m_iLeftWingBone = -1;
    //pVeh->m_iRightWingBone = -1;
    // Port-note: Raven's `memset( pVeh->m_iExhaustTag, -1, sizeof( int ) * MAX_VEHICLE_EXHAUSTS )` runs over bytes that are not one record with a view.
    // Raven wrote: memset( pVeh->m_iExhaustTag, -1, sizeof( int ) * MAX_VEHICLE_EXHAUSTS )
    portMissing("Initialize", source: "oracle/codemp/game/g_vehicles.c:1626")
    // Port-note: Raven's `memset( pVeh->m_iMuzzleTag, -1, sizeof( int ) * MAX_VEHICLE_MUZZLES )` runs over bytes that are not one record with a view.
    // Raven wrote: memset( pVeh->m_iMuzzleTag, -1, sizeof( int ) * MAX_VEHICLE_MUZZLES )
    portMissing("Initialize", source: "oracle/codemp/game/g_vehicles.c:1626")
    // FIXME! Use external values read from the vehicle data file!
    pVeh.m_iDroidUnitTag = -1

    //initialize to blaster, just since it's a basic weapon and there's no lightsaber crap...?
    parent!.client!.ps.weapon = WP_BLASTER
    parent!.client!.ps.weaponstate = WEAPON_READY
    parent!.client!.ps.stats[STAT_WEAPONS] |= (1 << WP_BLASTER)

    //Initialize to landed (wings closed, gears down) animation
    do {
        let iFlags: Int32 = SETANIM_FLAG_NORMAL
        let iBlend: Int32 = 300
        pVeh.m_ulFlags |= UInt(bitPattern: Int(VEH_GEARSOPEN))
        BG_SetAnim(pVeh.m_pParentEntity!.playerState!, bgAllAnims[pVeh.m_pParentEntity!.localAnimIndex].animsSlots, SETANIM_BOTH, BOTH_VS_IDLE, iFlags, iBlend)
    }

    return true
}

/// Source: oracle/codemp/game/g_vehicles.c:1763
private func Update(_ pVeh: JKAMP.Vehicle, _ pUmcd: JKAMP.Usercmd) -> Bool {
    var parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
    var pilotEnt: Entity?
    //static float fMod = 1000.0f / 60.0f;
    var vVehAngles = vec3_t()
    var i: Int32
    let prevSpeed: Int32
    let nextSpeed: Int32
    let curTime: Int32
    let halfMaxSpeed: Int32
    var parentPS: PlayerState?
    var linkHeld: Bool = false


    maintainSelfDuringBoarding: do {
        parentPS = pVeh.m_pParentEntity!.playerState

        curTime = level.time
        //FIXME: pass in ucmd?  Not sure if this is reliable...

        //increment the ammo for all rechargeable weapons
        i = 0
        while i < MAX_VEHICLE_WEAPONS {
            if pVeh.m_pVehicleInfo!.weapon[i].ID > VEH_WEAPON_BASE && pVeh.m_pVehicleInfo!.weapon[i].ammoRechargeMS != 0 && pVeh.weaponStatus[i].ammo < pVeh.m_pVehicleInfo!.weapon[i].ammoMax && pUmcd.serverTime - pVeh.weaponStatus[i].lastAmmoInc >= pVeh.m_pVehicleInfo!.weapon[i].ammoRechargeMS {
                //add 1 to the ammo
                pVeh.weaponStatus[i].lastAmmoInc = pUmcd.serverTime
                pVeh.weaponStatus[i].ammo += 1
                //NOTE: in order to send the vehicle's ammo info to the client, we copy the ammo into the first 2 ammo slots on the vehicle NPC's client->ps.ammo array
                if parent != nil && parent!.client != nil {
                    parent!.client!.ps.ammo[i] = pVeh.weaponStatus[i].ammo
                }
            }
            i += 1
        }
        i = 0
        while i < MAX_VEHICLE_TURRETS {
            if pVeh.m_pVehicleInfo!.turret[i].iWeapon > VEH_WEAPON_BASE && pVeh.m_pVehicleInfo!.turret[i].iAmmoRechargeMS != 0 && pVeh.turretStatus[i].ammo < pVeh.m_pVehicleInfo!.turret[i].iAmmoMax && pUmcd.serverTime - pVeh.turretStatus[i].lastAmmoInc >= pVeh.m_pVehicleInfo!.turret[i].iAmmoRechargeMS {
                //add 1 to the ammo
                pVeh.turretStatus[i].lastAmmoInc = pUmcd.serverTime
                pVeh.turretStatus[i].ammo += 1
                //NOTE: in order to send the vehicle's ammo info to the client, we copy the ammo into the first 2 ammo slots on the vehicle NPC's client->ps.ammo array
                if parent != nil && parent!.client != nil {
                    parent!.client!.ps.ammo[MAX_VEHICLE_WEAPONS + i] = pVeh.turretStatus[i].ammo
                }
            }
            i += 1
        }

        //increment shields for rechargable shields
        if pVeh.m_pVehicleInfo!.shieldRechargeMS != 0 && parentPS!.stats[STAT_ARMOR] > 0 && parentPS!.stats[STAT_ARMOR] < pVeh.m_pVehicleInfo!.shields && pUmcd.serverTime - pVeh.lastShieldInc >= pVeh.m_pVehicleInfo!.shieldRechargeMS {
            parentPS!.stats[STAT_ARMOR] += 1
            if parentPS!.stats[STAT_ARMOR] > pVeh.m_pVehicleInfo!.shields {
                parentPS!.stats[STAT_ARMOR] = pVeh.m_pVehicleInfo!.shields
            }
            pVeh.m_iShields = parentPS!.stats[STAT_ARMOR]
            G_VehUpdateShields(parent!)
        }

        if parent != nil && parent!.r.ownerNum != parent!.s.owner {
            parent!.s.owner = parent!.r.ownerNum
        }

        //keep the PS value in sync. set it up here in case we return below at some point.
        if pVeh.m_iBoarding != 0 {
            parent!.client!.ps.vehBoarding = true
        } else {
            parent!.client!.ps.vehBoarding = false
        }

        // See whether this vehicle should be dieing or dead.
        if pVeh.m_iDieTime != 0 {
            //NOTE!!!: This HAS to be consistent with cgame!!!
            // Keep track of the old orientation.
            pVeh.m_vPrevOrientation = pVeh.m_vOrientationVector

            // Process the orient commands.
            pVeh.m_pVehicleInfo!.runProcessOrientCommands(pVeh)
            // Need to copy orientation to our entity's viewangles so that it renders at the proper angle and currentAngles is correct.
            SetClientViewAngle(parent!, pVeh.m_vOrientationVector)
            if pVeh.m_pPilot != nil {
                SetClientViewAngle(pVeh.m_pPilot.map { Entity($0) }!, pVeh.m_vOrientationVector)
            }
            /*
            for ( i = 0; i < pVeh->m_pVehicleInfo->maxPassengers; i++ )
            {
            if ( pVeh->m_ppPassengers[i] )
            {
            SetClientViewAngle( (gentity_t *)pVeh->m_ppPassengers[i], pVeh->m_vOrientation );
            }
            }
            */

            // Process the move commands.
            pVeh.m_pVehicleInfo!.runProcessMoveCommands(pVeh)

            // Setup the move direction.
            if pVeh.m_pVehicleInfo!.type == VH_FIGHTER {
                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
                var scratchRight = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
                var scratchUp = vec3_t()
                AngleVectors(pVeh.m_vOrientationVector, &parent!.client!.ps.moveDir, &scratchRight, &scratchUp)
            } else {
                vVehAngles = vec3_t(0, pVeh.m_vOrientationVector[YAW], 0)
                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
                var scratchRight2 = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
                var scratchUp2 = vec3_t()
                AngleVectors(vVehAngles, &parent!.client!.ps.moveDir, &scratchRight2, &scratchUp2)
            }
            pVeh.m_pVehicleInfo!.runDeathUpdate(pVeh)
            return false
        } else if parent!.health <= 0 {
            // Vehicle dead!
            // Instant kill.
            if pVeh.m_pVehicleInfo!.type == VH_FIGHTER && pVeh.m_iLastImpactDmg > 500 {
                //explode instantly in inferno-y death
                pVeh.m_pVehicleInfo!.runStartDeathDelay(pVeh, -1)
            } else {
                pVeh.m_pVehicleInfo!.runStartDeathDelay(pVeh, 0)
            }
            pVeh.m_pVehicleInfo!.runDeathUpdate(pVeh)
            return false
        }

        if (parent!.spawnflags & 1) != 0 {
            if pVeh.m_pPilot != nil || !pVeh.m_bHasHadPilot {
                if pVeh.m_pPilot != nil && !pVeh.m_bHasHadPilot {
                    pVeh.m_bHasHadPilot = true
                    pVeh.m_iPilotLastIndex = pVeh.m_pPilot!.s.number
                }
                pVeh.m_iPilotTime = level.time + parent!.damage
            } else if pVeh.m_iPilotTime != 0 {
                //die
                let oldPilot: Entity? = g_entities[pVeh.m_iPilotLastIndex]

                if !oldPilot!.inuse || oldPilot!.client == nil || oldPilot!.client!.pers.connected != CON_CONNECTED {
                    //no longer in the game?
                    // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
                    var scratchDir = vec3_t()
                    G_Damage(parent!, parent, parent, &scratchDir, parent!.client!.ps.origin, 99999, DAMAGE_NO_PROTECTION, MOD_SUICIDE)
                } else {
                    var v = vec3_t()
                    v = parent!.client!.ps.origin - oldPilot!.client!.ps.origin

                    if VectorLength(v) < parent!.speed {
                        //they are still within the minimum distance to their vehicle
                        pVeh.m_iPilotTime = level.time + parent!.damage
                    } else if pVeh.m_iPilotTime < level.time {
                        //dying time
                        // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                        portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
                        var scratchDir2 = vec3_t()
                        G_Damage(parent!, parent, parent, &scratchDir2, parent!.client!.ps.origin, 99999, DAMAGE_NO_PROTECTION, MOD_SUICIDE)
                    }
                }
            }
        }
        //FIXME: does this give proper credit to the enemy who shot you down?

        //	if (level.time<pVeh->m_iTurboTime || pVeh->m_pVehicleInfo->type==VH_ANIMAL)
        // always knock guys around now...


        if pVeh.m_iBoarding != 0 {
            pilotEnt = pVeh.m_pPilot.map { Entity($0) }
            if pilotEnt != nil {
                if !pilotEnt!.inuse || pilotEnt!.client == nil || pilotEnt!.health <= 0 || pilotEnt!.client!.pers.connected != CON_CONNECTED {
                    pVeh.m_pVehicleInfo!.runEject(pVeh, pVeh.m_pPilot, true)
                    return false
                }
            }
        }

        // If we're not done mounting, can't do anything.
        if pVeh.m_iBoarding != 0 {
            if !pVeh.m_bWasBoarding {
                pVeh.m_vBoardingVelocity = parentPS!.velocity
                pVeh.m_bWasBoarding = true
            }

            // See if we're done boarding.
            if pVeh.m_iBoarding > -1 && pVeh.m_iBoarding <= level.time {
                pVeh.m_bWasBoarding = false
                pVeh.m_iBoarding = 0
            } else {
                break maintainSelfDuringBoarding
            }
        }

        parent = pVeh.m_pParentEntity.map { Entity($0) }

        // Validate vehicle.
        if parent == nil || parent!.client == nil || parent!.health <= 0 {
            return false
        }

        // See if any of the riders are dead and if so kick em off.
        if pVeh.m_pPilot != nil {
            pilotEnt = pVeh.m_pPilot.map { Entity($0) }

            if !pilotEnt!.inuse || pilotEnt!.client == nil || pilotEnt!.health <= 0 || pilotEnt!.client!.pers.connected != CON_CONNECTED {
                pVeh.m_pVehicleInfo!.runEject(pVeh, pVeh.m_pPilot, true)
            }
        }
        // If we're not empty...
        if pVeh.m_iNumPassengers > 0 {
            var psngr: Entity?
            // See if any of these suckers are dead.
            i = 0
            while i < pVeh.m_pVehicleInfo!.maxPassengers {
                psngr = pVeh.m_ppPassengers[i].map { Entity($0) }

                if psngr != nil && (!psngr!.inuse || psngr!.client == nil || psngr!.health <= 0 || psngr!.client!.pers.connected != CON_CONNECTED) {
                    pVeh.m_pVehicleInfo!.runEject(pVeh, pVeh.m_ppPassengers[i], true)
                    pVeh.m_iNumPassengers -= 1
                }
                i += 1
            }
        }

        // Copy over the commands for local storage.
        parent!.client!.pers.cmd.copy(from: pVeh.m_ucmd)
        pVeh.m_ucmd.buttons &= ~(BUTTON_TALK) //|BUTTON_GESTURE); //don't want some of these buttons
        // Copy over the commands for local storage.

        /*
        // Update time modifier.
        pVeh->m_fTimeModifier = pVeh->m_ucmd.serverTime - parent->client->ps.commandTime;
        //sanity check
        if ( pVeh->m_fTimeModifier < 1 )
        {
        pVeh->m_fTimeModifier = 1;
        }
        else if ( pVeh->m_fTimeModifier > 200 )
        {
        pVeh->m_fTimeModifier = 200;
        }
        //normalize to 1.0f at 20fps
        pVeh->m_fTimeModifier = pVeh->m_fTimeModifier / fMod;
        */

        //check for weapon linking/unlinking command
        i = 0
        while i < MAX_VEHICLE_WEAPONS {
            //HMM... can't get a seperate command for each weapon, so do them all...?
            if pVeh.m_pVehicleInfo!.weapon[i].linkable == 2 {
                //always linked
                //FIXME: just set this once, on Initialize...?
                if !pVeh.weaponStatus[i].linked {
                    pVeh.weaponStatus[i].linked = true
                }
            } else if (pVeh.m_ucmd.buttons & BUTTON_USE_HOLDABLE) != 0 {
                //pilot pressed the "weapon link" toggle button
                var pilotPS: PlayerState?
                var rider: BgEntity? = nil
                if parent!.s.owner != ENTITYNUM_NONE {
                    rider = PM_BGEntForNum(parent!.s.owner) //&g_entities[parent->r.ownerNum];
                }
                pilotPS = rider!.playerState
                if !pVeh.linkWeaponToggleHeld {
                    //okay to toggle
                    if pVeh.m_pVehicleInfo!.weapon[i].linkable == 1 {
                        //link-toggleable
                        pVeh.weaponStatus[i].linked = !pVeh.weaponStatus[i].linked
                    }
                }
                linkHeld = true
            }
            i += 1
        }
        if linkHeld {
            //so we don't hold it down and toggle it back and forth
            pVeh.linkWeaponToggleHeld = true
        } else {
            //so we don't hold it down and toggle it back and forth
            pVeh.linkWeaponToggleHeld = false
        }
        //now pass it over the network so cgame knows about it
        //NOTE: SP can just cheat and check directly
        parentPS!.vehWeaponsLinked = false
        i = 0
        while i < MAX_VEHICLE_WEAPONS {
            //HMM... can't get a seperate command for each weapon, so do them all...?
            if pVeh.weaponStatus[i].linked {
                parentPS!.vehWeaponsLinked = true
            }
            i += 1
        }

        i = 0
        while i < MAX_VEHICLE_TURRETS {
            //HMM... can't get a seperate command for each weapon, so do them all...?
            VEH_TurretThink(pVeh, parent!, i)
            i += 1
        }

    }

    if pVeh.m_pPilot != nil && pVeh.m_pPilot!.playerState != nil && pVeh.m_iBoarding != 0 {
        pVeh.m_pPilot!.playerState!.viewangles = pVeh.m_vOrientationVector
        pVeh.m_ucmd.buttons = 0
        pVeh.m_ucmd.forwardmove = 0
        pVeh.m_ucmd.rightmove = 0
        pVeh.m_ucmd.upmove = 0
    }

    // Keep track of the old orientation.
    pVeh.m_vPrevOrientation = pVeh.m_vOrientationVector

    // Process the orient commands.
    pVeh.m_pVehicleInfo!.runProcessOrientCommands(pVeh)
    // Need to copy orientation to our entity's viewangles so that it renders at the proper angle and currentAngles is correct.
    SetClientViewAngle(parent!, pVeh.m_vOrientationVector)
    if pVeh.m_pPilot != nil {
        if !BG_UnrestrainedPitchRoll(pVeh.m_pPilot!.playerState!, pVeh) {
            var newVAngle = vec3_t()
            newVAngle[PITCH] = pVeh.m_pPilot!.playerState!.viewangles[PITCH]
            newVAngle[YAW] = pVeh.m_pPilot!.playerState!.viewangles[YAW]
            newVAngle[ROLL] = pVeh.m_vOrientationVector[ROLL]
            SetClientViewAngle(pVeh.m_pPilot.map { Entity($0) }!, newVAngle)
        }
    }
    /*
    for ( i = 0; i < pVeh->m_pVehicleInfo->maxPassengers; i++ )
    {
    if ( pVeh->m_ppPassengers[i] )
    {
    SetClientViewAngle( (gentity_t *)pVeh->m_ppPassengers[i], pVeh->m_vOrientation );
    }
    }
    */

    // Process the move commands.
    prevSpeed = Int32(parentPS!.speed)
    pVeh.m_pVehicleInfo!.runProcessMoveCommands(pVeh)
    nextSpeed = Int32(parentPS!.speed)
    halfMaxSpeed = Int32(pVeh.m_pVehicleInfo!.speedMax * 0.5)


    // Shifting Sounds
    //=====================================================================
    if pVeh.m_iTurboTime < curTime && pVeh.m_iSoundDebounceTimer < curTime && ((nextSpeed > prevSpeed && nextSpeed > halfMaxSpeed && prevSpeed < halfMaxSpeed) || (nextSpeed > halfMaxSpeed && Q_irand(0, 1000) == 0)) {
        var shiftSound: Int32 = Q_irand(1, 4)
        switch shiftSound {
        case 1:
            shiftSound = pVeh.m_pVehicleInfo!.soundShift1

        case 2:
            shiftSound = pVeh.m_pVehicleInfo!.soundShift2

        case 3:
            shiftSound = pVeh.m_pVehicleInfo!.soundShift3

        case 4:
            shiftSound = pVeh.m_pVehicleInfo!.soundShift4

        default:
            break
        }
        if shiftSound != 0 {
            pVeh.m_iSoundDebounceTimer = curTime + Q_irand(1000, 4000)
            // TODO: MP Shift Sound Playback
            // NOTE: Use this type so it's spatialized and updates play origin as bike moves - MCG
        }
    }
    //=====================================================================


    // Setup the move direction.
    if pVeh.m_pVehicleInfo!.type == VH_FIGHTER {
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
        var scratchRight3 = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
        var scratchUp3 = vec3_t()
        AngleVectors(pVeh.m_vOrientationVector, &parent!.client!.ps.moveDir, &scratchRight3, &scratchUp3)
    } else {
        vVehAngles = vec3_t(0, pVeh.m_vOrientationVector[YAW], 0)
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
        var scratchRight4 = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("Update", source: "oracle/codemp/game/g_vehicles.c:1763")
        var scratchUp4 = vec3_t()
        AngleVectors(vVehAngles, &parent!.client!.ps.moveDir, &scratchRight4, &scratchUp4)
    }

    if pVeh.m_pVehicleInfo!.surfDestruction != 0 {
        if pVeh.m_iRemovedSurfaces != 0 {
            let dmg: Float
            G_VehicleDamageBoxSizing(pVeh)

            //damage him constantly if any chunks are currently taken off

            // 3 seconds max on death.
            dmg = Float(parent!.client!.ps.stats[STAT_MAX_HEALTH]) * pVeh.m_fTimeModifier / 180.0
            //FIXME: aside from bypassing shields, maybe set m_iShields to 0, too... ?
            G_DamageFromKiller(parent!, parent!, parent, parent!.client!.ps.origin, Int32(dmg), DAMAGE_NO_SELF_PROTECTION | DAMAGE_NO_HIT_LOC | DAMAGE_NO_PROTECTION | DAMAGE_NO_ARMOR, MOD_SUICIDE)
        }

        //make sure playerstate value stays in sync
        parent!.client!.ps.vehSurfaces = pVeh.m_iRemovedSurfaces
    }

    //keep the PS value in sync
    if pVeh.m_iBoarding != 0 {
        parent!.client!.ps.vehBoarding = true
    } else {
        parent!.client!.ps.vehBoarding = false
    }

    // Make sure the vehicle takes on the enemy of it's rider (for homing missles for instance).


    return true
}

// Update the properties of a Rider (that may reflect what happens to the vehicle).
/// Source: oracle/codemp/game/g_vehicles.c:2338
private func UpdateRider(_ pVeh: JKAMP.Vehicle, _ pRider: JKAMP.BgEntity, _ pUmcd: JKAMP.Usercmd) -> Bool {
    var parent: Entity?
    var rider: Entity?

    if pVeh.m_iBoarding != 0 && pVeh.m_iDieTime == 0 {
        return true
    }

    parent = pVeh.m_pParentEntity.map { Entity($0) }
    rider = Entity(pRider)
    //MG FIXME !! Single player needs update!
    if rider != nil && rider!.client != nil && parent != nil && parent!.client != nil {
        //so they know who we're locking onto with our rockets, if anyone
        rider!.client!.ps.rocketLockIndex = parent!.client!.ps.rocketLockIndex
        rider!.client!.ps.rocketLockTime = parent!.client!.ps.rocketLockTime
        rider!.client!.ps.rocketTargetTime = parent!.client!.ps.rocketTargetTime
    }
    // Regular exit.
    if (pUmcd.buttons & BUTTON_USE) != 0 && pVeh.m_pVehicleInfo!.type != VH_SPEEDER {
        if pVeh.m_pVehicleInfo!.type == VH_WALKER {
            //just get the fuck out
            pVeh.m_EjectDir = VEH_EJECT_REAR
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
            // Raven wrote: if ( pVeh->m_pVehicleInfo->Eject( pVeh, pRider, qfalse ) ) return false
            portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
        } else if !((pVeh.m_ulFlags & UInt(bitPattern: Int(VEH_FLYING))) != 0) {
            // If going too fast, roll off.
            if (parent!.client!.ps.speed <= 600) && pUmcd.rightmove != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
                // Raven wrote: if ( pVeh->m_pVehicleInfo->Eject( pVeh, pRider, qfalse ) ) { animNumber_t Anim; int iFlags = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD | SETANIM_FLAG_HOLDLESS, iBlend = 300; if ( pUmcd->rightmove > 0 ) { Anim = BOTH_ROLL_R; pVeh->m_EjectDir = VEH_EJECT_RIGHT; } else { Anim = BOTH_ROLL_L; pVeh->m_EjectDir = VEH_EJECT_LEFT; } VectorScale( parent->client->ps.velocity, 0.25f, rider->client->ps.velocity ); #if 1 Vehicle_SetAnim( rider, SETANIM_BOTH, Anim, iFlags, iBlend ); #else #endif //PM_SetAnim(pm,SETANIM_BOTH,anim,SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD|SETANIM_FLAG_HOLDLESS); rider->client->ps.weaponTime = rider->client->ps.torsoAnimTimer - 200;//just to make sure it's cleared when roll is done G_AddEvent( rider, EV_ROLL, 0 ); return false; }
                portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
            } else {
                // FIXME: Check trace to see if we should start playing the animation.
                var Anim: animNumber_t
                let iFlags: Int32 = SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD
                let iBlend: Int32 = 500
                if pUmcd.rightmove > 0 {
                    // Port-note: A store into `Anim`, a local the draft left as a hole.
                    // Raven wrote: Anim = BOTH_VS_DISMOUNT_R
                    portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
                    pVeh.m_EjectDir = VEH_EJECT_RIGHT
                } else {
                    // Port-note: A store into `Anim`, a local the draft left as a hole.
                    // Raven wrote: Anim = BOTH_VS_DISMOUNT_L
                    portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
                    pVeh.m_EjectDir = VEH_EJECT_LEFT
                }

                if pVeh.m_iBoarding <= 1 {
                    let iAnimLen: Int32
                    // NOTE: I know I shouldn't reuse pVeh->m_iBoarding so many times for so many different
                    // purposes, but it's not used anywhere else right here so why waste memory???
                    // Port-note: A read of `Anim`, a local the draft left as a hole.
                    // Raven wrote: iAnimLen = BG_AnimLength( rider->localAnimIndex, Anim )
                    portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
                    pVeh.m_iBoarding = level.time + iAnimLen
                    // Weird huh? Well I wanted to reuse flags and this should never be set in an
                    // entity, so what the heck.
                    rider!.flags |= FL_VEH_BOARDING

                    // Make sure they can't fire when leaving.
                    rider!.client!.ps.weaponTime = iAnimLen
                }

                rider!.client!.ps.velocity = parent!.client!.ps.velocity * 0.25

                // Port-note: A read of `Anim`, a local the draft left as a hole.
                // Raven wrote: Vehicle_SetAnim( rider, SETANIM_BOTH, Anim, iFlags, iBlend )
                portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
            }
        } else {
            // Flying, so just fall off.
            pVeh.m_EjectDir = VEH_EJECT_LEFT
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
            // Raven wrote: if ( pVeh->m_pVehicleInfo->Eject( pVeh, pRider, qfalse ) ) return false
            portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
        }
    }

    // Getting off animation complete (if we had one going)?
    if pVeh.m_iBoarding < level.time && (rider!.flags & FL_VEH_BOARDING) != 0 {
        rider!.flags &= ~FL_VEH_BOARDING
        // Eject this guy now.
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
        // Raven wrote: if ( pVeh->m_pVehicleInfo->Eject( pVeh, pRider, qfalse ) ) { return false; }
        portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
    }

    if pVeh.m_pVehicleInfo!.type != VH_FIGHTER && pVeh.m_pVehicleInfo!.type != VH_WALKER {
        // Jump off.
        if pUmcd.upmove > 0 {
            // NOT IN MULTI PLAYER!
            //===================================================================
            // Eject Player From Current Vehicle
            //-----------------------------------

            // Send Current Vehicle Spinning Out Of Control
            //----------------------------------------------

            // Todo: Throw Old Vehicle Away From The New Vehicle Some
            //-------------------------------------------------------

            // Start Boarding On Enemy's Vehicle
            //-----------------------------------

            // Don't Jump Off If Holding Strafe Key and Moving Fast
            //===================================================================

            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
            // Raven wrote: if ( pVeh->m_pVehicleInfo->Eject( pVeh, pRider, qfalse ) ) { // Allow them to force jump off. VectorScale( parent->client->ps.velocity, 0.5f, rider->client->ps.velocity ); rider->client->ps.velocity[2] += JUMP_VELOCITY; #ifdef _JK2MP rider->client->ps.fd.forceJumpZStart = rider->client->ps.origin[2]; if (!trap_ICARUS_TaskIDPending(rider, TID_CHAN_VOICE)) #else rider->client->ps.pm_flags |= ( PMF_JUMPING | PMF_JUMP_HELD ); rider->client->ps.forceJumpZStart = rider->client->ps.origin[2]; if ( !Q3_TaskIDPending( rider, TID_CHAN_VOICE ) ) #endif { G_AddEvent( rider, EV_JUMP, 0 ); } #if 1 Vehicle_SetAnim( rider, SETANIM_BOTH, BOTH_JUMP1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 300 ); #else #endif return false; }
            portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
        }

        // Roll off.
        if pUmcd.upmove < 0 {
            var Anim: animNumber_t = BOTH_ROLL_B
            pVeh.m_EjectDir = VEH_EJECT_REAR
            if pUmcd.rightmove > 0 {
                // Port-note: A store into `Anim`, a local the draft left as a hole.
                // Raven wrote: Anim = BOTH_ROLL_R
                portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
                pVeh.m_EjectDir = VEH_EJECT_RIGHT
            } else if pUmcd.rightmove < 0 {
                // Port-note: A store into `Anim`, a local the draft left as a hole.
                // Raven wrote: Anim = BOTH_ROLL_L
                portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
                pVeh.m_EjectDir = VEH_EJECT_LEFT
            } else if pUmcd.forwardmove < 0 {
                // Port-note: A store into `Anim`, a local the draft left as a hole.
                // Raven wrote: Anim = BOTH_ROLL_B
                portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
                pVeh.m_EjectDir = VEH_EJECT_REAR
            } else if pUmcd.forwardmove > 0 {
                // Port-note: A store into `Anim`, a local the draft left as a hole.
                // Raven wrote: Anim = BOTH_ROLL_F
                portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
                pVeh.m_EjectDir = VEH_EJECT_FRONT
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'".
            // Raven wrote: if ( pVeh->m_pVehicleInfo->Eject( pVeh, pRider, qfalse ) ) { if ( !(pVeh->m_ulFlags & VEH_FLYING) ) { VectorScale( parent->client->ps.velocity, 0.25f, rider->client->ps.velocity ); #if 1 Vehicle_SetAnim( rider, SETANIM_BOTH, Anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD | SETANIM_FLAG_HOLDLESS, 300 ); #else #endif //PM_SetAnim(pm,SETANIM_BOTH,anim,SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD|SETANIM_FLAG_HOLDLESS); rider->client->ps.weaponTime = rider->client->ps.torsoAnimTimer - 200;//just to make sure it's cleared when roll is done G_AddEvent( rider, EV_ROLL, 0 ); } return false; }
            portMissing("UpdateRider", source: "oracle/codemp/game/g_vehicles.c:2338")
        }
    }

    return true
}

// Attachs all the riders of this vehicle to their appropriate tag (*driver, *pass1, *pass2, whatever...).
/// Source: oracle/codemp/game/g_vehicles.c:2598
private func AttachRiders(_ pVeh: JKAMP.Vehicle) {
    var i: Int32 = 0

    AttachRidersGeneric(pVeh)

    if pVeh.m_pPilot != nil {
        let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
        let pilot: Entity? = pVeh.m_pPilot.map { Entity($0) }
        pilot!.waypoint = parent!.waypoint // take the veh's waypoint as your own

        //assuming we updated him relative to the bolt in AttachRidersGeneric
        G_SetOrigin(pilot!, &pilot!.client!.ps.origin)
        trap_LinkEntity(pilot!)
    }

    if pVeh.m_pOldPilot != nil {
        let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
        let oldpilot: Entity? = pVeh.m_pOldPilot.map { Entity($0) }
        oldpilot!.waypoint = parent!.waypoint // take the veh's waypoint as your own

        //assuming we updated him relative to the bolt in AttachRidersGeneric
        G_SetOrigin(oldpilot!, &oldpilot!.client!.ps.origin)
        trap_LinkEntity(oldpilot!)
    }

    //attach passengers
    while i < pVeh.m_iNumPassengers {
        if pVeh.m_ppPassengers[i] != nil {
            // Raven's record lives to the end of his block, so the block is the closure.
            MdxaBone.scratch { boltMatrix in
                var yawOnlyAngles = vec3_t()
                let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
                let pilot: Entity? = pVeh.m_ppPassengers[i].map { Entity($0) }
                var crotchBolt: Int32 = 0

                crotchBolt = trap_G2API_AddBolt(parent!.ghoul2, 0, "*driver")

                yawOnlyAngles = vec3_t(0, parent!.client!.ps.viewangles[YAW], 0)

                // Get the driver tag.
                trap_G2API_GetBoltMatrix(parent!.ghoul2, 0, crotchBolt, boltMatrix, yawOnlyAngles, parent!.client!.ps.origin, level.time, nil, &parent!.modelScale)
                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &pilot!.client!.ps.origin)

                G_SetOrigin(pilot!, &pilot!.client!.ps.origin)
                trap_LinkEntity(pilot!)
            }
        }
        i += 1
    }

    //attach droid
    if pVeh.m_pDroidUnit != nil && pVeh.m_iDroidUnitTag != -1 {
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in
            var yawOnlyAngles = vec3_t()
            var fwd = vec3_t()
            let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }
            let droid: Entity? = pVeh.m_pDroidUnit.map { Entity($0) }

            //assert(droid->client);

            if droid!.client != nil {
                yawOnlyAngles = vec3_t(0, parent!.client!.ps.viewangles[YAW], 0)

                // Get the droid tag.
                trap_G2API_GetBoltMatrix(parent!.ghoul2, 0, pVeh.m_iDroidUnitTag, boltMatrix, yawOnlyAngles, parent!.r.currentOrigin, level.time, nil, &parent!.modelScale)
                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &droid!.client!.ps.origin)
                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &fwd)
                vectoangles(fwd, &droid!.client!.ps.viewangles)

                G_SetOrigin(droid!, &droid!.client!.ps.origin)
                G_SetAngles(droid!, droid!.client!.ps.viewangles)
                SetClientViewAngle(droid!, droid!.client!.ps.viewangles)
                trap_LinkEntity(droid!)

                if droid!.NPC != nil {
                    NPC_SetAnim(droid!, SETANIM_BOTH, BOTH_STAND2, (SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD))
                    droid!.client!.ps.legsTimer = 500
                    droid!.client!.ps.torsoTimer = 500
                }
            }
        }
    }
    // If we have a pilot, attach him to the driver tag.


    // Get the driver tag.
    // If we have a pilot, attach him to the driver tag.


    // Get the driver tag.
}

// Make someone invisible and un-collidable.
/// Source: oracle/codemp/game/g_vehicles.c:2734
private func Ghost(_ pVeh: JKAMP.Vehicle, _ pEnt: JKAMP.BgEntity) {
    var ent: Entity?


    ent = Entity(pEnt)

    // This was introduced to prevent one extra entity from being sent to the clients
    ent!.r.svFlags |= SVF_NOCLIENT

    ent!.s.eFlags |= EF_NODRAW
    if ent!.client != nil {
        ent!.client!.ps.eFlags |= EF_NODRAW
    }
    ent!.r.contents = 0
}

// Make someone visible and collidable.
/// Source: oracle/codemp/game/g_vehicles.c:2759
private func UnGhost(_ pVeh: JKAMP.Vehicle, _ pEnt: JKAMP.BgEntity) {
    var ent: Entity?


    ent = Entity(pEnt)

    // make sure the client is sent again
    ent!.r.svFlags &= ~SVF_NOCLIENT

    ent!.s.eFlags &= ~EF_NODRAW
    if ent!.client != nil {
        ent!.client!.ps.eFlags &= ~EF_NODRAW
    }
    ent!.r.contents = CONTENTS_BODY
}

//try to resize the bounding box around a torn apart ship
/// Source: oracle/codemp/game/g_vehicles.c:2785
func G_VehicleDamageBoxSizing(_ pVeh: JKAMP.Vehicle) {
    var fwd = vec3_t()
    var right = vec3_t()
    var up = vec3_t()
    var nose = vec3_t()
    var back = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        let fDist: Float = 256.0
        let bDist: Float = 256.0
        let wDist: Float = 32.0
        let hDist: Float = 32.0
        let parent: Entity? = pVeh.m_pParentEntity.map { Entity($0) }

        if parent!.ghoul2 == nil || parent!.m_pVehicle == nil || parent!.client == nil {
            //shouldn't have gotten in here then
            return true
        }

        //for now, let's only do anything if all wings are stripped off.
        //this is because I want to be able to tear my wings off and fling
        //myself down narrow hallways to my death. Because it's fun! -rww
        if !((pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_C) != 0) || !((pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_D) != 0) || !((pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_E) != 0) || !((pVeh.m_iRemovedSurfaces & SHIPSURF_BROKEN_F) != 0) {
            return true
        }

        //get directions based on orientation
        AngleVectors(pVeh.m_vOrientationVector, &fwd, &right, &up)

        //get the nose and back positions (relative to 0, they're gonna be mins/maxs)
        _VectorMA(vec3_origin, fDist, fwd, &nose)
        _VectorMA(vec3_origin, -bDist, fwd, &back)

        //move the nose and back to opposite right/left, they will end up as our relative mins and maxs
        _VectorMA(nose, wDist, right, &nose)
        _VectorMA(nose, -wDist, right, &back)

        //use the same concept for up/down now
        _VectorMA(nose, hDist, up, &nose)
        _VectorMA(nose, -hDist, up, &back)

        //and now, let's trace and see if our new mins/maxs are safe..
        trap_Trace(trace, parent!.client!.ps.origin, back, nose, parent!.client!.ps.origin, parent!.s.number, parent!.clipmask)
        if trace.allsolid == 0 && trace.startsolid == 0 && trace.fraction == 1.0 {
            //all clear!
            parent!.r.maxs = nose
            parent!.r.mins = back
        } else {
            //oh well, DIE!
            //FIXME: does this give proper credit to the enemy who shot you down?
            // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("G_VehicleDamageBoxSizing", source: "oracle/codemp/game/g_vehicles.c:2785")
            var scratchDir = vec3_t()
            G_Damage(parent!, parent, parent, &scratchDir, parent!.client!.ps.origin, 9999, DAMAGE_NO_PROTECTION, MOD_SUICIDE)
        }
        return false
    }
    if earlyOut {
        return
    }
}

//get one of 4 possible impact locations based on the trace direction
/// Source: oracle/codemp/game/g_vehicles.c:2843
func G_FlyVehicleImpactDir(_ veh: Entity, _ trace: JKAMP.Trace) -> Int32 {
    var impactAngle: Float = 0
    var relativeAngle: Float = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { localTrace -> Int32 in
        var testMins = vec3_t()
        var testMaxs = vec3_t()
        var rWing = vec3_t()
        var lWing = vec3_t()
        var fwd = vec3_t()
        var right = vec3_t()
        var fPos = vec3_t()
        let pVeh: Vehicle? = veh.m_pVehicle
        var noseClear: Bool = false

        if pVeh == nil || veh.client == nil {
            return -1
        }

        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("G_FlyVehicleImpactDir", source: "oracle/codemp/game/g_vehicles.c:2843")
        var scratchUp = vec3_t()
        AngleVectors(veh.client!.ps.viewangles, &fwd, &right, &scratchUp)
        testMins = vec3_t(-24.0, -24.0, -24.0)
        testMaxs = vec3_t(24.0, 24.0, 24.0)

        //do a trace to determine if the nose is clear
        _VectorMA(veh.client!.ps.origin, 256.0, fwd, &fPos)
        trap_Trace(localTrace, veh.client!.ps.origin, testMins, testMaxs, fPos, veh.s.number, veh.clipmask)
        if localTrace.startsolid == 0 && localTrace.allsolid == 0 && localTrace.fraction == 1.0 {
            //otherwise I guess it's not clear..
            noseClear = true
        }

        if noseClear {
            //if nose is clear check for tearing the wings off
            //sadly, the trace endpos given always matches the vehicle origin, so we
            //can't get a real impact direction. First we'll trace forward and see if the wings are colliding
            //with anything, and if not, we'll fall back to checking the trace plane normal.
            _VectorMA(veh.client!.ps.origin, 128.0, right, &rWing)
            _VectorMA(veh.client!.ps.origin, -128.0, right, &lWing)

            //test the right wing - unless it's already removed
            if !((pVeh!.m_iRemovedSurfaces & SHIPSURF_BROKEN_E) != 0) || !((pVeh!.m_iRemovedSurfaces & SHIPSURF_BROKEN_F) != 0) {
                _VectorMA(rWing, 256.0, fwd, &fPos)
                trap_Trace(localTrace, rWing, testMins, testMaxs, fPos, veh.s.number, veh.clipmask)
                if localTrace.startsolid != 0 || localTrace.allsolid != 0 || localTrace.fraction != 1.0 {
                    //impact
                    return SHIPSURF_RIGHT
                }
            }

            //test the left wing - unless it's already removed
            if !((pVeh!.m_iRemovedSurfaces & SHIPSURF_BROKEN_C) != 0) || !((pVeh!.m_iRemovedSurfaces & SHIPSURF_BROKEN_D) != 0) {
                _VectorMA(lWing, 256.0, fwd, &fPos)
                trap_Trace(localTrace, lWing, testMins, testMaxs, fPos, veh.s.number, veh.clipmask)
                if localTrace.startsolid != 0 || localTrace.allsolid != 0 || localTrace.fraction != 1.0 {
                    //impact
                    return SHIPSURF_LEFT
                }
            }
        }

        //try to use the trace plane normal
        impactAngle = vectoyaw(trace.plane.normal)
        relativeAngle = AngleSubtract(impactAngle, veh.client!.ps.viewangles[YAW])

        if relativeAngle > 130 || relativeAngle < -130 {
            //consider this front
            return SHIPSURF_FRONT
        } else if relativeAngle > 0 {
            return SHIPSURF_RIGHT
        } else if relativeAngle < 0 {
            return SHIPSURF_LEFT
        }

        return SHIPSURF_BACK
    }
}

/// Source: oracle/codemp/game/g_vehicles.c:2930
func G_ShipSurfaceForSurfName(_ surfaceName: String) -> Int32 {
    if Q_strncmp("nose", surfaceName, 4) == 0 || Q_strncmp("f_gear", surfaceName, 6) == 0 || Q_strncmp("glass", surfaceName, 5) == 0 {
        return SHIPSURF_FRONT
    }
    if Q_strncmp("body", surfaceName, 4) == 0 {
        return SHIPSURF_BACK
    }
    if Q_strncmp("r_wing1", surfaceName, 7) == 0 || Q_strncmp("r_wing2", surfaceName, 7) == 0 || Q_strncmp("r_gear", surfaceName, 6) == 0 {
        return SHIPSURF_RIGHT
    }
    if Q_strncmp("l_wing1", surfaceName, 7) == 0 || Q_strncmp("l_wing2", surfaceName, 7) == 0 || Q_strncmp("l_gear", surfaceName, 6) == 0 {
        return SHIPSURF_LEFT
    }
    return -1
}

/// Source: oracle/codemp/game/g_vehicles.c:2961
func G_SetVehDamageFlags(_ veh: Entity, _ shipSurf: Int32, _ damageLevel: Int32) {
    var dmgFlag: Int32
    switch damageLevel {
    case 3:
        //add both flags so cgame side knows this surf is GONE
        //add heavy
        dmgFlag = SHIPSURF_DAMAGE_FRONT_HEAVY + (shipSurf - SHIPSURF_FRONT)
        veh.client!.ps.brokenLimbs |= (1 << dmgFlag)
        //add light
        dmgFlag = SHIPSURF_DAMAGE_FRONT_LIGHT + (shipSurf - SHIPSURF_FRONT)
        veh.client!.ps.brokenLimbs |= (1 << dmgFlag)
        //copy down
        veh.s.brokenLimbs = veh.client!.ps.brokenLimbs
        //check droid
        if shipSurf == SHIPSURF_BACK {
            //destroy the droid if we have one
            if veh.m_pVehicle != nil && veh.m_pVehicle!.m_pDroidUnit != nil {
                //we have one
                let droidEnt: Entity? = veh.m_pVehicle!.m_pDroidUnit.map { Entity($0) }
                if droidEnt != nil && ((droidEnt!.flags & FL_UNDYING) != 0 || droidEnt!.health > 0) {
                    //boom
                    //make it vulnerable
                    droidEnt!.flags &= ~FL_UNDYING
                    //blow it up
                    // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("G_SetVehDamageFlags", source: "oracle/codemp/game/g_vehicles.c:2961")
                    var scratchDir = vec3_t()
                    G_Damage(droidEnt!, veh.enemy, veh.enemy, &scratchDir, nil, 99999, 0, MOD_UNKNOWN)
                }
            }
        }

    case 2:
        dmgFlag = SHIPSURF_DAMAGE_FRONT_HEAVY + (shipSurf - SHIPSURF_FRONT)
        veh.client!.ps.brokenLimbs |= (1 << dmgFlag)
        //remove light
        dmgFlag = SHIPSURF_DAMAGE_FRONT_LIGHT + (shipSurf - SHIPSURF_FRONT)
        veh.client!.ps.brokenLimbs &= ~(1 << dmgFlag)
        //copy down
        veh.s.brokenLimbs = veh.client!.ps.brokenLimbs
        //check droid
        if shipSurf == SHIPSURF_BACK {
            //make the droid vulnerable if we have one
            if veh.m_pVehicle != nil && veh.m_pVehicle!.m_pDroidUnit != nil {
                //we have one
                let droidEnt: Entity? = veh.m_pVehicle!.m_pDroidUnit.map { Entity($0) }
                if droidEnt != nil && (droidEnt!.flags & FL_UNDYING) != 0 {
                    //make it vulnerab;e
                    droidEnt!.flags &= ~FL_UNDYING
                }
            }
        }

    case 1:
        //add light
        dmgFlag = SHIPSURF_DAMAGE_FRONT_LIGHT + (shipSurf - SHIPSURF_FRONT)
        veh.client!.ps.brokenLimbs |= (1 << dmgFlag)
        //remove heavy (shouldn't have to do this, but...
        dmgFlag = SHIPSURF_DAMAGE_FRONT_HEAVY + (shipSurf - SHIPSURF_FRONT)
        veh.client!.ps.brokenLimbs &= ~(1 << dmgFlag)
        //copy down
        veh.s.brokenLimbs = veh.client!.ps.brokenLimbs

    default:
        //remove heavy
        dmgFlag = SHIPSURF_DAMAGE_FRONT_HEAVY + (shipSurf - SHIPSURF_FRONT)
        veh.client!.ps.brokenLimbs &= ~(1 << dmgFlag)
        //remove light
        dmgFlag = SHIPSURF_DAMAGE_FRONT_LIGHT + (shipSurf - SHIPSURF_FRONT)
        veh.client!.ps.brokenLimbs &= ~(1 << dmgFlag)
        //copy down
        veh.s.brokenLimbs = veh.client!.ps.brokenLimbs
    }
}

/// Source: oracle/codemp/game/g_vehicles.c:3041
func G_VehicleSetDamageLocFlags(_ veh: Entity, _ impactDir: Int32, _ deathPoint: Int32) {
    // Raven assigns his own `deathPoint` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var deathPoint = deathPoint
    if veh.client == nil {
        return
    } else {
        var deathPoint: Int32
        let heavyDamagePoint: Int32
        let lightDamagePoint: Int32
        switch impactDir {
        case SHIPSURF_FRONT:
            deathPoint = veh.m_pVehicle!.m_pVehicleInfo!.health_front

        case SHIPSURF_BACK:
            deathPoint = veh.m_pVehicle!.m_pVehicleInfo!.health_back

        case SHIPSURF_RIGHT:
            deathPoint = veh.m_pVehicle!.m_pVehicleInfo!.health_right

        case SHIPSURF_LEFT:
            deathPoint = veh.m_pVehicle!.m_pVehicleInfo!.health_left

        default:
            return
        }
        if veh.m_pVehicle != nil && veh.m_pVehicle!.m_pVehicleInfo != nil && veh.m_pVehicle!.m_pVehicleInfo!.malfunctionArmorLevel != 0 && veh.m_pVehicle!.m_pVehicleInfo!.armor != 0 {
            var perc: Float = (Float(veh.m_pVehicle!.m_pVehicleInfo!.malfunctionArmorLevel) / Float(veh.m_pVehicle!.m_pVehicleInfo!.armor))
            if perc > 0.99 {
                perc = 0.99
            }
            lightDamagePoint = Int32(ceil(deathPoint * perc * 0.25))
            heavyDamagePoint = Int32(ceil(deathPoint * perc))
        } else {
            heavyDamagePoint = Int32(ceil(deathPoint * 0.66))
            lightDamagePoint = Int32(ceil(deathPoint * 0.14))
        }

        if veh.locationDamage[impactDir] >= deathPoint {
            //destroyed
            G_SetVehDamageFlags(veh, impactDir, 3)
        } else if veh.locationDamage[impactDir] <= lightDamagePoint {
            //light only
            G_SetVehDamageFlags(veh, impactDir, 1)
        } else if veh.locationDamage[impactDir] <= heavyDamagePoint {
            //heavy only
            G_SetVehDamageFlags(veh, impactDir, 2)
        }
    }
}

/// Source: oracle/codemp/game/g_vehicles.c:3102
func G_FlyVehicleDestroySurface(_ veh: Entity, _ surface: Int32) -> Bool {
    // Port-note: A local `char *[4] surfName` the table has no type for.
    // Raven wrote: char *surfName[4];
    portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")
    var numSurfs: Int32 = 0
    var smashedBits: Int32 = 0

    if surface == -1 {
        //not valid?
        return false
    }

    switch surface {
    case SHIPSURF_FRONT:
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[0] = "nose"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")

        smashedBits = (SHIPSURF_BROKEN_G)

        numSurfs = 1

    case SHIPSURF_BACK:
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[0] = "r_wing2"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[1] = "l_wing2"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")

        //get rid of the landing gear
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[2] = "r_gear"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[3] = "l_gear"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")

        smashedBits = (SHIPSURF_BROKEN_A | SHIPSURF_BROKEN_B | SHIPSURF_BROKEN_D | SHIPSURF_BROKEN_F)

        numSurfs = 4

    case SHIPSURF_RIGHT:
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[0] = "r_wing1"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[1] = "r_wing2"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")

        //get rid of the landing gear
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[2] = "r_gear"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")

        smashedBits = (SHIPSURF_BROKEN_B | SHIPSURF_BROKEN_E | SHIPSURF_BROKEN_F)

        numSurfs = 3

    case SHIPSURF_LEFT:
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[0] = "l_wing1"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[1] = "l_wing2"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")

        //get rid of the landing gear
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: surfName[2] = "l_gear"
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")

        smashedBits = (SHIPSURF_BROKEN_A | SHIPSURF_BROKEN_C | SHIPSURF_BROKEN_D)

        numSurfs = 3

    default:
        break
    }

    if numSurfs < 1 {
        //didn't get any valid surfs..
        return false
    }

    while numSurfs > 0 {
        //use my silly system of automatically managing surf status on both client and server
        numSurfs -= 1
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: NPC_SetSurfaceOnOff(veh, surfName[numSurfs], TURN_OFF)
        portMissing("G_FlyVehicleDestroySurface", source: "oracle/codemp/game/g_vehicles.c:3102")
    }

    if veh.m_pVehicle!.m_iRemovedSurfaces == 0 {
        //first time something got blown off
        if veh.m_pVehicle!.m_pPilot != nil {
            //make the pilot scream to his death
            G_EntitySound(veh.m_pVehicle!.m_pPilot.map { Entity($0) }!, CHAN_VOICE, G_SoundIndex("*falling1.wav"))
        }
    }
    //so we can check what's broken
    veh.m_pVehicle!.m_iRemovedSurfaces |= smashedBits

    //do some explosive damage, but don't damage this ship with it
    G_RadiusDamage(veh.client!.ps.origin, veh, 100, 500, veh, nil, MOD_VEH_EXPLOSION)

    //when spiraling to your death, do the electical shader
    veh.client!.ps.electrifyTime = level.time + 10000

    return true
}

/// Source: oracle/codemp/game/g_vehicles.c:3190
func G_FlyVehicleSurfaceDestruction(_ veh: Entity, _ trace: JKAMP.Trace, _ magnitude: Int32, _ force: Bool) {
    var impactDir: Int32
    let secondImpact: Int32
    var deathPoint: Int32 = -1
    var alreadyRebroken: Bool = false

    if veh.ghoul2 == nil || veh.m_pVehicle == nil {
        //no g2 instance.. or no vehicle instance
        return
    }

    impactDir = G_FlyVehicleImpactDir(veh, trace)

    anotherImpact: while true {
        if impactDir == -1 {
            //not valid?
            return
        }

        veh.locationDamage[impactDir] += magnitude * 7

        switch impactDir {
        case SHIPSURF_FRONT:
            deathPoint = veh.m_pVehicle!.m_pVehicleInfo!.health_front

        case SHIPSURF_BACK:
            deathPoint = veh.m_pVehicle!.m_pVehicleInfo!.health_back

        case SHIPSURF_RIGHT:
            deathPoint = veh.m_pVehicle!.m_pVehicleInfo!.health_right

        case SHIPSURF_LEFT:
            deathPoint = veh.m_pVehicle!.m_pVehicleInfo!.health_left

        default:
            break
        }

        if deathPoint != -1 {
            //got a valid health value
            if force && veh.locationDamage[impactDir] < deathPoint {
                //force that surf to be destroyed
                veh.locationDamage[impactDir] = deathPoint
            }
            if veh.locationDamage[impactDir] >= deathPoint {
                //do it
                if G_FlyVehicleDestroySurface(veh, impactDir) {
                    //actually took off a surface
                    G_VehicleSetDamageLocFlags(veh, impactDir, deathPoint)
                }
            } else {
                G_VehicleSetDamageLocFlags(veh, impactDir, deathPoint)
            }
        }

        if !alreadyRebroken {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "immutable value 'secondImpact' may only be initialized once".
            // Raven wrote: secondImpact = G_FlyVehicleImpactDir(veh, trace)
            portMissing("G_FlyVehicleSurfaceDestruction", source: "oracle/codemp/game/g_vehicles.c:3190")
            if impactDir != secondImpact {
                //can break off another piece in this same impact.. but only break off up to 2 at once
                alreadyRebroken = true
                impactDir = secondImpact
                continue anotherImpact
            }
        }
        break
    }
}

/// Source: oracle/codemp/game/g_vehicles.c:3261
func G_VehUpdateShields(_ targ: Entity) {
    if targ.client == nil || targ.m_pVehicle == nil || targ.m_pVehicle!.m_pVehicleInfo == nil {
        return
    }
    if targ.m_pVehicle!.m_pVehicleInfo!.shields <= 0 {
        //doesn't have shields, so don't have to send it
        return
    }
    targ.client!.ps.activeForcePass = Int32(floor((Float(targ.m_pVehicle!.m_iShields) / Float(targ.m_pVehicle!.m_pVehicleInfo!.shields)) * 10.0))
}

// Set the parent entity of this Vehicle NPC.
/// Source: oracle/codemp/game/g_vehicles.c:3277
func SetParent(_ pVeh: JKAMP.Vehicle, _ pParentEntity: JKAMP.BgEntity) {
    pVeh.m_pParentEntity = pParentEntity
}

// Add a pilot to the vehicle.
/// Source: oracle/codemp/game/g_vehicles.c:3280
func SetPilot(_ pVeh: JKAMP.Vehicle, _ pPilot: JKAMP.BgEntity) {
    pVeh.m_pPilot = pPilot
}

// Add a passenger to the vehicle (false if we're full).
/// Source: oracle/codemp/game/g_vehicles.c:3283
func AddPassenger(_ pVeh: JKAMP.Vehicle) -> Bool {
    return false
}

// Whether this vehicle is currently inhabited (by anyone) or not.
/// Source: oracle/codemp/game/g_vehicles.c:3286
func Inhabited(_ pVeh: JKAMP.Vehicle) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Bool' to expected argument type 'Int'".
    // Raven wrote: return ( pVeh->m_pPilot || pVeh->m_iNumPassengers ) ? true : false
    portMissing("Inhabited", source: "oracle/codemp/game/g_vehicles.c:3286")
}

// Setup the shared functions (one's that all vehicles would generally use).
/// Source: oracle/codemp/game/g_vehicles.c:3290
func G_SetSharedVehicleFunctions(_ pVehInfo: JKAMP.VehicleInfo) {
    //	pVehInfo->AnimateVehicle				=		AnimateVehicle;
    //	pVehInfo->AnimateRiders					=		AnimateRiders;
    pVehInfo.ValidateBoard = VehicleInfoThunks.ValidateBoard
    pVehInfo.SetParent = VehicleInfoThunks.SetParent
    pVehInfo.SetPilot = VehicleInfoThunks.SetPilot
    pVehInfo.AddPassenger = VehicleInfoThunks.AddPassenger
    pVehInfo.Animate = VehicleInfoThunks.Animate
    pVehInfo.Board = VehicleInfoThunks.Board
    pVehInfo.Eject = VehicleInfoThunks.Eject
    pVehInfo.EjectAll = VehicleInfoThunks.EjectAll
    pVehInfo.StartDeathDelay = VehicleInfoThunks.StartDeathDelay
    pVehInfo.DeathUpdate = VehicleInfoThunks.DeathUpdate
    pVehInfo.RegisterAssets = VehicleInfoThunks.RegisterAssets
    pVehInfo.Initialize = VehicleInfoThunks.Initialize
    pVehInfo.Update = VehicleInfoThunks.Update
    pVehInfo.UpdateRider = VehicleInfoThunks.UpdateRider
    //	pVehInfo->ProcessMoveCommands			=		ProcessMoveCommands;
    //	pVehInfo->ProcessOrientCommands			=		ProcessOrientCommands;
    pVehInfo.AttachRiders = VehicleInfoThunks.AttachRiders
    pVehInfo.Ghost = VehicleInfoThunks.Ghost
    pVehInfo.UnGhost = VehicleInfoThunks.UnGhost
    pVehInfo.Inhabited = VehicleInfoThunks.Inhabited
}

/// One static per function this file stores in a `VehicleInfo` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum VehicleInfoThunks {
    /// Source: oracle/codemp/game/g_vehicles.c:3283
    static let AddPassenger: VehicleInfoAddPassenger = { JKAMP_GameLogic.AddPassenger(JKAMP.Vehicle(handle: $0!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/g_vehicles.c:481
    static let Animate: VehicleInfoAnimate = { JKAMP_GameLogic.Animate(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/g_vehicles.c:2598
    static let AttachRiders: VehicleInfoAttachRiders = { JKAMP_GameLogic.AttachRiders(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/g_vehicles.c:630
    static let Board: VehicleInfoBoard = { JKAMP_GameLogic.Board(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/g_vehicles.c:1485
    static let DeathUpdate: VehicleInfoDeathUpdate = { JKAMP_GameLogic.DeathUpdate(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/g_vehicles.c:1019
    static let Eject: VehicleInfoEject = { JKAMP_GameLogic.Eject(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!), $2 != 0) ? 1 : 0 }

    /// Source: oracle/codemp/game/g_vehicles.c:1377
    static let EjectAll: VehicleInfoEjectAll = { JKAMP_GameLogic.EjectAll(JKAMP.Vehicle(handle: $0!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/g_vehicles.c:2734
    static let Ghost: VehicleInfoGhost = { JKAMP_GameLogic.Ghost(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!)) }

    /// Source: oracle/codemp/game/g_vehicles.c:3286
    static let Inhabited: VehicleInfoInhabited = { JKAMP_GameLogic.Inhabited(JKAMP.Vehicle(handle: $0!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/g_vehicles.c:1626
    static let Initialize: VehicleInfoInitialize = { JKAMP_GameLogic.Initialize(JKAMP.Vehicle(handle: $0!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/g_vehicles.c:1619
    static let RegisterAssets: VehicleInfoRegisterAssets = { JKAMP_GameLogic.RegisterAssets(JKAMP.Vehicle(handle: $0!)) }

    /// Source: oracle/codemp/game/g_vehicles.c:3277
    static let SetParent: VehicleInfoSetParent = { JKAMP_GameLogic.SetParent(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!)) }

    /// Source: oracle/codemp/game/g_vehicles.c:3280
    static let SetPilot: VehicleInfoSetPilot = { JKAMP_GameLogic.SetPilot(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!)) }

    /// Source: oracle/codemp/game/g_vehicles.c:1451
    static let StartDeathDelay: VehicleInfoStartDeathDelay = { JKAMP_GameLogic.StartDeathDelay(JKAMP.Vehicle(handle: $0!), $1) }

    /// Source: oracle/codemp/game/g_vehicles.c:2759
    static let UnGhost: VehicleInfoUnGhost = { JKAMP_GameLogic.UnGhost(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!)) }

    /// Source: oracle/codemp/game/g_vehicles.c:1763
    static let Update: VehicleInfoUpdate = { JKAMP_GameLogic.Update(JKAMP.Vehicle(handle: $0!), JKAMP.Usercmd(handle: $1!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/g_vehicles.c:2338
    static let UpdateRider: VehicleInfoUpdateRider = { JKAMP_GameLogic.UpdateRider(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!), JKAMP.Usercmd(handle: $2!)) ? 1 : 0 }

    /// Source: oracle/codemp/game/g_vehicles.c:496
    static let ValidateBoard: VehicleInfoValidateBoard = { JKAMP_GameLogic.ValidateBoard(JKAMP.Vehicle(handle: $0!), JKAMP.BgEntity(handle: $1!)) ? 1 : 0 }
}
