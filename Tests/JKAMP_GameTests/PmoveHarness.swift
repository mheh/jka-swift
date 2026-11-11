import Foundation
import JKATestSupport
@testable import JKAMP_BG
@testable import JKAMP_GameLogic
import JKAMP
import JKAMP_Game
import JKAShared

/// This is one pmove dumper the harness copies.
/// The cases share the world, the fixture grammar, the file stub, and the step loop, and they differ in the weapon and the pins.
///
/// - `melee`: `main_pmove.c`, the player holds `WP_MELEE`, and the fixtures are in `fixtures/pmove`.
enum PmoveSlice: Sendable {
    case melee
}

/// This type drives the ported `Pmove` over one scenario fixture, as the pmove dumpers drive Raven's `Pmove`.
/// The dumpers link Raven's game code with `-DQAGAME` and a zeroed `g_entities`, so the harness installs the game's bg channel over a fresh `GameWorld`.
/// The test world, `bg`, `world`, and `rng` are process globals, so a test runs the harness in a child process.
/// The test targets run other suites at the same time, and some of them assign `bg`.
///
/// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:322
enum PmoveHarness {
    // MARK: - State

    /// The test world that the C trace and point functions of the `Pmove` read.
    /// A `@convention(c)` function captures nothing, so the world is a global.
    nonisolated(unsafe) static var world = PmoveWorld()

    /// This line comes before the rebuilt text on the standard output of the child process.
    static let beginMarker = "<<pmove-harness-begin>>\n"

    /// This line comes after the rebuilt text on the standard output of the child process.
    static let endMarker = "<<pmove-harness-end>>\n"

    /// The path the dumpers open for the humanoid anim set.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:333
    static let animationPath = "models/players/_humanoid/animation.cfg"

    /// This is the error of a scenario that cannot start.
    ///
    /// - `animationLoad`: `BG_ParseAnimationFile` returned -1 for the `animation.cfg` of this fixture folder.
    /// - `unknownField`: a `ps` row names a field that the override table does not have.
    /// - `missingOutput`: the child process wrote no text between the two markers.
    enum HarnessError: Error, Equatable {
        case animationLoad(String)
        case unknownField(String)
        case missingOutput
    }
}

// MARK: - The slice

extension PmoveSlice {
    /// The fixture folder under `Oracle/fixtures/`, which also holds the `animation.cfg` of the slice.
    var folder: String {
        switch self {
        case .melee:
            return "pmove"
        }
    }

    /// The weapon of the baseline and of every user command.
    var weapon: Int32 {
        switch self {
        case .melee:
            return WP_MELEE
        }
    }
}

// MARK: - The state of one scenario

extension PmoveHarness {
    /// This gives `bg`, `world`, `rng`, and the test world their first values, and installs the game's bg channel.
    /// The dumper runs one process for each scenario, so each scenario starts from a fresh state.
    /// The game's channel reads the zeroed `g_entities` of the fresh `GameWorld`, as Raven's game code reads the dumper's zeroed array.
    /// The harness then puts its own file stub and `trap_SnapVector` over the engine traps, as the dumper does.
    /// Every other engine trap stays the game's, and it traps with no transport, as the dumper's `abort()` stubs do.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:114
    static func install(_ slice: PmoveSlice) {
        bg = BgState(consumer: .game, maxPoolSize: 3_000_000)
        JKAMP_GameLogic.world = GameWorld()
        rng = Rng()
        Self.world = PmoveWorld()
        installBgChannel()

        let files = FixtureFiles(folder: slice.folder)
        bg.straps.trap_FS_FOpenFile = { qpath, handle, mode in
            files.open(qpath, &handle, reading: mode == FS_READ)
        }
        bg.straps.trap_FS_Read = { buffer, length, handle in
            files.read(UnsafeMutableRawPointer(buffer), length, handle)
        }
        bg.straps.trap_FS_FCloseFile = { handle in
            files.close(handle)
        }
        // The dumper pins `trap_SnapVector` to `rintf`, which rounds to the nearest value and a tie to the even value.
        bg.straps.trap_SnapVector = { v in
            v = v.rounded(.toNearestOrEven)
        }
        // The dumper's `Com_Printf` writes to standard error, and the standard output carries only the rebuilt text.
        bg.print = { _ in }
    }

    /// This allocates one zeroed C block of `count` bytes, as the dumper's `memset` and its zeroed globals give.
    static func zeroed(_ count: Int) -> UnsafeMutableRawPointer {
        let base = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: 16)
        base.initializeMemory(as: UInt8.self, repeating: 0, count: count)
        return base
    }
}

