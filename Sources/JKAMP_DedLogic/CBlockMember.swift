import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's block member, one typed value of a block, which an IBI stream holds as an ID, a size, and the data.
/// Source: oracle/codemp/icarus/blockstream.h:38
// AI: Raven allocates the class with Z_Malloc in operator new, and the destructor only frees the data.
// ARC frees the class, so the two operators and the destructor drop.
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

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:44
    // Port-note: The body reads or writes `m_data`, which is `OpaquePointer?` and has no body form, so the body waits for that row.
    func Free() {
        // TODO: Port CBlockMember::Free
        portMissing("CBlockMember::Free", source: "oracle/codemp/icarus/BlockStream.cpp:44")
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
        // TODO: Port CBlockMember::GetInfo
        portMissing("CBlockMember::GetInfo", source: "oracle/codemp/icarus/BlockStream.cpp:61")
    }

    /**
    ```
    -------------------------
    SetData overloads
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:74
    // Port-note: The body reads or writes `m_data`, which is `OpaquePointer?` and has no body form, so the body waits for that row.
    func SetData(_ data: String) {
        // TODO: Port CBlockMember::SetData
        portMissing("CBlockMember::SetData", source: "oracle/codemp/icarus/BlockStream.cpp:74")
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:79
    // Port-note: The body reads or writes `m_data`, which is `OpaquePointer?` and has no body form, so the body waits for that row.
    func SetData(_ data: JKAShared.vec3_t) {
        // TODO: Port CBlockMember::SetData
        portMissing("CBlockMember::SetData", source: "oracle/codemp/icarus/BlockStream.cpp:79")
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:84
    func SetData(_ data: Slots<JKAShared.byte>?, _ size: Int32) {
        // TODO: Port CBlockMember::SetData
        portMissing("CBlockMember::SetData", source: "oracle/codemp/icarus/BlockStream.cpp:84")
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
    // Port-note: The body reads or writes `m_data`, which is `OpaquePointer?` and has no body form, so the body waits for that row.
    func ReadMember(_ stream: CharBuf, _ streamPos: inout Int32) -> Int32 {
        // TODO: Port CBlockMember::ReadMember
        portMissing("CBlockMember::ReadMember", source: "oracle/codemp/icarus/BlockStream.cpp:102")
    }

    /**
    ```
    -------------------------
    WriteMember
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:133
    // TODO: Port signature
    // Raven wrote: int CBlockMember::WriteMember( FILE *m_fileHandle )
    // No table row for `FILE *`.
    func WriteMember() -> Never {
        // TODO: Port CBlockMember::WriteMember
        portMissing("CBlockMember::WriteMember", source: "oracle/codemp/icarus/BlockStream.cpp:133")
    }

    /**
    ```
    -------------------------
    Duplicate
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:148
    // Port-note: The body reads or writes `m_data`, which is `OpaquePointer?` and has no body form, so the body waits for that row.
    func Duplicate() -> CBlockMember? {
        // TODO: Port CBlockMember::Duplicate
        portMissing("CBlockMember::Duplicate", source: "oracle/codemp/icarus/BlockStream.cpp:148")
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
        // TODO: Port CBlockMember::WriteData
        portMissing("CBlockMember::WriteData", source: "oracle/codemp/icarus/blockstream.h:76")
    }

    /// Source: oracle/codemp/icarus/blockstream.h:76
    func WriteData(_ data: inout Int32) {
        // TODO: Port CBlockMember::WriteData
        portMissing("CBlockMember::WriteData", source: "oracle/codemp/icarus/blockstream.h:76")
    }

    /// Source: oracle/codemp/icarus/blockstream.h:88
    // AI: Raven defines a template. The class has one overload for each type Raven's calls take, the text and the vector of SetData at BlockStream.cpp:76 and :81.
    func WriteDataPointer(_ data: String, _ num: Int32) {
        // TODO: Port CBlockMember::WriteDataPointer
        portMissing("CBlockMember::WriteDataPointer", source: "oracle/codemp/icarus/blockstream.h:88")
    }

    /// Source: oracle/codemp/icarus/blockstream.h:88
    func WriteDataPointer(_ data: JKAShared.vec3_t, _ num: Int32) {
        // TODO: Port CBlockMember::WriteDataPointer
        portMissing("CBlockMember::WriteDataPointer", source: "oracle/codemp/icarus/blockstream.h:88")
    }
}
