import Foundation
import JKATestSupport
import Testing
@testable import JKAMP_BG
import JKAMP
import JKAShared

/// The differential test of rule 18. It rebuilds `Oracle/golden/saberload.txt` from the ported `WP_SaberLoadParms` and `WP_SaberParseParms` and compares the whole text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_saberload.c`, token for token.
/// The dump runs in a child process, because it replaces the one `bg` state and other suites use that state at the same time.
@Suite("bg_saberLoad reproduces the saberload golden")
struct SaberLoadParityTests {
    @Test("the whole golden text matches")
    func goldenMatches() async throws {
        // given the fixture sabers behind the file system traps, when the child process loads and parses them
        let result = await #expect(processExitsWith: .success, observing: [\.standardOutputContent]) {
            try SaberLoadDump.writeDump()
        }

        // then its standard output is the golden text
        let got = String(decoding: result?.standardOutputContent ?? [], as: UTF8.self)
        let golden = try OracleData.golden("saberload")
        #expect(GoldenFormat.mismatch("saberload", got: got, golden: golden) == nil)
        #expect(got == golden)
    }
}

// MARK: - The dump

/// Each method rebuilds a part of the golden with the dumper's tokens and the dumper's order.
enum SaberLoadDump {
    /// The saber names the dumper parses, in its order.
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:302
    static let names = [
        "Kyle",
        "staff_saber",
        "edge_saber",
        "broken_saber",
        "nonexistent_xyz",
        "",
    ]

    /// This rebuilds the whole golden and writes it to standard output, for the parent process to compare.
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:311
    static func writeDump() throws {
        let files = try SaberLoadFixtureFiles()
        let registrations = SaberLoadRegistrations()
        Self.install(files: files, registrations: registrations)

        WP_SaberLoadParms()
        var out = "== saberload ==\n"
        for name in Self.names {
            out += Self.saber(name, registrations: registrations)
        }
        out += "== end ==\n"
        FileHandle.standardOutput.write(Data(out.utf8))
    }

    /// This builds a game state with the dumper's traps in place of the engine.
    /// `Com_Printf` goes to standard error as in the dumper, so standard output carries the dump alone.
    static func install(files: SaberLoadFixtureFiles, registrations: SaberLoadRegistrations) {
        bg = BgState()
        bg.print = { text in FileHandle.standardError.write(Data(text.utf8)) }
        bg.straps.trap_FS_GetFileList = { path, fileExtension, bufsize in
            files.fileList(path, fileExtension, bufsize)
        }
        bg.straps.trap_FS_FOpenFile = { qpath, f, _ in files.open(qpath, handle: &f) }
        bg.straps.trap_FS_Read = { buffer, len, f in files.read(into: buffer, count: len, handle: f) }
        bg.straps.trap_FS_FCloseFile = { f in files.close(f) }
        bg.straps.trap_R_RegisterSkin = { name in registrations.registerSkin(name) }
        bg.callbacks.G_SoundIndex = { name in registrations.soundIndex(name) }
    }

