import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

// Source: oracle/codemp/game/g_ICARUScb.c:52
// Raven's `setTable` is C storage in `Sources/CJKAMP_Game/g_tables.c`, and a body reads the public Slots in `Sources/JKAMP_Game/GameTables.swift`.

/// Source: oracle/codemp/game/g_ICARUScb.c:3895
// Raven wrote: char cinematicSkipScript[1024]
nonisolated(unsafe) let cinematicSkipScript: JKAShared.CharBuf = JKAShared.CharBuf(1024)

/// Source: oracle/codemp/game/g_ICARUScb.c:4575
// Raven wrote: qboolean player_locked = qfalse
let player_locked: Bool = { () -> Bool in portMissing("player_locked", source: "oracle/codemp/game/g_ICARUScb.c:4575") }()

/// Source: oracle/codemp/game/g_ICARUScb.c:4933
var textcolor_caption: [Float] {
    get { world.variables.textcolor_caption }
    set { world.variables.textcolor_caption = newValue }
}

/// Source: oracle/codemp/game/g_ICARUScb.c:4934
var textcolor_center: [Float] {
    get { world.variables.textcolor_center }
    set { world.variables.textcolor_center = newValue }
}

/// Source: oracle/codemp/game/g_ICARUScb.c:4935
var textcolor_scroll: [Float] {
    get { world.variables.textcolor_scroll }
    set { world.variables.textcolor_scroll = newValue }
}

/// Source: oracle/codemp/game/g_ICARUScb.c:270
func Q3_TaskIDClear(_ taskID: inout Int32) {
    taskID = -1
}

/// Source: oracle/codemp/game/g_ICARUScb.c:275
func G_DebugPrint(_ level: Int32, _ format: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    //Don't print messages they don't want to see
    //if ( g_ICARUSDebug->integer < level )
    if g_developer.integer != 2 {
        return
    }

    strcpy(&text, JKAShared.format(format, args))

    //Add the color formatting
    switch level {
    case WL_ERROR:
        Com_Printf(S_COLOR_RED + "ERROR: %s", text)

    case WL_WARNING:
        Com_Printf(S_COLOR_YELLOW + "WARNING: %s", text)

    case WL_DEBUG:
        do {
            var entNum: Int32 = 0
            var buffer = TextCursor()

            sscanf(text, "%d", &entNum)

            //if ( ( ICARUS_entFilter >= 0 ) && ( ICARUS_entFilter != entNum ) )
            //	return;

            buffer = TextCursor(text)
            buffer.advance(by: 5)

            if (entNum < 0) || (entNum > MAX_GENTITIES) {
                entNum = 0
            }

            Com_Printf(S_COLOR_BLUE + "DEBUG: %s(%d): %s\n", g_entities[entNum].script_targetname ?? "(null)", entNum, buffer.text)
            break
        }
        fallthrough

    default:
        Com_Printf(S_COLOR_GREEN + "INFO: %s", text)
    }
}

/**
```
-------------------------
Q3_GetAnimLower
-------------------------
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:331
private func Q3_GetAnimLower(_ ent: Entity) -> String? {
    var anim: Int32 = 0

    if ent.client == nil {
        G_DebugPrint(WL_WARNING, "Q3_GetAnimLower: attempted to read animation state off non-client!\n")
        return nil
    }

    anim = ent.client!.ps.legsAnim

    return animTable[anim].name
}

/**
```
-------------------------
Q3_GetAnimUpper
-------------------------
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:351
private func Q3_GetAnimUpper(_ ent: Entity) -> String? {
    var anim: Int32 = 0

    if ent.client == nil {
        G_DebugPrint(WL_WARNING, "Q3_GetAnimUpper: attempted to read animation state off non-client!\n")
        return nil
    }

    anim = ent.client!.ps.torsoAnim

    return animTable[anim].name
}

/**
```
-------------------------
Q3_GetAnimBoth
-------------------------
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:371
private func Q3_GetAnimBoth(_ ent: Entity) -> String? {
    let lowerName: String?
    let upperName: String?

    lowerName = Q3_GetAnimLower(ent)
    upperName = Q3_GetAnimUpper(ent)

    if lowerName == nil || lowerName!.isEmpty {
        G_DebugPrint(WL_WARNING, "Q3_GetAnimBoth: NULL legs animation string found!\n")
        return nil
    }

    if upperName == nil || upperName!.isEmpty {
        G_DebugPrint(WL_WARNING, "Q3_GetAnimBoth: NULL torso animation string found!\n")
        return nil
    }

    if Q_stricmp(lowerName!, upperName!) != 0 {
    }

    return lowerName
}

/// Source: oracle/codemp/game/g_ICARUScb.c:400
public func Q3_PlaySound(_ taskID: Int32, _ entID: Int32, _ name: String, _ channel: String) -> Int32 {
    let ent: Entity? = g_entities[entID]
    var finalName = CharBuf(64)
    var voice_chan: soundChannel_t = CHAN_VOICE
    var type_voice: Bool = false
    let soundHandle: Int32
    var bBroadcast: Bool

    Q_strncpyz(&finalName, name, MAX_QPATH)
    Q_strupr(&finalName)
    //G_AddSexToMunroString( finalName, qtrue );

    COM_StripExtension(String(finalName), &finalName)

    soundHandle = G_SoundIndex(String(finalName))
    bBroadcast = false

    if (Q_stricmp(channel, "CHAN_ANNOUNCER") == 0) || (ent!.classname != nil && Q_stricmp("target_scriptrunner", ent!.classname!) == 0) {
        bBroadcast = true
    }


    // moved here from further down so I can easily check channel-type without code dup...
    //
    if Q_stricmp(channel, "CHAN_VOICE") == 0 {
        voice_chan = CHAN_VOICE
        type_voice = true
    } else if Q_stricmp(channel, "CHAN_VOICE_ATTEN") == 0 {
        voice_chan = CHAN_AUTO //CHAN_VOICE_ATTEN;
        type_voice = true
    } else if Q_stricmp(channel, "CHAN_VOICE_GLOBAL") == 0 {
        voice_chan = CHAN_AUTO //CHAN_VOICE_GLOBAL;
        type_voice = true
        bBroadcast = true
    }

    // if we're in-camera, check for skipping cinematic and ifso, no subtitle print (since screen is not being
    //	updated anyway during skipping). This stops leftover subtitles being left onscreen after unskipping.
    //
    /*
    if (!in_camera ||
    (!g_skippingcin || !g_skippingcin->integer)
    )	// paranoia towards project end <g>
    {
    // Text on
    // certain NPC's we always want to use subtitles regardless of subtitle setting
    if (g_subtitles->integer == 1 || (ent->NPC && (ent->NPC->scriptFlags & SCF_USE_SUBTITLES) ) ) // Show all text
    {
    if ( in_camera)	// Cinematic
    {
    trap_SendServerCommand( -1, va("ct \"%s\" %i", finalName, soundHandle) );
    }
    else //if (precacheWav[i].speaker==SP_NONE)	//  lower screen text
    {
    sharedEntity_t		*ent2 = SV_GentityNum(0);
    // the numbers in here were either the original ones Bob entered (350), or one arrived at from checking the distance Chell stands at in stasis2 by the computer core that was submitted as a bug report...
    //
    if (bBroadcast || (DistanceSquared(ent->currentOrigin, ent2->currentOrigin) < ((voice_chan == CHAN_VOICE_ATTEN)?(350 * 350):(1200 * 1200)) ) )
    {
    trap_SendServerCommand( -1, va("ct \"%s\" %i", finalName, soundHandle) );
    }
    }
    }
    // Cinematic only
    else if (g_subtitles->integer == 2) // Show only talking head text and CINEMATIC
    {
    if ( in_camera)	// Cinematic text
    {
    trap_SendServerCommand( -1, va("ct \"%s\" %i", finalName, soundHandle));
    }
    }

    }
    */

    if type_voice {
        var buf = CharBuf(128)
        var tFVal: Float = 0

        strcpy(&buf, trap_Cvar_VariableStringBuffer("timescale", Int32((buf).count)))

        tFVal = atof(buf)


        if tFVal > 1.0 {
            //Skip the damn sound!
            return 1
        } else {
            //This the voice channel
            G_Sound(ent!, voice_chan, G_SoundIndex(String(finalName)))
        }
        //Remember we're waiting for this
        trap_ICARUS_TaskIDSet(ent!, TID_CHAN_VOICE, taskID)

        return 0
    }

    if bBroadcast {
        //Broadcast the sound
        var te: Entity?

        te = G_TempEntity(ent!.r.currentOrigin, EV_GLOBAL_SOUND)
        te!.s.eventParm = soundHandle
        te!.r.svFlags |= SVF_BROADCAST
    } else {
        G_Sound(ent!, CHAN_AUTO, soundHandle)
    }

    return 1
}

