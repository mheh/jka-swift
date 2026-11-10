import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's block, one ICARUS command with an ID, flags, and its list of members.
/// Source: oracle/codemp/icarus/blockstream.h:109
// AI: Raven's destructor only deletes the members. ARC frees the class and its members, so the destructor drops.
final class CBlock {
    // AI: Raven types the member list as a std::vector of pointers. The list is an Array of the class, by rule 17.
    typealias blockMember_v = [CBlockMember]

    private var m_members: blockMember_v = []			//List of all CBlockMembers owned by this list
    private var m_id: Int32 = 0				//ID of the block
    private var m_flags: Int32 = 0

    /**
    ```
    ===================================================================================================

      CBlock

    ===================================================================================================
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:170
    init() {
        // TODO: Port CBlock::CBlock
        portMissing("CBlock::CBlock", source: "oracle/codemp/icarus/BlockStream.cpp:170")
    }

    /**
    ```
    -------------------------
    Init
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:187
    func Init() -> Int32 {
        // TODO: Port CBlock::Init
        portMissing("CBlock::Init", source: "oracle/codemp/icarus/BlockStream.cpp:187")
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:201
    func Create(_ block_id: Int32) -> Int32 {
        // TODO: Port CBlock::Create
        portMissing("CBlock::Create", source: "oracle/codemp/icarus/BlockStream.cpp:201")
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:216
    func Free() -> Int32 {
        // TODO: Port CBlock::Free
        portMissing("CBlock::Free", source: "oracle/codemp/icarus/BlockStream.cpp:216")
    }

    //	Write overloads
    /**
    ```
    -------------------------
    Write
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:244
    func Write(_ member_id: Int32, _ member_data: String) -> Int32 {
        // TODO: Port CBlock::Write
        portMissing("CBlock::Write", source: "oracle/codemp/icarus/BlockStream.cpp:244")
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:258
    func Write(_ member_id: Int32, _ member_data: JKAShared.vec3_t) -> Int32 {
        // TODO: Port CBlock::Write
        portMissing("CBlock::Write", source: "oracle/codemp/icarus/BlockStream.cpp:258")
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:273
    func Write(_ member_id: Int32, _ member_data: Float) -> Int32 {
        // TODO: Port CBlock::Write
        portMissing("CBlock::Write", source: "oracle/codemp/icarus/BlockStream.cpp:273")
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:286
    func Write(_ member_id: Int32, _ member_data: Int32) -> Int32 {
        // TODO: Port CBlock::Write
        portMissing("CBlock::Write", source: "oracle/codemp/icarus/BlockStream.cpp:286")
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:300
    func Write(_ bMember: CBlockMember?) -> Int32 {
        // TODO: Port CBlock::Write
        portMissing("CBlock::Write", source: "oracle/codemp/icarus/BlockStream.cpp:300")
    }

    // Member list functions
    /**
    ```
    -------------------------
    AddMember
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:317
    func AddMember(_ member: CBlockMember?) -> Int32 {
        // TODO: Port CBlock::AddMember
        portMissing("CBlock::AddMember", source: "oracle/codemp/icarus/BlockStream.cpp:317")
    }

    /**
    ```
    -------------------------
    GetMember
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:329
    func GetMember(_ memberNum: Int32) -> CBlockMember? {
        // TODO: Port CBlock::GetMember
        portMissing("CBlock::GetMember", source: "oracle/codemp/icarus/BlockStream.cpp:329")
    }

    /**
    ```
    -------------------------
    GetMemberData
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:344
    func GetMemberData(_ memberNum: Int32) -> Slots<JKAShared.byte>? {
        // TODO: Port CBlock::GetMemberData
        portMissing("CBlock::GetMemberData", source: "oracle/codemp/icarus/BlockStream.cpp:344")
    }

    /**
    ```
    -------------------------
    Duplicate
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:359
    func Duplicate() -> CBlock? {
        // TODO: Port CBlock::Duplicate
        portMissing("CBlock::Duplicate", source: "oracle/codemp/icarus/BlockStream.cpp:359")
    }

    //Get the ID for the block
    /// Source: oracle/codemp/icarus/blockstream.h:140
    func GetBlockID() -> Int32 {
        self.m_id
    }

    //Get the number of member in the block's list
    /// Source: oracle/codemp/icarus/blockstream.h:141
    func GetNumMembers() -> Int32 {
        Int32(self.m_members.count)
    }

    /// Source: oracle/codemp/icarus/blockstream.h:143
    func SetFlags(_ flags: Int32) {
        self.m_flags = flags
    }

    /// Source: oracle/codemp/icarus/blockstream.h:144
    func SetFlag(_ flag: Int32) {
        self.m_flags |= flag
    }

    /// Source: oracle/codemp/icarus/blockstream.h:146
    func HasFlag(_ flag: Int32) -> Int32 {
        self.m_flags & flag
    }

    /// Source: oracle/codemp/icarus/blockstream.h:147
    func GetFlags() -> Int32 {
        self.m_flags
    }
}
