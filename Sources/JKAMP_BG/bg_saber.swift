import Foundation
import JKAMP
import JKAShared

/// Source: oracle/codemp/game/bg_saber.c:114
let AFLAG_IDLE = (JKAShared.SETANIM_FLAG_NORMAL)

/// Source: oracle/codemp/game/bg_saber.c:115
let AFLAG_ACTIVE = (JKAShared.SETANIM_FLAG_OVERRIDE | JKAShared.SETANIM_FLAG_HOLD | JKAShared.SETANIM_FLAG_HOLDLESS)

/// Source: oracle/codemp/game/bg_saber.c:116
let AFLAG_WAIT = (JKAShared.SETANIM_FLAG_HOLD | JKAShared.SETANIM_FLAG_HOLDLESS)

/// Source: oracle/codemp/game/bg_saber.c:117
let AFLAG_FINISH = (JKAShared.SETANIM_FLAG_HOLD)

/// Source: oracle/codemp/game/bg_saber.c:120
// TODO: Port global saberMoveData
// Raven wrote: saberMoveData_t saberMoveData[LS_MOVE_MAX]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saber.c:324
// Raven wrote: int transitionMove[Q_NUM_QUADS][Q_NUM_QUADS]
let transitionMove: [[Int32]] = { () -> [[Int32]] in portMissing("transitionMove", source: "oracle/codemp/game/bg_saber.c:324") }()

/// Source: oracle/codemp/game/bg_saber.c:715
// Raven wrote: int saberMoveTransitionAngle[Q_NUM_QUADS][Q_NUM_QUADS]
let saberMoveTransitionAngle: [[Int32]] = { () -> [[Int32]] in portMissing("saberMoveTransitionAngle", source: "oracle/codemp/game/bg_saber.c:715") }()

/// Source: oracle/codemp/game/bg_saber.c:1623
let BACK_STAB_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/bg_saber.c:1802
let FLIPHACK_DISTANCE = 200 as Int32

/// Source: oracle/codemp/game/bg_saber.c:2112
let SABER_ALT_ATTACK_POWER = 50 as Int32

/// Source: oracle/codemp/game/bg_saber.c:2113
let SABER_ALT_ATTACK_POWER_LR = 10 as Int32

/// Source: oracle/codemp/game/bg_saber.c:2114
let SABER_ALT_ATTACK_POWER_FB = 25 as Int32

/// Source: oracle/codemp/game/bg_saber.c:2777
// Raven wrote: int bg_parryDebounce[NUM_FORCE_POWER_LEVELS]
public let bg_parryDebounce: [Int32] = { () -> [Int32] in portMissing("bg_parryDebounce", source: "oracle/codemp/game/bg_saber.c:2777") }()

/// Source: oracle/codemp/game/bg_saber.c:10
func PM_irand_timesync(_ val1: Int32, _ val2: Int32) -> Int32 {
    var i: Int32

    i = Int32((val1 - 1) + (Q_random(&pm.cmd.serverTime) * (val2 - val1)) + 1)
    if i < val1 {
        i = val1
    }
    if i > val2 {
        i = val2
    }

    return i
}

/// Source: oracle/codemp/game/bg_saber.c:27
public func BG_ForcePowerDrain(_ ps: JKAMP.PlayerState, _ forcePower: JKAMP.forcePowers_t, _ overrideAmt: Int32) {
    //take away the power
    var drain: Int32 = overrideAmt

    /*
    if (ps->powerups[PW_FORCE_BOON])
    {
    return;
    }
    */
    //No longer grant infinite force with boon.

    if drain == 0 {
        drain = forcePowerNeeded[ps.fd.forcePowerLevel[forcePower]][forcePower]
    }
    if drain == 0 {
        return
    }

    if forcePower == FP_LEVITATION {
        //special case
        var jumpDrain: Int32 = 0

        if ps.velocity[2] > 250 {
            jumpDrain = 20
        } else if ps.velocity[2] > 200 {
            jumpDrain = 16
        } else if ps.velocity[2] > 150 {
            jumpDrain = 12
        } else if ps.velocity[2] > 100 {
            jumpDrain = 8
        } else if ps.velocity[2] > 50 {
            jumpDrain = 6
        } else if ps.velocity[2] > 0 {
            jumpDrain = 4
        }

        if jumpDrain != 0 {
            if ps.fd.forcePowerLevel[FP_LEVITATION] != 0 {
                //don't divide by 0!
                jumpDrain /= ps.fd.forcePowerLevel[FP_LEVITATION]
            }
        }

        ps.fd.forcePower -= jumpDrain
        if ps.fd.forcePower < 0 {
            ps.fd.forcePower = 0
        }

        return
    }

    ps.fd.forcePower -= drain
    if ps.fd.forcePower < 0 {
        ps.fd.forcePower = 0
    }
}

/// Source: oracle/codemp/game/bg_saber.c:102
func BG_EnoughForcePowerForMove(_ cost: Int32) -> Bool {
    if pm.ps.fd.forcePower < cost {
        PM_AddEvent(EV_NOAMMO)
        return false
    }

    return true
}

/// Source: oracle/codemp/game/bg_saber.c:392
func PM_AttackMoveForQuad(_ quad: Int32) -> JKAMP.saberMoveName_t {
    switch quad {
    case Q_B, Q_BR:
        return LS_A_BR2TL

    case Q_R:
        return LS_A_R2L

    case Q_TR:
        return LS_A_TR2BL

    case Q_T:
        return LS_A_T2B

    case Q_TL:
        return LS_A_TL2BR

    case Q_L:
        return LS_A_L2R

    case Q_BL:
        return LS_A_BL2TR

    default:
        break
    }
    return LS_NONE
}

/// Source: oracle/codemp/game/bg_saber.c:424
func PM_SaberAnimTransitionAnim(_ curmove: Int32, _ newmove: Int32) -> Int32 {
    var retmove: Int32 = newmove
    if curmove == LS_READY {
        //just standing there
        switch newmove {
        case LS_A_TL2BR, LS_A_L2R, LS_A_BL2TR, LS_A_BR2TL, LS_A_R2L, LS_A_TR2BL, LS_A_T2B:
            //transition is the start
            retmove = LS_S_TL2BR + (newmove - LS_A_TL2BR)

        default:
            break
        }
    } else {
        switch newmove {
        //transitioning to ready pose
        case LS_READY:
            switch curmove {
            //transitioning from an attack
            case LS_A_TL2BR, LS_A_L2R, LS_A_BL2TR, LS_A_BR2TL, LS_A_R2L, LS_A_TR2BL, LS_A_T2B:
                //transition is the return
                retmove = LS_R_TL2BR + (newmove - LS_A_TL2BR)

            default:
                break
            }
            //transitioning to an attack

        case LS_A_TL2BR, LS_A_L2R, LS_A_BL2TR, LS_A_BR2TL, LS_A_R2L, LS_A_TR2BL, LS_A_T2B:
            if newmove == curmove {
                //going into an attack
                if PM_SaberKataDone(curmove, newmove) {
                    //done with this kata, must return to ready before attack again
                    retmove = LS_R_TL2BR + (newmove - LS_A_TL2BR)
                } else {
                    //okay to chain to another attack
                    retmove = transitionMove[saberMoveData[curmove].endQuad][saberMoveData[newmove].startQuad]
                }
            } else if saberMoveData[curmove].endQuad == saberMoveData[newmove].startQuad {
                //new move starts from same quadrant
                retmove = newmove
            } else {
                switch curmove {
                //transitioning from an attack
                case LS_A_TL2BR, LS_A_L2R, LS_A_BL2TR, LS_A_BR2TL, LS_A_R2L, LS_A_TR2BL, LS_A_T2B, LS_D1_BR, LS_D1__R, LS_D1_TR, LS_D1_T_, LS_D1_TL, LS_D1__L, LS_D1_BL, LS_D1_B_:
                    retmove = transitionMove[saberMoveData[curmove].endQuad][saberMoveData[newmove].startQuad]
                    //transitioning from a return
                    //transitioning from a bounce
                    /*
                    case LS_BOUNCE_UL2LL:
                    case LS_BOUNCE_LL2UL:
                    case LS_BOUNCE_L2LL:
                    case LS_BOUNCE_L2UL:
                    case LS_BOUNCE_UR2LR:
                    case LS_BOUNCE_LR2UR:
                    case LS_BOUNCE_R2LR:
                    case LS_BOUNCE_R2UR:
                    case LS_BOUNCE_TOP:
                    case LS_OVER_UR2UL:
                    case LS_OVER_UL2UR:
                    case LS_BOUNCE_UR:
                    case LS_BOUNCE_UL:
                    case LS_BOUNCE_LR:
                    case LS_BOUNCE_LL:
                    */
                    //transitioning from a parry/reflection/knockaway/broken parry

                case LS_R_TL2BR, LS_R_L2R, LS_R_BL2TR, LS_R_BR2TL, LS_R_R2L, LS_R_TR2BL, LS_R_T2B, LS_PARRY_UP, LS_PARRY_UR, LS_PARRY_UL, LS_PARRY_LR, LS_PARRY_LL, LS_REFLECT_UP, LS_REFLECT_UR, LS_REFLECT_UL, LS_REFLECT_LR, LS_REFLECT_LL, LS_K1_T_, LS_K1_TR, LS_K1_TL, LS_K1_BR, LS_K1_BL, LS_V1_BR, LS_V1__R, LS_V1_TR, LS_V1_T_, LS_V1_TL, LS_V1__L, LS_V1_BL, LS_V1_B_, LS_H1_T_, LS_H1_TR, LS_H1_TL, LS_H1_BR, LS_H1_BL:
                    retmove = transitionMove[saberMoveData[curmove].endQuad][saberMoveData[newmove].startQuad]

                default:
                    break
                }
            }

        default:
            break
        }
    }

    if retmove == LS_NONE {
        return newmove
    }

    return retmove
}

/// Source: oracle/codemp/game/bg_saber.c:584
func PM_CheckStabDown() -> JKAMP.saberMoveName_t {
    var faceFwd = vec3_t()
    var facingAngles = vec3_t()
    var fwd = vec3_t()
    var ent: BgEntity? = nil
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> saberMoveName_t in
        //yeah, vm's may complain, but.. who cares!
        var trmins = vec3_t(-15, -15, -15)
        var trmaxs = vec3_t(15, 15, 15)

        let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
        if saber1 != nil && (saber1!.saberFlags & SFL_NO_STABDOWN) != 0 {
            return LS_NONE
        }
        if saber2 != nil && (saber2!.saberFlags & SFL_NO_STABDOWN) != 0 {
            return LS_NONE
        }

        if pm.ps.groundEntityNum == ENTITYNUM_NONE {
            //sorry must be on ground!
            return LS_NONE
        }
        if pm.ps.clientNum < MAX_CLIENTS {
            //player
            pm.ps.velocity[2] = 0
            pm.cmd.upmove = 0
        }

        facingAngles = vec3_t(0, pm.ps.viewangles[YAW], 0)
        // Raven passes NULL for the second and third outputs of `AngleVectors`.
        // The ported function takes them by reference, so the body passes scratch vectors it never reads.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(facingAngles, &faceFwd, &scratchRight, &scratchUp)

        //FIXME: need to only move forward until we bump into our target...?
        _VectorMA(pm.ps.origin, 164.0, faceFwd, &fwd)

        pm.runTrace(tr, pm.ps.origin, trmins, trmaxs, fwd, pm.ps.clientNum, MASK_PLAYERSOLID)

        if tr.entityNum < ENTITYNUM_WORLD {
            ent = PM_BGEntForNum(tr.entityNum)
        }

        if ent != nil && (ent!.s.eType == ET_PLAYER || ent!.s.eType == ET_NPC) && BG_InKnockDown(ent!.s.legsAnim) {
            //guy is on the ground below me, do a top-down attack
            if pm.ps.fd.saberAnimLevel == SS_DUAL {
                return LS_STABDOWN_DUAL
            } else if pm.ps.fd.saberAnimLevel == SS_STAFF {
                return LS_STABDOWN_STAFF
            } else {
                return LS_STABDOWN
            }
        }
        return LS_NONE
    }
}

/// Source: oracle/codemp/game/bg_saber.c:650
func PM_SaberMoveQuadrantForMovement(_ ucmd: JKAMP.Usercmd) -> Int32 {
    if ucmd.rightmove > 0 {
        //moving right
        if ucmd.forwardmove > 0 {
            //forward right = TL2BR slash
            return Q_TL
        } else if ucmd.forwardmove < 0 {
            //backward right = BL2TR uppercut
            return Q_BL
        } else {
            //just right is a left slice
            return Q_L
        }
    } else if ucmd.rightmove < 0 {
        //moving left
        if ucmd.forwardmove > 0 {
            //forward left = TR2BL slash
            return Q_TR
        } else if ucmd.forwardmove < 0 {
            //backward left = BR2TL uppercut
            return Q_BR
        } else {
            //just left is a right slice
            return Q_R
        }
    } else {
        //not moving left or right
        if ucmd.forwardmove > 0 {
            //forward= T2B slash
            return Q_T
        } else if ucmd.forwardmove < 0 {
            //backward= T2B slash	//or B2T uppercut?
            return Q_T
        } else {
            //Not moving at all
            return Q_R
        }
    }
}