/**
```
-------------------------
Q3_Play
-------------------------
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:527
public func Q3_Play(_ taskID: Int32, _ entID: Int32, _ type: String, _ name: String) {
    let ent: Entity? = g_entities[entID]

    if Q_stricmp(type, "PLAY_ROFF") == 0 {
        // Try to load the requested ROFF
        ent!.roffid = trap_ROFF_Cache(name)
        if ent!.roffid != 0 {
            ent!.roffname = G_NewString(name)

            // Start the roff from the beginning
            //ent->roff_ctr = 0;

            //Save this off for later
            trap_ICARUS_TaskIDSet(ent!, TID_MOVE_NAV, taskID)

            // Let the ROFF playing start.
            //ent->next_roff_time = level.time;

            //rww - Maybe use pos1 and pos2? I don't think we need to care if these values are sent across the net.
            // These need to be initialised up front...
            //VectorCopy( ent->r.currentOrigin, ent->pos1 );
            //VectorCopy( ent->r.currentAngles, ent->pos2 );
            ent!.s.origin2 = ent!.r.currentOrigin
            ent!.s.angles2 = ent!.r.currentAngles

            trap_LinkEntity(ent!)

            trap_ROFF_Play(ent!.s.number, ent!.roffid, true)
        }
    }
}

/**
```
=============
anglerCallback

Utility function
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:569
func anglerCallback(_ ent: Entity) {
    //Complete the task
    trap_ICARUS_TaskIDComplete(ent, TID_ANGLE_FACE)

    //Set the currentAngles, clear all movement
    _VectorMA(ent.s.apos.trBase, (ent.s.apos.trDuration * 0.001), ent.s.apos.trDelta, &ent.r.currentAngles)
    ent.s.apos.trBase = ent.r.currentAngles
    ent.s.apos.trDelta = vec3_t()
    ent.s.apos.trDuration = 1
    ent.s.apos.trType = TR_STATIONARY
    ent.s.apos.trTime = level.time

    //Stop thinking
    ent.reached = nil
    if ent.think == Think.anglerCallback {
        ent.think = nil
    }

    //link
    trap_LinkEntity(ent)
}

/**
```
=============
moverCallback

Utility function
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:603
func moverCallback(_ ent: Entity) {
    //complete the task
    trap_ICARUS_TaskIDComplete(ent, TID_MOVE_NAV)

    // play sound
    ent.s.loopSound = 0 //stop looping sound
    ent.s.loopIsSoundset = false
    G_PlayDoorSound(ent, BMS_END) //play end sound

    if ent.moverState == MOVER_1TO2 {
        //reached open
        // reached pos2
        MatchTeam(ent, MOVER_POS2, level.time)
        //SetMoverState( ent, MOVER_POS2, level.time );
    } else if ent.moverState == MOVER_2TO1 {
        //reached closed
        MatchTeam(ent, MOVER_POS1, level.time)
        //SetMoverState( ent, MOVER_POS1, level.time );
    }

    if ent.blocked == Blocked.Blocked_Mover {
        ent.blocked = nil
    }

    //	if ( !Q_stricmp( "misc_model_breakable", ent->classname ) && ent->physicsBounce )
    //	{//a gravity-affected model
    //		misc_model_breakable_gravity_init( ent, qfalse );
    //	}
}

/// Source: oracle/codemp/game/g_ICARUScb.c:635
func Blocked_Mover(_ ent: Entity, _ other: Entity) {
    // remove anything other than a client -- no longer the case

    // don't remove security keys or goodie keys
    if (other.s.eType == ET_ITEM) {
        // should we be doing anything special if a key blocks it... move it somehow..?
    } else if other.s.number != 0 && (other.client == nil || (other.client != nil && other.health <= 0 && other.r.contents == CONTENTS_CORPSE && other.message == nil)) {
        // if your not a client, or your a dead client remove yourself...
        //if ( !other->taskManager || !other->taskManager->IsRunning() )
        do {
            // if an item or weapon can we do a little explosion..?
            G_FreeEntity(other)
            return
        }
    }

    if ent.damage != 0 {
        var dir: vec3_t? = nil
        G_Damage(other, ent, ent, &dir, nil, ent.damage, 0, MOD_CRUSH)
    }
}

/**
```
=============
moveAndRotateCallback

Utility function
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:667
func moveAndRotateCallback(_ ent: Entity) {
    //stop turning
    anglerCallback(ent)
    //stop moving
    moverCallback(ent)
}

/**
```
=============
Q3_Lerp2Start

Lerps the origin of an entity to its starting position
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:682
public func Q3_Lerp2Start(_ entID: Int32, _ taskID: Int32, _ duration: Float) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_Lerp2Start: invalid entID %d\n", entID)
        return
    }

    if ent!.client != nil || Q_stricmp(ent!.classname!, "target_scriptrunner") == 0 {
        G_DebugPrint(WL_ERROR, "Q3_Lerp2Start: ent %d is NOT a mover!\n", entID)
        return
    }

    if ent!.s.eType != ET_MOVER {
        ent!.s.eType = ET_MOVER
    }

    //FIXME: set up correctly!!!
    ent!.moverState = MOVER_2TO1
    ent!.s.eType = ET_MOVER
    ent!.reached = Reached.moverCallback //Callsback the the completion of the move
    if ent!.damage != 0 {
        ent!.blocked = Blocked.Blocked_Mover
    }

    ent!.s.pos.trDuration = Int32(duration * 10) //In seconds
    ent!.s.pos.trTime = level.time

    trap_ICARUS_TaskIDSet(ent!, TID_MOVE_NAV, taskID)
    // starting sound
    G_PlayDoorLoopSound(ent!)
    G_PlayDoorSound(ent!, BMS_START) //??

    trap_LinkEntity(ent!)
}

/**
```
=============
Q3_Lerp2End

Lerps the origin of an entity to its ending position
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:730
public func Q3_Lerp2End(_ entID: Int32, _ taskID: Int32, _ duration: Float) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_Lerp2End: invalid entID %d\n", entID)
        return
    }

    if ent!.client != nil || Q_stricmp(ent!.classname!, "target_scriptrunner") == 0 {
        G_DebugPrint(WL_ERROR, "Q3_Lerp2End: ent %d is NOT a mover!\n", entID)
        return
    }

    if ent!.s.eType != ET_MOVER {
        ent!.s.eType = ET_MOVER
    }

    //FIXME: set up correctly!!!
    ent!.moverState = MOVER_1TO2
    ent!.s.eType = ET_MOVER
    ent!.reached = Reached.moverCallback //Callsback the the completion of the move
    if ent!.damage != 0 {
        ent!.blocked = Blocked.Blocked_Mover
    }

    ent!.s.pos.trDuration = Int32(duration * 10) //In seconds
    ent!.s.time = level.time

    trap_ICARUS_TaskIDSet(ent!, TID_MOVE_NAV, taskID)
    // starting sound
    G_PlayDoorLoopSound(ent!)
    G_PlayDoorSound(ent!, BMS_START) //??

    trap_LinkEntity(ent!)
}

/**
```
=============
Q3_Lerp2Pos

Lerps the origin and angles of an entity to the destination values

=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:781
public func Q3_Lerp2Pos(_ taskID: Int32, _ entID: Int32, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t?, _ duration: Float) {
    let ent: Entity? = g_entities[entID]
    var ang = vec3_t()
    var i: Int32
    var moverState: moverState_t
    // Raven assigns his own `duration` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var duration = duration

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_Lerp2Pos: invalid entID %d\n", entID)
        return
    }

    if ent!.client != nil || Q_stricmp(ent!.classname!, "target_scriptrunner") == 0 {
        G_DebugPrint(WL_ERROR, "Q3_Lerp2Pos: ent %d is NOT a mover!\n", entID)
        return
    }

    if ent!.s.eType != ET_MOVER {
        ent!.s.eType = ET_MOVER
    }

    //Don't allow a zero duration
    if duration == 0 {
        duration = 1
    }

    //
    // Movement

    moverState = ent!.moverState

    if moverState == MOVER_POS1 || moverState == MOVER_2TO1 {
        ent!.pos1 = ent!.r.currentOrigin
        ent!.pos2 = origin

        moverState = MOVER_1TO2
    } else {
        ent!.pos2 = ent!.r.currentOrigin
        ent!.pos1 = origin

        moverState = MOVER_2TO1
    }

    InitMoverTrData(ent!)

    ent!.s.pos.trDuration = Int32(duration)

    // start it going
    MatchTeam(ent!, moverState, level.time)
    //SetMoverState( ent, moverState, level.time );

    //Only do the angles if specified
    if angles! != nil {
        //
        // Rotation

        i = 0
        while i < 3 {
            ang[i] = AngleDelta(angles![i], ent!.r.currentAngles[i])
            ent!.s.apos.trDelta[i] = (ang[i] / (duration * 0.001))
            i += 1
        }

        ent!.s.apos.trBase = ent!.r.currentAngles

        if ent!.alt_fire {
            ent!.s.apos.trType = TR_LINEAR_STOP
        } else {
            ent!.s.apos.trType = TR_NONLINEAR_STOP
        }
        ent!.s.apos.trDuration = Int32(duration)

        ent!.s.apos.trTime = level.time

        ent!.reached = Reached.moveAndRotateCallback
        trap_ICARUS_TaskIDSet(ent!, TID_ANGLE_FACE, taskID)
    } else {
        //Setup the last bits of information
        ent!.reached = Reached.moverCallback
    }

    if ent!.damage != 0 {
        ent!.blocked = Blocked.Blocked_Mover
    }

    trap_ICARUS_TaskIDSet(ent!, TID_MOVE_NAV, taskID)
    // starting sound
    G_PlayDoorLoopSound(ent!)
    G_PlayDoorSound(ent!, BMS_START) //??

    trap_LinkEntity(ent!)
}

/**
```
=============
Q3_LerpAngles

Lerps the angles to the destination value
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:892
public func Q3_Lerp2Angles(_ taskID: Int32, _ entID: Int32, _ angles: JKAShared.vec3_t, _ duration: Float) {
    let ent: Entity? = g_entities[entID]
    var ang = vec3_t()
    var i: Int32

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_Lerp2Angles: invalid entID %d\n", entID)
        return
    }

    if ent!.client != nil || Q_stricmp(ent!.classname!, "target_scriptrunner") == 0 {
        G_DebugPrint(WL_ERROR, "Q3_Lerp2Angles: ent %d is NOT a mover!\n", entID)
        return
    }

    //If we want an instant move, don't send 0...
    ent!.s.apos.trDuration = Int32((duration > 0) ? duration : 1)

    i = 0
    while i < 3 {
        ang[i] = AngleSubtract(angles[i], ent!.r.currentAngles[i])
        ent!.s.apos.trDelta[i] = (ang[i] / (ent!.s.apos.trDuration * 0.001))
        i += 1
    }

    ent!.s.apos.trBase = ent!.r.currentAngles

    if ent!.alt_fire {
        ent!.s.apos.trType = TR_LINEAR_STOP
    } else {
        ent!.s.apos.trType = TR_NONLINEAR_STOP
    }

    ent!.s.apos.trTime = level.time

    trap_ICARUS_TaskIDSet(ent!, TID_ANGLE_FACE, taskID)

    //ent->e_ReachedFunc = reachedF_NULL;
    ent!.think = Think.anglerCallback
    ent!.nextthink = Int32(level.time + duration)

    trap_LinkEntity(ent!)
}

/**
```
=============
Q3_GetTag

Gets the value of a tag by the give name
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:948
public func Q3_GetTag(_ entID: Int32, _ name: String, _ lookup: Int32, _ info: inout JKAShared.vec3_t) -> Int32 {
    let ent: Entity? = g_entities[entID]

    if !ent!.inuse {
        return 0
    }

    switch lookup {
    case TYPE_ORIGIN:
        return TAG_GetOrigin(ent!.ownername!, name, &info)

    case TYPE_ANGLES:
        return TAG_GetAngles(ent!.ownername!, name, &info)

    default:
        break
    }

    return 0
}

/**
```
============
Q3_Use

Uses an entity
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:981
public func Q3_Use(_ entID: Int32, _ target: String) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_Use: invalid entID %d\n", entID)
        return
    }

    if target.isEmpty {
        G_DebugPrint(WL_WARNING, "Q3_Use: string is NULL!\n")
        return
    }

    G_UseTargets2(ent!, ent!, target)
}

/**
```
============
Q3_Kill
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: const char *name
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1009
public func Q3_Kill(_ entID: Int32, _ name: String) {
    let ent: Entity? = g_entities[entID]
    var victim: Entity? = nil
    let o_health: Int32

    if Q_stricmp(name, "self") == 0 {
        victim = ent
    } else if Q_stricmp(name, "enemy") == 0 {
        victim = ent!.enemy
    } else {
    }

    if victim == nil {
        G_DebugPrint(WL_WARNING, "Q3_Kill: can't find %s\n", name)
        return
    }

    //rww - I guess this would only apply to NPCs anyway. I'm not going to bother.
    //if ( victim == ent )
    //{//don't ICARUS_FreeEnt me, I'm in the middle of a script!  (FIXME: shouldn't ICARUS handle this internally?)
    //	victim->svFlags |= SVF_KILLED_SELF;
    //}

    o_health = victim!.health
    victim!.health = 0
    if victim!.client != nil {
        victim!.flags |= FL_NO_KNOCKBACK
    }
    //G_SetEnemy(victim, ent);
    if victim!.die != nil {
        //GEntity_DieFunc( victim, NULL, NULL, o_health, MOD_UNKNOWN );
        victim!.runDie(victim, victim, o_health, MOD_UNKNOWN)
    }
}

/**
```
============
Q3_RemoveEnt
  Description	:
  Return type	: void
  Argument		: sharedEntity_t *victim
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1062
func Q3_RemoveEnt(_ victim: Entity) {
    if victim.client != nil {
        if victim.s.eType != ET_NPC {
            G_DebugPrint(WL_WARNING, "Q3_RemoveEnt: You can't remove clients in MP!\n")
            //can't remove clients in MP
        } else {
            //remove the NPC
            if victim.client!.NPC_class == CLASS_VEHICLE {
                //eject everyone out of a vehicle that's about to remove itself
                let pVeh: Vehicle? = victim.m_pVehicle
                if pVeh != nil && pVeh!.m_pVehicleInfo != nil {
                    pVeh!.m_pVehicleInfo!.runEjectAll(pVeh)
                }
            }
            victim.think = Think.G_FreeEntity
            victim.nextthink = level.time + 100
        }
        /*
        //ClientDisconnect(ent);
        victim->s.eFlags |= EF_NODRAW;
        victim->s.eType = ET_INVISIBLE;
        victim->contents = 0;
        victim->health = 0;
        victim->targetname = NULL;

        if ( victim->NPC && victim->NPC->tempGoal != NULL )
        {
        G_FreeEntity( victim->NPC->tempGoal );
        victim->NPC->tempGoal = NULL;
        }
        if ( victim->client->ps.saberEntityNum != ENTITYNUM_NONE && victim->client->ps.saberEntityNum > 0 )
        {
        if ( g_entities[victim->client->ps.saberEntityNum].inuse )
        {
        G_FreeEntity( &g_entities[victim->client->ps.saberEntityNum] );
        }
        victim->client->ps.saberEntityNum = ENTITYNUM_NONE;
        }
        //Disappear in half a second
        victim->e_ThinkFunc = thinkF_G_FreeEntity;
        victim->nextthink = level.time + 500;
        return;
        */
    } else {
        victim.think = Think.G_FreeEntity
        victim.nextthink = level.time + 100
    }
}

