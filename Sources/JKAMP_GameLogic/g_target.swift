import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_target.c:753
var numNewICARUSEnts: Int32 {
    get { world.variables.numNewICARUSEnts }
    set { world.variables.numNewICARUSEnts = newValue }
}

/// Source: oracle/codemp/game/g_target.c:909
let ACT_ACTIVE = true

/// Source: oracle/codemp/game/g_target.c:910
let ACT_INACTIVE = false

/**
```
QUAKED target_give (1 0 0) (-8 -8 -8) (8 8 8)
Gives the activator all the items pointed to.
```
*/
/// Source: oracle/codemp/game/g_target.c:10
func Use_Target_Give(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    var t: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in

        if activator.client == nil {
            return true
        }

        if ent.target == nil {
            return true
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
        t = nil
        while let next = G_Find(t, \.targetname, ent.target) {
            t = next
            if t!.item == nil {
                continue
            }
            Touch_Item(t!, activator, trace)

            // make sure it isn't going to respawn or show any events
            t!.nextthink = 0
            trap_UnlinkEntity(t!)
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_target.c:36
func SP_target_give(_ ent: Entity) {
    ent.use = Use.Use_Target_Give
}

/**
```
QUAKED target_remove_powerups (1 0 0) (-8 -8 -8) (8 8 8)
takes away all the activators powerups.
Used to drop flight powerups into death puts.
```
*/
/// Source: oracle/codemp/game/g_target.c:47
func Use_target_remove_powerups(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    if activator.client == nil {
        return
    }

    if activator.client!.ps.powerups[PW_REDFLAG] != 0 {
        Team_ReturnFlag(TEAM_RED)
    } else if activator.client!.ps.powerups[PW_BLUEFLAG] != 0 {
        Team_ReturnFlag(TEAM_BLUE)
    } else if activator.client!.ps.powerups[PW_NEUTRALFLAG] != 0 {
        Team_ReturnFlag(TEAM_FREE)
    }

    activator.client!.ps.powerups.fill(0)
}

/// Source: oracle/codemp/game/g_target.c:63
func SP_target_remove_powerups(_ ent: Entity) {
    ent.use = Use.Use_target_remove_powerups
}

/**
```
QUAKED target_delay (1 0 0) (-8 -8 -8) (8 8 8) NO_RETRIGGER

NO_RETRIGGER - Keeps the delay from resetting the time if it is
activated again while it is counting down to an event.

"wait" seconds to pause before firing targets.
"random" delay variance, total delay = delay +/- random seconds
```
*/
/// Source: oracle/codemp/game/g_target.c:78
func Think_Target_Delay(_ ent: Entity) {
    G_UseTargets(ent, ent.activator)
}

/// Source: oracle/codemp/game/g_target.c:82
func Use_Target_Delay(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    if ent.nextthink > level.time && (ent.spawnflags & 1) != 0 {
        //Leave me alone, I am thinking.
        return
    }
    G_ActivateBehavior(ent, BSET_USE)
    ent.nextthink = Int32(Double(level.time) + (Double(ent.wait) + Double(ent.random) * crandom()) * 1000)
    ent.think = Think.Think_Target_Delay
    ent.activator = activator
}

/// Source: oracle/codemp/game/g_target.c:93
func SP_target_delay(_ ent: Entity) {
    // check delay for backwards compatability
    if !G_SpawnFloat("delay", "0", &ent.wait) {
        G_SpawnFloat("wait", "1", &ent.wait)
    }

    if ent.wait == 0 {
        ent.wait = 1
    }
    ent.use = Use.Use_Target_Delay
}

/**
```
QUAKED target_score (1 0 0) (-8 -8 -8) (8 8 8)
"count" number of points to add, default 1

The activator is given this many points.
```
*/
/// Source: oracle/codemp/game/g_target.c:113
func Use_Target_Score(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    AddScore(activator, ent.r.currentOrigin, ent.count)
}

/// Source: oracle/codemp/game/g_target.c:117
func SP_target_score(_ ent: Entity) {
    if ent.count == 0 {
        ent.count = 1
    }
    ent.use = Use.Use_Target_Score
}

/**
```
QUAKED target_print (1 0 0) (-8 -8 -8) (8 8 8) redteam blueteam private
"message"	text to print
"wait"		don't fire off again if triggered within this many milliseconds ago
If "private", only the activator gets the message.  If no checks, all clients get the message.
```
*/
/// Source: oracle/codemp/game/g_target.c:132
func Use_Target_Print(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    if !ent.inuse {
        Com_Printf("ERROR: Bad ent in Use_Target_Print")
        return
    }

    if ent.wait != 0 {
        if ent.genericValue14 >= level.time {
            return
        }
        ent.genericValue14 = Int32(level.time + ent.wait)
    }

    if !ent.inuse {
        Com_Error(ERR_DROP, "Bad ent in Use_Target_Print")
    } else if !activator.inuse {
        Com_Error(ERR_DROP, "Bad activator in Use_Target_Print")
    }

    if ent.genericValue15 > level.time {
        Com_Printf("TARGET PRINT ERRORS:\n")
        if activator.classname != nil && !activator.classname!.isEmpty {
            Com_Printf("activator classname: %s\n", activator.classname!)
        }
        if activator.target != nil && !activator.target!.isEmpty {
            Com_Printf("activator target: %s\n", activator.target!)
        }
        if activator.targetname != nil && !activator.targetname!.isEmpty {
            Com_Printf("activator targetname: %s\n", activator.targetname!)
        }
        if ent.targetname != nil && !ent.targetname!.isEmpty {
            Com_Printf("print targetname: %s\n", ent.targetname!)
        }
        Com_Error(ERR_DROP, "target_print used in quick succession, fix it! See the console for details.")
    }
    ent.genericValue15 = level.time + 5000

    G_ActivateBehavior(ent, BSET_USE)
    if (ent.spawnflags & 4) != 0 {
        //private, to one client only
        if !activator.inuse {
            Com_Printf("ERROR: Bad activator in Use_Target_Print")
        }
        if activator.client != nil {
            //make sure there's a valid client ent to send it to
            let message = CharBuf(ent.message!)
            if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {
                trap_SendServerCommand(activator.s.number, va("cps \"%s\"", ent.message ?? "(null)"))
            } else {
                trap_SendServerCommand(activator.s.number, va("cp \"%s\"", ent.message ?? "(null)"))
            }
        }
        //NOTE: change in functionality - if there *is* no valid client ent, it won't send it to anyone at all
        return
    }

    if (ent.spawnflags & 3) != 0 {
        if (ent.spawnflags & 1) != 0 {
            let message = CharBuf(ent.message!)
            if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {
                G_TeamCommand(TEAM_RED, va("cps \"%s\"", ent.message ?? "(null)"))
            } else {
                G_TeamCommand(TEAM_RED, va("cp \"%s\"", ent.message ?? "(null)"))
            }
        }
        if (ent.spawnflags & 2) != 0 {
            let message = CharBuf(ent.message!)
            if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {
                G_TeamCommand(TEAM_BLUE, va("cps \"%s\"", ent.message ?? "(null)"))
            } else {
                G_TeamCommand(TEAM_BLUE, va("cp \"%s\"", ent.message ?? "(null)"))
            }
        }
        return
    }

    let message = CharBuf(ent.message!)
    if message[0] == Int32(ascii: "@") && message[1] != Int32(ascii: "@") {
        trap_SendServerCommand(-1, va("cps \"%s\"", ent.message ?? "(null)"))
    } else {
        trap_SendServerCommand(-1, va("cp \"%s\"", ent.message ?? "(null)"))
    }
}

/// Source: oracle/codemp/game/g_target.c:239
func SP_target_print(_ ent: Entity) {
    ent.use = Use.Use_Target_Print
}

/**
```
QUAKED target_speaker (1 0 0) (-8 -8 -8) (8 8 8) looped-on looped-off global activator
"noise"		wav file to play

A global sound will play full volume throughout the level.
Activator sounds will play on the player that activated the target.
Global and activator sounds can't be combined with looping.
Normal sounds play each time the target is used.
Looped sounds will be toggled by use functions.
Multiple identical looping sounds will just increase volume without any speed cost.
"wait" : Seconds between auto triggerings, 0 = don't auto trigger
"random"	wait variance, default is 0
```
*/
/// Source: oracle/codemp/game/g_target.c:259
func Use_Target_Speaker(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(ent, BSET_USE)

    if (ent.spawnflags & 3) != 0 {
        // looping sound toggles
        if ent.s.loopSound != 0 {
            ent.s.loopSound = 0 // turn it off
            ent.s.loopIsSoundset = false
            ent.s.trickedentindex = 1
        } else {
            ent.s.loopSound = ent.noise_index // start it
            ent.s.loopIsSoundset = false
            ent.s.trickedentindex = 0
        }
    } else {
        // normal sound
        if (ent.spawnflags & 8) != 0 {
            G_AddEvent(activator, EV_GENERAL_SOUND, ent.noise_index)
        } else if (ent.spawnflags & 4) != 0 {
            G_AddEvent(ent, EV_GLOBAL_SOUND, ent.noise_index)
        } else {
            G_AddEvent(ent, EV_GENERAL_SOUND, ent.noise_index)
        }
    }
}

/// Source: oracle/codemp/game/g_target.c:286
func SP_target_speaker(_ ent: Entity) {
    var buffer = CharBuf(64)
    var s: String = ""

    G_SpawnFloat("wait", "0", &ent.wait)
    G_SpawnFloat("random", "0", &ent.random)

    if G_SpawnString("soundSet", "", &s) {
        // this is a sound set
        ent.s.soundSetIndex = G_SoundSetIndex(s)
        ent.s.eFlags = EF_PERMANENT
        ent.s.pos.trBase = ent.s.origin
        trap_LinkEntity(ent)
        return
    }

    if !G_SpawnString("noise", "NOSOUND", &s) {
        G_Error("target_speaker without a noise key at %s", vtos(ent.s.origin))
    }

    // force all client reletive sounds to be "activator" speakers that
    // play on the entity that activates it
    if CharBuf(s)[0] == Int32(ascii: "*") {
        ent.spawnflags |= 8
    }

    Q_strncpyz(&buffer, s, Int32((buffer).count))

    ent.noise_index = G_SoundIndex(String(buffer))

    // a repeating speaker can be done completely client side
    ent.s.eType = ET_SPEAKER
    ent.s.eventParm = ent.noise_index
    ent.s.frame = Int32(ent.wait * 10)
    ent.s.clientNum = Int32(ent.random * 10)


    // check for prestarted looping sound
    if (ent.spawnflags & 1) != 0 {
        ent.s.loopSound = ent.noise_index
        ent.s.loopIsSoundset = false
    }

    ent.use = Use.Use_Target_Speaker

    if (ent.spawnflags & 4) != 0 {
        ent.r.svFlags |= SVF_BROADCAST
    }

    ent.s.pos.trBase = ent.s.origin

    // must link the entity so we get areas and clusters so
    // the server can determine who to send updates to
    trap_LinkEntity(ent)
}

/**
```
QUAKED target_laser (0 .5 .8) (-8 -8 -8) (8 8 8) START_ON
When triggered, fires a laser.  You can either set a target or a direction.
```
*/
/// Source: oracle/codemp/game/g_target.c:349
func target_laser_think(_ `self`: Entity) {
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in
        var point = vec3_t()

        // if pointed at another entity, set movedir to point at it
        if `self`.enemy != nil {
            _VectorMA(`self`.enemy!.s.origin, 0.5, `self`.enemy!.r.mins, &point)
            _VectorMA(point, 0.5, `self`.enemy!.r.maxs, &point)
            `self`.movedir = point - `self`.s.origin
            VectorNormalize(&`self`.movedir)
        }

        // fire forward and see what we hit
        _VectorMA(`self`.s.origin, 2048, `self`.movedir, &end)

        trap_Trace(tr, `self`.s.origin, vec3_origin, vec3_origin, end, `self`.s.number, CONTENTS_SOLID | CONTENTS_BODY | CONTENTS_CORPSE)

        if tr.entityNum != 0 {
            // hurt it if we can
            G_Damage(g_entities[tr.entityNum], `self`, `self`.activator, &`self`.movedir, tr.endpos, `self`.damage, DAMAGE_NO_KNOCKBACK, MOD_TARGET_LASER)
        }

        `self`.s.origin2 = tr.endpos

        trap_LinkEntity(`self`)
        `self`.nextthink = level.time + FRAMETIME
    }
}

/// Source: oracle/codemp/game/g_target.c:379
func target_laser_on(_ `self`: Entity) {
    if `self`.activator == nil {
        `self`.activator = `self`
    }
    target_laser_think(`self`)
}

/// Source: oracle/codemp/game/g_target.c:386
func target_laser_off(_ `self`: Entity) {
    trap_UnlinkEntity(`self`)
    `self`.nextthink = 0
}

/// Source: oracle/codemp/game/g_target.c:392
func target_laser_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    `self`.activator = activator
    if `self`.nextthink > 0 {
        target_laser_off(`self`)
    } else {
        target_laser_on(`self`)
    }
}

/// Source: oracle/codemp/game/g_target.c:401
func target_laser_start(_ `self`: Entity) {
    var ent: Entity?

    `self`.s.eType = ET_BEAM

    if `self`.target != nil {
        ent = G_Find(nil, \.targetname, `self`.target)
        if ent == nil {
            G_Printf("%s at %s: %s is a bad target\n", `self`.classname!, vtos(`self`.s.origin), `self`.target!)
        }
        `self`.enemy = ent
    } else {
        G_SetMovedir(&`self`.s.angles, &`self`.movedir)
    }

    `self`.use = Use.target_laser_use
    `self`.think = Think.target_laser_think

    if `self`.damage == 0 {
        `self`.damage = 1
    }

    if (`self`.spawnflags & 1) != 0 {
        target_laser_on(`self`)
    } else {
        target_laser_off(`self`)
    }
}

/// Source: oracle/codemp/game/g_target.c:430
func SP_target_laser(_ `self`: Entity) {
    // let everything else get spawned before we start firing
    `self`.think = Think.target_laser_start
    `self`.nextthink = level.time + FRAMETIME
}

/// Source: oracle/codemp/game/g_target.c:440
func target_teleporter_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    var dest: Entity?

    if activator.client == nil {
        return
    }

    G_ActivateBehavior(`self`, BSET_USE)

    dest = G_PickTarget(`self`.target!)
    if dest == nil {
        G_Printf("Couldn't find teleporter destination\n")
        return
    }

    TeleportPlayer(activator, dest!.s.origin, dest!.s.angles)
}