    /// This prints one saber block: the request, the result, every `saberInfo_t` field in declaration order, and the registrations.
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:211
    static func saber(_ reqname: String, registrations: SaberLoadRegistrations) -> String {
        registrations.resetForSaber()
        return JKAMP.SaberInfo.scratch { saber in
            let ret = WP_SaberParseParms(reqname, saber)

            var out = "saber \"\(reqname)\"\n"
            out += Self.pi("ret", ret ? 1 : 0)
            out += Self.qstr("name", saber.name)
            out += Self.qstr("fullName", saber.fullName)
            out += Self.pi("type", saber.type)
            out += Self.qstr("model", saber.model)
            out += Self.pi("skin", saber.skin)
            out += Self.pi("soundOn", saber.soundOn)
            out += Self.pi("soundLoop", saber.soundLoop)
            out += Self.pi("soundOff", saber.soundOff)
            out += Self.pi("numBlades", saber.numBlades)
            for i in 0 ..< Int(JKAShared.MAX_BLADES) {
                let blade = saber.blade[i]
                out += "blade\(i) color \(blade.color) radius \(GoldenFormat.bits(blade.radius)) lengthMax \(GoldenFormat.bits(blade.lengthMax))\n"
            }
            out += Self.pi("stylesLearned", saber.stylesLearned)
            out += Self.pi("stylesForbidden", saber.stylesForbidden)
            out += Self.pi("maxChain", saber.maxChain)
            out += Self.pi("forceRestrictions", saber.forceRestrictions)
            out += Self.pi("lockBonus", saber.lockBonus)
            out += Self.pi("parryBonus", saber.parryBonus)
            out += Self.pi("breakParryBonus", saber.breakParryBonus)
            out += Self.pi("breakParryBonus2", saber.breakParryBonus2)
            out += Self.pi("disarmBonus", saber.disarmBonus)
            out += Self.pi("disarmBonus2", saber.disarmBonus2)
            out += Self.pi("singleBladeStyle", saber.singleBladeStyle)
            out += Self.pi("saberFlags", saber.saberFlags)
            out += Self.pi("saberFlags2", saber.saberFlags2)
            out += Self.pi("spinSound", saber.spinSound)
            out += Self.triple("swingSound", saber.swingSound)
            out += Self.pfh("moveSpeedScale", saber.moveSpeedScale)
            out += Self.pfh("animSpeedScale", saber.animSpeedScale)
            out += Self.pi("kataMove", saber.kataMove)
            out += Self.pi("lungeAtkMove", saber.lungeAtkMove)
            out += Self.pi("jumpAtkUpMove", saber.jumpAtkUpMove)
            out += Self.pi("jumpAtkFwdMove", saber.jumpAtkFwdMove)
            out += Self.pi("jumpAtkBackMove", saber.jumpAtkBackMove)
            out += Self.pi("jumpAtkRightMove", saber.jumpAtkRightMove)
            out += Self.pi("jumpAtkLeftMove", saber.jumpAtkLeftMove)
            out += Self.pi("readyAnim", saber.readyAnim)
            out += Self.pi("drawAnim", saber.drawAnim)
            out += Self.pi("putawayAnim", saber.putawayAnim)
            out += Self.pi("tauntAnim", saber.tauntAnim)
            out += Self.pi("bowAnim", saber.bowAnim)
            out += Self.pi("meditateAnim", saber.meditateAnim)
            out += Self.pi("flourishAnim", saber.flourishAnim)
            out += Self.pi("gloatAnim", saber.gloatAnim)
            out += Self.pi("bladeStyle2Start", saber.bladeStyle2Start)
            out += Self.pi("trailStyle", saber.trailStyle)
            out += Self.pi("g2MarksShader", saber.g2MarksShader)
            out += Self.pi("g2WeaponMarkShader", saber.g2WeaponMarkShader)
            out += Self.triple("hitSound", saber.hitSound)
            out += Self.triple("blockSound", saber.blockSound)
            out += Self.triple("bounceSound", saber.bounceSound)
            out += Self.pi("blockEffect", saber.blockEffect)
            out += Self.pi("hitPersonEffect", saber.hitPersonEffect)
            out += Self.pi("hitOtherEffect", saber.hitOtherEffect)
            out += Self.pi("bladeEffect", saber.bladeEffect)
            out += Self.pfh("knockbackScale", saber.knockbackScale)
            out += Self.pfh("damageScale", saber.damageScale)
            out += Self.pfh("splashRadius", saber.splashRadius)
            out += Self.pi("splashDamage", saber.splashDamage)
            out += Self.pfh("splashKnockback", saber.splashKnockback)
            out += Self.pi("trailStyle2", saber.trailStyle2)
            out += Self.pi("g2MarksShader2", saber.g2MarksShader2)
            out += Self.pi("g2WeaponMarkShader2", saber.g2WeaponMarkShader2)
            out += Self.triple("hit2Sound", saber.hit2Sound)
            out += Self.triple("block2Sound", saber.block2Sound)
            out += Self.triple("bounce2Sound", saber.bounce2Sound)
            out += Self.pi("blockEffect2", saber.blockEffect2)
            out += Self.pi("hitPersonEffect2", saber.hitPersonEffect2)
            out += Self.pi("hitOtherEffect2", saber.hitOtherEffect2)
            out += Self.pi("bladeEffect2", saber.bladeEffect2)
            out += Self.pfh("knockbackScale2", saber.knockbackScale2)
            out += Self.pfh("damageScale2", saber.damageScale2)
            out += Self.pfh("splashRadius2", saber.splashRadius2)
            out += Self.pi("splashDamage2", saber.splashDamage2)
            out += Self.pfh("splashKnockback2", saber.splashKnockback2)

            out += registrations.lines
            out += "--\n"
            return out
        }
    }
}

// MARK: - The tokens

extension SaberLoadDump {
    /// The dumper's `qstr`, a tag and a quoted string.
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:207
    static func qstr(_ tag: String, _ value: String) -> String {
        "\(tag) \"\(value)\"\n"
    }

    /// The dumper's `pi`, a tag and a decimal integer.
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:208
    static func pi(_ tag: String, _ value: Int32) -> String {
        "\(tag) \(value)\n"
    }

    /// The dumper's `pfh`, a tag and the bit pattern of a float.
    /// Source: jka-rust/tools/jampgame-oracle/main_saberload.c:209
    static func pfh(_ tag: String, _ value: Float) -> String {
        "\(tag) \(GoldenFormat.bits(value))\n"
    }

    /// The dumper's three-sound line, a tag and three decimal handles.
    static func triple(_ tag: String, _ values: Slots<JKAShared.qhandle_t>) -> String {
        "\(tag) \(values[0]) \(values[1]) \(values[2])\n"
    }
}
