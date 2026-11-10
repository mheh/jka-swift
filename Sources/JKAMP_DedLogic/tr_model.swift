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
var CachedModels: [String: CachedEndianedModelBinary_t]? {
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
var gbInsideRegisterModel: Bool {
    get { world.variables.gbInsideRegisterModel }
    set { world.variables.gbInsideRegisterModel = newValue }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:70
func RE_RegisterModels_StoreShaderRequest(_ psModelFileName: String, _ psShaderName: String, _ piShaderIndexPoke: inout Int32) {
    // Port-note: Row TR20. Raven subtracts the disk image address from `psShaderName` and `piShaderIndexPoke`, and a `String` and an `inout Int32` carry no address.
    // TODO: Port RE_RegisterModels_StoreShaderRequest
    portMissing("RE_RegisterModels_StoreShaderRequest", source: "oracle/codemp/renderer/tr_model.cpp:70")
}

// returns qtrue if loaded, and sets the supplied qbool to true if it was from cache (instead of disk)
//   (which we need to know to avoid LittleLong()ing everything again (well, the Mac needs to know anyway)...
//
// don't use ri.xxx functions in case running on dedicated...
//
/// Source: oracle/codemp/renderer/tr_model.cpp:125
func RE_RegisterModels_GetDiskFile(_ psModelFileName: String, _ ppvBuffer: inout OpaquePointer?, _ pqbAlreadyCached: inout Bool) -> Bool {
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
            ppvBuffer = OpaquePointer(pvFakeGLAFile.base)
            pqbAlreadyCached = false // faking it like this should mean that it works fine on the Mac as well
            return true
        }

        FS_ReadFile(String(sModelName), &ppvBuffer)
        pqbAlreadyCached = false
        let bSuccess = ppvBuffer != nil

        if bSuccess {
            Com_DPrintf("RE_RegisterModels_GetDiskFile(): Disk-loading \"%s\"\n", psModelFileName)
        }

        return bSuccess
    } else {
        ppvBuffer = OpaquePointer(ModelBin.pModelDiskImage!.base)
        pqbAlreadyCached = true
        return true
    }
}

/// Source: oracle/codemp/renderer/tr_model.cpp:179
// TODO: Port signature
// Raven wrote: void *RE_RegisterModels_Malloc(int iSize, void *pvDiskBufferIfJustLoaded, const char *psModelFileName, qboolean *pqbAlreadyFound, memtag_t eTag)
// No table row for the return `void *`.
func RE_RegisterModels_Malloc() -> Never {
    // TODO: Port RE_RegisterModels_Malloc
    portMissing("RE_RegisterModels_Malloc", source: "oracle/codemp/renderer/tr_model.cpp:179")
}

