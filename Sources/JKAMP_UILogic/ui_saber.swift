import Foundation
import JKAMP
import JKAShared
import JKAMP_UI
import JKAMP_BG

/// Source: oracle/codemp/ui/ui_saber.c:17
let MAX_SABER_DATA_SIZE = 0x80000 as Int32

/// Source: oracle/codemp/ui/ui_saber.c:22
var SaberParms: JKAShared.CharBuf {
    get { world.variables.SaberParms }
    set { world.variables.SaberParms = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:23
public var ui_saber_parms_parsed: Bool {
    get { world.variables.ui_saber_parms_parsed }
    set { world.variables.ui_saber_parms_parsed = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:25
var redSaberGlowShader: JKAShared.qhandle_t {
    get { world.variables.redSaberGlowShader }
    set { world.variables.redSaberGlowShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:26
var redSaberCoreShader: JKAShared.qhandle_t {
    get { world.variables.redSaberCoreShader }
    set { world.variables.redSaberCoreShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:27
var orangeSaberGlowShader: JKAShared.qhandle_t {
    get { world.variables.orangeSaberGlowShader }
    set { world.variables.orangeSaberGlowShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:28
var orangeSaberCoreShader: JKAShared.qhandle_t {
    get { world.variables.orangeSaberCoreShader }
    set { world.variables.orangeSaberCoreShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:29
var yellowSaberGlowShader: JKAShared.qhandle_t {
    get { world.variables.yellowSaberGlowShader }
    set { world.variables.yellowSaberGlowShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:30
var yellowSaberCoreShader: JKAShared.qhandle_t {
    get { world.variables.yellowSaberCoreShader }
    set { world.variables.yellowSaberCoreShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:31
var greenSaberGlowShader: JKAShared.qhandle_t {
    get { world.variables.greenSaberGlowShader }
    set { world.variables.greenSaberGlowShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:32
var greenSaberCoreShader: JKAShared.qhandle_t {
    get { world.variables.greenSaberCoreShader }
    set { world.variables.greenSaberCoreShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:33
var blueSaberGlowShader: JKAShared.qhandle_t {
    get { world.variables.blueSaberGlowShader }
    set { world.variables.blueSaberGlowShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:34
var blueSaberCoreShader: JKAShared.qhandle_t {
    get { world.variables.blueSaberCoreShader }
    set { world.variables.blueSaberCoreShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:35
var purpleSaberGlowShader: JKAShared.qhandle_t {
    get { world.variables.purpleSaberGlowShader }
    set { world.variables.purpleSaberGlowShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:36
var purpleSaberCoreShader: JKAShared.qhandle_t {
    get { world.variables.purpleSaberCoreShader }
    set { world.variables.purpleSaberCoreShader = newValue }
}

/// Source: oracle/codemp/ui/ui_saber.c:1077
private let MAX_SABER_HILTS = 64 as Int32

/// Source: oracle/codemp/ui/ui_saber.c:38
public func UI_CacheSaberGlowGraphics() {
    //FIXME: these get fucked by vid_restarts
    redSaberGlowShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/red_glow")
    redSaberCoreShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/red_line")
    orangeSaberGlowShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/orange_glow")
    orangeSaberCoreShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/orange_line")
    yellowSaberGlowShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/yellow_glow")
    yellowSaberCoreShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/yellow_line")
    greenSaberGlowShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/green_glow")
    greenSaberCoreShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/green_line")
    blueSaberGlowShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/blue_glow")
    blueSaberCoreShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/blue_line")
    purpleSaberGlowShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/purple_glow")
    purpleSaberCoreShader = trap_R_RegisterShaderNoMip("gfx/effects/sabers/purple_line")
}

/// Source: oracle/codemp/ui/ui_saber.c:54
public func UI_ParseLiteral(_ data: inout JKAShared.TextCursor, _ string: String) -> Bool {
    let token: String

    token = COM_ParseExt(&data, true)
    if token.isEmpty {
        Com_Printf("unexpected EOF\n")
        return true
    }

    if Q_stricmp(token, string) != 0 {
        Com_Printf("required string '%s' missing\n", string)
        return true
    }

    return false
}

/// Source: oracle/codemp/ui/ui_saber.c:74
public func UI_ParseLiteralSilent(_ data: inout JKAShared.TextCursor, _ string: String) -> Bool {
    let token: String

    token = COM_ParseExt(&data, true)
    if token.isEmpty {
        return true
    }

    if Q_stricmp(token, string) != 0 {
        return true
    }

    return false
}

/// Source: oracle/codemp/ui/ui_saber.c:92
@discardableResult
public func UI_SaberParseParm(_ saberName: String, _ parmname: String, _ saberData: inout JKAShared.CharBuf) -> Bool {
    var token: String
    var value = ""
    var p: TextCursor

    if saberName.isEmpty {
        return false
    }

    //try to parse it out
    p = TextCursor(SaberParms)
    // A bogus name is passed in
    COM_BeginParseSession("saberinfo")

    // look for the right saber
    while !p.isNull {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            return false
        }

        if Q_stricmp(token, saberName) == 0 {
            break
        }

        SkipBracedSection(&p)
    }
    if p.isNull {
        return false
    }

    if UI_ParseLiteral(&p, "{") {
        return false
    }

    // parse the saber info block
    while true {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_RED + "ERROR: unexpected EOF while parsing '%s'\n", saberName)
            return false
        }

        if Q_stricmp(token, "}") == 0 {
            break
        }

        if Q_stricmp(token, parmname) == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            strcpy(&saberData, value)
            return true
        }

        SkipRestOfLine(&p)
        continue
    }

    return false
}

/// Source: oracle/codemp/ui/ui_saber.c:167
public func UI_SaberModelForSaber(_ saberName: String, _ saberModel: inout JKAShared.CharBuf) -> Bool {
    return UI_SaberParseParm(saberName, "saberModel", &saberModel)
}

/// Source: oracle/codemp/ui/ui_saber.c:172
public func UI_SaberSkinForSaber(_ saberName: String, _ saberSkin: inout JKAShared.CharBuf) -> Bool {
    return UI_SaberParseParm(saberName, "customSkin", &saberSkin)
}

/// Source: oracle/codemp/ui/ui_saber.c:177
@discardableResult
public func UI_SaberTypeForSaber(_ saberName: String, _ saberType: inout JKAShared.CharBuf) -> Bool {
    return UI_SaberParseParm(saberName, "saberType", &saberType)
}

/// Source: oracle/codemp/ui/ui_saber.c:182
public func UI_SaberNumBladesForSaber(_ saberName: String) -> Int32 {
    var numBlades: Int32
    var numBladesString = CharBuf(8)
    UI_SaberParseParm(saberName, "numBlades", &numBladesString)
    numBlades = atoi(numBladesString)
    if numBlades < 1 {
        numBlades = 1
    } else if numBlades > 8 {
        numBlades = 8
    }
    return numBlades
}

/// Source: oracle/codemp/ui/ui_saber.c:199
public func UI_SaberShouldDrawBlade(_ saberName: String, _ bladeNum: Int32) -> Bool {
    var bladeStyle2Start: Int32 = 0
    var noBlade: Int32 = 0
    var bladeStyle2StartString = CharBuf(8)
    var noBladeString = CharBuf(8)
    UI_SaberParseParm(saberName, "bladeStyle2Start", &bladeStyle2StartString)
    if bladeStyle2StartString[0] != 0 {
        bladeStyle2Start = atoi(bladeStyle2StartString)
    }
    if bladeStyle2Start != 0
        && bladeNum >= bladeStyle2Start { //use second blade style
        UI_SaberParseParm(saberName, "noBlade2", &noBladeString)
        if noBladeString[0] != 0 {
            noBlade = atoi(noBladeString)
        }
    } else { //use first blade style
        UI_SaberParseParm(saberName, "noBlade", &noBladeString)
        if noBladeString[0] != 0 {
            noBlade = atoi(noBladeString)
        }
    }
    return Bool(noBlade == 0)
}

/// Source: oracle/codemp/ui/ui_saber.c:233
public func UI_IsSaberTwoHanded(_ saberName: String) -> Bool {
    let twoHanded: Int32
    var twoHandedString = CharBuf(8)
    UI_SaberParseParm(saberName, "twoHanded", &twoHandedString)
    if twoHandedString[0] == 0 { //not defined defaults to "no"
        return false
    }
    twoHanded = atoi(twoHandedString)
    return Bool(twoHanded != 0)
}

/// Source: oracle/codemp/ui/ui_saber.c:246
public func UI_SaberBladeLengthForSaber(_ saberName: String, _ bladeNum: Int32) -> Float {
    var lengthString = CharBuf(8)
    var length: Float = 40.0
    UI_SaberParseParm(saberName, "saberLength", &lengthString)
    if lengthString[0] != 0 {
        length = Float(atof(lengthString))
        if length < 0.0 {
            length = 0.0
        }
    }

    UI_SaberParseParm(saberName, va("saberLength%d", bladeNum + 1), &lengthString)
    if lengthString[0] != 0 {
        length = Float(atof(lengthString))
        if length < 0.0 {
            length = 0.0
        }
    }

    return length
}

/// Source: oracle/codemp/ui/ui_saber.c:273
public func UI_SaberBladeRadiusForSaber(_ saberName: String, _ bladeNum: Int32) -> Float {
    var radiusString = CharBuf(8)
    var radius: Float = 3.0
    UI_SaberParseParm(saberName, "saberRadius", &radiusString)
    if radiusString[0] != 0 {
        radius = Float(atof(radiusString))
        if radius < 0.0 {
            radius = 0.0
        }
    }

    UI_SaberParseParm(saberName, va("saberRadius%d", bladeNum + 1), &radiusString)
    if radiusString[0] != 0 {
        radius = Float(atof(radiusString))
        if radius < 0.0 {
            radius = 0.0
        }
    }

    return radius
}

/// Source: oracle/codemp/ui/ui_saber.c:300
public func UI_SaberProperNameForSaber(_ saberName: String, _ saberProperName: inout JKAShared.CharBuf) -> Bool {
    // Port-note: Raven copies his uninitialized buffer when the parse fails.
    // The CharBuf is zero at entry, so that copy writes an empty string.
    var stringedSaberName = CharBuf(1024)
    let ret = UI_SaberParseParm(saberName, "name", &stringedSaberName)
    // if it's a stringed reference translate it
    if ret && stringedSaberName[0] == Int32(ascii: "@") {
        let (_, text) = trap_SP_GetStringTextString(String(stringedSaberName[1...]), 1024)
        strcpy(&saberProperName, text)
    } else {
        // no stringed so just use it as it
        strcpy(&saberProperName, stringedSaberName)
    }

    return ret
}

/// Source: oracle/codemp/ui/ui_saber.c:319
public func UI_SaberValidForPlayerInMP(_ saberName: String) -> Bool {
    var allowed = CharBuf(8)
    if !UI_SaberParseParm(saberName, "notInMP", &allowed) { //not defined, default is yes
        return true
    }
    if allowed[0] == 0 { //not defined, default is yes
        return true
    } else { //return value
        return Bool(atoi(allowed) == 0)
    }
}

/// Source: oracle/codemp/ui/ui_saber.c:336
public func UI_SaberLoadParms() {
    var len: Int32
    var totallen: Int32
    var saberExtFNLen: Int32
    var fileCnt: Int32
    var i: Int32
    var holdChar: TextCursor
    var marker: Int32
    var saberExtensionListBuf = CharBuf(2048) //	The list of file names read in
    var f: fileHandle_t = 0
    var buffer = CharBuf(MAX_MENUFILE)

    //ui.Printf( "UI Parsing *.sab saber definitions\n" );

    ui_saber_parms_parsed = true
    UI_CacheSaberGlowGraphics()

    //set where to store the first one
    totallen = 0
    marker = 0
    SaberParms[marker] = 0

    //now load in the extra .npc extensions
    let filled = trap_FS_GetFileList("ext_data/sabers", ".sab", Int32(saberExtensionListBuf.count))
    fileCnt = filled.0
    saberExtensionListBuf = filled.1

    holdChar = TextCursor(saberExtensionListBuf)
    i = 0
    while i < fileCnt {
        saberExtFNLen = strlen(holdChar.text)

        len = trap_FS_FOpenFile(va("ext_data/sabers/%s", holdChar.text), &f, FS_READ)

        if f == 0 {
            i += 1
            holdChar.advance(by: saberExtFNLen + 1)
            continue
        }

        if len == -1 {
            Com_Printf("UI_SaberLoadParms: error reading %s\n", holdChar.text)
        } else {
            if len > Int32(buffer.count) {
                Com_Error(ERR_FATAL, "UI_SaberLoadParms: file %s too large to read (max=%d)", holdChar.text, Int32(buffer.count))
            }
            trap_FS_Read(&buffer, len, f)
            trap_FS_FCloseFile(f)
            // Port-note: Raven writes one byte past his buffer when the file has exactly MAX_MENUFILE bytes.
            // The CharBuf subscript traps on that write.
            buffer[len] = 0

            if totallen != 0 && SaberParms[marker - 1] == Int32(ascii: "}") { //don't let it end on a } because that should be a stand-alone token
                strcat(&SaberParms, " ", at: marker)
                totallen += 1
                marker += 1
            }
            len = COM_Compress(&buffer)

            if totallen + len >= MAX_SABER_DATA_SIZE {
                Com_Error(ERR_FATAL, "UI_SaberLoadParms: ran out of space before reading %s\n(you must make the .sab files smaller)", holdChar.text)
            }
            strcat(&SaberParms, buffer, at: marker)

            totallen += len
            marker += len
        }
        i += 1
        holdChar.advance(by: saberExtFNLen + 1)
    }
}

/// Source: oracle/codemp/ui/ui_saber.c:402
public func UI_DoSaber(_ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ length: Float, _ lengthMax: Float, _ radius: Float, _ color: JKAMP.saber_colors_t) {
    RefEntity.scratch { saber in
        var mid = vec3_t()
        var rgb = vec3_t(1, 1, 1)
        var blade: qhandle_t = 0
        var glow: qhandle_t = 0
        var radiusmult: Float
        var radiusRange: Float
        var radiusStart: Float

        if length < 0.5 {
            // if the thing is so short, just forget even adding me.
            return
        }

        // Find the midpoint of the saber for lighting purposes
        _VectorMA(origin, length * 0.5, dir, &mid)

        switch color {
        case SABER_RED:
            glow = redSaberGlowShader
            blade = redSaberCoreShader
            rgb = vec3_t(1.0, 0.2, 0.2)
        case SABER_ORANGE:
            glow = orangeSaberGlowShader
            blade = orangeSaberCoreShader
            rgb = vec3_t(1.0, 0.5, 0.1)
        case SABER_YELLOW:
            glow = yellowSaberGlowShader
            blade = yellowSaberCoreShader
            rgb = vec3_t(1.0, 1.0, 0.2)
        case SABER_GREEN:
            glow = greenSaberGlowShader
            blade = greenSaberCoreShader
            rgb = vec3_t(0.2, 1.0, 0.2)
        case SABER_BLUE:
            glow = blueSaberGlowShader
            blade = blueSaberCoreShader
            rgb = vec3_t(0.2, 0.4, 1.0)
        case SABER_PURPLE:
            glow = purpleSaberGlowShader
            blade = purpleSaberCoreShader
            rgb = vec3_t(0.9, 0.2, 1.0)
        default:
            break
        }

        // always add a light because sabers cast a nice glow before they slice you in half!!  or something...
        /*
        if ( doLight )
        {//FIXME: RGB combine all the colors of the sabers you're using into one averaged color!
            cgi_R_AddLightToScene( mid, (length*2.0f) + (random()*8.0f), rgb[0], rgb[1], rgb[2] );
        }
        */

        // Saber glow is it's own ref type because it uses a ton of sprites, otherwise it would eat up too many
        //	refEnts to do each glow blob individually
        saber.saberLength = length

        // Jeff, I did this because I foolishly wished to have a bright halo as the saber is unleashed.  
        // It's not quite what I'd hoped tho.  If you have any ideas, go for it!  --Pat
        if length < lengthMax {
            radiusmult = Float(1.0 + (2.0 / Double(length))) // Note this creates a curve, and length cannot be < 0.5.
        } else {
            radiusmult = 1.0
        }

        radiusRange = radius * 0.075
        radiusStart = radius - radiusRange

        saber.radius = Float((Double(radiusStart) + crandom() * Double(radiusRange)) * Double(radiusmult))
        //saber.radius = (2.8f + crandom() * 0.2f)*radiusmult;

        saber.origin = origin
        saber.axis[0] = dir
        saber.reType = RT_SABER_GLOW
        saber.customShader = glow
        saber.shaderRGBA[3] = 0xff
        saber.shaderRGBA[2] = saber.shaderRGBA[3]
        saber.shaderRGBA[1] = saber.shaderRGBA[2]
        saber.shaderRGBA[0] = saber.shaderRGBA[1]
        //saber.renderfx = rfx;

        trap_R_AddRefEntityToScene(saber)

        // Do the hot core
        _VectorMA(origin, length, dir, &saber.origin)
        _VectorMA(origin, -1, dir, &saber.oldorigin)
        saber.customShader = blade
        saber.reType = RT_LINE
        radiusStart = radius / 3.0
        saber.radius = Float((Double(radiusStart) + crandom() * Double(radiusRange)) * Double(radiusmult))
        //	saber.radius = (1.0 + crandom() * 0.2f)*radiusmult;

        trap_R_AddRefEntityToScene(saber)
    }
}

/// Source: oracle/codemp/ui/ui_saber.c:507
public func SaberColorToString(_ color: JKAMP.saber_colors_t) -> String? {
    if color == SABER_RED {
        return "red"
    }

    if color == SABER_ORANGE {
        return "orange"
    }

    if color == SABER_YELLOW {
        return "yellow"
    }

    if color == SABER_GREEN {
        return "green"
    }

    if color == SABER_BLUE {
        return "blue"
    }

    if color == SABER_PURPLE {
        return "purple"
    }
    return nil
}

/// Source: oracle/codemp/ui/ui_saber.c:528
public func TranslateSaberColor(_ name: String) -> JKAMP.saber_colors_t {
    if Q_stricmp(name, "red") == 0 {
        return SABER_RED
    }
    if Q_stricmp(name, "orange") == 0 {
        return SABER_ORANGE
    }
    if Q_stricmp(name, "yellow") == 0 {
        return SABER_YELLOW
    }
    if Q_stricmp(name, "green") == 0 {
        return SABER_GREEN
    }
    if Q_stricmp(name, "blue") == 0 {
        return SABER_BLUE
    }
    if Q_stricmp(name, "purple") == 0 {
        return SABER_PURPLE
    }
    if Q_stricmp(name, "random") == 0 {
        return saber_colors_t(Q_irand(SABER_ORANGE, SABER_PURPLE))
    }
    return SABER_BLUE
}

/// Source: oracle/codemp/ui/ui_saber.c:561
public func TranslateSaberType(_ name: String) -> JKAShared.saberType_t {
    if Q_stricmp(name, "SABER_SINGLE") == 0 {
        return SABER_SINGLE
    }
    if Q_stricmp(name, "SABER_STAFF") == 0 {
        return SABER_STAFF
    }
    if Q_stricmp(name, "SABER_BROAD") == 0 {
        return SABER_BROAD
    }
    if Q_stricmp(name, "SABER_PRONG") == 0 {
        return SABER_PRONG
    }
    if Q_stricmp(name, "SABER_DAGGER") == 0 {
        return SABER_DAGGER
    }
    if Q_stricmp(name, "SABER_ARC") == 0 {
        return SABER_ARC
    }
    if Q_stricmp(name, "SABER_SAI") == 0 {
        return SABER_SAI
    }
    if Q_stricmp(name, "SABER_CLAW") == 0 {
        return SABER_CLAW
    }
    if Q_stricmp(name, "SABER_LANCE") == 0 {
        return SABER_LANCE
    }
    if Q_stricmp(name, "SABER_STAR") == 0 {
        return SABER_STAR
    }
    if Q_stricmp(name, "SABER_TRIDENT") == 0 {
        return SABER_TRIDENT
    }
    if Q_stricmp(name, "SABER_SITH_SWORD") == 0 {
        return SABER_SITH_SWORD
    }
    return SABER_SINGLE
}

/// Source: oracle/codemp/ui/ui_saber.c:614
public func UI_SaberDrawBlade(_ item: ItemDef, _ saberName: String, _ saberModel: Int32, _ saberType: JKAShared.saberType_t, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t, _ bladeNum: Int32) {
    MdxaBone.scratch { boltMatrix in
        var bladeColorString = CharBuf(MAX_QPATH)
        let bladeColor: saber_colors_t
        let bladeLength: Float
        let bladeRadius: Float
        var bladeOrigin = vec3_t()
        var axis = [vec3_t](repeating: vec3_t(), count: 3)
        //	vec3_t	angles={0};
        var tagHack = false
        let tagName: String
        var bolt: Int32
        let scale: Float

        if (item.flags & ITF_ISSABER) != 0 && saberModel < 2 {
            strcpy(&bladeColorString, trap_Cvar_VariableStringBuffer("ui_saber_color", Int32(bladeColorString.count)))
        } else { //if ( item->flags&ITF_ISSABER2 ) - presumed
            strcpy(&bladeColorString, trap_Cvar_VariableStringBuffer("ui_saber2_color", Int32(bladeColorString.count)))
        }

        if !trap_G2API_HasGhoul2ModelOnIndex(&item.ghoul2, saberModel) { //invalid index!
            return
        }

        bladeColor = TranslateSaberColor(String(bladeColorString))

        bladeLength = UI_SaberBladeLengthForSaber(saberName, bladeNum)
        bladeRadius = UI_SaberBladeRadiusForSaber(saberName, bladeNum)

        tagName = va("*blade%d", bladeNum + 1)
        bolt = trap_G2API_AddBolt(item.ghoul2, saberModel, tagName)

        if bolt == -1 {
            tagHack = true
            //hmm, just fall back to the most basic tag (this will also make it work with pre-JKA saber models
            bolt = trap_G2API_AddBolt(item.ghoul2, saberModel, "*flash")
            if bolt == -1 { //no tag_flash either?!!
                bolt = 0
            }
        }

        //	angles[PITCH] = curYaw;
        //	angles[ROLL] = 0;

        // The engine only reads the scale, at G2_API.cpp:1825-1851, so the copy is behavior-equal.
        var originScale = vec3_origin
        trap_G2API_GetBoltMatrix(item.ghoul2, saberModel, bolt, boltMatrix, angles, origin, uiInfo.uiDC.realTime, nil, &originScale) //NULL was cgs.model_draw

        // work the matrix axis stuff into the original axis and origins used.
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &bladeOrigin)
        BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &axis[0]) //front (was NEGATIVE_Y, but the md3->glm exporter screws up this tag somethin' awful)
        //		...changed this back to NEGATIVE_Y		
        BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_X, &axis[1]) //right ... and changed this to NEGATIVE_X
        BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_Z, &axis[2]) //up

        // Where do I get scale from?
        //	scale = DC->xscale;
        scale = 1.0

        if tagHack {
            switch saberType {
            case SABER_SINGLE:
                _VectorMA(bladeOrigin, scale, axis[0], &bladeOrigin)
            case SABER_DAGGER:
                fallthrough
            case SABER_LANCE:
                break
            case SABER_STAFF:
                if bladeNum == 0 {
                    _VectorMA(bladeOrigin, 12 * scale, axis[0], &bladeOrigin)
                }
                if bladeNum == 1 {
                    _VectorScale(axis[0], -1, &axis[0])
                    _VectorMA(bladeOrigin, 12 * scale, axis[0], &bladeOrigin)
                }
            case SABER_BROAD:
                if bladeNum == 0 {
                    _VectorMA(bladeOrigin, -1 * scale, axis[1], &bladeOrigin)
                } else if bladeNum == 1 {
                    _VectorMA(bladeOrigin, 1 * scale, axis[1], &bladeOrigin)
                }
            case SABER_PRONG:
                if bladeNum == 0 {
                    _VectorMA(bladeOrigin, -3 * scale, axis[1], &bladeOrigin)
                } else if bladeNum == 1 {
                    _VectorMA(bladeOrigin, 3 * scale, axis[1], &bladeOrigin)
                }
            case SABER_ARC:
                _VectorSubtract(axis[1], axis[2], &axis[1])
                VectorNormalize(&axis[1])
                switch bladeNum {
                case 0:
                    _VectorMA(bladeOrigin, 8 * scale, axis[0], &bladeOrigin)
                    _VectorScale(axis[0], 0.75, &axis[0])
                    _VectorScale(axis[1], 0.25, &axis[1])
                    _VectorAdd(axis[0], axis[1], &axis[0])
                case 1:
                    _VectorScale(axis[0], 0.25, &axis[0])
                    _VectorScale(axis[1], 0.75, &axis[1])
                    _VectorAdd(axis[0], axis[1], &axis[0])
                case 2:
                    _VectorMA(bladeOrigin, -8 * scale, axis[0], &bladeOrigin)
                    _VectorScale(axis[0], -0.25, &axis[0])
                    _VectorScale(axis[1], 0.75, &axis[1])
                    _VectorAdd(axis[0], axis[1], &axis[0])
                case 3:
                    _VectorMA(bladeOrigin, -16 * scale, axis[0], &bladeOrigin)
                    _VectorScale(axis[0], -0.75, &axis[0])
                    _VectorScale(axis[1], 0.25, &axis[1])
                    _VectorAdd(axis[0], axis[1], &axis[0])
                default:
                    break
                }
            case SABER_SAI:
                if bladeNum == 1 {
                    _VectorMA(bladeOrigin, -3 * scale, axis[1], &bladeOrigin)
                } else if bladeNum == 2 {
                    _VectorMA(bladeOrigin, 3 * scale, axis[1], &bladeOrigin)
                }
            case SABER_CLAW:
                switch bladeNum {
                case 0:
                    _VectorMA(bladeOrigin, 2 * scale, axis[0], &bladeOrigin)
                    _VectorMA(bladeOrigin, 2 * scale, axis[2], &bladeOrigin)
                case 1:
                    _VectorMA(bladeOrigin, 2 * scale, axis[0], &bladeOrigin)
                    _VectorMA(bladeOrigin, 2 * scale, axis[2], &bladeOrigin)
                    _VectorMA(bladeOrigin, 2 * scale, axis[1], &bladeOrigin)
                case 2:
                    _VectorMA(bladeOrigin, 2 * scale, axis[0], &bladeOrigin)
                    _VectorMA(bladeOrigin, 2 * scale, axis[2], &bladeOrigin)
                    _VectorMA(bladeOrigin, -2 * scale, axis[1], &bladeOrigin)
                default:
                    break
                }
            case SABER_STAR:
                switch bladeNum {
                case 0:
                    _VectorMA(bladeOrigin, 8 * scale, axis[0], &bladeOrigin)
                case 1:
                    _VectorScale(axis[0], 0.33, &axis[0])
                    _VectorScale(axis[2], 0.67, &axis[2])
                    _VectorAdd(axis[0], axis[2], &axis[0])
                    _VectorMA(bladeOrigin, 8 * scale, axis[0], &bladeOrigin)
                case 2:
                    _VectorScale(axis[0], -0.33, &axis[0])
                    _VectorScale(axis[2], 0.67, &axis[2])
                    _VectorAdd(axis[0], axis[2], &axis[0])
                    _VectorMA(bladeOrigin, 8 * scale, axis[0], &bladeOrigin)
                case 3:
                    _VectorScale(axis[0], -1, &axis[0])
                    _VectorMA(bladeOrigin, 8 * scale, axis[0], &bladeOrigin)
                case 4:
                    _VectorScale(axis[0], -0.33, &axis[0])
                    _VectorScale(axis[2], -0.67, &axis[2])
                    _VectorAdd(axis[0], axis[2], &axis[0])
                    _VectorMA(bladeOrigin, 8 * scale, axis[0], &bladeOrigin)
                case 5:
                    _VectorScale(axis[0], 0.33, &axis[0])
                    _VectorScale(axis[2], -0.67, &axis[2])
                    _VectorAdd(axis[0], axis[2], &axis[0])
                    _VectorMA(bladeOrigin, 8 * scale, axis[0], &bladeOrigin)
                default:
                    break
                }
            case SABER_TRIDENT:
                switch bladeNum {
                case 0:
                    _VectorMA(bladeOrigin, 24 * scale, axis[0], &bladeOrigin)
                case 1:
                    _VectorMA(bladeOrigin, -6 * scale, axis[1], &bladeOrigin)
                    _VectorMA(bladeOrigin, 24 * scale, axis[0], &bladeOrigin)
                case 2:
                    _VectorMA(bladeOrigin, 6 * scale, axis[1], &bladeOrigin)
                    _VectorMA(bladeOrigin, 24 * scale, axis[0], &bladeOrigin)
                case 3:
                    _VectorMA(bladeOrigin, -32 * scale, axis[0], &bladeOrigin)
                    _VectorScale(axis[0], -1, &axis[0])
                default:
                    break
                }
            case SABER_SITH_SWORD:
                //no blade
                break
            default:
                break
            }
        }
        if saberType == SABER_SITH_SWORD { //draw no blade
            return
        }

        UI_DoSaber(bladeOrigin, axis[0], bladeLength, bladeLength, bladeRadius, bladeColor)
    }
}

/// Source: oracle/codemp/ui/ui_saber.c:894
public func UI_GetSaberForMenu(_ saber: inout JKAShared.CharBuf, _ saberNum: Int32) {
    var saberTypeString = CharBuf(MAX_QPATH)
    var saberType: saberType_t = SABER_NONE

    if saberNum == 0 {
        strcpy(&saber, trap_Cvar_VariableStringBuffer("ui_saber", MAX_QPATH))
        if !UI_SaberValidForPlayerInMP(String(saber)) {
            trap_Cvar_Set("ui_saber", "kyle")
            strcpy(&saber, trap_Cvar_VariableStringBuffer("ui_saber", MAX_QPATH))
        }
    } else {
        strcpy(&saber, trap_Cvar_VariableStringBuffer("ui_saber2", MAX_QPATH))
        if !UI_SaberValidForPlayerInMP(String(saber)) {
            trap_Cvar_Set("ui_saber2", "kyle")
            strcpy(&saber, trap_Cvar_VariableStringBuffer("ui_saber2", MAX_QPATH))
        }
    }
    //read this from the sabers.cfg
    UI_SaberTypeForSaber(String(saber), &saberTypeString)
    if saberTypeString[0] != 0 {
        saberType = TranslateSaberType(String(saberTypeString))
    }

    switch uiInfo.movesTitleIndex {
    case 0: //MD_ACROBATICS:
        break
    case 1: //MD_SINGLE_FAST:
        fallthrough
    case 2: //MD_SINGLE_MEDIUM:
        fallthrough
    case 3: //MD_SINGLE_STRONG:
        if saberType != SABER_SINGLE {
            Q_strncpyz(&saber, "single_1", MAX_QPATH)
        }
    case 4: //MD_DUAL_SABERS:
        if saberType != SABER_SINGLE {
            Q_strncpyz(&saber, "single_1", MAX_QPATH)
        }
    case 5: //MD_SABER_STAFF:
        if saberType == SABER_SINGLE || saberType == SABER_NONE {
            Q_strncpyz(&saber, "dual_1", MAX_QPATH)
        }
    default:
        break
    }
}

/// Source: oracle/codemp/ui/ui_saber.c:952
public func UI_SaberDrawBlades(_ item: ItemDef, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t) {
    //NOTE: only allows one saber type in view at a time
    var saber = CharBuf(MAX_QPATH)
    var saberNum: Int32 = 0
    var saberModel: Int32 = 0
    var numSabers: Int32 = 1

    if (item.flags & ITF_ISCHARACTER) != 0 //hacked sabermoves sabers in character's hand
        && uiInfo.movesTitleIndex == 4 /*MD_DUAL_SABERS*/ {
        numSabers = 2
    }

    saberNum = 0
    while saberNum < numSabers {
        if (item.flags & ITF_ISCHARACTER) != 0 { //hacked sabermoves sabers in character's hand
            UI_GetSaberForMenu(&saber, saberNum)
            saberModel = saberNum + 1
        } else if (item.flags & ITF_ISSABER) != 0 {
            strcpy(&saber, trap_Cvar_VariableStringBuffer("ui_saber", Int32(saber.count)))
            if !UI_SaberValidForPlayerInMP(String(saber)) {
                trap_Cvar_Set("ui_saber", "kyle")
                strcpy(&saber, trap_Cvar_VariableStringBuffer("ui_saber", Int32(saber.count)))
            }
            saberModel = 0
        } else if (item.flags & ITF_ISSABER2) != 0 {
            strcpy(&saber, trap_Cvar_VariableStringBuffer("ui_saber2", Int32(saber.count)))
            if !UI_SaberValidForPlayerInMP(String(saber)) {
                trap_Cvar_Set("ui_saber2", "kyle")
                strcpy(&saber, trap_Cvar_VariableStringBuffer("ui_saber2", Int32(saber.count)))
            }
            saberModel = 0
        } else {
            return
        }
        if saber[0] != 0 {
            let saberType: saberType_t
            var curBlade: Int32 = 0
            let numBlades = UI_SaberNumBladesForSaber(String(saber))
            if numBlades != 0 { //okay, here we go, time to draw each blade...
                var saberTypeString = CharBuf(MAX_QPATH)
                UI_SaberTypeForSaber(String(saber), &saberTypeString)
                saberType = TranslateSaberType(String(saberTypeString))
                curBlade = 0
                while curBlade < numBlades {
                    if UI_SaberShouldDrawBlade(String(saber), curBlade) {
                        UI_SaberDrawBlade(item, String(saber), saberModel, saberType, origin, angles, curBlade)
                    }
                    curBlade += 1
                }
            }
        }
        saberNum += 1
    }
}

/// Source: oracle/codemp/ui/ui_saber.c:1019
public func UI_SaberAttachToChar(_ item: ItemDef) {
    var numSabers: Int32 = 1
    var saberNum: Int32 = 0

    if trap_G2API_HasGhoul2ModelOnIndex(&item.ghoul2, 2) { //remove any extra models
        trap_G2API_RemoveGhoul2Model(&item.ghoul2, 2)
    }
    if trap_G2API_HasGhoul2ModelOnIndex(&item.ghoul2, 1) { //remove any extra models
        trap_G2API_RemoveGhoul2Model(&item.ghoul2, 1)
    }

    if uiInfo.movesTitleIndex == 4 /*MD_DUAL_SABERS*/ {
        numSabers = 2
    }

    saberNum = 0
    while saberNum < numSabers {
        //bolt sabers
        var modelPath = CharBuf(MAX_QPATH)
        var skinPath = CharBuf(MAX_QPATH)
        var saber = CharBuf(MAX_QPATH)

        UI_GetSaberForMenu(&saber, saberNum)

        if UI_SaberModelForSaber(String(saber), &modelPath) { //successfully found a model
            let g2Saber = trap_G2API_InitGhoul2Model(&item.ghoul2, String(modelPath), 0, 0, 0, 0, 0) //add the model
            if g2Saber != 0 {
                let boltNum: Int32
                //get the customSkin, if any
                if UI_SaberSkinForSaber(String(saber), &skinPath) {
                    let g2skin = trap_R_RegisterSkin(String(skinPath))
                    trap_G2API_SetSkin(item.ghoul2, g2Saber, 0, g2skin) //this is going to set the surfs on/off matching the skin file
                } else {
                    trap_G2API_SetSkin(item.ghoul2, g2Saber, 0, 0) //turn off custom skin
                }
                if saberNum == 0 {
                    boltNum = trap_G2API_AddBolt(item.ghoul2, 0, "*r_hand")
                } else {
                    boltNum = trap_G2API_AddBolt(item.ghoul2, 0, "*l_hand")
                }
                trap_G2API_AttachG2Model(item.ghoul2, g2Saber, item.ghoul2, boltNum, 0)
            }
        }
        saberNum += 1
    }
}

// Fill in with saber hilts
/// Source: oracle/codemp/ui/ui_saber.c:1080
public func UI_SaberGetHiltInfo(_ singleHilts: inout ArraySlice<String?>, _ staffHilts: inout ArraySlice<String?>) {
    var numSingleHilts: Int32 = 0
    var numStaffHilts: Int32 = 0
    var saberName: String?
    var token: String
    var p: TextCursor

    //go through all the loaded sabers and put the valid ones in the proper list
    p = TextCursor(SaberParms)
    COM_BeginParseSession("saberlist")

    // look for a saber
    while !p.isNull {
        token = COM_ParseExt(&p, true)
        if token.isEmpty { //invalid name
            continue
        }
        saberName = String_Alloc(token)
        //see if there's a "{" on the next line
        SkipRestOfLine(&p)

        if UI_ParseLiteralSilent(&p, "{") { //nope, not a name, keep looking
            continue
        }

        //this is a saber name
        if !UI_SaberValidForPlayerInMP(saberName!) {
            SkipBracedSection(&p)
            continue
        }

        if UI_IsSaberTwoHanded(saberName!) {
            if numStaffHilts < MAX_SABER_HILTS - 1 { //-1 because we have to NULL terminate the list
                staffHilts[staffHilts.startIndex + numStaffHilts] = saberName
                numStaffHilts += 1
            } else {
                Com_Printf("WARNING: too many two-handed sabers, ignoring saber '%s'\n", saberName ?? "(null)")
            }
        } else {
            if numSingleHilts < MAX_SABER_HILTS - 1 { //-1 because we have to NULL terminate the list
                singleHilts[singleHilts.startIndex + numSingleHilts] = saberName
                numSingleHilts += 1
            } else {
                Com_Printf("WARNING: too many one-handed sabers, ignoring saber '%s'\n", saberName ?? "(null)")
            }
        }
        //skip the whole braced section and move on to the next entry
        SkipBracedSection(&p)
    }
    //null terminate the list so the UI code knows where to stop listing them
    singleHilts[singleHilts.startIndex + numSingleHilts] = nil
    staffHilts[staffHilts.startIndex + numStaffHilts] = nil
}