/**
```
============
Q3_Remove
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: const char *name
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1128
public func Q3_Remove(_ entID: Int32, _ name: String) {
    let ent: Entity? = g_entities[entID]
    var victim: Entity? = nil

    if Q_stricmp("self", name) == 0 {
        victim = ent
        if victim == nil {
            G_DebugPrint(WL_WARNING, "Q3_Remove: can't find %s\n", name)
            return
        }
        Q3_RemoveEnt(victim!)
    } else if Q_stricmp("enemy", name) == 0 {
        victim = ent!.enemy
        if victim == nil {
            G_DebugPrint(WL_WARNING, "Q3_Remove: can't find %s\n", name)
            return
        }
        Q3_RemoveEnt(victim!)
    } else {
        if victim == nil {
            G_DebugPrint(WL_WARNING, "Q3_Remove: can't find %s\n", name)
            return
        }

        while victim != nil {
            Q3_RemoveEnt(victim!)
        }
    }
}

/**
```
============
Q3_GetFloat
  Description	:
  Return type	: int
  Argument		:  int entID
  Argument		: int type
  Argument		: const char *name
  Argument		: float *value
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1189
public func Q3_GetFloat(_ entID: Int32, _ type: Int32, _ name: String, _ value: inout Float) -> Int32 {
    let ent: Entity? = g_entities[entID]
    var toGet: Int32 = 0

    if ent == nil {
        return 0
    }

    toGet = GetIDForString(setTable, name) //FIXME: May want to make a "getTable" as well
    //FIXME: I'm getting really sick of these huge switch statements!

    //NOTENOTE: return true if the value was correctly obtained
    switch toGet {
    case SET_PARM1, SET_PARM2, SET_PARM3, SET_PARM4, SET_PARM5, SET_PARM6, SET_PARM7, SET_PARM8, SET_PARM9, SET_PARM10, SET_PARM11, SET_PARM12, SET_PARM13, SET_PARM14, SET_PARM15, SET_PARM16:
        if ent!.parms == nil {
            G_DebugPrint(WL_ERROR, "GET_PARM: %s %s did not have any parms set!\n", ent!.classname!, ent!.targetname!)
            return 0 // would prefer qfalse, but I'm fitting in with what's here <sigh>
        }
        value = atof(ent!.parms!.parm[toGet - SET_PARM1])

    case SET_COUNT:
        value = Float(ent!.count)

    case SET_HEALTH:
        value = Float(ent!.health)

    case SET_SKILL:
        return 0

    case SET_XVELOCITY:
        if ent!.client == nil {
            G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_XVELOCITY, %s not a client\n", ent!.targetname!)
            return 0
        }
        value = ent!.client!.ps.velocity[0]

    case SET_YVELOCITY:
        if ent!.client == nil {
            G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_YVELOCITY, %s not a client\n", ent!.targetname!)
            return 0
        }
        value = ent!.client!.ps.velocity[1]

    case SET_ZVELOCITY:
        if ent!.client == nil {
            G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_ZVELOCITY, %s not a client\n", ent!.targetname!)
            return 0
        }
        value = ent!.client!.ps.velocity[2]

    case SET_Z_OFFSET:
        value = ent!.r.currentOrigin[2] - ent!.s.origin[2]

    case SET_DPITCH:
        return 0

    case SET_DYAW:
        return 0

    case SET_WIDTH:
        value = ent!.r.mins[0]

    case SET_TIMESCALE:
        return 0

    case SET_CAMERA_GROUP_Z_OFS:
        return 0

    case SET_VISRANGE:
        return 0

    case SET_EARSHOT:
        return 0

    case SET_VIGILANCE:
        return 0

    case SET_GRAVITY:
        value = g_gravity.value

    case SET_FACEEYESCLOSED, SET_FACEEYESOPENED, SET_FACEAUX, SET_FACEBLINK, SET_FACEBLINKFROWN, SET_FACEFROWN, SET_FACENORMAL:
        G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_FACE___ not implemented\n")
        return 0

    case SET_WAIT:
        value = ent!.wait

    case SET_FOLLOWDIST:
        return 0
        //# #sep ints

    case SET_ANIM_HOLDTIME_LOWER:
        if ent!.client == nil {
            G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_ANIM_HOLDTIME_LOWER, %s not a client\n", ent!.targetname!)
            return 0
        }
        value = Float(ent!.client!.ps.legsTimer)

    case SET_ANIM_HOLDTIME_UPPER:
        if ent!.client == nil {
            G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_ANIM_HOLDTIME_UPPER, %s not a client\n", ent!.targetname!)
            return 0
        }
        value = Float(ent!.client!.ps.torsoTimer)

    case SET_ANIM_HOLDTIME_BOTH:
        G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_ANIM_HOLDTIME_BOTH not implemented\n")
        return 0

    case SET_ARMOR:
        if ent!.client == nil {
            G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_ARMOR, %s not a client\n", ent!.targetname!)
            return 0
        }
        value = Float(ent!.client!.ps.stats[STAT_ARMOR])

    case SET_WALKSPEED:
        return 0

    case SET_RUNSPEED:
        return 0

    case SET_YAWSPEED:
        return 0

    case SET_AGGRESSION:
        return 0

    case SET_AIM:
        return 0

    case SET_FRICTION:
        return 0

    case SET_SHOOTDIST:
        return 0

    case SET_HFOV:
        return 0

    case SET_VFOV:
        return 0

    case SET_DELAYSCRIPTTIME:
        return 0

    case SET_FORWARDMOVE:
        return 0

    case SET_RIGHTMOVE:
        return 0

    case SET_STARTFRAME:
        return 0

    case SET_ENDFRAME:
        return 0

    case SET_ANIMFRAME:
        return 0

    case SET_SHOT_SPACING:
        return 0

    case SET_MISSIONSTATUSTIME:
        return 0
        //# #sep booleans

    case SET_IGNOREPAIN:
        return 0

    case SET_IGNOREENEMIES:
        return 0

    case SET_IGNOREALERTS:
        return 0

    case SET_DONTSHOOT:
        return 0

    case SET_NOTARGET:
        value = Float((ent!.flags & FL_NOTARGET))

    case SET_DONTFIRE:
        return 0

    case SET_LOCKED_ENEMY:
        return 0

    case SET_CROUCHED:
        return 0

    case SET_WALKING:
        return 0

    case SET_RUNNING:
        return 0

    case SET_CHASE_ENEMIES:
        return 0

    case SET_LOOK_FOR_ENEMIES:
        return 0

    case SET_FACE_MOVE_DIR:
        return 0

    case SET_FORCED_MARCH:
        return 0

    case SET_UNDYING:
        return 0

    case SET_NOAVOID:
        return 0

    case SET_SOLID:
        value = Float(ent!.r.contents)

    case SET_PLAYER_USABLE:
        value = Float((ent!.r.svFlags & SVF_PLAYER_USABLE))

    case SET_LOOP_ANIM:
        return 0

    case SET_INTERFACE:
        G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_INTERFACE not implemented\n")
        return 0

    case SET_SHIELDS:
        return 0

    case SET_INVISIBLE:
        value = Float((ent!.s.eFlags & EF_NODRAW))

    case SET_VAMPIRE:
        return 0

    case SET_FORCE_INVINCIBLE:
        return 0

    case SET_GREET_ALLIES:
        return 0

    case SET_VIDEO_FADE_IN:
        G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_VIDEO_FADE_IN not implemented\n")
        return 0

    case SET_VIDEO_FADE_OUT:
        G_DebugPrint(WL_WARNING, "Q3_GetFloat: SET_VIDEO_FADE_OUT not implemented\n")
        return 0

    case SET_PLAYER_LOCKED:
        return 0

    case SET_LOCK_PLAYER_WEAPONS:
        return 0

    case SET_NO_IMPACT_DAMAGE:
        return 0

    case SET_NO_KNOCKBACK:
        value = Float((ent!.flags & FL_NO_KNOCKBACK))

    case SET_ALT_FIRE:
        return 0

    case SET_NO_RESPONSE:
        return 0

    case SET_INVINCIBLE:
        value = Float((ent!.flags & FL_GODMODE))

    case SET_MISSIONSTATUSACTIVE:
        return 0

    case SET_NO_COMBAT_TALK:
        return 0

    case SET_NO_ALERT_TALK:
        return 0

    case SET_USE_CP_NEAREST:
        return 0

    case SET_DISMEMBERABLE:
        return 0

    case SET_NO_FORCE:
        return 0

    case SET_NO_ACROBATICS:
        return 0

    case SET_USE_SUBTITLES:
        return 0

    case SET_NO_FALLTODEATH:
        return 0

    case SET_MORELIGHT:
        return 0

    case SET_TREASONED:
        return 0

    case SET_DISABLE_SHADER_ANIM:
        return 0

    case SET_SHADER_ANIM:
        return 0

    default:
        if trap_ICARUS_VariableDeclared(name) != VTYPE_FLOAT {
            return 0
        }

        return trap_ICARUS_GetFloatVariable(name, &value)
    }

    return 1
}

/**
```
============
Q3_GetVector
  Description	:
  Return type	: int
  Argument		:  int entID
  Argument		: int type
  Argument		: const char *name
  Argument		: vec3_t value
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1573
public func Q3_GetVector(_ entID: Int32, _ type: Int32, _ name: String, _ value: inout JKAShared.vec3_t) -> Int32 {
    let ent: Entity? = g_entities[entID]
    var toGet: Int32 = 0
    if ent == nil {
        return 0
    }

    toGet = GetIDForString(setTable, name) //FIXME: May want to make a "getTable" as well
    //FIXME: I'm getting really sick of these huge switch statements!

    //NOTENOTE: return true if the value was correctly obtained
    switch toGet {
    case SET_PARM1, SET_PARM2, SET_PARM3, SET_PARM4, SET_PARM5, SET_PARM6, SET_PARM7, SET_PARM8, SET_PARM9, SET_PARM10, SET_PARM11, SET_PARM12, SET_PARM13, SET_PARM14, SET_PARM15, SET_PARM16:
        sscanf(ent!.parms!.parm[toGet - SET_PARM1], "%f %f %f", &value)

    case SET_ORIGIN:
        value = ent!.r.currentOrigin

    case SET_ANGLES:
        value = ent!.r.currentAngles

    case SET_TELEPORT_DEST:
        G_DebugPrint(WL_WARNING, "Q3_GetVector: SET_TELEPORT_DEST not implemented\n")
        return 0

    default:
        if trap_ICARUS_VariableDeclared(name) != VTYPE_VECTOR {
            return 0
        }

        return trap_ICARUS_GetVectorVariable(name, value)
    }

    return 1
}

/**
```
============
Q3_GetString
  Description	:
  Return type	: int
  Argument		:  int entID
  Argument		: int type
  Argument		: const char *name
  Argument		: char **value
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1642
public func Q3_GetString(_ entID: Int32, _ type: Int32, _ name: String, _ value: inout String) -> Int32 {
    let ent: Entity? = g_entities[entID]
    var toGet: Int32 = 0
    if ent == nil {
        return 0
    }

    toGet = GetIDForString(setTable, name) //FIXME: May want to make a "getTable" as well

    switch toGet {
    case SET_ANIM_BOTH:
        guard let text = Q3_GetAnimBoth(ent!) else { return 0 }
        value = text

    case SET_PARM1, SET_PARM2, SET_PARM3, SET_PARM4, SET_PARM5, SET_PARM6, SET_PARM7, SET_PARM8, SET_PARM9, SET_PARM10, SET_PARM11, SET_PARM12, SET_PARM13, SET_PARM14, SET_PARM15, SET_PARM16:
        if ent!.parms != nil {
            value = ent!.parms!.parm[toGet - SET_PARM1]
        } else {
            G_DebugPrint(WL_WARNING, "Q3_GetString: invalid ent %s has no parms!\n", ent!.targetname!)
            return 0
        }

    case SET_TARGET:
        value = ent!.target!

    case SET_LOCATION:
        return 0
        //# #sep Scripts and other file paths

    case SET_SPAWNSCRIPT:
        value = ent!.behaviorSet[BSET_SPAWN]!

    case SET_USESCRIPT:
        value = ent!.behaviorSet[BSET_USE]!

    case SET_AWAKESCRIPT:
        value = ent!.behaviorSet[BSET_AWAKE]!

    case SET_ANGERSCRIPT:
        value = ent!.behaviorSet[BSET_ANGER]!

    case SET_ATTACKSCRIPT:
        value = ent!.behaviorSet[BSET_ATTACK]!

    case SET_VICTORYSCRIPT:
        value = ent!.behaviorSet[BSET_VICTORY]!

    case SET_LOSTENEMYSCRIPT:
        value = ent!.behaviorSet[BSET_LOSTENEMY]!

    case SET_PAINSCRIPT:
        value = ent!.behaviorSet[BSET_PAIN]!

    case SET_FLEESCRIPT:
        value = ent!.behaviorSet[BSET_FLEE]!

    case SET_DEATHSCRIPT:
        value = ent!.behaviorSet[BSET_DEATH]!

    case SET_DELAYEDSCRIPT:
        value = ent!.behaviorSet[BSET_DELAYED]!

    case SET_BLOCKEDSCRIPT:
        value = ent!.behaviorSet[BSET_BLOCKED]!

    case SET_FFIRESCRIPT:
        value = ent!.behaviorSet[BSET_FFIRE]!

    case SET_FFDEATHSCRIPT:
        value = ent!.behaviorSet[BSET_FFDEATH]!
        //# #sep Standard strings

    case SET_ENEMY:
        return 0

    case SET_LEADER:
        return 0

    case SET_CAPTURE:
        return 0

    case SET_TARGETNAME:
        value = ent!.targetname!

    case SET_PAINTARGET:
        return 0

    case SET_CAMERA_GROUP:
        return 0

    case SET_CAMERA_GROUP_TAG:
        return 0

    case SET_LOOK_TARGET:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_LOOK_TARGET, NOT SUPPORTED IN MULTIPLAYER\n")

    case SET_TARGET2:
        return 0

    case SET_REMOVE_TARGET:
        return 0

    case SET_WEAPON:
        return 0

    case SET_ITEM:
        return 0

    case SET_MUSIC_STATE:
        return 0
        //The below cannot be gotten

    case SET_NAVGOAL:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_NAVGOAL not implemented\n")
        return 0

    case SET_VIEWTARGET:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_VIEWTARGET not implemented\n")
        return 0

    case SET_WATCHTARGET:
        return 0

    case SET_VIEWENTITY:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_VIEWENTITY not implemented\n")
        return 0

    case SET_CAPTIONTEXTCOLOR:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_CAPTIONTEXTCOLOR not implemented\n")
        return 0

    case SET_CENTERTEXTCOLOR:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_CENTERTEXTCOLOR not implemented\n")
        return 0

    case SET_SCROLLTEXTCOLOR:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_SCROLLTEXTCOLOR not implemented\n")
        return 0

    case SET_COPY_ORIGIN:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_COPY_ORIGIN not implemented\n")
        return 0

    case SET_DEFEND_TARGET:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_COPY_ORIGIN not implemented\n")
        return 0

    case SET_VIDEO_PLAY:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_VIDEO_PLAY not implemented\n")
        return 0

    case SET_LOADGAME:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_LOADGAME not implemented\n")
        return 0

    case SET_LOCKYAW:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_LOCKYAW not implemented\n")
        return 0

    case SET_SCROLLTEXT:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_SCROLLTEXT not implemented\n")
        return 0

    case SET_LCARSTEXT:
        G_DebugPrint(WL_WARNING, "Q3_GetString: SET_LCARSTEXT not implemented\n")
        return 0

    case SET_FULLNAME:
        value = ent!.fullName!

    default:
        if trap_ICARUS_VariableDeclared(name) != VTYPE_STRING {
            return 0
        }

        return trap_ICARUS_GetStringVariable(name, value)
    }

    return 1
}

/// Source: oracle/codemp/game/g_ICARUScb.c:1865
func MoveOwner(_ `self`: Entity) {
    let owner: Entity? = g_entities[`self`.r.ownerNum]

    `self`.nextthink = level.time + FRAMETIME
    `self`.think = Think.G_FreeEntity

    if owner == nil || !owner!.inuse {
        return
    }

    if SpotWouldTelefrag2(owner!, `self`.r.currentOrigin) {
        `self`.think = Think.MoveOwner
    } else {
        G_SetOrigin(owner!, &`self`.r.currentOrigin)
        trap_ICARUS_TaskIDComplete(owner!, TID_MOVE_NAV)
    }
}

/**
```
=============
Q3_SetTeleportDest

Copies passed origin to ent running script once there is nothing there blocking the spot
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1895
private func Q3_SetTeleportDest(_ entID: Int32, _ org: inout JKAShared.vec3_t) -> Bool {
    let teleEnt: Entity? = g_entities[entID]

    if teleEnt != nil {
        if SpotWouldTelefrag2(teleEnt!, org) {
            let teleporter: Entity? = G_Spawn()

            G_SetOrigin(teleporter!, &org)
            teleporter!.r.ownerNum = teleEnt!.s.number

            teleporter!.think = Think.MoveOwner
            teleporter!.nextthink = level.time + FRAMETIME

            return false
        } else {
            G_SetOrigin(teleEnt!, &org)
        }
    }

    return true
}

/**
```
=============
Q3_SetOrigin

Sets the origin of an entity directly
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1929
private func Q3_SetOrigin(_ entID: Int32, _ origin: inout JKAShared.vec3_t) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetOrigin: bad ent %d\n", entID)
        return
    }

    trap_UnlinkEntity(ent!)

    if ent!.client != nil {
        ent!.client!.ps.origin = origin
        ent!.r.currentOrigin = origin
        ent!.client!.ps.origin[2] += 1

        ent!.client!.ps.velocity = vec3_t()
        ent!.client!.ps.pm_time = 160 // hold time
        ent!.client!.ps.pm_flags |= PMF_TIME_KNOCKBACK

        ent!.client!.ps.eFlags ^= EF_TELEPORT_BIT

        //		G_KillBox (ent);
    } else {
        G_SetOrigin(ent!, &origin)
    }

    trap_LinkEntity(ent!)
}

/**
```
=============
Q3_SetCopyOrigin

Copies origin of found ent into ent running script
=============`
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1970
private func Q3_SetCopyOrigin(_ entID: Int32, _ name: String) {
    var found: Entity?

    if found != nil {
        Q3_SetOrigin(entID, &found!.r.currentOrigin)
        SetClientViewAngle(g_entities[entID], found!.s.angles)
    } else {
        G_DebugPrint(WL_WARNING, "Q3_SetCopyOrigin: ent %s not found!\n", name)
    }
}

/**
```
=============
Q3_SetVelocity

Set the velocity of an entity directly
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:1992
private func Q3_SetVelocity(_ entID: Int32, _ axis: Int32, _ speed: Float) {
    let found: Entity? = g_entities[entID]
    //FIXME: Not supported
    if found == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetVelocity invalid entID %d\n", entID)
        return
    }

    if found!.client == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetVelocity: not a client %d\n", entID)
        return
    }

    //FIXME: add or set?
    found!.client!.ps.velocity[axis] += speed

    found!.client!.ps.pm_time = 500
    found!.client!.ps.pm_flags |= PMF_TIME_KNOCKBACK
}

/**
```
=============
Q3_SetAngles

Sets the angles of an entity directly
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2022
private func Q3_SetAngles(_ entID: Int32, _ angles: JKAShared.vec3_t) {
    let ent: Entity? = g_entities[entID]


    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetAngles: bad ent %d\n", entID)
        return
    }

    if ent!.client != nil {
        SetClientViewAngle(ent!, angles)
    } else {
        ent!.s.angles = angles
    }
    trap_LinkEntity(ent!)
}

/**
```
=============
Q3_Lerp2Origin

Lerps the origin to the destination value
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2051
public func Q3_Lerp2Origin(_ taskID: Int32, _ entID: Int32, _ origin: JKAShared.vec3_t, _ duration: Float) {
    let ent: Entity? = g_entities[entID]
    var moverState: moverState_t

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_Lerp2Origin: invalid entID %d\n", entID)
        return
    }

    if ent!.client != nil || Q_stricmp(ent!.classname!, "target_scriptrunner") == 0 {
        G_DebugPrint(WL_ERROR, "Q3_Lerp2Origin: ent %d is NOT a mover!\n", entID)
        return
    }

    if ent!.s.eType != ET_MOVER {
        ent!.s.eType = ET_MOVER
    }

    moverState = ent!.moverState

    if moverState == MOVER_POS1 || moverState == MOVER_2TO1 {
        ent!.pos1 = ent!.r.currentOrigin
        ent!.pos2 = origin

        moverState = MOVER_1TO2
    } else if moverState == MOVER_POS2 || moverState == MOVER_1TO2 {
        ent!.pos2 = ent!.r.currentOrigin
        ent!.pos1 = origin

        moverState = MOVER_2TO1
    }

    InitMoverTrData(ent!) //FIXME: This will probably break normal things that are being moved...

    ent!.s.pos.trDuration = Int32(duration)

    // start it going
    MatchTeam(ent!, moverState, level.time)
    //SetMoverState( ent, moverState, level.time );

    ent!.reached = Reached.moverCallback
    if ent!.damage != 0 {
        ent!.blocked = Blocked.Blocked_Mover
    }
    if taskID != -1 {
        trap_ICARUS_TaskIDSet(ent!, TID_MOVE_NAV, taskID)
    }
    // starting sound
    G_PlayDoorLoopSound(ent!) //start looping sound
    G_PlayDoorSound(ent!, BMS_START) //play start sound

    trap_LinkEntity(ent!)
}

/// Source: oracle/codemp/game/g_ICARUScb.c:2114
private func Q3_SetOriginOffset(_ entID: Int32, _ axis: Int32, _ offset: Float) {
    let ent: Entity? = g_entities[entID]
    var origin = vec3_t()
    var duration: Float

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetOriginOffset: invalid entID %d\n", entID)
        return
    }

    if ent!.client != nil || Q_stricmp(ent!.classname!, "target_scriptrunner") == 0 {
        G_DebugPrint(WL_ERROR, "Q3_SetOriginOffset: ent %d is NOT a mover!\n", entID)
        return
    }

    origin = ent!.s.origin
    origin[axis] += offset
    duration = 0
    if ent!.speed != 0 {
        duration = abs(offset) / abs(ent!.speed) * 1000.0
    }
    Q3_Lerp2Origin(-1, entID, origin, duration)
}

/**
```
=============
Q3_SetEnemy

Sets the enemy of an entity
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2149
private func Q3_SetEnemy(_ entID: Int32, _ name: String) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetEnemy: invalid entID %d\n", entID)
        return
    }

    if Q_stricmp("NONE", name) == 0 || Q_stricmp("NULL", name) == 0 {
        if ent!.NPC != nil {
            G_ClearEnemy(ent!)
        } else {
            ent!.enemy = nil
        }
    } else {
        var enemy: Entity?

        if enemy == nil {
            G_DebugPrint(WL_ERROR, "Q3_SetEnemy: no such enemy: '%s'\n", name)
            return
        } else {
            /*else if(enemy->health <= 0)
            {
            //G_DebugPrint( WL_ERROR, "Q3_SetEnemy: ERROR - desired enemy has health %d\n", enemy->health );
            return;
            }*/
            if ent!.NPC != nil {
                G_SetEnemy(ent!, enemy!)
                ent!.cantHitEnemyCounter = 0
            } else {
                G_SetEnemy(ent!, enemy!)
            }
        }
    }
}

