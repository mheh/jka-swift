final class Box { var v: [Float] = [1, 2, 3] }
let box = Box()
struct View {
    var velocity: [Float] {
        get { box.v }
        nonmutating set { box.v = newValue }
    }
}
struct Pm { var ps: View { View() } }
var pm: Pm { Pm() }
func clip(_ a: inout [Float], _ n: inout [Float], _ out: inout [Float]) {
    for i in 0..<3 { out[i] = a[i] * 10 }
}
var normal: [Float] = [0, 0, 1]
clip(&pm.ps.velocity, &normal, &pm.ps.velocity)
print("after clip:", box.v)