/**
```
QUAKED target_teleporter (1 0 0) (-8 -8 -8) (8 8 8)
The activator will be teleported away.
```
*/
/// Source: oracle/codemp/game/g_target.c:460
func SP_target_teleporter(_ `self`: Entity) {
    if `self`.targetname == nil {
        G_Printf("untargeted %s at %s\n", `self`.classname!, vtos(`self`.s.origin))
    }

    `self`.use = Use.target_teleporter_use
}

/**
```
QUAKED target_relay (.5 .5 .5) (-8 -8 -8) (8 8 8) RED_ONLY BLUE_ONLY RANDOM x x x x INACTIVE
This doesn't perform any actions except fire its targets.
The activator can be forced to be from a certain team.
if RANDOM is checked, only one of the targets will be fired, not all of them

  INACTIVE  Can't be used until activated

wait - set to -1 to use it only once
```
*/
/// Source: oracle/codemp/game/g_target.c:479
func target_relay_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    var ranscript: Bool = false
    if (`self`.spawnflags & 1) != 0 && activator.client != nil && activator.client!.sess.sessionTeam != TEAM_RED {
        return
    }
    if (`self`.spawnflags & 2) != 0 && activator.client != nil && activator.client!.sess.sessionTeam != TEAM_BLUE {
        return
    }

    if (`self`.flags & FL_INACTIVE) != 0 {
        //set by target_deactivate
        return
    }

    ranscript = G_ActivateBehavior(`self`, BSET_USE)
    if `self`.wait == -1 {
        //never use again
        if ranscript {
            //crap, can't remove!
            `self`.use = nil
        } else {
            //remove
            `self`.think = Think.G_FreeEntity
            `self`.nextthink = level.time + FRAMETIME
        }
    }
    if (`self`.spawnflags & 4) != 0 {
        var ent: Entity?

        ent = G_PickTarget(`self`.target!)
        if ent != nil && ent!.use != nil {
            GlobalUse(ent!, `self`, activator)
        }
        return
    }
    G_UseTargets(`self`, activator)
}

