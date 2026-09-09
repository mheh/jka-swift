/// A view over one C record, reached through the record's address as an opaque handle.
/// Every generated view conforms, so a generic helper can build a view from a slot address. Rule 11 keeps the handle in generated code.
public protocol HandleView: Hashable {
    init(handle: OpaquePointer)

    var handle: OpaquePointer { get }
}
