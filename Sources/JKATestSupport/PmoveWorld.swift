import JKAShared

/// This struct is the axial-brush test world of the pmove goldens, a transcription of `pmworld.h`.
/// Every brush is an axis-aligned box, so a trace needs only `Float` `+ - * /` and compares, with no libm.
/// The trace and the point test are the only collision that `pmove_trace`, `pmove`, and `pmove_saber` exercise.
///
/// Source: jka-rust/tools/jampgame-oracle/pmworld.h:1
public struct PmoveWorld {
    // MARK: - State

    /// The brushes of the world, in the order the fixture adds them.
    public private(set) var brushes: [PmoveBrush] = []

    /// The number of calls to `trace` since the last reset, the `ntr` tripwire of the pmove dump.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:44
    public var traceCount: Int = 0

    /// This is `PMW_SURFACE_CLIP_EPSILON`.
    /// A trace stops this distance in front of a face, as Q3's `CM_ClipBoxToBrush` does.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:30
    public static let surfaceClipEpsilon: Float = 0.125

    /// This is `PMW_MAX_BRUSHES`.
    /// The dumper ends with an error at one brush more, and the test traps there.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:31
    public static let maxBrushes = 64

    public init() {}
}

/// This struct is one axis-aligned box brush of the test world, with the surface flags a trace reports on a hit.
/// Source: jka-rust/tools/jampgame-oracle/pmworld.h:33
public struct PmoveBrush: Equatable, Sendable {
    public var mins: vec3_t
    public var maxs: vec3_t
    public var surfaceFlags: Int32

    public init(mins: vec3_t, maxs: vec3_t, surfaceFlags: Int32) {
        self.mins = mins
        self.maxs = maxs
        self.surfaceFlags = surfaceFlags
    }
}

/// This struct holds the `trace_t` fields the test world writes, so a caller copies them into a C `trace_t` or prints them.
/// The initial value is Raven's `memset(&tr, 0, sizeof(tr))`, so a field the trace does not write stays zero.
public struct PmoveTraceResult: Equatable, Sendable {
    public var allsolid: Int32 = 0
    public var startsolid: Int32 = 0
    public var fraction: Float = 0
    public var endpos = vec3_t(0, 0, 0)
    public var normal = vec3_t(0, 0, 0)
    public var dist: Float = 0
    public var type: Int32 = 0
    public var signbits: Int32 = 0
    public var surfaceFlags: Int32 = 0
    public var contents: Int32 = 0
    public var entityNum: Int32 = 0

    public init() {}
}

// MARK: - The world set

extension PmoveWorld {
    /// This clears the brushes and the trace count.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:46
    public mutating func reset() {
        self.brushes = []
        self.traceCount = 0
    }

    /// This adds one brush at the end of the brush list.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:51
    public mutating func add(_ brush: PmoveBrush) {
        precondition(self.brushes.count < Self.maxBrushes, "pmw: too many brushes")
        self.brushes.append(brush)
    }
}

// MARK: - The trace

extension PmoveWorld {
    /// This sweeps the box `mins`, `maxs` from `start` to `end` through all brushes, and counts the call.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:185
    public mutating func trace(_ start: vec3_t, _ mins: vec3_t, _ maxs: vec3_t, _ end: vec3_t) -> PmoveTraceResult {
        var tr = PmoveTraceResult()

        self.traceCount += 1

        tr.fraction = 1.0

        for brush in self.brushes {
            Self.clipBoxToBrush(&tr, start, end, mins, maxs, brush)
            if tr.allsolid != 0 {
                break // can't get any more solid
            }
        }

        if tr.allsolid != 0 {
            tr.startsolid = 1
        }

        let fraction: Float = tr.fraction
        tr.endpos[0] = start[0] + fraction * (end[0] - start[0])
        tr.endpos[1] = start[1] + fraction * (end[1] - start[1])
        tr.endpos[2] = start[2] + fraction * (end[2] - start[2])

        if tr.fraction < 1.0 {
            tr.entityNum = Int32(ENTITYNUM_WORLD)
            tr.contents = Int32(CONTENTS_SOLID)
        } else {
            tr.entityNum = Int32(ENTITYNUM_NONE)
        }

        return tr
    }

    /// This returns `CONTENTS_SOLID` when the point is inside or on a brush, and 0 when it is in open space.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:229
    public func pointContents(_ point: vec3_t) -> Int32 {
        for b in self.brushes {
            if point[0] >= b.mins[0] && point[0] <= b.maxs[0]
                && point[1] >= b.mins[1] && point[1] <= b.maxs[1]
                && point[2] >= b.mins[2] && point[2] <= b.maxs[2] {
                return Int32(CONTENTS_SOLID)
            }
        }
        return 0
    }

