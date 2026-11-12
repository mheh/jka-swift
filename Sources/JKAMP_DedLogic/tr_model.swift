import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_model.cpp:35
private let FILE_HASH_SIZE = 1024 as Int32

/// Source: oracle/codemp/renderer/tr_model.cpp:36
var mhHashTable: Slots<ModelHash?> { world.storage.mhHashTable }

/// Source: oracle/codemp/renderer/tr_model.cpp:68
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var CachedModels: [String: CachedEndianedModelBinary_t]? {
    get { world.CachedModels }
    set { world.CachedModels = newValue }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:95
/// Raven's data table, a hand property of `EngineWorld`.
var FakeGLAFile: [JKAShared.byte] {
    get { world.FakeGLAFile }
    set { world.FakeGLAFile = newValue }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:521
var giRegisterMedia_CurrentLevel: Int32 {
    get { world.variables.giRegisterMedia_CurrentLevel }
    set { world.variables.giRegisterMedia_CurrentLevel = newValue }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1406
public var gbInsideRegisterModel: Bool {
    get { world.variables.gbInsideRegisterModel }
    set { world.variables.gbInsideRegisterModel = newValue }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:70
// AI: Raven takes two pointers into the disk image and subtracts its base. The parameters are the byte offsets into the image, the pointer-into-a-buffer rule.
public func RE_RegisterModels_StoreShaderRequest(_ psModelFileName: String, _ psShaderName: Int32, _ piShaderIndexPoke: Int32) {
    var sModelName = CharBuf(MAX_QPATH)

    Q_strncpyz(&sModelName, psModelFileName, Int32(sModelName.count))
    Q_strlwr(&sModelName)

    // AI: Raven's `(*CachedModels)[sModelName]` inserts a default entry for a new name. The body inserts one before the read.
    if CachedModels![String(sModelName)] == nil {
        CachedModels![String(sModelName)] = CachedEndianedModelBinary_t()
    }
    let ModelBin = CachedModels![String(sModelName)]!

    if ModelBin.pModelDiskImage == nil {
        assert(false) // should never happen, means that we're being called on a model that wasn't loaded
    } else {
        let iNameOffset = psShaderName
        let iPokeOffset = piShaderIndexPoke

        ModelBin.ShaderRegisterData.append((iNameOffset, iPokeOffset))
    }
}

// returns qtrue if loaded, and sets the supplied qbool to true if it was from cache (instead of disk)
//   (which we need to know to avoid LittleLong()ing everything again (well, the Mac needs to know anyway)...
//
// don't use ri.xxx functions in case running on dedicated...
//
/// Source: oracle/codemp/renderer/tr_model.cpp:125
public func RE_RegisterModels_GetDiskFile(_ psModelFileName: String, _ ppvBuffer: inout Slots<JKAShared.byte>?, _ pqbAlreadyCached: inout Bool) -> Bool {
    var sModelName = CharBuf(MAX_QPATH)

    Q_strncpyz(&sModelName, psModelFileName, Int32(sModelName.count))
    Q_strlwr(&sModelName)

    // AI: Raven's `(*CachedModels)[sModelName]` inserts a default entry for a new name. The body inserts one before the read.
    if CachedModels![String(sModelName)] == nil {
        CachedModels![String(sModelName)] = CachedEndianedModelBinary_t()
    }
    let ModelBin = CachedModels![String(sModelName)]!

    if ModelBin.pModelDiskImage == nil {
        // didn't have it cached, so try the disk...
        //

        // special case intercept first...
        //
        if strcmp(sDEFAULT_GLA_NAME + ".gla", psModelFileName) == 0 {
            // return fake params as though it was found on disk...
            //
            let pvFakeGLAFile = Slots<JKAShared.byte>(scalars: Z_Malloc(Int32(FakeGLAFile.count), TAG_FILESYS, false), count: FakeGLAFile.count)
            // AI: Raven copies the table with memcpy. The table is a Swift array, so the loop copies each byte into the zone block.
            for i in 0..<FakeGLAFile.count {
                pvFakeGLAFile[i] = FakeGLAFile[i]
            }
            ppvBuffer = pvFakeGLAFile
            pqbAlreadyCached = false // faking it like this should mean that it works fine on the Mac as well
            return true
        }

        var pvLoadedData: OpaquePointer? = nil
        let iLen = FS_ReadFile(String(sModelName), &pvLoadedData)
        // AI: Raven hands `ppvBuffer` to FS_ReadFile. The buffer is the Slots over the `iLen` bytes and the NUL that FS_ReadFile puts after them, or nil.
        ppvBuffer = ZipBackend.bytes(pvLoadedData, count: iLen + 1)
        pqbAlreadyCached = false
        let bSuccess = ppvBuffer != nil

        if bSuccess {
            Com_DPrintf("RE_RegisterModels_GetDiskFile(): Disk-loading \"%s\"\n", psModelFileName)
        }

        return bSuccess
    } else {
        ppvBuffer = ModelBin.pModelDiskImage
        pqbAlreadyCached = true
        return true
    }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:179
public func RE_RegisterModels_Malloc(_ iSize: Int32, _ pvDiskBufferIfJustLoaded: Slots<JKAShared.byte>, _ psModelFileName: String, _ pqbAlreadyFound: inout Bool, _ eTag: JKAShared.memtag_t) -> Slots<JKAShared.byte> {
    var sModelName = CharBuf(MAX_QPATH)

    Q_strncpyz(&sModelName, psModelFileName, Int32(sModelName.count))
    Q_strlwr(&sModelName)

    // AI: Raven's `(*CachedModels)[sModelName]` inserts a default entry for a new name. The body inserts one before the read.
    if CachedModels![String(sModelName)] == nil {
        CachedModels![String(sModelName)] = CachedEndianedModelBinary_t()
    }
    let ModelBin = CachedModels![String(sModelName)]!

    if ModelBin.pModelDiskImage == nil {
        // ... then this entry has only just been created, ie we need to load it fully...
        //
        // new, instead of doing a Z_Malloc and assigning that we just morph the disk buffer alloc
        //	then don't thrown it away on return - cuts down on mem overhead
        //
        // Raven's `if ( pvDiskBufferIfJustLoaded )` test has no path here, because each caller passes the buffer of RE_RegisterModels_GetDiskFile,
        // so the Z_Malloc arm for a NULL buffer drops.
        Z_MorphMallocTag(OpaquePointer(pvDiskBufferIfJustLoaded.base), eTag)

        ModelBin.pModelDiskImage = pvDiskBufferIfJustLoaded
        ModelBin.iAllocSize = iSize

        var iCheckSum: Int32 = 0
        if FS_FileIsInPAK(String(sModelName), &iCheckSum) == 1 {
            ModelBin.iPAKFileCheckSum = iCheckSum // else ModelBin's constructor will leave it as -1
        }

        pqbAlreadyFound = false
    } else {
        // Raven re-registers the shaders of the model here under `#ifndef DEDICATED`, tr_model.cpp:219, so the dedicated build has no line.
        pqbAlreadyFound = true // tell caller not to re-Endian or re-Shader this binary
    }

    ModelBin.iLastLevelUsedOn = RE_RegisterMedia_GetLevel()

    return ModelBin.pModelDiskImage!
}

// Unfortunately the dedicated server also hates shader loading. So we need an alternate of this func.
//
/// Source: oracle/codemp/renderer/tr_model.cpp:253
public func RE_RegisterServerModels_Malloc(_ iSize: Int32, _ pvDiskBufferIfJustLoaded: Slots<JKAShared.byte>, _ psModelFileName: String, _ pqbAlreadyFound: inout Bool, _ eTag: JKAShared.memtag_t) -> Slots<JKAShared.byte> {
    var sModelName = CharBuf(MAX_QPATH)

    Q_strncpyz(&sModelName, psModelFileName, Int32(sModelName.count))
    Q_strlwr(&sModelName)

    // AI: Raven's `(*CachedModels)[sModelName]` inserts a default entry for a new name. The body inserts one before the read.
    if CachedModels![String(sModelName)] == nil {
        CachedModels![String(sModelName)] = CachedEndianedModelBinary_t()
    }
    let ModelBin = CachedModels![String(sModelName)]!

    if ModelBin.pModelDiskImage == nil {
        // ... then this entry has only just been created, ie we need to load it fully...
        //
        // new, instead of doing a Z_Malloc and assigning that we just morph the disk buffer alloc
        //	then don't thrown it away on return - cuts down on mem overhead
        //
        // Raven's `if ( pvDiskBufferIfJustLoaded )` test has no path here, because each caller passes the buffer of RE_RegisterModels_GetDiskFile,
        // so the Z_Malloc arm for a NULL buffer drops.
        Z_MorphMallocTag(OpaquePointer(pvDiskBufferIfJustLoaded.base), eTag)

        ModelBin.pModelDiskImage = pvDiskBufferIfJustLoaded
        ModelBin.iAllocSize = iSize

        var iCheckSum: Int32 = 0
        if FS_FileIsInPAK(String(sModelName), &iCheckSum) == 1 {
            ModelBin.iPAKFileCheckSum = iCheckSum // else ModelBin's constructor will leave it as -1
        }

        pqbAlreadyFound = false
    } else {
        // if we already had this model entry, then re-register all the shaders it wanted...
        // Raven's loop stands in a comment block, tr_model.cpp:288 to :307.
        //No. Bad.
        pqbAlreadyFound = true // tell caller not to re-Endian or re-Shader this binary
    }

    ModelBin.iLastLevelUsedOn = RE_RegisterMedia_GetLevel()

    return ModelBin.pModelDiskImage!
}

// dump any models not being used by this level if we're running low on memory...
//
/// Source: oracle/codemp/renderer/tr_model.cpp:326
private func GetModelDataAllocSize() -> Int32 {
    return Z_MemSize(TAG_MODEL_MD3) +
        Z_MemSize(TAG_MODEL_GLM) +
        Z_MemSize(TAG_MODEL_GLA)
}

/// Source: oracle/codemp/renderer/tr_model.cpp:337
public func RE_RegisterModels_LevelLoadEnd(_ bDeleteEverythingNotUsedThisLevel: Bool = false) -> Bool {
    var bAtLeastoneModelFreed = false

    Com_DPrintf(S_COLOR_RED + "RE_RegisterModels_LevelLoadEnd():\n")

    if gbInsideRegisterModel {
        Com_DPrintf("(Inside RE_RegisterModel (z_malloc recovery?), exiting...\n")
    } else {
        var iLoadedModelBytes = GetModelDataAllocSize()
        let iMaxModelBytes = r_modelpoolmegs!.integer * 1024 * 1024

        // AI: Raven steps the iterator only when no erase occurred. The walk over the sorted keys reads each entry once, so `bEraseOccured` has no use.
        // AI: Raven walks the std::map in the order of its sstring_t keys, which compare with Q_stricmp. The walk sorts the keys of the Dictionary in that order.
        for psModelName in CachedModels!.keys.sorted(by: { Q_stricmp($0, $1) < 0 }) {
            if !(bDeleteEverythingNotUsedThisLevel || iLoadedModelBytes > iMaxModelBytes) {
                break
            }

            let CachedModel = CachedModels![psModelName]!

            var bDeleteThis = false

            if bDeleteEverythingNotUsedThisLevel {
                bDeleteThis = (CachedModel.iLastLevelUsedOn != RE_RegisterMedia_GetLevel()) ? true : false
            } else {
                bDeleteThis = (CachedModel.iLastLevelUsedOn < RE_RegisterMedia_GetLevel()) ? true : false
            }

            // if it wasn't used on this level, dump it...
            //
            if bDeleteThis {
                Com_DPrintf(S_COLOR_RED + "Dumping \"%s\"", psModelName)

                if CachedModel.pModelDiskImage != nil {
                    Z_Free(OpaquePointer(CachedModel.pModelDiskImage!.base))
                    //CachedModel.pModelDiskImage = NULL;	// REM for reference, erase() call below negates the need for it.
                    bAtLeastoneModelFreed = true
                }
                CachedModels![psModelName] = nil

                iLoadedModelBytes = GetModelDataAllocSize()
            }
        }
    }

    Com_DPrintf(S_COLOR_RED + "RE_RegisterModels_LevelLoadEnd(): Ok\n")

    return bAtLeastoneModelFreed
}

// scan through all loaded models and see if their PAK checksums are still valid with the current pure PAK lists,
//	dump any that aren't (so people can't cheat by using models with huge spikes that show through walls etc)
//
// (avoid using ri.xxxx stuff here in case running on dedicated)
//
/// Source: oracle/codemp/renderer/tr_model.cpp:418
private func RE_RegisterModels_DumpNonPure() {
    Com_DPrintf("RE_RegisterModels_DumpNonPure():\n")

    if CachedModels == nil {
        return
    }
    // AI: Raven steps the iterator only when no erase occurred. The walk over the sorted keys reads each entry once, so `bEraseOccured` has no use.
    // AI: Raven walks the std::map in the order of its sstring_t keys, which compare with Q_stricmp. The walk sorts the keys of the Dictionary in that order.
    for psModelName in CachedModels!.keys.sorted(by: { Q_stricmp($0, $1) < 0 }) {
        let CachedModel = CachedModels![psModelName]!

        var iCheckSum: Int32 = -1
        let iInPak = FS_FileIsInPAK(psModelName, &iCheckSum)

        if iInPak == -1 || iCheckSum != CachedModel.iPAKFileCheckSum {
            if stricmp(sDEFAULT_GLA_NAME + ".gla", psModelName) != 0 { // don't dump "*default.gla", that's program internal anyway
                // either this is not from a PAK, or it's from a non-pure one, so ditch it...
                //
                Com_DPrintf("Dumping none pure model \"%s\"", psModelName)

                if CachedModel.pModelDiskImage != nil {
                    Z_Free(OpaquePointer(CachedModel.pModelDiskImage!.base))
                    //CachedModel.pModelDiskImage = NULL;	// REM for reference, erase() call below negates the need for it.
                }
                CachedModels![psModelName] = nil
            }
        }
    }

    Com_DPrintf("RE_RegisterModels_DumpNonPure(): Ok\n")
}

/// Source: oracle/codemp/renderer/tr_model.cpp:467
public func RE_RegisterModels_Info_f() {
    var iTotalBytes: Int32 = 0
    if CachedModels == nil {
        Com_Printf("%d bytes total (%.2fMB)\n", iTotalBytes, Float(iTotalBytes) / 1024.0 / 1024.0)
        return
    }

    let iModels = Int32(CachedModels!.count)
    var iModel: Int32 = 0

    // AI: Raven walks the std::map in the order of its sstring_t keys, which compare with Q_stricmp. The walk sorts the keys of the Dictionary in that order.
    for psModelName in CachedModels!.keys.sorted(by: { Q_stricmp($0, $1) < 0 }) {
        let CachedModel = CachedModels![psModelName]!

        Com_Printf("%d/%d: \"%s\" (%d bytes)", iModel, iModels, psModelName, CachedModel.iAllocSize)

        iTotalBytes += CachedModel.iAllocSize
        iModel += 1
    }
    Com_Printf("%d bytes total (%.2fMB)\n", iTotalBytes, Float(iTotalBytes) / 1024.0 / 1024.0)
}

// (don't use ri.xxx functions since the renderer may not be running here)...
//
/// Source: oracle/codemp/renderer/tr_model.cpp:496
private func RE_RegisterModels_DeleteAll() {
    if CachedModels == nil {
        return //argh!
    }

    // AI: Raven walks the std::map in the order of its sstring_t keys, which compare with Q_stricmp. The walk sorts the keys of the Dictionary in that order.
    for psModelName in CachedModels!.keys.sorted(by: { Q_stricmp($0, $1) < 0 }) {
        let CachedModel = CachedModels![psModelName]!

        if CachedModel.pModelDiskImage != nil {
            Z_Free(OpaquePointer(CachedModel.pModelDiskImage!.base))
        }

        CachedModels![psModelName] = nil
    }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:560
var sPrevMapName: CharBuf {
    get { world.sPrevMapName }
    set { world.sPrevMapName = newValue }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:522
public func RE_RegisterMedia_LevelLoadBegin(_ psMapName: String, _ eForceReload: JKAMP.ForceReload_e) {
    // for development purposes we may want to ditch certain media just before loading a map...
    //
    let bDeleteModels = eForceReload == eForceReload_MODELS || eForceReload == eForceReload_ALL
    //	bool bDeleteBSP		= eForceReload == eForceReload_BSP    || eForceReload == eForceReload_ALL;

    if bDeleteModels {
        RE_RegisterModels_DeleteAll()
    } else {
        if sv_pure!.integer != 0 {
            RE_RegisterModels_DumpNonPure()
        }
    }

    tr.numBSPModels = 0

    // at some stage I'll probably want to put some special logic here, like not incrementing the level number
    //	when going into a map like "brig" or something, so returning to the previous level doesn't require an
    //	asset reload etc, but for now...
    //
    // only bump level number if we're not on the same level.
    //	Note that this will hide uncached models, which is perhaps a bad thing?...
    //
    if Q_stricmp(psMapName, String(sPrevMapName)) != 0 {
        Q_strncpyz(&sPrevMapName, psMapName, Int32(sPrevMapName.count))
        giRegisterMedia_CurrentLevel += 1
    }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:568
public func RE_RegisterMedia_GetLevel() -> Int32 {
    return giRegisterMedia_CurrentLevel
}

/// Source: oracle/codemp/renderer/tr_model.cpp:577
public func RE_RegisterMedia_LevelLoadEnd() {
    RE_RegisterModels_LevelLoadEnd(false)
}

/**
```
** R_GetModelByHandle
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:593
public func R_GetModelByHandle(_ index: JKAShared.qhandle_t) -> Model? {
    var mod: Model?

    // out of range gets the defualt model
    if index < 1 || index >= tr.numModels {
        return tr.models[0]
    }

    mod = tr.models[index]

    return mod
}

/**
```
** R_AllocModel
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:611
public func R_AllocModel() -> Model? {
    var mod: Model

    if tr.numModels == MAX_MOD_KNOWN {
        return nil
    }

    mod = Model(Hunk_Alloc(Int32(Model.byteCount), h_low))
    mod.index = tr.numModels
    tr.models[tr.numModels] = mod
    tr.numModels += 1

    return mod
}

/**
```
================
return a hash value for the filename
================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:635
private func generateHashValue(_ fname: String, _ size: Int32) -> CLong {
    var i: Int32
    var hash: CLong
    var letter: CChar
    // Raven indexes his own `fname` parameter by byte, so the body reads a CharBuf of it.
    let fname = CharBuf(fname)

    hash = 0
    i = 0
    while fname[i] != 0 {
        let byte: UInt8 = fname[i]
        // Foundation also declares tolower, so the qualifier picks the C-locale form of JKAShared.
        letter = CChar(truncatingIfNeeded: JKAShared.tolower(Int32(byte)))
        if letter == Int32(ascii: ".") {
            break // don't include extension
        }
        if letter == Int32(ascii: "\\") {
            letter = CChar(truncatingIfNeeded: Int32(ascii: "/")) // damn path names
        }
        // C widens the `int` factor to `long` for the product.
        hash += CLong(letter) * CLong(i + 119)
        i += 1
    }
    hash &= CLong(size - 1)
    return hash
}

/// Source: oracle/codemp/renderer/tr_model.cpp:653
public func RE_InsertModelIntoHash(_ name: String, _ mod: Model) {
    var hash: Int32
    var mh: ModelHash

    hash = Int32(generateHashValue(name, FILE_HASH_SIZE))

    // insert this file into the hash table so we can look it up faster later
    mh = ModelHash(Hunk_Alloc(Int32(ModelHash.byteCount), h_low))

    mh.next = mhHashTable[hash]
    mh.modelHandle = mod.index
    mh.name = name
    mhHashTable[hash] = mh
}

/**
```
=================
ServerLoadMDXA - load a Ghoul 2 animation file
=================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:683
public func ServerLoadMDXA(_ mod: Model, _ buffer: Slots<JKAShared.byte>, _ mod_name: String, _ bAlreadyCached: inout Bool) -> Bool {
    var pinmodel: MdxaHeader
    var mdxa: MdxaHeader
    var version: Int32
    var size: Int32

    pinmodel = MdxaHeader(buffer.base)
    //
    // read some fields from the binary, but only LittleLong() them when we know this wasn't an already-cached model...
    //
    version = pinmodel.version
    size = pinmodel.ofsEnd

    // Raven's two LittleLong calls under `if (!bAlreadyCached)` have no line, because LittleLong of the WinDed arm is its argument.

    if version != MDXA_VERSION {
        return false
    }

    mod.type = MOD_MDXA
    mod.dataSize += size

    var bAlreadyFound = false
    mdxa = MdxaHeader(/*Hunk_Alloc( size );*/ RE_RegisterServerModels_Malloc(size, buffer, mod_name, &bAlreadyFound, TAG_MODEL_GLA).base)
    mod.mdxa = mdxa

    assert(bAlreadyCached == bAlreadyFound) // I should probably eliminate 'bAlreadyFound', but wtf?

    if !bAlreadyFound {
        // horrible new hackery, if !bAlreadyFound then we've just done a tag-morph, so we need to set the
        //	bool reference passed into this function to true, to tell the caller NOT to do an FS_Freefile since
        //	we've hijacked that memory block...
        //
        // Aaaargh. Kill me now...
        //
        bAlreadyCached = true
        assert(mdxa == MdxaHeader(buffer.base))
        //		memcpy( mdxa, buffer, size );	// and don't do this now, since it's the same thing

        // Raven's six LL calls have no line, because LittleLong of the WinDed arm is its argument.
    }

    if mdxa.numFrames < 1 {
        return false
    }

    if bAlreadyFound {
        return true // All done, stop here, do not LittleLong() etc. Do not pass go...
    }

    return true
}

/**
```
=================
ServerLoadMDXM - load a Ghoul 2 Mesh file
=================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:799
public func ServerLoadMDXM(_ mod: Model, _ buffer: Slots<JKAShared.byte>, _ mod_name: String, _ bAlreadyCached: inout Bool) -> Bool {
    var i: Int32
    var l: Int32
    var pinmodel: MdxmHeader
    var mdxm: MdxmHeader
    var lod: MdxmLOD
    var surf: MdxmSurface
    var version: Int32
    var size: Int32
    var sh: Shader?
    var surfInfo: MdxmSurfHierarchy

    pinmodel = MdxmHeader(buffer.base)
    //
    // read some fields from the binary, but only LittleLong() them when we know this wasn't an already-cached model...
    //
    version = pinmodel.version
    size = pinmodel.ofsEnd

    // Raven's two LittleLong calls under `if (!bAlreadyCached)` have no line, because LittleLong of the WinDed arm is its argument.

    if version != MDXM_VERSION {
        return false
    }

    mod.type = MOD_MDXM
    mod.dataSize += size

    var bAlreadyFound = false
    mdxm = MdxmHeader(/*Hunk_Alloc( size );*/ RE_RegisterServerModels_Malloc(size, buffer, mod_name, &bAlreadyFound, TAG_MODEL_GLM).base)
    mod.mdxm = mdxm

    assert(bAlreadyCached == bAlreadyFound) // I should probably eliminate 'bAlreadyFound', but wtf?

    if !bAlreadyFound {
        // horrible new hackery, if !bAlreadyFound then we've just done a tag-morph, so we need to set the
        //	bool reference passed into this function to true, to tell the caller NOT to do an FS_Freefile since
        //	we've hijacked that memory block...
        //
        // Aaaargh. Kill me now...
        //
        bAlreadyCached = true
        assert(mdxm == MdxmHeader(buffer.base))
        //		memcpy( mdxm, buffer, size );	// and don't do this now, since it's the same thing

        // Raven's seven LL calls have no line, because LittleLong of the WinDed arm is its argument.
    }

    // first up, go load in the animation file we need that has the skeletal animation info for this model
    mdxm.animIndex = RE_RegisterServerModel(va("%s.gla", mdxm.animName))
    if mdxm.animIndex == 0 {
        return false
    }

    mod.numLods = mdxm.numLODs - 1 //copy this up to the model for ease of use - it wil get inced after this.

    if bAlreadyFound {
        return true // All done. Stop, go no further, do not LittleLong(), do not pass Go...
    }

    surfInfo = MdxmSurfHierarchy(mdxm, byteOffset: mdxm.ofsSurfHierarchy)
    i = 0
    while i < mdxm.numSurfaces {
        // Raven's LL calls of the counts and of each child index have no line, because LittleLong of the WinDed arm is its argument.

        // We will not be using shaders on the server.
        sh = nil
        // insert it in the surface list

        surfInfo.shaderIndex = 0

        // AI: Raven hands the addresses of the two fields. The call hands their byte distances from the disk image, which the callee stores.
        RE_RegisterModels_StoreShaderRequest(mod_name, surfInfo.shader(buffer), surfInfo.shaderIndex(buffer))

        // find the next surface
        surfInfo = MdxmSurfHierarchy(surfInfo, byteOffset: MdxmSurfHierarchy.byteCount(childIndexes: surfInfo.numChildren))
        i += 1
    }

    // swap all the LOD's	(we need to do the middle part of this even for intel, because of shader reg and err-check)
    lod = MdxmLOD(mdxm, byteOffset: mdxm.ofsLODs)
    l = 0
    while l < mdxm.numLODs {
        var triCount: Int32 = 0

        // swap all the surfaces
        surf = MdxmSurface(lod, byteOffset: Int32(MdxmLOD.byteCount) + (mdxm.numSurfaces * Int32(MdxmLODSurfOffset.byteCount)))
        i = 0
        while i < mdxm.numSurfaces {
            // Raven's LL calls of the counts and offsets have no line, because LittleLong of the WinDed arm is its argument.

            triCount += surf.numTriangles

            if surf.numVerts > SHADER_MAX_VERTEXES {
                return false
            }
            if surf.numTriangles * 3 > SHADER_MAX_INDEXES {
                return false
            }

            // change to surface identifier
            surf.ident = SF_MDX

            // register the shaders

            // find the next surface
            surf = MdxmSurface(surf, byteOffset: surf.ofsEnd)
            i += 1
        }

        // find the next LOD
        lod = MdxmLOD(lod, byteOffset: lod.ofsEnd)
        l += 1
    }

    return true
}

/**
```
====================
RE_RegisterServerModel

Same as RE_RegisterModel, except used by the server to handle ghoul2 instance models.
====================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1003
public func RE_RegisterServerModel(_ name: String) -> JKAShared.qhandle_t {
    var mod: Model?
    var buf: Slots<JKAShared.byte>? = nil
    var lod: Int32
    var loaded = false
    //	qhandle_t	hModel;
    var numLoaded: Int32
    /*
    Ghoul2 Insert Start
    */
    var hash: Int32
    var mh: ModelHash?
    /*
    Ghoul2 Insert End
    */

    if r_noServerGhoul2 == nil { //keep it from choking when it gets to these checks in the g2 code. Registering all r_ cvars for the server would be a Bad Thing though.
        r_noServerGhoul2 = Cvar_Get("r_noserverghoul2", "0", 0)
    }

    if name.isEmpty {
        return 0
    }

    if strlen(name) >= MAX_QPATH {
        return 0
    }

    hash = Int32(generateHashValue(name, FILE_HASH_SIZE))

    //
    // see if the model is already loaded
    //
    mh = mhHashTable[hash]
    while let m = mh {
        if Q_stricmp(m.name, name) == 0 {
            return m.modelHandle
        }
        mh = m.next
    }

    mod = R_AllocModel()
    if mod == nil {
        return 0
    }

    // only set the name after the model has been successfully loaded
    Q_strncpyz(&mod!.nameBuffer, name, Int32(mod!.nameBuffer.count))

    var iLODStart: Int32 = 0
    if strstr(name, ".md3") != nil {
        iLODStart = MD3_MAX_LODS - 1 // this loads the md3s in reverse so they can be biased
    }
    mod!.numLods = 0

    //
    // load the files
    //
    numLoaded = 0

    // Port-note: Raven's `goto fail` leaves the loop for the `fail:` label. The flag `failed` skips the success arm after the loop.
    var failed = false
    lod = iLODStart
    while lod >= 0 {
        var filename = CharBuf(1024)

        strcpy(&filename, name)

        if lod != 0 {
            var namebuf = CharBuf(80)

            if let dot = Q_strrchr(String(filename), Int32(ascii: ".")) {
                filename[dot] = 0
            }
            strcpy(&namebuf, va("_%d.md3", lod))
            strcat(&filename, namebuf)
        }

        var bAlreadyCached = false
        if !RE_RegisterModels_GetDiskFile(String(filename), &buf, &bAlreadyCached) {
            lod -= 1
            continue
        }

        //loadmodel = mod;	// this seems to be fairly pointless

        // important that from now on we pass 'filename' instead of 'name' to all model load functions,
        //	because 'filename' accounts for any LOD mangling etc so guarantees unique lookups for yet more
        //	internal caching...
        //
        // AI: Raven reads the first word of the buffer as `unsigned`. The word reads as Int32, the type of the ident macros, so the compare has the same bits.
        let ident = buf![int: 0]
        // Raven's `if (!bAlreadyCached) ident = LittleLong(ident)` has no line, because LittleLong of the WinDed arm is its argument.

        switch ident { //if you're trying to register anything else as a model type on the server, you are out of luck
        case MDXA_IDENT:
            loaded = ServerLoadMDXA(mod!, buf!, String(filename), &bAlreadyCached)
        case MDXM_IDENT:
            loaded = ServerLoadMDXM(mod!, buf!, String(filename), &bAlreadyCached)
        default:
            failed = true
        }
        if failed {
            break
        }

        if !bAlreadyCached { // important to check!!
            FS_FreeFile(buf!)
        }

        if !loaded {
            if lod == 0 {
                failed = true
                break
            } else {
                break
            }
        } else {
            mod!.numLods += 1
            numLoaded += 1
        }
        lod -= 1
    }

    if !failed && numLoaded != 0 {
        // duplicate into higher lod spots that weren't
        // loaded, in case the user changes r_lodbias on the fly
        lod -= 1
        while lod >= 0 {
            mod!.numLods += 1
            mod!.md3[lod] = mod!.md3[lod + 1]
            lod -= 1
        }

        /*
        Ghoul2 Insert Start
        */

        RE_InsertModelIntoHash(name, mod!)
        return mod!.index
        /*
        Ghoul2 Insert End
        */
    }

    // fail:
    // we still keep the model_t around, so if the model name is asked for
    // again, we won't bother scanning the filesystem
    mod!.type = MOD_BAD
    RE_InsertModelIntoHash(name, mod!)
    return 0
}

/**
```
====================
RE_RegisterModel

Loads in a model for the given name

Zero will be returned if the model fails to load.
An entry will be retained for failed models as an
optimization to prevent disk rescanning if they are
asked for again.
====================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1169
private func RE_RegisterModel_Actual(_ name: String) -> JKAShared.qhandle_t {
    var mod: Model?
    var buf: Slots<JKAShared.byte>? = nil
    var lod: Int32
    var loaded = false
    //	qhandle_t	hModel;
    var numLoaded: Int32
    /*
    Ghoul2 Insert Start
    */
    var hash: Int32
    var mh: ModelHash?
    /*
    Ghoul2 Insert End
    */

    if name.isEmpty {
        Com_Printf("RE_RegisterModel: NULL name\n")
        return 0
    }

    if strlen(name) >= MAX_QPATH {
        Com_DPrintf(S_COLOR_RED + "Model name exceeds MAX_QPATH\n")
        return 0
    }

    /*
    Ghoul2 Insert Start
    */
    //	if (!tr.registered) {
    //		Com_Printf (S_COLOR_YELLOW  "RE_RegisterModel (%s) called before ready!\n",name );
    //		return 0;
    //	}
    //
    // search the currently loaded models
    //
    hash = Int32(generateHashValue(name, FILE_HASH_SIZE))

    //
    // see if the model is already loaded
    //
    mh = mhHashTable[hash]
    while let m = mh {
        if Q_stricmp(m.name, name) == 0 {
            return m.modelHandle
        }
        mh = m.next
    }

    //	for ( hModel = 1 ; hModel < tr.numModels; hModel++ ) {
    //		mod = tr.models[hModel];
    //		if ( !strcmp( mod->name, name ) ) {
    //			if( mod->type == MOD_BAD ) {
    //				return 0;
    //			}
    //			return hModel;
    //		}
    //	}

    if CharBuf(name)[0] == Int32(ascii: "#") {
        var temp = CharBuf(MAX_QPATH)

        tr.numBSPModels += 1
        Com_sprintf(&temp, MAX_QPATH, "*%d-0", tr.numBSPModels)
        hash = Int32(generateHashValue(String(temp), FILE_HASH_SIZE))
        mh = mhHashTable[hash]
        while let m = mh {
            if Q_stricmp(m.name, String(temp)) == 0 {
                return m.modelHandle
            }
            mh = m.next
        }

        return 0
    }

    if CharBuf(name)[0] == Int32(ascii: "*") { // don't create a bad model for a bsp model
        if Q_stricmp(name, "*default.gla") != 0 {
            return 0
        }
    }

    /*
    Ghoul2 Insert End
    */

    // allocate a new model_t

    mod = R_AllocModel()
    if mod == nil {
        Com_Printf(S_COLOR_YELLOW + "RE_RegisterModel: R_AllocModel() failed for '%s'\n", name)
        return 0
    }

    // only set the name after the model has been successfully loaded
    Q_strncpyz(&mod!.nameBuffer, name, Int32(mod!.nameBuffer.count))

    var iLODStart: Int32 = 0
    if strstr(name, ".md3") != nil {
        iLODStart = MD3_MAX_LODS - 1 // this loads the md3s in reverse so they can be biased
    }
    mod!.numLods = 0

    //
    // load the files
    //
    numLoaded = 0

    // Port-note: Raven's `goto fail` leaves the loop for the `fail:` label. The flag `failed` skips the success arm after the loop.
    var failed = false
    lod = iLODStart
    while lod >= 0 {
        var filename = CharBuf(1024)

        strcpy(&filename, name)

        if lod != 0 {
            var namebuf = CharBuf(80)

            if let dot = Q_strrchr(String(filename), Int32(ascii: ".")) {
                filename[dot] = 0
            }
            strcpy(&namebuf, va("_%d.md3", lod))
            strcat(&filename, namebuf)
        }

        var bAlreadyCached = false
        if !RE_RegisterModels_GetDiskFile(String(filename), &buf, &bAlreadyCached) {
            lod -= 1
            continue
        }

        //loadmodel = mod;	// this seems to be fairly pointless

        // important that from now on we pass 'filename' instead of 'name' to all model load functions,
        //	because 'filename' accounts for any LOD mangling etc so guarantees unique lookups for yet more
        //	internal caching...
        //
        // AI: Raven reads the first word of the buffer as `unsigned`. The word reads as Int32, the type of the ident macros, so the compare has the same bits.
        let ident = buf![int: 0]
        // Raven's `if (!bAlreadyCached) ident = LittleLong(ident)` has no line, because LittleLong of the WinDed arm is its argument.

        switch ident {
        // if you add any new types of model load in this switch-case, tell me,
        //	or copy what I've done with the cache scheme (-ste).
        //
        case MDXA_IDENT:
            loaded = R_LoadMDXA(mod!, buf!, String(filename), &bAlreadyCached)

        case MDXM_IDENT:
            loaded = R_LoadMDXM(mod!, buf!, String(filename), &bAlreadyCached)

        case MD3_IDENT:
            loaded = R_LoadMD3(mod!, lod, buf!, String(filename), &bAlreadyCached)

        default:
            Com_Printf(S_COLOR_YELLOW + "RE_RegisterModel: unknown fileid for %s\n", String(filename))
            failed = true
        }
        if failed {
            break
        }

        if !bAlreadyCached { // important to check!!
            FS_FreeFile(buf!)
        }

        if !loaded {
            if lod == 0 {
                failed = true
                break
            } else {
                break
            }
        } else {
            mod!.numLods += 1
            numLoaded += 1
            // if we have a valid model and are biased
            // so that we won't see any higher detail ones,
            // stop loading them
            if lod <= r_lodbias!.integer {
                break
            }
        }
        lod -= 1
    }

    if !failed && numLoaded != 0 {
        // duplicate into higher lod spots that weren't
        // loaded, in case the user changes r_lodbias on the fly
        lod -= 1
        while lod >= 0 {
            mod!.numLods += 1
            mod!.md3[lod] = mod!.md3[lod + 1]
            lod -= 1
        }

        /*
        Ghoul2 Insert Start
        */

        RE_InsertModelIntoHash(name, mod!)
        return mod!.index
        /*
        Ghoul2 Insert End
        */
    }

    // fail:
    // we still keep the model_t around, so if the model name is asked for
    // again, we won't bother scanning the filesystem
    mod!.type = MOD_BAD
    RE_InsertModelIntoHash(name, mod!)
    return 0
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1407
public func RE_RegisterModel(_ name: String) -> JKAShared.qhandle_t {
    let bWhatitwas = gbInsideRegisterModel
    gbInsideRegisterModel = true // !!!!!!!!!!!!!!

    let q = RE_RegisterModel_Actual(name)

    gbInsideRegisterModel = bWhatitwas

    return q
}

/**
```
=================
R_LoadMD3
=================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1427
private func R_LoadMD3(_ mod: Model, _ lod: Int32, _ buffer: Slots<JKAShared.byte>, _ mod_name: String, _ bAlreadyCached: inout Bool) -> Bool {
    var i: Int32
    var j: Int32
    let pinmodel: Md3Header
    var surf: Md3Surface
    let version: Int32
    let size: Int32

    pinmodel = Md3Header(buffer.base)
    //
    // read some fields from the binary, but only LittleLong() them when we know this wasn't an already-cached model...
    //
    version = pinmodel.version
    size = pinmodel.ofsEnd

    // Raven's two LittleLong calls under `if (!bAlreadyCached)` have no line, because LittleLong of the WinDed arm is its argument.

    if version != MD3_VERSION {
        Com_Printf(S_COLOR_YELLOW + "R_LoadMD3: %s has wrong version (%i should be %i)\n",
                   mod_name, version, MD3_VERSION)
        return false
    }

    mod.type = MOD_MESH
    mod.dataSize += size

    var bAlreadyFound = false
    mod.md3[lod] = Md3Header(/*Hunk_Alloc( size );*/ RE_RegisterModels_Malloc(size, buffer, mod_name, &bAlreadyFound, TAG_MODEL_MD3).base)

    assert(bAlreadyCached == bAlreadyFound)	// I should probably eliminate 'bAlreadyFound', but wtf?

    if !bAlreadyFound {
        // horrible new hackery, if !bAlreadyFound then we've just done a tag-morph, so we need to set the
        //	bool reference passed into this function to true, to tell the caller NOT to do an FS_Freefile since
        //	we've hijacked that memory block...
        //
        // Aaaargh. Kill me now...
        //
        bAlreadyCached = true
        assert(mod.md3[lod] == Md3Header(buffer.base))
//		memcpy( mod->md3[lod], buffer, size );	// and don't do this now, since it's the same thing

        // Raven's nine LL calls have no line, because LittleLong of the WinDed arm is its argument.
    }

    if mod.md3[lod]!.numFrames < 1 {
        Com_Printf(S_COLOR_YELLOW + "R_LoadMD3: %s has no frames\n", mod_name)
        return false
    }

    if bAlreadyFound {
        return true	// All done. Stop, go no further, do not pass Go...
    }

    // Raven's swaps of the frames and the tags stand under `#ifndef _M_IX86`, so the WinDed build has none.

    // swap all the surfaces
    surf = Md3Surface(mod.md3[lod]!, byteOffset: mod.md3[lod]!.ofsSurfaces)
    i = 0
    while i < mod.md3[lod]!.numSurfaces {
        // Raven's LL calls of the counts and offsets have no line, because LittleLong of the WinDed arm is its argument.

        if surf.numVerts > SHADER_MAX_VERTEXES {
            Com_Error(ERR_DROP, "R_LoadMD3: %s has more than %i verts on a surface (%i)",
                      mod_name, SHADER_MAX_VERTEXES, surf.numVerts)
        }
        if surf.numTriangles * 3 > SHADER_MAX_INDEXES {
            Com_Error(ERR_DROP, "R_LoadMD3: %s has more than %i triangles on a surface (%i)",
                      mod_name, SHADER_MAX_INDEXES / 3, surf.numTriangles)
        }

        // change to surface identifier
        surf.ident = SF_MD3

        // lowercase the surface name so skin compares are faster
        Q_strlwr(&surf.nameBuffer)

        // strip off a trailing _1 or _2
        // this is a crutch for q3data being a mess
        j = strlen(surf.name)
        if j > 2 && surf.nameBuffer[j - 2] == Int32(ascii: "_") {
            surf.nameBuffer[j - 2] = 0
        }

        // Raven's shader registration stands under `#ifndef DEDICATED`, and his swaps of the triangles, the ST, and the normals under `#ifndef _M_IX86`.

        // find the next surface
        surf = Md3Surface(surf, byteOffset: surf.ofsEnd)
        i += 1
    }

    return true
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1655
public func R_SVModelInit() {
    R_ModelInit()
}

/**
```
===============
R_ModelInit
===============
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1665
public func R_ModelInit() {
    var mod: Model?

    if CachedModels == nil {
        CachedModels = [:]
    }

    // leave a space for NULL model
    tr.numModels = 0
    mhHashTable.fill(nil)

    mod = R_AllocModel()
    mod!.type = MOD_BAD
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1683
public func R_HunkClearCrap() {
    //get your dirty sticky assets off me, you damn dirty hunk!
    KillTheShaderHashTable()
    tr.numModels = 0
    mhHashTable.fill(nil)
    tr.numShaders = 0
    tr.numSkins = 0
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1692
public func R_ModelFree() {
    if CachedModels != nil {
        RE_RegisterModels_DeleteAll()
        CachedModels = nil
    }
}

/**
```
================
R_Modellist_f
================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1708
public func R_Modellist_f() {
    var i: Int32
    var j: Int32
    var mod: Model
    var total: Int32
    var lods: Int32

    total = 0
    i = 1
    while i < tr.numModels {
        mod = tr.models[i]!
        lods = 1
        j = 1
        while j < MD3_MAX_LODS {
            if mod.md3[j] != nil && mod.md3[j] != mod.md3[j - 1] {
                lods += 1
            }
            j += 1
        }
        Com_Printf("%8i : (%i) %s\n", mod.dataSize, lods, mod.name)
        total += mod.dataSize
        i += 1
    }
    Com_Printf("%8i : Total models\n", total)
}

/**
```
================
R_GetTag
================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1744
private func R_GetTag(_ mod: JKAMP.Md3Header, _ frame: Int32, _ tagName: String) -> Md3Tag? {
    var tag: Md3Tag
    var i: Int32
    var frame = frame

    if frame >= mod.numFrames {
        // it is possible to have a bad frame while changing models, so don't error
        frame = mod.numFrames - 1
    }

    // Raven steps the `md3Tag_t *` by `frame * mod->numTags` records, so the byte offset adds that many record sizes.
    tag = Md3Tag(mod, byteOffset: mod.ofsTags + frame * mod.numTags * Int32(Md3Tag.byteCount))
    i = 0
    while i < mod.numTags {
        if strcmp(tag.name, tagName) == 0 {
            return tag // found it
        }
        i += 1
        // Raven's `tag++` steps one record.
        tag = Md3Tag(tag, byteOffset: Md3Tag.byteCount)
    }

    return nil
}

/**
```
================
R_LerpTag
================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1768
public func R_LerpTag(_ tag: JKAShared.Orientation, _ handle: JKAShared.qhandle_t, _ startFrame: Int32, _ endFrame: Int32, _ frac: Float, _ tagName: String) -> Int32 {
    // GetRefAPI stores it only in its `#ifndef DEDICATED` arm at tr_init.cpp:1488, so no caller builds in the dedicated host, and it is dead.
    let start: Md3Tag?, end: Md3Tag?
    var i: Int32
    let frontLerp: Float, backLerp: Float
    let model: Model?

    model = R_GetModelByHandle(handle)
    if model!.md3[0] == nil {
        AxisClear(tag.axis)
        tag.origin = vec3_t()
        return 0
    }

    start = R_GetTag(model!.md3[0]!, startFrame, tagName)
    end = R_GetTag(model!.md3[0]!, endFrame, tagName)
    if start == nil || end == nil {
        AxisClear(tag.axis)
        tag.origin = vec3_t()
        return 0
    }

    frontLerp = frac
    backLerp = 1.0 - frac

    i = 0
    while i < 3 {
        tag.origin[i] = start!.origin[i] * backLerp + end!.origin[i] * frontLerp
        tag.axis[0][i] = start!.axis[0][i] * backLerp + end!.axis[0][i] * frontLerp
        tag.axis[1][i] = start!.axis[1][i] * backLerp + end!.axis[1][i] * frontLerp
        tag.axis[2][i] = start!.axis[2][i] * backLerp + end!.axis[2][i] * frontLerp
        i += 1
    }
    _ = VectorNormalize(&tag.axis[0])
    _ = VectorNormalize(&tag.axis[1])
    _ = VectorNormalize(&tag.axis[2])
    return 1
}

/**
```
====================
R_ModelBounds
====================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1811
public func R_ModelBounds(_ handle: JKAShared.qhandle_t, _ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t) {
    var model: Model
    var header: Md3Header
    var frame: Md3Frame

    model = R_GetModelByHandle(handle)!

    if model.bmodel != nil {
        mins = model.bmodel!.bounds[0]
        maxs = model.bmodel!.bounds[1]
        return
    }

    if model.md3[0] == nil {
        mins = vec3_t()
        maxs = vec3_t()
        return
    }

    header = model.md3[0]!

    frame = Md3Frame(header, byteOffset: header.ofsFrames)

    mins = frame.bounds[0]
    maxs = frame.bounds[1]
}
