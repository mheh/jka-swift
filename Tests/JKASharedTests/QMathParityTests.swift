import JKAShared
import JKATestSupport
import Testing

/// The differential test of rule 18. It rebuilds `Oracle/golden/qmath.txt` from the ported functions and compares the whole text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_qmath.c`, token for token.
@Suite("q_math reproduces the qmath golden")
struct QMathParityTests {
    @Test("the whole golden text matches")
    func goldenMatches() throws {
        let vectors = try QMathDump.loadVectors()
        var got = ""
        got += QMathDump.rng()
        got += QMathDump.qrand()
        got += QMathDump.scalars()
        got += QMathDump.n2ll()
        got += QMathDump.planes(vectors)
        got += QMathDump.vecmath(vectors)
        got += "== end ==\n"

        let golden = try OracleData.golden("qmath")
        #expect(GoldenFormat.mismatch("qmath", got: got, golden: golden) == nil)
        #expect(got == golden)
    }
}

// MARK: - The dump

/// Each method rebuilds one section of the golden with the dumper's tokens and the dumper's order.
enum QMathDump {
    /// The fixture is 30 lines of three hex bit patterns.
    /// Source: jka-rust/tools/jampgame-oracle/main_qmath.c:37
    static func loadVectors() throws -> [vec3_t] {
        var out: [vec3_t] = []
        for line in try OracleData.fixture("vectors.txt").split(separator: "\n") {
            let words = line.split(separator: " ").compactMap { UInt32($0, radix: 16) }
            if words.count == 3 {
                out.append(vec3_t(Float(bitPattern: words[0]), Float(bitPattern: words[1]), Float(bitPattern: words[2])))
            }
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_qmath.c:52
    static func rng() -> String {
        let seeds: [Int32] = [Int32(bitPattern: 0x89ab_cdef), 0, 1, Int32(bitPattern: 0xdead_beef)]
        var out = "== rng ==\n"
        var rng = Rng()
        for seed in seeds {
            out += "seed \(GoldenFormat.hex8(UInt32(bitPattern: seed)))\n"
            rng.Rand_Init(seed)
            for _ in 0 ..< 100 {
                out += "fl \(GoldenFormat.bits(rng.flrand(0.0, 1.0)))\n"
                out += "fl \(GoldenFormat.bits(rng.flrand(-1.0, 1.0)))\n"
                out += "fl \(GoldenFormat.bits(rng.flrand(-100.0, 100.0)))\n"
                out += "qf \(GoldenFormat.bits(rng.Q_flrand(0.0, 1000.0)))\n"
                out += "ir \(rng.irand(0, 1))\n"
                out += "ir \(rng.irand(0, 100))\n"
                out += "ir \(rng.irand(-50, 50))\n"
                out += "qi \(rng.Q_irand(0, 32767))\n"
            }
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_qmath.c:71
    static func qrand() -> String {
        var out = "== qrand ==\n"
        var seed: Int32 = 12345
        for _ in 0 ..< 30 {
            out += "qr \(Q_rand(&seed))\n"
        }
        seed = 12345
        for _ in 0 ..< 30 {
            out += "qrn \(GoldenFormat.bits(Q_random(&seed)))\n"
        }
        seed = 12345
        for _ in 0 ..< 30 {
            out += "qcr \(GoldenFormat.bits(Q_crandom(&seed)))\n"
        }
        seed = -1
        for _ in 0 ..< 20 {
            out += "qr \(Q_rand(&seed))\n"
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_qmath.c:84
    static func scalars() -> String {
        var out = "== scalars ==\n"
        let ci: [Int32] = [
            -300, -128, -1, 0, 1, 127, 128, 200, -32769, -32768,
            32767, 32768, 100_000, -100_000, 1, 2, 3, 255, 256, 1023,
            1024, 0x7fff_ffff,
        ]
        for value in ci {
            out += "cc \(Int32(ClampChar(value))) cs \(Int32(ClampShort(value))) log2 \(Q_log2(value < 0 ? -value : value))\n"
        }

        // Q_rsqrt / Q_fabs / powf over a bit-pattern float table.
        let cf: [UInt32] = [
            0x3f80_0000, 0x4049_0fdb, 0x0000_0001, 0x8000_0000,
            0x7f7f_ffff, 0x3dcc_cccd, 0xc000_0000, 0x42c8_0000,
            0x0080_0000, 0xbf00_0000,
        ]
        for pattern in cf {
            let v = Float(bitPattern: pattern)
            out += "rsqrt \(GoldenFormat.bits(Q_rsqrt(v < 0 ? -v : v))) fabs \(GoldenFormat.bits(Q_fabs(v)))\n"
        }
        for y in Int32(1) ... 6 {
            out += "powf \(GoldenFormat.bits(powf(1.5, y)))\n"
        }

        // ByteToDir over valid and out-of-range indices.
        var d = vec3_t()
        for b in stride(from: Int32(0), to: 162, by: 17) {
            ByteToDir(b, &d)
            out += "b2d \(b) \(GoldenFormat.vector(d))\n"
        }
        ByteToDir(-1, &d)
        out += "b2d -1 \(GoldenFormat.vector(d))\n"
        ByteToDir(500, &d)
        out += "b2d 500 \(GoldenFormat.vector(d))\n"

        // The dumper masks byte 3 of ColorBytes3, which Raven leaves as stack garbage.
        let cc: [[UInt32]] = [
            [0x3f00_0000, 0x3e80_0000, 0x3f80_0000], [0x0000_0000, 0x0000_0000, 0x0000_0000],
            [0x3f80_0000, 0x3f80_0000, 0x3f80_0000], [0x3e4c_cccd, 0x3f19_999a, 0x3f73_3333],
        ]
        for color in cc {
            let r = Float(bitPattern: color[0])
            let g = Float(bitPattern: color[1])
            let b = Float(bitPattern: color[2])
            out += "cb3 \(GoldenFormat.hex8(ColorBytes3(r, g, b) & 0x00ff_ffff)) cb4 \(GoldenFormat.hex8(ColorBytes4(r, g, b, 0.5)))\n"
            var outColor = vec3_t()
            let m = NormalizeColor(vec3_t(r, g, b), &outColor)
            out += "ncol \(GoldenFormat.bits(m)) \(GoldenFormat.vector(outColor))\n"
        }
        return out
    }

    /// The dumper hand-picks safe normals, so the argument of `acos` stays in -1 to 1.
    /// Source: jka-rust/tools/jampgame-oracle/main_qmath.c:131
    static func n2ll() -> String {
        var out = "== n2ll ==\n"
        let ns: [[UInt32]] = [
            [0x3f80_0000, 0x0000_0000, 0x0000_0000],  // (1,0,0)
            [0x0000_0000, 0x3f80_0000, 0x0000_0000],  // (0,1,0)
            [0x0000_0000, 0x0000_0000, 0x3f80_0000],  // (0,0,1) singularity
            [0x0000_0000, 0x0000_0000, 0xbf80_0000],  // (0,0,-1) singularity
            [0x3f0f_5c29, 0x3f0f_5c29, 0x3ef1_a9fc],  // ~(0.56,0.56,0.47) normalized-ish
            [0xbf13_cd36, 0x3f13_cd36, 0x0000_0000],  // (-0.577,0.577,0)-ish
        ]
        for entry in ns {
            var n = vec3_t(Float(bitPattern: entry[0]), Float(bitPattern: entry[1]), Float(bitPattern: entry[2]))
            _ = VectorNormalize(&n)  // keep |z|<=1
            var b: (byte, byte) = (0, 0)
            NormalToLatLong(n, &b)
            out += "n2ll \(GoldenFormat.hex2(b.0))\(GoldenFormat.hex2(b.1))\n"
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_qmath.c:151
    static func planes(_ vectors: [vec3_t]) -> String {
        var out = "== planes ==\n"
        let count = vectors.count
        for i in 0 ..< count {
            let n = vectors[i]
            for ty in 0 ... 3 {
                var p = Plane()
                p.normal = n
                p.dist = n[0]
                p.type = byte(ty)
                SetPlaneSignbits(&p)
                let j = (i + 1) % count
                let k = (i + 2) % count
                let side = BoxOnPlaneSide(vectors[j], vectors[k], &p)
                out += "plane \(i) ty \(ty) sb \(p.signbits) side \(side)\n"
            }
        }
        return out
    }

    /// `ProjectPointOnPlane`, `PerpendicularVector`, and `RotatePointAroundVector` divide by the squared length of the normal.
    /// The dumper prints `SKIP` where that sum is zero, and the port never runs the divide there. Rule 19.
    ///
    /// Source: jka-rust/tools/jampgame-oracle/main_qmath.c:168
    static func vecmath(_ vectors: [vec3_t]) -> String {
        var out = "== vecmath ==\n"
        let count = vectors.count
        for i in 0 ..< count {
            let j = (i + 1) % count
            let k = (i + 2) % count
            let a = vectors[i]
            let b = vectors[j]
            let c = vectors[k]
            var t = vec3_t()
            var u = vec3_t()

            out += "i \(i)\n"

            var forward = vec3_t()
            var right = vec3_t()
            var up = vec3_t()
            AngleVectors(a, &forward, &right, &up)
            out += "av \(GoldenFormat.vector(forward)) \(GoldenFormat.vector(right)) \(GoldenFormat.vector(up))\n"

            var ang = vec3_t()
            vectoangles(a, &ang)
            out += "va \(GoldenFormat.vector(ang))\n"

            _VectorCopy(a, &t)
            out += "vn \(GoldenFormat.bits(VectorNormalize(&t))) \(GoldenFormat.vector(t))\n"
            out += "vn2 \(GoldenFormat.bits(VectorNormalize2(a, &t))) \(GoldenFormat.vector(t))\n"

            out += "vl \(GoldenFormat.bits(VectorLength(a))) vls \(GoldenFormat.bits(VectorLengthSquared(a)))\n"
            out += "dist \(GoldenFormat.bits(Distance(a, b))) dsq \(GoldenFormat.bits(DistanceSquared(a, b)))\n"
            out += "dh \(GoldenFormat.bits(DistanceHorizontal(a, b))) dhs \(GoldenFormat.bits(DistanceHorizontalSquared(a, b)))\n"
            out += "vcmp \(VectorCompare(a, b)) \(VectorCompare(a, a))\n"

            CrossProduct(a, b, &t)
            out += "cross \(GoldenFormat.vector(t))\n"
            out += "dot \(GoldenFormat.bits(_DotProduct(a, b))) _dot \(GoldenFormat.bits(_DotProduct(a, b)))\n"
            out += "dpn \(GoldenFormat.bits(DotProductNormalize(a, b)))\n"

            _VectorCopy(a, &t)
            VectorInverse(&t)
            out += "vinv \(GoldenFormat.vector(t))\n"
            _VectorMA(a, 2.5, b, &t)
            out += "vma \(GoldenFormat.vector(t))\n"
            _VectorAdd(a, b, &t)
            out += "vadd \(GoldenFormat.vector(t))\n"
            _VectorSubtract(a, b, &t)
            out += "vsub \(GoldenFormat.vector(t))\n"
            _VectorScale(a, 1.5, &t)
            out += "vscale \(GoldenFormat.vector(t))\n"
            var scaled4 = vec4_t()
            Vector4Scale(vec4_t(a[0], a[1], a[2], b[0]), 2.0, &scaled4)
            out += "v4s \(GoldenFormat.vector4(scaled4))\n"

            // The three divides need a non-degenerate normal or direction.
            if VectorLengthSquared(b) != 0 {
                ProjectPointOnPlane(&t, a, b)
                out += "proj \(GoldenFormat.vector(t))\n"
            } else {
                out += "proj SKIP\n"
            }

            MakeNormalVectors(a, &t, &u)
            out += "mnv \(GoldenFormat.vector(t)) \(GoldenFormat.vector(u))\n"
            if VectorLengthSquared(a) != 0 {
                PerpendicularVector(&t, a)
                out += "perp \(GoldenFormat.vector(t))\n"
            } else {
                out += "perp SKIP\n"
            }

            if VectorLengthSquared(a) != 0 {
                RotatePointAroundVector(&t, a, b, a[0])
                out += "rot \(GoldenFormat.vector(t))\n"
            } else {
                out += "rot SKIP\n"
            }

            // PlaneFromPoints leaves plane[3] untouched on the degenerate path, so the caller's zero must match.
            var plane = vec4_t(0, 0, 0, 0)
            let ok = PlaneFromPoints(&plane, a, b, c)
            out += "pfp \(ok ? 1 : 0) \(GoldenFormat.vector4(plane))\n"

            out += "angsub \(GoldenFormat.bits(AngleSubtract(a[0], a[1])))\n"
            AnglesSubtract(a, b, &t)
            out += "angssub \(GoldenFormat.vector(t))\n"
            out += "lerp \(GoldenFormat.bits(LerpAngle(a[0], a[1], a[2])))\n"
            out += "an360 \(GoldenFormat.bits(AngleNormalize360(a[0]))) an180 \(GoldenFormat.bits(AngleNormalize180(a[0])))"
            out += " amod \(GoldenFormat.bits(AngleMod(a[0]))) adel \(GoldenFormat.bits(AngleDelta(a[0], a[1])))\n"

            out += "rfb \(GoldenFormat.bits(RadiusFromBounds(a, b)))\n"
            out += "d2b \(DirToByte(a))\n"

            var closest = vec3_t()
            let found = G_FindClosestPointOnLineSegment(a, b, c, &closest)
            out += "gclose \(found ? 1 : 0) \(GoldenFormat.vector(closest))\n"
            out += "gdist \(GoldenFormat.bits(G_PointDistFromLineSegment(a, b, c)))\n"

            // Matrix / axis ops.
            var axis = [vec3_t](repeating: vec3_t(), count: 3)
            AnglesToAxis(a, &axis)
            out += "a2a \(GoldenFormat.vector(axis[0])) \(GoldenFormat.vector(axis[1])) \(GoldenFormat.vector(axis[2]))\n"
            VectorRotate(b, axis, &t)
            out += "vrot \(GoldenFormat.vector(t))\n"
            var copied = [vec3_t](repeating: vec3_t(), count: 3)
            AxisCopy(axis, &copied)
            out += "acopy \(GoldenFormat.vector(copied[1]))\n"
            RotateAroundDirection(&axis, a[1])
            out += "rad \(GoldenFormat.vector(axis[1]))\n"

            var cleared = [vec3_t](repeating: vec3_t(), count: 3)
            AxisClear(&cleared)
            out += "aclear \(GoldenFormat.bits(cleared[0][0])) \(GoldenFormat.bits(cleared[1][1])) \(GoldenFormat.bits(cleared[2][2]))\n"

            let m1: [[Float]] = [[a[0], a[1], a[2]], [b[0], b[1], b[2]], [c[0], c[1], c[2]]]
            let m2: [[Float]] = [[c[0], b[1], a[2]], [a[0], c[1], b[2]], [b[0], a[1], c[2]]]
            var product = [[Float]](repeating: [Float](repeating: 0, count: 3), count: 3)
            MatrixMultiply(m1, m2, &product)
            out += "mm \(GoldenFormat.bits(product[0][0])) \(GoldenFormat.bits(product[1][1])) \(GoldenFormat.bits(product[2][2]))\n"

            var mins = vec3_t()
            var maxs = vec3_t()
            ClearBounds(&mins, &maxs)
            AddPointToBounds(a, &mins, &maxs)
            AddPointToBounds(b, &mins, &maxs)
            out += "bounds \(GoldenFormat.vector(mins)) \(GoldenFormat.vector(maxs))\n"
        }
        return out
    }
}
