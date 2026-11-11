import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/ghoul2/G2_API.cpp:34
var g_Ghoul2Allocations: Int32 {
    get { world.variables.g_Ghoul2Allocations }
    set { world.variables.g_Ghoul2Allocations = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:35
var g_G2ServerAlloc: Int32 {
    get { world.variables.g_G2ServerAlloc }
    set { world.variables.g_G2ServerAlloc = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:36
var g_G2ClientAlloc: Int32 {
    get { world.variables.g_G2ClientAlloc }
    set { world.variables.g_G2ClientAlloc = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:37
var g_G2AllocServer: Int32 {
    get { world.variables.g_G2AllocServer }
    set { world.variables.g_G2AllocServer = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:616
// AI: Raven hands the module the address of each `CGhoul2Info_v`. The world holds the instances in a table, and the module's word is the slot number plus 1, row Z6 of docket 10.
var ghoul2Instances: [CGhoul2Info_v?] {
    get { world.ghoul2Instances }
    set { world.ghoul2Instances = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:42
let MAX_TRACKED_ALLOC = 4096 as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:43
var g_G2AllocTrackInit: Bool {
    get { world.variables.g_G2AllocTrackInit }
    set { world.variables.g_G2AllocTrackInit = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:44
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var g_G2AllocTrack: [CGhoul2Info_v?] {
    get { world.g_G2AllocTrack }
    set { world.g_G2AllocTrack = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:159
private let NUM_G2T_TIME = (2) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:160
var G2TimeBases: [Int32] {
    get { world.variables.G2TimeBases }
    set { world.variables.G2TimeBases = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:304
let MAX_G2_MODELS = (1024) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:305
let G2_MODEL_BITS = (10) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:308
let G2_INDEX_MASK = (MAX_G2_MODELS - 1)

/// Source: oracle/codemp/ghoul2/G2_API.cpp:477
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var singleton: Ghoul2InfoArray? {
    get { world.singleton }
    set { world.singleton = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:992
private let GHOUL2_RAG_STARTED = 0x0010 as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:993
private let GHOUL2_RAG_FORCESOLVE = 0x1000 as Int32

/// Source: oracle/codemp/ghoul2/G2_local.h:12
// AI: Raven defines the flag in G2_local.h, which no module of the host declares. The file that sets it holds the value as a `let`.
let GHOUL2_CRAZY_SMOOTH = 0x2000 as Int32		//hack for smoothing during ugly situations. forgive me.

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1469
private let RAG_PCJ = (0x00001) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1470
private let RAG_EFFECTOR = (0x00100) as Int32

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1724
var gG2_GBMNoReconstruct: Bool {
    get { world.variables.gG2_GBMNoReconstruct }
    set { world.variables.gG2_GBMNoReconstruct = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1725
var gG2_GBMUseSPMethod: Bool {
    get { world.variables.gG2_GBMUseSPMethod }
    set { world.variables.gG2_GBMUseSPMethod = newValue }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:46
func G2_DEBUG_InitPtrTracker() {
    g_G2AllocTrack.fill(nil)
    g_G2AllocTrackInit = true
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:52
func G2_DEBUG_ReportLeaks() {
    var i: Int32 = 0

    if !g_G2AllocTrackInit {
        Com_Printf("g2 leak tracker was never initialized!\n")
        return
    }

    while i < MAX_TRACKED_ALLOC {
        if g_G2AllocTrack[i] != nil {
            Com_Printf("Bad guy found in slot %i, attempting to access...", i)
            let g2v = g_G2AllocTrack[i]!

            // Port-note: Raven takes `g2v[0]` before the IsValid test, and an invalid handle gives an empty list, whose element 0 C leaves undefined.
            // The body reads element 0 only after the IsValid test, and drops Raven's test of the `mFileName` address, which is never NULL.
            if g2v.IsValid() && g2v[0].mFileName[0] != 0 {
                Com_Printf("Bad guy's filename is %s\n", String(g2v[0].mFileName))
            } else {
                Com_Printf("He's not valid! BURN HIM!\n")
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:83
func G2_DEBUG_ShovePtrInTracker(_ g2: CGhoul2Info_v?) {
    var i: Int32 = 0

    if !g_G2AllocTrackInit {
        G2_DEBUG_InitPtrTracker()
    }

    if !g_G2AllocTrackInit {
        G2_DEBUG_InitPtrTracker()
    }

    while i < MAX_TRACKED_ALLOC {
        if g_G2AllocTrack[i] == nil {
            g_G2AllocTrack[i] = g2
            return
        }
        i += 1
    }

    let g2v = g2!

    // Raven tests `currentModel->name`, the address of the array, which is never NULL.
    // Raven tests `currentModel->name[0]`, the first byte of the name.
    // Port-note: Raven reads `g2v[0]` of an empty list here, whose element 0 C leaves undefined.
    // The body reads element 0 only when the list holds a model, and an empty list takes the second arm.
    if g2v.size() > 0 && g2v[0].currentModel != nil && !g2v[0].currentModel!.name.isEmpty {
        Com_Printf("%s could not be fit into g2 debug instance tracker.\n", g2v[0].currentModel!.name)
    } else {
        Com_Printf("Crap g2 instance passed to instance tracker (in).\n")
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:119
func G2_DEBUG_RemovePtrFromTracker(_ g2: CGhoul2Info_v?) {
    var i: Int32 = 0

    if !g_G2AllocTrackInit {
        G2_DEBUG_InitPtrTracker()
    }

    while i < MAX_TRACKED_ALLOC {
        if g_G2AllocTrack[i] === g2 {
            g_G2AllocTrack[i] = nil
            return
        }
        i += 1
    }

    let g2v = g2!

    // Raven tests `currentModel->name`, the address of the array, which is never NULL.
    // Raven tests `currentModel->name[0]`, the first byte of the name.
    // Port-note: Raven reads `g2v[0]` of an empty list here, whose element 0 C leaves undefined.
    // The body reads element 0 only when the list holds a model, and an empty list takes the second arm.
    if g2v.size() > 0 && g2v[0].currentModel != nil && !g2v[0].currentModel!.name.isEmpty {
        Com_Printf("%s not in g2 debug instance tracker.\n", g2v[0].currentModel!.name)
    } else {
        Com_Printf("Crap g2 instance passed to instance tracker (out).\n")
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:162
func G2API_SetTime(_ currentTime: Int32, _ clock: Int32) {
    G2TimeBases[clock] = currentTime
    if G2TimeBases[1] > G2TimeBases[0] + 200 {
        G2TimeBases[1] = 0 // use server time instead
        return
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:179
func G2API_GetTime(_ argTime: Int32) -> Int32 {
    var ret = G2TimeBases[1]
    if ret == 0 {
        ret = G2TimeBases[0]
    }

    return ret
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:200
func G2API_AttachInstanceToEntNum(_ ghoul2: CGhoul2Info_v, _ entityNum: Int32, _ server: Bool) {
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:214
func G2API_ClearAttachedInstance(_ entityNum: Int32) {
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:221
func G2API_CleanEntAttachments() {
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:239
func G2API_OverrideServerWithClientData(_ serverInstance: CGhoul2Info?) -> Bool {
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:478
func TheGhoul2InfoArray() -> Ghoul2InfoArray {
    if singleton == nil {
        singleton = Ghoul2InfoArray()
    }
    return singleton!
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:487
func Ghoul2InfoArray_Free() {
    if singleton != nil {
        singleton = nil
    }
}

// this is the ONLY function to read entity states directly
/// Source: oracle/codemp/ghoul2/G2_API.cpp:496
func G2API_CleanGhoul2Models(_ ghoul2Ptr: inout CGhoul2Info_v?) {
    if ghoul2Ptr != nil {
        let ghoul2 = ghoul2Ptr!

        G2API_ClearSkinGore(ghoul2)

        // AI: Raven calls the destructor by hand. The body calls clear, whose body is the destructor's one call to Free.
        ghoul2.clear()

        // Raven's `sizeof(*ghoul2Ptr)` is the size of a pointer, the size of `UInt` on every Swift target.
        if g_G2AllocServer != 0 {
            g_G2ServerAlloc -= Int32(UInt.byteCount)
        } else {
            g_G2ClientAlloc -= Int32(UInt.byteCount)
        }
        g_Ghoul2Allocations -= Int32(UInt.byteCount)
        G2_DEBUG_RemovePtrFromTracker(ghoul2Ptr)

        // AI: Raven deletes the instance. The table drops its reference, so the deinit frees the item, row Z6 of docket 10.
        ghoul2Instances.freeSlot(ghoul2Ptr!)
        ghoul2Ptr = nil
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:570
func G2_ShouldRegisterServer() -> Bool {
    if currentVM != nil && currentVM == gvm {
        if com_cl_running != nil && com_cl_running!.integer != 0 &&
            Com_TheHunkMarkHasBeenMade() && ShaderHashTableExists() { //if the hunk has been marked then we are now loading client assets so don't load on server.
            return false
        }

        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:585
func G2API_PrecacheGhoul2Model(_ fileName: String) -> JKAShared.qhandle_t {
    if G2_ShouldRegisterServer() {
        return RE_RegisterServerModel(fileName)
    } else {
        return RE_RegisterModel(fileName)
    }
}

// initialise all that needs to be on a new Ghoul II model
/// Source: oracle/codemp/ghoul2/G2_API.cpp:601
func G2API_InitGhoul2Model(_ ghoul2Ptr: inout CGhoul2Info_v?, _ fileName: String, _ modelIndex: Int32, _ customSkin: JKAShared.qhandle_t, _ customShader: JKAShared.qhandle_t, _ modelFlags: Int32 = 0, _ lodBias: Int32 = 0) -> Int32 {
    var model: Int32

    // are we actually asking for a model to be loaded.
    if fileName.isEmpty {
        assert(false)
        return -1
    }

    if ghoul2Ptr == nil {
        ghoul2Ptr = CGhoul2Info_v()
        // AI: Raven hands the module the address of the new instance. The instance takes a free slot of the table, row Z6 of docket 10.
        ghoul2Instances.takeSlot(ghoul2Ptr!)
        // Raven's `sizeof(CGhoul2Info_v)` is the size of its one `int` field.
        if g_G2AllocServer != 0 {
            g_G2ServerAlloc += Int32(Int32.byteCount)
        } else {
            g_G2ClientAlloc += Int32(Int32.byteCount)
        }
        g_Ghoul2Allocations += Int32(Int32.byteCount)
        G2_DEBUG_ShovePtrInTracker(ghoul2Ptr)
    }

    let ghoul2 = ghoul2Ptr!

    // find a free spot in the list
    model = 0
    while model < ghoul2.size() {
        if ghoul2[model].mModelindex == -1 {
            // AI: Raven copies a new model into the slot. The slot holds the new instance itself, because the right side is a new temporary.
            ghoul2[model] = CGhoul2Info()
            break
        }
        model += 1
    }
    if model == ghoul2.size() {	//init should not be used to create additional models, only the first one
        assert(ghoul2.size() < 4) //use G2API_CopySpecificG2Model to add models
        ghoul2.push_back(CGhoul2Info())
    }

    strcpy(&ghoul2[model].mFileName, fileName)
    ghoul2[model].mModelindex = model
    if !G2_TestModelPointers(ghoul2[model]) {
        ghoul2[model].mFileName[0] = 0
        ghoul2[model].mModelindex = -1
    } else {
        G2_Init_Bone_List(&ghoul2[model].mBlist)
        G2_Init_Bolt_List(&ghoul2[model].mBltlist)
        ghoul2[model].mCustomShader = customShader
        ghoul2[model].mCustomSkin = customSkin
        ghoul2[model].mLodBias = lodBias
        ghoul2[model].mAnimFrameDefault = 0
        ghoul2[model].mFlags = 0

        ghoul2[model].mModelBoltLink = -1
    }
    return ghoul2[model].mModelindex
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:670
func G2API_SetLodBias(_ ghlInfo: CGhoul2Info?, _ lodBias: Int32) -> Bool {
    if ghlInfo != nil {
        ghlInfo!.mLodBias = lodBias
        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:681
func G2API_SetSkin(_ ghlInfo: CGhoul2Info?, _ customSkin: JKAShared.qhandle_t, _ renderSkin: JKAShared.qhandle_t) -> Bool {
    if ghlInfo != nil {
        ghlInfo!.mCustomSkin = customSkin
        if renderSkin != 0 { //this is going to set the surfs on/off matching the skin file
            G2_SetSurfaceOnOffFromSkin(ghlInfo, renderSkin)
        }

        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:696
func G2API_SetShader(_ ghlInfo: CGhoul2Info?, _ customShader: JKAShared.qhandle_t) -> Bool {
    if ghlInfo != nil {
        ghlInfo!.mCustomShader = customShader
        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:706
func G2API_SetSurfaceOnOff(_ ghoul2: CGhoul2Info_v, _ surfaceName: String, _ flags: Int32) -> Bool {
    var ghlInfo: CGhoul2Info? = nil

    if ghoul2.size() > 0 {
        ghlInfo = ghoul2[0]
    }

    if G2_SetupModelPointers(ghlInfo) {
        // ensure we flush the cache
        ghlInfo!.mMeshFrameNum = 0
        return G2_SetSurfaceOnOff(ghlInfo, &ghlInfo!.mSlist, surfaceName, flags)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:724
func G2API_GetSurfaceOnOff(_ ghlInfo: CGhoul2Info?, _ surfaceName: String) -> Int32 {
    if ghlInfo != nil {
        return G2_IsSurfaceOff(ghlInfo, &ghlInfo!.mSlist, surfaceName)
    }
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:733
func G2API_SetRootSurface(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ surfaceName: String) -> Bool {
    if G2_SetupModelPointers(ghoul2) {
        return G2_SetRootSurface(ghoul2, modelIndex, surfaceName)
    }

    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:743
func G2API_AddSurface(_ ghlInfo: CGhoul2Info?, _ surfaceNumber: Int32, _ polyNumber: Int32, _ BarycentricI: Float, _ BarycentricJ: Float, _ lod: Int32) -> Int32 {
    if G2_SetupModelPointers(ghlInfo) {
        // ensure we flush the cache
        ghlInfo!.mMeshFrameNum = 0
        return G2_AddSurface(ghlInfo, surfaceNumber, polyNumber, BarycentricI, BarycentricJ, lod)
    }
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:754
func G2API_RemoveSurface(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        // ensure we flush the cache
        ghlInfo!.mMeshFrameNum = 0
        return G2_RemoveSurface(&ghlInfo!.mSlist, index)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:765
func G2API_GetParentSurface(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Int32 {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_GetParentSurface(ghlInfo, index)
    }
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:774
func G2API_GetSurfaceRenderStatus(_ ghlInfo: CGhoul2Info?, _ surfaceName: String) -> Int32 {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_IsSurfaceRendered(ghlInfo, surfaceName, &ghlInfo!.mSlist)
    }
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:783
func G2API_HasGhoul2ModelOnIndex(_ ghlRemove: inout CGhoul2Info_v?, _ modelIndex: Int32) -> Bool {
    let ghlInfo = ghlRemove!

    if ghlInfo.size() == 0 || (ghlInfo.size() <= modelIndex) || (ghlInfo[modelIndex].mModelindex == -1) {
        return false
    }

    return true
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:795
func G2API_RemoveGhoul2Model(_ ghlRemove: inout CGhoul2Info_v?, _ modelIndex: Int32) -> Bool {
    let ghlInfo = ghlRemove!

    // sanity check
    if ghlInfo.size() == 0 || (ghlInfo.size() <= modelIndex) || (ghlInfo[modelIndex].mModelindex == -1) {
        // if we hit this assert then we are trying to delete a ghoul2 model on a ghoul2 instance that
        // one way or another is already gone.
        return false
    }

    if ghlInfo.size() > modelIndex {
        // Cleanup the gore attached to this model
        if ghlInfo[modelIndex].mGoreSetTag != 0 {
            DeleteGoreSet(ghlInfo[modelIndex].mGoreSetTag)
            ghlInfo[modelIndex].mGoreSetTag = 0
        }

        if ghlInfo[modelIndex].mBoneCache != nil {
            RemoveBoneCache(ghlInfo[modelIndex].mBoneCache)
            ghlInfo[modelIndex].mBoneCache = nil
        }

        // clear out the vectors this model used.
        ghlInfo[modelIndex].mBlist.removeAll()
        ghlInfo[modelIndex].mBltlist.removeAll()
        ghlInfo[modelIndex].mSlist.removeAll()

        // set us to be the 'not active' state
        ghlInfo[modelIndex].mModelindex = -1

        var newSize = ghlInfo.size()
        // now look through the list from the back and see if there is a block of -1's we can resize off the end of the list
        var i = ghlInfo.size() - 1
        while i > -1 {
            if ghlInfo[i].mModelindex == -1 {
                newSize = i
            }
            // once we hit one that isn't a -1, we are done.
            else {
                break
            }
            i -= 1
        }
        // do we need to resize?
        if newSize != ghlInfo.size() {
            // yes, so lets do it
            ghlInfo.resize(newSize)
        }

        // if we are not using any space, just delete the ghoul2 vector entirely
        if ghlInfo.size() == 0 {
            // Raven's `sizeof(*ghlRemove)` is the size of a pointer, the size of `UInt` on every Swift target.
            if g_G2AllocServer != 0 {
                g_G2ServerAlloc -= Int32(UInt.byteCount)
            } else {
                g_G2ClientAlloc -= Int32(UInt.byteCount)
            }
            g_Ghoul2Allocations -= Int32(UInt.byteCount)
            // AI: Raven deletes the instance, and its destructor calls Free. The body calls clear, whose body is the same call, then drops the reference.
            ghlRemove!.clear()
            // AI: The table drops its reference to the deleted instance, row Z6 of docket 10.
            ghoul2Instances.freeSlot(ghlRemove!)
            ghlRemove = nil
        }
    }


    return true
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:877
func G2API_RemoveGhoul2Models(_ ghlRemove: inout CGhoul2Info_v?) -> Bool {
    let ghlInfo = ghlRemove!
    var modelIndex: Int32 = 0
    var newSize: Int32 = 0
    var i: Int32

    // sanity check
    if ghlInfo.size() == 0 { // if we hit this then we are trying to delete a ghoul2 model on a ghoul2 instance that
        // one way or another is already gone.
        return false
    }

    modelIndex = 0
    while modelIndex < ghlInfo.size() {
        if ghlInfo[modelIndex].mModelindex == -1 {
            modelIndex += 1
            continue
        }
        // Cleanup the gore attached to this model
        if ghlInfo[modelIndex].mGoreSetTag != 0 {
            DeleteGoreSet(ghlInfo[modelIndex].mGoreSetTag)
            ghlInfo[modelIndex].mGoreSetTag = 0
        }

        if ghlInfo[modelIndex].mBoneCache != nil {
            RemoveBoneCache(ghlInfo[modelIndex].mBoneCache)
            ghlInfo[modelIndex].mBoneCache = nil
        }

        // clear out the vectors this model used.
        ghlInfo[modelIndex].mBlist.removeAll()
        ghlInfo[modelIndex].mBltlist.removeAll()
        ghlInfo[modelIndex].mSlist.removeAll()

        // set us to be the 'not active' state
        ghlInfo[modelIndex].mModelindex = -1
        modelIndex += 1
    }

    newSize = ghlInfo.size()
    // now look through the list from the back and see if there is a block of -1's we can resize off the end of the list
    i = ghlInfo.size() - 1
    while i > -1 {
        if ghlInfo[i].mModelindex == -1 {
            newSize = i
        }
        // once we hit one that isn't a -1, we are done.
        else {
            break
        }
        i -= 1
    }
    // do we need to resize?
    if newSize != ghlInfo.size() {
        // yes, so lets do it
        ghlInfo.resize(newSize)
    }

    // if we are not using any space, just delete the ghoul2 vector entirely
    if ghlInfo.size() == 0 {
        // Raven's `sizeof(*ghlRemove)` is the size of a pointer, the size of `UInt` on every Swift target.
        if g_G2AllocServer != 0 {
            g_G2ServerAlloc -= Int32(UInt.byteCount)
        } else {
            g_G2ClientAlloc -= Int32(UInt.byteCount)
        }
        g_Ghoul2Allocations -= Int32(UInt.byteCount)
        // AI: Raven deletes the instance, and its destructor calls Free. The body calls clear, whose body is the same call, then drops the reference.
        ghlRemove!.clear()
        // AI: The table drops its reference to the deleted instance, row Z6 of docket 10.
        ghoul2Instances.freeSlot(ghlRemove!)
        ghlRemove = nil
    }
    return true
}

//check if a bone exists on skeleton without actually adding to the bone list -rww
/// Source: oracle/codemp/ghoul2/G2_API.cpp:963
func G2API_DoesBoneExist(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    if G2_SetupModelPointers(ghlInfo) { //model is valid
        let mdxa = ghlInfo!.currentModel!.mdxa
        if mdxa != nil { //get the skeleton data and iterate through the bones
            var i: Int32
            var skel: MdxaSkel
            let offsets: MdxaSkelOffsets

            offsets = MdxaSkelOffsets(mdxa!, byteOffset: MdxaHeader.byteCount)

            i = 0
            while i < mdxa!.numBones {
                skel = MdxaSkel(mdxa!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[i])
                if Q_stricmp(skel.name, boneName) == 0 { //got it
                    return true
                }
                i += 1
            }
        }
    }

    //guess it doesn't exist
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:996
func G2API_SetBoneAnimIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32, _ AstartFrame: Int32, _ AendFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ AsetFrame: Float, _ blendTime: Int32) -> Bool {
    var setPtrs = false
    var res = false

    //rww - RAGDOLL_BEGIN
    if ghlInfo != nil {
        res = G2_SetupModelPointers(ghlInfo)
        setPtrs = true

        if res {
            if (ghlInfo!.mFlags & GHOUL2_RAG_STARTED) != 0 {
                return false
            }
        }
    }
    //rww - RAGDOLL_END

    var endFrame = AendFrame
    var startFrame = AstartFrame
    var setFrame = AsetFrame
    if endFrame <= 0 {
        endFrame = 1
    }
    if endFrame >= 100000 {
        endFrame = 1
    }
    if startFrame < 0 {
        startFrame = 0
    }
    if startFrame >= 100000 {
        startFrame = 0
    }
    if setFrame < 0.0 && setFrame != -1.0 {
        setFrame = 0.0
    }
    if setFrame > 100000.0 {
        setFrame = 0.0
    }
    if !setPtrs {
        res = G2_SetupModelPointers(ghlInfo)
    }

    if res {
        // ensure we flush the cache
        ghlInfo!.mSkelFrameNum = 0
        return G2_Set_Bone_Anim_Index(&ghlInfo!.mBlist, index, startFrame, endFrame, flags, animSpeed, currentTime, setFrame, blendTime, ghlInfo!.aHeader!.numFrames)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1066
func G2API_SetBoneAnim(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boneName: String, _ AstartFrame: Int32, _ AendFrame: Int32, _ flags: Int32, _ animSpeed: Float, _ currentTime: Int32, _ AsetFrame: Float, _ blendTime: Int32 = -1) -> Bool {
    var endFrame = AendFrame
    var startFrame = AstartFrame
    var setFrame = AsetFrame
    if endFrame <= 0 {
        endFrame = 1
    }
    if endFrame >= 100000 {
        endFrame = 1
    }
    if startFrame < 0 {
        startFrame = 0
    }
    if startFrame >= 100000 {
        startFrame = 0
    }
    if setFrame < 0.0 && setFrame != -1.0 {
        setFrame = 0.0
    }
    if setFrame > 100000.0 {
        setFrame = 0.0
    }
    if ghoul2.size() > modelIndex {
        let ghlInfo = ghoul2[modelIndex]
        var res = false

        //rww - RAGDOLL_BEGIN
        res = G2_SetupModelPointers(ghlInfo)

        if res {
            if (ghlInfo.mFlags & GHOUL2_RAG_STARTED) != 0 {
                return false
            }
        }
        //rww - RAGDOLL_END

        if res {
            // ensure we flush the cache
            ghlInfo.mSkelFrameNum = 0
            return G2_Set_Bone_Anim(ghlInfo, &ghlInfo.mBlist, boneName, startFrame, endFrame, flags, animSpeed, currentTime, setFrame, blendTime)
        }
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1140
func G2API_GetBoneAnim(_ ghlInfo: CGhoul2Info?, _ boneName: String, _ currentTime: Int32, _ currentFrame: inout Float, _ startFrame: inout Int32, _ endFrame: inout Int32, _ flags: inout Int32, _ animSpeed: inout Float, _ modelList: Slots<qhandle_t>?) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        let aCurrentTime = G2API_GetTime(currentTime)
        let ret = G2_Get_Bone_Anim(ghlInfo, &ghlInfo!.mBlist, boneName, aCurrentTime, &currentFrame,
            &startFrame, &endFrame, &flags, &animSpeed, modelList, ghlInfo!.mModelindex)
        return ret
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1191
func G2API_GetAnimRange(_ ghlInfo: CGhoul2Info?, _ boneName: String, _ startFrame: inout Int32, _ endFrame: inout Int32) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        let ret = G2_Get_Bone_Anim_Range(ghlInfo, &ghlInfo!.mBlist, boneName, &startFrame, &endFrame)
        return ret
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1225
func G2API_PauseBoneAnim(_ ghlInfo: CGhoul2Info?, _ boneName: String, _ currentTime: Int32) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_Pause_Bone_Anim(ghlInfo, &ghlInfo!.mBlist, boneName, currentTime)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1234
func G2API_IsPaused(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_IsPaused(String(ghlInfo!.mFileName), &ghlInfo!.mBlist, boneName)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1243
func G2API_StopBoneAnimIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_Stop_Bone_Anim_Index(&ghlInfo!.mBlist, index)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1252
func G2API_StopBoneAnim(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_Stop_Bone_Anim(String(ghlInfo!.mFileName), &ghlInfo!.mBlist, boneName)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1261
func G2API_SetBoneAnglesIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32, _ angles: JKAShared.vec3_t, _ flags: Int32, _ yaw: JKAMP.Eorientations, _ pitch: JKAMP.Eorientations, _ roll: JKAMP.Eorientations, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    var setPtrs = false
    var res = false

    //rww - RAGDOLL_BEGIN
    if ghlInfo != nil {
        res = G2_SetupModelPointers(ghlInfo)
        setPtrs = true

        if res {
            if (ghlInfo!.mFlags & GHOUL2_RAG_STARTED) != 0 {
                return false
            }
        }
    }
    //rww - RAGDOLL_END

    if !setPtrs {
        res = G2_SetupModelPointers(ghlInfo)
    }

    if res {
        // ensure we flush the cache
        ghlInfo!.mSkelFrameNum = 0
        return G2_Set_Bone_Angles_Index(&ghlInfo!.mBlist, index, angles, flags, yaw, pitch, roll, modelList, ghlInfo!.mModelindex, blendTime, currentTime)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1298
func G2API_SetBoneAngles(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boneName: String, _ angles: JKAShared.vec3_t, _ flags: Int32, _ up: JKAMP.Eorientations, _ left: JKAMP.Eorientations, _ forward: JKAMP.Eorientations, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    if ghoul2.size() > modelIndex {
        let ghlInfo = ghoul2[modelIndex]
        var res = false

        //rww - RAGDOLL_BEGIN
        res = G2_SetupModelPointers(ghlInfo)

        if res {
            if (ghlInfo.mFlags & GHOUL2_RAG_STARTED) != 0 {
                return false
            }
        }
        //rww - RAGDOLL_END

        if res {
            // ensure we flush the cache
            ghlInfo.mSkelFrameNum = 0
            return G2_Set_Bone_Angles(ghlInfo, &ghlInfo.mBlist, boneName, angles, flags, up, left, forward, modelList, ghlInfo.mModelindex, blendTime, currentTime)
        }
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1339
func G2API_SetBoneAnglesMatrixIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32, _ matrix: JKAMP.MdxaBone, _ flags: Int32, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32, _ currentTime: Int32) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        // ensure we flush the cache
        ghlInfo!.mSkelFrameNum = 0
        return G2_Set_Bone_Angles_Matrix_Index(&ghlInfo!.mBlist, index, matrix, flags, modelList, ghlInfo!.mModelindex, blendTime, currentTime)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1351
func G2API_SetBoneAnglesMatrix(_ ghlInfo: CGhoul2Info?, _ boneName: String, _ matrix: JKAMP.MdxaBone, _ flags: Int32, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32 = 0, _ currentTime: Int32 = 0) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        // ensure we flush the cache
        ghlInfo!.mSkelFrameNum = 0
        return G2_Set_Bone_Angles_Matrix(String(ghlInfo!.mFileName), &ghlInfo!.mBlist, boneName, matrix, flags, modelList, ghlInfo!.mModelindex, blendTime, currentTime)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1363
func G2API_StopBoneAnglesIndex(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        // ensure we flush the cache
        ghlInfo!.mSkelFrameNum = 0
        return G2_Stop_Bone_Angles_Index(&ghlInfo!.mBlist, index)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1374
func G2API_StopBoneAngles(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        // ensure we flush the cache
        ghlInfo!.mSkelFrameNum = 0
        return G2_Stop_Bone_Angles(String(ghlInfo!.mFileName), &ghlInfo!.mBlist, boneName)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1386
func G2API_AbsurdSmoothing(_ ghoul2: CGhoul2Info_v, _ status: Bool) {
    assert(ghoul2.size() != 0)
    let ghlInfo = ghoul2[0]

    if status { //turn it on
        ghlInfo.mFlags |= GHOUL2_CRAZY_SMOOTH
    } else { //off
        ghlInfo.mFlags &= ~GHOUL2_CRAZY_SMOOTH
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1404
func G2API_SetRagDoll(_ ghoul2: CGhoul2Info_v, _ parms: CRagDollParams?) {
    G2_SetRagDoll(ghoul2, parms)
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1410
func G2API_ResetRagDoll(_ ghoul2: CGhoul2Info_v) {
    G2_ResetRagDoll(ghoul2)
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1416
func G2API_RemoveBone(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        // ensure we flush the cache
        ghlInfo!.mSkelFrameNum = 0
        return G2_Remove_Bone(ghlInfo, &ghlInfo!.mBlist, boneName)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1434
func G2API_AnimateG2Models(_ ghoul2: CGhoul2Info_v, _ AcurrentTime: Int32, _ params: CRagDollUpdateParams?) {
    var model: Int32 = 0
    let currentTime = G2API_GetTime(AcurrentTime)

    // Walk the list and find all models that are active
    while model < ghoul2.size() {
        if ghoul2[model].mModel != 0 {
            G2_Animate_Bone_List(ghoul2, currentTime, model, params)
        }
        model += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1472
private func G2_GetRagBoneConveniently(_ ghoul2: CGhoul2Info_v, _ boneName: String) -> boneInfo_t? {
    let ghlInfo = ghoul2[0]

    if (ghlInfo.mFlags & GHOUL2_RAG_STARTED) == 0 { //can't do this if not in ragdoll
        return nil
    }

    let boneIndex = G2_Find_Bone_Rag(ghlInfo, &ghlInfo.mBlist, boneName)

    if boneIndex < 0 { //bad bone specification
        return nil
    }

    let bone = ghlInfo.mBlist[boneIndex]

    if (bone.flags & BONE_ANGLES_RAGDOLL) == 0 { //only want to return rag bones
        return nil
    }

    return bone
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1499
func G2API_RagPCJConstraint(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ min: JKAShared.vec3_t, _ max: JKAShared.vec3_t) -> Bool {
    let bone = G2_GetRagBoneConveniently(ghoul2, boneName)

    if bone == nil {
        return false
    }

    if (bone!.RagFlags & RAG_PCJ) == 0 { //this function is only for PCJ bones
        return false
    }

    _VectorCopy(min, &bone!.minAngles)
    _VectorCopy(max, &bone!.maxAngles)

    return true
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1519
func G2API_RagPCJGradientSpeed(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ speed: Float) -> Bool {
    let bone = G2_GetRagBoneConveniently(ghoul2, boneName)

    if bone == nil {
        return false
    }

    if (bone!.RagFlags & RAG_PCJ) == 0 { //this function is only for PCJ bones
        return false
    }

    bone!.overGradSpeed = speed

    return true
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1538
func G2API_RagEffectorGoal(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ pos: JKAShared.vec3_t?) -> Bool {
    let bone = G2_GetRagBoneConveniently(ghoul2, boneName)

    if bone == nil {
        return false
    }

    if (bone!.RagFlags & RAG_EFFECTOR) == 0 { //this function is only for effectors
        return false
    }

    if pos == nil { //go back to none in case we have one then
        bone!.hasOverGoal = false
    } else {
        _VectorCopy(pos!, &bone!.overGoalSpot)
        bone!.hasOverGoal = true
    }
    return true
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1564
func G2API_GetRagBonePos(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ pos: JKAShared.vec3_t, _ entAngles: JKAShared.vec3_t, _ entPos: JKAShared.vec3_t, _ entScale: JKAShared.vec3_t) -> Bool {
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1569
func G2API_RagEffectorKick(_ ghoul2: CGhoul2Info_v, _ boneName: String, _ velocity: JKAShared.vec3_t) -> Bool {
    let bone = G2_GetRagBoneConveniently(ghoul2, boneName)

    if bone == nil {
        return false
    }

    if (bone!.RagFlags & RAG_EFFECTOR) == 0 { //this function is only for effectors
        return false
    }

    bone!.epVelocity[2] = 0
    _VectorAdd(bone!.epVelocity, velocity, &bone!.epVelocity)
    bone!.physicsSettled = false

    return true
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1590
func G2API_RagForceSolve(_ ghoul2: CGhoul2Info_v, _ force: Bool) -> Bool {
    let ghlInfo = ghoul2[0]

    if (ghlInfo.mFlags & GHOUL2_RAG_STARTED) == 0 { //can't do this if not in ragdoll
        return false
    }

    if force {
        ghlInfo.mFlags |= GHOUL2_RAG_FORCESOLVE
    } else {
        ghlInfo.mFlags &= ~GHOUL2_RAG_FORCESOLVE
    }

    return true
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1613
func G2API_SetBoneIKState(_ ghoul2: CGhoul2Info_v, _ time: Int32, _ boneName: String?, _ ikState: Int32, _ params: SharedSetBoneIKStateParams?) -> Bool {
    return G2_SetBoneIKState(ghoul2, time, boneName, ikState, params)
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1619
func G2API_IKMove(_ ghoul2: CGhoul2Info_v, _ time: Int32, _ params: SharedIKMoveParams) -> Bool {
    return G2_IKMove(ghoul2, time, params)
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1624
func G2API_RemoveBolt(_ ghlInfo: CGhoul2Info?, _ index: Int32) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_Remove_Bolt(&ghlInfo!.mBltlist, index)
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1633
func G2API_AddBolt(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boneName: String) -> Int32 {
    if ghoul2.size() > modelIndex {
        let ghlInfo = ghoul2[modelIndex]
        if G2_SetupModelPointers(ghlInfo) {
            return G2_Add_Bolt(ghlInfo, &ghlInfo.mBltlist, &ghlInfo.mSlist, boneName)
        }
    }
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1648
func G2API_AddBoltSurfNum(_ ghlInfo: CGhoul2Info?, _ surfIndex: Int32) -> Int32 {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_Add_Bolt_Surf_Num(ghlInfo, &ghlInfo!.mBltlist, &ghlInfo!.mSlist, surfIndex)
    }
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1658
func G2API_AttachG2Model(_ ghoul2From: CGhoul2Info_v, _ modelFrom: Int32, _ ghoul2To: CGhoul2Info_v, _ toBoltIndex: Int32, _ toModel: Int32) -> Bool {
    var toBoltIndex = toBoltIndex
    var toModel = toModel
    assert(toBoltIndex >= 0)
    if toBoltIndex < 0 {
        return false
    }
    if G2_SetupModelPointers(ghoul2From) && G2_SetupModelPointers(ghoul2To) {
        // make sure we have a model to attach, a model to attach to, and a bolt on that model
        if (ghoul2From.size() > modelFrom) &&
            (ghoul2To.size() > toModel) &&
            ((ghoul2To[toModel].mBltlist[toBoltIndex].boneNumber != -1) || (ghoul2To[toModel].mBltlist[toBoltIndex].surfaceNumber != -1)) {
            // encode the bolt address into the model bolt link
            toModel &= MODEL_AND
            toBoltIndex &= BOLT_AND
            ghoul2From[modelFrom].mModelBoltLink = (toModel << MODEL_SHIFT) | (toBoltIndex << BOLT_SHIFT)
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1684
func G2API_SetBoltInfo(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boltInfo: Int32) {
    if ghoul2.size() > modelIndex {
        ghoul2[modelIndex].mModelBoltLink = boltInfo
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1695
func G2API_DetachG2Model(_ ghlInfo: CGhoul2Info?) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        ghlInfo!.mModelBoltLink = -1
        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1705
func G2API_AttachEnt(_ boltInfo: inout Int32, _ ghlInfoTo: CGhoul2Info?, _ toBoltIndex: Int32, _ entNum: Int32, _ toModelNum: Int32) -> Bool {
    var toBoltIndex = toBoltIndex
    var entNum = entNum
    var toModelNum = toModelNum
    if G2_SetupModelPointers(ghlInfoTo) {
        // make sure we have a model to attach, a model to attach to, and a bolt on that model
        if ghlInfoTo!.mBltlist.count != 0 && ((ghlInfoTo!.mBltlist[toBoltIndex].boneNumber != -1) || (ghlInfoTo!.mBltlist[toBoltIndex].surfaceNumber != -1)) {
            // encode the bolt address into the model bolt link
            toModelNum &= MODEL_AND
            toBoltIndex &= BOLT_AND
            entNum &= ENTITY_AND
            boltInfo = (toBoltIndex << BOLT_SHIFT) | (toModelNum << MODEL_SHIFT) | (entNum << ENTITY_SHIFT)
            return true
        }
    }
    return false

}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1727
func G2API_GetBoltMatrix_SPMethod(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boltIndex: Int32, _ matrix: JKAMP.MdxaBone, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNum: Int32, _ modelList: Slots<qhandle_t>?, _ scale: JKAShared.vec3_t) -> Bool {
    assert(ghoul2.size() > modelIndex)

    if ghoul2.size() > modelIndex {
        let ghlInfo = ghoul2[modelIndex]

        //assert(boltIndex < ghlInfo->mBltlist.size());

        if boltIndex < ghlInfo.mBltlist.count && boltIndex >= 0 {
            // make sure we have transformed the skeleton
            if !gG2_GBMNoReconstruct {
                G2_ConstructGhoulSkeleton(ghoul2, frameNum, true, scale)
            }

            gG2_GBMNoReconstruct = false

            return MdxaBone.scratch { scaled in
                var use: MdxaBone
                use = ghlInfo.mBltlist[boltIndex].position

                if scale[0] != 0 || scale[1] != 0 || scale[2] != 0 {
                    scaled.copy(from: use)
                    use = scaled

                    // scale the bolt position by the scale factor for this model since at this point its still in model space
                    if scale[0] != 0 {
                        scaled.matrix[0][3] *= scale[0]
                    }
                    if scale[1] != 0 {
                        scaled.matrix[1][3] *= scale[1]
                    }
                    if scale[2] != 0 {
                        scaled.matrix[2][3] *= scale[2]
                    }
                }
                // pre generate the world matrix
                G2_GenerateWorldMatrix(angles, position)

                // AI: Raven casts each row of four floats to a float pointer for VectorNormalize. The call normalizes the vector accessor of the row.
                _ = VectorNormalize(&use.matrix[0].vector)
                _ = VectorNormalize(&use.matrix[1].vector)
                _ = VectorNormalize(&use.matrix[2].vector)

                Multiply_3x4Matrix(matrix, worldMatrix, use)
                return true
            }
        }
    }
    return false
}

//qboolean G2API_GetBoltMatrix(CGhoul2Info_v &ghoul2, const int modelIndex, const int boltIndex, mdxaBone_t *matrix, const vec3_t angles,
//							 const vec3_t position, const int AframeNum, qhandle_t *modelList, const vec3_t scale )
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1795
func G2API_GetBoltMatrix(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32, _ boltIndex: Int32, _ matrix: JKAMP.MdxaBone, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNum: Int32, _ modelList: Slots<qhandle_t>?, _ scale: JKAShared.vec3_t) -> Bool {
//	G2ERROR(ghoul2.IsValid(),"Invalid ghlInfo");
    G2_GenerateWorldMatrix(angles, position)
    if G2_SetupModelPointers(ghoul2) {
        if modelIndex >= 0 && modelIndex < ghoul2.size() {
            let tframeNum = G2API_GetTime(frameNum)
            let ghlInfo = ghoul2[modelIndex]

            if boltIndex >= 0 && boltIndex < ghlInfo.mBltlist.count {
                return MdxaBone.scratch { bolt in
                    if G2_NeedsRecalc(ghlInfo, tframeNum) {
                        G2_ConstructGhoulSkeleton(ghoul2, tframeNum, true, scale)
                    }

                    G2_GetBoltMatrixLow(ghlInfo, boltIndex, scale, bolt)
                    // scale the bolt position by the scale factor for this model since at this point its still in model space
                    if scale[0] != 0 {
                        bolt.matrix[0][3] *= scale[0]
                    }
                    if scale[1] != 0 {
                        bolt.matrix[1][3] *= scale[1]
                    }
                    if scale[2] != 0 {
                        bolt.matrix[2][3] *= scale[2]
                    }
                    // AI: Raven casts each row of four floats to a float pointer for VectorNormalize. The call normalizes the vector accessor of the row.
                    _ = VectorNormalize(&bolt.matrix[0].vector)
                    _ = VectorNormalize(&bolt.matrix[1].vector)
                    _ = VectorNormalize(&bolt.matrix[2].vector)

                    Multiply_3x4Matrix(matrix, worldMatrix, bolt)

                    if !gG2_GBMUseSPMethod { //this is horribly stupid and I hate it. But lots of game code is written to assume this 90 degree offset thing.
                        MdxaBone.scratch { rotMat in
                            MdxaBone.scratch { tempMatrix in
                                let newangles = JKAShared.vec3_t(0, 270, 0)
                                Create_Matrix(newangles, rotMat)
                                // make the model space matrix we have for this bolt into a world matrix
                                Multiply_3x4Matrix(tempMatrix, worldMatrix, bolt)
                                var origin = JKAShared.vec3_t()
                                origin[0] = tempMatrix.matrix[0][3]
                                origin[1] = tempMatrix.matrix[1][3]
                                origin[2] = tempMatrix.matrix[2][3]
                                tempMatrix.matrix[0][3] = 0
                                tempMatrix.matrix[1][3] = 0
                                tempMatrix.matrix[2][3] = 0
                                Multiply_3x4Matrix(matrix, tempMatrix, rotMat)
                                matrix.matrix[0][3] = origin[0]
                                matrix.matrix[1][3] = origin[1]
                                matrix.matrix[2][3] = origin[2]
                            }
                        }
                    } else { //reset it
                        gG2_GBMUseSPMethod = false
                    }

                    return true
                }
            }
        }
    }
    Multiply_3x4Matrix(matrix, worldMatrix, identityMatrix_G2API_GetBoltMatrix)
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1903
func G2API_ListSurfaces(_ ghlInfo: CGhoul2Info?) {
    if G2_SetupModelPointers(ghlInfo) {
        G2_List_Model_Surfaces(String(ghlInfo!.mFileName))
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1911
func G2API_ListBones(_ ghlInfo: CGhoul2Info?, _ frame: Int32) {
    if G2_SetupModelPointers(ghlInfo) {
        G2_List_Model_Bones(String(ghlInfo!.mFileName), frame)
    }
}

// decide if we have Ghoul2 models associated with this ghoul list or not
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1920
func G2API_HaveWeGhoul2Models(_ ghoul2: CGhoul2Info_v) -> Bool {
    var i: Int32
    i = 0
    while i < ghoul2.size() {
        if ghoul2[i].mModelindex != -1 {
            return true
        }
        i += 1
    }
    return false
}

// run through the Ghoul2 models and set each of the mModel values to the correct one from the cgs.gameModel offset lsit
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1937
func G2API_SetGhoul2ModelIndexes(_ ghoul2: CGhoul2Info_v, _ modelList: Slots<qhandle_t>?, _ skinList: Slots<qhandle_t>?) {
    return
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:1962
func G2API_GetAnimFileNameIndex(_ modelIndex: JKAShared.qhandle_t) -> String {
    let mod_m = R_GetModelByHandle(modelIndex)
    return mod_m!.mdxm!.animName
}

/**
```
***********************************************************************************************
 * G2API_GetAnimFileName
 *    obtains the name of a model's .gla (animation) file
 *
 * Input
 *    pointer to list of CGhoul2Info's, WraithID of specific model in that list
 *
 * Output
 *    true if a good filename was obtained, false otherwise
 *
 ***********************************************************************************************
```
*/
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1979
func G2API_GetAnimFileName(_ ghlInfo: CGhoul2Info?, _ filename: inout JKAShared.TextCursor) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_GetAnimFileName(String(ghlInfo!.mFileName), &filename)
    }
    return false
}

/**
```
=======================
SV_QsortEntityNumbers
=======================
```
*/
/// Source: oracle/codemp/ghoul2/G2_API.cpp:1993
private func QsortDistance(_ a: CollisionRecord?, _ b: CollisionRecord?) -> Int32 {
    let ea = a!.mDistance
    let eb = b!.mDistance

    if ea < eb {
        return -1
    }
    return 1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2003
private func G2_NeedRetransform(_ g2: CGhoul2Info?, _ frameNum: Int32) -> Bool {
    var i: Int32 = 0
    var needTrans = false
    while i < g2!.mBlist.count {
        var time: Float
        let bone = g2!.mBlist[i]

        if bone.pauseTime != 0 {
            time = (bone.pauseTime - bone.startTime) / 50.0
        } else {
            time = (frameNum - bone.startTime) / 50.0
        }
        let newFrame = Int32(bone.startFrame + (time * bone.animSpeed))

        if newFrame < bone.endFrame ||
            (bone.flags & BONE_ANIM_OVERRIDE_LOOP) != 0 ||
            (bone.flags & BONE_NEED_TRANSFORM) != 0 { //ok, we're gonna have to do it. bone is apparently animating.
            bone.flags &= ~BONE_NEED_TRANSFORM
            needTrans = true
        }
        i += 1
    }

    return needTrans
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2035
func G2API_CollisionDetectCache(_ collRecMap: Slots<CollisionRecord>, _ ghoul2: CGhoul2Info_v, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNumber: Int32, _ entNum: Int32, _ rayStart: JKAShared.vec3_t, _ rayEnd: JKAShared.vec3_t, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ traceFlags: Int32, _ useLod: Int32, _ fRadius: Float) {
    //this will store off the transformed verts for the next trace - this is slower, but for models that do not animate
    //frequently it is much much faster. -rww
    let test = ghoul2[0].mTransformedVertsArray
    if G2_SetupModelPointers(ghoul2) {
        var transRayStart = vec3_t()
        var transRayEnd = vec3_t()

        let tframeNum = G2API_GetTime(frameNumber)
        // make sure we have transformed the whole skeletons for each model
        if G2_NeedRetransform(ghoul2[0], tframeNum) || ghoul2[0].mTransformedVertsArray == nil { //optimization, only create new transform space if we need to, otherwise
            //store it off!
            var i: Int32 = 0
            while i < ghoul2.size() {
                let g2 = ghoul2[i]

                /*
                if ((g2.mFlags & GHOUL2_ZONETRANSALLOC) && g2.mTransformedVertsArray)
                { //clear it out, yo.
                    Z_Free(g2.mTransformedVertsArray);
                    g2.mTransformedVertsArray = 0;
                }
                */
                if g2.mTransformedVertsArray == nil || (g2.mFlags & GHOUL2_ZONETRANSALLOC) == 0 { //reworked so we only alloc once!
                    //if we have a pointer, but not a ghoul2_zonetransalloc flag, then that means
                    //it is a miniheap pointer. Just stomp over it.
                    let iSize: Int32 = g2.currentModel!.mdxm!.numSurfaces * 4
                    g2.mTransformedVertsArray = Slots<Int32>(scalars: Z_Malloc(iSize, TAG_GHOUL2, true), count: Int(g2.currentModel!.mdxm!.numSurfaces))
                }

                g2.mFlags |= GHOUL2_ZONETRANSALLOC

                i += 1
            }
            G2_ConstructGhoulSkeleton(ghoul2, frameNumber, true, scale)
            G2VertSpace!.ResetHeap()

            // now having done that, time to build the model
            G2_TransformModel(ghoul2, frameNumber, scale, G2VertSpace, useLod, false)

            //don't need to do this anymore now that I am using a flag for zone alloc.
            /*
            i = 0;
            while (i < ghoul2.size())
            {
                CGhoul2Info &g2 = ghoul2[i];
                int iSize = g2.currentModel->mdxm->numSurfaces * 4;

                int *zoneMem = (int *)Z_Malloc(iSize, TAG_GHOUL2, qtrue);
                memcpy(zoneMem, g2.mTransformedVertsArray, iSize);
                g2.mTransformedVertsArray = zoneMem;
                g2.mFlags |= GHOUL2_ZONETRANSALLOC;
                i++;
            }
            */
        }

        // pre generate the world matrix - used to transform the incoming ray
        G2_GenerateWorldMatrix(angles, position)

        // model is built. Lets check to see if any triangles are actually hit.
        // first up, translate the ray to model space
        TransformAndTranslatePoint(rayStart, &transRayStart, worldMatrixInv)
        TransformAndTranslatePoint(rayEnd, &transRayEnd, worldMatrixInv)

        // now walk each model and check the ray against each poly - sigh, this is SO expensive. I wish there was a better way to do this.
        G2_TraceModels(ghoul2, transRayStart, transRayEnd, collRecMap, entNum, traceFlags, useLod, fRadius, 0, 0, 0, 0, nil, false)
        var i: Int32
        i = 0
        while i < MAX_G2_COLLISIONS && collRecMap[i].mEntityNum != -1 {
            i += 1
        }

        // now sort the resulting array of collision records so they are distance ordered
        qsort(collRecMap, i, QsortDistance)
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2124
func G2API_CollisionDetect(_ collRecMap: Slots<CollisionRecord>, _ ghoul2: CGhoul2Info_v, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNumber: Int32, _ entNum: Int32, _ rayStart: JKAShared.vec3_t, _ rayEnd: JKAShared.vec3_t, _ scale: JKAShared.vec3_t, _ G2VertSpace: CMiniHeap?, _ traceFlags: Int32, _ useLod: Int32, _ fRadius: Float) {
    /*
    if (1)
    {
        G2API_CollisionDetectCache(collRecMap, ghoul2, angles, position, frameNumber, entNum,
            rayStart, rayEnd, scale, G2VertSpace, traceFlags, useLod, fRadius);
        return;
    }
    */

    if G2_SetupModelPointers(ghoul2) {
        var transRayStart = vec3_t()
        var transRayEnd = vec3_t()

        // make sure we have transformed the whole skeletons for each model
        G2_ConstructGhoulSkeleton(ghoul2, frameNumber, true, scale)

        // pre generate the world matrix - used to transform the incoming ray
        G2_GenerateWorldMatrix(angles, position)

        G2VertSpace!.ResetHeap()

        // now having done that, time to build the model
        G2_TransformModel(ghoul2, frameNumber, scale, G2VertSpace, useLod, false)

        // model is built. Lets check to see if any triangles are actually hit.
        // first up, translate the ray to model space
        TransformAndTranslatePoint(rayStart, &transRayStart, worldMatrixInv)
        TransformAndTranslatePoint(rayEnd, &transRayEnd, worldMatrixInv)

        // now walk each model and check the ray against each poly - sigh, this is SO expensive. I wish there was a better way to do this.
        G2_TraceModels(ghoul2, transRayStart, transRayEnd, collRecMap, entNum, traceFlags, useLod, fRadius, 0, 0, 0, 0, nil, false)
        var i: Int32
        i = 0
        while i < MAX_G2_COLLISIONS && collRecMap[i].mEntityNum != -1 {
            i += 1
        }

        // now sort the resulting array of collision records so they are distance ordered
        qsort(collRecMap, i, QsortDistance)
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2175
func G2API_SetGhoul2ModelFlags(_ ghlInfo: CGhoul2Info?, _ flags: Int32) -> Bool {
    if G2_SetupModelPointers(ghlInfo) {
        ghlInfo!.mFlags &= GHOUL2_NEWORIGIN
        ghlInfo!.mFlags |= flags
        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2186
func G2API_GetGhoul2ModelFlags(_ ghlInfo: CGhoul2Info?) -> Int32 {
    if G2_SetupModelPointers(ghlInfo) {
        return (ghlInfo!.mFlags & ~GHOUL2_NEWORIGIN)
    }
    return 0
}

// given a boltmatrix, return in vec a normalised vector for the axis requested in flags
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2196
func G2API_GiveMeVectorFromMatrix(_ boltMatrix: JKAMP.MdxaBone, _ flags: JKAMP.Eorientations, _ vec: inout JKAShared.vec3_t) {
    switch flags {
    case ORIGIN:
        vec[0] = boltMatrix.matrix[0][3]
        vec[1] = boltMatrix.matrix[1][3]
        vec[2] = boltMatrix.matrix[2][3]
    case POSITIVE_Y:
        vec[0] = boltMatrix.matrix[0][1]
        vec[1] = boltMatrix.matrix[1][1]
        vec[2] = boltMatrix.matrix[2][1]
    case POSITIVE_X:
        vec[0] = boltMatrix.matrix[0][0]
        vec[1] = boltMatrix.matrix[1][0]
        vec[2] = boltMatrix.matrix[2][0]
    case POSITIVE_Z:
        vec[0] = boltMatrix.matrix[0][2]
        vec[1] = boltMatrix.matrix[1][2]
        vec[2] = boltMatrix.matrix[2][2]
    case NEGATIVE_Y:
        vec[0] = -boltMatrix.matrix[0][1]
        vec[1] = -boltMatrix.matrix[1][1]
        vec[2] = -boltMatrix.matrix[2][1]
    case NEGATIVE_X:
        vec[0] = -boltMatrix.matrix[0][0]
        vec[1] = -boltMatrix.matrix[1][0]
        vec[2] = -boltMatrix.matrix[2][0]
    case NEGATIVE_Z:
        vec[0] = -boltMatrix.matrix[0][2]
        vec[1] = -boltMatrix.matrix[1][2]
        vec[2] = -boltMatrix.matrix[2][2]
    default:
        break
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2239
func G2API_CopyGhoul2Instance(_ g2From: CGhoul2Info_v, _ g2To: CGhoul2Info_v, _ modelIndex: Int32) -> Int32 {
    assert(modelIndex == -1) // copy individual bolted parts is not used in jk2 and I didn't want to deal with it
    // if ya want it, we will add it back correctly

    //G2ERROR(ghoul2From.IsValid(),"Invalid ghlInfo");
    if g2From.IsValid() {
        g2To.DeepCopy(g2From)

        var model: Int32 = 0

        while model < g2To.size() {
            if g2To[model].mGoreSetTag != 0 {
                let gore = FindGoreSet(g2To[model].mGoreSetTag)
                gore!.mRefCount += 1
            }

            model += 1
        }
        //G2ANIM(ghoul2From,"G2API_CopyGhoul2Instance (source)");
        //G2ANIM(ghoul2To,"G2API_CopyGhoul2Instance (dest)");
    }

    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2282
func G2API_CopySpecificG2Model(_ ghoul2From: CGhoul2Info_v, _ modelFrom: Int32, _ ghoul2To: CGhoul2Info_v, _ modelTo: Int32) {
    // have we real ghoul2 models yet?
    // assume we actually have a model to copy from
    if ghoul2From.size() > modelFrom {
        // if we don't have enough models on the to side, resize us so we do
        if ghoul2To.size() <= modelTo {
            assert(modelTo < 5)
            ghoul2To.resize(modelTo + 1)
        }
        // do the copy

        if ghoul2To.IsValid() && ghoul2To.size() >= modelTo { //remove the bonecache before we stomp over this instance.
            if ghoul2To[modelTo].mBoneCache != nil {
                RemoveBoneCache(ghoul2To[modelTo].mBoneCache)
                ghoul2To[modelTo].mBoneCache = nil
            }
        }
        // AI: Raven assigns the model by value with the compiler's `operator=`. The call copies the members into the model of the slot.
        ghoul2To[modelTo].copy(ghoul2From[modelFrom])
    }
}

// This version will automatically copy everything about this model, and make a new one if necessary.
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2330
func G2API_DuplicateGhoul2Instance(_ g2From: CGhoul2Info_v, _ g2To: inout CGhoul2Info_v?) {
    var ignore: Int32

    if g2To != nil { // This is bad.  We only want to do this if there is not yet a to declared.
        return
    }

    g2To = CGhoul2Info_v()
    // AI: Raven hands the module the address of the new instance. The instance takes a free slot of the table, row Z6 of docket 10.
    ghoul2Instances.takeSlot(g2To!)
    // Raven's `sizeof(CGhoul2Info_v)` is the size of its one `int` field.
    if g_G2AllocServer != 0 {
        g_G2ServerAlloc += Int32(Int32.byteCount)
    } else {
        g_G2ClientAlloc += Int32(Int32.byteCount)
    }
    g_Ghoul2Allocations += Int32(Int32.byteCount)
    G2_DEBUG_ShovePtrInTracker(g2To)
    let ghoul2 = g2To!

    ignore = G2API_CopyGhoul2Instance(g2From, ghoul2, -1)

    return
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2360
func G2API_GetSurfaceName(_ ghlInfo: CGhoul2Info?, _ surfNumber: Int32) -> String {
    // Raven returns his static empty buffer `noSurface`, and the String return is a copy of its empty text.
    let noSurface = ""
    if G2_SetupModelPointers(ghlInfo) {
        let mod = ghlInfo!.currentModel
        var surf: MdxmSurface? = nil
        var surfInfo: MdxmSurfHierarchy? = nil

        if mod == nil || mod!.mdxm == nil {
            Com_Error(ERR_DROP, "G2API_GetSurfaceName: Bad model on instance %s.", String(ghlInfo!.mFileName))
        }

        //ok, I guess it's semi-valid for the user to be passing in surface > numSurfs because they don't know how many surfs a model
        //may have.. but how did they get that surf index to begin with? Oh well.
        if surfNumber < 0 || surfNumber >= mod!.mdxm!.numSurfaces {
            Com_Printf("G2API_GetSurfaceName: You passed in an invalid surface number (%i) for model %s.\n", surfNumber, String(ghlInfo!.mFileName))
            return noSurface
        }


        surf = G2_FindSurface(mod, surfNumber, 0)
        if surf != nil {
            if surf!.thisSurfaceIndex < 0 || surf!.thisSurfaceIndex >= mod!.mdxm!.numSurfaces {
                Com_Error(ERR_DROP, "G2API_GetSurfaceName: Bad surf num (%i) on surf for instance %s.", surf!.thisSurfaceIndex, String(ghlInfo!.mFileName))
            }
            let surfIndexes = MdxmHierarchyOffsets(mod!.mdxm!, byteOffset: MdxmHeader.byteCount)
            surfInfo = MdxmSurfHierarchy(surfIndexes, byteOffset: surfIndexes.offsets[surf!.thisSurfaceIndex])
            return surfInfo!.name
        }
    }
    return noSurface
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2403
func G2API_GetSurfaceIndex(_ ghlInfo: CGhoul2Info?, _ surfaceName: String) -> Int32 {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_GetSurfaceIndex(ghlInfo, surfaceName)
    }
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2412
func G2API_GetGLAName(_ ghoul2: CGhoul2Info_v, _ modelIndex: Int32) -> String? {
    if G2_SetupModelPointers(ghoul2) {
        if ghoul2.size() > modelIndex {
            //model_t	*mod = R_GetModelByHandle(RE_RegisterModel(ghoul2[modelIndex].mFileName));
            //return mod->mdxm->animName;

            assert(ghoul2[modelIndex].currentModel != nil && ghoul2[modelIndex].currentModel!.mdxm != nil)
            return ghoul2[modelIndex].currentModel!.mdxm!.animName
        }
    }
    return nil
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2428
func G2API_SetNewOrigin(_ ghoul2: CGhoul2Info_v, _ boltIndex: Int32) -> Bool {
    var ghlInfo: CGhoul2Info? = nil

    if ghoul2.size() > 0 {
        ghlInfo = ghoul2[0]
    }

    if G2_SetupModelPointers(ghlInfo) {
        if boltIndex < 0 {
            var modelName = CharBuf(MAX_QPATH)
            // Raven tests `currentModel->name`, the address of the array, which is never NULL.
            // Raven tests `currentModel->name[0]`, the first byte of the name.
            if ghlInfo!.currentModel != nil &&
                !ghlInfo!.currentModel!.name.isEmpty {
                strcpy(&modelName, ghlInfo!.currentModel!.name)
            } else {
                strcpy(&modelName, "None?!")
            }

            Com_Error(ERR_DROP, "Bad boltindex (%i) trying to SetNewOrigin (naughty naughty!)\nModel %s\n", boltIndex, String(modelName))
        }

        ghlInfo!.mNewOrigin = boltIndex
        ghlInfo!.mFlags |= GHOUL2_NEWORIGIN
        return true
    }
    return false
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2463
func G2API_GetBoneIndex(_ ghlInfo: CGhoul2Info?, _ boneName: String) -> Int32 {
    if G2_SetupModelPointers(ghlInfo) {
        return G2_Get_Bone_Index(ghlInfo, boneName)
    }
    return -1
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2472
// AI: Raven hands a `char **` out-pointer to a zone block. The parameter is the Slots of bytes of that block, the form of a `void **` of kind `bytes`.
func G2API_SaveGhoul2Models(_ ghoul2: CGhoul2Info_v, _ buffer: inout Slots<JKAShared.byte>?, _ size: inout Int32) -> Bool {
    return G2_SaveGhoul2Models(ghoul2, &buffer, &size)
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2477
// AI: Raven reads a `char *` to the zone block of G2_SaveGhoul2Models. The parameter is the Slots of bytes of that block.
func G2API_LoadGhoul2Models(_ ghoul2: CGhoul2Info_v, _ buffer: Slots<JKAShared.byte>) {
    G2_LoadGhoul2Model(ghoul2, buffer)
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2482
func G2API_FreeSaveBuffer(_ buffer: Slots<JKAShared.byte>) {
    Z_Free(OpaquePointer(buffer.base))
}

// this is kinda sad, but I need to call the destructor in this module (exe), not the game.dll...
//
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2489
func G2API_LoadSaveCodeDestructGhoul2Info(_ ghoul2: CGhoul2Info_v) {

    G2API_ClearSkinGore(ghoul2)
    // AI: Raven calls the destructor by hand. The body calls clear, whose body is the destructor's one call to Free.
    ghoul2.clear()	// so I can load junk over it then memset to 0 without orphaning
}

//see if surfs have any shader info...
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2499
func G2API_SkinlessModel(_ g2: CGhoul2Info?) -> Bool {
    if G2_SetupModelPointers(g2) {
        let mod = g2!.currentModel

        if mod != nil &&
            mod!.mdxm != nil {
            var surf: MdxmSurfHierarchy
            var i: Int32

            surf = MdxmSurfHierarchy(mod!.mdxm!, byteOffset: mod!.mdxm!.ofsSurfHierarchy)

            i = 0
            while i < mod!.mdxm!.numSurfaces {
                // Raven tests `surf->shader` and `surf->shader[0]`.
                // Both read as the same Swift test, so the draft writes it once.
                if !surf.shader.isEmpty { //found a surface with a shader name, ok.
                    return false
                }

                surf = MdxmSurfHierarchy(surf, byteOffset: MdxmSurfHierarchy.byteCount(childIndexes: surf.numChildren))
                i += 1
            }
        }
    }

    //found nothing.
    return true
}

//way of seeing how many marks are on a model currently -rww
/// Source: oracle/codemp/ghoul2/G2_API.cpp:2534
func G2API_GetNumGoreMarks(_ g2: CGhoul2Info?) -> Int32 {
    if g2!.mGoreSetTag != 0 {
        let goreSet = FindGoreSet(g2!.mGoreSetTag)

        if goreSet != nil {
            // AI: Raven reads the size of the multimap. The table is a Dictionary of arrays, so the size is the sum of the array counts.
            var size = 0
            for (_, records) in goreSet!.mGoreRecords {
                size += records.count
            }
            return Int32(size)
        }
    }

    return 0
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2549
func G2API_ClearSkinGore(_ ghoul2: CGhoul2Info_v) {
    var i: Int32

    i = 0
    while i < ghoul2.size() {
        if ghoul2[i].mGoreSetTag != 0 {
            DeleteGoreSet(ghoul2[i].mGoreSetTag)
            ghoul2[i].mGoreSetTag = 0
        }
        i += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2563
func G2API_Ghoul2Size(_ ghoul2: CGhoul2Info_v) -> Int32 {
    return ghoul2.size()
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2569
func G2API_AddSkinGore(_ ghoul2: CGhoul2Info_v, _ gore: SkinGoreData) {
    if VectorLength(gore.rayDirection) < 0.1 {
        assert(false) // can't add gore without a shot direction
        return
    }

    // make sure we have transformed the whole skeletons for each model
    //G2_ConstructGhoulSkeleton(ghoul2, gore.currentTime, NULL, true, gore.angles, gore.position, gore.scale, false);
    G2_ConstructGhoulSkeleton(ghoul2, gore.currentTime, true, gore.scale)

    // pre generate the world matrix - used to transform the incoming ray
    G2_GenerateWorldMatrix(gore.angles, gore.position)

    // first up, translate the ray to model space
    var transRayDirection = vec3_t()
    var transHitLocation = vec3_t()
    TransformAndTranslatePoint(gore.hitLocation, &transHitLocation, worldMatrixInv)
    TransformPoint(gore.rayDirection, &transRayDirection, worldMatrixInv)

    var lod: Int32
    ResetGoreTag()
    // C converts the float clamp to `int` at the store.
    let lodbias = Int32(Com_Clamp(0, 2, Float(G2_DecideTraceLod(ghoul2[0], r_lodbias!.integer))))
    let maxLod = Int32(Com_Clamp(0, Float(ghoul2[0].currentModel!.numLods), 3))	//limit to the number of lods the main model has
    lod = lodbias
    while lod < maxLod {
        // now having done that, time to build the model
        G2VertSpaceServer!.ResetHeap()

        G2_TransformModel(ghoul2, gore.currentTime, gore.scale, G2VertSpaceServer, lod, true)

        // now walk each model and compute new texture coordinates
        G2_TraceModels(ghoul2, transHitLocation, transRayDirection, nil, gore.entNum, 0, lod, 0.0, gore.SSize, gore.TSize, gore.theta, gore.shader, gore, true)
        lod += 1
    }
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2606
func G2_TestModelPointers(_ ghlInfo: CGhoul2Info?) -> Bool {
    guard let ghlInfo else {
        return false
    }
    ghlInfo.mValid = false
    if ghlInfo.mModelindex != -1 {
        if (com_dedicated != nil && com_dedicated!.integer != 0) ||
            (G2_ShouldRegisterServer()) { //supreme hackery!
            ghlInfo.mModel = RE_RegisterServerModel(String(ghlInfo.mFileName))
        } else {
            ghlInfo.mModel = RE_RegisterModel(String(ghlInfo.mFileName))
        }
        ghlInfo.currentModel = R_GetModelByHandle(ghlInfo.mModel)
        if ghlInfo.currentModel != nil {
            if ghlInfo.currentModel!.mdxm != nil {
                if ghlInfo.currentModelSize != 0 {
                    if ghlInfo.currentModelSize != ghlInfo.currentModel!.mdxm!.ofsEnd {
                        Com_Error(ERR_DROP, "Ghoul2 model was reloaded and has changed, map must be restarted.\n")
                    }
                }
                ghlInfo.currentModelSize = ghlInfo.currentModel!.mdxm!.ofsEnd
                ghlInfo.animModel = R_GetModelByHandle(ghlInfo.currentModel!.mdxm!.animIndex)
                if ghlInfo.animModel != nil {
                    ghlInfo.aHeader = ghlInfo.animModel!.mdxa
                    if ghlInfo.aHeader != nil {
                        if ghlInfo.currentAnimModelSize != 0 {
                            if ghlInfo.currentAnimModelSize != ghlInfo.aHeader!.ofsEnd {
                                Com_Error(ERR_DROP, "Ghoul2 model was reloaded and has changed, map must be restarted.\n")
                            }
                        }
                        ghlInfo.currentAnimModelSize = ghlInfo.aHeader!.ofsEnd
                        ghlInfo.mValid = true
                    }
                }
            }
        }
    }
    if !ghlInfo.mValid {
        ghlInfo.currentModel = nil
        ghlInfo.currentModelSize = 0
        ghlInfo.animModel = nil
        ghlInfo.currentAnimModelSize = 0
        ghlInfo.aHeader = nil
    }
    return ghlInfo.mValid
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2675
func G2_SetupModelPointers(_ ghlInfo: CGhoul2Info?) -> Bool {
    G2PerformanceTimer_G2_SetupModelPointers.Start()
    guard let ghlInfo else {
        return false
    }

//	if (ghlInfo->mValid && ghlInfo->currentModel)
    if false { //rww - Why are we bothering with all this? We can't change models like this anyway.
        //This function goes over 200k on the precision timer (in debug, but still), so I'm
        //cutting it off here because it gets called constantly.
        G2Time_G2_SetupModelPointers += G2PerformanceTimer_G2_SetupModelPointers.End()
        return true
    }

    ghlInfo.mValid = false

//	G2WARNING(ghlInfo->mModelindex != -1,"Setup request on non-used info slot?");
    if ghlInfo.mModelindex != -1 {
        // RJ - experimental optimization!
        if ghlInfo.mModel == 0 || true {
            if (com_dedicated != nil && com_dedicated!.integer != 0) ||
                (G2_ShouldRegisterServer()) { //supreme hackery!
                ghlInfo.mModel = RE_RegisterServerModel(String(ghlInfo.mFileName))
            } else {
                ghlInfo.mModel = RE_RegisterModel(String(ghlInfo.mFileName))
            }
            ghlInfo.currentModel = R_GetModelByHandle(ghlInfo.mModel)
        }

        if ghlInfo.currentModel != nil {
            if ghlInfo.currentModel!.mdxm != nil {
                if ghlInfo.currentModelSize != 0 {
                    if ghlInfo.currentModelSize != ghlInfo.currentModel!.mdxm!.ofsEnd {
                        Com_Error(ERR_DROP, "Ghoul2 model was reloaded and has changed, map must be restarted.\n")
                    }
                }
                ghlInfo.currentModelSize = ghlInfo.currentModel!.mdxm!.ofsEnd
                ghlInfo.animModel = R_GetModelByHandle(ghlInfo.currentModel!.mdxm!.animIndex)
                if ghlInfo.animModel != nil {
                    ghlInfo.aHeader = ghlInfo.animModel!.mdxa
                    if ghlInfo.aHeader != nil {
                        if ghlInfo.currentAnimModelSize != 0 {
                            if ghlInfo.currentAnimModelSize != ghlInfo.aHeader!.ofsEnd {
                                Com_Error(ERR_DROP, "Ghoul2 model was reloaded and has changed, map must be restarted.\n")
                            }
                        }
                        ghlInfo.currentAnimModelSize = ghlInfo.aHeader!.ofsEnd
                        ghlInfo.mValid = true
                    }
                }
            }
        }
    }
    if !ghlInfo.mValid {
        ghlInfo.currentModel = nil
        ghlInfo.currentModelSize = 0
        ghlInfo.animModel = nil
        ghlInfo.currentAnimModelSize = 0
        ghlInfo.aHeader = nil
    }

    G2Time_G2_SetupModelPointers += G2PerformanceTimer_G2_SetupModelPointers.End()
    return ghlInfo.mValid
}

/// Source: oracle/codemp/ghoul2/G2_API.cpp:2773
func G2_SetupModelPointers(_ ghoul2: CGhoul2Info_v) -> Bool { // returns true if any model is properly set up
    var ret = false
    var i: Int32 = 0
    while i < ghoul2.size() {
        let r = G2_SetupModelPointers(ghoul2[i])
        ret = ret || r
        i += 1
    }
    return ret
}
