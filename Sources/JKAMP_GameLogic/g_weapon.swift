import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_weapon.c:12
var s_quadFactor: Float {
    get { world.variables.s_quadFactor }
    set { world.variables.s_quadFactor = newValue }
}

/// Source: oracle/codemp/game/g_weapon.c:13
var forward: JKAShared.vec3_t {
    get { world.variables.forward }
    set { world.variables.forward = newValue }
}

/// Source: oracle/codemp/game/g_weapon.c:13
var vright: JKAShared.vec3_t {
    get { world.variables.vright }
    set { world.variables.vright = newValue }
}

/// Source: oracle/codemp/game/g_weapon.c:13
var up: JKAShared.vec3_t {
    get { world.variables.up }
    set { world.variables.up = newValue }
}

/// Source: oracle/codemp/game/g_weapon.c:14
var muzzle: JKAShared.vec3_t {
    get { world.variables.muzzle }
    set { world.variables.muzzle = newValue }
}

/// Source: oracle/codemp/game/g_weapon.c:18
let BRYAR_PISTOL_VEL = 1600 as Int32

/// Source: oracle/codemp/game/g_weapon.c:19
let BRYAR_PISTOL_DAMAGE = 10 as Int32

/// Source: oracle/codemp/game/g_weapon.c:20
private let BRYAR_CHARGE_UNIT = 200.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:21
let BRYAR_ALT_SIZE = 1.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:25
let BLASTER_SPREAD = 1.6 as Float

/// Source: oracle/codemp/game/g_weapon.c:26
let BLASTER_VELOCITY = 2300 as Int32

/// Source: oracle/codemp/game/g_weapon.c:27
let BLASTER_DAMAGE = 20 as Int32

/// Source: oracle/codemp/game/g_weapon.c:31
let DISRUPTOR_MAIN_DAMAGE = 30 as Int32

/// Source: oracle/codemp/game/g_weapon.c:32
let DISRUPTOR_MAIN_DAMAGE_SIEGE = 50 as Int32

/// Source: oracle/codemp/game/g_weapon.c:33
let DISRUPTOR_NPC_MAIN_DAMAGE_CUT = 0.25 as Float

/// Source: oracle/codemp/game/g_weapon.c:35
let DISRUPTOR_ALT_DAMAGE = 100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:36
let DISRUPTOR_NPC_ALT_DAMAGE_CUT = 0.2 as Float

/// Source: oracle/codemp/game/g_weapon.c:37
let DISRUPTOR_ALT_TRACES = 3 as Int32

/// Source: oracle/codemp/game/g_weapon.c:38
let DISRUPTOR_CHARGE_UNIT = 50.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:42
let BOWCASTER_DAMAGE = 50 as Int32

/// Source: oracle/codemp/game/g_weapon.c:43
private let BOWCASTER_VELOCITY = 1300 as Int32

/// Source: oracle/codemp/game/g_weapon.c:44
private let BOWCASTER_SPLASH_DAMAGE = 0 as Int32

/// Source: oracle/codemp/game/g_weapon.c:45
private let BOWCASTER_SPLASH_RADIUS = 0 as Int32

/// Source: oracle/codemp/game/g_weapon.c:46
private let BOWCASTER_SIZE = 2 as Int32

/// Source: oracle/codemp/game/g_weapon.c:48
let BOWCASTER_ALT_SPREAD = 5.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:49
let BOWCASTER_VEL_RANGE = 0.3 as Float

/// Source: oracle/codemp/game/g_weapon.c:50
private let BOWCASTER_CHARGE_UNIT = 200.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:54
let REPEATER_SPREAD = 1.4 as Float

/// Source: oracle/codemp/game/g_weapon.c:55
let REPEATER_DAMAGE = 14 as Int32

/// Source: oracle/codemp/game/g_weapon.c:56
let REPEATER_VELOCITY = 1600 as Int32

/// Source: oracle/codemp/game/g_weapon.c:58
private let REPEATER_ALT_SIZE = 3 as Int32

/// Source: oracle/codemp/game/g_weapon.c:59
let REPEATER_ALT_DAMAGE = 60 as Int32

/// Source: oracle/codemp/game/g_weapon.c:60
let REPEATER_ALT_SPLASH_DAMAGE = 60 as Int32

/// Source: oracle/codemp/game/g_weapon.c:61
let REPEATER_ALT_SPLASH_RADIUS = 128 as Int32

/// Source: oracle/codemp/game/g_weapon.c:62
let REPEATER_ALT_SPLASH_RAD_SIEGE = 80 as Int32

/// Source: oracle/codemp/game/g_weapon.c:63
let REPEATER_ALT_VELOCITY = 1100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:67
let DEMP2_DAMAGE = 35 as Int32

/// Source: oracle/codemp/game/g_weapon.c:68
let DEMP2_VELOCITY = 1800 as Int32

/// Source: oracle/codemp/game/g_weapon.c:69
let DEMP2_SIZE = 2 as Int32

/// Source: oracle/codemp/game/g_weapon.c:71
let DEMP2_ALT_DAMAGE = 8 as Int32

/// Source: oracle/codemp/game/g_weapon.c:72
let DEMP2_CHARGE_UNIT = 700.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:73
let DEMP2_ALT_RANGE = 4096 as Int32

/// Source: oracle/codemp/game/g_weapon.c:74
let DEMP2_ALT_SPLASHRADIUS = 256 as Int32

/// Source: oracle/codemp/game/g_weapon.c:78
let FLECHETTE_SHOTS = 5 as Int32

/// Source: oracle/codemp/game/g_weapon.c:79
let FLECHETTE_SPREAD = 4.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:80
let FLECHETTE_DAMAGE = 12 as Int32

/// Source: oracle/codemp/game/g_weapon.c:81
let FLECHETTE_VEL = 3500 as Int32

/// Source: oracle/codemp/game/g_weapon.c:82
let FLECHETTE_SIZE = 1 as Int32

/// Source: oracle/codemp/game/g_weapon.c:83
let FLECHETTE_MINE_RADIUS_CHECK = 256 as Int32

/// Source: oracle/codemp/game/g_weapon.c:84
let FLECHETTE_ALT_DAMAGE = 60 as Int32

/// Source: oracle/codemp/game/g_weapon.c:85
let FLECHETTE_ALT_SPLASH_DAM = 60 as Int32

/// Source: oracle/codemp/game/g_weapon.c:86
let FLECHETTE_ALT_SPLASH_RAD = 128 as Int32

/// Source: oracle/codemp/game/g_weapon.c:90
let ROCKET_VELOCITY = 900 as Int32

/// Source: oracle/codemp/game/g_weapon.c:91
let ROCKET_DAMAGE = 100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:92
let ROCKET_SPLASH_DAMAGE = 100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:93
let ROCKET_SPLASH_RADIUS = 160 as Int32

/// Source: oracle/codemp/game/g_weapon.c:94
let ROCKET_SIZE = 3 as Int32

/// Source: oracle/codemp/game/g_weapon.c:95
let ROCKET_ALT_THINK_TIME = 100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:102
let CONC_VELOCITY = 3000 as Int32

/// Source: oracle/codemp/game/g_weapon.c:103
let CONC_DAMAGE = 75 as Int32

/// Source: oracle/codemp/game/g_weapon.c:104
let CONC_NPC_DAMAGE_EASY = 40 as Int32

/// Source: oracle/codemp/game/g_weapon.c:105
let CONC_NPC_DAMAGE_NORMAL = 80 as Int32

/// Source: oracle/codemp/game/g_weapon.c:106
let CONC_NPC_DAMAGE_HARD = 100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:107
let CONC_SPLASH_DAMAGE = 40 as Int32

/// Source: oracle/codemp/game/g_weapon.c:108
let CONC_SPLASH_RADIUS = 200 as Int32

/// Source: oracle/codemp/game/g_weapon.c:110
let CONC_ALT_DAMAGE = 25 as Int32

/// Source: oracle/codemp/game/g_weapon.c:111
let CONC_ALT_NPC_DAMAGE_EASY = 20 as Int32

/// Source: oracle/codemp/game/g_weapon.c:112
let CONC_ALT_NPC_DAMAGE_MEDIUM = 35 as Int32

/// Source: oracle/codemp/game/g_weapon.c:113
let CONC_ALT_NPC_DAMAGE_HARD = 50 as Int32

/// Source: oracle/codemp/game/g_weapon.c:117
let STUN_BATON_DAMAGE = 20 as Int32

/// Source: oracle/codemp/game/g_weapon.c:118
let STUN_BATON_ALT_DAMAGE = 20 as Int32

/// Source: oracle/codemp/game/g_weapon.c:119
let STUN_BATON_RANGE = 8 as Int32

/// Source: oracle/codemp/game/g_weapon.c:123
let MELEE_SWING1_DAMAGE = 10 as Int32

/// Source: oracle/codemp/game/g_weapon.c:124
let MELEE_SWING2_DAMAGE = 12 as Int32

/// Source: oracle/codemp/game/g_weapon.c:125
let MELEE_RANGE = 8 as Int32

/// Source: oracle/codemp/game/g_weapon.c:129
let ATST_MAIN_VEL = 4000 as Int32

/// Source: oracle/codemp/game/g_weapon.c:130
let ATST_MAIN_DAMAGE = 25 as Int32

/// Source: oracle/codemp/game/g_weapon.c:131
let ATST_MAIN_SIZE = 3 as Int32

/// Source: oracle/codemp/game/g_weapon.c:135
let ATST_SIDE_MAIN_DAMAGE = 75 as Int32

/// Source: oracle/codemp/game/g_weapon.c:136
let ATST_SIDE_MAIN_VELOCITY = 1300 as Int32

/// Source: oracle/codemp/game/g_weapon.c:137
let ATST_SIDE_MAIN_NPC_DAMAGE_EASY = 30 as Int32

/// Source: oracle/codemp/game/g_weapon.c:138
let ATST_SIDE_MAIN_NPC_DAMAGE_NORMAL = 40 as Int32

/// Source: oracle/codemp/game/g_weapon.c:139
let ATST_SIDE_MAIN_NPC_DAMAGE_HARD = 50 as Int32

/// Source: oracle/codemp/game/g_weapon.c:140
let ATST_SIDE_MAIN_SIZE = 4 as Int32

/// Source: oracle/codemp/game/g_weapon.c:141
let ATST_SIDE_MAIN_SPLASH_DAMAGE = 10 as Int32

/// Source: oracle/codemp/game/g_weapon.c:142
let ATST_SIDE_MAIN_SPLASH_RADIUS = 16 as Int32

/// Source: oracle/codemp/game/g_weapon.c:144
let ATST_SIDE_ALT_VELOCITY = 1100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:145
let ATST_SIDE_ALT_NPC_VELOCITY = 600 as Int32

/// Source: oracle/codemp/game/g_weapon.c:146
let ATST_SIDE_ALT_DAMAGE = 130 as Int32

/// Source: oracle/codemp/game/g_weapon.c:148
let ATST_SIDE_ROCKET_NPC_DAMAGE_EASY = 30 as Int32

/// Source: oracle/codemp/game/g_weapon.c:149
let ATST_SIDE_ROCKET_NPC_DAMAGE_NORMAL = 50 as Int32

/// Source: oracle/codemp/game/g_weapon.c:150
let ATST_SIDE_ROCKET_NPC_DAMAGE_HARD = 90 as Int32

/// Source: oracle/codemp/game/g_weapon.c:152
let ATST_SIDE_ALT_SPLASH_DAMAGE = 130 as Int32

/// Source: oracle/codemp/game/g_weapon.c:153
let ATST_SIDE_ALT_SPLASH_RADIUS = 200 as Int32

/// Source: oracle/codemp/game/g_weapon.c:154
let ATST_SIDE_ALT_ROCKET_SIZE = 5 as Int32

/// Source: oracle/codemp/game/g_weapon.c:155
let ATST_SIDE_ALT_ROCKET_SPLASH_SCALE = 0.5 as Float

/// Source: oracle/codemp/game/g_weapon.c:1162
var ent_list: Slots<Entity?> { world.storage.ent_list }

/// Source: oracle/codemp/game/g_weapon.c:1918
let TD_DAMAGE = 70 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1919
let TD_SPLASH_RAD = 128 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1920
let TD_SPLASH_DAM = 90 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1921
let TD_VELOCITY = 900 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1922
let TD_MIN_CHARGE = 0.15 as Float

/// Source: oracle/codemp/game/g_weapon.c:1923
let TD_TIME = 3000 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1924
let TD_ALT_TIME = 3000 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1926
let TD_ALT_DAMAGE = 60 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1927
let TD_ALT_SPLASH_RAD = 128 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1928
let TD_ALT_SPLASH_DAM = 50 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1929
let TD_ALT_VELOCITY = 600 as Int32

/// Source: oracle/codemp/game/g_weapon.c:1930
let TD_ALT_MIN_CHARGE = 0.15 as Float

/// Source: oracle/codemp/game/g_weapon.c:2235
let LT_DAMAGE = 100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:2236
let LT_SPLASH_RAD = 256.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:2237
let LT_SPLASH_DAM = 105 as Int32

/// Source: oracle/codemp/game/g_weapon.c:2238
let LT_VELOCITY = 900.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:2239
let LT_SIZE = 1.5 as Float

/// Source: oracle/codemp/game/g_weapon.c:2240
let LT_ALT_TIME = 2000 as Int32

/// Source: oracle/codemp/game/g_weapon.c:2241
let LT_ACTIVATION_DELAY = 1000 as Int32

/// Source: oracle/codemp/game/g_weapon.c:2242
let LT_DELAY_TIME = 50 as Int32

/// Source: oracle/codemp/game/g_weapon.c:3627
let VEH_HOMING_MISSILE_THINK_TIME = 100 as Int32

/// Source: oracle/codemp/game/g_weapon.c:4049
private let MAX_XHAIR_DIST_ACCURACY = 20000.0 as Float

/// Source: oracle/codemp/game/g_weapon.c:4662
let EMPLACED_CANRESPAWN = 1 as Int32

/// Source: oracle/codemp/game/g_weapon.c:4825
let EMPLACED_GUN_HEALTH = 800 as Int32

/// Source: oracle/codemp/game/g_weapon.c:165
func touch_NULL(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
}

//We should really organize weapon data into tables or parse from the ext data so we have accurate info for this,
/// Source: oracle/codemp/game/g_weapon.c:176
func WP_SpeedOfMissileForWeapon(_ wp: Int32, _ alt_fire: Bool) -> Float {
    return 500
}

//-----------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:182
func W_TraceSetStart(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) {
    //make sure our start point isn't on the other side of a wall
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var entMins = vec3_t()
        var entMaxs = vec3_t()
        var eyePoint = vec3_t()

        entMins = ent.r.currentOrigin + ent.r.mins
        entMaxs = ent.r.currentOrigin + ent.r.maxs

        if G_BoxInBounds(start, mins, maxs, entMins, entMaxs) {
            return true
        }

        if ent.client == nil {
            return true
        }

        eyePoint = ent.s.pos.trBase
        eyePoint[2] += ent.client!.ps.viewheight

        trap_Trace(tr, eyePoint, mins, maxs, start, ent.s.number, MASK_SOLID | CONTENTS_SHOTCLIP)

        if tr.startsolid != 0 || tr.allsolid != 0 {
            return true
        }

        if tr.fraction < 1.0 {
            start = tr.endpos
        }
        return false
    }
    if earlyOut {
        return
    }
}

