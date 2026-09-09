// PROTOTYPE, throwaway. This file is the liftable half: the world, the views, and Raven's globals.
//
// The question: can a `final class GameWorld` own Raven's tables as C memory with Raven's stride,
// while Swift reaches them through pointer-backed view structs, Raven's global names as computed properties,
// and bare functions that keep Raven's spellings?
// The cases that are hard to judge on paper: a write through a get-only subscript, two entity views in one call,
// a C function pointer field that holds a Swift function, a `char *` field behind a string pool, and pointer fields as `Entity?`.
//
// This target is the only one that imports CJKAMP, and it does so with `internal import`.
// g_local.h declares every Raven function, so a target that imports it cannot define a bare `G_Spawn` of its own.

internal import CJKAMP

/// The C shape of a think function. The pointer is the entity's slot, and `Entity(handle:)` makes the view from it.
public typealias ThinkFunction = @convention(c) (OpaquePointer?) -> Void

// MARK: - The world

/// The one owner of module state. Raven's tables live in C memory here, with Raven's stride, so `LocateGameData` can hand them to the engine.
public final class GameWorld {
    let entityStorage: UnsafeMutablePointer<gentity_t>
    let levelStorage: UnsafeMutablePointer<level_locals_t>
    /// The pool that `char *` fields point into. Raven's `G_NewString` allocates from level memory the same way.
    public var stringPool: [UnsafeMutablePointer<CChar>] = []
    /// The names of the Swift functions stored in C function pointer fields, so the frame can show them.
    public var thinkNames: [UnsafeRawPointer: String] = [:]

    /// The stride `LocateGameData` reports to the engine.
    public static let entityStride = MemoryLayout<gentity_t>.stride
    public static let levelSize = MemoryLayout<level_locals_t>.size
    public static let maxEntities = Int(MAX_GENTITIES)
    public static let maxClients = Int(MAX_CLIENTS)

    init() {
        self.entityStorage = .allocate(capacity: Int(MAX_GENTITIES))
        self.entityStorage.initialize(repeating: gentity_t(), count: Int(MAX_GENTITIES))
        self.levelStorage = .allocate(capacity: 1)
        self.levelStorage.initialize(to: level_locals_t())
        for index in 0..<Int(MAX_GENTITIES) {
            self.entityStorage[index].s.number = Int32(index)
        }
    }

    public var g_entities: EntityTable { EntityTable(base: self.entityStorage) }
    public var level: Level { Level(raw: self.levelStorage) }

    /// The port of `G_NewString`, without the backslash handling, because the pool is the question here and not the escape.
    /// Source: oracle/codemp/game/g_spawn.c:724
    public func G_NewString(_ string: String) -> UnsafeMutablePointer<CChar> {
        let copy = strdup(string)!
        self.stringPool.append(copy)
        return copy
    }
}

// MARK: - Raven's globals

/// The one instance. `vmMain` has no context argument, and the engine calls the module from one thread.
nonisolated(unsafe) public let world = GameWorld()

public var level: Level { world.level }
public var g_entities: EntityTable { world.g_entities }

// MARK: - The views

/// One entity, as a view over its slot in the C table. Copying the view copies the pointer, not the entity.
public struct Entity: Equatable {
    let raw: UnsafeMutablePointer<gentity_t>

    /// The slot as an opaque handle, for the C function pointer boundary.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }
    init(raw: UnsafeMutablePointer<gentity_t>) { self.raw = raw }

    public var number: Int32 { self.raw.pointee.s.number }

    public var inuse: Bool {
        get { self.raw.pointee.inuse != qfalse }
        nonmutating set { self.raw.pointee.inuse = newValue ? qtrue : qfalse }
    }
    public var health: Int32 {
        get { self.raw.pointee.health }
        nonmutating set { self.raw.pointee.health = newValue }
    }
    public var nextthink: Int32 {
        get { self.raw.pointee.nextthink }
        nonmutating set { self.raw.pointee.nextthink = newValue }
    }
    public var origin: SIMD3<Float> {
        get { SIMD3(self.raw.pointee.s.origin.0, self.raw.pointee.s.origin.1, self.raw.pointee.s.origin.2) }
        nonmutating set { self.raw.pointee.s.origin = (newValue.x, newValue.y, newValue.z) }
    }
    public var enemy: Entity? {
        get { self.raw.pointee.enemy.map { Entity(raw: $0) } }
        nonmutating set { self.raw.pointee.enemy = newValue?.raw }
    }
    /// The C field holds a pointer into the world's string pool. The setter allocates from the pool.
    public var classname: String? {
        get { self.raw.pointee.classname.map { String(cString: $0) } }
        nonmutating set { self.raw.pointee.classname = newValue.map { world.G_NewString($0) } }
    }
    /// The C function pointer field. A capture-free Swift function with the `ThinkFunction` shape converts to it at the assignment.
    public var think: ThinkFunction? {
        get { unsafeBitCast(self.raw.pointee.think, to: ThinkFunction?.self) }
        nonmutating set { self.raw.pointee.think = unsafeBitCast(newValue, to: type(of: self.raw.pointee.think)) }
    }

    public static func == (lhs: Entity, rhs: Entity) -> Bool { lhs.raw == rhs.raw }
}

/// The entity table the engine shares. Raven's `g_entities`, with Raven's stride.
public struct EntityTable: RandomAccessCollection {
    let base: UnsafeMutablePointer<gentity_t>
    public var startIndex: Int { 0 }
    public var endIndex: Int { Int(MAX_GENTITIES) }
    public subscript(index: Int) -> Entity { Entity(raw: self.base + index) }
}

/// Raven's `level`, as a view over the C struct.
public struct Level {
    let raw: UnsafeMutablePointer<level_locals_t>

    public var time: Int32 {
        get { self.raw.pointee.time }
        nonmutating set { self.raw.pointee.time = newValue }
    }
    public var framenum: Int32 {
        get { self.raw.pointee.framenum }
        nonmutating set { self.raw.pointee.framenum = newValue }
    }
    public var num_entities: Int32 {
        get { self.raw.pointee.num_entities }
        nonmutating set { self.raw.pointee.num_entities = newValue }
    }
}
