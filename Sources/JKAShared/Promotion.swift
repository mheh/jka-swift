/// C promotes an `int` to `float` when the two meet in an expression, and Swift does not.
/// These operators restore that promotion for `Int32` and `Float`, so a ported body reads as Raven wrote it, for example `ps.velocity[2] -= ps.gravity * bg.pml.frametime`.

// MARK: - Arithmetic

/// Each operator promotes the `Int32` operand with `Float(...)`, as C does, and returns a `Float`.
/// `@_disfavoredOverload` keeps a same-type literal expression, such as `count + 1`, on the stdlib's `Int32` operator.
@_disfavoredOverload public func + (lhs: Int32, rhs: Float) -> Float { Float(lhs) + rhs }
@_disfavoredOverload public func + (lhs: Float, rhs: Int32) -> Float { lhs + Float(rhs) }
@_disfavoredOverload public func - (lhs: Int32, rhs: Float) -> Float { Float(lhs) - rhs }
@_disfavoredOverload public func - (lhs: Float, rhs: Int32) -> Float { lhs - Float(rhs) }
@_disfavoredOverload public func * (lhs: Int32, rhs: Float) -> Float { Float(lhs) * rhs }
@_disfavoredOverload public func * (lhs: Float, rhs: Int32) -> Float { lhs * Float(rhs) }
@_disfavoredOverload public func / (lhs: Int32, rhs: Float) -> Float { Float(lhs) / rhs }
@_disfavoredOverload public func / (lhs: Float, rhs: Int32) -> Float { lhs / Float(rhs) }

// MARK: - Comparison

/// Each operator promotes the `Int32` operand with `Float(...)`, as C does, and returns a `Bool`.
/// `@_disfavoredOverload` keeps a same-type literal expression, such as `count < 10`, on the stdlib's `Int32` operator.
@_disfavoredOverload public func < (lhs: Int32, rhs: Float) -> Bool { Float(lhs) < rhs }
@_disfavoredOverload public func < (lhs: Float, rhs: Int32) -> Bool { lhs < Float(rhs) }
@_disfavoredOverload public func <= (lhs: Int32, rhs: Float) -> Bool { Float(lhs) <= rhs }
@_disfavoredOverload public func <= (lhs: Float, rhs: Int32) -> Bool { lhs <= Float(rhs) }
@_disfavoredOverload public func > (lhs: Int32, rhs: Float) -> Bool { Float(lhs) > rhs }
@_disfavoredOverload public func > (lhs: Float, rhs: Int32) -> Bool { lhs > Float(rhs) }
@_disfavoredOverload public func >= (lhs: Int32, rhs: Float) -> Bool { Float(lhs) >= rhs }
@_disfavoredOverload public func >= (lhs: Float, rhs: Int32) -> Bool { lhs >= Float(rhs) }
@_disfavoredOverload public func == (lhs: Int32, rhs: Float) -> Bool { Float(lhs) == rhs }
@_disfavoredOverload public func == (lhs: Float, rhs: Int32) -> Bool { lhs == Float(rhs) }
@_disfavoredOverload public func != (lhs: Int32, rhs: Float) -> Bool { Float(lhs) != rhs }
@_disfavoredOverload public func != (lhs: Float, rhs: Int32) -> Bool { lhs != Float(rhs) }

// MARK: - Compound assignment

/// Each operator takes a `Float` left side and an `Int32` right side, and promotes the right side with `Float(...)`.
/// There is no `Int32` left-side form, since C truncates there and Raven's sites carry an explicit cast.
/// `@_disfavoredOverload` keeps a same-type literal expression, such as `a += 360`, on the stdlib's `Float` operator.
@_disfavoredOverload public func += (lhs: inout Float, rhs: Int32) { lhs = lhs + rhs }
@_disfavoredOverload public func -= (lhs: inout Float, rhs: Int32) { lhs = lhs - rhs }
@_disfavoredOverload public func *= (lhs: inout Float, rhs: Int32) { lhs = lhs * rhs }
@_disfavoredOverload public func /= (lhs: inout Float, rhs: Int32) { lhs = lhs / rhs }

// MARK: - Truth values

/// Raven adds a `qboolean` to an `int`, which C reads as 0 or 1, for example `isfog += G_SpawnInt("fognear", "0", &fogn)`.
/// `@_disfavoredOverload` keeps every `Int32` right side on the stdlib's `Int32` operator.
@_disfavoredOverload public func += (lhs: inout Int32, rhs: Bool) { lhs += rhs ? 1 : 0 }
