import Foundation
import Testing

/// This suite reads `vmtest.qvm` and checks its header against the README beside it.
/// The fixture is under test before the interpreter port exists.
struct QVMFixtureSuite {
    // MARK: - State

    static let directory = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("JKATestSupport")
        .appendingPathComponent("Fixtures")
        .appendingPathComponent("qvm")

    @Test("the header of vmtest.qvm matches the README")
    func headerMatchesTheReadme() throws {
        let image = try Data(contentsOf: Self.directory.appendingPathComponent("vmtest.qvm"))
        let readme = try String(contentsOf: Self.directory.appendingPathComponent("README.md"), encoding: .utf8)

        let names = ["vmMagic", "instructionCount", "codeOffset", "codeLength", "dataOffset", "dataLength", "litLength", "bssLength"]
        var fields: [String: Int] = [:]
        for (index, name) in names.enumerated() {
            fields[name] = Self.word(image, at: 4 * index)
        }

        // The README table holds one row per field.
        for name in names {
            let row = try #require(readme.split(separator: "\n").first { $0.hasPrefix("| `\(name)` |") })
            let cell = row.split(separator: "|")[1]
                .split(separator: " ")[0]
                .filter { $0 != "`" }
            let expected = try #require(cell.hasPrefix("0x") ? Int(cell.dropFirst(2), radix: 16) : Int(cell))
            #expect(fields[name] == expected, "\(name)")
        }
    }

    @Test("the sizes in the header fit the file")
    func sizesFitTheFile() throws {
        let image = try Data(contentsOf: Self.directory.appendingPathComponent("vmtest.qvm"))
        let codeOffset = Self.word(image, at: 8)
        let codeLength = Self.word(image, at: 12)
        let dataOffset = Self.word(image, at: 16)
        let dataLength = Self.word(image, at: 20)
        let litLength = Self.word(image, at: 24)
        let bssLength = Self.word(image, at: 28)

        // The checks of VM_Create
        #expect(codeOffset == 32)
        #expect(codeLength > 0)
        #expect(dataOffset == codeOffset + codeLength)
        #expect(image.count == dataOffset + dataLength + litLength)
        #expect(bssLength >= 0)
        #expect(dataLength + litLength + bssLength == 0x20000)
    }

    @Test("the lit segment holds JKA and the map names vmMain at instruction 0")
    func litAndMap() throws {
        let image = try Data(contentsOf: Self.directory.appendingPathComponent("vmtest.qvm"))
        let dataOffset = Self.word(image, at: 16)
        #expect(Self.word(image, at: dataOffset) == 7)
        #expect(Array(image[(dataOffset + 4)...]) == [0x4A, 0x4B, 0x41, 0x00])

        let map = try String(contentsOf: Self.directory.appendingPathComponent("vmtest.map"), encoding: .utf8)
        #expect(map.split(separator: "\n").first == "0 00000000 vmMain")
    }

    // MARK: - Reading

    /// This reads one little-endian 32-bit word at a byte offset.
    static func word(_ image: Data, at offset: Int) -> Int {
        var value: UInt32 = 0
        for byte in 0..<4 {
            value |= UInt32(image[image.startIndex + offset + byte]) << UInt32(8 * byte)
        }
        return Int(Int32(bitPattern: value))
    }
}
