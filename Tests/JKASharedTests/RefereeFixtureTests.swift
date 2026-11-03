import Foundation
import Testing
import JKATestSupport

/// This suite reads `reflog-real-duel1-idle.rec` and checks its `REFREC v1` header line field by field.
/// The format is the fork's `sv_referee.cpp:166-170` and `:590`, and the records after the line wait for the port of `sv_referee.swift`.
struct RefereeFixtureSuite {
    @Test("the header line of reflog-real-duel1-idle.rec holds each field")
    func headerFields() throws {
        let file = try OracleData.fixtureData("referee/reflog-real-duel1-idle.rec")
        #expect(file.count == 866)

        // The header is one text line and a newline, and the binary records start after it.
        let newline = try #require(file.firstIndex(of: 0x0A))
        #expect(newline - file.startIndex == 39)
        let line = try #require(String(data: file[file.startIndex..<newline], encoding: .ascii))
        let words = line.split(separator: " ", omittingEmptySubsequences: false)
        #expect(words.count == 5)
        #expect(words[0] == "REFREC")
        #expect(words[1] == "v1")

        // Each key appears once, in the fork's order.
        let pairs = words.dropFirst(2).map { $0.split(separator: "=", maxSplits: 1) }
        #expect(pairs.map { String($0[0]) } == ["map", "seed", "fps"])
        #expect(pairs[0][1] == "mp/duel1")
        #expect(Int32(pairs[1][1]) == 4001)
        #expect(Int32(pairs[2][1]) == 20)
    }
}
