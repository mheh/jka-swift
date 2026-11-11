import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_optimize.cpp:61
public func AAS_KeepEdge(_ edge: AasEdge) -> Int32 {
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_optimize.cpp:71
public func AAS_OptimizeEdge(_ optimized: Optimized, _ edgenum: Int32) -> Int32 {
    var i: Int32
    var optedgenum: Int32
    var edge: AasEdge
    var optedge: AasEdge

    edge = aasworld.edgesSlots[abs(edgenum)]
    if AAS_KeepEdge(edge) == 0 {
        return 0
    }

    optedgenum = optimized.edgeoptimizeindex![abs(edgenum)]
    if optedgenum != 0 {
        //keep the edge reversed sign
        if edgenum > 0 {
            return optedgenum
        } else {
            return -optedgenum
        }
    } //end if

    optedge = optimized.edgesSlots[optimized.numedges]

    i = 0
    while i < 2 {
        if optimized.vertexoptimizeindex![edge.v[i]] != 0 {
            optedge.v[i] = optimized.vertexoptimizeindex![edge.v[i]]
        } //end if
        else {
            optimized.vertexes![optimized.numvertexes] = aasworld.vertexes![edge.v[i]]
            optedge.v[i] = optimized.numvertexes
            optimized.vertexoptimizeindex![edge.v[i]] = optimized.numvertexes
            optimized.numvertexes += 1
        } //end else
        i += 1
    } //end for
    optimized.edgeoptimizeindex![abs(edgenum)] = optimized.numedges
    optedgenum = optimized.numedges
    optimized.numedges += 1
    //keep the edge reversed sign
    if edgenum > 0 {
        return optedgenum
    } else {
        return -optedgenum
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_optimize.cpp:116
public func AAS_KeepFace(_ face: AasFace) -> Int32 {
    if (face.faceflags & FACE_LADDER) == 0 {
        return 0
    } else {
        return 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_optimize.cpp:127
public func AAS_OptimizeFace(_ optimized: Optimized, _ facenum: Int32) -> Int32 {
    var i: Int32
    var edgenum: Int32
    var optedgenum: Int32
    var optfacenum: Int32
    var face: AasFace
    var optface: AasFace

    face = aasworld.facesSlots[abs(facenum)]
    if AAS_KeepFace(face) == 0 {
        return 0
    }

    optfacenum = optimized.faceoptimizeindex![abs(facenum)]
    if optfacenum != 0 {
        //keep the face side sign
        if facenum > 0 {
            return optfacenum
        } else {
            return -optfacenum
        }
    } //end if

    optface = optimized.facesSlots[optimized.numfaces]
    optface.copy(from: face)

    optface.numedges = 0
    optface.firstedge = optimized.edgeindexsize
    i = 0
    while i < face.numedges {
        edgenum = aasworld.edgeindex![face.firstedge + i]
        optedgenum = AAS_OptimizeEdge(optimized, edgenum)
        if optedgenum != 0 {
            optimized.edgeindex![optface.firstedge + optface.numedges] = optedgenum
            optface.numedges += 1
            optimized.edgeindexsize += 1
        } //end if
        i += 1
    } //end for
    optimized.faceoptimizeindex![abs(facenum)] = optimized.numfaces
    optfacenum = optimized.numfaces
    optimized.numfaces += 1
    //keep the face side sign
    if facenum > 0 {
        return optfacenum
    } else {
        return -optfacenum
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_optimize.cpp:172
public func AAS_OptimizeArea(_ optimized: Optimized, _ areanum: Int32) {
    var i: Int32
    var facenum: Int32
    var optfacenum: Int32
    var area: AasArea
    var optarea: AasArea

    area = aasworld.areasSlots[areanum]
    optarea = optimized.areasSlots[areanum]
    optarea.copy(from: area)

    optarea.numfaces = 0
    optarea.firstface = optimized.faceindexsize
    i = 0
    while i < area.numfaces {
        facenum = aasworld.faceindex![area.firstface + i]
        optfacenum = AAS_OptimizeFace(optimized, facenum)
        if optfacenum != 0 {
            optimized.faceindex![optarea.firstface + optarea.numfaces] = optfacenum
            optarea.numfaces += 1
            optimized.faceindexsize += 1
        } //end if
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_optimize.cpp:201
public func AAS_OptimizeAlloc(_ optimized: Optimized) {
    optimized.vertexes = Slots(vectors: GetClearedMemory(aasworld.numvertexes * Int32(vec3_t.byteCount)), count: Int(aasworld.numvertexes))
    optimized.numvertexes = 0
    optimized.edges = AasEdge(GetClearedMemory(aasworld.numedges * Int32(AasEdge.byteCount)))
    optimized.numedges = 1 //edge zero is a dummy
    optimized.edgeindex = Slots<Int32>(scalars: GetClearedMemory(aasworld.edgeindexsize * Int32(Int32.byteCount)), count: Int(aasworld.edgeindexsize))
    optimized.edgeindexsize = 0
    optimized.faces = AasFace(GetClearedMemory(aasworld.numfaces * Int32(AasFace.byteCount)))
    optimized.numfaces = 1 //face zero is a dummy
    optimized.faceindex = Slots<Int32>(scalars: GetClearedMemory(aasworld.faceindexsize * Int32(Int32.byteCount)), count: Int(aasworld.faceindexsize))
    optimized.faceindexsize = 0
    optimized.areas = AasArea(GetClearedMemory(aasworld.numareas * Int32(AasArea.byteCount)))
    optimized.numareas = aasworld.numareas
    //
    optimized.vertexoptimizeindex = Slots<Int32>(scalars: GetClearedMemory(aasworld.numvertexes * Int32(Int32.byteCount)), count: Int(aasworld.numvertexes))
    optimized.edgeoptimizeindex = Slots<Int32>(scalars: GetClearedMemory(aasworld.numedges * Int32(Int32.byteCount)), count: Int(aasworld.numedges))
    optimized.faceoptimizeindex = Slots<Int32>(scalars: GetClearedMemory(aasworld.numfaces * Int32(Int32.byteCount)), count: Int(aasworld.numfaces))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_optimize.cpp:226
public func AAS_OptimizeStore(_ optimized: Optimized) {
    //store the optimized vertexes
    if aasworld.vertexes != nil {
        FreeMemory(OpaquePointer(aasworld.vertexes!.base))
    }
    aasworld.vertexes = optimized.vertexes
    aasworld.numvertexes = optimized.numvertexes
    //store the optimized edges
    if aasworld.edges != nil {
        FreeMemory(aasworld.edges?.handle)
    }
    aasworld.edges = optimized.edges
    aasworld.numedges = optimized.numedges
    //store the optimized edge index
    if aasworld.edgeindex != nil {
        FreeMemory(OpaquePointer(aasworld.edgeindex!.base))
    }
    aasworld.edgeindex = optimized.edgeindex
    aasworld.edgeindexsize = optimized.edgeindexsize
    //store the optimized faces
    if aasworld.faces != nil {
        FreeMemory(aasworld.faces?.handle)
    }
    aasworld.faces = optimized.faces
    aasworld.numfaces = optimized.numfaces
    //store the optimized face index
    if aasworld.faceindex != nil {
        FreeMemory(OpaquePointer(aasworld.faceindex!.base))
    }
    aasworld.faceindex = optimized.faceindex
    aasworld.faceindexsize = optimized.faceindexsize
    //store the optimized areas
    if aasworld.areas != nil {
        FreeMemory(aasworld.areas?.handle)
    }
    aasworld.areas = optimized.areas
    aasworld.numareas = optimized.numareas
    //free optimize indexes
    FreeMemory(OpaquePointer(optimized.vertexoptimizeindex!.base))
    FreeMemory(OpaquePointer(optimized.edgeoptimizeindex!.base))
    FreeMemory(OpaquePointer(optimized.faceoptimizeindex!.base))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_optimize.cpp:263
public func AAS_Optimize() {
    Optimized.scratch { optimized in
        var i: Int32
        var sign: Int32

        AAS_OptimizeAlloc(optimized)
        i = 1
        while i < aasworld.numareas {
            AAS_OptimizeArea(optimized, i)
            i += 1
        } //end for
        //reset the reachability face pointers
        i = 0
        while i < aasworld.reachabilitysize {
            //NOTE: for TRAVEL_ELEVATOR the facenum is the model number of
            //		the elevator
            if (aasworld.reachabilitySlots[i].traveltype & TRAVELTYPE_MASK) == TRAVEL_ELEVATOR {
                i += 1
                continue
            }
            //NOTE: for TRAVEL_JUMPPAD the facenum is the Z velocity and the edgenum is the hor velocity
            if (aasworld.reachabilitySlots[i].traveltype & TRAVELTYPE_MASK) == TRAVEL_JUMPPAD {
                i += 1
                continue
            }
            //NOTE: for TRAVEL_FUNCBOB the facenum and edgenum contain other coded information
            if (aasworld.reachabilitySlots[i].traveltype & TRAVELTYPE_MASK) == TRAVEL_FUNCBOB {
                i += 1
                continue
            }
            //
            sign = aasworld.reachabilitySlots[i].facenum
            aasworld.reachabilitySlots[i].facenum = optimized.faceoptimizeindex![abs(aasworld.reachabilitySlots[i].facenum)]
            if sign < 0 {
                aasworld.reachabilitySlots[i].facenum = -aasworld.reachabilitySlots[i].facenum
            }
            sign = aasworld.reachabilitySlots[i].edgenum
            aasworld.reachabilitySlots[i].edgenum = optimized.edgeoptimizeindex![abs(aasworld.reachabilitySlots[i].edgenum)]
            if sign < 0 {
                aasworld.reachabilitySlots[i].edgenum = -aasworld.reachabilitySlots[i].edgenum
            }
            i += 1
        } //end for
        //store the optimized AAS data into aasworld
        AAS_OptimizeStore(optimized)
    }
    //print some nice stuff :)
    botimport.runPrint(PRT_MESSAGE, "AAS data optimized.\n")
}
