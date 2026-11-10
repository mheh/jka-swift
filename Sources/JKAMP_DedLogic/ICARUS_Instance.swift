import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's ICARUS instance, the owner of every sequence, every sequencer, and the signal table of the game.
/// One instance exists, `iICARUS` of GameInterface.cpp.
/// Source: oracle/codemp/icarus/instance.h:12
// AI: Raven's destructor has an empty body. ARC frees the class, so the destructor drops.
// AI: Raven declares the save and load methods virtual, and no class derives from ICARUS_Instance. The final class makes each one a plain method.
final class ICARUS_Instance {
    // AI: Raven types these with std::list and std::map. Each is an Array or a Dictionary, by rule 17.
    typealias sequence_l = [CSequence]
    typealias sequencer_l = [CSequencer]
    typealias signal_m = [String: Int32]

    private var m_interface: interface_export_t? = nil
    private var m_GUID: Int32 = 0

    private var m_sequences: sequence_l = []
    private var m_sequencers: sequencer_l = []

    private var m_signals: signal_m = [:]

    // AI: Raven declares six m_DEBUG_ counters under _DEBUG. The release build has no _DEBUG, so the fields drop.

    // Instance
    /// Source: oracle/codemp/icarus/Instance.cpp:24
    init() {
        self.m_GUID = 0

        //to be safe
        gSequencers = gSequencers.map { _ in nil }
        gTaskManagers = gTaskManagers.map { _ in nil }
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:56
    static func Create(_ ie: interface_export_t?) -> ICARUS_Instance? {
        // TODO: Port ICARUS_Instance::Create
        portMissing("ICARUS_Instance::Create", source: "oracle/codemp/icarus/Instance.cpp:56")
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:72
    private func Free() -> Int32 {
        //Delete any residual sequencers
        for sri in self.m_sequencers {
            // AI: Raven deletes each sequencer, and the destructor calls Free. ARC runs no destructor here, so the loop calls Free.
            _ = sri.Free()
        }

        self.m_sequencers.removeAll()
        //all these are deleted now so clear the global map.
        gSequencers = gSequencers.map { _ in nil }
        gTaskManagers = gTaskManagers.map { _ in nil }
        self.m_signals.removeAll()

        //Delete any residual sequences
        for si in self.m_sequences {
            // AI: Raven deletes each sequence, and the destructor calls Delete. ARC runs no destructor here, so the loop calls Delete.
            si.Delete()
        }

        self.m_sequences.removeAll()

        return 1
    }

    /**
    ```
    -------------------------
    Delete
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:121
    func Delete() -> Int32 {
        _ = self.Free()

        // AI: Raven deletes the instance here. ARC frees it when ICARUS_Shutdown drops `iICARUS`, so the step drops.

        return 1
    }

    /**
    ```
    -------------------------
    GetSequencer
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:165
    func GetSequencer(_ ownerID: Int32) -> CSequencer? {
        let sequencer: CSequencer? = CSequencer.Create()
        let taskManager: CTaskManager? = CTaskManager.Create()

        // Port-note: CSequencer.Init keeps its signature marker for `interface_export_t *`, so the call passes no arguments.
        // Raven wrote: sequencer->Init( ownerID, m_interface, taskManager, this );
        sequencer!.Init()

        _ = taskManager!.Init(sequencer)

        self.m_sequencers.append(sequencer!)

        return sequencer
    }

    /**
    ```
    -------------------------
    DeleteSequencer
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:191
    func DeleteSequencer(_ sequencer: CSequencer?) {
        // added 2/12/2 to properly delete blocks that were passed to the task manager
        _ = sequencer!.Recall()

        let taskManager: CTaskManager? = sequencer!.GetTaskManager()

        if taskManager != nil {
            _ = taskManager!.Free()
        }

        self.m_sequencers.removeAll { $0 === sequencer }

        _ = sequencer!.Free()
    }

    /**
    ```
    -------------------------
    GetSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:223
    func GetSequence() -> CSequence? {
        let sequence: CSequence? = CSequence.Create()

        //Assign the GUID
        sequence!.SetID(self.m_GUID)
        self.m_GUID += 1
        sequence!.SetOwner(self)

        self.m_sequences.append(sequence!)

        return sequence
    }

    /**
    ```
    -------------------------
    GetSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:248
    func GetSequence(_ id: Int32) -> CSequence? {
        for si in self.m_sequences {
            if si.GetID() == id {
                return si
            }
        }

        return nil
    }

    /**
    ```
    -------------------------
    DeleteSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:266
    func DeleteSequence(_ sequence: CSequence?) {
        self.m_sequences.removeAll { $0 === sequence }

        // AI: Raven deletes the sequence, and the destructor calls Delete.
        // The parent and the sequencer can still hold a reference, so the body calls Delete.
        sequence!.Delete()
    }

    /**
    ```
    -------------------------
    AllocateSequences
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:285
    private func AllocateSequences(_ numSequences: Int32, _ idTable: [Int32]) -> Int32 {
        var sequence: CSequence?

        var i: Int32 = 0
        while i < numSequences {
            //If the GUID of this sequence is higher than the current, take this a the "current" GUID
            if idTable[i] > self.m_GUID {
                self.m_GUID = idTable[i]
            }

            //Allocate the container sequence
            sequence = self.GetSequence()
            if sequence == nil {
                return 0
            }

            //Override the given GUID with the real one
            sequence!.SetID(idTable[i])
            i += 1
        }

        return 1
    }

    /**
    ```
    -------------------------
    SaveSequenceIDTable
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:312
    // Port-note: The body calls through `m_interface`, and `interface_export_t` has no Swift form, so the body waits for that row.
    private func SaveSequenceIDTable() -> Int32 {
        // TODO: Port ICARUS_Instance::SaveSequenceIDTable
        portMissing("ICARUS_Instance::SaveSequenceIDTable", source: "oracle/codemp/icarus/Instance.cpp:312")
    }

    /**
    ```
    -------------------------
    SaveSequences
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:346
    private func SaveSequences() -> Int32 {
        //Save out a listing of all the used sequences by ID
        _ = self.SaveSequenceIDTable()

        //Save all the information in order
        for sqi in self.m_sequences {
            _ = sqi.Save()
        }

        return 1
    }

    /**
    ```
    -------------------------
    SaveSequencers
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:367
    // Port-note: The body calls through `m_interface`, and `interface_export_t` has no Swift form, so the body waits for that row.
    private func SaveSequencers() -> Int32 {
        // TODO: Port ICARUS_Instance::SaveSequencers
        portMissing("ICARUS_Instance::SaveSequencers", source: "oracle/codemp/icarus/Instance.cpp:367")
    }

    /**
    ```
    -------------------------
    SaveSignals
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:389
    // Port-note: The body calls through `m_interface`, and `interface_export_t` has no Swift form, so the body waits for that row.
    private func SaveSignals() -> Int32 {
        // TODO: Port ICARUS_Instance::SaveSignals
        portMissing("ICARUS_Instance::SaveSignals", source: "oracle/codemp/icarus/Instance.cpp:389")
    }

    /**
    ```
    -------------------------
    Save
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:422
    // Port-note: The body calls through `m_interface`, and `interface_export_t` has no Swift form, so the body waits for that row.
    func Save() -> Int32 {
        // TODO: Port ICARUS_Instance::Save
        portMissing("ICARUS_Instance::Save", source: "oracle/codemp/icarus/Instance.cpp:422")
    }

    /**
    ```
    -------------------------
    LoadSignals
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:451
    // Port-note: The body calls through `m_interface`, and `interface_export_t` has no Swift form, so the body waits for that row.
    private func LoadSignals() -> Int32 {
        // TODO: Port ICARUS_Instance::LoadSignals
        portMissing("ICARUS_Instance::LoadSignals", source: "oracle/codemp/icarus/Instance.cpp:451")
    }

    /**
    ```
    -------------------------
    LoadSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:483
    private func LoadSequence() -> Int32 {
        let sequence: CSequence? = self.GetSequence()

        //Load the sequence back in
        _ = sequence!.Load()

        //If this sequence had a higher GUID than the current, save it
        if sequence!.GetID() > self.m_GUID {
            self.m_GUID = sequence!.GetID()
        }

        return 1
    }

    /**
    ```
    -------------------------
    LoadSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:503
    // Port-note: The body calls through `m_interface`, and `interface_export_t` has no Swift form, so the body waits for that row.
    private func LoadSequences() -> Int32 {
        // TODO: Port ICARUS_Instance::LoadSequences
        portMissing("ICARUS_Instance::LoadSequences", source: "oracle/codemp/icarus/Instance.cpp:503")
    }

    /**
    ```
    -------------------------
    LoadSequencers
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:547
    // Port-note: The body calls through `m_interface`, and `interface_export_t` has no Swift form, so the body waits for that row.
    private func LoadSequencers() -> Int32 {
        // TODO: Port ICARUS_Instance::LoadSequencers
        portMissing("ICARUS_Instance::LoadSequencers", source: "oracle/codemp/icarus/Instance.cpp:547")
    }

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:575
    // Port-note: The body calls through `m_interface`, and `interface_export_t` has no Swift form, so the body waits for that row.
    func Load() -> Int32 {
        // TODO: Port ICARUS_Instance::Load
        portMissing("ICARUS_Instance::Load", source: "oracle/codemp/icarus/Instance.cpp:575")
    }

    /**
    ```
    -------------------------
    Signal
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:623
    func Signal(_ identifier: String) {
        self.m_signals[identifier] = 1
    }

    /**
    ```
    -------------------------
    CheckSignal
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:634
    func CheckSignal(_ identifier: String) -> Bool {
        let smi: Int32? = self.m_signals[identifier]

        if smi == nil {
            return false
        }

        return true
    }

    /**
    ```
    -------------------------
    ClearSignal
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:652
    func ClearSignal(_ identifier: String) {
        self.m_signals[identifier] = nil
    }

    /// Source: oracle/codemp/icarus/instance.h:33
    func GetInterface() -> interface_export_t? {
        self.m_interface
    }
}