/// Source: oracle/codemp/game/g_target.c:520
func SP_target_relay(_ `self`: Entity) {
    `self`.use = Use.target_relay_use
    if (`self`.spawnflags & 128) != 0 {
        `self`.flags |= FL_INACTIVE
    }
}

/**
```
QUAKED target_kill (.5 .5 .5) (-8 -8 -8) (8 8 8)
Kills the activator.
```
*/
/// Source: oracle/codemp/game/g_target.c:534
func target_kill_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(`self`, BSET_USE)
    var dir: vec3_t? = nil
    G_Damage(activator, nil, nil, &dir, nil, 100000, DAMAGE_NO_PROTECTION, MOD_TELEFRAG)
}

/// Source: oracle/codemp/game/g_target.c:539
func SP_target_kill(_ `self`: Entity) {
    `self`.use = Use.target_kill_use
}

/**
```
QUAKED target_position (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for in-game calculation, like jumppad targets.
```
*/
/// Source: oracle/codemp/game/g_target.c:546
func SP_target_position(_ `self`: Entity) {
    G_SetOrigin(`self`, &`self`.s.origin)
    /*
    G_SetAngles( self, self->s.angles );
    self->s.eType = ET_INVISIBLE;
    */
}

/// Source: oracle/codemp/game/g_target.c:554
func target_location_linkup(_ ent: Entity) {
    var i: Int32
    var n: Int32
    // Raven walks his own `ent` parameter over `g_entities`, so the body walks the index of its slot, as for a walked local.
    var entIndex: Int32 = 0

    if level.locationLinked {
        return
    }

    level.locationLinked = true

    level.locationHead = nil

    trap_SetConfigstring(CS_LOCATIONS, "unknown")

    i = 0
    entIndex = 0
    n = 1
    while i < level.num_entities {
        if g_entities[entIndex].classname != nil && Q_stricmp(g_entities[entIndex].classname!, "target_location") == 0 {
            // lets overload some variables!
            g_entities[entIndex].health = n // use for location marking
            trap_SetConfigstring(CS_LOCATIONS + n, g_entities[entIndex].message!)
            n += 1
            g_entities[entIndex].nextTrain = level.locationHead
            level.locationHead = g_entities[entIndex]
        }
        i += 1
        entIndex += 1
    }

    // All linked together now
}

