import JKAMP
import JKAShared
import JKATestSupport
import Testing
@testable import JKAMP_GameLogic

/// The differential test of rule 18 for `Oracle/golden/gcombat.txt`.
/// Each test rebuilds one section from the ported `g_combat.c` functions over the `fixtures/gcombat/` inputs and compares the section text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_gcombat.c`, and the Rust twin is `jka-rust/crates/mp/game/tests/gcombat_parity.rs`.
/// The `hitloc` and `armor` tests assign a fresh world to the one global, so the suite runs one test after the other. Rule 3.
@Suite("g_combat reproduces the gcombat golden", .serialized)
struct GCombatParityTests {
    @Test("the raysphere section matches")
    func raysphereMatches() throws {
        let got = try GCombatDump.raysphereSection()

        try GCombatDump.expectSection("raysphere", got: got)
    }

    @Test("the hitloc section matches")
    func hitlocMatches() throws {
        world = GameWorld()

        let got = try GCombatDump.hitlocSection()

        try GCombatDump.expectSection("hitloc", got: got)
    }

    @Test("the armor section matches")
    func armorMatches() throws {
        world = GameWorld()

        let got = try GCombatDump.armorSection()

        try GCombatDump.expectSection("armor", got: got)
    }
}

// MARK: - The dump

enum GCombatDump {
    /// This compares the rebuilt text with one section of the golden, exact text.
    static func expectSection(_ name: String, got: String) throws {
        let golden = try OracleData.golden("gcombat")
        let expected = try #require(Self.section(name, of: golden))
        #expect(GoldenFormat.mismatch("gcombat", got: got, golden: expected) == nil)
        #expect(got == expected)
    }

    /// This returns one section of a golden, from its banner line to the line before the next banner.
    static func section(_ name: String, of golden: String) -> String? {
        guard let start = golden.range(of: "== \(name) ==\n") else { return nil }
        let rest = golden[start.lowerBound...]
        guard let next = rest.range(of: "\n== ", range: start.upperBound ..< rest.endIndex) else { return String(rest) }
        return String(rest[..<rest.index(after: next.lowerBound)])
    }

    /// This returns the token rows of one fixture that start with the tag.
    /// A comment line starts with `#`, so its first token never equals a tag.
    static func rows(_ fixture: String, tag: Substring) throws -> [[Substring]] {
        let text = try OracleData.fixture("gcombat/\(fixture)")
        let lines = text.split(separator: "\n").map { $0.split(separator: " ") }
        return lines.filter { $0.first == tag }
    }

    /// A float token is a plain integer as `(float)atol`, or a `0x` bit pattern.
    /// Source: jka-rust/tools/jampgame-oracle/main_gcombat.c:71
    static func pf(_ token: Substring) -> Float {
        if token.hasPrefix("0x") || token.hasPrefix("0X") {
            return Float(bitPattern: UInt32(token.dropFirst(2), radix: 16) ?? 0)
        }
        return Float(Int(token) ?? 0)
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_gcombat.c:79
    static func pi(_ token: Substring) -> Int32 {
        if token.hasPrefix("0x") || token.hasPrefix("0X") {
            return Int32(bitPattern: UInt32(token.dropFirst(2), radix: 16) ?? 0)
        }
        return Int32(token) ?? 0
    }

    /// The columns are `ray <origin xyz> <radius> <point xyz> <dir xyz>`.
    /// The record echoes `dir` after the function normalizes it, and an unwritten intersection slot stays zero.
    /// Source: jka-rust/crates/mp/game/tests/gcombat_parity.rs:39
    static func raysphereSection() throws -> String {
        var out = "== raysphere ==\n"
        for (idx, tok) in try Self.rows("raysphere.txt", tag: "ray").enumerated() {
            let origin = vec3_t(Self.pf(tok[1]), Self.pf(tok[2]), Self.pf(tok[3]))
            let radius = Self.pf(tok[4])
            let point = vec3_t(Self.pf(tok[5]), Self.pf(tok[6]), Self.pf(tok[7]))
            var dir = vec3_t(Self.pf(tok[8]), Self.pf(tok[9]), Self.pf(tok[10]))
            var intersections = [vec3_t(), vec3_t()]
            let n = RaySphereIntersections(
                origin,
                radius,
                point,
                &dir,
                &intersections
            )
            let i0 = GoldenFormat.vector(intersections[0])
            let i1 = GoldenFormat.vector(intersections[1])
            out += "ray \(idx) n \(n) dir \(GoldenFormat.vector(dir)) i0 \(i0) i1 \(i1)\n"
        }
        return out
    }

    /// The columns are `h <yaw> <absmin xyz> <absmax xyz> <mins xy> <maxs xy> <ppoint xyz>`.
    /// The target is entity 0 with client 0 seated, because a target with no client leaves `tangles` unset in Raven. Rule 19.
    /// Source: jka-rust/crates/mp/game/tests/gcombat_parity.rs:69
    static func hitlocSection() throws -> String {
        var out = "== hitloc ==\n"
        for (idx, tok) in try Self.rows("hitloc.txt", tag: "h").enumerated() {
            let ent = g_entities[0]
            ent.clear()
            g_clients[0].clear()
            ent.client = g_clients[0]
            ent.r.currentAngles[YAW] = Self.pf(tok[1])
            ent.r.absmin = vec3_t(Self.pf(tok[2]), Self.pf(tok[3]), Self.pf(tok[4]))
            ent.r.absmax = vec3_t(Self.pf(tok[5]), Self.pf(tok[6]), Self.pf(tok[7]))
            ent.r.mins[0] = Self.pf(tok[8])
            ent.r.mins[1] = Self.pf(tok[9])
            ent.r.maxs[0] = Self.pf(tok[10])
            ent.r.maxs[1] = Self.pf(tok[11])
            let ppoint = vec3_t(Self.pf(tok[12]), Self.pf(tok[13]), Self.pf(tok[14]))
            let hl = G_GetHitLocation(ent, ppoint)
            out += "h \(idx) hl \(hl)\n"
        }
        return out
    }

    /// The columns are `a <armor> <isVehicle 0|1> <electrifyTime> <hasVehicle 0|1> <levelTime> <damage> <dflags>`.
    /// An `isVehicle` of 1 sets `CLASS_VEHICLE`, and a `hasVehicle` of 1 seats slot 0 of the vehicle pool as a pointer that is not null.
    /// Source: jka-rust/crates/mp/game/tests/gcombat_parity.rs:112
    static func armorSection() throws -> String {
        var out = "== armor ==\n"
        for (idx, tok) in try Self.rows("armor.txt", tag: "a").enumerated() {
            let ent = g_entities[0]
            let client = g_clients[0]
            ent.clear()
            client.clear()
            client.ps.stats[STAT_ARMOR] = Self.pi(tok[1])
            client.NPC_class = Self.pi(tok[2]) != 0 ? CLASS_VEHICLE : CLASS_NONE
            client.ps.electrifyTime = Self.pi(tok[3])
            ent.client = client
            ent.m_pVehicle = Self.pi(tok[4]) != 0 ? g_vehiclePool[0] : nil
            level.time = Self.pi(tok[5])
            let damage = Self.pi(tok[6])
            let dflags = Self.pi(tok[7])
            let ret = CheckArmor(ent, damage, dflags)
            out += "a \(idx) ret \(ret) armor \(client.ps.stats[STAT_ARMOR])\n"
        }
        return out
    }
}
