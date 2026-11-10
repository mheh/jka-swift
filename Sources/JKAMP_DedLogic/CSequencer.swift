import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

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
    // TODO: Port m_ie
    // Raven wrote: interface_export_t	*m_ie;				//This is unique to the sequencer so that client side and server side sequencers could both
    // Raven wrote: //operate under different interfaces (for client side scripting)

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
        // TODO: Port CSequencer::CSequencer
        portMissing("CSequencer::CSequencer", source: "oracle/codemp/icarus/Sequencer.cpp:16")
    }

    /// Source: oracle/codemp/icarus/Sequencer.cpp:29
    deinit {
        // TODO: Port CSequencer::~CSequencer
        portMissing("CSequencer::~CSequencer", source: "oracle/codemp/icarus/Sequencer.cpp:29")
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
        // TODO: Port CSequencer::Create
        portMissing("CSequencer::Create", source: "oracle/codemp/icarus/Sequencer.cpp:42")
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
    // TODO: Port signature
    // Raven wrote: int CSequencer::Init( int ownerID, interface_export_t *ie, CTaskManager *taskManager, ICARUS_Instance *iICARUS )
    // No table row for `interface_export_t *`.
    func Init() -> Never {
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
    func Free() -> Int32 {
        // TODO: Port CSequencer::Free
        portMissing("CSequencer::Free", source: "oracle/codemp/icarus/Sequencer.cpp:73")
    }

    /**
    ```
    -------------------------
    Flush
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:106
    private func Flush(_ owner: CSequence?) -> Int32 {
        // TODO: Port CSequencer::Flush
        portMissing("CSequencer::Flush", source: "oracle/codemp/icarus/Sequencer.cpp:106")
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
        // TODO: Port CSequencer::AddStream
        portMissing("CSequencer::AddStream", source: "oracle/codemp/icarus/Sequencer.cpp:147")
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
        // TODO: Port CSequencer::DeleteStream
        portMissing("CSequencer::DeleteStream", source: "oracle/codemp/icarus/Sequencer.cpp:167")
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
        // TODO: Port CSequencer::AddTaskSequence
        portMissing("CSequencer::AddTaskSequence", source: "oracle/codemp/icarus/Sequencer.cpp:189")
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
        // TODO: Port CSequencer::GetTaskSequence
        portMissing("CSequencer::GetTaskSequence", source: "oracle/codemp/icarus/Sequencer.cpp:200")
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
        // TODO: Port CSequencer::AddSequence
        portMissing("CSequencer::AddSequence", source: "oracle/codemp/icarus/Sequencer.cpp:220")
    }

    /// Source: oracle/codemp/icarus/Sequencer.cpp:237
    private func AddSequence(_ parent: CSequence?, _ returnSeq: CSequence?, _ flags: Int32) -> CSequence? {
        // TODO: Port CSequencer::AddSequence
        portMissing("CSequencer::AddSequence", source: "oracle/codemp/icarus/Sequencer.cpp:237")
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
        // TODO: Port CSequencer::GetSequence
        portMissing("CSequencer::GetSequence", source: "oracle/codemp/icarus/Sequencer.cpp:263")
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
        // TODO: Port CSequencer::Interrupt
        portMissing("CSequencer::Interrupt", source: "oracle/codemp/icarus/Sequencer.cpp:290")
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
        // TODO: Port CSequencer::Run
        portMissing("CSequencer::Run", source: "oracle/codemp/icarus/Sequencer.cpp:308")
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
        // TODO: Port CSequencer::ParseIf
        portMissing("CSequencer::ParseIf", source: "oracle/codemp/icarus/Sequencer.cpp:410")
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
        // TODO: Port CSequencer::ParseElse
        portMissing("CSequencer::ParseElse", source: "oracle/codemp/icarus/Sequencer.cpp:451")
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
        // TODO: Port CSequencer::AddAffect
        portMissing("CSequencer::AddAffect", source: "oracle/codemp/icarus/Sequencer.cpp:560")
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
    private func Route(_ sequence: CSequence?, _ bstream: bstream_t?) -> Int32 {
        // TODO: Port CSequencer::Route
        portMissing("CSequencer::Route", source: "oracle/codemp/icarus/Sequencer.cpp:787")
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
        // TODO: Port CSequencer::CheckFlush
        portMissing("CSequencer::CheckFlush", source: "oracle/codemp/icarus/Sequencer.cpp:1677")
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
        // TODO: Port CSequencer::Prep
        portMissing("CSequencer::Prep", source: "oracle/codemp/icarus/Sequencer.cpp:1987")
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
    private func Prime(_ taskManager: CTaskManager?, _ command: CBlock?) -> Int32 {
        // TODO: Port CSequencer::Prime
        portMissing("CSequencer::Prime", source: "oracle/codemp/icarus/Sequencer.cpp:2006")
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
        // TODO: Port CSequencer::Callback
        portMissing("CSequencer::Callback", source: "oracle/codemp/icarus/Sequencer.cpp:2026")
    }

    /**
    ```
    -------------------------
    Recall
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2082
    func Recall() -> Int32 {
        // TODO: Port CSequencer::Recall
        portMissing("CSequencer::Recall", source: "oracle/codemp/icarus/Sequencer.cpp:2082")
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
        // TODO: Port CSequencer::Affect
        portMissing("CSequencer::Affect", source: "oracle/codemp/icarus/Sequencer.cpp:2114")
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
    private func PushCommand(_ command: CBlock?, _ flag: Int32) -> Int32 {
        // TODO: Port CSequencer::PushCommand
        portMissing("CSequencer::PushCommand", source: "oracle/codemp/icarus/Sequencer.cpp:2170")
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
        // TODO: Port CSequencer::PopCommand
        portMissing("CSequencer::PopCommand", source: "oracle/codemp/icarus/Sequencer.cpp:2192")
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
        // TODO: Port CSequencer::StripExtension
        portMissing("CSequencer::StripExtension", source: "oracle/codemp/icarus/Sequencer.cpp:2215")
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
    private func RemoveSequence(_ sequence: CSequence?) -> Int32 {
        // TODO: Port CSequencer::RemoveSequence
        portMissing("CSequencer::RemoveSequence", source: "oracle/codemp/icarus/Sequencer.cpp:2240")
    }

    /// Source: oracle/codemp/icarus/Sequencer.cpp:2268
    private func DestroySequence(_ sequence: CSequence?) -> Int32 {
        // TODO: Port CSequencer::DestroySequence
        portMissing("CSequencer::DestroySequence", source: "oracle/codemp/icarus/Sequencer.cpp:2268")
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
        // TODO: Port CSequencer::ReturnSequence
        portMissing("CSequencer::ReturnSequence", source: "oracle/codemp/icarus/Sequencer.cpp:2319")
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
    func Save() -> Int32 {
        // TODO: Port CSequencer::Save
        portMissing("CSequencer::Save", source: "oracle/codemp/icarus/Sequencer.cpp:2343")
    }

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequencer.cpp:2406
    func Load() -> Int32 {
        // TODO: Port CSequencer::Load
        portMissing("CSequencer::Load", source: "oracle/codemp/icarus/Sequencer.cpp:2406")
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
    // TODO: Port signature
    // Raven wrote: interface_export_t *GetInterface( void )	const	{	return m_ie;			}
    // No table row for `interface_export_t *`.
    func GetInterface() -> Never {
        // TODO: Port CSequencer::GetInterface
        portMissing("CSequencer::GetInterface", source: "oracle/codemp/icarus/sequencer.h:91")
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