/**
```
QUAKED target_location (0 0.5 0) (-8 -8 -8) (8 8 8)
Set "message" to the name of this location.
Set "count" to 0-7 for color.
0:white 1:red 2:green 3:yellow 4:blue 5:cyan 6:magenta 7:white

Closest target_location in sight used for the location, if none
in site, closest in distance
```
*/
/// Source: oracle/codemp/game/g_target.c:592
func SP_target_location(_ `self`: Entity) {
    `self`.think = Think.target_location_linkup
    `self`.nextthink = level.time + 200 // Let them all spawn first

    G_SetOrigin(`self`, &`self`.s.origin)
}

/// Source: oracle/codemp/game/g_target.c:611
func target_counter_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if `self`.count == 0 {
        return
    }

    //gi.Printf("target_counter %s used by %s, entnum %d\n", self->targetname, activator->targetname, activator->s.number );
    `self`.count -= 1

    G_DebugPrint(WL_VERBOSE, "target_counter %s used by %s (%d/%d)\n", `self`.targetname!, activator.targetname!, (`self`.genericValue1 - `self`.count), `self`.genericValue1)

    if `self`.count != 0 {
        if `self`.target2 != nil {
            //gi.Printf("target_counter %s firing target2 from %s, entnum %d\n", self->targetname, activator->targetname, activator->s.number );
            G_UseTargets2(`self`, activator, `self`.target2!)
        }
        return
    }

    G_ActivateBehavior(`self`, BSET_USE)

    if (`self`.spawnflags & 128) != 0 {
        `self`.flags |= FL_INACTIVE
    }

    `self`.activator = activator
    G_UseTargets(`self`, activator)

    if `self`.count == 0 {
        if `self`.bounceCount == 0 {
            return
        }
        `self`.count = `self`.genericValue1
        if `self`.bounceCount > 0 {
            //-1 means bounce back forever
            `self`.bounceCount -= 1
        }
    }
}

