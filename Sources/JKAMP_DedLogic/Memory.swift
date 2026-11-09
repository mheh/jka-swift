import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// leave these two as standard mallocs for the moment, there's something weird happening in ICARUS...
//
/// Source: oracle/codemp/icarus/Memory.cpp:8
// TODO: Port signature
// Raven wrote: void *ICARUS_Malloc(int iSize)
// No table row for the return `void *`.
func ICARUS_Malloc() -> Never {
    // TODO: Port ICARUS_Malloc
    portMissing("ICARUS_Malloc", source: "oracle/codemp/icarus/Memory.cpp:8")
}

/// Source: oracle/codemp/icarus/Memory.cpp:15
func ICARUS_Free(_ pMem: OpaquePointer?) {
    //gi.Free(pMem);
    //free(pMem);
    Z_Free(pMem)
}
