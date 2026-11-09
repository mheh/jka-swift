import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/null/null_snddma.cpp:7
// Raven wrote: qboolean gbInsideLoadSound = qfalse
let gbInsideLoadSound: Bool = false

/// Source: oracle/codemp/null/null_snddma.cpp:9
func SNDDMA_Init() -> Bool {
    return false
}

/// Source: oracle/codemp/null/null_snddma.cpp:14
func SNDDMA_GetDMAPos() -> Int32 {
    return 0
}

/// Source: oracle/codemp/null/null_snddma.cpp:19
func SNDDMA_Shutdown() {
}

/// Source: oracle/codemp/null/null_snddma.cpp:23
func SNDDMA_BeginPainting() {
}

/// Source: oracle/codemp/null/null_snddma.cpp:27
func SNDDMA_Submit() {
}

/// Source: oracle/codemp/null/null_snddma.cpp:31
func S_RegisterSound(_ name: String) -> JKAShared.sfxHandle_t {
    return 0
}

/// Source: oracle/codemp/null/null_snddma.cpp:35
func S_StartLocalSound(_ sfxHandle: JKAShared.sfxHandle_t, _ channelNum: Int32) {
}

/// Source: oracle/codemp/null/null_snddma.cpp:38
func S_ClearSoundBuffer() {
}

/// Source: oracle/codemp/null/null_snddma.cpp:41
func SND_RegisterAudio_LevelLoadEnd(_ something: Bool) -> Bool {
    return false
}

/// Source: oracle/codemp/null/null_snddma.cpp:46
func SND_FreeOldestSound() -> Int32 {
    return 0
}