/// Source: oracle/codemp/game/g_target.c:660
func SP_target_counter(_ `self`: Entity) {
    `self`.wait = -1
    if `self`.count == 0 {
        `self`.count = 2
    }
    //if ( self->bounceCount > 0 )//let's always set this anyway
    do {
        //we will reset when we use up our count, remember our initial count
        `self`.genericValue1 = `self`.count
    }

    `self`.use = Use.target_counter_use
}

/// Source: oracle/codemp/game/g_target.c:681
func target_random_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    var t_count: Int32 = 0
    let pick: Int32
    var t: Entity? = nil

    //gi.Printf("target_random %s used by %s (entnum %d)\n", self->targetname, activator->targetname, activator->s.number );
    G_ActivateBehavior(`self`, BSET_USE)

    if (`self`.spawnflags & 1) != 0 {
        `self`.use = nil
    }

    while let next = G_Find(t, \.targetname, `self`.target) {
        t = next
        if t!.s.number != `self`.s.number {
            t_count += 1
        }
    }
    t = nil

    if t_count == 0 {
        return
    }

    if t_count == 1 {
        G_UseTargets(`self`, activator)
        return
    }

    //FIXME: need a seed
    pick = Q_irand(1, t_count)
    t_count = 0
    while let next = G_Find(t, \.targetname, `self`.target) {
        t = next
        if t!.s.number != `self`.s.number {
            t_count += 1
        } else {
            continue
        }

        if t!.s.number == `self`.s.number {
            // gi.Printf ("WARNING: Entity used itself.\n");
        } else if t_count == pick {
            if t!.use != nil { // check can be omitted
                GlobalUse(t!, `self`, activator)
                return
            }
        }
        if !`self`.inuse {
            Com_Printf("entity was removed while using targets\n")
            return
        }
    }
}

