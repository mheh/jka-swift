import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_active.c:1097
let MAX_JEDIMASTER_DISTANCE = 2500 as Int32

/// Source: oracle/codemp/game/g_active.c:1098
let MAX_JEDIMASTER_FOV = 100 as Int32

/// Source: oracle/codemp/game/g_active.c:1100
let MAX_SIGHT_DISTANCE = 1500 as Int32

/// Source: oracle/codemp/game/g_active.c:1101
let MAX_SIGHT_FOV = 100 as Int32

/// Source: oracle/codemp/game/g_active.c:2203
let SLOWDOWN_DIST = 128.0 as Float

/// Source: oracle/codemp/game/g_active.c:2204
let MIN_NPC_SPEED = 16.0 as Float

/// Source: oracle/codemp/game/g_active.c:20
func P_SetTwitchInfo(_ client: Client) {
    client.ps.painTime = level.time
    client.ps.painDirection ^= 1
}

/**
```
===============
G_DamageFeedback

Called just before a snapshot is sent to the given player.
Totals up all damage and generates both the player_state_t
damage values to that client for pain blends and kicks, and
global pain sound events for all clients.
===============
```
*/
/// Source: oracle/codemp/game/g_active.c:36
func P_DamageFeedback(_ player: Entity) {
    var client: Client?
    var count: Float
    var angles = vec3_t()

    client = player.client
    if client!.ps.pm_type == PM_DEAD {
        return
    }

    // total points of damage shot at the player this frame
    count = Float(client!.damage_blood + client!.damage_armor)
    if count == 0 {
        return // didn't take any damage
    }

    if count > 255 {
        count = 255
    }

    // send the information to the client

    // world damage (falling, slime, etc) uses a special code
    // to make the blend blob centered instead of positional
    if client!.damage_fromWorld {
        client!.ps.damagePitch = 255
        client!.ps.damageYaw = 255

        client!.damage_fromWorld = false
    } else {
        vectoangles(client!.damage_from, &angles)
        client!.ps.damagePitch = Int32(Double(angles[PITCH]) / 360.0 * 256)
        client!.ps.damageYaw = Int32(Double(angles[YAW]) / 360.0 * 256)

        //cap them since we can't send negative values in here across the net
        if client!.ps.damagePitch < 0 {
            client!.ps.damagePitch = 0
        }
        if client!.ps.damageYaw < 0 {
            client!.ps.damageYaw = 0
        }
    }

    // play an apropriate pain sound
    if (level.time > player.pain_debounce_time) && !((player.flags & FL_GODMODE) != 0) && !((player.s.eFlags & EF_DEAD) != 0) {
        // don't do more than two pain sounds a second
        // nmckenzie: also don't make him loud and whiny if he's only getting nicked.
        if level.time - client!.ps.painTime < 500 || count < 10 {
            return
        }
        P_SetTwitchInfo(client!)
        player.pain_debounce_time = level.time + 700

        G_AddEvent(player, EV_PAIN, player.health)
        client!.ps.damageEvent += 1

        if client!.damage_armor != 0 && client!.damage_blood == 0 {
            client!.ps.damageType = 1 //pure shields
        } else if client!.damage_armor != 0 {
            client!.ps.damageType = 2 //shields and health
        } else {
            client!.ps.damageType = 0 //pure health
        }
    }


    client!.ps.damageCount = Int32(count)

    //
    // clear totals
    //
    client!.damage_blood = 0
    client!.damage_armor = 0
    client!.damage_knockback = 0
}

