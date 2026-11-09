import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_shader.cpp:28
var shaderText: String {
    get { world.variables.shaderText }
    set { world.variables.shaderText = newValue }
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:29
// AI: Raven wrote `CHash<CCMShaderText> shaderTextTable`. The forward reaches the `Dictionary` of `EngineWorld`, the name to the byte offset of the text.
var shaderTextTable: [String: Int32] {
    get { world.shaderTextTable }
    set { world.shaderTextTable = newValue }
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:30
// AI: Raven wrote `CHash<CCMShader> cmShaderTable`. The forward reaches the `Dictionary` of `EngineWorld`, the name to the offset of the record.
var cmShaderTable: [String: Int32] {
    get { world.cmShaderTable }
    set { world.cmShaderTable = newValue }
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:69
let MAX_SHADER_FILES = 1024 as Int32

/// Source: oracle/codemp/qcommon/cm_shader.cpp:226
// TODO: Port global svInfoParms
// Raven wrote: infoParm_t svInfoParms[]
// No view for `infoParm_t`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/qcommon/cm_shader.cpp:285
/// Raven's data table, a hand property of `EngineWorld`.
var svMaterialNames: [String] {
    get { world.svMaterialNames }
    set { world.svMaterialNames = newValue }
}

/**
```
====================
CM_CreateShaderTextHash
=====================
```
*/
/// Source: oracle/codemp/qcommon/cm_shader.cpp:37
func CM_CreateShaderTextHash() {
    var p: TextCursor
    var hasNewLines: Bool = false
    var token: String

    p = TextCursor(CharBuf(shaderText))
    // look for label
    while !p.isNull {
        p = SkipWhitespace(p, &hasNewLines)
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            break
        }
        // AI: Raven inserts a new `CCMShaderText` of the name and the text pointer. The table stores the byte offset of the cursor under the name.
        shaderTextTable[token] = p.offset!

        SkipBracedSection(&p)
    }
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:71
// Port-note: FS_ListFiles of files_pc carries a signature marker for its `char **` return, and `shaderText` is a `String` with no home for the `Z_Malloc` block.
func CM_LoadShaderFiles() {
    // TODO: Port CM_LoadShaderFiles
    portMissing("CM_LoadShaderFiles", source: "oracle/codemp/qcommon/cm_shader.cpp:71")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:158
func CM_GetShaderText(_ key: String) -> String? {
    let st = shaderTextTable[key]
    if st != nil {
        // AI: Raven returns the `GetData` pointer into `shaderText`. The function returns the text from that byte offset.
        return String(CharBuf(shaderText)[st!...])
    }
    return nil
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:176
func CM_FreeShaderText() {
    shaderTextTable.removeAll()
    // AI: Raven tests the `char *shaderText` for NULL. The empty text is the NULL of the `String` variable, because a loaded text holds at least one newline.
    if !shaderText.isEmpty {
        // Port-note: `shaderText` is a `String`, so the `Z_Malloc` block of CM_LoadShaderFiles has no pointer to free.
        // Raven wrote: Z_Free(shaderText);
        portMissing("CM_FreeShaderText", source: "oracle/codemp/qcommon/cm_shader.cpp:176")
        shaderText = ""
    }
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:195
func CM_LoadShaderText(_ forceReload: Bool) {
    if forceReload {
        CM_FreeShaderText()
    }
    // AI: Raven tests the `char *shaderText` for NULL. The empty text is the NULL of the `String` variable, because a loaded text holds at least one newline.
    if !shaderText.isEmpty {
        return
    }
    //	Com_Printf("Loading shader text .....\n");
    CM_LoadShaderFiles()
    CM_CreateShaderTextHash()

    //Com_Printf("..... %d shader definitions loaded\n", shaderTextTable.count());
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:261
// TODO: Port signature
// Raven wrote: void SV_ParseSurfaceParm( CCMShader * shader, const char **text )
// No table row for `CCMShader * shader`.
func SV_ParseSurfaceParm() -> Never {
    // TODO: Port SV_ParseSurfaceParm
    portMissing("SV_ParseSurfaceParm", source: "oracle/codemp/qcommon/cm_shader.cpp:261")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:290
// TODO: Port signature
// Raven wrote: void SV_ParseMaterial( CCMShader *shader, const char **text )
// No table row for `CCMShader * shader`.
func SV_ParseMaterial() -> Never {
    // TODO: Port SV_ParseMaterial
    portMissing("SV_ParseMaterial", source: "oracle/codemp/qcommon/cm_shader.cpp:290")
}

/**
```
===============
ParseVector
===============
```
*/
/// Source: oracle/codemp/qcommon/cm_shader.cpp:316
// TODO: Port signature
// Raven wrote: static qboolean CM_ParseVector( CCMShader *shader, const char **text, int count, float *v )
// No table row for `CCMShader * shader`.
private func CM_ParseVector() -> Never {
    // TODO: Port CM_ParseVector
    portMissing("CM_ParseVector", source: "oracle/codemp/qcommon/cm_shader.cpp:316")
}

/**
```
=================
CM_ParseShader

The current text pointer is at the explicit text definition of the
shader.  Parse it into the global shader variable.

This extracts all the info from the shader required for physics and collision
It is designed to *NOT* load any image files and not require any of the renderer to
be initialised.
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_shader.cpp:361
// TODO: Port signature
// Raven wrote: static void CM_ParseShader( CCMShader *shader, const char **text )
// No table row for `CCMShader * shader`.
private func CM_ParseShader() -> Never {
    // TODO: Port CM_ParseShader
    portMissing("CM_ParseShader", source: "oracle/codemp/qcommon/cm_shader.cpp:361")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:466
func CM_SetupShaderProperties() {
    var i: Int32

    // Add all basic shaders to the cmShaderTable
    i = 0
    while i < cmg.numShaders {
        // Port-note: CM_GetShaderInfo carries a signature marker, because the table has no row for the return `CCMShader *`.
        // Raven wrote: cmShaderTable.insert(CM_GetShaderInfo(i));
        portMissing("CM_SetupShaderProperties", source: "oracle/codemp/qcommon/cm_shader.cpp:466")
        i += 1
    }
    // Go through and parse evaluate shader names to shadernums
    i = 0
    while i < cmg.numShaders {
        // Port-note: CM_GetShaderInfo and CM_ParseShader carry signature markers, because the table has no row for `CCMShader *`.
        // Raven wrote: shader = CM_GetShaderInfo(i); def = CM_GetShaderText(shader->shader); if(def) { CM_ParseShader(shader, &def); }
        portMissing("CM_SetupShaderProperties", source: "oracle/codemp/qcommon/cm_shader.cpp:466")
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:489
func CM_ShutdownShaderProperties() {
    if cmShaderTable.count != 0 {
        //		Com_Printf("Shutting down cmShaderTable .....\n");
        cmShaderTable.removeAll()
    }
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:498
// TODO: Port signature
// Raven wrote: CCMShader *CM_GetShaderInfo( const char *name )
// No table row for the return `CCMShader *`.
func CM_GetShaderInfo(_ name: String) -> Never {
    // Port-note: The parameter tells the two C++ overloads apart, so the gate keeps this stub as a hand function.
    // TODO: Port CM_GetShaderInfo
    portMissing("CM_GetShaderInfo", source: "oracle/codemp/qcommon/cm_shader.cpp:498")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:526
// TODO: Port signature
// Raven wrote: CCMShader *CM_GetShaderInfo( int shaderNum )
// No table row for the return `CCMShader *`.
func CM_GetShaderInfo(_ shaderNum: Int32) -> Never {
    // Port-note: The parameter tells the two C++ overloads apart, so the gate keeps this stub as a hand function.
    // TODO: Port CM_GetShaderInfo
    portMissing("CM_GetShaderInfo", source: "oracle/codemp/qcommon/cm_shader.cpp:526")
}
