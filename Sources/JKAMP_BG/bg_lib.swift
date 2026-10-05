// Adopted from tools/oracle-closure/skeleton.py, rule 13. qsort is ported, and the Q3_VM bodies wait for the VM step.

import JKAMP
import JKAShared

/*
 * Qsort routine from Bentley & McIlroy's "Engineering a Sort Function".
 */

/// Raven swaps `n` bytes between two addresses, and picks a long or a char chunk by the element size and the alignment.
/// The chunk size is a speed choice the order of the result never observes, so this swaps `n` whole elements.
///
/// Source: oracle/codemp/game/bg_lib.c:80
private func swapfunc<T>(_ a: inout [T], _ x: Int, _ y: Int, _ n: Int) {
    for k in 0 ..< n {
        a.swapAt(x + k, y + k)
    }
}

/// Raven returns the address of the median of three, and this returns its index.
/// Source: oracle/codemp/game/bg_lib.c:98
private func med3<T>(_ a: [T], _ x: Int, _ y: Int, _ z: Int, _ cmp: (T, T) -> Int32) -> Int {
    cmp(a[x], a[y]) < 0 ?
        (cmp(a[y], a[z]) < 0 ? y : (cmp(a[x], a[z]) < 0 ? z : x))
        : (cmp(a[y], a[z]) > 0 ? y : (cmp(a[x], a[z]) < 0 ? x : z))
}

/// Raven writes the small-array loop twice, once for `n < 7` and once for the no-swap case.
/// This holds the one body both places call. Rule 10 keeps the behavior, not the shape.
///
/// Source: oracle/codemp/game/bg_lib.c:113
private func insertion<T>(_ a: inout [T], _ lo: Int, _ n: Int, _ cmp: (T, T) -> Int32) {
    for pm in (lo + 1) ..< (lo + n) {
        var pl = pm
        while pl > lo && cmp(a[pl - 1], a[pl]) > 0 {
            a.swapAt(pl, pl - 1)
            pl -= 1
        }
    }
}

/// Raven's `qsort`, the Bentley and McIlroy three-way partition, transcribed index for index over a Swift array.
/// The permutation of equal keys matches the C body, because the algorithm observes only comparisons and whole-element swaps.
/// jka-rust ruled this body canonical in DEC-34 and never reproduces the tie order of the MSVC runtime.
///
/// Source: oracle/codemp/game/bg_lib.c:105
func qsort<T>(_ a: inout [T], _ cmp: (T, T) -> Int32) {
    qsortSpan(&a, 0, a.count, cmp)
}

/// Raven reaches its tail iteration with `goto loop` over the same locals, and this holds the span in two parameters.
/// Source: oracle/codemp/game/bg_lib.c:110
private func qsortSpan<T>(_ a: inout [T], _ lo: Int, _ n: Int, _ cmp: (T, T) -> Int32) {
    var lo = lo
    var n = n

    while true {
        var swap_cnt = false

        if n < 7 {
            insertion(&a, lo, n, cmp)
            return
        }
        var pm = lo + n / 2
        if n > 7 {
            var pl = lo
            var pn = lo + n - 1
            if n > 40 {
                let d = n / 8
                pl = med3(a, pl, pl + d, pl + 2 * d, cmp)
                pm = med3(a, pm - d, pm, pm + d, cmp)
                pn = med3(a, pn - 2 * d, pn - d, pn, cmp)
            }
            pm = med3(a, pl, pm, pn, cmp)
        }
        a.swapAt(lo, pm)
        var pa = lo + 1
        var pb = pa

        var pc = lo + n - 1
        var pd = pc
        while true {
            while pb <= pc {
                let r = cmp(a[pb], a[lo])
                if r > 0 {
                    break
                }
                if r == 0 {
                    swap_cnt = true
                    a.swapAt(pa, pb)
                    pa += 1
                }
                pb += 1
            }
            while pb <= pc {
                let r = cmp(a[pc], a[lo])
                if r < 0 {
                    break
                }
                if r == 0 {
                    swap_cnt = true
                    a.swapAt(pc, pd)
                    pd -= 1
                }
                pc -= 1
            }
            if pb > pc {
                break
            }
            a.swapAt(pb, pc)
            swap_cnt = true
            pb += 1
            pc -= 1
        }
        if swap_cnt == false {  /* Switch to insertion sort */
            insertion(&a, lo, n, cmp)
            return
        }

        let pn = lo + n
        var r = min(pa - lo, pb - pa)
        if r > 0 {
            swapfunc(&a, lo, pb - r, r)
        }
        r = min(pd - pc, pn - pd - 1)
        if r > 0 {
            swapfunc(&a, pb, pn - r, r)
        }
        r = pb - pa
        if r > 1 {
            qsortSpan(&a, lo, r, cmp)
        }
        r = pd - pc
        if r > 1 {
            /* Iterate rather than recurse to save stack space */
            lo = pn - r
            n = r
            continue
        }
        return
    }
}

