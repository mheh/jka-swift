/// Raven's `vec3_t` at every Swift surface.
/// The C module imports its own `vec3_t` as a tuple, so generated code writes this one qualified as `JKAShared.vec3_t`.
public typealias vec3_t = SIMD3<Float>

/// This converts the tuple the C importer gives for `float[3]` into a vector.
public func vec3(of tuple: (Float, Float, Float)) -> vec3_t {
    vec3_t(tuple.0, tuple.1, tuple.2)
}

/// This converts a vector back into the tuple a C `float[3]` field takes.
public func tuple(of vector: vec3_t) -> (Float, Float, Float) {
    (vector.x, vector.y, vector.z)
}
