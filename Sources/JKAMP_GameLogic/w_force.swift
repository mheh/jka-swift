import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/w_force.c:7
private let METROID_JUMP = 1 as Int32

/// Source: oracle/codemp/game/w_force.c:24
var speedLoopSound: Int32 {
    get { world.variables.speedLoopSound }
    set { world.variables.speedLoopSound = newValue }
}

/// Source: oracle/codemp/game/w_force.c:26
var rageLoopSound: Int32 {
    get { world.variables.rageLoopSound }
    set { world.variables.rageLoopSound = newValue }
}

/// Source: oracle/codemp/game/w_force.c:28
var protectLoopSound: Int32 {
    get { world.variables.protectLoopSound }
    set { world.variables.protectLoopSound = newValue }
}

/// Source: oracle/codemp/game/w_force.c:30
var absorbLoopSound: Int32 {
    get { world.variables.absorbLoopSound }
    set { world.variables.absorbLoopSound = newValue }
}

/// Source: oracle/codemp/game/w_force.c:32
var seeLoopSound: Int32 {
    get { world.variables.seeLoopSound }
    set { world.variables.seeLoopSound = newValue }
}

/// Source: oracle/codemp/game/w_force.c:34
var ysalamiriLoopSound: Int32 {
    get { world.variables.ysalamiriLoopSound }
    set { world.variables.ysalamiriLoopSound = newValue }
}

/// Source: oracle/codemp/game/w_force.c:36
let FORCE_VELOCITY_DAMAGE = 0 as Int32

/// Source: oracle/codemp/game/w_force.c:51
// Raven wrote: const int forcePowerMinRank[NUM_FORCE_POWER_LEVELS][NUM_FORCE_POWERS]
let forcePowerMinRank: [[Int32]] = { () -> [[Int32]] in portMissing("forcePowerMinRank", source: "oracle/codemp/game/w_force.c:51") }()

/// Source: oracle/codemp/game/w_force.c:139
// Raven wrote: const int mindTrickTime[NUM_FORCE_POWER_LEVELS]
let mindTrickTime: [Int32] = { () -> [Int32] in portMissing("mindTrickTime", source: "oracle/codemp/game/w_force.c:139") }()

/// Source: oracle/codemp/game/w_force.c:3044
// Raven wrote: float forcePushPullRadius[NUM_FORCE_POWER_LEVELS]
let forcePushPullRadius: [Float] = { () -> [Float] in portMissing("forcePushPullRadius", source: "oracle/codemp/game/w_force.c:3044") }()

/// Source: oracle/codemp/game/w_force.c:40
func G_PreDefSound(_ org: JKAShared.vec3_t, _ pdSound: Int32) -> Entity? {
    var te: Entity?

    te = G_TempEntity(org, EV_PREDEFSOUND)
    te!.s.eventParm = pdSound
    te!.s.origin = org

    return te
}

/// Source: oracle/codemp/game/w_force.c:147
func WP_InitForcePowers(_ ent: Entity) {
    var i: Int32
    var i_r: Int32
    var maxRank: Int32 = g_maxForceRank.integer
    var warnClient: Bool = false
    let warnClientLimit: Bool = false
    var userinfo = CharBuf(1024)
    var forcePowers = CharBuf(256)
    var readBuf = CharBuf(256)
    var lastFPKnown: Int32 = -1
    var didEvent: Bool = false

    if maxRank == 0 {
        //if server has no max rank, default to max (50)
        maxRank = FORCE_MASTERY_JEDI_MASTER
    } else if maxRank >= NUM_FORCE_MASTERY_LEVELS {
        //ack, prevent user from being dumb
        maxRank = FORCE_MASTERY_JEDI_MASTER
        trap_Cvar_Set("g_maxForceRank", va("%i", maxRank))
    }

    /*
    if (g_forcePowerDisable.integer)
    {
    maxRank = FORCE_MASTERY_UNINITIATED;
    }
    */
    //rww - don't do this

    if ent.client == nil {
        return
    }

    ent.client!.ps.fd.saberAnimLevel = ent.client!.sess.saberLevel

    if ent.client!.ps.fd.saberAnimLevel < FORCE_LEVEL_1 || ent.client!.ps.fd.saberAnimLevel > FORCE_LEVEL_3 {
        ent.client!.ps.fd.saberAnimLevel = FORCE_LEVEL_1
    }

    if speedLoopSound == 0 {
        //so that the client configstring is already modified with this when we need it
        speedLoopSound = G_SoundIndex("sound/weapons/force/speedloop.wav")
    }

    if rageLoopSound == 0 {
        rageLoopSound = G_SoundIndex("sound/weapons/force/rageloop.wav")
    }

    if absorbLoopSound == 0 {
        absorbLoopSound = G_SoundIndex("sound/weapons/force/absorbloop.wav")
    }

    if protectLoopSound == 0 {
        protectLoopSound = G_SoundIndex("sound/weapons/force/protectloop.wav")
    }

    if seeLoopSound == 0 {
        seeLoopSound = G_SoundIndex("sound/weapons/force/seeloop.wav")
    }

    if ysalamiriLoopSound == 0 {
        ysalamiriLoopSound = G_SoundIndex("sound/player/nullifyloop.wav")
    }

    if ent.s.eType == ET_NPC {
        //just stop here then.
        return
    }

    i = 0
    while i < NUM_FORCE_POWERS {
        ent.client!.ps.fd.forcePowerLevel[i] = 0
        ent.client!.ps.fd.forcePowersKnown &= ~(1 << i)
        i += 1
    }

    ent.client!.ps.fd.forcePowerSelected = -1

    ent.client!.ps.fd.forceSide = 0

    if g_gametype.integer == GT_SIEGE && ent.client!.siegeClass != -1 {
        //Then use the powers for this class, and skip all this nonsense.
        i = 0

        while i < NUM_FORCE_POWERS {
            ent.client!.ps.fd.forcePowerLevel[i] = bgSiegeClasses[ent.client!.siegeClass].forcePowerLevels[i]

            if ent.client!.ps.fd.forcePowerLevel[i] == 0 {
                ent.client!.ps.fd.forcePowersKnown &= ~(1 << i)
            } else {
                ent.client!.ps.fd.forcePowersKnown |= (1 << i)
            }
            i += 1
        }

        if !ent.client!.sess.setForce {
            //bring up the class selection menu
            trap_SendServerCommand(ent.s.number, "scl")
        }
        ent.client!.sess.setForce = true

        return
    }

    if ent.s.eType == ET_NPC && ent.s.number >= MAX_CLIENTS {
        //rwwFIXMEFIXME: Temp
        strcpy(&userinfo, "forcepowers\\7-1-333003000313003120")
    } else {
        strcpy(&userinfo, trap_GetUserinfo(ent.s.number, Int32((userinfo).count)))
    }

    Q_strncpyz(&forcePowers, Info_ValueForKey(String(userinfo), "forcepowers"), Int32((forcePowers).count))

    if (ent.r.svFlags & SVF_BOT) != 0 && botstates[ent.s.number] != nil {
        //if it's a bot just copy the info directly from its personality
        Com_sprintf(&forcePowers, Int32((forcePowers).count), "%s\0", botstates[ent.s.number]!.forceinfo)
    }

    //rww - parse through the string manually and eat out all the appropriate data
    i = 0

    if g_forceBasedTeams.integer != 0 {
        if ent.client!.sess.sessionTeam == TEAM_RED {
            warnClient = !(BG_LegalizedForcePowers(&forcePowers, maxRank, HasSetSaberOnly(), FORCE_DARKSIDE, g_gametype.integer, g_forcePowerDisable.integer))
        } else if ent.client!.sess.sessionTeam == TEAM_BLUE {
            warnClient = !(BG_LegalizedForcePowers(&forcePowers, maxRank, HasSetSaberOnly(), FORCE_LIGHTSIDE, g_gametype.integer, g_forcePowerDisable.integer))
        } else {
            warnClient = !(BG_LegalizedForcePowers(&forcePowers, maxRank, HasSetSaberOnly(), 0, g_gametype.integer, g_forcePowerDisable.integer))
        }
    } else {
        warnClient = !(BG_LegalizedForcePowers(&forcePowers, maxRank, HasSetSaberOnly(), 0, g_gametype.integer, g_forcePowerDisable.integer))
    }

    i_r = 0
    while forcePowers[i] != 0 && forcePowers[i] != Int32(ascii: "-") {
        readBuf[i_r] = forcePowers[i]
        i_r += 1
        i += 1
    }
    readBuf[i_r] = 0
    //THE RANK
    ent.client!.ps.fd.forceRank = atoi(readBuf)
    i += 1

    i_r = 0
    while forcePowers[i] != 0 && forcePowers[i] != Int32(ascii: "-") {
        readBuf[i_r] = forcePowers[i]
        i_r += 1
        i += 1
    }
    readBuf[i_r] = 0
    //THE SIDE
    ent.client!.ps.fd.forceSide = atoi(readBuf)
    i += 1


    if g_gametype.integer != GT_SIEGE && (ent.r.svFlags & SVF_BOT) != 0 && botstates[ent.s.number] != nil {
        //hmm..I'm going to cheat here.
        let oldI: Int32 = i
        i_r = 0
        while forcePowers[i] != 0 && forcePowers[i] != Int32(ascii: "\n") && i_r < NUM_FORCE_POWERS {
            if ent.client!.ps.fd.forceSide == FORCE_LIGHTSIDE {
                if i_r == FP_ABSORB {
                    forcePowers[i] = Int32(ascii: "3")
                }
                if botstates[ent.s.number]!.settings.skill >= 4 {
                    //cheat and give them more stuff
                    if i_r == FP_HEAL {
                        forcePowers[i] = Int32(ascii: "3")
                    } else if i_r == FP_PROTECT {
                        forcePowers[i] = Int32(ascii: "3")
                    }
                }
            } else if ent.client!.ps.fd.forceSide == FORCE_DARKSIDE {
                if botstates[ent.s.number]!.settings.skill >= 4 {
                    if i_r == FP_GRIP {
                        forcePowers[i] = Int32(ascii: "3")
                    } else if i_r == FP_LIGHTNING {
                        forcePowers[i] = Int32(ascii: "3")
                    } else if i_r == FP_RAGE {
                        forcePowers[i] = Int32(ascii: "3")
                    } else if i_r == FP_DRAIN {
                        forcePowers[i] = Int32(ascii: "3")
                    }
                }
            }

            if i_r == FP_PUSH {
                forcePowers[i] = Int32(ascii: "3")
            } else if i_r == FP_PULL {
                forcePowers[i] = Int32(ascii: "3")
            }

            i += 1
            i_r += 1
        }
        i = oldI
    }

    i_r = 0
    while forcePowers[i] != 0 && forcePowers[i] != Int32(ascii: "\n") && i_r < NUM_FORCE_POWERS {
        readBuf[0] = forcePowers[i]
        readBuf[1] = 0

        ent.client!.ps.fd.forcePowerLevel[i_r] = atoi(readBuf)
        if ent.client!.ps.fd.forcePowerLevel[i_r] != 0 {
            ent.client!.ps.fd.forcePowersKnown |= (1 << i_r)
        } else {
            ent.client!.ps.fd.forcePowersKnown &= ~(1 << i_r)
        }
        i += 1
        i_r += 1
    }
    //THE POWERS

    if ent.s.eType != ET_NPC {
        if HasSetSaberOnly() {
            let te: Entity? = G_TempEntity(vec3_origin, EV_SET_FREE_SABER)
            te!.r.svFlags |= SVF_BROADCAST
            te!.s.eventParm = 1
        } else {
            let te: Entity? = G_TempEntity(vec3_origin, EV_SET_FREE_SABER)
            te!.r.svFlags |= SVF_BROADCAST
            te!.s.eventParm = 0
        }

        if g_forcePowerDisable.integer != 0 {
            let te: Entity? = G_TempEntity(vec3_origin, EV_SET_FORCE_DISABLE)
            te!.r.svFlags |= SVF_BROADCAST
            te!.s.eventParm = 1
        } else {
            let te: Entity? = G_TempEntity(vec3_origin, EV_SET_FORCE_DISABLE)
            te!.r.svFlags |= SVF_BROADCAST
            te!.s.eventParm = 0
        }
    }

    //rww - It seems we currently want to always do this, even if the player isn't exceeding the max
    //rank, so..
    //	if (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL)
    //	{ //totally messes duel up to force someone into spec mode, and besides, each "round" is
    //counted as a full restart
    //		ent->client->sess.setForce = qtrue;
    //	}

    if ent.s.eType == ET_NPC {
        ent.client!.sess.setForce = true
    } else if g_gametype.integer == GT_SIEGE {
        if !ent.client!.sess.setForce {
            ent.client!.sess.setForce = true
            //bring up the class selection menu
            trap_SendServerCommand(ent.s.number, "scl")
        }
    } else {
        if warnClient || !ent.client!.sess.setForce {
            //the client's rank is too high for the server and has been autocapped, so tell them
            if g_gametype.integer != GT_HOLOCRON && g_gametype.integer != GT_JEDIMASTER {
                didEvent = true

                //				if (!(ent->r.svFlags & SVF_BOT) && g_gametype.integer != GT_DUEL && g_gametype.integer != GT_POWERDUEL && ent->s.eType != ET_NPC)
                if !((ent.r.svFlags & SVF_BOT) != 0) && ent.s.eType != ET_NPC {
                    if g_teamAutoJoin.integer == 0 {
                        //Make them a spectator so they can set their powerups up without being bothered.
                        ent.client!.sess.sessionTeam = TEAM_SPECTATOR
                        ent.client!.sess.spectatorState = SPECTATOR_FREE
                        ent.client!.sess.spectatorClient = 0

                        ent.client!.pers.teamState.state = TEAM_BEGIN
                        trap_SendServerCommand(ent.s.number, "spc") // Fire up the profile menu
                    }
                }

                //Event isn't very reliable, I made it a string. This way I can send it to just one
                //client also, as opposed to making a broadcast event.
                trap_SendServerCommand(ent.s.number, va("nfr %i %i %i", maxRank, 1, ent.client!.sess.sessionTeam))
                //Arg1 is new max rank, arg2 is non-0 if force menu should be shown, arg3 is the current team
            }
            ent.client!.sess.setForce = true
        }

        if !didEvent {
            trap_SendServerCommand(ent.s.number, va("nfr %i %i %i", maxRank, 0, ent.client!.sess.sessionTeam))
        }

        if warnClientLimit {
            //the server has one or more force powers disabled and the client is using them in his config
            //trap_SendServerCommand(ent-g_entities, va("print \"The server has one or more force powers that you have chosen disabled.\nYou will not be able to use the disable force power(s) while playing on this server.\n\""));
        }
    }

    i = 0
    while i < NUM_FORCE_POWERS {
        if (ent.client!.ps.fd.forcePowersKnown & (1 << i)) != 0 && ent.client!.ps.fd.forcePowerLevel[i] == 0 {
            //err..
            ent.client!.ps.fd.forcePowersKnown &= ~(1 << i)
        } else {
            if i != FP_LEVITATION && i != FP_SABER_OFFENSE && i != FP_SABER_DEFENSE && i != FP_SABERTHROW {
                lastFPKnown = i
            }
        }

        i += 1
    }

    if (ent.client!.ps.fd.forcePowersKnown & ent.client!.sess.selectedFP) != 0 {
        ent.client!.ps.fd.forcePowerSelected = ent.client!.sess.selectedFP
    }

    if !((ent.client!.ps.fd.forcePowersKnown & (1 << ent.client!.ps.fd.forcePowerSelected)) != 0) {
        if lastFPKnown != -1 {
            ent.client!.ps.fd.forcePowerSelected = lastFPKnown
        } else {
            ent.client!.ps.fd.forcePowerSelected = 0
        }
    }

    while i < NUM_FORCE_POWERS {
        ent.client!.ps.fd.forcePowerBaseLevel[i] = ent.client!.ps.fd.forcePowerLevel[i]
        i += 1
    }
    ent.client!.ps.fd.forceUsingAdded = 0
}

/// Source: oracle/codemp/game/w_force.c:574
func WP_SpawnInitForcePowers(_ ent: Entity) {
    var i: Int32 = 0

    ent.client!.ps.saberAttackChainCount = 0

    i = 0

    while i < NUM_FORCE_POWERS {
        if (ent.client!.ps.fd.forcePowersActive & (1 << i)) != 0 {
            WP_ForcePowerStop(ent, i)
        }

        i += 1
    }

    ent.client!.ps.fd.forceDeactivateAll = 0

    ent.client!.ps.fd.forcePowerMax = FORCE_POWER_MAX
    ent.client!.ps.fd.forcePower = ent.client!.ps.fd.forcePowerMax
    ent.client!.ps.fd.forcePowerRegenDebounceTime = 0
    ent.client!.ps.fd.forceGripEntityNum = ENTITYNUM_NONE
    ent.client!.ps.fd.forceMindtrickTargetIndex = 0
    ent.client!.ps.fd.forceMindtrickTargetIndex2 = 0
    ent.client!.ps.fd.forceMindtrickTargetIndex3 = 0
    ent.client!.ps.fd.forceMindtrickTargetIndex4 = 0

    ent.client!.ps.holocronBits = 0

    i = 0
    while i < NUM_FORCE_POWERS {
        ent.client!.ps.holocronsCarried[i] = 0
        i += 1
    }

    if g_gametype.integer == GT_HOLOCRON {
        i = 0
        while i < NUM_FORCE_POWERS {
            ent.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_0
            i += 1
        }

        if HasSetSaberOnly() {
            if ent.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] < FORCE_LEVEL_1 {
                ent.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] = FORCE_LEVEL_1
            }
            if ent.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] < FORCE_LEVEL_1 {
                ent.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] = FORCE_LEVEL_1
            }
        }
    }

    i = 0

    while i < NUM_FORCE_POWERS {
        ent.client!.ps.fd.forcePowerDebounce[i] = 0
        ent.client!.ps.fd.forcePowerDuration[i] = 0

        i += 1
    }

    ent.client!.ps.fd.forcePowerRegenDebounceTime = 0
    ent.client!.ps.fd.forceJumpZStart = 0
    ent.client!.ps.fd.forceJumpCharge = 0
    ent.client!.ps.fd.forceJumpSound = 0
    ent.client!.ps.fd.forceGripDamageDebounceTime = 0
    ent.client!.ps.fd.forceGripBeingGripped = 0
    ent.client!.ps.fd.forceGripCripple = 0
    ent.client!.ps.fd.forceGripUseTime = 0
    ent.client!.ps.fd.forceGripSoundTime = 0
    ent.client!.ps.fd.forceGripStarted = 0
    ent.client!.ps.fd.forceHealTime = 0
    ent.client!.ps.fd.forceHealAmount = 0
    ent.client!.ps.fd.forceRageRecoveryTime = 0
    ent.client!.ps.fd.forceDrainEntNum = ENTITYNUM_NONE
    ent.client!.ps.fd.forceDrainTime = 0

    i = 0
    while i < NUM_FORCE_POWERS {
        if (ent.client!.ps.fd.forcePowersKnown & (1 << i)) != 0 && ent.client!.ps.fd.forcePowerLevel[i] == 0 {
            //make sure all known powers are cleared if we have level 0 in them
            ent.client!.ps.fd.forcePowersKnown &= ~(1 << i)
        }

        i += 1
    }

    if g_gametype.integer == GT_SIEGE && ent.client!.siegeClass != -1 {
        //Then use the powers for this class.
        i = 0

        while i < NUM_FORCE_POWERS {
            ent.client!.ps.fd.forcePowerLevel[i] = bgSiegeClasses[ent.client!.siegeClass].forcePowerLevels[i]

            if ent.client!.ps.fd.forcePowerLevel[i] == 0 {
                ent.client!.ps.fd.forcePowersKnown &= ~(1 << i)
            } else {
                ent.client!.ps.fd.forcePowersKnown |= (1 << i)
            }
            i += 1
        }
    }
}

/// Source: oracle/codemp/game/w_force.c:697
func ForcePowerUsableOn(_ attacker: Entity, _ other: Entity, _ forcePower: JKAMP.forcePowers_t) -> Int32 {
    if other.client != nil && BG_HasYsalamiri(g_gametype.integer, other.client!.ps) {
        return 0
    }

    if attacker.client != nil && !BG_CanUseFPNow(g_gametype.integer, attacker.client!.ps, level.time, forcePower) {
        return 0
    }

    //Dueling fighters cannot use force powers on others, with the exception of force push when locked with each other
    if attacker.client != nil && attacker.client!.ps.duelInProgress {
        return 0
    }

    if other.client != nil && other.client!.ps.duelInProgress {
        return 0
    }

    if forcePower == FP_GRIP {
        if other.client != nil && (other.client!.ps.fd.forcePowersActive & (1 << FP_ABSORB)) != 0 {
            //don't allow gripping to begin with if they are absorbing
            //play sound indicating that attack was absorbed
            if other.client!.forcePowerSoundDebounce < level.time {
                let abSound: Entity? = G_PreDefSound(other.client!.ps.origin, PDSOUND_ABSORBHIT)
                abSound!.s.trickedentindex = other.s.number
                other.client!.forcePowerSoundDebounce = level.time + 400
            }
            return 0
        } else if other.client != nil && other.client!.ps.weapon == WP_SABER && BG_SaberInSpecial(other.client!.ps.saberMove) {
            //don't grip person while they are in a special or some really bad things can happen.
            return 0
        }
    }

    if other.client != nil && (forcePower == FP_PUSH || forcePower == FP_PULL) {
        if BG_InKnockDown(other.client!.ps.legsAnim) {
            return 0
        }
    }

    if other.client != nil && other.s.eType == ET_NPC && other.s.NPC_class == CLASS_VEHICLE {
        //can't use the force on vehicles.. except lightning
        if forcePower == FP_LIGHTNING {
            return 1
        } else {
            return 0
        }
    }

    if other.client != nil && other.s.eType == ET_NPC && g_gametype.integer == GT_SIEGE {
        //can't use powers at all on npc's normally in siege...
        return 0
    }

    return 1
}

/// Source: oracle/codemp/game/w_force.c:774
func WP_ForcePowerAvailable(_ `self`: Entity, _ forcePower: JKAMP.forcePowers_t, _ overrideAmt: Int32) -> Bool {
    let drain: Int32 = overrideAmt != 0 ? overrideAmt : forcePowerNeeded[`self`.client!.ps.fd.forcePowerLevel[forcePower]][forcePower]

    if (`self`.client!.ps.fd.forcePowersActive & (1 << forcePower)) != 0 {
        //we're probably going to deactivate it..
        return true
    }
    if forcePower == FP_LEVITATION {
        return true
    }
    if drain == 0 {
        return true
    }
    if (forcePower == FP_DRAIN || forcePower == FP_LIGHTNING) && `self`.client!.ps.fd.forcePower >= 25 {
        //it's ok then, drain/lightning are actually duration
        return true
    }
    if `self`.client!.ps.fd.forcePower < drain {
        return false
    }
    return true
}

/// Source: oracle/codemp/game/w_force.c:803
func WP_ForcePowerInUse(_ `self`: Entity, _ forcePower: JKAMP.forcePowers_t) -> Bool {
    if (`self`.client!.ps.fd.forcePowersActive & (1 << forcePower)) != 0 {
        //already using this power
        return true
    }

    return false
}

