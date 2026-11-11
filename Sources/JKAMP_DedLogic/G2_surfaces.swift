import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// find a particular surface in the surface override list
/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:48
func G2_FindOverrideSurface(_ surfaceNum: Int32, _ surfaceList: inout [surfaceInfo_t]) -> surfaceInfo_t? {
    var i: Int32

    // look through entire list
    i = 0
    while i < surfaceList.count {
        if surfaceList[i].surface == surfaceNum {
            return surfaceList[i]
        }
        i += 1
    }
    // didn't find it.
    return nil
}

// given a surface name, lets see if it's legal in the model
/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:65
public func G2_IsSurfaceLegal(_ mod: Model?, _ surfaceName: String, _ flags: inout Int32) -> Int32 {
    // damn include file dependancies
    var surf: MdxmSurfHierarchy
    let mod_m = mod!
    surf = MdxmSurfHierarchy(mod_m.mdxm!, byteOffset: mod_m.mdxm!.ofsSurfHierarchy)

    var i: Int32 = 0
    while i < mod_m.mdxm!.numSurfaces {
        if Q_stricmp(surfaceName, surf.name) == 0 {
            flags = Int32(truncatingIfNeeded: surf.flags)
            return i
        }
        // find the next surface
        surf = MdxmSurfHierarchy(surf, byteOffset: MdxmSurfHierarchy.byteCount(childIndexes: surf.numChildren))
        i += 1
    }
    return -1
}

/**
```
***********************************************************************************************
 * G2_FindSurface
 *    find a surface in a ghoul2 surface override list based on it's name
 *
 * Input
 *    filename of model, surface list of model instance, name of surface, int to be filled in
 * with the index of this surface (defaults to NULL)
 *
 * Output
 *    pointer to surface if successful, false otherwise
 *
 ***********************************************************************************************
```
*/
/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:98
private func G2_FindSurface(_ ghlInfo: CGhoul2Info?, _ slist: inout [surfaceInfo_t], _ surfaceName: String, _ surfIndex: inout Int32) -> MdxmSurface? {
    var i: Int32 = 0
    // find the model we want
    let mod = ghlInfo!.currentModel!
    let surfIndexes = mod.mdxm.map { MdxmHierarchyOffsets($0, byteOffset: MdxmHeader.byteCount) }
    var surfInfo: MdxmSurfHierarchy

    // did we find a ghoul 2 model or not?
    if mod.mdxm == nil {
        surfIndex = -1
        return nil
    }

    // first find if we already have this surface in the list
    i = Int32(slist.count) - 1
    while i >= 0 {
        if slist[i].surface != 10000 && slist[i].surface != -1 {
            let surf = G2_FindSurface(mod, slist[i].surface, 0)!
            // back track and get the surfinfo struct for this surface
            surfInfo = MdxmSurfHierarchy(surfIndexes!, byteOffset: surfIndexes!.offsets[surf.thisSurfaceIndex])

            // are these the droids we're looking for?
            if Q_stricmp(surfInfo.name, surfaceName) == 0 {
                // yup
                surfIndex = i
                return surf
            }
        }
        i -= 1
    }
    // didn't find it
    surfIndex = -1
    return nil
}

