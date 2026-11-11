import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:31
let AAS_MAX_PORTALS = 65536 as Int32

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:32
let AAS_MAX_PORTALINDEXSIZE = 65536 as Int32

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:33
let AAS_MAX_CLUSTERS = 65536 as Int32

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:35
let MAX_PORTALAREAS = 1024 as Int32

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:38
// Raven wrote: int nofaceflood = qtrue
let nofaceflood: Int32 = 1

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:708
// AI: Raven declares `connectedareas` on the stack of AAS_ConnectedAreas. The function uses one zeroed allocation on the storage class.
var connectedareas_AAS_ConnectedAreas: Slots<Int32> { world.storage.connectedareas_AAS_ConnectedAreas }

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:779
// AI: Raven declares `areanums` on the stack of AAS_CheckAreaForPossiblePortals. The function uses one zeroed allocation on the storage class.
var areanums_AAS_CheckAreaForPossiblePortals: Slots<Int32> { world.storage.areanums_AAS_CheckAreaForPossiblePortals }

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:783
// AI: Raven declares `frontareanums` on the stack of AAS_CheckAreaForPossiblePortals. The function uses one zeroed allocation on the storage class.
var frontareanums_AAS_CheckAreaForPossiblePortals: Slots<Int32> { world.storage.frontareanums_AAS_CheckAreaForPossiblePortals }

