import Testing
@testable import JKAMP_Game

@Test("the entity table reads and writes one slot through its view")
func entitySlotReadsAndWrites() {
    let memory = GameMemory()

    memory.entities[5].health = 3
    memory.entities[5].classname = "bodyque"

    #expect(memory.entities[5].health == 3)
    #expect(memory.entities[5].classname == "bodyque")
    #expect(memory.entities[6].health == 0)
}

@Test("two views of one slot compare equal and two slots do not")
func viewsCompareByslot() {
    let memory = GameMemory()

    #expect(memory.entities[5] == memory.entities[5])
    #expect(memory.entities[5] != memory.entities[6])
}

@Test("an entity pointer field reads back as the view it was set from")
func entityPointerFieldRoundTrips() {
    let memory = GameMemory()

    memory.entities[5].enemy = memory.entities[6]

    #expect(memory.entities[5].enemy == memory.entities[6])
    #expect(memory.entities[7].enemy == nil)
}
