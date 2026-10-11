import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_combat.c:755
/// Raven's data table, a hand property of `GameWorld`.
var modNames: [String] {
    get { world.modNames }
    set { world.modNames = newValue }
}

/// Source: oracle/codemp/game/g_combat.c:1866
let DEATH_ALERT_RADIUS = 512 as Int32

/// Source: oracle/codemp/game/g_combat.c:1867
let DEATH_ALERT_SOUND_RADIUS = 512 as Int32

/// Source: oracle/codemp/game/g_combat.c:3165
/// Raven's data table, a hand property of `GameWorld`.
var hitLocName: [String] {
    get { world.hitLocName }
    set { world.hitLocName = newValue }
}

/// Source: oracle/codemp/game/g_combat.c:3753
var gGAvoidDismember: Int32 {
    get { world.variables.gGAvoidDismember }
    set { world.variables.gGAvoidDismember = newValue }
}

/// Source: oracle/codemp/game/g_combat.c:4573
var gPainMOD: Int32 {
    get { world.variables.gPainMOD }
    set { world.variables.gPainMOD = newValue }
}

/// Source: oracle/codemp/game/g_combat.c:4574
var gPainHitLoc: Int32 {
    get { world.variables.gPainHitLoc }
    set { world.variables.gPainHitLoc = newValue }
}

/// Source: oracle/codemp/game/g_combat.c:4575
var gPainPoint: JKAShared.vec3_t {
    get { world.variables.gPainPoint }
    set { world.variables.gPainPoint = newValue }
}

/// Source: oracle/codemp/game/g_combat.c:22
func ObjectDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ meansOfDeath: Int32) {
    if `self`.target != nil {
        G_UseTargets(`self`, attacker)
    }

    //remove my script_targetname
    G_FreeEntity(`self`)
}

