import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_event.c:1429
/// Raven's data table, a hand property of `CGameWorld`.
var cg_stringEdVoiceChatTable: [String?] { world.cg_stringEdVoiceChatTable }

/**
```
===================
CG_PlaceString

Also called by scoreboard drawing
===================
```
*/
/// Source: oracle/codemp/cgame/cg_event.c:45
func CG_PlaceString(_ rank: Int32) -> String {
    // Port-note: A static local `str` the function returns, storage that outlives the call.
    // Raven wrote: static char str[64];
    portMissing("CG_PlaceString", source: "oracle/codemp/cgame/cg_event.c:45")
    var s: String
    // Port-note: A pointer local `char * t` with no view.
    // Raven wrote: t;
    portMissing("CG_PlaceString", source: "oracle/codemp/cgame/cg_event.c:45")
    // number extenstions, eg 1st, 2nd, 3rd, 4th etc.
    // note that the rules are different for french, but by changing the required strip strings they seem to work
    var sST = CharBuf(10)
    var sND = CharBuf(10)
    var sRD = CharBuf(10)
    var sTH = CharBuf(10)
    var sTiedFor = CharBuf(64)
    // Raven assigns his own `rank` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var rank = rank

    strcpy(&sST, trap_SP_GetStringTextString("MP_INGAME_NUMBER_ST", Int32((sST).count)).1)
    strcpy(&sND, trap_SP_GetStringTextString("MP_INGAME_NUMBER_ND", Int32((sND).count)).1)
    strcpy(&sRD, trap_SP_GetStringTextString("MP_INGAME_NUMBER_RD", Int32((sRD).count)).1)
    strcpy(&sTH, trap_SP_GetStringTextString("MP_INGAME_NUMBER_TH", Int32((sTH).count)).1)
    strcpy(&sTiedFor, trap_SP_GetStringTextString("MP_INGAME_TIED_FOR", Int32((sTiedFor).count)).1)
    strcat(&sTiedFor, " ") // save worrying about translators adding spaces or not

    if (rank & RANK_TIED_FLAG) != 0 {
        rank &= ~RANK_TIED_FLAG
        // Port-note: A store into `t`, a local the draft left as a hole.
        // Raven wrote: t = sTiedFor
        portMissing("CG_PlaceString", source: "oracle/codemp/cgame/cg_event.c:45")
    } else {
        // Port-note: A store into `t`, a local the draft left as a hole.
        // Raven wrote: t = ""
        portMissing("CG_PlaceString", source: "oracle/codemp/cgame/cg_event.c:45")
    }

    if rank == 1 {
        s = va("1%s", sST) //S_COLOR_BLUE "1st" S_COLOR_WHITE;		// draw in blue
    } else if rank == 2 {
        s = va("2%s", sND) //S_COLOR_RED "2nd" S_COLOR_WHITE;		// draw in red
    } else if rank == 3 {
        s = va("3%s", sRD) //S_COLOR_YELLOW "3rd" S_COLOR_WHITE;		// draw in yellow
    } else if rank == 11 {
        s = va("11%s", sTH)
    } else if rank == 12 {
        s = va("12%s", sTH)
    } else if rank == 13 {
        s = va("13%s", sTH)
    } else if rank % 10 == 1 {
        s = va("%i%s", rank, sST)
    } else if rank % 10 == 2 {
        s = va("%i%s", rank, sND)
    } else if rank % 10 == 3 {
        s = va("%i%s", rank, sRD)
    } else {
        s = va("%i%s", rank, sTH)
    }

    // Port-note: A read of `str`, a local the draft left as a hole.
    // Raven wrote: Com_sprintf( str, sizeof( str ), "%s%s", t, s )
    portMissing("CG_PlaceString", source: "oracle/codemp/cgame/cg_event.c:45")
    // Port-note: A read of `str`, a local the draft left as a hole.
    // Raven wrote: return str
    portMissing("CG_PlaceString", source: "oracle/codemp/cgame/cg_event.c:45")
}

/**
```
=============
CG_Obituary
=============
```
*/
/// Source: oracle/codemp/cgame/cg_event.c:103
private func CG_Obituary(_ ent: JKAMP.EntityState) {
    let mod: Int32
    let target: Int32
    let attacker: Int32
    var message: String? = nil
    let targetInfo: String
    var attackerInfo: String? = nil
    var targetName = CharBuf(32)
    var targetVehName = CharBuf(32)
    var attackerName = CharBuf(32)
    var attackerVehName = CharBuf(32)
    var attackerVehWeapName = CharBuf(32)
    var gender: gender_t
    var ci: ClientInfo?
    var vehMessage: Bool = false

    clientkilled: do {
        target = ent.otherEntityNum
        attacker = ent.otherEntityNum2
        mod = ent.eventParm

        if target < 0 || target >= MAX_CLIENTS {
            CG_Error("CG_Obituary: target out of range")
        }
        ci = cgs.clientinfo[target]

        if attacker < 0 || attacker >= MAX_CLIENTS {
            //attacker = ENTITYNUM_WORLD;
            attackerInfo = nil
        } else {
            attackerInfo = CG_ConfigString(CS_PLAYERS + attacker)
        }

        targetInfo = CG_ConfigString(CS_PLAYERS + target)
        Q_strncpyz(&targetName, Info_ValueForKey(targetInfo, "n"), Int32((targetName).count) - 2)
        strcat(&targetName, S_COLOR_WHITE)

        // check for target in a vehicle
        if ent.lookTarget > VEHICLE_BASE && ent.lookTarget < MAX_VEHICLES && g_vehicleInfo[ent.lookTarget].name != nil {
            Q_strncpyz(&targetVehName, g_vehicleInfo[ent.lookTarget].name!, Int32((targetVehName).count) - 2)
        }

        // check for attacker in a vehicle
        if ent.brokenLimbs >= MAX_CLIENTS {
            let attVehCent: Centity? = cg_entities[ent.brokenLimbs]
            if attVehCent != nil && attVehCent!.m_pVehicle != nil && attVehCent!.m_pVehicle!.m_pVehicleInfo != nil {
                if attVehCent!.m_pVehicle!.m_pVehicleInfo!.name != nil {
                    Q_strncpyz(&attackerVehName, attVehCent!.m_pVehicle!.m_pVehicleInfo!.name!, Int32((attackerVehName).count) - 2)
                }
            }
        }

        //check for specific vehicle weapon
        if ent.weapon > 0 {
            if g_vehWeaponInfo[ent.weapon - 1].name != nil {
                Q_strncpyz(&attackerVehWeapName, g_vehWeaponInfo[ent.weapon - 1].name!, Int32((attackerVehWeapName).count) - 2)
            }
        }

        // check for single client messages

        if ent.saberInFlight {
            //asteroid->vehicle collision
            switch Q_irand(0, 2) {
            case 1:
                message = "DIED_ASTEROID2"

            case 2:
                message = "DIED_ASTEROID3"

            default:
                message = "DIED_ASTEROID1"
            }
            vehMessage = true
        } else {
            switch mod {
            case MOD_VEHICLE, MOD_SUICIDE, MOD_FALLING, MOD_COLLISION, MOD_VEH_EXPLOSION, MOD_CRUSH, MOD_WATER, MOD_SLIME, MOD_LAVA, MOD_TRIGGER_HURT:
                message = "DIED_GENERIC"

            case MOD_TARGET_LASER:
                vehMessage = true
                message = "DIED_TURBOLASER"

            default:
                message = nil
            }
        }

        // Attacker killed themselves.  Ridicule them for it.
        if attacker == target {
            vehMessage = false
            gender = ci!.gender
            switch mod {
            case MOD_BRYAR_PISTOL, MOD_BRYAR_PISTOL_ALT, MOD_BLASTER, MOD_TURBLAST, MOD_DISRUPTOR, MOD_DISRUPTOR_SPLASH, MOD_DISRUPTOR_SNIPER, MOD_BOWCASTER, MOD_REPEATER, MOD_REPEATER_ALT, MOD_FLECHETTE:
                if gender == GENDER_FEMALE {
                    message = "SUICIDE_SHOT_FEMALE"
                } else if gender == GENDER_NEUTER {
                    message = "SUICIDE_SHOT_GENDERLESS"
                } else {
                    message = "SUICIDE_SHOT_MALE"
                }

            case MOD_REPEATER_ALT_SPLASH, MOD_FLECHETTE_ALT_SPLASH, MOD_ROCKET, MOD_ROCKET_SPLASH, MOD_ROCKET_HOMING, MOD_ROCKET_HOMING_SPLASH, MOD_THERMAL, MOD_THERMAL_SPLASH, MOD_TRIP_MINE_SPLASH, MOD_TIMED_MINE_SPLASH, MOD_DET_PACK_SPLASH, MOD_VEHICLE, MOD_CONC, MOD_CONC_ALT:
                if gender == GENDER_FEMALE {
                    message = "SUICIDE_EXPLOSIVES_FEMALE"
                } else if gender == GENDER_NEUTER {
                    message = "SUICIDE_EXPLOSIVES_GENDERLESS"
                } else {
                    message = "SUICIDE_EXPLOSIVES_MALE"
                }

            case MOD_DEMP2:
                if gender == GENDER_FEMALE {
                    message = "SUICIDE_ELECTROCUTED_FEMALE"
                } else if gender == GENDER_NEUTER {
                    message = "SUICIDE_ELECTROCUTED_GENDERLESS"
                } else {
                    message = "SUICIDE_ELECTROCUTED_MALE"
                }

            case MOD_FALLING:
                if gender == GENDER_FEMALE {
                    message = "SUICIDE_FALLDEATH_FEMALE"
                } else if gender == GENDER_NEUTER {
                    message = "SUICIDE_FALLDEATH_GENDERLESS"
                } else {
                    message = "SUICIDE_FALLDEATH_MALE"
                }

            default:
                if gender == GENDER_FEMALE {
                    message = "SUICIDE_GENERICDEATH_FEMALE"
                } else if gender == GENDER_NEUTER {
                    message = "SUICIDE_GENERICDEATH_GENDERLESS"
                } else {
                    message = "SUICIDE_GENERICDEATH_MALE"
                }
            }
        }

        if target != attacker && target < MAX_CLIENTS && attacker < MAX_CLIENTS {
            break clientkilled
        }

        if message != nil {
            gender = ci!.gender

            if message!.isEmpty {
                vehMessage = false
                if gender == GENDER_FEMALE {
                    message = "SUICIDE_GENERICDEATH_FEMALE"
                } else if gender == GENDER_NEUTER {
                    message = "SUICIDE_GENERICDEATH_GENDERLESS"
                } else {
                    message = "SUICIDE_GENERICDEATH_MALE"
                }
            }
            if vehMessage {
                message = CG_GetStringEdString("MP_INGAMEVEH", message)
            } else {
                message = CG_GetStringEdString("MP_INGAME", message)
            }

            CG_Printf("%s %s\n", targetName, message!)
            return
        }

    }

    // check for kill messages from the current clientNum
    if attacker == cg.snap!.ps.clientNum {
        var s: String

        if cgs.gametype < GT_TEAM && cgs.gametype != GT_DUEL && cgs.gametype != GT_POWERDUEL {
            if cgs.gametype == GT_JEDIMASTER && attacker < MAX_CLIENTS && !ent.isJediMaster && !cg.snap!.ps.isJediMaster && CG_ThereIsAMaster() {
                var part1 = CharBuf(512)
                var part2 = CharBuf(512)
                strcpy(&part1, trap_SP_GetStringTextString("MP_INGAME_KILLED_MESSAGE", Int32((part1).count)).1)
                strcpy(&part2, trap_SP_GetStringTextString("MP_INGAME_JMKILLED_NOTJM", Int32((part2).count)).1)
                s = va("%s %s\n%s\n", part1, targetName, part2)
            } else if cgs.gametype == GT_JEDIMASTER && attacker < MAX_CLIENTS && !ent.isJediMaster && !cg.snap!.ps.isJediMaster {
                //no JM, saber must be out
                var part1 = CharBuf(512)
                strcpy(&part1, trap_SP_GetStringTextString("MP_INGAME_KILLED_MESSAGE", Int32((part1).count)).1)
                /*
                kmsg1 = "for 0 points.\nGo for the saber!";
                strcpy(part2, kmsg1);

                s = va("%s %s %s\n", part1, targetName, part2);
                */
                s = va("%s %s\n", part1, targetName)
            } else if cgs.gametype == GT_POWERDUEL {
                s = ""
            } else {
                var sPlaceWith = CharBuf(256)
                var sKilledStr = CharBuf(256)
                strcpy(&sPlaceWith, trap_SP_GetStringTextString("MP_INGAME_PLACE_WITH", Int32((sPlaceWith).count)).1)
                strcpy(&sKilledStr, trap_SP_GetStringTextString("MP_INGAME_KILLED_MESSAGE", Int32((sKilledStr).count)).1)

                s = va("%s %s.\n%s %s %i.", sKilledStr, targetName, CG_PlaceString(cg.snap!.ps.persistant[PERS_RANK] + 1), sPlaceWith, cg.snap!.ps.persistant[PERS_SCORE])
            }
        } else {
            var sKilledStr = CharBuf(256)
            strcpy(&sKilledStr, trap_SP_GetStringTextString("MP_INGAME_KILLED_MESSAGE", Int32((sKilledStr).count)).1)
            s = va("%s %s", sKilledStr, targetName)
        }
        //if (!(cg_singlePlayerActive.integer && cg_cameraOrbit.integer)) {
        CG_CenterPrint(s, Int32(Double(SCREEN_HEIGHT) * 0.30), BIGCHAR_WIDTH)
        //}
        // print the text message as well
    }

    // check for double client messages
    if attackerInfo == nil {
        //attacker = ENTITYNUM_WORLD;
        strcpy(&attackerName, "noname")
    } else {
        Q_strncpyz(&attackerName, Info_ValueForKey(attackerInfo!, "n"), Int32((attackerName).count) - 2)
        strcat(&attackerName, S_COLOR_WHITE)
        // check for kill messages about the current clientNum
        if target == cg.snap!.ps.clientNum {
            Q_strncpyz(&cg.killerNameBuffer, String(attackerName), 32)
        }
    }

    if attacker != ENTITYNUM_WORLD {
        switch mod {
        case MOD_STUN_BATON:
            message = "KILLED_STUN"

        case MOD_MELEE:
            message = "KILLED_MELEE"

        case MOD_SABER:
            message = "KILLED_SABER"

        case MOD_BRYAR_PISTOL, MOD_BRYAR_PISTOL_ALT:
            message = "KILLED_BRYAR"

        case MOD_BLASTER:
            message = "KILLED_BLASTER"

        case MOD_TURBLAST:
            message = "KILLED_BLASTER"

        case MOD_DISRUPTOR, MOD_DISRUPTOR_SPLASH:
            message = "KILLED_DISRUPTOR"

        case MOD_DISRUPTOR_SNIPER:
            message = "KILLED_DISRUPTORSNIPE"

        case MOD_BOWCASTER:
            message = "KILLED_BOWCASTER"

        case MOD_REPEATER:
            message = "KILLED_REPEATER"

        case MOD_REPEATER_ALT, MOD_REPEATER_ALT_SPLASH:
            message = "KILLED_REPEATERALT"

        case MOD_DEMP2, MOD_DEMP2_ALT:
            message = "KILLED_DEMP2"

        case MOD_FLECHETTE:
            message = "KILLED_FLECHETTE"

        case MOD_FLECHETTE_ALT_SPLASH:
            message = "KILLED_FLECHETTE_MINE"

        case MOD_ROCKET, MOD_ROCKET_SPLASH:
            message = "KILLED_ROCKET"

        case MOD_ROCKET_HOMING, MOD_ROCKET_HOMING_SPLASH:
            message = "KILLED_ROCKET_HOMING"

        case MOD_THERMAL, MOD_THERMAL_SPLASH:
            message = "KILLED_THERMAL"

        case MOD_TRIP_MINE_SPLASH:
            message = "KILLED_TRIPMINE"

        case MOD_TIMED_MINE_SPLASH:
            message = "KILLED_TRIPMINE_TIMED"

        case MOD_DET_PACK_SPLASH:
            message = "KILLED_DETPACK"

        case MOD_VEHICLE:
            vehMessage = true
            switch ent.generic1 {
            case WP_BLASTER: //primary blasters
                switch Q_irand(0, 2) {
                case 2:
                    message = "KILLED_VEH_BLASTER3"

                case 1:
                    message = "KILLED_VEH_BLASTER2"

                default:
                    message = "KILLED_VEH_BLASTER1"
                }

            case WP_ROCKET_LAUNCHER: //missile
                if Q_irand(0, 1) != 0 {
                    message = "KILLED_VEH_MISSILE2"
                } else {
                    message = "KILLED_VEH_MISSILE1"
                }

            case WP_THERMAL: //bomb
                message = "KILLED_VEH_BOMB"

            case WP_DEMP2: //ion cannon
                message = "KILLED_VEH_ION"

            case WP_TURRET: //turret
                message = "KILLED_VEH_TURRET"

            default:
                vehMessage = false
                message = "KILLED_GENERIC"
            }

        case MOD_CONC, MOD_CONC_ALT:
            message = "KILLED_GENERIC"

        case MOD_FORCE_DARK:
            message = "KILLED_DARKFORCE"

        case MOD_SENTRY:
            message = "KILLED_SENTRY"

        case MOD_TELEFRAG:
            message = "KILLED_TELEFRAG"

        case MOD_CRUSH:
            message = "KILLED_GENERIC" //"KILLED_FORCETOSS";

        case MOD_FALLING:
            message = "KILLED_FORCETOSS"

        case MOD_COLLISION, MOD_VEH_EXPLOSION:
            switch Q_irand(0, 2) {
            case 1:
                message = "KILLED_VEH_COLLISION2"

            case 2:
                message = "KILLED_VEH_COLLISION3"

            default:
                message = "KILLED_VEH_COLLISION1"
            }
            vehMessage = true

        case MOD_TRIGGER_HURT:
            message = "KILLED_GENERIC" //"KILLED_FORCETOSS";

        case MOD_TARGET_LASER:
            if Q_irand(0, 1) != 0 {
                message = "KILLED_TURRET1"
            } else {
                message = "KILLED_TURRET2"
            }
            vehMessage = true

        default:
            message = "KILLED_GENERIC"
        }

        if message != nil {
            if vehMessage {
                message = CG_GetStringEdString("MP_INGAMEVEH", message)
            } else {
                message = CG_GetStringEdString("MP_INGAME", message)
            }

            CG_Printf("%s ", targetName)
            if targetVehName[0] != 0 {
                CG_Printf("(%s) ", targetVehName)
            }
            if mod == MOD_TARGET_LASER {
                //no attacker name, just a turbolaser or other kind of turret...
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot force unwrap value of non-optional type 'String'".
                // Raven wrote: CG_Printf( "%s", message)
                portMissing("CG_Obituary", source: "oracle/codemp/cgame/cg_event.c:103")
            } else {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot force unwrap value of non-optional type 'String'".
                // Raven wrote: CG_Printf( "%s %s", message, attackerName)
                portMissing("CG_Obituary", source: "oracle/codemp/cgame/cg_event.c:103")

                if attackerVehName[0] != 0 && attackerVehWeapName[0] != 0 {
                    CG_Printf(" (%s %s)", attackerVehName, attackerVehWeapName)
                } else {
                    if attackerVehName[0] != 0 {
                        CG_Printf(" (%s)", attackerVehName)
                    } else if attackerVehWeapName[0] != 0 {
                        CG_Printf(" (%s)", attackerVehWeapName)
                    }
                }
            }
            CG_Printf("\n")
            return
        }
    }

    // we don't know what it was
    CG_Printf("%s %s\n", targetName, CG_GetStringEdString("MP_INGAME", "DIED_GENERIC"))
}

