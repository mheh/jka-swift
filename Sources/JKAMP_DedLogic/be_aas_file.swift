import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_file.cpp:479
var AAS_WriteAASLump_offset: Int32 {
    get { world.variables.AAS_WriteAASLump_offset }
    set { world.variables.AAS_WriteAASLump_offset = newValue }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_file.cpp:37
func AAS_SwapAASData() {
    // Raven swaps each field of the AAS lumps with LittleLong, LittleShort, and LittleFloat.
    // The loops have no line, because each swap of the WinDed arm is its argument.
}

//===========================================================================
// dump the current loaded aas file
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_file.cpp:166
func AAS_DumpAASData() {
    aasworld.numbboxes = 0
    if aasworld.bboxes != nil { FreeMemory(aasworld.bboxes!.handle) }
    aasworld.bboxes = nil
    aasworld.numvertexes = 0
    if aasworld.vertexes != nil { FreeMemory(OpaquePointer(aasworld.vertexes!.base)) }
    aasworld.vertexes = nil
    aasworld.numplanes = 0
    if aasworld.planes != nil { FreeMemory(aasworld.planes!.handle) }
    aasworld.planes = nil
    aasworld.numedges = 0
    if aasworld.edges != nil { FreeMemory(aasworld.edges!.handle) }
    aasworld.edges = nil
    aasworld.edgeindexsize = 0
    if aasworld.edgeindex != nil { FreeMemory(OpaquePointer(aasworld.edgeindex!.base)) }
    aasworld.edgeindex = nil
    aasworld.numfaces = 0
    if aasworld.faces != nil { FreeMemory(aasworld.faces!.handle) }
    aasworld.faces = nil
    aasworld.faceindexsize = 0
    if aasworld.faceindex != nil { FreeMemory(OpaquePointer(aasworld.faceindex!.base)) }
    aasworld.faceindex = nil
    aasworld.numareas = 0
    if aasworld.areas != nil { FreeMemory(aasworld.areas!.handle) }
    aasworld.areas = nil
    aasworld.numareasettings = 0
    if aasworld.areasettings != nil { FreeMemory(aasworld.areasettings!.handle) }
    aasworld.areasettings = nil
    aasworld.reachabilitysize = 0
    if aasworld.reachability != nil { FreeMemory(aasworld.reachability!.handle) }
    aasworld.reachability = nil
    aasworld.numnodes = 0
    if aasworld.nodes != nil { FreeMemory(aasworld.nodes!.handle) }
    aasworld.nodes = nil
    aasworld.numportals = 0
    if aasworld.portals != nil { FreeMemory(aasworld.portals!.handle) }
    aasworld.portals = nil
    aasworld.numportals = 0
    if aasworld.portalindex != nil { FreeMemory(OpaquePointer(aasworld.portalindex!.base)) }
    aasworld.portalindex = nil
    aasworld.portalindexsize = 0
    if aasworld.clusters != nil { FreeMemory(aasworld.clusters!.handle) }
    aasworld.clusters = nil
    aasworld.numclusters = 0
    //
    aasworld.loaded = 0
    aasworld.initialized = 0
    aasworld.savefile = 0
}

//===========================================================================
// allocate memory and read a lump of a AAS file
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_file.cpp:273
func AAS_LoadAASLump(_ fp: JKAShared.fileHandle_t, _ offset: Int32, _ length: Int32, _ lastoffset: inout Int32, _ size: Int32) -> String? {
    // Port-note: Raven returns the raw block of the lump, which the callers cast to a table of disk records, and the signature returns a `String?`, row D12 shape 7.
    // TODO: Port AAS_LoadAASLump
    portMissing("AAS_LoadAASLump", source: "oracle/codemp/botlib/be_aas_file.cpp:273")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_file.cpp:310
func AAS_DData(_ data: Slots<UInt8>, _ size: Int32) {
    var i: Int32

    i = 0
    while i < size {
        data[byte: i] ^= Int32(UInt8(truncatingIfNeeded: i)) * 119
        i += 1
    } //end for
}

//===========================================================================
// load an aas file
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_file.cpp:326
func AAS_LoadAASFile(_ filename: inout JKAShared.CharBuf) -> Int32 {
    // Port-note: AAS_LoadAASLump returns a `String?` where the body casts the block to each lump table, and runFS_FOpenFile takes the `fileHandle_t *` as an OpaquePointer.
    // TODO: Port AAS_LoadAASFile
    portMissing("AAS_LoadAASFile", source: "oracle/codemp/botlib/be_aas_file.cpp:326")
}

/// Source: oracle/codemp/botlib/be_aas_file.cpp:481
func AAS_WriteAASLump(_ fp: JKAShared.fileHandle_t, _ h: AasHeader, _ lumpnum: Int32, _ data: OpaquePointer?, _ length: Int32) -> Int32 {
    var lump: AasLump

    lump = h.lumps[lumpnum]

    // LittleLong of the WinDed arm is its argument.
    lump.fileofs = AAS_WriteAASLump_offset	//LittleLong(ftell(fp));
    lump.filelen = length

    if length > 0 {
        botimport.runFS_Write(data, length, fp)
    } //end if

    AAS_WriteAASLump_offset += length

    return 1
}

//===========================================================================
// aas data is useless after writing to file because it is byte swapped
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_file.cpp:506
func AAS_WriteAASFile(_ filename: inout JKAShared.CharBuf) -> Bool {
    var fp: fileHandle_t = 0

    // Port-note: botimport.Print has no text form in the view, which takes the format as an OpaquePointer.
    portMissing("botimport.Print", source: "oracle/codemp/botlib/be_aas_file.cpp:511")
    //swap the aas data
    AAS_SwapAASData()
    return AasHeader.scratch { header -> Bool in
        //initialize the file header
        // LittleLong of the WinDed arm is its argument.
        header.ident = AASID
        header.version = AASVERSION
        header.bspchecksum = aasworld.bspchecksum
        //open a new file
        // Port-note: runFS_FOpenFile takes the `fileHandle_t *` as an OpaquePointer, so the handle has no way back.
        portMissing("botimport.FS_FOpenFile", source: "oracle/codemp/botlib/be_aas_file.cpp:520")
        if fp == 0 {
            // Port-note: botimport.Print has no text form in the view, which takes the format as an OpaquePointer.
            portMissing("botimport.Print", source: "oracle/codemp/botlib/be_aas_file.cpp:523")
            return false
        } //end if
        //write the header
        botimport.runFS_Write(header.handle, Int32(AasHeader.byteCount), fp)
        AAS_WriteAASLump_offset = Int32(AasHeader.byteCount)
        //add the data lumps to the file
        if AAS_WriteAASLump(fp, header, AASLUMP_BBOXES, aasworld.bboxes?.handle, aasworld.numbboxes * Int32(AasBbox.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_VERTEXES, aasworld.vertexes.map { OpaquePointer($0.base) }, aasworld.numvertexes * Int32(vec3_t.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_PLANES, aasworld.planes?.handle, aasworld.numplanes * Int32(AasPlane.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_EDGES, aasworld.edges?.handle, aasworld.numedges * Int32(AasEdge.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_EDGEINDEX, aasworld.edgeindex.map { OpaquePointer($0.base) }, aasworld.edgeindexsize * Int32(Int32.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_FACES, aasworld.faces?.handle, aasworld.numfaces * Int32(AasFace.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_FACEINDEX, aasworld.faceindex.map { OpaquePointer($0.base) }, aasworld.faceindexsize * Int32(Int32.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_AREAS, aasworld.areas?.handle, aasworld.numareas * Int32(AasArea.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_AREASETTINGS, aasworld.areasettings?.handle, aasworld.numareasettings * Int32(AasAreasettings.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_REACHABILITY, aasworld.reachability?.handle, aasworld.reachabilitysize * Int32(AasReachability.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_NODES, aasworld.nodes?.handle, aasworld.numnodes * Int32(AasNode.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_PORTALS, aasworld.portals?.handle, aasworld.numportals * Int32(AasPortal.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_PORTALINDEX, aasworld.portalindex.map { OpaquePointer($0.base) }, aasworld.portalindexsize * Int32(Int32.byteCount)) == 0 { return false }
        if AAS_WriteAASLump(fp, header, AASLUMP_CLUSTERS, aasworld.clusters?.handle, aasworld.numclusters * Int32(AasCluster.byteCount)) == 0 { return false }
        //rewrite the header with the added lumps
        botimport.runFS_Seek(fp, 0, FS_SEEK_SET)
        AAS_DData(Slots(record: header).bytes.suffix(from: 8), Int32(AasHeader.byteCount) - 8)
        botimport.runFS_Write(header.handle, Int32(AasHeader.byteCount), fp)
        //close the file
        botimport.runFS_FCloseFile(fp)
        return true
    }
}
