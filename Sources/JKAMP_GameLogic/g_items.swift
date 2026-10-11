import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_items.c:21
let RESPAWN_ARMOR = 20 as Int32

/// Source: oracle/codemp/game/g_items.c:22
let RESPAWN_TEAM_WEAPON = 30 as Int32

/// Source: oracle/codemp/game/g_items.c:23
let RESPAWN_HEALTH = 30 as Int32

/// Source: oracle/codemp/game/g_items.c:24
let RESPAWN_AMMO = 40 as Int32

/// Source: oracle/codemp/game/g_items.c:25
let RESPAWN_HOLDABLE = 60 as Int32

/// Source: oracle/codemp/game/g_items.c:26
let RESPAWN_MEGAHEALTH = 120 as Int32

/// Source: oracle/codemp/game/g_items.c:27
let RESPAWN_POWERUP = 120 as Int32

/// Source: oracle/codemp/game/g_items.c:30
let ITMSF_SUSPEND = 1 as Int32

/// Source: oracle/codemp/game/g_items.c:31
let ITMSF_NOPLAYER = 2 as Int32

/// Source: oracle/codemp/game/g_items.c:32
let ITMSF_ALLOWNPC = 4 as Int32

/// Source: oracle/codemp/game/g_items.c:33
let ITMSF_NOTSOLID = 8 as Int32

/// Source: oracle/codemp/game/g_items.c:34
let ITMSF_VERTICAL = 16 as Int32

/// Source: oracle/codemp/game/g_items.c:35
let ITMSF_INVISIBLE = 32 as Int32

/// Source: oracle/codemp/game/g_items.c:42
let MAX_MEDPACK_HEAL_AMOUNT = 25 as Int32

/// Source: oracle/codemp/game/g_items.c:43
let MAX_MEDPACK_BIG_HEAL_AMOUNT = 50 as Int32

/// Source: oracle/codemp/game/g_items.c:44
let MAX_SENTRY_DISTANCE = 256 as Int32

/// Source: oracle/codemp/game/g_items.c:91
let SHIELD_HEALTH = 250 as Int32

/// Source: oracle/codemp/game/g_items.c:92
let SHIELD_HEALTH_DEC = 10 as Int32

/// Source: oracle/codemp/game/g_items.c:93
let MAX_SHIELD_HEIGHT = 254 as Int32

/// Source: oracle/codemp/game/g_items.c:94
let MAX_SHIELD_HALFWIDTH = 255 as Int32

/// Source: oracle/codemp/game/g_items.c:95
let SHIELD_HALFTHICKNESS = 4 as Int32

/// Source: oracle/codemp/game/g_items.c:96
let SHIELD_PLACEDIST = 64 as Int32

/// Source: oracle/codemp/game/g_items.c:98
let SHIELD_SIEGE_HEALTH = 2000 as Int32

/// Source: oracle/codemp/game/g_items.c:99
let SHIELD_SIEGE_HEALTH_DEC = (SHIELD_SIEGE_HEALTH / 25)

/// Source: oracle/codemp/game/g_items.c:101
var shieldLoopSound: JKAShared.qhandle_t {
    get { world.variables.shieldLoopSound }
    set { world.variables.shieldLoopSound = newValue }
}

/// Source: oracle/codemp/game/g_items.c:102
var shieldAttachSound: JKAShared.qhandle_t {
    get { world.variables.shieldAttachSound }
    set { world.variables.shieldAttachSound = newValue }
}

/// Source: oracle/codemp/game/g_items.c:103
var shieldActivateSound: JKAShared.qhandle_t {
    get { world.variables.shieldActivateSound }
    set { world.variables.shieldActivateSound = newValue }
}

/// Source: oracle/codemp/game/g_items.c:104
var shieldDeactivateSound: JKAShared.qhandle_t {
    get { world.variables.shieldDeactivateSound }
    set { world.variables.shieldDeactivateSound = newValue }
}

/// Source: oracle/codemp/game/g_items.c:105
var shieldDamageSound: JKAShared.qhandle_t {
    get { world.variables.shieldDamageSound }
    set { world.variables.shieldDamageSound = newValue }
}

/// Source: oracle/codemp/game/g_items.c:513
let PAS_DAMAGE = 2 as Int32

/// Source: oracle/codemp/game/g_items.c:544
let TURRET_RADIUS = 800 as Int32

/// Source: oracle/codemp/game/g_items.c:697
let TURRET_DEATH_DELAY = 2000 as Int32

/// Source: oracle/codemp/game/g_items.c:698
let TURRET_LIFETIME = 60000 as Int32

/// Source: oracle/codemp/game/g_items.c:975
let TURRET_AMMO_COUNT = 40 as Int32

/// Source: oracle/codemp/game/g_items.c:1164
let JETPACK_TOGGLE_TIME = 1000 as Int32

/// Source: oracle/codemp/game/g_items.c:1236
let CLOAK_TOGGLE_TIME = 1000 as Int32

/// Source: oracle/codemp/game/g_items.c:1274
let TOSSED_ITEM_STAY_PERIOD = 20000 as Int32

/// Source: oracle/codemp/game/g_items.c:1275
let TOSSED_ITEM_OWNER_NOTOUCH_DUR = 1000 as Int32

/// Source: oracle/codemp/game/g_items.c:1333
let DISP_HEALTH_ITEM = "item_medpak_instant"

/// Source: oracle/codemp/game/g_items.c:1334
let DISP_AMMO_ITEM = "ammo_all"

/// Source: oracle/codemp/game/g_items.c:1442
let EWEB_DEATH_RADIUS = 128 as Int32

/// Source: oracle/codemp/game/g_items.c:1443
let EWEB_DEATH_DMG = 90 as Int32

/// Source: oracle/codemp/game/g_items.c:1623
let EWEB_MISSILE_DAMAGE = 20 as Int32

/// Source: oracle/codemp/game/g_items.c:1856
let EWEB_HEALTH = 200 as Int32

/// Source: oracle/codemp/game/g_items.c:1982
let EWEB_USE_DEBOUNCE = 1000 as Int32

/// Source: oracle/codemp/game/g_items.c:2966
var itemRegistered: [Bool] {
    get { world.variables.itemRegistered }
    set { world.variables.itemRegistered = newValue }
}

// For more than four players, adjust the respawn times, up to 1/4.
/// Source: oracle/codemp/game/g_items.c:47
func adjustRespawnTime(_ preRespawnTime: Float, _ itemType: Int32, _ itemTag: Int32) -> Int32 {
    var respawnTime: Float = preRespawnTime

    if itemType == IT_WEAPON {
        if itemTag == WP_THERMAL || itemTag == WP_TRIP_MINE || itemTag == WP_DET_PACK {
            //special case for these, use ammo respawn rate
            respawnTime = Float(RESPAWN_AMMO)
        }
    }

    if g_adaptRespawn.integer == 0 {
        return (Int32(respawnTime))
    }

    if level.numPlayingClients > 4 {
        // Start scaling the respawn times.
        if level.numPlayingClients > 32 {
            // 1/4 time minimum.
            respawnTime = Float(Double(respawnTime) * 0.25)
        } else if level.numPlayingClients > 12 {
            // From 12-32, scale from 0.5 to 0.25;
            respawnTime = Float(Double(respawnTime) * 20.0 / Double(Float((level.numPlayingClients + 8))))
        } else {
            // From 4-12, scale from 1.0 to 0.5;
            respawnTime = Float(Double(respawnTime) * 8.0 / Double(Float((level.numPlayingClients + 4))))
        }
    }

    if Double(respawnTime) < 1.0 {
        // No matter what, don't go lower than 1 second, or the pickups become very noisy!
        respawnTime = 1.0
    }

    return (Int32(respawnTime))
}

/// Source: oracle/codemp/game/g_items.c:108
func ShieldRemove(_ `self`: Entity) {
    `self`.think = Think.G_FreeEntity
    `self`.nextthink = level.time + 100

    // Play kill sound...
    G_AddEvent(`self`, EV_GENERAL_SOUND, shieldDeactivateSound)
    `self`.s.loopSound = 0
    `self`.s.loopIsSoundset = false

    return
}

// Count down the health of the shield.
/// Source: oracle/codemp/game/g_items.c:123
func ShieldThink(_ `self`: Entity) {
    `self`.s.trickedentindex = 0

    if g_gametype.integer == GT_SIEGE {
        `self`.health -= SHIELD_SIEGE_HEALTH_DEC
    } else {
        `self`.health -= SHIELD_HEALTH_DEC
    }
    `self`.nextthink = level.time + 1000
    if `self`.health <= 0 {
        ShieldRemove(`self`)
    }
    return
}

// The shield was damaged to below zero health.
/// Source: oracle/codemp/game/g_items.c:145
func ShieldDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    // Play damaging sound...
    G_AddEvent(`self`, EV_GENERAL_SOUND, shieldDamageSound)

    ShieldRemove(`self`)
}

// The shield had damage done to it.  Make it flicker.
/// Source: oracle/codemp/game/g_items.c:155
func ShieldPain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    // Set the itemplaceholder flag to indicate the the shield drawing that the shield pain should be drawn.
    `self`.think = Think.ShieldThink
    `self`.nextthink = level.time + 400

    // Play damaging sound...
    G_AddEvent(`self`, EV_GENERAL_SOUND, shieldDamageSound)

    `self`.s.trickedentindex = 1

    return
}

// Try to turn the shield back on after a delay.
/// Source: oracle/codemp/game/g_items.c:171
func ShieldGoSolid(_ `self`: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        // see if we're valid
        `self`.health -= 1
        if `self`.health <= 0 {
            ShieldRemove(`self`)
            return true
        }

        trap_Trace(tr, `self`.r.currentOrigin, `self`.r.mins, `self`.r.maxs, `self`.r.currentOrigin, `self`.s.number, CONTENTS_BODY)
        if tr.startsolid != 0 {
            // gah, we can't activate yet
            `self`.nextthink = level.time + 200
            `self`.think = Think.ShieldGoSolid
            trap_LinkEntity(`self`)
        } else {
            // get hard... huh-huh...
            `self`.s.eFlags &= ~EF_NODRAW

            `self`.r.contents = CONTENTS_SOLID
            `self`.nextthink = level.time + 1000
            `self`.think = Think.ShieldThink
            `self`.takedamage = true
            trap_LinkEntity(`self`)

            // Play raising sound...
            G_AddEvent(`self`, EV_GENERAL_SOUND, shieldActivateSound)
            `self`.s.loopSound = shieldLoopSound
            `self`.s.loopIsSoundset = false
        }

        return true
        return false
    }
    if earlyOut {
        return
    }
}

// Turn the shield off to allow a friend to pass through.
/// Source: oracle/codemp/game/g_items.c:211
func ShieldGoNotSolid(_ `self`: Entity) {
    // make the shield non-solid very briefly
    `self`.r.contents = 0
    `self`.s.eFlags |= EF_NODRAW
    // nextthink needs to have a large enough interval to avoid excess accumulation of Activate messages
    `self`.nextthink = level.time + 200
    `self`.think = Think.ShieldGoSolid
    `self`.takedamage = false
    trap_LinkEntity(`self`)

    // Play kill sound...
    G_AddEvent(`self`, EV_GENERAL_SOUND, shieldDeactivateSound)
    `self`.s.loopSound = 0
    `self`.s.loopIsSoundset = false
}

// Somebody (a player) has touched the shield.  See if it is a "friend".
/// Source: oracle/codemp/game/g_items.c:230
func ShieldTouch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if g_gametype.integer >= GT_TEAM {
        // let teammates through
        // compare the parent's team to the "other's" team
        if `self`.parent != nil && `self`.parent!.client != nil && other.client != nil {
            if OnSameTeam(`self`.parent!, other) {
                ShieldGoNotSolid(`self`)
            }
        }
    } else {
        //let the person who dropped the shield through
        if `self`.parent != nil && `self`.parent!.s.number == other.s.number {
            ShieldGoNotSolid(`self`)
        }
    }
}

