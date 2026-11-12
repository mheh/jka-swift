import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's task, one command block that the task manager runs, with its GUID and its start time.
/// Source: oracle/codemp/icarus/taskmanager.h:33
// AI: Raven's destructor has an empty body. ARC frees the class, so the destructor drops.
public final class CTask {
    private var m_id: Int32 = 0
    private var m_timeStamp: UInt32 = 0
    private var m_block: CBlock? = nil

    /**
    ```
    =================================================

    CTask

    =================================================
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:27
    public init() {}

    /// Source: oracle/codemp/icarus/TaskManager.cpp:35
    public static func Create(_ GUID: Int32, _ block: CBlock?) -> CTask? {
        let task: CTask? = CTask()

        //TODO: Emit warning
        if task == nil {
            return nil
        }

        task!.SetTimeStamp(0)
        task!.SetBlock(block)
        task!.SetGUID(GUID)

        return task
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:57
    public func Free() {
        //NOTENOTE: The block is not consumed by the task, it is the sequencer's job to clean blocks up
        // AI: Raven deletes the task here. ARC frees the task when the last reference drops, so the body holds no statement.
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:44
    public func GetTimeStamp() -> UInt32 {
        self.m_timeStamp
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:45
    public func GetBlock() -> CBlock? {
        self.m_block
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:46
    public func GetGUID() -> Int32 {
        self.m_id
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:47
    public func GetID() -> Int32 {
        self.m_block!.GetBlockID()
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:49
    public func SetTimeStamp(_ timeStamp: UInt32) {
        self.m_timeStamp = timeStamp
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:50
    public func SetBlock(_ block: CBlock?) {
        self.m_block = block
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:51
    public func SetGUID(_ id: Int32) {
        self.m_id = id
    }
}