//===================================================================
/// Source: oracle/codemp/game/bg_saber.c:700
public func PM_SaberInBounce(_ move: Int32) -> Bool {
    if move >= LS_B1_BR && move <= LS_B1_BL {
        return true
    }
    if move >= LS_D1_BR && move <= LS_D1_BL {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_saber.c:783
func PM_SaberAttackChainAngle(_ move1: Int32, _ move2: Int32) -> Int32 {
    if move1 == -1 || move2 == -1 {
        return -1
    }
    return saberMoveTransitionAngle[saberMoveData[move1].endQuad][saberMoveData[move2].startQuad]
}

/// Source: oracle/codemp/game/bg_saber.c:792
func PM_SaberKataDone(_ curmove: Int32, _ newmove: Int32) -> Bool {
    if pm.ps.m_iVehicleNum != 0 {
        //never continue kata on vehicle
        if pm.ps.saberAttackChainCount > 0 {
            return true
        }
    }

    if pm.ps.fd.saberAnimLevel == SS_DESANN || pm.ps.fd.saberAnimLevel == SS_TAVION {
        //desann and tavion can link up as many attacks as they want
        return false
    }

    if pm.ps.fd.saberAnimLevel == SS_STAFF {
        //TEMP: for now, let staff attacks infinitely chain
        return false
    } else if pm.ps.fd.saberAnimLevel == SS_DUAL {
        //TEMP: for now, let staff attacks infinitely chain
        return false
    } else if pm.ps.fd.saberAnimLevel == FORCE_LEVEL_3 {
        if curmove == LS_NONE || newmove == LS_NONE {
            if pm.ps.fd.saberAnimLevel >= FORCE_LEVEL_3 && pm.ps.saberAttackChainCount > PM_irand_timesync(0, 1) {
                return true
            }
        } else if pm.ps.saberAttackChainCount > PM_irand_timesync(2, 3) {
            return true
        } else if pm.ps.saberAttackChainCount > 0 {
            let chainAngle: Int32 = PM_SaberAttackChainAngle(curmove, newmove)
            if chainAngle < 135 || chainAngle > 215 {
                //if trying to chain to a move that doesn't continue the momentum
                return true
            } else if chainAngle == 180 {
                //continues the momentum perfectly, allow it to chain 66% of the time
                if pm.ps.saberAttackChainCount > 1 {
                    return true
                }
            } else {
                //would continue the movement somewhat, 50% chance of continuing
                if pm.ps.saberAttackChainCount > 2 {
                    return true
                }
            }
        }
    } else {
        //Perhaps have chainAngle influence fast and medium chains as well? For now, just do level 3.
        if newmove == LS_A_TL2BR || newmove == LS_A_L2R || newmove == LS_A_BL2TR || newmove == LS_A_BR2TL || newmove == LS_A_R2L || newmove == LS_A_TR2BL {
            //lower chaining tolerance for spinning saber anims
            let chainTolerance: Int32

            if pm.ps.fd.saberAnimLevel == FORCE_LEVEL_1 {
                chainTolerance = 5
            } else {
                chainTolerance = 3
            }

            if pm.ps.saberAttackChainCount >= chainTolerance && PM_irand_timesync(1, pm.ps.saberAttackChainCount) > chainTolerance {
                return true
            }
        }
        if pm.ps.fd.saberAnimLevel == FORCE_LEVEL_2 && pm.ps.saberAttackChainCount > PM_irand_timesync(2, 5) {
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/game/bg_saber.c:886
func PM_SetAnimFrame(_ gent: JKAMP.PlayerState, _ frame: Int32, _ torso: Bool, _ legs: Bool) {
    gent.saberLockFrame = frame
}

/// Source: oracle/codemp/game/bg_saber.c:891
func PM_SaberLockWinAnim(_ victory: Bool, _ superBreak: Bool) -> Int32 {
    var winAnim: Int32 = -1
    switch pm.ps.torsoAnim {
    /*
    default:
    #ifndef FINAL_BUILD
    Com_Printf( S_COLOR_RED"ERROR-PM_SaberLockBreak: %s not in saberlock anim, anim = (%d)%s\n", pm->gent->NPC_type, pm->ps->torsoAnim, animTable[pm->ps->torsoAnim].name );
    #endif
    */
    case BOTH_BF2LOCK:
        if superBreak {
            winAnim = BOTH_LK_S_S_T_SB_1_W
        } else if !victory {
            winAnim = BOTH_BF1BREAK
        } else {
            pm.ps.saberMove = LS_A_T2B
            winAnim = BOTH_A3_T__B_
        }

    case BOTH_BF1LOCK:
        if superBreak {
            winAnim = BOTH_LK_S_S_T_SB_1_W
        } else if !victory {
            winAnim = BOTH_KNOCKDOWN4
        } else {
            pm.ps.saberMove = LS_K1_T_
            winAnim = BOTH_K1_S1_T_
        }

    case BOTH_CWCIRCLELOCK:
        if superBreak {
            winAnim = BOTH_LK_S_S_S_SB_1_W
        } else if !victory {
            pm.ps.saberMove = LS_V1_BL //pm->ps->saberBounceMove =
            pm.ps.saberBlocked = BLOCKED_PARRY_BROKEN
            winAnim = BOTH_V1_BL_S1
        } else {
            winAnim = BOTH_CWCIRCLEBREAK
        }

    case BOTH_CCWCIRCLELOCK:
        if superBreak {
            winAnim = BOTH_LK_S_S_S_SB_1_W
        } else if !victory {
            pm.ps.saberMove = LS_V1_BR //pm->ps->saberBounceMove =
            pm.ps.saberBlocked = BLOCKED_PARRY_BROKEN
            winAnim = BOTH_V1_BR_S1
        } else {
            winAnim = BOTH_CCWCIRCLEBREAK
        }

    default:
        //must be using new system:
        break
    }
    if winAnim != -1 {
        PM_SetAnim(SETANIM_BOTH, winAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
        pm.ps.weaponTime = pm.ps.torsoTimer
        pm.ps.saberBlocked = BLOCKED_NONE
        pm.ps.weaponstate = WEAPON_FIRING
        /*
        if ( superBreak
        && winAnim != BOTH_LK_ST_DL_T_SB_1_W )
        {//going to attack with saber, do a saber trail
        pm->ps->SaberActivateTrail( 200 );
        }
        */
    }
    return winAnim
}

/// Source: oracle/codemp/game/bg_saber.c:1000
func PM_SaberLockLoseAnim(_ genemy: JKAMP.PlayerState, _ victory: Bool, _ superBreak: Bool) -> Int32 {
    var loseAnim: Int32 = -1
    switch genemy.torsoAnim {
    /*
    default:
    #ifndef FINAL_BUILD
    Com_Printf( S_COLOR_RED"ERROR-PM_SaberLockBreak: %s not in saberlock anim, anim = (%d)%s\n", genemy->NPC_type, genemy->client->ps.torsoAnim, animTable[genemy->client->ps.torsoAnim].name );
    #endif
    */
    case BOTH_BF2LOCK:
        if superBreak {
            loseAnim = BOTH_LK_S_S_T_SB_1_L
        } else if !victory {
            loseAnim = BOTH_BF1BREAK
        } else {
            if !victory {
                //no-one won
                genemy.saberMove = LS_K1_T_
                loseAnim = BOTH_K1_S1_T_
            } else {
                //FIXME: this anim needs to transition back to ready when done
                loseAnim = BOTH_BF1BREAK
            }
        }

    case BOTH_BF1LOCK:
        if superBreak {
            loseAnim = BOTH_LK_S_S_T_SB_1_L
        } else if !victory {
            loseAnim = BOTH_KNOCKDOWN4
        } else {
            if !victory {
                //no-one won
                genemy.saberMove = LS_A_T2B
                loseAnim = BOTH_A3_T__B_
            } else {
                loseAnim = BOTH_KNOCKDOWN4
            }
        }

    case BOTH_CWCIRCLELOCK:
        if superBreak {
            loseAnim = BOTH_LK_S_S_S_SB_1_L
        } else if !victory {
            genemy.saberMove = LS_V1_BL //genemy->saberBounceMove =
            genemy.saberBlocked = BLOCKED_PARRY_BROKEN
            loseAnim = BOTH_V1_BL_S1
        } else {
            if !victory {
                //no-one won
                loseAnim = BOTH_CCWCIRCLEBREAK
            } else {
                genemy.saberMove = LS_V1_BL //genemy->saberBounceMove =
                genemy.saberBlocked = BLOCKED_PARRY_BROKEN
                loseAnim = BOTH_V1_BL_S1
                /*
                genemy->client->ps.saberMove = genemy->client->ps.saberBounceMove = LS_H1_BR;
                genemy->client->ps.saberBlocked = BLOCKED_PARRY_BROKEN;
                loseAnim = BOTH_H1_S1_BL;
                */
            }
        }

    case BOTH_CCWCIRCLELOCK:
        if superBreak {
            loseAnim = BOTH_LK_S_S_S_SB_1_L
        } else if !victory {
            genemy.saberMove = LS_V1_BR //genemy->saberBounceMove =
            genemy.saberBlocked = BLOCKED_PARRY_BROKEN
            loseAnim = BOTH_V1_BR_S1
        } else {
            if !victory {
                //no-one won
                loseAnim = BOTH_CWCIRCLEBREAK
            } else {
                genemy.saberMove = LS_V1_BR //genemy->saberBounceMove =
                genemy.saberBlocked = BLOCKED_PARRY_BROKEN
                loseAnim = BOTH_V1_BR_S1
                /*
                genemy->client->ps.saberMove = genemy->client->ps.saberBounceMove = LS_H1_BL;
                genemy->client->ps.saberBlocked = BLOCKED_PARRY_BROKEN;
                loseAnim = BOTH_H1_S1_BR;
                */
            }
        }

    default:
        break
    }
    if loseAnim != -1 {
        NPC_SetAnim(pm.entity(at: genemy.clientNum), SETANIM_BOTH, loseAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
        genemy.weaponTime = genemy.torsoTimer // + 250;
        genemy.saberBlocked = BLOCKED_NONE
        genemy.weaponstate = WEAPON_READY
    }
    return loseAnim
}

/// Source: oracle/codemp/game/bg_saber.c:1128
func PM_SaberLockResultAnim(_ duelist: JKAMP.PlayerState, _ superBreak: Bool, _ won: Bool) -> Int32 {
    var baseAnim: Int32 = duelist.torsoAnim
    switch baseAnim {
    case BOTH_LK_S_S_S_L_2:
        baseAnim = BOTH_LK_S_S_S_L_1

    case BOTH_LK_S_S_T_L_2:
        baseAnim = BOTH_LK_S_S_T_L_1

    case BOTH_LK_DL_DL_S_L_2:
        baseAnim = BOTH_LK_DL_DL_S_L_1

    case BOTH_LK_DL_DL_T_L_2:
        baseAnim = BOTH_LK_DL_DL_T_L_1

    case BOTH_LK_ST_ST_S_L_2:
        baseAnim = BOTH_LK_ST_ST_S_L_1

    case BOTH_LK_ST_ST_T_L_2:
        baseAnim = BOTH_LK_ST_ST_T_L_1

    default:
        break
    }
    //what kind of break?
    if !superBreak {
        baseAnim -= 2
    } else if superBreak {
        baseAnim += 1
    } else {
        //WTF?  Not a valid result
        return -1
    }
    //win or lose?
    if won {
        baseAnim += 1
    }

    //play the anim and hold it
    //server-side: set it on the other guy, too
    if duelist.clientNum == pm.ps.clientNum {
        //me
        PM_SetAnim(SETANIM_BOTH, baseAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
    } else {
        //other guy
        NPC_SetAnim(pm.entity(at: duelist.clientNum), SETANIM_BOTH, baseAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    }

    if superBreak && !won {
        //if you lose a superbreak, you're defenseless
        /*
        //Taken care of in SetSaberBoxSize()
        //make saberent not block
        gentity_t *saberent = &g_entities[duelist->client->ps.saberEntityNum];
        if ( saberent )
        {
        VectorClear(saberent->mins);
        VectorClear(saberent->maxs);
        G_SetOrigin(saberent, duelist->currentOrigin);
        }
        */
        if 1 != 0 {
            //set sabermove to none
            duelist.saberMove = LS_NONE
            //Hold the anim a little longer than it is
            duelist.torsoTimer += 250
        }
    }

    if 1 != 0 {
        //no attacking during this anim
        duelist.weaponTime = duelist.torsoTimer
        duelist.saberBlocked = BLOCKED_NONE
        /*
        if ( superBreak
        && won
        && baseAnim != BOTH_LK_ST_DL_T_SB_1_W )
        {//going to attack with saber, do a saber trail
        duelist->client->ps.SaberActivateTrail( 200 );
        }
        */
    }
    return baseAnim
}

/// Source: oracle/codemp/game/bg_saber.c:1234
func PM_SaberLockBreak(_ genemy: JKAMP.PlayerState, _ victory: Bool, _ strength: Int32) {
    var winAnim: Int32 = BOTH_STAND1
    var loseAnim: Int32 = BOTH_STAND1
    //qboolean punishLoser = qfalse;
    var noKnockdown: Bool = false
    var singleVsSingle: Bool = true
    let superBreak: Bool = (strength + pm.ps.saberLockHits > Q_irand(2, 4))

    winAnim = PM_SaberLockWinAnim(victory, superBreak)
    if winAnim != -1 {
        //a single vs. single break
        loseAnim = PM_SaberLockLoseAnim(genemy, victory, superBreak)
    } else {
        //must be a saberlock that's not between single and single...
        singleVsSingle = false
        winAnim = PM_SaberLockResultAnim(pm.ps, superBreak, true)
        pm.ps.weaponstate = WEAPON_FIRING
        loseAnim = PM_SaberLockResultAnim(genemy, superBreak, false)
        genemy.weaponstate = WEAPON_READY
    }

    if victory {
        //someone lost the lock, so punish them by knocking them down
        if pm.ps.saberLockHits != 0 && !superBreak {
            //there was some over-power in the win, but not enough to superbreak
            var oppDir = vec3_t()

            let strength: Int32 = 8

            oppDir = genemy.origin - pm.ps.origin
            VectorNormalize(&oppDir)

            if noKnockdown {
                if genemy.saberEntityNum == 0 {
                    //if he has already lost his saber then just knock him down
                    noKnockdown = false
                }
            }

            if !noKnockdown && BG_KnockDownable(genemy) {
                genemy.forceHandExtend = HANDEXTEND_KNOCKDOWN
                genemy.forceHandExtendTime = pm.cmd.serverTime + 1100
                genemy.forceDodgeAnim = 0 //this toggles between 1 and 0, when it's 1 we should play the get up anim

                genemy.otherKiller = pm.ps.clientNum
                genemy.otherKillerTime = pm.cmd.serverTime + 5000
                genemy.otherKillerDebounceTime = pm.cmd.serverTime + 100
                //genemy->otherKillerMOD = MOD_UNKNOWN;
                //genemy->otherKillerVehWeapon = 0;
                //genemy->otherKillerWeaponType = WP_NONE;

                genemy.velocity[0] = oppDir[0] * (strength * 40)
                genemy.velocity[1] = oppDir[1] * (strength * 40)
                genemy.velocity[2] = 100
            }

            pm.checkDuelLoss = genemy.clientNum + 1

            pm.ps.saberEventFlags |= SEF_LOCK_WON
        }
    } else {
        //If no one lost, then shove each player away from the other
        var oppDir = vec3_t()

        let strength: Int32 = 4

        oppDir = genemy.origin - pm.ps.origin
        VectorNormalize(&oppDir)
        genemy.velocity[0] = oppDir[0] * (strength * 40)
        genemy.velocity[1] = oppDir[1] * (strength * 40)
        genemy.velocity[2] = 150

        oppDir = pm.ps.origin - genemy.origin
        VectorNormalize(&oppDir)
        pm.ps.velocity[0] = oppDir[0] * (strength * 40)
        pm.ps.velocity[1] = oppDir[1] * (strength * 40)
        pm.ps.velocity[2] = 150

        genemy.forceHandExtend = HANDEXTEND_WEAPONREADY
    }

    pm.ps.weaponTime = 0
    genemy.weaponTime = 0

    genemy.saberLockTime = 0
    pm.ps.saberLockTime = genemy.saberLockTime
    genemy.saberLockFrame = 0
    pm.ps.saberLockFrame = genemy.saberLockFrame
    genemy.saberLockEnemy = 0
    pm.ps.saberLockEnemy = genemy.saberLockEnemy

    pm.ps.forceHandExtend = HANDEXTEND_WEAPONREADY

    PM_AddEvent(EV_JUMP)
    if !victory {
        //no-one won
        BG_AddPredictableEventToPlayerstate(EV_JUMP, 0, genemy)
    } else {
        if PM_irand_timesync(0, 1) != 0 {
            BG_AddPredictableEventToPlayerstate(EV_JUMP, PM_irand_timesync(0, 75), genemy)
        }
    }
}

/// Source: oracle/codemp/game/bg_saber.c:1342
public func BG_CheckIncrementLockAnim(_ anim: Int32, _ winOrLose: Int32) -> Bool {
    var increment: Bool = false
    //RULE: if you are the first style in the lock anim, you advance from LOSING position to WINNING position
    //		if you are the second style in the lock anim, you advance from WINNING position to LOSING position
    switch anim {
    //increment to win:
    case BOTH_LK_DL_DL_S_L_1, BOTH_LK_DL_DL_S_L_2, BOTH_LK_DL_DL_T_L_1, BOTH_LK_DL_DL_T_L_2, BOTH_LK_DL_S_S_L_1, BOTH_LK_DL_S_T_L_1, BOTH_LK_DL_ST_S_L_1, BOTH_LK_DL_ST_T_L_1, BOTH_LK_S_S_S_L_1, BOTH_LK_S_S_T_L_2, BOTH_LK_ST_S_S_L_1, BOTH_LK_ST_S_T_L_1, BOTH_LK_ST_ST_T_L_1, BOTH_LK_ST_ST_T_L_2:
        if winOrLose == SABERLOCK_WIN {
            increment = true
        } else {
            increment = false
        }
        //decrement to win:

    case BOTH_LK_S_DL_S_L_1, BOTH_LK_S_DL_T_L_1, BOTH_LK_S_S_S_L_2, BOTH_LK_S_S_T_L_1, BOTH_LK_S_ST_S_L_1, BOTH_LK_S_ST_T_L_1, BOTH_LK_ST_DL_S_L_1, BOTH_LK_ST_DL_T_L_1, BOTH_LK_ST_ST_S_L_1, BOTH_LK_ST_ST_S_L_2:
        if winOrLose == SABERLOCK_WIN {
            increment = false
        } else {
            increment = true
        }

    default:
        break
    }
    return increment
}

/// Source: oracle/codemp/game/bg_saber.c:1401
func PM_SaberLocked() {
    var remaining: Int32 = 0
    var genemy: PlayerState?
    let eGenemy: BgEntity? = PM_BGEntForNum(pm.ps.saberLockEnemy)

    if eGenemy == nil {
        return
    }

    genemy = eGenemy!.playerState

    if genemy == nil {
        return
    }
    let enemy = genemy!
    /*if ( ( (pm->ps->torsoAnim) == BOTH_BF2LOCK ||
    (pm->ps->torsoAnim) == BOTH_BF1LOCK ||
    (pm->ps->torsoAnim) == BOTH_CWCIRCLELOCK ||
    (pm->ps->torsoAnim) == BOTH_CCWCIRCLELOCK )
    && ( (genemy->torsoAnim) == BOTH_BF2LOCK ||
    (genemy->torsoAnim) == BOTH_BF1LOCK ||
    (genemy->torsoAnim) == BOTH_CWCIRCLELOCK ||
    (genemy->torsoAnim) == BOTH_CCWCIRCLELOCK )
    )
    */ //yeah..
    if pm.ps.saberLockFrame != 0 && enemy.saberLockFrame != 0 && BG_InSaberLock(pm.ps.torsoAnim) && BG_InSaberLock(enemy.torsoAnim) {
        var dist: Float = 0

        pm.ps.torsoTimer = 0
        pm.ps.weaponTime = 0
        enemy.torsoTimer = 0
        enemy.weaponTime = 0

        dist = DistanceSquared(pm.ps.origin, enemy.origin)
        if dist < 64 || dist > 6400 {
            //between 8 and 80 from each other
            PM_SaberLockBreak(enemy, false, 0)
            return
        }
        /*
        //NOTE: time-out is handled around where PM_SaberLocked is called
        if ( pm->ps->saberLockTime <= pm->cmd.serverTime + 500 )
        {//lock just ended
        PM_SaberLockBreak( genemy, qfalse, 0 );
        return;
        }
        */
        if pm.ps.saberLockAdvance {
            //holding attack
            var anim: Animation?
            let currentFrame: Float
            var curFrame: Int32
            var strength: Int32 = 1

            pm.ps.saberLockAdvance = false

            anim = pm.animationsSlots[pm.ps.torsoAnim]

            currentFrame = Float(pm.ps.saberLockFrame)

            strength = pm.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] + 1

            //advance/decrement my frame number
            if BG_InSaberLockOld(pm.ps.torsoAnim) {
                //old locks
                if (pm.ps.torsoAnim) == BOTH_CCWCIRCLELOCK || (pm.ps.torsoAnim) == BOTH_BF2LOCK {
                    curFrame = Int32(floor(currentFrame) - strength)
                    //drop my frame one
                    if curFrame <= anim!.firstFrame {
                        //I won!  Break out
                        PM_SaberLockBreak(enemy, true, strength)
                        return
                    } else {
                        PM_SetAnimFrame(pm.ps, curFrame, true, true)
                        remaining = curFrame - anim!.firstFrame
                    }
                } else {
                    curFrame = Int32(ceil(currentFrame) + strength)
                    //advance my frame one
                    if curFrame >= anim!.firstFrame + anim!.numFrames {
                        //I won!  Break out
                        PM_SaberLockBreak(enemy, true, strength)
                        return
                    } else {
                        PM_SetAnimFrame(pm.ps, curFrame, true, true)
                        remaining = anim!.firstFrame + anim!.numFrames - curFrame
                    }
                }
            } else {
                //new locks
                if BG_CheckIncrementLockAnim(pm.ps.torsoAnim, SABERLOCK_WIN) {
                    curFrame = Int32(ceil(currentFrame) + strength)
                    //advance my frame one
                    if curFrame >= anim!.firstFrame + anim!.numFrames {
                        //I won!  Break out
                        PM_SaberLockBreak(enemy, true, strength)
                        return
                    } else {
                        PM_SetAnimFrame(pm.ps, curFrame, true, true)
                        remaining = anim!.firstFrame + anim!.numFrames - curFrame
                    }
                } else {
                    curFrame = Int32(floor(currentFrame) - strength)
                    //drop my frame one
                    if curFrame <= anim!.firstFrame {
                        //I won!  Break out
                        PM_SaberLockBreak(enemy, true, strength)
                        return
                    } else {
                        PM_SetAnimFrame(pm.ps, curFrame, true, true)
                        remaining = curFrame - anim!.firstFrame
                    }
                }
            }
            if PM_irand_timesync(0, 2) == 0 {
                PM_AddEvent(EV_JUMP)
            }
            //advance/decrement enemy frame number
            anim = pm.animationsSlots[(enemy.torsoAnim)]

            if BG_InSaberLockOld(enemy.torsoAnim) {
                if (enemy.torsoAnim) == BOTH_CWCIRCLELOCK || (enemy.torsoAnim) == BOTH_BF1LOCK {
                    if PM_irand_timesync(0, 2) == 0 {
                        BG_AddPredictableEventToPlayerstate(EV_PAIN, Int32(floor(Float(80) / 100 * 100.0)), enemy)
                    }
                    PM_SetAnimFrame(enemy, anim!.firstFrame + remaining, true, true)
                } else {
                    PM_SetAnimFrame(enemy, anim!.firstFrame + anim!.numFrames - remaining, true, true)
                }
            } else {
                //new locks
                if BG_CheckIncrementLockAnim(enemy.torsoAnim, SABERLOCK_LOSE) {
                    if PM_irand_timesync(0, 2) == 0 {
                        BG_AddPredictableEventToPlayerstate(EV_PAIN, Int32(floor(Float(80) / 100 * 100.0)), enemy)
                    }
                    PM_SetAnimFrame(enemy, anim!.firstFrame + anim!.numFrames - remaining, true, true)
                } else {
                    PM_SetAnimFrame(enemy, anim!.firstFrame + remaining, true, true)
                }
            }
        }
    } else {
        //something broke us out of it
        PM_SaberLockBreak(enemy, false, 0)
    }
}

/// Source: oracle/codemp/game/bg_saber.c:1583
public func PM_SaberInBrokenParry(_ move: Int32) -> Bool {
    if move >= LS_V1_BR && move <= LS_V1_B_ {
        return true
    }
    if move >= LS_H1_T_ && move <= LS_H1_BL {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_saber.c:1597
func PM_BrokenParryForParry(_ move: Int32) -> Int32 {
    switch move {
    case LS_PARRY_UP:
        return LS_H1_T_

    case LS_PARRY_UR:
        return LS_H1_TR

    case LS_PARRY_UL:
        return LS_H1_TL

    case LS_PARRY_LR:
        return LS_H1_BL

    case LS_PARRY_LL:
        return LS_H1_BR

    case LS_READY:
        return LS_H1_B_

    default:
        break
    }
    return LS_NONE
}

/// Source: oracle/codemp/game/bg_saber.c:1625
func PM_CanBackstab() -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var flatAng = vec3_t()
        var fwd = vec3_t()
        var back = vec3_t()
        var trmins = vec3_t(-15, -15, -8)
        var trmaxs = vec3_t(15, 15, 8)

        flatAng = pm.ps.viewangles
        flatAng[PITCH] = 0

        // Raven passes NULL for the second and third outputs of `AngleVectors`.
        // The ported function takes them by reference, so the body passes scratch vectors it never reads.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(flatAng, &fwd, &scratchRight, &scratchUp)

        back[0] = pm.ps.origin[0] - fwd[0] * BACK_STAB_DISTANCE
        back[1] = pm.ps.origin[1] - fwd[1] * BACK_STAB_DISTANCE
        back[2] = pm.ps.origin[2] - fwd[2] * BACK_STAB_DISTANCE

        pm.runTrace(tr, pm.ps.origin, trmins, trmaxs, back, pm.ps.clientNum, MASK_PLAYERSOLID)

        if tr.fraction != 1.0 && tr.entityNum >= 0 && tr.entityNum < ENTITYNUM_NONE {
            let bgEnt: BgEntity? = PM_BGEntForNum(tr.entityNum)

            if bgEnt != nil && (bgEnt!.s.eType == ET_PLAYER || bgEnt!.s.eType == ET_NPC) {
                return true
            }
        }

        return false
    }
}

/// Source: oracle/codemp/game/bg_saber.c:1657
func PM_SaberFlipOverAttackMove() -> JKAMP.saberMoveName_t {
    var fwdAngles = vec3_t()
    var jumpFwd = vec3_t()
    //	float zDiff = 0;
    //	playerState_t *psData;
    //	bgEntity_t *bgEnt;

    let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
    let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
    //see if we have an overridden (or cancelled) lunge move
    if saber1 != nil && saber1!.jumpAtkFwdMove != LS_INVALID {
        if saber1!.jumpAtkFwdMove != LS_NONE {
            return saberMoveName_t(saber1!.jumpAtkFwdMove)
        }
    }
    if saber2 != nil && saber2!.jumpAtkFwdMove != LS_INVALID {
        if saber2!.jumpAtkFwdMove != LS_NONE {
            return saberMoveName_t(saber2!.jumpAtkFwdMove)
        }
    }
    //no overrides, cancelled?
    if saber1 != nil && saber1!.jumpAtkFwdMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    if saber2 != nil && saber2!.jumpAtkFwdMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    //just do it
    fwdAngles = pm.ps.viewangles
    fwdAngles[ROLL] = 0
    fwdAngles[PITCH] = fwdAngles[ROLL]
    // Raven passes NULL for the second and third outputs of `AngleVectors`.
    // The ported function takes them by reference, so the body passes scratch vectors it never reads.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(fwdAngles, &jumpFwd, &scratchRight, &scratchUp)
    pm.ps.velocity = jumpFwd * 150 //was 50
    pm.ps.velocity[2] = 400

    /*
    bgEnt = PM_BGEntForNum(tr->entityNum);

    if (!bgEnt)
    {
    return LS_A_FLIP_STAB;
    }

    psData = bgEnt->playerState;

    //go higher for enemies higher than you, lower for those lower than you
    if (psData)
    {
    zDiff = psData->origin[2] - pm->ps->origin[2];
    }
    else
    {
    zDiff = 0;
    }
    pm->ps->velocity[2] += (zDiff)*1.5f;

    //clamp to decent-looking values
    if ( zDiff <= 0 && pm->ps->velocity[2] < 200 )
    {//if we're on same level, don't let me jump so low, I clip into the ground
    pm->ps->velocity[2] = 200;
    }
    else if ( pm->ps->velocity[2] < 100 )
    {
    pm->ps->velocity[2] = 100;
    }
    else if ( pm->ps->velocity[2] > 400 )
    {
    pm->ps->velocity[2] = 400;
    }
    */

    PM_SetForceJumpZStart(pm.ps.origin[2]) //so we don't take damage if we land at same height

    PM_AddEvent(EV_JUMP)
    pm.ps.fd.forceJumpSound = 1
    pm.cmd.upmove = 0

    /*
    if ( PM_irand_timesync( 0, 1 ) )
    {
    return LS_A_FLIP_STAB;
    }
    else
    */
    do {
        return LS_A_FLIP_SLASH
    }
}

/// Source: oracle/codemp/game/bg_saber.c:1755
func PM_SaberBackflipAttackMove() -> Int32 {
    let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
    let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
    //see if we have an overridden (or cancelled) lunge move
    if saber1 != nil && saber1!.jumpAtkBackMove != LS_INVALID {
        if saber1!.jumpAtkBackMove != LS_NONE {
            return saberMoveName_t(saber1!.jumpAtkBackMove)
        }
    }
    if saber2 != nil && saber2!.jumpAtkBackMove != LS_INVALID {
        if saber2!.jumpAtkBackMove != LS_NONE {
            return saberMoveName_t(saber2!.jumpAtkBackMove)
        }
    }
    //no overrides, cancelled?
    if saber1 != nil && saber1!.jumpAtkBackMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    if saber2 != nil && saber2!.jumpAtkBackMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    //just do it
    pm.cmd.upmove = 127
    pm.ps.velocity[2] = 500
    return LS_A_BACKFLIP_ATK
}

/// Source: oracle/codemp/game/bg_saber.c:1793
func PM_SaberDualJumpAttackMove() -> Int32 {
    //FIXME: to make this move easier to execute, should be allowed to do it
    //		after you've already started your jump... but jump is delayed in
    //		this anim, so how do we undo the jump?
    pm.cmd.upmove = 0 //no jump just yet
    return LS_JUMPATTACK_DUAL
}

/// Source: oracle/codemp/game/bg_saber.c:1804
func PM_SomeoneInFront(_ tr: JKAMP.Trace) -> Bool {
    //Also a very simplified version of the sp counterpart
    var flatAng = vec3_t()
    var fwd = vec3_t()
    var back = vec3_t()
    var trmins = vec3_t(-15, -15, -8)
    var trmaxs = vec3_t(15, 15, 8)

    flatAng = pm.ps.viewangles
    flatAng[PITCH] = 0

    // Raven passes NULL for the second and third outputs of `AngleVectors`.
    // The ported function takes them by reference, so the body passes scratch vectors it never reads.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(flatAng, &fwd, &scratchRight, &scratchUp)

    back[0] = pm.ps.origin[0] + fwd[0] * FLIPHACK_DISTANCE
    back[1] = pm.ps.origin[1] + fwd[1] * FLIPHACK_DISTANCE
    back[2] = pm.ps.origin[2] + fwd[2] * FLIPHACK_DISTANCE

    pm.runTrace(tr, pm.ps.origin, trmins, trmaxs, back, pm.ps.clientNum, MASK_PLAYERSOLID)

    if tr.fraction != 1.0 && tr.entityNum >= 0 && tr.entityNum < ENTITYNUM_NONE {
        let bgEnt: BgEntity? = PM_BGEntForNum(tr.entityNum)

        if bgEnt != nil && (bgEnt!.s.eType == ET_PLAYER || bgEnt!.s.eType == ET_NPC) {
            return true
        }
    }

    return false
}

/// Source: oracle/codemp/game/bg_saber.c:1835
func PM_SaberLungeAttackMove(_ noSpecials: Bool) -> JKAMP.saberMoveName_t {
    var fwdAngles = vec3_t()
    var jumpFwd = vec3_t()
    let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
    let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
    //see if we have an overridden (or cancelled) lunge move
    if saber1 != nil && saber1!.lungeAtkMove != LS_INVALID {
        if saber1!.lungeAtkMove != LS_NONE {
            return saberMoveName_t(saber1!.lungeAtkMove)
        }
    }
    if saber2 != nil && saber2!.lungeAtkMove != LS_INVALID {
        if saber2!.lungeAtkMove != LS_NONE {
            return saberMoveName_t(saber2!.lungeAtkMove)
        }
    }
    //no overrides, cancelled?
    if saber1 != nil && saber1!.lungeAtkMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    if saber2 != nil && saber2!.lungeAtkMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    //just do it
    if pm.ps.fd.saberAnimLevel == SS_FAST {
        fwdAngles = pm.ps.viewangles
        fwdAngles[ROLL] = 0
        fwdAngles[PITCH] = fwdAngles[ROLL]
        //do the lunge
        // Raven passes NULL for the second and third outputs of `AngleVectors`.
        // The ported function takes them by reference, so the body passes scratch vectors it never reads.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(fwdAngles, &jumpFwd, &scratchRight, &scratchUp)
        pm.ps.velocity = jumpFwd * 150
        PM_AddEvent(EV_JUMP)

        return LS_A_LUNGE
    } else if !noSpecials && pm.ps.fd.saberAnimLevel == SS_STAFF {
        return LS_SPINATTACK
    } else if !noSpecials {
        return LS_SPINATTACK_DUAL
    }
    return LS_A_T2B
}

/// Source: oracle/codemp/game/bg_saber.c:1891
func PM_SaberJumpAttackMove2() -> JKAMP.saberMoveName_t {
    let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
    let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
    //see if we have an overridden (or cancelled) lunge move
    if saber1 != nil && saber1!.jumpAtkFwdMove != LS_INVALID {
        if saber1!.jumpAtkFwdMove != LS_NONE {
            return saberMoveName_t(saber1!.jumpAtkFwdMove)
        }
    }
    if saber2 != nil && saber2!.jumpAtkFwdMove != LS_INVALID {
        if saber2!.jumpAtkFwdMove != LS_NONE {
            return saberMoveName_t(saber2!.jumpAtkFwdMove)
        }
    }
    //no overrides, cancelled?
    if saber1 != nil && saber1!.jumpAtkFwdMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    if saber2 != nil && saber2!.jumpAtkFwdMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    //just do it
    if pm.ps.fd.saberAnimLevel == SS_DUAL {
        return PM_SaberDualJumpAttackMove()
    } else {
        //rwwFIXMEFIXME I don't like randomness for this sort of thing, gives people reason to
        //complain combat is unpredictable. Maybe do something more clever to determine
        //if we should do a left or right?
        /*
        if (PM_irand_timesync(0, 1))
        {
        newmove = LS_JUMPATTACK_STAFF_LEFT;
        }
        else
        */
        do {
            return LS_JUMPATTACK_STAFF_RIGHT
        }
    }
    return LS_A_T2B
}

/// Source: oracle/codemp/game/bg_saber.c:1947
func PM_SaberJumpAttackMove() -> JKAMP.saberMoveName_t {
    var fwdAngles = vec3_t()
    var jumpFwd = vec3_t()
    let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
    let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
    //see if we have an overridden (or cancelled) lunge move
    if saber1 != nil && saber1!.jumpAtkFwdMove != LS_INVALID {
        if saber1!.jumpAtkFwdMove != LS_NONE {
            return saberMoveName_t(saber1!.jumpAtkFwdMove)
        }
    }
    if saber2 != nil && saber2!.jumpAtkFwdMove != LS_INVALID {
        if saber2!.jumpAtkFwdMove != LS_NONE {
            return saberMoveName_t(saber2!.jumpAtkFwdMove)
        }
    }
    //no overrides, cancelled?
    if saber1 != nil && saber1!.jumpAtkFwdMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    if saber2 != nil && saber2!.jumpAtkFwdMove == LS_NONE {
        return LS_A_T2B //LS_NONE;
    }
    //just do it
    fwdAngles = pm.ps.viewangles
    fwdAngles[ROLL] = 0
    fwdAngles[PITCH] = fwdAngles[ROLL]
    // Raven passes NULL for the second and third outputs of `AngleVectors`.
    // The ported function takes them by reference, so the body passes scratch vectors it never reads.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(fwdAngles, &jumpFwd, &scratchRight, &scratchUp)
    pm.ps.velocity = jumpFwd * 300
    pm.ps.velocity[2] = 280
    PM_SetForceJumpZStart(pm.ps.origin[2]) //so we don't take damage if we land at same height

    PM_AddEvent(EV_JUMP)
    pm.ps.fd.forceJumpSound = 1
    pm.cmd.upmove = 0

    return LS_A_JUMP_T__B_
}

/// Source: oracle/codemp/game/bg_saber.c:1995
func PM_GroundDistance() -> Float {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Float in
        var down = vec3_t()

        down = pm.ps.origin

        down[2] -= 4096

        pm.runTrace(tr, pm.ps.origin, pm.mins, pm.maxs, down, pm.ps.clientNum, MASK_SOLID)

        down = pm.ps.origin - tr.endpos

        return VectorLength(down)
    }
}

/// Source: oracle/codemp/game/bg_saber.c:2011
func PM_WalkableGroundDistance() -> Float {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Float in
        var down = vec3_t()

        down = pm.ps.origin

        down[2] -= 4096

        pm.runTrace(tr, pm.ps.origin, pm.mins, pm.maxs, down, pm.ps.clientNum, MASK_SOLID)

        if tr.plane.normal[2] < MIN_WALK_NORMAL {
            //can't stand on this plane
            return 4096
        }

        down = pm.ps.origin - tr.endpos

        return VectorLength(down)
    }
}

/// Source: oracle/codemp/game/bg_saber.c:2033
private func PM_CanDoDualDoubleAttacks() -> Bool {
    if pm.ps.weapon == WP_SABER {
        var saber: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        if saber != nil && (saber!.saberFlags & SFL_NO_MIRROR_ATTACKS) != 0 {
            return false
        }
        saber = BG_MySaber(pm.ps.clientNum, 1)
        if saber != nil && (saber!.saberFlags & SFL_NO_MIRROR_ATTACKS) != 0 {
            return false
        }
    }
    if BG_SaberInSpecialAttack(pm.ps.torsoAnim) || BG_SaberInSpecialAttack(pm.ps.legsAnim) {
        return false
    }
    return true
}

/// Source: oracle/codemp/game/bg_saber.c:2058
private func PM_CheckEnemyPresence(_ dir: Int32, _ radius: Float) -> Bool {
    //anyone in this dir?
    var angles = vec3_t()
    var checkDir = vec3_t()
    var tTo = vec3_t()
    var tMins = vec3_t()
    var tMaxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        let tSize: Float = 12.0
        //sp uses a bbox ent list check, but.. that's not so easy/fast to
        //do in predicted code. So I'll just do a single box trace in the proper direction,
        //and take whatever is first hit.

        tMins = vec3_t(-tSize, -tSize, -tSize)
        tMaxs = vec3_t(tSize, tSize, tSize)

        angles = pm.ps.viewangles
        angles[PITCH] = 0.0

        switch dir {
        case DIR_RIGHT:
            // Raven passes NULL for the first and third outputs of `AngleVectors`.
            // The ported function takes them by reference, so the body passes scratch vectors it never reads.
            var scratchForward = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(angles, &scratchForward, &checkDir, &scratchUp)

        case DIR_LEFT:
            // Raven passes NULL for the first and third outputs of `AngleVectors`.
            // The ported function takes them by reference, so the body passes scratch vectors it never reads.
            var scratchForward2 = vec3_t()
            var scratchUp2 = vec3_t()
            AngleVectors(angles, &scratchForward2, &checkDir, &scratchUp2)
            checkDir = checkDir * -1

        case DIR_FRONT:
            // Raven passes NULL for the second and third outputs of `AngleVectors`.
            // The ported function takes them by reference, so the body passes scratch vectors it never reads.
            var scratchRight = vec3_t()
            var scratchUp3 = vec3_t()
            AngleVectors(angles, &checkDir, &scratchRight, &scratchUp3)

        case DIR_BACK:
            // Raven passes NULL for the second and third outputs of `AngleVectors`.
            // The ported function takes them by reference, so the body passes scratch vectors it never reads.
            var scratchRight2 = vec3_t()
            var scratchUp4 = vec3_t()
            AngleVectors(angles, &checkDir, &scratchRight2, &scratchUp4)
            checkDir = checkDir * -1

        default:
            break
        }

        _VectorMA(pm.ps.origin, radius, checkDir, &tTo)
        pm.runTrace(tr, pm.ps.origin, tMins, tMaxs, tTo, pm.ps.clientNum, MASK_PLAYERSOLID)

        if tr.fraction != 1.0 && tr.entityNum < ENTITYNUM_WORLD {
            //let's see who we hit
            let bgEnt: BgEntity? = PM_BGEntForNum(tr.entityNum)

            if bgEnt != nil && (bgEnt!.s.eType == ET_PLAYER || bgEnt!.s.eType == ET_NPC) {
                //this guy can be considered an "enemy"... if he is on the same team, oh well. can't bg-check that (without a whole lot of hassle).
                return true
            }
        }

        //no one in the trace
        return false
    }
}

/// Source: oracle/codemp/game/bg_saber.c:2117
func PM_CheckPullAttack() -> JKAMP.saberMoveName_t {
    //&& (pm->ps->clientNum < MAX_CLIENTS||PM_ControlledByPlayer())//PLAYER ONLY
    //&& G_TryingPullAttack( pm->gent, &pm->cmd, qfalse )
    //&& pm->ps->fd.forcePowerLevel[FP_PULL]
    //rwwFIXMEFIXME: rick has the damn msg.cpp file checked out exclusively so I can't update the bloody psf to send this for prediction
    //&& pm->cmd.forwardmove<0//pulling back
    //		if ( g_saberNewControlScheme->integer
    //			|| g_crosshairEntNum < ENTITYNUM_WORLD )//in old control scheme, there has to be someone there

    /*
    if ( g_crosshairEntNum < ENTITYNUM_WORLD
    && pm->gent && pm->gent->client )
    {
    gentity_t *targEnt = &g_entities[g_crosshairEntNum];
    if ( targEnt->client
    && targEnt->health > 0
    //FIXME: check other things like in knockdown, saberlock, uninterruptable anims, etc.
    && !PM_InOnGroundAnim( &targEnt->client->ps )
    && !PM_LockedAnim( targEnt->client->ps.legsAnim )
    && !PM_SuperBreakLoseAnim( targEnt->client->ps.legsAnim )
    && !PM_SuperBreakWinAnim( targEnt->client->ps.legsAnim )
    && targEnt->client->ps.saberLockTime <= 0
    && WP_ForceThrowable( targEnt, targEnt, pm->gent, qtrue, 1.0f, 0.0f, NULL ) )
    {
    if ( !g_saberNewControlScheme->integer )
    {//in old control scheme, make sure they're close or far enough away for the move we'll be doing
    float targDist = Distance( targEnt->currentOrigin, pm->ps->origin );
    if ( pullAttackMove == LS_PULL_ATTACK_STAB )
    {//must be closer than 512
    if ( targDist > 384.0f )
    {
    return LS_NONE;
    }
    }
    else//if ( pullAttackMove == LS_PULL_ATTACK_SWING )
    {//must be farther than 256
    if ( targDist > 512.0f )
    {
    return LS_NONE;
    }
    if ( targDist < 192.0f )
    {
    return LS_NONE;
    }
    }
    }

    vec3_t targAngles = {0,targEnt->client->ps.viewangles[YAW],0};
    if ( InFront( pm->ps->origin, targEnt->currentOrigin, targAngles ) )
    {
    NPC_SetAnim( targEnt, SETANIM_BOTH, BOTH_PULLED_INAIR_F, SETANIM_FLAG_OVERRIDE, SETANIM_FLAG_HOLD );
    }
    else
    {
    NPC_SetAnim( targEnt, SETANIM_BOTH, BOTH_PULLED_INAIR_B, SETANIM_FLAG_OVERRIDE, SETANIM_FLAG_HOLD );
    }
    //hold the anim until I'm with done pull anim
    targEnt->client->ps.legsAnimTimer = targEnt->client->ps.torsoAnimTimer = PM_AnimLength( pm->gent->client->clientInfo.animFileIndex, (animNumber_t)saberMoveData[pullAttackMove].animToUse );
    //set pullAttackTime
    pm->gent->client->ps.pullAttackTime = targEnt->client->ps.pullAttackTime = level.time+targEnt->client->ps.legsAnimTimer;
    //make us know about each other
    pm->gent->client->ps.pullAttackEntNum = g_crosshairEntNum;
    targEnt->client->ps.pullAttackEntNum = pm->ps->clientNum;
    //do effect and sound on me
    pm->ps->powerups[PW_FORCE_PUSH] = level.time + 1000;
    if ( pm->gent )
    {
    G_Sound( pm->gent, G_SoundIndex( "sound/weapons/force/pull.wav" ) );
    }
    doMove = qtrue;
    }
    }
    */
    return LS_NONE
}

/// Source: oracle/codemp/game/bg_saber.c:2228
func PM_InSecondaryStyle() -> Bool {
    if pm.ps.fd.saberAnimLevelBase == SS_STAFF || pm.ps.fd.saberAnimLevelBase == SS_DUAL {
        if pm.ps.fd.saberAnimLevel != pm.ps.fd.saberAnimLevelBase {
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/game/bg_saber.c:2241
func PM_SaberAttackForMovement(_ curmove: JKAMP.saberMoveName_t) -> JKAMP.saberMoveName_t {
    var newmove: saberMoveName_t = LS_NONE
    let noSpecials: Bool = PM_InSecondaryStyle()
    var allowCartwheels: Bool = true
    var overrideJumpRightAttackMove: saberMoveName_t = LS_INVALID
    var overrideJumpLeftAttackMove: saberMoveName_t = LS_INVALID

    if pm.ps.weapon == WP_SABER {
        let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)

        if saber1 != nil && saber1!.jumpAtkRightMove != LS_INVALID {
            if saber1!.jumpAtkRightMove != LS_NONE {
                //actually overriding
                overrideJumpRightAttackMove = saberMoveName_t(saber1!.jumpAtkRightMove)
            } else if saber2 != nil && saber2!.jumpAtkRightMove > LS_NONE {
                //would be cancelling it, but check the second saber, too
                overrideJumpRightAttackMove = saberMoveName_t(saber2!.jumpAtkRightMove)
            } else {
                //nope, just cancel it
                overrideJumpRightAttackMove = LS_NONE
            }
        } else if saber2 != nil && saber2!.jumpAtkRightMove != LS_INVALID {
            //first saber not overridden, check second
            overrideJumpRightAttackMove = saberMoveName_t(saber2!.jumpAtkRightMove)
        }

        if saber1 != nil && saber1!.jumpAtkLeftMove != LS_INVALID {
            if saber1!.jumpAtkLeftMove != LS_NONE {
                //actually overriding
                overrideJumpLeftAttackMove = saberMoveName_t(saber1!.jumpAtkLeftMove)
            } else if saber2 != nil && saber2!.jumpAtkLeftMove > LS_NONE {
                //would be cancelling it, but check the second saber, too
                overrideJumpLeftAttackMove = saberMoveName_t(saber2!.jumpAtkLeftMove)
            } else {
                //nope, just cancel it
                overrideJumpLeftAttackMove = LS_NONE
            }
        } else if saber2 != nil && saber2!.jumpAtkLeftMove != LS_INVALID {
            //first saber not overridden, check second
            overrideJumpLeftAttackMove = saberMoveName_t(saber1!.jumpAtkLeftMove)
        }

        if saber1 != nil && (saber1!.saberFlags & SFL_NO_CARTWHEELS) != 0 {
            allowCartwheels = false
        }
        if saber2 != nil && (saber2!.saberFlags & SFL_NO_CARTWHEELS) != 0 {
            allowCartwheels = false
        }
    }

    if pm.cmd.rightmove > 0 {
        //moving right
        if !noSpecials && overrideJumpRightAttackMove != LS_NONE && pm.ps.velocity[2] > 20.0 && (pm.cmd.buttons & BUTTON_ATTACK) != 0 && PM_GroundDistance() < 70.0 && (pm.cmd.upmove > 0 || (pm.ps.pm_flags & PMF_JUMP_HELD) != 0) && BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER_LR) {
            //cartwheel right
            BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER_LR)
            if overrideJumpRightAttackMove != LS_INVALID {
                //overridden with another move
                return overrideJumpRightAttackMove
            } else {
                var right = vec3_t()
                var fwdAngles = vec3_t()

                fwdAngles = vec3_t(0.0, pm.ps.viewangles[YAW], 0.0)

                // Raven passes NULL for the first and third outputs of `AngleVectors`.
                // The ported function takes them by reference, so the body passes scratch vectors it never reads.
                var scratchForward = vec3_t()
                var scratchUp = vec3_t()
                AngleVectors(fwdAngles, &scratchForward, &right, &scratchUp)
                pm.ps.velocity[1] = 0.0
                pm.ps.velocity[0] = pm.ps.velocity[1]
                _VectorMA(pm.ps.velocity, 190.0, right, &pm.ps.velocity)
                if pm.ps.fd.saberAnimLevel == SS_STAFF {
                    newmove = LS_BUTTERFLY_RIGHT
                    pm.ps.velocity[2] = 350.0
                } else if allowCartwheels {
                    //PM_SetJumped( JUMP_VELOCITY, qtrue );
                    PM_AddEvent(EV_JUMP)
                    pm.ps.velocity[2] = 300.0

                    //if ( !Q_irand( 0, 1 ) )
                    //if (PM_GroundDistance() >= 25.0f)
                    if 1 != 0 {
                        newmove = LS_JUMPATTACK_ARIAL_RIGHT
                    } else {
                        newmove = LS_JUMPATTACK_CART_RIGHT
                    }
                }
            }
        } else if pm.cmd.forwardmove > 0 {
            //forward right = TL2BR slash
            newmove = LS_A_TL2BR
        } else if pm.cmd.forwardmove < 0 {
            //backward right = BL2TR uppercut
            newmove = LS_A_BL2TR
        } else {
            //just right is a left slice
            newmove = LS_A_L2R
        }
    } else if pm.cmd.rightmove < 0 {
        //moving left
        if !noSpecials && overrideJumpLeftAttackMove != LS_NONE && pm.ps.velocity[2] > 20.0 && (pm.cmd.buttons & BUTTON_ATTACK) != 0 && PM_GroundDistance() < 70.0 && (pm.cmd.upmove > 0 || (pm.ps.pm_flags & PMF_JUMP_HELD) != 0) && BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER_LR) {
            //cartwheel left
            BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER_LR)

            if overrideJumpLeftAttackMove != LS_INVALID {
                //overridden with another move
                return overrideJumpLeftAttackMove
            } else {
                var right = vec3_t()
                var fwdAngles = vec3_t()

                fwdAngles = vec3_t(0.0, pm.ps.viewangles[YAW], 0.0)
                // Raven passes NULL for the first and third outputs of `AngleVectors`.
                // The ported function takes them by reference, so the body passes scratch vectors it never reads.
                var scratchForward2 = vec3_t()
                var scratchUp2 = vec3_t()
                AngleVectors(fwdAngles, &scratchForward2, &right, &scratchUp2)
                pm.ps.velocity[1] = 0.0
                pm.ps.velocity[0] = pm.ps.velocity[1]
                _VectorMA(pm.ps.velocity, -190.0, right, &pm.ps.velocity)
                if pm.ps.fd.saberAnimLevel == SS_STAFF {
                    newmove = LS_BUTTERFLY_LEFT
                    pm.ps.velocity[2] = 250.0
                } else if allowCartwheels {
                    //PM_SetJumped( JUMP_VELOCITY, qtrue );
                    PM_AddEvent(EV_JUMP)
                    pm.ps.velocity[2] = 350.0

                    //if ( !Q_irand( 0, 1 ) )
                    //if (PM_GroundDistance() >= 25.0f)
                    if 1 != 0 {
                        newmove = LS_JUMPATTACK_ARIAL_LEFT
                    } else {
                        newmove = LS_JUMPATTACK_CART_LEFT
                    }
                }
            }
        } else if pm.cmd.forwardmove > 0 {
            //forward left = TR2BL slash
            newmove = LS_A_TR2BL
        } else if pm.cmd.forwardmove < 0 {
            //backward left = BR2TL uppercut
            newmove = LS_A_BR2TL
        } else {
            //just left is a right slice
            newmove = LS_A_R2L
        }
    } else {
        //not moving left or right
        if pm.cmd.forwardmove > 0 {
            //forward= T2B slash
            if !noSpecials && (pm.ps.fd.saberAnimLevel == SS_DUAL || pm.ps.fd.saberAnimLevel == SS_STAFF) && pm.ps.fd.forceRageRecoveryTime < pm.cmd.serverTime && (pm.ps.groundEntityNum != ENTITYNUM_NONE || PM_GroundDistance() <= 40) && pm.ps.velocity[2] >= 0 && (pm.cmd.upmove > 0 || (pm.ps.pm_flags & PMF_JUMP_HELD) != 0) && !BG_SaberInTransitionAny(pm.ps.saberMove) && !BG_SaberInAttack(pm.ps.saberMove) && pm.ps.weaponTime <= 0 && pm.ps.forceHandExtend == HANDEXTEND_NONE && (pm.cmd.buttons & BUTTON_ATTACK) != 0 && BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER_FB) {
                //DUAL/STAFF JUMP ATTACK
                newmove = PM_SaberJumpAttackMove2()
                if newmove != LS_A_T2B && newmove != LS_NONE {
                    BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER_FB)
                }
            } else if !noSpecials && pm.ps.fd.saberAnimLevel == SS_MEDIUM && pm.ps.velocity[2] > 100 && PM_GroundDistance() < 32 && !BG_InSpecialJump(pm.ps.legsAnim) && !BG_SaberInSpecialAttack(pm.ps.torsoAnim) && BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER_FB) {
                //FLIP AND DOWNWARD ATTACK
                //trace_t tr;

                //if (PM_SomeoneInFront(&tr))
                do {
                    newmove = PM_SaberFlipOverAttackMove()
                    if newmove != LS_A_T2B && newmove != LS_NONE {
                        BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER_FB)
                    }
                }
            } else if !noSpecials && pm.ps.fd.saberAnimLevel == SS_STRONG && pm.ps.velocity[2] > 100 && PM_GroundDistance() < 32 && !BG_InSpecialJump(pm.ps.legsAnim) && !BG_SaberInSpecialAttack(pm.ps.torsoAnim) && BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER_FB) {
                //DFA
                //trace_t tr;

                //if (PM_SomeoneInFront(&tr))
                do {
                    newmove = PM_SaberJumpAttackMove()
                    if newmove != LS_A_T2B && newmove != LS_NONE {
                        BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER_FB)
                    }
                }
            } else if (pm.ps.fd.saberAnimLevel == SS_FAST || pm.ps.fd.saberAnimLevel == SS_DUAL || pm.ps.fd.saberAnimLevel == SS_STAFF) && pm.ps.groundEntityNum != ENTITYNUM_NONE && (pm.ps.pm_flags & PMF_DUCKED) != 0 && pm.ps.weaponTime <= 0 && !BG_SaberInSpecialAttack(pm.ps.torsoAnim) && BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER_FB) {
                //LUNGE (weak)
                newmove = PM_SaberLungeAttackMove(noSpecials)
                if newmove != LS_A_T2B && newmove != LS_NONE {
                    BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER_FB)
                }
            } else if !noSpecials {
                let stabDownMove: saberMoveName_t = PM_CheckStabDown()
                if stabDownMove != LS_NONE && BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER_FB) {
                    newmove = stabDownMove
                    BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER_FB)
                } else {
                    newmove = LS_A_T2B
                }
            }
        } else if pm.cmd.forwardmove < 0 {
            //backward= T2B slash//B2T uppercut?
            if !noSpecials && pm.ps.fd.saberAnimLevel == SS_STAFF && pm.ps.fd.forceRageRecoveryTime < pm.cmd.serverTime && pm.ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_1 && (pm.ps.groundEntityNum != ENTITYNUM_NONE || PM_GroundDistance() <= 40) && pm.ps.velocity[2] >= 0 && (pm.cmd.upmove > 0 || (pm.ps.pm_flags & PMF_JUMP_HELD) != 0) && !BG_SaberInTransitionAny(pm.ps.saberMove) && !BG_SaberInAttack(pm.ps.saberMove) && pm.ps.weaponTime <= 0 && pm.ps.forceHandExtend == HANDEXTEND_NONE && (pm.cmd.buttons & BUTTON_ATTACK) != 0 {
                //BACKFLIP ATTACK
                newmove = PM_SaberBackflipAttackMove()
            } else if PM_CanBackstab() && !BG_SaberInSpecialAttack(pm.ps.torsoAnim) {
                //BACKSTAB (attack varies by level)
                if pm.ps.fd.saberAnimLevel >= FORCE_LEVEL_2 && pm.ps.fd.saberAnimLevel != SS_STAFF {
                    //medium and higher attacks
                    if (pm.ps.pm_flags & PMF_DUCKED) != 0 || pm.cmd.upmove < 0 {
                        newmove = LS_A_BACK_CR
                    } else {
                        newmove = LS_A_BACK
                    }
                } else {
                    //weak attack
                    newmove = LS_A_BACKSTAB
                }
            } else {
                newmove = LS_A_T2B
            }
        } else if PM_SaberInBounce(curmove) {
            //bounces should go to their default attack if you don't specify a direction but are attacking
            newmove = saberMoveData[curmove].chain_attack

            if PM_SaberKataDone(curmove, newmove) {
                newmove = saberMoveData[curmove].chain_idle
            } else {
                newmove = saberMoveData[curmove].chain_attack
            }
        } else if curmove == LS_READY {
            //Not moving at all, shouldn't have gotten here...?
            //for now, just pick a random attack
            //newmove = Q_irand( LS_A_TL2BR, LS_A_T2B );
            //rww - If we don't seed with a "common" value, the client and server will get mismatched
            //prediction values. Under laggy conditions this will cause the appearance of rapid swing
            //sequence changes.

            newmove = LS_A_T2B //decided we don't like random attacks when idle, use an overhead instead.
        }
    }

    if pm.ps.fd.saberAnimLevel == SS_DUAL {
        if (newmove == LS_A_R2L || newmove == LS_S_R2L || newmove == LS_A_L2R || newmove == LS_S_L2R) && PM_CanDoDualDoubleAttacks() && PM_CheckEnemyPresence(DIR_RIGHT, 100.0) && PM_CheckEnemyPresence(DIR_LEFT, 100.0) {
            //enemy both on left and right
            newmove = LS_DUAL_LR
            //probably already moved, but...
            pm.cmd.rightmove = 0
        } else if (newmove == LS_A_T2B || newmove == LS_S_T2B || newmove == LS_A_BACK || newmove == LS_A_BACK_CR) && PM_CanDoDualDoubleAttacks() && PM_CheckEnemyPresence(DIR_FRONT, 100.0) && PM_CheckEnemyPresence(DIR_BACK, 100.0) {
            //enemy both in front and back
            newmove = LS_DUAL_FB
            //probably already moved, but...
            pm.cmd.forwardmove = 0
        }
    }

    return newmove
}

