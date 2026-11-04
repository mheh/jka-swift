internal import CJKAMP_Ded
import JKAShared

extension Winding {
    /// Raven's `(int)((winding_t *)0)->p[n]`, the byte offset of point `n`, which is the size of a winding of `n` points.
    /// `CopyWinding` copies that many bytes, because Raven allocates a winding past the four points of its C type.
    /// Source: oracle/codemp/qcommon/cm_polylib.cpp:255
    // AI: Raven takes the address of point n of a null winding pointer. The static gives the byte offset of point n from the offset of `p`.
    public static func byteCount(points n: some BinaryInteger) -> Int {
        MemoryLayout<winding_t>.offset(of: \winding_t.p)! + Int(n) * JKAShared.vec3_t.byteCount
    }
}