// After a short delay, create the shield by expanding in all directions.
/// Source: oracle/codemp/game/g_items.c:254
func CreateShield(_ ent: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var mins = vec3_t()
        var maxs = vec3_t()
        var end = vec3_t()
        var posTraceEnd = vec3_t()
        var negTraceEnd = vec3_t()
        var start = vec3_t()
        var height: Int32 = 0
        var posWidth: Int32 = 0
        var negWidth: Int32 = 0
        var halfWidth: Int32 = 0
        var xaxis: Bool = false
        var paramData: Int32 = 0
        var shieldID: Int32 = 0

        // trace upward to find height of shield
        end = ent.r.currentOrigin
        end[2] += MAX_SHIELD_HEIGHT
        trap_Trace(tr, ent.r.currentOrigin, vec3_origin, vec3_origin, end, ent.s.number, MASK_SHOT)
        height = Int32((MAX_SHIELD_HEIGHT * tr.fraction))

        // use angles to find the proper axis along which to align the shield
        mins = vec3_t(Float(-SHIELD_HALFTHICKNESS), Float(-SHIELD_HALFTHICKNESS), 0)
        maxs = vec3_t(Float(SHIELD_HALFTHICKNESS), Float(SHIELD_HALFTHICKNESS), Float(height))
        posTraceEnd = ent.r.currentOrigin
        negTraceEnd = ent.r.currentOrigin

        if Int32((ent.s.angles[YAW])) == 0 {
            posTraceEnd[1] += MAX_SHIELD_HALFWIDTH
            negTraceEnd[1] -= MAX_SHIELD_HALFWIDTH
            xaxis = false
        } else {
            posTraceEnd[0] += MAX_SHIELD_HALFWIDTH
            negTraceEnd[0] -= MAX_SHIELD_HALFWIDTH
            xaxis = true
        }

        // trace horizontally to find extend of shield
        // positive trace
        start = ent.r.currentOrigin
        start[2] += (height >> 1)
        trap_Trace(tr, start, vec3_origin, vec3_origin, posTraceEnd, ent.s.number, MASK_SHOT)
        posWidth = Int32(MAX_SHIELD_HALFWIDTH * tr.fraction)
        // negative trace
        trap_Trace(tr, start, vec3_origin, vec3_origin, negTraceEnd, ent.s.number, MASK_SHOT)
        negWidth = Int32(MAX_SHIELD_HALFWIDTH * tr.fraction)

        // kef -- monkey with dimensions and place origin in center
        halfWidth = (posWidth + negWidth) >> 1
        if xaxis {
            ent.r.currentOrigin[0] = ent.r.currentOrigin[0] - negWidth + halfWidth
        } else {
            ent.r.currentOrigin[1] = ent.r.currentOrigin[1] - negWidth + halfWidth
        }
        ent.r.currentOrigin[2] += (height >> 1)

        // set entity's mins and maxs to new values, make it solid, and link it
        if xaxis {
            ent.r.mins = vec3_t(Float(-halfWidth), Float(-SHIELD_HALFTHICKNESS), Float(-(height >> 1)))
            ent.r.maxs = vec3_t(Float(halfWidth), Float(SHIELD_HALFTHICKNESS), Float(height >> 1))
        } else {
            ent.r.mins = vec3_t(Float(-SHIELD_HALFTHICKNESS), Float(-halfWidth), Float(-(height >> 1)))
            ent.r.maxs = vec3_t(Float(SHIELD_HALFTHICKNESS), Float(halfWidth), Float(height))
        }
        ent.clipmask = MASK_SHOT

        // Information for shield rendering.

        //	xaxis - 1 bit
        //	height - 0-254 8 bits
        //	posWidth - 0-255 8 bits
        //  negWidth - 0 - 255 8 bits

        paramData = ((xaxis ? 1 : 0) << 24) | (height << 16) | (posWidth << 8) | (negWidth)
        ent.s.time2 = paramData

        if g_gametype.integer == GT_SIEGE {
            ent.health = Int32(ceil(Float((SHIELD_SIEGE_HEALTH * 1))))
        } else {
            ent.health = Int32(ceil(Float((SHIELD_HEALTH * 1))))
        }

        ent.s.time = ent.health //???
        ent.pain = Pain.ShieldPain
        ent.die = Die.ShieldDie
        ent.touch = Touch.ShieldTouch

        // see if we're valid
        trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, ent.r.currentOrigin, ent.s.number, CONTENTS_BODY)

        if tr.startsolid != 0 {
            // Something in the way!
            // make the shield non-solid very briefly
            ent.r.contents = 0
            ent.s.eFlags |= EF_NODRAW
            // nextthink needs to have a large enough interval to avoid excess accumulation of Activate messages
            ent.nextthink = level.time + 200
            ent.think = Think.ShieldGoSolid
            ent.takedamage = false
            trap_LinkEntity(ent)
        } else {
            // Get solid.
            ent.r.contents = CONTENTS_PLAYERCLIP | CONTENTS_SHOTCLIP //CONTENTS_SOLID;

            ent.nextthink = level.time
            ent.think = Think.ShieldThink

            ent.takedamage = true
            trap_LinkEntity(ent)

            // Play raising sound...
            G_AddEvent(ent, EV_GENERAL_SOUND, shieldActivateSound)
            ent.s.loopSound = shieldLoopSound
            ent.s.loopIsSoundset = false
        }

        ShieldGoSolid(ent)

        return true
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_items.c:382
func PlaceShield(_ playerent: Entity) -> Bool {
    var shieldItem: Gitem? = nil
    var shield: Entity? = nil
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var fwd = vec3_t()
        var pos = vec3_t()
        var dest = vec3_t()
        var mins = vec3_t(-4, -4, 0)
        var maxs = vec3_t(4, 4, 4)

        if shieldAttachSound == 0 {
            shieldLoopSound = G_SoundIndex("sound/movers/doors/forcefield_lp.wav")
            shieldAttachSound = G_SoundIndex("sound/weapons/detpack/stick.wav")
            shieldActivateSound = G_SoundIndex("sound/movers/doors/forcefield_on.wav")
            shieldDeactivateSound = G_SoundIndex("sound/movers/doors/forcefield_off.wav")
            shieldDamageSound = G_SoundIndex("sound/effects/bumpfield.wav")
            shieldItem = BG_FindItemForHoldable(HI_SHIELD)
        }

        // can we place this in front of us?
        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(playerent.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)
        fwd[2] = 0
        _VectorMA(playerent.client!.ps.origin, Float(SHIELD_PLACEDIST), fwd, &dest)
        trap_Trace(tr, playerent.client!.ps.origin, mins, maxs, dest, playerent.s.number, MASK_SHOT)
        if Double(tr.fraction) > 0.9 {
            //room in front
            pos = tr.endpos
            // drop to floor
            dest = vec3_t(pos[0], pos[1], pos[2] - 4096)
            trap_Trace(tr, pos, mins, maxs, dest, playerent.s.number, MASK_SOLID)
            if tr.startsolid == 0 && tr.allsolid == 0 {
                // got enough room so place the portable shield
                shield = G_Spawn()

                // Figure out what direction the shield is facing.
                if abs(fwd[0]) > abs(fwd[1]) {
                    // shield is north/south, facing east.
                    shield!.s.angles[YAW] = 0
                } else {
                    // shield is along the east/west axis, facing north
                    shield!.s.angles[YAW] = 90
                }
                shield!.think = Think.CreateShield
                shield!.nextthink = level.time + 500 // power up after .5 seconds
                shield!.parent = playerent

                // Set team number.
                shield!.s.otherEntityNum2 = playerent.client!.sess.sessionTeam

                shield!.s.eType = ET_SPECIAL
                shield!.s.modelindex = HI_SHIELD // this'll be used in CG_Useable() for rendering.
                shield!.classname = shieldItem!.classname

                shield!.r.contents = CONTENTS_TRIGGER

                shield!.touch = nil
                // using an item causes it to respawn
                shield!.use = nil //Use_Item;

                // allow to ride movers
                shield!.s.groundEntityNum = tr.entityNum

                G_SetOrigin(shield!, &tr.endpos)

                shield!.s.eFlags &= ~EF_NODRAW
                shield!.r.svFlags &= ~SVF_NOCLIENT

                trap_LinkEntity(shield!)

                shield!.s.owner = playerent.s.number
                shield!.s.shouldtarget = true
                if g_gametype.integer >= GT_TEAM {
                    shield!.s.teamowner = playerent.client!.sess.sessionTeam
                } else {
                    shield!.s.teamowner = 16
                }

                // Play placing sound...
                G_AddEvent(shield!, EV_GENERAL_SOUND, shieldAttachSound)

                return true
            }
        }
        // no room
        return false
    }
}

/// Source: oracle/codemp/game/g_items.c:472
func ItemUse_Binoculars(_ ent: Entity) {
    if ent.client == nil {
        return
    }

    if ent.client!.ps.weaponstate != WEAPON_READY {
        //So we can't fool it and reactivate while switching to the saber or something.
        return
    }

    /*
    if (ent->client->ps.weapon == WP_SABER)
    { //No.
    return;
    }
    */

    if ent.client!.ps.zoomMode == 0 {
        ent.client!.ps.zoomMode = 2
        ent.client!.ps.zoomLocked = false
        ent.client!.ps.zoomFov = 40.0
    } else if ent.client!.ps.zoomMode == 2 {
        ent.client!.ps.zoomMode = 0
        ent.client!.ps.zoomTime = level.time
    }
}

/// Source: oracle/codemp/game/g_items.c:504
func ItemUse_Shield(_ ent: Entity) {
    PlaceShield(ent)
}

/// Source: oracle/codemp/game/g_items.c:515
func SentryTouch(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    return
}

//----------------------------------------------------------------
/// Source: oracle/codemp/game/g_items.c:521
func pas_fire(_ ent: Entity) {
    var fwd = vec3_t()
    var myOrg = vec3_t()
    var enOrg = vec3_t()

    myOrg = ent.r.currentOrigin
    myOrg[2] += 24

    enOrg = ent.enemy!.client!.ps.origin
    enOrg[2] += 24

    fwd = enOrg - myOrg
    VectorNormalize(&fwd)

    myOrg[0] += fwd[0] * 16
    myOrg[1] += fwd[1] * 16
    myOrg[2] += fwd[2] * 16

    WP_FireTurretMissile(g_entities[ent.genericValue3], &myOrg, fwd, false, 10, 2300, MOD_SENTRY, ent)

    G_RunObject(ent)
}

//-----------------------------------------------------
/// Source: oracle/codemp/game/g_items.c:547
private func pas_find_enemies(_ `self`: Entity) -> Bool {
    var found: Bool = false
    var count: Int32 = 0
    var i: Int32 = 0
    var bestDist: Float = Float(TURRET_RADIUS * TURRET_RADIUS)
    var enemyDist: Float = 0
    var enemyDir = vec3_t()
    var org = vec3_t()
    var org2 = vec3_t()
    var entity_list = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))
    var target: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in

        if `self`.aimDebounceTime > level.time {
            // We were active and alert, i.e. had an enemy in the last 3 secs
            if `self`.painDebounceTime < level.time {
                G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/chars/turret/ping.wav"))
                `self`.painDebounceTime = level.time + 1000
            }
        }

        org2 = `self`.s.pos.trBase

        count = G_RadiusList(org2, Float(TURRET_RADIUS), `self`, true, &entity_list)

        i = 0
        while i < count {
            target = entity_list[i]

            if target!.client == nil {
                i += 1
                continue
            }
            if target == `self` || !target!.takedamage || target!.health <= 0 || (target!.flags & FL_NOTARGET) != 0 {
                i += 1
                continue
            }
            if `self`.alliedTeam != 0 && target!.client!.sess.sessionTeam == `self`.alliedTeam {
                i += 1
                continue
            }
            if `self`.genericValue3 == target!.s.number {
                i += 1
                continue
            }
            if !trap_InPVS(org2, target!.r.currentOrigin) {
                i += 1
                continue
            }

            if target!.s.eType == ET_NPC && target!.s.NPC_class == CLASS_VEHICLE {
                //don't get mad at vehicles, silly.
                i += 1
                continue
            }

            if target!.client != nil {
                org = target!.client!.ps.origin
            } else {
                org = target!.r.currentOrigin
            }

            trap_Trace(tr, org2, vec3_origin, vec3_origin, org, `self`.s.number, MASK_SHOT)

            if tr.allsolid == 0 && tr.startsolid == 0 && (Double(tr.fraction) == 1.0 || tr.entityNum == target!.s.number) {
                // Only acquire if have a clear shot, Is it in range and closer than our best?
                enemyDir = target!.r.currentOrigin - `self`.r.currentOrigin
                enemyDist = VectorLengthSquared(enemyDir)

                if enemyDist < bestDist {
                    if `self`.attackDebounceTime + 100 < level.time {
                        // We haven't fired or acquired an enemy in the last 2 seconds-start-up sound
                        G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/chars/turret/startup.wav"))

                        // Wind up turrets for a bit
                        // The SDK also declares `random`, so the call names the bg module.
                        `self`.attackDebounceTime = Int32(level.time + 900 + JKAMP_BG.random() * 200)
                    }

                    G_SetEnemy(`self`, target!)
                    bestDist = enemyDist
                    found = true
                }
            }
            i += 1
        }

        return found
    }
}

//---------------------------------
/// Source: oracle/codemp/game/g_items.c:642
func pas_adjust_enemy(_ ent: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in
        var keep: Bool = true

        if ent.enemy!.health <= 0 {
            keep = false
        } else {
            var org = vec3_t()
            var org2 = vec3_t()

            org2 = ent.s.pos.trBase

            if ent.enemy!.client != nil {
                org = ent.enemy!.client!.ps.origin
                org[2] -= 15
            } else {
                org = ent.enemy!.r.currentOrigin
            }

            trap_Trace(tr, org2, vec3_origin, vec3_origin, org, ent.s.number, MASK_SHOT)

            if tr.allsolid != 0 || tr.startsolid != 0 || tr.fraction < 0.9 || tr.entityNum == ent.s.number {
                if tr.entityNum != ent.enemy!.s.number {
                    // trace failed
                    keep = false
                }
            }
        }

        if keep {
            //ent->bounceCount = level.time + 500 + random() * 150;
        } else if ent.bounceCount < level.time && ent.enemy != nil {
            ent.enemy = nil
            // shut-down sound
            G_Sound(ent, CHAN_BODY, G_SoundIndex("sound/chars/turret/shutdown.wav"))

            // The SDK also declares `random`, so the call names the bg module.
            ent.bounceCount = Int32(level.time + 500 + JKAMP_BG.random() * 150)

            // make turret play ping sound for 5 seconds
            ent.aimDebounceTime = level.time + 5000
        }
    }
}

