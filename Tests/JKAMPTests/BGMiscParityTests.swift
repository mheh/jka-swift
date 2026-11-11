import JKAShared
import JKATestSupport
import Testing
@testable import JKAMP_BG
import JKAMP

/// The golden records that the Swift signatures cannot produce, which the comparison leaves out by key.
/// Each entry gives the key of the record, Raven's line, and the argument that the Swift form does not take.
private let skippedRecords: [(key: String, raven: String, argument: String)] = [
    ("grab nullps", "oracle/codemp/game/bg_misc.c:2201", "a NULL `ps`, which the non-optional PlayerState view cannot hold"),
]

/// The differential test of rule 18 for the seven sections of `Oracle/golden/bgmisc.txt` after `trajectory`.
/// Each test rebuilds one section from the ported tables and functions and compares the section text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_bgmisc.c`, token for token.
@Suite("bg_misc reproduces the table and state sections of the bgmisc golden")
struct BGMiscParityTests {
    @Test("the itemlist section matches")
    func itemlistMatches() throws {
        try Self.check("itemlist", got: BGMiscDump.itemlistSection())
    }

    @Test("the findid section matches")
    func findidMatches() throws {
        try Self.check("findid", got: BGMiscDump.findidSection())
    }

    @Test("the weapondata section matches")
    func weapondataMatches() throws {
        try Self.check("weapondata", got: BGMiscDump.weapondataSection())
    }

    @Test("the ammodata section matches")
    func ammodataMatches() throws {
        try Self.check("ammodata", got: BGMiscDump.ammodataSection())
    }

    @Test("the grab section matches")
    func grabMatches() throws {
        try Self.check("grab", got: BGMiscDump.grabSection())
    }

    @Test("the ps2es section matches")
    func ps2esMatches() throws {
        try Self.check("ps2es", got: BGMiscDump.ps2esSection())
    }

    @Test("the ps2esxp section matches")
    func ps2esxpMatches() throws {
        try Self.check("ps2esxp", got: BGMiscDump.ps2esxpSection())
    }

    /// This compares one rebuilt section with the same section of the golden, exact text, less the records of `skippedRecords`.
    private static func check(_ name: String, got: String) throws {
        let golden = try OracleData.golden("bgmisc")
        let section = try #require(BGMiscDump.section(name, of: golden))
        let lines = section.split(separator: "\n", omittingEmptySubsequences: false)
        let kept = lines.filter { line in
            !skippedRecords.contains { line == $0.key || line.hasPrefix($0.key + " ") }
        }
        let expected = kept.joined(separator: "\n")
        #expect(GoldenFormat.mismatch("bgmisc", got: got, golden: expected) == nil)
        #expect(got == expected)
    }
}

// MARK: - The table sections

