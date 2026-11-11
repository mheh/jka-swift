import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/win32/win_shared.cpp:137
// AI: Raven declares `regs` on the stack of Is3DNOW. The function uses one zeroed allocation on the storage class.
var regs_Is3DNOW: Slots<UInt32> { world.storage.regs_Is3DNOW }

/// Source: oracle/codemp/win32/win_shared.cpp:176
// AI: Raven declares `regs` on the stack of IsKNI. The function uses one zeroed allocation on the storage class.
var regs_IsKNI: Slots<UInt32> { world.storage.regs_IsKNI }

/// Source: oracle/codemp/win32/win_shared.cpp:190
// AI: Raven declares `regs` on the stack of IsWIL. The function uses one zeroed allocation on the storage class.
var regs_IsWIL: Slots<UInt32> { world.storage.regs_IsWIL }

/// Source: oracle/codemp/win32/win_shared.cpp:230
// AI: Raven declares `regs` on the stack of IsMMX. The function uses one zeroed allocation on the storage class.
var regs_IsMMX: Slots<UInt32> { world.storage.regs_IsMMX }

/// Source: oracle/codemp/win32/win_shared.cpp:416
let TOLERANCE = 1 as Int32

/// Source: oracle/codemp/win32/win_shared.cpp:417
let ROUND_THRESHOLD = 6 as Int32

/// Source: oracle/codemp/win32/win_shared.cpp:24
var sys_timeBase: Int32 { world.sys_timeBase }

/**
```
================
Sys_Milliseconds
================
```
*/
/// The default is Raven's, `bool baseTime = false` at oracle/codemp/qcommon/qcommon.h:978.
/// Source: oracle/codemp/win32/win_shared.cpp:22
@discardableResult
public func Sys_Milliseconds(_ baseTime: Bool = false) -> Int32 {
    var sys_curtime: Int32

    // AI: Raven called the Win32 timeGetTime. The backend reads the monotonic clock of the platform in milliseconds.
    sys_curtime = SysBackend.timeGetTime()
    if !baseTime {
        // Port-note: Raven's int subtraction overflows when the 32-bit clock wraps past the base.
        // The body wraps as the x86 build does.
        sys_curtime &-= sys_timeBase
    }

    return sys_curtime
}

/**
```
================
Sys_SnapVector
================
```
*/
/// Source: oracle/codemp/win32/win_shared.cpp:41
func Sys_SnapVector(_ v: inout JKAShared.vec3_t) {
    // AI: Raven stores each float through an `int` with the x87 `fld` and `fistp`, so a negative zero comes back as a positive zero.
    // The body takes the `nearbyintf` form of the fork at openjk/shared/sys/snapvector.cpp:59, which rounds to even on a tie and keeps the sign of a zero.
    v[0] = v[0].rounded(.toNearestOrEven)
    v[1] = v[1].rounded(.toNearestOrEven)
    v[2] = v[2].rounded(.toNearestOrEven)
    /*
    *v = myftol(*v);
    v++;
    *v = myftol(*v);
    v++;
    *v = myftol(*v);
    */
}

/**
```
** --------------------------------------------------------------------------------
**
** PROCESSOR STUFF
**
** --------------------------------------------------------------------------------
```
*/
/// Source: oracle/codemp/win32/win_shared.cpp:84
private func CPUID(_ `func`: Int32, _ regs: Slots<UInt32>) {
    // AI: Raven ran the x86 cpuid instruction and stored its four registers. The host has no portable cpuid, so the function stores nothing.
}

/// Source: oracle/codemp/win32/win_shared.cpp:102
private func IsPentium() -> Int32 {
    // AI: Raven tested the x86 ID flag of EFLAGS in assembly. The host has no such flag, so the function takes Raven's `err:` arm.
    return 0
}

