import JKAMP_Game

/// All state of the game module, rule 3. One instance exists behind `world`, and a test assigns a fresh one.
final class GameWorld {
    let memory = GameMemory()
    let strings = StringPool()
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
