import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC.c:34
var NPC: Entity? {
    get { world.variables.NPC }
    set { world.variables.NPC = newValue }
}

/// Source: oracle/codemp/game/NPC.c:35
var NPCInfo: GNPC? {
    get { world.variables.NPCInfo }
    set { world.variables.NPCInfo = newValue }
}

/// Source: oracle/codemp/game/NPC.c:36
var client: Client? {
    get { world.variables.client }
    set { world.variables.client = newValue }
}

/// Source: oracle/codemp/game/NPC.c:37
var ucmd: JKAMP.Usercmd { world.storage.ucmd }

/// Source: oracle/codemp/game/NPC.c:38
var enemyVisibility: visibility_t {
    get { world.variables.enemyVisibility }
    set { world.variables.enemyVisibility = newValue }
}

/// Source: oracle/codemp/game/NPC.c:112
let REMOVE_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC.c:113
let REMOVE_DISTANCE_SQR = (REMOVE_DISTANCE * REMOVE_DISTANCE)

/// Source: oracle/codemp/game/NPC.c:625
var _saved_NPC: Entity? {
    get { world.variables._saved_NPC }
    set { world.variables._saved_NPC = newValue }
}

/// Source: oracle/codemp/game/NPC.c:626
var _saved_NPCInfo: GNPC? {
    get { world.variables._saved_NPCInfo }
    set { world.variables._saved_NPCInfo = newValue }
}

/// Source: oracle/codemp/game/NPC.c:627
var _saved_client: Client? {
    get { world.variables._saved_client }
    set { world.variables._saved_client = newValue }
}

/// Source: oracle/codemp/game/NPC.c:628
var _saved_ucmd: JKAMP.Usercmd { world.storage._saved_ucmd }

/// Source: oracle/codemp/game/NPC.c:656
/// Raven's data table, a hand property of `GameWorld`.
var NPCDEBUG_RED: JKAShared.vec3_t {
    get { world.NPCDEBUG_RED }
    set { world.NPCDEBUG_RED = newValue }
}

/// Source: oracle/codemp/game/NPC.c:657
// Raven wrote: vec3_t NPCDEBUG_GREEN = {0.0, 1.0, 0.0}
let NPCDEBUG_GREEN: JKAShared.vec3_t = { () -> JKAShared.vec3_t in portMissing("NPCDEBUG_GREEN", source: "oracle/codemp/game/NPC.c:657") }()

/// Source: oracle/codemp/game/NPC.c:658
/// Raven's data table, a hand property of `GameWorld`.
var NPCDEBUG_BLUE: JKAShared.vec3_t {
    get { world.NPCDEBUG_BLUE }
    set { world.NPCDEBUG_BLUE = newValue }
}

/// Source: oracle/codemp/game/NPC.c:659
// Raven wrote: vec3_t NPCDEBUG_LIGHT_BLUE = {0.3f, 0.7f, 1.0}
let NPCDEBUG_LIGHT_BLUE: JKAShared.vec3_t = { () -> JKAShared.vec3_t in portMissing("NPCDEBUG_LIGHT_BLUE", source: "oracle/codemp/game/NPC.c:659") }()

/// Source: oracle/codemp/game/NPC.c:46
func CorpsePhysics(_ `self`: Entity) {
    // run the bot through the server like it was a real client
    ucmd.clear()
    ClientThink(`self`.s.number, ucmd)
    //VectorCopy( self->s.origin, self->s.origin2 );
    //rww - don't get why this is happening.

    if `self`.client!.NPC_class == CLASS_GALAKMECH {
        GM_Dying(`self`)
    }
    //FIXME: match my pitch and roll for the slope of my groundPlane
    if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE && !((`self`.s.eFlags & EF_DISINTEGRATION) != 0) {
        //on the ground
        //FIXME: check 4 corners
        pitch_roll_for_slope(`self`, nil)
    }

    if eventClearTime == level.time + ALERT_CLEAR_TIME {
        //events were just cleared out so add me again
        if !((`self`.client!.ps.eFlags & EF_NODRAW) != 0) {
            AddSightEvent(`self`.enemy!, `self`.r.currentOrigin, 384, AEL_DISCOVERED, 0.0)
        }
    }

    if level.time - `self`.s.time > 3000 {
        //been dead for 3 seconds
        if g_dismember.integer < 11381138 && g_saberRealisticCombat.integer == 0 {
            //can't be dismembered once dead
            if `self`.client!.NPC_class != CLASS_PROTOCOL {
                //	self->client->dismembered = qtrue;
            }
        }
    }

    //if ( level.time - self->s.time > 500 )
    if `self`.client!.respawnTime < (level.time + 500) {
        //don't turn "nonsolid" until about 1 second after actual death

        if (`self`.client!.ps.eFlags & EF_DISINTEGRATION) != 0 {
            `self`.r.contents = 0
        } else if (`self`.client!.NPC_class != CLASS_MARK1) && (`self`.client!.NPC_class != CLASS_INTERROGATOR) {
            `self`.r.contents = CONTENTS_CORPSE
            //self->r.maxs[2] = -8;
        }

        if `self`.message != nil {
            `self`.r.contents |= CONTENTS_TRIGGER
        }
    }
}

