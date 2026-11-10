import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/l_memory.cpp:23
let MEM_ID = 0x12345678 as Int32

/// Source: oracle/codemp/botlib/l_memory.cpp:24
let HUNK_ID = 0x87654321 as UInt32

/// Source: oracle/codemp/botlib/l_memory.cpp:26
// Raven wrote: int allocatedmemory
let allocatedmemory: Int32 = 0

/// Source: oracle/codemp/botlib/l_memory.cpp:27
// Raven wrote: int totalmemorysize
let totalmemorysize: Int32 = 0

/// Source: oracle/codemp/botlib/l_memory.cpp:28
// Raven wrote: int numblocks
let numblocks: Int32 = 0

/// Source: oracle/codemp/botlib/l_memory.cpp:325
func GetMemory(_ size: UInt32) -> UnsafeMutableRawPointer? {
    // Port-note: botimport.runGetMemory returns nothing through its run method, so the body has no address of the block, row BL1.
    // TODO: Port GetMemory
    portMissing("GetMemory", source: "oracle/codemp/botlib/l_memory.cpp:325")
}

/// Source: oracle/codemp/botlib/l_memory.cpp:346
func GetClearedMemory(_ size: UInt32) -> UnsafeMutableRawPointer {
    let ptr = GetMemory(size)
    // AI: Raven clears the block through its `void *`. The call clears a Slots of bytes over the block.
    Com_Memset(Slots<byte>(scalars: ptr!, count: Int(size)), 0, size)
    return ptr!
}

/// Source: oracle/codemp/botlib/l_memory.cpp:367
func GetHunkMemory(_ size: UInt32) -> UnsafeMutableRawPointer? {
    // Port-note: botimport.runHunkAlloc returns nothing through its run method, so the body has no address of the block, row BL1.
    // TODO: Port GetHunkMemory
    portMissing("GetHunkMemory", source: "oracle/codemp/botlib/l_memory.cpp:367")
}

/// Source: oracle/codemp/botlib/l_memory.cpp:388
func GetClearedHunkMemory(_ size: UInt32) -> UnsafeMutableRawPointer {
    let ptr = GetHunkMemory(size)
    // AI: Raven clears the block through its `void *`. The call clears a Slots of bytes over the block.
    Com_Memset(Slots<byte>(scalars: ptr!, count: Int(size)), 0, size)
    return ptr!
}

/// Source: oracle/codemp/botlib/l_memory.cpp:325
/// This overload is the guide's form for an `int` argument to an `unsigned long` parameter, and it converts the value once.
func GetMemory(_ size: Int32) -> UnsafeMutableRawPointer? {
    GetMemory(UInt32(bitPattern: size))
}

/// Source: oracle/codemp/botlib/l_memory.cpp:346
/// This overload is the guide's form for an `int` argument to an `unsigned long` parameter, and it converts the value once.
func GetClearedMemory(_ size: Int32) -> UnsafeMutableRawPointer {
    GetClearedMemory(UInt32(bitPattern: size))
}

/// Source: oracle/codemp/botlib/l_memory.cpp:367
/// This overload is the guide's form for an `int` argument to an `unsigned long` parameter, and it converts the value once.
func GetHunkMemory(_ size: Int32) -> UnsafeMutableRawPointer? {
    GetHunkMemory(UInt32(bitPattern: size))
}

/// Source: oracle/codemp/botlib/l_memory.cpp:388
/// This overload is the guide's form for an `int` argument to an `unsigned long` parameter, and it converts the value once.
func GetClearedHunkMemory(_ size: Int32) -> UnsafeMutableRawPointer {
    GetClearedHunkMemory(UInt32(bitPattern: size))
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_memory.cpp:406
func FreeMemory(_ ptr: OpaquePointer?) {
    let memid: Slots<UInt32>

    memid = Slots<UInt32>(wordBefore: ptr!)

    if memid[0] == MEM_ID {
        // AI: Raven hands the `unsigned long *` of the word to the import. The call hands the handle of the word.
        botimport.runFreeMemory(OpaquePointer(memid.base))
    } //end if
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_memory.cpp:423
func AvailableMemory() -> Int32 {
    return botimport.runAvailableMemory()
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_memory.cpp:433
func PrintUsedMemorySize() {
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_memory.cpp:442
func PrintMemoryLabels() {
}