/// Source: oracle/codemp/cgame/cg_event.c:611
func CG_ToggleBinoculars(_ cent: Centity, _ forceZoom: Int32) {
    if cent.currentState.number != cg.snap!.ps.clientNum {
        return
    }

    if cg.snap!.ps.weaponstate != WEAPON_READY {
        //So we can't fool it and reactivate while switching to the saber or something.
        return
    }

    /*
    if (cg.snap->ps.weapon == WP_SABER)
    { //No.
    return;
    }
    */

    if forceZoom != 0 {
        if forceZoom == 2 {
            cg.snap!.ps.zoomMode = 0
        } else if forceZoom == 1 {
            cg.snap!.ps.zoomMode = 2
        }
    }

    if cg.snap!.ps.zoomMode == 0 {
        trap_S_StartSound(nil, cg.snap!.ps.clientNum, CHAN_AUTO, cgs.media.zoomStart)
    } else if cg.snap!.ps.zoomMode == 2 {
        trap_S_StartSound(nil, cg.snap!.ps.clientNum, CHAN_AUTO, cgs.media.zoomEnd)
    }
}

/// Source: oracle/codemp/cgame/cg_event.c:656
func CG_LocalTimingBar(_ startTime: Int32, _ duration: Int32) {
    cg_genericTimerBar = startTime + duration
    cg_genericTimerDur = duration

    cg_genericTimerColor[0] = 1.0
    cg_genericTimerColor[1] = 1.0
    cg_genericTimerColor[2] = 0.0
    cg_genericTimerColor[3] = 1.0
}

/**
```
===============
CG_UseItem
===============
```
*/
/// Source: oracle/codemp/cgame/cg_event.c:672
private func CG_UseItem(_ cent: Centity) {
    var ci: ClientInfo?
    var itemNum: Int32
    let clientNum: Int32
    var item: Gitem?
    var es: EntityState?

    es = cent.currentState

    itemNum = (es!.event & ~EV_EVENT_BITS) - EV_USE_ITEM0
    if itemNum < 0 || itemNum > HI_NUM_HOLDABLE {
        itemNum = 0
    }

    // print a message if the local player
    if es!.number == cg.snap!.ps.clientNum {
        if itemNum == 0 {
            //CG_CenterPrint( "No item to use", SCREEN_HEIGHT * 0.30, BIGCHAR_WIDTH );
        } else {
            item = BG_FindItemForHoldable(itemNum)
        }
    }

    switch itemNum {
    case HI_BINOCULARS:
        CG_ToggleBinoculars(cent, es!.eventParm)

    case HI_SEEKER:
        trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.deploySeeker)

    case HI_SHIELD, HI_SENTRY_GUN:
        //	case HI_MEDKIT:
        break

    case HI_MEDPAC, HI_MEDPAC_BIG:
        clientNum = cent.currentState.clientNum
        if clientNum >= 0 && clientNum < MAX_CLIENTS {
            ci = cgs.clientinfo[clientNum]
            ci!.medkitUsageTime = cg.time
        }
        //Different sound for big bacta?
        trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.medkitSound)

    case HI_JETPACK:
        break

    case HI_HEALTHDISP:
        //CG_LocalTimingBar(cg.time, TOSS_DEBOUNCE_TIME);
        break

    case HI_AMMODISP:
        //CG_LocalTimingBar(cg.time, TOSS_DEBOUNCE_TIME);
        break

    case HI_EWEB:
        break

    case HI_CLOAK:
        break

    default:
        //trap_S_StartSound (NULL, es->number, CHAN_BODY, cgs.media.useNothingSound );
        break
    }

    if cg.snap != nil && cg.snap!.ps.clientNum == cent.currentState.number && itemNum != HI_BINOCULARS && itemNum != HI_JETPACK && itemNum != HI_HEALTHDISP && itemNum != HI_AMMODISP && itemNum != HI_CLOAK && itemNum != HI_EWEB {
        //if not using binoculars/jetpack/dispensers/cloak, we just used that item up, so switch
        BG_CycleInven(cg.snap!.ps, 1)
        cg.itemSelect = -1 //update the client-side selection display
    }
}

/**
```
================
CG_ItemPickup

A new item was picked up this frame
================
```
*/
/// Source: oracle/codemp/cgame/cg_event.c:753
private func CG_ItemPickup(_ itemNum: Int32) {
    cg.itemPickup = itemNum
    cg.itemPickupTime = cg.time
    cg.itemPickupBlendTime = cg.time
    // see if it should be the grabbed weapon
    if cg.snap != nil && bg_itemlist[itemNum].giType == IT_WEAPON {
        // 0 == no switching
        // 1 == automatically switch to best SAFE weapon
        // 2 == automatically switch to best weapon, safe or otherwise
        // 3 == if not saber, automatically switch to best weapon, safe or otherwise

        if 0 == cg_autoswitch.integer {
            // don't switch
        } else if cg_autoswitch.integer == 1 {
            //only autoselect if not explosive ("safe")
            if bg_itemlist[itemNum].giTag != WP_TRIP_MINE && bg_itemlist[itemNum].giTag != WP_DET_PACK && bg_itemlist[itemNum].giTag != WP_THERMAL && bg_itemlist[itemNum].giTag != WP_ROCKET_LAUNCHER && bg_itemlist[itemNum].giTag > cg.snap!.ps.weapon && cg.snap!.ps.weapon != WP_SABER {
                if cg.snap!.ps.emplacedIndex == 0 {
                    cg.weaponSelectTime = cg.time
                }
                cg.weaponSelect = bg_itemlist[itemNum].giTag
            }
        } else if cg_autoswitch.integer == 2 {
            //autoselect if better
            if bg_itemlist[itemNum].giTag > cg.snap!.ps.weapon && cg.snap!.ps.weapon != WP_SABER {
                if cg.snap!.ps.emplacedIndex == 0 {
                    cg.weaponSelectTime = cg.time
                }
                cg.weaponSelect = bg_itemlist[itemNum].giTag
            }
        }
        /*
        else if ( cg_autoswitch.integer == 3)
        { //autoselect if better and not using the saber as a weapon
        if (bg_itemlist[itemNum].giTag > cg.snap->ps.weapon &&
        cg.snap->ps.weapon != WP_SABER)
        {
        if (!cg.snap->ps.emplacedIndex)
        {
        cg.weaponSelectTime = cg.time;
        }
        cg.weaponSelect = bg_itemlist[itemNum].giTag;
        }
        }
        */
        //No longer required - just not switching ever if using saber
    }

    //rww - print pickup messages
    if bg_itemlist[itemNum].classname != nil && !bg_itemlist[itemNum].classname!.isEmpty && (bg_itemlist[itemNum].giType != IT_TEAM || (bg_itemlist[itemNum].giTag != PW_REDFLAG && bg_itemlist[itemNum].giTag != PW_BLUEFLAG)) {
        //don't print messages for flags, they have their own pickup event broadcasts
        var text = CharBuf(1024)
        var upperKey = CharBuf(1024)

        strcpy(&upperKey, bg_itemlist[itemNum].classname!)

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'CharBuf' to expected argument type 'String'".
        // Raven wrote: if ( trap_SP_GetStringTextString( va("SP_INGAME_%s",Q_strupr(upperKey)), text, sizeof( text ))) { Com_Printf("%s %s\n", CG_GetStringEdString("MP_INGAME", "PICKUPLINE"), text); } else { Com_Printf("%s %s\n", CG_GetStringEdString("MP_INGAME", "PICKUPLINE"), bg_itemlist[itemNum].classname); }
        portMissing("CG_ItemPickup", source: "oracle/codemp/cgame/cg_event.c:753")
    }
}

/**
```
================
CG_PainEvent

Also called by playerstate transition
================
```
*/
/// Source: oracle/codemp/cgame/cg_event.c:842
func CG_PainEvent(_ cent: Centity, _ health: Int32) {
    var snd: String

    // don't do more than two pain sounds a second
    if cg.time - cent.pe.painTime < 500 {
        return
    }

    if health < 25 {
        snd = "*pain25.wav"
    } else if health < 50 {
        snd = "*pain50.wav"
    } else if health < 75 {
        snd = "*pain75.wav"
    } else {
        snd = "*pain100.wav"
    }
    trap_S_StartSound(nil, cent.currentState.number, CHAN_VOICE, CG_CustomSound(cent.currentState.number, snd))

    // save pain time for programitic twitch animation
    cent.pe.painTime = cg.time
    cent.pe.painDirection ^= 1
}

/// Source: oracle/codemp/cgame/cg_event.c:868
func CG_ReattachLimb(_ source: Centity) {
    var ci: ClientInfo? = nil

    if source.currentState.number >= MAX_CLIENTS {
        ci = source.npcClient
    } else {
        ci = cgs.clientinfo[source.currentState.number]
    }
    if ci != nil {
        //re-apply the skin
        if ci!.torsoSkin > 0 {
            trap_G2API_SetSkin(source.ghoul2, 0, ci!.torsoSkin, ci!.torsoSkin)
        }
    }

    /*
    char *limbName;
    char *stubCapName;
    int i = G2_MODELPART_HEAD;

    //rww NOTE: Assumes G2_MODELPART_HEAD is first and G2_MODELPART_RLEG is last
    while (i <= G2_MODELPART_RLEG)
    {
    if (source->torsoBolt & (1 << (i-10)))
    {
    switch (i)
    {
    case G2_MODELPART_HEAD:
    limbName = "head";
    stubCapName = "torso_cap_head";
    break;
    case G2_MODELPART_WAIST:
    limbName = "torso";
    stubCapName = "hips_cap_torso";
    break;
    case G2_MODELPART_LARM:
    limbName = "l_arm";
    stubCapName = "torso_cap_l_arm";
    break;
    case G2_MODELPART_RARM:
    limbName = "r_arm";
    stubCapName = "torso_cap_r_arm";
    break;
    case G2_MODELPART_RHAND:
    limbName = "r_hand";
    stubCapName = "r_arm_cap_r_hand";
    break;
    case G2_MODELPART_LLEG:
    limbName = "l_leg";
    stubCapName = "hips_cap_l_leg";
    break;
    case G2_MODELPART_RLEG:
    limbName = "r_leg";
    stubCapName = "hips_cap_r_leg";
    break;
    default:
    source->torsoBolt = 0;
    source->ghoul2weapon = NULL;
    return;
    }

    trap_G2API_SetSurfaceOnOff(source->ghoul2, limbName, 0);
    trap_G2API_SetSurfaceOnOff(source->ghoul2, stubCapName, 0x00000100);
    }
    i++;
    }
    */
    source.torsoBolt = 0

    source.ghoul2weapon = nil
}