// MARK: - The ps baseline

extension PmoveHarness {
    /// This writes the pins of the baseline over a zeroed `playerState_t`.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:273
    static func baseline(_ ps: JKAMP.PlayerState, _ slice: PmoveSlice) {
        ps.pm_type = PM_NORMAL
        ps.weapon = slice.weapon
        ps.weaponstate = WEAPON_READY
        ps.stats[Int(STAT_HEALTH)] = 100
        ps.gravity = 800
        ps.speed = 250.0
        ps.basespeed = 250
        ps.standheight = Int32(DEFAULT_MAXS_2) // 40
        ps.crouchheight = Int32(CROUCH_MAXS_2) // 16
        ps.viewheight = Int32(DEFAULT_VIEWHEIGHT)
        ps.groundEntityNum = Int32(ENTITYNUM_NONE)
        ps.clientNum = 0
        ps.m_iVehicleNum = 0
        ps.commandTime = 0
        ps.legsAnim = 0
        ps.torsoAnim = 0
    }

    /// This applies one `ps` row, the field name and its values, through the override table of the dumper.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:235
    static func applyOverride(_ ps: JKAMP.PlayerState, _ tok: [String], _ slice: PmoveSlice) throws {
        let values = tok.dropFirst().map { Substring($0) }
        func float(_ i: Int) -> Float { PmoveFixture.parseFloat(values[values.startIndex + i]) }
        func int(_ i: Int) -> Int32 { PmoveFixture.parseInt(values[values.startIndex + i]) }
        func vector() -> vec3_t { vec3_t(float(0), float(1), float(2)) }

        switch tok[0] {
        case "origin":
            ps.origin = vector()

        case "velocity":
            ps.velocity = vector()

        case "viewangles":
            ps.viewangles = vector()

        case "delta_angles":
            ps.delta_angles[0] = int(0)
            ps.delta_angles[1] = int(1)
            ps.delta_angles[2] = int(2)

        case "groundEntityNum":
            ps.groundEntityNum = int(0)

        case "pm_flags":
            ps.pm_flags = int(0)

        case "pm_type":
            ps.pm_type = int(0)

        case "legsAnim":
            ps.legsAnim = int(0)

        case "torsoAnim":
            ps.torsoAnim = int(0)

        case "weapon":
            ps.weapon = int(0)

        case "gravity":
            ps.gravity = int(0)

        case "speed":
            ps.speed = float(0)

        case "basespeed":
            ps.basespeed = int(0)

        case "fallingToDeath":
            ps.fallingToDeath = int(0)

        case "clientNum":
            ps.clientNum = int(0)

        default:
            // The dumper ends with an error at a name that is not in its table.
            throw HarnessError.unknownField(tok[0])
        }
    }
}

// MARK: - The step loop