/// Source: oracle/codemp/game/NPC.c:115
func NPC_RemoveBody(_ `self`: Entity) {
    CorpsePhysics(`self`)

    `self`.nextthink = level.time + FRAMETIME

    if `self`.NPC!.nextBStateThink <= level.time {
        trap_ICARUS_MaintainTaskManager(`self`.s.number)
    }
    `self`.NPC!.nextBStateThink = level.time + FRAMETIME

    if `self`.message != nil {
        //I still have a key
        return
    }

    // I don't consider this a hack, it's creative coding . . .
    // I agree, very creative... need something like this for ATST and GALAKMECH too!
    if `self`.client!.NPC_class == CLASS_MARK1 {
        Mark1_dying(`self`)
    }

    // Since these blow up, remove the bounding box.
    if `self`.client!.NPC_class == CLASS_REMOTE || `self`.client!.NPC_class == CLASS_SENTRY || `self`.client!.NPC_class == CLASS_PROBE || `self`.client!.NPC_class == CLASS_INTERROGATOR || `self`.client!.NPC_class == CLASS_PROBE || `self`.client!.NPC_class == CLASS_MARK2 {
        //if ( !self->taskManager || !self->taskManager->IsRunning() )
        if !trap_ICARUS_IsRunning(`self`.s.number) {
            if `self`.activator == nil || `self`.activator!.client == nil || !((`self`.activator!.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0) {
                //not being held by a Rancor
                G_FreeEntity(`self`)
            }
        }
        return
    }

    //FIXME: don't ever inflate back up?
    `self`.r.maxs[2] = `self`.client!.renderInfo.eyePoint[2] - `self`.r.currentOrigin[2] + 4
    if `self`.r.maxs[2] < -8 {
        `self`.r.maxs[2] = -8
    }

    if `self`.client!.NPC_class == CLASS_GALAKMECH {
        //never disappears
        return
    }
    if `self`.NPC != nil && `self`.NPC!.timeOfDeath <= level.time {
        `self`.NPC!.timeOfDeath = level.time + 1000
        // Only do all of this nonsense for Scav boys ( and girls )
        ///	if ( self->client->playerTeam == NPCTEAM_SCAVENGERS || self->client->playerTeam == NPCTEAM_KLINGON
        //		|| self->client->playerTeam == NPCTEAM_HIROGEN || self->client->playerTeam == NPCTEAM_MALON )
        // should I check NPC_class here instead of TEAM ? - dmv
        if `self`.client!.playerTeam == NPCTEAM_ENEMY || `self`.client!.NPC_class == CLASS_PROTOCOL {
            `self`.nextthink = level.time + FRAMETIME // try back in a second

            /*
            if ( DistanceSquared( g_entities[0].r.currentOrigin, self->r.currentOrigin ) <= REMOVE_DISTANCE_SQR )
            {
            return;
            }

            if ( (InFOV( self, &g_entities[0], 110, 90 )) ) // generous FOV check
            {
            if ( (NPC_ClearLOS2( &g_entities[0], self->r.currentOrigin )) )
            {
            return;
            }
            }
            */
            //Don't care about this for MP I guess.
        }

        //FIXME: there are some conditions - such as heavy combat - in which we want
        //			to remove the bodies... but in other cases it's just weird, like
        //			when they're right behind you in a closed room and when they've been
        //			placed as dead NPCs by a designer...
        //			For now we just assume that a corpse with no enemy was
        //			placed in the map as a corpse
        if `self`.enemy != nil {
            //if ( !self->taskManager || !self->taskManager->IsRunning() )
            if !trap_ICARUS_IsRunning(`self`.s.number) {
                if `self`.activator == nil || `self`.activator!.client == nil || !((`self`.activator!.client!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0) {
                    //not being held by a Rancor
                    if `self`.client != nil && `self`.client!.ps.saberEntityNum > 0 && `self`.client!.ps.saberEntityNum < ENTITYNUM_WORLD {
                        let saberent: Entity? = g_entities[`self`.client!.ps.saberEntityNum]
                        if saberent != nil {
                            G_FreeEntity(saberent!)
                        }
                    }
                    G_FreeEntity(`self`)
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC.c:233
func BodyRemovalPadTime(_ ent: Entity) -> Int32 {
    var time: Int32

    if ent.client == nil {
        return 0
    }
    /*
    switch ( ent->client->playerTeam )
    {
    case NPCTEAM_KLINGON:	// no effect, we just remove them when the player isn't looking
    case NPCTEAM_SCAVENGERS:
    case NPCTEAM_HIROGEN:
    case NPCTEAM_MALON:
    case NPCTEAM_IMPERIAL:
    case NPCTEAM_STARFLEET:
    time = 10000; // 15 secs.
    break;

    case NPCTEAM_BORG:
    time = 2000;
    break;

    case NPCTEAM_STASIS:
    return qtrue;
    break;

    case NPCTEAM_FORGE:
    time = 1000;
    break;

    case NPCTEAM_BOTS:
    //		if (!Q_stricmp( ent->NPC_type, "mouse" ))
    //		{
    time = 0;
    //		}
    //		else
    //		{
    //			time = 10000;
    //		}
    break;

    case NPCTEAM_8472:
    time = 2000;
    break;

    default:
    // never go away
    time = Q3_INFINITE;
    break;
    }
    */
    // team no longer indicates species/race, so in this case we'd use NPC_class, but
    switch ent.client!.NPC_class {
    //case CLASS_PROTOCOL:
    case CLASS_MOUSE, CLASS_GONK, CLASS_R2D2, CLASS_R5D2, CLASS_MARK1, CLASS_MARK2, CLASS_PROBE, CLASS_SEEKER, CLASS_REMOTE, CLASS_SENTRY, CLASS_INTERROGATOR:
        time = 0

    default:
        // never go away
        //	time = Q3_INFINITE;
        // for now I'm making default 10000
        time = 10000
    }


    return time
}

/// Source: oracle/codemp/game/NPC.c:323
private func NPC_RemoveBodyEffect() {
    //	vec3_t		org;
    //	gentity_t	*tent;

    if NPC == nil || NPC!.client == nil || (NPC!.s.eFlags & EF_NODRAW) != 0 {
        return
    }
    /*
    switch(NPC->client->playerTeam)
    {
    case NPCTEAM_STARFLEET:
    //FIXME: Starfleet beam out
    break;

    case NPCTEAM_BOTS:
    //		VectorCopy( NPC->r.currentOrigin, org );
    //		org[2] -= 16;
    //		tent = G_TempEntity( org, EV_BOT_EXPLODE );
    //		tent->owner = NPC;

    break;

    default:
    break;
    }
    */


    // team no longer indicates species/race, so in this case we'd use NPC_class, but

    // stub code
    switch NPC!.client!.NPC_class {
    //case CLASS_PROTOCOL:
    case CLASS_PROBE, CLASS_SEEKER, CLASS_REMOTE, CLASS_SENTRY, CLASS_GONK, CLASS_R2D2, CLASS_R5D2, CLASS_MARK1, CLASS_MARK2, CLASS_INTERROGATOR, CLASS_ATST:
        //	VectorCopy( NPC->r.currentOrigin, org );
        //	org[2] -= 16;
        //	tent = G_TempEntity( org, EV_BOT_EXPLODE );
        //	tent->owner = NPC;
        break

    default:
        break
    }
}

/// Source: oracle/codemp/game/NPC.c:395
func pitch_roll_for_slope(_ forwhom: Entity, _ pass_slope: JKAShared.vec3_t?) {
    var slope = vec3_t()
    var nvf = vec3_t()
    var ovf = vec3_t()
    var ovr = vec3_t()
    var startspot = vec3_t()
    var endspot = vec3_t()
    var new_angles = vec3_t(0, 0, 0)
    var pitch: Float = 0
    var mod: Float = 0
    var dot: Float = 0

    //if we don't have a slope, get one
    if pass_slope == nil || VectorCompare(vec3_origin, pass_slope!) != 0 {
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut = Trace.scratch { trace -> Bool in

            startspot = forwhom.r.currentOrigin
            startspot[2] += forwhom.r.mins[2] + 4
            endspot = startspot
            endspot[2] -= 300
            trap_Trace(trace, forwhom.r.currentOrigin, vec3_origin, vec3_origin, endspot, forwhom.s.number, MASK_SOLID)
            //		if(trace_fraction>0.05&&forwhom.movetype==MOVETYPE_STEP)
            //			forwhom.flags(-)FL_ONGROUND;

            if Double(trace.fraction) >= 1.0 {
                return true
            }


            if VectorCompare(vec3_origin, trace.plane.normal) != 0 {
                return true
            }

            slope = trace.plane.normal
            return false
        }
        if earlyOut {
            return
        }
    } else {
        slope = pass_slope!
    }


    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("pitch_roll_for_slope", source: "oracle/codemp/game/NPC.c:395")
    var scratchUp = vec3_t()
    AngleVectors(forwhom.r.currentAngles, &ovf, &ovr, &scratchUp)

    vectoangles(slope, &new_angles)
    pitch = new_angles[PITCH] + 90
    new_angles[PITCH] = 0
    new_angles[ROLL] = new_angles[PITCH]

    // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("pitch_roll_for_slope", source: "oracle/codemp/game/NPC.c:395")
    var scratchRight = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("pitch_roll_for_slope", source: "oracle/codemp/game/NPC.c:395")
    var scratchUp2 = vec3_t()
    AngleVectors(new_angles, &nvf, &scratchRight, &scratchUp2)

    mod = _DotProduct(nvf, ovr)

    if mod < 0 {
        mod = -1
    } else {
        mod = 1
    }

    dot = _DotProduct(nvf, ovf)

    if forwhom.client != nil {
        var oldmins2: Float = 0

        forwhom.client!.ps.viewangles[PITCH] = dot * pitch
        forwhom.client!.ps.viewangles[ROLL] = ((1 - Q_fabs(dot)) * pitch * mod)
        oldmins2 = forwhom.r.mins[2]
        forwhom.r.mins[2] = -24 + 12 * abs(forwhom.client!.ps.viewangles[PITCH]) / 180.0
        //FIXME: if it gets bigger, move up
        if oldmins2 > forwhom.r.mins[2] {
            //our mins is now lower, need to move up
            //FIXME: trace?
            forwhom.client!.ps.origin[2] += (oldmins2 - forwhom.r.mins[2])
            forwhom.r.currentOrigin[2] = forwhom.client!.ps.origin[2]
            trap_LinkEntity(forwhom)
        }
    } else {
        forwhom.r.currentAngles[PITCH] = dot * pitch
        forwhom.r.currentAngles[ROLL] = ((1 - Q_fabs(dot)) * pitch * mod)
    }
}

/**
```
----------------------------------------
DeadThink
----------------------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:478
private func DeadThink() {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in

        //HACKHACKHACKHACKHACK
        //We should really have a seperate G2 bounding box (seperate from the physics bbox) for G2 collisions only
        //FIXME: don't ever inflate back up?
        NPC!.r.maxs[2] = NPC!.client!.renderInfo.eyePoint[2] - NPC!.r.currentOrigin[2] + 4
        if NPC!.r.maxs[2] < -8 {
            NPC!.r.maxs[2] = -8
        }
        if VectorCompare(NPC!.client!.ps.velocity, vec3_origin) != 0 {
            //not flying through the air
            if NPC!.r.mins[0] > -32 {
                NPC!.r.mins[0] -= 1
                trap_Trace(trace, NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPC!.r.currentOrigin, NPC!.s.number, NPC!.clipmask)
                if trace.allsolid != 0 {
                    NPC!.r.mins[0] += 1
                }
            }
            if NPC!.r.maxs[0] < 32 {
                NPC!.r.maxs[0] += 1
                trap_Trace(trace, NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPC!.r.currentOrigin, NPC!.s.number, NPC!.clipmask)
                if trace.allsolid != 0 {
                    NPC!.r.maxs[0] -= 1
                }
            }
            if NPC!.r.mins[1] > -32 {
                NPC!.r.mins[1] -= 1
                trap_Trace(trace, NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPC!.r.currentOrigin, NPC!.s.number, NPC!.clipmask)
                if trace.allsolid != 0 {
                    NPC!.r.mins[1] += 1
                }
            }
            if NPC!.r.maxs[1] < 32 {
                NPC!.r.maxs[1] += 1
                trap_Trace(trace, NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPC!.r.currentOrigin, NPC!.s.number, NPC!.clipmask)
                if trace.allsolid != 0 {
                    NPC!.r.maxs[1] -= 1
                }
            }
        }
        //HACKHACKHACKHACKHACK

        //FIXME: tilt and fall off of ledges?
        //NPC_PostDeathThink();

        /*
        if ( !NPCInfo->timeOfDeath && NPC->client != NULL && NPCInfo != NULL )
        {
        //haven't finished death anim yet and were NOT given a specific amount of time to wait before removal
        int				legsAnim	= NPC->client->ps.legsAnim;
        animation_t		*animations	= knownAnimFileSets[NPC->client->clientInfo.animFileIndex].animations;

        NPC->bounceCount = -1; // This is a cheap hack for optimizing the pointcontents check below

        //ghoul doesn't tell us this anymore
        //if ( NPC->client->renderInfo.legsFrame == animations[legsAnim].firstFrame + (animations[legsAnim].numFrames - 1) )
        {
        //reached the end of the death anim
        NPCInfo->timeOfDeath = level.time + BodyRemovalPadTime( NPC );
        }
        }
        else
        */
        do {
            //death anim done (or were given a specific amount of time to wait before removal), wait the requisite amount of time them remove
            if level.time >= NPCInfo!.timeOfDeath + BodyRemovalPadTime(NPC!) {
                if (NPC!.client!.ps.eFlags & EF_NODRAW) != 0 {
                    if !trap_ICARUS_IsRunning(NPC!.s.number) {
                        NPC!.think = Think.G_FreeEntity
                        NPC!.nextthink = level.time + FRAMETIME
                    }
                } else {
                    var npc_class: class_t = 0

                    // Start the body effect first, then delay 400ms before ditching the corpse
                    NPC_RemoveBodyEffect()

                    //FIXME: keep it running through physics somehow?
                    NPC!.think = Think.NPC_RemoveBody
                    NPC!.nextthink = level.time + FRAMETIME
                    //	if ( NPC->client->playerTeam == NPCTEAM_FORGE )
                    //		NPCInfo->timeOfDeath = level.time + FRAMETIME * 8;
                    //	else if ( NPC->client->playerTeam == NPCTEAM_BOTS )
                    npc_class = NPC!.client!.NPC_class
                    // check for droids
                    if npc_class == CLASS_SEEKER || npc_class == CLASS_REMOTE || npc_class == CLASS_PROBE || npc_class == CLASS_MOUSE || npc_class == CLASS_GONK || npc_class == CLASS_R2D2 || npc_class == CLASS_R5D2 || npc_class == CLASS_MARK2 || npc_class == CLASS_SENTRY {
                        NPC!.client!.ps.eFlags |= EF_NODRAW
                        NPCInfo!.timeOfDeath = level.time + FRAMETIME * 8
                    } else {
                        NPCInfo!.timeOfDeath = level.time + FRAMETIME * 4
                    }
                }
                return true
            }
        }

        // If the player is on the ground and the resting position contents haven't been set yet...(BounceCount tracks the contents)
        if NPC!.bounceCount < 0 && NPC!.s.groundEntityNum >= 0 {
            // if client is in a nodrop area, make him/her nodraw
            // Port-note: An assignment inside an expression.
            // Raven wrote: int contents = NPC->bounceCount = trap_PointContents( NPC->r.currentOrigin, -1 );
            portMissing("DeadThink", source: "oracle/codemp/game/NPC.c:478")

            // Port-note: A read of `contents`, a local the draft left as a hole.
            // Raven wrote: if ( ( contents & CONTENTS_NODROP ) ) { NPC->client->ps.eFlags |= EF_NODRAW; }
            portMissing("DeadThink", source: "oracle/codemp/game/NPC.c:478")
        }

        CorpsePhysics(NPC!)
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
===============
SetNPCGlobals

local function to set globals used throughout the AI code
===============
```
*/
/// Source: oracle/codemp/game/NPC.c:617
func SetNPCGlobals(_ ent: Entity) {
    NPC = ent
    NPCInfo = ent.NPC
    client = ent.client
    ucmd.clear()
}

/// Source: oracle/codemp/game/NPC.c:630
func SaveNPCGlobals() {
    _saved_NPC = NPC
    _saved_NPCInfo = NPCInfo
    _saved_client = client
    _saved_ucmd.copy(from: ucmd)
}

/// Source: oracle/codemp/game/NPC.c:638
func RestoreNPCGlobals() {
    NPC = _saved_NPC
    NPCInfo = _saved_NPCInfo
    client = _saved_client
    ucmd.copy(from: _saved_ucmd)
}

//We MUST do this, other funcs were using NPC illegally when "self" wasn't the global NPC
/// Source: oracle/codemp/game/NPC.c:647
func ClearNPCGlobals() {
    NPC = nil
    NPCInfo = nil
    client = nil
}

/// Source: oracle/codemp/game/NPC.c:664
func NPC_ShowDebugInfo() {
    if showBBoxes {
        var found: Entity? = nil
        var mins = vec3_t()
        var maxs = vec3_t()

        // Port-note: An assignment inside an expression.
        // Raven wrote: while( (found = G_Find( found, FOFS(classname), "NPC" ) ) != NULL ) { if ( trap_InPVS( found->r.currentOrigin, g_entities[0].r.currentOrigin ) ) { VectorAdd( found->r.currentOrigin, found->r.mins, mins ); VectorAdd( found->r.currentOrigin, found->r.maxs, maxs ); G_Cube( mins, maxs, NPCDEBUG_RED, 0.25 ); } }
        portMissing("NPC_ShowDebugInfo", source: "oracle/codemp/game/NPC.c:664")
    }
}

/// Source: oracle/codemp/game/NPC.c:683
func NPC_ApplyScriptFlags() {
    if (NPCInfo!.scriptFlags & SCF_CROUCHED) != 0 {
        if NPCInfo!.charmedTime > level.time && (ucmd.forwardmove != 0 || ucmd.rightmove != 0) {
            //ugh, if charmed and moving, ignore the crouched command
        } else {
            ucmd.upmove = -127
        }
    }

    if (NPCInfo!.scriptFlags & SCF_RUNNING) != 0 {
        ucmd.buttons &= ~BUTTON_WALKING
    } else if (NPCInfo!.scriptFlags & SCF_WALKING) != 0 {
        if NPCInfo!.charmedTime > level.time && (ucmd.forwardmove != 0 || ucmd.rightmove != 0) {
            //ugh, if charmed and moving, ignore the walking command
        } else {
            ucmd.buttons |= BUTTON_WALKING
        }
    }
    /*
    if(NPCInfo->scriptFlags & SCF_CAREFUL)
    {
    ucmd.buttons |= BUTTON_CAREFUL;
    }
    */
    if (NPCInfo!.scriptFlags & SCF_LEAN_RIGHT) != 0 {
        ucmd.buttons |= BUTTON_USE
        ucmd.rightmove = 127
        ucmd.forwardmove = 0
        ucmd.upmove = 0
    } else if (NPCInfo!.scriptFlags & SCF_LEAN_LEFT) != 0 {
        ucmd.buttons |= BUTTON_USE
        ucmd.rightmove = -127
        ucmd.forwardmove = 0
        ucmd.upmove = 0
    }

    if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 && (ucmd.buttons & BUTTON_ATTACK) != 0 {
        //Use altfire instead
        ucmd.buttons |= BUTTON_ALT_ATTACK
    }
}

/// Source: oracle/codemp/game/NPC.c:738
func NPC_HandleAIFlags() {
    //FIXME: make these flags checks a function call like NPC_CheckAIFlagsAndTimers
    if (NPCInfo!.aiFlags & NPCAI_LOST) != 0 {
        //Print that you need help!
        //FIXME: shouldn't remove this just yet if cg_draw needs it
        NPCInfo!.aiFlags &= ~NPCAI_LOST

        /*
        if ( showWaypoints )
        {
        Q3_DebugPrint(WL_WARNING, "%s can't navigate to target %s (my wp: %d, goal wp: %d)\n", NPC->targetname, NPCInfo->goalEntity->targetname, NPC->waypoint, NPCInfo->goalEntity->waypoint );
        }
        */

        if NPCInfo!.goalEntity != nil && NPCInfo!.goalEntity == NPC!.enemy {
            //We can't nav to our enemy
            //Drop enemy and see if we should search for him
            NPC_LostEnemyDecideChase()
        }
    }

    //MRJ Request:
    /*
    if ( NPCInfo->aiFlags & NPCAI_GREET_ALLIES && !NPC->enemy )//what if "enemy" is the greetEnt?
    {//If no enemy, look for teammates to greet
    //FIXME: don't say hi to the same guy over and over again.
    if ( NPCInfo->greetingDebounceTime < level.time )
    {//Has been at least 2 seconds since we greeted last
    if ( !NPCInfo->greetEnt )
    {//Find a teammate whom I'm facing and who is facing me and within 128
    NPCInfo->greetEnt = NPC_PickAlly( qtrue, 128, qtrue, qtrue );
    }

    if ( NPCInfo->greetEnt && !Q_irand(0, 5) )
    {//Start greeting someone
    qboolean	greeted = qfalse;

    //TODO:  If have a greetscript, run that instead?

    //FIXME: make them greet back?
    if( !Q_irand( 0, 2 ) )
    {//Play gesture anim (press gesture button?)
    greeted = qtrue;
    NPC_SetAnim( NPC, SETANIM_TORSO, Q_irand( BOTH_GESTURE1, BOTH_GESTURE3 ), SETANIM_FLAG_NORMAL|SETANIM_FLAG_HOLD );
    //NOTE: play full-body gesture if not moving?
    }

    if( !Q_irand( 0, 2 ) )
    {//Play random voice greeting sound
    greeted = qtrue;
    //FIXME: need NPC sound sets

    //G_AddVoiceEvent( NPC, Q_irand(EV_GREET1, EV_GREET3), 2000 );
    }

    if( !Q_irand( 0, 1 ) )
    {//set looktarget to them for a second or two
    greeted = qtrue;
    NPC_TempLookTarget( NPC, NPCInfo->greetEnt->s.number, 1000, 3000 );
    }

    if ( greeted )
    {//Did at least one of the things above
    //Don't greet again for 2 - 4 seconds
    NPCInfo->greetingDebounceTime = level.time + Q_irand( 2000, 4000 );
    NPCInfo->greetEnt = NULL;
    }
    }
    }
    }
    */
    //been told to play a victory sound after a delay
    if NPCInfo!.greetingDebounceTime != 0 && NPCInfo!.greetingDebounceTime < level.time {
        G_AddVoiceEvent(NPC!, Q_irand(EV_VICTORY1, EV_VICTORY3), Q_irand(2000, 4000))
        NPCInfo!.greetingDebounceTime = 0
    }

    if NPCInfo!.ffireCount > 0 {
        if NPCInfo!.ffireFadeDebounce < level.time {
            NPCInfo!.ffireCount -= 1
            //Com_Printf( "drop: %d < %d\n", NPCInfo->ffireCount, 3+((2-g_spskill.integer)*2) );
            NPCInfo!.ffireFadeDebounce = level.time + 3000
        }
    }
    if d_patched.integer != 0 {
        //use patch-style navigation
        if NPCInfo!.consecutiveBlockedMoves > 20 {
            //been stuck for a while, try again?
            NPCInfo!.consecutiveBlockedMoves = 0
        }
    }
}

/// Source: oracle/codemp/game/NPC.c:835
func NPC_AvoidWallsAndCliffs() {
    //...
}

/// Source: oracle/codemp/game/NPC.c:840
func NPC_CheckAttackScript() {
    if !((ucmd.buttons & BUTTON_ATTACK) != 0) {
        return
    }

    G_ActivateBehavior(NPC!, BSET_ATTACK)
}

/// Source: oracle/codemp/game/NPC.c:851
func NPC_CheckAttackHold() {
    var vec = vec3_t()

    // If they don't have an enemy they shouldn't hold their attack anim.
    if NPC!.enemy == nil {
        NPCInfo!.attackHoldTime = 0
        return
    }

    /*	if ( ( NPC->client->ps.weapon == WP_BORG_ASSIMILATOR ) || ( NPC->client->ps.weapon == WP_BORG_DRILL ) )
    {//FIXME: don't keep holding this if can't hit enemy?

    // If they don't have shields ( been disabled) they shouldn't hold their attack anim.
    if ( !(NPC->NPC->aiFlags & NPCAI_SHIELDS) )
    {
    NPCInfo->attackHoldTime = 0;
    return;
    }

    VectorSubtract(NPC->enemy->r.currentOrigin, NPC->r.currentOrigin, vec);
    if( VectorLengthSquared(vec) > NPC_MaxDistSquaredForWeapon() )
    {
    NPCInfo->attackHoldTime = 0;
    PM_SetTorsoAnimTimer(NPC, &NPC->client->ps.torsoAnimTimer, 0);
    }
    else if( NPCInfo->attackHoldTime && NPCInfo->attackHoldTime > level.time )
    {
    ucmd.buttons |= BUTTON_ATTACK;
    }
    else if ( ( NPCInfo->attackHold ) && ( ucmd.buttons & BUTTON_ATTACK ) )
    {
    NPCInfo->attackHoldTime = level.time + NPCInfo->attackHold;
    PM_SetTorsoAnimTimer(NPC, &NPC->client->ps.torsoAnimTimer, NPCInfo->attackHold);
    }
    else
    {
    NPCInfo->attackHoldTime = 0;
    PM_SetTorsoAnimTimer(NPC, &NPC->client->ps.torsoAnimTimer, 0);
    }
    }
    else*/
    do {
        //everyone else...?  FIXME: need to tie this into AI somehow?
        vec = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
        if VectorLengthSquared(vec) > NPC_MaxDistSquaredForWeapon() {
            NPCInfo!.attackHoldTime = 0
        } else if NPCInfo!.attackHoldTime != 0 && NPCInfo!.attackHoldTime > level.time {
            ucmd.buttons |= BUTTON_ATTACK
        } else if NPCInfo!.attackHold != 0 && (ucmd.buttons & BUTTON_ATTACK) != 0 {
            NPCInfo!.attackHoldTime = level.time + NPCInfo!.attackHold
        } else {
            NPCInfo!.attackHoldTime = 0
        }
    }
}

/**
```
void NPC_KeepCurrentFacing(void)

Fills in a default ucmd to keep current angles facing
```
*/
/// Source: oracle/codemp/game/NPC.c:920
func NPC_KeepCurrentFacing() {
    if ucmd.angles[YAW] == 0 {
        ucmd.angles[YAW] = ANGLE2SHORT(client!.ps.viewangles[YAW]) - client!.ps.delta_angles[YAW]
    }

    if ucmd.angles[PITCH] == 0 {
        ucmd.angles[PITCH] = ANGLE2SHORT(client!.ps.viewangles[PITCH]) - client!.ps.delta_angles[PITCH]
    }
}

/// Source: oracle/codemp/game/NPC.c:939
func NPC_BehaviorSet_Charmed(_ bState: Int32) {
    switch bState {
    case BS_FOLLOW_LEADER:
        NPC_BSFollowLeader()

    case BS_REMOVE:
        NPC_BSRemove()

    case BS_SEARCH:
        NPC_BSSearch()

    case BS_WANDER:
        NPC_BSWander()

    case BS_FLEE:
        NPC_BSFlee()

    default:
        NPC_BSDefault()
    }
}

/// Source: oracle/codemp/game/NPC.c:970
func NPC_BehaviorSet_Default(_ bState: Int32) {
    switch bState {
    case BS_ADVANCE_FIGHT:
        NPC_BSAdvanceFight()

    case BS_SLEEP:
        NPC_BSSleep()

    case BS_FOLLOW_LEADER:
        NPC_BSFollowLeader()

    case BS_JUMP:
        NPC_BSJump()

    case BS_REMOVE:
        NPC_BSRemove()

    case BS_SEARCH:
        NPC_BSSearch()

    case BS_NOCLIP:
        NPC_BSNoClip()

    case BS_WANDER:
        NPC_BSWander()

    case BS_FLEE:
        NPC_BSFlee()

    case BS_WAIT:
        NPC_BSWait()

    case BS_CINEMATIC:
        NPC_BSCinematic()

    default:
        NPC_BSDefault()
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Interrogator
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1019
func NPC_BehaviorSet_Interrogator(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSInterrogator_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_ImperialProbe
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1045
func NPC_BehaviorSet_ImperialProbe(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSImperialProbe_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Seeker
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1070
func NPC_BehaviorSet_Seeker(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSSeeker_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Remote
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1094
func NPC_BehaviorSet_Remote(_ bState: Int32) {
    NPC_BSRemote_Default()
}

/**
```
-------------------------
NPC_BehaviorSet_Sentry
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1106
func NPC_BehaviorSet_Sentry(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSSentry_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Grenadier
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1128
func NPC_BehaviorSet_Grenadier(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSGrenadier_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Sniper
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1150
func NPC_BehaviorSet_Sniper(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSSniper_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/// Source: oracle/codemp/game/NPC.c:1173
func NPC_BehaviorSet_Stormtrooper(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSST_Default()

    case BS_INVESTIGATE:
        NPC_BSST_Investigate()

    case BS_SLEEP:
        NPC_BSST_Sleep()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/// Source: oracle/codemp/game/NPC.c:1205
func NPC_BehaviorSet_Jedi(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSJedi_Default()

    case BS_FOLLOW_LEADER:
        NPC_BSJedi_FollowLeader()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Droid
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1232
func NPC_BehaviorSet_Droid(_ bState: Int32) {
    switch bState {
    case BS_DEFAULT, BS_STAND_GUARD, BS_PATROL:
        NPC_BSDroid_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Mark1
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1252
func NPC_BehaviorSet_Mark1(_ bState: Int32) {
    switch bState {
    case BS_DEFAULT, BS_STAND_GUARD, BS_PATROL:
        NPC_BSMark1_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Mark2
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1272
func NPC_BehaviorSet_Mark2(_ bState: Int32) {
    switch bState {
    case BS_DEFAULT, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL:
        NPC_BSMark2_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_ATST
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1293
func NPC_BehaviorSet_ATST(_ bState: Int32) {
    switch bState {
    case BS_DEFAULT, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL:
        NPC_BSATST_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_MineMonster
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1314
func NPC_BehaviorSet_MineMonster(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSMineMonster_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Howler
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1336
func NPC_BehaviorSet_Howler(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSHowler_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/**
```
-------------------------
NPC_BehaviorSet_Rancor
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC.c:1358
func NPC_BehaviorSet_Rancor(_ bState: Int32) {
    switch bState {
    case BS_STAND_GUARD, BS_PATROL, BS_STAND_AND_SHOOT, BS_HUNT_AND_KILL, BS_DEFAULT:
        NPC_BSRancor_Default()

    default:
        NPC_BehaviorSet_Default(bState)
    }
}

/// Source: oracle/codemp/game/NPC.c:1384
func NPC_RunBehavior(_ team: Int32, _ bState: Int32) {
    var dontSetAim: Bool = false

    if NPC!.s.NPC_class == CLASS_VEHICLE && NPC!.m_pVehicle != nil {
        //vehicles don't do AI!
        return
    }

    if bState == BS_CINEMATIC {
        NPC_BSCinematic()
    } else if NPC!.client!.ps.weapon == WP_EMPLACED_GUN {
        NPC_BSEmplaced()
        NPC_CheckCharmed()
        return
    } else if NPC!.client!.ps.weapon == WP_SABER {
        //jedi
        NPC_BehaviorSet_Jedi(bState)
        dontSetAim = true
    } else if NPC!.client!.NPC_class == CLASS_WAMPA {
        //wampa
        NPC_BSWampa_Default()
    } else if NPC!.client!.NPC_class == CLASS_RANCOR {
        //rancor
        NPC_BehaviorSet_Rancor(bState)
    } else if NPC!.client!.NPC_class == CLASS_REMOTE {
        NPC_BehaviorSet_Remote(bState)
    } else if NPC!.client!.NPC_class == CLASS_SEEKER {
        NPC_BehaviorSet_Seeker(bState)
    } else if NPC!.client!.NPC_class == CLASS_BOBAFETT {
        //bounty hunter
        if Boba_Flying(NPC!) {
            NPC_BehaviorSet_Seeker(bState)
        } else {
            NPC_BehaviorSet_Jedi(bState)
        }
        dontSetAim = true
    } else if (NPCInfo!.scriptFlags & SCF_FORCED_MARCH) != 0 {
        //being forced to march
        NPC_BSDefault()
    } else {
        switch team {
        //	case NPCTEAM_SCAVENGERS:
        //	case NPCTEAM_IMPERIAL:
        //	case NPCTEAM_KLINGON:
        //	case NPCTEAM_HIROGEN:
        //	case NPCTEAM_MALON:
        // not sure if TEAM_ENEMY is appropriate here, I think I should be using NPC_class to check for behavior - dmv
        case NPCTEAM_ENEMY:
            // special cases for enemy droids
            switch NPC!.client!.NPC_class {
            case CLASS_ATST:
                NPC_BehaviorSet_ATST(bState)
                return

            case CLASS_PROBE:
                NPC_BehaviorSet_ImperialProbe(bState)
                return

            case CLASS_REMOTE:
                NPC_BehaviorSet_Remote(bState)
                return

            case CLASS_SENTRY:
                NPC_BehaviorSet_Sentry(bState)
                return

            case CLASS_INTERROGATOR:
                NPC_BehaviorSet_Interrogator(bState)
                return

            case CLASS_MINEMONSTER:
                NPC_BehaviorSet_MineMonster(bState)
                return

            case CLASS_HOWLER:
                NPC_BehaviorSet_Howler(bState)
                return

            case CLASS_MARK1:
                NPC_BehaviorSet_Mark1(bState)
                return

            case CLASS_MARK2:
                NPC_BehaviorSet_Mark2(bState)
                return

            case CLASS_GALAKMECH:
                NPC_BSGM_Default()
                return

            default:
                break
            }

            if NPC!.enemy != nil && NPC!.s.weapon == WP_NONE && bState != BS_HUNT_AND_KILL && !trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
                //if in battle and have no weapon, run away, fixme: when in BS_HUNT_AND_KILL, they just stand there
                if bState != BS_FLEE {
                    NPC_StartFlee(NPC!.enemy!, NPC!.enemy!.r.currentOrigin, AEL_DANGER_GREAT, 5000, 10000)
                } else {
                    NPC_BSFlee()
                }
                return
            }
            if NPC!.client!.ps.weapon == WP_SABER {
                //special melee exception
                NPC_BehaviorSet_Default(bState)
                return
            }
            if NPC!.client!.ps.weapon == WP_DISRUPTOR && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                //a sniper
                NPC_BehaviorSet_Sniper(bState)
                return
            }
            if NPC!.client!.ps.weapon == WP_THERMAL || NPC!.client!.ps.weapon == WP_STUN_BATON {
                //a grenadier
                NPC_BehaviorSet_Grenadier(bState)
                return
            }
            if NPC_CheckSurrender() {
                return
            }
            NPC_BehaviorSet_Stormtrooper(bState)

        case NPCTEAM_NEUTRAL:
            // special cases for enemy droids
            if NPC!.client!.NPC_class == CLASS_PROTOCOL || NPC!.client!.NPC_class == CLASS_UGNAUGHT || NPC!.client!.NPC_class == CLASS_JAWA {
                NPC_BehaviorSet_Default(bState)
            } else if NPC!.client!.NPC_class == CLASS_VEHICLE {
                // TODO: Add vehicle behaviors here.
                NPC_UpdateAngles(true, true) //just face our spawn angles for now
            } else {
                // Just one of the average droids
                NPC_BehaviorSet_Droid(bState)
            }

        default:
            if NPC!.client!.NPC_class == CLASS_SEEKER {
                NPC_BehaviorSet_Seeker(bState)
            } else {
                if NPCInfo!.charmedTime > level.time {
                    NPC_BehaviorSet_Charmed(bState)
                } else {
                    NPC_BehaviorSet_Default(bState)
                }
                NPC_CheckCharmed()
                dontSetAim = true
            }
        }
    }
}

/**
```
===============
NPC_ExecuteBState

  MCG

NPC Behavior state thinking

===============
```
*/
/// Source: oracle/codemp/game/NPC.c:1576
func NPC_ExecuteBState(_ `self`: Entity) {
    let bState: bState_t

    NPC_HandleAIFlags()

    //FIXME: these next three bits could be a function call, some sort of setup/cleanup func
    //Lookmode must be reset every think cycle
    if NPC!.delayScriptTime != 0 && NPC!.delayScriptTime <= level.time {
        G_ActivateBehavior(NPC!, BSET_DELAYED)
        NPC!.delayScriptTime = 0
    }

    //Clear this and let bState set it itself, so it automatically handles changing bStates... but we need a set bState wrapper func
    NPCInfo!.combatMove = false

    //Execute our bState
    if NPCInfo!.tempBehavior != 0 {
        //Overrides normal behavior until cleared
        bState = NPCInfo!.tempBehavior
    } else {
        if NPCInfo!.behaviorState == 0 {
            NPCInfo!.behaviorState = NPCInfo!.defaultBehavior
        }

        bState = NPCInfo!.behaviorState
    }

    //Pick the proper bstate for us and run it
    NPC_RunBehavior(`self`.client!.playerTeam, bState)


    //	if(bState != BS_POINT_COMBAT && NPCInfo->combatPoint != -1)
    //	{
    //level.combatPoints[NPCInfo->combatPoint].occupied = qfalse;
    //NPCInfo->combatPoint = -1;
    //	}

    //Here we need to see what the scripted stuff told us to do
    //Only process snapshot if independant and in combat mode- this would pick enemies and go after needed items
    //	ProcessSnapshot();

    //Ignore my needs if I'm under script control- this would set needs for items
    //	CheckSelf();

    //Back to normal?  All decisions made?

    //FIXME: don't walk off ledges unless we can get to our goal faster that way, or that's our goal's surface
    //NPCPredict();

    if NPC!.enemy != nil {
        if !NPC!.enemy!.inuse {
            //just in case bState doesn't catch this
            G_ClearEnemy(NPC!)
        }
    }

    if NPC!.client!.ps.saberLockTime != 0 && NPC!.client!.ps.saberLockEnemy != ENTITYNUM_NONE {
        NPC_SetLookTarget(NPC!, NPC!.client!.ps.saberLockEnemy, level.time + 1000)
    } else if !NPC_CheckLookTarget(NPC!) {
        if NPC!.enemy != nil {
            NPC_SetLookTarget(NPC!, NPC!.enemy!.s.number, 0)
        }
    }

    if NPC!.enemy != nil {
        if (NPC!.enemy!.flags & FL_DONT_SHOOT) != 0 {
            ucmd.buttons &= ~BUTTON_ATTACK
            ucmd.buttons &= ~BUTTON_ALT_ATTACK
        } else if NPC!.client!.playerTeam != NPCTEAM_ENEMY && NPC!.enemy!.NPC != nil && (NPC!.enemy!.NPC!.surrenderTime > level.time || (NPC!.enemy!.NPC!.scriptFlags & SCF_FORCED_MARCH) != 0) {
            //don't shoot someone who's surrendering if you're a good guy
            ucmd.buttons &= ~BUTTON_ATTACK
            ucmd.buttons &= ~BUTTON_ALT_ATTACK
        }

        if client!.ps.weaponstate == WEAPON_IDLE {
            client!.ps.weaponstate = WEAPON_READY
        }
    } else {
        if client!.ps.weaponstate == WEAPON_READY {
            client!.ps.weaponstate = WEAPON_IDLE
        }
    }

    if !((ucmd.buttons & BUTTON_ATTACK) != 0) && NPC!.attackDebounceTime > level.time {
        //We just shot but aren't still shooting, so hold the gun up for a while
        if client!.ps.weapon == WP_SABER {
            //One-handed
            NPC_SetAnim(NPC!, SETANIM_TORSO, TORSO_WEAPONREADY1, SETANIM_FLAG_NORMAL)
        } else if client!.ps.weapon == WP_BRYAR_PISTOL {
            //Sniper pose
            NPC_SetAnim(NPC!, SETANIM_TORSO, TORSO_WEAPONREADY3, SETANIM_FLAG_NORMAL)
        }
        /*//FIXME: What's the proper solution here?
        else
        {//heavy weapon
        NPC_SetAnim(NPC,SETANIM_TORSO,TORSO_WEAPONREADY3,SETANIM_FLAG_NORMAL);
        }
        */
    } else if NPC!.enemy == nil {
        //		if(client->ps.weapon != WP_TRICORDER)
        do {
            if NPC!.s.torsoAnim == TORSO_WEAPONREADY1 || NPC!.s.torsoAnim == TORSO_WEAPONREADY3 {
                //we look ready for action, using one of the first 2 weapon, let's rest our weapon on our shoulder
                NPC_SetAnim(NPC!, SETANIM_TORSO, TORSO_WEAPONIDLE3, SETANIM_FLAG_NORMAL)
            }
        }
    }

    NPC_CheckAttackHold()
    NPC_ApplyScriptFlags()

    //cliff and wall avoidance
    NPC_AvoidWallsAndCliffs()

    // run the bot through the server like it was a real client
    //=== Save the ucmd for the second no-think Pmove ============================
    ucmd.serverTime = level.time - 50
    NPCInfo!.last_ucmd.copy(from: ucmd)
    if NPCInfo!.attackHoldTime == 0 {
        NPCInfo!.last_ucmd.buttons &= ~(BUTTON_ATTACK | BUTTON_ALT_ATTACK) //so we don't fire twice in one think
    }
    //============================================================================
    NPC_CheckAttackScript()
    NPC_KeepCurrentFacing()

    if NPC!.next_roff_time == 0 || NPC!.next_roff_time < level.time {
        //If we were following a roff, we don't do normal pmoves.
        ClientThink(NPC!.s.number, ucmd)
    } else {
        NPC_ApplyRoff()
    }

    // end of thinking cleanup
    NPCInfo!.touchedByPlayer = nil

    NPC_CheckPlayerAim()
    NPC_CheckAllClear()

    /*if( ucmd.forwardmove || ucmd.rightmove )
    {
    int	i, la = -1, ta = -1;

    for(i = 0; i < MAX_ANIMATIONS; i++)
    {
    if( NPC->client->ps.legsAnim == i )
    {
    la = i;
    }

    if( NPC->client->ps.torsoAnim == i )
    {
    ta = i;
    }

    if(la != -1 && ta != -1)
    {
    break;
    }
    }

    if(la != -1 && ta != -1)
    {//FIXME: should never play same frame twice or restart an anim before finishing it
    Com_Printf("LegsAnim: %s(%d) TorsoAnim: %s(%d)\n", animTable[la].name, NPC->renderInfo.legsFrame, animTable[ta].name, NPC->client->renderInfo.torsoFrame);
    }
    }*/
}

/// Source: oracle/codemp/game/NPC.c:1764
func NPC_CheckInSolid() {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in
        var point = vec3_t()
        point = NPC!.r.currentOrigin
        point[2] = Float(Double(point[2]) - 0.25)

        trap_Trace(trace, NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, point, NPC!.s.number, NPC!.clipmask)
        if trace.startsolid == 0 && trace.allsolid == 0 {
            NPCInfo!.lastClearOrigin = NPC!.r.currentOrigin
        } else {
            if VectorLengthSquared(NPCInfo!.lastClearOrigin) != 0 {
                //			Com_Printf("%s stuck in solid at %s: fixing...\n", NPC->script_targetname, vtos(NPC->r.currentOrigin));
                G_SetOrigin(NPC!, &NPCInfo!.lastClearOrigin)
                trap_LinkEntity(NPC!)
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC.c:1787
func G_DroidSounds(_ `self`: Entity) {
    if `self`.client != nil {
        //make the noises
        if TIMER_Done(`self`, "patrolNoise") && Q_irand(0, 20) == 0 {
            switch `self`.client!.NPC_class {
            case CLASS_R2D2:
                G_SoundOnEnt(`self`, CHAN_AUTO, va("sound/chars/r2d2/misc/r2d2talk0%d.wav", Q_irand(1, 3)))

            case CLASS_R5D2:
                G_SoundOnEnt(`self`, CHAN_AUTO, va("sound/chars/r5d2/misc/r5talk%d.wav", Q_irand(1, 4)))

            case CLASS_PROBE:
                G_SoundOnEnt(`self`, CHAN_AUTO, va("sound/chars/probe/misc/probetalk%d.wav", Q_irand(1, 3)))

            case CLASS_MOUSE:
                G_SoundOnEnt(`self`, CHAN_AUTO, va("sound/chars/mouse/misc/mousego%d.wav", Q_irand(1, 3)))

            case CLASS_GONK:
                G_SoundOnEnt(`self`, CHAN_AUTO, va("sound/chars/gonk/misc/gonktalk%d.wav", Q_irand(1, 2)))

            default:
                break
            }
            TIMER_Set(`self`, "patrolNoise", Q_irand(2000, 4000))
        }
    }
}

/// Source: oracle/codemp/game/NPC.c:1826
func NPC_Think(_ `self`: Entity) {
    var oldMoveDir = vec3_t()
    var i: Int32 = 0
    var player: Entity?

    `self`.nextthink = level.time + FRAMETIME

    SetNPCGlobals(`self`)

    ucmd.clear()

    oldMoveDir = `self`.client!.ps.moveDir
    if `self`.s.NPC_class != CLASS_VEHICLE {
        //YOU ARE BREAKING MY PREDICTION. Bad clear.
        `self`.client!.ps.moveDir = vec3_t()
    }

    if `self`.NPC == nil || `self`.client == nil {
        return
    }

    // dead NPCs have a special think, don't run scripts (for now)
    //FIXME: this breaks deathscripts
    if `self`.health <= 0 {
        DeadThink()
        if NPCInfo!.nextBStateThink <= level.time {
            trap_ICARUS_MaintainTaskManager(`self`.s.number)
        }
        `self`.client!.ps.origin = `self`.r.currentOrigin
        return
    }

    // see if NPC ai is frozen
    if debugNPCFreeze.value != 0 || (NPC!.r.svFlags & SVF_ICARUS_FREEZE) != 0 {
        NPC_UpdateAngles(true, true)
        ClientThink(`self`.s.number, ucmd)
        //VectorCopy(self->s.origin, self->s.origin2 );
        `self`.client!.ps.origin = `self`.r.currentOrigin
        return
    }

    `self`.nextthink = level.time + FRAMETIME / 2


    while i < MAX_CLIENTS {
        player = g_entities[i]

        if player!.inuse && player!.client != nil && player!.client!.sess.sessionTeam != TEAM_SPECTATOR && !((player!.client!.ps.pm_flags & PMF_FOLLOW) != 0) {
            //if ( player->client->ps.viewEntity == self->s.number )
            if 0 != 0 {
                //being controlled by player
                G_DroidSounds(`self`)
                //FIXME: might want to at least make sounds or something?
                //NPC_UpdateAngles(qtrue, qtrue);
                //Which ucmd should we send?  Does it matter, since it gets overridden anyway?
                NPCInfo!.last_ucmd.serverTime = level.time - 50
                ClientThink(NPC!.s.number, ucmd)
                //VectorCopy(self->s.origin, self->s.origin2 );
                `self`.client!.ps.origin = `self`.r.currentOrigin
                return
            }
        }
        i += 1
    }

    if `self`.client!.NPC_class == CLASS_VEHICLE {
        if `self`.client!.ps.m_iVehicleNum != 0 {
            //we don't think on our own
            //well, run scripts, though...
            trap_ICARUS_MaintainTaskManager(`self`.s.number)
            return
        } else {
            `self`.client!.ps.moveDir = vec3_t()
            `self`.client!.pers.cmd.forwardmove = 0
            `self`.client!.pers.cmd.rightmove = 0
            `self`.client!.pers.cmd.upmove = 0
            `self`.client!.pers.cmd.buttons = 0
            `self`.m_pVehicle!.m_ucmd.copy(from: `self`.client!.pers.cmd)
        }
    } else if NPC!.s.m_iVehicleNum != 0 {
        //droid in a vehicle?
        G_DroidSounds(`self`)
    }

    if NPCInfo!.nextBStateThink <= level.time && NPC!.s.m_iVehicleNum == 0 {
        if NPC!.s.eType != ET_NPC {
            //Something drastic happened in our script
            return
        }

        if NPC!.s.weapon == WP_SABER && g_spskill.integer >= 2 && NPCInfo!.rank > RANK_LT_JG {
            //Jedi think faster on hard difficulty, except low-rank (reborn)
            NPCInfo!.nextBStateThink = level.time + FRAMETIME / 2
        } else {
            //Maybe even 200 ms?
            NPCInfo!.nextBStateThink = level.time + FRAMETIME
        }

        //nextthink is set before this so something in here can override it
        if `self`.s.NPC_class != CLASS_VEHICLE || `self`.m_pVehicle == nil {
            //ok, let's not do this at all for vehicles.
            NPC_ExecuteBState(`self`)
        }
    } else {
        `self`.client!.ps.moveDir = oldMoveDir
        //or use client->pers.lastCommand?
        NPCInfo!.last_ucmd.serverTime = level.time - 50
        if NPC!.next_roff_time == 0 || NPC!.next_roff_time < level.time {
            //If we were following a roff, we don't do normal pmoves.
            //FIXME: firing angles (no aim offset) or regular angles?
            NPC_UpdateAngles(true, true)
            ucmd.copy(from: NPCInfo!.last_ucmd)
            ClientThink(NPC!.s.number, ucmd)
        } else {
            NPC_ApplyRoff()
        }
        //VectorCopy(self->s.origin, self->s.origin2 );
    }
    //must update icarus *every* frame because of certain animation completions in the pmove stuff that can leave a 50ms gap between ICARUS animation commands
    trap_ICARUS_MaintainTaskManager(`self`.s.number)
    `self`.client!.ps.origin = `self`.r.currentOrigin
}

/// Source: oracle/codemp/game/NPC.c:1981
func NPC_InitAI() {
    /*
    trap_Cvar_Register(&g_saberRealisticCombat, "g_saberRealisticCombat", "0", CVAR_CHEAT);

    trap_Cvar_Register(&debugNoRoam, "d_noroam", "0", CVAR_CHEAT);
    trap_Cvar_Register(&debugNPCAimingBeam, "d_npcaiming", "0", CVAR_CHEAT);
    trap_Cvar_Register(&debugBreak, "d_break", "0", CVAR_CHEAT);
    trap_Cvar_Register(&debugNPCAI, "d_npcai", "0", CVAR_CHEAT);
    trap_Cvar_Register(&debugNPCFreeze, "d_npcfreeze", "0", CVAR_CHEAT);
    trap_Cvar_Register(&d_JediAI, "d_JediAI", "0", CVAR_CHEAT);
    trap_Cvar_Register(&d_noGroupAI, "d_noGroupAI", "0", CVAR_CHEAT);
    trap_Cvar_Register(&d_asynchronousGroupAI, "d_asynchronousGroupAI", "0", CVAR_CHEAT);

    //0 = never (BORING)
    //1 = kyle only
    //2 = kyle and last enemy jedi
    //3 = kyle and any enemy jedi
    //4 = kyle and last enemy in a group
    //5 = kyle and any enemy
    //6 = also when kyle takes pain or enemy jedi dodges player saber swing or does an acrobatic evasion

    trap_Cvar_Register(&d_slowmodeath, "d_slowmodeath", "0", CVAR_CHEAT);

    trap_Cvar_Register(&d_saberCombat, "d_saberCombat", "0", CVAR_CHEAT);

    trap_Cvar_Register(&g_spskill, "g_npcspskill", "0", CVAR_ARCHIVE | CVAR_USERINFO);
    */
}

/// Source: oracle/codemp/game/NPC.c:2041
func NPC_InitGame() {
    //	globals.NPCs = (gNPC_t *) gi.TagMalloc(game.maxclients * sizeof(game.bots[0]), TAG_GAME);
    //	trap_Cvar_Register(&debugNPCName, "d_npc", "0", CVAR_CHEAT);

    NPC_LoadParms()
    NPC_InitAI()
    //	NPC_InitAnimTable();
    /*
    ResetTeamCounters();
    for ( int team = NPCTEAM_FREE; team < NPCTEAM_NUM_TEAMS; team++ )
    {
    teamLastEnemyTime[team] = -10000;
    }
    */
}

/// Source: oracle/codemp/game/NPC.c:2058
func NPC_SetAnim(_ ent: Entity, _ setAnimParts: Int32, _ anim: Int32, _ setAnimFlags: Int32) {
    // FIXME : once torsoAnim and legsAnim are in the same structure for NCP and Players
    // rename PM_SETAnimFinal to PM_SetAnim and have both NCP and Players call PM_SetAnim
    G_SetAnim(ent, nil, setAnimParts, anim, setAnimFlags, 0)
    /*
    if(ent->client)
    {//Players, NPCs
    if (setAnimFlags&SETANIM_FLAG_OVERRIDE)
    {
    if (setAnimParts & SETANIM_TORSO)
    {
    if( (setAnimFlags & SETANIM_FLAG_RESTART) || ent->client->ps.torsoAnim != anim )
    {
    PM_SetTorsoAnimTimer( ent, &ent->client->ps.torsoTimer, 0 );
    }
    }
    if (setAnimParts & SETANIM_LEGS)
    {
    if( (setAnimFlags & SETANIM_FLAG_RESTART) || ent->client->ps.legsAnim != anim )
    {
    PM_SetLegsAnimTimer( ent, &ent->client->ps.legsAnimTimer, 0 );
    }
    }
    }

    PM_SetAnimFinal(&ent->client->ps.torsoAnim,&ent->client->ps.legsAnim,setAnimParts,anim,setAnimFlags,
    &ent->client->ps.torsoAnimTimer,&ent->client->ps.legsAnimTimer,ent);
    }
    else
    {//bodies, etc.
    if (setAnimFlags&SETANIM_FLAG_OVERRIDE)
    {
    if (setAnimParts & SETANIM_TORSO)
    {
    if( (setAnimFlags & SETANIM_FLAG_RESTART) || ent->s.torsoAnim != anim )
    {
    PM_SetTorsoAnimTimer( ent, &ent->s.torsoAnimTimer, 0 );
    }
    }
    if (setAnimParts & SETANIM_LEGS)
    {
    if( (setAnimFlags & SETANIM_FLAG_RESTART) || ent->s.legsAnim != anim )
    {
    PM_SetLegsAnimTimer( ent, &ent->s.legsAnimTimer, 0 );
    }
    }
    }

    PM_SetAnimFinal(&ent->s.torsoAnim,&ent->s.legsAnim,setAnimParts,anim,setAnimFlags,
    &ent->s.torsoAnimTimer,&ent->s.legsAnimTimer,ent);
    }
    */
}