/// Source: oracle/codemp/game/g_items.c:702
func sentryExpire(_ `self`: Entity) {
    turret_die(`self`, `self`, `self`, 1000, MOD_UNKNOWN)
}

//---------------------------------
/// Source: oracle/codemp/game/g_items.c:708
func pas_think(_ ent: Entity) {
    var moved: Bool
    var diffYaw: Float
    var diffPitch: Float
    var enemyDir = vec3_t()
    var org = vec3_t()
    var frontAngles = vec3_t()
    var backAngles = vec3_t()
    var desiredAngles = vec3_t()
    var iEntityList: [Int32] = [Int32](repeating: 0, count: 1024)
    var numListedEntities: Int32
    var i: Int32 = 0
    var clTrapped: Bool = false
    var testMins = vec3_t()
    var testMaxs = vec3_t()

    testMins[0] = ent.r.currentOrigin[0] + ent.r.mins[0] + 4
    testMins[1] = ent.r.currentOrigin[1] + ent.r.mins[1] + 4
    testMins[2] = ent.r.currentOrigin[2] + ent.r.mins[2] + 4

    testMaxs[0] = ent.r.currentOrigin[0] + ent.r.maxs[0] - 4
    testMaxs[1] = ent.r.currentOrigin[1] + ent.r.maxs[1] - 4
    testMaxs[2] = ent.r.currentOrigin[2] + ent.r.maxs[2] - 4

    numListedEntities = trap_EntitiesInBox(testMins, testMaxs, &iEntityList, MAX_GENTITIES)

    while i < numListedEntities {
        if iEntityList[i] < MAX_CLIENTS {
            //client stuck inside me. go nonsolid.
            let clNum: Int32 = iEntityList[i]

            numListedEntities = trap_EntitiesInBox(g_entities[clNum].r.absmin, g_entities[clNum].r.absmax, &iEntityList, MAX_GENTITIES)

            i = 0
            while i < numListedEntities {
                if iEntityList[i] == ent.s.number {
                    clTrapped = true
                    break
                }
                i += 1
            }
            break
        }

        i += 1
    }

    if clTrapped {
        ent.r.contents = 0
        ent.s.fireflag = 0
        ent.nextthink = level.time + FRAMETIME
        return
    } else {
        ent.r.contents = CONTENTS_SOLID
    }

    if !g_entities[ent.genericValue3].inuse || g_entities[ent.genericValue3].client == nil || g_entities[ent.genericValue3].client!.sess.sessionTeam != ent.genericValue2 {
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
        return
    }

    //	G_RunObject(ent);

    if ent.damage == 0 {
        ent.damage = 1
        ent.nextthink = level.time + FRAMETIME
        return
    }

    if (ent.genericValue8 + TURRET_LIFETIME) < level.time {
        G_Sound(ent, CHAN_BODY, G_SoundIndex("sound/chars/turret/shutdown.wav"))
        ent.s.bolt2 = ENTITYNUM_NONE
        ent.s.fireflag = 2

        ent.think = Think.sentryExpire
        ent.nextthink = level.time + TURRET_DEATH_DELAY
        return
    }

    ent.nextthink = level.time + FRAMETIME

    if ent.enemy != nil {
        // make sure that the enemy is still valid
        pas_adjust_enemy(ent)
    }

    if ent.enemy != nil {
        if ent.enemy!.client == nil {
            ent.enemy = nil
        } else if ent.enemy!.s.number == ent.s.number {
            ent.enemy = nil
        } else if ent.enemy!.health < 1 {
            ent.enemy = nil
        }
    }

    if ent.enemy == nil {
        pas_find_enemies(ent)
    }

    if ent.enemy != nil {
        ent.s.bolt2 = ent.enemy!.s.number
    } else {
        ent.s.bolt2 = ENTITYNUM_NONE
    }

    moved = false
    diffYaw = 0.0
    diffPitch = 0.0

    ent.speed = AngleNormalize360(ent.speed)
    ent.random = AngleNormalize360(ent.random)

    if ent.enemy != nil {
        // ...then we'll calculate what new aim adjustments we should attempt to make this frame
        // Aim at enemy
        if ent.enemy!.client != nil {
            org = ent.enemy!.client!.ps.origin
        } else {
            org = ent.enemy!.r.currentOrigin
        }

        enemyDir = org - ent.r.currentOrigin
        vectoangles(enemyDir, &desiredAngles)

        diffYaw = AngleSubtract(ent.speed, desiredAngles[YAW])
        diffPitch = AngleSubtract(ent.random, desiredAngles[PITCH])
    } else {
        // no enemy, so make us slowly sweep back and forth as if searching for a new one
        diffYaw = sin(level.time * 0.0001 + ent.count) * 2.0
    }

    if abs(diffYaw) > 0.25 {
        moved = true

        if abs(diffYaw) > 10.0 {
            // cap max speed
            ent.speed += (diffYaw > 0.0) ? -10.0 : 10.0
        } else {
            // small enough
            ent.speed -= diffYaw
        }
    }


    if abs(diffPitch) > 0.25 {
        moved = true

        if abs(diffPitch) > 4.0 {
            // cap max speed
            ent.random += (diffPitch > 0.0) ? -4.0 : 4.0
        } else {
            // small enough
            ent.random -= diffPitch
        }
    }

    // the bone axes are messed up, so hence some dumbness here
    frontAngles = vec3_t(-ent.random, 0.0, 0.0)
    backAngles = vec3_t(0.0, 0.0, ent.speed)

    if moved {
        //ent->s.loopSound = G_SoundIndex( "sound/chars/turret/move.wav" );
    } else {
        ent.s.loopSound = 0
        ent.s.loopIsSoundset = false
    }

    if ent.enemy != nil && ent.attackDebounceTime < level.time {
        ent.count -= 1

        if ent.count != 0 {
            pas_fire(ent)
            ent.s.fireflag = 1
            ent.attackDebounceTime = level.time + 200
        } else {
            //ent->nextthink = 0;
            G_Sound(ent, CHAN_BODY, G_SoundIndex("sound/chars/turret/shutdown.wav"))
            ent.s.bolt2 = ENTITYNUM_NONE
            ent.s.fireflag = 2

            ent.think = Think.sentryExpire
            ent.nextthink = level.time + TURRET_DEATH_DELAY
        }
    } else {
        ent.s.fireflag = 0
    }
}

//------------------------------------------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_items.c:940
func turret_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    // Turn off the thinking of the base & use it's targets
    `self`.think = nil //NULL;
    `self`.use = nil //NULL;

    if `self`.target != nil {
        G_UseTargets(`self`, attacker)
    }

    if !g_entities[`self`.genericValue3].inuse || g_entities[`self`.genericValue3].client == nil {
        G_FreeEntity(`self`)
        return
    }

    // clear my data
    `self`.die = nil //NULL;
    `self`.takedamage = false
    `self`.health = 0

    // hack the effect angle so that explode death can orient the effect properly
    `self`.s.angles = vec3_t(0, 0, 1)

    G_PlayEffect(EFFECT_EXPLOSION_PAS, `self`.s.pos.trBase, `self`.s.angles)
    G_RadiusDamage(`self`.s.pos.trBase, g_entities[`self`.genericValue3], 30, 256, `self`, `self`, MOD_UNKNOWN)

    g_entities[`self`.genericValue3].client!.ps.fd.sentryDeployed = false

    //ExplodeDeath( self );
    G_FreeEntity(`self`)
}

//---------------------------------
/// Source: oracle/codemp/game/g_items.c:978
func SP_PAS(_ base: Entity) {
    if base.count == 0 {
        // give ammo
        base.count = TURRET_AMMO_COUNT
    }

    base.s.bolt1 = 1 //This is a sort of hack to indicate that this model needs special turret things done to it
    base.s.bolt2 = ENTITYNUM_NONE //store our current enemy index

    base.damage = 0 // start animation flag

    base.r.mins = vec3_t(-8, -8, 0)
    base.r.maxs = vec3_t(8, 8, 24)

    G_RunObject(base)

    base.think = Think.pas_think
    base.nextthink = level.time + FRAMETIME

    if base.health == 0 {
        base.health = 50
    }

    base.takedamage = true
    base.die = Die.turret_die

    base.physicsObject = true

    G_Sound(base, CHAN_BODY, G_SoundIndex("sound/chars/turret/startup.wav"))
}

//------------------------------------------------------------------------
/// Source: oracle/codemp/game/g_items.c:1014
func ItemUse_Sentry(_ ent: Entity) {
    var fwd = vec3_t()
    var fwdorg = vec3_t()
    var yawonly = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    var sentry: Entity?

    if ent.client == nil {
        return
    }

    mins = vec3_t(-8, -8, 0)
    maxs = vec3_t(8, 8, 24)


    yawonly[ROLL] = 0
    yawonly[PITCH] = 0
    yawonly[YAW] = ent.client!.ps.viewangles[YAW]

    // Raven passes NULL for the `right` and `up` outputs.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(yawonly, &fwd, &scratchRight, &scratchUp)

    fwdorg[0] = ent.client!.ps.origin[0] + fwd[0] * 64
    fwdorg[1] = ent.client!.ps.origin[1] + fwd[1] * 64
    fwdorg[2] = ent.client!.ps.origin[2] + fwd[2] * 64

    sentry = G_Spawn()

    sentry!.classname = "sentryGun"
    sentry!.s.modelindex = G_ModelIndex("models/items/psgun.glm") //replace ASAP

    sentry!.s.g2radius = Int32(30.0)
    sentry!.s.modelGhoul2 = 1

    G_SetOrigin(sentry!, &fwdorg)
    sentry!.parent = ent
    sentry!.r.contents = CONTENTS_SOLID
    sentry!.s.solid = 2
    sentry!.clipmask = MASK_SOLID
    sentry!.r.mins = mins
    sentry!.r.maxs = maxs
    sentry!.genericValue3 = ent.s.number
    sentry!.genericValue2 = ent.client!.sess.sessionTeam //so we can remove ourself if our owner changes teams
    sentry!.r.absmin[0] = sentry!.s.pos.trBase[0] + sentry!.r.mins[0]
    sentry!.r.absmin[1] = sentry!.s.pos.trBase[1] + sentry!.r.mins[1]
    sentry!.r.absmin[2] = sentry!.s.pos.trBase[2] + sentry!.r.mins[2]
    sentry!.r.absmax[0] = sentry!.s.pos.trBase[0] + sentry!.r.maxs[0]
    sentry!.r.absmax[1] = sentry!.s.pos.trBase[1] + sentry!.r.maxs[1]
    sentry!.r.absmax[2] = sentry!.s.pos.trBase[2] + sentry!.r.maxs[2]
    sentry!.s.eType = ET_GENERAL
    sentry!.s.pos.trType = TR_GRAVITY //STATIONARY;
    sentry!.s.pos.trTime = level.time
    sentry!.touch = Touch.SentryTouch
    sentry!.nextthink = level.time
    sentry!.genericValue4 = ENTITYNUM_NONE //genericValue4 used as enemy index

    sentry!.genericValue5 = 1000

    sentry!.genericValue8 = level.time

    sentry!.alliedTeam = ent.client!.sess.sessionTeam

    ent.client!.ps.fd.sentryDeployed = true

    trap_LinkEntity(sentry!)

    sentry!.s.owner = ent.s.number
    sentry!.s.shouldtarget = true
    if g_gametype.integer >= GT_TEAM {
        sentry!.s.teamowner = ent.client!.sess.sessionTeam
    } else {
        sentry!.s.teamowner = 16
    }

    SP_PAS(sentry!)
}

/// Source: oracle/codemp/game/g_items.c:1096
func ItemUse_Seeker(_ ent: Entity) {
    if g_gametype.integer == GT_SIEGE && d_siegeSeekerNPC.integer != 0 {
        //actualy spawn a remote NPC
        let remote = NPC_SpawnType(ent, "remote", nil, false)
        if remote != nil && remote!.client != nil {
            //set it to my team
            remote!.r.ownerNum = ent.s.number
            remote!.s.owner = remote!.r.ownerNum
            remote!.activator = ent
            if ent.client!.sess.sessionTeam == TEAM_BLUE {
                remote!.client!.playerTeam = NPCTEAM_PLAYER
            } else if ent.client!.sess.sessionTeam == TEAM_RED {
                remote!.client!.playerTeam = NPCTEAM_ENEMY
            } else {
                remote!.client!.playerTeam = NPCTEAM_NEUTRAL
            }
        }
    } else {
        ent.client!.ps.eFlags |= EF_SEEKERDRONE
        ent.client!.ps.droneExistTime = Float(level.time + 30000)
        ent.client!.ps.droneFireTime = Float(level.time + 1500)
    }
}