/// Source: oracle/codemp/game/w_force.c:813
func WP_ForcePowerUsable(_ `self`: Entity, _ forcePower: JKAMP.forcePowers_t) -> Bool {
    if BG_HasYsalamiri(g_gametype.integer, `self`.client!.ps) {
        return false
    }

    if `self`.health <= 0 || `self`.client!.ps.stats[STAT_HEALTH] <= 0 || (`self`.client!.ps.eFlags & EF_DEAD) != 0 {
        return false
    }

    if (`self`.client!.ps.pm_flags & PMF_FOLLOW) != 0 {
        //specs can't use powers through people
        return false
    }
    if `self`.client!.sess.sessionTeam == TEAM_SPECTATOR {
        return false
    }
    if `self`.client!.tempSpectate >= level.time {
        return false
    }

    if !BG_CanUseFPNow(g_gametype.integer, `self`.client!.ps, level.time, forcePower) {
        return false
    }

    if !((`self`.client!.ps.fd.forcePowersKnown & (1 << forcePower)) != 0) {
        //don't know this power
        return false
    }

    if (`self`.client!.ps.fd.forcePowersActive & (1 << forcePower)) != 0 {
        //already using this power
        if forcePower != FP_LEVITATION {
            return false
        }
    }

    if forcePower == FP_LEVITATION && `self`.client!.fjDidJump {
        return false
    }

    if `self`.client!.ps.fd.forcePowerLevel[forcePower] == 0 {
        return false
    }

    if g_debugMelee.integer != 0 {
        if (`self`.client!.ps.pm_flags & PMF_STUCK_TO_WALL) != 0 {
            //no offensive force powers when stuck to wall
            switch forcePower {
            case FP_GRIP, FP_LIGHTNING, FP_DRAIN, FP_SABER_OFFENSE, FP_SABER_DEFENSE, FP_SABERTHROW:
                return false

            default:
                break
            }
        }
    }

    if `self`.client!.ps.saberHolstered == 0 {
        if (`self`.client!.saber[0].saberFlags & SFL_TWO_HANDED) != 0 {
            if g_saberRestrictForce.integer != 0 {
                switch forcePower {
                case FP_PUSH, FP_PULL, FP_TELEPATHY, FP_GRIP, FP_LIGHTNING, FP_DRAIN:
                    return false

                default:
                    break
                }
            }
        }

        // Raven tests `self->client->saber[0].model` and `self->client->saber[0].model[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if (`self`.client!.saber[0].saberFlags & SFL_TWO_HANDED) != 0 || (!`self`.client!.saber[0].model.isEmpty) {
            //this saber requires the use of two hands OR our other hand is using an active saber too
            if (`self`.client!.saber[0].forceRestrictions & (1 << forcePower)) != 0 {
                //this power is verboten when using this saber
                return false
            }
        }

        // Raven tests `self->client->saber[0].model` and `self->client->saber[0].model[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if !`self`.client!.saber[0].model.isEmpty {
            //both sabers on
            if g_saberRestrictForce.integer != 0 {
                switch forcePower {
                case FP_PUSH, FP_PULL, FP_TELEPATHY, FP_GRIP, FP_LIGHTNING, FP_DRAIN:
                    return false

                default:
                    break
                }
            }
            if (`self`.client!.saber[1].forceRestrictions & (1 << forcePower)) != 0 {
                //this power is verboten when using this saber
                return false
            }
        }
    }
    return WP_ForcePowerAvailable(`self`, forcePower, 0) // OVERRIDEFIXME
}

/// Source: oracle/codemp/game/w_force.c:940
func WP_AbsorbConversion(_ attacked: Entity, _ atdAbsLevel: Int32, _ attacker: Entity, _ atPower: Int32, _ atPowerLevel: Int32, _ atForceSpent: Int32) -> Int32 {
    var getLevel: Int32 = 0
    var addTot: Int32 = 0
    var abSound: Entity?

    if atPower != FP_LIGHTNING && atPower != FP_DRAIN && atPower != FP_GRIP && atPower != FP_PUSH && atPower != FP_PULL {
        //Only these powers can be absorbed
        return -1
    }

    if atdAbsLevel == 0 {
        //looks like attacker doesn't have any absorb power
        return -1
    }

    if !((attacked.client!.ps.fd.forcePowersActive & (1 << FP_ABSORB)) != 0) {
        //absorb is not active
        return -1
    }

    //Subtract absorb power level from the offensive force power
    getLevel = atPowerLevel
    getLevel -= atdAbsLevel

    if getLevel < 0 {
        getLevel = 0
    }

    //let the attacker absorb an amount of force used in this attack based on his level of absorb
    addTot = (atForceSpent / 3) * attacked.client!.ps.fd.forcePowerLevel[FP_ABSORB]

    if addTot < 1 && atForceSpent >= 1 {
        addTot = 1
    }
    attacked.client!.ps.fd.forcePower += addTot
    if attacked.client!.ps.fd.forcePower > 100 {
        attacked.client!.ps.fd.forcePower = 100
    }

    //play sound indicating that attack was absorbed
    if attacked.client!.forcePowerSoundDebounce < level.time {
        abSound = G_PreDefSound(attacked.client!.ps.origin, PDSOUND_ABSORBHIT)
        abSound!.s.trickedentindex = attacked.s.number

        attacked.client!.forcePowerSoundDebounce = level.time + 400
    }

    return getLevel
}

/// Source: oracle/codemp/game/w_force.c:999
func WP_ForcePowerRegenerate(_ `self`: Entity, _ overrideAmt: Int32) {
    //called on a regular interval to regenerate force power.
    if `self`.client == nil {
        return
    }

    if overrideAmt != 0 {
        //custom regen amount
        `self`.client!.ps.fd.forcePower += overrideAmt
    } else {
        //otherwise, just 1
        `self`.client!.ps.fd.forcePower += 1
    }

    if `self`.client!.ps.fd.forcePower > `self`.client!.ps.fd.forcePowerMax {
        //cap it off at the max (default 100)
        `self`.client!.ps.fd.forcePower = `self`.client!.ps.fd.forcePowerMax
    }
}

/// Source: oracle/codemp/game/w_force.c:1021
func WP_ForcePowerStart(_ `self`: Entity, _ forcePower: JKAMP.forcePowers_t, _ overrideAmt: Int32) {
    //activate the given force power
    var duration: Int32 = 0
    var hearable: Bool = false
    var hearDist: Float = 0
    // Raven assigns his own `overrideAmt` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var overrideAmt = overrideAmt

    if !WP_ForcePowerAvailable(`self`, forcePower, overrideAmt) {
        return
    }

    if BG_FullBodyTauntAnim(`self`.client!.ps.legsAnim) {
        //stop taunt
        `self`.client!.ps.legsTimer = 0
    }
    if BG_FullBodyTauntAnim(`self`.client!.ps.torsoAnim) {
        //stop taunt
        `self`.client!.ps.torsoTimer = 0
    }
    //hearable and hearDist are merely for the benefit of bots, and not related to if a sound is actually played.
    //If duration is set, the force power will assume to be timer-based.
    switch Int32(forcePower) {
    case FP_HEAL:
        hearable = true
        hearDist = 256
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_LEVITATION:
        hearable = true
        hearDist = 256
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_SPEED:
        hearable = true
        hearDist = 256
        if `self`.client!.ps.fd.forcePowerLevel[FP_SPEED] == FORCE_LEVEL_1 {
            duration = 10000
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_SPEED] == FORCE_LEVEL_2 {
            duration = 15000
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_SPEED] == FORCE_LEVEL_3 {
            duration = 20000
        } else {
            break
        }

        if overrideAmt != 0 {
            duration = overrideAmt
        }

        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_PUSH:
        hearable = true
        hearDist = 256

    case FP_PULL:
        hearable = true
        hearDist = 256

    case FP_TELEPATHY:
        hearable = true
        hearDist = 256
        if `self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY] == FORCE_LEVEL_1 {
            duration = 20000
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY] == FORCE_LEVEL_2 {
            duration = 25000
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY] == FORCE_LEVEL_3 {
            duration = 30000
        } else {
            break
        }

        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_GRIP:
        hearable = true
        hearDist = 256
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)
        `self`.client!.ps.powerups[PW_DISINT_4] = level.time + 60000

    case FP_LIGHTNING:
        hearable = true
        hearDist = 512
        duration = overrideAmt
        overrideAmt = 0
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)
        `self`.client!.ps.activeForcePass = `self`.client!.ps.fd.forcePowerLevel[FP_LIGHTNING]

    case FP_RAGE:
        hearable = true
        hearDist = 256
        if `self`.client!.ps.fd.forcePowerLevel[FP_RAGE] == FORCE_LEVEL_1 {
            duration = 8000
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_RAGE] == FORCE_LEVEL_2 {
            duration = 14000
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_RAGE] == FORCE_LEVEL_3 {
            duration = 20000
        } else {
            break
        }

        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_PROTECT:
        hearable = true
        hearDist = 256
        duration = 20000
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_ABSORB:
        hearable = true
        hearDist = 256
        duration = 20000
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_TEAM_HEAL:
        hearable = true
        hearDist = 256
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_TEAM_FORCE:
        hearable = true
        hearDist = 256
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_DRAIN:
        hearable = true
        hearDist = 256
        duration = overrideAmt
        overrideAmt = 0
        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_SEE:
        hearable = true
        hearDist = 256
        if `self`.client!.ps.fd.forcePowerLevel[FP_SEE] == FORCE_LEVEL_1 {
            duration = 10000
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_SEE] == FORCE_LEVEL_2 {
            duration = 20000
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_SEE] == FORCE_LEVEL_3 {
            duration = 30000
        } else {
            break
        }

        `self`.client!.ps.fd.forcePowersActive |= (1 << forcePower)

    case FP_SABER_OFFENSE:
        break

    case FP_SABER_DEFENSE:
        break

    case FP_SABERTHROW:
        break

    default:
        break
    }

    if duration != 0 {
        `self`.client!.ps.fd.forcePowerDuration[forcePower] = level.time + duration
    } else {
        `self`.client!.ps.fd.forcePowerDuration[forcePower] = 0
    }

    if hearable {
        `self`.client!.ps.otherSoundLen = hearDist
        `self`.client!.ps.otherSoundTime = level.time + 100
    }

    `self`.client!.ps.fd.forcePowerDebounce[forcePower] = 0

    if Int32(forcePower) == FP_SPEED && overrideAmt != 0 {
        BG_ForcePowerDrain(`self`.client!.ps, forcePower, Int32(Double(overrideAmt) * 0.025))
    } else if Int32(forcePower) != FP_GRIP && Int32(forcePower) != FP_DRAIN {
        //grip and drain drain as damage is done
        BG_ForcePowerDrain(`self`.client!.ps, forcePower, overrideAmt)
    }
}

/// Source: oracle/codemp/game/w_force.c:1236
func ForceHeal(_ `self`: Entity) {
    if `self`.health <= 0 {
        return
    }

    if !WP_ForcePowerUsable(`self`, FP_HEAL) {
        return
    }

    if `self`.health >= `self`.client!.ps.stats[STAT_MAX_HEALTH] {
        return
    }

    if `self`.client!.ps.fd.forcePowerLevel[FP_HEAL] == FORCE_LEVEL_3 {
        `self`.health += 25 //This was 50, but that angered the Balance God.

        if `self`.health > `self`.client!.ps.stats[STAT_MAX_HEALTH] {
            `self`.health = `self`.client!.ps.stats[STAT_MAX_HEALTH]
        }
        BG_ForcePowerDrain(`self`.client!.ps, FP_HEAL, 0)
    } else if `self`.client!.ps.fd.forcePowerLevel[FP_HEAL] == FORCE_LEVEL_2 {
        `self`.health += 10

        if `self`.health > `self`.client!.ps.stats[STAT_MAX_HEALTH] {
            `self`.health = `self`.client!.ps.stats[STAT_MAX_HEALTH]
        }
        BG_ForcePowerDrain(`self`.client!.ps, FP_HEAL, 0)
    } else {
        `self`.health += 5

        if `self`.health > `self`.client!.ps.stats[STAT_MAX_HEALTH] {
            `self`.health = `self`.client!.ps.stats[STAT_MAX_HEALTH]
        }
        BG_ForcePowerDrain(`self`.client!.ps, FP_HEAL, 0)
    }
    /*
    else
    {
    WP_ForcePowerStart( self, FP_HEAL, 0 );
    }
    */
    //NOTE: Decided to make all levels instant.

    G_Sound(`self`, CHAN_ITEM, G_SoundIndex("sound/weapons/force/heal.wav"))
}

/// Source: oracle/codemp/game/w_force.c:1294
func WP_AddToClientBitflags(_ ent: Entity, _ entNum: Int32) {
    if entNum > 47 {
        ent.s.trickedentindex4 |= (1 << (entNum - 48))
    } else if entNum > 31 {
        ent.s.trickedentindex3 |= (1 << (entNum - 32))
    } else if entNum > 15 {
        ent.s.trickedentindex2 |= (1 << (entNum - 16))
    } else {
        ent.s.trickedentindex |= (1 << entNum)
    }
}

/// Source: oracle/codemp/game/w_force.c:1319
func ForceTeamHeal(_ `self`: Entity) {
    var radius: Float = 256
    var i: Int32 = 0
    var ent: Entity?
    var a = vec3_t()
    var numpl: Int32 = 0
    var pl: [Int32] = [Int32](repeating: 0, count: 32)
    var healthadd: Int32 = 0
    var te: Entity? = nil

    if `self`.health <= 0 {
        return
    }

    if !WP_ForcePowerUsable(`self`, FP_TEAM_HEAL) {
        return
    }

    if `self`.client!.ps.fd.forcePowerDebounce[FP_TEAM_HEAL] >= level.time {
        return
    }

    if `self`.client!.ps.fd.forcePowerLevel[FP_TEAM_HEAL] == FORCE_LEVEL_2 {
        radius = Float(Double(radius) * 1.5)
    }
    if `self`.client!.ps.fd.forcePowerLevel[FP_TEAM_HEAL] == FORCE_LEVEL_3 {
        radius *= 2
    }

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && `self` != ent && OnSameTeam(`self`, ent!) && ent!.client!.ps.stats[STAT_HEALTH] < ent!.client!.ps.stats[STAT_MAX_HEALTH] && ent!.client!.ps.stats[STAT_HEALTH] > 0 && ForcePowerUsableOn(`self`, ent!, FP_TEAM_HEAL) != 0 && trap_InPVS(`self`.client!.ps.origin, ent!.client!.ps.origin) {
            a = `self`.client!.ps.origin - ent!.client!.ps.origin

            if VectorLength(a) <= radius {
                pl[numpl] = i
                numpl += 1
            }
        }

        i += 1
    }

    if numpl < 1 {
        return
    }

    if numpl == 1 {
        healthadd = 50
    } else if numpl == 2 {
        healthadd = 33
    } else {
        healthadd = 25
    }

    `self`.client!.ps.fd.forcePowerDebounce[FP_TEAM_HEAL] = level.time + 2000
    i = 0

    while i < numpl {
        if g_entities[pl[i]].client!.ps.stats[STAT_HEALTH] > 0 && g_entities[pl[i]].health > 0 {
            g_entities[pl[i]].client!.ps.stats[STAT_HEALTH] += healthadd
            if g_entities[pl[i]].client!.ps.stats[STAT_HEALTH] > g_entities[pl[i]].client!.ps.stats[STAT_MAX_HEALTH] {
                g_entities[pl[i]].client!.ps.stats[STAT_HEALTH] = g_entities[pl[i]].client!.ps.stats[STAT_MAX_HEALTH]
            }

            g_entities[pl[i]].health = g_entities[pl[i]].client!.ps.stats[STAT_HEALTH]

            //At this point we know we got one, so add him into the collective event client bitflag
            if te == nil {
                te = G_TempEntity(`self`.client!.ps.origin, EV_TEAM_POWER)
                te!.s.eventParm = 1 //eventParm 1 is heal, eventParm 2 is force regen

                //since we had an extra check above, do the drain now because we got at least one guy
                BG_ForcePowerDrain(`self`.client!.ps, FP_TEAM_HEAL, forcePowerNeeded[`self`.client!.ps.fd.forcePowerLevel[FP_TEAM_HEAL]][FP_TEAM_HEAL])
            }

            WP_AddToClientBitflags(te!, pl[i])
            //Now cramming it all into one event.. doing this many g_sound events at once was a Bad Thing.
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/w_force.c:1424
func ForceTeamForceReplenish(_ `self`: Entity) {
    var radius: Float = 256
    var i: Int32 = 0
    var ent: Entity?
    var a = vec3_t()
    var numpl: Int32 = 0
    var pl: [Int32] = [Int32](repeating: 0, count: 32)
    var poweradd: Int32 = 0
    var te: Entity? = nil

    if `self`.health <= 0 {
        return
    }

    if !WP_ForcePowerUsable(`self`, FP_TEAM_FORCE) {
        return
    }

    if `self`.client!.ps.fd.forcePowerDebounce[FP_TEAM_FORCE] >= level.time {
        return
    }

    if `self`.client!.ps.fd.forcePowerLevel[FP_TEAM_FORCE] == FORCE_LEVEL_2 {
        radius = Float(Double(radius) * 1.5)
    }
    if `self`.client!.ps.fd.forcePowerLevel[FP_TEAM_FORCE] == FORCE_LEVEL_3 {
        radius *= 2
    }

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && `self` != ent && OnSameTeam(`self`, ent!) && ent!.client!.ps.fd.forcePower < 100 && ForcePowerUsableOn(`self`, ent!, FP_TEAM_FORCE) != 0 && trap_InPVS(`self`.client!.ps.origin, ent!.client!.ps.origin) {
            a = `self`.client!.ps.origin - ent!.client!.ps.origin

            if VectorLength(a) <= radius {
                pl[numpl] = i
                numpl += 1
            }
        }

        i += 1
    }

    if numpl < 1 {
        return
    }

    if numpl == 1 {
        poweradd = 50
    } else if numpl == 2 {
        poweradd = 33
    } else {
        poweradd = 25
    }
    `self`.client!.ps.fd.forcePowerDebounce[FP_TEAM_FORCE] = level.time + 2000

    BG_ForcePowerDrain(`self`.client!.ps, FP_TEAM_FORCE, forcePowerNeeded[`self`.client!.ps.fd.forcePowerLevel[FP_TEAM_FORCE]][FP_TEAM_FORCE])

    i = 0

    while i < numpl {
        g_entities[pl[i]].client!.ps.fd.forcePower += poweradd
        if g_entities[pl[i]].client!.ps.fd.forcePower > 100 {
            g_entities[pl[i]].client!.ps.fd.forcePower = 100
        }

        //At this point we know we got one, so add him into the collective event client bitflag
        if te == nil {
            te = G_TempEntity(`self`.client!.ps.origin, EV_TEAM_POWER)
            te!.s.eventParm = 2 //eventParm 1 is heal, eventParm 2 is force regen
        }

        WP_AddToClientBitflags(te!, pl[i])
        //Now cramming it all into one event.. doing this many g_sound events at once was a Bad Thing.

        i += 1
    }
}

/// Source: oracle/codemp/game/w_force.c:1523
func ForceGrip(_ `self`: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var tfrom = vec3_t()
        var tto = vec3_t()
        var fwd = vec3_t()

        if `self`.health <= 0 {
            return true
        }

        if `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE {
            return true
        }

        if `self`.client!.ps.weaponTime > 0 {
            return true
        }

        if `self`.client!.ps.fd.forceGripUseTime > level.time {
            return true
        }

        if !WP_ForcePowerUsable(`self`, FP_GRIP) {
            return true
        }

        tfrom = `self`.client!.ps.origin
        tfrom[2] += `self`.client!.ps.viewheight
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceGrip", source: "oracle/codemp/game/w_force.c:1523")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceGrip", source: "oracle/codemp/game/w_force.c:1523")
        var scratchUp = vec3_t()
        AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)
        tto[0] = tfrom[0] + fwd[0] * MAX_GRIP_DISTANCE
        tto[1] = tfrom[1] + fwd[1] * MAX_GRIP_DISTANCE
        tto[2] = tfrom[2] + fwd[2] * MAX_GRIP_DISTANCE

        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("ForceGrip", source: "oracle/codemp/game/w_force.c:1523")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("ForceGrip", source: "oracle/codemp/game/w_force.c:1523")
        trap_Trace(tr, tfrom, vec3_origin, vec3_origin, tto, `self`.s.number, MASK_PLAYERSOLID)

        if Double(tr.fraction) != 1.0 && tr.entityNum != ENTITYNUM_NONE && g_entities[tr.entityNum].client != nil && g_entities[tr.entityNum].client!.ps.fd.forceGripCripple == 0 && g_entities[tr.entityNum].client!.ps.fd.forceGripBeingGripped < level.time && ForcePowerUsableOn(`self`, g_entities[tr.entityNum], FP_GRIP) != 0 && (g_friendlyFire.integer != 0 || !OnSameTeam(`self`, g_entities[tr.entityNum])) {
            if g_entities[tr.entityNum].s.number < MAX_CLIENTS && g_entities[tr.entityNum].client!.ps.m_iVehicleNum != 0 {
                //a player on a vehicle
                let vehEnt: Entity? = g_entities[g_entities[tr.entityNum].client!.ps.m_iVehicleNum]
                if vehEnt!.inuse && vehEnt!.client != nil && vehEnt!.m_pVehicle != nil {
                    if vehEnt!.m_pVehicle!.m_pVehicleInfo!.type == VH_SPEEDER || vehEnt!.m_pVehicle!.m_pVehicleInfo!.type == VH_ANIMAL {
                        //push the guy off
                        vehEnt!.m_pVehicle!.m_pVehicleInfo!.runEject(vehEnt!.m_pVehicle, BgEntity(g_entities[tr.entityNum]), false)
                    }
                }
            }
            `self`.client!.ps.fd.forceGripEntityNum = tr.entityNum
            g_entities[tr.entityNum].client!.ps.fd.forceGripStarted = Float(level.time)
            `self`.client!.ps.fd.forceGripDamageDebounceTime = 0

            `self`.client!.ps.forceHandExtend = HANDEXTEND_FORCE_HOLD
            `self`.client!.ps.forceHandExtendTime = level.time + 5000
        } else {
            `self`.client!.ps.fd.forceGripEntityNum = ENTITYNUM_NONE
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_force.c:1596
func ForceSpeed(_ `self`: Entity, _ forceDuration: Int32) {
    if `self`.health <= 0 {
        return
    }

    if `self`.client!.ps.forceAllowDeactivateTime < level.time && (`self`.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
        WP_ForcePowerStop(`self`, FP_SPEED)
        return
    }

    if !WP_ForcePowerUsable(`self`, FP_SPEED) {
        return
    }

    if `self`.client!.holdingObjectiveItem >= MAX_CLIENTS && `self`.client!.holdingObjectiveItem < ENTITYNUM_WORLD {
        //holding Siege item
        if g_entities[`self`.client!.holdingObjectiveItem].genericValue15 != 0 {
            //disables force powers
            return
        }
    }

    `self`.client!.ps.forceAllowDeactivateTime = level.time + 1500

    WP_ForcePowerStart(`self`, FP_SPEED, forceDuration)
    G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/force/speed.wav"))
    G_Sound(`self`, TRACK_CHANNEL_2, speedLoopSound)
}

/// Source: oracle/codemp/game/w_force.c:1631
func ForceSeeing(_ `self`: Entity) {
    if `self`.health <= 0 {
        return
    }

    if `self`.client!.ps.forceAllowDeactivateTime < level.time && (`self`.client!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0 {
        WP_ForcePowerStop(`self`, FP_SEE)
        return
    }

    if !WP_ForcePowerUsable(`self`, FP_SEE) {
        return
    }

    `self`.client!.ps.forceAllowDeactivateTime = level.time + 1500

    WP_ForcePowerStart(`self`, FP_SEE, 0)

    G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/weapons/force/see.wav"))
    G_Sound(`self`, TRACK_CHANNEL_5, seeLoopSound)
}

/// Source: oracle/codemp/game/w_force.c:1658
func ForceProtect(_ `self`: Entity) {
    if `self`.health <= 0 {
        return
    }

    if `self`.client!.ps.forceAllowDeactivateTime < level.time && (`self`.client!.ps.fd.forcePowersActive & (1 << FP_PROTECT)) != 0 {
        WP_ForcePowerStop(`self`, FP_PROTECT)
        return
    }

    if !WP_ForcePowerUsable(`self`, FP_PROTECT) {
        return
    }

    // Make sure to turn off Force Rage and Force Absorb.
    if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
        WP_ForcePowerStop(`self`, FP_RAGE)
    }
    if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_ABSORB)) != 0 {
        WP_ForcePowerStop(`self`, FP_ABSORB)
    }

    `self`.client!.ps.forceAllowDeactivateTime = level.time + 1500

    WP_ForcePowerStart(`self`, FP_PROTECT, 0)
    G_PreDefSound(`self`.client!.ps.origin, PDSOUND_PROTECT)
    G_Sound(`self`, TRACK_CHANNEL_3, protectLoopSound)
}

