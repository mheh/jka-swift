import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_route.cpp:34
let DISTANCEFACTOR_CROUCH = 1.3 as Float

/// Source: oracle/codemp/botlib/be_aas_route.cpp:35
let DISTANCEFACTOR_SWIM = 1 as Int32

/// Source: oracle/codemp/botlib/be_aas_route.cpp:36
let DISTANCEFACTOR_WALK = 0.33 as Float

/// Source: oracle/codemp/botlib/be_aas_route.cpp:39
let CACHE_REFRESHTIME = 15.0 as Float

/// Source: oracle/codemp/botlib/be_aas_route.cpp:42
let MAX_FRAMEROUTINGUPDATES = 10 as Int32

/// Source: oracle/codemp/botlib/be_aas_route.cpp:63
var numareacacheupdates: Int32 {
    get { world.variables.numareacacheupdates }
    set { world.variables.numareacacheupdates = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_route.cpp:64
var numportalcacheupdates: Int32 {
    get { world.variables.numportalcacheupdates }
    set { world.variables.numportalcacheupdates = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_route.cpp:67
var routingcachesize: Int32 {
    get { world.variables.routingcachesize }
    set { world.variables.routingcachesize = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_route.cpp:68
var max_routingcachesize: Int32 {
    get { world.variables.max_routingcachesize }
    set { world.variables.max_routingcachesize = newValue }
}

/// Source: oracle/codemp/botlib/be_aas_route.cpp:911
let RCID = ((Int32(UInt8(ascii: "C")) << 24) + (Int32(UInt8(ascii: "R")) << 16) + (Int32(UInt8(ascii: "E")) << 8) + Int32(UInt8(ascii: "M")))

/// Source: oracle/codemp/botlib/be_aas_route.cpp:912
let RCVERSION = 2 as Int32

/// Source: oracle/codemp/botlib/be_aas_route.cpp:1124
let MAX_REACHABILITYPASSAREAS = 32 as Int32

/// Source: oracle/codemp/botlib/be_aas_route.cpp:1128
// AI: Raven declares `areas` on the stack of AAS_InitReachabilityAreas. The function uses one zeroed allocation on the storage class.
private var areas_AAS_InitReachabilityAreas: Slots<Int32> { world.storage.be_aas_route_areas_AAS_InitReachabilityAreas }

/// Source: oracle/codemp/botlib/be_aas_route.cpp:77
func AAS_RoutingInfo() {
    botimport.runPrint(PRT_MESSAGE, "%d area cache updates\n", numareacacheupdates)
    botimport.runPrint(PRT_MESSAGE, "%d portal cache updates\n", numportalcacheupdates)
    botimport.runPrint(PRT_MESSAGE, "%d bytes routing cache\n", routingcachesize)
}

//===========================================================================
// returns the number of the area in the cluster
// assumes the given area is in the given cluster or a portal of the cluster
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:92
func AAS_ClusterAreaNum(_ cluster: Int32, _ areanum: Int32) -> Int32 {
    var side: Int32
    var areacluster: Int32

    areacluster = aasworld.areasettingsSlots[areanum].cluster
    if areacluster > 0 {
        return aasworld.areasettingsSlots[areanum].clusterareanum
    } else {
/*#ifdef ROUTING_DEBUG
		if (aasworld.portals[-areacluster].frontcluster != cluster &&
				aasworld.portals[-areacluster].backcluster != cluster)
		{
			botimport.Print(PRT_ERROR, "portal %d: does not belong to cluster %d\n"
											, -areacluster, cluster);
		} //end if
#endif //ROUTING_DEBUG*/
        side = (aasworld.portalsSlots[-areacluster].frontcluster != cluster ? 1 : 0)
        return aasworld.portalsSlots[-areacluster].clusterareanum[side]
    } //end else
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:118
func AAS_InitTravelFlagFromType() {
    var i: Int32

    i = 0
    while i < MAX_TRAVELTYPES {
        aasworld.travelflagfortype[i] = TFL_INVALID
        i += 1
    } //end for
    aasworld.travelflagfortype[TRAVEL_INVALID] = TFL_INVALID
    aasworld.travelflagfortype[TRAVEL_WALK] = TFL_WALK
    aasworld.travelflagfortype[TRAVEL_CROUCH] = TFL_CROUCH
    aasworld.travelflagfortype[TRAVEL_BARRIERJUMP] = TFL_BARRIERJUMP
    aasworld.travelflagfortype[TRAVEL_JUMP] = TFL_JUMP
    aasworld.travelflagfortype[TRAVEL_LADDER] = TFL_LADDER
    aasworld.travelflagfortype[TRAVEL_WALKOFFLEDGE] = TFL_WALKOFFLEDGE
    aasworld.travelflagfortype[TRAVEL_SWIM] = TFL_SWIM
    aasworld.travelflagfortype[TRAVEL_WATERJUMP] = TFL_WATERJUMP
    aasworld.travelflagfortype[TRAVEL_TELEPORT] = TFL_TELEPORT
    aasworld.travelflagfortype[TRAVEL_ELEVATOR] = TFL_ELEVATOR
    aasworld.travelflagfortype[TRAVEL_ROCKETJUMP] = TFL_ROCKETJUMP
    aasworld.travelflagfortype[TRAVEL_BFGJUMP] = TFL_BFGJUMP
    aasworld.travelflagfortype[TRAVEL_GRAPPLEHOOK] = TFL_GRAPPLEHOOK
    aasworld.travelflagfortype[TRAVEL_DOUBLEJUMP] = TFL_DOUBLEJUMP
    aasworld.travelflagfortype[TRAVEL_RAMPJUMP] = TFL_RAMPJUMP
    aasworld.travelflagfortype[TRAVEL_STRAFEJUMP] = TFL_STRAFEJUMP
    aasworld.travelflagfortype[TRAVEL_JUMPPAD] = TFL_JUMPPAD
    aasworld.travelflagfortype[TRAVEL_FUNCBOB] = TFL_FUNCBOB
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:152
func AAS_TravelFlagForType_inline(_ traveltype: Int32) -> Int32 {
    // Raven assigns his own `traveltype` parameter. A Swift parameter is immutable, so the body takes a mutable copy.
    var traveltype = traveltype
    var tfl: Int32

    tfl = 0
    if (tfl & TRAVELFLAG_NOTTEAM1) != 0 {
        tfl |= TFL_NOTTEAM1
    }
    if (tfl & TRAVELFLAG_NOTTEAM2) != 0 {
        tfl |= TFL_NOTTEAM2
    }
    traveltype &= TRAVELTYPE_MASK
    if traveltype < 0 || traveltype >= MAX_TRAVELTYPES {
        return TFL_INVALID
    }
    tfl |= aasworld.travelflagfortype[traveltype]
    return tfl
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:173
func AAS_TravelFlagForType(_ traveltype: Int32) -> Int32 {
    return AAS_TravelFlagForType_inline(traveltype)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:183
func AAS_UnlinkCache(_ cache: AasRoutingcache) {
    if cache.time_next != nil {
        cache.time_next!.time_prev = cache.time_prev
    } else {
        aasworld.newestcache = cache.time_prev
    }
    if cache.time_prev != nil {
        cache.time_prev!.time_next = cache.time_next
    } else {
        aasworld.oldestcache = cache.time_next
    }
    cache.time_next = nil
    cache.time_prev = nil
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:198
func AAS_LinkCache(_ cache: AasRoutingcache) {
    if aasworld.newestcache != nil {
        aasworld.newestcache!.time_next = cache
        cache.time_prev = aasworld.newestcache
    } //end if
    else {
        aasworld.oldestcache = cache
        cache.time_prev = nil
    } //end else
    cache.time_next = nil
    aasworld.newestcache = cache
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:219
func AAS_FreeRoutingCache(_ cache: AasRoutingcache) {
    AAS_UnlinkCache(cache)
    routingcachesize -= cache.size
    FreeMemory(cache.handle)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:231
func AAS_RemoveRoutingCacheInCluster(_ clusternum: Int32) {
    var i: Int32
    var cache: AasRoutingcache?
    var nextcache: AasRoutingcache?
    var cluster: AasCluster

    if aasworld.clusterareacache == nil {
        return
    }
    cluster = aasworld.clustersSlots[clusternum]
    i = 0
    while i < cluster.numareas {
        // AI: Raven indexes the two-level pointer table of the cluster caches. The hand accessor of the view target steps the pointer level.
        cache = aasworld.clusterareacache(clusternum, i)
        while cache != nil {
            nextcache = cache!.next
            AAS_FreeRoutingCache(cache!)
            cache = nextcache
        } //end for
        // AI: Raven stores through the two-level pointer table of the cluster caches. The hand accessor of the view target does the store.
        aasworld.setClusterareacache(clusternum, i, to: nil)
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:256
func AAS_RemoveRoutingCacheUsingArea(_ areanum: Int32) {
    var i: Int32
    var clusternum: Int32
    var cache: AasRoutingcache?
    var nextcache: AasRoutingcache?

    clusternum = aasworld.areasettingsSlots[areanum].cluster
    if clusternum > 0 {
        //remove all the cache in the cluster the area is in
        AAS_RemoveRoutingCacheInCluster(clusternum)
    } //end if
    else {
        // if this is a portal remove all cache in both the front and back cluster
        AAS_RemoveRoutingCacheInCluster(aasworld.portalsSlots[-clusternum].frontcluster)
        AAS_RemoveRoutingCacheInCluster(aasworld.portalsSlots[-clusternum].backcluster)
    } //end else
    // remove all portal cache
    i = 0
    while i < aasworld.numareas {
        //refresh portal cache
        cache = aasworld.portalcache![i]
        while cache != nil {
            nextcache = cache!.next
            AAS_FreeRoutingCache(cache!)
            cache = nextcache
        } //end for
        aasworld.portalcache![i] = nil
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:291
func AAS_EnableRoutingArea(_ areanum: Int32, _ enable: Int32) -> Int32 {
    var flags: Int32

    if areanum <= 0 || areanum >= aasworld.numareas {
        if bot_developer != 0 {
            botimport.runPrint(PRT_ERROR, "AAS_EnableRoutingArea: areanum %d out of range\n", areanum)
        } //end if
        return 0
    } //end if
    flags = aasworld.areasettingsSlots[areanum].areaflags & AREA_DISABLED
    if enable < 0 {
        return (flags == 0 ? 1 : 0)
    }

    if enable != 0 {
        aasworld.areasettingsSlots[areanum].areaflags &= ~AREA_DISABLED
    } else {
        aasworld.areasettingsSlots[areanum].areaflags |= AREA_DISABLED
    }
    // if the status of the area changed
    if (flags & AREA_DISABLED) != (aasworld.areasettingsSlots[areanum].areaflags & AREA_DISABLED) {
        //remove all routing cache involving this area
        AAS_RemoveRoutingCacheUsingArea(areanum)
    } //end if
    return (flags == 0 ? 1 : 0)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:325
func AAS_RoutingTime() -> Float {
    return AAS_Time()
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:335
func AAS_GetAreaContentsTravelFlags(_ areanum: Int32) -> Int32 {
    var contents: Int32
    var tfl: Int32

    contents = aasworld.areasettingsSlots[areanum].contents
    tfl = 0
    if (contents & AREACONTENTS_WATER) != 0 {
        tfl |= TFL_WATER
    } else if (contents & AREACONTENTS_SLIME) != 0 {
        tfl |= TFL_SLIME
    } else if (contents & AREACONTENTS_LAVA) != 0 {
        tfl |= TFL_LAVA
    } else {
        tfl |= TFL_AIR
    }
    if (contents & AREACONTENTS_DONOTENTER) != 0 {
        tfl |= TFL_DONOTENTER
    }
    if (contents & AREACONTENTS_NOTTEAM1) != 0 {
        tfl |= TFL_NOTTEAM1
    }
    if (contents & AREACONTENTS_NOTTEAM2) != 0 {
        tfl |= TFL_NOTTEAM2
    }
    if (aasworld.areasettingsSlots[areanum].areaflags & AREA_BRIDGE) != 0 {
        tfl |= TFL_BRIDGE
    }
    return tfl
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:365
func AAS_AreaContentsTravelFlags_inline(_ areanum: Int32) -> Int32 {
    return aasworld.areacontentstravelflags![areanum]
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:375
func AAS_AreaContentsTravelFlags(_ areanum: Int32) -> Int32 {
    return aasworld.areacontentstravelflags![areanum]
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:385
func AAS_InitAreaContentsTravelFlags() {
    var i: Int32

    if aasworld.areacontentstravelflags != nil {
        FreeMemory(OpaquePointer(aasworld.areacontentstravelflags!.base))
    }
    aasworld.areacontentstravelflags = Slots<Int32>(scalars: GetClearedMemory(aasworld.numareas * Int32(Int32.byteCount)), count: Int(aasworld.numareas))
    //
    i = 0
    while i < aasworld.numareas {
        aasworld.areacontentstravelflags![i] = AAS_GetAreaContentsTravelFlags(i)
        i += 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:402
func AAS_CreateReversedReachability() {
    var i: Int32
    var n: Int32
    var revlink: AasReversedlink
    var reach: AasReachability
    var settings: AasAreasettings

    //free reversed links that have already been created
    if aasworld.reversedreachability != nil {
        FreeMemory(aasworld.reversedreachability?.handle)
    }
    //allocate memory for the reversed reachability links
    var ptr = GetClearedMemory(aasworld.numareas * Int32(AasReversedreachability.byteCount) +
                            aasworld.reachabilitysize * Int32(AasReversedlink.byteCount))
    //
    aasworld.reversedreachability = AasReversedreachability(ptr)
    //pointer to the memory for the reversed links
    ptr = ptr + aasworld.numareas * Int32(AasReversedreachability.byteCount)
    //check all reachabilities of all areas
    i = 1
    while i < aasworld.numareas {
        //settings of the area
        settings = aasworld.areasettingsSlots[i]
        //
        if settings.numreachableareas >= 128 {
            botimport.runPrint(PRT_WARNING, "area %d has more than 128 reachabilities\n", i)
        }
        //create reversed links for the reachabilities
        n = 0
        while n < settings.numreachableareas && n < 128 {
            //reachability link
            reach = aasworld.reachabilitySlots[settings.firstreachablearea + n]
            //
            revlink = AasReversedlink(ptr)
            ptr = ptr + Int32(AasReversedlink.byteCount)
            //
            revlink.areanum = i
            revlink.linknum = settings.firstreachablearea + n
            revlink.next = aasworld.reversedreachabilitySlots[reach.areanum].first
            aasworld.reversedreachabilitySlots[reach.areanum].first = revlink
            aasworld.reversedreachabilitySlots[reach.areanum].numlinks += 1
            n += 1
        } //end for
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:457
func AAS_AreaTravelTime(_ areanum: Int32, _ start: JKAShared.vec3_t?, _ end: JKAShared.vec3_t) -> Int32 {
    var intdist: Int32
    var dist: Float
    var dir = vec3_t()

    dir = start! - end
    dist = VectorLength(dir)
    //if crouch only area
    if AAS_AreaCrouch(areanum) != 0 {
        dist *= DISTANCEFACTOR_CROUCH
    }
    //if swim area
    else if AAS_AreaSwim(areanum) != 0 {
        dist *= DISTANCEFACTOR_SWIM
    }
    //normal walk area
    else {
        dist *= DISTANCEFACTOR_WALK
    }
    //
    intdist = Int32(dist)
    //make sure the distance isn't zero
    if intdist <= 0 {
        intdist = 1
    }
    return Int32(UInt16(truncatingIfNeeded: intdist))
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:483
func AAS_CalculateAreaTravelTimes() {
    var i: Int32
    var l: Int32
    var n: Int32
    var size: Int32
    var end = vec3_t()
    var revreach: AasReversedreachability
    var revlink: AasReversedlink?
    var reach: AasReachability
    var settings: AasAreasettings
    var starttime: Int32

    starttime = Sys_MilliSeconds()
    //if there are still area travel times, free the memory
    if aasworld.areatraveltimes != nil {
        FreeMemory(aasworld.areatraveltimes)
    }
    //get the total size of all the area travel times
    size = aasworld.numareas * Int32(OpaquePointer.byteCount)
    i = 0
    while i < aasworld.numareas {
        revreach = aasworld.reversedreachabilitySlots[i]
        //settings of the area
        settings = aasworld.areasettingsSlots[i]
        //
        size += settings.numreachableareas * Int32(OpaquePointer.byteCount)
        //
        size += settings.numreachableareas * revreach.numlinks * Int32(UInt16.byteCount)
        i += 1
    } //end for
    //allocate memory for the area travel times
    var ptr = GetClearedMemory(size)
    aasworld.areatraveltimes = OpaquePointer(ptr)
    ptr = ptr + aasworld.numareas * Int32(OpaquePointer.byteCount)
    //calcluate the travel times for all the areas
    i = 0
    while i < aasworld.numareas {
        //reversed reachabilities of this area
        revreach = aasworld.reversedreachabilitySlots[i]
        //settings of the area
        settings = aasworld.areasettingsSlots[i]
        //
        // AI: Raven stores a cast of the byte pointer into the table of travel times. The hand accessor of the view target does the store.
        aasworld.setAreatraveltimes(i, to: ptr)
        ptr = ptr + settings.numreachableareas * Int32(OpaquePointer.byteCount)
        //
        l = 0
        while l < settings.numreachableareas {
            // AI: Raven stores a cast of the byte pointer into the table of travel times. The hand accessor of the view target does the store.
            aasworld.setAreatraveltimes(i, l, to: ptr)
            ptr = ptr + revreach.numlinks * Int32(UInt16.byteCount)
            //reachability link
            reach = aasworld.reachabilitySlots[settings.firstreachablearea + l]
            //
            n = 0
            revlink = revreach.first
            while revlink != nil {
                end = aasworld.reachabilitySlots[revlink!.linknum].end
                //
                // AI: Raven indexes the three-level pointer table of the travel times. The hand accessor of the view target steps the two pointer levels.
                aasworld.areatraveltimes(i, l)[n] = UInt16(truncatingIfNeeded: AAS_AreaTravelTime(i, end, reach.start))
                revlink = revlink!.next
                n += 1
            } //end for
            l += 1
        } //end for
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:549
func AAS_PortalMaxTravelTime(_ portalnum: Int32) -> Int32 {
    var l: Int32
    var n: Int32
    var t: Int32
    var maxt: Int32
    var portal: AasPortal
    var revreach: AasReversedreachability
    var revlink: AasReversedlink?
    var settings: AasAreasettings

    portal = aasworld.portalsSlots[portalnum]
    //reversed reachabilities of this portal area
    revreach = aasworld.reversedreachabilitySlots[portal.areanum]
    //settings of the portal area
    settings = aasworld.areasettingsSlots[portal.areanum]
    //
    maxt = 0
    l = 0
    while l < settings.numreachableareas {
        n = 0
        revlink = revreach.first
        while revlink != nil {
            // AI: Raven indexes the three-level pointer table of the travel times. The hand accessor of the view target steps the two pointer levels.
            t = Int32(aasworld.areatraveltimes(portal.areanum, l)[n])
            if t > maxt {
                maxt = t
            } //end if
            revlink = revlink!.next
            n += 1
        } //end for
        l += 1
    } //end for
    return maxt
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:583
func AAS_InitPortalMaxTravelTimes() {
    var i: Int32

    if aasworld.portalmaxtraveltimes != nil {
        FreeMemory(OpaquePointer(aasworld.portalmaxtraveltimes!.base))
    }

    aasworld.portalmaxtraveltimes = Slots<Int32>(scalars: GetClearedMemory(aasworld.numportals * Int32(Int32.byteCount)), count: Int(aasworld.numportals))

    i = 0
    while i < aasworld.numportals {
        aasworld.portalmaxtraveltimes![i] = AAS_PortalMaxTravelTime(i)
        //botimport.Print(PRT_MESSAGE, "portal %d max tt = %d\n", i, aasworld.portalmaxtraveltimes[i]);
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/**
```
int AAS_FreeOldestCache(void)
{
	int i, j, bestcluster, bestarea, freed;
	float besttime;
	aas_routingcache_t *cache, *bestcache;

	freed = qfalse;
	besttime = 999999999;
	bestcache = NULL;
	bestcluster = 0;
	bestarea = 0;
	//refresh cluster cache
	for (i = 0; i < aasworld.numclusters; i++)
	{
		for (j = 0; j < aasworld.clusters[i].numareas; j++)
		{
			for (cache = aasworld.clusterareacache[i][j]; cache; cache = cache->next)
			{
				//never remove cache leading towards a portal
				if (aasworld.areasettings[cache->areanum].cluster < 0) continue;
				//if this cache is older than the cache we found so far
				if (cache->time < besttime)
				{
					bestcache = cache;
					bestcluster = i;
					bestarea = j;
					besttime = cache->time;
				} //end if
			} //end for
		} //end for
	} //end for
	if (bestcache)
	{
		cache = bestcache;
		if (cache->prev) cache->prev->next = cache->next;
		else aasworld.clusterareacache[bestcluster][bestarea] = cache->next;
		if (cache->next) cache->next->prev = cache->prev;
		AAS_FreeRoutingCache(cache);
		freed = qtrue;
	} //end if
	besttime = 999999999;
	bestcache = NULL;
	bestarea = 0;
	for (i = 0; i < aasworld.numareas; i++)
	{
		//refresh portal cache
		for (cache = aasworld.portalcache[i]; cache; cache = cache->next)
		{
			if (cache->time < besttime)
			{
				bestcache = cache;
				bestarea = i;
				besttime = cache->time;
			} //end if
		} //end for
	} //end for
	if (bestcache)
	{
		cache = bestcache;
		if (cache->prev) cache->prev->next = cache->next;
		else aasworld.portalcache[bestarea] = cache->next;
		if (cache->next) cache->next->prev = cache->prev;
		AAS_FreeRoutingCache(cache);
		freed = qtrue;
	} //end if
	return freed;
} //end of the function AAS_FreeOldestCache
```
*/
//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:678
func AAS_FreeOldestCache() -> Int32 {
    var clusterareanum: Int32
    var cache: AasRoutingcache?

    cache = aasworld.oldestcache
    while cache != nil {
        // never free area cache leading towards a portal
        if cache!.type == CACHETYPE_AREA && aasworld.areasettingsSlots[cache!.areanum].cluster < 0 {
            cache = cache!.time_next
            continue
        }
        break
    }
    if let cache {
        // unlink the cache
        if cache.type == CACHETYPE_AREA {
            //number of the area in the cluster
            clusterareanum = AAS_ClusterAreaNum(cache.cluster, cache.areanum)
            // unlink from cluster area cache
            if cache.prev != nil {
                cache.prev!.next = cache.next
            } else {
                // AI: Raven stores through the two-level pointer table of the cluster caches. The hand accessor of the view target does the store.
                aasworld.setClusterareacache(cache.cluster, clusterareanum, to: cache.next)
            }
            if cache.next != nil {
                cache.next!.prev = cache.prev
            }
        } else {
            // unlink from portal cache
            if cache.prev != nil {
                cache.prev!.next = cache.next
            } else {
                aasworld.portalcache![cache.areanum] = cache.next
            }
            if cache.next != nil {
                cache.next!.prev = cache.prev
            }
        }
        AAS_FreeRoutingCache(cache)
        return 1
    }
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:717
func AAS_AllocRoutingCache(_ numtraveltimes: Int32) -> AasRoutingcache? {
    var cache: AasRoutingcache
    var size: Int32

    //
    size = Int32(AasRoutingcache.byteCount)
                        + numtraveltimes * Int32(UInt16.byteCount)
                        + numtraveltimes * Int32(UInt8.byteCount)
    //
    routingcachesize += size
    //
    let block = GetClearedMemory(size)
    cache = AasRoutingcache(block)
    cache.reachabilities = Slots(scalars: block + Int32(AasRoutingcache.byteCount)
                                + numtraveltimes * Int32(UInt16.byteCount), count: Int(numtraveltimes))
    cache.size = size
    return cache
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:741
func AAS_FreeAllClusterAreaCache() {
    var i: Int32
    var j: Int32
    var cache: AasRoutingcache?
    var nextcache: AasRoutingcache?
    var cluster: AasCluster

    //free all cluster cache if existing
    if aasworld.clusterareacache == nil {
        return
    }
    //free caches
    i = 0
    while i < aasworld.numclusters {
        cluster = aasworld.clustersSlots[i]
        j = 0
        while j < cluster.numareas {
            // AI: Raven indexes the two-level pointer table of the cluster caches. The hand accessor of the view target steps the pointer level.
            cache = aasworld.clusterareacache(i, j)
            while cache != nil {
                nextcache = cache!.next
                AAS_FreeRoutingCache(cache!)
                cache = nextcache
            } //end for
            // AI: Raven stores through the two-level pointer table of the cluster caches. The hand accessor of the view target does the store.
            aasworld.setClusterareacache(i, j, to: nil)
            j += 1
        } //end for
        i += 1
    } //end for
    //free the cluster cache array
    FreeMemory(aasworld.clusterareacache)
    aasworld.clusterareacache = nil
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:773
func AAS_InitClusterAreaCache() {
    var i: Int32
    var size: Int32

    //
    size = 0
    i = 0
    while i < aasworld.numclusters {
        size += aasworld.clustersSlots[i].numareas
        i += 1
    } //end for
    //two dimensional array with pointers for every cluster to routing cache
    //for every area in that cluster
    var ptr = GetClearedMemory(
                aasworld.numclusters * Int32(OpaquePointer.byteCount) +
                size * Int32(OpaquePointer.byteCount))
    aasworld.clusterareacache = OpaquePointer(ptr)
    ptr = ptr + aasworld.numclusters * Int32(OpaquePointer.byteCount)
    i = 0
    while i < aasworld.numclusters {
        // AI: Raven stores a cast of the byte pointer into the table of cluster caches. The hand accessor of the view target does the store.
        aasworld.setClusterareacache(i, to: ptr)
        ptr = ptr + aasworld.clustersSlots[i].numareas * Int32(OpaquePointer.byteCount)
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:802
func AAS_FreeAllPortalCache() {
    var i: Int32
    var cache: AasRoutingcache?
    var nextcache: AasRoutingcache?

    //free all portal cache if existing
    if aasworld.portalcache == nil {
        return
    }
    //free portal caches
    i = 0
    while i < aasworld.numareas {
        cache = aasworld.portalcache![i]
        while cache != nil {
            nextcache = cache!.next
            AAS_FreeRoutingCache(cache!)
            cache = nextcache
        } //end for
        aasworld.portalcache![i] = nil
        i += 1
    } //end for
    FreeMemory(OpaquePointer(aasworld.portalcache!.base))
    aasworld.portalcache = nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:828
func AAS_InitPortalCache() {
    //
    aasworld.portalcache = Slots(pointers: GetClearedMemory(
                                aasworld.numareas * Int32(OpaquePointer.byteCount)), count: Int(aasworld.numareas))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:840
func AAS_InitRoutingUpdate() {
    var i: Int32
    var maxreachabilityareas: Int32

    //free routing update fields if already existing
    if aasworld.areaupdate != nil {
        FreeMemory(aasworld.areaupdate?.handle)
    }
    //
    maxreachabilityareas = 0
    i = 0
    while i < aasworld.numclusters {
        if aasworld.clustersSlots[i].numreachabilityareas > maxreachabilityareas {
            maxreachabilityareas = aasworld.clustersSlots[i].numreachabilityareas
        } //end if
        i += 1
    } //end for
    //allocate memory for the routing update fields
    aasworld.areaupdate = AasRoutingupdate(GetClearedMemory(
                                    maxreachabilityareas * Int32(AasRoutingupdate.byteCount)))
    //
    if aasworld.portalupdate != nil {
        FreeMemory(aasworld.portalupdate?.handle)
    }
    //allocate memory for the portal update fields
    aasworld.portalupdate = AasRoutingupdate(GetClearedMemory(
                                    (aasworld.numportals + 1) * Int32(AasRoutingupdate.byteCount)))
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
// Port-note: Raven calls this function from no file of either tree, so it is dead.
/// Source: oracle/codemp/botlib/be_aas_route.cpp:870
func AAS_CreateAllRoutingCache() {
    // TODO: Port AAS_CreateAllRoutingCache
    portMissing("AAS_CreateAllRoutingCache", source: "oracle/codemp/botlib/be_aas_route.cpp:870")
}

/// Source: oracle/codemp/botlib/be_aas_route.cpp:917
func AAS_WriteRouteCache() {
    var i: Int32
    var j: Int32
    var numportalcache: Int32
    var numareacache: Int32
    var totalsize: Int32
    var cache: AasRoutingcache?
    var cluster: AasCluster
    var fp: fileHandle_t = 0
    var filename = CharBuf(MAX_QPATH)

    numportalcache = 0
    i = 0
    while i < aasworld.numareas {
        cache = aasworld.portalcache![i]
        while cache != nil {
            numportalcache += 1
            cache = cache!.next
        } //end for
        i += 1
    } //end for
    numareacache = 0
    i = 0
    while i < aasworld.numclusters {
        cluster = aasworld.clustersSlots[i]
        j = 0
        while j < cluster.numareas {
            // AI: Raven indexes the two-level pointer table of the cluster caches. The hand accessor of the view target steps the pointer level.
            cache = aasworld.clusterareacache(i, j)
            while cache != nil {
                numareacache += 1
                cache = cache!.next
            } //end for
            j += 1
        } //end for
        i += 1
    } //end for
    // open the file for writing
    Com_sprintf(&filename, MAX_QPATH, "maps/%s.rcd", aasworld.mapname)
    botimport.runFS_FOpenFile(String(filename), &fp, FS_WRITE)
    if fp == 0 {
        AAS_Error("Unable to open file: %s\n", String(filename))
        return
    } //end if
    Routecacheheader.scratch { routecacheheader in
        //create the header
        routecacheheader.ident = RCID
        routecacheheader.version = RCVERSION
        routecacheheader.numareas = aasworld.numareas
        routecacheheader.numclusters = aasworld.numclusters
        routecacheheader.areacrc = CRC_ProcessString(Slots<byte>(scalars: aasworld.areasSlots.base, count: Int(Int32(AasArea.byteCount) * aasworld.numareas)), Int32(AasArea.byteCount) * aasworld.numareas)
        routecacheheader.clustercrc = CRC_ProcessString(Slots<byte>(scalars: aasworld.clustersSlots.base, count: Int(Int32(AasCluster.byteCount) * aasworld.numclusters)), Int32(AasCluster.byteCount) * aasworld.numclusters)
        routecacheheader.numportalcache = numportalcache
        routecacheheader.numareacache = numareacache
        //write the header
        botimport.runFS_Write(Slots(record: routecacheheader).bytes, Int32(Routecacheheader.byteCount), fp)
    }
    //
    totalsize = 0
    //write all the cache
    i = 0
    while i < aasworld.numareas {
        cache = aasworld.portalcache![i]
        while cache != nil {
            botimport.runFS_Write(Slots(record: cache!).bytes, cache!.size, fp)
            totalsize += cache!.size
            cache = cache!.next
        } //end for
        i += 1
    } //end for
    i = 0
    while i < aasworld.numclusters {
        cluster = aasworld.clustersSlots[i]
        j = 0
        while j < cluster.numareas {
            // AI: Raven indexes the two-level pointer table of the cluster caches. The hand accessor of the view target steps the pointer level.
            cache = aasworld.clusterareacache(i, j)
            while cache != nil {
                botimport.runFS_Write(Slots(record: cache!).bytes, cache!.size, fp)
                totalsize += cache!.size
                cache = cache!.next
            } //end for
            j += 1
        } //end for
        i += 1
    } //end for
    // write the visareas
    /*
    for (i = 0; i < aasworld.numareas; i++)
    {
        if (!aasworld.areavisibility[i]) {
            size = 0;
            botimport.FS_Write(&size, sizeof(int), fp);
            continue;
        }
        AAS_DecompressVis( aasworld.areavisibility[i], aasworld.numareas, aasworld.decompressedvis );
        size = AAS_CompressVis( aasworld.decompressedvis, aasworld.numareas, aasworld.decompressedvis );
        botimport.FS_Write(&size, sizeof(int), fp);
        botimport.FS_Write(aasworld.decompressedvis, size, fp);
    }
    */
    //
    botimport.runFS_FCloseFile(fp)
    botimport.runPrint(PRT_MESSAGE, "\nroute cache written to %s\n", String(filename))
    botimport.runPrint(PRT_MESSAGE, "written %d bytes of routing cache\n", totalsize)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1014
func AAS_ReadCache(_ fp: JKAShared.fileHandle_t) -> AasRoutingcache? {
    let size: Int32 = 0
    var cache: AasRoutingcache

    // Port-note: runFS_Read takes a Slots of bytes, and no form gives the bytes of the scalar `size` without a new helper.
    // Raven wrote: botimport.FS_Read(&size, sizeof(size), fp);
    portMissing("botimport.FS_Read", source: "oracle/codemp/botlib/be_aas_route.cpp:1019")
    let block = GetMemory(size)!
    cache = AasRoutingcache(block)
    cache.size = size
    botimport.runFS_Read(Slots<byte>(scalars: block, count: Int(size)).suffix(from: Int32.byteCount), size - Int32(Int32.byteCount), fp)
    cache.reachabilities = Slots(scalars: block + Int32(AasRoutingcache.byteCount) - Int32(UInt16.byteCount) +
        (size - Int32(AasRoutingcache.byteCount) + Int32(UInt16.byteCount)) / 3 * 2,
        count: Int((size - Int32(AasRoutingcache.byteCount) + Int32(UInt16.byteCount)) / 3))
    return cache
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1033
@discardableResult
func AAS_ReadRouteCache() -> Int32 {
    var i: Int32
    var clusterareanum: Int32 //, size;
    var fp: fileHandle_t = 0
    var filename = CharBuf(MAX_QPATH)
    var cache: AasRoutingcache?

    Com_sprintf(&filename, MAX_QPATH, "maps/%s.rcd", aasworld.mapname)
    botimport.runFS_FOpenFile(String(filename), &fp, FS_READ)
    if fp == 0 {
        return 0
    } //end if
    let valid = Routecacheheader.scratch { routecacheheader -> Bool in
        botimport.runFS_Read(Slots(record: routecacheheader).bytes, Int32(Routecacheheader.byteCount), fp)
        if routecacheheader.ident != RCID {
            // Port-note: Raven passes no argument for the %s, so his vsprintf reads a word past the arguments.
            // The port passes the file name, rule 19.
            AAS_Error("%s is not a route cache dump\n", String(filename))
            return false
        } //end if
        if routecacheheader.version != RCVERSION {
            AAS_Error("route cache dump has wrong version %d, should be %d", routecacheheader.version, RCVERSION)
            return false
        } //end if
        if routecacheheader.numareas != aasworld.numareas {
            //AAS_Error("route cache dump has wrong number of areas\n");
            return false
        } //end if
        if routecacheheader.numclusters != aasworld.numclusters {
            //AAS_Error("route cache dump has wrong number of clusters\n");
            return false
        } //end if
        if routecacheheader.areacrc !=
            CRC_ProcessString(Slots<byte>(scalars: aasworld.areasSlots.base, count: Int(Int32(AasArea.byteCount) * aasworld.numareas)), Int32(AasArea.byteCount) * aasworld.numareas) {
            //AAS_Error("route cache dump area CRC incorrect\n");
            return false
        } //end if
        if routecacheheader.clustercrc !=
            CRC_ProcessString(Slots<byte>(scalars: aasworld.clustersSlots.base, count: Int(Int32(AasCluster.byteCount) * aasworld.numclusters)), Int32(AasCluster.byteCount) * aasworld.numclusters) {
            //AAS_Error("route cache dump cluster CRC incorrect\n");
            return false
        } //end if
        //read all the portal cache
        i = 0
        while i < routecacheheader.numportalcache {
            cache = AAS_ReadCache(fp)
            cache!.next = aasworld.portalcache![cache!.areanum]
            cache!.prev = nil
            if aasworld.portalcache![cache!.areanum] != nil {
                aasworld.portalcache![cache!.areanum]!.prev = cache
            }
            aasworld.portalcache![cache!.areanum] = cache
            i += 1
        } //end for
        //read all the cluster area cache
        i = 0
        while i < routecacheheader.numareacache {
            cache = AAS_ReadCache(fp)
            clusterareanum = AAS_ClusterAreaNum(cache!.cluster, cache!.areanum)
            // AI: Raven indexes the two-level pointer table of the cluster caches. The hand accessor of the view target steps the pointer level.
            cache!.next = aasworld.clusterareacache(cache!.cluster, clusterareanum)
            cache!.prev = nil
            // AI: Raven indexes the two-level pointer table of the cluster caches. The hand accessor of the view target steps the pointer level.
            if aasworld.clusterareacache(cache!.cluster, clusterareanum) != nil {
                aasworld.clusterareacache(cache!.cluster, clusterareanum)!.prev = cache
            }
            // AI: Raven stores through the two-level pointer table of the cluster caches. The hand accessor of the view target does the store.
            aasworld.setClusterareacache(cache!.cluster, clusterareanum, to: cache)
            i += 1
        } //end for
        return true
    }
    if !valid {
        return 0
    }
    // read the visareas
    /*
    aasworld.areavisibility = (byte **) GetClearedMemory(aasworld.numareas * sizeof(byte *));
    aasworld.decompressedvis = (byte *) GetClearedMemory(aasworld.numareas * sizeof(byte));
    for (i = 0; i < aasworld.numareas; i++)
    {
        botimport.FS_Read(&size, sizeof(size), fp );
        if (size) {
            aasworld.areavisibility[i] = (byte *) GetMemory(size);
            botimport.FS_Read(aasworld.areavisibility[i], size, fp );
        }
    }
    */
    //
    botimport.runFS_FCloseFile(fp)
    return 1
}

/// Source: oracle/codemp/botlib/be_aas_route.cpp:1126
func AAS_InitReachabilityAreas() {
    var i: Int32
    var j: Int32
    var numareas: Int32
    // AI: Raven declares `int areas[MAX_REACHABILITYPASSAREAS]` here. The body reads the storage forward `areas_AAS_InitReachabilityAreas`.
    var numreachareas: Int32
    var reach: AasReachability
    var start = vec3_t()
    var end = vec3_t()

    if aasworld.reachabilityareas != nil {
        FreeMemory(aasworld.reachabilityareas?.handle)
    }
    if aasworld.reachabilityareaindex != nil {
        FreeMemory(OpaquePointer(aasworld.reachabilityareaindex!.base))
    }

    aasworld.reachabilityareas = AasReachabilityareas(
                GetClearedMemory(aasworld.reachabilitysize * Int32(AasReachabilityareas.byteCount)))
    aasworld.reachabilityareaindex = Slots<Int32>(scalars:
                GetClearedMemory(aasworld.reachabilitysize * MAX_REACHABILITYPASSAREAS * Int32(Int32.byteCount)),
                count: Int(aasworld.reachabilitysize * MAX_REACHABILITYPASSAREAS))
    numreachareas = 0
    i = 0
    while i < aasworld.reachabilitysize {
        reach = aasworld.reachabilitySlots[i]
        numareas = 0
        switch reach.traveltype & TRAVELTYPE_MASK {
        //trace areas from start to end
        case TRAVEL_BARRIERJUMP, TRAVEL_WATERJUMP:
            end = reach.start
            end[2] = reach.end[2]
            numareas = AAS_TraceAreas(reach.start, end, areas_AAS_InitReachabilityAreas, nil, MAX_REACHABILITYPASSAREAS)
        case TRAVEL_WALKOFFLEDGE:
            start = reach.end
            start[2] = reach.start[2]
            numareas = AAS_TraceAreas(start, reach.end, areas_AAS_InitReachabilityAreas, nil, MAX_REACHABILITYPASSAREAS)
        case TRAVEL_GRAPPLEHOOK:
            numareas = AAS_TraceAreas(reach.start, reach.end, areas_AAS_InitReachabilityAreas, nil, MAX_REACHABILITYPASSAREAS)

        //trace arch
        case TRAVEL_JUMP: break
        case TRAVEL_ROCKETJUMP: break
        case TRAVEL_BFGJUMP: break
        case TRAVEL_JUMPPAD: break

        //trace from reach->start to entity center, along entity movement
        //and from entity center to reach->end
        case TRAVEL_ELEVATOR: break
        case TRAVEL_FUNCBOB: break

        //no areas in between
        case TRAVEL_WALK: break
        case TRAVEL_CROUCH: break
        case TRAVEL_LADDER: break
        case TRAVEL_SWIM: break
        case TRAVEL_TELEPORT: break
        default: break
        } //end switch
        aasworld.reachabilityareasSlots[i].firstarea = numreachareas
        aasworld.reachabilityareasSlots[i].numareas = numareas
        j = 0
        while j < numareas {
            aasworld.reachabilityareaindex![numreachareas] = areas_AAS_InitReachabilityAreas[j]
            numreachareas += 1
            j += 1
        } //end for
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1198
func AAS_InitRouting() {
    AAS_InitTravelFlagFromType()
    //
    AAS_InitAreaContentsTravelFlags()
    //initialize the routing update fields
    AAS_InitRoutingUpdate()
    //create reversed reachability links used by the routing update algorithm
    AAS_CreateReversedReachability()
    //initialize the cluster cache
    AAS_InitClusterAreaCache()
    //initialize portal cache
    AAS_InitPortalCache()
    //initialize the area travel times
    AAS_CalculateAreaTravelTimes()
    //calculate the maximum travel times through portals
    AAS_InitPortalMaxTravelTimes()
    //get the areas reachabilities go through
    AAS_InitReachabilityAreas()
    //
    numareacacheupdates = 0
    numportalcacheupdates = 0
    //
    routingcachesize = 0
    max_routingcachesize = 1024 * Int32(LibVarValue("max_routingcache", "4096"))
    // read any routing cache if available
    AAS_ReadRouteCache()
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1234
func AAS_FreeRoutingCaches() {
    // free all the existing cluster area cache
    AAS_FreeAllClusterAreaCache()
    // free all the existing portal cache
    AAS_FreeAllPortalCache()
    // free cached travel times within areas
    if aasworld.areatraveltimes != nil {
        FreeMemory(aasworld.areatraveltimes)
    }
    aasworld.areatraveltimes = nil
    // free cached maximum travel time through cluster portals
    if aasworld.portalmaxtraveltimes != nil {
        FreeMemory(OpaquePointer(aasworld.portalmaxtraveltimes!.base))
    }
    aasworld.portalmaxtraveltimes = nil
    // free reversed reachability links
    if aasworld.reversedreachability != nil {
        FreeMemory(aasworld.reversedreachability?.handle)
    }
    aasworld.reversedreachability = nil
    // free routing algorithm memory
    if aasworld.areaupdate != nil {
        FreeMemory(aasworld.areaupdate?.handle)
    }
    aasworld.areaupdate = nil
    if aasworld.portalupdate != nil {
        FreeMemory(aasworld.portalupdate?.handle)
    }
    aasworld.portalupdate = nil
    // free lists with areas the reachabilities go through
    if aasworld.reachabilityareas != nil {
        FreeMemory(aasworld.reachabilityareas?.handle)
    }
    aasworld.reachabilityareas = nil
    // free the reachability area index
    if aasworld.reachabilityareaindex != nil {
        FreeMemory(OpaquePointer(aasworld.reachabilityareaindex!.base))
    }
    aasworld.reachabilityareaindex = nil
    // free area contents travel flags look up table
    if aasworld.areacontentstravelflags != nil {
        FreeMemory(OpaquePointer(aasworld.areacontentstravelflags!.base))
    }
    aasworld.areacontentstravelflags = nil
}

//===========================================================================
// update the given routing cache
//
// Parameter:			areacache		: routing cache to update
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1275
// AI: Raven declares `startareatraveltimes` on the stack of AAS_UpdateAreaRoutingCache. The function uses one zeroed allocation on the storage class.
var startareatraveltimes_AAS_UpdateAreaRoutingCache: Slots<UInt16> { world.storage.startareatraveltimes_AAS_UpdateAreaRoutingCache }

/// Source: oracle/codemp/botlib/be_aas_route.cpp:1271
func AAS_UpdateAreaRoutingCache(_ areacache: AasRoutingcache) {
    var i: Int32
    var nextareanum: Int32
    var cluster: Int32
    var badtravelflags: Int32
    var clusterareanum: Int32
    var linknum: Int32
    var numreachabilityareas: Int32
    var t: UInt16 //NOTE: not more than 128 reachabilities per area allowed
    var updateliststart: AasRoutingupdate?
    var updatelistend: AasRoutingupdate?
    var curupdate: AasRoutingupdate
    var nextupdate: AasRoutingupdate
    var reach: AasReachability
    var revreach: AasReversedreachability
    var revlink: AasReversedlink?

    numareacacheupdates += 1
    //number of reachability areas within this cluster
    numreachabilityareas = aasworld.clustersSlots[areacache.cluster].numreachabilityareas
    //
    aasworld.frameroutingupdates += 1
    //clear the routing update fields
//	Com_Memset(aasworld.areaupdate, 0, aasworld.numareas * sizeof(aas_routingupdate_t));
    //
    badtravelflags = ~areacache.travelflags
    //
    clusterareanum = AAS_ClusterAreaNum(areacache.cluster, areacache.areanum)
    if clusterareanum >= numreachabilityareas {
        return
    }
    //
    startareatraveltimes_AAS_UpdateAreaRoutingCache.zero()
    //
    curupdate = aasworld.areaupdateSlots[clusterareanum]
    curupdate.areanum = areacache.areanum
    //VectorCopy(areacache->origin, curupdate->start);
    curupdate.areatraveltimes = startareatraveltimes_AAS_UpdateAreaRoutingCache
    curupdate.tmptraveltime = Int32(areacache.starttraveltime)
    //
    areacache.traveltimes[clusterareanum] = UInt16(areacache.starttraveltime)
    //put the area to start with in the current read list
    curupdate.next = nil
    curupdate.prev = nil
    updateliststart = curupdate
    updatelistend = curupdate
    //while there are updates in the current list
    while updateliststart != nil {
        curupdate = updateliststart!
        //
        if curupdate.next != nil {
            curupdate.next!.prev = nil
        } else {
            updatelistend = nil
        }
        updateliststart = curupdate.next
        //
        curupdate.inlist = false
        //check all reversed reachability links
        revreach = aasworld.reversedreachabilitySlots[curupdate.areanum]
        //
        i = 0
        revlink = revreach.first
        while revlink != nil {
            linknum = revlink!.linknum
            reach = aasworld.reachabilitySlots[linknum]
            //if there is used an undesired travel type
            if (AAS_TravelFlagForType_inline(reach.traveltype) & badtravelflags) != 0 {
                revlink = revlink!.next
                i += 1
                continue
            }
            //if not allowed to enter the next area
            if (aasworld.areasettingsSlots[reach.areanum].areaflags & AREA_DISABLED) != 0 {
                revlink = revlink!.next
                i += 1
                continue
            }
            //if the next area has a not allowed travel flag
            if (AAS_AreaContentsTravelFlags_inline(reach.areanum) & badtravelflags) != 0 {
                revlink = revlink!.next
                i += 1
                continue
            }
            //number of the area the reversed reachability leads to
            nextareanum = revlink!.areanum
            //get the cluster number of the area
            cluster = aasworld.areasettingsSlots[nextareanum].cluster
            //don't leave the cluster
            if cluster > 0 && cluster != areacache.cluster {
                revlink = revlink!.next
                i += 1
                continue
            }
            //get the number of the area in the cluster
            clusterareanum = AAS_ClusterAreaNum(areacache.cluster, nextareanum)
            if clusterareanum >= numreachabilityareas {
                revlink = revlink!.next
                i += 1
                continue
            }
            //time already travelled plus the traveltime through
            //the current area plus the travel time from the reachability
            t = UInt16(truncatingIfNeeded: curupdate.tmptraveltime +
                        //AAS_AreaTravelTime(curupdate->areanum, curupdate->start, reach->end) +
                        Int32(curupdate.areatraveltimes![i]) +
                            reach.traveltime)
            //
            if areacache.traveltimes[clusterareanum] == 0 ||
                    areacache.traveltimes[clusterareanum] > t {
                areacache.traveltimes[clusterareanum] = t
                areacache.reachabilities![byte: clusterareanum] = linknum - aasworld.areasettingsSlots[nextareanum].firstreachablearea
                nextupdate = aasworld.areaupdateSlots[clusterareanum]
                nextupdate.areanum = nextareanum
                nextupdate.tmptraveltime = Int32(t)
                //VectorCopy(reach->start, nextupdate->start);
                // AI: Raven indexes the three-level pointer table of the travel times. The hand accessor of the view target steps the two pointer levels.
                nextupdate.areatraveltimes = aasworld.areatraveltimes(nextareanum, linknum -
                                                    aasworld.areasettingsSlots[nextareanum].firstreachablearea)
                if !nextupdate.inlist {
                    // we add the update to the end of the list
                    // we could also use a B+ tree to have a real sorted list
                    // on travel time which makes for faster routing updates
                    nextupdate.next = nil
                    nextupdate.prev = updatelistend
                    if updatelistend != nil {
                        updatelistend!.next = nextupdate
                    } else {
                        updateliststart = nextupdate
                    }
                    updatelistend = nextupdate
                    nextupdate.inlist = true
                } //end if
            } //end if
            revlink = revlink!.next
            i += 1
        } //end for
    } //end while
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1382
func AAS_GetAreaRoutingCache(_ clusternum: Int32, _ areanum: Int32, _ travelflags: Int32) -> AasRoutingcache? {
    var clusterareanum: Int32
    var cache: AasRoutingcache?
    var clustercache: AasRoutingcache?

    //number of the area in the cluster
    clusterareanum = AAS_ClusterAreaNum(clusternum, areanum)
    //pointer to the cache for the area in the cluster
    // AI: Raven indexes the two-level pointer table of the cluster caches. The hand accessor of the view target steps the pointer level.
    clustercache = aasworld.clusterareacache(clusternum, clusterareanum)
    //find the cache without undesired travel flags
    cache = clustercache
    while cache != nil {
        //if there aren't used any undesired travel types for the cache
        if cache!.travelflags == travelflags {
            break
        }
        cache = cache!.next
    } //end for
    //if there was no cache
    if cache == nil {
        cache = AAS_AllocRoutingCache(aasworld.clustersSlots[clusternum].numreachabilityareas)
        cache!.cluster = clusternum
        cache!.areanum = areanum
        cache!.origin = aasworld.areasSlots[areanum].center
        cache!.starttraveltime = 1
        cache!.travelflags = travelflags
        cache!.prev = nil
        cache!.next = clustercache
        if clustercache != nil {
            clustercache!.prev = cache
        }
        // AI: Raven stores through the two-level pointer table of the cluster caches. The hand accessor of the view target does the store.
        aasworld.setClusterareacache(clusternum, clusterareanum, to: cache)
        AAS_UpdateAreaRoutingCache(cache!)
    } //end if
    else {
        AAS_UnlinkCache(cache!)
    } //end else
    //the cache has been accessed
    cache!.time = AAS_RoutingTime()
    cache!.type = CACHETYPE_AREA
    AAS_LinkCache(cache!)
    return cache
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1428
func AAS_UpdatePortalRoutingCache(_ portalcache: AasRoutingcache) {
    var i: Int32
    var portalnum: Int32
    var clusterareanum: Int32
    var clusternum: Int32
    var t: UInt16
    var portal: AasPortal
    var cluster: AasCluster
    var cache: AasRoutingcache?
    var updateliststart: AasRoutingupdate?
    var updatelistend: AasRoutingupdate?
    var curupdate: AasRoutingupdate
    var nextupdate: AasRoutingupdate

    numportalcacheupdates += 1
    //clear the routing update fields
//	Com_Memset(aasworld.portalupdate, 0, (aasworld.numportals+1) * sizeof(aas_routingupdate_t));
    //
    curupdate = aasworld.portalupdateSlots[aasworld.numportals]
    curupdate.cluster = portalcache.cluster
    curupdate.areanum = portalcache.areanum
    curupdate.tmptraveltime = Int32(portalcache.starttraveltime)
    //if the start area is a cluster portal, store the travel time for that portal
    clusternum = aasworld.areasettingsSlots[portalcache.areanum].cluster
    if clusternum < 0 {
        portalcache.traveltimes[-clusternum] = UInt16(portalcache.starttraveltime)
    } //end if
    //put the area to start with in the current read list
    curupdate.next = nil
    curupdate.prev = nil
    updateliststart = curupdate
    updatelistend = curupdate
    //while there are updates in the current list
    while updateliststart != nil {
        curupdate = updateliststart!
        //remove the current update from the list
        if curupdate.next != nil {
            curupdate.next!.prev = nil
        } else {
            updatelistend = nil
        }
        updateliststart = curupdate.next
        //current update is removed from the list
        curupdate.inlist = false
        //
        cluster = aasworld.clustersSlots[curupdate.cluster]
        //
        cache = AAS_GetAreaRoutingCache(curupdate.cluster,
                                curupdate.areanum, portalcache.travelflags)
        //take all portals of the cluster
        i = 0
        while i < cluster.numportals {
            portalnum = aasworld.portalindex![cluster.firstportal + i]
            portal = aasworld.portalsSlots[portalnum]
            //if this is the portal of the current update continue
            if portal.areanum == curupdate.areanum {
                i += 1
                continue
            }
            //
            clusterareanum = AAS_ClusterAreaNum(curupdate.cluster, portal.areanum)
            if clusterareanum >= cluster.numreachabilityareas {
                i += 1
                continue
            }
            //
            t = cache!.traveltimes[clusterareanum]
            if t == 0 {
                i += 1
                continue
            }
            t = UInt16(truncatingIfNeeded: Int32(t) + curupdate.tmptraveltime)
            //
            if portalcache.traveltimes[portalnum] == 0 ||
                    portalcache.traveltimes[portalnum] > t {
                portalcache.traveltimes[portalnum] = t
                nextupdate = aasworld.portalupdateSlots[portalnum]
                if portal.frontcluster == curupdate.cluster {
                    nextupdate.cluster = portal.backcluster
                } //end if
                else {
                    nextupdate.cluster = portal.frontcluster
                } //end else
                nextupdate.areanum = portal.areanum
                //add travel time through the actual portal area for the next update
                nextupdate.tmptraveltime = Int32(t) + aasworld.portalmaxtraveltimes![portalnum]
                if !nextupdate.inlist {
                    // we add the update to the end of the list
                    // we could also use a B+ tree to have a real sorted list
                    // on travel time which makes for faster routing updates
                    nextupdate.next = nil
                    nextupdate.prev = updatelistend
                    if updatelistend != nil {
                        updatelistend!.next = nextupdate
                    } else {
                        updateliststart = nextupdate
                    }
                    updatelistend = nextupdate
                    nextupdate.inlist = true
                } //end if
            } //end if
            i += 1
        } //end for
    } //end while
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1526
func AAS_GetPortalRoutingCache(_ clusternum: Int32, _ areanum: Int32, _ travelflags: Int32) -> AasRoutingcache? {
    var cache: AasRoutingcache?

    //find the cached portal routing if existing
    cache = aasworld.portalcache![areanum]
    while cache != nil {
        if cache!.travelflags == travelflags {
            break
        }
        cache = cache!.next
    } //end for
    //if the portal routing isn't cached
    if cache == nil {
        cache = AAS_AllocRoutingCache(aasworld.numportals)
        cache!.cluster = clusternum
        cache!.areanum = areanum
        cache!.origin = aasworld.areasSlots[areanum].center
        cache!.starttraveltime = 1
        cache!.travelflags = travelflags
        //add the cache to the cache list
        cache!.prev = nil
        cache!.next = aasworld.portalcache![areanum]
        if aasworld.portalcache![areanum] != nil {
            aasworld.portalcache![areanum]!.prev = cache
        }
        aasworld.portalcache![areanum] = cache
        //update the cache
        AAS_UpdatePortalRoutingCache(cache!)
    } //end if
    else {
        AAS_UnlinkCache(cache!)
    } //end else
    //the cache has been accessed
    cache!.time = AAS_RoutingTime()
    cache!.type = CACHETYPE_PORTAL
    AAS_LinkCache(cache!)
    return cache
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1568
func AAS_AreaRouteToGoalArea(_ areanum: Int32, _ origin: JKAShared.vec3_t?, _ goalareanum: Int32, _ travelflags: Int32, _ traveltime: inout Int32, _ reachnum: inout Int32) -> Int32 {
    // Raven assigns his own `travelflags` parameter. A Swift parameter is immutable, so the body takes a mutable copy.
    var travelflags = travelflags
    var clusternum: Int32
    var goalclusternum: Int32
    var portalnum: Int32
    var i: Int32
    var clusterareanum: Int32
    var bestreachnum: Int32
    var t: UInt16
    var besttime: UInt16
    var portal: AasPortal
    var cluster: AasCluster
    var areacache: AasRoutingcache?
    var portalcache: AasRoutingcache?
    var reach: AasReachability

    if aasworld.initialized == 0 {
        return 0
    }

    if areanum == goalareanum {
        traveltime = 1
        reachnum = 0
        return 1
    }
    //
    if areanum <= 0 || areanum >= aasworld.numareas {
        if bot_developer != 0 {
            botimport.runPrint(PRT_ERROR, "AAS_AreaTravelTimeToGoalArea: areanum %d out of range\n", areanum)
        } //end if
        return 0
    } //end if
    if goalareanum <= 0 || goalareanum >= aasworld.numareas {
        if bot_developer != 0 {
            botimport.runPrint(PRT_ERROR, "AAS_AreaTravelTimeToGoalArea: goalareanum %d out of range\n", goalareanum)
        } //end if
        return 0
    } //end if
    // make sure the routing cache doesn't grow to large
    while AvailableMemory() < 1 * 1024 * 1024 {
        if AAS_FreeOldestCache() == 0 {
            break
        }
    }
    //
    if AAS_AreaDoNotEnter(areanum) != 0 || AAS_AreaDoNotEnter(goalareanum) != 0 {
        travelflags |= TFL_DONOTENTER
    } //end if
    //NOTE: the number of routing updates is limited per frame
    /*
    if (aasworld.frameroutingupdates > MAX_FRAMEROUTINGUPDATES)
    {
#ifdef DEBUG
        //Log_Write("WARNING: AAS_AreaTravelTimeToGoalArea: frame routing updates overflowed");
#endif
        return 0;
    } //end if
    */
    //
    clusternum = aasworld.areasettingsSlots[areanum].cluster
    goalclusternum = aasworld.areasettingsSlots[goalareanum].cluster
    //check if the area is a portal of the goal area cluster
    if clusternum < 0 && goalclusternum > 0 {
        portal = aasworld.portalsSlots[-clusternum]
        if portal.frontcluster == goalclusternum ||
                portal.backcluster == goalclusternum {
            clusternum = goalclusternum
        } //end if
    } //end if
    //check if the goalarea is a portal of the area cluster
    else if clusternum > 0 && goalclusternum < 0 {
        portal = aasworld.portalsSlots[-goalclusternum]
        if portal.frontcluster == clusternum ||
                portal.backcluster == clusternum {
            goalclusternum = clusternum
        } //end if
    } //end if
    //if both areas are in the same cluster
    //NOTE: there might be a shorter route via another cluster!!! but we don't care
    if clusternum > 0 && goalclusternum > 0 && clusternum == goalclusternum {
        //
        areacache = AAS_GetAreaRoutingCache(clusternum, goalareanum, travelflags)
        //the number of the area in the cluster
        clusterareanum = AAS_ClusterAreaNum(clusternum, areanum)
        //the cluster the area is in
        cluster = aasworld.clustersSlots[clusternum]
        //if the area is NOT a reachability area
        if clusterareanum >= cluster.numreachabilityareas {
            return 0
        }
        //if it is possible to travel to the goal area through this cluster
        if areacache!.traveltimes[clusterareanum] != 0 {
            reachnum = aasworld.areasettingsSlots[areanum].firstreachablearea +
                            Int32(areacache!.reachabilities![clusterareanum])
            if origin == nil {
                traveltime = Int32(areacache!.traveltimes[clusterareanum])
                return 1
            }
            reach = aasworld.reachabilitySlots[reachnum]
            traveltime = Int32(areacache!.traveltimes[clusterareanum]) +
                            AAS_AreaTravelTime(areanum, origin, reach.start)
            //
            return 1
        } //end if
    } //end if
    //
    clusternum = aasworld.areasettingsSlots[areanum].cluster
    goalclusternum = aasworld.areasettingsSlots[goalareanum].cluster
    //if the goal area is a portal
    if goalclusternum < 0 {
        //just assume the goal area is part of the front cluster
        portal = aasworld.portalsSlots[-goalclusternum]
        goalclusternum = portal.frontcluster
    } //end if
    //get the portal routing cache
    portalcache = AAS_GetPortalRoutingCache(goalclusternum, goalareanum, travelflags)
    //if the area is a cluster portal, read directly from the portal cache
    if clusternum < 0 {
        traveltime = Int32(portalcache!.traveltimes[-clusternum])
        reachnum = aasworld.areasettingsSlots[areanum].firstreachablearea +
                        Int32(portalcache!.reachabilities![-clusternum])
        return 1
    } //end if
    //
    besttime = 0
    bestreachnum = -1
    //the cluster the area is in
    cluster = aasworld.clustersSlots[clusternum]
    //find the portal of the area cluster leading towards the goal area
    i = 0
    while i < cluster.numportals {
        portalnum = aasworld.portalindex![cluster.firstportal + i]
        //if the goal area isn't reachable from the portal
        if portalcache!.traveltimes[portalnum] == 0 {
            i += 1
            continue
        }
        //
        portal = aasworld.portalsSlots[portalnum]
        //get the cache of the portal area
        areacache = AAS_GetAreaRoutingCache(clusternum, portal.areanum, travelflags)
        //current area inside the current cluster
        clusterareanum = AAS_ClusterAreaNum(clusternum, areanum)
        //if the area is NOT a reachability area
        if clusterareanum >= cluster.numreachabilityareas {
            i += 1
            continue
        }
        //if the portal is NOT reachable from this area
        if areacache!.traveltimes[clusterareanum] == 0 {
            i += 1
            continue
        }
        //total travel time is the travel time the portal area is from
        //the goal area plus the travel time towards the portal area
        t = UInt16(truncatingIfNeeded: Int32(portalcache!.traveltimes[portalnum]) + Int32(areacache!.traveltimes[clusterareanum]))
        //FIXME: add the exact travel time through the actual portal area
        //NOTE: for now we just add the largest travel time through the portal area
        //		because we can't directly calculate the exact travel time
        //		to be more specific we don't know which reachability was used to travel
        //		into the portal area
        t = UInt16(truncatingIfNeeded: Int32(t) + aasworld.portalmaxtraveltimes![portalnum])
        //
        if origin != nil {
            reachnum = aasworld.areasettingsSlots[areanum].firstreachablearea +
                            Int32(areacache!.reachabilities![clusterareanum])
            reach = aasworld.reachabilitySlots[reachnum]
            t = UInt16(truncatingIfNeeded: Int32(t) + AAS_AreaTravelTime(areanum, origin, reach.start))
        } //end if
        //if the time is better than the one already found
        if besttime == 0 || t < besttime {
            bestreachnum = reachnum
            besttime = t
        } //end if
        i += 1
    } //end for
    if bestreachnum < 0 {
        return 0
    }
    reachnum = bestreachnum
    traveltime = Int32(besttime)
    return 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1750
func AAS_AreaTravelTimeToGoalArea(_ areanum: Int32, _ origin: JKAShared.vec3_t?, _ goalareanum: Int32, _ travelflags: Int32) -> Int32 {
    var traveltime: Int32 = 0
    var reachnum: Int32 = 0

    if AAS_AreaRouteToGoalArea(areanum, origin, goalareanum, travelflags, &traveltime, &reachnum) != 0 {
        return traveltime
    }
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1766
func AAS_AreaReachabilityToGoalArea(_ areanum: Int32, _ origin: JKAShared.vec3_t, _ goalareanum: Int32, _ travelflags: Int32) -> Int32 {
    var traveltime: Int32 = 0
    var reachnum: Int32 = 0

    if AAS_AreaRouteToGoalArea(areanum, origin, goalareanum, travelflags, &traveltime, &reachnum) != 0 {
        return reachnum
    }
    return 0
}

//===========================================================================
// predict the route and stop on one of the stop events
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1783
func AAS_PredictRoute(_ route: AasPredictroute, _ areanum: Int32, _ origin: JKAShared.vec3_t, _ goalareanum: Int32, _ travelflags: Int32, _ maxareas: Int32, _ maxtime: Int32, _ stopevent: Int32, _ stopcontents: Int32, _ stoptfl: Int32, _ stopareanum: Int32) -> Int32 {
    var curareanum: Int32
    var reachnum: Int32
    var i: Int32
    var j: Int32
    var testareanum: Int32
    var curorigin = vec3_t()
    var reach: AasReachability
    var reachareas: AasReachabilityareas

    //init output
    route.stopevent = RSE_NONE
    route.endarea = goalareanum
    route.endcontents = 0
    route.endtravelflags = 0
    route.endpos = origin
    route.time = 0

    curareanum = areanum
    curorigin = origin

    i = 0
    while curareanum != goalareanum && (maxareas == 0 || i < maxareas) && i < aasworld.numareas {
        reachnum = AAS_AreaReachabilityToGoalArea(curareanum, curorigin, goalareanum, travelflags)
        if reachnum == 0 {
            route.stopevent = RSE_NOROUTE
            return 0
        } //end if
        reach = aasworld.reachabilitySlots[reachnum]
        //
        if (stopevent & RSE_USETRAVELTYPE) != 0 {
            if (AAS_TravelFlagForType_inline(reach.traveltype) & stoptfl) != 0 {
                route.stopevent = RSE_USETRAVELTYPE
                route.endarea = curareanum
                route.endcontents = aasworld.areasettingsSlots[curareanum].contents
                route.endtravelflags = AAS_TravelFlagForType_inline(reach.traveltype)
                route.endpos = reach.start
                return 1
            } //end if
            if (AAS_AreaContentsTravelFlags_inline(reach.areanum) & stoptfl) != 0 {
                route.stopevent = RSE_USETRAVELTYPE
                route.endarea = reach.areanum
                route.endcontents = aasworld.areasettingsSlots[reach.areanum].contents
                route.endtravelflags = AAS_AreaContentsTravelFlags_inline(reach.areanum)
                route.endpos = reach.end
                route.time += AAS_AreaTravelTime(areanum, origin, reach.start)
                route.time += reach.traveltime
                return 1
            } //end if
        } //end if
        reachareas = aasworld.reachabilityareasSlots[reachnum]
        j = 0
        while j < reachareas.numareas + 1 {
            if j >= reachareas.numareas {
                testareanum = reach.areanum
            } else {
                testareanum = aasworld.reachabilityareaindex![reachareas.firstarea + j]
            }
            if (stopevent & RSE_ENTERCONTENTS) != 0 {
                if (aasworld.areasettingsSlots[testareanum].contents & stopcontents) != 0 {
                    route.stopevent = RSE_ENTERCONTENTS
                    route.endarea = testareanum
                    route.endcontents = aasworld.areasettingsSlots[testareanum].contents
                    route.endpos = reach.end
                    route.time += AAS_AreaTravelTime(areanum, origin, reach.start)
                    route.time += reach.traveltime
                    return 1
                } //end if
            } //end if
            if (stopevent & RSE_ENTERAREA) != 0 {
                if testareanum == stopareanum {
                    route.stopevent = RSE_ENTERAREA
                    route.endarea = testareanum
                    route.endcontents = aasworld.areasettingsSlots[testareanum].contents
                    route.endpos = reach.start
                    return 1
                } //end if
            } //end if
            j += 1
        } //end for

        route.time += AAS_AreaTravelTime(areanum, origin, reach.start)
        route.time += reach.traveltime
        route.endarea = reach.areanum
        route.endcontents = aasworld.areasettingsSlots[reach.areanum].contents
        route.endtravelflags = AAS_TravelFlagForType_inline(reach.traveltype)
        route.endpos = reach.end
        //
        curareanum = reach.areanum
        curorigin = reach.end
        //
        if maxtime != 0 && route.time > maxtime {
            break
        }
        i += 1
    } //end while
    if curareanum != goalareanum {
        return 0
    }
    return 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
// Port-note: Raven calls this function from no file of either tree, so it is dead.
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1892
func AAS_BridgeWalkable(_ areanum: Int32) -> Int32 {
    // TODO: Port AAS_BridgeWalkable
    portMissing("AAS_BridgeWalkable", source: "oracle/codemp/botlib/be_aas_route.cpp:1892")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1902
func AAS_ReachabilityFromNum(_ num: Int32, _ reach: AasReachability) {
    if aasworld.initialized == 0 {
        reach.clear()
        return
    } //end if
    if num < 0 || num >= aasworld.reachabilitysize {
        reach.clear()
        return
    } //end if
    reach.copy(from: aasworld.reachabilitySlots[num])
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1922
func AAS_NextAreaReachability(_ areanum: Int32, _ reachnum: Int32) -> Int32 {
    // Raven assigns his own `reachnum` parameter. A Swift parameter is immutable, so the body takes a mutable copy.
    var reachnum = reachnum
    var settings: AasAreasettings

    if aasworld.initialized == 0 {
        return 0
    }

    if areanum <= 0 || areanum >= aasworld.numareas {
        botimport.runPrint(PRT_ERROR, "AAS_NextAreaReachability: areanum %d out of range\n", areanum)
        return 0
    } //end if

    settings = aasworld.areasettingsSlots[areanum]
    if reachnum == 0 {
        return settings.firstreachablearea
    } //end if
    if reachnum < settings.firstreachablearea {
        botimport.runPrint(PRT_FATAL, "AAS_NextAreaReachability: reachnum < settings->firstreachableara")
        return 0
    } //end if
    reachnum += 1
    if reachnum >= settings.firstreachablearea + settings.numreachableareas {
        return 0
    } //end if
    return reachnum
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1957
func AAS_NextModelReachability(_ num: Int32, _ modelnum: Int32) -> Int32 {
    // Raven assigns his own `num` parameter. A Swift parameter is immutable, so the body takes a mutable copy.
    var num = num
    var i: Int32

    if num <= 0 {
        num = 1
    } else if num >= aasworld.reachabilitysize {
        return 0
    } else {
        num += 1
    }
    //
    i = num
    while i < aasworld.reachabilitysize {
        if (aasworld.reachabilitySlots[i].traveltype & TRAVELTYPE_MASK) == TRAVEL_ELEVATOR {
            if aasworld.reachabilitySlots[i].facenum == modelnum {
                return i
            }
        } //end if
        else if (aasworld.reachabilitySlots[i].traveltype & TRAVELTYPE_MASK) == TRAVEL_FUNCBOB {
            if (aasworld.reachabilitySlots[i].facenum & 0x0000FFFF) == modelnum {
                return i
            }
        } //end if
        i += 1
    } //end for
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:1984
func AAS_RandomGoalArea(_ areanum: Int32, _ travelflags: Int32, _ goalareanum: inout Int32, _ goalorigin: inout JKAShared.vec3_t) -> Int32 {
    var i: Int32
    var n: Int32
    var t: Int32
    var start = vec3_t()
    var end = vec3_t()

    //if the area has no reachabilities
    if AAS_AreaReachability(areanum) == 0 {
        return 0
    }
    //
    n = Int32(aasworld.numareas * random())
    i = 0
    while i < aasworld.numareas {
        if n <= 0 {
            n = 1
        }
        if n >= aasworld.numareas {
            n = 1
        }
        if AAS_AreaReachability(n) != 0 {
            t = AAS_AreaTravelTimeToGoalArea(areanum, aasworld.areasSlots[areanum].center, n, travelflags)
            //if the goal is reachable
            if t > 0 {
                if AAS_AreaSwim(n) != 0 {
                    goalareanum = n
                    goalorigin = aasworld.areasSlots[n].center
                    //botimport.Print(PRT_MESSAGE, "found random goal area %d\n", *goalareanum);
                    return 1
                } //end if
                start = aasworld.areasSlots[n].center
                if AAS_PointAreaNum(start) == 0 {
                    Log_Write("area %d center %f %f %f in solid?", n, start[0], start[1], start[2])
                }
                end = start
                end[2] -= 300
                let found = AasTrace.scratch { trace -> Bool in
                    trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, -1))
                    if !trace.startsolid && trace.fraction < 1 && AAS_PointAreaNum(trace.endpos) == n {
                        if AAS_AreaGroundFaceArea(n) > 300 {
                            goalareanum = n
                            goalorigin = trace.endpos
                            //botimport.Print(PRT_MESSAGE, "found random goal area %d\n", *goalareanum);
                            return true
                        } //end if
                    } //end if
                    return false
                }
                if found {
                    return 1
                }
            } //end if
        } //end if
        n += 1
        i += 1
    } //end for
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_route.cpp:2039
func AAS_AreaVisible(_ srcarea: Int32, _ destarea: Int32) -> Int32 {
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
// Port-note: Raven calls this function from no file of either tree, so it is dead.
/// Source: oracle/codemp/botlib/be_aas_route.cpp:2049
func DistancePointToLine(_ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t, _ point: JKAShared.vec3_t) -> Float {
    // TODO: Port DistancePointToLine
    portMissing("DistancePointToLine", source: "oracle/codemp/botlib/be_aas_route.cpp:2049")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
// Port-note: Raven calls this function from no file of either tree, so it is dead.
/// Source: oracle/codemp/botlib/be_aas_route.cpp:2063
func AAS_NearestHideArea(_ srcnum: Int32, _ origin: JKAShared.vec3_t, _ areanum: Int32, _ enemynum: Int32, _ enemyorigin: JKAShared.vec3_t, _ enemyareanum: Int32, _ travelflags: Int32) -> Int32 {
    // TODO: Port AAS_NearestHideArea
    portMissing("AAS_NearestHideArea", source: "oracle/codemp/botlib/be_aas_route.cpp:2063")
}