/// Source: oracle/codemp/game/g_items.c:1127
private func MedPackGive(_ ent: Entity, _ amount: Int32) {
    if ent.client == nil {
        return
    }

    if ent.health <= 0 || ent.client!.ps.stats[STAT_HEALTH] <= 0 || (ent.client!.ps.eFlags & EF_DEAD) != 0 {
        return
    }

    if ent.health >= ent.client!.ps.stats[STAT_MAX_HEALTH] {
        return
    }

    ent.health += amount

    if ent.health > ent.client!.ps.stats[STAT_MAX_HEALTH] {
        ent.health = ent.client!.ps.stats[STAT_MAX_HEALTH]
    }
}

/// Source: oracle/codemp/game/g_items.c:1154
func ItemUse_MedPack_Big(_ ent: Entity) {
    MedPackGive(ent, MAX_MEDPACK_BIG_HEAL_AMOUNT)
}

/// Source: oracle/codemp/game/g_items.c:1159
func ItemUse_MedPack(_ ent: Entity) {
    MedPackGive(ent, MAX_MEDPACK_HEAL_AMOUNT)
}

/// Source: oracle/codemp/game/g_items.c:1165
func Jetpack_Off(_ ent: Entity) {
    //create effects?

    if !ent.client!.jetPackOn {
        //aready off
        return
    }

    ent.client!.jetPackOn = false
}

/// Source: oracle/codemp/game/g_items.c:1177
func Jetpack_On(_ ent: Entity) {
    //create effects?

    if ent.client!.jetPackOn {
        //aready on
        return
    }

    if ent.client!.ps.fd.forceGripBeingGripped >= level.time {
        //can't turn on during grip interval
        return
    }

    if ent.client!.ps.fallingToDeath != 0 {
        //too late!
        return
    }

    G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/boba/JETON"))

    ent.client!.jetPackOn = true
}

/// Source: oracle/codemp/game/g_items.c:1201
func ItemUse_Jetpack(_ ent: Entity) {
    if ent.client!.jetPackToggleTime >= level.time {
        return
    }

    if ent.health <= 0 || ent.client!.ps.stats[STAT_HEALTH] <= 0 || (ent.client!.ps.eFlags & EF_DEAD) != 0 || ent.client!.ps.pm_type == PM_DEAD {
        //can't use it when dead under any circumstances.
        return
    }

    if !ent.client!.jetPackOn && ent.client!.ps.jetpackFuel < 5 {
        //too low on fuel to start it up
        return
    }

    if ent.client!.jetPackOn {
        Jetpack_Off(ent)
    } else {
        Jetpack_On(ent)
    }

    ent.client!.jetPackToggleTime = level.time + JETPACK_TOGGLE_TIME
}

/// Source: oracle/codemp/game/g_items.c:1239
func ItemUse_UseCloak(_ ent: Entity) {
    if ent.client!.cloakToggleTime >= level.time {
        return
    }

    if ent.health <= 0 || ent.client!.ps.stats[STAT_HEALTH] <= 0 || (ent.client!.ps.eFlags & EF_DEAD) != 0 || ent.client!.ps.pm_type == PM_DEAD {
        //can't use it when dead under any circumstances.
        return
    }

    if ent.client!.ps.powerups[PW_CLOAKED] == 0 && ent.client!.ps.cloakFuel < 5 {
        //too low on fuel to start it up
        return
    }

    if ent.client!.ps.powerups[PW_CLOAKED] != 0 {
        //decloak
        Jedi_Decloak(ent)
    } else {
        //cloak
        Jedi_Cloak(ent)
    }

    ent.client!.cloakToggleTime = level.time + CLOAK_TOGGLE_TIME
}

/// Source: oracle/codemp/game/g_items.c:1277
func SpecialItemThink(_ ent: Entity) {
    let gravity: Float = 3.0
    let mass: Float = 0.09
    let bounce: Float = 1.1

    if ent.genericValue5 < level.time {
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
        return
    }

    G_RunExPhys(ent, gravity, mass, bounce, false, nil, 0)
    ent.s.origin = ent.r.currentOrigin
    ent.nextthink = level.time + 50
}

/// Source: oracle/codemp/game/g_items.c:1295
func G_SpecialSpawnItem(_ ent: Entity, _ item: JKAMP.Gitem) {
    RegisterItem(item)
    ent.item = item

    //go away if no one wants me
    ent.genericValue5 = level.time + TOSSED_ITEM_STAY_PERIOD
    ent.think = Think.SpecialItemThink
    ent.nextthink = level.time + 50
    ent.clipmask = MASK_SOLID

    ent.physicsBounce = 0.50 // items are bouncy
    ent.r.mins = vec3_t(-8, -8, -0)
    ent.r.maxs = vec3_t(8, 8, 16)

    ent.s.eType = ET_ITEM
    ent.s.modelindex = bg_itemlist.index(of: ent.item!) // store item number in modelindex

    ent.r.contents = CONTENTS_TRIGGER
    ent.touch = Touch.Touch_Item

    //can't touch owner for x seconds
    ent.genericValue11 = ent.r.ownerNum
    ent.genericValue10 = level.time + TOSSED_ITEM_OWNER_NOTOUCH_DUR

    //so we know to remove when picked up, not respawn
    ent.genericValue9 = 1

    //kind of a lame value to use, but oh well. This means don't
    //pick up this item clientside with prediction, because we
    //aren't sending over all the data necessary for the player
    //to know if he can.
    ent.s.brokenLimbs = 1

    //since it uses my server-only physics
    ent.s.eFlags |= EF_CLIENTSMOOTH
}

/// Source: oracle/codemp/game/g_items.c:1336
func G_PrecacheDispensers() {
    var item: Gitem?

    item = BG_FindItem(DISP_HEALTH_ITEM)
    if item != nil {
        RegisterItem(item!)
    }

    item = BG_FindItem(DISP_AMMO_ITEM)
    if item != nil {
        RegisterItem(item!)
    }
}

/// Source: oracle/codemp/game/g_items.c:1353
func ItemUse_UseDisp(_ ent: Entity, _ type: Int32) {
    var item: Gitem? = nil
    var eItem: Entity?

    if ent.client == nil || ent.client!.tossableItemDebounce > level.time {
        //can't use it again yet
        return
    }

    if ent.client!.ps.weaponTime > 0 || ent.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        //busy doing something else
        return
    }

    ent.client!.tossableItemDebounce = level.time + TOSS_DEBOUNCE_TIME

    if type == HI_HEALTHDISP {
        item = BG_FindItem(DISP_HEALTH_ITEM)
    } else {
        item = BG_FindItem(DISP_AMMO_ITEM)
    }

    if item != nil {
        var fwd = vec3_t()
        var pos = vec3_t()
        var te: Entity?

        eItem = G_Spawn()
        eItem!.r.ownerNum = ent.s.number
        eItem!.classname = item!.classname

        pos = ent.client!.ps.origin
        pos[2] += ent.client!.ps.viewheight

        G_SetOrigin(eItem!, &pos)
        eItem!.s.origin = eItem!.r.currentOrigin
        trap_LinkEntity(eItem!)

        G_SpecialSpawnItem(eItem!, item!)

        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(ent.client!.ps.viewangles, &fwd, &scratchRight, &scratchUp)
        eItem!.epVelocity = fwd * 128.0
        eItem!.epVelocity[2] = 16.0

        //	G_SetAnim( ent, NULL, SETANIM_TORSO, BOTH_THERMAL_THROW, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD, 0 );

        te = G_TempEntity(ent.client!.ps.origin, EV_LOCALTIMER)
        te!.s.time = level.time
        te!.s.time2 = TOSS_DEBOUNCE_TIME
        te!.s.owner = ent.client!.ps.clientNum
    }
}

//===============================================
//Portable E-Web -rww
//===============================================
//put the e-web away/remove it from the owner
/// Source: oracle/codemp/game/g_items.c:1417
func EWebDisattach(_ owner: Entity, _ eweb: Entity) {
    owner.client!.ewebIndex = 0
    owner.client!.ps.emplacedIndex = 0
    if owner.health > 0 {
        owner.client!.ps.stats[STAT_WEAPONS] = eweb.genericValue11
    } else {
        owner.client!.ps.stats[STAT_WEAPONS] = 0
    }
    eweb.think = Think.G_FreeEntity
    eweb.nextthink = level.time
}

//precache misc e-web assets
/// Source: oracle/codemp/game/g_items.c:1434
func EWebPrecache() {
    RegisterItem(BG_FindItemForWeapon(WP_TURRET)!)
    G_EffectIndex("detpack/explosion.efx")
    G_EffectIndex("turret/muzzle_flash.efx")
}

/// Source: oracle/codemp/game/g_items.c:1449
func EWebDie(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    var fxDir = vec3_t()

    G_RadiusDamage(`self`.r.currentOrigin, `self`, Float(EWEB_DEATH_DMG), Float(EWEB_DEATH_RADIUS), `self`, `self`, MOD_SUICIDE)

    fxDir = vec3_t(1.0, 0.0, 0.0)
    G_PlayEffect(EFFECT_EXPLOSION_DETPACK, `self`.r.currentOrigin, fxDir)

    if `self`.r.ownerNum != ENTITYNUM_NONE {
        let owner: Entity? = g_entities[`self`.r.ownerNum]

        if owner!.inuse && owner!.client != nil {
            EWebDisattach(owner!, `self`)

            //make sure it resets next time we spawn one in case we someone obtain one before death
            owner!.client!.ewebHealth = -1

            //take it away from him, it is gone forever.
            owner!.client!.ps.stats[STAT_HOLDABLE_ITEMS] &= ~(1 << HI_EWEB)

            if owner!.client!.ps.stats[STAT_HOLDABLE_ITEM] > 0 && bg_itemlist[owner!.client!.ps.stats[STAT_HOLDABLE_ITEM]].giType == IT_HOLDABLE && bg_itemlist[owner!.client!.ps.stats[STAT_HOLDABLE_ITEM]].giTag == HI_EWEB {
                //he has it selected so deselect it and select the first thing available
                owner!.client!.ps.stats[STAT_HOLDABLE_ITEM] = 0
                BG_CycleInven(owner!.client!.ps, 1)
            }
        }
    }
}

//e-web pain
/// Source: oracle/codemp/game/g_items.c:1484
func EWebPain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    //update the owner's health status of me
    if `self`.r.ownerNum != ENTITYNUM_NONE {
        let owner: Entity? = g_entities[`self`.r.ownerNum]

        if owner!.inuse && owner!.client != nil {
            owner!.client!.ewebHealth = `self`.health
        }
    }
}

//special routine for tracking angles between client and server
/// Source: oracle/codemp/game/g_items.c:1499
func EWeb_SetBoneAngles(_ ent: Entity, _ bone: String, _ angles: JKAShared.vec3_t) {
    var thebone: Int32? = 0
    var firstFree: Int32? = nil
    var i: Int32 = 0
    let boneIndex: Int32 = G_BoneIndex(bone)
    let flags: Int32
    let up: Int32
    let right: Int32
    let forward: Int32
    var boneVector: Int32? = 0
    var freeBoneVec: Int32? = nil

    while thebone != nil {
        if ent.s.boneIndexSlots[thebone!] == 0 && firstFree == nil {
            //if the value is 0 then this index is clear, we can use it if we don't find the bone we want already existing.
            firstFree = thebone
            freeBoneVec = boneVector
        } else if ent.s.boneIndexSlots[thebone!] != 0 {
            if ent.s.boneIndexSlots[thebone!] == boneIndex {
                //this is it
                break
            }
        }

        switch i {
        case 0:
            thebone = 1
            boneVector = 1
        case 1:
            thebone = 2
            boneVector = 2
        case 2:
            thebone = 3
            boneVector = 3
        default:
            thebone = nil
            boneVector = nil
        }

        i += 1
    }

    if thebone == nil {
        //didn't find it, create it
        if firstFree == nil {
            //no free bones.. can't do a thing then.
            Com_Printf("WARNING: E-Web has no free bone indexes\n")
            return
        }

        thebone = firstFree

        ent.s.boneIndexSlots[thebone!] = boneIndex
        boneVector = freeBoneVec
    }

    //If we got here then we have a vector and an index.

    //Copy the angles over the vector in the entitystate, so we can use the corresponding index
    //to set the bone angles on the client.
    ent.s.boneAnglesSlots[boneVector!] = angles

    //Now set the angles on our server instance if we have one.

    if ent.ghoul2 == nil {
        return
    }

    flags = BONE_ANGLES_POSTMULT
    up = POSITIVE_Y
    right = NEGATIVE_Z
    forward = NEGATIVE_X

    //first 3 bits is forward, second 3 bits is right, third 3 bits is up
    ent.s.boneOrient = ((forward) | (right << 3) | (up << 6))

    trap_G2API_SetBoneAngles(ent.ghoul2, 0, bone, angles, flags, up, right, forward, nil, 100, level.time)
}

