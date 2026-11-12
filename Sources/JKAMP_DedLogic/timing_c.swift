import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's cycle timer, the two time-stamp counter reads of a span and their difference.
/// Com_Frame and the Ghoul2 timers of tr_ghoul2.cpp hold one each under `G2_PERFORMANCE_ANALYSIS`.
/// Source: oracle/codemp/qcommon/timing.h:2
public final class timing_c {
    private var start: Int64 = 0
    private var end: Int64 = 0

    private var reset: Int32 = 0

    /// Source: oracle/codemp/qcommon/timing.h:10
    init() {}

    /// Source: oracle/codemp/qcommon/timing.h:13
    func Start() {
        // AI: Raven reads the x86 time-stamp counter with an inline `rdtsc` block. The backend reads the monotonic clock of the platform in milliseconds.
        self.start = Int64(SysBackend.timeGetTime())
    }

    /// Source: oracle/codemp/qcommon/timing.h:32
    func End() -> Int32 {
        var time: Int64
        // AI: Raven reads the x86 time-stamp counter with an inline `rdtsc` block. The backend reads the monotonic clock of the platform in milliseconds.
        self.end = Int64(SysBackend.timeGetTime())
        time = self.end - self.start
        if time < 0 {
            time = 0
        }
        return Int32(truncatingIfNeeded: time)
    }
}
