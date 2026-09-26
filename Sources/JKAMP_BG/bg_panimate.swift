import Foundation
import JKAMP
import JKAShared

/// Source: oracle/codemp/game/bg_panimate.c:1671
var BGPAFtextLoaded: Bool {
    get { bg.variables.BGPAFtextLoaded }
    set { bg.variables.BGPAFtextLoaded = newValue }
}

/// Source: oracle/codemp/game/bg_panimate.c:1672
var bgHumanoidAnimations: Slots<JKAMP.Animation> { bg.storage.bgHumanoidAnimations }

/// Source: oracle/codemp/game/bg_panimate.c:1702
var bgAllAnims: Slots<JKAMP.BgLoadedAnim> { bg.storage.bgAllAnims }

/// Source: oracle/codemp/game/bg_panimate.c:1703
var bgNumAllAnims: Int32 {
    get { bg.variables.bgNumAllAnims }
    set { bg.variables.bgNumAllAnims = newValue }
}

/// Source: oracle/codemp/game/bg_panimate.c:33
func BG_SaberStanceAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_STAND1, BOTH_STAND2, BOTH_SABERFAST_STANCE, BOTH_SABERSLOW_STANCE, BOTH_SABERSTAFF_STANCE, BOTH_SABERDUAL_STANCE:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:49
func BG_CrouchAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_SIT1, BOTH_SIT2, BOTH_SIT3, BOTH_CROUCH1, BOTH_CROUCH1IDLE, BOTH_CROUCH1WALK, BOTH_CROUCH1WALKBACK, BOTH_CROUCH2TOSTAND1, BOTH_CROUCH3, BOTH_KNEES1, BOTH_CROUCHATTACKBACK1, BOTH_ROLL_STAB:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:71
func BG_InSpecialJump(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_WALL_RUN_RIGHT, BOTH_WALL_RUN_RIGHT_STOP, BOTH_WALL_RUN_RIGHT_FLIP, BOTH_WALL_RUN_LEFT, BOTH_WALL_RUN_LEFT_STOP, BOTH_WALL_RUN_LEFT_FLIP, BOTH_WALL_FLIP_RIGHT, BOTH_WALL_FLIP_LEFT, BOTH_FLIP_BACK1, BOTH_FLIP_BACK2, BOTH_FLIP_BACK3, BOTH_WALL_FLIP_BACK1, BOTH_BUTTERFLY_LEFT, BOTH_BUTTERFLY_RIGHT, BOTH_BUTTERFLY_FL1, BOTH_BUTTERFLY_FR1, BOTH_FJSS_TR_BL, BOTH_FJSS_TL_BR, BOTH_FORCELEAP2_T__B_, BOTH_JUMPFLIPSLASHDOWN1, BOTH_JUMPFLIPSTABDOWN, BOTH_JUMPATTACK6, BOTH_JUMPATTACK7, BOTH_ARIAL_LEFT, BOTH_ARIAL_RIGHT, BOTH_ARIAL_F1, BOTH_CARTWHEEL_LEFT, BOTH_CARTWHEEL_RIGHT, BOTH_FORCELONGLEAP_START, BOTH_FORCELONGLEAP_ATTACK, BOTH_FORCEWALLRUNFLIP_START, BOTH_FORCEWALLRUNFLIP_END, BOTH_FORCEWALLRUNFLIP_ALT, BOTH_FLIP_ATTACK7, BOTH_FLIP_HOLD7, BOTH_FLIP_LAND, BOTH_A7_SOULCAL:
        return true

    default:
        break
    }
    if BG_InReboundJump(anim) {
        return true
    }
    if BG_InReboundHold(anim) {
        return true
    }
    if BG_InReboundRelease(anim) {
        return true
    }
    if BG_InBackFlip(anim) {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:134
func BG_InSaberStandAnim(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_SABERFAST_STANCE, BOTH_STAND2, BOTH_SABERSLOW_STANCE, BOTH_SABERDUAL_STANCE, BOTH_SABERSTAFF_STANCE:
        return true

    default:
        return false
    }
}

