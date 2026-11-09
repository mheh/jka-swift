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
func SV_ParseSurfaceParm(_ shader: CmShader, _ text: inout JKAShared.TextCursor) {
    let token: String
    // Port-note: A sizeof of `infoParm_t[26]` the draft cannot size.
    // Raven wrote: int numsvInfoParms = sizeof(svInfoParms) / sizeof(svInfoParms[0]);
    portMissing("SV_ParseSurfaceParm", source: "oracle/codemp/qcommon/cm_shader.cpp:261")
    var i: Int32

    token = COM_ParseExt(&text, false)
    // Port-note: A read of `numsvInfoParms`, a local the draft left as a hole.
    // Raven wrote: for ( i = 0 ; i < numsvInfoParms ; i++ ) { if ( !Q_stricmp( token, svInfoParms[i].name ) ) { shader->surfaceFlags |= svInfoParms[i].surfaceFlags; shader->contentFlags |= svInfoParms[i].contents; shader->contentFlags &= svInfoParms[i].clearSolid; break; } }
    portMissing("SV_ParseSurfaceParm", source: "oracle/codemp/qcommon/cm_shader.cpp:261")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:290
func SV_ParseMaterial(_ shader: CmShader, _ text: inout JKAShared.TextCursor) {
    let token: String
    var i: Int32

    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing material in shader '%s'\n", shader.shader)
        return
    }
    i = 0
    while i < MATERIAL_LAST {
        if Q_stricmp(token, svMaterialNames[i]) == 0 {
            shader.surfaceFlags |= i
            break
        }
        i += 1
    }
}

/**
```
===============
ParseVector
===============
```
*/
/// Source: oracle/codemp/qcommon/cm_shader.cpp:316
private func CM_ParseVector(_ shader: CmShader, _ text: inout JKAShared.TextCursor, _ count: Int32, _ v: Slots<Float>) -> Bool {
    var token: String
    var i: Int32
    // Raven assigns his own `v` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var v = v

    // FIXME: spaces are currently required after parens, should change parseext...
    token = COM_ParseExt(&text, false)
    if strcmp(token, "(") != 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing parenthesis in shader '%s'\n", shader.shader)
        return false
    }

    i = 0
    while i < count {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing vector element in shader '%s'\n", shader.shader)
            return false
        }
        v[i] = Float(atof(token))
        i += 1
    }

    token = COM_ParseExt(&text, false)
    if strcmp(token, ")") != 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing parenthesis in shader '%s'\n", shader.shader)
        return false
    }
    return true
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
private func CM_ParseShader(_ shader: CmShader, _ text: inout JKAShared.TextCursor) {
    var token: String

    token = COM_ParseExt(&text, true)
    if CharBuf(token)[0] != Int32(ascii: "{") {
        Com_Printf(S_COLOR_YELLOW + "WARNING: expecting '{', found '%s' instead in shader '%s'\n", token, shader.shader)
        return
    }

    while true {
        token = COM_ParseExt(&text, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: no concluding '}' in shader %s\n", shader.shader)
            return
        }

        // end of shader definition
        if CharBuf(token)[0] == Int32(ascii: "}") {
            break
        } else if CharBuf(token)[0] == Int32(ascii: "{") {
            // stage definition
            SkipBracedSection(&text)
            continue
        } else if Q_stricmp(token, "material") == 0 || Q_stricmp(token, "q3map_material") == 0 {
            // material deprecated as of 11 Jan 01
            // material undeprecated as of 7 May 01 - q3map_material deprecated
            SV_ParseMaterial(shader, &text)
        } else if Q_stricmp(token, "sun") == 0 || Q_stricmp(token, "q3map_sun") == 0 {
            // sun parms
            // q3map_sun deprecated as of 11 Jan 01
            //			float	a, b;

            token = COM_ParseExt(&text, false)
            //			shader->sunLight[0] = atof( token );
            token = COM_ParseExt(&text, false)
            //			shader->sunLight[1] = atof( token );
            token = COM_ParseExt(&text, false)
            //			shader->sunLight[2] = atof( token );

            //			VectorNormalize( shader->sunLight );

            token = COM_ParseExt(&text, false)
            //			a = atof( token );
            //			VectorScale( shader->sunLight, a, shader->sunLight);

            token = COM_ParseExt(&text, false)
            //			a = DEG2RAD(atof( token ));

            token = COM_ParseExt(&text, false)
            //			b = DEG2RAD(atof( token ));

            //			shader->sunDirection[0] = cos( a ) * cos( b );
            //			shader->sunDirection[1] = sin( a ) * cos( b );
            //			shader->sunDirection[2] = sin( b );
        } else if Q_stricmp(token, "surfaceParm") == 0 {
            SV_ParseSurfaceParm(shader, &text)
            continue
        } else if Q_stricmp(token, "fogParms") == 0 {
            var fogColor = vec3_t()
            // Port-note: Raven passes `fogColor` to `CM_ParseVector`, whose `v` parameter takes the Slots over the records, and Swift holds one record here. A Slots over one record has no form yet.
            // Raven wrote: if ( !CM_ParseVector( shader, text, 3, fogColor ) ) { return; }
            portMissing("CM_ParseShader", source: "oracle/codemp/qcommon/cm_shader.cpp:361")

            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parm for 'fogParms' keyword in shader '%s'\n", shader.shader)
                continue
            }
            //			shader->depthForOpaque = atof( token );

            // skip any old gradient directions
            SkipRestOfLine(&text)
            continue
        }
    }
    return
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
func CM_GetShaderInfo(_ name: String) -> CmShader? {
    // Port-note: The parameter tells the two C++ overloads apart, so the gate keeps this stub as a hand function.
    // TODO: Port CM_GetShaderInfo
    portMissing("CM_GetShaderInfo", source: "oracle/codemp/qcommon/cm_shader.cpp:498")
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:526
func CM_GetShaderInfo(_ shaderNum: Int32) -> CmShader? {
    // Port-note: The parameter tells the two C++ overloads apart, so the gate keeps this stub as a hand function.
    // TODO: Port CM_GetShaderInfo
    portMissing("CM_GetShaderInfo", source: "oracle/codemp/qcommon/cm_shader.cpp:526")
}
