import Testing
@testable import JKATestSupport

@Suite("OracleData reads the Oracle goldens and fixtures")
struct OracleDataTests {
    static let goldenNames = [
        "bglib", "bgmisc", "gcombat", "pmove", "pmove_saber",
        "pmove_trace", "qmath", "qshared", "saberload", "wsaber",
    ]

    @Test("each golden loads as non-empty text with a recognized header", arguments: goldenNames)
    func goldenLoads(name: String) throws {
        let text = try OracleData.golden(name)
        #expect(!text.isEmpty)
        let firstLine = text.split(separator: "\n", maxSplits: 1).first.map(String.init) ?? ""
        #expect(firstLine.hasPrefix("== ") || firstLine.hasPrefix("-- "))
    }

    @Test("a fixture loads as non-empty text")
    func fixtureLoads() throws {
        let text = try OracleData.fixture("ints.txt")
        #expect(!text.isEmpty)
    }

    @Test("a missing name throws OracleDataError.missing")
    func missingNameThrows() {
        #expect(throws: OracleDataError.missing("golden/nope.txt")) {
            try OracleData.golden("nope")
        }
    }
}