/// Source: oracle/codemp/game/g_combat.c:33
func G_HeavyMelee(_ attacker: Entity) -> Bool {
    if g_gametype.integer == GT_SIEGE && attacker.client != nil && attacker.client!.siegeClass != -1 && (bgSiegeClasses[attacker.client!.siegeClass].classflags & (1 << CFL_HEAVYMELEE)) != 0 {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_combat.c:46
func G_GetHitLocation(_ target: Entity, _ ppoint: JKAShared.vec3_t?) -> Int32 {
    var point = vec3_t()
    var point_dir = vec3_t()
    var forward = vec3_t()
    var right = vec3_t()
    var up = vec3_t()
    var tangles = vec3_t()
    var tcenter = vec3_t()
    let tradius: Float
    let udot: Float
    let fdot: Float
    let rdot: Float
    var Vertical: Int32
    var Forward: Int32
    var Lateral: Int32
    let HitLoc: Int32

    // Get target forward, right and up.
    if target.client != nil {
        // Ignore player's pitch and roll.
        tangles = vec3_t(0, target.r.currentAngles[YAW], 0)
    }

    AngleVectors(tangles, &forward, &right, &up)

    // Get center of target.
    tcenter = target.r.absmin + target.r.absmax
    tcenter = tcenter * 0.5

    // Get radius width of target.
    tradius = (abs(target.r.maxs[0]) + abs(target.r.maxs[1]) + abs(target.r.mins[0]) + abs(target.r.mins[1])) / 4

    // Get impact point.
    if ppoint != nil && VectorCompare(ppoint!, vec3_origin) == 0 {
        point = ppoint!
    } else {
        return HL_NONE
    }

    /*
    //get impact dir
    if(pdir && !VectorCompare(pdir, vec3_origin))
    {
    VectorCopy(pdir, dir);
    }
    else
    {
    return;
    }

    //put point at controlled distance from center
    VectorSubtract(point, tcenter, tempvec);
    tempvec[2] = 0;
    hdist = VectorLength(tempvec);

    VectorMA(point, hdist - tradius, dir, point);
    //now a point on the surface of a cylinder with a radius of tradius
    */
    point_dir = point - tcenter
    VectorNormalize(&point_dir)

    // Get bottom to top (vertical) position index
    udot = _DotProduct(up, point_dir)
    if Double(udot) > 0.800 {
        Vertical = 4
    } else if Double(udot) > 0.400 {
        Vertical = 3
    } else if Double(udot) > -0.333 {
        Vertical = 2
    } else if Double(udot) > -0.666 {
        Vertical = 1
    } else {
        Vertical = 0
    }

    // Get back to front (forward) position index.
    fdot = _DotProduct(forward, point_dir)
    if Double(fdot) > 0.666 {
        Forward = 4
    } else if Double(fdot) > 0.333 {
        Forward = 3
    } else if Double(fdot) > -0.333 {
        Forward = 2
    } else if Double(fdot) > -0.666 {
        Forward = 1
    } else {
        Forward = 0
    }

    // Get left to right (lateral) position index.
    rdot = _DotProduct(right, point_dir)
    if Double(rdot) > 0.666 {
        Lateral = 4
    } else if Double(rdot) > 0.333 {
        Lateral = 3
    } else if Double(rdot) > -0.333 {
        Lateral = 2
    } else if Double(rdot) > -0.666 {
        Lateral = 1
    } else {
        Lateral = 0
    }

    HitLoc = Vertical * 25 + Forward * 5 + Lateral

    if HitLoc <= 10 {
        // Feet.
        if rdot > 0 {
            return HL_FOOT_RT
        } else {
            return HL_FOOT_LT
        }
    } else if HitLoc <= 50 {
        // Legs.
        if rdot > 0 {
            return HL_LEG_RT
        } else {
            return HL_LEG_LT
        }
    } else if HitLoc == 56 || HitLoc == 60 || HitLoc == 61 || HitLoc == 65 || HitLoc == 66 || HitLoc == 70 {
        // Hands.
        if rdot > 0 {
            return HL_HAND_RT
        } else {
            return HL_HAND_LT
        }
    } else if HitLoc == 83 || HitLoc == 87 || HitLoc == 88 || HitLoc == 92 || HitLoc == 93 || HitLoc == 97 {
        // Arms.
        if rdot > 0 {
            return HL_ARM_RT
        } else {
            return HL_ARM_LT
        }
    } else if (HitLoc >= 107 && HitLoc <= 109) || (HitLoc >= 112 && HitLoc <= 114) || (HitLoc >= 117 && HitLoc <= 119) {
        // Head.
        return HL_HEAD
    } else {
        if Double(udot) < 0.3 {
            return HL_WAIST
        } else if fdot < 0 {
            if Double(rdot) > 0.4 {
                return HL_BACK_RT
            } else if Double(rdot) < -0.4 {
                return HL_BACK_LT
            } else if fdot < 0 {
                return HL_BACK
            }
        } else {
            if Double(rdot) > 0.3 {
                return HL_CHEST_RT
            } else if Double(rdot) < -0.3 {
                return HL_CHEST_LT
            } else if fdot < 0 {
                return HL_CHEST
            }
        }
    }
    return HL_NONE
}

/// Source: oracle/codemp/game/g_combat.c:369
func ExplodeDeath(_ `self`: Entity) {
    //	gentity_t	*tent;
    var forward = vec3_t()

    `self`.takedamage = false //stop chain reaction runaway loops

    `self`.s.loopSound = 0
    `self`.s.loopIsSoundset = false

    `self`.s.pos.trBase = `self`.r.currentOrigin

    //	tent = G_TempEntity( self->s.origin, EV_FX_EXPLOSION );
    // Raven passes NULL for the `right` and `up` outputs.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(`self`.s.angles, &forward, &scratchRight, &scratchUp)

    /*
    if ( self->fxID > 0 )
    {
    G_PlayEffect( self->fxID, self->r.currentOrigin, forward );
    }
    else
    */

    do {
        //		CG_SurfaceExplosion( self->r.currentOrigin, forward, 20.0f, 12.0f, ((self->spawnflags&4)==qfalse) );	//FIXME: This needs to be consistent to all exploders!
        //		G_Sound(self, self->sounds );
    }

    if `self`.splashDamage > 0 && `self`.splashRadius > 0 {
        var attacker: Entity? = `self`
        if `self`.parent != nil {
            attacker = `self`.parent
        }
        G_RadiusDamage(`self`.r.currentOrigin, attacker!, Float(`self`.splashDamage), Float(`self`.splashRadius), attacker, nil, MOD_UNKNOWN)
    }

    ObjectDie(`self`, `self`, `self`, 20, 0)
}

/**
```
============
ScorePlum
============
```
*/
/// Source: oracle/codemp/game/g_combat.c:417
func ScorePlum(_ ent: Entity, _ origin: JKAShared.vec3_t, _ score: Int32) {
    var plum: Entity?

    plum = G_TempEntity(origin, EV_SCOREPLUM)
    // only send this temp entity to a single client
    plum!.r.svFlags |= SVF_SINGLECLIENT
    plum!.r.singleClient = ent.s.number
    //
    plum!.s.otherEntityNum = ent.s.number
    plum!.s.time = score
}

/// Source: oracle/codemp/game/g_combat.c:437
func AddScore(_ ent: Entity, _ origin: JKAShared.vec3_t, _ score: Int32) {
    /*
    if (g_gametype.integer == GT_SIEGE)
    { //no scoring in this gametype at all.
    return;
    }
    */

    if ent.client == nil {
        return
    }
    // no scoring during pre-match warmup
    if level.warmupTime != 0 {
        return
    }
    // show score plum
    //ScorePlum(ent, origin, score);
    //
    ent.client!.ps.persistant[PERS_SCORE] += score
    if g_gametype.integer == GT_TEAM && !g_dontPenalizeTeam {
        level.teamScores[ent.client!.ps.persistant[PERS_TEAM]] += score
    }
    CalculateRanks()
}

/**
```
=================
TossClientItems

rww - Toss the weapon away from the player in the specified direction
=================
```
*/
/// Source: oracle/codemp/game/g_combat.c:469
func TossClientWeapon(_ `self`: Entity, _ direction: JKAShared.vec3_t, _ speed: Float) {
    var vel = vec3_t()
    var item: Gitem?
    var launched: Entity?
    let weapon: Int32 = `self`.s.weapon
    let ammoSub: Int32

    if g_gametype.integer == GT_SIEGE {
        //no dropping weaps
        return
    }

    if weapon <= WP_BRYAR_PISTOL {
        //can't have this
        return
    }

    if weapon == WP_EMPLACED_GUN || weapon == WP_TURRET {
        return
    }

    // find the item type for this weapon
    item = BG_FindItemForWeapon(weapon)

    ammoSub = (`self`.client!.ps.ammo[weaponData[weapon].ammoIndex] - bg_itemlist[BG_GetItemIndexByTag(weapon, IT_WEAPON)].quantity)

    if ammoSub < 0 {
        var ammoQuan: Int32 = item!.quantity
        ammoQuan -= (-ammoSub)

        if ammoQuan <= 0 {
            //no ammo
            return
        }
    }

    vel[0] = direction[0] * speed
    vel[1] = direction[1] * speed
    vel[2] = direction[2] * speed

    launched = LaunchItem(item!, &`self`.client!.ps.origin, vel)

    launched!.s.generic1 = `self`.s.number
    launched!.s.powerups = level.time + 1500

    launched!.count = bg_itemlist[BG_GetItemIndexByTag(weapon, IT_WEAPON)].quantity

    `self`.client!.ps.ammo[weaponData[weapon].ammoIndex] -= bg_itemlist[BG_GetItemIndexByTag(weapon, IT_WEAPON)].quantity

    if `self`.client!.ps.ammo[weaponData[weapon].ammoIndex] < 0 {
        launched!.count -= (-`self`.client!.ps.ammo[weaponData[weapon].ammoIndex])
        `self`.client!.ps.ammo[weaponData[weapon].ammoIndex] = 0
    }

    if (`self`.client!.ps.ammo[weaponData[weapon].ammoIndex] < 1 && weapon != WP_DET_PACK) || (weapon != WP_THERMAL && weapon != WP_DET_PACK && weapon != WP_TRIP_MINE) {
        var i: Int32 = 0
        var weap: Int32 = -1

        `self`.client!.ps.stats[STAT_WEAPONS] &= ~(1 << weapon)

        while i < WP_NUM_WEAPONS {
            if (`self`.client!.ps.stats[STAT_WEAPONS] & (1 << i)) != 0 && i != WP_NONE {
                //this one's good
                weap = i
                break
            }
            i += 1
        }

        if weap != -1 {
            `self`.s.weapon = weap
            `self`.client!.ps.weapon = weap
        } else {
            `self`.s.weapon = 0
            `self`.client!.ps.weapon = 0
        }

        G_AddEvent(`self`, EV_NOAMMO, weapon)
    }
}

/**
```
=================
TossClientItems

Toss the weapon and powerups for the killed player
=================
```
*/
/// Source: oracle/codemp/game/g_combat.c:568
func TossClientItems(_ `self`: Entity) {
    var item: Gitem?
    var weapon: Int32
    var angle: Float
    var i: Int32
    var drop: Entity?

    if g_gametype.integer == GT_SIEGE {
        //just don't drop anything then
        return
    }

    // drop the weapon if not a gauntlet or machinegun
    weapon = `self`.s.weapon

    // make a special check to see if they are changing to a new
    // weapon that isn't the mg or gauntlet.  Without this, a client
    // can pick up a weapon, be killed, and not drop the weapon because
    // their weapon change hasn't completed yet and they are still holding the MG.
    if weapon == WP_BRYAR_PISTOL {
        if `self`.client!.ps.weaponstate == WEAPON_DROPPING {
            weapon = `self`.client!.pers.cmd.weapon
        }
        if !((`self`.client!.ps.stats[STAT_WEAPONS] & (1 << weapon)) != 0) {
            weapon = WP_NONE
        }
    }

    `self`.s.bolt2 = weapon

    if weapon > WP_BRYAR_PISTOL && weapon != WP_EMPLACED_GUN && weapon != WP_TURRET && `self`.client!.ps.ammo[weaponData[weapon].ammoIndex] != 0 {
        var te: Entity?

        // find the item type for this weapon
        item = BG_FindItemForWeapon(weapon)

        // tell all clients to remove the weapon model on this guy until he respawns
        te = G_TempEntity(vec3_origin, EV_DESTROY_WEAPON_MODEL)
        te!.r.svFlags |= SVF_BROADCAST
        te!.s.eventParm = `self`.s.number

        // spawn the item
        Drop_Item(`self`, item!, 0)
    }

    // drop all the powerups if not in teamplay
    if g_gametype.integer != GT_TEAM && g_gametype.integer != GT_SIEGE {
        angle = 45
        i = 1
        while i < PW_NUM_POWERUPS {
            if `self`.client!.ps.powerups[i] > level.time {
                item = BG_FindItemForPowerup(i)
                if item == nil {
                    i += 1
                    continue
                }
                drop = Drop_Item(`self`, item!, angle)
                // decide how many seconds it has left
                drop!.count = (`self`.client!.ps.powerups[i] - level.time) / 1000
                if drop!.count < 1 {
                    drop!.count = 1
                }
                angle += 45
            }
            i += 1
        }
    }
}

/**
```
==================
LookAtKiller
==================
```
*/
/// Source: oracle/codemp/game/g_combat.c:643
func LookAtKiller(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity) {
    var dir = vec3_t()
    var angles = vec3_t()

    if attacker != `self` {
        dir = attacker.s.pos.trBase - `self`.s.pos.trBase
    } else if inflictor != `self` {
        dir = inflictor.s.pos.trBase - `self`.s.pos.trBase
    } else {
        `self`.client!.ps.stats[STAT_DEAD_YAW] = Int32(`self`.s.angles[YAW])
        return
    }

    `self`.client!.ps.stats[STAT_DEAD_YAW] = Int32(vectoyaw(dir))

    angles[YAW] = vectoyaw(dir)
    angles[PITCH] = 0
    angles[ROLL] = 0
}

/**
```
==================
GibEntity
==================
```
*/
/// Source: oracle/codemp/game/g_combat.c:668
func GibEntity(_ `self`: Entity, _ killer: Int32) {
    G_AddEvent(`self`, EV_GIB_PLAYER, killer)
    `self`.takedamage = false
    `self`.s.eType = ET_INVISIBLE
    `self`.r.contents = 0
}

/// Source: oracle/codemp/game/g_combat.c:675
func BodyRid(_ ent: Entity) {
    trap_UnlinkEntity(ent)
    ent.physicsObject = false
}

/**
```
==================
body_die
==================
```
*/
/// Source: oracle/codemp/game/g_combat.c:686
func body_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ meansOfDeath: Int32) {
    // NOTENOTE No gibbing right now, this is star wars.
    var doDisint: Bool = false

    if `self`.s.eType == ET_NPC {
        //well, just rem it then, so long as it's done with its death anim and it's not a standard weapon.
        if `self`.client != nil && `self`.client!.ps.torsoTimer <= 0 && (meansOfDeath == MOD_UNKNOWN || meansOfDeath == MOD_WATER || meansOfDeath == MOD_SLIME || meansOfDeath == MOD_LAVA || meansOfDeath == MOD_CRUSH || meansOfDeath == MOD_TELEFRAG || meansOfDeath == MOD_FALLING || meansOfDeath == MOD_SUICIDE || meansOfDeath == MOD_TARGET_LASER || meansOfDeath == MOD_TRIGGER_HURT) {
            `self`.think = Think.G_FreeEntity
            `self`.nextthink = level.time
        }
        return
    }

    if `self`.health < (GIB_HEALTH + 1) {
        `self`.health = GIB_HEALTH + 1

        if `self`.client != nil && (level.time - `self`.client!.respawnTime) < 2000 {
            doDisint = false
        } else {
            doDisint = true
        }
    }

    if `self`.client != nil && (`self`.client!.ps.eFlags & EF_DISINTEGRATION) != 0 {
        return
    } else if (`self`.s.eFlags & EF_DISINTEGRATION) != 0 {
        return
    }

    if doDisint {
        if `self`.client != nil {
            `self`.client!.ps.eFlags |= EF_DISINTEGRATION
            `self`.client!.ps.lastHitLoc = `self`.client!.ps.origin
        } else {
            `self`.s.eFlags |= EF_DISINTEGRATION
            `self`.s.origin2 = `self`.r.currentOrigin

            //since it's the corpse entity, tell it to "remove" itself
            `self`.think = Think.BodyRid
            `self`.nextthink = level.time + 1000
        }
        return
    }
}

/**
```
==================
CheckAlmostCapture
==================
```
*/
/// Source: oracle/codemp/game/g_combat.c:806
func CheckAlmostCapture(_ `self`: Entity, _ attacker: Entity) {
    // if this player was carrying a flag
    // get the goal flag this player should have been going for
    // if we found the destination flag and it's not picked up
    // if the player was *very* close
}

/// Source: oracle/codemp/game/g_combat.c:853
func G_InKnockDown(_ ps: JKAMP.PlayerState) -> Bool {
    switch (ps.legsAnim) {
    case BOTH_KNOCKDOWN1, BOTH_KNOCKDOWN2, BOTH_KNOCKDOWN3, BOTH_KNOCKDOWN4, BOTH_KNOCKDOWN5:
        return true

    case BOTH_GETUP1, BOTH_GETUP2, BOTH_GETUP3, BOTH_GETUP4, BOTH_GETUP5, BOTH_FORCE_GETUP_F1, BOTH_FORCE_GETUP_F2, BOTH_FORCE_GETUP_B1, BOTH_FORCE_GETUP_B2, BOTH_FORCE_GETUP_B3, BOTH_FORCE_GETUP_B4, BOTH_FORCE_GETUP_B5:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/g_combat.c:882
private func G_CheckSpecialDeathAnim(_ `self`: Entity, _ point: JKAShared.vec3_t, _ damage: Int32, _ mod: Int32, _ hitLoc: Int32) -> Int32 {
    var deathAnim: Int32 = -1

    if BG_InRoll(`self`.client!.ps, `self`.client!.ps.legsAnim) {
        deathAnim = BOTH_DEATH_ROLL //# Death anim from a roll
    } else if BG_FlippingAnim(`self`.client!.ps.legsAnim) {
        deathAnim = BOTH_DEATH_FLIP //# Death anim from a flip
    } else if G_InKnockDown(`self`.client!.ps) {
        //since these happen a lot, let's handle them case by case
        let animLength: Int32 = Int32(bgAllAnims[`self`.localAnimIndex].animsSlots[`self`.client!.ps.legsAnim].numFrames * abs(Float((bgHumanoidAnimations[`self`.client!.ps.legsAnim].frameLerp))))
        switch `self`.client!.ps.legsAnim {
        case BOTH_KNOCKDOWN1:
            if animLength - `self`.client!.ps.legsTimer > 100 {
                //on our way down
                if `self`.client!.ps.legsTimer > 600 {
                    //still partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_KNOCKDOWN2:
            if animLength - `self`.client!.ps.legsTimer > 700 {
                //on our way down
                if `self`.client!.ps.legsTimer > 600 {
                    //still partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_KNOCKDOWN3:
            if animLength - `self`.client!.ps.legsTimer > 100 {
                //on our way down
                if `self`.client!.ps.legsTimer > 1300 {
                    //still partially up
                    deathAnim = BOTH_DEATH_FALLING_DN
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_DN
                }
            }

        case BOTH_KNOCKDOWN4:
            if animLength - `self`.client!.ps.legsTimer > 300 {
                //on our way down
                if `self`.client!.ps.legsTimer > 350 {
                    //still partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            } else {
                //crouch death
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight = vec3_t()
                var scratchUp = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            }

        case BOTH_KNOCKDOWN5:
            if `self`.client!.ps.legsTimer < 750 {
                //flat
                deathAnim = BOTH_DEATH_LYING_DN
            }

        case BOTH_GETUP1:
            if `self`.client!.ps.legsTimer < 350 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 800 {
                //crouching
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight2 = vec3_t()
                var scratchUp2 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight2, &scratchUp2)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)
                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 450 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_GETUP2:
            if `self`.client!.ps.legsTimer < 150 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 850 {
                //crouching
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight3 = vec3_t()
                var scratchUp3 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight3, &scratchUp3)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 500 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_GETUP3:
            if `self`.client!.ps.legsTimer < 250 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 600 {
                //crouching
                var fwd = vec3_t()
                var thrown: Float = 0
                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight4 = vec3_t()
                var scratchUp4 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight4, &scratchUp4)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 150 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_DN
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_DN
                }
            }

        case BOTH_GETUP4:
            if `self`.client!.ps.legsTimer < 250 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 600 {
                //crouching
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight5 = vec3_t()
                var scratchUp5 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight5, &scratchUp5)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 850 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_DN
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_GETUP5:
            if `self`.client!.ps.legsTimer > 850 {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 1500 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_DN
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_DN
                }
            }

        case BOTH_GETUP_CROUCH_B1:
            if `self`.client!.ps.legsTimer < 800 {
                //crouching
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight6 = vec3_t()
                var scratchUp6 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight6, &scratchUp6)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 400 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_GETUP_CROUCH_F1:
            if `self`.client!.ps.legsTimer < 800 {
                //crouching
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight7 = vec3_t()
                var scratchUp7 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight7, &scratchUp7)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 150 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_DN
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_DN
                }
            }

        case BOTH_FORCE_GETUP_B1:
            if `self`.client!.ps.legsTimer < 325 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 725 {
                //spinning up
                deathAnim = BOTH_DEATH_SPIN_180 //# Death anim when facing backwards
            } else if `self`.client!.ps.legsTimer < 900 {
                //crouching
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight8 = vec3_t()
                var scratchUp8 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight8, &scratchUp8)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 50 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_FORCE_GETUP_B2:
            if `self`.client!.ps.legsTimer < 575 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 875 {
                //spinning up
                deathAnim = BOTH_DEATH_SPIN_180 //# Death anim when facing backwards
            } else if `self`.client!.ps.legsTimer < 900 {
                //crouching
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight9 = vec3_t()
                var scratchUp9 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight9, &scratchUp9)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else {
                //lying down
                //partially up
                deathAnim = BOTH_DEATH_FALLING_UP
            }

        case BOTH_FORCE_GETUP_B3:
            if `self`.client!.ps.legsTimer < 150 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 775 {
                //flipping
                deathAnim = BOTH_DEATHBACKWARD2 //backflip
            } else {
                //lying down
                //partially up
                deathAnim = BOTH_DEATH_FALLING_UP
            }

        case BOTH_FORCE_GETUP_B4:
            if `self`.client!.ps.legsTimer < 325 {
                //standing up
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 150 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_FORCE_GETUP_B5:
            if `self`.client!.ps.legsTimer < 550 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 1025 {
                //kicking up
                deathAnim = BOTH_DEATHBACKWARD2 //backflip
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 50 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_FORCE_GETUP_B6:
            if `self`.client!.ps.legsTimer < 225 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 425 {
                //crouching up
                var fwd = vec3_t()
                var thrown: Float = 0

                // Raven passes NULL for the `right` and `up` outputs.
                var scratchRight10 = vec3_t()
                var scratchUp10 = vec3_t()
                AngleVectors(`self`.client!.ps.viewangles, &fwd, &scratchRight10, &scratchUp10)
                thrown = _DotProduct(fwd, `self`.client!.ps.velocity)

                if thrown < -150 {
                    deathAnim = BOTH_DEATHBACKWARD1 //# Death anim when crouched and thrown back
                } else {
                    deathAnim = BOTH_DEATH_CROUCHED //# Death anim when crouched
                }
            } else if `self`.client!.ps.legsTimer < 825 {
                //flipping up
                deathAnim = BOTH_DEATHFORWARD3 //backflip
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 225 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_UP
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_UP
                }
            }

        case BOTH_FORCE_GETUP_F1:
            if `self`.client!.ps.legsTimer < 275 {
                //standing up
            } else if `self`.client!.ps.legsTimer < 750 {
                //flipping
                deathAnim = BOTH_DEATH14
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 100 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_DN
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_DN
                }
            }

        case BOTH_FORCE_GETUP_F2:
            if `self`.client!.ps.legsTimer < 1200 {
                //standing
            } else {
                //lying down
                if animLength - `self`.client!.ps.legsTimer > 225 {
                    //partially up
                    deathAnim = BOTH_DEATH_FALLING_DN
                } else {
                    //down
                    deathAnim = BOTH_DEATH_LYING_DN
                }
            }

        default:
            break
        }
    }

    return deathAnim
}

/// Source: oracle/codemp/game/g_combat.c:1374
func G_PickDeathAnim(_ `self`: Entity, _ point: JKAShared.vec3_t, _ damage: Int32, _ mod: Int32, _ hitLoc: Int32) -> Int32 {
    //FIXME: play dead flop anims on body if in an appropriate _DEAD anim when this func is called
    var deathAnim: Int32 = -1
    let max_health: Int32
    var legAnim: Int32 = 0
    var objVelocity = vec3_t()
    // Raven assigns his own `hitLoc` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var hitLoc = hitLoc

    if `self`.client == nil {
        if `self`.s.eType != ET_NPC {
            //g2animent
            return 0
        }
    }

    if `self`.client != nil {
        max_health = `self`.client!.ps.stats[STAT_MAX_HEALTH]

        if `self`.client!.inSpaceIndex != 0 && `self`.client!.inSpaceIndex != ENTITYNUM_NONE {
            return BOTH_CHOKE3
        }
    } else {
        max_health = 60
    }

    if `self`.client != nil {
        objVelocity = `self`.client!.ps.velocity
    } else {
        objVelocity = `self`.s.pos.trDelta
    }

    if hitLoc == HL_NONE {
        hitLoc = G_GetHitLocation(`self`, point) //self->hitLoc
    }

    if `self`.client != nil {
        legAnim = `self`.client!.ps.legsAnim
    } else {
        legAnim = `self`.s.legsAnim
    }

    if gGAvoidDismember != 0 {
        return BOTH_RIGHTHANDCHOPPEDOFF
    }

    //dead flops
    switch legAnim {
    case BOTH_DEATH1, BOTH_DEAD1, BOTH_DEATH2, BOTH_DEAD2, BOTH_DEATH8, BOTH_DEAD8, BOTH_DEATH13, BOTH_DEAD13, BOTH_DEATH14, BOTH_DEAD14, BOTH_DEATH16, BOTH_DEAD16, BOTH_DEADBACKWARD1, BOTH_DEADBACKWARD2:
        deathAnim = -2
        /*
        if ( PM_FinishedCurrentLegsAnim( self ) )
        {//done with the anim
        deathAnim = BOTH_DEADFLOP2;
        }
        else
        {
        deathAnim = -2;
        }
        break;
        case BOTH_DEADFLOP2:
        deathAnim = BOTH_DEADFLOP2;
        break;
        */
        fallthrough

    case BOTH_DEATH10, BOTH_DEAD10, BOTH_DEATH15, BOTH_DEAD15, BOTH_DEADFORWARD1, BOTH_DEADFORWARD2:
        deathAnim = -2
        /*
        if ( PM_FinishedCurrentLegsAnim( self ) )
        {//done with the anim
        deathAnim = BOTH_DEADFLOP1;
        }
        else
        {
        deathAnim = -2;
        }
        break;
        */
        fallthrough

    case BOTH_DEADFLOP1:
        deathAnim = -2

    case BOTH_DEAD3, BOTH_DEAD4, BOTH_DEAD5, BOTH_DEAD6, BOTH_DEAD7, BOTH_DEAD9, BOTH_DEAD11, BOTH_DEAD12, BOTH_DEAD17, BOTH_DEAD18, BOTH_DEAD19, BOTH_LYINGDEAD1, BOTH_STUMBLEDEAD1, BOTH_FALLDEAD1LAND, BOTH_DEATH3, BOTH_DEATH4, BOTH_DEATH5, BOTH_DEATH6, BOTH_DEATH7, BOTH_DEATH9, BOTH_DEATH11, BOTH_DEATH12, BOTH_DEATH17, BOTH_DEATH18, BOTH_DEATH19, BOTH_DEATHFORWARD1, BOTH_DEATHFORWARD2, BOTH_DEATHBACKWARD1, BOTH_DEATHBACKWARD2, BOTH_DEATH1IDLE, BOTH_LYINGDEATH1, BOTH_STUMBLEDEATH1, BOTH_FALLDEATH1, BOTH_FALLDEATH1INAIR, BOTH_FALLDEATH1LAND:
        deathAnim = -2

    default:
        break
    }
    if deathAnim == -1 {
        if `self`.client != nil {
            deathAnim = G_CheckSpecialDeathAnim(`self`, point, damage, mod, hitLoc)
        }

        if deathAnim == -1 {
            //death anims
            switch hitLoc {
            case HL_FOOT_RT, HL_FOOT_LT:
                if mod == MOD_SABER && Q_irand(0, 2) == 0 {
                    return BOTH_DEATH10 //chest: back flip
                } else if Q_irand(0, 2) == 0 {
                    deathAnim = BOTH_DEATH4 //back: forward
                } else if Q_irand(0, 1) == 0 {
                    deathAnim = BOTH_DEATH5 //same as 4
                } else {
                    deathAnim = BOTH_DEATH15 //back: forward
                }

            case HL_LEG_RT:
                if Q_irand(0, 2) == 0 {
                    deathAnim = BOTH_DEATH4 //back: forward
                } else if Q_irand(0, 1) == 0 {
                    deathAnim = BOTH_DEATH5 //same as 4
                } else {
                    deathAnim = BOTH_DEATH15 //back: forward
                }

            case HL_LEG_LT:
                if Q_irand(0, 2) == 0 {
                    deathAnim = BOTH_DEATH4 //back: forward
                } else if Q_irand(0, 1) == 0 {
                    deathAnim = BOTH_DEATH5 //same as 4
                } else {
                    deathAnim = BOTH_DEATH15 //back: forward
                }

            case HL_BACK:
                if VectorLengthSquared(objVelocity) == 0 {
                    deathAnim = BOTH_DEATH17 //head/back: croak
                } else {
                    if Q_irand(0, 2) == 0 {
                        deathAnim = BOTH_DEATH4 //back: forward
                    } else if Q_irand(0, 1) == 0 {
                        deathAnim = BOTH_DEATH5 //same as 4
                    } else {
                        deathAnim = BOTH_DEATH15 //back: forward
                    }
                }

            case HL_CHEST_RT, HL_ARM_RT, HL_HAND_RT, HL_BACK_RT:
                if Double(damage) <= Double(max_health) * 0.25 {
                    deathAnim = BOTH_DEATH9 //chest right: snap, fall forward
                } else if Double(damage) <= Double(max_health) * 0.5 {
                    deathAnim = BOTH_DEATH3 //chest right: back
                } else if Double(damage) <= Double(max_health) * 0.75 {
                    deathAnim = BOTH_DEATH6 //chest right: spin
                } else {
                    //TEMP HACK: play spinny deaths less often
                    if Q_irand(0, 1) != 0 {
                        deathAnim = BOTH_DEATH8 //chest right: spin high
                    } else {
                        switch Q_irand(0, 2) {
                        case 1:
                            deathAnim = BOTH_DEATH3 //chest right: back

                        case 2:
                            deathAnim = BOTH_DEATH6 //chest right: spin

                        default:
                            deathAnim = BOTH_DEATH9 //chest right: snap, fall forward
                        }
                    }
                }

            case HL_CHEST_LT, HL_ARM_LT, HL_HAND_LT, HL_BACK_LT:
                if Double(damage) <= Double(max_health) * 0.25 {
                    deathAnim = BOTH_DEATH11 //chest left: snap, fall forward
                } else if Double(damage) <= Double(max_health) * 0.5 {
                    deathAnim = BOTH_DEATH7 //chest left: back
                } else if Double(damage) <= Double(max_health) * 0.75 {
                    deathAnim = BOTH_DEATH12 //chest left: spin
                } else {
                    //TEMP HACK: play spinny deaths less often
                    if Q_irand(0, 1) != 0 {
                        deathAnim = BOTH_DEATH14 //chest left: spin high
                    } else {
                        switch Q_irand(0, 2) {
                        case 1:
                            deathAnim = BOTH_DEATH7 //chest left: back

                        case 2:
                            deathAnim = BOTH_DEATH12 //chest left: spin

                        default:
                            deathAnim = BOTH_DEATH11 //chest left: snap, fall forward
                        }
                    }
                }

            case HL_CHEST, HL_WAIST:
                if Double(damage) <= Double(max_health) * 0.25 || VectorLengthSquared(objVelocity) == 0 {
                    if Q_irand(0, 1) == 0 {
                        deathAnim = BOTH_DEATH18 //gut: fall right
                    } else {
                        deathAnim = BOTH_DEATH19 //gut: fall left
                    }
                } else if Double(damage) <= Double(max_health) * 0.5 {
                    deathAnim = BOTH_DEATH2 //chest: backward short
                } else if Double(damage) <= Double(max_health) * 0.75 {
                    if Q_irand(0, 1) == 0 {
                        deathAnim = BOTH_DEATH1 //chest: backward med
                    } else {
                        deathAnim = BOTH_DEATH16 //same as 1
                    }
                } else {
                    deathAnim = BOTH_DEATH10 //chest: back flip
                }

            case HL_HEAD:
                if Double(damage) <= Double(max_health) * 0.5 {
                    deathAnim = BOTH_DEATH17 //head/back: croak
                } else {
                    deathAnim = BOTH_DEATH13 //head: stumble, fall back
                }

            default:
                break
            }
        }
    }

    // Validate.....
    if deathAnim == -1 || !BG_HasAnimation(`self`.localAnimIndex, deathAnim) {
        // I guess we'll take what we can get.....
        deathAnim = BG_PickAnim(`self`.localAnimIndex, BOTH_DEATH1, BOTH_DEATH25)
    }

    return deathAnim
}

/// Source: oracle/codemp/game/g_combat.c:1744
func G_GetJediMaster() -> Entity? {
    var i: Int32 = 0
    var ent: Entity?

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.inuse && ent!.client != nil && ent!.client!.ps.isJediMaster {
            return ent
        }

        i += 1
    }

    return nil
}

/// Source: oracle/codemp/game/g_combat.c:1770
func G_AlertTeam(_ victim: Entity, _ attacker: Entity, _ radius: Float, _ soundDist: Float) {
    var radiusEnts: [Int32] = [Int32](repeating: 0, count: 128)
    var check: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()
    let numEnts: Int32
    var i: Int32
    var distSq: Float
    let sndDistSq: Float = (soundDist * soundDist)

    if attacker == nil || attacker.client == nil {
        return
    }

    //Setup the bbox to search in
    i = 0
    while i < 3 {
        mins[i] = victim.r.currentOrigin[i] - radius
        maxs[i] = victim.r.currentOrigin[i] + radius
        i += 1
    }

    //Get the number of entities in a given space
    numEnts = trap_EntitiesInBox(mins, maxs, &radiusEnts, 128)

    //Cull this list
    i = 0
    while i < numEnts {
        check = g_entities[radiusEnts[i]]

        //Validate clients
        if check!.client == nil {
            i += 1
            continue
        }

        //only want NPCs
        if check!.NPC == nil {
            i += 1
            continue
        }

        //Don't bother if they're ignoring enemies
        //		if ( check->svFlags & SVF_IGNORE_ENEMIES )
        //			continue;

        //This NPC specifically flagged to ignore alerts
        if (check!.NPC!.scriptFlags & SCF_IGNORE_ALERTS) != 0 {
            i += 1
            continue
        }

        //This NPC specifically flagged to ignore alerts
        if !((check!.NPC!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0) {
            i += 1
            continue
        }

        //this ent does not participate in group AI
        if (check!.NPC!.scriptFlags & SCF_NO_GROUPS) != 0 {
            i += 1
            continue
        }

        //Skip the requested avoid check if present
        if check == victim {
            i += 1
            continue
        }

        //Skip the attacker
        if check == attacker {
            i += 1
            continue
        }

        //Must be on the same team
        if check!.client!.playerTeam != victim.client!.playerTeam {
            i += 1
            continue
        }

        //Must be alive
        if check!.health <= 0 {
            i += 1
            continue
        }

        if check!.enemy == nil {
            //only do this if they're not already mad at someone
            distSq = DistanceSquared(check!.r.currentOrigin, victim.r.currentOrigin)
            if distSq > 16384 && !trap_InPVS(victim.r.currentOrigin, check!.r.currentOrigin) {
                //not even potentially visible/hearable
                i += 1
                continue
            }
            //NOTE: this allows sound alerts to still go through doors/PVS if the teammate is within 128 of the victim...
            if soundDist <= 0 || distSq > sndDistSq {
                //out of sound range
                if !InFOV(victim, check!, check!.NPC!.stats.hfov, check!.NPC!.stats.vfov) || !NPC_ClearLOS2(check!, victim.r.currentOrigin) {
                    //out of FOV or no LOS
                    i += 1
                    continue
                }
            }

            //FIXME: This can have a nasty cascading effect if setup wrong...
            G_SetEnemy(check!, attacker)
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_combat.c:1869
func G_DeathAlert(_ victim: Entity, _ attacker: Entity) {
    //FIXME: with all the other alert stuff, do we really need this?
    G_AlertTeam(victim, attacker, Float(DEATH_ALERT_RADIUS), Float(DEATH_ALERT_SOUND_RADIUS))
}

/// Source: oracle/codemp/game/g_combat.c:1883
func DeathFX(_ ent: Entity) {
    var effectPos = vec3_t()
    var right = vec3_t()
    var defaultDir = vec3_t()

    if ent.client == nil {
        return
    }

    defaultDir = vec3_t(0, 0, 1)

    // team no longer indicates species/race.  NPC_class should be used to identify certain npc types
    switch ent.client!.NPC_class {
    case CLASS_MOUSE:
        effectPos = ent.r.currentOrigin
        effectPos[2] -= 20
        G_PlayEffectID(G_EffectIndex("env/small_explode"), effectPos, defaultDir)
        G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/chars/mouse/misc/death1"))

    case CLASS_PROBE:
        effectPos = ent.r.currentOrigin
        effectPos[2] += 50
        G_PlayEffectID(G_EffectIndex("explosions/probeexplosion1"), effectPos, defaultDir)

    case CLASS_ATST:
        // Raven passes NULL for the `forward` and `up` outputs.
        var scratchForward = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(ent.r.currentAngles, &scratchForward, &right, &scratchUp)
        _VectorMA(ent.r.currentOrigin, 20, right, &effectPos)
        effectPos[2] += 180
        G_PlayEffectID(G_EffectIndex("explosions/droidexplosion1"), effectPos, defaultDir)
        _VectorMA(effectPos, -40, right, &effectPos)
        G_PlayEffectID(G_EffectIndex("explosions/droidexplosion1"), effectPos, defaultDir)

    case CLASS_SEEKER, CLASS_REMOTE:
        G_PlayEffectID(G_EffectIndex("env/small_explode"), ent.r.currentOrigin, defaultDir)

    case CLASS_GONK:
        effectPos = ent.r.currentOrigin
        effectPos[2] -= 5
        //		statusTextIndex = Q_irand( IGT_RESISTANCEISFUTILE, IGT_NAMEIS8OF12 );
        G_Sound(ent, CHAN_AUTO, G_SoundIndex(va("sound/chars/gonk/misc/death%d.wav", Q_irand(1, 3))))
        G_PlayEffectID(G_EffectIndex("env/med_explode"), effectPos, defaultDir)
        // should list all remaining droids here, hope I didn't miss any

    case CLASS_R2D2:
        effectPos = ent.r.currentOrigin
        effectPos[2] -= 10
        G_PlayEffectID(G_EffectIndex("env/med_explode"), effectPos, defaultDir)
        G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/chars/mark2/misc/mark2_explo"))

    case CLASS_PROTOCOL, CLASS_R5D2:
        effectPos = ent.r.currentOrigin
        effectPos[2] -= 10
        G_PlayEffectID(G_EffectIndex("env/med_explode"), effectPos, defaultDir)
        G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/chars/mark2/misc/mark2_explo"))

    case CLASS_MARK2:
        effectPos = ent.r.currentOrigin
        effectPos[2] -= 15
        G_PlayEffectID(G_EffectIndex("explosions/droidexplosion1"), effectPos, defaultDir)
        G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/chars/mark2/misc/mark2_explo"))

    case CLASS_INTERROGATOR:
        effectPos = ent.r.currentOrigin
        effectPos[2] -= 15
        G_PlayEffectID(G_EffectIndex("explosions/droidexplosion1"), effectPos, defaultDir)
        G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/chars/interrogator/misc/int_droid_explo"))

    case CLASS_MARK1:
        // Raven passes NULL for the `forward` and `up` outputs.
        var scratchForward2 = vec3_t()
        var scratchUp2 = vec3_t()
        AngleVectors(ent.r.currentAngles, &scratchForward2, &right, &scratchUp2)
        _VectorMA(ent.r.currentOrigin, 10, right, &effectPos)
        effectPos[2] -= 15
        G_PlayEffectID(G_EffectIndex("explosions/droidexplosion1"), effectPos, defaultDir)
        _VectorMA(effectPos, -20, right, &effectPos)
        G_PlayEffectID(G_EffectIndex("explosions/droidexplosion1"), effectPos, defaultDir)
        _VectorMA(effectPos, -20, right, &effectPos)
        G_PlayEffectID(G_EffectIndex("explosions/droidexplosion1"), effectPos, defaultDir)
        G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/chars/mark1/misc/mark1_explo"))

    case CLASS_SENTRY:
        G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/chars/sentry/misc/sentry_explo"))
        effectPos = ent.r.currentOrigin
        G_PlayEffectID(G_EffectIndex("env/med_explode"), effectPos, defaultDir)

    default:
        break
    }
}

/// Source: oracle/codemp/game/g_combat.c:1986
func G_CheckVictoryScript(_ `self`: Entity) {
    if !G_ActivateBehavior(`self`, BSET_VICTORY) {
        if `self`.NPC != nil && `self`.s.weapon == WP_SABER {
            //Jedi taunt from within their AI
            `self`.NPC!.blockedSpeechDebounceTime = 0 //get them ready to taunt
            return
        }
        if `self`.client != nil && `self`.client!.NPC_class == CLASS_GALAKMECH {
            `self`.wait = 1
            TIMER_Set(`self`, "gloatTime", Q_irand(5000, 8000))
            `self`.NPC!.blockedSpeechDebounceTime = 0 //get him ready to taunt
            return
        }
        //FIXME: any way to not say this *right away*?  Wait for victim's death anim/scream to finish?
        if `self`.NPC != nil && `self`.NPC!.group != nil && `self`.NPC!.group!.commander != nil && `self`.NPC!.group!.commander!.NPC != nil && `self`.NPC!.group!.commander!.NPC!.rank > `self`.NPC!.rank && Q_irand(0, 2) == 0 {
            //sometimes have the group commander speak instead
            `self`.NPC!.group!.commander!.NPC!.greetingDebounceTime = level.time + Q_irand(2000, 5000)
            //G_AddVoiceEvent( self->NPC->group->commander, Q_irand(EV_VICTORY1, EV_VICTORY3), 2000 );
        } else if `self`.NPC != nil {
            `self`.NPC!.greetingDebounceTime = level.time + Q_irand(2000, 5000)
            //G_AddVoiceEvent( self, Q_irand(EV_VICTORY1, EV_VICTORY3), 2000 );
        }
    }
}

/// Source: oracle/codemp/game/g_combat.c:2016
func G_AddPowerDuelScore(_ team: Int32, _ score: Int32) {
    var i: Int32 = 0
    var check: Entity?

    while i < MAX_CLIENTS {
        check = g_entities[i]
        if check!.inuse && check!.client != nil && check!.client!.pers.connected == CON_CONNECTED && !check!.client!.iAmALoser && check!.client!.ps.stats[STAT_HEALTH] > 0 && check!.client!.sess.sessionTeam != TEAM_SPECTATOR && check!.client!.sess.duelTeam == team {
            //found a living client on the specified team
            check!.client!.sess.wins += score
            ClientUserinfoChanged(check!.s.number)
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_combat.c:2037
func G_AddPowerDuelLoserScore(_ team: Int32, _ score: Int32) {
    var i: Int32 = 0
    var check: Entity?

    while i < MAX_CLIENTS {
        check = g_entities[i]
        if check!.inuse && check!.client != nil && check!.client!.pers.connected == CON_CONNECTED && (check!.client!.iAmALoser || (check!.client!.ps.stats[STAT_HEALTH] <= 0 && check!.client!.sess.sessionTeam != TEAM_SPECTATOR)) && check!.client!.sess.duelTeam == team {
            //found a living client on the specified team
            check!.client!.sess.losses += score
            ClientUserinfoChanged(check!.s.number)
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_combat.c:2059
func G_BroadcastObit(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ killer: Int32, _ meansOfDeath: Int32, _ wasInVehicle: Int32, _ wasJediMaster: Bool) {
    // broadcast the death event to everyone
    if `self`.s.eType != ET_NPC && !g_noPDuelCheck {
        var ent: Entity?

        ent = G_TempEntity(`self`.r.currentOrigin, EV_OBITUARY)
        ent!.s.eventParm = meansOfDeath
        ent!.s.otherEntityNum = `self`.s.number
        ent!.s.otherEntityNum2 = attacker.s.number
        if Q_stricmp("vehicle_proj", inflictor.classname!) == 0 {
            //a vehicle missile
            ent!.s.eventParm = MOD_VEHICLE
            //store index into g_vehWeaponInfo
            ent!.s.weapon = inflictor.s.otherEntityNum2 + 1
            //store generic rocket or blaster type of missile
            ent!.s.generic1 = inflictor.s.weapon
        }
        if wasInVehicle != 0 && `self`.s.number < MAX_CLIENTS {
            //target is in a vehicle, store the entnum
            ent!.s.lookTarget = wasInVehicle
        }
        if attacker.s.m_iVehicleNum != 0 && attacker.s.number < MAX_CLIENTS {
            //target is in a vehicle, store the entnum
            ent!.s.brokenLimbs = attacker.s.m_iVehicleNum
        } else if ent!.s.lookTarget != 0 && Q_stricmp("func_rotating", attacker.classname!) == 0 {
            //my vehicle was killed by a func_rotating, probably an asteroid, so...
            ent!.s.saberInFlight = true
        }
        ent!.r.svFlags = SVF_BROADCAST // send to everyone
        ent!.s.isJediMaster = wasJediMaster
    }
}

/// Source: oracle/codemp/game/g_combat.c:2858
/// Raven's `static int i` of `player_die`, a property of `GameWorld`.
var i_player_die: Int32 {
    get { world.i_player_die }
    set { world.i_player_die = newValue }
}

/// Source: oracle/codemp/game/g_combat.c:2123
func player_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ meansOfDeath: Int32) {
    let anim: Int32
    let contents: Int32
    var killer: Int32
    var i: Int32
    var killerName: String
    var obit: String
    var wasJediMaster: Bool = false
    var sPMType: Int32 = 0
    var wasInVehicle: Int32 = 0
    var tempInflictorEnt: Entity? = inflictor
    var tempInflictor: Bool = false
    var actualMOD: Int32 = meansOfDeath
    // Raven assigns his own `attacker` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var attacker = attacker

    if `self`.client!.ps.pm_type == PM_DEAD {
        return
    }

    if level.intermissiontime != 0 {
        return
    }

    //check player stuff
    g_dontFrickinCheck = false

    if g_gametype.integer == GT_POWERDUEL {
        //don't want to wait til later in the frame if this is the case
        CheckExitRules()

        if level.intermissiontime != 0 {
            return
        }
    }

    if `self`.s.eType == ET_NPC && `self`.s.NPC_class == CLASS_VEHICLE && `self`.m_pVehicle != nil && `self`.m_pVehicle!.m_pVehicleInfo!.explosionDelay == 0 && (`self`.m_pVehicle!.m_pPilot != nil || `self`.m_pVehicle!.m_iNumPassengers > 0 || `self`.m_pVehicle!.m_pDroidUnit != nil) {
        //kill everyone on board in the name of the attacker... if the vehicle has no death delay
        var murderer: Entity? = nil
        var killEnt: Entity?
        var i: Int32 = 0

        if `self`.client!.ps.otherKillerTime >= level.time {
            //use the last attacker
            murderer = g_entities[`self`.client!.ps.otherKiller]
            if !murderer!.inuse || murderer!.client == nil {
                murderer = nil
            } else {
                if murderer!.s.number >= MAX_CLIENTS && murderer!.s.eType == ET_NPC && murderer!.s.NPC_class == CLASS_VEHICLE && murderer!.m_pVehicle != nil && murderer!.m_pVehicle!.m_pPilot != nil {
                    let murderPilot: Entity? = g_entities[murderer!.m_pVehicle!.m_pPilot!.s.number]
                    if murderPilot!.inuse && murderPilot!.client != nil {
                        //give the pilot of the offending vehicle credit for the kill
                        murderer = murderPilot
                        actualMOD = `self`.client!.otherKillerMOD
                        if `self`.client!.otherKillerVehWeapon > 0 {
                            tempInflictorEnt = G_Spawn()
                            if tempInflictorEnt != nil {
                                //fake up the inflictor
                                tempInflictor = true
                                tempInflictorEnt!.classname = "vehicle_proj"
                                tempInflictorEnt!.s.otherEntityNum2 = `self`.client!.otherKillerVehWeapon - 1
                                tempInflictorEnt!.s.weapon = `self`.client!.otherKillerWeaponType
                            }
                        }
                    }
                }
            }
        } else if attacker.inuse && attacker.client != nil {
            if attacker.s.number >= MAX_CLIENTS && attacker.s.eType == ET_NPC && attacker.s.NPC_class == CLASS_VEHICLE && attacker.m_pVehicle != nil && attacker.m_pVehicle!.m_pPilot != nil {
                //set vehicles pilot's killer as murderer
                murderer = g_entities[attacker.m_pVehicle!.m_pPilot!.s.number]
                if murderer!.inuse && murderer!.client != nil && murderer!.client!.ps.otherKillerTime >= level.time {
                    murderer = g_entities[murderer!.client!.ps.otherKiller]
                    if !murderer!.inuse || murderer!.client == nil {
                        murderer = nil
                    }
                } else {
                    murderer = nil
                }
            } else {
                murderer = g_entities[attacker.s.number]
            }
        } else if `self`.m_pVehicle!.m_pPilot != nil {
            murderer = `self`.m_pVehicle!.m_pPilot.map { Entity($0) }
            if !murderer!.inuse || murderer!.client == nil {
                murderer = nil
            }
        }

        //no valid murderer.. just use self I guess
        if murderer == nil {
            murderer = attacker
        }

        if `self`.m_pVehicle!.m_pVehicleInfo!.hideRider {
            //pilot is *inside* me, so kill him, too
            killEnt = `self`.m_pVehicle!.m_pPilot.map { Entity($0) }
            if killEnt != nil && killEnt!.inuse && killEnt!.client != nil {
                var dir: vec3_t? = nil
                G_Damage(killEnt!, tempInflictorEnt, murderer, &dir, killEnt!.client!.ps.origin, 99999, DAMAGE_NO_PROTECTION, actualMOD)
            }
            if `self`.m_pVehicle!.m_pVehicleInfo != nil {
                let numPass: Int32 = `self`.m_pVehicle!.m_iNumPassengers
                i = 0
                while i < numPass && `self`.m_pVehicle!.m_iNumPassengers != 0 {
                    //go through and eject the last passenger
                    killEnt = `self`.m_pVehicle!.m_ppPassengers[`self`.m_pVehicle!.m_iNumPassengers - 1].map { Entity($0) }
                    if killEnt != nil {
                        `self`.m_pVehicle!.m_pVehicleInfo!.runEject(`self`.m_pVehicle, killEnt.map { BgEntity($0) }, true)
                        if killEnt!.inuse && killEnt!.client != nil {
                            var dir: vec3_t? = nil
                            G_Damage(killEnt!, tempInflictorEnt, murderer, &dir, killEnt!.client!.ps.origin, 99999, DAMAGE_NO_PROTECTION, actualMOD)
                        }
                    }
                    i += 1
                }
            }
        }
        killEnt = `self`.m_pVehicle!.m_pDroidUnit.map { Entity($0) }
        if killEnt != nil && killEnt!.inuse && killEnt!.client != nil {
            killEnt!.flags &= ~FL_UNDYING
            var dir: vec3_t? = nil
            G_Damage(killEnt!, tempInflictorEnt, murderer, &dir, killEnt!.client!.ps.origin, 99999, DAMAGE_NO_PROTECTION, actualMOD)
        }
        if tempInflictor {
            G_FreeEntity(tempInflictorEnt!)
        }
        tempInflictorEnt = inflictor
        tempInflictor = false
        actualMOD = meansOfDeath
    }

    `self`.client!.ps.emplacedIndex = 0

    G_BreakArm(`self`, 0) //unbreak anything we have broken
    `self`.client!.ps.saberEntityNum = `self`.client!.saberStoredIndex //in case we died while our saber was knocked away.

    `self`.client!.bodyGrabIndex = ENTITYNUM_NONE
    `self`.client!.bodyGrabTime = 0

    if `self`.client!.holdingObjectiveItem > 0 {
        //carrying a siege objective item - make sure it updates and removes itself from us now in case this is an instant death-respawn situation
        let objectiveItem: Entity? = g_entities[`self`.client!.holdingObjectiveItem]

        if objectiveItem!.inuse && objectiveItem!.think != nil {
            objectiveItem!.runThink()
        }
    }

    if (`self`.client!.inSpaceIndex != 0 && `self`.client!.inSpaceIndex != ENTITYNUM_NONE) || (`self`.client!.ps.eFlags2 & EF2_SHIP_DEATH) != 0 {
        `self`.client!.noCorpse = true
    }

    if `self`.client!.NPC_class != CLASS_VEHICLE && `self`.client!.ps.m_iVehicleNum != 0 {
        //I'm riding a vehicle
        //tell it I'm getting off
        let veh: Entity? = g_entities[`self`.client!.ps.m_iVehicleNum]

        if veh!.inuse && veh!.client != nil && veh!.m_pVehicle != nil {
            //remember it for obit
            wasInVehicle = g_vehicleInfo.index(of: veh!.m_pVehicle!.m_pVehicleInfo!)
            veh!.m_pVehicle!.m_pVehicleInfo!.runEject(veh!.m_pVehicle, BgEntity(`self`), true)

            if veh!.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
                //go into "die in ship" mode with flag
                `self`.client!.ps.eFlags2 |= EF2_SHIP_DEATH

                //put me over where my vehicle exploded
                G_SetOrigin(`self`, &veh!.client!.ps.origin)
                `self`.client!.ps.origin = veh!.client!.ps.origin
            }
        }
        //droids throw heads if they haven't yet
        switch `self`.client!.NPC_class {
        case CLASS_R2D2:
            if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "head") == 0 {
                var up = vec3_t()
                // Raven passes NULL for the `forward` and `right` outputs.
                var scratchForward = vec3_t()
                var scratchRight = vec3_t()
                AngleVectors(`self`.r.currentAngles, &scratchForward, &scratchRight, &up)
                G_PlayEffectID(G_EffectIndex("chunks/r2d2head_veh"), `self`.r.currentOrigin, up)
            }

        case CLASS_R5D2:
            if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "head") == 0 {
                var up = vec3_t()
                // Raven passes NULL for the `forward` and `right` outputs.
                var scratchForward2 = vec3_t()
                var scratchRight2 = vec3_t()
                AngleVectors(`self`.r.currentAngles, &scratchForward2, &scratchRight2, &up)
                G_PlayEffectID(G_EffectIndex("chunks/r5d2head_veh"), `self`.r.currentOrigin, up)
            }

        default:
            break
        }
    }

    if `self`.NPC != nil {
        if `self`.client != nil && Jedi_WaitingAmbush(`self`) {
            //ambushing trooper
            `self`.client!.noclip = false
        }
        NPC_FreeCombatPoint(`self`.NPC!.combatPoint, false)
        if `self`.NPC!.group != nil {
            //lastInGroup = (self->NPC->group->numGroup < 2);
            AI_GroupMemberKilled(`self`)
            AI_DeleteSelfFromGroup(`self`)
        }

        if `self`.NPC!.tempGoal != nil {
            G_FreeEntity(`self`.NPC!.tempGoal!)
            `self`.NPC!.tempGoal = nil
        }
        /*
        if ( self->s.eFlags & EF_LOCKED_TO_WEAPON )
        {
        // dumb, just get the NPC out of the chair
        extern void RunEmplacedWeapon( gentity_t *ent, usercmd_t **ucmd );

        usercmd_t cmd, *ad_cmd;

        memset( &cmd, 0, sizeof( usercmd_t ));

        //gentity_t *old = self->owner;

        if ( self->owner )
        {
        self->owner->s.frame = self->owner->startFrame = self->owner->endFrame = 0;
        self->owner->svFlags &= ~SVF_ANIMATING;
        }

        cmd.buttons |= BUTTON_USE;
        ad_cmd = &cmd;
        RunEmplacedWeapon( self, &ad_cmd );
        //self->owner = old;
        }
        */
        //if ( self->client->NPC_class == CLASS_BOBAFETT && self->client->moveType == MT_FLYSWIM )
        if 0 != 0 {
            Boba_FlyStop(`self`)
        }
        if `self`.s.NPC_class == CLASS_RANCOR {
            Rancor_DropVictim(`self`)
        }
    }
    if attacker.NPC != nil && attacker.NPC!.group != nil && attacker.NPC!.group!.enemy == `self` {
        attacker.NPC!.group!.enemy = nil
    }

    //Cheap method until/if I decide to put fancier stuff in (e.g. sabers falling out of hand and slowly
    //holstering on death like sp)
    if `self`.client!.ps.weapon == WP_SABER && `self`.client!.ps.saberHolstered == 0 && `self`.client!.ps.saberEntityNum != 0 {
        if !`self`.client!.ps.saberInFlight && `self`.client!.saber[0].soundOff != 0 {
            G_Sound(`self`, CHAN_AUTO, `self`.client!.saber[0].soundOff)
        }
        if `self`.client!.saber[1].soundOff != 0 && !`self`.client!.saber[1].model.isEmpty {
            G_Sound(`self`, CHAN_AUTO, `self`.client!.saber[1].soundOff)
        }
    }

    //Use any target we had
    G_UseTargets(`self`, `self`)

    if g_slowmoDuelEnd.integer != 0 && (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) && attacker.inuse && attacker.client != nil {
        if !gDoSlowMoDuel {
            gDoSlowMoDuel = true
            gSlowMoDuelTime = level.time
        }
    }
    /*
    else if (self->NPC && attacker && attacker->client && attacker->s.number < MAX_CLIENTS && !gDoSlowMoDuel)
    {
    gDoSlowMoDuel = qtrue;
    gSlowMoDuelTime = level.time;
    }
    */

    //Make sure the jetpack is turned off.
    Jetpack_Off(`self`)

    `self`.client!.ps.heldByClient = 0
    `self`.client!.beingThrown = 0
    `self`.client!.doingThrow = 0
    BG_ClearRocketLock(`self`.client!.ps)
    `self`.client!.isHacking = 0
    `self`.client!.ps.hackingTime = 0

    if inflictor.activator != nil && inflictor.client == nil && attacker.client == nil && inflictor.activator!.client != nil && inflictor.activator!.inuse && inflictor.s.weapon == WP_TURRET {
        attacker = inflictor.activator!
    }

    if `self`.client != nil && `self`.client!.ps.isJediMaster {
        wasJediMaster = true
    }

    //if he was charging or anything else, kill the sound
    G_MuteSound(`self`.s.number, CHAN_WEAPON)

    BlowDetpacks(`self`) //blow detpacks if they're planted

    `self`.client!.ps.fd.forceDeactivateAll = 1

    if (`self` == attacker || attacker.client == nil) && (meansOfDeath == MOD_CRUSH || meansOfDeath == MOD_FALLING || meansOfDeath == MOD_TRIGGER_HURT || meansOfDeath == MOD_UNKNOWN || meansOfDeath == MOD_SUICIDE) && `self`.client!.ps.otherKillerTime > level.time {
        //remember who last attacked us
        attacker = g_entities[`self`.client!.ps.otherKiller]
        if `self`.client!.otherKillerMOD != MOD_UNKNOWN {
            actualMOD = `self`.client!.otherKillerMOD
        }
        if `self`.client!.otherKillerVehWeapon > 0 {
            tempInflictorEnt = G_Spawn()
            if tempInflictorEnt != nil {
                //fake up the inflictor
                tempInflictor = true
                tempInflictorEnt!.classname = "vehicle_proj"
                tempInflictorEnt!.s.otherEntityNum2 = `self`.client!.otherKillerVehWeapon - 1
                tempInflictorEnt!.s.weapon = `self`.client!.otherKillerWeaponType
            }
        }
    }

    // check for an almost capture
    CheckAlmostCapture(`self`, attacker)

    `self`.client!.ps.pm_type = PM_DEAD
    `self`.client!.ps.pm_flags &= ~PMF_STUCK_TO_WALL

    killer = attacker.s.number
    if attacker.client != nil {
        killerName = attacker.client!.pers.netname
    } else {
        killerName = "<non-client>"
    }

    if killer < 0 || killer >= MAX_CLIENTS {
        killer = ENTITYNUM_WORLD
        killerName = "<world>"
    }

    // Port-note: A sizeof of `char *[45]` the draft cannot size.
    // Raven wrote: if ( meansOfDeath < 0 || meansOfDeath >= sizeof( modNames ) / sizeof( modNames[0] ) ) { obit = "<bad obituary>"; } else { obit = modNames[ meansOfDeath ]; }
    portMissing("player_die", source: "oracle/codemp/game/g_combat.c:2123")

    // Port-note: A read of `obit`, a local the draft left as a hole.
    // Raven wrote: G_LogPrintf("Kill: %i %i %i: %s killed %s by %s\n", killer, self->s.number, meansOfDeath, killerName, self->client->pers.netname, obit )
    portMissing("player_die", source: "oracle/codemp/game/g_combat.c:2123")

    if g_austrian.integer != 0 && (g_gametype.integer == GT_DUEL) && level.numPlayingClients >= 2 {
        let spawnTime: Int32 = (level.clientsSlots[level.sortedClients[0]].respawnTime > level.clientsSlots[level.sortedClients[1]].respawnTime) ? level.clientsSlots[level.sortedClients[0]].respawnTime : level.clientsSlots[level.sortedClients[1]].respawnTime
        G_LogPrintf("Duel Kill Details:\n")
        G_LogPrintf("Kill Time: %d\n", level.time - spawnTime)
        G_LogPrintf("victim: %s, hits on enemy %d\n", `self`.client!.pers.netname, `self`.client!.ps.persistant[PERS_HITS])
        if attacker.client != nil {
            G_LogPrintf("killer: %s, hits on enemy %d, health: %d\n", attacker.client!.pers.netname, attacker.client!.ps.persistant[PERS_HITS], attacker.health)
            //also - if MOD_SABER, list the animation and saber style
            if meansOfDeath == MOD_SABER {
                G_LogPrintf("killer saber style: %d, killer saber anim %s\n", attacker.client!.ps.fd.saberAnimLevel, animTable[(attacker.client!.ps.torsoAnim)].name!)
            }
        }
    }

    G_LogWeaponKill(killer, meansOfDeath)
    G_LogWeaponDeath(`self`.s.number, `self`.s.weapon)
    if attacker.client != nil && attacker.inuse {
        G_LogWeaponFrag(killer, `self`.s.number)
    }

    G_BroadcastObit(`self`, inflictor, attacker, killer, actualMOD, wasInVehicle, wasJediMaster)
    if tempInflictor {
        G_FreeEntity(tempInflictorEnt!)
    }

    `self`.enemy = attacker

    `self`.client!.ps.persistant[PERS_KILLED] += 1

    if `self` == attacker {
        `self`.client!.ps.fd.suicides += 1
    }

    if attacker.client != nil {
        //killed by a client of some kind (player, NPC or vehicle)
        if `self`.s.number < MAX_CLIENTS {
            //only remember real clients
            attacker.client!.lastkilled_client = `self`.s.number
        }

        G_CheckVictoryScript(attacker)

        if `self`.s.number >= MAX_CLIENTS && `self`.client != nil && `self`.client!.NPC_class != CLASS_VEHICLE && `self`.s.m_iVehicleNum != 0 {
            //no credit for droid, you do get credit for the vehicle kill and the pilot (2 points)
        } else if meansOfDeath == MOD_COLLISION || meansOfDeath == MOD_VEH_EXPLOSION {
            //no credit for veh-veh collisions?
        } else if attacker == `self` || OnSameTeam(`self`, attacker) {
            //killed self or teammate
            if meansOfDeath == MOD_FALLING && attacker != `self` && attacker.s.number < MAX_CLIENTS && attacker.s.m_iVehicleNum != 0 {
                //crushed by a teammate in a vehicle, no penalty
            } else if g_gametype.integer == GT_DUEL {
                //in duel, if you kill yourself, the person you are dueling against gets a kill for it
                var otherClNum: Int32 = -1
                if level.sortedClients[0] == `self`.s.number {
                    otherClNum = level.sortedClients[1]
                } else if level.sortedClients[1] == `self`.s.number {
                    otherClNum = level.sortedClients[0]
                }

                if otherClNum >= 0 && otherClNum < MAX_CLIENTS && g_entities[otherClNum].inuse && g_entities[otherClNum].client != nil && otherClNum != attacker.s.number {
                    AddScore(g_entities[otherClNum], `self`.r.currentOrigin, 1)
                } else {
                    AddScore(attacker, `self`.r.currentOrigin, -1)
                }
            } else {
                AddScore(attacker, `self`.r.currentOrigin, -1)
                if attacker != `self` && attacker.s.number < MAX_CLIENTS && `self`.s.number < MAX_CLIENTS {
                    G_CheckTKAutoKickBan(attacker)
                }
            }
            if g_gametype.integer == GT_JEDIMASTER {
                if `self`.client != nil && `self`.client!.ps.isJediMaster {
                    //killed ourself so return the saber to the original position
                    //(to avoid people jumping off ledges and making the saber
                    //unreachable for 60 seconds)
                    ThrowSaberToAttacker(`self`, nil)
                    `self`.client!.ps.isJediMaster = false
                }
            }
        } else {
            if g_gametype.integer == GT_JEDIMASTER {
                if (attacker.client != nil && attacker.client!.ps.isJediMaster) || (`self`.client != nil && `self`.client!.ps.isJediMaster) {
                    AddScore(attacker, `self`.r.currentOrigin, 1)

                    if `self`.client != nil && `self`.client!.ps.isJediMaster {
                        ThrowSaberToAttacker(`self`, attacker)
                        `self`.client!.ps.isJediMaster = false
                    }
                } else {
                    let jmEnt: Entity? = G_GetJediMaster()

                    if jmEnt != nil && jmEnt!.client != nil {
                        AddScore(jmEnt!, `self`.r.currentOrigin, 1)
                    }
                }
            } else {
                AddScore(attacker, `self`.r.currentOrigin, 1)
            }

            if meansOfDeath == MOD_STUN_BATON {
                // play humiliation on player
                attacker.client!.ps.persistant[PERS_GAUNTLET_FRAG_COUNT] += 1

                attacker.client!.rewardTime = level.time + REWARD_SPRITE_TIME

                // also play humiliation on target
                `self`.client!.ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_GAUNTLETREWARD
            }

            // check for two kills in a short amount of time
            // if this is close enough to the last kill, give a reward sound
            if level.time - attacker.client!.lastKillTime < CARNAGE_REWARD_TIME {
                // play excellent on player
                attacker.client!.ps.persistant[PERS_EXCELLENT_COUNT] += 1

                attacker.client!.rewardTime = level.time + REWARD_SPRITE_TIME
            }
            attacker.client!.lastKillTime = level.time
        }
    } else if meansOfDeath == MOD_COLLISION || meansOfDeath == MOD_VEH_EXPLOSION {
        //no credit for veh-veh collisions?
    } else {
        if `self`.client != nil && `self`.client!.ps.isJediMaster {
            //killed ourself so return the saber to the original position
            //(to avoid people jumping off ledges and making the saber
            //unreachable for 60 seconds)
            ThrowSaberToAttacker(`self`, nil)
            `self`.client!.ps.isJediMaster = false
        }

        if g_gametype.integer == GT_DUEL {
            //in duel, if you kill yourself, the person you are dueling against gets a kill for it
            var otherClNum: Int32 = -1
            if level.sortedClients[0] == `self`.s.number {
                otherClNum = level.sortedClients[1]
            } else if level.sortedClients[1] == `self`.s.number {
                otherClNum = level.sortedClients[0]
            }

            if otherClNum >= 0 && otherClNum < MAX_CLIENTS && g_entities[otherClNum].inuse && g_entities[otherClNum].client != nil && otherClNum != `self`.s.number {
                AddScore(g_entities[otherClNum], `self`.r.currentOrigin, 1)
            } else {
                AddScore(`self`, `self`.r.currentOrigin, -1)
            }
        } else {
            AddScore(`self`, `self`.r.currentOrigin, -1)
        }
    }

    // Add team bonuses
    Team_FragBonuses(`self`, inflictor, attacker)

    // if I committed suicide, the flag does not fall, it returns.
    if meansOfDeath == MOD_SUICIDE {
        if `self`.client!.ps.powerups[PW_NEUTRALFLAG] != 0 {
            // only happens in One Flag CTF
            Team_ReturnFlag(TEAM_FREE)
            `self`.client!.ps.powerups[PW_NEUTRALFLAG] = 0
        } else if `self`.client!.ps.powerups[PW_REDFLAG] != 0 {
            // only happens in standard CTF
            Team_ReturnFlag(TEAM_RED)
            `self`.client!.ps.powerups[PW_REDFLAG] = 0
        } else if `self`.client!.ps.powerups[PW_BLUEFLAG] != 0 {
            // only happens in standard CTF
            Team_ReturnFlag(TEAM_BLUE)
            `self`.client!.ps.powerups[PW_BLUEFLAG] = 0
        }
    }

    // if client is in a nodrop area, don't drop anything (but return CTF flags!)
    contents = trap_PointContents(`self`.r.currentOrigin, -1)
    if !((contents & CONTENTS_NODROP) != 0) && `self`.client!.ps.fallingToDeath == 0 {
        if `self`.s.eType != ET_NPC {
            TossClientItems(`self`)
        }
    } else {
        if `self`.client!.ps.powerups[PW_NEUTRALFLAG] != 0 {
            // only happens in One Flag CTF
            Team_ReturnFlag(TEAM_FREE)
        } else if `self`.client!.ps.powerups[PW_REDFLAG] != 0 {
            // only happens in standard CTF
            Team_ReturnFlag(TEAM_RED)
        } else if `self`.client!.ps.powerups[PW_BLUEFLAG] != 0 {
            // only happens in standard CTF
            Team_ReturnFlag(TEAM_BLUE)
        }
    }

    if MOD_TEAM_CHANGE == meansOfDeath {
        // Give them back a point since they didn't really die.
        AddScore(`self`, `self`.r.currentOrigin, 1)
    } else {
        Cmd_Score_f(`self`) // show scores
    }

    // send updated scores to any clients that are following this one,
    // or they would get stale scoreboards
    i = 0
    while i < level.maxclients {
        var client: Client?

        client = level.clientsSlots[i]
        if client!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        if client!.sess.sessionTeam != TEAM_SPECTATOR {
            i += 1
            continue
        }
        if client!.sess.spectatorClient == `self`.s.number {
            Cmd_Score_f(g_entities[i])
        }
        i += 1
    }

    `self`.takedamage = true // can still be gibbed

    `self`.s.weapon = WP_NONE
    `self`.s.powerups = 0
    if `self`.s.eType != ET_NPC {
        //handled differently for NPCs
        `self`.r.contents = CONTENTS_CORPSE
    }
    `self`.client!.ps.zoomMode = 0 // Turn off zooming when we die

    //rww - 07/19/02 - I removed this because it isn't working and it's ugly (for people on the outside)
    /*
    self->s.angles[0] = 0;
    self->s.angles[2] = 0;
    LookAtKiller (self, inflictor, attacker);

    VectorCopy( self->s.angles, self->client->ps.viewangles );
    */

    `self`.s.loopSound = 0
    `self`.s.loopIsSoundset = false

    if `self`.s.eType != ET_NPC {
        //handled differently for NPCs
        `self`.r.maxs[2] = -8
    }

    // don't allow respawn until the death anim is done
    // g_forcerespawn may force spawning at some later time
    `self`.client!.respawnTime = level.time + 1700

    // remove powerups
    `self`.client!.ps.powerups.fill(0)

    // NOTENOTE No gib deaths right now, this is star wars.
    /*
    // never gib in a nodrop
    if ( (self->health <= GIB_HEALTH && !(contents & CONTENTS_NODROP) && g_blood.integer) || meansOfDeath == MOD_SUICIDE)
    {
    // gib death
    GibEntity( self, killer );
    }
    else
    */
    do {
        // normal death

        // Raven's static local `i` is `i_player_die`, a property of `GameWorld`.

        anim = G_PickDeathAnim(`self`, `self`.pos1, damage, meansOfDeath, HL_NONE)

        if anim >= 1 {
            //Some droids don't have death anims
            // for the no-blood option, we need to prevent the health
            // from going to gib level
            if `self`.health <= GIB_HEALTH {
                `self`.health = GIB_HEALTH + 1
            }

            `self`.client!.respawnTime = level.time + 1000 //((self->client->animations[anim].numFrames*40)/(50.0f / self->client->animations[anim].frameLerp))+300;

            sPMType = `self`.client!.ps.pm_type
            `self`.client!.ps.pm_type = PM_NORMAL //don't want pm type interfering with our setanim calls.

            if `self`.inuse {
                //not disconnecting
                G_SetAnim(`self`, nil, SETANIM_BOTH, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD | SETANIM_FLAG_RESTART, 0)
            }

            `self`.client!.ps.pm_type = sPMType

            if meansOfDeath == MOD_SABER || (meansOfDeath == MOD_MELEE && G_HeavyMelee(attacker)) {
                //update the anim on the actual skeleton (so bolt point will reflect the correct position) and then check for dismem
                G_UpdateClientAnims(`self`, 1.0)
                G_CheckForDismemberment(`self`, attacker, `self`.pos1, damage, anim, false)
            }
        } else if `self`.NPC != nil && `self`.client != nil && `self`.client!.NPC_class != CLASS_MARK1 && `self`.client!.NPC_class != CLASS_VEHICLE {
            //in this case if we're an NPC it's my guess that we want to get removed straight away.
            `self`.think = Think.G_FreeEntity
            `self`.nextthink = level.time
        }

        //self->client->ps.legsAnim = anim;
        //self->client->ps.torsoAnim = anim;
        //		self->client->ps.pm_flags |= PMF_UPDATE_ANIM;		// Make sure the pmove sets up the GHOUL2 anims.

        //rww - do this on respawn, not death
        //CopyToBodyQue (self);

        //G_AddEvent( self, EV_DEATH1 + i, killer );
        if wasJediMaster {
            G_AddEvent(`self`, EV_DEATH1 + i_player_die, 1)
        } else {
            G_AddEvent(`self`, EV_DEATH1 + i_player_die, 0)
        }

        if `self` != attacker {
            //don't make NPCs want to murder you on respawn for killing yourself!
            G_DeathAlert(`self`, attacker)
        }

        // the body can still be gibbed
        if `self`.NPC == nil {
            //don't remove NPCs like this!
            `self`.die = Die.body_die
        }

        //It won't gib, it will disintegrate (because this is Star Wars).
        `self`.takedamage = true

        // globally cycle through the different death animations
        i_player_die = (i_player_die + 1) % 3
    }

    if `self`.NPC != nil {
        //If an NPC, make sure we start running our scripts again- this gets set to infinite while we fall to our deaths
        `self`.NPC!.nextBStateThink = level.time
    }

    if G_ActivateBehavior(`self`, BSET_DEATH) {
        //deathScript = qtrue;
    }

    if `self`.NPC != nil && (`self`.NPC!.scriptFlags & SCF_FFDEATH) != 0 {
        if G_ActivateBehavior(`self`, BSET_FFDEATH) {
            //FIXME: should running this preclude running the normal deathscript?
            //deathScript = qtrue;
        }
        G_UseTargets2(`self`, `self`, `self`.target4!)
    }

    /*
    if ( !deathScript && !(self->svFlags&SVF_KILLED_SELF) )
    {
    //Should no longer run scripts
    //WARNING!!! DO NOT DO THIS WHILE RUNNING A SCRIPT, ICARUS WILL CRASH!!!
    //FIXME: shouldn't ICARUS handle this internally?
    ICARUS_FreeEnt(self);
    }
    */
    //rwwFIXMEFIXME: Do this too?

    // Free up any timers we may have on us.
    TIMER_Clear2(`self`)

    trap_LinkEntity(`self`)

    if `self`.NPC != nil {
        `self`.NPC!.timeOfDeath = level.time //this will change - used for debouncing post-death events
    }

    // Start any necessary death fx for this entity
    DeathFX(`self`)


    if g_gametype.integer == GT_POWERDUEL && !g_noPDuelCheck {
        //powerduel checks
        if `self`.client!.sess.duelTeam == DUELTEAM_LONE {
            //automatically means a win as there is only one
            G_AddPowerDuelScore(DUELTEAM_DOUBLE, 1)
            G_AddPowerDuelLoserScore(DUELTEAM_LONE, 1)
            g_endPDuel = true
        } else if `self`.client!.sess.duelTeam == DUELTEAM_DOUBLE {
            var i: Int32 = 0
            var check: Entity?
            var heLives: Bool = false

            while i < MAX_CLIENTS {
                check = g_entities[i]
                if check!.inuse && check!.client != nil && check!.s.number != `self`.s.number && check!.client!.pers.connected == CON_CONNECTED && !check!.client!.iAmALoser && check!.client!.ps.stats[STAT_HEALTH] > 0 && check!.client!.sess.sessionTeam != TEAM_SPECTATOR && check!.client!.sess.duelTeam == DUELTEAM_DOUBLE {
                    //still an active living paired duelist so it's not over yet.
                    heLives = true
                    break
                }
                i += 1
            }

            if !heLives {
                //they're all dead, give the lone duelist the win.
                G_AddPowerDuelScore(DUELTEAM_LONE, 1)
                G_AddPowerDuelLoserScore(DUELTEAM_DOUBLE, 1)
                g_endPDuel = true
            }
        }
    }
}

/**
```
================
CheckArmor
================
```
*/
/// Source: oracle/codemp/game/g_combat.c:3019
func CheckArmor(_ ent: Entity, _ damage: Int32, _ dflags: Int32) -> Int32 {
    var client: Client?
    var save: Int32
    let count: Int32

    if damage == 0 {
        return 0
    }

    client = ent.client

    if client == nil {
        return 0
    }

    if (dflags & DAMAGE_NO_ARMOR) != 0 {
        return 0
    }

    if client!.NPC_class == CLASS_VEHICLE && ent.m_pVehicle != nil && ent.client!.ps.electrifyTime > level.time {
        //ion-cannon has disabled this ship's shields, take damage on hull!
        return 0
    }
    // armor
    count = client!.ps.stats[STAT_ARMOR]

    if (dflags & DAMAGE_HALF_ABSORB) != 0 {
        // Half the damage gets absorbed by the shields, rather than 100%
        save = Int32(ceil(Double(damage) * ARMOR_PROTECTION))
    } else {
        // All the damage gets absorbed by the shields.
        save = damage
    }

    // save is the most damage that the armor is elibigle to protect, of course, but it's limited by the total armor.
    if save >= count {
        save = count
    }

    if save == 0 {
        return 0
    }

    if (dflags & DAMAGE_HALF_ARMOR_REDUCTION) != 0 {
        client!.ps.stats[STAT_ARMOR] -= Int32((Double(save) * ARMOR_REDUCTION_FACTOR))
    } else {
        client!.ps.stats[STAT_ARMOR] -= save
    }

    return save
}

/// Source: oracle/codemp/game/g_combat.c:3074
func G_ApplyKnockback(_ targ: Entity, _ newDir: JKAShared.vec3_t, _ knockback: Float) {
    var kvel = vec3_t()
    let mass: Float

    if targ.physicsBounce > 0 {
        mass = targ.physicsBounce
    } else {
        mass = 200
    }

    if g_gravity.value > 0 {
        kvel = newDir * (Float(Double(g_knockback.value * Float(knockback) / mass) * 0.8))
        kvel[2] = Float(Double(newDir[2] * g_knockback.value * Float(knockback) / mass) * 1.5)
    } else {
        kvel = newDir * (g_knockback.value * Float(knockback) / mass)
    }

    if targ.client != nil {
        targ.client!.ps.velocity = targ.client!.ps.velocity + kvel
    } else if targ.s.pos.trType != TR_STATIONARY && targ.s.pos.trType != TR_LINEAR_STOP && targ.s.pos.trType != TR_NONLINEAR_STOP {
        targ.s.pos.trDelta = targ.s.pos.trDelta + kvel
        targ.s.pos.trBase = targ.r.currentOrigin
        targ.s.pos.trTime = level.time
    }

    // set the timer so that the other client can't cancel
    // out the movement immediately
    if targ.client != nil && targ.client!.ps.pm_time == 0 {
        var t: Int32

        t = Int32(knockback * 2)
        if t < 50 {
            t = 50
        }
        if t > 200 {
            t = 200
        }
        targ.client!.ps.pm_time = t
        targ.client!.ps.pm_flags |= PMF_TIME_KNOCKBACK
    }
}

/**
```
================
RaySphereIntersections
================
```
*/
/// Source: oracle/codemp/game/g_combat.c:3128
func RaySphereIntersections(_ origin: JKAShared.vec3_t, _ radius: Float, _ point: JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t, _ intersections: inout [JKAShared.vec3_t]) -> Int32 {
    let b: Float
    let c: Float
    let d: Float
    var t: Float

    //	| origin - (point + t * dir) | = radius
    //	a = dir[0]^2 + dir[1]^2 + dir[2]^2;
    //	b = 2 * (dir[0] * (point[0] - origin[0]) + dir[1] * (point[1] - origin[1]) + dir[2] * (point[2] - origin[2]));
    //	c = (point[0] - origin[0])^2 + (point[1] - origin[1])^2 + (point[2] - origin[2])^2 - radius^2;

    // normalize dir so a = 1
    VectorNormalize(&dir)
    b = 2 * (dir[0] * (point[0] - origin[0]) + dir[1] * (point[1] - origin[1]) + dir[2] * (point[2] - origin[2]))
    c = (point[0] - origin[0]) * (point[0] - origin[0]) + (point[1] - origin[1]) * (point[1] - origin[1]) + (point[2] - origin[2]) * (point[2] - origin[2]) - radius * radius

    d = b * b - 4 * c
    if d > 0 {
        t = (-b + sqrt(d)) / 2
        _VectorMA(point, t, dir, &intersections[0])
        t = (-b - sqrt(d)) / 2
        _VectorMA(point, t, dir, &intersections[1])
        return 2
    } else if d == 0 {
        t = (-b) / 2
        _VectorMA(point, t, dir, &intersections[0])
        return 1
    }
    return 0
}

/// Source: oracle/codemp/game/g_combat.c:3192
func G_GetDismemberLoc(_ `self`: Entity, _ boltPoint: inout JKAShared.vec3_t, _ limbType: Int32) {
    //Just get the general area without using server-side ghoul2
    var fwd = vec3_t()
    var right = vec3_t()
    var up = vec3_t()

    AngleVectors(`self`.r.currentAngles, &fwd, &right, &up)

    boltPoint = `self`.r.currentOrigin

    switch limbType {
    case G2_MODELPART_HEAD:
        boltPoint[0] += up[0] * 24
        boltPoint[1] += up[1] * 24
        boltPoint[2] += up[2] * 24

    case G2_MODELPART_WAIST:
        boltPoint[0] += up[0] * 4
        boltPoint[1] += up[1] * 4
        boltPoint[2] += up[2] * 4

    case G2_MODELPART_LARM:
        boltPoint[0] += up[0] * 18
        boltPoint[1] += up[1] * 18
        boltPoint[2] += up[2] * 18

        boltPoint[0] -= right[0] * 10
        boltPoint[1] -= right[1] * 10
        boltPoint[2] -= right[2] * 10

    case G2_MODELPART_RARM:
        boltPoint[0] += up[0] * 18
        boltPoint[1] += up[1] * 18
        boltPoint[2] += up[2] * 18

        boltPoint[0] += right[0] * 10
        boltPoint[1] += right[1] * 10
        boltPoint[2] += right[2] * 10

    case G2_MODELPART_RHAND:
        boltPoint[0] += up[0] * 8
        boltPoint[1] += up[1] * 8
        boltPoint[2] += up[2] * 8

        boltPoint[0] += right[0] * 10
        boltPoint[1] += right[1] * 10
        boltPoint[2] += right[2] * 10

    case G2_MODELPART_LLEG:
        boltPoint[0] -= up[0] * 4
        boltPoint[1] -= up[1] * 4
        boltPoint[2] -= up[2] * 4

        boltPoint[0] -= right[0] * 10
        boltPoint[1] -= right[1] * 10
        boltPoint[2] -= right[2] * 10

    case G2_MODELPART_RLEG:
        boltPoint[0] -= up[0] * 4
        boltPoint[1] -= up[1] * 4
        boltPoint[2] -= up[2] * 4

        boltPoint[0] += right[0] * 10
        boltPoint[1] += right[1] * 10
        boltPoint[2] += right[2] * 10

    default:
        break
    }

    return
}

/// Source: oracle/codemp/game/g_combat.c:3264
func G_GetDismemberBolt(_ `self`: Entity, _ boltPoint: inout JKAShared.vec3_t, _ limbType: Int32) {
    var useBolt: Int32 = `self`.genericValue5
    var properOrigin = vec3_t()
    var properAngles = vec3_t()
    var addVel = vec3_t()
    //vec3_t legAxis[3];
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        var fVSpeed: Float = 0
        var rotateBone: String? = nil

        switch limbType {
        case G2_MODELPART_HEAD:
            rotateBone = "cranium"

        case G2_MODELPART_WAIST:
            if `self`.localAnimIndex <= 1 {
                //humanoid
                rotateBone = "thoracic"
            } else {
                rotateBone = "pelvis"
            }

        case G2_MODELPART_LARM:
            rotateBone = "lradius"

        case G2_MODELPART_RARM:
            rotateBone = "rradius"

        case G2_MODELPART_RHAND:
            rotateBone = "rhand"

        case G2_MODELPART_LLEG:
            rotateBone = "ltibia"

        case G2_MODELPART_RLEG:
            rotateBone = "rtibia"

        default:
            rotateBone = "rtibia"
        }

        useBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, rotateBone!)

        properOrigin = `self`.client!.ps.origin
        properAngles = `self`.client!.ps.viewangles

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

        fVSpeed = Float(Double(fVSpeed) * 0.08)

        properOrigin[0] += addVel[0] * fVSpeed
        properOrigin[1] += addVel[1] * fVSpeed
        properOrigin[2] += addVel[2] * fVSpeed

        properAngles[0] = 0
        properAngles[1] = `self`.client!.ps.viewangles[YAW]
        properAngles[2] = 0

        trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, useBolt, boltMatrix, properAngles, properOrigin, level.time, nil, &`self`.modelScale)

        boltPoint[0] = boltMatrix.matrix[0][3]
        boltPoint[1] = boltMatrix.matrix[1][3]
        boltPoint[2] = boltMatrix.matrix[2][3]

        trap_G2API_GetBoltMatrix(`self`.ghoul2, 1, 0, boltMatrix, properAngles, properOrigin, level.time, nil, &`self`.modelScale)

        if `self`.client != nil && limbType == G2_MODELPART_RHAND {
            //Make some saber hit sparks over the severed wrist area
            var boltAngles = vec3_t()
            var te: Entity?

            boltAngles[0] = -boltMatrix.matrix[0][1]
            boltAngles[1] = -boltMatrix.matrix[1][1]
            boltAngles[2] = -boltMatrix.matrix[2][1]

            te = G_TempEntity(boltPoint, EV_SABER_HIT)
            te!.s.otherEntityNum = `self`.s.number
            te!.s.otherEntityNum2 = ENTITYNUM_NONE
            te!.s.weapon = 0 //saberNum
            te!.s.legsAnim = 0 //bladeNum

            te!.s.origin = boltPoint
            te!.s.angles = boltAngles

            if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
                //don't let it play with no direction
                te!.s.angles[1] = 1
            }

            te!.s.eventParm = 16 //lots of sparks
        }
    }
}

/// Source: oracle/codemp/game/g_combat.c:3387
func LimbTouch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
}

/// Source: oracle/codemp/game/g_combat.c:3391
func LimbThink(_ ent: Entity) {
    let gravity: Float = 3.0
    var mass: Float = 0.09
    var bounce: Float = 1.3

    switch ent.s.modelGhoul2 {
    case G2_MODELPART_HEAD:
        mass = 0.08
        bounce = 1.4

    case G2_MODELPART_WAIST:
        mass = 0.1
        bounce = 1.2

    default:
        break
    }

    if ent.speed < level.time {
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
        return
    }

    if ent.genericValue5 <= level.time {
        //this will be every frame by standard, but we want to compensate in case sv_fps is not 20.
        G_RunExPhys(ent, gravity, mass, bounce, true, nil, 0)
        ent.genericValue5 = level.time + 50
    }

    ent.nextthink = level.time
}

/// Source: oracle/codemp/game/g_combat.c:3436
func G_Dismember(_ ent: Entity, _ enemy: Entity, _ point: JKAShared.vec3_t, _ limbType: Int32, _ limbRollBase: Float, _ limbPitchBase: Float, _ deathAnim: Int32, _ postDeath: Bool) {
    var newPoint = vec3_t()
    var dir = vec3_t()
    var vel = vec3_t()
    var limb: Entity?
    var limbName = CharBuf(64)
    var stubName = CharBuf(64)
    var stubCapName = CharBuf(64)

    if limbType == G2_MODELPART_HEAD {
        Q_strncpyz(&limbName, "head", Int32((limbName).count))
        Q_strncpyz(&stubCapName, "torso_cap_head", Int32((stubCapName).count))
    } else if limbType == G2_MODELPART_WAIST {
        Q_strncpyz(&limbName, "torso", Int32((limbName).count))
        Q_strncpyz(&stubCapName, "hips_cap_torso", Int32((stubCapName).count))
    } else if limbType == G2_MODELPART_LARM {
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "l_arm", &limbName, Int32((limbName).count))
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "torso", &stubName, Int32((stubName).count))
        Com_sprintf(&stubCapName, Int32((stubCapName).count), "%s_cap_l_arm", stubName)
    } else if limbType == G2_MODELPART_RARM {
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "r_arm", &limbName, Int32((limbName).count))
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "torso", &stubName, Int32((stubName).count))
        Com_sprintf(&stubCapName, Int32((stubCapName).count), "%s_cap_r_arm", stubName)
    } else if limbType == G2_MODELPART_RHAND {
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "r_hand", &limbName, Int32((limbName).count))
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "r_arm", &stubName, Int32((stubName).count))
        Com_sprintf(&stubCapName, Int32((stubCapName).count), "%s_cap_r_hand", stubName)
    } else if limbType == G2_MODELPART_LLEG {
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "l_leg", &limbName, Int32((limbName).count))
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "hips", &stubName, Int32((stubName).count))
        Com_sprintf(&stubCapName, Int32((stubCapName).count), "%s_cap_l_leg", stubName)
    } else if limbType == G2_MODELPART_RLEG {
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "r_leg", &limbName, Int32((limbName).count))
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "hips", &stubName, Int32((stubName).count))
        Com_sprintf(&stubCapName, Int32((stubCapName).count), "%s_cap_r_leg", stubName)
    } else {
        //umm... just default to the right leg, I guess (same as on client)
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "r_leg", &limbName, Int32((limbName).count))
        BG_GetRootSurfNameWithVariant(ent.ghoul2, "hips", &stubName, Int32((stubName).count))
        Com_sprintf(&stubCapName, Int32((stubCapName).count), "%s_cap_r_leg", stubName)
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'".
    // Raven wrote: if (ent->ghoul2 && limbName && trap_G2API_GetSurfaceRenderStatus(ent->ghoul2, 0, limbName)) { //is it already off? If so there's no reason to be doing it again, so get out of here. return; }
    portMissing("G_Dismember", source: "oracle/codemp/game/g_combat.c:3436")

    newPoint = point
    limb = G_Spawn()
    limb!.classname = "playerlimb"

    /*
    if (limbType == G2_MODELPART_WAIST)
    { //slight hack
    newPoint[2] += 1;
    }
    */

    G_SetOrigin(limb!, &newPoint)
    limb!.s.pos.trBase = newPoint
    limb!.think = Think.LimbThink
    limb!.touch = Touch.LimbTouch
    limb!.speed = Float(level.time + Q_irand(8000, 16000))
    limb!.nextthink = level.time + FRAMETIME

    limb!.r.svFlags = SVF_USE_CURRENT_ORIGIN
    limb!.clipmask = MASK_SOLID
    limb!.r.contents = CONTENTS_TRIGGER
    limb!.physicsObject = true
    limb!.r.mins = vec3_t(-6.0, -6.0, -3.0)
    limb!.r.maxs = vec3_t(6.0, 6.0, 6.0)

    limb!.s.g2radius = 200

    limb!.s.eType = ET_GENERAL
    limb!.s.weapon = G2_MODEL_PART
    limb!.s.modelGhoul2 = limbType
    limb!.s.modelindex = ent.s.number
    if ent.client == nil {
        limb!.s.modelindex = -1
        limb!.s.otherEntityNum2 = ent.s.number
    }

    limb!.s.apos.trDelta = vec3_t()

    if ent.client != nil {
        limb!.r.currentAngles = ent.client!.ps.viewangles
        limb!.s.apos.trBase = ent.client!.ps.viewangles
    } else {
        limb!.r.currentAngles = ent.r.currentAngles
        limb!.s.apos.trBase = ent.r.currentAngles
    }

    //Set up the ExPhys values for the entity.
    limb!.epGravFactor = 0
    limb!.epVelocity = vec3_t()
    dir = point - ent.r.currentOrigin
    VectorNormalize(&dir)
    if ent.client != nil {
        vel = ent.client!.ps.velocity
    } else {
        vel = ent.s.pos.trDelta
    }
    _VectorMA(vel, 80, dir, &limb!.epVelocity)

    //add some vertical velocity
    if limbType == G2_MODELPART_HEAD || limbType == G2_MODELPART_WAIST {
        limb!.epVelocity[2] += 10
    }

    if enemy.client != nil && ent != enemy && ent.s.number != enemy.s.number && enemy.client!.ps.weapon == WP_SABER && enemy.client!.olderIsValid && (level.time - enemy.client!.lastSaberStorageTime) < 200 {
        //The enemy has valid saber positions between this and last frame. Use them to factor in direction of the limb.
        var dif = vec3_t()
        var totalDistance: Float
        let distScale: Float = 1.2

        //scale down the initial velocity first, which is based on the speed of the limb owner.
        //ExPhys object velocity operates on a slightly different scale than Q3-based physics velocity.
        limb!.epVelocity = limb!.epVelocity * 0.4

        dif = enemy.client!.lastSaberBase_Always - enemy.client!.olderSaberBase
        totalDistance = VectorNormalize(&dif)

        dif = dif * (totalDistance * distScale)
        limb!.epVelocity = limb!.epVelocity + dif

        if ent.client != nil && (ent.client!.ps.torsoTimer > 0 || !BG_InDeathAnim(ent.client!.ps.torsoAnim)) {
            //if he's done with his death anim we don't actually want the limbs going far
            var preVel = vec3_t()

            preVel = limb!.epVelocity
            preVel[2] = 0
            totalDistance = VectorNormalize(&preVel)

            if totalDistance < 40.0 {
                let mAmt: Float = 40.0

                limb!.epVelocity[0] = preVel[0] * mAmt
                limb!.epVelocity[1] = preVel[1] * mAmt
            }
        } else if ent.client != nil {
            limb!.epVelocity = limb!.epVelocity * 0.3
        }
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'".
    // Raven wrote: if (ent->s.eType == ET_NPC && ent->ghoul2 && limbName && stubCapName) { //if it's an npc remove these surfs on the server too. For players we don't even care cause there's no further dismemberment after death. trap_G2API_SetSurfaceOnOff(ent->ghoul2, limbName, 0x00000100); trap_G2API_SetSurfaceOnOff(ent->ghoul2, stubCapName, 0); }
    portMissing("G_Dismember", source: "oracle/codemp/game/g_combat.c:3436")

    limb!.s.customRGBA[0] = ent.s.customRGBA[0]
    limb!.s.customRGBA[1] = ent.s.customRGBA[1]
    limb!.s.customRGBA[2] = ent.s.customRGBA[2]
    limb!.s.customRGBA[3] = ent.s.customRGBA[3]

    trap_LinkEntity(limb!)
}

