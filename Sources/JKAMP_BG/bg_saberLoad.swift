import Foundation
import JKAMP
import JKAShared

/// Source: oracle/codemp/game/bg_saberLoad.c:43
let MAX_SABER_DATA_SIZE = 0x80000 as Int32

/// Source: oracle/codemp/game/bg_saberLoad.c:44
var SaberParms: JKAShared.CharBuf {
    get { bg.variables.SaberParms }
    set { bg.variables.SaberParms = newValue }
}

/// Source: oracle/codemp/game/bg_saberLoad.c:46
// TODO: Port global SaberTable
// Raven wrote: stringID_table_t SaberTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saberLoad.c:63
// TODO: Port global SaberMoveTable
// Raven wrote: stringID_table_t SaberMoveTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/bg_saberLoad.c:615
let DEFAULT_SABER = "Kyle"

/// Source: oracle/codemp/game/bg_saberLoad.c:2736
var bgSaberParseTBuffer: JKAShared.CharBuf {
    get { bg.variables.bgSaberParseTBuffer }
    set { bg.variables.bgSaberParseTBuffer = newValue }
}

/// Source: oracle/codemp/game/bg_saberLoad.c:32
func BG_SoundIndex(_ sound: String) -> Int32 {
    return G_SoundIndex(sound)
}

//Also used in npc code
/// Source: oracle/codemp/game/bg_saberLoad.c:129
public func BG_ParseLiteral(_ data: inout JKAShared.TextCursor, _ string: String) -> Bool {
    let token: String

    token = COM_ParseExt(&data, true)
    if token.isEmpty {
        Com_Printf("unexpected EOF\n")
        return true
    }

    if Q_stricmp(token, string) != 0 {
        Com_Printf("required string '%s' missing\n", string)
        return true
    }

    return false
}

/// Source: oracle/codemp/game/bg_saberLoad.c:149
public func TranslateSaberColor(_ name: String) -> JKAMP.saber_colors_t {
    if Q_stricmp(name, "red") == 0 {
        return SABER_RED
    }
    if Q_stricmp(name, "orange") == 0 {
        return SABER_ORANGE
    }
    if Q_stricmp(name, "yellow") == 0 {
        return SABER_YELLOW
    }
    if Q_stricmp(name, "green") == 0 {
        return SABER_GREEN
    }
    if Q_stricmp(name, "blue") == 0 {
        return SABER_BLUE
    }
    if Q_stricmp(name, "purple") == 0 {
        return SABER_PURPLE
    }
    if Q_stricmp(name, "random") == 0 {
        return (saber_colors_t((Q_irand(SABER_ORANGE, SABER_PURPLE))))
    }
    return SABER_BLUE
}

/// Source: oracle/codemp/game/bg_saberLoad.c:182
func TranslateSaberStyle(_ name: String) -> JKAShared.saber_styles_t {
    if Q_stricmp(name, "fast") == 0 {
        return SS_FAST
    }
    if Q_stricmp(name, "medium") == 0 {
        return SS_MEDIUM
    }
    if Q_stricmp(name, "strong") == 0 {
        return SS_STRONG
    }
    if Q_stricmp(name, "desann") == 0 {
        return SS_DESANN
    }
    if Q_stricmp(name, "tavion") == 0 {
        return SS_TAVION
    }
    if Q_stricmp(name, "dual") == 0 {
        return SS_DUAL
    }
    if Q_stricmp(name, "staff") == 0 {
        return SS_STAFF
    }
    return SS_NONE
}

