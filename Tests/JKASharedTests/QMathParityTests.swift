import JKAShared
import JKATestSupport
import Testing

/// The differential test of rule 18. It rebuilds `Oracle/golden/qmath.txt` from the ported functions and compares the whole text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_qmath.c`, token for token.
@Suite("q_math reproduces the qmath golden")
struct QMathParityTests {
    @Test("each ported section matches the golden", arguments: ["rng", "qrand", "scalars", "n2ll"])
    func sectionMatches(name: String) throws {
        let golden = try QMathGolden.section(name, in: OracleData.golden("qmath"))
        let got = QMathDump.section(name)
        #expect(GoldenFormat.mismatch("qmath \(name)", got: got, golden: golden) == nil)
        #expect(got == golden)
    }
}

// MARK: - The golden slices

/// This cuts one `== name ==` section out of the golden, so a lane commit gates on the sections it ported.
enum QMathGolden {
    static func section(_ name: String, in golden: String) throws -> String {
        let opener = "== \(name) ==\n"
        guard let start = golden.range(of: opener) else {
            throw QMathGoldenError.noSection(name)
        }
        let rest = golden[start.upperBound...]
        guard let end = rest.range(of: "\n== ") else {
            throw QMathGoldenError.noSection(name)
        }
        return opener + String(rest[..<end.lowerBound]) + "\n"
    }
}

enum QMathGoldenError: Error {
    case noSection(String)
}

// MARK: - The dump

/// Each method rebuilds one section of the golden with the dumper's tokens and the dumper's order.
enum QMathDump {
    /// This builds one section by its golden name.
    static func section(_ name: String) -> String {
        switch name {
        case "rng": self.rng()
        case "qrand": self.qrand()
        case "scalars": self.scalars()
        case "n2ll": self.n2ll()
        default: ""
        }
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
}
