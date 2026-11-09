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
func Sys_SnapVector(_ v: inout Float) {
    // Port-note: Raven steps `float *v` over three floats, and the stub takes one `inout Float`, row "Sys_SnapVector vector" of the win round.
    // TODO: Port Sys_SnapVector
    portMissing("Sys_SnapVector", source: "oracle/codemp/win32/win_shared.cpp:41")
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
    // Port-note: Raven times the x86 rdtsc counter against timeGetTime under a Win32 thread priority, row "CPU speed" of the win round.
    // No file of the WinDed link set calls this function.
    // TODO: Port Sys_GetCPUSpeedOld
    portMissing("Sys_GetCPUSpeedOld", source: "oracle/codemp/win32/win_shared.cpp:338")
}

/// Source: oracle/codemp/win32/win_shared.cpp:399
func Sys_GetCPUSpeed() -> Int32 {
    // Port-note: Raven times the x86 rdtsc counter against the Win32 performance counter, row "CPU speed" of the win round.
    // No file of the WinDed link set calls this function.
    // TODO: Port Sys_GetCPUSpeed
    portMissing("Sys_GetCPUSpeed", source: "oracle/codemp/win32/win_shared.cpp:399")
}