//start an animation on model_root both server side and client side
/// Source: oracle/codemp/game/g_items.c:1601
func EWeb_SetBoneAnim(_ eweb: Entity, _ startFrame: Int32, _ endFrame: Int32) {
    //set info on the entity so it knows to start the anim on the client next snapshot.
    eweb.s.eFlags |= EF_G2ANIMATING

    if eweb.s.torsoAnim == startFrame && eweb.s.legsAnim == endFrame {
        //already playing this anim, let's flag it to restart
        eweb.s.torsoFlip = !eweb.s.torsoFlip
    } else {
        eweb.s.torsoAnim = startFrame
        eweb.s.legsAnim = endFrame
    }

    //now set the animation on the server ghoul2 instance.
    trap_G2API_SetBoneAnim(eweb.ghoul2, 0, "model_root", startFrame, endFrame, (BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND), 1.0, level.time, -1, 100)
}

/// Source: oracle/codemp/game/g_items.c:1624
func EWebFire(_ owner: Entity, _ eweb: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var missile: Entity?
        var p = vec3_t()
        var d = vec3_t()
        var bPoint = vec3_t()

        if eweb.genericValue10 == -1 {
            //oh no
            return true
        }

        //get the muzzle point
        trap_G2API_GetBoltMatrix(eweb.ghoul2, 0, eweb.genericValue10, boltMatrix, eweb.s.apos.trBase, eweb.r.currentOrigin, level.time, nil, &eweb.modelScale)
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &p)
        BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &d)

        //Start the thing backwards into the bounding box so it can't start inside other solid things
        _VectorMA(p, -16.0, d, &bPoint)

        //create the missile
        missile = CreateMissile(&bPoint, d, 1200.0, 10000, owner, false)

        missile!.classname = "generic_proj"
        missile!.s.weapon = WP_TURRET

        missile!.damage = EWEB_MISSILE_DAMAGE
        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.methodOfDeath = MOD_TURBLAST
        missile!.clipmask = (MASK_SHOT | CONTENTS_LIGHTSABER)

        //ignore the e-web entity
        missile!.passThroughNum = eweb.s.number + 1

        //times it can bounce before it dies
        missile!.bounceCount = 8

        //play the muzzle flash
        vectoangles(d, &d)
        G_PlayEffectID(G_EffectIndex("turret/muzzle_flash.efx"), p, d)
        return false
    }
    if earlyOut {
        return
    }
}

//lock the owner into place relative to the cannon pos
/// Source: oracle/codemp/game/g_items.c:1667
func EWebPositionUser(_ owner: Entity, _ eweb: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        var p = vec3_t()
        var d = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        Trace.scratch { tr in

            trap_G2API_GetBoltMatrix(eweb.ghoul2, 0, eweb.genericValue9, boltMatrix, eweb.s.apos.trBase, eweb.r.currentOrigin, level.time, nil, &eweb.modelScale)
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &p)
            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_X, &d)

            _VectorMA(p, 32.0, d, &p)
            p[2] = eweb.r.currentOrigin[2]

            p[2] += 4.0

            trap_Trace(tr, owner.client!.ps.origin, owner.r.mins, owner.r.maxs, p, owner.s.number, MASK_PLAYERSOLID)

            if tr.startsolid == 0 && tr.allsolid == 0 && tr.fraction == 1.0 {
                //all clear, we can move there
                var pDown = vec3_t()

                pDown = p
                pDown[2] -= 7.0
                trap_Trace(tr, p, owner.r.mins, owner.r.maxs, pDown, owner.s.number, MASK_PLAYERSOLID)

                if tr.startsolid == 0 && tr.allsolid == 0 {
                    d = owner.client!.ps.origin - tr.endpos
                    if VectorLength(d) > 1.0 {
                        //we moved, do some animating
                        var dAng = vec3_t()
                        var aFlags: Int32 = SETANIM_FLAG_HOLD

                        vectoangles(d, &dAng)
                        dAng[YAW] = AngleSubtract(owner.client!.ps.viewangles[YAW], dAng[YAW])
                        if dAng[YAW] > 0.0 {
                            if owner.client!.ps.legsAnim == BOTH_STRAFE_RIGHT1 {
                                //reset to change direction
                                aFlags |= SETANIM_FLAG_OVERRIDE
                            }
                            G_SetAnim(owner, owner.client!.pers.cmd, SETANIM_LEGS, BOTH_STRAFE_LEFT1, aFlags, 0)
                        } else {
                            if owner.client!.ps.legsAnim == BOTH_STRAFE_LEFT1 {
                                //reset to change direction
                                aFlags |= SETANIM_FLAG_OVERRIDE
                            }
                            G_SetAnim(owner, owner.client!.pers.cmd, SETANIM_LEGS, BOTH_STRAFE_RIGHT1, aFlags, 0)
                        }
                    } else if owner.client!.ps.legsAnim == BOTH_STRAFE_RIGHT1 || owner.client!.ps.legsAnim == BOTH_STRAFE_LEFT1 {
                        //don't keep animating in place
                        owner.client!.ps.legsTimer = 0
                    }

                    G_SetOrigin(owner, &tr.endpos)
                    owner.client!.ps.origin = tr.endpos
                }
            } else {
                //can't move here.. stop using the thing I guess
                EWebDisattach(owner, eweb)
            }
        }
    }
}

//keep the bone angles updated based on the owner's look dir
/// Source: oracle/codemp/game/g_items.c:1735
func EWebUpdateBoneAngles(_ owner: Entity, _ eweb: Entity) {
    var yAng = vec3_t()
    let ideal: Float
    var incr: Float
    let turnCap: Float = 4.0

    yAng = vec3_t()
    ideal = AngleSubtract(owner.client!.ps.viewangles[YAW], eweb.s.angles[YAW])
    incr = AngleSubtract(ideal, eweb.angle)

    if incr > turnCap {
        incr = turnCap
    } else if incr < -turnCap {
        incr = -turnCap
    }

    eweb.angle += incr

    yAng[0] = eweb.angle
    EWeb_SetBoneAngles(eweb, "cannon_Yrot", yAng)

    EWebPositionUser(owner, eweb)
    if owner.client!.ewebIndex == 0 {
        //was removed during position function
        return
    }

    yAng = vec3_t()
    yAng[2] = AngleSubtract(owner.client!.ps.viewangles[PITCH], eweb.s.angles[PITCH]) * 0.8
    EWeb_SetBoneAngles(eweb, "cannon_Xrot", yAng)
}

/// Source: oracle/codemp/game/g_items.c:1776
func EWebThink(_ `self`: Entity) {
    var killMe: Bool = false
    let gravity: Float = 3.0
    let mass: Float = 0.09
    let bounce: Float = 1.1

    if `self`.r.ownerNum == ENTITYNUM_NONE {
        killMe = true
    } else {
        let owner: Entity? = g_entities[`self`.r.ownerNum]

        if !owner!.inuse || owner!.client == nil || owner!.client!.pers.connected != CON_CONNECTED || owner!.client!.ewebIndex != `self`.s.number || owner!.health < 1 {
            killMe = true
        } else if owner!.client!.ps.emplacedIndex != `self`.s.number {
            //just go back to the inventory then
            EWebDisattach(owner!, `self`)
            return
        }

        if !killMe {
            var yaw: Float = 0

            if BG_EmplacedView(&owner!.client!.ps.viewangles, &`self`.s.angles, &yaw, `self`.s.origin2[0]) != 0 {
                owner!.client!.ps.viewangles[YAW] = yaw
            }
            owner!.client!.ps.weapon = WP_EMPLACED_GUN
            owner!.client!.ps.stats[STAT_WEAPONS] = WP_EMPLACED_GUN

            if `self`.genericValue8 < level.time {
                //make sure the anim timer is done
                EWebUpdateBoneAngles(owner!, `self`)
                if owner!.client!.ewebIndex == 0 {
                    //was removed during position function
                    return
                }

                if (owner!.client!.pers.cmd.buttons & BUTTON_ATTACK) != 0 {
                    if `self`.genericValue5 < level.time {
                        //we can fire another shot off
                        EWebFire(owner!, `self`)

                        //cheap firing anim
                        EWeb_SetBoneAnim(`self`, 2, 4)
                        `self`.genericValue3 = 1

                        //set fire debounce time
                        `self`.genericValue5 = level.time + 100
                    }
                } else if `self`.genericValue5 < level.time && `self`.genericValue3 != 0 {
                    //reset the anim back to non-firing
                    EWeb_SetBoneAnim(`self`, 0, 1)
                    `self`.genericValue3 = 0
                }
            }
        }
    }

    if killMe {
        //something happened to the owner, let's explode
        EWebDie(`self`, `self`, `self`, 999, MOD_SUICIDE)
        return
    }

    //run some physics on it real quick so it falls and stuff properly
    G_RunExPhys(`self`, gravity, mass, bounce, false, nil, 0)

    `self`.nextthink = level.time
}

//spawn and set up an e-web ent
/// Source: oracle/codemp/game/g_items.c:1859
func EWeb_Create(_ spawner: Entity) -> Entity? {
    let modelName: String = "models/map_objects/hoth/eweb_model.glm"
    let failSound: Int32 = G_SoundIndex("sound/interface/shieldcon_empty")
    var ent: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Entity? in
        var fAng = vec3_t()
        var fwd = vec3_t()
        var pos = vec3_t()
        var downPos = vec3_t()
        var s = vec3_t()
        var mins = vec3_t()
        var maxs = vec3_t()

        mins = vec3_t(-32, -32, -24)
        maxs = vec3_t(32, 32, 24)

        fAng = vec3_t(0, spawner.client!.ps.viewangles[1], 0)
        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(fAng, &fwd, &scratchRight, &scratchUp)

        s = spawner.client!.ps.origin
        //allow some fudge
        s[2] += 12.0

        _VectorMA(s, 48.0, fwd, &pos)

        trap_Trace(tr, s, mins, maxs, pos, spawner.s.number, MASK_PLAYERSOLID)

        if tr.allsolid != 0 || tr.startsolid != 0 || tr.fraction != 1.0 {
            //can't spawn here, we are in solid
            G_Sound(spawner, CHAN_AUTO, failSound)
            return nil
        }

        ent = G_Spawn()

        ent!.clipmask = MASK_PLAYERSOLID
        ent!.r.contents = MASK_PLAYERSOLID

        ent!.physicsObject = true

        //for the sake of being able to differentiate client-side between this and an emplaced gun
        ent!.s.weapon = WP_NONE

        downPos = pos
        downPos[2] -= 18.0
        trap_Trace(tr, pos, mins, maxs, downPos, spawner.s.number, MASK_PLAYERSOLID)

        if tr.startsolid != 0 || tr.allsolid != 0 || tr.fraction == 1.0 || tr.entityNum < ENTITYNUM_WORLD {
            //didn't hit ground.
            G_FreeEntity(ent!)
            G_Sound(spawner, CHAN_AUTO, failSound)
            return nil
        }

        pos = tr.endpos

        G_SetOrigin(ent!, &pos)

        ent!.s.apos.trBase = fAng
        ent!.r.currentAngles = fAng

        ent!.s.owner = spawner.s.number
        ent!.s.teamowner = spawner.client!.sess.sessionTeam

        ent!.takedamage = true

        if spawner.client!.ewebHealth <= 0 {
            //refresh the owner's e-web health if its last e-web did not exist or was killed
            spawner.client!.ewebHealth = EWEB_HEALTH
        }

        //resume health of last deployment
        ent!.maxHealth = EWEB_HEALTH
        ent!.health = spawner.client!.ewebHealth
        G_ScaleNetHealth(ent!)

        ent!.die = Die.EWebDie
        ent!.pain = Pain.EWebPain

        ent!.think = Think.EWebThink
        ent!.nextthink = level.time

        //set up the g2 model info
        ent!.s.modelGhoul2 = 1
        ent!.s.g2radius = 128
        ent!.s.modelindex = G_ModelIndex(modelName)

        trap_G2API_InitGhoul2Model(&ent!.ghoul2, modelName, 0, 0, 0, 0, 0)

        if ent!.ghoul2 == nil {
            //should not happen, but just to be safe.
            G_FreeEntity(ent!)
            return nil
        }

        //initialize bone angles
        EWeb_SetBoneAngles(ent!, "cannon_Yrot", vec3_origin)
        EWeb_SetBoneAngles(ent!, "cannon_Xrot", vec3_origin)

        ent!.genericValue10 = trap_G2API_AddBolt(ent!.ghoul2, 0, "*cannonflash") //muzzle bolt
        ent!.genericValue9 = trap_G2API_AddBolt(ent!.ghoul2, 0, "cannon_Yrot") //for placing the owner relative to rotation

        //set the constraints for this guy as an emplaced weapon, and his constraint angles
        ent!.s.origin2[0] = 360.0 //360 degrees in either direction

        ent!.s.angles = fAng //consider "angle 0" for constraint

        //angle of y rot bone
        ent!.angle = 0.0

        ent!.r.ownerNum = spawner.s.number
        trap_LinkEntity(ent!)

        //store off the owner's current weapons, we will be forcing him to use the "emplaced" weapon
        ent!.genericValue11 = spawner.client!.ps.stats[STAT_WEAPONS]

        //start the "unfolding" anim
        EWeb_SetBoneAnim(ent!, 4, 20)
        //don't allow use until the anim is done playing (rough time estimate)
        ent!.genericValue8 = level.time + 500

        ent!.r.mins = mins
        ent!.r.maxs = maxs

        return ent
    }
}

