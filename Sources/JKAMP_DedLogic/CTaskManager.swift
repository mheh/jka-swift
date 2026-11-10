import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's task manager of one entity, which runs the commands of its sequencer one game frame at a time.
/// Source: oracle/codemp/icarus/taskmanager.h:97
// AI: Raven's destructor has an empty body. ARC frees the class, so the destructor drops.
final class CTaskManager {
    // AI: Raven types these with std::map, std::vector, and std::list. Each is a Dictionary or an Array, by rule 17.
    typealias taskID_m = [Int32: CTask]
    typealias taskGroupName_m = [String: CTaskGroup]
    typealias taskGroupID_m = [Int32: CTaskGroup]
    typealias taskGroup_v = [CTaskGroup]
    typealias tasks_l = [CTask]

    // Variables

    // AI: Raven holds the owner as a pointer. The field is weak, because the sequencer holds this task manager in m_taskManager.
    private weak var m_owner: CSequencer? = nil
    private var m_ownerID: Int32 = 0

    private var m_curGroup: CTaskGroup? = nil

    private var m_taskGroups: taskGroup_v = []
    private var m_tasks: tasks_l = []

    private var m_GUID: Int32 = 0
    private var m_count: Int32 = 0

    private var m_taskGroupNameMap: taskGroupName_m = [:]
    private var m_taskGroupIDMap: taskGroupID_m = [:]

    private var m_resident: Bool = false

    //CTask	*m_waitTask;		//Global pointer to the current task that is waiting for callback completion

