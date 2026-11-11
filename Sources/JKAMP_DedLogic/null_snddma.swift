import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/null/null_snddma.cpp:7
// Raven wrote: qboolean gbInsideLoadSound = qfalse
let gbInsideLoadSound: Bool = false

/// Source: oracle/codemp/null/null_snddma.cpp:9
public func SNDDMA_Init() -> Bool {
    return false
}

/// Source: oracle/codemp/null/null_snddma.cpp:14
public func SNDDMA_GetDMAPos() -> Int32 {
    return 0
}

/// Source: oracle/codemp/null/null_snddma.cpp:19
public func SNDDMA_Shutdown() {
}

/// Source: oracle/codemp/null/null_snddma.cpp:23
public func SNDDMA_BeginPainting() {
}

/// Source: oracle/codemp/null/null_snddma.cpp:27
public func SNDDMA_Submit() {
}

/// Source: oracle/codemp/null/null_snddma.cpp:31
public func S_RegisterSound(_ name: String) -> JKAShared.sfxHandle_t {
    return 0
}

/// Source: oracle/codemp/null/null_snddma.cpp:35
public func S_StartLocalSound(_ sfxHandle: JKAShared.sfxHandle_t, _ channelNum: Int32) {
}

/// Source: oracle/codemp/null/null_snddma.cpp:38
public func S_ClearSoundBuffer() {
}

/// Source: oracle/codemp/null/null_snddma.cpp:41
public func SND_RegisterAudio_LevelLoadEnd(_ something: Bool) -> Bool {
    return false
}

/// Source: oracle/codemp/null/null_snddma.cpp:46
public func SND_FreeOldestSound() -> Int32 {
    return 0
}
