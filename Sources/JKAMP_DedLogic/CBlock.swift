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
        self.m_flags = 0
        self.m_id = 0
    }

    /**
    ```
    -------------------------
    Init
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:187
    @discardableResult
    func Init() -> Int32 {
        self.m_flags = 0
        self.m_id = 0

        return 1
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:201
    @discardableResult
    func Create(_ block_id: Int32) -> Int32 {
        self.Init()

        self.m_id = block_id

        return 1
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:216
    @discardableResult
    func Free() -> Int32 {
        var numMembers: Int32 = self.GetNumMembers()
        var bMember: CBlockMember?

        while numMembers != 0 {
            numMembers -= 1
            bMember = self.GetMember(numMembers)

            if bMember == nil {
                return 0
            }
        }

        self.m_members.removeAll()			//List of all CBlockMembers owned by this list

        return 1
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
    @discardableResult
    func Write(_ member_id: Int32, _ member_data: String) -> Int32 {
        let bMember = CBlockMember()

        bMember.SetID(member_id)

        bMember.SetData(member_data)
        bMember.SetSize(strlen(member_data) + 1)

        self.AddMember(bMember)

        return 1
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:258
    @discardableResult
    func Write(_ member_id: Int32, _ member_data: JKAShared.vec3_t) -> Int32 {
        let bMember: CBlockMember

        bMember = CBlockMember()

        bMember.SetID(member_id)
        bMember.SetData(member_data)
        bMember.SetSize(Int32(vec3_t.byteCount))

        self.AddMember(bMember)

        return 1
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:273
    @discardableResult
    func Write(_ member_id: Int32, _ member_data: Float) -> Int32 {
        var member_data = member_data
        let bMember = CBlockMember()

        bMember.SetID(member_id)
        bMember.WriteData(&member_data)
        bMember.SetSize(Int32(Float.byteCount))

        self.AddMember(bMember)

        return 1
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:286
    @discardableResult
    func Write(_ member_id: Int32, _ member_data: Int32) -> Int32 {
        var member_data = member_data
        let bMember = CBlockMember()

        bMember.SetID(member_id)
        bMember.WriteData(&member_data)
        bMember.SetSize(Int32(Int32.byteCount))

        self.AddMember(bMember)

        return 1
    }

    /// Source: oracle/codemp/icarus/BlockStream.cpp:300
    @discardableResult
    func Write(_ bMember: CBlockMember?) -> Int32 {
        // findme: this is wrong:	bMember->SetSize( sizeof(bMember->GetData()) );

        self.AddMember(bMember)

        return 1
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
    @discardableResult
    func AddMember(_ member: CBlockMember?) -> Int32 {
        self.m_members.append(member!)
        return 1
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
        if memberNum > self.GetNumMembers() - 1 {
            return nil
        }
        return self.m_members[memberNum]
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
        var newblock: CBlock?

        newblock = CBlock()

        if newblock == nil {
            return nil
        }

        newblock!.Create(self.m_id)

        //Duplicate entire block and return the cc
        for mi in self.m_members {
            newblock!.AddMember(mi.Duplicate())
        }

        return newblock
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