/// Source: oracle/codemp/game/w_force.c:1694
func ForceAbsorb(_ `self`: Entity) {
    if `self`.health <= 0 {
        return
    }

    if `self`.client!.ps.forceAllowDeactivateTime < level.time && (`self`.client!.ps.fd.forcePowersActive & (1 << FP_ABSORB)) != 0 {
        WP_ForcePowerStop(`self`, FP_ABSORB)
        return
    }

    if !WP_ForcePowerUsable(`self`, FP_ABSORB) {
        return
    }

    // Make sure to turn off Force Rage and Force Protection.
    if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
        WP_ForcePowerStop(`self`, FP_RAGE)
    }
    if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_PROTECT)) != 0 {
        WP_ForcePowerStop(`self`, FP_PROTECT)
    }

    `self`.client!.ps.forceAllowDeactivateTime = level.time + 1500

    WP_ForcePowerStart(`self`, FP_ABSORB, 0)
    G_PreDefSound(`self`.client!.ps.origin, PDSOUND_ABSORB)
    G_Sound(`self`, TRACK_CHANNEL_3, absorbLoopSound)
}

/// Source: oracle/codemp/game/w_force.c:1730
func ForceRage(_ `self`: Entity) {
    if `self`.health <= 0 {
        return
    }

    if `self`.client!.ps.forceAllowDeactivateTime < level.time && (`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
        WP_ForcePowerStop(`self`, FP_RAGE)
        return
    }

    if !WP_ForcePowerUsable(`self`, FP_RAGE) {
        return
    }

    if `self`.client!.ps.fd.forceRageRecoveryTime >= level.time {
        return
    }

    if `self`.health < 10 {
        return
    }

    // Make sure to turn off Force Protection and Force Absorb.
    if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_PROTECT)) != 0 {
        WP_ForcePowerStop(`self`, FP_PROTECT)
    }
    if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_ABSORB)) != 0 {
        WP_ForcePowerStop(`self`, FP_ABSORB)
    }

    `self`.client!.ps.forceAllowDeactivateTime = level.time + 1500

    WP_ForcePowerStart(`self`, FP_RAGE, 0)

    G_Sound(`self`, TRACK_CHANNEL_4, G_SoundIndex("sound/weapons/force/rage.wav"))
    G_Sound(`self`, TRACK_CHANNEL_3, rageLoopSound)
}

/// Source: oracle/codemp/game/w_force.c:1777
func ForceLightning(_ `self`: Entity) {
    if `self`.health <= 0 {
        return
    }
    if `self`.client!.ps.fd.forcePower < 25 || !WP_ForcePowerUsable(`self`, FP_LIGHTNING) {
        return
    }
    if `self`.client!.ps.fd.forcePowerDebounce[FP_LIGHTNING] > level.time {
        //stops it while using it and also after using it, up to 3 second delay
        return
    }

    if `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        return
    }

    if `self`.client!.ps.weaponTime > 0 {
        return
    }

    //Shoot lightning from hand
    //using grip anim now, to extend the burst time
    `self`.client!.ps.forceHandExtend = HANDEXTEND_FORCE_HOLD
    `self`.client!.ps.forceHandExtendTime = level.time + 20000

    G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/force/lightning"))

    WP_ForcePowerStart(`self`, FP_LIGHTNING, 500)
}