/**
```
=============
P_WorldEffects

Check for lava / slime contents and drowning
=============
```
*/
/// Source: oracle/codemp/game/g_active.c:129
func P_WorldEffects(_ ent: Entity) {
    let envirosuit: Bool
    let waterlevel: Int32

    if ent.client!.noclip {
        ent.client!.airOutTime = level.time + 12000 // don't need air
        return
    }

    waterlevel = ent.waterlevel

    envirosuit = ent.client!.ps.powerups[PW_BATTLESUIT] > level.time

    //
    // check for drowning
    //
    if waterlevel == 3 {
        // envirosuit give air
        if envirosuit {
            ent.client!.airOutTime = level.time + 10000
        }

        // if out of air, start drowning
        if ent.client!.airOutTime < level.time {
            // drown!
            ent.client!.airOutTime += 1000
            if ent.health > 0 {
                // take more damage the longer underwater
                ent.damage += 2
                if ent.damage > 15 {
                    ent.damage = 15
                }

                // play a gurp sound instead of a normal pain sound
                // The SDK also declares `rand`, so the call names the bg module.
                if ent.health <= ent.damage {
                    G_Sound(ent, CHAN_VOICE, G_SoundIndex("sound/player/gurp1.wav"))
                } else if (JKAMP_BG.rand() & 1) != 0 {
                    G_Sound(ent, CHAN_VOICE, G_SoundIndex("sound/player/gurp1.wav"))
                } else {
                    G_Sound(ent, CHAN_VOICE, G_SoundIndex("sound/player/gurp2.wav"))
                }

                // don't play a normal pain sound
                ent.pain_debounce_time = level.time + 200

                // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("P_WorldEffects", source: "oracle/codemp/game/g_active.c:129")
                var scratchDir = vec3_t()
                G_Damage(ent, nil, nil, &scratchDir, nil, ent.damage, DAMAGE_NO_ARMOR, MOD_WATER)
            }
        }
    } else {
        ent.client!.airOutTime = level.time + 12000
        ent.damage = 2
    }

    //
    // check for sizzle damage (move to pmove?)
    //
    if waterlevel != 0 && (ent.watertype & (CONTENTS_LAVA | CONTENTS_SLIME)) != 0 {
        if ent.health > 0 && ent.pain_debounce_time <= level.time {
            if envirosuit {
                G_AddEvent(ent, EV_POWERUP_BATTLESUIT, 0)
            } else {
                if (ent.watertype & CONTENTS_LAVA) != 0 {
                    // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("P_WorldEffects", source: "oracle/codemp/game/g_active.c:129")
                    var scratchDir2 = vec3_t()
                    G_Damage(ent, nil, nil, &scratchDir2, nil, 30 * waterlevel, 0, MOD_LAVA)
                }

                if (ent.watertype & CONTENTS_SLIME) != 0 {
                    // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("P_WorldEffects", source: "oracle/codemp/game/g_active.c:129")
                    var scratchDir3 = vec3_t()
                    G_Damage(ent, nil, nil, &scratchDir3, nil, 10 * waterlevel, 0, MOD_SLIME)
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/g_active.c:213
func DoImpact(_ `self`: Entity, _ other: Entity, _ damageSelf: Bool) {
    var magnitude: Float
    var my_mass: Float
    var velocity = vec3_t()
    let cont: Int32
    var easyBreakBrush: Bool = true

    if `self`.client != nil {
        velocity = `self`.client!.ps.velocity
        if `self`.mass == 0 {
            my_mass = 10
        } else {
            my_mass = `self`.mass
        }
    } else {
        velocity = `self`.s.pos.trDelta
        if `self`.s.pos.trType == TR_GRAVITY {
            velocity[2] -= 0.25 * g_gravity.value
        }
        if `self`.mass == 0 {
            my_mass = 1
        } else if `self`.mass <= 10 {
            my_mass = 10
        } else {
            my_mass = `self`.mass ///10;
        }
    }

    magnitude = VectorLength(velocity) * my_mass / 10

    /*
    if(pointcontents(self.absmax)==CONTENT_WATER)//FIXME: or other watertypes
    magnitude/=3;							//water absorbs 2/3 velocity

    if(self.classname=="barrel"&&self.aflag)//rolling barrels are made for impacts!
    magnitude*=3;

    if(self.frozen>0&&magnitude<300&&self.flags&FL_ONGROUND&&loser==world&&self.velocity_z<-20&&self.last_onground+0.3<time)
    magnitude=300;
    */
    if other.material == MAT_GLASS || other.material == MAT_GLASS_METAL || other.material == MAT_GRATE1 || ((other.flags & FL_BBRUSH) != 0 && (other.spawnflags & 8) != 0) || (other.r.svFlags & SVF_GLASS_BRUSH) != 0 {
        easyBreakBrush = true
    }

    if `self`.client == nil || `self`.client!.ps.lastOnGround + 300 < level.time || (`self`.client!.ps.lastOnGround + 100 < level.time && easyBreakBrush) {
        var dir1 = vec3_t()
        var dir2 = vec3_t()
        var force: Float = 0
        let dot: Float

        if easyBreakBrush {
            magnitude *= 2
        }

        //damage them
        if magnitude >= 100 && other.s.number < ENTITYNUM_WORLD {
            dir1 = velocity
            VectorNormalize(&dir1)
            if VectorCompare(other.r.currentOrigin, vec3_origin) != 0 {
                //a brush with no origin
                dir2 = dir1
            } else {
                dir2 = other.r.currentOrigin - `self`.r.currentOrigin
                VectorNormalize(&dir2)
            }

            dot = _DotProduct(dir1, dir2)

            if Double(dot) >= 0.2 {
                force = dot
            } else {
                force = 0
            }

            force *= (magnitude / 50)

            cont = trap_PointContents(other.r.absmax, other.s.number)
            if (cont & CONTENTS_WATER) != 0 {
                force /= 3 //water absorbs 2/3 velocity
            }

            /*
            if(self.frozen>0&&force>10)
            force=10;
            */

            if (force >= 1 && other.s.number != 0) || force >= 10 {
                /*
                dprint("Damage other (");
                dprint(loser.classname);
                dprint("): ");
                dprint(ftos(force));
                dprint("\n");
                */
                if (other.r.svFlags & SVF_GLASS_BRUSH) != 0 {
                    other.splashRadius = Int32(Float((`self`.r.maxs[0] - `self`.r.mins[0])) / 4.0)
                }
                if other.takedamage {
                    G_Damage(other, `self`, `self`, &velocity, `self`.r.currentOrigin, Int32(force), DAMAGE_NO_ARMOR, MOD_CRUSH) //FIXME: MOD_IMPACT
                } else {
                    G_ApplyKnockback(other, dir2, force)
                }
            }
        }

        if damageSelf && `self`.takedamage {
            //Now damage me
            //FIXME: more lenient falling damage, especially for when driving a vehicle
            if `self`.client != nil && `self`.client!.ps.fd.forceJumpZStart != 0 {
                //we were force-jumping
                if `self`.r.currentOrigin[2] >= `self`.client!.ps.fd.forceJumpZStart {
                    //we landed at same height or higher than we landed
                    magnitude = 0
                } else {
                    //FIXME: take off some of it, at least?
                    magnitude = (`self`.client!.ps.fd.forceJumpZStart - `self`.r.currentOrigin[2]) / 3
                }
            }
            //if(self.classname!="monster_mezzoman"&&self.netname!="spider")//Cats always land on their feet
            if (magnitude >= 100 + `self`.health && `self`.s.number != 0 && `self`.s.weapon != WP_SABER) || (magnitude >= 700) {
                if (`self`.s.weapon == WP_SABER || `self`.s.number == 0) && `self`.client != nil && `self`.client!.ps.groundEntityNum < ENTITYNUM_NONE && magnitude < 1000 {
                    //players and jedi take less impact damage
                    //allow for some lenience on high falls
                    magnitude /= 2
                    /*
                    if ( self.absorb_time >= time )//crouching on impact absorbs 1/2 the damage
                    {
                    magnitude/=2;
                    }
                    */
                }
                magnitude /= 40
                magnitude = magnitude - force / 2 //If damage other, subtract half of that damage off of own injury
                if magnitude >= 1 {
                    //FIXME: Put in a thingtype impact sound function
                    /*
                    dprint("Damage self (");
                    dprint(self.classname);
                    dprint("): ");
                    dprint(ftos(magnitude));
                    dprint("\n");
                    */
                    /*
                    if ( self.classname=="player_sheep "&& self.flags&FL_ONGROUND && self.velocity_z > -50 )
                    return;
                    */
                    // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("DoImpact", source: "oracle/codemp/game/g_active.c:213")
                    var scratchDir = vec3_t()
                    G_Damage(`self`, nil, nil, &scratchDir, `self`.r.currentOrigin, Int32(magnitude / 2), DAMAGE_NO_ARMOR, MOD_FALLING) //FIXME: MOD_IMPACT
                }
            }
        }

        //FIXME: slow my velocity some?

        // NOTENOTE We don't use lastimpact as of yet
        //		self->lastImpact = level.time;

        /*
        if(self.flags&FL_ONGROUND)
        self.last_onground=time;
        */
    }
}

/// Source: oracle/codemp/game/g_active.c:407
func Client_CheckImpactBBrush(_ `self`: Entity, _ other: Entity) {
    if !other.inuse {
        return
    }
    if !`self`.inuse || `self`.client == nil || `self`.client!.tempSpectate >= level.time || `self`.client!.sess.sessionTeam == TEAM_SPECTATOR {
        //hmm.. let's not let spectators ram into breakables.
        return
    }

    /*
    if (BG_InSpecialJump(self->client->ps.legsAnim))
    { //don't do this either, qa says it creates "balance issues"
    return;
    }
    */

    if other.material == MAT_GLASS || other.material == MAT_GLASS_METAL || other.material == MAT_GRATE1 || ((other.flags & FL_BBRUSH) != 0 && (other.spawnflags & 8) != 0) || ((other.flags & FL_BBRUSH) != 0 && (other.health <= 10)) || (other.r.svFlags & SVF_GLASS_BRUSH) != 0 {
        //clients only do impact damage against easy-break breakables
        DoImpact(`self`, other, false)
    }
}

/**
```
===============
G_SetClientSound
===============
```
*/
/// Source: oracle/codemp/game/g_active.c:444
func G_SetClientSound(_ ent: Entity) {
    if ent.client != nil && ent.client!.isHacking != 0 {
        //loop hacking sound
        ent.client!.ps.loopSound = level.snd_hack
        ent.s.loopIsSoundset = false
    } else if ent.client != nil && ent.client!.isMedHealed > level.time {
        //loop healing sound
        ent.client!.ps.loopSound = level.snd_medHealed
        ent.s.loopIsSoundset = false
    } else if ent.client != nil && ent.client!.isMedSupplied > level.time {
        //loop supplying sound
        ent.client!.ps.loopSound = level.snd_medSupplied
        ent.s.loopIsSoundset = false
    } else if ent.waterlevel != 0 && (ent.watertype & (CONTENTS_LAVA | CONTENTS_SLIME)) != 0 {
        ent.client!.ps.loopSound = level.snd_fry
        ent.s.loopIsSoundset = false
    } else {
        ent.client!.ps.loopSound = 0
        ent.s.loopIsSoundset = false
    }
}

/**
```
==============
ClientImpacts
==============
```
*/
/// Source: oracle/codemp/game/g_active.c:478
func ClientImpacts(_ ent: Entity, _ pm: JKAMP.Pmove) {
    var i: Int32 = 0
    var j: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in
        var other: Entity?

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
        i = 0
        while i < pm.numtouch {
            j = 0
            while j < i {
                if pm.touchents[j] == pm.touchents[i] {
                    break
                }
                j += 1
            }
            if j != i {
                i += 1
                continue // duplicated
            }
            other = g_entities[pm.touchents[i]]

            if (ent.r.svFlags & SVF_BOT) != 0 && ent.touch != nil {
                ent.runTouch(other, trace)
            }

            if other!.touch == nil {
                i += 1
                continue
            }

            other!.runTouch(ent, trace)
            i += 1
        }
    }
}

/**
```
============
G_TouchTriggers

Find all trigger entities that ent's current position touches.
Spectators will only interact with teleporters.
============
```
*/
/// Source: oracle/codemp/game/g_active.c:516
func G_TouchTriggers(_ ent: Entity) {
    var i: Int32 = 0
    var num: Int32 = 0
    var touch: [Int32] = [Int32](repeating: 0, count: 1024)
    var hit: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var mins = vec3_t()
        var maxs = vec3_t()
        var range = vec3_t(40, 40, 52)

        if ent.client == nil {
            return true
        }

        // dead clients don't activate triggers!
        if ent.client!.ps.stats[STAT_HEALTH] <= 0 {
            return true
        }

        mins = ent.client!.ps.origin - range
        maxs = ent.client!.ps.origin + range

        num = trap_EntitiesInBox(mins, maxs, &touch, MAX_GENTITIES)

        // can't use ent->r.absmin, because that has a one unit pad
        mins = ent.client!.ps.origin + ent.r.mins
        maxs = ent.client!.ps.origin + ent.r.maxs

        i = 0
        while i < num {
            hit = g_entities[touch[i]]

            if hit!.touch == nil && ent.touch == nil {
                i += 1
                continue
            }
            if !((hit!.r.contents & CONTENTS_TRIGGER) != 0) {
                i += 1
                continue
            }

            // ignore most entities if a spectator
            if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "type '@convention(c) (Optional<OpaquePointer>, Optional<OpaquePointer>, Optional<OpaquePointer>) -> ()' cannot conform to 'Equatable' [#ProtocolTypeNonConformance]".
                // Raven wrote: if ( hit->s.eType != ET_TELEPORT_TRIGGER && // this is ugly but adding a new ET_? type will // most likely cause network incompatibilities hit->touch != Touch_DoorTrigger) { continue; }
                portMissing("G_TouchTriggers", source: "oracle/codemp/game/g_active.c:516")
            }

            // use seperate code for determining if an item is picked up
            // so you don't have to actually contact its bounding box
            if hit!.s.eType == ET_ITEM {
                if !BG_PlayerTouchesItem(ent.client!.ps, hit!.s, level.time) {
                    i += 1
                    continue
                }
            } else {
                if !trap_EntityContact(mins, maxs, hit!) {
                    i += 1
                    continue
                }
            }

            trace.clear()

            if hit!.touch != nil {
                hit!.runTouch(ent, trace)
            }

            if (ent.r.svFlags & SVF_BOT) != 0 && ent.touch != nil {
                ent.runTouch(hit, trace)
            }
            i += 1
        }

        // if we didn't touch a jump pad this pmove frame
        if ent.client!.ps.jumppad_frame != ent.client!.ps.pmove_framecount {
            ent.client!.ps.jumppad_frame = 0
            ent.client!.ps.jumppad_ent = 0
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
============
G_MoverTouchTriggers

Find all trigger entities that ent's current position touches.
Spectators will only interact with teleporters.
============
```
*/
/// Source: oracle/codemp/game/g_active.c:601
func G_MoverTouchPushTriggers(_ ent: Entity, _ oldOrg: inout JKAShared.vec3_t) {
    var i: Int32 = 0
    var num: Int32 = 0
    var step: Float = 0
    var stepSize: Float = 0
    var dist: Float = 0
    var touch: [Int32] = [Int32](repeating: 0, count: 1024)
    var hit: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var mins = vec3_t()
        var maxs = vec3_t()
        var dir = vec3_t()
        var size = vec3_t()
        var checkSpot = vec3_t()
        var range = vec3_t(40, 40, 52)

        // non-moving movers don't hit triggers!
        if VectorLengthSquared(ent.s.pos.trDelta) == 0 {
            return true
        }

        size = ent.r.mins - ent.r.maxs
        stepSize = VectorLength(size)
        if stepSize < 1 {
            stepSize = 1
        }

        dir = ent.r.currentOrigin - oldOrg
        dist = VectorNormalize(&dir)
        step = 0
        while step <= dist {
            _VectorMA(ent.r.currentOrigin, step, dir, &checkSpot)
            mins = checkSpot - range
            maxs = checkSpot + range

            num = trap_EntitiesInBox(mins, maxs, &touch, MAX_GENTITIES)

            // can't use ent->r.absmin, because that has a one unit pad
            mins = checkSpot + ent.r.mins
            maxs = checkSpot + ent.r.maxs

            i = 0
            while i < num {
                hit = g_entities[touch[i]]

                if hit!.s.eType != ET_PUSH_TRIGGER {
                    i += 1
                    continue
                }

                if hit!.touch == nil {
                    i += 1
                    continue
                }

                if !((hit!.r.contents & CONTENTS_TRIGGER) != 0) {
                    i += 1
                    continue
                }


                if !trap_EntityContact(mins, maxs, hit!) {
                    i += 1
                    continue
                }

                trace.clear()

                if hit!.touch != nil {
                    hit!.runTouch(ent, trace)
                }
                i += 1
            }
            step += stepSize
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
=================
SpectatorThink
=================
```
*/
/// Source: oracle/codemp/game/g_active.c:678
func SpectatorThink(_ ent: Entity, _ ucmd: JKAMP.Usercmd) {
    // Pmove names both the view and the function, so the module name selects the view.
    // Raven's record lives to the end of the function, so the rest of the body is the closure.
    JKAMP.Pmove.scratch { pm in
        var client: Client?

        client = ent.client

        if client!.sess.spectatorState != SPECTATOR_FOLLOW {
            client!.ps.pm_type = PM_SPECTATOR
            client!.ps.speed = 400 // faster than normal
            client!.ps.basespeed = 400

            //hmm, shouldn't have an anim if you're a spectator, make sure
            //it gets cleared.
            client!.ps.legsAnim = 0
            client!.ps.legsTimer = 0
            client!.ps.torsoAnim = 0
            client!.ps.torsoTimer = 0

            // set up for pmove
            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
            pm.ps = client!.ps
            pm.cmd = ucmd
            pm.tracemask = MASK_PLAYERSOLID & ~CONTENTS_BODY // spectators can fly through bodies
            // Port-note: A read of `pm`, a local the draft left as a hole.
            // Raven wrote: pm.trace = trap_Trace
            portMissing("SpectatorThink", source: "oracle/codemp/game/g_active.c:678")
            // Port-note: A read of `pm`, a local the draft left as a hole.
            // Raven wrote: pm.pointcontents = trap_PointContents
            portMissing("SpectatorThink", source: "oracle/codemp/game/g_active.c:678")

            pm.noSpecMove = g_noSpecMove.integer

            pm.animations = nil
            pm.nonHumanoid = false

            //Set up bg entity data
            // Port-note: A read of `pm`, a local the draft left as a hole.
            // Raven wrote: pm.baseEnt = (bgEntity_t *)g_entities
            portMissing("SpectatorThink", source: "oracle/codemp/game/g_active.c:678")
            // Port-note: A read of `pm`, a local the draft left as a hole.
            // Raven wrote: pm.entSize = sizeof(gentity_t)
            portMissing("SpectatorThink", source: "oracle/codemp/game/g_active.c:678")

            // perform a pmove
            Pmove(pm)
            // save results of pmove
            ent.s.origin = client!.ps.origin

            if ent.client!.tempSpectate < level.time {
                G_TouchTriggers(ent)
            }
            trap_UnlinkEntity(ent)
        }

        client!.oldbuttons = client!.buttons
        client!.buttons = ucmd.buttons

        if client!.tempSpectate < level.time {
            // attack button cycles through spectators
            if (client!.buttons & BUTTON_ATTACK) != 0 && !((client!.oldbuttons & BUTTON_ATTACK) != 0) {
                Cmd_FollowCycle_f(ent, 1)
            }

            if client!.sess.spectatorState == SPECTATOR_FOLLOW && (ucmd.upmove > 0) {
                //jump now removes you from follow mode
                StopFollowing(ent)
            }
        }
    }
}

/**
```
=================
ClientInactivityTimer

Returns qfalse if the client is dropped
=================
```
*/
/// Source: oracle/codemp/game/g_active.c:751
func ClientInactivityTimer(_ client: Client) -> Bool {
    if g_inactivity.integer == 0 {
        // give everyone some time, so if the operator sets g_inactivity during
        // gameplay, everyone isn't kicked
        client.inactivityTime = level.time + 60 * 1000
        client.inactivityWarning = false
    } else if client.pers.cmd.forwardmove != 0 || client.pers.cmd.rightmove != 0 || client.pers.cmd.upmove != 0 || (client.pers.cmd.buttons & (BUTTON_ATTACK | BUTTON_ALT_ATTACK)) != 0 {
        client.inactivityTime = level.time + g_inactivity.integer * 1000
        client.inactivityWarning = false
    } else if !client.pers.localClient {
        if level.time > client.inactivityTime {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '-' on 'Strideable' requires that 'Client' conform to '_Pointer'".
            // Raven wrote: trap_DropClient( client - level.clients, "Dropped due to inactivity" )
            portMissing("ClientInactivityTimer", source: "oracle/codemp/game/g_active.c:751")
            return false
        }
        if level.time > client.inactivityTime - 10000 && !client.inactivityWarning {
            client.inactivityWarning = true
            // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '-' on 'Strideable' requires that 'Client' conform to '_Pointer'".
            // Raven wrote: trap_SendServerCommand( client - level.clients, "cp \"Ten seconds until inactivity drop!\n\"" )
            portMissing("ClientInactivityTimer", source: "oracle/codemp/game/g_active.c:751")
        }
    }
    return true
}

/**
```
==================
ClientTimerActions

Actions that happen once a second
==================
```
*/
/// Source: oracle/codemp/game/g_active.c:783
func ClientTimerActions(_ ent: Entity, _ msec: Int32) {
    var client: Client?

    client = ent.client
    client!.timeResidual += msec

    while client!.timeResidual >= 1000 {
        client!.timeResidual -= 1000

        // count down health when over max
        if ent.health > client!.ps.stats[STAT_MAX_HEALTH] {
            ent.health -= 1
        }

        // count down armor when over max
        if client!.ps.stats[STAT_ARMOR] > client!.ps.stats[STAT_MAX_HEALTH] {
            client!.ps.stats[STAT_ARMOR] -= 1
        }
    }
}

/**
```
====================
ClientIntermissionThink
====================
```
*/
/// Source: oracle/codemp/game/g_active.c:810
func ClientIntermissionThink(_ client: Client) {
    client.ps.eFlags &= ~EF_TALK
    client.ps.eFlags &= ~EF_FIRING

    // the level will exit when everyone wants to or after timeouts

    // swap and latch button actions
    client.oldbuttons = client.buttons
    client.buttons = client.pers.cmd.buttons
    if (client.buttons & (BUTTON_ATTACK | BUTTON_USE_HOLDABLE) & (client.oldbuttons ^ client.buttons)) != 0 {
        // this used to be an ^1 but once a player says ready, it should stick
        client.readyToExit = 1 != 0
    }
}

/// Source: oracle/codemp/game/g_active.c:826
func G_VehicleAttachDroidUnit(_ vehEnt: Entity) {
    if vehEnt.m_pVehicle != nil && vehEnt.m_pVehicle!.m_pDroidUnit != nil {
        let droidEnt: Entity? = vehEnt.m_pVehicle!.m_pDroidUnit.map { Entity($0) }
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in
            var fwd = vec3_t()

            trap_G2API_GetBoltMatrix(vehEnt.ghoul2, 0, vehEnt.m_pVehicle!.m_iDroidUnitTag, boltMatrix, vehEnt.r.currentAngles, vehEnt.r.currentOrigin, level.time, nil, &vehEnt.modelScale)
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &droidEnt!.r.currentOrigin)
            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &fwd)
            vectoangles(fwd, &droidEnt!.r.currentAngles)

            if droidEnt!.client != nil {
                droidEnt!.client!.ps.viewangles = droidEnt!.r.currentAngles
                droidEnt!.client!.ps.origin = droidEnt!.r.currentOrigin
            }

            G_SetOrigin(droidEnt!, &droidEnt!.r.currentOrigin)
            trap_LinkEntity(droidEnt!)

            if droidEnt!.NPC != nil {
                NPC_SetAnim(droidEnt!, SETANIM_BOTH, BOTH_STAND2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            }
        }
    }
}

//called gameside only from pmove code (convenience)
/// Source: oracle/codemp/game/g_active.c:857
func G_CheapWeaponFire(_ entNum: Int32, _ ev: Int32) {
    let ent: Entity? = g_entities[entNum]

    if !ent!.inuse || ent!.client == nil {
        return
    }

    switch ev {
    case EV_FIRE_WEAPON:
        if ent!.m_pVehicle != nil && ent!.m_pVehicle!.m_pVehicleInfo!.type == VH_SPEEDER && ent!.client != nil && ent!.client!.ps.m_iVehicleNum != 0 {
            //a speeder with a pilot
            let rider: Entity? = g_entities[ent!.client!.ps.m_iVehicleNum - 1]
            if rider!.inuse && rider!.client != nil {
                //pilot is valid...
                if rider!.client!.ps.weapon != WP_MELEE && (rider!.client!.ps.weapon != WP_SABER || rider!.client!.ps.saberHolstered == 0) {
                    //can only attack on speeder when using melee or when saber is holstered
                    break
                }
            }
        }

        FireWeapon(ent!, false)
        ent!.client!.dangerTime = level.time
        ent!.client!.ps.eFlags &= ~EF_INVULNERABLE
        ent!.client!.invulnerableTimer = 0

    case EV_ALT_FIRE:
        FireWeapon(ent!, true)
        ent!.client!.dangerTime = level.time
        ent!.client!.ps.eFlags &= ~EF_INVULNERABLE
        ent!.client!.invulnerableTimer = 0

    default:
        break
    }
}

/// Source: oracle/codemp/game/g_active.c:909
func ClientEvents(_ ent: Entity, _ oldEventSequence: Int32) {
    var i: Int32
    var event: Int32
    var client: Client?
    var damage: Int32
    var dir = vec3_t()
    // Raven assigns his own `oldEventSequence` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var oldEventSequence = oldEventSequence
    //	vec3_t	origin, angles;
    //	qboolean	fired;
    //	gitem_t *item;
    //	gentity_t *drop;

    client = ent.client

    if oldEventSequence < client!.ps.eventSequence - MAX_PS_EVENTS {
        oldEventSequence = client!.ps.eventSequence - MAX_PS_EVENTS
    }
    i = oldEventSequence
    while i < client!.ps.eventSequence {
        event = client!.ps.events[i & (MAX_PS_EVENTS - 1)]

        switch event {
        case EV_FALL, EV_ROLL:
            do {
                let delta: Int32 = client!.ps.eventParms[i & (MAX_PS_EVENTS - 1)]
                var knockDownage: Bool = false

                if ent.client != nil && ent.client!.ps.fallingToDeath != 0 {
                    break
                }

                if ent.s.eType != ET_PLAYER {
                    break // not in the player model
                }

                if (g_dmflags.integer & DF_NO_FALLING) != 0 {
                    break
                }

                if BG_InKnockDownOnly(ent.client!.ps.legsAnim) {
                    if delta <= 14 {
                        break
                    }
                    knockDownage = true
                } else {
                    if delta <= 44 {
                        break
                    }
                }

                if knockDownage {
                    damage = delta * 1 //you suffer for falling unprepared. A lot. Makes throws and things useful, and more realistic I suppose.
                } else {
                    if g_gametype.integer == GT_SIEGE && delta > 60 {
                        //longer falls hurt more
                        damage = delta * 1 //good enough for now, I guess
                    } else {
                        damage = Int32(Double(delta) * 0.16) //good enough for now, I guess
                    }
                }

                dir = vec3_t(0, 0, 1)
                ent.pain_debounce_time = level.time + 200 // no normal pain sound
                // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("ClientEvents", source: "oracle/codemp/game/g_active.c:909")
                var scratchDir = vec3_t()
                G_Damage(ent, nil, nil, &scratchDir, nil, damage, DAMAGE_NO_ARMOR, MOD_FALLING)

                if ent.health < 1 {
                    G_Sound(ent, CHAN_AUTO, G_SoundIndex("sound/player/fallsplat.wav"))
                }
            }

        case EV_FIRE_WEAPON:
            FireWeapon(ent, false)
            ent.client!.dangerTime = level.time
            ent.client!.ps.eFlags &= ~EF_INVULNERABLE
            ent.client!.invulnerableTimer = 0

        case EV_ALT_FIRE:
            FireWeapon(ent, true)
            ent.client!.dangerTime = level.time
            ent.client!.ps.eFlags &= ~EF_INVULNERABLE
            ent.client!.invulnerableTimer = 0

        case EV_SABER_ATTACK:
            ent.client!.dangerTime = level.time
            ent.client!.ps.eFlags &= ~EF_INVULNERABLE
            ent.client!.invulnerableTimer = 0
            //rww - Note that these must be in the same order (ITEM#-wise) as they are in holdable_t

        case EV_USE_ITEM1:
            ItemUse_Seeker(ent)

        case EV_USE_ITEM2:
            ItemUse_Shield(ent)

        case EV_USE_ITEM3:
            ItemUse_MedPack(ent)

        case EV_USE_ITEM4:
            ItemUse_MedPack_Big(ent)

        case EV_USE_ITEM5:
            ItemUse_Binoculars(ent)

        case EV_USE_ITEM6:
            ItemUse_Sentry(ent)

        case EV_USE_ITEM7:
            ItemUse_Jetpack(ent)

        case EV_USE_ITEM8:
            //ItemUse_UseDisp(ent, HI_HEALTHDISP);
            break

        case EV_USE_ITEM9:
            //ItemUse_UseDisp(ent, HI_AMMODISP);
            break

        case EV_USE_ITEM10:
            ItemUse_UseEWeb(ent)

        case EV_USE_ITEM11:
            ItemUse_UseCloak(ent)

        default:
            break
        }
        i += 1
    }
}

/**
```
==============
SendPendingPredictableEvents
==============
```
*/
/// Source: oracle/codemp/game/g_active.c:1059
func SendPendingPredictableEvents(_ ps: JKAMP.PlayerState) {
    var t: Entity?
    let event: Int32
    let seq: Int32
    let extEvent: Int32
    let number: Int32

    // if there are still events pending
    if ps.entityEventSequence < ps.eventSequence {
        // create a temporary entity for this event which is sent to everyone
        // except the client who generated the event
        seq = ps.entityEventSequence & (MAX_PS_EVENTS - 1)
        event = ps.events[seq] | ((ps.entityEventSequence & 3) << 8)
        // set external event to zero before calling BG_PlayerStateToEntityState
        extEvent = ps.externalEvent
        ps.externalEvent = 0
        // create temporary entity for event
        t = G_TempEntity(ps.origin, event)
        number = t!.s.number
        BG_PlayerStateToEntityState(ps, t!.s, true)
        t!.s.number = number
        t!.s.eType = ET_EVENTS + event
        t!.s.eFlags |= EF_PLAYER_EVENT
        t!.s.otherEntityNum = ps.clientNum
        // send to everyone except the client who generated the event
        t!.r.svFlags |= SVF_NOTSINGLECLIENT
        t!.r.singleClient = ps.clientNum
        // set back external event
        ps.externalEvent = extEvent
    }
}

/// Source: oracle/codemp/game/g_active.c:1103
private func G_UpdateForceSightBroadcasts(_ `self`: Entity) {
    var i: Int32

    // Any clients with force sight on should see this client
    i = 0
    while i < level.numConnectedClients {
        let ent: Entity? = g_entities[level.sortedClients[i]]
        var dist: Float
        var angles = vec3_t()

        if ent == `self` {
            i += 1
            continue
        }

        // Not using force sight so we shouldnt broadcast to this one
        if !((ent!.client!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0) {
            i += 1
            continue
        }

        angles = `self`.client!.ps.origin - ent!.client!.ps.origin
        dist = VectorLengthSquared(angles)
        vectoangles(angles, &angles)

        // Too far away then just forget it
        if dist > MAX_SIGHT_DISTANCE * MAX_SIGHT_DISTANCE {
            i += 1
            continue
        }

        // If not within the field of view then forget it
        if InFieldOfVision(ent!.client!.ps.viewangles, Float(MAX_SIGHT_FOV), &angles) == 0 {
            break
        }

        // Turn on the broadcast bit for the master and since there is only one
        // master we are done
        `self`.r.broadcastClients[ent!.s.clientNum / 32] |= (1 << (ent!.s.clientNum % 32))

        break
        i += 1
    }
}

/// Source: oracle/codemp/game/g_active.c:1149
private func G_UpdateJediMasterBroadcasts(_ `self`: Entity) {
    var i: Int32

    // Not jedi master mode then nothing to do
    if g_gametype.integer != GT_JEDIMASTER {
        return
    }

    // This client isnt the jedi master so it shouldnt broadcast
    if !`self`.client!.ps.isJediMaster {
        return
    }

    // Broadcast ourself to all clients within range
    i = 0
    while i < level.numConnectedClients {
        let ent: Entity? = g_entities[level.sortedClients[i]]
        var dist: Float
        var angles = vec3_t()

        if ent == `self` {
            i += 1
            continue
        }

        angles = `self`.client!.ps.origin - ent!.client!.ps.origin
        dist = VectorLengthSquared(angles)
        vectoangles(angles, &angles)

        // Too far away then just forget it
        if dist > MAX_JEDIMASTER_DISTANCE * MAX_JEDIMASTER_DISTANCE {
            i += 1
            continue
        }

        // If not within the field of view then forget it
        if InFieldOfVision(ent!.client!.ps.viewangles, Float(MAX_JEDIMASTER_FOV), &angles) == 0 {
            i += 1
            continue
        }

        // Turn on the broadcast bit for the master and since there is only one
        // master we are done
        `self`.r.broadcastClients[ent!.s.clientNum / 32] |= (1 << (ent!.s.clientNum % 32))
        i += 1
    }
}

/// Source: oracle/codemp/game/g_active.c:1199
func G_UpdateClientBroadcasts(_ `self`: Entity) {
    // Clear all the broadcast bits for this client
    // Port-note: Raven's `memset ( self->r.broadcastClients, 0, sizeof ( self->r.broadcastClients ) )` runs over bytes that are not one record with a view.
    // Raven wrote: memset ( self->r.broadcastClients, 0, sizeof ( self->r.broadcastClients ) )
    portMissing("G_UpdateClientBroadcasts", source: "oracle/codemp/game/g_active.c:1199")

    // The jedi master is broadcast to everyone in range
    G_UpdateJediMasterBroadcasts(`self`)

    // Anyone with force sight on should see this client
    G_UpdateForceSightBroadcasts(`self`)
}

/// Source: oracle/codemp/game/g_active.c:1211
func G_AddPushVecToUcmd(_ `self`: Entity, _ ucmd: JKAMP.Usercmd) {
    var forward = vec3_t()
    var right = vec3_t()
    var moveDir = vec3_t()
    let pushSpeed: Float
    let fMove: Float
    let rMove: Float

    if `self`.client == nil {
        return
    }
    pushSpeed = VectorLengthSquared(`self`.client!.pushVec)
    if pushSpeed == 0 {
        //not being pushed
        return
    }

    // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
    var scratchUp = vec3_t()
    AngleVectors(`self`.client!.ps.viewangles, &forward, &right, &scratchUp)
    moveDir = forward * (ucmd.forwardmove / 127.0 * `self`.client!.ps.speed)
    _VectorMA(moveDir, ucmd.rightmove / 127.0 * `self`.client!.ps.speed, right, &moveDir)
    //moveDir is now our intended move velocity

    moveDir = moveDir + `self`.client!.pushVec
    `self`.client!.ps.speed = VectorNormalize(&moveDir)
    //moveDir is now our intended move velocity plus our push Vector

    fMove = Float(127.0 * Double(_DotProduct(forward, moveDir)))
    rMove = Float(127.0 * Double(_DotProduct(right, moveDir)))
    ucmd.forwardmove = Int32(floor(fMove)) //If in the same dir , will be positive
    ucmd.rightmove = Int32(floor(rMove)) //If in the same dir , will be positive

    if `self`.client!.pushVecTime < level.time {
        `self`.client!.pushVec = vec3_t()
    }
}

/// Source: oracle/codemp/game/g_active.c:1246
func G_StandingAnim(_ anim: Int32) -> Bool {
    //NOTE: does not check idles or special (cinematic) stands
    switch anim {
    case BOTH_STAND1, BOTH_STAND2, BOTH_STAND3, BOTH_STAND4:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/g_active.c:1260
func G_ActionButtonPressed(_ buttons: Int32) -> Bool {
    if (buttons & BUTTON_ATTACK) != 0 {
        return true
    } else if (buttons & BUTTON_USE_HOLDABLE) != 0 {
        return true
    } else if (buttons & BUTTON_GESTURE) != 0 {
        return true
    } else if (buttons & BUTTON_USE) != 0 {
        return true
    } else if (buttons & BUTTON_FORCEGRIP) != 0 {
        return true
    } else if (buttons & BUTTON_ALT_ATTACK) != 0 {
        return true
    } else if (buttons & BUTTON_FORCEPOWER) != 0 {
        return true
    } else if (buttons & BUTTON_FORCE_LIGHTNING) != 0 {
        return true
    } else if (buttons & BUTTON_FORCE_DRAIN) != 0 {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/g_active.c:1302
func G_CheckClientIdle(_ ent: Entity, _ ucmd: JKAMP.Usercmd) {
    var viewChange = vec3_t()
    let actionPressed: Bool
    var buttons: Int32

    if ent.client == nil || ent.health <= 0 || ent.client!.ps.stats[STAT_HEALTH] <= 0 || ent.client!.sess.sessionTeam == TEAM_SPECTATOR || (ent.client!.ps.pm_flags & PMF_FOLLOW) != 0 {
        return
    }

    buttons = ucmd.buttons

    if (ent.r.svFlags & SVF_BOT) != 0 {
        //they press use all the time..
        buttons &= ~BUTTON_USE
    }
    actionPressed = G_ActionButtonPressed(buttons)

    viewChange = ent.client!.ps.viewangles - ent.client!.idleViewAngles
    if VectorCompare(vec3_origin, ent.client!.ps.velocity) == 0 || actionPressed || ucmd.forwardmove != 0 || ucmd.rightmove != 0 || ucmd.upmove != 0 || !G_StandingAnim(ent.client!.ps.legsAnim) || (ent.health + ent.client!.ps.stats[STAT_ARMOR]) != ent.client!.idleHealth || VectorLength(viewChange) > 10 || ent.client!.ps.legsTimer > 0 || ent.client!.ps.torsoTimer > 0 || ent.client!.ps.weaponTime > 0 || ent.client!.ps.weaponstate == WEAPON_CHARGING || ent.client!.ps.weaponstate == WEAPON_CHARGING_ALT || ent.client!.ps.zoomMode != 0 || (ent.client!.ps.weaponstate != WEAPON_READY && ent.client!.ps.weapon != WP_SABER) || ent.client!.ps.forceHandExtend != HANDEXTEND_NONE || ent.client!.ps.saberBlocked != BLOCKED_NONE || ent.client!.ps.saberBlocking >= level.time || ent.client!.ps.weapon == WP_MELEE || (ent.client!.ps.weapon != ent.client!.pers.cmd.weapon && ent.s.eType != ET_NPC) {
        //FIXME: also check for turning?
        var brokeOut: Bool = false

        if VectorCompare(vec3_origin, ent.client!.ps.velocity) == 0 || actionPressed || ucmd.forwardmove != 0 || ucmd.rightmove != 0 || ucmd.upmove != 0 || (ent.health + ent.client!.ps.stats[STAT_ARMOR]) != ent.client!.idleHealth || ent.client!.ps.zoomMode != 0 || (ent.client!.ps.weaponstate != WEAPON_READY && ent.client!.ps.weapon != WP_SABER) || (ent.client!.ps.weaponTime > 0 && ent.client!.ps.weapon == WP_SABER) || ent.client!.ps.weaponstate == WEAPON_CHARGING || ent.client!.ps.weaponstate == WEAPON_CHARGING_ALT || ent.client!.ps.forceHandExtend != HANDEXTEND_NONE || ent.client!.ps.saberBlocked != BLOCKED_NONE || ent.client!.ps.saberBlocking >= level.time || ent.client!.ps.weapon == WP_MELEE || (ent.client!.ps.weapon != ent.client!.pers.cmd.weapon && ent.s.eType != ET_NPC) {
            //if in an idle, break out
            switch ent.client!.ps.legsAnim {
            case BOTH_STAND1IDLE1, BOTH_STAND2IDLE1, BOTH_STAND2IDLE2, BOTH_STAND3IDLE1, BOTH_STAND5IDLE1:
                ent.client!.ps.legsTimer = 0
                brokeOut = true

            default:
                break
            }
            switch ent.client!.ps.torsoAnim {
            case BOTH_STAND1IDLE1, BOTH_STAND2IDLE1, BOTH_STAND2IDLE2, BOTH_STAND3IDLE1, BOTH_STAND5IDLE1:
                ent.client!.ps.torsoTimer = 0
                ent.client!.ps.weaponTime = 0
                ent.client!.ps.saberMove = LS_READY
                brokeOut = true

            default:
                break
            }
        }
        //
        ent.client!.idleHealth = (ent.health + ent.client!.ps.stats[STAT_ARMOR])
        ent.client!.idleViewAngles = ent.client!.ps.viewangles
        if ent.client!.idleTime < level.time {
            ent.client!.idleTime = level.time
        }

        if brokeOut && (ent.client!.ps.weaponstate == WEAPON_CHARGING || ent.client!.ps.weaponstate == WEAPON_CHARGING_ALT) {
            ent.client!.ps.torsoAnim = TORSO_RAISEWEAP1
        }
    } else if level.time - ent.client!.idleTime > 5000 {
        //been idle for 5 seconds
        var idleAnim: Int32 = -1
        switch ent.client!.ps.legsAnim {
        case BOTH_STAND1:
            idleAnim = BOTH_STAND1IDLE1

        case BOTH_STAND2:
            idleAnim = BOTH_STAND2IDLE1 //Q_irand(BOTH_STAND2IDLE1,BOTH_STAND2IDLE2);

        case BOTH_STAND3:
            idleAnim = BOTH_STAND3IDLE1

        case BOTH_STAND5:
            idleAnim = BOTH_STAND5IDLE1

        default:
            break
        }

        if idleAnim == BOTH_STAND2IDLE1 && Q_irand(1, 10) <= 5 {
            idleAnim = BOTH_STAND2IDLE2
        }

        if idleAnim != -1 && idleAnim > 0 && idleAnim < MAX_ANIMATIONS {
            G_SetAnim(ent, ucmd, SETANIM_BOTH, idleAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)

            //don't idle again after this anim for a while
            //ent->client->idleTime = level.time + PM_AnimLength( ent->client->clientInfo.animFileIndex, (animNumber_t)idleAnim ) + Q_irand( 0, 2000 );
            ent.client!.idleTime = level.time + ent.client!.ps.legsTimer + Q_irand(0, 2000)
        }
    }
}

/// Source: oracle/codemp/game/g_active.c:1432
func NPC_Accelerate(_ ent: Entity, _ fullWalkAcc: Bool, _ fullRunAcc: Bool) {
    if ent.client == nil || ent.NPC == nil {
        return
    }

    if ent.NPC!.stats.acceleration == 0 {
        //No acceleration means just start and stop
        ent.NPC!.currentSpeed = ent.NPC!.desiredSpeed
    } else if ent.NPC!.desiredSpeed <= ent.NPC!.stats.walkSpeed {
        //FIXME:  in cinematics always accel/decel?
        //Only accelerate if at walkSpeeds
        if ent.NPC!.desiredSpeed > ent.NPC!.currentSpeed + ent.NPC!.stats.acceleration {
            //ent->client->ps.friction = 0;
            ent.NPC!.currentSpeed += ent.NPC!.stats.acceleration
        } else if ent.NPC!.desiredSpeed > ent.NPC!.currentSpeed {
            //ent->client->ps.friction = 0;
            ent.NPC!.currentSpeed = ent.NPC!.desiredSpeed
        } else if fullWalkAcc && ent.NPC!.desiredSpeed < ent.NPC!.currentSpeed - ent.NPC!.stats.acceleration {
            //decelerate even when walking
            ent.NPC!.currentSpeed -= ent.NPC!.stats.acceleration
        } else if ent.NPC!.desiredSpeed < ent.NPC!.currentSpeed {
            //stop on a dime
            ent.NPC!.currentSpeed = ent.NPC!.desiredSpeed
        }
    } else {
        //Only decelerate if at runSpeeds
        if fullRunAcc && ent.NPC!.desiredSpeed > ent.NPC!.currentSpeed + ent.NPC!.stats.acceleration {
            //Accelerate to runspeed
            //ent->client->ps.friction = 0;
            ent.NPC!.currentSpeed += ent.NPC!.stats.acceleration
        } else if ent.NPC!.desiredSpeed > ent.NPC!.currentSpeed {
            //accelerate instantly
            //ent->client->ps.friction = 0;
            ent.NPC!.currentSpeed = ent.NPC!.desiredSpeed
        } else if fullRunAcc && ent.NPC!.desiredSpeed < ent.NPC!.currentSpeed - ent.NPC!.stats.acceleration {
            ent.NPC!.currentSpeed -= ent.NPC!.stats.acceleration
        } else if ent.NPC!.desiredSpeed < ent.NPC!.currentSpeed {
            ent.NPC!.currentSpeed = ent.NPC!.desiredSpeed
        }
    }
}

/// Source: oracle/codemp/game/g_active.c:1494
private func NPC_GetWalkSpeed(_ ent: Entity) -> Int32 {
    var walkSpeed: Int32 = 0

    if (ent.client == nil) || (ent.NPC == nil) {
        return 0
    }

    switch ent.client!.playerTeam {
    default:
        walkSpeed = ent.NPC!.stats.walkSpeed
    }

    return walkSpeed
}

/**
```
-------------------------
NPC_GetRunSpeed
-------------------------
```
*/
/// Source: oracle/codemp/game/g_active.c:1517
private func NPC_GetRunSpeed(_ ent: Entity) -> Int32 {
    var runSpeed: Int32 = 0

    if (ent.client == nil) || (ent.NPC == nil) {
        return 0
    }
    /*
    switch ( ent->client->playerTeam )
    {
    case TEAM_BORG:
    runSpeed = ent->NPC->stats.runSpeed;
    runSpeed += BORG_RUN_INCR * (g_spskill->integer%3);
    break;

    case TEAM_8472:
    runSpeed = ent->NPC->stats.runSpeed;
    runSpeed += SPECIES_RUN_INCR * (g_spskill->integer%3);
    break;

    case TEAM_STASIS:
    runSpeed = ent->NPC->stats.runSpeed;
    runSpeed += STASIS_RUN_INCR * (g_spskill->integer%3);
    break;

    case TEAM_BOTS:
    runSpeed = ent->NPC->stats.runSpeed;
    break;

    default:
    runSpeed = ent->NPC->stats.runSpeed;
    break;
    }
    */
    // team no longer indicates species/race.  Use NPC_class to adjust speed for specific npc types
    switch ent.client!.NPC_class {
    case CLASS_PROBE, CLASS_GONK, CLASS_R2D2, CLASS_R5D2, CLASS_MARK1, CLASS_MARK2, CLASS_PROTOCOL, CLASS_ATST, CLASS_MOUSE, CLASS_SEEKER, CLASS_REMOTE:
        runSpeed = ent.NPC!.stats.runSpeed

    default:
        runSpeed = Int32(ent.NPC!.stats.runSpeed * 1.3) //rww - seems to slow in MP for some reason.
    }

    return runSpeed
}

/// Source: oracle/codemp/game/g_active.c:1577
func G_CheckMovingLoopingSounds(_ ent: Entity, _ ucmd: JKAMP.Usercmd) {
    if ent.client != nil {
        if (ent.NPC != nil && VectorCompare(vec3_origin, ent.client!.ps.moveDir) == 0) || ucmd.forwardmove != 0 || ucmd.rightmove != 0 || (ucmd.upmove != 0 && FlyingCreature(ent)) || (FlyingCreature(ent) && VectorCompare(vec3_origin, ent.client!.ps.velocity) == 0 && ent.health > 0) {
            switch ent.client!.NPC_class {
            case CLASS_R2D2:
                ent.s.loopSound = G_SoundIndex("sound/chars/r2d2/misc/r2_move_lp.wav")

            case CLASS_R5D2:
                ent.s.loopSound = G_SoundIndex("sound/chars/r2d2/misc/r2_move_lp2.wav")

            case CLASS_MARK2:
                ent.s.loopSound = G_SoundIndex("sound/chars/mark2/misc/mark2_move_lp")

            case CLASS_MOUSE:
                ent.s.loopSound = G_SoundIndex("sound/chars/mouse/misc/mouse_lp")

            case CLASS_PROBE:
                ent.s.loopSound = G_SoundIndex("sound/chars/probe/misc/probedroidloop")

            default:
                break
            }
        } else {
            //not moving under your own control, stop loopSound
            if ent.client!.NPC_class == CLASS_R2D2 || ent.client!.NPC_class == CLASS_R5D2 || ent.client!.NPC_class == CLASS_MARK2 || ent.client!.NPC_class == CLASS_MOUSE || ent.client!.NPC_class == CLASS_PROBE {
                ent.s.loopSound = 0
            }
        }
    }
}

/// Source: oracle/codemp/game/g_active.c:1616
func G_HeldByMonster(_ ent: Entity, _ ucmd: inout JKAMP.Usercmd?) {
    if ent.client != nil && ent.client!.ps.hasLookTarget {
        let monster: Entity? = g_entities[ent.client!.ps.lookTarget]
        if monster != nil && monster!.client != nil {
            //take the monster's waypoint as your own
            ent.waypoint = monster!.waypoint
            if monster!.s.NPC_class == CLASS_RANCOR {
                //only possibility right now, may add Wampa and Sand Creature later
                // Port-note: NULL for an inout parameter the draft has no scratch shape for.
                // Raven wrote: BG_AttachToRancor( monster->ghoul2, //ghoul2 info monster->r.currentAngles[YAW], monster->r.currentOrigin, level.time, NULL, monster->modelScale, (monster->client->ps.eFlags2&EF2_GENERIC_NPC_FLAG), ent->client->ps.origin, ent->client->ps.viewangles, NULL )
                portMissing("G_HeldByMonster", source: "oracle/codemp/game/g_active.c:1616")
            }
            ent.client!.ps.velocity = vec3_t()
            G_SetOrigin(ent, &ent.client!.ps.origin)
            SetClientViewAngle(ent, ent.client!.ps.viewangles)
            G_SetAngles(ent, ent.client!.ps.viewangles)
            trap_LinkEntity(ent) //redundant?
        }
    }
    // don't allow movement, weapon switching, and most kinds of button presses
    ucmd!.forwardmove = 0
    ucmd!.rightmove = 0
    ucmd!.upmove = 0
}

/// Source: oracle/codemp/game/g_active.c:1662
func G_SetTauntAnim(_ ent: Entity, _ taunt: Int32) {
    if ent.client!.pers.cmd.upmove != 0 || ent.client!.pers.cmd.forwardmove != 0 || ent.client!.pers.cmd.rightmove != 0 {
        //hack, don't do while moving
        return
    }
    if taunt != TAUNT_TAUNT {
        //normal taunt always allowed
        if g_gametype.integer != GT_DUEL && g_gametype.integer != GT_POWERDUEL {
            //no taunts unless in Duel
            return
        }
    }
    if ent.client!.ps.torsoTimer < 1 && ent.client!.ps.forceHandExtend == HANDEXTEND_NONE && ent.client!.ps.legsTimer < 1 && ent.client!.ps.weaponTime < 1 && ent.client!.ps.saberLockTime < level.time {
        var anim: Int32 = -1
        switch taunt {
        case TAUNT_TAUNT:
            // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
            // Both read as the same Swift test, so the draft writes it once.
            if ent.client!.ps.weapon != WP_SABER {
                anim = BOTH_ENGAGETAUNT
            } else if ent.client!.saber[0].tauntAnim != -1 {
                anim = ent.client!.saber[0].tauntAnim
            } else if !ent.client!.saber[1].model.isEmpty && ent.client!.saber[1].tauntAnim != -1 {
                anim = ent.client!.saber[1].tauntAnim
            } else {
                switch ent.client!.ps.fd.saberAnimLevel {
                case SS_FAST, SS_TAVION:
                    // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
                    // Both read as the same Swift test, so the draft writes it once.
                    if ent.client!.ps.saberHolstered == 1 && !ent.client!.saber[1].model.isEmpty {
                        //turn off second saber
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[1].soundOff)
                    } else if ent.client!.ps.saberHolstered == 0 {
                        //turn off first
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOff)
                    }
                    ent.client!.ps.saberHolstered = 2
                    anim = BOTH_GESTURE1

                case SS_MEDIUM, SS_STRONG, SS_DESANN:
                    anim = BOTH_ENGAGETAUNT

                case SS_DUAL:
                    // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
                    // Both read as the same Swift test, so the draft writes it once.
                    if ent.client!.ps.saberHolstered == 1 && !ent.client!.saber[1].model.isEmpty {
                        //turn on second saber
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[1].soundOn)
                    } else if ent.client!.ps.saberHolstered == 2 {
                        //turn on first
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOn)
                    }
                    ent.client!.ps.saberHolstered = 0
                    anim = BOTH_DUAL_TAUNT

                case SS_STAFF:
                    if ent.client!.ps.saberHolstered > 0 {
                        //turn on all blades
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOn)
                    }
                    ent.client!.ps.saberHolstered = 0
                    anim = BOTH_STAFF_TAUNT

                default:
                    break
                }
            }

        case TAUNT_BOW:
            // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
            // Both read as the same Swift test, so the draft writes it once.
            if ent.client!.saber[0].bowAnim != -1 {
                anim = ent.client!.saber[0].bowAnim
            } else if !ent.client!.saber[1].model.isEmpty && ent.client!.saber[1].bowAnim != -1 {
                anim = ent.client!.saber[1].bowAnim
            } else {
                anim = BOTH_BOW
            }
            // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
            // Both read as the same Swift test, so the draft writes it once.
            if ent.client!.ps.saberHolstered == 1 && !ent.client!.saber[1].model.isEmpty {
                //turn off second saber
                G_Sound(ent, CHAN_WEAPON, ent.client!.saber[1].soundOff)
            } else if ent.client!.ps.saberHolstered == 0 {
                //turn off first
                G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOff)
            }
            ent.client!.ps.saberHolstered = 2

        case TAUNT_MEDITATE:
            // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
            // Both read as the same Swift test, so the draft writes it once.
            if ent.client!.saber[0].meditateAnim != -1 {
                anim = ent.client!.saber[0].meditateAnim
            } else if !ent.client!.saber[1].model.isEmpty && ent.client!.saber[1].meditateAnim != -1 {
                anim = ent.client!.saber[1].meditateAnim
            } else {
                anim = BOTH_MEDITATE
            }
            // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
            // Both read as the same Swift test, so the draft writes it once.
            if ent.client!.ps.saberHolstered == 1 && !ent.client!.saber[1].model.isEmpty {
                //turn off second saber
                G_Sound(ent, CHAN_WEAPON, ent.client!.saber[1].soundOff)
            } else if ent.client!.ps.saberHolstered == 0 {
                //turn off first
                G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOff)
            }
            ent.client!.ps.saberHolstered = 2

        case TAUNT_FLOURISH:
            if ent.client!.ps.weapon == WP_SABER {
                // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
                // Both read as the same Swift test, so the draft writes it once.
                if ent.client!.ps.saberHolstered == 1 && !ent.client!.saber[1].model.isEmpty {
                    //turn on second saber
                    G_Sound(ent, CHAN_WEAPON, ent.client!.saber[1].soundOn)
                } else if ent.client!.ps.saberHolstered == 2 {
                    //turn on first
                    G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOn)
                }
                ent.client!.ps.saberHolstered = 0
                // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
                // Both read as the same Swift test, so the draft writes it once.
                if ent.client!.saber[0].flourishAnim != -1 {
                    anim = ent.client!.saber[0].flourishAnim
                } else if !ent.client!.saber[1].model.isEmpty && ent.client!.saber[1].flourishAnim != -1 {
                    anim = ent.client!.saber[1].flourishAnim
                } else {
                    switch ent.client!.ps.fd.saberAnimLevel {
                    case SS_FAST, SS_TAVION:
                        anim = BOTH_SHOWOFF_FAST

                    case SS_MEDIUM:
                        anim = BOTH_SHOWOFF_MEDIUM

                    case SS_STRONG, SS_DESANN:
                        anim = BOTH_SHOWOFF_STRONG

                    case SS_DUAL:
                        anim = BOTH_SHOWOFF_DUAL

                    case SS_STAFF:
                        anim = BOTH_SHOWOFF_STAFF

                    default:
                        break
                    }
                }
            }

        case TAUNT_GLOAT:
            // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
            // Both read as the same Swift test, so the draft writes it once.
            if ent.client!.saber[0].gloatAnim != -1 {
                anim = ent.client!.saber[0].gloatAnim
            } else if !ent.client!.saber[1].model.isEmpty && ent.client!.saber[1].gloatAnim != -1 {
                anim = ent.client!.saber[1].gloatAnim
            } else {
                switch ent.client!.ps.fd.saberAnimLevel {
                case SS_FAST, SS_TAVION:
                    anim = BOTH_VICTORY_FAST

                case SS_MEDIUM:
                    anim = BOTH_VICTORY_MEDIUM

                case SS_STRONG, SS_DESANN:
                    if ent.client!.ps.saberHolstered != 0 {
                        //turn on first
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOn)
                    }
                    ent.client!.ps.saberHolstered = 0
                    anim = BOTH_VICTORY_STRONG

                case SS_DUAL:
                    // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
                    // Both read as the same Swift test, so the draft writes it once.
                    if ent.client!.ps.saberHolstered == 1 && !ent.client!.saber[1].model.isEmpty {
                        //turn on second saber
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[1].soundOn)
                    } else if ent.client!.ps.saberHolstered == 2 {
                        //turn on first
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOn)
                    }
                    ent.client!.ps.saberHolstered = 0
                    anim = BOTH_VICTORY_DUAL

                case SS_STAFF:
                    if ent.client!.ps.saberHolstered != 0 {
                        //turn on first
                        G_Sound(ent, CHAN_WEAPON, ent.client!.saber[0].soundOn)
                    }
                    ent.client!.ps.saberHolstered = 0
                    anim = BOTH_VICTORY_STAFF

                default:
                    break
                }
            }

        default:
            break
        }
        if anim != -1 {
            if ent.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                ent.client!.ps.forceHandExtend = HANDEXTEND_TAUNT
                ent.client!.ps.forceDodgeAnim = anim
                ent.client!.ps.forceHandExtendTime = level.time + BG_AnimLength(ent.localAnimIndex, animNumber_t(anim))
            }
            if taunt != TAUNT_MEDITATE && taunt != TAUNT_BOW {
                //no sound for meditate or bow
                G_AddEvent(ent, EV_TAUNT, taunt)
            }
        }
    }
}

