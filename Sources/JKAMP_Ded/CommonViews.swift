#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(ucrt)
import ucrt
#endif
import JKAShared

// MARK: - Byte fill at an offset

/// Raven's `Com_Memset( o, val, count )` through a `char *` that points into a buffer at a byte offset.
/// Source: oracle/codemp/qcommon/common.cpp:526
// AI: Raven fills the bytes from a pointer into the buffer. The function takes the buffer and the byte offset of that pointer.
public func Com_Memset(_ buf: inout CharBuf, _ val: Int32, _ count: some BinaryInteger, at offset: some BinaryInteger) {
    var index = Int(offset)
    let end = Int(offset) + Int(count)
    while index < end {
        buf[index] = val
        index += 1
    }
}

// MARK: - The C library under common.cpp

/// The C library functions that common.cpp calls on raw memory and on a `struct tm` pointer.
/// A nil pointer traps at `memcpy` and `memset`, because the C library dereferences a NULL pointer there.
/// Each call names the C library module of its platform, because the member of the same name hides the C function.
// AI: Raven calls memcpy, memset, localtime, and asctime on raw pointers. The backend makes the calls in the view target.
public enum CommonBackend {
    /// Source: oracle/codemp/qcommon/common.cpp:1817
    public static func memcpy(_ dest: OpaquePointer?, _ src: OpaquePointer?, _ count: CUnsignedLong) {
        #if canImport(Darwin)
        _ = Darwin.memcpy(UnsafeMutableRawPointer(dest!), UnsafeRawPointer(src!), Int(count))
        #elseif canImport(Glibc)
        _ = Glibc.memcpy(UnsafeMutableRawPointer(dest!), UnsafeRawPointer(src!), Int(count))
        #elseif canImport(Musl)
        _ = Musl.memcpy(UnsafeMutableRawPointer(dest!), UnsafeRawPointer(src!), Int(count))
        #elseif canImport(ucrt)
        _ = ucrt.memcpy(UnsafeMutableRawPointer(dest!), UnsafeRawPointer(src!), Int(count))
        #endif
    }

    /// Source: oracle/codemp/qcommon/common.cpp:1822
    public static func memset(_ dest: OpaquePointer?, _ val: Int32, _ count: CUnsignedLong) {
        #if canImport(Darwin)
        _ = Darwin.memset(UnsafeMutableRawPointer(dest!), val, Int(count))
        #elseif canImport(Glibc)
        _ = Glibc.memset(UnsafeMutableRawPointer(dest!), val, Int(count))
        #elseif canImport(Musl)
        _ = Musl.memset(UnsafeMutableRawPointer(dest!), val, Int(count))
        #elseif canImport(ucrt)
        _ = ucrt.memset(UnsafeMutableRawPointer(dest!), val, Int(count))
        #endif
    }

    /// Raven's `asctime( localtime( &aclock ) )`, the text of the local time with its newline.
    /// Source: oracle/codemp/qcommon/common.cpp:177
    public static func asctime(_ aclock: time_t) -> String {
        var clock = aclock
        #if canImport(Darwin)
        return String(cString: Darwin.asctime(Darwin.localtime(&clock)))
        #elseif canImport(Glibc)
        return String(cString: Glibc.asctime(Glibc.localtime(&clock)))
        #elseif canImport(Musl)
        return String(cString: Musl.asctime(Musl.localtime(&clock)))
        #elseif canImport(ucrt)
        return String(cString: ucrt.asctime(ucrt.localtime(&clock)))
        #endif
    }
}

// MARK: - The C library qsort

// AI: Raven's host calls the C library qsort, which no target of the host has. These are the bodies of Sources/JKAMP_BG/bg_lib.swift, which the host does not import.
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
    var pm = lo + 1
    while pm < lo + n {
        var pl = pm
        while pl > lo && cmp(a[pl - 1], a[pl]) > 0 {
            a.swapAt(pl, pl - 1)
            pl -= 1
        }
        pm += 1
    }
}

/// Raven's `qsort`, the Bentley and McIlroy three-way partition, transcribed index for index over a Swift array.
/// The permutation of equal keys matches the C body, because the algorithm observes only comparisons and whole-element swaps.
/// jka-rust ruled this body canonical in DEC-34 and never reproduces the tie order of the MSVC runtime.
///
/// Source: oracle/codemp/game/bg_lib.c:105
public func qsort<T>(_ a: inout [T], _ cmp: (T, T) -> Int32) {
    qsortSpan(&a, 0, a.count, cmp)
}

/// Raven's `qsort(base, num, width, compare)` over the first `n` elements, with the `width` argument dropped.
/// The elements past `n` keep their order.
public func qsort<T>(_ a: inout [T], _ n: Int32, _ cmp: (T, T) -> Int32) {
    qsortSpan(&a, 0, Int(n), cmp)
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
