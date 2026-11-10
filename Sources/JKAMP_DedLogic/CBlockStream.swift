import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/icarus/blockstream.h:21
let IBI_VERSION: Float = 1.57

/// Source: oracle/codemp/icarus/blockstream.h:22
let MAX_FILENAME_LENGTH: Int32 = 1024

/// Raven's reader of a compiled IBI script, which reads the blocks of the script from its buffer.
/// Source: oracle/codemp/icarus/blockstream.h:158
// AI: Raven's destructor has an empty body. ARC frees the class, so the destructor drops.
final class CBlockStream {
    private var m_fileSize: Int32 = 0							//Size of the file
    // AI: Raven holds a `FILE *`. The field is the OpaquePointer? of FileBackend, the form of `fin` of unzip.swift.
    private var m_fileHandle: OpaquePointer? = nil						//Global file handle of current I/O source
    private var m_fileName = CharBuf(MAX_FILENAME_LENGTH)	//Name of the current file

    // AI: Raven points m_stream into the buffer of the caller. The field holds the buffer as a CharBuf, and an empty one is Raven's NULL.
    private var m_stream = CharBuf(0)							//Stream of data to be parsed
    private var m_streamPos: Int32 = 0

    /**
    ```
    ===================================================================================================

      CBlockStream

    ===================================================================================================
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:388
    init() {
        self.m_stream = CharBuf(0)
        self.m_streamPos = 0
    }

    /**
    ```
    -------------------------
    GetChar
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:404
    private func GetChar() -> CChar {
        var data: CChar

        data = self.m_stream[self.m_streamPos]
        self.m_streamPos += Int32(CChar.byteCount)

        return data
    }

    /**
    ```
    -------------------------
    GetUnsignedInteger
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:420
    // Port-note: Rule 20. No file of oracle/codemp calls this function.
    private func GetUnsignedInteger() -> UInt32 {
        var data: UInt32

        // C converts the word bits to `unsigned`.
        data = UInt32(bitPattern: self.m_stream.withSlots { $0[int: self.m_streamPos] })
        self.m_streamPos += Int32(UInt32.byteCount)

        return data
    }

    /**
    ```
    -------------------------
    GetInteger
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:436
    private func GetInteger() -> Int32 {
        var data: Int32

        data = self.m_stream.withSlots { $0[int: self.m_streamPos] }
        self.m_streamPos += Int32(Int32.byteCount)

        return data
    }

    /**
    ```
    -------------------------
    GetLong
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:452
    // Port-note: Rule 20. No file of oracle/codemp calls this function.
    private func GetLong() -> Int32 {
        var data: Int32

        data = self.m_stream.withSlots { $0[int: self.m_streamPos] }
        self.m_streamPos += Int32(Int32.byteCount)

        return data
    }

    /**
    ```
    -------------------------
    GetFloat
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:468
    private func GetFloat() -> Float {
        var data: Float

        data = self.m_stream.withSlots { $0[float: self.m_streamPos] }
        self.m_streamPos += Int32(Float.byteCount)

        return data
    }

    //	Extension stripping utility
    /**
    ```
    -------------------------
    StripExtension
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:486
    private func StripExtension(_ `in`: String, _ out: inout CharBuf) {
        let `in` = CharBuf(`in`)
        var i: Int32 = strlen(`in`)

        // Port-note: Raven tests the byte before the string at -1 before he tests the index, and the loop ends at -1 for any byte.
        // The port tests the index first, so the loop ends at -1 with no read outside the string.
        while (i >= 0) && (`in`[i] != Int32(ascii: ".")) {
            i -= 1
        }

        if i < 0 {
            strcpy(&out, `in`)
            return
        }

        strncpy(&out, `in`, i)
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:508
    @discardableResult
    func Free() -> Int32 {
        //NOTENOTE: It is assumed that the user will free the passed memory block (m_stream) immediately after the run call
        //			That's why this doesn't free the memory, it only clears its internal pointer

        self.m_stream = CharBuf(0)
        self.m_streamPos = 0

        return 1
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:525
    // Port-note: Rule 20. No file of either tree calls CBlockStream::Create.
    @discardableResult
    func Create(_ filename: String) -> Int32 {
        var newName = CharBuf(MAX_FILENAME_LENGTH)
        let id_header = CharBuf(IBI_HEADER_ID)
        // AI: Raven writes the float through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        var version = CharBuf(Float.byteCount)
        version.withMutableSlots { $0[float: 0] = IBI_VERSION }

        //Clear the temp string
        newName.zero()

        //Strip the extension and add the BLOCK_EXT extension
        strcpy(&self.m_fileName, filename)
        self.StripExtension(String(self.m_fileName), &newName)
        strcat(&newName, IBI_EXT)

        //Recover that as the active filename
        strcpy(&self.m_fileName, newName)

        self.m_fileHandle = FileBackend.fopen(String(self.m_fileName), "wb")
        if self.m_fileHandle == nil {
            return 0
        }

        // Raven's `sizeof(id_header)` is the size of a pointer in his 32-bit build, 4, the length of the header text with its terminator.
        _ = FileBackend.fwrite(id_header, at: 0, 1, strlen(IBI_HEADER_ID) + 1, self.m_fileHandle)
        _ = FileBackend.fwrite(version, at: 0, 1, Int32(Float.byteCount), self.m_fileHandle)

        return 1
    }

    /**
    ```
    -------------------------
    Init
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:558
    @discardableResult
    func Init() -> Int32 {
        self.m_fileHandle = nil
        self.m_fileName.zero()

        self.m_stream = CharBuf(0)
        self.m_streamPos = 0

        return 1
    }

    //	Block I/O functions
    /**
    ```
    -------------------------
    WriteBlock
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:577
    // Port-note: Rule 20. The callers of this function are in Interpreter.cpp, and WinDed does not link Interpreter.cpp.
    @discardableResult
    func WriteBlock(_ block: CBlock?) -> Int32 {
        var bMember: CBlockMember?
        let id: Int32 = block!.GetBlockID()
        let numMembers: Int32 = block!.GetNumMembers()
        // C converts the `int` flags to `unsigned char` by its low bits.
        let flags = UInt8(truncatingIfNeeded: block!.GetFlags())
        // AI: Raven writes each value through its address. The value goes into a CharBuf of its bytes, and the CharBuf is written.
        var value = CharBuf(Int32.byteCount)

        value.withMutableSlots { $0[int: 0] = id }
        _ = FileBackend.fwrite(value, at: 0, Int32(Int32.byteCount), 1, self.m_fileHandle)
        value.withMutableSlots { $0[int: 0] = numMembers }
        _ = FileBackend.fwrite(value, at: 0, Int32(Int32.byteCount), 1, self.m_fileHandle)
        value.withMutableSlots { $0[byte: 0] = flags }
        _ = FileBackend.fwrite(value, at: 0, Int32(UInt8.byteCount), 1, self.m_fileHandle)

        var i: Int32 = 0
        while i < numMembers {
            bMember = block!.GetMember(i)
            bMember!.WriteMember(self.m_fileHandle)
            i += 1
        }

        block!.Free()

        return 1
    }

    /**
    ```
    -------------------------
    BlockAvailable
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:605
    func BlockAvailable() -> Int32 {
        if self.m_streamPos >= self.m_fileSize {
            return 0
        }

        return 1
    }

    /**
    ```
    -------------------------
    ReadBlock
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:619
    @discardableResult
    func ReadBlock(_ get: CBlock?) -> Int32 {
        var bMember: CBlockMember
        var b_id: Int32
        var numMembers: Int32
        var flags: UInt8

        if self.BlockAvailable() == 0 {
            return 0
        }

        b_id = self.GetInteger()
        numMembers = self.GetInteger()
        flags = UInt8(truncatingIfNeeded: self.GetChar())

        if numMembers < 0 {
            return 0
        }

        get!.Create(b_id)
        get!.SetFlags(Int32(flags))

        // Stream blocks are generally temporary as they
        // are just used in an initial parsing phase...

        while numMembers > 0 {
            numMembers -= 1
            bMember = CBlockMember()
            bMember.ReadMember(self.m_stream, &self.m_streamPos)
            get!.AddMember(bMember)
        }

        return 1
    }

    /**
    ```
    -------------------------
    Open
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:665
    func Open(_ buffer: CharBuf, _ size: Int32) -> Int32 {
        var id_header = CharBuf(strlen(IBI_HEADER_ID) + 1)
        var version: Float

        self.Init()

        self.m_fileSize = size

        self.m_stream = buffer

        var i: Int32 = 0
        while i < id_header.count {
            id_header[i] = self.GetChar()
            i += 1
        }

        version = self.GetFloat()

        //Check for valid header
        if strcmp(id_header, IBI_HEADER_ID) != 0 {
            self.Free()
            return 0
        }

        //Check for valid version
        if version != IBI_VERSION {
            self.Free()
            return 0
        }

        return 1
    }
}
