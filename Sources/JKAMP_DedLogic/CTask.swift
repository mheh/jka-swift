import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's task, one command block that the task manager runs, with its GUID and its start time.
/// Source: oracle/codemp/icarus/taskmanager.h:33
// AI: Raven's destructor has an empty body. ARC frees the class, so the destructor drops.
final class CTask {
    private var m_id: Int32 = 0
    private var m_timeStamp: Int32 = 0
    private var m_block: CBlock? = nil

    /**
    ```
    =================================================

    CTask

    =================================================
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:27
    init() {
        // TODO: Port CTask::CTask
        portMissing("CTask::CTask", source: "oracle/codemp/icarus/TaskManager.cpp:27")
    }

    /// Source: oracle/codemp/icarus/TaskManager.cpp:35
    static func Create(_ GUID: Int32, _ block: CBlock?) -> CTask? {
        // TODO: Port CTask::Create
        portMissing("CTask::Create", source: "oracle/codemp/icarus/TaskManager.cpp:35")
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:57
    func Free() {
        // TODO: Port CTask::Free
        portMissing("CTask::Free", source: "oracle/codemp/icarus/TaskManager.cpp:57")
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:44
    func GetTimeStamp() -> Int32 {
        self.m_timeStamp
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:45
    func GetBlock() -> CBlock? {
        self.m_block
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:46
    func GetGUID() -> Int32 {
        self.m_id
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:47
    func GetID() -> Int32 {
        // TODO: Port CTask::GetID
        portMissing("CTask::GetID", source: "oracle/codemp/icarus/taskmanager.h:47")
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:49
    func SetTimeStamp(_ timeStamp: Int32) {
        self.m_timeStamp = timeStamp
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:50
    func SetBlock(_ block: CBlock?) {
        self.m_block = block
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:51
    func SetGUID(_ id: Int32) {
        self.m_id = id
    }
}
