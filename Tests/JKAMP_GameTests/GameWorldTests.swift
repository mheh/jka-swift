import Testing
@testable import JKAMP_GameLogic

/// Each test here assigns a fresh world to the one global, so they run one after the other. Rule 3.
@Suite(.serialized)
struct GameWorldSuite {
    @Test("g_entities reads and writes through the one world")
    func entitiesReadAndWriteThroughWorld() {
        world = GameWorld()

        g_entities[1].classname = "bodyque"
        g_entities[1].enemy = g_entities[2]

        #expect(g_entities[1].classname == "bodyque")
        #expect(g_entities[1].enemy == g_entities[2])
    }

    @Test("level reads back through the world's memory")
    func levelReadsBackThroughWorldMemory() {
        world = GameWorld()

        level.time = 100

        #expect(world.storage.level.time == 100)
    }

    @Test("the string pool interns one pointer per distinct text")
    func stringPoolInternsOnePointerPerText() {
        world = GameWorld()

        #expect(strings.intern("a").raw == strings.intern("a").raw)
    }
}
