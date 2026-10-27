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
        missile = WP_FireVehicleWeapon(parent, &pVeh.m_vMuzzlePos[curMuzzle], pVeh.m_vMuzzleDir[curMuzzle], vehWeapon, (turretNum != 0), true)

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
        diff = org - pVeh.m_vMuzzlePos[curMuzzle]
        dist = VectorNormalize(&diff)
        if turretEnemy.client != nil {
            velocity = turretEnemy.client!.ps.velocity
        } else {
            velocity = turretEnemy.s.pos.trDelta
        }
        _VectorMA(org, (dist / fSpeed), velocity, &org)
    }

    //FIXME: this isn't quite right, it's aiming from the muzzle, not the center of the turret...
    enemyDir = org - pVeh.m_vMuzzlePos[curMuzzle]
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
    vectoangles(pVeh.m_vMuzzleDir[curMuzzle], &curAngles)
    //subtract out the vehicle's angles to get the relative alignment
    AnglesSubtract(curAngles, pVeh.m_vOrientationVector, &curAngles)

    if turretEnemy != nil {
        aimCorrect = 1
        // ...then we'll calculate what new aim adjustments we should attempt to make this frame
        // Aim at enemy
        VEH_TurretAnglesToEnemy(pVeh, curMuzzle, vehWeapon.fSpeed, turretEnemy!, turretStats.bAILead, &desiredAngles)
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
    var entity_list = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))
    var target: Entity?
    var bestTarget: Entity? = nil

    WP_CalcVehMuzzle(parent, curMuzzle)
    org2 = pVeh.m_vMuzzlePos[curMuzzle]

    count = G_RadiusList(org2, turretStats.fAIRange, parent, true, &entity_list)

    i = 0
    while i < count {
        Trace.scratch { tr in
            target = entity_list[i]

            if target == parent || !target!.takedamage || target!.health <= 0 || (target!.flags & FL_NOTARGET) != 0 {
                return
            }
            if target!.client == nil {
                // only attack clients
                if !((target!.flags & FL_BBRUSH) != 0) //not a breakable brush
                    || !target!.takedamage //is a bbrush, but invincible
                    || (target!.NPC_targetname != nil && parent.targetname != nil && Q_stricmp(target!.NPC_targetname, parent.targetname) != 0) {
                    //not in invicible bbrush, but can only be broken by an NPC that is not me
                    if target!.s.weapon == WP_TURRET && target!.classname != nil && Q_strncmp("misc_turret", target!.classname!, 11) == 0 {
                        //these guys we want to shoot at
                    } else {
                        return
                    }
                }
                //else: we will shoot at bbrushes!
            } else if target!.client!.sess.sessionTeam == TEAM_SPECTATOR {
                return
            }
            if target == (pVeh.m_pPilot.map { Entity($0) }) || target!.r.ownerNum == parent.s.number {
                //don't get angry at my pilot or passengers?
                return
            }
            if parent.client != nil && parent.client!.sess.sessionTeam != 0 {
                if target!.client != nil {
                    if target!.client!.sess.sessionTeam == parent.client!.sess.sessionTeam {
                        // A bot/client/NPC we don't want to shoot
                        return
                    }
                } else if target!.teamnodmg == parent.client!.sess.sessionTeam {
                    //some other entity that's allied with us
                    return
                }
            }
            if !trap_InPVS(org2, target!.r.currentOrigin) {
                return
            }

            org = target!.r.currentOrigin

            trap_Trace(tr, org2, vec3_origin, vec3_origin, org, parent.s.number, MASK_SHOT)

            if tr.entityNum == target!.s.number || (tr.allsolid == 0 && tr.startsolid == 0 && tr.fraction == 1.0) {
                // Only acquire if have a clear shot, Is it in range and closer than our best?
                enemyDir = target!.r.currentOrigin - org2
                enemyDist = VectorLengthSquared(enemyDir)

                if enemyDist < bestDist || (target!.client != nil && !foundClient) {
                    // all things equal, keep current
                    bestTarget = target
                    bestDist = enemyDist
                    found = true
                    if target!.client != nil {
                        //prefer clients over non-clients
                        foundClient = true
                    }
                }
            }
        }
        i += 1
    }

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
            enemyDir = turretEnemy!.r.currentOrigin - pVeh.m_vMuzzlePos[curMuzzle]
            enemyDist = VectorLengthSquared(enemyDir)

            if enemyDist < rangeSq {
                // was in valid radius
                if trap_InPVS(pVeh.m_vMuzzlePos[curMuzzle], turretEnemy!.r.currentOrigin) {
                    // Every now and again, check to see if we can even trace to the enemy
                    Trace.scratch { tr in
                        var start = vec3_t()
                        var end = vec3_t()
                        start = pVeh.m_vMuzzlePos[curMuzzle]

                        end = turretEnemy!.r.currentOrigin
                        trap_Trace(tr, start, vec3_origin, vec3_origin, end, parent.s.number, MASK_SHOT)

                        if tr.entityNum == turretEnemy!.s.number || (tr.allsolid == 0 && tr.startsolid == 0) {
                            doAim = true // Can see our enemy
                        }
                    }
                }
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
