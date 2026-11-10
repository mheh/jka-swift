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
func AAS_LoadAASLump(_ fp: JKAShared.fileHandle_t, _ offset: Int32, _ length: Int32, _ lastoffset: inout Int32, _ size: Int32) -> UnsafeMutableRawPointer? {
    //
    if length == 0 {
        //just alloc a dummy
        return GetClearedHunkMemory(size + 1)
    } //end if
    //seek to the data
    if offset != lastoffset {
        botimport.runPrint(PRT_WARNING, "AAS file not sequentially read\n")
        if botimport.runFS_Seek(fp, CLong(offset), FS_SEEK_SET) != 0 {
            AAS_Error("can't seek to aas lump\n")
            AAS_DumpAASData()
            botimport.runFS_FCloseFile(fp)
            return nil
        } //end if
    } //end if
    //allocate memory
    let buf = GetClearedHunkMemory(length + 1)
    //read the data
    if length != 0 {
        botimport.runFS_Read(Slots<byte>(scalars: buf, count: Int(length)), length, fp)
        lastoffset += length
    } //end if
    return buf
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
    var fp: fileHandle_t = 0

    botimport.runPrint(PRT_MESSAGE, "trying to load %s\n", String(filename))
    //dump current loaded aas file
    AAS_DumpAASData()
    //open the file
    botimport.runFS_FOpenFile(String(filename), &fp, FS_READ)
    if fp == 0 {
        AAS_Error("can't open %s\n", String(filename))
        return BLERR_CANNOTOPENAASFILE
    } //end if
    return AasHeader.scratch { header -> Int32 in
        var offset: Int32, length: Int32, lastoffset: Int32

        //read the header
        botimport.runFS_Read(Slots(record: header).bytes, Int32(AasHeader.byteCount), fp)
        lastoffset = Int32(AasHeader.byteCount)
        //check header identification
        // LittleLong of the WinDed arm is its argument, so each `LittleLong` of this body has no line.
        if header.ident != AASID {
            AAS_Error("%s is not an AAS file\n", String(filename))
            botimport.runFS_FCloseFile(fp)
            return BLERR_WRONGAASFILEID
        } //end if
        //check the version
        //
        if header.version != AASVERSION_OLD && header.version != AASVERSION {
            AAS_Error("aas file %s is version %i, not %i\n", String(filename), header.version, AASVERSION)
            botimport.runFS_FCloseFile(fp)
            return BLERR_WRONGAASFILEVERSION
        } //end if
        //
        if header.version == AASVERSION {
            AAS_DData(Slots(record: header).bytes.suffix(from: 8), Int32(AasHeader.byteCount) - 8)
        } //end if
        //
        aasworld.bspchecksum = atoi(LibVarGetString("sv_mapChecksum"))
        if header.bspchecksum != aasworld.bspchecksum {
            AAS_Error("aas file %s is out of date\n", String(filename))
            botimport.runFS_FCloseFile(fp)
            return BLERR_WRONGAASFILEVERSION
        } //end if
        //load the lumps:
        //bounding boxes
        offset = header.lumps[AASLUMP_BBOXES].fileofs
        length = header.lumps[AASLUMP_BBOXES].filelen
        aasworld.bboxes = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasBbox.byteCount)).map { AasBbox($0) }
        aasworld.numbboxes = length / Int32(AasBbox.byteCount)
        if aasworld.numbboxes != 0 && aasworld.bboxes == nil { return BLERR_CANNOTREADAASLUMP }
        //vertexes
        offset = header.lumps[AASLUMP_VERTEXES].fileofs
        length = header.lumps[AASLUMP_VERTEXES].filelen
        aasworld.vertexes = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(vec3_t.byteCount)).map { Slots(vectors: $0, count: Int(length / Int32(vec3_t.byteCount))) }
        aasworld.numvertexes = length / Int32(vec3_t.byteCount)
        if aasworld.numvertexes != 0 && aasworld.vertexes == nil { return BLERR_CANNOTREADAASLUMP }
        //planes
        offset = header.lumps[AASLUMP_PLANES].fileofs
        length = header.lumps[AASLUMP_PLANES].filelen
        aasworld.planes = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasPlane.byteCount)).map { AasPlane($0) }
        aasworld.numplanes = length / Int32(AasPlane.byteCount)
        if aasworld.numplanes != 0 && aasworld.planes == nil { return BLERR_CANNOTREADAASLUMP }
        //edges
        offset = header.lumps[AASLUMP_EDGES].fileofs
        length = header.lumps[AASLUMP_EDGES].filelen
        aasworld.edges = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasEdge.byteCount)).map { AasEdge($0) }
        aasworld.numedges = length / Int32(AasEdge.byteCount)
        if aasworld.numedges != 0 && aasworld.edges == nil { return BLERR_CANNOTREADAASLUMP }
        //edgeindex
        offset = header.lumps[AASLUMP_EDGEINDEX].fileofs
        length = header.lumps[AASLUMP_EDGEINDEX].filelen
        aasworld.edgeindex = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(Int32.byteCount)).map { Slots<Int32>(scalars: $0, count: Int(length / Int32(Int32.byteCount))) }
        aasworld.edgeindexsize = length / Int32(Int32.byteCount)
        if aasworld.edgeindexsize != 0 && aasworld.edgeindex == nil { return BLERR_CANNOTREADAASLUMP }
        //faces
        offset = header.lumps[AASLUMP_FACES].fileofs
        length = header.lumps[AASLUMP_FACES].filelen
        aasworld.faces = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasFace.byteCount)).map { AasFace($0) }
        aasworld.numfaces = length / Int32(AasFace.byteCount)
        if aasworld.numfaces != 0 && aasworld.faces == nil { return BLERR_CANNOTREADAASLUMP }
        //faceindex
        offset = header.lumps[AASLUMP_FACEINDEX].fileofs
        length = header.lumps[AASLUMP_FACEINDEX].filelen
        aasworld.faceindex = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(Int32.byteCount)).map { Slots<Int32>(scalars: $0, count: Int(length / Int32(Int32.byteCount))) }
        aasworld.faceindexsize = length / Int32(Int32.byteCount)
        if aasworld.faceindexsize != 0 && aasworld.faceindex == nil { return BLERR_CANNOTREADAASLUMP }
        //convex areas
        offset = header.lumps[AASLUMP_AREAS].fileofs
        length = header.lumps[AASLUMP_AREAS].filelen
        aasworld.areas = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasArea.byteCount)).map { AasArea($0) }
        aasworld.numareas = length / Int32(AasArea.byteCount)
        if aasworld.numareas != 0 && aasworld.areas == nil { return BLERR_CANNOTREADAASLUMP }
        //area settings
        offset = header.lumps[AASLUMP_AREASETTINGS].fileofs
        length = header.lumps[AASLUMP_AREASETTINGS].filelen
        aasworld.areasettings = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasAreasettings.byteCount)).map { AasAreasettings($0) }
        aasworld.numareasettings = length / Int32(AasAreasettings.byteCount)
        if aasworld.numareasettings != 0 && aasworld.areasettings == nil { return BLERR_CANNOTREADAASLUMP }
        //reachability list
        offset = header.lumps[AASLUMP_REACHABILITY].fileofs
        length = header.lumps[AASLUMP_REACHABILITY].filelen
        aasworld.reachability = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasReachability.byteCount)).map { AasReachability($0) }
        aasworld.reachabilitysize = length / Int32(AasReachability.byteCount)
        if aasworld.reachabilitysize != 0 && aasworld.reachability == nil { return BLERR_CANNOTREADAASLUMP }
        //nodes
        offset = header.lumps[AASLUMP_NODES].fileofs
        length = header.lumps[AASLUMP_NODES].filelen
        aasworld.nodes = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasNode.byteCount)).map { AasNode($0) }
        aasworld.numnodes = length / Int32(AasNode.byteCount)
        if aasworld.numnodes != 0 && aasworld.nodes == nil { return BLERR_CANNOTREADAASLUMP }
        //cluster portals
        offset = header.lumps[AASLUMP_PORTALS].fileofs
        length = header.lumps[AASLUMP_PORTALS].filelen
        aasworld.portals = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasPortal.byteCount)).map { AasPortal($0) }
        aasworld.numportals = length / Int32(AasPortal.byteCount)
        if aasworld.numportals != 0 && aasworld.portals == nil { return BLERR_CANNOTREADAASLUMP }
        //cluster portal index
        offset = header.lumps[AASLUMP_PORTALINDEX].fileofs
        length = header.lumps[AASLUMP_PORTALINDEX].filelen
        aasworld.portalindex = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(Int32.byteCount)).map { Slots<Int32>(scalars: $0, count: Int(length / Int32(Int32.byteCount))) }
        aasworld.portalindexsize = length / Int32(Int32.byteCount)
        if aasworld.portalindexsize != 0 && aasworld.portalindex == nil { return BLERR_CANNOTREADAASLUMP }
        //clusters
        offset = header.lumps[AASLUMP_CLUSTERS].fileofs
        length = header.lumps[AASLUMP_CLUSTERS].filelen
        aasworld.clusters = AAS_LoadAASLump(fp, offset, length, &lastoffset, Int32(AasCluster.byteCount)).map { AasCluster($0) }
        aasworld.numclusters = length / Int32(AasCluster.byteCount)
        if aasworld.numclusters != 0 && aasworld.clusters == nil { return BLERR_CANNOTREADAASLUMP }
        //swap everything
        AAS_SwapAASData()
        //aas file is loaded
        aasworld.loaded = 1
        //close the file
        botimport.runFS_FCloseFile(fp)
        //
        return BLERR_NOERROR
    }
}