/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:783
// AI: Raven declares `backareanums` on the stack of AAS_CheckAreaForPossiblePortals. The function uses one zeroed allocation on the storage class.
var backareanums_AAS_CheckAreaForPossiblePortals: Slots<Int32> { world.storage.backareanums_AAS_CheckAreaForPossiblePortals }

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:46
public func AAS_RemoveClusterAreas() {
    var i: Int32

    i = 1
    while i < aasworld.numareas {
        aasworld.areasettingsSlots[i].cluster = 0
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:61
public func AAS_ClearCluster(_ clusternum: Int32) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var i: Int32

    i = 1
    while i < aasworld.numareas {
        if aasworld.areasettingsSlots[i].cluster == clusternum {
            aasworld.areasettingsSlots[i].cluster = 0
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
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:79
public func AAS_RemovePortalsClusterReference(_ clusternum: Int32) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var portalnum: Int32

    portalnum = 1
    while portalnum < aasworld.numportals {
        if aasworld.portalsSlots[portalnum].frontcluster == clusternum {
            aasworld.portalsSlots[portalnum].frontcluster = 0
        } //end if
        if aasworld.portalsSlots[portalnum].backcluster == clusternum {
            aasworld.portalsSlots[portalnum].backcluster = 0
        } //end if
        portalnum += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:101
public func AAS_UpdatePortal(_ areanum: Int32, _ clusternum: Int32) -> Int32 {
    var portalnum: Int32
    let portal: AasPortal
    let cluster: AasCluster

    //find the portal of the area
    portalnum = 1
    while portalnum < aasworld.numportals {
        if aasworld.portalsSlots[portalnum].areanum == areanum {
            break
        }
        portalnum += 1
    } //end for
    //
    if portalnum == aasworld.numportals {
        AAS_Error("no portal of area %d", areanum)
        return 1
    } //end if
    //
    portal = aasworld.portalsSlots[portalnum]
    //if the portal is already fully updated
    if portal.frontcluster == clusternum {
        return 1
    }
    if portal.backcluster == clusternum {
        return 1
    }
    //if the portal has no front cluster yet
    if portal.frontcluster == 0 {
        portal.frontcluster = clusternum
    } //end if
    //if the portal has no back cluster yet
    else if portal.backcluster == 0 {
        portal.backcluster = clusternum
    } //end else if
    else {
        //remove the cluster portal flag contents
        aasworld.areasettingsSlots[areanum].contents &= ~AREACONTENTS_CLUSTERPORTAL
        Log_Write("portal area %d is seperating more than two clusters\r\n", areanum)
        return 0
    } //end else
    if aasworld.portalindexsize >= AAS_MAX_PORTALINDEXSIZE {
        AAS_Error("AAS_MAX_PORTALINDEXSIZE")
        return 1
    } //end if
    //set the area cluster number to the negative portal number
    aasworld.areasettingsSlots[areanum].cluster = -portalnum
    //add the portal to the cluster using the portal index
    cluster = aasworld.clustersSlots[clusternum]
    aasworld.portalindex![cluster.firstportal + cluster.numportals] = portalnum
    aasworld.portalindexsize += 1
    cluster.numportals += 1
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:160
public func AAS_FloodClusterAreas_r(_ areanum: Int32, _ clusternum: Int32) -> Int32 {
    let area: AasArea
    var face: AasFace
    var facenum: Int32
    var i: Int32

    //
    if areanum <= 0 || areanum >= aasworld.numareas {
        AAS_Error("AAS_FloodClusterAreas_r: areanum out of range")
        return 0
    } //end if
    //if the area is already part of a cluster
    if aasworld.areasettingsSlots[areanum].cluster > 0 {
        if aasworld.areasettingsSlots[areanum].cluster == clusternum {
            return 1
        }
        //
        //there's a reachability going from one cluster to another only in one direction
        //
        AAS_Error("cluster %d touched cluster %d at area %d\r\n", clusternum, aasworld.areasettingsSlots[areanum].cluster, areanum)
        return 0
    } //end if
    //don't add the cluster portal areas to the clusters
    if (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
        return AAS_UpdatePortal(areanum, clusternum)
    } //end if
    //set the area cluster number
    aasworld.areasettingsSlots[areanum].cluster = clusternum
    aasworld.areasettingsSlots[areanum].clusterareanum = aasworld.clustersSlots[clusternum].numareas
    //the cluster has an extra area
    aasworld.clustersSlots[clusternum].numareas += 1

    area = aasworld.areasSlots[areanum]
    //use area faces to flood into adjacent areas
    if nofaceflood == 0 {
        i = 0
        while i < area.numfaces {
            facenum = abs(aasworld.faceindex![area.firstface + i])
            face = aasworld.facesSlots[facenum]
            if face.frontarea == areanum {
                if face.backarea != 0 {
                    if AAS_FloodClusterAreas_r(face.backarea, clusternum) == 0 {
                        return 0
                    }
                }
            } //end if
            else {
                if face.frontarea != 0 {
                    if AAS_FloodClusterAreas_r(face.frontarea, clusternum) == 0 {
                        return 0
                    }
                }
            } //end else
            i += 1
        } //end for
    } //end if
    //use the reachabilities to flood into other areas
    i = 0
    while i < aasworld.areasettingsSlots[areanum].numreachableareas {
        if aasworld.reachabilitySlots[aasworld.areasettingsSlots[areanum].firstreachablearea + i].areanum == 0 {
            i += 1
            continue
        } //end if
        if AAS_FloodClusterAreas_r(aasworld.reachabilitySlots[aasworld.areasettingsSlots[areanum].firstreachablearea + i].areanum, clusternum) == 0 {
            return 0
        }
        i += 1
    } //end for
    return 1
}

//===========================================================================
// try to flood from all areas without cluster into areas with a cluster set
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:233
public func AAS_FloodClusterAreasUsingReachabilities(_ clusternum: Int32) -> Int32 {
    var i: Int32
    var j: Int32
    var areanum: Int32

    i = 1
    while i < aasworld.numareas {
        //if this area already has a cluster set
        if aasworld.areasettingsSlots[i].cluster != 0 {
            i += 1
            continue
        }
        //if this area is a cluster portal
        if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
            i += 1
            continue
        }
        //loop over the reachable areas from this area
        j = 0
        while j < aasworld.areasettingsSlots[i].numreachableareas {
            //the reachable area
            areanum = aasworld.reachabilitySlots[aasworld.areasettingsSlots[i].firstreachablearea + j].areanum
            //if this area is a cluster portal
            if (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
                j += 1
                continue
            }
            //if this area has a cluster set
            if aasworld.areasettingsSlots[areanum].cluster != 0 {
                if AAS_FloodClusterAreas_r(i, clusternum) == 0 {
                    return 0
                }
                i = 0
                break
            } //end if
            j += 1
        } //end for
        i += 1
    } //end for
    return 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:271
public func AAS_NumberClusterPortals(_ clusternum: Int32) {
    // Port-note: Raven calls this function only from a comment, at be_aas_cluster.cpp:409, so it is dead.
    var i: Int32
    var portalnum: Int32
    let cluster: AasCluster
    var portal: AasPortal

    cluster = aasworld.clustersSlots[clusternum]
    i = 0
    while i < cluster.numportals {
        portalnum = aasworld.portalindex![cluster.firstportal + i]
        portal = aasworld.portalsSlots[portalnum]
        if portal.frontcluster == clusternum {
            portal.clusterareanum[0] = cluster.numareas
            cluster.numareas += 1
        } //end if
        else {
            portal.clusterareanum[1] = cluster.numareas
            cluster.numareas += 1
        } //end else
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:298
public func AAS_NumberClusterAreas(_ clusternum: Int32) {
    var i: Int32
    var portalnum: Int32
    var cluster: AasCluster
    var portal: AasPortal

    aasworld.clustersSlots[clusternum].numareas = 0
    aasworld.clustersSlots[clusternum].numreachabilityareas = 0
    //number all areas in this cluster WITH reachabilities
    i = 1
    while i < aasworld.numareas {
        //
        if aasworld.areasettingsSlots[i].cluster != clusternum {
            i += 1
            continue
        }
        //
        if AAS_AreaReachability(i) == 0 {
            i += 1
            continue
        }
        //
        aasworld.areasettingsSlots[i].clusterareanum = aasworld.clustersSlots[clusternum].numareas
        //the cluster has an extra area
        aasworld.clustersSlots[clusternum].numareas += 1
        aasworld.clustersSlots[clusternum].numreachabilityareas += 1
        i += 1
    } //end for
    //number all portals in this cluster WITH reachabilities
    cluster = aasworld.clustersSlots[clusternum]
    i = 0
    while i < cluster.numportals {
        portalnum = aasworld.portalindex![cluster.firstportal + i]
        portal = aasworld.portalsSlots[portalnum]
        if AAS_AreaReachability(portal.areanum) == 0 {
            i += 1
            continue
        }
        if portal.frontcluster == clusternum {
            portal.clusterareanum[0] = cluster.numareas
            cluster.numareas += 1
            aasworld.clustersSlots[clusternum].numreachabilityareas += 1
        } //end if
        else {
            portal.clusterareanum[1] = cluster.numareas
            cluster.numareas += 1
            aasworld.clustersSlots[clusternum].numreachabilityareas += 1
        } //end else
        i += 1
    } //end for
    //number all areas in this cluster WITHOUT reachabilities
    i = 1
    while i < aasworld.numareas {
        //
        if aasworld.areasettingsSlots[i].cluster != clusternum {
            i += 1
            continue
        }
        //
        if AAS_AreaReachability(i) != 0 {
            i += 1
            continue
        }
        //
        aasworld.areasettingsSlots[i].clusterareanum = aasworld.clustersSlots[clusternum].numareas
        //the cluster has an extra area
        aasworld.clustersSlots[clusternum].numareas += 1
        i += 1
    } //end for
    //number all portals in this cluster WITHOUT reachabilities
    cluster = aasworld.clustersSlots[clusternum]
    i = 0
    while i < cluster.numportals {
        portalnum = aasworld.portalindex![cluster.firstportal + i]
        portal = aasworld.portalsSlots[portalnum]
        if AAS_AreaReachability(portal.areanum) != 0 {
            i += 1
            continue
        }
        if portal.frontcluster == clusternum {
            portal.clusterareanum[0] = cluster.numareas
            cluster.numareas += 1
        } //end if
        else {
            portal.clusterareanum[1] = cluster.numareas
            cluster.numareas += 1
        } //end else
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:372
public func AAS_FindClusters() -> Int32 {
    var i: Int32
    var cluster: AasCluster

    AAS_RemoveClusterAreas()
    //
    i = 1
    while i < aasworld.numareas {
        //if the area is already part of a cluster
        if aasworld.areasettingsSlots[i].cluster != 0 {
            i += 1
            continue
        }
        // if not flooding through faces only use areas that have reachabilities
        if nofaceflood != 0 {
            if aasworld.areasettingsSlots[i].numreachableareas == 0 {
                i += 1
                continue
            }
        } //end if
        //if the area is a cluster portal
        if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
            i += 1
            continue
        }
        if aasworld.numclusters >= AAS_MAX_CLUSTERS {
            AAS_Error("AAS_MAX_CLUSTERS")
            return 0
        } //end if
        cluster = aasworld.clustersSlots[aasworld.numclusters]
        cluster.numareas = 0
        cluster.numreachabilityareas = 0
        cluster.firstportal = aasworld.portalindexsize
        cluster.numportals = 0
        //flood the areas in this cluster
        if AAS_FloodClusterAreas_r(i, aasworld.numclusters) == 0 {
            return 0
        }
        if AAS_FloodClusterAreasUsingReachabilities(aasworld.numclusters) == 0 {
            return 0
        }
        //number the cluster areas
        //AAS_NumberClusterPortals(aasworld.numclusters);
        AAS_NumberClusterAreas(aasworld.numclusters)
        //Log_Write("cluster %d has %d areas\r\n", aasworld.numclusters, cluster->numareas);
        aasworld.numclusters += 1
        i += 1
    } //end for
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:422
public func AAS_CreatePortals() {
    var i: Int32
    var portal: AasPortal

    i = 1
    while i < aasworld.numareas {
        //if the area is a cluster portal
        if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
            if aasworld.numportals >= AAS_MAX_PORTALS {
                AAS_Error("AAS_MAX_PORTALS")
                return
            } //end if
            portal = aasworld.portalsSlots[aasworld.numportals]
            portal.areanum = i
            portal.frontcluster = 0
            portal.backcluster = 0
            aasworld.numportals += 1
        } //end if
        i += 1
    } //end for
}

/**
```
//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
int AAS_MapContainsTeleporters(void)
{
	bsp_entity_t *entities, *ent;
	char *classname;

	entities = AAS_ParseBSPEntities();

	for (ent = entities; ent; ent = ent->next)
	{
		classname = AAS_ValueForBSPEpairKey(ent, "classname");
		if (classname && !strcmp(classname, "misc_teleporter"))
		{
			AAS_FreeBSPEntities(entities);
			return qtrue;
		} //end if
	} //end for
	return qfalse;
} //end of the function AAS_MapContainsTeleporters
//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
int AAS_NonConvexFaces(aas_face_t *face1, aas_face_t *face2, int side1, int side2)
{
	int i, j, edgenum;
	aas_plane_t *plane1, *plane2;
	aas_edge_t *edge;


	plane1 = &aasworld.planes[face1->planenum ^ side1];
	plane2 = &aasworld.planes[face2->planenum ^ side2];

	//check if one of the points of face1 is at the back of the plane of face2
	for (i = 0; i < face1->numedges; i++)
	{
		edgenum = abs(aasworld.edgeindex[face1->firstedge + i]);
		edge = &aasworld.edges[edgenum];
		for (j = 0; j < 2; j++)
		{
			if (DotProduct(plane2->normal, aasworld.vertexes[edge->v[j]]) -
							plane2->dist < -0.01) return qtrue;
		} //end for
	} //end for
	for (i = 0; i < face2->numedges; i++)
	{
		edgenum = abs(aasworld.edgeindex[face2->firstedge + i]);
		edge = &aasworld.edges[edgenum];
		for (j = 0; j < 2; j++)
		{
			if (DotProduct(plane1->normal, aasworld.vertexes[edge->v[j]]) -
							plane1->dist < -0.01) return qtrue;
		} //end for
	} //end for

	return qfalse;
} //end of the function AAS_NonConvexFaces
//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
qboolean AAS_CanMergeAreas(int *areanums, int numareas)
{
	int i, j, s, face1num, face2num, side1, side2, fn1, fn2;
	aas_face_t *face1, *face2;
	aas_area_t *area1, *area2;

	for (i = 0; i < numareas; i++)
	{
		area1 = &aasworld.areas[areanums[i]];
		for (fn1 = 0; fn1 < area1->numfaces; fn1++)
		{
			face1num = abs(aasworld.faceindex[area1->firstface + fn1]);
			face1 = &aasworld.faces[face1num];
			side1 = face1->frontarea != areanums[i];
			//check if the face isn't a shared one with one of the other areas
			for (s = 0; s < numareas; s++)
			{
				if (s == i) continue;
				if (face1->frontarea == s || face1->backarea == s) break;
			} //end for
			//if the face was a shared one
			if (s != numareas) continue;
			//
			for (j = 0; j < numareas; j++)
			{
				if (j == i) continue;
				area2 = &aasworld.areas[areanums[j]];
				for (fn2 = 0; fn2 < area2->numfaces; fn2++)
				{
					face2num = abs(aasworld.faceindex[area2->firstface + fn2]);
					face2 = &aasworld.faces[face2num];
					side2 = face2->frontarea != areanums[j];
					//check if the face isn't a shared one with one of the other areas
					for (s = 0; s < numareas; s++)
					{
						if (s == j) continue;
						if (face2->frontarea == s || face2->backarea == s) break;
					} //end for
					//if the face was a shared one
					if (s != numareas) continue;
					//
					if (AAS_NonConvexFaces(face1, face2, side1, side2)) return qfalse;
				} //end for
			} //end for
		} //end for
	} //end for
	return qtrue;
} //end of the function AAS_CanMergeAreas
//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
qboolean AAS_NonConvexEdges(aas_edge_t *edge1, aas_edge_t *edge2, int side1, int side2, int planenum)
{
	int i;
	vec3_t edgevec1, edgevec2, normal1, normal2;
	float dist1, dist2;
	aas_plane_t *plane;

	plane = &aasworld.planes[planenum];
	VectorSubtract(aasworld.vertexes[edge1->v[1]], aasworld.vertexes[edge1->v[0]], edgevec1);
	VectorSubtract(aasworld.vertexes[edge2->v[1]], aasworld.vertexes[edge2->v[0]], edgevec2);
	if (side1) VectorInverse(edgevec1);
	if (side2) VectorInverse(edgevec2);
	//
	CrossProduct(edgevec1, plane->normal, normal1);
	dist1 = DotProduct(normal1, aasworld.vertexes[edge1->v[0]]);
	CrossProduct(edgevec2, plane->normal, normal2);
	dist2 = DotProduct(normal2, aasworld.vertexes[edge2->v[0]]);

	for (i = 0; i < 2; i++)
	{
		if (DotProduct(aasworld.vertexes[edge1->v[i]], normal2) - dist2 < -0.01) return qfalse;
	} //end for
	for (i = 0; i < 2; i++)
	{
		if (DotProduct(aasworld.vertexes[edge2->v[i]], normal1) - dist1 < -0.01) return qfalse;
	} //end for
	return qtrue;
} //end of the function AAS_NonConvexEdges
//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
qboolean AAS_CanMergeFaces(int *facenums, int numfaces, int planenum)
{
	int i, j, s, edgenum1, edgenum2, side1, side2, en1, en2, ens;
	aas_face_t *face1, *face2, *otherface;
	aas_edge_t *edge1, *edge2;

	for (i = 0; i < numfaces; i++)
	{
		face1 = &aasworld.faces[facenums[i]];
		for (en1 = 0; en1 < face1->numedges; en1++)
		{
			edgenum1 = aasworld.edgeindex[face1->firstedge + en1];
			side1 = (edgenum1 < 0) ^ (face1->planenum != planenum);
			edgenum1 = abs(edgenum1);
			edge1 = &aasworld.edges[edgenum1];
			//check if the edge is shared with another face
			for (s = 0; s < numfaces; s++)
			{
				if (s == i) continue;
				otherface = &aasworld.faces[facenums[s]];
				for (ens = 0; ens < otherface->numedges; ens++)
				{
					if (edgenum1 == abs(aasworld.edgeindex[otherface->firstedge + ens])) break;
				} //end for
				if (ens != otherface->numedges) break;
			} //end for
			//if the edge was shared
			if (s != numfaces) continue;
			//
			for (j = 0; j < numfaces; j++)
			{
				if (j == i) continue;
				face2 = &aasworld.faces[facenums[j]];
				for (en2 = 0; en2 < face2->numedges; en2++)
				{
					edgenum2 = aasworld.edgeindex[face2->firstedge + en2];
					side2 = (edgenum2 < 0) ^ (face2->planenum != planenum);
					edgenum2 = abs(edgenum2);
					edge2 = &aasworld.edges[edgenum2];
					//check if the edge is shared with another face
					for (s = 0; s < numfaces; s++)
					{
						if (s == i) continue;
						otherface = &aasworld.faces[facenums[s]];
						for (ens = 0; ens < otherface->numedges; ens++)
						{
							if (edgenum2 == abs(aasworld.edgeindex[otherface->firstedge + ens])) break;
						} //end for
						if (ens != otherface->numedges) break;
					} //end for
					//if the edge was shared
					if (s != numfaces) continue;
					//
					if (AAS_NonConvexEdges(edge1, edge2, side1, side2, planenum)) return qfalse;
				} //end for
			} //end for
		} //end for
	} //end for
	return qtrue;
} //end of the function AAS_CanMergeFaces
```
*/
//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:670
public func AAS_ConnectedAreas_r(_ areanums: Slots<Int32>, _ numareas: Int32, _ connectedareas: Slots<Int32>, _ curarea: Int32) {
    var i: Int32
    var j: Int32
    var otherareanum: Int32
    var facenum: Int32
    let area: AasArea
    var face: AasFace

    connectedareas[curarea] = 1
    area = aasworld.areasSlots[areanums[curarea]]
    i = 0
    while i < area.numfaces {
        facenum = abs(aasworld.faceindex![area.firstface + i])
        face = aasworld.facesSlots[facenum]
        //if the face is solid
        if (face.faceflags & FACE_SOLID) != 0 {
            i += 1
            continue
        }
        //get the area at the other side of the face
        if face.frontarea != areanums[curarea] {
            otherareanum = face.frontarea
        } else {
            otherareanum = face.backarea
        }
        //check if the face is leading to one of the other areas
        j = 0
        while j < numareas {
            if areanums[j] == otherareanum {
                break
            }
            j += 1
        } //end for
        //if the face isn't leading to one of the other areas
        if j == numareas {
            i += 1
            continue
        }
        //if the other area is already connected
        if connectedareas[j] != 0 {
            i += 1
            continue
        }
        //recursively proceed with the other area
        AAS_ConnectedAreas_r(areanums, numareas, connectedareas, j)
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:706
public func AAS_ConnectedAreas(_ areanums: Slots<Int32>, _ numareas: Int32) -> Bool {
    var i: Int32

    connectedareas_AAS_ConnectedAreas.zero()
    if numareas < 1 {
        return false
    }
    if numareas == 1 {
        return true
    }
    AAS_ConnectedAreas_r(areanums, numareas, connectedareas_AAS_ConnectedAreas, 0)
    i = 0
    while i < numareas {
        if connectedareas_AAS_ConnectedAreas[i] == 0 {
            return false
        }
        i += 1
    } //end for
    return true
}

//===========================================================================
// gets adjacent areas with less presence types recursively
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:727
public func AAS_GetAdjacentAreasWithLessPresenceTypes_r(_ areanums: Slots<Int32>, _ numareas: Int32, _ curareanum: Int32) -> Int32 {
    // Raven assigns his own `numareas` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var numareas = numareas
    var i: Int32
    var j: Int32
    let presencetype: Int32
    var otherpresencetype: Int32
    var otherareanum: Int32
    var facenum: Int32
    let area: AasArea
    var face: AasFace

    areanums[numareas] = curareanum
    numareas += 1
    area = aasworld.areasSlots[curareanum]
    presencetype = aasworld.areasettingsSlots[curareanum].presencetype
    i = 0
    while i < area.numfaces {
        facenum = abs(aasworld.faceindex![area.firstface + i])
        face = aasworld.facesSlots[facenum]
        //if the face is solid
        if (face.faceflags & FACE_SOLID) != 0 {
            i += 1
            continue
        }
        //the area at the other side of the face
        if face.frontarea != curareanum {
            otherareanum = face.frontarea
        } else {
            otherareanum = face.backarea
        }
        //
        otherpresencetype = aasworld.areasettingsSlots[otherareanum].presencetype
        //if the other area has less presence types
        if (presencetype & ~otherpresencetype) != 0 && (otherpresencetype & ~presencetype) == 0 {
            //check if the other area isn't already in the list
            j = 0
            while j < numareas {
                if otherareanum == areanums[j] {
                    break
                }
                j += 1
            } //end for
            //if the other area isn't already in the list
            if j == numareas {
                if numareas >= MAX_PORTALAREAS {
                    AAS_Error("MAX_PORTALAREAS")
                    return numareas
                } //end if
                numareas = AAS_GetAdjacentAreasWithLessPresenceTypes_r(areanums, numareas, otherareanum)
            } //end if
        } //end if
        i += 1
    } //end for
    return numareas
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:776
public func AAS_CheckAreaForPossiblePortals(_ areanum: Int32) -> Int32 {
    var i: Int32
    var j: Int32
    var k: Int32
    var fen: Int32
    var ben: Int32
    var frontedgenum: Int32
    var backedgenum: Int32
    var facenum: Int32
    var numareas: Int32
    var otherareanum: Int32
    var numareafrontfaces = [Int32](repeating: 0, count: Int(MAX_PORTALAREAS))
    var numareabackfaces = [Int32](repeating: 0, count: Int(MAX_PORTALAREAS))
    var frontfacenums = [Int32](repeating: 0, count: Int(MAX_PORTALAREAS))
    var backfacenums = [Int32](repeating: 0, count: Int(MAX_PORTALAREAS))
    var numfrontfaces: Int32
    var numbackfaces: Int32
    var numfrontareas: Int32
    var numbackareas: Int32
    var frontplanenum: Int32
    var backplanenum: Int32
    var faceplanenum: Int32
    var area: AasArea
    var frontface: AasFace
    var backface: AasFace
    var face: AasFace

    //if it isn't already a portal
    if (aasworld.areasettingsSlots[areanum].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
        return 0
    }
    //it must be a grounded area
    if (aasworld.areasettingsSlots[areanum].areaflags & AREA_GROUNDED) == 0 {
        return 0
    }
    //
    numareafrontfaces.fill(0)
    numareabackfaces.fill(0)
    numbackfaces = 0
    numfrontfaces = numbackfaces
    numareas = numfrontfaces
    numbackareas = 0
    numfrontareas = numbackareas
    backplanenum = -1
    frontplanenum = backplanenum
    //add any adjacent areas with less presence types
    numareas = AAS_GetAdjacentAreasWithLessPresenceTypes_r(areanums_AAS_CheckAreaForPossiblePortals, 0, areanum)
    //
    i = 0
    while i < numareas {
        area = aasworld.areasSlots[areanums_AAS_CheckAreaForPossiblePortals[i]]
        j = 0
        while j < area.numfaces {
            facenum = abs(aasworld.faceindex![area.firstface + j])
            face = aasworld.facesSlots[facenum]
            //if the face is solid
            if (face.faceflags & FACE_SOLID) != 0 {
                j += 1
                continue
            }
            //check if the face is shared with one of the other areas
            k = 0
            while k < numareas {
                if k == i {
                    k += 1
                    continue
                }
                if face.frontarea == areanums_AAS_CheckAreaForPossiblePortals[k] || face.backarea == areanums_AAS_CheckAreaForPossiblePortals[k] {
                    break
                }
                k += 1
            } //end for
            //if the face is shared
            if k != numareas {
                j += 1
                continue
            }
            //the number of the area at the other side of the face
            if face.frontarea == areanums_AAS_CheckAreaForPossiblePortals[i] {
                otherareanum = face.backarea
            } else {
                otherareanum = face.frontarea
            }
            //if the other area already is a cluter portal
            if (aasworld.areasettingsSlots[otherareanum].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
                return 0
            }
            //number of the plane of the area
            faceplanenum = face.planenum & ~1
            //
            if frontplanenum < 0 || faceplanenum == frontplanenum {
                frontplanenum = faceplanenum
                frontfacenums[numfrontfaces] = facenum
                numfrontfaces += 1
                k = 0
                while k < numfrontareas {
                    if frontareanums_AAS_CheckAreaForPossiblePortals[k] == otherareanum {
                        break
                    }
                    k += 1
                } //end for
                if k == numfrontareas {
                    frontareanums_AAS_CheckAreaForPossiblePortals[numfrontareas] = otherareanum
                    numfrontareas += 1
                }
                numareafrontfaces[i] += 1
            } //end if
            else if backplanenum < 0 || faceplanenum == backplanenum {
                backplanenum = faceplanenum
                backfacenums[numbackfaces] = facenum
                numbackfaces += 1
                k = 0
                while k < numbackareas {
                    if backareanums_AAS_CheckAreaForPossiblePortals[k] == otherareanum {
                        break
                    }
                    k += 1
                } //end for
                if k == numbackareas {
                    backareanums_AAS_CheckAreaForPossiblePortals[numbackareas] = otherareanum
                    numbackareas += 1
                }
                numareabackfaces[i] += 1
            } //end else
            else {
                return 0
            } //end else
            j += 1
        } //end for
        i += 1
    } //end for
    //every area should have at least one front face and one back face
    i = 0
    while i < numareas {
        if numareafrontfaces[i] == 0 || numareabackfaces[i] == 0 {
            return 0
        }
        i += 1
    } //end for
    //the front areas should all be connected
    if !AAS_ConnectedAreas(frontareanums_AAS_CheckAreaForPossiblePortals, numfrontareas) {
        return 0
    }
    //the back areas should all be connected
    if !AAS_ConnectedAreas(backareanums_AAS_CheckAreaForPossiblePortals, numbackareas) {
        return 0
    }
    //none of the front faces should have a shared edge with a back face
    i = 0
    while i < numfrontfaces {
        frontface = aasworld.facesSlots[frontfacenums[i]]
        fen = 0
        while fen < frontface.numedges {
            frontedgenum = abs(aasworld.edgeindex![frontface.firstedge + fen])
            j = 0
            while j < numbackfaces {
                backface = aasworld.facesSlots[backfacenums[j]]
                ben = 0
                while ben < backface.numedges {
                    backedgenum = abs(aasworld.edgeindex![backface.firstedge + ben])
                    if frontedgenum == backedgenum {
                        break
                    }
                    ben += 1
                } //end for
                if ben != backface.numedges {
                    break
                }
                j += 1
            } //end for
            if j != numbackfaces {
                break
            }
            fen += 1
        } //end for
        if fen != frontface.numedges {
            break
        }
        i += 1
    } //end for
    if i != numfrontfaces {
        return 0
    }
    //set the cluster portal contents
    i = 0
    while i < numareas {
        aasworld.areasettingsSlots[areanums_AAS_CheckAreaForPossiblePortals[i]].contents |= AREACONTENTS_CLUSTERPORTAL
        //this area can be used as a route portal
        aasworld.areasettingsSlots[areanums_AAS_CheckAreaForPossiblePortals[i]].contents |= AREACONTENTS_ROUTEPORTAL
        Log_Write("possible portal: %d\r\n", areanums_AAS_CheckAreaForPossiblePortals[i])
        i += 1
    } //end for
    //
    return numareas
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:903
public func AAS_FindPossiblePortals() {
    var i: Int32
    var numpossibleportals: Int32

    numpossibleportals = 0
    i = 1
    while i < aasworld.numareas {
        numpossibleportals += AAS_CheckAreaForPossiblePortals(i)
        i += 1
    } //end for
    botimport.runPrint(PRT_MESSAGE, "\r%6d possible portal areas\n", numpossibleportals)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:920
public func AAS_RemoveAllPortals() {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var i: Int32

    i = 1
    while i < aasworld.numareas {
        aasworld.areasettingsSlots[i].contents &= ~AREACONTENTS_CLUSTERPORTAL
        i += 1
    } //end for
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:1355
public func AAS_TestPortals() -> Int32 {
    var i: Int32
    var portal: AasPortal

    i = 1
    while i < aasworld.numportals {
        portal = aasworld.portalsSlots[i]
        if portal.frontcluster == 0 {
            aasworld.areasettingsSlots[portal.areanum].contents &= ~AREACONTENTS_CLUSTERPORTAL
            Log_Write("portal area %d has no front cluster\r\n", portal.areanum)
            return 0
        } //end if
        if portal.backcluster == 0 {
            aasworld.areasettingsSlots[portal.areanum].contents &= ~AREACONTENTS_CLUSTERPORTAL
            Log_Write("portal area %d has no back cluster\r\n", portal.areanum)
            return 0
        } //end if
        i += 1
    } //end for
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:1384
public func AAS_CountForcedClusterPortals() {
    var num: Int32
    var i: Int32

    num = 0
    i = 1
    while i < aasworld.numareas {
        if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
            Log_Write("area %d is a forced portal area\r\n", i)
            num += 1
        } //end if
        i += 1
    } //end for
    botimport.runPrint(PRT_MESSAGE, "%6d forced portal areas\n", num)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:1405
public func AAS_CreateViewPortals() {
    var i: Int32

    i = 1
    while i < aasworld.numareas {
        if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_CLUSTERPORTAL) != 0 {
            aasworld.areasettingsSlots[i].contents |= AREACONTENTS_VIEWPORTAL
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
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:1423
public func AAS_SetViewPortalsAsClusterPortals() {
    var i: Int32

    i = 1
    while i < aasworld.numareas {
        if (aasworld.areasettingsSlots[i].contents & AREACONTENTS_VIEWPORTAL) != 0 {
            aasworld.areasettingsSlots[i].contents |= AREACONTENTS_CLUSTERPORTAL
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
/// Source: oracle/codemp/botlib/be_aas_cluster.cpp:1441
public func AAS_InitClustering() {
    var i: Int32
    var removedPortalAreas: Int32
    var n: Int32
    var total: Int32
    var numreachabilityareas: Int32

    if aasworld.loaded == 0 {
        return
    }
    //if there are clusters
    if aasworld.numclusters >= 1 {
        //if clustering isn't forced
        if Int32(LibVarGetValue("forceclustering")) == 0 && Int32(LibVarGetValue("forcereachability")) == 0 {
            return
        }
    } //end if
    //set all view portals as cluster portals in case we re-calculate the reachabilities and clusters (with -reach)
    AAS_SetViewPortalsAsClusterPortals()
    //count the number of forced cluster portals
    AAS_CountForcedClusterPortals()
    //remove all area cluster marks
    AAS_RemoveClusterAreas()
    //find possible cluster portals
    AAS_FindPossiblePortals()
    //craete portals to for the bot view
    AAS_CreateViewPortals()
    //remove all portals that are not closing a cluster
    //AAS_RemoveNotClusterClosingPortals();
    //initialize portal memory
    if aasworld.portals != nil {
        FreeMemory(aasworld.portals?.handle)
    }
    aasworld.portals = AasPortal(GetClearedMemory(AAS_MAX_PORTALS * Int32(AasPortal.byteCount)))
    //initialize portal index memory
    if aasworld.portalindex != nil {
        FreeMemory(OpaquePointer(aasworld.portalindex!.base))
    }
    aasworld.portalindex = Slots<Int32>(scalars: GetClearedMemory(AAS_MAX_PORTALINDEXSIZE * Int32(Int32.byteCount)), count: Int(AAS_MAX_PORTALINDEXSIZE))
    //initialize cluster memory
    if aasworld.clusters != nil {
        FreeMemory(aasworld.clusters?.handle)
    }
    aasworld.clusters = AasCluster(GetClearedMemory(AAS_MAX_CLUSTERS * Int32(AasCluster.byteCount)))
    //
    removedPortalAreas = 0
    botimport.runPrint(PRT_MESSAGE, "\r%6d removed portal areas", removedPortalAreas)
    while true {
        botimport.runPrint(PRT_MESSAGE, "\r%6d", removedPortalAreas)
        //initialize the number of portals and clusters
        aasworld.numportals = 1 //portal 0 is a dummy
        aasworld.portalindexsize = 0
        aasworld.numclusters = 1 //cluster 0 is a dummy
        //create the portals from the portal areas
        AAS_CreatePortals()
        //
        removedPortalAreas += 1
        //find the clusters
        if AAS_FindClusters() == 0 {
            continue
        }
        //test the portals
        if AAS_TestPortals() == 0 {
            continue
        }
        //
        break
    } //end while
    botimport.runPrint(PRT_MESSAGE, "\n")
    //the AAS file should be saved
    aasworld.savefile = 1
    //write the portal areas to the log file
    i = 1
    while i < aasworld.numportals {
        Log_Write("portal %d: area %d\r\n", i, aasworld.portalsSlots[i].areanum)
        i += 1
    } //end for
    // report cluster info
    botimport.runPrint(PRT_MESSAGE, "%6d portals created\n", aasworld.numportals)
    botimport.runPrint(PRT_MESSAGE, "%6d clusters created\n", aasworld.numclusters)
    i = 1
    while i < aasworld.numclusters {
        botimport.runPrint(PRT_MESSAGE, "cluster %d has %d reachability areas\n", i, aasworld.clustersSlots[i].numreachabilityareas)
        i += 1
    } //end for
    // report AAS file efficiency
    numreachabilityareas = 0
    total = 0
    i = 0
    while i < aasworld.numclusters {
        n = aasworld.clustersSlots[i].numreachabilityareas
        numreachabilityareas += n
        total += n * n
        i += 1
    }
    total += numreachabilityareas * aasworld.numportals
    //
    botimport.runPrint(PRT_MESSAGE, "%6i total reachability areas\n", numreachabilityareas)
    botimport.runPrint(PRT_MESSAGE, "%6i AAS memory/CPU usage (the lower the better)\n", total * 3)
}
