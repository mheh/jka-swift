import JKAMP
import JKAShared

/// This holds Raven's two traps as the C functions that `Pmove` calls through `pmove_t.trace` and `pmove_t.pointcontents`.
/// Each passes the pointer words to the syscall of its trap, as Raven's `trap_Trace` and `trap_PointContents` did.
public enum PmoveThunks {
    /// Source: oracle/codemp/game/g_syscalls.c:148
    public static let trap_Trace: PmoveTrace = { results, start, mins, maxs, end, passEntityNum, contentmask in
        _ = Syscall.call(G_TRACE, results, start, mins, maxs, end, passEntityNum, contentmask, 0, 10)
    }

    /// Source: oracle/codemp/game/g_syscalls.c:157
    public static let trap_PointContents: PmovePointcontents = { point, passEntityNum in
        Int32(truncatingIfNeeded: Syscall.call(G_POINT_CONTENTS, point, passEntityNum))
    }
}