/// Source: oracle/codemp/game/g_combat.c:3622
func DismembermentTest(_ `self`: Entity) {
    var sect: Int32 = G2_MODELPART_HEAD
    var boltPoint = vec3_t()

    while sect <= G2_MODELPART_RLEG {
        G_GetDismemberBolt(`self`, &boltPoint, sect)
        G_Dismember(`self`, `self`, boltPoint, sect, 90, 0, BOTH_DEATH1, false)
        sect += 1
    }
}

/// Source: oracle/codemp/game/g_combat.c:3635
func DismembermentByNum(_ `self`: Entity, _ num: Int32) {
    var sect: Int32 = G2_MODELPART_HEAD
    var boltPoint = vec3_t()

    switch num {
    case 0:
        sect = G2_MODELPART_HEAD

    case 1:
        sect = G2_MODELPART_WAIST

    case 2:
        sect = G2_MODELPART_LARM

    case 3:
        sect = G2_MODELPART_RARM

    case 4:
        sect = G2_MODELPART_RHAND

    case 5:
        sect = G2_MODELPART_LLEG

    case 6:
        sect = G2_MODELPART_RLEG

    default:
        break
    }

    G_GetDismemberBolt(`self`, &boltPoint, sect)
    G_Dismember(`self`, `self`, boltPoint, sect, 90, 0, BOTH_DEATH1, false)
}

