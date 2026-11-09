import JKAShared

// MARK: - Record arrays in a byte buffer

extension Slots where Element: HandleView {
    /// Raven's cast of a byte pointer to a record pointer that a body indexes, `(dshader_t *)(cmod_base + l->fileofs)`.
    /// The records must fit in the bytes, or the initializer traps where C reads past the buffer.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:81
    // AI: Raven casts the bytes of a lump to a record pointer. The initializer gives the Slots over the `count` records at the base of the byte Slots, the cast form of a view.
    public init(_ bytes: Slots<byte>, count: some BinaryInteger) {
        precondition(Int(count) >= 0 && Int(count) * Element.stride <= bytes.count, "The \(count) records run past the \(bytes.count) bytes of the buffer")
        self.init(views: bytes.base, count: Int(count), stride: Element.stride)
    }
}
