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

/// Raven's cached script, the bytes of one IBI file and their count.
/// Source: oracle/codemp/icarus/GameInterface.h:4
// AI: Raven holds an ICARUS_Malloc block in `char *buffer`. The record holds the CharBuf of the file, the form of the CharBuf callers of FS_ReadFile.
struct pscript_t {
    var buffer = CharBuf(0)
    var length: Int32 = 0
}

/// Source: oracle/codemp/icarus/GameInterface.h:10
// AI: Raven declares a `map < string, int >`. The type is a Dictionary, by rule 17.
typealias entlist_t = [String: Int32]

/// Source: oracle/codemp/icarus/GameInterface.h:11
// AI: Raven declares a `map < string, pscript_t* >`. The type is a Dictionary of the record, by rule 17.
typealias bufferlist_t = [String: pscript_t]

/// Source: oracle/codemp/icarus/GameInterface.cpp:17
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var ICARUS_BufferList: bufferlist_t {
    get { world.ICARUS_BufferList }
    set { world.ICARUS_BufferList = newValue }
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:18
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var ICARUS_EntList: entlist_t {
    get { world.ICARUS_EntList }
    set { world.ICARUS_EntList = newValue }
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:23
// Raven wrote: int ICARUS_entFilter = -1
let ICARUS_entFilter: Int32 = -1

/// Source: oracle/codemp/icarus/GameInterface.cpp:33
func ICARUS_GetScript(_ name: String, _ buf: inout JKAShared.TextCursor) -> Int32 {
    //Make sure the caller is valid

    //Attempt to retrieve a precached script
    var ei = ICARUS_BufferList[name]

    //Not found, check the disk
    if ei == nil {
        if ICARUS_RegisterScript(name) == false {
            return 0
        }

        //Script is now inserted, retrieve it and pass through
        ei = ICARUS_BufferList[name]

        if ei == nil {
            //NOTENOTE: This is an internal error in STL if this happens...
            assert(false)
            return 0
        }
    }

    buf = TextCursor(ei!.buffer)
    return ei!.length
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
    var ent = SV_GentityNum(0)

    //Release all ICARUS resources from the entities
    var i: Int32 = 0
    while i < /*globals.num_entities*/MAX_GENTITIES {
        ent = SV_GentityNum(i)

        if gSequencers[i] != nil {
            if ent!.s.number >= MAX_GENTITIES ||
                ent!.s.number < 0 {
                ent!.s.number = i
                assert(false)
            }
            ICARUS_FreeEnt(ent!)
        }
        i += 1
    }

    //Clear out all precached scripts
    // AI: Raven frees the ICARUS_Malloc block of each script and deletes the record. The records hold CharBufs, so the clear below frees them.

    ICARUS_BufferList.removeAll()

    //Clear the name map
    ICARUS_EntList.removeAll()

    //Free this instance
    if iICARUS != nil {
        iICARUS!.Delete()
        iICARUS = nil
    }
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
    assert(iICARUS != nil)

    if ent.s.number >= MAX_GENTITIES ||
        ent.s.number < 0 {
        assert(false)
        return
    }

    //Make sure the ent is valid
    if gSequencers[ent.s.number] == nil {
        return
    }

    //Remove them from the ICARUSE_EntList list so that when their g_entity index is reused, ICARUS doesn't try to affect the new (incorrect) ent.
    if VALIDSTRING(ent.script_targetname) {
        var temp = CharBuf(1024)

        strncpy(&temp, ent.script_targetname!, 1023)
        temp[1023] = 0

        // AI: Raven's Q_strupr returns its argument, and the port's returns nothing. The key is the text of the CharBuf after the call.
        Q_strupr(&temp)
        ICARUS_EntList.removeValue(forKey: String(temp))
    }

    //Delete the sequencer and the task manager
    iICARUS!.DeleteSequencer(gSequencers[ent.s.number])

    //Clean up the pointers
    gSequencers[ent.s.number] = nil
    gTaskManagers[ent.s.number] = nil
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
    var temp = CharBuf(1024)

    if VALIDSTRING(ent.script_targetname) == false {
        return
    }

    strncpy(&temp, ent.script_targetname!, 1023)
    temp[1023] = 0

    // AI: Raven's Q_strupr returns its argument, and the port's returns nothing. The key is the text of the CharBuf after the call.
    Q_strupr(&temp)
    ICARUS_EntList[String(temp)] = ent.s.number
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:328
func ICARUS_RegisterScript(_ name: String, _ bCalledDuringInterrogate: Bool = false) -> Bool {
    var pscript: pscript_t
    var newname = CharBuf(MAX_FILENAME_LENGTH)
    var buffer = CharBuf(0)	// lose compiler warning about uninitialised vars
    let length: Int32

    //Make sure this isn't already cached
    let ei = ICARUS_BufferList[name]

    // note special return condition here, if doing interrogate and we already have this file then we MUST return
    //	false (which stops the interrogator proceeding), this not only saves some time, but stops a potential
    //	script recursion bug which could lock the program in an infinite loop...   Return TRUE for normal though!
    //
    if ei != nil {
        return (bCalledDuringInterrogate) ? false : true
    }

    // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of newname.
    Com_sprintf(&newname, MAX_FILENAME_LENGTH, "%s%s", name, IBI_EXT)


    // small update here, if called during interrogate, don't let gi.FS_ReadFile() complain because it can't
    //	find stuff like BS_RUN_AND_SHOOT as scriptname...   During FINALBUILD the message won't appear anyway, hence
    //	the ifndef, this just cuts down on internal error reports while testing release mode...
    //
    let qbIgnoreFileRead = false
    //
    // NOTENOTE: For the moment I've taken this back out, to avoid doubling the number of fopen()'s per file.

    length = qbIgnoreFileRead ? -1 : FS_ReadFile(String(newname), &buffer)

    if length <= 0 {
        // File not found, but keep quiet during interrogate stage, because of stuff like BS_RUN_AND_SHOOT as scriptname
        //
        if !bCalledDuringInterrogate {
            Com_Printf(S_COLOR_RED + "Could not open file '%s'\n", newname)
        }
        return false
    }

    pscript = pscript_t()

    // AI: Raven copies the file into an ICARUS_Malloc block. The record takes a copy of the CharBuf of the file.
    pscript.buffer = buffer
    pscript.length = length

    FS_FreeFile(buffer)

    ICARUS_BufferList[name] = pscript

    return true
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

    return VM_Call(gvm!, GAME_ICARUS_GETSETIDFORSTRING)
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
    var newname = CharBuf(MAX_FILENAME_LENGTH)
    var i: Int32

    i = 0
    while i < NUM_BSETS {
        if ent.behaviorSet[i] == nil {
            i += 1
            continue
        }

        if GetIDForString(BSTable, ent.behaviorSet[i]!) == -1 {//not a behavior set
            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of newname.
            Com_sprintf(&newname, MAX_FILENAME_LENGTH, "%s/%s", Q3_SCRIPT_DIR, ent.behaviorSet[i]!)

            //Precache this, and all internally referenced scripts
            ICARUS_InterrogateScript(String(newname))
        }
        i += 1
    }
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
