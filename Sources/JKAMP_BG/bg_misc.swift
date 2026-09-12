import Foundation
import JKAMP
import JKAShared

/// Source: oracle/codemp/game/bg_misc.c:34
/// Raven's data table, a hand property of `BgState`.
var bgToggleableSurfaces: [String] {
    get { bg.bgToggleableSurfaces }
    set { bg.bgToggleableSurfaces = newValue }
}

/// Source: oracle/codemp/game/bg_misc.c:113
/// Raven's data table, a hand property of `BgState`.
var bg_customSiegeSoundNames: [String] {
    get { bg.bg_customSiegeSoundNames }
    set { bg.bg_customSiegeSoundNames = newValue }
}

/// Raven's `forceMasteryPoints` of `bg_misc.c`, the points a rank allows.
/// Source: oracle/codemp/game/bg_misc.c:162
let forceMasteryPoints: [Int32] = [
    0,		// FORCE_MASTERY_UNINITIATED,
    5,		// FORCE_MASTERY_INITIATE,
    10,		// FORCE_MASTERY_PADAWAN,
    20,		// FORCE_MASTERY_JEDI,
    30,		// FORCE_MASTERY_JEDI_GUARDIAN,
    50,		// FORCE_MASTERY_JEDI_ADEPT,
    75,		// FORCE_MASTERY_JEDI_KNIGHT,
    100		// FORCE_MASTERY_JEDI_MASTER,
]

/// Raven's `bgForcePowerCost` of `bg_misc.c`, the cost of one power at one level.
/// Source: oracle/codemp/game/bg_misc.c:174
let bgForcePowerCost: [[Int32]] = [ //0 == neutral
    [	0,	2,	4,	6	],	// Heal			// FP_HEAL
    [	0,	0,	2,	6	],	// Jump			//FP_LEVITATION,//hold/duration
    [	0,	2,	4,	6	],	// Speed		//FP_SPEED,//duration
    [	0,	1,	3,	6	],	// Push			//FP_PUSH,//hold/duration
    [	0,	1,	3,	6	],	// Pull			//FP_PULL,//hold/duration
    [	0,	4,	6,	8	],	// Mind Trick	//FP_TELEPATHY,//instant
    [	0,	1,	3,	6	],	// Grip			//FP_GRIP,//hold/duration
    [	0,	2,	5,	8	],	// Lightning	//FP_LIGHTNING,//hold/duration
    [	0,	4,	6,	8	],	// Dark Rage	//FP_RAGE,//duration
    [	0,	2,	5,	8	],	// Protection	//FP_PROTECT,//duration
    [	0,	1,	3,	6	],	// Absorb		//FP_ABSORB,//duration
    [	0,	1,	3,	6	],	// Team Heal	//FP_TEAM_HEAL,//instant
    [	0,	1,	3,	6	],	// Team Force	//FP_TEAM_FORCE,//instant
    [	0,	2,	4,	6	],	// Drain		//FP_DRAIN,//hold/duration
    [	0,	2,	5,	8	],	// Sight		//FP_SEE,//duration
    [	0,	1,	5,	8	],	// Saber Attack	//FP_SABER_OFFENSE,
    [	0,	1,	5,	8	],	// Saber Defend	//FP_SABER_DEFENSE,
    [	0,	4,	6,	8	]	// Saber Throw	//FP_SABERTHROW,
    //NUM_FORCE_POWERS
]

/// Raven's `forcePowerSorted` of `bg_misc.c`. Always use this order when drawing force powers, for any reason.
/// Source: oracle/codemp/game/bg_misc.c:197
let forcePowerSorted: [Int32] = [
    FP_TELEPATHY,
    FP_HEAL,
    FP_ABSORB,
    FP_PROTECT,
    FP_TEAM_HEAL,
    FP_LEVITATION,
    FP_SPEED,
    FP_PUSH,
    FP_PULL,
    FP_SEE,
    FP_LIGHTNING,
    FP_DRAIN,
    FP_RAGE,
    FP_GRIP,
    FP_TEAM_FORCE,
    FP_SABER_OFFENSE,
    FP_SABER_DEFENSE,
    FP_SABERTHROW,
]

/// Raven's `forcePowerDarkLight` of `bg_misc.c`, the side one power belongs to.
/// Source: oracle/codemp/game/bg_misc.c:219
let forcePowerDarkLight: [Int32] = [ //0 == neutral
    //nothing should be usable at rank 0..
    FORCE_LIGHTSIDE,//FP_HEAL,//instant
    0,//FP_LEVITATION,//hold/duration
    0,//FP_SPEED,//duration
    0,//FP_PUSH,//hold/duration
    0,//FP_PULL,//hold/duration
    FORCE_LIGHTSIDE,//FP_TELEPATHY,//instant
    FORCE_DARKSIDE,//FP_GRIP,//hold/duration
    FORCE_DARKSIDE,//FP_LIGHTNING,//hold/duration
    FORCE_DARKSIDE,//FP_RAGE,//duration
    FORCE_LIGHTSIDE,//FP_PROTECT,//duration
    FORCE_LIGHTSIDE,//FP_ABSORB,//duration
    FORCE_LIGHTSIDE,//FP_TEAM_HEAL,//instant
    FORCE_DARKSIDE,//FP_TEAM_FORCE,//instant
    FORCE_DARKSIDE,//FP_DRAIN,//hold/duration
    0,//FP_SEE,//duration
    0,//FP_SABER_OFFENSE,
    0,//FP_SABER_DEFENSE,
    0//FP_SABERTHROW,
        //NUM_FORCE_POWERS
]

/// Source: oracle/codemp/game/bg_misc.c:242
/// Raven's data table, a hand property of `BgState`.
var WeaponReadyAnim: [Int32] {
    get { bg.WeaponReadyAnim }
    set { bg.WeaponReadyAnim = newValue }
}

/// Source: oracle/codemp/game/bg_misc.c:268
/// Raven's data table, a hand property of `BgState`.
var WeaponReadyLegsAnim: [Int32] {
    get { bg.WeaponReadyLegsAnim }
    set { bg.WeaponReadyLegsAnim = newValue }
}

/// Source: oracle/codemp/game/bg_misc.c:294
/// Raven's data table, a hand property of `BgState`.
var WeaponAttackAnim: [Int32] {
    get { bg.WeaponAttackAnim }
    set { bg.WeaponAttackAnim = newValue }
}

/// Source: oracle/codemp/game/bg_misc.c:319
func BG_FileExists(_ fileName: String) -> Bool {
    // Raven also tests `fileName` for NULL here. A String is never NULL, so that half of the guard has no Swift form.
    if !fileName.isEmpty {
        var fh: Int32 = 0
        trap_FS_FOpenFile(fileName, &fh, FS_READ)
        if fh > 0 {
            trap_FS_FCloseFile(fh)
            return true
        }
    }

    return false
}