    /**
    ```
    =================================================

    CTaskManager

    =================================================
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:148
    init() {
        // TODO: Port CTaskManager::CTaskManager
        portMissing("CTaskManager::CTaskManager", source: "oracle/codemp/icarus/TaskManager.cpp:148")
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:162
    static func Create() -> CTaskManager? {
        // TODO: Port CTaskManager::Create
        portMissing("CTaskManager::Create", source: "oracle/codemp/icarus/TaskManager.cpp:162")
    }

    /**
    ```
    -------------------------
    Init
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:173
    func Init(_ owner: CSequencer?) -> Int32 {
        // TODO: Port CTaskManager::Init
        portMissing("CTaskManager::Init", source: "oracle/codemp/icarus/TaskManager.cpp:173")
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:195
    func Free() -> Int32 {
        // TODO: Port CTaskManager::Free
        portMissing("CTaskManager::Free", source: "oracle/codemp/icarus/TaskManager.cpp:195")
    }

    /**
    ```
    -------------------------
    Flush
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:227
    func Flush() -> Int32 {
        // TODO: Port CTaskManager::Flush
        portMissing("CTaskManager::Flush", source: "oracle/codemp/icarus/TaskManager.cpp:227")
    }

    /**
    ```
    -------------------------
    AddTaskGroup
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:240
    func AddTaskGroup(_ name: String) -> CTaskGroup? {
        // TODO: Port CTaskManager::AddTaskGroup
        portMissing("CTaskManager::AddTaskGroup", source: "oracle/codemp/icarus/TaskManager.cpp:240")
    }

    /**
    ```
    -------------------------
    GetTaskGroup
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:286
    func GetTaskGroup(_ name: String) -> CTaskGroup? {
        // TODO: Port CTaskManager::GetTaskGroup
        portMissing("CTaskManager::GetTaskGroup", source: "oracle/codemp/icarus/TaskManager.cpp:286")
    }

    /// Source: oracle/codemp/icarus/TaskManager.cpp:301
    func GetTaskGroup(_ id: Int32) -> CTaskGroup? {
        // TODO: Port CTaskManager::GetTaskGroup
        portMissing("CTaskManager::GetTaskGroup", source: "oracle/codemp/icarus/TaskManager.cpp:301")
    }

    /**
    ```
    -------------------------
    Update
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:322
    func Update() -> Int32 {
        // TODO: Port CTaskManager::Update
        portMissing("CTaskManager::Update", source: "oracle/codemp/icarus/TaskManager.cpp:322")
    }

    /**
    ```
    -------------------------
    IsRunning
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:346
    func IsRunning() -> Bool {
        // TODO: Port CTaskManager::IsRunning
        portMissing("CTaskManager::IsRunning", source: "oracle/codemp/icarus/TaskManager.cpp:346")
    }

    /**
    ```
    -------------------------
    Check
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:356
    private func Check(_ targetID: Int32, _ block: CBlock?, _ memberNum: Int32) -> Bool {
        // TODO: Port CTaskManager::Check
        portMissing("CTaskManager::Check", source: "oracle/codemp/icarus/TaskManager.cpp:356")
    }

    /**
    ```
    -------------------------
    GetFloat
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:370
    private func GetFloat(_ entID: Int32, _ block: CBlock?, _ memberNum: inout Int32, _ value: inout Float) -> Int32 {
        // TODO: Port CTaskManager::GetFloat
        portMissing("CTaskManager::GetFloat", source: "oracle/codemp/icarus/TaskManager.cpp:370")
    }

    /**
    ```
    -------------------------
    GetVector
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:443
    private func GetVector(_ entID: Int32, _ block: CBlock?, _ memberNum: inout Int32, _ value: inout JKAShared.vec3_t) -> Int32 {
        // TODO: Port CTaskManager::GetVector
        portMissing("CTaskManager::GetVector", source: "oracle/codemp/icarus/TaskManager.cpp:443")
    }

    /**
    ```
    -------------------------
    Get
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:531
    private func Get(_ entID: Int32, _ block: CBlock?, _ memberNum: inout Int32, _ value: inout String) -> Int32 {
        // TODO: Port CTaskManager::Get
        portMissing("CTaskManager::Get", source: "oracle/codemp/icarus/TaskManager.cpp:531")
    }

    /**
    ```
    -------------------------
    Go
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:700
    private func Go() -> Int32 {
        // TODO: Port CTaskManager::Go
        portMissing("CTaskManager::Go", source: "oracle/codemp/icarus/TaskManager.cpp:700")
    }

    /**
    ```
    -------------------------
    SetCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:841
    func SetCommand(_ command: CBlock?, _ type: Int32) -> Int32 {
        // TODO: Port CTaskManager::SetCommand
        portMissing("CTaskManager::SetCommand", source: "oracle/codemp/icarus/TaskManager.cpp:841")
    }

    /**
    ```
    -------------------------
    MarkTask
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:870
    func MarkTask(_ id: Int32, _ operation: Int32) -> Int32 {
        // TODO: Port CTaskManager::MarkTask
        portMissing("CTaskManager::MarkTask", source: "oracle/codemp/icarus/TaskManager.cpp:870")
    }

    /**
    ```
    -------------------------
    Completed
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:912
    func Completed(_ id: Int32) -> Int32 {
        // TODO: Port CTaskManager::Completed
        portMissing("CTaskManager::Completed", source: "oracle/codemp/icarus/TaskManager.cpp:912")
    }

    /**
    ```
    -------------------------
    CallbackCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:933
    private func CallbackCommand(_ task: CTask?, _ returnCode: Int32) -> Int32 {
        // TODO: Port CTaskManager::CallbackCommand
        portMissing("CTaskManager::CallbackCommand", source: "oracle/codemp/icarus/TaskManager.cpp:933")
    }

    /**
    ```
    -------------------------
    RecallTask
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:950
    func RecallTask() -> CBlock? {
        // TODO: Port CTaskManager::RecallTask
        portMissing("CTaskManager::RecallTask", source: "oracle/codemp/icarus/TaskManager.cpp:950")
    }

    /**
    ```
    -------------------------
    PushTask
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:975
    private func PushTask(_ task: CTask?, _ flag: Int32) -> Int32 {
        // TODO: Port CTaskManager::PushTask
        portMissing("CTaskManager::PushTask", source: "oracle/codemp/icarus/TaskManager.cpp:975")
    }

    /**
    ```
    -------------------------
    PopTask
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1004
    private func PopTask(_ flag: Int32) -> CTask? {
        // TODO: Port CTaskManager::PopTask
        portMissing("CTaskManager::PopTask", source: "oracle/codemp/icarus/TaskManager.cpp:1004")
    }

    /**
    ```
    -------------------------
    GetCurrentTask
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1040
    func GetCurrentTask() -> CBlock? {
        // TODO: Port CTaskManager::GetCurrentTask
        portMissing("CTaskManager::GetCurrentTask", source: "oracle/codemp/icarus/TaskManager.cpp:1040")
    }

    /**
    ```
    =================================================

      Task Functions

    =================================================
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1062
    private func Wait(_ task: CTask?, _ completed: inout Bool) -> Int32 {
        // TODO: Port CTaskManager::Wait
        portMissing("CTaskManager::Wait", source: "oracle/codemp/icarus/TaskManager.cpp:1062")
    }

    /**
    ```
    -------------------------
    WaitSignal
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1146
    private func WaitSignal(_ task: CTask?, _ completed: inout Bool) -> Int32 {
        // TODO: Port CTaskManager::WaitSignal
        portMissing("CTaskManager::WaitSignal", source: "oracle/codemp/icarus/TaskManager.cpp:1146")
    }

    /**
    ```
    -------------------------
    Print
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1177
    private func Print(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Print
        portMissing("CTaskManager::Print", source: "oracle/codemp/icarus/TaskManager.cpp:1177")
    }

    /**
    ```
    -------------------------
    Sound
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1200
    private func Sound(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Sound
        portMissing("CTaskManager::Sound", source: "oracle/codemp/icarus/TaskManager.cpp:1200")
    }

    /**
    ```
    -------------------------
    Rotate
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1224
    private func Rotate(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Rotate
        portMissing("CTaskManager::Rotate", source: "oracle/codemp/icarus/TaskManager.cpp:1224")
    }

    /**
    ```
    -------------------------
    Remove
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1269
    private func Remove(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Remove
        portMissing("CTaskManager::Remove", source: "oracle/codemp/icarus/TaskManager.cpp:1269")
    }

    /**
    ```
    -------------------------
    Camera
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1291
    private func Camera(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Camera
        portMissing("CTaskManager::Camera", source: "oracle/codemp/icarus/TaskManager.cpp:1291")
    }

    /**
    ```
    -------------------------
    Move
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1425
    private func Move(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Move
        portMissing("CTaskManager::Move", source: "oracle/codemp/icarus/TaskManager.cpp:1425")
    }

    /**
    ```
    -------------------------
    Kill
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1462
    private func Kill(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Kill
        portMissing("CTaskManager::Kill", source: "oracle/codemp/icarus/TaskManager.cpp:1462")
    }

    /**
    ```
    -------------------------
    Set
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1484
    private func Set(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Set
        portMissing("CTaskManager::Set", source: "oracle/codemp/icarus/TaskManager.cpp:1484")
    }

    /**
    ```
    -------------------------
    Use
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1505
    private func Use(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Use
        portMissing("CTaskManager::Use", source: "oracle/codemp/icarus/TaskManager.cpp:1505")
    }

    /**
    ```
    -------------------------
    DeclareVariable
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1527
    private func DeclareVariable(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::DeclareVariable
        portMissing("CTaskManager::DeclareVariable", source: "oracle/codemp/icarus/TaskManager.cpp:1527")
    }

    /**
    ```
    -------------------------
    FreeVariable
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1552
    private func FreeVariable(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::FreeVariable
        portMissing("CTaskManager::FreeVariable", source: "oracle/codemp/icarus/TaskManager.cpp:1552")
    }

    /**
    ```
    -------------------------
    Signal
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1575
    private func Signal(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Signal
        portMissing("CTaskManager::Signal", source: "oracle/codemp/icarus/TaskManager.cpp:1575")
    }

    /**
    ```
    -------------------------
    Play
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1597
    private func Play(_ task: CTask?) -> Int32 {
        // TODO: Port CTaskManager::Play
        portMissing("CTaskManager::Play", source: "oracle/codemp/icarus/TaskManager.cpp:1597")
    }

    /**
    ```
    -------------------------
    SaveCommand
    -------------------------
    ```
    */
    //FIXME: ARGH!  This is duplicated from CSequence because I can't directly link it any other way...
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1620
    private func SaveCommand(_ block: CBlock?) -> Int32 {
        // TODO: Port CTaskManager::SaveCommand
        portMissing("CTaskManager::SaveCommand", source: "oracle/codemp/icarus/TaskManager.cpp:1620")
    }

    /**
    ```
    -------------------------
    Save
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1663
    func Save() {
        // TODO: Port CTaskManager::Save
        portMissing("CTaskManager::Save", source: "oracle/codemp/icarus/TaskManager.cpp:1663")
    }

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1790
    func Load() {
        // TODO: Port CTaskManager::Load
        portMissing("CTaskManager::Load", source: "oracle/codemp/icarus/TaskManager.cpp:1790")
    }
}
