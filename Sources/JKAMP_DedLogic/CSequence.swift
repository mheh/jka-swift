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
        self.m_numCommands = 0
        self.m_flags = 0
        self.m_iterations = 1

        self.m_parent = nil
        self.m_return = nil
    }

    /// Source: oracle/codemp/icarus/Sequence.cpp:23
    deinit {
        self.Delete()
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
        let seq: CSequence? = CSequence()

        //TODO: Emit warning
        if seq == nil {
            return nil
        }

        seq!.SetFlag(SQ_COMMON)

        return seq
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
        //Notify the parent of the deletion
        if self.m_parent != nil {
            self.m_parent!.RemoveChild(self)
        }

        //Clear all children
        if self.m_children.count > 0 {
            /*for ( iterSeq = m_childrenMap.begin(); iterSeq != m_childrenMap.end(); iterSeq++ )
            {
                (*iterSeq).second->SetParent( NULL );
            }*/

            for si in self.m_children {
                si.SetParent(nil)
            }
        }
        self.m_children.removeAll()

        //Clear all held commands
        // AI: Raven deletes each command block in a loop, and the block frees its members.
        // ARC frees each block when the list drops it, so the loop drops.
        self.m_commands.removeAll()
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
        if child == nil {
            return
        }

        self.m_children.append(child!)
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
        if child == nil {
            return
        }

        //Remove the child
        self.m_children.removeAll { $0 === child }
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
        for ci in self.m_children {
            if ci === sequence {
                return true
            }

            if ci.HasChild(sequence) {
                return true
            }
        }

        return false
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
        self.m_parent = parent

        if parent == nil {
            return
        }

        //Inherit the parent's properties (this avoids messy tree walks later on)
        if (parent!.m_flags & SQ_RETAIN) != 0 {
            self.m_flags |= SQ_RETAIN
        }

        if (parent!.m_flags & SQ_PENDING) != 0 {
            self.m_flags |= SQ_PENDING
        }
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
        var command: CBlock? = nil

        //Make sure everything is ok

        if self.m_commands.isEmpty {
            return nil
        }

        switch type {
        case POP_FRONT:
            command = self.m_commands.first
            self.m_commands.removeFirst()
            self.m_numCommands -= 1

            return command

        case POP_BACK:
            command = self.m_commands.last
            self.m_commands.removeLast()
            self.m_numCommands -= 1

            return command

        default:
            break
        }

        //Invalid flag
        return nil
    }

    /**
    ```
    -------------------------
    PushCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:211
    @discardableResult
    func PushCommand(_ block: CBlock?, _ type: Int32) -> Int32 {
        //Make sure everything is ok

        switch type {
        case PUSH_FRONT:
            self.m_commands.insert(block!, at: 0)
            self.m_numCommands += 1

            return 1

        case PUSH_BACK:
            self.m_commands.append(block!)
            self.m_numCommands += 1

            return 1

        default:
            break
        }

        //Invalid flag
        return 0
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
        self.m_flags |= flag
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
        self.m_flags &= ~flag

        if children {
            for si in self.m_children {
                si.RemoveFlag(flag, true)
            }
        }
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
        return (self.m_flags & flag)
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
        self.m_return = sequence
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
        if iIndex < 0 || iIndex >= Int32(self.m_children.count) {
            return nil
        }

        return self.m_children[iIndex]
    }

    /**
    ```
    -------------------------
    SaveCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Sequence.cpp:320
    // Port-note: The body calls through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form, so the body waits for that row.
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
    /// Source: oracle/codemp/icarus/Sequence.cpp:414
    @discardableResult
    func Load() -> Int32 {
        return 0
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