/// Source: oracle/codemp/game/w_force.c:1812
func ForceLightningDamage(_ `self`: Entity, _ traceEnt: Entity, _ dir: inout JKAShared.vec3_t, _ impactPoint: JKAShared.vec3_t) {
    `self`.client!.dangerTime = level.time
    `self`.client!.ps.eFlags &= ~EF_INVULNERABLE
    `self`.client!.invulnerableTimer = 0

    if traceEnt.takedamage {
        if traceEnt.client == nil && traceEnt.s.eType == ET_NPC {
            //g2animent
            if traceEnt.s.genericenemyindex < level.time {
                traceEnt.s.genericenemyindex = level.time + 2000
            }
        }
        if traceEnt.client != nil {
            //an enemy or object
            if traceEnt.client!.noLightningTime >= level.time {
                //give them power and don't hurt them.
                traceEnt.client!.ps.fd.forcePower += 1
                if traceEnt.client!.ps.fd.forcePower > 100 {
                    traceEnt.client!.ps.fd.forcePower = 100
                }
                return
            }
            if ForcePowerUsableOn(`self`, traceEnt, FP_LIGHTNING) != 0 {
                var dmg: Int32 = Q_irand(1, 2)

                var modPowerLevel: Int32 = -1

                if traceEnt.client != nil {
                    modPowerLevel = WP_AbsorbConversion(traceEnt, traceEnt.client!.ps.fd.forcePowerLevel[FP_ABSORB], `self`, FP_LIGHTNING, `self`.client!.ps.fd.forcePowerLevel[FP_LIGHTNING], 1)
                }

                if modPowerLevel != -1 {
                    if modPowerLevel == 0 {
                        dmg = 0
                        traceEnt.client!.noLightningTime = level.time + 400
                    } else if modPowerLevel == 1 {
                        dmg = 1
                        traceEnt.client!.noLightningTime = level.time + 300
                    } else if modPowerLevel == 2 {
                        dmg = 1
                        traceEnt.client!.noLightningTime = level.time + 100
                    }
                }

                if `self`.client!.ps.weapon == WP_MELEE && `self`.client!.ps.fd.forcePowerLevel[FP_LIGHTNING] > FORCE_LEVEL_2 {
                    //2-handed lightning
                    //jackin' 'em up, Palpatine-style
                    dmg *= 2
                }

                if dmg != 0 {
                    //rww - Shields can now absorb lightning too.
                    G_Damage(traceEnt, `self`, `self`, &dir, impactPoint, dmg, 0, MOD_FORCE_DARK)
                }
                if traceEnt.client != nil {
                    if Q_irand(0, 2) == 0 {
                        G_Sound(traceEnt, CHAN_BODY, G_SoundIndex(va("sound/weapons/force/lightninghit%i", Q_irand(1, 3))))
                    }

                    if traceEnt.client!.ps.electrifyTime < (level.time + 400) {
                        //only update every 400ms to reduce bandwidth usage (as it is passing a 32-bit time value)
                        traceEnt.client!.ps.electrifyTime = level.time + 800
                    }
                    if traceEnt.client!.ps.powerups[PW_CLOAKED] != 0 {
                        //disable cloak temporarily
                        Jedi_Decloak(traceEnt)
                        traceEnt.client!.cloakToggleTime = level.time + Q_irand(3000, 10000)
                    }
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/w_force.c:1902
func ForceShootLightning(_ `self`: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var end = vec3_t()
        var forward = vec3_t()
        var traceEnt: Entity?

        if `self`.health <= 0 {
            return true
        }
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceShootLightning", source: "oracle/codemp/game/w_force.c:1902")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceShootLightning", source: "oracle/codemp/game/w_force.c:1902")
        var scratchUp = vec3_t()
        AngleVectors(`self`.client!.ps.viewangles, &forward, &scratchRight, &scratchUp)
        VectorNormalize(&forward)

        if `self`.client!.ps.fd.forcePowerLevel[FP_LIGHTNING] > FORCE_LEVEL_2 {
            //arc
            var center = vec3_t()
            var mins = vec3_t()
            var maxs = vec3_t()
            var dir = vec3_t()
            var ent_org = vec3_t()
            var size = vec3_t()
            var v = vec3_t()
            let radius: Float = Float(FORCE_LIGHTNING_RADIUS)
            var dot: Float = 0
            var dist: Float = 0
            // Port-note: A local `gentity_t *[1024] entityList` the table has no type for.
            // Raven wrote: gentity_t *entityList[MAX_GENTITIES];
            portMissing("ForceShootLightning", source: "oracle/codemp/game/w_force.c:1902")
            var iEntityList: [Int32] = [Int32](repeating: 0, count: 1024)
            var e: Int32 = 0
            var numListedEntities: Int32 = 0
            var i: Int32 = 0

            center = `self`.client!.ps.origin
            i = 0
            while i < 3 {
                mins[i] = center[i] - radius
                maxs[i] = center[i] + radius
                i += 1
            }
            numListedEntities = trap_EntitiesInBox(mins, maxs, &iEntityList, MAX_GENTITIES)

            i = 0
            while i < numListedEntities {
                // Port-note: A read of `entityList`, a local the draft left as a hole.
                // Raven wrote: entityList[i] = &g_entities[iEntityList[i]]
                portMissing("ForceShootLightning", source: "oracle/codemp/game/w_force.c:1902")

                i += 1
            }

            e = 0
            while e < numListedEntities {
                // Port-note: A read of `entityList`, a local the draft left as a hole.
                // Raven wrote: traceEnt = entityList[e]
                portMissing("ForceShootLightning", source: "oracle/codemp/game/w_force.c:1902")

                if traceEnt == nil {
                    e += 1
                    continue
                }
                if traceEnt == `self` {
                    e += 1
                    continue
                }
                if traceEnt!.r.ownerNum == `self`.s.number && traceEnt!.s.weapon != WP_THERMAL {
                    e += 1
                    continue
                }
                if !traceEnt!.inuse {
                    e += 1
                    continue
                }
                if !traceEnt!.takedamage {
                    e += 1
                    continue
                }
                if traceEnt!.health <= 0 {
                    e += 1
                    continue
                }
                if g_friendlyFire.integer == 0 && OnSameTeam(`self`, traceEnt!) {
                    e += 1
                    continue
                }
                //this is all to see if we need to start a saber attack, if it's in flight, this doesn't matter
                // find the distance from the edge of the bounding box
                i = 0
                while i < 3 {
                    if center[i] < traceEnt!.r.absmin[i] {
                        v[i] = traceEnt!.r.absmin[i] - center[i]
                    } else if center[i] > traceEnt!.r.absmax[i] {
                        v[i] = center[i] - traceEnt!.r.absmax[i]
                    } else {
                        v[i] = 0
                    }
                    i += 1
                }

                size = traceEnt!.r.absmax - traceEnt!.r.absmin
                _VectorMA(traceEnt!.r.absmin, 0.5, size, &ent_org)

                //see if they're in front of me
                //must be within the forward cone
                dir = ent_org - center
                VectorNormalize(&dir)
                // Port-note: An assignment inside an expression.
                // Raven wrote: if ( (dot = DotProduct( dir, forward )) < 0.5 ) continue
                portMissing("ForceShootLightning", source: "oracle/codemp/game/w_force.c:1902")

                //must be close enough
                dist = VectorLength(v)
                if dist >= radius {
                    e += 1
                    continue
                }

                //in PVS?
                if !traceEnt!.r.bmodel && !trap_InPVS(ent_org, `self`.client!.ps.origin) {
                    //must be in PVS
                    e += 1
                    continue
                }

                //Now check and see if we can actually hit it
                trap_Trace(tr, `self`.client!.ps.origin, vec3_origin, vec3_origin, ent_org, `self`.s.number, MASK_SHOT)
                if tr.fraction < 1.0 && tr.entityNum != traceEnt!.s.number {
                    //must have clear LOS
                    e += 1
                    continue
                }

                // ok, we are within the radius, add us to the incoming list
                ForceLightningDamage(`self`, traceEnt!, &dir, ent_org)
                e += 1
            }
        } else {
            //trace-line
            _VectorMA(`self`.client!.ps.origin, 2048, forward, &end)

            trap_Trace(tr, `self`.client!.ps.origin, vec3_origin, vec3_origin, end, `self`.s.number, MASK_SHOT)
            if tr.entityNum == ENTITYNUM_NONE || Double(tr.fraction) == 1.0 || tr.allsolid != 0 || tr.startsolid != 0 {
                return true
            }

            traceEnt = g_entities[tr.entityNum]
            ForceLightningDamage(`self`, traceEnt!, &forward, tr.endpos)
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_force.c:2022
func ForceDrain(_ `self`: Entity) {
    if `self`.health <= 0 {
        return
    }

    if `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        return
    }

    if `self`.client!.ps.weaponTime > 0 {
        return
    }

    if `self`.client!.ps.fd.forcePower < 25 || !WP_ForcePowerUsable(`self`, FP_DRAIN) {
        return
    }
    if `self`.client!.ps.fd.forcePowerDebounce[FP_DRAIN] > level.time {
        //stops it while using it and also after using it, up to 3 second delay
        return
    }

    //	self->client->ps.forceHandExtend = HANDEXTEND_FORCEPUSH;
    //	self->client->ps.forceHandExtendTime = level.time + 1000;
    `self`.client!.ps.forceHandExtend = HANDEXTEND_FORCE_HOLD
    `self`.client!.ps.forceHandExtendTime = level.time + 20000

    G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/force/drain.wav"))

    WP_ForcePowerStart(`self`, FP_DRAIN, 500)
}

/// Source: oracle/codemp/game/w_force.c:2058
func ForceDrainDamage(_ `self`: Entity, _ traceEnt: Entity, _ dir: JKAShared.vec3_t, _ impactPoint: JKAShared.vec3_t) {
    var tent: Entity?

    `self`.client!.dangerTime = level.time
    `self`.client!.ps.eFlags &= ~EF_INVULNERABLE
    `self`.client!.invulnerableTimer = 0

    if traceEnt.takedamage {
        if traceEnt.client != nil && (!OnSameTeam(`self`, traceEnt) || g_friendlyFire.integer != 0) && `self`.client!.ps.fd.forceDrainTime < level.time && traceEnt.client!.ps.fd.forcePower != 0 {
            //an enemy or object
            if traceEnt.client == nil && traceEnt.s.eType == ET_NPC {
                //g2animent
                if traceEnt.s.genericenemyindex < level.time {
                    traceEnt.s.genericenemyindex = level.time + 2000
                }
            }
            if ForcePowerUsableOn(`self`, traceEnt, FP_DRAIN) != 0 {
                var modPowerLevel: Int32 = -1
                var dmg: Int32 = 0
                if `self`.client!.ps.fd.forcePowerLevel[FP_DRAIN] == FORCE_LEVEL_1 {
                    dmg = 2 //because it's one-shot
                } else if `self`.client!.ps.fd.forcePowerLevel[FP_DRAIN] == FORCE_LEVEL_2 {
                    dmg = 3
                } else if `self`.client!.ps.fd.forcePowerLevel[FP_DRAIN] == FORCE_LEVEL_3 {
                    dmg = 4
                }

                if traceEnt.client != nil {
                    modPowerLevel = WP_AbsorbConversion(traceEnt, traceEnt.client!.ps.fd.forcePowerLevel[FP_ABSORB], `self`, FP_DRAIN, `self`.client!.ps.fd.forcePowerLevel[FP_DRAIN], 1)
                }

                if modPowerLevel != -1 {
                    if modPowerLevel == 0 {
                        dmg = 0
                    } else if modPowerLevel == 1 {
                        dmg = 1
                    } else if modPowerLevel == 2 {
                        dmg = 2
                    }
                }
                //G_Damage( traceEnt, self, self, dir, impactPoint, dmg, 0, MOD_FORCE_DARK );

                if dmg != 0 {
                    traceEnt.client!.ps.fd.forcePower -= (dmg)
                }
                if traceEnt.client!.ps.fd.forcePower < 0 {
                    traceEnt.client!.ps.fd.forcePower = 0
                }

                if `self`.client!.ps.stats[STAT_HEALTH] < `self`.client!.ps.stats[STAT_MAX_HEALTH] && `self`.health > 0 && `self`.client!.ps.stats[STAT_HEALTH] > 0 {
                    `self`.health += dmg
                    if `self`.health > `self`.client!.ps.stats[STAT_MAX_HEALTH] {
                        `self`.health = `self`.client!.ps.stats[STAT_MAX_HEALTH]
                    }
                    `self`.client!.ps.stats[STAT_HEALTH] = `self`.health
                }

                traceEnt.client!.ps.fd.forcePowerRegenDebounceTime = level.time + 800 //don't let the client being drained get force power back right away

                //Drain the standard amount since we just drained someone else

                /*
                if (self->client->ps.fd.forcePowerLevel[FP_DRAIN] == FORCE_LEVEL_1)
                {
                BG_ForcePowerDrain( &self->client->ps, FP_DRAIN, 0 );
                }
                else
                {
                BG_ForcePowerDrain( &self->client->ps, FP_DRAIN, forcePowerNeeded[self->client->ps.fd.forcePowerLevel[FP_DRAIN]][FP_DRAIN]/5 );
                }

                if (self->client->ps.fd.forcePowerLevel[FP_DRAIN] == FORCE_LEVEL_1)
                {
                self->client->ps.fd.forceDrainTime = level.time + 100;
                }
                else
                {
                self->client->ps.fd.forceDrainTime = level.time + 20;
                }

                if ( traceEnt->client )
                {
                if ( !Q_irand( 0, 2 ) )
                {
                //G_Sound( traceEnt, CHAN_BODY, G_SoundIndex( "sound/weapons/force/lightninghit.wav" ) );
                }
                //	traceEnt->s.powerups |= ( 1 << PW_DISINT_1 );

                //	traceEnt->client->ps.powerups[PW_DISINT_1] = level.time + 500;
                }
                */

                if traceEnt.client!.forcePowerSoundDebounce < level.time {
                    tent = G_TempEntity(impactPoint, EV_FORCE_DRAINED)
                    tent!.s.eventParm = DirToByte(dir)
                    tent!.s.owner = traceEnt.s.number

                    traceEnt.client!.forcePowerSoundDebounce = level.time + 400
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/w_force.c:2184
func ForceShootDrain(_ `self`: Entity) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var end = vec3_t()
        var forward = vec3_t()
        var traceEnt: Entity?
        var gotOneOrMore: Int32 = 0

        if `self`.health <= 0 {
            return 0
        }
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceShootDrain", source: "oracle/codemp/game/w_force.c:2184")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceShootDrain", source: "oracle/codemp/game/w_force.c:2184")
        var scratchUp = vec3_t()
        AngleVectors(`self`.client!.ps.viewangles, &forward, &scratchRight, &scratchUp)
        VectorNormalize(&forward)

        if `self`.client!.ps.fd.forcePowerLevel[FP_DRAIN] > FORCE_LEVEL_2 {
            //arc
            var center = vec3_t()
            var mins = vec3_t()
            var maxs = vec3_t()
            var dir = vec3_t()
            var ent_org = vec3_t()
            var size = vec3_t()
            var v = vec3_t()
            let radius: Float = Float(MAX_DRAIN_DISTANCE)
            var dot: Float = 0
            var dist: Float = 0
            // Port-note: A local `gentity_t *[1024] entityList` the table has no type for.
            // Raven wrote: gentity_t *entityList[MAX_GENTITIES];
            portMissing("ForceShootDrain", source: "oracle/codemp/game/w_force.c:2184")
            var iEntityList: [Int32] = [Int32](repeating: 0, count: 1024)
            var e: Int32 = 0
            var numListedEntities: Int32 = 0
            var i: Int32 = 0

            center = `self`.client!.ps.origin
            i = 0
            while i < 3 {
                mins[i] = center[i] - radius
                maxs[i] = center[i] + radius
                i += 1
            }
            numListedEntities = trap_EntitiesInBox(mins, maxs, &iEntityList, MAX_GENTITIES)

            i = 0
            while i < numListedEntities {
                // Port-note: A read of `entityList`, a local the draft left as a hole.
                // Raven wrote: entityList[i] = &g_entities[iEntityList[i]]
                portMissing("ForceShootDrain", source: "oracle/codemp/game/w_force.c:2184")

                i += 1
            }

            e = 0
            while e < numListedEntities {
                // Port-note: A read of `entityList`, a local the draft left as a hole.
                // Raven wrote: traceEnt = entityList[e]
                portMissing("ForceShootDrain", source: "oracle/codemp/game/w_force.c:2184")

                if traceEnt == nil {
                    e += 1
                    continue
                }
                if traceEnt == `self` {
                    e += 1
                    continue
                }
                if !traceEnt!.inuse {
                    e += 1
                    continue
                }
                if !traceEnt!.takedamage {
                    e += 1
                    continue
                }
                if traceEnt!.health <= 0 {
                    e += 1
                    continue
                }
                if traceEnt!.client == nil {
                    e += 1
                    continue
                }
                if traceEnt!.client!.ps.fd.forcePower == 0 {
                    e += 1
                    continue
                }
                if OnSameTeam(`self`, traceEnt!) && g_friendlyFire.integer == 0 {
                    e += 1
                    continue
                }
                //this is all to see if we need to start a saber attack, if it's in flight, this doesn't matter
                // find the distance from the edge of the bounding box
                i = 0
                while i < 3 {
                    if center[i] < traceEnt!.r.absmin[i] {
                        v[i] = traceEnt!.r.absmin[i] - center[i]
                    } else if center[i] > traceEnt!.r.absmax[i] {
                        v[i] = center[i] - traceEnt!.r.absmax[i]
                    } else {
                        v[i] = 0
                    }
                    i += 1
                }

                size = traceEnt!.r.absmax - traceEnt!.r.absmin
                _VectorMA(traceEnt!.r.absmin, 0.5, size, &ent_org)

                //see if they're in front of me
                //must be within the forward cone
                dir = ent_org - center
                VectorNormalize(&dir)
                // Port-note: An assignment inside an expression.
                // Raven wrote: if ( (dot = DotProduct( dir, forward )) < 0.5 ) continue
                portMissing("ForceShootDrain", source: "oracle/codemp/game/w_force.c:2184")

                //must be close enough
                dist = VectorLength(v)
                if dist >= radius {
                    e += 1
                    continue
                }

                //in PVS?
                if !traceEnt!.r.bmodel && !trap_InPVS(ent_org, `self`.client!.ps.origin) {
                    //must be in PVS
                    e += 1
                    continue
                }

                //Now check and see if we can actually hit it
                trap_Trace(tr, `self`.client!.ps.origin, vec3_origin, vec3_origin, ent_org, `self`.s.number, MASK_SHOT)
                if tr.fraction < 1.0 && tr.entityNum != traceEnt!.s.number {
                    //must have clear LOS
                    e += 1
                    continue
                }

                // ok, we are within the radius, add us to the incoming list
                ForceDrainDamage(`self`, traceEnt!, dir, ent_org)
                gotOneOrMore = 1
                e += 1
            }
        } else {
            //trace-line
            _VectorMA(`self`.client!.ps.origin, 2048, forward, &end)

            trap_Trace(tr, `self`.client!.ps.origin, vec3_origin, vec3_origin, end, `self`.s.number, MASK_SHOT)
            if tr.entityNum == ENTITYNUM_NONE || Double(tr.fraction) == 1.0 || tr.allsolid != 0 || tr.startsolid != 0 || g_entities[tr.entityNum].client == nil || !g_entities[tr.entityNum].inuse {
                return 0
            }

            traceEnt = g_entities[tr.entityNum]
            ForceDrainDamage(`self`, traceEnt!, forward, tr.endpos)
            gotOneOrMore = 1
        }

        `self`.client!.ps.activeForcePass = `self`.client!.ps.fd.forcePowerLevel[FP_DRAIN] + FORCE_LEVEL_3

        BG_ForcePowerDrain(`self`.client!.ps, FP_DRAIN, 5) //used to be 1, but this did, too, anger the God of Balance.

        `self`.client!.ps.fd.forcePowerRegenDebounceTime = level.time + 500

        return gotOneOrMore
    }
}

/// Source: oracle/codemp/game/w_force.c:2317
func ForceJumpCharge(_ `self`: Entity, _ ucmd: JKAMP.Usercmd) {
    //I guess this is unused now. Was used for the "charge" jump type.
    let forceJumpChargeInterval: Float = forceJumpStrength[0] / (FORCE_JUMP_CHARGE_TIME / FRAMETIME)

    if `self`.health <= 0 {
        return
    }

    if `self`.client!.ps.fd.forceJumpCharge == 0 && `self`.client!.ps.groundEntityNum == ENTITYNUM_NONE {
        return
    }

    if `self`.client!.ps.fd.forcePower < forcePowerNeeded[`self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION]][FP_LEVITATION] {
        G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_1 - 50], CHAN_VOICE)
        return
    }

    if `self`.client!.ps.fd.forceJumpCharge == 0 {
        `self`.client!.ps.fd.forceJumpAddTime = 0
    }

    if `self`.client!.ps.fd.forceJumpAddTime >= level.time {
        return
    }

    //need to play sound
    if `self`.client!.ps.fd.forceJumpCharge == 0 {
        G_Sound(`self`, TRACK_CHANNEL_1, G_SoundIndex("sound/weapons/force/jumpbuild.wav"))
    }

    //Increment
    if `self`.client!.ps.fd.forceJumpAddTime < level.time {
        `self`.client!.ps.fd.forceJumpCharge += forceJumpChargeInterval * 50
        `self`.client!.ps.fd.forceJumpAddTime = level.time + 500
    }

    //clamp to max strength for current level
    if `self`.client!.ps.fd.forceJumpCharge > forceJumpStrength[`self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION]] {
        `self`.client!.ps.fd.forceJumpCharge = forceJumpStrength[`self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION]]
        G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_1 - 50], CHAN_VOICE)
    }

    //clamp to max available force power
    if `self`.client!.ps.fd.forceJumpCharge / forceJumpChargeInterval / (FORCE_JUMP_CHARGE_TIME / FRAMETIME) * forcePowerNeeded[`self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION]][FP_LEVITATION] > `self`.client!.ps.fd.forcePower {
        //can't use more than you have
        G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_1 - 50], CHAN_VOICE)
        `self`.client!.ps.fd.forceJumpCharge = `self`.client!.ps.fd.forcePower * forceJumpChargeInterval / (FORCE_JUMP_CHARGE_TIME / FRAMETIME)
    }

    //G_Printf("%f\n", self->client->ps.fd.forceJumpCharge);
}

/// Source: oracle/codemp/game/w_force.c:2377
func WP_GetVelocityForForceJump(_ `self`: Entity, _ jumpVel: inout JKAShared.vec3_t, _ ucmd: JKAMP.Usercmd) -> Int32 {
    var pushFwd: Float = 0
    var pushRt: Float = 0
    var view = vec3_t()
    var forward = vec3_t()
    var right = vec3_t()
    view = `self`.client!.ps.viewangles
    view[0] = 0
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("WP_GetVelocityForForceJump", source: "oracle/codemp/game/w_force.c:2377")
    var scratchUp = vec3_t()
    AngleVectors(view, &forward, &right, &scratchUp)
    if ucmd.forwardmove != 0 && ucmd.rightmove != 0 {
        if ucmd.forwardmove > 0 {
            pushFwd = 50
        } else {
            pushFwd = -50
        }
        if ucmd.rightmove > 0 {
            pushRt = 50
        } else {
            pushRt = -50
        }
    } else if ucmd.forwardmove != 0 || ucmd.rightmove != 0 {
        if ucmd.forwardmove > 0 {
            pushFwd = 100
        } else if ucmd.forwardmove < 0 {
            pushFwd = -100
        } else if ucmd.rightmove > 0 {
            pushRt = 100
        } else if ucmd.rightmove < 0 {
            pushRt = -100
        }
    }

    G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_1 - 50], CHAN_VOICE)

    G_PreDefSound(`self`.client!.ps.origin, PDSOUND_FORCEJUMP)

    if `self`.client!.ps.fd.forceJumpCharge < JUMP_VELOCITY + 40 {
        //give him at least a tiny boost from just a tap
        `self`.client!.ps.fd.forceJumpCharge = Float(JUMP_VELOCITY + 400)
    }

    if `self`.client!.ps.velocity[2] < -30 {
        //so that we can get a good boost when force jumping in a fall
        `self`.client!.ps.velocity[2] = -30
    }

    _VectorMA(`self`.client!.ps.velocity, pushFwd, forward, &jumpVel)
    _VectorMA(`self`.client!.ps.velocity, pushRt, right, &jumpVel)
    jumpVel[2] += `self`.client!.ps.fd.forceJumpCharge
    if pushFwd > 0 && `self`.client!.ps.fd.forceJumpCharge > 200 {
        return FJ_FORWARD
    } else if pushFwd < 0 && `self`.client!.ps.fd.forceJumpCharge > 200 {
        return FJ_BACKWARD
    } else if pushRt > 0 && `self`.client!.ps.fd.forceJumpCharge > 200 {
        return FJ_RIGHT
    } else if pushRt < 0 && `self`.client!.ps.fd.forceJumpCharge > 200 {
        return FJ_LEFT
    } else {
        return FJ_UP
    }
}

/// Source: oracle/codemp/game/w_force.c:2462
func ForceJump(_ `self`: Entity, _ ucmd: JKAMP.Usercmd) {
    let forceJumpChargeInterval: Float
    var jumpVel = vec3_t()

    if `self`.client!.ps.fd.forcePowerDuration[FP_LEVITATION] > level.time {
        return
    }
    if !WP_ForcePowerUsable(`self`, FP_LEVITATION) {
        return
    }
    if `self`.s.groundEntityNum == ENTITYNUM_NONE {
        return
    }
    if `self`.health <= 0 {
        return
    }

    `self`.client!.fjDidJump = true

    forceJumpChargeInterval = forceJumpStrength[`self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION]] / (FORCE_JUMP_CHARGE_TIME / FRAMETIME)

    WP_GetVelocityForForceJump(`self`, &jumpVel, ucmd)

    //FIXME: sound effect
    `self`.client!.ps.fd.forceJumpZStart = `self`.client!.ps.origin[2] //remember this for when we land
    `self`.client!.ps.velocity = jumpVel
    //wasn't allowing them to attack when jumping, but that was annoying
    //self->client->ps.weaponTime = self->client->ps.torsoAnimTimer;

    WP_ForcePowerStart(`self`, FP_LEVITATION, Int32(`self`.client!.ps.fd.forceJumpCharge / forceJumpChargeInterval / (FORCE_JUMP_CHARGE_TIME / FRAMETIME) * forcePowerNeeded[`self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION]][FP_LEVITATION]))
    //self->client->ps.fd.forcePowerDuration[FP_LEVITATION] = level.time + self->client->ps.weaponTime;
    `self`.client!.ps.fd.forceJumpCharge = 0
    `self`.client!.ps.forceJumpFlip = true
}

/// Source: oracle/codemp/game/w_force.c:2502
func WP_AddAsMindtricked(_ fd: JKAMP.Forcedata, _ entNum: Int32) {
    if entNum > 47 {
        fd.forceMindtrickTargetIndex4 |= (1 << (entNum - 48))
    } else if entNum > 31 {
        fd.forceMindtrickTargetIndex3 |= (1 << (entNum - 32))
    } else if entNum > 15 {
        fd.forceMindtrickTargetIndex2 |= (1 << (entNum - 16))
    } else {
        fd.forceMindtrickTargetIndex |= (1 << entNum)
    }
}

/// Source: oracle/codemp/game/w_force.c:2527
func ForceTelepathyCheckDirectNPCTarget(_ `self`: Entity, _ tr: JKAMP.Trace, _ tookPower: inout Bool) -> Bool {
    var traceEnt: Entity?
    var targetLive: Bool = false
    var mindTrickDone: Bool = false
    var tfrom = vec3_t()
    var tto = vec3_t()
    var fwd = vec3_t()
    let radius: Float = Float(MAX_TRICK_DISTANCE)

    //Check for a direct usage on NPCs first
    tfrom = `self`.client!.ps.origin
    tfrom[2] += `self`.client!.ps.viewheight
    // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("ForceTelepathyCheckDirectNPCTarget", source: "oracle/codemp/game/w_force.c:2527")
    var scratchRight = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("ForceTelepathyCheckDirectNPCTarget", source: "oracle/codemp/game/w_force.c:2527")
    var scratchUp = vec3_t()
    AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)
    tto[0] = tfrom[0] + fwd[0] * radius / 2
    tto[1] = tfrom[1] + fwd[1] * radius / 2
    tto[2] = tfrom[2] + fwd[2] * radius / 2

    // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
    portMissing("ForceTelepathyCheckDirectNPCTarget", source: "oracle/codemp/game/w_force.c:2527")
    // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
    portMissing("ForceTelepathyCheckDirectNPCTarget", source: "oracle/codemp/game/w_force.c:2527")
    trap_Trace(tr, tfrom, vec3_origin, vec3_origin, tto, `self`.s.number, MASK_PLAYERSOLID)

    if tr.entityNum == ENTITYNUM_NONE || tr.fraction == 1.0 || tr.allsolid != 0 || tr.startsolid != 0 {
        return false
    }

    traceEnt = g_entities[tr.entityNum]

    if traceEnt!.NPC != nil && (traceEnt!.NPC!.scriptFlags & SCF_NO_FORCE) != 0 {
        return false
    }

    if traceEnt != nil && traceEnt!.client != nil {
        switch traceEnt!.client!.NPC_class {
        //no droids either
        case CLASS_GALAKMECH, CLASS_ATST, CLASS_PROBE, CLASS_GONK, CLASS_R2D2, CLASS_R5D2, CLASS_MARK1, CLASS_MARK2, CLASS_MOUSE, CLASS_SEEKER, CLASS_REMOTE, CLASS_PROTOCOL, CLASS_BOBAFETT, CLASS_RANCOR:
            break

        default:
            targetLive = true
        }
    }

    if traceEnt!.s.number < MAX_CLIENTS {
        //a regular client
        return false
    }

    if targetLive && traceEnt!.NPC != nil {
        //hit an organic non-player
        var eyeDir = vec3_t()
        if G_ActivateBehavior(traceEnt!, BSET_MINDTRICK) {
            //activated a script on him
            //FIXME: do the visual sparkles effect on their heads, still?
            WP_ForcePowerStart(`self`, FP_TELEPATHY, 0)
        } else if (`self`.NPC != nil && traceEnt!.client!.playerTeam != `self`.client!.playerTeam) || (`self`.NPC == nil && traceEnt!.client!.playerTeam != `self`.client!.sess.sessionTeam) {
            //an enemy
            let override: Int32 = 0
            if (traceEnt!.NPC!.scriptFlags & SCF_NO_MIND_TRICK) != 0 {
            } else if traceEnt!.s.weapon != WP_SABER && traceEnt!.client!.NPC_class != CLASS_REBORN {
                //haha!  Jedi aren't easily confused!
                if `self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY] > FORCE_LEVEL_2 {
                    //turn them to our side
                    //if mind trick 3 and aiming at an enemy need more force power
                    if traceEnt!.s.weapon != WP_NONE {
                        //don't charm people who aren't capable of fighting... like ugnaughts and droids
                        var newPlayerTeam: Int32
                        var newEnemyTeam: Int32

                        if traceEnt!.enemy != nil {
                            G_ClearEnemy(traceEnt!)
                        }
                        if traceEnt!.NPC != nil {
                            //traceEnt->NPC->tempBehavior = BS_FOLLOW_LEADER;
                            traceEnt!.client!.leader = `self`
                        }
                        //FIXME: maybe pick an enemy right here?
                        if `self`.NPC != nil {
                            //NPC
                            newPlayerTeam = `self`.client!.playerTeam
                            newEnemyTeam = `self`.client!.enemyTeam
                        } else {
                            //client/bot
                            if `self`.client!.sess.sessionTeam == TEAM_BLUE {
                                //rebel
                                newPlayerTeam = NPCTEAM_PLAYER
                                newEnemyTeam = NPCTEAM_ENEMY
                            } else if `self`.client!.sess.sessionTeam == TEAM_RED {
                                //imperial
                                newPlayerTeam = NPCTEAM_ENEMY
                                newEnemyTeam = NPCTEAM_PLAYER
                            } else {
                                //neutral - wan't attack anyone
                                newPlayerTeam = NPCTEAM_NEUTRAL
                                newEnemyTeam = NPCTEAM_NEUTRAL
                            }
                        }
                        //store these for retrieval later
                        traceEnt!.genericValue1 = traceEnt!.client!.playerTeam
                        traceEnt!.genericValue2 = traceEnt!.client!.enemyTeam
                        traceEnt!.genericValue3 = traceEnt!.s.teamowner
                        //set the new values
                        traceEnt!.client!.playerTeam = newPlayerTeam
                        traceEnt!.client!.enemyTeam = newEnemyTeam
                        traceEnt!.s.teamowner = newPlayerTeam
                        //FIXME: need a *charmed* timer on this...?  Or do TEAM_PLAYERS assume that "confusion" means they should switch to team_enemy when done?
                        traceEnt!.NPC!.charmedTime = level.time + mindTrickTime[`self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY]]
                    }
                } else {
                    //just confuse them
                    //somehow confuse them?  Set don't fire to true for a while?  Drop their aggression?  Maybe just take their enemy away and don't let them pick one up for a while unless shot?
                    traceEnt!.NPC!.confusionTime = level.time + mindTrickTime[`self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY]] //confused for about 10 seconds
                    NPC_PlayConfusionSound(traceEnt!)
                    if traceEnt!.enemy != nil {
                        G_ClearEnemy(traceEnt!)
                    }
                }
            } else {
                NPC_Jedi_PlayConfusionSound(traceEnt!)
            }
            WP_ForcePowerStart(`self`, FP_TELEPATHY, override)
        } else if traceEnt!.client!.playerTeam == `self`.client!.playerTeam {
            //an ally
            //maybe just have him look at you?  Respond?  Take your enemy?
            if traceEnt!.client!.ps.pm_type < PM_DEAD && traceEnt!.NPC != nil && !((traceEnt!.NPC!.scriptFlags & SCF_NO_RESPONSE) != 0) {
                NPC_UseResponse(traceEnt!, `self`, false)
                WP_ForcePowerStart(`self`, FP_TELEPATHY, 1)
            }
        }
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceTelepathyCheckDirectNPCTarget", source: "oracle/codemp/game/w_force.c:2527")
        var scratchRight2 = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceTelepathyCheckDirectNPCTarget", source: "oracle/codemp/game/w_force.c:2527")
        var scratchUp2 = vec3_t()
        AngleVectors(traceEnt!.client!.renderInfo.eyeAngles, &eyeDir, &scratchRight2, &scratchUp2)
        VectorNormalize(&eyeDir)
        G_PlayEffectID(G_EffectIndex("force/force_touch"), traceEnt!.client!.renderInfo.eyePoint, eyeDir)

        //make sure this plays and that you cannot press fire for about 1 second after this
        //FIXME: BOTH_FORCEMINDTRICK or BOTH_FORCEDISTRACT
        //NPC_SetAnim( self, SETANIM_TORSO, BOTH_MINDTRICK1, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_RESTART|SETANIM_FLAG_HOLD );
        //FIXME: build-up or delay this until in proper part of anim
        mindTrickDone = true
    } else {
        if `self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY] > FORCE_LEVEL_1 && tr.fraction * 2048 > 64 {
            //don't create a diversion less than 64 from you of if at power level 1
            //use distraction anim instead
            G_PlayEffectID(G_EffectIndex("force/force_touch"), tr.endpos, tr.plane.normal)
            //FIXME: these events don't seem to always be picked up...?
            AddSoundEvent(`self`, tr.endpos, 512, AEL_SUSPICIOUS, true) //, qtrue );
            AddSightEvent(`self`, tr.endpos, 512, AEL_SUSPICIOUS, 50)
            WP_ForcePowerStart(`self`, FP_TELEPATHY, 0)
            tookPower = true
        }
        //NPC_SetAnim( self, SETANIM_TORSO, BOTH_MINDTRICK2, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_RESTART|SETANIM_FLAG_HOLD );
    }
    //self->client->ps.saberMove = self->client->ps.saberBounceMove = LS_READY;//don't finish whatever saber anim you may have been in
    `self`.client!.ps.saberBlocked = BLOCKED_NONE
    `self`.client!.ps.weaponTime = 1000
    /*
    if ( self->client->ps.fd.forcePowersActive&(1<<FP_SPEED) )
    {
    self->client->ps.weaponTime = floor( self->client->ps.weaponTime * g_timescale->value );
    }
    */
    return true
}

/// Source: oracle/codemp/game/w_force.c:2723
func ForceTelepathy(_ `self`: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var tto = vec3_t()
        var thispush_org = vec3_t()
        var a = vec3_t()
        var mins = vec3_t()
        var maxs = vec3_t()
        var fwdangles = vec3_t()
        var forward = vec3_t()
        var right = vec3_t()
        var center = vec3_t()
        var i: Int32 = 0
        var visionArc: Float = 0
        var radius: Float = Float(MAX_TRICK_DISTANCE)
        var tookPower: Bool = false

        if `self`.health <= 0 {
            return true
        }

        if `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE {
            return true
        }

        if `self`.client!.ps.weaponTime > 0 {
            return true
        }

        if `self`.client!.ps.powerups[PW_REDFLAG] != 0 || `self`.client!.ps.powerups[PW_BLUEFLAG] != 0 {
            //can't mindtrick while carrying the flag
            return true
        }

        if `self`.client!.ps.forceAllowDeactivateTime < level.time && (`self`.client!.ps.fd.forcePowersActive & (1 << FP_TELEPATHY)) != 0 {
            WP_ForcePowerStop(`self`, FP_TELEPATHY)
            return true
        }

        if !WP_ForcePowerUsable(`self`, FP_TELEPATHY) {
            return true
        }

        if ForceTelepathyCheckDirectNPCTarget(`self`, tr, &tookPower) {
            //hit an NPC directly
            `self`.client!.ps.forceAllowDeactivateTime = level.time + 1500
            G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/weapons/force/distract.wav"))
            `self`.client!.ps.forceHandExtend = HANDEXTEND_FORCEPUSH
            `self`.client!.ps.forceHandExtendTime = level.time + 1000
            return true
        }

        if `self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY] == FORCE_LEVEL_2 {
            visionArc = 180
        } else if `self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY] == FORCE_LEVEL_3 {
            visionArc = 360
            radius = MAX_TRICK_DISTANCE * 2.0
        }

        fwdangles = `self`.client!.ps.viewangles
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceTelepathy", source: "oracle/codemp/game/w_force.c:2723")
        var scratchUp = vec3_t()
        AngleVectors(fwdangles, &forward, &right, &scratchUp)
        center = `self`.client!.ps.origin

        i = 0
        while i < 3 {
            mins[i] = center[i] - radius
            maxs[i] = center[i] + radius
            i += 1
        }

        if `self`.client!.ps.fd.forcePowerLevel[FP_TELEPATHY] == FORCE_LEVEL_1 {
            if Double(tr.fraction) != 1.0 && tr.entityNum != ENTITYNUM_NONE && g_entities[tr.entityNum].inuse && g_entities[tr.entityNum].client != nil && g_entities[tr.entityNum].client!.pers.connected != 0 && g_entities[tr.entityNum].client!.sess.sessionTeam != TEAM_SPECTATOR {
                WP_AddAsMindtricked(`self`.client!.ps.fd, tr.entityNum)
                if !tookPower {
                    WP_ForcePowerStart(`self`, FP_TELEPATHY, 0)
                }

                G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/weapons/force/distract.wav"))

                `self`.client!.ps.forceHandExtend = HANDEXTEND_FORCEPUSH
                `self`.client!.ps.forceHandExtendTime = level.time + 1000

                return true
            } else {
                return true
            }
        } else {
            var ent: Entity?
            var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
            var numListedEntities: Int32 = 0
            var e: Int32 = 0
            var gotatleastone: Bool = false

            numListedEntities = trap_EntitiesInBox(mins, maxs, &entityList, MAX_GENTITIES)

            while e < numListedEntities {
                ent = g_entities[entityList[e]]

                if ent != nil {
                    //not in the arc, don't consider it
                    if ent!.client != nil {
                        thispush_org = ent!.client!.ps.origin
                    } else {
                        thispush_org = ent!.s.pos.trBase
                    }
                    tto = `self`.client!.ps.origin
                    tto[2] += `self`.client!.ps.viewheight
                    a = thispush_org - tto
                    vectoangles(a, &a)

                    if ent!.client == nil {
                        entityList[e] = ENTITYNUM_NONE
                    } else if InFieldOfVision(`self`.client!.ps.viewangles, visionArc, &a) == 0 {
                        //only bother with arc rules if the victim is a client
                        entityList[e] = ENTITYNUM_NONE
                    } else if ForcePowerUsableOn(`self`, ent!, FP_TELEPATHY) == 0 {
                        entityList[e] = ENTITYNUM_NONE
                    } else if OnSameTeam(`self`, ent!) {
                        entityList[e] = ENTITYNUM_NONE
                    }
                }
                ent = g_entities[entityList[e]]
                if ent != nil && ent != `self` && ent!.client != nil {
                    gotatleastone = true
                    WP_AddAsMindtricked(`self`.client!.ps.fd, ent!.s.number)
                }
                e += 1
            }

            if gotatleastone {
                `self`.client!.ps.forceAllowDeactivateTime = level.time + 1500

                if !tookPower {
                    WP_ForcePowerStart(`self`, FP_TELEPATHY, 0)
                }

                G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/weapons/force/distract.wav"))

                `self`.client!.ps.forceHandExtend = HANDEXTEND_FORCEPUSH
                `self`.client!.ps.forceHandExtendTime = level.time + 1000
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_force.c:2895
func GEntity_UseFunc(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    GlobalUse(`self`, other, activator)
}

/// Source: oracle/codemp/game/w_force.c:2900
func CanCounterThrow(_ `self`: Entity, _ thrower: Entity, _ pull: Bool) -> Bool {
    var powerUse: Int32 = 0

    if `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        return 0 != 0
    }

    if `self`.client!.ps.weaponTime > 0 {
        return 0 != 0
    }

    if `self`.health <= 0 {
        return 0 != 0
    }

    if `self`.client!.ps.powerups[PW_DISINT_4] > level.time {
        return 0 != 0
    }

    if `self`.client!.ps.weaponstate == WEAPON_CHARGING || `self`.client!.ps.weaponstate == WEAPON_CHARGING_ALT {
        //don't autodefend when charging a weapon
        return 0 != 0
    }

    if g_gametype.integer == GT_SIEGE && pull && thrower.client != nil {
        //in siege, pull will affect people if they are not facing you, so they can't run away so much
        var d = vec3_t()
        let a: Float

        d = thrower.client!.ps.origin - `self`.client!.ps.origin
        vectoangles(d, &d)

        a = AngleSubtract(d[YAW], `self`.client!.ps.viewangles[YAW])

        if a > 60.0 || a < -60.0 {
            //if facing more than 60 degrees away they cannot defend
            return 0 != 0
        }
    }

    if pull {
        powerUse = FP_PULL
    } else {
        powerUse = FP_PUSH
    }

    if !WP_ForcePowerUsable(`self`, powerUse) {
        return 0 != 0
    }

    if `self`.client!.ps.groundEntityNum == ENTITYNUM_NONE {
        //you cannot counter a push/pull if you're in the air
        return 0 != 0
    }

    return 1 != 0
}

/// Source: oracle/codemp/game/w_force.c:2970
func G_InGetUpAnim(_ ps: JKAMP.PlayerState) -> Bool {
    switch (ps.legsAnim) {
    case BOTH_GETUP1, BOTH_GETUP2, BOTH_GETUP3, BOTH_GETUP4, BOTH_GETUP5, BOTH_FORCE_GETUP_F1, BOTH_FORCE_GETUP_F2, BOTH_FORCE_GETUP_B1, BOTH_FORCE_GETUP_B2, BOTH_FORCE_GETUP_B3, BOTH_FORCE_GETUP_B4, BOTH_FORCE_GETUP_B5, BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_BROLL_L, BOTH_GETUP_BROLL_R, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F, BOTH_GETUP_FROLL_L, BOTH_GETUP_FROLL_R:
        return true

    default:
        break
    }

    switch (ps.torsoAnim) {
    case BOTH_GETUP1, BOTH_GETUP2, BOTH_GETUP3, BOTH_GETUP4, BOTH_GETUP5, BOTH_FORCE_GETUP_F1, BOTH_FORCE_GETUP_F2, BOTH_FORCE_GETUP_B1, BOTH_FORCE_GETUP_B2, BOTH_FORCE_GETUP_B3, BOTH_FORCE_GETUP_B4, BOTH_FORCE_GETUP_B5, BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_BROLL_L, BOTH_GETUP_BROLL_R, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F, BOTH_GETUP_FROLL_L, BOTH_GETUP_FROLL_R:
        return true

    default:
        break
    }

    return false
}

/// Source: oracle/codemp/game/w_force.c:3025
func G_LetGoOfWall(_ ent: Entity) {
    if ent.client == nil {
        return
    }
    ent.client!.ps.pm_flags &= ~PMF_STUCK_TO_WALL
    if BG_InReboundJump(ent.client!.ps.legsAnim) || BG_InReboundHold(ent.client!.ps.legsAnim) {
        ent.client!.ps.legsTimer = 0
    }
    if BG_InReboundJump(ent.client!.ps.torsoAnim) || BG_InReboundHold(ent.client!.ps.torsoAnim) {
        ent.client!.ps.torsoTimer = 0
    }
}

/// Source: oracle/codemp/game/w_force.c:3054
func ForceThrow(_ `self`: Entity, _ pull: Bool) {
    //shove things in front of you away
    var dist: Float = 0
    var ent: Entity?
    var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
    // Port-note: A local `gentity_t *[1024] push_list` the table has no type for.
    // Raven wrote: gentity_t *push_list[MAX_GENTITIES];
    portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")
    var numListedEntities: Int32 = 0
    var mins = vec3_t()
    var maxs = vec3_t()
    var v = vec3_t()
    var i: Int32 = 0
    var e: Int32 = 0
    var ent_count: Int32 = 0
    let radius: Int32 = 1024
    var powerLevel: Int32 = 0
    var visionArc: Int32 = 0
    var pushPower: Int32 = 0
    var pushPowerMod: Int32 = 0
    var center = vec3_t()
    var ent_org = vec3_t()
    var size = vec3_t()
    var forward = vec3_t()
    var right = vec3_t()
    var end = vec3_t()
    var dir = vec3_t()
    var fwdangles = vec3_t(0, 0, 0)
    var dot1: Float = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var x: Int32 = 0
        var pushDir = vec3_t()
        var thispush_org = vec3_t()
        var tfrom = vec3_t()
        var tto = vec3_t()
        var fwd = vec3_t()
        var a = vec3_t()
        var knockback: Float = Float(pull ? 0 : 200)
        var powerUse: Int32 = 0

        visionArc = 0

        if `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE && (`self`.client!.ps.forceHandExtend != HANDEXTEND_KNOCKDOWN || !G_InGetUpAnim(`self`.client!.ps)) {
            return true
        }

        if g_useWhileThrowing.integer == 0 && `self`.client!.ps.saberInFlight {
            return true
        }

        if `self`.client!.ps.weaponTime > 0 {
            return true
        }

        if `self`.health <= 0 {
            return true
        }
        if `self`.client!.ps.powerups[PW_DISINT_4] > level.time {
            return true
        }
        if pull {
            powerUse = FP_PULL
        } else {
            powerUse = FP_PUSH
        }

        if !WP_ForcePowerUsable(`self`, powerUse) {
            return true
        }

        if !pull && `self`.client!.ps.saberLockTime > level.time && `self`.client!.ps.saberLockFrame != 0 {
            G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/force/push.wav"))
            `self`.client!.ps.powerups[PW_DISINT_4] = level.time + 1500

            `self`.client!.ps.saberLockHits += `self`.client!.ps.fd.forcePowerLevel[FP_PUSH] * 2

            WP_ForcePowerStart(`self`, FP_PUSH, 0)
            return true
        }

        WP_ForcePowerStart(`self`, powerUse, 0)

        //make sure this plays and that you cannot press fire for about 1 second after this
        if pull {
            G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/force/pull.wav"))
            if `self`.client!.ps.forceHandExtend == HANDEXTEND_NONE {
                `self`.client!.ps.forceHandExtend = HANDEXTEND_FORCEPULL
                if g_gametype.integer == GT_SIEGE && `self`.client!.ps.weapon == WP_SABER {
                    //hold less so can attack right after a pull
                    `self`.client!.ps.forceHandExtendTime = level.time + 200
                } else {
                    `self`.client!.ps.forceHandExtendTime = level.time + 400
                }
            }
            `self`.client!.ps.powerups[PW_DISINT_4] = `self`.client!.ps.forceHandExtendTime + 200
            `self`.client!.ps.powerups[PW_PULL] = `self`.client!.ps.powerups[PW_DISINT_4]
        } else {
            G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/force/push.wav"))
            if `self`.client!.ps.forceHandExtend == HANDEXTEND_NONE {
                `self`.client!.ps.forceHandExtend = HANDEXTEND_FORCEPUSH
                `self`.client!.ps.forceHandExtendTime = level.time + 1000
            } else if `self`.client!.ps.forceHandExtend == HANDEXTEND_KNOCKDOWN && G_InGetUpAnim(`self`.client!.ps) {
                if `self`.client!.ps.forceDodgeAnim > 4 {
                    `self`.client!.ps.forceDodgeAnim -= 8
                }
                `self`.client!.ps.forceDodgeAnim += 8 //special case, play push on upper torso, but keep playing current knockdown anim on legs
            }
            `self`.client!.ps.powerups[PW_DISINT_4] = level.time + 1100
            `self`.client!.ps.powerups[PW_PULL] = 0
        }

        fwdangles = `self`.client!.ps.viewangles
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")
        var scratchUp = vec3_t()
        AngleVectors(fwdangles, &forward, &right, &scratchUp)
        center = `self`.client!.ps.origin

        i = 0
        while i < 3 {
            mins[i] = center[i] - radius
            maxs[i] = center[i] + radius
            i += 1
        }


        if pull {
            powerLevel = `self`.client!.ps.fd.forcePowerLevel[FP_PULL]
            pushPower = 256 * `self`.client!.ps.fd.forcePowerLevel[FP_PULL]
        } else {
            powerLevel = `self`.client!.ps.fd.forcePowerLevel[FP_PUSH]
            pushPower = 256 * `self`.client!.ps.fd.forcePowerLevel[FP_PUSH]
        }

        if powerLevel == 0 {
            //Shouldn't have made it here..
            return true
        }

        if powerLevel == FORCE_LEVEL_2 {
            visionArc = 60
        } else if powerLevel == FORCE_LEVEL_3 {
            visionArc = 180
        }

        if powerLevel == FORCE_LEVEL_1 {
            //can only push/pull targeted things at level 1
            tfrom = `self`.client!.ps.origin
            tfrom[2] += `self`.client!.ps.viewheight
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")
            var scratchRight = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")
            var scratchUp2 = vec3_t()
            AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp2)
            tto[0] = tfrom[0] + fwd[0] * radius / 2
            tto[1] = tfrom[1] + fwd[1] * radius / 2
            tto[2] = tfrom[2] + fwd[2] * radius / 2

            // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
            portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")
            // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
            portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")
            trap_Trace(tr, tfrom, vec3_origin, vec3_origin, tto, `self`.s.number, MASK_PLAYERSOLID)

            if Double(tr.fraction) != 1.0 && tr.entityNum != ENTITYNUM_NONE {
                if g_entities[tr.entityNum].client == nil && g_entities[tr.entityNum].s.eType == ET_NPC {
                    //g2animent
                    if g_entities[tr.entityNum].s.genericenemyindex < level.time {
                        g_entities[tr.entityNum].s.genericenemyindex = level.time + 2000
                    }
                }

                numListedEntities = 0
                entityList[numListedEntities] = tr.entityNum

                if pull {
                    if ForcePowerUsableOn(`self`, g_entities[tr.entityNum], FP_PULL) == 0 {
                        return true
                    }
                } else {
                    if ForcePowerUsableOn(`self`, g_entities[tr.entityNum], FP_PUSH) == 0 {
                        return true
                    }
                }
                numListedEntities += 1
            } else {
                //didn't get anything, so just
                return true
            }
        } else {
            numListedEntities = trap_EntitiesInBox(mins, maxs, &entityList, MAX_GENTITIES)

            e = 0

            while e < numListedEntities {
                ent = g_entities[entityList[e]]

                if ent!.client == nil && ent!.s.eType == ET_NPC {
                    //g2animent
                    if ent!.s.genericenemyindex < level.time {
                        ent!.s.genericenemyindex = level.time + 2000
                    }
                }

                if ent != nil {
                    if ent!.client != nil {
                        thispush_org = ent!.client!.ps.origin
                    } else {
                        thispush_org = ent!.s.pos.trBase
                    }
                }

                if ent != nil {
                    //not in the arc, don't consider it
                    tto = `self`.client!.ps.origin
                    tto[2] += `self`.client!.ps.viewheight
                    a = thispush_org - tto
                    vectoangles(a, &a)

                    if ent!.client != nil && InFieldOfVision(`self`.client!.ps.viewangles, Float(visionArc), &a) == 0 && ForcePowerUsableOn(`self`, ent!, powerUse) != 0 {
                        //only bother with arc rules if the victim is a client
                        entityList[e] = ENTITYNUM_NONE
                    } else if ent!.client != nil {
                        if pull {
                            if ForcePowerUsableOn(`self`, ent!, FP_PULL) == 0 {
                                entityList[e] = ENTITYNUM_NONE
                            }
                        } else {
                            if ForcePowerUsableOn(`self`, ent!, FP_PUSH) == 0 {
                                entityList[e] = ENTITYNUM_NONE
                            }
                        }
                    }
                }
                e += 1
            }
        }

        e = 0
        while e < numListedEntities {
            if entityList[e] != ENTITYNUM_NONE && entityList[e] >= 0 && entityList[e] < MAX_GENTITIES {
                ent = g_entities[entityList[e]]
            } else {
                ent = nil
            }

            if ent == nil {
                e += 1
                continue
            }
            if ent == `self` {
                e += 1
                continue
            }
            if ent!.client != nil && OnSameTeam(ent!, `self`) {
                e += 1
                continue
            }
            if !(ent!.inuse) {
                e += 1
                continue
            }
            if ent!.s.eType != ET_MISSILE {
                if ent!.s.eType != ET_ITEM {
                    //FIXME: need pushable objects
                    if Q_stricmp("func_button", ent!.classname!) == 0 {
                        //we might push it
                        if pull || !((ent!.spawnflags & SPF_BUTTON_FPUSHABLE) != 0) {
                            //not force-pushable, never pullable
                            e += 1
                            continue
                        }
                    } else {
                        if (ent!.s.eFlags & EF_NODRAW) != 0 {
                            e += 1
                            continue
                        }
                        if ent!.client == nil {
                            if Q_stricmp("lightsaber", ent!.classname!) != 0 {
                                //not a lightsaber
                                if Q_stricmp("func_door", ent!.classname!) != 0 || !((ent!.spawnflags & 2) != 0) {
                                    //not a force-usable door
                                    if Q_stricmp("func_static", ent!.classname!) != 0 || (!((ent!.spawnflags & 1) != 0) && !((ent!.spawnflags & 2) != 0)) {
                                        //not a force-usable func_static
                                        if Q_stricmp("limb", ent!.classname!) != 0 {
                                            //not a limb
                                            e += 1
                                            continue
                                        }
                                    }
                                } else if ent!.moverState != MOVER_POS1 && ent!.moverState != MOVER_POS2 {
                                    //not at rest
                                    e += 1
                                    continue
                                }
                            }
                        } else if ent!.client!.NPC_class == CLASS_GALAKMECH || ent!.client!.NPC_class == CLASS_ATST || ent!.client!.NPC_class == CLASS_RANCOR {
                            //can't push ATST or Galak or Rancor
                            e += 1
                            continue
                        }
                    }
                }
            } else {
                if ent!.s.pos.trType == TR_STATIONARY && (ent!.s.eFlags & EF_MISSILE_STICK) != 0 {
                    //can't force-push/pull stuck missiles (detpacks, tripmines)
                    e += 1
                    continue
                }
                if ent!.s.pos.trType == TR_STATIONARY && ent!.s.weapon != WP_THERMAL {
                    //only thermal detonators can be pushed once stopped
                    e += 1
                    continue
                }
            }

            //this is all to see if we need to start a saber attack, if it's in flight, this doesn't matter
            // find the distance from the edge of the bounding box
            i = 0
            while i < 3 {
                if center[i] < ent!.r.absmin[i] {
                    v[i] = ent!.r.absmin[i] - center[i]
                } else if center[i] > ent!.r.absmax[i] {
                    v[i] = center[i] - ent!.r.absmax[i]
                } else {
                    v[i] = 0
                }
                i += 1
            }

            size = ent!.r.absmax - ent!.r.absmin
            _VectorMA(ent!.r.absmin, 0.5, size, &ent_org)

            dir = ent_org - center
            VectorNormalize(&dir)
            // Port-note: An assignment inside an expression.
            // Raven wrote: if ( (dot1 = DotProduct( dir, forward )) < 0.6 ) continue
            portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")

            dist = VectorLength(v)

            //Now check and see if we can actually deflect it
            //method1
            //if within a certain range, deflect it
            if dist >= radius {
                e += 1
                continue
            }

            //in PVS?
            if !ent!.r.bmodel && !trap_InPVS(ent_org, `self`.client!.ps.origin) {
                //must be in PVS
                e += 1
                continue
            }

            //really should have a clear LOS to this thing...
            trap_Trace(tr, `self`.client!.ps.origin, vec3_origin, vec3_origin, ent_org, `self`.s.number, MASK_SHOT)
            if tr.fraction < 1.0 && tr.entityNum != ent!.s.number {
                //must have clear LOS
                //try from eyes too before you give up
                var eyePoint = vec3_t()
                eyePoint = `self`.client!.ps.origin
                eyePoint[2] += `self`.client!.ps.viewheight
                trap_Trace(tr, eyePoint, vec3_origin, vec3_origin, ent_org, `self`.s.number, MASK_SHOT)

                if tr.fraction < 1.0 && tr.entityNum != ent!.s.number {
                    e += 1
                    continue
                }
            }

            // ok, we are within the radius, add us to the incoming list
            // Port-note: A read of `push_list`, a local the draft left as a hole.
            // Raven wrote: push_list[ent_count] = ent
            portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")
            ent_count += 1
            e += 1
        }

        if ent_count != 0 {
            //method1:
            x = 0
            while x < ent_count {
                var modPowerLevel: Int32 = powerLevel


                // Port-note: A read of `push_list`, a local the draft left as a hole.
                // Raven wrote: if (push_list[x]->client) { modPowerLevel = WP_AbsorbConversion(push_list[x], push_list[x]->client->ps.fd.forcePowerLevel[FP_ABSORB], self, powerUse, powerLevel, forcePowerNeeded[self->client->ps.fd.forcePowerLevel[powerUse]][powerUse]); if (modPowerLevel == -1) { modPowerLevel = powerLevel; } }
                portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")

                pushPower = 256 * modPowerLevel

                // Port-note: A read of `push_list`, a local the draft left as a hole.
                // Raven wrote: if (push_list[x]->client) { VectorCopy(push_list[x]->client->ps.origin, thispush_org); } else { VectorCopy(push_list[x]->s.origin, thispush_org); }
                portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")

                // Port-note: A read of `push_list`, a local the draft left as a hole.
                // Raven wrote: if ( push_list[x]->client ) {//FIXME: make enemy jedi able to hunker down and resist this? int otherPushPower = push_list[x]->client->ps.fd.forcePowerLevel[powerUse]; qboolean canPullWeapon = qtrue; float dirLen = 0; if ( g_debugMelee.integer ) { if ( (push_list[x]->client->ps.pm_flags&PMF_STUCK_TO_WALL) ) {//no resistance if stuck to wall //push/pull them off the wall otherPushPower = 0; G_LetGoOfWall( push_list[x] ); } } knockback = pull?0:200; pushPowerMod = pushPower; if (push_list[x]->client->pers.cmd.forwardmove || push_list[x]->client->pers.cmd.rightmove) { //if you are moving, you get one less level of defense otherPushPower--; if (otherPushPower < 0) { otherPushPower = 0; } } if (otherPushPower && CanCounterThrow(push_list[x], self, pull)) { if ( pull ) { G_Sound( push_list[x], CHAN_BODY, G_SoundIndex( "sound/weapons/force/pull.wav" ) ); push_list[x]->client->ps.forceHandExtend = HANDEXTEND_FORCEPULL; push_list[x]->client->ps.forceHandExtendTime = level.time + 400; } else { G_Sound( push_list[x], CHAN_BODY, G_SoundIndex( "sound/weapons/force/push.wav" ) ); push_list[x]->client->ps.forceHandExtend = HANDEXTEND_FORCEPUSH; push_list[x]->client->ps.forceHandExtendTime = level.time + 1000; } push_list[x]->client->ps.powerups[PW_DISINT_4] = push_list[x]->client->ps.forceHandExtendTime + 200; if (pull) { push_list[x]->client->ps.powerups[PW_PULL] = push_list[x]->client->ps.powerups[PW_DISINT_4]; } else { push_list[x]->client->ps.powerups[PW_PULL] = 0; } //Make a counter-throw effect if (otherPushPower >= modPowerLevel) { pushPowerMod = 0; canPullWeapon = qfalse; } else { int powerDif = (modPowerLevel - otherPushPower); if (powerDif >= 3) { pushPowerMod -= pushPowerMod*0.2; } else if (powerDif == 2) { pushPowerMod -= pushPowerMod*0.4; } else if (powerDif == 1) { pushPowerMod -= pushPowerMod*0.8; } if (pushPowerMod < 0) { pushPowerMod = 0; } } } //shove them if ( pull ) { VectorSubtract( self->client->ps.origin, thispush_org, pushDir ); if (push_list[x]->client && VectorLength(pushDir) <= 256) { int randfact = 0; if (modPowerLevel == FORCE_LEVEL_1) { randfact = 3; } else if (modPowerLevel == FORCE_LEVEL_2) { randfact = 7; } else if (modPowerLevel == FORCE_LEVEL_3) { randfact = 10; } if (!OnSameTeam(self, push_list[x]) && Q_irand(1, 10) <= randfact && canPullWeapon) { vec3_t uorg, vecnorm; VectorCopy(self->client->ps.origin, uorg); uorg[2] += 64; VectorSubtract(uorg, thispush_org, vecnorm); VectorNormalize(vecnorm); TossClientWeapon(push_list[x], vecnorm, 500); } } } else { VectorSubtract( thispush_org, self->client->ps.origin, pushDir ); } if ((modPowerLevel > otherPushPower || push_list[x]->client->ps.m_iVehicleNum) && push_list[x]->client) { if (modPowerLevel == FORCE_LEVEL_3 && push_list[x]->client->ps.forceHandExtend != HANDEXTEND_KNOCKDOWN) { dirLen = VectorLength(pushDir); if (BG_KnockDownable(&push_list[x]->client->ps) && dirLen <= (64*((modPowerLevel - otherPushPower)-1))) { //can only do a knockdown if fairly close push_list[x]->client->ps.forceHandExtend = HANDEXTEND_KNOCKDOWN; push_list[x]->client->ps.forceHandExtendTime = level.time + 700; push_list[x]->client->ps.forceDodgeAnim = 0; //this toggles between 1 and 0, when it's 1 we should play the get up anim push_list[x]->client->ps.quickerGetup = qtrue; } else if (push_list[x]->s.number < MAX_CLIENTS && push_list[x]->client->ps.m_iVehicleNum && dirLen <= 128.0f ) { //a player on a vehicle gentity_t *vehEnt = &g_entities[push_list[x]->client->ps.m_iVehicleNum]; if (vehEnt->inuse && vehEnt->client && vehEnt->m_pVehicle) { if (vehEnt->m_pVehicle->m_pVehicleInfo->type == VH_SPEEDER || vehEnt->m_pVehicle->m_pVehicleInfo->type == VH_ANIMAL) { //push the guy off vehEnt->m_pVehicle->m_pVehicleInfo->Eject(vehEnt->m_pVehicle, (bgEntity_t *)push_list[x], qfalse); } } } } } if (!dirLen) { dirLen = VectorLength(pushDir); } VectorNormalize(pushDir); if (push_list[x]->client) { //escape a force grip if we're in one if (self->client->ps.fd.forceGripBeingGripped > level.time) { //force the enemy to stop gripping me if I managed to push him if (push_list[x]->client->ps.fd.forceGripEntityNum == self->s.number) { if (modPowerLevel >= push_list[x]->client->ps.fd.forcePowerLevel[FP_GRIP]) { //only break the grip if our push/pull level is >= their grip level WP_ForcePowerStop(push_list[x], FP_GRIP); self->client->ps.fd.forceGripBeingGripped = 0; push_list[x]->client->ps.fd.forceGripUseTime = level.time + 1000; //since we just broke out of it.. } } } push_list[x]->client->ps.otherKiller = self->s.number; push_list[x]->client->ps.otherKillerTime = level.time + 5000; push_list[x]->client->ps.otherKillerDebounceTime = level.time + 100; push_list[x]->client->otherKillerMOD = MOD_UNKNOWN; push_list[x]->client->otherKillerVehWeapon = 0; push_list[x]->client->otherKillerWeaponType = WP_NONE; pushPowerMod -= (dirLen*0.7); if (pushPowerMod < 16) { pushPowerMod = 16; } //fullbody push effect push_list[x]->client->pushEffectTime = level.time + 600; push_list[x]->client->ps.velocity[0] = pushDir[0]*pushPowerMod; push_list[x]->client->ps.velocity[1] = pushDir[1]*pushPowerMod; if ((int)push_list[x]->client->ps.velocity[2] == 0) { //if not going anywhere vertically, boost them up a bit push_list[x]->client->ps.velocity[2] = pushDir[2]*pushPowerMod; if (push_list[x]->client->ps.velocity[2] < 128) { push_list[x]->client->ps.velocity[2] = 128; } } else { push_list[x]->client->ps.velocity[2] = pushDir[2]*pushPowerMod; } } } else if ( push_list[x]->s.eType == ET_MISSILE && push_list[x]->s.pos.trType != TR_STATIONARY && (push_list[x]->s.pos.trType != TR_INTERPOLATE||push_list[x]->s.weapon != WP_THERMAL) )//rolling and stationary thermal detonators are dealt with below { if ( pull ) {//deflect rather than reflect? } else { G_ReflectMissile( self, push_list[x], forward ); } } else if ( !Q_stricmp( "func_static", push_list[x]->classname ) ) {//force-usable func_static if ( !pull && (push_list[x]->spawnflags&1/*F_PUSH*/) ) { GEntity_UseFunc( push_list[x], self, self ); } else if ( pull && (push_list[x]->spawnflags&2/*F_PULL*/) ) { GEntity_UseFunc( push_list[x], self, self ); } } else if ( !Q_stricmp( "func_door", push_list[x]->classname ) && (push_list[x]->spawnflags&2) ) {//push/pull the door vec3_t pos1, pos2; vec3_t trFrom; VectorCopy(self->client->ps.origin, trFrom); trFrom[2] += self->client->ps.viewheight; AngleVectors( self->client->ps.viewangles, forward, NULL, NULL ); VectorNormalize( forward ); VectorMA( trFrom, radius, forward, end ); trap_Trace( &tr, trFrom, vec3_origin, vec3_origin, end, self->s.number, MASK_SHOT ); if ( tr.entityNum != push_list[x]->s.number || tr.fraction == 1.0 || tr.allsolid || tr.startsolid ) {//must be pointing right at it continue; } if ( VectorCompare( vec3_origin, push_list[x]->s.origin ) ) {//does not have an origin brush, so pos1 & pos2 are relative to world origin, need to calc center VectorSubtract( push_list[x]->r.absmax, push_list[x]->r.absmin, size ); VectorMA( push_list[x]->r.absmin, 0.5, size, center ); if ( (push_list[x]->spawnflags&1) && push_list[x]->moverState == MOVER_POS1 ) {//if at pos1 and started open, make sure we get the center where it *started* because we're going to add back in the relative values pos1 and pos2 VectorSubtract( center, push_list[x]->pos1, center ); } else if ( !(push_list[x]->spawnflags&1) && push_list[x]->moverState == MOVER_POS2 ) {//if at pos2, make sure we get the center where it *started* because we're going to add back in the relative values pos1 and pos2 VectorSubtract( center, push_list[x]->pos2, center ); } VectorAdd( center, push_list[x]->pos1, pos1 ); VectorAdd( center, push_list[x]->pos2, pos2 ); } else {//actually has an origin, pos1 and pos2 are absolute VectorCopy( push_list[x]->r.currentOrigin, center ); VectorCopy( push_list[x]->pos1, pos1 ); VectorCopy( push_list[x]->pos2, pos2 ); } if ( Distance( pos1, trFrom ) < Distance( pos2, trFrom ) ) {//pos1 is closer if ( push_list[x]->moverState == MOVER_POS1 ) {//at the closest pos if ( pull ) {//trying to pull, but already at closest point, so screw it continue; } } else if ( push_list[x]->moverState == MOVER_POS2 ) {//at farthest pos if ( !pull ) {//trying to push, but already at farthest point, so screw it continue; } } } else {//pos2 is closer if ( push_list[x]->moverState == MOVER_POS1 ) {//at the farthest pos if ( !pull ) {//trying to push, but already at farthest point, so screw it continue; } } else if ( push_list[x]->moverState == MOVER_POS2 ) {//at closest pos if ( pull ) {//trying to pull, but already at closest point, so screw it continue; } } } GEntity_UseFunc( push_list[x], self, self ); } else if ( Q_stricmp( "func_button", push_list[x]->classname ) == 0 ) {//pretend you pushed it Touch_Button( push_list[x], self, NULL ); continue; }
                portMissing("ForceThrow", source: "oracle/codemp/game/w_force.c:3054")
                x += 1
            }
        }

        //attempt to break any leftover grips
        //if we're still in a current grip that wasn't broken by the push, it will still remain
        `self`.client!.dangerTime = level.time
        `self`.client!.ps.eFlags &= ~EF_INVULNERABLE
        `self`.client!.invulnerableTimer = 0

        if `self`.client!.ps.fd.forceGripBeingGripped > level.time {
            `self`.client!.ps.fd.forceGripBeingGripped = 0
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_force.c:3822
func WP_ForcePowerStop(_ `self`: Entity, _ forcePower: JKAMP.forcePowers_t) {
    let wasActive: Int32 = `self`.client!.ps.fd.forcePowersActive

    `self`.client!.ps.fd.forcePowersActive &= ~(1 << forcePower)

    switch Int32(forcePower) {
    case FP_HEAL:
        `self`.client!.ps.fd.forceHealAmount = 0
        `self`.client!.ps.fd.forceHealTime = 0

    case FP_LEVITATION:
        break

    case FP_SPEED:
        if (wasActive & (1 << FP_SPEED)) != 0 {
            G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_2 - 50], CHAN_VOICE)
        }

    case FP_PUSH:
        break

    case FP_PULL:
        break

    case FP_TELEPATHY:
        if (wasActive & (1 << FP_TELEPATHY)) != 0 {
            G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/weapons/force/distractstop.wav"))
        }
        `self`.client!.ps.fd.forceMindtrickTargetIndex = 0
        `self`.client!.ps.fd.forceMindtrickTargetIndex2 = 0
        `self`.client!.ps.fd.forceMindtrickTargetIndex3 = 0
        `self`.client!.ps.fd.forceMindtrickTargetIndex4 = 0

    case FP_SEE:
        if (wasActive & (1 << FP_SEE)) != 0 {
            G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_5 - 50], CHAN_VOICE)
        }

    case FP_GRIP:
        `self`.client!.ps.fd.forceGripUseTime = level.time + 3000
        if `self`.client!.ps.fd.forcePowerLevel[FP_GRIP] > FORCE_LEVEL_1 && g_entities[`self`.client!.ps.fd.forceGripEntityNum].client != nil && g_entities[`self`.client!.ps.fd.forceGripEntityNum].health > 0 && g_entities[`self`.client!.ps.fd.forceGripEntityNum].inuse && (level.time - g_entities[`self`.client!.ps.fd.forceGripEntityNum].client!.ps.fd.forceGripStarted) > 500 {
            //if we had our throat crushed in for more than half a second, gasp for air when we're let go
            if (wasActive & (1 << FP_GRIP)) != 0 {
                G_EntitySound(g_entities[`self`.client!.ps.fd.forceGripEntityNum], CHAN_VOICE, G_SoundIndex("*gasp.wav"))
            }
        }

        if g_entities[`self`.client!.ps.fd.forceGripEntityNum].client != nil && g_entities[`self`.client!.ps.fd.forceGripEntityNum].inuse {
            g_entities[`self`.client!.ps.fd.forceGripEntityNum].client!.ps.forceGripChangeMovetype = PM_NORMAL
        }

        if `self`.client!.ps.forceHandExtend == HANDEXTEND_FORCE_HOLD {
            `self`.client!.ps.forceHandExtendTime = 0
        }

        `self`.client!.ps.fd.forceGripEntityNum = ENTITYNUM_NONE

        `self`.client!.ps.powerups[PW_DISINT_4] = 0

    case FP_LIGHTNING:
        if `self`.client!.ps.fd.forcePowerLevel[FP_LIGHTNING] < FORCE_LEVEL_2 {
            //don't do it again for 3 seconds, minimum... FIXME: this should be automatic once regeneration is slower (normal)
            `self`.client!.ps.fd.forcePowerDebounce[FP_LIGHTNING] = level.time + 3000
        } else {
            `self`.client!.ps.fd.forcePowerDebounce[FP_LIGHTNING] = level.time + 1500
        }
        if `self`.client!.ps.forceHandExtend == HANDEXTEND_FORCE_HOLD {
            `self`.client!.ps.forceHandExtendTime = 0 //reset hand position
        }

        `self`.client!.ps.activeForcePass = 0

    case FP_RAGE:
        `self`.client!.ps.fd.forceRageRecoveryTime = level.time + 10000
        if (wasActive & (1 << FP_RAGE)) != 0 {
            G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_3 - 50], CHAN_VOICE)
        }

    case FP_ABSORB:
        if (wasActive & (1 << FP_ABSORB)) != 0 {
            G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_3 - 50], CHAN_VOICE)
        }

    case FP_PROTECT:
        if (wasActive & (1 << FP_PROTECT)) != 0 {
            G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_3 - 50], CHAN_VOICE)
        }

    case FP_DRAIN:
        if `self`.client!.ps.fd.forcePowerLevel[FP_DRAIN] < FORCE_LEVEL_2 {
            //don't do it again for 3 seconds, minimum...
            `self`.client!.ps.fd.forcePowerDebounce[FP_DRAIN] = level.time + 3000
        } else {
            `self`.client!.ps.fd.forcePowerDebounce[FP_DRAIN] = level.time + 1500
        }

        if `self`.client!.ps.forceHandExtend == HANDEXTEND_FORCE_HOLD {
            `self`.client!.ps.forceHandExtendTime = 0 //reset hand position
        }

        `self`.client!.ps.activeForcePass = 0
        fallthrough

    default:
        break
    }
}

