import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_turret.c:7
func CreepToPosition(_ ideal: inout JKAShared.vec3_t, _ current: inout JKAShared.vec3_t) {
    let max_degree_switch: Float = 90
    var degrees_negative: Int32 = 0
    var degrees_positive: Int32 = 0
    var doNegative: Int32 = 0

    var angle_ideal: Int32
    var angle_current: Int32

    angle_ideal = Int32(ideal[YAW])
    angle_current = Int32(current[YAW])

    if angle_ideal <= angle_current {
        degrees_negative = (angle_current - angle_ideal)

        degrees_positive = (360 - angle_current) + angle_ideal
    } else {
        degrees_negative = angle_current + (360 - angle_ideal)

        degrees_positive = (angle_ideal - angle_current)
    }

    if degrees_negative < degrees_positive {
        doNegative = 1
    }

    if doNegative != 0 {
        current[YAW] -= max_degree_switch

        if current[YAW] < ideal[YAW] && (current[YAW] + (max_degree_switch * 2)) >= ideal[YAW] {
            current[YAW] = ideal[YAW]
        }

        if current[YAW] < 0 {
            current[YAW] += 361
        }
    } else {
        current[YAW] += max_degree_switch

        if current[YAW] > ideal[YAW] && (current[YAW] - (max_degree_switch * 2)) <= ideal[YAW] {
            current[YAW] = ideal[YAW]
        }

        if current[YAW] > 360 {
            current[YAW] -= 361
        }
    }

    if ideal[PITCH] < 0 {
        ideal[PITCH] += 360
    }

    angle_ideal = Int32(ideal[PITCH])
    angle_current = Int32(current[PITCH])

    doNegative = 0

    if angle_ideal <= angle_current {
        degrees_negative = (angle_current - angle_ideal)

        degrees_positive = (360 - angle_current) + angle_ideal
    } else {
        degrees_negative = angle_current + (360 - angle_ideal)

        degrees_positive = (angle_ideal - angle_current)
    }

    if degrees_negative < degrees_positive {
        doNegative = 1
    }

    if doNegative != 0 {
        current[PITCH] -= max_degree_switch

        if current[PITCH] < ideal[PITCH] && (current[PITCH] + (max_degree_switch * 2)) >= ideal[PITCH] {
            current[PITCH] = ideal[PITCH]
        }

        if current[PITCH] < 0 {
            current[PITCH] += 361
        }
    } else {
        current[PITCH] += max_degree_switch

        if current[PITCH] > ideal[PITCH] && (current[PITCH] - (max_degree_switch * 2)) <= ideal[PITCH] {
            current[PITCH] = ideal[PITCH]
        }

        if current[PITCH] > 360 {
            current[PITCH] -= 361
        }
    }
}

/// Source: oracle/codemp/cgame/cg_turret.c:125
func TurretClientRun(_ ent: Centity) {
    if ent.ghoul2 == nil {
        var weaponInfo: WeaponInfo?

        trap_G2API_InitGhoul2Model(&ent.ghoul2, CG_ConfigString(CS_MODELS + ent.currentState.modelindex), 0, 0, 0, 0, 0)

        if ent.ghoul2 == nil {
            //bad
            return
        }

        ent.torsoBolt = trap_G2API_AddBolt(ent.ghoul2, 0, "*flash02")

        trap_G2API_SetBoneAngles(ent.ghoul2, 0, "bone_hinge", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_Y, POSITIVE_Z, POSITIVE_X, nil, 100, cg.time)
        trap_G2API_SetBoneAngles(ent.ghoul2, 0, "bone_gback", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_Y, POSITIVE_Z, POSITIVE_X, nil, 100, cg.time)
        trap_G2API_SetBoneAngles(ent.ghoul2, 0, "bone_barrel", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_Y, POSITIVE_Z, POSITIVE_X, nil, 100, cg.time)

        trap_G2API_SetBoneAnim(ent.ghoul2, 0, "model_root", 0, 11, BONE_ANIM_OVERRIDE_FREEZE, 0.8, cg.time, 0, 0)

        ent.turAngles[ROLL] = 0
        ent.turAngles[PITCH] = 90
        ent.turAngles[YAW] = 0

        weaponInfo = cg_weapons[WP_TURRET]

        if !weaponInfo!.registered {
            CG_RegisterWeapon(WP_TURRET)
        }
    }

    if ent.currentState.fireflag == 2 {
        //I'm about to blow
        trap_G2API_SetBoneAngles(ent.ghoul2, 0, "bone_hinge", ent.turAngles, BONE_ANGLES_REPLACE, NEGATIVE_Y, NEGATIVE_Z, NEGATIVE_X, nil, 100, cg.time)
        return
    } else if ent.currentState.fireflag != 0 && ent.bolt4 != ent.currentState.fireflag {
        var muzzleOrg = vec3_t()
        var muzzleDir = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in

            trap_G2API_GetBoltMatrix(ent.ghoul2, 0, ent.torsoBolt, boltMatrix, vec3_origin, ent.lerpOrigin, cg.time, cgs.gameModels, &ent.modelScale)
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &muzzleOrg)
            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_X, &muzzleDir)

            trap_FX_PlayEffectID(cgs.effects.mTurretMuzzleFlash, muzzleOrg, muzzleDir, -1, -1)

            ent.bolt4 = ent.currentState.fireflag
        }
    } else if ent.currentState.fireflag == 0 {
        ent.bolt4 = 0
    }

    if ent.currentState.bolt2 != ENTITYNUM_NONE {
        //turn toward the enemy
        let enemy: Centity? = cg_entities[ent.currentState.bolt2]

        if enemy != nil {
            var enAng = vec3_t()
            var enPos = vec3_t()

            enPos = enemy!.currentState.pos.trBase

            enAng = enPos - ent.lerpOrigin
            VectorNormalize(&enAng)
            vectoangles(enAng, &enAng)
            enAng[ROLL] = 0
            enAng[PITCH] += 90

            CreepToPosition(&enAng, &ent.turAngles)
        }
    } else {
        var idleAng = vec3_t()
        var turnAmount: Float = 0

        if ent.turAngles[YAW] > 360 {
            ent.turAngles[YAW] -= 361
        }

        if ent.dustTrailTime == 0 {
            ent.dustTrailTime = cg.time
        }

        turnAmount = Float(Double(cg.time - ent.dustTrailTime) * 0.03)

        if turnAmount > 360 {
            turnAmount = 360
        }

        idleAng[PITCH] = 90
        idleAng[ROLL] = 0
        idleAng[YAW] = ent.turAngles[YAW] + turnAmount
        ent.dustTrailTime = cg.time

        CreepToPosition(&idleAng, &ent.turAngles)
    }

    if cg.time < ent.frame_minus1_refreshed {
        ent.frame_minus1_refreshed = cg.time
        return
    }

    ent.frame_minus1_refreshed = cg.time
    trap_G2API_SetBoneAngles(ent.ghoul2, 0, "bone_hinge", ent.turAngles, BONE_ANGLES_REPLACE, NEGATIVE_Y, NEGATIVE_Z, NEGATIVE_X, nil, 100, cg.time)
}
