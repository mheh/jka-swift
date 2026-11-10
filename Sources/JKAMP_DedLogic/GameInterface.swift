import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/icarus/GameInterface.cpp:16
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var iICARUS: ICARUS_Instance? {
    get { world.iICARUS }
    set { world.iICARUS = newValue }
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:17
// TODO: Port global ICARUS_BufferList
// Raven wrote: bufferlist_t ICARUS_BufferList
// No view for `std::map<std::basic_string<char>, pscript_s *, std::less<std::basic_string<char> >, std::allocator<pscript_s *> >`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/icarus/GameInterface.cpp:18
// TODO: Port global ICARUS_EntList
// Raven wrote: entlist_t ICARUS_EntList
// No view for `std::map<std::basic_string<char>, int, std::less<std::basic_string<char> >, std::allocator<int> >`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/icarus/GameInterface.cpp:23
// Raven wrote: int ICARUS_entFilter = -1
let ICARUS_entFilter: Int32 = -1

/// Source: oracle/codemp/icarus/GameInterface.cpp:592
// TODO: Port global BSTable
// Raven wrote: stringID_table_t BSTable[]
// No view for `stringID_table_s` of `q_shared.h`.

/// Source: oracle/codemp/icarus/GameInterface.cpp:33
func ICARUS_GetScript(_ name: String, _ buf: inout JKAShared.TextCursor) -> Int32 {
    // TODO: Port ICARUS_GetScript
    portMissing("ICARUS_GetScript", source: "oracle/codemp/icarus/GameInterface.cpp:33")
}

/**
```
=============
ICARUS_RunScript

Runs the script by the given name
=============
```
*/
/// Source: oracle/codemp/icarus/GameInterface.cpp:69
func ICARUS_RunScript(_ ent: JKAMP.SharedEntity, _ name: String) -> Int32 {
    var buf = TextCursor()
    let len: Int32

    //Make sure the caller is valid
    if gSequencers[ent.s.number] == nil {
        //Com_Printf( "%s : entity is not a valid script user\n", ent->classname );
        return 0
    }
    len = ICARUS_GetScript(name, &buf)
    if len == 0 {
        return 0
    }

    //Attempt to run the script
    if S_FAILED(gSequencers[ent.s.number]!.Run(buf.buf, len)) {
        return 0
    }

    if (ICARUS_entFilter == -1) || (ICARUS_entFilter == ent.s.number) {
        Q3_DebugPrint(WL_VERBOSE, "%d Script %s executed by %s %s\n", svs.time, name, ent.classname ?? "(null)", ent.targetname ?? "(null)")
    }

    return 1
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:143
func ICARUS_Init() {
    // TODO: Port ICARUS_Init
    portMissing("ICARUS_Init", source: "oracle/codemp/icarus/GameInterface.cpp:143")
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:166
func ICARUS_Shutdown() {
    // TODO: Port ICARUS_Shutdown
    portMissing("ICARUS_Shutdown", source: "oracle/codemp/icarus/GameInterface.cpp:166")
}

/**
```
==============
ICARUS_FreeEnt

Frees all ICARUS resources on an entity

WARNING!!! DO NOT DO THIS WHILE RUNNING A SCRIPT, ICARUS WILL CRASH!!!
FIXME: shouldn't ICARUS handle this internally?

==============
```
*/
/// Source: oracle/codemp/icarus/GameInterface.cpp:220
func ICARUS_FreeEnt(_ ent: JKAMP.SharedEntity) {
    // TODO: Port ICARUS_FreeEnt
    portMissing("ICARUS_FreeEnt", source: "oracle/codemp/icarus/GameInterface.cpp:220")
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:268
func ICARUS_ValidEnt(_ ent: JKAMP.SharedEntity) -> Bool {
    var i: Int32

    //Targeted by a script
    if VALIDSTRING(ent.script_targetname) {
        return true
    }

    //Potentially able to call a script
    i = 0
    while i < NUM_BSETS {
        if VALIDSTRING(ent.behaviorSet[i]) {
            //Com_Printf( "WARNING: Entity %d (%s) has behaviorSet but no script_targetname -- using targetname\n", ent->s.number, ent->targetname );

            //ent->script_targetname = ent->targetname;
            //rww - You CANNOT do things like this now. We're switching memory around to be able to read this memory from vm land,
            //and while this allows us to read it on our "fake" entity here, we can't modify pointers like this. We can however do
            //something completely hackish such as the following.
            let trueEntity = SV_GentityNum(ent.s.number)
            //This works because we're modifying the actual shared game vm data and turning one pointer into another.
            //While these pointers both look like garbage to us in here, they are not.
            trueEntity!.script_targetname = trueEntity!.targetname
            return true
        }
        i += 1
    }

    return false
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:307
func ICARUS_AssociateEnt(_ ent: JKAMP.SharedEntity) {
    // TODO: Port ICARUS_AssociateEnt
    portMissing("ICARUS_AssociateEnt", source: "oracle/codemp/icarus/GameInterface.cpp:307")
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:328
func ICARUS_RegisterScript(_ name: String, _ bCalledDuringInterrogate: Bool = false) -> Bool {
    // TODO: Port ICARUS_RegisterScript
    portMissing("ICARUS_RegisterScript", source: "oracle/codemp/icarus/GameInterface.cpp:328")
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:400
func ICARUS_SoundPrecache(_ filename: String) {
    let sharedMem = IcarusSoundIndex(sv.mSharedMemoryBytes!.base)

    sharedMem.filename = filename

    VM_Call(gvm!, GAME_ICARUS_SOUNDINDEX)
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:409
func ICARUS_GetIDForString(_ string: String) -> Int32 {
    let sharedMem = IcarusGetSetIDForString(sv.mSharedMemoryBytes!.base)

    sharedMem.string = string

    // AI: Raven returns the int of VM_Call. The port's VM_Call returns the pointer-wide word of vmMain, so the body takes its low 32 bits.
    return Int32(truncatingIfNeeded: VM_Call(gvm!, GAME_ICARUS_GETSETIDFORSTRING))
}

// at this point the filename should have had the "scripts" (Q3_SCRIPT_DIR) added to it (but not the IBI extension)
//
/// Source: oracle/codemp/icarus/GameInterface.cpp:426
func ICARUS_InterrogateScript(_ filename: String) {
    // TODO: Port ICARUS_InterrogateScript
    portMissing("ICARUS_InterrogateScript", source: "oracle/codemp/icarus/GameInterface.cpp:426")
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:617
func ICARUS_PrecacheEnt(_ ent: JKAMP.SharedEntity) {
    // TODO: Port ICARUS_PrecacheEnt
    portMissing("ICARUS_PrecacheEnt", source: "oracle/codemp/icarus/GameInterface.cpp:617")
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:646
func ICARUS_InitEnt(_ ent: JKAMP.SharedEntity) {
    //Make sure this is a fresh ent
    if gSequencers[ent.s.number] != nil {
        return
    }

    if gTaskManagers[ent.s.number] != nil {
        return
    }

    //Create the sequencer and setup the task manager
    gSequencers[ent.s.number] = iICARUS!.GetSequencer(ent.s.number)
    gTaskManagers[ent.s.number] = gSequencers[ent.s.number]!.GetTaskManager()

    //Initialize all taskIDs to -1
    ent.taskID.fill(-1)

    //Add this entity to a map of valid associated ents for quick retrieval later
    ICARUS_AssociateEnt(ent)

    //Precache all the entity's scripts
    ICARUS_PrecacheEnt(ent)
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:679
func ICARUS_LinkEntity(_ entID: Int32, _ sequencer: CSequencer?, _ taskManager: CTaskManager?) -> Int32 {
    let ent = SV_GentityNum(entID)

    if ent == nil {
        return 0
    }

    gSequencers[ent!.s.number] = sequencer
    gTaskManagers[ent!.s.number] = taskManager

    ICARUS_AssociateEnt(ent!)

    return 1
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:700
func Svcmd_ICARUS_f() {
    //rwwFIXMEFIXME: Do something with this for debugging purposes at some point.
    /*
    char	*cmd = Cmd_Argv( 1 );

    if ( Q_stricmp( cmd, "log" ) == 0 )
    {
        //g_ICARUSDebug->integer = WL_DEBUG;
        if ( VALIDSTRING( Cmd_Argv( 2 ) ) )
        {
            sharedEntity_t	*ent = G_Find( NULL, FOFS( script_targetname ), gi.argv(2) );

            if ( ent == NULL )
            {
                Com_Printf( "Entity \"%s\" not found!\n", gi.argv(2) );
                return;
            }

            //Start logging
            Com_Printf("Logging ICARUS info for entity %s\n", gi.argv(2) );

            ICARUS_entFilter		= ( ent->s.number == ICARUS_entFilter ) ? -1 : ent->s.number;

            return;
        }

        Com_Printf("Logging ICARUS info for all entities\n");

        return;
    }
    */
    return
}