/// Source: oracle/codemp/game/bg_lib.c:287
// Raven wrote: void *memmove( void *dest, const void *src, size_t count )
// Not ported: the C library's, which no body of the module calls, and a Swift body moves bytes through CharBuf and a view's setter.

/// Source: oracle/codemp/game/bg_lib.c:763
var randSeed: Int32 {
    get { bg.variables.randSeed }
    set { bg.variables.randSeed = newValue }
}

/// Source: oracle/codemp/game/bg_lib.c:765
public func srand(_ seed: UInt32) {
    randSeed = Int32(bitPattern: seed)
}

/// Source: oracle/codemp/game/bg_lib.c:769
public func rand() -> Int32 {
    randSeed = (69069 &* randSeed &+ 1)
    return randSeed & 0x7fff
}

/// Source: oracle/codemp/game/q_shared.h:1591
public func random() -> Float {
    Float(rand() & 0x7fff) / Float(0x7fff)
}

/// Source: oracle/codemp/game/q_shared.h:1592
public func crandom() -> Float {
    // Raven's 2.0 and 0.5 are double literals, so the arithmetic runs in double and narrows to float once, on return.
    Float(2.0 * (Double(random()) - 0.5))
}

/// Source: oracle/codemp/game/bg_lib.c:774
func atof(_ string: String) -> Double {
    var sign: Float
    var value: Float
    var c: Int32
    // Raven steps his own `string` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var string = TextCursor(CharBuf(string))


    // skip whitespace
    while string.byte <= Int32(ascii: " ") {
        if string.byte == 0 {
            return 0
        }
        string.advance()
    }

    // check sign
    switch string.byte {
    case Int32(ascii: "+"):
        string.advance()
        sign = 1

    case Int32(ascii: "-"):
        string.advance()
        sign = -1

    default:
        sign = 1
    }

    // read digits
    value = 0
    c = string[0]
    if c != Int32(ascii: ".") {
        repeat {
            c = string.byte
            string.advance()
            if c < Int32(ascii: "0") || c > Int32(ascii: "9") {
                break
            }
            c -= Int32(ascii: "0")
            value = value * 10 + c
        } while 1 != 0
    } else {
        string.advance()
    }

    // check for decimal point
    if c == Int32(ascii: ".") {
        var fraction: Double

        fraction = 0.1
        repeat {
            c = string.byte
            string.advance()
            if c < Int32(ascii: "0") || c > Int32(ascii: "9") {
                break
            }
            c -= Int32(ascii: "0")
            value = Float(Double(value) + Double(c) * fraction)
            fraction *= 0.1
        } while 1 != 0
    }

    // not handling 10e10 notation...

    return Double(value * sign)
}

/// Source: oracle/codemp/game/bg_lib.c:841
func _atof(_ stringPtr: inout JKAShared.TextCursor) -> Double {
    var string: TextCursor
    var sign: Float
    var value: Float
    var c: Int32 = Int32(ascii: "0") // bk001211 - uninitialized use possible

    string = stringPtr

    // skip whitespace
    while string.byte <= Int32(ascii: " ") {
        if string.byte == 0 {
            stringPtr = string
            return 0
        }
        string.advance()
    }

    // check sign
    switch string.byte {
    case Int32(ascii: "+"):
        string.advance()
        sign = 1

    case Int32(ascii: "-"):
        string.advance()
        sign = -1

    default:
        sign = 1
    }

    // read digits
    value = 0
    if string[0] != Int32(ascii: ".") {
        repeat {
            c = string.byte
            string.advance()
            if c < Int32(ascii: "0") || c > Int32(ascii: "9") {
                break
            }
            c -= Int32(ascii: "0")
            value = value * 10 + c
        } while 1 != 0
    }

    // check for decimal point
    if c == Int32(ascii: ".") {
        var fraction: Double

        fraction = 0.1
        repeat {
            c = string.byte
            string.advance()
            if c < Int32(ascii: "0") || c > Int32(ascii: "9") {
                break
            }
            c -= Int32(ascii: "0")
            value = Float(Double(value) + Double(c) * fraction)
            fraction *= 0.1
        } while 1 != 0

    }

    // not handling 10e10 notation...
    stringPtr = string

    return Double(value * sign)
}
