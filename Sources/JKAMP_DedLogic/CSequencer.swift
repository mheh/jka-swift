import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's test for a sequencer return code other than `SEQ_OK`.
/// Source: oracle/codemp/icarus/sequencer.h:36
func S_FAILED(_ a: Int32) -> Bool {
    a != SEQ_OK
}

/// Raven's parse stream record, one block stream and the stream that it interrupts.
/// Source: oracle/codemp/icarus/sequencer.h:42
// AI: Raven declares a C struct that the sequencer handles through pointers. The record is a final class, so a pointer is a reference.
final class bstream_s {
    var stream: CBlockStream? = nil
    var last: bstream_s? = nil
}

/// Source: oracle/codemp/icarus/sequencer.h:46
typealias bstream_t = bstream_s

/**
```
==================================================================================================

  CSequencer

==================================================================================================
```
*/
/// Raven's sequencer of one entity, which parses a script into sequences and hands each command to its task manager.
/// Source: oracle/codemp/icarus/sequencer.h:68
// AI: Raven allocates the class with Z_Malloc in operator new and frees it in operator delete. ARC frees the class, so the two operators drop.
final class CSequencer {
    //	typedef	map < int, CSequence * >			sequenceID_m;
    // AI: Raven types the list with std::list. It is an Array, by rule 17.
    typealias sequence_l = [CSequence]
    // AI: Raven keys a std::map by the CTaskGroup pointer.
    // The Dictionary keys by the ObjectIdentifier of the group, because a class is not Hashable.
    typealias taskSequence_m = [ObjectIdentifier: CSequence]

    //Member variables

    // AI: Raven holds the owner as a pointer. The field is weak, because the instance holds every sequencer in its list.
    private weak var m_owner: ICARUS_Instance? = nil
    private var m_ownerID: Int32 = 0

    private var m_taskManager: CTaskManager? = nil
    private var m_ie: interface_export_t? = nil				//This is unique to the sequencer so that client side and server side sequencers could both
    //operate under different interfaces (for client side scripting)

    private var m_numCommands: Int32 = 0		//Total number of commands for the sequencer (including all child sequences)

    //	sequenceID_m		m_sequenceMap;
    private var m_sequences: sequence_l = []
    private var m_taskSequences: taskSequence_m = [:]

    private var m_curSequence: CSequence? = nil
    private var m_curGroup: CTaskGroup? = nil

    private var m_curStream: bstream_t? = nil

    private var m_elseValid: Int32 = 0
    private var m_elseOwner: CBlock? = nil
    // AI: Raven holds a std::vector of bstream_t pointers. The field is an Array of the record, by rule 17.
    private var m_streamsCreated: [bstream_t] = []

    // Sequencer
    /// Source: oracle/codemp/icarus/Sequencer.cpp:16
    init() {
        self.m_numCommands = 0

        self.m_curStream = nil
        self.m_curSequence = nil

        self.m_elseValid = 0
        self.m_elseOwner = nil

        self.m_curGroup = nil
    }

    /// Source: oracle/codemp/icarus/Sequencer.cpp:29
    deinit {
        self.Free()	//Safe even if already freed
    }

    /**
    ```
    ========================
    Create

    Static creation function
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:42
    static func Create() -> CSequencer? {
        let sequencer: CSequencer? = CSequencer()

        return sequencer
    }

    /**
    ```
    ========================
    Init

    Initializes the sequencer
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:56
    @discardableResult
    func Init(_ ownerID: Int32, _ ie: interface_export_t?, _ taskManager: CTaskManager?, _ iICARUS: ICARUS_Instance?) -> Int32 {
        self.m_ownerID = ownerID
        self.m_owner = iICARUS
        self.m_taskManager = taskManager
        self.m_ie = ie

        return SEQ_OK
    }

    /**
    ```
    ========================
    Free

    Releases all resources and re-inits the sequencer
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:73
    @discardableResult
    func Free() -> Int32 {
        //Flush the sequences
        for sli in self.m_sequences {
            self.m_owner!.DeleteSequence(sli)
        }

        self.m_sequences.removeAll()
        self.m_taskSequences.removeAll()

        //Clean up any other info
        self.m_numCommands = 0
        self.m_curSequence = nil

        var streamToDel: bstream_t?
        while !self.m_streamsCreated.isEmpty {
            streamToDel = self.m_streamsCreated.last
            self.DeleteStream(streamToDel)
        }

        return SEQ_OK
    }

    /**
    ```
    -------------------------
    Flush
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:106
    @discardableResult
    private func Flush(_ owner: CSequence?) -> Int32 {
        if owner == nil {
            return SEQ_FAILED
        }

        self.Recall()

        //Flush the sequences
        var sli = 0
        while sli < self.m_sequences.count {
            if (self.m_sequences[sli] === owner) || (owner!.HasChild(self.m_sequences[sli])) || (self.m_sequences[sli].HasFlag(SQ_PENDING) != 0) || (self.m_sequences[sli].HasFlag(SQ_TASK) != 0) {
                sli += 1
                continue
            }

            //Delete it, and remove all references
            self.RemoveSequence(self.m_sequences[sli])
            self.m_owner!.DeleteSequence(self.m_sequences[sli])

            //Delete from the sequence list and move on
            self.m_sequences.remove(at: sli)
        }

        //Make sure this owner knows it's now the root sequence
        owner!.SetParent(nil)
        owner!.SetReturn(nil)

        return SEQ_OK
    }

    /**
    ```
    ========================
    AddStream

    Creates a stream for parsing
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:147
    private func AddStream() -> bstream_t? {
        var stream: bstream_t?

        stream = bstream_t()				//deleted in Route()
        stream!.stream = CBlockStream()	//deleted in Route()
        stream!.last = self.m_curStream

        self.m_streamsCreated.append(stream!)

        return stream
    }

    /**
    ```
    ========================
    DeleteStream

    Deletes parsing stream
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:167
    private func DeleteStream(_ bstream: bstream_t?) {
        let finder: Int? = self.m_streamsCreated.firstIndex { $0 === bstream }
        if finder != nil {
            self.m_streamsCreated.remove(at: finder!)
        }

        bstream!.stream!.Free()
    }

    /**
    ```
    -------------------------
    AddTaskSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:189
    private func AddTaskSequence(_ sequence: CSequence?, _ group: CTaskGroup?) {
        self.m_taskSequences[ObjectIdentifier(group!)] = sequence
    }

    /**
    ```
    -------------------------
    GetTaskSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:200
    private func GetTaskSequence(_ group: CTaskGroup?) -> CSequence? {
        var tsi: CSequence?

        // AI: Raven finds a NULL group in the map and gets the end of the map. The Dictionary has no nil key, so a nil group returns nil here.
        if group == nil {
            return nil
        }

        tsi = self.m_taskSequences[ObjectIdentifier(group!)]

        if tsi == nil {
            return nil
        }

        return tsi
    }

    /**
    ```
    ========================
    AddSequence

    Creates and adds a sequence to the sequencer
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:220
    private func AddSequence() -> CSequence? {
        let sequence: CSequence? = self.m_owner!.GetSequence()

        if sequence == nil {
            return nil
        }

        //Add it to the list
        self.m_sequences.append(sequence!)

        //FIXME: Temp fix
        sequence!.SetFlag(SQ_PENDING)

        return sequence
    }

    /// Source: oracle/codemp/icarus/Sequencer.cpp:237
    private func AddSequence(_ parent: CSequence?, _ returnSeq: CSequence?, _ flags: Int32) -> CSequence? {
        let sequence: CSequence? = self.m_owner!.GetSequence()

        if sequence == nil {
            return nil
        }

        //Add it to the list
        self.m_sequences.append(sequence!)

        sequence!.SetFlags(flags)
        sequence!.SetParent(parent)
        sequence!.SetReturn(returnSeq)

        return sequence
    }

    /**
    ```
    ========================
    GetSequence

    Retrieves a sequence by its ID
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:263
    private func GetSequence(_ id: Int32) -> CSequence? {
        /*	sequenceID_m::iterator mi;

            mi = m_sequenceMap.find( id );

            if ( mi == m_sequenceMap.end() )
                return NULL;

            return (*mi).second;*/

