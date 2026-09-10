import JKAMP
import JKAShared

/// Which module linked this bg code. Rule 23.
/// Raven compiled the bg files once per consumer, so this value picks the arm a body takes where Raven wrote `#ifdef QAGAME`.
///
/// - `game`: the game module, `jampgame`.
/// - `cgame`: the client game module.
/// - `ui`: the user interface module.
public enum BgConsumer {
    case game
    case cgame
    case ui
}

/// All state of the bg files, rule 3. One instance exists behind `bg`, and a test assigns a fresh one.
/// The game module and cgame each link this code with their own instance, so nothing here reaches `world`.
public final class BgState {
    // MARK: - State

    /// The game module installs its own `Com_Error` at `dllEntry`.
    /// The default ends the process with Raven's text, as the engine would.
    public var error: (Int32, String) -> Never = { level, text in
        fatalError("Com_Error(\(level)): \(text)")
    }

    /// The game module installs its own `Com_Printf` at `dllEntry`.
    /// The default writes the text to standard output.
    public var print: (String) -> Void = { text in
        Swift.print(text, terminator: "")
    }

    /// The `strap_` functions of `bg_strap.h`, which the consumer installs over its own traps at its entry point.
    /// Rule 23 puts that install in one call at the entry point, `dllEntry` for the game.
    public var straps = BgStraps()

    /// The game functions a bg body calls by name, which the consumer installs at its entry point.
    /// Rule 23 puts that install in one call at the entry point, `dllEntry` for the game.
    public var callbacks = BgCallbacks()

    /// The module that linked this bg code, which a body reads where Raven wrote `#ifdef QAGAME`.
    public let consumer: BgConsumer

    /// Raven's `MAX_POOL_SIZE`, which is 3000000 for the game, 2048000 for cgame, and 512000 for the user interface.
    public let maxPoolSize: Int32

    /// Raven's `static char bg_pool[MAX_POOL_SIZE]` of `bg_misc.c`.
    /// The block is never freed, and it lives as long as the module.
    public let pool: UnsafeMutableRawPointer

    /// A view over the game's own memory for Raven's `bg_fighterAltControl` cvar, which the game installs at its entry point.
    /// The default is a view over one zeroed `vmCvar_t` this state owns, so `.integer` reads 0, which is Raven's default for the cvar.
    public var fighterAltControl: VmCvar

    /// `Com_Error` records the raised error here before the trap.
    /// A test transport reads what was raised.
    var lastErrorLevel: Int32 = 0
    var lastErrorText: String = ""

    // A transcriptor adds each Raven static of a bg_*.c file here, with Raven's name and a /// Source: line.

    // MARK: - bg_misc.c

    /// Raven's `static int bg_poolSize` of `bg_misc.c`.
    /// Source: oracle/codemp/game/bg_misc.c:3325
    var poolSize: Int32 = 0

    /// Raven's `static int bg_poolTail` of `bg_misc.c`, initialized to `MAX_POOL_SIZE`.
    /// Source: oracle/codemp/game/bg_misc.c:3326
    var poolTail: Int32

    // MARK: - bg_pmove.c

    /// Source: oracle/codemp/game/bg_pmove.c:161
    var forceJumpStrength: [Float] = [
        Float(JUMP_VELOCITY), //normal jump
        420,
        590,
        840,
    ]

    /// The defaults are the game's, so a test builds a state with no argument.
    public init(consumer: BgConsumer = .game, maxPoolSize: Int32 = 3_000_000) {
        self.consumer = consumer
        self.maxPoolSize = maxPoolSize
        self.poolTail = maxPoolSize
        self.pool = UnsafeMutableRawPointer.allocate(byteCount: Int(maxPoolSize), alignment: 16)

        let cvarStorage = UnsafeMutableRawPointer.allocate(byteCount: VmCvar.byteCount, alignment: 4)
        cvarStorage.initializeMemory(as: UInt8.self, repeating: 0, count: VmCvar.byteCount)
        self.fighterAltControl = VmCvar(handle: OpaquePointer(cvarStorage))
    }
}

/// The one instance. The engine calls the module from one thread, so this is not isolated.
public nonisolated(unsafe) var bg = BgState()

/// This is Raven's `Com_Error` as the bg files call it.
/// The module supplies the route through `bg.error`.
/// Source: oracle/codemp/game/g_main.c:1208
func Com_Error(_ level: Int32, _ text: String) -> Never {
    bg.lastErrorLevel = level
    bg.lastErrorText = text
    bg.error(level, text)
}

/// This is Raven's `Com_Printf` as the bg files call it.
/// The module supplies the route through `bg.print`.
/// Source: oracle/codemp/game/g_main.c:1219
func Com_Printf(_ text: String) {
    bg.print(text)
}

/// A body reads Raven's `MAX_POOL_SIZE`, and the value comes from the installed state.
var MAX_POOL_SIZE: Int32 { bg.maxPoolSize }

/// A body reads Raven's `bg_fighterAltControl`, and the view comes from the installed state.
var bg_fighterAltControl: VmCvar { bg.fighterAltControl }
