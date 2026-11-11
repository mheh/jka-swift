import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:29
let GORE_TAG_UPPER = (256) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:30
let GORE_TAG_MASK = (~255) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:32
var CurrentTag: Int32 {
    get { world.variables.CurrentTag }
    set { world.variables.CurrentTag = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:33
var CurrentTagUpper: Int32 {
    get { world.variables.CurrentTagUpper }
    set { world.variables.CurrentTagUpper = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:35
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var GoreRecords: [Int32: GoreTextureCoordinates] {
    get { world.GoreRecords }
    set { world.GoreRecords = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:36
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var GoreTagsTemp: [[Int32]: Int32] {
    get { world.GoreTagsTemp }
    set { world.GoreTagsTemp = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:38
var goreModelIndex: Int32 {
    get { world.variables.goreModelIndex }
    set { world.variables.goreModelIndex = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:40
var cg_g2MarksAllModels: JKAMP.Cvar? {
    get { world.variables.cg_g2MarksAllModels }
    set { world.variables.cg_g2MarksAllModels = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:56
let MAX_GORE_RECORDS = (500) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:124
var CurrentGoreSet: Int32 {
    get { world.variables.CurrentGoreSet }
    set { world.variables.CurrentGoreSet = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:125
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var GoreSets: [Int32: CGoreSet] {
    get { world.GoreSets }
    set { world.GoreSets = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:792
let MAX_GORE_VERTS = (3000) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:793
var GoreVerts: Slots<VertexTemp> { world.storage.GoreVerts }

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:794
var GoreIndexCopy: [Int32] {
    get { world.variables.GoreIndexCopy }
    set { world.variables.GoreIndexCopy = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:795
var GoreTouch: Int32 {
    get { world.variables.GoreTouch }
    set { world.variables.GoreTouch = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:797
let MAX_GORE_INDECIES = (6000) as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:798
var GoreIndecies: [Int32] {
    get { world.variables.GoreIndecies }
    set { world.variables.GoreIndecies = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:800
let GORE_MARGIN = (0.0) as Float

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1715
// Raven wrote: #define SURFACE_SAVE_BLOCK_SIZE sizeof ( surfaceInfo_t )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1716
// Raven wrote: #define BOLT_SAVE_BLOCK_SIZE ( sizeof ( boltInfo_t ) - sizeof ( mdxaBone_t ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1717
// Raven wrote: #define BONE_SAVE_BLOCK_SIZE sizeof ( boneInfo_t )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:43
private func DestroyGoreTexCoordinates(_ tag: Int32) {
    let gTC = FindGoreRecord(tag)
    if gTC == nil {
        return
    }
    // AI: Raven runs the destructor of the record, which frees its `tex` blocks. The class has no destructor, so the call drops.
    //I don't know what's going on here, it should call the destructor for
    //this when it erases the record but sometimes it doesn't. -rww
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:58
func AllocGoreRecord() -> Int32 {
    while GoreRecords.count > MAX_GORE_RECORDS {
        // AI: Raven reads the first record of an ordered map. The Dictionary has no order, so the body takes the least tag.
        let tagHigh = GoreRecords.keys.min()! & GORE_TAG_MASK
        var it: Int32

        it = GoreRecords.keys.min()!

        // AI: Raven runs the destructor of the record here. The class has no destructor, so the call drops.
        GoreRecords[it] = nil
        while GoreRecords.count != 0 {
            if (GoreRecords.keys.min()! & GORE_TAG_MASK) != tagHigh {
                break
            }
            it = GoreRecords.keys.min()!

            // AI: Raven runs the destructor of the record here. The class has no destructor, so the call drops.
            GoreRecords[it] = nil
        }
    }
    let ret = CurrentTag
    GoreRecords[CurrentTag] = GoreTextureCoordinates()
    CurrentTag += 1
    return ret
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:96
func ResetGoreTag() {
    GoreTagsTemp.removeAll()
    CurrentTag = CurrentTagUpper
    CurrentTagUpper += GORE_TAG_UPPER
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:103
func FindGoreRecord(_ tag: Int32) -> GoreTextureCoordinates? {
    if let i = GoreRecords[tag] {
        return i
    }
    return nil
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:113
// AI: Raven returns `void *` over the `GoreTextureCoordinates *` of FindGoreRecord. The function returns that class, the form of FindGoreRecord.
func G2_GetGoreRecord(_ tag: Int32) -> GoreTextureCoordinates? {
    // Raven calls this function from no file of either tree, so it is dead.
    return FindGoreRecord(tag)
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:118
func DeleteGoreRecord(_ tag: Int32) {
    DestroyGoreTexCoordinates(tag)
    GoreRecords[tag] = nil
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:127
func FindGoreSet(_ goreSetTag: Int32) -> CGoreSet? {
    if let f = GoreSets[goreSetTag] {
        return f
    }
    return nil
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:142
func NewGoreSet() -> CGoreSet? {
    let ret = CGoreSet(CurrentGoreSet)
    CurrentGoreSet += 1
    GoreSets[ret.mMyGoreSetTag] = ret
    ret.mRefCount = 1
    return ret
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:153
func DeleteGoreSet(_ goreSetTag: Int32) {
    if let f = GoreSets[goreSetTag] {
        if f.mRefCount == 0 || f.mRefCount - 1 == 0 {
            // AI: Raven deletes the set and then erases its entry. The body erases the entry, and the deinit runs when the last reference goes.
            GoreSets[goreSetTag] = nil
        } else {
            f.mRefCount -= 1
        }
    }
}

// assorted Ghoul 2 functions.
// list all surfaces associated with a model
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:279
func G2_List_Model_Surfaces(_ fileName: String) {
    var i: Int32
    var x: Int32
    let mod_m = R_GetModelByHandle(RE_RegisterModel(fileName))
    var surf: MdxmSurfHierarchy

    surf = MdxmSurfHierarchy(mod_m!.mdxm!, byteOffset: mod_m!.mdxm!.ofsSurfHierarchy)
    var surface = MdxmSurface(mod_m!.mdxm!, byteOffset: mod_m!.mdxm!.ofsLODs + Int32(MdxmLOD.byteCount))

    x = 0
    while x < mod_m!.mdxm!.numSurfaces {
        Com_Printf("Surface %i Name %s\n", x, surf.name)
        if r_verbose!.value != 0 {
            Com_Printf("Num Descendants %i\n", surf.numChildren)
            i = 0
            while i < surf.numChildren {
                Com_Printf("Descendant %i\n", surf.childIndexes[i])
                i += 1
            }
        }
        // find the next surface
        surf = MdxmSurfHierarchy(surf, byteOffset: MdxmSurfHierarchy.byteCount(childIndexes: surf.numChildren))
        surface = MdxmSurface(surface, byteOffset: surface.ofsEnd)
        x += 1
    }

}

// list all bones associated with a model
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:307
func G2_List_Model_Bones(_ fileName: String, _ frame: Int32) {
    var x: Int32
    var i: Int32
    var skel: MdxaSkel
    let offsets: MdxaSkelOffsets
    let mod_m = R_GetModelByHandle(RE_RegisterModel(fileName))
    let mod_a = R_GetModelByHandle(mod_m!.mdxm!.animIndex)
// 	mdxaFrame_t		*aframe=0;
//	int				frameSize;
    let header = mod_a!.mdxa

    // figure out where the offset list is
    offsets = MdxaSkelOffsets(header!, byteOffset: MdxaHeader.byteCount)

//    frameSize = (int)( &((mdxaFrame_t *)0)->boneIndexes[ header->numBones ] );

//	aframe = (mdxaFrame_t *)((byte *)header + header->ofsFrames + (frame * frameSize));
    // walk each bone and list it's name
    x = 0
    while x < mod_a!.mdxa!.numBones {
        skel = MdxaSkel(header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[x])
        Com_Printf("Bone %i Name %s\n", x, skel.name)

        Com_Printf("X pos %f, Y pos %f, Z pos %f\n", skel.BasePoseMat.matrix[0][3], skel.BasePoseMat.matrix[1][3], skel.BasePoseMat.matrix[2][3])

        // if we are in verbose mode give us more details
        if r_verbose!.value != 0 {
            Com_Printf("Num Descendants %i\n", skel.numChildren)
            i = 0
            while i < skel.numChildren {
                Com_Printf("Num Descendants %i\n", skel.numChildren)
                i += 1
            }
        }
        x += 1
    }
}

/**
```
***********************************************************************************************
 * G2_GetAnimFileName
 *    obtain the .gla filename for a model
 *
 * Input
 *    filename of model
 *
 * Output
 *    true if we successfully obtained a filename, false otherwise
 *
 ***********************************************************************************************
```
*/
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:356
func G2_GetAnimFileName(_ fileName: String, _ filename: inout JKAShared.TextCursor) -> Bool {
    // find the model we want
    let mod = R_GetModelByHandle(RE_RegisterModel(fileName))

    if let mod, let mdxm = mod.mdxm, !mdxm.animName.isEmpty {
        filename = TextCursor(mdxm.animNameBuffer)
        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:376
func G2_DecideTraceLod(_ ghoul2: CGhoul2Info, _ useLod: Int32) -> Int32 {
    var returnLod = useLod

    // if we are overriding the LOD at top level, then we can afford to only check this level of model
    if ghoul2.mLodBias > returnLod {
        returnLod = ghoul2.mLodBias
    }
//	assert(G2_MODEL_OK(&ghoul2));

    //what about r_lodBias?

    // now ensure that we haven't selected a lod that doesn't exist for this model
    if returnLod >= ghoul2.currentModel!.mdxm!.numLODs {
        returnLod = ghoul2.currentModel!.mdxm!.numLODs - 1
    }

    return returnLod
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:404
func R_TransformEachSurface(_ surface: MdxmSurface, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ TransformedVertsArray: Slots<Int32>, _ boneCache: CBoneCache?) {
    var j: Int32
    var k: Int32
    var v: MdxmVertex
    let TransformedVerts: Slots<Float>?

    //
    // deform the vertexes by the lerped bones
    //
    let piBoneReferences = surface.boneReferences

    // alloc some space for the transformed verts to get put in
    let heapBlock = G2VertSpace!.MiniHeapAlloc(surface.numVerts * 5 * 4)
    TransformedVerts = heapBlock?.floats(at: 0)
    // AI: Raven stores the float pointer as an `int`. The slot holds the byte offset of the block in the heap, row X8 of docket 10.
    TransformedVertsArray[surface.thisSurfaceIndex] = heapBlock == nil ? 0 : G2VertSpace!.mHeap!.offset(of: heapBlock!)
    if TransformedVerts == nil {
        Com_Error(ERR_DROP, "Ran out of transform space for Ghoul2 Models. Adjust MiniHeapSize in SV_SpawnServer.\n")
    }

    // whip through and actually transform each vertex
    let numVerts: Int32 = surface.numVerts
    v = MdxmVertex(surface, byteOffset: surface.ofsVerts)
    // AI: Raven takes the address of vertex `numVerts` and casts it to a texture coordinate pointer. The view is the record at that byte offset.
    let pTexCoords = MdxmVertexTexCoord(v, byteOffset: numVerts * Int32(MdxmVertex.byteCount))

    // AI: Raven hands each row of four floats of a bone to DotProduct. Each call below reads the vector accessor of the row.
    // Raven steps `v` and indexes `pTexCoords` as pointers. Each view steps by the record size.

    // optimisation issue
    if (scale[0] != 1.0) || (scale[1] != 1.0) || (scale[2] != 1.0) {
        j = 0
        while j < numVerts {
            var tempVert: vec3_t
            var tempNormal: vec3_t
//			mdxmWeight_t	*w;

            tempVert = vec3_t()
            tempNormal = vec3_t()
//			w = v->weights;

            let iNumWeights: Int32 = G2_GetVertWeights(v)

            var fTotalWeight: Float = 0.0
            k = 0
            while k < iNumWeights {
                let iBoneIndex: Int32 = G2_GetVertBoneIndex(v, k)
                let fBoneWeight: Float = G2_GetVertBoneWeight(v, k, &fTotalWeight, iNumWeights)

                let bone = EvalBoneCache(piBoneReferences[iBoneIndex], boneCache)

                tempVert[0] += fBoneWeight * (_DotProduct(bone.matrix[0].vector, v.vertCoords) + bone.matrix[0][3])
                tempVert[1] += fBoneWeight * (_DotProduct(bone.matrix[1].vector, v.vertCoords) + bone.matrix[1][3])
                tempVert[2] += fBoneWeight * (_DotProduct(bone.matrix[2].vector, v.vertCoords) + bone.matrix[2][3])

                tempNormal[0] += fBoneWeight * _DotProduct(bone.matrix[0].vector, v.normal)
                tempNormal[1] += fBoneWeight * _DotProduct(bone.matrix[1].vector, v.normal)
                tempNormal[2] += fBoneWeight * _DotProduct(bone.matrix[2].vector, v.normal)
                k += 1
            }
            var pos: Int32 = j * 5

            let texCoord = MdxmVertexTexCoord(pTexCoords, byteOffset: j * Int32(MdxmVertexTexCoord.byteCount))
            // copy tranformed verts into temp space
            TransformedVerts![pos] = tempVert[0] * scale[0]
            pos += 1
            TransformedVerts![pos] = tempVert[1] * scale[1]
            pos += 1
            TransformedVerts![pos] = tempVert[2] * scale[2]
            pos += 1
            // we will need the S & T coors too for hitlocation and hitmaterial stuff
            TransformedVerts![pos] = texCoord.texCoords[0]
            pos += 1
            TransformedVerts![pos] = texCoord.texCoords[1]

            v = MdxmVertex(v, byteOffset: MdxmVertex.byteCount)// = (mdxmVertex_t *)&v->weights[/*v->numWeights*/surface->maxVertBoneWeights];
            j += 1
        }
    } else {
        var pos: Int32 = 0
        j = 0
        while j < numVerts {
            var tempVert: vec3_t
            var tempNormal: vec3_t
//			const mdxmWeight_t	*w;

            tempVert = vec3_t()
            tempNormal = vec3_t()
//			w = v->weights;

            let iNumWeights: Int32 = G2_GetVertWeights(v)

            var fTotalWeight: Float = 0.0
            k = 0
            while k < iNumWeights {
                let iBoneIndex: Int32 = G2_GetVertBoneIndex(v, k)
                let fBoneWeight: Float = G2_GetVertBoneWeight(v, k, &fTotalWeight, iNumWeights)

                let bone = EvalBoneCache(piBoneReferences[iBoneIndex], boneCache)

                tempVert[0] += fBoneWeight * (_DotProduct(bone.matrix[0].vector, v.vertCoords) + bone.matrix[0][3])
                tempVert[1] += fBoneWeight * (_DotProduct(bone.matrix[1].vector, v.vertCoords) + bone.matrix[1][3])
                tempVert[2] += fBoneWeight * (_DotProduct(bone.matrix[2].vector, v.vertCoords) + bone.matrix[2][3])

                tempNormal[0] += fBoneWeight * _DotProduct(bone.matrix[0].vector, v.normal)
                tempNormal[1] += fBoneWeight * _DotProduct(bone.matrix[1].vector, v.normal)
                tempNormal[2] += fBoneWeight * _DotProduct(bone.matrix[2].vector, v.normal)
                k += 1
            }

            let texCoord = MdxmVertexTexCoord(pTexCoords, byteOffset: j * Int32(MdxmVertexTexCoord.byteCount))
            // copy tranformed verts into temp space
            TransformedVerts![pos] = tempVert[0]
            pos += 1
            TransformedVerts![pos] = tempVert[1]
            pos += 1
            TransformedVerts![pos] = tempVert[2]
            pos += 1
            // we will need the S & T coors too for hitlocation and hitmaterial stuff
            TransformedVerts![pos] = texCoord.texCoords[0]
            pos += 1
            TransformedVerts![pos] = texCoord.texCoords[1]
            pos += 1

            v = MdxmVertex(v, byteOffset: MdxmVertex.byteCount)// = (mdxmVertex_t *)&v->weights[/*v->numWeights*/surface->maxVertBoneWeights];
            j += 1
        }
    }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:517
func G2_TransformSurfaces(_ surfaceNum: Int32, _ rootSList: inout [surfaceInfo_t], _ boneCache: CBoneCache?, _ currentModel: Model, _ lod: Int32, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ TransformedVertArray: Slots<Int32>, _ secondTimeAround: Bool) {
    var i: Int32
    assert(currentModel.mdxm != nil)
    // back track and get the surfinfo struct for this surface
    let surface = G2_FindSurface(currentModel, surfaceNum, lod)!
    let surfIndexes = MdxmHierarchyOffsets(currentModel.mdxm!, byteOffset: MdxmHeader.byteCount)
    let surfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surface.thisSurfaceIndex])

    // see if we have an override surface in the surface list
    let surfOverride = G2_FindOverrideSurface(surfaceNum, &rootSList)

    // really, we should use the default flags for this surface unless it's been overriden
    var offFlags = Int32(truncatingIfNeeded: surfInfo.flags)

    if surfOverride != nil {
        offFlags = surfOverride!.offFlags
    }
    // if this surface is not off, add it to the shader render list
    if offFlags == 0 {

        R_TransformEachSurface(surface, scale, G2VertSpace, TransformedVertArray, boneCache)
    }

    // if we are turning off all descendants, then stop this recursion now
    if (offFlags & G2SURFACEFLAG_NODESCENDANTS) != 0 {
        return
    }

    // now recursively call for the children
    i = 0
    while i < surfInfo.numChildren {
        G2_TransformSurfaces(surfInfo.childIndexes[i], &rootSList, boneCache, currentModel, lod, scale, G2VertSpace, TransformedVertArray, secondTimeAround)
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:560
func G2_TransformModel(_ ghoul2: CGhoul2Info_v, _ frameNum: Int32, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ useLod: Int32, _ ApplyGore: Bool) {
    var i: Int32
    var lod: Int32
    var correctScale = JKAShared.vec3_t()
    var firstModelOnly = false

    if cg_g2MarksAllModels == nil {
        cg_g2MarksAllModels = Cvar_Get("cg_g2MarksAllModels", "0", 0)
    }

    if cg_g2MarksAllModels == nil
        || cg_g2MarksAllModels!.integer == 0
    {
        firstModelOnly = true
    }

    _VectorCopy(scale, &correctScale)
    // check for scales of 0 - that's the default I believe
    if scale[0] == 0 {
        correctScale[0] = 1.0
    }
    if scale[1] == 0 {
        correctScale[1] = 1.0
    }
    if scale[2] == 0 {
        correctScale[2] = 1.0
    }

    // walk each possible model for this entity and try rendering it out
    i = 0
    while i < ghoul2.size() {
        let g = ghoul2[i]
        // don't bother with models that we don't care about.
        if !g.mValid {
            i += 1
            continue
        }
        assert(g.mBoneCache != nil)
//		assert(G2_MODEL_OK(&g));
        // stop us building this model more than once per frame
        g.mMeshFrameNum = frameNum

        // decide the LOD
        if ApplyGore {
            lod = useLod
            assert(g.currentModel != nil)
            if lod >= g.currentModel!.numLods {
                g.mTransformedVertsArray = nil
                if firstModelOnly {
                    // we don't really need to do multiple models for gore.
                    return
                }
                //do the rest
                i += 1
                continue
            }
        } else {
            lod = G2_DecideTraceLod(g, useLod)
        }

        // give us space for the transformed vertex array to be put in
        if (g.mFlags & GHOUL2_ZONETRANSALLOC) == 0 { //do not stomp if we're using zone space
            let heap = G2VertSpace!.MiniHeapAlloc(g.currentModel!.mdxm!.numSurfaces * 4)
            // AI: Raven casts the `char *` of MiniHeapAlloc to `int *`. The Slots of `numSurfaces` words over the bytes is the cast, so the memset below clears Raven's `numSurfaces * 4` bytes.
            g.mTransformedVertsArray = heap == nil ? nil : Slots<Int32>(scalars: heap!.base, count: Int(g.currentModel!.mdxm!.numSurfaces))
            if g.mTransformedVertsArray == nil {
                Com_Error(ERR_DROP, "Ran out of transform space for Ghoul2 Models. Adjust MiniHeapSize in SV_SpawnServer.\n")
            }
        }

        g.mTransformedVertsArray!.zero()

        _ = G2_FindOverrideSurface(-1, &g.mSlist) //reset the quick surface override lookup;
        // recursively call the model surface transform

        G2_TransformSurfaces(g.mSurfaceRoot, &g.mSlist, g.mBoneCache, g.currentModel!, lod, correctScale, G2VertSpace, g.mTransformedVertsArray!, false)

        if ApplyGore && firstModelOnly {
            // we don't really need to do multiple models for gore.
            break
        }
        i += 1
    }
}

// work out how much space a triangle takes
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:665
private func G2_AreaOfTri(_ A: JKAShared.vec3_t, _ B: JKAShared.vec3_t, _ C: JKAShared.vec3_t) -> Float {
    var cross = JKAShared.vec3_t()
    var ab = JKAShared.vec3_t()
    var cb = JKAShared.vec3_t()
    ab = A - B
    cb = C - B

    CrossProduct(ab, cb, &cross)

    return VectorLength(cross)
}

// actually determine the S and T of the coordinate we hit in a given poly
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:677
private func G2_BuildHitPointST(_ A: JKAShared.vec3_t, _ SA: Float, _ TA: Float,
                                _ B: JKAShared.vec3_t, _ SB: Float, _ TB: Float,
                                _ C: JKAShared.vec3_t, _ SC: Float, _ TC: Float,
                                _ P: JKAShared.vec3_t, _ s: inout Float, _ t: inout Float, _ bary_i: inout Float, _ bary_j: inout Float) {
    let areaABC: Float = G2_AreaOfTri(A, B, C)

    let i: Float = G2_AreaOfTri(P, B, C) / areaABC
    bary_i = i
    let j: Float = G2_AreaOfTri(A, P, C) / areaABC
    bary_j = j
    let k: Float = G2_AreaOfTri(A, B, P) / areaABC

    s = SA * i + SB * j + SC * k
    t = TA * i + TB * j + TC * k

    s = fmod(s, 1)
    if s < 0 {
        s = Float(Double(s) + 1.0)
    }

    t = fmod(t, 1)
    if t < 0 {
        t = Float(Double(t) + 1.0)
    }

}

// routine that works out given a ray whether or not it hits a poly
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:709
func G2_SegmentTriangleTest(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ A: JKAShared.vec3_t, _ B: JKAShared.vec3_t, _ C: JKAShared.vec3_t, _ backFaces: Bool, _ frontFaces: Bool, _ returnedPoint: inout JKAShared.vec3_t, _ returnedNormal: inout JKAShared.vec3_t, _ denom: inout Float) -> Bool {
    let tiny: Float = 1E-10
    var returnedNormalT = JKAShared.vec3_t()
    var edgeAC = JKAShared.vec3_t()

    edgeAC = C - A
    returnedNormalT = B - A

    CrossProduct(returnedNormalT, edgeAC, &returnedNormal)

    var ray = JKAShared.vec3_t()
    ray = end - start

    denom = _DotProduct(ray, returnedNormal)

    if abs(denom) < tiny ||        // triangle parallel to ray
        (!backFaces && denom > 0) ||		// not accepting back faces
        (!frontFaces && denom < 0)		//not accepting front faces
    {
        return false
    }

    var toPlane = JKAShared.vec3_t()
    toPlane = A - start

    let t: Float = _DotProduct(toPlane, returnedNormal) / denom

    if t < 0.0 || t > 1.0 {
        return false // off segment
    }

    ray = ray * t

    returnedPoint = ray + start

    var edgePA = JKAShared.vec3_t()
    edgePA = A - returnedPoint

    var edgePB = JKAShared.vec3_t()
    edgePB = B - returnedPoint

    var edgePC = JKAShared.vec3_t()
    edgePC = C - returnedPoint

    var temp = JKAShared.vec3_t()

    CrossProduct(edgePA, edgePB, &temp)
    if _DotProduct(temp, returnedNormal) < 0.0 {
        return false // off triangle
    }

    CrossProduct(edgePC, edgePA, &temp)
    if _DotProduct(temp, returnedNormal) < 0.0 {
        return false // off triangle
    }

    CrossProduct(edgePB, edgePC, &temp)
    if _DotProduct(temp, returnedNormal) < 0.0 {
        return false // off triangle
    }
    return true
}

// now we at poly level, check each model space transformed poly against the model world transfomed ray
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:804
func G2_GorePolys(_ surface: MdxmSurface, _ TS: CTraceSurface, _ surfInfo: MdxmSurfHierarchy) {
    // Raven's one call is in G2_TraceSurfaces for a trace with no collision records, which only G2API_AddSkinGore starts.
    // No file of the server calls G2API_AddSkinGore, so the function is dead in the dedicated build.
    var j: Int32
    var basis1 = vec3_t()
    var basis2 = vec3_t()
    var taxis = vec3_t()
    var saxis = vec3_t()

    basis2[0] = 0.0
    basis2[1] = 0.0
    basis2[2] = 1.0

    CrossProduct(TS.rayEnd, basis2, &basis1)

    if _DotProduct(basis1, basis1) < 0.1 {
        basis2[0] = 0.0
        basis2[1] = 1.0
        basis2[2] = 0.0
        CrossProduct(TS.rayEnd, basis2, &basis1)
    }

    CrossProduct(TS.rayEnd, basis1, &basis2)
    // Give me a shot direction not a bunch of zeros :) -Gil
    assert(_DotProduct(basis1, basis1) > 0.0001)
    assert(_DotProduct(basis2, basis2) > 0.0001)

    _ = VectorNormalize(&basis1)
    _ = VectorNormalize(&basis2)

    let c: Float = cos(TS.theta)
    let s: Float = sin(TS.theta)

    _VectorScale(basis1, 0.5 * c / TS.tsize, &taxis)
    _VectorMA(taxis, 0.5 * s / TS.tsize, basis2, &taxis)

    _VectorScale(basis1, -0.5 * s / TS.ssize, &saxis)
    _VectorMA(saxis, 0.5 * c / TS.ssize, basis2, &saxis)

    // AI: Raven casts the `int` slot back to a float pointer.
    // The reader gives the floats at that byte offset of the heap of `G2VertSpaceServer`, the one heap that the server hands to the transform, row X8 of docket 10.
    var verts = G2VertSpaceServer!.mHeap!.floats(at: TS.TransformedVertsArray![surface.thisSurfaceIndex])
    let numVerts: Int32 = surface.numVerts
    var flags: Int32 = 15
    assert(numVerts < MAX_GORE_VERTS)
    j = 0
    while j < numVerts {
        let pos: Int32 = j * 5
        var delta = vec3_t()
        delta[0] = verts[pos + 0] - TS.rayStart[0]
        delta[1] = verts[pos + 1] - TS.rayStart[1]
        delta[2] = verts[pos + 2] - TS.rayStart[2]
        let s: Float = _DotProduct(delta, saxis) + 0.5
        let t: Float = _DotProduct(delta, taxis) + 0.5
        var vflags: Int32 = 0
        if s > GORE_MARGIN {
            vflags |= 1
        }
        if s < 1.0 - GORE_MARGIN {
            vflags |= 2
        }
        if t > GORE_MARGIN {
            vflags |= 4
        }
        if t < 1.0 - GORE_MARGIN {
            vflags |= 8
        }
        vflags = (~vflags)
        flags &= vflags
        GoreVerts[j].flags = vflags
        GoreVerts[j].tex[0] = s
        GoreVerts[j].tex[1] = t
        j += 1
    }
    if flags != 0 {
        return // completely off the gore splotch.
    }
    var numTris: Int32
    var newNumTris: Int32
    var newNumVerts: Int32
    numTris = surface.numTriangles
    // AI: Raven casts the surface address plus `ofsTriangles` to a triangle pointer and indexes it. Each triangle is the view at that offset plus `j` times the record size.
    // AI: Raven casts the `int` slot back to a float pointer. The reader is the same as at the first read of `verts`.
    verts = G2VertSpaceServer!.mHeap!.floats(at: TS.TransformedVertsArray![surface.thisSurfaceIndex])
    newNumTris = 0
    newNumVerts = 0
    GoreTouch += 1
    if TS.gore == nil {
        return
    }
    j = 0
    while j < numTris {
        let tri = MdxmTriangle(surface, byteOffset: surface.ofsTriangles + j * Int32(MdxmTriangle.byteCount))
        assert(tri.indexes[0] >= 0 && tri.indexes[0] < numVerts)
        assert(tri.indexes[1] >= 0 && tri.indexes[1] < numVerts)
        assert(tri.indexes[2] >= 0 && tri.indexes[2] < numVerts)
        flags = 15 &
            GoreVerts[tri.indexes[0]].flags &
            GoreVerts[tri.indexes[1]].flags &
            GoreVerts[tri.indexes[2]].flags
        if flags != 0 {
            j += 1
            continue
        }
        if !TS.gore!.frontFaces || !TS.gore!.backFaces {
            // we need to back/front face cull
            var e1 = vec3_t()
            var e2 = vec3_t()
            var n = vec3_t()

            // AI: Raven hands each point as a float pointer to a vector parameter. Each call reads the vector accessor of the first three floats.
            e1 = verts.suffix(from: tri.indexes[1] * 5).vector - verts.suffix(from: tri.indexes[0] * 5).vector
            e2 = verts.suffix(from: tri.indexes[2] * 5).vector - verts.suffix(from: tri.indexes[0] * 5).vector
            CrossProduct(e1, e2, &n)
            if _DotProduct(TS.rayEnd, n) > 0.0 {
                if !TS.gore!.frontFaces {
                    j += 1
                    continue
                }
            } else {
                if !TS.gore!.backFaces {
                    j += 1
                    continue
                }
            }

        }

        var k: Int32

        assert(newNumTris * 3 + 3 < MAX_GORE_INDECIES)
        k = 0
        while k < 3 {
            if GoreVerts[tri.indexes[k]].touch == GoreTouch {
                GoreIndecies[newNumTris * 3 + k] = GoreVerts[tri.indexes[k]].newindex
            } else {
                GoreVerts[tri.indexes[k]].touch = GoreTouch
                GoreVerts[tri.indexes[k]].newindex = newNumVerts
                GoreIndecies[newNumTris * 3 + k] = newNumVerts
                GoreIndexCopy[newNumVerts] = tri.indexes[k]
                newNumVerts += 1
            }
            k += 1
        }
        newNumTris += 1
        j += 1
    }
    if newNumVerts == 0 {
        return
    }

    var newTag: Int32
    let f = GoreTagsTemp[[goreModelIndex, TS.surfaceNum]]
    if f == nil { // need to generate a record
        newTag = AllocGoreRecord()
        var goreSet: CGoreSet? = nil
        if TS.ghoul2info!.mGoreSetTag != 0 {
            goreSet = FindGoreSet(TS.ghoul2info!.mGoreSetTag)
        }
        if goreSet == nil {
            goreSet = NewGoreSet()
            TS.ghoul2info!.mGoreSetTag = goreSet!.mMyGoreSetTag
        }
        assert(goreSet != nil)
        var add = SGoreSurface()
        add.shader = TS.goreShader
        add.mDeleteTime = 0
        if TS.gore!.lifeTime != 0 {
            add.mDeleteTime = G2API_GetTime(0) + TS.gore!.lifeTime
        }
        add.mFadeTime = TS.gore!.fadeOutTime
        add.mFadeRGB = TS.gore!.fadeRGB
        add.mGoreTag = newTag

        add.mGoreGrowStartTime = G2API_GetTime(0)
        if TS.gore!.growDuration == -1 {
            add.mGoreGrowEndTime = -1    // set this to -1 to disable growing
        } else {
            add.mGoreGrowEndTime = G2API_GetTime(0) + TS.gore!.growDuration
        }

        assert(TS.gore!.growDuration != 0)
        add.mGoreGrowFactor = (1.0 - TS.gore!.goreScaleStartFraction) / Float(TS.gore!.growDuration)	//curscale = (curtime-mGoreGrowStartTime)*mGoreGrowFactor;
        add.mGoreGrowOffset = TS.gore!.goreScaleStartFraction

        goreSet!.mGoreRecords[TS.surfaceNum, default: []].append(add)
        GoreTagsTemp[[goreModelIndex, TS.surfaceNum]] = newTag
    } else {
        newTag = f!
    }
    let gore = FindGoreRecord(newTag)
    if gore != nil {
        assert(Float.byteCount == Int32.byteCount)
        // data block format:
        let size: UInt32 = UInt32(
            Int32.byteCount + // num verts
            Int32.byteCount + // num tris
            Int32.byteCount * Int(newNumVerts) + // which verts to copy from original surface
            Float.byteCount * 4 * Int(newNumVerts) + // storgage for deformed verts
            Float.byteCount * 4 * Int(newNumVerts) + // storgage for deformed normal
            Float.byteCount * 2 * Int(newNumVerts) + // texture coordinates
            Int32.byteCount * Int(newNumTris) * 3  // new indecies
        )

        // AI: Raven walks the block with an `int` pointer and a `float` pointer. Each pointer is an index local into its Slots over the block.
        let data = Slots<Int32>(scalars: Z_Malloc(Int32(UInt32(Int32.byteCount) * size), TAG_GHOUL2_GORE, true), count: Int(size))
        var dataIndex: Int32 = 0
        var i: Int32

        if gore!.tex[TS.lod] != nil {
            Z_Free(OpaquePointer(gore!.tex[TS.lod]!.base))
        }

        gore!.tex[TS.lod] = Slots<Float>(scalars: data.base, count: data.count)
        data[dataIndex] = newNumVerts
        dataIndex += 1
        data[dataIndex] = newNumTris
        dataIndex += 1

        // AI: Raven copies the ints with `memcpy`. `GoreIndexCopy` is a Swift array of the world, so a loop copies each int.
        i = 0
        while i < newNumVerts {
            data[dataIndex + i] = GoreIndexCopy[i]
            i += 1
        }
        dataIndex += newNumVerts * 9 // skip verts and normals
        let fdata = gore!.tex[TS.lod]!
        var fdataIndex: Int32 = dataIndex

        j = 0
        while j < newNumVerts {
            fdata[fdataIndex] = GoreVerts[GoreIndexCopy[j]].tex[0]
            fdataIndex += 1
            fdata[fdataIndex] = GoreVerts[GoreIndexCopy[j]].tex[1]
            fdataIndex += 1
            j += 1
        }
        dataIndex = fdataIndex
        // AI: Raven copies the ints with `memcpy`. `GoreIndecies` is a Swift array of the world, so a loop copies each int.
        i = 0
        while i < newNumTris * 3 {
            data[dataIndex + i] = GoreIndecies[i]
            i += 1
        }
        dataIndex += newNumTris * 3
        assert(UInt32(dataIndex) * UInt32(Int32.byteCount) == size)
        fdataIndex = dataIndex
        // build the entity to gore matrix
        fdata.suffix(from: fdataIndex + 0).vector = saxis
        fdata.suffix(from: fdataIndex + 4).vector = taxis
        fdata.suffix(from: fdataIndex + 8).vector = TS.rayEnd
        _ = VectorNormalize(&fdata.suffix(from: fdataIndex + 0).vector)
        _ = VectorNormalize(&fdata.suffix(from: fdataIndex + 4).vector)
        _ = VectorNormalize(&fdata.suffix(from: fdataIndex + 8).vector)
        fdata[fdataIndex + 3] = -0.5 // subtract texture center
        fdata[fdataIndex + 7] = -0.5
        fdata[fdataIndex + 11] = 0.0
        var shotOriginInCurrentSpace = vec3_t() // unknown space
        TransformPoint(TS.rayStart, &shotOriginInCurrentSpace, MdxaBone(fdata.suffix(from: fdataIndex).base)) // dest middle arg
        // this will insure the shot origin in our unknown space is now the shot origin, making it a known space
        fdata[fdataIndex + 3] -= shotOriginInCurrentSpace[0]
        fdata[fdataIndex + 7] -= shotOriginInCurrentSpace[1]
        fdata[fdataIndex + 11] -= shotOriginInCurrentSpace[2]
        Inverse_Matrix(MdxaBone(fdata.suffix(from: fdataIndex).base), MdxaBone(fdata.suffix(from: fdataIndex + 12).base))  // dest 2nd arg
        dataIndex += 24

//		assert((data - (int *)gore->tex[TS.lod]) * sizeof(int) == size);
    }
}

// now we're at poly level, check each model space transformed poly against the model world transfomed ray
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1092
private func G2_TracePolys(_ surface: MdxmSurface, _ surfInfo: MdxmSurfHierarchy, _ TS: CTraceSurface) -> Bool {
    var j: Int32
    let numTris: Int32

    // whip through and actually transform each vertex
    // AI: Raven casts the surface address plus `ofsTriangles` to a triangle pointer and indexes it. Each triangle is the view at that offset plus `j` times the record size.
    // AI: Raven casts the `int` slot back to a float pointer.
    // The reader gives the floats at that byte offset of the heap of `G2VertSpaceServer`, the one heap that the server hands to the transform, row X8 of docket 10.
    let verts = G2VertSpaceServer!.mHeap!.floats(at: TS.TransformedVertsArray![surface.thisSurfaceIndex])
    numTris = surface.numTriangles
    j = 0
    while j < numTris {
        let tri = MdxmTriangle(surface, byteOffset: surface.ofsTriangles + j * Int32(MdxmTriangle.byteCount))
        var face: Float = 0
        var hitPoint = vec3_t()
        var normal = vec3_t()
        // determine actual coords for this triangle
        let point1 = verts.suffix(from: tri.indexes[0] * 5)
        let point2 = verts.suffix(from: tri.indexes[1] * 5)
        let point3 = verts.suffix(from: tri.indexes[2] * 5)
        // did we hit it?
        var i: Int32
        // AI: Raven hands each point as a float pointer to a vector parameter. Each call reads the vector accessor of the first three floats.
        if G2_SegmentTriangleTest(TS.rayStart, TS.rayEnd, point1.vector, point2.vector, point3.vector, true, true, &hitPoint, &normal, &face) {	// find space in the collision records for this record
            i = 0
            while i < MAX_G2_COLLISIONS {
                if TS.collRecMap![i].mEntityNum == -1 {
                    let newCol = TS.collRecMap![i]
                    var distVect = vec3_t()
                    var x_pos: Float = 0
                    var y_pos: Float = 0

                    newCol.mPolyIndex = j
                    newCol.mEntityNum = TS.entNum
                    newCol.mSurfaceIndex = surface.thisSurfaceIndex
                    newCol.mModelIndex = TS.modelIndex
                    if face > 0 {
                        newCol.mFlags = G2_FRONTFACE
                    } else {
                        newCol.mFlags = G2_BACKFACE
                    }

                    _VectorSubtract(hitPoint, TS.rayStart, &distVect)
                    newCol.mDistance = VectorLength(distVect)

                    // put the hit point back into world space
                    TransformAndTranslatePoint(hitPoint, &newCol.mCollisionPosition, worldMatrix)

                    // transform normal (but don't translate) into world angles
                    TransformPoint(normal, &newCol.mCollisionNormal, worldMatrix)
                    _ = VectorNormalize(&newCol.mCollisionNormal)

                    newCol.mLocation = 0
                    newCol.mMaterial = newCol.mLocation

                    // Determine our location within the texture, and barycentric coordinates
                    G2_BuildHitPointST(point1.vector, point1[3], point1[4],
                                       point2.vector, point2[3], point2[4],
                                       point3.vector, point3[3], point3[4],
                                       hitPoint, &x_pos, &y_pos, &newCol.mBarycentricI, &newCol.mBarycentricJ)

                    // Raven's block that reads the hit location and the hit material of the shader stands in a comment at G2_misc.cpp:1149.

                    // exit now if we should
                    if TS.traceFlags == G2_RETURNONHIT {
                        TS.hitOne = true
                        return true
                    }

                    break
                }
                i += 1
            }
            if i == MAX_G2_COLLISIONS {
                //assert(i!=MAX_G2_COLLISIONS);		// run out of collision record space - will probalbly never happen
                //It happens. And the assert is bugging me.
                TS.hitOne = true	//force stop recursion
                return true	// return true to avoid wasting further time, but no hit will result without a record
            }
        }
        j += 1
    }
    return false
}

// now we're at poly level, check each model space transformed poly against the model world transfomed ray
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1222
private func G2_RadiusTracePolys(_ surface: MdxmSurface, _ TS: CTraceSurface) -> Bool {
    var j: Int32
    var basis1 = vec3_t()
    var basis2 = vec3_t()
    var taxis = vec3_t()
    var saxis = vec3_t()

    basis2[0] = 0.0
    basis2[1] = 0.0
    basis2[2] = 1.0

    var v3RayDir = vec3_t()
    _VectorSubtract(TS.rayEnd, TS.rayStart, &v3RayDir)

    CrossProduct(v3RayDir, basis2, &basis1)

    if _DotProduct(basis1, basis1) < 0.1 {
        basis2[0] = 0.0
        basis2[1] = 1.0
        basis2[2] = 0.0
        CrossProduct(v3RayDir, basis2, &basis1)
    }

    CrossProduct(v3RayDir, basis1, &basis2)
    // Give me a shot direction not a bunch of zeros :) -Gil
//	assert(DotProduct(basis1,basis1)>.0001f);
//	assert(DotProduct(basis2,basis2)>.0001f);

    _ = VectorNormalize(&basis1)
    _ = VectorNormalize(&basis2)

    let c: Float = cos(0.0)//theta
    let s: Float = sin(0.0)//theta

    _VectorScale(basis1, 0.5 * c / TS.m_fRadius, &taxis)
    _VectorMA(taxis, 0.5 * s / TS.m_fRadius, basis2, &taxis)

    _VectorScale(basis1, -0.5 * s / TS.m_fRadius, &saxis)
    _VectorMA(saxis, 0.5 * c / TS.m_fRadius, basis2, &saxis)

    // AI: Raven casts the `int` slot back to a float pointer.
    // The reader gives the floats at that byte offset of the heap of `G2VertSpaceServer`, the one heap that the server hands to the transform, row X8 of docket 10.
    let verts = G2VertSpaceServer!.mHeap!.floats(at: TS.TransformedVertsArray![surface.thisSurfaceIndex])
    let numVerts: Int32 = surface.numVerts

    var flags: Int32 = 63
    //rayDir/=lengthSquared(raydir);
    let f: Float = VectorLengthSquared(v3RayDir)
    v3RayDir[0] /= f
    v3RayDir[1] /= f
    v3RayDir[2] /= f

    j = 0
    while j < numVerts {
        let pos: Int32 = j * 5
        var delta = vec3_t()
        delta[0] = verts[pos + 0] - TS.rayStart[0]
        delta[1] = verts[pos + 1] - TS.rayStart[1]
        delta[2] = verts[pos + 2] - TS.rayStart[2]
        let s: Float = _DotProduct(delta, saxis) + 0.5
        let t: Float = _DotProduct(delta, taxis) + 0.5
        let u: Float = _DotProduct(delta, v3RayDir)
        var vflags: Int32 = 0

        if s > 0 {
            vflags |= 1
        }
        if s < 1 {
            vflags |= 2
        }
        if t > 0 {
            vflags |= 4
        }
        if t < 1 {
            vflags |= 8
        }
        if u > 0 {
            vflags |= 16
        }
        if u < 1 {
            vflags |= 32
        }

        vflags = (~vflags)
        flags &= vflags
        GoreVerts[j].flags = vflags
        j += 1
    }

    if flags != 0 {
        return false // completely off the gore splotch  (so presumably hit nothing? -Ste)
    }
    let numTris: Int32 = surface.numTriangles
    // AI: Raven casts the surface address plus `ofsTriangles` to a triangle pointer and indexes it. Each triangle is the view at that offset plus `j` times the record size.

    j = 0
    while j < numTris {
        let tri = MdxmTriangle(surface, byteOffset: surface.ofsTriangles + j * Int32(MdxmTriangle.byteCount))
        assert(tri.indexes[0] >= 0 && tri.indexes[0] < numVerts)
        assert(tri.indexes[1] >= 0 && tri.indexes[1] < numVerts)
        assert(tri.indexes[2] >= 0 && tri.indexes[2] < numVerts)
        flags = 63 &
            GoreVerts[tri.indexes[0]].flags &
            GoreVerts[tri.indexes[1]].flags &
            GoreVerts[tri.indexes[2]].flags
        var i: Int32
        if flags != 0 {
            j += 1
            continue
        } else {
            // we hit a triangle, so init a collision record...
            //
            i = 0
            while i < MAX_G2_COLLISIONS {
                if TS.collRecMap![i].mEntityNum == -1 {
                    let newCol = TS.collRecMap![i]

                    newCol.mPolyIndex = j
                    newCol.mEntityNum = TS.entNum
                    newCol.mSurfaceIndex = surface.thisSurfaceIndex
                    newCol.mModelIndex = TS.modelIndex
//					if (face>0)
//					{
                    newCol.mFlags = G2_FRONTFACE
//					}
//					else
//					{
//						newCol.mFlags = G2_BACKFACE;
//					}

                    //get normal from triangle
                    let A = verts.suffix(from: tri.indexes[0] * 5)
                    let B = verts.suffix(from: tri.indexes[1] * 5)
                    let C = verts.suffix(from: tri.indexes[2] * 5)
                    var normal = vec3_t()
                    var edgeAC = vec3_t()
                    var edgeBA = vec3_t()

                    // AI: Raven hands each point as a float pointer to a vector parameter. Each call reads the vector accessor of the first three floats.
                    _VectorSubtract(C.vector, A.vector, &edgeAC)
                    _VectorSubtract(B.vector, A.vector, &edgeBA)
                    CrossProduct(edgeBA, edgeAC, &normal)

                    // transform normal (but don't translate) into world angles
                    TransformPoint(normal, &newCol.mCollisionNormal, worldMatrix)
                    _ = VectorNormalize(&newCol.mCollisionNormal)

                    newCol.mLocation = 0
                    newCol.mMaterial = newCol.mLocation
                    // exit now if we should
                    if TS.traceFlags == G2_RETURNONHIT {
                        TS.hitOne = true
                        return true
                    }

                    var distVect = vec3_t()
                    //yeah, I want the collision point. Let's work out the impact point on the triangle. -rww
                    var hitPoint = vec3_t()
                    let side: Float
                    let side2: Float
                    let dist: Float
                    let third: Float = -(A[0] * (B[1] * C[2] - C[1] * B[2]) + B[0] * (C[1] * A[2] - A[1] * C[2]) + C[0] * (A[1] * B[2] - B[1] * A[2]))

                    _VectorSubtract(TS.rayEnd, TS.rayStart, &distVect)
                    side = normal[0] * TS.rayStart[0] + normal[1] * TS.rayStart[1] + normal[2] * TS.rayStart[2] + third
                    side2 = normal[0] * distVect[0] + normal[1] * distVect[1] + normal[2] * distVect[2]
                    dist = side / side2
                    _VectorMA(TS.rayStart, -dist, distVect, &hitPoint)

                    _VectorSubtract(hitPoint, TS.rayStart, &distVect)
                    newCol.mDistance = VectorLength(distVect)

                    // put the hit point back into world space
                    TransformAndTranslatePoint(hitPoint, &newCol.mCollisionPosition, worldMatrix)
                    newCol.mBarycentricJ = 0.0
                    newCol.mBarycentricI = newCol.mBarycentricJ
                    break
                }
                i += 1
            }
            if i == MAX_G2_COLLISIONS {
                //assert(i!=MAX_G2_COLLISIONS);		// run out of collision record space - happens OFTEN
                TS.hitOne = true	//force stop recursion
                return true	// return true to avoid wasting further time, but no hit will result without a record
            }
        }
        j += 1
    }

    return false
}

// look at a surface and then do the trace on each poly
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1428
private func G2_TraceSurfaces(_ TS: CTraceSurface) {
    var i: Int32
    // back track and get the surfinfo struct for this surface
    assert(TS.currentModel != nil)
    assert(TS.currentModel!.mdxm != nil)
    let surface = G2_FindSurface(TS.currentModel, TS.surfaceNum, TS.lod)!
    let surfIndexes = MdxmHierarchyOffsets(TS.currentModel!.mdxm!, byteOffset: MdxmHeader.byteCount)
    let surfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surface.thisSurfaceIndex])

    // see if we have an override surface in the surface list
    let surfOverride = G2_FindOverrideSurface(TS.surfaceNum, &TS.rootSList)

    // don't allow recursion if we've already hit a polygon
    if TS.hitOne {
        return
    }

    // really, we should use the default flags for this surface unless it's been overriden
    var offFlags = Int32(truncatingIfNeeded: surfInfo.flags)

    // set the off flags if we have some
    if surfOverride != nil {
        offFlags = surfOverride!.offFlags
    }

    // if this surface is not off, try to hit it
    if offFlags == 0 {
        if TS.collRecMap != nil {
            if !(Double(abs(TS.m_fRadius)) < 0.1) {	// if not a point-trace
                // .. then use radius check
                //
                if G2_RadiusTracePolys(surface,		// const mdxmSurface_t *surface,
                                       TS
                                       )
                    && (TS.traceFlags == G2_RETURNONHIT)
                {
                    TS.hitOne = true
                    return
                }
            } else {
                // go away and trace the polys in this surface
                if G2_TracePolys(surface, surfInfo, TS)
                    && (TS.traceFlags == G2_RETURNONHIT)
                {
                    // ok, we hit one, *and* we want to return instantly because the returnOnHit is set
                    // so indicate we've hit one, so other surfaces don't get hit and return
                    TS.hitOne = true
                    return
                }
            }
        } else {
            G2_GorePolys(surface, TS, surfInfo)
        }
    }

    // if we are turning off all descendants, then stop this recursion now
    if (offFlags & G2SURFACEFLAG_NODESCENDANTS) != 0 {
        return
    }

    // now recursively call for the children
    i = 0
    while i < surfInfo.numChildren && !TS.hitOne {
        TS.surfaceNum = surfInfo.childIndexes[i]
        G2_TraceSurfaces(TS)
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1514
func G2_TraceModels(_ ghoul2: CGhoul2Info_v, _ rayStart: JKAShared.vec3_t, _ rayEnd: JKAShared.vec3_t, _ collRecMap: Slots<CollisionRecord>?, _ entNum: Int32, _ eG2TraceType: Int32, _ useLod: Int32, _ fRadius: Float, _ ssize: Float, _ tsize: Float, _ theta: Float, _ shader: Int32, _ gore: SkinGoreData?, _ skipIfLODNotMatch: Bool) {
    var i: Int32
    var lod: Int32
    var skin: Skin?
    var cust_shader: Shader?
    var firstModelOnly = false

    if cg_g2MarksAllModels == nil {
        cg_g2MarksAllModels = Cvar_Get("cg_g2MarksAllModels", "0", 0)
    }

    if cg_g2MarksAllModels == nil
        || cg_g2MarksAllModels!.integer == 0
    {
        firstModelOnly = true
    }

    // walk each possible model for this entity and try tracing against it
    i = 0
    while i < ghoul2.size() {
        goreModelIndex = i
        // don't bother with models that we don't care about.
        if ghoul2[i].mModelindex == -1 {
            i += 1
            continue
        }

        // don't bother with models that we don't care about.
        if !ghoul2[i].mValid {
            i += 1
            continue
        }
//		assert(G2_MODEL_OK(&ghoul2[i]));
        // do we really want to collide with this object?
        if (ghoul2[i].mFlags & GHOUL2_NOCOLLIDE) != 0 {
            i += 1
            continue
        }

        if ghoul2[i].mCustomShader != 0 && ghoul2[i].mCustomShader != -20 { //rww - -20 is a server instance (hack)
            cust_shader = R_GetShaderByHandle(ghoul2[i].mCustomShader)
        } else {
            cust_shader = nil
        }

        // figure out the custom skin thing
        if ghoul2[i].mSkin > 0 && ghoul2[i].mSkin < tr.numSkins {
            skin = R_GetSkinByHandle(ghoul2[i].mSkin)
        } else {
            skin = nil
        }

        lod = G2_DecideTraceLod(ghoul2[i], useLod)
        if skipIfLODNotMatch {//we only want to hit this SPECIFIC LOD...
            if lod != useLod {//doesn't match, skip this model
                i += 1
                continue
            }
        }

        //reset the quick surface override lookup
        _ = G2_FindOverrideSurface(-1, &ghoul2[i].mSlist)

        let TS = CTraceSurface(
            ghoul2[i].mSurfaceRoot,
            ghoul2[i].mSlist,
            ghoul2[i].currentModel,
            lod,
            rayStart,
            rayEnd,
            collRecMap,
            entNum,
            i,
            skin,
            cust_shader,
            ghoul2[i].mTransformedVertsArray,
            eG2TraceType,
            fRadius,
            ssize,
            tsize,
            theta,
            shader,
            ghoul2[i],
            gore
        )
        // start the surface recursion loop
        G2_TraceSurfaces(TS)

        // if we've hit one surface on one model, don't bother doing the rest
        if TS.hitOne {
            break
        }
        if collRecMap == nil && firstModelOnly {
            // we don't really need to do multiple models for gore.
            break
        }
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1613
func TransformPoint(_ `in`: JKAShared.vec3_t, _ out: inout JKAShared.vec3_t, _ mat: JKAMP.MdxaBone) {
    var i: Int32 = 0
    while i < 3 {
        out[i] = `in`[0] * mat.matrix[i][0] + `in`[1] * mat.matrix[i][1] + `in`[2] * mat.matrix[i][2]
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1620
func TransformAndTranslatePoint(_ `in`: JKAShared.vec3_t, _ out: inout JKAShared.vec3_t, _ mat: JKAMP.MdxaBone) {

    var i: Int32 = 0
    while i < 3 {
        out[i] = `in`[0] * mat.matrix[i][0] + `in`[1] * mat.matrix[i][1] + `in`[2] * mat.matrix[i][2] + mat.matrix[i][3]
        i += 1
    }
}

// create a matrix using a set of angles
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1630
func Create_Matrix(_ angle: JKAShared.vec3_t, _ matrix: JKAMP.MdxaBone) {
    var axis = [vec3_t](repeating: vec3_t(), count: 3)

    // convert angles to axis
    AnglesToAxis(angle, &axis)
    matrix.matrix[0][0] = axis[0][0]
    matrix.matrix[1][0] = axis[0][1]
    matrix.matrix[2][0] = axis[0][2]

    matrix.matrix[0][1] = axis[1][0]
    matrix.matrix[1][1] = axis[1][1]
    matrix.matrix[2][1] = axis[1][2]

    matrix.matrix[0][2] = axis[2][0]
    matrix.matrix[1][2] = axis[2][1]
    matrix.matrix[2][2] = axis[2][2]

    matrix.matrix[0][3] = 0
    matrix.matrix[1][3] = 0
    matrix.matrix[2][3] = 0


}

// given a matrix, generate the inverse of that matrix
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1656
func Inverse_Matrix(_ src: JKAMP.MdxaBone, _ dest: JKAMP.MdxaBone) {
    var i: Int32
    var j: Int32

    i = 0
    while i < 3 {
        j = 0
        while j < 3 {
            dest.matrix[i][j] = src.matrix[j][i]
            j += 1
        }
        i += 1
    }
    i = 0
    while i < 3 {
        dest.matrix[i][3] = 0
        j = 0
        while j < 3 {
            dest.matrix[i][3] -= dest.matrix[i][j] * src.matrix[j][3]
            j += 1
        }
        i += 1
    }
}

// generate the world matrix for a given set of angles and origin - called from lots of places
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1678
func G2_GenerateWorldMatrix(_ angles: JKAShared.vec3_t, _ origin: JKAShared.vec3_t) {
    Create_Matrix(angles, worldMatrix)
    worldMatrix.matrix[0][3] = origin[0]
    worldMatrix.matrix[1][3] = origin[1]
    worldMatrix.matrix[2][3] = origin[2]

    Inverse_Matrix(worldMatrix, worldMatrixInv)
}

// go away and determine what the pointer for a specific surface definition within the model definition is
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1689
func G2_FindSurface(_ mod_t: Model?, _ index: Int32, _ lod: Int32) -> MdxmSurface? {
    // damn include file dependancies
    let mod = mod_t!

    // point at first lod list
    // Raven's `current` is a byte pointer, and each read casts it to the record at its address.
    var current = MdxmLOD(mod.mdxm!, byteOffset: mod.mdxm!.ofsLODs)
    var i: Int32

    //walk the lods
    i = 0
    while i < lod {
        let lodData = current
        current = MdxmLOD(current, byteOffset: lodData.ofsEnd)
        i += 1
    }

    // avoid the lod pointer data structure
    let indexes = MdxmLODSurfOffset(current, byteOffset: MdxmLOD.byteCount)
    // we are now looking at the offset array
    return MdxmSurface(indexes, byteOffset: indexes.offsets[index])
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1715
// AI: Raven takes `sizeof` of the struct. The Swift class has no byte size, so the constant holds the byte count of the 32-bit build.
private let SURFACE_SAVE_BLOCK_SIZE = 24 as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1716
// AI: Raven takes `sizeof` of the struct less its `position` record. The constant holds the byte count of the 32-bit build, four ints.
private let BOLT_SAVE_BLOCK_SIZE = 16 as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1717
// AI: Raven takes `sizeof` of the struct. The Swift class has no byte size, so the constant holds the byte count of the 32-bit build.
private let BONE_SAVE_BLOCK_SIZE = 744 as Int32

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1719
// AI: Raven hands a `char **` out-pointer to a zone block. The parameter is the Slots of bytes of that block, the form of a `void **` of kind `bytes`.
func G2_SaveGhoul2Models(_ ghoul2: CGhoul2Info_v, _ buffer: inout Slots<JKAShared.byte>?, _ size: inout Int32) -> Bool {
    // G2API_SaveGhoul2Models is the one caller, and no file of the MP tree calls it, so the function is dead.

    // is there anything to save?
    if ghoul2.size() == 0 {
        buffer = Slots<JKAShared.byte>(scalars: Z_Malloc(4, TAG_GHOUL2, true), count: 4)
        let tempBuffer = buffer!
        tempBuffer[int: 0] = 0
        size = 4
        return true
    }

    // yeah, lets get busy
    size = 0

    // this one isn't a define since I couldn't work out how to figure it out at compile time
    // AI: Raven subtracts two member addresses. The constant holds the byte count of the band from mModelindex to mFlags in the 32-bit build.
    let ghoul2BlockSize = 116 as Int32

    // add in count for number of ghoul2 models
    size += 4
    // start out working out the total size of the buffer we need to allocate
    var i: Int32 // Linux GCC is forcing new scoping rules
    i = 0
    while i < ghoul2.size() {
        size += ghoul2BlockSize
        // add in count for number of surfaces
        size += 4
        size += (Int32(ghoul2[i].mSlist.count) * SURFACE_SAVE_BLOCK_SIZE)
        // add in count for number of bones
        size += 4
        size += (Int32(ghoul2[i].mBlist.count) * BONE_SAVE_BLOCK_SIZE)
        // add in count for number of bolts
        size += 4
        size += (Int32(ghoul2[i].mBltlist.count) * BOLT_SAVE_BLOCK_SIZE)
        i += 1
    }

    // ok, we should know how much space we need now
    buffer = Slots<JKAShared.byte>(scalars: Z_Malloc(size, TAG_GHOUL2, true), count: Int(size))

    // now lets start putting the data we care about into the buffer
    var tempBuffer = buffer!

    // save out how many ghoul2 models we have
    tempBuffer[int: 0] = ghoul2.size()
    tempBuffer = tempBuffer.suffix(from: 4)

    i = 0
    while i < ghoul2.size() {
        // first save out the ghoul2 details themselves
//		OutputDebugString(va("G2_SaveGhoul2Models(): ghoul2[%d].mModelindex = %d\n",i,ghoul2[i].mModelindex));
        // AI: Raven copies the band of CGhoul2Info from mModelindex to mFlags with memcpy. The body writes each member at its offset in the 32-bit build.
        tempBuffer[int: 0] = ghoul2[i].mModelindex
        tempBuffer[int: 4] = ghoul2[i].mCustomShader
        tempBuffer[int: 8] = ghoul2[i].mCustomSkin
        tempBuffer[int: 12] = ghoul2[i].mModelBoltLink
        tempBuffer[int: 16] = ghoul2[i].mSurfaceRoot
        tempBuffer[int: 20] = ghoul2[i].mLodBias
        tempBuffer[int: 24] = ghoul2[i].mNewOrigin
        tempBuffer[int: 28] = ghoul2[i].mGoreSetTag
        tempBuffer[int: 32] = ghoul2[i].mModel
        Com_Memcpy(tempBuffer.suffix(from: 36), ghoul2[i].mFileName, MAX_QPATH)
        tempBuffer[int: 100] = ghoul2[i].mAnimFrameDefault
        tempBuffer[int: 104] = ghoul2[i].mSkelFrameNum
        tempBuffer[int: 108] = ghoul2[i].mMeshFrameNum
        tempBuffer[int: 112] = ghoul2[i].mFlags
        tempBuffer = tempBuffer.suffix(from: ghoul2BlockSize)

        // save out how many surfaces we have
        tempBuffer[int: 0] = Int32(ghoul2[i].mSlist.count)
        tempBuffer = tempBuffer.suffix(from: 4)

        // now save the all the surface list info
        var x: Int32
        x = 0
        while x < ghoul2[i].mSlist.count {
            // AI: Raven copies each `surfaceInfo_t` whole with memcpy. The body writes each member at its offset in the 32-bit build.
            let surf = ghoul2[i].mSlist[x]
            tempBuffer[int: 0] = surf.offFlags
            tempBuffer[int: 4] = surf.surface
            tempBuffer[float: 8] = surf.genBarycentricJ
            tempBuffer[float: 12] = surf.genBarycentricI
            tempBuffer[int: 16] = surf.genPolySurfaceIndex
            tempBuffer[int: 20] = surf.genLod
            tempBuffer = tempBuffer.suffix(from: SURFACE_SAVE_BLOCK_SIZE)
            x += 1
        }

        // save out how many bones we have
        tempBuffer[int: 0] = Int32(ghoul2[i].mBlist.count)
        tempBuffer = tempBuffer.suffix(from: 4)

        // now save the all the bone list info
        x = 0
        while x < ghoul2[i].mBlist.count {
            // AI: Raven copies each `boneInfo_t` whole with memcpy. The body writes each member at its offset in the 32-bit build.
            // Port-note: Raven copies the padding bytes 658 to 659 and 685 to 687 uninitialized. The zeroed block keeps those bytes zero.
            let bone = ghoul2[i].mBlist[x]
            tempBuffer[int: 0] = bone.boneNumber
            Com_Memcpy(tempBuffer.suffix(from: 4), bone.matrix.matrix.bytes, 48)
            tempBuffer[int: 52] = bone.flags
            tempBuffer[int: 56] = bone.startFrame
            tempBuffer[int: 60] = bone.endFrame
            tempBuffer[int: 64] = bone.startTime
            tempBuffer[int: 68] = bone.pauseTime
            tempBuffer[float: 72] = bone.animSpeed
            tempBuffer[float: 76] = bone.blendFrame
            tempBuffer[int: 80] = bone.blendLerpFrame
            tempBuffer[int: 84] = bone.blendTime
            tempBuffer[int: 88] = bone.blendStart
            tempBuffer[int: 92] = bone.boneBlendTime
            tempBuffer[int: 96] = bone.boneBlendStart
            tempBuffer[int: 100] = bone.lastTime
            Com_Memcpy(tempBuffer.suffix(from: 104), bone.newMatrix.matrix.bytes, 48)
            tempBuffer[int: 152] = bone.lastTimeUpdated
            tempBuffer[int: 156] = bone.lastContents
            tempBuffer[float: 160] = bone.lastPosition[0]
            tempBuffer[float: 164] = bone.lastPosition[1]
            tempBuffer[float: 168] = bone.lastPosition[2]
            tempBuffer[float: 172] = bone.velocityEffector[0]
            tempBuffer[float: 176] = bone.velocityEffector[1]
            tempBuffer[float: 180] = bone.velocityEffector[2]
            tempBuffer[float: 184] = bone.lastAngles[0]
            tempBuffer[float: 188] = bone.lastAngles[1]
            tempBuffer[float: 192] = bone.lastAngles[2]
            tempBuffer[float: 196] = bone.minAngles[0]
            tempBuffer[float: 200] = bone.minAngles[1]
            tempBuffer[float: 204] = bone.minAngles[2]
            tempBuffer[float: 208] = bone.maxAngles[0]
            tempBuffer[float: 212] = bone.maxAngles[1]
            tempBuffer[float: 216] = bone.maxAngles[2]
            tempBuffer[float: 220] = bone.currentAngles[0]
            tempBuffer[float: 224] = bone.currentAngles[1]
            tempBuffer[float: 228] = bone.currentAngles[2]
            tempBuffer[float: 232] = bone.anglesOffset[0]
            tempBuffer[float: 236] = bone.anglesOffset[1]
            tempBuffer[float: 240] = bone.anglesOffset[2]
            tempBuffer[float: 244] = bone.positionOffset[0]
            tempBuffer[float: 248] = bone.positionOffset[1]
            tempBuffer[float: 252] = bone.positionOffset[2]
            tempBuffer[float: 256] = bone.radius
            tempBuffer[float: 260] = bone.weight
            tempBuffer[int: 264] = bone.ragIndex
            tempBuffer[float: 268] = bone.velocityRoot[0]
            tempBuffer[float: 272] = bone.velocityRoot[1]
            tempBuffer[float: 276] = bone.velocityRoot[2]
            tempBuffer[int: 280] = bone.ragStartTime
            tempBuffer[int: 284] = bone.firstTime
            tempBuffer[int: 288] = bone.firstCollisionTime
            tempBuffer[int: 292] = bone.restTime
            tempBuffer[int: 296] = bone.RagFlags
            tempBuffer[int: 300] = bone.DependentRagIndexMask
            Com_Memcpy(tempBuffer.suffix(from: 304), bone.originalTrueBoneMatrix.matrix.bytes, 48)
            Com_Memcpy(tempBuffer.suffix(from: 352), bone.parentTrueBoneMatrix.matrix.bytes, 48)
            Com_Memcpy(tempBuffer.suffix(from: 400), bone.parentOriginalTrueBoneMatrix.matrix.bytes, 48)
            tempBuffer[float: 448] = bone.originalOrigin[0]
            tempBuffer[float: 452] = bone.originalOrigin[1]
            tempBuffer[float: 456] = bone.originalOrigin[2]
            tempBuffer[float: 460] = bone.originalAngles[0]
            tempBuffer[float: 464] = bone.originalAngles[1]
            tempBuffer[float: 468] = bone.originalAngles[2]
            tempBuffer[float: 472] = bone.lastShotDir[0]
            tempBuffer[float: 476] = bone.lastShotDir[1]
            tempBuffer[float: 480] = bone.lastShotDir[2]
            // AI: Raven copies the four basepose pointers, which hold addresses of this process. A view does not fit in 4 bytes, so the four words are zero.
            tempBuffer[int: 484] = 0
            tempBuffer[int: 488] = 0
            tempBuffer[int: 492] = 0
            tempBuffer[int: 496] = 0
            tempBuffer[int: 500] = bone.parentRawBoneIndex
            Com_Memcpy(tempBuffer.suffix(from: 504), bone.ragOverrideMatrix.matrix.bytes, 48)
            Com_Memcpy(tempBuffer.suffix(from: 552), bone.extraMatrix.matrix.bytes, 48)
            tempBuffer[float: 600] = bone.extraVec1[0]
            tempBuffer[float: 604] = bone.extraVec1[1]
            tempBuffer[float: 608] = bone.extraVec1[2]
            tempBuffer[float: 612] = bone.extraFloat1
            tempBuffer[int: 616] = bone.extraInt1
            tempBuffer[float: 620] = bone.ikPosition[0]
            tempBuffer[float: 624] = bone.ikPosition[1]
            tempBuffer[float: 628] = bone.ikPosition[2]
            tempBuffer[float: 632] = bone.ikSpeed
            tempBuffer[float: 636] = bone.epVelocity[0]
            tempBuffer[float: 640] = bone.epVelocity[1]
            tempBuffer[float: 644] = bone.epVelocity[2]
            tempBuffer[float: 648] = bone.epGravFactor
            tempBuffer[int: 652] = bone.solidCount
            tempBuffer[byte: 656] = Int32(bone.physicsSettled ? 1 : 0)
            tempBuffer[byte: 657] = Int32(bone.snapped ? 1 : 0)
            tempBuffer[int: 660] = bone.parentBoneIndex
            tempBuffer[float: 664] = bone.offsetRotation
            tempBuffer[float: 668] = bone.overGradSpeed
            tempBuffer[float: 672] = bone.overGoalSpot[0]
            tempBuffer[float: 676] = bone.overGoalSpot[1]
            tempBuffer[float: 680] = bone.overGoalSpot[2]
            tempBuffer[byte: 684] = Int32(bone.hasOverGoal ? 1 : 0)
            Com_Memcpy(tempBuffer.suffix(from: 688), bone.animFrameMatrix.matrix.bytes, 48)
            tempBuffer[int: 736] = bone.hasAnimFrameMatrix
            tempBuffer[int: 740] = bone.airTime
            tempBuffer = tempBuffer.suffix(from: BONE_SAVE_BLOCK_SIZE)
            x += 1
        }

        // save out how many bolts we have
        tempBuffer[int: 0] = Int32(ghoul2[i].mBltlist.count)
        tempBuffer = tempBuffer.suffix(from: 4)

        // lastly save the all the bolt list info
        x = 0
        while x < ghoul2[i].mBltlist.count {
            // AI: Raven copies the first 16 bytes of each `boltInfo_t` with memcpy. The body writes the four members at their offsets.
            let bolt = ghoul2[i].mBltlist[x]
            tempBuffer[int: 0] = bolt.boneNumber
            tempBuffer[int: 4] = bolt.surfaceNumber
            tempBuffer[int: 8] = bolt.surfaceType
            tempBuffer[int: 12] = bolt.boltUsed
            tempBuffer = tempBuffer.suffix(from: BOLT_SAVE_BLOCK_SIZE)
            x += 1
        }
        i += 1
    }

    return true
}

// have to free space malloced in the save system here because the game DLL can't.
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1812
func G2_FreeSaveBuffer(_ buffer: Slots<JKAShared.byte>) {
    Z_Free(OpaquePointer(buffer.base))
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1817
func G2_FindConfigStringSpace(_ name: String, _ start: Int32, _ max: Int32) -> Int32 {
    var s = CharBuf(MAX_STRING_CHARS)
    var i: Int32
    i = 1
    while i < max {
        SV_GetConfigstring(start + i, &s, Int32(s.count))
        if s[0] == 0 {
            break
        }
        if Q_stricmp(String(s), name) == 0 {
            return i
        }
        i += 1
    }

    SV_SetConfigstring(start + i, name)
    return i
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1841
// AI: Raven reads a `char *` to the zone block of G2_SaveGhoul2Models. The parameter is the Slots of bytes of that block.
func G2_LoadGhoul2Model(_ ghoul2: CGhoul2Info_v, _ buffer: Slots<JKAShared.byte>) {
    // G2API_LoadGhoul2Models is the one caller, and no file of the MP tree calls it, so the function is dead.
    var buffer = buffer
    // first thing, lets see how many ghoul2 models we have, and resize our buffers accordingly
    let newSize = buffer[int: 0]
    ghoul2.resize(newSize)
    buffer = buffer.suffix(from: 4)

    // did we actually resize to a value?
    if newSize == 0 {
        // no, ok, well, done then.
        return
    }

    // this one isn't a define since I couldn't work out how to figure it out at compile time
    // AI: Raven subtracts two member addresses. The constant holds the byte count of the band from mModelindex to mFlags in the 32-bit build.
    let ghoul2BlockSize = 116 as Int32

    // now we have enough instances, lets go through each one and load up the relevant details
    var i: Int32 = 0
    while i < ghoul2.size() {
        ghoul2[i].mSkelFrameNum = 0
        ghoul2[i].mModelindex = -1
        ghoul2[i].mFileName[0] = 0
        ghoul2[i].mValid = false
        // load the ghoul2 info from the buffer
        // AI: Raven copies the band of CGhoul2Info from mModelindex to mFlags with memcpy. The body reads each member at its offset in the 32-bit build.
        ghoul2[i].mModelindex = buffer[int: 0]
        ghoul2[i].mCustomShader = buffer[int: 4]
        ghoul2[i].mCustomSkin = buffer[int: 8]
        ghoul2[i].mModelBoltLink = buffer[int: 12]
        ghoul2[i].mSurfaceRoot = buffer[int: 16]
        ghoul2[i].mLodBias = buffer[int: 20]
        ghoul2[i].mNewOrigin = buffer[int: 24]
        ghoul2[i].mGoreSetTag = buffer[int: 28]
        ghoul2[i].mModel = buffer[int: 32]
        Com_Memcpy(&ghoul2[i].mFileName, buffer.suffix(from: 36), MAX_QPATH)
        ghoul2[i].mAnimFrameDefault = buffer[int: 100]
        ghoul2[i].mSkelFrameNum = buffer[int: 104]
        ghoul2[i].mMeshFrameNum = buffer[int: 108]
        ghoul2[i].mFlags = buffer[int: 112]
//		OutputDebugString(va("G2_LoadGhoul2Model(): ghoul2[%d].mModelindex = %d\n",i,ghoul2[i].mModelindex));
        buffer = buffer.suffix(from: ghoul2BlockSize)

        if ghoul2[i].mModelindex != -1 && ghoul2[i].mFileName[0] != 0 {
            ghoul2[i].mModelindex = i
            _ = G2_SetupModelPointers(ghoul2[i])
        }

        // give us enough surfaces to load up the data
        // Raven's `resize` constructs each new element and destroys each element past the count.
        while ghoul2[i].mSlist.count < buffer[int: 0] {
            ghoul2[i].mSlist.append(surfaceInfo_t())
        }
        while ghoul2[i].mSlist.count > buffer[int: 0] {
            ghoul2[i].mSlist.removeLast()
        }
        buffer = buffer.suffix(from: 4)

        // now load all the surfaces
        var x: Int32
        x = 0
        while x < ghoul2[i].mSlist.count {
            // AI: Raven copies each `surfaceInfo_t` whole with memcpy. The body reads each member at its offset in the 32-bit build.
            let surf = ghoul2[i].mSlist[x]
            surf.offFlags = buffer[int: 0]
            surf.surface = buffer[int: 4]
            surf.genBarycentricJ = buffer[float: 8]
            surf.genBarycentricI = buffer[float: 12]
            surf.genPolySurfaceIndex = buffer[int: 16]
            surf.genLod = buffer[int: 20]
            buffer = buffer.suffix(from: SURFACE_SAVE_BLOCK_SIZE)
            x += 1
        }

        // give us enough bones to load up the data
        while ghoul2[i].mBlist.count < buffer[int: 0] {
            ghoul2[i].mBlist.append(boneInfo_t())
        }
        while ghoul2[i].mBlist.count > buffer[int: 0] {
            ghoul2[i].mBlist.removeLast()
        }
        buffer = buffer.suffix(from: 4)

        // now load all the bones
        x = 0
        while x < ghoul2[i].mBlist.count {
            // AI: Raven copies each `boneInfo_t` whole with memcpy. The body reads each member at its offset in the 32-bit build.
            let bone = ghoul2[i].mBlist[x]
            bone.boneNumber = buffer[int: 0]
            Com_Memcpy(bone.matrix.matrix.bytes, buffer.suffix(from: 4), 48)
            bone.flags = buffer[int: 52]
            bone.startFrame = buffer[int: 56]
            bone.endFrame = buffer[int: 60]
            bone.startTime = buffer[int: 64]
            bone.pauseTime = buffer[int: 68]
            bone.animSpeed = buffer[float: 72]
            bone.blendFrame = buffer[float: 76]
            bone.blendLerpFrame = buffer[int: 80]
            bone.blendTime = buffer[int: 84]
            bone.blendStart = buffer[int: 88]
            bone.boneBlendTime = buffer[int: 92]
            bone.boneBlendStart = buffer[int: 96]
            bone.lastTime = buffer[int: 100]
            Com_Memcpy(bone.newMatrix.matrix.bytes, buffer.suffix(from: 104), 48)
            bone.lastTimeUpdated = buffer[int: 152]
            bone.lastContents = buffer[int: 156]
            bone.lastPosition[0] = buffer[float: 160]
            bone.lastPosition[1] = buffer[float: 164]
            bone.lastPosition[2] = buffer[float: 168]
            bone.velocityEffector[0] = buffer[float: 172]
            bone.velocityEffector[1] = buffer[float: 176]
            bone.velocityEffector[2] = buffer[float: 180]
            bone.lastAngles[0] = buffer[float: 184]
            bone.lastAngles[1] = buffer[float: 188]
            bone.lastAngles[2] = buffer[float: 192]
            bone.minAngles[0] = buffer[float: 196]
            bone.minAngles[1] = buffer[float: 200]
            bone.minAngles[2] = buffer[float: 204]
            bone.maxAngles[0] = buffer[float: 208]
            bone.maxAngles[1] = buffer[float: 212]
            bone.maxAngles[2] = buffer[float: 216]
            bone.currentAngles[0] = buffer[float: 220]
            bone.currentAngles[1] = buffer[float: 224]
            bone.currentAngles[2] = buffer[float: 228]
            bone.anglesOffset[0] = buffer[float: 232]
            bone.anglesOffset[1] = buffer[float: 236]
            bone.anglesOffset[2] = buffer[float: 240]
            bone.positionOffset[0] = buffer[float: 244]
            bone.positionOffset[1] = buffer[float: 248]
            bone.positionOffset[2] = buffer[float: 252]
            bone.radius = buffer[float: 256]
            bone.weight = buffer[float: 260]
            bone.ragIndex = buffer[int: 264]
            bone.velocityRoot[0] = buffer[float: 268]
            bone.velocityRoot[1] = buffer[float: 272]
            bone.velocityRoot[2] = buffer[float: 276]
            bone.ragStartTime = buffer[int: 280]
            bone.firstTime = buffer[int: 284]
            bone.firstCollisionTime = buffer[int: 288]
            bone.restTime = buffer[int: 292]
            bone.RagFlags = buffer[int: 296]
            bone.DependentRagIndexMask = buffer[int: 300]
            Com_Memcpy(bone.originalTrueBoneMatrix.matrix.bytes, buffer.suffix(from: 304), 48)
            Com_Memcpy(bone.parentTrueBoneMatrix.matrix.bytes, buffer.suffix(from: 352), 48)
            Com_Memcpy(bone.parentOriginalTrueBoneMatrix.matrix.bytes, buffer.suffix(from: 400), 48)
            bone.originalOrigin[0] = buffer[float: 448]
            bone.originalOrigin[1] = buffer[float: 452]
            bone.originalOrigin[2] = buffer[float: 456]
            bone.originalAngles[0] = buffer[float: 460]
            bone.originalAngles[1] = buffer[float: 464]
            bone.originalAngles[2] = buffer[float: 468]
            bone.lastShotDir[0] = buffer[float: 472]
            bone.lastShotDir[1] = buffer[float: 476]
            bone.lastShotDir[2] = buffer[float: 480]
            // AI: Raven restores the four basepose pointers from the block. The save wrote them as zero, so the four views are nil.
            bone.basepose = nil
            bone.baseposeInv = nil
            bone.baseposeParent = nil
            bone.baseposeInvParent = nil
            bone.parentRawBoneIndex = buffer[int: 500]
            Com_Memcpy(bone.ragOverrideMatrix.matrix.bytes, buffer.suffix(from: 504), 48)
            Com_Memcpy(bone.extraMatrix.matrix.bytes, buffer.suffix(from: 552), 48)
            bone.extraVec1[0] = buffer[float: 600]
            bone.extraVec1[1] = buffer[float: 604]
            bone.extraVec1[2] = buffer[float: 608]
            bone.extraFloat1 = buffer[float: 612]
            bone.extraInt1 = buffer[int: 616]
            bone.ikPosition[0] = buffer[float: 620]
            bone.ikPosition[1] = buffer[float: 624]
            bone.ikPosition[2] = buffer[float: 628]
            bone.ikSpeed = buffer[float: 632]
            bone.epVelocity[0] = buffer[float: 636]
            bone.epVelocity[1] = buffer[float: 640]
            bone.epVelocity[2] = buffer[float: 644]
            bone.epGravFactor = buffer[float: 648]
            bone.solidCount = buffer[int: 652]
            bone.physicsSettled = (buffer[byte: 656] as Int32) != 0
            bone.snapped = (buffer[byte: 657] as Int32) != 0
            bone.parentBoneIndex = buffer[int: 660]
            bone.offsetRotation = buffer[float: 664]
            bone.overGradSpeed = buffer[float: 668]
            bone.overGoalSpot[0] = buffer[float: 672]
            bone.overGoalSpot[1] = buffer[float: 676]
            bone.overGoalSpot[2] = buffer[float: 680]
            bone.hasOverGoal = (buffer[byte: 684] as Int32) != 0
            Com_Memcpy(bone.animFrameMatrix.matrix.bytes, buffer.suffix(from: 688), 48)
            bone.hasAnimFrameMatrix = buffer[int: 736]
            bone.airTime = buffer[int: 740]
            buffer = buffer.suffix(from: BONE_SAVE_BLOCK_SIZE)
            x += 1
        }

        // give us enough bolts to load up the data
        while ghoul2[i].mBltlist.count < buffer[int: 0] {
            ghoul2[i].mBltlist.append(boltInfo_t())
        }
        while ghoul2[i].mBltlist.count > buffer[int: 0] {
            ghoul2[i].mBltlist.removeLast()
        }
        buffer = buffer.suffix(from: 4)

        // now load all the bolts
        x = 0
        while x < ghoul2[i].mBltlist.count {
            // AI: Raven copies the first 16 bytes of each `boltInfo_t` with memcpy. The body reads the four members at their offsets.
            let bolt = ghoul2[i].mBltlist[x]
            bolt.boneNumber = buffer[int: 0]
            bolt.surfaceNumber = buffer[int: 4]
            bolt.surfaceType = buffer[int: 8]
            bolt.boltUsed = buffer[int: 12]
            buffer = buffer.suffix(from: BOLT_SAVE_BLOCK_SIZE)
            x += 1
        }
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_misc.cpp:1912
func G2_LerpAngles(_ ghoul2: CGhoul2Info_v, _ nextGhoul2: CGhoul2Info_v, _ interpolation: Float) {
    // Raven calls this function from no file of either tree, so it is dead.
    // loop each model
    var i: Int32 = 0
    while i < ghoul2.size() {
        if ghoul2[i].mModelindex != -1 {
            // now walk the bone list
            var x: Int32 = 0
            while x < ghoul2[i].mBlist.count {
                let bone = ghoul2[i].mBlist[x]
                // sure we have one to lerp to?
                if (nextGhoul2.size() > i) &&
                    (nextGhoul2[i].mModelindex != -1) &&
                    (nextGhoul2[i].mBlist.count > x) &&
                    (nextGhoul2[i].mBlist[x].boneNumber != -1)
                {
                    let nextBone = nextGhoul2[i].mBlist[x]
                    // does this bone override actually have anything in it, and if it does, is it a bone angles override?
                    if (bone.boneNumber != -1) && ((bone.flags) & (BONE_ANGLES_TOTAL)) != 0 {
                        let nowMatrix = bone.matrix.matrix
                        let nextMatrix = nextBone.matrix.matrix
                        let newMatrix = bone.newMatrix.matrix
                        // now interpolate the matrix
                        var z: Int32 = 0
                        while z < 12 {
                            newMatrix[z / 4][z % 4] = nowMatrix[z / 4][z % 4] + interpolation * (nextMatrix[z / 4][z % 4] - nowMatrix[z / 4][z % 4])
                            z += 1
                        }
                    }
                } else {
                    ghoul2[i].mBlist[x].newMatrix.copy(from: ghoul2[i].mBlist[x].matrix)
                }
                x += 1
            }
        }
        i += 1
    }
}