/// Source: oracle/codemp/win32/win_shared.cpp:135
private func Is3DNOW() -> Int32 {
    // AI: Raven declares `unsigned int regs[4]` on his stack. The body uses the zeroed allocation of the storage class through the `regs_Is3DNOW` forward.
    let pstring = CharBuf(16)
    var processorString = CharBuf(13)

    // get name of processor
    // AI: Raven hands `pstring` to CPUID as `unsigned int *`. CPUID stores nothing on this host, so the call drops and `pstring` stays zero.
    processorString[0] = pstring[4] as Int8
    processorString[1] = pstring[5] as Int8
    processorString[2] = pstring[6] as Int8
    processorString[3] = pstring[7] as Int8
    processorString[4] = pstring[12] as Int8
    processorString[5] = pstring[13] as Int8
    processorString[6] = pstring[14] as Int8
    processorString[7] = pstring[15] as Int8
    processorString[8] = pstring[8] as Int8
    processorString[9] = pstring[9] as Int8
    processorString[10] = pstring[10] as Int8
    processorString[11] = pstring[11] as Int8
    processorString[12] = 0

    //  REMOVED because you can have 3DNow! on non-AMD systems
    //	if ( strcmp( processorString, "AuthenticAMD" ) )
    //		return qfalse;

    // check AMD-specific functions
    // Raven wrote 0x80000000.
    CPUID(~0x7fff_ffff, regs_Is3DNOW)
    if regs_Is3DNOW[0] < 0x80000000 {
        return 0
    }

    // bit 31 of EDX denotes 3DNOW! support
    // Raven wrote 0x80000001.
    CPUID(~0x7fff_fffe, regs_Is3DNOW)
    if (regs_Is3DNOW[3] & (1 << 31)) != 0 {
        return 1
    }

    return 0
}

/// Source: oracle/codemp/win32/win_shared.cpp:174
private func IsKNI() -> Int32 {
    // AI: Raven declares `unsigned int regs[4]` on his stack. The body uses the zeroed allocation of the storage class through the `regs_IsKNI` forward.

    // get CPU feature bits
    CPUID(1, regs_IsKNI)

    // bit 25 of EDX denotes KNI existence
    if (regs_IsKNI[3] & (1 << 25)) != 0 {
        return 1
    }

    return 0
}

/// Source: oracle/codemp/win32/win_shared.cpp:188
private func IsWIL() -> Int32 {
    // AI: Raven declares `unsigned int regs[4]` on his stack. The body uses the zeroed allocation of the storage class through the `regs_IsWIL` forward.

    // get CPU feature bits
    CPUID(1, regs_IsWIL)

    // bit 26 of EDX denotes WIL existence
    if (regs_IsWIL[3] & (1 << 26)) != 0 {
        // Ok, CPU supports this instruction, but does the OS?
        //
        // Test a WIL instruction and make sure you don't get an exception...
        //
        // AI: Raven ran one Willamette instruction under __try to test the OS. The host runs no x86 instruction, so the test drops.
        // 	xorpd xmm0,xmm0;  // Willamette New Instructions
        //			if(_exception_code()==STATUS_ILLEGAL_INSTRUCTION)	// forget it, any exception should count as fail for safety

        return 1 // Williamette/P4 instructions available
    }

    return 0
}

/// Source: oracle/codemp/win32/win_shared.cpp:228
private func IsMMX() -> Int32 {
    // AI: Raven declares `unsigned int regs[4]` on his stack. The body uses the zeroed allocation of the storage class through the `regs_IsMMX` forward.

    // get CPU feature bits
    CPUID(1, regs_IsMMX)

    // bit 23 of EDX denotes MMX existence
    if (regs_IsMMX[3] & (1 << 23)) != 0 {
        return 1
    }
    return 0
}

/// Source: oracle/codemp/win32/win_shared.cpp:241
func Sys_GetProcessorId() -> Int32 {
    return CPUID_GENERIC
}

/// Source: oracle/codemp/win32/win_shared.cpp:293
func Sys_GetCurrentUser() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var s_userName = CharBuf(1024)

    // AI: Raven called the Win32 GetUserName with the buffer size. The backend reads the name of the effective user, nil on a failure.
    if let userName = SysBackend.GetUserName() {
        Q_strncpyz(&s_userName, userName, Int32(s_userName.count))
    } else {
        strcpy(&s_userName, "player")
    }

    if s_userName[0] == 0 {
        strcpy(&s_userName, "player")
    }

    return String(s_userName)
}

/// Source: oracle/codemp/win32/win_shared.cpp:314
func Sys_DefaultHomePath() -> String? {
    return nil
}

/// Source: oracle/codemp/win32/win_shared.cpp:318
func Sys_DefaultInstallPath() -> String {
    return Sys_Cwd()
}

