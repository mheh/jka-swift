import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/icarus/blockstream.h:22
let MAX_FILENAME_LENGTH: Int32 = 1024

/// Raven's reader of a compiled IBI script, which reads the blocks of the script from its buffer.
/// Source: oracle/codemp/icarus/blockstream.h:158
// AI: Raven's destructor has an empty body. ARC frees the class, so the destructor drops.
final class CBlockStream {
    private var m_fileSize: Int32 = 0							//Size of the file
    // TODO: Port m_fileHandle
    // Raven wrote: FILE	*m_fileHandle;						//Global file handle of current I/O source
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
        // TODO: Port CBlockStream::CBlockStream
        portMissing("CBlockStream::CBlockStream", source: "oracle/codemp/icarus/BlockStream.cpp:388")
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
        // TODO: Port CBlockStream::GetChar
        portMissing("CBlockStream::GetChar", source: "oracle/codemp/icarus/BlockStream.cpp:404")
    }

    /**
    ```
    -------------------------
    GetUnsignedInteger
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:420
    private func GetUnsignedInteger() -> UInt32 {
        // TODO: Port CBlockStream::GetUnsignedInteger
        portMissing("CBlockStream::GetUnsignedInteger", source: "oracle/codemp/icarus/BlockStream.cpp:420")
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
        // TODO: Port CBlockStream::GetInteger
        portMissing("CBlockStream::GetInteger", source: "oracle/codemp/icarus/BlockStream.cpp:436")
    }

    /**
    ```
    -------------------------
    GetLong
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:452
    private func GetLong() -> Int32 {
        // TODO: Port CBlockStream::GetLong
        portMissing("CBlockStream::GetLong", source: "oracle/codemp/icarus/BlockStream.cpp:452")
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
        // TODO: Port CBlockStream::GetFloat
        portMissing("CBlockStream::GetFloat", source: "oracle/codemp/icarus/BlockStream.cpp:468")
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
        // TODO: Port CBlockStream::StripExtension
        portMissing("CBlockStream::StripExtension", source: "oracle/codemp/icarus/BlockStream.cpp:486")
    }

    /**
    ```
    -------------------------
    Free
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:508
    func Free() -> Int32 {
        // TODO: Port CBlockStream::Free
        portMissing("CBlockStream::Free", source: "oracle/codemp/icarus/BlockStream.cpp:508")
    }

    /**
    ```
    -------------------------
    Create
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:525
    func Create(_ filename: String) -> Int32 {
        // TODO: Port CBlockStream::Create
        portMissing("CBlockStream::Create", source: "oracle/codemp/icarus/BlockStream.cpp:525")
    }

    /**
    ```
    -------------------------
    Init
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:558
    func Init() -> Int32 {
        // TODO: Port CBlockStream::Init
        portMissing("CBlockStream::Init", source: "oracle/codemp/icarus/BlockStream.cpp:558")
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
    func WriteBlock(_ block: CBlock?) -> Int32 {
        // TODO: Port CBlockStream::WriteBlock
        portMissing("CBlockStream::WriteBlock", source: "oracle/codemp/icarus/BlockStream.cpp:577")
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
        // TODO: Port CBlockStream::BlockAvailable
        portMissing("CBlockStream::BlockAvailable", source: "oracle/codemp/icarus/BlockStream.cpp:605")
    }

    /**
    ```
    -------------------------
    ReadBlock
    -------------------------
    ```
    */
    /// Source: oracle/codemp/icarus/BlockStream.cpp:619
    func ReadBlock(_ get: CBlock?) -> Int32 {
        // TODO: Port CBlockStream::ReadBlock
        portMissing("CBlockStream::ReadBlock", source: "oracle/codemp/icarus/BlockStream.cpp:619")
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
        // TODO: Port CBlockStream::Open
        portMissing("CBlockStream::Open", source: "oracle/codemp/icarus/BlockStream.cpp:665")
    }
}