/// Source: oracle/codemp/game/g_target.c:748
func SP_target_random(_ `self`: Entity) {
    `self`.use = Use.target_random_use
}

/// Source: oracle/codemp/game/g_target.c:754
func scriptrunner_run(_ `self`: Entity) {
    /*
    if (self->behaviorSet[BSET_USE])
    {
    char	newname[MAX_FILENAME_LENGTH];

    sprintf((char *) &newname, "%s/%s", Q3_SCRIPT_DIR, self->behaviorSet[BSET_USE] );

    ICARUS_RunScript( self, newname );
    }
    */

    if `self`.count != -1 {
        if `self`.count <= 0 {
            `self`.use = nil
            `self`.behaviorSet[BSET_USE] = nil
            return
        } else {
            `self`.count -= 1
        }
    }

    if `self`.behaviorSet[BSET_USE] != nil {
        if (`self`.spawnflags & 1) != 0 {
            if `self`.activator == nil {
                if g_developer.integer != 0 {
                    Com_Printf("target_scriptrunner tried to run on invalid entity!\n")
                }
                return
            }

            //if ( !self->activator->sequencer || !self->activator->taskManager )
            if !trap_ICARUS_IsInitialized(`self`.s.number) {
                //Need to be initialized through ICARUS
                if `self`.activator!.script_targetname == nil || `self`.activator!.script_targetname!.isEmpty {
                    //We don't have a script_targetname, so create a new one
                    `self`.activator!.script_targetname = va("newICARUSEnt%d", numNewICARUSEnts)
                    numNewICARUSEnts += 1
                }

                if trap_ICARUS_ValidEnt(`self`.activator!) {
                    trap_ICARUS_InitEnt(`self`.activator!)
                } else {
                    if g_developer.integer != 0 {
                        Com_Printf("target_scriptrunner tried to run on invalid ICARUS activator!\n")
                    }
                    return
                }
            }

            if g_developer.integer != 0 {
                Com_Printf("target_scriptrunner running %s on activator %s\n", `self`.behaviorSet[BSET_USE]!, `self`.activator!.targetname!)
            }
            trap_ICARUS_RunScript(`self`.activator!, va("%s/%s", Q3_SCRIPT_DIR, `self`.behaviorSet[BSET_USE]!))
        } else {
            if g_developer.integer != 0 && `self`.activator != nil {
                Com_Printf("target_scriptrunner %s used by %s\n", `self`.targetname!, `self`.activator!.targetname!)
            }
            G_ActivateBehavior(`self`, BSET_USE)
        }
    }

    if `self`.wait != 0 {
        `self`.nextthink = Int32(level.time + `self`.wait)
    }
}

