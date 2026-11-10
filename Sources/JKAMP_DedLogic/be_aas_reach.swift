import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:37
let AAS_MAX_REACHABILITYSIZE = 65536 as Int32

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:39
let REACHABILITYAREASPERCYCLE = 15 as Int32

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:41
let INSIDEUNITS = 2 as Int32

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:42
let INSIDEUNITS_WALKEND = 5 as Int32

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:43
let INSIDEUNITS_WALKSTART = 0.1 as Double

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:44
let INSIDEUNITS_WATERJUMP = 15 as Int32

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:46
let AREA_WEAPONJUMP = 8192 as Int32

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:48
var reach_swim: Int32 {
    get { world.variables.reach_swim }
    set { world.variables.reach_swim = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:49
var reach_equalfloor: Int32 {
    get { world.variables.reach_equalfloor }
    set { world.variables.reach_equalfloor = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:50
var reach_step: Int32 {
    get { world.variables.reach_step }
    set { world.variables.reach_step = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:51
var reach_walk: Int32 {
    get { world.variables.reach_walk }
    set { world.variables.reach_walk = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:52
var reach_barrier: Int32 {
    get { world.variables.reach_barrier }
    set { world.variables.reach_barrier = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:53
var reach_waterjump: Int32 {
    get { world.variables.reach_waterjump }
    set { world.variables.reach_waterjump = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:54
var reach_walkoffledge: Int32 {
    get { world.variables.reach_walkoffledge }
    set { world.variables.reach_walkoffledge = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:55
var reach_jump: Int32 {
    get { world.variables.reach_jump }
    set { world.variables.reach_jump = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:56
var reach_ladder: Int32 {
    get { world.variables.reach_ladder }
    set { world.variables.reach_ladder = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:57
var reach_teleport: Int32 {
    get { world.variables.reach_teleport }
    set { world.variables.reach_teleport = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:58
var reach_elevator: Int32 {
    get { world.variables.reach_elevator }
    set { world.variables.reach_elevator = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:59
var reach_funcbob: Int32 {
    get { world.variables.reach_funcbob }
    set { world.variables.reach_funcbob = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:60
var reach_grapple: Int32 {
    get { world.variables.reach_grapple }
    set { world.variables.reach_grapple = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:61
// Raven wrote: int reach_doublejump
let reach_doublejump: Int32 = 0

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:62
// Raven wrote: int reach_rampjump
let reach_rampjump: Int32 = 0

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:63
// Raven wrote: int reach_strafejump
let reach_strafejump: Int32 = 0

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:64
var reach_rocketjump: Int32 {
    get { world.variables.reach_rocketjump }
    set { world.variables.reach_rocketjump = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:65
// Raven wrote: int reach_bfgjump
let reach_bfgjump: Int32 = 0

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:66
var reach_jumppad: Int32 {
    get { world.variables.reach_jumppad }
    set { world.variables.reach_jumppad = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:68
var calcgrapplereach: Int32 {
    get { world.variables.calcgrapplereach }
    set { world.variables.calcgrapplereach = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:83
var reachabilityheap: Slots<AasLreachability>? {
    get { world.variables.reachabilityheap }
    set { world.variables.reachabilityheap = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:84
var nextreachability: AasLreachability? {
    get { world.variables.nextreachability }
    set { world.variables.nextreachability = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:85
var areareachability: Slots<AasLreachability?>? {
    get { world.variables.areareachability }
    set { world.variables.areareachability = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:86
var numlreachabilities: Int32 {
    get { world.variables.numlreachabilities }
    set { world.variables.numlreachabilities = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:1044
// AI: Raven declares `areas` on the stack of AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge. The function uses one zeroed allocation on the storage class.
private var areas_AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge: Slots<Int32> { world.storage.be_aas_reach_areas_AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge }

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:2095
// AI: Raven declares `areas` on the stack of AAS_Reachability_Jump. The function uses one zeroed allocation on the storage class.
private var areas_AAS_Reachability_Jump: Slots<Int32> { world.storage.be_aas_reach_areas_AAS_Reachability_Jump }

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3271
// AI: Raven declares `areas` on the stack of AAS_Reachability_FuncBobbing. The function uses one zeroed allocation on the storage class.
private var areas_AAS_Reachability_FuncBobbing: Slots<Int32> { world.storage.be_aas_reach_areas_AAS_Reachability_FuncBobbing }

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3275
// AI: Raven declares `start_edgeverts` on the stack of AAS_Reachability_FuncBobbing. The function uses one zeroed allocation on the storage class.
var start_edgeverts_AAS_Reachability_FuncBobbing: Slots<JKAShared.vec3_t> { world.storage.start_edgeverts_AAS_Reachability_FuncBobbing }

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3275
// AI: Raven declares `end_edgeverts` on the stack of AAS_Reachability_FuncBobbing. The function uses one zeroed allocation on the storage class.
var end_edgeverts_AAS_Reachability_FuncBobbing: Slots<JKAShared.vec3_t> { world.storage.end_edgeverts_AAS_Reachability_FuncBobbing }

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3276
// AI: Raven declares `points` on the stack of AAS_Reachability_FuncBobbing. The function uses one zeroed allocation on the storage class.
private var points_AAS_Reachability_FuncBobbing: Slots<JKAShared.vec3_t> { world.storage.be_aas_reach_points_AAS_Reachability_FuncBobbing }

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3778
// AI: Raven declares `areas` on the stack of AAS_Reachability_Grapple. The function uses one zeroed allocation on the storage class.
private var areas_AAS_Reachability_Grapple: Slots<Int32> { world.storage.be_aas_reach_areas_AAS_Reachability_Grapple }

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:4111
// AI: Raven declares `areas` on the stack of AAS_Reachability_WalkOffLedge. The function uses one zeroed allocation on the storage class.
private var areas_AAS_Reachability_WalkOffLedge: Slots<Int32> { world.storage.be_aas_reach_areas_AAS_Reachability_WalkOffLedge }

//===========================================================================
// returns the surface area of the given face
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:95
func AAS_FaceArea(_ face: AasFace) -> Float {
    var i: Int32, edgenum: Int32, side: Int32
    var total: Float
    let v: vec3_t
    var d1 = vec3_t(), d2 = vec3_t(), cross = vec3_t()
    var edge: AasEdge

    edgenum = aasworld.edgeindex![face.firstedge]
    side = edgenum < 0 ? 1 : 0
    edge = aasworld.edgesSlots[abs(edgenum)]
    v = aasworld.vertexes![edge.v[side]]

    total = 0
    i = 1
    while i < face.numedges - 1 {
        edgenum = aasworld.edgeindex![face.firstedge + i]
        side = edgenum < 0 ? 1 : 0
        edge = aasworld.edgesSlots[abs(edgenum)]
        d1 = aasworld.vertexes![edge.v[side]] - v
        d2 = aasworld.vertexes![edge.v[side == 0 ? 1 : 0]] - v
        CrossProduct(d1, d2, &cross)
        total = Float(Double(total) + 0.5 * Double(VectorLength(cross)))
        i += 1
    } //end for
    return total
}

//===========================================================================
// returns the volume of an area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:128
func AAS_AreaVolume(_ areanum: Int32) -> Float {
    var i: Int32, edgenum: Int32, facenum: Int32, side: Int32
    var d: vec_t, a: vec_t, volume: vec_t
    var corner = vec3_t()
    var plane: AasPlane
    var edge: AasEdge
    var face: AasFace
    var area: AasArea

    area = aasworld.areasSlots[areanum]
    facenum = aasworld.faceindex![area.firstface]
    face = aasworld.facesSlots[abs(facenum)]
    edgenum = aasworld.edgeindex![face.firstedge]
    edge = aasworld.edgesSlots[abs(edgenum)]
    //
    corner = aasworld.vertexes![edge.v[0]]

    //make tetrahedrons to all other faces
    volume = 0
    i = 0
    while i < area.numfaces {
        facenum = abs(aasworld.faceindex![area.firstface + i])
        face = aasworld.facesSlots[facenum]
        side = face.backarea != areanum ? 1 : 0
        plane = aasworld.planesSlots[face.planenum ^ side]
        d = -(_DotProduct(corner, plane.normal) - plane.dist)
        a = AAS_FaceArea(face)
        volume += d * a
        i += 1
    } //end for

    volume /= 3
    return volume
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:168
func AAS_BestReachableLinkArea(_ areas: AasLink?) -> Int32 {
    var link: AasLink?

    link = areas
    while link != nil {
        if AAS_AreaGrounded(link!.areanum) != 0 || AAS_AreaSwim(link!.areanum) != 0 {
            return link!.areanum
        } //end if
        link = link!.next_area
    } //end for
    //
    link = areas
    while link != nil {
        if link!.areanum != 0 { return link!.areanum }
        //FIXME: this is a bad idea when the reachability is not yet
        // calculated when the level items are loaded
        if AAS_AreaReachability(link!.areanum) != 0 {
            return link!.areanum
        }
        link = link!.next_area
    } //end for
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:196
func AAS_GetJumpPadInfo(_ ent: Int32, _ areastart: inout JKAShared.vec3_t, _ absmins: inout JKAShared.vec3_t, _ absmaxs: inout JKAShared.vec3_t, _ velocity: inout JKAShared.vec3_t) -> Int32 {
    return AasTrace.scratch { trace -> Int32 in
        var modelnum: Int32, ent2: Int32
        var speed: Float = 0, height: Float, gravity: Float, time: Float, dist: Float, forward: Float
        var origin = vec3_t(), angles = vec3_t(), teststart = vec3_t(), ent2origin = vec3_t()
        var model = CharBuf(MAX_EPAIRKEY)
        var target = CharBuf(MAX_EPAIRKEY), targetname = CharBuf(MAX_EPAIRKEY)

        //
        _ = AAS_FloatForBSPEpairKey(ent, "speed", &speed)
        if speed == 0 { speed = 1000 }
        angles = vec3_t()
        //get the mins, maxs and origin of the model
        _ = AAS_ValueForBSPEpairKey(ent, "model", &model, MAX_EPAIRKEY)
        if model[0] != 0 {
            modelnum = atoi(model[1...])
        } else {
            modelnum = 0
        }
        AAS_BSPModelMinsMaxsOrigin(modelnum, angles, &absmins, &absmaxs, &origin)
        absmins = origin + absmins
        absmaxs = origin + absmaxs
        origin = absmins + absmaxs
        origin = origin * 0.5

        //get the start areas
        teststart = origin
        teststart[2] += 64
        trace.copy(from: AAS_TraceClientBBox(teststart, origin, PRESENCE_CROUCH, -1))
        if trace.startsolid {
            botimport.runPrint(PRT_MESSAGE, "trigger_push start solid\n")
            areastart = origin
        } //end if
        else {
            areastart = trace.endpos
        } //end else
        areastart[2] += 0.125
        //
        //AAS_DrawPermanentCross(origin, 4, 4);
        //get the target entity
        _ = AAS_ValueForBSPEpairKey(ent, "target", &target, MAX_EPAIRKEY)
        ent2 = AAS_NextBSPEntity(0)
        while ent2 != 0 {
            if AAS_ValueForBSPEpairKey(ent2, "targetname", &targetname, MAX_EPAIRKEY) == 0 {
                ent2 = AAS_NextBSPEntity(ent2)
                continue
            }
            if strcmp(targetname, target) == 0 { break }
            ent2 = AAS_NextBSPEntity(ent2)
        } //end for
        if ent2 == 0 {
            botimport.runPrint(PRT_MESSAGE, "trigger_push without target entity %s\n", String(target))
            return 0
        } //end if
        _ = AAS_VectorForBSPEpairKey(ent2, "origin", &ent2origin)
        //
        height = ent2origin[2] - origin[2]
        gravity = aassettings.phys_gravity
        time = Float(sqrt(Double(height) / (0.5 * Double(gravity))))
        if time == 0 {
            botimport.runPrint(PRT_MESSAGE, "trigger_push without time\n")
            return 0
        } //end if
        // set s.origin2 to the push velocity
        velocity = ent2origin - origin
        dist = VectorNormalize(&velocity)
        forward = dist / time
        //FIXME: why multiply by 1.1
        forward *= 1.1
        velocity = velocity * forward
        velocity[2] = time * gravity
        return 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:273
func AAS_BestReachableFromJumpPadArea(_ origin: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) -> Int32 {
    return AasClientmove.scratch { move -> Int32 in
        var area2num: Int32, ent: Int32, bot_visualizejumppads: Int32, bestareanum: Int32
        var volume: Float, bestareavolume: Float
        var areastart = vec3_t(), cmdmove = vec3_t(), bboxmins = vec3_t(), bboxmaxs = vec3_t()
        var absmins = vec3_t(), absmaxs = vec3_t(), velocity = vec3_t()
        var areas: AasLink?, link: AasLink?
        var classname = CharBuf(MAX_EPAIRKEY)

        bot_visualizejumppads = Int32(LibVarValue("bot_visualizejumppads", "0"))
        bboxmins = origin + mins
        bboxmaxs = origin + maxs
        ent = AAS_NextBSPEntity(0)
        while ent != 0 {
            if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            if strcmp(classname, "trigger_push") != 0 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            //
            if AAS_GetJumpPadInfo(ent, &areastart, &absmins, &absmaxs, &velocity) == 0 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            //get the areas the jump pad brush is in
            areas = AAS_LinkEntityClientBBox(absmins, absmaxs, -1, PRESENCE_CROUCH)
            link = areas
            while link != nil {
                if AAS_AreaJumpPad(link!.areanum) != 0 { break }
                link = link!.next_area
            } //end for
            if link == nil {
                botimport.runPrint(PRT_MESSAGE, "trigger_push not in any jump pad area\n")
                AAS_UnlinkFromAreas(areas)
                ent = AAS_NextBSPEntity(ent)
                continue
            } //end if
            //
            //botimport.Print(PRT_MESSAGE, "found a trigger_push with velocity %f %f %f\n", velocity[0], velocity[1], velocity[2]);
            //
            cmdmove = vec3_t(0, 0, 0)
            move.clear()
            area2num = 0
            _ = AAS_ClientMovementHitBBox(move, -1, areastart, PRESENCE_NORMAL, 0, velocity, cmdmove, 0, 30, 0.1, bboxmins, bboxmaxs, bot_visualizejumppads)
            if move.frames < 30 {
                bestareanum = 0
                bestareavolume = 0
                link = areas
                while link != nil {
                    if AAS_AreaJumpPad(link!.areanum) == 0 {
                        link = link!.next_area
                        continue
                    }
                    volume = AAS_AreaVolume(link!.areanum)
                    if volume >= bestareavolume {
                        bestareanum = link!.areanum
                        bestareavolume = volume
                    } //end if
                    link = link!.next_area
                } //end if
                AAS_UnlinkFromAreas(areas)
                return bestareanum
            } //end if
            AAS_UnlinkFromAreas(areas)
            ent = AAS_NextBSPEntity(ent)
        } //end for
        return 0
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:343
func AAS_BestReachableArea(_ origin: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ goalorigin: inout JKAShared.vec3_t) -> Int32 {
    return AasTrace.scratch { trace -> Int32 in
        var areanum: Int32, i: Int32, j: Int32, k: Int32, l: Int32
        var areas: AasLink?
        var absmins = vec3_t(), absmaxs = vec3_t()
        //vec3_t bbmins, bbmaxs;
        var start = vec3_t(), end = vec3_t()

        if aasworld.loaded == 0 {
            botimport.runPrint(PRT_ERROR, "AAS_BestReachableArea: aas not loaded\n")
            return 0
        } //end if
        //find a point in an area
        start = origin
        areanum = AAS_PointAreaNum(start)
        //while no area found fudge around a little
        i = 0
        while i < 5 && areanum == 0 {
            j = 0
            while j < 5 && areanum == 0 {
                k = -1
                while k <= 1 && areanum == 0 {
                    l = -1
                    while l <= 1 && areanum == 0 {
                        start = origin
                        start[0] += Float(j) * 4 * k
                        start[1] += Float(j) * 4 * l
                        start[2] += Float(i) * 4
                        areanum = AAS_PointAreaNum(start)
                        l += 1
                    } //end for
                    k += 1
                } //end for
                j += 1
            } //end for
            i += 1
        } //end for
        //if an area was found
        if areanum != 0 {
            //drop client bbox down and try again
            end = start
            start[2] += 0.25
            end[2] -= 50
            trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, -1))
            if !trace.startsolid {
                areanum = AAS_PointAreaNum(trace.endpos)
                goalorigin = trace.endpos
                //FIXME: cannot enable next line right now because the reachability
                // does not have to be calculated when the level items are loaded
                //if the origin is in an area with reachability
                //if (AAS_AreaReachability(areanum)) return areanum;
                if areanum != 0 { return areanum }
            } //end if
            else {
                //it can very well happen that the AAS_PointAreaNum function tells that
                //a point is in an area and that starting a AAS_TraceClientBBox from that
                //point will return trace.startsolid qtrue
                goalorigin = start
                return areanum
            } //end else
        } //end if
        //
        //AAS_PresenceTypeBoundingBox(PRESENCE_CROUCH, bbmins, bbmaxs);
        //NOTE: the goal origin does not have to be in the goal area
        // because the bot will have to move towards the item origin anyway
        goalorigin = origin
        //
        absmins = origin + mins
        absmaxs = origin + maxs
        //add bounding box size
        //VectorSubtract(absmins, bbmaxs, absmins);
        //VectorSubtract(absmaxs, bbmins, absmaxs);
        //link an invalid (-1) entity
        areas = AAS_LinkEntityClientBBox(absmins, absmaxs, -1, PRESENCE_CROUCH)
        //get the reachable link arae
        areanum = AAS_BestReachableLinkArea(areas)
        //unlink the invalid entity
        AAS_UnlinkFromAreas(areas)
        //
        return areanum
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:439
func AAS_SetupReachabilityHeap() {
    var i: Int32

    reachabilityheap = Slots<AasLreachability>(GetClearedMemory(AAS_MAX_REACHABILITYSIZE * Int32(AasLreachability.byteCount)), count: AAS_MAX_REACHABILITYSIZE)
    i = 0
    while i < AAS_MAX_REACHABILITYSIZE - 1 {
        reachabilityheap![i].next = reachabilityheap![i + 1]
        i += 1
    } //end for
    reachabilityheap![AAS_MAX_REACHABILITYSIZE - 1].next = nil
    nextreachability = reachabilityheap![0]
    numlreachabilities = 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:459
func AAS_ShutDownReachabilityHeap() {
    FreeMemory(OpaquePointer(reachabilityheap!.base))
    numlreachabilities = 0
}

//===========================================================================
// returns a reachability link
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:471
func AAS_AllocReachability() -> AasLreachability? {
    var r: AasLreachability?

    if nextreachability == nil { return nil }
    //make sure the error message only shows up once
    if nextreachability!.next == nil { AAS_Error("AAS_MAX_REACHABILITYSIZE") }
    //
    r = nextreachability
    nextreachability = nextreachability!.next
    numlreachabilities += 1
    return r
}

//===========================================================================
// frees a reachability link
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:491
func AAS_FreeReachability(_ lreach: AasLreachability) {
    lreach.clear()

    lreach.next = nextreachability
    nextreachability = lreach
    numlreachabilities -= 1
}

//===========================================================================
// returns qtrue if the area has reachability links
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:506
func AAS_AreaReachability(_ areanum: Int32) -> Int32 {
    if areanum < 0 || areanum >= aasworld.numareas {
        AAS_Error("AAS_AreaReachability: areanum %d out of range", areanum)
        return 0
    } //end if
    return aasworld.areasettingsSlots[areanum].numreachableareas
}

//===========================================================================
// returns the surface area of all ground faces together of the area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:522
func AAS_AreaGroundFaceArea(_ areanum: Int32) -> Float {
    var i: Int32
    var total: Float
    var area: AasArea
    var face: AasFace

    total = 0
    area = aasworld.areasSlots[areanum]
    i = 0
    while i < area.numfaces {
        face = aasworld.facesSlots[abs(aasworld.faceindex![area.firstface + i])]
        if (face.faceflags & FACE_GROUND) == 0 {
            i += 1
            continue
        }
        //
        total += AAS_FaceArea(face)
        i += 1
    } //end for
    return total
}

//===========================================================================
// returns the center of a face
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:547
func AAS_FaceCenter(_ facenum: Int32, _ center: inout JKAShared.vec3_t) {
    var i: Int32
    var scale: Float
    var face: AasFace
    var edge: AasEdge

    face = aasworld.facesSlots[facenum]

    center = vec3_t()
    i = 0
    while i < face.numedges {
        edge = aasworld.edgesSlots[abs(aasworld.edgeindex![face.firstedge + i])]
        center = center + aasworld.vertexes![edge.v[0]]
        center = center + aasworld.vertexes![edge.v[1]]
        i += 1
    } //end for
    scale = Float(0.5 / Double(face.numedges))
    center = center * scale
}

//===========================================================================
// returns the maximum distance a player can fall before being damaged
// damage = deltavelocity*deltavelocity  * 0.0001
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:574
func AAS_FallDamageDistance() -> Int32 {
    var maxzvelocity: Float, gravity: Float, t: Float

    maxzvelocity = sqrt(Float(30 * 10000))
    gravity = aassettings.phys_gravity
    t = maxzvelocity / gravity
    return Int32(0.5 * Double(gravity) * Double(t) * Double(t))
}

//===========================================================================
// distance = 0.5 * gravity * t * t
// vel = t * gravity
// damage = vel * vel * 0.0001
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:592
func AAS_FallDelta(_ distance: Float) -> Float {
    var t: Float, delta: Float, gravity: Float

    gravity = aassettings.phys_gravity
    t = sqrt(abs(distance) * 2 / gravity)
    delta = t * gravity
    return Float(Double(delta * delta) * 0.0001)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:607
func AAS_MaxJumpHeight(_ phys_jumpvel: Float) -> Float {
    var phys_gravity: Float

    phys_gravity = aassettings.phys_gravity
    //maximum height a player can jump with the given initial z velocity
    return Float(0.5 * Double(phys_gravity) * Double(phys_jumpvel / phys_gravity) * Double(phys_jumpvel / phys_gravity))
}

//===========================================================================
// returns true if a player can only crouch in the area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:622
func AAS_MaxJumpDistance(_ phys_jumpvel: Float) -> Float {
    var phys_gravity: Float, phys_maxvelocity: Float, t: Float

    phys_gravity = aassettings.phys_gravity
    phys_maxvelocity = aassettings.phys_maxvelocity
    //time a player takes to fall the height
    t = Float(sqrt(Double(aassettings.rs_maxjumpfallheight) / (0.5 * Double(phys_gravity))))
    //maximum distance
    return phys_maxvelocity * (t + phys_jumpvel / phys_gravity)
}

//===========================================================================
// returns true if a player can only crouch in the area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:640
func AAS_AreaCrouch(_ areanum: Int32) -> Int32 {
    if (aasworld.areasettingsSlots[areanum].presencetype & PRESENCE_NORMAL) == 0 {
        return 1
    } else {
        return 0
    }
}

//===========================================================================
// returns qtrue if it is possible to swim in the area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:652
func AAS_AreaSwim(_ areanum: Int32) -> Int32 {
    if (aasworld.areasettingsSlots[areanum].areaflags & AREA_LIQUID) != 0 {
        return 1
    } else {
        return 0
    }
}

//===========================================================================
// returns qtrue if the area contains a liquid
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:664
func AAS_AreaLiquid(_ areanum: Int32) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    if (aasworld.areasettingsSlots[areanum].areaflags & AREA_LIQUID) != 0 { return 1 }
    else { return 0 }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:675
func AAS_AreaLava(_ areanum: Int32) -> Int32 {
    return (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_LAVA)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:685
func AAS_AreaSlime(_ areanum: Int32) -> Int32 {
    return (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_SLIME)
}

//===========================================================================
// returns qtrue if the area contains ground faces
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:696
func AAS_AreaGrounded(_ areanum: Int32) -> Int32 {
    return (aasworld.areasettingsSlots[areanum].areaflags & AREA_GROUNDED)
}

//===========================================================================
// returns true if the area contains ladder faces
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:707
func AAS_AreaLadder(_ areanum: Int32) -> Int32 {
    return (aasworld.areasettingsSlots[areanum].areaflags & AREA_LADDER)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:717
func AAS_AreaJumpPad(_ areanum: Int32) -> Int32 {
    return (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_JUMPPAD)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:727
func AAS_AreaTeleporter(_ areanum: Int32) -> Int32 {
    return (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_TELEPORTER)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:737
func AAS_AreaClusterPortal(_ areanum: Int32) -> Int32 {
    return (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_CLUSTERPORTAL)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:747
func AAS_AreaDoNotEnter(_ areanum: Int32) -> Int32 {
    return (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_DONOTENTER)
}

//===========================================================================
// returns the time it takes perform a barrier jump
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:758
func AAS_BarrierJumpTravelTime() -> Int32 {
    // Port-note: Raven calls this function only from a comment, at be_aas_reach.cpp:1471, so it is dead.
    return Int32(UInt16(truncatingIfNeeded: Int32(Double(aassettings.phys_jumpvel) / (Double(aassettings.phys_gravity) * 0.1))))
}

//===========================================================================
// returns true if there already exists a reachability from area1 to area2
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:769
func AAS_ReachabilityExists(_ area1num: Int32, _ area2num: Int32) -> Bool {
    var r: AasLreachability?

    r = areareachability![area1num]
    while r != nil {
        if r!.areanum == area2num { return true }
        r = r!.next
    } //end for
    return false
}

//===========================================================================
// returns true if there is a solid just after the end point when going
// from start to end
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:787
func AAS_NearbySolidOrGap(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) -> Int32 {
    // Port-note: Raven calls this function only from comments, at be_aas_reach.cpp:978 and in the blocks of :1022 and :1366, so it is dead.
    var dir = vec3_t(), testpoint = vec3_t()
    var areanum: Int32

    dir = end - start
    dir[2] = 0
    _ = VectorNormalize(&dir)
    _VectorMA(end, 48, dir, &testpoint)

    areanum = AAS_PointAreaNum(testpoint)
    if areanum == 0 {
        testpoint[2] += 16
        areanum = AAS_PointAreaNum(testpoint)
        if areanum == 0 { return 1 }
    } //end if
    _VectorMA(end, 64, dir, &testpoint)
    areanum = AAS_PointAreaNum(testpoint)
    if areanum != 0 {
        if AAS_AreaSwim(areanum) == 0 && AAS_AreaGrounded(areanum) == 0 { return 1 }
    } //end if
    return 0
}

//===========================================================================
// searches for swim reachabilities between adjacent areas
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:819
func AAS_Reachability_Swim(_ area1num: Int32, _ area2num: Int32) -> Int32 {
    var i: Int32, j: Int32, face1num: Int32, face2num: Int32, side1: Int32
    var area1: AasArea, area2: AasArea
    var areasettings: AasAreasettings
    var lreach: AasLreachability?
    var face1: AasFace
    var plane: AasPlane
    var start = vec3_t()

    if AAS_AreaSwim(area1num) == 0 || AAS_AreaSwim(area2num) == 0 { return 0 }
    //if the second area is crouch only
    if (aasworld.areasettingsSlots[area2num].presencetype & PRESENCE_NORMAL) == 0 { return 0 }

    area1 = aasworld.areasSlots[area1num]
    area2 = aasworld.areasSlots[area2num]

    //if the areas are not near anough
    i = 0
    while i < 3 {
        if area1.mins[i] > area2.maxs[i] + 10 { return 0 }
        if area1.maxs[i] < area2.mins[i] - 10 { return 0 }
        i += 1
    } //end for
    //find a shared face and create a reachability link
    i = 0
    while i < area1.numfaces {
        face1num = aasworld.faceindex![area1.firstface + i]
        side1 = face1num < 0 ? 1 : 0
        face1num = abs(face1num)
        //
        j = 0
        while j < area2.numfaces {
            face2num = abs(aasworld.faceindex![area2.firstface + j])
            //
            if face1num == face2num {
                AAS_FaceCenter(face1num, &start)
                //
                if (AAS_PointContents(start) & (CONTENTS_LAVA | CONTENTS_SLIME | CONTENTS_WATER)) != 0 {
                    //
                    face1 = aasworld.facesSlots[face1num]
                    areasettings = aasworld.areasettingsSlots[area1num]
                    //create a new reachability link
                    lreach = AAS_AllocReachability()
                    if lreach == nil { return 0 }
                    lreach!.areanum = area2num
                    lreach!.facenum = face1num
                    lreach!.edgenum = 0
                    lreach!.start = start
                    plane = aasworld.planesSlots[face1.planenum ^ side1]
                    _VectorMA(lreach!.start, Float(-INSIDEUNITS), plane.normal, &lreach!.end)
                    lreach!.traveltype = TRAVEL_SWIM
                    lreach!.traveltime = 1
                    //if the volume of the area is rather small
                    if AAS_AreaVolume(area2num) < 800 {
                        lreach!.traveltime += 200
                    }
                    //if (!(AAS_PointContents(start) & MASK_WATER)) lreach->traveltime += 500;
                    //link the reachability
                    lreach!.next = areareachability![area1num]
                    areareachability![area1num] = lreach
                    reach_swim += 1
                    return 1
                } //end if
            } //end if
            j += 1
        } //end for
        i += 1
    } //end for
    return 0
}

//===========================================================================
// searches for reachabilities between adjacent areas with equal floor
// heights
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:896
func AAS_Reachability_EqualFloorHeight(_ area1num: Int32, _ area2num: Int32) -> Int32 {
    return AasLreachability.scratch { lr -> Int32 in
        var i: Int32, j: Int32, edgenum: Int32, edgenum1: Int32, edgenum2: Int32, foundreach: Int32, side: Int32
        var height: Float, bestheight: Float, length: Float, bestlength: Float
        var dir = vec3_t(), start = vec3_t(), end = vec3_t(), normal = vec3_t(), invgravity = vec3_t()
        let gravitydirection = vec3_t(0, 0, -1)
        var edgevec = vec3_t()
        var area1: AasArea, area2: AasArea
        var face1: AasFace, face2: AasFace
        var edge: AasEdge
        var plane2: AasPlane
        var lreach: AasLreachability?

        if AAS_AreaGrounded(area1num) == 0 || AAS_AreaGrounded(area2num) == 0 { return 0 }

        area1 = aasworld.areasSlots[area1num]
        area2 = aasworld.areasSlots[area2num]
        //if the areas are not near anough in the x-y direction
        i = 0
        while i < 2 {
            if area1.mins[i] > area2.maxs[i] + 10 { return 0 }
            if area1.maxs[i] < area2.mins[i] - 10 { return 0 }
            i += 1
        } //end for
        //if area 2 is too high above area 1
        if area2.mins[2] > area1.maxs[2] { return 0 }
        //
        invgravity = gravitydirection
        VectorInverse(&invgravity)
        //
        bestheight = 99999
        bestlength = 0
        foundreach = 0
        //
        //check if the areas have ground faces with a common edge
        //if existing use the lowest common edge for a reachability link
        i = 0
        while i < area1.numfaces {
            face1 = aasworld.facesSlots[abs(aasworld.faceindex![area1.firstface + i])]
            if (face1.faceflags & FACE_GROUND) == 0 {
                i += 1
                continue
            }
            //
            j = 0
            while j < area2.numfaces {
                face2 = aasworld.facesSlots[abs(aasworld.faceindex![area2.firstface + j])]
                if (face2.faceflags & FACE_GROUND) == 0 {
                    j += 1
                    continue
                }
                //if there is a common edge
                edgenum1 = 0
                while edgenum1 < face1.numedges {
                    edgenum2 = 0
                    while edgenum2 < face2.numedges {
                        if abs(aasworld.edgeindex![face1.firstedge + edgenum1]) != abs(aasworld.edgeindex![face2.firstedge + edgenum2]) {
                            edgenum2 += 1
                            continue
                        }
                        edgenum = aasworld.edgeindex![face1.firstedge + edgenum1]
                        side = edgenum < 0 ? 1 : 0
                        edge = aasworld.edgesSlots[abs(edgenum)]
                        //get the length of the edge
                        dir = aasworld.vertexes![edge.v[1]] - aasworld.vertexes![edge.v[0]]
                        length = VectorLength(dir)
                        //get the start point
                        start = aasworld.vertexes![edge.v[0]] + aasworld.vertexes![edge.v[1]]
                        start = start * 0.5
                        end = start
                        //get the end point several units inside area2
                        //and the start point several units inside area1
                        //NOTE: normal is pointing into area2 because the
                        //face edges are stored counter clockwise
                        edgevec = aasworld.vertexes![edge.v[side]] - aasworld.vertexes![edge.v[side == 0 ? 1 : 0]]
                        plane2 = aasworld.planesSlots[face2.planenum]
                        CrossProduct(edgevec, plane2.normal, &normal)
                        VectorNormalize(&normal)
                        //
                        //VectorMA(start, -1, normal, start);
                        _VectorMA(end, Float(INSIDEUNITS_WALKEND), normal, &end)
                        start[0] = Float(Double(start[0]) + Double(normal[0]) * INSIDEUNITS_WALKSTART)
                        start[1] = Float(Double(start[1]) + Double(normal[1]) * INSIDEUNITS_WALKSTART)
                        start[2] = Float(Double(start[2]) + Double(normal[2]) * INSIDEUNITS_WALKSTART)
                        end[2] += 0.125
                        //
                        height = _DotProduct(invgravity, start)
                        //NOTE: if there's nearby solid or a gap area after this area
                        //disabled this crap
                        //if (AAS_NearbySolidOrGap(start, end)) height += 200;
                        //NOTE: disabled because it disables reachabilities to very small areas
                        //if (AAS_PointAreaNum(end) != area2num) continue;
                        //get the longest lowest edge
                        if height < bestheight || (height < bestheight + 1 && length > bestlength) {
                            bestheight = height
                            bestlength = length
                            //create a new reachability link
                            lr.areanum = area2num
                            lr.facenum = 0
                            lr.edgenum = edgenum
                            lr.start = start
                            lr.end = end
                            lr.traveltype = TRAVEL_WALK
                            lr.traveltime = 1
                            foundreach = 1
                        } //end if
                        edgenum2 += 1
                    } //end for
                    edgenum1 += 1
                } //end for
                j += 1
            } //end for
            i += 1
        } //end for
        if foundreach != 0 {
            //create a new reachability link
            lreach = AAS_AllocReachability()
            if lreach == nil { return 0 }
            lreach!.areanum = lr.areanum
            lreach!.facenum = lr.facenum
            lreach!.edgenum = lr.edgenum
            lreach!.start = lr.start
            lreach!.end = lr.end
            lreach!.traveltype = lr.traveltype
            lreach!.traveltime = lr.traveltime
            lreach!.next = areareachability![area1num]
            areareachability![area1num] = lreach
            //if going into a crouch area
            if AAS_AreaCrouch(area1num) == 0 && AAS_AreaCrouch(area2num) != 0 {
                lreach!.traveltime = Int32(lreach!.traveltime + aassettings.rs_startcrouch)
            } //end if
            /*
            //NOTE: if there's nearby solid or a gap area after this area
            if (!AAS_NearbySolidOrGap(lreach->start, lreach->end))
            {
                lreach->traveltime += 100;
            } //end if
            */
            //avoid rather small areas
            //if (AAS_AreaGroundFaceArea(lreach->areanum) < 500) lreach->traveltime += 100;
            //
            reach_equalfloor += 1
            return 1
        } //end if
        return 0
    }
}

//===========================================================================
// searches step, barrier, waterjump and walk off ledge reachabilities
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:1042
func AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge(_ area1num: Int32, _ area2num: Int32) -> Int32 {
    return AasTrace.scratch { trace -> Int32 in
        // AI: Raven declares `int areas[10]` on his stack.
        // The body uses the zeroed allocation of the storage class through the `areas_AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge` forward.
        var i: Int32, j: Int32, k: Int32, l: Int32, edge1num: Int32, edge2num: Int32, numareas: Int32
        var ground_bestarea2groundedgenum: Int32, ground_foundreach: Int32
        var water_bestarea2groundedgenum: Int32, water_foundreach: Int32
        var side1: Int32, area1swim: Int32, faceside1: Int32, groundface1num: Int32
        var dist: Float, dist1: Float = 0, dist2: Float = 0, diff: Float, invgravitydot: Float, ortdot: Float
        var x1: Float, x2: Float, x3: Float, x4: Float, y1: Float, y2: Float, y3: Float, y4: Float, tmp: Float, y: Float
        var length: Float, ground_bestlength: Float, water_bestlength: Float, ground_bestdist: Float, water_bestdist: Float
        var v1 = vec3_t(), v2 = vec3_t(), v3 = vec3_t(), v4 = vec3_t(), tmpv = vec3_t()
        var p1area1 = vec3_t(), p1area2 = vec3_t(), p2area1 = vec3_t(), p2area2 = vec3_t()
        var normal = vec3_t(), ort = vec3_t(), edgevec = vec3_t(), start = vec3_t(), end = vec3_t(), dir = vec3_t()
        var ground_beststart = vec3_t(), ground_bestend = vec3_t(), ground_bestnormal = vec3_t()
        var water_beststart = vec3_t(), water_bestend = vec3_t(), water_bestnormal = vec3_t()
        let invgravity = vec3_t(0, 0, 1)
        var testpoint = vec3_t()
        var plane: AasPlane
        var area1: AasArea, area2: AasArea
        var groundface1: AasFace, groundface2: AasFace
        var ground_bestface1: AasFace?, water_bestface1: AasFace?
        var edge1: AasEdge, edge2: AasEdge
        var lreach: AasLreachability?

        //must be able to walk or swim in the first area
        if AAS_AreaGrounded(area1num) == 0 && AAS_AreaSwim(area1num) == 0 { return 0 }
        //
        if AAS_AreaGrounded(area2num) == 0 && AAS_AreaSwim(area2num) == 0 { return 0 }
        //
        area1 = aasworld.areasSlots[area1num]
        area2 = aasworld.areasSlots[area2num]
        //if the first area contains a liquid
        area1swim = AAS_AreaSwim(area1num)
        //if the areas are not near anough in the x-y direction
        i = 0
        while i < 2 {
            if area1.mins[i] > area2.maxs[i] + 10 { return 0 }
            if area1.maxs[i] < area2.mins[i] - 10 { return 0 }
            i += 1
        } //end for
        //
        ground_foundreach = 0
        ground_bestdist = 99999
        ground_bestlength = 0
        ground_bestarea2groundedgenum = 0
        //
        water_foundreach = 0
        water_bestdist = 99999
        water_bestlength = 0
        water_bestarea2groundedgenum = 0
        //
        i = 0
        while i < area1.numfaces {
            groundface1num = aasworld.faceindex![area1.firstface + i]
            faceside1 = groundface1num < 0 ? 1 : 0
            groundface1 = aasworld.facesSlots[abs(groundface1num)]
            //if this isn't a ground face
            if (groundface1.faceflags & FACE_GROUND) == 0 {
                //if we can swim in the first area
                if area1swim != 0 {
                    //face plane must be more or less horizontal
                    plane = aasworld.planesSlots[groundface1.planenum ^ (faceside1 == 0 ? 1 : 0)]
                    if Double(_DotProduct(plane.normal, invgravity)) < 0.7 {
                        i += 1
                        continue
                    }
                } //end if
                else {
                    //if we can't swim in the area it must be a ground face
                    i += 1
                    continue
                } //end else
            } //end if
            //
            k = 0
            while k < groundface1.numedges {
                edge1num = aasworld.edgeindex![groundface1.firstedge + k]
                side1 = (edge1num < 0) ? 1 : 0
                //NOTE: for water faces we must take the side area 1 is
                // on into account because the face is shared and doesn't
                // have to be oriented correctly
                if (groundface1.faceflags & FACE_GROUND) == 0 { side1 = (side1 == faceside1) ? 1 : 0 }
                edge1num = abs(edge1num)
                edge1 = aasworld.edgesSlots[edge1num]
                //vertexes of the edge
                v1 = aasworld.vertexes![edge1.v[side1 == 0 ? 1 : 0]]
                v2 = aasworld.vertexes![edge1.v[side1]]
                //get a vertical plane through the edge
                //NOTE: normal is pointing into area 2 because the
                //face edges are stored counter clockwise
                edgevec = v2 - v1
                CrossProduct(edgevec, invgravity, &normal)
                VectorNormalize(&normal)
                dist = _DotProduct(normal, v1)
                //check the faces from the second area
                j = 0
                while j < area2.numfaces {
                    groundface2 = aasworld.facesSlots[abs(aasworld.faceindex![area2.firstface + j])]
                    //must be a ground face
                    if (groundface2.faceflags & FACE_GROUND) == 0 {
                        j += 1
                        continue
                    }
                    //check the edges of this ground face
                    l = 0
                    while l < groundface2.numedges {
                        edge2num = abs(aasworld.edgeindex![groundface2.firstedge + l])
                        edge2 = aasworld.edgesSlots[edge2num]
                        //vertexes of the edge
                        v3 = aasworld.vertexes![edge2.v[0]]
                        v4 = aasworld.vertexes![edge2.v[1]]
                        //check the distance between the two points and the vertical plane
                        //through the edge of area1
                        diff = _DotProduct(normal, v3) - dist
                        if Double(diff) < -0.1 || Double(diff) > 0.1 {
                            l += 1
                            continue
                        }
                        diff = _DotProduct(normal, v4) - dist
                        if Double(diff) < -0.1 || Double(diff) > 0.1 {
                            l += 1
                            continue
                        }
                        //
                        //project the two ground edges into the step side plane
                        //and calculate the shortest distance between the two
                        //edges if they overlap in the direction orthogonal to
                        //the gravity direction
                        CrossProduct(invgravity, normal, &ort)
                        invgravitydot = _DotProduct(invgravity, invgravity)
                        ortdot = _DotProduct(ort, ort)
                        //projection into the step plane
                        //NOTE: since gravity is vertical this is just the z coordinate
                        y1 = v1[2]//DotProduct(v1, invgravity) / invgravitydot;
                        y2 = v2[2]//DotProduct(v2, invgravity) / invgravitydot;
                        y3 = v3[2]//DotProduct(v3, invgravity) / invgravitydot;
                        y4 = v4[2]//DotProduct(v4, invgravity) / invgravitydot;
                        //
                        x1 = _DotProduct(v1, ort) / ortdot
                        x2 = _DotProduct(v2, ort) / ortdot
                        x3 = _DotProduct(v3, ort) / ortdot
                        x4 = _DotProduct(v4, ort) / ortdot
                        //
                        if x1 > x2 {
                            tmp = x1
                            x1 = x2
                            x2 = tmp
                            tmp = y1
                            y1 = y2
                            y2 = tmp
                            tmpv = v1
                            v1 = v2
                            v2 = tmpv
                        } //end if
                        if x3 > x4 {
                            tmp = x3
                            x3 = x4
                            x4 = tmp
                            tmp = y3
                            y3 = y4
                            y4 = tmp
                            tmpv = v3
                            v3 = v4
                            v4 = tmpv
                        } //end if
                        //if the two projected edge lines have no overlap
                        if x2 <= x3 || x4 <= x1 {
    //						Log_Write("lines no overlap: from area %d to %d\r\n", area1num, area2num);
                            l += 1
                            continue
                        } //end if
                        //if the two lines fully overlap
                        if (Double(x1) - 0.5 < Double(x3) && Double(x4) < Double(x2) + 0.5) &&
                            (Double(x3) - 0.5 < Double(x1) && Double(x2) < Double(x4) + 0.5) {
                            dist1 = y3 - y1
                            dist2 = y4 - y2
                            p1area1 = v1
                            p2area1 = v2
                            p1area2 = v3
                            p2area2 = v4
                        } //end if
                        else {
                            //if the points are equal
                            if Double(x1) > Double(x3) - 0.1 && Double(x1) < Double(x3) + 0.1 {
                                dist1 = y3 - y1
                                p1area1 = v1
                                p1area2 = v3
                            } //end if
                            else if x1 < x3 {
                                y = y1 + (x3 - x1) * (y2 - y1) / (x2 - x1)
                                dist1 = y3 - y
                                p1area1 = v3
                                p1area1[2] = y
                                p1area2 = v3
                            } //end if
                            else {
                                y = y3 + (x1 - x3) * (y4 - y3) / (x4 - x3)
                                dist1 = y - y1
                                p1area1 = v1
                                p1area2 = v1
                                p1area2[2] = y
                            } //end if
                            //if the points are equal
                            if Double(x2) > Double(x4) - 0.1 && Double(x2) < Double(x4) + 0.1 {
                                dist2 = y4 - y2
                                p2area1 = v2
                                p2area2 = v4
                            } //end if
                            else if x2 < x4 {
                                y = y3 + (x2 - x3) * (y4 - y3) / (x4 - x3)
                                dist2 = y - y2
                                p2area1 = v2
                                p2area2 = v2
                                p2area2[2] = y
                            } //end if
                            else {
                                y = y1 + (x4 - x1) * (y2 - y1) / (x2 - x1)
                                dist2 = y4 - y
                                p2area1 = v4
                                p2area1[2] = y
                                p2area2 = v4
                            } //end else
                        } //end else
                        //if both distances are pretty much equal
                        //then we take the middle of the points
                        if dist1 > dist2 - 1 && dist1 < dist2 + 1 {
                            dist = dist1
                            start = p1area1 + p2area1
                            start = start * 0.5
                            end = p1area2 + p2area2
                            end = end * 0.5
                        } //end if
                        else if dist1 < dist2 {
                            dist = dist1
                            start = p1area1
                            end = p1area2
                        } //end else if
                        else {
                            dist = dist2
                            start = p2area1
                            end = p2area2
                        } //end else
                        //get the length of the overlapping part of the edges of the two areas
                        dir = p2area2 - p1area2
                        length = VectorLength(dir)
                        //
                        if (groundface1.faceflags & FACE_GROUND) != 0 {
                            //if the vertical distance is smaller
                            if dist < ground_bestdist ||
                                //or the vertical distance is pretty much the same
                                //but the overlapping part of the edges is longer
                                (dist < ground_bestdist + 1 && length > ground_bestlength) {
                                ground_bestdist = dist
                                ground_bestlength = length
                                ground_foundreach = 1
                                ground_bestarea2groundedgenum = edge1num
                                ground_bestface1 = groundface1
                                //best point towards area1
                                ground_beststart = start
                                //normal is pointing into area2
                                ground_bestnormal = normal
                                //best point towards area2
                                ground_bestend = end
                            } //end if
                        } //end if
                        else {
                            //if the vertical distance is smaller
                            if dist < water_bestdist ||
                                //or the vertical distance is pretty much the same
                                //but the overlapping part of the edges is longer
                                (dist < water_bestdist + 1 && length > water_bestlength) {
                                water_bestdist = dist
                                water_bestlength = length
                                water_foundreach = 1
                                water_bestarea2groundedgenum = edge1num
                                water_bestface1 = groundface1
                                //best point towards area1
                                water_beststart = start
                                //normal is pointing into area2
                                water_bestnormal = normal
                                //best point towards area2
                                water_bestend = end
                            } //end if
                        } //end else
                        l += 1
                    } //end for
                    j += 1
                } //end for
                k += 1
            } //end for
            i += 1
        } //end for
        //
        // NOTE: swim reachabilities are already filtered out
        //
        // Steps
        //
        //        ---------
        //        |          step height -> TRAVEL_WALK
        //--------|
        //
        //        ---------
        //~~~~~~~~|          step height and low water -> TRAVEL_WALK
        //--------|
        //
        //~~~~~~~~~~~~~~~~~~
        //        ---------
        //        |          step height and low water up to the step -> TRAVEL_WALK
        //--------|
        //
        //check for a step reachability
        if ground_foundreach != 0 {
            //if area2 is higher but lower than the maximum step height
            //NOTE: ground_bestdist >= 0 also catches equal floor reachabilities
            if ground_bestdist >= 0 && ground_bestdist < aassettings.phys_maxstep {
                //create walk reachability from area1 to area2
                lreach = AAS_AllocReachability()
                if lreach == nil { return 0 }
                lreach!.areanum = area2num
                lreach!.facenum = 0
                lreach!.edgenum = ground_bestarea2groundedgenum
                lreach!.start[0] = Float(Double(ground_beststart[0]) + Double(ground_bestnormal[0]) * INSIDEUNITS_WALKSTART)
                lreach!.start[1] = Float(Double(ground_beststart[1]) + Double(ground_bestnormal[1]) * INSIDEUNITS_WALKSTART)
                lreach!.start[2] = Float(Double(ground_beststart[2]) + Double(ground_bestnormal[2]) * INSIDEUNITS_WALKSTART)
                _VectorMA(ground_bestend, Float(INSIDEUNITS_WALKEND), ground_bestnormal, &lreach!.end)
                lreach!.traveltype = TRAVEL_WALK
                lreach!.traveltime = 0//1;
                //if going into a crouch area
                if AAS_AreaCrouch(area1num) == 0 && AAS_AreaCrouch(area2num) != 0 {
                    lreach!.traveltime = Int32(lreach!.traveltime + aassettings.rs_startcrouch)
                } //end if
                lreach!.next = areareachability![area1num]
                areareachability![area1num] = lreach
                //NOTE: if there's nearby solid or a gap area after this area
                /*
                if (!AAS_NearbySolidOrGap(lreach->start, lreach->end))
                {
                    lreach->traveltime += 100;
                } //end if
                */
                //avoid rather small areas
                //if (AAS_AreaGroundFaceArea(lreach->areanum) < 500) lreach->traveltime += 100;
                //
                reach_step += 1
                return 1
            } //end if
        } //end if
        //
        // Water Jumps
        //
        //        ---------
        //        |
        //~~~~~~~~|
        //        |
        //        |          higher than step height and water up to waterjump height -> TRAVEL_WATERJUMP
        //--------|
        //
        //~~~~~~~~~~~~~~~~~~
        //        ---------
        //        |
        //        |
        //        |
        //        |          higher than step height and low water up to the step -> TRAVEL_WATERJUMP
        //--------|
        //
        //check for a waterjump reachability
        if water_foundreach != 0 {
            //get a test point a little bit towards area1
            _VectorMA(water_bestend, Float(-INSIDEUNITS), water_bestnormal, &testpoint)
            //go down the maximum waterjump height
            testpoint[2] -= aassettings.phys_maxwaterjump
            //if there IS water the sv_maxwaterjump height below the bestend point
            if (aasworld.areasettingsSlots[AAS_PointAreaNum(testpoint)].areaflags & AREA_LIQUID) != 0 {
                //don't create rediculous water jump reachabilities from areas very far below
                //the water surface
                if water_bestdist < aassettings.phys_maxwaterjump + 24 {
                    //waterjumping from or towards a crouch only area is not possible in Quake2
                    if (aasworld.areasettingsSlots[area1num].presencetype & PRESENCE_NORMAL) != 0 &&
                        (aasworld.areasettingsSlots[area2num].presencetype & PRESENCE_NORMAL) != 0 {
                        //create water jump reachability from area1 to area2
                        lreach = AAS_AllocReachability()
                        if lreach == nil { return 0 }
                        lreach!.areanum = area2num
                        lreach!.facenum = 0
                        lreach!.edgenum = water_bestarea2groundedgenum
                        lreach!.start = water_beststart
                        _VectorMA(water_bestend, Float(INSIDEUNITS_WATERJUMP), water_bestnormal, &lreach!.end)
                        lreach!.traveltype = TRAVEL_WATERJUMP
                        lreach!.traveltime = Int32(aassettings.rs_waterjump)
                        lreach!.next = areareachability![area1num]
                        areareachability![area1num] = lreach
                        //we've got another waterjump reachability
                        reach_waterjump += 1
                        return 1
                    } //end if
                } //end if
            } //end if
        } //end if
        //
        // Barrier Jumps
        //
        //        ---------
        //        |
        //        |
        //        |
        //        |         higher than step height lower than barrier height -> TRAVEL_BARRIERJUMP
        //--------|
        //
        //        ---------
        //        |
        //        |
        //        |
        //~~~~~~~~|         higher than step height lower than barrier height
        //--------|         and a thin layer of water in the area to jump from -> TRAVEL_BARRIERJUMP
        //
        //check for a barrier jump reachability
        if ground_foundreach != 0 {
            //if area2 is higher but lower than the maximum barrier jump height
            if ground_bestdist > 0 && ground_bestdist < aassettings.phys_maxbarrier {
                //if no water in area1 or a very thin layer of water on the ground
                if water_foundreach == 0 || (ground_bestdist - water_bestdist < 16) {
                    //cannot perform a barrier jump towards or from a crouch area in Quake2
                    if AAS_AreaCrouch(area1num) == 0 && AAS_AreaCrouch(area2num) == 0 {
                        //create barrier jump reachability from area1 to area2
                        lreach = AAS_AllocReachability()
                        if lreach == nil { return 0 }
                        lreach!.areanum = area2num
                        lreach!.facenum = 0
                        lreach!.edgenum = ground_bestarea2groundedgenum
                        lreach!.start[0] = Float(Double(ground_beststart[0]) + Double(ground_bestnormal[0]) * INSIDEUNITS_WALKSTART)
                        lreach!.start[1] = Float(Double(ground_beststart[1]) + Double(ground_bestnormal[1]) * INSIDEUNITS_WALKSTART)
                        lreach!.start[2] = Float(Double(ground_beststart[2]) + Double(ground_bestnormal[2]) * INSIDEUNITS_WALKSTART)
                        _VectorMA(ground_bestend, Float(INSIDEUNITS_WALKEND), ground_bestnormal, &lreach!.end)
                        lreach!.traveltype = TRAVEL_BARRIERJUMP
                        lreach!.traveltime = Int32(aassettings.rs_barrierjump)//AAS_BarrierJumpTravelTime();
                        lreach!.next = areareachability![area1num]
                        areareachability![area1num] = lreach
                        //we've got another barrierjump reachability
                        reach_barrier += 1
                        return 1
                    } //end if
                } //end if
            } //end if
        } //end if
        //
        // Walk and Walk Off Ledge
        //
        //--------|
        //        |          can walk or step back -> TRAVEL_WALK
        //        ---------
        //
        //--------|
        //        |
        //        |
        //        |
        //        |          cannot walk/step back -> TRAVEL_WALKOFFLEDGE
        //        ---------
        //
        //--------|
        //        |
        //        |~~~~~~~~
        //        |
        //        |          cannot step back but can waterjump back -> TRAVEL_WALKOFFLEDGE
        //        ---------  FIXME: create TRAVEL_WALK reach??
        //
        //check for a walk or walk off ledge reachability
        if ground_foundreach != 0 {
            if ground_bestdist < 0 {
                if ground_bestdist > -aassettings.phys_maxstep {
                    //create walk reachability from area1 to area2
                    lreach = AAS_AllocReachability()
                    if lreach == nil { return 0 }
                    lreach!.areanum = area2num
                    lreach!.facenum = 0
                    lreach!.edgenum = ground_bestarea2groundedgenum
                    lreach!.start[0] = Float(Double(ground_beststart[0]) + Double(ground_bestnormal[0]) * INSIDEUNITS_WALKSTART)
                    lreach!.start[1] = Float(Double(ground_beststart[1]) + Double(ground_bestnormal[1]) * INSIDEUNITS_WALKSTART)
                    lreach!.start[2] = Float(Double(ground_beststart[2]) + Double(ground_bestnormal[2]) * INSIDEUNITS_WALKSTART)
                    _VectorMA(ground_bestend, Float(INSIDEUNITS_WALKEND), ground_bestnormal, &lreach!.end)
                    lreach!.traveltype = TRAVEL_WALK
                    lreach!.traveltime = 1
                    lreach!.next = areareachability![area1num]
                    areareachability![area1num] = lreach
                    //we've got another walk reachability
                    reach_walk += 1
                    return 1
                } //end if
                // if no maximum fall height set or less than the max
                if aassettings.rs_maxfallheight == 0 || abs(ground_bestdist) < aassettings.rs_maxfallheight {
                    //trace a bounding box vertically to check for solids
                    _VectorMA(ground_bestend, Float(INSIDEUNITS), ground_bestnormal, &ground_bestend)
                    start = ground_bestend
                    start[2] = ground_beststart[2]
                    end = ground_bestend
                    end[2] += 4
                    trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, -1))
                    //if no solids were found
                    if !trace.startsolid && Double(trace.fraction) >= 1.0 {
                        //the trace end point must be in the goal area
                        trace.endpos[2] += 1
                        if AAS_PointAreaNum(trace.endpos) == area2num {
                            //if not going through a cluster portal
                            numareas = AAS_TraceAreas(start, end, areas_AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge, nil, Int32(areas_AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge.count))
                            i = 0
                            while i < numareas {
                                if AAS_AreaClusterPortal(areas_AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge[i]) != 0 {
                                    break
                                }
                                i += 1
                            }
                            if i >= numareas {
                                //create a walk off ledge reachability from area1 to area2
                                lreach = AAS_AllocReachability()
                                if lreach == nil { return 0 }
                                lreach!.areanum = area2num
                                lreach!.facenum = 0
                                lreach!.edgenum = ground_bestarea2groundedgenum
                                lreach!.start = ground_beststart
                                lreach!.end = ground_bestend
                                lreach!.traveltype = TRAVEL_WALKOFFLEDGE
                                lreach!.traveltime = Int32(aassettings.rs_startwalkoffledge + abs(ground_bestdist) * 50 / aassettings.phys_gravity)
                                //if falling from too high and not falling into water
                                if AAS_AreaSwim(area2num) == 0 && AAS_AreaJumpPad(area2num) == 0 {
                                    if AAS_FallDelta(ground_bestdist) > aassettings.phys_falldelta5 {
                                        lreach!.traveltime = Int32(lreach!.traveltime + aassettings.rs_falldamage5)
                                    } //end if
                                    if AAS_FallDelta(ground_bestdist) > aassettings.phys_falldelta10 {
                                        lreach!.traveltime = Int32(lreach!.traveltime + aassettings.rs_falldamage10)
                                    } //end if
                                } //end if
                                lreach!.next = areareachability![area1num]
                                areareachability![area1num] = lreach
                                //
                                reach_walkoffledge += 1
                                //NOTE: don't create a weapon (rl, bfg) jump reachability here
                                //because it interferes with other reachabilities
                                //like the ladder reachability
                                return 1
                            } //end if
                        } //end if
                    } //end if
                } //end if
            } //end else
        } //end if
        return 0
    }
}

//===========================================================================
// returns the distance between the two vectors
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:1593
private func VectorDistance(_ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t) -> Float {
    var dir = vec3_t()

    dir = v2 - v1
    return VectorLength(dir)
}

//===========================================================================
// returns true if the first vector is between the last two vectors
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:1607
func VectorBetweenVectors(_ v: JKAShared.vec3_t, _ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t) -> Int32 {
    var dir1 = vec3_t(), dir2 = vec3_t()

    dir1 = v - v1
    dir2 = v - v2
    return (_DotProduct(dir1, dir2) <= 0) ? 1 : 0
}

//===========================================================================
// returns the mid point between the two vectors
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:1622
func VectorMiddle(_ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t, _ middle: inout JKAShared.vec3_t) {
    middle = v1 + v2
    middle = middle * 0.5
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:1814
func AAS_ClosestEdgePoints(_ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t, _ v3: JKAShared.vec3_t, _ v4: JKAShared.vec3_t, _ plane1: AasPlane, _ plane2: AasPlane, _ beststart1: inout JKAShared.vec3_t, _ bestend1: inout JKAShared.vec3_t, _ beststart2: inout JKAShared.vec3_t, _ bestend2: inout JKAShared.vec3_t, _ bestdist: Float) -> Float {
    var bestdist = bestdist
    var dir1 = vec3_t(), dir2 = vec3_t(), p1 = vec3_t(), p2 = vec3_t(), p3 = vec3_t(), p4 = vec3_t()
    var a1: Float, a2: Float, b1: Float, b2: Float, dist: Float, dist1: Float, dist2: Float
    var founddist: Int32

    //edge vectors
    dir1 = v2 - v1
    dir2 = v4 - v3
    //get the horizontal directions
    dir1[2] = 0
    dir2[2] = 0
    //
    // p1 = point on an edge vector of area2 closest to v1
    // p2 = point on an edge vector of area2 closest to v2
    // p3 = point on an edge vector of area1 closest to v3
    // p4 = point on an edge vector of area1 closest to v4
    //
    if dir2[0] != 0 {
        a2 = dir2[1] / dir2[0]
        b2 = v3[1] - a2 * v3[0]
        //point on the edge vector of area2 closest to v1
        p1[0] = (_DotProduct(v1, dir2) - (a2 * dir2[0] + b2 * dir2[1])) / dir2[0]
        p1[1] = a2 * p1[0] + b2
        //point on the edge vector of area2 closest to v2
        p2[0] = (_DotProduct(v2, dir2) - (a2 * dir2[0] + b2 * dir2[1])) / dir2[0]
        p2[1] = a2 * p2[0] + b2
    } //end if
    else {
        //point on the edge vector of area2 closest to v1
        p1[0] = v3[0]
        p1[1] = v1[1]
        //point on the edge vector of area2 closest to v2
        p2[0] = v3[0]
        p2[1] = v2[1]
    } //end else
    //
    if dir1[0] != 0 {
        //
        a1 = dir1[1] / dir1[0]
        b1 = v1[1] - a1 * v1[0]
        //point on the edge vector of area1 closest to v3
        p3[0] = (_DotProduct(v3, dir1) - (a1 * dir1[0] + b1 * dir1[1])) / dir1[0]
        p3[1] = a1 * p3[0] + b1
        //point on the edge vector of area1 closest to v4
        p4[0] = (_DotProduct(v4, dir1) - (a1 * dir1[0] + b1 * dir1[1])) / dir1[0]
        p4[1] = a1 * p4[0] + b1
    } //end if
    else {
        //point on the edge vector of area1 closest to v3
        p3[0] = v1[0]
        p3[1] = v3[1]
        //point on the edge vector of area1 closest to v4
        p4[0] = v1[0]
        p4[1] = v4[1]
    } //end else
    //start with zero z-coordinates
    p1[2] = 0
    p2[2] = 0
    p3[2] = 0
    p4[2] = 0
    //calculate the z-coordinates from the ground planes
    p1[2] = (plane2.dist - _DotProduct(plane2.normal, p1)) / plane2.normal[2]
    p2[2] = (plane2.dist - _DotProduct(plane2.normal, p2)) / plane2.normal[2]
    p3[2] = (plane1.dist - _DotProduct(plane1.normal, p3)) / plane1.normal[2]
    p4[2] = (plane1.dist - _DotProduct(plane1.normal, p4)) / plane1.normal[2]
    //
    founddist = 0
    //
    if VectorBetweenVectors(p1, v3, v4) != 0 {
        dist = VectorDistance(v1, p1)
        if Double(dist) > Double(bestdist) - 0.5 && Double(dist) < Double(bestdist) + 0.5 {
            dist1 = VectorDistance(beststart1, v1)
            dist2 = VectorDistance(beststart2, v1)
            if dist1 > dist2 {
                if dist1 > VectorDistance(beststart1, beststart2) { beststart2 = v1 }
            } //end if
            else {
                if dist2 > VectorDistance(beststart1, beststart2) { beststart1 = v1 }
            } //end else
            dist1 = VectorDistance(bestend1, p1)
            dist2 = VectorDistance(bestend2, p1)
            if dist1 > dist2 {
                if dist1 > VectorDistance(bestend1, bestend2) { bestend2 = p1 }
            } //end if
            else {
                if dist2 > VectorDistance(bestend1, bestend2) { bestend1 = p1 }
            } //end else
        } //end if
        else if dist < bestdist {
            bestdist = dist
            beststart1 = v1
            beststart2 = v1
            bestend1 = p1
            bestend2 = p1
        } //end if
        founddist = 1
    } //end if
    if VectorBetweenVectors(p2, v3, v4) != 0 {
        dist = VectorDistance(v2, p2)
        if Double(dist) > Double(bestdist) - 0.5 && Double(dist) < Double(bestdist) + 0.5 {
            dist1 = VectorDistance(beststart1, v2)
            dist2 = VectorDistance(beststart2, v2)
            if dist1 > dist2 {
                if dist1 > VectorDistance(beststart1, beststart2) { beststart2 = v2 }
            } //end if
            else {
                if dist2 > VectorDistance(beststart1, beststart2) { beststart1 = v2 }
            } //end else
            dist1 = VectorDistance(bestend1, p2)
            dist2 = VectorDistance(bestend2, p2)
            if dist1 > dist2 {
                if dist1 > VectorDistance(bestend1, bestend2) { bestend2 = p2 }
            } //end if
            else {
                if dist2 > VectorDistance(bestend1, bestend2) { bestend1 = p2 }
            } //end else
        } //end if
        else if dist < bestdist {
            bestdist = dist
            beststart1 = v2
            beststart2 = v2
            bestend1 = p2
            bestend2 = p2
        } //end if
        founddist = 1
    } //end else if
    if VectorBetweenVectors(p3, v1, v2) != 0 {
        dist = VectorDistance(v3, p3)
        if Double(dist) > Double(bestdist) - 0.5 && Double(dist) < Double(bestdist) + 0.5 {
            dist1 = VectorDistance(beststart1, p3)
            dist2 = VectorDistance(beststart2, p3)
            if dist1 > dist2 {
                if dist1 > VectorDistance(beststart1, beststart2) { beststart2 = p3 }
            } //end if
            else {
                if dist2 > VectorDistance(beststart1, beststart2) { beststart1 = p3 }
            } //end else
            dist1 = VectorDistance(bestend1, v3)
            dist2 = VectorDistance(bestend2, v3)
            if dist1 > dist2 {
                if dist1 > VectorDistance(bestend1, bestend2) { bestend2 = v3 }
            } //end if
            else {
                if dist2 > VectorDistance(bestend1, bestend2) { bestend1 = v3 }
            } //end else
        } //end if
        else if dist < bestdist {
            bestdist = dist
            beststart1 = p3
            beststart2 = p3
            bestend1 = v3
            bestend2 = v3
        } //end if
        founddist = 1
    } //end else if
    if VectorBetweenVectors(p4, v1, v2) != 0 {
        dist = VectorDistance(v4, p4)
        if Double(dist) > Double(bestdist) - 0.5 && Double(dist) < Double(bestdist) + 0.5 {
            dist1 = VectorDistance(beststart1, p4)
            dist2 = VectorDistance(beststart2, p4)
            if dist1 > dist2 {
                if dist1 > VectorDistance(beststart1, beststart2) { beststart2 = p4 }
            } //end if
            else {
                if dist2 > VectorDistance(beststart1, beststart2) { beststart1 = p4 }
            } //end else
            dist1 = VectorDistance(bestend1, v4)
            dist2 = VectorDistance(bestend2, v4)
            if dist1 > dist2 {
                if dist1 > VectorDistance(bestend1, bestend2) { bestend2 = v4 }
            } //end if
            else {
                if dist2 > VectorDistance(bestend1, bestend2) { bestend1 = v4 }
            } //end else
        } //end if
        else if dist < bestdist {
            bestdist = dist
            beststart1 = p4
            beststart2 = p4
            bestend1 = v4
            bestend2 = v4
        } //end if
        founddist = 1
    } //end else if
    //if no shortest distance was found the shortest distance
    //is between one of the vertexes of edge1 and one of edge2
    if founddist == 0 {
        dist = VectorDistance(v1, v3)
        if dist < bestdist {
            bestdist = dist
            beststart1 = v1
            beststart2 = v1
            bestend1 = v3
            bestend2 = v3
        } //end if
        dist = VectorDistance(v1, v4)
        if dist < bestdist {
            bestdist = dist
            beststart1 = v1
            beststart2 = v1
            bestend1 = v4
            bestend2 = v4
        } //end if
        dist = VectorDistance(v2, v3)
        if dist < bestdist {
            bestdist = dist
            beststart1 = v2
            beststart2 = v2
            bestend1 = v3
            bestend2 = v3
        } //end if
        dist = VectorDistance(v2, v4)
        if dist < bestdist {
            bestdist = dist
            beststart1 = v2
            beststart2 = v2
            bestend1 = v4
            bestend2 = v4
        } //end if
    } //end if
    return bestdist
}

//===========================================================================
// creates possible jump reachabilities between the areas
//
// The two closest points on the ground of the areas are calculated
// One of the points will be on an edge of a ground face of area1 and
// one on an edge of a ground face of area2.
// If there is a range of closest points the point in the middle of this range
// is selected.
// Between these two points there must be one or more gaps.
// If the gaps exist a potential jump is predicted.
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:2092
func AAS_Reachability_Jump(_ area1num: Int32, _ area2num: Int32) -> Int32 {
    return AasTrace.scratch { trace -> Int32 in
        return AasClientmove.scratch { move -> Int32 in
            // AI: Raven declares `int areas[10]` on his stack.
            // The body uses the zeroed allocation of the storage class through the `areas_AAS_Reachability_Jump` forward.
            var i: Int32, j: Int32, k: Int32, l: Int32, face1num: Int32, face2num: Int32, edge1num: Int32, edge2num: Int32, traveltype: Int32
            var stopevent: Int32, numareas: Int32
            var phys_jumpvel: Float, maxjumpdistance: Float, maxjumpheight: Float, height: Float, bestdist: Float, speed: Float = 0
            var v1 = vec3_t(), v2 = vec3_t(), v3 = vec3_t(), v4 = vec3_t()
            var beststart = vec3_t(), beststart2 = vec3_t(), bestend = vec3_t(), bestend2 = vec3_t()
            var teststart = vec3_t(), testend = vec3_t(), dir = vec3_t(), velocity = vec3_t(), cmdmove = vec3_t(), sidewards = vec3_t()
            let up = vec3_t(0, 0, 1)
            var area1: AasArea, area2: AasArea
            var face1: AasFace, face2: AasFace
            var edge1: AasEdge, edge2: AasEdge
            var plane1: AasPlane, plane2: AasPlane, plane: AasPlane
            var lreach: AasLreachability?

            if AAS_AreaGrounded(area1num) == 0 || AAS_AreaGrounded(area2num) == 0 { return 0 }
            //cannot jump from or to a crouch area
            if AAS_AreaCrouch(area1num) != 0 || AAS_AreaCrouch(area2num) != 0 { return 0 }
            //
            area1 = aasworld.areasSlots[area1num]
            area2 = aasworld.areasSlots[area2num]
            //
            phys_jumpvel = aassettings.phys_jumpvel
            //maximum distance a player can jump
            maxjumpdistance = 2 * AAS_MaxJumpDistance(phys_jumpvel)
            //maximum height a player can jump with the given initial z velocity
            maxjumpheight = AAS_MaxJumpHeight(phys_jumpvel)

            //if the areas are not near anough in the x-y direction
            i = 0
            while i < 2 {
                if area1.mins[i] > area2.maxs[i] + maxjumpdistance { return 0 }
                if area1.maxs[i] < area2.mins[i] - maxjumpdistance { return 0 }
                i += 1
            } //end for
            //if area2 is way to high to jump up to
            if area2.mins[2] > area1.maxs[2] + maxjumpheight { return 0 }
            //
            bestdist = 999999
            //
            i = 0
            while i < area1.numfaces {
                face1num = aasworld.faceindex![area1.firstface + i]
                face1 = aasworld.facesSlots[abs(face1num)]
                //if not a ground face
                if (face1.faceflags & FACE_GROUND) == 0 {
                    i += 1
                    continue
                }
                //
                j = 0
                while j < area2.numfaces {
                    face2num = aasworld.faceindex![area2.firstface + j]
                    face2 = aasworld.facesSlots[abs(face2num)]
                    //if not a ground face
                    if (face2.faceflags & FACE_GROUND) == 0 {
                        j += 1
                        continue
                    }
                    //
                    k = 0
                    while k < face1.numedges {
                        edge1num = abs(aasworld.edgeindex![face1.firstedge + k])
                        edge1 = aasworld.edgesSlots[edge1num]
                        l = 0
                        while l < face2.numedges {
                            edge2num = abs(aasworld.edgeindex![face2.firstedge + l])
                            edge2 = aasworld.edgesSlots[edge2num]
                            //calculate the minimum distance between the two edges
                            v1 = aasworld.vertexes![edge1.v[0]]
                            v2 = aasworld.vertexes![edge1.v[1]]
                            v3 = aasworld.vertexes![edge2.v[0]]
                            v4 = aasworld.vertexes![edge2.v[1]]
                            //get the ground planes
                            plane1 = aasworld.planesSlots[face1.planenum]
                            plane2 = aasworld.planesSlots[face2.planenum]
                            //
                            bestdist = AAS_ClosestEdgePoints(v1, v2, v3, v4, plane1, plane2, &beststart, &bestend, &beststart2, &bestend2, bestdist)
                            l += 1
                        } //end for
                        k += 1
                    } //end for
                    j += 1
                } //end for
                i += 1
            } //end for
            VectorMiddle(beststart, beststart2, &beststart)
            VectorMiddle(bestend, bestend2, &bestend)
            if bestdist > 4 && bestdist < maxjumpdistance {
    //		Log_Write("shortest distance between %d and %d is %f\r\n", area1num, area2num, bestdist);
                // if very close and almost no height difference then the bot can walk
                if bestdist <= 48 && abs(beststart[2] - bestend[2]) < 8 {
                    speed = 400
                    traveltype = TRAVEL_WALKOFFLEDGE
                } //end if
                else if AAS_HorizontalVelocityForJump(0, beststart, bestend, &speed) != 0 {
                    //FIXME: why multiply with 1.2???
                    speed *= 1.2
                    traveltype = TRAVEL_WALKOFFLEDGE
                } //end else if
                else {
                    //get the horizontal speed for the jump, if it isn't possible to calculate this
                    //speed (the jump is not possible) then there's no jump reachability created
                    if AAS_HorizontalVelocityForJump(phys_jumpvel, beststart, bestend, &speed) == 0 {
                        return 0
                    }
                    speed *= 1.05
                    traveltype = TRAVEL_JUMP
                    //
                    //NOTE: test if the horizontal distance isn't too small
                    dir = bestend - beststart
                    dir[2] = 0
                    if VectorLength(dir) < 10 {
                        return 0
                    }
                } //end if
                //
                dir = bestend - beststart
                VectorNormalize(&dir)
                _VectorMA(beststart, 1, dir, &teststart)
                //
                testend = teststart
                testend[2] -= 100
                trace.copy(from: AAS_TraceClientBBox(teststart, testend, PRESENCE_NORMAL, -1))
                //
                if trace.startsolid {
                    return 0
                }
                if trace.fraction < 1 {
                    plane = aasworld.planesSlots[trace.planenum]
                    // if the bot can stand on the surface
                    if Double(_DotProduct(plane.normal, up)) >= 0.7 {
                        // if no lava or slime below
                        if (AAS_PointContents(trace.endpos) & (CONTENTS_LAVA | CONTENTS_SLIME)) == 0 {
                            if teststart[2] - trace.endpos[2] <= aassettings.phys_maxbarrier {
                                return 0
                            }
                        } //end if
                    } //end if
                } //end if
                //
                _VectorMA(bestend, -1, dir, &teststart)
                //
                testend = teststart
                testend[2] -= 100
                trace.copy(from: AAS_TraceClientBBox(teststart, testend, PRESENCE_NORMAL, -1))
                //
                if trace.startsolid {
                    return 0
                }
                if trace.fraction < 1 {
                    plane = aasworld.planesSlots[trace.planenum]
                    // if the bot can stand on the surface
                    if Double(_DotProduct(plane.normal, up)) >= 0.7 {
                        // if no lava or slime below
                        if (AAS_PointContents(trace.endpos) & (CONTENTS_LAVA | CONTENTS_SLIME)) == 0 {
                            if teststart[2] - trace.endpos[2] <= aassettings.phys_maxbarrier {
                                return 0
                            }
                        } //end if
                    } //end if
                } //end if
                //
                // get command movement
                cmdmove = vec3_t()
                if (traveltype & TRAVELTYPE_MASK) == TRAVEL_JUMP {
                    cmdmove[2] = aassettings.phys_jumpvel
                } else {
                    cmdmove[2] = 0
                }
                //
                dir = bestend - beststart
                dir[2] = 0
                VectorNormalize(&dir)
                CrossProduct(dir, up, &sidewards)
                //
                stopevent = SE_HITGROUND | SE_ENTERWATER | SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE
                if AAS_AreaClusterPortal(area1num) == 0 && AAS_AreaClusterPortal(area2num) == 0 {
                    stopevent |= SE_TOUCHCLUSTERPORTAL
                }
                //
                i = 0
                while i < 3 {
                    //
                    if i == 1 {
                        testend = testend + sidewards
                    } else if i == 2 {
                        testend = bestend - sidewards
                    } else {
                        testend = bestend
                    }
                    dir = testend - beststart
                    dir[2] = 0
                    VectorNormalize(&dir)
                    velocity = dir * speed
                    //
                    _ = AAS_PredictClientMovement(move, -1, beststart, PRESENCE_NORMAL, 1, velocity, cmdmove, 3, 30, 0.1, stopevent, 0, 0)
                    // if prediction time wasn't enough to fully predict the movement
                    if move.frames >= 30 {
                        return 0
                    }
                    // don't enter slime or lava and don't fall from too high
                    if (move.stopevent & (SE_ENTERSLIME | SE_ENTERLAVA)) != 0 {
                        return 0
                    }
                    // never jump or fall through a cluster portal
                    if (move.stopevent & SE_TOUCHCLUSTERPORTAL) != 0 {
                        return 0
                    }
                    //the end position should be in area2, also test a little bit back
                    //because the predicted jump could have rushed through the area
                    _VectorMA(move.endpos, -64, dir, &teststart)
                    teststart[2] += 1
                    numareas = AAS_TraceAreas(move.endpos, teststart, areas_AAS_Reachability_Jump, nil, Int32(areas_AAS_Reachability_Jump.count))
                    j = 0
                    while j < numareas {
                        if areas_AAS_Reachability_Jump[j] == area2num {
                            break
                        }
                        j += 1
                    } //end for
                    if j < numareas {
                        break
                    }
                    i += 1
                }
                if i >= 3 {
                    return 0
                }
                //
                //create a new reachability link
                lreach = AAS_AllocReachability()
                if lreach == nil { return 0 }
                lreach!.areanum = area2num
                lreach!.facenum = 0
                lreach!.edgenum = 0
                lreach!.start = beststart
                lreach!.end = bestend
                lreach!.traveltype = traveltype

                dir = bestend - beststart
                height = dir[2]
                dir[2] = 0
                if (traveltype & TRAVELTYPE_MASK) == TRAVEL_WALKOFFLEDGE && height > VectorLength(dir) {
                    lreach!.traveltime = Int32(aassettings.rs_startwalkoffledge + height * 50 / aassettings.phys_gravity)
                }
                else {
                    lreach!.traveltime = Int32(aassettings.rs_startjump + VectorDistance(bestend, beststart) * 240 / aassettings.phys_maxwalkvelocity)
                } //end if
                //
                if AAS_AreaJumpPad(area2num) == 0 {
                    if AAS_FallDelta(beststart[2] - bestend[2]) > aassettings.phys_falldelta5 {
                        lreach!.traveltime = Int32(lreach!.traveltime + aassettings.rs_falldamage5)
                    } //end if
                    else if AAS_FallDelta(beststart[2] - bestend[2]) > aassettings.phys_falldelta10 {
                        lreach!.traveltime = Int32(lreach!.traveltime + aassettings.rs_falldamage10)
                    } //end if
                } //end if
                lreach!.next = areareachability![area1num]
                areareachability![area1num] = lreach
                //
                if (traveltype & TRAVELTYPE_MASK) == TRAVEL_JUMP {
                    reach_jump += 1
                } else {
                    reach_walkoffledge += 1
                }
            } //end if
            return 0
        }
    }
}

//===========================================================================
// create a possible ladder reachability from area1 to area2
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:2363
func AAS_Reachability_Ladder(_ area1num: Int32, _ area2num: Int32) -> Int32 {
    return AasTrace.scratch { trace -> Int32 in
        var area2num = area2num
        var i: Int32, j: Int32, k: Int32, l: Int32, edge1num: Int32, edge2num: Int32, sharededgenum: Int32, lowestedgenum: Int32
        var face1num: Int32, face2num: Int32, ladderface1num: Int32, ladderface2num: Int32
        var ladderface1vertical: Int32, ladderface2vertical: Int32, firstv: Int32
        var face1area: Float, face2area: Float, bestface1area: Float, bestface2area: Float
        var phys_jumpvel: Float, maxjumpheight: Float
        var area1point = vec3_t(), area2point = vec3_t(), v1 = vec3_t(), v2 = vec3_t()
        let up = vec3_t(0, 0, 1)
        var mid = vec3_t(), lowestpoint = vec3_t(), start = vec3_t(), end = vec3_t(), sharededgevec = vec3_t(), dir = vec3_t()
        var area1: AasArea, area2: AasArea
        var face1: AasFace, face2: AasFace, ladderface1: AasFace?, ladderface2: AasFace?
        var plane1: AasPlane, plane2: AasPlane
        var sharededge: AasEdge, edge1: AasEdge
        var lreach: AasLreachability?

        if AAS_AreaLadder(area1num) == 0 || AAS_AreaLadder(area2num) == 0 { return 0 }
        //
        phys_jumpvel = aassettings.phys_jumpvel
        //maximum height a player can jump with the given initial z velocity
        maxjumpheight = AAS_MaxJumpHeight(phys_jumpvel)

        area1 = aasworld.areasSlots[area1num]
        area2 = aasworld.areasSlots[area2num]
        //
        ladderface1 = nil
        ladderface2 = nil
        ladderface1num = 0 //make compiler happy
        ladderface2num = 0 //make compiler happy
        bestface1area = -9999
        bestface2area = -9999
        sharededgenum = 0 //make compiler happy
        lowestedgenum = 0 //make compiler happy
        //
        i = 0
        while i < area1.numfaces {
            face1num = aasworld.faceindex![area1.firstface + i]
            face1 = aasworld.facesSlots[abs(face1num)]
            //if not a ladder face
            if (face1.faceflags & FACE_LADDER) == 0 {
                i += 1
                continue
            }
            //
            j = 0
            while j < area2.numfaces {
                face2num = aasworld.faceindex![area2.firstface + j]
                face2 = aasworld.facesSlots[abs(face2num)]
                //if not a ladder face
                if (face2.faceflags & FACE_LADDER) == 0 {
                    j += 1
                    continue
                }
                //check if the faces share an edge
                k = 0
                while k < face1.numedges {
                    edge1num = aasworld.edgeindex![face1.firstedge + k]
                    l = 0
                    while l < face2.numedges {
                        edge2num = aasworld.edgeindex![face2.firstedge + l]
                        if abs(edge1num) == abs(edge2num) {
                            //get the face with the largest area
                            face1area = AAS_FaceArea(face1)
                            face2area = AAS_FaceArea(face2)
                            if face1area > bestface1area && face2area > bestface2area {
                                bestface1area = face1area
                                bestface2area = face2area
                                ladderface1 = face1
                                ladderface2 = face2
                                ladderface1num = face1num
                                ladderface2num = face2num
                                sharededgenum = edge1num
                            } //end if
                            break
                        } //end if
                        l += 1
                    } //end for
                    if l != face2.numedges { break }
                    k += 1
                } //end for
                j += 1
            } //end for
            i += 1
        } //end for
        //
        if ladderface1 != nil && ladderface2 != nil {
            //get the middle of the shared edge
            sharededge = aasworld.edgesSlots[abs(sharededgenum)]
            firstv = sharededgenum < 0 ? 1 : 0
            //
            v1 = aasworld.vertexes![sharededge.v[firstv]]
            v2 = aasworld.vertexes![sharededge.v[firstv == 0 ? 1 : 0]]
            area1point = v1 + v2
            area1point = area1point * 0.5
            area2point = area1point
            //
            //if the face plane in area 1 is pretty much vertical
            plane1 = aasworld.planesSlots[ladderface1!.planenum ^ (ladderface1num < 0 ? 1 : 0)]
            plane2 = aasworld.planesSlots[ladderface2!.planenum ^ (ladderface2num < 0 ? 1 : 0)]
            //
            //get the points really into the areas
            sharededgevec = v2 - v1
            CrossProduct(plane1.normal, sharededgevec, &dir)
            VectorNormalize(&dir)
            //NOTE: 32 because that's larger than 16 (bot bbox x,y)
            _VectorMA(area1point, -32, dir, &area1point)
            _VectorMA(area2point, 32, dir, &area2point)
            //
            ladderface1vertical = Double(abs(_DotProduct(plane1.normal, up))) < 0.1 ? 1 : 0
            ladderface2vertical = Double(abs(_DotProduct(plane2.normal, up))) < 0.1 ? 1 : 0
            //there's only reachability between vertical ladder faces
            if ladderface1vertical == 0 && ladderface2vertical == 0 { return 0 }
            //if both vertical ladder faces
            if ladderface1vertical != 0 && ladderface2vertical != 0
                //and the ladder faces do not make a sharp corner
                && Double(_DotProduct(plane1.normal, plane2.normal)) > 0.7
                //and the shared edge is not too vertical
                && Double(abs(_DotProduct(sharededgevec, up))) < 0.7 {
                //create a new reachability link
                lreach = AAS_AllocReachability()
                if lreach == nil { return 0 }
                lreach!.areanum = area2num
                lreach!.facenum = ladderface1num
                lreach!.edgenum = abs(sharededgenum)
                lreach!.start = area1point
                //VectorCopy(area2point, lreach->end);
                _VectorMA(area2point, -3, plane1.normal, &lreach!.end)
                lreach!.traveltype = TRAVEL_LADDER
                lreach!.traveltime = 10
                lreach!.next = areareachability![area1num]
                areareachability![area1num] = lreach
                //
                reach_ladder += 1
                //create a new reachability link
                lreach = AAS_AllocReachability()
                if lreach == nil { return 0 }
                lreach!.areanum = area1num
                lreach!.facenum = ladderface2num
                lreach!.edgenum = abs(sharededgenum)
                lreach!.start = area2point
                //VectorCopy(area1point, lreach->end);
                _VectorMA(area1point, -3, plane1.normal, &lreach!.end)
                lreach!.traveltype = TRAVEL_LADDER
                lreach!.traveltime = 10
                lreach!.next = areareachability![area2num]
                areareachability![area2num] = lreach
                //
                reach_ladder += 1
                //
                return 1
            } //end if
            //if the second ladder face is also a ground face
            //create ladder end (just ladder) reachability and
            //walk off a ladder (ledge) reachability
            if ladderface1vertical != 0 && (ladderface2!.faceflags & FACE_GROUND) != 0 {
                //create a new reachability link
                lreach = AAS_AllocReachability()
                if lreach == nil { return 0 }
                lreach!.areanum = area2num
                lreach!.facenum = ladderface1num
                lreach!.edgenum = abs(sharededgenum)
                lreach!.start = area1point
                lreach!.end = area2point
                lreach!.end[2] += 16
                _VectorMA(lreach!.end, -15, plane1.normal, &lreach!.end)
                lreach!.traveltype = TRAVEL_LADDER
                lreach!.traveltime = 10
                lreach!.next = areareachability![area1num]
                areareachability![area1num] = lreach
                //
                reach_ladder += 1
                //create a new reachability link
                lreach = AAS_AllocReachability()
                if lreach == nil { return 0 }
                lreach!.areanum = area1num
                lreach!.facenum = ladderface2num
                lreach!.edgenum = abs(sharededgenum)
                lreach!.start = area2point
                lreach!.end = area1point
                lreach!.traveltype = TRAVEL_WALKOFFLEDGE
                lreach!.traveltime = 10
                lreach!.next = areareachability![area2num]
                areareachability![area2num] = lreach
                //
                reach_walkoffledge += 1
                //
                return 1
            } //end if
            //
            if ladderface1vertical != 0 {
                //find lowest edge of the ladder face
                lowestpoint[2] = 99999
                i = 0
                while i < ladderface1!.numedges {
                    edge1num = abs(aasworld.edgeindex![ladderface1!.firstedge + i])
                    edge1 = aasworld.edgesSlots[edge1num]
                    //
                    v1 = aasworld.vertexes![edge1.v[0]]
                    v2 = aasworld.vertexes![edge1.v[1]]
                    //
                    mid = v1 + v2
                    mid = mid * 0.5
                    //
                    if mid[2] < lowestpoint[2] {
                        lowestpoint = mid
                        lowestedgenum = edge1num
                    } //end if
                    i += 1
                } //end for
                //
                plane1 = aasworld.planesSlots[ladderface1!.planenum]
                //trace down in the middle of this edge
                _VectorMA(lowestpoint, 5, plane1.normal, &start)
                end = start
                start[2] += 5
                end[2] -= 100
                //trace without entity collision
                trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, -1))
                //
                //
                trace.endpos[2] += 1
                area2num = AAS_PointAreaNum(trace.endpos)
                //
                area2 = aasworld.areasSlots[area2num]
                i = 0
                while i < area2.numfaces {
                    face2num = aasworld.faceindex![area2.firstface + i]
                    face2 = aasworld.facesSlots[abs(face2num)]
                    //
                    if (face2.faceflags & FACE_LADDER) != 0 {
                        plane2 = aasworld.planesSlots[face2.planenum]
                        if Double(abs(_DotProduct(plane2.normal, up))) < 0.1 { break }
                    } //end if
                    i += 1
                } //end for
                //if from another area without vertical ladder faces
                if i >= area2.numfaces && area2num != area1num &&
                    //the reachabilities shouldn't exist already
                    !AAS_ReachabilityExists(area1num, area2num) &&
                    !AAS_ReachabilityExists(area2num, area1num) {
                    //if the height is jumpable
                    if start[2] - trace.endpos[2] < maxjumpheight {
                        //create a new reachability link
                        lreach = AAS_AllocReachability()
                        if lreach == nil { return 0 }
                        lreach!.areanum = area2num
                        lreach!.facenum = ladderface1num
                        lreach!.edgenum = lowestedgenum
                        lreach!.start = lowestpoint
                        lreach!.end = trace.endpos
                        lreach!.traveltype = TRAVEL_LADDER
                        lreach!.traveltime = 10
                        lreach!.next = areareachability![area1num]
                        areareachability![area1num] = lreach
                        //
                        reach_ladder += 1
                        //create a new reachability link
                        lreach = AAS_AllocReachability()
                        if lreach == nil { return 0 }
                        lreach!.areanum = area1num
                        lreach!.facenum = ladderface1num
                        lreach!.edgenum = lowestedgenum
                        lreach!.start = trace.endpos
                        //get the end point a little bit into the ladder
                        _VectorMA(lowestpoint, -5, plane1.normal, &lreach!.end)
                        //get the end point a little higher
                        lreach!.end[2] += 10
                        lreach!.traveltype = TRAVEL_JUMP
                        lreach!.traveltime = 10
                        lreach!.next = areareachability![area2num]
                        areareachability![area2num] = lreach
                        //
                        reach_jump += 1
                        //
                        return 1
                    } //end if
                } //end if
                /*//if slime or lava below the ladder
                //try jump reachability from far towards the ladder
                if (aasworld.areasettings[area2num].contents & (AREACONTENTS_SLIME
                                                        | AREACONTENTS_LAVA))
                {
                    for (i = 20; i <= 120; i += 20)
                    {
                        //trace down in the middle of this edge
                        VectorMA(lowestpoint, i, plane1->normal, start);
                        VectorCopy(start, end);
                        start[2] += 5;
                        end[2] -= 100;
                        //trace without entity collision
                        trace = AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, -1);
                        //
                        if (trace.startsolid) break;
                        trace.endpos[2] += 1;
                        area2num = AAS_PointAreaNum(trace.endpos);
                        if (area2num == area1num) continue;
                        //
                        if (start[2] - trace.endpos[2] > maxjumpheight) continue;
                        if (aasworld.areasettings[area2num].contents & (AREACONTENTS_SLIME
                                                    | AREACONTENTS_LAVA)) continue;
                        //
                        //create a new reachability link
                        lreach = AAS_AllocReachability();
                        if (!lreach) return qfalse;
                        lreach->areanum = area1num;
                        lreach->facenum = ladderface1num;
                        lreach->edgenum = lowestedgenum;
                        VectorCopy(trace.endpos, lreach->start);
                        VectorCopy(lowestpoint, lreach->end);
                        lreach->end[2] += 5;
                        lreach->traveltype = TRAVEL_JUMP;
                        lreach->traveltime = 10;
                        lreach->next = areareachability[area2num];
                        areareachability[area2num] = lreach;
                        //
                        reach_jump++;
                        //
                        Log_Write("jump far to ladder reach between %d and %d\r\n", area2num, area1num);
                        //
                        break;
                    } //end for
                } //end if*/
            } //end if
        } //end if
        return 0
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:2706
func AAS_TravelFlagsForTeam(_ ent: Int32) -> Int32 {
    var notteam: Int32 = 0

    if AAS_IntForBSPEpairKey(ent, "bot_notteam", &notteam) == 0 {
        return 0
    }
    if notteam == 1 {
        return TRAVELFLAG_NOTTEAM1
    }
    if notteam == 2 {
        return TRAVELFLAG_NOTTEAM2
    }
    return 0
}

//===========================================================================
// create possible teleporter reachabilities
// this is very game dependent.... :(
//
// classname = trigger_multiple or trigger_teleport
// target = "t1"
//
// classname = target_teleporter
// targetname = "t1"
// target = "t2"
//
// classname = misc_teleporter_dest
// targetname = "t2"
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:2736
func AAS_Reachability_Teleport() {
    AasTrace.scratch { trace -> Void in
        AasClientmove.scratch { move -> Void in
            var area1num: Int32, area2num: Int32
            var target = CharBuf(MAX_EPAIRKEY), targetname = CharBuf(MAX_EPAIRKEY)
            var classname = CharBuf(MAX_EPAIRKEY), model = CharBuf(MAX_EPAIRKEY)
            var ent: Int32, dest: Int32
            var angle: Float = 0
            var origin = vec3_t(), destorigin = vec3_t(), mins = vec3_t(), maxs = vec3_t(), end = vec3_t(), angles = vec3_t()
            var mid = vec3_t(), velocity = vec3_t(), cmdmove = vec3_t()
            var lreach: AasLreachability?
            var areas: AasLink?, link: AasLink?

            ent = AAS_NextBSPEntity(0)
            while ent != 0 {
                if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
                    ent = AAS_NextBSPEntity(ent)
                    continue
                }
                if strcmp(classname, "trigger_multiple") == 0 {
                    _ = AAS_ValueForBSPEpairKey(ent, "model", &model, MAX_EPAIRKEY)
    //#ifdef REACH_DEBUG
                    botimport.runPrint(PRT_MESSAGE, "trigger_multiple model = \"%s\"\n", String(model))
    //#endif REACH_DEBUG
                    angles = vec3_t()
                    AAS_BSPModelMinsMaxsOrigin(atoi(model[1...]), angles, &mins, &maxs, &origin)
                    //
                    if AAS_ValueForBSPEpairKey(ent, "target", &target, MAX_EPAIRKEY) == 0 {
                        botimport.runPrint(PRT_ERROR, "trigger_multiple at %1.0f %1.0f %1.0f without target\n", origin[0], origin[1], origin[2])
                        ent = AAS_NextBSPEntity(ent)
                        continue
                    } //end if
                    dest = AAS_NextBSPEntity(0)
                    while dest != 0 {
                        if AAS_ValueForBSPEpairKey(dest, "classname", &classname, MAX_EPAIRKEY) == 0 {
                            dest = AAS_NextBSPEntity(dest)
                            continue
                        }
                        if strcmp(classname, "target_teleporter") == 0 {
                            if AAS_ValueForBSPEpairKey(dest, "targetname", &targetname, MAX_EPAIRKEY) == 0 {
                                dest = AAS_NextBSPEntity(dest)
                                continue
                            }
                            if strcmp(targetname, target) == 0 {
                                break
                            } //end if
                        } //end if
                        dest = AAS_NextBSPEntity(dest)
                    } //end for
                    if dest == 0 {
                        ent = AAS_NextBSPEntity(ent)
                        continue
                    } //end if
                    if AAS_ValueForBSPEpairKey(dest, "target", &target, MAX_EPAIRKEY) == 0 {
                        botimport.runPrint(PRT_ERROR, "target_teleporter without target\n")
                        ent = AAS_NextBSPEntity(ent)
                        continue
                    } //end if
                } //end else
                else if strcmp(classname, "trigger_teleport") == 0 {
                    _ = AAS_ValueForBSPEpairKey(ent, "model", &model, MAX_EPAIRKEY)
    //#ifdef REACH_DEBUG
                    botimport.runPrint(PRT_MESSAGE, "trigger_teleport model = \"%s\"\n", String(model))
    //#endif REACH_DEBUG
                    angles = vec3_t()
                    AAS_BSPModelMinsMaxsOrigin(atoi(model[1...]), angles, &mins, &maxs, &origin)
                    //
                    if AAS_ValueForBSPEpairKey(ent, "target", &target, MAX_EPAIRKEY) == 0 {
                        botimport.runPrint(PRT_ERROR, "trigger_teleport at %1.0f %1.0f %1.0f without target\n", origin[0], origin[1], origin[2])
                        ent = AAS_NextBSPEntity(ent)
                        continue
                    } //end if
                } //end if
                else {
                    ent = AAS_NextBSPEntity(ent)
                    continue
                } //end else
                //
                dest = AAS_NextBSPEntity(0)
                while dest != 0 {
                    //classname should be misc_teleporter_dest
                    //but I've also seen target_position and actually any
                    //entity could be used... burp
                    if AAS_ValueForBSPEpairKey(dest, "targetname", &targetname, MAX_EPAIRKEY) != 0 {
                        if strcmp(targetname, target) == 0 {
                            break
                        } //end if
                    } //end if
                    dest = AAS_NextBSPEntity(dest)
                } //end for
                if dest == 0 {
                    botimport.runPrint(PRT_ERROR, "teleporter without misc_teleporter_dest (%s)\n", String(target))
                    ent = AAS_NextBSPEntity(ent)
                    continue
                } //end if
                if AAS_VectorForBSPEpairKey(dest, "origin", &destorigin) == 0 {
                    botimport.runPrint(PRT_ERROR, "teleporter destination (%s) without origin\n", String(target))
                    ent = AAS_NextBSPEntity(ent)
                    continue
                } //end if
                //
                area2num = AAS_PointAreaNum(destorigin)
                //if not teleported into a teleporter or into a jumppad
                if AAS_AreaTeleporter(area2num) == 0 && AAS_AreaJumpPad(area2num) == 0 {
                    end = destorigin
                    end[2] -= 64
                    trace.copy(from: AAS_TraceClientBBox(destorigin, end, PRESENCE_CROUCH, -1))
                    if trace.startsolid {
                        botimport.runPrint(PRT_ERROR, "teleporter destination (%s) in solid\n", String(target))
                        ent = AAS_NextBSPEntity(ent)
                        continue
                    } //end if
                    area2num = AAS_PointAreaNum(trace.endpos)
                    //
                    /*
                    if (!AAS_AreaTeleporter(area2num) &&
                        !AAS_AreaJumpPad(area2num) &&
                        !AAS_AreaGrounded(area2num))
                    {
                        VectorCopy(trace.endpos, destorigin);
                    }
                    else*/
                    do {
                        //predict where you'll end up
                        _ = AAS_FloatForBSPEpairKey(dest, "angle", &angle)
                        if angle != 0 {
                            angles = vec3_t(0, angle, 0)
                            var scratchRight = vec3_t()
                            var scratchUp = vec3_t()
                            // Raven passes NULL for the right and up outputs.
                            AngleVectors(angles, &velocity, &scratchRight, &scratchUp)
                            velocity = velocity * 400
                        } //end if
                        else {
                            velocity = vec3_t()
                        } //end else
                        cmdmove = vec3_t()
                        _ = AAS_PredictClientMovement(move, -1, destorigin, PRESENCE_NORMAL, 0, velocity, cmdmove, 0, 30, 0.1, SE_HITGROUND | SE_ENTERWATER | SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE | SE_TOUCHJUMPPAD | SE_TOUCHTELEPORTER, 0, 0) //qtrue);
                        area2num = AAS_PointAreaNum(move.endpos)
                        if (move.stopevent & (SE_ENTERSLIME | SE_ENTERLAVA)) != 0 {
                            botimport.runPrint(PRT_WARNING, "teleported into slime or lava at dest %s\n", String(target))
                        } //end if
                        destorigin = move.endpos
                    } //end else
                } //end if
                //
                //botimport.Print(PRT_MESSAGE, "teleporter brush origin at %f %f %f\n", origin[0], origin[1], origin[2]);
                //botimport.Print(PRT_MESSAGE, "teleporter brush mins = %f %f %f\n", mins[0], mins[1], mins[2]);
                //botimport.Print(PRT_MESSAGE, "teleporter brush maxs = %f %f %f\n", maxs[0], maxs[1], maxs[2]);
                mins = origin + mins
                maxs = origin + maxs
                //
                mid = mins + maxs
                mid = mid * 0.5
                //link an invalid (-1) entity
                areas = AAS_LinkEntityClientBBox(mins, maxs, -1, PRESENCE_CROUCH)
                if areas == nil {
                    botimport.runPrint(PRT_MESSAGE, "trigger_multiple not in any area\n")
                }
                //
                link = areas
                while link != nil {
                    //if (!AAS_AreaGrounded(link->areanum)) continue;
                    if AAS_AreaTeleporter(link!.areanum) == 0 {
                        link = link!.next_area
                        continue
                    }
                    //
                    area1num = link!.areanum
                    //create a new reachability link
                    lreach = AAS_AllocReachability()
                    if lreach == nil { break }
                    lreach!.areanum = area2num
                    lreach!.facenum = 0
                    lreach!.edgenum = 0
                    lreach!.start = mid
                    lreach!.end = destorigin
                    lreach!.traveltype = TRAVEL_TELEPORT
                    lreach!.traveltype |= AAS_TravelFlagsForTeam(ent)
                    lreach!.traveltime = Int32(aassettings.rs_teleport)
                    lreach!.next = areareachability![area1num]
                    areareachability![area1num] = lreach
                    //
                    reach_teleport += 1
                    link = link!.next_area
                } //end for
                //unlink the invalid entity
                AAS_UnlinkFromAreas(areas)
                ent = AAS_NextBSPEntity(ent)
            } //end for
        }
    }
}

//===========================================================================
// create possible elevator (func_plat) reachabilities
// this is very game dependent.... :(
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:2930
func AAS_Reachability_Elevator() {
    AasTrace.scratch { trace -> Void in
        var area1num: Int32 = 0, area2num: Int32, modelnum: Int32, i: Int32, j: Int32, k: Int32, l: Int32, n: Int32, p: Int32
        var lip: Float = 0, height: Float = 0, speed: Float = 0
        var model = CharBuf(MAX_EPAIRKEY), classname = CharBuf(MAX_EPAIRKEY)
        var ent: Int32
        var mins = vec3_t(), maxs = vec3_t(), origin = vec3_t()
        let angles = vec3_t(0, 0, 0)
        var pos1 = vec3_t(), pos2 = vec3_t(), mids = vec3_t(), platbottom = vec3_t(), plattop = vec3_t()
        var bottomorg = vec3_t(), toporg = vec3_t(), start = vec3_t(), end = vec3_t(), dir = vec3_t()
        var xvals: [vec_t] = Array(repeating: 0, count: 8), yvals: [vec_t] = Array(repeating: 0, count: 8)
        var xvals_top: [vec_t] = Array(repeating: 0, count: 8), yvals_top: [vec_t] = Array(repeating: 0, count: 8)
        var lreach: AasLreachability?

        ent = AAS_NextBSPEntity(0)
        while ent != 0 {
            if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            if strcmp(classname, "func_plat") == 0 {
                if AAS_ValueForBSPEpairKey(ent, "model", &model, MAX_EPAIRKEY) == 0 {
                    botimport.runPrint(PRT_ERROR, "func_plat without model\n")
                    ent = AAS_NextBSPEntity(ent)
                    continue
                } //end if
                //get the model number, and skip the leading *
                modelnum = atoi(model[1...])
                if modelnum <= 0 {
                    botimport.runPrint(PRT_ERROR, "func_plat with invalid model number\n")
                    ent = AAS_NextBSPEntity(ent)
                    continue
                } //end if
                //get the mins, maxs and origin of the model
                //NOTE: the origin is usually (0,0,0) and the mins and maxs
                //      are the absolute mins and maxs
                AAS_BSPModelMinsMaxsOrigin(modelnum, angles, &mins, &maxs, &origin)
                //
                _ = AAS_VectorForBSPEpairKey(ent, "origin", &origin)
                //pos1 is the top position, pos2 is the bottom
                pos1 = origin
                pos2 = origin
                //get the lip of the plat
                _ = AAS_FloatForBSPEpairKey(ent, "lip", &lip)
                if lip == 0 { lip = 8 }
                //get the movement height of the plat
                _ = AAS_FloatForBSPEpairKey(ent, "height", &height)
                if height == 0 { height = (maxs[2] - mins[2]) - lip }
                //get the speed of the plat
                _ = AAS_FloatForBSPEpairKey(ent, "speed", &speed)
                if speed == 0 { speed = 200 }
                //get bottom position below pos1
                pos2[2] -= height
                //
                //get a point just above the plat in the bottom position
                mids = mins + maxs
                platbottom[0] = Float(Double(pos2[0]) + Double(mids[0]) * 0.5)
                platbottom[1] = Float(Double(pos2[1]) + Double(mids[1]) * 0.5)
                platbottom[2] = Float(Double(pos2[2]) + Double(mids[2]) * 0.5)
                platbottom[2] = maxs[2] - (pos1[2] - pos2[2]) + 2
                //get a point just above the plat in the top position
                mids = mins + maxs
                plattop[0] = Float(Double(pos2[0]) + Double(mids[0]) * 0.5)
                plattop[1] = Float(Double(pos2[1]) + Double(mids[1]) * 0.5)
                plattop[2] = Float(Double(pos2[2]) + Double(mids[2]) * 0.5)
                plattop[2] = maxs[2] + 2
                //
                /*if (!area1num)
                {
                    Log_Write("no grounded area near plat bottom\r\n");
                    continue;
                } //end if*/
                //get the mins and maxs a little larger
                i = 0
                while i < 3 {
                    mins[i] -= 1
                    maxs[i] += 1
                    i += 1
                } //end for
                //
                //botimport.Print(PRT_MESSAGE, "platbottom[2] = %1.1f plattop[2] = %1.1f\n", platbottom[2], plattop[2]);
                //
                mids = mins + maxs
                mids = mids * 0.5
                //
                xvals[0] = mins[0]
                xvals[1] = mids[0]
                xvals[2] = maxs[0]
                xvals[3] = mids[0]
                yvals[0] = mids[1]
                yvals[1] = maxs[1]
                yvals[2] = mids[1]
                yvals[3] = mins[1]
                //
                xvals[4] = mins[0]
                xvals[5] = maxs[0]
                xvals[6] = maxs[0]
                xvals[7] = mins[0]
                yvals[4] = maxs[1]
                yvals[5] = maxs[1]
                yvals[6] = mins[1]
                yvals[7] = mins[1]
                //find adjacent areas around the bottom of the plat
                i = 0
                while i < 9 {
                    if i < 8 { //check at the sides of the plat
                        bottomorg[0] = origin[0] + xvals[i]
                        bottomorg[1] = origin[1] + yvals[i]
                        bottomorg[2] = platbottom[2] + 16
                        //get a grounded or swim area near the plat in the bottom position
                        area1num = AAS_PointAreaNum(bottomorg)
                        k = 0
                        while k < 16 {
                            if area1num != 0 {
                                if AAS_AreaGrounded(area1num) != 0 || AAS_AreaSwim(area1num) != 0 { break }
                            } //end if
                            bottomorg[2] += 4
                            area1num = AAS_PointAreaNum(bottomorg)
                            k += 1
                        } //end if
                        //if in solid
                        if k >= 16 {
                            i += 1
                            continue
                        } //end if
                    } //end if
                    else { //at the middle of the plat
                        bottomorg = plattop
                        bottomorg[2] += 24
                        area1num = AAS_PointAreaNum(bottomorg)
                        if area1num == 0 {
                            i += 1
                            continue
                        }
                        bottomorg = platbottom
                        bottomorg[2] += 24
                    } //end else
                    //look at adjacent areas around the top of the plat
                    //make larger steps to outside the plat everytime
                    n = 0
                    while n < 3 {
                        k = 0
                        while k < 3 {
                            mins[k] -= 4
                            maxs[k] += 4
                            k += 1
                        } //end for
                        xvals_top[0] = mins[0]
                        xvals_top[1] = mids[0]
                        xvals_top[2] = maxs[0]
                        xvals_top[3] = mids[0]
                        yvals_top[0] = mids[1]
                        yvals_top[1] = maxs[1]
                        yvals_top[2] = mids[1]
                        yvals_top[3] = mins[1]
                        //
                        xvals_top[4] = mins[0]
                        xvals_top[5] = maxs[0]
                        xvals_top[6] = maxs[0]
                        xvals_top[7] = mins[0]
                        yvals_top[4] = maxs[1]
                        yvals_top[5] = maxs[1]
                        yvals_top[6] = mins[1]
                        yvals_top[7] = mins[1]
                        //
                        j = 0
                        while j < 8 {
                            toporg[0] = origin[0] + xvals_top[j]
                            toporg[1] = origin[1] + yvals_top[j]
                            toporg[2] = plattop[2] + 16
                            //get a grounded or swim area near the plat in the top position
                            area2num = AAS_PointAreaNum(toporg)
                            l = 0
                            while l < 16 {
                                if area2num != 0 {
                                    if AAS_AreaGrounded(area2num) != 0 || AAS_AreaSwim(area2num) != 0 {
                                        start = plattop
                                        start[2] += 32
                                        end = toporg
                                        end[2] += 1
                                        trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, -1))
                                        if trace.fraction >= 1 { break }
                                    } //end if
                                } //end if
                                toporg[2] += 4
                                area2num = AAS_PointAreaNum(toporg)
                                l += 1
                            } //end if
                            //if in solid
                            if l >= 16 {
                                j += 1
                                continue
                            }
                            //never create a reachability in the same area
                            if area2num == area1num {
                                j += 1
                                continue
                            }
                            //if the area isn't grounded
                            if AAS_AreaGrounded(area2num) == 0 {
                                j += 1
                                continue
                            }
                            //if there already exists reachability between the areas
                            if AAS_ReachabilityExists(area1num, area2num) {
                                j += 1
                                continue
                            }
                            //if the reachability start is within the elevator bounding box
                            dir = bottomorg - platbottom
                            VectorNormalize(&dir)
                            dir[0] = bottomorg[0] + 24 * dir[0]
                            dir[1] = bottomorg[1] + 24 * dir[1]
                            dir[2] = bottomorg[2]
                            //
                            p = 0
                            while p < 3 {
                                if dir[p] < origin[p] + mins[p] || dir[p] > origin[p] + maxs[p] { break }
                                p += 1
                            }
                            if p >= 3 {
                                j += 1
                                continue
                            }
                            //create a new reachability link
                            lreach = AAS_AllocReachability()
                            if lreach == nil {
                                j += 1
                                continue
                            }
                            lreach!.areanum = area2num
                            //the facenum is the model number
                            lreach!.facenum = modelnum
                            //the edgenum is the height
                            lreach!.edgenum = Int32(height)
                            //
                            lreach!.start = dir
                            lreach!.end = toporg
                            lreach!.traveltype = TRAVEL_ELEVATOR
                            lreach!.traveltype |= AAS_TravelFlagsForTeam(ent)
                            lreach!.traveltime = Int32(aassettings.rs_startelevator + height * 100 / speed)
                            lreach!.next = areareachability![area1num]
                            areareachability![area1num] = lreach
                            //don't go any further to the outside
                            n = 9999
                            //
                            //
                            reach_elevator += 1
                            j += 1
                        } //end for
                        n += 1
                    } //end for
                    i += 1
                } //end for
            } //end if
            ent = AAS_NextBSPEntity(ent)
        } //end for
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3145
func AAS_FindFaceReachabilities(_ facepoints: Slots<JKAShared.vec3_t>, _ numpoints: Int32, _ plane: AasPlane, _ towardsface: Int32) -> AasLreachability? {
    var i: Int32, j: Int32, k: Int32, l: Int32
    var facenum: Int32, edgenum: Int32, bestfacenum: Int32
    var v1 = vec3_t(), v2 = vec3_t(), v3 = vec3_t(), v4 = vec3_t()
    var bestdist: Float, speed: Float = 0, hordist: Float, dist: Float
    var beststart = vec3_t(), beststart2 = vec3_t(), bestend = vec3_t(), bestend2 = vec3_t(), tmp = vec3_t(), hordir = vec3_t(), testpoint = vec3_t()
    var lreach: AasLreachability?, lreachabilities: AasLreachability?
    var area: AasArea
    var face: AasFace
    var edge: AasEdge
    var faceplane: AasPlane, bestfaceplane: AasPlane?

    //
    lreachabilities = nil
    bestfacenum = 0
    bestfaceplane = nil
    //
    i = 1
    while i < aasworld.numareas {
        area = aasworld.areasSlots[i]
        // get the shortest distance between one of the func_bob start edges and
        // one of the face edges of area1
        bestdist = 999999
        j = 0
        while j < area.numfaces {
            facenum = aasworld.faceindex![area.firstface + j]
            face = aasworld.facesSlots[abs(facenum)]
            //if not a ground face
            if (face.faceflags & FACE_GROUND) == 0 {
                j += 1
                continue
            }
            //get the ground planes
            faceplane = aasworld.planesSlots[face.planenum]
            //
            k = 0
            while k < face.numedges {
                edgenum = abs(aasworld.edgeindex![face.firstedge + k])
                edge = aasworld.edgesSlots[edgenum]
                //calculate the minimum distance between the two edges
                v1 = aasworld.vertexes![edge.v[0]]
                v2 = aasworld.vertexes![edge.v[1]]
                //
                l = 0
                while l < numpoints {
                    v3 = facepoints[l]
                    v4 = facepoints[(l + 1) % numpoints]
                    dist = AAS_ClosestEdgePoints(v1, v2, v3, v4, faceplane, plane, &beststart, &bestend, &beststart2, &bestend2, bestdist)
                    if dist < bestdist {
                        bestfacenum = facenum
                        bestfaceplane = faceplane
                        bestdist = dist
                    } //end if
                    l += 1
                } //end for
                k += 1
            } //end for
            j += 1
        } //end for
        //
        if bestdist > 192 {
            i += 1
            continue
        }
        //
        VectorMiddle(beststart, beststart2, &beststart)
        VectorMiddle(bestend, bestend2, &bestend)
        //
        if towardsface == 0 {
            tmp = beststart
            beststart = bestend
            bestend = tmp
        } //end if
        //
        hordir = bestend - beststart
        hordir[2] = 0
        hordist = VectorLength(hordir)
        //
        if hordist > 2 * AAS_MaxJumpDistance(aassettings.phys_jumpvel) {
            i += 1
            continue
        }
        //the end point should not be significantly higher than the start point
        if bestend[2] - 32 > beststart[2] {
            i += 1
            continue
        }
        //don't fall down too far
        if bestend[2] < beststart[2] - 128 {
            i += 1
            continue
        }
        //the distance should not be too far
        if hordist > 32 {
            //check for walk off ledge
            if AAS_HorizontalVelocityForJump(0, beststart, bestend, &speed) == 0 {
                i += 1
                continue
            }
        } //end if
        //
        beststart[2] += 1
        bestend[2] += 1
        //
        if towardsface != 0 {
            testpoint = bestend
        } else {
            testpoint = beststart
        }
        testpoint[2] = 0
        testpoint[2] = (bestfaceplane!.dist - _DotProduct(bestfaceplane!.normal, testpoint)) / bestfaceplane!.normal[2]
        //
        if !AAS_PointInsideFace(bestfacenum, testpoint, 0.1) {
            //if the faces are not overlapping then only go down
            if bestend[2] - 16 > beststart[2] {
                i += 1
                continue
            }
        } //end if
        lreach = AAS_AllocReachability()
        if lreach == nil { return lreachabilities }
        lreach!.areanum = i
        lreach!.facenum = 0
        lreach!.edgenum = 0
        lreach!.start = beststart
        lreach!.end = bestend
        lreach!.traveltype = 0
        lreach!.traveltime = 0
        lreach!.next = lreachabilities
        lreachabilities = lreach
        if towardsface != 0 {
            AAS_PermanentLine(lreach!.start, lreach!.end, 1)
        } else {
            AAS_PermanentLine(lreach!.start, lreach!.end, 2)
        }
        i += 1
    } //end for
    return lreachabilities
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3268
func AAS_Reachability_FuncBobbing() {
    AasPlane.scratch { start_plane -> Void in
        AasPlane.scratch { end_plane -> Void in
            // AI: Raven declares `int areas[10]` on his stack.
            // The body uses the zeroed allocation of the storage class through the `areas_AAS_Reachability_FuncBobbing` forward.
            // AI: Raven declares `vec3_t start_edgeverts[4], end_edgeverts[4]` and `vec3_t points[10]` on his stack.
            // The body uses the zeroed allocations of the storage class through the three forwards with the `_AAS_Reachability_FuncBobbing` suffix.
            var ent: Int32, spawnflags: Int32 = 0, modelnum: Int32, axis: Int32
            var i: Int32, numareas: Int32
            var classname = CharBuf(MAX_EPAIRKEY), model = CharBuf(MAX_EPAIRKEY)
            var origin = vec3_t(), move_end = vec3_t(), move_start = vec3_t(), move_start_top = vec3_t(), move_end_top = vec3_t()
            var mins = vec3_t(), maxs = vec3_t()
            let angles = vec3_t(0, 0, 0)
            var mid = vec3_t()
            var org = vec3_t(), start = vec3_t(), end = vec3_t(), dir = vec3_t()
            var height: Float = 0
            var startreach: AasLreachability?, endreach: AasLreachability?, nextstartreach: AasLreachability?, nextendreach: AasLreachability?, lreach: AasLreachability?
            var firststartreach: AasLreachability?, firstendreach: AasLreachability?

            ent = AAS_NextBSPEntity(0)
            while ent != 0 {
                if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
                    ent = AAS_NextBSPEntity(ent)
                    continue
                }
                if strcmp(classname, "func_bobbing") != 0 {
                    ent = AAS_NextBSPEntity(ent)
                    continue
                }
                _ = AAS_FloatForBSPEpairKey(ent, "height", &height)
                if height == 0 { height = 32 }
                //
                if AAS_ValueForBSPEpairKey(ent, "model", &model, MAX_EPAIRKEY) == 0 {
                    botimport.runPrint(PRT_ERROR, "func_bobbing without model\n")
                    ent = AAS_NextBSPEntity(ent)
                    continue
                } //end if
                //get the model number, and skip the leading *
                modelnum = atoi(model[1...])
                if modelnum <= 0 {
                    botimport.runPrint(PRT_ERROR, "func_bobbing with invalid model number\n")
                    ent = AAS_NextBSPEntity(ent)
                    continue
                } //end if
                //if the entity has an origin set then use it
                if AAS_VectorForBSPEpairKey(ent, "origin", &origin) == 0 {
                    origin = vec3_t(0, 0, 0)
                }
                //
                // Raven passes NULL for the `origin` output, and the scratch local takes the write.
                var scratchOrigin = vec3_t()
                AAS_BSPModelMinsMaxsOrigin(modelnum, angles, &mins, &maxs, &scratchOrigin)
                //
                mins = mins + origin
                maxs = maxs + origin
                //
                mid = mins + maxs
                mid = mid * 0.5
                origin = mid
                //
                move_end = origin
                move_start = origin
                //
                _ = AAS_IntForBSPEpairKey(ent, "spawnflags", &spawnflags)
                // set the axis of bobbing
                if (spawnflags & 1) != 0 {
                    axis = 0
                } else if (spawnflags & 2) != 0 {
                    axis = 1
                } else {
                    axis = 2
                }
                //
                move_start[axis] -= height
                move_end[axis] += height
                //
                Log_Write("funcbob model %d, start = {%1.1f, %1.1f, %1.1f} end = {%1.1f, %1.1f, %1.1f}\n", modelnum, move_start[0], move_start[1], move_start[2], move_end[0], move_end[1], move_end[2])
                //
                /*
                AAS_DrawPermanentCross(move_start, 4, 1);
                AAS_DrawPermanentCross(move_end, 4, 2);
                */
                //
                i = 0
                while i < 4 {
                    start_edgeverts_AAS_Reachability_FuncBobbing[i] = move_start
                    start_edgeverts_AAS_Reachability_FuncBobbing[i][2] += maxs[2] - mid[2] //+ bbox maxs z
                    start_edgeverts_AAS_Reachability_FuncBobbing[i][2] += 24	//+ player origin to ground dist
                    i += 1
                } //end for
                start_edgeverts_AAS_Reachability_FuncBobbing[0][0] += maxs[0] - mid[0]
                start_edgeverts_AAS_Reachability_FuncBobbing[0][1] += maxs[1] - mid[1]
                start_edgeverts_AAS_Reachability_FuncBobbing[1][0] += maxs[0] - mid[0]
                start_edgeverts_AAS_Reachability_FuncBobbing[1][1] += mins[1] - mid[1]
                start_edgeverts_AAS_Reachability_FuncBobbing[2][0] += mins[0] - mid[0]
                start_edgeverts_AAS_Reachability_FuncBobbing[2][1] += mins[1] - mid[1]
                start_edgeverts_AAS_Reachability_FuncBobbing[3][0] += mins[0] - mid[0]
                start_edgeverts_AAS_Reachability_FuncBobbing[3][1] += maxs[1] - mid[1]
                //
                start_plane.dist = start_edgeverts_AAS_Reachability_FuncBobbing[0][2]
                start_plane.normal = vec3_t(0, 0, 1)
                //
                i = 0
                while i < 4 {
                    end_edgeverts_AAS_Reachability_FuncBobbing[i] = move_end
                    end_edgeverts_AAS_Reachability_FuncBobbing[i][2] += maxs[2] - mid[2] //+ bbox maxs z
                    end_edgeverts_AAS_Reachability_FuncBobbing[i][2] += 24	//+ player origin to ground dist
                    i += 1
                } //end for
                end_edgeverts_AAS_Reachability_FuncBobbing[0][0] += maxs[0] - mid[0]
                end_edgeverts_AAS_Reachability_FuncBobbing[0][1] += maxs[1] - mid[1]
                end_edgeverts_AAS_Reachability_FuncBobbing[1][0] += maxs[0] - mid[0]
                end_edgeverts_AAS_Reachability_FuncBobbing[1][1] += mins[1] - mid[1]
                end_edgeverts_AAS_Reachability_FuncBobbing[2][0] += mins[0] - mid[0]
                end_edgeverts_AAS_Reachability_FuncBobbing[2][1] += mins[1] - mid[1]
                end_edgeverts_AAS_Reachability_FuncBobbing[3][0] += mins[0] - mid[0]
                end_edgeverts_AAS_Reachability_FuncBobbing[3][1] += maxs[1] - mid[1]
                //
                end_plane.dist = end_edgeverts_AAS_Reachability_FuncBobbing[0][2]
                end_plane.normal = vec3_t(0, 0, 1)
                //
                move_start_top = move_start
                move_start_top[2] += maxs[2] - mid[2] + 24 //+ bbox maxs z
                move_end_top = move_end
                move_end_top[2] += maxs[2] - mid[2] + 24 //+ bbox maxs z
                //
                if AAS_PointAreaNum(move_start_top) == 0 {
                    ent = AAS_NextBSPEntity(ent)
                    continue
                }
                if AAS_PointAreaNum(move_end_top) == 0 {
                    ent = AAS_NextBSPEntity(ent)
                    continue
                }
                //
                i = 0
                while i < 2 {
                    firstendreach = nil
                    firststartreach = firstendreach
                    //
                    if i == 0 {
                        firststartreach = AAS_FindFaceReachabilities(start_edgeverts_AAS_Reachability_FuncBobbing, 4, start_plane, 1)
                        firstendreach = AAS_FindFaceReachabilities(end_edgeverts_AAS_Reachability_FuncBobbing, 4, end_plane, 0)
                    } //end if
                    else {
                        firststartreach = AAS_FindFaceReachabilities(end_edgeverts_AAS_Reachability_FuncBobbing, 4, end_plane, 1)
                        firstendreach = AAS_FindFaceReachabilities(start_edgeverts_AAS_Reachability_FuncBobbing, 4, start_plane, 0)
                    } //end else
                    //
                    //create reachabilities from start to end
                    startreach = firststartreach
                    while startreach != nil {
                        nextstartreach = startreach!.next
                        //
                        //trace = AAS_TraceClientBBox(startreach->start, move_start_top, PRESENCE_NORMAL, -1);
                        //if (trace.fraction < 1) continue;
                        //
                        endreach = firstendreach
                        while endreach != nil {
                            nextendreach = endreach!.next
                            //
                            //trace = AAS_TraceClientBBox(endreach->end, move_end_top, PRESENCE_NORMAL, -1);
                            //if (trace.fraction < 1) continue;
                            //
                            Log_Write("funcbob reach from area %d to %d\n", startreach!.areanum, endreach!.areanum)
                            //
                            //
                            if i == 0 {
                                org = move_start_top
                            } else {
                                org = move_end_top
                            }
                            dir = startreach!.start - org
                            dir[2] = 0
                            VectorNormalize(&dir)
                            start = startreach!.start
                            _VectorMA(startreach!.start, 1, dir, &start)
                            start[2] += 1
                            _VectorMA(startreach!.start, 16, dir, &end)
                            end[2] += 1
                            //
                            numareas = AAS_TraceAreas(start, end, areas_AAS_Reachability_FuncBobbing, points_AAS_Reachability_FuncBobbing, 10)
                            if numareas <= 0 {
                                endreach = nextendreach
                                continue
                            }
                            if numareas > 1 {
                                startreach!.start = points_AAS_Reachability_FuncBobbing[1]
                            } else {
                                startreach!.start = end
                            }
                            //
                            if AAS_PointAreaNum(startreach!.start) == 0 {
                                endreach = nextendreach
                                continue
                            }
                            if AAS_PointAreaNum(endreach!.end) == 0 {
                                endreach = nextendreach
                                continue
                            }
                            //
                            lreach = AAS_AllocReachability()
                            lreach!.areanum = endreach!.areanum
                            if i == 0 {
                                lreach!.edgenum = (Int32(move_start[axis]) << 16) | (Int32(move_end[axis]) & 0x0000ffff)
                            } else {
                                lreach!.edgenum = (Int32(move_end[axis]) << 16) | (Int32(move_start[axis]) & 0x0000ffff)
                            }
                            lreach!.facenum = (spawnflags << 16) | modelnum
                            lreach!.start = startreach!.start
                            lreach!.end = endreach!.end
    //					AAS_DrawArrow(lreach->start, lreach->end, LINECOLOR_BLUE, LINECOLOR_YELLOW);
    //					AAS_PermanentLine(lreach->start, lreach->end, 1);
                            lreach!.traveltype = TRAVEL_FUNCBOB
                            lreach!.traveltype |= AAS_TravelFlagsForTeam(ent)
                            lreach!.traveltime = Int32(aassettings.rs_funcbob)
                            reach_funcbob += 1
                            lreach!.next = areareachability![startreach!.areanum]
                            areareachability![startreach!.areanum] = lreach
                            //
                            endreach = nextendreach
                        } //end for
                        startreach = nextstartreach
                    } //end for
                    startreach = firststartreach
                    while startreach != nil {
                        nextstartreach = startreach!.next
                        AAS_FreeReachability(startreach!)
                        startreach = nextstartreach
                    } //end for
                    endreach = firstendreach
                    while endreach != nil {
                        nextendreach = endreach!.next
                        AAS_FreeReachability(endreach!)
                        endreach = nextendreach
                    } //end for
                    //only go up with func_bobbing entities that go up and down
                    if (spawnflags & 1) == 0 && (spawnflags & 2) == 0 { break }
                    i += 1
                } //end for
                ent = AAS_NextBSPEntity(ent)
            } //end for
        }
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3482
func AAS_Reachability_JumpPad() {
    AasClientmove.scratch { move -> Void in
        var face2num: Int32, i: Int32, ret: Int32, area2num: Int32, visualize: Int32, ent: Int32, bot_visualizejumppads: Int32
        //int modelnum, ent2;
        //float dist, time, height, gravity, forward;
        var speed: Float = 0, zvel: Float, hordist: Float
        var face2: AasFace
        var area2: AasArea
        var lreach: AasLreachability?
        var areastart = vec3_t(), facecenter = vec3_t(), dir = vec3_t(), cmdmove = vec3_t()
        var velocity = vec3_t(), absmins = vec3_t(), absmaxs = vec3_t()
        //vec3_t origin, ent2origin, angles, teststart;
        //aas_trace_t trace;
        var areas: AasLink?, link: AasLink?
        //char target[MAX_EPAIRKEY], targetname[MAX_EPAIRKEY], model[MAX_EPAIRKEY];
        var classname = CharBuf(MAX_EPAIRKEY)

        bot_visualizejumppads = Int32(LibVarValue("bot_visualizejumppads", "0"))
        ent = AAS_NextBSPEntity(0)
        while ent != 0 {
            if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            if strcmp(classname, "trigger_push") != 0 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            //
            if AAS_GetJumpPadInfo(ent, &areastart, &absmins, &absmaxs, &velocity) == 0 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            /*
            //
            AAS_FloatForBSPEpairKey(ent, "speed", &speed);
            if (!speed) speed = 1000;
    //		AAS_VectorForBSPEpairKey(ent, "angles", angles);
    //		AAS_SetMovedir(angles, velocity);
    //		VectorScale(velocity, speed, velocity);
            VectorClear(angles);
            //get the mins, maxs and origin of the model
            AAS_ValueForBSPEpairKey(ent, "model", model, MAX_EPAIRKEY);
            if (model[0]) modelnum = atoi(model+1);
            else modelnum = 0;
            AAS_BSPModelMinsMaxsOrigin(modelnum, angles, absmins, absmaxs, origin);
            VectorAdd(origin, absmins, absmins);
            VectorAdd(origin, absmaxs, absmaxs);
            //
    #ifdef REACH_DEBUG
            botimport.Print(PRT_MESSAGE, "absmins = %f %f %f\n", absmins[0], absmins[1], absmins[2]);
            botimport.Print(PRT_MESSAGE, "absmaxs = %f %f %f\n", absmaxs[0], absmaxs[1], absmaxs[2]);
    #endif REACH_DEBUG
            VectorAdd(absmins, absmaxs, origin);
            VectorScale (origin, 0.5, origin);

            //get the start areas
            VectorCopy(origin, teststart);
            teststart[2] += 64;
            trace = AAS_TraceClientBBox(teststart, origin, PRESENCE_CROUCH, -1);
            if (trace.startsolid)
            {
                botimport.Print(PRT_MESSAGE, "trigger_push start solid\n");
                VectorCopy(origin, areastart);
            } //end if
            else
            {
                VectorCopy(trace.endpos, areastart);
            } //end else
            areastart[2] += 0.125;
            //
            //AAS_DrawPermanentCross(origin, 4, 4);
            //get the target entity
            AAS_ValueForBSPEpairKey(ent, "target", target, MAX_EPAIRKEY);
            for (ent2 = AAS_NextBSPEntity(0); ent2; ent2 = AAS_NextBSPEntity(ent2))
            {
                if (!AAS_ValueForBSPEpairKey(ent2, "targetname", targetname, MAX_EPAIRKEY)) continue;
                if (!strcmp(targetname, target)) break;
            } //end for
            if (!ent2)
            {
                botimport.Print(PRT_MESSAGE, "trigger_push without target entity %s\n", target);
                continue;
            } //end if
            AAS_VectorForBSPEpairKey(ent2, "origin", ent2origin);
            //
            height = ent2origin[2] - origin[2];
            gravity = aassettings.sv_gravity;
            time = sqrt( height / ( 0.5 * gravity ) );
            if (!time)
            {
                botimport.Print(PRT_MESSAGE, "trigger_push without time\n");
                continue;
            } //end if
            // set s.origin2 to the push velocity
            VectorSubtract ( ent2origin, origin, velocity);
            dist = VectorNormalize( velocity);
            forward = dist / time;
            //FIXME: why multiply by 1.1
            forward *= 1.1;
            VectorScale(velocity, forward, velocity);
            velocity[2] = time * gravity;
            */
            //get the areas the jump pad brush is in
            areas = AAS_LinkEntityClientBBox(absmins, absmaxs, -1, PRESENCE_CROUCH)
            /*
            for (link = areas; link; link = link->next_area)
            {
                if (link->areanum == 563)
                {
                    ret = qfalse;
                }
            }
            */
            link = areas
            while link != nil {
                if AAS_AreaJumpPad(link!.areanum) != 0 { break }
                link = link!.next_area
            } //end for
            if link == nil {
                botimport.runPrint(PRT_MESSAGE, "trigger_push not in any jump pad area\n")
                AAS_UnlinkFromAreas(areas)
                ent = AAS_NextBSPEntity(ent)
                continue
            } //end if
            //
            botimport.runPrint(PRT_MESSAGE, "found a trigger_push with velocity %f %f %f\n", velocity[0], velocity[1], velocity[2])
            //if there is a horizontal velocity check for a reachability without air control
            if velocity[0] != 0 || velocity[1] != 0 {
                cmdmove = vec3_t(0, 0, 0)
                //VectorCopy(velocity, cmdmove);
                //cmdmove[2] = 0;
                move.clear()
                area2num = 0
                i = 0
                while i < 20 {
                    _ = AAS_PredictClientMovement(move, -1, areastart, PRESENCE_NORMAL, 0, velocity, cmdmove, 0, 30, 0.1, SE_HITGROUND | SE_ENTERWATER | SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE | SE_TOUCHJUMPPAD | SE_TOUCHTELEPORTER, 0, bot_visualizejumppads)
                    area2num = move.endarea
                    link = areas
                    while link != nil {
                        if AAS_AreaJumpPad(link!.areanum) == 0 {
                            link = link!.next_area
                            continue
                        }
                        if link!.areanum == area2num { break }
                        link = link!.next_area
                    } //end if
                    if link == nil { break }
                    areastart = move.endpos
                    velocity = move.velocity
                    i += 1
                } //end for
                if area2num != 0 && i < 20 {
                    link = areas
                    while link != nil {
                        if AAS_AreaJumpPad(link!.areanum) == 0 {
                            link = link!.next_area
                            continue
                        }
                        if AAS_ReachabilityExists(link!.areanum, area2num) {
                            link = link!.next_area
                            continue
                        }
                        //create a rocket or bfg jump reachability from area1 to area2
                        lreach = AAS_AllocReachability()
                        if lreach == nil {
                            AAS_UnlinkFromAreas(areas)
                            return
                        } //end if
                        lreach!.areanum = area2num
                        //NOTE: the facenum is the Z velocity
                        lreach!.facenum = Int32(velocity[2])
                        //NOTE: the edgenum is the horizontal velocity
                        lreach!.edgenum = Int32(sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1]))
                        lreach!.start = areastart
                        lreach!.end = move.endpos
                        lreach!.traveltype = TRAVEL_JUMPPAD
                        lreach!.traveltype |= AAS_TravelFlagsForTeam(ent)
                        lreach!.traveltime = Int32(aassettings.rs_jumppad)
                        lreach!.next = areareachability![link!.areanum]
                        areareachability![link!.areanum] = lreach
                        //
                        reach_jumppad += 1
                        link = link!.next_area
                    } //end for
                } //end if
            } //end if
            //
            if abs(velocity[0]) > 100 || abs(velocity[1]) > 100 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            //check for areas we can reach with air control
            area2num = 1
            while area2num < aasworld.numareas {
                visualize = 0
                /*
                if (area2num == 3568)
                {
                    for (link = areas; link; link = link->next_area)
                    {
                        if (link->areanum == 3380)
                        {
                            visualize = qtrue;
                            botimport.Print(PRT_MESSAGE, "bah\n");
                        } //end if
                    } //end for
                } //end if*/
                //never try to go back to one of the original jumppad areas
                //and don't create reachabilities if they already exist
                link = areas
                while link != nil {
                    if AAS_ReachabilityExists(link!.areanum, area2num) { break }
                    if AAS_AreaJumpPad(link!.areanum) != 0 {
                        if link!.areanum == area2num { break }
                    } //end if
                    link = link!.next_area
                } //end if
                if link != nil {
                    area2num += 1
                    continue
                }
                //
                area2 = aasworld.areasSlots[area2num]
                i = 0
                while i < area2.numfaces {
                    face2num = aasworld.faceindex![area2.firstface + i]
                    face2 = aasworld.facesSlots[abs(face2num)]
                    //if it is not a ground face
                    if (face2.faceflags & FACE_GROUND) == 0 {
                        i += 1
                        continue
                    }
                    //get the center of the face
                    AAS_FaceCenter(face2num, &facecenter)
                    //only go higher up
                    if facecenter[2] < areastart[2] {
                        i += 1
                        continue
                    }
                    //get the jumppad jump z velocity
                    zvel = velocity[2]
                    //get the horizontal speed for the jump, if it isn't possible to calculate this
                    //speed
                    ret = AAS_HorizontalVelocityForJump(zvel, areastart, facecenter, &speed)
                    if ret != 0 && speed < 150 {
                        //direction towards the face center
                        dir = facecenter - areastart
                        dir[2] = 0
                        hordist = VectorNormalize(&dir)
                        //if (hordist < 1.6 * facecenter[2] - areastart[2])
                        do {
                            //get command movement
                            cmdmove = dir * speed
                            //
                            _ = AAS_PredictClientMovement(move, -1, areastart, PRESENCE_NORMAL, 0, velocity, cmdmove, 30, 30, 0.1, SE_ENTERWATER | SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE | SE_TOUCHJUMPPAD | SE_TOUCHTELEPORTER | SE_HITGROUNDAREA, area2num, visualize)
                            //if prediction time wasn't enough to fully predict the movement
                            //don't enter slime or lava and don't fall from too high
                            if move.frames < 30 &&
                                (move.stopevent & (SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE)) == 0
                                && (move.stopevent & (SE_HITGROUNDAREA | SE_TOUCHJUMPPAD | SE_TOUCHTELEPORTER)) != 0 {
                                //never go back to the same jumppad
                                link = areas
                                while link != nil {
                                    if link!.areanum == move.endarea { break }
                                    link = link!.next_area
                                }
                                if link == nil {
                                    link = areas
                                    while link != nil {
                                        if AAS_AreaJumpPad(link!.areanum) == 0 {
                                            link = link!.next_area
                                            continue
                                        }
                                        if AAS_ReachabilityExists(link!.areanum, area2num) {
                                            link = link!.next_area
                                            continue
                                        }
                                        //create a jumppad reachability from area1 to area2
                                        lreach = AAS_AllocReachability()
                                        if lreach == nil {
                                            AAS_UnlinkFromAreas(areas)
                                            return
                                        } //end if
                                        lreach!.areanum = move.endarea
                                        //NOTE: the facenum is the Z velocity
                                        lreach!.facenum = Int32(velocity[2])
                                        //NOTE: the edgenum is the horizontal velocity
                                        lreach!.edgenum = Int32(sqrt(cmdmove[0] * cmdmove[0] + cmdmove[1] * cmdmove[1]))
                                        lreach!.start = areastart
                                        lreach!.end = facecenter
                                        lreach!.traveltype = TRAVEL_JUMPPAD
                                        lreach!.traveltype |= AAS_TravelFlagsForTeam(ent)
                                        lreach!.traveltime = Int32(aassettings.rs_aircontrolledjumppad)
                                        lreach!.next = areareachability![link!.areanum]
                                        areareachability![link!.areanum] = lreach
                                        //
                                        reach_jumppad += 1
                                        link = link!.next_area
                                    } //end for
                                }
                            } //end if
                        } //end if
                    } //end for
                    i += 1
                } //end for
                area2num += 1
            } //end for
            AAS_UnlinkFromAreas(areas)
            ent = AAS_NextBSPEntity(ent)
        } //end for
    }
}

//===========================================================================
// never point at ground faces
// always a higher and pretty far area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3776
func AAS_Reachability_Grapple(_ area1num: Int32, _ area2num: Int32) -> Int32 {
    return BspTrace.scratch { bsptrace -> Int32 in
        return AasTrace.scratch { trace -> Int32 in
            // AI: Raven declares `int areas[20]` on his stack.
            // The body uses the zeroed allocation of the storage class through the `areas_AAS_Reachability_Grapple` forward.
            var face2num: Int32, i: Int32, j: Int32, areanum: Int32, numareas: Int32
            var mingrappleangle: Float, z: Float, hordist: Float
            var face2: AasFace
            var area1: AasArea, area2: AasArea
            var lreach: AasLreachability?
            var areastart = vec3_t(), facecenter = vec3_t(), start = vec3_t(), end = vec3_t(), dir = vec3_t()
            let down = vec3_t(0, 0, -1)
            var v = vec3_t()

            //only grapple when on the ground or swimming
            if AAS_AreaGrounded(area1num) == 0 && AAS_AreaSwim(area1num) == 0 { return 0 }
            //don't grapple from a crouch area
            if (AAS_AreaPresenceType(area1num) & PRESENCE_NORMAL) == 0 { return 0 }
            //NOTE: disabled area swim it doesn't work right
            if AAS_AreaSwim(area1num) != 0 { return 0 }
            //
            area1 = aasworld.areasSlots[area1num]
            area2 = aasworld.areasSlots[area2num]
            //don't grapple towards way lower areas
            if area2.maxs[2] < area1.mins[2] { return 0 }
            //
            start = aasworld.areasSlots[area1num].center
            //if not a swim area
            if AAS_AreaSwim(area1num) == 0 {
                if AAS_PointAreaNum(start) == 0 {
                    Log_Write("area %d center %f %f %f in solid?\r\n", area1num, start[0], start[1], start[2])
                }
                end = start
                end[2] -= 1000
                trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, -1))
                if trace.startsolid { return 0 }
                areastart = trace.endpos
            } //end if
            else {
                if (AAS_PointContents(start) & (CONTENTS_LAVA | CONTENTS_SLIME | CONTENTS_WATER)) == 0 { return 0 }
            } //end else
            //
            //start is now the start point
            //
            i = 0
            while i < area2.numfaces {
                face2num = aasworld.faceindex![area2.firstface + i]
                face2 = aasworld.facesSlots[abs(face2num)]
                //if it is not a solid face
                if (face2.faceflags & FACE_SOLID) == 0 {
                    i += 1
                    continue
                }
                //direction towards the first vertex of the face
                v = aasworld.vertexes![aasworld.edgesSlots[abs(aasworld.edgeindex![face2.firstedge])].v[0]]
                dir = v - areastart
                //if the face plane is facing away
                if _DotProduct(aasworld.planesSlots[face2.planenum].normal, dir) > 0 {
                    i += 1
                    continue
                }
                //get the center of the face
                AAS_FaceCenter(face2num, &facecenter)
                //only go higher up with the grapple
                if facecenter[2] < areastart[2] + 64 {
                    i += 1
                    continue
                }
                //only use vertical faces or downward facing faces
                if _DotProduct(aasworld.planesSlots[face2.planenum].normal, down) < 0 {
                    i += 1
                    continue
                }
                //direction towards the face center
                dir = facecenter - areastart
                //
                z = dir[2]
                dir[2] = 0
                hordist = VectorLength(dir)
                if hordist == 0 {
                    i += 1
                    continue
                }
                //if too far
                if hordist > 2000 {
                    i += 1
                    continue
                }
                //check the minimal angle of the movement
                mingrappleangle = 15 //15 degrees
                if z / hordist < tan(2 * M_PI * mingrappleangle / 360) {
                    i += 1
                    continue
                }
                //
                start = facecenter
                _VectorMA(facecenter, -500, aasworld.planesSlots[face2.planenum].normal, &end)
                //
                bsptrace.copy(from: AAS_Trace(start, nil, nil, end, 0, CONTENTS_SOLID))
                //the grapple won't stick to the sky and the grapple point should be near the AAS wall
                if (bsptrace.surface.flags & SURF_SKY) != 0 || (bsptrace.fraction * 500 > 32) {
                    i += 1
                    continue
                }
                //trace a full bounding box from the area center on the ground to
                //the center of the face
                dir = facecenter - areastart
                VectorNormalize(&dir)
                _VectorMA(areastart, 4, dir, &start)
                end = bsptrace.endpos
                trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, -1))
                dir = trace.endpos - facecenter
                if VectorLength(dir) > 24 {
                    i += 1
                    continue
                }
                //
                start = trace.endpos
                end = trace.endpos
                end[2] -= AAS_FallDamageDistance()
                trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, -1))
                if trace.fraction >= 1 {
                    i += 1
                    continue
                }
                //area to end in
                areanum = AAS_PointAreaNum(trace.endpos)
                //if not in lava or slime
                if (aasworld.areasettingsSlots[areanum].contents & (AREACONTENTS_SLIME | AREACONTENTS_LAVA)) != 0 {
                    i += 1
                    continue
                } //end if
                //do not go the the source area
                if areanum == area1num {
                    i += 1
                    continue
                }
                //don't create reachabilities if they already exist
                if AAS_ReachabilityExists(area1num, areanum) {
                    i += 1
                    continue
                }
                //only end in areas we can stand
                if AAS_AreaGrounded(areanum) == 0 {
                    i += 1
                    continue
                }
                //never go through cluster portals!!
                numareas = AAS_TraceAreas(areastart, bsptrace.endpos, areas_AAS_Reachability_Grapple, nil, 20)
                if numareas >= 20 {
                    i += 1
                    continue
                }
                j = 0
                while j < numareas {
                    if (aasworld.areasettingsSlots[areas_AAS_Reachability_Grapple[j]].contents & AREACONTENTS_CLUSTERPORTAL) != 0 { break }
                    j += 1
                } //end for
                if j < numareas {
                    i += 1
                    continue
                }
                //create a new reachability link
                lreach = AAS_AllocReachability()
                if lreach == nil { return 0 }
                lreach!.areanum = areanum
                lreach!.facenum = face2num
                lreach!.edgenum = 0
                lreach!.start = areastart
                //VectorCopy(facecenter, lreach->end);
                lreach!.end = bsptrace.endpos
                lreach!.traveltype = TRAVEL_GRAPPLEHOOK
                dir = lreach!.end - lreach!.start
                lreach!.traveltime = Int32(Double(aassettings.rs_startgrapple) + Double(VectorLength(dir)) * 0.25)
                lreach!.next = areareachability![area1num]
                areareachability![area1num] = lreach
                //
                reach_grapple += 1
                i += 1
            } //end for
            //
            return 0
        }
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3917
func AAS_SetWeaponJumpAreaFlags() {
    var ent: Int32, i: Int32
    let mins = vec3_t(-15, -15, -15), maxs = vec3_t(15, 15, 15)
    var origin = vec3_t()
    var areanum: Int32, weaponjumpareas: Int32, spawnflags: Int32
    var classname = CharBuf(MAX_EPAIRKEY)

    weaponjumpareas = 0
    ent = AAS_NextBSPEntity(0)
    while ent != 0 {
        if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
            ent = AAS_NextBSPEntity(ent)
            continue
        }
        if strcmp(classname, "item_armor_body") == 0 ||
            strcmp(classname, "item_health") == 0 ||
            strcmp(classname, "weapon_disruptor") == 0 ||
            strcmp(classname, "weapon_repeater") == 0 ||
            strcmp(classname, "weapon_demp2") == 0 ||
            strcmp(classname, "weapon_flechette") == 0 ||
            strcmp(classname, "weapon_rocket_launcher") == 0 {
            if AAS_VectorForBSPEpairKey(ent, "origin", &origin) != 0 {
                spawnflags = 0
                _ = AAS_IntForBSPEpairKey(ent, "spawnflags", &spawnflags)
                //if not a stationary item
                if (spawnflags & 1) == 0 {
                    if AAS_DropToFloor(&origin, mins, maxs) == 0 {
                        botimport.runPrint(PRT_MESSAGE, "%s in solid at (%1.1f %1.1f %1.1f)\n", String(classname), origin[0], origin[1], origin[2])
                    } //end if
                } //end if
                //areanum = AAS_PointAreaNum(origin);
                areanum = AAS_BestReachableArea(origin, mins, maxs, &origin)
                //the bot may rocket jump towards this area
                aasworld.areasettingsSlots[areanum].areaflags |= AREA_WEAPONJUMP
                //
                //if (!AAS_AreaGrounded(areanum))
                //	botimport.Print(PRT_MESSAGE, "area not grounded\n");
                //
                weaponjumpareas += 1
            } //end if
        } //end if
        ent = AAS_NextBSPEntity(ent)
    } //end for
    i = 1
    while i < aasworld.numareas {
        if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_JUMPPAD) != 0 {
            aasworld.areasettingsSlots[i].areaflags |= AREA_WEAPONJUMP
            weaponjumpareas += 1
        } //end if
        i += 1
    } //end for
    botimport.runPrint(PRT_MESSAGE, "%d weapon jump areas\n", weaponjumpareas)
}

//===========================================================================
// create a possible weapon jump reachability from area1 to area2
//
// check if there's a cool item in the second area
// check if area1 is lower than area2
// check if the bot can rocketjump from area1 to area2
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:3984
func AAS_Reachability_WeaponJump(_ area1num: Int32, _ area2num: Int32) -> Int32 {
    return AasTrace.scratch { trace -> Int32 in
        return AasClientmove.scratch { move -> Int32 in
            var face2num: Int32, i: Int32, n: Int32, ret: Int32, visualize: Int32
            var speed: Float = 0, zvel: Float, hordist: Float
            var face2: AasFace
            var area1: AasArea, area2: AasArea
            var lreach: AasLreachability?
            var areastart = vec3_t(), facecenter = vec3_t(), start = vec3_t(), end = vec3_t(), dir = vec3_t(), cmdmove = vec3_t()// teststart;
            var velocity = vec3_t()

            visualize = 0
    //	if (area1num == 4436 && area2num == 4318)
    //	{
    //		visualize = qtrue;
    //	}
            if AAS_AreaGrounded(area1num) == 0 || AAS_AreaSwim(area1num) != 0 { return 0 }
            if AAS_AreaGrounded(area2num) == 0 { return 0 }
            //NOTE: only weapon jump towards areas with an interesting item in it??
            if (aasworld.areasettingsSlots[area2num].areaflags & AREA_WEAPONJUMP) == 0 { return 0 }
            //
            area1 = aasworld.areasSlots[area1num]
            area2 = aasworld.areasSlots[area2num]
            //don't weapon jump towards way lower areas
            if area2.maxs[2] < area1.mins[2] { return 0 }
            //
            start = aasworld.areasSlots[area1num].center
            //if not a swim area
            if AAS_PointAreaNum(start) == 0 {
                Log_Write("area %d center %f %f %f in solid?\r\n", area1num, start[0], start[1], start[2])
            }
            end = start
            end[2] -= 1000
            trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, -1))
            if trace.startsolid { return 0 }
            areastart = trace.endpos
            //
            //areastart is now the start point
            //
            i = 0
            while i < area2.numfaces {
                face2num = aasworld.faceindex![area2.firstface + i]
                face2 = aasworld.facesSlots[abs(face2num)]
                //if it is not a solid face
                if (face2.faceflags & FACE_GROUND) == 0 {
                    i += 1
                    continue
                }
                //get the center of the face
                AAS_FaceCenter(face2num, &facecenter)
                //only go higher up with weapon jumps
                if facecenter[2] < areastart[2] + 64 {
                    i += 1
                    continue
                }
                //NOTE: set to 2 to allow bfg jump reachabilities
                n = 0
                while n < 1/*2*/ {
                    //get the rocket jump z velocity
                    if n != 0 {
                        zvel = AAS_BFGJumpZVelocity(areastart)
                    } else {
                        zvel = AAS_RocketJumpZVelocity(areastart)
                    }
                    //get the horizontal speed for the jump, if it isn't possible to calculate this
                    //speed (the jump is not possible) then there's no jump reachability created
                    ret = AAS_HorizontalVelocityForJump(zvel, areastart, facecenter, &speed)
                    if ret != 0 && speed < 300 {
                        //direction towards the face center
                        dir = facecenter - areastart
                        dir[2] = 0
                        hordist = VectorNormalize(&dir)
                        //if (hordist < 1.6 * (facecenter[2] - areastart[2]))
                        do {
                            //get command movement
                            cmdmove = dir * speed
                            velocity = vec3_t(0, 0, zvel)
                            /*
                            //get command movement
                            VectorScale(dir, speed, velocity);
                            velocity[2] = zvel;
                            VectorSet(cmdmove, 0, 0, 0);
                            */
                            //
                            _ = AAS_PredictClientMovement(move, -1, areastart, PRESENCE_NORMAL, 1, velocity, cmdmove, 30, 30, 0.1, SE_ENTERWATER | SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE | SE_TOUCHJUMPPAD | SE_HITGROUND | SE_HITGROUNDAREA, area2num, visualize)
                            //if prediction time wasn't enough to fully predict the movement
                            //don't enter slime or lava and don't fall from too high
                            if move.frames < 30 &&
                                (move.stopevent & (SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE)) == 0
                                && (move.stopevent & (SE_HITGROUNDAREA | SE_TOUCHJUMPPAD)) != 0 {
                                //create a rocket or bfg jump reachability from area1 to area2
                                lreach = AAS_AllocReachability()
                                if lreach == nil { return 0 }
                                lreach!.areanum = area2num
                                lreach!.facenum = 0
                                lreach!.edgenum = 0
                                lreach!.start = areastart
                                lreach!.end = facecenter
                                if n != 0 {
                                    lreach!.traveltype = TRAVEL_BFGJUMP
                                    lreach!.traveltime = Int32(aassettings.rs_bfgjump)
                                } //end if
                                else {
                                    lreach!.traveltype = TRAVEL_ROCKETJUMP
                                    lreach!.traveltime = Int32(aassettings.rs_rocketjump)
                                } //end else
                                lreach!.next = areareachability![area1num]
                                areareachability![area1num] = lreach
                                //
                                reach_rocketjump += 1
                                return 1
                            } //end if
                        } //end if
                    } //end if
                    n += 1
                } //end for
                i += 1
            } //end for
            //
            return 0
        }
    }
}

//===========================================================================
// calculates additional walk off ledge reachabilities for the given area
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:4109
func AAS_Reachability_WalkOffLedge(_ areanum: Int32) {
    AasTrace.scratch { trace -> Void in
        // AI: Raven declares `int areas[10]` on his stack.
        // The body uses the zeroed allocation of the storage class through the `areas_AAS_Reachability_WalkOffLedge` forward.
        var i: Int32, j: Int32, k: Int32, l: Int32, m: Int32, n: Int32, p: Int32, numareas: Int32
        var face1num: Int32, face2num: Int32, face3num: Int32, edge1num: Int32, edge2num: Int32, edge3num: Int32
        var otherareanum: Int32, gap: Int32, reachareanum: Int32, side: Int32
        var area: AasArea, area2: AasArea
        var face1: AasFace, face2: AasFace, face3: AasFace
        var edge: AasEdge
        var plane: AasPlane
        var v1 = vec3_t(), v2 = vec3_t()
        var sharededgevec = vec3_t(), mid = vec3_t(), dir = vec3_t(), testend = vec3_t()
        var lreach: AasLreachability?

        if AAS_AreaGrounded(areanum) == 0 || AAS_AreaSwim(areanum) != 0 { return }
        //
        area = aasworld.areasSlots[areanum]
        //
        i = 0
        while i < area.numfaces {
            face1num = aasworld.faceindex![area.firstface + i]
            face1 = aasworld.facesSlots[abs(face1num)]
            //face 1 must be a ground face
            if (face1.faceflags & FACE_GROUND) == 0 {
                i += 1
                continue
            }
            //go through all the edges of this ground face
            k = 0
            while k < face1.numedges {
                edge1num = aasworld.edgeindex![face1.firstedge + k]
                //find another not ground face using this same edge
                j = 0
                while j < area.numfaces {
                    face2num = aasworld.faceindex![area.firstface + j]
                    face2 = aasworld.facesSlots[abs(face2num)]
                    //face 2 may not be a ground face
                    if (face2.faceflags & FACE_GROUND) != 0 {
                        j += 1
                        continue
                    }
                    //compare all the edges
                    l = 0
                    while l < face2.numedges {
                        edge2num = aasworld.edgeindex![face2.firstedge + l]
                        if abs(edge1num) == abs(edge2num) {
                            //get the area at the other side of the face
                            if face2.frontarea == areanum {
                                otherareanum = face2.backarea
                            } else {
                                otherareanum = face2.frontarea
                            }
                            //
                            area2 = aasworld.areasSlots[otherareanum]
                            //if the other area is grounded!
                            if (aasworld.areasettingsSlots[otherareanum].areaflags & AREA_GROUNDED) != 0 {
                                //check for a possible gap
                                gap = 0
                                n = 0
                                while n < area2.numfaces {
                                    face3num = aasworld.faceindex![area2.firstface + n]
                                    //may not be the shared face of the two areas
                                    if abs(face3num) == abs(face2num) {
                                        n += 1
                                        continue
                                    }
                                    //
                                    face3 = aasworld.facesSlots[abs(face3num)]
                                    //find an edge shared by all three faces
                                    m = 0
                                    while m < face3.numedges {
                                        edge3num = aasworld.edgeindex![face3.firstedge + m]
                                        //but the edge should be shared by all three faces
                                        if abs(edge3num) == abs(edge1num) {
                                            if (face3.faceflags & FACE_SOLID) == 0 {
                                                gap = 1
                                                break
                                            } //end if
                                            //
                                            if (face3.faceflags & FACE_GROUND) != 0 {
                                                gap = 0
                                                break
                                            } //end if
                                            //FIXME: there are more situations to be handled
                                            gap = 1
                                            break
                                        } //end if
                                        m += 1
                                    } //end for
                                    if m < face3.numedges { break }
                                    n += 1
                                } //end for
                                if gap == 0 { break }
                            } //end if
                            //check for a walk off ledge reachability
                            edge = aasworld.edgesSlots[abs(edge1num)]
                            side = edge1num < 0 ? 1 : 0
                            //
                            v1 = aasworld.vertexes![edge.v[side]]
                            v2 = aasworld.vertexes![edge.v[side == 0 ? 1 : 0]]
                            //
                            plane = aasworld.planesSlots[face1.planenum]
                            //get the points really into the areas
                            sharededgevec = v2 - v1
                            CrossProduct(plane.normal, sharededgevec, &dir)
                            VectorNormalize(&dir)
                            //
                            mid = v1 + v2
                            mid = mid * 0.5
                            _VectorMA(mid, 8, dir, &mid)
                            //
                            testend = mid
                            testend[2] -= 1000
                            trace.copy(from: AAS_TraceClientBBox(mid, testend, PRESENCE_CROUCH, -1))
                            //
                            if trace.startsolid {
                                //Log_Write("area %d: trace.startsolid\r\n", areanum);
                                break
                            } //end if
                            reachareanum = AAS_PointAreaNum(trace.endpos)
                            if reachareanum == areanum {
                                //Log_Write("area %d: same area\r\n", areanum);
                                break
                            } //end if
                            if AAS_ReachabilityExists(areanum, reachareanum) {
                                //Log_Write("area %d: reachability already exists\r\n", areanum);
                                break
                            } //end if
                            if AAS_AreaGrounded(reachareanum) == 0 && AAS_AreaSwim(reachareanum) == 0 {
                                //Log_Write("area %d, reach area %d: not grounded and not swim\r\n", areanum, reachareanum);
                                break
                            } //end if
                            //
                            if (aasworld.areasettingsSlots[reachareanum].contents & (AREACONTENTS_SLIME | AREACONTENTS_LAVA)) != 0 {
                                //Log_Write("area %d, reach area %d: lava or slime\r\n", areanum, reachareanum);
                                break
                            } //end if
                            //if not going through a cluster portal
                            numareas = AAS_TraceAreas(mid, testend, areas_AAS_Reachability_WalkOffLedge, nil, Int32(areas_AAS_Reachability_WalkOffLedge.count))
                            p = 0
                            while p < numareas {
                                if AAS_AreaClusterPortal(areas_AAS_Reachability_WalkOffLedge[p]) != 0 {
                                    break
                                }
                                p += 1
                            }
                            if p < numareas {
                                break
                            }
                            // if a maximum fall height is set and the bot would fall down further
                            if aassettings.rs_maxfallheight != 0 && abs(mid[2] - trace.endpos[2]) > aassettings.rs_maxfallheight {
                                break
                            }
                            //
                            lreach = AAS_AllocReachability()
                            if lreach == nil { break }
                            lreach!.areanum = reachareanum
                            lreach!.facenum = 0
                            lreach!.edgenum = edge1num
                            lreach!.start = mid
                            lreach!.end = trace.endpos
                            lreach!.traveltype = TRAVEL_WALKOFFLEDGE
                            lreach!.traveltime = Int32(aassettings.rs_startwalkoffledge + abs(mid[2] - trace.endpos[2]) * 50 / aassettings.phys_gravity)
                            if AAS_AreaSwim(reachareanum) == 0 && AAS_AreaJumpPad(reachareanum) == 0 {
                                if AAS_FallDelta(mid[2] - trace.endpos[2]) > aassettings.phys_falldelta5 {
                                    lreach!.traveltime = Int32(lreach!.traveltime + aassettings.rs_falldamage5)
                                } //end if
                                else if AAS_FallDelta(mid[2] - trace.endpos[2]) > aassettings.phys_falldelta10 {
                                    lreach!.traveltime = Int32(lreach!.traveltime + aassettings.rs_falldamage10)
                                } //end if
                            } //end if
                            lreach!.next = areareachability![areanum]
                            areareachability![areanum] = lreach
                            //we've got another walk off ledge reachability
                            reach_walkoffledge += 1
                        } //end if
                        l += 1
                    } //end for
                    j += 1
                } //end for
                k += 1
            } //end for
            i += 1
        } //end for
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:4290
func AAS_StoreReachability() {
    var i: Int32
    var areasettings: AasAreasettings
    var lreach: AasLreachability?
    var reach: AasReachability

    if aasworld.reachability != nil { FreeMemory(aasworld.reachability?.handle) }
    aasworld.reachability = AasReachability(GetClearedMemory((numlreachabilities + 10) * Int32(AasReachability.byteCount)))
    aasworld.reachabilitysize = 1
    i = 0
    while i < aasworld.numareas {
        areasettings = aasworld.areasettingsSlots[i]
        areasettings.firstreachablearea = aasworld.reachabilitysize
        areasettings.numreachableareas = 0
        lreach = areareachability![i]
        while lreach != nil {
            reach = aasworld.reachabilitySlots[areasettings.firstreachablearea + areasettings.numreachableareas]
            reach.areanum = lreach!.areanum
            reach.facenum = lreach!.facenum
            reach.edgenum = lreach!.edgenum
            reach.start = lreach!.start
            reach.end = lreach!.end
            reach.traveltype = lreach!.traveltype
            reach.traveltime = lreach!.traveltime
            //
            areasettings.numreachableareas += 1
            lreach = lreach!.next
        } //end for
        aasworld.reachabilitysize += areasettings.numreachableareas
        i += 1
    } //end for
}

//===========================================================================
//
// TRAVEL_WALK					100%	equal floor height + steps
// TRAVEL_CROUCH				100%
// TRAVEL_BARRIERJUMP			100%
// TRAVEL_JUMP					 80%
// TRAVEL_LADDER				100%	+ fall down from ladder + jump up to ladder
// TRAVEL_WALKOFFLEDGE			 90%	walk off very steep walls?
// TRAVEL_SWIM					100%
// TRAVEL_WATERJUMP				100%
// TRAVEL_TELEPORT				100%
// TRAVEL_ELEVATOR				100%
// TRAVEL_GRAPPLEHOOK			100%
// TRAVEL_DOUBLEJUMP			  0%
// TRAVEL_RAMPJUMP				  0%
// TRAVEL_STRAFEJUMP			  0%
// TRAVEL_ROCKETJUMP			100%	(currently limited towards areas with items)
// TRAVEL_BFGJUMP				  0%	(currently disabled)
// TRAVEL_JUMPPAD				100%
// TRAVEL_FUNCBOB				100%
//
// Parameter:			-
// Returns:				true if NOT finished
// Changes Globals:		-
//===========================================================================
/// Raven's `static float framereachability` of `AAS_ContinueInitReachability`, a property of `EngineWorld`.
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:4350
var framereachability: Float {
    get { world.framereachability }
    set { world.framereachability = newValue }
}

/// Raven's `static float reachability_delay` of `AAS_ContinueInitReachability`, a property of `EngineWorld`.
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:4350
var reachability_delay: Float {
    get { world.reachability_delay }
    set { world.reachability_delay = newValue }
}

/// Raven's `static int lastpercentage` of `AAS_ContinueInitReachability`, a property of `EngineWorld`.
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:4351
var lastpercentage: Int32 {
    get { world.lastpercentage }
    set { world.lastpercentage = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_reach.cpp:4347
func AAS_ContinueInitReachability(_ time: Float) -> Int32 {
    var i: Int32, j: Int32, todo: Int32
    let start_time: Int32

    if aasworld.loaded == 0 { return 0 }
    //if reachability is calculated for all areas
    if aasworld.numreachabilityareas >= aasworld.numareas + 2 { return 0 }
    //if starting with area 1 (area 0 is a dummy)
    if aasworld.numreachabilityareas == 1 {
        botimport.runPrint(PRT_MESSAGE, "calculating reachability...\n")
        lastpercentage = 0
        framereachability = 2000
        reachability_delay = 1000
    } //end if
    //number of areas to calculate reachability for this cycle
    todo = aasworld.numreachabilityareas + Int32(framereachability)
    start_time = Sys_MilliSeconds()
    //loop over the areas
    i = aasworld.numreachabilityareas
    while i < aasworld.numareas && i < todo {
        aasworld.numreachabilityareas += 1
        //only create jumppad reachabilities from jumppad areas
        if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_JUMPPAD) != 0 {
            i += 1
            continue
        } //end if
        //loop over the areas
        j = 1
        while j < aasworld.numareas {
            if i == j {
                j += 1
                continue
            }
            //never create reachabilities from teleporter or jumppad areas to regular areas
            if (aasworld.areasettingsSlots[i].contents & (AREACONTENTS_TELEPORTER | AREACONTENTS_JUMPPAD)) != 0 {
                if (aasworld.areasettingsSlots[j].contents & (AREACONTENTS_TELEPORTER | AREACONTENTS_JUMPPAD)) == 0 {
                    j += 1
                    continue
                } //end if
            } //end if
            //if there already is a reachability link from area i to j
            if AAS_ReachabilityExists(i, j) {
                j += 1
                continue
            }
            //check for a swim reachability
            if AAS_Reachability_Swim(i, j) != 0 {
                j += 1
                continue
            }
            //check for a simple walk on equal floor height reachability
            if AAS_Reachability_EqualFloorHeight(i, j) != 0 {
                j += 1
                continue
            }
            //check for step, barrier, waterjump and walk off ledge reachabilities
            if AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge(i, j) != 0 {
                j += 1
                continue
            }
            //check for ladder reachabilities
            if AAS_Reachability_Ladder(i, j) != 0 {
                j += 1
                continue
            }
            //check for a jump reachability
            if AAS_Reachability_Jump(i, j) != 0 {
                j += 1
                continue
            }
            j += 1
        } //end for
        //never create these reachabilities from teleporter or jumppad areas
        if (aasworld.areasettingsSlots[i].contents & (AREACONTENTS_TELEPORTER | AREACONTENTS_JUMPPAD)) != 0 {
            i += 1
            continue
        } //end if
        //loop over the areas
        j = 1
        while j < aasworld.numareas {
            if i == j {
                j += 1
                continue
            }
            //
            if AAS_ReachabilityExists(i, j) {
                j += 1
                continue
            }
            //check for a grapple hook reachability
            if calcgrapplereach != 0 { _ = AAS_Reachability_Grapple(i, j) }
            //check for a weapon jump reachability
            _ = AAS_Reachability_WeaponJump(i, j)
            j += 1
        } //end for
        //if the calculation took more time than the max reachability delay
        if Sys_MilliSeconds() - start_time > Int32(reachability_delay) { break }
        //
        if aasworld.numreachabilityareas * 1000 / aasworld.numareas > lastpercentage { break }
        i += 1
    } //end for
    //
    if aasworld.numreachabilityareas == aasworld.numareas {
        botimport.runPrint(PRT_MESSAGE, "\r%6.1f%%", Float(100.0))
        botimport.runPrint(PRT_MESSAGE, "\nplease wait while storing reachability...\n")
        aasworld.numreachabilityareas += 1
    } //end if
    //if this is the last step in the reachability calculations
    else if aasworld.numreachabilityareas == aasworld.numareas + 1 {
        //create additional walk off ledge reachabilities for every area
        i = 1
        while i < aasworld.numareas {
            //only create jumppad reachabilities from jumppad areas
            if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_JUMPPAD) != 0 {
                i += 1
                continue
            } //end if
            AAS_Reachability_WalkOffLedge(i)
            i += 1
        } //end for
        //create jump pad reachabilities
        AAS_Reachability_JumpPad()
        //create teleporter reachabilities
        AAS_Reachability_Teleport()
        //create elevator (func_plat) reachabilities
        AAS_Reachability_Elevator()
        //create func_bobbing reachabilities
        AAS_Reachability_FuncBobbing()
        //
        //*/
        //store all the reachabilities
        AAS_StoreReachability()
        //free the reachability link heap
        AAS_ShutDownReachabilityHeap()
        //
        FreeMemory(OpaquePointer(areareachability!.base))
        //
        aasworld.numreachabilityareas += 1
        //
        botimport.runPrint(PRT_MESSAGE, "calculating clusters...\n")
    } //end if
    else {
        lastpercentage = aasworld.numreachabilityareas * 1000 / aasworld.numareas
        botimport.runPrint(PRT_MESSAGE, "\r%6.1f%%", Float(lastpercentage) / 10)
    } //end else
    //not yet finished
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_reach.cpp:4494
func AAS_InitReachability() {
    if aasworld.loaded == 0 { return }

    if aasworld.reachabilitysize != 0 {
        if Int32(LibVarGetValue("forcereachability")) == 0 {
            aasworld.numreachabilityareas = aasworld.numareas + 2
            return
        } //end if
    } //end if
    calcgrapplereach = Int32(LibVarGetValue("grapplereach"))
    aasworld.savefile = 1
    //start with area 1 because area zero is a dummy
    aasworld.numreachabilityareas = 1
    ////aasworld.numreachabilityareas = aasworld.numareas + 1;		//only calculate entity reachabilities
    //setup the heap with reachability links
    AAS_SetupReachabilityHeap()
    //allocate area reachability link array
    // `UInt.byteCount` is the size of one record pointer.
    areareachability = Slots(pointers: GetClearedMemory(aasworld.numareas * Int32(UInt.byteCount)), count: Int(aasworld.numareas))
    //
    AAS_SetWeaponJumpAreaFlags()
}