/// Source: oracle/codemp/game/bg_panimate.c:149
func BG_InReboundJump(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_FORCEWALLREBOUND_FORWARD, BOTH_FORCEWALLREBOUND_LEFT, BOTH_FORCEWALLREBOUND_BACK, BOTH_FORCEWALLREBOUND_RIGHT:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:163
func BG_InReboundHold(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_FORCEWALLHOLD_FORWARD, BOTH_FORCEWALLHOLD_LEFT, BOTH_FORCEWALLHOLD_BACK, BOTH_FORCEWALLHOLD_RIGHT:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:177
func BG_InReboundRelease(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_FORCEWALLRELEASE_FORWARD, BOTH_FORCEWALLRELEASE_LEFT, BOTH_FORCEWALLRELEASE_BACK, BOTH_FORCEWALLRELEASE_RIGHT:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:191
func BG_InBackFlip(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_FLIP_BACK1, BOTH_FLIP_BACK2, BOTH_FLIP_BACK3:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:204
func BG_DirectFlippingAnim(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_FLIP_F, BOTH_FLIP_B, BOTH_FLIP_L, BOTH_FLIP_R:
        return true

    default:
        break
    }

    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:219
func BG_SaberInAttackPure(_ move: Int32) -> Bool {
    if move >= LS_A_TL2BR && move <= LS_A_T2B {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:227
func BG_SaberInAttack(_ move: Int32) -> Bool {
    if move >= LS_A_TL2BR && move <= LS_A_T2B {
        return true
    }
    switch move {
    case LS_A_BACK, LS_A_BACK_CR, LS_A_BACKSTAB, LS_ROLL_STAB, LS_A_LUNGE, LS_A_JUMP_T__B_, LS_A_FLIP_STAB, LS_A_FLIP_SLASH, LS_JUMPATTACK_DUAL, LS_JUMPATTACK_ARIAL_LEFT, LS_JUMPATTACK_ARIAL_RIGHT, LS_JUMPATTACK_CART_LEFT, LS_JUMPATTACK_CART_RIGHT, LS_JUMPATTACK_STAFF_LEFT, LS_JUMPATTACK_STAFF_RIGHT, LS_BUTTERFLY_LEFT, LS_BUTTERFLY_RIGHT, LS_A_BACKFLIP_ATK, LS_SPINATTACK_DUAL, LS_SPINATTACK, LS_LEAP_ATTACK, LS_SWOOP_ATTACK_RIGHT, LS_SWOOP_ATTACK_LEFT, LS_TAUNTAUN_ATTACK_RIGHT, LS_TAUNTAUN_ATTACK_LEFT, LS_KICK_F, LS_KICK_B, LS_KICK_R, LS_KICK_L, LS_KICK_S, LS_KICK_BF, LS_KICK_RL, LS_KICK_F_AIR, LS_KICK_B_AIR, LS_KICK_R_AIR, LS_KICK_L_AIR, LS_STABDOWN, LS_STABDOWN_STAFF, LS_STABDOWN_DUAL, LS_DUAL_SPIN_PROTECT, LS_STAFF_SOULCAL, LS_A1_SPECIAL, LS_A2_SPECIAL, LS_A3_SPECIAL, LS_UPSIDE_DOWN_ATTACK, LS_PULL_ATTACK_STAB, LS_PULL_ATTACK_SWING, LS_SPINATTACK_ALORA, LS_DUAL_FB, LS_DUAL_LR, LS_HILT_BASH:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:292
func BG_SaberInKata(_ saberMove: Int32) -> Bool {
    switch saberMove {
    case LS_A1_SPECIAL, LS_A2_SPECIAL, LS_A3_SPECIAL, LS_DUAL_SPIN_PROTECT, LS_STAFF_SOULCAL:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:306
func BG_InKataAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_A6_SABERPROTECT, BOTH_A7_SOULCAL, BOTH_A1_SPECIAL, BOTH_A2_SPECIAL, BOTH_A3_SPECIAL:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:320
func BG_SaberInSpecial(_ move: Int32) -> Bool {
    switch move {
    case LS_A_BACK, LS_A_BACK_CR, LS_A_BACKSTAB, LS_ROLL_STAB, LS_A_LUNGE, LS_A_JUMP_T__B_, LS_A_FLIP_STAB, LS_A_FLIP_SLASH, LS_JUMPATTACK_DUAL, LS_JUMPATTACK_ARIAL_LEFT, LS_JUMPATTACK_ARIAL_RIGHT, LS_JUMPATTACK_CART_LEFT, LS_JUMPATTACK_CART_RIGHT, LS_JUMPATTACK_STAFF_LEFT, LS_JUMPATTACK_STAFF_RIGHT, LS_BUTTERFLY_LEFT, LS_BUTTERFLY_RIGHT, LS_A_BACKFLIP_ATK, LS_SPINATTACK_DUAL, LS_SPINATTACK, LS_LEAP_ATTACK, LS_SWOOP_ATTACK_RIGHT, LS_SWOOP_ATTACK_LEFT, LS_TAUNTAUN_ATTACK_RIGHT, LS_TAUNTAUN_ATTACK_LEFT, LS_KICK_F, LS_KICK_B, LS_KICK_R, LS_KICK_L, LS_KICK_S, LS_KICK_BF, LS_KICK_RL, LS_KICK_F_AIR, LS_KICK_B_AIR, LS_KICK_R_AIR, LS_KICK_L_AIR, LS_STABDOWN, LS_STABDOWN_STAFF, LS_STABDOWN_DUAL, LS_DUAL_SPIN_PROTECT, LS_STAFF_SOULCAL, LS_A1_SPECIAL, LS_A2_SPECIAL, LS_A3_SPECIAL, LS_UPSIDE_DOWN_ATTACK, LS_PULL_ATTACK_STAB, LS_PULL_ATTACK_SWING, LS_SPINATTACK_ALORA, LS_DUAL_FB, LS_DUAL_LR, LS_HILT_BASH:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:380
func BG_KickMove(_ move: Int32) -> Bool {
    switch move {
    case LS_KICK_F, LS_KICK_B, LS_KICK_R, LS_KICK_L, LS_KICK_S, LS_KICK_BF, LS_KICK_RL, LS_KICK_F_AIR, LS_KICK_B_AIR, LS_KICK_R_AIR, LS_KICK_L_AIR, LS_HILT_BASH:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:401
func BG_SaberInIdle(_ move: Int32) -> Bool {
    switch move {
    case LS_NONE, LS_READY, LS_DRAW, LS_PUTAWAY:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:415
func BG_InExtraDefenseSaberMove(_ move: Int32) -> Bool {
    switch move {
    case LS_SPINATTACK_DUAL, LS_SPINATTACK, LS_DUAL_SPIN_PROTECT, LS_STAFF_SOULCAL, LS_A1_SPECIAL, LS_A2_SPECIAL, LS_A3_SPECIAL, LS_JUMPATTACK_DUAL:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:433
func BG_FlippingAnim(_ anim: Int32) -> Bool {
    switch anim {
    //Not really flips, but...
    //
    //JKA
    case BOTH_FLIP_F, BOTH_FLIP_B, BOTH_FLIP_L, BOTH_FLIP_R, BOTH_WALL_RUN_RIGHT_FLIP, BOTH_WALL_RUN_LEFT_FLIP, BOTH_WALL_FLIP_RIGHT, BOTH_WALL_FLIP_LEFT, BOTH_FLIP_BACK1, BOTH_FLIP_BACK2, BOTH_FLIP_BACK3, BOTH_WALL_FLIP_BACK1, BOTH_WALL_RUN_RIGHT, BOTH_WALL_RUN_LEFT, BOTH_WALL_RUN_RIGHT_STOP, BOTH_WALL_RUN_LEFT_STOP, BOTH_BUTTERFLY_LEFT, BOTH_BUTTERFLY_RIGHT, BOTH_BUTTERFLY_FL1, BOTH_BUTTERFLY_FR1, BOTH_ARIAL_LEFT, BOTH_ARIAL_RIGHT, BOTH_ARIAL_F1, BOTH_CARTWHEEL_LEFT, BOTH_CARTWHEEL_RIGHT, BOTH_JUMPFLIPSLASHDOWN1, BOTH_JUMPFLIPSTABDOWN, BOTH_JUMPATTACK6, BOTH_JUMPATTACK7, BOTH_FORCEWALLRUNFLIP_END, BOTH_FORCEWALLRUNFLIP_ALT, BOTH_FLIP_ATTACK7, BOTH_A7_SOULCAL:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:479
func BG_SpinningSaberAnim(_ anim: Int32) -> Bool {
    switch anim {
    //level 1 - FIXME: level 1 will have *no* spins
    //level 2
    //level 3
    //level 4
    //level 5
    //level 6
    //level 7
    //special
    //case BOTH_A2_STABBACK1:
    case BOTH_T1_BR_BL, BOTH_T1__R__L, BOTH_T1__R_BL, BOTH_T1_TR_BL, BOTH_T1_BR_TL, BOTH_T1_BR__L, BOTH_T1_TL_BR, BOTH_T1__L_BR, BOTH_T1__L__R, BOTH_T1_BL_BR, BOTH_T1_BL__R, BOTH_T1_BL_TR, BOTH_T2_BR__L, BOTH_T2_BR_BL, BOTH_T2__R_BL, BOTH_T2__L_BR, BOTH_T2_BL_BR, BOTH_T2_BL__R, BOTH_T3_BR__L, BOTH_T3_BR_BL, BOTH_T3__R_BL, BOTH_T3__L_BR, BOTH_T3_BL_BR, BOTH_T3_BL__R, BOTH_T4_BR__L, BOTH_T4_BR_BL, BOTH_T4__R_BL, BOTH_T4__L_BR, BOTH_T4_BL_BR, BOTH_T4_BL__R, BOTH_T5_BR_BL, BOTH_T5__R__L, BOTH_T5__R_BL, BOTH_T5_TR_BL, BOTH_T5_BR_TL, BOTH_T5_BR__L, BOTH_T5_TL_BR, BOTH_T5__L_BR, BOTH_T5__L__R, BOTH_T5_BL_BR, BOTH_T5_BL__R, BOTH_T5_BL_TR, BOTH_T6_BR_TL, BOTH_T6__R_TL, BOTH_T6__R__L, BOTH_T6__R_BL, BOTH_T6_TR_TL, BOTH_T6_TR__L, BOTH_T6_TR_BL, BOTH_T6_T__TL, BOTH_T6_T__BL, BOTH_T6_TL_BR, BOTH_T6__L_BR, BOTH_T6__L__R, BOTH_T6_TL__R, BOTH_T6_TL_TR, BOTH_T6__L_TR, BOTH_T6__L_T_, BOTH_T6_BL_T_, BOTH_T6_BR__L, BOTH_T6_BR_BL, BOTH_T6_BL_BR, BOTH_T6_BL__R, BOTH_T6_BL_TR, BOTH_T7_BR_TL, BOTH_T7_BR__L, BOTH_T7_BR_BL, BOTH_T7__R__L, BOTH_T7__R_BL, BOTH_T7_TR__L, BOTH_T7_T___R, BOTH_T7_TL_BR, BOTH_T7__L_BR, BOTH_T7__L__R, BOTH_T7_BL_BR, BOTH_T7_BL__R, BOTH_T7_BL_TR, BOTH_T7_TL_TR, BOTH_T7_T__BR, BOTH_T7__L_TR, BOTH_V7_BL_S7, BOTH_ATTACK_BACK, BOTH_CROUCHATTACKBACK1, BOTH_BUTTERFLY_LEFT, BOTH_BUTTERFLY_RIGHT, BOTH_FJSS_TR_BL, BOTH_FJSS_TL_BR, BOTH_JUMPFLIPSLASHDOWN1, BOTH_JUMPFLIPSTABDOWN:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:587
func BG_SaberInSpecialAttack(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_A2_STABBACK1, BOTH_ATTACK_BACK, BOTH_CROUCHATTACKBACK1, BOTH_ROLL_STAB, BOTH_BUTTERFLY_LEFT, BOTH_BUTTERFLY_RIGHT, BOTH_BUTTERFLY_FL1, BOTH_BUTTERFLY_FR1, BOTH_FJSS_TR_BL, BOTH_FJSS_TL_BR, BOTH_LUNGE2_B__T_, BOTH_FORCELEAP2_T__B_, BOTH_JUMPFLIPSLASHDOWN1, BOTH_JUMPFLIPSTABDOWN, BOTH_JUMPATTACK6, BOTH_JUMPATTACK7, BOTH_SPINATTACK6, BOTH_SPINATTACK7, BOTH_FORCELONGLEAP_ATTACK, BOTH_VS_ATR_S, BOTH_VS_ATL_S, BOTH_VT_ATR_S, BOTH_VT_ATL_S, BOTH_A7_KICK_F, BOTH_A7_KICK_B, BOTH_A7_KICK_R, BOTH_A7_KICK_L, BOTH_A7_KICK_S, BOTH_A7_KICK_BF, BOTH_A7_KICK_RL, BOTH_A7_KICK_F_AIR, BOTH_A7_KICK_B_AIR, BOTH_A7_KICK_R_AIR, BOTH_A7_KICK_L_AIR, BOTH_STABDOWN, BOTH_STABDOWN_STAFF, BOTH_STABDOWN_DUAL, BOTH_A6_SABERPROTECT, BOTH_A7_SOULCAL, BOTH_A1_SPECIAL, BOTH_A2_SPECIAL, BOTH_A3_SPECIAL, BOTH_FLIP_ATTACK7, BOTH_PULL_IMPALE_STAB, BOTH_PULL_IMPALE_SWING, BOTH_ALORA_SPIN_SLASH, BOTH_A6_FB, BOTH_A6_LR, BOTH_A7_HILT:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:645
func BG_KickingAnim(_ anim: Int32) -> Bool {
    switch anim {
    //NOT kicks, but do kick traces anyway
    case BOTH_A7_KICK_F, BOTH_A7_KICK_B, BOTH_A7_KICK_R, BOTH_A7_KICK_L, BOTH_A7_KICK_S, BOTH_A7_KICK_BF, BOTH_A7_KICK_RL, BOTH_A7_KICK_F_AIR, BOTH_A7_KICK_B_AIR, BOTH_A7_KICK_R_AIR, BOTH_A7_KICK_L_AIR, BOTH_A7_HILT, BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:672
func BG_InGrappleMove(_ anim: Int32) -> Int32 {
    switch anim {
    case BOTH_KYLE_GRAB, BOTH_KYLE_MISS:
        return 1 //grabbing at someone

    case BOTH_KYLE_PA_1, BOTH_KYLE_PA_2:
        return 2 //beating the shit out of someone

    case BOTH_PLAYER_PA_1, BOTH_PLAYER_PA_2, BOTH_PLAYER_PA_FLY:
        return 3 //getting the shit beaten out of you

    default:
        break
    }

    return 0
}

/// Source: oracle/codemp/game/bg_panimate.c:692
func BG_BrokenParryForAttack(_ move: Int32) -> Int32 {
    //Our attack was knocked away by a knockaway parry
    //FIXME: need actual anims for this
    //FIXME: need to know which side of the saber was hit!  For now, we presume the saber gets knocked away from the center
    switch saberMoveData[move].startQuad {
    case Q_B:
        return LS_V1_B_

    case Q_BR:
        return LS_V1_BR

    case Q_R:
        return LS_V1__R

    case Q_TR:
        return LS_V1_TR

    case Q_T:
        return LS_V1_T_

    case Q_TL:
        return LS_V1_TL

    case Q_L:
        return LS_V1__L

    case Q_BL:
        return LS_V1_BL

    default:
        break
    }
    return LS_NONE
}

/// Source: oracle/codemp/game/bg_panimate.c:727
func BG_BrokenParryForParry(_ move: Int32) -> Int32 {
    //FIXME: need actual anims for this
    //FIXME: need to know which side of the saber was hit!  For now, we presume the saber gets knocked away from the center
    switch move {
    case LS_PARRY_UP:
        //Hmm... since we don't know what dir the hit came from, randomly pick knock down or knock back
        if Q_irand(0, 1) != 0 {
            return LS_H1_B_
        } else {
            return LS_H1_T_
        }

    case LS_PARRY_UR:
        return LS_H1_TR

    case LS_PARRY_UL:
        return LS_H1_TL

    case LS_PARRY_LR:
        return LS_H1_BR

    case LS_PARRY_LL:
        return LS_H1_BL

    case LS_READY:
        return LS_H1_B_ //???

    default:
        break
    }
    return LS_NONE
}

/// Source: oracle/codemp/game/bg_panimate.c:763
func BG_KnockawayForParry(_ move: Int32) -> Int32 {
    //FIXME: need actual anims for this
    //FIXME: need to know which side of the saber was hit!  For now, we presume the saber gets knocked away from the center
    switch move {
    case BLOCKED_TOP:
        return LS_K1_T_ //push up

    case BLOCKED_UPPER_LEFT:
        return LS_K1_TL //push up and to left

    case BLOCKED_LOWER_RIGHT:
        return LS_K1_BR //push down and to left

    case BLOCKED_LOWER_LEFT:
        return LS_K1_BL //push down and to right

    default:
        return LS_K1_TR //push up, slightly to right
    }
    //return LS_NONE;
}

/// Source: oracle/codemp/game/bg_panimate.c:789
func BG_InRoll(_ ps: JKAMP.PlayerState, _ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_BROLL_L, BOTH_GETUP_BROLL_R, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F, BOTH_GETUP_FROLL_L, BOTH_GETUP_FROLL_R, BOTH_ROLL_F, BOTH_ROLL_B, BOTH_ROLL_R, BOTH_ROLL_L:
        if ps.legsTimer > 0 {
            return true
        }

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:814
func BG_InSpecialDeathAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_DEATH_ROLL, BOTH_DEATH_FLIP, BOTH_DEATH_SPIN_90_R, BOTH_DEATH_SPIN_90_L, BOTH_DEATH_SPIN_180, BOTH_DEATH_LYING_UP, BOTH_DEATH_LYING_DN, BOTH_DEATH_FALLING_DN, BOTH_DEATH_FALLING_UP, BOTH_DEATH_CROUCHED:
        return true

    default:
        return false
    }
}

/// Source: oracle/codemp/game/bg_panimate.c:836
func BG_InDeathAnim(_ anim: Int32) -> Bool {
    //Purposely does not cover stumbledeath and falldeath...
    switch anim {
    //# #sep case BOTH_ DEAD POSES # Should be last frame of corresponding previous anims
    //# #sep case BOTH_ DEAD TWITCH/FLOP # React to being shot from death poses
    case BOTH_DEATH1, BOTH_DEATH2, BOTH_DEATH3, BOTH_DEATH4, BOTH_DEATH5, BOTH_DEATH6, BOTH_DEATH7, BOTH_DEATH8, BOTH_DEATH9, BOTH_DEATH10, BOTH_DEATH11, BOTH_DEATH12, BOTH_DEATH13, BOTH_DEATH14, BOTH_DEATH14_UNGRIP, BOTH_DEATH14_SITUP, BOTH_DEATH15, BOTH_DEATH16, BOTH_DEATH17, BOTH_DEATH18, BOTH_DEATH19, BOTH_DEATH20, BOTH_DEATH21, BOTH_DEATH22, BOTH_DEATH23, BOTH_DEATH24, BOTH_DEATH25, BOTH_DEATHFORWARD1, BOTH_DEATHFORWARD2, BOTH_DEATHFORWARD3, BOTH_DEATHBACKWARD1, BOTH_DEATHBACKWARD2, BOTH_DEATH1IDLE, BOTH_LYINGDEATH1, BOTH_STUMBLEDEATH1, BOTH_FALLDEATH1, BOTH_FALLDEATH1INAIR, BOTH_FALLDEATH1LAND, BOTH_DEAD1, BOTH_DEAD2, BOTH_DEAD3, BOTH_DEAD4, BOTH_DEAD5, BOTH_DEAD6, BOTH_DEAD7, BOTH_DEAD8, BOTH_DEAD9, BOTH_DEAD10, BOTH_DEAD11, BOTH_DEAD12, BOTH_DEAD13, BOTH_DEAD14, BOTH_DEAD15, BOTH_DEAD16, BOTH_DEAD17, BOTH_DEAD18, BOTH_DEAD19, BOTH_DEAD20, BOTH_DEAD21, BOTH_DEAD22, BOTH_DEAD23, BOTH_DEAD24, BOTH_DEAD25, BOTH_DEADFORWARD1, BOTH_DEADFORWARD2, BOTH_DEADBACKWARD1, BOTH_DEADBACKWARD2, BOTH_LYINGDEAD1, BOTH_STUMBLEDEAD1, BOTH_FALLDEAD1LAND, BOTH_DEADFLOP1, BOTH_DEADFLOP2, BOTH_DISMEMBER_HEAD1, BOTH_DISMEMBER_TORSO1, BOTH_DISMEMBER_LLEG, BOTH_DISMEMBER_RLEG, BOTH_DISMEMBER_RARM, BOTH_DISMEMBER_LARM:
        return true

    default:
        return BG_InSpecialDeathAnim(anim)
    }
}

/// Source: oracle/codemp/game/bg_panimate.c:930
func BG_InKnockDownOnly(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_KNOCKDOWN1, BOTH_KNOCKDOWN2, BOTH_KNOCKDOWN3, BOTH_KNOCKDOWN4, BOTH_KNOCKDOWN5:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:944
func BG_InSaberLockOld(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_BF2LOCK, BOTH_BF1LOCK, BOTH_CWCIRCLELOCK, BOTH_CCWCIRCLELOCK:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:957
func BG_InSaberLock(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_LK_S_DL_S_L_1, BOTH_LK_S_DL_T_L_1, BOTH_LK_S_ST_S_L_1, BOTH_LK_S_ST_T_L_1, BOTH_LK_S_S_S_L_1, BOTH_LK_S_S_T_L_1, BOTH_LK_DL_DL_S_L_1, BOTH_LK_DL_DL_T_L_1, BOTH_LK_DL_ST_S_L_1, BOTH_LK_DL_ST_T_L_1, BOTH_LK_DL_S_S_L_1, BOTH_LK_DL_S_T_L_1, BOTH_LK_ST_DL_S_L_1, BOTH_LK_ST_DL_T_L_1, BOTH_LK_ST_ST_S_L_1, BOTH_LK_ST_ST_T_L_1, BOTH_LK_ST_S_S_L_1, BOTH_LK_ST_S_T_L_1, BOTH_LK_S_S_S_L_2, BOTH_LK_S_S_T_L_2, BOTH_LK_DL_DL_S_L_2, BOTH_LK_DL_DL_T_L_2, BOTH_LK_ST_ST_S_L_2, BOTH_LK_ST_ST_T_L_2:
        return true

    default:
        return BG_InSaberLockOld(anim)
    }
    //return qfalse;
}

//Called only where pm is valid (not all require pm, but some do):

//Called only where pm is valid (not all require pm, but some do):
/// Source: oracle/codemp/game/bg_panimate.c:995
func PM_InCartwheel(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_ARIAL_LEFT, BOTH_ARIAL_RIGHT, BOTH_ARIAL_F1, BOTH_CARTWHEEL_LEFT, BOTH_CARTWHEEL_RIGHT:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1010
func BG_InKnockDownOnGround(_ ps: JKAMP.PlayerState) -> Bool {
    switch ps.legsAnim {
    case BOTH_KNOCKDOWN1, BOTH_KNOCKDOWN2, BOTH_KNOCKDOWN3, BOTH_KNOCKDOWN4, BOTH_KNOCKDOWN5, BOTH_RELEASED:
        //if ( PM_AnimLength( g_entities[ps->clientNum].client->clientInfo.animFileIndex, (animNumber_t)ps->legsAnim ) - ps->legsAnimTimer > 300 )
        do {
            //at end of fall down anim
            return true
        }

    case BOTH_GETUP1, BOTH_GETUP2, BOTH_GETUP3, BOTH_GETUP4, BOTH_GETUP5, BOTH_GETUP_CROUCH_F1, BOTH_GETUP_CROUCH_B1, BOTH_FORCE_GETUP_F1, BOTH_FORCE_GETUP_F2, BOTH_FORCE_GETUP_B1, BOTH_FORCE_GETUP_B2, BOTH_FORCE_GETUP_B3, BOTH_FORCE_GETUP_B4, BOTH_FORCE_GETUP_B5, BOTH_FORCE_GETUP_B6:
        if BG_AnimLength(0, animNumber_t(ps.legsAnim)) - ps.legsTimer < 500 {
            //at beginning of getup anim
            return true
        }

    case BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_BROLL_L, BOTH_GETUP_BROLL_R, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F, BOTH_GETUP_FROLL_L, BOTH_GETUP_FROLL_R:
        if BG_AnimLength(0, animNumber_t(ps.legsAnim)) - ps.legsTimer < 500 {
            //at beginning of getup anim
            return true
        }

    case BOTH_LK_DL_ST_T_SB_1_L:
        if ps.legsTimer < 1000 {
            return true
        }

    case BOTH_PLAYER_PA_3_FLY:
        if ps.legsTimer < 300 {
            return true
        }

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1074
func BG_StabDownAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_STABDOWN, BOTH_STABDOWN_STAFF, BOTH_STABDOWN_DUAL:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1086
func PM_SaberBounceForAttack(_ move: Int32) -> Int32 {
    switch saberMoveData[move].startQuad {
    case Q_B, Q_BR:
        return LS_B1_BR

    case Q_R:
        return LS_B1__R

    case Q_TR:
        return LS_B1_TR

    case Q_T:
        return LS_B1_T_

    case Q_TL:
        return LS_B1_TL

    case Q_L:
        return LS_B1__L

    case Q_BL:
        return LS_B1_BL

    default:
        break
    }
    return LS_NONE
}

/// Source: oracle/codemp/game/bg_panimate.c:1116
func PM_SaberDeflectionForQuad(_ quad: Int32) -> Int32 {
    switch quad {
    case Q_B:
        return LS_D1_B_

    case Q_BR:
        return LS_D1_BR

    case Q_R:
        return LS_D1__R

    case Q_TR:
        return LS_D1_TR

    case Q_T:
        return LS_D1_T_

    case Q_TL:
        return LS_D1_TL

    case Q_L:
        return LS_D1__L

    case Q_BL:
        return LS_D1_BL

    default:
        break
    }
    return LS_NONE
}

/// Source: oracle/codemp/game/bg_panimate.c:1148
func PM_SaberInDeflect(_ move: Int32) -> Bool {
    if move >= LS_D1_BR && move <= LS_D1_B_ {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1157
func PM_SaberInParry(_ move: Int32) -> Bool {
    if move >= LS_PARRY_UP && move <= LS_PARRY_LL {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1166
func PM_SaberInKnockaway(_ move: Int32) -> Bool {
    if move >= LS_K1_T_ && move <= LS_K1_BL {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1175
func PM_SaberInReflect(_ move: Int32) -> Bool {
    if move >= LS_REFLECT_UP && move <= LS_REFLECT_LL {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1184
func PM_SaberInStart(_ move: Int32) -> Bool {
    if move >= LS_S_TL2BR && move <= LS_S_T2B {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1193
func PM_SaberInReturn(_ move: Int32) -> Bool {
    if move >= LS_R_TL2BR && move <= LS_R_T2B {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1202
func BG_SaberInReturn(_ move: Int32) -> Bool {
    return PM_SaberInReturn(move)
}

/// Source: oracle/codemp/game/bg_panimate.c:1207
func PM_InSaberAnim(_ anim: Int32) -> Bool {
    if (anim) >= BOTH_A1_T__B_ && (anim) <= BOTH_H1_S1_BR {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1216
func PM_InKnockDown(_ ps: JKAMP.PlayerState) -> Bool {
    switch (ps.legsAnim) {
    case BOTH_KNOCKDOWN1, BOTH_KNOCKDOWN2, BOTH_KNOCKDOWN3, BOTH_KNOCKDOWN4, BOTH_KNOCKDOWN5:
        return true

    case BOTH_GETUP1, BOTH_GETUP2, BOTH_GETUP3, BOTH_GETUP4, BOTH_GETUP5, BOTH_FORCE_GETUP_F1, BOTH_FORCE_GETUP_F2, BOTH_FORCE_GETUP_B1, BOTH_FORCE_GETUP_B2, BOTH_FORCE_GETUP_B3, BOTH_FORCE_GETUP_B4, BOTH_FORCE_GETUP_B5, BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_BROLL_L, BOTH_GETUP_BROLL_R, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F, BOTH_GETUP_FROLL_L, BOTH_GETUP_FROLL_R:
        if ps.legsTimer != 0 {
            return true
        }

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1256
func PM_PainAnim(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_PAIN1, BOTH_PAIN2, BOTH_PAIN3, BOTH_PAIN4, BOTH_PAIN5, BOTH_PAIN6, BOTH_PAIN7, BOTH_PAIN8, BOTH_PAIN9, BOTH_PAIN10, BOTH_PAIN11, BOTH_PAIN12, BOTH_PAIN13, BOTH_PAIN14, BOTH_PAIN15, BOTH_PAIN16, BOTH_PAIN17, BOTH_PAIN18:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1284
func PM_JumpingAnim(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_JUMP1, BOTH_INAIR1, BOTH_LAND1, BOTH_LAND2, BOTH_JUMPBACK1, BOTH_INAIRBACK1, BOTH_LANDBACK1, BOTH_JUMPLEFT1, BOTH_INAIRLEFT1, BOTH_LANDLEFT1, BOTH_JUMPRIGHT1, BOTH_INAIRRIGHT1, BOTH_LANDRIGHT1, BOTH_FORCEJUMP1, BOTH_FORCEINAIR1, BOTH_FORCELAND1, BOTH_FORCEJUMPBACK1, BOTH_FORCEINAIRBACK1, BOTH_FORCELANDBACK1, BOTH_FORCEJUMPLEFT1, BOTH_FORCEINAIRLEFT1, BOTH_FORCELANDLEFT1, BOTH_FORCEJUMPRIGHT1, BOTH_FORCEINAIRRIGHT1, BOTH_FORCELANDRIGHT1:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1319
func PM_LandingAnim(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_LAND1, BOTH_LAND2, BOTH_LANDBACK1, BOTH_LANDLEFT1, BOTH_LANDRIGHT1, BOTH_FORCELAND1, BOTH_FORCELANDBACK1, BOTH_FORCELANDLEFT1, BOTH_FORCELANDRIGHT1:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1338
func PM_SpinningAnim(_ anim: Int32) -> Bool {
    /*
    switch ( anim )
    {
    //FIXME: list any other spinning anims
    default:
    break;
    }
    */
    return BG_SpinningSaberAnim(anim)
}

/// Source: oracle/codemp/game/bg_panimate.c:1351
func PM_InOnGroundAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_DEAD1, BOTH_DEAD2, BOTH_DEAD3, BOTH_DEAD4, BOTH_DEAD5, BOTH_DEADFORWARD1, BOTH_DEADBACKWARD1, BOTH_DEADFORWARD2, BOTH_DEADBACKWARD2, BOTH_LYINGDEATH1, BOTH_LYINGDEAD1, BOTH_SLEEP1, BOTH_KNOCKDOWN1, BOTH_KNOCKDOWN2, BOTH_KNOCKDOWN3, BOTH_KNOCKDOWN4, BOTH_KNOCKDOWN5, BOTH_GETUP1, BOTH_GETUP2, BOTH_GETUP3, BOTH_GETUP4, BOTH_GETUP5, BOTH_GETUP_CROUCH_F1, BOTH_GETUP_CROUCH_B1, BOTH_FORCE_GETUP_F1, BOTH_FORCE_GETUP_F2, BOTH_FORCE_GETUP_B1, BOTH_FORCE_GETUP_B2, BOTH_FORCE_GETUP_B3, BOTH_FORCE_GETUP_B4, BOTH_FORCE_GETUP_B5, BOTH_FORCE_GETUP_B6, BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_BROLL_L, BOTH_GETUP_BROLL_R, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F, BOTH_GETUP_FROLL_L, BOTH_GETUP_FROLL_R:
        return true

    default:
        break
    }

    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1402
func PM_InRollComplete(_ ps: JKAMP.PlayerState, _ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_ROLL_F, BOTH_ROLL_B, BOTH_ROLL_R, BOTH_ROLL_L:
        if ps.legsTimer < 1 {
            return true
        }

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1419
func PM_CanRollFromSoulCal(_ ps: JKAMP.PlayerState) -> Bool {
    if ps.legsAnim == BOTH_A7_SOULCAL && ps.legsTimer < 700 && ps.legsTimer > 250 {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1430
func BG_SuperBreakLoseAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_LK_S_DL_S_SB_1_L, BOTH_LK_S_DL_T_SB_1_L, BOTH_LK_S_ST_S_SB_1_L, BOTH_LK_S_ST_T_SB_1_L, BOTH_LK_S_S_S_SB_1_L, BOTH_LK_S_S_T_SB_1_L, BOTH_LK_DL_DL_S_SB_1_L, BOTH_LK_DL_DL_T_SB_1_L, BOTH_LK_DL_ST_S_SB_1_L, BOTH_LK_DL_ST_T_SB_1_L, BOTH_LK_DL_S_S_SB_1_L, BOTH_LK_DL_S_T_SB_1_L, BOTH_LK_ST_DL_S_SB_1_L, BOTH_LK_ST_DL_T_SB_1_L, BOTH_LK_ST_ST_S_SB_1_L, BOTH_LK_ST_ST_T_SB_1_L, BOTH_LK_ST_S_S_SB_1_L, BOTH_LK_ST_S_T_SB_1_L:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1458
func BG_SuperBreakWinAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_LK_S_DL_S_SB_1_W, BOTH_LK_S_DL_T_SB_1_W, BOTH_LK_S_ST_S_SB_1_W, BOTH_LK_S_ST_T_SB_1_W, BOTH_LK_S_S_S_SB_1_W, BOTH_LK_S_S_T_SB_1_W, BOTH_LK_DL_DL_S_SB_1_W, BOTH_LK_DL_DL_T_SB_1_W, BOTH_LK_DL_ST_S_SB_1_W, BOTH_LK_DL_ST_T_SB_1_W, BOTH_LK_DL_S_S_SB_1_W, BOTH_LK_DL_S_T_SB_1_W, BOTH_LK_ST_DL_S_SB_1_W, BOTH_LK_ST_DL_T_SB_1_W, BOTH_LK_ST_ST_S_SB_1_W, BOTH_LK_ST_ST_T_SB_1_W, BOTH_LK_ST_S_S_SB_1_W, BOTH_LK_ST_S_T_SB_1_W:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1487
func BG_SaberLockBreakAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_BF1BREAK, BOTH_BF2BREAK, BOTH_CWCIRCLEBREAK, BOTH_CCWCIRCLEBREAK, BOTH_LK_S_DL_S_B_1_L, BOTH_LK_S_DL_S_B_1_W, BOTH_LK_S_DL_T_B_1_L, BOTH_LK_S_DL_T_B_1_W, BOTH_LK_S_ST_S_B_1_L, BOTH_LK_S_ST_S_B_1_W, BOTH_LK_S_ST_T_B_1_L, BOTH_LK_S_ST_T_B_1_W, BOTH_LK_S_S_S_B_1_L, BOTH_LK_S_S_S_B_1_W, BOTH_LK_S_S_T_B_1_L, BOTH_LK_S_S_T_B_1_W, BOTH_LK_DL_DL_S_B_1_L, BOTH_LK_DL_DL_S_B_1_W, BOTH_LK_DL_DL_T_B_1_L, BOTH_LK_DL_DL_T_B_1_W, BOTH_LK_DL_ST_S_B_1_L, BOTH_LK_DL_ST_S_B_1_W, BOTH_LK_DL_ST_T_B_1_L, BOTH_LK_DL_ST_T_B_1_W, BOTH_LK_DL_S_S_B_1_L, BOTH_LK_DL_S_S_B_1_W, BOTH_LK_DL_S_T_B_1_L, BOTH_LK_DL_S_T_B_1_W, BOTH_LK_ST_DL_S_B_1_L, BOTH_LK_ST_DL_S_B_1_W, BOTH_LK_ST_DL_T_B_1_L, BOTH_LK_ST_DL_T_B_1_W, BOTH_LK_ST_ST_S_B_1_L, BOTH_LK_ST_ST_S_B_1_W, BOTH_LK_ST_ST_T_B_1_L, BOTH_LK_ST_ST_T_B_1_W, BOTH_LK_ST_S_S_B_1_L, BOTH_LK_ST_S_S_B_1_W, BOTH_LK_ST_S_T_B_1_L, BOTH_LK_ST_S_T_B_1_W:
        return true

    default:
        break
    }
    return (BG_SuperBreakLoseAnim(anim) || BG_SuperBreakWinAnim(anim))
}

/// Source: oracle/codemp/game/bg_panimate.c:1538
func BG_FullBodyTauntAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_GESTURE1, BOTH_DUAL_TAUNT, BOTH_STAFF_TAUNT, BOTH_BOW, BOTH_MEDITATE, BOTH_SHOWOFF_FAST, BOTH_SHOWOFF_MEDIUM, BOTH_SHOWOFF_STRONG, BOTH_SHOWOFF_DUAL, BOTH_SHOWOFF_STAFF, BOTH_VICTORY_FAST, BOTH_VICTORY_MEDIUM, BOTH_VICTORY_STRONG, BOTH_VICTORY_DUAL, BOTH_VICTORY_STAFF:
        return true

    default:
        break
    }
    return false
}

/**
```
=============
BG_AnimLength

Get the "length" of an anim given the local anim index (which skeleton)
and anim number. Obviously does not take things like the length of the
anim while force speeding (as an example) and whatnot into account.
=============
```
*/

/**
```
=============
BG_AnimLength

Get the "length" of an anim given the local anim index (which skeleton)
and anim number. Obviously does not take things like the length of the
anim while force speeding (as an example) and whatnot into account.
=============
```
*/
/// Source: oracle/codemp/game/bg_panimate.c:1573
func BG_AnimLength(_ index: Int32, _ anim: JKAMP.animNumber_t) -> Int32 {
    if anim >= MAX_ANIMATIONS {
        return -1
    }

    return Int32(bgAllAnims[index].animsSlots[anim].numFrames * abs(Float((bgAllAnims[index].animsSlots[anim].frameLerp))))
}

//just use whatever pm->animations is

//just use whatever pm->animations is
/// Source: oracle/codemp/game/bg_panimate.c:1584
func PM_AnimLength(_ index: Int32, _ anim: JKAMP.animNumber_t) -> Int32 {
    if anim >= MAX_ANIMATIONS || pm.animations == nil {
        return -1
    }
    if anim < 0 {
        Com_Error(ERR_DROP, "ERROR: anim %d < 0\n", anim)
    }
    return Int32(pm.animationsSlots[anim].numFrames * abs(Float((pm.animationsSlots[anim].frameLerp))))
}

/// Source: oracle/codemp/game/bg_panimate.c:1597
func PM_DebugLegsAnim(_ anim: Int32) {
    let oldAnim: Int32 = (pm.ps.legsAnim)
    let newAnim: Int32 = (anim)

    if oldAnim < MAX_TOTALANIMATIONS && oldAnim >= BOTH_DEATH1 && newAnim < MAX_TOTALANIMATIONS && newAnim >= BOTH_DEATH1 {
        // Port-note: Raven passes the record's address to a `%s`, and the format reads the text at that address.
        // Those bytes are the record's first field, and the port names that field.
        Com_Printf("OLD: %s\n", animTable[oldAnim].name!)
        // Port-note: Raven passes the record's address to a `%s`, and the format reads the text at that address.
        // Those bytes are the record's first field, and the port names that field.
        Com_Printf("NEW: %s\n", animTable[newAnim].name!)
    }
}

/// Source: oracle/codemp/game/bg_panimate.c:1610
func PM_SaberInTransition(_ move: Int32) -> Bool {
    if move >= LS_T1_BR__R && move <= LS_T1_BL__L {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1619
func BG_SaberInTransitionAny(_ move: Int32) -> Bool {
    if PM_SaberInStart(move) {
        return true
    } else if PM_SaberInTransition(move) {
        return true
    } else if PM_SaberInReturn(move) {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_panimate.c:1642
func BG_FlipPart(_ ps: JKAMP.PlayerState, _ part: Int32) {
    if part == SETANIM_TORSO {
        if ps.torsoFlip {
            ps.torsoFlip = false
        } else {
            ps.torsoFlip = true
        }
    } else if part == SETANIM_LEGS {
        if ps.legsFlip {
            ps.legsFlip = false
        } else {
            ps.legsFlip = true
        }
    }
}

//ALWAYS call on game/cgame init

//ALWAYS call on game/cgame init
/// Source: oracle/codemp/game/bg_panimate.c:1706
func BG_InitAnimsets() {
    bgAllAnims.zero()
    BGPAFtextLoaded = false // VVFIXME - The PC doesn't seem to need this, but why?
}

//ALWAYS call on game/cgame shutdown

//ALWAYS call on game/cgame shutdown
/// Source: oracle/codemp/game/bg_panimate.c:1713
func BG_ClearAnimsets() {
    /*
    int i = 1;

    while (i < bgNumAllAnims)
    {
    if (bgAllAnims[i].anims)
    {
    strap_TrueFree((void **)&bgAllAnims[i].anims);
    }
    i++;
    }
    */
}

/// Source: oracle/codemp/game/bg_panimate.c:1729
func BG_AnimsetAlloc() -> JKAMP.Animation? {
    bgAllAnims[bgNumAllAnims].anims = Animation(BG_Alloc(Int32(Animation.byteCount) * MAX_TOTALANIMATIONS))

    return bgAllAnims[bgNumAllAnims].anims
}

/// Source: oracle/codemp/game/bg_panimate.c:1737
func BG_AnimsetFree(_ animset: Slots<JKAMP.Animation>) {
    /*
    if (!animset)
    {
    return;
    }

    strap_TrueFree((void **)&animset);

    #ifdef _DEBUG
    if (animset)
    {
    assert(!"Failed to free anim set");
    }
    #endif
    */
}

/**
```
======================
BG_ParseAnimationFile

Read a configuration file containing animation coutns and rates
models/players/visor/animation.cfg, etc

======================
```
*/

/**
```
======================
BG_ParseAnimationFile

Read a configuration file containing animation coutns and rates
models/players/visor/animation.cfg, etc

======================
```
*/
/// Source: oracle/codemp/game/bg_panimate.c:2339
func BG_ParseAnimationFile(_ filename: String, _ animset: Slots<JKAMP.Animation>?, _ isHumanoid: Bool) -> Int32 {
    var text_p = TextCursor()
    let len: Int32
    var i: Int32
    var token: String
    var fps: Float
    let skip: Int32
    var usedIndex: Int32 = -1
    var nextIndex: Int32 = bgNumAllAnims
    var dynAlloc: Bool = false
    var wasLoaded: Bool = false
    var BGPAFtext = CharBuf(60000)

    var f: fileHandle_t = 0
    var animNum: Int32
    // Raven assigns his own `animset` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var animset = animset

    if !isHumanoid {
        i = 0
        while i < bgNumAllAnims {
            //see if it's been loaded already
            if Q_stricmp(bgAllAnims[i].filename, filename) == 0 {
                animset = bgAllAnims[i].animsSlots
                return i //alright, we already have it.
            }
            i += 1
        }

        //Looks like it has not yet been loaded. Allocate space for the anim set if we need to, and continue along.
        if animset == nil {
            if strstr(filename, "players/_humanoid/") != nil {
                //then use the static humanoid set.
                animset = bgHumanoidAnimations
                nextIndex = 0
            } else if strstr(filename, "players/rockettrooper/") != nil {
                //rockettrooper always index 1
                nextIndex = 1
                animset = BG_AnimsetAlloc().map { Slots(record: $0) }
                dynAlloc = true //so we know to free this memory in case we have to return early. Don't want any leaks.

                if animset == nil {
                    return -1
                }
            } else {
                animset = BG_AnimsetAlloc().map { Slots(record: $0) }
                dynAlloc = true //so we know to free this memory in case we have to return early. Don't want any leaks.

                if animset == nil {
                    return -1
                }
            }
        }
    }

    // load the file
    if !BGPAFtextLoaded || !isHumanoid {
        //rww - We are always using the same animation config now. So only load it once.
        len = trap_FS_FOpenFile(filename, &f, FS_READ)
        if (len <= 0) || (len >= Int32((BGPAFtext).count) - 1) {
            if dynAlloc {
                BG_AnimsetFree(animset!)
            }
            if len > 0 {
                Com_Error(ERR_DROP, "%s exceeds the allowed game-side animation buffer!", filename)
            }
            return -1
        }

        trap_FS_Read(&BGPAFtext, len, f)
        BGPAFtext[len] = 0
        trap_FS_FCloseFile(f)
    } else {
        if dynAlloc {
            BG_AnimsetFree(animset!)
        }
        return 0 //humanoid index
    }

    // parse the text
    text_p = TextCursor(BGPAFtext)
    skip = 0 // quiet the compiler warning

    //FIXME: have some way of playing anims backwards... negative numFrames?

    //initialize anim array so that from 0 to MAX_ANIMATIONS, set default values of 0 1 0 100
    i = 0
    while i < MAX_ANIMATIONS {
        animset![i].firstFrame = 0
        animset![i].numFrames = 0
        animset![i].loopFrames = -1
        animset![i].frameLerp = 100
        i += 1
    }

    // read information for each frame
    while 1 != 0 {
        token = COM_Parse(&text_p)

        // Raven's NULL test on token has no form here, and the arm it guards is gone.
        if token.isEmpty {
            break
        }

        animNum = GetIDForString(animTable, token)
        if animNum == -1 {
            //#ifndef FINAL_BUILD
            continue
        }

        token = COM_Parse(&text_p)
        // Raven's NULL test on token has no form here, and the arm it guards is gone.
        // Raven's arm under the guard has no path, and its text stays here:
        // {
        //             break;
        //         }
        animset![animNum].firstFrame = atoi(token)

        token = COM_Parse(&text_p)
        // Raven's NULL test on token has no form here, and the arm it guards is gone.
        // Raven's arm under the guard has no path, and its text stays here:
        // {
        //             break;
        //         }
        animset![animNum].numFrames = atoi(token)

        token = COM_Parse(&text_p)
        // Raven's NULL test on token has no form here, and the arm it guards is gone.
        // Raven's arm under the guard has no path, and its text stays here:
        // {
        //             break;
        //         }
        animset![animNum].loopFrames = atoi(token)

        token = COM_Parse(&text_p)
        // Raven's NULL test on token has no form here, and the arm it guards is gone.
        // Raven's arm under the guard has no path, and its text stays here:
        // {
        //             break;
        //         }
        fps = atof(token)
        if fps == 0 {
            fps = 1 //Don't allow divide by zero error
        }
        if fps < 0 {
            //backwards
            animset![animNum].frameLerp = Int32(floor(1000.0 / fps))
        } else {
            animset![animNum].frameLerp = Int32(ceil(1000.0 / fps))
        }
    }
    /*
    #ifdef _DEBUG
    //Check the array, and print the ones that have nothing in them.
    for(i = 0; i < MAX_ANIMATIONS; i++)
    {
    if (animTable[i].name != NULL)		// This animation reference exists.
    {
    if (animset[i].firstFrame <= 0 && animset[i].numFrames <=0)
    {	// This is an empty animation reference.
    Com_Printf("***ANIMTABLE reference #%d (%s) is empty!\n", i, animTable[i].name);
    }
    }
    }
    #endif // _DEBUG
    */

    wasLoaded = BGPAFtextLoaded

    if isHumanoid {
        bgAllAnims[0].animsSlots = animset!
        strcpy(&bgAllAnims[0].filenameBuffer, filename)
        BGPAFtextLoaded = true

        usedIndex = 0
    } else {
        bgAllAnims[nextIndex].animsSlots = animset!
        strcpy(&bgAllAnims[nextIndex].filenameBuffer, filename)

        usedIndex = bgNumAllAnims

        if nextIndex > 1 {
            //don't bother increasing the number if this ended up as a humanoid/rockettrooper load.
            bgNumAllAnims += 1
        } else {
            BGPAFtextLoaded = true
            usedIndex = nextIndex
        }
    }

    /*
    if (!wasLoaded && BGPAFtextLoaded)
    { //just loaded humanoid skel - we always want the rockettrooper to be after it, in slot 1
    #ifdef _DEBUG
    assert(BG_ParseAnimationFile("models/players/rockettrooper/animation.cfg", NULL, qfalse) == 1);
    #else
    BG_ParseAnimationFile("models/players/rockettrooper/animation.cfg", NULL, qfalse);
    #endif
    }
    */

    return usedIndex
}

/**
```
===================
LEGS Animations
Base animation for overall body
===================
```
*/

/**
```
===================
LEGS Animations
Base animation for overall body
===================
```
*/
/// Source: oracle/codemp/game/bg_panimate.c:2588
private func BG_StartLegsAnim(_ ps: JKAMP.PlayerState, _ anim: Int32) {
    if ps.pm_type >= PM_DEAD {
        //please let me know if this assert fires on you (ideally before you close/ignore it) -rww

        //vehicles are allowed to do this.. IF it's a vehicle death anim
        if ps.clientNum < MAX_CLIENTS || anim != BOTH_VT_DEATH1 {
            return
        }
    }
    if ps.legsTimer > 0 {
        return // a high priority animation is running
    }

    if ps.legsAnim == anim {
        BG_FlipPart(ps, SETANIM_LEGS)
    } else if bgEntityLegsAnim(of: ps.clientNum) == anim {
        //toggled anim to one anim then back to the one we were at previously in
        //one frame, indicating that anim should be restarted.
        BG_FlipPart(ps, SETANIM_LEGS)
    }
    ps.legsAnim = anim

    /*
    if ( pm->debugLevel ) {
    Com_Printf("%d:  StartLegsAnim %d, on client#%d\n", pm->cmd.serverTime, anim, pm->ps->clientNum);
    }
    */
}

/// Source: oracle/codemp/game/bg_panimate.c:2626
func PM_ContinueLegsAnim(_ anim: Int32) {
    if (pm.ps.legsAnim) == anim {
        return
    }
    if pm.ps.legsTimer > 0 {
        return // a high priority animation is running
    }

    BG_StartLegsAnim(pm.ps, anim)
}

/// Source: oracle/codemp/game/bg_panimate.c:2637
func PM_ForceLegsAnim(_ anim: Int32) {
    if BG_InSpecialJump(pm.ps.legsAnim) && pm.ps.legsTimer > 0 && !BG_InSpecialJump(anim) {
        return
    }

    if BG_InRoll(pm.ps, pm.ps.legsAnim) && pm.ps.legsTimer > 0 && !BG_InRoll(pm.ps, anim) {
        return
    }

    pm.ps.legsTimer = 0
    BG_StartLegsAnim(pm.ps, anim)
}

/**
```
===================
TORSO Animations
Override animations for upper body
===================
```
*/

/**
```
===================
TORSO Animations
Override animations for upper body
===================
```
*/
/// Source: oracle/codemp/game/bg_panimate.c:2664
func BG_StartTorsoAnim(_ ps: JKAMP.PlayerState, _ anim: Int32) {
    if ps.pm_type >= PM_DEAD {
        //please let me know if this assert fires on you (ideally before you close/ignore it) -rww
        return
    }

    if ps.torsoAnim == anim {
        BG_FlipPart(ps, SETANIM_TORSO)
    } else if bgEntityTorsoAnim(of: ps.clientNum) == anim {
        //toggled anim to one anim then back to the one we were at previously in
        //one frame, indicating that anim should be restarted.
        BG_FlipPart(ps, SETANIM_TORSO)
    }
    ps.torsoAnim = anim
}

/// Source: oracle/codemp/game/bg_panimate.c:2687
func PM_StartTorsoAnim(_ anim: Int32) {
    BG_StartTorsoAnim(pm.ps, anim)
}

/**
```
-------------------------
PM_SetLegsAnimTimer
-------------------------
```
*/

/**
```
-------------------------
PM_SetLegsAnimTimer
-------------------------
```
*/
/// Source: oracle/codemp/game/bg_panimate.c:2698
func BG_SetLegsAnimTimer(_ ps: JKAMP.PlayerState, _ time: Int32) {
    ps.legsTimer = time

    if ps.legsTimer < 0 && time != -1 {
        //Cap timer to 0 if was counting down, but let it be -1 if that was intentional.  NOTENOTE Yeah this seems dumb, but it mirrors SP.
        ps.legsTimer = 0
    }
}

/// Source: oracle/codemp/game/bg_panimate.c:2708
func PM_SetLegsAnimTimer(_ time: Int32) {
    BG_SetLegsAnimTimer(pm.ps, time)
}

/**
```
-------------------------
PM_SetTorsoAnimTimer
-------------------------
```
*/

/**
```
-------------------------
PM_SetTorsoAnimTimer
-------------------------
```
*/
/// Source: oracle/codemp/game/bg_panimate.c:2718
func BG_SetTorsoAnimTimer(_ ps: JKAMP.PlayerState, _ time: Int32) {
    ps.torsoTimer = time

    if ps.torsoTimer < 0 && time != -1 {
        //Cap timer to 0 if was counting down, but let it be -1 if that was intentional.  NOTENOTE Yeah this seems dumb, but it mirrors SP.
        ps.torsoTimer = 0
    }
}

/// Source: oracle/codemp/game/bg_panimate.c:2728
func PM_SetTorsoAnimTimer(_ time: Int32) {
    BG_SetTorsoAnimTimer(pm.ps, time)
}

/// Source: oracle/codemp/game/bg_panimate.c:2733
func BG_SaberStartTransAnim(_ clientNum: Int32, _ saberAnimLevel: Int32, _ weapon: Int32, _ anim: Int32, _ animSpeed: inout Float, _ broken: Int32) {
    if anim >= BOTH_A1_T__B_ && anim <= BOTH_ROLL_STAB {
        if weapon == WP_SABER {
            var saber: SaberInfo? = BG_MySaber(clientNum, 0)
            if saber != nil && saber!.animSpeedScale != 1.0 {
                animSpeed *= saber!.animSpeedScale
            }
            saber = BG_MySaber(clientNum, 1)
            if saber != nil && saber!.animSpeedScale != 1.0 {
                animSpeed *= saber!.animSpeedScale
            }
        }
    }

    if ((anim) >= BOTH_T1_BR__R && (anim) <= BOTH_T1_BL_TL) || ((anim) >= BOTH_T2_BR__R && (anim) <= BOTH_T2_BL_TL) || ((anim) >= BOTH_T3_BR__R && (anim) <= BOTH_T3_BL_TL) {
        if saberAnimLevel == FORCE_LEVEL_1 {
            animSpeed *= 1.5
        } else if saberAnimLevel == FORCE_LEVEL_3 {
            animSpeed *= 0.75
        }

        if (broken & (1 << BROKENLIMB_RARM)) != 0 {
            animSpeed *= 0.5
        } else if (broken & (1 << BROKENLIMB_LARM)) != 0 {
            animSpeed *= 0.65
        }
    } else if broken != 0 && PM_InSaberAnim(anim) {
        if (broken & (1 << BROKENLIMB_RARM)) != 0 {
            animSpeed *= 0.5
        } else if (broken & (1 << BROKENLIMB_LARM)) != 0 {
            animSpeed *= 0.65
        }
    }
}

/// Source: oracle/codemp/game/bg_panimate.c:2800
func BG_SetAnimFinal(_ ps: JKAMP.PlayerState, _ animations: Slots<JKAMP.Animation>, _ setAnimParts: Int32, _ anim: Int32, _ setAnimFlags: Int32, _ blendTime: Int32) {
    var editAnimSpeed: Float = 1

    // Raven assigns his own `blendTime` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var blendTime = blendTime
    setAnimLegs: do {
        // Raven's NULL test on animations has no form here, and the arm it guards is gone.
        // Raven's arm under the guard has no path, and its text stays here:
        // {
        //         return;
        //     }


        //NOTE: Setting blendTime here breaks actual blending..
        blendTime = 0

        BG_SaberStartTransAnim(ps.clientNum, ps.fd.saberAnimLevel, ps.weapon, anim, &editAnimSpeed, ps.brokenLimbs)

        // Set torso anim
        if (setAnimParts & SETANIM_TORSO) != 0 {
            // Don't reset if it's already running the anim
            if !((setAnimFlags & SETANIM_FLAG_RESTART) != 0) && (ps.torsoAnim) == anim {
                break setAnimLegs
            }
            // or if a more important anim is running
            if !((setAnimFlags & SETANIM_FLAG_OVERRIDE) != 0) && ((ps.torsoTimer > 0) || (ps.torsoTimer == -1)) {
                break setAnimLegs
            }

            BG_StartTorsoAnim(ps, anim)

            if (setAnimFlags & SETANIM_FLAG_HOLD) != 0 {
                if (setAnimFlags & SETANIM_FLAG_HOLDLESS) != 0 {
                    // Make sure to only wait in full 1/20 sec server frame intervals.
                    var dur: Int32
                    var speedDif: Int32

                    dur = Int32((animations[anim].numFrames - 1) * abs(Float((animations[anim].frameLerp))))
                    speedDif = Int32(dur - (dur * editAnimSpeed))
                    dur += speedDif
                    if dur > 1 {
                        ps.torsoTimer = dur - 1
                    } else {
                        ps.torsoTimer = Int32(abs(Float((animations[anim].frameLerp))))
                    }
                } else {
                    ps.torsoTimer = Int32(((animations[anim].numFrames) * abs(Float((animations[anim].frameLerp)))))
                }

                if (ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
                    ps.torsoTimer = Int32(Double(ps.torsoTimer) / 1.7)
                }
            }
        }

    }
    // Set legs anim
    setAnimDone: do {
        if (setAnimParts & SETANIM_LEGS) != 0 {
            // Don't reset if it's already running the anim
            if !((setAnimFlags & SETANIM_FLAG_RESTART) != 0) && (ps.legsAnim) == anim {
                break setAnimDone
            }
            // or if a more important anim is running
            if !((setAnimFlags & SETANIM_FLAG_OVERRIDE) != 0) && ((ps.legsTimer > 0) || (ps.legsTimer == -1)) {
                break setAnimDone
            }

            BG_StartLegsAnim(ps, anim)

            if (setAnimFlags & SETANIM_FLAG_HOLD) != 0 {
                if (setAnimFlags & SETANIM_FLAG_HOLDLESS) != 0 {
                    // Make sure to only wait in full 1/20 sec server frame intervals.
                    var dur: Int32
                    var speedDif: Int32

                    dur = Int32((animations[anim].numFrames - 1) * abs(Float((animations[anim].frameLerp))))
                    speedDif = Int32(dur - (dur * editAnimSpeed))
                    dur += speedDif
                    if dur > 1 {
                        ps.legsTimer = dur - 1
                    } else {
                        ps.legsTimer = Int32(abs(Float((animations[anim].frameLerp))))
                    }
                } else {
                    ps.legsTimer = Int32(((animations[anim].numFrames) * abs(Float((animations[anim].frameLerp)))))
                }

                if PM_RunningAnim(anim) || PM_WalkingAnim(anim) {
                    if (ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
                        ps.legsTimer = Int32(Double(ps.legsTimer) / 1.3)
                    } else if (ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
                        ps.legsTimer = Int32(Double(ps.legsTimer) / 1.7)
                    }
                }
            }
        }

    }
    return
}

/// Source: oracle/codemp/game/bg_panimate.c:2926
func PM_SetAnimFinal(_ setAnimParts: Int32, _ anim: Int32, _ setAnimFlags: Int32, _ blendTime: Int32) {
    BG_SetAnimFinal(pm.ps, pm.animationsSlots, setAnimParts, anim, setAnimFlags, blendTime)
}

/// Source: oracle/codemp/game/bg_panimate.c:2933
func BG_HasAnimation(_ animIndex: Int32, _ animation: Int32) -> Bool {
    var animations: Slots<Animation>

    //must be a valid anim number
    if animation < 0 || animation >= MAX_ANIMATIONS {
        return false
    }

    //Must have a file index entry
    if animIndex < 0 || animIndex > bgNumAllAnims {
        return false
    }

    animations = bgAllAnims[animIndex].animsSlots

    //No frames, no anim
    if animations[animation].numFrames == 0 {
        return false
    }

    //Has the sequence
    return true
}

/// Source: oracle/codemp/game/bg_panimate.c:2957
func BG_PickAnim(_ animIndex: Int32, _ minAnim: Int32, _ maxAnim: Int32) -> Int32 {
    var anim: Int32
    var count: Int32 = 0

    repeat {
        anim = Q_irand(minAnim, maxAnim)
        count += 1
    } while !BG_HasAnimation(animIndex, anim) && count < 1000

    if count == 1000 {
        //guess we just don't have a death anim then.
        return -1
    }

    return anim
}

//I want to be able to use this on a playerstate even when we are not the focus
//of a pmove too so I have ported it to true BGishness.
//Please do not reference pm in this function or any functions that it calls,
//or I will cry. -rww

//I want to be able to use this on a playerstate even when we are not the focus
//of a pmove too so I have ported it to true BGishness.
//Please do not reference pm in this function or any functions that it calls,
//or I will cry. -rww
/// Source: oracle/codemp/game/bg_panimate.c:2981
func BG_SetAnim(_ ps: JKAMP.PlayerState, _ animations: Slots<JKAMP.Animation>, _ setAnimParts: Int32, _ anim: Int32, _ setAnimFlags: Int32, _ blendTime: Int32) {
    // Raven assigns his own `animations` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var animations = animations
    // Raven assigns his own `anim` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var anim = anim
    // Raven's NULL test on animations has no form here, and the arm it guards is gone.
    // Raven's arm under the guard has no path, and its text stays here:
    // {
    //         animations = bgAllAnims[0].anims;
    //     }

    if animations[anim].firstFrame == 0 && animations[anim].numFrames == 0 {
        if anim == BOTH_RUNBACK1 || anim == BOTH_WALKBACK1 || anim == BOTH_RUN1 {
            //hack for droids
            anim = BOTH_WALK2
        }

        if animations[anim].firstFrame == 0 && animations[anim].numFrames == 0 {
            //still? Just return then I guess.
            return
        }
    }

    /*
    if (BG_InSpecialJump(anim))
    {
    setAnimFlags |= SETANIM_FLAG_RESTART;
    }
    */
    //Don't know why I put this here originally but it's messing stuff up now and it isn't needed.

    //	if (BG_InRoll(ps, ps->legsAnim))
    //	{ //never interrupt a roll
    //		return;
    //	}

    if (setAnimFlags & SETANIM_FLAG_OVERRIDE) != 0 {
        if (setAnimParts & SETANIM_TORSO) != 0 {
            if (setAnimFlags & SETANIM_FLAG_RESTART) != 0 || (ps.torsoAnim) != anim {
                BG_SetTorsoAnimTimer(ps, 0)
            }
        }
        if (setAnimParts & SETANIM_LEGS) != 0 {
            if (setAnimFlags & SETANIM_FLAG_RESTART) != 0 || (ps.legsAnim) != anim {
                BG_SetLegsAnimTimer(ps, 0)
            }
        }
    }

    BG_SetAnimFinal(ps, animations, setAnimParts, anim, setAnimFlags, blendTime)
}

/// Source: oracle/codemp/game/bg_panimate.c:3037
func PM_SetAnim(_ setAnimParts: Int32, _ anim: Int32, _ setAnimFlags: Int32, _ blendTime: Int32) {
    BG_SetAnim(pm.ps, pm.animationsSlots, setAnimParts, anim, setAnimFlags, blendTime)
}
