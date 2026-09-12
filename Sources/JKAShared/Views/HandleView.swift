/// A view over one C record, reached through the record's address as an opaque handle.
/// Every generated view conforms, so a generic helper can build a view from a slot address. Rule 11 keeps the handle in generated code.
/// The `SyscallWord` refinement makes every view a word by its handle, so a trap passes a view bare.
public protocol HandleView: Hashable, SyscallWord {
    init(handle: OpaquePointer)

    var handle: OpaquePointer { get }

    /// The size of one slot in bytes, and the distance between two slots of a C array, so a module that cannot see the C type allocates one.
    static var byteCount: Int { get }
    static var stride: Int { get }
}

extension HandleView {
    public var word: Int { Int(bitPattern: self.handle) }
}
