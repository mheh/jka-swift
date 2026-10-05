import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_mem.c:11
let POOLSIZE = (256 * 1024) as Int32

/// Source: oracle/codemp/game/g_mem.c:13
var memoryPool: JKAShared.CharBuf {
    get { world.variables.memoryPool }
    set { world.variables.memoryPool = newValue }
}

/// Source: oracle/codemp/game/g_mem.c:14
var allocPoint: Int32 {
    get { world.variables.allocPoint }
    set { world.variables.allocPoint = newValue }
}

/// Source: oracle/codemp/game/g_mem.c:16
func G_Alloc(_ size: Int32) -> UnsafeMutableRawPointer {
    // Port-note: A pointer local `char * p` with no view.
    // Raven wrote: char *p;
    portMissing("G_Alloc", source: "oracle/codemp/game/g_mem.c:16")

    if g_debugAlloc.integer != 0 {
        G_Printf("G_Alloc of %i bytes (%i left)\n", size, POOLSIZE - allocPoint - ((size + 31) & ~31))
    }

    if allocPoint + size > POOLSIZE {
        G_Error("G_Alloc: failed on allocation of %i bytes\n", size) // bk010103 - was %u, but is signed
        // Port-note: Raven returns NULL, and the function returns a `UnsafeMutableRawPointer`.
        // Raven wrote: return NULL
        portMissing("G_Alloc", source: "oracle/codemp/game/g_mem.c:16")
    }

    // Port-note: A store into `p`, a local the draft left as a hole.
    // Raven wrote: p = &memoryPool[allocPoint]
    portMissing("G_Alloc", source: "oracle/codemp/game/g_mem.c:16")

    allocPoint += (size + 31) & ~31

    // Port-note: A read of `p`, a local the draft left as a hole.
    // Raven wrote: return p
    portMissing("G_Alloc", source: "oracle/codemp/game/g_mem.c:16")
}

/// Source: oracle/codemp/game/g_mem.c:35
func G_InitMemory() {
    allocPoint = 0
}

/// Source: oracle/codemp/game/g_mem.c:39
func Svcmd_GameMem_f() {
    G_Printf("Game memory status: %i out of %i bytes allocated\n", allocPoint, POOLSIZE)
}