/**
```
===============
BG_ParseField

Takes a key/value pair and sets the binary values
in a gentity/centity/whatever the hell you want
===============
```
*/
/// Source: oracle/codemp/game/bg_misc.c:358
func BG_ParseField(_ l_fields: Slots<JKAMP.BgField>, _ key: String, _ value: String, _ ent: UnsafeMutableRawPointer) {
    var v: Float
    var vec = vec3_t()

    // Raven walks a `BG_field_t *` from `l_fields` while `f->name` is set. The port indexes the same slots.
    var index: Int32 = 0
    while let name = l_fields[index].name {
        let f = l_fields[index]
        if Q_stricmp(name.string, key) == 0 {
            // found it
            let b = ent

            switch f.type {
            case F_LSTRING:
                if bg.consumer == .game {
                    b[string: f.ofs] = G_NewString(value)
                } else {
                    b[string: f.ofs] = CG_NewString(value)
                }
            case F_VECTOR:
                sscanf(value, "%f %f %f", &vec)
                b[float: f.ofs, 0] = vec[0]
                b[float: f.ofs, 1] = vec[1]
                b[float: f.ofs, 2] = vec[2]
            case F_INT:
                b[int: f.ofs] = atoi(value)
            case F_FLOAT:
                b[float: f.ofs] = atof(value)
            case F_ANGLEHACK:
                v = atof(value)
                b[float: f.ofs, 0] = 0
                b[float: f.ofs, 1] = v
                b[float: f.ofs, 2] = 0
            case F_PARM1, F_PARM2, F_PARM3, F_PARM4, F_PARM5, F_PARM6, F_PARM7, F_PARM8,
                F_PARM9, F_PARM10, F_PARM11, F_PARM12, F_PARM13, F_PARM14, F_PARM15, F_PARM16:
                if bg.consumer == .game {
                    // Port-note: `bgEntity_t` carries the same leading `entityState_t`, so this view reads the same bytes.
                    Q3_SetParm(BgEntity(ent).s.number, f.type - F_PARM1, value)
                } else {
                    // Raven compiles no `F_PARM` case for cgame, so the field falls to `F_IGNORE` and nothing happens.
                }
            case F_IGNORE:
                break
            default:
                break
            }
            return
        }

        index += 1
    }
}

/**
```
================
BG_LegalizedForcePowers

The magical function to end all functions.
This will take the force power string in powerOut and parse through it, then legalize
it based on the supposed rank and spit it into powerOut, returning true if it was legal
to begin with and false if not.
fpDisabled is actually only expected (needed) from the server, because the ui disables
force power selection anyway when force powers are disabled on the server.
================
```
*/
// Port-note: Raven leaves `final_Powers` uninitialized, and a short string leaves the tail of it unread.
// Swift needs a value, so the port starts every entry at 0.
/// Source: oracle/codemp/game/bg_misc.c:439
func BG_LegalizedForcePowers(_ powerOut: inout JKAShared.CharBuf, _ maxRank: Int32, _ freeSaber: Bool, _ teamForce: Int32, _ gametype: Int32, _ fpDisabled: Int32) -> Bool {
    var powerBuf = CharBuf(128)
    var readBuf = CharBuf(128)
    var maintainsValidity = true
    let powerLen = strlen(powerOut)
    var i: Int32 = 0
    var c: Int32 = 0
    var allowedPoints: Int32 = 0
    var usedPoints: Int32 = 0
    var countDown: Int32 = 0

    var final_Side: Int32
    var final_Powers = [Int32](repeating: 0, count: Int(NUM_FORCE_POWERS))

    if powerLen >= 128 {
        //This should not happen. If it does, this is obviously a bogus string.
        //They can have this string. Because I said so.
        strcpy(&powerBuf, "7-1-032330000000001333")
        maintainsValidity = false
    } else {
        strcpy(&powerBuf, powerOut) //copy it as the original
    }

    //first of all, print the max rank into the string as the rank
    strcpy(&powerOut, va("%i-", maxRank))

    while i < 128 && powerBuf[i] != 0 && powerBuf[i] != Int32(ascii: "-") {
        i += 1
    }
    i += 1
    while i < 128 && powerBuf[i] != 0 && powerBuf[i] != Int32(ascii: "-") {
        readBuf[c] = powerBuf[i]
        c += 1
        i += 1
    }
    readBuf[c] = 0
    i += 1
    //at this point, readBuf contains the intended side
    final_Side = atoi(readBuf)

    if final_Side != FORCE_LIGHTSIDE && final_Side != FORCE_DARKSIDE {
        //Not a valid side. You will be dark. Because I said so. (this is something that should never actually happen unless you purposely feed in an invalid config)
        final_Side = FORCE_DARKSIDE
        maintainsValidity = false
    }

    if teamForce != 0 {
        //If we are under force-aligned teams, make sure we're on the right side.
        if final_Side != teamForce {
            final_Side = teamForce
            //maintainsValidity = qfalse;
            //Not doing this, for now. Let them join the team with their filtered powers.
        }
    }

    //Now we have established a valid rank, and a valid side.
    //Read the force powers in, and cut them down based on the various rules supplied.
    c = 0
    while i < 128 && powerBuf[i] != 0 && powerBuf[i] != Int32(ascii: "\n") && c < NUM_FORCE_POWERS {
        readBuf[0] = powerBuf[i]
        readBuf[1] = 0
        final_Powers[c] = atoi(readBuf)
        c += 1
        i += 1
    }

    //final_Powers now contains all the stuff from the string
    //Set the maximum allowed points used based on the max rank level, and count the points actually used.
    allowedPoints = forceMasteryPoints[maxRank]

    i = 0
    while i < NUM_FORCE_POWERS {
        //if this power doesn't match the side we're on, then 0 it now.
        if final_Powers[i] != 0 && forcePowerDarkLight[i] != 0 && forcePowerDarkLight[i] != final_Side {
            final_Powers[i] = 0
            //This is only likely to happen with g_forceBasedTeams. Let it slide.
        }

        if final_Powers[i] != 0 && (fpDisabled & (1 << i)) != 0 {
            //if this power is disabled on the server via said server option, then we don't get it.
            final_Powers[i] = 0
        }

        i += 1
    }

    if gametype < GT_TEAM {
        //don't bother with team powers then
        final_Powers[FP_TEAM_HEAL] = 0
        final_Powers[FP_TEAM_FORCE] = 0
    }

    usedPoints = 0
    i = 0
    while i < NUM_FORCE_POWERS {
        countDown = 0

        countDown = final_Powers[i]

        while countDown > 0 {
            usedPoints += bgForcePowerCost[i][countDown] //[fp index][fp level]
            //if this is jump, or we have a free saber and it's offense or defense, take the level back down on level 1
            if countDown == 1
                && ((i == FP_LEVITATION)
                    || (i == FP_SABER_OFFENSE && freeSaber)
                    || (i == FP_SABER_DEFENSE && freeSaber)) {
                usedPoints -= bgForcePowerCost[i][countDown]
            }
            countDown -= 1
        }

        i += 1
    }

    if usedPoints > allowedPoints {
        //Time to do the fancy stuff. (meaning, slowly cut parts off while taking a guess at what is most or least important in the config)
        var attemptedCycles: Int32 = 0
        var powerCycle: Int32 = 2
        var minPow: Int32 = 0

        if freeSaber {
            minPow = 1
        }

        maintainsValidity = false

        while usedPoints > allowedPoints {
            c = 0

            while c < NUM_FORCE_POWERS && usedPoints > allowedPoints {
                if final_Powers[c] != 0 && final_Powers[c] < powerCycle {
                    //kill in order of lowest powers, because the higher powers are probably more important
                    if c == FP_SABER_OFFENSE
                        && (final_Powers[FP_SABER_DEFENSE] > minPow || final_Powers[FP_SABERTHROW] > 0) {
                        //if we're on saber attack, only suck it down if we have no def or throw either
                        var whichOne: Int32 = FP_SABERTHROW //first try throw

                        if final_Powers[whichOne] == 0 {
                            whichOne = FP_SABER_DEFENSE //if no throw, drain defense
                        }

                        while final_Powers[whichOne] > 0 && usedPoints > allowedPoints {
                            if final_Powers[whichOne] > 1
                                || ((whichOne != FP_SABER_OFFENSE || !freeSaber)
                                    && (whichOne != FP_SABER_DEFENSE || !freeSaber)) {
                                //don't take attack or defend down on level 1 still, if it's free
                                usedPoints -= bgForcePowerCost[whichOne][final_Powers[whichOne]]
                                final_Powers[whichOne] -= 1
                            } else {
                                break
                            }
                        }
                    } else {
                        while final_Powers[c] > 0 && usedPoints > allowedPoints {
                            if final_Powers[c] > 1
                                || ((c != FP_LEVITATION)
                                    && (c != FP_SABER_OFFENSE || !freeSaber)
                                    && (c != FP_SABER_DEFENSE || !freeSaber)) {
                                usedPoints -= bgForcePowerCost[c][final_Powers[c]]
                                final_Powers[c] -= 1
                            } else {
                                break
                            }
                        }
                    }
                }

                c += 1
            }

            powerCycle += 1
            attemptedCycles += 1

            if attemptedCycles > NUM_FORCE_POWERS {
                //I think this should be impossible. But just in case.
                break
            }
        }

        if usedPoints > allowedPoints {
            //Still? Fine then.. we will kill all of your powers, except the freebies.
            i = 0

            while i < NUM_FORCE_POWERS {
                final_Powers[i] = 0
                if i == FP_LEVITATION
                    || (i == FP_SABER_OFFENSE && freeSaber)
                    || (i == FP_SABER_DEFENSE && freeSaber) {
                    final_Powers[i] = 1
                }
                i += 1
            }
            usedPoints = 0
        }
    }

    if freeSaber {
        if final_Powers[FP_SABER_OFFENSE] < 1 {
            final_Powers[FP_SABER_OFFENSE] = 1
        }
        if final_Powers[FP_SABER_DEFENSE] < 1 {
            final_Powers[FP_SABER_DEFENSE] = 1
        }
    }
    if final_Powers[FP_LEVITATION] < 1 {
        final_Powers[FP_LEVITATION] = 1
    }

    i = 0
    while i < NUM_FORCE_POWERS {
        if final_Powers[i] > FORCE_LEVEL_3 {
            final_Powers[i] = FORCE_LEVEL_3
        }
        i += 1
    }

    if fpDisabled != 0 {
        //If we specifically have attack or def disabled, force them up to level 3. It's the way
        //things work for the case of all powers disabled.
        //If jump is disabled, down-cap it to level 1. Otherwise don't do a thing.
        if (fpDisabled & (1 << FP_LEVITATION)) != 0 {
            final_Powers[FP_LEVITATION] = 1
        }
        if (fpDisabled & (1 << FP_SABER_OFFENSE)) != 0 {
            final_Powers[FP_SABER_OFFENSE] = 3
        }
        if (fpDisabled & (1 << FP_SABER_DEFENSE)) != 0 {
            final_Powers[FP_SABER_DEFENSE] = 3
        }
    }

    if final_Powers[FP_SABER_OFFENSE] < 1 {
        final_Powers[FP_SABER_DEFENSE] = 0
        final_Powers[FP_SABERTHROW] = 0
    }

    //We finally have all the force powers legalized and stored locally.
    //Put them all into the string and return the result. We already have
    //the rank there, so print the side and the powers now.
    Q_strcat(&powerOut, 128, va("%i-", final_Side))

    i = strlen(powerOut)
    c = 0
    while c < NUM_FORCE_POWERS {
        strcpy(&readBuf, va("%i", final_Powers[c]))
        powerOut[i] = readBuf[0]
        c += 1
        i += 1
    }
    powerOut[i] = 0

    return maintainsValidity
}

