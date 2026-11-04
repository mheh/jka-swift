import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/win32/win_shared.cpp:416
let TOLERANCE = 1 as Int32

/// Source: oracle/codemp/win32/win_shared.cpp:417
let ROUND_THRESHOLD = 6 as Int32

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
    // TODO: Port Sys_Milliseconds
    portMissing("Sys_Milliseconds", source: "oracle/codemp/win32/win_shared.cpp:22")
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
    // TODO: Port CPUID
    portMissing("CPUID", source: "oracle/codemp/win32/win_shared.cpp:84")
}

/// Source: oracle/codemp/win32/win_shared.cpp:102
private func IsPentium() -> Int32 {
    // TODO: Port IsPentium
    portMissing("IsPentium", source: "oracle/codemp/win32/win_shared.cpp:102")
}

/// Source: oracle/codemp/win32/win_shared.cpp:135
private func Is3DNOW() -> Int32 {
    // TODO: Port Is3DNOW
    portMissing("Is3DNOW", source: "oracle/codemp/win32/win_shared.cpp:135")
}

/// Source: oracle/codemp/win32/win_shared.cpp:174
private func IsKNI() -> Int32 {
    // TODO: Port IsKNI
    portMissing("IsKNI", source: "oracle/codemp/win32/win_shared.cpp:174")
}

/// Source: oracle/codemp/win32/win_shared.cpp:188
private func IsWIL() -> Int32 {
    // TODO: Port IsWIL
    portMissing("IsWIL", source: "oracle/codemp/win32/win_shared.cpp:188")
}

/// Source: oracle/codemp/win32/win_shared.cpp:228
private func IsMMX() -> Int32 {
    // TODO: Port IsMMX
    portMissing("IsMMX", source: "oracle/codemp/win32/win_shared.cpp:228")
}

/// Source: oracle/codemp/win32/win_shared.cpp:241
func Sys_GetProcessorId() -> Int32 {
    // TODO: Port Sys_GetProcessorId
    portMissing("Sys_GetProcessorId", source: "oracle/codemp/win32/win_shared.cpp:241")
}

/// Source: oracle/codemp/win32/win_shared.cpp:293
func Sys_GetCurrentUser() -> String {
    // TODO: Port Sys_GetCurrentUser
    portMissing("Sys_GetCurrentUser", source: "oracle/codemp/win32/win_shared.cpp:293")
}

/// Source: oracle/codemp/win32/win_shared.cpp:314
func Sys_DefaultHomePath() -> String? {
    // TODO: Port Sys_DefaultHomePath
    portMissing("Sys_DefaultHomePath", source: "oracle/codemp/win32/win_shared.cpp:314")
}

/// Source: oracle/codemp/win32/win_shared.cpp:318
func Sys_DefaultInstallPath() -> String {
    // TODO: Port Sys_DefaultInstallPath
    portMissing("Sys_DefaultInstallPath", source: "oracle/codemp/win32/win_shared.cpp:318")
}

/// Source: oracle/codemp/win32/win_shared.cpp:323
func Sys_GetPhysicalMemory() -> Int32 {
    // TODO: Port Sys_GetPhysicalMemory
    portMissing("Sys_GetPhysicalMemory", source: "oracle/codemp/win32/win_shared.cpp:323")
}

/// Source: oracle/codemp/win32/win_shared.cpp:338
func Sys_GetCPUSpeedOld() -> Int32 {
    // TODO: Port Sys_GetCPUSpeedOld
    portMissing("Sys_GetCPUSpeedOld", source: "oracle/codemp/win32/win_shared.cpp:338")
}

/// Source: oracle/codemp/win32/win_shared.cpp:399
func Sys_GetCPUSpeed() -> Int32 {
    // TODO: Port Sys_GetCPUSpeed
    portMissing("Sys_GetCPUSpeed", source: "oracle/codemp/win32/win_shared.cpp:399")
}
