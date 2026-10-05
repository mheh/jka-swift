import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_vehicleTurret.c:12
func VEH_TurretCheckFire(_ pVeh: JKAMP.Vehicle, _ parent: Entity, _ turretStats: JKAMP.TurretStats, _ vehWeapon: JKAMP.VehWeaponInfo, _ turretNum: Int32, _ curMuzzle: Int32) {
    // if it's time to fire and we have an enemy, then gun 'em down!  pushDebounce time controls next fire time
    if pVeh.m_iMuzzleTag[curMuzzle] == -1 {
        //invalid muzzle?
        return
    }

    if pVeh.m_iMuzzleWait[curMuzzle] >= level.time {
        //can't fire yet
        return
    }

    if pVeh.turretStatus[turretNum].ammo < vehWeapon.iAmmoPerShot {
        //no ammo, can't fire
        return
    }

    //if ( turretEnemy )
    do {
        //FIXME: check to see if I'm aiming generally where I want to
        var nextMuzzle: Int32 = 0
        let muzzlesFired: Int32 = (1 << curMuzzle)
        var missile: Entity?
        WP_CalcVehMuzzle(parent, curMuzzle)

        //FIXME: some variation in fire dir
        // Port-note: The draft of this statement did not compile, and the compiler wrote "failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs)".
        // Raven wrote: missile = WP_FireVehicleWeapon( parent, pVeh->m_vMuzzlePos[curMuzzle], pVeh->m_vMuzzleDir[curMuzzle], vehWeapon, (turretNum!=0), qtrue )
        portMissing("VEH_TurretCheckFire", source: "oracle/codemp/game/g_vehicleTurret.c:12")

        //play the weapon's muzzle effect if we have one
        G_VehMuzzleFireFX(parent, missile!, muzzlesFired)

        //take the ammo away
        pVeh.turretStatus[turretNum].ammo -= vehWeapon.iAmmoPerShot
        //toggle to the next muzzle on this turret, if there is one
        nextMuzzle = ((curMuzzle + 1) == pVeh.m_pVehicleInfo!.turret[turretNum].iMuzzle[0]) ? pVeh.m_pVehicleInfo!.turret[turretNum].iMuzzle[1] : pVeh.m_pVehicleInfo!.turret[turretNum].iMuzzle[0]
        if nextMuzzle != 0 {
            //a valid muzzle to toggle to
            pVeh.turretStatus[turretNum].nextMuzzle = nextMuzzle - 1 //-1 because you type muzzles 1-10 in the .veh file
        }
        //add delay to the next muzzle so it doesn't fire right away on the next frame
        pVeh.m_iMuzzleWait[pVeh.turretStatus[turretNum].nextMuzzle] = level.time + turretStats.iDelay
    }
}

