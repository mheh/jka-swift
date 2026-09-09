import JKATestSupport
import Testing
@testable import JKAMP_BG

/// The differential test of rule 18. It rebuilds `Oracle/golden/bglib.txt` from the ported `qsort` and compares the whole text.
/// The `kv` block sorts by key alone, so its output pins the permutation `qsort` gives to equal keys.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_bglib.c`, token for token.
@Suite("bg_lib reproduces the bglib golden")
struct BGLibParityTests {
    @Test("the whole golden text matches")
    func goldenMatches() throws {
        var got = try BGLibDump.qsortSection()
        got += "== end ==\n"

        let golden = try OracleData.golden("bglib")
        #expect(GoldenFormat.mismatch("bglib", got: got, golden: golden) == nil)
        #expect(got == golden)
    }
}

// MARK: - The dump

enum BGLibDump {
    /// One key and one payload, so an equal-key tie is visible in the output.
    struct Kv {
        var key: Int32
        var payload: Int32
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_bglib.c:25
    static func qsortSection() throws -> String {
        var out = "== qsort ==\n"
        var arr: [Int32] = try OracleData.fixture("ints.txt")
            .split(separator: "\n")
            .compactMap { Int32($0.trimmingCharacters(in: .whitespaces)) }
        let n = arr.count
        qsort(&arr) { x, y in
            Int32(x > y ? 1 : 0) - Int32(x < y ? 1 : 0)
        }
        out += "ints \(n)\n"
        for value in arr {
            out += "\(value)\n"
        }

        // struct array: sort by key, dump (key,payload) to observe qsort's
        // (unstable) ordering of equal keys deterministically.
        var kv: [Kv] = [
            (5, 0), (3, 1), (5, 2), (1, 3), (3, 4), (9, 5), (1, 6), (7, 7), (3, 8), (5, 9),
            (0, 10), (8, 11), (2, 12), (8, 13), (4, 14), (6, 15), (3, 16), (9, 17), (1, 18), (5, 19),
        ].map { Kv(key: $0.0, payload: $0.1) }
        let kn = kv.count
        qsort(&kv) { x, y in
            Int32(x.key > y.key ? 1 : 0) - Int32(x.key < y.key ? 1 : 0)
        }
        out += "kv \(kn)\n"
        for entry in kv {
            out += "\(entry.key) \(entry.payload)\n"
        }
        return out
    }
}