//use the e-web
/// Source: oracle/codemp/game/g_items.c:1984
func ItemUse_UseEWeb(_ ent: Entity) {
    if ent.client!.ewebTime > level.time {
        //can't use again yet
        return
    }

    if ent.client!.ps.weaponTime > 0 || ent.client!.ps.forceHandExtend != HANDEXTEND_NONE {
        //busy doing something else
        return
    }

    if ent.client!.ps.emplacedIndex != 0 && ent.client!.ewebIndex == 0 {
        //using an emplaced gun already that isn't our own e-web
        return
    }

    if ent.client!.ewebIndex != 0 {
        //put it away
        EWebDisattach(ent, g_entities[ent.client!.ewebIndex])
    } else {
        //create it
        let eweb: Entity? = EWeb_Create(ent)

        if eweb != nil {
            //if it's null the thing couldn't spawn (probably no room)
            ent.client!.ewebIndex = eweb!.s.number
            ent.client!.ps.emplacedIndex = eweb!.s.number
        }
    }

    ent.client!.ewebTime = level.time + EWEB_USE_DEBOUNCE
}

/// Source: oracle/codemp/game/g_items.c:2024
func Pickup_Powerup(_ ent: Entity, _ other: Entity) -> Int32 {
    var quantity: Int32 = 0
    var i: Int32 = 0
    var client: Client?

    if other.client!.ps.powerups[ent.item!.giTag] == 0 {
        // round timing to seconds to make multiple powerup timers
        // count in sync
        other.client!.ps.powerups[ent.item!.giTag] = level.time - (level.time % 1000)

        G_LogWeaponPowerup(other.s.number, ent.item!.giTag)
    }

    if ent.count != 0 {
        quantity = ent.count
    } else {
        quantity = ent.item!.quantity
    }

    other.client!.ps.powerups[ent.item!.giTag] += quantity * 1000

    if ent.item!.giTag == PW_YSALAMIRI {
        other.client!.ps.powerups[PW_FORCE_ENLIGHTENED_LIGHT] = 0
        other.client!.ps.powerups[PW_FORCE_ENLIGHTENED_DARK] = 0
        other.client!.ps.powerups[PW_FORCE_BOON] = 0
    }

    // give any nearby players a "denied" anti-reward
    i = 0
    while i < level.maxclients {
        Trace.scratch { tr in
            var delta = vec3_t()
            let len: Float
            var forward = vec3_t()

            client = level.clientsSlots[i]
            if client == other.client {
                return
            }
            if client!.pers.connected == CON_DISCONNECTED {
                return
            }
            if client!.ps.stats[STAT_HEALTH] <= 0 {
                return
            }

            // if same team in team game, no sound
            // cannot use OnSameTeam as it expects to g_entities, not clients
            if g_gametype.integer >= GT_TEAM && other.client!.sess.sessionTeam == client!.sess.sessionTeam {
                return
            }

            // if too far away, no sound
            delta = ent.s.pos.trBase - client!.ps.origin
            len = VectorNormalize(&delta)
            if len > 192 {
                return
            }

            // if not facing, no sound
            // Raven passes NULL for the right and up outputs.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(client!.ps.viewangles, &forward, &scratchRight, &scratchUp)
            if Double(_DotProduct(delta, forward)) < 0.4 {
                return
            }

            // if not line of sight, no sound
            trap_Trace(tr, client!.ps.origin, vec3_origin, vec3_origin, ent.s.pos.trBase, ENTITYNUM_NONE, CONTENTS_SOLID)
            if tr.fraction != 1.0 {
                return
            }

            // anti-reward
            client!.ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_DENIEDREWARD
        }
        i += 1
    }
    return RESPAWN_POWERUP
}

/// Source: oracle/codemp/game/g_items.c:2104
func Pickup_Holdable(_ ent: Entity, _ other: Entity) -> Int32 {
    other.client!.ps.stats[STAT_HOLDABLE_ITEM] = bg_itemlist.index(of: ent.item!)

    other.client!.ps.stats[STAT_HOLDABLE_ITEMS] |= (1 << ent.item!.giTag)

    G_LogWeaponItem(other.s.number, ent.item!.giTag)

    return adjustRespawnTime(Float(RESPAWN_HOLDABLE), ent.item!.giType, ent.item!.giTag)
}

/// Source: oracle/codemp/game/g_items.c:2118
func Add_Ammo(_ ent: Entity, _ weapon: Int32, _ count: Int32) {
    if ent.client!.ps.ammo[weapon] < ammoData[weapon].max {
        ent.client!.ps.ammo[weapon] += count
        if ent.client!.ps.ammo[weapon] > ammoData[weapon].max {
            ent.client!.ps.ammo[weapon] = ammoData[weapon].max
        }
    }
}

/// Source: oracle/codemp/game/g_items.c:2130
func Pickup_Ammo(_ ent: Entity, _ other: Entity) -> Int32 {
    let quantity: Int32

    if ent.count != 0 {
        quantity = ent.count
    } else {
        quantity = ent.item!.quantity
    }

    if ent.item!.giTag == -1 {
        //an ammo_all, give them a bit of everything
        if g_gametype.integer == GT_SIEGE {
            Add_Ammo(other, AMMO_BLASTER, 100)
            Add_Ammo(other, AMMO_POWERCELL, 100)
            Add_Ammo(other, AMMO_METAL_BOLTS, 100)
            Add_Ammo(other, AMMO_ROCKETS, 5)
            if (other.client!.ps.stats[STAT_WEAPONS] & (1 << WP_DET_PACK)) != 0 {
                Add_Ammo(other, AMMO_DETPACK, 2)
            }
            if (other.client!.ps.stats[STAT_WEAPONS] & (1 << WP_THERMAL)) != 0 {
                Add_Ammo(other, AMMO_THERMAL, 2)
            }
            if (other.client!.ps.stats[STAT_WEAPONS] & (1 << WP_TRIP_MINE)) != 0 {
                Add_Ammo(other, AMMO_TRIPMINE, 2)
            }
        } else {
            Add_Ammo(other, AMMO_BLASTER, 50)
            Add_Ammo(other, AMMO_POWERCELL, 50)
            Add_Ammo(other, AMMO_METAL_BOLTS, 50)
            Add_Ammo(other, AMMO_ROCKETS, 2)
        }
    } else {
        Add_Ammo(other, ent.item!.giTag, quantity)
    }

    return adjustRespawnTime(Float(RESPAWN_AMMO), ent.item!.giType, ent.item!.giTag)
}

/// Source: oracle/codemp/game/g_items.c:2180
func Pickup_Weapon(_ ent: Entity, _ other: Entity) -> Int32 {
    var quantity: Int32

    if ent.count < 0 {
        quantity = 0 // None for you, sir!
    } else {
        if ent.count != 0 {
            quantity = ent.count
        } else {
            quantity = ent.item!.quantity
        }

        // dropped items and teamplay weapons always have full ammo
        if !((ent.flags & FL_DROPPED_ITEM) != 0) && g_gametype.integer != GT_TEAM {
            // respawning rules

            // New method:  If the player has less than half the minimum, give them the minimum, else add 1/2 the min.

            // drop the quantity if the already have over the minimum
            if Double(other.client!.ps.ammo[ent.item!.giTag]) < Double(quantity) * 0.5 {
                quantity = quantity - other.client!.ps.ammo[ent.item!.giTag]
            } else {
                quantity = Int32(Double(quantity) * 0.5) // only add half the value.
            }

            // Old method:  If the player has less than the minimum, give them the minimum, else just add 1.
            /*
            // drop the quantity if the already have over the minimum
            if ( other->client->ps.ammo[ ent->item->giTag ] < quantity ) {
            quantity = quantity - other->client->ps.ammo[ ent->item->giTag ];
            } else {
            quantity = 1;		// only add a single shot
            }
            */
        }
    }

    // add the weapon
    other.client!.ps.stats[STAT_WEAPONS] |= (1 << ent.item!.giTag)

    //Add_Ammo( other, ent->item->giTag, quantity );
    Add_Ammo(other, weaponData[ent.item!.giTag].ammoIndex, quantity)

    G_LogWeaponPickup(other.s.number, ent.item!.giTag)

    // team deathmatch has slow weapon respawns
    if g_gametype.integer == GT_TEAM {
        return adjustRespawnTime(Float(RESPAWN_TEAM_WEAPON), ent.item!.giType, ent.item!.giTag)
    }

    return adjustRespawnTime(Float(g_weaponRespawn.integer), ent.item!.giType, ent.item!.giTag)
}

/// Source: oracle/codemp/game/g_items.c:2237
func Pickup_Health(_ ent: Entity, _ other: Entity) -> Int32 {
    let max: Int32
    let quantity: Int32

    // small and mega healths will go over the max
    if ent.item!.quantity != 5 && ent.item!.quantity != 100 {
        max = other.client!.ps.stats[STAT_MAX_HEALTH]
    } else {
        max = other.client!.ps.stats[STAT_MAX_HEALTH] * 2
    }

    if ent.count != 0 {
        quantity = ent.count
    } else {
        quantity = ent.item!.quantity
    }

    other.health += quantity

    if other.health > max {
        other.health = max
    }
    other.client!.ps.stats[STAT_HEALTH] = other.health

    if ent.item!.quantity == 100 {
        // mega health respawns slow
        return RESPAWN_MEGAHEALTH
    }

    return adjustRespawnTime(Float(RESPAWN_HEALTH), ent.item!.giType, ent.item!.giTag)
}

/// Source: oracle/codemp/game/g_items.c:2270
func Pickup_Armor(_ ent: Entity, _ other: Entity) -> Int32 {
    other.client!.ps.stats[STAT_ARMOR] += ent.item!.quantity
    if other.client!.ps.stats[STAT_ARMOR] > other.client!.ps.stats[STAT_MAX_HEALTH] * ent.item!.giTag {
        other.client!.ps.stats[STAT_ARMOR] = other.client!.ps.stats[STAT_MAX_HEALTH] * ent.item!.giTag
    }

    return adjustRespawnTime(Float(RESPAWN_ARMOR), ent.item!.giType, ent.item!.giTag)
}

/**
```
===============
RespawnItem
===============
```
*/
/// Source: oracle/codemp/game/g_items.c:2288
func RespawnItem(_ ent: Entity) {
    // Raven assigns his own `ent` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var ent = ent
    // randomly select from teamed entities
    if ent.team != nil {
        var master: Entity?
        var count: Int32
        let choice: Int32

        if ent.teammaster == nil {
            G_Error("RespawnItem: bad teammaster")
        }
        master = ent.teammaster

        count = 0
        var entWalk: Entity? = master
        while entWalk != nil {
            entWalk = entWalk!.teamchain
            count += 1
        }

        // The SDK also declares `rand`, so the call names the bg module.
        choice = JKAMP_BG.rand() % count

        count = 0
        ent = master!
        while count < choice {
            ent = ent.teamchain!
            count += 1
        }
    }

    ent.r.contents = CONTENTS_TRIGGER
    //ent->s.eFlags &= ~EF_NODRAW;
    ent.s.eFlags &= ~(EF_NODRAW | EF_ITEMPLACEHOLDER)
    ent.r.svFlags &= ~SVF_NOCLIENT
    trap_LinkEntity(ent)

    if ent.item!.giType == IT_POWERUP {
        // play powerup spawn sound to all clients
        var te: Entity?

        // if the powerup respawn sound should Not be global
        if ent.speed != 0 {
            te = G_TempEntity(ent.s.pos.trBase, EV_GENERAL_SOUND)
        } else {
            te = G_TempEntity(ent.s.pos.trBase, EV_GLOBAL_SOUND)
        }
        te!.s.eventParm = G_SoundIndex("sound/items/respawn1")
        te!.r.svFlags |= SVF_BROADCAST
    }

    // play the normal respawn sound only to nearby clients
    G_AddEvent(ent, EV_ITEM_RESPAWN, 0)

    ent.nextthink = 0
}

/// Source: oracle/codemp/game/g_items.c:2336
func CheckItemCanBePickedUpByNPC(_ item: Entity, _ pickerupper: Entity) -> Bool {
    if (item.flags & FL_DROPPED_ITEM) != 0 && item.activator != g_entities[0] && pickerupper.s.number != 0 && pickerupper.s.weapon == WP_NONE && pickerupper.enemy != nil && pickerupper.painDebounceTime < level.time && pickerupper.NPC != nil && pickerupper.NPC!.surrenderTime < level.time && !((pickerupper.NPC!.scriptFlags & SCF_FORCED_MARCH) != 0) {
        //non-player, in combat, picking up a dropped item that does NOT belong to the player and it *not* a security key
        if level.time - item.s.time < 3000 {
            return false
        }
        return true
    }
    return false
}