/// Source: oracle/codemp/game/g_vehicleTurret.c:61
func VEH_TurretAnglesToEnemy(_ pVeh: JKAMP.Vehicle, _ curMuzzle: Int32, _ fSpeed: Float, _ turretEnemy: Entity, _ bAILead: Bool, _ desiredAngles: inout JKAShared.vec3_t) {
    var enemyDir = vec3_t()
    var org = vec3_t()
    org = turretEnemy.r.currentOrigin
    if bAILead {
        //we want to lead them a bit
        var diff = vec3_t()
        var velocity = vec3_t()
        let dist: Float
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '-' cannot be applied to operands of type 'vec3_t' (aka 'SIMD3<Float>') and 'Slots<Float>'".
        // Raven wrote: VectorSubtract( org, pVeh->m_vMuzzlePos[curMuzzle], diff )
        portMissing("VEH_TurretAnglesToEnemy", source: "oracle/codemp/game/g_vehicleTurret.c:61")
        dist = VectorNormalize(&diff)
        if turretEnemy.client != nil {
            velocity = turretEnemy.client!.ps.velocity
        } else {
            velocity = turretEnemy.s.pos.trDelta
        }
        _VectorMA(org, (dist / fSpeed), velocity, &org)
    }

    //FIXME: this isn't quite right, it's aiming from the muzzle, not the center of the turret...
    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '-' cannot be applied to operands of type 'vec3_t' (aka 'SIMD3<Float>') and 'Slots<Float>'".
    // Raven wrote: VectorSubtract( org, pVeh->m_vMuzzlePos[curMuzzle], enemyDir )
    portMissing("VEH_TurretAnglesToEnemy", source: "oracle/codemp/game/g_vehicleTurret.c:61")
    //Get the desired absolute, world angles to our target
    vectoangles(enemyDir, &desiredAngles)
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_vehicleTurret.c:89
func VEH_TurretAim(_ pVeh: JKAMP.Vehicle, _ parent: Entity, _ turretEnemy: Entity?, _ turretStats: JKAMP.TurretStats, _ vehWeapon: JKAMP.VehWeaponInfo, _ turretNum: Int32, _ curMuzzle: Int32, _ desiredAngles: inout JKAShared.vec3_t) -> Bool {
    var curAngles = vec3_t()
    var addAngles = vec3_t()
    var newAngles = vec3_t()
    var yawAngles = vec3_t()
    var pitchAngles = vec3_t()
    var aimCorrect: Float = 0

    WP_CalcVehMuzzle(parent, curMuzzle)
    //get the current absolute angles of the turret right now
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<Float>' to expected argument type 'vec3_t' (aka 'SIMD3<Float>')".
    // Raven wrote: vectoangles( pVeh->m_vMuzzleDir[curMuzzle], curAngles )
    portMissing("VEH_TurretAim", source: "oracle/codemp/game/g_vehicleTurret.c:89")
    //subtract out the vehicle's angles to get the relative alignment
    AnglesSubtract(curAngles, pVeh.m_vOrientationVector, &curAngles)

    if turretEnemy != nil {
        aimCorrect = 1
        // ...then we'll calculate what new aim adjustments we should attempt to make this frame
        // Aim at enemy
        // Port-note: Raven passes the optional `turretEnemy` to `VEH_TurretAnglesToEnemy`, whose `turretEnemy` parameter takes a value. A never-null ruling is due.
        // Raven wrote: VEH_TurretAnglesToEnemy( pVeh, curMuzzle, vehWeapon->fSpeed, turretEnemy, turretStats->bAILead, desiredAngles )
        portMissing("VEH_TurretAim", source: "oracle/codemp/game/g_vehicleTurret.c:89")
    }
    //subtract out the vehicle's angles to get the relative desired alignment
    AnglesSubtract(desiredAngles, pVeh.m_vOrientationVector, &desiredAngles)
    //Now clamp the desired relative angles
    //clamp yaw
    desiredAngles[YAW] = AngleNormalize180(desiredAngles[YAW])
    if pVeh.m_pVehicleInfo!.turret[turretNum].yawClampLeft != 0 && desiredAngles[YAW] > pVeh.m_pVehicleInfo!.turret[turretNum].yawClampLeft {
        aimCorrect = 0
        desiredAngles[YAW] = pVeh.m_pVehicleInfo!.turret[turretNum].yawClampLeft
    }
    if pVeh.m_pVehicleInfo!.turret[turretNum].yawClampRight != 0 && desiredAngles[YAW] < pVeh.m_pVehicleInfo!.turret[turretNum].yawClampRight {
        aimCorrect = 0
        desiredAngles[YAW] = pVeh.m_pVehicleInfo!.turret[turretNum].yawClampRight
    }
    //clamp pitch
    desiredAngles[PITCH] = AngleNormalize180(desiredAngles[PITCH])
    if pVeh.m_pVehicleInfo!.turret[turretNum].pitchClampDown != 0 && desiredAngles[PITCH] > pVeh.m_pVehicleInfo!.turret[turretNum].pitchClampDown {
        aimCorrect = 0
        desiredAngles[PITCH] = pVeh.m_pVehicleInfo!.turret[turretNum].pitchClampDown
    }
    if pVeh.m_pVehicleInfo!.turret[turretNum].pitchClampUp != 0 && desiredAngles[PITCH] < pVeh.m_pVehicleInfo!.turret[turretNum].pitchClampUp {
        aimCorrect = 0
        desiredAngles[PITCH] = pVeh.m_pVehicleInfo!.turret[turretNum].pitchClampUp
    }
    //Now get the offset we want from our current relative angles
    AnglesSubtract(desiredAngles, curAngles, &addAngles)
    //Now cap the addAngles for our fTurnSpeed
    if addAngles[PITCH] > turretStats.fTurnSpeed {
        //aimCorrect = qfalse;//???
        addAngles[PITCH] = turretStats.fTurnSpeed
    } else if addAngles[PITCH] < -turretStats.fTurnSpeed {
        //aimCorrect = qfalse;//???
        addAngles[PITCH] = -turretStats.fTurnSpeed
    }
    if addAngles[YAW] > turretStats.fTurnSpeed {
        //aimCorrect = qfalse;//???
        addAngles[YAW] = turretStats.fTurnSpeed
    } else if addAngles[YAW] < -turretStats.fTurnSpeed {
        //aimCorrect = qfalse;//???
        addAngles[YAW] = -turretStats.fTurnSpeed
    }
    //Now add the additional angles back in to our current relative angles
    //FIXME: add some AI aim error randomness...?
    newAngles[PITCH] = AngleNormalize180(curAngles[PITCH] + addAngles[PITCH])
    newAngles[YAW] = AngleNormalize180(curAngles[YAW] + addAngles[YAW])
    //Now set the bone angles to the new angles
    //set yaw
    if turretStats.yawBone != nil {
        yawAngles = vec3_t()
        yawAngles[turretStats.yawAxis] = newAngles[YAW]
        NPC_SetBoneAngles(parent, turretStats.yawBone!, yawAngles)
    }
    //set pitch
    if turretStats.pitchBone != nil {
        pitchAngles = vec3_t()
        pitchAngles[turretStats.pitchAxis] = newAngles[PITCH]
        NPC_SetBoneAngles(parent, turretStats.pitchBone!, pitchAngles)
    }
    //force muzzle to recalc next check
    pVeh.m_iMuzzleTime[curMuzzle] = 0

    return aimCorrect != 0
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_vehicleTurret.c:193
private func VEH_TurretFindEnemies(_ pVeh: JKAMP.Vehicle, _ parent: Entity, _ turretStats: JKAMP.TurretStats, _ turretNum: Int32, _ curMuzzle: Int32) -> Bool {
    var found: Bool = false
    var i: Int32 = 0
    var count: Int32 = 0
    var bestDist: Float = turretStats.fAIRange * turretStats.fAIRange
    var enemyDist: Float = 0
    var enemyDir = vec3_t()
    var org = vec3_t()
    var org2 = vec3_t()
    var foundClient: Bool = false
    // Port-note: A local `gentity_t *[1024] entity_list` the table has no type for.
    // Raven wrote: gentity_t *entity_list[MAX_GENTITIES];
    portMissing("VEH_TurretFindEnemies", source: "oracle/codemp/game/g_vehicleTurret.c:193")
    var target: Entity?
    var bestTarget: Entity? = nil

    WP_CalcVehMuzzle(parent, curMuzzle)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Slots<Float>' to type 'vec3_t' (aka 'SIMD3<Float>')".
    // Raven wrote: VectorCopy( pVeh->m_vMuzzlePos[curMuzzle], org2 )
    portMissing("VEH_TurretFindEnemies", source: "oracle/codemp/game/g_vehicleTurret.c:193")

    // Port-note: A read of `entity_list`, a local the draft left as a hole.
    // Raven wrote: count = G_RadiusList( org2, turretStats->fAIRange, parent, qtrue, entity_list )
    portMissing("VEH_TurretFindEnemies", source: "oracle/codemp/game/g_vehicleTurret.c:193")

    // Port-note: Raven's block leaves a loop outside the record's scope, and the closure cannot.
    // Raven wrote: for ( i = 0; i < count; i++ ) { trace_t tr; target = entity_list[i]; if ( target == parent || !target->takedamage || target->health <= 0 || ( target->flags & FL_NOTARGET )) { continue; } if ( !target->client ) {// only attack clients if ( !(target->flags&FL_BBRUSH)//not a breakable brush || !target->takedamage//is a bbrush, but invincible || (target->NPC_targetname&&parent->targetname&&Q_stricmp(target->NPC_targetname,parent->targetname)!=0) )//not in invicible bbrush, but can only be broken by an NPC that is not me { if ( target->s.weapon == WP_TURRET && target->classname && Q_strncmp( "misc_turret", target->classname, 11 ) == 0 ) {//these guys we want to shoot at } else { continue; } } //else: we will shoot at bbrushes! } else if ( target->client->sess.sessionTeam == TEAM_SPECTATOR ) { continue; } if ( target == ((gentity_t*)pVeh->m_pPilot) || target->r.ownerNum == parent->s.number ) {//don't get angry at my pilot or passengers? continue; } if ( parent->client && parent->client->sess.sessionTeam ) { if ( target->client ) { if ( target->client->sess.sessionTeam == parent->client->sess.sessionTeam ) { // A bot/client/NPC we don't want to shoot continue; } } else if ( target->teamnodmg == parent->client->sess.sessionTeam ) {//some other entity that's allied with us continue; } } if ( !trap_InPVS( org2, target->r.currentOrigin )) { continue; } VectorCopy( target->r.currentOrigin, org ); trap_Trace( &tr, org2, NULL, NULL, org, parent->s.number, MASK_SHOT ); if ( tr.entityNum == target->s.number || (!tr.allsolid && !tr.startsolid && tr.fraction == 1.0 ) ) { // Only acquire if have a clear shot, Is it in range and closer than our best? VectorSubtract( target->r.currentOrigin, org2, enemyDir ); enemyDist = VectorLengthSquared( enemyDir ); if ( enemyDist < bestDist || (target->client && !foundClient))// all things equal, keep current { bestTarget = target; bestDist = enemyDist; found = qtrue; if ( target->client ) {//prefer clients over non-clients foundClient = qtrue; } } } }
    portMissing("VEH_TurretFindEnemies", source: "oracle/codemp/game/g_vehicleTurret.c:193")

    if found {
        pVeh.turretStatus[turretNum].enemyEntNum = bestTarget!.s.number
    }

    return found
}

/// Source: oracle/codemp/game/g_vehicleTurret.c:304
func VEH_TurretObeyPassengerControl(_ pVeh: JKAMP.Vehicle, _ parent: Entity, _ turretNum: Int32) {
    let turretStats: TurretStats? = pVeh.m_pVehicleInfo!.turret[turretNum]
    let passenger: Entity? = pVeh.m_ppPassengers[turretStats!.passengerNum - 1].map { Entity($0) }

    if passenger != nil && passenger!.client != nil && passenger!.health > 0 {
        //a valid, living passenger client
        let vehWeapon: VehWeaponInfo? = g_vehWeaponInfo[turretStats!.iWeapon]
        let curMuzzle: Int32 = pVeh.turretStatus[turretNum].nextMuzzle
        var aimAngles = vec3_t()
        aimAngles = passenger!.client!.ps.viewangles

        VEH_TurretAim(pVeh, parent, nil, turretStats!, vehWeapon!, turretNum, curMuzzle, &aimAngles)
        if (passenger!.client!.pers.cmd.buttons & (BUTTON_ATTACK | BUTTON_ALT_ATTACK)) != 0 {
            //he's pressing an attack button, so fire!
            VEH_TurretCheckFire(pVeh, parent, turretStats!, vehWeapon!, turretNum, curMuzzle)
        }
    }
}

/// Source: oracle/codemp/game/g_vehicleTurret.c:324
func VEH_TurretThink(_ pVeh: JKAMP.Vehicle, _ parent: Entity, _ turretNum: Int32) {
    var doAim: Bool = false
    var enemyDist: Float = 0
    var rangeSq: Float = 0
    var enemyDir = vec3_t()
    let turretStats: TurretStats? = pVeh.m_pVehicleInfo!.turret[turretNum]
    var vehWeapon: VehWeaponInfo? = nil
    var turretEnemy: Entity? = nil
    var curMuzzle: Int32 = 0


    if turretStats == nil || turretStats!.iAmmoMax == 0 {
        //not a valid turret
        return
    }

    if turretStats!.passengerNum != 0 && pVeh.m_iNumPassengers >= turretStats!.passengerNum {
        //the passenger that has control of this turret is on the ship
        VEH_TurretObeyPassengerControl(pVeh, parent, turretNum)
        return
    } else if !turretStats!.bAI {
        //this turret does not think on its own.
        return
    }
    //okay, so it has AI, but still don't think if there's no pilot!
    if pVeh.m_pPilot == nil {
        return
    }

    vehWeapon = g_vehWeaponInfo[turretStats!.iWeapon]
    rangeSq = (turretStats!.fAIRange * turretStats!.fAIRange)
    curMuzzle = pVeh.turretStatus[turretNum].nextMuzzle

    if pVeh.turretStatus[turretNum].enemyEntNum < ENTITYNUM_WORLD {
        turretEnemy = g_entities[pVeh.turretStatus[turretNum].enemyEntNum]
        if turretEnemy!.health < 0 || !turretEnemy!.inuse || turretEnemy == (pVeh.m_pPilot.map { Entity($0) }) || turretEnemy == parent || turretEnemy!.r.ownerNum == parent.s.number || (turretEnemy!.client != nil && turretEnemy!.client!.sess.sessionTeam == TEAM_SPECTATOR) {
            //don't keep going after spectators, pilot, self, dead people, etc.
            turretEnemy = nil
            pVeh.turretStatus[turretNum].enemyEntNum = ENTITYNUM_NONE
        }
    }

    if pVeh.turretStatus[turretNum].enemyHoldTime < level.time {
        if VEH_TurretFindEnemies(pVeh, parent, turretStats!, turretNum, curMuzzle) {
            turretEnemy = g_entities[pVeh.turretStatus[turretNum].enemyEntNum]
            doAim = true
        } else if parent.enemy != nil && parent.enemy!.s.number < ENTITYNUM_WORLD {
            if g_gametype.integer < GT_TEAM || !OnSameTeam(parent.enemy!, parent) {
                //either not in a team game or the enemy isn't on the same team
                turretEnemy = parent.enemy
                doAim = true
            }
        }
        if turretEnemy != nil {
            //found one
            if turretEnemy!.client != nil {
                //hold on to clients for a min of 3 seconds
                pVeh.turretStatus[turretNum].enemyHoldTime = level.time + 3000
            } else {
                //hold less
                pVeh.turretStatus[turretNum].enemyHoldTime = level.time + 500
            }
        }
    }
    if turretEnemy != nil {
        if turretEnemy!.health > 0 {
            // enemy is alive
            WP_CalcVehMuzzle(parent, curMuzzle)
            // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '-' cannot be applied to operands of type 'vec3_t' (aka 'SIMD3<Float>') and 'Slots<Float>'".
            // Raven wrote: VectorSubtract( turretEnemy->r.currentOrigin, pVeh->m_vMuzzlePos[curMuzzle], enemyDir )
            portMissing("VEH_TurretThink", source: "oracle/codemp/game/g_vehicleTurret.c:324")
            enemyDist = VectorLengthSquared(enemyDir)

            if enemyDist < rangeSq {
                // was in valid radius
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<Float>' to expected argument type 'vec3_t' (aka 'SIMD3<Float>')".
                // Raven wrote: if ( trap_InPVS( pVeh->m_vMuzzlePos[curMuzzle], turretEnemy->r.currentOrigin ) ) { // Every now and again, check to see if we can even trace to the enemy trace_t tr; vec3_t start, end; VectorCopy( pVeh->m_vMuzzlePos[curMuzzle], start ); VectorCopy( turretEnemy->r.currentOrigin, end ); trap_Trace( &tr, start, NULL, NULL, end, parent->s.number, MASK_SHOT ); if ( tr.entityNum == turretEnemy->s.number || (!tr.allsolid && !tr.startsolid ) ) { doAim = qtrue; // Can see our enemy } }
                portMissing("VEH_TurretThink", source: "oracle/codemp/game/g_vehicleTurret.c:324")
            }
        }
    }

    if doAim {
        var aimAngles = vec3_t()
        if VEH_TurretAim(pVeh, parent, turretEnemy, turretStats!, vehWeapon!, turretNum, curMuzzle, &aimAngles) {
            VEH_TurretCheckFire(pVeh, parent, turretStats!, vehWeapon!, turretNum, curMuzzle)
        }
    }
}