/**
```
=============
Q3_SetLeader

Sets the leader of an NPC
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2207
private func Q3_SetLeader(_ entID: Int32, _ name: String) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetLeader: invalid entID %d\n", entID)
        return
    }

    if ent!.client == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetLeader: ent %d is NOT a player or NPC!\n", entID)
        return
    }

    if Q_stricmp("NONE", name) == 0 || Q_stricmp("NULL", name) == 0 {
        ent!.client!.leader = nil
    } else {
        var leader: Entity?

        if leader == nil {
            //G_DebugPrint( WL_ERROR,"Q3_SetEnemy: unable to locate enemy: '%s'\n", name );
            return
        } else if leader!.health <= 0 {
            //G_DebugPrint( WL_ERROR,"Q3_SetEnemy: ERROR - desired enemy has health %d\n", enemy->health );
            return
        } else {
            ent!.client!.leader = leader
        }
    }
}

/**
```
=============
Q3_SetNavGoal

Sets the navigational goal of an entity
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2255
private func Q3_SetNavGoal(_ entID: Int32, _ name: String) -> Bool {
    let ent: Entity? = g_entities[entID]
    var goalPos = vec3_t()

    if ent!.health == 0 {
        G_DebugPrint(WL_ERROR, "Q3_SetNavGoal: tried to set a navgoal (\"%s\") on a corpse! \"%s\"\n", name, ent!.script_targetname ?? "(null)")
        return false
    }
    if ent!.NPC == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetNavGoal: tried to set a navgoal (\"%s\") on a non-NPC: \"%s\"\n", name, ent!.script_targetname ?? "(null)")
        return false
    }
    if ent!.NPC!.tempGoal == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetNavGoal: tried to set a navgoal (\"%s\") on a dead NPC: \"%s\"\n", name, ent!.script_targetname ?? "(null)")
        return false
    }
    if !ent!.NPC!.tempGoal!.inuse {
        G_DebugPrint(WL_ERROR, "Q3_SetNavGoal: NPC's (\"%s\") navgoal is freed: \"%s\"\n", name, ent!.script_targetname ?? "(null)")
        return false
    }
    if Q_stricmp("null", name) == 0 || Q_stricmp("NULL", name) == 0 {
        ent!.NPC!.goalEntity = nil
        trap_ICARUS_TaskIDComplete(ent!, TID_MOVE_NAV)
        return false
    } else {
        //Get the position of the goal
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'".
        // Raven wrote: if ( TAG_GetOrigin2( NULL, name, goalPos ) == qfalse ) { gentity_t *targ = G_Find(NULL, FOFS(targetname), (char*)name); if ( !targ ) { G_DebugPrint( WL_ERROR, "Q3_SetNavGoal: can't find NAVGOAL \"%s\"\n", name ); return qfalse; } else { ent->NPC->goalEntity = targ; ent->NPC->goalRadius = sqrt(ent->r.maxs[0]+ent->r.maxs[0]) + sqrt(targ->r.maxs[0]+targ->r.maxs[0]); ent->NPC->aiFlags &= ~NPCAI_TOUCHED_GOAL; } } else { int goalRadius = TAG_GetRadius( NULL, name ); NPC_SetMoveGoal( ent, goalPos, goalRadius, qtrue, -1, NULL ); //We know we want to clear the lastWaypoint here ent->NPC->goalEntity->lastWaypoint = WAYPOINT_NONE; ent->NPC->aiFlags &= ~NPCAI_TOUCHED_GOAL; #ifdef _DEBUG //this is *only* for debugging navigation ent->NPC->tempGoal->target = G_NewString( name ); #endif// _DEBUG return qtrue; }
        portMissing("Q3_SetNavGoal", source: "oracle/codemp/game/g_ICARUScb.c:2255")
    }
    return false
}

/**
```
============
SetLowerAnim
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int animID
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2330
private func SetLowerAnim(_ entID: Int32, _ animID: Int32) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "SetLowerAnim: invalid entID %d\n", entID)
        return
    }

    if ent!.client == nil {
        G_DebugPrint(WL_ERROR, "SetLowerAnim: ent %d is NOT a player or NPC!\n", entID)
        return
    }

    G_SetAnim(ent!, nil, SETANIM_LEGS, animID, SETANIM_FLAG_RESTART | SETANIM_FLAG_HOLD | SETANIM_FLAG_OVERRIDE, 0)
}

/**
```
============
SetUpperAnim
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int animID
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2358
private func SetUpperAnim(_ entID: Int32, _ animID: Int32) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "SetUpperAnim: invalid entID %d\n", entID)
        return
    }

    if ent!.client == nil {
        G_DebugPrint(WL_ERROR, "SetLowerAnim: ent %d is NOT a player or NPC!\n", entID)
        return
    }

    G_SetAnim(ent!, nil, SETANIM_TORSO, animID, SETANIM_FLAG_RESTART | SETANIM_FLAG_HOLD | SETANIM_FLAG_OVERRIDE, 0)
}

/**
```
=============
Q3_SetAnimUpper

Sets the upper animation of an entity
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2384
private func Q3_SetAnimUpper(_ entID: Int32, _ anim_name: String) -> Bool {
    var animID: Int32 = 0

    animID = GetIDForString(animTable, anim_name)

    if animID == -1 {
        G_DebugPrint(WL_WARNING, "Q3_SetAnimUpper: unknown animation sequence '%s'\n", anim_name)
        return false
    }

    /*
    if ( !PM_HasAnimation( SV_GentityNum(entID), animID ) )
    {
    return qfalse;
    }
    */

    SetUpperAnim(entID, animID)
    return true
}

/**
```
=============
Q3_SetAnimLower

Sets the lower animation of an entity
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2414
private func Q3_SetAnimLower(_ entID: Int32, _ anim_name: String) -> Bool {
    var animID: Int32 = 0

    //FIXME: Setting duck anim does not actually duck!

    animID = GetIDForString(animTable, anim_name)

    if animID == -1 {
        G_DebugPrint(WL_WARNING, "Q3_SetAnimLower: unknown animation sequence '%s'\n", anim_name)
        return false
    }

    /*
    if ( !PM_HasAnimation( SV_GentityNum(entID), animID ) )
    {
    return qfalse;
    }
    */

    SetLowerAnim(entID, animID)
    return true
}

/**
```
============
Q3_SetAnimHoldTime
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int int_data
  Argument		: qboolean lower
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2449
private func Q3_SetAnimHoldTime(_ entID: Int32, _ int_data: Int32, _ lower: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetAnimHoldTime is not currently supported in MP\n")
    /*
    gentity_t	*ent  = &g_entities[entID];

    if ( !ent )
    {
    G_DebugPrint( WL_WARNING, "Q3_SetAnimHoldTime: invalid entID %d\n", entID);
    return;
    }

    if ( !ent->client )
    {
    G_DebugPrint( WL_ERROR, "Q3_SetAnimHoldTime: ent %d is NOT a player or NPC!\n", entID);
    return;
    }

    if(lower)
    {
    PM_SetLegsAnimTimer( ent, &ent->client->ps.legsAnimTimer, int_data );
    }
    else
    {
    PM_SetTorsoAnimTimer( ent, &ent->client->ps.torsoAnimTimer, int_data );
    }
    */
}

/**
```
============
Q3_SetHealth
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2487
private func Q3_SetHealth(_ entID: Int32, _ data: Int32) {
    let ent: Entity? = g_entities[entID]
    // Raven assigns his own `data` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var data = data

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetHealth: invalid entID %d\n", entID)
        return
    }

    if data < 0 {
        data = 0
    }

    ent!.health = data

    if ent!.client == nil {
        return
    }

    ent!.client!.ps.stats[STAT_HEALTH] = data

    if ent!.client!.ps.stats[STAT_HEALTH] > ent!.client!.ps.stats[STAT_MAX_HEALTH] {
        ent!.client!.ps.stats[STAT_HEALTH] = ent!.client!.ps.stats[STAT_MAX_HEALTH]
        ent!.health = ent!.client!.ps.stats[STAT_HEALTH]
    }
    if data == 0 {
        ent!.health = 1
        if ent!.client!.sess.sessionTeam == TEAM_SPECTATOR {
            //this would be silly
            return
        }

        ent!.flags &= ~FL_GODMODE
        ent!.health = -999
        ent!.client!.ps.stats[STAT_HEALTH] = ent!.health
        player_die(ent!, ent!, ent!, 100000, MOD_FALLING)
    }
}

/**
```
============
Q3_SetArmor
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2539
private func Q3_SetArmor(_ entID: Int32, _ data: Int32) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetArmor: invalid entID %d\n", entID)
        return
    }

    if ent!.client == nil {
        return
    }

    ent!.client!.ps.stats[STAT_ARMOR] = data
    if ent!.client!.ps.stats[STAT_ARMOR] > ent!.client!.ps.stats[STAT_MAX_HEALTH] {
        ent!.client!.ps.stats[STAT_ARMOR] = ent!.client!.ps.stats[STAT_MAX_HEALTH]
    }
}

/**
```
============
Q3_SetBState
  Description	:
  Return type	: static qboolean
  Argument		:  int entID
  Argument		: const char *bs_name
FIXME: this should be a general NPC wrapper function
	that is called ANY time	a bState is changed...
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2573
private func Q3_SetBState(_ entID: Int32, _ bs_name: String) -> Bool {
    let ent: Entity? = g_entities[entID]
    let bSID: bState_t

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetBState: invalid entID %d\n", entID)
        return true
    }

    if ent!.NPC == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetBState: '%s' is not an NPC\n", ent!.targetname!)
        return true //ok to complete
    }

    bSID = bState_t(GetIDForString(BSTable, bs_name))
    if bSID > -1 {
        if bSID == BS_SEARCH || bSID == BS_WANDER {
            //FIXME: Reimplement

            if ent!.waypoint != WAYPOINT_NONE {
                NPC_BSSearchStart(ent!.waypoint, bSID)
            } else {
                ent!.waypoint = NAV_FindClosestWaypointForEnt(ent!, WAYPOINT_NONE)

                if ent!.waypoint != WAYPOINT_NONE {
                    NPC_BSSearchStart(ent!.waypoint, bSID)
                } else {
                    /*else if( ent->lastWaypoint >=0 && ent->lastWaypoint < num_waypoints )
                    {
                    NPC_BSSearchStart( ent->lastWaypoint, bSID );
                    }
                    else if( ent->lastValidWaypoint >=0 && ent->lastValidWaypoint < num_waypoints )
                    {
                    NPC_BSSearchStart( ent->lastValidWaypoint, bSID );
                    }*/
                    G_DebugPrint(WL_ERROR, "Q3_SetBState: '%s' is not in a valid waypoint to search from!\n", ent!.targetname!)
                    return true
                }
            }
        }


        ent!.NPC!.tempBehavior = BS_DEFAULT //need to clear any temp behaviour
        if ent!.NPC!.behaviorState == BS_NOCLIP && bSID != BS_NOCLIP {
            //need to rise up out of the floor after noclipping
            ent!.r.currentOrigin[2] = Float(Double(ent!.r.currentOrigin[2]) + 0.125)
            G_SetOrigin(ent!, &ent!.r.currentOrigin)
        }
        ent!.NPC!.behaviorState = bSID
        if bSID == BS_DEFAULT {
            ent!.NPC!.defaultBehavior = bSID
        }
    }

    ent!.NPC!.aiFlags &= ~NPCAI_TOUCHED_GOAL

    //	if ( bSID == BS_FLY )
    //	{//FIXME: need a set bState wrapper
    //		ent->client->moveType = MT_FLYSWIM;
    //	}
    //	else
    do {
        //FIXME: these are presumptions!
        //Q3_SetGravity( entID, g_gravity->value );
        //ent->client->moveType = MT_RUNJUMP;
    }

    if bSID == BS_NOCLIP {
        ent!.client!.noclip = true
    } else {
        ent!.client!.noclip = false
    }

    /*
    if ( bSID == BS_FACE || bSID == BS_POINT_AND_SHOOT || bSID == BS_FACE_ENEMY )
    {
    ent->NPC->aimTime = level.time + 5 * 1000;//try for 5 seconds
    return qfalse;//need to wait for task complete message
    }
    */

    //	if ( bSID == BS_SNIPER || bSID == BS_ADVANCE_FIGHT )
    if bSID == BS_ADVANCE_FIGHT {
        return false //need to wait for task complete message
    }

    /*
    if ( bSID == BS_SHOOT || bSID == BS_POINT_AND_SHOOT )
    {//Let them shoot right NOW
    ent->NPC->shotTime = ent->attackDebounceTime = level.time;
    }
    */
    if bSID == BS_JUMP {
        ent!.NPC!.jumpState = JS_FACING
    }

    return true //ok to complete
}

/**
```
============
Q3_SetTempBState
  Description	:
  Return type	: static qboolean
  Argument		:  int entID
  Argument		: const char *bs_name
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2699
private func Q3_SetTempBState(_ entID: Int32, _ bs_name: String) -> Bool {
    let ent: Entity? = g_entities[entID]
    let bSID: bState_t

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetTempBState: invalid entID %d\n", entID)
        return true
    }

    if ent!.NPC == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetTempBState: '%s' is not an NPC\n", ent!.targetname!)
        return true //ok to complete
    }

    bSID = bState_t(GetIDForString(BSTable, bs_name))
    if bSID > -1 {
        ent!.NPC!.tempBehavior = bSID
    }

    /*
    if ( bSID == BS_FACE || bSID == BS_POINT_AND_SHOOT || bSID == BS_FACE_ENEMY )
    {
    ent->NPC->aimTime = level.time + 5 * 1000;//try for 5 seconds
    return qfalse;//need to wait for task complete message
    }
    */

    /*
    if ( bSID == BS_SHOOT || bSID == BS_POINT_AND_SHOOT )
    {//Let them shoot right NOW
    ent->NPC->shotTime = ent->attackDebounceTime = level.time;
    }
    */
    return true //ok to complete
}