/// Source: oracle/codemp/win32/win_shared.cpp:323
func Sys_GetPhysicalMemory() -> Int32 {
    // AI: Raven filled a MEMORYSTATUS with the Win32 GlobalMemoryStatus. The backend gives its `dwTotalPhys` from the page count of the platform.
    let dwTotalPhys = SysBackend.GlobalMemoryStatus()

    return (Int32(dwTotalPhys / (1024 * 1024)) + 1)
}

/// Source: oracle/codemp/win32/win_shared.cpp:338
func Sys_GetCPUSpeedOld() -> Int32 {
    // Port-note: Sys_GetCPUSpeed is the one caller, and it is dead, so this function is dead.
    SysBackend.timeBeginPeriod(1)

    var iPriority: Int32
    let hThread = SysBackend.GetCurrentThread()

    iPriority = SysBackend.GetThreadPriority(hThread)
    if iPriority != THREAD_PRIORITY_ERROR_RETURN {
        SysBackend.SetThreadPriority(hThread, THREAD_PRIORITY_TIME_CRITICAL)
    }

    let clockStart = UInt32(bitPattern: SysBackend.timeGetTime())
    let clockEnd = clockStart &+ 100

    var start: UInt32
    var end: UInt32

    // AI: Raven reads the x86 time-stamp counter with an inline `rdtsc` block. The backend reads the monotonic clock of the platform in milliseconds.
    // With this clock, `coarse` is 0 and the function returns 0.
    start = UInt32(bitPattern: SysBackend.timeGetTime())

    while UInt32(bitPattern: SysBackend.timeGetTime()) < clockEnd { // loop for 1 tenth of a second
    }
    // AI: Raven reads the x86 time-stamp counter with an inline `rdtsc` block. The backend reads the monotonic clock of the platform in milliseconds.
    end = UInt32(bitPattern: SysBackend.timeGetTime())

    // Reset priority
    if iPriority != THREAD_PRIORITY_ERROR_RETURN {
        SysBackend.SetThreadPriority(hThread, iPriority)
    }

    SysBackend.timeEndPeriod(1)

    var time: UInt32
    time = end &- start
    let coarse = Int32(time / 100000)
    let firsttry = Int32(floor(Double((coarse + 25) / 50)) * 50)
    if abs(firsttry - coarse) < 10 {
        return firsttry
    } else {
        return Int32(floor(floor(Double(coarse + 17) / 33.3) * 33.3))
    }
}

