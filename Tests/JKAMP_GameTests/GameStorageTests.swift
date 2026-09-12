import Testing
@testable import JKAMP_Game

@Test("the entity table reads and writes one slot through its view")
func entitySlotReadsAndWrites() {
    let storage = GameStorage()

    storage.g_entities[5].health = 3
    storage.g_entities[5].classname = "bodyque"

    #expect(storage.g_entities[5].health == 3)
    #expect(storage.g_entities[5].classname == "bodyque")
    #expect(storage.g_entities[6].health == 0)
}

@Test("two views of one slot compare equal and two slots do not")
func viewsCompareByslot() {
    let storage = GameStorage()

    #expect(storage.g_entities[5] == storage.g_entities[5])
    #expect(storage.g_entities[5] != storage.g_entities[6])
}

@Test("an entity pointer field reads back as the view it was set from")
func entityPointerFieldRoundTrips() {
    let storage = GameStorage()

    storage.g_entities[5].enemy = storage.g_entities[6]

    #expect(storage.g_entities[5].enemy == storage.g_entities[6])
    #expect(storage.g_entities[7].enemy == nil)
}
