import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/null/null_glimp.cpp:42
// TODO: Port global qwglSwapIntervalEXT
// Raven wrote: qboolean ( * qwglSwapIntervalEXT)( int interval )
// No table row for `qboolean (*)(int)`.

/// Source: oracle/codemp/null/null_glimp.cpp:43
// TODO: Port global qglMultiTexCoord2fARB
// Raven wrote: void ( * qglMultiTexCoord2fARB )( GLenum texture, float s, float t )
// No table row for `void (*)(int, float, float)`.

/// Source: oracle/codemp/null/null_glimp.cpp:44
// TODO: Port global qglActiveTextureARB
// Raven wrote: void ( * qglActiveTextureARB )( GLenum texture )
// No table row for `void (*)(int)`.

/// Source: oracle/codemp/null/null_glimp.cpp:45
// TODO: Port global qglClientActiveTextureARB
// Raven wrote: void ( * qglClientActiveTextureARB )( GLenum texture )
// No table row for `void (*)(int)`.

/// Source: oracle/codemp/null/null_glimp.cpp:48
// TODO: Port global qglLockArraysEXT
// Raven wrote: void ( * qglLockArraysEXT)( int, int)
// No table row for `void (*)(int, int)`.

/// Source: oracle/codemp/null/null_glimp.cpp:49
// TODO: Port global qglUnlockArraysEXT
// Raven wrote: void ( * qglUnlockArraysEXT) ( void )
// No table row for `void (*)()`.

/// Source: oracle/codemp/null/null_glimp.cpp:52
public func GLimp_EndFrame() {
}

/// Source: oracle/codemp/null/null_glimp.cpp:55
public func GLimp_Init() {
}

/// Source: oracle/codemp/null/null_glimp.cpp:59
public func GLimp_Shutdown() {
}

/// Source: oracle/codemp/null/null_glimp.cpp:62
public func GLimp_EnableLogging(_ enable: Bool) {
}

/// Source: oracle/codemp/null/null_glimp.cpp:65
public func GLimp_LogComment(_ comment: String) {
}

/// Source: oracle/codemp/null/null_glimp.cpp:68
public func QGL_Init(_ dllname: String) -> Bool {
    return true
}

/// Source: oracle/codemp/null/null_glimp.cpp:72
public func QGL_Shutdown() {
}
