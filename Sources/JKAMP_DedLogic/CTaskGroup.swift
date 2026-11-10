import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's task group, the tasks of one named task block, with the completion state of each task.
/// Source: oracle/codemp/icarus/taskmanager.h:62
// AI: Raven's destructor only clears m_completedTasks. ARC frees the class and the table, so the destructor drops.
final class CTaskGroup {
    // AI: Raven types the table with std::map. It is a Dictionary, by rule 17.
    typealias taskCallback_m = [Int32: Bool]

    //protected:

    var m_completedTasks: taskCallback_m = [:]

    var m_parent: CTaskGroup? = nil

    var m_numCompleted: Int32 = 0
    var m_GUID: Int32 = 0

    /**
    ```
    =================================================

    CTaskGroup

    =================================================
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:71
    init() {
        self.Init()

        self.m_GUID = 0
        self.m_parent = nil
    }

    /**
    ```
    -------------------------
    SetGUID
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:90
    func SetGUID(_ GUID: Int32) {
        self.m_GUID = GUID
    }

    /**
    ```
    -------------------------
    Init
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:101
    func Init() {
        self.m_completedTasks.removeAll()

        self.m_numCompleted = 0
        self.m_parent = nil
    }

    /**
    ```
    -------------------------
    Add
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:115
    func Add(_ task: CTask?) -> Int32 {
        self.m_completedTasks[task!.GetGUID()] = false
        return TASK_OK
    }

    /**
    ```
    -------------------------
    MarkTaskComplete
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/TaskManager.cpp:127
    func MarkTaskComplete(_ id: Int32) -> Bool {
        if self.m_completedTasks[id] != nil {
            self.m_completedTasks[id] = true
            self.m_numCompleted += 1

            return true
        }

        return false
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:76
    func SetParent(_ group: CTaskGroup?) {
        self.m_parent = group
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:78
    func Complete() -> Bool {
        self.m_numCompleted == self.m_completedTasks.count
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:82
    func GetParent() -> CTaskGroup? {
        self.m_parent
    }

    /// Source: oracle/codemp/icarus/taskmanager.h:83
    func GetGUID() -> Int32 {
        self.m_GUID
    }
}