// set a named surface offFlags - if it doesn't find a surface with this name in the list then it will add one.
/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:148
func G2_SetSurfaceOnOff(_ ghlInfo: CGhoul2Info?, _ slist: inout [surfaceInfo_t], _ surfaceName: String, _ offFlags: Int32) -> Bool {
    var surfIndex: Int32 = -1
    let temp_slist_entry = surfaceInfo_t()
    let surf: MdxmSurface?
    // find the model we want
    let mod = ghlInfo!.currentModel!

    // did we find a ghoul 2 model or not?
    if mod.mdxm == nil {
        return false
    }

    // first find if we already have this surface in the list
    surf = G2_FindSurface(ghlInfo, &slist, surfaceName, &surfIndex)
    if surf != nil {
        // set descendants value

        // slist[surfIndex].offFlags = offFlags;
        // seems to me that we shouldn't overwrite the other flags.
        // the only bit we really care about in the incoming flags is the off bit
        slist[surfIndex].offFlags &= ~(G2SURFACEFLAG_OFF | G2SURFACEFLAG_NODESCENDANTS)
        slist[surfIndex].offFlags |= offFlags & (G2SURFACEFLAG_OFF | G2SURFACEFLAG_NODESCENDANTS)
        return true
    } else {
        // ok, not in the list already - in that case, lets verify this surface exists in the model mesh
        var flags: Int32 = 0
        let surfaceNum = G2_IsSurfaceLegal(mod, surfaceName, &flags)
        if surfaceNum != -1 {
            var newflags = flags
            // the only bit we really care about in the incoming flags is the off bit
            newflags &= ~(G2SURFACEFLAG_OFF | G2SURFACEFLAG_NODESCENDANTS)
            newflags |= offFlags & (G2SURFACEFLAG_OFF | G2SURFACEFLAG_NODESCENDANTS)

            if newflags != flags { // insert here then because it changed, no need to add an override otherwise
                temp_slist_entry.offFlags = newflags
                temp_slist_entry.surface = surfaceNum

                slist.append(temp_slist_entry)
            }
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:201
func G2_SetSurfaceOnOffFromSkin(_ ghlInfo: CGhoul2Info?, _ renderSkin: JKAShared.qhandle_t) {
    var j: Int32
    let skin = R_GetSkinByHandle(renderSkin)!

    ghlInfo!.mSlist.removeAll() //remove any overrides we had before.
    ghlInfo!.mMeshFrameNum = 0

    j = 0
    while j < skin.numSurfaces {
        // the names have both been lowercased
        if strcmp(skin.surfaces[j]!.shader!.name, "*off") == 0 {
            _ = G2_SetSurfaceOnOff(ghlInfo, &ghlInfo!.mSlist, skin.surfaces[j]!.name, G2SURFACEFLAG_OFF)
        } else {
            var flags: Int32 = 0
            let surfaceNum = G2_IsSurfaceLegal(ghlInfo!.currentModel, skin.surfaces[j]!.name, &flags)
            if surfaceNum != -1 && (flags & G2SURFACEFLAG_OFF) == 0 { //only turn on if it's not an "_off" surface
                _ = G2_SetSurfaceOnOff(ghlInfo, &ghlInfo!.mSlist, skin.surfaces[j]!.name, 0)
            }
        }
        j += 1
    }
}

// return a named surfaces off flags - should tell you if this surface is on or off.
/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:229
func G2_IsSurfaceOff(_ ghlInfo: CGhoul2Info?, _ slist: inout [surfaceInfo_t], _ surfaceName: String) -> Int32 {
    let mod = ghlInfo!.currentModel!
    var surfIndex: Int32 = -1
    let surf: MdxmSurface?

    // did we find a ghoul 2 model or not?
    if mod.mdxm == nil {
        return 0
    }

    // first find if we already have this surface in the list
    surf = G2_FindSurface(ghlInfo, &slist, surfaceName, &surfIndex)
    if surf != nil {
        // set descendants value
        return slist[surfIndex].offFlags
    }
    // ok, we didn't find it in the surface list. Lets look at the original surface then.

    var surface = MdxmSurfHierarchy(mod.mdxm!, byteOffset: mod.mdxm!.ofsSurfHierarchy)

    var i: Int32 = 0
    while i < mod.mdxm!.numSurfaces {
        if Q_stricmp(surfaceName, surface.name) == 0 {
            return Int32(truncatingIfNeeded: surface.flags)
        }
        // find the next surface
        surface = MdxmSurfHierarchy(surface, byteOffset: MdxmSurfHierarchy.byteCount(childIndexes: surface.numChildren))
        i += 1
    }

    return 0
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:266
func G2_FindRecursiveSurface(_ currentModel: Model, _ surfaceNum: Int32, _ rootList: inout [surfaceInfo_t], _ activeSurfaces: Slots<Int32>) {
    var surfaceNum = surfaceNum
    var i: Int32
    let surface = G2_FindSurface(currentModel, surfaceNum, 0)!
    let surfIndexes = MdxmHierarchyOffsets(currentModel.mdxm!, byteOffset: MdxmHeader.byteCount)
    let surfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surface.thisSurfaceIndex])

    // see if we have an override surface in the surface list
    let surfOverride = G2_FindOverrideSurface(surfaceNum, &rootList)

    // really, we should use the default flags for this surface unless it's been overriden
    var offFlags = Int32(truncatingIfNeeded: surfInfo.flags)

    // set the off flags if we have some
    if surfOverride != nil {
        offFlags = surfOverride!.offFlags
    }

    // if this surface is not off, indicate as such in the active surface list
    if (offFlags & G2SURFACEFLAG_OFF) == 0 {
        activeSurfaces[surfaceNum] = 1
    } else
    // if we are turning off all descendants, then stop this recursion now
    if (offFlags & G2SURFACEFLAG_NODESCENDANTS) != 0 {
        return
    }

    // now recursively call for the children
    i = 0
    while i < surfInfo.numChildren {
        surfaceNum = surfInfo.childIndexes[i]
        G2_FindRecursiveSurface(currentModel, surfaceNum, &rootList, activeSurfaces)
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:306
func G2_RemoveRedundantGeneratedSurfaces(_ slist: inout [surfaceInfo_t], _ activeSurfaces: Slots<Int32>) {
    var i: Int32

    // walk the surface list, removing surface overrides or generated surfaces that are pointing at surfaces that aren't active anymore
    i = 0
    while i < slist.count {
        if slist[i].surface != -1 {
            // is this a generated surface?
            if (slist[i].offFlags & G2SURFACEFLAG_GENERATED) != 0 {
                // if it's not in the list, remove it
                if activeSurfaces[slist[i].genPolySurfaceIndex & 0xffff] == 0 {
                    G2_RemoveSurface(&slist, i)
                }
            }
            // no, so it does point back at a legal surface
            else {
                // if it's not in the list, remove it
                if activeSurfaces[slist[i].surface] == 0 {
                    G2_RemoveSurface(&slist, i)
                }
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:337
func G2_SetRootSurface(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ surfaceName: String) -> Bool {
    let surf: Int32
    var flags: Int32 = 0
    let activeSurfaces: Slots<Int32>
    let activeBones: Slots<Int32>

    let mod_m = ghoul2[modelIndex].currentModel!
    let mod_a = ghoul2[modelIndex].animModel!

    // did we find a ghoul 2 model or not?
    if mod_m.mdxm == nil {
        return false
    }

    // first find if we already have this surface in the list
    surf = G2_IsSurfaceLegal(mod_m, surfaceName, &flags)
    if surf != -1 {
        // first see if this ghoul2 model already has this as a root surface
        if ghoul2[modelIndex].mSurfaceRoot == surf {
            return true
        }

        // set the root surface
        ghoul2[modelIndex].mSurfaceRoot = surf

        // ok, now the tricky bits.
        // firstly, generate a list of active / on surfaces below the root point

        // gimme some space to put this list into
        activeSurfaces = Slots<Int32>(scalars: Z_Malloc(mod_m.mdxm!.numSurfaces * 4, TAG_GHOUL2, true), count: Int(mod_m.mdxm!.numSurfaces))
        activeSurfaces.zero()
        activeBones = Slots<Int32>(scalars: Z_Malloc(mod_a.mdxa!.numBones * 4, TAG_GHOUL2, true), count: Int(mod_a.mdxa!.numBones))
        activeBones.zero()

        G2_FindRecursiveSurface(mod_m, surf, &ghoul2[modelIndex].mSlist, activeSurfaces)

        // now generate the used bone list
        let CBL = CConstructBoneList(
            ghoul2[modelIndex].mSurfaceRoot,
            activeBones,
            ghoul2[modelIndex].mSlist,
            mod_m,
            ghoul2[modelIndex].mBlist
        )

        G2_ConstructUsedBoneList(CBL)

        // now remove all procedural or override surfaces that refer to surfaces that arent on this list
        G2_RemoveRedundantGeneratedSurfaces(&ghoul2[modelIndex].mSlist, activeSurfaces)

        // now remove all bones that are pointing at bones that aren't active
        G2_RemoveRedundantBoneOverrides(&ghoul2[modelIndex].mBlist, activeBones)

        // then remove all bolts that point at surfaces or bones that *arent* active.
        G2_RemoveRedundantBolts(&ghoul2[modelIndex].mBltlist, &ghoul2[modelIndex].mSlist, activeSurfaces, activeBones)

        // then remove all models on this ghoul2 instance that use those bolts that are being removed.
        var i: Int32 = 0
        while i < ghoul2.size() {
            // are we even bolted to anything?
            if ghoul2[i].mModelBoltLink != -1 {
                let boltMod = (ghoul2[i].mModelBoltLink >> MODEL_SHIFT) & MODEL_AND
                let boltNum = (ghoul2[i].mModelBoltLink >> BOLT_SHIFT) & BOLT_AND
                // if either the bolt list is too small, or the bolt we are pointing at references nothing, remove this model
                if (ghoul2[boltMod].mBltlist.count <= boltNum) ||
                    ((ghoul2[boltMod].mBltlist[boltNum].boneNumber == -1) &&
                     (ghoul2[boltMod].mBltlist[boltNum].surfaceNumber == -1))
                {
                    var g2i: CGhoul2Info_v? = ghoul2
                    _ = G2API_RemoveGhoul2Model(&g2i, i)
                }
            }
            i += 1
        }
        //No support for this, for now.

        // remember to free what we used
        Z_Free(OpaquePointer(activeSurfaces.base))
        Z_Free(OpaquePointer(activeBones.base))

        return true
    }
/*
//g2r	if (entstate->ghoul2)
	{
		CGhoul2Info_v &ghoul2 = *((CGhoul2Info_v *)entstate->ghoul2);
		model_t				*mod_m = R_GetModelByHandle(RE_RegisterModel(ghoul2[modelIndex].mFileName));
		model_t				*mod_a = R_GetModelByHandle(mod_m->mdxm->animIndex); 
		int					surf;
		int					flags;
		int					*activeSurfaces, *activeBones;

		// did we find a ghoul 2 model or not?
		if (!mod_m->mdxm)
		{
			return qfalse;
		}

 		// first find if we already have this surface in the list
		surf = G2_IsSurfaceLegal(mod_m, surfaceName, &flags);
		if (surf != -1)
		{
			// first see if this ghoul2 model already has this as a root surface
			if (ghoul2[modelIndex].mSurfaceRoot == surf)
			{
				return qtrue;
			}

			// set the root surface
			ghoul2[modelIndex].mSurfaceRoot = surf;

			// ok, now the tricky bits.
			// firstly, generate a list of active / on surfaces below the root point

			// gimme some space to put this list into
			activeSurfaces = (int *)Z_Malloc(mod_m->mdxm->numSurfaces * 4, TAG_GHOUL2, qtrue);
			memset(activeSurfaces, 0, (mod_m->mdxm->numSurfaces * 4));
			activeBones = (int *)Z_Malloc(mod_a->mdxa->numBones * 4, TAG_GHOUL2, qtrue);
			memset(activeBones, 0, (mod_a->mdxa->numBones * 4));

			G2_FindRecursiveSurface(mod_m, surf, ghoul2[modelIndex].mSlist, activeSurfaces);

			// now generate the used bone list
			CConstructBoneList	CBL(ghoul2[modelIndex].mSurfaceRoot, 
								activeBones,
								ghoul2[modelIndex].mSlist,
								mod_m,
								ghoul2[modelIndex].mBlist);

			G2_ConstructUsedBoneList(CBL);

			// now remove all procedural or override surfaces that refer to surfaces that arent on this list
			G2_RemoveRedundantGeneratedSurfaces(ghoul2[modelIndex].mSlist, activeSurfaces);

			// now remove all bones that are pointing at bones that aren't active
			G2_RemoveRedundantBoneOverrides(ghoul2[modelIndex].mBlist, activeBones);

			// then remove all bolts that point at surfaces or bones that *arent* active.
			G2_RemoveRedundantBolts(ghoul2[modelIndex].mBltlist, ghoul2[modelIndex].mSlist, activeSurfaces, activeBones);

			// then remove all models on this ghoul2 instance that use those bolts that are being removed.
			for (int i=0; i<ghoul2.size(); i++)
			{
				// are we even bolted to anything?
				if (ghoul2[i].mModelBoltLink != -1)
				{
					int	boltMod = (ghoul2[i].mModelBoltLink >> MODEL_SHIFT) & MODEL_AND;
					int	boltNum = (ghoul2[i].mModelBoltLink >> BOLT_SHIFT) & BOLT_AND;
					// if either the bolt list is too small, or the bolt we are pointing at references nothing, remove this model
					if ((ghoul2[boltMod].mBltlist.size() <= boltNum) || 
						((ghoul2[boltMod].mBltlist[boltNum].boneNumber == -1) && 
						 (ghoul2[boltMod].mBltlist[boltNum].surfaceNumber == -1)))
					{
						G2API_RemoveGhoul2Model(entstate, i);
					}
				}
			}

			// remember to free what we used
			Z_Free(activeSurfaces);
			Z_Free(activeBones);

			return (qtrue);
		}
	}
	assert(0);*/
    return false
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:511
func G2_AddSurface(_ ghoul2: CGhoul2Info?, _ surfaceNumber: Int32, _ polyNumber: Int32, _ BarycentricI: Float, _ BarycentricJ: Float, _ lod: Int32) -> Int32 {
    let temp_slist_entry = surfaceInfo_t()
    var lod = lod

    // decide if LOD is legal
    lod = G2_DecideTraceLod(ghoul2!, lod)

    // first up, see if we have a free one already set up  - look only from the end of the constant surfaces onwards
    var i: Int32 = 0
    while i < ghoul2!.mSlist.count {
        // is the surface count -1? That would indicate it's free
        if ghoul2!.mSlist[i].surface == -1 {
            ghoul2!.mSlist[i].offFlags = G2SURFACEFLAG_GENERATED
            ghoul2!.mSlist[i].surface = 10000		// no model will ever have 10000 surfaces
            ghoul2!.mSlist[i].genBarycentricI = BarycentricI
            ghoul2!.mSlist[i].genBarycentricJ = BarycentricJ
            ghoul2!.mSlist[i].genPolySurfaceIndex = ((polyNumber & 0xffff) << 16) | (surfaceNumber & 0xffff)
            ghoul2!.mSlist[i].genLod = lod
            return i
        }
        i += 1
    }

    // ok, didn't find one. Better create one

    temp_slist_entry.offFlags = G2SURFACEFLAG_GENERATED
    temp_slist_entry.surface = 10000
    temp_slist_entry.genBarycentricI = BarycentricI
    temp_slist_entry.genBarycentricJ = BarycentricJ
    temp_slist_entry.genPolySurfaceIndex = ((polyNumber & 0xffff) << 16) | (surfaceNumber & 0xffff)
    temp_slist_entry.genLod = lod

    ghoul2!.mSlist.append(temp_slist_entry)

    return (Int32(ghoul2!.mSlist.count) - 1)
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:549
func G2_RemoveSurface(_ slist: inout [surfaceInfo_t], _ index: Int32) -> Bool {
    // did we find it?
    if index != -1 {
        // set us to be the 'not active' state
        slist[index].surface = -1

        var newSize = slist.count
        // now look through the list from the back and see if there is a block of -1's we can resize off the end of the list
        var i = slist.count - 1
        while i > -1 {
            if slist[i].surface == -1 {
                newSize = i
            }
            // once we hit one that isn't a -1, we are done.
            else {
                break
            }
            i -= 1
        }
        // do we need to resize?
        if newSize != slist.count {
            // yes, so lets do it
            slist.removeLast(slist.count - newSize)
        }

        return true
    }

    // no
    return false
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:588
func G2_GetParentSurface(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Int32 {
    let mod = ghlInfo!.currentModel!
    let surf: MdxmSurface?
    let surfIndexes = MdxmHierarchyOffsets(mod.mdxm!, byteOffset: MdxmHeader.byteCount)
    let surfInfo: MdxmSurfHierarchy?

    // walk each surface and see if this index is listed in it's children
    surf = G2_FindSurface(mod, index, 0)
    surfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surf!.thisSurfaceIndex])

    return surfInfo!.parentIndex
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:603
func G2_GetSurfaceIndex(_ ghlInfo: CGhoul2Info?, _ surfaceName: String) -> Int32 {
    let mod = ghlInfo!.currentModel
    var flags: Int32 = 0

    return G2_IsSurfaceLegal(mod, surfaceName, &flags)
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:611
func G2_IsSurfaceRendered(_ ghlInfo: CGhoul2Info?, _ surfaceName: String, _ slist: inout [surfaceInfo_t]) -> Int32 {
    var flags: Int32 = 0 //, surfFlags = 0;
    var surfIndex: Int32 = 0
    if ghlInfo!.currentModel!.mdxm == nil {
        return -1
    }

    // now travel up the skeleton to see if any of it's ancestors have a 'no descendants' turned on

    // find the original surface in the surface list
    var surfNum = G2_IsSurfaceLegal(ghlInfo!.currentModel, surfaceName, &flags)
    if surfNum != -1 { //must be legal
        let surfIndexes = MdxmHierarchyOffsets(ghlInfo!.currentModel!.mdxm!, byteOffset: MdxmHeader.byteCount)
        let surfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surfNum])
        surfNum = surfInfo.parentIndex
        // walk the surface hierarchy up until we hit the root
        while surfNum != -1 {
            let parentSurf: MdxmSurface?
            var parentFlags: Int32 = 0
            let parentSurfInfo: MdxmSurfHierarchy

            parentSurfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surfNum])

            // find the original surface in the surface list
            //G2 was bug, above comment was accurate, but we don't want the original flags, we want the parent flags
            _ = G2_IsSurfaceLegal(ghlInfo!.currentModel, parentSurfInfo.name, &parentFlags)

            // now see if we already have overriden this surface in the slist
            parentSurf = G2_FindSurface(ghlInfo, &slist, parentSurfInfo.name, &surfIndex)
            if parentSurf != nil {
                // set descendants value
                parentFlags = slist[surfIndex].offFlags
            }
            // now we have the parent flags, lets see if any have the 'no descendants' flag set
            if (parentFlags & G2SURFACEFLAG_NODESCENDANTS) != 0 {
                flags |= G2SURFACEFLAG_OFF
                break
            }
            // set up scan of next parent
            surfNum = parentSurfInfo.parentIndex
        }
    } else {
        return -1
    }
    if flags == 0 { //it's not being overridden by a parent
        // now see if we already have overriden this surface in the slist
        let surf = G2_FindSurface(ghlInfo, &slist, surfaceName, &surfIndex)
        if surf != nil {
            // set descendants value
            flags = slist[surfIndex].offFlags
        }
        // ok, at this point in flags we have what this surface is set to, and the index of the surface itself
    }
    return flags
}
