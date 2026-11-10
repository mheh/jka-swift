internal import CJKAMP_Ded
import JKAMP
import JKAShared

// MARK: - The words of a game system call

extension Slots where Element == Int32 {
    /// Raven's `int *args` of `SV_GameSystemCalls`, over the `intptr_t` words that `VM_DllSyscall` of `jka_host.c` gathers from the module.
    /// A read gives the low `int` of the word, and `VMA` reads the whole word.
    /// Source: oracle/codemp/server/sv_game.cpp:458
    // AI: Raven read each word as an int, which holds a pointer only on a 32-bit build.
    // The Slots steps over the intptr_t words and reads the low int of each, the conversion C makes.
    public init(syscallWords base: UnsafeMutableRawPointer, count: Int) {
        self.init(
            base: base,
            count: count,
            stride: MemoryLayout<Int>.stride,
            read: { Int32(truncatingIfNeeded: $0.load(as: Int.self)) },
            write: { $0.storeBytes(of: Int($1), as: Int.self) }
        )
    }

    /// The whole word at slot `x`, the pointer that Raven's `VM_ArgPtr` gives a module library.
    private func word(_ x: Int32) -> UnsafeMutableRawPointer? {
        precondition(x >= 0 && Int(x) < self.count, "Syscall word \(x) is out of the range 0..<\(self.count)")
        return UnsafeMutableRawPointer(bitPattern: self.base.load(fromByteOffset: Int(x) * self.stride, as: Int.self))
    }

    /// Raven's `VMA(x)` handed on as a `void *`, `Com_Memset( VMA(1), args[2], args[3] )`.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and the word stays an opaque handle.
    public func VMA(_ x: Int32) -> OpaquePointer? {
        self.word(x).map { OpaquePointer($0) }
    }

    /// Raven's `(int)VMA(x)`, the address at the word as a number, the return of TRAP_STRNCPY.
    /// Source: oracle/codemp/server/sv_game.cpp:471
    // AI: Raven casts the address to `int`, which holds an address only on a 32-bit build. The accessor gives the whole word.
    public func VMA(_ x: Int32) -> Int {
        Int(bitPattern: self.word(x))
    }

    /// Raven's `(const char *)VMA(x)`, the text at the word.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it reads the text at the word.
    public func VMA(_ x: Int32) -> String {
        cString(at: self.word(x)!)
    }

    /// Raven's `(T *)VMA(x)` of a record, the view at the word, and nil for Raven's NULL.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it gives the view over the record at the word.
    public func VMA<V: HandleView>(_ x: Int32) -> V? {
        self.word(x).map { V(handle: OpaquePointer($0)) }
    }

    /// Raven's `(const float *)VMA(x)` of one vector that the callee reads.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it reads the three floats at the word.
    public func VMA(_ x: Int32) -> JKAShared.vec3_t {
        Slots<JKAShared.vec3_t>(vectors: self.word(x)!, count: 1)[0]
    }

    /// Raven's `(const float *)VMA(x)` of a vector that the module can pass as NULL, nil for Raven's NULL.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it reads the vector or gives nil.
    public func VMA(_ x: Int32) -> JKAShared.vec3_t? {
        self.word(x).map { Slots<JKAShared.vec3_t>(vectors: $0, count: 1)[0] }
    }

    /// Raven's `(void **)VMA(x)`, the module's pointer slot that the engine sets, a Slots of count 1.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it gives the pointer slot at the word.
    public func VMA(_ x: Int32) -> Slots<OpaquePointer?> {
        Slots<OpaquePointer?>(opaque: self.word(x)!, count: 1)
    }

    /// Raven's `(float *)VMA(x)` of a vector array that the callee writes, a Slots of Raven's 12-byte vectors.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it gives the vectors at the word.
    public func VMA(_ x: Int32) -> Slots<JKAShared.vec3_t> {
        Slots<JKAShared.vec3_t>(vectors: self.word(x)!, count: Int.max / 12)
    }

    /// Raven's `(char *)VMA(x)` of a buffer that the engine fills, the bytes at the word with the widest count.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it gives the bytes at the word.
    public func VMA(_ x: Int32) -> Slots<byte> {
        Slots<byte>(scalars: self.word(x)!, count: Int.max)
    }