/// Source: oracle/codemp/game/w_force.c:3948
func DoGripAction(_ `self`: Entity, _ forcePower: JKAMP.forcePowers_t) {
    var gripEnt: Entity?
    var gripLevel: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var a = vec3_t()
        var fwd = vec3_t()
        var fwd_o = vec3_t()
        var start_o = vec3_t()
        var nvel = vec3_t()

        `self`.client!.dangerTime = level.time
        `self`.client!.ps.eFlags &= ~EF_INVULNERABLE
        `self`.client!.invulnerableTimer = 0

        gripEnt = g_entities[`self`.client!.ps.fd.forceGripEntityNum]

        if gripEnt == nil || gripEnt!.client == nil || !gripEnt!.inuse || gripEnt!.health < 1 || ForcePowerUsableOn(`self`, gripEnt!, FP_GRIP) == 0 {
            WP_ForcePowerStop(`self`, forcePower)
            `self`.client!.ps.fd.forceGripEntityNum = ENTITYNUM_NONE

            if gripEnt != nil && gripEnt!.client != nil && gripEnt!.inuse {
                gripEnt!.client!.ps.forceGripChangeMovetype = PM_NORMAL
            }
            return true
        }

        a = gripEnt!.client!.ps.origin - `self`.client!.ps.origin

        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("DoGripAction", source: "oracle/codemp/game/w_force.c:3948")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("DoGripAction", source: "oracle/codemp/game/w_force.c:3948")
        trap_Trace(tr, `self`.client!.ps.origin, vec3_origin, vec3_origin, gripEnt!.client!.ps.origin, `self`.s.number, MASK_PLAYERSOLID)

        gripLevel = WP_AbsorbConversion(gripEnt!, gripEnt!.client!.ps.fd.forcePowerLevel[FP_ABSORB], `self`, FP_GRIP, `self`.client!.ps.fd.forcePowerLevel[FP_GRIP], forcePowerNeeded[`self`.client!.ps.fd.forcePowerLevel[FP_GRIP]][FP_GRIP])

        if gripLevel == -1 {
            gripLevel = `self`.client!.ps.fd.forcePowerLevel[FP_GRIP]
        }

        if gripLevel == 0 {
            WP_ForcePowerStop(`self`, forcePower)
            return true
        }

        if VectorLength(a) > MAX_GRIP_DISTANCE {
            WP_ForcePowerStop(`self`, forcePower)
            return true
        }

        if !InFront(gripEnt!.client!.ps.origin, `self`.client!.ps.origin, `self`.client!.ps.viewangles, 0.9) && gripLevel < FORCE_LEVEL_3 {
            WP_ForcePowerStop(`self`, forcePower)
            return true
        }

        if tr.fraction != 1.0 && tr.entityNum != gripEnt!.s.number {
            WP_ForcePowerStop(`self`, forcePower)
            return true
        }

        if `self`.client!.ps.fd.forcePowerDebounce[FP_GRIP] < level.time {
            //2 damage per second while choking, resulting in 10 damage total (not including The Squeeze<tm>)
            `self`.client!.ps.fd.forcePowerDebounce[FP_GRIP] = level.time + 1000
            // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("DoGripAction", source: "oracle/codemp/game/w_force.c:3948")
            var scratchDir = vec3_t()
            G_Damage(gripEnt!, `self`, `self`, &scratchDir, nil, 2, DAMAGE_NO_ARMOR, MOD_FORCE_DARK)
        }

        Jetpack_Off(gripEnt!) //make sure the guy being gripped has his jetpack off.

        if gripLevel == FORCE_LEVEL_1 {
            gripEnt!.client!.ps.fd.forceGripBeingGripped = Float(level.time + 1000)

            if (level.time - gripEnt!.client!.ps.fd.forceGripStarted) > 5000 {
                WP_ForcePowerStop(`self`, forcePower)
            }
            return true
        }

        if gripLevel == FORCE_LEVEL_2 {
            gripEnt!.client!.ps.fd.forceGripBeingGripped = Float(level.time + 1000)

            if gripEnt!.client!.ps.forceGripMoveInterval < level.time {
                gripEnt!.client!.ps.velocity[2] = 30

                gripEnt!.client!.ps.forceGripMoveInterval = level.time + 300 //only update velocity every 300ms, so as to avoid heavy bandwidth usage
            }

            gripEnt!.client!.ps.otherKiller = `self`.s.number
            gripEnt!.client!.ps.otherKillerTime = level.time + 5000
            gripEnt!.client!.ps.otherKillerDebounceTime = level.time + 100
            gripEnt!.client!.otherKillerMOD = MOD_UNKNOWN
            gripEnt!.client!.otherKillerVehWeapon = 0
            gripEnt!.client!.otherKillerWeaponType = WP_NONE

            gripEnt!.client!.ps.forceGripChangeMovetype = PM_FLOAT

            if (level.time - gripEnt!.client!.ps.fd.forceGripStarted) > 3000 && `self`.client!.ps.fd.forceGripDamageDebounceTime == 0 {
                //if we managed to lift him into the air for 2 seconds, give him a crack
                `self`.client!.ps.fd.forceGripDamageDebounceTime = 1
                // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("DoGripAction", source: "oracle/codemp/game/w_force.c:3948")
                var scratchDir2 = vec3_t()
                G_Damage(gripEnt!, `self`, `self`, &scratchDir2, nil, 20, DAMAGE_NO_ARMOR, MOD_FORCE_DARK)

                //Must play custom sounds on the actual entity. Don't use G_Sound (it creates a temp entity for the sound)
                G_EntitySound(gripEnt!, CHAN_VOICE, G_SoundIndex(va("*choke%d.wav", Q_irand(1, 3))))

                gripEnt!.client!.ps.forceHandExtend = HANDEXTEND_CHOKE
                gripEnt!.client!.ps.forceHandExtendTime = level.time + 2000

                if (gripEnt!.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 {
                    //choking, so don't let him keep gripping himself
                    WP_ForcePowerStop(gripEnt!, FP_GRIP)
                }
            } else if (level.time - gripEnt!.client!.ps.fd.forceGripStarted) > 4000 {
                WP_ForcePowerStop(`self`, forcePower)
            }
            return true
        }

        if gripLevel == FORCE_LEVEL_3 {
            gripEnt!.client!.ps.fd.forceGripBeingGripped = Float(level.time + 1000)

            gripEnt!.client!.ps.otherKiller = `self`.s.number
            gripEnt!.client!.ps.otherKillerTime = level.time + 5000
            gripEnt!.client!.ps.otherKillerDebounceTime = level.time + 100
            gripEnt!.client!.otherKillerMOD = MOD_UNKNOWN
            gripEnt!.client!.otherKillerVehWeapon = 0
            gripEnt!.client!.otherKillerWeaponType = WP_NONE

            gripEnt!.client!.ps.forceGripChangeMovetype = PM_FLOAT

            if gripEnt!.client!.ps.forceGripMoveInterval < level.time {
                var nvLen: Float = 0

                start_o = gripEnt!.client!.ps.origin
                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("DoGripAction", source: "oracle/codemp/game/w_force.c:3948")
                var scratchRight = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("DoGripAction", source: "oracle/codemp/game/w_force.c:3948")
                var scratchUp = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)
                fwd_o[0] = `self`.client!.ps.origin[0] + fwd[0] * 128
                fwd_o[1] = `self`.client!.ps.origin[1] + fwd[1] * 128
                fwd_o[2] = `self`.client!.ps.origin[2] + fwd[2] * 128
                fwd_o[2] += 16
                nvel = fwd_o - start_o

                nvLen = VectorLength(nvel)

                if nvLen < 16 {
                    //within x units of desired spot
                    VectorNormalize(&nvel)
                    gripEnt!.client!.ps.velocity[0] = nvel[0] * 8
                    gripEnt!.client!.ps.velocity[1] = nvel[1] * 8
                    gripEnt!.client!.ps.velocity[2] = nvel[2] * 8
                } else if nvLen < 64 {
                    VectorNormalize(&nvel)
                    gripEnt!.client!.ps.velocity[0] = nvel[0] * 128
                    gripEnt!.client!.ps.velocity[1] = nvel[1] * 128
                    gripEnt!.client!.ps.velocity[2] = nvel[2] * 128
                } else if nvLen < 128 {
                    VectorNormalize(&nvel)
                    gripEnt!.client!.ps.velocity[0] = nvel[0] * 256
                    gripEnt!.client!.ps.velocity[1] = nvel[1] * 256
                    gripEnt!.client!.ps.velocity[2] = nvel[2] * 256
                } else if nvLen < 200 {
                    VectorNormalize(&nvel)
                    gripEnt!.client!.ps.velocity[0] = nvel[0] * 512
                    gripEnt!.client!.ps.velocity[1] = nvel[1] * 512
                    gripEnt!.client!.ps.velocity[2] = nvel[2] * 512
                } else {
                    VectorNormalize(&nvel)
                    gripEnt!.client!.ps.velocity[0] = nvel[0] * 700
                    gripEnt!.client!.ps.velocity[1] = nvel[1] * 700
                    gripEnt!.client!.ps.velocity[2] = nvel[2] * 700
                }

                gripEnt!.client!.ps.forceGripMoveInterval = level.time + 300 //only update velocity every 300ms, so as to avoid heavy bandwidth usage
            }

            if (level.time - gripEnt!.client!.ps.fd.forceGripStarted) > 3000 && `self`.client!.ps.fd.forceGripDamageDebounceTime == 0 {
                //if we managed to lift him into the air for 2 seconds, give him a crack
                `self`.client!.ps.fd.forceGripDamageDebounceTime = 1
                // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("DoGripAction", source: "oracle/codemp/game/w_force.c:3948")
                var scratchDir3 = vec3_t()
                G_Damage(gripEnt!, `self`, `self`, &scratchDir3, nil, 40, DAMAGE_NO_ARMOR, MOD_FORCE_DARK)

                //Must play custom sounds on the actual entity. Don't use G_Sound (it creates a temp entity for the sound)
                G_EntitySound(gripEnt!, CHAN_VOICE, G_SoundIndex(va("*choke%d.wav", Q_irand(1, 3))))

                gripEnt!.client!.ps.forceHandExtend = HANDEXTEND_CHOKE
                gripEnt!.client!.ps.forceHandExtendTime = level.time + 2000

                if (gripEnt!.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 {
                    //choking, so don't let him keep gripping himself
                    WP_ForcePowerStop(gripEnt!, FP_GRIP)
                }
            } else if (level.time - gripEnt!.client!.ps.fd.forceGripStarted) > 4000 {
                WP_ForcePowerStop(`self`, forcePower)
            }
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_force.c:4164
func G_IsMindTricked(_ fd: JKAMP.Forcedata, _ client: Int32) -> Bool {
    var checkIn: Int32
    let trickIndex1: Int32
    let trickIndex2: Int32
    let trickIndex3: Int32
    let trickIndex4: Int32
    var sub: Int32 = 0


    trickIndex1 = fd.forceMindtrickTargetIndex
    trickIndex2 = fd.forceMindtrickTargetIndex2
    trickIndex3 = fd.forceMindtrickTargetIndex3
    trickIndex4 = fd.forceMindtrickTargetIndex4

    if client > 47 {
        checkIn = trickIndex4
        sub = 48
    } else if client > 31 {
        checkIn = trickIndex3
        sub = 32
    } else if client > 15 {
        checkIn = trickIndex2
        sub = 16
    } else {
        checkIn = trickIndex1
    }

    if (checkIn & (1 << (client - sub))) != 0 {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/w_force.c:4208
private func RemoveTrickedEnt(_ fd: JKAMP.Forcedata, _ client: Int32) {
    if client > 47 {
        fd.forceMindtrickTargetIndex4 &= ~(1 << (client - 48))
    } else if client > 31 {
        fd.forceMindtrickTargetIndex3 &= ~(1 << (client - 32))
    } else if client > 15 {
        fd.forceMindtrickTargetIndex2 &= ~(1 << (client - 16))
    } else {
        fd.forceMindtrickTargetIndex &= ~(1 << client)
    }
}

/// Source: oracle/codemp/game/w_force.c:4236
private func WP_UpdateMindtrickEnts(_ `self`: Entity) {
    var i: Int32 = 0

    while i < MAX_CLIENTS {
        if G_IsMindTricked(`self`.client!.ps.fd, i) {
            let ent: Entity? = g_entities[i]

            if ent == nil || ent!.client == nil || !ent!.inuse || ent!.health < 1 || (ent!.client!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0 {
                RemoveTrickedEnt(`self`.client!.ps.fd, i)
            } else if (level.time - `self`.client!.dangerTime) < g_TimeSinceLastFrame * 4 {
                //Untrick this entity if the tricker (self) fires while in his fov
                if trap_InPVS(ent!.client!.ps.origin, `self`.client!.ps.origin) && OrgVisible(ent!.client!.ps.origin, `self`.client!.ps.origin, ent!.s.number) != 0 {
                    RemoveTrickedEnt(`self`.client!.ps.fd, i)
                }
            } else if BG_HasYsalamiri(g_gametype.integer, ent!.client!.ps) {
                RemoveTrickedEnt(`self`.client!.ps.fd, i)
            }
        }

        i += 1
    }

    if `self`.client!.ps.fd.forceMindtrickTargetIndex == 0 && `self`.client!.ps.fd.forceMindtrickTargetIndex2 == 0 && `self`.client!.ps.fd.forceMindtrickTargetIndex3 == 0 && `self`.client!.ps.fd.forceMindtrickTargetIndex4 == 0 {
        //everyone who we had tricked is no longer tricked, so stop the power
        WP_ForcePowerStop(`self`, FP_TELEPATHY)
    } else if `self`.client!.ps.powerups[PW_REDFLAG] != 0 || `self`.client!.ps.powerups[PW_BLUEFLAG] != 0 {
        WP_ForcePowerStop(`self`, FP_TELEPATHY)
    }
}

/// Source: oracle/codemp/game/w_force.c:4282
private func WP_ForcePowerRun(_ `self`: Entity, _ forcePower: JKAMP.forcePowers_t, _ cmd: JKAMP.Usercmd) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Usercmd.scratch { ucmd in

        switch Int32(forcePower) {
        case FP_HEAL:
            if `self`.client!.ps.fd.forcePowerLevel[FP_HEAL] == FORCE_LEVEL_1 {
                if `self`.client!.ps.velocity[0] != 0 || `self`.client!.ps.velocity[1] != 0 || `self`.client!.ps.velocity[2] != 0 {
                    WP_ForcePowerStop(`self`, forcePower)
                    break
                }
            }

            if `self`.health < 1 || `self`.client!.ps.stats[STAT_HEALTH] < 1 {
                WP_ForcePowerStop(`self`, forcePower)
                break
            }

            if `self`.client!.ps.fd.forceHealTime > level.time {
                break
            }
            if `self`.health > `self`.client!.ps.stats[STAT_MAX_HEALTH] {
                //rww - we might start out over max_health and we don't want force heal taking us down to 100 or whatever max_health is
                WP_ForcePowerStop(`self`, forcePower)
                break
            }
            `self`.client!.ps.fd.forceHealTime = level.time + 1000
            `self`.health += 1
            `self`.client!.ps.fd.forceHealAmount += 1

            if `self`.health > `self`.client!.ps.stats[STAT_MAX_HEALTH] {
                `self`.health = `self`.client!.ps.stats[STAT_MAX_HEALTH]
                WP_ForcePowerStop(`self`, forcePower)
            }

            if (`self`.client!.ps.fd.forcePowerLevel[FP_HEAL] == FORCE_LEVEL_1 && `self`.client!.ps.fd.forceHealAmount >= 25) || (`self`.client!.ps.fd.forcePowerLevel[FP_HEAL] == FORCE_LEVEL_2 && `self`.client!.ps.fd.forceHealAmount >= 33) {
                WP_ForcePowerStop(`self`, forcePower)
            }

        case FP_SPEED:
            //This is handled in PM_WalkMove and PM_StepSlideMove
            if `self`.client!.holdingObjectiveItem >= MAX_CLIENTS && `self`.client!.holdingObjectiveItem < ENTITYNUM_WORLD {
                if g_entities[`self`.client!.holdingObjectiveItem].genericValue15 != 0 {
                    //disables force powers
                    WP_ForcePowerStop(`self`, forcePower)
                }
            }

        case FP_GRIP:
            if `self`.client!.ps.forceHandExtend != HANDEXTEND_FORCE_HOLD {
                WP_ForcePowerStop(`self`, FP_GRIP)
                break
            }

            if `self`.client!.ps.fd.forcePowerDebounce[FP_PULL] < level.time {
                //This is sort of not ideal. Using the debounce value reserved for pull for this because pull doesn't need it.
                BG_ForcePowerDrain(`self`.client!.ps, forcePower, 1)
                `self`.client!.ps.fd.forcePowerDebounce[FP_PULL] = level.time + 100
            }

            if `self`.client!.ps.fd.forcePower < 1 {
                WP_ForcePowerStop(`self`, FP_GRIP)
                break
            }

            DoGripAction(`self`, forcePower)

        case FP_LEVITATION:
            if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE && `self`.client!.ps.fd.forceJumpZStart == 0 {
                //done with jump
                WP_ForcePowerStop(`self`, forcePower)
            }

        case FP_RAGE:
            if `self`.health < 1 {
                WP_ForcePowerStop(`self`, forcePower)
                break
            }
            if `self`.client!.ps.forceRageDrainTime < level.time {
                var addTime: Int32 = 400

                `self`.health -= 2

                if `self`.client!.ps.fd.forcePowerLevel[FP_RAGE] == FORCE_LEVEL_1 {
                    addTime = 150
                } else if `self`.client!.ps.fd.forcePowerLevel[FP_RAGE] == FORCE_LEVEL_2 {
                    addTime = 300
                } else if `self`.client!.ps.fd.forcePowerLevel[FP_RAGE] == FORCE_LEVEL_3 {
                    addTime = 450
                }
                `self`.client!.ps.forceRageDrainTime = level.time + addTime
            }

            if `self`.health < 1 {
                `self`.health = 1
                WP_ForcePowerStop(`self`, forcePower)
            }

            `self`.client!.ps.stats[STAT_HEALTH] = `self`.health

        case FP_DRAIN:
            if `self`.client!.ps.forceHandExtend != HANDEXTEND_FORCE_HOLD {
                WP_ForcePowerStop(`self`, forcePower)
                break
            }

            if `self`.client!.ps.fd.forcePowerLevel[FP_DRAIN] > FORCE_LEVEL_1 {
                //higher than level 1
                if (cmd.buttons & BUTTON_FORCE_DRAIN) != 0 || ((cmd.buttons & BUTTON_FORCEPOWER) != 0 && `self`.client!.ps.fd.forcePowerSelected == FP_DRAIN) {
                    //holding it keeps it going
                    `self`.client!.ps.fd.forcePowerDuration[FP_DRAIN] = level.time + 500
                }
            }
            // OVERRIDEFIXME
            if !WP_ForcePowerAvailable(`self`, forcePower, 0) || `self`.client!.ps.fd.forcePowerDuration[FP_DRAIN] < level.time || `self`.client!.ps.fd.forcePower < 25 {
                WP_ForcePowerStop(`self`, forcePower)
            } else {
                ForceShootDrain(`self`)
            }

        case FP_LIGHTNING:
            if `self`.client!.ps.forceHandExtend != HANDEXTEND_FORCE_HOLD {
                //Animation for hand extend doesn't end with hand out, so we have to limit lightning intervals by animation intervals (once hand starts to go in in animation, lightning should stop)
                WP_ForcePowerStop(`self`, forcePower)
                break
            }

            if `self`.client!.ps.fd.forcePowerLevel[FP_LIGHTNING] > FORCE_LEVEL_1 {
                //higher than level 1
                if (cmd.buttons & BUTTON_FORCE_LIGHTNING) != 0 || ((cmd.buttons & BUTTON_FORCEPOWER) != 0 && `self`.client!.ps.fd.forcePowerSelected == FP_LIGHTNING) {
                    //holding it keeps it going
                    `self`.client!.ps.fd.forcePowerDuration[FP_LIGHTNING] = level.time + 500
                }
            }
            // OVERRIDEFIXME
            if !WP_ForcePowerAvailable(`self`, forcePower, 0) || `self`.client!.ps.fd.forcePowerDuration[FP_LIGHTNING] < level.time || `self`.client!.ps.fd.forcePower < 25 {
                WP_ForcePowerStop(`self`, forcePower)
            } else {
                ForceShootLightning(`self`)
                BG_ForcePowerDrain(`self`.client!.ps, forcePower, 0)
            }

        case FP_TELEPATHY:
            if `self`.client!.holdingObjectiveItem >= MAX_CLIENTS && `self`.client!.holdingObjectiveItem < ENTITYNUM_WORLD && g_entities[`self`.client!.holdingObjectiveItem].genericValue15 != 0 {
                //if force hindered can't mindtrick whilst carrying a siege item
                WP_ForcePowerStop(`self`, FP_TELEPATHY)
            } else {
                WP_UpdateMindtrickEnts(`self`)
            }

        case FP_SABER_OFFENSE:
            break

        case FP_SABER_DEFENSE:
            break

        case FP_SABERTHROW:
            break

        case FP_PROTECT:
            if `self`.client!.ps.fd.forcePowerDebounce[forcePower] < level.time {
                BG_ForcePowerDrain(`self`.client!.ps, forcePower, 1)
                if `self`.client!.ps.fd.forcePower < 1 {
                    WP_ForcePowerStop(`self`, forcePower)
                }

                `self`.client!.ps.fd.forcePowerDebounce[forcePower] = level.time + 300
            }

        case FP_ABSORB:
            if `self`.client!.ps.fd.forcePowerDebounce[forcePower] < level.time {
                BG_ForcePowerDrain(`self`.client!.ps, forcePower, 1)
                if `self`.client!.ps.fd.forcePower < 1 {
                    WP_ForcePowerStop(`self`, forcePower)
                }

                `self`.client!.ps.fd.forcePowerDebounce[forcePower] = level.time + 600
            }

        default:
            break
        }
    }
}

/// Source: oracle/codemp/game/w_force.c:4508
func WP_DoSpecificPower(_ `self`: Entity, _ ucmd: JKAMP.Usercmd, _ forcepower: JKAMP.forcePowers_t) -> Int32 {
    var powerSucceeded: Int32

    powerSucceeded = 1

    // OVERRIDEFIXME
    if !WP_ForcePowerAvailable(`self`, forcepower, 0) {
        return 0
    }

    switch forcepower {
    case FP_HEAL:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceHeal(`self`)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_LEVITATION:
        //if leave the ground by some other means, cancel the force jump so we don't suddenly jump when we land.

        if `self`.client!.ps.groundEntityNum == ENTITYNUM_NONE {
            `self`.client!.ps.fd.forceJumpCharge = 0
            G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_1 - 50], CHAN_VOICE)
            //This only happens if the groundEntityNum == ENTITYNUM_NONE when the button is actually released
        } else {
            //still on ground, so jump
            ForceJump(`self`, ucmd)
        }

    case FP_SPEED:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceSpeed(`self`, 0)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_GRIP:
        if `self`.client!.ps.fd.forceGripEntityNum == ENTITYNUM_NONE {
            ForceGrip(`self`)
        }

        if `self`.client!.ps.fd.forceGripEntityNum != ENTITYNUM_NONE {
            if !((`self`.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0) {
                WP_ForcePowerStart(`self`, FP_GRIP, 0)
                BG_ForcePowerDrain(`self`.client!.ps, FP_GRIP, GRIP_DRAIN_AMOUNT)
            }
        } else {
            powerSucceeded = 0
        }

    case FP_LIGHTNING:
        ForceLightning(`self`)

    case FP_PUSH:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 && !((`self`.r.svFlags & SVF_BOT) != 0) {
            //need to release before we can use nonhold powers again
            break
        }
        ForceThrow(`self`, false)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_PULL:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceThrow(`self`, true)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_TELEPATHY:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceTelepathy(`self`)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_RAGE:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceRage(`self`)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_PROTECT:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceProtect(`self`)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_ABSORB:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceAbsorb(`self`)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_TEAM_HEAL:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceTeamHeal(`self`)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_TEAM_FORCE:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceTeamForceReplenish(`self`)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_DRAIN:
        ForceDrain(`self`)

    case FP_SEE:
        powerSucceeded = 0 //always 0 for nonhold powers
        if `self`.client!.ps.fd.forceButtonNeedRelease != 0 {
            //need to release before we can use nonhold powers again
            break
        }
        ForceSeeing(`self`)
        `self`.client!.ps.fd.forceButtonNeedRelease = 1

    case FP_SABER_OFFENSE:
        break

    case FP_SABER_DEFENSE:
        break

    case FP_SABERTHROW:
        break

    default:
        break
    }

    return powerSucceeded
}

/// Source: oracle/codemp/game/w_force.c:4673
func FindGenericEnemyIndex(_ `self`: Entity) {
    //Find another client that would be considered a threat.
    var i: Int32 = 0
    var tlen: Float
    var ent: Entity?
    var besten: Entity? = nil
    var blen: Float = 99999999
    var a = vec3_t()

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && ent!.s.number != `self`.s.number && ent!.health > 0 && !OnSameTeam(`self`, ent!) && ent!.client!.ps.pm_type != PM_INTERMISSION && ent!.client!.ps.pm_type != PM_SPECTATOR {
            a = ent!.client!.ps.origin - `self`.client!.ps.origin
            tlen = VectorLength(a)

            if tlen < blen && InFront(ent!.client!.ps.origin, `self`.client!.ps.origin, `self`.client!.ps.viewangles, 0.8) && OrgVisible(`self`.client!.ps.origin, ent!.client!.ps.origin, `self`.s.number) != 0 {
                blen = tlen
                besten = ent
            }
        }

        i += 1
    }

    if besten == nil {
        return
    }

    `self`.client!.ps.genericEnemyIndex = besten!.s.number
}

/// Source: oracle/codemp/game/w_force.c:4711
func SeekerDroneUpdate(_ `self`: Entity) {
    var org = vec3_t()
    var elevated = vec3_t()
    var dir = vec3_t()
    var a = vec3_t()
    var endir = vec3_t()
    var en: Entity?
    var angle: Float = 0
    var prefig: Float = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        if !((`self`.client!.ps.eFlags & EF_SEEKERDRONE) != 0) {
            `self`.client!.ps.genericEnemyIndex = -1
            return true
        }

        if `self`.health < 1 {
            elevated = `self`.client!.ps.origin
            elevated[2] += 40

            angle = Float(Double((level.time / 12) & 255) * (M_PI * 2) / 255) //magical numbers make magic happen
            dir[0] = cos(angle) * 20
            dir[1] = sin(angle) * 20
            dir[2] = cos(angle) * 5
            org = elevated + dir

            a[ROLL] = 0
            a[YAW] = 0
            a[PITCH] = 1

            G_PlayEffect(EFFECT_SPARK_EXPLOSION, org, a)

            `self`.client!.ps.eFlags -= EF_SEEKERDRONE
            `self`.client!.ps.genericEnemyIndex = -1

            return true
        }

        if `self`.client!.ps.droneExistTime >= level.time && `self`.client!.ps.droneExistTime < (level.time + 5000) {
            `self`.client!.ps.genericEnemyIndex = Int32(1024 + `self`.client!.ps.droneExistTime)
            if `self`.client!.ps.droneFireTime < level.time {
                G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/laser_trap/warning.wav"))
                `self`.client!.ps.droneFireTime = Float(level.time + 100)
            }
            return true
        } else if `self`.client!.ps.droneExistTime < level.time {
            elevated = `self`.client!.ps.origin
            elevated[2] += 40

            prefig = (`self`.client!.ps.droneExistTime - level.time) / 80

            if prefig > 55 {
                prefig = 55
            } else if prefig < 1 {
                prefig = 1
            }

            elevated[2] -= 55 - prefig

            angle = Float(Double((level.time / 12) & 255) * (M_PI * 2) / 255) //magical numbers make magic happen
            dir[0] = cos(angle) * 20
            dir[1] = sin(angle) * 20
            dir[2] = cos(angle) * 5
            org = elevated + dir

            a[ROLL] = 0
            a[YAW] = 0
            a[PITCH] = 1

            G_PlayEffect(EFFECT_SPARK_EXPLOSION, org, a)

            `self`.client!.ps.eFlags -= EF_SEEKERDRONE
            `self`.client!.ps.genericEnemyIndex = -1

            return true
        }

        if `self`.client!.ps.genericEnemyIndex == -1 {
            `self`.client!.ps.genericEnemyIndex = ENTITYNUM_NONE
        }

        if `self`.client!.ps.genericEnemyIndex != ENTITYNUM_NONE && `self`.client!.ps.genericEnemyIndex != -1 {
            en = g_entities[`self`.client!.ps.genericEnemyIndex]

            if en == nil || en!.client == nil {
                `self`.client!.ps.genericEnemyIndex = ENTITYNUM_NONE
            } else if en!.s.number == `self`.s.number {
                `self`.client!.ps.genericEnemyIndex = ENTITYNUM_NONE
            } else if en!.health < 1 {
                `self`.client!.ps.genericEnemyIndex = ENTITYNUM_NONE
            } else if OnSameTeam(`self`, en!) {
                `self`.client!.ps.genericEnemyIndex = ENTITYNUM_NONE
            } else {
                if !InFront(en!.client!.ps.origin, `self`.client!.ps.origin, `self`.client!.ps.viewangles, 0.8) {
                    `self`.client!.ps.genericEnemyIndex = ENTITYNUM_NONE
                } else if OrgVisible(`self`.client!.ps.origin, en!.client!.ps.origin, `self`.s.number) == 0 {
                    `self`.client!.ps.genericEnemyIndex = ENTITYNUM_NONE
                }
            }
        }

        if `self`.client!.ps.genericEnemyIndex == ENTITYNUM_NONE || `self`.client!.ps.genericEnemyIndex == -1 {
            FindGenericEnemyIndex(`self`)
        }

        if `self`.client!.ps.genericEnemyIndex != ENTITYNUM_NONE && `self`.client!.ps.genericEnemyIndex != -1 {
            en = g_entities[`self`.client!.ps.genericEnemyIndex]

            elevated = `self`.client!.ps.origin
            elevated[2] += 40

            angle = Float(Double((level.time / 12) & 255) * (M_PI * 2) / 255) //magical numbers make magic happen
            dir[0] = cos(angle) * 20
            dir[1] = sin(angle) * 20
            dir[2] = cos(angle) * 5
            org = elevated + dir

            //org is now where the thing should be client-side because it uses the same time-based offset
            if `self`.client!.ps.droneFireTime < level.time {
                // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                portMissing("SeekerDroneUpdate", source: "oracle/codemp/game/w_force.c:4711")
                // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                portMissing("SeekerDroneUpdate", source: "oracle/codemp/game/w_force.c:4711")
                trap_Trace(tr, org, vec3_origin, vec3_origin, en!.client!.ps.origin, -1, MASK_SOLID)

                if tr.fraction == 1 && tr.startsolid == 0 && tr.allsolid == 0 {
                    endir = en!.client!.ps.origin - org
                    VectorNormalize(&endir)

                    WP_FireGenericBlasterMissile(`self`, &org, endir, 0 != 0, 15, 2000, MOD_BLASTER)
                    G_SoundAtLoc(org, CHAN_WEAPON, G_SoundIndex("sound/weapons/bryar/fire.wav"))

                    `self`.client!.ps.droneFireTime = Float(level.time + Q_irand(400, 700))
                }
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_force.c:4870
func HolocronUpdate(_ `self`: Entity) {
    //keep holocron status updated in holocron mode
    var i: Int32 = 0
    var noHRank: Int32 = 0

    if noHRank < FORCE_LEVEL_0 {
        noHRank = FORCE_LEVEL_0
    }
    if noHRank > FORCE_LEVEL_3 {
        noHRank = FORCE_LEVEL_3
    }

    trap_Cvar_Update(g_MaxHolocronCarry)

    while i < NUM_FORCE_POWERS {
        if `self`.client!.ps.holocronsCarried[i] != 0 {
            //carrying it, make sure we have the power
            `self`.client!.ps.holocronBits |= (1 << i)
            `self`.client!.ps.fd.forcePowersKnown |= (1 << i)
            `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_3
        } else {
            //otherwise, make sure the power is cleared from us
            `self`.client!.ps.fd.forcePowerLevel[i] = 0
            if (`self`.client!.ps.holocronBits & (1 << i)) != 0 {
                `self`.client!.ps.holocronBits -= (1 << i)
            }

            if (`self`.client!.ps.fd.forcePowersKnown & (1 << i)) != 0 && i != FP_LEVITATION && i != FP_SABER_OFFENSE {
                `self`.client!.ps.fd.forcePowersKnown -= (1 << i)
            }

            if (`self`.client!.ps.fd.forcePowersActive & (1 << i)) != 0 && i != FP_LEVITATION && i != FP_SABER_OFFENSE {
                WP_ForcePowerStop(`self`, i)
            }

            if i == FP_LEVITATION {
                if noHRank >= FORCE_LEVEL_1 {
                    `self`.client!.ps.fd.forcePowerLevel[i] = noHRank
                } else {
                    `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_1
                }
            } else if i == FP_SABER_OFFENSE {
                `self`.client!.ps.fd.forcePowersKnown |= (1 << i)

                if noHRank >= FORCE_LEVEL_1 {
                    `self`.client!.ps.fd.forcePowerLevel[i] = noHRank
                } else {
                    `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_1
                }
            } else {
                `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_0
            }
        }

        i += 1
    }

    if HasSetSaberOnly() {
        //if saberonly, we get these powers no matter what (still need the holocrons for level 3)
        if `self`.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] < FORCE_LEVEL_1 {
            `self`.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] = FORCE_LEVEL_1
        }
        if `self`.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] < FORCE_LEVEL_1 {
            `self`.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] = FORCE_LEVEL_1
        }
    }
}

/// Source: oracle/codemp/game/w_force.c:4958
func JediMasterUpdate(_ `self`: Entity) {
    //keep jedi master status updated for JM gametype
    var i: Int32 = 0

    trap_Cvar_Update(g_MaxHolocronCarry)

    while i < NUM_FORCE_POWERS {
        if `self`.client!.ps.isJediMaster {
            `self`.client!.ps.fd.forcePowersKnown |= (1 << i)
            `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_3

            if i == FP_TEAM_HEAL || i == FP_TEAM_FORCE || i == FP_DRAIN || i == FP_ABSORB {
                //team powers are useless in JM, absorb is too because no one else has powers to absorb. Drain is just
                //relatively useless in comparison, because its main intent is not to heal, but rather to cripple others
                //by draining their force at the same time. And no one needs force in JM except the JM himself.
                `self`.client!.ps.fd.forcePowersKnown &= ~(1 << i)
                `self`.client!.ps.fd.forcePowerLevel[i] = 0
            }

            if i == FP_TELEPATHY {
                //this decision was made because level 3 mindtrick allows the JM to just hide too much, and no one else has force
                //sight to counteract it. Since the JM himself is the focus of gameplay in this mode, having him hidden for large
                //durations is indeed a bad thing.
                `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_2
            }
        } else {
            if (`self`.client!.ps.fd.forcePowersKnown & (1 << i)) != 0 && i != FP_LEVITATION {
                `self`.client!.ps.fd.forcePowersKnown -= (1 << i)
            }

            if (`self`.client!.ps.fd.forcePowersActive & (1 << i)) != 0 && i != FP_LEVITATION {
                WP_ForcePowerStop(`self`, i)
            }

            if i == FP_LEVITATION {
                `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_1
            } else {
                `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_0
            }
        }

        i += 1
    }
}