/// Source: oracle/codemp/game/g_target.c:839
func target_scriptrunner_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if `self`.nextthink > level.time {
        return
    }

    `self`.activator = activator
    `self`.enemy = other
    if `self`.delay != 0 {
        //delay before firing scriptrunner
        `self`.think = Think.scriptrunner_run
        `self`.nextthink = level.time + `self`.delay
    } else {
        scriptrunner_run(`self`)
    }
}

/**
```
QUAKED target_scriptrunner (1 0 0) (-4 -4 -4) (4 4 4) runonactivator x x x x x x INACTIVE
--- SPAWNFLAGS ---
runonactivator - Will run the script on the entity that used this or tripped the trigger that used this
INACTIVE - start off

----- KEYS ------
Usescript - Script to run when used
count - how many times to run, -1 = infinite.  Default is once
wait - can't be used again in this amount of seconds (Default is 1 second if it's multiple-use)
delay - how long to wait after use to run script
```
*/
/// Source: oracle/codemp/game/g_target.c:871
func SP_target_scriptrunner(_ `self`: Entity) {
    var v: Float = 0
    if (`self`.spawnflags & 128) != 0 {
        `self`.flags |= FL_INACTIVE
    }

    if `self`.count == 0 {
        `self`.count = 1 //default 1 use only
    }
    /*
    else if ( !self->wait )
    {
    self->wait = 1;//default wait of 1 sec
    }
    */
    // FIXME: this is a hack... because delay is read in as an int, so I'm bypassing that because it's too late in the project to change it and I want to be able to set less than a second delays
    // no one should be setting a radius on a scriptrunner, if they are this would be bad, take this out for the next project
    v = 0.0
    G_SpawnFloat("delay", "0", &v)
    `self`.delay = Int32(v * 1000) //sec to ms
    `self`.wait *= 1000 //sec to ms

    G_SetOrigin(`self`, &`self`.s.origin)
    `self`.use = Use.target_scriptrunner_use
}