/// Source: oracle/codemp/game/bg_misc.c:795
// TODO: Port global bg_itemlist
// Raven wrote: gitem_t bg_itemlist[]
// Raven's data table is C storage by hand in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape.

/// Source: oracle/codemp/game/bg_misc.c:1773
func vectoyaw(_ vec: JKAShared.vec3_t) -> Float {
    var yaw: Float

    if vec[YAW] == 0 && vec[PITCH] == 0 {
        yaw = 0
    } else {
        if vec[PITCH] != 0 {
            // Raven's atan2 is the double libm call and M_PI is the double of math.h.
            yaw = Float(atan2(Double(vec[YAW]), Double(vec[PITCH])) * 180 / Double.pi)
        } else if vec[YAW] > 0 {
            yaw = 90
        } else {
            yaw = 270
        }
        if yaw < 0 {
            yaw += 360
        }
    }

    return yaw
}

/// Source: oracle/codemp/game/bg_misc.c:1794
func BG_HasYsalamiri(_ gametype: Int32, _ ps: JKAMP.PlayerState) -> Bool {
    if gametype == GT_CTY && (ps.powerups[PW_REDFLAG] != 0 || ps.powerups[PW_BLUEFLAG] != 0) {
        return true
    }

    if ps.powerups[PW_YSALAMIRI] != 0 {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/bg_misc.c:1810
func BG_CanUseFPNow(_ gametype: Int32, _ ps: JKAMP.PlayerState, _ time: Int32, _ power: JKAMP.forcePowers_t) -> Bool {
    if BG_HasYsalamiri(gametype, ps) {
        return false
    }

    if ps.forceRestricted || ps.trueNonJedi {
        return false
    }

    if ps.weapon == WP_EMPLACED_GUN {
        //can't use any of your powers while on an emplaced weapon
        return false
    }

    if ps.m_iVehicleNum != 0 {
        //can't use powers while riding a vehicle (this may change, I don't know)
        return false
    }

    if ps.duelInProgress {
        if power != FP_SABER_OFFENSE && power != FP_SABER_DEFENSE && /*power != FP_SABERTHROW &&*/
            power != FP_LEVITATION {
            if ps.saberLockFrame == 0 || power != FP_PUSH {
                return false
            }
        }
    }

    if ps.saberLockFrame != 0 || ps.saberLockTime > time {
        if power != FP_PUSH {
            return false
        }
    }

    if ps.fallingToDeath != 0 {
        return false
    }

    if (ps.brokenLimbs & (1 << BROKENLIMB_RARM)) != 0
        || (ps.brokenLimbs & (1 << BROKENLIMB_LARM)) != 0 {
        //powers we can't use with a broken arm
        switch power {
        case FP_PUSH, FP_PULL, FP_GRIP, FP_LIGHTNING, FP_DRAIN:
            return false
        default:
            break
        }
    }

    return true
}

/**
```
==============
BG_FindItemForPowerup
==============
```
*/
/// Source: oracle/codemp/game/bg_misc.c:1881
func BG_FindItemForPowerup(_ pw: JKAMP.powerup_t) -> JKAMP.Gitem? {
    var i: Int32

    i = 0
    while i < bg_numItems {
        if (bg_itemlist[i].giType == IT_POWERUP || bg_itemlist[i].giType == IT_TEAM)
            && bg_itemlist[i].giTag == pw {
            return bg_itemlist[i]
        }
        i += 1
    }

    return nil
}

/**
```
==============
BG_FindItemForHoldable
==============
```
*/
/// Source: oracle/codemp/game/bg_misc.c:1901
func BG_FindItemForHoldable(_ pw: JKAMP.holdable_t) -> JKAMP.Gitem? {
    var i: Int32

    i = 0
    while i < bg_numItems {
        if bg_itemlist[i].giType == IT_HOLDABLE && bg_itemlist[i].giTag == pw {
            return bg_itemlist[i]
        }
        i += 1
    }

    // Raven writes `return NULL` after this call, which `Com_Error` never reaches.
    Com_Error(ERR_DROP, "HoldableItem not found")
}

/**
```
===============
BG_FindItemForWeapon

===============
```
*/
/// Source: oracle/codemp/game/bg_misc.c:1922
func BG_FindItemForWeapon(_ weapon: JKAMP.weapon_t) -> JKAMP.Gitem? {
    // Raven walks a `gitem_t *` from `bg_itemlist + 1` while `it->classname` is set. The port indexes the same slots.
    var index: Int32 = 1
    while bg_itemlist[index].classname != nil {
        let it = bg_itemlist[index]
        if it.giType == IT_WEAPON && it.giTag == weapon {
            return it
        }
        index += 1
    }

    // Raven writes `return NULL` after this call, which `Com_Error` never reaches.
    Com_Error(ERR_DROP, "Couldn't find item for weapon \(weapon)")
}

/**
```
===============
BG_FindItemForAmmo

===============
```
*/
/// Source: oracle/codemp/game/bg_misc.c:1941
func BG_FindItemForAmmo(_ ammo: JKAMP.ammo_t) -> JKAMP.Gitem? {
    var index: Int32 = 1
    while bg_itemlist[index].classname != nil {
        let it = bg_itemlist[index]
        if it.giType == IT_AMMO && it.giTag == ammo {
            return it
        }
        index += 1
    }

    // Raven writes `return NULL` after this call, which `Com_Error` never reaches.
    Com_Error(ERR_DROP, "Couldn't find item for ammo \(ammo)")
}

/**
```
===============
BG_FindItem

===============
```
*/
/// Source: oracle/codemp/game/bg_misc.c:1960
func BG_FindItem(_ classname: String) -> JKAMP.Gitem? {
    var index: Int32 = 1
    while let itemClassname = bg_itemlist[index].classname {
        if Q_stricmp(itemClassname.string, classname) == 0 {
            return bg_itemlist[index]
        }
        index += 1
    }

    return nil
}

/**
```
============
BG_PlayerTouchesItem

Items can be picked up without actually touching their physical bounds to make
grabbing them easier
============
```
*/
/// Source: oracle/codemp/game/bg_misc.c:1979
func BG_PlayerTouchesItem(_ ps: JKAMP.PlayerState, _ item: JKAMP.EntityState, _ atTime: Int32) -> Bool {
    var origin = vec3_t()

    BG_EvaluateTrajectory(item.pos, atTime, &origin)

    // we are ignoring ducked differences here
    if ps.origin[0] - origin[0] > 44
        || ps.origin[0] - origin[0] < -50
        || ps.origin[1] - origin[1] > 36
        || ps.origin[1] - origin[1] < -36
        || ps.origin[2] - origin[2] > 36
        || ps.origin[2] - origin[2] < -36 {
        return false
    }

    return true
}

/// Source: oracle/codemp/game/bg_misc.c:1997
func BG_ProperForceIndex(_ power: Int32) -> Int32 {
    var i: Int32 = 0

    while i < NUM_FORCE_POWERS {
        if forcePowerSorted[i] == power {
            return i
        }

        i += 1
    }

    return -1
}

/// Source: oracle/codemp/game/bg_misc.c:2014
func BG_CycleForce(_ ps: JKAMP.PlayerState, _ direction: Int32) {
    var i = ps.fd.forcePowerSelected
    var x = i
    var presel = i
    var foundnext: Int32 = -1

    // Port-note: Raven wrote `!ps->fd.forcePowersKnown & (1 << x)`.
    // In C, negation has higher precedence than bitwise AND.
    // The port keeps that order per rule 2.
    let hasNoKnownPowers: Int32 = (ps.fd.forcePowersKnown == 0 ? 1 : 0) & (1 << x)
    if hasNoKnownPowers != 0 || x >= NUM_FORCE_POWERS || x == -1 {
        //apparently we have no valid force powers
        return
    }

    x = BG_ProperForceIndex(x)
    presel = x

    if direction == 1 {
        //get the next power
        x += 1
    } else {
        //get the previous power
        x -= 1
    }

    if x >= NUM_FORCE_POWERS {
        //cycled off the end.. cycle around to the first
        x = 0
    }
    if x < 0 {
        //cycled off the beginning.. cycle around to the last
        x = NUM_FORCE_POWERS - 1
    }

    i = forcePowerSorted[x] //the "sorted" value of this power

    while x != presel {
        //loop around to the current force power
        if (ps.fd.forcePowersKnown & (1 << i)) != 0 && i != ps.fd.forcePowerSelected {
            //we have the force power
            if i != FP_LEVITATION && i != FP_SABER_OFFENSE
                && i != FP_SABER_DEFENSE && i != FP_SABERTHROW {
                //it's selectable
                foundnext = i
                break
            }
        }

        if direction == 1 {
            //next
            x += 1
        } else {
            //previous
            x -= 1
        }

        if x >= NUM_FORCE_POWERS {
            //loop around
            x = 0
        }
        if x < 0 {
            //loop around
            x = NUM_FORCE_POWERS - 1
        }

        i = forcePowerSorted[x] //set to the sorted value again
    }

    if foundnext != -1 {
        //found one, select it
        ps.fd.forcePowerSelected = foundnext
    }
}

/// Source: oracle/codemp/game/bg_misc.c:2092
func BG_GetItemIndexByTag(_ tag: Int32, _ type: Int32) -> Int32 {
    //Get the itemlist index from the tag and type
    var i: Int32 = 0

    while i < bg_numItems {
        if bg_itemlist[i].giTag == tag && bg_itemlist[i].giType == type {
            return i
        }

        i += 1
    }

    return 0
}

//yeah..
/// Source: oracle/codemp/game/bg_misc.c:2111
func BG_IsItemSelectable(_ ps: JKAMP.PlayerState, _ item: Int32) -> Bool {
    if item == HI_HEALTHDISP || item == HI_AMMODISP || item == HI_JETPACK {
        return false
    }
    return true
}

/// Source: oracle/codemp/game/bg_misc.c:2121
func BG_CycleInven(_ ps: JKAMP.PlayerState, _ direction: Int32) {
    var i: Int32
    var dontFreeze: Int32 = 0
    var original: Int32

    i = bg_itemlist[ps.stats[STAT_HOLDABLE_ITEM]].giTag
    original = i

    if direction == 1 {
        //next
        i += 1
        if i == HI_NUM_HOLDABLE {
            i = 1
        }
    } else {
        //previous
        i -= 1
        if i == 0 {
            i = HI_NUM_HOLDABLE - 1
        }
    }

    while i != original {
        //go in a full loop until hitting something, if hit nothing then select nothing
        if (ps.stats[STAT_HOLDABLE_ITEMS] & (1 << i)) != 0 {
            //we have it, select it.
            if BG_IsItemSelectable(ps, i) {
                ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(i, IT_HOLDABLE)
                break
            }
        }

        if direction == 1 {
            //next
            i += 1
        } else {
            //previous
            i -= 1
        }

        if i <= 0 {
            //wrap around to the last
            i = HI_NUM_HOLDABLE - 1
        } else if i >= HI_NUM_HOLDABLE {
            //wrap around to the first
            i = 1
        }

        dontFreeze += 1
        if dontFreeze >= 32 {
            //yeah, sure, whatever (it's 2 am and I'm paranoid and can't frickin think)
            break
        }
    }
}

/**
```
================
BG_CanItemBeGrabbed

Returns false if the item should not be picked up.
This needs to be the same for client side prediction and server use.
================
```
*/
/// Source: oracle/codemp/game/bg_misc.c:2192
func BG_CanItemBeGrabbed(_ gametype: Int32, _ ent: JKAMP.EntityState, _ ps: JKAMP.PlayerState) -> Bool {
    let item: JKAMP.Gitem

    if ent.modelindex < 1 || ent.modelindex >= bg_numItems {
        Com_Error(ERR_DROP, "BG_CanItemBeGrabbed: index out of range")
    }

    item = bg_itemlist[ent.modelindex]

    // Raven guards a NULL ps here. The view is non-optional, so the guard has no Swift form.
    // Port-note: Raven's NULL path returns qfalse with the comment "safety return since below code assumes a non-null ps".
    if ps.trueJedi {
        //force powers and saber only
        if item.giType != IT_TEAM //not a flag
            && item.giType != IT_ARMOR //not shields
            && (item.giType != IT_WEAPON || item.giTag != WP_SABER) //not a saber
            && (item.giType != IT_HOLDABLE || item.giTag != HI_SEEKER) //not a seeker
            && (item.giType != IT_POWERUP || item.giTag == PW_YSALAMIRI) { //not a force pick-up
            return false
        }
    } else if ps.trueNonJedi {
        //can't pick up force powerups
        if (item.giType == IT_POWERUP && item.giTag != PW_YSALAMIRI) //if a powerup, can only can pick up ysalamiri
            || (item.giType == IT_HOLDABLE && item.giTag == HI_SEEKER) //if holdable, cannot pick up seeker
            || (item.giType == IT_WEAPON && item.giTag == WP_SABER) { //or if it's a saber
            return false
        }
    }
    // Port-note: Raven also tests `item` for NULL here. The view is non-optional, so that half of the guard has no Swift form.
    if ps.isJediMaster && (item.giType == IT_WEAPON || item.giType == IT_AMMO) {
        //jedi master cannot pick up weapons
        return false
    }
    if ps.duelInProgress {
        //no picking stuff up while in a duel, no matter what the type is
        return false
    }

    switch item.giType {
    case IT_WEAPON:
        if ent.generic1 == ps.clientNum && ent.powerups != 0 {
            return false
        }
        if (ent.eFlags & EF_DROPPEDWEAPON) == 0 && (ps.stats[STAT_WEAPONS] & (1 << item.giTag)) != 0
            && item.giTag != WP_THERMAL && item.giTag != WP_TRIP_MINE && item.giTag != WP_DET_PACK {
            //weaponstay stuff.. if this isn't dropped, and you already have it, you don't get it.
            return false
        }
        if item.giTag == WP_THERMAL || item.giTag == WP_TRIP_MINE || item.giTag == WP_DET_PACK {
            //check to see if full on ammo for this, if so, then..
            let ammoIndex = weaponData[item.giTag].ammoIndex
            if ps.ammo[ammoIndex] >= ammoData[ammoIndex].max {
                //don't need it
                return false
            }
        }
        return true	// weapons are always picked up

    case IT_AMMO:
        if item.giTag == -1 {
            //special case for "all ammo" packs
            return true
        }
        if ps.ammo[item.giTag] >= ammoData[item.giTag].max {
            return false		// can't hold any more
        }
        return true

    case IT_ARMOR:
        if ps.stats[STAT_ARMOR] >= ps.stats[STAT_MAX_HEALTH] /* * item->giTag*/ {
            return false
        }
        return true

    case IT_HEALTH:
        // small and mega healths will go over the max, otherwise
        // don't pick up if already at max
        if (ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
            return false
        }

        if item.quantity == 5 || item.quantity == 100 {
            if ps.stats[STAT_HEALTH] >= ps.stats[STAT_MAX_HEALTH] * 2 {
                return false
            }
            return true
        }

        if ps.stats[STAT_HEALTH] >= ps.stats[STAT_MAX_HEALTH] {
            return false
        }
        return true

    case IT_POWERUP:
        // Raven also tests `ps` for NULL here. The view is non-optional, so that half of the guard has no Swift form.
        if ps.powerups[PW_YSALAMIRI] != 0 {
            if item.giTag != PW_YSALAMIRI {
                return false
            }
        }
        return true	// powerups are always picked up

    case IT_TEAM: // team items, such as flags
        if gametype == GT_CTF || gametype == GT_CTY {
            // ent->modelindex2 is non-zero on items if they are dropped
            // we need to know this because we can pick up our dropped flag (and return it)
            // but we can't pick up our flag at base
            if ps.persistant[PERS_TEAM] == TEAM_RED {
                if item.giTag == PW_BLUEFLAG
                    || (item.giTag == PW_REDFLAG && ent.modelindex2 != 0)
                    || (item.giTag == PW_REDFLAG && ps.powerups[PW_BLUEFLAG] != 0) {
                    return true
                }
            } else if ps.persistant[PERS_TEAM] == TEAM_BLUE {
                if item.giTag == PW_REDFLAG
                    || (item.giTag == PW_BLUEFLAG && ent.modelindex2 != 0)
                    || (item.giTag == PW_BLUEFLAG && ps.powerups[PW_REDFLAG] != 0) {
                    return true
                }
            }
        }

        return false

    case IT_HOLDABLE:
        if (ps.stats[STAT_HOLDABLE_ITEMS] & (1 << item.giTag)) != 0 {
            return false
        }
        return true

    case IT_BAD:
        Com_Error(ERR_DROP, "BG_CanItemBeGrabbed: IT_BAD")
    default:
        Com_Printf("BG_CanItemBeGrabbed: unknown enum \(item.giType)\n")
    }

    return false
}

/**
```
================
BG_EvaluateTrajectory

================
```
*/
/// Source: oracle/codemp/game/bg_misc.c:2353
func BG_EvaluateTrajectory(_ tr: JKAShared.Trajectory, _ atTime: Int32, _ result: inout JKAShared.vec3_t) {
    var atTime = atTime
    var deltaTime: Float
    var phase: Float

    switch tr.trType {
    case TR_STATIONARY, TR_INTERPOLATE:
        result = tr.trBase
    case TR_LINEAR:
        // Raven's `0.001` is a double, so the product runs in double and rounds once into the float.
        deltaTime = Float(Double(atTime - tr.trTime) * 0.001)	// milliseconds to seconds
        _VectorMA(tr.trBase, deltaTime, tr.trDelta, &result)
    case TR_SINE:
        deltaTime = (atTime - tr.trTime) / Float(tr.trDuration)
        // M_PI is the double of math.h and sin is the double libm call, so the term runs in double and rounds once.
        phase = Float(sin(Double(deltaTime) * Double.pi * 2))
        _VectorMA(tr.trBase, phase, tr.trDelta, &result)
    case TR_LINEAR_STOP:
        if atTime > tr.trTime + tr.trDuration {
            atTime = tr.trTime + tr.trDuration
        }
        deltaTime = Float(Double(atTime - tr.trTime) * 0.001)	// milliseconds to seconds
        if deltaTime < 0 {
            deltaTime = 0
        }
        _VectorMA(tr.trBase, deltaTime, tr.trDelta, &result)
    case TR_NONLINEAR_STOP:
        if atTime > tr.trTime + tr.trDuration {
            atTime = tr.trTime + tr.trDuration
        }
        //new slow-down at end
        if atTime - tr.trTime > tr.trDuration || atTime - tr.trTime <= 0 {
            deltaTime = 0
        } else {
            //FIXME: maybe scale this somehow?  So that it starts out faster and stops faster?
            // Raven's DEG2RAD multiplies by the double M_PI and cos is the double libm call, so the angle runs in double.
            let degrees: Float = 90.0 - (90.0 * (Float(atTime) - tr.trTime) / Float(tr.trDuration))
            deltaTime = tr.trDuration * 0.001 * Float(cos(Double(degrees) * Double.pi / 180.0))
        }
        _VectorMA(tr.trBase, deltaTime, tr.trDelta, &result)
    case TR_GRAVITY:
        deltaTime = Float(Double(atTime - tr.trTime) * 0.001)	// milliseconds to seconds
        _VectorMA(tr.trBase, deltaTime, tr.trDelta, &result)
        // Raven's `0.5` is a double, so the whole term runs in double and rounds once into the float.
        result[2] -= Float(0.5 * Double(DEFAULT_GRAVITY) * Double(deltaTime) * Double(deltaTime))		// FIXME: local gravity...
    default:
        if bg.consumer == .game {
            Com_Error(ERR_DROP, "BG_EvaluateTrajectory: [GAME SIDE] unknown trType: \(tr.trType)")
        } else {
            Com_Error(ERR_DROP, "BG_EvaluateTrajectory: [CLIENTGAME SIDE] unknown trType: \(tr.trType)")
        }
    }
}

/**
```
================
BG_EvaluateTrajectoryDelta

For determining velocity at a given time
================
```
*/
/// Source: oracle/codemp/game/bg_misc.c:2419
func BG_EvaluateTrajectoryDelta(_ tr: JKAShared.Trajectory, _ atTime: Int32, _ result: inout JKAShared.vec3_t) {
    var deltaTime: Float
    var phase: Float

    switch tr.trType {
    case TR_STATIONARY, TR_INTERPOLATE:
        result = vec3_t(0, 0, 0)
    case TR_LINEAR:
        result = tr.trDelta
    case TR_SINE:
        deltaTime = (atTime - tr.trTime) / Float(tr.trDuration)
        // M_PI is the double of math.h and cos is the double libm call, so the term runs in double and rounds once.
        phase = Float(cos(Double(deltaTime) * Double.pi * 2))	// derivative of sin = cos
        phase *= 0.5
        _VectorScale(tr.trDelta, phase, &result)
    case TR_LINEAR_STOP:
        if atTime > tr.trTime + tr.trDuration {
            result = vec3_t(0, 0, 0)
            return
        }
        result = tr.trDelta
    case TR_NONLINEAR_STOP:
        if atTime - tr.trTime > tr.trDuration || atTime - tr.trTime <= 0 {
            result = vec3_t(0, 0, 0)
            return
        }
        // Raven's DEG2RAD multiplies by the double M_PI and cos is the double libm call, so the angle runs in double.
        let degrees: Float = 90.0 - (90.0 * (Float(atTime) - tr.trTime) / Float(tr.trDuration))
        deltaTime = tr.trDuration * 0.001 * Float(cos(Double(degrees) * Double.pi / 180.0))
        _VectorScale(tr.trDelta, deltaTime, &result)
    case TR_GRAVITY:
        // Raven's `0.001` is a double, so the product runs in double and rounds once into the float.
        deltaTime = Float(Double(atTime - tr.trTime) * 0.001)	// milliseconds to seconds
        result = tr.trDelta
        result[2] -= DEFAULT_GRAVITY * deltaTime		// FIXME: local gravity...
    default:
        // Raven passes `tr->trTime` to this message, not the trType.
        Com_Error(ERR_DROP, "BG_EvaluateTrajectoryDelta: unknown trType: \(tr.trTime)")
    }
}

/// Source: oracle/codemp/game/bg_misc.c:2635
func BG_AddPredictableEventToPlayerstate(_ newEvent: Int32, _ eventParm: Int32, _ ps: JKAMP.PlayerState) {
    ps.events[ps.eventSequence & (MAX_PS_EVENTS - 1)] = newEvent
    ps.eventParms[ps.eventSequence & (MAX_PS_EVENTS - 1)] = eventParm
    ps.eventSequence += 1
}

/**
```
========================
BG_TouchJumpPad
========================
```
*/
/// Source: oracle/codemp/game/bg_misc.c:2667
func BG_TouchJumpPad(_ ps: JKAMP.PlayerState, _ jumppad: JKAMP.EntityState) {
    // spectators don't use jump pads
    if ps.pm_type != PM_NORMAL && ps.pm_type != PM_JETPACK && ps.pm_type != PM_FLOAT {
        return
    }

    // if we didn't hit this same jumppad the previous frame
    // then don't play the event sound again if we are in a fat trigger
    if ps.jumppad_ent != jumppad.number {
        var angles = vec3_t()
        vectoangles(jumppad.origin2, &angles)
        let p = fabsf(AngleNormalize180(angles[PITCH]))
        // Port-note: `effectNum` was computed here in Raven's body and never used again, so it is dropped.
        _ = p < 45 ? 0 : 1
    }
    // remember hitting this jumppad this frame
    ps.jumppad_ent = jumppad.number
    ps.jumppad_frame = ps.pmove_framecount
    // give the player the velocity from the jumppad
    ps.velocity = jumppad.origin2
}

/**
```
=================
BG_EmplacedView

Shared code for emplaced angle gun constriction
=================
```
*/
/// Source: oracle/codemp/game/bg_misc.c:2703
func BG_EmplacedView(_ baseAngles: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t, _ newYaw: inout Float, _ constraint: Float) -> Int32 {
    var dif = AngleSubtract(baseAngles[YAW], angles[YAW])

    if dif > constraint || dif < -constraint {
        var amt: Float

        if dif > constraint {
            amt = (dif - constraint)
            dif = constraint
        } else if dif < -constraint {
            amt = (dif + constraint)
            dif = -constraint
        } else {
            amt = 0.0
        }

        newYaw = AngleSubtract(angles[YAW], -dif)

        if amt > 1.0 || amt < -1.0 {
            //significant, force the view
            return 2
        } else {
            //just a little out of range
            return 1
        }
    }

    return 0
}

//To see if the client is trying to use one of the included skins not meant for MP.
//I don't much care for hardcoded strings, but this seems the best way to go.
/// Source: oracle/codemp/game/bg_misc.c:2744
func BG_IsValidCharacterModel(_ modelName: String, _ skinName: String) -> Bool {
    if Q_stricmp(skinName, "menu") == 0 {
        return false
    } else if Q_stricmp(modelName, "kyle") == 0 {
        if Q_stricmp(skinName, "fpls") == 0 {
            return false
        } else if Q_stricmp(skinName, "fpls2") == 0 {
            return false
        } else if Q_stricmp(skinName, "fpls3") == 0 {
            return false
        }
    }
    return true
}

/// Source: oracle/codemp/game/bg_misc.c:2768
func BG_ValidateSkinForTeam(_ modelName: String, _ skinName: inout JKAShared.CharBuf, _ team: Int32, _ colors: inout JKAShared.vec3_t) -> Bool {
    if Q_stricmpn(modelName, "jedi_", 5) == 0 {
        //argh, it's a custom player skin!
        // Raven guards a NULL colors here. The parameter is an inout vector, so the guard has no Swift form.
        if team == TEAM_RED {
            colors[0] = 1.0
            colors[1] = 0.0
            colors[2] = 0.0
        } else if team == TEAM_BLUE {
            colors[0] = 0.0
            colors[1] = 0.0
            colors[2] = 1.0
        }
        return true
    }

    if team == TEAM_RED {
        if Q_stricmp("red", skinName) != 0 {
            //not "red"
            if Q_stricmp("blue", skinName) == 0
                || Q_stricmp("default", skinName) == 0
                || strchr(skinName, "|") != nil //a multi-skin playerModel
                || !BG_IsValidCharacterModel(modelName, String(skinName)) {
                Q_strncpyz(&skinName, "red", MAX_QPATH)
                return false
            } else {
                //need to set it to red
                let len = strlen(skinName)
                if len < 3 {
                    //too short to be "red"
                    Q_strcat(&skinName, MAX_QPATH, "_red")
                } else {
                    let start = len - 3
                    if Q_strncmp("red", skinName[start...], 3) != 0 {
                        //doesn't already end in "red"
                        if len + 4 >= MAX_QPATH {
                            //too big to append "_red"
                            Q_strncpyz(&skinName, "red", MAX_QPATH)
                            return false
                        } else {
                            Q_strcat(&skinName, MAX_QPATH, "_red")
                        }
                    }
                }
                //if file does not exist, set to "red"
                if !BG_FileExists(va("models/players/%s/model_%s.skin", modelName, skinName)) {
                    Q_strncpyz(&skinName, "red", MAX_QPATH)
                }
                return false
            }
        }

    } else if team == TEAM_BLUE {
        if Q_stricmp("blue", skinName) != 0 {
            if Q_stricmp("red", skinName) == 0
                || Q_stricmp("default", skinName) == 0
                || strchr(skinName, "|") != nil //a multi-skin playerModel
                || !BG_IsValidCharacterModel(modelName, String(skinName)) {
                Q_strncpyz(&skinName, "blue", MAX_QPATH)
                return false
            } else {
                //need to set it to blue
                let len = strlen(skinName)
                if len < 4 {
                    //too short to be "blue"
                    Q_strcat(&skinName, MAX_QPATH, "_blue")
                } else {
                    let start = len - 4
                    if Q_strncmp("blue", skinName[start...], 4) != 0 {
                        //doesn't already end in "blue"
                        if len + 5 >= MAX_QPATH {
                            //too big to append "_blue"
                            Q_strncpyz(&skinName, "blue", MAX_QPATH)
                            return false
                        } else {
                            Q_strcat(&skinName, MAX_QPATH, "_blue")
                        }
                    }
                }
                //if file does not exist, set to "blue"
                if !BG_FileExists(va("models/players/%s/model_%s.skin", modelName, skinName)) {
                    Q_strncpyz(&skinName, "blue", MAX_QPATH)
                }
                return false
            }
        }
    }
    return true
}

/**
```
========================
BG_PlayerStateToEntityState

This is done after each set of usercmd_t on the server,
and after local prediction on the client
========================
```
*/
/// Source: oracle/codemp/game/bg_misc.c:2887
func BG_PlayerStateToEntityState(_ ps: JKAMP.PlayerState, _ s: JKAMP.EntityState, _ snap: Bool) {
    if ps.pm_type == PM_INTERMISSION || ps.pm_type == PM_SPECTATOR {
        s.eType = ET_INVISIBLE
    } else if ps.stats[STAT_HEALTH] <= GIB_HEALTH {
        s.eType = ET_INVISIBLE
    } else {
        s.eType = ET_PLAYER
    }

    s.number = ps.clientNum

    s.pos.trType = TR_INTERPOLATE
    s.pos.trBase = ps.origin
    if snap {
        var base = s.pos.trBase
        SnapVector(&base)
        s.pos.trBase = base
    }
    // set the trDelta for flag direction
    s.pos.trDelta = ps.velocity

    s.apos.trType = TR_INTERPOLATE
    s.apos.trBase = ps.viewangles
    if snap {
        var base = s.apos.trBase
        SnapVector(&base)
        s.apos.trBase = base
    }

    s.trickedentindex = ps.fd.forceMindtrickTargetIndex
    s.trickedentindex2 = ps.fd.forceMindtrickTargetIndex2
    s.trickedentindex3 = ps.fd.forceMindtrickTargetIndex3
    s.trickedentindex4 = ps.fd.forceMindtrickTargetIndex4

    s.forceFrame = ps.saberLockFrame

    s.emplacedOwner = ps.electrifyTime

    s.speed = ps.speed

    s.genericenemyindex = ps.genericEnemyIndex

    s.activeForcePass = ps.activeForcePass

    s.angles2[YAW] = Float(ps.movementDir)
    s.legsAnim = ps.legsAnim
    s.torsoAnim = ps.torsoAnim

    s.legsFlip = ps.legsFlip
    s.torsoFlip = ps.torsoFlip

    s.clientNum = ps.clientNum		// ET_PLAYER looks here instead of at number
    // so corpses can also reference the proper config
    s.eFlags = ps.eFlags
    s.eFlags2 = ps.eFlags2

    s.saberInFlight = ps.saberInFlight
    s.saberEntityNum = ps.saberEntityNum
    s.saberMove = ps.saberMove
    s.forcePowersActive = ps.fd.forcePowersActive

    if ps.duelInProgress {
        s.bolt1 = 1
    } else {
        s.bolt1 = 0
    }

    s.otherEntityNum2 = ps.emplacedIndex

    s.saberHolstered = ps.saberHolstered

    if ps.genericEnemyIndex != -1 {
        s.eFlags |= EF_SEEKERDRONE
    }

    if ps.stats[STAT_HEALTH] <= 0 {
        s.eFlags |= EF_DEAD
    } else {
        s.eFlags &= ~EF_DEAD
    }

    if ps.externalEvent != 0 {
        s.event = ps.externalEvent
        s.eventParm = ps.externalEventParm
    } else if ps.entityEventSequence < ps.eventSequence {
        if ps.entityEventSequence < ps.eventSequence - MAX_PS_EVENTS {
            ps.entityEventSequence = ps.eventSequence - MAX_PS_EVENTS
        }
        let seq = ps.entityEventSequence & (MAX_PS_EVENTS - 1)
        s.event = ps.events[seq] | ((ps.entityEventSequence & 3) << 8)
        s.eventParm = ps.eventParms[seq]
        ps.entityEventSequence += 1
    }

    s.weapon = ps.weapon
    s.groundEntityNum = ps.groundEntityNum

    s.powerups = 0
    var i: Int32 = 0
    while i < MAX_POWERUPS {
        if ps.powerups[i] != 0 {
            s.powerups |= 1 << i
        }
        i += 1
    }

    s.loopSound = ps.loopSound
    s.generic1 = ps.generic1

    //NOT INCLUDED IN ENTITYSTATETOPLAYERSTATE:
    s.modelindex2 = ps.weaponstate
    s.constantLight = ps.weaponChargeTime

    s.origin2 = ps.lastHitLoc

    s.isJediMaster = ps.isJediMaster

    s.time2 = ps.holocronBits

    s.fireflag = ps.fd.saberAnimLevel

    s.heldByClient = ps.heldByClient
    s.ragAttach = ps.ragAttach

    s.iModelScale = ps.iModelScale

    s.brokenLimbs = ps.brokenLimbs

    s.hasLookTarget = ps.hasLookTarget
    s.lookTarget = ps.lookTarget

    s.customRGBA[0] = ps.customRGBA[0]
    s.customRGBA[1] = ps.customRGBA[1]
    s.customRGBA[2] = ps.customRGBA[2]
    s.customRGBA[3] = ps.customRGBA[3]

    s.m_iVehicleNum = ps.m_iVehicleNum
}

/**
```
========================
BG_PlayerStateToEntityStateExtraPolate

This is done after each set of usercmd_t on the server,
and after local prediction on the client
========================
```
*/
/// Source: oracle/codemp/game/bg_misc.c:3037
func BG_PlayerStateToEntityStateExtraPolate(_ ps: JKAMP.PlayerState, _ s: JKAMP.EntityState, _ time: Int32, _ snap: Bool) {
    if ps.pm_type == PM_INTERMISSION || ps.pm_type == PM_SPECTATOR {
        s.eType = ET_INVISIBLE
    } else if ps.stats[STAT_HEALTH] <= GIB_HEALTH {
        s.eType = ET_INVISIBLE
    } else {
        s.eType = ET_PLAYER
    }

    s.number = ps.clientNum

    s.pos.trType = TR_LINEAR_STOP
    s.pos.trBase = ps.origin
    if snap {
        var base = s.pos.trBase
        SnapVector(&base)
        s.pos.trBase = base
    }
    // set the trDelta for flag direction and linear prediction
    s.pos.trDelta = ps.velocity
    // set the time for linear prediction
    s.pos.trTime = time
    // set maximum extra polation time
    s.pos.trDuration = 50 // 1000 / sv_fps (default = 20)

    s.apos.trType = TR_INTERPOLATE
    s.apos.trBase = ps.viewangles
    if snap {
        var base = s.apos.trBase
        SnapVector(&base)
        s.apos.trBase = base
    }

    s.trickedentindex = ps.fd.forceMindtrickTargetIndex
    s.trickedentindex2 = ps.fd.forceMindtrickTargetIndex2
    s.trickedentindex3 = ps.fd.forceMindtrickTargetIndex3
    s.trickedentindex4 = ps.fd.forceMindtrickTargetIndex4

    s.forceFrame = ps.saberLockFrame

    s.emplacedOwner = ps.electrifyTime

    s.speed = ps.speed

    s.genericenemyindex = ps.genericEnemyIndex

    s.activeForcePass = ps.activeForcePass

    s.angles2[YAW] = Float(ps.movementDir)
    s.legsAnim = ps.legsAnim
    s.torsoAnim = ps.torsoAnim

    s.legsFlip = ps.legsFlip
    s.torsoFlip = ps.torsoFlip

    s.clientNum = ps.clientNum		// ET_PLAYER looks here instead of at number
    // so corpses can also reference the proper config
    s.eFlags = ps.eFlags
    s.eFlags2 = ps.eFlags2

    s.saberInFlight = ps.saberInFlight
    s.saberEntityNum = ps.saberEntityNum
    s.saberMove = ps.saberMove
    s.forcePowersActive = ps.fd.forcePowersActive

    if ps.duelInProgress {
        s.bolt1 = 1
    } else {
        s.bolt1 = 0
    }

    s.otherEntityNum2 = ps.emplacedIndex

    s.saberHolstered = ps.saberHolstered

    if ps.genericEnemyIndex != -1 {
        s.eFlags |= EF_SEEKERDRONE
    }

    if ps.stats[STAT_HEALTH] <= 0 {
        s.eFlags |= EF_DEAD
    } else {
        s.eFlags &= ~EF_DEAD
    }

    if ps.externalEvent != 0 {
        s.event = ps.externalEvent
        s.eventParm = ps.externalEventParm
    } else if ps.entityEventSequence < ps.eventSequence {
        if ps.entityEventSequence < ps.eventSequence - MAX_PS_EVENTS {
            ps.entityEventSequence = ps.eventSequence - MAX_PS_EVENTS
        }
        let seq = ps.entityEventSequence & (MAX_PS_EVENTS - 1)
        s.event = ps.events[seq] | ((ps.entityEventSequence & 3) << 8)
        s.eventParm = ps.eventParms[seq]
        ps.entityEventSequence += 1
    }

    s.weapon = ps.weapon
    s.groundEntityNum = ps.groundEntityNum

    s.powerups = 0
    var i: Int32 = 0
    while i < MAX_POWERUPS {
        if ps.powerups[i] != 0 {
            s.powerups |= 1 << i
        }
        i += 1
    }

    s.loopSound = ps.loopSound
    s.generic1 = ps.generic1

    //NOT INCLUDED IN ENTITYSTATETOPLAYERSTATE:
    s.modelindex2 = ps.weaponstate
    s.constantLight = ps.weaponChargeTime

    s.origin2 = ps.lastHitLoc

    s.isJediMaster = ps.isJediMaster

    s.time2 = ps.holocronBits

    s.fireflag = ps.fd.saberAnimLevel

    s.heldByClient = ps.heldByClient
    s.ragAttach = ps.ragAttach

    s.iModelScale = ps.iModelScale

    s.brokenLimbs = ps.brokenLimbs

    s.hasLookTarget = ps.hasLookTarget
    s.lookTarget = ps.lookTarget

    s.customRGBA[0] = ps.customRGBA[0]
    s.customRGBA[1] = ps.customRGBA[1]
    s.customRGBA[2] = ps.customRGBA[2]
    s.customRGBA[3] = ps.customRGBA[3]

    s.m_iVehicleNum = ps.m_iVehicleNum
}

/// Source: oracle/codemp/game/bg_misc.c:3200
func BG_ModelCache(_ modelName: String, _ skinName: String) -> Int32 {
    if bg.consumer == .game {
        var g2: OpaquePointer? = nil

        // Raven also tests `skinName` for NULL here. A String is never NULL, so that half of the guard has no Swift form.
        if !skinName.isEmpty {
            trap_R_RegisterSkin(skinName)
        }

        //I could hook up a precache ghoul2 function, but oh well, this works
        trap_G2API_InitGhoul2Model(&g2, modelName, 0, 0, 0, 0, 0)
        if g2 != nil { //now get rid of it
            trap_G2API_CleanGhoul2Models(&g2)
        }
        return 0
    } else {
        if !skinName.isEmpty {
            trap_R_RegisterSkin(skinName)
        }
        return trap_R_RegisterModel(modelName)
    }
}

/// Source: oracle/codemp/game/bg_misc.c:3312
// Raven wrote: #define MAX_POOL_SIZE 3000000
// A hand value: bg.maxPoolSize, the consumer's value under rule 23, which bg_local.swift forwards under Raven's name.

/// Source: oracle/codemp/game/bg_misc.c:3324
// Raven wrote: static char bg_pool[MAX_POOL_SIZE]
// A hand property of the state object, `bg.pool`, by the HAND_VARS ruling.

/// Source: oracle/codemp/game/bg_misc.c:3325
var bg_poolSize: Int32 {
    get { bg.variables.bg_poolSize }
    set { bg.variables.bg_poolSize = newValue }
}

/// Source: oracle/codemp/game/bg_misc.c:3326
var bg_poolTail: Int32 {
    get { bg.variables.bg_poolTail }
    set { bg.variables.bg_poolTail = newValue }
}

/// Source: oracle/codemp/game/bg_misc.c:3328
func BG_Alloc(_ size: Int32) -> UnsafeMutableRawPointer {
    // Raven wrote `0xfffffffc`, the same bit pattern as `~0x0000_0003` on an `Int32`.
    bg_poolSize = ((bg_poolSize + 0x0000_0003) & ~0x0000_0003)

    if bg_poolSize + size > bg_poolTail {
        // Raven writes `return 0` after this call, which `Com_Error` never reaches.
        Com_Error(ERR_DROP, "BG_Alloc: buffer exceeded tail (\(bg_poolSize + size) > \(bg_poolTail))")
    }

    bg_poolSize += size

    return bg.pool + (bg_poolSize - size)
}

/// Source: oracle/codemp/game/bg_misc.c:3343
func BG_AllocUnaligned(_ size: Int32) -> UnsafeMutableRawPointer {
    if bg_poolSize + size > bg_poolTail {
        // Raven writes `return 0` after this call, which `Com_Error` never reaches.
        Com_Error(ERR_DROP, "BG_AllocUnaligned: buffer exceeded tail (\(bg_poolSize + size) > \(bg_poolTail))")
    }

    bg_poolSize += size

    return bg.pool + (bg_poolSize - size)
}

/// Source: oracle/codemp/game/bg_misc.c:3356
func BG_TempAlloc(_ size: Int32) -> UnsafeMutableRawPointer {
    // Raven wrote `0xfffffffc`, the same bit pattern as `~0x0000_0003` on an `Int32`.
    var size = size
    size = ((size + 0x0000_0003) & ~0x0000_0003)

    if bg_poolTail - size < bg_poolSize {
        // Raven writes `return 0` after this call, which `Com_Error` never reaches.
        Com_Error(ERR_DROP, "BG_TempAlloc: buffer exceeded head (\(bg_poolTail - size) > \(bg_poolSize))")
    }

    bg_poolTail -= size

    return bg.pool + bg_poolTail
}

/// Source: oracle/codemp/game/bg_misc.c:3371
func BG_TempFree(_ size: Int32) {
    // Raven wrote `0xfffffffc`, the same bit pattern as `~0x0000_0003` on an `Int32`.
    var size = size
    size = ((size + 0x0000_0003) & ~0x0000_0003)

    if bg_poolTail + size > MAX_POOL_SIZE {
        Com_Error(ERR_DROP, "BG_TempFree: tail greater than size (\(bg_poolTail + size) > \(MAX_POOL_SIZE))")
    }

    bg_poolTail += size
}

/// Source: oracle/codemp/game/bg_misc.c:3383
func BG_StringAlloc(_ source: String) -> PooledString {
    let dest: UnsafeMutableRawPointer

    dest = BG_Alloc(strlen(source) + 1)
    strcpy(dest, source)
    return PooledString(dest)
}

/// Source: oracle/codemp/game/bg_misc.c:3392
func BG_OutOfMemory() -> Bool {
    return bg_poolSize >= MAX_POOL_SIZE
}
