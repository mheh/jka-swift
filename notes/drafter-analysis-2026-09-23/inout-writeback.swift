final class Storage { var v: SIMD3<Float> = SIMD3(1, 2, 3); var n: SIMD3<Float> = SIMD3(0, 0, 1) }
let storage = Storage()
struct PS: Hashable {
    var velocity: SIMD3<Float> {
        get { storage.v }
        nonmutating set { storage.v = newValue }
    }
}
struct Pmove: Hashable {
    var ps: PS { get { PS() } }
}
final class Vars { var pm: Pmove? = Pmove() }
let vars = Vars()
var pm: Pmove {
    get { guard let pm = vars.pm else { preconditionFailure() }; return pm }
    set { vars.pm = newValue }
}
func PM_ClipVelocity(_ `in`: inout SIMD3<Float>, _ normal: inout SIMD3<Float>, _ out: inout SIMD3<Float>, _ overbounce: Float) {
    let backoff = (`in` * normal).sum() * overbounce
    for i in 0..<3 { out[i] = `in`[i] - normal[i] * backoff }
}
var normal = SIMD3<Float>(0, 0, 1)
PM_ClipVelocity(&pm.ps.velocity, &normal, &pm.ps.velocity, 1.001)
print(storage.v)
