internal import CJKAMP_Game

/// The C memory of the game module: the entity table, the client table, and the level record. Rule 3 and struct-views.md row 5.
/// The three blocks are zeroed as Raven's statics were, they are freed in `deinit`, and this is the only place a table is allocated.
public final class GameMemory {
    // MARK: - State

    private let entityStorage: UnsafeMutablePointer<gentity_t>
    private let clientStorage: UnsafeMutablePointer<gclient_t>
    private let levelStorage: UnsafeMutablePointer<level_locals_t>

    // The counts are qualified, because the C import declares the same macro names.
    private let entityCount = Int(JKAShared.MAX_GENTITIES)
    private let clientCount = Int(JKAMP.MAX_CLIENTS)

    /// The entity table, with Raven's stride, so a slot address is the pointer Raven's `g_entities + i` gave.
    public var entities: Slots<Entity> {
        Slots(
            views: UnsafeMutableRawPointer(self.entityStorage),
            count: self.entityCount,
            stride: MemoryLayout<gentity_t>.stride
        )
    }

    /// The client table, with Raven's stride.
    public var clients: Slots<Client> {
        Slots(
            views: UnsafeMutableRawPointer(self.clientStorage),
            count: self.clientCount,
            stride: MemoryLayout<gclient_t>.stride
        )
    }

    /// The one `level_locals_t` record.
    public var level: Level { Level(raw: self.levelStorage) }

    public init() {
        self.entityStorage = UnsafeMutablePointer<gentity_t>.allocate(capacity: Int(JKAShared.MAX_GENTITIES))
        self.clientStorage = UnsafeMutablePointer<gclient_t>.allocate(capacity: Int(JKAMP.MAX_CLIENTS))
        self.levelStorage = UnsafeMutablePointer<level_locals_t>.allocate(capacity: 1)
        self.entityStorage.initialize(repeating: gentity_t(), count: Int(JKAShared.MAX_GENTITIES))
        self.clientStorage.initialize(repeating: gclient_t(), count: Int(JKAMP.MAX_CLIENTS))
        self.levelStorage.initialize(to: level_locals_t())
    }

    deinit {
        self.entityStorage.deinitialize(count: self.entityCount)
        self.entityStorage.deallocate()
        self.clientStorage.deinitialize(count: self.clientCount)
        self.clientStorage.deallocate()
        self.levelStorage.deinitialize(count: 1)
        self.levelStorage.deallocate()
    }
}