/// Source: oracle/codemp/win32/win_shared.cpp:399
func Sys_GetCPUSpeed() -> Int32 {
    // Port-note: The one caller is win32/win_main.cpp:1469, and WinDed links null/win_main.cpp, so this function is dead.
    var raw_freq: UInt32 // Raw frequency of CPU in MHz
    var norm_freq: UInt32 // Normalized frequency of CPU in MHz.
    var t0 = LARGE_INTEGER(), t1 = LARGE_INTEGER() // Variables for High-Resolution Performance Counter reads

    var freq: UInt32 = 0 // Most current frequ. calculation
    var freq2: UInt32 = 0 // 2nd most current frequ. calc.
    var freq3: UInt32 = 0 // 3rd most current frequ. calc.

    var total: UInt32 // Sum of previous three frequency calculations
    var tries: Int32 = 0 // Number of times a calculation has been made on this call to cpuspeed
    var total_cycles: UInt32 = 0, cycles: UInt32 // Clock cycles elapsed during test
    var stamp0: UInt32 = 0, stamp1: UInt32 = 0 // Time Stamp Variable for beginning and end  of test
    var total_ticks: UInt32 = 0, ticks: UInt32 // Microseconds elapsed during test
    var count_freq = LARGE_INTEGER() // High Resolution Performance Counter frequency

    var iPriority: Int32
    let hThread = SysBackend.GetCurrentThread()

    if !SysBackend.QueryPerformanceFrequency(&count_freq) {
        return Sys_GetCPUSpeedOld() //should never happen
    }

    // On processors supporting the Read
    //   Time Stamp opcode, compare elapsed
    //   time on the High-Resolution Counter
    //   with elapsed cycles on the Time
    //   Stamp Register.

    repeat { // This do loop runs up to 20 times or until the average of the previous
        //   three calculated frequencies is within 1 MHz of each of the
        //   individual calculated frequencies. This resampling increases the
        //   accuracy of the results since outside factors could affect this calculation

        tries += 1 // Increment number of times sampled on this call to cpuspeed

        freq3 = freq2 // Shift frequencies back to make
        freq2 = freq //   room for new frequency measurement

        SysBackend.QueryPerformanceCounter(&t0) // Get high-resolution performance counter time

        t1 = t0 // Set Initial time

        iPriority = SysBackend.GetThreadPriority(hThread)
        if iPriority != THREAD_PRIORITY_ERROR_RETURN {
            SysBackend.SetThreadPriority(hThread, THREAD_PRIORITY_TIME_CRITICAL)
        }

        while t1.LowPart &- t0.LowPart < 50 {
            // Loop until 50 ticks have passed since last read of hi-res counter. This accounts for overhead later.
            SysBackend.QueryPerformanceCounter(&t1)
            // AI: Raven reads the x86 time-stamp counter with an inline `rdtsc` block. The backend reads the monotonic clock of the platform in milliseconds.
            // With this clock, each `freq` is 0 and the function returns 0.
            stamp0 = UInt32(bitPattern: SysBackend.timeGetTime())
        }

        t0 = t1 // Reset Initial Time

        while t1.LowPart &- t0.LowPart < 2000 {
            // Loop until enough ticks have passed since last read of hi-res counter. This allows for elapsed time for sampling.
            SysBackend.QueryPerformanceCounter(&t1)
            // AI: Raven reads the x86 time-stamp counter with an inline `rdtsc` block. The backend reads the monotonic clock of the platform in milliseconds.
            stamp1 = UInt32(bitPattern: SysBackend.timeGetTime())
        }

        if iPriority != THREAD_PRIORITY_ERROR_RETURN { // Reset priority
            SysBackend.SetThreadPriority(hThread, iPriority)
        }

        cycles = stamp1 &- stamp0 // Number of internal clock cycles is difference between two time stamp readings.

        ticks = t1.LowPart &- t0.LowPart
        // Number of external ticks is difference between two hi-res counter reads.

        // Note that some seemingly arbitrary mulitplies and
        //   divides are done below. This is to maintain a
        //   high level of precision without truncating the
        //   most significant data. According to what value
        //   ITERATIIONS is set to, these multiplies and
        //   divides might need to be shifted for optimal
        //   precision.

        ticks = ticks &* 100000 // Convert ticks to hundred thousandths of a tick

        ticks = ticks / (count_freq.LowPart / 10)
        // Hundred Thousandths of a Ticks / ( 10 ticks/second ) = microseconds (us)

        total_ticks &+= ticks
        total_cycles &+= cycles

        if ticks % count_freq.LowPart > count_freq.LowPart / 2 {
            ticks &+= 1 // Round up if necessary
        }

        if ticks == 0 {
            ticks &+= 1 // prevent DIV by ZERO
        }

        freq = cycles / ticks // Cycles / us  = MHz

        if cycles % ticks > ticks / 2 {
            freq &+= 1 // Round up if necessary
        }

        total = (freq &+ freq2 &+ freq3) // Total last three frequency calculations

        // MSVC hands each `unsigned long` difference to the `int` abs of stdlib.h, so the bits read as an `int`.
        // Port-note: Rule 19. Raven's abs of INT_MIN is undefined, and the Swift abs traps there.
    } while (tries < 3) ||
        (tries < 20) &&
        ((abs(Int32(bitPattern: 3 &* freq &- total)) > 3 * TOLERANCE) ||
            (abs(Int32(bitPattern: 3 &* freq2 &- total)) > 3 * TOLERANCE) ||
            (abs(Int32(bitPattern: 3 &* freq3 &- total)) > 3 * TOLERANCE))
    // Compare last three calculations to average of last three calculations.

    if total_ticks == 0 {
        total_ticks &+= 1 // prevent DIV by ZERO
    }

    // Try one more significant digit.
    freq3 = (total_cycles &* 10) / total_ticks
    freq2 = (total_cycles &* 100) / total_ticks

    if freq2 &- (freq3 &* 10) >= UInt32(ROUND_THRESHOLD) {
        freq3 &+= 1
    }

    raw_freq = total_cycles / total_ticks
    norm_freq = raw_freq

    freq = raw_freq &* 10
    if (freq3 &- freq) >= UInt32(ROUND_THRESHOLD) {
        norm_freq &+= 1
    }

    return Int32(bitPattern: norm_freq)
}