        for iterSeq in self.m_sequences {
            if iterSeq.GetID() == id {
                return iterSeq
            }
        }

        return nil
    }

    /**
    ```
    -------------------------
    Interrupt
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:290
    private func Interrupt() {
        let command: CBlock? = self.m_taskManager!.GetCurrentTask()

        if command == nil {
            return
        }

        //Save it
        self.PushCommand(command, PUSH_BACK)
    }

    /**
    ```
    ========================
    Run

    Runs a script
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:308
    func Run(_ buffer: CharBuf, _ size: Int32) -> Int32 {
        var blockStream: bstream_t?

        self.Recall()

        //Create a new stream
        blockStream = self.AddStream()

        //Open the stream as an IBI stream
        if blockStream!.stream!.Open(buffer, size) == 0 {
            self.m_ie!.I_DPrintf!(WL_ERROR, "invalid stream")
            return SEQ_FAILED
        }

        let sequence: CSequence? = self.AddSequence(nil, self.m_curSequence, SQ_COMMON)

        // Interpret the command blocks and route them properly
        if S_FAILED(self.Route(sequence, blockStream)) {
            //Error code is set inside of Route()
            return SEQ_FAILED
        }

        return SEQ_OK
    }

    /**
    ```
    ========================
    ParseRun

    Parses a user triggered run command
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:344
    private func ParseRun(_ block: CBlock?) -> Int32 {
        var new_sequence: CSequence?
        var new_stream: bstream_t?
        var buffer = TextCursor()
        var newname = CharBuf(MAX_STRING_SIZE)
        var buffer_size: Int32

        //Get the name and format it
        // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
        var runName = CharBuf(block!.GetMember(0)!.GetSize())
        Com_Memcpy(&runName, block!.GetMemberData(0)!, runName.count)
        self.StripExtension(String(runName), &newname)

        //Get the file from the game engine
        buffer_size = self.m_ie!.I_LoadFile!(String(newname), &buffer)

        if buffer_size <= 0 {
            self.m_ie!.I_DPrintf!(WL_ERROR, "'%s' : could not open file\n", runName)
            return SEQ_FAILED
        }

        //Create a new stream for this file
        new_stream = self.AddStream()

        //Begin streaming the file
        if new_stream!.stream!.Open(buffer.buf, buffer_size) == 0 {
            self.m_ie!.I_DPrintf!(WL_ERROR, "invalid stream")
            return SEQ_FAILED
        }

        //Create a new sequence
        new_sequence = self.AddSequence(self.m_curSequence, self.m_curSequence, (SQ_RUN | SQ_PENDING))

        self.m_curSequence!.AddChild(new_sequence)

        // Interpret the command blocks and route them properly
        if S_FAILED(self.Route(new_sequence, new_stream)) {
            //Error code is set inside of Route()
            return SEQ_FAILED
        }

        self.m_curSequence = self.m_curSequence!.GetReturn()

        block!.Write(TK_FLOAT, Float(new_sequence!.GetID()))
        self.PushCommand(block, PUSH_FRONT)

        return SEQ_OK
    }

    /**
    ```
    ========================
    ParseIf

    Parses an if statement
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:410
    private func ParseIf(_ block: CBlock?, _ bstream: bstream_t?) -> Int32 {
        var sequence: CSequence?

        //Create the container sequence
        sequence = self.AddSequence(self.m_curSequence, self.m_curSequence, SQ_CONDITIONAL)

        if sequence == nil {
            self.m_ie!.I_DPrintf!(WL_ERROR, "ParseIf: failed to allocate container sequence")
            return SEQ_FAILED
        }

        self.m_curSequence!.AddChild(sequence)

        //Add a unique conditional identifier to the block for reference later
        block!.Write(TK_FLOAT, Float(sequence!.GetID()))

        //Push this onto the stack to mark the conditional entrance
        self.PushCommand(block, PUSH_FRONT)

        //Recursively obtain the conditional body
        self.Route(sequence, bstream)

        self.m_elseValid = 2
        self.m_elseOwner = block

        return SEQ_OK
    }

    /**
    ```
    ========================
    ParseElse

    Parses an else statement
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:451
    private func ParseElse(_ block: CBlock?, _ bstream: bstream_t?) -> Int32 {
        //The else is not retained

        var sequence: CSequence?

        //Create the container sequence
        sequence = self.AddSequence(self.m_curSequence, self.m_curSequence, SQ_CONDITIONAL)

        if sequence == nil {
            self.m_ie!.I_DPrintf!(WL_ERROR, "ParseIf: failed to allocate container sequence")
            return SEQ_FAILED
        }

        self.m_curSequence!.AddChild(sequence)

        //Add a unique conditional identifier to the block for reference later
        //TODO: Emit warning
        if self.m_elseOwner == nil {
            self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid 'else' found!\n")
            return SEQ_FAILED
        }

        self.m_elseOwner!.Write(TK_FLOAT, Float(sequence!.GetID()))

        self.m_elseOwner!.SetFlag(BF_ELSE)

        //Recursively obtain the conditional body
        self.Route(sequence, bstream)

        self.m_elseValid = 0
        self.m_elseOwner = nil

        return SEQ_OK
    }

    /**
    ```
    ========================
    ParseLoop

    Parses a loop command
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:500
    private func ParseLoop(_ block: CBlock?, _ bstream: bstream_t?) -> Int32 {
        var sequence: CSequence?
        var bm: CBlockMember?
        let min: Float
        let max: Float
        var rIter: Int32
        var memberNum: Int32 = 0

        //Set the parent
        sequence = self.AddSequence(self.m_curSequence, self.m_curSequence, (SQ_LOOP | SQ_RETAIN))

        if sequence == nil {
            self.m_ie!.I_DPrintf!(WL_ERROR, "ParseLoop : failed to allocate container sequence")
            return SEQ_FAILED
        }

        self.m_curSequence!.AddChild(sequence)

        //Set the number of iterations of this sequence

        bm = block!.GetMember(memberNum)
        memberNum += 1

        if bm!.GetID() == ID_RANDOM {
            //Parse out the random number
            min = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1
            max = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1

            rIter = Int32(self.m_ie!.I_Random!(min, max))
            sequence!.SetIterations(rIter)
        } else {
            sequence!.SetIterations(Int32(bm!.GetData()![float: 0]))
        }

        //Add a unique loop identifier to the block for reference later
        block!.Write(TK_FLOAT, Float(sequence!.GetID()))

        //Push this onto the stack to mark the loop entrance
        self.PushCommand(block, PUSH_FRONT)

        //Recursively obtain the loop
        self.Route(sequence, bstream)

        return SEQ_OK
    }

    /**
    ```
    ========================
    AddAffect

    Adds a sequence that is saved until the affect is called by the parent
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:560
    private func AddAffect(_ bstream: bstream_t?, _ retain: Int32, _ id: inout Int32) -> Int32 {
        let sequence: CSequence? = self.AddSequence()
        let new_stream = bstream_t()

        sequence!.SetFlag(SQ_AFFECT | SQ_PENDING)

        if retain != 0 {
            sequence!.SetFlag(SQ_RETAIN)
        }

        //This will be replaced once it's actually used, but this will restore the route state properly
        sequence!.SetReturn(self.m_curSequence)

        //We need this as a temp holder
        new_stream.last = self.m_curStream
        new_stream.stream = bstream!.stream

        if S_FAILED(self.Route(sequence, new_stream)) {
            return SEQ_FAILED
        }

        id = sequence!.GetID()

        sequence!.SetReturn(nil)

        return SEQ_OK
    }

    /**
    ```
    ========================
    ParseAffect

    Parses an affect command
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:597
    private func ParseAffect(_ block: CBlock?, _ bstream: bstream_t?) -> Int32 {
        var stream_sequencer: CSequencer? = nil
        var entname: CharBuf
        var ret: Int32 = 0
        var ent: JKAMP.SharedEntity? = nil

        // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
        entname = CharBuf(block!.GetMember(0)!.GetSize())
        Com_Memcpy(&entname, block!.GetMemberData(0)!, entname.count)
        ent = self.m_ie!.I_GetEntityByName!(String(entname))

        if ent == nil { // if there wasn't a valid entname in the affect, we need to check if it's a get command
            //try to parse a 'get' command that is embeded in this 'affect'

            var id: Int32
            var p1: String? = nil
            var name: CharBuf
            var bm: CBlockMember? = nil
            //
            //	Get the first parameter (this should be the get)
            //
            bm = block!.GetMember(0)
            id = bm!.GetID()

            switch id {
            // these 3 cases probably aren't necessary
            case TK_STRING, TK_IDENTIFIER, TK_CHAR:
                // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
                var p1Text = CharBuf(bm!.GetSize())
                Com_Memcpy(&p1Text, bm!.GetData()!, p1Text.count)
                p1 = String(p1Text)

            case ID_GET:
                var type: Int32

                //get( TYPE, NAME )
                type = Int32(block!.GetMemberData(1)![float: 0])
                // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
                name = CharBuf(block!.GetMember(2)!.GetSize())
                Com_Memcpy(&name, block!.GetMemberData(2)!, name.count)

                switch type { // what type are they attempting to get

                case TK_STRING:
                    //only string is acceptable for affect, store result in p1
                    // Raven's p1 is NULL here, and I_GetString sets it on success, so the call fills a text local first.
                    var p1Value = ""
                    if self.m_ie!.I_GetString!(self.m_ownerID, type, String(name), &p1Value) == 0 {
                        return 0
                    }
                    p1 = p1Value

                default:
                    //FIXME: Make an enum id for the error...
                    self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid parameter type on affect _1")
                    return 0
                }

            default:
                //FIXME: Make an enum id for the error...
                self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid parameter type on affect _2")
                return 0
            }//end id switch

            if p1 != nil {
                ent = self.m_ie!.I_GetEntityByName!(p1!)
            }
            if ent == nil {	// a valid entity name was not returned from the get command
                // Port-note: Rule 19. Raven passes no argument for the `%s`, so his vsprintf reads an unset stack word.
                // The port passes "(null)", the text his vsprintf prints for a NULL text.
                self.m_ie!.I_DPrintf!(WL_WARNING, "'%s' : invalid affect() target\n", "(null)")
            }

        } // end if(!ent)

        if ent != nil {
            stream_sequencer = gSequencers[ent!.s.number]//ent->sequencer;
        }

        if stream_sequencer == nil {
            self.m_ie!.I_DPrintf!(WL_WARNING, "'%s' : invalid affect() target\n", entname)

            //Fast-forward out of this affect block onto the next valid code
            let backSeq: CSequence? = self.m_curSequence

            let trashSeq: CSequence? = self.m_owner!.GetSequence()
            self.Route(trashSeq, bstream)
            self.Recall()
            self.DestroySequence(trashSeq)
            self.m_curSequence = backSeq
            return SEQ_OK
        }

        if S_FAILED(stream_sequencer!.AddAffect(bstream, Int32(self.m_curSequence!.HasFlag(SQ_RETAIN)), &ret)) {
            return SEQ_FAILED
        }

        //Hold onto the id for later use
        //FIXME: If the target sequence is freed, what then?		(!suspect!)

        block!.Write(TK_FLOAT, Float(ret))

        self.PushCommand(block, PUSH_FRONT)
        /*
        //Don't actually do these right now, we're just pre-processing (parsing) the affect
        if( ent )
        {	// ents need to update upon being affected
            ent->taskManager->Update();
        }
        */

        return SEQ_OK
    }

    /**
    ```
    -------------------------
    ParseTask
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:734
    private func ParseTask(_ block: CBlock?, _ bstream: bstream_t?) -> Int32 {
        var sequence: CSequence?
        var group: CTaskGroup?

        //Setup the container sequence
        sequence = self.AddSequence(self.m_curSequence, self.m_curSequence, SQ_TASK | SQ_RETAIN)
        self.m_curSequence!.AddChild(sequence)

        //Get the name of this task for reference later
        // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
        var taskName = CharBuf(block!.GetMember(0)!.GetSize())
        Com_Memcpy(&taskName, block!.GetMemberData(0)!, taskName.count)

        //Get a new task group from the task manager
        group = self.m_taskManager!.AddTaskGroup(String(taskName))

        if group == nil {
            self.m_ie!.I_DPrintf!(WL_ERROR, "error : unable to allocate a new task group")
            return SEQ_FAILED
        }

        //The current group is set to this group, all subsequent commands (until a block end) will fall into this task group
        group!.SetParent(self.m_curGroup)
        self.m_curGroup = group

        //Keep an association between this task and the container sequence
        self.AddTaskSequence(sequence, group)

        //PushCommand( block, PUSH_FRONT );

        //Recursively obtain the loop
        self.Route(sequence, bstream)

        return SEQ_OK
    }

    /**
    ```
    ========================
    Route

    Properly handles and routes commands to the sequencer
    ========================
    ```
    */
    //FIXME: Re-entering this code will produce unpredictable results if a script has already been routed and is running currently
    //FIXME: A sequencer cannot properly affect itself
    /// Source: oracle/codemp/icarus/Sequencer.cpp:787
    @discardableResult
    private func Route(_ sequence: CSequence?, _ bstream: bstream_t?) -> Int32 {
        var stream: CBlockStream?
        var block: CBlock?

        //Take the stream as the current stream
        self.m_curStream = bstream
        stream = bstream!.stream

        self.m_curSequence = sequence

        //Obtain all blocks
        while stream!.BlockAvailable() != 0 {
            block = CBlock()		//deleted in Free()
            stream!.ReadBlock(block)

            //TEMP: HACK!
            if self.m_elseValid != 0 {
                self.m_elseValid -= 1
            }

            switch block!.GetBlockID() {
            //Marks the end of a blocked section
            case ID_BLOCK_END:

                //Save this as a pre-process marker
                self.PushCommand(block, PUSH_FRONT)

                if self.m_curSequence!.HasFlag(SQ_RUN) != 0 || self.m_curSequence!.HasFlag(SQ_AFFECT) != 0 {
                    //Go back to the last stream
                    self.m_curStream = bstream!.last
                }

                if self.m_curSequence!.HasFlag(SQ_TASK) != 0 {
                    //Go back to the last stream
                    self.m_curStream = bstream!.last
                    self.m_curGroup = self.m_curGroup!.GetParent()
                }

                self.m_curSequence = self.m_curSequence!.GetReturn()

                return SEQ_OK

            //Affect pre-processor
            case ID_AFFECT:

                if S_FAILED(self.ParseAffect(block, bstream)) {
                    return SEQ_FAILED
                }

            //Run pre-processor
            case ID_RUN:

                if S_FAILED(self.ParseRun(block)) {
                    return SEQ_FAILED
                }

            //Loop pre-processor
            case ID_LOOP:

                if S_FAILED(self.ParseLoop(block, bstream)) {
                    return SEQ_FAILED
                }

            //Conditional pre-processor
            case ID_IF:

                if S_FAILED(self.ParseIf(block, bstream)) {
                    return SEQ_FAILED
                }

            case ID_ELSE:

                //TODO: Emit warning
                if self.m_elseValid == 0 {
                    self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid 'else' found!\n")
                    return SEQ_FAILED
                }

                if S_FAILED(self.ParseElse(block, bstream)) {
                    return SEQ_FAILED
                }

            case ID_TASK:

                if S_FAILED(self.ParseTask(block, bstream)) {
                    return SEQ_FAILED
                }

            //FIXME: For now this is to catch problems, but can ultimately be removed
            case ID_WAIT, ID_PRINT, ID_SOUND, ID_MOVE, ID_ROTATE, ID_SET, ID_USE, ID_REMOVE, ID_KILL, ID_FLUSH, ID_CAMERA, ID_DO, ID_DECLARE, ID_FREE, ID_SIGNAL, ID_WAITSIGNAL, ID_PLAY:

                //Commands go directly into the sequence without pre-process
                self.PushCommand(block, PUSH_FRONT)

            //Error
            default:

                self.m_ie!.I_DPrintf!(WL_ERROR, "'%d' : invalid block ID", block!.GetBlockID())

                return SEQ_FAILED
            }
        }

        //Check for a run sequence, it must be marked
        if self.m_curSequence!.HasFlag(SQ_RUN) != 0 {
            block = CBlock()
            block!.Create(ID_BLOCK_END)
            self.PushCommand(block, PUSH_FRONT)	//mark the end of the run

            /*
            //Free the stream
            m_curStream = bstream->last;
            DeleteStream( bstream );
            */

            return SEQ_OK
        }

        //Check to start the communication
        if (bstream!.last == nil) && (self.m_numCommands > 0) {
            //Everything is routed, so get it all rolling
            self.Prime(self.m_taskManager, self.PopCommand(POP_BACK))
        }

        self.m_curStream = bstream!.last

        //Free the stream
        self.DeleteStream(bstream)

        return SEQ_OK
    }

    /**
    ```
    ========================
    CheckRun

    Checks for run command pre-processing
    ========================
    ```
    */
    //Directly changes the parameter to avoid excess push/pop
    /// Source: oracle/codemp/icarus/Sequencer.cpp:961
    private func CheckRun(_ command: inout CBlock?) {
        let block: CBlock? = command

        if block == nil {
            return
        }

        //Check for a run command
        if block!.GetBlockID() == ID_RUN {
            let id = Int32(block!.GetMemberData(1)![float: 0])

            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            var runName = CharBuf(block!.GetMember(0)!.GetSize())
            Com_Memcpy(&runName, block!.GetMemberData(0)!, runName.count)
            // Port-note: Raven prints the `DWORD` of I_GetTime with `%d`, and the format takes no UInt32, so the call needs a conversion Raven did not write.
            // Raven wrote: m_ie->I_DPrintf( WL_DEBUG, "%4d run( \"%s\" ); [%d]", m_ownerID, (char *) block->GetMemberData(0), m_ie->I_GetTime() );
            portMissing("CSequencer::CheckRun", source: "oracle/codemp/icarus/Sequencer.cpp:961")

            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            self.m_curSequence = self.GetSequence(id)

            //TODO: Emit warning
            if self.m_curSequence == nil {
                self.m_ie!.I_DPrintf!(WL_ERROR, "Unable to find 'run' sequence!\n")
                command = nil
                return
            }

            if self.m_curSequence!.GetNumCommands() > 0 {
                command = self.PopCommand(POP_BACK)

                self.Prep(&command)	//Account for any other pre-processes
                return
            }

            return
        }

        //Check for the end of a run
        if (block!.GetBlockID() == ID_BLOCK_END) && (self.m_curSequence!.HasFlag(SQ_RUN) != 0) {
            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            self.m_curSequence = self.ReturnSequence(self.m_curSequence)

            if self.m_curSequence != nil && self.m_curSequence!.GetNumCommands() > 0 {
                command = self.PopCommand(POP_BACK)

                self.Prep(&command)	//Account for any other pre-processes
                return
            }

            //FIXME: Check this...
        }
    }

    /**
    ```
    -------------------------
    EvaluateConditional
    -------------------------
    ```
    */
    //FIXME: This function will be written better later once the functionality of the ideas here are tested
    /// Source: oracle/codemp/icarus/Sequencer.cpp:1045
    private func EvaluateConditional(_ block: CBlock?) -> Int32 {
        var bm: CBlockMember?
        var tempString1 = CharBuf(128)
        var tempString2 = CharBuf(128)
        var vec = vec3_t()
        var id: Int32
        var i: Int32
        var oper: Int32
        var memberNum: Int32 = 0
        var p1: String? = nil
        var p2: String? = nil
        var t1: Int32
        var t2: Int32

        //
        //	Get the first parameter
        //

        bm = block!.GetMember(memberNum)
        memberNum += 1
        id = bm!.GetID()
        t1 = id

        switch id {
        case TK_FLOAT:
            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
            Com_sprintf(&tempString1, 128, "%.3f", bm!.GetData()![float: 0])
            p1 = String(tempString1)

        case TK_VECTOR:

            tempString1[0] = 0

            i = 0
            while i < 3 {
                bm = block!.GetMember(memberNum)
                memberNum += 1
                vec[i] = bm!.GetData()![float: 0]
                i += 1
            }

            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
            Com_sprintf(&tempString1, 128, "%.3f %.3f %.3f", vec[0], vec[1], vec[2])
            p1 = String(tempString1)

        case TK_STRING, TK_IDENTIFIER, TK_CHAR:

            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            var p1Text = CharBuf(bm!.GetSize())
            Com_Memcpy(&p1Text, bm!.GetData()!, p1Text.count)
            p1 = String(p1Text)

        case ID_GET:
            var type: Int32
            var name: CharBuf

            //get( TYPE, NAME )
            type = Int32(block!.GetMemberData(memberNum)![float: 0])
            memberNum += 1
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            name = CharBuf(block!.GetMember(memberNum)!.GetSize())
            Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
            memberNum += 1

            //Get the type returned and hold onto it
            t1 = type

            switch type {
            case TK_FLOAT:
                var fVal: Float = 0

                if self.m_ie!.I_GetFloat!(self.m_ownerID, type, String(name), &fVal) == 0 {
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
                Com_sprintf(&tempString1, 128, "%.3f", fVal)
                p1 = String(tempString1)

            case TK_INT:
                var fVal: Float = 0

                if self.m_ie!.I_GetFloat!(self.m_ownerID, type, String(name), &fVal) == 0 {
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
                Com_sprintf(&tempString1, 128, "%d", Int32(fVal))
                p1 = String(tempString1)

            case TK_STRING:

                // Raven's p1 is NULL here, and I_GetString sets it on success, so the call fills a text local first.
                var p1Value = ""
                if self.m_ie!.I_GetString!(self.m_ownerID, type, String(name), &p1Value) == 0 {
                    return 0
                }
                p1 = p1Value

            case TK_VECTOR:
                var vVal = vec3_t()

                if self.m_ie!.I_GetVector!(self.m_ownerID, type, String(name), &vVal) == 0 {
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
                Com_sprintf(&tempString1, 128, "%.3f %.3f %.3f", vVal[0], vVal[1], vVal[2])
                p1 = String(tempString1)

            default:
                break
            }

        case ID_RANDOM:
            let min: Float
            let max: Float
            //FIXME: This will not account for nested random() statements

            min = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1
            max = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1

            //A float value is returned from the function
            t1 = TK_FLOAT

            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
            Com_sprintf(&tempString1, 128, "%.3f", self.m_ie!.I_Random!(min, max))
            p1 = String(tempString1)

        case ID_TAG:
            var name: CharBuf
            let type: Float

            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            name = CharBuf(block!.GetMember(memberNum)!.GetSize())
            Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
            memberNum += 1
            type = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1

            t1 = TK_VECTOR

            //TODO: Emit warning
            if self.m_ie!.I_GetTag!(self.m_ownerID, String(name), Int32(type), &vec) == 0 {
                self.m_ie!.I_DPrintf!(WL_ERROR, "Unable to find tag \"%s\"!\n", name)
                return 0
            }

            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
            Com_sprintf(&tempString1, 128, "%.3f %.3f %.3f", vec[0], vec[1], vec[2])
            p1 = String(tempString1)

        default:
            //FIXME: Make an enum id for the error...
            self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid parameter type on conditional")
            return 0
        }

        //
        //	Get the comparison operator
        //

        bm = block!.GetMember(memberNum)
        memberNum += 1
        id = bm!.GetID()

        switch id {
        case TK_EQUALS, TK_GREATER_THAN, TK_LESS_THAN, TK_NOT:
            oper = id

        default:
            self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid operator type found on conditional!\n")
            return 0	//FIXME: Emit warning
        }

        //
        //	Get the second parameter
        //

        bm = block!.GetMember(memberNum)
        memberNum += 1
        id = bm!.GetID()
        t2 = id

        switch id {
        case TK_FLOAT:
            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
            Com_sprintf(&tempString2, 128, "%.3f", bm!.GetData()![float: 0])
            p2 = String(tempString2)

        case TK_VECTOR:

            tempString2[0] = 0

            i = 0
            while i < 3 {
                bm = block!.GetMember(memberNum)
                memberNum += 1
                vec[i] = bm!.GetData()![float: 0]
                i += 1
            }

            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
            Com_sprintf(&tempString2, 128, "%.3f %.3f %.3f", vec[0], vec[1], vec[2])
            p2 = String(tempString2)

        case TK_STRING, TK_IDENTIFIER, TK_CHAR:

            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            var p2Text = CharBuf(bm!.GetSize())
            Com_Memcpy(&p2Text, bm!.GetData()!, p2Text.count)
            p2 = String(p2Text)

        case ID_GET:
            var type: Int32
            var name: CharBuf

            //get( TYPE, NAME )
            type = Int32(block!.GetMemberData(memberNum)![float: 0])
            memberNum += 1
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            name = CharBuf(block!.GetMember(memberNum)!.GetSize())
            Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
            memberNum += 1

            //Get the type returned and hold onto it
            t2 = type

            switch type {
            case TK_FLOAT:
                var fVal: Float = 0

                if self.m_ie!.I_GetFloat!(self.m_ownerID, type, String(name), &fVal) == 0 {
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
                Com_sprintf(&tempString2, 128, "%.3f", fVal)
                p2 = String(tempString2)

            case TK_INT:
                var fVal: Float = 0

                if self.m_ie!.I_GetFloat!(self.m_ownerID, type, String(name), &fVal) == 0 {
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
                Com_sprintf(&tempString2, 128, "%d", Int32(fVal))
                p2 = String(tempString2)

            case TK_STRING:

                // Raven's p2 is NULL here, and I_GetString sets it on success, so the call fills a text local first.
                var p2Value = ""
                if self.m_ie!.I_GetString!(self.m_ownerID, type, String(name), &p2Value) == 0 {
                    return 0
                }
                p2 = p2Value

            case TK_VECTOR:
                var vVal = vec3_t()

                if self.m_ie!.I_GetVector!(self.m_ownerID, type, String(name), &vVal) == 0 {
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
                Com_sprintf(&tempString2, 128, "%.3f %.3f %.3f", vVal[0], vVal[1], vVal[2])
                p2 = String(tempString2)

            default:
                break
            }

        case ID_RANDOM:
            let min: Float
            let max: Float
            //FIXME: This will not account for nested random() statements

            min = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1
            max = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1

            //A float value is returned from the function
            t2 = TK_FLOAT

            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
            Com_sprintf(&tempString2, 128, "%.3f", self.m_ie!.I_Random!(min, max))
            p2 = String(tempString2)

        case ID_TAG:
            var name: CharBuf
            let type: Float

            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            name = CharBuf(block!.GetMember(memberNum)!.GetSize())
            Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
            memberNum += 1
            type = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1

            t2 = TK_VECTOR

            //TODO: Emit warning
            if self.m_ie!.I_GetTag!(self.m_ownerID, String(name), Int32(type), &vec) == 0 {
                self.m_ie!.I_DPrintf!(WL_ERROR, "Unable to find tag \"%s\"!\n", name)
                return 0
            }

            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of the buffer.
            Com_sprintf(&tempString2, 128, "%.3f %.3f %.3f", vec[0], vec[1], vec[2])
            p2 = String(tempString2)

        default:
            //FIXME: Make an enum id for the error...
            self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid parameter type on conditional")
            return 0
        }

        return self.m_ie!.I_Evaluate!(t1, p1!, t2, p2!, oper)
    }

    /**
    ```
    ========================
    CheckIf

    Checks for if statement pre-processing
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:1385
    private func CheckIf(_ command: inout CBlock?) {
        let block: CBlock? = command
        var successID: Int32
        var failureID: Int32
        var successSeq: CSequence?
        var failureSeq: CSequence?

        if block == nil {
            return
        }

        if block!.GetBlockID() == ID_IF {
            let ret: Int32 = self.EvaluateConditional(block)

            if ret != 0 /*TRUE*/ {
                if block!.HasFlag(BF_ELSE) != 0 {
                    successID = Int32(block!.GetMemberData(block!.GetNumMembers() - 2)![float: 0])
                } else {
                    successID = Int32(block!.GetMemberData(block!.GetNumMembers() - 1)![float: 0])
                }

                successSeq = self.GetSequence(successID)

                //TODO: Emit warning
                if successSeq == nil {
                    self.m_ie!.I_DPrintf!(WL_ERROR, "Unable to find conditional success sequence!\n")
                    command = nil
                    return
                }

                //Only save the conditional statement if the calling sequence is retained
                if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                    self.PushCommand(block, PUSH_FRONT)
                } else {
                    command = nil
                }

                self.m_curSequence = successSeq

                //Recursively work out any other pre-processors
                command = self.PopCommand(POP_BACK)
                self.Prep(&command)

                return
            }

            if (ret == 0) && (block!.HasFlag(BF_ELSE) != 0) {
                failureID = Int32(block!.GetMemberData(block!.GetNumMembers() - 1)![float: 0])
                failureSeq = self.GetSequence(failureID)

                //TODO: Emit warning
                if failureSeq == nil {
                    self.m_ie!.I_DPrintf!(WL_ERROR, "Unable to find conditional failure sequence!\n")
                    command = nil
                    return
                }

                //Only save the conditional statement if the calling sequence is retained
                if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                    self.PushCommand(block, PUSH_FRONT)
                } else {
                    command = nil
                }

                self.m_curSequence = failureSeq

                //Recursively work out any other pre-processors
                command = self.PopCommand(POP_BACK)
                self.Prep(&command)

                return
            }

            //Only save the conditional statement if the calling sequence is retained
            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            //Conditional failed, just move on to the next command
            command = self.PopCommand(POP_BACK)
            self.Prep(&command)

            return
        }

        if (block!.GetBlockID() == ID_BLOCK_END) && (self.m_curSequence!.HasFlag(SQ_CONDITIONAL) != 0) {
            if self.m_curSequence!.GetReturn() == nil {
                command = nil
                return
            }

            //Check to retain it
            if self.m_curSequence!.GetParent()!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            //Back out of the conditional and resume the previous sequence
            self.m_curSequence = self.ReturnSequence(self.m_curSequence)

            //This can safely happen
            if self.m_curSequence == nil {
                command = nil
                return
            }

            command = self.PopCommand(POP_BACK)
            self.Prep(&command)
        }
    }

    /**
    ```
    ========================
    CheckLoop

    Checks for loop command pre-processing
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:1539
    private func CheckLoop(_ command: inout CBlock?) {
        var bm: CBlockMember?
        let block: CBlock? = command
        let min: Float
        let max: Float
        var iterations: Int32
        var loopID: Int32
        var memberNum: Int32 = 0

        if block == nil {
            return
        }

        //Check for a loop
        if block!.GetBlockID() == ID_LOOP {
            //Get the loop ID
            bm = block!.GetMember(memberNum)
            memberNum += 1

            if bm!.GetID() == ID_RANDOM {
                //Parse out the random number
                min = block!.GetMemberData(memberNum)![float: 0]
                memberNum += 1
                max = block!.GetMemberData(memberNum)![float: 0]
                memberNum += 1

                iterations = Int32(self.m_ie!.I_Random!(min, max))
            } else {
                iterations = Int32(bm!.GetData()![float: 0])
            }

            loopID = Int32(block!.GetMemberData(memberNum)![float: 0])
            memberNum += 1

            let loop: CSequence? = self.GetSequence(loopID)

            //TODO: Emit warning
            if loop == nil {
                self.m_ie!.I_DPrintf!(WL_ERROR, "Unable to find 'loop' sequence!\n")
                command = nil
                return
            }

            if loop!.GetParent() == nil {
                command = nil
                return
            }

            //Restore the count if it has been lost
            loop!.SetIterations(iterations)

            //Only save the loop command if the calling sequence is retained
            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            self.m_curSequence = loop

            //Recursively work out any other pre-processors
            command = self.PopCommand(POP_BACK)
            self.Prep(&command)

            return
        }

        //Check for the end of the loop
        if (block!.GetBlockID() == ID_BLOCK_END) && (self.m_curSequence!.HasFlag(SQ_LOOP) != 0) {
            //We don't want to decrement -1
            if self.m_curSequence!.GetIterations() > 0 {
                self.m_curSequence!.SetIterations(self.m_curSequence!.GetIterations() - 1)	//Nice, eh?
            }

            //Either there's another iteration, or it's infinite
            if self.m_curSequence!.GetIterations() != 0 {
                //Another iteration is going to happen, so this will need to be considered again
                self.PushCommand(block, PUSH_FRONT)

                command = self.PopCommand(POP_BACK)
                self.Prep(&command)

                return
            } else {
                if self.m_curSequence!.GetReturn() == nil {
                    command = nil
                    return
                }

                //Check to retain it
                if self.m_curSequence!.GetParent()!.HasFlag(SQ_RETAIN) != 0 {
                    self.PushCommand(block, PUSH_FRONT)
                } else {
                    command = nil
                }

                //Back out of the loop and resume the previous sequence
                self.m_curSequence = self.ReturnSequence(self.m_curSequence)

                //This can safely happen
                if self.m_curSequence == nil {
                    command = nil
                    return
                }

                command = self.PopCommand(POP_BACK)
                self.Prep(&command)
            }
        }
    }

    /**
    ```
    ========================
    CheckFlush

    Checks for flush command pre-processing
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:1677
    private func CheckFlush(_ command: inout CBlock?) {
        let block: CBlock? = command

        if block == nil {
            return
        }

        if block!.GetBlockID() == ID_FLUSH {
            //Flush the sequence
            self.Flush(self.m_curSequence)

            //Check to retain it
            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            command = self.PopCommand(POP_BACK)
            self.Prep(&command)

            return
        }
    }

    /**
    ```
    ========================
    CheckAffect

    Checks for affect command pre-processing
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:1717
    private func CheckAffect(_ command: inout CBlock?) {
        let block: CBlock? = command
        var ent: JKAMP.SharedEntity? = nil
        var entname: CharBuf
        var memberNum: Int32 = 0

        if block == nil {
            return
        }

        if block!.GetBlockID() == ID_AFFECT {
            var sequencer: CSequencer? = nil
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            entname = CharBuf(block!.GetMember(memberNum)!.GetSize())
            Com_Memcpy(&entname, block!.GetMemberData(memberNum)!, entname.count)
            memberNum += 1
            ent = self.m_ie!.I_GetEntityByName!(String(entname))

            if ent == nil { // if there wasn't a valid entname in the affect, we need to check if it's a get command
                //try to parse a 'get' command that is embeded in this 'affect'

                var id: Int32
                var p1: String? = nil
                var name: CharBuf
                var bm: CBlockMember? = nil
                //
                //	Get the first parameter (this should be the get)
                //
                bm = block!.GetMember(0)
                id = bm!.GetID()

                switch id {
                // these 3 cases probably aren't necessary
                case TK_STRING, TK_IDENTIFIER, TK_CHAR:
                    // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
                    var p1Text = CharBuf(bm!.GetSize())
                    Com_Memcpy(&p1Text, bm!.GetData()!, p1Text.count)
                    p1 = String(p1Text)

                case ID_GET:
                    var type: Int32

                    //get( TYPE, NAME )
                    type = Int32(block!.GetMemberData(memberNum)![float: 0])
                    memberNum += 1
                    // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
                    name = CharBuf(block!.GetMember(memberNum)!.GetSize())
                    Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
                    memberNum += 1

                    switch type { // what type are they attempting to get

                    case TK_STRING:
                        //only string is acceptable for affect, store result in p1
                        // Raven's p1 is NULL here, and I_GetString sets it on success, so the call fills a text local first.
                        var p1Value = ""
                        if self.m_ie!.I_GetString!(self.m_ownerID, type, String(name), &p1Value) == 0 {
                            return
                        }
                        p1 = p1Value

                    default:
                        //FIXME: Make an enum id for the error...
                        self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid parameter type on affect _1")
                        return
                    }

                default:
                    //FIXME: Make an enum id for the error...
                    self.m_ie!.I_DPrintf!(WL_ERROR, "Invalid parameter type on affect _2")
                    return
                }//end id switch

                if p1 != nil {
                    ent = self.m_ie!.I_GetEntityByName!(p1!)
                }
                if ent == nil {	// a valid entity name was not returned from the get command
                    // Port-note: Rule 19. Raven passes no argument for the `%s`, so his vsprintf reads an unset stack word.
                    // The port passes "(null)", the text his vsprintf prints for a NULL text.
                    self.m_ie!.I_DPrintf!(WL_WARNING, "'%s' : invalid affect() target\n", "(null)")
                }

            } // end if(!ent)

            if ent != nil {
                sequencer = gSequencers[ent!.s.number]//ent->sequencer;
            }
            if memberNum == 0 {	//there was no get, increment manually before next step
                memberNum += 1
            }
            let type = Int32(block!.GetMemberData(memberNum)![float: 0])
            let id = Int32(block!.GetMemberData(memberNum + 1)![float: 0])

            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            //NOTENOTE: If this isn't found, continue on to the next command
            if sequencer == nil {
                command = self.PopCommand(POP_BACK)
                self.Prep(&command)
                return
            }

            sequencer!.Affect(id, type)

            command = self.PopCommand(POP_BACK)
            self.Prep(&command)
            if ent != nil {	// ents need to update upon being affected
                //ent->taskManager->Update();
                gTaskManagers[ent!.s.number]!.Update()
            }

            return
        }

        if (block!.GetBlockID() == ID_BLOCK_END) && (self.m_curSequence!.HasFlag(SQ_AFFECT) != 0) {
            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            self.m_curSequence = self.ReturnSequence(self.m_curSequence)

            if self.m_curSequence == nil {
                command = nil
                return
            }

            command = self.PopCommand(POP_BACK)
            self.Prep(&command)
            if ent != nil {	// ents need to update upon being affected
                //ent->taskManager->Update();
                gTaskManagers[ent!.s.number]!.Update()
            }
        }
    }

    /**
    ```
    -------------------------
    CheckDo
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:1885
    private func CheckDo(_ command: inout CBlock?) {
        let block: CBlock? = command

        if block == nil {
            return
        }

        if block!.GetBlockID() == ID_DO {
            //Get the sequence
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            var groupName = CharBuf(block!.GetMember(0)!.GetSize())
            Com_Memcpy(&groupName, block!.GetMemberData(0)!, groupName.count)
            let group: CTaskGroup? = self.m_taskManager!.GetTaskGroup(String(groupName))
            let sequence: CSequence? = self.GetTaskSequence(group)

            //TODO: Emit warning
            if group == nil {
                //TODO: Give name/number of entity trying to execute, too
                self.m_ie!.I_DPrintf!(WL_ERROR, "ICARUS Unable to find task group \"%s\"!\n", groupName)
                command = nil
                return
            }

            //TODO: Emit warning
            if sequence == nil {
                //TODO: Give name/number of entity trying to execute, too
                self.m_ie!.I_DPrintf!(WL_ERROR, "ICARUS Unable to find task 'group' sequence!\n", groupName)
                command = nil
                return
            }

            //Only save the loop command if the calling sequence is retained
            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            //Set this to our current sequence
            sequence!.SetReturn(self.m_curSequence)
            self.m_curSequence = sequence

            group!.SetParent(self.m_curGroup)
            self.m_curGroup = group

            //Mark all the following commands as being in the task
            self.m_taskManager!.MarkTask(group!.GetGUID(), TASK_START)

            //Recursively work out any other pre-processors
            command = self.PopCommand(POP_BACK)
            self.Prep(&command)

            return
        }

        if (block!.GetBlockID() == ID_BLOCK_END) && (self.m_curSequence!.HasFlag(SQ_TASK) != 0) {
            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {
                self.PushCommand(block, PUSH_FRONT)
            } else {
                command = nil
            }

            self.m_taskManager!.MarkTask(self.m_curGroup!.GetGUID(), TASK_END)
            self.m_curGroup = self.m_curGroup!.GetParent()

            let returnSeq: CSequence? = self.ReturnSequence(self.m_curSequence)
            self.m_curSequence!.SetReturn(nil)
            self.m_curSequence = returnSeq

            if self.m_curSequence == nil {
                command = nil
                return
            }

            command = self.PopCommand(POP_BACK)
            self.Prep(&command)
        }
    }

    /**
    ```
    ========================
    Prep

    Handles internal sequencer maintenance
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:1987
    private func Prep(_ command: inout CBlock?) {
        //Check all pre-processes
        self.CheckAffect(&command)
        self.CheckFlush(&command)
        self.CheckLoop(&command)
        self.CheckRun(&command)
        self.CheckIf(&command)
        self.CheckDo(&command)
    }

    /**
    ```
    ========================
    Prime

    Starts communication between the task manager and this sequencer
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2006
    @discardableResult
    private func Prime(_ taskManager: CTaskManager?, _ command: CBlock?) -> Int32 {
        var command = command

        self.Prep(&command)

        if command != nil {
            taskManager!.SetCommand(command, PUSH_BACK)
        }

        return SEQ_OK
    }

    /**
    ```
    ========================
    Callback

    Handles a completed task and returns a new task to be completed
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2026
    func Callback(_ taskManager: CTaskManager?, _ block: CBlock?, _ returnCode: Int32) -> Int32 {
        var command: CBlock?

        if returnCode == TASK_RETURN_COMPLETE {
            //There are no more pending commands
            if self.m_curSequence == nil {
                return SEQ_OK
            }

            //Check to retain the command
            if self.m_curSequence!.HasFlag(SQ_RETAIN) != 0 {	//This isn't true for affect sequences...?
                self.PushCommand(block, PUSH_FRONT)
            }

            //Check for pending commands
            if self.m_curSequence!.GetNumCommands() <= 0 {
                if self.m_curSequence!.GetReturn() == nil {
                    return SEQ_OK
                }

                self.m_curSequence = self.m_curSequence!.GetReturn()
            }

            command = self.PopCommand(POP_BACK)
            self.Prep(&command)

            if command != nil {
                taskManager!.SetCommand(command, PUSH_FRONT)
            }

            return SEQ_OK
        }

        //FIXME: This could be more descriptive
        self.m_ie!.I_DPrintf!(WL_ERROR, "command could not be called back\n")

        return SEQ_FAILED
    }

    /**
    ```
    -------------------------
    Recall
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2082
    @discardableResult
    func Recall() -> Int32 {
        var block: CBlock? = nil

        if self.m_taskManager == nil {
            //uh.. ok.
            return 1
        }

        while let next = self.m_taskManager!.RecallTask() {
            block = next
            if self.m_curSequence != nil {
                self.PushCommand(block, PUSH_BACK)
            } else {
                block = nil
            }
        }

        return 1
    }

    /**
    ```
    -------------------------
    Affect
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2114
    @discardableResult
    private func Affect(_ id: Int32, _ type: Int32) -> Int32 {
        let sequence: CSequence? = self.GetSequence(id)

        if sequence == nil {
            return SEQ_FAILED
        }

        switch type {

        case TYPE_FLUSH:

            //Get rid of all old code
            self.Flush(sequence)

            sequence!.RemoveFlag(SQ_PENDING, true)

            self.m_curSequence = sequence

            self.Prime(self.m_taskManager, self.PopCommand(POP_BACK))

        case TYPE_INSERT:

            self.Recall()

            sequence!.SetReturn(self.m_curSequence)

            sequence!.RemoveFlag(SQ_PENDING, true)

            self.m_curSequence = sequence

            self.Prime(self.m_taskManager, self.PopCommand(POP_BACK))

        default:
            self.m_ie!.I_DPrintf!(WL_ERROR, "unknown affect type found")
        }

        return SEQ_OK
    }

    /**
    ```
    ========================
    PushCommand

    Pushes a commands onto the current sequence
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2170
    @discardableResult
    private func PushCommand(_ command: CBlock?, _ flag: Int32) -> Int32 {
        //Make sure everything is ok
        if self.m_curSequence == nil {
            return SEQ_FAILED
        }

        self.m_curSequence!.PushCommand(command, flag)
        self.m_numCommands += 1

        //Invalid flag
        return SEQ_OK
    }

    /**
    ```
    ========================
    PopCommand

    Pops a command off the current sequence
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2192
    private func PopCommand(_ flag: Int32) -> CBlock? {
        //Make sure everything is ok
        if self.m_curSequence == nil {
            return nil
        }

        let block: CBlock? = self.m_curSequence!.PopCommand(flag)

        if block != nil {
            self.m_numCommands -= 1
        }

        return block
    }

    /**
    ```
    ========================
    StripExtension

    Filename ultility.  Probably get rid of this if I decided to use CStrings...
    ========================
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2215
    private func StripExtension(_ `in`: String, _ out: inout CharBuf) {
        let `in` = CharBuf(`in`)
        var i: Int32 = strlen(`in`) + 1

        // Port-note: Raven starts one byte past the NUL and ends at -1 before the string, and both reads are outside the string.
        // The port takes the first byte as no dot and stops at -1 with no read, so the loop ends where Raven's loop ends.
        while (i >= 0) && (i >= `in`.count || `in`[i] != Int32(ascii: ".")) {
            i -= 1
        }

        if i < 0 {
            strcpy(&out, `in`)
            return
        }

        strncpy(&out, `in`, i)
    }

    /**
    ```
    -------------------------
    RemoveSequence
    -------------------------
    ```
    */
    //NOTENOTE: This only removes references to the sequence, IT DOES NOT FREE THE ALLOCATED MEMORY!  You've be warned! =)
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2240
    @discardableResult
    private func RemoveSequence(_ sequence: CSequence?) -> Int32 {
        var temp: CSequence?

        let numChildren: Int32 = sequence!.GetNumChildren()

        //Add all the children
        var i: Int32 = 0
        while i < numChildren {
            temp = sequence!.GetChildByIndex(i)

            //TODO: Emit warning
            if temp == nil {
                self.m_ie!.I_DPrintf!(WL_WARNING, "Unable to find child sequence on RemoveSequence call!\n")
                i += 1
                continue
            }

            //Remove the references to this sequence
            temp!.SetParent(nil)
            temp!.SetReturn(nil)

            i += 1
        }

        return SEQ_OK
    }

    /// Source: oracle/codemp/icarus/Sequencer.cpp:2268
    @discardableResult
    private func DestroySequence(_ sequence: CSequence?) -> Int32 {
        if sequence == nil {
            return SEQ_FAILED
        }

        //m_sequenceMap.erase( sequence->GetID() );
        self.m_sequences.removeAll { $0 === sequence }

        for tsi in self.m_taskSequences {
            if tsi.value === sequence {
                self.m_taskSequences.removeValue(forKey: tsi.key)
            }
        }

        let parent: CSequence? = sequence!.GetParent()
        if parent != nil {
            parent!.RemoveChild(sequence)
        }

        var curChild: Int32 = sequence!.GetNumChildren()
        while curChild != 0 {
            // Stop if we're about to go negative (invalid index!).
            if curChild > 0 {
                curChild -= 1
                self.DestroySequence(sequence!.GetChildByIndex(curChild))
            } else {
                break
            }
        }

        self.m_owner!.DeleteSequence(sequence)

        return SEQ_OK
    }

    /**
    ```
    -------------------------
    ReturnSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2319
    private func ReturnSequence(_ sequence: CSequence?) -> CSequence? {
        var sequence = sequence

        while sequence!.GetReturn() != nil {
            if sequence === sequence!.GetReturn() {
                return nil
            }

            sequence = sequence!.GetReturn()

            if sequence!.GetNumCommands() > 0 {
                return sequence
            }
        }
        return nil
    }

    //Save / Load
    /**
    ```
    -------------------------
    Save
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2343
    @discardableResult
    func Save() -> Int32 {
        return 0
    }

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2406
    @discardableResult
    func Load() -> Int32 {
        return 0
    }

    /// Source: oracle/codemp/icarus/sequencer.h:86
    func GetOwner() -> ICARUS_Instance? {
        self.m_owner
    }

    /// Source: oracle/codemp/icarus/sequencer.h:88
    func SetOwnerID(_ owner: Int32) {
        self.m_ownerID = owner
    }

    /// Source: oracle/codemp/icarus/sequencer.h:90
    func GetOwnerID() -> Int32 {
        self.m_ownerID
    }

    /// Source: oracle/codemp/icarus/sequencer.h:91
    func GetInterface() -> interface_export_t? {
        self.m_ie
    }

    /// Source: oracle/codemp/icarus/sequencer.h:92
    func GetTaskManager() -> CTaskManager? {
        self.m_taskManager
    }

    /// Source: oracle/codemp/icarus/sequencer.h:94
    func SetTaskManager(_ tm: CTaskManager?) {
        if let tm {
            self.m_taskManager = tm
        }
    }
}