extension BGMiscDump {
    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:213
    static func itemlistSection() -> String {
        var out = "== itemlist ==\n"
        // The C table keeps the empty slot 0 and the end marker, so the walk to `bg_numItems` prints both as Raven stored them.
        for i in 0 ... Int(bg_numItems) {
            let it = bg_itemlist[i]
            out += "item \(i)\n"
            out += Self.pS(" classname", it.classname)
            out += Self.pS(" pickup_sound", it.pickup_sound)
            for m in 0 ..< it.world_model.count {
                out += Self.pS(" world_model\(m)", it.world_model[m])
            }
            out += Self.pS(" view_model", it.view_model)
            out += Self.pS(" icon", it.icon)
            out += Self.pI(" quantity", it.quantity)
            out += Self.pI(" giType", it.giType)
            out += Self.pI(" giTag", it.giTag)
            out += Self.pS(" precaches", it.precaches)
            out += Self.pS(" sounds", it.sounds)
            out += Self.pS(" description", it.description)
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:236
    static func findidSection() -> String {
        var out = "== findid ==\n"
        // The weapon, ammo, and holdable searches stop on `Com_Error` for a tag with no item, so only tags with an item are queried.
        for w in (WP_NONE + 1) ..< WP_NUM_WEAPONS {
            out += "weapon \(w) \(Self.itemIndex(BG_FindItemForWeapon(w)))\n"
        }
        let ammos = [
            AMMO_FORCE,
            AMMO_BLASTER,
            AMMO_POWERCELL,
            AMMO_METAL_BOLTS,
            AMMO_ROCKETS,
            AMMO_THERMAL,
            AMMO_TRIPMINE,
            AMMO_DETPACK,
        ]
        for a in ammos {
            out += "ammo \(a) \(Self.itemIndex(BG_FindItemForAmmo(a)))\n"
        }
        for h in (HI_NONE + 1) ..< HI_NUM_HOLDABLE {
            out += "holdable \(h) \(Self.itemIndex(BG_FindItemForHoldable(h)))\n"
        }
        for p in 0 ... PW_NUM_POWERUPS {
            out += "powerup \(p) \(Self.itemIndex(BG_FindItemForPowerup(p)))\n"
        }
        out += "powerup 999 \(Self.itemIndex(BG_FindItemForPowerup(999)))\n"
        let names = [
            "weapon_saber",
            "weapon_blaster",
            "ammo_blaster",
            "item_shield_sm_instant",
            "team_CTF_redflag",
            "item_medpac",
            "item_force_enlighten_light",
            "weapon_stun_baton",
            "nonexistent_item",
            "",
        ]
        for name in names {
            out += "find \"\(name)\" \(Self.itemIndex(BG_FindItem(name)))\n"
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:264
    static func weapondataSection() -> String {
        var out = "== weapondata ==\n"
        for w in 0 ..< Int(WP_NUM_WEAPONS) {
            let d = weaponData[w]
            let fields = [
                d.ammoIndex,
                d.ammoLow,
                d.energyPerShot,
                d.fireTime,
                d.range,
                d.altEnergyPerShot,
                d.altFireTime,
                d.altRange,
                d.chargeSubTime,
                d.altChargeSubTime,
                d.chargeSub,
                d.altChargeSub,
                d.maxCharge,
                d.altMaxCharge,
            ]
            out += "wd \(w) " + fields.map { String($0) }.joined(separator: " ") + "\n"
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:273
    static func ammodataSection() -> String {
        var out = "== ammodata ==\n"
        for a in 0 ..< Int(AMMO_MAX) {
            out += "ad \(a) \(ammoData[a].max)\n"
        }
        return out
    }

    /// Raven's `it - bg_itemlist` for a found item, and -1 for NULL.
    private static func itemIndex(_ item: Gitem?) -> Int32 {
        guard let item else { return -1 }
        let index: Int32 = bg_itemlist.index(of: item)
        return index
    }
}

// MARK: - The state sections

extension BGMiscDump {
    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:278
    static func grabSection() throws -> String {
        var out = "== grab ==\n"
        let text = try OracleData.fixture("bgmisc/grab.txt")
        JKAMP.EntityState.scratch { ent in
            JKAMP.PlayerState.scratch { ps in
                var gametype: Int32 = 0
                var havePs = false
                for line in text.split(separator: "\n") {
                    let tok = Self.tokens(line)
                    if tok.isEmpty || tok[0].hasPrefix("#") {
                        continue
                    }
                    switch tok[0] {
                    case "reset":
                        ent.clear()
                        ps.clear()
                        gametype = 0
                        havePs = true

                    case "nullps":
                        havePs = false

                    case "gametype":
                        gametype = Self.pi(tok[1])

                    case "ent":
                        Self.esSet(ent, Array(tok.dropFirst()))

                    case "ps":
                        Self.psSet(ps, Array(tok.dropFirst()))

                    case "run":
                        // A NULL `ps` has no Swift call, so its record is in `skippedRecords`.
                        if !havePs {
                            break
                        }
                        let grabbed = BG_CanItemBeGrabbed(gametype, ent, ps)
                        out += "grab \(tok[1]) \(grabbed ? 1 : 0)\n"

                    default:
                        Issue.record("grab: unknown cmd '\(tok[0])'")
                    }
                }
            }
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:371
    static func ps2esSection() throws -> String {
        var out = "== ps2es ==\n"
        let text = try OracleData.fixture("bgmisc/ps.txt")
        JKAMP.PlayerState.scratch { ps in
            var snap: Int32 = 0
            for line in text.split(separator: "\n") {
                let tok = Self.tokens(line)
                if tok.isEmpty || tok[0].hasPrefix("#") {
                    continue
                }
                switch tok[0] {
                case "reset":
                    ps.clear()
                    snap = 0

                case "snap":
                    snap = Self.pi(tok[1])

                case "ps":
                    Self.psSet(ps, Array(tok.dropFirst()))

                case "run":
                    JKAMP.EntityState.scratch { s in
                        BG_PlayerStateToEntityState(ps, s, snap != 0)
                        out += Self.dumpES(String(tok[1]), ps, s)
                    }

                default:
                    Issue.record("ps2es: unknown cmd '\(tok[0])'")
                }
            }
        }
        return out
    }

    /// The extrapolation runs over the same fixture with `snap` 0 and a fixed time, and it adds the two time fields after the base dump.
    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:405
    static func ps2esxpSection() throws -> String {
        var out = "== ps2esxp ==\n"
        let text = try OracleData.fixture("bgmisc/ps.txt")
        JKAMP.PlayerState.scratch { ps in
            for line in text.split(separator: "\n") {
                let tok = Self.tokens(line)
                if tok.isEmpty || tok[0].hasPrefix("#") {
                    continue
                }
                switch tok[0] {
                case "reset":
                    ps.clear()

                case "snap":
                    // The dumper ignores `snap` here and runs with `snap` 0.
                    break

                case "ps":
                    Self.psSet(ps, Array(tok.dropFirst()))

                case "run":
                    JKAMP.EntityState.scratch { s in
                        BG_PlayerStateToEntityStateExtraPolate(ps, s, Self.xpTime, false)
                        out += Self.dumpES(String(tok[1]), ps, s)
                        out += Self.pI(" pos.trTime", s.pos.trTime)
                        out += Self.pI(" pos.trDuration", s.pos.trDuration)
                    }

                default:
                    Issue.record("ps2esxp: unknown cmd '\(tok[0])'")
                }
            }
        }
        return out
    }

    /// The `XP_TIME` of the dumper, the extrapolation time of every run.
    private static let xpTime: Int32 = 12345

    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:313
    private static func dumpES(_ label: String, _ ps: JKAMP.PlayerState, _ s: JKAMP.EntityState) -> String {
        var out = "es \(label)\n"
        out += Self.pI(" eType", s.eType)
        out += Self.pI(" number", s.number)
        out += Self.pI(" pos.trType", s.pos.trType)
        out += Self.pV(" pos.trBase", s.pos.trBase)
        out += Self.pV(" pos.trDelta", s.pos.trDelta)
        out += Self.pI(" apos.trType", s.apos.trType)
        out += Self.pV(" apos.trBase", s.apos.trBase)
        out += Self.pI(" trickedentindex", s.trickedentindex)
        out += Self.pI(" trickedentindex2", s.trickedentindex2)
        out += Self.pI(" trickedentindex3", s.trickedentindex3)
        out += Self.pI(" trickedentindex4", s.trickedentindex4)
        out += Self.pI(" forceFrame", s.forceFrame)
        out += Self.pI(" emplacedOwner", s.emplacedOwner)
        out += " speed \(GoldenFormat.bits(s.speed))\n"
        out += Self.pI(" genericenemyindex", s.genericenemyindex)
        out += Self.pI(" activeForcePass", s.activeForcePass)
        out += Self.pV(" angles2", s.angles2)
        out += Self.pI(" legsAnim", s.legsAnim)
        out += Self.pI(" torsoAnim", s.torsoAnim)
        out += Self.pB(" legsFlip", s.legsFlip)
        out += Self.pB(" torsoFlip", s.torsoFlip)
        out += Self.pI(" clientNum", s.clientNum)
        out += Self.pI(" eFlags", s.eFlags)
        out += Self.pI(" eFlags2", s.eFlags2)
        out += Self.pB(" saberInFlight", s.saberInFlight)
        out += Self.pI(" saberEntityNum", s.saberEntityNum)
        out += Self.pI(" saberMove", s.saberMove)
        out += Self.pI(" forcePowersActive", s.forcePowersActive)
        out += Self.pI(" bolt1", s.bolt1)
        out += Self.pI(" otherEntityNum2", s.otherEntityNum2)
        out += Self.pI(" saberHolstered", s.saberHolstered)
        out += Self.pI(" event", s.event)
        out += Self.pI(" eventParm", s.eventParm)
        out += Self.pI(" weapon", s.weapon)
        out += Self.pI(" groundEntityNum", s.groundEntityNum)
        out += Self.pI(" powerups", s.powerups)
        out += Self.pI(" loopSound", s.loopSound)
        out += Self.pI(" generic1", s.generic1)
        out += Self.pI(" modelindex2", s.modelindex2)
        out += Self.pI(" constantLight", s.constantLight)
        out += Self.pV(" origin2", s.origin2)
        out += Self.pB(" isJediMaster", s.isJediMaster)
        out += Self.pI(" time2", s.time2)
        out += Self.pI(" fireflag", s.fireflag)
        out += Self.pI(" heldByClient", s.heldByClient)
        out += Self.pI(" ragAttach", s.ragAttach)
        out += Self.pI(" iModelScale", s.iModelScale)
        out += Self.pI(" brokenLimbs", s.brokenLimbs)
        out += Self.pB(" hasLookTarget", s.hasLookTarget)
        out += Self.pI(" lookTarget", s.lookTarget)
        out += " customRGBA \(s.customRGBA[0]) \(s.customRGBA[1]) \(s.customRGBA[2]) \(s.customRGBA[3])\n"
        out += Self.pI(" m_iVehicleNum", s.m_iVehicleNum)
        // The events path of the conversion moves `entityEventSequence` forward on the player state.
        out += Self.pI(" ps.entityEventSequence", ps.entityEventSequence)
        return out
    }
}

// MARK: - The fixture setters

extension BGMiscDump {
    /// This sets one `playerState_t` field, named by the first token, from the tokens after it.
    /// A `qboolean` field is a `Bool` in the view, so the setter stores the token as true when it is not 0.
    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:83
    static func psSet(_ ps: JKAMP.PlayerState, _ tok: [Substring]) {
        switch tok[0] {
        // scalar ints
        case "pm_type": ps.pm_type = Self.pi(tok[1])
        case "clientNum": ps.clientNum = Self.pi(tok[1])
        case "weapon": ps.weapon = Self.pi(tok[1])
        case "weaponstate": ps.weaponstate = Self.pi(tok[1])
        case "weaponChargeTime": ps.weaponChargeTime = Self.pi(tok[1])
        case "groundEntityNum": ps.groundEntityNum = Self.pi(tok[1])
        case "movementDir": ps.movementDir = Self.pi(tok[1])
        case "eFlags": ps.eFlags = Self.pi(tok[1])
        case "eFlags2": ps.eFlags2 = Self.pi(tok[1])
        case "externalEvent": ps.externalEvent = Self.pi(tok[1])
        case "externalEventParm": ps.externalEventParm = Self.pi(tok[1])
        case "eventSequence": ps.eventSequence = Self.pi(tok[1])
        case "entityEventSequence": ps.entityEventSequence = Self.pi(tok[1])
        case "duelInProgress": ps.duelInProgress = Self.pi(tok[1]) != 0
        case "genericEnemyIndex": ps.genericEnemyIndex = Self.pi(tok[1])
        case "isJediMaster": ps.isJediMaster = Self.pi(tok[1]) != 0
        case "trueJedi": ps.trueJedi = Self.pi(tok[1]) != 0
        case "trueNonJedi": ps.trueNonJedi = Self.pi(tok[1]) != 0
        case "legsAnim": ps.legsAnim = Self.pi(tok[1])
        case "torsoAnim": ps.torsoAnim = Self.pi(tok[1])
        case "legsFlip": ps.legsFlip = Self.pi(tok[1]) != 0
        case "torsoFlip": ps.torsoFlip = Self.pi(tok[1]) != 0
        case "saberInFlight": ps.saberInFlight = Self.pi(tok[1]) != 0
        case "saberEntityNum": ps.saberEntityNum = Self.pi(tok[1])
        case "saberMove": ps.saberMove = Self.pi(tok[1])
        case "saberHolstered": ps.saberHolstered = Self.pi(tok[1])
        case "saberLockFrame": ps.saberLockFrame = Self.pi(tok[1])
        case "electrifyTime": ps.electrifyTime = Self.pi(tok[1])
        case "activeForcePass": ps.activeForcePass = Self.pi(tok[1])
        case "emplacedIndex": ps.emplacedIndex = Self.pi(tok[1])
        case "holocronBits": ps.holocronBits = Self.pi(tok[1])
        case "heldByClient": ps.heldByClient = Self.pi(tok[1])
        case "ragAttach": ps.ragAttach = Self.pi(tok[1])
        case "iModelScale": ps.iModelScale = Self.pi(tok[1])
        case "brokenLimbs": ps.brokenLimbs = Self.pi(tok[1])
        case "hasLookTarget": ps.hasLookTarget = Self.pi(tok[1]) != 0
        case "lookTarget": ps.lookTarget = Self.pi(tok[1])
        case "m_iVehicleNum": ps.m_iVehicleNum = Self.pi(tok[1])
        case "loopSound": ps.loopSound = Self.pi(tok[1])
        case "generic1": ps.generic1 = Self.pi(tok[1])

        // float
        case "speed": ps.speed = Self.pf(tok[1])

        // vec3
        case "origin": ps.origin = Self.pv(tok)
        case "velocity": ps.velocity = Self.pv(tok)
        case "viewangles": ps.viewangles = Self.pv(tok)
        case "lastHitLoc": ps.lastHitLoc = Self.pv(tok)

        // indexed int arrays
        case "events": ps.events[Self.pi(tok[1])] = Self.pi(tok[2])
        case "eventParms": ps.eventParms[Self.pi(tok[1])] = Self.pi(tok[2])
        case "powerups": ps.powerups[Self.pi(tok[1])] = Self.pi(tok[2])
        case "customRGBA": ps.customRGBA[Self.pi(tok[1])] = Self.pi(tok[2])
        case "stats": ps.stats[Self.pi(tok[1])] = Self.pi(tok[2])
        case "ammo": ps.ammo[Self.pi(tok[1])] = Self.pi(tok[2])
        case "persistant": ps.persistant[Self.pi(tok[1])] = Self.pi(tok[2])

        // stat aliases
        case "health": ps.stats[STAT_HEALTH] = Self.pi(tok[1])
        case "maxhealth": ps.stats[STAT_MAX_HEALTH] = Self.pi(tok[1])
        case "armor": ps.stats[STAT_ARMOR] = Self.pi(tok[1])
        case "statweapons": ps.stats[STAT_WEAPONS] = Self.pi(tok[1])
        case "holdables": ps.stats[STAT_HOLDABLE_ITEMS] = Self.pi(tok[1])

        // named powerups and persistant slots
        case "powerups_ysalamiri": ps.powerups[PW_YSALAMIRI] = Self.pi(tok[1])
        case "powerups_redflag": ps.powerups[PW_REDFLAG] = Self.pi(tok[1])
        case "powerups_blueflag": ps.powerups[PW_BLUEFLAG] = Self.pi(tok[1])
        case "persistant_team": ps.persistant[PERS_TEAM] = Self.pi(tok[1])

        // forcedata
        case "fd_forcePowersActive": ps.fd.forcePowersActive = Self.pi(tok[1])
        case "fd_saberAnimLevel": ps.fd.saberAnimLevel = Self.pi(tok[1])
        case "fd_mtti1": ps.fd.forceMindtrickTargetIndex = Self.pi(tok[1])
        case "fd_mtti2": ps.fd.forceMindtrickTargetIndex2 = Self.pi(tok[1])
        case "fd_mtti3": ps.fd.forceMindtrickTargetIndex3 = Self.pi(tok[1])
        case "fd_mtti4": ps.fd.forceMindtrickTargetIndex4 = Self.pi(tok[1])

        default:
            Issue.record("ps_set: unknown field '\(tok[0])'")
        }
    }

    /// This sets one `entityState_t` field, named by the first token, from the token after it.
    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:167
    static func esSet(_ es: JKAMP.EntityState, _ tok: [Substring]) {
        switch tok[0] {
        case "modelindex": es.modelindex = Self.pi(tok[1])
        case "modelindex2": es.modelindex2 = Self.pi(tok[1])
        case "generic1": es.generic1 = Self.pi(tok[1])
        case "powerups": es.powerups = Self.pi(tok[1])
        case "eFlags": es.eFlags = Self.pi(tok[1])

        default:
            Issue.record("es_set: unknown field '\(tok[0])'")
        }
    }
}

// MARK: - The text helpers

extension BGMiscDump {
    /// The `tokenize` of the dumper, which splits a line at a space, a tab, or a carriage return.
    static func tokens(_ line: Substring) -> [Substring] {
        line.split { $0 == " " || $0 == "\t" || $0 == "\r" }
    }

    /// The three float tokens after the field name, as one vector.
    private static func pv(_ tok: [Substring]) -> vec3_t {
        vec3_t(Self.pf(tok[1]), Self.pf(tok[2]), Self.pf(tok[3]))
    }

    /// The `pI` of the dumper, a tag and a C `%d`.
    private static func pI(_ tag: String, _ value: Int32) -> String {
        "\(tag) \(value)\n"
    }

    /// A `qboolean` field prints as the 0 or 1 that the C `%d` printed.
    private static func pB(_ tag: String, _ value: Bool) -> String {
        "\(tag) \(value ? 1 : 0)\n"
    }

    /// The `pV` of the dumper, a tag and three float bit patterns.
    private static func pV(_ tag: String, _ value: vec3_t) -> String {
        "\(tag) \(GoldenFormat.vector(value))\n"
    }

    /// The `pS` of the dumper, which prints a NULL string as `(null)`.
    private static func pS(_ tag: String, _ value: String?) -> String {
        "\(tag) \(value ?? "(null)")\n"
    }
}