/// Source: oracle/codemp/cgame/cg_event.c:945
func CG_TeamName(_ team: Int32) -> String {
    if team == TEAM_RED {
        return "RED"
    } else if team == TEAM_BLUE {
        return "BLUE"
    } else if team == TEAM_SPECTATOR {
        return "SPECTATOR"
    }
    return "FREE"
}

/// Source: oracle/codemp/cgame/cg_event.c:956
func CG_PrintCTFMessage(_ ci: ClientInfo, _ teamName: String, _ ctfMessage: Int32) {
    var printMsg = CharBuf(1024)
    var refName: String? = nil
    var psStringEDString: String? = nil

    doPrint: do {
        switch ctfMessage {
        case CTFMESSAGE_FRAGGED_FLAG_CARRIER:
            refName = "FRAGGED_FLAG_CARRIER"

        case CTFMESSAGE_FLAG_RETURNED:
            refName = "FLAG_RETURNED"

        case CTFMESSAGE_PLAYER_RETURNED_FLAG:
            refName = "PLAYER_RETURNED_FLAG"

        case CTFMESSAGE_PLAYER_CAPTURED_FLAG:
            refName = "PLAYER_CAPTURED_FLAG"

        case CTFMESSAGE_PLAYER_GOT_FLAG:
            refName = "PLAYER_GOT_FLAG"

        default:
            return
        }

        psStringEDString = CG_GetStringEdString("MP_INGAME", refName)

        if psStringEDString == nil || psStringEDString!.isEmpty {
            return
        }

        if !teamName.isEmpty {
            // Port-note: A pointer local `const char * f` with no view.
            // Raven wrote: const char *f = strstr(psStringEDString, "%s");
            portMissing("CG_PrintCTFMessage", source: "oracle/codemp/cgame/cg_event.c:956")

            // Port-note: A read of `f`, a local the draft left as a hole.
            // Raven wrote: if (f) { int strLen = 0; int i = 0; if (ci) { Com_sprintf(printMsg, sizeof(printMsg), "%s ", ci->name); strLen = strlen(printMsg); } while (psStringEDString[i] && i < 512) { if (psStringEDString[i] == '%' && psStringEDString[i+1] == 's') { printMsg[strLen] = '\0'; Q_strcat(printMsg, sizeof(printMsg), teamName); strLen = strlen(printMsg); i++; } else { printMsg[strLen] = psStringEDString[i]; strLen++; } i++; } printMsg[strLen] = '\0'; goto doPrint; }
            portMissing("CG_PrintCTFMessage", source: "oracle/codemp/cgame/cg_event.c:956")
        }

        Com_sprintf(&printMsg, Int32((printMsg).count), "%s %s", ci.name, psStringEDString!)

    }
    Com_Printf("%s\n", printMsg)
}

/// Source: oracle/codemp/cgame/cg_event.c:1044
func CG_GetCTFMessageEvent(_ es: JKAMP.EntityState) {
    let clIndex: Int32 = es.trickedentindex
    let teamIndex: Int32 = es.trickedentindex2
    var ci: ClientInfo? = nil
    var teamName: String? = nil

    if clIndex < MAX_CLIENTS {
        ci = cgs.clientinfo[clIndex]
    }

    if teamIndex < 50 {
        teamName = CG_TeamName(teamIndex)
    }

    if ci == nil {
        return
    }

    CG_PrintCTFMessage(ci!, teamName!, es.eventParm)
}

/// Source: oracle/codemp/cgame/cg_event.c:1078
func DoFall(_ cent: Centity, _ es: JKAMP.EntityState, _ clientNum: Int32) {
    let delta: Int32 = es.eventParm

    if (cent.currentState.eFlags & EF_DEAD) != 0 {
        //corpses crack into the ground ^_^
        if delta > 25 {
            trap_S_StartSound(nil, es.number, CHAN_AUTO, cgs.media.fallSound)
        } else {
            trap_S_StartSound(nil, es.number, CHAN_AUTO, trap_S_RegisterSound("sound/movers/objects/objectHit.wav"))
        }
    } else if BG_InKnockDownOnly(es.legsAnim) {
        if delta > 14 {
            trap_S_StartSound(nil, es.number, CHAN_AUTO, cgs.media.fallSound)
        } else {
            trap_S_StartSound(nil, es.number, CHAN_AUTO, trap_S_RegisterSound("sound/movers/objects/objectHit.wav"))
        }
    } else if delta > 50 {
        trap_S_StartSound(nil, es.number, CHAN_AUTO, cgs.media.fallSound)
        trap_S_StartSound(nil, cent.currentState.number, CHAN_VOICE, CG_CustomSound(cent.currentState.number, "*land1.wav"))
        cent.pe.painTime = cg.time // don't play a pain sound right after this
    } else if delta > 44 {
        trap_S_StartSound(nil, es.number, CHAN_AUTO, cgs.media.fallSound)
        trap_S_StartSound(nil, cent.currentState.number, CHAN_VOICE, CG_CustomSound(cent.currentState.number, "*land1.wav"))
        cent.pe.painTime = cg.time // don't play a pain sound right after this
    } else {
        trap_S_StartSound(nil, es.number, CHAN_AUTO, cgs.media.landSound)
    }

    if clientNum == cg.predictedPlayerState.clientNum {
        // smooth landing z changes
        cg.landChange = Float(-delta)
        if cg.landChange > 32 {
            cg.landChange = 32
        }
        if cg.landChange < -32 {
            cg.landChange = -32
        }
        cg.landTime = cg.time
    }
    //JLFRUMBLE

    /*		else if (delta > 44)
    FF_XboxDamage(44, 0);
    else
    FF_XboxDamage(20, 0);
    */
}

/// Source: oracle/codemp/cgame/cg_event.c:1170
func CG_InClientBitflags(_ ent: JKAMP.EntityState, _ client: Int32) -> Int32 {
    var checkIn: Int32
    var sub: Int32 = 0

    if client > 47 {
        checkIn = ent.trickedentindex4
        sub = 48
    } else if client > 31 {
        checkIn = ent.trickedentindex3
        sub = 32
    } else if client > 15 {
        checkIn = ent.trickedentindex2
        sub = 16
    } else {
        checkIn = ent.trickedentindex
    }

    if (checkIn & (1 << (client - sub))) != 0 {
        return 1
    }

    return 0
}

/// Source: oracle/codemp/cgame/cg_event.c:1206
func CG_TryPlayCustomSound(_ origin: JKAShared.vec3_t?, _ entityNum: Int32, _ channel: Int32, _ soundName: String) {
    let cSound: sfxHandle_t = CG_CustomSound(entityNum, soundName)

    if cSound <= 0 {
        return
    }

    trap_S_StartSound(origin, entityNum, channel, cSound)
}

/// Source: oracle/codemp/cgame/cg_event.c:1218
func CG_G2MarkEvent(_ es: JKAMP.EntityState) {
    //es->origin should be the hit location of the projectile,
    //whereas es->origin2 is the predicted position of the
    //projectile. (based on the trajectory upon impact) -rww
    let pOwner: Centity? = cg_entities[es.otherEntityNum]
    var startPoint = vec3_t()
    var size: Float = 0.0
    var shader: qhandle_t = 0

    if pOwner!.ghoul2 == nil {
        //can't do anything then...
        return
    }

    //es->eventParm being non-0 means to do a special trace check
    //first. This will give us an impact right at the surface to
    //project the mark on. Typically this is used for radius
    //explosions and such, where the source position could be
    //way outside of model space.
    if es.eventParm != 0 {
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut = Trace.scratch { tr -> Bool in
            var ignore: Int32 = ENTITYNUM_NONE

            CG_G2Trace(tr, es.origin, nil, nil, es.origin2, ignore, MASK_PLAYERSOLID)

            if tr.entityNum != es.otherEntityNum {
                //try again if we hit an ent but not the one we wanted.
                //CG_TestLine(es->origin, es->origin2, 2000, 0x0000ff, 1);
                if tr.entityNum < ENTITYNUM_WORLD {
                    ignore = tr.entityNum
                    CG_G2Trace(tr, es.origin, nil, nil, es.origin2, ignore, MASK_PLAYERSOLID)
                    if tr.entityNum != es.otherEntityNum {
                        //try extending the trace a bit.. or not
                        /*
                        vec3_t v;

                        VectorSubtract(es->origin2, es->origin, v);
                        VectorScale(v, 64.0f, v);
                        VectorAdd(es->origin2, v, es->origin2);

                        CG_G2Trace(&tr, es->origin, NULL, NULL, es->origin2, ignore, MASK_PLAYERSOLID);
                        if (tr.entityNum != es->otherEntityNum)
                        {
                        return;
                        }
                        */
                        //didn't manage to collide with the desired person. No mark will be placed then.
                        return true
                    }
                }
            }

            //otherwise we now have a valid starting point.
            startPoint = tr.endpos
            return false
        }
        if earlyOut {
            return
        }
    } else {
        startPoint = es.origin
    }

    if (es.eFlags & EF_JETPACK_ACTIVE) != 0 {
        // a vehicle weapon, make it a larger size mark
        //OR base this on the size of the thing you hit?
        if g_vehWeaponInfo[es.otherEntityNum2].fG2MarkSize != 0 {
            size = flrand(0.6, 1.4) * g_vehWeaponInfo[es.otherEntityNum2].fG2MarkSize
        } else {
            size = flrand(32.0, 72.0)
        }
        //specify mark shader in vehWeapon file
        if g_vehWeaponInfo[es.otherEntityNum2].iG2MarkShaderHandle != 0 {
            //have one we want to use instead of defaults
            shader = g_vehWeaponInfo[es.otherEntityNum2].iG2MarkShaderHandle
        }
    }
    switch es.weapon {
    case WP_BRYAR_PISTOL, WP_CONCUSSION, WP_BRYAR_OLD, WP_BLASTER, WP_DISRUPTOR, WP_BOWCASTER, WP_REPEATER, WP_TURRET:
        if size == 0 {
            size = 4.0
        }
        if shader == 0 {
            shader = cgs.media.bdecal_bodyburn1
        }
        CG_AddGhoul2Mark(shader, size, startPoint, es.origin2, es.owner, pOwner!.lerpOrigin, pOwner!.lerpAngles[YAW], pOwner!.ghoul2, &pOwner!.modelScale, Q_irand(10000, 20000))

    case WP_ROCKET_LAUNCHER, WP_THERMAL:
        if size == 0 {
            size = 24.0
        }
        if shader == 0 {
            shader = cgs.media.bdecal_burn1
        }
        CG_AddGhoul2Mark(shader, size, startPoint, es.origin2, es.owner, pOwner!.lerpOrigin, pOwner!.lerpAngles[YAW], pOwner!.ghoul2, &pOwner!.modelScale, Q_irand(10000, 20000))
        /*
        case WP_FLECHETTE:
        CG_AddGhoul2Mark(cgs.media.bdecal_bodyburn1, flrand(0.5f, 1.0f),
        startPoint, es->origin2, es->owner, pOwner->lerpOrigin,
        pOwner->lerpAngles[YAW], pOwner->ghoul2,
        pOwner->modelScale);
        break;
        */
        //Issues with small scale?

    default:
        break
    }
}

/// Source: oracle/codemp/cgame/cg_event.c:1350
func CG_CalcVehMuzzle(_ pVeh: JKAMP.Vehicle, _ ent: Centity, _ muzzleNum: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var vehAngles = vec3_t()


        if pVeh.m_iMuzzleTime[muzzleNum] == cg.time {
            //already done for this frame, don't need to do it again
            return true
        }
        //Uh... how about we set this, hunh...?  :)
        pVeh.m_iMuzzleTime[muzzleNum] = cg.time

        vehAngles = ent.lerpAngles
        if pVeh.m_pVehicleInfo != nil {
            if pVeh.m_pVehicleInfo!.type == VH_ANIMAL || pVeh.m_pVehicleInfo!.type == VH_WALKER {
                vehAngles[ROLL] = 0.0
                vehAngles[PITCH] = vehAngles[ROLL]
            } else if pVeh.m_pVehicleInfo!.type == VH_SPEEDER {
                vehAngles[PITCH] = 0.0
            }
        }
        trap_G2API_GetBoltMatrix_NoRecNoRot(ent.ghoul2, 0, pVeh.m_iMuzzleTag[muzzleNum], boltMatrix, vehAngles, ent.lerpOrigin, cg.time, nil, &ent.modelScale)
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &pVeh.m_vMuzzlePos[muzzleNum])
        BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &pVeh.m_vMuzzleDir[muzzleNum])
        return false
    }
    if earlyOut {
        return
    }
}

//corresponds to G_VehMuzzleFireFX -rww
/// Source: oracle/codemp/cgame/cg_event.c:1384
func CG_VehMuzzleFireFX(_ veh: Centity, _ broadcaster: JKAMP.EntityState) {
    let pVeh: Vehicle? = veh.m_pVehicle
    var curMuz: Int32 = 0
    var muzFX: Int32 = 0

    if pVeh == nil || veh.ghoul2 == nil {
        return
    }

    curMuz = 0
    while curMuz < MAX_VEHICLE_MUZZLES {
        //go through all muzzles and
        if pVeh!.m_iMuzzleTag[curMuz] != -1 && (broadcaster.trickedentindex & (1 << curMuz)) != 0 {
            //this muzzle fired
            muzFX = 0
            if pVeh!.m_pVehicleInfo!.weapMuzzle[curMuz] == 0 {
                //no weaopon for this muzzle?  check turrets
                var i: Int32
                var j: Int32
                i = 0
                while i < MAX_VEHICLE_TURRETS {
                    j = 0
                    while j < MAX_VEHICLE_TURRETS {
                        if pVeh!.m_pVehicleInfo!.turret[i].iMuzzle[j] - 1 == curMuz {
                            //this muzzle belongs to this turret
                            muzFX = g_vehWeaponInfo[pVeh!.m_pVehicleInfo!.turret[i].iWeapon].iMuzzleFX
                            break
                        }
                        j += 1
                    }
                    i += 1
                }
            } else {
                muzFX = g_vehWeaponInfo[pVeh!.m_pVehicleInfo!.weapMuzzle[curMuz]].iMuzzleFX
            }
            if muzFX != 0 {
                //CG_CalcVehMuzzle(pVeh, veh, curMuz);
                //trap_FX_PlayEffectID(muzFX, pVeh->m_vMuzzlePos[curMuz], pVeh->m_vMuzzleDir[curMuz], -1, -1);
                trap_FX_PlayBoltedEffectID(muzFX, &veh.currentState.origin, veh.ghoul2, pVeh!.m_iMuzzleTag[curMuz], veh.currentState.number, 0, 0, true)
            }
        }
        curMuz += 1
    }
}

