import JKATestSupport
import Testing

/// This suite checks the shape of the three huff goldens under `Oracle/golden/huff`.
/// The dumper is `jka-rust/tools/huff-oracle/main.cpp`.
/// The parity test comes with the port of `huffman.cpp`.
@Suite("The huff goldens keep the shape main.cpp writes")
struct HuffGoldenFormatTests {
    /// One parsed `seq.txt` or `chat.txt`: the header fields and the hex lines.
    struct Stream {
        var name: String
        var bloc: Int
        var bytes: Int
        var hexLines: [String]
    }

    @Test("codes.txt has 256 lines, one per symbol, in the order 0 to 255")
    func codesShape() throws {
        let lines = try Self.lines("huff/codes")
        #expect(lines.count == 256)
        for (symbol, line) in lines.enumerated() {
            let parts = try #require(Self.codeFields(line), "line \(symbol + 1) is malformed")
            #expect(parts.symbol == symbol)
            #expect(parts.bits.allSatisfy { $0 == "0" || $0 == "1" })
            #expect(parts.bits.count == parts.count)
            #expect(parts.count > 0)
        }
    }

    @Test("codes.txt gives every symbol a code that is no prefix of another")
    func codesArePrefixFree() throws {
        let codes = try Self.codes()
        let sorted = codes.sorted()
        for index in 1..<sorted.count {
            #expect(sorted[index].hasPrefix(sorted[index - 1]) == false)
        }
    }

    @Test("seq.txt holds the stream of the symbols 0 to 255")
    func seqShape() throws {
        let stream = try Self.stream("huff/seq")
        let codes = try Self.codes()
        #expect(stream.name == "seq")
        #expect(stream.bloc == codes.reduce(0) { $0 + $1.count })
        try Self.expectStreamShape(stream)
    }

    @Test("chat.txt holds the stream of the 20 byte chat string")
    func chatShape() throws {
        let stream = try Self.stream("huff/chat")
        let codes = try Self.codes()
        let chat: [UInt8] = [
            0x63, 0x68, 0x61, 0x74, 0x20, 0x22, 0x50, 0x5e, 0x37, 0x19,
            0x3a, 0x20, 0x79, 0x6f, 0x20, 0xb0, 0x2f, 0x2e, 0x73, 0x22,
        ]
        #expect(stream.name == "chat")
        #expect(stream.bloc == chat.reduce(0) { $0 + codes[Int($1)].count })
        try Self.expectStreamShape(stream)
    }
}

// MARK: - Parsing

extension HuffGoldenFormatTests {
    private static func lines(_ name: String) throws -> [String] {
        let text = try OracleData.golden(name)
        #expect(text.hasSuffix("\n"))
        return text.split(separator: "\n", omittingEmptySubsequences: false).dropLast().map(String.init)
    }

    /// This parses `"%3d: <bits>  (<n> bits)"`.
    private static func codeFields(_ line: String) -> (symbol: Int, bits: String, count: Int)? {
        let halves = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        guard halves.count == 2 else { return nil }
        let fields = halves[1].split(separator: " ")
        guard fields.count == 3, fields[2] == "bits)", fields[1].hasPrefix("("),
              let symbol = Int(halves[0].trimmingCharacters(in: .whitespaces)),
              let count = Int(fields[1].dropFirst())
        else { return nil }
        return (symbol, String(fields[0]), count)
    }

    private static func codes() throws -> [String] {
        try self.lines("huff/codes").map { line in
            let parts = try #require(Self.codeFields(line))
            return parts.bits
        }
    }

    /// This parses `"<name> bloc=<n> bytes=<n>"` and the hex lines under it.
    private static func stream(_ name: String) throws -> Stream {
        let lines = try Self.lines(name)
        let head = try #require(lines.first).split(separator: " ")
        try #require(head.count == 3)
        try #require(head[1].hasPrefix("bloc="))
        try #require(head[2].hasPrefix("bytes="))
        let bloc = try #require(Int(head[1].dropFirst(5)))
        let bytes = try #require(Int(head[2].dropFirst(6)))
        return Stream(name: String(head[0]), bloc: bloc, bytes: bytes, hexLines: Array(lines.dropFirst()))
    }

    private static func expectStreamShape(_ stream: Stream) throws {
        #expect(stream.bytes == (stream.bloc + 7) >> 3)

        // main.cpp writes 32 bytes per line, so 64 hex digits, and a shorter last line.
        let fullLines = stream.bytes / 32
        let rest = stream.bytes % 32
        #expect(stream.hexLines.count == fullLines + (rest == 0 ? 0 : 1))
        for (index, line) in stream.hexLines.enumerated() {
            let expected = index < fullLines ? 64 : rest * 2
            #expect(line.count == expected)
            #expect(line.allSatisfy { $0.isHexDigit && ($0.isNumber || $0.isLowercase) })
        }

        // The buffer starts zeroed, so the unused bits of the last byte are zero.
        let last = try #require(stream.hexLines.last?.suffix(2))
        let lastByte = try #require(UInt8(last, radix: 16))
        let used = stream.bloc & 7
        if used != 0 {
            #expect(lastByte >> UInt8(used) == 0)
        }
    }
}