// Unfortunately the dedicated server also hates shader loading. So we need an alternate of this func.
//
/// Source: oracle/codemp/renderer/tr_model.cpp:253
// TODO: Port signature
// Raven wrote: void *RE_RegisterServerModels_Malloc(int iSize, void *pvDiskBufferIfJustLoaded, const char *psModelFileName, qboolean *pqbAlreadyFound, memtag_t eTag)
// No table row for the return `void *`.
func RE_RegisterServerModels_Malloc() -> Never {
    // TODO: Port RE_RegisterServerModels_Malloc
    portMissing("RE_RegisterServerModels_Malloc", source: "oracle/codemp/renderer/tr_model.cpp:253")
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
func RE_RegisterModels_LevelLoadEnd(_ bDeleteEverythingNotUsedThisLevel: Bool = false) -> Bool {
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
func RE_RegisterModels_Info_f() {
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
func RE_RegisterMedia_LevelLoadBegin(_ psMapName: String, _ eForceReload: JKAMP.ForceReload_e) {
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
func RE_RegisterMedia_GetLevel() -> Int32 {
    return giRegisterMedia_CurrentLevel
}

/// Source: oracle/codemp/renderer/tr_model.cpp:577
func RE_RegisterMedia_LevelLoadEnd() {
    RE_RegisterModels_LevelLoadEnd(false)
}

/**
```
** R_GetModelByHandle
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:593
func R_GetModelByHandle(_ index: JKAShared.qhandle_t) -> Model? {
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
func R_AllocModel() -> Model? {
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
func RE_InsertModelIntoHash(_ name: String, _ mod: Model) {
    var hash: Int32
    var mh: ModelHash

    hash = Int32(generateHashValue(name, FILE_HASH_SIZE))

    // insert this file into the hash table so we can look it up faster later
    mh = ModelHash(Hunk_Alloc(Int32(ModelHash.byteCount), h_low))

    mh.next = mhHashTable[hash]
    // Port-note: Row TR12. The view's own `handle` hides the `handle` field of `modelHash_t`, and FIELD_NAMES has no row for it.
    // Raven wrote: mh->handle = mod->index;
    portMissing("RE_InsertModelIntoHash", source: "oracle/codemp/renderer/tr_model.cpp:664")
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
// TODO: Port signature
// Raven wrote: qboolean ServerLoadMDXA( model_t *mod, void *buffer, const char *mod_name, qboolean &bAlreadyCached )
// No table row for `qboolean & bAlreadyCached`.
func ServerLoadMDXA() -> Never {
    // TODO: Port ServerLoadMDXA
    portMissing("ServerLoadMDXA", source: "oracle/codemp/renderer/tr_model.cpp:683")
}

/**
```
=================
ServerLoadMDXM - load a Ghoul 2 Mesh file
=================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:799
// TODO: Port signature
// Raven wrote: qboolean ServerLoadMDXM( model_t *mod, void *buffer, const char *mod_name, qboolean &bAlreadyCached )
// No table row for `qboolean & bAlreadyCached`.
func ServerLoadMDXM() -> Never {
    // TODO: Port ServerLoadMDXM
    portMissing("ServerLoadMDXM", source: "oracle/codemp/renderer/tr_model.cpp:799")
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
func RE_RegisterServerModel(_ name: String) -> JKAShared.qhandle_t {
    var mod: Model?
    var buf: OpaquePointer? = nil
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
            // Port-note: Row TR12. The view's own `handle` hides the `handle` field of `modelHash_t`, and FIELD_NAMES has no row for it.
            // Raven wrote: return mh->handle;
            portMissing("RE_RegisterServerModel", source: "oracle/codemp/renderer/tr_model.cpp:1040")
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
        // Port-note: Row TR13. `buf` is the `OpaquePointer` of RE_RegisterModels_GetDiskFile, so the body cannot read the word at its base.
        // Port-note: ServerLoadMDXA and ServerLoadMDXM keep their `TODO: Port signature` markers, so the switch has no call form.
        // Raven wrote: ident = *(unsigned *)buf; if (!bAlreadyCached) ident = LittleLong(ident); switch (ident) { case MDXA_IDENT: loaded = ServerLoadMDXA( mod, buf, filename, bAlreadyCached ); break; case MDXM_IDENT: loaded = ServerLoadMDXM( mod, buf, filename, bAlreadyCached ); break; default: goto fail; }
        portMissing("RE_RegisterServerModel", source: "oracle/codemp/renderer/tr_model.cpp:1094")

        if !bAlreadyCached { // important to check!!
            FS_FreeFile(buf)
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
    var buf: OpaquePointer? = nil
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
            // Port-note: Row TR12. The view's own `handle` hides the `handle` field of `modelHash_t`, and FIELD_NAMES has no row for it.
            // Raven wrote: return mh->handle;
            portMissing("RE_RegisterModel_Actual", source: "oracle/codemp/renderer/tr_model.cpp:1213")
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
                // Port-note: Row TR12. The view's own `handle` hides the `handle` field of `modelHash_t`, and FIELD_NAMES has no row for it.
                // Raven wrote: return mh->handle;
                portMissing("RE_RegisterModel_Actual", source: "oracle/codemp/renderer/tr_model.cpp:1241")
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
        // Port-note: Row TR13. `buf` is the `OpaquePointer` of RE_RegisterModels_GetDiskFile, so the body cannot read the word at its base.
        // Port-note: R_LoadMD3 keeps its `TODO: Port signature` marker, so the switch has no call form for MD3_IDENT.
        // Raven wrote: ident = *(unsigned *)buf; if (!bAlreadyCached) ident = LittleLong(ident); switch (ident) { case MDXA_IDENT: loaded = R_LoadMDXA( mod, buf, filename, bAlreadyCached ); break; case MDXM_IDENT: loaded = R_LoadMDXM( mod, buf, filename, bAlreadyCached ); break; case MD3_IDENT: loaded = R_LoadMD3( mod, lod, buf, filename, bAlreadyCached ); break; default: Com_Printf (S_COLOR_YELLOW"RE_RegisterModel: unknown fileid for %s\n", filename); goto fail; }
        portMissing("RE_RegisterModel_Actual", source: "oracle/codemp/renderer/tr_model.cpp:1313")

        if !bAlreadyCached { // important to check!!
            FS_FreeFile(buf)
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
func RE_RegisterModel(_ name: String) -> JKAShared.qhandle_t {
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
// TODO: Port signature
// Raven wrote: static qboolean R_LoadMD3 (model_t *mod, int lod, void *buffer, const char *mod_name, qboolean &bAlreadyCached )
// No table row for `qboolean & bAlreadyCached`.
private func R_LoadMD3() -> Never {
    // TODO: Port R_LoadMD3
    portMissing("R_LoadMD3", source: "oracle/codemp/renderer/tr_model.cpp:1427")
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1655
func R_SVModelInit() {
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
func R_ModelInit() {
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
func R_HunkClearCrap() {
    //get your dirty sticky assets off me, you damn dirty hunk!
    KillTheShaderHashTable()
    tr.numModels = 0
    mhHashTable.fill(nil)
    tr.numShaders = 0
    tr.numSkins = 0
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1692
func R_ModelFree() {
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
func R_Modellist_f() {
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
    // Port-note: Row TR14. The tags stand at the byte offset `ofsTags` from the header, and a view gives no record at a byte offset of another record.
    // TODO: Port R_GetTag
    portMissing("R_GetTag", source: "oracle/codemp/renderer/tr_model.cpp:1744")
}

/**
```
================
R_LerpTag
================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1768
// TODO: Port signature
// Raven wrote: int R_LerpTag( orientation_t *tag, qhandle_t handle, int startFrame, int endFrame, float frac, const char *tagName )
// No table row for `orientation_t * tag`.
func R_LerpTag() -> Never {
    // TODO: Port R_LerpTag
    portMissing("R_LerpTag", source: "oracle/codemp/renderer/tr_model.cpp:1768")
}

/**
```
====================
R_ModelBounds
====================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1811
func R_ModelBounds(_ handle: JKAShared.qhandle_t, _ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t) {
    var model: Model
    var header: Md3Header

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

    // Port-note: Row TR14. `md3Frame_t` stands at the byte offset `ofsFrames` from the header, and a view gives no record at a byte offset of another record.
    // Raven wrote: frame = (md3Frame_t *)( (byte *)header + header->ofsFrames ); VectorCopy( frame->bounds[0], mins ); VectorCopy( frame->bounds[1], maxs );
    portMissing("R_ModelBounds", source: "oracle/codemp/renderer/tr_model.cpp:1832")
}
