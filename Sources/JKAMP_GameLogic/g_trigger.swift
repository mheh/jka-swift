import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_trigger.c:6
var gTrigFallSound: Int32 {
    get { world.variables.gTrigFallSound }
    set { world.variables.gTrigFallSound = newValue }
}

/// Source: oracle/codemp/game/g_trigger.c:895
let PUSH_LINEAR = 4 as Int32

/// Source: oracle/codemp/game/g_trigger.c:896
let PUSH_RELATIVE = 16 as Int32

/// Source: oracle/codemp/game/g_trigger.c:897
let PUSH_MULTIPLE = 2048 as Int32

/// Source: oracle/codemp/game/g_trigger.c:899
let PUSH_CONSTANT = 2 as Int32

/// Source: oracle/codemp/game/g_trigger.c:1441
let INITIAL_SUFFOCATION_DELAY = 500 as Int32

/// Source: oracle/codemp/game/g_trigger.c:8
func InitTrigger(_ `self`: Entity) {
    if VectorCompare(`self`.s.angles, vec3_origin) == 0 {
        G_SetMovedir(&`self`.s.angles, &`self`.movedir)
    }

    trap_SetBrushModel(`self`, `self`.model!)
    `self`.r.contents = CONTENTS_TRIGGER // replaces the -1 from trap_SetBrushModel
    `self`.r.svFlags = SVF_NOCLIENT

    if (`self`.spawnflags & 128) != 0 {
        `self`.flags |= FL_INACTIVE
    }
}

// the wait time has passed, so set back up for another activation
/// Source: oracle/codemp/game/g_trigger.c:23
func multi_wait(_ ent: Entity) {
    ent.nextthink = 0
}

// the trigger was just activated
// ent->activator should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
/// Source: oracle/codemp/game/g_trigger.c:32
func multi_trigger_run(_ ent: Entity) {
    ent.think = nil

    G_ActivateBehavior(ent, BSET_USE)

    if ent.soundSet != nil && !ent.soundSet!.isEmpty {
        trap_SetConfigstring(CS_GLOBAL_AMBIENT_SET, ent.soundSet!)
    }

    if ent.genericValue4 != 0 {
        //we want to activate target3 for team1 or target4 for team2
        if ent.genericValue4 == SIEGETEAM_TEAM1 && ent.target3 != nil && !ent.target3!.isEmpty {
            G_UseTargets2(ent, ent.activator!, ent.target3!)
        } else if ent.genericValue4 == SIEGETEAM_TEAM2 && ent.target4 != nil && !ent.target4!.isEmpty {
            G_UseTargets2(ent, ent.activator!, ent.target4!)
        }

        ent.genericValue4 = 0
    }

    G_UseTargets(ent, ent.activator)
    if ent.noise_index != 0 {
        G_Sound(ent.activator!, CHAN_AUTO, ent.noise_index)
    }

    if ent.target2 != nil && !ent.target2!.isEmpty && ent.wait >= 0 {
        ent.think = Think.trigger_cleared_fire
        ent.nextthink = Int32(level.time + ent.speed)
    } else if ent.wait > 0 {
        if ent.painDebounceTime != level.time {
            //first ent to touch it this frame
            //ent->e_ThinkFunc = thinkF_multi_wait;
            ent.nextthink = Int32(level.time + (ent.wait + ent.random * crandom()) * 1000)
            ent.painDebounceTime = level.time
        }
    } else if ent.wait < 0 {
        // we can't just remove (self) here, because this is a touch function
        // called while looping through area links...
        ent.r.contents &= ~CONTENTS_TRIGGER //so the EntityContact trace doesn't have to be done against me
        ent.think = nil
        ent.use = nil
        //Don't remove, Icarus may barf?
        //ent->nextthink = level.time + FRAMETIME;
        //ent->think = G_FreeEntity;
    }
    if ent.activator != nil && ent.activator!.client != nil {
        // mark the trigger as being touched by the player
        ent.aimDebounceTime = level.time
    }
}