/**
```
============
Q3_SetDefaultBState
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: const char *bs_name
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2749
private func Q3_SetDefaultBState(_ entID: Int32, _ bs_name: String) {
    let ent: Entity? = g_entities[entID]
    let bSID: bState_t

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetDefaultBState: invalid entID %d\n", entID)
        return
    }

    if ent!.NPC == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetDefaultBState: '%s' is not an NPC\n", ent!.targetname!)
        return
    }

    bSID = bState_t(GetIDForString(BSTable, bs_name))
    if bSID > -1 {
        ent!.NPC!.defaultBehavior = bSID
    }
}

/**
```
============
Q3_SetDPitch
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: float data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2783
private func Q3_SetDPitch(_ entID: Int32, _ data: Float) {
    G_DebugPrint(WL_WARNING, "Q3_SetDPitch: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetDYaw
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: float data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2799
private func Q3_SetDYaw(_ entID: Int32, _ data: Float) {
    G_DebugPrint(WL_WARNING, "Q3_SetDYaw: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetShootDist
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: float data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2815
private func Q3_SetShootDist(_ entID: Int32, _ data: Float) {
    G_DebugPrint(WL_WARNING, "Q3_SetShootDist: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetVisrange
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: float data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2831
private func Q3_SetVisrange(_ entID: Int32, _ data: Float) {
    G_DebugPrint(WL_WARNING, "Q3_SetVisrange: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetEarshot
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: float data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2847
private func Q3_SetEarshot(_ entID: Int32, _ data: Float) {
    G_DebugPrint(WL_WARNING, "Q3_SetEarshot: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetVigilance
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: float data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2863
private func Q3_SetVigilance(_ entID: Int32, _ data: Float) {
    G_DebugPrint(WL_WARNING, "Q3_SetVigilance: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetVFOV
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2879
private func Q3_SetVFOV(_ entID: Int32, _ data: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetVFOV: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetHFOV
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2895
private func Q3_SetHFOV(_ entID: Int32, _ data: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetHFOV: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetWidth
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: float data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2911
private func Q3_SetWidth(_ entID: Int32, _ data: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetWidth: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetTimeScale
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: const char *data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2926
private func Q3_SetTimeScale(_ entID: Int32, _ data: String) {
    trap_Cvar_Set("timescale", data)
}

/**
```
============
Q3_SetInvisible
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: qboolean invisible
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2941
private func Q3_SetInvisible(_ entID: Int32, _ invisible: Bool) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetInvisible: invalid entID %d\n", entID)
        return
    }

    if invisible {
        `self`!.s.eFlags |= EF_NODRAW
        if `self`!.client != nil {
            `self`!.client!.ps.eFlags |= EF_NODRAW
        }
        `self`!.r.contents = 0
    } else {
        `self`!.s.eFlags &= ~EF_NODRAW
        if `self`!.client != nil {
            `self`!.client!.ps.eFlags &= ~EF_NODRAW
        }
    }
}

/**
```
============
Q3_SetVampire
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: qboolean vampire
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2979
private func Q3_SetVampire(_ entID: Int32, _ vampire: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetVampire: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetGreetAllies
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: qboolean greet
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:2993
private func Q3_SetGreetAllies(_ entID: Int32, _ greet: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetGreetAllies: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetViewTarget
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *name
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3009
private func Q3_SetViewTarget(_ entID: Int32, _ name: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetViewTarget: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetWatchTarget
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *name
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3025
private func Q3_SetWatchTarget(_ entID: Int32, _ name: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetWatchTarget: NOT SUPPORTED IN MP\n")
    return
}

/// Source: oracle/codemp/game/g_ICARUScb.c:3031
func Q3_SetLoopSound(_ entID: Int32, _ name: String) {
    let index: sfxHandle_t
    let `self`: Entity? = g_entities[entID]

    if Q_stricmp("NULL", name) == 0 || Q_stricmp("NONE", name) == 0 {
        `self`!.s.loopSound = 0
        `self`!.s.loopIsSoundset = false
        return
    }

    index = G_SoundIndex(name)

    if index != 0 {
        `self`!.s.loopSound = index
        `self`!.s.loopIsSoundset = false
    } else {
        G_DebugPrint(WL_WARNING, "Q3_SetLoopSound: can't find sound file: '%s'\n", name)
    }
}

/// Source: oracle/codemp/game/g_ICARUScb.c:3056
func Q3_SetICARUSFreeze(_ entID: Int32, _ name: String, _ freeze: Bool) {
    var `self`: Entity?
    if `self` == nil {
        //hmm, targetname failed, try script_targetname?
    }

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetICARUSFreeze: invalid ent %s\n", name)
        return
    }

    if freeze {
        `self`!.r.svFlags |= SVF_ICARUS_FREEZE
    } else {
        `self`!.r.svFlags &= ~SVF_ICARUS_FREEZE
    }
}

/**
```
============
Q3_SetViewEntity
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *name
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3089
func Q3_SetViewEntity(_ entID: Int32, _ name: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetViewEntity currently unsupported in MP, ask if you need it.\n")
}

/// Source: oracle/codemp/game/g_ICARUScb.c:3104
private func Q3_SetWeapon(_ entID: Int32, _ wp_name: String) {
    let ent: Entity? = g_entities[entID]
    let wp: Int32 = GetIDForString(WPTable, wp_name)

    ent!.client!.ps.stats[STAT_WEAPONS] = (1 << wp)
    ChangeWeapon(ent!, wp)
}

/**
```
============
Q3_SetItem
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *wp_name
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3122
private func Q3_SetItem(_ entID: Int32, _ item_name: String) {
    //rww - unused in mp
    G_DebugPrint(WL_WARNING, "Q3_SetItem: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetWalkSpeed
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: int int_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3139
private func Q3_SetWalkSpeed(_ entID: Int32, _ int_data: Int32) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetWalkSpeed: invalid entID %d\n", entID)
        return
    }

    if `self`!.NPC == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetWalkSpeed: '%s' is not an NPC!\n", `self`!.targetname!)
        return
    }

    if int_data == 0 {
        `self`!.client!.ps.speed = 1
        `self`!.NPC!.stats.walkSpeed = Int32(`self`!.client!.ps.speed)
    }

    `self`!.client!.ps.speed = Float(int_data)
    `self`!.NPC!.stats.walkSpeed = Int32(`self`!.client!.ps.speed)
}

/**
```
============
Q3_SetRunSpeed
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: int int_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3173
private func Q3_SetRunSpeed(_ entID: Int32, _ int_data: Int32) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetRunSpeed: invalid entID %d\n", entID)
        return
    }

    if `self`!.NPC == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetRunSpeed: '%s' is not an NPC!\n", `self`!.targetname!)
        return
    }

    if int_data == 0 {
        `self`!.client!.ps.speed = 1
        `self`!.NPC!.stats.runSpeed = Int32(`self`!.client!.ps.speed)
    }

    `self`!.client!.ps.speed = Float(int_data)
    `self`!.NPC!.stats.runSpeed = Int32(`self`!.client!.ps.speed)
}

/**
```
============
Q3_SetYawSpeed
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: float float_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3207
private func Q3_SetYawSpeed(_ entID: Int32, _ float_data: Float) {
    G_DebugPrint(WL_WARNING, "Q3_SetYawSpeed: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetAggression
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: int int_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3223
private func Q3_SetAggression(_ entID: Int32, _ int_data: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetAggression: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetAim
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: int int_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3239
private func Q3_SetAim(_ entID: Int32, _ int_data: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetAim: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetFriction
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: int int_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3255
private func Q3_SetFriction(_ entID: Int32, _ int_data: Int32) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetFriction: invalid entID %d\n", entID)
        return
    }

    if `self`!.client == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetFriction: '%s' is not an NPC/player!\n", `self`!.targetname!)
        return
    }

    G_DebugPrint(WL_WARNING, "Q3_SetFriction currently unsupported in MP\n")
    //	self->client->ps.friction = int_data;
}

/**
```
============
Q3_SetGravity
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: float float_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3285
private func Q3_SetGravity(_ entID: Int32, _ float_data: Float) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetGravity: invalid entID %d\n", entID)
        return
    }

    if `self`!.client == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetGravity: '%s' is not an NPC/player!\n", `self`!.targetname!)
        return
    }

    //FIXME: what if we want to return them to normal global gravity?
    if `self`!.NPC != nil {
        `self`!.NPC!.aiFlags |= NPCAI_CUSTOM_GRAVITY
    }
    `self`!.client!.ps.gravity = Int32(float_data)
}

/**
```
============
Q3_SetWait
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: float float_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3319
private func Q3_SetWait(_ entID: Int32, _ float_data: Float) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetWait: invalid entID %d\n", entID)
        return
    }

    `self`!.wait = float_data
}

/// Source: oracle/codemp/game/g_ICARUScb.c:3333
private func Q3_SetShotSpacing(_ entID: Int32, _ int_data: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetShotSpacing: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetFollowDist
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: float float_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3348
private func Q3_SetFollowDist(_ entID: Int32, _ float_data: Float) {
    G_DebugPrint(WL_WARNING, "Q3_SetFollowDist: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetScale
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: float float_data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3364
private func Q3_SetScale(_ entID: Int32, _ float_data: Float) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetScale: invalid entID %d\n", entID)
        return
    }

    if `self`!.client != nil {
        if float_data < 0 {
            `self`!.client!.ps.iModelScale = Int32(float_data)
        } else {
            `self`!.client!.ps.iModelScale = Int32(float_data * 100.0)
        }
    } else {
        if float_data < 0 {
            `self`!.s.iModelScale = Int32(float_data)
        } else {
            `self`!.s.iModelScale = Int32(float_data * 100.0)
        }
    }
}

/**
```
============
Q3_GameSideCheckStringCounterIncrement
  Description	:
  Return type	: static float
  Argument		: const char *string
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3406
private func Q3_GameSideCheckStringCounterIncrement(_ string: String) -> Float {
    var numString = TextCursor()
    var val: Float = 0.0
    // Raven steps his own `string` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var string = TextCursor(CharBuf(string))

    if string[0] == Int32(ascii: "+") {
        //We want to increment whatever the value is by whatever follows the +
        if string[1] != 0 {
            numString = string
            numString.advance()
            val = atof(numString.text)
        }
    } else if string[0] == Int32(ascii: "-") {
        //we want to decrement
        if string[1] != 0 {
            numString = string
            numString.advance()
            val = atof(numString.text) * -1
        }
    }

    return val
}

/**
```
============
Q3_SetCount
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *data
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3440
private func Q3_SetCount(_ entID: Int32, _ data: String) {
    let `self`: Entity? = g_entities[entID]
    var val: Float = 0.0

    //FIXME: use FOFS() stuff here to make a generic entity field setting?
    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetCount: invalid entID %d\n", entID)
        return
    }

    val = Q3_GameSideCheckStringCounterIncrement(data)
    if val != 0 {
        `self`!.count += Int32(val)
    } else {
        `self`!.count = atoi(data)
    }
}

/**
```
============
Q3_SetTargetName
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *targetname
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3472
private func Q3_SetTargetName(_ entID: Int32, _ targetname: String) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetTargetName: invalid entID %d\n", entID)
        return
    }

    if Q_stricmp("NULL", (targetname)) == 0 {
        `self`!.targetname = nil
    } else {
        `self`!.targetname = G_NewString(targetname)
    }
}

/**
```
============
Q3_SetTarget
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *target
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3502
private func Q3_SetTarget(_ entID: Int32, _ target: String) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetTarget: invalid entID %d\n", entID)
        return
    }

    if Q_stricmp("NULL", (target)) == 0 {
        `self`!.target = nil
    } else {
        `self`!.target = G_NewString(target)
    }
}

/**
```
============
Q3_SetTarget2
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *target
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3531
private func Q3_SetTarget2(_ entID: Int32, _ target2: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetTarget2 does not exist in MP\n")
    /*
    sharedEntity_t	*self  = SV_GentityNum(entID);

    if ( !self )
    {
    G_DebugPrint( WL_WARNING, "Q3_SetTarget2: invalid entID %d\n", entID);
    return;
    }

    if(!Q_stricmp("NULL", ((char *)target2)))
    {
    self->target2 = NULL;
    }
    else
    {
    self->target2 = G_NewString( target2 );
    }
    */
}

/**
```
============
Q3_SetRemoveTarget
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *target
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3562
private func Q3_SetRemoveTarget(_ entID: Int32, _ target: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetRemoveTarget: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetPainTarget
  Description	:
  Return type	: void
  Argument		: int entID
  Argument		: const char *targetname
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3578
private func Q3_SetPainTarget(_ entID: Int32, _ targetname: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetPainTarget: NOT SUPPORTED IN MP\n")
    /*
    sharedEntity_t	*self  = SV_GentityNum(entID);

    if ( !self )
    {
    G_DebugPrint( WL_WARNING, "Q3_SetPainTarget: invalid entID %d\n", entID);
    return;
    }

    if(Q_stricmp("NULL", ((char *)targetname)) == 0)
    {
    self->paintarget = NULL;
    }
    else
    {
    self->paintarget = G_NewString((char *)targetname);
    }
    */
}

