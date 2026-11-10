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
func G2_IsSurfaceLegal(_ mod: OpaquePointer?, _ surfaceName: String, _ flags: inout Int32) -> Int32 {
    // Port-note: The parameter `mod` is an `OpaquePointer?`, which a logic body cannot read, and the walk of the hierarchy is at a byte offset from `mdxm`.
    // TODO: Port G2_IsSurfaceLegal
    portMissing("G2_IsSurfaceLegal", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:65")
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
    // Port-note: Raven calls G2_FindSurface of G2_misc.cpp:1689, which has a signature marker, and walks the hierarchy at a byte offset from `mdxm`.
    // TODO: Port G2_FindSurface
    portMissing("G2_FindSurface", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:98")
}

// set a named surface offFlags - if it doesn't find a surface with this name in the list then it will add one.
/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:148
func G2_SetSurfaceOnOff(_ ghlInfo: CGhoul2Info?, _ slist: inout [surfaceInfo_t], _ surfaceName: String, _ offFlags: Int32) -> Bool {
    // Port-note: Raven passes the model to G2_IsSurfaceLegal, whose `OpaquePointer?` parameter a logic body cannot fill.
    // TODO: Port G2_SetSurfaceOnOff
    portMissing("G2_SetSurfaceOnOff", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:148")
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:201
func G2_SetSurfaceOnOffFromSkin(_ ghlInfo: CGhoul2Info?, _ renderSkin: JKAShared.qhandle_t) {
    // Port-note: Raven passes the model to G2_IsSurfaceLegal, whose `OpaquePointer?` parameter a logic body cannot fill.
    // TODO: Port G2_SetSurfaceOnOffFromSkin
    portMissing("G2_SetSurfaceOnOffFromSkin", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:201")
}

// return a named surfaces off flags - should tell you if this surface is on or off.
/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:229
func G2_IsSurfaceOff(_ ghlInfo: CGhoul2Info?, _ slist: inout [surfaceInfo_t], _ surfaceName: String) -> Int32 {
    // Port-note: Raven walks the `mdxmSurfHierarchy_t` records at a byte offset from `mdxm`, and a logic body has no form for a view at a byte offset past a record.
    // TODO: Port G2_IsSurfaceOff
    portMissing("G2_IsSurfaceOff", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:229")
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:266
func G2_FindRecursiveSurface(_ currentModel: Model, _ surfaceNum: Int32, _ rootList: inout [surfaceInfo_t], _ activeSurfaces: Slots<Int32>) {
    // Port-note: Raven calls G2_FindSurface of G2_misc.cpp:1689, which has a signature marker, and walks the hierarchy at a byte offset from `mdxm`.
    // TODO: Port G2_FindRecursiveSurface
    portMissing("G2_FindRecursiveSurface", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:266")
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
    // Port-note: Raven passes the model to G2_IsSurfaceLegal, whose `OpaquePointer?` parameter a logic body cannot fill.
    // TODO: Port G2_SetRootSurface
    portMissing("G2_SetRootSurface", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:337")
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
    // Port-note: Raven calls G2_FindSurface of G2_misc.cpp:1689, which has a signature marker, and walks the hierarchy at a byte offset from `mdxm`.
    // TODO: Port G2_GetParentSurface
    portMissing("G2_GetParentSurface", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:588")
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:603
func G2_GetSurfaceIndex(_ ghlInfo: CGhoul2Info?, _ surfaceName: String) -> Int32 {
    // Port-note: Raven passes the model to G2_IsSurfaceLegal, whose `OpaquePointer?` parameter a logic body cannot fill.
    // TODO: Port G2_GetSurfaceIndex
    portMissing("G2_GetSurfaceIndex", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:603")
}

/// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:611
func G2_IsSurfaceRendered(_ ghlInfo: CGhoul2Info?, _ surfaceName: String, _ slist: inout [surfaceInfo_t]) -> Int32 {
    // Port-note: Raven passes the model to G2_IsSurfaceLegal, whose `OpaquePointer?` parameter a logic body cannot fill.
    // TODO: Port G2_IsSurfaceRendered
    portMissing("G2_IsSurfaceRendered", source: "oracle/codemp/ghoul2/G2_surfaces.cpp:611")
}
