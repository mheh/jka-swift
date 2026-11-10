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

/// One row of Raven's `infoParm_t` of `cm_shader.cpp`, the surface parameter name and the flags it sets and clears.
/// Source: oracle/codemp/qcommon/cm_shader.cpp:220
struct InfoParm {
    var name: String
    var clearSolid: Int32
    var surfaceFlags: Int32
    var contents: Int32
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:226
// AI: Raven keeps `infoParm_t svInfoParms[]` as C data. The table is a constant Array of rows in Raven's order, because the module never writes it.
let svInfoParms: [InfoParm] = [
    // Game surface flags
    InfoParm(name: "sky", clearSolid: -1, surfaceFlags: SURF_SKY, contents: 0), // emit light from an environment map
    InfoParm(name: "slick", clearSolid: -1, surfaceFlags: SURF_SLICK, contents: 0),

    InfoParm(name: "nodamage", clearSolid: -1, surfaceFlags: SURF_NODAMAGE, contents: 0),
    InfoParm(name: "noimpact", clearSolid: -1, surfaceFlags: SURF_NOIMPACT, contents: 0), // don't make impact explosions or marks
    InfoParm(name: "nomarks", clearSolid: -1, surfaceFlags: SURF_NOMARKS, contents: 0), // don't make impact marks, but still explode
    InfoParm(name: "nodraw", clearSolid: -1, surfaceFlags: SURF_NODRAW, contents: 0), // don't generate a drawsurface (or a lightmap)
    InfoParm(name: "nosteps", clearSolid: -1, surfaceFlags: SURF_NOSTEPS, contents: 0),
    InfoParm(name: "nodlight", clearSolid: -1, surfaceFlags: SURF_NODLIGHT, contents: 0), // don't ever add dynamic lights

    // Game content flags
    InfoParm(name: "nonsolid", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: 0), // special hack to clear solid flag
    InfoParm(name: "nonopaque", clearSolid: ~CONTENTS_OPAQUE, surfaceFlags: 0, contents: 0), // special hack to clear opaque flag
    InfoParm(name: "lava", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_LAVA), // very damaging
    InfoParm(name: "water", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_WATER),
    InfoParm(name: "fog", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_FOG), // carves surfaces entering
    InfoParm(name: "playerclip", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_PLAYERCLIP),
    InfoParm(name: "monsterclip", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_MONSTERCLIP),
    InfoParm(name: "botclip", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_BOTCLIP), // for bots
    InfoParm(name: "shotclip", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_SHOTCLIP),
    InfoParm(name: "trigger", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_TRIGGER),
    InfoParm(name: "nodrop", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_NODROP), // don't drop items or leave bodies (death fog, lava, etc)
    InfoParm(name: "terrain", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_TERRAIN), // use special terrain collsion
    InfoParm(name: "ladder", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_LADDER), // climb up in it like water
    InfoParm(name: "abseil", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_ABSEIL), // can abseil down this brush
    InfoParm(name: "outside", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_OUTSIDE), // volume is considered to be in the outside (i.e. not indoors)
    InfoParm(name: "inside", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_INSIDE), // volume is considered to be inside (i.e. indoors)

    InfoParm(name: "detail", clearSolid: -1, surfaceFlags: 0, contents: CONTENTS_DETAIL), // don't include in structural bsp
    // Raven wrote CONTENTS_TRANSLUCENT, the unsigned 0x80000000.
    InfoParm(name: "trans", clearSolid: -1, surfaceFlags: 0, contents: ~0x7fff_ffff), // surface has an alpha component
]

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
    var shaderFiles1: [String]
    var numShaders1: Int32 = 0
    var shaderFiles2: [String]
    var numShaders2: Int32 = 0
    // AI: Raven keeps `char *buffers[MAX_SHADER_FILES]`. The Array holds one CharBuf per file, and nil is Raven's NULL.
    // Each entry starts as an empty CharBuf, because Raven hands FS_ReadFile the address `&buffers[i]`, and a nil entry is his NULL, which asks for the length alone.
    var buffers = [CharBuf?](repeating: CharBuf(0), count: Int(MAX_SHADER_FILES))
    var numShaders: Int32
    var i: Int32
    var sum: Int32 = 0

    // scan for shader files
    shaderFiles1 = FS_ListFiles("shaders", ".shader", &numShaders1)
    shaderFiles2 = FS_ListFiles("shaders/test", ".shader", &numShaders2)

