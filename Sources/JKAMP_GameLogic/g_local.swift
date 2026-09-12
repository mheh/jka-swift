import JKAMP_Game

/// All state of the game module, rule 3. One instance exists behind `world`, and a test assigns a fresh one.
final class GameWorld {
    let memory = GameMemory()
    let storage = GameStorage()
    let strings = StringPool()

    /// Raven's `static unsigned long holdrand` of `q_math.c`, which the game module owns one copy of.
    /// Source: oracle/codemp/game/q_math.c:1432
    var rng = Rng()
}

/// The one instance. `vmMain` has no context argument and the engine calls the module from one thread, so this is not isolated.
nonisolated(unsafe) var world = GameWorld()

/// Source: oracle/codemp/game/g_main.c:9
var level: Level { world.memory.level }

/// Source: oracle/codemp/game/g_main.c:27
var g_entities: Slots<Entity> { world.memory.entities }

/// Source: oracle/codemp/game/g_main.c:28
var g_clients: Slots<Client> { world.memory.clients }

/// The string pool of rule 9, the only source of a runtime `char *`.
var strings: StringPool { world.strings }

// MARK: - The holdrand draws of q_math.c

// Raven's five `holdrand` functions read one file-scope seed per compiled module.
// The seed is a stored property of the world under rule 3, and these forwarders keep a ported body reading as Raven wrote it.
// Source: oracle/codemp/game/q_math.c:1434

/// Source: oracle/codemp/game/q_math.c:1434
func Rand_Init(_ seed: Int32) {
    world.rng.Rand_Init(seed)
}

/// Source: oracle/codemp/game/q_math.c:1441
func flrand(_ min: Float, _ max: Float) -> Float {
    world.rng.flrand(min, max)
}

/// Source: oracle/codemp/game/q_math.c:1451
func Q_flrand(_ min: Float, _ max: Float) -> Float {
    world.rng.Q_flrand(min, max)
}

/// Source: oracle/codemp/game/q_math.c:1458
func irand(_ min: Int32, _ max: Int32) -> Int32 {
    world.rng.irand(min, max)
}

/// Source: oracle/codemp/game/q_math.c:1471
func Q_irand(_ value1: Int32, _ value2: Int32) -> Int32 {
    world.rng.Q_irand(value1, value2)
}
