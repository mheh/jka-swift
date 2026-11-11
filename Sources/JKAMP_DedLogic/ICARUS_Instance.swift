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
        let instance: ICARUS_Instance? = ICARUS_Instance()
        instance!.m_interface = ie
        // AI: Raven calls the Win32 OutputDebugString for the debugger window. A POSIX host has no such window, so the call drops.
        return instance
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:72
    @discardableResult
    private func Free() -> Int32 {
        //Delete any residual sequencers
        for sri in self.m_sequencers {
            // AI: Raven deletes each sequencer, and the destructor calls Free. ARC runs no destructor here, so the loop calls Free.
            sri.Free()
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
        self.Free()

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

        sequencer!.Init(ownerID, self.m_interface, taskManager, self)

        taskManager!.Init(sequencer)

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
        sequencer!.Recall()

        let taskManager: CTaskManager? = sequencer!.GetTaskManager()

        if taskManager != nil {
            taskManager!.Free()
        }

        self.m_sequencers.removeAll { $0 === sequencer }

        sequencer!.Free()
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
    // Port-note: Rule 20. The one path to this function is ICARUS_Instance::Save, which has no caller in oracle/codemp.
    @discardableResult
    private func SaveSequenceIDTable() -> Int32 {
        // AI: Raven writes each value through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        // AI: Raven passes each chunk ID as a four-character constant. The body passes its value as hex, with the text in a trailing comment.
        var value = CharBuf(Int32.byteCount)

        //Save out the number of sequences to follow
        let numSequences = Int32(self.m_sequences.count)
        value.withMutableSlots { $0[int: 0] = numSequences }
        _ = value.withSlots { self.m_interface!.I_WriteSaveData!(0x2353_4551, $0, Int32(Int32.byteCount)) } // '#SEQ'

        //Sequences are saved first, by ID and information

        //First pass, save all sequences ID for reconstruction
        // AI: Raven fills a `new int[]` block and tests it for NULL. The table is a CharBuf of its bytes, which is never nil, so the test drops.
        var idTable = CharBuf(Int32(Int32.byteCount) * numSequences)
        var itr: Int32 = 0

        for sqi in self.m_sequences {
            idTable.withMutableSlots { $0[int: itr * Int32(Int32.byteCount)] = sqi.GetID() }
            itr += 1
        }

        _ = idTable.withSlots { self.m_interface!.I_WriteSaveData!(0x5351_5442, $0, Int32(Int32.byteCount) * numSequences) } // 'SQTB'

        // AI: Raven deletes the table here. ARC frees the CharBuf, so the step drops.

        return 1
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
        self.SaveSequenceIDTable()

        //Save all the information in order
        for sqi in self.m_sequences {
            sqi.Save()
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
    // Port-note: Rule 20. The one path to this function is ICARUS_Instance::Save, which has no caller in oracle/codemp.
    private func SaveSequencers() -> Int32 {
        // AI: Raven writes each value through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        // AI: Raven passes each chunk ID as a four-character constant. The body passes its value as hex, with the text in a trailing comment.
        var value = CharBuf(Int32.byteCount)

        //Save out the number of sequences to follow
        let numSequencers = Int32(self.m_sequencers.count)
        value.withMutableSlots { $0[int: 0] = numSequencers }
        _ = value.withSlots { self.m_interface!.I_WriteSaveData!(0x2353_5152, $0, Int32(Int32.byteCount)) } // '#SQR'

        //The sequencers are then saved
        for si in self.m_sequencers {
            si.Save()
        }

        return 1
    }

    /**
    ```
    -------------------------
    SaveSignals
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:389
    // Port-note: Rule 20. The one path to this function is ICARUS_Instance::Save, which has no caller in oracle/codemp.
    private func SaveSignals() -> Int32 {
        // AI: Raven writes each value through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        // AI: Raven passes each chunk ID as a four-character constant. The body passes its value as hex, with the text in a trailing comment.
        var value = CharBuf(Int32.byteCount)

        let numSignals = Int32(self.m_signals.count)

        value.withMutableSlots { $0[int: 0] = numSignals }
        _ = value.withSlots { self.m_interface!.I_WriteSaveData!(0x4953_4947, $0, Int32(Int32.byteCount)) } // 'ISIG'

        // AI: Raven walks the std::map in the order of its keys. The Dictionary has no order, so the loop walks the sorted keys.
        for si in self.m_signals.keys.sorted() {
            //m_interface->I_WriteSaveData( 'ISIG', &numSignals, sizeof( numSignals ) );
            let name = CharBuf(si)

            //Make sure this is a valid string
            // AI: Raven also tests the pointer for NULL. A String is never nil, so that test drops.
            assert(name[0] != 0)

            let length: Int32 = strlen(name) + 1

            //Save out the string size
            value.withMutableSlots { $0[int: 0] = length }
            _ = value.withSlots { self.m_interface!.I_WriteSaveData!(0x5349_4723, $0, Int32(Int32.byteCount)) } // 'SIG#'

            //Write out the string
            _ = name.withSlots { self.m_interface!.I_WriteSaveData!(0x5349_474E, $0, length) } // 'SIGN'
        }

        return 1
    }

    /**
    ```
    -------------------------
    Save
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:422
    // Port-note: Rule 20. No file of oracle/codemp calls this function.
    @discardableResult
    func Save() -> Int32 {
        // AI: Raven writes each value through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        // AI: Raven passes each chunk ID as a four-character constant. The body passes its value as hex, with the text in a trailing comment.
        var value = CharBuf(Double.byteCount)

        //Save out a ICARUS save block header with the ICARUS version
        let version: Double = ICARUS_VERSION
        value.withMutableSlots { $0[double: 0] = version }
        _ = value.withSlots { self.m_interface!.I_WriteSaveData!(0x4943_4152, $0, Int32(Double.byteCount)) } // 'ICAR'

        //Save out the signals
        if self.SaveSignals() == 0 {
            return 0
        }

        //Save out the sequences
        if self.SaveSequences() == 0 {
            return 0
        }

        //Save out the sequencers
        if self.SaveSequencers() == 0 {
            return 0
        }

        _ = value.withSlots { self.m_interface!.I_WriteSaveData!(0x4945_4E44, $0, Int32(Double.byteCount)) } // 'IEND'

        return 1
    }

    /**
    ```
    -------------------------
    LoadSignals
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:451
    // Port-note: Rule 20. The one path to this function is ICARUS_Instance::Load, which has no caller in oracle/codemp.
    private func LoadSignals() -> Int32 {
        // AI: Raven reads each value through its address. The read fills a CharBuf of the value's bytes, and the body takes the value from it.
        // AI: Raven passes each chunk ID as a four-character constant. The body passes its value as hex, with the text in a trailing comment.
        var value = CharBuf(Int32.byteCount)
        let numSignals: Int32

        // Port-note: Rule 19. ReadFromSaveGame of MP fills nothing, so Raven reads an unset local. The CharBuf starts at zero.
        _ = value.withMutableSlots { self.m_interface!.I_ReadSaveData!(0x4953_4947, $0, Int32(Int32.byteCount)) } // 'ISIG'
        numSignals = value.withSlots { $0[int: 0] }

        var i: Int32 = 0
        while i < numSignals {
            var buffer = CharBuf(1024)
            let length: Int32

            //Get the size of the string
            _ = value.withMutableSlots { self.m_interface!.I_ReadSaveData!(0x5349_4723, $0, Int32(Int32.byteCount)) } // 'SIG#'
            length = value.withSlots { $0[int: 0] }

            // C converts the `int` length to the unsigned `size_t` of `sizeof` for the compare.
            assert(UInt32(bitPattern: length) < buffer.count)

            //Get the string
            _ = buffer.withMutableSlots { self.m_interface!.I_ReadSaveData!(0x5349_474E, $0, length) } // 'SIGN'

            //Turn it on and add it to the system
            self.Signal(String(buffer))
            i += 1
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
    /// Source: oracle/codemp/icarus/Instance.cpp:483
    private func LoadSequence() -> Int32 {
        let sequence: CSequence? = self.GetSequence()

        //Load the sequence back in
        sequence!.Load()

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
    // Port-note: Rule 20. The one path to this function is ICARUS_Instance::Load, which has no caller in oracle/codemp.
    private func LoadSequences() -> Int32 {
        var sequence: CSequence?
        let numSequences: Int32
        // AI: Raven reads each value through its address. The read fills a CharBuf of the value's bytes, and the body takes the value from it.
        // AI: Raven passes each chunk ID as a four-character constant. The body passes its value as hex, with the text in a trailing comment.
        var value = CharBuf(Int32.byteCount)

        //Get the number of sequences to read in
        // Port-note: Rule 19. ReadFromSaveGame of MP fills nothing, so Raven reads an unset local. The CharBuf starts at zero.
        _ = value.withMutableSlots { self.m_interface!.I_ReadSaveData!(0x2353_4551, $0, Int32(Int32.byteCount)) } // '#SEQ'
        numSequences = value.withSlots { $0[int: 0] }

        // AI: Raven reads into a `new int[]` block and tests it for NULL. The read fills a CharBuf, which is never nil, so the test drops.
        var idBytes = CharBuf(Int32(Int32.byteCount) * numSequences)

        //Load the sequencer ID table
        _ = idBytes.withMutableSlots { self.m_interface!.I_ReadSaveData!(0x5351_5442, $0, Int32(Int32.byteCount) * numSequences) } // 'SQTB'
        // AI: Raven hands the block to AllocateSequences. The body takes the Array of its parameter from the bytes.
        let idTable: [Int32] = idBytes.withSlots { table in (0..<numSequences).map { table[int: $0 * Int32(Int32.byteCount)] } }

        //First pass, allocate all container sequences and give them their proper IDs
        if self.AllocateSequences(numSequences, idTable) == 0 {
            return 0
        }

        //Second pass, load all sequences
        var i: Int32 = 0
        while i < numSequences {
            //Get the proper sequence for this load
            sequence = self.GetSequence(idTable[i])
            if sequence == nil {
                return 0
            }

            //Load the sequence
            if sequence!.Load() == 0 {
                return 0
            }
            i += 1
        }

        //Free the idTable
        // AI: Raven deletes the table here. ARC frees the CharBuf and the Array, so the step drops.

        return 1
    }

    /**
    ```
    -------------------------
    LoadSequencers
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:547
    // Port-note: Rule 20. The one path to this function is ICARUS_Instance::Load, which has no caller in oracle/codemp.
    private func LoadSequencers() -> Int32 {
        var sequencer: CSequencer?
        let numSequencers: Int32
        // AI: Raven reads each value through its address. The read fills a CharBuf of the value's bytes, and the body takes the value from it.
        // AI: Raven passes each chunk ID as a four-character constant. The body passes its value as hex, with the text in a trailing comment.
        var value = CharBuf(Int32.byteCount)

        //Get the number of sequencers to load
        // Raven's `sizeof(&numSequencers)` is the size of a pointer in his 32-bit build, 4, the size of the `int`.
        // Port-note: Rule 19. ReadFromSaveGame of MP fills nothing, so Raven reads an unset local. The CharBuf starts at zero.
        _ = value.withMutableSlots { self.m_interface!.I_ReadSaveData!(0x2353_5152, $0, Int32(Int32.byteCount)) } // '#SQR'
        numSequencers = value.withSlots { $0[int: 0] }

        //Load all sequencers
        var i: Int32 = 0
        while i < numSequencers {
            //NOTENOTE: The ownerID will be replaced in the loading process
            sequencer = self.GetSequencer(-1)
            if sequencer == nil {
                return 0
            }

            if sequencer!.Load() == 0 {
                return 0
            }
            i += 1
        }

        return 1
    }

    /**
    ```
    -------------------------
    Load
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/Instance.cpp:575
    // Port-note: Rule 20. No file of oracle/codemp calls this function.
    @discardableResult
    func Load() -> Int32 {
        // AI: Raven reads each value through its address. The read fills a CharBuf of the value's bytes, and the body takes the value from it.
        // AI: Raven passes each chunk ID as a four-character constant. The body passes its value as hex, with the text in a trailing comment.
        var value = CharBuf(Double.byteCount)

        //Clear out any old information
        self.Free()

        //Check to make sure we're at the ICARUS save block
        let version: Double
        // Port-note: Rule 19. ReadFromSaveGame of MP fills nothing, so Raven reads an unset local. The CharBuf starts at zero.
        _ = value.withMutableSlots { self.m_interface!.I_ReadSaveData!(0x4943_4152, $0, Int32(Double.byteCount)) } // 'ICAR'
        version = value.withSlots { $0[double: 0] }

        //Versions must match!
        if version != ICARUS_VERSION {
            self.m_interface!.I_DPrintf!(WL_ERROR, "save game data contains outdated ICARUS version information!\n")
            return 0
        }

        //Load all signals
        if self.LoadSignals() == 0 {
            self.m_interface!.I_DPrintf!(WL_ERROR, "failed to load signals from save game!\n")
            return 0
        }

        //Load in all sequences
        if self.LoadSequences() == 0 {
            self.m_interface!.I_DPrintf!(WL_ERROR, "failed to load sequences from save game!\n")
            return 0
        }

        //Load in all sequencers
        if self.LoadSequencers() == 0 {
            self.m_interface!.I_DPrintf!(WL_ERROR, "failed to load sequencers from save game!\n")
            return 0
        }

        _ = value.withMutableSlots { self.m_interface!.I_ReadSaveData!(0x4945_4E44, $0, Int32(Double.byteCount)) } // 'IEND'

        return 1
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
