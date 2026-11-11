import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:28
let MAX_DEBUGLINES = 1024 as Int32

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:29
let MAX_DEBUGPOLYGONS = 8192 as Int32

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:31
public var debuglines: [Int32] {
    get { world.variables.debuglines }
    set { world.variables.debuglines = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:32
public var debuglinevisible: [Int32] {
    get { world.variables.debuglinevisible }
    set { world.variables.debuglinevisible = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:33
public var numdebuglines: Int32 {
    get { world.variables.numdebuglines }
    set { world.variables.numdebuglines = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:35
private var debugpolygons: [Int32] {
    get { world.variables.be_aas_debug_debugpolygons }
    set { world.variables.be_aas_debug_debugpolygons = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:335
// AI: Raven declares `points` on the stack of AAS_ShowFacePolygon. The function uses one zeroed allocation on the storage class.
private var points_AAS_ShowFacePolygon: Slots<JKAShared.vec3_t> { world.storage.be_aas_debug_points_AAS_ShowFacePolygon }

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:43
public func AAS_ClearShownPolygons() {
    var i: Int32
//*
    i = 0
    while i < MAX_DEBUGPOLYGONS {
        if debugpolygons[i] != 0 { botimport.runDebugPolygonDelete(debugpolygons[i]) }
        debugpolygons[i] = 0
        i += 1
    } //end for
//*/
/*
    for (i = 0; i < MAX_DEBUGPOLYGONS; i++)
    {
        botimport.DebugPolygonDelete(i);
        debugpolygons[i] = 0;
    } //end for
*/
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:67
public func AAS_ShowPolygon(_ color: Int32, _ numpoints: Int32, _ points: Slots<JKAShared.vec3_t>) {
    var i: Int32

    i = 0
    while i < MAX_DEBUGPOLYGONS {
        if debugpolygons[i] == 0 {
            debugpolygons[i] = botimport.runDebugPolygonCreate(color, numpoints, points)
            break
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
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:86
public func AAS_ClearShownDebugLines() {
    var i: Int32

    //make all lines invisible
    i = 0
    while i < MAX_DEBUGLINES {
        if debuglines[i] != 0 {
            //botimport.DebugLineShow(debuglines[i], NULL, NULL, LINECOLOR_NONE);
            botimport.runDebugLineDelete(debuglines[i])
            debuglines[i] = 0
            debuglinevisible[i] = 0
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
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:108
public func AAS_DebugLine(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ color: Int32) {
    var line: Int32

    line = 0
    while line < MAX_DEBUGLINES {
        if debuglines[line] == 0 {
            debuglines[line] = botimport.runDebugLineCreate()
            debuglinevisible[line] = 0
            numdebuglines += 1
        } //end if
        if debuglinevisible[line] == 0 {
            // The engine only reads the two vectors, at sv_bot.cpp:544, so the copies are behavior-equal.
            var start = start, end = end
            botimport.runDebugLineShow(debuglines[line], &start, &end, color)
            debuglinevisible[line] = 1
            return
        } //end else
        line += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:134
public func AAS_PermanentLine(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ color: Int32) {
    var line: Int32

    line = botimport.runDebugLineCreate()
    // The engine only reads the two vectors, at sv_bot.cpp:544, so the copies are behavior-equal.
    var start = start, end = end
    botimport.runDebugLineShow(line, &start, &end, color)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:147
public func AAS_DrawPermanentCross(_ origin: JKAShared.vec3_t, _ size: Float, _ color: Int32) {
    var i: Int32, debugline: Int32
    var start = vec3_t(), end = vec3_t()

    i = 0
    while i < 3 {
        start = origin
        start[i] += size
        end = origin
        end[i] -= size
        AAS_DebugLine(start, end, color)
        debugline = botimport.runDebugLineCreate()
        botimport.runDebugLineShow(debugline, &start, &end, color)
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:169
public func AAS_DrawPlaneCross(_ point: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ dist: Float, _ type: Int32, _ color: Int32) {
    var n0: Int32, n1: Int32, n2: Int32, j: Int32, line: Int32
    var lines = [Int32](repeating: 0, count: 2)
    var start1 = vec3_t(), end1 = vec3_t(), start2 = vec3_t(), end2 = vec3_t()

    //make a cross in the hit plane at the hit point
    start1 = point
    end1 = point
    start2 = point
    end2 = point

    n0 = type % 3
    n1 = (type + 1) % 3
    n2 = (type + 2) % 3
    start1[n1] -= 6
    start1[n2] -= 6
    end1[n1] += 6
    end1[n2] += 6
    start2[n1] += 6
    start2[n2] -= 6
    end2[n1] -= 6
    end2[n2] += 6

    start1[n0] = (dist - (start1[n1] * normal[n1] +
                start1[n2] * normal[n2])) / normal[n0]
    end1[n0] = (dist - (end1[n1] * normal[n1] +
                end1[n2] * normal[n2])) / normal[n0]
    start2[n0] = (dist - (start2[n1] * normal[n1] +
                start2[n2] * normal[n2])) / normal[n0]
    end2[n0] = (dist - (end2[n1] * normal[n1] +
                end2[n2] * normal[n2])) / normal[n0]

    j = 0
    line = 0
    while j < 2 && line < MAX_DEBUGLINES {
        if debuglines[line] == 0 {
            debuglines[line] = botimport.runDebugLineCreate()
            lines[j] = debuglines[line]
            j += 1
            debuglinevisible[line] = 1
            numdebuglines += 1
        } //end if
        else if debuglinevisible[line] == 0 {
            lines[j] = debuglines[line]
            j += 1
            debuglinevisible[line] = 1
        } //end else
        line += 1
    } //end for
    botimport.runDebugLineShow(lines[0], &start1, &end1, color)
    botimport.runDebugLineShow(lines[1], &start2, &end2, color)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:225
public func AAS_ShowBoundingBox(_ origin: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) {
    var bboxcorners = [vec3_t](repeating: vec3_t(), count: 8)
    var lines = [Int32](repeating: 0, count: 3)
    var i: Int32, j: Int32, line: Int32

    //upper corners
    bboxcorners[0][0] = origin[0] + maxs[0]
    bboxcorners[0][1] = origin[1] + maxs[1]
    bboxcorners[0][2] = origin[2] + maxs[2]
    //
    bboxcorners[1][0] = origin[0] + mins[0]
    bboxcorners[1][1] = origin[1] + maxs[1]
    bboxcorners[1][2] = origin[2] + maxs[2]
    //
    bboxcorners[2][0] = origin[0] + mins[0]
    bboxcorners[2][1] = origin[1] + mins[1]
    bboxcorners[2][2] = origin[2] + maxs[2]
    //
    bboxcorners[3][0] = origin[0] + maxs[0]
    bboxcorners[3][1] = origin[1] + mins[1]
    bboxcorners[3][2] = origin[2] + maxs[2]
    //lower corners
    // AI: Raven copies the four upper corners with memcpy. The corners are a Swift array, so the loop copies each index.
    for k in 0..<4 {
        bboxcorners[4 + k] = bboxcorners[k]
    }
    i = 0
    while i < 4 { bboxcorners[4 + i][2] = origin[2] + mins[2]; i += 1 }
    //draw bounding box
    i = 0
    while i < 4 {
        j = 0
        line = 0
        while j < 3 && line < MAX_DEBUGLINES {
            if debuglines[line] == 0 {
                debuglines[line] = botimport.runDebugLineCreate()
                lines[j] = debuglines[line]
                j += 1
                debuglinevisible[line] = 1
                numdebuglines += 1
            } //end if
            else if debuglinevisible[line] == 0 {
                lines[j] = debuglines[line]
                j += 1
                debuglinevisible[line] = 1
            } //end else
            line += 1
        } //end for
        // Swift takes no two inout elements of one array in one call, so each line takes copies of its two corners.
        //top plane
        var top0 = bboxcorners[i], top1 = bboxcorners[(i + 1) & 3]
        botimport.runDebugLineShow(lines[0], &top0,
                                    &top1, LINECOLOR_RED)
        //bottom plane
        var bottom0 = bboxcorners[4 + i], bottom1 = bboxcorners[4 + ((i + 1) & 3)]
        botimport.runDebugLineShow(lines[1], &bottom0,
                                    &bottom1, LINECOLOR_RED)
        //vertical lines
        var vertical0 = bboxcorners[i], vertical1 = bboxcorners[4 + i]
        botimport.runDebugLineShow(lines[2], &vertical0,
                                    &vertical1, LINECOLOR_RED)
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:285
public func AAS_ShowFace(_ facenum: Int32) {
    var i: Int32, color: Int32, edgenum: Int32
    var edge: AasEdge
    let face: AasFace
    let plane: AasPlane
    var start = vec3_t(), end = vec3_t()

    color = LINECOLOR_YELLOW
    //check if face number is in range
    if facenum >= aasworld.numfaces {
        botimport.runPrint(PRT_ERROR, "facenum %d out of range\n", facenum)
    } //end if
    face = aasworld.facesSlots[facenum]
    //walk through the edges of the face
    i = 0
    while i < face.numedges {
        //edge number
        edgenum = abs(aasworld.edgeindex![face.firstedge + i])
        //check if edge number is in range
        if edgenum >= aasworld.numedges {
            botimport.runPrint(PRT_ERROR, "edgenum %d out of range\n", edgenum)
        } //end if
        edge = aasworld.edgesSlots[edgenum]
        if color == LINECOLOR_RED { color = LINECOLOR_GREEN }
        else if color == LINECOLOR_GREEN { color = LINECOLOR_BLUE }
        else if color == LINECOLOR_BLUE { color = LINECOLOR_YELLOW }
        else { color = LINECOLOR_RED }
        AAS_DebugLine(aasworld.vertexes![edge.v[0]],
                                        aasworld.vertexes![edge.v[1]],
                                        color)
        i += 1
    } //end for
    plane = aasworld.planesSlots[face.planenum]
    edgenum = abs(aasworld.edgeindex![face.firstedge])
    edge = aasworld.edgesSlots[edgenum]
    start = aasworld.vertexes![edge.v[0]]
    _VectorMA(start, 20, plane.normal, &end)
    AAS_DebugLine(start, end, LINECOLOR_RED)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:332
public func AAS_ShowFacePolygon(_ facenum: Int32, _ color: Int32, _ flip: Int32) {
    var i: Int32, edgenum: Int32, numpoints: Int32
    // AI: Raven declares `vec3_t points[128]` on the stack. The body uses the storage forward points_AAS_ShowFacePolygon.
    var edge: AasEdge
    let face: AasFace

    //check if face number is in range
    if facenum >= aasworld.numfaces {
        botimport.runPrint(PRT_ERROR, "facenum %d out of range\n", facenum)
    } //end if
    face = aasworld.facesSlots[facenum]
    //walk through the edges of the face
    numpoints = 0
    if flip != 0 {
        i = face.numedges - 1
        while i >= 0 {
            //edge number
            edgenum = aasworld.edgeindex![face.firstedge + i]
            edge = aasworld.edgesSlots[abs(edgenum)]
            points_AAS_ShowFacePolygon[numpoints] = aasworld.vertexes![edge.v[edgenum < 0 ? 1 : 0]]
            numpoints += 1
            i -= 1
        } //end for
    } //end if
    else {
        i = 0
        while i < face.numedges {
            //edge number
            edgenum = aasworld.edgeindex![face.firstedge + i]
            edge = aasworld.edgesSlots[abs(edgenum)]
            points_AAS_ShowFacePolygon[numpoints] = aasworld.vertexes![edge.v[edgenum < 0 ? 1 : 0]]
            numpoints += 1
            i += 1
        } //end for
    } //end else
    AAS_ShowPolygon(color, numpoints, points_AAS_ShowFacePolygon)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:377
public func AAS_ShowArea(_ areanum: Int32, _ groundfacesonly: Int32) {
    var areaedges = [Int32](repeating: 0, count: Int(MAX_DEBUGLINES))
    var numareaedges: Int32, i: Int32, j: Int32, n: Int32, color: Int32 = 0, line: Int32
    var facenum: Int32, edgenum: Int32
    let area: AasArea
    var face: AasFace
    var edge: AasEdge

    //
    numareaedges = 0
    //
    if areanum < 0 || areanum >= aasworld.numareas {
        botimport.runPrint(PRT_ERROR, "area %d out of range [0, %d]\n", areanum, aasworld.numareas)
        return
    } //end if
    //pointer to the convex area
    area = aasworld.areasSlots[areanum]
    //walk through the faces of the area
    i = 0
    while i < area.numfaces {
        facenum = abs(aasworld.faceindex![area.firstface + i])
        //check if face number is in range
        if facenum >= aasworld.numfaces {
            botimport.runPrint(PRT_ERROR, "facenum %d out of range\n", facenum)
        } //end if
        face = aasworld.facesSlots[facenum]
        //ground faces only
        if groundfacesonly != 0 {
            if (face.faceflags & (FACE_GROUND | FACE_LADDER)) == 0 { i += 1; continue }
        } //end if
        //walk through the edges of the face
        j = 0
        while j < face.numedges {
            //edge number
            edgenum = abs(aasworld.edgeindex![face.firstedge + j])
            //check if edge number is in range
            if edgenum >= aasworld.numedges {
                botimport.runPrint(PRT_ERROR, "edgenum %d out of range\n", edgenum)
            } //end if
            //check if the edge is stored already
            n = 0
            while n < numareaedges {
                if areaedges[n] == edgenum { break }
                n += 1
            } //end for
            if n == numareaedges && numareaedges < MAX_DEBUGLINES {
                areaedges[numareaedges] = edgenum
                numareaedges += 1
            } //end if
            j += 1
        } //end for
        //AAS_ShowFace(facenum);
        i += 1
    } //end for
    //draw all the edges
    n = 0
    while n < numareaedges {
        line = 0
        while line < MAX_DEBUGLINES {
            if debuglines[line] == 0 {
                debuglines[line] = botimport.runDebugLineCreate()
                debuglinevisible[line] = 0
                numdebuglines += 1
            } //end if
            if debuglinevisible[line] == 0 {
                break
            } //end else
            line += 1
        } //end for
        if line >= MAX_DEBUGLINES { return }
        edge = aasworld.edgesSlots[areaedges[n]]
        if color == LINECOLOR_RED { color = LINECOLOR_BLUE }
        else if color == LINECOLOR_BLUE { color = LINECOLOR_GREEN }
        else if color == LINECOLOR_GREEN { color = LINECOLOR_YELLOW }
        else { color = LINECOLOR_RED }
        // The engine only reads the two vectors, at sv_bot.cpp:544, so the copies are behavior-equal.
        var v0 = aasworld.vertexes![edge.v[0]], v1 = aasworld.vertexes![edge.v[1]]
        botimport.runDebugLineShow(debuglines[line],
                                    &v0,
                                    &v1,
                                    color)
        debuglinevisible[line] = 1
        n += 1
    } //end for*/
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:469
public func AAS_ShowAreaPolygons(_ areanum: Int32, _ color: Int32, _ groundfacesonly: Int32) {
    var i: Int32, facenum: Int32
    let area: AasArea
    var face: AasFace

    //
    if areanum < 0 || areanum >= aasworld.numareas {
        botimport.runPrint(PRT_ERROR, "area %d out of range [0, %d]\n", areanum, aasworld.numareas)
        return
    } //end if
    //pointer to the convex area
    area = aasworld.areasSlots[areanum]
    //walk through the faces of the area
    i = 0
    while i < area.numfaces {
        facenum = abs(aasworld.faceindex![area.firstface + i])
        //check if face number is in range
        if facenum >= aasworld.numfaces {
            botimport.runPrint(PRT_ERROR, "facenum %d out of range\n", facenum)
        } //end if
        face = aasworld.facesSlots[facenum]
        //ground faces only
        if groundfacesonly != 0 {
            if (face.faceflags & (FACE_GROUND | FACE_LADDER)) == 0 { i += 1; continue }
        } //end if
        AAS_ShowFacePolygon(facenum, color, face.frontarea != areanum ? 1 : 0)
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:508
public func AAS_DrawCross(_ origin: JKAShared.vec3_t, _ size: Float, _ color: Int32) {
    var i: Int32
    var start = vec3_t(), end = vec3_t()

    i = 0
    while i < 3 {
        start = origin
        start[i] += size
        end = origin
        end[i] -= size
        AAS_DebugLine(start, end, color)
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:528
public func AAS_PrintTravelType(_ traveltype: Int32) {
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:562
public func AAS_DrawArrow(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ linecolor: Int32, _ arrowcolor: Int32) {
    var dir = vec3_t(), cross = vec3_t(), p1 = vec3_t(), p2 = vec3_t(), up = vec3_t(0, 0, 1)
    var dot: Float

    dir = end - start
    VectorNormalize(&dir)
    dot = _DotProduct(dir, up)
    if Double(dot) > 0.99 || Double(dot) < -0.99 { cross = vec3_t(1, 0, 0) }
    else { CrossProduct(dir, up, &cross) }

    _VectorMA(end, -6, dir, &p1)
    p2 = p1
    _VectorMA(p1, 6, cross, &p1)
    _VectorMA(p2, -6, cross, &p2)

    AAS_DebugLine(start, end, linecolor)
    AAS_DebugLine(p1, end, arrowcolor)
    AAS_DebugLine(p2, end, arrowcolor)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:588
public func AAS_ShowReachability(_ reach: AasReachability) {
    var dir = vec3_t(), cmdmove = vec3_t(), velocity = vec3_t()
    var speed: Float = 0, zvel: Float = 0

    AasClientmove.scratch { move in
        AAS_ShowAreaPolygons(reach.areanum, 5, 1)
        //AAS_ShowArea(reach->areanum, qtrue);
        AAS_DrawArrow(reach.start, reach.end, LINECOLOR_BLUE, LINECOLOR_YELLOW)
        //
        if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_JUMP ||
            (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_WALKOFFLEDGE {
            AAS_HorizontalVelocityForJump(aassettings.phys_jumpvel, reach.start, reach.end, &speed)
            //
            dir = reach.end - reach.start
            dir[2] = 0
            VectorNormalize(&dir)
            //set the velocity
            velocity = dir * speed
            //set the command movement
            cmdmove = vec3_t()
            cmdmove[2] = aassettings.phys_jumpvel
            //
            AAS_PredictClientMovement(move, -1, reach.start, PRESENCE_NORMAL, 1,
                                        velocity, cmdmove, 3, 30, 0.1,
                                        SE_HITGROUND | SE_ENTERWATER | SE_ENTERSLIME |
                                        SE_ENTERLAVA | SE_HITGROUNDDAMAGE, 0, 1)
            //
            if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_JUMP {
                AAS_JumpReachRunStart(reach, &dir)
                AAS_DrawCross(dir, 4, LINECOLOR_BLUE)
            } //end if
        } //end if
        else if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_ROCKETJUMP {
            zvel = AAS_RocketJumpZVelocity(reach.start)
            AAS_HorizontalVelocityForJump(zvel, reach.start, reach.end, &speed)
            //
            dir = reach.end - reach.start
            dir[2] = 0
            VectorNormalize(&dir)
            //get command movement
            cmdmove = dir * speed
            velocity = vec3_t(0, 0, zvel)
            //
            AAS_PredictClientMovement(move, -1, reach.start, PRESENCE_NORMAL, 1,
                                        velocity, cmdmove, 30, 30, 0.1,
                                        SE_ENTERWATER | SE_ENTERSLIME |
                                        SE_ENTERLAVA | SE_HITGROUNDDAMAGE |
                                        SE_TOUCHJUMPPAD | SE_HITGROUNDAREA, reach.areanum, 1)
        } //end else if
        else if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_JUMPPAD {
            cmdmove = vec3_t(0, 0, 0)
            //
            dir = reach.end - reach.start
            dir[2] = 0
            VectorNormalize(&dir)
            //set the velocity
            //NOTE: the edgenum is the horizontal velocity
            velocity = dir * Float(reach.edgenum)
            //NOTE: the facenum is the Z velocity
            velocity[2] = Float(reach.facenum)
            //
            AAS_PredictClientMovement(move, -1, reach.start, PRESENCE_NORMAL, 1,
                                        velocity, cmdmove, 30, 30, 0.1,
                                        SE_ENTERWATER | SE_ENTERSLIME |
                                        SE_ENTERLAVA | SE_HITGROUNDDAMAGE |
                                        SE_TOUCHJUMPPAD | SE_HITGROUNDAREA, reach.areanum, 1)
        } //end else if
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:670
// AI: Raven declares `reach` static in AAS_ShowReachableAreas. The function uses one zeroed allocation on the storage class.
var reach_AAS_ShowReachableAreas: AasReachability { world.storage.reach_AAS_ShowReachableAreas }

/// Raven's `static int index` of `AAS_ShowReachableAreas`, a property of `EngineWorld`.
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:671
var index: Int32 {
    get { world.index }
    set { world.index = newValue }
}

/// Raven's `static int lastareanum` of `AAS_ShowReachableAreas`, a property of `EngineWorld`.
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:671
var lastareanum: Int32 {
    get { world.lastareanum }
    set { world.lastareanum = newValue }
}

/// Raven's `static float lasttime` of `AAS_ShowReachableAreas`, a property of `EngineWorld`.
/// Source: oracle/codemp/botlib/be_aas_debug.cpp:672
var lasttime_AAS_ShowReachableAreas: Float {
    get { world.lasttime_AAS_ShowReachableAreas }
    set { world.lasttime_AAS_ShowReachableAreas = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:667
public func AAS_ShowReachableAreas(_ areanum: Int32) {
    // Raven's static locals `reach` and `lasttime` take the function name as a suffix here.
    let settings: AasAreasettings

    if areanum != lastareanum {
        index = 0
        lastareanum = areanum
    } //end if
    settings = aasworld.areasettingsSlots[areanum]
    //
    if settings.numreachableareas == 0 { return }
    //
    if index >= settings.numreachableareas { index = 0 }
    //
    if Double(AAS_Time() - lasttime_AAS_ShowReachableAreas) > 1.5 {
        reach_AAS_ShowReachableAreas.copy(from: aasworld.reachabilitySlots[settings.firstreachablearea + index])
        index += 1
        lasttime_AAS_ShowReachableAreas = AAS_Time()
        AAS_PrintTravelType(reach_AAS_ShowReachableAreas.traveltype & TRAVELTYPE_MASK)
        botimport.runPrint(PRT_MESSAGE, "\n")
    } //end if
    AAS_ShowReachability(reach_AAS_ShowReachableAreas)
}

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:696
public func AAS_FloodAreas_r(_ areanum: Int32, _ cluster: Int32, _ done: Slots<Int32>) {
    var nextareanum: Int32, i: Int32, facenum: Int32
    let area: AasArea
    var face: AasFace
    let settings: AasAreasettings
    var reach: AasReachability

    AAS_ShowAreaPolygons(areanum, 1, 1)
    //pointer to the convex area
    area = aasworld.areasSlots[areanum]
    settings = aasworld.areasettingsSlots[areanum]
    //walk through the faces of the area
    i = 0
    while i < area.numfaces {
        facenum = abs(aasworld.faceindex![area.firstface + i])
        face = aasworld.facesSlots[facenum]
        if face.frontarea == areanum {
            nextareanum = face.backarea
        } else {
            nextareanum = face.frontarea
        }
        if nextareanum == 0 {
            i += 1
            continue
        }
        if done[nextareanum] != 0 {
            i += 1
            continue
        }
        done[nextareanum] = 1
        if (aasworld.areasettingsSlots[nextareanum].contents & AREACONTENTS_VIEWPORTAL) != 0 {
            i += 1
            continue
        }
        if AAS_AreaCluster(nextareanum) != cluster {
            i += 1
            continue
        }
        AAS_FloodAreas_r(nextareanum, cluster, done)
        i += 1
    } //end for
    //
    i = 0
    while i < settings.numreachableareas {
        reach = aasworld.reachabilitySlots[settings.firstreachablearea + i]
        nextareanum = reach.areanum
        if nextareanum == 0 {
            i += 1
            continue
        }
        if done[nextareanum] != 0 {
            i += 1
            continue
        }
        done[nextareanum] = 1
        if (aasworld.areasettingsSlots[nextareanum].contents & AREACONTENTS_VIEWPORTAL) != 0 {
            i += 1
            continue
        }
        if AAS_AreaCluster(nextareanum) != cluster {
            i += 1
            continue
        }
        /*
        if ((reach->traveltype & TRAVELTYPE_MASK) == TRAVEL_WALKOFFLEDGE)
        {
            AAS_DebugLine(reach->start, reach->end, 1);
        }
        */
        AAS_FloodAreas_r(nextareanum, cluster, done)
        i += 1
    }
}

/// Source: oracle/codemp/botlib/be_aas_debug.cpp:752
public func AAS_FloodAreas(_ origin: JKAShared.vec3_t) {
    var areanum: Int32, cluster: Int32
    let done: Slots<Int32>

    done = Slots<Int32>(scalars: GetClearedMemory(aasworld.numareas * Int32(Int32.byteCount)), count: Int(aasworld.numareas))
    areanum = AAS_PointAreaNum(origin)
    cluster = AAS_AreaCluster(areanum)
    AAS_FloodAreas_r(areanum, cluster, done)
}
