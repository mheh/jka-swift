import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/w_saber.c:7
let SABER_BOX_SIZE = 16.0 as Float

/// Source: oracle/codemp/game/w_saber.c:18
var saberSpinSound: Int32 {
    get { world.variables.saberSpinSound }
    set { world.variables.saberSpinSound = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:284
let PROPER_THROWN_VALUE = 999 as Int32

/// Source: oracle/codemp/game/w_saber.c:639
let LOOK_DEFAULT_SPEED = 0.15 as Float

/// Source: oracle/codemp/game/w_saber.c:640
let LOOK_TALKING_SPEED = 0.15 as Float

/// Source: oracle/codemp/game/w_saber.c:1088
let LOCK_IDEAL_DIST_TOP = 32.0 as Float

/// Source: oracle/codemp/game/w_saber.c:1089
let LOCK_IDEAL_DIST_CIRCLE = 48.0 as Float

/// Source: oracle/codemp/game/w_saber.c:1091
let SABER_HITDAMAGE = 35 as Int32

/// Source: oracle/codemp/game/w_saber.c:1216
let LOCK_IDEAL_DIST_JKA = 46.0 as Float

/// Source: oracle/codemp/game/w_saber.c:2235
let SABER_NONATTACK_DAMAGE = 1 as Int32

/// Source: oracle/codemp/game/w_saber.c:2850
let SABER_EXTRAPOLATE_DIST = 16.0 as Float

/// Source: oracle/codemp/game/w_saber.c:3503
let MAX_SABER_VICTIMS = 16 as Int32

/// Source: oracle/codemp/game/w_saber.c:3504
var victimEntityNum: [Int32] {
    get { world.variables.victimEntityNum }
    set { world.variables.victimEntityNum = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3505
var victimHitEffectDone: [Bool] {
    get { world.variables.victimHitEffectDone }
    set { world.variables.victimHitEffectDone = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3506
var totalDmg: [Float] {
    get { world.variables.totalDmg }
    set { world.variables.totalDmg = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3507
var dmgDir: [JKAShared.vec3_t] {
    get { world.variables.dmgDir }
    set { world.variables.dmgDir = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3508
var dmgSpot: [JKAShared.vec3_t] {
    get { world.variables.dmgSpot }
    set { world.variables.dmgSpot = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3509
var dismemberDmg: [Bool] {
    get { world.variables.dismemberDmg }
    set { world.variables.dismemberDmg = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3510
var saberKnockbackFlags: [Int32] {
    get { world.variables.saberKnockbackFlags }
    set { world.variables.saberKnockbackFlags = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3511
var numVictims: Int32 {
    get { world.variables.numVictims }
    set { world.variables.numVictims = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3794
var saberDoClashEffect: Bool {
    get { world.variables.saberDoClashEffect }
    set { world.variables.saberDoClashEffect = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3795
/// Raven's data table, a hand property of `GameWorld`.
var saberClashPos: JKAShared.vec3_t {
    get { world.saberClashPos }
    set { world.saberClashPos = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3796
/// Raven's data table, a hand property of `GameWorld`.
var saberClashNorm: JKAShared.vec3_t {
    get { world.saberClashNorm }
    set { world.saberClashNorm = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3797
var saberClashEventParm: Int32 {
    get { world.variables.saberClashEventParm }
    set { world.variables.saberClashEventParm = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3846
var saberHitWall: Bool {
    get { world.variables.saberHitWall }
    set { world.variables.saberHitWall = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3847
var saberHitSaber: Bool {
    get { world.variables.saberHitSaber }
    set { world.variables.saberHitSaber = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:3848
var saberHitFraction: Float {
    get { world.variables.saberHitFraction }
    set { world.variables.saberHitFraction = newValue }
}

/// Source: oracle/codemp/game/w_saber.c:5284
let MAX_SABER_SWING_INC = 0.33 as Float

/// Source: oracle/codemp/game/w_saber.c:5885
let MIN_SABER_SLICE_DISTANCE = 50 as Int32

/// Source: oracle/codemp/game/w_saber.c:5887
let MIN_SABER_SLICE_RETURN_DISTANCE = 30 as Int32

/// Source: oracle/codemp/game/w_saber.c:5889
let SABER_THROWN_HIT_DAMAGE = 30 as Int32

/// Source: oracle/codemp/game/w_saber.c:5890
let SABER_THROWN_RETURN_HIT_DAMAGE = 5 as Int32

/// Source: oracle/codemp/game/w_saber.c:6337
let MAX_LEAVE_TIME = 20000 as Int32

/// Source: oracle/codemp/game/w_saber.c:6510
let SABER_RETRIEVE_DELAY = 3000 as Int32

/// Source: oracle/codemp/game/w_saber.c:6587
// Raven wrote: #define SABERINVALID ( ! saberent || ! saberOwner || ! other || ! saberent -> inuse || ! saberOwner -> inuse || ! other -> inuse || ! saberOwner -> client || ! other -> client || ! saberOwner -> client -> ps . saberEntityNum || saberOwner -> client -> ps . saberLockTime > ( level . time - 100 ) )
// A hand value: saberInvalid, a hand Bool function of JKAMP_GameLogic, because the macro reads three parameters of its four callers and is not a constant.

/// Source: oracle/codemp/game/w_saber.c:7115
let SABER_MAX_THROW_DISTANCE = 700 as Int32

/// Source: oracle/codemp/game/w_saber.c:7470
let STAFF_KICK_RANGE = 16 as Int32

/// Source: oracle/codemp/game/w_saber.c:39
func RandFloat(_ min: Float, _ max: Float) -> Float {
    //	return ((rand() * (max - min)) / 32768.0F) + min;
    //for linux:
    // The SDK also declares `rand`, so the call names the bg module.
    return ((JKAMP_BG.rand() * (max - min)) / Float(RAND_MAX)) + min
}

/// Source: oracle/codemp/game/w_saber.c:46
func G_DebugBoxLines(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ duration: Int32) {
    var start = vec3_t()
    var end = vec3_t()

    let x: Float = maxs[0] - mins[0]
    let y: Float = maxs[1] - mins[1]

    // top of box
    start = maxs
    end = maxs
    start[0] -= x
    G_TestLine(start, end, 0x00000ff, duration)
    end[0] = start[0]
    end[1] -= y
    G_TestLine(start, end, 0x00000ff, duration)
    start[1] = end[1]
    start[0] += x
    G_TestLine(start, end, 0x00000ff, duration)
    G_TestLine(start, maxs, 0x00000ff, duration)
    // bottom of box
    start = mins
    end = mins
    start[0] += x
    G_TestLine(start, end, 0x00000ff, duration)
    end[0] = start[0]
    end[1] += y
    G_TestLine(start, end, 0x00000ff, duration)
    start[1] = end[1]
    start[0] -= x
    G_TestLine(start, end, 0x00000ff, duration)
    G_TestLine(start, mins, 0x00000ff, duration)
}

//general check for performing certain attacks against others
/// Source: oracle/codemp/game/w_saber.c:82
func G_CanBeEnemy(_ `self`: Entity, _ enemy: Entity) -> Bool {
    if !`self`.inuse || !enemy.inuse || `self`.client == nil || enemy.client == nil {
        return false
    }

    if `self`.client!.ps.duelInProgress && `self`.client!.ps.duelIndex != enemy.s.number {
        //dueling but not with this person
        return false
    }

    if enemy.client!.ps.duelInProgress && enemy.client!.ps.duelIndex != `self`.s.number {
        //other guy dueling but not with me
        return false
    }

    if g_gametype.integer < GT_TEAM {
        //ok, sure
        return true
    }

    if g_friendlyFire.integer != 0 {
        //if ff on then can inflict damage normally on teammates
        return true
    }

    if OnSameTeam(`self`, enemy) {
        //ff not on, don't hurt teammates
        return false
    }

    return true
}

//This function gets the attack power which is used to decide broken parries,
//knockaways, and numerous other things. It is not directly related to the
//actual amount of damage done, however. -rww
/// Source: oracle/codemp/game/w_saber.c:120
private func G_SaberAttackPower(_ ent: Entity, _ attacking: Bool) -> Int32 {
    var baseLevel: Int32

    baseLevel = ent.client!.ps.fd.saberAnimLevel

    //Give "medium" strength for the two special stances.
    if baseLevel == SS_DUAL {
        baseLevel = 2
    } else if baseLevel == SS_STAFF {
        baseLevel = 2
    }

    if attacking {
        //the attacker gets a boost to help penetrate defense.
        //General boost up so the individual levels make a bigger difference.
        baseLevel *= 2

        baseLevel += 1

        //Get the "speed" of the swing, roughly, and add more power
        //to the attack based on it.
        if ent.client!.lastSaberStorageTime >= (level.time - 50) && ent.client!.olderIsValid {
            var vSub = vec3_t()
            var swingDist: Int32
            var toleranceAmt: Int32

            //We want different "tolerance" levels for adding in the distance of the last swing
            //to the base power level depending on which stance we are using. Otherwise fast
            //would have more advantage than it should since the animations are all much faster.
            switch ent.client!.ps.fd.saberAnimLevel {
            case SS_STRONG:
                toleranceAmt = 8

            case SS_MEDIUM:
                toleranceAmt = 16

            case SS_FAST:
                toleranceAmt = 24

            default:
                toleranceAmt = 16
            }

            vSub = ent.client!.lastSaberBase_Always - ent.client!.olderSaberBase
            swingDist = Int32(VectorLength(vSub))

            while swingDist > 0 {
                //I would like to do something more clever. But I suppose this works, at least for now.
                baseLevel += 1
                swingDist -= toleranceAmt
            }
        }

        if g_saberDebugPrint.integer > 1 {
            Com_Printf("Client %i: ATT STR: %i\n", ent.s.number, baseLevel)
        }
    }

    if (ent.client!.ps.brokenLimbs & (1 << BROKENLIMB_RARM)) != 0 || (ent.client!.ps.brokenLimbs & (1 << BROKENLIMB_LARM)) != 0 {
        //We're very weak when one of our arms is broken
        baseLevel = Int32(Double(baseLevel) * 0.3)
    }

    //Cap at reasonable values now.
    if baseLevel < 1 {
        baseLevel = 1
    } else if baseLevel > 16 {
        baseLevel = 16
    }

    if g_gametype.integer == GT_POWERDUEL && ent.client!.sess.duelTeam == DUELTEAM_LONE {
        //get more power then
        return baseLevel * 2
    } else if attacking && g_gametype.integer == GT_SIEGE {
        //in siege, saber battles should be quicker and more biased toward the attacker
        return baseLevel * 3
    }

    return baseLevel
}

/// Source: oracle/codemp/game/w_saber.c:219
func WP_DeactivateSaber(_ `self`: Entity, _ clearLength: Bool) {
    if `self`.client == nil {
        return
    }
    //keep my saber off!
    if `self`.client!.ps.saberHolstered == 0 {
        `self`.client!.ps.saberHolstered = 2
        /*
        if ( clearLength )
        {
        self->client->ps.SetSaberLength( 0 );
        }
        */
        //Doens't matter ATM
        if `self`.client!.saber[0].soundOff != 0 {
            G_Sound(`self`, CHAN_WEAPON, `self`.client!.saber[0].soundOff)
        }

        if `self`.client!.saber[1].soundOff != 0 && !`self`.client!.saber[1].model.isEmpty {
            G_Sound(`self`, CHAN_WEAPON, `self`.client!.saber[1].soundOff)
        }
    }
}

/// Source: oracle/codemp/game/w_saber.c:250
func WP_ActivateSaber(_ `self`: Entity) {
    if `self`.client == nil {
        return
    }

    if `self`.NPC != nil && `self`.client!.ps.forceHandExtend == HANDEXTEND_JEDITAUNT && (`self`.client!.ps.forceHandExtendTime - level.time) > 200 {
        //if we're an NPC and in the middle of a taunt then stop it
        `self`.client!.ps.forceHandExtend = HANDEXTEND_NONE
        `self`.client!.ps.forceHandExtendTime = 0
    } else if `self`.client!.ps.fd.forceGripCripple != 0 {
        //can't activate saber while being gripped
        return
    }

    if `self`.client!.ps.saberHolstered != 0 {
        `self`.client!.ps.saberHolstered = 0
        if `self`.client!.saber[0].soundOn != 0 {
            G_Sound(`self`, CHAN_WEAPON, `self`.client!.saber[0].soundOn)
        }

        if `self`.client!.saber[1].soundOn != 0 {
            G_Sound(`self`, CHAN_WEAPON, `self`.client!.saber[1].soundOn)
        }
    }
}

/// Source: oracle/codemp/game/w_saber.c:286
func SaberUpdateSelf(_ ent: Entity) {
    if ent.r.ownerNum == ENTITYNUM_NONE {
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
        return
    }

    if !g_entities[ent.r.ownerNum].inuse || g_entities[ent.r.ownerNum].client == nil {
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
        return
    }

    if g_entities[ent.r.ownerNum].client!.ps.saberInFlight && g_entities[ent.r.ownerNum].health > 0 {
        //let The Master take care of us now (we'll get treated like a missile until we return)
        ent.nextthink = level.time
        ent.genericValue5 = PROPER_THROWN_VALUE
        return
    }

    ent.genericValue5 = 0

    if g_entities[ent.r.ownerNum].client!.ps.weapon != WP_SABER || (g_entities[ent.r.ownerNum].client!.ps.pm_flags & PMF_FOLLOW) != 0 || g_entities[ent.r.ownerNum].client!.sess.sessionTeam == TEAM_SPECTATOR || g_entities[ent.r.ownerNum].client!.tempSpectate >= level.time || g_entities[ent.r.ownerNum].health < 1 || BG_SabersOff(g_entities[ent.r.ownerNum].client!.ps) || (g_entities[ent.r.ownerNum].client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] == 0 && g_entities[ent.r.ownerNum].s.eType != ET_NPC) {
        //owner is not using saber, spectating, dead, saber holstered, or has no attack level
        ent.r.contents = 0
        ent.clipmask = 0
    } else {
        //Standard contents (saber is active)
        if g_saberDebugBox.integer == 1 || g_saberDebugBox.integer == 4 {
            var dbgMins = vec3_t()
            var dbgMaxs = vec3_t()

            dbgMins = ent.r.currentOrigin + ent.r.mins
            dbgMaxs = ent.r.currentOrigin + ent.r.maxs

            G_DebugBoxLines(dbgMins, dbgMaxs, Int32((10.0 / Float(g_svfps.integer)) * 100))
        }
        if ent.r.contents != CONTENTS_LIGHTSABER {
            if (level.time - g_entities[ent.r.ownerNum].client!.lastSaberStorageTime) <= 200 {
                //Only go back to solid once we're sure our owner has updated recently
                ent.r.contents = CONTENTS_LIGHTSABER
                ent.clipmask = MASK_PLAYERSOLID | CONTENTS_LIGHTSABER
            }
        } else {
            ent.r.contents = CONTENTS_LIGHTSABER
            ent.clipmask = MASK_PLAYERSOLID | CONTENTS_LIGHTSABER
        }
    }

    trap_LinkEntity(ent)

    ent.nextthink = level.time
}

/// Source: oracle/codemp/game/w_saber.c:360
func SaberGotHit(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    let own: Entity? = g_entities[`self`.r.ownerNum]

    if own == nil || own!.client == nil {
        return
    }

    //Do something here..? Was handling projectiles here, but instead they're now handled in their own functions.
}

/// Source: oracle/codemp/game/w_saber.c:376
private func SetSaberBoxSize(_ saberent: Entity) {
    var owner: Entity? = nil
    var saberOrg = vec3_t()
    var saberTip = vec3_t()
    var i: Int32
    var j: Int32 = 0
    var k: Int32 = 0
    var dualSabers: Bool = false
    var alwaysBlock = [[Bool]](repeating: [Bool](repeating: false, count: MAX_BLADES), count: MAX_SABERS)
    var forceBlock: Bool = false


    if saberent.r.ownerNum < MAX_CLIENTS && saberent.r.ownerNum >= 0 {
        owner = g_entities[saberent.r.ownerNum]
    } else if saberent.r.ownerNum >= 0 && saberent.r.ownerNum < ENTITYNUM_WORLD && g_entities[saberent.r.ownerNum].s.eType == ET_NPC {
        owner = g_entities[saberent.r.ownerNum]
    }

    if owner == nil || !owner!.inuse || owner!.client == nil {
        return
    }

    // Raven tests `owner->client->saber[1].model` and `owner->client->saber[1].model[0]`.
    // Both read as the same Swift test, so the draft writes it once.
    if !owner!.client!.saber[1].model.isEmpty {
        dualSabers = true
    }

    if PM_SaberInBrokenParry(owner!.client!.ps.saberMove) || BG_SuperBreakLoseAnim(owner!.client!.ps.torsoAnim) {
        //let swings go right through when we're in this state
        i = 0
        while i < MAX_SABERS {
            if i > 0 && !dualSabers {
                //not using a second saber, set it to not blocking
                j = 0
                while j < MAX_BLADES {
                    alwaysBlock[i][j] = false
                    j += 1
                }
            } else {
                if (owner!.client!.saber[i].saberFlags2 & SFL2_ALWAYS_BLOCK) != 0 {
                    j = 0
                    while j < owner!.client!.saber[i].numBlades {
                        alwaysBlock[i][j] = true
                        forceBlock = true
                        j += 1
                    }
                }
                if owner!.client!.saber[i].bladeStyle2Start > 0 {
                    j = owner!.client!.saber[i].bladeStyle2Start
                    while j < owner!.client!.saber[i].numBlades {
                        if (owner!.client!.saber[i].saberFlags2 & SFL2_ALWAYS_BLOCK2) != 0 {
                            alwaysBlock[i][j] = true
                            forceBlock = true
                        } else {
                            alwaysBlock[i][j] = false
                        }
                        j += 1
                    }
                }
            }
            i += 1
        }
        if !forceBlock {
            //no sabers/blades to FORCE to be on, so turn off blocking altogether
            saberent.r.mins = vec3_t(0, 0, 0)
            saberent.r.maxs = vec3_t(0, 0, 0)
            if g_saberDebugPrint.integer > 1 {
                Com_Printf("Client %i in broken parry, saber box 0\n", owner!.s.number)
            }
            return
        }
    }

    if (level.time - owner!.client!.lastSaberStorageTime) > 200 || (level.time - owner!.client!.saber[j].blade[k].storageTime) > 100 {
        //it's been too long since we got a reliable point storage, so use the defaults and leave.
        saberent.r.mins = vec3_t(-SABER_BOX_SIZE, -SABER_BOX_SIZE, -SABER_BOX_SIZE)
        saberent.r.maxs = vec3_t(SABER_BOX_SIZE, SABER_BOX_SIZE, SABER_BOX_SIZE)
        return
    }

    if dualSabers || owner!.client!.saber[0].numBlades > 1 {
        //dual sabers or multi-blade saber
        if owner!.client!.ps.saberHolstered > 1 {
            //entirely off
            //no blocking at all
            saberent.r.mins = vec3_t(0, 0, 0)
            saberent.r.maxs = vec3_t(0, 0, 0)
            return
        }
    } else {
        //single saber
        if owner!.client!.ps.saberHolstered != 0 {
            //off
            //no blocking at all
            saberent.r.mins = vec3_t(0, 0, 0)
            saberent.r.maxs = vec3_t(0, 0, 0)
            return
        }
    }
    //Start out at the saber origin, then go through all the blades and push out the extents
    //for each blade, then set the box relative to the origin.
    saberent.r.mins = saberent.r.currentOrigin
    saberent.r.maxs = saberent.r.currentOrigin

    i = 0
    while i < 3 {
        j = 0
        while j < MAX_SABERS {
            if owner!.client!.saber[j].model.isEmpty {
                break
            }
            if dualSabers && owner!.client!.ps.saberHolstered == 1 && j == 1 {
                //this mother is holstered, get outta here.
                j += 1
                j += 1
                continue
            }
            k = 0
            while k < owner!.client!.saber[j].numBlades {
                if k > 0 {
                    //not the first blade
                    if !dualSabers {
                        //using a single saber
                        if owner!.client!.saber[j].numBlades > 1 {
                            //with multiple blades
                            if owner!.client!.ps.saberHolstered == 1 {
                                //all blades after the first one are off
                                break
                            }
                        }
                    }
                }
                if forceBlock {
                    //only do blocking with blades that are marked to block
                    if !alwaysBlock[j][k] {
                        //this blade shouldn't be blocking
                        k += 1
                        continue
                    }
                }
                //VectorMA(owner->client->saber[j].blade[k].muzzlePoint, owner->client->saber[j].blade[k].lengthMax*0.5f, owner->client->saber[j].blade[k].muzzleDir, saberOrg);
                saberOrg = owner!.client!.saber[j].blade[k].muzzlePoint
                _VectorMA(owner!.client!.saber[j].blade[k].muzzlePoint, owner!.client!.saber[j].blade[k].lengthMax, owner!.client!.saber[j].blade[k].muzzleDir, &saberTip)

                if saberOrg[i] < saberent.r.mins[i] {
                    saberent.r.mins[i] = saberOrg[i]
                }
                if saberTip[i] < saberent.r.mins[i] {
                    saberent.r.mins[i] = saberTip[i]
                }

                if saberOrg[i] > saberent.r.maxs[i] {
                    saberent.r.maxs[i] = saberOrg[i]
                }
                if saberTip[i] > saberent.r.maxs[i] {
                    saberent.r.maxs[i] = saberTip[i]
                }

                //G_TestLine(saberOrg, saberTip, 0x0000ff, 50);
                k += 1
            }
            j += 1
        }
        i += 1
    }

    saberent.r.mins = saberent.r.mins - saberent.r.currentOrigin
    saberent.r.maxs = saberent.r.maxs - saberent.r.currentOrigin
}

/// Source: oracle/codemp/game/w_saber.c:566
func WP_SaberInitBladeData(_ ent: Entity) {
    var saberent: Entity? = nil
    var checkEnt: Entity?
    var i: Int32 = 0

    while i < level.num_entities {
        //make sure there are no other saber entities floating around that think they belong to this client.
        checkEnt = g_entities[i]

        if checkEnt!.inuse && checkEnt!.neverFree && checkEnt!.r.ownerNum == ent.s.number && checkEnt!.classname != nil && !checkEnt!.classname!.isEmpty && Q_stricmp(checkEnt!.classname!, "lightsaber") == 0 {
            if saberent != nil {
                //already have one
                checkEnt!.neverFree = false
                checkEnt!.think = Think.G_FreeEntity
                checkEnt!.nextthink = level.time
            } else {
                //hmm.. well then, take it as my own.
                //free the bitch but don't issue a kg2 to avoid overflowing clients.
                checkEnt!.s.modelGhoul2 = 0
                G_FreeEntity(checkEnt!)

                //now init it manually and reuse this ent slot.
                G_InitGentity(checkEnt!)
                saberent = checkEnt
            }
        }

        i += 1
    }

    //We do not want the client to have any real knowledge of the entity whatsoever. It will only
    //ever be used on the server.
    if saberent == nil {
        //ok, make one then
        saberent = G_Spawn()
    }
    ent.client!.saberStoredIndex = saberent!.s.number
    ent.client!.ps.saberEntityNum = ent.client!.saberStoredIndex
    saberent!.classname = "lightsaber"

    saberent!.neverFree = true //the saber being removed would be a terrible thing.

    saberent!.r.svFlags = SVF_USE_CURRENT_ORIGIN
    saberent!.r.ownerNum = ent.s.number

    saberent!.clipmask = MASK_PLAYERSOLID | CONTENTS_LIGHTSABER
    saberent!.r.contents = CONTENTS_LIGHTSABER

    SetSaberBoxSize(saberent!)

    saberent!.mass = 10

    saberent!.s.eFlags |= EF_NODRAW
    saberent!.r.svFlags |= SVF_NOCLIENT

    saberent!.s.modelGhoul2 = 1
    //should we happen to be removed (we belong to an NPC and he is removed) then
    //we want to attempt to remove our g2 instance on the client in case we had one.

    saberent!.touch = Touch.SaberGotHit

    saberent!.think = Think.SaberUpdateSelf
    saberent!.genericValue5 = 0
    saberent!.nextthink = level.time + 50

    saberSpinSound = G_SoundIndex("sound/weapons/saber/saberspin.wav")
}

/// Source: oracle/codemp/game/w_saber.c:642
private func G_CheckLookTarget(_ ent: Entity, _ lookAngles: inout JKAShared.vec3_t, _ lookingSpeed: inout Float) -> Bool {
    //FIXME: also clamp the lookAngles based on the clamp + the existing difference between
    //		headAngles and torsoAngles?  But often the tag_torso is straight but the torso itself
    //		is deformed to not face straight... sigh...

    if ent.s.eType == ET_NPC && ent.s.m_iVehicleNum != 0 && ent.s.NPC_class != CLASS_VEHICLE {
        //an NPC bolted to a vehicle should just look around randomly
        if TIMER_Done(ent, "lookAround") {
            ent.NPC!.shootAngles[YAW] = flrand(0, 360)
            TIMER_Set(ent, "lookAround", Q_irand(500, 3000))
        }
        lookAngles = vec3_t(0, ent.NPC!.shootAngles[YAW], 0)
        return true
    }
    //Now calc head angle to lookTarget, if any
    if ent.client!.renderInfo.lookTarget >= 0 && ent.client!.renderInfo.lookTarget < ENTITYNUM_WORLD {
        var lookDir = vec3_t()
        var lookOrg = vec3_t()
        var eyeOrg = vec3_t()
        var i: Int32

        if ent.client!.renderInfo.lookMode == LM_ENT {
            let lookCent: Entity? = g_entities[ent.client!.renderInfo.lookTarget]
            if lookCent != nil {
                if lookCent != ent.enemy {
                    //We turn heads faster than headbob speed, but not as fast as if watching an enemy
                    lookingSpeed = LOOK_DEFAULT_SPEED
                }

                //FIXME: Ignore small deltas from current angles so we don't bob our head in synch with theirs?

                /*
                if ( ent->client->renderInfo.lookTarget == 0 && !cg.renderingThirdPerson )//!cg_thirdPerson.integer )
                {//Special case- use cg.refdef.vieworg if looking at player and not in third person view
                VectorCopy( cg.refdef.vieworg, lookOrg );
                }
                */
                if lookCent!.client != nil {
                    lookOrg = lookCent!.client!.renderInfo.eyePoint
                } else if lookCent!.inuse && VectorCompare(lookCent!.r.currentOrigin, vec3_origin) == 0 {
                    lookOrg = lookCent!.r.currentOrigin
                } else {
                    //at origin of world
                    return false
                }
                //Look in dir of lookTarget
            }
        } else if ent.client!.renderInfo.lookMode == LM_INTEREST && ent.client!.renderInfo.lookTarget > -1 && ent.client!.renderInfo.lookTarget < MAX_INTEREST_POINTS {
            lookOrg = level.interestPoints[ent.client!.renderInfo.lookTarget].origin
        } else {
            return false
        }

        eyeOrg = ent.client!.renderInfo.eyePoint

        lookDir = lookOrg - eyeOrg

        vectoangles(lookDir, &lookAngles)

        i = 0
        while i < 3 {
            lookAngles[i] = AngleNormalize180(lookAngles[i])
            ent.client!.renderInfo.eyeAngles[i] = AngleNormalize180(ent.client!.renderInfo.eyeAngles[i])
            i += 1
        }
        AnglesSubtract(lookAngles, ent.client!.renderInfo.eyeAngles, &lookAngles)
        return true
    }

    return false
}

/// Source: oracle/codemp/game/w_saber.c:732
private func G_G2NPCAngles(_ ent: Entity, _ legs: inout [JKAShared.vec3_t], _ angles: inout JKAShared.vec3_t) {
    let craniumBone: String = "cranium"
    let thoracicBone: String = "thoracic"
    var looking: Bool = false
    var viewAngles = vec3_t()
    var lookAngles = vec3_t()

    if ent.client != nil {
        if (ent.client!.NPC_class == CLASS_PROBE) || (ent.client!.NPC_class == CLASS_R2D2) || (ent.client!.NPC_class == CLASS_R5D2) || (ent.client!.NPC_class == CLASS_ATST) {
            var trailingLegsAngles = vec3_t()

            if ent.s.eType == ET_NPC && ent.s.m_iVehicleNum != 0 && ent.s.NPC_class != CLASS_VEHICLE {
                //an NPC bolted to a vehicle should use the full angles
                angles = ent.r.currentAngles
            } else {
                angles = ent.client!.ps.viewangles
                angles[PITCH] = 0
            }

            //FIXME: use actual swing/clamp tolerances?
            /*
            if ( ent->client->ps.groundEntityNum != ENTITYNUM_NONE )
            {//on the ground
            CG_PlayerLegsYawFromMovement( cent, ent->client->ps.velocity, &angles[YAW], cent->lerpAngles[YAW], -60, 60, qtrue );
            }
            else
            {//face legs to front
            CG_PlayerLegsYawFromMovement( cent, vec3_origin, &angles[YAW], cent->lerpAngles[YAW], -60, 60, qtrue );
            }
            */

            viewAngles = ent.client!.ps.viewangles
            //			viewAngles[YAW] = viewAngles[ROLL] = 0;
            viewAngles[PITCH] = Float(Double(viewAngles[PITCH]) * 0.5)
            lookAngles = viewAngles

            lookAngles[1] = 0

            if ent.client!.NPC_class == CLASS_ATST {
                //body pitch
                NPC_SetBoneAngles(ent, thoracicBone, lookAngles)
                //BG_G2SetBoneAngles( cent, ent, ent->thoracicBone, lookAngles, BONE_ANGLES_POSTMULT,POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, cgs.model_draw);
            }

            lookAngles = viewAngles

            if ent.client != nil && ent.client!.NPC_class == CLASS_ATST {
                //CG_ATSTLegsYaw( cent, trailingLegsAngles );
                AnglesToAxis(trailingLegsAngles, &legs)
            } else {
                //FIXME: this needs to properly set the legs.yawing field so we don't erroneously play the turning anim, but we do play it when turning in place
                /*
                if ( angles[YAW] == cent->pe.legs.yawAngle )
                {
                cent->pe.legs.yawing = qfalse;
                }
                else
                {
                cent->pe.legs.yawing = qtrue;
                }

                cent->pe.legs.yawAngle = angles[YAW];
                if ( ent->client )
                {
                ent->client->renderInfo.legsYaw = angles[YAW];
                }
                AnglesToAxis( angles, legs );
                */
            }

            //			if ( ent && ent->client && ent->client->NPC_class == CLASS_ATST )
            //			{
            //				looking = qfalse;
            //			}
            //			else
            do {
                //look at lookTarget!
                //FIXME: snaps to side when lets go of lookTarget... ?
                var lookingSpeed: Float = 0.3
                looking = G_CheckLookTarget(ent, &lookAngles, &lookingSpeed)
                lookAngles[ROLL] = 0 //droids can't pitch or roll their heads
                lookAngles[PITCH] = lookAngles[ROLL] //droids can't pitch or roll their heads
                if looking {
                    //want to keep doing this lerp behavior for a full second after stopped looking (so don't snap)
                    ent.client!.renderInfo.lookingDebounceTime = level.time + 1000
                }
            }
            if ent.client!.renderInfo.lookingDebounceTime > level.time {
                //adjust for current body orientation
                var oldLookAngles = vec3_t()

                lookAngles[YAW] -= 0 //ent->client->ps.viewangles[YAW];//cent->pe.torso.yawAngle;
                //lookAngles[YAW] -= cent->pe.legs.yawAngle;

                //normalize
                lookAngles[YAW] = AngleNormalize180(lookAngles[YAW])

                //slowly lerp to this new value
                //Remember last headAngles
                oldLookAngles = ent.client!.renderInfo.lastHeadAngles
                if VectorCompare(oldLookAngles, lookAngles) == 0 {
                    //FIXME: This clamp goes off viewAngles,
                    //but really should go off the tag_torso's axis[0] angles, no?
                    lookAngles[YAW] = oldLookAngles[YAW] + (lookAngles[YAW] - oldLookAngles[YAW]) * 0.4
                }
                //Remember current lookAngles next time
                ent.client!.renderInfo.lastHeadAngles = lookAngles
            } else {
                //Remember current lookAngles next time
                ent.client!.renderInfo.lastHeadAngles = lookAngles
            }
            if ent.client!.NPC_class == CLASS_ATST {
                lookAngles = ent.client!.ps.viewangles
                lookAngles[2] = 0
                lookAngles[0] = lookAngles[2]
                lookAngles[YAW] -= trailingLegsAngles[YAW]
            } else {
                lookAngles[ROLL] = 0
                lookAngles[PITCH] = lookAngles[ROLL]
                lookAngles[YAW] -= ent.client!.ps.viewangles[YAW]
            }

            NPC_SetBoneAngles(ent, craniumBone, lookAngles)
            //BG_G2SetBoneAngles( cent, ent, ent->craniumBone, lookAngles, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, cgs.model_draw);
            //return;
        } else {
            //	VectorCopy( ent->client->ps.viewangles, angles );
            //	AnglesToAxis( angles, legs );
            //return;
        }
    }
}

/// Source: oracle/codemp/game/w_saber.c:881
private func G_G2PlayerAngles(_ ent: Entity, _ legs: inout [JKAShared.vec3_t], _ legsAngles: inout JKAShared.vec3_t) {
    var tPitching: Bool = false
    var tYawing: Bool = false
    var lYawing: Bool = false
    var tYawAngle: Float = ent.client!.ps.viewangles[YAW]
    var tPitchAngle: Float = 0
    var lYawAngle: Float = ent.client!.ps.viewangles[YAW]

    let ciLegs: Int32 = ent.client!.ps.legsAnim
    let ciTorso: Int32 = ent.client!.ps.torsoAnim

    var turAngles = vec3_t()
    var lerpOrg = vec3_t()
    var lerpAng = vec3_t()

    if ent.s.eType == ET_NPC && ent.client != nil {
        //sort of hacky, but it saves a pretty big load off the server
        var i: Int32 = 0
        var clEnt: Entity?

        //If no real clients are in the same PVS then don't do any of this stuff, no one can see him anyway!
        while i < MAX_CLIENTS {
            clEnt = g_entities[i]

            if clEnt != nil && clEnt!.inuse && clEnt!.client != nil && trap_InPVS(clEnt!.client!.ps.origin, ent.client!.ps.origin) {
                //this client can see him
                break
            }

            i += 1
        }

        if i == MAX_CLIENTS {
            //no one can see him, just return
            return
        }
    }

    lerpOrg = ent.client!.ps.origin
    lerpAng = ent.client!.ps.viewangles

    if ent.localAnimIndex <= 1 {
        //don't do these things on non-humanoids
        var lookAngles = vec3_t()
        var emplaced: EntityState? = nil

        if ent.client!.ps.hasLookTarget {
            lookAngles = g_entities[ent.client!.ps.lookTarget].r.currentOrigin - ent.client!.ps.origin
            vectoangles(lookAngles, &lookAngles)
            ent.client!.lookTime = level.time + 1000
        } else {
            lookAngles = ent.client!.ps.origin
        }
        lookAngles[PITCH] = 0

        if ent.client!.ps.emplacedIndex != 0 {
            emplaced = g_entities[ent.client!.ps.emplacedIndex].s
        }

        BG_G2PlayerAngles(ent.ghoul2, ent.client!.renderInfo.motionBolt, ent.s, level.time, &lerpOrg, &lerpAng, &legs, &legsAngles, &tYawing, &tPitching, &lYawing, &tYawAngle, &tPitchAngle, &lYawAngle, FRAMETIME, &turAngles, &ent.modelScale, ciLegs, ciTorso, &ent.client!.corrTime, &lookAngles, &ent.client!.lastHeadAngles, ent.client!.lookTime, emplaced, nil)

        if ent.client!.ps.heldByClient != 0 && ent.client!.ps.heldByClient <= MAX_CLIENTS {
            //then put our arm in this client's hand
            //is index+1 because index 0 is valid.
            let heldByIndex: Int32 = ent.client!.ps.heldByClient - 1
            let other: Entity? = g_entities[heldByIndex]
            var lHandBolt: Int32 = 0

            if other != nil && other!.inuse && other!.client != nil && other!.ghoul2 != nil {
                lHandBolt = trap_G2API_AddBolt(other!.ghoul2, 0, "*l_hand")
            } else {
                //they left the game, perhaps?
                ent.client!.ps.heldByClient = 0
                return
            }

            if lHandBolt != 0 {
                // Raven's record lives to the end of his block, so the block is the closure.
                MdxaBone.scratch { boltMatrix in
                    var boltOrg = vec3_t()
                    var tAngles = vec3_t()

                    tAngles = other!.client!.ps.viewangles
                    tAngles[ROLL] = 0
                    tAngles[PITCH] = tAngles[ROLL]

                    trap_G2API_GetBoltMatrix(other!.ghoul2, 0, lHandBolt, boltMatrix, tAngles, other!.client!.ps.origin, level.time, nil, &other!.modelScale)
                    boltOrg[0] = boltMatrix.matrix[0][3]
                    boltOrg[1] = boltMatrix.matrix[1][3]
                    boltOrg[2] = boltMatrix.matrix[2][3]

                    BG_IK_MoveArm(ent.ghoul2, lHandBolt, level.time, ent.s, ent.client!.ps.torsoAnim, &boltOrg, &ent.client!.ikStatus, &ent.client!.ps.origin, &ent.client!.ps.viewangles, &ent.modelScale, 500, false)
                }
            }
        } else if ent.client!.ikStatus {
            //make sure we aren't IKing if we don't have anyone to hold onto us.
            var lHandBolt: Int32 = 0

            if ent.inuse && ent.client != nil && ent.ghoul2 != nil {
                lHandBolt = trap_G2API_AddBolt(ent.ghoul2, 0, "*l_hand")
            } else {
                //This shouldn't happen, but just in case it does, we'll have a failsafe.
                ent.client!.ikStatus = false
            }

            if lHandBolt != 0 {
                // BG_IK_MoveArm only reads `desiredPos`, so the copy of `vec3_origin` is never written.
                var originPos = vec3_origin
                BG_IK_MoveArm(ent.ghoul2, lHandBolt, level.time, ent.s, ent.client!.ps.torsoAnim/*BOTH_DEAD1*/, &originPos, &ent.client!.ikStatus, &ent.client!.ps.origin, &ent.client!.ps.viewangles, &ent.modelScale, 500, true)
            }
        }
    } else if ent.m_pVehicle != nil && ent.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
        var lookAngles = vec3_t()

        legsAngles = ent.client!.ps.viewangles
        legsAngles[PITCH] = 0
        AnglesToAxis(legsAngles, &legs)

        lookAngles = ent.client!.ps.viewangles
        lookAngles[ROLL] = 0
        lookAngles[YAW] = lookAngles[ROLL]

        BG_G2ATSTAngles(ent.ghoul2, level.time, &lookAngles)
    } else if ent.NPC != nil {
        //an NPC not using a humanoid skeleton, do special angle stuff.
        if ent.s.eType == ET_NPC && ent.s.NPC_class == CLASS_VEHICLE && ent.m_pVehicle != nil && ent.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
            //fighters actually want to take pitch and roll into account for the axial angles
            legsAngles = ent.client!.ps.viewangles
            AnglesToAxis(legsAngles, &legs)
        } else {
            G_G2NPCAngles(ent, &legs, &legsAngles)
        }
    }
}

/// Source: oracle/codemp/game/w_saber.c:1036
private func SaberAttacking(_ `self`: Entity) -> Bool {
    if PM_SaberInParry(`self`.client!.ps.saberMove) {
        return false
    }
    if PM_SaberInBrokenParry(`self`.client!.ps.saberMove) {
        return false
    }
    if PM_SaberInDeflect(`self`.client!.ps.saberMove) {
        return false
    }
    if PM_SaberInBounce(`self`.client!.ps.saberMove) {
        return false
    }
    if PM_SaberInKnockaway(`self`.client!.ps.saberMove) {
        return false
    }

    if BG_SaberInAttack(`self`.client!.ps.saberMove) {
        if `self`.client!.ps.weaponstate == WEAPON_FIRING && `self`.client!.ps.saberBlocked == BLOCKED_NONE {
            //if we're firing and not blocking, then we're attacking.
            return true
        }
    }

    if BG_SaberInSpecial(`self`.client!.ps.saberMove) {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/w_saber.c:1094
func G_SaberLockAnim(_ attackerSaberStyle: Int32, _ defenderSaberStyle: Int32, _ topOrSide: Int32, _ lockOrBreakOrSuperBreak: Int32, _ winOrLose: Int32) -> Int32 {
    var baseAnim: Int32 = -1
    if lockOrBreakOrSuperBreak == SABERLOCK_LOCK {
        //special case: if we're using the same style and locking
        if attackerSaberStyle == defenderSaberStyle || (attackerSaberStyle >= SS_FAST && attackerSaberStyle <= SS_TAVION && defenderSaberStyle >= SS_FAST && defenderSaberStyle <= SS_TAVION) {
            //using same style
            if winOrLose == SABERLOCK_LOSE {
                //you want the defender's stance...
                switch defenderSaberStyle {
                case SS_DUAL:
                    if topOrSide == SABERLOCK_TOP {
                        baseAnim = BOTH_LK_DL_DL_T_L_2
                    } else {
                        baseAnim = BOTH_LK_DL_DL_S_L_2
                    }

                case SS_STAFF:
                    if topOrSide == SABERLOCK_TOP {
                        baseAnim = BOTH_LK_ST_ST_T_L_2
                    } else {
                        baseAnim = BOTH_LK_ST_ST_S_L_2
                    }

                default:
                    if topOrSide == SABERLOCK_TOP {
                        baseAnim = BOTH_LK_S_S_T_L_2
                    } else {
                        baseAnim = BOTH_LK_S_S_S_L_2
                    }
                }
            }
        }
    }
    if baseAnim == -1 {
        switch attackerSaberStyle {
        case SS_DUAL:
            switch defenderSaberStyle {
            case SS_DUAL:
                baseAnim = BOTH_LK_DL_DL_S_B_1_L

            case SS_STAFF:
                baseAnim = BOTH_LK_DL_ST_S_B_1_L

            default:
                baseAnim = BOTH_LK_DL_S_S_B_1_L
            }

        case SS_STAFF:
            switch defenderSaberStyle {
            case SS_DUAL:
                baseAnim = BOTH_LK_ST_DL_S_B_1_L

            case SS_STAFF:
                baseAnim = BOTH_LK_ST_ST_S_B_1_L

            default:
                baseAnim = BOTH_LK_ST_S_S_B_1_L
            }

        default:
            switch defenderSaberStyle {
            case SS_DUAL:
                baseAnim = BOTH_LK_S_DL_S_B_1_L

            case SS_STAFF:
                baseAnim = BOTH_LK_S_ST_S_B_1_L

            default:
                baseAnim = BOTH_LK_S_S_S_B_1_L
            }
        }
        //side lock or top lock?
        if topOrSide == SABERLOCK_TOP {
            baseAnim += 5
        }
        //lock, break or superbreak?
        if lockOrBreakOrSuperBreak == SABERLOCK_LOCK {
            baseAnim += 2
        } else {
            //a break or superbreak
            if lockOrBreakOrSuperBreak == SABERLOCK_SUPERBREAK {
                baseAnim += 3
            }
            //winner or loser?
            if winOrLose == SABERLOCK_WIN {
                baseAnim += 1
            }
        }
    }
    return baseAnim
}

/// Source: oracle/codemp/game/w_saber.c:1218
private func WP_SabersCheckLock2(_ attacker: Entity, _ defender: Entity, _ lockMode: sabersLockMode_t) -> Bool {
    var attAnim: Int32 = 0
    var defAnim: Int32 = 0
    var attStart: Float = 0.5
    var defStart: Float = 0.5
    var idealDist: Float = 48.0
    var attAngles = vec3_t()
    var defAngles = vec3_t()
    var defDir = vec3_t()
    var newOrg = vec3_t()
    var attDir = vec3_t()
    var diff: Float = 0
    // Raven assigns his own `lockMode` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var lockMode = lockMode
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in

        //MATCH ANIMS
        if lockMode == LOCK_RANDOM {
            lockMode = sabersLockMode_t(Q_irand(Int32(LOCK_FIRST), Int32((LOCK_RANDOM)) - 1))
        }
        if attacker.client!.ps.fd.saberAnimLevel >= SS_FAST && attacker.client!.ps.fd.saberAnimLevel <= SS_TAVION && defender.client!.ps.fd.saberAnimLevel >= SS_FAST && defender.client!.ps.fd.saberAnimLevel <= SS_TAVION {
            //2 single sabers?  Just do it the old way...
            switch lockMode {
            case LOCK_TOP:
                attAnim = BOTH_BF2LOCK
                defAnim = BOTH_BF1LOCK
                defStart = 0.5
                attStart = defStart
                idealDist = LOCK_IDEAL_DIST_TOP

            case LOCK_DIAG_TR:
                attAnim = BOTH_CCWCIRCLELOCK
                defAnim = BOTH_CWCIRCLELOCK
                defStart = 0.5
                attStart = defStart
                idealDist = LOCK_IDEAL_DIST_CIRCLE

            case LOCK_DIAG_TL:
                attAnim = BOTH_CWCIRCLELOCK
                defAnim = BOTH_CCWCIRCLELOCK
                defStart = 0.5
                attStart = defStart
                idealDist = LOCK_IDEAL_DIST_CIRCLE

            case LOCK_DIAG_BR:
                attAnim = BOTH_CWCIRCLELOCK
                defAnim = BOTH_CCWCIRCLELOCK
                defStart = 0.85
                attStart = defStart
                idealDist = LOCK_IDEAL_DIST_CIRCLE

            case LOCK_DIAG_BL:
                attAnim = BOTH_CCWCIRCLELOCK
                defAnim = BOTH_CWCIRCLELOCK
                defStart = 0.85
                attStart = defStart
                idealDist = LOCK_IDEAL_DIST_CIRCLE

            case LOCK_R:
                attAnim = BOTH_CCWCIRCLELOCK
                defAnim = BOTH_CWCIRCLELOCK
                defStart = 0.75
                attStart = defStart
                idealDist = LOCK_IDEAL_DIST_CIRCLE

            case LOCK_L:
                attAnim = BOTH_CWCIRCLELOCK
                defAnim = BOTH_CCWCIRCLELOCK
                defStart = 0.75
                attStart = defStart
                idealDist = LOCK_IDEAL_DIST_CIRCLE

            default:
                return false
            }
        } else {
            //use the new system
            idealDist = LOCK_IDEAL_DIST_JKA //all of the new saberlocks are 46.08 from each other because Richard Lico is da MAN
            if lockMode == LOCK_TOP {
                //top lock
                attAnim = G_SaberLockAnim(attacker.client!.ps.fd.saberAnimLevel, defender.client!.ps.fd.saberAnimLevel, SABERLOCK_TOP, SABERLOCK_LOCK, SABERLOCK_WIN)
                defAnim = G_SaberLockAnim(defender.client!.ps.fd.saberAnimLevel, attacker.client!.ps.fd.saberAnimLevel, SABERLOCK_TOP, SABERLOCK_LOCK, SABERLOCK_LOSE)
                defStart = 0.5
                attStart = defStart
            } else {
                //side lock
                switch lockMode {
                case LOCK_DIAG_TR:
                    attAnim = G_SaberLockAnim(attacker.client!.ps.fd.saberAnimLevel, defender.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_WIN)
                    defAnim = G_SaberLockAnim(defender.client!.ps.fd.saberAnimLevel, attacker.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_LOSE)
                    defStart = 0.5
                    attStart = defStart

                case LOCK_DIAG_TL:
                    attAnim = G_SaberLockAnim(attacker.client!.ps.fd.saberAnimLevel, defender.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_LOSE)
                    defAnim = G_SaberLockAnim(defender.client!.ps.fd.saberAnimLevel, attacker.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_WIN)
                    defStart = 0.5
                    attStart = defStart

                case LOCK_DIAG_BR:
                    attAnim = G_SaberLockAnim(attacker.client!.ps.fd.saberAnimLevel, defender.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_WIN)
                    defAnim = G_SaberLockAnim(defender.client!.ps.fd.saberAnimLevel, attacker.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_LOSE)
                    if BG_CheckIncrementLockAnim(attAnim, SABERLOCK_WIN) {
                        attStart = 0.85 //move to end of anim
                    } else {
                        attStart = 0.15 //start at beginning of anim
                    }
                    if BG_CheckIncrementLockAnim(defAnim, SABERLOCK_LOSE) {
                        defStart = 0.85 //start at end of anim
                    } else {
                        defStart = 0.15 //start at beginning of anim
                    }

                case LOCK_DIAG_BL:
                    attAnim = G_SaberLockAnim(attacker.client!.ps.fd.saberAnimLevel, defender.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_LOSE)
                    defAnim = G_SaberLockAnim(defender.client!.ps.fd.saberAnimLevel, attacker.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_WIN)
                    if BG_CheckIncrementLockAnim(attAnim, SABERLOCK_WIN) {
                        attStart = 0.85 //move to end of anim
                    } else {
                        attStart = 0.15 //start at beginning of anim
                    }
                    if BG_CheckIncrementLockAnim(defAnim, SABERLOCK_LOSE) {
                        defStart = 0.85 //start at end of anim
                    } else {
                        defStart = 0.15 //start at beginning of anim
                    }

                case LOCK_R:
                    attAnim = G_SaberLockAnim(attacker.client!.ps.fd.saberAnimLevel, defender.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_LOSE)
                    defAnim = G_SaberLockAnim(defender.client!.ps.fd.saberAnimLevel, attacker.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_WIN)
                    if BG_CheckIncrementLockAnim(attAnim, SABERLOCK_WIN) {
                        attStart = 0.75 //move to end of anim
                    } else {
                        attStart = 0.25 //start at beginning of anim
                    }
                    if BG_CheckIncrementLockAnim(defAnim, SABERLOCK_LOSE) {
                        defStart = 0.75 //start at end of anim
                    } else {
                        defStart = 0.25 //start at beginning of anim
                    }

                case LOCK_L:
                    attAnim = G_SaberLockAnim(attacker.client!.ps.fd.saberAnimLevel, defender.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_WIN)
                    defAnim = G_SaberLockAnim(defender.client!.ps.fd.saberAnimLevel, attacker.client!.ps.fd.saberAnimLevel, SABERLOCK_SIDE, SABERLOCK_LOCK, SABERLOCK_LOSE)
                    //attacker starts with advantage
                    if BG_CheckIncrementLockAnim(attAnim, SABERLOCK_WIN) {
                        attStart = 0.75 //move to end of anim
                    } else {
                        attStart = 0.25 //start at beginning of anim
                    }
                    if BG_CheckIncrementLockAnim(defAnim, SABERLOCK_LOSE) {
                        defStart = 0.75 //start at end of anim
                    } else {
                        defStart = 0.25 //start at beginning of anim
                    }

                default:
                    return false
                }
            }
        }

        G_SetAnim(attacker, nil, SETANIM_BOTH, attAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
        attacker.client!.ps.saberLockFrame = Int32(bgAllAnims[attacker.localAnimIndex].animsSlots[attAnim].firstFrame + (bgAllAnims[attacker.localAnimIndex].animsSlots[attAnim].numFrames * attStart))

        G_SetAnim(defender, nil, SETANIM_BOTH, defAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
        defender.client!.ps.saberLockFrame = Int32(bgAllAnims[defender.localAnimIndex].animsSlots[defAnim].firstFrame + (bgAllAnims[defender.localAnimIndex].animsSlots[defAnim].numFrames * defStart))

        attacker.client!.ps.saberLockHits = 0
        defender.client!.ps.saberLockHits = 0

        attacker.client!.ps.saberLockAdvance = false
        defender.client!.ps.saberLockAdvance = false

        attacker.client!.ps.velocity = vec3_t()
        defender.client!.ps.velocity = vec3_t()
        defender.client!.ps.saberLockTime = level.time + 10000
        attacker.client!.ps.saberLockTime = defender.client!.ps.saberLockTime
        attacker.client!.ps.saberLockEnemy = defender.s.number
        defender.client!.ps.saberLockEnemy = attacker.s.number
        defender.client!.ps.weaponTime = Q_irand(1000, 3000) //delay 1 to 3 seconds before pushing
        attacker.client!.ps.weaponTime = defender.client!.ps.weaponTime //delay 1 to 3 seconds before pushing

        defDir = defender.r.currentOrigin - attacker.r.currentOrigin
        attAngles = attacker.client!.ps.viewangles
        attAngles[YAW] = vectoyaw(defDir)
        SetClientViewAngle(attacker, attAngles)
        defAngles[PITCH] = attAngles[PITCH] * -1
        defAngles[YAW] = AngleNormalize180(attAngles[YAW] + 180)
        defAngles[ROLL] = 0
        SetClientViewAngle(defender, defAngles)

        //MATCH POSITIONS
        diff = VectorNormalize(&defDir) - idealDist //diff will be the total error in dist
        //try to move attacker half the diff towards the defender
        _VectorMA(attacker.r.currentOrigin, diff * 0.5, defDir, &newOrg)

        trap_Trace(trace, attacker.r.currentOrigin, attacker.r.mins, attacker.r.maxs, newOrg, attacker.s.number, attacker.clipmask)
        if trace.startsolid == 0 && trace.allsolid == 0 {
            G_SetOrigin(attacker, &trace.endpos)
            if attacker.client != nil {
                attacker.client!.ps.origin = trace.endpos
            }
            trap_LinkEntity(attacker)
        }
        //now get the defender's dist and do it for him too
        attDir = attacker.r.currentOrigin - defender.r.currentOrigin
        diff = VectorNormalize(&attDir) - idealDist //diff will be the total error in dist
        //try to move defender all of the remaining diff towards the attacker
        _VectorMA(defender.r.currentOrigin, diff, attDir, &newOrg)
        trap_Trace(trace, defender.r.currentOrigin, defender.r.mins, defender.r.maxs, newOrg, defender.s.number, defender.clipmask)
        if trace.startsolid == 0 && trace.allsolid == 0 {
            if defender.client != nil {
                defender.client!.ps.origin = trace.endpos
            }
            G_SetOrigin(defender, &trace.endpos)
            trap_LinkEntity(defender)
        }

        //DONE!
        return true
    }
}

/// Source: oracle/codemp/game/w_saber.c:1462
func WP_SabersCheckLock(_ ent1: Entity, _ ent2: Entity) -> Bool {
    let dist: Float
    var ent1BlockingPlayer: Bool = false
    var ent2BlockingPlayer: Bool = false

    if g_debugSaberLocks.integer != 0 {
        WP_SabersCheckLock2(ent1, ent2, LOCK_RANDOM)
        return true
    }
    //for now.. it's not fair to the lone duelist.
    //we need dual saber lock animations.
    if g_gametype.integer == GT_POWERDUEL {
        return false
    }

    if g_saberLocking.integer == 0 {
        return false
    }

    if ent1.client == nil || ent2.client == nil {
        return false
    }

    if ent1.s.eType == ET_NPC || ent2.s.eType == ET_NPC {
        //if either ents is NPC, then never let an NPC lock with someone on the same playerTeam
        if ent1.client!.playerTeam == ent2.client!.playerTeam {
            return false
        }
    }

    if ent1.client!.ps.saberEntityNum == 0 || ent2.client!.ps.saberEntityNum == 0 || ent1.client!.ps.saberInFlight || ent2.client!.ps.saberInFlight {
        //can't get in lock if one of them has had the saber knocked out of his hand
        return false
    }

    if ent1.s.eType != ET_NPC && ent2.s.eType != ET_NPC {
        //can always get into locks with NPCs
        if !ent1.client!.ps.duelInProgress || !ent2.client!.ps.duelInProgress || ent1.client!.ps.duelIndex != ent2.s.number || ent2.client!.ps.duelIndex != ent1.s.number {
            //only allow saber locking if two players are dueling with each other directly
            if g_gametype.integer != GT_DUEL && g_gametype.integer != GT_POWERDUEL {
                return false
            }
        }
    }

    if abs(ent1.r.currentOrigin[2] - ent2.r.currentOrigin[2]) > 16 {
        return false
    }
    if ent1.client!.ps.groundEntityNum == ENTITYNUM_NONE || ent2.client!.ps.groundEntityNum == ENTITYNUM_NONE {
        return false
    }
    dist = DistanceSquared(ent1.r.currentOrigin, ent2.r.currentOrigin)
    if dist < 64 || dist > 6400 {
        //between 8 and 80 from each other
        return false
    }

    if BG_InSpecialJump(ent1.client!.ps.legsAnim) {
        return false
    }
    if BG_InSpecialJump(ent2.client!.ps.legsAnim) {
        return false
    }

    if BG_InRoll(ent1.client!.ps, ent1.client!.ps.legsAnim) {
        return false
    }
    if BG_InRoll(ent2.client!.ps, ent2.client!.ps.legsAnim) {
        return false
    }

    if ent1.client!.ps.forceHandExtend != HANDEXTEND_NONE || ent2.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        return false
    }

    if (ent1.client!.ps.pm_flags & PMF_DUCKED) != 0 || (ent2.client!.ps.pm_flags & PMF_DUCKED) != 0 {
        return false
    }

    if (ent1.client!.saber[0].saberFlags & SFL_NOT_LOCKABLE) != 0 || (ent2.client!.saber[0].saberFlags & SFL_NOT_LOCKABLE) != 0 {
        return false
    }
    // Raven tests `ent1->client->saber[1].model` and `ent1->client->saber[1].model[0]`.
    // Both read as the same Swift test, so the draft writes it once.
    if !ent1.client!.saber[1].model.isEmpty && ent1.client!.ps.saberHolstered == 0 && (ent1.client!.saber[1].saberFlags & SFL_NOT_LOCKABLE) != 0 {
        return false
    }
    // Raven tests `ent2->client->saber[1].model` and `ent2->client->saber[1].model[0]`.
    // Both read as the same Swift test, so the draft writes it once.
    if !ent2.client!.saber[1].model.isEmpty && ent2.client!.ps.saberHolstered == 0 && (ent2.client!.saber[1].saberFlags & SFL_NOT_LOCKABLE) != 0 {
        return false
    }

    if !InFront(ent1.client!.ps.origin, ent2.client!.ps.origin, ent2.client!.ps.viewangles, 0.4) {
        return false
    }
    if !InFront(ent2.client!.ps.origin, ent1.client!.ps.origin, ent1.client!.ps.viewangles, 0.4) {
        return false
    }

    //T to B lock
    if ent1.client!.ps.torsoAnim == BOTH_A1_T__B_ || ent1.client!.ps.torsoAnim == BOTH_A2_T__B_ || ent1.client!.ps.torsoAnim == BOTH_A3_T__B_ || ent1.client!.ps.torsoAnim == BOTH_A4_T__B_ || ent1.client!.ps.torsoAnim == BOTH_A5_T__B_ || ent1.client!.ps.torsoAnim == BOTH_A6_T__B_ || ent1.client!.ps.torsoAnim == BOTH_A7_T__B_ {
        //ent1 is attacking top-down
        return WP_SabersCheckLock2(ent1, ent2, LOCK_TOP)
    }

    if ent2.client!.ps.torsoAnim == BOTH_A1_T__B_ || ent2.client!.ps.torsoAnim == BOTH_A2_T__B_ || ent2.client!.ps.torsoAnim == BOTH_A3_T__B_ || ent2.client!.ps.torsoAnim == BOTH_A4_T__B_ || ent2.client!.ps.torsoAnim == BOTH_A5_T__B_ || ent2.client!.ps.torsoAnim == BOTH_A6_T__B_ || ent2.client!.ps.torsoAnim == BOTH_A7_T__B_ {
        //ent2 is attacking top-down
        return WP_SabersCheckLock2(ent2, ent1, LOCK_TOP)
    }

    if ent1.s.number == 0 && ent1.client!.ps.saberBlocking == BLK_WIDE && ent1.client!.ps.weaponTime <= 0 {
        ent1BlockingPlayer = true
    }
    if ent2.s.number == 0 && ent2.client!.ps.saberBlocking == BLK_WIDE && ent2.client!.ps.weaponTime <= 0 {
        ent2BlockingPlayer = true
    }

    //TR to BL lock
    if ent1.client!.ps.torsoAnim == BOTH_A1_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A2_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A3_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A4_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A5_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A6_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A7_TR_BL {
        //ent1 is attacking diagonally
        if ent2BlockingPlayer {
            //player will block this anyway
            return WP_SabersCheckLock2(ent1, ent2, LOCK_DIAG_TR)
        }
        if ent2.client!.ps.torsoAnim == BOTH_A1_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A2_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A3_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A4_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A5_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A6_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A7_TR_BL || ent2.client!.ps.torsoAnim == BOTH_P1_S1_TL {
            //ent2 is attacking in the opposite diagonal
            return WP_SabersCheckLock2(ent1, ent2, LOCK_DIAG_TR)
        }
        if ent2.client!.ps.torsoAnim == BOTH_A1_BR_TL || ent2.client!.ps.torsoAnim == BOTH_A2_BR_TL || ent2.client!.ps.torsoAnim == BOTH_A3_BR_TL || ent2.client!.ps.torsoAnim == BOTH_A4_BR_TL || ent2.client!.ps.torsoAnim == BOTH_A5_BR_TL || ent2.client!.ps.torsoAnim == BOTH_A6_BR_TL || ent2.client!.ps.torsoAnim == BOTH_A7_BR_TL || ent2.client!.ps.torsoAnim == BOTH_P1_S1_BL {
            //ent2 is attacking in the opposite diagonal
            return WP_SabersCheckLock2(ent1, ent2, LOCK_DIAG_BL)
        }
        return false
    }

    if ent2.client!.ps.torsoAnim == BOTH_A1_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A2_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A3_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A4_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A5_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A6_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A7_TR_BL {
        //ent2 is attacking diagonally
        if ent1BlockingPlayer {
            //player will block this anyway
            return WP_SabersCheckLock2(ent2, ent1, LOCK_DIAG_TR)
        }
        if ent1.client!.ps.torsoAnim == BOTH_A1_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A2_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A3_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A4_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A5_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A6_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A7_TR_BL || ent1.client!.ps.torsoAnim == BOTH_P1_S1_TL {
            //ent1 is attacking in the opposite diagonal
            return WP_SabersCheckLock2(ent2, ent1, LOCK_DIAG_TR)
        }
        if ent1.client!.ps.torsoAnim == BOTH_A1_BR_TL || ent1.client!.ps.torsoAnim == BOTH_A2_BR_TL || ent1.client!.ps.torsoAnim == BOTH_A3_BR_TL || ent1.client!.ps.torsoAnim == BOTH_A4_BR_TL || ent1.client!.ps.torsoAnim == BOTH_A5_BR_TL || ent1.client!.ps.torsoAnim == BOTH_A6_BR_TL || ent1.client!.ps.torsoAnim == BOTH_A7_BR_TL || ent1.client!.ps.torsoAnim == BOTH_P1_S1_BL {
            //ent1 is attacking in the opposite diagonal
            return WP_SabersCheckLock2(ent2, ent1, LOCK_DIAG_BL)
        }
        return false
    }

    //TL to BR lock
    if ent1.client!.ps.torsoAnim == BOTH_A1_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A2_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A3_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A4_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A5_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A6_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A7_TL_BR {
        //ent1 is attacking diagonally
        if ent2BlockingPlayer {
            //player will block this anyway
            return WP_SabersCheckLock2(ent1, ent2, LOCK_DIAG_TL)
        }
        if ent2.client!.ps.torsoAnim == BOTH_A1_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A2_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A3_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A4_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A5_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A6_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A7_TL_BR || ent2.client!.ps.torsoAnim == BOTH_P1_S1_TR {
            //ent2 is attacking in the opposite diagonal
            return WP_SabersCheckLock2(ent1, ent2, LOCK_DIAG_TL)
        }
        if ent2.client!.ps.torsoAnim == BOTH_A1_BL_TR || ent2.client!.ps.torsoAnim == BOTH_A2_BL_TR || ent2.client!.ps.torsoAnim == BOTH_A3_BL_TR || ent2.client!.ps.torsoAnim == BOTH_A4_BL_TR || ent2.client!.ps.torsoAnim == BOTH_A5_BL_TR || ent2.client!.ps.torsoAnim == BOTH_A6_BL_TR || ent2.client!.ps.torsoAnim == BOTH_A7_BL_TR || ent2.client!.ps.torsoAnim == BOTH_P1_S1_BR {
            //ent2 is attacking in the opposite diagonal
            return WP_SabersCheckLock2(ent1, ent2, LOCK_DIAG_BR)
        }
        return false
    }

    if ent2.client!.ps.torsoAnim == BOTH_A1_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A2_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A3_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A4_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A5_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A6_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A7_TL_BR {
        //ent2 is attacking diagonally
        if ent1BlockingPlayer {
            //player will block this anyway
            return WP_SabersCheckLock2(ent2, ent1, LOCK_DIAG_TL)
        }
        if ent1.client!.ps.torsoAnim == BOTH_A1_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A2_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A3_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A4_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A5_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A6_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A7_TL_BR || ent1.client!.ps.torsoAnim == BOTH_P1_S1_TR {
            //ent1 is attacking in the opposite diagonal
            return WP_SabersCheckLock2(ent2, ent1, LOCK_DIAG_TL)
        }
        if ent1.client!.ps.torsoAnim == BOTH_A1_BL_TR || ent1.client!.ps.torsoAnim == BOTH_A2_BL_TR || ent1.client!.ps.torsoAnim == BOTH_A3_BL_TR || ent1.client!.ps.torsoAnim == BOTH_A4_BL_TR || ent1.client!.ps.torsoAnim == BOTH_A5_BL_TR || ent1.client!.ps.torsoAnim == BOTH_A6_BL_TR || ent1.client!.ps.torsoAnim == BOTH_A7_BL_TR || ent1.client!.ps.torsoAnim == BOTH_P1_S1_BR {
            //ent1 is attacking in the opposite diagonal
            return WP_SabersCheckLock2(ent2, ent1, LOCK_DIAG_BR)
        }
        return false
    }
    //L to R lock
    if ent1.client!.ps.torsoAnim == BOTH_A1__L__R || ent1.client!.ps.torsoAnim == BOTH_A2__L__R || ent1.client!.ps.torsoAnim == BOTH_A3__L__R || ent1.client!.ps.torsoAnim == BOTH_A4__L__R || ent1.client!.ps.torsoAnim == BOTH_A5__L__R || ent1.client!.ps.torsoAnim == BOTH_A6__L__R || ent1.client!.ps.torsoAnim == BOTH_A7__L__R {
        //ent1 is attacking l to r
        if ent2BlockingPlayer {
            //player will block this anyway
            return WP_SabersCheckLock2(ent1, ent2, LOCK_L)
        }
        if ent2.client!.ps.torsoAnim == BOTH_A1_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A2_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A3_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A4_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A5_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A6_TL_BR || ent2.client!.ps.torsoAnim == BOTH_A7_TL_BR || ent2.client!.ps.torsoAnim == BOTH_P1_S1_TR || ent2.client!.ps.torsoAnim == BOTH_P1_S1_BL {
            //ent2 is attacking or blocking on the r
            return WP_SabersCheckLock2(ent1, ent2, LOCK_L)
        }
        return false
    }
    if ent2.client!.ps.torsoAnim == BOTH_A1__L__R || ent2.client!.ps.torsoAnim == BOTH_A2__L__R || ent2.client!.ps.torsoAnim == BOTH_A3__L__R || ent2.client!.ps.torsoAnim == BOTH_A4__L__R || ent2.client!.ps.torsoAnim == BOTH_A5__L__R || ent2.client!.ps.torsoAnim == BOTH_A6__L__R || ent2.client!.ps.torsoAnim == BOTH_A7__L__R {
        //ent2 is attacking l to r
        if ent1BlockingPlayer {
            //player will block this anyway
            return WP_SabersCheckLock2(ent2, ent1, LOCK_L)
        }
        if ent1.client!.ps.torsoAnim == BOTH_A1_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A2_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A3_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A4_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A5_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A6_TL_BR || ent1.client!.ps.torsoAnim == BOTH_A7_TL_BR || ent1.client!.ps.torsoAnim == BOTH_P1_S1_TR || ent1.client!.ps.torsoAnim == BOTH_P1_S1_BL {
            //ent1 is attacking or blocking on the r
            return WP_SabersCheckLock2(ent2, ent1, LOCK_L)
        }
        return false
    }
    //R to L lock
    if ent1.client!.ps.torsoAnim == BOTH_A1__R__L || ent1.client!.ps.torsoAnim == BOTH_A2__R__L || ent1.client!.ps.torsoAnim == BOTH_A3__R__L || ent1.client!.ps.torsoAnim == BOTH_A4__R__L || ent1.client!.ps.torsoAnim == BOTH_A5__R__L || ent1.client!.ps.torsoAnim == BOTH_A6__R__L || ent1.client!.ps.torsoAnim == BOTH_A7__R__L {
        //ent1 is attacking r to l
        if ent2BlockingPlayer {
            //player will block this anyway
            return WP_SabersCheckLock2(ent1, ent2, LOCK_R)
        }
        if ent2.client!.ps.torsoAnim == BOTH_A1_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A2_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A3_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A4_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A5_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A6_TR_BL || ent2.client!.ps.torsoAnim == BOTH_A7_TR_BL || ent2.client!.ps.torsoAnim == BOTH_P1_S1_TL || ent2.client!.ps.torsoAnim == BOTH_P1_S1_BR {
            //ent2 is attacking or blocking on the l
            return WP_SabersCheckLock2(ent1, ent2, LOCK_R)
        }
        return false
    }
    if ent2.client!.ps.torsoAnim == BOTH_A1__R__L || ent2.client!.ps.torsoAnim == BOTH_A2__R__L || ent2.client!.ps.torsoAnim == BOTH_A3__R__L || ent2.client!.ps.torsoAnim == BOTH_A4__R__L || ent2.client!.ps.torsoAnim == BOTH_A5__R__L || ent2.client!.ps.torsoAnim == BOTH_A6__R__L || ent2.client!.ps.torsoAnim == BOTH_A7__R__L {
        //ent2 is attacking r to l
        if ent1BlockingPlayer {
            //player will block this anyway
            return WP_SabersCheckLock2(ent2, ent1, LOCK_R)
        }
        if ent1.client!.ps.torsoAnim == BOTH_A1_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A2_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A3_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A4_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A5_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A6_TR_BL || ent1.client!.ps.torsoAnim == BOTH_A7_TR_BL || ent1.client!.ps.torsoAnim == BOTH_P1_S1_TL || ent1.client!.ps.torsoAnim == BOTH_P1_S1_BR {
            //ent1 is attacking or blocking on the l
            return WP_SabersCheckLock2(ent2, ent1, LOCK_R)
        }
        return false
    }
    if Q_irand(0, 10) == 0 {
        return WP_SabersCheckLock2(ent1, ent2, LOCK_RANDOM)
    }
    return false
}

/// Source: oracle/codemp/game/w_saber.c:1891
private func G_GetParryForBlock(_ block: Int32) -> Int32 {
    switch block {
    case BLOCKED_UPPER_RIGHT:
        return LS_PARRY_UR

    case BLOCKED_UPPER_RIGHT_PROJ:
        return LS_REFLECT_UR

    case BLOCKED_UPPER_LEFT:
        return LS_PARRY_UL

    case BLOCKED_UPPER_LEFT_PROJ:
        return LS_REFLECT_UL

    case BLOCKED_LOWER_RIGHT:
        return LS_PARRY_LR

    case BLOCKED_LOWER_RIGHT_PROJ:
        return LS_REFLECT_LR

    case BLOCKED_LOWER_LEFT:
        return LS_PARRY_LL

    case BLOCKED_LOWER_LEFT_PROJ:
        return LS_REFLECT_LL

    case BLOCKED_TOP:
        return LS_PARRY_UP

    case BLOCKED_TOP_PROJ:
        return LS_REFLECT_UP

    default:
        break
    }

    return LS_NONE
}

/// Source: oracle/codemp/game/w_saber.c:1938
private func WP_GetSaberDeflectionAngle(_ attacker: Entity, _ defender: Entity, _ saberHitFraction: Float) -> Bool {
    let animBasedDeflection: Bool = true
    let attSaberLevel: Int32
    let defSaberLevel: Int32

    if attacker.client == nil || attacker.ghoul2 == nil {
        return false
    }
    if defender.client == nil || defender.ghoul2 == nil {
        return false
    }

    if (level.time - attacker.client!.lastSaberStorageTime) > 500 {
        //last update was too long ago, something is happening to this client to prevent his saber from updating
        return false
    }
    if (level.time - defender.client!.lastSaberStorageTime) > 500 {
        //ditto
        return false
    }

    attSaberLevel = G_SaberAttackPower(attacker, SaberAttacking(attacker))
    defSaberLevel = G_SaberAttackPower(defender, SaberAttacking(defender))

    if animBasedDeflection {
        //Hmm, let's try just basing it off the anim
        let attQuadStart: Int32 = saberMoveData[attacker.client!.ps.saberMove].startQuad
        let attQuadEnd: Int32 = saberMoveData[attacker.client!.ps.saberMove].endQuad
        var defQuad: Int32 = saberMoveData[defender.client!.ps.saberMove].endQuad
        var quadDiff: Int32 = Int32(abs(Float((defQuad - attQuadStart))))

        if defender.client!.ps.saberMove == LS_READY {
            //FIXME: we should probably do SOMETHING here...
            //I have this return qfalse here in the hopes that
            //the defender will pick a parry and the attacker
            //will hit the defender's saber again.
            //But maybe this func call should come *after*
            //it's decided whether or not the defender is
            //going to parry.
            return false
        }

        //reverse the left/right of the defQuad because of the mirrored nature of facing each other in combat
        switch defQuad {
        case Q_BR:
            defQuad = Q_BL

        case Q_R:
            defQuad = Q_L

        case Q_TR:
            defQuad = Q_TL

        case Q_TL:
            defQuad = Q_TR

        case Q_L:
            defQuad = Q_R

        case Q_BL:
            defQuad = Q_BR

        default:
            break
        }

        if quadDiff > 4 {
            //wrap around so diff is never greater than 180 (4 * 45)
            quadDiff = 4 - (quadDiff - 4)
        }
        //have the quads, find a good anim to use
        if (quadDiff == 0 || (quadDiff == 1 && Q_irand(0, 1) != 0)) && (defSaberLevel == attSaberLevel || Q_irand(0, defSaberLevel - attSaberLevel) >= 0) {
            //bounce straight back
            let attMove: Int32 = attacker.client!.ps.saberMove
            attacker.client!.ps.saberMove = PM_SaberBounceForAttack(attacker.client!.ps.saberMove)
            if g_saberDebugPrint.integer != 0 {
                Com_Printf("attack %s vs. parry %s bounced to %s\n", animTable[saberMoveData[attMove].animToUse].name!, animTable[saberMoveData[defender.client!.ps.saberMove].animToUse].name!, animTable[saberMoveData[attacker.client!.ps.saberMove].animToUse].name!)
            }
            attacker.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
            return false
        } else {
            //attack hit at an angle, figure out what angle it should bounce off att
            var newQuad: Int32
            quadDiff = defQuad - attQuadEnd
            //add half the diff of between the defense and attack end to the attack end
            if quadDiff > 4 {
                quadDiff = 4 - (quadDiff - 4)
            } else if quadDiff < -4 {
                quadDiff = -4 + (quadDiff + 4)
            }
            newQuad = Int32(attQuadEnd + ceil((Float(quadDiff)) / 2.0))
            if newQuad < Q_BR {
                //less than zero wraps around
                newQuad = Q_B + newQuad
            }
            if newQuad == attQuadStart {
                //never come off at the same angle that we would have if the attack was not interrupted
                if Q_irand(0, 1) != 0 {
                    newQuad -= 1
                } else {
                    newQuad += 1
                }
                if newQuad < Q_BR {
                    newQuad = Q_B
                } else if newQuad > Q_B {
                    newQuad = Q_BR
                }
            }
            if newQuad == defQuad {
                //bounce straight back
                let attMove: Int32 = attacker.client!.ps.saberMove
                attacker.client!.ps.saberMove = PM_SaberBounceForAttack(attacker.client!.ps.saberMove)
                if g_saberDebugPrint.integer != 0 {
                    Com_Printf("attack %s vs. parry %s bounced to %s\n", animTable[saberMoveData[attMove].animToUse].name!, animTable[saberMoveData[defender.client!.ps.saberMove].animToUse].name!, animTable[saberMoveData[attacker.client!.ps.saberMove].animToUse].name!)
                }
                attacker.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
                return false
            } else {
                //else, pick a deflection
                let attMove: Int32 = attacker.client!.ps.saberMove
                attacker.client!.ps.saberMove = PM_SaberDeflectionForQuad(newQuad)
                if g_saberDebugPrint.integer != 0 {
                    Com_Printf("attack %s vs. parry %s deflected to %s\n", animTable[saberMoveData[attMove].animToUse].name!, animTable[saberMoveData[defender.client!.ps.saberMove].animToUse].name!, animTable[saberMoveData[attacker.client!.ps.saberMove].animToUse].name!)
                }
                attacker.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE
                return true
            }
        }
    } else {
        //old math-based method (probably broken)
        var att_HitDir = vec3_t()
        var def_BladeDir = vec3_t()
        var temp = vec3_t()
        let hitDot: Float

        temp = attacker.client!.lastSaberBase_Always

        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(attacker.client!.lastSaberDir_Always, &att_HitDir, &scratchRight, &scratchUp)

        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight2 = vec3_t()
        var scratchUp2 = vec3_t()
        AngleVectors(defender.client!.lastSaberDir_Always, &def_BladeDir, &scratchRight2, &scratchUp2)

        //now compare
        hitDot = _DotProduct(att_HitDir, def_BladeDir)
        if hitDot < 0.25 && hitDot > -0.25 {
            //hit pretty much perpendicular, pop straight back
            attacker.client!.ps.saberMove = PM_SaberBounceForAttack(attacker.client!.ps.saberMove)
            attacker.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
            return false
        } else {
            //a deflection
            var att_Right = vec3_t()
            var att_Up = vec3_t()
            var att_DeflectionDir = vec3_t()
            let swingRDot: Float
            let swingUDot: Float

            //get the direction of the deflection
            att_DeflectionDir = def_BladeDir * hitDot
            //get our bounce straight back direction
            temp = att_HitDir * -1.0
            //add the bounce back and deflection
            att_DeflectionDir = att_DeflectionDir + temp
            //normalize the result to determine what direction our saber should bounce back toward
            VectorNormalize(&att_DeflectionDir)

            //need to know the direction of the deflectoin relative to the attacker's facing
            temp = vec3_t(0, attacker.client!.ps.viewangles[YAW], 0) //presumes no pitch!
            // Raven passes NULL for the `forward` output.
            var scratchForward = vec3_t()
            AngleVectors(temp, &scratchForward, &att_Right, &att_Up)
            swingRDot = _DotProduct(att_Right, att_DeflectionDir)
            swingUDot = _DotProduct(att_Up, att_DeflectionDir)

            if swingRDot > 0.25 {
                //deflect to right
                if swingUDot > 0.25 {
                    //deflect to top
                    attacker.client!.ps.saberMove = LS_D1_TR
                } else if swingUDot < -0.25 {
                    //deflect to bottom
                    attacker.client!.ps.saberMove = LS_D1_BR
                } else {
                    //deflect horizontally
                    attacker.client!.ps.saberMove = LS_D1__R
                }
            } else if swingRDot < -0.25 {
                //deflect to left
                if swingUDot > 0.25 {
                    //deflect to top
                    attacker.client!.ps.saberMove = LS_D1_TL
                } else if swingUDot < -0.25 {
                    //deflect to bottom
                    attacker.client!.ps.saberMove = LS_D1_BL
                } else {
                    //deflect horizontally
                    attacker.client!.ps.saberMove = LS_D1__L
                }
            } else {
                //deflect in middle
                if swingUDot > 0.25 {
                    //deflect to top
                    attacker.client!.ps.saberMove = LS_D1_T_
                } else if swingUDot < -0.25 {
                    //deflect to bottom
                    attacker.client!.ps.saberMove = LS_D1_B_
                } else {
                    //deflect horizontally?  Well, no such thing as straight back in my face, so use top
                    if swingRDot > 0 {
                        attacker.client!.ps.saberMove = LS_D1_TR
                    } else if swingRDot < 0 {
                        attacker.client!.ps.saberMove = LS_D1_TL
                    } else {
                        attacker.client!.ps.saberMove = LS_D1_T_
                    }
                }
            }

            attacker.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE
            return true
        }
    }
}

/// Source: oracle/codemp/game/w_saber.c:2210
func G_KnockawayForParry(_ move: Int32) -> Int32 {
    //FIXME: need actual anims for this
    //FIXME: need to know which side of the saber was hit!  For now, we presume the saber gets knocked away from the center
    switch move {
    case LS_PARRY_UP:
        return LS_K1_T_ //push up

    case LS_PARRY_UL:
        return LS_K1_TL //push up and to left

    case LS_PARRY_LR:
        return LS_K1_BR //push down and to left

    case LS_PARRY_LL:
        return LS_K1_BL //push down and to right

    default:
        return LS_K1_TR //push up, slightly to right
    }
}

//For strong attacks, we ramp damage based on the point in the attack animation
/// Source: oracle/codemp/game/w_saber.c:2238
private func G_GetAttackDamage(_ `self`: Entity, _ minDmg: Int32, _ maxDmg: Int32, _ multPoint: Float) -> Int32 {
    var peakDif: Int32 = 0
    var speedDif: Int32 = 0
    var totalDamage: Int32 = maxDmg
    var peakPoint: Float = 0
    var attackAnimLength: Float = bgAllAnims[`self`.localAnimIndex].animsSlots[`self`.client!.ps.torsoAnim].numFrames * abs(Float((bgAllAnims[`self`.localAnimIndex].animsSlots[`self`.client!.ps.torsoAnim].frameLerp)))
    var currentPoint: Float = 0
    var damageFactor: Float = 0
    var animSpeedFactor: Float = 1.0

    //Be sure to scale by the proper anim speed just as if we were going to play the animation
    BG_SaberStartTransAnim(`self`.s.number, `self`.client!.ps.fd.saberAnimLevel, `self`.client!.ps.weapon, `self`.client!.ps.torsoAnim, &animSpeedFactor, `self`.client!.ps.brokenLimbs)
    speedDif = Int32(attackAnimLength - (attackAnimLength * animSpeedFactor))
    attackAnimLength += speedDif
    peakPoint = attackAnimLength
    peakPoint -= attackAnimLength * multPoint

    //we treat torsoTimer as the point in the animation (closer it is to attackAnimLength, closer it is to beginning)
    currentPoint = Float(`self`.client!.ps.torsoTimer)

    if peakPoint > currentPoint {
        peakDif = Int32((peakPoint - currentPoint))
    } else {
        peakDif = Int32((currentPoint - peakPoint))
    }

    damageFactor = Float(((currentPoint / peakPoint)))
    if damageFactor > 1 {
        damageFactor = (2.0 - damageFactor)
    }

    totalDamage = Int32(totalDamage * damageFactor)
    if totalDamage < minDmg {
        totalDamage = minDmg
    }
    if totalDamage > maxDmg {
        totalDamage = maxDmg
    }

    //Com_Printf("%i\n", totalDamage);

    return totalDamage
}

//Get the point in the animation and return a percentage of the current point in the anim between 0 and the total anim length (0.0f - 1.0f)
/// Source: oracle/codemp/game/w_saber.c:2290
private func G_GetAnimPoint(_ `self`: Entity) -> Float {
    var speedDif: Int32 = 0
    var attackAnimLength: Float = bgAllAnims[`self`.localAnimIndex].animsSlots[`self`.client!.ps.torsoAnim].numFrames * abs(Float((bgAllAnims[`self`.localAnimIndex].animsSlots[`self`.client!.ps.torsoAnim].frameLerp)))
    var currentPoint: Float = 0
    var animSpeedFactor: Float = 1.0
    var animPercentage: Float = 0

    //Be sure to scale by the proper anim speed just as if we were going to play the animation
    BG_SaberStartTransAnim(`self`.s.number, `self`.client!.ps.fd.saberAnimLevel, `self`.client!.ps.weapon, `self`.client!.ps.torsoAnim, &animSpeedFactor, `self`.client!.ps.brokenLimbs)
    speedDif = Int32(attackAnimLength - (attackAnimLength * animSpeedFactor))
    attackAnimLength += speedDif

    currentPoint = Float(`self`.client!.ps.torsoTimer)

    animPercentage = currentPoint / attackAnimLength

    //Com_Printf("%f\n", animPercentage);

    return animPercentage
}

/// Source: oracle/codemp/game/w_saber.c:2312
private func G_ClientIdleInWorld(_ ent: Entity) -> Bool {
    if ent.s.eType == ET_NPC {
        return false
    }

    if ent.client!.pers.cmd.upmove == 0 && ent.client!.pers.cmd.forwardmove == 0 && ent.client!.pers.cmd.rightmove == 0 && !((ent.client!.pers.cmd.buttons & BUTTON_GESTURE) != 0) && !((ent.client!.pers.cmd.buttons & BUTTON_FORCEGRIP) != 0) && !((ent.client!.pers.cmd.buttons & BUTTON_ALT_ATTACK) != 0) && !((ent.client!.pers.cmd.buttons & BUTTON_FORCEPOWER) != 0) && !((ent.client!.pers.cmd.buttons & BUTTON_FORCE_LIGHTNING) != 0) && !((ent.client!.pers.cmd.buttons & BUTTON_FORCE_DRAIN) != 0) && !((ent.client!.pers.cmd.buttons & BUTTON_ATTACK) != 0) {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/w_saber.c:2336
private func G_G2TraceCollide(_ tr: JKAMP.Trace, _ lastValidStart: JKAShared.vec3_t, _ lastValidEnd: JKAShared.vec3_t, _ traceMins: JKAShared.vec3_t, _ traceMaxs: JKAShared.vec3_t) -> Bool {
    //Hit the ent with the normal trace, try the collision trace.
    // Port-note: A local `G2Trace_t G2Trace` the table has no type for.
    // Raven wrote: G2Trace_t G2Trace;
    portMissing("G_G2TraceCollide", source: "oracle/codemp/game/w_saber.c:2336")
    var g2Hit: Entity?
    var angles = vec3_t()
    var tN: Int32 = 0
    var fRadius: Float = 0

    if d_saberGhoul2Collision.integer == 0 {
        return false
    }

    if !g_entities[tr.entityNum].inuse {
        //don't do perpoly on corpses.
        return false
    }

    if traceMins[0] != 0 || traceMins[1] != 0 || traceMins[2] != 0 || traceMaxs[0] != 0 || traceMaxs[1] != 0 || traceMaxs[2] != 0 {
        fRadius = (traceMaxs[0] - traceMins[0]) / 2.0
    }

    // Port-note: Raven's `memset (&G2Trace, 0, sizeof(G2Trace))` runs over bytes that are not one record with a view.
    // Raven wrote: memset (&G2Trace, 0, sizeof(G2Trace))
    portMissing("G_G2TraceCollide", source: "oracle/codemp/game/w_saber.c:2336")

    while tN < MAX_G2_COLLISIONS {
        // Port-note: A read of `G2Trace`, a local the draft left as a hole.
        // Raven wrote: G2Trace[tN].mEntityNum = -1
        portMissing("G_G2TraceCollide", source: "oracle/codemp/game/w_saber.c:2336")
        tN += 1
    }
    g2Hit = g_entities[tr.entityNum]

    if g2Hit != nil && g2Hit!.inuse && g2Hit!.ghoul2 != nil {
        var g2HitOrigin = vec3_t()

        angles[PITCH] = 0
        angles[ROLL] = angles[PITCH]

        if g2Hit!.client != nil {
            g2HitOrigin = g2Hit!.client!.ps.origin
            angles[YAW] = g2Hit!.client!.ps.viewangles[YAW]
        } else {
            g2HitOrigin = g2Hit!.r.currentOrigin
            angles[YAW] = g2Hit!.r.currentAngles[YAW]
        }

        if g_optvehtrace.integer != 0 && g2Hit!.s.eType == ET_NPC && g2Hit!.s.NPC_class == CLASS_VEHICLE && g2Hit!.m_pVehicle != nil {
            // Port-note: A read of `G2Trace`, a local the draft left as a hole.
            // Raven wrote: trap_G2API_CollisionDetectCache ( G2Trace, g2Hit->ghoul2, angles, g2HitOrigin, level.time, g2Hit->s.number, lastValidStart, lastValidEnd, g2Hit->modelScale, 0, g_g2TraceLod.integer, fRadius )
            portMissing("G_G2TraceCollide", source: "oracle/codemp/game/w_saber.c:2336")
        } else {
            // Port-note: A read of `G2Trace`, a local the draft left as a hole.
            // Raven wrote: trap_G2API_CollisionDetect ( G2Trace, g2Hit->ghoul2, angles, g2HitOrigin, level.time, g2Hit->s.number, lastValidStart, lastValidEnd, g2Hit->modelScale, 0, g_g2TraceLod.integer, fRadius )
            portMissing("G_G2TraceCollide", source: "oracle/codemp/game/w_saber.c:2336")
        }

        // Port-note: A read of `G2Trace`, a local the draft left as a hole.
        // Raven wrote: if (G2Trace[0].mEntityNum != g2Hit->s.number) { tr->fraction = 1.0f; tr->entityNum = ENTITYNUM_NONE; tr->startsolid = 0; tr->allsolid = 0; return qfalse; } else { //The ghoul2 trace result matches, so copy the collision position into the trace endpos and send it back. VectorCopy(G2Trace[0].mCollisionPosition, tr->endpos); VectorCopy(G2Trace[0].mCollisionNormal, tr->plane.normal); if (g2Hit->client) { g2Hit->client->g2LastSurfaceHit = G2Trace[0].mSurfaceIndex; g2Hit->client->g2LastSurfaceTime = level.time; } return qtrue; }
        portMissing("G_G2TraceCollide", source: "oracle/codemp/game/w_saber.c:2336")
    }

    return false
}

/// Source: oracle/codemp/game/w_saber.c:2428
private func G_SaberInBackAttack(_ move: Int32) -> Bool {
    switch move {
    case LS_A_BACK, LS_A_BACK_CR, LS_A_BACKSTAB:
        return true

    default:
        break
    }

    return false
}

/// Raven's `static saberFace_t faces[12]` of `G_BuildSaberFaces`, which the world keeps between calls.
/// Source: oracle/codemp/game/w_saber.c:2457
var faces: Slots<SaberFace> {
    get { world.faces }
    set { world.faces = newValue }
}

//build faces around blade for collision checking -rww
/// Source: oracle/codemp/game/w_saber.c:2454
private func G_BuildSaberFaces(_ base: JKAShared.vec3_t, _ tip: JKAShared.vec3_t, _ radius: Float, _ fwd: JKAShared.vec3_t, _ right: JKAShared.vec3_t, _ fNum: inout Int32, _ fList: inout SaberFace?) {
    var i: Int32 = 0
    var d1 = vec3_t()
    var d2 = vec3_t()
    var invFwd = vec3_t()
    var invRight = vec3_t()

    invFwd = fwd
    VectorInverse(&invFwd)
    invRight = right
    VectorInverse(&invRight)

    while i < 8 {
        //yeah, this part is kind of a hack, but eh
        if i < 2 {
            //"left" surface
            d1 = fwd
            d2 = invRight
        } else if i < 4 {
            //"right" surface
            d1 = fwd
            d2 = right
        } else if i < 6 {
            //"front" surface
            d1 = right
            d2 = fwd
        } else if i < 8 {
            //"back" surface
            d1 = right
            d2 = invFwd
        }

        //first triangle for this surface
        _VectorMA(base, radius / 2.0, d1, &faces[i].v1)
        _VectorMA(faces[i].v1, radius / 2.0, d2, &faces[i].v1)

        _VectorMA(tip, radius / 2.0, d1, &faces[i].v2)
        _VectorMA(faces[i].v2, radius / 2.0, d2, &faces[i].v2)

        _VectorMA(tip, -radius / 2.0, d1, &faces[i].v3)
        _VectorMA(faces[i].v3, radius / 2.0, d2, &faces[i].v3)

        i += 1

        //second triangle for this surface
        _VectorMA(tip, -radius / 2.0, d1, &faces[i].v1)
        _VectorMA(faces[i].v1, radius / 2.0, d2, &faces[i].v1)

        _VectorMA(base, radius / 2.0, d1, &faces[i].v2)
        _VectorMA(faces[i].v2, radius / 2.0, d2, &faces[i].v2)

        _VectorMA(base, -radius / 2.0, d1, &faces[i].v3)
        _VectorMA(faces[i].v3, radius / 2.0, d2, &faces[i].v3)

        i += 1
    }

    //top surface
    //face 1
    _VectorMA(tip, radius / 2.0, fwd, &faces[i].v1)
    _VectorMA(faces[i].v1, -radius / 2.0, right, &faces[i].v1)

    _VectorMA(tip, radius / 2.0, fwd, &faces[i].v2)
    _VectorMA(faces[i].v2, radius / 2.0, right, &faces[i].v2)

    _VectorMA(tip, -radius / 2.0, fwd, &faces[i].v3)
    _VectorMA(faces[i].v3, -radius / 2.0, right, &faces[i].v3)

    i += 1

    //face 2
    _VectorMA(tip, radius / 2.0, fwd, &faces[i].v1)
    _VectorMA(faces[i].v1, radius / 2.0, right, &faces[i].v1)

    _VectorMA(tip, -radius / 2.0, fwd, &faces[i].v2)
    _VectorMA(faces[i].v2, -radius / 2.0, right, &faces[i].v2)

    _VectorMA(tip, -radius / 2.0, fwd, &faces[i].v3)
    _VectorMA(faces[i].v3, radius / 2.0, right, &faces[i].v3)

    i += 1

    //bottom surface
    //face 1
    _VectorMA(base, radius / 2.0, fwd, &faces[i].v1)
    _VectorMA(faces[i].v1, -radius / 2.0, right, &faces[i].v1)

    _VectorMA(base, radius / 2.0, fwd, &faces[i].v2)
    _VectorMA(faces[i].v2, radius / 2.0, right, &faces[i].v2)

    _VectorMA(base, -radius / 2.0, fwd, &faces[i].v3)
    _VectorMA(faces[i].v3, -radius / 2.0, right, &faces[i].v3)

    i += 1

    //face 2
    _VectorMA(base, radius / 2.0, fwd, &faces[i].v1)
    _VectorMA(faces[i].v1, radius / 2.0, right, &faces[i].v1)

    _VectorMA(base, -radius / 2.0, fwd, &faces[i].v2)
    _VectorMA(faces[i].v2, -radius / 2.0, right, &faces[i].v2)

    _VectorMA(base, -radius / 2.0, fwd, &faces[i].v3)
    _VectorMA(faces[i].v3, radius / 2.0, right, &faces[i].v3)

    i += 1

    //yeah.. always going to be 12 I suppose.
    fNum = i
    fList = faces[0]
}

//collision utility function -rww
/// Source: oracle/codemp/game/w_saber.c:2573
private func G_SabCol_CalcPlaneEq(_ x: JKAShared.vec3_t, _ y: JKAShared.vec3_t, _ z: JKAShared.vec3_t, _ planeEq: inout [Float]) {
    planeEq[0] = x[1] * (y[2] - z[2]) + y[1] * (z[2] - x[2]) + z[1] * (x[2] - y[2])
    planeEq[1] = x[2] * (y[0] - z[0]) + y[2] * (z[0] - x[0]) + z[2] * (x[0] - y[0])
    planeEq[2] = x[0] * (y[1] - z[1]) + y[0] * (z[1] - x[1]) + z[0] * (x[1] - y[1])
    // Raven's one expression is three terms here, because the compiler cannot type-check it whole in reasonable time.
    let termX: Float = x[0] * (y[1] * z[2] - z[1] * y[2])
    let termY: Float = y[0] * (z[1] * x[2] - x[1] * z[2])
    let termZ: Float = z[0] * (x[1] * y[2] - y[1] * x[2])
    planeEq[3] = -(termX + termY + termZ)
}

//collision utility function -rww
/// Source: oracle/codemp/game/w_saber.c:2582
private func G_SabCol_PointRelativeToPlane(_ pos: JKAShared.vec3_t, _ side: inout Float, _ planeEq: inout [Float]) -> Int32 {
    side = planeEq[0] * pos[0] + planeEq[1] * pos[1] + planeEq[2] * pos[2] + planeEq[3]

    if side > 0.0 {
        return 1
    } else if side < 0.0 {
        return -1
    }

    return 0
}

/// Raven's `static float planeEq[4]` of `G_SaberFaceCollisionCheck`, which the world keeps between calls.
/// Source: oracle/codemp/game/w_saber.c:2602
var planeEq: [Float] {
    get { world.planeEq }
    set { world.planeEq = newValue }
}

//do actual collision check using generated saber "faces"
/// Source: oracle/codemp/game/w_saber.c:2599
private func G_SaberFaceCollisionCheck(_ fNum: Int32, _ fList: SaberFace, _ atkStart: JKAShared.vec3_t, _ atkEnd: JKAShared.vec3_t, _ atkMins: inout JKAShared.vec3_t, _ atkMaxs: inout JKAShared.vec3_t, _ impactPoint: inout JKAShared.vec3_t) -> Bool {
    var side: Float = 0
    var side2: Float = 0
    var dist: Float
    var dir = vec3_t()
    var point = vec3_t()
    var i: Int32 = 0
    // Raven steps his `fList` parameter through `faces`, so the body walks an index into that table.
    var fListIndex = faces.index(of: fList)

    if VectorCompare(atkMins, vec3_origin) != 0 && VectorCompare(atkMaxs, vec3_origin) != 0 {
        atkMins = vec3_t(-1.0, -1.0, -1.0)
        atkMaxs = vec3_t(1.0, 1.0, 1.0)
    }

    dir = atkEnd - atkStart

    while i < fNum {
        G_SabCol_CalcPlaneEq(faces[fListIndex].v1, faces[fListIndex].v2, faces[fListIndex].v3, &planeEq)

        if G_SabCol_PointRelativeToPlane(atkStart, &side, &planeEq) != G_SabCol_PointRelativeToPlane(atkEnd, &side2, &planeEq) {
            //start/end points intersect with the plane
            var extruded = vec3_t()
            var minPoint = vec3_t()
            var maxPoint = vec3_t()
            var planeNormal = vec3_t()
            var facing: Int32 = 0

            planeNormal = vec3_t(planeEq[0], planeEq[1], planeEq[2])
            side2 = planeNormal[0] * dir[0] + planeNormal[1] * dir[1] + planeNormal[2] * dir[2]

            dist = side / side2
            _VectorMA(atkStart, -dist, dir, &point)

            minPoint = point + atkMins
            maxPoint = point + atkMaxs

            //point is now the point at which we intersect on the plane.
            //see if that point is within the edges of the face.
            _VectorMA(faces[fListIndex].v1, -2.0, planeNormal, &extruded)
            G_SabCol_CalcPlaneEq(faces[fListIndex].v1, faces[fListIndex].v2, extruded, &planeEq)
            facing = G_SabCol_PointRelativeToPlane(point, &side, &planeEq)

            if facing < 0 {
                //not intersecting.. let's try with the mins/maxs and see if they interesect on the edge plane
                facing = G_SabCol_PointRelativeToPlane(minPoint, &side, &planeEq)
                if facing < 0 {
                    facing = G_SabCol_PointRelativeToPlane(maxPoint, &side, &planeEq)
                }
            }

            if facing >= 0 {
                //first edge is facing...
                _VectorMA(faces[fListIndex].v2, -2.0, planeNormal, &extruded)
                G_SabCol_CalcPlaneEq(faces[fListIndex].v2, faces[fListIndex].v3, extruded, &planeEq)
                facing = G_SabCol_PointRelativeToPlane(point, &side, &planeEq)

                if facing < 0 {
                    //not intersecting.. let's try with the mins/maxs and see if they interesect on the edge plane
                    facing = G_SabCol_PointRelativeToPlane(minPoint, &side, &planeEq)
                    if facing < 0 {
                        facing = G_SabCol_PointRelativeToPlane(maxPoint, &side, &planeEq)
                    }
                }

                if facing >= 0 {
                    //second edge is facing...
                    _VectorMA(faces[fListIndex].v3, -2.0, planeNormal, &extruded)
                    G_SabCol_CalcPlaneEq(faces[fListIndex].v3, faces[fListIndex].v1, extruded, &planeEq)
                    facing = G_SabCol_PointRelativeToPlane(point, &side, &planeEq)

                    if facing < 0 {
                        //not intersecting.. let's try with the mins/maxs and see if they interesect on the edge plane
                        facing = G_SabCol_PointRelativeToPlane(minPoint, &side, &planeEq)
                        if facing < 0 {
                            facing = G_SabCol_PointRelativeToPlane(maxPoint, &side, &planeEq)
                        }
                    }

                    if facing >= 0 {
                        //third edge is facing.. success
                        impactPoint = point
                        return true
                    }
                }
            }
        }

        i += 1
        fListIndex += 1
    }

    //did not hit anything
    return false
}

//check for collision of 2 blades -rww
/// Source: oracle/codemp/game/w_saber.c:2700
private func G_SaberCollide(_ atk: Entity, _ def: Entity, _ atkStart: JKAShared.vec3_t, _ atkEnd: JKAShared.vec3_t, _ atkMins: inout JKAShared.vec3_t, _ atkMaxs: inout JKAShared.vec3_t, _ impactPoint: inout JKAShared.vec3_t) -> Bool {
    var i: Int32
    var j: Int32

    if g_saberBladeFaces.integer == 0 {
        //detailed check not enabled
        return true
    }

    if !atk.inuse || atk.client == nil || !def.inuse || def.client == nil {
        //must have 2 clients and a valid saber entity
        return false
    }

    i = 0
    while i < MAX_SABERS {
        j = 0
        // Raven tests `def->client->saber[i].model` and `def->client->saber[i].model[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if !def.client!.saber[i].model.isEmpty {
            //valid saber on the defender
            var blade: BladeInfo?
            var v = vec3_t()
            var fwd = vec3_t()
            var right = vec3_t()
            var base = vec3_t()
            var tip = vec3_t()
            var fNum: Int32 = 0
            var fList: SaberFace?

            //go through each blade on the defender's sabers
            while j < def.client!.saber[i].numBlades {
                blade = def.client!.saber[i].blade[j]

                if (level.time - blade!.storageTime) < 200 {
                    //recently updated
                    //first get base and tip of blade
                    base = blade!.muzzlePoint
                    _VectorMA(base, blade!.lengthMax, blade!.muzzleDir, &tip)

                    //Now get relative angles between the points
                    v = tip - base
                    vectoangles(v, &v)
                    // Raven passes NULL for the `forward` output.
                    var scratchForward = vec3_t()
                    AngleVectors(v, &scratchForward, &right, &fwd)

                    //now build collision faces for this blade
                    G_BuildSaberFaces(base, tip, blade!.radius * 3.0, fwd, right, &fNum, &fList)
                    if fNum > 0 {
                        if G_SaberFaceCollisionCheck(fNum, fList!, atkStart, atkEnd, &atkMins, &atkMaxs, &impactPoint) {
                            //collided
                            return true
                        }
                    }
                }
                j += 1
            }
        }
        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/w_saber.c:2779
func WP_SaberBladeLength(_ saber: JKAMP.SaberInfo) -> Float {
    //return largest length
    var i: Int32
    var len: Float = 0.0
    i = 0
    while i < saber.numBlades {
        if saber.blade[i].lengthMax > len {
            len = saber.blade[i].lengthMax
        }
        i += 1
    }
    return len
}

/// Source: oracle/codemp/game/w_saber.c:2793
func WP_SaberLength(_ ent: Entity) -> Float {
    //return largest length
    if ent.client == nil {
        return 0.0
    } else {
        var i: Int32
        var len: Float
        var bestLen: Float = 0.0
        i = 0
        while i < MAX_SABERS {
            len = WP_SaberBladeLength(ent.client!.saber[i])
            if len > bestLen {
                bestLen = len
            }
            i += 1
        }
        return bestLen
    }
}

/// Source: oracle/codemp/game/w_saber.c:2814
func WPDEBUG_SaberColor(_ saberColor: JKAMP.saber_colors_t) -> Int32 {
    switch Int32((saberColor)) {
    case SABER_RED:
        return 0x000000ff

    case SABER_ORANGE:
        return 0x000088ff

    case SABER_YELLOW:
        return 0x0000ffff

    case SABER_GREEN:
        return 0x0000ff00

    case SABER_BLUE:
        return 0x00ff0000

    case SABER_PURPLE:
        return 0x00ff00ff

    default:
        return 0x00ffffff //white
    }
}

/// Source: oracle/codemp/game/w_saber.c:2851
func WP_SabersIntersect(_ ent1: Entity, _ ent1SaberNum: Int32, _ ent1BladeNum: Int32, _ ent2: Entity, _ checkDir: Bool) -> Bool {
    var saberBase1 = vec3_t()
    var saberTip1 = vec3_t()
    var saberBaseNext1 = vec3_t()
    var saberTipNext1 = vec3_t()
    var saberBase2 = vec3_t()
    var saberTip2 = vec3_t()
    var saberBaseNext2 = vec3_t()
    var saberTipNext2 = vec3_t()
    var ent2SaberNum: Int32 = 0
    var ent2BladeNum: Int32 = 0
    var dir = vec3_t()

    if ent1.client == nil || ent2.client == nil {
        return false
    }
    if BG_SabersOff(ent1.client!.ps) || BG_SabersOff(ent2.client!.ps) {
        return false
    }

    ent2SaberNum = 0
    while ent2SaberNum < MAX_SABERS {
        if ent2.client!.saber[ent2SaberNum].type != SABER_NONE {
            ent2BladeNum = 0
            while ent2BladeNum < ent2.client!.saber[ent2SaberNum].numBlades {
                if ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].lengthMax > 0 {
                    //valid saber and this blade is on
                    //if ( ent1->client->saberInFlight )
                    do {
                        saberBase1 = ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].muzzlePointOld
                        saberBaseNext1 = ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].muzzlePoint

                        dir = ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].muzzlePoint - ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].muzzlePointOld
                        VectorNormalize(&dir)
                        _VectorMA(saberBaseNext1, SABER_EXTRAPOLATE_DIST, dir, &saberBaseNext1)

                        _VectorMA(saberBase1, ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].lengthMax + SABER_EXTRAPOLATE_DIST, ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].muzzleDirOld, &saberTip1)
                        _VectorMA(saberBaseNext1, ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].lengthMax + SABER_EXTRAPOLATE_DIST, ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].muzzleDir, &saberTipNext1)

                        dir = saberTipNext1 - saberTip1
                        VectorNormalize(&dir)
                        _VectorMA(saberTipNext1, SABER_EXTRAPOLATE_DIST, dir, &saberTipNext1)
                    }
                    /*
                    else
                    {
                    VectorCopy( ent1->client->saber[ent1SaberNum].blade[ent1BladeNum].muzzlePoint, saberBase1 );
                    VectorCopy( ent1->client->saber[ent1SaberNum].blade[ent1BladeNum].muzzlePointNext, saberBaseNext1 );
                    VectorMA( saberBase1, ent1->client->saber[ent1SaberNum].blade[ent1BladeNum].lengthMax, ent1->client->saber[ent1SaberNum].blade[ent1BladeNum].muzzleDir, saberTip1 );
                    VectorMA( saberBaseNext1, ent1->client->saber[ent1SaberNum].blade[ent1BladeNum].lengthMax, ent1->client->saber[ent1SaberNum].blade[ent1BladeNum].muzzleDirNext, saberTipNext1 );
                    }
                    */

                    //if ( ent2->client->saberInFlight )
                    do {
                        saberBase2 = ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].muzzlePointOld
                        saberBaseNext2 = ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].muzzlePoint

                        dir = ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].muzzlePoint - ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].muzzlePointOld
                        VectorNormalize(&dir)
                        _VectorMA(saberBaseNext2, SABER_EXTRAPOLATE_DIST, dir, &saberBaseNext2)

                        _VectorMA(saberBase2, ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].lengthMax + SABER_EXTRAPOLATE_DIST, ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].muzzleDirOld, &saberTip2)
                        _VectorMA(saberBaseNext2, ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].lengthMax + SABER_EXTRAPOLATE_DIST, ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].muzzleDir, &saberTipNext2)

                        dir = saberTipNext2 - saberTip2
                        VectorNormalize(&dir)
                        _VectorMA(saberTipNext2, SABER_EXTRAPOLATE_DIST, dir, &saberTipNext2)
                    }
                    /*
                    else
                    {
                    VectorCopy( ent2->client->saber[ent2SaberNum].blade[ent2BladeNum].muzzlePoint, saberBase2 );
                    VectorCopy( ent2->client->saber[ent2SaberNum].blade[ent2BladeNum].muzzlePointNext, saberBaseNext2 );
                    VectorMA( saberBase2, ent2->client->saber[ent2SaberNum].blade[ent2BladeNum].lengthMax, ent2->client->saber[ent2SaberNum].blade[ent2BladeNum].muzzleDir, saberTip2 );
                    VectorMA( saberBaseNext2, ent2->client->saber[ent2SaberNum].blade[ent2BladeNum].lengthMax, ent2->client->saber[ent2SaberNum].blade[ent2BladeNum].muzzleDirNext, saberTipNext2 );
                    }
                    */
                    if checkDir {
                        //check the direction of the two swings to make sure the sabers are swinging towards each other
                        var saberDir1 = vec3_t()
                        var saberDir2 = vec3_t()
                        var dot: Float = 0.0

                        saberDir1 = saberTipNext1 - saberTip1
                        saberDir2 = saberTipNext2 - saberTip2
                        VectorNormalize(&saberDir1)
                        VectorNormalize(&saberDir2)
                        if _DotProduct(saberDir1, saberDir2) > 0.6 {
                            //sabers moving in same dir, probably didn't actually hit
                            ent2BladeNum += 1
                            continue
                        }
                        //now check orientation of sabers, make sure they're not parallel or close to it
                        dot = _DotProduct(ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].muzzleDir, ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].muzzleDir)
                        if dot > 0.9 || dot < -0.9 {
                            //too parallel to really block effectively?
                            ent2BladeNum += 1
                            continue
                        }
                    }

                    if g_saberDebugBox.integer == 2 || g_saberDebugBox.integer == 4 {
                        G_TestLine(saberBase1, saberTip1, ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].color, 500)
                        G_TestLine(saberTip1, saberTipNext1, ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].color, 500)
                        G_TestLine(saberTipNext1, saberBase1, ent1.client!.saber[ent1SaberNum].blade[ent1BladeNum].color, 500)

                        G_TestLine(saberBase2, saberTip2, ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].color, 500)
                        G_TestLine(saberTip2, saberTipNext2, ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].color, 500)
                        G_TestLine(saberTipNext2, saberBase2, ent2.client!.saber[ent2SaberNum].blade[ent2BladeNum].color, 500)
                    }
                    if tri_tri_intersect(saberBase1, saberTip1, saberBaseNext1, saberBase2, saberTip2, saberBaseNext2) {
                        return true
                    }
                    if tri_tri_intersect(saberBase1, saberTip1, saberBaseNext1, saberBase2, saberTip2, saberTipNext2) {
                        return true
                    }
                    if tri_tri_intersect(saberBase1, saberTip1, saberTipNext1, saberBase2, saberTip2, saberBaseNext2) {
                        return true
                    }
                    if tri_tri_intersect(saberBase1, saberTip1, saberTipNext1, saberBase2, saberTip2, saberTipNext2) {
                        return true
                    }
                }
                ent2BladeNum += 1
            }
        }
        ent2SaberNum += 1
    }
    return false
}

/// Source: oracle/codemp/game/w_saber.c:2987
private func G_PowerLevelForSaberAnim(_ ent: Entity, _ saberNum: Int32, _ mySaberHit: Bool) -> Int32 {
    if ent.client == nil || saberNum >= MAX_SABERS {
        return FORCE_LEVEL_0
    } else {
        let anim: Int32 = ent.client!.ps.torsoAnim
        let animTimer: Int32 = ent.client!.ps.torsoTimer
        let animTimeElapsed: Int32 = BG_AnimLength(ent.localAnimIndex, animNumber_t(anim)) - animTimer
        let saber: SaberInfo? = ent.client!.saber[saberNum]
        if anim >= BOTH_A1_T__B_ && anim <= BOTH_D1_B____ {
            //FIXME: these two need their own style
            if saber!.type == SABER_LANCE {
                return FORCE_LEVEL_4
            } else if saber!.type == SABER_TRIDENT {
                return FORCE_LEVEL_3
            }
            return FORCE_LEVEL_1
        }
        if anim >= BOTH_A2_T__B_ && anim <= BOTH_D2_B____ {
            return FORCE_LEVEL_2
        }
        if anim >= BOTH_A3_T__B_ && anim <= BOTH_D3_B____ {
            return FORCE_LEVEL_3
        }
        if anim >= BOTH_A4_T__B_ && anim <= BOTH_D4_B____ {
            //desann
            return FORCE_LEVEL_4
        }
        if anim >= BOTH_A5_T__B_ && anim <= BOTH_D5_B____ {
            //tavion
            return FORCE_LEVEL_2
        }
        if anim >= BOTH_A6_T__B_ && anim <= BOTH_D6_B____ {
            //dual
            return FORCE_LEVEL_2
        }
        if anim >= BOTH_A7_T__B_ && anim <= BOTH_D7_B____ {
            //staff
            return FORCE_LEVEL_2
        }
        if anim >= BOTH_P1_S1_T_ && anim <= BOTH_H1_S1_BR {
            //parries, knockaways and broken parries
            return FORCE_LEVEL_1 //FIXME: saberAnimLevel?
        }
        switch anim {
        case BOTH_A2_STABBACK1:
            if mySaberHit {
                //someone else hit my saber, not asking for damage level, but defense strength
                return FORCE_LEVEL_1
            }
            if animTimer < 450 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 400 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_ATTACK_BACK:
            if animTimer < 500 {
                //end of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_CROUCHATTACKBACK1:
            if animTimer < 800 {
                //end of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_BUTTERFLY_LEFT, BOTH_BUTTERFLY_RIGHT, BOTH_BUTTERFLY_FL1, BOTH_BUTTERFLY_FR1:
            //FIXME: break up?
            return FORCE_LEVEL_3

        case BOTH_FJSS_TR_BL, BOTH_FJSS_TL_BR:
            //FIXME: break up?
            return FORCE_LEVEL_3

        case BOTH_K1_S1_T_, BOTH_K1_S1_TR, BOTH_K1_S1_TL, BOTH_K1_S1_BL, BOTH_K1_S1_B_, BOTH_K1_S1_BR:
            //FIXME: break up?
            return FORCE_LEVEL_3

        case BOTH_LUNGE2_B__T_:
            if mySaberHit {
                //someone else hit my saber, not asking for damage level, but defense strength
                return FORCE_LEVEL_1
            }
            if animTimer < 400 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 150 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_FORCELEAP2_T__B_:
            if animTimer < 400 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 550 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_VS_ATR_S, BOTH_VS_ATL_S, BOTH_VT_ATR_S, BOTH_VT_ATL_S:
            return FORCE_LEVEL_3 //???

        case BOTH_JUMPFLIPSLASHDOWN1:
            if animTimer <= 1000 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 600 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_JUMPFLIPSTABDOWN:
            if animTimer <= 1300 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed <= 300 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_JUMPATTACK6:
            /*
            if (pm->ps)
            {
            if ( ( pm->ps->legsAnimTimer >= 1450
            && BG_AnimLength( g_entities[ps->clientNum].client->clientInfo.animFileIndex, BOTH_JUMPATTACK6 ) - pm->ps->legsAnimTimer >= 400 )
            ||(pm->ps->legsAnimTimer >= 400
            && BG_AnimLength( g_entities[ps->clientNum].client->clientInfo.animFileIndex, BOTH_JUMPATTACK6 ) - pm->ps->legsAnimTimer >= 1100 ) )
            {//pretty much sideways
            return FORCE_LEVEL_3;
            }
            }
            */
            if (animTimer >= 1450 && animTimeElapsed >= 400) || (animTimer >= 400 && animTimeElapsed >= 1100) {
                //pretty much sideways
                return FORCE_LEVEL_3
            }
            return FORCE_LEVEL_0

        case BOTH_JUMPATTACK7:
            if animTimer <= 1200 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 200 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_SPINATTACK6:
            if animTimeElapsed <= 200 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_2 //FORCE_LEVEL_3;

        case BOTH_SPINATTACK7:
            if animTimer <= 500 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 500 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_2 //FORCE_LEVEL_3;

        case BOTH_FORCELONGLEAP_ATTACK:
            if animTimeElapsed <= 200 {
                //1st four frames of anim
                return FORCE_LEVEL_3
            }
            /*
            case BOTH_A7_KICK_F://these kicks attack, too
            case BOTH_A7_KICK_B:
            case BOTH_A7_KICK_R:
            case BOTH_A7_KICK_L:
            //FIXME: break up
            return FORCE_LEVEL_3;
            break;
            */

        case BOTH_STABDOWN:
            if animTimer <= 900 {
                //end of anim
                return FORCE_LEVEL_3
            }

        case BOTH_STABDOWN_STAFF:
            if animTimer <= 850 {
                //end of anim
                return FORCE_LEVEL_3
            }

        case BOTH_STABDOWN_DUAL:
            if animTimer <= 900 {
                //end of anim
                return FORCE_LEVEL_3
            }

        case BOTH_A6_SABERPROTECT:
            if animTimer < 650 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 250 {
                //start of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_A7_SOULCAL:
            if animTimer < 650 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 600 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_A1_SPECIAL:
            if animTimer < 600 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 200 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_A2_SPECIAL:
            if animTimer < 300 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 200 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_A3_SPECIAL:
            if animTimer < 700 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 200 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_FLIP_ATTACK7:
            return FORCE_LEVEL_3

        case BOTH_PULL_IMPALE_STAB:
            if mySaberHit {
                //someone else hit my saber, not asking for damage level, but defense strength
                return FORCE_LEVEL_1
            }
            if animTimer < 1000 {
                //end of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_PULL_IMPALE_SWING:
            if animTimer < 500 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 650 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_ALORA_SPIN_SLASH:
            if animTimer < 900 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 250 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_A6_FB:
            if mySaberHit {
                //someone else hit my saber, not asking for damage level, but defense strength
                return FORCE_LEVEL_1
            }
            if animTimer < 250 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 250 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_A6_LR:
            if mySaberHit {
                //someone else hit my saber, not asking for damage level, but defense strength
                return FORCE_LEVEL_1
            }
            if animTimer < 250 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 250 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_3

        case BOTH_A7_HILT:
            return FORCE_LEVEL_0
            //===SABERLOCK SUPERBREAKS START===========================================================================

        case BOTH_LK_S_DL_T_SB_1_W:
            if animTimer < 700 {
                //end of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_S_ST_S_SB_1_W:
            if animTimer < 300 {
                //end of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_S_DL_S_SB_1_W, BOTH_LK_S_S_S_SB_1_W:
            if animTimer < 700 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 400 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_S_ST_T_SB_1_W, BOTH_LK_S_S_T_SB_1_W:
            if animTimer < 150 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 400 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_DL_DL_T_SB_1_W:
            return FORCE_LEVEL_5

        case BOTH_LK_DL_DL_S_SB_1_W, BOTH_LK_DL_ST_S_SB_1_W:
            if animTimeElapsed < 1000 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_DL_ST_T_SB_1_W:
            if animTimer < 950 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 650 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_DL_S_S_SB_1_W:
            if saberNum != 0 {
                //only right hand saber does damage in this suberbreak
                return FORCE_LEVEL_0
            }
            if animTimer < 900 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 450 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_DL_S_T_SB_1_W:
            if saberNum != 0 {
                //only right hand saber does damage in this suberbreak
                return FORCE_LEVEL_0
            }
            if animTimer < 250 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 150 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_ST_DL_S_SB_1_W:
            return FORCE_LEVEL_5

        case BOTH_LK_ST_DL_T_SB_1_W:
            //special suberbreak - doesn't kill, just kicks them backwards
            return FORCE_LEVEL_0

        case BOTH_LK_ST_ST_S_SB_1_W, BOTH_LK_ST_S_S_SB_1_W:
            if animTimer < 800 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 350 {
                //beginning of anim
                return FORCE_LEVEL_0
            }
            return FORCE_LEVEL_5

        case BOTH_LK_ST_ST_T_SB_1_W, BOTH_LK_ST_S_T_SB_1_W:
            return FORCE_LEVEL_5
            //===SABERLOCK SUPERBREAKS START===========================================================================

        case BOTH_HANG_ATTACK:
            //FIME: break up
            if animTimer < 1000 {
                //end of anim
                return FORCE_LEVEL_0
            } else if animTimeElapsed < 250 {
                //beginning of anim
                return FORCE_LEVEL_0
            } else {
                //sweet spot
                return FORCE_LEVEL_5
            }

        case BOTH_ROLL_STAB:
            if mySaberHit {
                //someone else hit my saber, not asking for damage level, but defense strength
                return FORCE_LEVEL_1
            }
            if animTimeElapsed > 400 {
                //end of anim
                return FORCE_LEVEL_0
            } else {
                return FORCE_LEVEL_3
            }

        default:
            break
        }
        return FORCE_LEVEL_0
    }
}

/// Source: oracle/codemp/game/w_saber.c:3512
func WP_SaberClearDamage() {
    var ven: Int32
    ven = 0
    while ven < MAX_SABER_VICTIMS {
        victimEntityNum[ven] = ENTITYNUM_NONE
        ven += 1
    }
    victimHitEffectDone.fill(false)
    totalDmg.fill(0)
    dmgDir.fill(vec3_t())
    dmgSpot.fill(vec3_t())
    dismemberDmg.fill(false)
    saberKnockbackFlags.fill(0)
    numVictims = 0
}

/// Source: oracle/codemp/game/w_saber.c:3528
func WP_SaberDamageAdd(_ trVictimEntityNum: Int32, _ trDmgDir: JKAShared.vec3_t, _ trDmgSpot: JKAShared.vec3_t, _ trDmg: Int32, _ doDismemberment: Bool, _ knockBackFlags: Int32) {
    if trVictimEntityNum < 0 || trVictimEntityNum >= ENTITYNUM_WORLD {
        return
    }

    if trDmg != 0 {
        //did some damage to something
        var curVictim: Int32 = 0
        var i: Int32

        i = 0
        while i < numVictims {
            if victimEntityNum[i] == trVictimEntityNum {
                //already hit this guy before
                curVictim = i
                break
            }
            i += 1
        }
        if i == numVictims {
            //haven't hit his guy before
            if numVictims + 1 >= MAX_SABER_VICTIMS {
                //can't add another victim at this time
                return
            }
            //add a new victim to the list
            curVictim = numVictims
            victimEntityNum[numVictims] = trVictimEntityNum
            numVictims += 1
        }

        totalDmg[curVictim] += trDmg
        if VectorCompare(dmgDir[curVictim], vec3_origin) != 0 {
            dmgDir[curVictim] = trDmgDir
        }
        if VectorCompare(dmgSpot[curVictim], vec3_origin) != 0 {
            dmgSpot[curVictim] = trDmgSpot
        }
        if doDismemberment {
            dismemberDmg[curVictim] = true
        }
        saberKnockbackFlags[curVictim] |= knockBackFlags
    }
}

/// Source: oracle/codemp/game/w_saber.c:3577
func WP_SaberApplyDamage(_ `self`: Entity) {
    var i: Int32
    if numVictims == 0 {
        return
    }
    i = 0
    while i < numVictims {
        var victim: Entity? = nil
        var dflags: Int32 = 0

        victim = g_entities[victimEntityNum[i]]

        // nmckenzie: SABER_DAMAGE_WALLS
        if victim!.client == nil {
            totalDmg[i] *= g_saberWallDamageScale.value
        }

        if !dismemberDmg[i] {
            //don't do dismemberment!
            dflags |= DAMAGE_NO_DISMEMBER
        }
        dflags |= saberKnockbackFlags[i]

        G_Damage(victim!, `self`, `self`, &dmgDir[i], dmgSpot[i], Int32(totalDmg[i]), dflags, MOD_SABER)
        i += 1
    }
}

/// Source: oracle/codemp/game/w_saber.c:3608
func WP_SaberDoHit(_ `self`: Entity, _ saberNum: Int32, _ bladeNum: Int32) {
    var i: Int32
    if numVictims == 0 {
        return
    }
    i = 0
    while i < numVictims {
        var te: Entity? = nil
        var victim: Entity? = nil
        var isDroid: Bool = false

        if victimHitEffectDone[i] {
            i += 1
            continue
        }

        victimHitEffectDone[i] = true

        victim = g_entities[victimEntityNum[i]]

        if victim!.client != nil {
            let npc_class: class_t = victim!.client!.NPC_class

            if npc_class == CLASS_SEEKER || npc_class == CLASS_PROBE || npc_class == CLASS_MOUSE || npc_class == CLASS_REMOTE || npc_class == CLASS_GONK || npc_class == CLASS_R2D2 || npc_class == CLASS_R5D2 || npc_class == CLASS_PROTOCOL || npc_class == CLASS_MARK1 || npc_class == CLASS_MARK2 || npc_class == CLASS_INTERROGATOR || npc_class == CLASS_ATST || npc_class == CLASS_SENTRY {
                //don't make "blood" sparks for droids.
                isDroid = true
            }
        }

        te = G_TempEntity(dmgSpot[i], EV_SABER_HIT)
        if te != nil {
            te!.s.otherEntityNum = victimEntityNum[i]
            te!.s.otherEntityNum2 = `self`.s.number
            te!.s.weapon = saberNum
            te!.s.legsAnim = bladeNum

            te!.s.origin = dmgSpot[i]
            //VectorCopy(tr.plane.normal, te->s.angles);
            te!.s.angles = dmgDir[i] * -1

            if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
                //don't let it play with no direction
                te!.s.angles[1] = 1
            }

            if !isDroid && (victim!.client != nil || victim!.s.eType == ET_NPC || victim!.s.eType == ET_BODY) {
                if totalDmg[i] < 5 {
                    te!.s.eventParm = 3
                } else if totalDmg[i] < 20 {
                    te!.s.eventParm = 2
                } else {
                    te!.s.eventParm = 1
                }
            } else {
                if !WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[saberNum], bladeNum) && (`self`.client!.saber[saberNum].saberFlags2 & SFL2_NO_CLASH_FLARE) != 0 {
                    //don't do clash flare
                } else if WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[saberNum], bladeNum) && (`self`.client!.saber[saberNum].saberFlags2 & SFL2_NO_CLASH_FLARE2) != 0 {
                    //don't do clash flare
                } else {
                    if totalDmg[i] > SABER_NONATTACK_DAMAGE {
                        //I suppose I could tie this into the saberblock event, but I'm tired of adding flags to that thing.
                        let teS: Entity? = G_TempEntity(te!.s.origin, EV_SABER_CLASHFLARE)
                        teS!.s.origin = te!.s.origin
                    }
                    te!.s.eventParm = 0
                }
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/w_saber.c:3701
func WP_SaberRadiusDamage(_ ent: Entity, _ point: JKAShared.vec3_t, _ radius: Float, _ damage: Int32, _ knockBack: Float) {
    if ent.client == nil {
        return
    } else if radius <= 0.0 || (damage <= 0 && knockBack <= 0) {
        return
    } else {
        var mins = vec3_t()
        var maxs = vec3_t()
        var entDir = vec3_t()
        var radiusEnts: [Int32] = [Int32](repeating: 0, count: 128)
        var radiusEnt: Entity? = nil
        let numEnts: Int32
        var i: Int32
        var dist: Float

        //Setup the bbox to search in
        i = 0
        while i < 3 {
            mins[i] = point[i] - radius
            maxs[i] = point[i] + radius
            i += 1
        }

        //Get the number of entities in a given space
        numEnts = trap_EntitiesInBox(mins, maxs, &radiusEnts, 128)

        i = 0
        while i < numEnts {
            radiusEnt = g_entities[radiusEnts[i]]
            if !radiusEnt!.inuse {
                i += 1
                continue
            }

            if radiusEnt == ent {
                //Skip myself
                i += 1
                continue
            }

            if radiusEnt!.client == nil {
                //must be a client
                if G_EntIsBreakable(radiusEnt!.s.number) {
                    //damage breakables within range, but not as much
                    // G_Damage writes `dir`, so we pass a copy of `vec3_origin`.
                    var originDir = vec3_origin
                    G_Damage(radiusEnt!, ent, ent, &originDir, radiusEnt!.r.currentOrigin, 10, 0, MOD_MELEE)
                }
                i += 1
                continue
            }

            if (radiusEnt!.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
                //can't be one being held
                i += 1
                continue
            }

            entDir = radiusEnt!.r.currentOrigin - point
            dist = VectorNormalize(&entDir)
            if dist <= radius {
                //in range
                if damage > 0 {
                    //do damage
                    let points: Int32 = Int32(ceil(Float(damage) * dist / radius))
                    // G_Damage writes `dir`, so we pass a copy of `vec3_origin`.
                    var originDir2 = vec3_origin
                    G_Damage(radiusEnt!, ent, ent, &originDir2, radiusEnt!.r.currentOrigin, points, DAMAGE_NO_KNOCKBACK, MOD_MELEE)
                }
                if knockBack > 0 {
                    //do knockback
                    if radiusEnt!.client != nil && radiusEnt!.client!.NPC_class != CLASS_RANCOR && radiusEnt!.client!.NPC_class != CLASS_ATST && !((radiusEnt!.flags & FL_NO_KNOCKBACK) != 0) {
                        let knockbackStr: Float = knockBack * dist / radius
                        entDir[2] += 0.1
                        VectorNormalize(&entDir)
                        G_Throw(radiusEnt!, entDir, knockbackStr)
                        if radiusEnt!.health > 0 {
                            //still alive
                            if knockbackStr > 50 {
                                //close enough and knockback high enough to possibly knock down
                                if dist < (radius * 0.5) || radiusEnt!.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                                    //within range of my fist or within ground-shaking range and not in the air
                                    G_Knockdown(radiusEnt!) //, ent, entDir, 500, qtrue );
                                }
                            }
                        }
                    }
                }
            }
            i += 1
        }
    }
}

/// Source: oracle/codemp/game/w_saber.c:3798
func WP_SaberDoClash(_ `self`: Entity, _ saberNum: Int32, _ bladeNum: Int32) {
    if saberDoClashEffect {
        let te: Entity? = G_TempEntity(saberClashPos, EV_SABER_BLOCK)
        te!.s.origin = saberClashPos
        te!.s.angles = saberClashNorm
        te!.s.eventParm = saberClashEventParm
        te!.s.otherEntityNum2 = `self`.s.number
        te!.s.weapon = saberNum
        te!.s.legsAnim = bladeNum
    }
}

/// Source: oracle/codemp/game/w_saber.c:3812
func WP_SaberBounceSound(_ ent: Entity, _ saberNum: Int32, _ bladeNum: Int32) {
    var index: Int32 = 1
    if ent.client == nil {
        return
    }
    index = Q_irand(1, 9)
    if !WP_SaberBladeUseSecondBladeStyle(ent.client!.saber[saberNum], bladeNum) && ent.client!.saber[saberNum].bounceSound[0] != 0 {
        G_Sound(ent, CHAN_AUTO, ent.client!.saber[saberNum].bounceSound[Q_irand(0, 2)])
    } else if WP_SaberBladeUseSecondBladeStyle(ent.client!.saber[saberNum], bladeNum) && ent.client!.saber[saberNum].bounce2Sound[0] != 0 {
        G_Sound(ent, CHAN_AUTO, ent.client!.saber[saberNum].bounce2Sound[Q_irand(0, 2)])
    } else if !WP_SaberBladeUseSecondBladeStyle(ent.client!.saber[saberNum], bladeNum) && ent.client!.saber[saberNum].blockSound[0] != 0 {
        G_Sound(ent, CHAN_AUTO, ent.client!.saber[saberNum].blockSound[Q_irand(0, 2)])
    } else if WP_SaberBladeUseSecondBladeStyle(ent.client!.saber[saberNum], bladeNum) && ent.client!.saber[saberNum].block2Sound[0] != 0 {
        G_Sound(ent, CHAN_AUTO, ent.client!.saber[saberNum].block2Sound[Q_irand(0, 2)])
    } else {
        G_Sound(ent, CHAN_AUTO, G_SoundIndex(va("sound/weapons/saber/saberblock%d.wav", index)))
    }
}

/// Source: oracle/codemp/game/w_saber.c:3857
private func CheckSaberDamage(_ `self`: Entity, _ rSaberNum: Int32, _ rBladeNum: Int32, _ saberStart: JKAShared.vec3_t, _ saberEnd: inout JKAShared.vec3_t, _ doInterpolate: Bool, _ trMask: Int32, _ extrapolate: Bool) -> Bool {
    // Raven assigns his own `trMask` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var trMask = trMask
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var dir = vec3_t()
        var saberTrMins = vec3_t()
        var saberTrMaxs = vec3_t()
        var lastValidStart = vec3_t()
        var lastValidEnd = vec3_t()
        var selfSaberLevel: Int32 = 0
        var otherSaberLevel: Int32 = 0
        var dmg: Int32 = 0
        var attackStr: Int32 = 0
        var saberBoxSize: Float = d_saberBoxTraceSize.value
        var idleDamage: Bool = false
        var didHit: Bool = false
        var sabersClashed: Bool = false
        var unblockable: Bool = false
        var didDefense: Bool = false
        var didOffense: Bool = false
        var saberTraceDone: Bool = false
        var otherUnblockable: Bool = false
        var tryDeflectAgain: Bool = false

        var otherOwner: Entity?

        if BG_SabersOff(`self`.client!.ps) {
            return false
        }

        selfSaberLevel = G_SaberAttackPower(`self`, SaberAttacking(`self`))

        //Add the standard radius into the box size
        saberBoxSize += (`self`.client!.saber[rSaberNum].blade[rBladeNum].radius * 0.5)

        if `self`.client!.ps.weaponTime <= 0 {
            //if not doing any attacks or anything, just use point traces.
            saberTrMins = vec3_t()
            saberTrMaxs = vec3_t()
        } else if d_saberGhoul2Collision.integer != 0 {
            if d_saberSPStyleDamage.integer != 0 {
                //SP-size saber damage traces
                saberTrMins = vec3_t(-2, -2, -2)
                saberTrMaxs = vec3_t(2, 2, 2)
            } else {
                saberTrMins = vec3_t(-saberBoxSize * 3, -saberBoxSize * 3, -saberBoxSize * 3)
                saberTrMaxs = vec3_t(saberBoxSize * 3, saberBoxSize * 3, saberBoxSize * 3)
            }
        } else if `self`.client!.ps.fd.saberAnimLevel < FORCE_LEVEL_2 {
            //box trace for fast, because it doesn't get updated so often
            saberTrMins = vec3_t(-saberBoxSize, -saberBoxSize, -saberBoxSize)
            saberTrMaxs = vec3_t(saberBoxSize, saberBoxSize, saberBoxSize)
        } else if d_saberAlwaysBoxTrace.integer != 0 {
            saberTrMins = vec3_t(-saberBoxSize, -saberBoxSize, -saberBoxSize)
            saberTrMaxs = vec3_t(saberBoxSize, saberBoxSize, saberBoxSize)
        } else {
            //just trace the minimum blade radius
            saberBoxSize = (`self`.client!.saber[rSaberNum].blade[rBladeNum].radius * 0.4)

            saberTrMins = vec3_t(-saberBoxSize, -saberBoxSize, -saberBoxSize)
            saberTrMaxs = vec3_t(saberBoxSize, saberBoxSize, saberBoxSize)
        }

        while !saberTraceDone {
            if doInterpolate && d_saberSPStyleDamage.integer == 0 {
                //This didn't quite work out like I hoped. But it's better than nothing. Sort of.
                var oldSaberStart = vec3_t()
                var oldSaberEnd = vec3_t()
                var saberDif = vec3_t()
                var oldSaberDif = vec3_t()
                var traceTests: Int32 = 0
                var trDif: Float = 8

                if (level.time - `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.lastTime) > 100 {
                    //no valid last pos, use current
                    oldSaberStart = saberStart
                    oldSaberEnd = saberEnd
                } else {
                    //trace from last pos
                    oldSaberStart = `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.base
                    oldSaberEnd = `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.tip
                }

                saberDif = saberStart - saberEnd
                oldSaberDif = oldSaberStart - oldSaberEnd

                VectorNormalize(&saberDif)
                VectorNormalize(&oldSaberDif)

                saberEnd[0] = saberStart[0] - (saberDif[0] * trDif)
                saberEnd[1] = saberStart[1] - (saberDif[1] * trDif)
                saberEnd[2] = saberStart[2] - (saberDif[2] * trDif)

                oldSaberEnd[0] = oldSaberStart[0] - (oldSaberDif[0] * trDif)
                oldSaberEnd[1] = oldSaberStart[1] - (oldSaberDif[1] * trDif)
                oldSaberEnd[2] = oldSaberStart[2] - (oldSaberDif[2] * trDif)

                trap_Trace(tr, saberEnd, saberTrMins, saberTrMaxs, saberStart, `self`.s.number, trMask)

                lastValidStart = saberEnd
                lastValidEnd = saberStart
                if tr.entityNum < MAX_CLIENTS {
                    G_G2TraceCollide(tr, lastValidStart, lastValidEnd, saberTrMins, saberTrMaxs)
                } else if tr.entityNum < ENTITYNUM_WORLD {
                    let trHit: Entity? = g_entities[tr.entityNum]

                    if trHit!.inuse && trHit!.ghoul2 != nil {
                        //hit a non-client entity with a g2 instance
                        G_G2TraceCollide(tr, lastValidStart, lastValidEnd, saberTrMins, saberTrMaxs)
                    }
                }

                trDif += 1

                while Double(tr.fraction) == 1.0 && traceTests < 4 && tr.entityNum >= ENTITYNUM_NONE {
                    if (level.time - `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.lastTime) > 100 {
                        //no valid last pos, use current
                        oldSaberStart = saberStart
                        oldSaberEnd = saberEnd
                    } else {
                        //trace from last pos
                        oldSaberStart = `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.base
                        oldSaberEnd = `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.tip
                    }

                    saberDif = saberStart - saberEnd
                    oldSaberDif = oldSaberStart - oldSaberEnd

                    VectorNormalize(&saberDif)
                    VectorNormalize(&oldSaberDif)

                    saberEnd[0] = saberStart[0] - (saberDif[0] * trDif)
                    saberEnd[1] = saberStart[1] - (saberDif[1] * trDif)
                    saberEnd[2] = saberStart[2] - (saberDif[2] * trDif)

                    oldSaberEnd[0] = oldSaberStart[0] - (oldSaberDif[0] * trDif)
                    oldSaberEnd[1] = oldSaberStart[1] - (oldSaberDif[1] * trDif)
                    oldSaberEnd[2] = oldSaberStart[2] - (oldSaberDif[2] * trDif)

                    trap_Trace(tr, saberEnd, saberTrMins, saberTrMaxs, saberStart, `self`.s.number, trMask)

                    lastValidStart = saberEnd
                    lastValidEnd = saberStart
                    if tr.entityNum < MAX_CLIENTS {
                        G_G2TraceCollide(tr, lastValidStart, lastValidEnd, saberTrMins, saberTrMaxs)
                    } else if tr.entityNum < ENTITYNUM_WORLD {
                        let trHit: Entity? = g_entities[tr.entityNum]

                        if trHit!.inuse && trHit!.ghoul2 != nil {
                            //hit a non-client entity with a g2 instance
                            G_G2TraceCollide(tr, lastValidStart, lastValidEnd, saberTrMins, saberTrMaxs)
                        }
                    }

                    traceTests += 1
                    trDif += 8
                }
            } else {
                var saberEndExtrapolated = vec3_t()
                if extrapolate {
                    //extrapolate 16
                    var diff = vec3_t()
                    diff = saberEnd - saberStart
                    VectorNormalize(&diff)
                    _VectorMA(saberStart, SABER_EXTRAPOLATE_DIST, diff, &saberEndExtrapolated)
                } else {
                    saberEndExtrapolated = saberEnd
                }
                trap_Trace(tr, saberStart, saberTrMins, saberTrMaxs, saberEndExtrapolated, `self`.s.number, trMask)

                lastValidStart = saberStart
                lastValidEnd = saberEndExtrapolated
                /*
                if ( tr.allsolid || tr.startsolid )
                {
                if ( tr.entityNum == ENTITYNUM_NONE )
                {
                qboolean whah = qtrue;
                }
                Com_Printf( "saber trace start/all solid - ent is %d\n", tr.entityNum );
                }
                */
                if tr.entityNum < MAX_CLIENTS {
                    G_G2TraceCollide(tr, lastValidStart, lastValidEnd, saberTrMins, saberTrMaxs)
                } else if tr.entityNum < ENTITYNUM_WORLD {
                    let trHit: Entity? = g_entities[tr.entityNum]

                    if trHit!.inuse && trHit!.ghoul2 != nil {
                        //hit a non-client entity with a g2 instance
                        G_G2TraceCollide(tr, lastValidStart, lastValidEnd, saberTrMins, saberTrMaxs)
                    }
                }
            }

            saberTraceDone = true
        }

        if `self`.client!.ps.saberAttackWound < level.time && (SaberAttacking(`self`) || BG_SuperBreakWinAnim(`self`.client!.ps.torsoAnim) || (d_saberSPStyleDamage.integer != 0 && `self`.client!.ps.saberInFlight && rSaberNum == 0) || (WP_SaberBladeDoTransitionDamage(`self`.client!.saber[rSaberNum], rBladeNum) && BG_SaberInTransitionAny(`self`.client!.ps.saberMove)) || (`self`.client!.ps.m_iVehicleNum != 0 && `self`.client!.ps.saberMove > LS_READY)) {
            //this animation is that of the last attack movement, and so it should do full damage
            let saberInSpecial: Bool = BG_SaberInSpecial(`self`.client!.ps.saberMove)
            let inBackAttack: Bool = G_SaberInBackAttack(`self`.client!.ps.saberMove)

            if d_saberSPStyleDamage.integer != 0 {
                var fDmg: Float = 0.0
                if `self`.client!.ps.saberInFlight {
                    let saberEnt: Entity? = g_entities[`self`.client!.ps.saberEntityNum]
                    if saberEnt == nil || !saberEnt!.s.saberInFlight {
                        //does less damage on the way back
                        fDmg = 1.0
                        attackStr = FORCE_LEVEL_0
                    } else {
                        fDmg = 2.5 * `self`.client!.ps.fd.forcePowerLevel[FP_SABERTHROW]
                        attackStr = FORCE_LEVEL_1
                    }
                } else {
                    attackStr = G_PowerLevelForSaberAnim(`self`, rSaberNum, false)
                    if g_saberRealisticCombat.integer != 0 {
                        switch attackStr {
                        case FORCE_LEVEL_2:
                            fDmg = 5.0

                        case FORCE_LEVEL_1, FORCE_LEVEL_0:
                            fDmg = 2.5

                        default:
                            fDmg = 10.0
                        }
                    } else {
                        if `self`.client!.ps.torsoAnim == BOTH_SPINATTACK6 || `self`.client!.ps.torsoAnim == BOTH_SPINATTACK7 {
                            //too easy to do, lower damage
                            fDmg = 2.5
                        } else {
                            fDmg = 2.5 * Float(attackStr)
                        }
                    }
                }
                if g_saberRealisticCombat.integer > 1 {
                    //always do damage, and lots of it
                    if g_saberRealisticCombat.integer > 2 {
                        //always do damage, and lots of it
                        fDmg = 25.0
                    } else if fDmg > 0.1 {
                        //only do super damage if we would have done damage according to normal rules
                        fDmg = 25.0
                    }
                }
                /*
                if ( dmg > 0.1f )
                {
                if ( (self->client->ps.forcePowersActive&(1<<FP_RAGE)) )
                {//add some damage if raged
                dmg += self->client->ps.forcePowerLevel[FP_RAGE] * 5.0f;
                }
                else if ( self->client->ps.forceRageRecoveryTime )
                {//halve it if recovering
                dmg *= 0.5f;
                }
                }
                */
                if g_gametype.integer != GT_DUEL && g_gametype.integer != GT_POWERDUEL && g_gametype.integer != GT_SIEGE {
                    //in faster-paced games, sabers do more damage
                    fDmg *= 2.0
                }
                if fDmg != 0 {
                    //the longer the trace, the more damage it does
                    //FIXME: in SP, we only use the part of the trace that's actually *inside* the hit ent...
                    let traceLength: Float = Distance(saberEnd, saberStart)
                    if tr.fraction >= 1.0 {
                        //allsolid?
                        dmg = Int32(ceil(fDmg * traceLength * 0.1 * 0.33))
                    } else {
                        //fractional hit, the sooner you hit in the trace, the more damage you did
                        dmg = Int32(ceil(fDmg * traceLength * (1.0 - tr.fraction) * 0.1 * 0.33)) //(1.0f-tr.fraction) isn't really accurate, but kind of simulates what we have in SP
                    }
                    if g_saberDebugBox.integer == 3 || g_saberDebugBox.integer == 4 {
                        G_TestLine(saberStart, saberEnd, 0x0000ff, 50)
                    }
                }
                /*
                if ( dmg )
                {
                Com_Printf("CL %i SABER DMG: %i, anim %s, torsoTimer %i\n", self->s.number, dmg, animTable[self->client->ps.torsoAnim].name, self->client->ps.torsoTimer );
                }
                */
                if `self`.client!.ps.torsoAnim == BOTH_A1_SPECIAL || `self`.client!.ps.torsoAnim == BOTH_A2_SPECIAL || `self`.client!.ps.torsoAnim == BOTH_A3_SPECIAL {
                    //parry/block/break-parry bonus for single-style kata moves
                    attackStr += 1
                }
                if BG_SuperBreakWinAnim(`self`.client!.ps.torsoAnim) {
                    trMask &= ~CONTENTS_LIGHTSABER
                }
            } else {
                dmg = SABER_HITDAMAGE

                if `self`.client!.ps.fd.saberAnimLevel == SS_STAFF || `self`.client!.ps.fd.saberAnimLevel == SS_DUAL {
                    if saberInSpecial {
                        //it will get auto-ramped based on the point in the attack, later on
                        if `self`.client!.ps.saberMove == LS_SPINATTACK || `self`.client!.ps.saberMove == LS_SPINATTACK_DUAL {
                            //these attacks are long and have the potential to hit a lot so they will do less damage.
                            dmg = 10
                        } else {
                            if BG_KickingAnim(`self`.client!.ps.legsAnim) || BG_KickingAnim(`self`.client!.ps.torsoAnim) {
                                //saber shouldn't do more than min dmg during kicks
                                dmg = 2
                            } else if BG_SaberInKata(`self`.client!.ps.saberMove) {
                                //special kata move
                                if `self`.client!.ps.fd.saberAnimLevel == SS_DUAL {
                                    //this is the nasty saber twirl, do big damage cause it makes you vulnerable
                                    dmg = 90
                                } else {
                                    //staff kata
                                    dmg = G_GetAttackDamage(`self`, 60, 70, 0.5)
                                }
                            } else {
                                //dmg = 90;
                                //ramp from 2 to 90 by default for other specials
                                dmg = G_GetAttackDamage(`self`, 2, 90, 0.5)
                            }
                        }
                    } else {
                        //otherwise we'll ramp up to 70 I guess, for both dual and staff
                        dmg = G_GetAttackDamage(`self`, 2, 70, 0.5)
                    }
                } else if `self`.client!.ps.fd.saberAnimLevel == 3 {
                    //new damage-ramping system
                    if !saberInSpecial && !inBackAttack {
                        dmg = G_GetAttackDamage(`self`, 2, 120, 0.5)
                    } else if saberInSpecial && (`self`.client!.ps.saberMove == LS_A_JUMP_T__B_) {
                        dmg = G_GetAttackDamage(`self`, 2, 180, 0.65)
                    } else if inBackAttack {
                        dmg = G_GetAttackDamage(`self`, 2, 30, 0.5) //can hit multiple times (and almost always does), so..
                    } else {
                        dmg = 100
                    }
                } else if `self`.client!.ps.fd.saberAnimLevel == 2 {
                    if saberInSpecial && (`self`.client!.ps.saberMove == LS_A_FLIP_STAB || `self`.client!.ps.saberMove == LS_A_FLIP_SLASH) {
                        //a well-timed hit with this can do a full 85
                        dmg = G_GetAttackDamage(`self`, 2, 80, 0.5)
                    } else if inBackAttack {
                        dmg = G_GetAttackDamage(`self`, 2, 25, 0.5)
                    } else {
                        dmg = 60
                    }
                } else if `self`.client!.ps.fd.saberAnimLevel == 1 {
                    if saberInSpecial && (`self`.client!.ps.saberMove == LS_A_LUNGE) {
                        dmg = G_GetAttackDamage(`self`, 2, SABER_HITDAMAGE - 5, 0.3)
                    } else if inBackAttack {
                        dmg = G_GetAttackDamage(`self`, 2, 30, 0.5)
                    } else {
                        dmg = SABER_HITDAMAGE
                    }
                }

                attackStr = `self`.client!.ps.fd.saberAnimLevel
            }
        } else if `self`.client!.ps.saberAttackWound < level.time && `self`.client!.ps.saberIdleWound < level.time {
            //just touching, do minimal damage and only check for it every 200ms (mainly to cut down on network traffic for hit events)
            if (`self`.client!.saber[0].saberFlags2 & SFL2_NO_IDLE_EFFECT) != 0 {
                //no idle damage or effects
                return true //true cause even though we didn't get a hit, we don't want to do those extra traces because the debounce time says not to.
            }
            trMask &= ~CONTENTS_LIGHTSABER
            if d_saberSPStyleDamage.integer != 0 {
                if BG_SaberInReturn(`self`.client!.ps.saberMove) {
                    dmg = SABER_NONATTACK_DAMAGE
                } else {
                    if d_saberSPStyleDamage.integer == 2 {
                        dmg = SABER_NONATTACK_DAMAGE
                    } else {
                        dmg = 0
                    }
                }
            } else {
                dmg = SABER_NONATTACK_DAMAGE
            }
            idleDamage = true
        } else {
            return true //true cause even though we didn't get a hit, we don't want to do those extra traces because the debounce time says not to.
        }

        if BG_SaberInSpecial(`self`.client!.ps.saberMove) {
            let inBackAttack: Bool = G_SaberInBackAttack(`self`.client!.ps.saberMove)

            unblockable = true
            `self`.client!.ps.saberBlocked = 0

            if d_saberSPStyleDamage.integer != 0 {
            } else if !inBackAttack {
                if `self`.client!.ps.saberMove == LS_A_JUMP_T__B_ {
                    //do extra damage for special unblockables
                    dmg += 5 //This is very tiny, because this move has a huge damage ramp
                } else if `self`.client!.ps.saberMove == LS_A_FLIP_STAB || `self`.client!.ps.saberMove == LS_A_FLIP_SLASH {
                    dmg += 5 //ditto
                    if dmg <= 40 || G_GetAnimPoint(`self`) <= 0.4 {
                        //sort of a hack, don't want it doing big damage in the off points of the anim
                        dmg = 2
                    }
                } else if `self`.client!.ps.saberMove == LS_A_LUNGE {
                    dmg += 2 //and ditto again
                    if G_GetAnimPoint(`self`) <= 0.4 {
                        //same as above
                        dmg = 2
                    }
                } else if `self`.client!.ps.saberMove == LS_SPINATTACK || `self`.client!.ps.saberMove == LS_SPINATTACK_DUAL {
                    //do a constant significant amount of damage but ramp up a little to the mid-point
                    dmg = G_GetAttackDamage(`self`, 2, dmg + 3, 0.5)
                    dmg += 10
                } else {
                    //dmg += 20;
                    if BG_KickingAnim(`self`.client!.ps.legsAnim) || BG_KickingAnim(`self`.client!.ps.torsoAnim) {
                        //saber shouldn't do more than min dmg during kicks
                        dmg = 2
                    } else {
                        //auto-ramp it I guess since it's a special we don't have a special case for.
                        dmg = G_GetAttackDamage(`self`, 5, dmg + 5, 0.5)
                    }
                }
            }
        }

        if dmg == 0 {
            if tr.entityNum < MAX_CLIENTS || (g_entities[tr.entityNum].inuse && (g_entities[tr.entityNum].r.contents & CONTENTS_LIGHTSABER) != 0) {
                return true
            }
            return false
        }

        if dmg > SABER_NONATTACK_DAMAGE {
            dmg = Int32(dmg * g_saberDamageScale.value)

            //see if this specific saber has a damagescale
            if !WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[rSaberNum], rBladeNum) && `self`.client!.saber[rSaberNum].damageScale != 1.0 {
                dmg = Int32(ceil(Float(dmg) * `self`.client!.saber[rSaberNum].damageScale))
            } else if WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[rSaberNum], rBladeNum) && `self`.client!.saber[rSaberNum].damageScale2 != 1.0 {
                dmg = Int32(ceil(Float(dmg) * `self`.client!.saber[rSaberNum].damageScale2))
            }

            if (`self`.client!.ps.brokenLimbs & (1 << BROKENLIMB_RARM)) != 0 || (`self`.client!.ps.brokenLimbs & (1 << BROKENLIMB_LARM)) != 0 {
                //weaken it if an arm is broken
                dmg = Int32(Double(dmg) * 0.3)
                if dmg <= SABER_NONATTACK_DAMAGE {
                    dmg = SABER_NONATTACK_DAMAGE + 1
                }
            }
        }

        if dmg > SABER_NONATTACK_DAMAGE && `self`.client!.ps.isJediMaster {
            //give the Jedi Master more saber attack power
            dmg *= 2
        }

        if dmg > SABER_NONATTACK_DAMAGE && g_gametype.integer == GT_SIEGE && `self`.client!.siegeClass != -1 && (bgSiegeClasses[`self`.client!.siegeClass].classflags & (1 << CFL_MORESABERDMG)) != 0 {
            //this class is flagged to do extra saber damage. I guess 2x will do for now.
            dmg *= 2
        }

        if g_gametype.integer == GT_POWERDUEL && `self`.client!.sess.duelTeam == DUELTEAM_LONE {
            //always x2 when we're powerdueling alone... er, so, we apparently no longer want this?  So they say.
            if g_duel_fraglimit.integer != 0 {
                //dmg *= 1.5 - (.4 * (float)self->client->sess.wins / (float)g_duel_fraglimit.integer);
            }
            //dmg *= 2;
        }

        if g_saberDebugPrint.integer > 2 && dmg > 1 {
            Com_Printf("CL %i SABER DMG: %i\n", `self`.s.number, dmg)
        }

        dir = saberEnd - saberStart
        VectorNormalize(&dir)

        if tr.entityNum == ENTITYNUM_WORLD || g_entities[tr.entityNum].s.eType == ET_TERRAIN {
            //register this as a wall hit for jedi AI
            `self`.client!.ps.saberEventFlags |= SEF_HITWALL
            saberHitWall = true
        }

        if saberHitWall && (`self`.client!.saber[rSaberNum].saberFlags & SFL_BOUNCE_ON_WALLS) != 0 && (BG_SaberInAttackPure(`self`.client!.ps.saberMove) || `self`.client!.ps.saberMove == LS_A_JUMP_T__B_) {
            //then bounce off
            /*
            qboolean onlyIfNotSpecial = qfalse;
            qboolean skipIt = qfalse;
            if (tr.plane.normal[2] >= 0.8f ||
            tr.plane.normal[2] <= -0.8f ||
            VectorCompare(tr.plane.normal, vec3_origin))
            {
            if ((tr.plane.normal[2] >= 0.8f || VectorCompare(tr.plane.normal, vec3_origin)) &&
            self->client->ps.viewangles[PITCH] <= 30.0f &&
            self->client->pers.cmd.upmove >= 0)
            { //don't hit the ground if we are not looking down a lot/crouched
            skipIt = qtrue;
            }
            else
            {
            onlyIfNotSpecial = qtrue;
            }
            }
            if (!skipIt && (!onlyIfNotSpecial || !BG_SaberInSpecial(self->client->ps.saberMove)))
            */
            do {
                var te: Entity? = nil
                /*
                qboolean pre = saberDoClashEffect;

                VectorCopy( tr.endpos, saberClashPos );
                VectorCopy( tr.plane.normal, saberClashNorm );
                saberClashEventParm = 1;
                saberDoClashEffect = qtrue;
                WP_SaberDoClash( self, rSaberNum, rBladeNum );
                saberDoClashEffect = pre;
                */

                `self`.client!.ps.saberMove = BG_BrokenParryForAttack(`self`.client!.ps.saberMove)
                `self`.client!.ps.saberBlocked = BLOCKED_PARRY_BROKEN
                if `self`.client!.ps.torsoAnim == `self`.client!.ps.legsAnim {
                    //set anim now on both parts
                    let anim: Int32 = saberMoveData[`self`.client!.ps.saberMove].animToUse
                    G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                }

                //do bounce sound & force feedback
                WP_SaberBounceSound(`self`, rSaberNum, rBladeNum)
                //do hit effect
                te = G_TempEntity(tr.endpos, EV_SABER_HIT)
                te!.s.otherEntityNum = ENTITYNUM_NONE //we didn't hit anyone in particular
                te!.s.otherEntityNum2 = `self`.s.number //send this so it knows who we are
                te!.s.weapon = rSaberNum
                te!.s.legsAnim = rBladeNum
                te!.s.origin = tr.endpos
                te!.s.angles = tr.plane.normal
                if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
                    //don't let it play with no direction
                    te!.s.angles[1] = 1
                }
                //do radius damage/knockback, if any
                if !WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[rSaberNum], rBladeNum) {
                    WP_SaberRadiusDamage(`self`, tr.endpos, `self`.client!.saber[rSaberNum].splashRadius, `self`.client!.saber[rSaberNum].splashDamage, `self`.client!.saber[rSaberNum].splashKnockback)
                } else {
                    WP_SaberRadiusDamage(`self`, tr.endpos, `self`.client!.saber[rSaberNum].splashRadius2, `self`.client!.saber[rSaberNum].splashDamage2, `self`.client!.saber[rSaberNum].splashKnockback2)
                }

                return true
            }
        }

        // Port-note: Raven's `goto blockStuff` jumps from the blocked-hit arm into the saber-clash arm, to his label `blockStuff`.
        // The statements from the label to the end of the saber-clash arm are this nested function, and both arms return its value.
        func blockStuff() -> Bool {
            otherUnblockable = false

            if otherOwner != nil && otherOwner!.client != nil && otherOwner!.client!.ps.saberInFlight {
                return false
            }

            //this is a thrown saber, don't do any fancy saber-saber collision stuff
            if `self`.client!.ps.saberEntityNum != 0 && `self`.client!.ps.saberInFlight && rSaberNum == 0 {
                return false
            }

            otherSaberLevel = G_SaberAttackPower(otherOwner!, SaberAttacking(otherOwner!))

            if dmg > SABER_NONATTACK_DAMAGE && !unblockable && !otherUnblockable {
                let lockFactor: Int32 = g_saberLockFactor.integer

                if sabersClashed && Q_irand(1, 20) <= lockFactor {
                    if !G_ClientIdleInWorld(otherOwner!) {
                        if WP_SabersCheckLock(`self`, otherOwner!) {
                            `self`.client!.ps.saberBlocked = BLOCKED_NONE
                            otherOwner!.client!.ps.saberBlocked = BLOCKED_NONE
                            return didHit
                        }
                    }
                }
            }

            if otherOwner == nil || otherOwner!.client == nil {
                return didHit
            }

            if BG_SaberInSpecial(otherOwner!.client!.ps.saberMove) {
                otherUnblockable = true
                otherOwner!.client!.ps.saberBlocked = 0
            }

            if sabersClashed && dmg > SABER_NONATTACK_DAMAGE && selfSaberLevel < FORCE_LEVEL_3 && !PM_SaberInBounce(otherOwner!.client!.ps.saberMove) && !PM_SaberInParry(`self`.client!.ps.saberMove) && !PM_SaberInBrokenParry(`self`.client!.ps.saberMove) && !BG_SaberInSpecial(`self`.client!.ps.saberMove) && !PM_SaberInBounce(`self`.client!.ps.saberMove) && !PM_SaberInDeflect(`self`.client!.ps.saberMove) && !PM_SaberInReflect(`self`.client!.ps.saberMove) && !unblockable {
                //if (Q_irand(1, 10) <= 6)
                if true { //for now, just always try a deflect. (deflect func can cause bounces too)
                    if !WP_GetSaberDeflectionAngle(`self`, otherOwner!, tr.fraction) {
                        tryDeflectAgain = true //Failed the deflect, try it again if we can if the guy we're smashing goes into a parry and we don't break it
                    } else {
                        `self`.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE
                        didOffense = true
                    }
                } else {
                    `self`.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
                    didOffense = true

                    if g_saberDebugPrint.integer != 0 {
                        Com_Printf("Client %i clashed into client %i's saber, did BLOCKED_ATK_BOUNCE\n", `self`.s.number, otherOwner!.s.number)
                    }
                }
            }

            if ((selfSaberLevel < FORCE_LEVEL_3 && ((tryDeflectAgain && Q_irand(1, 10) <= 3) || (!tryDeflectAgain && Q_irand(1, 10) <= 7))) || (Q_irand(1, 10) <= 1 && otherSaberLevel >= FORCE_LEVEL_3)) && !PM_SaberInBounce(`self`.client!.ps.saberMove) && !PM_SaberInBrokenParry(otherOwner!.client!.ps.saberMove) && !BG_SaberInSpecial(otherOwner!.client!.ps.saberMove) && !PM_SaberInBounce(otherOwner!.client!.ps.saberMove) && !PM_SaberInDeflect(otherOwner!.client!.ps.saberMove) && !PM_SaberInReflect(otherOwner!.client!.ps.saberMove) && (otherSaberLevel > FORCE_LEVEL_2 || (otherOwner!.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] >= 3 && Q_irand(0, otherSaberLevel) != 0)) && !unblockable && !otherUnblockable && dmg > SABER_NONATTACK_DAMAGE && !didOffense { //don't allow the person we're attacking to do this if we're making an unblockable attack
                //knockaways can make fast-attacker go into a broken parry anim if the ent is using fast or med. In MP, we also randomly decide this for level 3 attacks.
                //Going to go ahead and let idle damage do simple knockaways. Looks sort of good that way.
                //turn the parry into a knockaway
                if `self`.client!.ps.saberEntityNum != 0 { //make sure he has his saber still
                    saberCheckKnockdown_BrokenParry(g_entities[`self`.client!.ps.saberEntityNum], `self`, otherOwner!)
                }

                if !PM_SaberInParry(otherOwner!.client!.ps.saberMove) {
                    WP_SaberBlockNonRandom(otherOwner!, tr.endpos, false)
                    otherOwner!.client!.ps.saberMove = BG_KnockawayForParry(otherOwner!.client!.ps.saberBlocked)
                    otherOwner!.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE
                } else {
                    otherOwner!.client!.ps.saberMove = G_KnockawayForParry(otherOwner!.client!.ps.saberMove) //BG_KnockawayForParry( otherOwner->client->ps.saberBlocked );
                    otherOwner!.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE
                }

                //make them (me) go into a broken parry
                `self`.client!.ps.saberMove = BG_BrokenParryForAttack(`self`.client!.ps.saberMove)
                `self`.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE

                if g_saberDebugPrint.integer != 0 {
                    Com_Printf("Client %i sent client %i into a reflected attack with a knockaway\n", otherOwner!.s.number, `self`.s.number)
                }

                didDefense = true
            } else if (selfSaberLevel > FORCE_LEVEL_2 || unblockable) && //if we're doing a special attack, we can send them into a broken parry too (MP only)
                (otherOwner!.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] < selfSaberLevel || (otherOwner!.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] == selfSaberLevel && (Double(Q_irand(1, 10)) >= Double(otherSaberLevel) * 1.5 || unblockable))) && PM_SaberInParry(otherOwner!.client!.ps.saberMove) && !PM_SaberInBrokenParry(otherOwner!.client!.ps.saberMove) && !PM_SaberInParry(`self`.client!.ps.saberMove) && !PM_SaberInBrokenParry(`self`.client!.ps.saberMove) && !PM_SaberInBounce(`self`.client!.ps.saberMove) && dmg > SABER_NONATTACK_DAMAGE && !didOffense && !otherUnblockable {
                //they are in a parry, and we are slamming down on them with a move of equal or greater force than their defense, so send them into a broken parry.. unless they are already in one.
                if otherOwner!.client!.ps.saberEntityNum != 0 { //make sure he has his saber still
                    saberCheckKnockdown_BrokenParry(g_entities[otherOwner!.client!.ps.saberEntityNum], otherOwner!, `self`)
                }

                if g_saberDebugPrint.integer != 0 {
                    Com_Printf("Client %i sent client %i into a broken parry\n", `self`.s.number, otherOwner!.s.number)
                }

                otherOwner!.client!.ps.saberMove = BG_BrokenParryForParry(otherOwner!.client!.ps.saberMove)
                otherOwner!.client!.ps.saberBlocked = BLOCKED_PARRY_BROKEN

                didDefense = true
            } else if (selfSaberLevel > FORCE_LEVEL_2) && //if we're doing a special attack, we can send them into a broken parry too (MP only)
                //( otherOwner->client->ps.fd.forcePowerLevel[FP_SABER_DEFENSE] < selfSaberLevel || (otherOwner->client->ps.fd.forcePowerLevel[FP_SABER_DEFENSE] == selfSaberLevel && (Q_irand(1, 10) >= otherSaberLevel*3 || unblockable)) ) &&
                otherSaberLevel >= FORCE_LEVEL_3 && PM_SaberInParry(otherOwner!.client!.ps.saberMove) && !PM_SaberInBrokenParry(otherOwner!.client!.ps.saberMove) && !PM_SaberInParry(`self`.client!.ps.saberMove) && !PM_SaberInBrokenParry(`self`.client!.ps.saberMove) && !PM_SaberInBounce(`self`.client!.ps.saberMove) && !PM_SaberInDeflect(`self`.client!.ps.saberMove) && !PM_SaberInReflect(`self`.client!.ps.saberMove) && dmg > SABER_NONATTACK_DAMAGE && !didOffense && !unblockable {
                //they are in a parry, and we are slamming down on them with a move of equal or greater force than their defense, so send them into a broken parry.. unless they are already in one.
                if g_saberDebugPrint.integer != 0 {
                    Com_Printf("Client %i bounced off of client %i's saber\n", `self`.s.number, otherOwner!.s.number)
                }

                if !tryDeflectAgain {
                    if !WP_GetSaberDeflectionAngle(`self`, otherOwner!, tr.fraction) {
                        tryDeflectAgain = true
                    }
                }

                didOffense = true
            } else if SaberAttacking(otherOwner!) && dmg > SABER_NONATTACK_DAMAGE && !BG_SaberInSpecial(otherOwner!.client!.ps.saberMove) && !didOffense && !otherUnblockable {
                //they were attacking and our saber hit their saber, make them bounce. But if they're in a special attack, leave them.
                if !PM_SaberInBounce(`self`.client!.ps.saberMove) && !PM_SaberInBounce(otherOwner!.client!.ps.saberMove) && !PM_SaberInDeflect(`self`.client!.ps.saberMove) && !PM_SaberInDeflect(otherOwner!.client!.ps.saberMove) && !PM_SaberInReflect(`self`.client!.ps.saberMove) && !PM_SaberInReflect(otherOwner!.client!.ps.saberMove) {
                    var attackAdv: Int32
                    var defendStr: Int32 = G_PowerLevelForSaberAnim(otherOwner!, 0, true)
                    var attackBonus: Int32 = 0
                    if otherOwner!.client!.ps.torsoAnim == BOTH_A1_SPECIAL || otherOwner!.client!.ps.torsoAnim == BOTH_A2_SPECIAL || otherOwner!.client!.ps.torsoAnim == BOTH_A3_SPECIAL {
                        //parry/block/break-parry bonus for single-style kata moves
                        defendStr += 1
                    }
                    defendStr += Q_irand(0, otherOwner!.client!.saber[0].parryBonus)
                    // Raven tests `otherOwner->client->saber[1].model` and `otherOwner->client->saber[1].model[0]`.
                    // Both read as the same Swift test, so the draft writes it once.
                    if !otherOwner!.client!.saber[1].model.isEmpty && otherOwner!.client!.ps.saberHolstered == 0 {
                        defendStr += Q_irand(0, otherOwner!.client!.saber[1].parryBonus)
                    }

                    if g_saberDebugPrint.integer != 0 {
                        Com_Printf("Client %i and client %i bounced off of each other's sabers\n", `self`.s.number, otherOwner!.s.number)
                    }

                    attackBonus = Q_irand(0, `self`.client!.saber[0].breakParryBonus)
                    // Raven tests `self->client->saber[1].model` and `self->client->saber[1].model[0]`.
                    // Both read as the same Swift test, so the draft writes it once.
                    if !`self`.client!.saber[1].model.isEmpty && `self`.client!.ps.saberHolstered == 0 {
                        attackBonus += Q_irand(0, `self`.client!.saber[1].breakParryBonus)
                    }
                    attackAdv = (attackStr + attackBonus + `self`.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE]) - (defendStr + otherOwner!.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE])

                    if attackAdv > 1 {
                        //I won, he should knockaway
                        otherOwner!.client!.ps.saberMove = BG_BrokenParryForAttack(otherOwner!.client!.ps.saberMove)
                        otherOwner!.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE
                    } else if attackAdv > 0 {
                        //I won, he should bounce, I should continue
                        otherOwner!.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
                    } else if attackAdv < 1 {
                        //I lost, I get knocked away
                        `self`.client!.ps.saberMove = BG_BrokenParryForAttack(`self`.client!.ps.saberMove)
                        `self`.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE
                    } else if attackAdv < 0 {
                        //I lost, I bounce off
                        `self`.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
                    } else {
                        //even, both bounce off
                        `self`.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
                        otherOwner!.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
                    }

                    didOffense = true
                }
            }

            if d_saberGhoul2Collision.integer != 0 && !didDefense && dmg <= SABER_NONATTACK_DAMAGE && !otherUnblockable { //with perpoly, it looks pretty weird to have clash flares coming off the guy's face and whatnot
                if !PM_SaberInParry(otherOwner!.client!.ps.saberMove) && !PM_SaberInBrokenParry(otherOwner!.client!.ps.saberMove) && !BG_SaberInSpecial(otherOwner!.client!.ps.saberMove) && !PM_SaberInBounce(otherOwner!.client!.ps.saberMove) && !PM_SaberInDeflect(otherOwner!.client!.ps.saberMove) && !PM_SaberInReflect(otherOwner!.client!.ps.saberMove) {
                    WP_SaberBlockNonRandom(otherOwner!, tr.endpos, false)
                    otherOwner!.client!.ps.saberEventFlags |= SEF_PARRIED
                }
            } else if !didDefense && dmg > SABER_NONATTACK_DAMAGE && !otherUnblockable { //if not more than idle damage, don't even bother blocking.
                //block
                if !PM_SaberInParry(otherOwner!.client!.ps.saberMove) && !PM_SaberInBrokenParry(otherOwner!.client!.ps.saberMove) && !BG_SaberInSpecial(otherOwner!.client!.ps.saberMove) && !PM_SaberInBounce(otherOwner!.client!.ps.saberMove) && !PM_SaberInDeflect(otherOwner!.client!.ps.saberMove) && !PM_SaberInReflect(otherOwner!.client!.ps.saberMove) {
                    var crushTheParry: Bool = false

                    if unblockable {
                        //It's unblockable. So send us into a broken parry immediately.
                        crushTheParry = true
                    }

                    if !SaberAttacking(otherOwner!) {
                        var otherIdleStr: Int32 = otherOwner!.client!.ps.fd.saberAnimLevel
                        if otherIdleStr == SS_DUAL || otherIdleStr == SS_STAFF {
                            otherIdleStr = SS_MEDIUM
                        }

                        WP_SaberBlockNonRandom(otherOwner!, tr.endpos, false)
                        otherOwner!.client!.ps.saberEventFlags |= SEF_PARRIED
                        `self`.client!.ps.saberEventFlags |= SEF_BLOCKED

                        if attackStr + `self`.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] > otherIdleStr + otherOwner!.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] {
                            crushTheParry = true
                        } else {
                            tryDeflectAgain = true
                        }
                    } else if selfSaberLevel > otherSaberLevel || (selfSaberLevel == otherSaberLevel && Q_irand(1, 10) <= 2) {
                        //they are attacking, and we managed to make them break
                        //Give them a parry, so we can later break it.
                        WP_SaberBlockNonRandom(otherOwner!, tr.endpos, false)
                        crushTheParry = true

                        if otherOwner!.client!.ps.saberEntityNum != 0 { //make sure he has his saber still
                            saberCheckKnockdown_BrokenParry(g_entities[otherOwner!.client!.ps.saberEntityNum], otherOwner!, `self`)
                        }

                        if g_saberDebugPrint.integer != 0 {
                            Com_Printf("Client %i forced client %i into a broken parry with a stronger attack\n", `self`.s.number, otherOwner!.s.number)
                        }
                    } else {
                        //They are attacking, so are we, and obviously they have an attack level higher than or equal to ours
                        if selfSaberLevel == otherSaberLevel {
                            //equal level, try to bounce off each other's sabers
                            if !didOffense && !PM_SaberInParry(`self`.client!.ps.saberMove) && !PM_SaberInBrokenParry(`self`.client!.ps.saberMove) && !BG_SaberInSpecial(`self`.client!.ps.saberMove) && !PM_SaberInBounce(`self`.client!.ps.saberMove) && !PM_SaberInDeflect(`self`.client!.ps.saberMove) && !PM_SaberInReflect(`self`.client!.ps.saberMove) && !unblockable {
                                `self`.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
                                didOffense = true
                            }
                            if !didDefense && !PM_SaberInParry(otherOwner!.client!.ps.saberMove) && !PM_SaberInBrokenParry(otherOwner!.client!.ps.saberMove) && !BG_SaberInSpecial(otherOwner!.client!.ps.saberMove) && !PM_SaberInBounce(otherOwner!.client!.ps.saberMove) && !PM_SaberInDeflect(otherOwner!.client!.ps.saberMove) && !PM_SaberInReflect(otherOwner!.client!.ps.saberMove) && !unblockable {
                                otherOwner!.client!.ps.saberBlocked = BLOCKED_ATK_BOUNCE
                            }
                            if g_saberDebugPrint.integer != 0 {
                                Com_Printf("Equal attack level bounce/deflection for clients %i and %i\n", `self`.s.number, otherOwner!.s.number)
                            }

                            `self`.client!.ps.saberEventFlags |= SEF_DEFLECTED
                            otherOwner!.client!.ps.saberEventFlags |= SEF_DEFLECTED
                        } else if (level.time - otherOwner!.client!.lastSaberStorageTime) < 500 && !unblockable { //make sure the stored saber data is updated
                            //They are higher, this means they can actually smash us into a broken parry
                            //Using reflected anims instead now
                            `self`.client!.ps.saberMove = BG_BrokenParryForAttack(`self`.client!.ps.saberMove)
                            `self`.client!.ps.saberBlocked = BLOCKED_PARRY_BROKEN

                            if `self`.client!.ps.saberEntityNum != 0 { //make sure he has his saber still
                                saberCheckKnockdown_BrokenParry(g_entities[`self`.client!.ps.saberEntityNum], `self`, otherOwner!)
                            }

                            if g_saberDebugPrint.integer != 0 {
                                Com_Printf("Client %i hit client %i's stronger attack, was forced into a broken parry\n", `self`.s.number, otherOwner!.s.number)
                            }

                            otherOwner!.client!.ps.saberEventFlags &= ~SEF_BLOCKED

                            didOffense = true
                        }
                    }

                    if crushTheParry && PM_SaberInParry(G_GetParryForBlock(otherOwner!.client!.ps.saberBlocked)) {
                        //This means that the attack actually hit our saber, and we went to block it.
                        //But, one of the above cases says we actually can't. So we will be smashed into a broken parry instead.
                        otherOwner!.client!.ps.saberMove = BG_BrokenParryForParry(G_GetParryForBlock(otherOwner!.client!.ps.saberBlocked))
                        otherOwner!.client!.ps.saberBlocked = BLOCKED_PARRY_BROKEN

                        otherOwner!.client!.ps.saberEventFlags &= ~SEF_PARRIED
                        `self`.client!.ps.saberEventFlags &= ~SEF_BLOCKED

                        if g_saberDebugPrint.integer != 0 {
                            Com_Printf("Client %i broke through %i's parry with a special or stronger attack\n", `self`.s.number, otherOwner!.s.number)
                        }
                    } else if PM_SaberInParry(G_GetParryForBlock(otherOwner!.client!.ps.saberBlocked)) && !didOffense && tryDeflectAgain {
                        //We want to try deflecting again because the other is in the parry and we haven't made any new moves
                        let preMove: Int32 = otherOwner!.client!.ps.saberMove

                        otherOwner!.client!.ps.saberMove = G_GetParryForBlock(otherOwner!.client!.ps.saberBlocked)
                        WP_GetSaberDeflectionAngle(`self`, otherOwner!, tr.fraction)
                        otherOwner!.client!.ps.saberMove = preMove
                    }
                }
            }

            `self`.client!.ps.saberAttackWound = level.time + g_saberDmgDelay_Wound.integer

            return didHit
        }

        //rww - I'm saying || tr.startsolid here, because otherwise your saber tends to skip positions and go through
        //people, and the compensation traces start in their bbox too. Which results in the saber passing through people
        //when you visually cut right through them. Which sucks.

        if (tr.fraction != 1 || tr.startsolid != 0) && g_entities[tr.entityNum].takedamage && (g_entities[tr.entityNum].health > 0 || !((g_entities[tr.entityNum].s.eFlags & EF_DISINTEGRATION) != 0)) && tr.entityNum != `self`.s.number && g_entities[tr.entityNum].inuse {
            //hit something that had health and takes damage
            if idleDamage && g_entities[tr.entityNum].client != nil && OnSameTeam(`self`, g_entities[tr.entityNum]) && g_friendlySaber.integer == 0 {
                return false
            }

            if g_entities[tr.entityNum].client != nil && g_entities[tr.entityNum].client!.ps.duelInProgress && g_entities[tr.entityNum].client!.ps.duelIndex != `self`.s.number {
                return false
            }

            if g_entities[tr.entityNum].client != nil && `self`.client!.ps.duelInProgress && `self`.client!.ps.duelIndex != g_entities[tr.entityNum].s.number {
                return false
            }

            if BG_StabDownAnim(`self`.client!.ps.torsoAnim) && g_entities[tr.entityNum].client != nil && !BG_InKnockDownOnGround(g_entities[tr.entityNum].client!.ps) {
                //stabdowns only damage people who are actually on the ground...
                return false
            }
            `self`.client!.ps.saberIdleWound = level.time + g_saberDmgDelay_Idle.integer

            didHit = true

            if d_saberSPStyleDamage.integer == 0 //let's trying making blocks have to be blocked by a saber
                && g_entities[tr.entityNum].client != nil && !unblockable && WP_SaberCanBlock(g_entities[tr.entityNum], tr.endpos, 0, MOD_SABER, false, attackStr) != 0 {
                //hit a client who blocked the attack (fake: didn't actually hit their saber)
                if dmg <= SABER_NONATTACK_DAMAGE {
                    `self`.client!.ps.saberIdleWound = level.time + g_saberDmgDelay_Idle.integer
                }
                saberDoClashEffect = true
                saberClashPos = tr.endpos
                saberClashNorm = tr.plane.normal
                saberClashEventParm = 1

                if dmg > SABER_NONATTACK_DAMAGE {
                    let lockFactor: Int32 = g_saberLockFactor.integer

                    if (g_entities[tr.entityNum].client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] - `self`.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE]) > 1 && Q_irand(1, 10) < lockFactor * 2 {
                        //Just got blocked by someone with a decently higher attack level, so enter into a lock (where they have the advantage due to a higher attack lev)
                        if !G_ClientIdleInWorld(g_entities[tr.entityNum]) {
                            if (trMask & CONTENTS_LIGHTSABER) != 0 && WP_SabersCheckLock(`self`, g_entities[tr.entityNum]) {
                                `self`.client!.ps.saberBlocked = BLOCKED_NONE
                                g_entities[tr.entityNum].client!.ps.saberBlocked = BLOCKED_NONE
                                return didHit
                            }
                        }
                    } else if Q_irand(1, 20) < lockFactor {
                        if !G_ClientIdleInWorld(g_entities[tr.entityNum]) {
                            if (trMask & CONTENTS_LIGHTSABER) != 0 && WP_SabersCheckLock(`self`, g_entities[tr.entityNum]) {
                                `self`.client!.ps.saberBlocked = BLOCKED_NONE
                                g_entities[tr.entityNum].client!.ps.saberBlocked = BLOCKED_NONE
                                return didHit
                            }
                        }
                    }
                }
                otherOwner = g_entities[tr.entityNum]
                // Raven wrote `goto blockStuff` at this line.
                return blockStuff()
            } else {
                //damage the thing we hit
                var doDismemberment: Bool = false
                var knockbackFlags: Int32 = 0

                if g_entities[tr.entityNum].client != nil {
                    //not a "jedi", so make them suffer more
                    if dmg > SABER_NONATTACK_DAMAGE {
                        //don't bother increasing just for idle touch damage
                        dmg = Int32(Double(dmg) * 1.5)
                    }
                }
                /*
                if (g_entities[tr.entityNum].client
                && g_entities[tr.entityNum].client->ps.weapon != WP_SABER )//fd.forcePowerLevel[FP_SABER_OFFENSE])
                { //not a "jedi", so make them suffer more
                if ( dmg > SABER_NONATTACK_DAMAGE )
                { //don't bother increasing just for idle touch damage
                dmg *= 1.5;
                }
                }
                */

                if d_saberSPStyleDamage.integer == 0 {
                    if g_entities[tr.entityNum].client != nil && g_entities[tr.entityNum].client!.ps.weapon == WP_SABER {
                        //for jedi using the saber, half the damage (this comes with the increased default dmg debounce time)
                        if g_gametype.integer != GT_SIEGE {
                            //unless siege..
                            if dmg > SABER_NONATTACK_DAMAGE && !unblockable {
                                //don't reduce damage if it's only 1, or if this is an unblockable attack
                                if dmg == SABER_HITDAMAGE {
                                    //level 1 attack
                                    dmg = Int32(Double(dmg) * 0.7)
                                } else {
                                    dmg = Int32(Double(dmg) * 0.5)
                                }
                            }
                        }
                    }
                }

                if `self`.s.eType == ET_NPC && g_entities[tr.entityNum].client != nil && `self`.client!.playerTeam == g_entities[tr.entityNum].client!.playerTeam {
                    //Oops. Since he's an NPC, we'll be forgiving and cut the damage down.
                    dmg = Int32(dmg * 0.2)
                }

                //store the damage, we'll apply it later
                if !WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[rSaberNum], rBladeNum) && !((`self`.client!.saber[rSaberNum].saberFlags2 & SFL2_NO_DISMEMBERMENT) != 0) {
                    doDismemberment = true
                }
                if WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[rSaberNum], rBladeNum) && !((`self`.client!.saber[rSaberNum].saberFlags2 & SFL2_NO_DISMEMBERMENT) != 0) {
                    doDismemberment = true
                }

                if !WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[rSaberNum], rBladeNum) && `self`.client!.saber[rSaberNum].knockbackScale > 0.0 {
                    if rSaberNum < 1 {
                        knockbackFlags = DAMAGE_SABER_KNOCKBACK1
                    } else {
                        knockbackFlags = DAMAGE_SABER_KNOCKBACK2
                    }
                }

                if WP_SaberBladeUseSecondBladeStyle(`self`.client!.saber[rSaberNum], rBladeNum) && `self`.client!.saber[rSaberNum].knockbackScale > 0.0 {
                    if rSaberNum < 1 {
                        knockbackFlags = DAMAGE_SABER_KNOCKBACK1_B2
                    } else {
                        knockbackFlags = DAMAGE_SABER_KNOCKBACK2_B2
                    }
                }

                WP_SaberDamageAdd(tr.entityNum, dir, tr.endpos, dmg, doDismemberment, knockbackFlags)

                if g_entities[tr.entityNum].client != nil {
                    //Let jedi AI know if it hit an enemy
                    if `self`.enemy != nil && `self`.enemy == g_entities[tr.entityNum] {
                        `self`.client!.ps.saberEventFlags |= SEF_HITENEMY
                    } else {
                        `self`.client!.ps.saberEventFlags |= SEF_HITOBJECT
                    }
                }

                if d_saberSPStyleDamage.integer != 0 {
                } else {
                    `self`.client!.ps.saberAttackWound = level.time + 100
                }
            }
        } else if (tr.fraction != 1 || tr.startsolid != 0) && (g_entities[tr.entityNum].r.contents & CONTENTS_LIGHTSABER) != 0 && g_entities[tr.entityNum].r.contents != -1 && g_entities[tr.entityNum].inuse {
            //saber clash
            otherOwner = g_entities[g_entities[tr.entityNum].r.ownerNum]

            if !otherOwner!.inuse || otherOwner!.client == nil {
                return false
            }

            if otherOwner != nil && otherOwner!.client != nil && otherOwner!.client!.ps.saberInFlight {
                //don't do extra collision checking vs sabers in air
            } else {
                //hit an in-hand saber, do extra collision check against it
                if d_saberSPStyleDamage.integer != 0 {
                    //use SP-style blade-collision test
                    if !WP_SabersIntersect(`self`, rSaberNum, rBladeNum, otherOwner!, false) {
                        //sabers did not actually intersect
                        return false
                    }
                } else {
                    //MP-style
                    if !G_SaberCollide(`self`, otherOwner!, lastValidStart, lastValidEnd, &saberTrMins, &saberTrMaxs, &tr.endpos) {
                        //detailed collision did not produce results...
                        return false
                    }
                }
            }

            if OnSameTeam(`self`, otherOwner!) && g_friendlySaber.integer == 0 {
                return false
            }

            if (`self`.s.eType == ET_NPC || otherOwner!.s.eType == ET_NPC) && //just make sure one of us is an npc
                `self`.client!.playerTeam == otherOwner!.client!.playerTeam && g_gametype.integer != GT_SIEGE {
                //don't hit your teammate's sabers if you are an NPC. It can be rather annoying.
                return false
            }

            if otherOwner!.client!.ps.duelInProgress && otherOwner!.client!.ps.duelIndex != `self`.s.number {
                return false
            }

            if `self`.client!.ps.duelInProgress && `self`.client!.ps.duelIndex != otherOwner!.s.number {
                return false
            }

            if g_debugSaberLocks.integer != 0 {
                WP_SabersCheckLock2(`self`, otherOwner!, LOCK_RANDOM)
                return true
            }
            didHit = true
            `self`.client!.ps.saberIdleWound = level.time + g_saberDmgDelay_Idle.integer

            if dmg <= SABER_NONATTACK_DAMAGE {
                `self`.client!.ps.saberIdleWound = level.time + g_saberDmgDelay_Idle.integer
            }

            saberDoClashEffect = true
            saberClashPos = tr.endpos
            saberClashNorm = tr.plane.normal
            saberClashEventParm = 1

            sabersClashed = true
            saberHitSaber = true
            saberHitFraction = tr.fraction

            if saberCheckKnockdown_Smashed(g_entities[tr.entityNum], otherOwner!, `self`, dmg) {
                //smashed it out of the air
                return false
            }

            //is this my thrown saber?
            if `self`.client!.ps.saberEntityNum != 0 && `self`.client!.ps.saberInFlight && rSaberNum == 0 && saberCheckKnockdown_Smashed(g_entities[`self`.client!.ps.saberEntityNum], `self`, otherOwner!, dmg) {
                //they smashed it out of the air
                return false
            }

            return blockStuff()
        }

        return didHit
    }
}

/// Source: oracle/codemp/game/w_saber.c:5275
func VectorCompare2(_ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t) -> Int32 {
    if v1[0] > v2[0] + 0.0001 || v1[0] < v2[0] - 0.0001 || v1[1] > v2[1] + 0.0001 || v1[1] < v2[1] - 0.0001 || v1[2] > v2[2] + 0.0001 || v1[2] < v2[2] - 0.0001 {
        return 0
    }
    return 1
}

/// Source: oracle/codemp/game/w_saber.c:5285
func G_SPSaberDamageTraceLerped(_ `self`: Entity, _ saberNum: Int32, _ bladeNum: Int32, _ baseNew: inout JKAShared.vec3_t, _ endNew: inout JKAShared.vec3_t, _ clipmask: Int32) {
    var baseOld = vec3_t()
    var endOld = vec3_t()
    var mp1 = vec3_t()
    var mp2 = vec3_t()
    var md1 = vec3_t()
    var md2 = vec3_t()

    if (level.time - `self`.client!.saber[saberNum].blade[bladeNum].trail.lastTime) > 100 {
        //no valid last pos, use current
        baseOld = baseNew
        endOld = endNew
    } else {
        //trace from last pos
        baseOld = `self`.client!.saber[saberNum].blade[bladeNum].trail.base
        endOld = `self`.client!.saber[saberNum].blade[bladeNum].trail.tip
    }

    mp1 = baseOld
    mp2 = baseNew
    md1 = endOld - baseOld
    VectorNormalize(&md1)
    md2 = endNew - baseNew
    VectorNormalize(&md2)

    saberHitWall = false
    saberHitSaber = false
    saberHitFraction = 1.0
    if VectorCompare2(baseOld, baseNew) != 0 && VectorCompare2(endOld, endNew) != 0 {
        //no diff
        CheckSaberDamage(`self`, saberNum, bladeNum, baseNew, &endNew, false, clipmask, false)
    } else {
        //saber moved, lerp
        var step: Float = 8
        let stepsize: Float = 8
        var ma1 = vec3_t()
        var ma2 = vec3_t()
        var md2ang = vec3_t()
        var curBase1 = vec3_t()
        var curBase2 = vec3_t()
        var xx: Int32
        var curMD1 = vec3_t()
        var curMD2 = vec3_t()
        let dirInc: Float
        var curDirFrac: Float
        var baseDiff = vec3_t()
        var bladePointOld = vec3_t()
        var bladePointNew = vec3_t()
        var extrapolate: Bool = true

        //do the trace at the base first
        bladePointOld = baseOld
        bladePointNew = baseNew
        CheckSaberDamage(`self`, saberNum, bladeNum, bladePointOld, &bladePointNew, false, clipmask, true)

        //if hit a saber, shorten rest of traces to match
        if saberHitFraction < 1.0 {
            //adjust muzzleDir...
            var ma1 = vec3_t()
            var ma2 = vec3_t()
            vectoangles(md1, &ma1)
            vectoangles(md2, &ma2)
            xx = 0
            while xx < 3 {
                md2ang[xx] = LerpAngle(ma1[xx], ma2[xx], saberHitFraction)
                xx += 1
            }
            // Raven passes NULL for the `right` and `up` outputs.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(md2ang, &md2, &scratchRight, &scratchUp)
            //shorten the base pos
            baseDiff = mp2 - mp1
            _VectorMA(mp1, saberHitFraction, baseDiff, &baseNew)
            _VectorMA(baseNew, `self`.client!.saber[saberNum].blade[bladeNum].lengthMax, md2, &endNew)
        }

        //If the angle diff in the blade is high, need to do it in chunks of 33 to avoid flattening of the arc
        if BG_SaberInAttack(`self`.client!.ps.saberMove) || BG_SaberInSpecialAttack(`self`.client!.ps.torsoAnim) || BG_SpinningSaberAnim(`self`.client!.ps.torsoAnim) || BG_InSpecialJump(`self`.client!.ps.torsoAnim) {
            curDirFrac = _DotProduct(md1, md2)
        } else {
            curDirFrac = 1.0
        }
        //NOTE: if saber spun at least 180 degrees since last damage trace, this is not reliable...!
        if abs(curDirFrac) < 1.0 - MAX_SABER_SWING_INC {
            //the saber blade spun more than 33 degrees since the last damage trace
            dirInc = 1.0 / ((1.0 - curDirFrac) / MAX_SABER_SWING_INC)
            curDirFrac = dirInc
        } else {
            curDirFrac = 1.0
            dirInc = 0.0
        }
        //qboolean hit_saber = qfalse;

        vectoangles(md1, &ma1)
        vectoangles(md2, &ma2)

        //VectorSubtract( md2, md1, mdDiff );
        curMD2 = md1
        curBase2 = baseOld

        while 1 != 0 {
            curMD1 = curMD2
            curBase1 = curBase2
            if curDirFrac >= 1.0 {
                curMD2 = md2
                curBase2 = baseNew
            } else {
                xx = 0
                while xx < 3 {
                    md2ang[xx] = LerpAngle(ma1[xx], ma2[xx], curDirFrac)
                    xx += 1
                }
                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight2 = vec3_t()
                var scratchUp2 = vec3_t()
                AngleVectors(md2ang, &curMD2, &scratchRight2, &scratchUp2)
                //VectorMA( md1, curDirFrac, mdDiff, curMD2 );
                baseDiff = baseNew - baseOld
                _VectorMA(baseOld, curDirFrac, baseDiff, &curBase2)
            }
            // Move up the blade in intervals of stepsize
            step = stepsize
            while step <= `self`.client!.saber[saberNum].blade[bladeNum].lengthMax {
                _VectorMA(curBase1, step, curMD1, &bladePointOld)
                _VectorMA(curBase2, step, curMD2, &bladePointNew)

                if step + stepsize >= `self`.client!.saber[saberNum].blade[bladeNum].lengthMax {
                    extrapolate = false
                }
                //do the damage trace
                CheckSaberDamage(`self`, saberNum, bladeNum, bladePointOld, &bladePointNew, false, clipmask, extrapolate)
                /*
                if ( WP_SaberDamageForTrace( ent->s.number, bladePointOld, bladePointNew, baseDamage, curMD2,
                qfalse, entPowerLevel, ent->client->ps.saber[saberNum].type, qtrue,
                saberNum, bladeNum ) )
                {
                hit_wall = qtrue;
                }
                */

                //if hit a saber, shorten rest of traces to match
                if saberHitFraction < 1.0 {
                    var curMA1 = vec3_t()
                    var curMA2 = vec3_t()
                    //adjust muzzle endpoint
                    baseDiff = mp2 - mp1
                    _VectorMA(mp1, saberHitFraction, baseDiff, &baseNew)
                    _VectorMA(baseNew, `self`.client!.saber[saberNum].blade[bladeNum].lengthMax, curMD2, &endNew)
                    //adjust muzzleDir...
                    vectoangles(curMD1, &curMA1)
                    vectoangles(curMD2, &curMA2)
                    xx = 0
                    while xx < 3 {
                        md2ang[xx] = LerpAngle(curMA1[xx], curMA2[xx], saberHitFraction)
                        xx += 1
                    }
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight3 = vec3_t()
                    var scratchUp3 = vec3_t()
                    AngleVectors(md2ang, &curMD2, &scratchRight3, &scratchUp3)
                    saberHitSaber = true
                }
                if saberHitWall {
                    break
                }
                step += stepsize
            }
            if saberHitWall || saberHitSaber {
                break
            }
            if curDirFrac >= 1.0 {
                break
            } else {
                curDirFrac += dirInc
                if curDirFrac >= 1.0 {
                    curDirFrac = 1.0
                }
            }
        }

        //do the trace at the end last
        //Special check- adjust for length of blade not being a multiple of 12
        /*
        aveLength = (ent->client->ps.saber[saberNum].blade[bladeNum].lengthOld + ent->client->ps.saber[saberNum].blade[bladeNum].length)/2;
        if ( step > aveLength )
        {//less dmg if the last interval was not stepsize
        tipDmgMod = (stepsize-(step-aveLength))/stepsize;
        }
        //NOTE: since this is the tip, we do not extrapolate the extra 16
        if ( WP_SaberDamageForTrace( ent->s.number, endOld, endNew, tipDmgMod*baseDamage, md2,
        qfalse, entPowerLevel, ent->client->ps.saber[saberNum].type, qfalse,
        saberNum, bladeNum ) )
        {
        hit_wall = qtrue;
        }
        */
    }
}

/// Source: oracle/codemp/game/w_saber.c:5492
func WP_SaberStartMissileBlockCheck(_ `self`: Entity, _ ucmd: JKAMP.Usercmd) {
    var dist: Float = 0
    var ent: Entity?
    var incoming: Entity? = nil
    var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
    var numListedEntities: Int32 = 0
    var mins = vec3_t()
    var maxs = vec3_t()
    var i: Int32 = 0
    var e: Int32 = 0
    var closestDist: Float = 0
    let radius: Float = 256
    var forward = vec3_t()
    var dir = vec3_t()
    var missile_dir = vec3_t()
    var fwdangles = vec3_t(0, 0, 0)
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var traceTo = vec3_t()
        var entDir = vec3_t()
        var dot1: Float = 0
        var dot2: Float = 0
        var lookTDist: Float = -1
        var lookT: Entity? = nil
        var doFullRoutine: Bool = true

        //keep this updated even if we don't get below
        if !((`self`.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0) {
            //lookTarget is set by and to the monster that's holding you, no other operations can change that
            `self`.client!.ps.hasLookTarget = false
        }

        if `self`.client!.ps.weapon != WP_SABER && `self`.client!.NPC_class != CLASS_BOBAFETT {
            doFullRoutine = false
        } else if `self`.client!.ps.saberInFlight {
            doFullRoutine = false
        } else if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_LIGHTNING)) != 0 {
            //can't block while zapping
            doFullRoutine = false
        } else if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_DRAIN)) != 0 {
            //can't block while draining
            doFullRoutine = false
        } else if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_PUSH)) != 0 {
            //can't block while shoving
            doFullRoutine = false
        } else if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 {
            //can't block while gripping (FIXME: or should it break the grip?  Pain should break the grip, I think...)
            doFullRoutine = false
        }

        if `self`.client!.ps.weaponTime > 0 {
            //don't autoblock while busy with stuff
            return true
        }

        if (`self`.client!.saber[0].saberFlags & SFL_NOT_ACTIVE_BLOCKING) != 0 {
            //can't actively block with this saber type
            return true
        }

        if `self`.health <= 0 {
            //dead don't try to block (NOTE: actual deflection happens in missile code)
            return true
        }
        if PM_InKnockDown(`self`.client!.ps) {
            //can't block when knocked down
            return true
        }

        if BG_SabersOff(`self`.client!.ps) && `self`.client!.NPC_class != CLASS_BOBAFETT {
            if `self`.s.eType != ET_NPC {
                //player doesn't auto-activate
                doFullRoutine = false
            }
        }

        if `self`.s.eType == ET_PLAYER {
            //don't do this if already attacking!
            if (ucmd.buttons & BUTTON_ATTACK) != 0 || BG_SaberInAttack(`self`.client!.ps.saberMove) || BG_SaberInSpecialAttack(`self`.client!.ps.torsoAnim) || BG_SaberInTransitionAny(`self`.client!.ps.saberMove) {
                doFullRoutine = false
            }
        }

        if `self`.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] > level.time {
            //can't block while gripping (FIXME: or should it break the grip?  Pain should break the grip, I think...)
            doFullRoutine = false
        }

        fwdangles[1] = `self`.client!.ps.viewangles[1]
        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(fwdangles, &forward, &scratchRight, &scratchUp)

        i = 0
        while i < 3 {
            mins[i] = `self`.r.currentOrigin[i] - radius
            maxs[i] = `self`.r.currentOrigin[i] + radius
            i += 1
        }

        numListedEntities = trap_EntitiesInBox(mins, maxs, &entityList, MAX_GENTITIES)

        closestDist = radius

        e = 0
        while e < numListedEntities {
            ent = g_entities[entityList[e]]

            if ent == `self` {
                e += 1
                continue
            }

            //as long as we're here I'm going to get a looktarget too, I guess. -rww
            if `self`.s.eType == ET_PLAYER && ent!.client != nil && (ent!.s.eType == ET_NPC || ent!.s.eType == ET_PLAYER) && !OnSameTeam(ent!, `self`) && ent!.client!.sess.sessionTeam != TEAM_SPECTATOR && !((ent!.client!.ps.pm_flags & PMF_FOLLOW) != 0) && (ent!.s.eType != ET_NPC || ent!.s.NPC_class != CLASS_VEHICLE) && ent!.health > 0 {
                //seems like a valid enemy to look at.
                var vecSub = vec3_t()
                var vecLen: Float = 0

                vecSub = `self`.client!.ps.origin - ent!.client!.ps.origin
                vecLen = VectorLength(vecSub)

                if lookTDist == -1 || vecLen < lookTDist {
                    // Raven's record lives to the end of his block, so the block is the closure.
                    Trace.scratch { tr in
                        var myEyes = vec3_t()

                        myEyes = `self`.client!.ps.origin
                        myEyes[2] += `self`.client!.ps.viewheight

                        trap_Trace(tr, myEyes, vec3_origin, vec3_origin, ent!.client!.ps.origin, `self`.s.number, MASK_PLAYERSOLID)

                        if tr.fraction == 1.0 || tr.entityNum == ent!.s.number {
                            //we have a clear line of sight to him, so it's all good.
                            lookT = ent
                            lookTDist = vecLen
                        }
                    }
                }
            }

            if !doFullRoutine {
                //don't care about the rest then
                e += 1
                continue
            }

            if ent!.r.ownerNum == `self`.s.number {
                e += 1
                continue
            }
            if !(ent!.inuse) {
                e += 1
                continue
            }
            if ent!.s.eType != ET_MISSILE && !((ent!.s.eFlags & EF_MISSILE_STICK) != 0) {
                //not a normal projectile
                var pOwner: Entity?

                if ent!.r.ownerNum < 0 || ent!.r.ownerNum >= ENTITYNUM_WORLD {
                    //not going to be a client then.
                    e += 1
                    continue
                }

                pOwner = g_entities[ent!.r.ownerNum]

                if !pOwner!.inuse || pOwner!.client == nil {
                    e += 1
                    continue //not valid cl owner
                }

                if pOwner!.client!.ps.saberEntityNum == 0 || !pOwner!.client!.ps.saberInFlight || pOwner!.client!.ps.saberEntityNum != ent!.s.number {
                    //the saber is knocked away and/or not flying actively, or this ent is not the cl's saber ent at all
                    e += 1
                    continue
                }

                //If we get here then it's ok to be treated as a thrown saber, I guess.
            } else {
                if ent!.s.pos.trType == TR_STATIONARY && `self`.s.eType == ET_PLAYER {
                    //nothing you can do with a stationary missile if you're the player
                    e += 1
                    continue
                }
            }

            //see if they're in front of me
            dir = ent!.r.currentOrigin - `self`.r.currentOrigin
            dist = VectorNormalize(&dir)
            //FIXME: handle detpacks, proximity mines and tripmines
            if ent!.s.weapon == WP_THERMAL {
                //thermal detonator!
                if `self`.NPC != nil && dist < ent!.splashRadius {
                    var jump = false
                    if dist < ent!.splashRadius && ent!.nextthink < level.time + 600 && ent!.count != 0 && `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                        jump = ent!.s.pos.trType == TR_STATIONARY || ent!.s.pos.trType == TR_INTERPOLATE
                        if !jump {
                            dot1 = _DotProduct(dir, forward)
                            jump = dot1 < SABER_REFLECT_MISSILE_CONE
                        }
                        if !jump {
                            jump = !WP_ForcePowerUsable(`self`, FP_PUSH)
                        }
                    }
                    if jump {
                        //TD is close enough to hurt me, I'm on the ground and the thing is at rest or behind me and about to blow up, or I don't have force-push so force-jump!
                        //FIXME: sometimes this might make me just jump into it...?
                        `self`.client!.ps.fd.forceJumpCharge = 480
                    } else if `self`.client!.NPC_class != CLASS_BOBAFETT {
                        //FIXME: check forcePushRadius[NPC->client->ps.forcePowerLevel[FP_PUSH]]
                        ForceThrow(`self`, false)
                    }
                }
                e += 1
                continue
            } else if ent!.splashDamage != 0 && ent!.splashRadius != 0 {
                //exploding missile
                //FIXME: handle tripmines and detpacks somehow...
                //			maybe do a force-gesture that makes them explode?
                //			But what if we're within it's splashradius?
                if `self`.s.eType == ET_PLAYER {
                    //players don't auto-handle these at all
                    e += 1
                    continue
                } else {
                    //if ( ent->s.pos.trType == TR_STATIONARY && (ent->s.eFlags&EF_MISSILE_STICK)
                    //	&& 	self->client->NPC_class != CLASS_BOBAFETT )
                    if 0 != 0 {
                        //a placed explosive like a tripmine or detpack
                        if InFOV3(ent!.r.currentOrigin, `self`.client!.renderInfo.eyePoint, `self`.client!.ps.viewangles, 90, 90) {
                            //in front of me
                            if G_ClearLOS4(`self`, ent!) {
                                //can see it
                                var throwDir = vec3_t()
                                //make the gesture
                                ForceThrow(`self`, false)
                                //take it off the wall and toss it
                                ent!.s.pos.trType = TR_GRAVITY
                                ent!.s.eType = ET_MISSILE
                                ent!.s.eFlags &= ~EF_MISSILE_STICK
                                ent!.flags |= FL_BOUNCE_HALF
                                // Raven passes NULL for the `right` and `up` outputs.
                                var scratchRight2 = vec3_t()
                                var scratchUp2 = vec3_t()
                                AngleVectors(ent!.r.currentAngles, &throwDir, &scratchRight2, &scratchUp2)
                                _VectorMA(ent!.r.currentOrigin, ent!.r.maxs[0] + 4, throwDir, &ent!.r.currentOrigin)
                                ent!.s.pos.trBase = ent!.r.currentOrigin
                                ent!.s.pos.trDelta = throwDir * 300
                                ent!.s.pos.trDelta[2] += 150
                                _VectorMA(ent!.s.pos.trDelta, 800, dir, &ent!.s.pos.trDelta)
                                ent!.s.pos.trTime = level.time // move a bit on the very first frame
                                ent!.s.pos.trBase = ent!.r.currentOrigin
                                ent!.r.ownerNum = `self`.s.number
                                // make it explode, but with less damage
                                ent!.splashDamage /= 3
                                ent!.splashRadius /= 3
                                //ent->think = WP_Explode;
                                ent!.nextthink = level.time + Q_irand(500, 3000)
                            }
                        }
                    } else if dist < ent!.splashRadius && `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE && (_DotProduct(dir, forward) < SABER_REFLECT_MISSILE_CONE || !WP_ForcePowerUsable(`self`, FP_PUSH)) {
                        //NPCs try to evade it
                        `self`.client!.ps.fd.forceJumpCharge = 480
                    } else if `self`.client!.NPC_class != CLASS_BOBAFETT {
                        //else, try to force-throw it away
                        //FIXME: check forcePushRadius[NPC->client->ps.forcePowerLevel[FP_PUSH]]
                        ForceThrow(`self`, false)
                    }
                }
                //otherwise, can't block it, so we're screwed
                e += 1
                continue
            }

            if ent!.s.weapon != WP_SABER {
                //only block shots coming from behind
                dot1 = _DotProduct(dir, forward)
                if dot1 < SABER_REFLECT_MISSILE_CONE {
                    e += 1
                    continue
                }
            } else if `self`.s.eType == ET_PLAYER {
                //player never auto-blocks thrown sabers
                e += 1
                continue
            }

            //see if they're heading towards me
            missile_dir = ent!.s.pos.trDelta
            VectorNormalize(&missile_dir)
            dot2 = _DotProduct(dir, missile_dir)
            if dot2 > 0 {
                e += 1
                continue
            }

            //FIXME: must have a clear trace to me, too...
            if dist < closestDist {
                traceTo = `self`.r.currentOrigin
                traceTo[2] = `self`.r.absmax[2] - 4
                trap_Trace(trace, ent!.r.currentOrigin, ent!.r.mins, ent!.r.maxs, traceTo, ent!.s.number, ent!.clipmask)
                if trace.allsolid != 0 || trace.startsolid != 0 || (trace.fraction < 1.0 && trace.entityNum != `self`.s.number && trace.entityNum != `self`.client!.ps.saberEntityNum) {
                    //okay, try one more check
                    VectorNormalize2(ent!.s.pos.trDelta, &entDir)
                    _VectorMA(ent!.r.currentOrigin, radius, entDir, &traceTo)
                    trap_Trace(trace, ent!.r.currentOrigin, ent!.r.mins, ent!.r.maxs, traceTo, ent!.s.number, ent!.clipmask)
                    if trace.allsolid != 0 || trace.startsolid != 0 || (trace.fraction < 1.0 && trace.entityNum != `self`.s.number && trace.entityNum != `self`.client!.ps.saberEntityNum) {
                        //can't hit me, ignore it
                        e += 1
                        continue
                    }
                }
                if `self`.s.eType == ET_NPC {
                    //An NPC
                    if `self`.NPC != nil && `self`.enemy == nil && ent!.r.ownerNum != ENTITYNUM_NONE {
                        let owner: Entity? = g_entities[ent!.r.ownerNum]
                        if owner!.health >= 0 && (owner!.client == nil || owner!.client!.playerTeam != `self`.client!.playerTeam) {
                            G_SetEnemy(`self`, owner!)
                        }
                    }
                }
                //FIXME: if NPC, predict the intersection between my current velocity/path and the missile's, see if it intersects my bounding box (+/-saberLength?), don't try to deflect unless it does?
                closestDist = dist
                incoming = ent
            }
            e += 1
        }

        if `self`.s.eType == ET_NPC && `self`.localAnimIndex <= 1 {
            //humanoid NPCs don't set angles based on server angles for looking, unlike other NPCs
            if `self`.client != nil && `self`.client!.renderInfo.lookTarget < ENTITYNUM_WORLD {
                lookT = g_entities[`self`.client!.renderInfo.lookTarget]
            }
        }

        if lookT != nil {
            //we got a looktarget at some point so we'll assign it then.
            if !((`self`.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0) {
                //lookTarget is set by and to the monster that's holding you, no other operations can change that
                `self`.client!.ps.hasLookTarget = true
                `self`.client!.ps.lookTarget = lookT!.s.number
            }
        }

        if !doFullRoutine {
            //then we're done now
            return true
        }

        if incoming != nil {
            if `self`.NPC != nil {
                if Jedi_WaitingAmbush(`self`) {
                    Jedi_Ambush(`self`)
                }
                if `self`.client!.NPC_class == CLASS_BOBAFETT && (`self`.client!.ps.eFlags2 & EF2_FLYING) != 0 && incoming!.methodOfDeath != MOD_ROCKET_HOMING {
                    //a hovering Boba Fett, not a tracking rocket
                    if Q_irand(0, 1) == 0 {
                        //strafe
                        `self`.NPC!.standTime = 0
                        `self`.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + Q_irand(1000, 2000)
                    }
                    if Q_irand(0, 1) == 0 {
                        //go up/down
                        TIMER_Set(`self`, "heightChange", Q_irand(1000, 3000))
                        `self`.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + Q_irand(1000, 2000)
                    }
                } else if Jedi_SaberBlockGo(`self`, `self`.NPC!.last_ucmd, nil, nil, incoming, 0.0) != EVASION_NONE {
                    //make sure to turn on your saber if it's not on
                    if `self`.client!.NPC_class != CLASS_BOBAFETT {
                        //self->client->ps.SaberActivate();
                        WP_ActivateSaber(`self`)
                    }
                }
            } else {
                let owner: Entity? = g_entities[incoming!.r.ownerNum]

                WP_SaberBlockNonRandom(`self`, incoming!.r.currentOrigin, true)
                if owner != nil && owner!.client != nil && (`self`.enemy == nil || `self`.enemy!.s.weapon != WP_SABER) {
                    `self`.enemy = owner
                    //NPC_SetLookTarget( self, owner->s.number, level.time+1000 );
                    //player looktargetting done differently
                }
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_saber.c:5894
private func CheckThrownSaberDamaged(_ saberent: Entity, _ saberOwner: Entity, _ ent: Entity, _ dist: Int32, _ returning: Int32, _ noDCheck: Bool) -> Bool {
    var vecsub = vec3_t()
    var veclen: Float = 0
    var te: Entity?

    if saberOwner.client != nil && saberOwner.client!.ps.saberAttackWound > level.time {
        return false
    }

    if ent.client != nil && ent.inuse && ent.s.number != saberOwner.s.number && ent.health > 0 && ent.takedamage && trap_InPVS(ent.client!.ps.origin, saberent.r.currentOrigin) && ent.client!.sess.sessionTeam != TEAM_SPECTATOR && (ent.client!.pers.connected != 0 || ent.s.eType == ET_NPC) {
        //hit a client
        if ent.inuse && ent.client != nil && ent.client!.ps.duelInProgress && ent.client!.ps.duelIndex != saberOwner.s.number {
            return false
        }

        if ent.inuse && ent.client != nil && saberOwner.client!.ps.duelInProgress && saberOwner.client!.ps.duelIndex != ent.s.number {
            return false
        }

        vecsub = saberent.r.currentOrigin - ent.client!.ps.origin
        veclen = VectorLength(vecsub)

        if veclen < dist {
            //within range
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives nil where Raven's block falls through to its end.
            let earlyOut = Trace.scratch { tr -> Bool? in

                trap_Trace(tr, saberent.r.currentOrigin, vec3_origin, vec3_origin, ent.client!.ps.origin, saberent.s.number, MASK_SHOT)

                if tr.fraction == 1 || tr.entityNum == ent.s.number {
                    //Slice them
                    if !saberOwner.client!.ps.isJediMaster && WP_SaberCanBlock(ent, tr.endpos, 0, MOD_SABER, false, 999) != 0 {
                        //they blocked it
                        WP_SaberBlockNonRandom(ent, tr.endpos, false)

                        te = G_TempEntity(tr.endpos, EV_SABER_BLOCK)
                        te!.s.origin = tr.endpos
                        te!.s.angles = tr.plane.normal
                        if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
                            te!.s.angles[1] = 1
                        }
                        te!.s.eventParm = 1
                        te!.s.weapon = 0 //saberNum
                        te!.s.legsAnim = 0 //bladeNum

                        if saberCheckKnockdown_Thrown(saberent, saberOwner, g_entities[tr.entityNum]) {
                            //it was knocked out of the air
                            return false
                        }

                        if returning == 0 {
                            //return to owner if blocked
                            thrownSaberTouch(saberent, saberent, nil)
                        }

                        saberOwner.client!.ps.saberAttackWound = level.time + 500
                        return false
                    } else {
                        //a good hit
                        var dir = vec3_t()
                        var dflags: Int32 = 0

                        dir = tr.endpos - saberent.r.currentOrigin
                        VectorNormalize(&dir)

                        if dir[0] == 0 && dir[1] == 0 && dir[2] == 0 {
                            dir[1] = 1
                        }

                        if (saberOwner.client!.saber[0].saberFlags2 & SFL2_NO_DISMEMBERMENT) != 0 {
                            dflags |= DAMAGE_NO_DISMEMBER
                        }

                        if saberOwner.client!.saber[0].knockbackScale > 0.0 {
                            dflags |= DAMAGE_SABER_KNOCKBACK1
                        }

                        if saberOwner.client!.ps.isJediMaster {
                            //2x damage for the Jedi Master
                            G_Damage(ent, saberOwner, saberOwner, &dir, tr.endpos, saberent.damage * 2, dflags, MOD_SABER)
                        } else {
                            G_Damage(ent, saberOwner, saberOwner, &dir, tr.endpos, saberent.damage, dflags, MOD_SABER)
                        }

                        te = G_TempEntity(tr.endpos, EV_SABER_HIT)
                        te!.s.otherEntityNum = ent.s.number
                        te!.s.otherEntityNum2 = saberOwner.s.number
                        te!.s.weapon = 0 //saberNum
                        te!.s.legsAnim = 0 //bladeNum
                        te!.s.origin = tr.endpos
                        te!.s.angles = tr.plane.normal
                        if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
                            te!.s.angles[1] = 1
                        }

                        te!.s.eventParm = 1

                        if returning == 0 {
                            //return to owner if blocked
                            thrownSaberTouch(saberent, saberent, nil)
                        }
                    }

                    saberOwner.client!.ps.saberAttackWound = level.time + 500
                }
                return nil
            }
            if let earlyOut {
                return earlyOut
            }
        }
    } else if ent.client == nil && ent.inuse && ent.takedamage && ent.health > 0 && ent.s.number != saberOwner.s.number && ent.s.number != saberent.s.number && (noDCheck || trap_InPVS(ent.r.currentOrigin, saberent.r.currentOrigin)) {
        //hit a non-client

        if noDCheck {
            veclen = 0
        } else {
            vecsub = saberent.r.currentOrigin - ent.r.currentOrigin
            veclen = VectorLength(vecsub)
        }

        if veclen < dist {
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { tr in
                var entOrigin = vec3_t()

                if ent.s.eType == ET_MOVER {
                    entOrigin = ent.r.absmax - ent.r.absmin
                    _VectorMA(ent.r.absmin, 0.5, entOrigin, &entOrigin)
                    entOrigin = ent.r.absmin + ent.r.absmax
                    entOrigin = entOrigin * 0.5
                } else {
                    entOrigin = ent.r.currentOrigin
                }

                trap_Trace(tr, saberent.r.currentOrigin, vec3_origin, vec3_origin, entOrigin, saberent.s.number, MASK_SHOT)

                if tr.fraction == 1 || tr.entityNum == ent.s.number {
                    var dir = vec3_t()
                    var dflags: Int32 = 0

                    dir = tr.endpos - entOrigin
                    VectorNormalize(&dir)

                    if (saberOwner.client!.saber[0].saberFlags2 & SFL2_NO_DISMEMBERMENT) != 0 {
                        dflags |= DAMAGE_NO_DISMEMBER
                    }
                    if saberOwner.client!.saber[0].knockbackScale > 0.0 {
                        dflags |= DAMAGE_SABER_KNOCKBACK1
                    }

                    if ent.s.eType == ET_NPC {
                        //an animent
                        G_Damage(ent, saberOwner, saberOwner, &dir, tr.endpos, 40, dflags, MOD_SABER)
                    } else {
                        G_Damage(ent, saberOwner, saberOwner, &dir, tr.endpos, 5, dflags, MOD_SABER)
                    }

                    te = G_TempEntity(tr.endpos, EV_SABER_HIT)
                    te!.s.otherEntityNum = ENTITYNUM_NONE //don't do this for throw damage
                    //te->s.otherEntityNum = ent->s.number;
                    te!.s.otherEntityNum2 = saberOwner.s.number //actually, do send this, though - for the overridden per-saber hit effects/sounds
                    te!.s.weapon = 0 //saberNum
                    te!.s.legsAnim = 0 //bladeNum
                    te!.s.origin = tr.endpos
                    te!.s.angles = tr.plane.normal
                    if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
                        te!.s.angles[1] = 1
                    }

                    if ent.s.eType == ET_MOVER {
                        if saberOwner.client != nil && (saberOwner.client!.saber[0].saberFlags2 & SFL2_NO_CLASH_FLARE) != 0 {
                            //don't do clash flare - NOTE: assumes same is true for both sabers if using dual sabers!
                            G_FreeEntity(te!) //kind of a waste, but...
                        } else {
                            //I suppose I could tie this into the saberblock event, but I'm tired of adding flags to that thing.
                            let teS: Entity? = G_TempEntity(te!.s.origin, EV_SABER_CLASHFLARE)
                            teS!.s.origin = te!.s.origin

                            te!.s.eventParm = 0
                        }
                    } else {
                        te!.s.eventParm = 1
                    }

                    if returning == 0 {
                        //return to owner if blocked
                        thrownSaberTouch(saberent, saberent, nil)
                    }

                    saberOwner.client!.ps.saberAttackWound = level.time + 500
                }
            }
        }
    }

    return true
}

/// Source: oracle/codemp/game/w_saber.c:6127
private func saberCheckRadiusDamage(_ saberent: Entity, _ returning: Int32) {
    //we're going to cheat and damage players within the saber's radius, just for the sake of doing things more "efficiently" (and because the saber entity has no server g2 instance)
    var i: Int32 = 0
    var dist: Int32 = 0
    var ent: Entity?
    let saberOwner: Entity? = g_entities[saberent.r.ownerNum]

    if returning != 0 && returning != 2 {
        dist = MIN_SABER_SLICE_RETURN_DISTANCE
    } else {
        dist = MIN_SABER_SLICE_DISTANCE
    }

    if saberOwner == nil || saberOwner!.client == nil {
        return
    }

    if saberOwner!.client!.ps.saberAttackWound > level.time {
        return
    }

    while i < level.num_entities {
        ent = g_entities[i]

        CheckThrownSaberDamaged(saberent, saberOwner!, ent!, dist, returning, false)

        i += 1
    }
}

/// Source: oracle/codemp/game/w_saber.c:6165
private func saberMoveBack(_ ent: Entity, _ goingBack: Bool) {
    var origin = vec3_t()
    var oldOrg = vec3_t()

    ent.s.pos.trType = TR_LINEAR

    oldOrg = ent.r.currentOrigin
    // get current position
    BG_EvaluateTrajectory(ent.s.pos, level.time, &origin)
    //Get current angles?
    BG_EvaluateTrajectory(ent.s.apos, level.time, &ent.r.currentAngles)

    //compensation test code..
    if !goingBack && ent.s.pos.trType != TR_GRAVITY {
        //acts as a fallback in case touch code fails, keeps saber from going through things between predictions
        var originalLength: Float = 0
        let iCompensationLength: Int32 = 32
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut = Trace.scratch { tr -> Bool in
            var mins = vec3_t()
            var maxs = vec3_t()
            var calcComp = vec3_t()
            var compensatedOrigin = vec3_t()
            mins = vec3_t(-24.0, -24.0, -8.0)
            maxs = vec3_t(24.0, 24.0, 8.0)

            calcComp = origin - oldOrg
            originalLength = VectorLength(calcComp)

            VectorNormalize(&calcComp)

            compensatedOrigin[0] = oldOrg[0] + calcComp[0] * (originalLength + iCompensationLength)
            compensatedOrigin[1] = oldOrg[1] + calcComp[1] * (originalLength + iCompensationLength)
            compensatedOrigin[2] = oldOrg[2] + calcComp[2] * (originalLength + iCompensationLength)

            trap_Trace(tr, oldOrg, mins, maxs, compensatedOrigin, ent.r.ownerNum, MASK_PLAYERSOLID)

            if (tr.fraction != 1 || tr.startsolid != 0 || tr.allsolid != 0) && tr.entityNum != ent.r.ownerNum && !((g_entities[tr.entityNum].r.contents & CONTENTS_LIGHTSABER) != 0) {
                ent.s.pos.trDelta = vec3_t()

                //Unfortunately doing this would defeat the purpose of the compensation. We will have to settle for a jerk on the client.
                //VectorCopy( origin, ent->r.currentOrigin );

                //we'll skip the dist check, since we don't really care about that (we just hit it physically)
                CheckThrownSaberDamaged(ent, g_entities[ent.r.ownerNum], g_entities[tr.entityNum], 256, 0, true)

                if ent.s.pos.trType == TR_GRAVITY {
                    //got blocked and knocked away in the damage func
                    return true
                }

                tr.startsolid = 0
                if tr.entityNum == ENTITYNUM_NONE {
                    //eh, this is a filthy lie. (obviously it had to hit something or it wouldn't be in here, so we'll say it hit the world)
                    tr.entityNum = ENTITYNUM_WORLD
                }
                thrownSaberTouch(ent, g_entities[tr.entityNum], tr)
                return true
            }
            return false
        }
        if earlyOut {
            return
        }
    }

    ent.r.currentOrigin = origin
}

/// Source: oracle/codemp/game/w_saber.c:6229
func SaberBounceSound(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    `self`.s.apos.trBase = `self`.r.currentAngles
    `self`.s.apos.trBase[PITCH] = 90
}

/// Source: oracle/codemp/game/w_saber.c:6235
func DeadSaberThink(_ saberent: Entity) {
    if saberent.speed < level.time {
        saberent.think = Think.G_FreeEntity
        saberent.nextthink = level.time
        return
    }

    G_RunObject(saberent)
}

/// Source: oracle/codemp/game/w_saber.c:6247
func MakeDeadSaber(_ ent: Entity) {
    //spawn a "dead" saber entity here so it looks like the saber fell out of the air.
    //This entity will remove itself after a very short time period.
    var startorg = vec3_t()
    var startang = vec3_t()
    var saberent: Entity?
    var owner: Entity? = nil

    if g_gametype.integer == GT_JEDIMASTER {
        //never spawn a dead saber in JM, because the only saber on the level is really a world object
        //G_Sound(ent, CHAN_AUTO, saberOffSound);
        return
    }

    saberent = G_Spawn()

    startorg = ent.r.currentOrigin
    startang = ent.r.currentAngles

    saberent!.classname = "deadsaber"

    saberent!.r.svFlags = SVF_USE_CURRENT_ORIGIN
    saberent!.r.ownerNum = ent.s.number

    saberent!.clipmask = MASK_PLAYERSOLID
    saberent!.r.contents = CONTENTS_TRIGGER //0;

    saberent!.r.mins = vec3_t(-3.0, -3.0, -1.5)
    saberent!.r.maxs = vec3_t(3.0, 3.0, 1.5)

    saberent!.touch = Touch.SaberBounceSound

    saberent!.think = Think.DeadSaberThink
    saberent!.nextthink = level.time

    saberent!.s.pos.trBase = startorg
    saberent!.s.apos.trBase = startang

    saberent!.s.origin = startorg
    saberent!.s.angles = startang

    saberent!.r.currentOrigin = startorg
    saberent!.r.currentAngles = startang

    saberent!.s.apos.trType = TR_GRAVITY
    saberent!.s.apos.trDelta[0] = Float(Q_irand(200, 800))
    saberent!.s.apos.trDelta[1] = Float(Q_irand(200, 800))
    saberent!.s.apos.trDelta[2] = Float(Q_irand(200, 800))
    saberent!.s.apos.trTime = level.time - 50

    saberent!.s.pos.trType = TR_GRAVITY
    saberent!.s.pos.trTime = level.time - 50
    saberent!.flags = FL_BOUNCE_HALF
    if ent.r.ownerNum >= 0 && ent.r.ownerNum < ENTITYNUM_WORLD {
        owner = g_entities[ent.r.ownerNum]

        if owner!.inuse && owner!.client != nil && !owner!.client!.saber[0].model.isEmpty {
            WP_SaberAddG2Model(saberent!, owner!.client!.saber[0].model, owner!.client!.saber[0].skin)
        } else {
            //WP_SaberAddG2Model( saberent, NULL, 0 );
            //argh!!!!
            G_FreeEntity(saberent!)
            return
        }
    }

    saberent!.s.modelGhoul2 = 1
    saberent!.s.g2radius = 20

    saberent!.s.eType = ET_MISSILE
    saberent!.s.weapon = WP_SABER

    saberent!.speed = Float(level.time + 4000)

    saberent!.bounceCount = 12

    //fall off in the direction the real saber was headed
    saberent!.s.pos.trDelta = ent.s.pos.trDelta

    saberMoveBack(saberent!, true)
    saberent!.s.pos.trType = TR_GRAVITY

    trap_LinkEntity(saberent!)
}

/// Source: oracle/codemp/game/w_saber.c:6342
func DownedSaberThink(_ saberent: Entity) {
    var saberOwn: Entity? = nil
    var notDisowned: Bool = false
    var pullBack: Bool = false

    saberent.nextthink = level.time

    if saberent.r.ownerNum == ENTITYNUM_NONE {
        MakeDeadSaber(saberent)

        saberent.think = Think.G_FreeEntity
        saberent.nextthink = level.time
        return
    }

    saberOwn = g_entities[saberent.r.ownerNum]

    if saberOwn == nil || !saberOwn!.inuse || saberOwn!.client == nil || saberOwn!.client!.sess.sessionTeam == TEAM_SPECTATOR || (saberOwn!.client!.ps.pm_flags & PMF_FOLLOW) != 0 {
        MakeDeadSaber(saberent)

        saberent.think = Think.G_FreeEntity
        saberent.nextthink = level.time
        return
    }

    if saberOwn!.client!.ps.saberEntityNum != 0 {
        if saberOwn!.client!.ps.saberEntityNum == saberent.s.number {
            //owner shouldn't have this set if we're thinking in here. Must've fallen off a cliff and instantly respawned or something.
            notDisowned = true
        } else {
            //This should never happen, but just in case..
            MakeDeadSaber(saberent)

            saberent.think = Think.G_FreeEntity
            saberent.nextthink = level.time
            return
        }
    }

    if notDisowned || saberOwn!.health < 1 || saberOwn!.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] == 0 {
        //He's dead, just go back to our normal saber status
        saberOwn!.client!.ps.saberEntityNum = saberOwn!.client!.saberStoredIndex

        //MakeDeadSaber(saberent); //spawn a dead saber on top of where we are now. The "bodyqueue" method.
        //Actually this will get taken care of when the thrown saber func sees we're dead.


        saberReactivate(saberent, saberOwn!)

        if saberOwn!.health < 1 {
            saberOwn!.client!.ps.saberInFlight = false
            MakeDeadSaber(saberent)
        }

        saberent.touch = Touch.SaberGotHit
        saberent.think = Think.SaberUpdateSelf
        saberent.genericValue5 = 0
        saberent.nextthink = level.time

        saberent.r.svFlags |= (SVF_NOCLIENT)
        //saberent->r.contents = CONTENTS_LIGHTSABER;
        saberent.s.loopSound = 0
        saberent.s.loopIsSoundset = false

        if saberOwn!.health > 0 {
            //only set this if he's alive. If dead we want to reflect the lack of saber on the corpse, as he died with his saber out.
            saberOwn!.client!.ps.saberInFlight = false
            WP_SaberRemoveG2Model(saberent)
        }
        saberOwn!.client!.ps.saberEntityState = 0
        saberOwn!.client!.ps.saberThrowDelay = level.time + 500
        saberOwn!.client!.ps.saberCanThrow = false

        return
    }

    if saberOwn!.client!.saberKnockedTime < level.time && (saberOwn!.client!.pers.cmd.buttons & BUTTON_ATTACK) != 0 {
        //He wants us back
        pullBack = true
    } else if (level.time - saberOwn!.client!.saberKnockedTime) > MAX_LEAVE_TIME {
        //Been sitting around for too long, go back no matter what he wants.
        pullBack = true
    }

    if pullBack {
        //Get going back to the owner.
        saberOwn!.client!.ps.saberEntityNum = saberOwn!.client!.saberStoredIndex

        saberReactivate(saberent, saberOwn!)

        saberent.touch = Touch.SaberGotHit

        saberent.think = Think.saberBackToOwner
        saberent.speed = 0
        saberent.genericValue5 = 0
        saberent.nextthink = level.time

        saberent.r.contents = CONTENTS_LIGHTSABER

        G_Sound(saberOwn!, CHAN_BODY, G_SoundIndex("sound/weapons/force/pull.wav"))
        if saberOwn!.client!.saber[0].soundOn != 0 {
            G_Sound(saberent, CHAN_BODY, saberOwn!.client!.saber[0].soundOn)
        }
        if saberOwn!.client!.saber[1].soundOn != 0 {
            G_Sound(saberOwn!, CHAN_BODY, saberOwn!.client!.saber[1].soundOn)
        }

        return
    }

    G_RunObject(saberent)
    saberent.nextthink = level.time
}

/// Source: oracle/codemp/game/w_saber.c:6482
func saberReactivate(_ saberent: Entity, _ saberOwner: Entity) {
    saberent.s.saberInFlight = true

    saberent.s.apos.trType = TR_LINEAR
    saberent.s.apos.trDelta[0] = 0
    saberent.s.apos.trDelta[1] = 800
    saberent.s.apos.trDelta[2] = 0

    saberent.s.pos.trType = TR_LINEAR
    saberent.s.eType = ET_GENERAL
    saberent.s.eFlags = 0

    saberent.parent = saberOwner

    saberent.genericValue5 = 0

    SetSaberBoxSize(saberent)

    saberent.touch = Touch.thrownSaberTouch

    saberent.s.weapon = WP_SABER

    saberOwner.client!.ps.saberEntityState = 1

    trap_LinkEntity(saberent)
}

/// Source: oracle/codemp/game/w_saber.c:6512
func saberKnockDown(_ saberent: Entity, _ saberOwner: Entity, _ other: Entity) {
    saberOwner.client!.ps.saberEntityNum = 0 //still stored in client->saberStoredIndex
    saberOwner.client!.saberKnockedTime = level.time + SABER_RETRIEVE_DELAY

    saberent.clipmask = MASK_SOLID
    saberent.r.contents = CONTENTS_TRIGGER //0;

    saberent.r.mins = vec3_t(-3.0, -3.0, -1.5)
    saberent.r.maxs = vec3_t(3.0, 3.0, 1.5)

    saberent.s.apos.trType = TR_GRAVITY
    saberent.s.apos.trDelta[0] = Float(Q_irand(200, 800))
    saberent.s.apos.trDelta[1] = Float(Q_irand(200, 800))
    saberent.s.apos.trDelta[2] = Float(Q_irand(200, 800))
    saberent.s.apos.trTime = level.time - 50

    saberent.s.pos.trType = TR_GRAVITY
    saberent.s.pos.trTime = level.time - 50
    saberent.flags |= FL_BOUNCE_HALF

    WP_SaberAddG2Model(saberent, saberOwner.client!.saber[0].model, saberOwner.client!.saber[0].skin)

    saberent.s.modelGhoul2 = 1
    saberent.s.g2radius = 20

    saberent.s.eType = ET_MISSILE
    saberent.s.weapon = WP_SABER

    saberent.speed = Float(level.time + 4000)

    saberent.bounceCount = -5 //8;

    saberMoveBack(saberent, true)
    saberent.s.pos.trType = TR_GRAVITY

    saberent.s.loopSound = 0 //kill this in case it was spinning.
    saberent.s.loopIsSoundset = false

    saberent.r.svFlags &= ~(SVF_NOCLIENT) //make sure the client is getting updates on where it is and such.

    saberent.touch = Touch.SaberBounceSound
    saberent.think = Think.DownedSaberThink
    saberent.nextthink = level.time

    if saberOwner != other {
        //if someone knocked it out of the air and it wasn't turned off, go in the direction they were facing.
        if other.inuse && other.client != nil {
            var otherFwd = vec3_t()
            let deflectSpeed: Float = 200

            // Raven passes NULL for the `right` and `up` outputs.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(other.client!.ps.viewangles, &otherFwd, &scratchRight, &scratchUp)

            saberent.s.pos.trDelta[0] = otherFwd[0] * deflectSpeed
            saberent.s.pos.trDelta[1] = otherFwd[1] * deflectSpeed
            saberent.s.pos.trDelta[2] = otherFwd[2] * deflectSpeed
        }
    }

    trap_LinkEntity(saberent)

    if saberOwner.client!.saber[0].soundOff != 0 {
        G_Sound(saberent, CHAN_BODY, saberOwner.client!.saber[0].soundOff)
    }

    if saberOwner.client!.saber[1].soundOff != 0 && !saberOwner.client!.saber[1].model.isEmpty {
        G_Sound(saberOwner, CHAN_BODY, saberOwner.client!.saber[1].soundOff)
    }
}

/// Source: oracle/codemp/game/w_saber.c:6589
func WP_SaberRemoveG2Model(_ saberent: Entity) {
    if saberent.ghoul2 != nil {
        trap_G2API_RemoveGhoul2Models(saberent.ghoul2)
    }
}

/// Source: oracle/codemp/game/w_saber.c:6597
func WP_SaberAddG2Model(_ saberent: Entity, _ saberModel: String, _ saberSkin: JKAShared.qhandle_t) {
    WP_SaberRemoveG2Model(saberent)
    if !saberModel.isEmpty {
        saberent.s.modelindex = G_ModelIndex(saberModel)
    } else {
        saberent.s.modelindex = G_ModelIndex("models/weapons2/saber/saber_w.glm")
    }
    //FIXME: use customSkin?
    trap_G2API_InitGhoul2Model(&saberent.ghoul2, saberModel, saberent.s.modelindex, saberSkin, 0, 0, 0)
}

//Make the saber go flying directly out of the owner's hand in the specified direction
/// Source: oracle/codemp/game/w_saber.c:6613
func saberKnockOutOfHand(_ saberent: Entity, _ saberOwner: Entity, _ velocity: JKAShared.vec3_t) -> Bool {
    if !saberent.inuse || !saberOwner.inuse || saberOwner.client == nil {
        return false
    }

    if saberOwner.client!.ps.saberEntityNum == 0 {
        //already gone
        return false
    }

    if (level.time - saberOwner.client!.lastSaberStorageTime) > 50 {
        //must have a reasonably updated saber base pos
        return false
    }

    if saberOwner.client!.ps.saberLockTime > (level.time - 100) {
        return false
    }
    if (saberOwner.client!.saber[0].saberFlags & SFL_NOT_DISARMABLE) != 0 {
        return false
    }

    saberOwner.client!.ps.saberInFlight = true
    saberOwner.client!.ps.saberEntityState = 1

    saberent.s.saberInFlight = false //qtrue;

    saberent.s.pos.trType = TR_LINEAR
    saberent.s.eType = ET_GENERAL
    saberent.s.eFlags = 0

    WP_SaberAddG2Model(saberent, saberOwner.client!.saber[0].model, saberOwner.client!.saber[0].skin)

    saberent.s.modelGhoul2 = 127

    saberent.parent = saberOwner

    saberent.damage = SABER_THROWN_HIT_DAMAGE
    saberent.methodOfDeath = MOD_SABER
    saberent.splashMethodOfDeath = MOD_SABER
    saberent.s.solid = 2
    saberent.r.contents = CONTENTS_LIGHTSABER

    saberent.genericValue5 = 0

    saberent.r.mins = vec3_t(-24.0, -24.0, -8.0)
    saberent.r.maxs = vec3_t(24.0, 24.0, 8.0)

    saberent.s.genericenemyindex = saberOwner.s.number + 1024
    saberent.s.weapon = WP_SABER

    saberent.genericValue5 = 0

    G_SetOrigin(saberent, &saberOwner.client!.lastSaberBase_Always) //use this as opposed to the right hand bolt,
    //because I don't want to risk reconstructing the skel again to get it here. And it isn't worth storing.
    saberKnockDown(saberent, saberOwner, saberOwner)
    saberent.s.pos.trDelta = velocity //override the velocity on the knocked away saber.

    return true
}

//Called at the result of a circle lock duel - the loser gets his saber tossed away and is put into a reflected attack anim
/// Source: oracle/codemp/game/w_saber.c:6681
func saberCheckKnockdown_DuelLoss(_ saberent: Entity, _ saberOwner: Entity, _ other: Entity) -> Bool {
    var dif = vec3_t()
    var totalDistance: Float = 1
    let distScale: Float = 6.5
    var validMomentum: Bool = true
    var disarmChance: Int32 = 1

    if saberInvalid(saberent, saberOwner, other) {
        return false
    }

    dif = vec3_t()

    if !other.client!.olderIsValid || (level.time - other.client!.lastSaberStorageTime) >= 200 {
        //see if the spots are valid
        validMomentum = false
    }

    if validMomentum {
        //Get the difference
        dif = other.client!.lastSaberBase_Always - other.client!.olderSaberBase
        totalDistance = VectorNormalize(&dif)

        if totalDistance == 0 {
            //fine, try our own
            if !saberOwner.client!.olderIsValid || (level.time - saberOwner.client!.lastSaberStorageTime) >= 200 {
                validMomentum = false
            }

            if validMomentum {
                dif = saberOwner.client!.lastSaberBase_Always - saberOwner.client!.olderSaberBase
                totalDistance = VectorNormalize(&dif)
            }
        }

        if validMomentum {
            if totalDistance == 0 {
                //try the difference between the two blades
                dif = saberOwner.client!.lastSaberBase_Always - other.client!.lastSaberBase_Always
                totalDistance = VectorNormalize(&dif)
            }

            if totalDistance != 0 {
                //if we still have no difference somehow, just let it fall to the ground when the time comes.
                if totalDistance < 20 {
                    totalDistance = 20
                }
                dif = dif * (totalDistance * distScale)
            }
        }
    }

    saberOwner.client!.ps.saberMove = LS_V1_BL //rwwFIXMEFIXME: Ideally check which lock it was exactly and use the proper anim (same goes for the attacker)
    saberOwner.client!.ps.saberBlocked = BLOCKED_BOUNCE_MOVE

    if other.client != nil {
        disarmChance += other.client!.saber[0].disarmBonus
        // Raven tests `other->client->saber[1].model` and `other->client->saber[1].model[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if !other.client!.saber[1].model.isEmpty && other.client!.ps.saberHolstered == 0 {
            // Raven reads the field and drops the value.
            _ = other.client!.saber[1].disarmBonus
        }
    }
    if Q_irand(0, disarmChance) != 0 {
        return saberKnockOutOfHand(saberent, saberOwner, dif)
    } else {
        return false
    }
}

//Called when we want to try knocking the saber out of the owner's hand upon them going into a broken parry.
//Also called on reflected attacks.
/// Source: oracle/codemp/game/w_saber.c:6765
func saberCheckKnockdown_BrokenParry(_ saberent: Entity, _ saberOwner: Entity, _ other: Entity) -> Bool {
    let myAttack: Int32
    let otherAttack: Int32
    var doKnock: Bool = false
    var disarmChance: Int32 = 1

    if saberInvalid(saberent, saberOwner, other) {
        return false
    }

    //Neither gets an advantage based on attack state, when it comes to knocking
    //saber out of hand.
    myAttack = G_SaberAttackPower(saberOwner, false)
    otherAttack = G_SaberAttackPower(other, false)

    if !other.client!.olderIsValid || (level.time - other.client!.lastSaberStorageTime) >= 200 {
        //if we don't know which way to throw the saber based on momentum between saber positions, just don't throw it
        return false
    }

    //only knock the saber out of the hand if they're in a stronger stance I suppose. Makes strong more advantageous.
    if otherAttack > myAttack + 1 && Q_irand(1, 10) <= 7 {
        //This would be, say, strong stance against light stance.
        doKnock = true
    } else if otherAttack > myAttack && Q_irand(1, 10) <= 3 {
        //Strong vs. medium, medium vs. light
        doKnock = true
    }

    if doKnock {
        var dif = vec3_t()
        var totalDistance: Float
        let distScale: Float = 6.5

        dif = other.client!.lastSaberBase_Always - other.client!.olderSaberBase
        totalDistance = VectorNormalize(&dif)

        if totalDistance == 0 {
            //fine, try our own
            if !saberOwner.client!.olderIsValid || (level.time - saberOwner.client!.lastSaberStorageTime) >= 200 {
                //if we don't know which way to throw the saber based on momentum between saber positions, just don't throw it
                return false
            }

            dif = saberOwner.client!.lastSaberBase_Always - saberOwner.client!.olderSaberBase
            totalDistance = VectorNormalize(&dif)
        }

        if totalDistance == 0 {
            //...forget it then.
            return false
        }

        if totalDistance < 20 {
            totalDistance = 20
        }
        dif = dif * (totalDistance * distScale)

        if other.client != nil {
            disarmChance += other.client!.saber[0].disarmBonus
            // Raven tests `other->client->saber[1].model` and `other->client->saber[1].model[0]`.
            // Both read as the same Swift test, so the draft writes it once.
            if !other.client!.saber[1].model.isEmpty && other.client!.ps.saberHolstered == 0 {
                // Raven reads the field and drops the value.
                _ = other.client!.saber[1].disarmBonus
            }
        }
        if Q_irand(0, disarmChance) != 0 {
            return saberKnockOutOfHand(saberent, saberOwner, dif)
        }
    }

    return false
}

//Called upon an enemy actually slashing into a thrown saber
/// Source: oracle/codemp/game/w_saber.c:6852
func saberCheckKnockdown_Smashed(_ saberent: Entity, _ saberOwner: Entity, _ other: Entity, _ damage: Int32) -> Bool {
    if saberInvalid(saberent, saberOwner, other) {
        return false
    }

    if !saberOwner.client!.ps.saberInFlight {
        //can only do this if the saber is already actually in flight
        return false
    }

    if other.inuse && other.client != nil && BG_InExtraDefenseSaberMove(other.client!.ps.saberMove) {
        //make sure the blow was strong enough
        saberKnockDown(saberent, saberOwner, other)
        return true
    }

    if damage > 10 {
        //make sure the blow was strong enough
        saberKnockDown(saberent, saberOwner, other)
        return true
    }

    return false
}

//Called upon blocking a thrown saber. If the throw level compared to the blocker's defense level
//is inferior, or equal and a random factor is met, then the saber will be tossed to the ground.
/// Source: oracle/codemp/game/w_saber.c:6884
func saberCheckKnockdown_Thrown(_ saberent: Entity, _ saberOwner: Entity, _ other: Entity) -> Bool {
    var throwLevel: Int32 = 0
    var defenLevel: Int32 = 0
    var tossIt: Bool = false

    if saberInvalid(saberent, saberOwner, other) {
        return false
    }

    defenLevel = other.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE]
    throwLevel = saberOwner.client!.ps.fd.forcePowerLevel[FP_SABERTHROW]

    if defenLevel > throwLevel {
        tossIt = true
    } else if defenLevel == throwLevel && Q_irand(1, 10) <= 4 {
        tossIt = true
    }
    //otherwise don't

    if tossIt {
        saberKnockDown(saberent, saberOwner, other)
        return true
    }

    return false
}

/// Source: oracle/codemp/game/w_saber.c:6917
func saberBackToOwner(_ saberent: Entity) {
    let saberOwner: Entity? = g_entities[saberent.r.ownerNum]
    var dir = vec3_t()
    let ownerLen: Float

    if saberent.r.ownerNum == ENTITYNUM_NONE {
        MakeDeadSaber(saberent)

        saberent.think = Think.G_FreeEntity
        saberent.nextthink = level.time
        return
    }

    if !saberOwner!.inuse || saberOwner!.client == nil || saberOwner!.client!.sess.sessionTeam == TEAM_SPECTATOR {
        MakeDeadSaber(saberent)

        saberent.think = Think.G_FreeEntity
        saberent.nextthink = level.time
        return
    }

    if saberOwner!.health < 1 || saberOwner!.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] == 0 {
        //He's dead, just go back to our normal saber status
        saberent.touch = Touch.SaberGotHit
        saberent.think = Think.SaberUpdateSelf
        saberent.genericValue5 = 0
        saberent.nextthink = level.time

        if saberOwner!.client != nil && saberOwner!.client!.saber[0].soundOff != 0 {
            G_Sound(saberent, CHAN_AUTO, saberOwner!.client!.saber[0].soundOff)
        }
        MakeDeadSaber(saberent)

        saberent.r.svFlags |= (SVF_NOCLIENT)
        saberent.r.contents = CONTENTS_LIGHTSABER
        SetSaberBoxSize(saberent)
        saberent.s.loopSound = 0
        saberent.s.loopIsSoundset = false
        WP_SaberRemoveG2Model(saberent)

        saberOwner!.client!.ps.saberInFlight = false
        saberOwner!.client!.ps.saberEntityState = 0
        saberOwner!.client!.ps.saberThrowDelay = level.time + 500
        saberOwner!.client!.ps.saberCanThrow = false

        return
    }

    //make sure this is set alright
    saberOwner!.client!.ps.saberEntityNum = saberent.s.number

    saberent.r.contents = CONTENTS_LIGHTSABER

    dir = saberent.pos1 - saberent.r.currentOrigin

    ownerLen = VectorLength(dir)

    if saberent.speed < level.time {
        var baseSpeed: Float = 900

        VectorNormalize(&dir)

        saberMoveBack(saberent, true)
        saberent.s.pos.trBase = saberent.r.currentOrigin

        if saberOwner!.client!.ps.fd.forcePowerLevel[FP_SABERTHROW] >= FORCE_LEVEL_3 {
            //allow players with high saber throw rank to control the return speed of the saber
            baseSpeed = 900

            saberent.speed = Float(level.time) // + 200;
        } else {
            baseSpeed = 700
            saberent.speed = Float(level.time + 50)
        }

        //Gradually slow down as it approaches, so it looks smoother coming into the hand.
        if ownerLen < 64 {
            saberent.s.pos.trDelta = dir * (baseSpeed - 200)
        } else if ownerLen < 128 {
            saberent.s.pos.trDelta = dir * (baseSpeed - 150)
        } else if ownerLen < 256 {
            saberent.s.pos.trDelta = dir * (baseSpeed - 100)
        } else {
            saberent.s.pos.trDelta = dir * baseSpeed
        }

        saberent.s.pos.trTime = level.time
    }

    /*
    if (ownerLen <= 512)
    {
    saberent->s.saberInFlight = qfalse;
    saberent->s.loopSound = saberHumSound;
    saberent->s.loopIsSoundset = qfalse;
    }
    */
    //I'm just doing this now. I don't really like the spin on the way back. And it does weird stuff with the new saber-knocked-away code.
    if saberOwner!.client!.ps.saberEntityNum == saberent.s.number {
        if !((saberOwner!.client!.saber[0].saberFlags & SFL_RETURN_DAMAGE) != 0) || saberOwner!.client!.ps.saberHolstered != 0 {
            saberent.s.saberInFlight = false
        }
        saberent.s.loopSound = saberOwner!.client!.saber[0].soundLoop
        saberent.s.loopIsSoundset = false

        if ownerLen <= 32 {
            G_Sound(saberent, CHAN_AUTO, G_SoundIndex("sound/weapons/saber/saber_catch.wav"))

            saberOwner!.client!.ps.saberInFlight = false
            saberOwner!.client!.ps.saberEntityState = 0
            saberOwner!.client!.ps.saberCanThrow = false
            saberOwner!.client!.ps.saberThrowDelay = level.time + 300

            saberent.touch = Touch.SaberGotHit

            saberent.think = Think.SaberUpdateSelf
            saberent.genericValue5 = 0
            saberent.nextthink = level.time + 50
            WP_SaberRemoveG2Model(saberent)

            return
        }

        if !saberent.s.saberInFlight {
            saberCheckRadiusDamage(saberent, 1)
        } else {
            saberCheckRadiusDamage(saberent, 2)
        }

        saberMoveBack(saberent, true)
    }

    saberent.nextthink = level.time
}

/// Source: oracle/codemp/game/w_saber.c:7080
func thrownSaberTouch(_ saberent: Entity, _ other: Entity, _ trace: JKAMP.Trace?) {
    var hitEnt: Entity? = other

    if other.s.number == saberent.r.ownerNum {
        return
    }
    saberent.s.pos.trDelta = vec3_t()
    saberent.s.pos.trTime = level.time

    saberent.s.apos.trType = TR_LINEAR
    saberent.s.apos.trDelta[0] = 0
    saberent.s.apos.trDelta[1] = 800
    saberent.s.apos.trDelta[2] = 0

    saberent.s.pos.trBase = saberent.r.currentOrigin

    saberent.think = Think.saberBackToOwner
    saberent.nextthink = level.time

    if other.r.ownerNum < MAX_CLIENTS && (other.r.contents & CONTENTS_LIGHTSABER) != 0 && g_entities[other.r.ownerNum].client != nil && g_entities[other.r.ownerNum].inuse {
        hitEnt = g_entities[other.r.ownerNum]
    }

    //we'll skip the dist check, since we don't really care about that (we just hit it physically)
    CheckThrownSaberDamaged(saberent, g_entities[saberent.r.ownerNum], hitEnt!, 256, 0, true)

    saberent.speed = 0
}

/// Source: oracle/codemp/game/w_saber.c:7117
func saberFirstThrown(_ saberent: Entity) {
    var vSub = vec3_t()
    var vLen: Float = 0
    let saberOwn: Entity? = g_entities[saberent.r.ownerNum]

    runMin: do {
        if saberent.r.ownerNum == ENTITYNUM_NONE {
            MakeDeadSaber(saberent)

            saberent.think = Think.G_FreeEntity
            saberent.nextthink = level.time
            return
        }

        if saberOwn == nil || !saberOwn!.inuse || saberOwn!.client == nil || saberOwn!.client!.sess.sessionTeam == TEAM_SPECTATOR {
            MakeDeadSaber(saberent)

            saberent.think = Think.G_FreeEntity
            saberent.nextthink = level.time
            return
        }

        if saberOwn!.health < 1 || saberOwn!.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] == 0 {
            //He's dead, just go back to our normal saber status
            saberent.touch = Touch.SaberGotHit
            saberent.think = Think.SaberUpdateSelf
            saberent.genericValue5 = 0
            saberent.nextthink = level.time

            if saberOwn!.client != nil && saberOwn!.client!.saber[0].soundOff != 0 {
                G_Sound(saberent, CHAN_AUTO, saberOwn!.client!.saber[0].soundOff)
            }
            MakeDeadSaber(saberent)

            saberent.r.svFlags |= (SVF_NOCLIENT)
            saberent.r.contents = CONTENTS_LIGHTSABER
            SetSaberBoxSize(saberent)
            saberent.s.loopSound = 0
            saberent.s.loopIsSoundset = false
            WP_SaberRemoveG2Model(saberent)

            saberOwn!.client!.ps.saberInFlight = false
            saberOwn!.client!.ps.saberEntityState = 0
            saberOwn!.client!.ps.saberThrowDelay = level.time + 500
            saberOwn!.client!.ps.saberCanThrow = false

            return
        }

        if (level.time - saberOwn!.client!.ps.saberDidThrowTime) > 500 {
            if !((saberOwn!.client!.buttons & BUTTON_ALT_ATTACK) != 0) {
                //If owner releases altattack 500ms or later after throwing saber, it autoreturns
                thrownSaberTouch(saberent, saberent, nil)
                break runMin
            } else if (level.time - saberOwn!.client!.ps.saberDidThrowTime) > 6000 {
                //if it's out longer than 6 seconds, return it
                thrownSaberTouch(saberent, saberent, nil)
                break runMin
            }
        }

        if BG_HasYsalamiri(g_gametype.integer, saberOwn!.client!.ps) {
            thrownSaberTouch(saberent, saberent, nil)
            break runMin
        }

        if !BG_CanUseFPNow(g_gametype.integer, saberOwn!.client!.ps, level.time, FP_SABERTHROW) {
            thrownSaberTouch(saberent, saberent, nil)
            break runMin
        }

        vSub = saberOwn!.client!.ps.origin - saberent.r.currentOrigin
        vLen = VectorLength(vSub)

        if vLen >= (SABER_MAX_THROW_DISTANCE * saberOwn!.client!.ps.fd.forcePowerLevel[FP_SABERTHROW]) {
            thrownSaberTouch(saberent, saberent, nil)
            break runMin
        }

        if saberOwn!.client!.ps.fd.forcePowerLevel[FP_SABERTHROW] >= FORCE_LEVEL_2 && saberent.speed < level.time {
            //if owner is rank 3 in saber throwing, the saber goes where he points
            var fwd = vec3_t()
            var traceFrom = vec3_t()
            var traceTo = vec3_t()
            var dir = vec3_t()
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { tr in

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight = vec3_t()
                var scratchUp = vec3_t()
                AngleVectors(saberOwn!.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)

                traceFrom = saberOwn!.client!.ps.origin
                traceFrom[2] += saberOwn!.client!.ps.viewheight

                traceTo = traceFrom
                traceTo[0] += fwd[0] * 4096
                traceTo[1] += fwd[1] * 4096
                traceTo[2] += fwd[2] * 4096

                saberMoveBack(saberent, false)
                saberent.s.pos.trBase = saberent.r.currentOrigin

                if saberOwn!.client!.ps.fd.forcePowerLevel[FP_SABERTHROW] >= FORCE_LEVEL_3 {
                    //if highest saber throw rank, we can direct the saber toward players directly by looking at them
                    trap_Trace(tr, traceFrom, vec3_origin, vec3_origin, traceTo, saberOwn!.s.number, MASK_PLAYERSOLID)
                } else {
                    trap_Trace(tr, traceFrom, vec3_origin, vec3_origin, traceTo, saberOwn!.s.number, MASK_SOLID)
                }

                dir = tr.endpos - saberent.r.currentOrigin

                VectorNormalize(&dir)

                saberent.s.pos.trDelta = dir * 500
                saberent.s.pos.trTime = level.time

                if saberOwn!.client!.ps.fd.forcePowerLevel[FP_SABERTHROW] >= FORCE_LEVEL_3 {
                    //we'll treat them to a quicker update rate if their throw rank is high enough
                    saberent.speed = Float(level.time + 100)
                } else {
                    saberent.speed = Float(level.time + 400)
                }
            }
        }

    }

    saberCheckRadiusDamage(saberent, 0)
    G_RunObject(saberent)
}

/// Source: oracle/codemp/game/w_saber.c:7259
func UpdateClientRenderBolts(_ `self`: Entity, _ renderOrigin: JKAShared.vec3_t, _ renderAngles: JKAShared.vec3_t) {
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        let ri: RenderInfo? = `self`.client!.renderInfo

        if `self`.ghoul2 == nil {
            ri!.headPoint = `self`.client!.ps.origin
            ri!.handRPoint = `self`.client!.ps.origin
            ri!.handLPoint = `self`.client!.ps.origin
            ri!.torsoPoint = `self`.client!.ps.origin
            ri!.crotchPoint = `self`.client!.ps.origin
            ri!.footRPoint = `self`.client!.ps.origin
            ri!.footLPoint = `self`.client!.ps.origin
        } else {
            //head
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.headBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
            ri!.headPoint[0] = boltMatrix.matrix[0][3]
            ri!.headPoint[1] = boltMatrix.matrix[1][3]
            ri!.headPoint[2] = boltMatrix.matrix[2][3]

            //right hand
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.handRBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
            ri!.handRPoint[0] = boltMatrix.matrix[0][3]
            ri!.handRPoint[1] = boltMatrix.matrix[1][3]
            ri!.handRPoint[2] = boltMatrix.matrix[2][3]

            //left hand
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.handLBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
            ri!.handLPoint[0] = boltMatrix.matrix[0][3]
            ri!.handLPoint[1] = boltMatrix.matrix[1][3]
            ri!.handLPoint[2] = boltMatrix.matrix[2][3]

            //chest
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.torsoBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
            ri!.torsoPoint[0] = boltMatrix.matrix[0][3]
            ri!.torsoPoint[1] = boltMatrix.matrix[1][3]
            ri!.torsoPoint[2] = boltMatrix.matrix[2][3]

            //crotch
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.crotchBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
            ri!.crotchPoint[0] = boltMatrix.matrix[0][3]
            ri!.crotchPoint[1] = boltMatrix.matrix[1][3]
            ri!.crotchPoint[2] = boltMatrix.matrix[2][3]

            //right foot
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.footRBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
            ri!.footRPoint[0] = boltMatrix.matrix[0][3]
            ri!.footRPoint[1] = boltMatrix.matrix[1][3]
            ri!.footRPoint[2] = boltMatrix.matrix[2][3]

            //left foot
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.footLBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
            ri!.footLPoint[0] = boltMatrix.matrix[0][3]
            ri!.footLPoint[1] = boltMatrix.matrix[1][3]
            ri!.footLPoint[2] = boltMatrix.matrix[2][3]
        }

        `self`.client!.renderInfo.boltValidityTime = level.time
    }
}

/// Source: oracle/codemp/game/w_saber.c:7322
func UpdateClientRenderinfo(_ `self`: Entity, _ renderOrigin: JKAShared.vec3_t, _ renderAngles: JKAShared.vec3_t) {
    let ri: RenderInfo? = `self`.client!.renderInfo
    if ri!.mPCalcTime < level.time {
        //We're just going to give rough estimates on most of this stuff,
        //it's not like most of it matters.

        //Should you wish to make any of this valid then feel free to do so.




        //VectorClear(ri->eyeAngles);


        if `self`.ghoul2 != nil && `self`.ghoul2 != ri!.lastG2 {
            //the g2 instance changed, so update all the bolts.
            //rwwFIXMEFIXME: Base on skeleton used? Assuming humanoid currently.
            ri!.lastG2 = `self`.ghoul2

            if `self`.localAnimIndex <= 1 {
                ri!.headBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*head_eyes")
                ri!.handRBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*r_hand")
                ri!.handLBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_hand")
                ri!.torsoBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "thoracic")
                ri!.crotchBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "pelvis")
                ri!.footRBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*r_leg_foot")
                ri!.footLBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_leg_foot")
                ri!.motionBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "Motion")
            } else {
                ri!.headBolt = -1
                ri!.handRBolt = -1
                ri!.handLBolt = -1
                ri!.torsoBolt = -1
                ri!.crotchBolt = -1
                ri!.footRBolt = -1
                ri!.footLBolt = -1
                ri!.motionBolt = -1
            }

            ri!.lastG2 = `self`.ghoul2
        }

        `self`.client!.renderInfo.eyeAngles = `self`.client!.ps.viewangles

        //we'll just say the legs/torso are whatever the first frame of our current anim is.
        ri!.torsoFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[`self`.client!.ps.torsoAnim].firstFrame
        ri!.legsFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[`self`.client!.ps.legsAnim].firstFrame
        if g_debugServerSkel.integer != 0 {
            //Alright, I was doing this, but it's just too slow to do every frame.
            //From now on if we want this data to be valid we're going to have to make a verify call for it before
            //accessing it. I'm only doing this now if we want to debug the server skel by drawing lines from bolt
            //positions every frame.
            // Raven's record lives to the end of his block, so the block is the closure.
            MdxaBone.scratch { boltMatrix in

                if `self`.ghoul2 == nil {
                    ri!.headPoint = `self`.client!.ps.origin
                    ri!.handRPoint = `self`.client!.ps.origin
                    ri!.handLPoint = `self`.client!.ps.origin
                    ri!.torsoPoint = `self`.client!.ps.origin
                    ri!.crotchPoint = `self`.client!.ps.origin
                    ri!.footRPoint = `self`.client!.ps.origin
                    ri!.footLPoint = `self`.client!.ps.origin
                } else {
                    //head
                    trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.headBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
                    ri!.headPoint[0] = boltMatrix.matrix[0][3]
                    ri!.headPoint[1] = boltMatrix.matrix[1][3]
                    ri!.headPoint[2] = boltMatrix.matrix[2][3]

                    //right hand
                    trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.handRBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
                    ri!.handRPoint[0] = boltMatrix.matrix[0][3]
                    ri!.handRPoint[1] = boltMatrix.matrix[1][3]
                    ri!.handRPoint[2] = boltMatrix.matrix[2][3]

                    //left hand
                    trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.handLBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
                    ri!.handLPoint[0] = boltMatrix.matrix[0][3]
                    ri!.handLPoint[1] = boltMatrix.matrix[1][3]
                    ri!.handLPoint[2] = boltMatrix.matrix[2][3]

                    //chest
                    trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.torsoBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
                    ri!.torsoPoint[0] = boltMatrix.matrix[0][3]
                    ri!.torsoPoint[1] = boltMatrix.matrix[1][3]
                    ri!.torsoPoint[2] = boltMatrix.matrix[2][3]

                    //crotch
                    trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.crotchBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
                    ri!.crotchPoint[0] = boltMatrix.matrix[0][3]
                    ri!.crotchPoint[1] = boltMatrix.matrix[1][3]
                    ri!.crotchPoint[2] = boltMatrix.matrix[2][3]

                    //right foot
                    trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.footRBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
                    ri!.footRPoint[0] = boltMatrix.matrix[0][3]
                    ri!.footRPoint[1] = boltMatrix.matrix[1][3]
                    ri!.footRPoint[2] = boltMatrix.matrix[2][3]

                    //left foot
                    trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.footLBolt, boltMatrix, renderAngles, renderOrigin, level.time, nil, &`self`.modelScale)
                    ri!.footLPoint[0] = boltMatrix.matrix[0][3]
                    ri!.footLPoint[1] = boltMatrix.matrix[1][3]
                    ri!.footLPoint[2] = boltMatrix.matrix[2][3]
                }

                //Now draw the skel for debug
                G_TestLine(ri!.headPoint, ri!.torsoPoint, 0x000000ff, 50)
                G_TestLine(ri!.torsoPoint, ri!.handRPoint, 0x000000ff, 50)
                G_TestLine(ri!.torsoPoint, ri!.handLPoint, 0x000000ff, 50)
                G_TestLine(ri!.torsoPoint, ri!.crotchPoint, 0x000000ff, 50)
                G_TestLine(ri!.crotchPoint, ri!.footRPoint, 0x000000ff, 50)
                G_TestLine(ri!.crotchPoint, ri!.footLPoint, 0x000000ff, 50)
            }
        }

        //muzzle point calc (we are going to be cheap here)
        ri!.muzzlePointOld = ri!.muzzlePoint
        ri!.muzzlePoint = `self`.client!.ps.origin
        ri!.muzzleDirOld = ri!.muzzleDir
        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(`self`.client!.ps.viewangles, &ri!.muzzleDir, &scratchRight, &scratchUp)
        ri!.mPCalcTime = level.time

        ri!.eyePoint = `self`.client!.ps.origin
        ri!.eyePoint[2] += `self`.client!.ps.viewheight
    }
}

/// Source: oracle/codemp/game/w_saber.c:7474
private func G_KickDownable(_ ent: Entity) -> Bool {
    if d_saberKickTweak.integer == 0 {
        return true
    }

    if !ent.inuse || ent.client == nil {
        return false
    }

    if BG_InKnockDown(ent.client!.ps.legsAnim) || BG_InKnockDown(ent.client!.ps.torsoAnim) {
        return false
    }

    if ent.client!.ps.weaponTime <= 0 && ent.client!.ps.weapon == WP_SABER && ent.client!.ps.groundEntityNum != ENTITYNUM_NONE {
        return false
    }

    return true
}

/// Source: oracle/codemp/game/w_saber.c:7502
private func G_TossTheMofo(_ ent: Entity, _ tossDir: JKAShared.vec3_t, _ tossStr: Float) {
    if !ent.inuse || ent.client == nil {
        //no good
        return
    }

    if ent.s.eType == ET_NPC && ent.s.NPC_class == CLASS_VEHICLE {
        //no, silly
        return
    }

    _VectorMA(ent.client!.ps.velocity, tossStr, tossDir, &ent.client!.ps.velocity)
    ent.client!.ps.velocity[2] = 200
    if ent.health > 0 && ent.client!.ps.forceHandExtend != HANDEXTEND_KNOCKDOWN && BG_KnockDownable(ent.client!.ps) && G_KickDownable(ent) {
        //if they are alive, knock them down I suppose
        ent.client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
        ent.client!.ps.forceHandExtendTime = level.time + 700
        ent.client!.ps.forceDodgeAnim = 0 //this toggles between 1 and 0, when it's 1 we should play the get up anim
        //ent->client->ps.quickerGetup = qtrue;
    }
}

/// Source: oracle/codemp/game/w_saber.c:7527
private func G_KickTrace(_ ent: Entity, _ kickDir: inout JKAShared.vec3_t, _ kickDist: Float, _ kickEnd: JKAShared.vec3_t?, _ kickDamage: Int32, _ kickPush: Float) -> Entity? {
    var traceOrg = vec3_t()
    var traceEnd = vec3_t()
    var kickMins = vec3_t()
    var kickMaxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Entity? in
        var hitEnt: Entity? = nil
        kickMins = vec3_t(-2.0, -2.0, -2.0)
        kickMaxs = vec3_t(2.0, 2.0, 2.0)
        //FIXME: variable kick height?
        if kickEnd != nil && VectorCompare(kickEnd!, vec3_origin) == 0 {
            //they passed us the end point of the trace, just use that
            //this makes the trace flat
            traceOrg = vec3_t(ent.r.currentOrigin[0], ent.r.currentOrigin[1], kickEnd![2])
            traceEnd = kickEnd!
        } else {
            //extrude
            traceOrg = vec3_t(ent.r.currentOrigin[0], ent.r.currentOrigin[1], ent.r.currentOrigin[2] + ent.r.maxs[2] * 0.5)
            _VectorMA(traceOrg, kickDist, kickDir, &traceEnd)
        }

        if d_saberKickTweak.integer != 0 {
            trap_G2Trace(trace, traceOrg, kickMins, kickMaxs, traceEnd, ent.s.number, MASK_SHOT, G2TRFLAG_DOGHOULTRACE | G2TRFLAG_GETSURFINDEX | G2TRFLAG_THICK | G2TRFLAG_HITCORPSES, g_g2TraceLod.integer)
        } else {
            trap_Trace(trace, traceOrg, kickMins, kickMaxs, traceEnd, ent.s.number, MASK_SHOT)
        }

        //G_TestLine(traceOrg, traceEnd, 0x0000ff, 5000);
        if trace.fraction < 1.0 && trace.startsolid == 0 && trace.allsolid == 0 {
            if ent.client!.jediKickTime > level.time {
                if trace.entityNum == ent.client!.jediKickIndex {
                    //we are hitting the same ent we last hit in this same anim, don't hit it again
                    return nil
                }
            }
            ent.client!.jediKickIndex = trace.entityNum
            ent.client!.jediKickTime = level.time + ent.client!.ps.legsTimer

            hitEnt = g_entities[trace.entityNum]
            //FIXME: regardless of what we hit, do kick hit sound and impact effect
            //G_PlayEffect( "misc/kickHit", trace.endpos, trace.plane.normal );
            if ent.client!.ps.torsoAnim == BOTH_A7_HILT {
                G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/movers/objects/saber_slam"))
            } else {
                G_Sound(ent, CHAN_AUTO, G_SoundIndex(va("sound/weapons/melee/punch%d", Q_irand(1, 4))))
            }
            if hitEnt!.inuse {
                //we hit an entity
                //FIXME: don't hit same ent more than once per kick
                if hitEnt!.takedamage {
                    //hurt it
                    if hitEnt!.client != nil {
                        hitEnt!.client!.ps.otherKiller = ent.s.number
                        hitEnt!.client!.ps.otherKillerDebounceTime = level.time + 10000
                        hitEnt!.client!.ps.otherKillerTime = level.time + 10000
                        hitEnt!.client!.otherKillerMOD = MOD_MELEE
                        hitEnt!.client!.otherKillerVehWeapon = 0
                        hitEnt!.client!.otherKillerWeaponType = WP_NONE
                    }

                    if d_saberKickTweak.integer != 0 {
                        G_Damage(hitEnt!, ent, ent, &kickDir, trace.endpos, Int32(kickDamage * 0.2), DAMAGE_NO_KNOCKBACK, MOD_MELEE)
                    } else {
                        G_Damage(hitEnt!, ent, ent, &kickDir, trace.endpos, kickDamage, DAMAGE_NO_KNOCKBACK, MOD_MELEE)
                    }
                }
                if hitEnt!.client != nil && !((hitEnt!.client!.ps.pm_flags & PMF_TIME_KNOCKBACK) != 0) && G_CanBeEnemy(ent, hitEnt!) {
                    //FIXME: this should not always work
                    if hitEnt!.health <= 0 {
                        //we kicked a dead guy
                        //throw harder - FIXME: no matter how hard I push them, they don't go anywhere... corpses use less physics???
                        //	G_Throw( hitEnt, kickDir, kickPush*4 );
                        //see if we should play a better looking death on them
                        //	G_ThrownDeathAnimForDeathAnim( hitEnt, trace.endpos );
                        G_TossTheMofo(hitEnt!, kickDir, kickPush * 4.0)
                    } else {
                        /*
                        G_Throw( hitEnt, kickDir, kickPush );
                        if ( kickPush >= 75.0f && !Q_irand( 0, 2 ) )
                        {
                        G_Knockdown( hitEnt, ent, kickDir, 300, qtrue );
                        }
                        else
                        {
                        G_Knockdown( hitEnt, ent, kickDir, kickPush, qtrue );
                        }
                        */
                        if kickPush >= 75.0 && Q_irand(0, 2) == 0 {
                            G_TossTheMofo(hitEnt!, kickDir, 300.0)
                        } else {
                            G_TossTheMofo(hitEnt!, kickDir, kickPush)
                        }
                    }
                }
            }
        }
        return (hitEnt)
    }
}

/// Source: oracle/codemp/game/w_saber.c:7644
private func G_KickSomeMofos(_ ent: Entity) {
    var kickDir = vec3_t()
    var kickEnd = vec3_t()
    var fwdAngs = vec3_t()
    let animLength: Float = Float(BG_AnimLength(ent.localAnimIndex, animNumber_t(ent.client!.ps.legsAnim)))
    let elapsedTime: Float = Float((animLength - ent.client!.ps.legsTimer))
    let remainingTime: Float = (animLength - elapsedTime)
    var kickDist: Float = (ent.r.maxs[0] * 1.5) + STAFF_KICK_RANGE + 8.0
    let kickDamage: Int32 = Q_irand(10, 15)
    var kickPush: Int32 = Int32(flrand(50.0, 100.0))
    var doKick: Bool = false
    let ri: RenderInfo? = ent.client!.renderInfo

    kickDir = vec3_t(0.0, 0.0, 0.0)
    kickEnd = vec3_t(0.0, 0.0, 0.0)
    fwdAngs = vec3_t(0.0, ent.client!.ps.viewangles[YAW], 0.0)

    //HMM... or maybe trace from origin to footRBolt/footLBolt?  Which one?  G2 trace?  Will do hitLoc, if so...
    if ent.client!.ps.torsoAnim == BOTH_A7_HILT {
        if elapsedTime >= 250 && remainingTime >= 250 {
            //front
            doKick = true
            if ri!.handRBolt != -1 {
                //actually trace to a bolt
                G_GetBoltPosition(ent, ri!.handRBolt, &kickEnd, 0)
                kickDir = kickEnd - ent.client!.ps.origin
                kickDir[2] = 0 //ah, flatten it, I guess...
                VectorNormalize(&kickDir)
            } else {
                //guess
                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight = vec3_t()
                var scratchUp = vec3_t()
                AngleVectors(fwdAngs, &kickDir, &scratchRight, &scratchUp)
            }
        }
    } else {
        switch ent.client!.ps.legsAnim {
        case BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F:
            if elapsedTime >= 250 && remainingTime >= 250 {
                //front
                doKick = true
                if ri!.footRBolt != -1 {
                    //actually trace to a bolt
                    G_GetBoltPosition(ent, ri!.footRBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.client!.ps.origin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                } else {
                    //guess
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight2 = vec3_t()
                    var scratchUp2 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight2, &scratchUp2)
                }
            }

        case BOTH_A7_KICK_F_AIR, BOTH_A7_KICK_B_AIR, BOTH_A7_KICK_R_AIR, BOTH_A7_KICK_L_AIR:
            if elapsedTime >= 100 && remainingTime >= 250 {
                //air
                doKick = true
                if ri!.footRBolt != -1 {
                    //actually trace to a bolt
                    G_GetBoltPosition(ent, ri!.footRBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                } else {
                    //guess
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight3 = vec3_t()
                    var scratchUp3 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight3, &scratchUp3)
                }
            }

        case BOTH_A7_KICK_F:
            //FIXME: push forward?
            if elapsedTime >= 250 && remainingTime >= 250 {
                //front
                doKick = true
                if ri!.footRBolt != -1 {
                    //actually trace to a bolt
                    G_GetBoltPosition(ent, ri!.footRBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                } else {
                    //guess
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight4 = vec3_t()
                    var scratchUp4 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight4, &scratchUp4)
                }
            }

        case BOTH_A7_KICK_B:
            //FIXME: push back?
            if elapsedTime >= 250 && remainingTime >= 250 {
                //back
                doKick = true
                if ri!.footRBolt != -1 {
                    //actually trace to a bolt
                    G_GetBoltPosition(ent, ri!.footRBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                } else {
                    //guess
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight5 = vec3_t()
                    var scratchUp5 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight5, &scratchUp5)
                    kickDir = kickDir * -1
                }
            }

        case BOTH_A7_KICK_R:
            //FIXME: push right?
            if elapsedTime >= 250 && remainingTime >= 250 {
                //right
                doKick = true
                if ri!.footRBolt != -1 {
                    //actually trace to a bolt
                    G_GetBoltPosition(ent, ri!.footRBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                } else {
                    //guess
                    // Raven passes NULL for the `forward` and `up` outputs.
                    var scratchForward = vec3_t()
                    var scratchUp6 = vec3_t()
                    AngleVectors(fwdAngs, &scratchForward, &kickDir, &scratchUp6)
                }
            }

        case BOTH_A7_KICK_L:
            //FIXME: push left?
            if elapsedTime >= 250 && remainingTime >= 250 {
                //left
                doKick = true
                if ri!.footLBolt != -1 {
                    //actually trace to a bolt
                    G_GetBoltPosition(ent, ri!.footLBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                } else {
                    //guess
                    // Raven passes NULL for the `forward` and `up` outputs.
                    var scratchForward2 = vec3_t()
                    var scratchUp7 = vec3_t()
                    AngleVectors(fwdAngs, &scratchForward2, &kickDir, &scratchUp7)
                    kickDir = kickDir * -1
                }
            }

        case BOTH_A7_KICK_S:
            kickPush = Int32(flrand(75.0, 125.0))
            if ri!.footRBolt != -1 {
                //actually trace to a bolt
                if elapsedTime >= 550 && elapsedTime <= 1050 {
                    doKick = true
                    G_GetBoltPosition(ent, ri!.footRBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                    //NOTE: have to fudge this a little because it's not getting enough range with the anim as-is
                    _VectorMA(kickEnd, 8.0, kickDir, &kickEnd)
                }
            } else {
                //guess
                if elapsedTime >= 400 && elapsedTime < 500 {
                    //front
                    doKick = true
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight6 = vec3_t()
                    var scratchUp8 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight6, &scratchUp8)
                } else if elapsedTime >= 500 && elapsedTime < 600 {
                    //front-right?
                    doKick = true
                    fwdAngs[YAW] += 45
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight7 = vec3_t()
                    var scratchUp9 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight7, &scratchUp9)
                } else if elapsedTime >= 600 && elapsedTime < 700 {
                    //right
                    doKick = true
                    // Raven passes NULL for the `forward` and `up` outputs.
                    var scratchForward3 = vec3_t()
                    var scratchUp10 = vec3_t()
                    AngleVectors(fwdAngs, &scratchForward3, &kickDir, &scratchUp10)
                } else if elapsedTime >= 700 && elapsedTime < 800 {
                    //back-right?
                    doKick = true
                    fwdAngs[YAW] += 45
                    // Raven passes NULL for the `forward` and `up` outputs.
                    var scratchForward4 = vec3_t()
                    var scratchUp11 = vec3_t()
                    AngleVectors(fwdAngs, &scratchForward4, &kickDir, &scratchUp11)
                } else if elapsedTime >= 800 && elapsedTime < 900 {
                    //back
                    doKick = true
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight8 = vec3_t()
                    var scratchUp12 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight8, &scratchUp12)
                    kickDir = kickDir * -1
                } else if elapsedTime >= 900 && elapsedTime < 1000 {
                    //back-left?
                    doKick = true
                    fwdAngs[YAW] += 45
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight9 = vec3_t()
                    var scratchUp13 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight9, &scratchUp13)
                } else if elapsedTime >= 1000 && elapsedTime < 1100 {
                    //left
                    doKick = true
                    // Raven passes NULL for the `forward` and `up` outputs.
                    var scratchForward5 = vec3_t()
                    var scratchUp14 = vec3_t()
                    AngleVectors(fwdAngs, &scratchForward5, &kickDir, &scratchUp14)
                    kickDir = kickDir * -1
                } else if elapsedTime >= 1100 && elapsedTime < 1200 {
                    //front-left?
                    doKick = true
                    fwdAngs[YAW] += 45
                    // Raven passes NULL for the `forward` and `up` outputs.
                    var scratchForward6 = vec3_t()
                    var scratchUp15 = vec3_t()
                    AngleVectors(fwdAngs, &scratchForward6, &kickDir, &scratchUp15)
                    kickDir = kickDir * -1
                }
            }

        case BOTH_A7_KICK_BF:
            kickPush = Int32(flrand(75.0, 125.0))
            kickDist += 20.0
            if elapsedTime < 1500 {
                //auto-aim!
                //			overridAngles = PM_AdjustAnglesForBFKick( ent, ucmd, fwdAngs, qboolean(elapsedTime<850) )?qtrue:overridAngles;
                //FIXME: if we haven't done the back kick yet and there's no-one there to
                //			kick anymore, go into some anim that returns us to our base stance
            }
            if ri!.footRBolt != -1 {
                //actually trace to a bolt
                if (elapsedTime >= 750 && elapsedTime < 850) || (elapsedTime >= 1400 && elapsedTime < 1500) {
                    //right, though either would do
                    doKick = true
                    G_GetBoltPosition(ent, ri!.footRBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                    //NOTE: have to fudge this a little because it's not getting enough range with the anim as-is
                    _VectorMA(kickEnd, 8, kickDir, &kickEnd)
                }
            } else {
                //guess
                if elapsedTime >= 250 && elapsedTime < 350 {
                    //front
                    doKick = true
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight10 = vec3_t()
                    var scratchUp16 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight10, &scratchUp16)
                } else if elapsedTime >= 350 && elapsedTime < 450 {
                    //back
                    doKick = true
                    // Raven passes NULL for the `right` and `up` outputs.
                    var scratchRight11 = vec3_t()
                    var scratchUp17 = vec3_t()
                    AngleVectors(fwdAngs, &kickDir, &scratchRight11, &scratchUp17)
                    kickDir = kickDir * -1
                }
            }

        case BOTH_A7_KICK_RL:
            kickPush = Int32(flrand(75.0, 125.0))
            kickDist += 10.0

            //ok, I'm tracing constantly on these things, they NEVER hit otherwise (in MP at least)

            //FIXME: auto aim at enemies on the side of us?
            //overridAngles = PM_AdjustAnglesForRLKick( ent, ucmd, fwdAngs, qboolean(elapsedTime<850) )?qtrue:overridAngles;
            //if ( elapsedTime >= 250 && elapsedTime < 350 )
            if (level.framenum & 1) != 0 {
                //right
                doKick = true
                if ri!.footRBolt != -1 {
                    //actually trace to a bolt
                    G_GetBoltPosition(ent, ri!.footRBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                    //NOTE: have to fudge this a little because it's not getting enough range with the anim as-is
                    _VectorMA(kickEnd, 8, kickDir, &kickEnd)
                } else {
                    //guess
                    // Raven passes NULL for the `forward` and `up` outputs.
                    var scratchForward7 = vec3_t()
                    var scratchUp18 = vec3_t()
                    AngleVectors(fwdAngs, &scratchForward7, &kickDir, &scratchUp18)
                }
            } else {
                //else if ( elapsedTime >= 350 && elapsedTime < 450 )
                //left
                doKick = true
                if ri!.footLBolt != -1 {
                    //actually trace to a bolt
                    G_GetBoltPosition(ent, ri!.footLBolt, &kickEnd, 0)
                    kickDir = kickEnd - ent.r.currentOrigin
                    kickDir[2] = 0 //ah, flatten it, I guess...
                    VectorNormalize(&kickDir)
                    //NOTE: have to fudge this a little because it's not getting enough range with the anim as-is
                    _VectorMA(kickEnd, 8, kickDir, &kickEnd)
                } else {
                    //guess
                    // Raven passes NULL for the `forward` and `up` outputs.
                    var scratchForward8 = vec3_t()
                    var scratchUp19 = vec3_t()
                    AngleVectors(fwdAngs, &scratchForward8, &kickDir, &scratchUp19)
                    kickDir = kickDir * -1
                }
            }

        default:
            break
        }
    }

    if doKick {
        //		G_KickTrace( ent, kickDir, kickDist, kickEnd, kickDamage, kickPush );
        G_KickTrace(ent, &kickDir, kickDist, nil, kickDamage, Float(kickPush))
    }
}

/// Source: oracle/codemp/game/w_saber.c:7958
private func G_PrettyCloseIGuess(_ a: Float, _ b: Float, _ tolerance: Float) -> Bool {
    if (a - b) < tolerance && (a - b) > -tolerance {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/w_saber.c:7969
private func G_GrabSomeMofos(_ `self`: Entity) {
    let ri: RenderInfo? = `self`.client!.renderInfo
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var flatAng = vec3_t()
        var pos = vec3_t()
        var grabMins = vec3_t()
        var grabMaxs = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = Trace.scratch { trace -> Bool in

            if `self`.ghoul2 == nil || ri!.handRBolt == -1 {
                //no good
                return true
            }

            flatAng = vec3_t(0.0, `self`.client!.ps.viewangles[1], 0.0)
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, ri!.handRBolt, boltMatrix, flatAng, `self`.client!.ps.origin, level.time, nil, &`self`.modelScale)
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &pos)

            grabMins = vec3_t(-4.0, -4.0, -4.0)
            grabMaxs = vec3_t(4.0, 4.0, 4.0)

            //trace from my origin to my hand, if we hit anyone then get 'em
            trap_G2Trace(trace, `self`.client!.ps.origin, grabMins, grabMaxs, pos, `self`.s.number, MASK_SHOT, G2TRFLAG_DOGHOULTRACE | G2TRFLAG_GETSURFINDEX | G2TRFLAG_THICK | G2TRFLAG_HITCORPSES, g_g2TraceLod.integer)

            if trace.fraction != 1.0 && trace.entityNum < ENTITYNUM_WORLD {
                let grabbed: Entity? = g_entities[trace.entityNum]

                if grabbed!.inuse && (grabbed!.s.eType == ET_PLAYER || grabbed!.s.eType == ET_NPC) && grabbed!.client != nil && grabbed!.health > 0 && G_CanBeEnemy(`self`, grabbed!) && G_PrettyCloseIGuess(grabbed!.client!.ps.origin[2], `self`.client!.ps.origin[2], 4.0) && (BG_InGrappleMove(grabbed!.client!.ps.torsoAnim) == 0 || grabbed!.client!.ps.torsoAnim == BOTH_KYLE_GRAB) && (BG_InGrappleMove(grabbed!.client!.ps.legsAnim) == 0 || grabbed!.client!.ps.legsAnim == BOTH_KYLE_GRAB) {
                    //grabbed an active player/npc
                    var tortureAnim: Int32 = -1
                    var correspondingAnim: Int32 = -1

                    if `self`.client!.pers.cmd.forwardmove > 0 {
                        //punch grab
                        tortureAnim = BOTH_KYLE_PA_1
                        correspondingAnim = BOTH_PLAYER_PA_1
                    } else if `self`.client!.pers.cmd.forwardmove < 0 {
                        //knee-throw
                        tortureAnim = BOTH_KYLE_PA_2
                        correspondingAnim = BOTH_PLAYER_PA_2
                    }

                    if tortureAnim == -1 || correspondingAnim == -1 {
                        if `self`.client!.ps.torsoTimer < 300 && `self`.client!.grappleState == 0 {
                            //you failed to grab anyone, play the "failed to grab" anim
                            G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, BOTH_KYLE_MISS, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                            if `self`.client!.ps.torsoAnim == BOTH_KYLE_MISS {
                                //providing the anim set succeeded..
                                `self`.client!.ps.weaponTime = `self`.client!.ps.torsoTimer
                            }
                        }
                        return true
                    }

                    `self`.client!.grappleIndex = grabbed!.s.number
                    `self`.client!.grappleState = 1

                    grabbed!.client!.grappleIndex = `self`.s.number
                    grabbed!.client!.grappleState = 20

                    //time to crack some heads
                    G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, tortureAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                    if `self`.client!.ps.torsoAnim == tortureAnim {
                        //providing the anim set succeeded..
                        `self`.client!.ps.weaponTime = `self`.client!.ps.torsoTimer
                    }

                    G_SetAnim(grabbed!, grabbed!.client!.pers.cmd, SETANIM_BOTH, correspondingAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                    if grabbed!.client!.ps.torsoAnim == correspondingAnim {
                        //providing the anim set succeeded..
                        if grabbed!.client!.ps.weapon == WP_SABER {
                            //turn it off
                            if grabbed!.client!.ps.saberHolstered == 0 {
                                grabbed!.client!.ps.saberHolstered = 2
                                if grabbed!.client!.saber[0].soundOff != 0 {
                                    G_Sound(grabbed!, CHAN_AUTO, grabbed!.client!.saber[0].soundOff)
                                }
                                if grabbed!.client!.saber[1].soundOff != 0 && !grabbed!.client!.saber[1].model.isEmpty {
                                    G_Sound(grabbed!, CHAN_AUTO, grabbed!.client!.saber[1].soundOff)
                                }
                            }
                        }
                        if grabbed!.client!.ps.torsoTimer < `self`.client!.ps.torsoTimer {
                            //make sure they stay in the anim at least as long as the grabber
                            grabbed!.client!.ps.torsoTimer = `self`.client!.ps.torsoTimer
                        }
                        grabbed!.client!.ps.weaponTime = grabbed!.client!.ps.torsoTimer
                    }
                }
            }

            if `self`.client!.ps.torsoTimer < 300 && `self`.client!.grappleState == 0 {
                //you failed to grab anyone, play the "failed to grab" anim
                G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, BOTH_KYLE_MISS, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                if `self`.client!.ps.torsoAnim == BOTH_KYLE_MISS {
                    //providing the anim set succeeded..
                    `self`.client!.ps.weaponTime = `self`.client!.ps.torsoTimer
                }
            }
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_saber.c:8084
func WP_SaberPositionUpdate(_ `self`: Entity, _ ucmd: JKAMP.Usercmd) {
    //rww - keep the saber position as updated as possible on the server so that we can try to do realistic-looking contact stuff
    //Note that this function also does the majority of working in maintaining the server g2 client instance (updating angles/anims/etc)
    var mySaber: Entity? = nil
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var properAngles = vec3_t()
        var properOrigin = vec3_t()
        var boltAngles = vec3_t()
        var boltOrigin = vec3_t()
        var end = vec3_t()
        var legAxis = [vec3_t](repeating: vec3_t(), count: 3)
        var addVel = vec3_t()
        var rawAngles = vec3_t()
        var fVSpeed: Float = 0
        var returnAfterUpdate: Int32 = 0
        var animSpeedScale: Float = 1.0
        var saberNum: Int32 = 0
        var clientOverride: Bool = false
        var vehEnt: Entity? = nil
        var rSaberNum: Int32 = 0
        var rBladeNum: Int32 = 0


        nextStep: do {
            if `self`.inuse && `self`.client != nil {
                if `self`.client!.saberCycleQueue != 0 {
                    `self`.client!.ps.fd.saberDrawAnimLevel = `self`.client!.saberCycleQueue
                } else {
                    `self`.client!.ps.fd.saberDrawAnimLevel = `self`.client!.ps.fd.saberAnimLevel
                }
            }

            if `self`.inuse && `self`.client != nil && `self`.client!.saberCycleQueue != 0 && (`self`.client!.ps.weaponTime <= 0 || `self`.health < 1) {
                //we cycled attack levels while we were busy, so update now that we aren't (even if that means we're dead)
                `self`.client!.ps.fd.saberAnimLevel = `self`.client!.saberCycleQueue
                `self`.client!.saberCycleQueue = 0
            }

            if !`self`.inuse || `self`.client == nil || `self`.ghoul2 == nil || g2SaberInstance == nil {
                return true
            }

            if BG_KickingAnim(`self`.client!.ps.legsAnim) {
                //do some kick traces and stuff if we're in the appropriate anim
                G_KickSomeMofos(`self`)
            } else if `self`.client!.ps.torsoAnim == BOTH_KYLE_GRAB {
                //try to grab someone
                G_GrabSomeMofos(`self`)
            } else if `self`.client!.grappleState != 0 {
                let grappler: Entity? = g_entities[`self`.client!.grappleIndex]

                if !grappler!.inuse || grappler!.client == nil || grappler!.client!.grappleIndex != `self`.s.number || BG_InGrappleMove(grappler!.client!.ps.torsoAnim) == 0 || BG_InGrappleMove(grappler!.client!.ps.legsAnim) == 0 || BG_InGrappleMove(`self`.client!.ps.torsoAnim) == 0 || BG_InGrappleMove(`self`.client!.ps.legsAnim) == 0 || `self`.client!.grappleState == 0 || grappler!.client!.grappleState == 0 || grappler!.health < 1 || `self`.health < 1 || !G_PrettyCloseIGuess(`self`.client!.ps.origin[2], grappler!.client!.ps.origin[2], 4.0) {
                    `self`.client!.grappleState = 0
                    if (BG_InGrappleMove(`self`.client!.ps.torsoAnim) != 0 && `self`.client!.ps.torsoTimer > 100) || (BG_InGrappleMove(`self`.client!.ps.legsAnim) != 0 && `self`.client!.ps.legsTimer > 100) {
                        //if they're pretty far from finishing the anim then shove them into another anim
                        G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, BOTH_KYLE_MISS, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                        if `self`.client!.ps.torsoAnim == BOTH_KYLE_MISS {
                            //providing the anim set succeeded..
                            `self`.client!.ps.weaponTime = `self`.client!.ps.torsoTimer
                        }
                    }
                } else {
                    var grapAng = vec3_t()

                    grapAng = grappler!.client!.ps.origin - `self`.client!.ps.origin

                    if VectorLength(grapAng) > 64.0 {
                        //too far away, break it off
                        if (BG_InGrappleMove(`self`.client!.ps.torsoAnim) != 0 && `self`.client!.ps.torsoTimer > 100) || (BG_InGrappleMove(`self`.client!.ps.legsAnim) != 0 && `self`.client!.ps.legsTimer > 100) {
                            `self`.client!.grappleState = 0

                            G_SetAnim(`self`, `self`.client!.pers.cmd, SETANIM_BOTH, BOTH_KYLE_MISS, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                            if `self`.client!.ps.torsoAnim == BOTH_KYLE_MISS {
                                //providing the anim set succeeded..
                                `self`.client!.ps.weaponTime = `self`.client!.ps.torsoTimer
                            }
                        }
                    } else {
                        vectoangles(grapAng, &grapAng)
                        SetClientViewAngle(`self`, grapAng)

                        if `self`.client!.grappleState >= 20 {
                            //grapplee
                            //try to position myself at the correct distance from my grappler
                            var idealDist: Float = 0
                            var gFwd = vec3_t()
                            var idealSpot = vec3_t()
                            // Raven's record lives to the end of his block, so the block is the closure.
                            Trace.scratch { trace in

                                if grappler!.client!.ps.torsoAnim == BOTH_KYLE_PA_1 {
                                    //grab punch
                                    idealDist = 46.0
                                } else {
                                    //knee-throw
                                    idealDist = 34.0
                                }

                                // Raven passes NULL for the `right` and `up` outputs.
                                var scratchRight = vec3_t()
                                var scratchUp = vec3_t()
                                AngleVectors(grappler!.client!.ps.viewangles, &gFwd, &scratchRight, &scratchUp)
                                _VectorMA(grappler!.client!.ps.origin, idealDist, gFwd, &idealSpot)

                                trap_Trace(trace, `self`.client!.ps.origin, `self`.r.mins, `self`.r.maxs, idealSpot, `self`.s.number, `self`.clipmask)
                                if trace.startsolid == 0 && trace.allsolid == 0 && trace.fraction == 1.0 {
                                    //go there
                                    G_SetOrigin(`self`, &idealSpot)
                                    `self`.client!.ps.origin = idealSpot
                                }
                            }
                        } else if `self`.client!.grappleState >= 1 {
                            //grappler
                            if grappler!.client!.ps.weapon == WP_SABER {
                                //make sure their saber is shut off
                                if grappler!.client!.ps.saberHolstered == 0 {
                                    grappler!.client!.ps.saberHolstered = 2
                                    if grappler!.client!.saber[0].soundOff != 0 {
                                        G_Sound(grappler!, CHAN_AUTO, grappler!.client!.saber[0].soundOff)
                                    }
                                    if grappler!.client!.saber[1].soundOff != 0 && !grappler!.client!.saber[1].model.isEmpty {
                                        G_Sound(grappler!, CHAN_AUTO, grappler!.client!.saber[1].soundOff)
                                    }
                                }
                            }

                            //check for smashy events
                            if `self`.client!.ps.torsoAnim == BOTH_KYLE_PA_1 {
                                //grab punch
                                if `self`.client!.grappleState == 1 {
                                    //smack
                                    if `self`.client!.ps.torsoTimer < 3400 {
                                        let grapplerAnim: Int32 = grappler!.client!.ps.torsoAnim
                                        let grapplerTime: Int32 = grappler!.client!.ps.torsoTimer

                                        var dir: vec3_t? = nil
                                        G_Damage(grappler!, `self`, `self`, &dir, `self`.client!.ps.origin, 10, 0, MOD_MELEE)
                                        //G_Sound( grappler, CHAN_AUTO, G_SoundIndex( va( "sound/weapons/melee/punch%d", Q_irand( 1, 4 ) ) ) );

                                        //it might try to put them into a pain anim or something, so override it back again
                                        if grappler!.health > 0 {
                                            grappler!.client!.ps.torsoAnim = grapplerAnim
                                            grappler!.client!.ps.torsoTimer = grapplerTime
                                            grappler!.client!.ps.legsAnim = grapplerAnim
                                            grappler!.client!.ps.legsTimer = grapplerTime
                                            grappler!.client!.ps.weaponTime = grapplerTime
                                        }
                                        `self`.client!.grappleState += 1
                                    }
                                } else if `self`.client!.grappleState == 2 {
                                    //smack!
                                    if `self`.client!.ps.torsoTimer < 2550 {
                                        let grapplerAnim: Int32 = grappler!.client!.ps.torsoAnim
                                        let grapplerTime: Int32 = grappler!.client!.ps.torsoTimer

                                        var dir: vec3_t? = nil
                                        G_Damage(grappler!, `self`, `self`, &dir, `self`.client!.ps.origin, 10, 0, MOD_MELEE)
                                        //G_Sound( grappler, CHAN_AUTO, G_SoundIndex( va( "sound/weapons/melee/punch%d", Q_irand( 1, 4 ) ) ) );

                                        //it might try to put them into a pain anim or something, so override it back again
                                        if grappler!.health > 0 {
                                            grappler!.client!.ps.torsoAnim = grapplerAnim
                                            grappler!.client!.ps.torsoTimer = grapplerTime
                                            grappler!.client!.ps.legsAnim = grapplerAnim
                                            grappler!.client!.ps.legsTimer = grapplerTime
                                            grappler!.client!.ps.weaponTime = grapplerTime
                                        }
                                        `self`.client!.grappleState += 1
                                    }
                                } else {
                                    //SMACK!
                                    if `self`.client!.ps.torsoTimer < 1300 {
                                        var tossDir = vec3_t()

                                        var dir: vec3_t? = nil
                                        G_Damage(grappler!, `self`, `self`, &dir, `self`.client!.ps.origin, 30, 0, MOD_MELEE)
                                        //G_Sound( grappler, CHAN_AUTO, G_SoundIndex( va( "sound/weapons/melee/punch%d", Q_irand( 1, 4 ) ) ) );

                                        `self`.client!.grappleState = 0

                                        tossDir = grappler!.client!.ps.origin - `self`.client!.ps.origin
                                        VectorNormalize(&tossDir)
                                        tossDir = tossDir * 500.0
                                        tossDir[2] = 200.0

                                        grappler!.client!.ps.velocity = grappler!.client!.ps.velocity + tossDir

                                        if grappler!.health > 0 {
                                            //if still alive knock them down
                                            grappler!.client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
                                            grappler!.client!.ps.forceHandExtendTime = level.time + 1300
                                        }
                                    }
                                }
                            } else if `self`.client!.ps.torsoAnim == BOTH_KYLE_PA_2 {
                                //knee throw
                                if `self`.client!.grappleState == 1 {
                                    //knee to the face
                                    if `self`.client!.ps.torsoTimer < 3200 {
                                        let grapplerAnim: Int32 = grappler!.client!.ps.torsoAnim
                                        let grapplerTime: Int32 = grappler!.client!.ps.torsoTimer

                                        var dir: vec3_t? = nil
                                        G_Damage(grappler!, `self`, `self`, &dir, `self`.client!.ps.origin, 20, 0, MOD_MELEE)
                                        //G_Sound( grappler, CHAN_AUTO, G_SoundIndex( va( "sound/weapons/melee/punch%d", Q_irand( 1, 4 ) ) ) );

                                        //it might try to put them into a pain anim or something, so override it back again
                                        if grappler!.health > 0 {
                                            grappler!.client!.ps.torsoAnim = grapplerAnim
                                            grappler!.client!.ps.torsoTimer = grapplerTime
                                            grappler!.client!.ps.legsAnim = grapplerAnim
                                            grappler!.client!.ps.legsTimer = grapplerTime
                                            grappler!.client!.ps.weaponTime = grapplerTime
                                        }
                                        `self`.client!.grappleState += 1
                                    }
                                } else if `self`.client!.grappleState == 2 {
                                    //smashed on the ground
                                    if `self`.client!.ps.torsoTimer < 2000 {
                                        //G_Damage(grappler, self, self, NULL, self->client->ps.origin, 10, 0, MOD_MELEE);
                                        //don't do damage on this one, it would look very freaky if they died
                                        G_EntitySound(grappler!, CHAN_VOICE, G_SoundIndex("*pain100.wav"))
                                        //G_Sound( grappler, CHAN_AUTO, G_SoundIndex( va( "sound/weapons/melee/punch%d", Q_irand( 1, 4 ) ) ) );
                                        `self`.client!.grappleState += 1
                                    }
                                } else {
                                    //and another smash
                                    if `self`.client!.ps.torsoTimer < 1000 {
                                        var dir: vec3_t? = nil
                                        G_Damage(grappler!, `self`, `self`, &dir, `self`.client!.ps.origin, 30, 0, MOD_MELEE)
                                        //G_Sound( grappler, CHAN_AUTO, G_SoundIndex( va( "sound/weapons/melee/punch%d", Q_irand( 1, 4 ) ) ) );

                                        //it might try to put them into a pain anim or something, so override it back again
                                        if grappler!.health > 0 {
                                            grappler!.client!.ps.torsoTimer = 1000
                                            //G_SetAnim(grappler, &grappler->client->pers.cmd, SETANIM_BOTH, BOTH_GETUP3, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD, 0);
                                            grappler!.client!.grappleState = 0
                                        } else {
                                            //override death anim
                                            grappler!.client!.ps.torsoAnim = BOTH_DEADFLOP1
                                            grappler!.client!.ps.legsAnim = BOTH_DEADFLOP1
                                        }

                                        `self`.client!.grappleState = 0
                                    }
                                }
                            } else {
                                //?
                            }
                        }
                    }
                }
            }

            //If this is a listen server (client+server running on same machine),
            //then lets try to steal the skeleton/etc data off the client instance
            //for this entity to save us processing time.
            clientOverride = trap_G2API_OverrideServer(`self`.ghoul2)

            saberNum = `self`.client!.ps.saberEntityNum

            if saberNum == 0 {
                saberNum = `self`.client!.saberStoredIndex
            }

            if saberNum == 0 {
                returnAfterUpdate = 1
                break nextStep
            }

            mySaber = g_entities[saberNum]

            if `self`.health < 1 {
                //we don't want to waste precious CPU time calculating saber positions for corpses. But we want to avoid the saber ent position lagging on spawn, so..
                //I guess it's good to keep the position updated even when contents are 0
                if mySaber != nil && ((mySaber!.r.contents & CONTENTS_LIGHTSABER) != 0 || mySaber!.r.contents == 0) && !`self`.client!.ps.saberInFlight {
                    //Since we haven't got a bolt position, place it on top of the player origin.
                    mySaber!.r.currentOrigin = `self`.client!.ps.origin
                }

                //I don't want to return now actually, I want to keep g2 instances for corpses up to
                //date because I'm doing better corpse hit detection/dismem (particularly for the
                //npc's)
                //return;
            }

            if BG_SuperBreakWinAnim(`self`.client!.ps.torsoAnim) {
                `self`.client!.ps.weaponstate = WEAPON_FIRING
            }
            if `self`.client!.ps.weapon != WP_SABER || `self`.client!.ps.weaponstate == WEAPON_RAISING || `self`.client!.ps.weaponstate == WEAPON_DROPPING || `self`.health < 1 {
                if !`self`.client!.ps.saberInFlight {
                    returnAfterUpdate = 1
                }
            }

            if `self`.client!.ps.saberThrowDelay < level.time {
                if (`self`.client!.saber[0].saberFlags & SFL_NOT_THROWABLE) != 0 {
                    //cant throw it normally!
                    if (`self`.client!.saber[0].saberFlags & SFL_SINGLE_BLADE_THROWABLE) != 0 {
                        //but can throw it if only have 1 blade on
                        if `self`.client!.saber[0].numBlades > 1 && `self`.client!.ps.saberHolstered == 1 {
                            //have multiple blades and only one blade on
                            `self`.client!.ps.saberCanThrow = true //qfalse;
                            //huh? want to be able to throw then right?
                        } else {
                            //multiple blades on, can't throw
                            `self`.client!.ps.saberCanThrow = false
                        }
                    } else {
                        //never can throw it
                        `self`.client!.ps.saberCanThrow = false
                    }
                } else {
                    //can throw it!
                    `self`.client!.ps.saberCanThrow = true
                }
            }
        }
        finalUpdate: do {
            if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
                animSpeedScale = 2
            }

            properOrigin = `self`.client!.ps.origin

            //try to predict the origin based on velocity so it's more like what the client is seeing
            addVel = `self`.client!.ps.velocity
            VectorNormalize(&addVel)

            if `self`.client!.ps.velocity[0] < 0 {
                fVSpeed += (-`self`.client!.ps.velocity[0])
            } else {
                fVSpeed += `self`.client!.ps.velocity[0]
            }
            if `self`.client!.ps.velocity[1] < 0 {
                fVSpeed += (-`self`.client!.ps.velocity[1])
            } else {
                fVSpeed += `self`.client!.ps.velocity[1]
            }
            if `self`.client!.ps.velocity[2] < 0 {
                fVSpeed += (-`self`.client!.ps.velocity[2])
            } else {
                fVSpeed += `self`.client!.ps.velocity[2]
            }

            //fVSpeed *= 0.08;
            fVSpeed *= 1.6 / g_svfps.value

            //Cap it off at reasonable values so the saber box doesn't go flying ahead of us or
            //something if we get a big speed boost from something.
            if fVSpeed > 70 {
                fVSpeed = 70
            }
            if fVSpeed < -70 {
                fVSpeed = -70
            }

            properOrigin[0] += addVel[0] * fVSpeed
            properOrigin[1] += addVel[1] * fVSpeed
            properOrigin[2] += addVel[2] * fVSpeed

            properAngles[0] = 0
            if `self`.s.number < MAX_CLIENTS && `self`.client!.ps.m_iVehicleNum != 0 {
                vehEnt = g_entities[`self`.client!.ps.m_iVehicleNum]
                if vehEnt!.inuse && vehEnt!.client != nil && vehEnt!.m_pVehicle != nil {
                    properAngles[1] = vehEnt!.m_pVehicle!.m_vOrientationVector[YAW]
                } else {
                    properAngles[1] = `self`.client!.ps.viewangles[YAW]
                    vehEnt = nil
                }
            } else {
                properAngles[1] = `self`.client!.ps.viewangles[YAW]
            }
            properAngles[2] = 0

            AnglesToAxis(properAngles, &legAxis)

            UpdateClientRenderinfo(`self`, properOrigin, properAngles)

            if !clientOverride {
                //if we get the client instance we don't need to do this
                G_G2PlayerAngles(`self`, &legAxis, &properAngles)
            }

            if vehEnt != nil {
                properAngles[1] = vehEnt!.m_pVehicle!.m_vOrientationVector[YAW]
            }

            if returnAfterUpdate != 0 && saberNum != 0 {
                //We don't even need to do GetBoltMatrix if we're only in here to keep the g2 server instance in sync
                //but keep our saber entity in sync too, just copy it over our origin.

                //I guess it's good to keep the position updated even when contents are 0
                if mySaber != nil && ((mySaber!.r.contents & CONTENTS_LIGHTSABER) != 0 || mySaber!.r.contents == 0) && !`self`.client!.ps.saberInFlight {
                    //Since we haven't got a bolt position, place it on top of the player origin.
                    mySaber!.r.currentOrigin = `self`.client!.ps.origin
                }

                break finalUpdate
            }

            if returnAfterUpdate != 0 {
                break finalUpdate
            }

            //We'll get data for blade 0 first no matter what it is and stick them into
            //the constant ("_Always") values. Later we will handle going through each blade.
            trap_G2API_GetBoltMatrix(`self`.ghoul2, 1, 0, boltMatrix, properAngles, properOrigin, level.time, nil, &`self`.modelScale)
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltOrigin)
            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &boltAngles)

            //immediately store these values so we don't have to recalculate this again
            if `self`.client!.lastSaberStorageTime != 0 && (level.time - `self`.client!.lastSaberStorageTime) < 200 {
                //alright
                `self`.client!.olderSaberBase = `self`.client!.lastSaberBase_Always
                `self`.client!.olderIsValid = true
            } else {
                `self`.client!.olderIsValid = false
            }

            `self`.client!.lastSaberBase_Always = boltOrigin
            `self`.client!.lastSaberDir_Always = boltAngles
            `self`.client!.lastSaberStorageTime = level.time

            rawAngles = boltAngles

            _VectorMA(boltOrigin, `self`.client!.saber[0].blade[0].lengthMax, boltAngles, &end)

            if `self`.client!.ps.saberEntityNum != 0 {
                //I guess it's good to keep the position updated even when contents are 0
                if mySaber != nil && ((mySaber!.r.contents & CONTENTS_LIGHTSABER) != 0 || mySaber!.r.contents == 0) && !`self`.client!.ps.saberInFlight {
                    //place it roughly in the middle of the saber..
                    _VectorMA(boltOrigin, `self`.client!.saber[0].blade[0].lengthMax, boltAngles, &mySaber!.r.currentOrigin)
                }
            }

            boltAngles[YAW] = `self`.client!.ps.viewangles[YAW]

            /*	{
            static int lastDTime = 0;
            if (lastDTime < level.time)
            {
            G_TestLine(boltOrigin, end, 0x0000ff, 200);
            lastDTime = level.time + 200;
            }
            }
            */
            if `self`.client!.ps.saberInFlight {
                //do the thrown-saber stuff
                let saberent: Entity? = g_entities[saberNum]

                if saberent != nil {
                    if `self`.client!.ps.saberEntityState == 0 && `self`.client!.ps.saberEntityNum != 0 {
                        var startorg = vec3_t()
                        var startang = vec3_t()
                        var dir = vec3_t()

                        saberent!.r.currentOrigin = boltOrigin

                        startorg = boltOrigin
                        startang = boltAngles

                        //startang[0] = 90;
                        //Instead of this we'll sort of fake it and slowly tilt it down on the client via
                        //a perframe method (which doesn't actually affect where or how the saber hits)

                        saberent!.r.svFlags &= ~(SVF_NOCLIENT)
                        saberent!.s.pos.trBase = startorg
                        saberent!.s.apos.trBase = startang

                        saberent!.s.origin = startorg
                        saberent!.s.angles = startang

                        saberent!.s.saberInFlight = true

                        saberent!.s.apos.trType = TR_LINEAR
                        saberent!.s.apos.trDelta[0] = 0
                        saberent!.s.apos.trDelta[1] = 800
                        saberent!.s.apos.trDelta[2] = 0

                        saberent!.s.pos.trType = TR_LINEAR
                        saberent!.s.eType = ET_GENERAL
                        saberent!.s.eFlags = 0

                        WP_SaberAddG2Model(saberent!, `self`.client!.saber[0].model, `self`.client!.saber[0].skin)

                        saberent!.s.modelGhoul2 = 127

                        saberent!.parent = `self`

                        `self`.client!.ps.saberEntityState = 1

                        //Projectile stuff:
                        // Raven passes NULL for the `right` and `up` outputs.
                        var scratchRight2 = vec3_t()
                        var scratchUp2 = vec3_t()
                        AngleVectors(`self`.client!.ps.viewangles, &dir, &scratchRight2, &scratchUp2)

                        saberent!.nextthink = level.time + FRAMETIME
                        saberent!.think = Think.saberFirstThrown

                        saberent!.damage = SABER_THROWN_HIT_DAMAGE
                        saberent!.methodOfDeath = MOD_SABER
                        saberent!.splashMethodOfDeath = MOD_SABER
                        saberent!.s.solid = 2
                        saberent!.r.contents = CONTENTS_LIGHTSABER

                        saberent!.genericValue5 = 0

                        saberent!.r.mins = vec3_t(SABERMINS_X, SABERMINS_Y, SABERMINS_Z)
                        saberent!.r.maxs = vec3_t(SABERMAXS_X, SABERMAXS_Y, SABERMAXS_Z)

                        saberent!.s.genericenemyindex = `self`.s.number + 1024

                        saberent!.touch = Touch.thrownSaberTouch

                        saberent!.s.weapon = WP_SABER

                        saberent!.s.pos.trDelta = dir * 400
                        saberent!.s.pos.trTime = level.time

                        if `self`.client!.saber[0].spinSound != 0 {
                            saberent!.s.loopSound = `self`.client!.saber[0].spinSound
                        } else {
                            saberent!.s.loopSound = saberSpinSound
                        }
                        saberent!.s.loopIsSoundset = false

                        `self`.client!.ps.saberDidThrowTime = level.time

                        `self`.client!.dangerTime = level.time
                        `self`.client!.ps.eFlags &= ~EF_INVULNERABLE
                        `self`.client!.invulnerableTimer = 0

                        trap_LinkEntity(saberent!)
                    } else if `self`.client!.ps.saberEntityNum != 0 {
                        saberent!.pos1 = boltOrigin
                        trap_LinkEntity(saberent!)

                        if saberent!.genericValue5 == PROPER_THROWN_VALUE {
                            //return to the owner now, this is a bad state to be in for here..
                            saberent!.genericValue5 = 0
                            saberent!.think = Think.SaberUpdateSelf
                            saberent!.nextthink = level.time
                            WP_SaberRemoveG2Model(saberent!)

                            `self`.client!.ps.saberInFlight = false
                            `self`.client!.ps.saberEntityState = 0
                            `self`.client!.ps.saberThrowDelay = level.time + 500
                            `self`.client!.ps.saberCanThrow = false
                        }
                    }
                }
            }

            /*
            if (self->client->ps.saberInFlight)
            { //if saber is thrown then only do the standard stuff for the left hand saber
            rSaberNum = 1;
            }
            */

            if !BG_SabersOff(`self`.client!.ps) {
                let saberent: Entity? = g_entities[saberNum]

                if !`self`.client!.ps.saberInFlight && saberent != nil {
                    saberent!.r.svFlags |= (SVF_NOCLIENT)
                    saberent!.r.contents = CONTENTS_LIGHTSABER
                    SetSaberBoxSize(saberent!)
                    saberent!.s.loopSound = 0
                    saberent!.s.loopIsSoundset = false
                }

                if `self`.client!.ps.saberLockTime > level.time && `self`.client!.ps.saberEntityNum != 0 {
                    if `self`.client!.ps.saberIdleWound < level.time {
                        var te: Entity?
                        var dir = vec3_t()
                        te = G_TempEntity(g_entities[saberNum].r.currentOrigin, EV_SABER_BLOCK)
                        dir = vec3_t(0, 1, 0)
                        te!.s.origin = g_entities[saberNum].r.currentOrigin
                        te!.s.angles = dir
                        te!.s.eventParm = 1
                        te!.s.weapon = 0 //saberNum
                        te!.s.legsAnim = 0 //bladeNum

                        `self`.client!.ps.saberIdleWound = level.time + Q_irand(400, 600)
                    }

                    while rSaberNum < MAX_SABERS {
                        rBladeNum = 0
                        while rBladeNum < `self`.client!.saber[rSaberNum].numBlades {
                            //Don't bother updating the bolt for each blade for this, it's just a very rough fallback method for during saberlocks
                            `self`.client!.saber[saberNum].blade[rBladeNum].trail.base = boltOrigin
                            `self`.client!.saber[saberNum].blade[rBladeNum].trail.tip = end
                            `self`.client!.saber[saberNum].blade[rBladeNum].trail.lastTime = level.time

                            rBladeNum += 1
                        }

                        rSaberNum += 1
                    }
                    `self`.client!.hasCurrentPosition = true

                    `self`.client!.ps.saberBlocked = BLOCKED_NONE

                    break finalUpdate
                }

                //reset it in case we used it for cycling before
                rBladeNum = 0
                rSaberNum = rBladeNum

                if `self`.client!.ps.saberInFlight {
                    //if saber is thrown then only do the standard stuff for the left hand saber
                    if `self`.client!.ps.saberEntityNum == 0 {
                        //however, if saber is not in flight but rather knocked away, our left saber is off, and thus we may do nothing.
                        rSaberNum = 1 //was 2?
                    } else {
                        //thrown saber still in flight, so do damage
                        rSaberNum = 0 //was 1?
                    }
                }

                WP_SaberClearDamage()
                saberDoClashEffect = false

                //Now cycle through each saber and each blade on the saber and do damage traces.
                while rSaberNum < MAX_SABERS {
                    if `self`.client!.saber[rSaberNum].model.isEmpty {
                        rSaberNum += 1
                        continue
                    }

                    /*
                    if (rSaberNum == 0 && (self->client->ps.brokenLimbs & (1 << BROKENLIMB_RARM)))
                    { //don't do saber 0 is the right arm is broken
                    rSaberNum++;
                    continue;
                    }
                    */
                    //for now I'm keeping a broken right arm swingable, it will just look and act damaged
                    //but still be useable

                    if rSaberNum == 1 && (`self`.client!.ps.brokenLimbs & (1 << BROKENLIMB_LARM)) != 0 {
                        //don't to saber 1 if the left arm is broken
                        break
                    }
                    // Raven tests `self->client->saber[1].model` and `self->client->saber[1].model[0]`.
                    // Both read as the same Swift test, so the draft writes it once.
                    if rSaberNum > 0 && !`self`.client!.saber[1].model.isEmpty && `self`.client!.ps.saberHolstered == 1 {
                        //don't to saber 2 if it's off
                        break
                    }
                    rBladeNum = 0
                    while rBladeNum < `self`.client!.saber[rSaberNum].numBlades {
                        //update muzzle data for the blade
                        `self`.client!.saber[rSaberNum].blade[rBladeNum].muzzlePointOld = `self`.client!.saber[rSaberNum].blade[rBladeNum].muzzlePoint
                        `self`.client!.saber[rSaberNum].blade[rBladeNum].muzzleDirOld = `self`.client!.saber[rSaberNum].blade[rBladeNum].muzzleDir

                        // Raven tests `!self->client->saber[1].model` and `!self->client->saber[1].model[0]`.
                        // Both read as the same Swift test, so the draft writes it once.
                        if rBladeNum > 0 && (`self`.client!.saber[1].model.isEmpty) && `self`.client!.saber[rSaberNum].numBlades > 1 && `self`.client!.ps.saberHolstered == 1 {
                            //don't to extra blades if they're off
                            break
                        }
                        //get the new data
                        //then update the bolt pos/dir. rBladeNum corresponds to the bolt index because blade bolts are added in order.
                        if rSaberNum == 0 && `self`.client!.ps.saberInFlight {
                            if `self`.client!.ps.saberEntityNum == 0 {
                                //dropped it... shouldn't get here, but...
                                //assert(0);
                                //FIXME: It's getting here a lot actually....
                                rSaberNum += 1
                                rBladeNum = 0
                                continue
                            } else {
                                let saberEnt: Entity? = g_entities[`self`.client!.ps.saberEntityNum]
                                var saberOrg = vec3_t()
                                var saberAngles = vec3_t()
                                if saberEnt == nil || !saberEnt!.inuse || saberEnt!.ghoul2 == nil {
                                    //wtf?
                                    rSaberNum += 1
                                    rBladeNum = 0
                                    continue
                                }
                                if saberent!.s.saberInFlight {
                                    //spinning
                                    BG_EvaluateTrajectory(saberEnt!.s.pos, level.time + 50, &saberOrg)
                                    BG_EvaluateTrajectory(saberEnt!.s.apos, level.time + 50, &saberAngles)
                                } else {
                                    //coming right back
                                    var saberDir = vec3_t()
                                    BG_EvaluateTrajectory(saberEnt!.s.pos, level.time, &saberOrg)
                                    saberDir = `self`.r.currentOrigin - saberOrg
                                    vectoangles(saberDir, &saberAngles)
                                }
                                trap_G2API_GetBoltMatrix(saberEnt!.ghoul2, 0, rBladeNum, boltMatrix, saberAngles, saberOrg, level.time, nil, &`self`.modelScale)
                                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &`self`.client!.saber[rSaberNum].blade[rBladeNum].muzzlePoint)
                                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &`self`.client!.saber[rSaberNum].blade[rBladeNum].muzzleDir)
                                boltOrigin = `self`.client!.saber[rSaberNum].blade[rBladeNum].muzzlePoint
                                _VectorMA(boltOrigin, `self`.client!.saber[rSaberNum].blade[rBladeNum].lengthMax, `self`.client!.saber[rSaberNum].blade[rBladeNum].muzzleDir, &end)
                            }
                        } else {
                            trap_G2API_GetBoltMatrix(`self`.ghoul2, rSaberNum + 1, rBladeNum, boltMatrix, properAngles, properOrigin, level.time, nil, &`self`.modelScale)
                            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &`self`.client!.saber[rSaberNum].blade[rBladeNum].muzzlePoint)
                            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &`self`.client!.saber[rSaberNum].blade[rBladeNum].muzzleDir)
                            boltOrigin = `self`.client!.saber[rSaberNum].blade[rBladeNum].muzzlePoint
                            _VectorMA(boltOrigin, `self`.client!.saber[rSaberNum].blade[rBladeNum].lengthMax, `self`.client!.saber[rSaberNum].blade[rBladeNum].muzzleDir, &end)
                        }

                        `self`.client!.saber[rSaberNum].blade[rBladeNum].storageTime = level.time

                        if `self`.client!.hasCurrentPosition && d_saberInterpolate.integer != 0 {
                            if `self`.client!.ps.weaponTime <= 0 {
                                //rww - 07/17/02 - don't bother doing the extra stuff unless actually attacking. This is in attempt to save CPU.
                                CheckSaberDamage(`self`, rSaberNum, rBladeNum, boltOrigin, &end, false, (MASK_PLAYERSOLID | CONTENTS_LIGHTSABER | MASK_SHOT), false)
                            } else if d_saberInterpolate.integer == 1 {
                                var trMask: Int32 = CONTENTS_LIGHTSABER | CONTENTS_BODY
                                var sN: Int32 = 0
                                var gotHit: Bool = false
                                var clientUnlinked: [Bool] = [Bool](repeating: false, count: 32)
                                var skipSaberTrace: Bool = false

                                if g_saberTraceSaberFirst.integer == 0 {
                                    skipSaberTrace = true
                                } else if g_saberTraceSaberFirst.integer >= 2 && g_gametype.integer != GT_DUEL && g_gametype.integer != GT_POWERDUEL && !`self`.client!.ps.duelInProgress {
                                    //if value is >= 2, and not in a duel, skip
                                    skipSaberTrace = true
                                }

                                if skipSaberTrace {
                                    //skip the saber-contents-only trace and get right to the full trace
                                    trMask = (MASK_PLAYERSOLID | CONTENTS_LIGHTSABER | MASK_SHOT)
                                } else {
                                    while sN < MAX_CLIENTS {
                                        if g_entities[sN].inuse && g_entities[sN].client != nil && g_entities[sN].r.linked && g_entities[sN].health > 0 && (g_entities[sN].r.contents & CONTENTS_BODY) != 0 {
                                            //Take this mask off before the saber trace, because we want to hit the saber first
                                            g_entities[sN].r.contents &= ~CONTENTS_BODY
                                            clientUnlinked[sN] = true
                                        } else {
                                            clientUnlinked[sN] = false
                                        }
                                        sN += 1
                                    }
                                }

                                while !gotHit {
                                    if !CheckSaberDamage(`self`, rSaberNum, rBladeNum, boltOrigin, &end, false, trMask, false) {
                                        if !CheckSaberDamage(`self`, rSaberNum, rBladeNum, boltOrigin, &end, true, trMask, false) {
                                            var oldSaberStart = vec3_t()
                                            var oldSaberEnd = vec3_t()
                                            var saberAngleNow = vec3_t()
                                            var saberAngleBefore = vec3_t()
                                            var saberMidDir = vec3_t()
                                            var saberMidAngle = vec3_t()
                                            var saberMidPoint = vec3_t()
                                            var saberMidEnd = vec3_t()
                                            var saberSubBase = vec3_t()
                                            var deltaX: Float = 0
                                            var deltaY: Float = 0
                                            var deltaZ: Float = 0

                                            if (level.time - `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.lastTime) > 100 {
                                                //no valid last pos, use current
                                                oldSaberStart = boltOrigin
                                                oldSaberEnd = end
                                            } else {
                                                //trace from last pos
                                                oldSaberStart = `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.base
                                                oldSaberEnd = `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.tip
                                            }

                                            saberAngleBefore = oldSaberEnd - oldSaberStart
                                            vectoangles(saberAngleBefore, &saberAngleBefore)

                                            saberAngleNow = end - boltOrigin
                                            vectoangles(saberAngleNow, &saberAngleNow)

                                            deltaX = AngleDelta(saberAngleBefore[0], saberAngleNow[0])
                                            deltaY = AngleDelta(saberAngleBefore[1], saberAngleNow[1])
                                            deltaZ = AngleDelta(saberAngleBefore[2], saberAngleNow[2])

                                            if (deltaX != 0 || deltaY != 0 || deltaZ != 0) && deltaX < 180 && deltaY < 180 && deltaZ < 180 && (BG_SaberInAttack(`self`.client!.ps.saberMove) || PM_SaberInTransition(`self`.client!.ps.saberMove)) {
                                                //don't go beyond here if we aren't attacking/transitioning or the angle is too large.
                                                //and don't bother if the angle is the same
                                                saberMidAngle[0] = saberAngleBefore[0] + (deltaX / 2)
                                                saberMidAngle[1] = saberAngleBefore[1] + (deltaY / 2)
                                                saberMidAngle[2] = saberAngleBefore[2] + (deltaZ / 2)

                                                //Now that I have the angle, I'll just say the base for it is the difference between the two start
                                                //points (even though that's quite possibly completely false)
                                                saberSubBase = boltOrigin - oldSaberStart
                                                saberMidPoint[0] = Float(Double(boltOrigin[0]) + (Double(saberSubBase[0]) * 0.5))
                                                saberMidPoint[1] = Float(Double(boltOrigin[1]) + (Double(saberSubBase[1]) * 0.5))
                                                saberMidPoint[2] = Float(Double(boltOrigin[2]) + (Double(saberSubBase[2]) * 0.5))

                                                // Raven passes NULL for the `right` and `up` outputs.
                                                var scratchRight3 = vec3_t()
                                                var scratchUp3 = vec3_t()
                                                AngleVectors(saberMidAngle, &saberMidDir, &scratchRight3, &scratchUp3)
                                                saberMidEnd[0] = saberMidPoint[0] + saberMidDir[0] * `self`.client!.saber[rSaberNum].blade[rBladeNum].lengthMax
                                                saberMidEnd[1] = saberMidPoint[1] + saberMidDir[1] * `self`.client!.saber[rSaberNum].blade[rBladeNum].lengthMax
                                                saberMidEnd[2] = saberMidPoint[2] + saberMidDir[2] * `self`.client!.saber[rSaberNum].blade[rBladeNum].lengthMax

                                                //I'll just trace straight out and not even trace between positions to save speed.
                                                if CheckSaberDamage(`self`, rSaberNum, rBladeNum, saberMidPoint, &saberMidEnd, false, trMask, false) {
                                                    gotHit = true
                                                }
                                            }
                                        } else {
                                            gotHit = true
                                        }
                                    } else {
                                        gotHit = true
                                    }

                                    if g_saberTraceSaberFirst.integer != 0 {
                                        sN = 0
                                        while sN < MAX_CLIENTS {
                                            if clientUnlinked[sN] {
                                                //Make clients clip properly again.
                                                if g_entities[sN].inuse && g_entities[sN].health > 0 {
                                                    g_entities[sN].r.contents |= CONTENTS_BODY
                                                }
                                            }
                                            sN += 1
                                        }
                                    }

                                    if !gotHit {
                                        if trMask != (MASK_PLAYERSOLID | CONTENTS_LIGHTSABER | MASK_SHOT) {
                                            trMask = (MASK_PLAYERSOLID | CONTENTS_LIGHTSABER | MASK_SHOT)
                                        } else {
                                            gotHit = true //break out of the loop
                                        }
                                    }
                                }
                            } else if d_saberInterpolate.integer != 0 {
                                if !CheckSaberDamage(`self`, rSaberNum, rBladeNum, boltOrigin, &end, false, (MASK_PLAYERSOLID | CONTENTS_LIGHTSABER | MASK_SHOT), false) {
                                    CheckSaberDamage(`self`, rSaberNum, rBladeNum, boltOrigin, &end, true, (MASK_PLAYERSOLID | CONTENTS_LIGHTSABER | MASK_SHOT), false)
                                }
                            }
                        } else if d_saberSPStyleDamage.integer != 0 {
                            G_SPSaberDamageTraceLerped(`self`, rSaberNum, rBladeNum, &boltOrigin, &end, (MASK_PLAYERSOLID | CONTENTS_LIGHTSABER | MASK_SHOT))
                        } else {
                            CheckSaberDamage(`self`, rSaberNum, rBladeNum, boltOrigin, &end, false, (MASK_PLAYERSOLID | CONTENTS_LIGHTSABER | MASK_SHOT), false)
                        }

                        `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.base = boltOrigin
                        `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.tip = end
                        `self`.client!.saber[rSaberNum].blade[rBladeNum].trail.lastTime = level.time
                        //VectorCopy(boltOrigin, self->client->lastSaberBase);
                        //VectorCopy(end, self->client->lastSaberTip);
                        `self`.client!.hasCurrentPosition = true

                        //do hit effects
                        WP_SaberDoHit(`self`, rSaberNum, rBladeNum)
                        WP_SaberDoClash(`self`, rSaberNum, rBladeNum)

                        rBladeNum += 1
                    }

                    rSaberNum += 1
                }

                WP_SaberApplyDamage(`self`)
                //NOTE: doing one call like this after the 2 loops above is a bit cheaper, tempentity-wise... but won't use the correct saber and blade numbers...
                //now actually go through and apply all the damage we did
                //WP_SaberDoHit( self, 0, 0 );
                //WP_SaberDoClash( self, 0, 0 );

                if mySaber != nil && mySaber!.inuse {
                    trap_LinkEntity(mySaber!)
                }

                if !`self`.client!.ps.saberInFlight {
                    `self`.client!.ps.saberEntityState = 0
                }
            }
        }
        if clientOverride {
            //if we get the client instance we don't even need to bother setting anims and stuff
            return true
        }

        G_UpdateClientAnims(`self`, animSpeedScale)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/w_saber.c:9104
func WP_MissileBlockForBlock(_ saberBlock: Int32) -> Int32 {
    switch saberBlock {
    case BLOCKED_UPPER_RIGHT:
        return BLOCKED_UPPER_RIGHT_PROJ

    case BLOCKED_UPPER_LEFT:
        return BLOCKED_UPPER_LEFT_PROJ

    case BLOCKED_LOWER_RIGHT:
        return BLOCKED_LOWER_RIGHT_PROJ

    case BLOCKED_LOWER_LEFT:
        return BLOCKED_LOWER_LEFT_PROJ

    case BLOCKED_TOP:
        return BLOCKED_TOP_PROJ

    default:
        break
    }
    return saberBlock
}

/// Source: oracle/codemp/game/w_saber.c:9127
func WP_SaberBlockNonRandom(_ `self`: Entity, _ hitloc: JKAShared.vec3_t, _ missileBlock: Bool) {
    var diff = vec3_t()
    var fwdangles = vec3_t(0, 0, 0)
    var right = vec3_t()
    var clEye = vec3_t()
    let rightdot: Float
    let zdiff: Float

    clEye = `self`.client!.ps.origin
    clEye[2] += `self`.client!.ps.viewheight

    diff = hitloc - clEye
    diff[2] = 0
    VectorNormalize(&diff)

    fwdangles[1] = `self`.client!.ps.viewangles[1]
    // Ultimately we might care if the shot was ahead or behind, but for now, just quadrant is fine.
    // Raven passes NULL for the `forward` and `up` outputs.
    var scratchForward = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(fwdangles, &scratchForward, &right, &scratchUp)

    rightdot = _DotProduct(right, diff)
    zdiff = hitloc[2] - clEye[2]

    if zdiff > 0 {
        if Double(rightdot) > 0.3 {
            `self`.client!.ps.saberBlocked = BLOCKED_UPPER_RIGHT
        } else if Double(rightdot) < -0.3 {
            `self`.client!.ps.saberBlocked = BLOCKED_UPPER_LEFT
        } else {
            `self`.client!.ps.saberBlocked = BLOCKED_TOP
        }
    } else if zdiff > -20 {
        if zdiff < -10 {
            //hmm, pretty low, but not low enough to use the low block, so we need to duck
        }
        if Double(rightdot) > 0.1 {
            `self`.client!.ps.saberBlocked = BLOCKED_UPPER_RIGHT
        } else if Double(rightdot) < -0.1 {
            `self`.client!.ps.saberBlocked = BLOCKED_UPPER_LEFT
        } else {
            `self`.client!.ps.saberBlocked = BLOCKED_TOP
        }
    } else {
        if rightdot >= 0 {
            `self`.client!.ps.saberBlocked = BLOCKED_LOWER_RIGHT
        } else {
            `self`.client!.ps.saberBlocked = BLOCKED_LOWER_LEFT
        }
    }

    if missileBlock {
        `self`.client!.ps.saberBlocked = WP_MissileBlockForBlock(`self`.client!.ps.saberBlocked)
    }
}

/// Source: oracle/codemp/game/w_saber.c:9200
func WP_SaberBlock(_ playerent: Entity, _ hitloc: JKAShared.vec3_t, _ missileBlock: Bool) {
    var diff = vec3_t()
    var fwdangles = vec3_t(0, 0, 0)
    var right = vec3_t()
    let rightdot: Float
    let zdiff: Float

    diff = hitloc - playerent.client!.ps.origin
    VectorNormalize(&diff)

    fwdangles[1] = playerent.client!.ps.viewangles[1]
    // Ultimately we might care if the shot was ahead or behind, but for now, just quadrant is fine.
    // Raven passes NULL for the `forward` and `up` outputs.
    var scratchForward = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(fwdangles, &scratchForward, &right, &scratchUp)

    rightdot = _DotProduct(right, diff) + RandFloat(-0.2, 0.2)
    zdiff = hitloc[2] - playerent.client!.ps.origin[2] + Q_irand(-8, 8)

    // Figure out what quadrant the block was in.
    if zdiff > 24 {
        // Attack from above
        if Q_irand(0, 1) != 0 {
            playerent.client!.ps.saberBlocked = BLOCKED_TOP
        } else {
            playerent.client!.ps.saberBlocked = BLOCKED_UPPER_LEFT
        }
    } else if zdiff > 13 {
        // The upper half has three viable blocks...
        if Double(rightdot) > 0.25 {
            // In the right quadrant...
            if Q_irand(0, 1) != 0 {
                playerent.client!.ps.saberBlocked = BLOCKED_UPPER_LEFT
            } else {
                playerent.client!.ps.saberBlocked = BLOCKED_LOWER_LEFT
            }
        } else {
            switch Q_irand(0, 3) {
            case 0:
                playerent.client!.ps.saberBlocked = BLOCKED_UPPER_RIGHT

            case 1, 2:
                playerent.client!.ps.saberBlocked = BLOCKED_LOWER_RIGHT

            case 3:
                playerent.client!.ps.saberBlocked = BLOCKED_TOP

            default:
                break
            }
        }
    } else {
        // The lower half is a bit iffy as far as block coverage.  Pick one of the "low" ones at random.
        if Q_irand(0, 1) != 0 {
            playerent.client!.ps.saberBlocked = BLOCKED_LOWER_RIGHT
        } else {
            playerent.client!.ps.saberBlocked = BLOCKED_LOWER_LEFT
        }
    }

    if missileBlock {
        playerent.client!.ps.saberBlocked = WP_MissileBlockForBlock(playerent.client!.ps.saberBlocked)
    }
}

/// Source: oracle/codemp/game/w_saber.c:9276
func WP_SaberCanBlock(_ `self`: Entity, _ point: JKAShared.vec3_t, _ dflags: Int32, _ mod: Int32, _ projectile: Bool, _ attackStr: Int32) -> Int32 {
    var thrownSaber: Bool = false
    var blockFactor: Float = 0
    // Raven assigns his own `attackStr` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var attackStr = attackStr

    if `self`.client == nil {
        return 0
    }

    if attackStr == 999 {
        attackStr = 0
        thrownSaber = true
    }

    if BG_SaberInAttack(`self`.client!.ps.saberMove) {
        return 0
    }

    if PM_InSaberAnim(`self`.client!.ps.torsoAnim) && `self`.client!.ps.saberBlocked == 0 && `self`.client!.ps.saberMove != LS_READY && `self`.client!.ps.saberMove != LS_NONE {
        if `self`.client!.ps.saberMove < LS_PARRY_UP || `self`.client!.ps.saberMove > LS_REFLECT_LL {
            return 0
        }
    }

    if PM_SaberInBrokenParry(`self`.client!.ps.saberMove) {
        return 0
    }

    if `self`.client!.ps.saberEntityNum == 0 {
        //saber is knocked away
        return 0
    }

    if BG_SabersOff(`self`.client!.ps) {
        return 0
    }

    if `self`.client!.ps.weapon != WP_SABER {
        return 0
    }

    if `self`.client!.ps.weaponstate == WEAPON_RAISING {
        return 0
    }

    if `self`.client!.ps.saberInFlight {
        return 0
    }

    if (`self`.client!.pers.cmd.buttons & BUTTON_ATTACK) != 0 {
        //don't block when the player is trying to slash, if it's a projectile or he's doing a very strong attack
        return 0
    }

    //Removed this for now, the new broken parry stuff should handle it. This is how
    //blocks were decided before the 1.03 patch (as you can see, it was STUPID.. for the most part)
    /*
    if (attackStr == FORCE_LEVEL_3)
    {
    if (self->client->ps.fd.forcePowerLevel[FP_SABER_DEFENSE] >= FORCE_LEVEL_3)
    {
    if (Q_irand(1, 10) < 3)
    {
    return 0;
    }
    }
    else
    {
    return 0;
    }
    }

    if (attackStr == FORCE_LEVEL_2 && Q_irand(1, 10) < 3)
    {
    if (self->client->ps.fd.forcePowerLevel[FP_SABER_DEFENSE] >= FORCE_LEVEL_3)
    {
    //do nothing for now
    }
    else if (self->client->ps.fd.forcePowerLevel[FP_SABER_DEFENSE] >= FORCE_LEVEL_2)
    {
    if (Q_irand(1, 10) < 5)
    {
    return 0;
    }
    }
    else
    {
    return 0;
    }
    }

    if (attackStr == FORCE_LEVEL_1 && !self->client->ps.fd.forcePowerLevel[FP_SABER_DEFENSE] &&
    Q_irand(1, 40) < 3)
    { //if I have no defense level at all then I might be unable to block a level 1 attack (but very rarely)
    return 0;
    }
    */

    if SaberAttacking(`self`) {
        //attacking, can't block now
        return 0
    }

    if `self`.client!.ps.saberMove != LS_READY && `self`.client!.ps.saberBlocking == 0 {
        return 0
    }

    if `self`.client!.ps.saberBlockTime >= level.time {
        return 0
    }

    if `self`.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        return 0
    }

    if `self`.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] == FORCE_LEVEL_3 {
        if d_saberGhoul2Collision.integer != 0 {
            blockFactor = 0.3
        } else {
            blockFactor = 0.05
        }
    } else if `self`.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] == FORCE_LEVEL_2 {
        blockFactor = 0.6
    } else if `self`.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] == FORCE_LEVEL_1 {
        blockFactor = 0.9
    } else {
        //for now we just don't get to autoblock with no def
        return 0
    }

    if thrownSaber {
        blockFactor -= 0.25
    }

    if attackStr != 0 {
        //blocking a saber, not a projectile.
        blockFactor -= 0.25
    }

    if !InFront(point, `self`.client!.ps.origin, `self`.client!.ps.viewangles, blockFactor) {
        return 0
    }

    if projectile {
        WP_SaberBlockNonRandom(`self`, point, projectile)
    }
    return 1
}

/// Source: oracle/codemp/game/w_saber.c:9453
func HasSetSaberOnly() -> Bool {
    var i: Int32 = 0
    var wDisable: Int32 = 0

    if g_gametype.integer == GT_JEDIMASTER {
        //set to 0
        return false
    }

    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        wDisable = g_duelWeaponDisable.integer
    } else {
        wDisable = g_weaponDisable.integer
    }

    while i < WP_NUM_WEAPONS {
        if !((wDisable & (1 << i)) != 0) && i != WP_SABER && i != WP_NONE {
            return false
        }

        i += 1
    }

    return true
}
