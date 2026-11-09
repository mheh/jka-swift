/// Raven's `sizeof(T)` of a C scalar or a vector in a host body, `s = sizeof(vec_t)*3*points + sizeof(int)` of `AllocWinding`.
/// A body writes `vec_t.byteCount` and `Int32.byteCount`, the form `BitStorage.byteCount` gives a view, and never `MemoryLayout`, under rule 11.
/// Each count is the size of Raven's C type: `vec3_t` is 12 bytes as `float[3]` is, and not the 16 bytes of `SIMD3<Float>`.
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:41
// AI: Raven takes `sizeof` of a C type. The port gives each scalar and vector type a `byteCount` static with the size of the C type.

extension Int8 {
    /// Raven's `sizeof(char)`.
    public static var byteCount: Int { MemoryLayout<Int8>.size }
}

extension UInt8 {
    /// Raven's `sizeof(byte)` and `sizeof(unsigned char)`.
    public static var byteCount: Int { MemoryLayout<UInt8>.size }
}

extension Int16 {
    /// Raven's `sizeof(short)`.
    public static var byteCount: Int { MemoryLayout<Int16>.size }
}

extension UInt16 {
    /// Raven's `sizeof(word)` and `sizeof(unsigned short)`.
    public static var byteCount: Int { MemoryLayout<UInt16>.size }
}

extension Int32 {
    /// Raven's `sizeof(int)`, and the size of every `int` typedef and C enum the port spells `Int32`.
    public static var byteCount: Int { MemoryLayout<Int32>.size }
}

extension UInt32 {
    /// Raven's `sizeof(unsigned int)` and `sizeof(UINT4)`, and `sizeof(ulong)` on a target where `unsigned long` is 4 bytes.
    public static var byteCount: Int { MemoryLayout<UInt32>.size }
}

extension UInt {
    /// Raven's `sizeof(ulong)` on a target where `unsigned long` is 8 bytes.
    public static var byteCount: Int { MemoryLayout<UInt>.size }
}

extension Float {
    /// Raven's `sizeof(float)` and `sizeof(vec_t)`.
    public static var byteCount: Int { MemoryLayout<Float>.size }
}

extension Double {
    /// Raven's `sizeof(double)`.
    public static var byteCount: Int { MemoryLayout<Double>.size }
}

extension SIMD2 where Scalar == Float {
    /// Raven's `sizeof(vec2_t)`, two floats.
    public static var byteCount: Int { 2 * MemoryLayout<Float>.size }
}

extension SIMD3 where Scalar == Float {
    /// Raven's `sizeof(vec3_t)`, three floats.
    public static var byteCount: Int { 3 * MemoryLayout<Float>.size }
}

extension SIMD4 where Scalar == Float {
    /// Raven's `sizeof(vec4_t)`, four floats.
    public static var byteCount: Int { 4 * MemoryLayout<Float>.size }
}

extension OpaquePointer {
    /// Raven's `sizeof(T *)`, the size of one pointer, `sizeof( cm.surfaces[0] )` of `CMod_LoadPatches`.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:498
    public static var byteCount: Int { MemoryLayout<OpaquePointer>.size }
}
