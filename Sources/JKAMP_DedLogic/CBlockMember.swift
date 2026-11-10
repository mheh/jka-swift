import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's block member, one typed value of a block, which an IBI stream holds as an ID, a size, and the data.
/// Source: oracle/codemp/icarus/blockstream.h:38
// AI: Raven allocates the class with Z_Malloc in operator new. ARC frees the class, so the two operators drop.
final class CBlockMember {
    private var m_id: Int32 = 0		//ID of the value contained in data
    private var m_size: Int32 = 0		//Size of the data member variable
    // AI: Raven holds the ICARUS_Malloc block of the data as `void *`, a text, a float, an int, or a vector by `m_id`.
    // The field is the Slots over the bytes of the block, the form of `pModelDiskImage` of CachedEndianedModelBinary_t, so a body reads `m_data![float: 0]`.
    private var m_data: Slots<JKAShared.byte>? = nil	//Data for this member

    /**
    ```
    ===================================================================================================

      CBlockMember

    ===================================================================================================
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:26
    init() {
        self.m_id = -1
        self.m_size = -1
        self.m_data = nil
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:33
    deinit {
        self.Free()
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:44
    func Free() {
        if self.m_data != nil {
            // AI: Raven frees the `void *` block. The call frees the base of the Slots, the form of the download blocks of SV_CloseDownload.
            ICARUS_Free(OpaquePointer(self.m_data!.base))
            self.m_data = nil

            self.m_size = -1
            self.m_id = self.m_size
        }
    }

    /**
    ```
    -------------------------
    GetInfo
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:61
    func GetInfo(_ id: inout Int32, _ size: inout Int32, _ data: inout Slots<JKAShared.byte>?) {
        id = self.m_id
        size = self.m_size
        data = self.m_data
    }

    /**
    ```
    -------------------------
    SetData overloads
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:74
    func SetData(_ data: String) {
        self.WriteDataPointer(data, strlen(data) + 1)
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:79
    func SetData(_ data: JKAShared.vec3_t) {
        self.WriteDataPointer(data, 3)
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:84
    func SetData(_ data: Slots<JKAShared.byte>?, _ size: Int32) {
        if self.m_data != nil {
            // AI: Raven frees the `void *` block. The call frees the base of the Slots, the form of the download blocks of SV_CloseDownload.
            ICARUS_Free(OpaquePointer(self.m_data!.base))
        }

        // AI: Raven holds the ICARUS_Malloc block as `void *`. The field is the Slots over its bytes, the form of the fake GLA file of RE_RegisterModels_GetDiskFile.
        self.m_data = Slots<JKAShared.byte>(scalars: ICARUS_Malloc(size), count: Int(size))
        // AI: Raven calls memcpy on the two pointers. Com_Memcpy over the two Slots copies the same bytes.
        Com_Memcpy(self.m_data!, data!, size)
        self.m_size = size
    }

    //	Member I/O functions
    /**
    ```
    -------------------------
    ReadMember
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:102
    @discardableResult
    func ReadMember(_ stream: CharBuf, _ streamPos: inout Int32) -> Int32 {
        self.m_id = stream.withSlots { $0[int: streamPos] }
        streamPos += Int32(Int32.byteCount)

        if self.m_id == ID_RANDOM {//special case, need to initialize this member's data to Q3_INFINITE so we can randomize the number only the first time random is checked when inside a wait
            self.m_size = Int32(Float.byteCount)
            // AI: Raven steps over a `long`, 4 bytes on WinDed.
            streamPos += Int32(Int32.byteCount)
            // AI: Raven holds the ICARUS_Malloc block as `void *`. The field is the Slots over its bytes, the form of the fake GLA file of RE_RegisterModels_GetDiskFile.
            self.m_data = Slots<JKAShared.byte>(scalars: ICARUS_Malloc(self.m_size), count: Int(self.m_size))
            let infinite = Float(Q3_INFINITE)
            // AI: Raven copies the float through its address. The body stores the float at byte 0 of the block.
            self.m_data![float: 0] = infinite
        } else {
            // AI: Raven reads a `long`, 4 bytes on WinDed.
            self.m_size = stream.withSlots { $0[int: streamPos] }
            streamPos += Int32(Int32.byteCount)
            // AI: Raven holds the ICARUS_Malloc block as `void *`. The field is the Slots over its bytes, the form of the fake GLA file of RE_RegisterModels_GetDiskFile.
            self.m_data = Slots<JKAShared.byte>(scalars: ICARUS_Malloc(self.m_size), count: Int(self.m_size))
            // AI: Raven calls memcpy on the two pointers. Com_Memcpy over the two Slots copies the same bytes.
            stream.withSlots { Com_Memcpy(self.m_data!, $0.suffix(from: streamPos), self.m_size) }
        }
        streamPos += self.m_size

        return 1
    }

    /**
    ```
    -------------------------
    WriteMember
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:133
    // Port-note: Rule 20. The one caller is CBlockStream::WriteBlock, whose callers are in Interpreter.cpp, and WinDed does not link Interpreter.cpp.
    @discardableResult
    func WriteMember(_ m_fileHandle: OpaquePointer?) -> Int32 {
        // AI: Raven writes each value through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        var value = CharBuf(Int32.byteCount)

        value.withMutableSlots { $0[int: 0] = self.m_id }
        _ = FileBackend.fwrite(value, at: 0, Int32(Int32.byteCount), 1, m_fileHandle)
        value.withMutableSlots { $0[int: 0] = self.m_size }
        _ = FileBackend.fwrite(value, at: 0, Int32(Int32.byteCount), 1, m_fileHandle)
        _ = FileBackend.fwrite(self.m_data!, at: 0, self.m_size, 1, m_fileHandle)

        return 1
    }

    /**
    ```
    -------------------------
    Duplicate
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:148
    func Duplicate() -> CBlockMember? {
        let newblock: CBlockMember? = CBlockMember()

        if newblock == nil {
            return nil
        }

        newblock!.SetData(self.m_data, self.m_size)
        newblock!.SetSize(self.m_size)
        newblock!.SetID(self.m_id)

        return newblock
    }

    //Set the ID member variable
    /// Source: oracle/codemp/icarus/blockstream.h:50
    func SetID(_ id: Int32) {
        self.m_id = id
    }

    //Set the size member variable
    /// Source: oracle/codemp/icarus/blockstream.h:51
    func SetSize(_ size: Int32) {
        self.m_size = size
    }

    //Get ID member variables
    /// Source: oracle/codemp/icarus/blockstream.h:60
    func GetID() -> Int32 {
        self.m_id
    }

    //Get data member variable
    /// Source: oracle/codemp/icarus/blockstream.h:61
    func GetData() -> Slots<JKAShared.byte>? {
        self.m_data
    }

    //Get size member variable
    /// Source: oracle/codemp/icarus/blockstream.h:62
    func GetSize() -> Int32 {
        self.m_size
    }

    /// Source: oracle/codemp/icarus/blockstream.h:76
    // AI: Raven defines a template. The class has one overload for each type Raven's calls take, `float` and `int` of CBlock::Write at BlockStream.cpp:278 and :291.
    func WriteData(_ data: inout Float) {
        if self.m_data != nil {
            // AI: Raven frees the `void *` block. The call frees the base of the Slots, the form of the download blocks of SV_CloseDownload.
            ICARUS_Free(OpaquePointer(self.m_data!.base))
        }

        // AI: Raven holds the ICARUS_Malloc block as `void *`. The field is the Slots over its bytes, the form of the fake GLA file of RE_RegisterModels_GetDiskFile.
        self.m_data = Slots<JKAShared.byte>(scalars: ICARUS_Malloc(Int32(Float.byteCount)), count: Float.byteCount)
        // AI: Raven stores through the cast of the block to `T *`. The body stores the value at byte 0 of the block.
        self.m_data![float: 0] = data
        self.m_size = Int32(Float.byteCount)
    }

    /// Source: oracle/codemp/icarus/blockstream.h:76
    func WriteData(_ data: inout Int32) {
        if self.m_data != nil {
            // AI: Raven frees the `void *` block. The call frees the base of the Slots, the form of the download blocks of SV_CloseDownload.
            ICARUS_Free(OpaquePointer(self.m_data!.base))
        }

        // AI: Raven holds the ICARUS_Malloc block as `void *`. The field is the Slots over its bytes, the form of the fake GLA file of RE_RegisterModels_GetDiskFile.
        self.m_data = Slots<JKAShared.byte>(scalars: ICARUS_Malloc(Int32(Int32.byteCount)), count: Int32.byteCount)
        // AI: Raven stores through the cast of the block to `T *`. The body stores the value at byte 0 of the block.
        self.m_data![int: 0] = data
        self.m_size = Int32(Int32.byteCount)
    }

    /// Source: oracle/codemp/icarus/blockstream.h:88
    // AI: Raven defines a template. The class has one overload for each type Raven's calls take, the text and the vector of SetData at BlockStream.cpp:76 and :81.
    func WriteDataPointer(_ data: String, _ num: Int32) {
        if self.m_data != nil {
            // AI: Raven frees the `void *` block. The call frees the base of the Slots, the form of the download blocks of SV_CloseDownload.
            ICARUS_Free(OpaquePointer(self.m_data!.base))
        }

        // AI: Raven holds the ICARUS_Malloc block as `void *`. The field is the Slots over its bytes, the form of the fake GLA file of RE_RegisterModels_GetDiskFile.
        self.m_data = Slots<JKAShared.byte>(scalars: ICARUS_Malloc(num * Int32(CChar.byteCount)), count: Int(num * Int32(CChar.byteCount)))
        // AI: Raven copies the text through its pointer. Com_Memcpy copies the same bytes from a CharBuf of the text.
        Com_Memcpy(self.m_data!, CharBuf(data), num * Int32(CChar.byteCount))
        self.m_size = num * Int32(CChar.byteCount)
    }

    /// Source: oracle/codemp/icarus/blockstream.h:88
    func WriteDataPointer(_ data: JKAShared.vec3_t, _ num: Int32) {
        if self.m_data != nil {
            // AI: Raven frees the `void *` block. The call frees the base of the Slots, the form of the download blocks of SV_CloseDownload.
            ICARUS_Free(OpaquePointer(self.m_data!.base))
        }

        // AI: Raven holds the ICARUS_Malloc block as `void *`. The field is the Slots over its bytes, the form of the fake GLA file of RE_RegisterModels_GetDiskFile.
        self.m_data = Slots<JKAShared.byte>(scalars: ICARUS_Malloc(num * Int32(Float.byteCount)), count: Int(num * Int32(Float.byteCount)))
        // AI: Raven copies `num` floats from the vector with memcpy. The body stores each float at its byte offset of the block.
        var i: Int32 = 0
        while i < num {
            self.m_data![float: i * Int32(Float.byteCount)] = data[i]
            i += 1
        }
        self.m_size = num * Int32(Float.byteCount)
    }
}
