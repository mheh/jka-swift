import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// leave these two as standard mallocs for the moment, there's something weird happening in ICARUS...
//
/// Source: oracle/codemp/icarus/Memory.cpp:8
func ICARUS_Malloc(_ iSize: Int32) -> UnsafeMutableRawPointer {
    //return gi.Malloc(iSize, TAG_ICARUS);
    //return malloc(iSize);
    return Z_Malloc(iSize, TAG_ICARUS5, false)
}

/// Source: oracle/codemp/icarus/Memory.cpp:15
func ICARUS_Free(_ pMem: OpaquePointer?) {
    //gi.Free(pMem);
    //free(pMem);
    Z_Free(pMem)
}
