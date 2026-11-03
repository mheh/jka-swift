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
// Raven wrote: CHash<CCMShaderText> shaderTextTable
let shaderTextTable: Int32 = 0

/// Source: oracle/codemp/qcommon/cm_shader.cpp:30
// Raven wrote: CHash<CCMShader> cmShaderTable
let cmShaderTable: Int32 = 0

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
    // TODO: Port CM_CreateShaderTextHash
    portMissing("CM_CreateShaderTextHash", source: "oracle/codemp/qcommon/cm_shader.cpp:37")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:71
func CM_LoadShaderFiles() {
    // TODO: Port CM_LoadShaderFiles
    portMissing("CM_LoadShaderFiles", source: "oracle/codemp/qcommon/cm_shader.cpp:71")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:158
func CM_GetShaderText(_ key: String) -> String? {
    // TODO: Port CM_GetShaderText
    portMissing("CM_GetShaderText", source: "oracle/codemp/qcommon/cm_shader.cpp:158")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:176
func CM_FreeShaderText() {
    // TODO: Port CM_FreeShaderText
    portMissing("CM_FreeShaderText", source: "oracle/codemp/qcommon/cm_shader.cpp:176")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:195
func CM_LoadShaderText(_ forceReload: Bool) {
    // TODO: Port CM_LoadShaderText
    portMissing("CM_LoadShaderText", source: "oracle/codemp/qcommon/cm_shader.cpp:195")
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
    // TODO: Port CM_SetupShaderProperties
    portMissing("CM_SetupShaderProperties", source: "oracle/codemp/qcommon/cm_shader.cpp:466")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:489
func CM_ShutdownShaderProperties() {
    // TODO: Port CM_ShutdownShaderProperties
    portMissing("CM_ShutdownShaderProperties", source: "oracle/codemp/qcommon/cm_shader.cpp:489")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:498
// TODO: Port signature
// Raven wrote: CCMShader *CM_GetShaderInfo( const char *name )
// No table row for the return `CCMShader *`.
func CM_GetShaderInfo(_ name: String) -> Never {
    // TODO: Port CM_GetShaderInfo
    portMissing("CM_GetShaderInfo", source: "oracle/codemp/qcommon/cm_shader.cpp:498")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:526
// TODO: Port signature
// Raven wrote: CCMShader *CM_GetShaderInfo( int shaderNum )
// No table row for the return `CCMShader *`.
func CM_GetShaderInfo(_ shaderNum: Int32) -> Never {
    // TODO: Port CM_GetShaderInfo
    portMissing("CM_GetShaderInfo", source: "oracle/codemp/qcommon/cm_shader.cpp:526")
}