/**
```
============
Q3_SetFullName
  Description	:
  Return type	: static void
  Argument		: int entID
  Argument		: const char *fullName
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3610
private func Q3_SetFullName(_ entID: Int32, _ fullName: String) {
    let `self`: Entity? = g_entities[entID]

    if `self` == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetFullName: invalid entID %d\n", entID)
        return
    }

    if Q_stricmp("NULL", (fullName)) == 0 {
        `self`!.fullName = nil
    } else {
        `self`!.fullName = G_NewString(fullName)
    }
}

/// Source: oracle/codemp/game/g_ICARUScb.c:3630
private func Q3_SetMusicState(_ dms: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetMusicState: NOT SUPPORTED IN MP\n")
    return
}

/// Source: oracle/codemp/game/g_ICARUScb.c:3636
private func Q3_SetForcePowerLevel(_ entID: Int32, _ forcePower: Int32, _ forceLevel: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetForcePowerLevel: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetParm
  Description	:
  Return type	: void
  Argument		: int entID
  Argument		: int parmNum
  Argument		: const char *parmValue
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3651
func Q3_SetParm(_ entID: Int32, _ parmNum: Int32, _ parmValue: String) {
    let ent: Entity? = g_entities[entID]
    var val: Float

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetParm: invalid entID %d\n", entID)
        return
    }

    if parmNum < 0 || parmNum >= MAX_PARMS {
        G_DebugPrint(WL_WARNING, "SET_PARM: parmNum %d out of range!\n", parmNum)
        return
    }

    if ent!.parms == nil {
        ent!.parms = Parms(G_Alloc(Int32(Parms.byteCount)))
        ent!.parms!.clear()
    }

    // Port-note: An assignment inside an expression.
    // Raven wrote: if ( (val = Q3_GameSideCheckStringCounterIncrement( parmValue )) ) { val += atof( ent->parms->parm[parmNum] ); Com_sprintf( ent->parms->parm[parmNum], sizeof(ent->parms->parm), "%f", val ); } else {//Just copy the string //copy only 16 characters strncpy( ent->parms->parm[parmNum], parmValue, sizeof(ent->parms->parm[0]) ); //set the last charcter to null in case we had to truncate their passed string if ( ent->parms->parm[parmNum][sizeof(ent->parms->parm[0]) - 1] != 0 ) {//Tried to set a string that is too long ent->parms->parm[parmNum][sizeof(ent->parms->parm[0]) - 1] = 0; G_DebugPrint( WL_WARNING, "SET_PARM: parm%d string too long, truncated to '%s'!\n", parmNum, ent->parms->parm[parmNum] ); } }
    portMissing("Q3_SetParm", source: "oracle/codemp/game/g_ICARUScb.c:3651")
}

/**
```
=============
Q3_SetCaptureGoal

Sets the capture spot goal of an entity
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3701
private func Q3_SetCaptureGoal(_ entID: Int32, _ name: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetCaptureGoal: NOT SUPPORTED IN MP\n")
    return
}

/**
```
=============
Q3_SetEvent

?
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3714
private func Q3_SetEvent(_ entID: Int32, _ event_name: String) {
    //rwwFIXMEFIXME: Use in MP?
    G_DebugPrint(WL_WARNING, "Q3_SetEvent: NOT SUPPORTED IN MP (may be in future, ask if needed)\n")
    return
}

/**
```
============
Q3_SetIgnorePain

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3727
private func Q3_SetIgnorePain(_ entID: Int32, _ data: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetIgnorePain: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetIgnoreEnemies

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3740
private func Q3_SetIgnoreEnemies(_ entID: Int32, _ data: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetIgnoreEnemies: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetIgnoreAlerts

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3753
private func Q3_SetIgnoreAlerts(_ entID: Int32, _ data: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetIgnoreAlerts: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetNoTarget

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3767
private func Q3_SetNoTarget(_ entID: Int32, _ data: Bool) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetNoTarget: invalid entID %d\n", entID)
        return
    }

    if data {
        ent!.flags |= FL_NOTARGET
    } else {
        ent!.flags &= ~FL_NOTARGET
    }
}

/**
```
============
Q3_SetDontShoot

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3790
private func Q3_SetDontShoot(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetDontShoot: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetDontFire

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3803
private func Q3_SetDontFire(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetDontFire: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetFireWeapon

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3816
private func Q3_SetFireWeapon(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetFireWeapon: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetInactive

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3830
private func Q3_SetInactive(_ entID: Int32, _ add: Bool) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetInactive: invalid entID %d\n", entID)
        return
    }

    if add {
        ent!.flags |= FL_INACTIVE
    } else {
        ent!.flags &= ~FL_INACTIVE
    }
}

/**
```
============
Q3_SetFuncUsableVisible

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3857
private func Q3_SetFuncUsableVisible(_ entID: Int32, _ visible: Bool) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetFuncUsableVisible: invalid entID %d\n", entID)
        return
    }

    // Yeah, I know that this doesn't even do half of what the func_usable use code does, but if I've got two things on top of each other...and only
    //	one is visible at a time....and neither can ever be used......and finally, the shader on it has the shader_anim stuff going on....It doesn't seem
    //	like I can easily use the other version without nasty side effects.
    if visible {
        ent!.r.svFlags &= ~SVF_NOCLIENT
        ent!.s.eFlags &= ~EF_NODRAW
    } else {
        ent!.r.svFlags |= SVF_NOCLIENT
        ent!.s.eFlags |= EF_NODRAW
    }
}

/**
```
============
Q3_SetLockedEnemy

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3889
private func Q3_SetLockedEnemy(_ entID: Int32, _ locked: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetLockedEnemy: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetCinematicSkipScript

============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3903
private func Q3_SetCinematicSkipScript(_ scriptname: String) {
    G_DebugPrint(WL_WARNING, "Q3_SetCinematicSkipScript: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetNoMindTrick

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3916
private func Q3_SetNoMindTrick(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetNoMindTrick: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetCrouched

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3929
private func Q3_SetCrouched(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetCrouched: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetWalking

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3942
private func Q3_SetWalking(_ entID: Int32, _ add: Bool) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetWalking: invalid entID %d\n", entID)
        return
    }

    if ent!.NPC == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetWalking: '%s' is not an NPC!\n", ent!.targetname!)
        return
    }

    if add {
        ent!.NPC!.scriptFlags |= SCF_WALKING
    } else {
        ent!.NPC!.scriptFlags &= ~SCF_WALKING
    }
    return
}

/**
```
============
Q3_SetRunning

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3976
private func Q3_SetRunning(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetRunning: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetForcedMarch

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:3989
private func Q3_SetForcedMarch(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetForcedMarch: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetChaseEnemies

indicates whether the npc should chase after an enemy
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4001
private func Q3_SetChaseEnemies(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetChaseEnemies: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetLookForEnemies

if set npc will be on the look out for potential enemies
if not set, npc will ignore enemies
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4015
private func Q3_SetLookForEnemies(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetLookForEnemies: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetFaceMoveDir

============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4027
private func Q3_SetFaceMoveDir(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetFaceMoveDir: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetAltFire

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4040
private func Q3_SetAltFire(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetAltFire: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetDontFlee

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4053
private func Q3_SetDontFlee(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetDontFlee: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetNoResponse

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4066
private func Q3_SetNoResponse(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetNoResponse: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetCombatTalk

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4079
private func Q3_SetCombatTalk(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetCombatTalk: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetAlertTalk

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4092
private func Q3_SetAlertTalk(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetAlertTalk: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetUseCpNearest

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4105
private func Q3_SetUseCpNearest(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetUseCpNearest: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetNoForce

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4118
private func Q3_SetNoForce(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetNoForce: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetNoAcrobatics

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4131
private func Q3_SetNoAcrobatics(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetNoAcrobatics: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetUseSubtitles

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4144
private func Q3_SetUseSubtitles(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetUseSubtitles: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetNoFallToDeath

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4157
private func Q3_SetNoFallToDeath(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetNoFallToDeath: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetDismemberable

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4170
private func Q3_SetDismemberable(_ entID: Int32, _ dismemberable: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetDismemberable: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetMoreLight

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4184
private func Q3_SetMoreLight(_ entID: Int32, _ add: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetMoreLight: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetUndying

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4197
private func Q3_SetUndying(_ entID: Int32, _ undying: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetUndying: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetInvincible

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4210
private func Q3_SetInvincible(_ entID: Int32, _ invincible: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetInvicible: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetForceInvincible
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: qboolean forceInv
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4224
private func Q3_SetForceInvincible(_ entID: Int32, _ forceInv: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetForceInvicible: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetNoAvoid

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4237
private func Q3_SetNoAvoid(_ entID: Int32, _ noAvoid: Bool) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetNoAvoid: invalid entID %d\n", entID)
        return
    }

    if ent!.NPC == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetNoAvoid: '%s' is not an NPC!\n", ent!.targetname!)
        return
    }

    if noAvoid {
        ent!.NPC!.aiFlags |= NPCAI_NO_COLL_AVOID
    } else {
        ent!.NPC!.aiFlags &= ~NPCAI_NO_COLL_AVOID
    }
}

/**
```
============
SolidifyOwner
  Description	:
  Return type	: void
  Argument		: sharedEntity_t *self
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4271
func SolidifyOwner(_ `self`: Entity) {
    let oldContents: Int32
    let owner: Entity? = g_entities[`self`.r.ownerNum]

    `self`.nextthink = level.time + FRAMETIME
    `self`.think = Think.G_FreeEntity

    if owner == nil || !owner!.inuse {
        return
    }

    oldContents = owner!.r.contents
    owner!.r.contents = CONTENTS_BODY
    if SpotWouldTelefrag2(owner!, owner!.r.currentOrigin) {
        owner!.r.contents = oldContents
        `self`.think = Think.SolidifyOwner
    } else {
        trap_ICARUS_TaskIDComplete(owner!, TID_RESIZE)
    }
}

/**
```
============
Q3_SetSolid

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4305
private func Q3_SetSolid(_ entID: Int32, _ solid: Bool) -> Bool {
    let ent: Entity? = g_entities[entID]

    if ent == nil || !ent!.inuse {
        G_DebugPrint(WL_WARNING, "Q3_SetSolid: invalid entID %d\n", entID)
        return true
    }

    if solid {
        //FIXME: Presumption
        let oldContents: Int32 = ent!.r.contents
        ent!.r.contents = CONTENTS_BODY
        if SpotWouldTelefrag2(ent!, ent!.r.currentOrigin) {
            let solidifier: Entity? = G_Spawn()

            solidifier!.r.ownerNum = ent!.s.number

            solidifier!.think = Think.SolidifyOwner
            solidifier!.nextthink = level.time + FRAMETIME

            ent!.r.contents = oldContents
            return false
        }
        ent!.clipmask |= CONTENTS_BODY
    } else {
        //FIXME: Presumption
        if (ent!.s.eFlags & EF_NODRAW) != 0 {
            //We're invisible too, so set contents to none
            ent!.r.contents = 0
        } else {
            ent!.r.contents = CONTENTS_CORPSE
        }
    }
    return true
}

/**
```
============
Q3_SetForwardMove

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4354
private func Q3_SetForwardMove(_ entID: Int32, _ fmoveVal: Int32) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetForwardMove: invalid entID %d\n", entID)
        return
    }

    if ent!.client == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetForwardMove: '%s' is not an NPC/player!\n", ent!.targetname!)
        return
    }

    G_DebugPrint(WL_WARNING, "Q3_SetForwardMove: NOT SUPPORTED IN MP\n")
    //ent->client->forced_forwardmove = fmoveVal;
}

/**
```
============
Q3_SetRightMove

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4381
private func Q3_SetRightMove(_ entID: Int32, _ rmoveVal: Int32) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetRightMove: invalid entID %d\n", entID)
        return
    }

    if ent!.client == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetRightMove: '%s' is not an NPC/player!\n", ent!.targetname!)
        return
    }

    G_DebugPrint(WL_WARNING, "Q3_SetRightMove: NOT SUPPORTED IN MP\n")
    //ent->client->forced_rightmove = rmoveVal;
}

/**
```
============
Q3_SetLockAngle

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4408
private func Q3_SetLockAngle(_ entID: Int32, _ lockAngle: String) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetLockAngle: invalid entID %d\n", entID)
        return
    }

    if ent!.client == nil {
        G_DebugPrint(WL_ERROR, "Q3_SetLockAngle: '%s' is not an NPC/player!\n", ent!.targetname!)
        return
    }

    G_DebugPrint(WL_WARNING, "Q3_SetLockAngle is not currently available. Ask if you really need it.\n")
    /*
    if(Q_stricmp("off", lockAngle) == 0)
    {//free it
    ent->client->renderInfo.renderFlags &= ~RF_LOCKEDANGLE;
    }
    else
    {
    ent->client->renderInfo.renderFlags |= RF_LOCKEDANGLE;


    if(Q_stricmp("auto", lockAngle) == 0)
    {//use current yaw
    ent->client->renderInfo.lockYaw = ent->client->ps.viewangles[YAW];
    }
    else
    {//specified yaw
    ent->client->renderInfo.lockYaw = atof((char *)lockAngle);
    }
    }
    */
}

/**
```
============
Q3_CameraGroup

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4455
private func Q3_CameraGroup(_ entID: Int32, _ camG: String) {
    G_DebugPrint(WL_WARNING, "Q3_CameraGroup: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_CameraGroupZOfs

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4468
private func Q3_CameraGroupZOfs(_ camGZOfs: Float) {
    G_DebugPrint(WL_WARNING, "Q3_CameraGroupZOfs: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_CameraGroup

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4480
private func Q3_CameraGroupTag(_ camGTag: String) {
    G_DebugPrint(WL_WARNING, "Q3_CameraGroupTag: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_RemoveRHandModel
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4491
private func Q3_RemoveRHandModel(_ entID: Int32, _ addModel: String) {
    G_DebugPrint(WL_WARNING, "Q3_RemoveRHandModel: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_AddRHandModel
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4501
private func Q3_AddRHandModel(_ entID: Int32, _ addModel: String) {
    G_DebugPrint(WL_WARNING, "Q3_AddRHandModel: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_AddLHandModel
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4511
private func Q3_AddLHandModel(_ entID: Int32, _ addModel: String) {
    G_DebugPrint(WL_WARNING, "Q3_AddLHandModel: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_RemoveLHandModel
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4521
private func Q3_RemoveLHandModel(_ entID: Int32, _ addModel: String) {
    G_DebugPrint(WL_WARNING, "Q3_RemoveLHandModel: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_LookTarget

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4533
private func Q3_LookTarget(_ entID: Int32, _ targetName: String) {
    G_DebugPrint(WL_WARNING, "Q3_LookTarget: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_Face

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4546
private func Q3_Face(_ entID: Int32, _ expression: Int32, _ holdtime: Float) {
    G_DebugPrint(WL_WARNING, "Q3_Face: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetLocation
  Description	:
  Return type	: qboolean
  Argument		:  int entID
  Argument		: const char *location
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4560
private func Q3_SetLocation(_ entID: Int32, _ location: String) -> Bool {
    G_DebugPrint(WL_WARNING, "Q3_SetLocation: NOT SUPPORTED IN MP\n")
    return true
}

/// Source: oracle/codemp/game/g_ICARUScb.c:4576
private func Q3_SetPlayerLocked(_ entID: Int32, _ locked: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetPlayerLocked: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetLockPlayerWeapons
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: qboolean locked
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4590
private func Q3_SetLockPlayerWeapons(_ entID: Int32, _ locked: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetLockPlayerWeapons: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetNoImpactDamage
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: qboolean locked
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4605
private func Q3_SetNoImpactDamage(_ entID: Int32, _ noImp: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetNoImpactDamage: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetBehaviorSet

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4617
private func Q3_SetBehaviorSet(_ entID: Int32, _ toSet: Int32, _ scriptname: String) -> Bool {
    let ent: Entity? = g_entities[entID]
    var bSet: bSet_t = BSET_INVALID

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetBehaviorSet: invalid entID %d\n", entID)
        return false
    }

    switch toSet {
    case SET_SPAWNSCRIPT:
        bSet = BSET_SPAWN

    case SET_USESCRIPT:
        bSet = BSET_USE

    case SET_AWAKESCRIPT:
        bSet = BSET_AWAKE

    case SET_ANGERSCRIPT:
        bSet = BSET_ANGER

    case SET_ATTACKSCRIPT:
        bSet = BSET_ATTACK

    case SET_VICTORYSCRIPT:
        bSet = BSET_VICTORY

    case SET_LOSTENEMYSCRIPT:
        bSet = BSET_LOSTENEMY

    case SET_PAINSCRIPT:
        bSet = BSET_PAIN

    case SET_FLEESCRIPT:
        bSet = BSET_FLEE

    case SET_DEATHSCRIPT:
        bSet = BSET_DEATH

    case SET_DELAYEDSCRIPT:
        bSet = BSET_DELAYED

    case SET_BLOCKEDSCRIPT:
        bSet = BSET_BLOCKED

    case SET_FFIRESCRIPT:
        bSet = BSET_FFIRE

    case SET_FFDEATHSCRIPT:
        bSet = BSET_FFDEATH

    case SET_MINDTRICKSCRIPT:
        bSet = BSET_MINDTRICK

    default:
        break
    }

    if bSet < BSET_SPAWN || bSet >= NUM_BSETS {
        return false
    }

    if Q_stricmp("NULL", scriptname) == 0 {
        if ent!.behaviorSet[bSet] != nil {
            //			gi.TagFree( ent->behaviorSet[bSet] );
        }

        ent!.behaviorSet[bSet] = nil
        //memset( &ent->behaviorSet[bSet], 0, sizeof(ent->behaviorSet[bSet]) );
    } else {
        if ent!.behaviorSet[bSet] != nil {
            //				gi.TagFree( ent->behaviorSet[bSet] );
        }

        ent!.behaviorSet[bSet] = G_NewString(scriptname) //FIXME: This really isn't good...

        //ent->behaviorSet[bSet] = scriptname;
        //strncpy( (char *) &ent->behaviorSet[bSet], scriptname, MAX_BSET_LENGTH );
    }
    return true
}

/**
```
============
Q3_SetDelayScriptTime

?
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4717
private func Q3_SetDelayScriptTime(_ entID: Int32, _ delayTime: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetDelayScriptTime: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetPlayerUsable
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: qboolean usable
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4734
private func Q3_SetPlayerUsable(_ entID: Int32, _ usable: Bool) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetPlayerUsable: invalid entID %d\n", entID)
        return
    }

    if usable {
        ent!.r.svFlags |= SVF_PLAYER_USABLE
    } else {
        ent!.r.svFlags &= ~SVF_PLAYER_USABLE
    }
}

/**
```
============
Q3_SetDisableShaderAnims
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int disabled
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4763
private func Q3_SetDisableShaderAnims(_ entID: Int32, _ disabled: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetDisableShaderAnims: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetShaderAnim
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int disabled
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4778
private func Q3_SetShaderAnim(_ entID: Int32, _ disabled: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetShaderAnim: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetStartFrame
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int startFrame
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4793
private func Q3_SetStartFrame(_ entID: Int32, _ startFrame: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetStartFrame: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetEndFrame
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int endFrame
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4808
private func Q3_SetEndFrame(_ entID: Int32, _ endFrame: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetEndFrame: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetAnimFrame
  Description	:
  Return type	: static void
  Argument		:  int entID
  Argument		: int startFrame
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4822
private func Q3_SetAnimFrame(_ entID: Int32, _ animFrame: Int32) {
    G_DebugPrint(WL_WARNING, "Q3_SetAnimFrame: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetLoopAnim
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: qboolean loopAnim
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4836
private func Q3_SetLoopAnim(_ entID: Int32, _ loopAnim: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetLoopAnim: NOT SUPPORTED IN MP\n")
}

/**
```
============
Q3_SetShields
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: qboolean shields
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4851
private func Q3_SetShields(_ entID: Int32, _ shields: Bool) {
    G_DebugPrint(WL_WARNING, "Q3_SetShields: NOT SUPPORTED IN MP\n")
    return
}

/**
```
============
Q3_SetSaberActive
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: qboolean shields
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4866
private func Q3_SetSaberActive(_ entID: Int32, _ active: Bool) {
    let ent: Entity? = g_entities[entID]

    if ent == nil || !ent!.inuse {
        return
    }

    if ent!.client == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetSaberActive: %d is not a client\n", entID)
    }

    //fixme: Take into account player being in state where saber won't toggle? For now we simply won't care.
    if ent!.client!.ps.saberHolstered == 0 && active {
        Cmd_ToggleSaber_f(ent!)
    } else if BG_SabersOff(ent!.client!.ps) && !active {
        Cmd_ToggleSaber_f(ent!)
    }
}

/**
```
============
Q3_SetNoKnockback
  Description	:
  Return type	: void
  Argument		:  int entID
  Argument		: qboolean noKnockback
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4900
private func Q3_SetNoKnockback(_ entID: Int32, _ noKnockback: Bool) {
    let ent: Entity? = g_entities[entID]

    if ent == nil {
        G_DebugPrint(WL_WARNING, "Q3_SetNoKnockback: invalid entID %d\n", entID)
        return
    }

    if noKnockback {
        ent!.flags |= FL_NO_KNOCKBACK
    } else {
        ent!.flags &= ~FL_NO_KNOCKBACK
    }
}

/**
```
============
Q3_SetCleanDamagingEnts
  Description	:
  Return type	: void
============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4927
private func Q3_SetCleanDamagingEnts() {
    G_DebugPrint(WL_WARNING, "Q3_SetCleanDamagingEnts: NOT SUPPORTED IN MP\n")
    return
}

/**
```
-------------------------
SetTextColor
-------------------------
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4942
private func SetTextColor(_ textcolor: JKAShared.vec4_t, _ color: String) {
    G_DebugPrint(WL_WARNING, "SetTextColor: NOT SUPPORTED IN MP\n")
    return
}

/**
```
=============
Q3_SetCaptionTextColor

Change color text prints in
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4955
private func Q3_SetCaptionTextColor(_ color: String) {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '[Float]' to expected argument type 'vec4_t' (aka 'SIMD4<Float>')".
    // Raven wrote: SetTextColor(textcolor_caption,color)
    portMissing("Q3_SetCaptionTextColor", source: "oracle/codemp/game/g_ICARUScb.c:4955")
}

/**
```
=============
Q3_SetCenterTextColor

Change color text prints in
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4967
private func Q3_SetCenterTextColor(_ color: String) {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '[Float]' to expected argument type 'vec4_t' (aka 'SIMD4<Float>')".
    // Raven wrote: SetTextColor(textcolor_center,color)
    portMissing("Q3_SetCenterTextColor", source: "oracle/codemp/game/g_ICARUScb.c:4967")
}

/**
```
=============
Q3_SetScrollTextColor

Change color text prints in
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4979
private func Q3_SetScrollTextColor(_ color: String) {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '[Float]' to expected argument type 'vec4_t' (aka 'SIMD4<Float>')".
    // Raven wrote: SetTextColor(textcolor_scroll,color)
    portMissing("Q3_SetScrollTextColor", source: "oracle/codemp/game/g_ICARUScb.c:4979")
}

/**
```
=============
Q3_ScrollText

Prints a message in the center of the screen
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:4991
private func Q3_ScrollText(_ id: String) {
    G_DebugPrint(WL_WARNING, "Q3_ScrollText: NOT SUPPORTED IN MP\n")
    //trap_SendServerCommand( -1, va("st \"%s\"", id));

    return
}

/**
```
=============
Q3_LCARSText

Prints a message in the center of the screen giving it an LCARS frame around it
=============
```
*/
/// Source: oracle/codemp/game/g_ICARUScb.c:5006
private func Q3_LCARSText(_ id: String) {
    G_DebugPrint(WL_WARNING, "Q3_ScrollText: NOT SUPPORTED IN MP\n")
    //trap_SendServerCommand( -1, va("lt \"%s\"", id));

    return
}