/// Source: oracle/codemp/botlib/be_aas_file.cpp:481
func AAS_WriteAASLump(_ fp: JKAShared.fileHandle_t, _ h: AasHeader, _ lumpnum: Int32, _ data: OpaquePointer?, _ length: Int32) -> Int32 {
    var lump: AasLump

    lump = h.lumps[lumpnum]

    // LittleLong of the WinDed arm is its argument.
    lump.fileofs = AAS_WriteAASLump_offset	//LittleLong(ftell(fp));
    lump.filelen = length

    if length > 0 {
        botimport.runFS_Write(Slots<byte>(scalars: data!, count: Int(length)), length, fp)
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

    botimport.runPrint(PRT_MESSAGE, "writing %s\n", String(filename))
    //swap the aas data
    AAS_SwapAASData()
    return AasHeader.scratch { header -> Bool in
        //initialize the file header
        // LittleLong of the WinDed arm is its argument.
        header.ident = AASID
        header.version = AASVERSION
        header.bspchecksum = aasworld.bspchecksum
        //open a new file
        botimport.runFS_FOpenFile(String(filename), &fp, FS_WRITE)
        if fp == 0 {
            botimport.runPrint(PRT_ERROR, "error opening %s\n", String(filename))
            return false
        } //end if
        //write the header
        botimport.runFS_Write(Slots(record: header).bytes, Int32(AasHeader.byteCount), fp)
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
        botimport.runFS_Write(Slots(record: header).bytes, Int32(AasHeader.byteCount), fp)
        //close the file
        botimport.runFS_FCloseFile(fp)
        return true
    }
}