/**
```
==============
ClientThink

This will be called once for each client frame, which will
usually be a couple times for each server frame on fast clients.

If "g_synchronousClients 1" is set, this will be called exactly
once for each server frame, which makes for smooth demo recording.
==============
```
*/
/// Source: oracle/codemp/game/g_active.c:1939
func ClientThink_real(_ ent: Entity) {
    var client: Client?
    // Pmove names both the view and the function, so the module name selects the view.
    // Raven's record lives to the end of the function, so the rest of the body is the closure.
    JKAMP.Pmove.scratch { pm in
        var oldEventSequence: Int32 = 0
        var msec: Int32 = 0
        var ucmd: Usercmd?
        var isNPC: Bool = false
        let controlledByPlayer: Bool = false
        var killJetFlags: Bool = true

        client = ent.client

        if ent.s.eType == ET_NPC {
            isNPC = true
        }

        // don't think if the client is not yet connected (and thus not yet spawned in)
        if client!.pers.connected != CON_CONNECTED && !isNPC {
            return
        }

        // This code was moved here from clientThink to fix a problem with g_synchronousClients
        // being set to 1 when in vehicles.
        if ent.s.number < MAX_CLIENTS && ent.client!.ps.m_iVehicleNum != 0 {
            //driving a vehicle
            if g_entities[ent.client!.ps.m_iVehicleNum].client != nil {
                let veh: Entity? = g_entities[ent.client!.ps.m_iVehicleNum]

                if veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pPilot == BgEntity(ent) {
                    //only take input from the pilot...
                    veh!.client!.ps.commandTime = ent.client!.ps.commandTime
                    veh!.m_pVehicle!.m_ucmd.copy(from: ent.client!.pers.cmd)
                    if (veh!.m_pVehicle!.m_ucmd.buttons & BUTTON_TALK) != 0 {
                        //forced input if "chat bubble" is up
                        veh!.m_pVehicle!.m_ucmd.buttons = BUTTON_TALK
                        veh!.m_pVehicle!.m_ucmd.forwardmove = 0
                        veh!.m_pVehicle!.m_ucmd.rightmove = 0
                        veh!.m_pVehicle!.m_ucmd.upmove = 0
                    }
                }
            }
        }

        if !((client!.ps.pm_flags & PMF_FOLLOW) != 0) {
            if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 && bgSiegeClasses[client!.siegeClass].saberStance != 0 {
                //the class says we have to use this stance set.
                if !((bgSiegeClasses[client!.siegeClass].saberStance & (1 << client!.ps.fd.saberAnimLevel)) != 0) {
                    //the current stance is not in the bitmask, so find the first one that is.
                    var i: Int32 = SS_FAST

                    while i < SS_NUM_SABER_STYLES {
                        if (bgSiegeClasses[client!.siegeClass].saberStance & (1 << i)) != 0 {
                            if i == SS_DUAL && client!.ps.saberHolstered == 1 {
                                //one saber should be off, adjust saberAnimLevel accordinly
                                client!.ps.fd.saberAnimLevelBase = i
                                client!.ps.fd.saberAnimLevel = SS_FAST
                                client!.ps.fd.saberDrawAnimLevel = client!.ps.fd.saberAnimLevel
                            } else if i == SS_STAFF && client!.ps.saberHolstered == 1 && client!.saber[0].singleBladeStyle != SS_NONE {
                                //one saber or blade should be off, adjust saberAnimLevel accordinly
                                client!.ps.fd.saberAnimLevelBase = i
                                client!.ps.fd.saberAnimLevel = client!.saber[0].singleBladeStyle
                                client!.ps.fd.saberDrawAnimLevel = client!.ps.fd.saberAnimLevel
                            } else {
                                client!.ps.fd.saberAnimLevel = i
                                client!.ps.fd.saberAnimLevelBase = client!.ps.fd.saberAnimLevel
                                client!.ps.fd.saberDrawAnimLevel = i
                            }
                            break
                        }

                        i += 1
                    }
                }
            } else if !client!.saber[0].model.isEmpty && !client!.saber[1].model.isEmpty {
                //with two sabs always use akimbo style
                if client!.ps.saberHolstered == 1 {
                    //one saber should be off, adjust saberAnimLevel accordinly
                    client!.ps.fd.saberAnimLevelBase = SS_DUAL
                    client!.ps.fd.saberAnimLevel = SS_FAST
                    client!.ps.fd.saberDrawAnimLevel = client!.ps.fd.saberAnimLevel
                } else {
                    if !WP_SaberStyleValidForSaber(client!.saber[0], client!.saber[1], client!.ps.saberHolstered, client!.ps.fd.saberAnimLevel) {
                        //only use dual style if the style we're trying to use isn't valid
                        client!.ps.fd.saberAnimLevel = SS_DUAL
                        client!.ps.fd.saberAnimLevelBase = client!.ps.fd.saberAnimLevel
                    }
                    client!.ps.fd.saberDrawAnimLevel = client!.ps.fd.saberAnimLevel
                }
            } else {
                if client!.saber[0].stylesLearned == (1 << SS_STAFF) {
                    //then *always* use the staff style
                    client!.ps.fd.saberAnimLevelBase = SS_STAFF
                }
                if client!.ps.fd.saberAnimLevelBase == SS_STAFF {
                    //using staff style
                    if client!.ps.saberHolstered == 1 && client!.saber[0].singleBladeStyle != SS_NONE {
                        //one blade should be off, adjust saberAnimLevel accordinly
                        client!.ps.fd.saberAnimLevel = client!.saber[0].singleBladeStyle
                        client!.ps.fd.saberDrawAnimLevel = client!.ps.fd.saberAnimLevel
                    } else {
                        client!.ps.fd.saberAnimLevel = SS_STAFF
                        client!.ps.fd.saberDrawAnimLevel = client!.ps.fd.saberAnimLevel
                    }
                }
            }
        }

        // mark the time, so the connection sprite can be removed
        ucmd = ent.client!.pers.cmd

        if client != nil && (client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
            G_HeldByMonster(ent, &ucmd)
        }

        // sanity check the command time to prevent speedup cheating
        if ucmd!.serverTime > level.time + 200 {
            ucmd!.serverTime = level.time + 200
            //		G_Printf("serverTime <<<<<\n" );
        }
        if ucmd!.serverTime < level.time - 1000 {
            ucmd!.serverTime = level.time - 1000
            //		G_Printf("serverTime >>>>>\n" );
        }

        if isNPC && (ucmd!.serverTime - client!.ps.commandTime) < 1 {
            ucmd!.serverTime = client!.ps.commandTime + 100
        }

        msec = ucmd!.serverTime - client!.ps.commandTime
        // following others may result in bad times, but we still want
        // to check for follow toggles
        if msec < 1 && client!.sess.spectatorState != SPECTATOR_FOLLOW {
            return
        }

        if msec > 200 {
            msec = 200
        }

        if pmove_msec.integer < 8 {
            trap_Cvar_Set("pmove_msec", "8")
        } else if pmove_msec.integer > 33 {
            trap_Cvar_Set("pmove_msec", "33")
        }

        if pmove_fixed.integer != 0 || client!.pers.pmoveFixed {
            ucmd!.serverTime = ((ucmd!.serverTime + pmove_msec.integer - 1) / pmove_msec.integer) * pmove_msec.integer
            //if (ucmd->serverTime - client->ps.commandTime <= 0)
            //	return;
        }

        //
        // check for exiting intermission
        //
        if level.intermissiontime != 0 {
            if ent.s.number < MAX_CLIENTS || client!.NPC_class == CLASS_VEHICLE {
                //players and vehicles do nothing in intermissions
                ClientIntermissionThink(client!)
                return
            }
        }

        // spectators don't do much
        if client!.sess.sessionTeam == TEAM_SPECTATOR || client!.tempSpectate > level.time {
            if client!.sess.spectatorState == SPECTATOR_SCOREBOARD {
                return
            }
            SpectatorThink(ent, ucmd!)
            return
        }

        if ent.client != nil && (ent.client!.ps.eFlags & EF_INVULNERABLE) != 0 {
            if ent.client!.invulnerableTimer <= level.time {
                ent.client!.ps.eFlags &= ~EF_INVULNERABLE
            }
        }

        if ent.s.eType != ET_NPC {
            // check for inactivity timer, but never drop the local client of a non-dedicated server
            if !ClientInactivityTimer(client!) {
                return
            }
        }

        //Check if we should have a fullbody push effect around the player
        if client!.pushEffectTime > level.time {
            client!.ps.eFlags |= EF_BODYPUSH
        } else if client!.pushEffectTime != 0 {
            client!.pushEffectTime = 0
            client!.ps.eFlags &= ~EF_BODYPUSH
        }

        if (client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_JETPACK)) != 0 {
            client!.ps.eFlags |= EF_JETPACK
        } else {
            client!.ps.eFlags &= ~EF_JETPACK
        }

        if client!.noclip {
            client!.ps.pm_type = PM_NOCLIP
        } else if (client!.ps.eFlags & EF_DISINTEGRATION) != 0 {
            client!.ps.pm_type = PM_NOCLIP
        } else if client!.ps.stats[STAT_HEALTH] <= 0 {
            client!.ps.pm_type = PM_DEAD
        } else {
            if client!.ps.forceGripChangeMovetype != 0 {
                client!.ps.pm_type = client!.ps.forceGripChangeMovetype
            } else {
                if client!.jetPackOn {
                    client!.ps.pm_type = PM_JETPACK
                    client!.ps.eFlags |= EF_JETPACK_ACTIVE
                    killJetFlags = false
                } else {
                    client!.ps.pm_type = PM_NORMAL
                }
            }
        }

        if killJetFlags {
            client!.ps.eFlags &= ~EF_JETPACK_ACTIVE
            client!.ps.eFlags &= ~EF_JETPACK_FLAMING
        }


        if client!.bodyGrabIndex != ENTITYNUM_NONE {
            let grabbed: Entity? = g_entities[client!.bodyGrabIndex]

            if !grabbed!.inuse || grabbed!.s.eType != ET_BODY || (grabbed!.s.eFlags & EF_DISINTEGRATION) != 0 || (grabbed!.s.eFlags & EF_NODRAW) != 0 {
                if grabbed!.inuse && grabbed!.s.eType == ET_BODY {
                    grabbed!.s.ragAttach = 0
                }
                client!.bodyGrabIndex = ENTITYNUM_NONE
            } else {
                // Raven's record lives to the end of his block, so the block is the closure.
                MdxaBone.scratch { rhMat in
                    var rhOrg = vec3_t()
                    var tAng = vec3_t()
                    var bodyDir = vec3_t()
                    var bodyDist: Float = 0

                    ent.client!.ps.forceHandExtend = HANDEXTEND_DRAGGING

                    if ent.client!.ps.forceHandExtendTime < level.time + 500 {
                        ent.client!.ps.forceHandExtendTime = level.time + 1000
                    }

                    tAng = vec3_t(0, ent.client!.ps.viewangles[YAW], 0)
                    trap_G2API_GetBoltMatrix(ent.ghoul2, 0, 0, rhMat, tAng, ent.client!.ps.origin, level.time, nil, &ent.modelScale) //0 is always going to be right hand bolt
                    BG_GiveMeVectorFromMatrix(rhMat, ORIGIN, &rhOrg)

                    bodyDir = rhOrg - grabbed!.r.currentOrigin
                    bodyDist = VectorLength(bodyDir)

                    if bodyDist > 40.0 {
                        //can no longer reach
                        grabbed!.s.ragAttach = 0
                        client!.bodyGrabIndex = ENTITYNUM_NONE
                    } else if bodyDist > 24.0 {
                        bodyDir[2] = 0 //don't want it floating
                        //VectorScale(bodyDir, 0.1f, bodyDir);
                        grabbed!.epVelocity = grabbed!.epVelocity + bodyDir
                        G_Sound(grabbed!, CHAN_AUTO, G_SoundIndex("sound/player/roll1.wav"))
                    }
                }
            }
        } else if ent.client!.ps.forceHandExtend == HANDEXTEND_DRAGGING {
            ent.client!.ps.forceHandExtend = HANDEXTEND_WEAPONREADY
        }

        if ent.NPC != nil && ent.s.NPC_class != CLASS_VEHICLE {
            //FIXME: swoop should keep turning (and moving forward?) for a little bit?
            if ent.NPC!.combatMove == false {
                //if ( !(ucmd->buttons & BUTTON_USE) )
                if 1 != 0 {
                    //Not leaning
                    let Flying: Bool = (ucmd!.upmove != 0 && (ent.client!.ps.eFlags2 & EF2_FLYING) != 0)
                    let Climbing: Bool = (ucmd!.upmove != 0 && (ent.watertype & CONTENTS_LADDER) != 0)

                    //client->ps.friction = 6;

                    if ucmd!.forwardmove != 0 || ucmd!.rightmove != 0 || Flying {
                        //if ( ent->NPC->behaviorState != BS_FORMATION )
                        do {
                            //In - Formation NPCs set thier desiredSpeed themselves
                            if (ucmd!.buttons & BUTTON_WALKING) != 0 {
                                ent.NPC!.desiredSpeed = NPC_GetWalkSpeed(ent) //ent->NPC->stats.walkSpeed;
                            } else {
                                ent.NPC!.desiredSpeed = NPC_GetRunSpeed(ent) //ent->NPC->stats.runSpeed;
                            }

                            if ent.NPC!.currentSpeed >= 80 && !controlledByPlayer {
                                //At higher speeds, need to slow down close to stuff
                                //Slow down as you approach your goal
                                //	if ( ent->NPC->distToGoal < SLOWDOWN_DIST && client->race != RACE_BORG && !(ent->NPC->aiFlags&NPCAI_NO_SLOWDOWN) )//128
                                if ent.NPC!.distToGoal < SLOWDOWN_DIST && !((ent.NPC!.aiFlags & NPCAI_NO_SLOWDOWN) != 0) {
                                    if ent.NPC!.desiredSpeed > MIN_NPC_SPEED {
                                        let slowdownSpeed: Float = (Float(ent.NPC!.desiredSpeed)) * ent.NPC!.distToGoal / SLOWDOWN_DIST

                                        ent.NPC!.desiredSpeed = Int32(ceil(slowdownSpeed))
                                        if ent.NPC!.desiredSpeed < MIN_NPC_SPEED {
                                            //don't slow down too much
                                            ent.NPC!.desiredSpeed = Int32(MIN_NPC_SPEED)
                                        }
                                    }
                                }
                            }
                        }
                    } else if Climbing {
                        ent.NPC!.desiredSpeed = ent.NPC!.stats.walkSpeed
                    } else {
                        //We want to stop
                        ent.NPC!.desiredSpeed = 0
                    }

                    NPC_Accelerate(ent, false, false)

                    if ent.NPC!.currentSpeed <= 24 && ent.NPC!.desiredSpeed < ent.NPC!.currentSpeed {
                        //No-one walks this slow
                        ent.NPC!.currentSpeed = 0 //Full stop
                        client!.ps.speed = Float(ent.NPC!.currentSpeed) //Full stop
                        ucmd!.forwardmove = 0
                        ucmd!.rightmove = 0
                    } else {
                        if ent.NPC!.currentSpeed <= ent.NPC!.stats.walkSpeed {
                            //Play the walkanim
                            ucmd!.buttons |= BUTTON_WALKING
                        } else {
                            ucmd!.buttons &= ~BUTTON_WALKING
                        }

                        if ent.NPC!.currentSpeed > 0 {
                            //We should be moving
                            if Climbing || Flying {
                                if ucmd!.upmove == 0 {
                                    //We need to force them to take a couple more steps until stopped
                                    ucmd!.upmove = ent.NPC!.last_ucmd.upmove //was last_upmove;
                                }
                            } else if ucmd!.forwardmove == 0 && ucmd!.rightmove == 0 {
                                //We need to force them to take a couple more steps until stopped
                                ucmd!.forwardmove = ent.NPC!.last_ucmd.forwardmove //was last_forwardmove;
                                ucmd!.rightmove = ent.NPC!.last_ucmd.rightmove //was last_rightmove;
                            }
                        }

                        client!.ps.speed = Float(ent.NPC!.currentSpeed)
                        //	if ( player && player->client && player->client->ps.viewEntity == ent->s.number )
                        //	{
                        //	}
                        //	else
                        //rwwFIXMEFIXME: do this and also check for all real client
                        if 1 != 0 {
                            //Slow down on turns - don't orbit!!!
                            var turndelta: Float = 0
                            // if the NPC is locked into a Yaw, we want to check the lockedDesiredYaw...otherwise the NPC can't walk backwards, because it always thinks it trying to turn according to desiredYaw
                            //if( client->renderInfo.renderFlags & RF_LOCKEDANGLE ) // yeah I know the RF_ flag is a pretty ugly hack...
                            if 0 != 0 {
                                turndelta = (180 - abs(AngleDelta(ent.r.currentAngles[YAW], ent.NPC!.lockedDesiredYaw))) / 180
                            } else {
                                turndelta = (180 - abs(AngleDelta(ent.r.currentAngles[YAW], ent.NPC!.desiredYaw))) / 180
                            }

                            if turndelta < 0.75 {
                                client!.ps.speed = 0
                            } else if ent.NPC!.distToGoal < 100 && Double(turndelta) < 1.0 {
                                //Turn is greater than 45 degrees or closer than 100 to goal
                                client!.ps.speed = floor((Float((client!.ps.speed))) * turndelta)
                            }
                        }
                    }
                }
            } else {
                ent.NPC!.desiredSpeed = (ucmd!.buttons & BUTTON_WALKING) != 0 ? NPC_GetWalkSpeed(ent) : NPC_GetRunSpeed(ent)

                client!.ps.speed = Float(ent.NPC!.desiredSpeed)
            }

            if (ucmd!.buttons & BUTTON_WALKING) != 0 {
                //sort of a hack I guess since MP handles walking differently from SP (has some proxy cheat prevention methods)
                /*
                if (ent->client->ps.speed > 64)
                {
                ent->client->ps.speed = 64;
                }
                */

                if ucmd!.forwardmove > 64 {
                    ucmd!.forwardmove = 64
                } else if ucmd!.forwardmove < -64 {
                    ucmd!.forwardmove = -64
                }

                if ucmd!.rightmove > 64 {
                    ucmd!.rightmove = 64
                } else if ucmd!.rightmove < -64 {
                    ucmd!.rightmove = -64
                }

                //ent->client->ps.speed = ent->client->ps.basespeed = NPC_GetRunSpeed( ent );
            }
            client!.ps.basespeed = Int32(client!.ps.speed)
        } else if client!.ps.m_iVehicleNum == 0 && (ent.NPC == nil || ent.s.NPC_class != CLASS_VEHICLE) {
            // set speed
            client!.ps.speed = g_speed.value

            //Check for a siege class speed multiplier
            if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 {
                client!.ps.speed *= bgSiegeClasses[client!.siegeClass].speed
            }

            if client!.bodyGrabIndex != ENTITYNUM_NONE {
                //can't go nearly as fast when dragging a body around
                client!.ps.speed *= 0.2
            }

            client!.ps.basespeed = Int32(client!.ps.speed)
        }

        if ent.NPC == nil || !((ent.NPC!.aiFlags & NPCAI_CUSTOM_GRAVITY) != 0) {
            //use global gravity
            if ent.NPC != nil && ent.s.NPC_class == CLASS_VEHICLE && ent.m_pVehicle != nil && ent.m_pVehicle!.m_pVehicleInfo!.gravity != 0 {
                //use custom veh gravity
                client!.ps.gravity = ent.m_pVehicle!.m_pVehicleInfo!.gravity
            } else {
                if ent.client!.inSpaceIndex != 0 && ent.client!.inSpaceIndex != ENTITYNUM_NONE {
                    //in space, so no gravity...
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Double' to type 'Int32'".
                    // Raven wrote: client->ps.gravity = 1.0f
                    portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
                    if ent.s.number < MAX_CLIENTS {
                        client!.ps.velocity = client!.ps.velocity * 0.8
                    }
                } else {
                    if (client!.ps.eFlags2 & EF2_SHIP_DEATH) != 0 {
                        //float there
                        client!.ps.velocity = vec3_t()
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Double' to type 'Int32'".
                        // Raven wrote: client->ps.gravity = 1.0f
                        portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
                    } else {
                        client!.ps.gravity = Int32(g_gravity.value)
                    }
                }
            }
        }

        if ent.client!.ps.duelInProgress {
            let duelAgainst: Entity? = g_entities[ent.client!.ps.duelIndex]

            //Keep the time updated, so once this duel ends this player can't engage in a duel for another
            //10 seconds. This will give other people a chance to engage in duels in case this player wants
            //to engage again right after he's done fighting and someone else is waiting.
            ent.client!.ps.fd.privateDuelTime = level.time + 10000

            if ent.client!.ps.duelTime < level.time {
                //Bring out the sabers
                if ent.client!.ps.weapon == WP_SABER && ent.client!.ps.saberHolstered != 0 && ent.client!.ps.duelTime != 0 {
                    ent.client!.ps.saberHolstered = 0

                    if ent.client!.saber[0].soundOn != 0 {
                        G_Sound(ent, CHAN_AUTO, ent.client!.saber[0].soundOn)
                    }
                    if ent.client!.saber[1].soundOn != 0 {
                        G_Sound(ent, CHAN_AUTO, ent.client!.saber[1].soundOn)
                    }

                    G_AddEvent(ent, EV_PRIVATE_DUEL, 2)

                    ent.client!.ps.duelTime = 0
                }

                if duelAgainst != nil && duelAgainst!.client != nil && duelAgainst!.inuse && duelAgainst!.client!.ps.weapon == WP_SABER && duelAgainst!.client!.ps.saberHolstered != 0 && duelAgainst!.client!.ps.duelTime != 0 {
                    duelAgainst!.client!.ps.saberHolstered = 0

                    if duelAgainst!.client!.saber[0].soundOn != 0 {
                        G_Sound(duelAgainst!, CHAN_AUTO, duelAgainst!.client!.saber[0].soundOn)
                    }
                    if duelAgainst!.client!.saber[1].soundOn != 0 {
                        G_Sound(duelAgainst!, CHAN_AUTO, duelAgainst!.client!.saber[1].soundOn)
                    }

                    G_AddEvent(duelAgainst!, EV_PRIVATE_DUEL, 2)

                    duelAgainst!.client!.ps.duelTime = 0
                }
            } else {
                client!.ps.speed = 0
                client!.ps.basespeed = 0
                ucmd!.forwardmove = 0
                ucmd!.rightmove = 0
                ucmd!.upmove = 0
            }

            if duelAgainst == nil || duelAgainst!.client == nil || !duelAgainst!.inuse || duelAgainst!.client!.ps.duelIndex != ent.s.number {
                ent.client!.ps.duelInProgress = 0 != 0
                G_AddEvent(ent, EV_PRIVATE_DUEL, 0)
            } else if duelAgainst!.health < 1 || duelAgainst!.client!.ps.stats[STAT_HEALTH] < 1 {
                ent.client!.ps.duelInProgress = 0 != 0
                duelAgainst!.client!.ps.duelInProgress = 0 != 0

                G_AddEvent(ent, EV_PRIVATE_DUEL, 0)
                G_AddEvent(duelAgainst!, EV_PRIVATE_DUEL, 0)

                //Winner gets full health.. providing he's still alive
                if ent.health > 0 && ent.client!.ps.stats[STAT_HEALTH] > 0 {
                    if ent.health < ent.client!.ps.stats[STAT_MAX_HEALTH] {
                        ent.health = ent.client!.ps.stats[STAT_MAX_HEALTH]
                        ent.client!.ps.stats[STAT_HEALTH] = ent.health
                    }

                    if g_spawnInvulnerability.integer != 0 {
                        ent.client!.ps.eFlags |= EF_INVULNERABLE
                        ent.client!.invulnerableTimer = level.time + g_spawnInvulnerability.integer
                    }
                }

                /*
                trap_SendServerCommand( ent-g_entities, va("print \"%s %s\n\"", ent->client->pers.netname, G_GetStringEdString("MP_SVGAME", "PLDUELWINNER")) );
                trap_SendServerCommand( duelAgainst-g_entities, va("print \"%s %s\n\"", ent->client->pers.netname, G_GetStringEdString("MP_SVGAME", "PLDUELWINNER")) );
                */
                //Private duel announcements are now made globally because we only want one duel at a time.
                if ent.health > 0 && ent.client!.ps.stats[STAT_HEALTH] > 0 {
                    // Port-note: Raven passes `"MP_SVGAME"` to `G_GetStringEdString`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                    // Raven wrote: trap_SendServerCommand( -1, va("cp \"%s %s %s!\n\"", ent->client->pers.netname, G_GetStringEdString("MP_SVGAME", "PLDUELWINNER"), duelAgainst->client->pers.netname) )
                    portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
                } else {
                    //it was a draw, because we both managed to die in the same frame
                    // Port-note: Raven passes `"MP_SVGAME"` to `G_GetStringEdString`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                    // Raven wrote: trap_SendServerCommand( -1, va("cp \"%s\n\"", G_GetStringEdString("MP_SVGAME", "PLDUELTIE")) )
                    portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
                }
            } else {
                var vSub = vec3_t()
                var subLen: Float = 0

                vSub = ent.client!.ps.origin - duelAgainst!.client!.ps.origin
                subLen = VectorLength(vSub)

                if subLen >= 1024 {
                    ent.client!.ps.duelInProgress = 0 != 0
                    duelAgainst!.client!.ps.duelInProgress = 0 != 0

                    G_AddEvent(ent, EV_PRIVATE_DUEL, 0)
                    G_AddEvent(duelAgainst!, EV_PRIVATE_DUEL, 0)

                    // Port-note: Raven passes `"MP_SVGAME"` to `G_GetStringEdString`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                    // Raven wrote: trap_SendServerCommand( -1, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "PLDUELSTOP")) )
                    portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
                }
            }
        }

        if ent.client!.doingThrow > level.time {
            let throwee: Entity? = g_entities[ent.client!.throwingIndex]

            if !throwee!.inuse || throwee!.client == nil || throwee!.health < 1 || throwee!.client!.sess.sessionTeam == TEAM_SPECTATOR || (throwee!.client!.ps.pm_flags & PMF_FOLLOW) != 0 || throwee!.client!.throwingIndex != ent.s.number {
                ent.client!.doingThrow = 0
                ent.client!.ps.forceHandExtend = HANDEXTEND_NONE

                if throwee!.inuse && throwee!.client != nil {
                    throwee!.client!.ps.heldByClient = 0
                    throwee!.client!.beingThrown = 0

                    if throwee!.client!.ps.forceHandExtend != HANDEXTEND_POSTTHROWN {
                        throwee!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                    }
                }
            }
        }

        if ent.client!.beingThrown > level.time {
            let thrower: Entity? = g_entities[ent.client!.throwingIndex]

            if !thrower!.inuse || thrower!.client == nil || thrower!.health < 1 || thrower!.client!.sess.sessionTeam == TEAM_SPECTATOR || (thrower!.client!.ps.pm_flags & PMF_FOLLOW) != 0 || thrower!.client!.throwingIndex != ent.s.number {
                ent.client!.ps.heldByClient = 0
                ent.client!.beingThrown = 0

                if ent.client!.ps.forceHandExtend != HANDEXTEND_POSTTHROWN {
                    ent.client!.ps.forceHandExtend = HANDEXTEND_NONE
                }

                if thrower!.inuse && thrower!.client != nil {
                    thrower!.client!.doingThrow = 0
                    thrower!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                }
            } else if thrower!.inuse && thrower!.client != nil && thrower!.ghoul2 != nil && trap_G2_HaveWeGhoul2Models(thrower!.ghoul2) {
                do {
                    let pDif: Float = 40.0
                    var boltOrg = vec3_t()
                    var pBoltOrg = vec3_t()
                    var tAngles = vec3_t()
                    var vDif = vec3_t()
                    var entDir = vec3_t()
                    var otherAngles = vec3_t()
                    var fwd = vec3_t()
                    var right = vec3_t()

                    //Always look at the thrower.
                    entDir = thrower!.client!.ps.origin - ent.client!.ps.origin
                    otherAngles = ent.client!.ps.viewangles
                    otherAngles[YAW] = vectoyaw(entDir)
                    SetClientViewAngle(ent, otherAngles)

                    tAngles = thrower!.client!.ps.viewangles
                    tAngles[ROLL] = 0
                    tAngles[PITCH] = tAngles[ROLL]

                    //Get the direction between the pelvis and position of the hand


                    pBoltOrg = thrower!.client!.ps.origin
                    // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
                    var scratchUp = vec3_t()
                    AngleVectors(tAngles, &fwd, &right, &scratchUp)
                    boltOrg[0] = pBoltOrg[0] + fwd[0] * 8 + right[0] * pDif
                    boltOrg[1] = pBoltOrg[1] + fwd[1] * 8 + right[1] * pDif
                    boltOrg[2] = pBoltOrg[2]
                    //G_TestLine(boltOrg, pBoltOrg, 0x0000ff, 50);

                    vDif = ent.client!.ps.origin - boltOrg
                    if VectorLength(vDif) > 32.0 && (thrower!.client!.doingThrow - level.time) < 4500 {
                        //the hand is too far away, and can no longer hold onto us, so escape.
                        ent.client!.ps.heldByClient = 0
                        ent.client!.beingThrown = 0
                        thrower!.client!.doingThrow = 0

                        thrower!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                        G_EntitySound(thrower!, CHAN_VOICE, G_SoundIndex("*pain25.wav"))

                        ent.client!.ps.forceDodgeAnim = 2
                        ent.client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
                        ent.client!.ps.forceHandExtendTime = level.time + 500
                        ent.client!.ps.velocity[2] = 400
                        G_PreDefSound(ent.client!.ps.origin, PDSOUND_FORCEJUMP)
                    } else if (client!.beingThrown - level.time) < 4000 {
                        //step into the next part of the throw, and go flying back
                        let vScale: Float = 400.0
                        ent.client!.ps.forceHandExtend = HANDEXTEND_POSTTHROWN
                        ent.client!.ps.forceHandExtendTime = level.time + 1200
                        ent.client!.ps.forceDodgeAnim = 0

                        thrower!.client!.ps.forceHandExtend = HANDEXTEND_POSTTHROW
                        thrower!.client!.ps.forceHandExtendTime = level.time + 200

                        ent.client!.ps.heldByClient = 0

                        ent.client!.ps.heldByClient = 0
                        ent.client!.beingThrown = 0
                        thrower!.client!.doingThrow = 0

                        // Raven passes NULL for the `right` output, and AngleVectors only skips that write.
                        var scratchRight = vec3_t()
                        // Raven passes NULL for the `up` output, and AngleVectors only skips that write.
                        var scratchUp2 = vec3_t()
                        AngleVectors(thrower!.client!.ps.viewangles, &vDif, &scratchRight, &scratchUp2)
                        ent.client!.ps.velocity[0] = vDif[0] * vScale
                        ent.client!.ps.velocity[1] = vDif[1] * vScale
                        ent.client!.ps.velocity[2] = 400

                        G_EntitySound(ent, CHAN_VOICE, G_SoundIndex("*pain100.wav"))
                        G_EntitySound(thrower!, CHAN_VOICE, G_SoundIndex("*jump1.wav"))

                        //Set the thrower as the "other killer", so if we die from fall/impact damage he is credited.
                        ent.client!.ps.otherKiller = thrower!.s.number
                        ent.client!.ps.otherKillerTime = level.time + 8000
                        ent.client!.ps.otherKillerDebounceTime = level.time + 100
                        ent.client!.otherKillerMOD = MOD_FALLING
                        ent.client!.otherKillerVehWeapon = 0
                        ent.client!.otherKillerWeaponType = WP_NONE
                    } else {
                        //see if we can move to be next to the hand.. if it's not clear, break the throw.
                        var intendedOrigin = vec3_t()
                        // Raven's record lives to the end of his block, so the block is the closure.
                        Trace.scratch { tr in
                            // Raven's record lives to the end of his block, so the block is the closure.
                            Trace.scratch { tr2 in

                                vDif = boltOrg - pBoltOrg
                                VectorNormalize(&vDif)

                                ent.client!.ps.velocity = vec3_t()
                                intendedOrigin[0] = pBoltOrg[0] + vDif[0] * pDif
                                intendedOrigin[1] = pBoltOrg[1] + vDif[1] * pDif
                                intendedOrigin[2] = thrower!.client!.ps.origin[2]

                                trap_Trace(tr, intendedOrigin, ent.r.mins, ent.r.maxs, intendedOrigin, ent.s.number, ent.clipmask)
                                trap_Trace(tr2, ent.client!.ps.origin, ent.r.mins, ent.r.maxs, intendedOrigin, ent.s.number, CONTENTS_SOLID)

                                if Double(tr.fraction) == 1.0 && tr.startsolid == 0 && Double(tr2.fraction) == 1.0 && tr2.startsolid == 0 {
                                    ent.client!.ps.origin = intendedOrigin

                                    if (client!.beingThrown - level.time) < 4800 {
                                        ent.client!.ps.heldByClient = thrower!.s.number + 1
                                    }
                                } else {
                                    //if the guy can't be put here then it's time to break the throw off.
                                    ent.client!.ps.heldByClient = 0
                                    ent.client!.beingThrown = 0
                                    thrower!.client!.doingThrow = 0

                                    thrower!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                                    G_EntitySound(thrower!, CHAN_VOICE, G_SoundIndex("*pain25.wav"))

                                    ent.client!.ps.forceDodgeAnim = 2
                                    ent.client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
                                    ent.client!.ps.forceHandExtendTime = level.time + 500
                                    ent.client!.ps.velocity[2] = 400
                                    G_PreDefSound(ent.client!.ps.origin, PDSOUND_FORCEJUMP)
                                }
                            }
                        }
                    }
                }
            }
        } else if ent.client!.ps.heldByClient != 0 {
            ent.client!.ps.heldByClient = 0
        }

        /*
        if ( client->ps.powerups[PW_HASTE] ) {
        client->ps.speed *= 1.3;
        }
        */

        //Will probably never need this again, since we have g2 properly serverside now.
        //But just in case.
        /*
        if (client->ps.usingATST && ent->health > 0)
        { //we have special shot clip boxes as an ATST
        ent->r.contents |= CONTENTS_NOSHOT;
        ATST_ManageDamageBoxes(ent);
        }
        else
        {
        ent->r.contents &= ~CONTENTS_NOSHOT;
        client->damageBoxHandle_Head = 0;
        client->damageBoxHandle_RLeg = 0;
        client->damageBoxHandle_LLeg = 0;
        }
        */

        //rww - moved this stuff into the pmove code so that it's predicted properly
        //BG_AdjustClientSpeed(&client->ps, &client->pers.cmd, level.time);

        // set up for pmove
        oldEventSequence = client!.ps.eventSequence

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        if (ent.flags & FL_FORCE_GESTURE) != 0 {
            ent.flags &= ~FL_FORCE_GESTURE
            ent.client!.pers.cmd.buttons |= BUTTON_GESTURE
        }

        if ent.client != nil && ent.client!.ps.fallingToDeath != 0 && (level.time - FALL_FADE_TIME) > ent.client!.ps.fallingToDeath {
            //die!
            if ent.health > 0 {
                var otherKiller: Entity? = ent
                if ent.client!.ps.otherKillerTime > level.time && ent.client!.ps.otherKiller != ENTITYNUM_NONE {
                    otherKiller = g_entities[ent.client!.ps.otherKiller]

                    if !otherKiller!.inuse {
                        otherKiller = ent
                    }
                }
                // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
                var scratchDir = vec3_t()
                G_Damage(ent, otherKiller, otherKiller, &scratchDir, ent.client!.ps.origin, 9999, DAMAGE_NO_PROTECTION, MOD_FALLING)
                //player_die(ent, ent, ent, 100000, MOD_FALLING);
                //		if (!ent->NPC)
                //		{
                //			respawn(ent);
                //		}
                //		ent->client->ps.fallingToDeath = 0;

                G_MuteSound(ent.s.number, CHAN_VOICE) //stop screaming, because you are dead!
            }
        }

        if ent.client!.ps.otherKillerTime > level.time && ent.client!.ps.groundEntityNum != ENTITYNUM_NONE && ent.client!.ps.otherKillerDebounceTime < level.time {
            ent.client!.ps.otherKillerTime = 0
            ent.client!.ps.otherKiller = ENTITYNUM_NONE
        } else if ent.client!.ps.otherKillerTime > level.time && ent.client!.ps.groundEntityNum == ENTITYNUM_NONE {
            if ent.client!.ps.otherKillerDebounceTime < (level.time + 100) {
                ent.client!.ps.otherKillerDebounceTime = level.time + 100
            }
        }

        //	WP_ForcePowersUpdate( ent, msec, ucmd); //update any active force powers
        //	WP_SaberPositionUpdate(ent, ucmd); //check the server-side saber point, do apprioriate server-side actions (effects are cs-only)

        //NOTE: can't put USE here *before* PMove!!
        if ent.client!.ps.useDelay > level.time && ent.client!.ps.m_iVehicleNum != 0 {
            //when in a vehicle, debounce the use...
            ucmd!.buttons &= ~BUTTON_USE
        }

        //FIXME: need to do this before check to avoid walls and cliffs (or just cliffs?)
        G_AddPushVecToUcmd(ent, ucmd!)

        //play/stop any looping sounds tied to controlled movement
        G_CheckMovingLoopingSounds(ent, ucmd!)

        pm.ps = client!.ps
        pm.cmd = ucmd!
        if pm.ps.pm_type == PM_DEAD {
            pm.tracemask = MASK_PLAYERSOLID & ~CONTENTS_BODY
        } else if (ent.r.svFlags & SVF_BOT) != 0 {
            pm.tracemask = MASK_PLAYERSOLID | CONTENTS_MONSTERCLIP
        } else {
            pm.tracemask = MASK_PLAYERSOLID
        }
        // Port-note: A read of `pm`, a local the draft left as a hole.
        // Raven wrote: pm.trace = trap_Trace
        portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
        // Port-note: A read of `pm`, a local the draft left as a hole.
        // Raven wrote: pm.pointcontents = trap_PointContents
        portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
        pm.debugLevel = g_debugMove.integer
        pm.noFootsteps = (g_dmflags.integer & DF_NO_FOOTSTEPS) > 0

        // Port-note: A read of `pm`, a local the draft left as a hole.
        // Raven wrote: pm.pmove_fixed = pmove_fixed.integer | client->pers.pmoveFixed
        portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
        pm.pmove_msec = pmove_msec.integer

        pm.animations = bgAllAnims[ent.localAnimIndex].anims //NULL;

        //rww - bgghoul2
        pm.ghoul2 = nil


        if ent.ghoul2 != nil {
            if ent.localAnimIndex > 1 {
                //if it isn't humanoid then we will be having none of this.
                pm.ghoul2 = nil
            } else {
                pm.ghoul2 = ent.ghoul2
                pm.g2Bolts_LFoot = trap_G2API_AddBolt(ent.ghoul2, 0, "*l_leg_foot")
                pm.g2Bolts_RFoot = trap_G2API_AddBolt(ent.ghoul2, 0, "*r_leg_foot")
            }
        }

        //point the saber data to the right place

        //I'll just do this every frame in case the scale changes in realtime (don't need to update the g2 inst for that)
        pm.modelScale = ent.modelScale
        //rww end bgghoul2

        pm.gametype = g_gametype.integer
        pm.debugMelee = g_debugMelee.integer
        pm.stepSlideFix = g_stepSlideFix.integer

        pm.noSpecMove = g_noSpecMove.integer

        pm.nonHumanoid = (ent.localAnimIndex > 0)

        client!.oldOrigin = client!.ps.origin

        /*
        if (level.intermissionQueued != 0 && g_singlePlayer.integer) {
        if ( level.time - level.intermissionQueued >= 1000  ) {
        pm.cmd.buttons = 0;
        pm.cmd.forwardmove = 0;
        pm.cmd.rightmove = 0;
        pm.cmd.upmove = 0;
        if ( level.time - level.intermissionQueued >= 2000 && level.time - level.intermissionQueued <= 2500 ) {
        trap_SendConsoleCommand( EXEC_APPEND, "centerview\n");
        }
        ent->client->ps.pm_type = PM_SPINTERMISSION;
        }
        }
        */

        //Set up bg entity data
        // Port-note: A read of `pm`, a local the draft left as a hole.
        // Raven wrote: pm.baseEnt = (bgEntity_t *)g_entities
        portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")
        // Port-note: A read of `pm`, a local the draft left as a hole.
        // Raven wrote: pm.entSize = sizeof(gentity_t)
        portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")

        if ent.client!.ps.saberLockTime > level.time {
            let blockOpp: Entity? = g_entities[ent.client!.ps.saberLockEnemy]

            if blockOpp != nil && blockOpp!.inuse && blockOpp!.client != nil {
                var lockDir = vec3_t()
                var lockAng = vec3_t()

                //VectorClear( ent->client->ps.velocity );
                lockDir = blockOpp!.r.currentOrigin - ent.r.currentOrigin
                //lockAng[YAW] = vectoyaw( defDir );
                vectoangles(lockDir, &lockAng)
                SetClientViewAngle(ent, lockAng)
            }

            if ent.client!.ps.saberLockHitCheckTime < level.time {
                //have moved to next frame since last lock push
                ent.client!.ps.saberLockHitCheckTime = level.time //so we don't push more than once per server frame
                if (ent.client!.buttons & BUTTON_ATTACK) != 0 && !((ent.client!.oldbuttons & BUTTON_ATTACK) != 0) {
                    if ent.client!.ps.saberLockHitIncrementTime < level.time {
                        //have moved to next frame since last saberlock attack button press
                        var lockHits: Int32 = 0
                        ent.client!.ps.saberLockHitIncrementTime = level.time //so we don't register an attack key press more than once per server frame
                        //NOTE: FP_SABER_OFFENSE level already taken into account in PM_SaberLocked
                        if (ent.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
                            //raging: push harder
                            lockHits = 1 + ent.client!.ps.fd.forcePowerLevel[FP_RAGE]
                        } else {
                            //normal attack
                            switch ent.client!.ps.fd.saberAnimLevel {
                            case SS_FAST:
                                lockHits = 1

                            case SS_MEDIUM, SS_TAVION, SS_DUAL, SS_STAFF:
                                lockHits = 2

                            case SS_STRONG, SS_DESANN:
                                lockHits = 3

                            default:
                                break
                            }
                        }
                        if ent.client!.ps.fd.forceRageRecoveryTime > level.time && Q_irand(0, 1) != 0 {
                            //finished raging: weak
                            lockHits -= 1
                        }
                        lockHits += ent.client!.saber[0].lockBonus
                        // Raven tests `ent->client->saber[1].model` and `ent->client->saber[1].model[0]`.
                        // Both read as the same Swift test, so the draft writes it once.
                        if !ent.client!.saber[1].model.isEmpty && ent.client!.ps.saberHolstered == 0 {
                            lockHits += ent.client!.saber[1].lockBonus
                        }
                        ent.client!.ps.saberLockHits += lockHits
                        if g_saberLockRandomNess.integer != 0 {
                            ent.client!.ps.saberLockHits += Q_irand(0, g_saberLockRandomNess.integer)
                            if ent.client!.ps.saberLockHits < 0 {
                                ent.client!.ps.saberLockHits = 0
                            }
                        }
                    }
                }
                if ent.client!.ps.saberLockHits > 0 {
                    if !ent.client!.ps.saberLockAdvance {
                        ent.client!.ps.saberLockHits -= 1
                    }
                    ent.client!.ps.saberLockAdvance = true
                }
            }
        } else {
            ent.client!.ps.saberLockFrame = 0
            //check for taunt
            if (pm.cmd.generic_cmd == GENCMD_ENGAGE_DUEL) && (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) {
                //already in a duel, make it a taunt command
                pm.cmd.buttons |= BUTTON_GESTURE
            }
        }

        if ent.s.number >= MAX_CLIENTS {
            pm.mins = ent.r.mins
            pm.maxs = ent.r.maxs
            if ent.s.NPC_class == CLASS_VEHICLE && ent.m_pVehicle != nil {
                if ent.m_pVehicle!.m_pPilot != nil {
                    //vehicles want to use their last pilot ucmd I guess
                    if (level.time - ent.m_pVehicle!.m_ucmd.serverTime) > 2000 {
                        //Previous owner disconnected, maybe
                        ent.m_pVehicle!.m_ucmd.serverTime = level.time
                        ent.client!.ps.commandTime = level.time - 100
                        msec = 100
                    }

                    pm.cmd = ent.m_pVehicle!.m_ucmd

                    //no veh can strafe
                    pm.cmd.rightmove = 0
                    //no crouching or jumping!
                    pm.cmd.upmove = 0

                    //NOTE: button presses were getting lost!
                    pm.cmd.buttons = (g_entities[ent.m_pVehicle!.m_pPilot!.s.number].client!.pers.cmd.buttons & (BUTTON_ATTACK | BUTTON_ALT_ATTACK))
                }
                if ent.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
                    if ent.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                        //ATST crushes anything underneath it
                        let under: Entity? = g_entities[ent.client!.ps.groundEntityNum]
                        if under != nil && under!.health != 0 && under!.takedamage {
                            var down = vec3_t(0, 0, -1)
                            //FIXME: we'll be doing traces down from each foot, so we'll have a real impact origin
                            G_Damage(under!, ent, ent, &down, under!.r.currentOrigin, 100, 0, MOD_CRUSH)
                        }
                    }
                }
            }
        }

        Pmove(pm)

        if ent.client!.solidHack != 0 {
            if ent.client!.solidHack > level.time {
                //whee!
                ent.r.contents = 0
            } else {
                ent.r.contents = CONTENTS_BODY
                ent.client!.solidHack = 0
            }
        }

        if ent.NPC != nil {
            ent.r.currentAngles = ent.client!.ps.viewangles
        }

        if pm.checkDuelLoss != 0 {
            if pm.checkDuelLoss > 0 && (pm.checkDuelLoss <= MAX_CLIENTS || (pm.checkDuelLoss < (MAX_GENTITIES - 1) && g_entities[pm.checkDuelLoss - 1].s.eType == ET_NPC)) {
                let clientLost: Entity? = g_entities[pm.checkDuelLoss - 1]

                if clientLost != nil && clientLost!.inuse && clientLost!.client != nil && Q_irand(0, 40) > clientLost!.health {
                    var attDir = vec3_t()
                    attDir = ent.client!.ps.origin - clientLost!.client!.ps.origin
                    VectorNormalize(&attDir)

                    clientLost!.client!.ps.velocity = vec3_t()
                    clientLost!.client!.ps.forceHandExtend = HANDEXTEND_NONE
                    clientLost!.client!.ps.forceHandExtendTime = 0

                    gGAvoidDismember = 1
                    G_Damage(clientLost!, ent, ent, &attDir, clientLost!.client!.ps.origin, 9999, DAMAGE_NO_PROTECTION, MOD_SABER)

                    if clientLost!.health < 1 {
                        gGAvoidDismember = 2
                        G_CheckForDismemberment(clientLost!, ent, clientLost!.client!.ps.origin, 999, (clientLost!.client!.ps.legsAnim), false)
                    }

                    gGAvoidDismember = 0
                } else if clientLost != nil && clientLost!.inuse && clientLost!.client != nil && clientLost!.client!.ps.forceHandExtend != HANDEXTEND_KNOCKDOWN && clientLost!.client!.ps.saberEntityNum != 0 {
                    //if we didn't knock down it was a circle lock. So as punishment, make them lose their saber and go into a proper anim
                    saberCheckKnockdown_DuelLoss(g_entities[clientLost!.client!.ps.saberEntityNum], clientLost!, ent)
                }
            }

            pm.checkDuelLoss = 0
        }

        if ent.client!.ps.groundEntityNum < ENTITYNUM_WORLD {
            //standing on an ent
            let groundEnt: Entity? = g_entities[ent.client!.ps.groundEntityNum]
            if groundEnt != nil && groundEnt!.s.eType == ET_NPC && groundEnt!.s.NPC_class == CLASS_VEHICLE && groundEnt!.inuse && groundEnt!.health > 0 && groundEnt!.m_pVehicle != nil {
                //standing on a valid, living vehicle
                if groundEnt!.client!.ps.speed == 0 && groundEnt!.m_pVehicle!.m_ucmd.upmove > 0 {
                    //a vehicle that's trying to take off!
                    //just kill me
                    var up = vec3_t(0, 0, 1)
                    G_Damage(ent, nil, nil, &up, ent.r.currentOrigin, 9999999, DAMAGE_NO_PROTECTION, MOD_CRUSH)
                    return
                }
            }
        }

        if pm.cmd.generic_cmd != 0 && (pm.cmd.generic_cmd != ent.client!.lastGenCmd || ent.client!.lastGenCmdTime < level.time) {
            ent.client!.lastGenCmd = pm.cmd.generic_cmd
            if pm.cmd.generic_cmd != GENCMD_FORCE_THROW && pm.cmd.generic_cmd != GENCMD_FORCE_PULL {
                //these are the only two where you wouldn't care about a delay between
                ent.client!.lastGenCmdTime = level.time + 300 //default 100ms debounce between issuing the same command.
            }

            switch pm.cmd.generic_cmd {
            case 0:
                break

            case GENCMD_SABERSWITCH:
                Cmd_ToggleSaber_f(ent)

            case GENCMD_ENGAGE_DUEL:
                if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
                    //already in a duel, made it a taunt command
                } else {
                    Cmd_EngageDuel_f(ent)
                }

            case GENCMD_FORCE_HEAL:
                ForceHeal(ent)

            case GENCMD_FORCE_SPEED:
                ForceSpeed(ent, 0)

            case GENCMD_FORCE_THROW:
                ForceThrow(ent, false)

            case GENCMD_FORCE_PULL:
                ForceThrow(ent, true)

            case GENCMD_FORCE_DISTRACT:
                ForceTelepathy(ent)

            case GENCMD_FORCE_RAGE:
                ForceRage(ent)

            case GENCMD_FORCE_PROTECT:
                ForceProtect(ent)

            case GENCMD_FORCE_ABSORB:
                ForceAbsorb(ent)

            case GENCMD_FORCE_HEALOTHER:
                ForceTeamHeal(ent)

            case GENCMD_FORCE_FORCEPOWEROTHER:
                ForceTeamForceReplenish(ent)

            case GENCMD_FORCE_SEEING:
                ForceSeeing(ent)

            case GENCMD_USE_SEEKER:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_SEEKER)) != 0 && G_ItemUsable(ent.client!.ps, HI_SEEKER) != 0 {
                    ItemUse_Seeker(ent)
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_SEEKER, 0)
                    ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] &= ~(1 << HI_SEEKER)
                }

            case GENCMD_USE_FIELD:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_SHIELD)) != 0 && G_ItemUsable(ent.client!.ps, HI_SHIELD) != 0 {
                    ItemUse_Shield(ent)
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_SHIELD, 0)
                    ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] &= ~(1 << HI_SHIELD)
                }

            case GENCMD_USE_BACTA:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_MEDPAC)) != 0 && G_ItemUsable(ent.client!.ps, HI_MEDPAC) != 0 {
                    ItemUse_MedPack(ent)
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_MEDPAC, 0)
                    ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] &= ~(1 << HI_MEDPAC)
                }

            case GENCMD_USE_BACTABIG:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_MEDPAC_BIG)) != 0 && G_ItemUsable(ent.client!.ps, HI_MEDPAC_BIG) != 0 {
                    ItemUse_MedPack_Big(ent)
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_MEDPAC_BIG, 0)
                    ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] &= ~(1 << HI_MEDPAC_BIG)
                }

            case GENCMD_USE_ELECTROBINOCULARS:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_BINOCULARS)) != 0 && G_ItemUsable(ent.client!.ps, HI_BINOCULARS) != 0 {
                    ItemUse_Binoculars(ent)
                    if ent.client!.ps.zoomMode == 0 {
                        G_AddEvent(ent, EV_USE_ITEM0 + HI_BINOCULARS, 1)
                    } else {
                        G_AddEvent(ent, EV_USE_ITEM0 + HI_BINOCULARS, 2)
                    }
                }

            case GENCMD_ZOOM:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_BINOCULARS)) != 0 && G_ItemUsable(ent.client!.ps, HI_BINOCULARS) != 0 {
                    ItemUse_Binoculars(ent)
                    if ent.client!.ps.zoomMode == 0 {
                        G_AddEvent(ent, EV_USE_ITEM0 + HI_BINOCULARS, 1)
                    } else {
                        G_AddEvent(ent, EV_USE_ITEM0 + HI_BINOCULARS, 2)
                    }
                }

            case GENCMD_USE_SENTRY:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_SENTRY_GUN)) != 0 && G_ItemUsable(ent.client!.ps, HI_SENTRY_GUN) != 0 {
                    ItemUse_Sentry(ent)
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_SENTRY_GUN, 0)
                    ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] &= ~(1 << HI_SENTRY_GUN)
                }

            case GENCMD_USE_JETPACK:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_JETPACK)) != 0 && G_ItemUsable(ent.client!.ps, HI_JETPACK) != 0 {
                    ItemUse_Jetpack(ent)
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_JETPACK, 0)
                    /*
                    if (ent->client->ps.zoomMode == 0)
                    {
                    G_AddEvent(ent, EV_USE_ITEM0+HI_BINOCULARS, 1);
                    }
                    else
                    {
                    G_AddEvent(ent, EV_USE_ITEM0+HI_BINOCULARS, 2);
                    }
                    */
                }

            case GENCMD_USE_HEALTHDISP:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_HEALTHDISP)) != 0 && G_ItemUsable(ent.client!.ps, HI_HEALTHDISP) != 0 {
                    //ItemUse_UseDisp(ent, HI_HEALTHDISP);
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_HEALTHDISP, 0)
                }

            case GENCMD_USE_AMMODISP:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_AMMODISP)) != 0 && G_ItemUsable(ent.client!.ps, HI_AMMODISP) != 0 {
                    //ItemUse_UseDisp(ent, HI_AMMODISP);
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_AMMODISP, 0)
                }

            case GENCMD_USE_EWEB:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_EWEB)) != 0 && G_ItemUsable(ent.client!.ps, HI_EWEB) != 0 {
                    ItemUse_UseEWeb(ent)
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_EWEB, 0)
                }

            case GENCMD_USE_CLOAK:
                if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_CLOAK)) != 0 && G_ItemUsable(ent.client!.ps, HI_CLOAK) != 0 {
                    if ent.client!.ps.powerups[PW_CLOAKED] != 0 {
                        //decloak
                        Jedi_Decloak(ent)
                    } else {
                        //cloak
                        Jedi_Cloak(ent)
                    }
                }

            case GENCMD_SABERATTACKCYCLE:
                Cmd_SaberAttackCycle_f(ent)

            case GENCMD_TAUNT:
                G_SetTauntAnim(ent, TAUNT_TAUNT)

            case GENCMD_BOW:
                G_SetTauntAnim(ent, TAUNT_BOW)

            case GENCMD_MEDITATE:
                G_SetTauntAnim(ent, TAUNT_MEDITATE)

            case GENCMD_FLOURISH:
                G_SetTauntAnim(ent, TAUNT_FLOURISH)

            case GENCMD_GLOAT:
                G_SetTauntAnim(ent, TAUNT_GLOAT)

            default:
                break
            }
        }

        // save results of pmove
        if ent.client!.ps.eventSequence != oldEventSequence {
            ent.eventTime = level.time
        }
        if g_smoothClients.integer != 0 {
            BG_PlayerStateToEntityStateExtraPolate(ent.client!.ps, ent.s, ent.client!.ps.commandTime, false)
            //rww - 12-03-02 - Don't snap the origin of players! It screws prediction all up.
        } else {
            BG_PlayerStateToEntityState(ent.client!.ps, ent.s, false)
        }

        if isNPC {
            ent.s.eType = ET_NPC
        }

        SendPendingPredictableEvents(ent.client!.ps)

        if !((ent.client!.ps.eFlags & EF_FIRING) != 0) {
            client!.fireHeld = false // for grapple
        }

        // use the snapped origin for linking so it matches client predicted versions
        ent.r.currentOrigin = ent.s.pos.trBase

        if ent.s.eType != ET_NPC || ent.s.NPC_class != CLASS_VEHICLE || ent.m_pVehicle == nil || ent.m_pVehicle!.m_iRemovedSurfaces == 0 {
            //let vehicles that are getting broken apart do their own crazy sizing stuff
            ent.r.mins = pm.mins
            ent.r.maxs = pm.maxs
        }

        ent.waterlevel = pm.waterlevel
        ent.watertype = pm.watertype

        // execute client events
        ClientEvents(ent, oldEventSequence)

        if pm.useEvent != 0 {
            //TODO: Use
            //		TryUse( ent );
        }
        if (ent.client!.pers.cmd.buttons & BUTTON_USE) != 0 && ent.client!.ps.useDelay < level.time {
            TryUse(ent)
            ent.client!.ps.useDelay = level.time + 100
        }

        // link entity now, after any personal teleporters have been used
        trap_LinkEntity(ent)
        if !ent.client!.noclip {
            G_TouchTriggers(ent)
        }

        // NOTE: now copy the exact origin over otherwise clients can be snapped into solid
        ent.r.currentOrigin = ent.client!.ps.origin

        //test for solid areas in the AAS file
        //	BotTestAAS(ent->r.currentOrigin);

        // touch other objects
        ClientImpacts(ent, pm)

        // save results of triggers and client events
        if ent.client!.ps.eventSequence != oldEventSequence {
            ent.eventTime = level.time
        }

        // swap and latch button actions
        client!.oldbuttons = client!.buttons
        client!.buttons = ucmd!.buttons
        client!.latched_buttons |= client!.buttons & ~client!.oldbuttons

        //	G_VehicleAttachDroidUnit( ent );

        // Did we kick someone in our pmove sequence?
        if client!.ps.forceKickFlip != 0 {
            let faceKicked: Entity? = g_entities[client!.ps.forceKickFlip - 1]

            if faceKicked != nil && faceKicked!.client != nil && (!OnSameTeam(ent, faceKicked!) || g_friendlyFire.integer != 0) && (!faceKicked!.client!.ps.duelInProgress || faceKicked!.client!.ps.duelIndex == ent.s.number) && (!ent.client!.ps.duelInProgress || ent.client!.ps.duelIndex == faceKicked!.s.number) {
                if faceKicked != nil && faceKicked!.client != nil && faceKicked!.health != 0 && faceKicked!.takedamage {
                    //push them away and do pain
                    var oppDir = vec3_t()
                    var strength: Int32 = Int32(VectorNormalize2(client!.ps.velocity, &oppDir))

                    strength = Int32(Double(strength) * 0.05)

                    oppDir = oppDir * -1

                    G_Damage(faceKicked!, ent, ent, &oppDir, client!.ps.origin, strength, DAMAGE_NO_ARMOR, MOD_MELEE)

                    if faceKicked!.client!.ps.weapon != WP_SABER || faceKicked!.client!.ps.fd.saberAnimLevel != FORCE_LEVEL_3 || (!BG_SaberInAttack(faceKicked!.client!.ps.saberMove) && !PM_SaberInStart(faceKicked!.client!.ps.saberMove) && !PM_SaberInReturn(faceKicked!.client!.ps.saberMove) && !PM_SaberInTransition(faceKicked!.client!.ps.saberMove)) {
                        if faceKicked!.health > 0 && faceKicked!.client!.ps.stats[STAT_HEALTH] > 0 && faceKicked!.client!.ps.forceHandExtend != HANDEXTEND_KNOCKDOWN {
                            if BG_KnockDownable(faceKicked!.client!.ps) && Q_irand(1, 10) <= 3 {
                                //only actually knock over sometimes, but always do velocity hit
                                faceKicked!.client!.ps.forceHandExtend = HANDEXTEND_KNOCKDOWN
                                faceKicked!.client!.ps.forceHandExtendTime = level.time + 1100
                                faceKicked!.client!.ps.forceDodgeAnim = 0 //this toggles between 1 and 0, when it's 1 we should play the get up anim
                            }

                            faceKicked!.client!.ps.otherKiller = ent.s.number
                            faceKicked!.client!.ps.otherKillerTime = level.time + 5000
                            faceKicked!.client!.ps.otherKillerDebounceTime = level.time + 100
                            faceKicked!.client!.otherKillerMOD = MOD_MELEE
                            faceKicked!.client!.otherKillerVehWeapon = 0
                            faceKicked!.client!.otherKillerWeaponType = WP_NONE

                            faceKicked!.client!.ps.velocity[0] = oppDir[0] * (strength * 40)
                            faceKicked!.client!.ps.velocity[1] = oppDir[1] * (strength * 40)
                            faceKicked!.client!.ps.velocity[2] = 200
                        }
                    }

                    G_Sound(faceKicked!, CHAN_AUTO, G_SoundIndex(va("sound/weapons/melee/punch%d", Q_irand(1, 4))))
                }
            }

            client!.ps.forceKickFlip = 0
        }

        // check for respawning
        if client!.ps.stats[STAT_HEALTH] <= 0 && !((client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0) && ent.s.eType != ET_NPC {
            // wait for the attack button to be pressed
            if level.time > client!.respawnTime && !gDoSlowMoDuel {
                // forcerespawn is to prevent users from waiting out powerups
                var forceRes: Int32 = g_forcerespawn.integer

                if g_gametype.integer == GT_POWERDUEL {
                    forceRes = 1
                } else if g_gametype.integer == GT_SIEGE && g_siegeRespawn.integer != 0 {
                    //wave respawning on
                    forceRes = 1
                }

                if forceRes > 0 && (level.time - client!.respawnTime) > forceRes * 1000 {
                    respawn(ent)
                    return
                }

                // pressing attack or use is the normal respawn method
                if (ucmd!.buttons & (BUTTON_ATTACK | BUTTON_USE_HOLDABLE)) != 0 {
                    respawn(ent)
                }
            } else if gDoSlowMoDuel {
                client!.respawnTime = level.time + 1000
            }
            return
        }

        // perform once-a-second actions
        ClientTimerActions(ent, msec)

        G_UpdateClientBroadcasts(ent)

        //try some idle anims on ent if getting no input and not moving for some time
        G_CheckClientIdle(ent, ucmd!)

        // This code was moved here from clientThink to fix a problem with g_synchronousClients
        // being set to 1 when in vehicles.
        if ent.s.number < MAX_CLIENTS && ent.client!.ps.m_iVehicleNum != 0 {
            //driving a vehicle
            //run it
            if g_entities[ent.client!.ps.m_iVehicleNum].inuse && g_entities[ent.client!.ps.m_iVehicleNum].client != nil {
                ClientThink(ent.client!.ps.m_iVehicleNum, g_entities[ent.client!.ps.m_iVehicleNum].m_pVehicle!.m_ucmd)
            } else {
                //vehicle no longer valid?
                ent.client!.ps.m_iVehicleNum = 0
            }
        }
    }
}