/**
```
===============
Touch_Item
===============
```
*/
/// Source: oracle/codemp/game/g_items.c:2362
func Touch_Item(_ ent: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    var respawn: Int32
    var predict: Bool

    if ent.genericValue10 > level.time && other.s.number == ent.genericValue11 {
        //this is the ent that we don't want to be able to touch us for x seconds
        return
    }

    if (ent.s.eFlags & EF_ITEMPLACEHOLDER) != 0 {
        return
    }

    if (ent.s.eFlags & EF_NODRAW) != 0 {
        return
    }

    if ent.item!.giType == IT_WEAPON && ent.s.powerups != 0 && ent.s.powerups < level.time {
        ent.s.generic1 = 0
        ent.s.powerups = 0
    }

    if other.client == nil {
        return
    }
    if other.health < 1 {
        return // dead people can't pickup
    }

    if ent.item!.giType == IT_POWERUP && (ent.item!.giTag == PW_FORCE_ENLIGHTENED_LIGHT || ent.item!.giTag == PW_FORCE_ENLIGHTENED_DARK) {
        if ent.item!.giTag == PW_FORCE_ENLIGHTENED_LIGHT {
            if other.client!.ps.fd.forceSide != FORCE_LIGHTSIDE {
                return
            }
        } else {
            if other.client!.ps.fd.forceSide != FORCE_DARKSIDE {
                return
            }
        }
    }

    // the same pickup rules are used for client side and server side
    if !BG_CanItemBeGrabbed(g_gametype.integer, ent.s, other.client!.ps) {
        return
    }


    if other.client!.NPC_class == CLASS_ATST || other.client!.NPC_class == CLASS_GONK || other.client!.NPC_class == CLASS_MARK1 || other.client!.NPC_class == CLASS_MARK2 || other.client!.NPC_class == CLASS_MOUSE || other.client!.NPC_class == CLASS_PROBE || other.client!.NPC_class == CLASS_PROTOCOL || other.client!.NPC_class == CLASS_R2D2 || other.client!.NPC_class == CLASS_R5D2 || other.client!.NPC_class == CLASS_SEEKER || other.client!.NPC_class == CLASS_REMOTE || other.client!.NPC_class == CLASS_RANCOR || other.client!.NPC_class == CLASS_WAMPA || other.client!.NPC_class == CLASS_UGNAUGHT || other.client!.NPC_class == CLASS_SENTRY {
        //FIXME: some flag would be better
        //droids can't pick up items/weapons!
        return
    }

    if CheckItemCanBePickedUpByNPC(ent, other) {
        if other.NPC != nil && other.NPC!.goalEntity != nil && other.NPC!.goalEntity!.enemy == ent {
            //they were running to pick me up, they did, so clear goal
            other.NPC!.goalEntity = nil
            other.NPC!.squadState = SQUAD_STAND_AND_SHOOT
        }
    } else if !((ent.spawnflags & ITMSF_ALLOWNPC) != 0) {
        // NPCs cannot pick it up
        if other.s.eType == ET_NPC {
            // Not the player?
            var dontGo: Bool = false
            if ent.item!.giType == IT_AMMO && ent.item!.giTag == -1 && other.s.NPC_class == CLASS_VEHICLE && other.m_pVehicle != nil && other.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
                //yeah, uh, atst gets healed by these things
                if other.maxHealth != 0 && other.health < other.maxHealth {
                    other.health += 80
                    if other.health > other.maxHealth {
                        other.health = other.maxHealth
                    }
                    G_ScaleNetHealth(other)
                    dontGo = true
                }
            }

            if !dontGo {
                return
            }
        }
    }

    G_LogPrintf("Item: %i %s\n", other.s.number, ent.item!.classname!)

    predict = other.client!.pers.predictItemPickup

    // call the item-specific pickup function
    switch ent.item!.giType {
    case IT_WEAPON:
        respawn = Pickup_Weapon(ent, other)
        //		predict = qfalse;
        predict = true

    case IT_AMMO:
        respawn = Pickup_Ammo(ent, other)
        if ent.item!.giTag == AMMO_THERMAL || ent.item!.giTag == AMMO_TRIPMINE || ent.item!.giTag == AMMO_DETPACK {
            var weapForAmmo: Int32 = 0

            if ent.item!.giTag == AMMO_THERMAL {
                weapForAmmo = WP_THERMAL
            } else if ent.item!.giTag == AMMO_TRIPMINE {
                weapForAmmo = WP_TRIP_MINE
            } else {
                weapForAmmo = WP_DET_PACK
            }

            if other.client != nil && other.client!.ps.ammo[weaponData[weapForAmmo].ammoIndex] > 0 {
                other.client!.ps.stats[STAT_WEAPONS] |= (1 << weapForAmmo)
            }
        }
        //		predict = qfalse;
        predict = true

    case IT_ARMOR:
        respawn = Pickup_Armor(ent, other)
        //		predict = qfalse;
        predict = true

    case IT_HEALTH:
        respawn = Pickup_Health(ent, other)
        //		predict = qfalse;
        predict = true

    case IT_POWERUP:
        respawn = Pickup_Powerup(ent, other)
        predict = false

    case IT_TEAM:
        respawn = Pickup_Team(ent, other)

    case IT_HOLDABLE:
        respawn = Pickup_Holdable(ent, other)

    default:
        return
    }

    if respawn == 0 {
        return
    }

    // play the normal pickup sound
    if predict {
        if other.client != nil {
            BG_AddPredictableEventToPlayerstate(EV_ITEM_PICKUP, ent.s.number, other.client!.ps)
        } else {
            G_AddPredictableEvent(other, EV_ITEM_PICKUP, ent.s.number)
        }
    } else {
        G_AddEvent(other, EV_ITEM_PICKUP, ent.s.number)
    }

    // powerup pickups are global broadcasts
    if ent.item!.giType == IT_TEAM {
        // if we want the global sound to play
        if ent.speed == 0 {
            var te: Entity?

            te = G_TempEntity(ent.s.pos.trBase, EV_GLOBAL_ITEM_PICKUP)
            te!.s.eventParm = ent.s.modelindex
            te!.r.svFlags |= SVF_BROADCAST
        } else {
            var te: Entity?

            te = G_TempEntity(ent.s.pos.trBase, EV_GLOBAL_ITEM_PICKUP)
            te!.s.eventParm = ent.s.modelindex
            // only send this temp entity to a single client
            te!.r.svFlags |= SVF_SINGLECLIENT
            te!.r.singleClient = other.s.number
        }
    }

    // fire item targets
    G_UseTargets(ent, other)

    // wait of -1 will not respawn
    if ent.wait == -1 {
        ent.r.svFlags |= SVF_NOCLIENT
        ent.s.eFlags |= EF_NODRAW
        ent.r.contents = 0
        ent.unlinkAfterEvent = true
        return
    }

    // non zero wait overrides respawn time
    if ent.wait != 0 {
        respawn = Int32(ent.wait)
    }

    // random can be used to vary the respawn time
    if ent.random != 0 {
        respawn = Int32(respawn + crandom() * ent.random)
        if respawn < 1 {
            respawn = 1
        }
    }

    // dropped items will not respawn
    if (ent.flags & FL_DROPPED_ITEM) != 0 {
        ent.freeAfterEvent = true
    }

    // picked up items still stay around, they just don't
    // draw anything.  This allows respawnable items
    // to be placed on movers.
    if !((ent.flags & FL_DROPPED_ITEM) != 0) && (ent.item!.giType == IT_WEAPON || ent.item!.giType == IT_POWERUP) {
        ent.s.eFlags |= EF_ITEMPLACEHOLDER
        ent.s.eFlags &= ~EF_NODRAW
    } else {
        ent.s.eFlags |= EF_NODRAW
        ent.r.svFlags |= SVF_NOCLIENT
    }
    ent.r.contents = 0

    if ent.genericValue9 != 0 {
        //dropped item, should be removed when picked up
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
        return
    }

    // ZOID
    // A negative respawn times means to never respawn this item (but don't
    // delete it).  This is used by items that are respawned by third party
    // events such as ctf flags
    if respawn <= 0 {
        ent.nextthink = 0
        ent.think = nil
    } else {
        ent.nextthink = level.time + respawn * 1000
        ent.think = Think.RespawnItem
    }
    trap_LinkEntity(ent)
}

/**
```
================
LaunchItem

Spawns an item and tosses it forward
================
```
*/
/// Source: oracle/codemp/game/g_items.c:2658
func LaunchItem(_ item: JKAMP.Gitem, _ origin: inout JKAShared.vec3_t, _ velocity: JKAShared.vec3_t) -> Entity? {
    var dropped: Entity?

    dropped = G_Spawn()

    dropped!.s.eType = ET_ITEM
    dropped!.s.modelindex = bg_itemlist.index(of: item) // store item number in modelindex
    if dropped!.s.modelindex < 0 {
        dropped!.s.modelindex = 0
    }
    dropped!.s.modelindex2 = 1 // This is non-zero is it's a dropped item

    dropped!.classname = item.classname
    dropped!.item = item
    dropped!.r.mins = vec3_t(Float(-ITEM_RADIUS), Float(-ITEM_RADIUS), Float(-ITEM_RADIUS))
    dropped!.r.maxs = vec3_t(Float(ITEM_RADIUS), Float(ITEM_RADIUS), Float(ITEM_RADIUS))

    dropped!.r.contents = CONTENTS_TRIGGER

    dropped!.touch = Touch.Touch_Item

    G_SetOrigin(dropped!, &origin)
    dropped!.s.pos.trType = TR_GRAVITY
    dropped!.s.pos.trTime = level.time
    dropped!.s.pos.trDelta = velocity

    dropped!.flags |= FL_BOUNCE_HALF
    if (g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY) && item.giType == IT_TEAM {
        // Special case for CTF flags
        dropped!.think = Think.Team_DroppedFlagThink
        dropped!.nextthink = level.time + 30000
        Team_CheckDroppedItem(dropped!)

        //rww - so bots know
        if strcmp(dropped!.classname!, "team_CTF_redflag") == 0 {
            droppedRedFlag = dropped
        } else if strcmp(dropped!.classname!, "team_CTF_blueflag") == 0 {
            droppedBlueFlag = dropped
        }
    } else {
        // auto-remove after 30 seconds
        dropped!.think = Think.G_FreeEntity
        dropped!.nextthink = level.time + 30000
    }

    dropped!.flags = FL_DROPPED_ITEM

    if item.giType == IT_WEAPON || item.giType == IT_POWERUP {
        dropped!.s.eFlags |= EF_DROPPEDWEAPON
    }

    vectoangles(velocity, &dropped!.s.angles)
    dropped!.s.angles[PITCH] = 0

    if item.giTag == WP_TRIP_MINE || item.giTag == WP_DET_PACK {
        dropped!.s.angles[PITCH] = -90
    }

    if item.giTag != WP_BOWCASTER && item.giTag != WP_DET_PACK && item.giTag != WP_THERMAL {
        dropped!.s.angles[ROLL] = -90
    }

    dropped!.physicsObject = true

    trap_LinkEntity(dropped!)

    return dropped
}

/**
```
================
Drop_Item

Spawns an item and tosses it forward
================
```
*/
/// Source: oracle/codemp/game/g_items.c:2742
func Drop_Item(_ ent: Entity, _ item: JKAMP.Gitem, _ angle: Float) -> Entity? {
    var velocity = vec3_t()
    var angles = vec3_t()

    angles = ent.s.apos.trBase
    angles[YAW] += angle
    angles[PITCH] = 0 // always forward

    // Raven passes NULL for the `right` and `up` outputs.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(angles, &velocity, &scratchRight, &scratchUp)
    velocity = velocity * 150
    velocity[2] += 200 + crandom() * 50

    return LaunchItem(item, &ent.s.pos.trBase, velocity)
}

/**
```
================
Use_Item

Respawn the item
================
```
*/
/// Source: oracle/codemp/game/g_items.c:2765
func Use_Item(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    RespawnItem(ent)
}