/// Source: oracle/codemp/game/bg_saber.c:2620
func PM_KickMoveForConditions() -> Int32 {
    var kickMove: Int32 = -1

    //FIXME: only if FP_SABER_OFFENSE >= 3
    if pm.cmd.rightmove != 0 {
        //kick to side
        if pm.cmd.rightmove > 0 {
            //kick right
            kickMove = LS_KICK_R
        } else {
            //kick left
            kickMove = LS_KICK_L
        }
        pm.cmd.rightmove = 0
    } else if pm.cmd.forwardmove != 0 {
        //kick front/back
        if pm.cmd.forwardmove > 0 {
            //kick fwd
            /*
            if (pm->ps->groundEntityNum != ENTITYNUM_NONE &&
            PM_CheckEnemyPresence( DIR_FRONT, 64.0f ))
            {
            kickMove = LS_HILT_BASH;
            }
            else
            */
            do {
                kickMove = LS_KICK_F
            }
        } else {
            //kick back
            kickMove = LS_KICK_B
        }
        pm.cmd.forwardmove = 0
    } else {
        //if (pm->cmd.buttons & BUTTON_ATTACK)
        //if (pm->ps->pm_flags & PMF_JUMP_HELD)
        if 0 != 0 {
            //ok, let's try some fancy kicks
            //qboolean is actually of type int anyway, but just for safeness.
            let front: Int32 = (PM_CheckEnemyPresence(DIR_FRONT, 100.0) ? 1 : 0)
            let back: Int32 = (PM_CheckEnemyPresence(DIR_BACK, 100.0) ? 1 : 0)
            let right: Int32 = (PM_CheckEnemyPresence(DIR_RIGHT, 100.0) ? 1 : 0)
            let left: Int32 = (PM_CheckEnemyPresence(DIR_LEFT, 100.0) ? 1 : 0)
            let numEnemy: Int32 = front + back + right + left

            if numEnemy >= 3 || ((right == 0 || left == 0) && numEnemy >= 2) {
                //> 2 enemies near, or, >= 2 enemies near and they are not to the right and left.
                kickMove = LS_KICK_S
            } else if right != 0 && left != 0 {
                //enemies on both sides
                kickMove = LS_KICK_RL
            } else {
                //oh well, just do a forward kick
                kickMove = LS_KICK_F
            }

            pm.cmd.upmove = 0
        }
    }

    return kickMove
}