/**
```
==================
G_CheckClientTimeouts

Checks whether a client has exceded any timeouts and act accordingly
==================
```
*/
/// Source: oracle/codemp/game/g_active.c:3620
func G_CheckClientTimeouts(_ ent: Entity) {
    // Only timeout supported right now is the timeout to spectator mode
    if g_timeouttospec.integer == 0 {
        return
    }

    // Already a spectator, no need to boot them to spectator
    if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
        return
    }

    // See how long its been since a command was received by the client and if its
    // longer than the timeout to spectator then force this client into spectator mode
    if level.time - ent.client!.pers.cmd.serverTime > g_timeouttospec.integer * 1000 {
        SetTeam(ent, "spectator")
    }
}

/**
```
==================
ClientThink

A new command has arrived from the client
==================
```
*/
/// Source: oracle/codemp/game/g_active.c:3649
func ClientThink(_ clientNum: Int32, _ ucmd: JKAMP.Usercmd?) {
    var entIndex: Int32 = 0

    entIndex = clientNum
    if clientNum < MAX_CLIENTS {
        trap_GetUsercmd(clientNum, g_entities[entIndex].client!.pers.cmd)
    }

    // mark the time we got info, so we can display the
    // phone jack if they don't get any for a while
    g_entities[entIndex].client!.lastCmdTime = level.time

    if ucmd != nil {
        g_entities[entIndex].client!.pers.cmd.copy(from: ucmd!)
    }

    /* 	This was moved to clientthink_real, but since its sort of a risky change i left it here for
    now as a more concrete reference - BSD

    if ( clientNum < MAX_CLIENTS
    && ent->client->ps.m_iVehicleNum )
    {//driving a vehicle
    if (g_entities[ent->client->ps.m_iVehicleNum].client)
    {
    gentity_t *veh = &g_entities[ent->client->ps.m_iVehicleNum];

    if (veh->m_pVehicle &&
    veh->m_pVehicle->m_pPilot == (bgEntity_t *)ent)
    { //only take input from the pilot...
    veh->client->ps.commandTime = ent->client->ps.commandTime;
    memcpy(&veh->m_pVehicle->m_ucmd, &ent->client->pers.cmd, sizeof(usercmd_t));
    if ( veh->m_pVehicle->m_ucmd.buttons & BUTTON_TALK )
    { //forced input if "chat bubble" is up
    veh->m_pVehicle->m_ucmd.buttons = BUTTON_TALK;
    veh->m_pVehicle->m_ucmd.forwardmove = 0;
    veh->m_pVehicle->m_ucmd.rightmove = 0;
    veh->m_pVehicle->m_ucmd.upmove = 0;
    }
    }
    }
    }
    */
    if !((g_entities[entIndex].r.svFlags & SVF_BOT) != 0) && g_synchronousClients.integer == 0 {
        ClientThink_real(g_entities[entIndex])
    } else if clientNum >= MAX_CLIENTS {
        // vehicles are clients and when running synchronous they still need to think here
        // so special case them.
        ClientThink_real(g_entities[entIndex])
    }

    /*	This was moved to clientthink_real, but since its sort of a risky change i left it here for
    now as a more concrete reference - BSD

    if ( clientNum < MAX_CLIENTS
    && ent->client->ps.m_iVehicleNum )
    {//driving a vehicle
    //run it
    if (g_entities[ent->client->ps.m_iVehicleNum].inuse &&
    g_entities[ent->client->ps.m_iVehicleNum].client)
    {
    ClientThink(ent->client->ps.m_iVehicleNum, &g_entities[ent->client->ps.m_iVehicleNum].m_pVehicle->m_ucmd);
    }
    else
    { //vehicle no longer valid?
    ent->client->ps.m_iVehicleNum = 0;
    }
    }
    */
}