/**
```
================
FinishSpawningItem

Traces down to find where an item should rest, instead of letting them
free fall from their spawn points
================
```
*/
/// Source: oracle/codemp/game/g_items.c:2779
func FinishSpawningItem(_ ent: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var dest = vec3_t()
        //	gitem_t		*item;

        //	VectorSet( ent->r.mins, -ITEM_RADIUS, -ITEM_RADIUS, -ITEM_RADIUS );
        //	VectorSet( ent->r.maxs, ITEM_RADIUS, ITEM_RADIUS, ITEM_RADIUS );

        if g_gametype.integer == GT_SIEGE {
            //in siege remove all powerups
            if ent.item!.giType == IT_POWERUP {
                G_FreeEntity(ent)
                return true
            }
        }

        if g_gametype.integer != GT_JEDIMASTER {
            if HasSetSaberOnly() {
                if ent.item!.giType == IT_AMMO {
                    G_FreeEntity(ent)
                    return true
                }

                if ent.item!.giType == IT_HOLDABLE {
                    if ent.item!.giTag == HI_SEEKER || ent.item!.giTag == HI_SHIELD || ent.item!.giTag == HI_SENTRY_GUN {
                        G_FreeEntity(ent)
                        return true
                    }
                }
            }
        } else {
            //no powerups in jedi master
            if ent.item!.giType == IT_POWERUP {
                G_FreeEntity(ent)
                return true
            }
        }

        if g_gametype.integer == GT_HOLOCRON {
            if ent.item!.giType == IT_POWERUP {
                if ent.item!.giTag == PW_FORCE_ENLIGHTENED_LIGHT || ent.item!.giTag == PW_FORCE_ENLIGHTENED_DARK {
                    G_FreeEntity(ent)
                    return true
                }
            }
        }

        if g_forcePowerDisable.integer != 0 {
            //if force powers disabled, don't add force powerups
            if ent.item!.giType == IT_POWERUP {
                if ent.item!.giTag == PW_FORCE_ENLIGHTENED_LIGHT || ent.item!.giTag == PW_FORCE_ENLIGHTENED_DARK || ent.item!.giTag == PW_FORCE_BOON {
                    G_FreeEntity(ent)
                    return true
                }
            }
        }

        if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
            if ent.item!.giType == IT_ARMOR || ent.item!.giType == IT_HEALTH || (ent.item!.giType == IT_HOLDABLE && (ent.item!.giTag == HI_MEDPAC || ent.item!.giTag == HI_MEDPAC_BIG)) {
                G_FreeEntity(ent)
                return true
            }
        }

        if g_gametype.integer != GT_CTF && g_gametype.integer != GT_CTY && ent.item!.giType == IT_TEAM {
            var killMe: Int32 = 0

            switch ent.item!.giTag {
            case PW_REDFLAG:
                killMe = 1

            case PW_BLUEFLAG:
                killMe = 1

            case PW_NEUTRALFLAG:
                killMe = 1

            default:
                break
            }

            if killMe != 0 {
                G_FreeEntity(ent)
                return true
            }
        }

        ent.r.mins = vec3_t(-8, -8, -0)
        ent.r.maxs = vec3_t(8, 8, 16)

        ent.s.eType = ET_ITEM
        ent.s.modelindex = bg_itemlist.index(of: ent.item!) // store item number in modelindex
        ent.s.modelindex2 = 0 // zero indicates this isn't a dropped item

        ent.r.contents = CONTENTS_TRIGGER
        ent.touch = Touch.Touch_Item
        // useing an item causes it to respawn
        ent.use = Use.Use_Item

        // create a Ghoul2 model if the world model is a glm
        /*	item = &bg_itemlist[ ent->s.modelindex ];
        if (!stricmp(&item->world_model[0][strlen(item->world_model[0]) - 4], ".glm"))
        {
        trap_G2API_InitGhoul2Model(&ent->s, item->world_model[0], G_ModelIndex(item->world_model[0] ), 0, 0, 0, 0);
        ent->s.radius = 60;
        }
        */
        if (ent.spawnflags & ITMSF_SUSPEND) != 0 {
            // suspended
            G_SetOrigin(ent, &ent.s.origin)
        } else {
            // drop to floor

            //if it is directly even with the floor it will return startsolid, so raise up by 0.1
            //and temporarily subtract 0.1 from the z maxs so that going up doesn't push into the ceiling
            ent.s.origin[2] = Float(Double(ent.s.origin[2]) + 0.1)
            ent.r.maxs[2] = Float(Double(ent.r.maxs[2]) - 0.1)

            dest = vec3_t(ent.s.origin[0], ent.s.origin[1], ent.s.origin[2] - 4096)
            trap_Trace(tr, ent.s.origin, ent.r.mins, ent.r.maxs, dest, ent.s.number, MASK_SOLID)
            if tr.startsolid != 0 {
                G_Printf("FinishSpawningItem: %s startsolid at %s\n", ent.classname!, vtos(ent.s.origin))
                G_FreeEntity(ent)
                return true
            }

            //add the 0.1 back after the trace
            ent.r.maxs[2] = Float(Double(ent.r.maxs[2]) + 0.1)

            // allow to ride movers
            ent.s.groundEntityNum = tr.entityNum

            G_SetOrigin(ent, &tr.endpos)
        }

        // team slaves and targeted items aren't present at start
        if (ent.flags & FL_TEAMSLAVE) != 0 || ent.targetname != nil {
            ent.s.eFlags |= EF_NODRAW
            ent.r.contents = 0
            return true
        }

        // powerups don't spawn in for a while
        /*
        if ( ent->item->giType == IT_POWERUP ) {
        float	respawn;

        respawn = 45 + crandom() * 15;
        ent->s.eFlags |= EF_NODRAW;
        ent->r.contents = 0;
        ent->nextthink = level.time + respawn * 1000;
        ent->think = RespawnItem;
        return;
        }
        */

        trap_LinkEntity(ent)
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
==================
G_CheckTeamItems
==================
```
*/
/// Source: oracle/codemp/game/g_items.c:2973
func G_CheckTeamItems() {
    // Set up team stuff
    Team_InitGame()

    if g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY {
        var item: Gitem?

        // check for the two flags
        item = BG_FindItem("team_CTF_redflag")
        if item == nil || !itemRegistered[bg_itemlist.firstIndex(of: item!)!] {
            G_Printf(S_COLOR_YELLOW + "WARNING: No team_CTF_redflag in map")
        }
        item = BG_FindItem("team_CTF_blueflag")
        if item == nil || !itemRegistered[bg_itemlist.firstIndex(of: item!)!] {
            G_Printf(S_COLOR_YELLOW + "WARNING: No team_CTF_blueflag in map")
        }
    }
}

/**
```
==============
ClearRegisteredItems
==============
```
*/
/// Source: oracle/codemp/game/g_items.c:2998
func ClearRegisteredItems() {
    itemRegistered.fill(false)

    // players always start with the base weapon
    RegisterItem(BG_FindItemForWeapon(WP_BRYAR_PISTOL)!)
    RegisterItem(BG_FindItemForWeapon(WP_STUN_BATON)!)
    RegisterItem(BG_FindItemForWeapon(WP_MELEE)!)
    RegisterItem(BG_FindItemForWeapon(WP_SABER)!)

    if g_gametype.integer == GT_SIEGE {
        //kind of cheesy, maybe check if siege class with disp's is gonna be on this map too
        G_PrecacheDispensers()
    }
}

/**
```
===============
RegisterItem

The item will be added to the precache list
===============
```
*/
/// Source: oracle/codemp/game/g_items.c:3020
func RegisterItem(_ item: JKAMP.Gitem) {
    itemRegistered[bg_itemlist.firstIndex(of: item)!] = true
}

/**
```
===============
SaveRegisteredItems

Write the needed items to a config string
so the client will know which ones to precache
===============
```
*/
/// Source: oracle/codemp/game/g_items.c:3036
func SaveRegisteredItems() {
    var string = CharBuf(257)
    var i: Int32
    var count: Int32

    count = 0
    i = 0
    while i < bg_numItems {
        if itemRegistered[i] {
            count += 1
            string[i] = Int32(ascii: "1")
        } else {
            string[i] = Int32(ascii: "0")
        }
        i += 1
    }
    string[bg_numItems] = 0

    //	G_Printf( "%i items registered\n", count );
    trap_SetConfigstring(CS_ITEMS, String(string))
}

/**
```
============
G_ItemDisabled
============
```
*/
/// Source: oracle/codemp/game/g_items.c:3061
func G_ItemDisabled(_ item: JKAMP.Gitem) -> Int32 {
    var name = CharBuf(128)

    Com_sprintf(&name, Int32((name).count), "disable_%s", item.classname!)
    return trap_Cvar_VariableIntegerValue(String(name))
}

/**
```
============
G_SpawnItem

Sets the clipping size and plants the object on the floor.

Items can't be immediately dropped to floor, because they might
be on an entity that hasn't spawned yet.
============
```
*/
/// Source: oracle/codemp/game/g_items.c:3079
func G_SpawnItem(_ ent: Entity, _ item: JKAMP.Gitem) {
    var wDisable: Int32 = 0

    G_SpawnFloat("random", "0", &ent.random)
    G_SpawnFloat("wait", "0", &ent.wait)

    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        wDisable = g_duelWeaponDisable.integer
    } else {
        wDisable = g_weaponDisable.integer
    }

    if item.giType == IT_WEAPON && wDisable != 0 && (wDisable & (1 << item.giTag)) != 0 {
        if g_gametype.integer != GT_JEDIMASTER {
            G_FreeEntity(ent)
            return
        }
    }

    RegisterItem(item)
    if G_ItemDisabled(item) != 0 {
        return
    }

    ent.item = item
    // some movers spawn on the second frame, so delay item
    // spawns until the third frame so they can ride trains
    ent.nextthink = level.time + FRAMETIME * 2
    ent.think = Think.FinishSpawningItem

    ent.physicsBounce = 0.50 // items are bouncy

    if item.giType == IT_POWERUP {
        G_SoundIndex("sound/items/respawn1")
        G_SpawnFloat("noglobalsound", "0", &ent.speed)
    }
}

/**
```
================
G_BounceItem

================
```
*/
/// Source: oracle/codemp/game/g_items.c:3130
func G_BounceItem(_ ent: Entity, _ trace: JKAMP.Trace) {
    var velocity = vec3_t()
    let dot: Float
    let hitTime: Int32

    // reflect the velocity on the trace plane
    hitTime = Int32(level.previousTime + (level.time - level.previousTime) * trace.fraction)
    BG_EvaluateTrajectoryDelta(ent.s.pos, hitTime, &velocity)
    dot = _DotProduct(velocity, trace.plane.normal)
    _VectorMA(velocity, -2 * dot, trace.plane.normal, &ent.s.pos.trDelta)

    // cut the velocity to keep from bouncing forever
    ent.s.pos.trDelta = ent.s.pos.trDelta * ent.physicsBounce

    if (ent.s.weapon == WP_DET_PACK && ent.s.eType == ET_GENERAL && ent.physicsObject) {
        //detpacks only
        if ent.touch != nil {
            ent.runTouch(g_entities[trace.entityNum], trace)
            return
        }
    }

    // check for stop
    if trace.plane.normal[2] > 0 && ent.s.pos.trDelta[2] < 40 {
        trace.endpos[2] = Float(Double(trace.endpos[2]) + 1.0) // make sure it is off ground
        SnapVector(&trace.endpos)
        G_SetOrigin(ent, &trace.endpos)
        ent.s.groundEntityNum = trace.entityNum
        return
    }

    ent.r.currentOrigin = ent.r.currentOrigin + trace.plane.normal
    ent.s.pos.trBase = ent.r.currentOrigin
    ent.s.pos.trTime = level.time

    if ent.s.eType == ET_HOLOCRON || (ent.s.shouldtarget && ent.s.eType == ET_GENERAL && ent.physicsObject) {
        //holocrons and sentry guns
        if ent.touch != nil {
            ent.runTouch(g_entities[trace.entityNum], trace)
        }
    }
}

/**
```
================
G_RunItem

================
```
*/
/// Source: oracle/codemp/game/g_items.c:3183
func G_RunItem(_ ent: Entity) {
    var origin = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var contents: Int32 = 0
        var mask: Int32 = 0

        // if groundentity has been set to -1, it may have been pushed off an edge
        if ent.s.groundEntityNum == -1 {
            if ent.s.pos.trType != TR_GRAVITY {
                ent.s.pos.trType = TR_GRAVITY
                ent.s.pos.trTime = level.time
            }
        }

        if ent.s.pos.trType == TR_STATIONARY {
            // check think function
            G_RunThink(ent)
            return true
        }

        // get current position
        BG_EvaluateTrajectory(ent.s.pos, level.time, &origin)

        // trace a line from the previous position to the current position
        if ent.clipmask != 0 {
            mask = ent.clipmask
        } else {
            mask = MASK_PLAYERSOLID & ~CONTENTS_BODY //MASK_SOLID;
        }
        trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, origin, ent.r.ownerNum, mask)

        ent.r.currentOrigin = tr.endpos

        if tr.startsolid != 0 {
            tr.fraction = 0
        }

        trap_LinkEntity(ent) // FIXME: avoid this for stationary?

        // check think function
        G_RunThink(ent)

        if tr.fraction == 1 {
            return true
        }

        // if it is in a nodrop volume, remove it
        contents = trap_PointContents(ent.r.currentOrigin, -1)
        if (contents & CONTENTS_NODROP) != 0 {
            if ent.item != nil && ent.item!.giType == IT_TEAM {
                Team_FreeEntity(ent)
            } else {
                G_FreeEntity(ent)
            }
            return true
        }

        G_BounceItem(ent, tr)
        return false
    }
    if earlyOut {
        return
    }
}