    // Raven's NULL test of the list is the empty Array.
    if shaderFiles1.isEmpty || numShaders1 == 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: no shader files found\n")
        return
    }

    numShaders = numShaders1 + numShaders2
    if numShaders > MAX_SHADER_FILES {
        numShaders = MAX_SHADER_FILES
    }

    // load and parse shader files
    i = 0
    while i < numShaders1 {
        var filename = CharBuf(MAX_QPATH)

        Com_sprintf(&filename, MAX_QPATH, "shaders/%s", shaderFiles1[i])
        Com_DPrintf("...loading '%s'\n", String(filename))
        sum += FS_ReadFile(String(filename), &buffers[i])
        if buffers[i] == nil {
            Com_Error(ERR_FATAL, "Couldn't load %s", String(filename))
        }
        i += 1
    }
    while i < numShaders {
        var filename = CharBuf(MAX_QPATH)

        Com_sprintf(&filename, MAX_QPATH, "shaders/test/%s", shaderFiles2[i - numShaders1])
        Com_DPrintf("...loading '%s'\n", String(filename))
        sum += FS_ReadFile(String(filename), &buffers[i])
        if buffers[i] == nil {
            Com_Error(ERR_DROP, "Couldn't load %s", String(filename))
        }
        i += 1
    }

    // build single large buffer
    // AI: Raven builds the text in a Z_Malloc block. The call stays for the zone count, and the text builds in a CharBuf of the same size.
    _ = Z_Malloc(sum + numShaders * 2, TAG_SHADERTEXT, true)
    var text = CharBuf(sum + numShaders * 2)

    // free in reverse order, so the temp files are all dumped
    i = numShaders - 1
    while i >= 0 {
        strcat(&text, "\n")
        strcat(&text, buffers[i]!)
        FS_FreeFile(buffers[i]!)
        i -= 1
    }
    shaderText = String(text)

    // free up memory
    FS_FreeFileList(shaderFiles1)
    FS_FreeFileList(shaderFiles2)
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
        // AI: Raven frees the Z_Malloc block of the text. The text is a String, so the free drops and the zone count keeps the block.
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
    let numsvInfoParms = svInfoParms.count
    var i: Int32

    token = COM_ParseExt(&text, false)
    i = 0
    while i < numsvInfoParms {
        if Q_stricmp(token, svInfoParms[i].name) == 0 {
            shader.surfaceFlags |= svInfoParms[i].surfaceFlags
            shader.contentFlags |= svInfoParms[i].contents
            shader.contentFlags &= svInfoParms[i].clearSolid
            break
        }
        i += 1
    }
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
private func CM_ParseVector(_ shader: CmShader, _ text: inout JKAShared.TextCursor, _ count: Int32, _ v: inout JKAShared.vec3_t) -> Bool {
    var token: String
    var i: Int32

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
            if !CM_ParseVector(shader, &text, 3, &fogColor) {
                return
            }

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
    var def: String?
    var shader: CmShader?

    // Add all basic shaders to the cmShaderTable
    i = 0
    while i < cmg.numShaders {
        // AI: Raven inserts the `CCMShader *` of slot `i` into the `CHash`. The table stores the offset of the record in `cmg.shaders` under its name.
        cmShaderTable[CM_GetShaderInfo(i)!.shader] = i
        i += 1
    }
    // Go through and parse evaluate shader names to shadernums
    i = 0
    while i < cmg.numShaders {
        shader = CM_GetShaderInfo(i)
        def = CM_GetShaderText(shader!.shader)
        if def != nil {
            var p = TextCursor(CharBuf(def!))
            CM_ParseShader(shader!, &p)
        }
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
    var out: CmShader?
    var def: String?

    // AI: Raven finds the `CCMShader *` in the `CHash`. The table gives the offset of the record in `cmg.shaders`.
    let offset = cmShaderTable[name]
    if offset != nil {
        out = cmg.shadersSlots[offset!]
        return out
    }

    // Create a new CCMShader class
    out = CmShader(Hunk_Alloc(Int32(CmShader.byteCount), h_high))
    // Set defaults
    Q_strncpyz(&out!.shaderBuffer, name, MAX_QPATH)
    out!.contentFlags = CONTENTS_SOLID | CONTENTS_OPAQUE

    // Parse in any text if it exists
    def = CM_GetShaderText(name)
    if def != nil {
        var p = TextCursor(CharBuf(def!))
        CM_ParseShader(out!, &p)
    }

    // Port-note: The record of Hunk_Alloc is not a slot of `cmg.shaders`, so the offset form of `cmShaderTable` has no value for it.
    // Raven wrote: cmShaderTable.insert(out);
    portMissing("CM_GetShaderInfo", source: "oracle/codemp/qcommon/cm_shader.cpp:498")
    return out
}

/// Source: oracle/codemp/qcommon/cm_shader.cpp:526
func CM_GetShaderInfo(_ shaderNum: Int32) -> CmShader? {
    var out: CmShader?

    if (shaderNum < 0) || (shaderNum >= cmg.numShaders) {
        return nil
    }
    out = cmg.shadersSlots[shaderNum]
    return out
}
