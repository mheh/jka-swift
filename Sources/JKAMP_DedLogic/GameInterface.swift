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
public func ICARUS_GetScript(_ name: String, _ buf: inout JKAShared.TextCursor) -> Int32 {
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
public func ICARUS_RunScript(_ ent: JKAMP.SharedEntity, _ name: String) -> Int32 {
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
public func ICARUS_Init() {
    //Link all interface functions
    Interface_Init(interface_export)

    //Create the ICARUS instance for this session
    iICARUS = ICARUS_Instance.Create(interface_export)

    if iICARUS == nil {
        Com_Error(ERR_DROP, "Unable to initialize ICARUS instance\n")
    }
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:166
public func ICARUS_Shutdown() {
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
public func ICARUS_FreeEnt(_ ent: JKAMP.SharedEntity) {
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
public func ICARUS_ValidEnt(_ ent: JKAMP.SharedEntity) -> Bool {
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
public func ICARUS_AssociateEnt(_ ent: JKAMP.SharedEntity) {
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
public func ICARUS_RegisterScript(_ name: String, _ bCalledDuringInterrogate: Bool = false) -> Bool {
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
public func ICARUS_SoundPrecache(_ filename: String) {
    let sharedMem = IcarusSoundIndex(sv.mSharedMemoryBytes!.base)

    sharedMem.filename = filename

    VM_Call(gvm!, GAME_ICARUS_SOUNDINDEX)
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:409
public func ICARUS_GetIDForString(_ string: String) -> Int32 {
    let sharedMem = IcarusGetSetIDForString(sv.mSharedMemoryBytes!.base)

    sharedMem.string = string

    return VM_Call(gvm!, GAME_ICARUS_GETSETIDFORSTRING)
}

// at this point the filename should have had the "scripts" (Q3_SCRIPT_DIR) added to it (but not the IBI extension)
//
/// Source: oracle/codemp/icarus/GameInterface.cpp:426
public func ICARUS_InterrogateScript(_ filename: String) {
    let stream = CBlockStream()
    var blockMember: CBlockMember?
    let block = CBlock()

    if Q_stricmp(filename, "NULL") == 0 || Q_stricmp(filename, "default") == 0 {
        return
    }

    //////////////////////////////////
    //
    // ensure "scripts" (Q3_SCRIPT_DIR), which will be missing if this was called recursively...
    //
    var sFilename = CharBuf(MAX_FILENAME_LENGTH)	// should really be MAX_QPATH (and 64 bytes instead of 1024), but this fits the rest of the code

    if Q_stricmpn(filename, Q3_SCRIPT_DIR, strlen(Q3_SCRIPT_DIR)) == 0 {
        Q_strncpyz(&sFilename, filename, Int32(sFilename.count))
    } else {
        Q_strncpyz(&sFilename, va("%s/%s", Q3_SCRIPT_DIR, filename), Int32(sFilename.count))
    }
    //
    //////////////////////////////////


    //Attempt to register this script
    if ICARUS_RegisterScript(String(sFilename), true) == false {	// true = bCalledDuringInterrogate
        return
    }

    var buf = TextCursor()
    var len: Int32

    //Attempt to retrieve the new script data
    len = ICARUS_GetScript(String(sFilename), &buf)
    if len == 0 {
        return
    }

    //Open the stream
    if stream.Open(buf.buf, len) == 0 {
        return
    }

    var sVal1: CharBuf
    var sVal2: CharBuf
    var temp = CharBuf(1024)
    var setID: Int32

    //Now iterate through all blocks of the script, searching for keywords
    while stream.BlockAvailable() != 0 {
        //Get a block
        if stream.ReadBlock(block) == 0 {
            return
        }

        //Determine what type of block this is
        switch block.GetBlockID() {
        case ID_CAMERA:	// to cache ROFF files
            let f: Float = block.GetMemberData(0)![float: 0]

            if f == TYPE_PATH {
                // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
                sVal1 = CharBuf(block.GetMember(1)!.GetSize())
                Com_Memcpy(&sVal1, block.GetMemberData(1)!, sVal1.count)

                //we can do this I guess since the roff is loaded on the server.
                theROFFSystem.Cache(String(sVal1), false)
            }

        case ID_PLAY:	// to cache ROFF files

            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            sVal1 = CharBuf(block.GetMember(0)!.GetSize())
            Com_Memcpy(&sVal1, block.GetMemberData(0)!, sVal1.count)

            if Q_stricmp(String(sVal1), "PLAY_ROFF") == 0 {
                // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
                sVal1 = CharBuf(block.GetMember(1)!.GetSize())
                Com_Memcpy(&sVal1, block.GetMemberData(1)!, sVal1.count)

                //we can do this I guess since the roff is loaded on the server.
                theROFFSystem.Cache(String(sVal1), false)
            }

        //Run commands
        case ID_RUN:

            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            sVal1 = CharBuf(block.GetMember(0)!.GetSize())
            Com_Memcpy(&sVal1, block.GetMemberData(0)!, sVal1.count)

            COM_StripExtension(String(sVal1), &temp)
            ICARUS_InterrogateScript(String(temp))

        case ID_SOUND:
            //We can't just call over to S_RegisterSound or whatever because this is on the server.
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            sVal1 = CharBuf(block.GetMember(1)!.GetSize())
            Com_Memcpy(&sVal1, block.GetMemberData(1)!, sVal1.count)	//0 is channel, 1 is filename
            ICARUS_SoundPrecache(String(sVal1))

        case ID_SET:
            blockMember = block.GetMember(0)

            //NOTENOTE: This will not catch special case get() inlines! (There's not really a good way to do that)

            //Make sure we're testing against strings
            if blockMember!.GetID() == TK_STRING {
                // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
                sVal1 = CharBuf(block.GetMember(0)!.GetSize())
                Com_Memcpy(&sVal1, block.GetMemberData(0)!, sVal1.count)
                // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
                sVal2 = CharBuf(block.GetMember(1)!.GetSize())
                Com_Memcpy(&sVal2, block.GetMemberData(1)!, sVal2.count)

                //Get the id for this set identifier
                setID = ICARUS_GetIDForString(String(sVal1))

                //Check against valid types
                switch setID {
                case SET_SPAWNSCRIPT,
                     SET_USESCRIPT,
                     SET_AWAKESCRIPT,
                     SET_ANGERSCRIPT,
                     SET_ATTACKSCRIPT,
                     SET_VICTORYSCRIPT,
                     SET_LOSTENEMYSCRIPT,
                     SET_PAINSCRIPT,
                     SET_FLEESCRIPT,
                     SET_DEATHSCRIPT,
                     SET_DELAYEDSCRIPT,
                     SET_BLOCKEDSCRIPT,
                     SET_FFIRESCRIPT,
                     SET_FFDEATHSCRIPT,
                     SET_MINDTRICKSCRIPT,
                     SET_CINEMATIC_SKIPSCRIPT:
                    //Recursively obtain all embedded scripts
                    ICARUS_InterrogateScript(String(sVal2))
                case SET_LOOPSOUND:		//like ID_SOUND, but set's looping
                    ICARUS_SoundPrecache(String(sVal2))
                case SET_VIDEO_PLAY:	//in game cinematic
                    //do nothing for MP.
                    break
                case SET_ADDRHANDBOLT_MODEL,
                     SET_ADDLHANDBOLT_MODEL:
                    //do nothing for MP
                    break
                default:
                    break
                }
            }

        default:
            break
        }

        //Clean out the block for the next pass
        block.Free()
    }

    //All done
    stream.Free()
}

/// Source: oracle/codemp/icarus/GameInterface.cpp:617
public func ICARUS_PrecacheEnt(_ ent: JKAMP.SharedEntity) {
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
public func ICARUS_InitEnt(_ ent: JKAMP.SharedEntity) {
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
public func Svcmd_ICARUS_f() {
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
