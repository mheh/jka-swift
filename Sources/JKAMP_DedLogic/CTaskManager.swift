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
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Unable to allocate task group \"%s\"\n", name)
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
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_WARNING, "Could not find task group \"%s\"\n", name)
            return nil
        }

        return tgi
    }

    /// Source: oracle/codemp/icarus/TaskManager.cpp:301
    func GetTaskGroup(_ id: Int32) -> CTaskGroup? {
        let tgi: CTaskGroup? = self.m_taskGroupIDMap[id]

        if tgi == nil {
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_WARNING, "Could not find task group \"%d\"\n", id)
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
    @discardableResult
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
    private func GetFloat(_ entID: Int32, _ block: CBlock?, _ memberNum: inout Int32, _ value: inout Float) -> Int32 {
        var name: CharBuf
        var type: Int32

        //See if this is a get() command replacement
        if self.Check(ID_GET, block, memberNum) {
            //Update the member past the header id
            memberNum += 1

            //get( TYPE, NAME )
            type = Int32(block!.GetMemberData(memberNum)![float: 0])
            memberNum += 1
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            name = CharBuf(block!.GetMember(memberNum)!.GetSize())
            Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
            memberNum += 1

            //TODO: Emit warning
            if type != TK_FLOAT {
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Get() call tried to return a non-FLOAT parameter!\n")
                return 0
            }

            return (self.m_owner!.GetInterface())!.I_GetFloat!(entID, type, String(name), &value)
        }

        //Look for a random() inline call
        if self.Check(ID_RANDOM, block, memberNum) {
            let min: Float
            let max: Float

            memberNum += 1

            min = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1
            max = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1

            value = (self.m_owner!.GetInterface())!.I_Random!(min, max)

            return 1
        }

        //Look for a tag() inline call
        if self.Check(ID_TAG, block, memberNum) {
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_WARNING, "Invalid use of \"tag\" inline.  Not a valid replacement for type FLOAT\n")
            return 0
        }

        let bm: CBlockMember? = block!.GetMember(memberNum)

        if bm!.GetID() == TK_INT {
            value = Float(block!.GetMemberData(memberNum)![int: 0])
            memberNum += 1
        } else if bm!.GetID() == TK_FLOAT {
            value = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1
        } else {
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_WARNING, "Unexpected value; expected type FLOAT\n")
            return 0
        }

        return 1
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
        var name: CharBuf
        var type: Int32
        var i: Int32

        //See if this is a get() command replacement
        if self.Check(ID_GET, block, memberNum) {
            //Update the member past the header id
            memberNum += 1

            //get( TYPE, NAME )
            type = Int32(block!.GetMemberData(memberNum)![float: 0])
            memberNum += 1
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            name = CharBuf(block!.GetMember(memberNum)!.GetSize())
            Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
            memberNum += 1

            //TODO: Emit warning
            if type != TK_VECTOR {
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Get() call tried to return a non-VECTOR parameter!\n")
            }

            return (self.m_owner!.GetInterface())!.I_GetVector!(entID, type, String(name), &value)
        }

        //Look for a random() inline call
        if self.Check(ID_RANDOM, block, memberNum) {
            let min: Float
            let max: Float

            memberNum += 1

            min = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1
            max = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1

            i = 0
            while i < 3 {
                value[i] = Float((self.m_owner!.GetInterface())!.I_Random!(min, max))	//FIXME: Just truncating it for now.. should be fine though
                i += 1
            }

            return 1
        }

        //Look for a tag() inline call
        if self.Check(ID_TAG, block, memberNum) {
            var tagName = ""
            var tagLookup: Float = 0

            memberNum += 1
            // ICARUS_VALIDATE
            if self.Get(entID, block, &memberNum, &tagName) == 0 { return TASK_FAILED }
            if self.GetFloat(entID, block, &memberNum, &tagLookup) == 0 { return TASK_FAILED }

            if (self.m_owner!.GetInterface())!.I_GetTag!(entID, tagName, Int32(tagLookup), &value) == 0 {
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Unable to find tag \"%s\" for ent %i!\n", tagName, entID)
                //			assert(0);
                return TASK_FAILED
            }

            return 1
        }

        //Check for a real vector here
        type = Int32(block!.GetMemberData(memberNum)![float: 0])

        if type != TK_VECTOR {
            //		(m_owner->GetInterface())->I_DPrintf( WL_WARNING, "Unexpected value; expected type VECTOR\n" );
            return 0
        }

        memberNum += 1

        i = 0
        while i < 3 {
            if self.GetFloat(entID, block, &memberNum, &value[i]) == 0 {
                return 0
            }
            i += 1
        }

        return 1
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
        // AI: Raven formats into a static buffer and returns a pointer into it. The buffer is a local, because the String of `value` is a copy.
        var tempBuffer = CharBuf(128)	//FIXME: EEEK!
        var vector = vec3_t()
        var name: CharBuf
        var tagName = ""
        var tagLookup: Float = 0
        var type: Int32

        //Look for a get() inline call
        if self.Check(ID_GET, block, memberNum) {
            //Update the member past the header id
            memberNum += 1

            //get( TYPE, NAME )
            type = Int32(block!.GetMemberData(memberNum)![float: 0])
            memberNum += 1
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            name = CharBuf(block!.GetMember(memberNum)!.GetSize())
            Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
            memberNum += 1

            //Format the return properly
            //FIXME: This is probably doing double formatting in certain cases...
            //FIXME: STRING MANAGEMENT NEEDS TO BE IMPLEMENTED, MY CURRENT SOLUTION IS NOT ACCEPTABLE!!
            switch type {
            case TK_STRING:
                if (self.m_owner!.GetInterface())!.I_GetString!(entID, type, String(name), &value) == 0 {
                    (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Get() parameter \"%s\" could not be found!\n", name)
                    return 0
                }

                return 1

            case TK_FLOAT:
                var temp: Float = 0

                if (self.m_owner!.GetInterface())!.I_GetFloat!(entID, type, String(name), &temp) == 0 {
                    (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Get() parameter \"%s\" could not be found!\n", name)
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of tempBuffer.
                Com_sprintf(&tempBuffer, 128, "%f", temp)
                value = String(tempBuffer)

                return 1

            case TK_VECTOR:
                var vval = vec3_t()

                if (self.m_owner!.GetInterface())!.I_GetVector!(entID, type, String(name), &vval) == 0 {
                    (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Get() parameter \"%s\" could not be found!\n", name)
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of tempBuffer.
                Com_sprintf(&tempBuffer, 128, "%f %f %f", vval[0], vval[1], vval[2])
                value = String(tempBuffer)

                return 1

            default:
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Get() call tried to return an unknown type!\n")
                return 0
            }
        }

        //Look for a random() inline call
        if self.Check(ID_RANDOM, block, memberNum) {
            let min: Float
            let max: Float
            let ret: Float

            memberNum += 1

            min = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1
            max = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1

            ret = (self.m_owner!.GetInterface())!.I_Random!(min, max)

            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of tempBuffer.
            Com_sprintf(&tempBuffer, 128, "%f", ret)
            value = String(tempBuffer)

            return 1
        }

        //Look for a tag() inline call
        if self.Check(ID_TAG, block, memberNum) {
            memberNum += 1
            // ICARUS_VALIDATE
            if self.Get(entID, block, &memberNum, &tagName) == 0 { return TASK_FAILED }
            if self.GetFloat(entID, block, &memberNum, &tagLookup) == 0 { return TASK_FAILED }

            if (self.m_owner!.GetInterface())!.I_GetTag!(entID, tagName, Int32(tagLookup), &vector) == 0 {
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Unable to find tag \"%s\"!\n", tagName)
                return 0
            }

            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of tempBuffer.
            Com_sprintf(&tempBuffer, 128, "%f %f %f", vector[0], vector[1], vector[2])
            value = String(tempBuffer)

            return 1
        }

        //Get an actual piece of data

        let bm: CBlockMember? = block!.GetMember(memberNum)

        if bm!.GetID() == TK_INT {
            let fval = Float(block!.GetMemberData(memberNum)![int: 0])
            memberNum += 1
            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of tempBuffer.
            Com_sprintf(&tempBuffer, 128, "%f", fval)
            value = String(tempBuffer)

            return 1
        } else if bm!.GetID() == TK_FLOAT {
            let fval: Float = block!.GetMemberData(memberNum)![float: 0]
            memberNum += 1
            // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of tempBuffer.
            Com_sprintf(&tempBuffer, 128, "%f", fval)
            value = String(tempBuffer)

            return 1
        } else if bm!.GetID() == TK_VECTOR {
            var vval = vec3_t()

            memberNum += 1

            var i: Int32 = 0
            while i < 3 {
                if self.GetFloat(entID, block, &memberNum, &vval[i]) == 0 {
                    return 0
                }

                // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of tempBuffer.
                Com_sprintf(&tempBuffer, 128, "%f %f %f", vval[0], vval[1], vval[2])
                value = String(tempBuffer)
                i += 1
            }

            return 1
        } else if (bm!.GetID() == TK_STRING) || (bm!.GetID() == TK_IDENTIFIER) {
            // AI: Raven casts the member data to `char *`. The text is a copy of the member bytes in a CharBuf.
            name = CharBuf(bm!.GetSize())
            Com_Memcpy(&name, block!.GetMemberData(memberNum)!, name.count)
            memberNum += 1
            value = String(name)

            return 1
        }

        //TODO: Emit warning
        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_WARNING, "Unexpected value; expected type STRING\n")

        return 0
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
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Runaway loop detected!\n")
            return TASK_FAILED
        }

        //If there are tasks to complete, do so
        if self.m_tasks.isEmpty == false {
            //Get the next task
            task = self.PopTask(POP_BACK)

            if task == nil {
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Invalid task found in Go()!\n")
                return TASK_FAILED
            }

            //If this hasn't been stamped, do so
            if task!.GetTimeStamp() == 0 {
                task!.SetTimeStamp((self.m_owner!.GetInterface())!.I_GetTime!())
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
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Found unknown task type!\n")
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
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Unable to allocate new task!\n")
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
    @discardableResult
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

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Command callback failure!\n")
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
    @discardableResult
    private func Wait(_ task: CTask?, _ completed: inout Bool) -> Int32 {
        let bm: CBlockMember?
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var dwtime: Float = 0
        var memberNum: Int32 = 0

        completed = false

        bm = block!.GetMember(0)

        //Check if this is a task completion wait
        if bm!.GetID() == TK_STRING {
            // ICARUS_VALIDATE
            if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

            if task!.GetTimeStamp() == (self.m_owner!.GetInterface())!.I_GetTime!() {
                //Print out the debug info
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d wait(\"%s\"); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())
            }

            let group: CTaskGroup? = self.GetTaskGroup(sVal)

            if group == nil {
                //TODO: Emit warning
                completed = false
                return TASK_FAILED
            }

            completed = group!.Complete()
        } else {	//Otherwise it's a time completion wait
            if self.Check(ID_RANDOM, block, memberNum) {//get it random only the first time
                let min: Float
                let max: Float

                dwtime = block!.GetMemberData(memberNum)![float: 0]
                memberNum += 1
                if dwtime == Q3_INFINITE {//we have not evaluated this random yet
                    min = block!.GetMemberData(memberNum)![float: 0]
                    memberNum += 1
                    max = block!.GetMemberData(memberNum)![float: 0]
                    memberNum += 1

                    dwtime = (self.m_owner!.GetInterface())!.I_Random!(min, max)

                    //store the result in the first member
                    // AI: Raven hands the address of the float local to SetData. The value goes into a CharBuf of its bytes, and SetData copies them.
                    var bytes = CharBuf(Float.byteCount)
                    bytes.withMutableSlots {
                        $0[float: 0] = dwtime
                        bm!.SetData($0, Int32(Float.byteCount))
                    }
                }
            } else {
                // ICARUS_VALIDATE
                if self.GetFloat(self.m_ownerID, block, &memberNum, &dwtime) == 0 { return TASK_FAILED }
            }

            if task!.GetTimeStamp() == (self.m_owner!.GetInterface())!.I_GetTime!() {
                //Print out the debug info
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d wait( %d ); [%d]", self.m_ownerID, Int32(dwtime), task!.GetTimeStamp())
            }

            // C converts the DWORD time stamp and the DWORD time to float.
            if (Float(task!.GetTimeStamp()) + dwtime) < Float((self.m_owner!.GetInterface())!.I_GetTime!()) {
                completed = true
                memberNum = 0
                if self.Check(ID_RANDOM, block, memberNum) {//set the data back to 0 so it will be re-randomized next time
                    // C converts the int Q3_INFINITE to the float local.
                    dwtime = Float(Q3_INFINITE)
                    // AI: Raven hands the address of the float local to SetData. The value goes into a CharBuf of its bytes, and SetData copies them.
                    var bytes = CharBuf(Float.byteCount)
                    bytes.withMutableSlots {
                        $0[float: 0] = dwtime
                        bm!.SetData($0, Int32(Float.byteCount))
                    }
                }
            }
        }

        return TASK_OK
    }

    /**
    ```
    -------------------------
    WaitSignal
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1146
    @discardableResult
    private func WaitSignal(_ task: CTask?, _ completed: inout Bool) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var memberNum: Int32 = 0

        completed = false

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

        if task!.GetTimeStamp() == (self.m_owner!.GetInterface())!.I_GetTime!() {
            //Print out the debug info
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d waitsignal(\"%s\"); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())
        }

        if (self.m_owner!.GetOwner())!.CheckSignal(sVal) {
            completed = true
            (self.m_owner!.GetOwner())!.ClearSignal(sVal)
        }

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Print
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1177
    @discardableResult
    private func Print(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d print(\"%s\"); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())

        (self.m_owner!.GetInterface())!.I_CenterPrint!(sVal)

        self.Completed(task!.GetGUID())

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Sound
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1200
    @discardableResult
    private func Sound(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var sVal2 = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }
        if self.Get(self.m_ownerID, block, &memberNum, &sVal2) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d sound(\"%s\", \"%s\"); [%d]", self.m_ownerID, sVal, sVal2, task!.GetTimeStamp())

        //Only instantly complete if the user has requested it
        if (self.m_owner!.GetInterface())!.I_PlaySound!(task!.GetGUID(), self.m_ownerID, sVal2, sVal) != 0 {
            self.Completed(task!.GetGUID())
        }

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Rotate
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1224
    @discardableResult
    private func Rotate(_ task: CTask?) -> Int32 {
        var vector = vec3_t()
        let block: CBlock? = task!.GetBlock()
        var tagName = ""
        var tagLookup: Float = 0
        var duration: Float = 0
        var memberNum: Int32 = 0

        //Check for a tag reference
        if self.Check(ID_TAG, block, memberNum) {
            memberNum += 1

            // ICARUS_VALIDATE
            if self.Get(self.m_ownerID, block, &memberNum, &tagName) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &tagLookup) == 0 { return TASK_FAILED }

            if (self.m_owner!.GetInterface())!.I_GetTag!(self.m_ownerID, tagName, Int32(tagLookup), &vector) == 0 {
                //TODO: Emit warning
                (self.m_owner!.GetInterface())!.I_DPrintf!(WL_ERROR, "Unable to find tag \"%s\"!\n", tagName)
                return TASK_FAILED
            }
        } else {
            //Get a normal vector
            if self.GetVector(self.m_ownerID, block, &memberNum, &vector) == 0 { return TASK_FAILED }
        }

        //Find the duration
        if self.GetFloat(self.m_ownerID, block, &memberNum, &duration) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d rotate( <%f,%f,%f>, %d); [%d]", self.m_ownerID, vector[0], vector[1], vector[2], Int32(duration), task!.GetTimeStamp())
        (self.m_owner!.GetInterface())!.I_Lerp2Angles!(task!.GetGUID(), self.m_ownerID, &vector, duration)

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Remove
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1269
    @discardableResult
    private func Remove(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d remove(\"%s\"); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())
        (self.m_owner!.GetInterface())!.I_Remove!(self.m_ownerID, sVal)

        self.Completed(task!.GetGUID())

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Camera
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1291
    @discardableResult
    private func Camera(_ task: CTask?) -> Int32 {
        let ie: interface_export_t? = (self.m_owner!.GetInterface())
        let block: CBlock? = task!.GetBlock()
        var vector = vec3_t()
        var vector2 = vec3_t()
        var type: Float = 0
        var fVal: Float = 0
        var fVal2: Float = 0
        var fVal3: Float = 0
        var sVal = ""
        var memberNum: Int32 = 0

        //Get the camera function type
        // ICARUS_VALIDATE
        if self.GetFloat(self.m_ownerID, block, &memberNum, &type) == 0 { return TASK_FAILED }

        switch Int32(type) {
        case TYPE_PAN:

            if self.GetVector(self.m_ownerID, block, &memberNum, &vector) == 0 { return TASK_FAILED }
            if self.GetVector(self.m_ownerID, block, &memberNum, &vector2) == 0 { return TASK_FAILED }

            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( PAN, <%f %f %f>, <%f %f %f>, %f); [%d]", self.m_ownerID, vector[0], vector[1], vector[2], vector2[0], vector2[1], vector2[2], fVal, task!.GetTimeStamp())
            ie!.I_CameraPan!(vector, vector2, fVal)

        case TYPE_ZOOM:

            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal2) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( ZOOM, %f, %f); [%d]", self.m_ownerID, fVal, fVal2, task!.GetTimeStamp())
            ie!.I_CameraZoom!(fVal, fVal2)

        case TYPE_MOVE:

            if self.GetVector(self.m_ownerID, block, &memberNum, &vector) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( MOVE, <%f %f %f>, %f); [%d]", self.m_ownerID, vector[0], vector[1], vector[2], fVal, task!.GetTimeStamp())
            ie!.I_CameraMove!(vector, fVal)

        case TYPE_ROLL:

            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal2) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( ROLL, %f, %f); [%d]", self.m_ownerID, fVal, fVal2, task!.GetTimeStamp())
            ie!.I_CameraRoll!(fVal, fVal2)

        case TYPE_FOLLOW:

            if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal2) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( FOLLOW, \"%s\", %f, %f); [%d]", self.m_ownerID, sVal, fVal, fVal2, task!.GetTimeStamp())
            ie!.I_CameraFollow!(sVal, fVal, fVal2)

        case TYPE_TRACK:

            if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal2) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( TRACK, \"%s\", %f, %f); [%d]", self.m_ownerID, sVal, fVal, fVal2, task!.GetTimeStamp())
            ie!.I_CameraTrack!(sVal, fVal, fVal2)

        case TYPE_DISTANCE:

            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal2) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( DISTANCE, %f, %f); [%d]", self.m_ownerID, fVal, fVal2, task!.GetTimeStamp())
            ie!.I_CameraDistance!(fVal, fVal2)

        case TYPE_FADE:

            if self.GetVector(self.m_ownerID, block, &memberNum, &vector) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }

            if self.GetVector(self.m_ownerID, block, &memberNum, &vector2) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal2) == 0 { return TASK_FAILED }

            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal3) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( FADE, <%f %f %f>, %f, <%f %f %f>, %f, %f); [%d]", self.m_ownerID, vector[0], vector[1], vector[2], fVal, vector2[0], vector2[1], vector2[2], fVal2, fVal3, task!.GetTimeStamp())
            ie!.I_CameraFade!(vector[0], vector[1], vector[2], fVal, vector2[0], vector2[1], vector2[2], fVal2, fVal3)

        case TYPE_PATH:
            if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( PATH, \"%s\"); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())
            ie!.I_CameraPath!(sVal)

        case TYPE_ENABLE:
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( ENABLE ); [%d]", self.m_ownerID, task!.GetTimeStamp())
            ie!.I_CameraEnable!()

        case TYPE_DISABLE:
            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( DISABLE ); [%d]", self.m_ownerID, task!.GetTimeStamp())
            ie!.I_CameraDisable!()

        case TYPE_SHAKE:
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }
            if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal2) == 0 { return TASK_FAILED }

            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d camera( SHAKE, %f, %f ); [%d]", self.m_ownerID, fVal, fVal2, task!.GetTimeStamp())
            ie!.I_CameraShake!(fVal, Int32(fVal2))

        default:
            break
        }

        self.Completed(task!.GetGUID())

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Move
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1425
    @discardableResult
    private func Move(_ task: CTask?) -> Int32 {
        var vector = vec3_t()
        var vector2 = vec3_t()
        let block: CBlock? = task!.GetBlock()
        var duration: Float = 0
        var memberNum: Int32 = 0

        //Get the goal position
        // ICARUS_VALIDATE
        if self.GetVector(self.m_ownerID, block, &memberNum, &vector) == 0 { return TASK_FAILED }

        //Check for possible angles field
        if self.GetVector(self.m_ownerID, block, &memberNum, &vector2) == 0 {
            if self.GetFloat(self.m_ownerID, block, &memberNum, &duration) == 0 { return TASK_FAILED }


            (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d move( <%f %f %f>, %f ); [%d]", self.m_ownerID, vector[0], vector[1], vector[2], duration, task!.GetTimeStamp())
            // Raven passes NULL for the angles.
            var noAngles: vec3_t? = nil
            (self.m_owner!.GetInterface())!.I_Lerp2Pos!(task!.GetGUID(), self.m_ownerID, &vector, &noAngles, duration)

            return TASK_OK
        }

        //Get the duration and make the call
        if self.GetFloat(self.m_ownerID, block, &memberNum, &duration) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d move( <%f %f %f>, <%f %f %f>, %f ); [%d]", self.m_ownerID, vector[0], vector[1], vector[2], vector2[0], vector2[1], vector2[2], duration, task!.GetTimeStamp())
        // The angles parameter of I_Lerp2Pos is an optional vector, so the call passes vector2 in an optional.
        var angles: vec3_t? = vector2
        (self.m_owner!.GetInterface())!.I_Lerp2Pos!(task!.GetGUID(), self.m_ownerID, &vector, &angles, duration)

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Kill
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1462
    @discardableResult
    private func Kill(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d kill( \"%s\" ); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())
        (self.m_owner!.GetInterface())!.I_Kill!(self.m_ownerID, sVal)

        self.Completed(task!.GetGUID())

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Set
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1484
    @discardableResult
    private func Set(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var sVal2 = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }
        if self.Get(self.m_ownerID, block, &memberNum, &sVal2) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d set( \"%s\", \"%s\" ); [%d]", self.m_ownerID, sVal, sVal2, task!.GetTimeStamp())
        (self.m_owner!.GetInterface())!.I_Set!(task!.GetGUID(), self.m_ownerID, sVal, sVal2)

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Use
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1505
    @discardableResult
    private func Use(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d use( \"%s\" ); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())
        (self.m_owner!.GetInterface())!.I_Use!(self.m_ownerID, sVal)

        self.Completed(task!.GetGUID())

        return TASK_OK
    }

    /**
    ```
    -------------------------
    DeclareVariable
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1527
    @discardableResult
    private func DeclareVariable(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var memberNum: Int32 = 0
        var fVal: Float = 0

        // ICARUS_VALIDATE
        if self.GetFloat(self.m_ownerID, block, &memberNum, &fVal) == 0 { return TASK_FAILED }
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d declare( %d, \"%s\" ); [%d]", self.m_ownerID, Int32(fVal), sVal, task!.GetTimeStamp())
        (self.m_owner!.GetInterface())!.I_DeclareVariable!(Int32(fVal), sVal)

        self.Completed(task!.GetGUID())

        return TASK_OK
    }

    /**
    ```
    -------------------------
    FreeVariable
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1552
    @discardableResult
    private func FreeVariable(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d free( \"%s\" ); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())
        (self.m_owner!.GetInterface())!.I_FreeVariable!(sVal)

        self.Completed(task!.GetGUID())

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Signal
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1575
    @discardableResult
    private func Signal(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d signal( \"%s\" ); [%d]", self.m_ownerID, sVal, task!.GetTimeStamp())
        (self.m_owner!.GetOwner())!.Signal(sVal)

        self.Completed(task!.GetGUID())

        return TASK_OK
    }

    /**
    ```
    -------------------------
    Play
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:1597
    @discardableResult
    private func Play(_ task: CTask?) -> Int32 {
        let block: CBlock? = task!.GetBlock()
        var sVal = ""
        var sVal2 = ""
        var memberNum: Int32 = 0

        // ICARUS_VALIDATE
        if self.Get(self.m_ownerID, block, &memberNum, &sVal) == 0 { return TASK_FAILED }
        if self.Get(self.m_ownerID, block, &memberNum, &sVal2) == 0 { return TASK_FAILED }

        (self.m_owner!.GetInterface())!.I_DPrintf!(WL_DEBUG, "%4d play( \"%s\", \"%s\" ); [%d]", self.m_ownerID, sVal, sVal2, task!.GetTimeStamp())
        (self.m_owner!.GetInterface())!.I_Play!(task!.GetGUID(), self.m_ownerID, sVal, sVal2)

        return TASK_OK
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
    // Port-note: Rule 20. The one caller is CTaskManager::Save, and Raven compiles that call out with `#if 0` at TaskManager.cpp:1665, so the function keeps its marker.
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