//determine if the class given is listed in the string using the | formatting
/// Source: oracle/codemp/game/g_trigger.c:97
func G_NameInTriggerClassList(_ list: String, _ str: String) -> Bool {
    let list = CharBuf(list)
    var cmp = CharBuf(1024)
    var i: Int32 = 0
    var j: Int32

    while list[i] != 0 {
        j = 0
        while list[i] != 0 && list[i] != Int32(ascii: "|") {
            cmp[j] = list[i]
            i += 1
            j += 1
        }
        cmp[j] = 0

        if Q_stricmp(str, String(cmp)) == 0 {
            //found it
            return true
        }
        if list[i] != Int32(ascii: "|") {
            //reached the end and never found it
            return false
        }
        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/g_trigger.c:130
func multi_trigger(_ ent: Entity, _ activator: Entity) {
    var haltTrigger: Bool = false

    if ent.think == Think.multi_trigger_run {
        //already triggered, just waiting to run
        return
    }

    if g_gametype.integer == GT_SIEGE && !gSiegeRoundBegun {
        //nothing can be used til the round starts.
        return
    }

    if g_gametype.integer == GT_SIEGE && activator.client != nil && ent.alliedTeam != 0 && activator.client!.sess.sessionTeam != ent.alliedTeam {
        //this team can't activate this trigger.
        return
    }

    if g_gametype.integer == GT_SIEGE && ent.idealclass != nil && !ent.idealclass!.isEmpty {
        //only certain classes can activate it
        if activator.client == nil || activator.client!.siegeClass < 0 {
            //no class
            return
        }

        if !G_NameInTriggerClassList(bgSiegeClasses[activator.client!.siegeClass].name, ent.idealclass!) {
            //wasn't in the list
            return
        }
    }

    if g_gametype.integer == GT_SIEGE && ent.genericValue1 != 0 {
        haltTrigger = true

        if activator.client != nil && activator.client!.holdingObjectiveItem != 0 && ent.targetname != nil && !ent.targetname!.isEmpty {
            let objItem: Entity? = g_entities[activator.client!.holdingObjectiveItem]

            if objItem != nil && objItem!.inuse {
                if objItem!.goaltarget != nil && !objItem!.goaltarget!.isEmpty && Q_stricmp(ent.targetname!, objItem!.goaltarget!) == 0 {
                    if objItem!.genericValue7 != activator.client!.sess.sessionTeam {
                        //The carrier of the item is not on the team which disallows objective scoring for it
                        if objItem!.target3 != nil && !objItem!.target3!.isEmpty {
                            //if it has a target3, fire it off instead of using the trigger
                            G_UseTargets2(objItem!, objItem!, objItem!.target3!)

                            //3-24-03 - want to fire off the target too I guess, if we have one.
                            if ent.targetname != nil && !ent.targetname!.isEmpty {
                                haltTrigger = false
                            }
                        } else {
                            haltTrigger = false
                        }

                        //now that the item has been delivered, it can go away.
                        SiegeItemRemoveOwner(objItem!, activator)
                        objItem!.nextthink = 0
                        objItem!.neverFree = false
                        G_FreeEntity(objItem!)
                    }
                }
            }
        }
    } else if ent.genericValue1 != 0 {
        //Never activate in non-siege gametype I guess.
        return
    }

    if ent.genericValue2 != 0 {
        //has "teambalance" property
        var i: Int32 = 0
        var team1ClNum: Int32 = 0
        var team2ClNum: Int32 = 0
        let owningTeam: Int32 = ent.genericValue3
        var newOwningTeam: Int32 = 0
        var numEnts: Int32 = 0
        var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
        var cl: Entity?

        if g_gametype.integer != GT_SIEGE {
            return
        }

        if activator.client == nil || (activator.client!.sess.sessionTeam != SIEGETEAM_TEAM1 && activator.client!.sess.sessionTeam != SIEGETEAM_TEAM2) {
            //activator must be a valid client to begin with
            return
        }

        //Count up the number of clients standing within the bounds of the trigger and the number of them on each team
        numEnts = trap_EntitiesInBox(ent.r.absmin, ent.r.absmax, &entityList, MAX_GENTITIES)
        while i < numEnts {
            if entityList[i] < MAX_CLIENTS {
                //only care about clients
                cl = g_entities[entityList[i]]

                //the client is valid
                if cl!.inuse && cl!.client != nil && (cl!.client!.sess.sessionTeam == SIEGETEAM_TEAM1 || cl!.client!.sess.sessionTeam == SIEGETEAM_TEAM2) && cl!.health > 0 && !((cl!.client!.ps.eFlags & EF_DEAD) != 0) {
                    //See which team he's on
                    if cl!.client!.sess.sessionTeam == SIEGETEAM_TEAM1 {
                        team1ClNum += 1
                    } else {
                        team2ClNum += 1
                    }
                }
            }
            i += 1
        }

        if team1ClNum == 0 && team2ClNum == 0 {
            //no one in the box? How did we get activated? Oh well.
            return
        }

        if team1ClNum == team2ClNum {
            //if equal numbers the ownership will remain the same as it is now
            return
        }

        //decide who owns it now
        if team1ClNum > team2ClNum {
            newOwningTeam = SIEGETEAM_TEAM1
        } else {
            newOwningTeam = SIEGETEAM_TEAM2
        }

        if owningTeam == newOwningTeam {
            //it's the same one it already was, don't care then.
            return
        }

        //Set the new owner and set the variable which will tell us to activate a team-specific target
        ent.genericValue3 = newOwningTeam
        ent.genericValue4 = newOwningTeam
    }

    if haltTrigger {
        //This is an objective trigger and the activator is not carrying an objective item that matches the targetname.
        return
    }

    if ent.nextthink > level.time {
        if (ent.spawnflags & 2048) != 0 {
            if ent.painDebounceTime != 0 && ent.painDebounceTime != level.time {
                //this should still allow subsequent ents to fire this trigger in the current frame
                return // can't retrigger until the wait is over
            }
        } else {
            return
        }
    }

    // if the player has already activated this trigger this frame
    if activator.s.number == 0 && ent.aimDebounceTime == level.time {
        return
    }

    if (ent.flags & FL_INACTIVE) != 0 {
        //Not active at this time
        return
    }

    ent.activator = activator

    if ent.delay != 0 && ent.painDebounceTime < (level.time + ent.delay) {
        //delay before firing trigger
        ent.think = Think.multi_trigger_run
        ent.nextthink = level.time + ent.delay
        ent.painDebounceTime = level.time
    } else {
        multi_trigger_run(ent)
    }
}

/// Source: oracle/codemp/game/g_trigger.c:343
func Use_Multi(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    multi_trigger(ent, activator)
}

/// Source: oracle/codemp/game/g_trigger.c:350
func Touch_Multi(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if other.client == nil {
        return
    }

    if (`self`.flags & FL_INACTIVE) != 0 {
        //set by target_deactivate
        return
    }

    if `self`.alliedTeam != 0 {
        if other.client!.sess.sessionTeam != `self`.alliedTeam {
            return
        }
    }

    // moved to just above multi_trigger because up here it just checks if the trigger is not being touched
    // we want it to check any conditions set on the trigger, if one of those isn't met, the trigger is considered to be "cleared"
    //	if ( self->e_ThinkFunc == thinkF_trigger_cleared_fire )
    //	{//We're waiting to fire our target2 first
    //		self->nextthink = level.time + self->speed;
    //		return;
    //	}

    if (`self`.spawnflags & 1) != 0 {
        if other.s.eType == ET_NPC {
            return
        }
    } else {
        if (`self`.spawnflags & 16) != 0 {
            //NPCONLY
            if other.NPC == nil {
                return
            }
        }

        if `self`.NPC_targetname != nil && !`self`.NPC_targetname!.isEmpty {
            if other.script_targetname != nil && !other.script_targetname!.isEmpty {
                if Q_stricmp(`self`.NPC_targetname!, other.script_targetname!) != 0 {
                    //not the right guy to fire me off
                    return
                }
            } else {
                return
            }
        }
    }

    if (`self`.spawnflags & 2) != 0 {
        //FACING
        var forward = vec3_t()

        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(other.client!.ps.viewangles, &forward, &scratchRight, &scratchUp)

        if Double(_DotProduct(`self`.movedir, forward)) < 0.5 {
            //Not Within 45 degrees
            return
        }
    }

    if (`self`.spawnflags & 4) != 0 {
        //USE_BUTTON
        if !((other.client!.pers.cmd.buttons & BUTTON_USE) != 0) {
            //not pressing use button
            return
        }

        if (other.client!.ps.weaponTime > 0 && other.client!.ps.torsoAnim != BOTH_BUTTON_HOLD && other.client!.ps.torsoAnim != BOTH_CONSOLE1) || other.health < 1 || (other.client!.ps.pm_flags & PMF_FOLLOW) != 0 || other.client!.sess.sessionTeam == TEAM_SPECTATOR || other.client!.ps.forceHandExtend != HANDEXTEND_NONE {
            //player has to be free of other things to use.
            return
        }

        if `self`.genericValue7 != 0 {
            //we have to be holding the use key in this trigger for x milliseconds before firing
            if g_gametype.integer == GT_SIEGE && `self`.idealclass != nil && !`self`.idealclass!.isEmpty {
                //only certain classes can activate it
                if other.client == nil || other.client!.siegeClass < 0 {
                    //no class
                    return
                }

                if !G_NameInTriggerClassList(bgSiegeClasses[other.client!.siegeClass].name, `self`.idealclass!) {
                    //wasn't in the list
                    return
                }
            }

            if !G_PointInBounds(other.client!.ps.origin, `self`.r.absmin, `self`.r.absmax) {
                return
            } else if other.client!.isHacking != `self`.s.number && other.s.number < MAX_CLIENTS {
                //start the hack
                other.client!.isHacking = `self`.s.number
                other.client!.hackingAngles = other.client!.ps.viewangles
                other.client!.ps.hackingTime = level.time + `self`.genericValue7
                other.client!.ps.hackingBaseTime = `self`.genericValue7
                if other.client!.ps.hackingBaseTime > 60000 {
                    //don't allow a bit overflow
                    other.client!.ps.hackingTime = level.time + 60000
                    other.client!.ps.hackingBaseTime = 60000
                }
                return
            } else if other.client!.ps.hackingTime < level.time {
                //finished with the hack, reset the hacking values and let it fall through
                other.client!.isHacking = 0 //can't hack a client
                other.client!.ps.hackingTime = 0
            } else {
                //hack in progress
                return
            }
        }
    }

    if (`self`.spawnflags & 8) != 0 {
        //FIRE_BUTTON
        if !((other.client!.pers.cmd.buttons & BUTTON_ATTACK) != 0) && !((other.client!.pers.cmd.buttons & BUTTON_ALT_ATTACK) != 0) {
            //not pressing fire button or altfire button
            return
        }
    }

    if `self`.radius != 0 {
        var eyeSpot = vec3_t()

        //Only works if your head is in it, but we allow leaning out
        //NOTE: We don't use CalcEntitySpot SPOT_HEAD because we don't want this
        //to be reliant on the physical model the player uses.
        eyeSpot = other.client!.ps.origin
        eyeSpot[2] += other.client!.ps.viewheight

        if G_PointInBounds(eyeSpot, `self`.r.absmin, `self`.r.absmax) {
            if !((other.client!.pers.cmd.buttons & BUTTON_ATTACK) != 0) && !((other.client!.pers.cmd.buttons & BUTTON_ALT_ATTACK) != 0) {
                //not attacking, so hiding bonus
                /*
                //FIXME:  should really have sound events clear the hiddenDist
                other->client->hiddenDist = self->radius;
                //NOTE: movedir HAS to be normalized!
                if ( VectorLength( self->movedir ) )
                {//They can only be hidden from enemies looking in this direction
                VectorCopy( self->movedir, other->client->hiddenDir );
                }
                else
                {
                VectorClear( other->client->hiddenDir );
                }
                */
                //Not using this, at least not yet.
            }
        }
    }

    if (`self`.spawnflags & 4) != 0 {
        //USE_BUTTON
        if other.client!.ps.torsoAnim != BOTH_BUTTON_HOLD && other.client!.ps.torsoAnim != BOTH_CONSOLE1 {
            G_SetAnim(other, nil, SETANIM_TORSO, BOTH_BUTTON_HOLD, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
        } else {
            other.client!.ps.torsoTimer = 500
        }
        other.client!.ps.weaponTime = other.client!.ps.torsoTimer
    }

    if `self`.think == Think.trigger_cleared_fire {
        //We're waiting to fire our target2 first
        `self`.nextthink = Int32(level.time + `self`.speed)
        return
    }

    multi_trigger(`self`, other)
}

/// Source: oracle/codemp/game/g_trigger.c:549
func trigger_cleared_fire(_ `self`: Entity) {
    G_UseTargets2(`self`, `self`.activator!, `self`.target2!)
    `self`.think = nil
    // should start the wait timer now, because the trigger's just been cleared, so we must "wait" from this point
    if `self`.wait > 0 {
        `self`.nextthink = Int32(level.time + (`self`.wait + `self`.random * crandom()) * 1000)
    }
}

/**
```
QUAKED trigger_multiple (.1 .5 .1) ? CLIENTONLY FACING USE_BUTTON FIRE_BUTTON NPCONLY x x INACTIVE MULTIPLE
CLIENTONLY - only a player can trigger this by touch
FACING - Won't fire unless triggering ent's view angles are within 45 degrees of trigger's angles (in addition to any other conditions)
USE_BUTTON - Won't fire unless player is in it and pressing use button (in addition to any other conditions)
FIRE_BUTTON - Won't fire unless player/NPC is in it and pressing fire button (in addition to any other conditions)
NPCONLY - only non-player NPCs can trigger this by touch
INACTIVE - Start off, has to be activated to be touchable/usable
MULTIPLE - multiple entities can touch this trigger in a single frame *and* if needed, the trigger can have a wait of > 0

"wait"		Seconds between triggerings, 0 default, number < 0 means one time only.
"random"	wait variance, default is 0
"delay"		how many seconds to wait to fire targets after tripped
"hiderange" As long as NPC's head is in this trigger, NPCs out of this hiderange cannot see him.  If you set an angle on the trigger, they're only hidden from enemies looking in that direction.  the player's crouch viewheight is 36, his standing viewheight is 54.  So a trigger thast should hide you when crouched but not standing should be 48 tall.
"target2"	The trigger will fire this only when the trigger has been activated and subsequently 'cleared'( once any of the conditions on the trigger have not been satisfied).  This will not fire the "target" more than once until the "target2" is fired (trigger field is 'cleared')
"speed"		How many seconds to wait to fire the target2, default is 1
"noise"		Sound to play when the trigger fires (plays at activator's origin)
"NPC_targetname"  Only the NPC with this NPC_targetname fires this trigger

Variable sized repeatable trigger.  Must be targeted at one or more entities.
so, the basic time between firing is a random time between
(wait - random) and (wait + random)

"team" - If set, only this team can trip this trigger
	0 - any
	1 - red
	2 - blue

"soundSet"	Ambient sound set to play when this trigger is activated

usetime		-	If specified (in milliseconds) along with the USE_BUTTON flag, will
				require a client to hold the use key for x amount of ms before firing.

Applicable only during Siege gametype:
teamuser	-	if 1, team 2 can't use this. If 2, team 1 can't use this.
siegetrig	-	if non-0, can only be activated by players carrying a misc_siege_item
				which is associated with this trigger by the item's goaltarget value.
teambalance	-	if non-0, is "owned" by the last team that activated. Can only be activated
				by the other team if the number of players on the other team inside	the
				trigger outnumber the number of players on the owning team inside the
				trigger.
target3		-	fire when activated by team1
target4		-	fire when activated by team2

idealclass	-	Can only be used by this class/these classes. You can specify use by
				multiple classes with the use of |, e.g.:
				"Imperial Medic|Imperial Assassin|Imperial Demolitionist"
```
*/
/// Source: oracle/codemp/game/g_trigger.c:607
func SP_trigger_multiple(_ ent: Entity) {
    var s: String = ""
    if G_SpawnString("noise", "", &s) {
        if !s.isEmpty {
            ent.noise_index = G_SoundIndex(s)
        } else {
            ent.noise_index = 0
        }
    }

    G_SpawnInt("usetime", "0", &ent.genericValue7)

    //For siege gametype
    G_SpawnInt("siegetrig", "0", &ent.genericValue1)
    G_SpawnInt("teambalance", "0", &ent.genericValue2)

    G_SpawnInt("delay", "0", &ent.delay)

    if (ent.wait > 0) && (ent.random >= ent.wait) {
        ent.random = ent.wait - FRAMETIME
        Com_Printf(S_COLOR_YELLOW + "trigger_multiple has random >= wait\n")
    }

    ent.delay *= 1000 //1 = 1 msec, 1000 = 1 sec
    if ent.speed == 0 && ent.target2 != nil && !ent.target2!.isEmpty {
        ent.speed = 1000
    } else {
        ent.speed *= 1000
    }

    ent.touch = Touch.Touch_Multi
    ent.use = Use.Use_Multi

    if ent.team != nil && !ent.team!.isEmpty {
        ent.alliedTeam = atoi(ent.team!)
        ent.team = nil
    }

    InitTrigger(ent)
    trap_LinkEntity(ent)
}

/**
```
QUAKED trigger_once (.5 1 .5) ? CLIENTONLY FACING USE_BUTTON FIRE_BUTTON x x x INACTIVE MULTIPLE
CLIENTONLY - only a player can trigger this by touch
FACING - Won't fire unless triggering ent's view angles are within 45 degrees of trigger's angles (in addition to any other conditions)
USE_BUTTON - Won't fire unless player is in it and pressing use button (in addition to any other conditions)
FIRE_BUTTON - Won't fire unless player/NPC is in it and pressing fire button (in addition to any other conditions)
INACTIVE - Start off, has to be activated to be touchable/usable
MULTIPLE - multiple entities can touch this trigger in a single frame *and* if needed, the trigger can have a wait of > 0

"random"	wait variance, default is 0
"delay"		how many seconds to wait to fire targets after tripped
Variable sized repeatable trigger.  Must be targeted at one or more entities.
so, the basic time between firing is a random time between
(wait - random) and (wait + random)
"noise"		Sound to play when the trigger fires (plays at activator's origin)
"NPC_targetname"  Only the NPC with this NPC_targetname fires this trigger

"team" - If set, only this team can trip this trigger
	0 - any
	1 - red
	2 - blue

"soundSet"	Ambient sound set to play when this trigger is activated

usetime		-	If specified (in milliseconds) along with the USE_BUTTON flag, will
				require a client to hold the use key for x amount of ms before firing.

Applicable only during Siege gametype:
teamuser - if 1, team 2 can't use this. If 2, team 1 can't use this.
siegetrig - if non-0, can only be activated by players carrying a misc_siege_item
			which is associated with this trigger by the item's goaltarget value.

idealclass	-	Can only be used by this class/these classes. You can specify use by
				multiple classes with the use of |, e.g.:
				"Imperial Medic|Imperial Assassin|Imperial Demolitionist"
```
*/
/// Source: oracle/codemp/game/g_trigger.c:694
func SP_trigger_once(_ ent: Entity) {
    var s: String = ""
    if G_SpawnString("noise", "", &s) {
        if !s.isEmpty {
            ent.noise_index = G_SoundIndex(s)
        } else {
            ent.noise_index = 0
        }
    }

    G_SpawnInt("usetime", "0", &ent.genericValue7)

    //For siege gametype
    G_SpawnInt("siegetrig", "0", &ent.genericValue1)

    G_SpawnInt("delay", "0", &ent.delay)

    ent.wait = -1

    ent.touch = Touch.Touch_Multi
    ent.use = Use.Use_Multi

    if ent.team != nil && !ent.team!.isEmpty {
        ent.alliedTeam = atoi(ent.team!)
        ent.team = nil
    }

    ent.delay *= 1000 //1 = 1 msec, 1000 = 1 sec

    InitTrigger(ent)
    trap_LinkEntity(ent)
}

/**
```
======================================================================
trigger_lightningstrike -rww
======================================================================
```
*/
//lightning strike trigger lightning strike event
/// Source: oracle/codemp/game/g_trigger.c:739
func Do_Strike(_ ent: Entity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { localTrace -> Bool in
        var strikeFrom = vec3_t()
        var strikePoint = vec3_t()
        var fxAng = vec3_t()

        //maybe allow custom fx direction at some point?
        fxAng = vec3_t(90.0, 0.0, 0.0)

        //choose a random point to strike within the bounds of the trigger
        strikePoint[0] = flrand(ent.r.absmin[0], ent.r.absmax[0])
        strikePoint[1] = flrand(ent.r.absmin[1], ent.r.absmax[1])

        //consider the bottom mins the ground level
        strikePoint[2] = ent.r.absmin[2]

        //set the from point
        strikeFrom[0] = strikePoint[0]
        strikeFrom[1] = strikePoint[1]
        strikeFrom[2] = ent.r.absmax[2] - 4.0

        //now trace for damaging stuff, and do the effect
        trap_Trace(localTrace, strikeFrom, vec3_origin, vec3_origin, strikePoint, ent.s.number, MASK_PLAYERSOLID)
        strikePoint = localTrace.endpos

        if localTrace.startsolid != 0 || localTrace.allsolid != 0 {
            //got a bad spot, think again next frame to try another strike
            ent.nextthink = level.time
            return true
        }

        if ent.radius != 0 {
            //do a radius damage at the end pos
            G_RadiusDamage(strikePoint, ent, Float(ent.damage), ent.radius, ent, nil, MOD_SUICIDE)
        } else {
            //only damage individuals
            let trHit: Entity? = g_entities[localTrace.entityNum]

            if trHit!.inuse && trHit!.takedamage {
                //damage it then
                var dir: vec3_t? = nil
                G_Damage(trHit!, ent, ent, &dir, trHit!.r.currentOrigin, ent.damage, 0, MOD_SUICIDE)
            }
        }

        G_PlayEffectID(ent.genericValue2, strikeFrom, fxAng)
        return false
    }
    if earlyOut {
        return
    }
}

//lightning strike trigger think loop
/// Source: oracle/codemp/game/g_trigger.c:789
func Think_Strike(_ ent: Entity) {
    if ent.genericValue1 != 0 {
        //turned off currently
        return
    }

    ent.nextthink = Int32(level.time + ent.wait + Q_irand(0, Int32(ent.random)))
    Do_Strike(ent)
}

//lightning strike trigger use event function
/// Source: oracle/codemp/game/g_trigger.c:801
func Use_Strike(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    ent.genericValue1 = (ent.genericValue1 == 0 ? 1 : 0)

    if ent.genericValue1 == 0 {
        //turn it back on
        ent.nextthink = level.time
    }
}

/**
```
QUAKED trigger_lightningstrike (.1 .5 .1) ? START_OFF
START_OFF - start trigger disabled

"lightningfx"	effect to use for lightning, MUST be specified
"wait"			Seconds between strikes, 1000 default
"random"		wait variance, default is 2000
"dmg"			damage on strike (default 50)
"radius"		if non-0, does a radius damage at the lightning strike
				impact point (using this value as the radius). otherwise
				will only do line trace damage. default 0.

use to toggle on and off
```
*/
/// Source: oracle/codemp/game/g_trigger.c:824
func SP_trigger_lightningstrike(_ ent: Entity) {
    var s: String = ""

    ent.use = Use.Use_Strike
    ent.think = Think.Think_Strike
    ent.nextthink = level.time + 500

    G_SpawnString("lightningfx", "", &s)
    if s.isEmpty {
        Com_Error(ERR_DROP, "trigger_lightningstrike with no lightningfx")
    }

    //get a configstring index for it
    ent.genericValue2 = G_EffectIndex(s)

    if (ent.spawnflags & 1) != 0 {
        //START_OFF
        ent.genericValue1 = 1
    }

    if ent.wait == 0 {
        //default 1000
        ent.wait = 1000
    }
    if ent.random == 0 {
        //default 2000
        ent.random = 2000
    }
    if ent.damage == 0 {
        //default 50
        ent.damage = 50
    }

    InitTrigger(ent)
    trap_LinkEntity(ent)
}

/// Source: oracle/codemp/game/g_trigger.c:872
func trigger_always_think(_ ent: Entity) {
    G_UseTargets(ent, ent)
    G_FreeEntity(ent)
}

/**
```
QUAKED trigger_always (.5 .5 .5) (-8 -8 -8) (8 8 8)
This trigger will always fire.  It is activated by the world.
```
*/
/// Source: oracle/codemp/game/g_trigger.c:880
func SP_trigger_always(_ ent: Entity) {
    // we must have some delay to make sure our use targets are present
    ent.nextthink = level.time + 300
    ent.think = Think.trigger_always_think
}

/// Source: oracle/codemp/game/g_trigger.c:901
func trigger_push_touch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if (`self`.flags & FL_INACTIVE) != 0 {
        //set by target_deactivate
        return
    }

    if !((`self`.spawnflags & PUSH_LINEAR) != 0) {
        //normal throw
        if other.client == nil {
            return
        }
        BG_TouchJumpPad(other.client!.ps, `self`.s)
        return
    }

    //linear
    if level.time < `self`.painDebounceTime + `self`.wait {
        if (`self`.spawnflags & PUSH_MULTIPLE) != 0 {
            if `self`.painDebounceTime != 0 && level.time > `self`.painDebounceTime {
                return
            }
        } else {
            return
        }
    }

    /*
    //???
    // if the player has already activated this trigger this frame
    if( other && !other->s.number && self->aimDebounceTime == level.time )
    {
    return;
    }
    */

    /*
    if( self->spawnflags & PUSH_CONVEYOR )
    {   // only push player if he's on the ground
    if( other->s.groundEntityNum == ENTITYNUM_NONE )
    {
    return;
    }
    }
    */

    /*
    if ( self->spawnflags & 1 )
    {//PLAYERONLY
    if ( other->s.number >= MAX_CLIENTS )
    {
    return;
    }
    }
    else
    {
    if ( self->spawnflags & 8 )
    {//NPCONLY
    if ( other->NPC == NULL )
    {
    return;
    }
    }
    }
    */

    if other.client == nil {
        if other.s.pos.trType != TR_STATIONARY && other.s.pos.trType != TR_LINEAR_STOP && other.s.pos.trType != TR_NONLINEAR_STOP && VectorLengthSquared(other.s.pos.trDelta) != 0 {
            //already moving
            other.s.pos.trBase = other.r.currentOrigin
            other.s.pos.trDelta = `self`.s.origin2
            other.s.pos.trTime = level.time
        }
        return
    }

    if other.client!.ps.pm_type != PM_NORMAL && other.client!.ps.pm_type != PM_DEAD && other.client!.ps.pm_type != PM_FREEZE {
        return
    }

    if (`self`.spawnflags & PUSH_RELATIVE) != 0 {
        //relative, dir to it * speed
        var dir = vec3_t()
        dir = `self`.s.origin2 - other.r.currentOrigin
        if `self`.speed != 0 {
            VectorNormalize(&dir)
            dir = dir * `self`.speed
        }
        other.client!.ps.velocity = dir
    } else if (`self`.spawnflags & PUSH_LINEAR) != 0 {
        //linear dir * speed
        other.client!.ps.velocity = `self`.s.origin2 * `self`.speed
    } else {
        other.client!.ps.velocity = `self`.s.origin2
    }
    //so we don't take damage unless we land lower than we start here...
    /*
    other->client->ps.forceJumpZStart = 0;
    other->client->ps.pm_flags |= PMF_TRIGGER_PUSHED;//pushed by a trigger
    other->client->ps.jumpZStart = other->client->ps.origin[2];
    */

    if `self`.wait == -1 {
        `self`.touch = nil
    } else if `self`.wait > 0 {
        `self`.painDebounceTime = level.time
    }
    /*
    if( other && !other->s.number )
    {	// mark that the player has activated this trigger this frame
    self->aimDebounceTime =level.time;
    }
    */
}

/**
```
=================
AimAtTarget

Calculate origin2 so the target apogee will be hit
=================
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1039
func AimAtTarget(_ `self`: Entity) {
    var ent: Entity?
    var origin = vec3_t()
    let height: Float
    let gravity: Float
    let time: Float
    let forward: Float
    let dist: Float

    origin = `self`.r.absmin + `self`.r.absmax
    origin = origin * 0.5

    ent = G_PickTarget(`self`.target!)
    if ent == nil {
        G_FreeEntity(`self`)
        return
    }

    if `self`.classname != nil && Q_stricmp("trigger_push", `self`.classname!) == 0 {
        if (`self`.spawnflags & PUSH_RELATIVE) != 0 {
            //relative, not an arc or linear
            `self`.s.origin2 = ent!.r.currentOrigin
            return
        } else if (`self`.spawnflags & PUSH_LINEAR) != 0 {
            //linear, not an arc
            `self`.s.origin2 = ent!.r.currentOrigin - origin
            VectorNormalize(&`self`.s.origin2)
            return
        }
    }

    if `self`.classname != nil && Q_stricmp("target_push", `self`.classname!) == 0 {
        if (`self`.spawnflags & PUSH_CONSTANT) != 0 {
            `self`.s.origin2 = ent!.s.origin - `self`.s.origin
            VectorNormalize(&`self`.s.origin2)
            `self`.s.origin2 = `self`.s.origin2 * `self`.speed
            return
        }
    }

    height = ent!.s.origin[2] - origin[2]
    gravity = g_gravity.value
    time = Float(sqrt(Double(height) / (0.5 * Double(gravity))))
    if time == 0 {
        G_FreeEntity(`self`)
        return
    }

    // set s.origin2 to the push velocity
    `self`.s.origin2 = ent!.s.origin - origin
    `self`.s.origin2[2] = 0
    dist = VectorNormalize(&`self`.s.origin2)

    forward = dist / time
    `self`.s.origin2 = `self`.s.origin2 * forward

    `self`.s.origin2[2] = time * gravity
}

/**
```
QUAKED trigger_push (.5 .5 .5) ? x x LINEAR x RELATIVE x x INACTIVE MULTIPLE
Must point at a target_position, which will be the apex of the leap.
This will be client side predicted, unlike target_push

LINEAR - Instead of tossing the client at the target_position, it will push them towards it.  Must set a "speed" (see below)
RELATIVE - instead of pushing you in a direction that is always from the center of the trigger to the target_position, it pushes *you* toward the target position, relative to your current location (can use with "speed"... if don't set a speed, it will use the distance from you to the target_position)
INACTIVE - not active until targeted by a target_activate
MULTIPLE - multiple entities can touch this trigger in a single frame *and* if needed, the trigger can have a wait of > 0

wait - how long to wait between pushes: -1 = push only once
speed - when used with the LINEAR spawnflag, pushes the client toward the position at a constant speed (default is 1000)
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1112
func SP_trigger_push(_ `self`: Entity) {
    InitTrigger(`self`)

    // unlike other triggers, we need to send this one to the client
    `self`.r.svFlags &= ~SVF_NOCLIENT

    // make sure the client precaches this sound
    G_SoundIndex("sound/weapons/force/jump.wav")

    `self`.s.eType = ET_PUSH_TRIGGER

    if !((`self`.spawnflags & 2) != 0) {
        //start on
        `self`.touch = Touch.trigger_push_touch
    }

    if (`self`.spawnflags & 4) != 0 {
        //linear
        `self`.speed = 1000
    }

    `self`.think = Think.AimAtTarget
    `self`.nextthink = level.time + FRAMETIME
    trap_LinkEntity(`self`)
}

/// Source: oracle/codemp/game/g_trigger.c:1138
func Use_target_push(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if activator.client == nil {
        return
    }

    if activator.client!.ps.pm_type != PM_NORMAL && activator.client!.ps.pm_type != PM_FLOAT {
        return
    }

    G_ActivateBehavior(`self`, BSET_USE)

    activator.client!.ps.velocity = `self`.s.origin2

    // play fly sound every 1.5 seconds
    if activator.fly_sound_debounce_time < level.time {
        activator.fly_sound_debounce_time = level.time + 1500
        if `self`.noise_index != 0 {
            G_Sound(activator, CHAN_AUTO, `self`.noise_index)
        }
    }
}

/**
```
QUAKED target_push (.5 .5 .5) (-8 -8 -8) (8 8 8) bouncepad CONSTANT
CONSTANT will push activator in direction of 'target' at constant 'speed'

Pushes the activator in the direction.of angle, or towards a target apex.
"speed"		defaults to 1000
if "bouncepad", play bounce noise instead of none
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1168
func SP_target_push(_ `self`: Entity) {
    if `self`.speed == 0 {
        `self`.speed = 1000
    }
    G_SetMovedir(&`self`.s.angles, &`self`.s.origin2)
    `self`.s.origin2 = `self`.s.origin2 * `self`.speed

    if (`self`.spawnflags & 1) != 0 {
        `self`.noise_index = G_SoundIndex("sound/weapons/force/jump.wav")
    } else {
        `self`.noise_index = 0 //G_SoundIndex("sound/misc/windfly.wav");
    }
    if `self`.target != nil {
        `self`.r.absmin = `self`.s.origin
        `self`.r.absmax = `self`.s.origin
        `self`.think = Think.AimAtTarget
        `self`.nextthink = level.time + FRAMETIME
    }
    `self`.use = Use.Use_target_push
}

/// Source: oracle/codemp/game/g_trigger.c:1197
func trigger_teleporter_touch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    var dest: Entity?

    if (`self`.flags & FL_INACTIVE) != 0 {
        //set by target_deactivate
        return
    }

    if other.client == nil {
        return
    }
    if other.client!.ps.pm_type == PM_DEAD {
        return
    }
    // Spectators only?
    if (`self`.spawnflags & 1) != 0 && other.client!.sess.sessionTeam != TEAM_SPECTATOR {
        return
    }


    dest = G_PickTarget(`self`.target!)
    if dest == nil {
        G_Printf("Couldn't find teleporter destination\n")
        return
    }

    TeleportPlayer(other, dest!.s.origin, dest!.s.angles)
}

/**
```
QUAKED trigger_teleport (.5 .5 .5) ? SPECTATOR
Allows client side prediction of teleportation events.
Must point at a target_position, which will be the teleport destination.

If spectator is set, only spectators can use this teleport
Spectator teleporters are not normally placed in the editor, but are created
automatically near doors to allow spectators to move through them
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1236
func SP_trigger_teleport(_ `self`: Entity) {
    InitTrigger(`self`)

    // unlike other triggers, we need to send this one to the client
    // unless is a spectator trigger
    if (`self`.spawnflags & 1) != 0 {
        `self`.r.svFlags |= SVF_NOCLIENT
    } else {
        `self`.r.svFlags &= ~SVF_NOCLIENT
    }

    // make sure the client precaches this sound
    G_SoundIndex("sound/weapons/force/speed.wav")

    `self`.s.eType = ET_TELEPORT_TRIGGER
    `self`.touch = Touch.trigger_teleporter_touch

    trap_LinkEntity(`self`)
}

/**
```
QUAKED trigger_hurt (.5 .5 .5) ? START_OFF CAN_TARGET SILENT NO_PROTECTION SLOW
Any entity that touches this will be hurt.
It does dmg points of damage each server frame
Targeting the trigger will toggle its on / off state.

CAN_TARGET		if you target it, it will toggle on and off
SILENT			supresses playing the sound
SLOW			changes the damage rate to once per second
NO_PROTECTION	*nothing* stops the damage

"team"			team (1 or 2) to allow hurting (if none then hurt anyone) only applicable for siege
"dmg"			default 5 (whole numbers only)
If dmg is set to -1 this brush will use the fade-kill method
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1280
func hurt_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if activator.inuse && activator.client != nil {
        `self`.activator = activator
    } else {
        `self`.activator = nil
    }

    G_ActivateBehavior(`self`, BSET_USE)

    if `self`.r.linked {
        trap_UnlinkEntity(`self`)
    } else {
        trap_LinkEntity(`self`)
    }
}

/// Source: oracle/codemp/game/g_trigger.c:1299
func hurt_touch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    let dflags: Int32

    if g_gametype.integer == GT_SIEGE && `self`.team != nil && !`self`.team!.isEmpty {
        let team: Int32 = atoi(`self`.team!)

        if other.inuse && other.s.number < MAX_CLIENTS && other.client != nil && other.client!.sess.sessionTeam != team {
            //real client don't hurt
            return
        } else if other.inuse && other.client != nil && other.s.eType == ET_NPC && other.s.NPC_class == CLASS_VEHICLE && other.s.teamowner != team {
            //vehicle owned by team don't hurt
            return
        }
    }

    if (`self`.flags & FL_INACTIVE) != 0 {
        //set by target_deactivate
        return
    }

    if !other.takedamage {
        return
    }

    if `self`.timestamp > level.time {
        return
    }

    if `self`.damage == -1 && other.client != nil && other.health < 1 {
        other.client!.ps.fallingToDeath = 0
        respawn(other)
        return
    }

    if `self`.damage == -1 && other.client != nil && other.client!.ps.fallingToDeath != 0 {
        return
    }

    if (`self`.spawnflags & 16) != 0 {
        `self`.timestamp = level.time + 1000
    } else {
        `self`.timestamp = level.time + FRAMETIME
    }

    // play sound
    /*
    if ( !(self->spawnflags & 4) && self->damage != -1 ) {
    G_Sound( other, CHAN_AUTO, self->noise_index );
    }
    */

    if (`self`.spawnflags & 8) != 0 {
        dflags = DAMAGE_NO_PROTECTION
    } else {
        dflags = 0
    }

    if `self`.damage == -1 && other.client != nil {
        if other.client!.ps.otherKillerTime > level.time {
            //we're as good as dead, so if someone pushed us into this then remember them
            other.client!.ps.otherKillerTime = level.time + 20000
            other.client!.ps.otherKillerDebounceTime = level.time + 10000
            other.client!.otherKillerMOD = MOD_FALLING
            other.client!.otherKillerVehWeapon = 0
            other.client!.otherKillerWeaponType = WP_NONE
        }
        other.client!.ps.fallingToDeath = level.time

        //rag on the way down, this flag will automatically be cleared for us on respawn
        other.client!.ps.eFlags |= EF_RAG

        //make sure his jetpack is off
        Jetpack_Off(other)

        if other.NPC != nil {
            //kill it now
            var vDir = vec3_t()

            vDir = vec3_t(0, 1, 0)
            G_Damage(other, other, other, &vDir, other.client!.ps.origin, Q3_INFINITE, 0, MOD_FALLING)
        } else {
            G_EntitySound(other, CHAN_VOICE, G_SoundIndex("*falling1.wav"))
        }

        `self`.timestamp = 0 //do not ignore others
    } else {
        var dmg: Int32 = `self`.damage

        if dmg == -1 {
            //so fall-to-blackness triggers destroy evertyhing
            dmg = 99999
            `self`.timestamp = 0
        }
        if `self`.activator != nil && `self`.activator!.inuse && `self`.activator!.client != nil {
            var dir: vec3_t? = nil
            G_Damage(other, `self`.activator, `self`.activator, &dir, nil, dmg, dflags | DAMAGE_NO_PROTECTION, MOD_TRIGGER_HURT)
        } else {
            var dir: vec3_t? = nil
            G_Damage(other, `self`, `self`, &dir, nil, dmg, dflags | DAMAGE_NO_PROTECTION, MOD_TRIGGER_HURT)
        }
    }
}

/// Source: oracle/codemp/game/g_trigger.c:1413
func SP_trigger_hurt(_ `self`: Entity) {
    InitTrigger(`self`)

    gTrigFallSound = G_SoundIndex("*falling1.wav")

    `self`.noise_index = G_SoundIndex("sound/weapons/force/speed.wav")
    `self`.touch = Touch.hurt_touch

    if `self`.damage == 0 {
        `self`.damage = 5
    }

    `self`.r.contents = CONTENTS_TRIGGER

    if (`self`.spawnflags & 2) != 0 {
        `self`.use = Use.hurt_use
    }

    // link in to the world if starting active
    if !((`self`.spawnflags & 1) != 0) {
        trap_LinkEntity(`self`)
    } else if `self`.r.linked {
        trap_UnlinkEntity(`self`)
    }
}

/// Source: oracle/codemp/game/g_trigger.c:1442
func space_touch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if !other.inuse || other.client == nil {
        return
    }

    if other.s.number < MAX_CLIENTS && other.client!.ps.m_iVehicleNum != 0 && other.client!.ps.m_iVehicleNum >= MAX_CLIENTS {
        //a player client inside a vehicle
        let veh: Entity? = g_entities[other.client!.ps.m_iVehicleNum]

        if veh!.inuse && veh!.client != nil && veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo!.hideRider {
            //if they are "inside" a vehicle, then let that protect them from THE HORRORS OF SPACE.
            other.client!.inSpaceSuffocation = 0
            other.client!.inSpaceIndex = ENTITYNUM_NONE
            return
        }
    }

    if !G_PointInBounds(other.client!.ps.origin, `self`.r.absmin, `self`.r.absmax) {
        //his origin must be inside the trigger
        return
    }

    if other.client!.inSpaceIndex == 0 || other.client!.inSpaceIndex == ENTITYNUM_NONE {
        //freshly entering space
        other.client!.inSpaceSuffocation = level.time + INITIAL_SUFFOCATION_DELAY
    }

    other.client!.inSpaceIndex = `self`.s.number
}