/// Source: oracle/codemp/game/g_target.c:900
func G_SetActiveState(_ targetstring: String, _ actState: Bool) {
    var target: Entity? = nil
    while let next = G_Find(target, \.targetname, targetstring) {
        target = next
        target!.flags = actState ? (target!.flags & ~FL_INACTIVE) : (target!.flags | FL_INACTIVE)
    }
}

/// Source: oracle/codemp/game/g_target.c:912
func target_activate_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(`self`, BSET_USE)

    G_SetActiveState(`self`.target!, true)
}

/// Source: oracle/codemp/game/g_target.c:919
func target_deactivate_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(`self`, BSET_USE)

    G_SetActiveState(`self`.target!, false)
}

//FIXME: make these apply to doors, etc too?
/**
```
QUAKED target_activate (1 0 0) (-4 -4 -4) (4 4 4)
Will set the target(s) to be usable/triggerable
```
*/
/// Source: oracle/codemp/game/g_target.c:930
func SP_target_activate(_ `self`: Entity) {
    G_SetOrigin(`self`, &`self`.s.origin)
    `self`.use = Use.target_activate_use
}

/**
```
QUAKED target_deactivate (1 0 0) (-4 -4 -4) (4 4 4)
Will set the target(s) to be non-usable/triggerable
```
*/
/// Source: oracle/codemp/game/g_target.c:939
func SP_target_deactivate(_ `self`: Entity) {
    G_SetOrigin(`self`, &`self`.s.origin)
    `self`.use = Use.target_deactivate_use
}

/// Source: oracle/codemp/game/g_target.c:945
func target_level_change_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(`self`, BSET_USE)

    trap_SendConsoleCommand(EXEC_NOW, va("map %s", `self`.message!))
}

/**
```
QUAKED target_level_change (1 0 0) (-4 -4 -4) (4 4 4)
"mapname" - Name of map to change to
```
*/
/// Source: oracle/codemp/game/g_target.c:955
func SP_target_level_change(_ `self`: Entity) {
    var s: String = ""

    G_SpawnString("mapname", "", &s)
    `self`.message = G_NewString(s)

    if `self`.message == nil || `self`.message!.isEmpty {
        G_Error("target_level_change with no mapname!\n")
        return
    }

    G_SetOrigin(`self`, &`self`.s.origin)
    `self`.use = Use.target_level_change_use
}

/// Source: oracle/codemp/game/g_target.c:972
func target_play_music_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(`self`, BSET_USE)
    trap_SetConfigstring(CS_MUSIC, `self`.message!)
}

/**
```
QUAKED target_play_music (1 0 0) (-4 -4 -4) (4 4 4)
target_play_music
Plays the requested music files when this target is used.

"targetname"
"music"		music WAV or MP3 file ( music/introfile.mp3 [optional]  music/loopfile.mp3 )

If an intro file and loop file are specified, the intro plays first, then the looping
portion will start and loop indefinetly.  If no introfile is entered, only the loopfile
will play.
```
*/
/// Source: oracle/codemp/game/g_target.c:989
func SP_target_play_music(_ `self`: Entity) {
    var s: String = ""

    G_SetOrigin(`self`, &`self`.s.origin)
    if !G_SpawnString("music", "", &s) {
        G_Error("target_play_music without a music key at %s", vtos(`self`.s.origin))
    }

    `self`.message = G_NewString(s)

    `self`.use = Use.target_play_music_use
}
