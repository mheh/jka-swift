import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_mem.c:11
let POOLSIZE = (256 * 1024) as Int32

/// Source: oracle/codemp/game/g_mem.c:13
// Raven wrote: static char memoryPool[POOLSIZE]
// A hand property of the state object, `world.memoryPool`, by the HAND_VARS ruling.

/// Source: oracle/codemp/game/g_mem.c:14
var allocPoint: Int32 {
    get { world.variables.allocPoint }
    set { world.variables.allocPoint = newValue }
}

/// Source: oracle/codemp/game/g_mem.c:16
func G_Alloc(_ size: Int32) -> UnsafeMutableRawPointer {
    let p: UnsafeMutableRawPointer

    if g_debugAlloc.integer != 0 {
        G_Printf("G_Alloc of %i bytes (%i left)\n", size, POOLSIZE - allocPoint - ((size + 31) & ~31))
    }

    if allocPoint + size > POOLSIZE {
        G_Error("G_Alloc: failed on allocation of %i bytes\n", size) // bk010103 - was %u, but is signed
    }

    p = world.memoryPool + allocPoint

    allocPoint += (size + 31) & ~31

    return p
}

/// Source: oracle/codemp/game/g_mem.c:35
func G_InitMemory() {
    allocPoint = 0
}

/// Source: oracle/codemp/game/g_mem.c:39
func Svcmd_GameMem_f() {
    G_Printf("Game memory status: %i out of %i bytes allocated\n", allocPoint, POOLSIZE)
}