extension PmoveHarness {
    /// This runs one scenario and returns its section of the golden, from the `-- scenario` banner to `== end ==`.
    /// `dump` writes one step line from the step number and the `pmove_t`, and the world and `rng` give the two tripwires.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:322
    static func run(_ slice: PmoveSlice, scenario name: String, dump: (Int32, JKAMP.Pmove) -> String) throws -> String {
        Self.install(slice)

        // Load the anim set before the fixture, as the dumper does.
        guard BG_ParseAnimationFile(Self.animationPath, bgHumanoidAnimations, true) != -1 else {
            throw HarnessError.animationLoad(slice.folder)
        }

        let rows = try PmoveFixture.rows(OracleData.fixture("\(slice.folder)/\(name).txt"))

        // The zeroed `playerState_t` and `pmove_t` of the dumper, and entity 0 of the zeroed `g_entities`.
        let psBlock = Self.zeroed(JKAMP.PlayerState.byteCount)
        let moveBlock = Self.zeroed(JKAMP.Pmove.byteCount)
        defer {
            psBlock.deallocate()
            moveBlock.deallocate()
        }
        let ps = JKAMP.PlayerState(handle: OpaquePointer(psBlock))
        let move = JKAMP.Pmove(handle: OpaquePointer(moveBlock))
        let entity = g_entities[0]

        Self.baseline(ps, slice)

        // Set up the `pmove_t`, and each `cmd` row writes the command fields.
        move.ps = ps
        move.trace = { results, start, mins, maxs, end, _, _ in
            let r = PmoveHarness.world.trace(
                PmoveHarness.vector(start),
                PmoveHarness.vector(mins),
                PmoveHarness.vector(maxs),
                PmoveHarness.vector(end)
            )
            PmoveHarness.write(r, to: JKAMP.Trace(handle: results!))
        }
        move.pointcontents = { point, _ in
            PmoveHarness.world.pointContents(PmoveHarness.vector(point))
        }
        move.tracemask = Int32(MASK_PLAYERSOLID)
        move.animations = bgHumanoidAnimations[0]
        move.baseEnt = JKAMP.BgEntity(handle: entity.handle)
        move.entSize = Int32(Entity.byteCount)
        move.gametype = 0

        var out = "-- scenario \(name) --\n"
        out += "== pmove ==\n"

        var step: Int32 = 0
        var prevServerTime: Int32 = 0

        for row in rows {
            switch row {
            case .brush(let brush):
                Self.world.add(brush)

            case .ps(let tok):
                try Self.applyOverride(ps, tok, slice)

            case .start:
                // Freeze the anim mirror to the first ps values, and dump step 0, the state before any move.
                Self.mirror(ps, entity)
                entity.s.number = 0
                entity.s.eType = ET_GENERAL
                Self.world.traceCount = 0
                out += dump(step, move)
                step += 1

            case .cmd(let c):
                var r: Int32 = 0
                while r < c.repeats {
                    let cmd = move.cmd
                    cmd.forwardmove = c.forward
                    cmd.rightmove = c.right
                    cmd.upmove = c.up
                    cmd.buttons = c.buttons
                    cmd.weapon = slice.weapon
                    // The dumper casts each angle to `short`.
                    cmd.angles[0] = Int32(Int16(truncatingIfNeeded: c.pitch))
                    cmd.angles[1] = Int32(Int16(truncatingIfNeeded: c.yaw &+ r &* c.yawStep))
                    cmd.angles[2] = Int32(Int16(truncatingIfNeeded: c.roll))
                    prevServerTime &+= c.dt
                    cmd.serverTime = prevServerTime

                    Self.world.traceCount = 0
                    Pmove(move)

                    // Copy the ps anims to entity 0 for the restart check of the next step, as `BG_PlayerStateToEntityState` does.
                    Self.mirror(ps, entity)

                    out += dump(step, move)
                    step += 1
                    r += 1
                }
            }
        }

        out += "== end ==\n"
        return out
    }

    /// This copies the legs and torso anims of the ps to entity 0, where the restart check of `BG_StartLegsAnim` reads them.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:412
    static func mirror(_ ps: JKAMP.PlayerState, _ entity: Entity) {
        entity.s.legsAnim = ps.legsAnim
        entity.s.torsoAnim = ps.torsoAnim
    }

    /// This reads three floats from a `vec3_t` pointer of the C trace function.
    static func vector(_ pointer: OpaquePointer?) -> vec3_t {
        let p = UnsafePointer<Float>(pointer!)
        return vec3_t(p[0], p[1], p[2])
    }

    /// This writes a world trace over a whole `trace_t`, as the dumper's `*results = tr` does.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:217
    static func write(_ r: PmoveTraceResult, to trace: JKAMP.Trace) {
        trace.clear()
        trace.allsolid = r.allsolid
        trace.startsolid = r.startsolid
        trace.fraction = r.fraction
        trace.endpos = r.endpos
        trace.plane.normal = r.normal
        trace.plane.dist = r.dist
        trace.plane.type = r.type
        trace.plane.signbits = r.signbits
        trace.surfaceFlags = r.surfaceFlags
        trace.contents = r.contents
        trace.entityNum = r.entityNum
    }
}

// MARK: - The child process

extension PmoveHarness {
    /// This runs every scenario of a slice in order, and writes the whole text between the two markers on the standard output.
    /// The exit test calls this in its child process.
    static func emit(_ slice: PmoveSlice, scenarios: [String], dump: (Int32, JKAMP.Pmove) -> String) throws {
        var text = ""
        for name in scenarios {
            text += try Self.run(slice, scenario: name, dump: dump)
        }
        FileHandle.standardOutput.write(Data((Self.beginMarker + text + Self.endMarker).utf8))
    }

    /// This takes the rebuilt text from the standard output of the child process.
    static func extract(_ output: [UInt8]) throws -> String {
        let text = String(decoding: output, as: UTF8.self)
        guard let begin = text.range(of: Self.beginMarker),
              let end = text.range(of: Self.endMarker, range: begin.upperBound ..< text.endIndex) else {
            throw HarnessError.missingOutput
        }
        return String(text[begin.upperBound ..< end.lowerBound])
    }
}