    /// Raven's `(int *)VMA(x)` of an `int` array, the words at the word with the widest count.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it gives the ints at the word.
    public func VMA(_ x: Int32) -> Slots<Int32> {
        Slots<Int32>(scalars: self.word(x)!, count: Int.max / 4)
    }

    /// Raven's `(float *)VMA(x)` of a float that the callee writes, the floats at the word with the widest count.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it gives the floats at the word.
    public func VMA(_ x: Int32) -> Slots<Float> {
        Slots<Float>(scalars: self.word(x)!, count: Int.max / 4)
    }

    /// Raven's `(T **)VMA(x)` of a table of record pointers, the pointer slots at the word with the widest count.
    /// Source: oracle/codemp/server/sv_game.cpp:403
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it gives the record pointers at the word.
    public func VMA<V: HandleView>(_ x: Int32) -> Slots<V?> {
        Slots<V?>(pointers: self.word(x)!, count: Int.max / MemoryLayout<Int>.stride)
    }

    /// Raven's `(T *)VMA(x)` of a record array that the callee indexes and writes, `(CollisionRecord_t*)VMA(1)`, the records at the word with the widest count.
    /// Source: oracle/codemp/server/sv_game.cpp:1415
    // AI: Raven's macro reads the local `args` of the switch. The accessor is a method of `args`, and it gives the records at the word.
    public func VMA<V: HandleView>(_ x: Int32) -> Slots<V> {
        Slots<V>(views: self.word(x)!, count: Int.max / V.stride, stride: V.stride)
    }

    /// Raven's `VMF(x)`, `((float *)args)[x]`, the float whose bits `PASSFLOAT` put in the low half of the word.
    /// Source: oracle/codemp/server/sv_game.cpp:406
    // AI: Raven's macro reads the local `args` of the switch as floats. The accessor is a method of `args`, and it reads the low int as float bits.
    public func VMF(_ x: Int32) -> Float {
        Float(bitPattern: UInt32(bitPattern: self[Int(x)]))
    }
}

// MARK: - The game memory of the server

extension Server {
    /// Raven's `(sharedEntity_t *)((byte *)sv.gentities + sv.gentitySize*(num))`, the entities of the game with the stride the game gave.
    /// The game allocates its entities past the shared part, so the stride is `sv.gentitySize` and not the size of `sharedEntity_t`.
    /// Source: oracle/codemp/server/sv_game.cpp:57
    // AI: Raven steps a byte pointer by the size the game gave. The accessor gives a Slots with that stride and the widest count.
    public var gentitiesSlots: Slots<SharedEntity> {
        precondition(self.raw.pointee.gentities != nil, "gentities is NULL")
        return Slots(views: UnsafeMutableRawPointer(self.raw.pointee.gentities!), count: Int(Int32.max), stride: Int(self.gentitySize))
    }

    /// Raven's `(playerState_t *)((byte *)sv.gameClients + sv.gameClientSize*(num))`, the player states of the game with the stride the game gave.
    /// Source: oracle/codemp/server/sv_game.cpp:65
    // AI: Raven steps a byte pointer by the size the game gave. The accessor gives a Slots with that stride and the widest count.
    public var gameClientsSlots: Slots<PlayerState> {
        precondition(self.raw.pointee.gameClients != nil, "gameClients is NULL")
        return Slots(views: UnsafeMutableRawPointer(self.raw.pointee.gameClients!), count: Int(Int32.max), stride: Int(self.gameClientSize))
    }

    /// Raven's `(const char **)&sv.entityParsePoint` handed to `COM_Parse`, the entity text from the pointer as a cursor.
    /// The setter moves the C pointer by the bytes the cursor read, or sets it NULL when the cursor is NULL.
    /// Source: oracle/codemp/server/sv_game.cpp:343
    // AI: Raven walks the `char *` field in place.
    // The accessor reads the text from the pointer as a cursor, and the setter moves the pointer by the cursor offset.
    public var entityParsePointCursor: TextCursor {
        get { Server.cursor(at: self.raw.pointee.entityParsePoint) }
        nonmutating set { self.raw.pointee.entityParsePoint = Server.moved(self.raw.pointee.entityParsePoint, by: newValue) }
    }