/// Source: oracle/codemp/game/g_active.c:3723
func G_RunClient(_ ent: Entity) {
    if !((ent.r.svFlags & SVF_BOT) != 0) && g_synchronousClients.integer == 0 {
        return
    }
    ent.client!.pers.cmd.serverTime = level.time
    ClientThink_real(ent)
}

/**
```
==================
SpectatorClientEndFrame

==================
```
*/
/// Source: oracle/codemp/game/g_active.c:3738
func SpectatorClientEndFrame(_ ent: Entity) {
    var cl: Client?

    if ent.s.eType == ET_NPC {
        return
    }

    // if we are doing a chase cam or a remote view, grab the latest info
    if ent.client!.sess.spectatorState == SPECTATOR_FOLLOW {
        var clientNum: Int32

        clientNum = ent.client!.sess.spectatorClient

        // team follow1 and team follow2 go to whatever clients are playing
        if clientNum == -1 {
            clientNum = level.follow1
        } else if clientNum == -2 {
            clientNum = level.follow2
        }
        if clientNum >= 0 {
            cl = level.clientsSlots[clientNum]
            if cl!.pers.connected == CON_CONNECTED && cl!.sess.sessionTeam != TEAM_SPECTATOR {
                //flags = (cl->mGameFlags & ~(PSG_VOTED | PSG_TEAMVOTED)) | (ent->client->mGameFlags & (PSG_VOTED | PSG_TEAMVOTED));
                //ent->client->mGameFlags = flags;
                ent.client!.ps.eFlags = cl!.ps.eFlags
                ent.client!.ps.copy(from: cl!.ps)
                ent.client!.ps.pm_flags |= PMF_FOLLOW
                return
            } else {
                // drop them to free spectators unless they are dedicated camera followers
                if ent.client!.sess.spectatorClient >= 0 {
                    ent.client!.sess.spectatorState = SPECTATOR_FREE
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '-' cannot be applied to two 'Client?' operands".
                    // Raven wrote: ClientBegin( ent->client - level.clients, qtrue )
                    portMissing("SpectatorClientEndFrame", source: "oracle/codemp/game/g_active.c:3738")
                }
            }
        }
    }

    if ent.client!.sess.spectatorState == SPECTATOR_SCOREBOARD {
        ent.client!.ps.pm_flags |= PMF_SCOREBOARD
    } else {
        ent.client!.ps.pm_flags &= ~PMF_SCOREBOARD
    }
}