//----------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:236
private func WP_FireBryarPistol(_ ent: Entity, _ altFire: Bool) {
    var damage: Int32 = BRYAR_PISTOL_DAMAGE
    var count: Int32

    let missile: Entity? = CreateMissile(&muzzle, forward, Float(BRYAR_PISTOL_VEL), 10000, ent, altFire)

    missile!.classname = "bryar_proj"
    missile!.s.weapon = WP_BRYAR_PISTOL

    if altFire {
        var boxSize: Float = 0

        count = Int32((level.time - ent.client!.ps.weaponChargeTime) / BRYAR_CHARGE_UNIT)

        if count < 1 {
            count = 1
        } else if count > 5 {
            count = 5
        }

        if count > 1 {
            damage = Int32(Double(damage) * (Double(count) * 1.7))
        } else {
            damage = Int32(Double(damage) * (Double(count) * 1.5))
        }

        missile!.s.generic1 = count // The missile will then render according to the charge level.

        boxSize = Float(Double(BRYAR_ALT_SIZE) * (Double(count) * 0.5))

        missile!.r.maxs = vec3_t(boxSize, boxSize, boxSize)
        missile!.r.mins = vec3_t(-boxSize, -boxSize, -boxSize)
    }

    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    if altFire {
        missile!.methodOfDeath = MOD_BRYAR_PISTOL_ALT
    } else {
        missile!.methodOfDeath = MOD_BRYAR_PISTOL
    }
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

    // we don't want it to bounce forever
    missile!.bounceCount = 8
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:304
func WP_FireTurretMissile(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ altFire: Bool, _ damage: Int32, _ velocity: Int32, _ mod: Int32, _ ignore: Entity) {
    var missile: Entity?

    missile = CreateMissile(&start, dir, Float(velocity), 10000, ent, altFire)

    missile!.classname = "generic_proj"
    missile!.s.weapon = WP_TURRET

    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = mod
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

    missile!.passThroughNum = ignore.s.number + 1

    // we don't want it to bounce forever
    missile!.bounceCount = 8
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:331
func WP_FireGenericBlasterMissile(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ altFire: Bool, _ damage: Int32, _ velocity: Int32, _ mod: Int32) {
    var missile: Entity?

    missile = CreateMissile(&start, dir, Float(velocity), 10000, ent, altFire)

    missile!.classname = "generic_proj"
    missile!.s.weapon = WP_BRYAR_PISTOL

    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = mod
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

    // we don't want it to bounce forever
    missile!.bounceCount = 8
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:359
func WP_FireBlasterMissile(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ altFire: Bool) {
    let velocity: Int32 = BLASTER_VELOCITY
    var damage: Int32 = BLASTER_DAMAGE
    var missile: Entity?

    if ent.s.eType == ET_NPC {
        //animent
        damage = 10
    }

    missile = CreateMissile(&start, dir, Float(velocity), 10000, ent, altFire)

    missile!.classname = "blaster_proj"
    missile!.s.weapon = WP_BLASTER

    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = MOD_BLASTER
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

    // we don't want it to bounce forever
    missile!.bounceCount = 8
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:386
func WP_FireTurboLaserMissile(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ dir: JKAShared.vec3_t) {
    let velocity: Int32 = Int32(ent.mass)
    var missile: Entity?

    missile = CreateMissile(&start, dir, Float(velocity), 10000, ent, false)

    //use a custom shot effect
    missile!.s.otherEntityNum2 = ent.genericValue14
    //use a custom impact effect
    missile!.s.emplacedOwner = ent.genericValue15

    missile!.classname = "turbo_proj"
    missile!.s.weapon = WP_TURRET

    missile!.damage = ent.damage //FIXME: externalize
    missile!.splashDamage = ent.splashDamage //FIXME: externalize
    missile!.splashRadius = ent.splashRadius //FIXME: externalize
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = MOD_TARGET_LASER //MOD_TURBLAST; //count as a heavy weap
    missile!.splashMethodOfDeath = MOD_TARGET_LASER //MOD_TURBLAST;// ?SPLASH;
    missile!.clipmask = MASK_SHOT

    // we don't want it to bounce forever
    missile!.bounceCount = 8

    //set veh as cgame side owner for purpose of fx overrides
    missile!.s.owner = ent.s.number

    //don't let them last forever
    missile!.think = Think.G_FreeEntity
    missile!.nextthink = level.time + 5000 //at 20000 speed, that should be more than enough
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:422
func WP_FireEmplacedMissile(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ altFire: Bool, _ ignore: Entity) {
    let velocity: Int32 = BLASTER_VELOCITY
    let damage: Int32 = BLASTER_DAMAGE
    var missile: Entity?

    missile = CreateMissile(&start, dir, Float(velocity), 10000, ent, altFire)

    missile!.classname = "emplaced_gun_proj"
    missile!.s.weapon = WP_TURRET //WP_EMPLACED_GUN;

    missile!.activator = ignore

    missile!.damage = damage
    missile!.dflags = (DAMAGE_DEATH_KNOCKBACK | DAMAGE_HEAVY_WEAP_CLASS)
    missile!.methodOfDeath = MOD_VEHICLE
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

    missile!.passThroughNum = ignore.s.number + 1

    // we don't want it to bounce forever
    missile!.bounceCount = 8
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:451
private func WP_FireBlaster(_ ent: Entity, _ altFire: Bool) {
    var dir = vec3_t()
    var angs = vec3_t()

    vectoangles(forward, &angs)

    if altFire {
        // add some slop to the alt-fire direction
        angs[PITCH] += crandom() * BLASTER_SPREAD
        angs[YAW] += crandom() * BLASTER_SPREAD
    }

    // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
    var scratchRight = vec3_t()
    // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
    var scratchUp = vec3_t()
    AngleVectors(angs, &dir, &scratchRight, &scratchUp)

    // FIXME: if temp_org does not have clear trace to inside the bbox, don't shoot!
    WP_FireBlasterMissile(ent, &muzzle, dir, altFire)
}

/**
```
======================================================================

DISRUPTOR

======================================================================
```
*/
//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:483
private func WP_DisruptorMainFire(_ ent: Entity) {
    var damage: Int32 = DISRUPTOR_MAIN_DAMAGE
    var render_impact: Bool = true
    var start = vec3_t()
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var traceEnt: Entity?
        var tent: Entity?
        let shotRange: Float = 8192
        var ignore: Int32 = 0
        var traces: Int32 = 0

        if g_gametype.integer == GT_SIEGE {
            damage = DISRUPTOR_MAIN_DAMAGE_SIEGE
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        start = ent.client!.ps.origin
        start[2] += ent.client!.ps.viewheight //By eyes

        _VectorMA(start, shotRange, forward, &end)

        ignore = ent.s.number
        traces = 0
        while traces < 10 {
            //need to loop this in case we hit a Jedi who dodges the shot
            if d_projectileGhoul2Collision.integer != 0 {
                // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                portMissing("WP_DisruptorMainFire", source: "oracle/codemp/game/g_weapon.c:483")
                // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                portMissing("WP_DisruptorMainFire", source: "oracle/codemp/game/g_weapon.c:483")
                trap_G2Trace(tr, start, vec3_origin, vec3_origin, end, ignore, MASK_SHOT, G2TRFLAG_DOGHOULTRACE | G2TRFLAG_GETSURFINDEX | G2TRFLAG_THICK | G2TRFLAG_HITCORPSES, g_g2TraceLod.integer)
            } else {
                // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                portMissing("WP_DisruptorMainFire", source: "oracle/codemp/game/g_weapon.c:483")
                // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                portMissing("WP_DisruptorMainFire", source: "oracle/codemp/game/g_weapon.c:483")
                trap_Trace(tr, start, vec3_origin, vec3_origin, end, ignore, MASK_SHOT)
            }

            traceEnt = g_entities[tr.entityNum]

            if d_projectileGhoul2Collision.integer != 0 && traceEnt!.inuse && traceEnt!.client != nil {
                //g2 collision checks -rww
                if traceEnt!.inuse && traceEnt!.client != nil && traceEnt!.ghoul2 != nil {
                    //since we used G2TRFLAG_GETSURFINDEX, tr.surfaceFlags will actually contain the index of the surface on the ghoul2 model we collided with.
                    traceEnt!.client!.g2LastSurfaceHit = tr.surfaceFlags
                    traceEnt!.client!.g2LastSurfaceTime = level.time
                }

                if traceEnt!.ghoul2 != nil {
                    tr.surfaceFlags = 0 //clear the surface flags after, since we actually care about them in here.
                }
            }

            if traceEnt != nil && traceEnt!.client != nil && traceEnt!.client!.ps.duelInProgress && traceEnt!.client!.ps.duelIndex != ent.s.number {
                start = tr.endpos
                ignore = tr.entityNum
                traces += 1
                continue
            }

            if Jedi_DodgeEvasion(traceEnt!, ent, tr, G_GetHitLocation(traceEnt!, tr.endpos)) {
                //act like we didn't even hit him
                start = tr.endpos
                ignore = tr.entityNum
                traces += 1
                continue
            } else if traceEnt != nil && traceEnt!.client != nil && traceEnt!.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] >= FORCE_LEVEL_3 {
                if WP_SaberCanBlock(traceEnt!, tr.endpos, 0, MOD_DISRUPTOR, true, 0) != 0 {
                    //broadcast and stop the shot because it was blocked
                    var te: Entity? = nil

                    tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_MAIN_SHOT)
                    tent!.s.origin2 = muzzle
                    tent!.s.eventParm = ent.s.number

                    te = G_TempEntity(tr.endpos, EV_SABER_BLOCK)
                    te!.s.origin = tr.endpos
                    te!.s.angles = tr.plane.normal
                    if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
                        te!.s.angles[1] = 1
                    }
                    te!.s.eventParm = 0
                    te!.s.weapon = 0 //saberNum
                    te!.s.legsAnim = 0 //bladeNum

                    return true
                }
            } else if (traceEnt!.flags & FL_SHIELDED) != 0 {
                //stopped cold
                return true
            }
            //a Jedi is not dodging this shot
            break
        }

        if (tr.surfaceFlags & SURF_NOIMPACT) != 0 {
            render_impact = false
        }

        // always render a shot beam, doing this the old way because I don't much feel like overriding the effect.
        tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_MAIN_SHOT)
        tent!.s.origin2 = muzzle
        tent!.s.eventParm = ent.s.number

        traceEnt = g_entities[tr.entityNum]

        if render_impact {
            if tr.entityNum < ENTITYNUM_WORLD && traceEnt!.takedamage {
                if traceEnt!.client != nil && LogAccuracyHit(traceEnt!, ent) {
                    ent.client!.accuracy_hits += 1
                }

                G_Damage(traceEnt!, ent, ent, &forward, tr.endpos, damage, DAMAGE_NORMAL, MOD_DISRUPTOR)

                tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_HIT)
                tent!.s.eventParm = DirToByte(tr.plane.normal)
                if traceEnt!.client != nil {
                    tent!.s.weapon = 1
                }
            } else {
                // Hmmm, maybe don't make any marks on things that could break
                tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_SNIPER_MISS)
                tent!.s.eventParm = DirToByte(tr.plane.normal)
                tent!.s.weapon = 1
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_weapon.c:624
func G_CanDisruptify(_ ent: Entity) -> Bool {
    if !ent.inuse || ent.client == nil || ent.s.eType != ET_NPC || ent.s.NPC_class != CLASS_VEHICLE || ent.m_pVehicle == nil {
        //not vehicle
        return true
    }

    if ent.m_pVehicle!.m_pVehicleInfo!.type == VH_ANIMAL {
        //animal is only type that can be disintigeiteigerated
        return true
    }

    //don't do it to any other veh
    return false
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:642
func WP_DisruptorAltFire(_ ent: Entity) {
    var damage: Int32 = 0
    var skip: Int32 = 0
    var render_impact: Bool = true
    var start = vec3_t()
    var end = vec3_t()
    var muzzle2 = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var traceEnt: Entity?
        var tent: Entity?
        let shotRange: Float = 8192.0
        var i: Int32 = 0
        var count: Int32 = 0
        var maxCount: Int32 = 60
        var traces: Int32 = DISRUPTOR_ALT_TRACES
        var fullCharge: Bool = false

        damage = DISRUPTOR_ALT_DAMAGE - 30

        muzzle2 = muzzle // making a backup copy

        if ent.client != nil {
            start = ent.client!.ps.origin
            start[2] += ent.client!.ps.viewheight //By eyes

            count = Int32((level.time - ent.client!.ps.weaponChargeTime) / DISRUPTOR_CHARGE_UNIT)
            if g_gametype.integer == GT_SIEGE {
                //maybe a full alt-charge should be a *bit* more dangerous in Siege mode?
                //maxCount = ceil((200.0f-(float)damage)/2.0f);//cap at 200 damage total
                maxCount = 200 //the previous line ALWAYS evaluated to 135 - was that on purpose?
            }
        } else {
            start = ent.r.currentOrigin
            start[2] += 24

            count = Int32((100) / DISRUPTOR_CHARGE_UNIT)
        }

        count *= 2

        if count < 1 {
            count = 1
        } else if count >= maxCount {
            count = maxCount
            fullCharge = true
        }

        // more powerful charges go through more things
        if count < 10 {
            traces = 1
        } else if count < 20 {
            traces = 2
        }

        damage += count

        skip = ent.s.number

        i = 0
        while i < traces {
            _VectorMA(start, shotRange, forward, &end)

            if d_projectileGhoul2Collision.integer != 0 {
                // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                portMissing("WP_DisruptorAltFire", source: "oracle/codemp/game/g_weapon.c:642")
                // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                portMissing("WP_DisruptorAltFire", source: "oracle/codemp/game/g_weapon.c:642")
                trap_G2Trace(tr, start, vec3_origin, vec3_origin, end, skip, MASK_SHOT, G2TRFLAG_DOGHOULTRACE | G2TRFLAG_GETSURFINDEX | G2TRFLAG_THICK | G2TRFLAG_HITCORPSES, g_g2TraceLod.integer)
            } else {
                // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                portMissing("WP_DisruptorAltFire", source: "oracle/codemp/game/g_weapon.c:642")
                // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                portMissing("WP_DisruptorAltFire", source: "oracle/codemp/game/g_weapon.c:642")
                trap_Trace(tr, start, vec3_origin, vec3_origin, end, skip, MASK_SHOT)
            }

            traceEnt = g_entities[tr.entityNum]

            if d_projectileGhoul2Collision.integer != 0 && traceEnt!.inuse && traceEnt!.client != nil {
                //g2 collision checks -rww
                if traceEnt!.inuse && traceEnt!.client != nil && traceEnt!.ghoul2 != nil {
                    //since we used G2TRFLAG_GETSURFINDEX, tr.surfaceFlags will actually contain the index of the surface on the ghoul2 model we collided with.
                    traceEnt!.client!.g2LastSurfaceHit = tr.surfaceFlags
                    traceEnt!.client!.g2LastSurfaceTime = level.time
                }

                if traceEnt!.ghoul2 != nil {
                    tr.surfaceFlags = 0 //clear the surface flags after, since we actually care about them in here.
                }
            }

            if (tr.surfaceFlags & SURF_NOIMPACT) != 0 {
                render_impact = false
            }

            if traceEnt != nil && traceEnt!.client != nil && traceEnt!.client!.ps.duelInProgress && traceEnt!.client!.ps.duelIndex != ent.s.number {
                skip = tr.entityNum
                start = tr.endpos
                i += 1
                continue
            }

            if Jedi_DodgeEvasion(traceEnt!, ent, tr, G_GetHitLocation(traceEnt!, tr.endpos)) {
                skip = tr.entityNum
                start = tr.endpos
                i += 1
                continue
            } else if traceEnt != nil && traceEnt!.client != nil && traceEnt!.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] >= FORCE_LEVEL_3 {
                if WP_SaberCanBlock(traceEnt!, tr.endpos, 0, MOD_DISRUPTOR_SNIPER, true, 0) != 0 {
                    //broadcast and stop the shot because it was blocked
                    var te: Entity? = nil

                    tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_SNIPER_SHOT)
                    tent!.s.origin2 = muzzle
                    tent!.s.shouldtarget = fullCharge
                    tent!.s.eventParm = ent.s.number

                    te = G_TempEntity(tr.endpos, EV_SABER_BLOCK)
                    te!.s.origin = tr.endpos
                    te!.s.angles = tr.plane.normal
                    if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
                        te!.s.angles[1] = 1
                    }
                    te!.s.eventParm = 0
                    te!.s.weapon = 0 //saberNum
                    te!.s.legsAnim = 0 //bladeNum

                    return true
                }
            }

            // always render a shot beam, doing this the old way because I don't much feel like overriding the effect.
            tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_SNIPER_SHOT)
            tent!.s.origin2 = muzzle
            tent!.s.shouldtarget = fullCharge
            tent!.s.eventParm = ent.s.number

            // If the beam hits a skybox, etc. it would look foolish to add impact effects
            if render_impact {
                if traceEnt!.takedamage && traceEnt!.client != nil {
                    tent!.s.otherEntityNum = traceEnt!.s.number

                    // Create a simple impact type mark
                    tent = G_TempEntity(tr.endpos, EV_MISSILE_MISS)
                    tent!.s.eventParm = DirToByte(tr.plane.normal)
                    tent!.s.eFlags |= EF_ALT_FIRING

                    if LogAccuracyHit(traceEnt!, ent) {
                        if ent.client != nil {
                            ent.client!.accuracy_hits += 1
                        }
                    }
                } else {
                    if (traceEnt!.r.svFlags & SVF_GLASS_BRUSH) != 0 || traceEnt!.takedamage || traceEnt!.s.eType == ET_MOVER {
                        if traceEnt!.takedamage {
                            G_Damage(traceEnt!, ent, ent, &forward, tr.endpos, damage, DAMAGE_NO_KNOCKBACK, MOD_DISRUPTOR_SNIPER)

                            tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_HIT)
                            tent!.s.eventParm = DirToByte(tr.plane.normal)
                        }
                    } else {
                        // Hmmm, maybe don't make any marks on things that could break
                        tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_SNIPER_MISS)
                        tent!.s.eventParm = DirToByte(tr.plane.normal)
                    }
                    break // and don't try any more traces
                }

                if (traceEnt!.flags & FL_SHIELDED) != 0 {
                    //stops us cold
                    break
                }

                if traceEnt!.takedamage {
                    var preAng = vec3_t()
                    let preHealth: Int32 = traceEnt!.health
                    var preLegs: Int32 = 0
                    var preTorso: Int32 = 0

                    if traceEnt!.client != nil {
                        preLegs = traceEnt!.client!.ps.legsAnim
                        preTorso = traceEnt!.client!.ps.torsoAnim
                        preAng = traceEnt!.client!.ps.viewangles
                    }

                    G_Damage(traceEnt!, ent, ent, &forward, tr.endpos, damage, DAMAGE_NO_KNOCKBACK, MOD_DISRUPTOR_SNIPER)

                    if traceEnt!.client != nil && preHealth > 0 && traceEnt!.health <= 0 && fullCharge && G_CanDisruptify(traceEnt!) {
                        //was killed by a fully charged sniper shot, so disintegrate
                        traceEnt!.client!.ps.viewangles = preAng

                        traceEnt!.client!.ps.eFlags |= EF_DISINTEGRATION
                        traceEnt!.client!.ps.lastHitLoc = tr.endpos

                        traceEnt!.client!.ps.legsAnim = preLegs
                        traceEnt!.client!.ps.torsoAnim = preTorso

                        traceEnt!.r.contents = 0

                        traceEnt!.client!.ps.velocity = vec3_t()
                    }

                    tent = G_TempEntity(tr.endpos, EV_DISRUPTOR_HIT)
                    tent!.s.eventParm = DirToByte(tr.plane.normal)
                    if traceEnt!.client != nil {
                        tent!.s.weapon = 1
                    }
                }
            } else {
                break // don't try anymore traces
            }

            // Get ready for an attempt to trace through another person
            muzzle = tr.endpos
            start = tr.endpos
            skip = tr.entityNum
            i += 1
        }
        return false
    }
    if earlyOut {
        return
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:890
private func WP_FireDisruptor(_ ent: Entity, _ altFire: Bool) {
    // Raven assigns his own `altFire` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var altFire = altFire
    if ent.client == nil || ent.client!.ps.zoomMode != 1 {
        //do not ever let it do the alt fire when not zoomed
        altFire = false
    }

    if ent.s.eType == ET_NPC && ent.client == nil {
        //special case for animents
        WP_DisruptorAltFire(ent)
        return
    }

    if altFire {
        WP_DisruptorAltFire(ent)
    } else {
        WP_DisruptorMainFire(ent)
    }
}

/// Source: oracle/codemp/game/g_weapon.c:923
private func WP_BowcasterAltFire(_ ent: Entity) {
    let damage: Int32 = BOWCASTER_DAMAGE

    let missile: Entity? = CreateMissile(&muzzle, forward, Float(BOWCASTER_VELOCITY), 10000, ent, false)

    missile!.classname = "bowcaster_proj"
    missile!.s.weapon = WP_BOWCASTER

    missile!.r.maxs = vec3_t(Float(BOWCASTER_SIZE), Float(BOWCASTER_SIZE), Float(BOWCASTER_SIZE))
    missile!.r.mins = missile!.r.maxs * -1

    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = MOD_BOWCASTER
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

    missile!.flags |= FL_BOUNCE
    missile!.bounceCount = 3
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:945
private func WP_BowcasterMainFire(_ ent: Entity) {
    var damage: Int32 = BOWCASTER_DAMAGE
    var count: Int32
    var vel: Float
    var angs = vec3_t()
    var dir = vec3_t()
    var missile: Entity?
    var i: Int32

    if ent.client == nil {
        count = 1
    } else {
        count = Int32((level.time - ent.client!.ps.weaponChargeTime) / BOWCASTER_CHARGE_UNIT)
    }

    if count < 1 {
        count = 1
    } else if count > 5 {
        count = 5
    }

    if !((count & 1) != 0) {
        // if we aren't odd, knock us down a level
        count -= 1
    }

    //scale the damage down based on how many are about to be fired
    if count <= 1 {
        damage = 50
    } else if count == 2 {
        damage = 45
    } else if count == 3 {
        damage = 40
    } else if count == 4 {
        damage = 35
    } else {
        damage = 30
    }

    i = 0
    while i < count {
        // create a range of different velocities
        vel = BOWCASTER_VELOCITY * (crandom() * BOWCASTER_VEL_RANGE + 1.0)

        vectoangles(forward, &angs)

        // add some slop to the alt-fire direction
        angs[PITCH] += crandom() * BOWCASTER_ALT_SPREAD * 0.2
        angs[YAW] += ((i + 0.5) * BOWCASTER_ALT_SPREAD - count * 0.5 * BOWCASTER_ALT_SPREAD)

        // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
        var scratchRight = vec3_t()
        // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
        var scratchUp = vec3_t()
        AngleVectors(angs, &dir, &scratchRight, &scratchUp)

        missile = CreateMissile(&muzzle, dir, vel, 10000, ent, true)

        missile!.classname = "bowcaster_alt_proj"
        missile!.s.weapon = WP_BOWCASTER

        missile!.r.maxs = vec3_t(Float(BOWCASTER_SIZE), Float(BOWCASTER_SIZE), Float(BOWCASTER_SIZE))
        missile!.r.mins = missile!.r.maxs * -1

        missile!.damage = damage
        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.methodOfDeath = MOD_BOWCASTER
        missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

        // we don't want it to bounce
        missile!.bounceCount = 0
        i += 1
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1032
private func WP_FireBowcaster(_ ent: Entity, _ altFire: Bool) {
    if altFire {
        WP_BowcasterAltFire(ent)
    } else {
        WP_BowcasterMainFire(ent)
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1056
private func WP_RepeaterMainFire(_ ent: Entity, _ dir: JKAShared.vec3_t) {
    let damage: Int32 = REPEATER_DAMAGE

    let missile: Entity? = CreateMissile(&muzzle, dir, Float(REPEATER_VELOCITY), 10000, ent, false)

    missile!.classname = "repeater_proj"
    missile!.s.weapon = WP_REPEATER

    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = MOD_REPEATER
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

    // we don't want it to bounce forever
    missile!.bounceCount = 8
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1076
private func WP_RepeaterAltFire(_ ent: Entity) {
    let damage: Int32 = REPEATER_ALT_DAMAGE

    let missile: Entity? = CreateMissile(&muzzle, forward, Float(REPEATER_ALT_VELOCITY), 10000, ent, true)

    missile!.classname = "repeater_alt_proj"
    missile!.s.weapon = WP_REPEATER

    missile!.r.maxs = vec3_t(Float(REPEATER_ALT_SIZE), Float(REPEATER_ALT_SIZE), Float(REPEATER_ALT_SIZE))
    missile!.r.mins = missile!.r.maxs * -1
    missile!.s.pos.trType = TR_GRAVITY
    missile!.s.pos.trDelta[2] += 40.0 //give a slight boost in the upward direction
    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = MOD_REPEATER_ALT
    missile!.splashMethodOfDeath = MOD_REPEATER_ALT_SPLASH
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
    missile!.splashDamage = REPEATER_ALT_SPLASH_DAMAGE
    if g_gametype.integer == GT_SIEGE {
        missile!.splashRadius = REPEATER_ALT_SPLASH_RAD_SIEGE
    } else {
        missile!.splashRadius = REPEATER_ALT_SPLASH_RADIUS
    }

    // we don't want it to bounce forever
    missile!.bounceCount = 8
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1110
private func WP_FireRepeater(_ ent: Entity, _ altFire: Bool) {
    var dir = vec3_t()
    var angs = vec3_t()

    vectoangles(forward, &angs)

    if altFire {
        WP_RepeaterAltFire(ent)
    } else {
        // add some slop to the alt-fire direction
        angs[PITCH] += crandom() * REPEATER_SPREAD
        angs[YAW] += crandom() * REPEATER_SPREAD

        // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
        var scratchRight = vec3_t()
        // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
        var scratchUp = vec3_t()
        AngleVectors(angs, &dir, &scratchRight, &scratchUp)

        WP_RepeaterMainFire(ent, dir)
    }
}

/// Source: oracle/codemp/game/g_weapon.c:1142
private func WP_DEMP2_MainFire(_ ent: Entity) {
    let damage: Int32 = DEMP2_DAMAGE

    let missile: Entity? = CreateMissile(&muzzle, forward, Float(DEMP2_VELOCITY), 10000, ent, false)

    missile!.classname = "demp2_proj"
    missile!.s.weapon = WP_DEMP2

    missile!.r.maxs = vec3_t(Float(DEMP2_SIZE), Float(DEMP2_SIZE), Float(DEMP2_SIZE))
    missile!.r.mins = missile!.r.maxs * -1
    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = MOD_DEMP2
    missile!.clipmask = MASK_SHOT

    // we don't want it to ever bounce
    missile!.bounceCount = 0
}

/// Source: oracle/codemp/game/g_weapon.c:1164
func DEMP2_AltRadiusDamage(_ ent: Entity) {
    var frac: Float = (level.time - ent.genericValue5) / 800.0
    var dist: Float
    var radius: Float
    var fact: Float
    var gent: Entity?
    var iEntityList: [Int32] = [Int32](repeating: 0, count: 1024)
    var entityList = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))
    var myOwner: Entity? = nil
    let numListedEntities: Int32
    var i: Int32
    var e: Int32
    var mins = vec3_t()
    var maxs = vec3_t()
    var v = vec3_t()
    var dir = vec3_t()

    if ent.r.ownerNum >= 0 && ent.r.ownerNum < MAX_GENTITIES {
        myOwner = g_entities[ent.r.ownerNum]
    }

    if myOwner == nil || !myOwner!.inuse || myOwner!.client == nil {
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
        return
    }

    frac *= frac * frac // yes, this is completely ridiculous...but it causes the shell to grow slowly then "explode" at the end

    radius = frac * 200.0 // 200 is max radius...the model is aprox. 100 units tall...the fx draw code mults. this by 2.

    fact = Float(Double(ent.count) * 0.6)

    if fact < 1 {
        fact = 1
    }

    radius *= fact

    i = 0
    while i < 3 {
        mins[i] = ent.r.currentOrigin[i] - radius
        maxs[i] = ent.r.currentOrigin[i] + radius
        i += 1
    }

    numListedEntities = trap_EntitiesInBox(mins, maxs, &iEntityList, MAX_GENTITIES)

    i = 0
    while i < numListedEntities {
        entityList[i] = g_entities[iEntityList[i]]
        i += 1
    }

    e = 0
    while e < numListedEntities {
        gent = entityList[e]

        if gent == nil || !gent!.takedamage || gent!.r.contents == 0 {
            e += 1
            continue
        }

        // find the distance from the edge of the bounding box
        i = 0
        while i < 3 {
            if ent.r.currentOrigin[i] < gent!.r.absmin[i] {
                v[i] = gent!.r.absmin[i] - ent.r.currentOrigin[i]
            } else if ent.r.currentOrigin[i] > gent!.r.absmax[i] {
                v[i] = ent.r.currentOrigin[i] - gent!.r.absmax[i]
            } else {
                v[i] = 0
            }
            i += 1
        }

        // shape is an ellipsoid, so cut vertical distance in half`
        v[2] *= 0.5

        dist = VectorLength(v)

        if dist >= radius {
            // shockwave hasn't hit them yet
            e += 1
            continue
        }

        if dist + (16 * ent.count) < ent.genericValue6 {
            // shockwave has already hit this thing...
            e += 1
            continue
        }

        v = gent!.r.currentOrigin
        dir = v - ent.r.currentOrigin

        // push the center of mass higher than the origin so players get knocked into the air more
        dir[2] += 12

        if gent != myOwner {
            G_Damage(gent!, myOwner, myOwner, &dir, ent.r.currentOrigin, ent.damage, DAMAGE_DEATH_KNOCKBACK, ent.splashMethodOfDeath)
            if gent!.takedamage && gent!.client != nil {
                if gent!.client!.ps.electrifyTime < level.time {
                    //electrocution effect
                    if gent!.s.eType == ET_NPC && gent!.s.NPC_class == CLASS_VEHICLE && gent!.m_pVehicle != nil && (gent!.m_pVehicle!.m_pVehicleInfo!.type == VH_SPEEDER || gent!.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER) {
                        //do some extra stuff to speeders/walkers
                        gent!.client!.ps.electrifyTime = level.time + Q_irand(3000, 4000)
                    } else if gent!.s.NPC_class != CLASS_VEHICLE || (gent!.m_pVehicle != nil && gent!.m_pVehicle!.m_pVehicleInfo!.type != VH_FIGHTER) {
                        //don't do this to fighters
                        gent!.client!.ps.electrifyTime = level.time + Q_irand(300, 800)
                    }
                }
                if gent!.client!.ps.powerups[PW_CLOAKED] != 0 {
                    //disable cloak temporarily
                    Jedi_Decloak(gent!)
                    gent!.client!.cloakToggleTime = level.time + Q_irand(3000, 10000)
                }
            }
        }
        e += 1
    }

    // store the last fraction so that next time around we can test against those things that fall between that last point and where the current shockwave edge is
    ent.genericValue6 = Int32(radius)

    if frac < 1.0 {
        // shock is still happening so continue letting it expand
        ent.nextthink = level.time + 50
    } else {
        //don't just leave the entity around
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1310
func DEMP2_AltDetonate(_ ent: Entity) {
    var efEnt: Entity?

    G_SetOrigin(ent, &ent.r.currentOrigin)
    if ent.pos1[0] == 0 && ent.pos1[1] == 0 && ent.pos1[2] == 0 {
        //don't play effect with a 0'd out directional vector
        ent.pos1[1] = 1
    }
    //Let's just save ourself some bandwidth and play both the effect and sphere spawn in 1 event
    efEnt = G_PlayEffect(EFFECT_EXPLOSION_DEMP2ALT, ent.r.currentOrigin, ent.pos1)

    if efEnt != nil {
        efEnt!.s.weapon = ent.count * 2
    }

    ent.genericValue5 = level.time
    ent.genericValue6 = 0
    ent.nextthink = level.time + 50
    ent.think = Think.DEMP2_AltRadiusDamage
    ent.s.eType = ET_GENERAL // make us a missile no longer
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1336
private func WP_DEMP2_AltFire(_ ent: Entity) {
    var damage: Int32 = DEMP2_ALT_DAMAGE
    var count: Int32 = 0
    var origcount: Int32 = 0
    var fact: Float = 0
    var start = vec3_t()
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in
        var missile: Entity?

        start = muzzle

        _VectorMA(start, Float(DEMP2_ALT_RANGE), forward, &end)

        count = Int32((level.time - ent.client!.ps.weaponChargeTime) / DEMP2_CHARGE_UNIT)

        origcount = count

        if count < 1 {
            count = 1
        } else if count > 3 {
            count = 3
        }

        fact = Float(Double(count) * 0.8)
        if fact < 1 {
            fact = 1
        }
        damage = Int32(Float(damage) * fact)

        if origcount == 0 {
            //this was just a tap-fire
            damage = 1
        }

        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("WP_DEMP2_AltFire", source: "oracle/codemp/game/g_weapon.c:1336")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("WP_DEMP2_AltFire", source: "oracle/codemp/game/g_weapon.c:1336")
        trap_Trace(tr, start, vec3_origin, vec3_origin, end, ent.s.number, MASK_SHOT)

        missile = G_Spawn()
        G_SetOrigin(missile!, &tr.endpos)
        //In SP the impact actually travels as a missile based on the trace fraction, but we're
        //just going to be instant. -rww

        missile!.pos1 = tr.plane.normal

        missile!.count = count

        missile!.classname = "demp2_alt_proj"
        missile!.s.weapon = WP_DEMP2

        missile!.think = Think.DEMP2_AltDetonate
        missile!.nextthink = level.time

        missile!.damage = damage
        missile!.splashDamage = missile!.damage
        missile!.methodOfDeath = MOD_DEMP2
        missile!.splashMethodOfDeath = missile!.methodOfDeath
        missile!.splashRadius = DEMP2_ALT_SPLASHRADIUS

        missile!.r.ownerNum = ent.s.number

        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

        // we don't want it to ever bounce
        missile!.bounceCount = 0
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1406
private func WP_FireDEMP2(_ ent: Entity, _ altFire: Bool) {
    if altFire {
        WP_DEMP2_AltFire(ent)
    } else {
        WP_DEMP2_MainFire(ent)
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1430
private func WP_FlechetteMainFire(_ ent: Entity) {
    var fwd = vec3_t()
    var angs = vec3_t()
    var missile: Entity?
    var i: Int32

    i = 0
    while i < FLECHETTE_SHOTS {
        vectoangles(forward, &angs)

        if i != 0 {
            //do nothing on the first shot, it will hit the crosshairs
            angs[PITCH] += crandom() * FLECHETTE_SPREAD
            angs[YAW] += crandom() * FLECHETTE_SPREAD
        }

        // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
        var scratchRight = vec3_t()
        // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
        var scratchUp = vec3_t()
        AngleVectors(angs, &fwd, &scratchRight, &scratchUp)

        missile = CreateMissile(&muzzle, fwd, Float(FLECHETTE_VEL), 10000, ent, false)

        missile!.classname = "flech_proj"
        missile!.s.weapon = WP_FLECHETTE

        missile!.r.maxs = vec3_t(Float(FLECHETTE_SIZE), Float(FLECHETTE_SIZE), Float(FLECHETTE_SIZE))
        missile!.r.mins = missile!.r.maxs * -1

        missile!.damage = FLECHETTE_DAMAGE
        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.methodOfDeath = MOD_FLECHETTE
        missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

        // we don't want it to bounce forever
        missile!.bounceCount = Q_irand(5, 8)

        missile!.flags |= FL_BOUNCE_SHRAPNEL
        i += 1
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1470
func prox_mine_think(_ ent: Entity) {
    let count: Int32
    var i: Int32
    var blow: Bool = false

    // if it isn't time to auto-explode, do a small proximity check
    if ent.delay > level.time {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<Entity?>' to expected argument type '[Entity?]'".
        // Raven wrote: count = G_RadiusList( ent->r.currentOrigin, FLECHETTE_MINE_RADIUS_CHECK, ent, qtrue, ent_list )
        portMissing("prox_mine_think", source: "oracle/codemp/game/g_weapon.c:1470")

        i = 0
        while i < count {
            if ent_list[i]!.client != nil && ent_list[i]!.health > 0 && ent.activator != nil && ent_list[i]!.s.number != ent.activator!.s.number {
                blow = true
                break
            }
            i += 1
        }
    } else {
        // well, we must die now
        blow = true
    }

    if blow {
        ent.think = Think.laserTrapExplode
        ent.nextthink = level.time + 200
    } else {
        // we probably don't need to do this thinking logic very often...maybe this is fast enough?
        ent.nextthink = level.time + 500
    }
}

//-----------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1509
private func WP_TraceSetStart(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) {
    //make sure our start point isn't on the other side of a wall
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var entMins = vec3_t()
        var entMaxs = vec3_t()

        entMins = ent.r.currentOrigin + ent.r.mins
        entMaxs = ent.r.currentOrigin + ent.r.maxs

        if G_BoxInBounds(start, mins, maxs, entMins, entMaxs) {
            return true
        }

        if ent.client == nil {
            return true
        }

        trap_Trace(tr, ent.client!.ps.origin, mins, maxs, start, ent.s.number, MASK_SOLID | CONTENTS_SHOTCLIP)

        if tr.startsolid != 0 || tr.allsolid != 0 {
            return true
        }

        if tr.fraction < 1.0 {
            start = tr.endpos
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_weapon.c:1543
func WP_ExplosiveDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    laserTrapExplode(`self`)
}

//----------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1549
func WP_flechette_alt_blow(_ ent: Entity) {
    ent.s.pos.trDelta[0] = 1
    ent.s.pos.trDelta[1] = 0
    ent.s.pos.trDelta[2] = 0

    laserTrapExplode(ent)
}

//------------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1560
private func WP_CreateFlechetteBouncyThing(_ start: inout JKAShared.vec3_t, _ fwd: JKAShared.vec3_t, _ `self`: Entity) {
    // The SDK also declares `random`, so the call names the bg module.
    let missile: Entity? = CreateMissile(&start, fwd, 700 + JKAMP_BG.random() * 700, Int32(1500 + JKAMP_BG.random() * 2000), `self`, true)

    missile!.think = Think.WP_flechette_alt_blow

    missile!.activator = `self`

    missile!.s.weapon = WP_FLECHETTE
    missile!.classname = "flech_alt"
    missile!.mass = 4

    // How 'bout we give this thing a size...
    missile!.r.mins = vec3_t(-3.0, -3.0, -3.0)
    missile!.r.maxs = vec3_t(3.0, 3.0, 3.0)
    missile!.clipmask = MASK_SHOT

    missile!.touch = Touch.touch_NULL

    // normal ones bounce, alt ones explode on impact
    missile!.s.pos.trType = TR_GRAVITY

    missile!.flags |= FL_BOUNCE_HALF
    missile!.s.eFlags |= EF_ALT_FIRING

    missile!.bounceCount = 50

    missile!.damage = FLECHETTE_ALT_DAMAGE
    missile!.dflags = 0
    missile!.splashDamage = FLECHETTE_ALT_SPLASH_DAM
    missile!.splashRadius = FLECHETTE_ALT_SPLASH_RAD

    missile!.r.svFlags = SVF_USE_CURRENT_ORIGIN

    missile!.methodOfDeath = MOD_FLECHETTE_ALT_SPLASH
    missile!.splashMethodOfDeath = MOD_FLECHETTE_ALT_SPLASH

    missile!.pos2 = start
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1602
private func WP_FlechetteAltFire(_ `self`: Entity) {
    var dir = vec3_t()
    var fwd = vec3_t()
    var start = vec3_t()
    var angs = vec3_t()
    var i: Int32

    vectoangles(forward, &angs)
    start = muzzle

    WP_TraceSetStart(`self`, &start, vec3_origin, vec3_origin) //make sure our start point isn't on the other side of a wall

    i = 0
    while i < 2 {
        dir = angs

        // The SDK also declares `random`, so the call names the bg module.
        dir[PITCH] -= JKAMP_BG.random() * 4 + 8 // make it fly upwards
        dir[YAW] += crandom() * 2
        // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
        var scratchRight = vec3_t()
        // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
        var scratchUp = vec3_t()
        AngleVectors(dir, &fwd, &scratchRight, &scratchUp)

        WP_CreateFlechetteBouncyThing(&start, fwd, `self`)
        i += 1
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1626
private func WP_FireFlechette(_ ent: Entity, _ altFire: Bool) {
    if altFire {
        //WP_FlechetteProxMine( ent );
        WP_FlechetteAltFire(ent)
    } else {
        WP_FlechetteMainFire(ent)
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1651
func rocketThink(_ ent: Entity) {
    var newdir = vec3_t()
    var targetdir = vec3_t()
    var up = vec3_t(0, 0, 1)
    var right = vec3_t()
    var org = vec3_t()
    let dot: Float
    let dot2: Float
    let dis: Float
    var i: Int32
    var vel: Float = (ent.spawnflags & 1) != 0 ? ent.speed : Float(ROCKET_VELOCITY)

    if ent.genericValue1 != 0 && ent.genericValue1 < level.time {
        //time's up, we're done, remove us
        if ent.genericValue2 != 0 {
            //explode when die
            RocketDie(ent, g_entities[ent.r.ownerNum], g_entities[ent.r.ownerNum], 0, MOD_UNKNOWN)
        } else {
            //just remove when die
            G_FreeEntity(ent)
        }
        return
    }
    if ent.enemy == nil || ent.enemy!.client == nil || ent.enemy!.health <= 0 || ent.enemy!.client!.ps.powerups[PW_CLOAKED] != 0 {
        //no enemy or enemy not a client or enemy dead or enemy cloaked
        if ent.genericValue1 == 0 {
            //doesn't have its own self-kill time
            ent.nextthink = level.time + 10000
            ent.think = Think.G_FreeEntity
        }
        return
    }

    if (ent.spawnflags & 1) != 0 {
        //vehicle rocket
        if ent.enemy!.client != nil && ent.enemy!.client!.NPC_class == CLASS_VEHICLE {
            //tracking another vehicle
            if ent.enemy!.client!.ps.speed + 4000 > vel {
                vel = ent.enemy!.client!.ps.speed + 4000
            }
        }
    }

    if ent.enemy != nil && ent.enemy!.inuse {
        let newDirMult: Float = ent.angle != 0 ? ent.angle * 2.0 : 1.0
        let oldDirMult: Float = ent.angle != 0 ? (1.0 - ent.angle) * 2.0 : 1.0

        org = ent.enemy!.r.currentOrigin
        org[2] += (ent.enemy!.r.mins[2] + ent.enemy!.r.maxs[2]) * 0.5

        targetdir = org - ent.r.currentOrigin
        VectorNormalize(&targetdir)

        // Now the rocket can't do a 180 in space, so we'll limit the turn to about 45 degrees.
        dot = _DotProduct(targetdir, ent.movedir)
        if (ent.spawnflags & 1) != 0 {
            //vehicle rocket
            if ent.radius > -1.0 {
                //can lose the lock if DotProduct drops below this number
                if dot < ent.radius {
                    //lost the lock!!!
                    //HMM... maybe can re-lock on if they come in front again?
                    /*
                    //OR: should it stop trying to lock altogether?
                    if ( ent->genericValue1 )
                    {//have a timelimit, set next think to that
                    ent->nextthink = ent->genericValue1;
                    if ( ent->genericValue2 )
                    {//explode when die
                    ent->think = G_ExplodeMissile;
                    }
                    else
                    {
                    ent->think = G_FreeEntity;
                    }
                    }
                    else
                    {
                    ent->think = NULL;
                    ent->nextthink = -1;
                    }
                    */
                    return
                }
            }
        }


        // a dot of 1.0 means right-on-target.
        if dot < 0.0 {
            // Go in the direction opposite, start a 180.
            CrossProduct(ent.movedir, up, &right)
            dot2 = _DotProduct(targetdir, right)

            if dot2 > 0 {
                // Turn 45 degrees right.
                _VectorMA(ent.movedir, 0.4 * newDirMult, right, &newdir)
            } else {
                // Turn 45 degrees left.
                _VectorMA(ent.movedir, -0.4 * newDirMult, right, &newdir)
            }

            // Yeah we've adjusted horizontally, but let's split the difference vertically, so we kinda try to move towards it.
            newdir[2] = Float(Double((targetdir[2] * newDirMult) + (ent.movedir[2] * oldDirMult)) * 0.5)

            // let's also slow down a lot
            vel *= 0.5
        } else if dot < 0.70 {
            // Still a bit off, so we turn a bit softer
            _VectorMA(ent.movedir, 0.5 * newDirMult, targetdir, &newdir)
        } else {
            // getting close, so turn a bit harder
            _VectorMA(ent.movedir, 0.9 * newDirMult, targetdir, &newdir)
        }

        // add crazy drunkenness
        i = 0
        while i < 3 {
            newdir[i] += crandom() * ent.random * 0.25
            i += 1
        }

        // decay the randomness
        ent.random *= 0.9

        if ent.enemy!.client != nil && ent.enemy!.client!.ps.groundEntityNum != ENTITYNUM_NONE {
            //tracking a client who's on the ground, aim at the floor...?
            // Try to crash into the ground if we get close enough to do splash damage
            dis = Distance(ent.r.currentOrigin, org)

            if dis < 128 {
                // the closer we get, the more we push the rocket down, heh heh.
                newdir[2] -= (1.0 - (dis / 128.0)) * 0.6
            }
        }

        VectorNormalize(&newdir)

        ent.s.pos.trDelta = newdir * (vel * 0.5)
        ent.movedir = newdir
        SnapVector(&ent.s.pos.trDelta) // save net bandwidth
        ent.s.pos.trBase = ent.r.currentOrigin
        ent.s.pos.trTime = level.time
    }

    ent.nextthink = level.time + ROCKET_ALT_THINK_TIME // Nothing at all spectacular happened, continue.
    return
}

/// Source: oracle/codemp/game/g_weapon.c:1814
func RocketDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    `self`.die = nil
    `self`.r.contents = 0

    G_ExplodeMissile(`self`)

    `self`.think = Think.G_FreeEntity
    `self`.nextthink = level.time
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1826
private func WP_FireRocket(_ ent: Entity, _ altFire: Bool) {
    let damage: Int32 = ROCKET_DAMAGE
    var vel: Int32 = ROCKET_VELOCITY
    var dif: Int32 = 0
    var rTime: Float
    var missile: Entity?

    if altFire {
        vel = Int32(Float(vel) * 0.5)
    }

    missile = CreateMissile(&muzzle, forward, Float(vel), 10000, ent, altFire)

    if ent.client != nil && ent.client!.ps.rocketLockIndex != ENTITYNUM_NONE {
        let lockTimeInterval: Float = ((g_gametype.integer == GT_SIEGE) ? 2400.0 : 1200.0) / 16.0
        rTime = ent.client!.ps.rocketLockTime

        if rTime == -1 {
            rTime = ent.client!.ps.rocketLastValidTime
        }
        dif = Int32((level.time - rTime) / lockTimeInterval)

        if dif < 0 {
            dif = 0
        }

        //It's 10 even though it locks client-side at 8, because we want them to have a sturdy lock first, and because there's a slight difference in time between server and client
        if dif >= 10 && rTime != -1 {
            missile!.enemy = g_entities[ent.client!.ps.rocketLockIndex]

            if missile!.enemy != nil && missile!.enemy!.client != nil && missile!.enemy!.health > 0 && !OnSameTeam(ent, missile!.enemy!) {
                //if enemy became invalid, died, or is on the same team, then don't seek it
                missile!.angle = 0.5
                missile!.think = Think.rocketThink
                missile!.nextthink = level.time + ROCKET_ALT_THINK_TIME
            }
        }

        ent.client!.ps.rocketLockIndex = ENTITYNUM_NONE
        ent.client!.ps.rocketLockTime = 0
        ent.client!.ps.rocketTargetTime = 0
    }

    missile!.classname = "rocket_proj"
    missile!.s.weapon = WP_ROCKET_LAUNCHER

    // Make it easier to hit things
    missile!.r.maxs = vec3_t(Float(ROCKET_SIZE), Float(ROCKET_SIZE), Float(ROCKET_SIZE))
    missile!.r.mins = missile!.r.maxs * -1

    missile!.damage = damage
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    if altFire {
        missile!.methodOfDeath = MOD_ROCKET_HOMING
        missile!.splashMethodOfDeath = MOD_ROCKET_HOMING_SPLASH
    } else {
        missile!.methodOfDeath = MOD_ROCKET
        missile!.splashMethodOfDeath = MOD_ROCKET_SPLASH
    }
    //===testing being able to shoot rockets out of the air==================================
    missile!.health = 10
    missile!.takedamage = true
    missile!.r.contents = MASK_SHOT
    missile!.die = Die.RocketDie
    //===testing being able to shoot rockets out of the air==================================

    missile!.clipmask = MASK_SHOT
    missile!.splashDamage = ROCKET_SPLASH_DAMAGE
    missile!.splashRadius = ROCKET_SPLASH_RADIUS

    // we don't want it to ever bounce
    missile!.bounceCount = 0
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1936
func thermalDetonatorExplode(_ ent: Entity) {
    if ent.count == 0 {
        G_Sound(ent, CHAN_WEAPON, G_SoundIndex("sound/weapons/thermal/warning.wav"))
        ent.count = 1
        ent.genericValue5 = level.time + 500
        ent.think = Think.thermalThinkStandard
        ent.nextthink = level.time
        ent.r.svFlags |= SVF_BROADCAST //so everyone hears/sees the explosion?
    } else {
        var origin = vec3_t()
        var dir = vec3_t(0, 0, 1)

        BG_EvaluateTrajectory(ent.s.pos, level.time, &origin)
        origin[2] += 8
        SnapVector(&origin)
        G_SetOrigin(ent, &origin)

        ent.s.eType = ET_GENERAL
        G_AddEvent(ent, EV_MISSILE_MISS, DirToByte(dir))
        ent.freeAfterEvent = true

        if G_RadiusDamage(ent.r.currentOrigin, ent.parent!, Float(ent.splashDamage), Float(ent.splashRadius), ent, ent, ent.splashMethodOfDeath) {
            g_entities[ent.r.ownerNum].client!.accuracy_hits += 1
        }

        trap_LinkEntity(ent)
    }
}

/// Source: oracle/codemp/game/g_weapon.c:1972
func thermalThinkStandard(_ ent: Entity) {
    if ent.genericValue5 < level.time {
        ent.think = Think.thermalDetonatorExplode
        ent.nextthink = level.time
        return
    }

    G_RunObject(ent)
    ent.nextthink = level.time
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:1986
func WP_FireThermalDetonator(_ ent: Entity, _ altFire: Bool) -> Entity? {
    var bolt: Entity?
    var dir = vec3_t()
    var start = vec3_t()
    var chargeAmount: Float = 1.0

    dir = forward
    start = muzzle

    bolt = G_Spawn()

    bolt!.physicsObject = true

    bolt!.classname = "thermal_detonator"
    bolt!.think = Think.thermalThinkStandard
    bolt!.nextthink = level.time
    bolt!.touch = Touch.touch_NULL

    // How 'bout we give this thing a size...
    bolt!.r.mins = vec3_t(-3.0, -3.0, -3.0)
    bolt!.r.maxs = vec3_t(3.0, 3.0, 3.0)
    bolt!.clipmask = MASK_SHOT

    W_TraceSetStart(ent, &start, bolt!.r.mins, bolt!.r.maxs) //make sure our start point isn't on the other side of a wall

    if ent.client != nil {
        chargeAmount = Float(level.time - ent.client!.ps.weaponChargeTime)
    }

    // get charge amount
    chargeAmount = chargeAmount / Float(TD_VELOCITY)

    if chargeAmount > 1.0 {
        chargeAmount = 1.0
    } else if chargeAmount < TD_MIN_CHARGE {
        chargeAmount = TD_MIN_CHARGE
    }

    // normal ones bounce, alt ones explode on impact
    bolt!.genericValue5 = level.time + TD_TIME // How long 'til she blows
    bolt!.s.pos.trType = TR_GRAVITY
    bolt!.parent = ent
    bolt!.r.ownerNum = ent.s.number
    bolt!.s.pos.trDelta = dir * (TD_VELOCITY * chargeAmount)

    if ent.health >= 0 {
        bolt!.s.pos.trDelta[2] += 120
    }

    if !altFire {
        bolt!.flags |= FL_BOUNCE_HALF
    }

    bolt!.s.loopSound = G_SoundIndex("sound/weapons/thermal/thermloop.wav")
    bolt!.s.loopIsSoundset = false

    bolt!.damage = TD_DAMAGE
    bolt!.dflags = 0
    bolt!.splashDamage = TD_SPLASH_DAM
    bolt!.splashRadius = TD_SPLASH_RAD

    bolt!.s.eType = ET_MISSILE
    bolt!.r.svFlags = SVF_USE_CURRENT_ORIGIN
    bolt!.s.weapon = WP_THERMAL

    bolt!.methodOfDeath = MOD_THERMAL
    bolt!.splashMethodOfDeath = MOD_THERMAL_SPLASH

    bolt!.s.pos.trTime = level.time // move a bit on the very first frame
    bolt!.s.pos.trBase = start

    SnapVector(&bolt!.s.pos.trDelta) // save net bandwidth
    bolt!.r.currentOrigin = start

    bolt!.pos2 = start

    bolt!.bounceCount = -5

    return bolt
}

/// Source: oracle/codemp/game/g_weapon.c:2074
func WP_DropThermal(_ ent: Entity) -> Entity? {
    AngleVectors(ent.client!.ps.viewangles, &forward, &vright, &up)
    return (WP_FireThermalDetonator(ent, false))
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:2082
func WP_LobFire(_ `self`: Entity, _ start: JKAShared.vec3_t, _ target: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ clipmask: Int32, _ velocity: inout JKAShared.vec3_t, _ tracePath: Bool, _ ignoreEntNum: Int32, _ enemyNum: Int32, _ minSpeed: Float, _ maxSpeed: Float, _ idealSpeed: Float, _ mustHit: Bool) -> Bool {
    //for the galak mech NPC
    var targetDist: Float = 0
    var shotSpeed: Float = 0
    let speedInc: Float = 100
    var travelTime: Float = 0
    var impactDist: Float = 0
    var bestImpactDist: Float = Float(Q3_INFINITE)
    var targetDir = vec3_t()
    var shotVel = vec3_t()
    var failCase = vec3_t()
    // Raven assigns his own `minSpeed` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var minSpeed = minSpeed
    // Raven assigns his own `maxSpeed` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var maxSpeed = maxSpeed
    // Raven assigns his own `idealSpeed` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var idealSpeed = idealSpeed
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // Every path of Raven's block returns, so the closure's value is the function's.
        return Trajectory.scratch { tr -> Bool in
            var blocked: Bool = false
            var elapsedTime: Int32 = 0
            var skipNum: Int32 = 0
            let timeStep: Int32 = 500
            var hitCount: Int32 = 0
            let maxHits: Int32 = 7
            var lastPos = vec3_t()
            var testPos = vec3_t()
            var traceEnt: Entity?

            if idealSpeed == 0 {
                idealSpeed = 300
            } else if idealSpeed < speedInc {
                idealSpeed = speedInc
            }
            shotSpeed = idealSpeed
            skipNum = Int32((idealSpeed - speedInc) / speedInc)
            if minSpeed == 0 {
                minSpeed = 100
            }
            if maxSpeed == 0 {
                maxSpeed = 900
            }
            while hitCount < maxHits {
                targetDir = target - start
                targetDist = VectorNormalize(&targetDir)

                shotVel = targetDir * shotSpeed
                travelTime = targetDist / shotSpeed
                shotVel[2] = Float(Double(shotVel[2]) + Double(travelTime) * 0.5 * Double(g_gravity.value))

                if hitCount == 0 {
                    //save the first (ideal) one as the failCase (fallback value)
                    if !mustHit {
                        //default is fine as a return value
                        failCase = shotVel
                    }
                }

                if tracePath {
                    //do a rough trace of the path
                    blocked = false

                    tr.trBase = start
                    tr.trDelta = shotVel
                    tr.trType = TR_GRAVITY
                    tr.trTime = level.time
                    travelTime *= 1000.0
                    lastPos = start

                    //This may be kind of wasteful, especially on long throws... use larger steps?  Divide the travelTime into a certain hard number of slices?  Trace just to apex and down?
                    elapsedTime = timeStep
                    while elapsedTime < floor(travelTime) + timeStep {
                        if Float(elapsedTime) > travelTime {
                            //cap it
                            elapsedTime = Int32(floor(travelTime))
                        }
                        BG_EvaluateTrajectory(tr, level.time + elapsedTime, &testPos)
                        trap_Trace(trace, lastPos, mins, maxs, testPos, ignoreEntNum, clipmask)

                        if trace.allsolid != 0 || trace.startsolid != 0 {
                            blocked = true
                            break
                        }
                        if trace.fraction < 1.0 {
                            //hit something
                            if trace.entityNum == enemyNum {
                                //hit the enemy, that's perfect!
                                break
                            } else if Double(trace.plane.normal[2]) > 0.7 && DistanceSquared(trace.endpos, target) < 4096 {
                                //close enough!
                                break
                            } else {
                                //FIXME: maybe find the extents of this brush and go above or below it on next try somehow?
                                impactDist = DistanceSquared(trace.endpos, target)
                                if impactDist < bestImpactDist {
                                    bestImpactDist = impactDist
                                    failCase = shotVel
                                }
                                blocked = true
                                //see if we should store this as the failCase
                                if trace.entityNum < ENTITYNUM_WORLD {
                                    //hit an ent
                                    traceEnt = g_entities[trace.entityNum]
                                    if traceEnt != nil && traceEnt!.takedamage && !OnSameTeam(`self`, traceEnt!) {
                                        //hit something breakable, so that's okay
                                        //we haven't found a clear shot yet so use this as the failcase
                                        failCase = shotVel
                                    }
                                }
                                break
                            }
                        }
                        if elapsedTime == floor(travelTime) {
                            //reached end, all clear
                            break
                        } else {
                            //all clear, try next slice
                            lastPos = testPos
                        }
                        elapsedTime += timeStep
                    }
                    if blocked {
                        //hit something, adjust speed (which will change arc)
                        hitCount += 1
                        shotSpeed = idealSpeed + ((hitCount - skipNum) * speedInc) //from min to max (skipping ideal)
                        if hitCount >= skipNum {
                            //skip ideal since that was the first value we tested
                            shotSpeed += speedInc
                        }
                    } else {
                        //made it!
                        break
                    }
                } else {
                    //no need to check the path, go with first calc
                    break
                }
            }

            if hitCount >= maxHits {
                //NOTE: worst case scenario, use the one that impacted closest to the target (or just use the first try...?)
                velocity = failCase
                return false
            }
            velocity = shotVel
            return true
        }
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2244
func laserTrapExplode(_ `self`: Entity) {
    var v = vec3_t()
    `self`.takedamage = false

    if `self`.activator != nil {
        G_RadiusDamage(`self`.r.currentOrigin, `self`.activator!, Float(`self`.splashDamage), Float(`self`.splashRadius), `self`, `self`, MOD_TRIP_MINE_SPLASH)
    }

    if `self`.s.weapon != WP_FLECHETTE {
        G_AddEvent(`self`, EV_MISSILE_MISS, 0)
    }

    v = `self`.s.pos.trDelta
    //Explode outward from the surface

    if `self`.s.time == -2 {
        v[0] = 0
        v[1] = 0
        v[2] = 0
    }

    if `self`.s.weapon == WP_FLECHETTE {
        G_PlayEffect(EFFECT_EXPLOSION_FLECHETTE, `self`.r.currentOrigin, v)
    } else {
        G_PlayEffect(EFFECT_EXPLOSION_TRIPMINE, `self`.r.currentOrigin, v)
    }

    `self`.think = Think.G_FreeEntity
    `self`.nextthink = level.time
}

/// Source: oracle/codemp/game/g_weapon.c:2282
func laserTrapDelayedExplode(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ meansOfDeath: Int32) {
    `self`.enemy = attacker
    `self`.think = Think.laserTrapExplode
    `self`.nextthink = level.time + FRAMETIME
    `self`.takedamage = false
    if attacker.s.number == 0 {
        //less damage when shot by player
        `self`.splashDamage /= 3
        `self`.splashRadius /= 3
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2296
func touchLaserTrap(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if other.s.number < ENTITYNUM_WORLD {
        //just explode if we hit any entity. This way we don't have things happening like tripmines floating
        //in the air after getting stuck to a moving door
        if ent.activator != other {
            ent.touch = nil
            ent.nextthink = level.time + FRAMETIME
            ent.think = Think.laserTrapExplode
            ent.s.pos.trDelta = trace.plane.normal
        }
    } else {
        ent.touch = nil
        if trace.entityNum != ENTITYNUM_NONE {
            ent.enemy = g_entities[trace.entityNum]
        }
        laserTrapStick(ent, &trace.endpos, trace.plane.normal)
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2320
func proxMineThink(_ ent: Entity) {
    var i: Int32 = 0
    var cl: Entity?
    var owner: Entity? = nil

    if ent.r.ownerNum < ENTITYNUM_WORLD {
        owner = g_entities[ent.r.ownerNum]
    }

    ent.nextthink = level.time

    if ent.genericValue15 < level.time || owner == nil || !owner!.inuse || owner!.client == nil || owner!.client!.pers.connected != CON_CONNECTED {
        //time to die!
        ent.think = Think.laserTrapExplode
        return
    }

    while i < MAX_CLIENTS {
        //eh, just check for clients, don't care about anyone else...
        cl = g_entities[i]

        if cl!.inuse && cl!.client != nil && cl!.client!.pers.connected == CON_CONNECTED && owner != cl && cl!.client!.sess.sessionTeam != TEAM_SPECTATOR && cl!.client!.tempSpectate < level.time && cl!.health > 0 {
            if !OnSameTeam(owner!, cl!) || g_friendlyFire.integer != 0 {
                //not on the same team, or friendly fire is enabled
                var v = vec3_t()

                v = ent.r.currentOrigin - cl!.client!.ps.origin
                if VectorLength(v) < (ent.splashRadius / 2.0) {
                    ent.think = Think.laserTrapExplode
                    return
                }
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2367
func laserTrapThink(_ ent: Entity) {
    var traceEnt: Entity?
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in

        //just relink it every think
        trap_LinkEntity(ent)

        //turn on the beam effect
        if !((ent.s.eFlags & EF_FIRING) != 0) {
            //arm me
            G_Sound(ent, CHAN_WEAPON, G_SoundIndex("sound/weapons/laser_trap/warning.wav"))
            ent.s.eFlags |= EF_FIRING
        }
        ent.think = Think.laserTrapThink
        ent.nextthink = level.time + FRAMETIME

        // Find the main impact point
        _VectorMA(ent.s.pos.trBase, 1024, ent.movedir, &end)
        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("laserTrapThink", source: "oracle/codemp/game/g_weapon.c:2367")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("laserTrapThink", source: "oracle/codemp/game/g_weapon.c:2367")
        trap_Trace(tr, ent.r.currentOrigin, vec3_origin, vec3_origin, end, ent.s.number, MASK_SHOT)

        traceEnt = g_entities[tr.entityNum]

        ent.s.time = -1 //let all clients know to draw a beam from this guy

        if traceEnt!.client != nil || tr.startsolid != 0 {
            //go boom
            ent.touch = nil
            ent.nextthink = level.time + LT_DELAY_TIME
            ent.think = Think.laserTrapExplode
        }
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2402
func laserTrapStick(_ ent: Entity, _ endpos: inout JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    G_SetOrigin(ent, &endpos)
    ent.pos1 = normal

    ent.s.apos.trDelta = vec3_t()
    // This will orient the object to face in the direction of the normal
    ent.s.pos.trDelta = normal
    //VectorScale( normal, -1, ent->s.pos.trDelta );
    ent.s.pos.trTime = level.time


    //This does nothing, cg_missile makes assumptions about direction of travel controlling angles
    vectoangles(normal, &ent.s.apos.trBase)
    ent.s.apos.trDelta = vec3_t()
    ent.s.apos.trType = TR_STATIONARY
    ent.s.angles = ent.s.apos.trBase
    ent.r.currentAngles = ent.s.angles


    G_Sound(ent, CHAN_WEAPON, G_SoundIndex("sound/weapons/laser_trap/stick.wav"))
    if ent.count != 0 {
        //a tripwire
        //add draw line flag
        ent.movedir = normal
        ent.think = Think.laserTrapThink
        ent.nextthink = level.time + LT_ACTIVATION_DELAY //delay the activation
        ent.touch = Touch.touch_NULL
        //make it shootable
        ent.takedamage = true
        ent.health = 5
        ent.die = Die.laserTrapDelayedExplode

        //shove the box through the wall
        ent.r.mins = vec3_t(-LT_SIZE * 2, -LT_SIZE * 2, -LT_SIZE * 2)
        ent.r.maxs = vec3_t(LT_SIZE * 2, LT_SIZE * 2, LT_SIZE * 2)

        //so that the owner can blow it up with projectiles
        ent.r.svFlags |= SVF_OWNERNOTSHARED
    } else {
        ent.touch = Touch.touchLaserTrap
        ent.think = Think.proxMineThink //laserTrapExplode;
        ent.genericValue15 = level.time + 30000 //auto-explode after 30 seconds.
        ent.nextthink = level.time + LT_ALT_TIME // How long 'til she blows

        //make it shootable
        ent.takedamage = true
        ent.health = 5
        ent.die = Die.laserTrapDelayedExplode

        //shove the box through the wall
        ent.r.mins = vec3_t(-LT_SIZE * 2, -LT_SIZE * 2, -LT_SIZE * 2)
        ent.r.maxs = vec3_t(LT_SIZE * 2, LT_SIZE * 2, LT_SIZE * 2)

        //so that the owner can blow it up with projectiles
        ent.r.svFlags |= SVF_OWNERNOTSHARED

        if !((ent.s.eFlags & EF_FIRING) != 0) {
            //arm me
            G_Sound(ent, CHAN_WEAPON, G_SoundIndex("sound/weapons/laser_trap/warning.wav"))
            ent.s.eFlags |= EF_FIRING
            ent.s.time = -1
            ent.s.bolt2 = 1
        }
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2471
func TrapThink(_ ent: Entity) {
    //laser trap think
    ent.nextthink = level.time + 50
    G_RunObject(ent)
}

/// Source: oracle/codemp/game/g_weapon.c:2477
func CreateLaserTrap(_ laserTrap: Entity, _ start: JKAShared.vec3_t, _ owner: Entity) {
    //create a laser trap entity
    laserTrap.classname = "laserTrap"
    laserTrap.flags |= FL_BOUNCE_HALF
    laserTrap.s.eFlags |= EF_MISSILE_STICK
    laserTrap.splashDamage = LT_SPLASH_DAM
    laserTrap.splashRadius = Int32(LT_SPLASH_RAD)
    laserTrap.damage = LT_DAMAGE
    laserTrap.methodOfDeath = MOD_TRIP_MINE_SPLASH
    laserTrap.splashMethodOfDeath = MOD_TRIP_MINE_SPLASH
    laserTrap.s.eType = ET_GENERAL
    laserTrap.r.svFlags = SVF_USE_CURRENT_ORIGIN
    laserTrap.s.weapon = WP_TRIP_MINE
    laserTrap.s.pos.trType = TR_GRAVITY
    laserTrap.r.contents = MASK_SHOT
    laserTrap.parent = owner
    laserTrap.activator = owner
    laserTrap.r.ownerNum = owner.s.number
    laserTrap.r.mins = vec3_t(-LT_SIZE, -LT_SIZE, -LT_SIZE)
    laserTrap.r.maxs = vec3_t(LT_SIZE, LT_SIZE, LT_SIZE)
    laserTrap.clipmask = MASK_SHOT
    laserTrap.s.solid = 2
    laserTrap.s.modelindex = G_ModelIndex("models/weapons2/laser_trap/laser_trap_w.glm")
    laserTrap.s.modelGhoul2 = 1
    laserTrap.s.g2radius = 40

    laserTrap.s.genericenemyindex = owner.s.number + MAX_GENTITIES

    laserTrap.health = 1

    laserTrap.s.time = 0

    laserTrap.s.pos.trTime = level.time // move a bit on the very first frame
    laserTrap.s.pos.trBase = start
    SnapVector(&laserTrap.s.pos.trBase) // save net bandwidth

    SnapVector(&laserTrap.s.pos.trDelta) // save net bandwidth
    laserTrap.r.currentOrigin = start

    laserTrap.s.apos.trType = TR_GRAVITY
    laserTrap.s.apos.trTime = level.time
    // The SDK also declares `rand`, so the call names the bg module.
    laserTrap.s.apos.trBase[YAW] = Float(JKAMP_BG.rand() % 360)
    // The SDK also declares `rand`, so the call names the bg module.
    laserTrap.s.apos.trBase[PITCH] = Float(JKAMP_BG.rand() % 360)
    // The SDK also declares `rand`, so the call names the bg module.
    laserTrap.s.apos.trBase[ROLL] = Float(JKAMP_BG.rand() % 360)

    // The SDK also declares `rand`, so the call names the bg module.
    if JKAMP_BG.rand() % 10 < 5 {
        laserTrap.s.apos.trBase[YAW] = -laserTrap.s.apos.trBase[YAW]
    }

    laserTrap.pos2 = start
    laserTrap.touch = Touch.touchLaserTrap
    laserTrap.think = Think.TrapThink
    laserTrap.nextthink = level.time + 50
}

/// Source: oracle/codemp/game/g_weapon.c:2533
func WP_PlaceLaserTrap(_ ent: Entity, _ alt_fire: Bool) {
    var laserTrap: Entity?
    var found: Entity? = nil
    var dir = vec3_t()
    var start = vec3_t()
    var trapcount: Int32 = 0
    var foundLaserTraps: [Int32] = [Int32](repeating: 0, count: 1024)
    let trapcount_org: Int32
    var lowestTimeStamp: Int32
    var removeMe: Int32
    var i: Int32

    foundLaserTraps[0] = ENTITYNUM_NONE

    dir = forward
    start = muzzle

    laserTrap = G_Spawn()

    //limit to 10 placed at any one time
    //see how many there are now
    // Port-note: An assignment inside an expression.
    // Raven wrote: while ( (found = G_Find( found, FOFS(classname), "laserTrap" )) != NULL ) { if ( found->parent != ent ) { continue; } foundLaserTraps[trapcount++] = found->s.number; }
    portMissing("WP_PlaceLaserTrap", source: "oracle/codemp/game/g_weapon.c:2533")
    //now remove first ones we find until there are only 9 left
    found = nil
    trapcount_org = trapcount
    lowestTimeStamp = level.time
    while trapcount > 9 {
        removeMe = -1
        i = 0
        while i < trapcount_org {
            if foundLaserTraps[i] == ENTITYNUM_NONE {
                i += 1
                continue
            }
            found = g_entities[foundLaserTraps[i]]
            if laserTrap != nil && found!.setTime < lowestTimeStamp {
                removeMe = i
                lowestTimeStamp = found!.setTime
            }
            i += 1
        }
        if removeMe != -1 {
            //remove it... or blow it?
            if g_entities[foundLaserTraps[removeMe]] == nil {
                break
            } else {
                G_FreeEntity(g_entities[foundLaserTraps[removeMe]])
            }
            foundLaserTraps[removeMe] = ENTITYNUM_NONE
            trapcount -= 1
        } else {
            break
        }
    }

    //now make the new one
    CreateLaserTrap(laserTrap!, start, ent)

    //set player-created-specific fields
    laserTrap!.setTime = level.time //remember when we placed it

    if !alt_fire {
        //tripwire
        laserTrap!.count = 1
    }

    //move it
    laserTrap!.s.pos.trType = TR_GRAVITY

    if alt_fire {
        laserTrap!.s.pos.trDelta = dir * 512
    } else {
        laserTrap!.s.pos.trDelta = dir * 256
    }

    trap_LinkEntity(laserTrap!)
}

/**
```
======================================================================

DET PACK

======================================================================
```
*/
/// Source: oracle/codemp/game/g_weapon.c:2636
func VectorNPos(_ `in`: JKAShared.vec3_t, _ out: inout JKAShared.vec3_t) {
    if `in`[0] < 0 {
        out[0] = -`in`[0]
    } else {
        out[0] = `in`[0]
    }
    if `in`[1] < 0 {
        out[1] = -`in`[1]
    } else {
        out[1] = `in`[1]
    }
    if `in`[2] < 0 {
        out[2] = -`in`[2]
    } else {
        out[2] = `in`[2]
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2645
func charge_stick(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    var tent: Entity?

    if (other.flags & FL_BBRUSH) != 0 && other.s.pos.trType == TR_STATIONARY && other.s.apos.trType == TR_STATIONARY {
        //a perfectly still breakable brush, let us attach directly to it!
        `self`.target_ent = other //remember them when we blow up
    } else if other.s.number < ENTITYNUM_WORLD && other.s.eType == ET_MOVER && trace.plane.normal[2] > 0 {
        //stick to it?
        `self`.s.groundEntityNum = other.s.number
    } else if other.s.number < ENTITYNUM_WORLD && (other.client != nil || other.s.weapon == 0) {
        //hit another entity that is not stickable, "bounce" off
        var vNor = vec3_t()
        var tN = vec3_t()

        vNor = trace.plane.normal
        VectorNormalize(&vNor)
        VectorNPos(`self`.s.pos.trDelta, &tN)
        `self`.s.pos.trDelta[0] = Float(Double(`self`.s.pos.trDelta[0]) + Double(vNor[0]) * (Double(tN[0]) * ((Double(Float(Q_irand(1, 10)))) * 0.1)))
        `self`.s.pos.trDelta[1] = Float(Double(`self`.s.pos.trDelta[1]) + Double(vNor[1]) * (Double(tN[1]) * ((Double(Float(Q_irand(1, 10)))) * 0.1)))
        `self`.s.pos.trDelta[2] = Float(Double(`self`.s.pos.trDelta[2]) + Double(vNor[1]) * (Double(tN[2]) * ((Double(Float(Q_irand(1, 10)))) * 0.1)))

        vectoangles(vNor, &`self`.s.angles)
        vectoangles(vNor, &`self`.s.apos.trBase)
        `self`.touch = Touch.charge_stick
        return
    } else if other.s.number < ENTITYNUM_WORLD {
        //hit an entity that we just want to explode on (probably another projectile or something)
        var v = vec3_t()

        `self`.touch = nil
        `self`.think = nil
        `self`.nextthink = 0

        `self`.takedamage = false

        `self`.s.apos.trDelta = vec3_t()
        `self`.s.apos.trType = TR_STATIONARY

        G_RadiusDamage(`self`.r.currentOrigin, `self`.parent!, Float(`self`.splashDamage), Float(`self`.splashRadius), `self`, `self`, MOD_DET_PACK_SPLASH)
        v = trace.plane.normal
        `self`.pos2 = v
        `self`.count = -1
        G_PlayEffect(EFFECT_EXPLOSION_DETPACK, `self`.r.currentOrigin, v)

        `self`.think = Think.G_FreeEntity
        `self`.nextthink = level.time
        return
    }

    //if we get here I guess we hit hte world so we can stick to it

    `self`.touch = nil
    `self`.think = Think.DetPackBlow
    `self`.nextthink = level.time + 30000

    `self`.s.apos.trDelta = vec3_t()
    `self`.s.apos.trType = TR_STATIONARY

    `self`.s.pos.trType = TR_STATIONARY
    `self`.s.origin = `self`.r.currentOrigin
    `self`.s.pos.trBase = `self`.r.currentOrigin
    `self`.s.pos.trDelta = vec3_t()

    `self`.s.apos.trDelta = vec3_t()

    VectorNormalize(&trace.plane.normal)

    vectoangles(trace.plane.normal, &`self`.s.angles)
    `self`.r.currentAngles = `self`.s.angles
    `self`.s.apos.trBase = `self`.s.angles

    `self`.pos2 = trace.plane.normal
    `self`.count = -1

    G_Sound(`self`, CHAN_WEAPON, G_SoundIndex("sound/weapons/detpack/stick.wav"))

    tent = G_TempEntity(`self`.r.currentOrigin, EV_MISSILE_MISS)
    tent!.s.weapon = 0
    tent!.parent = `self`
    tent!.r.ownerNum = `self`.s.number

    //so that the owner can blow it up with projectiles
    `self`.r.svFlags |= SVF_OWNERNOTSHARED
}

/// Source: oracle/codemp/game/g_weapon.c:2740
func DetPackBlow(_ `self`: Entity) {
    var v = vec3_t()

    `self`.pain = nil
    `self`.die = nil
    `self`.takedamage = false

    if `self`.target_ent != nil {
        //we were attached to something, do *direct* damage to it!
        G_Damage(`self`.target_ent!, `self`, g_entities[`self`.r.ownerNum], &v, `self`.r.currentOrigin, `self`.damage, 0, MOD_DET_PACK_SPLASH)
    }
    G_RadiusDamage(`self`.r.currentOrigin, `self`.parent!, Float(`self`.splashDamage), Float(`self`.splashRadius), `self`, `self`, MOD_DET_PACK_SPLASH)
    v[0] = 0
    v[1] = 0
    v[2] = 1

    if `self`.count == -1 {
        v = `self`.pos2
    }

    G_PlayEffect(EFFECT_EXPLOSION_DETPACK, `self`.r.currentOrigin, v)

    `self`.think = Think.G_FreeEntity
    `self`.nextthink = level.time
}

/// Source: oracle/codemp/game/g_weapon.c:2768
func DetPackPain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    `self`.think = Think.DetPackBlow
    `self`.nextthink = level.time + Q_irand(50, 100)
    `self`.takedamage = false
}

/// Source: oracle/codemp/game/g_weapon.c:2775
func DetPackDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    `self`.think = Think.DetPackBlow
    `self`.nextthink = level.time + Q_irand(50, 100)
    `self`.takedamage = false
}

/// Source: oracle/codemp/game/g_weapon.c:2782
func drop_charge(_ `self`: Entity, _ start: inout JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t) {
    var bolt: Entity?

    VectorNormalize(&dir)

    bolt = G_Spawn()
    bolt!.classname = "detpack"
    bolt!.nextthink = level.time + FRAMETIME
    bolt!.think = Think.G_RunObject
    bolt!.s.eType = ET_GENERAL
    bolt!.s.g2radius = 100
    bolt!.s.modelGhoul2 = 1
    bolt!.s.modelindex = G_ModelIndex("models/weapons2/detpack/det_pack_proj.glm")

    bolt!.parent = `self`
    bolt!.r.ownerNum = `self`.s.number
    bolt!.damage = 100
    bolt!.splashDamage = 200
    bolt!.splashRadius = 200
    bolt!.methodOfDeath = MOD_DET_PACK_SPLASH
    bolt!.splashMethodOfDeath = MOD_DET_PACK_SPLASH
    bolt!.clipmask = MASK_SHOT
    bolt!.s.solid = 2
    bolt!.r.contents = MASK_SHOT
    bolt!.touch = Touch.charge_stick

    bolt!.physicsObject = true

    bolt!.s.genericenemyindex = `self`.s.number + MAX_GENTITIES
    //rww - so client prediction knows we own this and won't hit it

    bolt!.r.mins = vec3_t(-2, -2, -2)
    bolt!.r.maxs = vec3_t(2, 2, 2)

    bolt!.health = 1
    bolt!.takedamage = true
    bolt!.pain = Pain.DetPackPain
    bolt!.die = Die.DetPackDie

    bolt!.s.weapon = WP_DET_PACK

    bolt!.setTime = level.time

    G_SetOrigin(bolt!, &start)
    bolt!.s.pos.trType = TR_GRAVITY
    bolt!.s.pos.trBase = start
    bolt!.s.pos.trDelta = dir * 300
    bolt!.s.pos.trTime = level.time

    bolt!.s.apos.trType = TR_GRAVITY
    bolt!.s.apos.trTime = level.time
    // The SDK also declares `rand`, so the call names the bg module.
    bolt!.s.apos.trBase[YAW] = Float(JKAMP_BG.rand() % 360)
    // The SDK also declares `rand`, so the call names the bg module.
    bolt!.s.apos.trBase[PITCH] = Float(JKAMP_BG.rand() % 360)
    // The SDK also declares `rand`, so the call names the bg module.
    bolt!.s.apos.trBase[ROLL] = Float(JKAMP_BG.rand() % 360)

    // The SDK also declares `rand`, so the call names the bg module.
    if JKAMP_BG.rand() % 10 < 5 {
        bolt!.s.apos.trBase[YAW] = -bolt!.s.apos.trBase[YAW]
    }

    vectoangles(dir, &bolt!.s.angles)
    bolt!.s.apos.trBase = bolt!.s.angles
    bolt!.s.apos.trDelta = vec3_t(300, 0, 0)
    bolt!.s.apos.trTime = level.time

    trap_LinkEntity(bolt!)
}

/// Source: oracle/codemp/game/g_weapon.c:2851
func BlowDetpacks(_ ent: Entity) {
    var found: Entity? = nil

    if ent.client!.ps.hasDetPackPlanted {
        // Port-note: An assignment inside an expression.
        // Raven wrote: while ( (found = G_Find( found, FOFS(classname), "detpack") ) != NULL ) {//loop through all ents and blow the crap out of them! if ( found->parent == ent ) { VectorCopy( found->r.currentOrigin, found->s.origin ); found->think = DetPackBlow; found->nextthink = level.time + 100 + random() * 200; G_Sound( found, CHAN_BODY, G_SoundIndex("sound/weapons/detpack/warning.wav") ); } }
        portMissing("BlowDetpacks", source: "oracle/codemp/game/g_weapon.c:2851")
        ent.client!.ps.hasDetPackPlanted = false
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2871
func CheatsOn() -> Bool {
    if g_cheats.integer == 0 {
        return false
    }
    return true
}

/// Source: oracle/codemp/game/g_weapon.c:2880
func WP_DropDetPack(_ ent: Entity, _ alt_fire: Bool) {
    var found: Entity? = nil
    var trapcount: Int32 = 0
    var foundDetPacks: [Int32] = [ENTITYNUM_NONE, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    let trapcount_org: Int32
    var lowestTimeStamp: Int32
    var removeMe: Int32
    var i: Int32

    if ent.client == nil {
        return
    }

    //limit to 10 placed at any one time
    //see how many there are now
    // Port-note: An assignment inside an expression.
    // Raven wrote: while ( (found = G_Find( found, FOFS(classname), "detpack" )) != NULL ) { if ( found->parent != ent ) { continue; } foundDetPacks[trapcount++] = found->s.number; }
    portMissing("WP_DropDetPack", source: "oracle/codemp/game/g_weapon.c:2880")
    //now remove first ones we find until there are only 9 left
    found = nil
    trapcount_org = trapcount
    lowestTimeStamp = level.time
    while trapcount > 9 {
        removeMe = -1
        i = 0
        while i < trapcount_org {
            if foundDetPacks[i] == ENTITYNUM_NONE {
                i += 1
                continue
            }
            found = g_entities[foundDetPacks[i]]
            if found!.setTime < lowestTimeStamp {
                removeMe = i
                lowestTimeStamp = found!.setTime
            }
            i += 1
        }
        if removeMe != -1 {
            //remove it... or blow it?
            if g_entities[foundDetPacks[removeMe]] == nil {
                break
            } else {
                if !CheatsOn() {
                    //Let them have unlimited if cheats are enabled
                    G_FreeEntity(g_entities[foundDetPacks[removeMe]])
                }
            }
            foundDetPacks[removeMe] = ENTITYNUM_NONE
            trapcount -= 1
        } else {
            break
        }
    }

    if alt_fire {
        BlowDetpacks(ent)
    } else {
        AngleVectors(ent.client!.ps.viewangles, &forward, &vright, &up)

        CalcMuzzlePoint(ent, forward, vright, up, &muzzle)

        VectorNormalize(&forward)
        _VectorMA(muzzle, -4, forward, &muzzle)
        drop_charge(ent, &muzzle, &forward)

        ent.client!.ps.hasDetPackPlanted = true
    }
}

/// Source: oracle/codemp/game/g_weapon.c:2967
private func WP_FireConcussionAlt(_ ent: Entity) {
    //a rail-gun-like beam
    let damage: Int32 = CONC_ALT_DAMAGE
    var skip: Int32 = 0
    let traces: Int32 = DISRUPTOR_ALT_TRACES
    var render_impact: Bool = true
    var start = vec3_t()
    var end = vec3_t()
    var muzzle2 = vec3_t()
    var dir = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in
        var traceEnt: Entity?
        var tent: Entity?
        let shotRange: Float = 8192.0
        var hitDodged: Bool = false
        var shot_mins = vec3_t()
        var shot_maxs = vec3_t()
        var i: Int32 = 0

        //Shove us backwards for half a second
        _VectorMA(ent.client!.ps.velocity, -200, forward, &ent.client!.ps.velocity)
        ent.client!.ps.groundEntityNum = ENTITYNUM_NONE
        if (ent.client!.ps.pm_flags & PMF_DUCKED) != 0 {
            //hunkered down
            ent.client!.ps.pm_time = 100
        } else {
            ent.client!.ps.pm_time = 250
        }
        //	ent->client->ps.pm_flags |= PMF_TIME_KNOCKBACK|PMF_TIME_NOFRICTION;
        //FIXME: only if on ground?  So no "rocket jump"?  Or: (see next FIXME)
        //FIXME: instead, set a forced ucmd backmove instead of this sliding

        muzzle2 = muzzle // making a backup copy

        start = muzzle
        WP_TraceSetStart(ent, &start, vec3_origin, vec3_origin)

        skip = ent.s.number

        //	if ( ent->client && ent->client->ps.powerups[PW_WEAPON_OVERCHARGE] > 0 && ent->client->ps.powerups[PW_WEAPON_OVERCHARGE] > cg.time )
        //	{
        //		// in overcharge mode, so doing double damage
        //		damage *= 2;
        //	}

        //Make it a little easier to hit guys at long range
        shot_mins = vec3_t(-1, -1, -1)
        shot_maxs = vec3_t(1, 1, 1)

        i = 0
        while i < traces {
            _VectorMA(start, shotRange, forward, &end)

            //NOTE: if you want to be able to hit guys in emplaced guns, use "G2_COLLIDE, 10" instead of "G2_RETURNONHIT, 0"
            //alternately, if you end up hitting an emplaced_gun that has a sitter, just redo this one trace with the "G2_COLLIDE, 10" to see if we it the sitter
            //gi.trace( &tr, start, NULL, NULL, end, skip, MASK_SHOT, G2_COLLIDE, 10 );//G2_RETURNONHIT, 0 );
            if d_projectileGhoul2Collision.integer != 0 {
                trap_G2Trace(tr, start, shot_mins, shot_maxs, end, skip, MASK_SHOT, G2TRFLAG_DOGHOULTRACE | G2TRFLAG_GETSURFINDEX | G2TRFLAG_HITCORPSES, g_g2TraceLod.integer)
            } else {
                trap_Trace(tr, start, shot_mins, shot_maxs, end, skip, MASK_SHOT)
            }

            traceEnt = g_entities[tr.entityNum]

            if d_projectileGhoul2Collision.integer != 0 && traceEnt!.inuse && traceEnt!.client != nil {
                //g2 collision checks -rww
                if traceEnt!.inuse && traceEnt!.client != nil && traceEnt!.ghoul2 != nil {
                    //since we used G2TRFLAG_GETSURFINDEX, tr.surfaceFlags will actually contain the index of the surface on the ghoul2 model we collided with.
                    traceEnt!.client!.g2LastSurfaceHit = tr.surfaceFlags
                    traceEnt!.client!.g2LastSurfaceTime = level.time
                }

                if traceEnt!.ghoul2 != nil {
                    tr.surfaceFlags = 0 //clear the surface flags after, since we actually care about them in here.
                }
            }
            if (tr.surfaceFlags & SURF_NOIMPACT) != 0 {
                render_impact = false
            }

            if tr.entityNum == ent.s.number {
                // should never happen, but basically we don't want to consider a hit to ourselves?
                // Get ready for an attempt to trace through another person
                muzzle2 = tr.endpos
                start = tr.endpos
                skip = tr.entityNum
                i += 1
                continue
            }

            // always render a shot beam, doing this the old way because I don't much feel like overriding the effect.
            //NOTE: let's just draw one beam at the end
            //tent = G_TempEntity( tr.endpos, EV_CONC_ALT_SHOT );
            //tent->svFlags |= SVF_BROADCAST;

            //VectorCopy( muzzle2, tent->s.origin2 );

            if tr.fraction >= 1.0 {
                // draw the beam but don't do anything else
                break
            }

            if traceEnt!.s.weapon == WP_SABER {
                //FIXME: need a more reliable way to know we hit a jedi?
                hitDodged = Jedi_DodgeEvasion(traceEnt!, ent, tr, HL_NONE)
                //acts like we didn't even hit him
            }
            if !hitDodged {
                if render_impact {
                    if (tr.entityNum < ENTITYNUM_WORLD && traceEnt!.takedamage) || Q_stricmp(traceEnt!.classname!, "misc_model_breakable") == 0 || traceEnt!.s.eType == ET_MOVER {
                        var noKnockBack: Bool = false

                        // Create a simple impact type mark that doesn't last long in the world
                        //G_PlayEffectID( G_EffectIndex( "concussion/alt_hit" ), tr.endpos, tr.plane.normal );
                        //no no no

                        if traceEnt!.client != nil && LogAccuracyHit(traceEnt!, ent) {
                            //NOTE: hitting multiple ents can still get you over 100% accuracy
                            ent.client!.accuracy_hits += 1
                        }

                        noKnockBack = (traceEnt!.flags & FL_NO_KNOCKBACK) != 0 //will be set if they die, I want to know if it was on *before* they died
                        if traceEnt != nil && traceEnt!.client != nil && traceEnt!.client!.NPC_class == CLASS_GALAKMECH {
                            //hehe
                            G_Damage(traceEnt!, ent, ent, &forward, tr.endpos, 10, DAMAGE_NO_KNOCKBACK | DAMAGE_NO_HIT_LOC, MOD_CONC_ALT)
                            break
                        }
                        G_Damage(traceEnt!, ent, ent, &forward, tr.endpos, damage, DAMAGE_NO_KNOCKBACK | DAMAGE_NO_HIT_LOC, MOD_CONC_ALT)

                        //do knockback and knockdown manually
                        if traceEnt!.client != nil {
                            //only if we hit a client
                            var pushDir = vec3_t()
                            pushDir = forward
                            if pushDir[2] < 0.2 {
                                pushDir[2] = 0.2
                            }
                            /*
                            if ( !noKnockBack )
                            {//knock-backable
                            G_Throw( traceEnt, pushDir, 200 );
                            }
                            */
                            if traceEnt!.health > 0 {
                                //alive
                                //if ( G_HasKnockdownAnims( traceEnt ) )
                                if !noKnockBack && traceEnt!.localAnimIndex == 0 && traceEnt!.client!.ps.forceHandExtend != HANDEXTEND_KNOCKDOWN && BG_KnockDownable(traceEnt!.client!.ps) {
                                    //knock-downable
                                    //G_Knockdown( traceEnt, ent, pushDir, 400, qtrue );
                                    var plPDif = vec3_t()
                                    var pStr: Float = 0

                                    //cap it and stuff, base the strength and whether or not we can knockdown on the distance
                                    //from the shooter to the target
                                    plPDif = traceEnt!.client!.ps.origin - ent.client!.ps.origin
                                    pStr = 500.0 - VectorLength(plPDif)
                                    if pStr < 150.0 {
                                        pStr = 150.0
                                    }
                                    if pStr > 200.0 {
                                        traceEnt!.client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
                                        traceEnt!.client!.ps.forceHandExtendTime = level.time + 1100
                                        traceEnt!.client!.ps.forceDodgeAnim = 0 //this toggles between 1 and 0, when it's 1 we should play the get up anim
                                    }
                                    traceEnt!.client!.ps.otherKiller = ent.s.number
                                    traceEnt!.client!.ps.otherKillerTime = level.time + 5000
                                    traceEnt!.client!.ps.otherKillerDebounceTime = level.time + 100
                                    traceEnt!.client!.otherKillerMOD = MOD_UNKNOWN
                                    traceEnt!.client!.otherKillerVehWeapon = 0
                                    traceEnt!.client!.otherKillerWeaponType = WP_NONE

                                    traceEnt!.client!.ps.velocity[0] += pushDir[0] * pStr
                                    traceEnt!.client!.ps.velocity[1] += pushDir[1] * pStr
                                    traceEnt!.client!.ps.velocity[2] = pStr
                                }
                            }
                        }

                        if traceEnt!.s.eType == ET_MOVER {
                            //stop the traces on any mover
                            break
                        }
                    } else {
                        // we only make this mark on things that can't break or move
                        //	tent = G_TempEntity(tr.endpos, EV_MISSILE_MISS);
                        //	tent->s.eventParm = DirToByte(tr.plane.normal);
                        //	tent->s.eFlags |= EF_ALT_FIRING;

                        //tent->svFlags |= SVF_BROADCAST;
                        //eh? why broadcast?
                        //	VectorCopy( tr.plane.normal, tent->pos1 );

                        //mmm..no..don't do this more than once for no reason whatsoever.
                        break // hit solid, but doesn't take damage, so stop the shot...we _could_ allow it to shoot through walls, might be cool?
                    }
                } else {
                    break // don't try anymore traces
                }
            }
            // Get ready for an attempt to trace through another person
            muzzle2 = tr.endpos
            start = tr.endpos
            skip = tr.entityNum
            hitDodged = false
            i += 1
        }
        //just draw one beam all the way to the end
        //	tent = G_TempEntity( tr.endpos, EV_CONC_ALT_SHOT );
        //	tent->svFlags |= SVF_BROADCAST;
        //again, why broadcast?

        //	tent = G_TempEntity(tr.endpos, EV_MISSILE_MISS);
        //	tent->s.eventParm = DirToByte(tr.plane.normal);
        //	tent->s.eFlags |= EF_ALT_FIRING;
        //	VectorCopy( muzzle, tent->s.origin2 );

        // now go along the trail and make sight events
        dir = tr.endpos - muzzle

        //	shotDist = VectorNormalize( dir );

        //let's pack all this junk into a single tempent, and send it off.
        tent = G_TempEntity(tr.endpos, EV_CONC_ALT_IMPACT)
        tent!.s.eventParm = DirToByte(tr.plane.normal)
        tent!.s.owner = ent.s.number
        tent!.s.angles = dir
        tent!.s.origin2 = muzzle
        tent!.s.angles2 = forward

        //FIXME: if shoot *really* close to someone, the alert could be way out of their FOV
        //FIXME: on a really long shot, this could make a LOT of alerts in one frame...
        //FIXME: creates *way* too many effects, make it one effect somehow?
        //FIXME: spawn a temp ent that continuously spawns sight alerts here?  And 1 sound alert to draw their attention?
    }
}

/// Source: oracle/codemp/game/g_weapon.c:3232
private func WP_FireConcussion(_ ent: Entity) {
    //a fast rocket-like projectile
    var start = vec3_t()
    let damage: Int32 = CONC_DAMAGE
    let vel: Float = Float(CONC_VELOCITY)
    var missile: Entity?

    //hold us still for a bit
    //ent->client->ps.pm_time = 300;
    //ent->client->ps.pm_flags |= PMF_TIME_KNOCKBACK;
    //add viewkick
    //	if ( ent->s.number < MAX_CLIENTS//player only
    //		&& !cg.renderingThirdPerson )//gives an advantage to being in 3rd person, but would look silly otherwise
    //	{//kick the view back
    //		cg.kick_angles[PITCH] = Q_flrand( -10, -15 );
    //		cg.kick_time = level.time;
    //	}
    //mm..yeah..this needs some reworking for mp

    start = muzzle
    WP_TraceSetStart(ent, &start, vec3_origin, vec3_origin) //make sure our start point isn't on the other side of a wall

    missile = CreateMissile(&start, forward, vel, 10000, ent, false)

    missile!.classname = "conc_proj"
    missile!.s.weapon = WP_CONCUSSION
    missile!.mass = 10

    // Make it easier to hit things
    missile!.r.maxs = vec3_t(Float(ROCKET_SIZE), Float(ROCKET_SIZE), Float(ROCKET_SIZE))
    missile!.r.mins = missile!.r.maxs * -1

    missile!.damage = damage
    missile!.dflags = DAMAGE_EXTRA_KNOCKBACK

    missile!.methodOfDeath = MOD_CONC
    missile!.splashMethodOfDeath = MOD_CONC

    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
    missile!.splashDamage = CONC_SPLASH_DAMAGE
    missile!.splashRadius = CONC_SPLASH_RADIUS

    // we don't want it to ever bounce
    missile!.bounceCount = 0
}

//---------------------------------------------------------
// FireStunBaton
//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:3282
func WP_FireStunBaton(_ ent: Entity, _ alt_fire: Bool) {
    var tr_ent: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var mins = vec3_t()
        var maxs = vec3_t()
        var end = vec3_t()
        var muzzleStun = vec3_t()

        if ent.client == nil {
            muzzleStun = ent.r.currentOrigin
            muzzleStun[2] += 8
        } else {
            muzzleStun = ent.client!.ps.origin
            muzzleStun[2] += ent.client!.ps.viewheight - 6
        }

        _VectorMA(muzzleStun, 20.0, forward, &muzzleStun)
        _VectorMA(muzzleStun, 4.0, vright, &muzzleStun)

        _VectorMA(muzzleStun, Float(STUN_BATON_RANGE), forward, &end)

        maxs = vec3_t(6, 6, 6)
        mins = maxs * -1

        trap_Trace(tr, muzzleStun, mins, maxs, end, ent.s.number, MASK_SHOT)

        if tr.entityNum >= ENTITYNUM_WORLD {
            return true
        }

        tr_ent = g_entities[tr.entityNum]

        if tr_ent != nil && tr_ent!.takedamage && tr_ent!.client != nil {
            //see if either party is involved in a duel
            if tr_ent!.client!.ps.duelInProgress && tr_ent!.client!.ps.duelIndex != ent.s.number {
                return true
            }

            if ent.client != nil && ent.client!.ps.duelInProgress && ent.client!.ps.duelIndex != tr_ent!.s.number {
                return true
            }
        }

        if tr_ent != nil && tr_ent!.takedamage {
            G_PlayEffect(EFFECT_STUNHIT, tr.endpos, tr.plane.normal)

            G_Sound(tr_ent!, CHAN_WEAPON, G_SoundIndex(va("sound/weapons/melee/punch%d", Q_irand(1, 4))))
            G_Damage(tr_ent!, ent, ent, &forward, tr.endpos, STUN_BATON_DAMAGE, (DAMAGE_NO_KNOCKBACK | DAMAGE_HALF_ABSORB), MOD_STUN_BATON)

            if tr_ent!.client != nil {
                //if it's a player then use the shock effect
                if tr_ent!.client!.NPC_class == CLASS_VEHICLE {
                    //not on vehicles
                    if tr_ent!.m_pVehicle == nil || tr_ent!.m_pVehicle!.m_pVehicleInfo!.type == VH_ANIMAL || tr_ent!.m_pVehicle!.m_pVehicleInfo!.type == VH_FLIER {
                        //can zap animals
                        tr_ent!.client!.ps.electrifyTime = level.time + Q_irand(3000, 4000)
                    }
                } else {
                    tr_ent!.client!.ps.electrifyTime = level.time + 700
                }
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

//---------------------------------------------------------
// FireMelee
//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:3363
func WP_FireMelee(_ ent: Entity, _ alt_fire: Bool) {
    var tr_ent: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var mins = vec3_t()
        var maxs = vec3_t()
        var end = vec3_t()
        var muzzlePunch = vec3_t()

        if ent.client != nil && ent.client!.ps.torsoAnim == BOTH_MELEE2 {
            //right
            if (ent.client!.ps.brokenLimbs & (1 << BROKENLIMB_RARM)) != 0 {
                return true
            }
        } else {
            //left
            if (ent.client!.ps.brokenLimbs & (1 << BROKENLIMB_LARM)) != 0 {
                return true
            }
        }

        if ent.client == nil {
            muzzlePunch = ent.r.currentOrigin
            muzzlePunch[2] += 8
        } else {
            muzzlePunch = ent.client!.ps.origin
            muzzlePunch[2] += ent.client!.ps.viewheight - 6
        }

        _VectorMA(muzzlePunch, 20.0, forward, &muzzlePunch)
        _VectorMA(muzzlePunch, 4.0, vright, &muzzlePunch)

        _VectorMA(muzzlePunch, Float(MELEE_RANGE), forward, &end)

        maxs = vec3_t(6, 6, 6)
        mins = maxs * -1

        trap_Trace(tr, muzzlePunch, mins, maxs, end, ent.s.number, MASK_SHOT)

        if tr.entityNum != ENTITYNUM_NONE {
            //hit something
            tr_ent = g_entities[tr.entityNum]

            G_Sound(ent, CHAN_AUTO, G_SoundIndex(va("sound/weapons/melee/punch%d", Q_irand(1, 4))))

            if tr_ent!.takedamage && tr_ent!.client != nil {
                //special duel checks
                if tr_ent!.client!.ps.duelInProgress && tr_ent!.client!.ps.duelIndex != ent.s.number {
                    return true
                }

                if ent.client != nil && ent.client!.ps.duelInProgress && ent.client!.ps.duelIndex != tr_ent!.s.number {
                    return true
                }
            }

            if tr_ent!.takedamage {
                //damage them, do more damage if we're in the second right hook
                var dmg: Int32 = MELEE_SWING1_DAMAGE

                if ent.client != nil && ent.client!.ps.torsoAnim == BOTH_MELEE2 {
                    //do a tad bit more damage on the second swing
                    dmg = MELEE_SWING2_DAMAGE
                }

                if G_HeavyMelee(ent) {
                    //2x damage for heavy melee class
                    dmg *= 2
                }

                G_Damage(tr_ent!, ent, ent, &forward, tr.endpos, dmg, DAMAGE_NO_ARMOR, MOD_MELEE)
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
======================
SnapVectorTowards

Round a vector to integers for more efficient network
transmission, but make sure that it rounds towards a given point
rather than blindly truncating.  This prevents it from truncating
into a wall.
======================
```
*/
/// Source: oracle/codemp/game/g_weapon.c:3464
func SnapVectorTowards(_ v: inout JKAShared.vec3_t, _ to: JKAShared.vec3_t) {
    var i: Int32

    i = 0
    while i < 3 {
        if to[i] <= v[i] {
            v[i] = Float(Int32(v[i]))
        } else {
            v[i] = Float(Int32(v[i]) + 1)
        }
        i += 1
    }
}

/**
```
===============
LogAccuracyHit
===============
```
*/
/// Source: oracle/codemp/game/g_weapon.c:3485
func LogAccuracyHit(_ target: Entity, _ attacker: Entity) -> Bool {
    if !target.takedamage {
        return false
    }

    if target == attacker {
        return false
    }

    if target.client == nil {
        return false
    }


    if attacker.client == nil {
        return false
    }

    if target.client!.ps.stats[STAT_HEALTH] <= 0 {
        return false
    }

    if OnSameTeam(target, attacker) {
        return false
    }

    return true
}

/**
```
===============
CalcMuzzlePoint

set muzzle location relative to pivoting eye
rwwFIXMEFIXME: Since ghoul2 models are on server and properly updated now,
it may be reasonable to base muzzle point off actual weapon bolt point.
The down side would be that it does not necessarily look alright from a
first person perspective.
===============
```
*/
/// Source: oracle/codemp/game/g_weapon.c:3530
func CalcMuzzlePoint(_ ent: Entity, _ forward: JKAShared.vec3_t, _ right: JKAShared.vec3_t, _ up: JKAShared.vec3_t, _ muzzlePoint: inout JKAShared.vec3_t) {
    let weapontype: Int32
    var muzzleOffPoint = vec3_t()

    weapontype = ent.s.weapon
    muzzlePoint = ent.s.pos.trBase

    muzzleOffPoint = WP_MuzzlePoint[weapontype]

    if weapontype > WP_NONE && weapontype < WP_NUM_WEAPONS {
        // Use the table to generate the muzzlepoint;
        do {
            // Crouching.  Use the add-to-Z method to adjust vertically.
            _VectorMA(muzzlePoint, muzzleOffPoint[0], forward, &muzzlePoint)
            _VectorMA(muzzlePoint, muzzleOffPoint[1], right, &muzzlePoint)
            muzzlePoint[2] += ent.client!.ps.viewheight + muzzleOffPoint[2]
        }
    }

    // snap to integer coordinates for more efficient network bandwidth usage
    SnapVector(&muzzlePoint)
}

/**
```
===============
CalcMuzzlePointOrigin

set muzzle location relative to pivoting eye
===============
```
*/
/// Source: oracle/codemp/game/g_weapon.c:3560
func CalcMuzzlePointOrigin(_ ent: Entity, _ origin: JKAShared.vec3_t, _ forward: JKAShared.vec3_t, _ right: JKAShared.vec3_t, _ up: JKAShared.vec3_t, _ muzzlePoint: inout JKAShared.vec3_t) {
    muzzlePoint = ent.s.pos.trBase
    muzzlePoint[2] += ent.client!.ps.viewheight
    _VectorMA(muzzlePoint, 14, forward, &muzzlePoint)
    // snap to integer coordinates for more efficient network bandwidth usage
    SnapVector(&muzzlePoint)
}

/// Source: oracle/codemp/game/g_weapon.c:3569
func WP_TouchVehMissile(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { myTrace in
        myTrace.copy(from: trace)
        myTrace.entityNum = other.s.number
        G_MissileImpact(ent, myTrace)
    }
}

/// Source: oracle/codemp/game/g_weapon.c:3580
func WP_CalcVehMuzzle(_ ent: Entity, _ muzzleNum: Int32) {
    let pVeh: Vehicle? = ent.m_pVehicle
    // Port-note: The draft of this statement did not compile, and the compiler wrote "failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs)".
    // Raven wrote: mdxaBone_t boltMatrix;
    portMissing("WP_CalcVehMuzzle", source: "oracle/codemp/game/g_weapon.c:3580")
    var vehAngles = vec3_t()


    if pVeh!.m_iMuzzleTime[muzzleNum] == level.time {
        //already done for this frame, don't need to do it again
        return
    }
    //Uh... how about we set this, hunh...?  :)
    pVeh!.m_iMuzzleTime[muzzleNum] = level.time

    vehAngles = ent.client!.ps.viewangles
    if pVeh!.m_pVehicleInfo != nil && (pVeh!.m_pVehicleInfo!.type == VH_ANIMAL || pVeh!.m_pVehicleInfo!.type == VH_WALKER || pVeh!.m_pVehicleInfo!.type == VH_SPEEDER) {
        vehAngles[ROLL] = 0
        vehAngles[PITCH] = vehAngles[ROLL]
    }

    // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
    // Raven wrote: trap_G2API_GetBoltMatrix_NoRecNoRot(ent->ghoul2, 0, pVeh->m_iMuzzleTag[muzzleNum], &boltMatrix, vehAngles, ent->client->ps.origin, level.time, NULL, ent->modelScale)
    portMissing("WP_CalcVehMuzzle", source: "oracle/codemp/game/g_weapon.c:3580")
    // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
    // Raven wrote: BG_GiveMeVectorFromMatrix(&boltMatrix, ORIGIN, pVeh->m_vMuzzlePos[muzzleNum])
    portMissing("WP_CalcVehMuzzle", source: "oracle/codemp/game/g_weapon.c:3580")
    // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
    // Raven wrote: BG_GiveMeVectorFromMatrix(&boltMatrix, NEGATIVE_Y, pVeh->m_vMuzzleDir[muzzleNum])
    portMissing("WP_CalcVehMuzzle", source: "oracle/codemp/game/g_weapon.c:3580")
}

/// Source: oracle/codemp/game/g_weapon.c:3610
func WP_VehWeapSetSolidToOwner(_ `self`: Entity) {
    `self`.r.svFlags |= SVF_OWNERNOTSHARED
    if `self`.genericValue1 != 0 {
        //expire after a time
        if `self`.genericValue2 != 0 {
            //blow up when your lifetime is up
            `self`.think = Think.G_ExplodeMissile //FIXME: custom func?
        } else {
            //just remove yourself
            `self`.think = Think.G_FreeEntity //FIXME: custom func?
        }
        `self`.nextthink = level.time + `self`.genericValue1
    }
}

/// Source: oracle/codemp/game/g_weapon.c:3628
func WP_FireVehicleWeapon(_ ent: Entity, _ start: inout JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ vehWeapon: JKAMP.VehWeaponInfo, _ alt_fire: Bool, _ isTurretWeap: Bool) -> Entity? {
    var missile: Entity? = nil

    //FIXME: add some randomness...?  Inherent inaccuracy stat of weapon?  Pilot skill?
    if vehWeapon.bIsProjectile {
        //projectile entity
        var mins = vec3_t()
        var maxs = vec3_t()

        maxs = vec3_t(vehWeapon.fWidth / 2.0, vehWeapon.fWidth / 2.0, vehWeapon.fHeight / 2.0)
        mins = maxs * -1

        //make sure our start point isn't on the other side of a wall
        WP_TraceSetStart(ent, &start, mins, maxs)

        //FIXME: CUSTOM MODEL?
        //QUERY: alt_fire true or not?  Does it matter?
        missile = CreateMissile(&start, dir, vehWeapon.fSpeed, 10000, ent, false)

        missile!.classname = "vehicle_proj"

        missile!.s.genericenemyindex = ent.s.number + MAX_GENTITIES
        missile!.damage = vehWeapon.iDamage
        missile!.splashDamage = vehWeapon.iSplashDamage
        missile!.splashRadius = Int32(vehWeapon.fSplashRadius)

        //FIXME: externalize some of these properties?
        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.clipmask = MASK_SHOT
        //Maybe by checking flags...?
        if vehWeapon.bSaberBlockable {
            missile!.clipmask |= CONTENTS_LIGHTSABER
        }
        /*
        if ( (vehWeapon->iFlags&VWF_KNOCKBACK) )
        {
        missile->dflags &= ~DAMAGE_DEATH_KNOCKBACK;
        }
        if ( (vehWeapon->iFlags&VWF_RADAR) )
        {
        missile->s.eFlags |= EF_RADAROBJECT;
        }
        */
        // Make it easier to hit things
        missile!.r.mins = mins
        missile!.r.maxs = maxs
        //some slightly different stuff for things with bboxes
        if vehWeapon.fWidth != 0 || vehWeapon.fHeight != 0 {
            //we assume it's a rocket-like thing
            missile!.s.weapon = WP_ROCKET_LAUNCHER //does this really matter?
            missile!.methodOfDeath = MOD_VEHICLE //MOD_ROCKET;
            missile!.splashMethodOfDeath = MOD_VEHICLE //MOD_ROCKET;// ?SPLASH;

            // we don't want it to ever bounce
            missile!.bounceCount = 0

            missile!.mass = 10
        } else {
            //a blaster-laser-like thing
            missile!.s.weapon = WP_BLASTER //does this really matter?
            missile!.methodOfDeath = MOD_VEHICLE //count as a heavy weap
            missile!.splashMethodOfDeath = MOD_VEHICLE // ?SPLASH;
            // we don't want it to bounce forever
            missile!.bounceCount = 8
        }

        if vehWeapon.bHasGravity {
            //TESTME: is this all we need to do?
            missile!.s.weapon = WP_THERMAL //does this really matter?
            missile!.s.pos.trType = TR_GRAVITY
        }

        if vehWeapon.bIonWeapon {
            //so it disables ship shields and sends them out of control
            missile!.s.weapon = WP_DEMP2
        }

        if vehWeapon.iHealth != 0 {
            //the missile can take damage
            /*
            //don't do this - ships hit them first and have no trace.plane.normal to bounce off it at and end up in the middle of the asteroid...
            missile->health = vehWeapon->iHealth;
            missile->takedamage = qtrue;
            missile->r.contents = MASK_SHOT;
            missile->die = RocketDie;
            */
        }

        //pilot should own this projectile on server if we have a pilot
        if ent.m_pVehicle != nil && ent.m_pVehicle!.m_pPilot != nil {
            //owned by vehicle pilot
            missile!.r.ownerNum = ent.m_pVehicle!.m_pPilot!.s.number
        } else {
            //owned by vehicle?
            missile!.r.ownerNum = ent.s.number
        }

        //set veh as cgame side owner for purpose of fx overrides
        missile!.s.owner = ent.s.number
        if alt_fire {
            //use the second weapon's iShotFX
            missile!.s.eFlags |= EF_ALT_FIRING
        }
        if isTurretWeap {
            //look for the turret weapon info on cgame side, not vehicle weapon info
            missile!.s.weapon = WP_TURRET
        }
        if vehWeapon.iLifeTime != 0 {
            //expire after a time
            if vehWeapon.bExplodeOnExpire {
                //blow up when your lifetime is up
                missile!.think = Think.G_ExplodeMissile //FIXME: custom func?
            } else {
                //just remove yourself
                missile!.think = Think.G_FreeEntity //FIXME: custom func?
            }
            missile!.nextthink = level.time + vehWeapon.iLifeTime
        }
        // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '-' on 'Strideable' requires that 'VehWeaponInfo' conform to '_Pointer'".
        // Raven wrote: missile->s.otherEntityNum2 = (vehWeapon-&g_vehWeaponInfo[0])
        portMissing("WP_FireVehicleWeapon", source: "oracle/codemp/game/g_weapon.c:3628")
        missile!.s.eFlags |= EF_JETPACK_ACTIVE
        //homing
        if vehWeapon.fHoming != 0 {
            //homing missile
            if ent.client != nil && ent.client!.ps.rocketLockIndex != ENTITYNUM_NONE {
                var dif: Int32 = 0
                var rTime: Float
                rTime = ent.client!.ps.rocketLockTime

                if rTime == -1 {
                    rTime = ent.client!.ps.rocketLastValidTime
                }

                if vehWeapon.iLockOnTime == 0 {
                    //no minimum lock-on time
                    dif = 10 //guaranteed lock-on
                } else {
                    let lockTimeInterval: Float = vehWeapon.iLockOnTime / 16.0
                    dif = Int32((level.time - rTime) / lockTimeInterval)
                }

                if dif < 0 {
                    dif = 0
                }

                //It's 10 even though it locks client-side at 8, because we want them to have a sturdy lock first, and because there's a slight difference in time between server and client
                if dif >= 10 && rTime != -1 {
                    missile!.enemy = g_entities[ent.client!.ps.rocketLockIndex]

                    if missile!.enemy != nil && missile!.enemy!.client != nil && missile!.enemy!.health > 0 && !OnSameTeam(ent, missile!.enemy!) {
                        //if enemy became invalid, died, or is on the same team, then don't seek it
                        missile!.spawnflags |= 1 //just to let it know it should be faster...
                        missile!.speed = vehWeapon.fSpeed
                        missile!.angle = vehWeapon.fHoming
                        missile!.radius = vehWeapon.fHomingFOV
                        //crap, if we have a lifetime, need to store that somewhere else on ent and have rocketThink func check it every frame...
                        if vehWeapon.iLifeTime != 0 {
                            //expire after a time
                            missile!.genericValue1 = level.time + vehWeapon.iLifeTime
                            missile!.genericValue2 = ((vehWeapon.bExplodeOnExpire) ? 1 : 0)
                        }
                        //now go ahead and use the rocketThink func
                        missile!.think = Think.rocketThink //FIXME: custom func?
                        missile!.nextthink = level.time + VEH_HOMING_MISSILE_THINK_TIME
                        missile!.s.eFlags |= EF_RADAROBJECT //FIXME: externalize
                        if missile!.enemy!.s.NPC_class == CLASS_VEHICLE {
                            //let vehicle know we've locked on to them
                            missile!.s.otherEntityNum = missile!.enemy!.s.number
                        }
                    }
                }

                missile!.movedir = dir
                missile!.random = 1.0 //FIXME: externalize?
            }
        }
        if vehWeapon.fSpeed == 0 {
            //a mine or something?
            if vehWeapon.iHealth != 0 {
                //the missile can take damage
                missile!.health = vehWeapon.iHealth
                missile!.takedamage = true
                missile!.r.contents = MASK_SHOT
                missile!.die = Die.RocketDie
            }
            //only do damage when someone touches us
            missile!.s.weapon = WP_THERMAL //does this really matter?
            G_SetOrigin(missile!, &start)
            missile!.touch = Touch.WP_TouchVehMissile
            missile!.s.eFlags |= EF_RADAROBJECT //FIXME: externalize
            //crap, if we have a lifetime, need to store that somewhere else on ent and have rocketThink func check it every frame...
            if vehWeapon.iLifeTime != 0 {
                //expire after a time
                missile!.genericValue1 = vehWeapon.iLifeTime
                missile!.genericValue2 = ((vehWeapon.bExplodeOnExpire) ? 1 : 0)
            }
            //now go ahead and use the setsolidtoowner func
            missile!.think = Think.WP_VehWeapSetSolidToOwner
            missile!.nextthink = level.time + 3000
        }
    } else {
        //traceline
        //FIXME: implement
    }

    return missile
}

//custom routine to not waste tempents horribly -rww
/// Source: oracle/codemp/game/g_weapon.c:3851
func G_VehMuzzleFireFX(_ ent: Entity, _ broadcaster: Entity, _ muzzlesFired: Int32) {
    let pVeh: Vehicle? = ent.m_pVehicle
    var b: Entity?

    if pVeh == nil {
        return
    }

    //joy
    b = broadcaster

    //this guy owns it
    b!.s.owner = ent.s.number

    //this is the bitfield of all muzzles fired this time
    //NOTE: just need MAX_VEHICLE_MUZZLES bits for this... should be cool since it's currently 12 and we're sending it in 16 bits
    b!.s.trickedentindex = muzzlesFired

    //add the event
    G_AddEvent(b!, EV_VEH_FIRE, 0)
}

/// Source: oracle/codemp/game/g_weapon.c:3883
func G_EstimateCamPos(_ viewAngles: JKAShared.vec3_t, _ cameraFocusLoc: inout JKAShared.vec3_t, _ viewheight: Float, _ thirdPersonRange: Float, _ thirdPersonHorzOffset: Float, _ vertOffset: Float, _ pitchOffset: Float, _ ignoreEntNum: Int32, _ camPos: inout JKAShared.vec3_t) {
    let MASK_CAMERACLIP: Int32 = (MASK_SOLID | CONTENTS_PLAYERCLIP)
    let CAMERA_SIZE: Float = 4
    var cameramins = vec3_t()
    var cameramaxs = vec3_t()
    var cameraFocusAngles = vec3_t()
    var camerafwd = vec3_t()
    var cameraup = vec3_t()
    var cameraIdealTarget = vec3_t()
    var cameraCurTarget = vec3_t()
    var cameraIdealLoc = vec3_t()
    var cameraCurLoc = vec3_t()
    var diff = vec3_t()
    var camAngles = vec3_t()
    var viewaxis = [vec3_t](repeating: vec3_t(), count: 3)
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in

        cameramins = vec3_t(-CAMERA_SIZE, -CAMERA_SIZE, -CAMERA_SIZE)
        cameramaxs = vec3_t(CAMERA_SIZE, CAMERA_SIZE, CAMERA_SIZE)

        cameraFocusAngles = viewAngles
        cameraFocusAngles[PITCH] += pitchOffset
        if bg_fighterAltControl.integer == 0 {
            //clamp view pitch
            cameraFocusAngles[PITCH] = AngleNormalize180(cameraFocusAngles[PITCH])
            if Double(cameraFocusAngles[PITCH]) > 80.0 {
                cameraFocusAngles[PITCH] = 80.0
            } else if Double(cameraFocusAngles[PITCH]) < -80.0 {
                cameraFocusAngles[PITCH] = -80.0
            }
        }
        // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
        var scratchRight = vec3_t()
        AngleVectors(cameraFocusAngles, &camerafwd, &scratchRight, &cameraup)

        cameraFocusLoc[2] += viewheight

        cameraIdealTarget = cameraFocusLoc
        cameraIdealTarget[2] += vertOffset

        //NOTE: on cgame, this uses the thirdpersontargetdamp value, we ignore that here
        cameraCurTarget = cameraIdealTarget
        trap_Trace(trace, cameraFocusLoc, cameramins, cameramaxs, cameraCurTarget, ignoreEntNum, MASK_CAMERACLIP)
        if Double(trace.fraction) < 1.0 {
            cameraCurTarget = trace.endpos
        }

        _VectorMA(cameraIdealTarget, -(thirdPersonRange), camerafwd, &cameraIdealLoc)
        //NOTE: on cgame, this uses the thirdpersoncameradamp value, we ignore that here
        cameraCurLoc = cameraIdealLoc
        trap_Trace(trace, cameraCurTarget, cameramins, cameramaxs, cameraCurLoc, ignoreEntNum, MASK_CAMERACLIP)
        if Double(trace.fraction) < 1.0 {
            cameraCurLoc = trace.endpos
        }

        diff = cameraCurTarget - cameraCurLoc
        do {
            let dist: Float = VectorNormalize(&diff)
            //under normal circumstances, should never be 0.00000 and so on.
            if dist == 0 || (diff[0] == 0 || diff[1] == 0) {
                //must be hitting something, need some value to calc angles, so use cam forward
                diff = camerafwd
            }
        }

        vectoangles(diff, &camAngles)

        if thirdPersonHorzOffset != 0.0 {
            AnglesToAxis(camAngles, &viewaxis)
            _VectorMA(cameraCurLoc, thirdPersonHorzOffset, viewaxis[1], &cameraCurLoc)
        }

        camPos = cameraCurLoc
    }
}

/// Source: oracle/codemp/game/g_weapon.c:3961
func WP_GetVehicleCamPos(_ ent: Entity, _ pilot: Entity, _ camPos: inout JKAShared.vec3_t) {
    var thirdPersonHorzOffset: Float = ent.m_pVehicle!.m_pVehicleInfo!.cameraHorzOffset
    var thirdPersonRange: Float = ent.m_pVehicle!.m_pVehicleInfo!.cameraRange
    var pitchOffset: Float = ent.m_pVehicle!.m_pVehicleInfo!.cameraPitchOffset
    var vertOffset: Float = ent.m_pVehicle!.m_pVehicleInfo!.cameraVertOffset

    if ent.client!.ps.hackingTime != 0 {
        thirdPersonHorzOffset += ((Float(ent.client!.ps.hackingTime)) / MAX_STRAFE_TIME) * -80.0
        thirdPersonRange += abs((Float(ent.client!.ps.hackingTime)) / MAX_STRAFE_TIME) * 100.0
    }

    if ent.m_pVehicle!.m_pVehicleInfo!.cameraPitchDependantVertOffset {
        if pilot.client!.ps.viewangles[PITCH] > 0 {
            vertOffset = 130 + pilot.client!.ps.viewangles[PITCH] * -10
            if vertOffset < -170 {
                vertOffset = -170
            }
        } else if pilot.client!.ps.viewangles[PITCH] < 0 {
            vertOffset = 130 + pilot.client!.ps.viewangles[PITCH] * -5
            if vertOffset > 130 {
                vertOffset = 130
            }
        } else {
            vertOffset = 30
        }
        if pilot.client!.ps.viewangles[PITCH] > 0 {
            pitchOffset = Float(Double(pilot.client!.ps.viewangles[PITCH]) * -0.75)
        } else if pilot.client!.ps.viewangles[PITCH] < 0 {
            pitchOffset = Float(Double(pilot.client!.ps.viewangles[PITCH]) * -0.75)
        } else {
            pitchOffset = 0
        }
    }

    //Control Scheme 3 Method:
    G_EstimateCamPos(ent.client!.ps.viewangles, &pilot.client!.ps.origin, Float(pilot.client!.ps.viewheight), thirdPersonRange, thirdPersonHorzOffset, vertOffset, pitchOffset, pilot.s.number, &camPos)
    /*
    //Control Scheme 2 Method:
    G_EstimateCamPos( ent->m_pVehicle->m_vOrientation, ent->r.currentOrigin, pilot->client->ps.viewheight, thirdPersonRange,
    thirdPersonHorzOffset, vertOffset, pitchOffset,
    pilot->s.number, camPos );
    */
}

/// Source: oracle/codemp/game/g_weapon.c:4022
func WP_VehLeadCrosshairVeh(_ camTraceEnt: Entity, _ newEnd: inout JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ shotStart: JKAShared.vec3_t, _ shotDir: inout JKAShared.vec3_t) {
    if g_vehAutoAimLead.integer != 0 {
        if camTraceEnt.client != nil && camTraceEnt.client!.NPC_class == CLASS_VEHICLE {
            //if the crosshair is on a vehicle, lead it
            let dot: Float
            let distAdjust: Float = _DotProduct(camTraceEnt.client!.ps.velocity, dir)
            var predPos = vec3_t()
            var predShotDir = vec3_t()
            if distAdjust > 500 || DistanceSquared(camTraceEnt.client!.ps.origin, shotStart) > 7000000 {
                //moving away from me at a decent speed and/or more than @2600 units away from me
                _VectorMA(newEnd, distAdjust, dir, &predPos)
                predShotDir = predPos - shotStart
                VectorNormalize(&predShotDir)
                dot = _DotProduct(predShotDir, shotDir)
                if dot >= 0.75 {
                    //if the new aim vector is no more than 23 degrees off the original one, go ahead and adjust the aim
                    newEnd = predPos
                }
            }
        }
    }
    shotDir = newEnd - shotStart
    VectorNormalize(&shotDir)
}

/// Source: oracle/codemp/game/g_weapon.c:4052
func WP_VehCheckTraceFromCamPos(_ ent: Entity, _ shotStart: JKAShared.vec3_t, _ shotDir: inout JKAShared.vec3_t) -> Bool {
    //FIXME: only if dynamicCrosshair and dynamicCrosshairPrecision is on!
    if ent.m_pVehicle == nil || ent.m_pVehicle!.m_pVehicleInfo == nil || ent.m_pVehicle!.m_pPilot == nil || (ent.m_pVehicle!.m_pPilot.map { Entity($0) })!.client == nil || (ent.m_pVehicle!.m_pPilot!.s.number >= MAX_CLIENTS) {
        return false
    }
    if (ent.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER && g_cullDistance > MAX_XHAIR_DIST_ACCURACY) || ent.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
        //FIRST: simulate the normal crosshair trace from the center of the veh straight forward
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives nil where Raven's block falls through to its end.
        let earlyOut = Trace.scratch { trace -> Bool? in
            var dir = vec3_t()
            var start = vec3_t()
            var end = vec3_t()
            if ent.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
                //for some reason, the walker always draws the crosshair out from from the first muzzle point
                // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
                var scratchRight = vec3_t()
                // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
                var scratchUp = vec3_t()
                AngleVectors(ent.client!.ps.viewangles, &dir, &scratchRight, &scratchUp)
                start = ent.r.currentOrigin
                start[2] += ent.m_pVehicle!.m_pVehicleInfo!.height - DEFAULT_MINS_2 - 48
            } else {
                var ang = vec3_t()
                if ent.m_pVehicle!.m_pVehicleInfo!.type == VH_SPEEDER {
                    ang = vec3_t(0.0, ent.m_pVehicle!.m_vOrientationVector[1], 0.0)
                } else {
                    ang = ent.m_pVehicle!.m_vOrientationVector
                }
                // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
                var scratchRight2 = vec3_t()
                // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
                var scratchUp2 = vec3_t()
                AngleVectors(ang, &dir, &scratchRight2, &scratchUp2)
                start = ent.r.currentOrigin
            }
            _VectorMA(start, g_cullDistance, dir, &end)
            trap_Trace(trace, start, vec3_origin, vec3_origin, end, ent.s.number, CONTENTS_SOLID | CONTENTS_BODY)

            if ent.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
                //just use the result of that one trace since walkers don't do the extra trace
                shotDir = trace.endpos - shotStart
                VectorNormalize(&shotDir)
                return true
            } else {
                //NOW do the trace from the camPos and compare with above trace
                // Raven's record lives to the end of his block, so the block is the closure.
                // The closure gives nil where Raven's block falls through to its end.
                let earlyOut2 = Trace.scratch { extraTrace -> Bool? in
                    var newEnd = vec3_t()
                    let camTraceEntNum: Int32 = BG_VehTraceFromCamPos(extraTrace, BgEntity(ent), ent.r.currentOrigin, shotStart, end, &newEnd, &shotDir, (trace.fraction * g_cullDistance))
                    if camTraceEntNum != 0 {
                        WP_VehLeadCrosshairVeh(g_entities[camTraceEntNum - 1], &newEnd, dir, shotStart, &shotDir)
                        return true
                    }
                    return nil
                }
                if let earlyOut2 {
                    return earlyOut2
                }
            }
            return nil
        }
        if let earlyOut {
            return earlyOut
        }
    }
    return false
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:4116
func FireVehicleWeapon(_ ent: Entity, _ alt_fire: Bool) {
    let pVeh: Vehicle? = ent.m_pVehicle
    var muzzlesFired: Int32 = 0
    var missile: Entity? = nil
    var vehWeapon: VehWeaponInfo? = nil
    var clearRocketLockEntity: Bool = false

    tryFire: do {
        if pVeh == nil {
            return
        }

        if pVeh!.m_iRemovedSurfaces != 0 {
            //can't fire when the thing is breaking apart
            return
        }

        if pVeh!.m_pVehicleInfo!.type == VH_WALKER && ent.client!.ps.electrifyTime > level.time {
            //don't fire while being electrocuted
            return
        }

        // TODO?: If possible (probably not enough time), it would be nice if secondary fire was actually a mode switch/toggle
        // so that, for instance, an x-wing can have 4-gun fire, or individual muzzle fire. If you wanted a different weapon, you
        // would actually have to press the 2 key or something like that (I doubt I'd get a graphic for it anyways though). -AReis

        // If this is not the alternate fire, fire a normal blaster shot...
        if pVeh!.m_pVehicleInfo != nil && (pVeh!.m_pVehicleInfo!.type != VH_FIGHTER || (pVeh!.m_ulFlags & UInt(bitPattern: Int(VEH_WINGSOPEN))) != 0) {
            //fighters can only fire when wings are open
            var weaponNum: Int32 = 0
            var vehWeaponIndex: Int32 = VEH_WEAPON_NONE
            var delay: Int32 = 1000
            var aimCorrect: Bool = false
            var linkedFiring: Bool = false

            if !alt_fire {
                weaponNum = 0
            } else {
                weaponNum = 1
            }

            vehWeaponIndex = pVeh!.m_pVehicleInfo!.weapon[weaponNum].ID

            if pVeh!.weaponStatus[weaponNum].ammo <= 0 {
                //no ammo for this weapon
                if pVeh!.m_pPilot != nil && pVeh!.m_pPilot!.s.number < MAX_CLIENTS {
                    // let the client know he's out of ammo
                    var i: Int32 = 0
                    //but only if one of the vehicle muzzles is actually ready to fire this weapon
                    i = 0
                    while i < MAX_VEHICLE_MUZZLES {
                        if pVeh!.m_pVehicleInfo!.weapMuzzle[i] != vehWeaponIndex {
                            //this muzzle doesn't match the weapon we're trying to use
                            i += 1
                            continue
                        }
                        if pVeh!.m_iMuzzleTag[i] != -1 && pVeh!.m_iMuzzleWait[i] < level.time {
                            //this one would have fired, send the no ammo message
                            G_AddEvent(pVeh!.m_pPilot.map { Entity($0) }!, EV_NOAMMO, weaponNum)
                            break
                        }
                        i += 1
                    }
                }
                return
            }

            delay = pVeh!.m_pVehicleInfo!.weapon[weaponNum].delay
            aimCorrect = pVeh!.m_pVehicleInfo!.weapon[weaponNum].aimCorrect
            if pVeh!.m_pVehicleInfo!.weapon[weaponNum].linkable == 2 || (pVeh!.m_pVehicleInfo!.weapon[weaponNum].linkable == 1 && pVeh!.weaponStatus[weaponNum].linked) {
                //we're linking the primary or alternate weapons, so we'll do *all* the muzzles
                linkedFiring = true
            }

            if vehWeaponIndex <= VEH_WEAPON_BASE || vehWeaponIndex >= MAX_VEH_WEAPONS {
                //invalid vehicle weapon
                return
            } else {
                var i: Int32 = 0
                var numMuzzles: Int32 = 0
                var numMuzzlesReady: Int32 = 0
                var cumulativeDelay: Int32 = 0
                var cumulativeAmmo: Int32 = 0
                var sentAmmoWarning: Bool = false

                vehWeapon = g_vehWeaponInfo[vehWeaponIndex]

                if pVeh!.m_pVehicleInfo!.weapon[weaponNum].linkable == 2 {
                    //always linked weapons don't accumulate delay, just use specified delay
                    cumulativeDelay = delay
                }
                //find out how many we've got for this weapon
                i = 0
                while i < MAX_VEHICLE_MUZZLES {
                    if pVeh!.m_pVehicleInfo!.weapMuzzle[i] != vehWeaponIndex {
                        //this muzzle doesn't match the weapon we're trying to use
                        i += 1
                        continue
                    }
                    if pVeh!.m_iMuzzleTag[i] != -1 && pVeh!.m_iMuzzleWait[i] < level.time {
                        numMuzzlesReady += 1
                    }
                    if pVeh!.m_pVehicleInfo!.weapMuzzle[pVeh!.weaponStatus[weaponNum].nextMuzzle] != vehWeaponIndex {
                        //Our designated next muzzle for this weapon isn't valid for this weapon (happens when ships fire for the first time)
                        //set the next to this one
                        pVeh!.weaponStatus[weaponNum].nextMuzzle = i
                    }
                    if linkedFiring {
                        cumulativeAmmo += vehWeapon!.iAmmoPerShot
                        if pVeh!.m_pVehicleInfo!.weapon[weaponNum].linkable != 2 {
                            //always linked weapons don't accumulate delay, just use specified delay
                            cumulativeDelay += delay
                        }
                    }
                    numMuzzles += 1
                    i += 1
                }

                if linkedFiring {
                    //firing all muzzles at once
                    if numMuzzlesReady != numMuzzles {
                        //can't fire all linked muzzles yet
                        return
                    } else {
                        //can fire all linked muzzles, check ammo
                        if pVeh!.weaponStatus[weaponNum].ammo < cumulativeAmmo {
                            //can't fire, not enough ammo
                            if pVeh!.m_pPilot != nil && pVeh!.m_pPilot!.s.number < MAX_CLIENTS {
                                // let the client know he's out of ammo
                                G_AddEvent(pVeh!.m_pPilot.map { Entity($0) }!, EV_NOAMMO, weaponNum)
                            }
                            return
                        }
                    }
                }

                i = 0
                while i < MAX_VEHICLE_MUZZLES {
                    if pVeh!.m_pVehicleInfo!.weapMuzzle[i] != vehWeaponIndex {
                        //this muzzle doesn't match the weapon we're trying to use
                        i += 1
                        continue
                    }
                    if !linkedFiring && i != pVeh!.weaponStatus[weaponNum].nextMuzzle {
                        //we're only firing one muzzle and this isn't it
                        i += 1
                        continue
                    }

                    // Fire this muzzle.
                    if pVeh!.m_iMuzzleTag[i] != -1 && pVeh!.m_iMuzzleWait[i] < level.time {
                        var start = vec3_t()
                        var dir = vec3_t()

                        if pVeh!.weaponStatus[weaponNum].ammo < vehWeapon!.iAmmoPerShot {
                            //out of ammo!
                            if !sentAmmoWarning {
                                sentAmmoWarning = true
                                if pVeh!.m_pPilot != nil && pVeh!.m_pPilot!.s.number < MAX_CLIENTS {
                                    // let the client know he's out of ammo
                                    G_AddEvent(pVeh!.m_pPilot.map { Entity($0) }!, EV_NOAMMO, weaponNum)
                                }
                            }
                        } else {
                            //have enough ammo to shoot
                            //do the firing
                            WP_CalcVehMuzzle(ent, i)
                            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Slots<Float>' to type 'vec3_t' (aka 'SIMD3<Float>')".
                            // Raven wrote: VectorCopy( pVeh->m_vMuzzlePos[i], start )
                            portMissing("FireVehicleWeapon", source: "oracle/codemp/game/g_weapon.c:4116")
                            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Slots<Float>' to type 'vec3_t' (aka 'SIMD3<Float>')".
                            // Raven wrote: VectorCopy( pVeh->m_vMuzzleDir[i], dir )
                            portMissing("FireVehicleWeapon", source: "oracle/codemp/game/g_weapon.c:4116")
                            if WP_VehCheckTraceFromCamPos(ent, start, &dir) {
                                //auto-aim at whatever crosshair would be over from camera's point of view (if closer)
                            } else if aimCorrect {
                                //auto-aim the missile at the crosshair if there's anything there
                                // Raven's record lives to the end of his block, so the block is the closure.
                                Trace.scratch { trace in
                                    var end = vec3_t()
                                    var ang = vec3_t()
                                    var fixedDir = vec3_t()

                                    if pVeh!.m_pVehicleInfo!.type == VH_SPEEDER {
                                        ang = vec3_t(0.0, pVeh!.m_vOrientationVector[1], 0.0)
                                    } else {
                                        ang = pVeh!.m_vOrientationVector
                                    }
                                    // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
                                    var scratchRight = vec3_t()
                                    // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
                                    var scratchUp = vec3_t()
                                    AngleVectors(ang, &fixedDir, &scratchRight, &scratchUp)
                                    _VectorMA(ent.r.currentOrigin, 32768, fixedDir, &end)
                                    //VectorMA( ent->r.currentOrigin, 8192, dir, end );
                                    trap_Trace(trace, ent.r.currentOrigin, vec3_origin, vec3_origin, end, ent.s.number, MASK_SHOT)
                                    if trace.fraction < 1.0 && trace.allsolid == 0 && trace.startsolid == 0 {
                                        var newEnd = vec3_t()
                                        newEnd = trace.endpos
                                        WP_VehLeadCrosshairVeh(g_entities[trace.entityNum], &newEnd, fixedDir, start, &dir)
                                    }
                                }
                            }

                            //play the weapon's muzzle effect if we have one
                            //NOTE: just need MAX_VEHICLE_MUZZLES bits for this... should be cool since it's currently 12 and we're sending it in 16 bits
                            muzzlesFired |= (1 << i)

                            missile = WP_FireVehicleWeapon(ent, &start, dir, vehWeapon!, alt_fire, false)
                            if vehWeapon!.fHoming != 0 {
                                //clear the rocket lock entity *after* all muzzles have fired
                                clearRocketLockEntity = true
                            }
                        }

                        if linkedFiring {
                            //we're linking the weapon, so continue on and fire all appropriate muzzles
                            i += 1
                            continue
                        }
                        //else just firing one
                        //take the ammo, set the next muzzle and set the delay on it
                        if numMuzzles > 1 {
                            //more than one, look for it
                            var nextMuzzle: Int32 = pVeh!.weaponStatus[weaponNum].nextMuzzle
                            while 1 != 0 {
                                nextMuzzle += 1
                                if nextMuzzle >= MAX_VEHICLE_MUZZLES {
                                    nextMuzzle = 0
                                }
                                if nextMuzzle == pVeh!.weaponStatus[weaponNum].nextMuzzle {
                                    //WTF?  Wrapped without finding another valid one!
                                    break
                                }
                                if pVeh!.m_pVehicleInfo!.weapMuzzle[nextMuzzle] == vehWeaponIndex {
                                    //this is the next muzzle for this weapon
                                    pVeh!.weaponStatus[weaponNum].nextMuzzle = nextMuzzle
                                    break
                                }
                            }
                        }
                        //set the delay on the next muzzle
                        pVeh!.m_iMuzzleWait[pVeh!.weaponStatus[weaponNum].nextMuzzle] = level.time + delay
                        //take away the ammo
                        pVeh!.weaponStatus[weaponNum].ammo -= vehWeapon!.iAmmoPerShot
                        //NOTE: in order to send the vehicle's ammo info to the client, we copy the ammo into the first 2 ammo slots on the vehicle NPC's client->ps.ammo array
                        if pVeh!.m_pParentEntity != nil && ((pVeh!.m_pParentEntity).map { Entity($0) })!.client != nil {
                            ((pVeh!.m_pParentEntity).map { Entity($0) })!.client!.ps.ammo[weaponNum] = pVeh!.weaponStatus[weaponNum].ammo
                        }
                        //done!
                        //we'll get in here again next frame and try the next muzzle...
                        //return;
                        break tryFire
                    }
                    i += 1
                }
                //we went through all the muzzles, so apply the cumulative delay and ammo cost
                if cumulativeAmmo != 0 {
                    //taking ammo one shot at a time
                    //take the ammo
                    pVeh!.weaponStatus[weaponNum].ammo -= cumulativeAmmo
                    //NOTE: in order to send the vehicle's ammo info to the client, we copy the ammo into the first 2 ammo slots on the vehicle NPC's client->ps.ammo array
                    if pVeh!.m_pParentEntity != nil && ((pVeh!.m_pParentEntity).map { Entity($0) })!.client != nil {
                        ((pVeh!.m_pParentEntity).map { Entity($0) })!.client!.ps.ammo[weaponNum] = pVeh!.weaponStatus[weaponNum].ammo
                    }
                }
                if cumulativeDelay != 0 {
                    //we linked muzzles so we need to apply the cumulative delay now, to each of the linked muzzles
                    i = 0
                    while i < MAX_VEHICLE_MUZZLES {
                        if pVeh!.m_pVehicleInfo!.weapMuzzle[i] != vehWeaponIndex {
                            //this muzzle doesn't match the weapon we're trying to use
                            i += 1
                            continue
                        }
                        //apply the cumulative delay
                        pVeh!.m_iMuzzleWait[i] = level.time + cumulativeDelay
                        i += 1
                    }
                }
            }
        }

    }
    if clearRocketLockEntity {
        //hmm, should probably clear that anytime any weapon fires?
        ent.client!.ps.rocketLockIndex = ENTITYNUM_NONE
        ent.client!.ps.rocketLockTime = 0
        ent.client!.ps.rocketTargetTime = 0
    }

    if vehWeapon != nil && muzzlesFired > 0 {
        G_VehMuzzleFireFX(ent, missile!, muzzlesFired)
    }
}

/// Source: oracle/codemp/game/g_weapon.c:4424
func FireWeapon(_ ent: Entity, _ altFire: Bool) {
    if ent.client!.ps.powerups[PW_QUAD] != 0 {
        s_quadFactor = g_quadfactor.value
    } else {
        s_quadFactor = 1
    }

    // track shots taken for accuracy tracking.  Grapple is not a weapon and gauntet is just not tracked
    if ent.s.weapon != WP_SABER && ent.s.weapon != WP_STUN_BATON && ent.s.weapon != WP_MELEE {
        if ent.s.weapon == WP_FLECHETTE {
            ent.client!.accuracy_shots += FLECHETTE_SHOTS
        } else {
            ent.client!.accuracy_shots += 1
        }
    }

    if ent.client != nil && ent.client!.NPC_class == CLASS_VEHICLE {
        FireVehicleWeapon(ent, altFire)
        return
    } else {
        // set aiming directions
        if ent.s.weapon == WP_EMPLACED_GUN && ent.client!.ps.emplacedIndex != 0 {
            //if using emplaced then base muzzle point off of gun position/angles
            let emp: Entity? = g_entities[ent.client!.ps.emplacedIndex]

            if emp!.inuse {
                var yaw: Float = 0
                var viewAngCap = vec3_t()
                let override: Int32

                viewAngCap = ent.client!.ps.viewangles
                if viewAngCap[PITCH] > 40 {
                    viewAngCap[PITCH] = 40
                }

                override = BG_EmplacedView(&ent.client!.ps.viewangles, &emp!.s.angles, &yaw, emp!.s.origin2[0])

                if override != 0 {
                    viewAngCap[YAW] = yaw
                }

                AngleVectors(viewAngCap, &forward, &vright, &up)
            } else {
                AngleVectors(ent.client!.ps.viewangles, &forward, &vright, &up)
            }
        } else if ent.s.number < MAX_CLIENTS && ent.client!.ps.m_iVehicleNum != 0 && ent.s.weapon == WP_BLASTER {
            //riding a vehicle...with blaster selected
            var vehTurnAngles = vec3_t()
            let vehEnt: Entity? = g_entities[ent.client!.ps.m_iVehicleNum]

            if vehEnt!.inuse && vehEnt!.client != nil && vehEnt!.m_pVehicle != nil {
                vehTurnAngles = vehEnt!.m_pVehicle!.m_vOrientationVector
                vehTurnAngles[PITCH] = ent.client!.ps.viewangles[PITCH]
            } else {
                vehTurnAngles = ent.client!.ps.viewangles
            }
            if ent.client!.pers.cmd.rightmove > 0 {
                //shooting to right
                vehTurnAngles[YAW] -= 90.0
            } else if ent.client!.pers.cmd.rightmove < 0 {
                //shooting to left
                vehTurnAngles[YAW] += 90.0
            }

            AngleVectors(vehTurnAngles, &forward, &vright, &up)
        } else {
            AngleVectors(ent.client!.ps.viewangles, &forward, &vright, &up)
        }

        CalcMuzzlePoint(ent, forward, vright, up, &muzzle)

        // fire the specific weapon
        switch ent.s.weapon {
        case WP_STUN_BATON:
            WP_FireStunBaton(ent, altFire)

        case WP_MELEE:
            WP_FireMelee(ent, altFire)

        case WP_SABER:
            break

        case WP_BRYAR_PISTOL:
            //if ( g_gametype.integer == GT_SIEGE )
            if 1 != 0 {
                //allow alt-fire
                WP_FireBryarPistol(ent, altFire)
            } else {
                WP_FireBryarPistol(ent, false)
            }

        case WP_CONCUSSION:
            if altFire {
                WP_FireConcussionAlt(ent)
            } else {
                WP_FireConcussion(ent)
            }

        case WP_BRYAR_OLD:
            WP_FireBryarPistol(ent, altFire)

        case WP_BLASTER:
            WP_FireBlaster(ent, altFire)

        case WP_DISRUPTOR:
            WP_FireDisruptor(ent, altFire)

        case WP_BOWCASTER:
            WP_FireBowcaster(ent, altFire)

        case WP_REPEATER:
            WP_FireRepeater(ent, altFire)

        case WP_DEMP2:
            WP_FireDEMP2(ent, altFire)

        case WP_FLECHETTE:
            WP_FireFlechette(ent, altFire)

        case WP_ROCKET_LAUNCHER:
            WP_FireRocket(ent, altFire)

        case WP_THERMAL:
            WP_FireThermalDetonator(ent, altFire)

        case WP_TRIP_MINE:
            WP_PlaceLaserTrap(ent, altFire)

        case WP_DET_PACK:
            WP_DropDetPack(ent, altFire)

        case WP_EMPLACED_GUN:
            if ent.client != nil && ent.client!.ewebIndex != 0 {
                //specially handled by the e-web itself
                break
            }
            WP_FireEmplaced(ent, altFire)

        default:
            //			assert(!"unknown weapon fire");
            break
        }
    }

    G_LogWeaponFire(ent.s.number, ent.s.weapon)
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:4611
private func WP_FireEmplaced(_ ent: Entity, _ altFire: Bool) {
    var dir = vec3_t()
    var angs = vec3_t()
    var gunpoint = vec3_t()
    var right = vec3_t()
    var gun: Entity?
    let side: Int32

    if ent.client == nil {
        return
    }

    if ent.client!.ps.emplacedIndex == 0 {
        //shouldn't be using WP_EMPLACED_GUN if we aren't on an emplaced weapon
        return
    }

    gun = g_entities[ent.client!.ps.emplacedIndex]

    if !gun!.inuse || gun!.health <= 0 {
        //gun was removed or killed, although we should never hit this check because we should have been forced off it already
        return
    }

    gunpoint = gun!.s.origin
    gunpoint[2] += 46

    // Raven passes NULL for the `forward` output, and AngleVectors only skips that write.
    var scratchForward = vec3_t()
    // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
    var scratchUp = vec3_t()
    AngleVectors(ent.client!.ps.viewangles, &scratchForward, &right, &scratchUp)

    if gun!.genericValue10 != 0 {
        //fire out of the right cannon side
        _VectorMA(gunpoint, 10.0, right, &gunpoint)
        side = 0
    } else {
        //the left
        _VectorMA(gunpoint, -10.0, right, &gunpoint)
        side = 1
    }

    gun!.genericValue10 = side
    G_AddEvent(gun!, EV_FIRE_WEAPON, side)

    vectoangles(forward, &angs)

    // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
    var scratchRight = vec3_t()
    // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
    var scratchUp2 = vec3_t()
    AngleVectors(angs, &dir, &scratchRight, &scratchUp2)

    WP_FireEmplacedMissile(gun!, &gunpoint, dir, altFire, ent)
}

/// Source: oracle/codemp/game/g_weapon.c:4691
func emplaced_gun_use(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace?) {
    var fwd1 = vec3_t()
    var fwd2 = vec3_t()
    var dot: Float
    let oldWeapon: Int32
    let activator: Entity? = other
    let zoffset: Float = 50
    var anglesToOwner = vec3_t()
    var vLen = vec3_t()
    let ownLen: Float

    tryHeal: do {
        if `self`.health <= 0 {
            //gun is destroyed
            return
        }

        if `self`.activator != nil {
            //someone is already using me
            return
        }

        if activator!.client == nil {
            return
        }

        if activator!.client!.ps.emplacedTime > level.time {
            //last use attempt still too recent
            return
        }

        if activator!.client!.ps.forceHandExtend != HANDEXTEND_NONE {
            //don't use if busy doing something else
            return
        }

        if activator!.client!.ps.origin[2] > `self`.s.origin[2] + zoffset - 8 {
            //can't use it from the top
            return
        }

        if (activator!.client!.ps.pm_flags & PMF_DUCKED) != 0 {
            //must be standing
            return
        }

        if activator!.client!.ps.isJediMaster {
            //jm can't use weapons
            return
        }

        vLen = `self`.s.origin - activator!.client!.ps.origin
        ownLen = VectorLength(vLen)

        if ownLen > 64.0 {
            //must be within 64 units of the gun to use at all
            return
        }

        // Let's get some direction vectors for the user
        // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
        var scratchRight = vec3_t()
        // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
        var scratchUp = vec3_t()
        AngleVectors(activator!.client!.ps.viewangles, &fwd1, &scratchRight, &scratchUp)

        // Get the guns direction vector
        // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
        var scratchRight2 = vec3_t()
        // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
        var scratchUp2 = vec3_t()
        AngleVectors(`self`.pos1, &fwd2, &scratchRight2, &scratchUp2)

        dot = _DotProduct(fwd1, fwd2)

        // Must be reasonably facing the way the gun points ( 110 degrees or so ), otherwise we don't allow to use it.
        if dot < -0.2 {
            break tryHeal
        }

        fwd1 = `self`.s.origin - activator!.client!.ps.origin
        VectorNormalize(&fwd1)

        dot = _DotProduct(fwd1, fwd2)

        //check the positioning in relation to the gun as well
        if dot < 0.6 {
            break tryHeal
        }

        `self`.genericValue1 = 1

        oldWeapon = activator!.s.weapon

        // swap the users weapon with the emplaced gun
        activator!.client!.ps.weapon = `self`.s.weapon
        activator!.client!.ps.weaponstate = WEAPON_READY
        activator!.client!.ps.stats[STAT_WEAPONS] |= (1 << WP_EMPLACED_GUN)

        activator!.client!.ps.emplacedIndex = `self`.s.number

        `self`.s.emplacedOwner = activator!.s.number
        `self`.s.activeForcePass = NUM_FORCE_POWERS + 1

        // the gun will track which weapon we used to have
        `self`.s.weapon = oldWeapon

        //user's new owner becomes the gun ent
        activator!.r.ownerNum = `self`.s.number
        `self`.activator = activator

        anglesToOwner = `self`.r.currentOrigin - activator!.client!.ps.origin
        vectoangles(anglesToOwner, &anglesToOwner)
        return

    }
    TryHeal(activator!, `self`)
}

/// Source: oracle/codemp/game/g_weapon.c:4804
func emplaced_gun_realuse(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    emplaced_gun_use(`self`, other, nil)
}

//----------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:4810
func emplaced_gun_pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    `self`.s.health = `self`.health

    if `self`.health <= 0 {
        //death effect.. for now taken care of on cgame
    } else {
        //if we have a pain behavior set then use it I guess
        G_ActivateBehavior(`self`, BSET_PAIN)
    }
}

//----------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:4828
func emplaced_gun_update(_ `self`: Entity) {
    var smokeOrg = vec3_t()
    var puffAngle = vec3_t()
    let oldWeap: Int32
    var ownLen: Float = 0

    if `self`.health < 1 && `self`.genericValue5 == 0 {
        //we are dead, set our respawn delay if we have one
        if (`self`.spawnflags & EMPLACED_CANRESPAWN) != 0 {
            `self`.genericValue5 = level.time + 4000 + `self`.count
        }
    } else if `self`.health < 1 && `self`.genericValue5 < level.time {
        //we are dead, see if it's time to respawn
        `self`.s.time = 0
        `self`.genericValue4 = 0
        `self`.genericValue3 = 0
        `self`.health = Int32(Double(EMPLACED_GUN_HEALTH) * 0.4)
        `self`.s.health = `self`.health
    }

    if `self`.genericValue4 != 0 && `self`.genericValue4 < 2 && `self`.s.time < level.time {
        //we have finished our warning (red flashing) effect, it's time to finish dying
        var explOrg = vec3_t()

        puffAngle = vec3_t(0, 0, 1)

        explOrg = `self`.r.currentOrigin
        explOrg[2] += 16

        //just use the detpack explosion effect
        G_PlayEffect(EFFECT_EXPLOSION_DETPACK, explOrg, puffAngle)

        `self`.genericValue3 = level.time + Q_irand(2500, 3500)

        G_RadiusDamage(`self`.r.currentOrigin, `self`, Float(`self`.splashDamage), Float(`self`.splashRadius), `self`, nil, MOD_UNKNOWN)

        `self`.s.time = -1

        `self`.genericValue4 = 2
    }

    if `self`.genericValue3 > level.time {
        //see if we are freshly dead and should be smoking
        if `self`.genericValue2 < level.time {
            //is it time yet to spawn another smoke puff?
            puffAngle = vec3_t(0, 0, 1)
            smokeOrg = `self`.r.currentOrigin

            smokeOrg[2] += 60

            G_PlayEffect(EFFECT_SMOKE, smokeOrg, puffAngle)
            `self`.genericValue2 = level.time + Q_irand(250, 400)
        }
    }

    if `self`.activator != nil && `self`.activator!.client != nil && `self`.activator!.inuse {
        //handle updating current user
        var vLen = vec3_t()
        vLen = `self`.s.origin - `self`.activator!.client!.ps.origin
        ownLen = VectorLength(vLen)

        if !((`self`.activator!.client!.pers.cmd.buttons & BUTTON_USE) != 0) && `self`.genericValue1 != 0 {
            `self`.genericValue1 = 0
        }

        if (`self`.activator!.client!.pers.cmd.buttons & BUTTON_USE) != 0 && `self`.genericValue1 == 0 {
            `self`.activator!.client!.ps.emplacedIndex = 0
            `self`.activator!.client!.ps.saberHolstered = 0
            `self`.nextthink = level.time + 50
            return
        }
    }

    if (`self`.activator != nil && `self`.activator!.client != nil) && (!`self`.activator!.inuse || `self`.activator!.client!.ps.emplacedIndex != `self`.s.number || `self`.genericValue4 != 0 || ownLen > 64) {
        //get the user off of me then
        `self`.activator!.client!.ps.stats[STAT_WEAPONS] &= ~(1 << WP_EMPLACED_GUN)

        oldWeap = `self`.activator!.client!.ps.weapon
        `self`.activator!.client!.ps.weapon = `self`.s.weapon
        `self`.s.weapon = oldWeap
        `self`.activator!.r.ownerNum = ENTITYNUM_NONE
        `self`.activator!.client!.ps.emplacedTime = Float(level.time + 1000)
        `self`.activator!.client!.ps.emplacedIndex = 0
        `self`.activator!.client!.ps.saberHolstered = 0
        `self`.activator = nil

        `self`.s.activeForcePass = 0
    } else if `self`.activator != nil && `self`.activator!.client != nil {
        //make sure the user is using the emplaced gun weapon
        `self`.activator!.client!.ps.weapon = WP_EMPLACED_GUN
        `self`.activator!.client!.ps.weaponstate = WEAPON_READY
    }
    `self`.nextthink = level.time + 50
}

//----------------------------------------------------------
/// Source: oracle/codemp/game/g_weapon.c:4930
func emplaced_gun_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    //set us up to flash and then explode
    if `self`.genericValue4 != 0 {
        return
    }

    `self`.genericValue4 = 1

    `self`.s.time = level.time + 3000

    `self`.genericValue5 = 0
}

/// Source: oracle/codemp/game/g_weapon.c:4944
func SP_emplaced_gun(_ ent: Entity) {
    let name: String = "models/map_objects/mp/turret_chair.glm"
    var down = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in

        //make sure our assets are precached
        RegisterItem(BG_FindItemForWeapon(WP_EMPLACED_GUN)!)

        ent.r.contents = CONTENTS_SOLID
        ent.s.solid = SOLID_BBOX

        ent.genericValue5 = 0

        ent.r.mins = vec3_t(-30, -20, 8)
        ent.r.maxs = vec3_t(30, 20, 60)

        down = ent.s.origin

        down[2] -= 1024

        trap_Trace(tr, ent.s.origin, ent.r.mins, ent.r.maxs, down, ent.s.number, MASK_SOLID)

        if tr.fraction != 1 && tr.allsolid == 0 && tr.startsolid == 0 {
            ent.s.origin = tr.endpos
        }

        ent.spawnflags |= 4 // deadsolid

        ent.health = EMPLACED_GUN_HEALTH

        if (ent.spawnflags & EMPLACED_CANRESPAWN) != 0 {
            //make it somewhat easier to kill if it can respawn
            ent.health = Int32(Double(ent.health) * 0.4)
        }

        ent.maxHealth = ent.health
        G_ScaleNetHealth(ent)

        ent.genericValue4 = 0

        ent.takedamage = true
        ent.pain = Pain.emplaced_gun_pain
        ent.die = Die.emplaced_gun_die

        // being caught in this thing when it blows would be really bad.
        ent.splashDamage = 80
        ent.splashRadius = 128

        // amount of ammo that this little poochie has
        G_SpawnInt("count", "600", &ent.count)

        G_SpawnFloat("constraint", "60", &ent.s.origin2[0])

        ent.s.modelindex = G_ModelIndex(name)
        ent.s.modelGhoul2 = 1
        ent.s.g2radius = 110

        //so the cgame knows for sure that we're an emplaced weapon
        ent.s.weapon = WP_EMPLACED_GUN

        G_SetOrigin(ent, &ent.s.origin)

        // store base angles for later
        ent.pos1 = ent.s.angles
        ent.r.currentAngles = ent.s.angles
        ent.s.apos.trBase = ent.s.angles

        ent.think = Think.emplaced_gun_update
        ent.nextthink = level.time + 50

        ent.use = Use.emplaced_gun_realuse

        ent.r.svFlags |= SVF_PLAYER_USABLE

        ent.s.pos.trType = TR_STATIONARY

        ent.s.owner = MAX_CLIENTS + 1
        ent.s.shouldtarget = true
        //ent->s.teamowner = 0;

        trap_LinkEntity(ent)
    }
}