    /// Raven's `(const char **)&sv.mLocalSubBSPEntityParsePoint` handed to `COM_Parse`, in the form of `entityParsePointCursor`.
    /// Source: oracle/codemp/server/sv_game.cpp:356
    // AI: Raven walks the `char *` field in place.
    // The accessor reads the text from the pointer as a cursor, and the setter moves the pointer by the cursor offset.
    public var mLocalSubBSPEntityParsePointCursor: TextCursor {
        get { Server.cursor(at: self.raw.pointee.mLocalSubBSPEntityParsePoint) }
        nonmutating set { self.raw.pointee.mLocalSubBSPEntityParsePoint = Server.moved(self.raw.pointee.mLocalSubBSPEntityParsePoint, by: newValue) }
    }

    /// Raven's `sv.mSharedMemory`, the `char *` field that holds the address of the game's shared buffer, as the bytes at that address.
    /// The bytes have the widest count, the form of a `bytes` field such as `Msg.data`.
    /// Source: oracle/codemp/server/sv_game.cpp:939
    // AI: Raven stores the module's buffer address in a `char *` field.
    // The accessor stores and reads the address as a Slots of bytes, so no text copy goes into the pool.
    public var mSharedMemoryBytes: Slots<byte>? {
        get { self.raw.pointee.mSharedMemory.map { Slots(scalars: UnsafeMutableRawPointer($0), count: Int.max) } }
        nonmutating set { self.raw.pointee.mSharedMemory = newValue?.base.assumingMemoryBound(to: CChar.self) }
    }

    /// The text at a `char *` as a cursor at offset 0, or the NULL cursor.
    private static func cursor(at pointer: UnsafeMutablePointer<CChar>?) -> TextCursor {
        guard let pointer else { return TextCursor() }
        return TextCursor(CharBuf(cString(at: pointer)))
    }

    /// The `char *` moved by the bytes that a cursor from `cursor(at:)` read, or NULL for the NULL cursor.
    private static func moved(_ pointer: UnsafeMutablePointer<CChar>?, by cursor: TextCursor) -> UnsafeMutablePointer<CChar>? {
        guard let pointer, let offset = cursor.offset else { return nil }
        return pointer + Int(offset)
    }
}

// MARK: - The module's word of a Ghoul2 instance

extension Array {
    /// Raven's `new CGhoul2Info_v`, the instance in the first free slot of the host table, or in a new slot at the end.
    /// The module names the instance by its word, the slot number plus 1, so 0 stays NULL.
    /// Source: oracle/codemp/ghoul2/G2_API.cpp:616
    // AI: Raven hands the module the address of the instance. The table holds the instance, and the word is its slot number plus 1, row Z6 of docket 10.
    public mutating func takeSlot<T: AnyObject>(_ instance: T) where Element == T? {
        if let free = self.firstIndex(where: { $0 == nil }) {
            self[free] = instance
        } else {
            self.append(instance)
        }
    }

    /// Raven's `delete` of a `CGhoul2Info_v`, the slot of the instance back to nil, so the last reference drops and the deinit runs.
    /// Source: oracle/codemp/ghoul2/G2_API.cpp:563
    // AI: Raven deletes the instance. The table drops its reference, row Z6 of docket 10.
    public mutating func freeSlot<T: AnyObject>(_ instance: T) where Element == T? {
        if let slot = self.firstIndex(where: { $0 === instance }) {
            self[slot] = nil
        }
    }

    /// Raven's `*((CGhoul2Info_v *)args[1])`, the instance that a module's word names, and nil for NULL.
    /// Source: oracle/codemp/server/sv_game.cpp:1325
    // AI: Raven reads the word as the address of the instance. The word is the slot number plus 1 in the host table, row Z6 of docket 10.
    public func instance<T: AnyObject>(word: OpaquePointer?) -> T? where Element == T? {
        let slot = Int(bitPattern: word)
        precondition(slot >= 0 && slot <= self.count, "Ghoul2 word \(slot) names no slot of the table")
        return slot == 0 ? nil : self[slot - 1]
    }

    /// Raven's `*ghoul2Ptr` written back to the module, the word of an instance of the table, and NULL for nil.
    /// Source: oracle/codemp/server/sv_game.cpp:1340
    // AI: Raven's callee writes the address of the instance into the module's slot. The word is the slot number plus 1 in the host table, row Z6 of docket 10.
    public func word<T: AnyObject>(of instance: T?) -> OpaquePointer? where Element == T? {
        guard let instance, let slot = self.firstIndex(where: { $0 === instance }) else { return nil }
        return OpaquePointer(bitPattern: slot + 1)
    }
}
