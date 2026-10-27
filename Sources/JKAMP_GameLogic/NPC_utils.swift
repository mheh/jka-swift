import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_utils.c:7
var teamNumbers: [Int32] {
    get { world.variables.teamNumbers }
    set { world.variables.teamNumbers = newValue }
}

/// Source: oracle/codemp/game/NPC_utils.c:8
var teamStrength: [Int32] {
    get { world.variables.teamStrength }
    set { world.variables.teamStrength = newValue }
}

/// Source: oracle/codemp/game/NPC_utils.c:9
// Raven wrote: int teamCounter[TEAM_NUM_TEAMS]
let teamCounter: [Int32] = [Int32](repeating: 0, count: 4)

/// Source: oracle/codemp/game/NPC_utils.c:11
let VALID_ATTACK_CONE = 2.0 as Float

/// Source: oracle/codemp/game/NPC_utils.c:998
private let TURN_ON = 0x00000000 as Int32

/// Source: oracle/codemp/game/NPC_utils.c:999
private let TURN_OFF = 0x00000100 as Int32

/// Source: oracle/codemp/game/NPC_utils.c:1243
private let MAX_RADIUS_ENTS = 256 as Int32

/// Source: oracle/codemp/game/NPC_utils.c:1244
let NEAR_DEFAULT_RADIUS = 256 as Int32