//stupid way of figuring out what string to use for voice chats
/// Source: oracle/codemp/cgame/cg_event.c:1464
func CG_GetStringForVoiceSound(_ s: String) -> String {
    var i: Int32 = 0
    while i < MAX_CUSTOM_SIEGE_SOUNDS {
        if bg_customSiegeSoundNames[i] != nil && Q_stricmp(bg_customSiegeSoundNames[i], s) == 0 {
            //get the matching reference name
            return CG_GetStringEdString("MENUS", cg_stringEdVoiceChatTable[i])
        }
        i += 1
    }

    return "voice chat"
}

/// Source: oracle/codemp/cgame/cg_event.c:1491
func CG_EntityEvent(_ cent: Centity, _ position: JKAShared.vec3_t) {
    var es: EntityState?
    var event: Int32 = 0
    var dir = vec3_t()
    var s: String
    var clientNum: Int32 = 0
    var ci: ClientInfo?
    var eID: Int32 = 0
    var isnd: Int32 = 0
    var cl_ent: Centity?

    es = cent.currentState
    event = es!.event & ~EV_EVENT_BITS

    if cg_debugEvents.integer != 0 {
        CG_Printf("ent:%3i  event:%3i ", es!.number, event)
    }

    if event == 0 {
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("ZEROEVENT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        return
    }

    clientNum = es!.clientNum
    if clientNum < 0 || clientNum >= MAX_CLIENTS {
        clientNum = 0
    }

    if es!.eType == ET_NPC {
        clientNum = es!.number

        if cent.npcClient == nil {
            CG_CreateNPCClient(&cent.npcClient) //allocate memory for it

            if cent.npcClient == nil {
                return
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'ClientInfo?' must be unwrapped to refer to member 'clear' of wrapped base type 'ClientInfo'".
            // Raven wrote: memset(cent->npcClient, 0, sizeof(clientInfo_t))
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
            cent.npcClient!.ghoul2Model = nil
        }

        ci = cent.npcClient
    } else {
        ci = cgs.clientinfo[clientNum]
    }

    switch event {
    //
    // movement generated events
    //
    case EV_CLIENTJOIN:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_CLIENTJOIN")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

        //Slight hack to force a local reinit of client entity on join.
        cl_ent = cg_entities[es!.eventParm]

        if cl_ent != nil {
            //cl_ent->torsoBolt = 0;
            cl_ent!.bolt1 = 0
            cl_ent!.bolt2 = 0
            cl_ent!.bolt3 = 0
            cl_ent!.bolt4 = 0
            cl_ent!.bodyHeight = 0 //SABER_LENGTH_MAX;
            //cl_ent->saberExtendTime = 0;
            cl_ent!.boltInfo = 0
            cl_ent!.frame_minus1_refreshed = 0
            cl_ent!.frame_minus2_refreshed = 0
            cl_ent!.frame_hold_time = 0
            cl_ent!.frame_hold_refreshed = 0
            cl_ent!.trickAlpha = 0
            cl_ent!.trickAlphaTime = 0
            cl_ent!.ghoul2weapon = nil
            cl_ent!.weapon = WP_NONE
            cl_ent!.teamPowerEffectTime = 0
            cl_ent!.teamPowerType = 0 != 0
            cl_ent!.numLoopingSounds = 0
            //cl_ent->localAnimIndex = 0;
        }

    case EV_FOOTSTEP:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FOOTSTEP")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_footsteps.integer != 0 {
            var soundType: footstep_t = 0
            switch es!.eventParm {
            case MATERIAL_MUD:
                soundType = FOOTSTEP_MUDWALK

            case MATERIAL_DIRT:
                soundType = FOOTSTEP_DIRTWALK

            case MATERIAL_SAND:
                soundType = FOOTSTEP_SANDWALK

            case MATERIAL_SNOW:
                soundType = FOOTSTEP_SNOWWALK

            case MATERIAL_SHORTGRASS, MATERIAL_LONGGRASS:
                soundType = FOOTSTEP_GRASSWALK

            case MATERIAL_SOLIDMETAL:
                soundType = FOOTSTEP_METALWALK

            case MATERIAL_HOLLOWMETAL:
                soundType = FOOTSTEP_PIPEWALK

            case MATERIAL_GRAVEL:
                soundType = FOOTSTEP_GRAVELWALK

            case MATERIAL_CARPET, MATERIAL_FABRIC, MATERIAL_CANVAS, MATERIAL_RUBBER, MATERIAL_PLASTIC:
                soundType = FOOTSTEP_RUGWALK

            case MATERIAL_SOLIDWOOD, MATERIAL_HOLLOWWOOD:
                soundType = FOOTSTEP_WOODWALK

            default:
                soundType = FOOTSTEP_STONEWALK
            }

            // The SDK also declares `rand`, so the call names the bg module.
            trap_S_StartSound(nil, es!.number, CHAN_BODY, cgs.media.footsteps[soundType][JKAMP_BG.rand() & 3])
        }

    case EV_FOOTSTEP_METAL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FOOTSTEP_METAL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_footsteps.integer != 0 {
            // The SDK also declares `rand`, so the call names the bg module.
            trap_S_StartSound(nil, es!.number, CHAN_BODY, cgs.media.footsteps[FOOTSTEP_METALWALK][JKAMP_BG.rand() & 3])
        }

    case EV_FOOTSPLASH:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FOOTSPLASH")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_footsteps.integer != 0 {
            // The SDK also declares `rand`, so the call names the bg module.
            trap_S_StartSound(nil, es!.number, CHAN_BODY, cgs.media.footsteps[FOOTSTEP_SPLASH][JKAMP_BG.rand() & 3])
        }

    case EV_FOOTWADE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FOOTWADE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_footsteps.integer != 0 {
            // The SDK also declares `rand`, so the call names the bg module.
            trap_S_StartSound(nil, es!.number, CHAN_BODY, cgs.media.footsteps[FOOTSTEP_SPLASH][JKAMP_BG.rand() & 3])
        }

    case EV_SWIM:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SWIM")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_footsteps.integer != 0 {
            // The SDK also declares `rand`, so the call names the bg module.
            trap_S_StartSound(nil, es!.number, CHAN_BODY, cgs.media.footsteps[FOOTSTEP_SPLASH][JKAMP_BG.rand() & 3])
        }

    case EV_FALL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FALL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.number == cg.snap!.ps.clientNum && cg.snap!.ps.fallingToDeath != 0 {
            break
        }
        DoFall(cent, es!, clientNum)

    case EV_STEP_4,
         EV_STEP_8,
         EV_STEP_12,
         EV_STEP_16: // smooth out step up transitions
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_STEP")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var oldStep: Float = 0
            var delta: Int32 = 0
            var step: Int32 = 0

            if clientNum != cg.predictedPlayerState.clientNum {
                break
            }
            // if we are interpolating, we don't need to smooth steps
            if cg.demoPlayback || (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 || cg_nopredict.integer != 0 || cg_synchronousClients.integer != 0 {
                break
            }
            // check for stepping up before a previous step is completed
            delta = cg.time - cg.stepTime
            if delta < STEP_TIME {
                oldStep = cg.stepChange * (STEP_TIME - delta) / STEP_TIME
            } else {
                oldStep = 0
            }

            // add this amount
            step = 4 * (event - EV_STEP_4 + 1)
            cg.stepChange = oldStep + step
            if cg.stepChange > MAX_STEP_CHANGE {
                cg.stepChange = Float(MAX_STEP_CHANGE)
            }
            cg.stepTime = cg.time
            break
        }
        fallthrough

    case EV_JUMP_PAD:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_JUMP_PAD")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

    case EV_GHOUL2_MARK:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GHOUL2_MARK")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

        if cg_ghoul2Marks.integer != 0 {
            //Can we put a burn mark on him?
            CG_G2MarkEvent(es!)
        }

    case EV_GLOBAL_DUEL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GLOBAL_DUEL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        //used for beginning of power duels
        //if (cg.predictedPlayerState.persistant[PERS_TEAM] != TEAM_SPECTATOR)
        if es!.otherEntityNum == cg.predictedPlayerState.clientNum || es!.otherEntityNum2 == cg.predictedPlayerState.clientNum || es!.groundEntityNum == cg.predictedPlayerState.clientNum {
            CG_CenterPrint(CG_GetStringEdString("MP_SVGAME", "BEGIN_DUEL"), 120, GIANTCHAR_WIDTH * 2)
            trap_S_StartLocalSound(cgs.media.countFightSound, CHAN_ANNOUNCER)
        }

    case EV_PRIVATE_DUEL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PRIVATE_DUEL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

        if cg.snap!.ps.clientNum != es!.number {
            break
        }

        if es!.eventParm != 0 {
            //starting the duel
            if es!.eventParm == 2 {
                CG_CenterPrint(CG_GetStringEdString("MP_SVGAME", "BEGIN_DUEL"), 120, GIANTCHAR_WIDTH * 2)
                trap_S_StartLocalSound(cgs.media.countFightSound, CHAN_ANNOUNCER)
            } else {
                trap_S_StartBackgroundTrack("music/mp/duel.mp3", "music/mp/duel.mp3", false)
            }
        } else {
            //ending the duel
            CG_StartMusic(true)
        }

    case EV_JUMP:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_JUMP")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_jumpSounds.integer != 0 {
            trap_S_StartSound(nil, es!.number, CHAN_VOICE, CG_CustomSound(es!.number, "*jump1.wav"))
        }

    case EV_ROLL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ROLL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.number == cg.snap!.ps.clientNum && cg.snap!.ps.fallingToDeath != 0 {
            break
        }
        if es!.eventParm != 0 {
            //fall-roll-in-one event
            DoFall(cent, es!, clientNum)
        }

        trap_S_StartSound(nil, es!.number, CHAN_VOICE, CG_CustomSound(es!.number, "*jump1.wav"))
        trap_S_StartSound(nil, es!.number, CHAN_BODY, cgs.media.rollSound)

    case EV_TAUNT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_TAUNT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var soundIndex: Int32 = 0
            if cgs.gametype != GT_DUEL && cgs.gametype != GT_POWERDUEL && es!.eventParm == TAUNT_TAUNT {
                //normal taunt
                soundIndex = CG_CustomSound(es!.number, "*taunt.wav")
            } else {
                switch es!.eventParm {
                case TAUNT_BOW:
                    //soundIndex = CG_CustomSound( es->number, va("*respect%d.wav", Q_irand(1,3)) );
                    break

                case TAUNT_MEDITATE:
                    //soundIndex = CG_CustomSound( es->number, va("*meditate%d.wav", Q_irand(1,3)) );
                    break

                case TAUNT_FLOURISH:
                    if Q_irand(0, 1) != 0 {
                        soundIndex = CG_CustomSound(es!.number, va("*deflect%d.wav", Q_irand(1, 3)))
                        if soundIndex == 0 {
                            soundIndex = CG_CustomSound(es!.number, va("*gloat%d.wav", Q_irand(1, 3)))
                            if soundIndex == 0 {
                                soundIndex = CG_CustomSound(es!.number, va("*anger%d.wav", Q_irand(1, 3)))
                            }
                        }
                    } else {
                        soundIndex = CG_CustomSound(es!.number, va("*gloat%d.wav", Q_irand(1, 3)))
                        if soundIndex == 0 {
                            soundIndex = CG_CustomSound(es!.number, va("*deflect%d.wav", Q_irand(1, 3)))
                            if soundIndex == 0 {
                                soundIndex = CG_CustomSound(es!.number, va("*anger%d.wav", Q_irand(1, 3)))
                            }
                        }
                    }

                case TAUNT_GLOAT:
                    soundIndex = CG_CustomSound(es!.number, va("*victory%d.wav", Q_irand(1, 3)))

                default:
                    if Q_irand(0, 1) != 0 {
                        soundIndex = CG_CustomSound(es!.number, va("*anger%d.wav", Q_irand(1, 3)))
                    } else {
                        soundIndex = CG_CustomSound(es!.number, va("*taunt%d.wav", Q_irand(1, 3)))
                        if soundIndex == 0 {
                            soundIndex = CG_CustomSound(es!.number, va("*anger%d.wav", Q_irand(1, 3)))
                        }
                    }
                }
            }
            if soundIndex == 0 {
                soundIndex = CG_CustomSound(es!.number, "*taunt.wav")
            }
            if soundIndex != 0 {
                trap_S_StartSound(nil, es!.number, CHAN_VOICE, soundIndex)
            }
        }
        //Begin NPC sounds

    case EV_ANGER1, //Say when acquire an enemy when didn't have one before
         EV_ANGER2,
         EV_ANGER3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ANGERx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*anger%i.wav", event - EV_ANGER1 + 1))

    case EV_VICTORY1, //Say when killed an enemy
         EV_VICTORY2,
         EV_VICTORY3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_VICTORYx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*victory%i.wav", event - EV_VICTORY1 + 1))

    case EV_CONFUSE1, //Say when confused
         EV_CONFUSE2,
         EV_CONFUSE3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_CONFUSEDx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*confuse%i.wav", event - EV_CONFUSE1 + 1))

    case EV_PUSHED1, //Say when pushed
         EV_PUSHED2,
         EV_PUSHED3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PUSHEDx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*pushed%i.wav", event - EV_PUSHED1 + 1))

    case EV_CHOKE1, //Say when choking
         EV_CHOKE2,
         EV_CHOKE3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_CHOKEx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*choke%i.wav", event - EV_CHOKE1 + 1))

    case EV_FFWARN: //Warn ally to stop shooting you
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FFWARN")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, "*ffwarn.wav")

    case EV_FFTURN: //Turn on ally after being shot by them
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FFTURN")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, "*ffturn.wav")
        //extra sounds for ST

    case EV_CHASE1, EV_CHASE2, EV_CHASE3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_CHASEx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*chase%i.wav", event - EV_CHASE1 + 1))

    case EV_COVER1, EV_COVER2, EV_COVER3, EV_COVER4, EV_COVER5:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_COVERx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*cover%i.wav", event - EV_COVER1 + 1))

    case EV_DETECTED1, EV_DETECTED2, EV_DETECTED3, EV_DETECTED4, EV_DETECTED5:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DETECTEDx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*detected%i.wav", event - EV_DETECTED1 + 1))

    case EV_GIVEUP1, EV_GIVEUP2, EV_GIVEUP3, EV_GIVEUP4:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GIVEUPx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*giveup%i.wav", event - EV_GIVEUP1 + 1))

    case EV_LOOK1, EV_LOOK2:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_LOOKx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*look%i.wav", event - EV_LOOK1 + 1))

    case EV_LOST1:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_LOST1")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, "*lost1.wav")

    case EV_OUTFLANK1, EV_OUTFLANK2:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_OUTFLANKx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*outflank%i.wav", event - EV_OUTFLANK1 + 1))

    case EV_ESCAPING1, EV_ESCAPING2, EV_ESCAPING3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ESCAPINGx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*escaping%i.wav", event - EV_ESCAPING1 + 1))

    case EV_SIGHT1, EV_SIGHT2, EV_SIGHT3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SIGHTx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*sight%i.wav", event - EV_SIGHT1 + 1))

    case EV_SOUND1, EV_SOUND2, EV_SOUND3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SOUNDx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*sound%i.wav", event - EV_SOUND1 + 1))

    case EV_SUSPICIOUS1, EV_SUSPICIOUS2, EV_SUSPICIOUS3, EV_SUSPICIOUS4, EV_SUSPICIOUS5:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SUSPICIOUSx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*suspicious%i.wav", event - EV_SUSPICIOUS1 + 1))
        //extra sounds for Jedi

    case EV_COMBAT1, EV_COMBAT2, EV_COMBAT3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_COMBATx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*combat%i.wav", event - EV_COMBAT1 + 1))

    case EV_JDETECTED1, EV_JDETECTED2, EV_JDETECTED3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_JDETECTEDx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*jdetected%i.wav", event - EV_JDETECTED1 + 1))

    case EV_TAUNT1, EV_TAUNT2, EV_TAUNT3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_TAUNTx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*taunt%i.wav", event - EV_TAUNT1 + 1))

    case EV_JCHASE1, EV_JCHASE2, EV_JCHASE3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_JCHASEx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*jchase%i.wav", event - EV_JCHASE1 + 1))

    case EV_JLOST1, EV_JLOST2, EV_JLOST3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_JLOSTx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*jlost%i.wav", event - EV_JLOST1 + 1))

    case EV_DEFLECT1, EV_DEFLECT2, EV_DEFLECT3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DEFLECTx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*deflect%i.wav", event - EV_DEFLECT1 + 1))

    case EV_GLOAT1, EV_GLOAT2, EV_GLOAT3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GLOATx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, va("*gloat%i.wav", event - EV_GLOAT1 + 1))

    case EV_PUSHFAIL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PUSHFAIL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_TryPlayCustomSound(nil, es!.number, CHAN_VOICE, "*pushfail.wav")
        //End NPC sounds

    case EV_SIEGESPEC:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SIEGESPEC")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.owner == cg.predictedPlayerState.clientNum {
            cg_siegeDeathTime = es!.time
        }

    case EV_WATER_TOUCH:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_WATER_TOUCH")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.watrInSound)

    case EV_WATER_LEAVE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_WATER_LEAVE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.watrOutSound)

    case EV_WATER_UNDER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_WATER_UNDER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.watrUnSound)

    case EV_WATER_CLEAR:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_WATER_CLEAR")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        trap_S_StartSound(nil, es!.number, CHAN_AUTO, CG_CustomSound(es!.number, "*gasp.wav"))

    case EV_ITEM_PICKUP:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ITEM_PICKUP")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var item: Gitem?
            var index: Int32 = 0
            var newindex: Bool = false

            index = cg_entities[es!.eventParm].currentState.modelindex // player predicted

            if index < 1 && cg_entities[es!.eventParm].currentState.isJediMaster {
                //a holocron most likely
                index = cg_entities[es!.eventParm].currentState.trickedentindex4
                trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.holocronPickup)

                if es!.number == cg.snap!.ps.clientNum && showPowersName[index] != nil {
                    let strText: String = CG_GetStringEdString("MP_INGAME", "PICKUPLINE")

                    //Com_Printf("%s %s\n", strText, showPowersName[index]);
                    CG_CenterPrint(va("%s %s\n", strText, CG_GetStringEdString("SP_INGAME", showPowersName[index])), Int32(Double(SCREEN_HEIGHT) * 0.30), BIGCHAR_WIDTH)
                }

                //Show the player their force selection bar in case picking the holocron up changed the current selection
                if index != FP_SABER_OFFENSE && index != FP_SABER_DEFENSE && index != FP_SABERTHROW && index != FP_LEVITATION && es!.number == cg.snap!.ps.clientNum && (index == cg.snap!.ps.fd.forcePowerSelected || !((cg.snap!.ps.fd.forcePowersActive & (1 << cg.snap!.ps.fd.forcePowerSelected)) != 0)) {
                    if cg.forceSelect != index {
                        cg.forceSelect = index
                        newindex = true
                    }
                }

                if es!.number == cg.snap!.ps.clientNum && newindex {
                    if cg.forceSelectTime < cg.time {
                        cg.forceSelectTime = Float(cg.time)
                    }
                }

                break
            }

            if cg_entities[es!.eventParm].weapon >= cg.time {
                //rww - an unfortunately necessary hack to prevent double item pickups
                break
            }

            //Hopefully even if this entity is somehow removed and replaced with, say, another
            //item, this time will have expired by the time that item needs to be picked up.
            //Of course, it's quite possible this will fail miserably, so if you've got a better
            //solution then please do use it.
            cg_entities[es!.eventParm].weapon = cg.time + 500

            if index < 1 || index >= bg_numItems {
                break
            }
            item = bg_itemlist[index]

            if item!.giType != IT_TEAM {
                if item!.pickup_sound != nil && !item!.pickup_sound!.isEmpty {
                    trap_S_StartSound(nil, es!.number, CHAN_AUTO, trap_S_RegisterSound(item!.pickup_sound!))
                }
            }

            // show icon and name on status bar
            if es!.number == cg.snap!.ps.clientNum {
                CG_ItemPickup(index)
            }
        }

    case EV_GLOBAL_ITEM_PICKUP:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GLOBAL_ITEM_PICKUP")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var item: Gitem?
            var index: Int32 = 0

            index = es!.eventParm // player predicted

            if index < 1 || index >= bg_numItems {
                break
            }
            item = bg_itemlist[index]
            // powerup pickups are global
            if item!.pickup_sound != nil && !item!.pickup_sound!.isEmpty {
                trap_S_StartSound(nil, cg.snap!.ps.clientNum, CHAN_AUTO, trap_S_RegisterSound(item!.pickup_sound!))
            }

            // show icon and name on status bar
            if es!.number == cg.snap!.ps.clientNum {
                CG_ItemPickup(index)
            }
        }

    case EV_VEH_FIRE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_VEH_FIRE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            let veh: Centity? = cg_entities[es!.owner]
            CG_VehMuzzleFireFX(veh!, es!)
        }
        //
        // weapon events
        //

    case EV_NOAMMO:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_NOAMMO")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        //		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.noAmmoSound );
        if es!.number == cg.snap!.ps.clientNum {
            if CG_InFighter() || CG_InATST() || cg.snap!.ps.weapon == WP_NONE {
                //just letting us know our vehicle is out of ammo
                //FIXME: flash something on HUD or give some message so we know we have no ammo
                let localCent: Centity? = cg_entities[cg.snap!.ps.clientNum]
                if localCent!.m_pVehicle != nil && localCent!.m_pVehicle!.m_pVehicleInfo != nil && localCent!.m_pVehicle!.m_pVehicleInfo!.weapon[es!.eventParm].soundNoAmmo != 0 {
                    //play the "no Ammo" sound for this weapon
                    trap_S_StartSound(nil, cg.snap!.ps.clientNum, CHAN_AUTO, localCent!.m_pVehicle!.m_pVehicleInfo!.weapon[es!.eventParm].soundNoAmmo)
                } else {
                    //play the default "no ammo" sound
                    trap_S_StartSound(nil, cg.snap!.ps.clientNum, CHAN_AUTO, cgs.media.noAmmoSound)
                }
                //flash the HUD so they associate the sound with the visual indicator that they don't have enough ammo
                if cg_vehicleAmmoWarningTime < cg.time || cg_vehicleAmmoWarning != es!.eventParm {
                    //if there's already one going, don't interrupt it (unless they tried to fire another weapon that's out of ammo)
                    cg_vehicleAmmoWarning = es!.eventParm
                    cg_vehicleAmmoWarningTime = cg.time + 500
                }
            } else if cg.snap!.ps.weapon == WP_SABER {
                cg.forceHUDTotalFlashTime = cg.time + 1000
            } else {
                var weap: Int32 = 0

                if es!.eventParm != 0 && es!.eventParm < WP_NUM_WEAPONS {
                    cg.snap!.ps.stats[STAT_WEAPONS] &= ~(1 << es!.eventParm)
                    weap = cg.snap!.ps.weapon
                } else if es!.eventParm != 0 {
                    weap = (es!.eventParm - WP_NUM_WEAPONS)
                }
                CG_OutOfAmmoChange(weap)
            }
        }

    case EV_CHANGE_WEAPON:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_CHANGE_WEAPON")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            let weapon: Int32 = es!.eventParm
            var weaponInfo: WeaponInfo?


            weaponInfo = cg_weapons[weapon]


            if weaponInfo!.selectSound != 0 {
                trap_S_StartSound(nil, es!.number, CHAN_AUTO, weaponInfo!.selectSound)
            } else if weapon != WP_SABER {
                //not sure what SP is doing for this but I don't want a select sound for saber (it has the saber-turn-on)
                trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.selectSound)
            }
        }

    case EV_FIRE_WEAPON:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FIRE_WEAPON")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        // Port-note: Raven's block leaves a loop outside the record's scope, and the closure cannot.
        // Raven wrote: if (cent->currentState.number >= MAX_CLIENTS && cent->currentState.eType != ET_NPC) { //special case for turret firing vec3_t gunpoint, gunangle; mdxaBone_t matrix; weaponInfo_t *weaponInfo = &cg_weapons[WP_TURRET]; if ( !weaponInfo->registered ) { CG_RegisterWeapon(WP_TURRET); } if (cent->ghoul2) { if (!cent->bolt1) { cent->bolt1 = trap_G2API_AddBolt(cent->ghoul2, 0, "*flash01"); } if (!cent->bolt2) { cent->bolt2 = trap_G2API_AddBolt(cent->ghoul2, 0, "*flash02"); } trap_G2API_SetBoneAnim(cent->ghoul2, 0, "Bone02", 1, 4, BONE_ANIM_OVERRIDE_FREEZE|BONE_ANIM_BLEND, 1.0f, cg.time, -1, 300); } else { break; } if (cent->currentState.eventParm) { trap_G2API_GetBoltMatrix(cent->ghoul2, 0, cent->bolt2, &matrix, cent->currentState.angles, cent->currentState.origin, cg.time, cgs.gameModels, cent->modelScale); } else { trap_G2API_GetBoltMatrix(cent->ghoul2, 0, cent->bolt1, &matrix, cent->currentState.angles, cent->currentState.origin, cg.time, cgs.gameModels, cent->modelScale); } gunpoint[0] = matrix.matrix[0][3]; gunpoint[1] = matrix.matrix[1][3]; gunpoint[2] = matrix.matrix[2][3]; gunangle[0] = -matrix.matrix[0][0]; gunangle[1] = -matrix.matrix[1][0]; gunangle[2] = -matrix.matrix[2][0]; trap_FX_PlayEffectID(cgs.effects.mEmplacedMuzzleFlash, gunpoint, gunangle, -1, -1); } else if (cent->currentState.weapon != WP_EMPLACED_GUN || cent->currentState.eType == ET_NPC) { if (cent->currentState.eType == ET_NPC && cent->currentState.NPC_class == CLASS_VEHICLE && cent->m_pVehicle) { //vehicles do nothing for clientside weapon fire events.. at least for now. break; } CG_FireWeapon( cent, qfalse ); }
        portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")

    case EV_ALT_FIRE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ALT_FIRE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

        if cent.currentState.weapon == WP_EMPLACED_GUN {
            //don't do anything for emplaced stuff
            break
        }

        if cent.currentState.eType == ET_NPC && cent.currentState.NPC_class == CLASS_VEHICLE && cent.m_pVehicle != nil {
            //vehicles do nothing for clientside weapon fire events.. at least for now.
            break
        }

        CG_FireWeapon(cent, true)

        //if you just exploded your detpacks and you have no ammo left for them, autoswitch
        if cg.snap!.ps.clientNum == cent.currentState.number && cg.snap!.ps.weapon == WP_DET_PACK {
            if cg.snap!.ps.ammo[weaponData[WP_DET_PACK].ammoIndex] == 0 {
                CG_OutOfAmmoChange(WP_DET_PACK)
            }
        }

    case EV_SABER_ATTACK:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SABER_ATTACK")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var swingSound: qhandle_t = trap_S_RegisterSound(va("sound/weapons/saber/saberhup%i.wav", Q_irand(1, 8)))
            var client: ClientInfo? = nil
            if cg_entities[es!.number].currentState.eType == ET_NPC {
                client = cg_entities[es!.number].npcClient
            } else if es!.number < MAX_CLIENTS {
                client = cgs.clientinfo[es!.number]
            }
            if client != nil && client!.infoValid && client!.saber[0].swingSound[0] != 0 {
                //custom swing sound
                swingSound = client!.saber[0].swingSound[Q_irand(0, 2)]
            }
            trap_S_StartSound(es!.pos.trBase, es!.number, CHAN_WEAPON, swingSound)
        }

    case EV_SABER_HIT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SABER_HIT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var hitPersonFxID: Int32 = cgs.effects.mSaberBloodSparks
            var hitPersonSmallFxID: Int32 = cgs.effects.mSaberBloodSparksSmall
            var hitPersonMidFxID: Int32 = cgs.effects.mSaberBloodSparksMid
            var hitOtherFxID: Int32 = cgs.effects.mSaberCut
            var hitSound: Int32 = trap_S_RegisterSound(va("sound/weapons/saber/saberhit%i.wav", Q_irand(1, 3)))

            if es!.otherEntityNum2 >= 0 && es!.otherEntityNum2 < ENTITYNUM_NONE {
                //we have a specific person who is causing this effect, see if we should override it with any custom saber effects/sounds
                var client: ClientInfo? = nil
                if cg_entities[es!.otherEntityNum2].currentState.eType == ET_NPC {
                    client = cg_entities[es!.otherEntityNum2].npcClient
                } else if es!.otherEntityNum2 < MAX_CLIENTS {
                    client = cgs.clientinfo[es!.otherEntityNum2]
                }
                if client != nil && client!.infoValid {
                    let saberNum: Int32 = es!.weapon
                    let bladeNum: Int32 = es!.legsAnim
                    if WP_SaberBladeUseSecondBladeStyle(client!.saber[saberNum], bladeNum) {
                        //use second blade style values
                        if client!.saber[saberNum].hitPersonEffect2 != 0 {
                            //custom hit person effect
                            hitPersonMidFxID = client!.saber[saberNum].hitPersonEffect2
                            hitPersonSmallFxID = hitPersonMidFxID
                            hitPersonFxID = hitPersonSmallFxID
                        }
                        if client!.saber[saberNum].hitOtherEffect2 != 0 {
                            //custom hit other effect
                            hitOtherFxID = client!.saber[saberNum].hitOtherEffect2
                        }
                        if client!.saber[saberNum].hit2Sound[0] != 0 {
                            //custom hit sound
                            hitSound = client!.saber[saberNum].hit2Sound[Q_irand(0, 2)]
                        }
                    } else {
                        //use first blade style values
                        if client!.saber[saberNum].hitPersonEffect != 0 {
                            //custom hit person effect
                            hitPersonMidFxID = client!.saber[saberNum].hitPersonEffect
                            hitPersonSmallFxID = hitPersonMidFxID
                            hitPersonFxID = hitPersonSmallFxID
                        }
                        if client!.saber[saberNum].hitOtherEffect != 0 {
                            //custom hit other effect
                            hitOtherFxID = client!.saber[0].hitOtherEffect
                        }
                        if client!.saber[saberNum].hitSound[0] != 0 {
                            //custom hit sound
                            hitSound = client!.saber[saberNum].hitSound[Q_irand(0, 2)]
                        }
                    }
                }
            }

            if es!.eventParm == 16 {
                //Make lots of sparks, something special happened
                var fxDir = vec3_t()
                fxDir = es!.angles
                if fxDir[0] == 0 && fxDir[1] == 0 && fxDir[2] == 0 {
                    fxDir[1] = 1
                }
                trap_S_StartSound(es!.origin, es!.number, CHAN_AUTO, hitSound)
                trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
                trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
                trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
                trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
                trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
                trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
            } else if es!.eventParm != 0 {
                //hit a person
                var fxDir = vec3_t()
                fxDir = es!.angles
                if fxDir[0] == 0 && fxDir[1] == 0 && fxDir[2] == 0 {
                    fxDir[1] = 1
                }
                trap_S_StartSound(es!.origin, es!.number, CHAN_AUTO, hitSound)
                if es!.eventParm == 3 {
                    // moderate or big hits.
                    trap_FX_PlayEffectID(hitPersonSmallFxID, es!.origin, fxDir, -1, -1)
                } else if es!.eventParm == 2 {
                    // this is for really big hits.
                    trap_FX_PlayEffectID(hitPersonMidFxID, es!.origin, fxDir, -1, -1)
                } else {
                    // this should really just be done in the effect itself, no?
                    trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
                    trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
                    trap_FX_PlayEffectID(hitPersonFxID, es!.origin, fxDir, -1, -1)
                }
            } else {
                //hit something else
                var fxDir = vec3_t()
                fxDir = es!.angles
                if fxDir[0] == 0 && fxDir[1] == 0 && fxDir[2] == 0 {
                    fxDir[1] = 1
                }
                //old jk2mp method
                /*
                trap_S_StartSound(es->origin, es->number, CHAN_AUTO, trap_S_RegisterSound("sound/weapons/saber/saberhit.wav"));
                trap_FX_PlayEffectID( trap_FX_RegisterEffect("saber/spark.efx"), es->origin, fxDir, -1, -1 );
                */

                trap_FX_PlayEffectID(hitOtherFxID, es!.origin, fxDir, -1, -1)
            }

            //rww - this means we have the number of the ent being hit and the ent that owns the saber doing
            //the hit. This being the case, we can store these indecies and the current time in order to do
            //some visual tricks on the client between frames to make it look like we're actually continuing
            //to hit between server frames.
            if es!.otherEntityNum != ENTITYNUM_NONE && es!.otherEntityNum2 != ENTITYNUM_NONE {
                var saberOwner: Centity?

                saberOwner = cg_entities[es!.otherEntityNum2]

                saberOwner!.serverSaberHitIndex = es!.otherEntityNum
                saberOwner!.serverSaberHitTime = cg.time

                if es!.eventParm != 0 {
                    saberOwner!.serverSaberFleshImpact = true
                } else {
                    saberOwner!.serverSaberFleshImpact = false
                }
            }
        }

    case EV_SABER_BLOCK:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SABER_BLOCK")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            if es!.eventParm != 0 {
                //saber block
                var cullPass: Bool = false
                var blockFXID: Int32 = cgs.effects.mSaberBlock
                var blockSound: qhandle_t = trap_S_RegisterSound(va("sound/weapons/saber/saberblock%d.wav", Q_irand(1, 9)))
                var noFlare: Bool = false

                if es!.otherEntityNum2 >= 0 && es!.otherEntityNum2 < ENTITYNUM_NONE {
                    //we have a specific person who is causing this effect, see if we should override it with any custom saber effects/sounds
                    var client: ClientInfo? = nil
                    if cg_entities[es!.otherEntityNum2].currentState.eType == ET_NPC {
                        client = cg_entities[es!.otherEntityNum2].npcClient
                    } else if es!.otherEntityNum2 < MAX_CLIENTS {
                        client = cgs.clientinfo[es!.otherEntityNum2]
                    }
                    if client != nil && client!.infoValid {
                        let saberNum: Int32 = es!.weapon
                        let bladeNum: Int32 = es!.legsAnim
                        if WP_SaberBladeUseSecondBladeStyle(client!.saber[saberNum], bladeNum) {
                            //use second blade style values
                            if client!.saber[saberNum].blockEffect2 != 0 {
                                //custom saber block effect
                                blockFXID = client!.saber[saberNum].blockEffect2
                            }
                            if client!.saber[saberNum].block2Sound[0] != 0 {
                                //custom hit sound
                                blockSound = client!.saber[saberNum].block2Sound[Q_irand(0, 2)]
                            }
                        } else {
                            if client!.saber[saberNum].blockEffect != 0 {
                                //custom saber block effect
                                blockFXID = client!.saber[saberNum].blockEffect
                            }
                            if client!.saber[saberNum].blockSound[0] != 0 {
                                //custom hit sound
                                blockSound = client!.saber[saberNum].blockSound[Q_irand(0, 2)]
                            }
                        }
                        if (client!.saber[saberNum].saberFlags2 & SFL2_NO_CLASH_FLARE) != 0 {
                            noFlare = true
                        }
                    }
                }
                if cg.mInRMG {
                    // Raven's record lives to the end of his block, so the block is the closure.
                    Trace.scratch { tr in
                        var vecSub = vec3_t()

                        vecSub = cg.refdef.vieworg - es!.origin

                        if VectorLength(vecSub) < 5000 {
                            CG_Trace(tr, cg.refdef.vieworg, nil, nil, es!.origin, ENTITYNUM_NONE, CONTENTS_TERRAIN | CONTENTS_SOLID)

                            if Double(tr.fraction) == 1.0 || tr.entityNum < MAX_CLIENTS {
                                cullPass = true
                            }
                        }
                    }
                } else {
                    cullPass = true
                }

                if cullPass {
                    var fxDir = vec3_t()

                    fxDir = es!.angles
                    if fxDir[0] == 0 && fxDir[1] == 0 && fxDir[2] == 0 {
                        fxDir[1] = 1
                    }
                    trap_S_StartSound(es!.origin, es!.number, CHAN_AUTO, blockSound)
                    trap_FX_PlayEffectID(blockFXID, es!.origin, fxDir, -1, -1)

                    if !noFlare {
                        cg_saberFlashTime = cg.time - 50
                        cg_saberFlashPos = es!.origin
                    }
                }
            } else {
                //projectile block
                var fxDir = vec3_t()
                fxDir = es!.angles
                if fxDir[0] == 0 && fxDir[1] == 0 && fxDir[2] == 0 {
                    fxDir[1] = 1
                }
                trap_FX_PlayEffectID(cgs.effects.mBlasterDeflect, es!.origin, fxDir, -1, -1)
            }
        }

    case EV_SABER_CLASHFLARE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SABER_CLASHFLARE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var cullPass: Bool = false

            if cg.mInRMG {
                // Raven's record lives to the end of his block, so the block is the closure.
                Trace.scratch { tr in
                    var vecSub = vec3_t()

                    vecSub = cg.refdef.vieworg - es!.origin

                    if VectorLength(vecSub) < 5000 {
                        CG_Trace(tr, cg.refdef.vieworg, nil, nil, es!.origin, ENTITYNUM_NONE, CONTENTS_TERRAIN | CONTENTS_SOLID)

                        if Double(tr.fraction) == 1.0 || tr.entityNum < MAX_CLIENTS {
                            cullPass = true
                        }
                    }
                }
            } else {
                cullPass = true
            }

            if cullPass {
                cg_saberFlashTime = cg.time - 50
                cg_saberFlashPos = es!.origin
            }
            trap_S_StartSound(es!.origin, -1, CHAN_WEAPON, trap_S_RegisterSound(va("sound/weapons/saber/saberhitwall%i", Q_irand(1, 3))))
        }

    case EV_SABER_UNHOLSTER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SABER_UNHOLSTER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var ci: ClientInfo? = nil

            if es!.eType == ET_NPC {
                ci = cg_entities[es!.number].npcClient
            } else if es!.number < MAX_CLIENTS {
                ci = cgs.clientinfo[es!.number]
            }

            if ci != nil {
                if ci!.saber[0].soundOn != 0 {
                    trap_S_StartSound(nil, es!.number, CHAN_AUTO, ci!.saber[0].soundOn)
                }
                if ci!.saber[1].soundOn != 0 {
                    trap_S_StartSound(nil, es!.number, CHAN_AUTO, ci!.saber[1].soundOn)
                }
            }
        }

    case EV_BECOME_JEDIMASTER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SABER_UNHOLSTER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        // Port-note: Raven's block leaves a loop outside the record's scope, and the closure cannot.
        // Raven wrote: { trace_t tr; vec3_t playerMins = {-15, -15, DEFAULT_MINS_2+8}; vec3_t playerMaxs = {15, 15, DEFAULT_MAXS_2}; vec3_t ang, pos, dpos; VectorClear(ang); ang[ROLL] = 1; VectorCopy(position, dpos); dpos[2] -= 4096; CG_Trace(&tr, position, playerMins, playerMaxs, dpos, es->number, MASK_SOLID); VectorCopy(tr.endpos, pos); if (tr.fraction == 1) { break; } trap_FX_PlayEffectID(cgs.effects.mJediSpawn, pos, ang, -1, -1); trap_S_StartSound (NULL, es->number, CHAN_AUTO, trap_S_RegisterSound( "sound/weapons/saber/saberon.wav" ) ); if (cg.snap->ps.clientNum == es->number) { trap_S_StartLocalSound(cgs.media.happyMusic, CHAN_LOCAL); CGCam_SetMusicMult(0.3, 5000); } }
        portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")

    case EV_DISRUPTOR_MAIN_SHOT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DISRUPTOR_MAIN_SHOT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cent.currentState.eventParm != cg.snap!.ps.clientNum || cg.renderingThirdPerson {
            //h4q3ry
            CG_GetClientWeaponMuzzleBoltPoint(cent.currentState.eventParm, &cent.currentState.origin2)
        } else {
            if cg.lastFPFlashPoint[0] != 0 || cg.lastFPFlashPoint[1] != 0 || cg.lastFPFlashPoint[2] != 0 {
                //get the position of the muzzle flash for the first person weapon model from the last frame
                cent.currentState.origin2 = cg.lastFPFlashPoint
            }
        }
        FX_DisruptorMainShot(cent.currentState.origin2, cent.lerpOrigin)

    case EV_DISRUPTOR_SNIPER_SHOT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DISRUPTOR_SNIPER_SHOT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cent.currentState.eventParm != cg.snap!.ps.clientNum || cg.renderingThirdPerson {
            //h4q3ry
            CG_GetClientWeaponMuzzleBoltPoint(cent.currentState.eventParm, &cent.currentState.origin2)
        } else {
            if cg.lastFPFlashPoint[0] != 0 || cg.lastFPFlashPoint[1] != 0 || cg.lastFPFlashPoint[2] != 0 {
                //get the position of the muzzle flash for the first person weapon model from the last frame
                cent.currentState.origin2 = cg.lastFPFlashPoint
            }
        }
        FX_DisruptorAltShot(cent.currentState.origin2, cent.lerpOrigin, cent.currentState.shouldtarget)

    case EV_DISRUPTOR_SNIPER_MISS:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DISRUPTOR_SNIPER_MISS")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        ByteToDir(es!.eventParm, &dir)
        if es!.weapon != 0 {
            //primary
            FX_DisruptorHitWall(cent.lerpOrigin, dir)
        } else {
            //secondary
            FX_DisruptorAltMiss(cent.lerpOrigin, dir)
        }

    case EV_DISRUPTOR_HIT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DISRUPTOR_HIT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        ByteToDir(es!.eventParm, &dir)
        if es!.weapon != 0 {
            //client
            FX_DisruptorHitPlayer(cent.lerpOrigin, dir, true)
        } else {
            //non-client
            FX_DisruptorHitWall(cent.lerpOrigin, dir)
        }

    case EV_DISRUPTOR_ZOOMSOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DISRUPTOR_ZOOMSOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.number == cg.snap!.ps.clientNum {
            if cg.snap!.ps.zoomMode != 0 {
                trap_S_StartLocalSound(trap_S_RegisterSound("sound/weapons/disruptor/zoomstart.wav"), CHAN_AUTO)
            } else {
                trap_S_StartLocalSound(trap_S_RegisterSound("sound/weapons/disruptor/zoomend.wav"), CHAN_AUTO)
            }
        }

    case EV_PREDEFSOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PREDEFSOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var sID: Int32 = -1

            switch es!.eventParm {
            case PDSOUND_PROTECTHIT:
                sID = trap_S_RegisterSound("sound/weapons/force/protecthit.mp3")

            case PDSOUND_PROTECT:
                sID = trap_S_RegisterSound("sound/weapons/force/protect.mp3")

            case PDSOUND_ABSORBHIT:
                sID = trap_S_RegisterSound("sound/weapons/force/absorbhit.mp3")
                if es!.trickedentindex >= 0 && es!.trickedentindex < MAX_CLIENTS {
                    var clnum: Int32 = es!.trickedentindex

                    cg_entities[clnum].teamPowerEffectTime = cg.time + 1000
                    cg_entities[clnum].teamPowerType = 3 != 0
                }

            case PDSOUND_ABSORB:
                sID = trap_S_RegisterSound("sound/weapons/force/absorb.mp3")

            case PDSOUND_FORCEJUMP:
                sID = trap_S_RegisterSound("sound/weapons/force/jump.mp3")

            case PDSOUND_FORCEGRIP:
                sID = trap_S_RegisterSound("sound/weapons/force/grip.mp3")

            default:
                break
            }

            if sID != 1 {
                trap_S_StartSound(es!.origin, es!.number, CHAN_AUTO, sID)
            }
        }

    case EV_TEAM_POWER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_TEAM_POWER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var clnum: Int32 = 0

            while clnum < MAX_CLIENTS {
                if CG_InClientBitflags(es!, clnum) != 0 {
                    if es!.eventParm == 1 {
                        //eventParm 1 is heal
                        trap_S_StartSound(nil, clnum, CHAN_AUTO, cgs.media.teamHealSound)
                        cg_entities[clnum].teamPowerEffectTime = cg.time + 1000
                        cg_entities[clnum].teamPowerType = 1 != 0
                    } else {
                        //eventParm 2 is force regen
                        trap_S_StartSound(nil, clnum, CHAN_AUTO, cgs.media.teamRegenSound)
                        cg_entities[clnum].teamPowerEffectTime = cg.time + 1000
                        cg_entities[clnum].teamPowerType = 0 != 0
                    }
                }
                clnum += 1
            }
        }

    case EV_SCREENSHAKE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SCREENSHAKE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.modelindex == 0 || cg.predictedPlayerState.clientNum == es!.modelindex - 1 {
            CGCam_Shake(es!.angles[0], es!.time)
        }

    case EV_LOCALTIMER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_LOCALTIMER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.owner == cg.predictedPlayerState.clientNum {
            CG_LocalTimingBar(es!.time, es!.time2)
        }

    case EV_USE_ITEM0:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM0")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM1:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM1")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM2:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM2")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM3")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM4:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM4")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM5:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM5")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM6:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM6")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM7:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM7")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM8:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM8")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM9:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM9")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM10:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM10")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM11:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM11")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM12:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM12")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM13:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM13")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_USE_ITEM14:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_USE_ITEM14")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_UseItem(cent)

    case EV_ITEMUSEFAIL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ITEMUSEFAIL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg.snap!.ps.clientNum == es!.number {
            var psStringEDRef: String? = nil

            switch es!.eventParm {
            case SENTRY_NOROOM:
                psStringEDRef = CG_GetStringEdString("MP_INGAME", "SENTRY_NOROOM")

            case SENTRY_ALREADYPLACED:
                psStringEDRef = CG_GetStringEdString("MP_INGAME", "SENTRY_ALREADYPLACED")

            case SHIELD_NOROOM:
                psStringEDRef = CG_GetStringEdString("MP_INGAME", "SHIELD_NOROOM")

            case SEEKER_ALREADYDEPLOYED:
                psStringEDRef = CG_GetStringEdString("MP_INGAME", "SEEKER_ALREADYDEPLOYED")

            default:
                break
            }

            if psStringEDRef == nil {
                break
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot force unwrap value of non-optional type 'String'".
            // Raven wrote: Com_Printf("%s\n", psStringEDRef)
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        //=================================================================
        //
        // other events
        //

    case EV_PLAYER_TELEPORT_IN:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PLAYER_TELEPORT_IN")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        // Port-note: Raven's block leaves a loop outside the record's scope, and the closure cannot.
        // Raven wrote: { trace_t tr; vec3_t playerMins = {-15, -15, DEFAULT_MINS_2+8}; vec3_t playerMaxs = {15, 15, DEFAULT_MAXS_2}; vec3_t ang, pos, dpos; VectorClear(ang); ang[ROLL] = 1; VectorCopy(position, dpos); dpos[2] -= 4096; CG_Trace(&tr, position, playerMins, playerMaxs, dpos, es->number, MASK_SOLID); VectorCopy(tr.endpos, pos); trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.teleInSound ); if (tr.fraction == 1) { break; } trap_FX_PlayEffectID(cgs.effects.mSpawn, pos, ang, -1, -1); }
        portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")

    case EV_PLAYER_TELEPORT_OUT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PLAYER_TELEPORT_OUT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        // Port-note: Raven's block leaves a loop outside the record's scope, and the closure cannot.
        // Raven wrote: { trace_t tr; vec3_t playerMins = {-15, -15, DEFAULT_MINS_2+8}; vec3_t playerMaxs = {15, 15, DEFAULT_MAXS_2}; vec3_t ang, pos, dpos; VectorClear(ang); ang[ROLL] = 1; VectorCopy(position, dpos); dpos[2] -= 4096; CG_Trace(&tr, position, playerMins, playerMaxs, dpos, es->number, MASK_SOLID); VectorCopy(tr.endpos, pos); trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.teleOutSound ); if (tr.fraction == 1) { break; } trap_FX_PlayEffectID(cgs.effects.mSpawn, pos, ang, -1, -1); }
        portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")

    case EV_ITEM_POP:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ITEM_POP")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.respawnSound)

    case EV_ITEM_RESPAWN:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ITEM_RESPAWN")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        cent.miscTime = cg.time // scale up from this
        trap_S_StartSound(nil, es!.number, CHAN_AUTO, cgs.media.respawnSound)

    case EV_GRENADE_BOUNCE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GRENADE_BOUNCE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

    case EV_SCOREPLUM:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SCOREPLUM")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_ScorePlum(cent.currentState.otherEntityNum, cent.lerpOrigin, cent.currentState.time)

    case EV_CTFMESSAGE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_CTFMESSAGE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_GetCTFMessageEvent(es!)

    case EV_BODYFADE:
        if es!.eType != ET_BODY {
            break
        }

        if cent.ghoul2 != nil && trap_G2_HaveWeGhoul2Models(cent.ghoul2) {
            //turn the inside of the face off, to avoid showing the mouth when we start alpha fading the corpse
            trap_G2API_SetSurfaceOnOff(cent.ghoul2, "head_eyes_mouth", 0x00000002)
        }

        cent.bodyFadeTime = cg.time + 60000
        //
        // siege gameplay events
        //

    case EV_SIEGE_ROUNDOVER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SIEGE_ROUNDOVER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_SiegeRoundOver(cg_entities[cent.currentState.weapon], cent.currentState.eventParm)

    case EV_SIEGE_OBJECTIVECOMPLETE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SIEGE_OBJECTIVECOMPLETE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_SiegeObjectiveCompleted(cg_entities[cent.currentState.weapon], cent.currentState.eventParm, cent.currentState.trickedentindex)

    case EV_DESTROY_GHOUL2_INSTANCE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DESTROY_GHOUL2_INSTANCE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_entities[es!.eventParm].ghoul2 != nil && trap_G2_HaveWeGhoul2Models(cg_entities[es!.eventParm].ghoul2) {
            if es!.eventParm < MAX_CLIENTS {
                //You try to do very bad thing!
                break
            }
            trap_G2API_CleanGhoul2Models(&(cg_entities[es!.eventParm].ghoul2))
        }

    case EV_DESTROY_WEAPON_MODEL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DESTROY_WEAPON_MODEL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_entities[es!.eventParm].ghoul2 != nil && trap_G2_HaveWeGhoul2Models(cg_entities[es!.eventParm].ghoul2) && trap_G2API_HasGhoul2ModelOnIndex((cg_entities[es!.eventParm].ghoul2), 1) {
            trap_G2API_RemoveGhoul2Model(&(cg_entities[es!.eventParm].ghoul2), 1)
        }

    case EV_GIVE_NEW_RANK:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GIVE_NEW_RANK")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.trickedentindex == cg.snap!.ps.clientNum {
            trap_Cvar_Set("ui_rankChange", va("%i", es!.eventParm))

            trap_Cvar_Set("ui_myteam", va("%i", es!.bolt2))

            if !((trap_Key_GetCatcher() & KEYCATCH_UI) != 0) && es!.bolt1 == 0 {
                trap_OpenUIMenu(UIMENU_PLAYERCONFIG)
            }
        }

    case EV_SET_FREE_SABER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SET_FREE_SABER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

        trap_Cvar_Set("ui_freeSaber", va("%i", es!.eventParm))

    case EV_SET_FORCE_DISABLE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SET_FORCE_DISABLE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

        trap_Cvar_Set("ui_forcePowerDisable", va("%i", es!.eventParm))
        //
        // missile impacts
        //

    case EV_CONC_ALT_IMPACT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_CONC_ALT_IMPACT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var dist: Float = 0
            let shotDist: Float = VectorNormalize(&es!.angles)
            var spot = vec3_t()

            dist = 0.0
            while dist < shotDist {
                //one effect would be.. a whole lot better
                _VectorMA(es!.origin2, dist, es!.angles, &spot)
                trap_FX_PlayEffectID(cgs.effects.mConcussionAltRing, spot, es!.angles2, -1, -1)
                dist += 64.0
            }

            ByteToDir(es!.eventParm, &dir)
            CG_MissileHitWall(WP_CONCUSSION, es!.owner, position, dir, IMPACTSOUND_DEFAULT, true, 0)

            FX_ConcAltShot(es!.origin2, spot)

            //steal the bezier effect from the disruptor
            FX_DisruptorAltMiss(position, dir)
        }

    case EV_MISSILE_STICK:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_MISSILE_STICK")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

    case EV_MISSILE_HIT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_MISSILE_HIT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        ByteToDir(es!.eventParm, &dir)
        if es!.emplacedOwner != 0 {
            //hack: this is an index to a custom effect to use
            trap_FX_PlayEffectID(cgs.gameEffects[es!.emplacedOwner], position, dir, -1, -1)
        } else if CG_VehicleWeaponImpact(cent) {
            //a vehicle missile that uses an overridden impact effect...
        } else if (cent.currentState.eFlags & EF_ALT_FIRING) != 0 {
            CG_MissileHitPlayer(es!.weapon, position, dir, es!.otherEntityNum, true)
        } else {
            CG_MissileHitPlayer(es!.weapon, position, dir, es!.otherEntityNum, false)
        }

        if cg_ghoul2Marks.integer != 0 && es!.trickedentindex != 0 {
            //flag to place a ghoul2 mark
            CG_G2MarkEvent(es!)
        }

    case EV_MISSILE_MISS:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_MISSILE_MISS")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        ByteToDir(es!.eventParm, &dir)
        if es!.emplacedOwner != 0 {
            //hack: this is an index to a custom effect to use
            trap_FX_PlayEffectID(cgs.gameEffects[es!.emplacedOwner], position, dir, -1, -1)
        } else if CG_VehicleWeaponImpact(cent) {
            //a vehicle missile that used an overridden impact effect...
        } else if (cent.currentState.eFlags & EF_ALT_FIRING) != 0 {
            CG_MissileHitWall(es!.weapon, 0, position, dir, IMPACTSOUND_DEFAULT, true, es!.generic1)
        } else {
            CG_MissileHitWall(es!.weapon, 0, position, dir, IMPACTSOUND_DEFAULT, false, 0)
        }

        if cg_ghoul2Marks.integer != 0 && es!.trickedentindex != 0 {
            //flag to place a ghoul2 mark
            CG_G2MarkEvent(es!)
        }

    case EV_MISSILE_MISS_METAL:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_MISSILE_MISS_METAL")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        ByteToDir(es!.eventParm, &dir)
        if es!.emplacedOwner != 0 {
            //hack: this is an index to a custom effect to use
            trap_FX_PlayEffectID(cgs.gameEffects[es!.emplacedOwner], position, dir, -1, -1)
        } else if CG_VehicleWeaponImpact(cent) {
            //a vehicle missile that used an overridden impact effect...
        } else if (cent.currentState.eFlags & EF_ALT_FIRING) != 0 {
            CG_MissileHitWall(es!.weapon, 0, position, dir, IMPACTSOUND_METAL, true, es!.generic1)
        } else {
            CG_MissileHitWall(es!.weapon, 0, position, dir, IMPACTSOUND_METAL, false, 0)
        }

    case EV_PLAY_EFFECT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PLAY_EFFECT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        switch es!.eventParm {
        case EFFECT_SMOKE:
            eID = cgs.effects.mEmplacedDeadSmoke

        case EFFECT_EXPLOSION:
            eID = cgs.effects.mEmplacedExplode

        case EFFECT_EXPLOSION_PAS:
            eID = cgs.effects.mTurretExplode

        case EFFECT_SPARK_EXPLOSION:
            eID = cgs.effects.mSparkExplosion

        case EFFECT_EXPLOSION_TRIPMINE:
            eID = cgs.effects.mTripmineExplosion

        case EFFECT_EXPLOSION_DETPACK:
            eID = cgs.effects.mDetpackExplosion

        case EFFECT_EXPLOSION_FLECHETTE:
            eID = cgs.effects.mFlechetteAltBlow

        case EFFECT_STUNHIT:
            eID = cgs.effects.mStunBatonFleshImpact

        case EFFECT_EXPLOSION_DEMP2ALT:
            FX_DEMP2_AltDetonate(cent.lerpOrigin, Float(es!.weapon))
            eID = cgs.effects.mAltDetonate

        case EFFECT_EXPLOSION_TURRET:
            eID = cgs.effects.mTurretExplode

        case EFFECT_SPARKS:
            eID = cgs.effects.mSparksExplodeNoSound

        case EFFECT_WATER_SPLASH:
            eID = cgs.effects.waterSplash

        case EFFECT_ACID_SPLASH:
            eID = cgs.effects.acidSplash

        case EFFECT_LAVA_SPLASH:
            eID = cgs.effects.lavaSplash

        case EFFECT_LANDING_MUD:
            eID = cgs.effects.landingMud

        case EFFECT_LANDING_SAND:
            eID = cgs.effects.landingSand

        case EFFECT_LANDING_DIRT:
            eID = cgs.effects.landingDirt

        case EFFECT_LANDING_SNOW:
            eID = cgs.effects.landingSnow

        case EFFECT_LANDING_GRAVEL:
            eID = cgs.effects.landingGravel

        default:
            eID = -1
        }

        if eID != -1 {
            var fxDir = vec3_t()

            fxDir = es!.angles

            if fxDir[0] == 0 && fxDir[1] == 0 && fxDir[2] == 0 {
                fxDir[1] = 1
            }

            trap_FX_PlayEffectID(eID, es!.origin, fxDir, -1, -1)
        }

    case EV_PLAY_EFFECT_ID, EV_PLAY_PORTAL_EFFECT_ID:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PLAY_EFFECT_ID")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var fxDir = vec3_t()
            var portalEffect: Bool = false
            var efxIndex: Int32 = 0

            if event == EV_PLAY_PORTAL_EFFECT_ID {
                //This effect should only be played inside sky portals.
                portalEffect = true
            }

            // Raven passes NULL for the `right` and `up` outputs.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(es!.angles, &fxDir, &scratchRight, &scratchUp)

            if fxDir[0] == 0 && fxDir[1] == 0 && fxDir[2] == 0 {
                fxDir[1] = 1
            }

            if cgs.gameEffects[es!.eventParm] != 0 {
                efxIndex = cgs.gameEffects[es!.eventParm]
            } else {
                s = CG_ConfigString(CS_EFFECTS + es!.eventParm)
                if !s.isEmpty {
                    efxIndex = trap_FX_RegisterEffect(s)
                }
            }

            if efxIndex != 0 {
                if portalEffect {
                    trap_FX_PlayPortalEffectID(efxIndex, position, fxDir, -1, -1)
                } else {
                    trap_FX_PlayEffectID(efxIndex, position, fxDir, -1, -1)
                }
            }
        }

    case EV_PLAYDOORSOUND:
        CG_PlayDoorSound(cent, es!.eventParm)

    case EV_PLAYDOORLOOPSOUND:
        CG_PlayDoorLoopSound(cent)

    case EV_BMODEL_SOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_BMODEL_SOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        do {
            var sfx: sfxHandle_t = 0
            var soundSet: String

            soundSet = CG_ConfigString(CS_AMBIENT_SET + es!.soundSetIndex)

            if soundSet.isEmpty {
                break
            }

            sfx = trap_AS_GetBModelSound(soundSet, es!.eventParm)

            if sfx == -1 {
                break
            }

            trap_S_StartSound(nil, es!.number, CHAN_AUTO, sfx)
        }

    case EV_MUTE_SOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_MUTE_SOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if (cg_entities[es!.trickedentindex2].currentState.eFlags & EF_SOUNDTRACKER) != 0 {
            cg_entities[es!.trickedentindex2].currentState.eFlags -= EF_SOUNDTRACKER
        }
        trap_S_MuteSound(es!.trickedentindex2, es!.trickedentindex)
        CG_S_StopLoopingSound(es!.trickedentindex2, -1)

    case EV_VOICECMD_SOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_VOICECMD_SOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.groundEntityNum >= MAX_CLIENTS {
            //don't ever use this unless it is being used on a real client
            break
        }
        do {
            var sfx: sfxHandle_t = cgs.gameSounds[es!.eventParm]
            var ci: ClientInfo? = cgs.clientinfo[es!.groundEntityNum]
            let vChatEnt: Centity? = cg_entities[es!.groundEntityNum]
            var descr = CharBuf(1024)

            strcpy(&descr, CG_GetStringForVoiceSound(CG_ConfigString(CS_SOUNDS + es!.eventParm)))

            if sfx == 0 {
                s = CG_ConfigString(CS_SOUNDS + es!.eventParm)
                sfx = CG_CustomSound(es!.groundEntityNum, s)
            }

            if sfx != 0 {
                if es!.groundEntityNum != cg.predictedPlayerState.clientNum {
                    //play on the head as well to simulate hearing in radio and in world
                    if ci!.team == cg.predictedPlayerState.persistant[PERS_TEAM] {
                        //don't hear it if this person is on the other team, but they can still
                        //hear it in the world spot.
                        trap_S_StartSound(nil, cg.snap!.ps.clientNum, CHAN_MENU1, sfx)
                    }
                }
                if ci!.team == cg.predictedPlayerState.persistant[PERS_TEAM] {
                    //add to the chat box
                    //hear it in the world spot.
                    var vchatstr = CharBuf(1024)
                    strcpy(&vchatstr, va("<%s: %s>\n", ci!.name, descr))
                    CG_Printf(String(vchatstr))
                    CG_ChatBox_AddString(&vchatstr)
                }

                //and play in world for everyone
                trap_S_StartSound(nil, es!.groundEntityNum, CHAN_VOICE, sfx)
                vChatEnt!.vChatTime = cg.time + 1000
            }
        }

    case EV_GENERAL_SOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GENERAL_SOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.saberEntityNum == TRACK_CHANNEL_2 || es!.saberEntityNum == TRACK_CHANNEL_3 || es!.saberEntityNum == TRACK_CHANNEL_5 {
            //channels 2 and 3 are for speed and rage, 5 for sight
            if cgs.gameSounds[es!.eventParm] != 0 {
                CG_S_AddRealLoopingSound(es!.number, es!.pos.trBase, vec3_origin, cgs.gameSounds[es!.eventParm])
            }
        } else {
            if cgs.gameSounds[es!.eventParm] != 0 {
                trap_S_StartSound(nil, es!.number, es!.saberEntityNum, cgs.gameSounds[es!.eventParm])
            } else {
                s = CG_ConfigString(CS_SOUNDS + es!.eventParm)
                trap_S_StartSound(nil, es!.number, es!.saberEntityNum, CG_CustomSound(es!.number, s))
            }
        }

    case EV_GLOBAL_SOUND: // play from the player's head so it never diminishes
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GLOBAL_SOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cgs.gameSounds[es!.eventParm] != 0 {
            trap_S_StartSound(nil, cg.snap!.ps.clientNum, CHAN_MENU1, cgs.gameSounds[es!.eventParm])
        } else {
            s = CG_ConfigString(CS_SOUNDS + es!.eventParm)
            trap_S_StartSound(nil, cg.snap!.ps.clientNum, CHAN_MENU1, CG_CustomSound(es!.number, s))
        }

    case EV_GLOBAL_TEAM_SOUND: // play from the player's head so it never diminishes
        do {
            if cg_debugEvents.integer != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
                // Raven wrote: DEBUGNAME("EV_GLOBAL_TEAM_SOUND")
                portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
            }
            switch es!.eventParm {
            case GTS_RED_CAPTURE: // CTF: red team captured the blue flag, 1FCTF: red team captured the neutral flag
                //CG_AddBufferedSound( cgs.media.redScoredSound );
                break

            case GTS_BLUE_CAPTURE: // CTF: blue team captured the red flag, 1FCTF: blue team captured the neutral flag
                //CG_AddBufferedSound( cgs.media.blueScoredSound );
                break

            case GTS_RED_RETURN: // CTF: blue flag returned, 1FCTF: never used
                if cgs.gametype == GT_CTY {
                    CG_AddBufferedSound(cgs.media.blueYsalReturnedSound)
                } else {
                    CG_AddBufferedSound(cgs.media.blueFlagReturnedSound)
                }

            case GTS_BLUE_RETURN: // CTF red flag returned, 1FCTF: neutral flag returned
                if cgs.gametype == GT_CTY {
                    CG_AddBufferedSound(cgs.media.redYsalReturnedSound)
                } else {
                    CG_AddBufferedSound(cgs.media.redFlagReturnedSound)
                }

            case GTS_RED_TAKEN: // CTF: red team took blue flag, 1FCTF: blue team took the neutral flag
                // if this player picked up the flag then a sound is played in CG_CheckLocalSounds
                if cgs.gametype == GT_CTY {
                    CG_AddBufferedSound(cgs.media.redTookYsalSound)
                } else {
                    CG_AddBufferedSound(cgs.media.redTookFlagSound)
                }

            case GTS_BLUE_TAKEN: // CTF: blue team took the red flag, 1FCTF red team took the neutral flag
                // if this player picked up the flag then a sound is played in CG_CheckLocalSounds
                if cgs.gametype == GT_CTY {
                    CG_AddBufferedSound(cgs.media.blueTookYsalSound)
                } else {
                    CG_AddBufferedSound(cgs.media.blueTookFlagSound)
                }

            case GTS_REDTEAM_SCORED:
                CG_AddBufferedSound(cgs.media.redScoredSound)

            case GTS_BLUETEAM_SCORED:
                CG_AddBufferedSound(cgs.media.blueScoredSound)

            case GTS_REDTEAM_TOOK_LEAD:
                CG_AddBufferedSound(cgs.media.redLeadsSound)

            case GTS_BLUETEAM_TOOK_LEAD:
                CG_AddBufferedSound(cgs.media.blueLeadsSound)

            case GTS_TEAMS_ARE_TIED:
                CG_AddBufferedSound(cgs.media.teamsTiedSound)

            default:
                break
            }
            break
        }
        fallthrough

    case EV_ENTITY_SOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_ENTITY_SOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        //somewhat of a hack - weapon is the caller entity's index, trickedentindex is the proper sound channel
        if cgs.gameSounds[es!.eventParm] != 0 {
            trap_S_StartSound(nil, es!.clientNum, es!.trickedentindex, cgs.gameSounds[es!.eventParm])
        } else {
            s = CG_ConfigString(CS_SOUNDS + es!.eventParm)
            trap_S_StartSound(nil, es!.clientNum, es!.trickedentindex, CG_CustomSound(es!.clientNum, s))
        }

    case EV_PLAY_ROFF:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PLAY_ROFF")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        trap_ROFF_Play(es!.weapon, es!.eventParm, es!.trickedentindex != 0)

    case EV_GLASS_SHATTER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GLASS_SHATTER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_GlassShatter(es!.genericenemyindex, es!.origin, es!.angles, Float(es!.trickedentindex), es!.pos.trTime)

    case EV_DEBRIS:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DEBRIS")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_Chunks(es!.owner, es!.origin, es!.angles, es!.origin2, es!.angles2, es!.speed, es!.eventParm, es!.trickedentindex, es!.modelindex, es!.apos.trBase[0])

    case EV_MISC_MODEL_EXP:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_MISC_MODEL_EXP")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_MiscModelExplosion(es!.origin2, es!.angles2, es!.time, es!.eventParm)

    case EV_PAIN:
        // local player sounds are triggered in CG_CheckLocalSounds,
        // so ignore events on the player
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_PAIN")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

        if cg_oldPainSounds.integer == 0 || (cent.currentState.number != cg.snap!.ps.clientNum) {
            CG_PainEvent(cent, es!.eventParm)
        }

    case EV_DEATH1, EV_DEATH2, EV_DEATH3:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DEATHx")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        trap_S_StartSound(nil, es!.number, CHAN_VOICE, CG_CustomSound(es!.number, va("*death%i.wav", event - EV_DEATH1 + 1)))
        if es!.eventParm != 0 && es!.number == cg.snap!.ps.clientNum {
            trap_S_StartLocalSound(cgs.media.dramaticFailure, CHAN_LOCAL)
            CGCam_SetMusicMult(0.3, 5000)
        }

    case EV_OBITUARY:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_OBITUARY")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_Obituary(es!)
        //
        // powerup events
        //

    case EV_POWERUP_QUAD:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_POWERUP_QUAD")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.number == cg.snap!.ps.clientNum {
            cg.powerupActive = PW_QUAD
            cg.powerupTime = cg.time
        }

    case EV_POWERUP_BATTLESUIT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_POWERUP_BATTLESUIT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if es!.number == cg.snap!.ps.clientNum {
            cg.powerupActive = PW_BATTLESUIT
            cg.powerupTime = cg.time
        }

    case EV_FORCE_DRAINED:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_FORCE_DRAINED")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        ByteToDir(es!.eventParm, &dir)
        //FX_ForceDrained(position, dir);
        trap_S_StartSound(nil, es!.owner, CHAN_AUTO, cgs.media.drainSound)
        cg_entities[es!.owner].teamPowerEffectTime = cg.time + 1000
        cg_entities[es!.owner].teamPowerType = 2 != 0

    case EV_GIB_PLAYER:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_GIB_PLAYER")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }

    case EV_STARTLOOPINGSOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_STARTLOOPINGSOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cgs.gameSounds[es!.eventParm] != 0 {
            isnd = cgs.gameSounds[es!.eventParm]
        } else {
            s = CG_ConfigString(CS_SOUNDS + es!.eventParm)
            isnd = CG_CustomSound(es!.number, s)
        }

        CG_S_AddRealLoopingSound(es!.number, es!.pos.trBase, vec3_origin, isnd)
        es!.loopSound = isnd

    case EV_STOPLOOPINGSOUND:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_STOPLOOPINGSOUND")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_S_StopLoopingSound(es!.number, -1)
        es!.loopSound = 0

    case EV_WEAPON_CHARGE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_WEAPON_CHARGE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_weapons[es!.eventParm].chargeSound != 0 {
            trap_S_StartSound(nil, es!.number, CHAN_WEAPON, cg_weapons[es!.eventParm].chargeSound)
        } else if es!.eventParm == WP_DISRUPTOR {
            trap_S_StartSound(nil, es!.number, CHAN_WEAPON, cgs.media.disruptorZoomLoop)
        }

    case EV_WEAPON_CHARGE_ALT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_WEAPON_CHARGE_ALT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        if cg_weapons[es!.eventParm].altChargeSound != 0 {
            trap_S_StartSound(nil, es!.number, CHAN_WEAPON, cg_weapons[es!.eventParm].altChargeSound)
        }

    case EV_SHIELD_HIT:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_SHIELD_HIT")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        ByteToDir(es!.eventParm, &dir)
        CG_PlayerShieldHit(es!.otherEntityNum, &dir, es!.time2)

    case EV_DEBUG_LINE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_DEBUG_LINE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_Beam(cent)

    case EV_TESTLINE:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("EV_TESTLINE")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'UInt32'".
        // Raven wrote: CG_TestLine(es->origin, es->origin2, es->time2, es->weapon, 1)
        portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")

    default:
        if cg_debugEvents.integer != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'DEBUGNAME' in scope".
            // Raven wrote: DEBUGNAME("UNKNOWN")
            portMissing("CG_EntityEvent", source: "oracle/codemp/cgame/cg_event.c:1491")
        }
        CG_Error("Unknown event: %i", event)
    }
}

/**
```
==============
CG_CheckEvents

==============
```
*/
/// Source: oracle/codemp/cgame/cg_event.c:3700
func CG_CheckEvents(_ cent: Centity) {
    // check for event-only entities
    if cent.currentState.eType > ET_EVENTS {
        if cent.previousEvent != 0 {
            return // already fired
        }
        // if this is a player event set the entity number of the client entity number
        if (cent.currentState.eFlags & EF_PLAYER_EVENT) != 0 {
            cent.currentState.number = cent.currentState.otherEntityNum
        }

        cent.previousEvent = 1

        cent.currentState.event = cent.currentState.eType - ET_EVENTS
    } else {
        // check for events riding with another entity
        if cent.currentState.event == cent.previousEvent {
            return
        }
        cent.previousEvent = cent.currentState.event
        if (cent.currentState.event & ~EV_EVENT_BITS) == 0 {
            return
        }
    }

    // calculate the position at exactly the frame time
    BG_EvaluateTrajectory(cent.currentState.pos, cg.snap!.serverTime, &cent.lerpOrigin)
    CG_SetEntitySoundPosition(cent)

    CG_EntityEvent(cent, cent.lerpOrigin)
}