/// Source: oracle/codemp/game/g_combat.c:3671
func G_GetHitQuad(_ `self`: Entity, _ hitloc: JKAShared.vec3_t) -> Int32 {
    var diff = vec3_t()
    var fwdangles = vec3_t(0, 0, 0)
    var right = vec3_t()
    var clEye = vec3_t()
    let rightdot: Float
    let zdiff: Float
    var hitLoc: Int32 = gPainHitLoc

    if `self`.client != nil {
        clEye = `self`.client!.ps.origin
        clEye[2] += `self`.client!.ps.viewheight
    } else {
        clEye = `self`.s.pos.trBase
        clEye[2] += 16
    }

    diff = hitloc - clEye
    diff[2] = 0
    VectorNormalize(&diff)

    if `self`.client != nil {
        fwdangles[1] = `self`.client!.ps.viewangles[1]
    } else {
        fwdangles[1] = `self`.s.apos.trBase[1]
    }
    // Ultimately we might care if the shot was ahead or behind, but for now, just quadrant is fine.
    // Raven passes NULL for the `forward` and `up` outputs.
    var scratchForward = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(fwdangles, &scratchForward, &right, &scratchUp)

    rightdot = _DotProduct(right, diff)
    zdiff = hitloc[2] - clEye[2]

    if zdiff > 0 {
        if Double(rightdot) > 0.3 {
            hitLoc = G2_MODELPART_RARM
        } else if Double(rightdot) < -0.3 {
            hitLoc = G2_MODELPART_LARM
        } else {
            hitLoc = G2_MODELPART_HEAD
        }
    } else if zdiff > -20 {
        if Double(rightdot) > 0.1 {
            hitLoc = G2_MODELPART_RARM
        } else if Double(rightdot) < -0.1 {
            hitLoc = G2_MODELPART_LARM
        } else {
            hitLoc = G2_MODELPART_HEAD
        }
    } else {
        if rightdot >= 0 {
            hitLoc = G2_MODELPART_RLEG
        } else {
            hitLoc = G2_MODELPART_LLEG
        }
    }

    return hitLoc
}