/**
```
==============
ClientEndFrame

Called at the end of each server frame for each connected client
A fast client will have multiple ClientThink for each ClientEdFrame,
while a slow client may have multiple ClientEndFrame between ClientThink.
==============
```
*/
/// Source: oracle/codemp/game/g_active.c:3794
func ClientEndFrame(_ ent: Entity) {
    var i: Int32
    var pers: ClientPersistant?
    var isNPC: Bool = false

    if ent.s.eType == ET_NPC {
        isNPC = true
    }

    if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
        SpectatorClientEndFrame(ent)
        return
    }

    pers = ent.client!.pers

    // turn off any expired powerups
    i = 0
    while i < MAX_POWERUPS {
        if ent.client!.ps.powerups[i] < level.time {
            ent.client!.ps.powerups[i] = 0
        }
        i += 1
    }

    // save network bandwidth
    // FIXME: this must change eventually for non-sync demo recording

    //
    // If the end of unit layout is displayed, don't give
    // the player any normal movement attributes
    //
    if level.intermissiontime != 0 {
        if ent.s.number < MAX_CLIENTS || ent.client!.NPC_class == CLASS_VEHICLE {
            //players and vehicles do nothing in intermissions
            return
        }
    }

    // burn from lava, etc
    P_WorldEffects(ent)

    // apply all the damage taken this frame
    P_DamageFeedback(ent)

    // add the EF_CONNECTION flag if we haven't gotten commands recently
    if level.time - ent.client!.lastCmdTime > 1000 {
        ent.s.eFlags |= EF_CONNECTION
    } else {
        ent.s.eFlags &= ~EF_CONNECTION
    }

    ent.client!.ps.stats[STAT_HEALTH] = ent.health // FIXME: get rid of ent->health...

    G_SetClientSound(ent)

    // set the latest infor
    if g_smoothClients.integer != 0 {
        BG_PlayerStateToEntityStateExtraPolate(ent.client!.ps, ent.s, ent.client!.ps.commandTime, false)
        //rww - 12-03-02 - Don't snap the origin of players! It screws prediction all up.
    } else {
        BG_PlayerStateToEntityState(ent.client!.ps, ent.s, false)
    }

    if isNPC {
        ent.s.eType = ET_NPC
    }

    SendPendingPredictableEvents(ent.client!.ps)

    // set the bit for the reachability area the client is currently in
    //	i = trap_AAS_PointReachabilityAreaIndex( ent->client->ps.origin );
    //	ent->client->areabits[i >> 3] |= 1 << (i & 7);
}