    /// This gives one of the six outward faces of a brush.
    /// The normal is exactly one of plus or minus each axis, and the distance makes `normal . p == dist` on the face.
    /// An even face is the plus side of its axis, and an odd face is the minus side.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:67
    static func brushPlane(_ b: PmoveBrush, _ face: Int) -> (normal: vec3_t, dist: Float, axis: Int) {
        let a = face >> 1
        let positive = (face & 1) == 0
        var normal = vec3_t(0, 0, 0)
        if positive {
            normal[a] = 1.0
            return (normal, b.maxs[a], a)
        } else {
            normal[a] = -1.0
            return (normal, -b.mins[a], a)
        }
    }

    /// This is Q3's `CM_ClipBoxToBrush` for one box brush, and it updates `tw` in place.
    /// A `return` means that this brush does not clip the sweep.
    /// Source: jka-rust/tools/jampgame-oracle/pmworld.h:84
    static func clipBoxToBrush(
        _ tw: inout PmoveTraceResult,
        _ start: vec3_t,
        _ end: vec3_t,
        _ tw_mins: vec3_t,
        _ tw_maxs: vec3_t,
        _ brush: PmoveBrush
    ) {
        var enterFrac: Float = -1.0
        var leaveFrac: Float = 1.0
        var clipNormal = vec3_t(0, 0, 0)
        var clipDist: Float = 0.0
        var clipAxis = 0
        var getout = false
        var startout = false
        let epsilon: Float = Self.surfaceClipEpsilon

        for face in 0 ..< 6 {
            let (normal, planeDist, axis) = Self.brushPlane(brush, face)

            let ofs0: Float = normal[0] < 0.0 ? tw_maxs[0] : tw_mins[0]
            let ofs1: Float = normal[1] < 0.0 ? tw_maxs[1] : tw_mins[1]
            let ofs2: Float = normal[2] < 0.0 ? tw_maxs[2] : tw_mins[2]

            // The normal is axial, so only the offset on its axis contributes to the dot product.
            let ofsDot: Float = ofs0 * normal[0] + ofs1 * normal[1] + ofs2 * normal[2]
            let dist: Float = planeDist - ofsDot

            let startDot: Float = start[0] * normal[0] + start[1] * normal[1] + start[2] * normal[2]
            let endDot: Float = end[0] * normal[0] + end[1] * normal[1] + end[2] * normal[2]
            let d1: Float = startDot - dist
            let d2: Float = endDot - dist

            if d2 > 0.0 {
                getout = true // endpoint is not in solid
            }
            if d1 > 0.0 {
                startout = true
            }

            // The sweep is completely in front of this face, so it does not touch the brush.
            if d1 > 0.0 && (d2 >= epsilon || d2 >= d1) {
                return
            }
            // The sweep does not cross this plane, so the plane is irrelevant.
            if d1 <= 0.0 && d2 <= 0.0 {
                continue
            }

            if d1 > d2 {
                // The sweep enters the brush through this face.
                var f: Float = (d1 - epsilon) / (d1 - d2)
                if f < 0.0 {
                    f = 0.0
                }
                if f > enterFrac {
                    enterFrac = f
                    clipNormal = normal
                    clipDist = planeDist
                    clipAxis = axis
                }
            } else {
                // The sweep leaves the brush through this face.
                var f: Float = (d1 + epsilon) / (d1 - d2)
                if f > 1.0 {
                    f = 1.0
                }
                if f < leaveFrac {
                    leaveFrac = f
                }
            }
        }

        if !startout {
            // The start point is inside this brush.
            tw.startsolid = 1
            if !getout {
                tw.allsolid = 1
                tw.fraction = 0.0
                tw.contents = Int32(CONTENTS_SOLID)
            }
            return
        }

        if enterFrac < leaveFrac {
            if enterFrac > -1.0 && enterFrac < tw.fraction {
                if enterFrac < 0.0 {
                    enterFrac = 0.0
                }
                tw.fraction = enterFrac
                tw.normal = clipNormal
                tw.dist = clipDist
                tw.type = Int32(clipAxis) // 0, 1, or 2 is an axial plane
                // A bit is set for each negative component of the normal.
                let signX: Int32 = clipNormal[0] < 0.0 ? 1 : 0
                let signY: Int32 = clipNormal[1] < 0.0 ? 2 : 0
                let signZ: Int32 = clipNormal[2] < 0.0 ? 4 : 0
                tw.signbits = signX | signY | signZ
                tw.surfaceFlags = brush.surfaceFlags
                tw.contents = Int32(CONTENTS_SOLID)
            }
        }
    }
}