/**
```
QUAKED trigger_space (.5 .5 .5) ?
causes human clients to suffocate and have no gravity.
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1484
func SP_trigger_space(_ `self`: Entity) {
    InitTrigger(`self`)
    `self`.r.contents = CONTENTS_TRIGGER

    `self`.touch = Touch.space_touch

    trap_LinkEntity(`self`)
}

/// Source: oracle/codemp/game/g_trigger.c:1494
func shipboundary_touch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace?) {
    var ent: Entity?

    if !other.inuse || other.client == nil || other.s.number < MAX_CLIENTS || other.m_pVehicle == nil {
        //only let vehicles touch
        return
    }

    if other.client!.ps.hyperSpaceTime != 0 && level.time - other.client!.ps.hyperSpaceTime < HYPERSPACE_TIME {
        //don't interfere with hyperspacing ships
        return
    }

    ent = G_Find(nil, \.targetname, `self`.target)
    if ent == nil || !ent!.inuse {
        //this is bad
        G_Error("trigger_shipboundary has invalid target '%s'\n", `self`.target!)
        return
    }

    if other.client!.ps.m_iVehicleNum == 0 || other.m_pVehicle!.m_iRemovedSurfaces != 0 {
        //if a vehicle touches a boundary without a pilot in it or with parts missing, just blow the thing up
        var dir: vec3_t? = nil
        G_Damage(other, other, other, &dir, other.client!.ps.origin, 99999, DAMAGE_NO_PROTECTION, MOD_SUICIDE)
        return
    }

    //make sure this sucker is linked so the prediction knows where to go
    trap_LinkEntity(ent!)

    other.client!.ps.vehTurnaroundIndex = ent!.s.number
    other.client!.ps.vehTurnaroundTime = level.time + (`self`.genericValue1 * 2)

    //keep up the detailed checks for another 2 seconds
    `self`.genericValue7 = level.time + 2000
}

/// Source: oracle/codemp/game/g_trigger.c:1533
func shipboundary_think(_ ent: Entity) {
    var iEntityList: [Int32] = [Int32](repeating: 0, count: 1024)
    let numListedEntities: Int32
    var i: Int32 = 0
    var listedEnt: Entity?

    ent.nextthink = level.time + 100

    if ent.genericValue7 < level.time {
        //don't need to be doing this check, no one has touched recently
        return
    }

    numListedEntities = trap_EntitiesInBox(ent.r.absmin, ent.r.absmax, &iEntityList, MAX_GENTITIES)
    while i < numListedEntities {
        listedEnt = g_entities[iEntityList[i]]
        if listedEnt!.inuse && listedEnt!.client != nil && listedEnt!.client!.ps.m_iVehicleNum != 0 {
            if listedEnt!.s.eType == ET_NPC && listedEnt!.s.NPC_class == CLASS_VEHICLE {
                let pVeh: Vehicle? = listedEnt!.m_pVehicle
                if pVeh != nil && pVeh!.m_pVehicleInfo!.type == VH_FIGHTER {
                    shipboundary_touch(ent, listedEnt!, nil)
                }
            }
        }
        i += 1
    }
}

/**
```
QUAKED trigger_shipboundary (.5 .5 .5) ?
causes vehicle to turn toward target and travel in that direction for a set time when hit.

"target"		name of entity to turn toward (can be info_notnull, or whatever).
"traveltime"	time to travel in this direction
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1574
func SP_trigger_shipboundary(_ `self`: Entity) {
    InitTrigger(`self`)
    `self`.r.contents = CONTENTS_TRIGGER

    if `self`.target == nil || `self`.target!.isEmpty {
        G_Error("trigger_shipboundary without a target.")
    }
    G_SpawnInt("traveltime", "0", &`self`.genericValue1)

    if `self`.genericValue1 == 0 {
        G_Error("trigger_shipboundary without traveltime.")
    }

    `self`.think = Think.shipboundary_think
    `self`.nextthink = level.time + 500
    `self`.touch = Touch.shipboundary_touch

    trap_LinkEntity(`self`)
}

/// Source: oracle/codemp/game/g_trigger.c:1597
func hyperspace_touch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    var ent: Entity?

    if !other.inuse || other.client == nil || other.s.number < MAX_CLIENTS || other.m_pVehicle == nil {
        //only let vehicles touch
        return
    }

    if other.client!.ps.hyperSpaceTime != 0 && level.time - other.client!.ps.hyperSpaceTime < HYPERSPACE_TIME {
        //already hyperspacing, just keep us moving
        if (other.client!.ps.eFlags2 & EF2_HYPERSPACE) != 0 {
            //they've started the hyperspace but haven't been teleported yet
            let timeFrac: Float = (Float((level.time - other.client!.ps.hyperSpaceTime))) / HYPERSPACE_TIME
            if timeFrac >= HYPERSPACE_TELEPORT_FRAC {
                //half-way, now teleport them!
                var diff = vec3_t()
                var fwd = vec3_t()
                var right = vec3_t()
                var up = vec3_t()
                var newOrg = vec3_t()
                let fDiff: Float
                let rDiff: Float
                let uDiff: Float
                //take off the flag so we only do this once
                other.client!.ps.eFlags2 &= ~EF2_HYPERSPACE
                //Get the offset from the local position
                ent = G_Find(nil, \.targetname, `self`.target)
                if ent == nil || !ent!.inuse {
                    //this is bad
                    G_Error("trigger_hyperspace has invalid target '%s'\n", `self`.target!)
                    return
                }
                diff = other.client!.ps.origin - ent!.s.origin
                AngleVectors(ent!.s.angles, &fwd, &right, &up)
                fDiff = _DotProduct(fwd, diff)
                rDiff = _DotProduct(right, diff)
                uDiff = _DotProduct(up, diff)

                //Now get the base position of the destination
                ent = G_Find(nil, \.targetname, `self`.target2)
                if ent == nil || !ent!.inuse {
                    //this is bad
                    G_Error("trigger_hyperspace has invalid target2 '%s'\n", `self`.target2!)
                    return
                }
                newOrg = ent!.s.origin
                //finally, add the offset into the new origin
                AngleVectors(ent!.s.angles, &fwd, &right, &up)
                _VectorMA(newOrg, fDiff * `self`.radius, fwd, &newOrg)
                _VectorMA(newOrg, rDiff * `self`.radius, right, &newOrg)
                _VectorMA(newOrg, uDiff * `self`.radius, up, &newOrg)
                //G_Printf("hyperspace from %s to %s\n", vtos(other->client->ps.origin), vtos(newOrg) );
                //now put them in the offset position, facing the angles that position wants them to be facing
                TeleportPlayer(other, newOrg, ent!.s.angles)
                if other.m_pVehicle != nil && other.m_pVehicle!.m_pPilot != nil {
                    //teleport the pilot, too
                    TeleportPlayer(other.m_pVehicle!.m_pPilot.map { Entity($0) }!, newOrg, ent!.s.angles)
                    //FIXME: and the passengers?
                }
                //make them face the new angle
                //other->client->ps.hyperSpaceIndex = ent->s.number;
                other.client!.ps.hyperSpaceAngles = ent!.s.angles
                //sound
                G_Sound(other, CHAN_LOCAL, G_SoundIndex("sound/vehicles/common/hyperend.wav"))
            }
        }
        return
    } else {
        ent = G_Find(nil, \.targetname, `self`.target)
        if ent == nil || !ent!.inuse {
            //this is bad
            G_Error("trigger_hyperspace has invalid target '%s'\n", `self`.target!)
            return
        }

        if other.client!.ps.m_iVehicleNum == 0 || other.m_pVehicle!.m_iRemovedSurfaces != 0 {
            //if a vehicle touches a boundary without a pilot in it or with parts missing, just blow the thing up
            var dir: vec3_t? = nil
            G_Damage(other, other, other, &dir, other.client!.ps.origin, 99999, DAMAGE_NO_PROTECTION, MOD_SUICIDE)
            return
        }
        //other->client->ps.hyperSpaceIndex = ent->s.number;
        other.client!.ps.hyperSpaceAngles = ent!.s.angles
        other.client!.ps.hyperSpaceTime = level.time
    }
}

/**
```
void trigger_hyperspace_find_targets( gentity_t *self )
{
	gentity_t *targEnt = NULL;
	targEnt = G_Find (NULL, FOFS(targetname), self->target);
	if (!targEnt || !targEnt->inuse)
	{ //this is bad
		G_Error("trigger_hyperspace has invalid target '%s'\n", self->target);
		return;
	}
	targEnt->r.svFlags |= SVF_BROADCAST;//crap, need to tell the cgame about the target_position
	targEnt = G_Find (NULL, FOFS(targetname), self->target2);
	if (!targEnt || !targEnt->inuse)
	{ //this is bad
		G_Error("trigger_hyperspace has invalid target2 '%s'\n", self->target2);
		return;
	}
	targEnt->r.svFlags |= SVF_BROADCAST;//crap, need to tell the cgame about the target_position
}
```
*/
/**
```
QUAKED trigger_hyperspace (.5 .5 .5) ?
Ship will turn to face the angles of the first target_position then fly forward, playing the hyperspace effect, then pop out at a relative point around the target

"target"		whatever position the ship teleports from in relation to the target_position specified here, that's the relative position the ship will spawn at around the target2 target_position
"target2"		name of target_position to teleport the ship to (will be relative to it's origin)
"exitscale"		Can use this to make the vehicle appear farther from the exit position than they were from the entry position at the time of teleporting (scales the relative position - default is "1" - normal, no scale)
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1709
func SP_trigger_hyperspace(_ `self`: Entity) {
    G_SpawnFloat("exitscale", "1", &`self`.radius)

    //register the hyperspace end sound (start sounds are customized)
    G_SoundIndex("sound/vehicles/common/hyperend.wav")

    InitTrigger(`self`)
    `self`.r.contents = CONTENTS_TRIGGER

    if `self`.target == nil || `self`.target!.isEmpty {
        G_Error("trigger_hyperspace without a target.")
    }
    if `self`.target2 == nil || `self`.target2!.isEmpty {
        G_Error("trigger_hyperspace without a target2.")
    }

    `self`.delay = Int32(Distance(`self`.r.absmax, `self`.r.absmin)) //my size

    `self`.touch = Touch.hyperspace_touch

    trap_LinkEntity(`self`)

    //self->think = trigger_hyperspace_find_targets;
    //self->nextthink = level.time + FRAMETIME;
}

/**
```
QUAKED func_timer (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) START_ON
This should be renamed trigger_timer...
Repeatedly fires its targets.
Can be turned on or off by using.

"wait"			base time between triggering all targets, default is 1
"random"		wait variance, default is 0
so, the basic time between firing is a random time between
(wait - random) and (wait + random)
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1757
func func_timer_think(_ `self`: Entity) {
    G_UseTargets(`self`, `self`.activator)
    // set time before next firing
    `self`.nextthink = Int32(level.time + 1000 * (`self`.wait + crandom() * `self`.random))
}

/// Source: oracle/codemp/game/g_trigger.c:1763
func func_timer_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    `self`.activator = activator

    G_ActivateBehavior(`self`, BSET_USE)

    // if on, turn it off
    if `self`.nextthink != 0 {
        `self`.nextthink = 0
        return
    }

    // turn it on
    func_timer_think(`self`)
}

/// Source: oracle/codemp/game/g_trigger.c:1778
func SP_func_timer(_ `self`: Entity) {
    G_SpawnFloat("random", "1", &`self`.random)
    G_SpawnFloat("wait", "1", &`self`.wait)

    `self`.use = Use.func_timer_use
    `self`.think = Think.func_timer_think

    if `self`.random >= `self`.wait {
        `self`.random = `self`.wait - 1 //NOTE: was - FRAMETIME, but FRAMETIME is in msec (100) and these numbers are in *seconds*!
        G_Printf("func_timer at %s has random >= wait\n", vtos(`self`.s.origin))
    }

    if (`self`.spawnflags & 1) != 0 {
        `self`.nextthink = level.time + FRAMETIME
        `self`.activator = `self`
    }

    `self`.r.svFlags = SVF_NOCLIENT
}

/// Source: oracle/codemp/game/g_trigger.c:1798
func asteroid_pick_random_asteroid(_ `self`: Entity) -> Entity? {
    var t_count: Int32 = 0
    let pick: Int32
    var t: Entity? = nil

    while let next = G_Find(t, \.targetname, `self`.target) {
        t = next
        if t!.s.number != `self`.s.number {
            t_count += 1
        }
    }
    t = nil

    if t_count == 0 {
        return nil
    }

    if t_count == 1 {
        return (G_Find(nil, \.targetname, `self`.target))
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

        if t_count == pick {
            return t
        }
    }
    return nil
}

/// Source: oracle/codemp/game/g_trigger.c:1843
func asteroid_count_num_asteroids(_ `self`: Entity) -> Int32 {
    var i: Int32
    var count: Int32 = 0

    i = MAX_CLIENTS
    while i < ENTITYNUM_WORLD {
        if !g_entities[i].inuse {
            i += 1
            continue
        }
        if g_entities[i].r.ownerNum == `self`.s.number {
            count += 1
        }
        i += 1
    }
    return count
}

/// Source: oracle/codemp/game/g_trigger.c:1864
func asteroid_move_to_start2(_ `self`: Entity, _ ownerTrigger: Entity) {
    //move asteroid to a new start position
    //move it
    var startSpot = vec3_t()
    var endSpot = vec3_t()
    var startAngles = vec3_t()
    let dist: Float
    let speed: Float = flrand(`self`.speed * 0.25, `self`.speed * 2.0)
    let capAxis: Int32
    var axis: Int32
    var time: Int32 = 0

    capAxis = Q_irand(0, 2)
    axis = 0
    while axis < 3 {
        if axis == capAxis {
            if Q_irand(0, 1) != 0 {
                startSpot[axis] = ownerTrigger.r.mins[axis]
                endSpot[axis] = ownerTrigger.r.maxs[axis]
            } else {
                startSpot[axis] = ownerTrigger.r.maxs[axis]
                endSpot[axis] = ownerTrigger.r.mins[axis]
            }
        } else {
            startSpot[axis] = ownerTrigger.r.mins[axis] + (flrand(0, 1.0) * (ownerTrigger.r.maxs[axis] - ownerTrigger.r.mins[axis]))
            endSpot[axis] = ownerTrigger.r.mins[axis] + (flrand(0, 1.0) * (ownerTrigger.r.maxs[axis] - ownerTrigger.r.mins[axis]))
        }
        axis += 1
    }
    //FIXME: maybe trace from start to end to make sure nothing is in the way?  How big of a trace?

    G_SetOrigin(`self`, &startSpot)
    dist = Distance(endSpot, startSpot)
    time = Int32(ceil(dist / speed) * 1000)
    Q3_Lerp2Origin(-1, `self`.s.number, endSpot, Float(time))

    //spin it
    startAngles[0] = flrand(-360, 360)
    startAngles[1] = flrand(-360, 360)
    startAngles[2] = flrand(-360, 360)
    G_SetAngles(`self`, startAngles)
    `self`.s.apos.trDelta[0] = flrand(-100, 100)
    `self`.s.apos.trDelta[1] = flrand(-100, 100)
    `self`.s.apos.trDelta[2] = flrand(-100, 100)
    `self`.s.apos.trTime = level.time
    `self`.s.apos.trType = TR_LINEAR
    //move itownerTrigger back to a new start when done
    `self`.think = Think.asteroid_move_to_start
    `self`.nextthink = level.time + time
}

/// Source: oracle/codemp/game/g_trigger.c:1922
func asteroid_move_to_start(_ `self`: Entity) {
    //move asteroid to a new start position
    asteroid_move_to_start2(`self`, g_entities[`self`.r.ownerNum])
}

/// Source: oracle/codemp/game/g_trigger.c:1927
func asteroid_field_think(_ `self`: Entity) {
    let numAsteroids: Int32 = asteroid_count_num_asteroids(`self`)

    `self`.nextthink = level.time + 500

    if numAsteroids < `self`.count {
        //need to spawn a new asteroid
        let newAsteroid: Entity? = G_Spawn()
        if newAsteroid != nil {
            let copyAsteroid: Entity? = asteroid_pick_random_asteroid(`self`)
            if copyAsteroid != nil {
                newAsteroid!.model = copyAsteroid!.model
                newAsteroid!.model2 = copyAsteroid!.model2
                newAsteroid!.health = copyAsteroid!.health
                newAsteroid!.spawnflags = copyAsteroid!.spawnflags
                newAsteroid!.mass = copyAsteroid!.mass
                newAsteroid!.damage = copyAsteroid!.damage
                newAsteroid!.speed = copyAsteroid!.speed

                G_SetOrigin(newAsteroid!, &copyAsteroid!.s.origin)
                G_SetAngles(newAsteroid!, copyAsteroid!.s.angles)
                newAsteroid!.classname = "func_rotating"

                SP_func_rotating(newAsteroid!)

                newAsteroid!.genericValue15 = copyAsteroid!.genericValue15
                newAsteroid!.s.iModelScale = copyAsteroid!.s.iModelScale
                newAsteroid!.maxHealth = newAsteroid!.health
                G_ScaleNetHealth(newAsteroid!)
                newAsteroid!.radius = copyAsteroid!.radius
                newAsteroid!.material = copyAsteroid!.material
                //CacheChunkEffects( self->material );

                //keep track of it
                newAsteroid!.r.ownerNum = `self`.s.number

                //position it
                asteroid_move_to_start2(newAsteroid!, `self`)

                //think again sooner if need even more
                if numAsteroids + 1 < `self`.count {
                    //still need at least one more
                    //spawn it in 100ms
                    `self`.nextthink = level.time + 100
                }
            }
        }
    }
}

/**
```
QUAKED trigger_asteroid_field (.5 .5 .5) ?
speed - how fast, on average, the asteroid moves
count - how many asteroids, max, to have at one time
target - target this at func_rotating asteroids
```
*/
/// Source: oracle/codemp/game/g_trigger.c:1986
func SP_trigger_asteroid_field(_ `self`: Entity) {
    trap_SetBrushModel(`self`, `self`.model!)
    //	self->r.contents = CONTENTS_TRIGGER;		// replaces the -1 from trap_SetBrushModel
    `self`.r.contents = 0
    `self`.r.svFlags = SVF_NOCLIENT

    if `self`.count == 0 {
        `self`.health = 20
    }

    if `self`.speed == 0 {
        `self`.speed = 10000
    }

    `self`.think = Think.asteroid_field_think
    `self`.nextthink = level.time + 100

    trap_LinkEntity(`self`)
}
