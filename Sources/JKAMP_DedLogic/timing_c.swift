import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's cycle timer, the two time-stamp counter reads of a span and their difference.
/// Com_Frame and the Ghoul2 timers of tr_ghoul2.cpp hold one each under `G2_PERFORMANCE_ANALYSIS`.
/// Source: oracle/codemp/qcommon/timing.h:2
// AI: Raven reads the counter with an inline `rdtsc` block. The class keeps his fields and leaves the read to the body wave.
final class timing_c {
    private var start: Int64 = 0
    private var end: Int64 = 0

    private var reset: Int32 = 0

    /// Source: oracle/codemp/qcommon/timing.h:10
    init() {}

    /// Source: oracle/codemp/qcommon/timing.h:13
    func Start() {
        // TODO: Port timing_c::Start
        portMissing("timing_c::Start", source: "oracle/codemp/qcommon/timing.h:13")
    }

    /// Source: oracle/codemp/qcommon/timing.h:32
    func End() -> Int32 {
        // TODO: Port timing_c::End
        portMissing("timing_c::End", source: "oracle/codemp/qcommon/timing.h:32")
    }
}
