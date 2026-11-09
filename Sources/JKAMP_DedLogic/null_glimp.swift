import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/null/null_glimp.cpp:42
// Port-note: row Z6. No file of this unit reads the pointer, and the renderer files that read it are stage E5.
// TODO: Port global qwglSwapIntervalEXT
// Raven wrote: qboolean ( * qwglSwapIntervalEXT)( int interval )
// No table row for `qboolean (*)(int)`.

/// Source: oracle/codemp/null/null_glimp.cpp:43
// Port-note: row Z6. No file of this unit reads the pointer, and the renderer files that read it are stage E5.
// TODO: Port global qglMultiTexCoord2fARB
// Raven wrote: void ( * qglMultiTexCoord2fARB )( GLenum texture, float s, float t )
// No table row for `void (*)(int, float, float)`.

/// Source: oracle/codemp/null/null_glimp.cpp:44
// Port-note: row Z6. No file of this unit reads the pointer, and the renderer files that read it are stage E5.
// TODO: Port global qglActiveTextureARB
// Raven wrote: void ( * qglActiveTextureARB )( GLenum texture )
// No table row for `void (*)(int)`.

/// Source: oracle/codemp/null/null_glimp.cpp:45
// Port-note: row Z6. No file of this unit reads the pointer, and the renderer files that read it are stage E5.
// TODO: Port global qglClientActiveTextureARB
// Raven wrote: void ( * qglClientActiveTextureARB )( GLenum texture )
// No table row for `void (*)(int)`.

/// Source: oracle/codemp/null/null_glimp.cpp:48
// Port-note: row Z6. No file of this unit reads the pointer, and the renderer files that read it are stage E5.
// TODO: Port global qglLockArraysEXT
// Raven wrote: void ( * qglLockArraysEXT)( int, int)
// No table row for `void (*)(int, int)`.

/// Source: oracle/codemp/null/null_glimp.cpp:49
// Port-note: row Z6. No file of this unit reads the pointer, and the renderer files that read it are stage E5.
// TODO: Port global qglUnlockArraysEXT
// Raven wrote: void ( * qglUnlockArraysEXT) ( void )
// No table row for `void (*)()`.

/// Source: oracle/codemp/null/null_glimp.cpp:52
func GLimp_EndFrame() {
}

/// Source: oracle/codemp/null/null_glimp.cpp:55
func GLimp_Init() {
}

/// Source: oracle/codemp/null/null_glimp.cpp:59
func GLimp_Shutdown() {
}

/// Source: oracle/codemp/null/null_glimp.cpp:62
func GLimp_EnableLogging(_ enable: Bool) {
}

/// Source: oracle/codemp/null/null_glimp.cpp:65
func GLimp_LogComment(_ comment: String) {
}

/// Source: oracle/codemp/null/null_glimp.cpp:68
func QGL_Init(_ dllname: String) -> Bool {
    return true
}

/// Source: oracle/codemp/null/null_glimp.cpp:72
func QGL_Shutdown() {
}