/// Source: oracle/codemp/game/g_combat.c:3757
func G_GetHitLocFromSurfName(_ ent: Entity, _ surfName: String, _ hitLoc: inout Int32, _ point: JKAShared.vec3_t?, _ dir: JKAShared.vec3_t?, _ bladeDir: JKAShared.vec3_t, _ mod: Int32) -> Bool {
    var dismember: Bool = false
    var actualTime: Int32 = 0
    var kneeLBolt: Int32 = -1
    var kneeRBolt: Int32 = -1
    var handRBolt: Int32 = -1
    var handLBolt: Int32 = -1
    var footRBolt: Int32 = -1
    var footLBolt: Int32 = -1

    hitLoc = HL_NONE

    if surfName.isEmpty {
        return false
    }

    if ent.client == nil {
        return false
    }

    if point == nil {
        return false
    }

    // Raven tests `ent->client->NPC_class == CLASS_R2D2` and `ent->client->NPC_class == CLASS_R2D2`.
    // Both read as the same Swift test, so the draft writes it once.
    if ent.client != nil && (ent.client!.NPC_class == CLASS_R2D2 || ent.client!.NPC_class == CLASS_GONK || ent.client!.NPC_class == CLASS_MOUSE || ent.client!.NPC_class == CLASS_SENTRY || ent.client!.NPC_class == CLASS_INTERROGATOR || ent.client!.NPC_class == CLASS_SENTRY || ent.client!.NPC_class == CLASS_PROBE) {
        //we don't care about per-surface hit-locations or dismemberment for these guys
        return false
    }

    if ent.localAnimIndex <= 1 {
        //humanoid
        handLBolt = trap_G2API_AddBolt(ent.ghoul2, 0, "*l_hand")
        handRBolt = trap_G2API_AddBolt(ent.ghoul2, 0, "*r_hand")
        kneeLBolt = trap_G2API_AddBolt(ent.ghoul2, 0, "*hips_l_knee")
        kneeRBolt = trap_G2API_AddBolt(ent.ghoul2, 0, "*hips_r_knee")
        footLBolt = trap_G2API_AddBolt(ent.ghoul2, 0, "*l_leg_foot")
        footRBolt = trap_G2API_AddBolt(ent.ghoul2, 0, "*r_leg_foot")
    }

    if ent.client != nil && (ent.client!.NPC_class == CLASS_ATST) {
        //FIXME: almost impossible to hit these... perhaps we should
        //		check for splashDamage and do radius damage to these parts?
        //		Or, if we ever get bbox G2 traces, that may fix it, too
        if Q_stricmp("head_light_blaster_cann", surfName) == 0 {
            hitLoc = HL_ARM_LT
        } else if Q_stricmp("head_concussion_charger", surfName) == 0 {
            hitLoc = HL_ARM_RT
        }
        return (false)
    } else if ent.client != nil && (ent.client!.NPC_class == CLASS_MARK1) {
        if Q_stricmp("l_arm", surfName) == 0 {
            hitLoc = HL_ARM_LT
        } else if Q_stricmp("r_arm", surfName) == 0 {
            hitLoc = HL_ARM_RT
        } else if Q_stricmp("torso_front", surfName) == 0 {
            hitLoc = HL_CHEST
        } else if Q_stricmp("torso_tube1", surfName) == 0 {
            hitLoc = HL_GENERIC1
        } else if Q_stricmp("torso_tube2", surfName) == 0 {
            hitLoc = HL_GENERIC2
        } else if Q_stricmp("torso_tube3", surfName) == 0 {
            hitLoc = HL_GENERIC3
        } else if Q_stricmp("torso_tube4", surfName) == 0 {
            hitLoc = HL_GENERIC4
        } else if Q_stricmp("torso_tube5", surfName) == 0 {
            hitLoc = HL_GENERIC5
        } else if Q_stricmp("torso_tube6", surfName) == 0 {
            hitLoc = HL_GENERIC6
        }
        return (false)
    } else if ent.client != nil && (ent.client!.NPC_class == CLASS_MARK2) {
        if Q_stricmp("torso_canister1", surfName) == 0 {
            hitLoc = HL_GENERIC1
        } else if Q_stricmp("torso_canister2", surfName) == 0 {
            hitLoc = HL_GENERIC2
        } else if Q_stricmp("torso_canister3", surfName) == 0 {
            hitLoc = HL_GENERIC3
        }
        return (false)
    } else if ent.client != nil && (ent.client!.NPC_class == CLASS_GALAKMECH) {
        if Q_stricmp("torso_antenna", surfName) == 0 || Q_stricmp("torso_antenna_base", surfName) == 0 {
            hitLoc = HL_GENERIC1
        } else if Q_stricmp("torso_shield", surfName) == 0 {
            hitLoc = HL_GENERIC2
        } else {
            hitLoc = HL_CHEST
        }
        return (false)
    }

    //FIXME: check the hitLoc and hitDir against the cap tag for the place
    //where the split will be- if the hit dir is roughly perpendicular to
    //the direction of the cap, then the split is allowed, otherwise we
    //hit it at the wrong angle and should not dismember...
    actualTime = level.time
    if Q_strncmp("hips", surfName, 4) == 0 {
        //FIXME: test properly for legs
        hitLoc = HL_WAIST
        if ent.client != nil && ent.ghoul2 != nil {
            // Raven's record lives to the end of his block, so the block is the closure.
            MdxaBone.scratch { boltMatrix in
                var tagOrg = vec3_t()
                var angles = vec3_t()

                angles = vec3_t(0, ent.r.currentAngles[YAW], 0)
                if kneeLBolt >= 0 {
                    trap_G2API_GetBoltMatrix(ent.ghoul2, 0, kneeLBolt, boltMatrix, angles, ent.r.currentOrigin, actualTime, nil, &ent.modelScale)
                    BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &tagOrg)
                    if DistanceSquared(point!, tagOrg) < 100 {
                        //actually hit the knee
                        hitLoc = HL_LEG_LT
                    }
                }
                if hitLoc == HL_WAIST {
                    if kneeRBolt >= 0 {
                        trap_G2API_GetBoltMatrix(ent.ghoul2, 0, kneeRBolt, boltMatrix, angles, ent.r.currentOrigin, actualTime, nil, &ent.modelScale)
                        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &tagOrg)
                        if DistanceSquared(point!, tagOrg) < 100 {
                            //actually hit the knee
                            hitLoc = HL_LEG_RT
                        }
                    }
                }
            }
        }
    } else if Q_strncmp("torso", surfName, 5) == 0 {
        if ent.client == nil {
            hitLoc = HL_CHEST
        } else {
            var t_fwd = vec3_t()
            var t_rt = vec3_t()
            var t_up = vec3_t()
            var dirToImpact = vec3_t()
            var frontSide: Float = 0
            var rightSide: Float = 0
            var upSide: Float = 0
            AngleVectors(ent.client!.renderInfo.torsoAngles, &t_fwd, &t_rt, &t_up)

            if ent.client!.renderInfo.boltValidityTime != level.time {
                var renderAng = vec3_t()

                renderAng[0] = 0
                renderAng[1] = ent.client!.ps.viewangles[YAW]
                renderAng[2] = 0

                UpdateClientRenderBolts(ent, ent.client!.ps.origin, renderAng)
            }

            dirToImpact = point! - ent.client!.renderInfo.torsoPoint
            frontSide = _DotProduct(t_fwd, dirToImpact)
            rightSide = _DotProduct(t_rt, dirToImpact)
            upSide = _DotProduct(t_up, dirToImpact)
            if upSide < -10 {
                //hit at waist
                hitLoc = HL_WAIST
            } else {
                //hit on upper torso
                if rightSide > 4 {
                    hitLoc = HL_ARM_RT
                } else if rightSide < -4 {
                    hitLoc = HL_ARM_LT
                } else if rightSide > 2 {
                    if frontSide > 0 {
                        hitLoc = HL_CHEST_RT
                    } else {
                        hitLoc = HL_BACK_RT
                    }
                } else if rightSide < -2 {
                    if frontSide > 0 {
                        hitLoc = HL_CHEST_LT
                    } else {
                        hitLoc = HL_BACK_LT
                    }
                } else if upSide > -3 && mod == MOD_SABER {
                    hitLoc = HL_HEAD
                } else if frontSide > 0 {
                    hitLoc = HL_CHEST
                } else {
                    hitLoc = HL_BACK
                }
            }
        }
    } else if Q_strncmp("head", surfName, 4) == 0 {
        hitLoc = HL_HEAD
    } else if Q_strncmp("r_arm", surfName, 5) == 0 {
        hitLoc = HL_ARM_RT
        if ent.client != nil && ent.ghoul2 != nil {
            // Raven's record lives to the end of his block, so the block is the closure.
            MdxaBone.scratch { boltMatrix in
                var tagOrg = vec3_t()
                var angles = vec3_t()

                angles = vec3_t(0, ent.r.currentAngles[YAW], 0)
                if handRBolt >= 0 {
                    trap_G2API_GetBoltMatrix(ent.ghoul2, 0, handRBolt, boltMatrix, angles, ent.r.currentOrigin, actualTime, nil, &ent.modelScale)
                    BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &tagOrg)
                    if DistanceSquared(point!, tagOrg) < 256 {
                        //actually hit the hand
                        hitLoc = HL_HAND_RT
                    }
                }
            }
        }
    } else if Q_strncmp("l_arm", surfName, 5) == 0 {
        hitLoc = HL_ARM_LT
        if ent.client != nil && ent.ghoul2 != nil {
            // Raven's record lives to the end of his block, so the block is the closure.
            MdxaBone.scratch { boltMatrix in
                var tagOrg = vec3_t()
                var angles = vec3_t()

                angles = vec3_t(0, ent.r.currentAngles[YAW], 0)
                if handLBolt >= 0 {
                    trap_G2API_GetBoltMatrix(ent.ghoul2, 0, handLBolt, boltMatrix, angles, ent.r.currentOrigin, actualTime, nil, &ent.modelScale)
                    BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &tagOrg)
                    if DistanceSquared(point!, tagOrg) < 256 {
                        //actually hit the hand
                        hitLoc = HL_HAND_LT
                    }
                }
            }
        }
    } else if Q_strncmp("r_leg", surfName, 5) == 0 {
        hitLoc = HL_LEG_RT
        if ent.client != nil && ent.ghoul2 != nil {
            // Raven's record lives to the end of his block, so the block is the closure.
            MdxaBone.scratch { boltMatrix in
                var tagOrg = vec3_t()
                var angles = vec3_t()

                angles = vec3_t(0, ent.r.currentAngles[YAW], 0)
                if footRBolt >= 0 {
                    trap_G2API_GetBoltMatrix(ent.ghoul2, 0, footRBolt, boltMatrix, angles, ent.r.currentOrigin, actualTime, nil, &ent.modelScale)
                    BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &tagOrg)
                    if DistanceSquared(point!, tagOrg) < 100 {
                        //actually hit the foot
                        hitLoc = HL_FOOT_RT
                    }
                }
            }
        }
    } else if Q_strncmp("l_leg", surfName, 5) == 0 {
        hitLoc = HL_LEG_LT
        if ent.client != nil && ent.ghoul2 != nil {
            // Raven's record lives to the end of his block, so the block is the closure.
            MdxaBone.scratch { boltMatrix in
                var tagOrg = vec3_t()
                var angles = vec3_t()

                angles = vec3_t(0, ent.r.currentAngles[YAW], 0)
                if footLBolt >= 0 {
                    trap_G2API_GetBoltMatrix(ent.ghoul2, 0, footLBolt, boltMatrix, angles, ent.r.currentOrigin, actualTime, nil, &ent.modelScale)
                    BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &tagOrg)
                    if DistanceSquared(point!, tagOrg) < 100 {
                        //actually hit the foot
                        hitLoc = HL_FOOT_LT
                    }
                }
            }
        }
    } else if Q_strncmp("r_hand", surfName, 6) == 0 || Q_strncmp("w_", surfName, 2) == 0 {
        //right hand or weapon
        hitLoc = HL_HAND_RT
    } else if Q_strncmp("l_hand", surfName, 6) == 0 {
        hitLoc = HL_HAND_LT
    }
    /*
    #ifdef _DEBUG
    else
    {
    Com_Printf( "ERROR: surface %s does not belong to any hitLocation!!!\n", surfName );
    }
    #endif //_DEBUG
    */

    //if ( g_dismemberment->integer >= 11381138 || !ent->client->dismembered )
    if g_dismember.integer == 100 {
        //full probability...
        if ent.client != nil && ent.client!.NPC_class == CLASS_PROTOCOL {
            dismember = true
        } else if dir != nil && (dir![0] != 0 || dir![1] != 0 || dir![2] != 0) && (bladeDir[0] != 0 || bladeDir[1] != 0 || bladeDir[2] != 0) {
            //we care about direction (presumably for dismemberment)
            //if ( g_dismemberProbabilities->value<=0.0f||G_Dismemberable( ent, *hitLoc ) )
            if 1 != 0 {
                //either we don't care about probabilties or the probability let us continue
                var tagName: String? = nil
                var aoa: Float = 0.5
                //dir must be roughly perpendicular to the hitLoc's cap bolt
                switch hitLoc {
                case HL_LEG_RT:
                    tagName = "*hips_cap_r_leg"

                case HL_LEG_LT:
                    tagName = "*hips_cap_l_leg"

                case HL_WAIST:
                    tagName = "*hips_cap_torso"
                    aoa = 0.25

                case HL_CHEST_RT, HL_ARM_RT, HL_BACK_LT:
                    tagName = "*torso_cap_r_arm"

                case HL_CHEST_LT, HL_ARM_LT, HL_BACK_RT:
                    tagName = "*torso_cap_l_arm"

                case HL_HAND_RT:
                    tagName = "*r_arm_cap_r_hand"

                case HL_HAND_LT:
                    tagName = "*l_arm_cap_l_hand"

                case HL_HEAD:
                    tagName = "*torso_cap_head"
                    aoa = 0.25

                default:
                    //no dismemberment possible with these, so no checks needed
                    break
                }
                if tagName != nil {
                    let tagBolt: Int32 = trap_G2API_AddBolt(ent.ghoul2, 0, tagName!)
                    if tagBolt != -1 {
                        // Raven's record lives to the end of his block, so the block is the closure.
                        MdxaBone.scratch { boltMatrix in
                            var tagOrg = vec3_t()
                            var tagDir = vec3_t()
                            var angles = vec3_t()

                            angles = vec3_t(0, ent.r.currentAngles[YAW], 0)
                            trap_G2API_GetBoltMatrix(ent.ghoul2, 0, tagBolt, boltMatrix, angles, ent.r.currentOrigin, actualTime, nil, &ent.modelScale)
                            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &tagOrg)
                            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &tagDir)
                            if DistanceSquared(point!, tagOrg) < 256 {
                                //hit close
                                var dot: Float = _DotProduct(dir!, tagDir)
                                if dot < aoa && dot > -aoa {
                                    //hit roughly perpendicular
                                    dot = _DotProduct(bladeDir, tagDir)
                                    if dot < aoa && dot > -aoa {
                                        //blade was roughly perpendicular
                                        dismember = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            //hmm, no direction supplied.
            dismember = true
        }
    }
    return dismember
}

/// Source: oracle/codemp/game/g_combat.c:4218
func G_CheckForDismemberment(_ ent: Entity, _ enemy: Entity, _ point: JKAShared.vec3_t, _ damage: Int32, _ deathAnim: Int32, _ postDeath: Bool) {
    var hitLoc: Int32 = -1
    var hitLocUse: Int32 = -1
    var boltPoint = vec3_t()
    let dismember: Int32 = g_dismember.integer

    if ent.localAnimIndex > 1 {
        if ent.NPC == nil {
            return
        }

        if ent.client!.NPC_class != CLASS_PROTOCOL {
            //this is the only non-humanoid allowed to do dismemberment.
            return
        }
    }

    if dismember == 0 {
        return
    }

    if gGAvoidDismember == 1 {
        return
    }

    if gGAvoidDismember != 2 {
        //this means do the dismemberment regardless of randomness and damage
        if Q_irand(0, 100) > dismember {
            return
        }

        if damage < 5 {
            return
        }
    }

    if gGAvoidDismember == 2 {
        hitLoc = HL_HAND_RT
    } else {
        if d_saberGhoul2Collision.integer != 0 && ent.client != nil && ent.client!.g2LastSurfaceTime == level.time {
            var hitSurface = CharBuf(64)

            strcpy(&hitSurface, trap_G2API_GetSurfaceName(ent.ghoul2, ent.client!.g2LastSurfaceHit, 0))

            if hitSurface[0] != 0 {
                G_GetHitLocFromSurfName(ent, String(hitSurface), &hitLoc, point, vec3_origin, vec3_origin, MOD_UNKNOWN)
            }
        }

        if hitLoc == -1 {
            hitLoc = G_GetHitLocation(ent, point)
        }
    }

    switch hitLoc {
    case HL_FOOT_RT, HL_LEG_RT:
        hitLocUse = G2_MODELPART_RLEG

    case HL_FOOT_LT, HL_LEG_LT:
        hitLocUse = G2_MODELPART_LLEG

    case HL_WAIST:
        hitLocUse = G2_MODELPART_WAIST
        /*
        case HL_BACK_RT:
        case HL_BACK_LT:
        case HL_BACK:
        case HL_CHEST_RT:
        case HL_CHEST_LT:
        case HL_CHEST:
        break;
        */

    case HL_ARM_RT:
        hitLocUse = G2_MODELPART_RARM

    case HL_HAND_RT:
        hitLocUse = G2_MODELPART_RHAND

    case HL_ARM_LT, HL_HAND_LT:
        hitLocUse = G2_MODELPART_LARM

    case HL_HEAD:
        hitLocUse = G2_MODELPART_HEAD

    default:
        hitLocUse = G_GetHitQuad(ent, point)
    }

    if hitLocUse == -1 {
        return
    }

    if ent.client != nil {
        G_GetDismemberBolt(ent, &boltPoint, hitLocUse)
        if g_austrian.integer != 0 && (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) {
            G_LogPrintf("Duel Dismemberment: %s dismembered at %s\n", ent.client!.pers.netname, hitLocName[hitLoc])
        }
    } else {
        G_GetDismemberLoc(ent, &boltPoint, hitLocUse)
    }
    G_Dismember(ent, enemy, boltPoint, hitLocUse, 90, 0, deathAnim, postDeath)
}

/// Source: oracle/codemp/game/g_combat.c:4346
func G_LocationBasedDamageModifier(_ ent: Entity, _ point: JKAShared.vec3_t?, _ mod: Int32, _ dflags: Int32, _ damage: inout Int32) {
    var hitLoc: Int32 = -1

    if g_locationBasedDamage.integer == 0 {
        //then leave it alone
        return
    }

    if (dflags & DAMAGE_NO_HIT_LOC) != 0 {
        //then leave it alone
        return
    }

    if mod == MOD_SABER && damage <= 1 {
        //don't bother for idle damage
        return
    }

    if point == nil {
        return
    }

    if ent.client != nil && ent.client!.NPC_class == CLASS_VEHICLE {
        //no location-based damage on vehicles
        return
    }

    if (d_saberGhoul2Collision.integer != 0 && ent.client != nil && ent.client!.g2LastSurfaceTime == level.time && mod == MOD_SABER) || (d_projectileGhoul2Collision.integer != 0 && ent.client != nil && ent.client!.g2LastSurfaceTime == level.time) {
        var hitSurface = CharBuf(64)

        strcpy(&hitSurface, trap_G2API_GetSurfaceName(ent.ghoul2, ent.client!.g2LastSurfaceHit, 0))

        if hitSurface[0] != 0 {
            G_GetHitLocFromSurfName(ent, String(hitSurface), &hitLoc, point, vec3_origin, vec3_origin, MOD_UNKNOWN)
        }
    }

    if hitLoc == -1 {
        hitLoc = G_GetHitLocation(ent, point)
    }

    switch hitLoc {
    case HL_FOOT_RT, HL_FOOT_LT:
        damage = Int32(Double(damage) * 0.5)

    case HL_LEG_RT, HL_LEG_LT:
        damage = Int32(Double(damage) * 0.7)

    case HL_WAIST, HL_BACK_RT, HL_BACK_LT, HL_BACK, HL_CHEST_RT, HL_CHEST_LT, HL_CHEST:
        break

    case HL_ARM_RT, HL_ARM_LT:
        damage = Int32(Double(damage) * 0.85)

    case HL_HAND_RT, HL_HAND_LT:
        damage = Int32(Double(damage) * 0.6)

    case HL_HEAD:
        damage = Int32(Double(damage) * 1.3)

    default:
        break
    }
}

/// Source: oracle/codemp/game/g_combat.c:4432
func G_ThereIsAMaster() -> Bool {
    var i: Int32 = 0
    var ent: Entity?

    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent != nil && ent!.client != nil && ent!.client!.ps.isJediMaster {
            return true
        }

        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/g_combat.c:4452
func G_Knockdown(_ victim: Entity) {
    if victim.client != nil && BG_KnockDownable(victim.client!.ps) {
        victim.client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
        victim.client!.ps.forceDodgeAnim = 0
        victim.client!.ps.forceHandExtendTime = level.time + 1100
        victim.client!.ps.quickerGetup = false
    }
}

/// Source: oracle/codemp/game/g_combat.c:4463
func G_ApplyVehicleOtherKiller(_ targ: Entity, _ inflictor: Entity, _ attacker: Entity, _ mod: Int32, _ vehicleDying: Bool) {
    if targ.client != nil {
        if targ.client!.ps.otherKillerDebounceTime > level.time {
            //wait a minute, I already have a last damager
            if targ.health < 0 || (targ.m_pVehicle != nil && targ.m_pVehicle!.m_iRemovedSurfaces != 0) {
                //already dying?  don't let credit transfer to anyone else
                return
            }
            //otherwise, still alive, so, fine, use this damager...
        }

        targ.client!.ps.otherKiller = attacker.s.number
        targ.client!.ps.otherKillerTime = level.time + 25000
        targ.client!.ps.otherKillerDebounceTime = level.time + 25000
        targ.client!.otherKillerMOD = mod
        if Q_stricmp("vehicle_proj", inflictor.classname!) == 0 {
            targ.client!.otherKillerVehWeapon = inflictor.s.otherEntityNum2 + 1
            targ.client!.otherKillerWeaponType = inflictor.s.weapon
        } else {
            targ.client!.otherKillerVehWeapon = 0
            targ.client!.otherKillerWeaponType = WP_NONE
        }
        if vehicleDying {
            //propogate otherkiller down to pilot and passengers so that proper credit is given if they suicide or eject...
            if targ.m_pVehicle != nil {
                var passNum: Int32
                if targ.m_pVehicle!.m_pPilot != nil {
                    let pilot: Entity? = g_entities[targ.m_pVehicle!.m_pPilot!.s.number]
                    if pilot!.client != nil {
                        pilot!.client!.ps.otherKiller = targ.client!.ps.otherKiller
                        pilot!.client!.ps.otherKillerTime = targ.client!.ps.otherKillerTime
                        pilot!.client!.ps.otherKillerDebounceTime = targ.client!.ps.otherKillerDebounceTime
                        pilot!.client!.otherKillerMOD = targ.client!.otherKillerMOD
                        pilot!.client!.otherKillerVehWeapon = targ.client!.otherKillerVehWeapon
                        pilot!.client!.otherKillerWeaponType = targ.client!.otherKillerWeaponType
                    }
                }
                passNum = 0
                while passNum < targ.m_pVehicle!.m_iNumPassengers {
                    let pass: Entity? = g_entities[targ.m_pVehicle!.m_ppPassengers[passNum]!.s.number]
                    if pass!.client != nil {
                        pass!.client!.ps.otherKiller = targ.client!.ps.otherKiller
                        pass!.client!.ps.otherKillerTime = targ.client!.ps.otherKillerTime
                        pass!.client!.ps.otherKillerDebounceTime = targ.client!.ps.otherKillerDebounceTime
                        pass!.client!.otherKillerMOD = targ.client!.otherKillerMOD
                        pass!.client!.otherKillerVehWeapon = targ.client!.otherKillerVehWeapon
                        pass!.client!.otherKillerWeaponType = targ.client!.otherKillerWeaponType
                    }
                    passNum += 1
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/g_combat.c:4528
func G_CheckVehicleNPCTeamDamage(_ ent: Entity) -> Bool {
    //NOTE: this covers both the vehicle and NPCs riding vehicles (droids)
    if ent.s.number < MAX_CLIENTS || ent.s.eType != ET_NPC {
        //not valid or a real client or not an NPC
        return false
    }

    if ent.s.NPC_class != CLASS_VEHICLE {
        //regualar NPC
        if ent.s.m_iVehicleNum != 0 {
            //an NPC in a vehicle, check for team damage
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/game/g_combat.c:4577
func G_Damage(_ targ: Entity, _ inflictor: Entity?, _ attacker: Entity?, _ dir: inout JKAShared.vec3_t?, _ point: JKAShared.vec3_t?, _ damage: Int32, _ dflags: Int32, _ mod: Int32) {
    var client: Client?
    var take: Int32
    let save: Int32
    let asave: Int32
    var knockback: Int32
    let max: Int32
    var subamt: Int32 = 0
    var famt: Float = 0
    var hamt: Float = 0
    var shieldAbsorbed: Float = 0
    // Raven assigns his own `inflictor` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var inflictor = inflictor
    // Raven assigns his own `attacker` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var attacker = attacker
    // Raven assigns his own `damage` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var damage = damage
    // Raven assigns his own `dflags` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var dflags = dflags

    if targ.damageRedirect != 0 {
        G_Damage(g_entities[targ.damageRedirectTo], inflictor, attacker, &dir, point, damage, dflags, mod)
        return
    }

    if mod == MOD_DEMP2 && targ.inuse && targ.client != nil {
        if targ.client!.ps.electrifyTime < level.time {
            //electrocution effect
            if targ.s.eType == ET_NPC && targ.s.NPC_class == CLASS_VEHICLE && targ.m_pVehicle != nil && (targ.m_pVehicle!.m_pVehicleInfo!.type == VH_SPEEDER || targ.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER) {
                //do some extra stuff to speeders/walkers
                targ.client!.ps.electrifyTime = level.time + Q_irand(3000, 4000)
            } else if targ.s.NPC_class != CLASS_VEHICLE || (targ.m_pVehicle != nil && targ.m_pVehicle!.m_pVehicleInfo!.type != VH_FIGHTER) {
                //don't do this to fighters
                targ.client!.ps.electrifyTime = level.time + Q_irand(300, 800)
            }
        }
    }

    if g_gametype.integer == GT_SIEGE && !gSiegeRoundBegun {
        //nothing can be damaged til the round starts.
        return
    }

    if !targ.takedamage {
        return
    }

    if (targ.flags & FL_SHIELDED) != 0 && mod != MOD_SABER && targ.client == nil {
        //magnetically protected, this thing can only be damaged by lightsabers
        return
    }

    if (targ.flags & FL_DMG_BY_SABER_ONLY) != 0 && mod != MOD_SABER {
        //saber-only damage
        return
    }

    if targ.client != nil {
        //don't take damage when in a walker, or fighter
        //unless the walker/fighter is dead!!! -rww
        if targ.client!.ps.clientNum < MAX_CLIENTS && targ.client!.ps.m_iVehicleNum != 0 {
            let veh: Entity? = g_entities[targ.client!.ps.m_iVehicleNum]
            if veh!.m_pVehicle != nil && veh!.health > 0 {
                if veh!.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER || veh!.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
                    if !((dflags & DAMAGE_NO_PROTECTION) != 0) {
                        return
                    }
                }
            }
        }
    }

    if (targ.flags & FL_DMG_BY_HEAVY_WEAP_ONLY) != 0 {
        //only take damage from explosives and such
        if mod != MOD_REPEATER_ALT && mod != MOD_ROCKET && mod != MOD_FLECHETTE_ALT_SPLASH && mod != MOD_ROCKET_HOMING && mod != MOD_THERMAL && mod != MOD_THERMAL_SPLASH && mod != MOD_TRIP_MINE_SPLASH && mod != MOD_TIMED_MINE_SPLASH && mod != MOD_DET_PACK_SPLASH && mod != MOD_VEHICLE && mod != MOD_CONC && mod != MOD_CONC_ALT && mod != MOD_SABER && mod != MOD_TURBLAST && mod != MOD_TARGET_LASER && mod != MOD_SUICIDE && mod != MOD_FALLING && mod != MOD_CRUSH && mod != MOD_TELEFRAG && mod != MOD_COLLISION && mod != MOD_VEH_EXPLOSION && mod != MOD_TRIGGER_HURT {
            if mod != MOD_MELEE || !G_HeavyMelee(attacker!) {
                //let classes with heavy melee ability damage heavy wpn dmg doors with fists
                return
            }
        }
    }

    if (targ.flags & FL_BBRUSH) != 0 {
        if mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT || mod == MOD_BRYAR_PISTOL || mod == MOD_BRYAR_PISTOL_ALT || mod == MOD_MELEE {
            //these don't damage bbrushes.. ever
            if mod != MOD_MELEE || !G_HeavyMelee(attacker!) {
                //let classes with heavy melee ability damage breakable brushes with fists
                return
            }
        }
    }

    if targ.client != nil && targ.client!.ps.duelInProgress {
        if attacker != nil && attacker!.client != nil && attacker!.s.number != targ.client!.ps.duelIndex {
            return
        } else if attacker != nil && attacker!.client != nil && mod != MOD_SABER {
            return
        }
    }
    if attacker != nil && attacker!.client != nil && attacker!.client!.ps.duelInProgress {
        if targ.client != nil && targ.s.number != attacker!.client!.ps.duelIndex {
            return
        } else if targ.client != nil && mod != MOD_SABER {
            return
        }
    }

    if !((dflags & DAMAGE_NO_PROTECTION) != 0) {
        //rage overridden by no_protection
        if targ.client != nil && (targ.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
            damage = Int32(Double(damage) * 0.5)
        }
    }

    // the intermission has allready been qualified for, so don't
    // allow any extra scoring
    if level.intermissionQueued != 0 {
        return
    }
    if inflictor == nil {
        inflictor = g_entities[ENTITYNUM_WORLD]
    }
    if attacker == nil {
        attacker = g_entities[ENTITYNUM_WORLD]
    }

    // shootable doors / buttons don't actually have any health

    //if genericValue4 == 1 then it's glass or a breakable and those do have health
    if targ.s.eType == ET_MOVER && targ.genericValue4 != 1 {
        if targ.use != nil && targ.moverState == MOVER_POS1 {
            GlobalUse(targ, inflictor!, attacker!)
        }
        return
    }
    // reduce damage by the attacker's handicap value
    // unless they are rocket jumping
    if attacker!.client != nil && attacker != targ && attacker!.s.eType == ET_PLAYER && g_gametype.integer != GT_SIEGE {
        max = attacker!.client!.ps.stats[STAT_MAX_HEALTH]
        damage = damage * max / 100
    }

    if !((dflags & DAMAGE_NO_HIT_LOC) != 0) {
        //see if we should modify it by damage location
        if targ.inuse && (targ.client != nil || targ.s.eType == ET_NPC) && attacker!.inuse && (attacker!.client != nil || attacker!.s.eType == ET_NPC) {
            //check for location based damage stuff.
            G_LocationBasedDamageModifier(targ, point, mod, dflags, &damage)
        }
    }

    if targ.client != nil && targ.client!.NPC_class == CLASS_RANCOR && (attacker == nil || attacker!.client == nil || attacker!.client!.NPC_class != CLASS_RANCOR) {
        // I guess always do 10 points of damage...feel free to tweak as needed
        if damage < 10 {
            //ignore piddly little damage
            damage = 0
        } else if damage >= 10 {
            damage = 10
        }
    }

    client = targ.client

    if client != nil {
        if client!.noclip {
            return
        }
    }

    if dir == nil {
        dflags |= DAMAGE_NO_KNOCKBACK
    } else {
        VectorNormalize(&dir!)
    }

    knockback = damage
    if knockback > 200 {
        knockback = 200
    }
    if (targ.flags & FL_NO_KNOCKBACK) != 0 {
        knockback = 0
    }
    if (dflags & DAMAGE_NO_KNOCKBACK) != 0 {
        knockback = 0
    }

    // figure momentum add, even if the damage won't be taken
    if knockback != 0 && targ.client != nil {
        var kvel = vec3_t()
        let mass: Float

        mass = 200

        if mod == MOD_SABER {
            var saberKnockbackScale: Float = g_saberDmgVelocityScale.value
            if (dflags & DAMAGE_SABER_KNOCKBACK1) != 0 || (dflags & DAMAGE_SABER_KNOCKBACK2) != 0 {
                //saber does knockback, scale it by the right number
                if saberKnockbackScale == 0 {
                    saberKnockbackScale = 1.0
                }
                if attacker != nil && attacker!.client != nil {
                    if (dflags & DAMAGE_SABER_KNOCKBACK1) != 0 {
                        if attacker != nil && attacker!.client != nil {
                            saberKnockbackScale *= attacker!.client!.saber[0].knockbackScale
                        }
                    }
                    if (dflags & DAMAGE_SABER_KNOCKBACK1_B2) != 0 {
                        if attacker != nil && attacker!.client != nil {
                            saberKnockbackScale *= attacker!.client!.saber[0].knockbackScale2
                        }
                    }
                    if (dflags & DAMAGE_SABER_KNOCKBACK2) != 0 {
                        if attacker != nil && attacker!.client != nil {
                            saberKnockbackScale *= attacker!.client!.saber[1].knockbackScale
                        }
                    }
                    if (dflags & DAMAGE_SABER_KNOCKBACK2_B2) != 0 {
                        if attacker != nil && attacker!.client != nil {
                            saberKnockbackScale *= attacker!.client!.saber[1].knockbackScale2
                        }
                    }
                }
            }
            kvel = dir! * ((g_knockback.value * Float(knockback) / mass) * saberKnockbackScale)
        } else {
            kvel = dir! * (g_knockback.value * Float(knockback) / mass)
        }
        targ.client!.ps.velocity = targ.client!.ps.velocity + kvel

        // set the timer so that the other client can't cancel
        // out the movement immediately
        if targ.client!.ps.pm_time == 0 && (g_saberDmgVelocityScale.integer != 0 || mod != MOD_SABER || (dflags & DAMAGE_SABER_KNOCKBACK1) != 0 || (dflags & DAMAGE_SABER_KNOCKBACK2) != 0 || (dflags & DAMAGE_SABER_KNOCKBACK1_B2) != 0 || (dflags & DAMAGE_SABER_KNOCKBACK2_B2) != 0) {
            var t: Int32

            t = knockback * 2
            if t < 50 {
                t = 50
            }
            if t > 200 {
                t = 200
            }
            targ.client!.ps.pm_time = t
            targ.client!.ps.pm_flags |= PMF_TIME_KNOCKBACK
        }
    }

    if (g_trueJedi.integer != 0 || g_gametype.integer == GT_SIEGE) && client != nil {
        //less explosive damage for jedi, more saber damage for non-jedi
        if client!.ps.trueJedi || (g_gametype.integer == GT_SIEGE && client!.ps.weapon == WP_SABER) {
            //if the target is a trueJedi, reduce splash and explosive damage to 1/2
            switch mod {
            case MOD_REPEATER_ALT, MOD_REPEATER_ALT_SPLASH, MOD_DEMP2_ALT, MOD_FLECHETTE_ALT_SPLASH, MOD_ROCKET, MOD_ROCKET_SPLASH, MOD_ROCKET_HOMING, MOD_ROCKET_HOMING_SPLASH, MOD_THERMAL, MOD_THERMAL_SPLASH, MOD_TRIP_MINE_SPLASH, MOD_TIMED_MINE_SPLASH, MOD_DET_PACK_SPLASH:
                damage = Int32(Double(damage) * 0.75)

            default:
                break
            }
        } else if (client!.ps.trueNonJedi || (g_gametype.integer == GT_SIEGE && client!.ps.weapon != WP_SABER)) && mod == MOD_SABER {
            //if the target is a trueNonJedi, take more saber damage... combined with the 1.5 in the w_saber stuff, this is 6 times damage!
            if damage < 100 {
                damage *= 4
                if damage > 100 {
                    damage = 100
                }
            }
        }
    }

    if attacker!.client != nil && targ.client != nil && g_gametype.integer == GT_SIEGE && targ.client!.siegeClass != -1 && (bgSiegeClasses[targ.client!.siegeClass].classflags & (1 << CFL_STRONGAGAINSTPHYSICAL)) != 0 {
        //this class is flagged to take less damage from physical attacks.
        //For now I'm just decreasing against any client-based attack, this can be changed later I guess.
        damage = Int32(Double(damage) * 0.5)
    }

    // check for completely getting out of the damage
    if !((dflags & DAMAGE_NO_PROTECTION) != 0) {
        // if TF_NO_FRIENDLY_FIRE is set, don't do damage to the target
        // if the attacker was on the same team
        if targ != attacker {
            if OnSameTeam(targ, attacker!) {
                if g_friendlyFire.integer == 0 {
                    return
                }
            } else if attacker != nil && attacker!.inuse && attacker!.client == nil && attacker!.activator != nil && targ != attacker!.activator && attacker!.activator!.inuse && attacker!.activator!.client != nil {
                //emplaced guns don't hurt teammates of user
                if OnSameTeam(targ, attacker!.activator!) {
                    if g_friendlyFire.integer == 0 {
                        return
                    }
                }
            } else if targ.inuse && targ.client != nil && g_gametype.integer >= GT_TEAM && attacker!.s.number >= MAX_CLIENTS && attacker!.alliedTeam != 0 && targ.client!.sess.sessionTeam == attacker!.alliedTeam && g_friendlyFire.integer == 0 {
                //things allied with my team should't hurt me.. I guess
                return
            }
        }

        if g_gametype.integer == GT_JEDIMASTER && g_friendlyFire.integer == 0 && targ.client != nil && attacker != nil && attacker!.client != nil && targ != attacker && !targ.client!.ps.isJediMaster && !attacker!.client!.ps.isJediMaster && G_ThereIsAMaster() {
            return
        }

        if targ.s.number >= MAX_CLIENTS && targ.client != nil && targ.s.shouldtarget && targ.s.teamowner != 0 && attacker != nil && attacker!.inuse && attacker!.client != nil && targ.s.owner >= 0 && targ.s.owner < MAX_CLIENTS {
            let targown: Entity? = g_entities[targ.s.owner]

            if targown != nil && targown!.inuse && targown!.client != nil && OnSameTeam(targown!, attacker!) {
                if g_friendlyFire.integer == 0 {
                    return
                }
            }
        }

        // check for godmode
        if (targ.flags & FL_GODMODE) != 0 && targ.s.eType != ET_NPC {
            return
        }

        if targ.client != nil && (targ.client!.ps.eFlags & EF_INVULNERABLE) != 0 && attacker != nil && attacker!.client != nil && targ != attacker {
            if targ.client!.invulnerableTimer <= level.time {
                targ.client!.ps.eFlags &= ~EF_INVULNERABLE
            } else {
                return
            }
        }
    }

    //check for teamnodmg
    //NOTE: non-client objects hitting clients (and clients hitting clients) purposely doesn't obey this teamnodmg (for emplaced guns)
    if attacker != nil && targ.client == nil {
        //attacker hit a non-client
        if g_gametype.integer == GT_SIEGE && g_ff_objectives.integer == 0 {
            //in siege mode (and...?)
            if targ.teamnodmg != 0 {
                //targ shouldn't take damage from a certain team
                if attacker!.client != nil {
                    //a client hit a non-client object
                    if targ.teamnodmg == attacker!.client!.sess.sessionTeam {
                        return
                    }
                } else if attacker!.teamnodmg != 0 {
                    //a non-client hit a non-client object
                    //FIXME: maybe check alliedTeam instead?
                    if targ.teamnodmg == attacker!.teamnodmg {
                        if attacker!.activator != nil && attacker!.activator!.inuse && attacker!.activator!.s.number < MAX_CLIENTS && attacker!.activator!.client != nil && attacker!.activator!.client!.sess.sessionTeam != targ.teamnodmg {
                            //uh, let them damage it I guess.
                        } else {
                            return
                        }
                    }
                }
            }
        }
    }

    // battlesuit protects from all radius damage (but takes knockback)
    // and protects 50% against all damage
    if client != nil && client!.ps.powerups[PW_BATTLESUIT] != 0 {
        G_AddEvent(targ, EV_POWERUP_BATTLESUIT, 0)
        if (dflags & DAMAGE_RADIUS) != 0 || (mod == MOD_FALLING) {
            return
        }
        damage = Int32(Double(damage) * 0.5)
    }

    // add to the attacker's hit counter (if the target isn't a general entity like a prox mine)
    if attacker!.client != nil && targ != attacker && targ.health > 0 && targ.s.eType != ET_MISSILE && targ.s.eType != ET_GENERAL && client != nil {
        if OnSameTeam(targ, attacker!) {
            attacker!.client!.ps.persistant[PERS_HITS] -= 1
        } else {
            attacker!.client!.ps.persistant[PERS_HITS] += 1
        }
        attacker!.client!.ps.persistant[PERS_ATTACKEE_ARMOR] = (targ.health << 8) | (client!.ps.stats[STAT_ARMOR])
    }

    // always give half damage if hurting self... but not in siege.  Heavy weapons need a counter.
    // calculated after knockback, so rocket jumping works
    if targ == attacker && !((dflags & DAMAGE_NO_SELF_PROTECTION) != 0) {
        if g_gametype.integer == GT_SIEGE {
            damage = Int32(Double(damage) * 1.5)
        } else {
            damage = Int32(Double(damage) * 0.5)
        }
    }

    if damage < 1 {
        damage = 1
    }

    //store the attacker as the potential killer in case we die by other means
    if targ.client != nil && attacker != nil && attacker != targ {
        if targ.s.eType == ET_NPC && targ.s.NPC_class == CLASS_VEHICLE {
            //vehicle
            G_ApplyVehicleOtherKiller(targ, inflictor!, attacker!, mod, false)
        } else {
            //other client
            targ.client!.ps.otherKiller = attacker!.s.number
            targ.client!.ps.otherKillerTime = level.time + 5000
            targ.client!.ps.otherKillerDebounceTime = level.time + 100
            targ.client!.otherKillerMOD = mod
            targ.client!.otherKillerVehWeapon = 0
            targ.client!.otherKillerWeaponType = WP_NONE
        }
    }

    take = damage
    save = 0

    // save some from armor
    asave = CheckArmor(targ, take, dflags)

    if asave != 0 {
        shieldAbsorbed = Float(asave)
    }

    take -= asave
    if targ.client != nil {
        //update vehicle shields and armor, check for explode
        if targ.client!.NPC_class == CLASS_VEHICLE && targ.m_pVehicle != nil {
            //FIXME: should be in its own function in g_vehicles.c now, too big to be here
            var surface: Int32 = -1
            if attacker != nil {
                //so we know the last guy who shot at us
                targ.enemy = attacker
            }

            if (targ.m_pVehicle!.m_pVehicleInfo!.type == VH_ANIMAL) {
                //((CVehicleNPC *)targ->NPC)->m_ulFlags |= CVehicleNPC::VEH_BUCKING;
            }

            targ.m_pVehicle!.m_iShields = targ.client!.ps.stats[STAT_ARMOR]
            G_VehUpdateShields(targ)
            targ.m_pVehicle!.m_iArmor -= take
            if targ.m_pVehicle!.m_iArmor <= 0 {
                targ.s.eFlags |= EF_DEAD
                targ.client!.ps.eFlags |= EF_DEAD
                targ.m_pVehicle!.m_iArmor = 0
            }
            if targ.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
                //get the last surf that was hit
                if targ.client != nil && targ.client!.g2LastSurfaceTime == level.time {
                    var hitSurface = CharBuf(64)

                    strcpy(&hitSurface, trap_G2API_GetSurfaceName(targ.ghoul2, targ.client!.g2LastSurfaceHit, 0))

                    if hitSurface[0] != 0 {
                        surface = G_ShipSurfaceForSurfName(String(hitSurface))

                        if take != 0 && surface > 0 {
                            //hit a certain part of the ship
                            var deathPoint: Int32 = 0

                            targ.locationDamage[surface] += take

                            switch surface {
                            case SHIPSURF_FRONT:
                                deathPoint = targ.m_pVehicle!.m_pVehicleInfo!.health_front

                            case SHIPSURF_BACK:
                                deathPoint = targ.m_pVehicle!.m_pVehicleInfo!.health_back

                            case SHIPSURF_RIGHT:
                                deathPoint = targ.m_pVehicle!.m_pVehicleInfo!.health_right

                            case SHIPSURF_LEFT:
                                deathPoint = targ.m_pVehicle!.m_pVehicleInfo!.health_left

                            default:
                                break
                            }

                            //presume 0 means it wasn't set and so it should never die.
                            if deathPoint != 0 {
                                if targ.locationDamage[surface] >= deathPoint {
                                    //this area of the ship is now dead
                                    let wasDying: Bool = (targ.m_pVehicle!.m_iRemovedSurfaces != 0)
                                    if G_FlyVehicleDestroySurface(targ, surface) {
                                        //actually took off a surface
                                        G_VehicleSetDamageLocFlags(targ, surface, deathPoint)
                                        if !wasDying {
                                            //always take credit for kill if they were healthy before
                                            targ.client!.ps.otherKillerDebounceTime = 0
                                        }
                                        G_ApplyVehicleOtherKiller(targ, inflictor!, attacker!, mod, true)
                                    }
                                } else {
                                    G_VehicleSetDamageLocFlags(targ, surface, deathPoint)
                                }
                            }
                        }
                    }
                }
            }
            if targ.m_pVehicle!.m_pVehicleInfo!.type != VH_ANIMAL {
                /*
                if ( targ->m_pVehicle->m_iArmor <= 0 )
                {//vehicle all out of armor
                Vehicle_t *pVeh = targ->m_pVehicle;
                if ( pVeh->m_iDieTime == 0 )
                {//just start the flaming effect and explosion delay, if it's not going already...
                pVeh->m_pVehicleInfo->StartDeathDelay( pVeh, 0 );
                }
                }
                else*/
                if attacker != nil && targ != attacker && point != nil && VectorCompare(targ.client!.ps.origin, point!) == 0 && targ.m_pVehicle!.m_LandTrace.fraction >= 1.0 {
                    //just took a hit, knock us around
                    var vUp = vec3_t()
                    var impactDir = vec3_t()
                    var impactStrength: Float = (damage / 200.0) * 10.0
                    var dot: Float = 0.0
                    if impactStrength > 10.0 {
                        impactStrength = 10.0
                    }
                    //pitch or roll us based on where we were hit
                    // Raven passes NULL for the `forward` and `right` outputs.
                    var scratchForward = vec3_t()
                    var scratchRight = vec3_t()
                    AngleVectors(targ.m_pVehicle!.m_vOrientationVector, &scratchForward, &scratchRight, &vUp)
                    impactDir = point! - targ.r.currentOrigin
                    VectorNormalize(&impactDir)
                    if surface <= 0 {
                        //no surf guess where we were hit, then
                        var vFwd = vec3_t()
                        var vRight = vec3_t()
                        AngleVectors(targ.m_pVehicle!.m_vOrientationVector, &vFwd, &vRight, &vUp)
                        dot = _DotProduct(vRight, impactDir)
                        if dot > 0.4 {
                            surface = SHIPSURF_RIGHT
                        } else if dot < -0.4 {
                            surface = SHIPSURF_LEFT
                        } else {
                            dot = _DotProduct(vFwd, impactDir)
                            if dot > 0.0 {
                                surface = SHIPSURF_FRONT
                            } else {
                                surface = SHIPSURF_BACK
                            }
                        }
                    }
                    switch surface {
                    case SHIPSURF_FRONT:
                        dot = _DotProduct(vUp, impactDir)
                        if dot > 0 {
                            targ.m_pVehicle!.m_vOrientationVector[PITCH] += impactStrength
                        } else {
                            targ.m_pVehicle!.m_vOrientationVector[PITCH] -= impactStrength
                        }

                    case SHIPSURF_BACK:
                        dot = _DotProduct(vUp, impactDir)
                        if dot > 0 {
                            targ.m_pVehicle!.m_vOrientationVector[PITCH] -= impactStrength
                        } else {
                            targ.m_pVehicle!.m_vOrientationVector[PITCH] += impactStrength
                        }

                    case SHIPSURF_RIGHT:
                        dot = _DotProduct(vUp, impactDir)
                        if dot > 0 {
                            targ.m_pVehicle!.m_vOrientationVector[ROLL] -= impactStrength
                        } else {
                            targ.m_pVehicle!.m_vOrientationVector[ROLL] += impactStrength
                        }

                    case SHIPSURF_LEFT:
                        dot = _DotProduct(vUp, impactDir)
                        if dot > 0 {
                            targ.m_pVehicle!.m_vOrientationVector[ROLL] += impactStrength
                        } else {
                            targ.m_pVehicle!.m_vOrientationVector[ROLL] -= impactStrength
                        }

                    default:
                        break
                    }
                }
            }
        }
    }

    if mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT {
        //FIXME: screw with non-animal vehicles, too?
        if client != nil {
            if client!.NPC_class == CLASS_VEHICLE && targ.m_pVehicle != nil && targ.m_pVehicle!.m_pVehicleInfo != nil && targ.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
                //all damage goes into the disruption of shields and systems
                take = 0
            } else {
                if client!.jetPackOn {
                    //disable jetpack temporarily
                    Jetpack_Off(targ)
                    client!.jetPackToggleTime = level.time + Q_irand(3000, 10000)
                }

                if client!.NPC_class == CLASS_PROTOCOL || client!.NPC_class == CLASS_SEEKER || client!.NPC_class == CLASS_R2D2 || client!.NPC_class == CLASS_R5D2 || client!.NPC_class == CLASS_MOUSE || client!.NPC_class == CLASS_GONK {
                    // DEMP2 does more damage to these guys.
                    take *= 2
                } else if client!.NPC_class == CLASS_PROBE || client!.NPC_class == CLASS_INTERROGATOR || client!.NPC_class == CLASS_MARK1 || client!.NPC_class == CLASS_MARK2 || client!.NPC_class == CLASS_SENTRY || client!.NPC_class == CLASS_ATST {
                    // DEMP2 does way more damage to these guys.
                    take *= 5
                } else {
                    if take > 0 {
                        take /= 3
                        if take < 1 {
                            take = 1
                        }
                    }
                }
            }
        }
    }

    if g_debugDamage.integer != 0 {
        G_Printf("%i: client:%i health:%i damage:%i armor:%i\n", level.time, targ.s.number, targ.health, take, asave)
    }

    // add to the damage inflicted on a player this frame
    // the total will be turned into screen blends and view angle kicks
    // at the end of the frame
    if client != nil {
        if attacker != nil {
            client!.ps.persistant[PERS_ATTACKER] = attacker!.s.number
        } else {
            client!.ps.persistant[PERS_ATTACKER] = ENTITYNUM_WORLD
        }
        client!.damage_armor += asave
        client!.damage_blood += take
        client!.damage_knockback += knockback
        if dir != nil {
            client!.damage_from = dir!
            client!.damage_fromWorld = false
        } else {
            client!.damage_from = targ.r.currentOrigin
            client!.damage_fromWorld = true
        }

        if attacker != nil && attacker!.client != nil {
            BotDamageNotification(client!, attacker!)
        } else if inflictor != nil && inflictor!.client != nil {
            BotDamageNotification(client!, inflictor!)
        }
    }

    // See if it's the player hurting the emeny flag carrier
    if g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY {
        Team_CheckHurtCarrier(targ, attacker!)
    }

    if targ.client != nil {
        // set the last client who damaged the target
        targ.client!.lasthurt_client = attacker!.s.number
        targ.client!.lasthurt_mod = mod
    }

    if !((dflags & DAMAGE_NO_PROTECTION) != 0) {
        //protect overridden by no_protection
        if take != 0 && targ.client != nil && (targ.client!.ps.fd.forcePowersActive & (1 << FP_PROTECT)) != 0 {
            if targ.client!.ps.fd.forcePower != 0 {
                var maxtake: Int32 = take

                //G_Sound(targ, CHAN_AUTO, protectHitSound);
                if targ.client!.forcePowerSoundDebounce < level.time {
                    G_PreDefSound(targ.client!.ps.origin, PDSOUND_PROTECTHIT)
                    targ.client!.forcePowerSoundDebounce = level.time + 400
                }

                if targ.client!.ps.fd.forcePowerLevel[FP_PROTECT] == FORCE_LEVEL_1 {
                    famt = 1
                    hamt = 0.40

                    if maxtake > 100 {
                        maxtake = 100
                    }
                } else if targ.client!.ps.fd.forcePowerLevel[FP_PROTECT] == FORCE_LEVEL_2 {
                    famt = 0.5
                    hamt = 0.60

                    if maxtake > 200 {
                        maxtake = 200
                    }
                } else if targ.client!.ps.fd.forcePowerLevel[FP_PROTECT] == FORCE_LEVEL_3 {
                    famt = 0.25
                    hamt = 0.80

                    if maxtake > 400 {
                        maxtake = 400
                    }
                }

                if targ.client!.ps.powerups[PW_FORCE_BOON] == 0 {
                    targ.client!.ps.fd.forcePower = Int32(Float(targ.client!.ps.fd.forcePower) - maxtake * famt)
                } else {
                    targ.client!.ps.fd.forcePower = Int32(Float(targ.client!.ps.fd.forcePower) - (maxtake * famt) / 2)
                }
                subamt = Int32((maxtake * hamt) + (take - maxtake))
                if targ.client!.ps.fd.forcePower < 0 {
                    subamt += targ.client!.ps.fd.forcePower
                    targ.client!.ps.fd.forcePower = 0
                }
                if subamt != 0 {
                    take -= subamt

                    if take < 0 {
                        take = 0
                    }
                }
            }
        }
    }

    if shieldAbsorbed != 0 {
        /*
        if ( targ->client->NPC_class == CLASS_VEHICLE )
        {
        targ->client->ps.electrifyTime = level.time + Q_irand( 500, 1000 );
        }
        else
        */
        do {
            var evEnt: Entity?

            // Send off an event to show a shield shell on the player, pointing in the right direction.
            //evEnt = G_TempEntity(vec3_origin, EV_SHIELD_HIT);
            //rww - er.. what the? This isn't broadcast, why is it being set on vec3_origin?!
            evEnt = G_TempEntity(targ.r.currentOrigin, EV_SHIELD_HIT)
            evEnt!.s.otherEntityNum = targ.s.number
            evEnt!.s.eventParm = DirToByte(dir)
            evEnt!.s.time2 = Int32(shieldAbsorbed)
            /*
            shieldAbsorbed *= 20;

            if (shieldAbsorbed > 1500)
            {
            shieldAbsorbed = 1500;
            }
            if (shieldAbsorbed < 200)
            {
            shieldAbsorbed = 200;
            }

            if (targ->client->ps.powerups[PW_SHIELDHIT] < (level.time + shieldAbsorbed))
            {
            targ->client->ps.powerups[PW_SHIELDHIT] = level.time + shieldAbsorbed;
            }
            //flicker for as many ms as damage was absorbed (*20)
            //therefore 10 damage causes 1/5 of a seond of flickering, whereas
            //a full 100 causes 2 seconds (but is reduced to 1.5 seconds due to the max)

            */
        }
    }

    // do the damage
    if take != 0 {
        if targ.client != nil && targ.s.number < MAX_CLIENTS && (mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT) {
            //uh.. shock them or something. what the hell, I don't know.
            if targ.client!.ps.weaponTime <= 0 {
                //yeah, we were supposed to be beta a week ago, I don't feel like
                //breaking the game so I'm gonna be safe and only do this only
                //if your weapon is not busy
                targ.client!.ps.weaponTime = 2000
                targ.client!.ps.electrifyTime = level.time + 2000
                if targ.client!.ps.weaponstate == WEAPON_CHARGING || targ.client!.ps.weaponstate == WEAPON_CHARGING_ALT {
                    targ.client!.ps.weaponstate = WEAPON_READY
                }
            }
        }

        if !((dflags & DAMAGE_NO_PROTECTION) != 0) {
            //rage overridden by no_protection
            if targ.client != nil && (targ.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 && (inflictor!.client != nil || attacker!.client != nil) {
                take /= (targ.client!.ps.fd.forcePowerLevel[FP_RAGE] + 1)
            }
        }
        targ.health = targ.health - take

        if (targ.flags & FL_UNDYING) != 0 {
            //take damage down to 1, but never die
            if targ.health < 1 {
                targ.health = 1
            }
        }

        if targ.client != nil {
            targ.client!.ps.stats[STAT_HEALTH] = targ.health
        }

        if !((dflags & DAMAGE_NO_PROTECTION) != 0) {
            //rage overridden by no_protection
            if targ.client != nil && (targ.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 && (inflictor!.client != nil || attacker!.client != nil) {
                if targ.health <= 0 {
                    targ.health = 1
                }
                if targ.client!.ps.stats[STAT_HEALTH] <= 0 {
                    targ.client!.ps.stats[STAT_HEALTH] = 1
                }
            }
        }

        //We want to go ahead and set gPainHitLoc regardless of if we have a pain func,
        //so we can adjust the location damage too.
        if targ.client != nil && targ.ghoul2 != nil && targ.client!.g2LastSurfaceTime == level.time {
            //We updated the hit surface this frame, so it's valid.
            var hitSurface = CharBuf(64)

            strcpy(&hitSurface, trap_G2API_GetSurfaceName(targ.ghoul2, targ.client!.g2LastSurfaceHit, 0))

            if hitSurface[0] != 0 {
                G_GetHitLocFromSurfName(targ, String(hitSurface), &gPainHitLoc, point, dir, vec3_origin, mod)
            } else {
                gPainHitLoc = -1
            }

            if gPainHitLoc < HL_MAX && gPainHitLoc >= 0 && targ.locationDamage[gPainHitLoc] < Q3_INFINITE && (targ.s.eType == ET_PLAYER || targ.s.NPC_class != CLASS_VEHICLE) {
                targ.locationDamage[gPainHitLoc] += take

                if g_armBreakage.integer != 0 && targ.client!.ps.brokenLimbs == 0 && targ.client!.ps.stats[STAT_HEALTH] > 0 && targ.health > 0 && !((targ.s.eFlags & EF_DEAD) != 0) {
                    //check for breakage
                    if targ.locationDamage[HL_ARM_RT] + targ.locationDamage[HL_HAND_RT] >= 80 {
                        G_BreakArm(targ, BROKENLIMB_RARM)
                    } else if targ.locationDamage[HL_ARM_LT] + targ.locationDamage[HL_HAND_LT] >= 80 {
                        G_BreakArm(targ, BROKENLIMB_LARM)
                    }
                }
            }
        } else {
            gPainHitLoc = -1
        }

        if targ.maxHealth != 0 {
            //if this is non-zero this guy should be updated his s.health to send to the client
            G_ScaleNetHealth(targ)
        }

        if targ.health <= 0 {
            if client != nil {
                targ.flags |= FL_NO_KNOCKBACK

                if point != nil {
                    targ.pos1 = point!
                } else {
                    targ.pos1 = targ.client!.ps.origin
                }
            } else if targ.s.eType == ET_NPC {
                //g2animent
                targ.pos1 = point!
            }

            if targ.health < -999 {
                targ.health = -999
            }

            // If we are a breaking glass brush, store the damage point so we can do cool things with it.
            if (targ.r.svFlags & SVF_GLASS_BRUSH) != 0 {
                targ.pos1 = point!
                if dir != nil {
                    targ.pos2 = dir!
                } else {
                    targ.pos2 = vec3_t()
                }
            }

            if targ.s.eType == ET_NPC && targ.client != nil && (targ.s.eFlags & EF_DEAD) != 0 {
                //an NPC that's already dead. Maybe we can cut some more limbs off!
                //saber or heavy melee (claws)
                if (mod == MOD_SABER || (mod == MOD_MELEE && G_HeavyMelee(attacker!))) && take > 2 && (dflags & DAMAGE_NO_DISMEMBER) == 0 {
                    G_CheckForDismemberment(targ, attacker!, targ.pos1, take, targ.client!.ps.torsoAnim, true)
                }
            }

            targ.enemy = attacker
            targ.runDie(inflictor, attacker, take, mod)
            G_ActivateBehavior(targ, BSET_DEATH)
            return
        } else {
            if g_debugMelee.integer != 0 {
                //getting hurt makes you let go of the wall
                if targ.client != nil && (targ.client!.ps.pm_flags & PMF_STUCK_TO_WALL) != 0 {
                    G_LetGoOfWall(targ)
                }
            }
            if targ.pain != nil {
                if targ.s.eType != ET_NPC || mod != MOD_SABER || take > 1 {
                    //don't even notify NPCs of pain if it's just idle saber damage
                    gPainMOD = mod
                    if point != nil {
                        gPainPoint = point!
                    } else {
                        gPainPoint = targ.r.currentOrigin
                    }
                    targ.runPain(attacker, take)
                }
            }
        }

        G_LogWeaponDamage(attacker!.s.number, mod, take)
    }
}

/// A caller that passes a vector for `dir` reaches `G_Damage` through this forward, and a NULL caller passes the optional.
/// Source: oracle/codemp/game/g_combat.c:4577
func G_Damage(_ targ: Entity, _ inflictor: Entity?, _ attacker: Entity?, _ dir: inout JKAShared.vec3_t, _ point: JKAShared.vec3_t?, _ damage: Int32, _ dflags: Int32, _ mod: Int32) {
    var optionalDir: JKAShared.vec3_t? = dir
    defer { dir = optionalDir! }
    G_Damage(targ, inflictor, attacker, &optionalDir, point, damage, dflags, mod)
}

/// Source: oracle/codemp/game/g_combat.c:5717
func G_DamageFromKiller(_ pEnt: Entity, _ pVehEnt: Entity, _ attacker: Entity?, _ org: JKAShared.vec3_t, _ damage: Int32, _ dflags: Int32, _ mod: Int32) {
    var killer: Entity? = attacker
    var inflictor: Entity? = attacker
    var tempInflictor: Bool = false
    // Raven assigns his own `mod` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var mod = mod
    if pVehEnt.client == nil {
        return
    }
    if pVehEnt.client!.ps.otherKiller < ENTITYNUM_WORLD && pVehEnt.client!.ps.otherKillerTime > level.time {
        let potentialKiller: Entity? = g_entities[pVehEnt.client!.ps.otherKiller]

        if potentialKiller!.inuse {
            //he's valid I guess
            killer = potentialKiller
            mod = pVehEnt.client!.otherKillerMOD
            inflictor = killer
            if pVehEnt.client!.otherKillerVehWeapon > 0 {
                inflictor = G_Spawn()
                if inflictor != nil {
                    //fake up the inflictor
                    tempInflictor = true
                    inflictor!.classname = "vehicle_proj"
                    inflictor!.s.otherEntityNum2 = pVehEnt.client!.otherKillerVehWeapon - 1
                    inflictor!.s.weapon = pVehEnt.client!.otherKillerWeaponType
                }
            }
        }
    }
    //FIXME: damage hitEnt, some, too?  Our explosion should hurt them some, but...
    if killer != nil && killer!.s.eType == ET_NPC && killer!.s.NPC_class == CLASS_VEHICLE && killer!.m_pVehicle != nil && killer!.m_pVehicle!.m_pPilot != nil {
        killer = killer!.m_pVehicle!.m_pPilot.map { Entity($0) }
    }
    var dir: vec3_t? = nil
    G_Damage(pEnt, inflictor, killer, &dir, org, damage, dflags, mod)
    if tempInflictor {
        G_FreeEntity(inflictor!)
    }
}

/**
```
============
CanDamage

Returns qtrue if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
```
*/
/// Source: oracle/codemp/game/g_combat.c:5768
func CanDamage(_ targ: Entity, _ origin: JKAShared.vec3_t) -> Bool {
    var dest = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var midpoint = vec3_t()

        // use the midpoint of the bounds instead of the origin, because
        // bmodels may have their origin is 0,0,0
        midpoint = targ.r.absmin + targ.r.absmax
        midpoint = midpoint * 0.5

        dest = midpoint
        trap_Trace(tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID)
        if Double(tr.fraction) == 1.0 || tr.entityNum == targ.s.number {
            return true
        }

        // this should probably check in the plane of projection,
        // rather than in world coordinate, and also include Z
        dest = midpoint
        dest[0] = Float(Double(dest[0]) + 15.0)
        dest[1] = Float(Double(dest[1]) + 15.0)
        trap_Trace(tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID)
        if Double(tr.fraction) == 1.0 {
            return true
        }

        dest = midpoint
        dest[0] = Float(Double(dest[0]) + 15.0)
        dest[1] = Float(Double(dest[1]) - 15.0)
        trap_Trace(tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID)
        if Double(tr.fraction) == 1.0 {
            return true
        }

        dest = midpoint
        dest[0] = Float(Double(dest[0]) - 15.0)
        dest[1] = Float(Double(dest[1]) + 15.0)
        trap_Trace(tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID)
        if Double(tr.fraction) == 1.0 {
            return true
        }

        dest = midpoint
        dest[0] = Float(Double(dest[0]) - 15.0)
        dest[1] = Float(Double(dest[1]) - 15.0)
        trap_Trace(tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID)
        if Double(tr.fraction) == 1.0 {
            return true
        }


        return false
    }
}

/**
```
============
G_RadiusDamage
============
```
*/
/// Source: oracle/codemp/game/g_combat.c:5823
func G_RadiusDamage(_ origin: JKAShared.vec3_t, _ attacker: Entity, _ damage: Float, _ radius: Float, _ ignore: Entity?, _ missile: Entity?, _ mod: Int32) -> Bool {
    var points: Float
    var dist: Float
    var ent: Entity?
    var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
    let numListedEntities: Int32
    var mins = vec3_t()
    var maxs = vec3_t()
    var v = vec3_t()
    var dir = vec3_t()
    var i: Int32
    var e: Int32
    var hitClient: Bool = false
    let roastPeople: Bool = false
    // Raven assigns his own `radius` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var radius = radius

    /*
    if (missile && !missile->client && missile->s.weapon > WP_NONE &&
    missile->s.weapon < WP_NUM_WEAPONS && missile->r.ownerNum >= 0 &&
    (missile->r.ownerNum < MAX_CLIENTS || g_entities[missile->r.ownerNum].s.eType == ET_NPC))
    { //sounds like it's a valid weapon projectile.. is it a valid explosive to create marks from?
    switch(missile->s.weapon)
    {
    case WP_FLECHETTE: //flechette issuing this will be alt-fire
    case WP_ROCKET_LAUNCHER:
    case WP_THERMAL:
    case WP_TRIP_MINE:
    case WP_DET_PACK:
    roastPeople = qtrue; //Then create explosive marks
    break;
    default:
    break;
    }
    }
    */
    //oh well.. maybe sometime? I am trying to cut down on tempent use.

    if radius < 1 {
        radius = 1
    }

    i = 0
    while i < 3 {
        mins[i] = origin[i] - radius
        maxs[i] = origin[i] + radius
        i += 1
    }

    numListedEntities = trap_EntitiesInBox(mins, maxs, &entityList, MAX_GENTITIES)

    e = 0
    while e < numListedEntities {
        ent = g_entities[entityList[e]]

        if ent == ignore {
            e += 1
            continue
        }
        if !ent!.takedamage {
            e += 1
            continue
        }

        // find the distance from the edge of the bounding box
        i = 0
        while i < 3 {
            if origin[i] < ent!.r.absmin[i] {
                v[i] = ent!.r.absmin[i] - origin[i]
            } else if origin[i] > ent!.r.absmax[i] {
                v[i] = origin[i] - ent!.r.absmax[i]
            } else {
                v[i] = 0
            }
            i += 1
        }

        dist = VectorLength(v)
        if dist >= radius {
            e += 1
            continue
        }

        points = Float(Double(damage) * (1.0 - Double(dist / radius)))

        if CanDamage(ent!, origin) {
            if LogAccuracyHit(ent!, attacker) {
                hitClient = true
            }
            dir = ent!.r.currentOrigin - origin
            // push the center of mass higher than the origin so players
            // get knocked into the air more
            dir[2] += 24
            if attacker.inuse && attacker.client != nil && attacker.s.eType == ET_NPC && attacker.s.NPC_class == CLASS_VEHICLE && attacker.m_pVehicle != nil && attacker.m_pVehicle!.m_pPilot != nil {
                //say my pilot did it.
                G_Damage(ent!, missile, attacker.m_pVehicle!.m_pPilot.map { Entity($0) }, &dir, origin, Int32(points), DAMAGE_RADIUS, mod)
            } else {
                G_Damage(ent!, missile, attacker, &dir, origin, Int32(points), DAMAGE_RADIUS, mod)
            }

            if ent != nil && ent!.client != nil && roastPeople && missile != nil && VectorCompare(ent!.r.currentOrigin, missile!.r.currentOrigin) == 0 {
                //the thing calling this function can create burn marks on people, so create an event to do so
                let evEnt: Entity? = G_TempEntity(ent!.r.currentOrigin, EV_GHOUL2_MARK)

                evEnt!.s.otherEntityNum = ent!.s.number //the entity the mark should be placed on
                evEnt!.s.weapon = WP_ROCKET_LAUNCHER //always say it's rocket so we make the right mark

                //Try to place the decal by going from the missile location to the location of the person that was hit
                evEnt!.s.origin = missile!.r.currentOrigin
                evEnt!.s.origin2 = ent!.r.currentOrigin

                //it's hacky, but we want to move it up so it's more likely to hit
                //the torso.
                if missile!.r.currentOrigin[2] < ent!.r.currentOrigin[2] {
                    //move it up less so the decal is placed lower on the model then
                    evEnt!.s.origin2[2] += 8
                } else {
                    evEnt!.s.origin2[2] += 24
                }

                //Special col check
                evEnt!.s.eventParm = 1
            }
        }
        e += 1
    }

    return hitClient
}