//returns qtrue if it got to the end, otherwise qfalse.
/// Source: oracle/codemp/game/g_ICARUScb.c:5018
public func Q3_Set(_ taskID: Int32, _ entID: Int32, _ type_name: String, _ data: String) -> Bool {
    let ent: Entity? = g_entities[entID]
    var float_data: Float
    var int_data: Int32
    let toSet: Int32
    var vector_data = vec3_t()

    //Set this for callbacks
    toSet = GetIDForString(setTable, type_name)

    //TODO: Throw in a showscript command that will list each command and what they're doing...
    //		maybe as simple as printing that line of the script to the console preceeded by the person's name?
    //		showscript can take any number of targetnames or "all"?  Groupname?
    switch toSet {
    case SET_ORIGIN:
        sscanf(data, "%f %f %f", &vector_data)
        G_SetOrigin(ent!, &vector_data)
        if Q_strncmp("NPC_", ent!.classname!, 4) == 0 {
            //hack for moving spawners
            ent!.s.origin = vector_data
        }

    case SET_TELEPORT_DEST:
        sscanf(data, "%f %f %f", &vector_data)
        if !Q3_SetTeleportDest(entID, &vector_data) {
            trap_ICARUS_TaskIDSet(ent!, TID_MOVE_NAV, taskID)
            return false
        }

    case SET_COPY_ORIGIN:
        Q3_SetCopyOrigin(entID, data)

    case SET_ANGLES:
        //Q3_SetAngles( entID, *(vec3_t *) data);
        sscanf(data, "%f %f %f", &vector_data)
        Q3_SetAngles(entID, vector_data)

    case SET_XVELOCITY:
        float_data = atof(data)
        Q3_SetVelocity(entID, 0, float_data)

    case SET_YVELOCITY:
        float_data = atof(data)
        Q3_SetVelocity(entID, 1, float_data)

    case SET_ZVELOCITY:
        float_data = atof(data)
        Q3_SetVelocity(entID, 2, float_data)

    case SET_Z_OFFSET:
        float_data = atof(data)
        Q3_SetOriginOffset(entID, 2, float_data)

    case SET_ENEMY:
        Q3_SetEnemy(entID, data)

    case SET_LEADER:
        Q3_SetLeader(entID, data)

    case SET_NAVGOAL:
        if Q3_SetNavGoal(entID, data) {
            trap_ICARUS_TaskIDSet(ent!, TID_MOVE_NAV, taskID)
            return false //Don't call it back
        }

    case SET_ANIM_UPPER:
        if Q3_SetAnimUpper(entID, data) {
            Q3_TaskIDClear(&ent!.taskID[TID_ANIM_BOTH]) //We only want to wait for the top
            trap_ICARUS_TaskIDSet(ent!, TID_ANIM_UPPER, taskID)
            return false //Don't call it back
        }

    case SET_ANIM_LOWER:
        if Q3_SetAnimLower(entID, data) {
            Q3_TaskIDClear(&ent!.taskID[TID_ANIM_BOTH]) //We only want to wait for the bottom
            trap_ICARUS_TaskIDSet(ent!, TID_ANIM_LOWER, taskID)
            return false //Don't call it back
        }

    case SET_ANIM_BOTH:
        do {
            var both: Int32 = 0
            if Q3_SetAnimUpper(entID, data) {
                trap_ICARUS_TaskIDSet(ent!, TID_ANIM_UPPER, taskID)
                both += 1
            } else {
                G_DebugPrint(WL_ERROR, "Q3_SetAnimUpper: %s does not have anim %s!\n", ent!.targetname!, data)
            }
            if Q3_SetAnimLower(entID, data) {
                trap_ICARUS_TaskIDSet(ent!, TID_ANIM_LOWER, taskID)
                both += 1
            } else {
                G_DebugPrint(WL_ERROR, "Q3_SetAnimLower: %s does not have anim %s!\n", ent!.targetname!, data)
            }
            if both >= 2 {
                trap_ICARUS_TaskIDSet(ent!, TID_ANIM_BOTH, taskID)
            }
            if both != 0 {
                return false //Don't call it back
            }
        }

    case SET_ANIM_HOLDTIME_LOWER:
        int_data = atoi(data)
        Q3_SetAnimHoldTime(entID, int_data, true)
        Q3_TaskIDClear(&ent!.taskID[TID_ANIM_BOTH]) //We only want to wait for the bottom
        trap_ICARUS_TaskIDSet(ent!, TID_ANIM_LOWER, taskID)
        return false //Don't call it back

    case SET_ANIM_HOLDTIME_UPPER:
        int_data = atoi(data)
        Q3_SetAnimHoldTime(entID, int_data, false)
        Q3_TaskIDClear(&ent!.taskID[TID_ANIM_BOTH]) //We only want to wait for the top
        trap_ICARUS_TaskIDSet(ent!, TID_ANIM_UPPER, taskID)
        return false //Don't call it back

    case SET_ANIM_HOLDTIME_BOTH:
        int_data = atoi(data)
        Q3_SetAnimHoldTime(entID, int_data, false)
        Q3_SetAnimHoldTime(entID, int_data, true)
        trap_ICARUS_TaskIDSet(ent!, TID_ANIM_BOTH, taskID)
        trap_ICARUS_TaskIDSet(ent!, TID_ANIM_UPPER, taskID)
        trap_ICARUS_TaskIDSet(ent!, TID_ANIM_LOWER, taskID)
        return false //Don't call it back

    case SET_PLAYER_TEAM:
        G_DebugPrint(WL_WARNING, "Q3_SetPlayerTeam: Not in MP ATM, let a programmer (ideally Rich) know if you need it\n")

    case SET_ENEMY_TEAM:
        G_DebugPrint(WL_WARNING, "Q3_SetEnemyTeam: NOT SUPPORTED IN MP\n")

    case SET_HEALTH:
        int_data = atoi(data)
        Q3_SetHealth(entID, int_data)

    case SET_ARMOR:
        int_data = atoi(data)
        Q3_SetArmor(entID, int_data)

    case SET_BEHAVIOR_STATE:
        if !Q3_SetBState(entID, data) {
            trap_ICARUS_TaskIDSet(ent!, TID_BSTATE, taskID)
            return false //don't complete
        }

    case SET_DEFAULT_BSTATE:
        Q3_SetDefaultBState(entID, data)

    case SET_TEMP_BSTATE:
        if !Q3_SetTempBState(entID, data) {
            trap_ICARUS_TaskIDSet(ent!, TID_BSTATE, taskID)
            return false //don't complete
        }

    case SET_CAPTURE:
        Q3_SetCaptureGoal(entID, data)

    case SET_DPITCH:
        float_data = atof(data)
        Q3_SetDPitch(entID, float_data)
        trap_ICARUS_TaskIDSet(ent!, TID_ANGLE_FACE, taskID)
        return false

    case SET_DYAW:
        float_data = atof(data)
        Q3_SetDYaw(entID, float_data)
        trap_ICARUS_TaskIDSet(ent!, TID_ANGLE_FACE, taskID)
        return false

    case SET_EVENT:
        Q3_SetEvent(entID, data)

    case SET_VIEWTARGET:
        Q3_SetViewTarget(entID, data)
        trap_ICARUS_TaskIDSet(ent!, TID_ANGLE_FACE, taskID)
        return false

    case SET_WATCHTARGET:
        Q3_SetWatchTarget(entID, data)

    case SET_VIEWENTITY:
        Q3_SetViewEntity(entID, data)

    case SET_LOOPSOUND:
        Q3_SetLoopSound(entID, data)

    case SET_ICARUS_FREEZE, SET_ICARUS_UNFREEZE:
        Q3_SetICARUSFreeze(entID, data, Bool((toSet == SET_ICARUS_FREEZE)))

    case SET_WEAPON:
        Q3_SetWeapon(entID, data)

    case SET_ITEM:
        Q3_SetItem(entID, data)

    case SET_WALKSPEED:
        int_data = atoi(data)
        Q3_SetWalkSpeed(entID, int_data)

    case SET_RUNSPEED:
        int_data = atoi(data)
        Q3_SetRunSpeed(entID, int_data)

    case SET_WIDTH:
        int_data = atoi(data)
        Q3_SetWidth(entID, int_data)
        return false

    case SET_YAWSPEED:
        float_data = atof(data)
        Q3_SetYawSpeed(entID, float_data)

    case SET_AGGRESSION:
        int_data = atoi(data)
        Q3_SetAggression(entID, int_data)

    case SET_AIM:
        int_data = atoi(data)
        Q3_SetAim(entID, int_data)

    case SET_FRICTION:
        int_data = atoi(data)
        Q3_SetFriction(entID, int_data)

    case SET_GRAVITY:
        float_data = atof(data)
        Q3_SetGravity(entID, float_data)

    case SET_WAIT:
        float_data = atof(data)
        Q3_SetWait(entID, float_data)

    case SET_FOLLOWDIST:
        float_data = atof(data)
        Q3_SetFollowDist(entID, float_data)

    case SET_SCALE:
        float_data = atof(data)
        Q3_SetScale(entID, float_data)

    case SET_COUNT:
        Q3_SetCount(entID, data)

    case SET_SHOT_SPACING:
        int_data = atoi(data)
        Q3_SetShotSpacing(entID, int_data)

    case SET_IGNOREPAIN:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetIgnorePain(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetIgnorePain(entID, false)
        }

    case SET_IGNOREENEMIES:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetIgnoreEnemies(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetIgnoreEnemies(entID, false)
        }

    case SET_IGNOREALERTS:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetIgnoreAlerts(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetIgnoreAlerts(entID, false)
        }

    case SET_DONTSHOOT:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetDontShoot(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetDontShoot(entID, false)
        }

    case SET_DONTFIRE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetDontFire(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetDontFire(entID, false)
        }

    case SET_LOCKED_ENEMY:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetLockedEnemy(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetLockedEnemy(entID, false)
        }

    case SET_NOTARGET:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoTarget(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetNoTarget(entID, false)
        }

    case SET_LEAN:
        G_DebugPrint(WL_WARNING, "SET_LEAN NOT SUPPORTED IN MP\n")

    case SET_SHOOTDIST:
        float_data = atof(data)
        Q3_SetShootDist(entID, float_data)

    case SET_TIMESCALE:
        Q3_SetTimeScale(entID, data)

    case SET_VISRANGE:
        float_data = atof(data)
        Q3_SetVisrange(entID, float_data)

    case SET_EARSHOT:
        float_data = atof(data)
        Q3_SetEarshot(entID, float_data)

    case SET_VIGILANCE:
        float_data = atof(data)
        Q3_SetVigilance(entID, float_data)

    case SET_VFOV:
        int_data = atoi(data)
        Q3_SetVFOV(entID, int_data)

    case SET_HFOV:
        int_data = atoi(data)
        Q3_SetHFOV(entID, int_data)

    case SET_TARGETNAME:
        Q3_SetTargetName(entID, data)

    case SET_TARGET:
        Q3_SetTarget(entID, data)

    case SET_TARGET2:
        Q3_SetTarget2(entID, data)

    case SET_LOCATION:
        if !Q3_SetLocation(entID, data) {
            trap_ICARUS_TaskIDSet(ent!, TID_LOCATION, taskID)
            return false
        }

    case SET_PAINTARGET:
        Q3_SetPainTarget(entID, data)

    case SET_DEFEND_TARGET:
        G_DebugPrint(WL_WARNING, "Q3_SetDefendTarget unimplemented\n", entID)

    case SET_PARM1, SET_PARM2, SET_PARM3, SET_PARM4, SET_PARM5, SET_PARM6, SET_PARM7, SET_PARM8, SET_PARM9, SET_PARM10, SET_PARM11, SET_PARM12, SET_PARM13, SET_PARM14, SET_PARM15, SET_PARM16:
        Q3_SetParm(entID, (toSet - SET_PARM1), data)

    case SET_SPAWNSCRIPT, SET_USESCRIPT, SET_AWAKESCRIPT, SET_ANGERSCRIPT, SET_ATTACKSCRIPT, SET_VICTORYSCRIPT, SET_PAINSCRIPT, SET_FLEESCRIPT, SET_DEATHSCRIPT, SET_DELAYEDSCRIPT, SET_BLOCKEDSCRIPT, SET_FFIRESCRIPT, SET_FFDEATHSCRIPT, SET_MINDTRICKSCRIPT:
        if !Q3_SetBehaviorSet(entID, toSet, data) {
            G_DebugPrint(WL_ERROR, "Q3_SetBehaviorSet: Invalid bSet %s\n", type_name)
        }

    case SET_NO_MINDTRICK:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoMindTrick(entID, true)
        } else {
            Q3_SetNoMindTrick(entID, false)
        }

    case SET_CINEMATIC_SKIPSCRIPT:
        Q3_SetCinematicSkipScript(data)

    case SET_DELAYSCRIPTTIME:
        int_data = atoi(data)
        Q3_SetDelayScriptTime(entID, int_data)

    case SET_CROUCHED:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetCrouched(entID, true)
        } else {
            Q3_SetCrouched(entID, false)
        }

    case SET_WALKING:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetWalking(entID, true)
        } else {
            Q3_SetWalking(entID, false)
        }

    case SET_RUNNING:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetRunning(entID, true)
        } else {
            Q3_SetRunning(entID, false)
        }

    case SET_CHASE_ENEMIES:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetChaseEnemies(entID, true)
        } else {
            Q3_SetChaseEnemies(entID, false)
        }

    case SET_LOOK_FOR_ENEMIES:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetLookForEnemies(entID, true)
        } else {
            Q3_SetLookForEnemies(entID, false)
        }

    case SET_FACE_MOVE_DIR:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetFaceMoveDir(entID, true)
        } else {
            Q3_SetFaceMoveDir(entID, false)
        }

    case SET_ALT_FIRE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetAltFire(entID, true)
        } else {
            Q3_SetAltFire(entID, false)
        }

    case SET_DONT_FLEE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetDontFlee(entID, true)
        } else {
            Q3_SetDontFlee(entID, false)
        }

    case SET_FORCED_MARCH:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetForcedMarch(entID, true)
        } else {
            Q3_SetForcedMarch(entID, false)
        }

    case SET_NO_RESPONSE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoResponse(entID, true)
        } else {
            Q3_SetNoResponse(entID, false)
        }

    case SET_NO_COMBAT_TALK:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetCombatTalk(entID, true)
        } else {
            Q3_SetCombatTalk(entID, false)
        }

    case SET_NO_ALERT_TALK:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetAlertTalk(entID, true)
        } else {
            Q3_SetAlertTalk(entID, false)
        }

    case SET_USE_CP_NEAREST:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetUseCpNearest(entID, true)
        } else {
            Q3_SetUseCpNearest(entID, false)
        }

    case SET_NO_FORCE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoForce(entID, true)
        } else {
            Q3_SetNoForce(entID, false)
        }

    case SET_NO_ACROBATICS:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoAcrobatics(entID, true)
        } else {
            Q3_SetNoAcrobatics(entID, false)
        }

    case SET_USE_SUBTITLES:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetUseSubtitles(entID, true)
        } else {
            Q3_SetUseSubtitles(entID, false)
        }

    case SET_NO_FALLTODEATH:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoFallToDeath(entID, true)
        } else {
            Q3_SetNoFallToDeath(entID, false)
        }

    case SET_DISMEMBERABLE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetDismemberable(entID, true)
        } else {
            Q3_SetDismemberable(entID, false)
        }

    case SET_MORELIGHT:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetMoreLight(entID, true)
        } else {
            Q3_SetMoreLight(entID, false)
        }

    case SET_TREASONED:
        G_DebugPrint(WL_VERBOSE, "SET_TREASONED is disabled, do not use\n")

    case SET_UNDYING:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetUndying(entID, true)
        } else {
            Q3_SetUndying(entID, false)
        }

    case SET_INVINCIBLE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetInvincible(entID, true)
        } else {
            Q3_SetInvincible(entID, false)
        }

    case SET_NOAVOID:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoAvoid(entID, true)
        } else {
            Q3_SetNoAvoid(entID, false)
        }

    case SET_SOLID:
        if Q_stricmp("true", (data)) == 0 {
            if !Q3_SetSolid(entID, true) {
                trap_ICARUS_TaskIDSet(ent!, TID_RESIZE, taskID)
                return false
            }
        } else {
            Q3_SetSolid(entID, false)
        }

    case SET_INVISIBLE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetInvisible(entID, true)
        } else {
            Q3_SetInvisible(entID, false)
        }

    case SET_VAMPIRE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetVampire(entID, true)
        } else {
            Q3_SetVampire(entID, false)
        }

    case SET_FORCE_INVINCIBLE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetForceInvincible(entID, true)
        } else {
            Q3_SetForceInvincible(entID, false)
        }

    case SET_GREET_ALLIES:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetGreetAllies(entID, true)
        } else {
            Q3_SetGreetAllies(entID, false)
        }

    case SET_PLAYER_LOCKED:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetPlayerLocked(entID, true)
        } else {
            Q3_SetPlayerLocked(entID, false)
        }

    case SET_LOCK_PLAYER_WEAPONS:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetLockPlayerWeapons(entID, true)
        } else {
            Q3_SetLockPlayerWeapons(entID, false)
        }

    case SET_NO_IMPACT_DAMAGE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoImpactDamage(entID, true)
        } else {
            Q3_SetNoImpactDamage(entID, false)
        }

    case SET_FORWARDMOVE:
        int_data = atoi(data)
        Q3_SetForwardMove(entID, int_data)

    case SET_RIGHTMOVE:
        int_data = atoi(data)
        Q3_SetRightMove(entID, int_data)

    case SET_LOCKYAW:
        Q3_SetLockAngle(entID, data)

    case SET_CAMERA_GROUP:
        Q3_CameraGroup(entID, data)

    case SET_CAMERA_GROUP_Z_OFS:
        float_data = atof(data)
        Q3_CameraGroupZOfs(float_data)

    case SET_CAMERA_GROUP_TAG:
        Q3_CameraGroupTag(data)
        //FIXME: put these into camera commands

    case SET_LOOK_TARGET:
        Q3_LookTarget(entID, data)

    case SET_ADDRHANDBOLT_MODEL:
        Q3_AddRHandModel(entID, data)

    case SET_REMOVERHANDBOLT_MODEL:
        Q3_RemoveRHandModel(entID, data)

    case SET_ADDLHANDBOLT_MODEL:
        Q3_AddLHandModel(entID, data)

    case SET_REMOVELHANDBOLT_MODEL:
        Q3_RemoveLHandModel(entID, data)

    case SET_FACEEYESCLOSED, SET_FACEEYESOPENED, SET_FACEAUX, SET_FACEBLINK, SET_FACEBLINKFROWN, SET_FACEFROWN, SET_FACENORMAL:
        float_data = atof(data)
        Q3_Face(entID, toSet, float_data)

    case SET_SCROLLTEXT:
        Q3_ScrollText(data)

    case SET_LCARSTEXT:
        Q3_LCARSText(data)

    case SET_CAPTIONTEXTCOLOR:
        Q3_SetCaptionTextColor(data)

    case SET_CENTERTEXTCOLOR:
        Q3_SetCenterTextColor(data)

    case SET_SCROLLTEXTCOLOR:
        Q3_SetScrollTextColor(data)

    case SET_PLAYER_USABLE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetPlayerUsable(entID, true)
        } else {
            Q3_SetPlayerUsable(entID, false)
        }

    case SET_STARTFRAME:
        int_data = atoi(data)
        Q3_SetStartFrame(entID, int_data)

    case SET_ENDFRAME:
        int_data = atoi(data)
        Q3_SetEndFrame(entID, int_data)

        trap_ICARUS_TaskIDSet(ent!, TID_ANIM_BOTH, taskID)
        return false

    case SET_ANIMFRAME:
        int_data = atoi(data)
        Q3_SetAnimFrame(entID, int_data)
        return false

    case SET_LOOP_ANIM:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetLoopAnim(entID, true)
        } else {
            Q3_SetLoopAnim(entID, false)
        }

    case SET_INTERFACE:
        G_DebugPrint(WL_WARNING, "Q3_SetInterface: NOT SUPPORTED IN MP\n")

    case SET_SHIELDS:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetShields(entID, true)
        } else {
            Q3_SetShields(entID, false)
        }

    case SET_SABERACTIVE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetSaberActive(entID, true)
        } else {
            Q3_SetSaberActive(entID, false)
        }

    case SET_ADJUST_AREA_PORTALS:
        G_DebugPrint(WL_WARNING, "Q3_SetAdjustAreaPortals: NOT SUPPORTED IN MP\n")

    case SET_DMG_BY_HEAVY_WEAP_ONLY:
        G_DebugPrint(WL_WARNING, "Q3_SetDmgByHeavyWeapOnly: NOT SUPPORTED IN MP\n")

    case SET_SHIELDED:
        G_DebugPrint(WL_WARNING, "Q3_SetShielded: NOT SUPPORTED IN MP\n")

    case SET_NO_GROUPS:
        G_DebugPrint(WL_WARNING, "Q3_SetNoGroups: NOT SUPPORTED IN MP\n")

    case SET_FIRE_WEAPON:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetFireWeapon(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetFireWeapon(entID, false)
        }

    case SET_INACTIVE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetInactive(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetInactive(entID, false)
        } else if Q_stricmp("unlocked", (data)) == 0 {
            UnLockDoors(g_entities[entID])
        } else if Q_stricmp("locked", (data)) == 0 {
            LockDoors(g_entities[entID])
        }

    case SET_END_SCREENDISSOLVE:
        G_DebugPrint(WL_WARNING, "SET_END_SCREENDISSOLVE: NOT SUPPORTED IN MP\n")

    case SET_MISSION_STATUS_SCREEN:
        //Cvar_Set("cg_missionstatusscreen", "1");
        G_DebugPrint(WL_WARNING, "SET_MISSION_STATUS_SCREEN: NOT SUPPORTED IN MP\n")

    case SET_FUNC_USABLE_VISIBLE:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetFuncUsableVisible(entID, true)
        } else if Q_stricmp("false", (data)) == 0 {
            Q3_SetFuncUsableVisible(entID, false)
        }

    case SET_NO_KNOCKBACK:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetNoKnockback(entID, true)
        } else {
            Q3_SetNoKnockback(entID, false)
        }

    case SET_VIDEO_PLAY:
        // don't do this check now, James doesn't want a scripted cinematic to also skip any Video cinematics as well,
        //	the "timescale" and "skippingCinematic" cvars will be set back to normal in the Video code, so doing a
        //	skip will now only skip one section of a multiple-part story (eg VOY1 bridge sequence)
        //
        //		if ( g_timescale->value <= 1.0f )
        do {
            G_DebugPrint(WL_WARNING, "SET_VIDEO_PLAY: NOT SUPPORTED IN MP\n")
            //SV_SendConsoleCommand( va("inGameCinematic %s\n", (char *)data) );
        }

    case SET_VIDEO_FADE_IN:
        G_DebugPrint(WL_WARNING, "SET_VIDEO_FADE_IN: NOT SUPPORTED IN MP\n")

    case SET_VIDEO_FADE_OUT:
        G_DebugPrint(WL_WARNING, "SET_VIDEO_FADE_OUT: NOT SUPPORTED IN MP\n")

    case SET_REMOVE_TARGET:
        Q3_SetRemoveTarget(entID, data)

    case SET_LOADGAME:
        //gi.SendConsoleCommand( va("load %s\n", (const char *) data ) );
        G_DebugPrint(WL_WARNING, "SET_LOADGAME: NOT SUPPORTED IN MP\n")

    case SET_MENU_SCREEN:
        //UI_SetActiveMenu( (const char *) data );
        break

    case SET_OBJECTIVE_SHOW:
        G_DebugPrint(WL_WARNING, "SET_OBJECTIVE_SHOW: NOT SUPPORTED IN MP\n")

    case SET_OBJECTIVE_HIDE:
        G_DebugPrint(WL_WARNING, "SET_OBJECTIVE_HIDE: NOT SUPPORTED IN MP\n")

    case SET_OBJECTIVE_SUCCEEDED:
        G_DebugPrint(WL_WARNING, "SET_OBJECTIVE_SUCCEEDED: NOT SUPPORTED IN MP\n")

    case SET_OBJECTIVE_FAILED:
        G_DebugPrint(WL_WARNING, "SET_OBJECTIVE_FAILED: NOT SUPPORTED IN MP\n")

    case SET_OBJECTIVE_CLEARALL:
        G_DebugPrint(WL_WARNING, "SET_OBJECTIVE_CLEARALL: NOT SUPPORTED IN MP\n")

    case SET_MISSIONFAILED:
        G_DebugPrint(WL_WARNING, "SET_MISSIONFAILED: NOT SUPPORTED IN MP\n")

    case SET_MISSIONSTATUSTEXT:
        G_DebugPrint(WL_WARNING, "SET_MISSIONSTATUSTEXT: NOT SUPPORTED IN MP\n")

    case SET_MISSIONSTATUSTIME:
        G_DebugPrint(WL_WARNING, "SET_MISSIONSTATUSTIME: NOT SUPPORTED IN MP\n")

    case SET_CLOSINGCREDITS:
        G_DebugPrint(WL_WARNING, "SET_CLOSINGCREDITS: NOT SUPPORTED IN MP\n")

    case SET_SKILL:
        //		//can never be set
        break

    case SET_FULLNAME:
        Q3_SetFullName(entID, data)

    case SET_DISABLE_SHADER_ANIM:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetDisableShaderAnims(entID, 1)
        } else {
            Q3_SetDisableShaderAnims(entID, 0)
        }

    case SET_SHADER_ANIM:
        if Q_stricmp("true", (data)) == 0 {
            Q3_SetShaderAnim(entID, 1)
        } else {
            Q3_SetShaderAnim(entID, 0)
        }

    case SET_MUSIC_STATE:
        Q3_SetMusicState(data)

    case SET_CLEAN_DAMAGING_ENTS:
        Q3_SetCleanDamagingEnts()

    case SET_HUD:
        G_DebugPrint(WL_WARNING, "SET_HUD: NOT SUPPORTED IN MP\n")

    case SET_FORCE_HEAL_LEVEL, SET_FORCE_JUMP_LEVEL, SET_FORCE_SPEED_LEVEL, SET_FORCE_PUSH_LEVEL, SET_FORCE_PULL_LEVEL, SET_FORCE_MINDTRICK_LEVEL, SET_FORCE_GRIP_LEVEL, SET_FORCE_LIGHTNING_LEVEL, SET_SABER_THROW, SET_SABER_DEFENSE, SET_SABER_OFFENSE:
        int_data = atoi(data)
        Q3_SetForcePowerLevel(entID, (toSet - SET_FORCE_HEAL_LEVEL), int_data)

    default:
        //G_DebugPrint( WL_ERROR, "Q3_Set: '%s' is not a valid set field\n", type_name );
        trap_ICARUS_SetVar(taskID, entID, type_name, data)
    }

    return true
}