/// Source: oracle/codemp/game/bg_saber.c:2696
func PM_SaberMoveOkayForKata() -> Bool {
    if pm.ps.saberMove == LS_READY || PM_SaberInStart(pm.ps.saberMove) {
        return true
    } else {
        return false
    }
}

/// Source: oracle/codemp/game/bg_saber.c:2709
func PM_CanDoKata() -> Bool {
    if PM_InSecondaryStyle() {
        return false
    }

    if !pm.ps.saberInFlight && PM_SaberMoveOkayForKata() && !BG_SaberInKata(pm.ps.saberMove) && !BG_InKataAnim(pm.ps.legsAnim) && !BG_InKataAnim(pm.ps.torsoAnim) && pm.ps.groundEntityNum != ENTITYNUM_NONE && (pm.cmd.buttons & BUTTON_ATTACK) != 0 && (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 && pm.cmd.forwardmove == 0 && pm.cmd.rightmove == 0 && pm.cmd.upmove <= 0 && BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER) {
        //FIXME: check rage, etc...
        var saber: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        if saber != nil && saber!.kataMove == LS_NONE {
            //kata move has been overridden in a way that should stop you from doing it at all
            return false
        }
        saber = BG_MySaber(pm.ps.clientNum, 1)
        if saber != nil && saber!.kataMove == LS_NONE {
            //kata move has been overridden in a way that should stop you from doing it at all
            return false
        }
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_saber.c:2750
func PM_CheckAltKickAttack() -> Bool {
    if pm.ps.weapon == WP_SABER {
        var saber: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        if saber != nil && (saber!.saberFlags & SFL_NO_KICKS) != 0 {
            return false
        }
        saber = BG_MySaber(pm.ps.clientNum, 1)
        if saber != nil && (saber!.saberFlags & SFL_NO_KICKS) != 0 {
            return false
        }
    }
    if (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 && (!BG_FlippingAnim(pm.ps.legsAnim) || pm.ps.legsTimer <= 250) && (pm.ps.fd.saberAnimLevel == SS_STAFF) && pm.ps.saberHolstered == 0 {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_saber.c:2785
func PM_SaberPowerCheck() -> Bool {
    if pm.ps.saberInFlight {
        //so we don't keep doing stupid force out thing while guiding saber.
        if pm.ps.fd.forcePower > forcePowerNeeded[pm.ps.fd.forcePowerLevel[FP_SABERTHROW]][FP_SABERTHROW] {
            return true
        }
    } else {
        return BG_EnoughForcePowerForMove(forcePowerNeeded[pm.ps.fd.forcePowerLevel[FP_SABERTHROW]][FP_SABERTHROW])
    }

    return false
}

/// Source: oracle/codemp/game/bg_saber.c:2802
func PM_CanDoRollStab() -> Bool {
    if pm.ps.weapon == WP_SABER {
        var saber: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        if saber != nil && (saber!.saberFlags & SFL_NO_ROLL_STAB) != 0 {
            return false
        }
        saber = BG_MySaber(pm.ps.clientNum, 1)
        if saber != nil && (saber!.saberFlags & SFL_NO_ROLL_STAB) != 0 {
            return false
        }
    }
    return true
}

/// Source: oracle/codemp/game/bg_saber.c:2836
func PM_WeaponLightsaber() {
    var addTime: Int32 = 0
    var amount: Int32 = 0
    let delayed_fire: Bool = false
    var anim: Int32 = -1
    var curmove: Int32 = 0
    var newmove: Int32 = LS_NONE

    var checkOnlyWeap: Bool = false

    weapChecks: do {
        if PM_InKnockDown(pm.ps) || BG_InRoll(pm.ps, pm.ps.legsAnim) {
            //in knockdown
            // make weapon function
            if pm.ps.weaponTime > 0 {
                pm.ps.weaponTime -= pml.msec
                if pm.ps.weaponTime <= 0 {
                    pm.ps.weaponTime = 0
                }
            }
            if pm.ps.legsAnim == BOTH_ROLL_F && pm.ps.legsTimer <= 250 {
                if (pm.cmd.buttons & BUTTON_ATTACK) != 0 {
                    if BG_EnoughForcePowerForMove(SABER_ALT_ATTACK_POWER_FB) && !pm.ps.saberInFlight {
                        if PM_CanDoRollStab() {
                            //make sure the saber is on for this move!
                            if pm.ps.saberHolstered == 2 {
                                //all the way off
                                pm.ps.saberHolstered = 0
                                PM_AddEvent(EV_SABER_UNHOLSTER)
                            }
                            PM_SetSaberMove(LS_ROLL_STAB)
                            BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER_FB)
                        }
                    }
                }
            }
            return
        }

        if pm.ps.saberLockTime > pm.cmd.serverTime {
            pm.ps.saberMove = LS_NONE
            PM_SaberLocked()
            return
        } else {
            if pm.ps.saberLockFrame != 0 {
                if pm.ps.saberLockEnemy < ENTITYNUM_NONE && pm.ps.saberLockEnemy >= 0 {
                    var bgEnt: BgEntity?
                    var en: PlayerState?

                    bgEnt = PM_BGEntForNum(pm.ps.saberLockEnemy)

                    if bgEnt != nil {
                        en = bgEnt!.playerState

                        if en != nil {
                            PM_SaberLockBreak(en!, false, 0)
                            return
                        }
                    }
                }

                if pm.ps.saberLockFrame != 0 {
                    pm.ps.torsoTimer = 0
                    PM_SetAnim(SETANIM_TORSO, BOTH_STAND1, SETANIM_FLAG_OVERRIDE, 100)
                    pm.ps.saberLockFrame = 0
                }
            }
        }

        if BG_KickingAnim(pm.ps.legsAnim) || BG_KickingAnim(pm.ps.torsoAnim) {
            if pm.ps.legsTimer > 0 {
                //you're kicking, no interruptions
                return
            }
            //done?  be immeditately ready to do an attack
            pm.ps.saberMove = LS_READY
            pm.ps.weaponTime = 0
        }

        if BG_SuperBreakLoseAnim(pm.ps.torsoAnim) || BG_SuperBreakWinAnim(pm.ps.torsoAnim) {
            if pm.ps.torsoTimer > 0 {
                //never interrupt these
                return
            }
        }

        if BG_SabersOff(pm.ps) {
            if pm.ps.saberMove != LS_READY {
                PM_SetSaberMove(LS_READY)
            }

            if (pm.ps.legsAnim) != (pm.ps.torsoAnim) && !BG_InSlopeAnim(pm.ps.legsAnim) && pm.ps.torsoTimer <= 0 {
                PM_SetAnim(SETANIM_TORSO, (pm.ps.legsAnim), SETANIM_FLAG_OVERRIDE, 100)
            } else if BG_InSlopeAnim(pm.ps.legsAnim) && pm.ps.torsoTimer <= 0 {
                PM_SetAnim(SETANIM_TORSO, PM_GetSaberStance(), SETANIM_FLAG_OVERRIDE, 100)
            }

            if pm.ps.weaponTime < 1 && ((pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 || (pm.cmd.buttons & BUTTON_ATTACK) != 0) {
                if pm.ps.duelTime < pm.cmd.serverTime {
                    if pm.ps.m_iVehicleNum == 0 {
                        //don't let em unholster the saber by attacking while on vehicle
                        pm.ps.saberHolstered = 0
                        PM_AddEvent(EV_SABER_UNHOLSTER)
                    } else {
                        pm.cmd.buttons &= ~BUTTON_ALT_ATTACK
                        pm.cmd.buttons &= ~BUTTON_ATTACK
                    }
                }
            }

            if pm.ps.weaponTime > 0 {
                pm.ps.weaponTime -= pml.msec
            }

            checkOnlyWeap = true
            break weapChecks
        }

        if pm.ps.saberEntityNum == 0 && pm.ps.saberInFlight {
            //this means our saber has been knocked away
            /*
            if (pm->ps->saberMove != LS_READY)
            {
            PM_SetSaberMove( LS_READY );
            }

            if ((pm->ps->legsAnim) != (pm->ps->torsoAnim) && !BG_InSlopeAnim(pm->ps->legsAnim))
            {
            PM_SetAnim(SETANIM_TORSO,(pm->ps->legsAnim),SETANIM_FLAG_OVERRIDE, 100);
            }

            if (BG_InSaberStandAnim(pm->ps->torsoAnim) || pm->ps->torsoAnim == BOTH_SABERPULL)
            {
            PM_SetAnim(SETANIM_TORSO,BOTH_STAND1,SETANIM_FLAG_OVERRIDE, 100);
            }

            return;
            */
            //Old method, don't want to do this now because we want to finish up reflected attacks and things
            //if our saber is pried out of our hands from one.
            if pm.ps.fd.saberAnimLevel == SS_DUAL {
                if pm.ps.saberHolstered > 1 {
                    pm.ps.saberHolstered = 1
                }
            } else {
                pm.cmd.buttons &= ~BUTTON_ATTACK
            }
            pm.cmd.buttons &= ~BUTTON_ALT_ATTACK
        }

        if (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 {
            //might as well just check for a saber throw right here
            if pm.ps.fd.saberAnimLevel == SS_STAFF {
                //kick instead of doing a throw
                //if in a saber attack return anim, can interrupt it with a kick
                if pm.ps.weaponTime > 0 && PM_SaberInReturn(pm.ps.saberMove) && pm.ps.saberBlocked == BLOCKED_NONE && !((pm.cmd.buttons & BUTTON_ATTACK) != 0) {
                    if (pm.cmd.forwardmove != 0 || pm.cmd.rightmove != 0) && PM_CheckAltKickAttack() {
                        //allow them to do the kick now!
                        var kickMove: Int32 = PM_KickMoveForConditions()
                        if kickMove != -1 {
                            pm.ps.weaponTime = 0
                            PM_SetSaberMove(kickMove)
                            return
                        }
                    }
                }
            } else if pm.ps.weaponTime < 1 && pm.ps.saberCanThrow && !BG_HasYsalamiri(pm.gametype, pm.ps) && BG_CanUseFPNow(pm.gametype, pm.ps, pm.cmd.serverTime, FP_SABERTHROW) && pm.ps.fd.forcePowerLevel[FP_SABERTHROW] > 0 && PM_SaberPowerCheck() {
                // Raven's record lives to the end of his block, so the block is the closure.
                Trace.scratch { sabTr in
                    var fwd = vec3_t()
                    var minFwd = vec3_t()
                    var sabMins = vec3_t()
                    var sabMaxs = vec3_t()

                    sabMins = vec3_t(SABERMINS_X, SABERMINS_Y, SABERMINS_Z)
                    sabMaxs = vec3_t(SABERMAXS_X, SABERMAXS_Y, SABERMAXS_Z)

                    // Raven passes NULL for the second and third outputs of `AngleVectors`.
                    // The ported function takes them by reference, so the body passes scratch vectors it never reads.
                    var scratchRight = vec3_t()
                    var scratchUp = vec3_t()
                    AngleVectors(pm.ps.viewangles, &fwd, &scratchRight, &scratchUp)
                    _VectorMA(pm.ps.origin, SABER_MIN_THROW_DIST, fwd, &minFwd)

                    pm.runTrace(sabTr, pm.ps.origin, sabMins, sabMaxs, minFwd, pm.ps.clientNum, MASK_PLAYERSOLID)

                    if sabTr.allsolid != 0 || sabTr.startsolid != 0 || sabTr.fraction < 1.0 {
                        //not enough room to throw
                    } else {
                        //throw it
                        //This will get set to false again once the saber makes it back to its owner game-side
                        if !pm.ps.saberInFlight {
                            pm.ps.fd.forcePower -= forcePowerNeeded[pm.ps.fd.forcePowerLevel[FP_SABERTHROW]][FP_SABERTHROW]
                        }

                        pm.ps.saberInFlight = true
                    }
                }
            }
        }

        if pm.ps.saberInFlight && pm.ps.saberEntityNum != 0 {
            //guiding saber
            if (pm.ps.fd.saberAnimLevel != SS_DUAL || pm.ps.saberHolstered != 0 || (!((pm.cmd.buttons & BUTTON_ATTACK) != 0) && (pm.ps.torsoAnim == BOTH_SABERDUAL_STANCE || pm.ps.torsoAnim == BOTH_SABERPULL || pm.ps.torsoAnim == BOTH_STAND1 || PM_RunningAnim(pm.ps.torsoAnim) || PM_WalkingAnim(pm.ps.torsoAnim) || PM_JumpingAnim(pm.ps.torsoAnim) || PM_SwimmingAnim(pm.ps.torsoAnim)))) {
                PM_SetAnim(SETANIM_TORSO, BOTH_SABERPULL, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 100)
                pm.ps.torsoTimer = 1
                return
            }
        }

        // don't allow attack until all buttons are up
        //This is bad. It freezes the attack state and the animations if you hold the button after respawning, and it looks strange.
        /*
        if ( pm->ps->pm_flags & PMF_RESPAWNED ) {
        return;
        }
        */

        // check for dead player
        if pm.ps.stats[STAT_HEALTH] <= 0 {
            return
        }

        /*

        if (pm->ps->weaponstate == WEAPON_READY ||
        pm->ps->weaponstate == WEAPON_IDLE)
        {
        if (pm->ps->saberMove != LS_READY && pm->ps->weaponTime <= 0 && !pm->ps->saberBlocked)
        {
        PM_SetSaberMove( LS_READY );
        }
        }

        if(PM_RunningAnim(pm->ps->torsoAnim))
        {
        if ((pm->ps->torsoAnim) != (pm->ps->legsAnim))
        {
        PM_SetAnim(SETANIM_TORSO,(pm->ps->legsAnim),SETANIM_FLAG_OVERRIDE, 100);
        }
        }
        */

        // make weapon function
        if pm.ps.weaponTime > 0 {
            //check for special pull move while busy
            let pullmove: saberMoveName_t = PM_CheckPullAttack()
            if pullmove != LS_NONE {
                pm.ps.weaponTime = 0
                pm.ps.torsoTimer = 0
                pm.ps.legsTimer = 0
                pm.ps.forceHandExtend = HANDEXTEND_NONE
                pm.ps.weaponstate = WEAPON_READY
                PM_SetSaberMove(pullmove)
                return
            }

            pm.ps.weaponTime -= pml.msec

            //This was stupid and didn't work right. Looks like things are fine without it.
            //	if (pm->ps->saberBlocked && pm->ps->torsoAnim != saberMoveData[pm->ps->saberMove].animToUse)
            //	{ //rww - keep him in the blocking pose until he can attack again
            //		PM_SetAnim(SETANIM_TORSO,saberMoveData[pm->ps->saberMove].animToUse,saberMoveData[pm->ps->saberMove].animSetFlags|SETANIM_FLAG_HOLD, saberMoveData[pm->ps->saberMove].blendTime);
            //		return;
            //	}
        } else {
            pm.ps.weaponstate = WEAPON_READY
        }

        // Now we react to a block action by the player's lightsaber.
        if pm.ps.saberBlocked != 0 {
            if pm.ps.saberBlocked >= BLOCKED_UPPER_RIGHT && pm.ps.saberBlocked < BLOCKED_UPPER_RIGHT_PROJ {
                //hold the parry for a bit
                pm.ps.weaponTime = bg_parryDebounce[pm.ps.fd.forcePowerLevel[FP_SABER_DEFENSE]] + 200
            }
            switch pm.ps.saberBlocked {
            case BLOCKED_BOUNCE_MOVE:
                do {
                    //act as a bounceMove and reset the saberMove instead of using a seperate value for it
                    pm.ps.torsoTimer = 0
                    PM_SetSaberMove(pm.ps.saberMove)
                    pm.ps.weaponTime = pm.ps.torsoTimer
                    pm.ps.saberBlocked = 0
                }

            case BLOCKED_PARRY_BROKEN:
                //whatever parry we were is in now broken, play the appropriate knocked-away anim
                do {
                    var nextMove: Int32 = 0

                    if PM_SaberInBrokenParry(pm.ps.saberMove) {
                        //already have one...?
                        nextMove = pm.ps.saberMove
                    } else {
                        nextMove = PM_BrokenParryForParry(pm.ps.saberMove)
                    }
                    if nextMove != LS_NONE {
                        PM_SetSaberMove(nextMove)
                        pm.ps.weaponTime = pm.ps.torsoTimer
                    } else {
                        //Maybe in a knockaway?
                    }
                }

            case BLOCKED_ATK_BOUNCE:
                // If there is absolutely no blocked move in the chart, don't even mess with the animation.
                // OR if we are already in a block or parry.
                if pm.ps.saberMove >= LS_T1_BR__R {
                    //an actual bounce?  Other bounces before this are actually transitions?
                    pm.ps.saberBlocked = BLOCKED_NONE
                } else {
                    var bounceMove: Int32 = 0

                    if PM_SaberInBounce(pm.ps.saberMove) || !BG_SaberInAttack(pm.ps.saberMove) {
                        if (pm.cmd.buttons & BUTTON_ATTACK) != 0 {
                            //transition to a new attack
                            var newQuad: Int32 = PM_SaberMoveQuadrantForMovement(pm.cmd)
                            while newQuad == saberMoveData[pm.ps.saberMove].startQuad {
                                //player is still in same attack quad, don't repeat that attack because it looks bad,
                                //FIXME: try to pick one that might look cool?
                                //newQuad = Q_irand( Q_BR, Q_BL );
                                newQuad = PM_irand_timesync(Q_BR, Q_BL)
                                //FIXME: sanity check, just in case?
                            }
                            bounceMove = transitionMove[saberMoveData[pm.ps.saberMove].startQuad][newQuad]
                        } else {
                            //return to ready
                            if saberMoveData[pm.ps.saberMove].startQuad == Q_T {
                                bounceMove = LS_R_BL2TR
                            } else if saberMoveData[pm.ps.saberMove].startQuad < Q_T {
                                bounceMove = LS_R_TL2BR + saberMoveData[pm.ps.saberMove].startQuad - Q_BR
                            } else {
                                bounceMove = LS_R_BR2TL + saberMoveData[pm.ps.saberMove].startQuad - Q_TL
                            }
                        }
                    } else {
                        //start the bounce
                        bounceMove = PM_SaberBounceForAttack(saberMoveName_t(pm.ps.saberMove))
                    }

                    PM_SetSaberMove(bounceMove)

                    pm.ps.weaponTime = pm.ps.torsoTimer //+saberMoveData[bounceMove].blendTime+SABER_BLOCK_DUR;
                }

            case BLOCKED_UPPER_RIGHT:
                PM_SetSaberMove(LS_PARRY_UR)

            case BLOCKED_UPPER_RIGHT_PROJ:
                PM_SetSaberMove(LS_REFLECT_UR)

            case BLOCKED_UPPER_LEFT:
                PM_SetSaberMove(LS_PARRY_UL)

            case BLOCKED_UPPER_LEFT_PROJ:
                PM_SetSaberMove(LS_REFLECT_UL)

            case BLOCKED_LOWER_RIGHT:
                PM_SetSaberMove(LS_PARRY_LR)

            case BLOCKED_LOWER_RIGHT_PROJ:
                PM_SetSaberMove(LS_REFLECT_LR)

            case BLOCKED_LOWER_LEFT:
                PM_SetSaberMove(LS_PARRY_LL)

            case BLOCKED_LOWER_LEFT_PROJ:
                PM_SetSaberMove(LS_REFLECT_LL)

            case BLOCKED_TOP:
                PM_SetSaberMove(LS_PARRY_UP)

            case BLOCKED_TOP_PROJ:
                PM_SetSaberMove(LS_REFLECT_UP)

            default:
                pm.ps.saberBlocked = BLOCKED_NONE
            }
            if pm.ps.saberBlocked >= BLOCKED_UPPER_RIGHT && pm.ps.saberBlocked < BLOCKED_UPPER_RIGHT_PROJ {
                //hold the parry for a bit
                if pm.ps.torsoTimer < pm.ps.weaponTime {
                    pm.ps.torsoTimer = pm.ps.weaponTime
                }
            }

            //what the? I don't know why I was doing this.
            /*
            if (pm->ps->saberBlocked != BLOCKED_ATK_BOUNCE && pm->ps->saberBlocked != BLOCKED_PARRY_BROKEN && pm->ps->weaponTime < 1)
            {
            pm->ps->torsoTimer = SABER_BLOCK_DUR;
            pm->ps->weaponTime = pm->ps->torsoTimer;
            }
            */

            //clear block
            pm.ps.saberBlocked = 0

            // Charging is like a lead-up before attacking again.  This is an appropriate use, or we can create a new weaponstate for blocking
            pm.ps.weaponstate = WEAPON_READY

            // Done with block, so stop these active weapon branches.
            return
        }

    }
    if pm.ps.saberEntityNum != 0 {
        //only check if we have our saber with us
        // check for weapon change
        // can't change if weapon is firing, but can change again if lowering or raising
        //if ( pm->ps->weaponTime <= 0 || pm->ps->weaponstate != WEAPON_FIRING ) {
        if pm.ps.weaponTime <= 0 && pm.ps.torsoTimer <= 0 {
            if pm.ps.weapon != pm.cmd.weapon {
                PM_BeginWeaponChange(pm.cmd.weapon)
            }
        }
    }

    if PM_CanDoKata() {
        var overrideMove: saberMoveName_t = LS_INVALID
        let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
        //see if we have an overridden (or cancelled) kata move
        if saber1 != nil && saber1!.kataMove != LS_INVALID {
            if saber1!.kataMove != LS_NONE {
                overrideMove = saberMoveName_t(saber1!.kataMove)
            }
        }
        if overrideMove == LS_INVALID {
            //not overridden by first saber, check second
            if saber2 != nil && saber2!.kataMove != LS_INVALID {
                if saber2!.kataMove != LS_NONE {
                    overrideMove = saberMoveName_t(saber2!.kataMove)
                }
            }
        }
        //no overrides, cancelled?
        if overrideMove == LS_INVALID {
            if saber2 != nil && saber2!.kataMove == LS_NONE {
                overrideMove = LS_NONE
            } else if saber2 != nil && saber2!.kataMove == LS_NONE {
                overrideMove = LS_NONE
            }
        }
        if overrideMove == LS_INVALID {
            //not overridden
            //FIXME: make sure to turn on saber(s)!
            switch pm.ps.fd.saberAnimLevel {
            case SS_FAST, SS_TAVION:
                PM_SetSaberMove(LS_A1_SPECIAL)

            case SS_MEDIUM:
                PM_SetSaberMove(LS_A2_SPECIAL)

            case SS_STRONG, SS_DESANN:
                PM_SetSaberMove(LS_A3_SPECIAL)

            case SS_DUAL:
                PM_SetSaberMove(LS_DUAL_SPIN_PROTECT) //PM_CheckDualSpinProtect();

            case SS_STAFF:
                PM_SetSaberMove(LS_STAFF_SOULCAL)

            default:
                break
            }
            pm.ps.weaponstate = WEAPON_FIRING
            //G_DrainPowerForSpecialMove( pm->gent, FP_SABER_OFFENSE, SABER_ALT_ATTACK_POWER );//FP_SPEED, SINGLE_SPECIAL_POWER );
            BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER)
        } else if overrideMove != LS_NONE {
            PM_SetSaberMove(overrideMove)
            pm.ps.weaponstate = WEAPON_FIRING
            BG_ForcePowerDrain(pm.ps, FP_GRIP, SABER_ALT_ATTACK_POWER)
        }
        if overrideMove != LS_NONE {
            //not cancelled
            return
        }
    }

    if pm.ps.weaponTime > 0 {
        return
    }

    // *********************************************************
    // WEAPON_DROPPING
    // *********************************************************

    // change weapon if time
    if pm.ps.weaponstate == WEAPON_DROPPING {
        PM_FinishWeaponChange()
        return
    }

    // *********************************************************
    // WEAPON_RAISING
    // *********************************************************

    if pm.ps.weaponstate == WEAPON_RAISING {
        //Just selected the weapon
        pm.ps.weaponstate = WEAPON_IDLE
        if (pm.ps.legsAnim) == BOTH_WALK1 {
            PM_SetAnim(SETANIM_TORSO, BOTH_WALK1, SETANIM_FLAG_NORMAL, 100)
        } else if (pm.ps.legsAnim) == BOTH_RUN1 {
            PM_SetAnim(SETANIM_TORSO, BOTH_RUN1, SETANIM_FLAG_NORMAL, 100)
        } else if (pm.ps.legsAnim) == BOTH_RUN2 {
            PM_SetAnim(SETANIM_TORSO, BOTH_RUN2, SETANIM_FLAG_NORMAL, 100)
        } else if pm.ps.legsAnim == BOTH_RUN_STAFF {
            PM_SetAnim(SETANIM_TORSO, BOTH_RUN_STAFF, SETANIM_FLAG_NORMAL, 100)
        } else if pm.ps.legsAnim == BOTH_RUN_DUAL {
            PM_SetAnim(SETANIM_TORSO, BOTH_RUN_DUAL, SETANIM_FLAG_NORMAL, 100)
        } else if (pm.ps.legsAnim) == BOTH_WALK1 {
            PM_SetAnim(SETANIM_TORSO, BOTH_WALK1, SETANIM_FLAG_NORMAL, 100)
        } else if pm.ps.legsAnim == BOTH_WALK2 {
            PM_SetAnim(SETANIM_TORSO, BOTH_WALK2, SETANIM_FLAG_NORMAL, 100)
        } else if pm.ps.legsAnim == BOTH_WALK_STAFF {
            PM_SetAnim(SETANIM_TORSO, BOTH_WALK_STAFF, SETANIM_FLAG_NORMAL, 100)
        } else if pm.ps.legsAnim == BOTH_WALK_DUAL {
            PM_SetAnim(SETANIM_TORSO, BOTH_WALK_DUAL, SETANIM_FLAG_NORMAL, 100)
        } else {
            PM_SetAnim(SETANIM_TORSO, PM_GetSaberStance(), SETANIM_FLAG_NORMAL, 100)
        }

        if pm.ps.weaponstate == WEAPON_RAISING {
            return
        }
    }

    if checkOnlyWeap {
        return
    }

    // *********************************************************
    // Check for WEAPON ATTACK
    // *********************************************************
    if pm.ps.fd.saberAnimLevel == SS_STAFF && (pm.cmd.buttons & BUTTON_ALT_ATTACK) != 0 {
        //ok, try a kick I guess.
        var kickMove: Int32 = -1

        if !BG_KickingAnim(pm.ps.torsoAnim) && !BG_KickingAnim(pm.ps.legsAnim) && !BG_InRoll(pm.ps, pm.ps.legsAnim) && pm.ps.saberMove == LS_READY && !((pm.ps.pm_flags & PMF_DUCKED) != 0) && (pm.cmd.upmove >= 0) {
            //player kicks
            kickMove = PM_KickMoveForConditions()
        }

        if kickMove != -1 {
            if pm.ps.groundEntityNum == ENTITYNUM_NONE {
                //if in air, convert kick to an in-air kick
                let gDist: Float = PM_GroundDistance()
                //let's only allow air kicks if a certain distance from the ground
                //it's silly to be able to do them right as you land.
                //also looks wrong to transition from a non-complete flip anim...
                if (!BG_FlippingAnim(pm.ps.legsAnim) || pm.ps.legsTimer <= 0) && gDist > 64.0 && gDist > (-pm.ps.velocity[2]) - 64.0 {
                    switch kickMove {
                    case LS_KICK_F:
                        kickMove = LS_KICK_F_AIR

                    case LS_KICK_B:
                        kickMove = LS_KICK_B_AIR

                    case LS_KICK_R:
                        kickMove = LS_KICK_R_AIR

                    case LS_KICK_L:
                        kickMove = LS_KICK_L_AIR

                    default:
                        kickMove = -1
                    }
                } else {
                    //leave it as a normal kick unless we're too high up
                    if gDist > 128.0 || pm.ps.velocity[2] >= 0 {
                        //off ground, but too close to ground
                        kickMove = -1
                    }
                }
            }

            if kickMove != -1 {
                PM_SetSaberMove(kickMove)
                return
            }
        }
    }

    //this is never a valid regular saber attack button
    pm.cmd.buttons &= ~BUTTON_ALT_ATTACK

    if !delayed_fire {
        // Start with the current move, and cross index it with the current control states.
        if pm.ps.saberMove > LS_NONE && pm.ps.saberMove < LS_MOVE_MAX {
            curmove = pm.ps.saberMove
        } else {
            curmove = LS_READY
        }

        if curmove == LS_A_JUMP_T__B_ || pm.ps.torsoAnim == BOTH_FORCELEAP2_T__B_ {
            //must transition back to ready from this anim
            newmove = LS_R_T2B
        } else if !((pm.cmd.buttons & (BUTTON_ATTACK | BUTTON_ALT_ATTACK)) != 0) {
            // check for fire
            //not attacking
            pm.ps.weaponTime = 0

            if pm.ps.weaponTime > 0 {
                //Still firing
                pm.ps.weaponstate = WEAPON_FIRING
            } else if pm.ps.weaponstate != WEAPON_READY {
                pm.ps.weaponstate = WEAPON_IDLE
            }
            //Check for finishing an anim if necc.
            if curmove >= LS_S_TL2BR && curmove <= LS_S_T2B {
                //started a swing, must continue from here
                newmove = LS_A_TL2BR + (curmove - LS_S_TL2BR)
            } else if curmove >= LS_A_TL2BR && curmove <= LS_A_T2B {
                //finished an attack, must continue from here
                newmove = LS_R_TL2BR + (curmove - LS_A_TL2BR)
            } else if PM_SaberInTransition(curmove) {
                //in a transition, must play sequential attack
                newmove = saberMoveData[curmove].chain_attack
            } else if PM_SaberInBounce(curmove) {
                //in a bounce
                newmove = saberMoveData[curmove].chain_idle //oops, not attacking, so don't chain
            } else {
                //FIXME: what about returning from a parry?
                //PM_SetSaberMove( LS_READY );
                //if ( pm->ps->saberBlockingTime > pm->cmd.serverTime )
                do {
                    PM_SetSaberMove(LS_READY)
                }
                return
            }
        }

        // ***************************************************
        // Pressing attack, so we must look up the proper attack move.

        if pm.ps.weaponTime > 0 {
            // Last attack is not yet complete.
            pm.ps.weaponstate = WEAPON_FIRING
            return
        } else {
            var both: Int32 = 0
            if pm.ps.torsoAnim == BOTH_FORCELONGLEAP_ATTACK || pm.ps.torsoAnim == BOTH_FORCELONGLEAP_LAND {
                //can't attack in these anims
                return
            } else if pm.ps.torsoAnim == BOTH_FORCELONGLEAP_START {
                //only 1 attack you can do from this anim
                if pm.ps.torsoTimer >= 200 {
                    //hit it early enough to do the attack
                    PM_SetSaberMove(LS_LEAP_ATTACK)
                }
                return
            }
            if curmove >= LS_PARRY_UP && curmove <= LS_REFLECT_LL {
                //from a parry or reflection, can go directly into an attack
                switch saberMoveData[curmove].endQuad {
                case Q_T:
                    newmove = LS_A_T2B

                case Q_TR:
                    newmove = LS_A_TR2BL

                case Q_TL:
                    newmove = LS_A_TL2BR

                case Q_BR:
                    newmove = LS_A_BR2TL

                case Q_BL:
                    newmove = LS_A_BL2TR

                default:
                    break
                }
            }

            if newmove != LS_NONE {
                //have a valid, final LS_ move picked, so skip findingt he transition move and just get the anim
                anim = saberMoveData[newmove].animToUse
            }

            //FIXME: diagonal dirs use the figure-eight attacks from ready pose?
            if anim == -1 {
                //FIXME: take FP_SABER_OFFENSE into account here somehow?
                if PM_SaberInTransition(curmove) {
                    //in a transition, must play sequential attack
                    newmove = saberMoveData[curmove].chain_attack
                } else if curmove >= LS_S_TL2BR && curmove <= LS_S_T2B {
                    //started a swing, must continue from here
                    newmove = LS_A_TL2BR + (curmove - LS_S_TL2BR)
                } else if PM_SaberInBrokenParry(curmove) {
                    //broken parries must always return to ready
                    newmove = LS_READY
                } else {
                    //get attack move from movement command
                    /*
                    if ( PM_SaberKataDone() )
                    {//we came from a bounce and cannot chain to another attack because our kata is done
                    newmove = saberMoveData[curmove].chain_idle;
                    }
                    else */
                    newmove = PM_SaberAttackForMovement(curmove)
                    if (PM_SaberInBounce(curmove) || PM_SaberInBrokenParry(curmove)) && saberMoveData[newmove].startQuad == saberMoveData[curmove].endQuad {
                        //this attack would be a repeat of the last (which was blocked), so don't actually use it, use the default chain attack for this bounce
                        newmove = saberMoveData[curmove].chain_attack
                    }

                    if PM_SaberKataDone(curmove, newmove) {
                        //cannot chain this time
                        newmove = saberMoveData[curmove].chain_idle
                    }
                }
                /*
                if ( newmove == LS_NONE )
                {//FIXME: should we allow this?  Are there some anims that you should never be able to chain into an attack?
                //only curmove that might get in here is LS_NONE, LS_DRAW, LS_PUTAWAY and the LS_R_ returns... all of which are in Q_R
                newmove = PM_AttackMoveForQuad( saberMoveData[curmove].endQuad );
                }
                */
                if newmove != LS_NONE {
                    //Now get the proper transition move
                    newmove = PM_SaberAnimTransitionAnim(curmove, newmove)
                    anim = saberMoveData[newmove].animToUse
                }
            }

            if anim == -1 {
                //not side-stepping, pick neutral anim
                // Add randomness for prototype?
                newmove = saberMoveData[curmove].chain_attack

                anim = saberMoveData[newmove].animToUse

                if pm.cmd.forwardmove == 0 && pm.cmd.rightmove == 0 && pm.cmd.upmove >= 0 && pm.ps.groundEntityNum != ENTITYNUM_NONE {
                    //not moving at all, so set the anim on entire body
                    both = 1
                }
            }

            if anim == -1 {
                switch pm.ps.legsAnim {
                case BOTH_WALK1, BOTH_WALK2, BOTH_WALK_STAFF, BOTH_WALK_DUAL, BOTH_WALKBACK1, BOTH_WALKBACK2, BOTH_WALKBACK_STAFF, BOTH_WALKBACK_DUAL, BOTH_RUN1, BOTH_RUN2, BOTH_RUN_STAFF, BOTH_RUN_DUAL, BOTH_RUNBACK1, BOTH_RUNBACK2, BOTH_RUNBACK_STAFF:
                    anim = pm.ps.legsAnim

                default:
                    anim = PM_GetSaberStance()
                }

                //				if (PM_RunningAnim(anim) && !pm->cmd.forwardmove && !pm->cmd.rightmove)
                //				{ //semi-hacky (if not moving on x-y and still playing the running anim, force the player out of it)
                //					anim = PM_GetSaberStance();
                //				}
                newmove = LS_READY
            }

            PM_SetSaberMove(newmove)

            if both != 0 && pm.ps.torsoAnim == anim {
                PM_SetAnim(SETANIM_LEGS, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 100)
            }

            //don't fire again until anim is done
            pm.ps.weaponTime = pm.ps.torsoTimer
        }
    }

    // *********************************************************
    // WEAPON_FIRING
    // *********************************************************

    pm.ps.weaponstate = WEAPON_FIRING

    amount = weaponData[pm.ps.weapon].energyPerShot

    addTime = pm.ps.weaponTime

    pm.ps.saberAttackSequence = pm.ps.torsoAnim
    if addTime == 0 {
        addTime = weaponData[pm.ps.weapon].fireTime
    }
    pm.ps.weaponTime = addTime
}

/// Source: oracle/codemp/game/bg_saber.c:3802
func PM_SetSaberMove(_ newMove: Int32) {
    var setflags: UInt32 = saberMoveData[newMove].animSetFlags
    var anim: Int32 = saberMoveData[newMove].animToUse
    var parts: Int32 = SETANIM_TORSO

    if newMove == LS_READY || newMove == LS_A_FLIP_STAB || newMove == LS_A_FLIP_SLASH {
        //finished with a kata (or in a special move) reset attack counter
        pm.ps.saberAttackChainCount = 0
    } else if BG_SaberInAttack(newMove) {
        //continuing with a kata, increment attack counter
        pm.ps.saberAttackChainCount += 1
    }

    if pm.ps.saberAttackChainCount > 16 {
        //for the sake of being able to send the value over the net within a reasonable bit count
        pm.ps.saberAttackChainCount = 16
    }

    if newMove == LS_DRAW {
        let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
        if saber1 != nil && saber1!.drawAnim != -1 {
            anim = saber1!.drawAnim
        } else if saber2 != nil && saber2!.drawAnim != -1 {
            anim = saber2!.drawAnim
        } else if pm.ps.fd.saberAnimLevel == SS_STAFF {
            anim = BOTH_S1_S7
        } else if pm.ps.fd.saberAnimLevel == SS_DUAL {
            anim = BOTH_S1_S6
        }
    } else if newMove == LS_PUTAWAY {
        let saber1: SaberInfo? = BG_MySaber(pm.ps.clientNum, 0)
        let saber2: SaberInfo? = BG_MySaber(pm.ps.clientNum, 1)
        if saber1 != nil && saber1!.putawayAnim != -1 {
            anim = saber1!.putawayAnim
        } else if saber2 != nil && saber2!.putawayAnim != -1 {
            anim = saber2!.putawayAnim
        } else if pm.ps.fd.saberAnimLevel == SS_STAFF {
            anim = BOTH_S7_S1
        } else if pm.ps.fd.saberAnimLevel == SS_DUAL {
            anim = BOTH_S6_S1
        }
    } else if pm.ps.fd.saberAnimLevel == SS_STAFF && newMove >= LS_S_TL2BR && newMove < LS_REFLECT_LL {
        //staff has an entirely new set of anims, besides special attacks
        //FIXME: include ready and draw/putaway?
        //FIXME: get hand-made bounces and deflections?
        if newMove >= LS_V1_BR && newMove <= LS_REFLECT_LL {
            //there aren't 1-7, just 1, 6 and 7, so just set it
            anim = BOTH_P7_S7_T_ + (anim - BOTH_P1_S1_T_) //shift it up to the proper set
        } else {
            //add the appropriate animLevel
            anim += (pm.ps.fd.saberAnimLevel - FORCE_LEVEL_1) * SABER_ANIM_GROUP_SIZE
        }
    } else if pm.ps.fd.saberAnimLevel == SS_DUAL && newMove >= LS_S_TL2BR && newMove < LS_REFLECT_LL {
        //akimbo has an entirely new set of anims, besides special attacks
        //FIXME: include ready and draw/putaway?
        //FIXME: get hand-made bounces and deflections?
        if newMove >= LS_V1_BR && newMove <= LS_REFLECT_LL {
            //there aren't 1-7, just 1, 6 and 7, so just set it
            anim = BOTH_P6_S6_T_ + (anim - BOTH_P1_S1_T_) //shift it up to the proper set
        } else {
            //add the appropriate animLevel
            anim += (pm.ps.fd.saberAnimLevel - FORCE_LEVEL_1) * SABER_ANIM_GROUP_SIZE
        }
    } else if pm.ps.fd.saberAnimLevel > FORCE_LEVEL_1 && !BG_SaberInIdle(newMove) && !PM_SaberInParry(newMove) && !PM_SaberInKnockaway(newMove) && !PM_SaberInBrokenParry(newMove) && !PM_SaberInReflect(newMove) && !BG_SaberInSpecial(newMove) {
        /*
        else if ( newMove == LS_DRAW && pm->ps->SaberStaff() )
        {//hold saber out front as we turn it on
        //FIXME: need a real "draw" anim for this (and put-away)
        anim = BOTH_SABERSTAFF_STANCE;
        }
        */
        //readies, parries and reflections have only 1 level
        anim += (pm.ps.fd.saberAnimLevel - FORCE_LEVEL_1) * SABER_ANIM_GROUP_SIZE
    }

    // If the move does the same animation as the last one, we need to force a restart...
    if saberMoveData[pm.ps.saberMove].animToUse == anim && newMove > LS_PUTAWAY {
        setflags |= UInt32(bitPattern: SETANIM_FLAG_RESTART)
    }

    //saber torso anims should always be highest priority (4/12/02 - for special anims only)
    if pm.ps.m_iVehicleNum == 0 {
        //if not riding a vehicle
        if BG_SaberInSpecial(newMove) {
            setflags |= UInt32(bitPattern: SETANIM_FLAG_OVERRIDE)
        }
        /*
        if ( newMove == LS_A_LUNGE
        || newMove == LS_A_JUMP_T__B_
        || newMove == LS_A_BACKSTAB
        || newMove == LS_A_BACK
        || newMove == LS_A_BACK_CR
        || newMove == LS_A_FLIP_STAB
        || newMove == LS_A_FLIP_SLASH
        || newMove == LS_JUMPATTACK_DUAL
        || newMove == LS_A_BACKFLIP_ATK)
        {
        setflags |= SETANIM_FLAG_OVERRIDE;
        }
        */
    }
    if BG_InSaberStandAnim(anim) || anim == BOTH_STAND1 {
        anim = (pm.ps.legsAnim)

        if (anim >= BOTH_STAND1 && anim <= BOTH_STAND4TOATTACK2) || (anim >= TORSO_DROPWEAP1 && anim <= TORSO_WEAPONIDLE10) {
            //If standing then use the special saber stand anim
            anim = PM_GetSaberStance()
        }

        if (pm.ps.pm_flags & PMF_DUCKED) != 0 {
            //Playing torso walk anims while crouched makes you look like a monkey
            anim = PM_GetSaberStance()
        }

        if anim == BOTH_WALKBACK1 || anim == BOTH_WALKBACK2 || anim == BOTH_WALK1 {
            //normal stance when walking backward so saber doesn't look like it's cutting through leg
            anim = PM_GetSaberStance()
        }

        if BG_InSlopeAnim(anim) {
            anim = PM_GetSaberStance()
        }

        parts = SETANIM_TORSO
    }

    if pm.ps.m_iVehicleNum == 0 {
        //if not riding a vehicle
        if newMove == LS_JUMPATTACK_ARIAL_RIGHT || newMove == LS_JUMPATTACK_ARIAL_LEFT {
            //force only on legs
            parts = SETANIM_LEGS
        } else if newMove == LS_A_LUNGE || newMove == LS_A_JUMP_T__B_ || newMove == LS_A_BACKSTAB || newMove == LS_A_BACK || newMove == LS_A_BACK_CR || newMove == LS_ROLL_STAB || newMove == LS_A_FLIP_STAB || newMove == LS_A_FLIP_SLASH || newMove == LS_JUMPATTACK_DUAL || newMove == LS_JUMPATTACK_ARIAL_LEFT || newMove == LS_JUMPATTACK_ARIAL_RIGHT || newMove == LS_JUMPATTACK_CART_LEFT || newMove == LS_JUMPATTACK_CART_RIGHT || newMove == LS_JUMPATTACK_STAFF_LEFT || newMove == LS_JUMPATTACK_STAFF_RIGHT || newMove == LS_A_BACKFLIP_ATK || newMove == LS_STABDOWN || newMove == LS_STABDOWN_STAFF || newMove == LS_STABDOWN_DUAL || newMove == LS_DUAL_SPIN_PROTECT || newMove == LS_STAFF_SOULCAL || newMove == LS_A1_SPECIAL || newMove == LS_A2_SPECIAL || newMove == LS_A3_SPECIAL || newMove == LS_UPSIDE_DOWN_ATTACK || newMove == LS_PULL_ATTACK_STAB || newMove == LS_PULL_ATTACK_SWING || BG_KickMove(newMove) {
            parts = SETANIM_BOTH
        } else if BG_SpinningSaberAnim(anim) {
            //spins must be played on entire body
            parts = SETANIM_BOTH
        } else if (pm.cmd.forwardmove == 0 && pm.cmd.rightmove == 0 && pm.cmd.upmove == 0) {
            //not trying to run, duck or jump
            if !BG_FlippingAnim(pm.ps.legsAnim) && !BG_InRoll(pm.ps, pm.ps.legsAnim) && !PM_InKnockDown(pm.ps) && !PM_JumpingAnim(pm.ps.legsAnim) && !BG_InSpecialJump(pm.ps.legsAnim) && anim != PM_GetSaberStance() && pm.ps.groundEntityNum != ENTITYNUM_NONE && !((pm.ps.pm_flags & PMF_DUCKED) != 0) {
                parts = SETANIM_BOTH
            } else if !((pm.ps.pm_flags & PMF_DUCKED) != 0) && (newMove == LS_SPINATTACK_DUAL || newMove == LS_SPINATTACK) {
                parts = SETANIM_BOTH
            }
        }

        PM_SetAnim(parts, anim, Int32(bitPattern: setflags), saberMoveData[newMove].blendTime)
        if parts != SETANIM_LEGS && (pm.ps.legsAnim == BOTH_ARIAL_LEFT || pm.ps.legsAnim == BOTH_ARIAL_RIGHT) {
            if pm.ps.legsTimer > pm.ps.torsoTimer {
                pm.ps.legsTimer = pm.ps.torsoTimer
            }
        }
    }

    if (pm.ps.torsoAnim) == anim {
        //successfully changed anims
        //special check for *starting* a saber swing
        //playing at attack
        if BG_SaberInAttack(newMove) || BG_SaberInSpecialAttack(anim) {
            if pm.ps.saberMove != newMove {
                //wasn't playing that attack before
                if newMove != LS_KICK_F && newMove != LS_KICK_B && newMove != LS_KICK_R && newMove != LS_KICK_L && newMove != LS_KICK_F_AIR && newMove != LS_KICK_B_AIR && newMove != LS_KICK_R_AIR && newMove != LS_KICK_L_AIR {
                    PM_AddEvent(EV_SABER_ATTACK)
                }

                if pm.ps.brokenLimbs != 0 {
                    //randomly make pain sounds with a broken arm because we are suffering.
                    var iFactor: Int32 = -1

                    if (pm.ps.brokenLimbs & (1 << BROKENLIMB_RARM)) != 0 {
                        //You're using it more. So it hurts more.
                        iFactor = 5
                    } else if (pm.ps.brokenLimbs & (1 << BROKENLIMB_LARM)) != 0 {
                        iFactor = 10
                    }

                    if iFactor != -1 {
                        if PM_irand_timesync(0, iFactor) == 0 {
                            BG_AddPredictableEventToPlayerstate(EV_PAIN, PM_irand_timesync(1, 100), pm.ps)
                        }
                    }
                }
            }
        }

        if BG_SaberInSpecial(newMove) && pm.ps.weaponTime < pm.ps.torsoTimer {
            //rww 01-02-03 - I think this will solve the issue of special attacks being interruptable, hopefully without side effects
            pm.ps.weaponTime = pm.ps.torsoTimer
        }

        pm.ps.saberMove = newMove
        pm.ps.saberBlocking = saberMoveData[newMove].blocking

        pm.ps.torsoAnim = anim

        if pm.ps.weaponTime <= 0 {
            pm.ps.saberBlocked = BLOCKED_NONE
        }
    }
}

/// Source: oracle/codemp/game/bg_saber.c:4100
func BG_MySaber(_ clientNum: Int32, _ saberNum: Int32) -> JKAMP.SaberInfo? {
    //returns a pointer to the requested saberNum
    let ent: BgEntity = pm.entity(at: clientNum)
    if bgEntityInuse(ent) && ent.playerState != nil {
        // Raven names `ent->client->saber[saberNum]` more than once, and each Swift use calls the channel, so the draft reads it once.
        let saber = bgClientSaber(of: clientNum, at: saberNum)
        // Raven tests `!ent->client->saber[saberNum].model` and `!ent->client->saber[saberNum].model[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if saber!.model.isEmpty {
            //don't have saber anymore!
            return nil
        }
        return saber
    }

    return nil
}
