import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's sequence, one list of commands of a script, with its parent, its children, and the sequence it returns to.
/// Source: oracle/codemp/icarus/sequence.h:12
// AI: Raven allocates the class with Z_Malloc in operator new and frees it in operator delete. ARC frees the class, so the two operators drop.
final class CSequence {
    // AI: Raven types these with std::list and std::map. Each is an Array or a Dictionary, by rule 17.
    typealias sequence_l = [CSequence]
    typealias sequenceID_m = [Int32: CSequence]
    typealias block_l = [CBlock]

    // AI: Raven holds the owner as a pointer. The field is weak, because the instance holds every sequence in its list.
    private weak var m_owner: ICARUS_Instance? = nil

    //Organization information
    private var m_children: sequence_l = []
    // AI: Raven holds the parent as a pointer. The field is weak, because the parent holds this sequence in m_children.
    private weak var m_parent: CSequence? = nil
    private var m_return: CSequence? = nil

    //Data information
    private var m_commands: block_l = []
    private var m_flags: Int32 = 0
    private var m_iterations: Int32 = 0
    private var m_id: Int32 = 0
    private var m_numCommands: Int32 = 0

    /// Source: oracle/codemp/icarus/Sequence.cpp:13
    init() {
        // TODO: Port CSequence::CSequence
        portMissing("CSequence::CSequence", source: "oracle/codemp/icarus/Sequence.cpp:13")
    }

    /// Source: oracle/codemp/icarus/Sequence.cpp:23
    deinit {
        // TODO: Port CSequence::~CSequence
        portMissing("CSequence::~CSequence", source: "oracle/codemp/icarus/Sequence.cpp:23")
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:34
    static func Create() -> CSequence? {
        // TODO: Port CSequence::Create
        portMissing("CSequence::Create", source: "oracle/codemp/icarus/Sequence.cpp:34")
    }

    /**
    ```
    -------------------------
    Delete
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:54
    func Delete() {
        // TODO: Port CSequence::Delete
        portMissing("CSequence::Delete", source: "oracle/codemp/icarus/Sequence.cpp:54")
    }

    /**
    ```
    -------------------------
    AddChild
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:96
    func AddChild(_ child: CSequence?) {
        // TODO: Port CSequence::AddChild
        portMissing("CSequence::AddChild", source: "oracle/codemp/icarus/Sequence.cpp:96")
    }

    /**
    ```
    -------------------------
    RemoveChild
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:111
    func RemoveChild(_ child: CSequence?) {
        // TODO: Port CSequence::RemoveChild
        portMissing("CSequence::RemoveChild", source: "oracle/codemp/icarus/Sequence.cpp:111")
    }

    /**
    ```
    -------------------------
    HasChild
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:127
    func HasChild(_ sequence: CSequence?) -> Bool {
        // TODO: Port CSequence::HasChild
        portMissing("CSequence::HasChild", source: "oracle/codemp/icarus/Sequence.cpp:127")
    }

    /**
    ```
    -------------------------
    SetParent
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:149
    func SetParent(_ parent: CSequence?) {
        // TODO: Port CSequence::SetParent
        portMissing("CSequence::SetParent", source: "oracle/codemp/icarus/Sequence.cpp:149")
    }

    /**
    ```
    -------------------------
    PopCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:170
    func PopCommand(_ type: Int32) -> CBlock? {
        // TODO: Port CSequence::PopCommand
        portMissing("CSequence::PopCommand", source: "oracle/codemp/icarus/Sequence.cpp:170")
    }

    /**
    ```
    -------------------------
    PushCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:211
    func PushCommand(_ block: CBlock?, _ type: Int32) -> Int32 {
        // TODO: Port CSequence::PushCommand
        portMissing("CSequence::PushCommand", source: "oracle/codemp/icarus/Sequence.cpp:211")
    }

    /**
    ```
    -------------------------
    SetFlag
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:246
    func SetFlag(_ flag: Int32) {
        // TODO: Port CSequence::SetFlag
        portMissing("CSequence::SetFlag", source: "oracle/codemp/icarus/Sequence.cpp:246")
    }

    /**
    ```
    -------------------------
    RemoveFlag
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:257
    func RemoveFlag(_ flag: Int32, _ children: Bool = false) {
        // TODO: Port CSequence::RemoveFlag
        portMissing("CSequence::RemoveFlag", source: "oracle/codemp/icarus/Sequence.cpp:257")
    }

    /**
    ```
    -------------------------
    HasFlag
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:278
    func HasFlag(_ flag: Int32) -> Int32 {
        // TODO: Port CSequence::HasFlag
        portMissing("CSequence::HasFlag", source: "oracle/codemp/icarus/Sequence.cpp:278")
    }

    /**
    ```
    -------------------------
    SetReturn
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:289
    func SetReturn(_ sequence: CSequence?) {
        // TODO: Port CSequence::SetReturn
        portMissing("CSequence::SetReturn", source: "oracle/codemp/icarus/Sequence.cpp:289")
    }

    /**
    ```
    -------------------------
    GetChild
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:301
    func GetChildByIndex(_ iIndex: Int32) -> CSequence? {
        // TODO: Port CSequence::GetChildByIndex
        portMissing("CSequence::GetChildByIndex", source: "oracle/codemp/icarus/Sequence.cpp:301")
    }

    /**
    ```
    -------------------------
    SaveCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:320
    private func SaveCommand(_ block: CBlock?) -> Int32 {
        // TODO: Port CSequence::SaveCommand
        portMissing("CSequence::SaveCommand", source: "oracle/codemp/icarus/Sequence.cpp:320")
    }

    /**
    ```
    -------------------------
    Save
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:363
    func Save() -> Int32 {
        // TODO: Port CSequence::Save
        portMissing("CSequence::Save", source: "oracle/codemp/icarus/Sequence.cpp:363")
    }

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:414
    func Load() -> Int32 {
        // TODO: Port CSequence::Load
        portMissing("CSequence::Load", source: "oracle/codemp/icarus/Sequence.cpp:414")
    }

    /// Source: oracle/codemp/icarus/sequence.h:34
    func GetParent() -> CSequence? {
        self.m_parent
    }

    /// Source: oracle/codemp/icarus/sequence.h:44
    func GetFlags() -> Int32 {
        self.m_flags
    }

    /// Source: oracle/codemp/icarus/sequence.h:45
    func SetFlags(_ flags: Int32) {
        self.m_flags = flags
    }

    /// Source: oracle/codemp/icarus/sequence.h:48
    func GetIterations() -> Int32 {
        self.m_iterations
    }

    /// Source: oracle/codemp/icarus/sequence.h:49
    func SetIterations(_ it: Int32) {
        self.m_iterations = it
    }

    /// Source: oracle/codemp/icarus/sequence.h:51
    func GetID() -> Int32 {
        self.m_id
    }

    /// Source: oracle/codemp/icarus/sequence.h:52
    func SetID(_ id: Int32) {
        self.m_id = id
    }

    /// Source: oracle/codemp/icarus/sequence.h:54
    func GetReturn() -> CSequence? {
        self.m_return
    }

    /// Source: oracle/codemp/icarus/sequence.h:58
    func GetNumCommands() -> Int32 {
        self.m_numCommands
    }

    /// Source: oracle/codemp/icarus/sequence.h:59
    func GetNumChildren() -> Int32 {
        Int32(self.m_children.count)
    }

    /// Source: oracle/codemp/icarus/sequence.h:64
    func SetOwner(_ owner: ICARUS_Instance?) {
        self.m_owner = owner
    }
}
