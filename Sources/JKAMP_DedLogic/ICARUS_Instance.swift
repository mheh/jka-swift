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
        // TODO: Port ICARUS_Instance::ICARUS_Instance
        portMissing("ICARUS_Instance::ICARUS_Instance", source: "oracle/codemp/icarus/Instance.cpp:24")
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
        // TODO: Port ICARUS_Instance::Free
        portMissing("ICARUS_Instance::Free", source: "oracle/codemp/icarus/Instance.cpp:72")
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
        // TODO: Port ICARUS_Instance::Delete
        portMissing("ICARUS_Instance::Delete", source: "oracle/codemp/icarus/Instance.cpp:121")
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
        // TODO: Port ICARUS_Instance::GetSequencer
        portMissing("ICARUS_Instance::GetSequencer", source: "oracle/codemp/icarus/Instance.cpp:165")
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
        // TODO: Port ICARUS_Instance::DeleteSequencer
        portMissing("ICARUS_Instance::DeleteSequencer", source: "oracle/codemp/icarus/Instance.cpp:191")
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
        // TODO: Port ICARUS_Instance::GetSequence
        portMissing("ICARUS_Instance::GetSequence", source: "oracle/codemp/icarus/Instance.cpp:223")
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
        // TODO: Port ICARUS_Instance::GetSequence
        portMissing("ICARUS_Instance::GetSequence", source: "oracle/codemp/icarus/Instance.cpp:248")
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
        // TODO: Port ICARUS_Instance::DeleteSequence
        portMissing("ICARUS_Instance::DeleteSequence", source: "oracle/codemp/icarus/Instance.cpp:266")
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
        // TODO: Port ICARUS_Instance::AllocateSequences
        portMissing("ICARUS_Instance::AllocateSequences", source: "oracle/codemp/icarus/Instance.cpp:285")
    }

    /**
    ```
    -------------------------
    SaveSequenceIDTable
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:312
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
        // TODO: Port ICARUS_Instance::SaveSequences
        portMissing("ICARUS_Instance::SaveSequences", source: "oracle/codemp/icarus/Instance.cpp:346")
    }

    /**
    ```
    -------------------------
    SaveSequencers
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:367
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
        // TODO: Port ICARUS_Instance::LoadSequence
        portMissing("ICARUS_Instance::LoadSequence", source: "oracle/codemp/icarus/Instance.cpp:483")
    }

    /**
    ```
    -------------------------
    LoadSequence
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:503
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
        // TODO: Port ICARUS_Instance::Signal
        portMissing("ICARUS_Instance::Signal", source: "oracle/codemp/icarus/Instance.cpp:623")
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
        // TODO: Port ICARUS_Instance::CheckSignal
        portMissing("ICARUS_Instance::CheckSignal", source: "oracle/codemp/icarus/Instance.cpp:634")
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
        // TODO: Port ICARUS_Instance::ClearSignal
        portMissing("ICARUS_Instance::ClearSignal", source: "oracle/codemp/icarus/Instance.cpp:652")
    }

    /// Source: oracle/codemp/icarus/instance.h:33
    func GetInterface() -> interface_export_t? {
        self.m_interface
    }
}
