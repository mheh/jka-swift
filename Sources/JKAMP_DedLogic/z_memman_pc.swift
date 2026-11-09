import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:14
/// Raven's data table, a hand property of `EngineWorld`.
var psTagStrings: [String] {
    get { world.psTagStrings }
    set { world.psTagStrings = newValue }
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:28
let ZONE_MAGIC = 0x21436587 as Int32

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:75
var com_validateZone: JKAMP.Cvar? {
    get { world.variables.com_validateZone }
    set { world.variables.com_validateZone = newValue }
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:77
var TheZone: Zone { world.storage.TheZone }

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:139
// Raven wrote: StaticZeroMem_t gZeroMalloc
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:141
// Raven wrote: StaticMem_t gEmptyString
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:143
// Raven wrote: StaticMem_t gNumberString[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:156
var gbMemFreeupOccured: Bool {
    get { world.variables.gbMemFreeupOccured }
    set { world.variables.gbMemFreeupOccured = newValue }
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:626
var hunk_tag: JKAShared.memtag_t {
    get { world.variables.hunk_tag }
    set { world.variables.hunk_tag = newValue }
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:82
func Z_Validate() {
    if com_validateZone == nil || com_validateZone!.integer == 0 {
        return
    }

    var pMemory = TheZone.Header.pNext
    while let current = pMemory {
        if current.iMagic != ZONE_MAGIC {
            Com_Error(ERR_FATAL, "Z_Validate(): Corrupt zone header!")
        }

        if ZoneTailFromHeader(current).iMagic != ZONE_MAGIC {
            Com_Error(ERR_FATAL, "Z_Validate(): Corrupt zone tail!")
        }

        pMemory = current.pNext
    }
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:157
func Z_Malloc(_ iSize: Int32, _ eTag: JKAShared.memtag_t, _ bZeroit: Bool = false, _ iUnusedAlign: Int32 = 4) -> UnsafeMutableRawPointer {
    gbMemFreeupOccured = false

    if iSize == 0 {
        let pMemory = ZoneHeader(gZeroMalloc)
        return pMemory.block
    }

    // Add in tracking info
    //
    let iRealSize: Int32 = (iSize + Int32(ZoneHeader.byteCount) + Int32(ZoneTail.byteCount))

    // Allocate a chunk...
    //
    var pMemory: ZoneHeader? = nil
    while pMemory == nil {
        if bZeroit {
            pMemory = ZoneBackend.calloc(iRealSize, 1)
        } else {
            pMemory = ZoneBackend.malloc(iRealSize)
        }
        if pMemory == nil {
            // new bit, if we fail to malloc memory, try dumping some of the cached stuff that's non-vital and try again...
            //

            // ditch the BSP cache...
            //
            if CM_DeleteCachedMap(false) {
                gbMemFreeupOccured = true
                continue // we've just ditched a whole load of memory, so try again with the malloc
            }


            // ditch any sounds not used on this level...
            //
            if SND_RegisterAudio_LevelLoadEnd(true) {
                gbMemFreeupOccured = true
                continue // we've dropped at least one sound, so try again with the malloc
            }

            // ditch the model-binaries cache...  (must be getting desperate here!)
            //
            // Port-note: `RE_RegisterModels_LevelLoadEnd` of tr_model.cpp has no Swift stub, because the renderer files are a later port stage.
            // Raven wrote: if (RE_RegisterModels_LevelLoadEnd(qtrue)) { gbMemFreeupOccured = qtrue; continue; }
            portMissing("Z_Malloc", source: "oracle/codemp/qcommon/z_memman_pc.cpp:157")

            // as a last panic measure, dump all the audio memory, but not if we're in the audio loader
            //	(which is annoying, but I'm not sure how to ensure we're not dumping any memory needed by the sound
            //	currently being loaded if that was the case)...
            //
            // note that this keeps querying until it's freed up as many bytes as the requested size, but freeing
            //	several small blocks might not mean that one larger one is satisfiable after freeup, however that'll
            //	just make it go round again and try for freeing up another bunch of blocks until the total is satisfied
            //	again (though this will have freed twice the requested amount in that case), so it'll either work
            //	eventually or not free up enough and drop through to the final ERR_DROP. No worries...
            //
            if !gbInsideLoadSound {
                var iBytesFreed: Int32 = SND_FreeOldestSound()
                if iBytesFreed != 0 {
                    var iTheseBytesFreed: Int32 = 0
                    while true {
                        iTheseBytesFreed = SND_FreeOldestSound()
                        if !(iTheseBytesFreed != 0) { break }
                        iBytesFreed += iTheseBytesFreed
                        if iBytesFreed >= iRealSize {
                            break // early opt-out since we've managed to recover enough (mem-contiguity issues aside)
                        }
                    }
                    gbMemFreeupOccured = true
                    continue
                }
            }

            // sigh, dunno what else to try, I guess we'll have to give up and report this as an out-of-mem error...
            //
            // findlabel:  "recovermem"

            Com_Printf(S_COLOR_RED + "Z_Malloc(): Failed to alloc %d bytes (TAG_%s) !!!!!\n", iSize, psTagStrings[eTag])
            Z_Details_f()
            Com_Error(ERR_FATAL, "(Repeat): Z_Malloc(): Failed to alloc %d bytes (TAG_%s) !!!!!\n", iSize, psTagStrings[eTag])
        }
    }

    // Link in
    pMemory!.iMagic = ZONE_MAGIC
    pMemory!.eTag = eTag
    pMemory!.iSize = iSize
    pMemory!.pNext = TheZone.Header.pNext
    TheZone.Header.pNext = pMemory
    if pMemory!.pNext != nil {
        pMemory!.pNext!.pPrev = pMemory
    }
    pMemory!.pPrev = TheZone.Header
    //
    // add tail...
    //
    ZoneTailFromHeader(pMemory!).iMagic = ZONE_MAGIC

    // Update stats...
    //
    TheZone.Stats.iCurrent += iSize
    TheZone.Stats.iCount += 1
    TheZone.Stats.iSizesPerTag[eTag] += iSize
    TheZone.Stats.iCountsPerTag[eTag] += 1

    if TheZone.Stats.iCurrent > TheZone.Stats.iPeak {
        TheZone.Stats.iPeak = TheZone.Stats.iCurrent
    }

    Z_Validate() // check for corruption

    let pvReturnMem = pMemory!.block
    return pvReturnMem
}

// used during model cacheing to save an extra malloc, lets us morph the disk-load buffer then
//	just not fs_freefile() it afterwards.
//
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:313
func Z_MorphMallocTag(_ pvAddress: OpaquePointer?, _ eDesiredTag: JKAShared.memtag_t) {
    let pMemory = ZoneHeader(block: pvAddress!)

    if pMemory.iMagic != ZONE_MAGIC {
        Com_Error(ERR_FATAL, "Z_MorphMallocTag(): Not a valid zone header!")
        // won't get here
    }

    // DEC existing tag stats...
    //
    //	TheZone.Stats.iCurrent	- unchanged
    //	TheZone.Stats.iCount	- unchanged
    TheZone.Stats.iSizesPerTag[pMemory.eTag] -= pMemory.iSize
    TheZone.Stats.iCountsPerTag[pMemory.eTag] -= 1

    // morph...
    //
    pMemory.eTag = eDesiredTag

    // INC new tag stats...
    //
    //	TheZone.Stats.iCurrent	- unchanged
    //	TheZone.Stats.iCount	- unchanged
    TheZone.Stats.iSizesPerTag[pMemory.eTag] += pMemory.iSize
    TheZone.Stats.iCountsPerTag[pMemory.eTag] += 1
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:342
private func Zone_FreeBlock(_ pMemory: ZoneHeader) {
    if pMemory.eTag != TAG_STATIC { // belt and braces, should never hit this though
        // Update stats...
        //
        TheZone.Stats.iCount -= 1
        TheZone.Stats.iCurrent -= pMemory.iSize
        TheZone.Stats.iSizesPerTag[pMemory.eTag] -= pMemory.iSize
        TheZone.Stats.iCountsPerTag[pMemory.eTag] -= 1

        // Sanity checks...
        //

        // Unlink and free...
        //
        pMemory.pPrev!.pNext = pMemory.pNext
        if pMemory.pNext != nil {
            pMemory.pNext!.pPrev = pMemory.pPrev
        }
        ZoneBackend.free(pMemory)
    }
}

// stats-query function to ask how big a malloc is...
//
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:383
func Z_Size(_ pvAddress: OpaquePointer?) -> Int32 {
    let pMemory = ZoneHeader(block: pvAddress!)

    if pMemory.eTag == TAG_STATIC {
        return 0 // kind of
    }

    if pMemory.iMagic != ZONE_MAGIC {
        Com_Error(ERR_FATAL, "Z_Size(): Not a valid zone header!")
        // won't get here
    }

    return pMemory.iSize
}

// Frees a block of memory...
//
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:404
func Z_Free(_ pvAddress: OpaquePointer?) {
    if pvAddress == nil { // I've put this in as a safety measure because of some bits of #ifdef BSPC stuff	-Ste.
        //Com_Error(ERR_FATAL, "Z_Free(): NULL arg");
        return
    }

    let pMemory = ZoneHeader(block: pvAddress!)

    if pMemory.eTag == TAG_STATIC {
        return
    }

    if pMemory.iMagic != ZONE_MAGIC {
        Com_Error(ERR_FATAL, "Z_Free(): Corrupt zone header!")
    }
    if ZoneTailFromHeader(pMemory).iMagic != ZONE_MAGIC {
        Com_Error(ERR_FATAL, "Z_Free(): Corrupt zone tail!")
    }

    Zone_FreeBlock(pMemory)
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:446
func Z_MemSize(_ eTag: JKAShared.memtag_t) -> Int32 {
    return TheZone.Stats.iSizesPerTag[eTag]
}

// Frees all blocks with the specified tag...
//
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:453
func Z_TagFree(_ eTag: JKAShared.memtag_t) {
    //#ifdef _DEBUG
    //	int iZoneBlocks = TheZone.Stats.iCount;
    //#endif

    var pMemory = TheZone.Header.pNext
    while let current = pMemory {
        let pNext = current.pNext
        if (eTag == TAG_ALL) || (current.eTag == eTag) {
            Zone_FreeBlock(current)
        }
        pMemory = pNext
    }

    // these stupid pragmas don't work here???!?!?!
    //
    //#ifdef _DEBUG
    //#pragma warning( disable : 4189)
    //	int iBlocksFreed = iZoneBlocks - TheZone.Stats.iCount;
    //#pragma warning( default : 4189)
    //#endif
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:480
func S_Malloc(_ iSize: Int32) -> UnsafeMutableRawPointer {
    return Z_Malloc(iSize, TAG_SMALL)
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:510
private func Z_Stats_f() {
    Com_Printf("\nThe zone is using %d bytes (%.2fMB) in %d memory blocks\n", TheZone.Stats.iCurrent, Float(TheZone.Stats.iCurrent) / 1024.0 / 1024.0, TheZone.Stats.iCount)

    Com_Printf("The zone peaked at %d bytes (%.2fMB)\n", TheZone.Stats.iPeak, Float(TheZone.Stats.iPeak) / 1024.0 / 1024.0)
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:526
private func Z_Details_f() {
    Com_Printf("---------------------------------------------------------------------------\n")
    Com_Printf("%20s %9s\n", "Zone Tag", "Bytes")
    Com_Printf("%20s %9s\n", "--------", "-----")
    var i: Int32 = 0
    while i < TAG_COUNT {
        let iThisCount: Int32 = TheZone.Stats.iCountsPerTag[i]
        let iThisSize: Int32 = TheZone.Stats.iSizesPerTag[i]

        if iThisCount != 0 {
            // can you believe that using %2.2f as a format specifier doesn't bloody work?
            //	It ignores the left-hand specifier. Sigh, now I've got to do shit like this...
            //
            let fSize: Float = Float((iThisSize)) / 1024.0 / 1024.0
            let iSize: Int32 = Int32(fSize)
            let iRemainder: Int32 = Int32(100.0 * (fSize - floor(fSize)))
            Com_Printf("%20s %9d (%2d.%02dMB) in %6d blocks (%9d average)\n", psTagStrings[i], iThisSize, iSize, iRemainder, iThisCount, iThisSize / iThisCount)
        }
        i += 1
    }
    Com_Printf("---------------------------------------------------------------------------\n")

    Z_Stats_f()
}

// Shuts down the zone memory system and frees up all memory
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:558
func Com_ShutdownZoneMemory() {
    //	Com_Printf("Shutting down zone memory .....\n");

    Cmd_RemoveCommand("zone_stats")
    Cmd_RemoveCommand("zone_details")

    if TheZone.Stats.iCount != 0 {
        Com_Printf("Automatically freeing %d blocks making up %d bytes\n", TheZone.Stats.iCount, TheZone.Stats.iCurrent)
        Z_TagFree(TAG_ALL)
    }
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:577
func Com_InitZoneMemory() {
    TheZone.clear()
    TheZone.Header.iMagic = ZONE_MAGIC

    //#ifdef _DEBUG
    //	com_validateZone = Cvar_Get("com_validateZone", "1", 0);
    //#else
    com_validateZone = Cvar_Get("com_validateZone", "0", 0)
    //#endif

    Cmd_AddCommand("zone_stats", Z_Stats_f)
    Cmd_AddCommand("zone_details", Z_Details_f)
}

/**
```
========================
CopyString

 NOTE:	never write over the memory CopyString returns because
		memory from a memstatic_t might be returned
========================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:607
func CopyString(_ `in`: String) -> String {
    if `in`.isEmpty {
        // AI: Raven returns the address of the bytes after the header of gEmptyString. The function returns the text of those bytes.
        return String(CharBuf(bytes: gEmptyString.mem.map { CChar(bitPattern: $0) }))
    } else if CharBuf(`in`)[1] == 0 {
        if CharBuf(`in`)[0] >= Int32(ascii: "0") && CharBuf(`in`)[0] <= Int32(ascii: "9") {
            // AI: Raven returns the address of the bytes after the header of one gNumberString block. The function returns the text of those bytes.
            return String(CharBuf(bytes: gNumberString[CharBuf(`in`)[0] - Int32(ascii: "0")].mem.map { CChar(bitPattern: $0) }))
        }
    }

    // AI: Raven copies the text into the S_Malloc block and returns the block. The call stays for the zone count, and the function returns the text.
    _ = S_Malloc(strlen(`in`) + 1)
    return `in`
}

/**
```
===============
Com_TouchMemory

Touch all known used data to make sure it is paged in
===============
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:636
func Com_TouchMemory() {
    //	int		start, end;
    var i: Int32
    var j: Int32
    var sum: Int32

    //	start = Sys_Milliseconds();
    Z_Validate()

    sum = 0

    var pMemory = TheZone.Header.pNext
    while let current = pMemory {
        j = current.iSize >> 2
        // AI: Raven reads the block through a byte pointer that he casts to int * at the read. The local is a Slots<Int32> over the block.
        let pMem = Slots<Int32>(scalars: current.block, count: Int(j))
        i = 0
        while i < j {
            // Port-note: Raven's int sum overflows on a large zone, which C leaves undefined. The sum wraps at 32 bits.
            sum &+= pMem[i]
            i += 64
        }

        pMemory = current.pNext
    }

    //	end = Sys_Milliseconds();
    //	Com_Printf( "Com_TouchMemory: %i msec\n", end - start );
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:664
func Com_TheHunkMarkHasBeenMade() -> Bool {
    if hunk_tag == TAG_HUNK_MARK2 {
        return true
    }
    return false
}

/**
```
=================
Com_InitHunkMemory
=================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:678
func Com_InitHunkMemory() {
    hunk_tag = TAG_HUNK_MARK1
    Hunk_Clear()
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:683
func Com_ShutdownHunkMemory() {
    //Er, ok. Clear it then I guess.
    Z_TagFree(TAG_HUNK_MARK1)
    Z_TagFree(TAG_HUNK_MARK2)
}

/**
```
====================
Hunk_MemoryRemaining
====================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:695
func Hunk_MemoryRemaining() -> Int32 {
    return (64 * 1024 * 1024) - (Z_MemSize(TAG_HUNK_MARK1) + Z_MemSize(TAG_HUNK_MARK2)) //Yeah. Whatever. We've got no size now.
}

/**
```
===================
Hunk_SetMark

The server calls this after the level and game VM have been loaded
===================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:706
func Hunk_SetMark() {
    hunk_tag = TAG_HUNK_MARK2
}

/**
```
=================
Hunk_ClearToMark

The client calls this before starting a vid_restart or snd_restart
=================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:717
func Hunk_ClearToMark() {
    //if this is not true then no mark has been made
    Z_TagFree(TAG_HUNK_MARK2)
}

/**
```
=================
Hunk_CheckMark
=================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:727
func Hunk_CheckMark() -> Bool {
    //if( hunk_low.mark || hunk_high.mark ) {
    if hunk_tag != TAG_HUNK_MARK1 {
        return true
    }
    return false
}

/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:752
func Hunk_Clear() {
    SV_ShutdownGameProgs()

    hunk_tag = TAG_HUNK_MARK1
    Z_TagFree(TAG_HUNK_MARK1)
    Z_TagFree(TAG_HUNK_MARK2)

    // Port-note: `R_HunkClearCrap` of tr_model.cpp has no Swift stub, because the renderer files are a later port stage.
    // Raven wrote: R_HunkClearCrap();
    portMissing("Hunk_Clear", source: "oracle/codemp/qcommon/z_memman_pc.cpp:752")

    //	Com_Printf( "Hunk_Clear: reset the hunk ok\n" );
    VM_Clear()

    //See if any ghoul2 stuff was leaked, at this point it should be all cleaned up.
    // Port-note: `g_Ghoul2Allocations`, `g_G2ClientAlloc`, `g_G2ServerAlloc`, and `G2_DEBUG_ReportLeaks` of G2_API.cpp have no Swift home,
    // because the Ghoul2 files are a later port stage.
    // Raven wrote: if (g_Ghoul2Allocations) { Com_Printf("%i bytes leaked by ghoul2 routines (%i client, %i server)\n", g_Ghoul2Allocations, g_G2ClientAlloc, g_G2ServerAlloc); G2_DEBUG_ReportLeaks(); }
    portMissing("Hunk_Clear", source: "oracle/codemp/qcommon/z_memman_pc.cpp:752")
}

/**
```
=================
Hunk_Alloc

Allocate permanent (until the hunk is cleared) memory
=================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:791
func Hunk_Alloc(_ size: Int32, _ preference: JKAMP.ha_pref) -> UnsafeMutableRawPointer {
    return Z_Malloc(size, hunk_tag, true)
}

/**
```
=================
Hunk_AllocateTempMemory

This is used by the file loading system.
Multiple files can be loaded in temporary memory.
When the files-in-use count reaches zero, all temp memory will be deleted
=================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:804
func Hunk_AllocateTempMemory(_ size: Int32) -> UnsafeMutableRawPointer {
    // don't bother clearing, because we are going to load a file over it
    return Z_Malloc(size, TAG_TEMP_HUNKALLOC, false)
}

/**
```
==================
Hunk_FreeTempMemory
==================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:815
func Hunk_FreeTempMemory(_ buf: OpaquePointer?) {
    Z_Free(buf)
}

/**
```
=================
Hunk_ClearTempMemory

The temp space is no longer needed.  If we have left more
touched but unused memory on this side, have future
permanent allocs use this side.
=================
```
*/
/// Source: oracle/codemp/qcommon/z_memman_pc.cpp:830
func Hunk_ClearTempMemory() {
    Z_TagFree(TAG_TEMP_HUNKALLOC)
}
