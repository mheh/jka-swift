import JKAMP_Ded
import JKAShared
import Testing
@testable import JKAMP_DedLogic

/// This suite checks the port of `md4.cpp` against the test vectors of RFC 1320, appendix A.5.
/// Each test makes a fresh world, because `x`, `bits`, and `digest` live on the storage class of the world.
@Suite(.serialized)
struct MD4Suite {
    @Test("MD4Init, MD4Update, and MD4Final give the RFC 1320 digests", arguments: [
        ("", "31d6cfe0d16ae931b73c59d7e0c089c0"),
        ("abc", "a448017aaf21d8525fc10ae87aa6729d"),
        ("message digest", "d9130a8164549fe818874806e1c7014b"),
    ])
    func digestMatchesTheVector(text: String, expected: String) {
        world = EngineWorld()
        let digest = Self.digest(of: text)
        #expect(Self.hex(digest) == expected)
    }

    @Test("Com_BlockChecksum of abc is the exclusive or of the four digest words")
    func blockChecksumMatchesTheDigest() {
        world = EngineWorld()
        let digest = Self.digest(of: "abc")

        // Raven reads the digest as four `int` words in little-endian order, md4.cpp:276.
        var words: [Int32] = []
        for i in 0..<4 {
            let b = digest[(i * 4)..<(i * 4 + 4)].map { UInt32($0) }
            words.append(Int32(bitPattern: b[0] | (b[1] << 8) | (b[2] << 16) | (b[3] << 24)))
        }
        let expected = UInt32(bitPattern: words[0] ^ words[1] ^ words[2] ^ words[3])

        world = EngineWorld()
        var bytes = Array("abc".utf8) + [0]
        let checksum = bytes.withUnsafeMutableBytes { raw in
            Com_BlockChecksum(
                Slots<JKAShared.byte>(scalars: raw.baseAddress!, count: raw.count),
                3
            )
        }
        #expect(checksum == expected)
    }
}

// MARK: - The digest and the text

extension MD4Suite {
    /// This hashes the UTF-8 bytes of the text through the three md4 functions and returns the 16 digest bytes.
    /// The buffer holds one extra byte, so the empty text still has a base address.
    private static func digest(of text: String) -> [UInt8] {
        var input = Array(text.utf8) + [0]
        var digest = [UInt8](repeating: 0, count: 16)
        input.withUnsafeMutableBytes { inputRaw in
            digest.withUnsafeMutableBytes { digestRaw in
                Md4Ctx.scratch { ctx in
                    MD4Init(ctx)
                    MD4Update(
                        ctx,
                        Slots<UInt8>(scalars: inputRaw.baseAddress!, count: inputRaw.count),
                        UInt32(text.utf8.count)
                    )
                    MD4Final(
                        Slots<UInt8>(scalars: digestRaw.baseAddress!, count: 16),
                        ctx
                    )
                }
            }
        }
        return digest
    }

    /// This writes the bytes as lowercase hexadecimal, two digits for each byte.
    private static func hex(_ bytes: [UInt8]) -> String {
        let digits = Array("0123456789abcdef")
        return String(bytes.flatMap { [digits[Int($0 >> 4)], digits[Int($0 & 0x0f)]] })
    }
}
