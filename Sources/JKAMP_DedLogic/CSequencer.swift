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
        // TODO: Port CSequencer::Init
        portMissing("CSequencer::Init", source: "oracle/codemp/icarus/Sequencer.cpp:56")
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
            // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
            // Raven wrote: m_ie->I_DPrintf( WL_ERROR, "invalid stream" );
            portMissing("CSequencer::Run", source: "oracle/codemp/icarus/Sequencer.cpp:308")
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func ParseRun(_ block: CBlock?) -> Int32 {
        // TODO: Port CSequencer::ParseRun
        portMissing("CSequencer::ParseRun", source: "oracle/codemp/icarus/Sequencer.cpp:344")
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
            // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
            // Raven wrote: m_ie->I_DPrintf( WL_ERROR, "ParseIf: failed to allocate container sequence" );
            portMissing("CSequencer::ParseIf", source: "oracle/codemp/icarus/Sequencer.cpp:410")
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
            // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
            // Raven wrote: m_ie->I_DPrintf( WL_ERROR, "ParseIf: failed to allocate container sequence" );
            portMissing("CSequencer::ParseElse", source: "oracle/codemp/icarus/Sequencer.cpp:451")
            return SEQ_FAILED
        }

        self.m_curSequence!.AddChild(sequence)

        //Add a unique conditional identifier to the block for reference later
        //TODO: Emit warning
        if self.m_elseOwner == nil {
            // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
            // Raven wrote: m_ie->I_DPrintf( WL_ERROR, "Invalid 'else' found!\n" );
            portMissing("CSequencer::ParseElse", source: "oracle/codemp/icarus/Sequencer.cpp:451")
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func ParseLoop(_ block: CBlock?, _ bstream: bstream_t?) -> Int32 {
        // TODO: Port CSequencer::ParseLoop
        portMissing("CSequencer::ParseLoop", source: "oracle/codemp/icarus/Sequencer.cpp:500")
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func ParseAffect(_ block: CBlock?, _ bstream: bstream_t?) -> Int32 {
        // TODO: Port CSequencer::ParseAffect
        portMissing("CSequencer::ParseAffect", source: "oracle/codemp/icarus/Sequencer.cpp:597")
    }

    /**
    ```
    -------------------------
    ParseTask
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:734
    // Port-note: The body reads the task name as block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func ParseTask(_ block: CBlock?, _ bstream: bstream_t?) -> Int32 {
        // TODO: Port CSequencer::ParseTask
        portMissing("CSequencer::ParseTask", source: "oracle/codemp/icarus/Sequencer.cpp:734")
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
                    // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
                    // Raven wrote: m_ie->I_DPrintf( WL_ERROR, "Invalid 'else' found!\n" );
                    portMissing("CSequencer::Route", source: "oracle/codemp/icarus/Sequencer.cpp:787")
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

                // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
                // Raven wrote: m_ie->I_DPrintf( WL_ERROR, "'%d' : invalid block ID", block->GetBlockID() );
                portMissing("CSequencer::Route", source: "oracle/codemp/icarus/Sequencer.cpp:787")

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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func CheckRun(_ command: inout CBlock?) {
        // TODO: Port CSequencer::CheckRun
        portMissing("CSequencer::CheckRun", source: "oracle/codemp/icarus/Sequencer.cpp:961")
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func EvaluateConditional(_ block: CBlock?) -> Int32 {
        // TODO: Port CSequencer::EvaluateConditional
        portMissing("CSequencer::EvaluateConditional", source: "oracle/codemp/icarus/Sequencer.cpp:1045")
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func CheckIf(_ command: inout CBlock?) {
        // TODO: Port CSequencer::CheckIf
        portMissing("CSequencer::CheckIf", source: "oracle/codemp/icarus/Sequencer.cpp:1385")
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func CheckLoop(_ command: inout CBlock?) {
        // TODO: Port CSequencer::CheckLoop
        portMissing("CSequencer::CheckLoop", source: "oracle/codemp/icarus/Sequencer.cpp:1539")
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func CheckAffect(_ command: inout CBlock?) {
        // TODO: Port CSequencer::CheckAffect
        portMissing("CSequencer::CheckAffect", source: "oracle/codemp/icarus/Sequencer.cpp:1717")
    }

    /**
    ```
    -------------------------
    CheckDo
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:1885
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through `m_ie`.
    private func CheckDo(_ command: inout CBlock?) {
        // TODO: Port CSequencer::CheckDo
        portMissing("CSequencer::CheckDo", source: "oracle/codemp/icarus/Sequencer.cpp:1885")
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
        // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
        // Raven wrote: m_ie->I_DPrintf( WL_ERROR,  "command could not be called back\n" );
        portMissing("CSequencer::Callback", source: "oracle/codemp/icarus/Sequencer.cpp:2026")

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
            // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
            // Raven wrote: m_ie->I_DPrintf( WL_ERROR, "unknown affect type found" );
            portMissing("CSequencer::Affect", source: "oracle/codemp/icarus/Sequencer.cpp:2114")
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
                // Port-note: The call goes through `m_ie`, and `interface_export_t` has no Swift form.
                // Raven wrote: m_ie->I_DPrintf( WL_WARNING, "Unable to find child sequence on RemoveSequence call!\n" );
                portMissing("CSequencer::RemoveSequence", source: "oracle/codemp/icarus/Sequencer.cpp:2240")
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
