import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_routealt.cpp:39
public var midrangeareas: Slots<Midrangearea>? {
    get { world.variables.midrangeareas }
    set { world.variables.midrangeareas = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_routealt.cpp:40
public var clusterareas: Slots<Int32>? {
    get { world.variables.clusterareas }
    set { world.variables.clusterareas = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_routealt.cpp:41
public var numclusterareas: Int32 {
    get { world.variables.numclusterareas }
    set { world.variables.numclusterareas = newValue }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_routealt.cpp:49
public func AAS_AltRoutingFloodCluster_r(_ areanum: Int32) {
    var i: Int32
    var otherareanum: Int32
    var area: AasArea
    var face: AasFace

    //add the current area to the areas of the current cluster
    clusterareas![numclusterareas] = areanum
    numclusterareas += 1
    //remove the area from the mid range areas
    midrangeareas![areanum].valid = 0
    //flood to other areas through the faces of this area
    area = aasworld.areasSlots[areanum]
    i = 0
    while i < area.numfaces {
        face = aasworld.facesSlots[abs(aasworld.faceindex![area.firstface + i])]
        //get the area at the other side of the face
        if face.frontarea == areanum {
            otherareanum = face.backarea
        } else {
            otherareanum = face.frontarea
        }
        //if there is an area at the other side of this face
        if otherareanum == 0 {
            i += 1
            continue
        }
        //if the other area is not a midrange area
        if midrangeareas![otherareanum].valid == 0 {
            i += 1
            continue
        }
        //
        AAS_AltRoutingFloodCluster_r(otherareanum)
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_routealt.cpp:82
public func AAS_AlternativeRouteGoals(_ start: JKAShared.vec3_t, _ startareanum: Int32, _ goal: JKAShared.vec3_t, _ goalareanum: Int32, _ travelflags: Int32, _ altroutegoals: Slots<AasAltroutegoal>, _ maxaltroutegoals: Int32, _ type: Int32) -> Int32 {
    var i: Int32
    var j: Int32
    var bestareanum: Int32
    var numaltroutegoals: Int32
    var nummidrangeareas: Int32
    var starttime: Int32
    var goaltime: Int32
    var goaltraveltime: Int32
    var dist: Float
    var bestdist: Float
    var mid = vec3_t()
    var dir = vec3_t()

    if startareanum == 0 || goalareanum == 0 {
        return 0
    }
    //travel time towards the goal area
    goaltraveltime = AAS_AreaTravelTimeToGoalArea(startareanum, start, goalareanum, travelflags)
    //clear the midrange areas
    midrangeareas!.zero(count: aasworld.numareas)
    numaltroutegoals = 0
    //
    nummidrangeareas = 0
    //
    i = 1
    while i < aasworld.numareas {
        //
        if (type & ALTROUTEGOAL_ALL) == 0 {
            if !((type & ALTROUTEGOAL_CLUSTERPORTALS) != 0 && (aasworld.areasettingsSlots[i].contents & AREACONTENTS_CLUSTERPORTAL) != 0) {
                if !((type & ALTROUTEGOAL_VIEWPORTALS) != 0 && (aasworld.areasettingsSlots[i].contents & AREACONTENTS_VIEWPORTAL) != 0) {
                    i += 1
                    continue
                } //end if
            } //end if
        } //end if
        //if the area has no reachabilities
        if AAS_AreaReachability(i) == 0 {
            i += 1
            continue
        }
        //tavel time from the area to the start area
        starttime = AAS_AreaTravelTimeToGoalArea(startareanum, start, i, travelflags)
        if starttime == 0 {
            i += 1
            continue
        }
        //if the travel time from the start to the area is greater than the shortest goal travel time
        if starttime > Float(1.1) * goaltraveltime {
            i += 1
            continue
        }
        //travel time from the area to the goal area
        goaltime = AAS_AreaTravelTimeToGoalArea(i, nil, goalareanum, travelflags)
        if goaltime == 0 {
            i += 1
            continue
        }
        //if the travel time from the area to the goal is greater than the shortest goal travel time
        if goaltime > Float(0.8) * goaltraveltime {
            i += 1
            continue
        }
        //this is a mid range area
        midrangeareas![i].valid = 1
        midrangeareas![i].starttime = starttime
        midrangeareas![i].goaltime = goaltime
        Log_Write("%d midrange area %d", nummidrangeareas, i)
        nummidrangeareas += 1
        i += 1
    } //end for
    //
    i = 1
    while i < aasworld.numareas {
        if midrangeareas![i].valid == 0 {
            i += 1
            continue
        }
        //get the areas in one cluster
        numclusterareas = 0
        AAS_AltRoutingFloodCluster_r(i)
        //now we've got a cluster with areas through which an alternative route could go
        //get the 'center' of the cluster
        mid = vec3_t()
        j = 0
        while j < numclusterareas {
            mid = mid + aasworld.areasSlots[clusterareas![j]].center
            j += 1
        } //end for
        // VectorScale is a macro, so C multiplies each component by the double `1.0 / numclusterareas`.
        let scale = 1.0 / Double(numclusterareas)
        mid[0] = Float(Double(mid[0]) * scale)
        mid[1] = Float(Double(mid[1]) * scale)
        mid[2] = Float(Double(mid[2]) * scale)
        //get the area closest to the center of the cluster
        bestdist = 999999
        bestareanum = 0
        j = 0
        while j < numclusterareas {
            dir = mid - aasworld.areasSlots[clusterareas![j]].center
            dist = VectorLength(dir)
            if dist < bestdist {
                bestdist = dist
                bestareanum = clusterareas![j]
            } //end if
            j += 1
        } //end for
        //now we've got an area for an alternative route
        //FIXME: add alternative goal origin
        altroutegoals[numaltroutegoals].origin = aasworld.areasSlots[bestareanum].center
        altroutegoals[numaltroutegoals].areanum = bestareanum
        altroutegoals[numaltroutegoals].starttraveltime = midrangeareas![bestareanum].starttime
        altroutegoals[numaltroutegoals].goaltraveltime = midrangeareas![bestareanum].goaltime
        altroutegoals[numaltroutegoals].extratraveltime =
                    (midrangeareas![bestareanum].starttime + midrangeareas![bestareanum].goaltime) -
                                goaltraveltime
        numaltroutegoals += 1
        //
        //don't return more than the maximum alternative route goals
        if numaltroutegoals >= maxaltroutegoals {
            break
        }
        i += 1
    } //end for
    return numaltroutegoals
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_routealt.cpp:199
public func AAS_InitAlternativeRouting() {
    if midrangeareas != nil {
        FreeMemory(OpaquePointer(midrangeareas!.base))
    }
    midrangeareas = Slots<Midrangearea>(GetMemory(aasworld.numareas * Int32(Midrangearea.byteCount))!, count: aasworld.numareas)
    if clusterareas != nil {
        FreeMemory(OpaquePointer(clusterareas!.base))
    }
    clusterareas = Slots<Int32>(scalars: GetMemory(aasworld.numareas * Int32(Int32.byteCount))!, count: Int(aasworld.numareas))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_routealt.cpp:214
public func AAS_ShutdownAlternativeRouting() {
    if midrangeareas != nil {
        FreeMemory(OpaquePointer(midrangeareas!.base))
    }
    midrangeareas = nil
    if clusterareas != nil {
        FreeMemory(OpaquePointer(clusterareas!.base))
    }
    clusterareas = nil
    numclusterareas = 0
}
