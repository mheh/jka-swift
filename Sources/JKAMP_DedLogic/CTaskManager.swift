import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/icarus/taskmanager.h:15
let RUNAWAY_LIMIT: Int32 = 256

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
    init() {}

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:162
    static func Create() -> CTaskManager? {
        return CTaskManager()
    }

    /**
    ```
    -------------------------
    Init
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:173
    @discardableResult
    func Init(_ owner: CSequencer?) -> Int32 {
        //TODO: Emit warning
        if owner == nil {
            return TASK_FAILED
        }

        self.m_tasks.removeAll()
        self.m_owner = owner
        self.m_ownerID = owner!.GetOwnerID()
        self.m_curGroup = nil
        self.m_GUID = 0
        self.m_resident = false

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:195
    @discardableResult
    func Free() -> Int32 {
        //Clear out all pending tasks
        for ti in self.m_tasks {
            ti.Free()
        }

        self.m_tasks.removeAll()

        //Clear out all taskGroups

        self.m_taskGroups.removeAll()
        self.m_taskGroupNameMap.removeAll()
        self.m_taskGroupIDMap.removeAll()

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Flush
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:227
    @discardableResult
    func Flush() -> Int32 {
        //FIXME: Rewrite

        return 1
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
        var group: CTaskGroup?

        //Collect any garbage
        let tgni: CTaskGroup? = self.m_taskGroupNameMap[name]

        if tgni != nil {
            group = tgni

            //Clear it and just move on
            group!.Init()

            return group
        }

        //Allocate a new one
        group = CTaskGroup()

        //TODO: Emit warning
        if group == nil {
            // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
            // Raven wrote: (m_owner->GetInterface())->I_DPrintf( WL_ERROR, "Unable to allocate task group \"%s\"\n", name );
            portMissing("CTaskManager::AddTaskGroup", source: "oracle/codemp/icarus/TaskManager.cpp:240")
            return nil
        }

        //Setup the internal information
        group!.SetGUID(self.m_GUID)
        self.m_GUID += 1

        //Add it to the list and associate it for retrieval later
        self.m_taskGroups.append(group!)
        self.m_taskGroupNameMap[name] = group
        self.m_taskGroupIDMap[group!.GetGUID()] = group

        return group
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
        let tgi: CTaskGroup? = self.m_taskGroupNameMap[name]

        if tgi == nil {
            // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
            // Raven wrote: (m_owner->GetInterface())->I_DPrintf( WL_WARNING, "Could not find task group \"%s\"\n", name );
            portMissing("CTaskManager::GetTaskGroup", source: "oracle/codemp/icarus/TaskManager.cpp:286")
            return nil
        }

        return tgi
    }

    /// Source: oracle/codemp/icarus/TaskManager.cpp:301
    func GetTaskGroup(_ id: Int32) -> CTaskGroup? {
        let tgi: CTaskGroup? = self.m_taskGroupIDMap[id]

        if tgi == nil {
            // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
            // Raven wrote: (m_owner->GetInterface())->I_DPrintf( WL_WARNING, "Could not find task group \"%d\"\n", id );
            portMissing("CTaskManager::GetTaskGroup", source: "oracle/codemp/icarus/TaskManager.cpp:301")
            return nil
        }

        return tgi
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
        let owner = SV_GentityNum(self.m_ownerID)

        if (owner!.r.svFlags & SVF_ICARUS_FREEZE) != 0 {
            return TASK_FAILED
        }
        self.m_count = 0	//Needed for runaway init
        self.m_resident = true

        let returnVal: Int32 = self.Go()

        self.m_resident = false

        return returnVal
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
        return self.m_tasks.isEmpty == false
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
        if (block!.GetMember(memberNum))!.GetID() == targetID {
            return true
        }

        return false
    }

    /**
    ```
    -------------------------
    GetFloat
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:370
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through the interface.
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through the interface.
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
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through the interface.
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
        var task: CTask? = nil
        var completed = false

        //Check for run away scripts
        let count: Int32 = self.m_count
        self.m_count += 1
        if count > RUNAWAY_LIMIT {
            // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
            // Raven wrote: (m_owner->GetInterface())->I_DPrintf( WL_ERROR, "Runaway loop detected!\n" );
            portMissing("CTaskManager::Go", source: "oracle/codemp/icarus/TaskManager.cpp:700")
            return TASK_FAILED
        }

        //If there are tasks to complete, do so
        if self.m_tasks.isEmpty == false {
            //Get the next task
            task = self.PopTask(POP_BACK)

            if task == nil {
                // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
                // Raven wrote: (m_owner->GetInterface())->I_DPrintf( WL_ERROR, "Invalid task found in Go()!\n" );
                portMissing("CTaskManager::Go", source: "oracle/codemp/icarus/TaskManager.cpp:700")
                return TASK_FAILED
            }

            //If this hasn't been stamped, do so
            if task!.GetTimeStamp() == 0 {
                // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
                // Raven wrote: task->SetTimeStamp( ( m_owner->GetInterface())->I_GetTime() );
                portMissing("CTaskManager::Go", source: "oracle/codemp/icarus/TaskManager.cpp:700")
            }

            //Switch and call the proper function
            switch task!.GetID() {
            case ID_WAIT:

                self.Wait(task, &completed)

                //Push it to consider it again on the next frame if not complete
                if completed == false {
                    self.PushTask(task, PUSH_BACK)
                    return TASK_OK
                }

                self.Completed(task!.GetGUID())

            case ID_WAITSIGNAL:

                self.WaitSignal(task, &completed)

                //Push it to consider it again on the next frame if not complete
                if completed == false {
                    self.PushTask(task, PUSH_BACK)
                    return TASK_OK
                }

                self.Completed(task!.GetGUID())

            case ID_PRINT:	//print( STRING )
                self.Print(task)

            case ID_SOUND:	//sound( name )
                self.Sound(task)

            case ID_MOVE:	//move ( ORIGIN, ANGLES, DURATION )
                self.Move(task)

            case ID_ROTATE:	//rotate( ANGLES, DURATION )
                self.Rotate(task)

            case ID_KILL:	//kill( NAME )
                self.Kill(task)

            case ID_REMOVE:	//remove( NAME )
                self.Remove(task)

            case ID_CAMERA:	//camera( ? )
                self.Camera(task)

            case ID_SET:	//set( NAME, ? )
                self.Set(task)

            case ID_USE:	//use( NAME )
                self.Use(task)

            case ID_DECLARE://declare( TYPE, NAME )
                self.DeclareVariable(task)

            case ID_FREE:	//free( NAME )
                self.FreeVariable(task)

            case ID_SIGNAL:	//signal( NAME )
                self.Signal(task)

            case ID_PLAY:	//play ( NAME )
                self.Play(task)

            default:
                task!.Free()
                // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
                // Raven wrote: (m_owner->GetInterface())->I_DPrintf( WL_ERROR, "Found unknown task type!\n" );
                portMissing("CTaskManager::Go", source: "oracle/codemp/icarus/TaskManager.cpp:700")
                return TASK_FAILED
            }

            //Pump the sequencer for another task
            self.CallbackCommand(task, TASK_RETURN_COMPLETE)

            task!.Free()
        }

        //FIXME: A command surge limiter could be implemented at this point to be sure a script doesn't
        //		 execute too many commands in one cycle.  This may, however, cause timing errors to surface.

        return TASK_OK
    }

    /**
    ```
    -------------------------
    SetCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:841
    @discardableResult
    func SetCommand(_ command: CBlock?, _ type: Int32) -> Int32 {
        let task: CTask? = CTask.Create(self.m_GUID, command)
        self.m_GUID += 1

        //If this is part of a task group, add it in
        if self.m_curGroup != nil {
            self.m_curGroup!.Add(task)
        }

        //TODO: Emit warning
        if task == nil {
            // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
            // Raven wrote: (m_owner->GetInterface())->I_DPrintf( WL_ERROR, "Unable to allocate new task!\n" );
            portMissing("CTaskManager::SetCommand", source: "oracle/codemp/icarus/TaskManager.cpp:841")
            return TASK_FAILED
        }

        self.PushTask(task, type)

        return TASK_OK
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
        let group: CTaskGroup? = self.GetTaskGroup(id)

        if group == nil {
            return TASK_FAILED
        }

        if operation == TASK_START {
            //Reset all the completion information
            group!.Init()

            group!.SetParent(self.m_curGroup)
            self.m_curGroup = group
        } else if operation == TASK_END {
            if self.m_curGroup == nil {
                return TASK_FAILED
            }

            self.m_curGroup = self.m_curGroup!.GetParent()
        }

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Completed
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:912
    @discardableResult
    func Completed(_ id: Int32) -> Int32 {
        //Mark the task as completed
        for tgi in self.m_taskGroups {
            //If this returns true, then the task was marked properly
            if tgi.MarkTaskComplete(id) {
                break
            }
        }

        return TASK_OK
    }

    /**
    ```
    -------------------------
    CallbackCommand
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:933
    @discardableResult
    private func CallbackCommand(_ task: CTask?, _ returnCode: Int32) -> Int32 {
        if self.m_owner!.Callback(self, task!.GetBlock(), returnCode) == SEQ_OK {
            return self.Go()
        }

        // Port-note: The call goes through `m_owner->GetInterface()`, and `interface_export_t` has no Swift form.
        // Raven wrote: (m_owner->GetInterface())->I_DPrintf( WL_ERROR, "Command callback failure!\n" );
        portMissing("CTaskManager::CallbackCommand", source: "oracle/codemp/icarus/TaskManager.cpp:933")
        return TASK_FAILED
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
        var task: CTask?

        task = self.PopTask(POP_BACK)

        if task != nil {
            // fixed 2/12/2 to free the task that has been popped (called from sequencer Recall)
            let retBlock: CBlock? = task!.GetBlock()
            task!.Free()

            return retBlock
            //	return task->GetBlock();
        }

        return nil
    }

    /**
    ```
    -------------------------
    PushTask
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:975
    @discardableResult
    private func PushTask(_ task: CTask?, _ flag: Int32) -> Int32 {
        switch flag {
        case PUSH_FRONT:
            self.m_tasks.insert(task!, at: 0)

            return TASK_OK

        case PUSH_BACK:
            self.m_tasks.append(task!)

            return TASK_OK

        default:
            break
        }

        //Invalid flag
        return SEQ_FAILED
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
        var task: CTask?

        if self.m_tasks.isEmpty {
            return nil
        }

        switch flag {
        case POP_FRONT:
            task = self.m_tasks.first
            self.m_tasks.removeFirst()

            return task

        case POP_BACK:
            task = self.m_tasks.last
            self.m_tasks.removeLast()

            return task

        default:
            break
        }

        //Invalid flag
        return nil
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
        let task: CTask? = self.PopTask(POP_BACK)

        if task == nil {
            return nil
        }
        // fixed 2/12/2 to free the task that has been popped (called from sequencer Interrupt)
        let retBlock: CBlock? = task!.GetBlock()
        task!.Free()

        return retBlock
        //	return task->GetBlock();
    }

    /**
    ```
    =================================================

      Task Functions

    =================================================
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1062
    // Port-note: The body reads block member data, which waits for the `m_data` row, and it calls through the interface.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
    @discardableResult
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
    // Port-note: Each call of the body goes through `interface_export_t`, which has no Swift form, so the body waits for that row.
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
    func Save() {}

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1790
    func Load() {}
}