/**
```
void CalcEntitySpot ( gentity_t *ent, spot_t spot, vec3_t point )

Added: Uses shootAngles if a NPC has them
```
*/
/// Source: oracle/codemp/game/NPC_utils.c:20
func CalcEntitySpot(_ ent: Entity, _ spot: spot_t, _ point: inout JKAShared.vec3_t) {
    var forward = vec3_t()
    var up = vec3_t()
    var right = vec3_t()
    var start = vec3_t()
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        switch spot {
        case SPOT_ORIGIN:
            if VectorCompare(ent.r.currentOrigin, vec3_origin) != 0 {
                //brush
                point = ent.r.absmax - ent.r.absmin //size
                _VectorMA(ent.r.absmin, 0.5, point, &point)
            } else {
                point = ent.r.currentOrigin
            }

        case SPOT_CHEST, SPOT_HEAD:
            if ent.client != nil && VectorLengthSquared(ent.client!.renderInfo.eyePoint) != 0 {
                //Actual tag_head eyespot!
                //FIXME: Stasis aliens may have a problem here...
                point = ent.client!.renderInfo.eyePoint
                if ent.client!.NPC_class == CLASS_ATST {
                    //adjust up some
                    point[2] += 28 //magic number :)
                }
                if ent.NPC != nil {
                    //always aim from the center of my bbox, so we don't wiggle when we lean forward or backwards
                    point[0] = ent.r.currentOrigin[0]
                    point[1] = ent.r.currentOrigin[1]
                }
                /*
                else if (ent->s.eType == ET_PLAYER )
                {
                SubtractLeanOfs( ent, point );
                }
                */
            } else {
                point = ent.r.currentOrigin
                if ent.client != nil {
                    point[2] += ent.client!.ps.viewheight
                }
            }
            if spot == SPOT_CHEST && ent.client != nil {
                if ent.client!.NPC_class != CLASS_ATST {
                    //adjust up some
                    point[2] -= ent.r.maxs[2] * 0.2
                }
            }

        case SPOT_HEAD_LEAN:
            if ent.client != nil && VectorLengthSquared(ent.client!.renderInfo.eyePoint) != 0 {
                //Actual tag_head eyespot!
                //FIXME: Stasis aliens may have a problem here...
                point = ent.client!.renderInfo.eyePoint
                if ent.client!.NPC_class == CLASS_ATST {
                    //adjust up some
                    point[2] += 28 //magic number :)
                }
                if ent.NPC != nil {
                    //always aim from the center of my bbox, so we don't wiggle when we lean forward or backwards
                    point[0] = ent.r.currentOrigin[0]
                    point[1] = ent.r.currentOrigin[1]
                }
                /*
                else if ( ent->s.eType == ET_PLAYER )
                {
                SubtractLeanOfs( ent, point );
                }
                */
                //NOTE: automatically takes leaning into account!
            } else {
                point = ent.r.currentOrigin
                if ent.client != nil {
                    point[2] += ent.client!.ps.viewheight
                }
                //AddLeanOfs ( ent, point );
            }
            //FIXME: implement...
            //case SPOT_CHEST:
            //Returns point 3/4 from tag_torso to tag_head?
            //break;

        case SPOT_LEGS:
            point = ent.r.currentOrigin
            point[2] = Float(Double(point[2]) + (Double(ent.r.mins[2]) * 0.5))

        case SPOT_WEAPON:
            if ent.NPC != nil && VectorCompare(ent.NPC!.shootAngles, vec3_origin) == 0 && VectorCompare(ent.NPC!.shootAngles, ent.client!.ps.viewangles) == 0 {
                AngleVectors(ent.NPC!.shootAngles, &forward, &right, &up)
            } else {
                AngleVectors(ent.client!.ps.viewangles, &forward, &right, &up)
            }
            CalcMuzzlePoint(ent, forward, right, up, &point)

        case SPOT_GROUND:
            // if entity is on the ground, just use it's absmin
            if ent.s.groundEntityNum != -1 {
                point = ent.r.currentOrigin
                point[2] = ent.r.absmin[2]
                break
            }

            // if it is reasonably close to the ground, give the point underneath of it
            start = ent.r.currentOrigin
            start[2] = ent.r.absmin[2]
            end = start
            end[2] -= 64
            trap_Trace(tr, start, ent.r.mins, ent.r.maxs, end, ent.s.number, MASK_PLAYERSOLID)
            if Double(tr.fraction) < 1.0 {
                point = tr.endpos
                break
            }

            // otherwise just use the origin
            point = ent.r.currentOrigin

        default:
            point = ent.r.currentOrigin
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
qboolean NPC_UpdateAngles ( qboolean doPitch, qboolean doYaw )

Added: option to do just pitch or just yaw

Does not include "aim" in it's calculations

FIXME: stop compressing angles into shorts!!!!
```
*/
/// Source: oracle/codemp/game/NPC_utils.c:182
func NPC_UpdateAngles(_ doPitch: Bool, _ doYaw: Bool) -> Bool {
    var error: Float
    var decay: Float
    var targetPitch: Float = 0
    var targetYaw: Float = 0
    var yawSpeed: Float
    var exact: Bool = true

    // if angle changes are locked; just keep the current angles
    // aimTime isn't even set anymore... so this code was never reached, but I need a way to lock NPC's yaw, so instead of making a new SCF_ flag, just use the existing render flag... - dmv
    if NPC!.enemy == nil && ((level.time < NPCInfo!.aimTime)) {
        if doPitch {
            targetPitch = NPCInfo!.lockedDesiredPitch
        }

        if doYaw {
            targetYaw = NPCInfo!.lockedDesiredYaw
        }
    } else {
        // we're changing the lockedDesired Pitch/Yaw below so it's lost it's original meaning, get rid of the lock flag
        //	NPC->client->renderInfo.renderFlags &= ~RF_LOCKEDANGLE;

        if doPitch {
            targetPitch = NPCInfo!.desiredPitch
            NPCInfo!.lockedDesiredPitch = NPCInfo!.desiredPitch
        }

        if doYaw {
            targetYaw = NPCInfo!.desiredYaw
            NPCInfo!.lockedDesiredYaw = NPCInfo!.desiredYaw
        }
    }

    if NPC!.s.weapon == WP_EMPLACED_GUN {
        // FIXME: this seems to do nothing, actually...
        yawSpeed = 20
    } else {
        yawSpeed = NPCInfo!.stats.yawSpeed
    }

    if NPC!.s.weapon == WP_SABER && (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
        var buf = CharBuf(128)
        var tFVal: Float = 0

        strcpy(&buf, trap_Cvar_VariableStringBuffer("timescale", Int32((buf).count)))

        tFVal = Float(atof(buf))

        yawSpeed *= 1.0 / tFVal
    }

    if doYaw {
        // decay yaw error
        error = AngleDelta(NPC!.client!.ps.viewangles[YAW], targetYaw)
        if abs(error) > MIN_ANGLE_ERROR {
            if error != 0 {
                exact = false

                decay = Float(60.0 + Double(yawSpeed * 3))
                decay *= 50.0 / 1000.0 //msec

                if Double(error) < 0.0 {
                    error += decay
                    if Double(error) > 0.0 {
                        error = 0.0
                    }
                } else {
                    error -= decay
                    if Double(error) < 0.0 {
                        error = 0.0
                    }
                }
            }
        }

        ucmd.angles[YAW] = ANGLE2SHORT(targetYaw + error) - client!.ps.delta_angles[YAW]
    }

    //FIXME: have a pitchSpeed?
    if doPitch {
        // decay pitch error
        error = AngleDelta(NPC!.client!.ps.viewangles[PITCH], targetPitch)
        if abs(error) > MIN_ANGLE_ERROR {
            if error != 0 {
                exact = false

                decay = Float(60.0 + Double(yawSpeed * 3))
                decay *= 50.0 / 1000.0 //msec

                if Double(error) < 0.0 {
                    error += decay
                    if Double(error) > 0.0 {
                        error = 0.0
                    }
                } else {
                    error -= decay
                    if Double(error) < 0.0 {
                        error = 0.0
                    }
                }
            }
        }

        ucmd.angles[PITCH] = ANGLE2SHORT(targetPitch + error) - client!.ps.delta_angles[PITCH]
    }

    ucmd.angles[ROLL] = ANGLE2SHORT(NPC!.client!.ps.viewangles[ROLL]) - client!.ps.delta_angles[ROLL]

    if exact && trap_ICARUS_TaskIDPending(NPC!, TID_ANGLE_FACE) {
        trap_ICARUS_TaskIDComplete(NPC!, TID_ANGLE_FACE)
    }
    return exact


    //float		runningMod = NPCInfo->currentSpeed/100.0f;

    // if angle changes are locked; just keep the current angles

    //		NPCInfo->aimTime = level.time + 250;


    // decay yaw error
    /*
    if(NPC->client->playerTeam == TEAM_BORG&&
    NPCInfo->behaviorState != BS_FACE&&NPCInfo->tempBehavior!= BS_FACE)
    {//HACK - borg turn more jittery
    if ( error )
    {
    exact = qfalse;

    decay = 60.0 + yawSpeed * 3;
    decay *= 50.0 / 1000.0;//msec
    //Snap to
    if(fabs(error) > 10)
    {
    if(random() > 0.6)
    {
    doSound = qtrue;
    }
    }

    if ( error < 0.0)//-10.0 )
    {
    error += decay;
    if ( error > 0.0 )
    {
    error = 0.0;
    }
    }
    else if ( error > 0.0)//10.0 )
    {
    error -= decay;
    if ( error < 0.0 )
    {
    error = 0.0;
    }
    }
    }
    }
    else*/




    //FIXME: have a pitchSpeed?
    // decay pitch error
    /*
    if(NPC->client->playerTeam == TEAM_BORG&&
    NPCInfo->behaviorState != BS_FACE&&NPCInfo->tempBehavior!= BS_FACE)
    {//HACK - borg turn more jittery
    if ( error )
    {
    exact = qfalse;

    decay = 60.0 + yawSpeed * 3;
    decay *= 50.0 / 1000.0;//msec
    //Snap to
    if(fabs(error) > 10)
    {
    if(random() > 0.6)
    {
    doSound = qtrue;
    }
    }

    if ( error < 0.0)//-10.0 )
    {
    error += decay;
    if ( error > 0.0 )
    {
    error = 0.0;
    }
    }
    else if ( error > 0.0)//10.0 )
    {
    error -= decay;
    if ( error < 0.0 )
    {
    error = 0.0;
    }
    }
    }
    }
    else*/





    /*
    if(doSound)
    {
    G_Sound(NPC, G_SoundIndex(va("sound/enemies/borg/borgservo%d.wav", Q_irand(1, 8))));
    }
    */
}

/// Source: oracle/codemp/game/NPC_utils.c:519
func NPC_AimWiggle(_ enemy_org: inout JKAShared.vec3_t) {
    //shoot for somewhere between the head and torso
    //NOTE: yes, I know this looks weird, but it works
    if NPCInfo!.aimErrorDebounceTime < level.time {
        NPCInfo!.aimOfs[0] = Float(0.3 * Double(flrand(NPC!.enemy!.r.mins[0], NPC!.enemy!.r.maxs[0])))
        NPCInfo!.aimOfs[1] = Float(0.3 * Double(flrand(NPC!.enemy!.r.mins[1], NPC!.enemy!.r.maxs[1])))
        if NPC!.enemy!.r.maxs[2] > 0 {
            NPCInfo!.aimOfs[2] = NPC!.enemy!.r.maxs[2] * flrand(0.0, -1.0)
        }
    }
    enemy_org = enemy_org + NPCInfo!.aimOfs
}

/**
```
qboolean NPC_UpdateFiringAngles ( qboolean doPitch, qboolean doYaw )

  Includes aim when determining angles - so they don't always hit...
```
*/
/// Source: oracle/codemp/game/NPC_utils.c:540
func NPC_UpdateFiringAngles(_ doPitch: Bool, _ doYaw: Bool) -> Bool {
    // add yaw error based on NPCInfo->aim value





    // add pitch error based on NPCInfo->aim value







    var error: Float
    var diff: Float
    var decay: Float
    var targetPitch: Float = 0
    var targetYaw: Float = 0
    var exact: Bool = true

    // if angle changes are locked; just keep the current angles
    if level.time < NPCInfo!.aimTime {
        if doPitch {
            targetPitch = NPCInfo!.lockedDesiredPitch
        }
        if doYaw {
            targetYaw = NPCInfo!.lockedDesiredYaw
        }
    } else {
        if doPitch {
            targetPitch = NPCInfo!.desiredPitch
        }
        if doYaw {
            targetYaw = NPCInfo!.desiredYaw
        }

        //		NPCInfo->aimTime = level.time + 250;
        if doPitch {
            NPCInfo!.lockedDesiredPitch = NPCInfo!.desiredPitch
        }
        if doYaw {
            NPCInfo!.lockedDesiredYaw = NPCInfo!.desiredYaw
        }
    }

    if NPCInfo!.aimErrorDebounceTime < level.time {
        if Q_irand(0, 1) != 0 {
            NPCInfo!.lastAimErrorYaw = (Float((6 - NPCInfo!.stats.aim))) * flrand(-1, 1)
        }
        if Q_irand(0, 1) != 0 {
            NPCInfo!.lastAimErrorPitch = (Float((6 - NPCInfo!.stats.aim))) * flrand(-1, 1)
        }
        NPCInfo!.aimErrorDebounceTime = level.time + Q_irand(250, 2000)
    }

    if doYaw {
        // decay yaw diff
        diff = AngleDelta(NPC!.client!.ps.viewangles[YAW], targetYaw)

        if diff != 0 {
            exact = false

            decay = Float(60.0 + 80.0)
            decay *= 50.0 / 1000.0 //msec
            if Double(diff) < 0.0 {
                diff += decay
                if Double(diff) > 0.0 {
                    diff = 0.0
                }
            } else {
                diff -= decay
                if Double(diff) < 0.0 {
                    diff = 0.0
                }
            }
        }

        // add yaw error based on NPCInfo->aim value
        error = NPCInfo!.lastAimErrorYaw

        /*
        if(Q_irand(0, 1))
        {
        error *= -1;
        }
        */

        ucmd.angles[YAW] = ANGLE2SHORT(targetYaw + diff + error) - client!.ps.delta_angles[YAW]
    }

    if doPitch {
        // decay pitch diff
        diff = AngleDelta(NPC!.client!.ps.viewangles[PITCH], targetPitch)
        if diff != 0 {
            exact = false

            decay = Float(60.0 + 80.0)
            decay *= 50.0 / 1000.0 //msec
            if Double(diff) < 0.0 {
                diff += decay
                if Double(diff) > 0.0 {
                    diff = 0.0
                }
            } else {
                diff -= decay
                if Double(diff) < 0.0 {
                    diff = 0.0
                }
            }
        }

        error = NPCInfo!.lastAimErrorPitch

        ucmd.angles[PITCH] = ANGLE2SHORT(targetPitch + diff + error) - client!.ps.delta_angles[PITCH]
    }

    ucmd.angles[ROLL] = ANGLE2SHORT(NPC!.client!.ps.viewangles[ROLL]) - client!.ps.delta_angles[ROLL]

    return exact
}

/// Source: oracle/codemp/game/NPC_utils.c:740
func NPC_UpdateShootAngles(_ angles: JKAShared.vec3_t, _ doPitch: Bool, _ doYaw: Bool) {
    //FIXME: shoot angles either not set right or not used!
    var error: Float
    var decay: Float
    var targetPitch: Float = 0
    var targetYaw: Float = 0

    if doPitch {
        targetPitch = angles[PITCH]
    }
    if doYaw {
        targetYaw = angles[YAW]
    }


    if doYaw {
        // decay yaw error
        error = AngleDelta(NPCInfo!.shootAngles[YAW], targetYaw)
        if error != 0 {
            decay = Float(60.0 + 80.0 * Double(NPCInfo!.stats.aim))
            decay *= 100.0 / 1000.0 //msec
            if Double(error) < 0.0 {
                error += decay
                if Double(error) > 0.0 {
                    error = 0.0
                }
            } else {
                error -= decay
                if Double(error) < 0.0 {
                    error = 0.0
                }
            }
        }
        NPCInfo!.shootAngles[YAW] = targetYaw + error
    }

    if doPitch {
        // decay pitch error
        error = AngleDelta(NPCInfo!.shootAngles[PITCH], targetPitch)
        if error != 0 {
            decay = Float(60.0 + 80.0 * Double(NPCInfo!.stats.aim))
            decay *= 100.0 / 1000.0 //msec
            if Double(error) < 0.0 {
                error += decay
                if Double(error) > 0.0 {
                    error = 0.0
                }
            } else {
                error -= decay
                if Double(error) < 0.0 {
                    error = 0.0
                }
            }
        }
        NPCInfo!.shootAngles[PITCH] = targetPitch + error
    }
}

/**
```
void SetTeamNumbers (void)

Sets the number of living clients on each team

FIXME: Does not account for non-respawned players!
FIXME: Don't include medics?
```
*/
/// Source: oracle/codemp/game/NPC_utils.c:818
func SetTeamNumbers() {
    var found: Entity?
    var i: Int32

    i = 0
    while i < TEAM_NUM_TEAMS {
        teamNumbers[i] = 0
        teamStrength[i] = 0
        i += 1
    }

    i = 0
    while i < 1 {
        found = g_entities[i]

        if found!.client != nil {
            if found!.health > 0 {
                teamNumbers[found!.client!.playerTeam] += 1
                teamStrength[found!.client!.playerTeam] += found!.health
            }
        }
        i += 1
    }

    i = 0
    while i < TEAM_NUM_TEAMS {
        //Get the average health
        teamStrength[i] = Int32(floor((Float((teamStrength[i]))) / (Float((teamNumbers[i])))))
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_utils.c:851
func G_ActivateBehavior(_ `self`: Entity, _ bset: Int32) -> Bool {
    var bSID: bState_t = bState_t(-1)
    var bs_name: String? = nil


    bs_name = `self`.behaviorSet[bset]

    if !(VALIDSTRING(bs_name)) {
        return false
    }

    if `self`.NPC != nil {
        bSID = bState_t(GetIDForString(BSTable, bs_name!))
    }

    if bSID > -1 {
        `self`.NPC!.tempBehavior = BS_DEFAULT
        `self`.NPC!.behaviorState = bSID
    } else {
        /*
        char			newname[MAX_FILENAME_LENGTH];
        sprintf((char *) &newname, "%s/%s", Q3_SCRIPT_DIR, bs_name );
        */

        //FIXME: between here and actually getting into the ICARUS_RunScript function, the stack gets blown!
        //if ( ( ICARUS_entFilter == -1 ) || ( ICARUS_entFilter == self->s.number ) )
        if 0 != 0 {
            G_DebugPrint(WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", `self`.targetname ?? "", GetStringForID(BSETTable, bset) ?? "", bs_name!)
        }
        trap_ICARUS_RunScript(`self`, va("%s/%s", Q3_SCRIPT_DIR, bs_name!))
    }
    return true
}

//rww - special system for sync'ing bone angles between client and server.
/// Source: oracle/codemp/game/NPC_utils.c:906
func NPC_SetBoneAngles(_ ent: Entity, _ bone: String, _ angles: JKAShared.vec3_t) {
    var thebone: Int32? = 0
    var firstFree: Int32? = nil
    var i: Int32 = 0
    let boneIndex: Int32 = G_BoneIndex(bone)
    let flags: Int32
    let up: Int32
    let right: Int32
    let forward: Int32
    var boneVector: Int32? = 0
    var freeBoneVec: Int32? = nil

    while thebone != nil {
        if ent.s.boneIndexSlots[thebone!] == 0 && firstFree == nil {
            //if the value is 0 then this index is clear, we can use it if we don't find the bone we want already existing.
            firstFree = thebone
            freeBoneVec = boneVector
        } else if ent.s.boneIndexSlots[thebone!] != 0 {
            if ent.s.boneIndexSlots[thebone!] == boneIndex {
                //this is it
                break
            }
        }

        switch i {
        case 0:
            thebone = 1
            boneVector = 1

        case 1:
            thebone = 2
            boneVector = 2

        case 2:
            thebone = 3
            boneVector = 3

        default:
            thebone = nil
            boneVector = nil
        }

        i += 1
    }

    if thebone == nil {
        //didn't find it, create it
        if firstFree == nil {
            //no free bones.. can't do a thing then.
            Com_Printf("WARNING: NPC has no free bone indexes\n")
            return
        }

        thebone = firstFree

        ent.s.boneIndexSlots[thebone!] = boneIndex
        boneVector = freeBoneVec
    }

    //If we got here then we have a vector and an index.

    //Copy the angles over the vector in the entitystate, so we can use the corresponding index
    //to set the bone angles on the client.
    ent.s.boneAnglesSlots[boneVector!] = angles

    //Now set the angles on our server instance if we have one.

    if ent.ghoul2 == nil {
        return
    }

    flags = BONE_ANGLES_POSTMULT
    up = POSITIVE_X
    right = NEGATIVE_Y
    forward = NEGATIVE_Z

    //first 3 bits is forward, second 3 bits is right, third 3 bits is up
    ent.s.boneOrient = ((forward) | (right << 3) | (up << 6))

    trap_G2API_SetBoneAngles(ent.ghoul2, 0, bone, angles, flags, up, right, forward, nil, 100, level.time)
}

/// Source: oracle/codemp/game/NPC_utils.c:1001
func NPC_SetSurfaceOnOff(_ ent: Entity, _ surfaceName: String, _ surfaceFlags: Int32) {
    var i: Int32 = 0
    var foundIt: Bool = false

    while i < BG_NUM_TOGGLEABLE_SURFACES && bgToggleableSurfaces[i] != nil {
        if Q_stricmp(surfaceName, bgToggleableSurfaces[i]) == 0 {
            //got it
            foundIt = true
            break
        }
        i += 1
    }

    if !foundIt {
        Com_Printf("WARNING: Tried to toggle NPC surface that isn't in toggleable surface list (%s)\n", surfaceName)
        return
    }

    if surfaceFlags == TURN_ON {
        //Make sure the entitystate values reflect this surface as on now.
        ent.s.surfacesOn |= (1 << i)
        ent.s.surfacesOff &= ~(1 << i)
    } else {
        //Otherwise make sure they're off.
        ent.s.surfacesOn &= ~(1 << i)
        ent.s.surfacesOff |= (1 << i)
    }

    if ent.ghoul2 == nil {
        return
    }

    trap_G2API_SetSurfaceOnOff(ent.ghoul2, surfaceName, surfaceFlags)
}

//rww - cheap check to see if an armed client is looking in our general direction
/// Source: oracle/codemp/game/NPC_utils.c:1042
func NPC_SomeoneLookingAtMe(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var pEnt: Entity?

    while i < MAX_CLIENTS {
        pEnt = g_entities[i]

        if pEnt != nil && pEnt!.inuse && pEnt!.client != nil && pEnt!.client!.sess.sessionTeam != TEAM_SPECTATOR && !((pEnt!.client!.ps.pm_flags & PMF_FOLLOW) != 0) && pEnt!.s.weapon != WP_NONE {
            if trap_InPVS(ent.r.currentOrigin, pEnt!.r.currentOrigin) {
                if InFOV(ent, pEnt!, 30, 30) {
                    //I'm in a 30 fov or so cone from this player.. that's enough I guess.
                    return true
                }
            }
        }

        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/NPC_utils.c:1069
func NPC_ClearLOS(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) -> Bool {
    return G_ClearLOS(NPC!, start, end)
}

/// Source: oracle/codemp/game/NPC_utils.c:1073
func NPC_ClearLOS5(_ end: JKAShared.vec3_t) -> Bool {
    return G_ClearLOS5(NPC!, end)
}

/// Source: oracle/codemp/game/NPC_utils.c:1077
func NPC_ClearLOS4(_ ent: Entity) -> Bool {
    return G_ClearLOS4(NPC!, ent)
}

/// Source: oracle/codemp/game/NPC_utils.c:1081
func NPC_ClearLOS3(_ start: JKAShared.vec3_t, _ ent: Entity) -> Bool {
    return G_ClearLOS3(NPC!, start, ent)
}

/// Source: oracle/codemp/game/NPC_utils.c:1085
public func NPC_ClearLOS2(_ ent: Entity, _ end: JKAShared.vec3_t) -> Bool {
    return G_ClearLOS2(NPC!, ent, end)
}

/// Source: oracle/codemp/game/NPC_utils.c:1096
func NPC_ValidEnemy(_ ent: Entity) -> Bool {
    var entTeam: Int32 = TEAM_FREE
    //Must be a valid pointer
    if ent == nil {
        return false
    }

    //Must not be me
    if ent == NPC {
        return false
    }

    //Must not be deleted
    if ent.inuse == false {
        return false
    }

    //Must be alive
    if ent.health <= 0 {
        return false
    }

    //In case they're in notarget mode
    if (ent.flags & FL_NOTARGET) != 0 {
        return false
    }

    //Must be an NPC
    if ent.client == nil {
        //	if ( ent->svFlags&SVF_NONNPC_ENEMY )
        if ent.s.eType != ET_NPC {
            //still potentially valid
            if ent.alliedTeam == NPC!.client!.playerTeam {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    } else if ent.client != nil && ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
        //don't go after spectators
        return false
    }
    if ent.NPC != nil && ent.client != nil {
        entTeam = ent.client!.playerTeam
    } else if ent.client != nil {
        if g_gametype.integer < GT_TEAM {
            entTeam = NPCTEAM_PLAYER
        } else {
            if ent.client!.sess.sessionTeam == TEAM_BLUE {
                entTeam = NPCTEAM_PLAYER
            } else if ent.client!.sess.sessionTeam == TEAM_RED {
                entTeam = NPCTEAM_ENEMY
            } else {
                entTeam = NPCTEAM_NEUTRAL
            }
        }
    }
    //Can't be on the same team
    if ent.client!.playerTeam == NPC!.client!.playerTeam {
        return false
    }

    //if haven't seen him in a while, give up
    //if ( NPCInfo->enemyLastSeenTime != 0 && level.time - NPCInfo->enemyLastSeenTime > 7000 )//FIXME: make a stat?
    //	return qfalse;
    if entTeam == NPC!.client!.enemyTeam || (NPC!.client!.enemyTeam == NPCTEAM_FREE && ent.client!.NPC_class != NPC!.client!.NPC_class) || (ent.client!.NPC_class == CLASS_WAMPA && ent.enemy != nil) || (ent.client!.NPC_class == CLASS_RANCOR && ent.enemy != nil) || (entTeam == NPCTEAM_FREE && ent.client!.enemyTeam == NPCTEAM_FREE && ent.enemy != nil && ent.enemy!.client != nil && (ent.enemy!.client!.playerTeam == NPC!.client!.playerTeam || (ent.enemy!.client!.playerTeam != NPCTEAM_ENEMY && NPC!.client!.playerTeam == NPCTEAM_PLAYER))) {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/NPC_utils.c:1195
func NPC_TargetVisible(_ ent: Entity) -> Bool {
    //Make sure we're in a valid range
    if DistanceSquared(ent.r.currentOrigin, NPC!.r.currentOrigin) > (NPCInfo!.stats.visrange * NPCInfo!.stats.visrange) {
        return false
    }

    //Check our FOV
    if InFOV(ent, NPC!, NPCInfo!.stats.hfov, NPCInfo!.stats.vfov) == false {
        return false
    }

    //Check for sight
    if NPC_ClearLOS4(ent) == false {
        return false
    }

    return true
}

/// Source: oracle/codemp/game/NPC_utils.c:1246
func NPC_FindNearestEnemy(_ ent: Entity) -> Int32 {
    var iradiusEnts: [Int32] = [Int32](repeating: 0, count: 256)
    var radEnt: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()
    var nearestEntID: Int32 = -1
    var nearestDist: Float = Float(WORLD_SIZE) * Float(WORLD_SIZE)
    var distance: Float
    let numEnts: Int32
    var numChecks: Int32 = 0
    var i: Int32

    //Setup the bbox to search in
    i = 0
    while i < 3 {
        mins[i] = ent.r.currentOrigin[i] - NPCInfo!.stats.visrange
        maxs[i] = ent.r.currentOrigin[i] + NPCInfo!.stats.visrange
        i += 1
    }

    //Get a number of entities in a given space
    numEnts = trap_EntitiesInBox(mins, maxs, &iradiusEnts, MAX_RADIUS_ENTS)

    i = 0
    while i < numEnts {
        radEnt = g_entities[iradiusEnts[i]]
        //Don't consider self
        if radEnt == ent {
            i += 1
            continue
        }

        //Must be valid
        if NPC_ValidEnemy(radEnt!) == false {
            i += 1
            continue
        }

        numChecks += 1
        //Must be visible
        if NPC_TargetVisible(radEnt!) == false {
            i += 1
            continue
        }

        distance = DistanceSquared(ent.r.currentOrigin, radEnt!.r.currentOrigin)

        //Found one closer to us
        if distance < nearestDist {
            nearestEntID = radEnt!.s.number
            nearestDist = distance
        }
        i += 1
    }

    return nearestEntID
}

/// Source: oracle/codemp/game/NPC_utils.c:1302
func NPC_PickEnemyExt(_ checkAlerts: Bool) -> Entity? {
    //Check for Hazard Team status and remove this check
    /*
    if ( NPC->client->playerTeam != TEAM_STARFLEET )
    {
    //If we've found the player, return it
    if ( NPC_FindPlayer() )
    return &g_entities[0];
    }
    */

    //If we've asked for the closest enemy
    let entID: Int32 = NPC_FindNearestEnemy(NPC!)

    //If we have a valid enemy, use it
    if entID >= 0 {
        return g_entities[entID]
    }

    if checkAlerts {
        let alertEvent: Int32 = NPC_CheckAlertEvents(true, true, -1, true, AEL_DISCOVERED)

        //There is an event to look at
        if alertEvent >= 0 {
            let event: AlertEvent? = level.alertEvents[alertEvent]

            //Don't pay attention to our own alerts
            if event!.owner == NPC {
                return nil
            }

            if event!.level >= AEL_DISCOVERED {
                //If it's the player, attack him
                if event!.owner == g_entities[0] {
                    return event!.owner
                }

                //If it's on our team, then take its enemy as well
                if event!.owner!.client != nil && (event!.owner!.client!.playerTeam == NPC!.client!.playerTeam) {
                    return event!.owner!.enemy
                }
            }
        }
    }

    return nil
}

/// Source: oracle/codemp/game/NPC_utils.c:1356
func NPC_FindPlayer() -> Bool {
    return NPC_TargetVisible(g_entities[0])
}

/// Source: oracle/codemp/game/NPC_utils.c:1367
private func NPC_CheckPlayerDistance() -> Bool {
    return false //MOOT in MP
    /*
    float distance;

    //Make sure we have an enemy
    if ( NPC->enemy == NULL )
    return qfalse;

    //Only do this for non-players
    if ( NPC->enemy->s.number == 0 )
    return qfalse;

    //must be set up to get mad at player
    if ( !NPC->client || NPC->client->enemyTeam != NPCTEAM_PLAYER )
    return qfalse;

    //Must be within our FOV
    if ( InFOV( &g_entities[0], NPC, NPCInfo->stats.hfov, NPCInfo->stats.vfov ) == qfalse )
    return qfalse;

    distance = DistanceSquared( NPC->r.currentOrigin, NPC->enemy->r.currentOrigin );

    if ( distance > DistanceSquared( NPC->r.currentOrigin, g_entities[0].r.currentOrigin ) )
    { //rwwFIXMEFIXME: care about all clients not just client 0
    G_SetEnemy( NPC, &g_entities[0] );
    return qtrue;
    }

    return qfalse;
    */
}

/// Source: oracle/codemp/game/NPC_utils.c:1407
func NPC_FindEnemy(_ checkAlerts: Bool) -> Bool {
    var newenemy: Entity?

    //We're ignoring all enemies for now
    //if( NPC->svFlags & SVF_IGNORE_ENEMIES )
    if 0 != 0 {
        G_ClearEnemy(NPC!)
        return false
    }

    //we can't pick up any enemies for now
    if NPCInfo!.confusionTime > level.time {
        return false
    }

    //Don't want a new enemy
    //rwwFIXMEFIXME: support for locked enemy
    //if ( ( ValidEnemy( NPC->enemy ) ) && ( NPC->svFlags & SVF_LOCKEDENEMY ) )
    //	return qtrue;

    //See if the player is closer than our current enemy
    if NPC_CheckPlayerDistance() {
        return true
    }

    //Otherwise, turn off the flag
    //	NPC->svFlags &= ~SVF_LOCKEDENEMY;
    //See if the player is closer than our current enemy
    if NPC!.client!.NPC_class != CLASS_RANCOR && NPC!.client!.NPC_class != CLASS_WAMPA && NPC_CheckPlayerDistance() {
        //rancors, wampas & sand creatures don't care if player is closer, they always go with closest
        return true
    }

    //If we've gotten here alright, then our target it still valid
    if NPC_ValidEnemy(NPC!.enemy!) {
        return true
    }

    newenemy = NPC_PickEnemyExt(checkAlerts)

    //if we found one, take it as the enemy
    if NPC_ValidEnemy(newenemy!) {
        G_SetEnemy(NPC!, newenemy!)
        return true
    }

    return false
}

/// Source: oracle/codemp/game/NPC_utils.c:1469
func NPC_CheckEnemyExt(_ checkAlerts: Bool) -> Bool {
    //Make sure we're ready to think again
    /*
    if ( NPCInfo->enemyCheckDebounceTime > level.time )
    return qfalse;

    //Get our next think time
    NPCInfo->enemyCheckDebounceTime = level.time + NPC_GetCheckDelta();

    //Attempt to find an enemy
    return NPC_FindEnemy();
    */
    return NPC_FindEnemy(checkAlerts)
}

/// Source: oracle/codemp/game/NPC_utils.c:1491
func NPC_FacePosition(_ position: JKAShared.vec3_t, _ doPitch: Bool) -> Bool {
    var muzzle = vec3_t()
    var angles = vec3_t()
    let yawDelta: Float
    var facing: Bool = true

    //Get the positions
    if NPC!.client != nil && (NPC!.client!.NPC_class == CLASS_RANCOR || NPC!.client!.NPC_class == CLASS_WAMPA) {
        CalcEntitySpot(NPC!, SPOT_ORIGIN, &muzzle)
        muzzle[2] += NPC!.r.maxs[2] * 0.75
    } else if NPC!.client != nil && NPC!.client!.NPC_class == CLASS_GALAKMECH {
        CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)
    } else {
        CalcEntitySpot(NPC!, SPOT_HEAD_LEAN, &muzzle) //SPOT_HEAD
    }

    //Find the desired angles
    GetAnglesForDirection(muzzle, position, &angles)

    NPCInfo!.desiredYaw = AngleNormalize360(angles[YAW])
    NPCInfo!.desiredPitch = AngleNormalize360(angles[PITCH])

    if NPC!.enemy != nil && NPC!.enemy!.client != nil && NPC!.enemy!.client!.NPC_class == CLASS_ATST {
        // FIXME: this is kind of dumb, but it was the easiest way to get it to look sort of ok
        NPCInfo!.desiredYaw += flrand(-5, 5) + sin(level.time * 0.004) * 7
        NPCInfo!.desiredPitch += flrand(-2, 2)
    }
    //Face that yaw
    NPC_UpdateAngles(true, true)

    //Find the delta between our goal and our current facing
    yawDelta = AngleNormalize360(NPCInfo!.desiredYaw - (SHORT2ANGLE(ucmd.angles[YAW] + client!.ps.delta_angles[YAW])))

    //See if we are facing properly
    if abs(yawDelta) > VALID_ATTACK_CONE {
        facing = false
    }

    if doPitch {
        //Find the delta between our goal and our current facing
        let currentAngles: Float = (SHORT2ANGLE(ucmd.angles[PITCH] + client!.ps.delta_angles[PITCH]))
        let pitchDelta: Float = NPCInfo!.desiredPitch - currentAngles

        //See if we are facing properly
        if abs(pitchDelta) > VALID_ATTACK_CONE {
            facing = false
        }
    }

    return facing
}

/// Source: oracle/codemp/game/NPC_utils.c:1555
func NPC_FaceEntity(_ ent: Entity, _ doPitch: Bool) -> Bool {
    var entPos = vec3_t()

    //Get the positions
    CalcEntitySpot(ent, SPOT_HEAD_LEAN, &entPos)

    return NPC_FacePosition(entPos, doPitch)
}

/// Source: oracle/codemp/game/NPC_utils.c:1571
func NPC_FaceEnemy(_ doPitch: Bool) -> Bool {
    if NPC == nil {
        return false
    }

    if NPC!.enemy == nil {
        return false
    }

    return NPC_FaceEntity(NPC!.enemy!, doPitch)
}

/// Source: oracle/codemp/game/NPC_utils.c:1588
func NPC_CheckCanAttackExt() -> Bool {
    //We don't want them to shoot
    if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 {
        return false
    }

    //Turn to face
    if NPC_FaceEnemy(true) == false {
        return false
    }

    //Must have a clear line of sight to the target
    if NPC_ClearShot(NPC!.enemy!) == false {
        return false
    }

    return true
}

/// Source: oracle/codemp/game/NPC_utils.c:1611
func NPC_ClearLookTarget(_ `self`: Entity) {
    if `self`.client == nil {
        return
    }

    if (`self`.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
        //lookTarget is set by and to the monster that's holding you, no other operations can change that
        return
    }

    `self`.client!.renderInfo.lookTarget = ENTITYNUM_NONE //ENTITYNUM_WORLD;
    `self`.client!.renderInfo.lookTargetClearTime = 0
}

/**
```
-------------------------
NPC_SetLookTarget
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_utils.c:1632
func NPC_SetLookTarget(_ `self`: Entity, _ entNum: Int32, _ clearTime: Int32) {
    if `self`.client == nil {
        return
    }

    if (`self`.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
        //lookTarget is set by and to the monster that's holding you, no other operations can change that
        return
    }

    `self`.client!.renderInfo.lookTarget = entNum
    `self`.client!.renderInfo.lookTargetClearTime = clearTime
}

/**
```
-------------------------
NPC_CheckLookTarget
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_utils.c:1653
func NPC_CheckLookTarget(_ `self`: Entity) -> Bool {
    if `self`.client != nil {
        if `self`.client!.renderInfo.lookTarget >= 0 && `self`.client!.renderInfo.lookTarget < ENTITYNUM_WORLD {
            //within valid range
            if (g_entities[`self`.client!.renderInfo.lookTarget] == nil) || !g_entities[`self`.client!.renderInfo.lookTarget].inuse {
                //lookTarget not inuse or not valid anymore
                NPC_ClearLookTarget(`self`)
            } else if `self`.client!.renderInfo.lookTargetClearTime != 0 && `self`.client!.renderInfo.lookTargetClearTime < level.time {
                //Time to clear lookTarget
                NPC_ClearLookTarget(`self`)
            } else if g_entities[`self`.client!.renderInfo.lookTarget].client != nil && `self`.enemy != nil && (g_entities[`self`.client!.renderInfo.lookTarget] != `self`.enemy) {
                //should always look at current enemy if engaged in battle... FIXME: this could override certain scripted lookTargets...???
                NPC_ClearLookTarget(`self`)
            } else {
                return true
            }
        }
    }

    return false
}

/// Source: oracle/codemp/game/NPC_utils.c:1687
func NPC_CheckCharmed() {
    if NPCInfo!.charmedTime != 0 && NPCInfo!.charmedTime < level.time && NPC!.client != nil {
        //we were charmed, set us back!
        NPC!.client!.playerTeam = NPC!.genericValue1
        NPC!.client!.enemyTeam = NPC!.genericValue2
        NPC!.s.teamowner = NPC!.genericValue3

        NPC!.client!.leader = nil
        if NPCInfo!.tempBehavior == BS_FOLLOW_LEADER {
            NPCInfo!.tempBehavior = BS_DEFAULT
        }
        G_ClearEnemy(NPC!)
        NPCInfo!.charmedTime = 0
        //say something to let player know you've snapped out of it
        G_AddVoiceEvent(NPC!, Q_irand(EV_CONFUSE1, EV_CONFUSE3), 2000)
    }
}

/// Source: oracle/codemp/game/NPC_utils.c:1707
func G_GetBoltPosition(_ `self`: Entity, _ boltIndex: Int32, _ pos: inout JKAShared.vec3_t, _ modelIndex: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var result = vec3_t()
        var angles = vec3_t()

        if !`self`.inuse {
            return true
        }

        if `self`.client != nil {
            //clients don't actually even keep r.currentAngles maintained
            angles = vec3_t(0, `self`.client!.ps.viewangles[YAW], 0)
        } else {
            angles = vec3_t(0, `self`.r.currentAngles[YAW], 0)
        }

        if `self`.ghoul2 == nil {
            return true
        }

        trap_G2API_GetBoltMatrix(`self`.ghoul2, modelIndex, boltIndex, boltMatrix, angles, `self`.r.currentOrigin, level.time, nil, &`self`.modelScale)
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &result)
        pos = result
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/NPC_utils.c:1742
func NPC_EntRangeFromBolt(_ targEnt: Entity, _ boltIndex: Int32) -> Float {
    var org = vec3_t()


    G_GetBoltPosition(NPC!, boltIndex, &org, 0)

    return (Distance(targEnt.r.currentOrigin, org))
}

/// Source: oracle/codemp/game/NPC_utils.c:1756
func NPC_EnemyRangeFromBolt(_ boltIndex: Int32) -> Float {
    return (NPC_EntRangeFromBolt(NPC!.enemy!, boltIndex))
}

/// Source: oracle/codemp/game/NPC_utils.c:1761
func NPC_GetEntsNearBolt(_ radiusEnts: inout [Int32], _ radius: Float, _ boltIndex: Int32, _ boltOrg: inout JKAShared.vec3_t) -> Int32 {
    var mins = vec3_t()
    var maxs = vec3_t()
    var i: Int32

    //get my handRBolt's position
    var org = vec3_t()

    G_GetBoltPosition(NPC!, boltIndex, &org, 0)

    boltOrg = org

    //Setup the bbox to search in
    i = 0
    while i < 3 {
        mins[i] = boltOrg[i] - radius
        maxs[i] = boltOrg[i] + radius
        i += 1
    }

    //Get the number of entities in a given space
    return (trap_EntitiesInBox(mins, maxs, &radiusEnts, 128))
}