/// Source: oracle/codemp/game/bg_saberLoad.c:215
public func WP_SaberBladeUseSecondBladeStyle(_ saber: JKAMP.SaberInfo, _ bladeNum: Int32) -> Bool {
    // Raven's NULL test on saber has no form here, and the arm it guards is gone.
    if saber.bladeStyle2Start > 0 {
        if bladeNum >= saber.bladeStyle2Start {
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/game/bg_saberLoad.c:230
public func WP_SaberBladeDoTransitionDamage(_ saber: JKAMP.SaberInfo, _ bladeNum: Int32) -> Bool {
    if !WP_SaberBladeUseSecondBladeStyle(saber, bladeNum) && (saber.saberFlags2 & SFL2_TRANSITION_DAMAGE) != 0 {
        //use first blade style for this blade
        return true
    } else if WP_SaberBladeUseSecondBladeStyle(saber, bladeNum) && (saber.saberFlags2 & SFL2_TRANSITION_DAMAGE2) != 0 {
        //use second blade style for this blade
        return true
    }
    return false
}

/// Source: oracle/codemp/game/bg_saberLoad.c:245
public func WP_UseFirstValidSaberStyle(_ saber1: JKAMP.SaberInfo, _ saber2: JKAMP.SaberInfo, _ saberHolstered: Int32, _ saberAnimLevel: inout Int32) -> Bool {
    var styleInvalid: Bool = false
    var saber1Active: Bool
    var saber2Active: Bool
    var dualSabers: Bool = false
    var validStyles: Int32 = 0
    var styleNum: Int32

    // Raven's NULL test on saber2 has no form here, and the arm it guards is gone.
    // Raven tests `saber2->model` and `saber2->model[0]`.
    // Both read as the same Swift test, so the draft writes it once.
    if !saber2.model.isEmpty {
        dualSabers = true
    }

    if dualSabers {
        //dual
        if saberHolstered > 1 {
            saber2Active = false
            saber1Active = saber2Active
        } else if saberHolstered > 0 {
            saber1Active = true
            saber2Active = false
        } else {
            saber2Active = true
            saber1Active = saber2Active
        }
    } else {
        saber2Active = false
        // Raven's NULL test on saber1 has no form here, and the arm it guards is gone.
        // Raven tests `!saber1->model` and `!saber1->model[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if saber1.model.isEmpty {
            saber1Active = false
        } else if saber1.numBlades > 1 {
            //staff
            if saberHolstered > 1 {
                saber1Active = false
            } else {
                saber1Active = true
            }
        } else {
            //single
            if saberHolstered != 0 {
                saber1Active = false
            } else {
                saber1Active = true
            }
        }
    }

    //initially, all styles are valid
    styleNum = SS_NONE + 1
    while styleNum < SS_NUM_SABER_STYLES {
        validStyles |= (1 << styleNum)
        styleNum += 1
    }

    // Raven's NULL test on saber1 has no form here, and the arm it guards is gone.
    // Raven tests `saber1->model` and `saber1->model[0]`.
    // Both read as the same Swift test, so the draft writes it once.
    if saber1Active && !saber1.model.isEmpty && saber1.stylesForbidden != 0 {
        if (saber1.stylesForbidden & (1 << saberAnimLevel)) != 0 {
            //not a valid style for first saber!
            styleInvalid = true
            validStyles &= ~saber1.stylesForbidden
        }
    }
    if dualSabers {
        //check second saber, too
        if saber2Active && saber2.stylesForbidden != 0 {
            if (saber2.stylesForbidden & (1 << saberAnimLevel)) != 0 {
                //not a valid style for second saber!
                styleInvalid = true
                //only the ones both sabers allow is valid
                validStyles &= ~saber2.stylesForbidden
            }
        }
    }
    if styleInvalid && validStyles != 0 {
        //using an invalid style and have at least one valid style to use, so switch to it
        var styleNum: Int32
        styleNum = SS_FAST
        while styleNum < SS_NUM_SABER_STYLES {
            if (validStyles & (1 << styleNum)) != 0 {
                saberAnimLevel = styleNum
                return true
            }
            styleNum += 1
        }
    }
    return false
}

/// Source: oracle/codemp/game/bg_saberLoad.c:353
public func WP_SaberStyleValidForSaber(_ saber1: JKAMP.SaberInfo, _ saber2: JKAMP.SaberInfo, _ saberHolstered: Int32, _ saberAnimLevel: Int32) -> Bool {
    var saber1Active: Bool
    var saber2Active: Bool
    var dualSabers: Bool = false

    // Raven's NULL test on saber2 has no form here, and the arm it guards is gone.
    // Raven tests `saber2->model` and `saber2->model[0]`.
    // Both read as the same Swift test, so the draft writes it once.
    if !saber2.model.isEmpty {
        dualSabers = true
    }

    if dualSabers {
        //dual
        if saberHolstered > 1 {
            saber2Active = false
            saber1Active = saber2Active
        } else if saberHolstered > 0 {
            saber1Active = true
            saber2Active = false
        } else {
            saber2Active = true
            saber1Active = saber2Active
        }
    } else {
        saber2Active = false
        // Raven's NULL test on saber1 has no form here, and the arm it guards is gone.
        // Raven tests `!saber1->model` and `!saber1->model[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if saber1.model.isEmpty {
            saber1Active = false
        } else if saber1.numBlades > 1 {
            //staff
            if saberHolstered > 1 {
                saber1Active = false
            } else {
                saber1Active = true
            }
        } else {
            //single
            if saberHolstered != 0 {
                saber1Active = false
            } else {
                saber1Active = true
            }
        }
    }

    // Raven's NULL test on saber1 has no form here, and the arm it guards is gone.
    // Raven tests `saber1->model` and `saber1->model[0]`.
    // Both read as the same Swift test, so the draft writes it once.
    if saber1Active && !saber1.model.isEmpty && saber1.stylesForbidden != 0 {
        if (saber1.stylesForbidden & (1 << saberAnimLevel)) != 0 {
            //not a valid style for first saber!
            return false
        }
    }
    // Raven's NULL test on saber2 has no form here, and the arm it guards is gone.
    // Raven tests `saber2->model` and `saber2->model[0]`.
    // Both read as the same Swift test, so the draft writes it once.
    if dualSabers && saber2Active && !saber2.model.isEmpty {
        if saber2.stylesForbidden != 0 {
            //check second saber, too
            if (saber2.stylesForbidden & (1 << saberAnimLevel)) != 0 {
                //not a valid style for second saber!
                return false
            }
        }
        //now: if using dual sabers, only dual and tavion (if given with this saber) are allowed
        if saberAnimLevel != SS_DUAL {
            //dual is okay
            if saberAnimLevel != SS_TAVION {
                //tavion might be okay, all others are not
                return false
            } else {
                //see if "tavion" style is okay
                // Raven's NULL test on saber1 has no form here, and the arm it guards is gone.
                // Raven tests `saber1->model` and `saber1->model[0]`.
                // Both read as the same Swift test, so the draft writes it once.
                if saber1Active && !saber1.model.isEmpty && (saber1.stylesLearned & (1 << SS_TAVION)) != 0 {
                    //okay to use tavion style, first saber gave it to us
                } else if (saber2.stylesLearned & (1 << SS_TAVION)) != 0 {
                    //okay to use tavion style, second saber gave it to us
                } else {
                    //tavion style is not allowed because neither of the sabers we're using gave it to us (I know, doesn't quite make sense, but...)
                    return false
                }
            }
        }
    }
    return true
}

/// Source: oracle/codemp/game/bg_saberLoad.c:466
public func WP_SaberCanTurnOffSomeBlades(_ saber: JKAMP.SaberInfo) -> Bool {
    if saber.bladeStyle2Start > 0 && saber.numBlades > saber.bladeStyle2Start {
        if (saber.saberFlags2 & SFL2_NO_MANUAL_DEACTIVATE) != 0 && (saber.saberFlags2 & SFL2_NO_MANUAL_DEACTIVATE2) != 0 {
            //all blades are always on
            return false
        }
    } else {
        if (saber.saberFlags2 & SFL2_NO_MANUAL_DEACTIVATE) != 0 {
            //all blades are always on
            return false
        }
    }
    //you can turn some off
    return true
}

/// Source: oracle/codemp/game/bg_saberLoad.c:488
func WP_SaberSetDefaults(_ saber: JKAMP.SaberInfo) {
    var i: Int32

    //Set defaults so that, if it fails, there's at least something there
    i = 0
    while i < MAX_BLADES {
        saber.blade[i].color = SABER_RED
        saber.blade[i].radius = SABER_RADIUS_STANDARD
        saber.blade[i].lengthMax = 32
        i += 1
    }

    strcpy(&saber.nameBuffer, "default")
    strcpy(&saber.fullNameBuffer, "lightsaber")
    strcpy(&saber.modelBuffer, "models/weapons2/saber_reborn/saber_w.glm")
    saber.skin = 0
    saber.soundOn = BG_SoundIndex("sound/weapons/saber/enemy_saber_on.wav")
    saber.soundLoop = BG_SoundIndex("sound/weapons/saber/saberhum3.wav")
    saber.soundOff = BG_SoundIndex("sound/weapons/saber/enemy_saber_off.wav")
    saber.numBlades = 1
    saber.type = SABER_SINGLE
    saber.stylesLearned = 0
    saber.stylesForbidden = 0 //allow all styles
    saber.maxChain = 0 //0 = use default behavior
    saber.forceRestrictions = 0
    saber.lockBonus = 0
    saber.parryBonus = 0
    saber.breakParryBonus = 0
    saber.breakParryBonus2 = 0
    saber.disarmBonus = 0
    saber.disarmBonus2 = 0
    saber.singleBladeStyle = SS_NONE //makes it so that you use a different style if you only have the first blade active
    //	saber->brokenSaber1 = NULL;//if saber is actually hit by another saber, it can be cut in half/broken and will be replaced with this saber in your right hand
    //	saber->brokenSaber2 = NULL;//if saber is actually hit by another saber, it can be cut in half/broken and will be replaced with this saber in your left hand
    //===NEW========================================================================================
    //done in cgame (client-side code)
    saber.saberFlags = 0 //see all the SFL_ flags
    saber.saberFlags2 = 0 //see all the SFL2_ flags

    saber.spinSound = 0 //none - if set, plays this sound as it spins when thrown
    saber.swingSound[0] = 0 //none - if set, plays one of these 3 sounds when swung during an attack - NOTE: must provide all 3!!!
    saber.swingSound[1] = 0 //none - if set, plays one of these 3 sounds when swung during an attack - NOTE: must provide all 3!!!
    saber.swingSound[2] = 0 //none - if set, plays one of these 3 sounds when swung during an attack - NOTE: must provide all 3!!!

    //done in game (server-side code)
    saber.moveSpeedScale = 1.0 //1.0 - you move faster/slower when using this saber
    saber.animSpeedScale = 1.0 //1.0 - plays normal attack animations faster/slower

    saber.kataMove = LS_INVALID //LS_INVALID - if set, player will execute this move when they press both attack buttons at the same time
    saber.lungeAtkMove = LS_INVALID //LS_INVALID - if set, player will execute this move when they crouch+fwd+attack
    saber.jumpAtkUpMove = LS_INVALID //LS_INVALID - if set, player will execute this move when they jump+attack
    saber.jumpAtkFwdMove = LS_INVALID //LS_INVALID - if set, player will execute this move when they jump+fwd+attack
    saber.jumpAtkBackMove = LS_INVALID //LS_INVALID - if set, player will execute this move when they jump+back+attack
    saber.jumpAtkRightMove = LS_INVALID //LS_INVALID - if set, player will execute this move when they jump+rightattack
    saber.jumpAtkLeftMove = LS_INVALID //LS_INVALID - if set, player will execute this move when they jump+left+attack
    saber.readyAnim = -1 //-1 - anim to use when standing idle
    saber.drawAnim = -1 //-1 - anim to use when drawing weapon
    saber.putawayAnim = -1 //-1 - anim to use when putting weapon away
    saber.tauntAnim = -1 //-1 - anim to use when hit "taunt"
    saber.bowAnim = -1 //-1 - anim to use when hit "bow"
    saber.meditateAnim = -1 //-1 - anim to use when hit "meditate"
    saber.flourishAnim = -1 //-1 - anim to use when hit "flourish"
    saber.gloatAnim = -1 //-1 - anim to use when hit "gloat"

    //***NOTE: you can only have a maximum of 2 "styles" of blades, so this next value, "bladeStyle2Start" is the number of the first blade to use these value on... all blades before this use the normal values above, all blades at and after this number use the secondary values below***
    saber.bladeStyle2Start = 0 //0 - if set, blades from this number and higher use the following values (otherwise, they use the normal values already set)

    //***The following can be different for the extra blades - not setting them individually defaults them to the value for the whole saber (and first blade)***

    //===PRIMARY BLADES=====================
    //done in cgame (client-side code)
    saber.trailStyle = 0 //0 - default (0) is normal, 1 is a motion blur and 2 is no trail at all (good for real-sword type mods)
    saber.g2MarksShader = 0 //none - if set, the game will use this shader for marks on enemies instead of the default "gfx/damage/saberglowmark"
    saber.g2WeaponMarkShader = 0 //none - if set, the game will use this shader for marks on enemies instead of the default "gfx/damage/saberglowmark"
    //saber->bladeShader = 0;				//none - if set, overrides the shader used for the saber blade?
    //saber->trailShader = 0;				//none - if set, overrides the shader used for the saber trail?
    saber.hitSound[0] = 0 //none - if set, plays one of these 3 sounds when saber hits a person - NOTE: must provide all 3!!!
    saber.hitSound[1] = 0 //none - if set, plays one of these 3 sounds when saber hits a person - NOTE: must provide all 3!!!
    saber.hitSound[2] = 0 //none - if set, plays one of these 3 sounds when saber hits a person - NOTE: must provide all 3!!!
    saber.blockSound[0] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits another saber/sword - NOTE: must provide all 3!!!
    saber.blockSound[1] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits another saber/sword - NOTE: must provide all 3!!!
    saber.blockSound[2] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits another saber/sword - NOTE: must provide all 3!!!
    saber.bounceSound[0] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits a wall and bounces off (must set bounceOnWall to 1 to use these sounds) - NOTE: must provide all 3!!!
    saber.bounceSound[1] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits a wall and bounces off (must set bounceOnWall to 1 to use these sounds) - NOTE: must provide all 3!!!
    saber.bounceSound[2] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits a wall and bounces off (must set bounceOnWall to 1 to use these sounds) - NOTE: must provide all 3!!!
    saber.blockEffect = 0 //none - if set, plays this effect when the saber/sword hits another saber/sword (instead of "saber/saber_block.efx")
    saber.hitPersonEffect = 0 //none - if set, plays this effect when the saber/sword hits a person (instead of "saber/blood_sparks_mp.efx")
    saber.hitOtherEffect = 0 //none - if set, plays this effect when the saber/sword hits something else damagable (instead of "saber/saber_cut.efx")
    saber.bladeEffect = 0 //none - if set, plays this effect at the blade tag

    //done in game (server-side code)
    saber.knockbackScale = 0 //0 - if non-zero, uses damage done to calculate an appropriate amount of knockback
    saber.damageScale = 1.0 //1 - scale up or down the damage done by the saber
    saber.splashRadius = 0.0 //0 - radius of splashDamage
    saber.splashDamage = 0 //0 - amount of splashDamage, 100% at a distance of 0, 0% at a distance = splashRadius
    saber.splashKnockback = 0.0 //0 - amount of splashKnockback, 100% at a distance of 0, 0% at a distance = splashRadius

    //===SECONDARY BLADES===================
    //done in cgame (client-side code)
    saber.trailStyle2 = 0 //0 - default (0) is normal, 1 is a motion blur and 2 is no trail at all (good for real-sword type mods)
    saber.g2MarksShader2 = 0 //none - if set, the game will use this shader for marks on enemies instead of the default "gfx/damage/saberglowmark"
    saber.g2WeaponMarkShader2 = 0 //none - if set, the game will use this shader for marks on enemies instead of the default "gfx/damage/saberglowmark"
    //saber->bladeShader = 0;				//none - if set, overrides the shader used for the saber blade?
    //saber->trailShader = 0;				//none - if set, overrides the shader used for the saber trail?
    saber.hit2Sound[0] = 0 //none - if set, plays one of these 3 sounds when saber hits a person - NOTE: must provide all 3!!!
    saber.hit2Sound[1] = 0 //none - if set, plays one of these 3 sounds when saber hits a person - NOTE: must provide all 3!!!
    saber.hit2Sound[2] = 0 //none - if set, plays one of these 3 sounds when saber hits a person - NOTE: must provide all 3!!!
    saber.block2Sound[0] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits another saber/sword - NOTE: must provide all 3!!!
    saber.block2Sound[1] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits another saber/sword - NOTE: must provide all 3!!!
    saber.block2Sound[2] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits another saber/sword - NOTE: must provide all 3!!!
    saber.bounce2Sound[0] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits a wall and bounces off (must set bounceOnWall to 1 to use these sounds) - NOTE: must provide all 3!!!
    saber.bounce2Sound[1] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits a wall and bounces off (must set bounceOnWall to 1 to use these sounds) - NOTE: must provide all 3!!!
    saber.bounce2Sound[2] = 0 //none - if set, plays one of these 3 sounds when saber/sword hits a wall and bounces off (must set bounceOnWall to 1 to use these sounds) - NOTE: must provide all 3!!!
    saber.blockEffect2 = 0 //none - if set, plays this effect when the saber/sword hits another saber/sword (instead of "saber/saber_block.efx")
    saber.hitPersonEffect2 = 0 //none - if set, plays this effect when the saber/sword hits a person (instead of "saber/blood_sparks_mp.efx")
    saber.hitOtherEffect2 = 0 //none - if set, plays this effect when the saber/sword hits something else damagable (instead of "saber/saber_cut.efx")
    saber.bladeEffect2 = 0 //none - if set, plays this effect at the blade tag

    //done in game (server-side code)
    saber.knockbackScale2 = 0 //0 - if non-zero, uses damage done to calculate an appropriate amount of knockback
    saber.damageScale2 = 1.0 //1 - scale up or down the damage done by the saber
    saber.splashRadius2 = 0.0 //0 - radius of splashDamage
    saber.splashDamage2 = 0 //0 - amount of splashDamage, 100% at a distance of 0, 0% at a distance = splashRadius
    saber.splashKnockback2 = 0.0 //0 - amount of splashKnockback, 100% at a distance of 0, 0% at a distance = splashRadius
    //=========================================================================================================================================
}

/// Source: oracle/codemp/game/bg_saberLoad.c:617
public func WP_SaberParseParms(_ SaberName: String, _ saber: JKAMP.SaberInfo) -> Bool {
    var token: String
    var value: String = ""
    var p = TextCursor()
    var useSaber = CharBuf(1024)
    var f: Float = 0
    var n: Int32 = 0
    var triedDefault: Bool = false
    var saberMove: Int32 = LS_INVALID
    var anim: Int32 = -1

    // Raven's NULL test on saber has no form here, and the arm it guards is gone.
    // Raven's arm under the guard has no path, and its text stays here:
    // {
    //         return qfalse;
    //     }

    //Set defaults so that, if it fails, there's at least something there
    WP_SaberSetDefaults(saber)

    // Raven's NULL test on SaberName has no form here, and the arm it guards is gone.
    if SaberName.isEmpty {
        strcpy(&useSaber, DEFAULT_SABER) //default
        triedDefault = true
    } else {
        strcpy(&useSaber, SaberName)
    }

    //try to parse it out
    p = TextCursor(SaberParms)
    COM_BeginParseSession("saberinfo")

    // look for the right saber
    while !p.isNull {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            if !triedDefault {
                //fall back to default and restart, should always be there
                p = TextCursor(SaberParms)
                COM_BeginParseSession("saberinfo")
                strcpy(&useSaber, DEFAULT_SABER)
                triedDefault = true
            } else {
                return false
            }
        }

        if Q_stricmp(token, String(useSaber)) == 0 {
            break
        }

        SkipBracedSection(&p)
    }
    if p.isNull {
        //even the default saber isn't found?
        return false
    }

    //got the name we're using for sure
    strcpy(&saber.nameBuffer, useSaber)

    if BG_ParseLiteral(&p, "{") {
        return false
    }

    // parse the saber info block
    while 1 != 0 {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_RED + "ERROR: unexpected EOF while parsing '%s'\n", useSaber)
            return false
        }

        if Q_stricmp(token, "}") == 0 {
            break
        }

        //saber fullName
        if Q_stricmp(token, "name") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            strcpy(&saber.fullNameBuffer, value)
            continue
        }

        //saber type
        if Q_stricmp(token, "saberType") == 0 {
            var saberType: Int32

            if COM_ParseString(&p, &value) {
                continue
            }
            saberType = GetIDForString(SaberTable, value)
            if saberType >= SABER_SINGLE && saberType <= NUM_SABERS {
                saber.type = saberType_t(saberType)
            }
            continue
        }

        //saber hilt
        if Q_stricmp(token, "saberModel") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            strcpy(&saber.modelBuffer, value)
            continue
        }

        if Q_stricmp(token, "customSkin") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.skin = trap_R_RegisterSkin(value)
            continue
        }

        //on sound
        if Q_stricmp(token, "soundOn") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.soundOn = BG_SoundIndex(value)
            continue
        }

        //loop sound
        if Q_stricmp(token, "soundLoop") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.soundLoop = BG_SoundIndex(value)
            continue
        }

        //off sound
        if Q_stricmp(token, "soundOff") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.soundOff = BG_SoundIndex(value)
            continue
        }

        if Q_stricmp(token, "numBlades") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n < 1 || n > MAX_BLADES {
                Com_Error(ERR_DROP, "WP_SaberParseParms: saber %s has illegal number of blades (%d) max: %d", useSaber, n, MAX_BLADES)
                continue
            }
            saber.numBlades = n
            continue
        }

        // saberColor
        if Q_stricmpn(token, "saberColor", 10) == 0 {
            if strlen(token) == 10 {
                n = -1
            } else if strlen(token) == 11 {
                n = atoi(String(token.dropFirst(Int(10)))) - 1
                if n > 7 || n < 1 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad saberColor '%s' in %s\n", token, useSaber)
                    continue
                }
            } else {
                Com_Printf(S_COLOR_YELLOW + "WARNING: bad saberColor '%s' in %s\n", token, useSaber)
                continue
            }

            if COM_ParseString(&p, &value) {
                continue
            }

            if n == -1 {
                //NOTE: this fills in the rest of the blades with the same color by default
                let color: saber_colors_t = TranslateSaberColor(value)
                n = 0
                while n < MAX_BLADES {
                    saber.blade[n].color = color
                    n += 1
                }
            } else {
                saber.blade[n].color = TranslateSaberColor(value)
            }
            continue
        }

        //saber length
        if Q_stricmpn(token, "saberLength", 11) == 0 {
            if strlen(token) == 11 {
                n = -1
            } else if strlen(token) == 12 {
                n = atoi(String(token.dropFirst(Int(11)))) - 1
                if n > 7 || n < 1 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad saberLength '%s' in %s\n", token, useSaber)
                    continue
                }
            } else {
                Com_Printf(S_COLOR_YELLOW + "WARNING: bad saberLength '%s' in %s\n", token, useSaber)
                continue
            }

            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            //cap
            if f < 4.0 {
                f = 4.0
            }

            if n == -1 {
                //NOTE: this fills in the rest of the blades with the same length by default
                n = 0
                while n < MAX_BLADES {
                    saber.blade[n].lengthMax = f
                    n += 1
                }
            } else {
                saber.blade[n].lengthMax = f
            }
            continue
        }

        //blade radius
        if Q_stricmpn(token, "saberRadius", 11) == 0 {
            if strlen(token) == 11 {
                n = -1
            } else if strlen(token) == 12 {
                n = atoi(String(token.dropFirst(Int(11)))) - 1
                if n > 7 || n < 1 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad saberRadius '%s' in %s\n", token, useSaber)
                    continue
                }
            } else {
                Com_Printf(S_COLOR_YELLOW + "WARNING: bad saberRadius '%s' in %s\n", token, useSaber)
                continue
            }

            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            //cap
            if f < 0.25 {
                f = 0.25
            }
            if n == -1 {
                //NOTE: this fills in the rest of the blades with the same length by default
                n = 0
                while n < MAX_BLADES {
                    saber.blade[n].radius = f
                    n += 1
                }
            } else {
                saber.blade[n].radius = f
            }
            continue
        }

        //locked saber style
        if Q_stricmp(token, "saberStyle") == 0 {
            var style: Int32
            var styleNum: Int32
            if COM_ParseString(&p, &value) {
                continue
            }
            //OLD WAY: only allowed ONE style
            style = TranslateSaberStyle(value)
            //learn only this style
            saber.stylesLearned = (1 << style)
            //forbid all other styles
            saber.stylesForbidden = 0
            styleNum = SS_NONE + 1
            while styleNum < SS_NUM_SABER_STYLES {
                if styleNum != style {
                    saber.stylesForbidden |= (1 << styleNum)
                }
                styleNum += 1
            }
            continue
        }

        //learned saber style
        if Q_stricmp(token, "saberStyleLearned") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.stylesLearned |= (1 << TranslateSaberStyle(value))
            continue
        }

        //forbidden saber style
        if Q_stricmp(token, "saberStyleForbidden") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.stylesForbidden |= (1 << TranslateSaberStyle(value))
            continue
        }

        //maxChain
        if Q_stricmp(token, "maxChain") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.maxChain = n
            continue
        }

        //lockable
        if Q_stricmp(token, "lockable") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n == 0 {
                saber.saberFlags |= SFL_NOT_LOCKABLE
            }
            continue
        }

        //throwable
        if Q_stricmp(token, "throwable") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n == 0 {
                saber.saberFlags |= SFL_NOT_THROWABLE
            }
            continue
        }

        //disarmable
        if Q_stricmp(token, "disarmable") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n == 0 {
                saber.saberFlags |= SFL_NOT_DISARMABLE
            }
            continue
        }

        //active blocking
        if Q_stricmp(token, "blocking") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n == 0 {
                saber.saberFlags |= SFL_NOT_ACTIVE_BLOCKING
            }
            continue
        }

        //twoHanded
        if Q_stricmp(token, "twoHanded") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_TWO_HANDED
            }
            continue
        }

        //force power restrictions
        if Q_stricmp(token, "forceRestrict") == 0 {
            var fp: Int32

            if COM_ParseString(&p, &value) {
                continue
            }
            fp = GetIDForString(FPTable, value)
            if fp >= FP_FIRST && fp < NUM_FORCE_POWERS {
                saber.forceRestrictions |= (1 << fp)
            }
            continue
        }

        //lockBonus
        if Q_stricmp(token, "lockBonus") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.lockBonus = n
            continue
        }

        //parryBonus
        if Q_stricmp(token, "parryBonus") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.parryBonus = n
            continue
        }

        //breakParryBonus
        if Q_stricmp(token, "breakParryBonus") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.breakParryBonus = n
            continue
        }

        //breakParryBonus2
        if Q_stricmp(token, "breakParryBonus2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.breakParryBonus2 = n
            continue
        }

        //disarmBonus
        if Q_stricmp(token, "disarmBonus") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.disarmBonus = n
            continue
        }

        //disarmBonus2
        if Q_stricmp(token, "disarmBonus2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.disarmBonus2 = n
            continue
        }

        //single blade saber style
        if Q_stricmp(token, "singleBladeStyle") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.singleBladeStyle = TranslateSaberStyle(value)
            continue
        }

        //single blade throwable
        if Q_stricmp(token, "singleBladeThrowable") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_SINGLE_BLADE_THROWABLE
            }
            continue
        }

        //broken replacement saber1 (right hand)
        if Q_stricmp(token, "brokenSaber1") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            //saber->brokenSaber1 = G_NewString( value );
            continue
        }

        //broken replacement saber2 (left hand)
        if Q_stricmp(token, "brokenSaber2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            //saber->brokenSaber2 = G_NewString( value );
            continue
        }

        //spins and does damage on return from saberthrow
        if Q_stricmp(token, "returnDamage") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_RETURN_DAMAGE
            }
            continue
        }

        //spin sound (when thrown)
        if Q_stricmp(token, "spinSound") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.spinSound = BG_SoundIndex(value)
            continue
        }

        //swing sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "swingSound1") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.swingSound[0] = BG_SoundIndex(value)
            continue
        }

        //swing sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "swingSound2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.swingSound[1] = BG_SoundIndex(value)
            continue
        }

        //swing sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "swingSound3") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.swingSound[2] = BG_SoundIndex(value)
            continue
        }

        //you move faster/slower when using this saber
        if Q_stricmp(token, "moveSpeedScale") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.moveSpeedScale = f
            continue
        }

        //plays normal attack animations faster/slower
        if Q_stricmp(token, "animSpeedScale") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.animSpeedScale = f
            continue
        }

        //if non-zero, the saber will bounce back when it hits solid architecture (good for real-sword type mods)
        if Q_stricmp(token, "bounceOnWalls") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_BOUNCE_ON_WALLS
            }
            continue
        }

        //if set, saber model is bolted to wrist, not in hand... useful for things like claws & shields, etc.
        if Q_stricmp(token, "boltToWrist") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_BOLT_TO_WRIST
            }
            continue
        }

        //kata move
        if Q_stricmp(token, "kataMove") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saberMove = GetIDForString(SaberMoveTable, value)
            if saberMove >= LS_INVALID && saberMove < LS_MOVE_MAX {
                saber.kataMove = saberMove //LS_INVALID - if set, player will execute this move when they press both attack buttons at the same time
            }
            continue
        }
        //lungeAtkMove move
        if Q_stricmp(token, "lungeAtkMove") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saberMove = GetIDForString(SaberMoveTable, value)
            if saberMove >= LS_INVALID && saberMove < LS_MOVE_MAX {
                saber.lungeAtkMove = saberMove
            }
            continue
        }
        //jumpAtkUpMove move
        if Q_stricmp(token, "jumpAtkUpMove") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saberMove = GetIDForString(SaberMoveTable, value)
            if saberMove >= LS_INVALID && saberMove < LS_MOVE_MAX {
                saber.jumpAtkUpMove = saberMove
            }
            continue
        }
        //jumpAtkFwdMove move
        if Q_stricmp(token, "jumpAtkFwdMove") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saberMove = GetIDForString(SaberMoveTable, value)
            if saberMove >= LS_INVALID && saberMove < LS_MOVE_MAX {
                saber.jumpAtkFwdMove = saberMove
            }
            continue
        }
        //jumpAtkBackMove move
        if Q_stricmp(token, "jumpAtkBackMove") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saberMove = GetIDForString(SaberMoveTable, value)
            if saberMove >= LS_INVALID && saberMove < LS_MOVE_MAX {
                saber.jumpAtkBackMove = saberMove
            }
            continue
        }
        //jumpAtkRightMove move
        if Q_stricmp(token, "jumpAtkRightMove") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saberMove = GetIDForString(SaberMoveTable, value)
            if saberMove >= LS_INVALID && saberMove < LS_MOVE_MAX {
                saber.jumpAtkRightMove = saberMove
            }
            continue
        }
        //jumpAtkLeftMove move
        if Q_stricmp(token, "jumpAtkLeftMove") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saberMove = GetIDForString(SaberMoveTable, value)
            if saberMove >= LS_INVALID && saberMove < LS_MOVE_MAX {
                saber.jumpAtkLeftMove = saberMove
            }
            continue
        }
        //readyAnim
        if Q_stricmp(token, "readyAnim") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            anim = GetIDForString(animTable, value)
            if anim >= 0 && anim < MAX_ANIMATIONS {
                saber.readyAnim = anim
            }
            continue
        }
        //drawAnim
        if Q_stricmp(token, "drawAnim") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            anim = GetIDForString(animTable, value)
            if anim >= 0 && anim < MAX_ANIMATIONS {
                saber.drawAnim = anim
            }
            continue
        }
        //putawayAnim
        if Q_stricmp(token, "putawayAnim") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            anim = GetIDForString(animTable, value)
            if anim >= 0 && anim < MAX_ANIMATIONS {
                saber.putawayAnim = anim
            }
            continue
        }
        //tauntAnim
        if Q_stricmp(token, "tauntAnim") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            anim = GetIDForString(animTable, value)
            if anim >= 0 && anim < MAX_ANIMATIONS {
                saber.tauntAnim = anim
            }
            continue
        }
        //bowAnim
        if Q_stricmp(token, "bowAnim") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            anim = GetIDForString(animTable, value)
            if anim >= 0 && anim < MAX_ANIMATIONS {
                saber.bowAnim = anim
            }
            continue
        }
        //meditateAnim
        if Q_stricmp(token, "meditateAnim") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            anim = GetIDForString(animTable, value)
            if anim >= 0 && anim < MAX_ANIMATIONS {
                saber.meditateAnim = anim
            }
            continue
        }
        //flourishAnim
        if Q_stricmp(token, "flourishAnim") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            anim = GetIDForString(animTable, value)
            if anim >= 0 && anim < MAX_ANIMATIONS {
                saber.flourishAnim = anim
            }
            continue
        }
        //gloatAnim
        if Q_stricmp(token, "gloatAnim") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            anim = GetIDForString(animTable, value)
            if anim >= 0 && anim < MAX_ANIMATIONS {
                saber.gloatAnim = anim
            }
            continue
        }

        //if set, cannot do roll-stab move at end of roll
        if Q_stricmp(token, "noRollStab") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_ROLL_STAB
            }
            continue
        }

        //if set, cannot do pull+attack move (move not available in MP anyway)
        if Q_stricmp(token, "noPullAttack") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_PULL_ATTACK
            }
            continue
        }

        //if set, cannot do back-stab moves
        if Q_stricmp(token, "noBackAttack") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_BACK_ATTACK
            }
            continue
        }

        //if set, cannot do stabdown move (when enemy is on ground)
        if Q_stricmp(token, "noStabDown") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_STABDOWN
            }
            continue
        }

        //if set, cannot side-run or forward-run on walls
        if Q_stricmp(token, "noWallRuns") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_WALL_RUNS
            }
            continue
        }

        //if set, cannot do backflip off wall or side-flips off walls
        if Q_stricmp(token, "noWallFlips") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_WALL_FLIPS
            }
            continue
        }

        //if set, cannot grab wall & jump off
        if Q_stricmp(token, "noWallGrab") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_WALL_GRAB
            }
            continue
        }

        //if set, cannot roll
        if Q_stricmp(token, "noRolls") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_ROLLS
            }
            continue
        }

        //if set, cannot do flips
        if Q_stricmp(token, "noFlips") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_FLIPS
            }
            continue
        }

        //if set, cannot do cartwheels
        if Q_stricmp(token, "noCartwheels") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_CARTWHEELS
            }
            continue
        }

        //if set, cannot do kicks (can't do kicks anyway if using a throwable saber/sword)
        if Q_stricmp(token, "noKicks") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_KICKS
            }
            continue
        }

        //if set, cannot do the simultaneous attack left/right moves (only available in Dual Lightsaber Combat Style)
        if Q_stricmp(token, "noMirrorAttacks") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags |= SFL_NO_MIRROR_ATTACKS
            }
            continue
        }

        //stays on in water
        if Q_stricmp(token, "onInWater") == 0 {
            //ignore in MP
            SkipRestOfLine(&p)
            continue
        }

        if Q_stricmp(token, "notInMP") == 0 {
            //ignore this
            SkipRestOfLine(&p)
            continue
        }

        //===ABOVE THIS, ALL VALUES ARE GLOBAL TO THE SABER========================================================
        //bladeStyle2Start - where to start using the second set of blade data
        if Q_stricmp(token, "bladeStyle2Start") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.bladeStyle2Start = n
            continue
        }
        //===BLADE-SPECIFIC FIELDS=================================================================================

        //===PRIMARY BLADE====================================
        //stops the saber from drawing marks on the world (good for real-sword type mods)
        if Q_stricmp(token, "noWallMarks") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_WALL_MARKS
            }
            continue
        }

        //stops the saber from drawing a dynamic light (good for real-sword type mods)
        if Q_stricmp(token, "noDlight") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_DLIGHT
            }
            continue
        }

        //stops the saber from drawing a blade (good for real-sword type mods)
        if Q_stricmp(token, "noBlade") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_BLADE
            }
            continue
        }

        //default (0) is normal, 1 is a motion blur and 2 is no trail at all (good for real-sword type mods)
        if Q_stricmp(token, "trailStyle") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.trailStyle = n
            continue
        }

        //if set, the game will use this shader for marks on enemies instead of the default "gfx/damage/saberglowmark"
        if Q_stricmp(token, "g2MarksShader") == 0 {
            if COM_ParseString(&p, &value) {
                SkipRestOfLine(&p)
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //if set, the game will use this shader for marks on enemies instead of the default "gfx/damage/saberglowmark"
        if Q_stricmp(token, "g2WeaponMarkShader") == 0 {
            if COM_ParseString(&p, &value) {
                SkipRestOfLine(&p)
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //if non-zero, uses damage done to calculate an appropriate amount of knockback
        if Q_stricmp(token, "knockbackScale") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.knockbackScale = f
            continue
        }

        //scale up or down the damage done by the saber
        if Q_stricmp(token, "damageScale") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.damageScale = f
            continue
        }

        //if non-zero, the saber never does dismemberment (good for pointed/blunt melee weapons)
        if Q_stricmp(token, "noDismemberment") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_DISMEMBERMENT
            }
            continue
        }

        //if non-zero, the saber will not do damage or any effects when it is idle (not in an attack anim).  (good for real-sword type mods)
        if Q_stricmp(token, "noIdleEffect") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_IDLE_EFFECT
            }
            continue
        }

        //if set, the blades will always be blocking (good for things like shields that should always block)
        if Q_stricmp(token, "alwaysBlock") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_ALWAYS_BLOCK
            }
            continue
        }

        //if set, the blades cannot manually be toggled on and off
        if Q_stricmp(token, "noManualDeactivate") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_MANUAL_DEACTIVATE
            }
            continue
        }

        //if set, the blade does damage in start, transition and return anims (like strong style does)
        if Q_stricmp(token, "transitionDamage") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_TRANSITION_DAMAGE
            }
            continue
        }

        //splashRadius - radius of splashDamage
        if Q_stricmp(token, "splashRadius") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.splashRadius = f
            continue
        }

        //splashDamage - amount of splashDamage, 100% at a distance of 0, 0% at a distance = splashRadius
        if Q_stricmp(token, "splashDamage") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.splashDamage = n
            continue
        }

        //splashKnockback - amount of splashKnockback, 100% at a distance of 0, 0% at a distance = splashRadius
        if Q_stricmp(token, "splashKnockback") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.splashKnockback = f
            continue
        }

        //hit sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "hitSound1") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.hitSound[0] = BG_SoundIndex(value)
            continue
        }

        //hit sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "hitSound2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.hitSound[1] = BG_SoundIndex(value)
            continue
        }

        //hit sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "hitSound3") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.hitSound[2] = BG_SoundIndex(value)
            continue
        }

        //block sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "blockSound1") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.blockSound[0] = BG_SoundIndex(value)
            continue
        }

        //block sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "blockSound2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.blockSound[1] = BG_SoundIndex(value)
            continue
        }

        //block sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "blockSound3") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.blockSound[2] = BG_SoundIndex(value)
            continue
        }

        //bounce sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "bounceSound1") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.bounceSound[0] = BG_SoundIndex(value)
            continue
        }

        //bounce sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "bounceSound2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.bounceSound[1] = BG_SoundIndex(value)
            continue
        }

        //bounce sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "bounceSound3") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.bounceSound[2] = BG_SoundIndex(value)
            continue
        }

        //block effect - when saber/sword hits another saber/sword
        if Q_stricmp(token, "blockEffect") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //hit person effect - when saber/sword hits a person
        if Q_stricmp(token, "hitPersonEffect") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //hit other effect - when saber/sword hits sopmething else damagable
        if Q_stricmp(token, "hitOtherEffect") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //blade effect
        if Q_stricmp(token, "bladeEffect") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //if non-zero, the saber will not do the big, white clash flare with other sabers
        if Q_stricmp(token, "noClashFlare") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_CLASH_FLARE
            }
            continue
        }

        //===SECONDARY BLADE====================================
        //stops the saber from drawing marks on the world (good for real-sword type mods)
        if Q_stricmp(token, "noWallMarks2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_WALL_MARKS2
            }
            continue
        }

        //stops the saber from drawing a dynamic light (good for real-sword type mods)
        if Q_stricmp(token, "noDlight2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_DLIGHT2
            }
            continue
        }

        //stops the saber from drawing a blade (good for real-sword type mods)
        if Q_stricmp(token, "noBlade2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_BLADE2
            }
            continue
        }

        //default (0) is normal, 1 is a motion blur and 2 is no trail at all (good for real-sword type mods)
        if Q_stricmp(token, "trailStyle2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.trailStyle2 = n
            continue
        }

        //if set, the game will use this shader for marks on enemies instead of the default "gfx/damage/saberglowmark"
        if Q_stricmp(token, "g2MarksShader2") == 0 {
            if COM_ParseString(&p, &value) {
                SkipRestOfLine(&p)
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //if set, the game will use this shader for marks on enemies instead of the default "gfx/damage/saberglowmark"
        if Q_stricmp(token, "g2WeaponMarkShader2") == 0 {
            if COM_ParseString(&p, &value) {
                SkipRestOfLine(&p)
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //if non-zero, uses damage done to calculate an appropriate amount of knockback
        if Q_stricmp(token, "knockbackScale2") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.knockbackScale2 = f
            continue
        }

        //scale up or down the damage done by the saber
        if Q_stricmp(token, "damageScale2") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.damageScale2 = f
            continue
        }

        //if non-zero, the saber never does dismemberment (good for pointed/blunt melee weapons)
        if Q_stricmp(token, "noDismemberment2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_DISMEMBERMENT2
            }
            continue
        }

        //if non-zero, the saber will not do damage or any effects when it is idle (not in an attack anim).  (good for real-sword type mods)
        if Q_stricmp(token, "noIdleEffect2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_IDLE_EFFECT2
            }
            continue
        }

        //if set, the blades will always be blocking (good for things like shields that should always block)
        if Q_stricmp(token, "alwaysBlock2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_ALWAYS_BLOCK2
            }
            continue
        }

        //if set, the blades cannot manually be toggled on and off
        if Q_stricmp(token, "noManualDeactivate2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_MANUAL_DEACTIVATE2
            }
            continue
        }

        //if set, the blade does damage in start, transition and return anims (like strong style does)
        if Q_stricmp(token, "transitionDamage2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_TRANSITION_DAMAGE2
            }
            continue
        }

        //splashRadius - radius of splashDamage
        if Q_stricmp(token, "splashRadius2") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.splashRadius2 = f
            continue
        }

        //splashDamage - amount of splashDamage, 100% at a distance of 0, 0% at a distance = splashRadius
        if Q_stricmp(token, "splashDamage2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            saber.splashDamage2 = n
            continue
        }

        //splashKnockback - amount of splashKnockback, 100% at a distance of 0, 0% at a distance = splashRadius
        if Q_stricmp(token, "splashKnockback2") == 0 {
            if COM_ParseFloat(&p, &f) {
                SkipRestOfLine(&p)
                continue
            }
            saber.splashKnockback2 = f
            continue
        }

        //hit sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "hit2Sound1") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.hit2Sound[0] = BG_SoundIndex(value)
            continue
        }

        //hit sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "hit2Sound2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.hit2Sound[1] = BG_SoundIndex(value)
            continue
        }

        //hit sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "hit2Sound3") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.hit2Sound[2] = BG_SoundIndex(value)
            continue
        }

        //block sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "block2Sound1") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.block2Sound[0] = BG_SoundIndex(value)
            continue
        }

        //block sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "block2Sound2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.block2Sound[1] = BG_SoundIndex(value)
            continue
        }

        //block sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "block2Sound3") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.block2Sound[2] = BG_SoundIndex(value)
            continue
        }

        //bounce sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "bounce2Sound1") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.bounce2Sound[0] = BG_SoundIndex(value)
            continue
        }

        //bounce sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "bounce2Sound2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.bounce2Sound[1] = BG_SoundIndex(value)
            continue
        }

        //bounce sound - NOTE: must provide all 3!!!
        if Q_stricmp(token, "bounce2Sound3") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            saber.bounce2Sound[2] = BG_SoundIndex(value)
            continue
        }

        //block effect - when saber/sword hits another saber/sword
        if Q_stricmp(token, "blockEffect2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //hit person effect - when saber/sword hits a person
        if Q_stricmp(token, "hitPersonEffect2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //hit other effect - when saber/sword hits sopmething else damagable
        if Q_stricmp(token, "hitOtherEffect2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //blade effect
        if Q_stricmp(token, "bladeEffect2") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            SkipRestOfLine(&p)
            continue
        }

        //if non-zero, the saber will not do the big, white clash flare with other sabers
        if Q_stricmp(token, "noClashFlare2") == 0 {
            if COM_ParseInt(&p, &n) {
                SkipRestOfLine(&p)
                continue
            }
            if n != 0 {
                saber.saberFlags2 |= SFL2_NO_CLASH_FLARE2
            }
            continue
        }
        //===END BLADE-SPECIFIC FIELDS=============================================================================

        //FIXME: saber sounds (on, off, loop)

        SkipRestOfLine(&p)
    }

    //FIXME: precache the saberModel(s)?

    return true
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2574
func WP_SaberParseParm(_ saberName: String, _ parmname: String, _ saberData: inout JKAShared.CharBuf) -> Bool {
    var token: String
    var value: String = ""
    var p = TextCursor()

    // Raven's NULL test on saberName has no form here, and the arm it guards is gone.
    if saberName.isEmpty {
        return false
    }

    //try to parse it out
    p = TextCursor(SaberParms)
    COM_BeginParseSession("saberinfo")

    // look for the right saber
    while !p.isNull {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            return false
        }

        if Q_stricmp(token, saberName) == 0 {
            break
        }

        SkipBracedSection(&p)
    }
    if p.isNull {
        return false
    }

    if BG_ParseLiteral(&p, "{") {
        return false
    }

    // parse the saber info block
    while 1 != 0 {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_RED + "ERROR: unexpected EOF while parsing '%s'\n", saberName)
            return false
        }

        if Q_stricmp(token, "}") == 0 {
            break
        }

        if Q_stricmp(token, parmname) == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            strcpy(&saberData, value)
            return true
        }

        SkipRestOfLine(&p)
        continue
    }

    return false
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2647
func WP_SaberValidForPlayerInMP(_ saberName: String) -> Bool {
    var allowed = CharBuf(8)
    if !WP_SaberParseParm(saberName, "notInMP", &allowed) {
        //not defined, default is yes
        return true
    }
    if allowed[0] == 0 {
        //not defined, default is yes
        return true
    } else {
        //return value
        return (Bool((atoi(allowed) == 0)))
    }
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2664
public func WP_RemoveSaber(_ sabers: Slots<JKAMP.SaberInfo>, _ saberNum: Int32) {
    // Raven assigns his own `sabers` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var sabers = sabers
    // Raven's NULL test on sabers has no form here, and the arm it guards is gone.
    // Raven's arm under the guard has no path, and its text stays here:
    // {
    //         return;
    //     }
    //reset everything for this saber just in case
    WP_SaberSetDefaults(sabers[saberNum])

    strcpy(&sabers[saberNum].nameBuffer, "none")
    sabers[saberNum].model = ""

    //ent->client->ps.dualSabers = qfalse;
    BG_SI_Deactivate(sabers[saberNum])
    BG_SI_SetLength(sabers[saberNum], 0.0)
    //	if ( ent->weaponModel[saberNum] > 0 )
    //	{
    //		gi.G2API_RemoveGhoul2Model( ent->ghoul2, ent->weaponModel[saberNum] );
    //		ent->weaponModel[saberNum] = -1;
    //	}
    //	if ( saberNum == 1 )
    //	{
    //		ent->client->ps.dualSabers = qfalse;
    //	}
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2690
public func WP_SetSaber(_ entNum: Int32, _ sabers: Slots<JKAMP.SaberInfo>, _ saberNum: Int32, _ saberName: String) {
    // Raven assigns his own `sabers` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var sabers = sabers
    // Raven's NULL test on sabers has no form here, and the arm it guards is gone.
    // Raven's arm under the guard has no path, and its text stays here:
    // {
    //         return;
    //     }
    if Q_stricmp("none", saberName) == 0 || Q_stricmp("remove", saberName) == 0 {
        if saberNum != 0 {
            //can't remove saber 0 ever
            WP_RemoveSaber(sabers, saberNum)
        }
        return
    }

    if entNum < MAX_CLIENTS && !WP_SaberValidForPlayerInMP(saberName) {
        WP_SaberParseParms("Kyle", sabers[saberNum]) //get saber info
    } else {
        WP_SaberParseParms(saberName, sabers[saberNum]) //get saber info
    }
    if (sabers[1].saberFlags & SFL_TWO_HANDED) != 0 {
        //not allowed to use a 2-handed saber as second saber
        WP_RemoveSaber(sabers, 1)
        return
    } else if (sabers[0].saberFlags & SFL_TWO_HANDED) != 0 && !sabers[1].model.isEmpty {
        //you can't use a two-handed saber with a second saber, so remove saber 2
        WP_RemoveSaber(sabers, 1)
        return
    }
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2727
func WP_SaberSetColor(_ sabers: Slots<JKAMP.SaberInfo>, _ saberNum: Int32, _ bladeNum: Int32, _ colorName: String) {
    // Port-note: Raven guards a NULL `sabers` here. Swift holds it as a value, so the guard has no form and reads false.
    portMissing("WP_SaberSetColor", source: "oracle/codemp/game/bg_saberLoad.c:2727")
    // Raven's arm under the guard has no path, and its text stays here:
    // {
    //         return;
    //     }
    sabers[saberNum].blade[bladeNum].color = TranslateSaberColor(colorName)
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2738
public func WP_SaberLoadParms() {
    var len: Int32
    var totallen: Int32
    var saberExtFNLen: Int32
    let mainBlockLen: Int32
    let fileCnt: Int32
    var i: Int32
    //const char	*filename = "ext_data/sabers.cfg";
    var holdChar = TextCursor()
    var marker: Int32 = 0
    var saberExtensionListBuf = CharBuf(2048)
    var f: fileHandle_t = 0

    len = 0

    //remember where to store the next one
    mainBlockLen = len
    totallen = mainBlockLen
    marker = totallen
    SaberParms[marker] = 0

    //now load in the extra .sab extensions
    let filled = trap_FS_GetFileList("ext_data/sabers", ".sab", Int32((saberExtensionListBuf).count))
    fileCnt = filled.0
    saberExtensionListBuf = filled.1

    holdChar = TextCursor(saberExtensionListBuf)
    i = 0
    while i < fileCnt {
        saberExtFNLen = strlen(holdChar.text)

        len = trap_FS_FOpenFile(va("ext_data/sabers/%s", holdChar.text), &f, FS_READ)

        if len == -1 {
            Com_Printf("error reading file\n")
        } else {
            if (totallen + len + 1) >= MAX_SABER_DATA_SIZE {
                Com_Error(ERR_DROP, "Saber extensions (*.sab) are too large")
            }

            trap_FS_Read(&bgSaberParseTBuffer, len, f)
            bgSaberParseTBuffer[len] = 0

            len = COM_Compress(&bgSaberParseTBuffer)

            Q_strcat(&SaberParms, MAX_SABER_DATA_SIZE - totallen, String(bgSaberParseTBuffer), at: marker)
            trap_FS_FCloseFile(f)

            //get around the stupid problem of not having an endline at the bottom
            //of a sab file -rww
            Q_strcat(&SaberParms, MAX_SABER_DATA_SIZE - totallen, "\n", at: marker)
            len += 1

            totallen += len
            marker = totallen
        }
        i += 1
        holdChar.advance(by: saberExtFNLen + 1)
    }
}

//---------------------------------------
/// Source: oracle/codemp/game/bg_saberLoad.c:2803
func BG_BLADE_ActivateTrail(_ blade: JKAMP.BladeInfo, _ duration: Float) {
    blade.trail.inAction = 1
    blade.trail.duration = Int32(duration)
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2809
func BG_BLADE_DeactivateTrail(_ blade: JKAMP.BladeInfo, _ duration: Float) {
    blade.trail.inAction = 0
    blade.trail.duration = Int32(duration)
}

//---------------------------------------
/// Source: oracle/codemp/game/bg_saberLoad.c:2815
func BG_SI_Activate(_ saber: JKAMP.SaberInfo) {
    var i: Int32

    i = 0
    while i < saber.numBlades {
        saber.blade[i].active = true
        i += 1
    }
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2825
func BG_SI_Deactivate(_ saber: JKAMP.SaberInfo) {
    var i: Int32

    i = 0
    while i < saber.numBlades {
        saber.blade[i].active = false
        i += 1
    }
}

// Description: Activate a specific Blade of this Saber.
// Created: 10/03/02 by Aurelio Reis, Modified: 10/03/02 by Aurelio Reis.
//	[in]		int iBlade		Which Blade to activate.
//	[in]		bool bActive	Whether to activate it (default true), or deactivate it (false).
//	[return]	void
/// Source: oracle/codemp/game/bg_saberLoad.c:2840
func BG_SI_BladeActivate(_ saber: JKAMP.SaberInfo, _ iBlade: Int32, _ bActive: Bool) {
    // Validate blade ID/Index.
    if iBlade < 0 || iBlade >= saber.numBlades {
        return
    }

    saber.blade[iBlade].active = bActive
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2849
func BG_SI_Active(_ saber: JKAMP.SaberInfo) -> Bool {
    var i: Int32

    i = 0
    while i < saber.numBlades {
        if saber.blade[i].active {
            return true
        }
        i += 1
    }
    return false
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2863
func BG_SI_SetLength(_ saber: JKAMP.SaberInfo, _ length: Float) {
    var i: Int32

    i = 0
    while i < saber.numBlades {
        saber.blade[i].length = length
        i += 1
    }
}

//not in sp, added it for my own convenience
/// Source: oracle/codemp/game/bg_saberLoad.c:2874
func BG_SI_SetDesiredLength(_ saber: JKAMP.SaberInfo, _ len: Float, _ bladeNum: Int32) {
    var i: Int32
    var startBlade: Int32 = 0
    var maxBlades: Int32 = saber.numBlades

    if bladeNum >= 0 && bladeNum < saber.numBlades {
        //doing this on a specific blade
        startBlade = bladeNum
        maxBlades = bladeNum + 1
    }
    i = startBlade
    while i < maxBlades {
        saber.blade[i].desiredLength = len
        i += 1
    }
}

//also not in sp, added it for my own convenience
/// Source: oracle/codemp/game/bg_saberLoad.c:2890
func BG_SI_SetLengthGradual(_ saber: JKAMP.SaberInfo, _ time: Int32) {
    var i: Int32
    var amt: Float
    var dLen: Float

    i = 0
    while i < saber.numBlades {
        dLen = saber.blade[i].desiredLength

        if dLen == -1 {
            //assume we want max blade len
            dLen = saber.blade[i].lengthMax
        }

        if saber.blade[i].length == dLen {
            i += 1
            continue
        }

        if saber.blade[i].length == saber.blade[i].lengthMax || saber.blade[i].length == 0 {
            saber.blade[i].extendDebounce = time
            if saber.blade[i].length == 0 {
                saber.blade[i].length += 1
            } else {
                saber.blade[i].length -= 1
            }
        }

        amt = Float((Double(time) - Double(saber.blade[i].extendDebounce)) * 0.01)

        if amt < 0.2 {
            amt = 0.2
        }

        if saber.blade[i].length < dLen {
            saber.blade[i].length += amt

            if saber.blade[i].length > dLen {
                saber.blade[i].length = dLen
            }
            if saber.blade[i].length > saber.blade[i].lengthMax {
                saber.blade[i].length = saber.blade[i].lengthMax
            }
        } else if saber.blade[i].length > dLen {
            saber.blade[i].length -= amt

            if saber.blade[i].length < dLen {
                saber.blade[i].length = dLen
            }
            if saber.blade[i].length < 0 {
                saber.blade[i].length = 0
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2959
func BG_SI_Length(_ saber: JKAMP.SaberInfo) -> Float {
    //return largest length
    var len1: Int32 = 0
    var i: Int32

    i = 0
    while i < saber.numBlades {
        if saber.blade[i].length > len1 {
            len1 = Int32(saber.blade[i].length)
        }
        i += 1
    }
    return Float(len1)
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2974
func BG_SI_LengthMax(_ saber: JKAMP.SaberInfo) -> Float {
    var len1: Int32 = 0
    var i: Int32

    i = 0
    while i < saber.numBlades {
        if saber.blade[i].lengthMax > len1 {
            len1 = Int32(saber.blade[i].lengthMax)
        }
        i += 1
    }
    return Float(len1)
}

/// Source: oracle/codemp/game/bg_saberLoad.c:2989
func BG_SI_ActivateTrail(_ saber: JKAMP.SaberInfo, _ duration: Float) {
    var i: Int32

    i = 0
    while i < saber.numBlades {
        //saber->blade[i].ActivateTrail( duration );
        BG_BLADE_ActivateTrail(saber.blade[i], duration)
        i += 1
    }
}

/// Source: oracle/codemp/game/bg_saberLoad.c:3000
func BG_SI_DeactivateTrail(_ saber: JKAMP.SaberInfo, _ duration: Float) {
    var i: Int32

    i = 0
    while i < saber.numBlades {
        //saber->blade[i].DeactivateTrail( duration );
        BG_BLADE_DeactivateTrail(saber.blade[i], duration)
        i += 1
    }
}
