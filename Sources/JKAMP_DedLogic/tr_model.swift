import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_model.cpp:35
private let FILE_HASH_SIZE = 1024 as Int32

/// Source: oracle/codemp/renderer/tr_model.cpp:36
// TODO: Port global mhHashTable
// Raven wrote: static modelHash_t *mhHashTable[FILE_HASH_SIZE]
// No table row for `modelHash_t *[1024]`.

/// Source: oracle/codemp/renderer/tr_model.cpp:68
// TODO: Port global CachedModels
// Raven wrote: CachedModels_t *CachedModels = NULL
// No table row for `CachedModels_t *`.

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
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
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
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
    // TODO: Port RE_RegisterModels_GetDiskFile
    portMissing("RE_RegisterModels_GetDiskFile", source: "oracle/codemp/renderer/tr_model.cpp:125")
}

/// Source: oracle/codemp/renderer/tr_model.cpp:179
// TODO: Port signature
// Raven wrote: void *RE_RegisterModels_Malloc(int iSize, void *pvDiskBufferIfJustLoaded, const char *psModelFileName, qboolean *pqbAlreadyFound, memtag_t eTag)
// No table row for the return `void *`.
func RE_RegisterModels_Malloc() -> Never {
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
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
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
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
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
    // TODO: Port RE_RegisterModels_LevelLoadEnd
    portMissing("RE_RegisterModels_LevelLoadEnd", source: "oracle/codemp/renderer/tr_model.cpp:337")
}

// scan through all loaded models and see if their PAK checksums are still valid with the current pure PAK lists,
//	dump any that aren't (so people can't cheat by using models with huge spikes that show through walls etc)
//
// (avoid using ri.xxxx stuff here in case running on dedicated)
//
/// Source: oracle/codemp/renderer/tr_model.cpp:418
private func RE_RegisterModels_DumpNonPure() {
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
    // TODO: Port RE_RegisterModels_DumpNonPure
    portMissing("RE_RegisterModels_DumpNonPure", source: "oracle/codemp/renderer/tr_model.cpp:418")
}

/// Source: oracle/codemp/renderer/tr_model.cpp:467
func RE_RegisterModels_Info_f() {
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
    // TODO: Port RE_RegisterModels_Info_f
    portMissing("RE_RegisterModels_Info_f", source: "oracle/codemp/renderer/tr_model.cpp:467")
}

// (don't use ri.xxx functions since the renderer may not be running here)...
//
/// Source: oracle/codemp/renderer/tr_model.cpp:496
private func RE_RegisterModels_DeleteAll() {
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
    // TODO: Port RE_RegisterModels_DeleteAll
    portMissing("RE_RegisterModels_DeleteAll", source: "oracle/codemp/renderer/tr_model.cpp:496")
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

    // Port-note: Row TR1. `tr` is a `trGlobals_t` of tr_local.h, which has no C header and no view in the host target.
    // Raven wrote: tr.numBSPModels = 0
    portMissing("RE_RegisterMedia_LevelLoadBegin", source: "oracle/codemp/renderer/tr_model.cpp:541")

    // at some stage I'll probably want to put some special logic here, like not incrementing the level number
    //	when going into a map like "brig" or something, so returning to the previous level doesn't require an
    //	asset reload etc, but for now...
    //
    // only bump level number if we're not on the same level.
    //	Note that this will hide uncached models, which is perhaps a bad thing?...
    //
    // Port-note: Row TR6. The static local `char sPrevMapName[MAX_QPATH]` keeps its text across calls and has no storage row.
    // Raven wrote: static char sPrevMapName[MAX_QPATH]={0}; if (Q_stricmp( psMapName,sPrevMapName )) { Q_strncpyz( sPrevMapName, psMapName, sizeof(sPrevMapName) ); giRegisterMedia_CurrentLevel++; }
    portMissing("RE_RegisterMedia_LevelLoadBegin", source: "oracle/codemp/renderer/tr_model.cpp:560")
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
// TODO: Port signature
// Raven wrote: model_t *R_GetModelByHandle( qhandle_t index )
// No table row for the return `model_t *`.
func R_GetModelByHandle() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_GetModelByHandle
    portMissing("R_GetModelByHandle", source: "oracle/codemp/renderer/tr_model.cpp:593")
}

/**
```
** R_AllocModel
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:611
// TODO: Port signature
// Raven wrote: model_t *R_AllocModel( void )
// No table row for the return `model_t *`.
func R_AllocModel() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_AllocModel
    portMissing("R_AllocModel", source: "oracle/codemp/renderer/tr_model.cpp:611")
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
// TODO: Port signature
// Raven wrote: void RE_InsertModelIntoHash(const char *name, model_t *mod)
// No table row for `model_t * mod`.
func RE_InsertModelIntoHash() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_InsertModelIntoHash
    portMissing("RE_InsertModelIntoHash", source: "oracle/codemp/renderer/tr_model.cpp:653")
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
// No table row for `model_t * mod`.
func ServerLoadMDXA() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
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
// No table row for `model_t * mod`.
func ServerLoadMDXM() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_RegisterServerModel
    portMissing("RE_RegisterServerModel", source: "oracle/codemp/renderer/tr_model.cpp:1003")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_RegisterModel_Actual
    portMissing("RE_RegisterModel_Actual", source: "oracle/codemp/renderer/tr_model.cpp:1169")
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
// No table row for `model_t * mod`.
private func R_LoadMD3() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_ModelInit
    portMissing("R_ModelInit", source: "oracle/codemp/renderer/tr_model.cpp:1665")
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1683
func R_HunkClearCrap() {
    //get your dirty sticky assets off me, you damn dirty hunk!
    KillTheShaderHashTable()
    // Port-note: Row TR1. `tr` is a `trGlobals_t` of tr_local.h, which has no C header and no view in the host target, and `mhHashTable` has no storage row.
    // Raven wrote: tr.numModels = 0; memset(mhHashTable, 0, sizeof(mhHashTable)); tr.numShaders = 0; tr.numSkins = 0;
    portMissing("R_HunkClearCrap", source: "oracle/codemp/renderer/tr_model.cpp:1686")
}

/// Source: oracle/codemp/renderer/tr_model.cpp:1692
func R_ModelFree() {
    // Port-note: Row TR2. `CachedModels` is a `map<sstring_t, CachedEndianedModelBinary_t>` of the C++ track, rule 17, so the stem gives it no storage.
    // TODO: Port R_ModelFree
    portMissing("R_ModelFree", source: "oracle/codemp/renderer/tr_model.cpp:1692")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_Modellist_f
    portMissing("R_Modellist_f", source: "oracle/codemp/renderer/tr_model.cpp:1708")
}

/**
```
================
R_GetTag
================
```
*/
/// Source: oracle/codemp/renderer/tr_model.cpp:1744
// TODO: Port signature
// Raven wrote: static md3Tag_t *R_GetTag( md3Header_t *mod, int frame, const char *tagName )
// No table row for `md3Header_t * mod`.
private func R_GetTag() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_ModelBounds
    portMissing("R_ModelBounds", source: "oracle/codemp/renderer/tr_model.cpp:1811")
}
