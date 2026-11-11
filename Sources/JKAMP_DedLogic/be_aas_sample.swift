import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_sample.cpp:34
let BBOX_NORMAL_EPSILON = 0.001 as Double

/// Source: oracle/codemp/botlib/be_aas_sample.cpp:36
private let ON_EPSILON = 0 as Int32

/// Source: oracle/codemp/botlib/be_aas_sample.cpp:38
let TRACEPLANE_EPSILON = 0.125 as Double

/// Source: oracle/codemp/botlib/be_aas_sample.cpp:48
public var numaaslinks: Int32 {
    get { world.variables.numaaslinks }
    set { world.variables.numaaslinks = newValue }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:56
public func AAS_PresenceTypeBoundingBox(_ presencetype: Int32, _ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t) {
    let index: Int32
    //bounding box size for each presence type
    let boxmins: [vec3_t] = [vec3_t(0, 0, 0), vec3_t(-15, -15, -24), vec3_t(-15, -15, -24)]
    let boxmaxs: [vec3_t] = [vec3_t(0, 0, 0), vec3_t(15, 15, 32), vec3_t(15, 15, 8)]

    if presencetype == PRESENCE_NORMAL {
        index = 1
    } else if presencetype == PRESENCE_CROUCH {
        index = 2
    } else {
        botimport.runPrint(PRT_FATAL, "AAS_PresenceTypeBoundingBox: unknown presence type\n")
        index = 2
    } //end if
    mins = boxmins[index]
    maxs = boxmaxs[index]
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:79
public func AAS_InitAASLinkHeap() {
    var i: Int32
    var max_aaslinks: Int32

    max_aaslinks = aasworld.linkheapsize
    //if there's no link heap present
    if aasworld.linkheap == nil {
        max_aaslinks = Int32(LibVarValue("max_aaslinks", "6144"))
        if max_aaslinks < 0 {
            max_aaslinks = 0
        }
        aasworld.linkheapsize = max_aaslinks
        aasworld.linkheap = AasLink(GetHunkMemory(max_aaslinks * Int32(AasLink.byteCount))!)
    } //end if
    //link the links on the heap
    aasworld.linkheapSlots[0].prev_ent = nil
    aasworld.linkheapSlots[0].next_ent = aasworld.linkheapSlots[1]
    i = 1
    while i < max_aaslinks - 1 {
        aasworld.linkheapSlots[i].prev_ent = aasworld.linkheapSlots[i - 1]
        aasworld.linkheapSlots[i].next_ent = aasworld.linkheapSlots[i + 1]
        i += 1
    } //end for
    aasworld.linkheapSlots[max_aaslinks - 1].prev_ent = aasworld.linkheapSlots[max_aaslinks - 2]
    aasworld.linkheapSlots[max_aaslinks - 1].next_ent = nil
    //pointer to the first free link
    aasworld.freelinks = aasworld.linkheapSlots[0]
    //
    numaaslinks = max_aaslinks
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:117
public func AAS_FreeAASLinkHeap() {
    if aasworld.linkheap != nil {
        FreeMemory(aasworld.linkheap?.handle)
    }
    aasworld.linkheap = nil
    aasworld.linkheapsize = 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:129
public func AAS_AllocAASLink() -> AasLink? {
    let link: AasLink?

    link = aasworld.freelinks
    if link == nil {
        if bot_developer != 0 {
            botimport.runPrint(PRT_FATAL, "empty aas link heap\n")
        } //end if
        return nil
    } //end if
    if aasworld.freelinks != nil {
        aasworld.freelinks = aasworld.freelinks!.next_ent
    }
    if aasworld.freelinks != nil {
        aasworld.freelinks!.prev_ent = nil
    }
    numaaslinks -= 1
    return link
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:155
public func AAS_DeAllocAASLink(_ link: AasLink) {
    if aasworld.freelinks != nil {
        aasworld.freelinks!.prev_ent = link
    }
    link.prev_ent = nil
    link.next_ent = aasworld.freelinks
    link.prev_area = nil
    link.next_area = nil
    aasworld.freelinks = link
    numaaslinks += 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:171
public func AAS_InitAASLinkedEntities() {
    if aasworld.loaded == 0 {
        return
    }
    if aasworld.arealinkedentities != nil {
        FreeMemory(OpaquePointer(aasworld.arealinkedentities!.base))
    }
    // The block holds one record pointer per area, and `UInt.byteCount` is the size of one pointer.
    aasworld.arealinkedentities = Slots(pointers: GetClearedHunkMemory(aasworld.numareas * Int32(UInt.byteCount)), count: Int(aasworld.numareas))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:184
public func AAS_FreeAASLinkedEntities() {
    if aasworld.arealinkedentities != nil {
        FreeMemory(OpaquePointer(aasworld.arealinkedentities!.base))
    }
    aasworld.arealinkedentities = nil
}

//===========================================================================
// returns the AAS area the point is in
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:196
public func AAS_PointAreaNum(_ point: JKAShared.vec3_t) -> Int32 {
    var nodenum: Int32
    var dist: vec_t
    var node: AasNode
    var plane: AasPlane

    if aasworld.loaded == 0 {
        botimport.runPrint(PRT_ERROR, "AAS_PointAreaNum: aas not loaded\n")
        return 0
    } //end if

    //start with node 1 because node zero is a dummy used for solid leafs
    nodenum = 1
    while nodenum > 0 {
        //		botimport.Print(PRT_MESSAGE, "[%d]", nodenum);
        node = aasworld.nodesSlots[nodenum]
        plane = aasworld.planesSlots[node.planenum]
        dist = _DotProduct(point, plane.normal) - plane.dist
        if dist > 0 {
            nodenum = node.children[0]
        } else {
            nodenum = node.children[1]
        }
    } //end while
    if nodenum == 0 {
        return 0
    } //end if
    return -nodenum
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:249
public func AAS_PointReachabilityAreaIndex(_ origin: JKAShared.vec3_t) -> Int32 {
    var areanum: Int32
    var cluster: Int32
    var i: Int32
    var index: Int32

    if aasworld.initialized == 0 {
        return 0
    }

    // Port-note: Raven returns the sum of the reachability areas of every cluster for a NULL `origin`.
    // The signature takes a vector, and the one caller that passes NULL, g_cmds.c:2456, is in a comment.
    areanum = AAS_PointAreaNum(origin)
    if areanum == 0 || AAS_AreaReachability(areanum) == 0 {
        return 0
    }
    cluster = aasworld.areasettingsSlots[areanum].cluster
    areanum = aasworld.areasettingsSlots[areanum].clusterareanum
    if cluster < 0 {
        cluster = aasworld.portalsSlots[-cluster].frontcluster
        areanum = aasworld.portalsSlots[-cluster].clusterareanum[0]
    } //end if

    index = 0
    i = 0
    while i < cluster {
        index += aasworld.clustersSlots[i].numreachabilityareas
        i += 1
    } //end for
    index += areanum
    return index
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:291
public func AAS_AreaCluster(_ areanum: Int32) -> Int32 {
    if areanum <= 0 || areanum >= aasworld.numareas {
        botimport.runPrint(PRT_ERROR, "AAS_AreaCluster: invalid area number\n")
        return 0
    } //end if
    return aasworld.areasettingsSlots[areanum].cluster
}

//===========================================================================
// returns the presence types of the given area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:307
public func AAS_AreaPresenceType(_ areanum: Int32) -> Int32 {
    if aasworld.loaded == 0 {
        return 0
    }
    if areanum <= 0 || areanum >= aasworld.numareas {
        botimport.runPrint(PRT_ERROR, "AAS_AreaPresenceType: invalid area number\n")
        return 0
    } //end if
    return aasworld.areasettingsSlots[areanum].presencetype
}

//===========================================================================
// returns the presence type at the given point
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:324
public func AAS_PointPresenceType(_ point: JKAShared.vec3_t) -> Int32 {
    let areanum: Int32

    if aasworld.loaded == 0 {
        return 0
    }

    areanum = AAS_PointAreaNum(point)
    if areanum == 0 {
        return PRESENCE_NONE
    }
    return aasworld.areasettingsSlots[areanum].presencetype
}

//===========================================================================
// calculates the minimum distance between the origin of the box and the
// given plane when both will collide on the given side of the plane
//
// normal	=	normal vector of plane to calculate distance from
// mins		=	minimums of box relative to origin
// maxs		=	maximums of box relative to origin
// side		=	side of the plane we want to calculate the distance from
//					0 normal vector side
//					1 not normal vector side
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:349
public func AAS_BoxOriginDistanceFromPlane(_ normal: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ side: Int32) -> Float {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var v1 = vec3_t(), v2 = vec3_t()
    var i: Int32

    //swap maxs and mins when on the other side of the plane
    if side != 0 {
        //get a point of the box that would be one of the first
        //to collide with the plane
        i = 0
        while i < 3 {
            if Double(normal[i]) > BBOX_NORMAL_EPSILON {
                v1[i] = maxs[i]
            } else if Double(normal[i]) < -BBOX_NORMAL_EPSILON {
                v1[i] = mins[i]
            } else {
                v1[i] = 0
            }
            i += 1
        } //end for
    } //end if
    else {
        //get a point of the box that would be one of the first
        //to collide with the plane
        i = 0
        while i < 3 {
            if Double(normal[i]) > BBOX_NORMAL_EPSILON {
                v1[i] = mins[i]
            } else if Double(normal[i]) < -BBOX_NORMAL_EPSILON {
                v1[i] = maxs[i]
            } else {
                v1[i] = 0
            }
            i += 1
        } //end for
    } //end else
    //
    v2 = normal
    VectorInverse(&v2)
//	VectorNegate(normal, v2);
    return _DotProduct(v1, v2)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:389
public func AAS_AreaEntityCollision(_ areanum: Int32, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ presencetype: Int32, _ passent: Int32, _ trace: AasTrace) -> Bool {
    var boxmins = vec3_t()
    var boxmaxs = vec3_t()

    AAS_PresenceTypeBoundingBox(presencetype, &boxmins, &boxmaxs)

    return BspTrace.scratch { bsptrace -> Bool in
        var collision: Int32
        var link: AasLink?

        //assume no collision
        bsptrace.fraction = 1
        collision = 0
        link = aasworld.arealinkedentities![areanum]
        while link != nil {
            //ignore the pass entity
            if link!.entnum == passent {
                link = link!.next_ent
                continue
            }
            //
            if AAS_EntityCollision(link!.entnum, start, boxmins, boxmaxs, end, CONTENTS_SOLID | CONTENTS_PLAYERCLIP, bsptrace) {
                collision = 1
            } //end if
            link = link!.next_ent
        } //end for
        if collision != 0 {
            trace.startsolid = bsptrace.startsolid
            trace.ent = bsptrace.ent
            trace.endpos = bsptrace.endpos
            trace.area = 0
            trace.planenum = 0
            return true
        } //end if
        return false
    }
}

//===========================================================================
// recursive subdivision of the line by the BSP tree.
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:442
// AI: Raven declares `trace` on the stack of AAS_TraceClientBBox. The function uses one zeroed allocation on the storage class.
var trace_AAS_TraceClientBBox: AasTrace { world.storage.trace_AAS_TraceClientBBox }

/// Source: oracle/codemp/botlib/be_aas_sample.cpp:432
public func AAS_TraceClientBBox(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ presencetype: Int32, _ passent: Int32) -> AasTrace {
    let trace = trace_AAS_TraceClientBBox

    //clear the trace structure
    trace.clear()

    if aasworld.loaded == 0 { return trace }

    return AasTracestack.scratch(count: 127) { tracestack -> AasTrace in
        var side: Int32, nodenum: Int32, tmpplanenum: Int32
        var front: Float, back: Float, frac: Float
        var cur_start: vec3_t, cur_end: vec3_t
        var cur_mid = vec3_t(), v1 = vec3_t(), v2 = vec3_t()
        var tstack_pIndex: Int32
        var aasnode: AasNode
        var plane: AasPlane

        tstack_pIndex = 0
        //we start with the whole line on the stack
        tracestack[tstack_pIndex].start = start
        tracestack[tstack_pIndex].end = end
        tracestack[tstack_pIndex].planenum = 0
        //start with node 1 because node zero is a dummy for a solid leaf
        tracestack[tstack_pIndex].nodenum = 1 //starting at the root of the tree
        tstack_pIndex += 1

        while true {
            //pop up the stack
            tstack_pIndex -= 1
            //if the trace stack is empty (ended up with a piece of the
            //line to be traced in an area)
            if tstack_pIndex < 0 {
                tstack_pIndex += 1
                //nothing was hit
                trace.startsolid = false
                trace.fraction = 1.0
                //endpos is the end of the line
                trace.endpos = end
                //nothing hit
                trace.ent = 0
                trace.area = 0
                trace.planenum = 0
                return trace
            } //end if
            //number of the current node to test the line against
            nodenum = tracestack[tstack_pIndex].nodenum
            //if it is an area
            if nodenum < 0 {
                //botimport.Print(PRT_MESSAGE, "areanum = %d, must be %d\n", -nodenum, AAS_PointAreaNum(start));
                //if can't enter the area because it hasn't got the right presence type
                if (aasworld.areasettingsSlots[-nodenum].presencetype & presencetype) == 0 {
                    //if the start point is still the initial start point
                    //NOTE: no need for epsilons because the points will be
                    //exactly the same when they're both the start point
                    if tracestack[tstack_pIndex].start[0] == start[0] &&
                        tracestack[tstack_pIndex].start[1] == start[1] &&
                        tracestack[tstack_pIndex].start[2] == start[2] {
                        trace.startsolid = true
                        trace.fraction = 0.0
                        v1 = vec3_t()
                    } //end if
                    else {
                        trace.startsolid = false
                        v1 = end - start
                        v2 = tracestack[tstack_pIndex].start - start
                        trace.fraction = VectorLength(v2) / VectorNormalize(&v1)
                        _VectorMA(tracestack[tstack_pIndex].start, -0.125, v1, &tracestack[tstack_pIndex].start)
                    } //end else
                    trace.endpos = tracestack[tstack_pIndex].start
                    trace.ent = 0
                    trace.area = -nodenum
                    //				VectorSubtract(end, start, v1);
                    trace.planenum = tracestack[tstack_pIndex].planenum
                    //always take the plane with normal facing towards the trace start
                    plane = aasworld.planesSlots[trace.planenum]
                    if _DotProduct(v1, plane.normal) > 0 { trace.planenum ^= 1 }
                    return trace
                } //end if
                else {
                    if passent >= 0 {
                        if AAS_AreaEntityCollision(-nodenum, tracestack[tstack_pIndex].start, tracestack[tstack_pIndex].end, presencetype, passent, trace) {
                            if !trace.startsolid {
                                v1 = end - start
                                v2 = trace.endpos - start
                                trace.fraction = VectorLength(v2) / VectorLength(v1)
                            } //end if
                            return trace
                        } //end if
                    } //end if
                } //end else
                trace.lastarea = -nodenum
                continue
            } //end if
            //if it is a solid leaf
            if nodenum == 0 {
                //if the start point is still the initial start point
                //NOTE: no need for epsilons because the points will be
                //exactly the same when they're both the start point
                if tracestack[tstack_pIndex].start[0] == start[0] &&
                    tracestack[tstack_pIndex].start[1] == start[1] &&
                    tracestack[tstack_pIndex].start[2] == start[2] {
                    trace.startsolid = true
                    trace.fraction = 0.0
                    v1 = vec3_t()
                } //end if
                else {
                    trace.startsolid = false
                    v1 = end - start
                    v2 = tracestack[tstack_pIndex].start - start
                    trace.fraction = VectorLength(v2) / VectorNormalize(&v1)
                    _VectorMA(tracestack[tstack_pIndex].start, -0.125, v1, &tracestack[tstack_pIndex].start)
                } //end else
                trace.endpos = tracestack[tstack_pIndex].start
                trace.ent = 0
                trace.area = 0	//hit solid leaf
                //			VectorSubtract(end, start, v1);
                trace.planenum = tracestack[tstack_pIndex].planenum
                //always take the plane with normal facing towards the trace start
                plane = aasworld.planesSlots[trace.planenum]
                if _DotProduct(v1, plane.normal) > 0 { trace.planenum ^= 1 }
                return trace
            } //end if
            //the node to test against
            aasnode = aasworld.nodesSlots[nodenum]
            //start point of current line to test against node
            cur_start = tracestack[tstack_pIndex].start
            //end point of the current line to test against node
            cur_end = tracestack[tstack_pIndex].end
            //the current node plane
            plane = aasworld.planesSlots[aasnode.planenum]

            //		switch(plane->type)
            //			default: //gee it's not an axial plane
            front = _DotProduct(cur_start, plane.normal) - plane.dist
            back = _DotProduct(cur_end, plane.normal) - plane.dist
            // bk010221 - old location of FPE hack and divide by zero expression
            //if the whole to be traced line is totally at the front of this node
            //only go down the tree with the front child
            if front >= -ON_EPSILON && back >= -ON_EPSILON {
                //keep the current start and end point on the stack
                //and go down the tree with the front child
                tracestack[tstack_pIndex].nodenum = aasnode.children[0]
                tstack_pIndex += 1
                if tstack_pIndex >= 127 {
                    botimport.runPrint(PRT_ERROR, "AAS_TraceBoundingBox: stack overflow\n")
                    return trace
                } //end if
            } //end if
            //if the whole to be traced line is totally at the back of this node
            //only go down the tree with the back child
            else if front < ON_EPSILON && back < ON_EPSILON {
                //keep the current start and end point on the stack
                //and go down the tree with the back child
                tracestack[tstack_pIndex].nodenum = aasnode.children[1]
                tstack_pIndex += 1
                if tstack_pIndex >= 127 {
                    botimport.runPrint(PRT_ERROR, "AAS_TraceBoundingBox: stack overflow\n")
                    return trace
                } //end if
            } //end if
            //go down the tree both at the front and back of the node
            else {
                tmpplanenum = tracestack[tstack_pIndex].planenum
                // bk010221 - new location of divide by zero (see above)
                if front == back { front -= 0.001 } // bk0101022 - hack/FPE
                //calculate the hitpoint with the node (split point of the line)
                //put the crosspoint TRACEPLANE_EPSILON pixels on the near side
                if front < 0 {
                    frac = Float((Double(front) + TRACEPLANE_EPSILON) / Double(front - back))
                } else {
                    frac = Float((Double(front) - TRACEPLANE_EPSILON) / Double(front - back)) // bk010221
                }
                //
                if frac < 0 {
                    frac = 0.001 //0
                } else if frac > 1 {
                    frac = 0.999 //1
                }
                //frac = front / (front-back);
                //
                cur_mid[0] = cur_start[0] + (cur_end[0] - cur_start[0]) * frac
                cur_mid[1] = cur_start[1] + (cur_end[1] - cur_start[1]) * frac
                cur_mid[2] = cur_start[2] + (cur_end[2] - cur_start[2]) * frac

                //			AAS_DrawPlaneCross(cur_mid, plane->normal, plane->dist, plane->type, LINECOLOR_RED);
                //side the front part of the line is on
                side = front < 0 ? 1 : 0
                //first put the end part of the line on the stack (back side)
                tracestack[tstack_pIndex].start = cur_mid
                //not necesary to store because still on stack
                //VectorCopy(cur_end, tstack_p->end);
                tracestack[tstack_pIndex].planenum = aasnode.planenum
                tracestack[tstack_pIndex].nodenum = aasnode.children[side == 0 ? 1 : 0]
                tstack_pIndex += 1
                if tstack_pIndex >= 127 {
                    botimport.runPrint(PRT_ERROR, "AAS_TraceBoundingBox: stack overflow\n")
                    return trace
                } //end if
                //now put the part near the start of the line on the stack so we will
                //continue with thats part first. This way we'll find the first
                //hit of the bbox
                tracestack[tstack_pIndex].start = cur_start
                tracestack[tstack_pIndex].end = cur_mid
                tracestack[tstack_pIndex].planenum = tmpplanenum
                tracestack[tstack_pIndex].nodenum = aasnode.children[side]
                tstack_pIndex += 1
                if tstack_pIndex >= 127 {
                    botimport.runPrint(PRT_ERROR, "AAS_TraceBoundingBox: stack overflow\n")
                    return trace
                } //end if
            } //end else
        } //end while
    }
}

//===========================================================================
// recursive subdivision of the line by the BSP tree.
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:709
public func AAS_TraceAreas(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ areas: Slots<Int32>, _ points: Slots<JKAShared.vec3_t>?, _ maxareas: Int32) -> Int32 {
    var numareas: Int32

    numareas = 0
    areas[0] = 0
    if aasworld.loaded == 0 {
        return numareas
    }

    return AasTracestack.scratch(count: 127) { tracestack -> Int32 in
        var side: Int32
        var nodenum: Int32
        var tmpplanenum: Int32
        var front: Float
        var back: Float
        var frac: Float
        var cur_start: vec3_t
        var cur_end: vec3_t
        var cur_mid = vec3_t()
        var tstack_pIndex: Int32
        var aasnode: AasNode
        var plane: AasPlane

        tstack_pIndex = 0
        //we start with the whole line on the stack
        tracestack[tstack_pIndex].start = start
        tracestack[tstack_pIndex].end = end
        tracestack[tstack_pIndex].planenum = 0
        //start with node 1 because node zero is a dummy for a solid leaf
        tracestack[tstack_pIndex].nodenum = 1 //starting at the root of the tree
        tstack_pIndex += 1

        while true {
            //pop up the stack
            tstack_pIndex -= 1
            //if the trace stack is empty (ended up with a piece of the
            //line to be traced in an area)
            if tstack_pIndex < 0 {
                return numareas
            } //end if
            //number of the current node to test the line against
            nodenum = tracestack[tstack_pIndex].nodenum
            //if it is an area
            if nodenum < 0 {
                //botimport.Print(PRT_MESSAGE, "areanum = %d, must be %d\n", -nodenum, AAS_PointAreaNum(start));
                areas[numareas] = -nodenum
                if points != nil {
                    points![numareas] = tracestack[tstack_pIndex].start
                }
                numareas += 1
                if numareas >= maxareas {
                    return numareas
                }
                continue
            } //end if
            //if it is a solid leaf
            if nodenum == 0 {
                continue
            } //end if
            //the node to test against
            aasnode = aasworld.nodesSlots[nodenum]
            //start point of current line to test against node
            cur_start = tracestack[tstack_pIndex].start
            //end point of the current line to test against node
            cur_end = tracestack[tstack_pIndex].end
            //the current node plane
            plane = aasworld.planesSlots[aasnode.planenum]

            //		switch(plane->type)
            //			default: //gee it's not an axial plane
            front = _DotProduct(cur_start, plane.normal) - plane.dist
            back = _DotProduct(cur_end, plane.normal) - plane.dist

            //if the whole to be traced line is totally at the front of this node
            //only go down the tree with the front child
            if front > 0 && back > 0 {
                //keep the current start and end point on the stack
                //and go down the tree with the front child
                tracestack[tstack_pIndex].nodenum = aasnode.children[0]
                tstack_pIndex += 1
                if tstack_pIndex >= 127 {
                    botimport.runPrint(PRT_ERROR, "AAS_TraceAreas: stack overflow\n")
                    return numareas
                } //end if
            } //end if
            //if the whole to be traced line is totally at the back of this node
            //only go down the tree with the back child
            else if front <= 0 && back <= 0 {
                //keep the current start and end point on the stack
                //and go down the tree with the back child
                tracestack[tstack_pIndex].nodenum = aasnode.children[1]
                tstack_pIndex += 1
                if tstack_pIndex >= 127 {
                    botimport.runPrint(PRT_ERROR, "AAS_TraceAreas: stack overflow\n")
                    return numareas
                } //end if
            } //end if
            //go down the tree both at the front and back of the node
            else {
                tmpplanenum = tracestack[tstack_pIndex].planenum
                //calculate the hitpoint with the node (split point of the line)
                //put the crosspoint TRACEPLANE_EPSILON pixels on the near side
                if front < 0 {
                    frac = (front) / (front - back)
                } else {
                    frac = (front) / (front - back)
                }
                if frac < 0 {
                    frac = 0
                } else if frac > 1 {
                    frac = 1
                }
                //frac = front / (front-back);
                //
                cur_mid[0] = cur_start[0] + (cur_end[0] - cur_start[0]) * frac
                cur_mid[1] = cur_start[1] + (cur_end[1] - cur_start[1]) * frac
                cur_mid[2] = cur_start[2] + (cur_end[2] - cur_start[2]) * frac

                //			AAS_DrawPlaneCross(cur_mid, plane->normal, plane->dist, plane->type, LINECOLOR_RED);
                //side the front part of the line is on
                side = front < 0 ? 1 : 0
                //first put the end part of the line on the stack (back side)
                tracestack[tstack_pIndex].start = cur_mid
                //not necesary to store because still on stack
                //VectorCopy(cur_end, tstack_p->end);
                tracestack[tstack_pIndex].planenum = aasnode.planenum
                tracestack[tstack_pIndex].nodenum = aasnode.children[side == 0 ? 1 : 0]
                tstack_pIndex += 1
                if tstack_pIndex >= 127 {
                    botimport.runPrint(PRT_ERROR, "AAS_TraceAreas: stack overflow\n")
                    return numareas
                } //end if
                //now put the part near the start of the line on the stack so we will
                //continue with thats part first. This way we'll find the first
                //hit of the bbox
                tracestack[tstack_pIndex].start = cur_start
                tracestack[tstack_pIndex].end = cur_mid
                tracestack[tstack_pIndex].planenum = tmpplanenum
                tracestack[tstack_pIndex].nodenum = aasnode.children[side]
                tstack_pIndex += 1
                if tstack_pIndex >= 127 {
                    botimport.runPrint(PRT_ERROR, "AAS_TraceAreas: stack overflow\n")
                    return numareas
                } //end if
            } //end else
        } //end while
    }
}

//===========================================================================
// a simple cross product
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
// void AAS_OrthogonalToVectors(vec3_t v1, vec3_t v2, vec3_t res)
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:896
private func AAS_OrthogonalToVectors(_ v1: vec3_t, _ v2: vec3_t, _ res: inout vec3_t) {
    res[0] = (v1[1] * v2[2]) - (v1[2] * v2[1])
    res[1] = (v1[2] * v2[0]) - (v1[0] * v2[2])
    res[2] = (v1[0] * v2[1]) - (v1[1] * v2[0])
}

//===========================================================================
// tests if the given point is within the face boundaries
//
// Parameter:				face		: face to test if the point is in it
//								pnormal	: normal of the plane to use for the face
//								point		: point to test if inside face boundaries
// Returns:					qtrue if the point is within the face boundaries
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:909
public func AAS_InsideFace(_ face: AasFace, _ pnormal: JKAShared.vec3_t, _ point: JKAShared.vec3_t, _ epsilon: Float) -> Bool {
    var i: Int32
    var firstvertex: Int32
    var edgenum: Int32
    var v0: vec3_t
    var edgevec: vec3_t
    var pointvec: vec3_t
    var sepnormal = vec3_t()
    var edge: AasEdge

    if aasworld.loaded == 0 {
        return false
    }

    i = 0
    while i < face.numedges {
        edgenum = aasworld.edgeindex![face.firstedge + i]
        edge = aasworld.edgesSlots[abs(edgenum)]
        //get the first vertex of the edge
        firstvertex = edgenum < 0 ? 1 : 0
        v0 = aasworld.vertexes![edge.v[firstvertex]]
        //edge vector
        edgevec = aasworld.vertexes![edge.v[firstvertex == 0 ? 1 : 0]] - v0
        //
        //vector from first edge point to point possible in face
        pointvec = point - v0
        //get a vector pointing inside the face orthogonal to both the
        //edge vector and the normal vector of the plane the face is in
        //this vector defines a plane through the origin (first vertex of
        //edge) and through both the edge vector and the normal vector
        //of the plane
        AAS_OrthogonalToVectors(edgevec, pnormal, &sepnormal)
        //check on wich side of the above plane the point is
        //this is done by checking the sign of the dot product of the
        //vector orthogonal vector from above and the vector from the
        //origin (first vertex of edge) to the point
        //if the dotproduct is smaller than zero the point is outside the face
        if _DotProduct(pointvec, sepnormal) < -epsilon {
            return false
        }
        i += 1
    } //end for
    return true
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:961
public func AAS_PointInsideFace(_ facenum: Int32, _ point: JKAShared.vec3_t, _ epsilon: Float) -> Bool {
    var i: Int32
    var firstvertex: Int32
    var edgenum: Int32
    var v1: vec3_t
    var v2: vec3_t
    var edgevec: vec3_t
    var pointvec: vec3_t
    var sepnormal = vec3_t()
    var edge: AasEdge
    let plane: AasPlane
    let face: AasFace

    if aasworld.loaded == 0 {
        return false
    }

    face = aasworld.facesSlots[facenum]
    plane = aasworld.planesSlots[face.planenum]
    //
    i = 0
    while i < face.numedges {
        edgenum = aasworld.edgeindex![face.firstedge + i]
        edge = aasworld.edgesSlots[abs(edgenum)]
        //get the first vertex of the edge
        firstvertex = edgenum < 0 ? 1 : 0
        // AI: Raven points `v1` and `v2` at two vertexes of the table and only reads them. The locals hold copies of the vectors.
        v1 = aasworld.vertexes![edge.v[firstvertex]]
        v2 = aasworld.vertexes![edge.v[firstvertex == 0 ? 1 : 0]]
        //edge vector
        edgevec = v2 - v1
        //vector from first edge point to point possible in face
        pointvec = point - v1
        //
        CrossProduct(edgevec, plane.normal, &sepnormal)
        //
        if _DotProduct(pointvec, sepnormal) < -epsilon {
            return false
        }
        i += 1
    } //end for
    return true
}

//===========================================================================
// returns the ground face the given point is above in the given area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1001
public func AAS_AreaGroundFace(_ areanum: Int32, _ point: JKAShared.vec3_t) -> AasFace? {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var i: Int32
    var facenum: Int32
    let up = vec3_t(0, 0, 1)
    var normal = vec3_t()
    var area: AasArea
    var face: AasFace

    if aasworld.loaded == 0 {
        return nil
    }

    area = aasworld.areasSlots[areanum]
    i = 0
    while i < area.numfaces {
        facenum = aasworld.faceindex![area.firstface + i]
        face = aasworld.facesSlots[abs(facenum)]
        //if this is a ground face
        if (face.faceflags & FACE_GROUND) != 0 {
            //get the up or down normal
            if aasworld.planesSlots[face.planenum].normal[2] < 0 {
                normal = -up
            } else {
                normal = up
            }
            //check if the point is in the face
            if AAS_InsideFace(face, normal, point, 0.01) {
                return face
            }
        } //end if
        i += 1
    } //end for
    return nil
}

//===========================================================================
// returns the face the trace end position is situated in
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1035
public func AAS_FacePlane(_ facenum: Int32, _ normal: inout JKAShared.vec3_t, _ dist: inout Float) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var plane: AasPlane

    plane = aasworld.planesSlots[aasworld.facesSlots[facenum].planenum]
    normal = plane.normal
    dist = plane.dist
}

//===========================================================================
// returns the face the trace end position is situated in
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1050
public func AAS_TraceEndFace(_ trace: AasTrace) -> AasFace? {
    // Port-note: Raven calls this function only from BotExportTest under `#ifdef DEBUG`, which the release build leaves out, so it is dead.
    var i: Int32
    var facenum: Int32
    var area: AasArea
    var face: AasFace
    let firstface: AasFace? = nil

    if aasworld.loaded == 0 {
        return nil
    }

    //if started in solid no face was hit
    if trace.startsolid {
        return nil
    }
    //trace->lastarea is the last area the trace was in
    area = aasworld.areasSlots[trace.lastarea]
    //check which face the trace.endpos was in
    i = 0
    while i < area.numfaces {
        facenum = aasworld.faceindex![area.firstface + i]
        face = aasworld.facesSlots[abs(facenum)]
        //if the face is in the same plane as the trace end point
        if (face.planenum & ~1) == (trace.planenum & ~1) {
            //firstface is used for optimization, if theres only one
            //face in the plane then it has to be the good one
            //if there are more faces in the same plane then always
            //check the one with the fewest edges first
/*			if (firstface)
            {
                if (firstface->numedges < face->numedges)
                {
                    if (AAS_InsideFace(firstface,
                        aasworld.planes[face->planenum].normal, trace->endpos))
                    {
                        return firstface;
                    } //end if
                    firstface = face;
                } //end if
                else
                {
                    if (AAS_InsideFace(face,
                        aasworld.planes[face->planenum].normal, trace->endpos))
                    {
                        return face;
                    } //end if
                } //end else
            } //end if
            else
            {
                firstface = face;
            } //end else*/
            if AAS_InsideFace(face,
                        aasworld.planesSlots[face.planenum].normal, trace.endpos, 0.01) {
                return face
            }
        } //end if
        i += 1
    } //end for
    return firstface
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1110
public func AAS_BoxOnPlaneSide2(_ absmins: JKAShared.vec3_t, _ absmaxs: JKAShared.vec3_t, _ p: AasPlane) -> Int32 {
    var i: Int32
    var sides: Int32
    let dist1: Float
    let dist2: Float
    var corners = [vec3_t](repeating: vec3_t(), count: 2)

    i = 0
    while i < 3 {
        if p.normal[i] < 0 {
            corners[0][i] = absmins[i]
            corners[1][i] = absmaxs[i]
        } //end if
        else {
            corners[1][i] = absmins[i]
            corners[0][i] = absmaxs[i]
        } //end else
        i += 1
    } //end for
    dist1 = _DotProduct(p.normal, corners[0]) - p.dist
    dist2 = _DotProduct(p.normal, corners[1]) - p.dist
    sides = 0
    if dist1 >= 0 {
        sides = 1
    }
    if dist2 < 0 {
        sides |= 2
    }

    return sides
}

//===========================================================================
// remove the links to this entity from all areas
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1175
public func AAS_UnlinkFromAreas(_ areas: AasLink?) {
    var link: AasLink?
    var nextlink: AasLink?

    link = areas
    while link != nil {
        //next area the entity is linked in
        nextlink = link!.next_area
        //remove the entity from the linked list of this area
        if link!.prev_ent != nil {
            link!.prev_ent!.next_ent = link!.next_ent
        } else {
            aasworld.arealinkedentities![link!.areanum] = link!.next_ent
        }
        if link!.next_ent != nil {
            link!.next_ent!.prev_ent = link!.prev_ent
        }
        //deallocate the link structure
        AAS_DeAllocAASLink(link!)
        link = nextlink
    } //end for
}

/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1206
public func AAS_AASLinkEntity(_ absmins: JKAShared.vec3_t, _ absmaxs: JKAShared.vec3_t, _ entnum: Int32) -> AasLink? {
    if aasworld.loaded == 0 {
        botimport.runPrint(PRT_ERROR, "AAS_LinkEntity: aas not loaded\n")
        return nil
    } //end if

    return AasLinkstack.scratch(count: 128) { linkstack -> AasLink? in
        var side: Int32
        var nodenum: Int32
        var lstack_pIndex: Int32
        var aasnode: AasNode
        var plane: AasPlane
        var link: AasLink?
        var areas: AasLink?

        areas = nil
        //
        lstack_pIndex = 0
        //we start with the whole line on the stack
        //start with node 1 because node zero is a dummy used for solid leafs
        linkstack[lstack_pIndex].nodenum = 1 //starting at the root of the tree
        lstack_pIndex += 1

        while true {
            //pop up the stack
            lstack_pIndex -= 1
            //if the trace stack is empty (ended up with a piece of the
            //line to be traced in an area)
            if lstack_pIndex < 0 {
                break
            }
            //number of the current node to test the line against
            nodenum = linkstack[lstack_pIndex].nodenum
            //if it is an area
            if nodenum < 0 {
                //NOTE: the entity might have already been linked into this area
                // because several node children can point to the same area
                link = aasworld.arealinkedentities![-nodenum]
                while link != nil {
                    if link!.entnum == entnum {
                        break
                    }
                    link = link!.next_ent
                } //end for
                if link != nil {
                    continue
                }
                //
                link = AAS_AllocAASLink()
                if link == nil {
                    return areas
                }
                link!.entnum = entnum
                link!.areanum = -nodenum
                //put the link into the double linked area list of the entity
                link!.prev_area = nil
                link!.next_area = areas
                if areas != nil {
                    areas!.prev_area = link
                }
                areas = link
                //put the link into the double linked entity list of the area
                link!.prev_ent = nil
                link!.next_ent = aasworld.arealinkedentities![-nodenum]
                if aasworld.arealinkedentities![-nodenum] != nil {
                    aasworld.arealinkedentities![-nodenum]!.prev_ent = link
                }
                aasworld.arealinkedentities![-nodenum] = link
                //
                continue
            } //end if
            //if solid leaf
            if nodenum == 0 {
                continue
            }
            //the node to test against
            aasnode = aasworld.nodesSlots[nodenum]
            //the current node plane
            plane = aasworld.planesSlots[aasnode.planenum]
            //get the side(s) the box is situated relative to the plane
            side = AAS_BoxOnPlaneSide2(absmins, absmaxs, plane)
            //if on the front side of the node
            if (side & 1) != 0 {
                linkstack[lstack_pIndex].nodenum = aasnode.children[0]
                lstack_pIndex += 1
            } //end if
            if lstack_pIndex >= 127 {
                botimport.runPrint(PRT_ERROR, "AAS_LinkEntity: stack overflow\n")
                break
            } //end if
            //if on the back side of the node
            if (side & 2) != 0 {
                linkstack[lstack_pIndex].nodenum = aasnode.children[1]
                lstack_pIndex += 1
            } //end if
            if lstack_pIndex >= 127 {
                botimport.runPrint(PRT_ERROR, "AAS_LinkEntity: stack overflow\n")
                break
            } //end if
        } //end while
        return areas
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1306
public func AAS_LinkEntityClientBBox(_ absmins: JKAShared.vec3_t, _ absmaxs: JKAShared.vec3_t, _ entnum: Int32, _ presencetype: Int32) -> AasLink? {
    var mins = vec3_t()
    var maxs = vec3_t()
    let newabsmins: vec3_t
    let newabsmaxs: vec3_t

    AAS_PresenceTypeBoundingBox(presencetype, &mins, &maxs)
    newabsmins = absmins - maxs
    newabsmaxs = absmaxs - mins
    //relink the entity
    return AAS_AASLinkEntity(newabsmins, newabsmaxs, entnum)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1323
public func AAS_BBoxAreas(_ absmins: JKAShared.vec3_t, _ absmaxs: JKAShared.vec3_t, _ areas: Slots<Int32>, _ maxareas: Int32) -> Int32 {
    let linkedareas: AasLink?
    var link: AasLink?
    var num: Int32

    linkedareas = AAS_AASLinkEntity(absmins, absmaxs, -1)
    num = 0
    link = linkedareas
    while link != nil {
        areas[num] = link!.areanum
        num += 1
        if num >= maxareas {
            break
        }
        link = link!.next_area
    } //end for
    AAS_UnlinkFromAreas(linkedareas)
    return num
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1346
public func AAS_AreaInfo(_ areanum: Int32, _ info: AasAreainfo) -> Int32 {
    let settings: AasAreasettings
    if areanum <= 0 || areanum >= aasworld.numareas {
        botimport.runPrint(PRT_ERROR, "AAS_AreaInfo: areanum %d out of range\n", areanum)
        return 0
    } //end if
    settings = aasworld.areasettingsSlots[areanum]
    info.cluster = settings.cluster
    info.contents = settings.contents
    info.flags = settings.areaflags
    info.presencetype = settings.presencetype
    info.mins = aasworld.areasSlots[areanum].mins
    info.maxs = aasworld.areasSlots[areanum].maxs
    info.center = aasworld.areasSlots[areanum].center
    return Int32(AasAreainfo.byteCount)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_sample.cpp:1372
public func AAS_PlaneFromNum(_ planenum: Int32) -> AasPlane? {
    if aasworld.loaded == 0 {
        return nil
    }

    return aasworld.planesSlots[planenum]
}
