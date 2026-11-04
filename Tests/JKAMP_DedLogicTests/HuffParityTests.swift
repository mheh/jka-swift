import JKATestSupport
import Testing
@testable import JKAMP_DedLogic

/// This suite checks the port of `huffman.cpp` against the three huff goldens of `jka-rust/tools/huff-oracle/main.cpp`.
/// The first test seeds `msgHuff` in a fresh world as `MSG_initHuffman` does, and the tests run one after the other on that tree.
/// `Huff_offsetTransmit` never calls `Huff_addRef`, so the tree stays as the seed left it.
/// The seed reaches the hole of `get_ppnode`, so the suite waits on the open row of the address of one element of a Slots as a slot.
@Suite(.serialized, .disabled("get_ppnode waits on the open row of the address of one element of a Slots as a slot"))
struct HuffParitySuite {
    /// The world that holds the seeded tree, so the 2.1 million `Huff_addRef` calls of the seed run once.
    nonisolated(unsafe) static var seededWorld: EngineWorld?

    @Test("the compressor gives every symbol the prefix code of codes.txt")
    func codesMatchTheGolden() throws {
        Self.seed()
        let golden = try Self.lines("huff/codes")
        #expect(golden.count == 256)

        for symbol in 0..<256 {
            var buf = [UInt8](repeating: 0, count: 64)
            var bloc: Int32 = 0
            buf.withUnsafeMutableBytes { raw in
                Huff_offsetTransmit(msgHuff.compressor, Int32(symbol), raw.baseAddress!, &bloc)
            }
            let bits = Self.bits(buf, count: Int(bloc))
            #expect(golden[symbol] == "\(Self.pad(symbol)): \(bits)  (\(bloc) bits)")
        }
    }

    @Test("the stream of the symbols 0 to 255 matches seq.txt")
    func seqMatchesTheGolden() throws {
        Self.seed()
        try Self.expectStream("huff/seq", name: "seq", symbols: (0..<256).map { UInt8($0) })
    }

    @Test("the stream of the chat string with the byte 0xB0 matches chat.txt")
    func chatMatchesTheGolden() throws {
        Self.seed()
        let chat: [UInt8] = [
            0x63, 0x68, 0x61, 0x74, 0x20, 0x22, 0x50, 0x5e, 0x37, 0x19,
            0x3a, 0x20, 0x79, 0x6f, 0x20, 0xb0, 0x2f, 0x2e, 0x73, 0x22,
        ]
        try Self.expectStream("huff/chat", name: "chat", symbols: chat)
    }
}

// MARK: - The seed and the streams

extension HuffParitySuite {
    /// This builds a fresh world and seeds `msgHuff` the way `MSG_initHuffman` does, msg.cpp:3219.
    /// If the seeded world is still the one global, the seed does not run again.
    private static func seed() {
        if let seeded = Self.seededWorld, seeded === world { return }
        world = EngineWorld()
        Self.seededWorld = world
        Huff_Init(msgHuff)
        for i in 0..<256 {
            for _ in 0..<msg_hData[i] {
                Huff_addRef(msgHuff.compressor, Int32(i))
                Huff_addRef(msgHuff.decompressor, Int32(i))
            }
        }
    }

    /// This sends the symbols through `Huff_offsetTransmit` from offset 0 and compares the header and the hex lines with the golden.
    private static func expectStream(_ golden: String, name: String, symbols: [UInt8]) throws {
        var buf = [UInt8](repeating: 0, count: 8192)
        var bloc: Int32 = 0
        buf.withUnsafeMutableBytes { raw in
            for symbol in symbols {
                Huff_offsetTransmit(msgHuff.compressor, Int32(symbol), raw.baseAddress!, &bloc)
            }
        }
        let bytes = (Int(bloc) + 7) >> 3
        let hex = buf.prefix(bytes).map { Self.hex($0) }.joined()
        var expected = ["\(name) bloc=\(bloc) bytes=\(bytes)"]
        var start = hex.startIndex
        while start < hex.endIndex {
            let end = hex.index(start, offsetBy: 64, limitedBy: hex.endIndex) ?? hex.endIndex
            expected.append(String(hex[start..<end]))
            start = end
        }
        #expect(try Self.lines(golden) == expected)
    }
}

// MARK: - Formatting

extension HuffParitySuite {
    private static func lines(_ name: String) throws -> [String] {
        let text = try OracleData.golden(name)
        return text.split(separator: "\n", omittingEmptySubsequences: false).dropLast().map(String.init)
    }

    /// This reads bits 0 to `count` of the buffer, the low bit of each byte first, the order `add_bit` writes them.
    private static func bits(_ buf: [UInt8], count: Int) -> String {
        String((0..<count).map { (buf[$0 >> 3] >> UInt8($0 & 7)) & 1 == 1 ? "1" : "0" })
    }

    /// This is the `%3d` of main.cpp.
    private static func pad(_ symbol: Int) -> String {
        let text = String(symbol)
        return String(repeating: " ", count: 3 - text.count) + text
    }

    /// This is the `%02x` of main.cpp.
    private static func hex(_ byte: UInt8) -> String {
        let text = String(byte, radix: 16)
        return text.count == 1 ? "0" + text : text
    }
}