/// Source: oracle/codemp/game/w_force.c:5013
func WP_HasForcePowers(_ ps: JKAMP.PlayerState) -> Bool {
    var i: Int32
    i = 0
    while i < NUM_FORCE_POWERS {
        if i == FP_LEVITATION {
            if ps.fd.forcePowerLevel[i] > FORCE_LEVEL_1 {
                return true
            }
        } else if ps.fd.forcePowerLevel[i] > FORCE_LEVEL_0 {
            return true
        }
        i += 1
    }
    return false
}

//try a special roll getup move
/// Source: oracle/codemp/game/w_force.c:5037
func G_SpecialRollGetup(_ `self`: Entity) -> Bool {
    //fixme: currently no knockdown will actually land you on your front... so froll's are pretty useless at the moment.
    var rolled: Bool = false

    /*
    if (self->client->ps.weapon != WP_SABER &&
    self->client->ps.weapon != WP_MELEE)
    { //can't do acrobatics without saber selected
    return qfalse;
    }
    */

    if `self`.client!.pers.cmd.rightmove > 0 && `self`.client!.pers.cmd.forwardmove == 0 {
        G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, BOTH_GETUP_BROLL_R, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
        rolled = true
    } else if `self`.client!.pers.cmd.rightmove < 0 && `self`.client!.pers.cmd.forwardmove == 0 {
        G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, BOTH_GETUP_BROLL_L, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
        rolled = true
    } else if `self`.client!.pers.cmd.rightmove == 0 && `self`.client!.pers.cmd.forwardmove > 0 {
        G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, BOTH_GETUP_BROLL_F, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
        rolled = true
    } else if `self`.client!.pers.cmd.rightmove == 0 && `self`.client!.pers.cmd.forwardmove < 0 {
        G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, BOTH_GETUP_BROLL_B, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
        rolled = true
    } else if `self`.client!.pers.cmd.upmove != 0 {
        G_PreDefSound(`self`.client!.ps.origin, PDSOUND_FORCEJUMP)
        `self`.client!.ps.forceDodgeAnim = 2
        `self`.client!.ps.forceHandExtendTime = level.time + 500

        //self->client->ps.velocity[2] = 300;
    }

    if rolled {
        G_EntitySound(`self`, CHAN_VOICE, G_SoundIndex("*jump1.wav"))
    }

    return rolled
}

/// Source: oracle/codemp/game/w_force.c:5094
func WP_ForcePowersUpdate(_ `self`: Entity, _ ucmd: JKAMP.Usercmd) {
    var usingForce: Bool = false
    var i: Int32
    var holo: Int32
    var holoregen: Int32
    var prepower: Int32 = 0
    //see if any force powers are running
    powersetcheck: do {

        if `self`.client == nil {
            return
        }

        if (`self`.client!.ps.pm_flags & PMF_FOLLOW) != 0 {
            //not a "real" game client, it's a spectator following someone
            return
        }
        if `self`.client!.sess.sessionTeam == TEAM_SPECTATOR {
            return
        }

        /*
        if (self->client->ps.fd.saberAnimLevel > self->client->ps.fd.forcePowerLevel[FP_SABER_OFFENSE])
        {
        self->client->ps.fd.saberAnimLevel = self->client->ps.fd.forcePowerLevel[FP_SABER_OFFENSE];
        }
        else if (!self->client->ps.fd.saberAnimLevel)
        {
        self->client->ps.fd.saberAnimLevel = FORCE_LEVEL_1;
        }
        */
        //The stance in relation to power level is no longer applicable with the crazy new akimbo/staff stances.
        if `self`.client!.ps.fd.saberAnimLevel == 0 {
            `self`.client!.ps.fd.saberAnimLevel = FORCE_LEVEL_1
        }

        if g_gametype.integer != GT_SIEGE {
            if !((`self`.client!.ps.fd.forcePowersKnown & (1 << FP_LEVITATION)) != 0) {
                `self`.client!.ps.fd.forcePowersKnown |= (1 << FP_LEVITATION)
            }

            if `self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION] < FORCE_LEVEL_1 {
                `self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION] = FORCE_LEVEL_1
            }
        }

        if `self`.client!.ps.fd.forcePowerSelected < 0 {
            //bad
            `self`.client!.ps.fd.forcePowerSelected = 0
        }

        if ((`self`.client!.sess.selectedFP != `self`.client!.ps.fd.forcePowerSelected) || (`self`.client!.sess.saberLevel != `self`.client!.ps.fd.saberAnimLevel)) && !((`self`.r.svFlags & SVF_BOT) != 0) {
            if `self`.client!.sess.updateUITime < level.time {
                //a bit hackish, but we don't want the client to flood with userinfo updates if they rapidly cycle
                //through their force powers or saber attack levels

                `self`.client!.sess.selectedFP = `self`.client!.ps.fd.forcePowerSelected
                `self`.client!.sess.saberLevel = `self`.client!.ps.fd.saberAnimLevel
            }
        }

        if g_LastFrameTime == 0 {
            g_LastFrameTime = level.time
        }

        if `self`.client!.ps.forceHandExtend == HANDEXTEND_KNOCKDOWN {
            `self`.client!.ps.zoomFov = 0
            `self`.client!.ps.zoomMode = 0
            `self`.client!.ps.zoomLocked = false
            `self`.client!.ps.zoomTime = 0
        }

        if `self`.client!.ps.forceHandExtend == HANDEXTEND_KNOCKDOWN && `self`.client!.ps.forceHandExtendTime >= level.time {
            `self`.client!.ps.saberMove = 0
            `self`.client!.ps.saberBlocking = 0
            `self`.client!.ps.saberBlocked = 0
            `self`.client!.ps.weaponTime = 0
            `self`.client!.ps.weaponstate = WEAPON_READY
        } else if `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE && `self`.client!.ps.forceHandExtendTime < level.time {
            if `self`.client!.ps.forceHandExtend == HANDEXTEND_KNOCKDOWN && `self`.client!.ps.forceDodgeAnim == 0 {
                if `self`.health < 1 || (`self`.client!.ps.eFlags & EF_DEAD) != 0 {
                    `self`.client!.ps.forceHandExtend = HANDEXTEND_NONE
                } else if G_SpecialRollGetup(`self`) {
                    `self`.client!.ps.forceHandExtend = HANDEXTEND_NONE
                } else {
                    //hmm.. ok.. no more getting up on your own, you've gotta push something, unless..
                    if (level.time - `self`.client!.ps.forceHandExtendTime) > 4000 {
                        //4 seconds elapsed, I guess they're too dumb to push something to get up!
                        if `self`.client!.pers.cmd.upmove != 0 && `self`.client!.ps.fd.forcePowerLevel[FP_LEVITATION] > FORCE_LEVEL_1 {
                            //force getup
                            G_PreDefSound(`self`.client!.ps.origin, PDSOUND_FORCEJUMP)
                            `self`.client!.ps.forceDodgeAnim = 2
                            `self`.client!.ps.forceHandExtendTime = level.time + 500

                            //self->client->ps.velocity[2] = 400;
                        } else if `self`.client!.ps.quickerGetup {
                            G_EntitySound(`self`, CHAN_VOICE, G_SoundIndex("*jump1.wav"))
                            `self`.client!.ps.forceDodgeAnim = 3
                            `self`.client!.ps.forceHandExtendTime = level.time + 500
                            `self`.client!.ps.velocity[2] = 300
                        } else {
                            `self`.client!.ps.forceDodgeAnim = 1
                            `self`.client!.ps.forceHandExtendTime = level.time + 1000
                        }
                    }
                }
                `self`.client!.ps.quickerGetup = false
            } else if `self`.client!.ps.forceHandExtend == HANDEXTEND_POSTTHROWN {
                if `self`.health < 1 || (`self`.client!.ps.eFlags & EF_DEAD) != 0 {
                    `self`.client!.ps.forceHandExtend = HANDEXTEND_NONE
                } else if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE && `self`.client!.ps.forceDodgeAnim == 0 {
                    `self`.client!.ps.forceDodgeAnim = 1
                    `self`.client!.ps.forceHandExtendTime = level.time + 1000
                    G_EntitySound(`self`, CHAN_VOICE, G_SoundIndex("*jump1.wav"))
                    `self`.client!.ps.velocity[2] = 100
                } else if `self`.client!.ps.forceDodgeAnim == 0 {
                    `self`.client!.ps.forceHandExtendTime = level.time + 100
                } else {
                    `self`.client!.ps.forceHandExtend = HANDEXTEND_WEAPONREADY
                }
            } else {
                `self`.client!.ps.forceHandExtend = HANDEXTEND_WEAPONREADY
            }
        }

        if g_gametype.integer == GT_HOLOCRON {
            HolocronUpdate(`self`)
        }
        if g_gametype.integer == GT_JEDIMASTER {
            JediMasterUpdate(`self`)
        }

        SeekerDroneUpdate(`self`)

        if `self`.client!.ps.powerups[PW_FORCE_BOON] != 0 {
            prepower = `self`.client!.ps.fd.forcePower
        }

        if `self`.client != nil && (BG_HasYsalamiri(g_gametype.integer, `self`.client!.ps) || `self`.client!.ps.fd.forceDeactivateAll != 0 || `self`.client!.tempSpectate >= level.time) {
            //has ysalamiri.. or we want to forcefully stop all his active powers
            i = 0

            while i < NUM_FORCE_POWERS {
                if (`self`.client!.ps.fd.forcePowersActive & (1 << i)) != 0 && i != FP_LEVITATION {
                    WP_ForcePowerStop(`self`, i)
                }

                i += 1
            }

            if `self`.client!.tempSpectate >= level.time {
                `self`.client!.ps.fd.forcePower = 100
                `self`.client!.ps.fd.forceRageRecoveryTime = 0
            }

            `self`.client!.ps.fd.forceDeactivateAll = 0

            if `self`.client!.ps.fd.forceJumpCharge != 0 {
                G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_1 - 50], CHAN_VOICE)
                `self`.client!.ps.fd.forceJumpCharge = 0
            }
        } else {
            //otherwise just do a check through them all to see if they need to be stopped for any reason.
            i = 0

            while i < NUM_FORCE_POWERS {
                if (`self`.client!.ps.fd.forcePowersActive & (1 << i)) != 0 && i != FP_LEVITATION && !BG_CanUseFPNow(g_gametype.integer, `self`.client!.ps, level.time, i) {
                    WP_ForcePowerStop(`self`, i)
                }

                i += 1
            }
        }

        i = 0

        if `self`.client!.ps.powerups[PW_FORCE_ENLIGHTENED_LIGHT] != 0 || `self`.client!.ps.powerups[PW_FORCE_ENLIGHTENED_DARK] != 0 {
            //enlightenment
            if `self`.client!.ps.fd.forceUsingAdded == 0 {
                i = 0

                while i < NUM_FORCE_POWERS {
                    `self`.client!.ps.fd.forcePowerBaseLevel[i] = `self`.client!.ps.fd.forcePowerLevel[i]

                    if forcePowerDarkLight[i] == 0 || `self`.client!.ps.fd.forceSide == forcePowerDarkLight[i] {
                        `self`.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_3
                        `self`.client!.ps.fd.forcePowersKnown |= (1 << i)
                    }

                    i += 1
                }

                `self`.client!.ps.fd.forceUsingAdded = 1
            }
        } else if `self`.client!.ps.fd.forceUsingAdded != 0 {
            //we don't have enlightenment but we're still using enlightened powers, so clear them back to how they should be.
            i = 0

            while i < NUM_FORCE_POWERS {
                `self`.client!.ps.fd.forcePowerLevel[i] = `self`.client!.ps.fd.forcePowerBaseLevel[i]
                if `self`.client!.ps.fd.forcePowerLevel[i] == 0 {
                    if (`self`.client!.ps.fd.forcePowersActive & (1 << i)) != 0 {
                        WP_ForcePowerStop(`self`, i)
                    }
                    `self`.client!.ps.fd.forcePowersKnown &= ~(1 << i)
                }

                i += 1
            }

            `self`.client!.ps.fd.forceUsingAdded = 0
        }

        i = 0

        if !((`self`.client!.ps.fd.forcePowersActive & (1 << FP_TELEPATHY)) != 0) {
            //clear the mindtrick index values
            `self`.client!.ps.fd.forceMindtrickTargetIndex = 0
            `self`.client!.ps.fd.forceMindtrickTargetIndex2 = 0
            `self`.client!.ps.fd.forceMindtrickTargetIndex3 = 0
            `self`.client!.ps.fd.forceMindtrickTargetIndex4 = 0
        }

        if `self`.health < 1 {
            `self`.client!.ps.fd.forceGripBeingGripped = 0
        }

        if `self`.client!.ps.fd.forceGripBeingGripped > level.time {
            `self`.client!.ps.fd.forceGripCripple = 1

            //keep the saber off during this period
            if `self`.client!.ps.weapon == WP_SABER && `self`.client!.ps.saberHolstered == 0 {
                Cmd_ToggleSaber_f(`self`)
            }
        } else {
            `self`.client!.ps.fd.forceGripCripple = 0
        }

        if `self`.client!.ps.fd.forceJumpSound != 0 {
            G_PreDefSound(`self`.client!.ps.origin, PDSOUND_FORCEJUMP)
            `self`.client!.ps.fd.forceJumpSound = 0
        }

        if `self`.client!.ps.fd.forceGripCripple != 0 {
            if `self`.client!.ps.fd.forceGripSoundTime < level.time {
                G_PreDefSound(`self`.client!.ps.origin, PDSOUND_FORCEGRIP)
                `self`.client!.ps.fd.forceGripSoundTime = Float(level.time + 1000)
            }
        }

        if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
            `self`.client!.ps.powerups[PW_SPEED] = level.time + 100
        }

        if `self`.health <= 0 {
            //if dead, deactivate any active force powers
            i = 0
            while i < NUM_FORCE_POWERS {
                if `self`.client!.ps.fd.forcePowerDuration[i] != 0 || (`self`.client!.ps.fd.forcePowersActive & (1 << i)) != 0 {
                    WP_ForcePowerStop(`self`, forcePowers_t(i))
                    `self`.client!.ps.fd.forcePowerDuration[i] = 0
                }
                i += 1
            }
            break powersetcheck
        }

        if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE {
            `self`.client!.fjDidJump = false
        }

        if `self`.client!.ps.fd.forceJumpCharge != 0 && `self`.client!.ps.groundEntityNum == ENTITYNUM_NONE && `self`.client!.fjDidJump {
            //this was for the "charge" jump method... I guess
            if ucmd.upmove < 10 && (!((ucmd.buttons & BUTTON_FORCEPOWER) != 0) || `self`.client!.ps.fd.forcePowerSelected != FP_LEVITATION) {
                G_MuteSound(`self`.client!.ps.fd.killSoundEntIndex[TRACK_CHANNEL_1 - 50], CHAN_VOICE)
                `self`.client!.ps.fd.forceJumpCharge = 0
            }
        }


        if !((`self`.client!.ps.pm_flags & PMF_JUMP_HELD) != 0) && `self`.client!.ps.fd.forceJumpCharge != 0 {
            if !((ucmd.buttons & BUTTON_FORCEPOWER) != 0) || `self`.client!.ps.fd.forcePowerSelected != FP_LEVITATION {
                if WP_DoSpecificPower(`self`, ucmd, FP_LEVITATION) != 0 {
                    usingForce = true
                }
            }
        }

        if (ucmd.buttons & BUTTON_FORCEGRIP) != 0 {
            //grip is one of the powers with its own button.. if it's held, call the specific grip power function.
            if WP_DoSpecificPower(`self`, ucmd, FP_GRIP) != 0 {
                usingForce = true
            } else {
                //don't let recharge even if the grip misses if the player still has the button down
                usingForce = true
            }
        } else {
            //see if we're using it generically.. if not, stop.
            if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 {
                if !((ucmd.buttons & BUTTON_FORCEPOWER) != 0) || `self`.client!.ps.fd.forcePowerSelected != FP_GRIP {
                    WP_ForcePowerStop(`self`, FP_GRIP)
                }
            }
        }

        if (ucmd.buttons & BUTTON_FORCE_LIGHTNING) != 0 {
            //lightning
            WP_DoSpecificPower(`self`, ucmd, FP_LIGHTNING)
            usingForce = true
        } else {
            //see if we're using it generically.. if not, stop.
            if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_LIGHTNING)) != 0 {
                if !((ucmd.buttons & BUTTON_FORCEPOWER) != 0) || `self`.client!.ps.fd.forcePowerSelected != FP_LIGHTNING {
                    WP_ForcePowerStop(`self`, FP_LIGHTNING)
                }
            }
        }

        if (ucmd.buttons & BUTTON_FORCE_DRAIN) != 0 {
            //drain
            WP_DoSpecificPower(`self`, ucmd, FP_DRAIN)
            usingForce = true
        } else {
            //see if we're using it generically.. if not, stop.
            if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_DRAIN)) != 0 {
                if !((ucmd.buttons & BUTTON_FORCEPOWER) != 0) || `self`.client!.ps.fd.forcePowerSelected != FP_DRAIN {
                    WP_ForcePowerStop(`self`, FP_DRAIN)
                }
            }
        }

        if (ucmd.buttons & BUTTON_FORCEPOWER) != 0 && BG_CanUseFPNow(g_gametype.integer, `self`.client!.ps, level.time, `self`.client!.ps.fd.forcePowerSelected) {
            if `self`.client!.ps.fd.forcePowerSelected == FP_LEVITATION {
                ForceJumpCharge(`self`, ucmd)
                usingForce = true
            } else if WP_DoSpecificPower(`self`, ucmd, `self`.client!.ps.fd.forcePowerSelected) != 0 {
                usingForce = true
            } else if `self`.client!.ps.fd.forcePowerSelected == FP_GRIP {
                usingForce = true
            }
        } else {
            `self`.client!.ps.fd.forceButtonNeedRelease = 0
        }

        i = 0
        while i < NUM_FORCE_POWERS {
            if `self`.client!.ps.fd.forcePowerDuration[i] != 0 {
                if `self`.client!.ps.fd.forcePowerDuration[i] < level.time {
                    if (`self`.client!.ps.fd.forcePowersActive & (1 << i)) != 0 {
                        //turn it off
                        WP_ForcePowerStop(`self`, forcePowers_t(i))
                    }
                    `self`.client!.ps.fd.forcePowerDuration[i] = 0
                }
            }
            if (`self`.client!.ps.fd.forcePowersActive & (1 << i)) != 0 {
                usingForce = true
                WP_ForcePowerRun(`self`, forcePowers_t(i), ucmd)
            }
            i += 1
        }
        if `self`.client!.ps.saberInFlight && `self`.client!.ps.saberEntityNum != 0 {
            //don't regen force power while throwing saber
            if `self`.client!.ps.saberEntityNum < ENTITYNUM_NONE && `self`.client!.ps.saberEntityNum > 0 {
                //
                if g_entities[`self`.client!.ps.saberEntityNum] != nil && g_entities[`self`.client!.ps.saberEntityNum].s.pos.trType == TR_LINEAR {
                    //fell to the ground and we're trying to pull it back
                    usingForce = true
                }
            }
        }
        if `self`.client!.ps.fd.forcePowersActive == 0 || `self`.client!.ps.fd.forcePowersActive == (1 << FP_DRAIN) {
            //when not using the force, regenerate at 1 point per half second
            if !`self`.client!.ps.saberInFlight && `self`.client!.ps.fd.forcePowerRegenDebounceTime < level.time && (`self`.client!.ps.weapon != WP_SABER || !BG_SaberInSpecial(`self`.client!.ps.saberMove)) {
                if g_gametype.integer != GT_HOLOCRON || g_MaxHolocronCarry.value != 0 {
                    //if (!g_trueJedi.integer || self->client->ps.weapon == WP_SABER)
                    //let non-jedi force regen since we're doing a more strict jedi/non-jedi thing... this gives dark jedi something to drain
                    do {
                        if `self`.client!.ps.powerups[PW_FORCE_BOON] != 0 {
                            WP_ForcePowerRegenerate(`self`, 6)
                        } else if `self`.client!.ps.isJediMaster && g_gametype.integer == GT_JEDIMASTER {
                            WP_ForcePowerRegenerate(`self`, 4) //jedi master regenerates 4 times as fast
                        } else {
                            WP_ForcePowerRegenerate(`self`, 0)
                        }
                    }
                    /*
                    else if (g_trueJedi.integer && self->client->ps.weapon != WP_SABER)
                    {
                    self->client->ps.fd.forcePower = 0;
                    }
                    */
                } else {
                    //regenerate based on the number of holocrons carried
                    holoregen = 0
                    holo = 0
                    while holo < NUM_FORCE_POWERS {
                        if `self`.client!.ps.holocronsCarried[holo] != 0 {
                            holoregen += 1
                        }
                        holo += 1
                    }

                    WP_ForcePowerRegenerate(`self`, holoregen)
                }

                if g_gametype.integer == GT_SIEGE {
                    if `self`.client!.holdingObjectiveItem != 0 && g_entities[`self`.client!.holdingObjectiveItem].inuse && g_entities[`self`.client!.holdingObjectiveItem].genericValue15 != 0 {
                        //1 point per 7 seconds.. super slow
                        `self`.client!.ps.fd.forcePowerRegenDebounceTime = level.time + 7000
                    } else if `self`.client!.siegeClass != -1 && (bgSiegeClasses[`self`.client!.siegeClass].classflags & (1 << CFL_FASTFORCEREGEN)) != 0 {
                        //if this is siege and our player class has the fast force regen ability, then recharge with 1/5th the usual delay
                        `self`.client!.ps.fd.forcePowerRegenDebounceTime = Int32(Double(level.time) + (Double(g_forceRegenTime.integer) * 0.2))
                    } else {
                        `self`.client!.ps.fd.forcePowerRegenDebounceTime = level.time + g_forceRegenTime.integer
                    }
                } else {
                    if g_gametype.integer == GT_POWERDUEL && `self`.client!.sess.duelTeam == DUELTEAM_LONE {
                        if g_duel_fraglimit.integer != 0 {
                            `self`.client!.ps.fd.forcePowerRegenDebounceTime = Int32(Double(level.time) + (Double(g_forceRegenTime.integer) * (0.6 + (0.3 * Double(Float(`self`.client!.sess.wins)) / Double(Float(g_duel_fraglimit.integer))))))
                        } else {
                            `self`.client!.ps.fd.forcePowerRegenDebounceTime = Int32(Double(level.time) + (Double(g_forceRegenTime.integer) * 0.7))
                        }
                    } else {
                        `self`.client!.ps.fd.forcePowerRegenDebounceTime = level.time + g_forceRegenTime.integer
                    }
                }
            }
        }

    }

    if prepower != 0 && `self`.client!.ps.fd.forcePower < prepower {
        var dif: Int32 = ((prepower - `self`.client!.ps.fd.forcePower) / 2)
        if dif < 1 {
            dif = 1
        }

        `self`.client!.ps.fd.forcePower = (prepower - dif)
    }
}

/// Source: oracle/codemp/game/w_force.c:5673
func Jedi_DodgeEvasion(_ `self`: Entity, _ shooter: Entity, _ tr: JKAMP.Trace, _ hitLoc: Int32) -> Bool {
    var dodgeAnim: Int32 = -1

    if `self`.client == nil || `self`.health <= 0 {
        return false
    }

    if g_forceDodge.integer == 0 {
        return false
    }

    if g_forceDodge.integer != 2 {
        if !((`self`.client!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0) {
            return false
        }
    }

    if `self`.client!.ps.groundEntityNum == ENTITYNUM_NONE {
        //can't dodge in mid-air
        return false
    }

    if `self`.client!.ps.weaponTime > 0 || `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        //in some effect that stops me from moving on my own
        return false
    }

    if g_forceDodge.integer == 2 {
        if `self`.client!.ps.fd.forcePowersActive != 0 {
            //for now just don't let us dodge if we're using a force power at all
            return false
        }
    }

    if g_forceDodge.integer == 2 {
        if !WP_ForcePowerUsable(`self`, FP_SPEED) {
            //make sure we have it and have enough force power
            return false
        }
    }

    if g_forceDodge.integer == 2 {
        if Q_irand(1, 7) > `self`.client!.ps.fd.forcePowerLevel[FP_SPEED] {
            //more likely to fail on lower force speed level
            return false
        }
    } else {
        //We now dodge all the time, but only on level 3
        if `self`.client!.ps.fd.forcePowerLevel[FP_SEE] < FORCE_LEVEL_3 {
            //more likely to fail on lower force sight level
            return false
        }
    }

    switch hitLoc {
    case HL_NONE:
        return false

    case HL_FOOT_RT, HL_FOOT_LT, HL_LEG_RT, HL_LEG_LT:
        return false

    case HL_BACK_RT:
        dodgeAnim = BOTH_DODGE_FL

    case HL_CHEST_RT:
        dodgeAnim = BOTH_DODGE_FR

    case HL_BACK_LT:
        dodgeAnim = BOTH_DODGE_FR

    case HL_CHEST_LT:
        dodgeAnim = BOTH_DODGE_FR

    case HL_BACK, HL_CHEST, HL_WAIST:
        dodgeAnim = BOTH_DODGE_FL

    case HL_ARM_RT, HL_HAND_RT:
        dodgeAnim = BOTH_DODGE_L

    case HL_ARM_LT, HL_HAND_LT:
        dodgeAnim = BOTH_DODGE_R

    case HL_HEAD:
        dodgeAnim = BOTH_DODGE_FL

    default:
        return false
    }

    if dodgeAnim != -1 {
        //Our own happy way of forcing an anim:
        `self`.client!.ps.forceHandExtend = HANDEXTEND_DODGE
        `self`.client!.ps.forceDodgeAnim = dodgeAnim
        `self`.client!.ps.forceHandExtendTime = level.time + 300

        `self`.client!.ps.powerups[PW_SPEEDBURST] = level.time + 100

        if g_forceDodge.integer == 2 {
            ForceSpeed(`self`, 500)
        } else {
            G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/force/speed.wav"))
        }
        return true
    }
    return false
}
