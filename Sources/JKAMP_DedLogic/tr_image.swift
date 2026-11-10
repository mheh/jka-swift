import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_image.cpp:2335
let LANCZOS3 = (3.0) as Float

/// Source: oracle/codemp/renderer/tr_image.cpp:2336
// Raven wrote: #define M_PI_OVER_3 ( M_PI / 3.0f )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/renderer/tr_image.cpp:2967
var gServerSkinHack: Bool {
    get { world.variables.gServerSkinHack }
    set { world.variables.gServerSkinHack = newValue }
}

/// Source: oracle/codemp/renderer/tr_image.cpp:1421
// TODO: Port signature
// Raven wrote: void LoadTGA ( const char *name, byte **pic, int *width, int *height)
// No table row for `byte ** pic`.
func LoadTGA() -> Never {
    // Its two callers at tr_image.cpp:2252 and :2295 stand under `#ifndef DEDICATED`, so the function is dead in the dedicated build.
    // TODO: Port LoadTGA
    portMissing("LoadTGA", source: "oracle/codemp/renderer/tr_image.cpp:1421")
}

/// Source: oracle/codemp/renderer/tr_image.cpp:2310
func R_InvertImage(_ data: Slots<UInt8>, _ width: Int32, _ height: Int32, _ depth: Int32) {
    var newData: Int32
    var oldData: Int32
    var y: Int32
    var stride: Int32

    stride = width * depth

    oldData = ((height - 1) * stride)
    let block = Z_Malloc(height * stride, TAG_TEMP_IMAGE, false)
    // AI: Raven walks `byte *` pointers over the zone block and the image. The walks are byte offsets into the Slots of each.
    let saveData = Slots<UInt8>(scalars: block, count: Int(height * stride))
    newData = 0

    y = 0
    while y < height {
        // AI: Raven calls memcpy on the two pointers. Com_Memcpy over the two Slots copies the same bytes.
        Com_Memcpy(saveData.suffix(from: newData), data.suffix(from: oldData), stride)
        newData += stride
        oldData -= stride
        y += 1
    }
    // AI: Raven calls memcpy on the two pointers. Com_Memcpy over the two Slots copies the same bytes.
    Com_Memcpy(data, saveData, height * stride)
    // AI: Raven frees the `byte *` of the zone block. The call frees the handle of the block.
    Z_Free(OpaquePointer(block))
}

/// Source: oracle/codemp/renderer/tr_image.cpp:2352
func Lanczos3(_ t: Float) -> Float {
    var t = t
    if t == 0 {
        return (1.0)
    }
    t = Float(abs(t))
    if t < 3.0 {
        // M_PI_OVER_3 is Raven's `( M_PI / 3.0f )`.
        // Foundation also declares M_PI as a double, so the qualifier picks the float M_PI of q_shared.h:548.
        return (sinf(t * JKAShared.M_PI) * sinf(t * (JKAShared.M_PI / 3.0)) / (t * JKAShared.M_PI * t * (JKAShared.M_PI / 3.0)))
    }
    return (0.0)
}

/// Source: oracle/codemp/renderer/tr_image.cpp:2366
func R_Resample(_ source: Slots<UInt8>, _ swidth: Int32, _ sheight: Int32, _ dest: Slots<UInt8>, _ dwidth: Int32, _ dheight: Int32, _ components: Int32) {
    var i: Int32
    var j: Int32
    var k: Int32
    var l: Int32
    var count: Int32
    var left: Int32
    var right: Int32
    var num: Int32
    var pixel: Int32
    var raster: Slots<UInt8>
    var center: Float
    var weight: Float
    var scale: Float
    var width: Float
    var height: Float
    var contributors: Slots<ContribList>

    //	MD_PushTag(TAG_RESAMPLE);

    let work = Slots<UInt8>(scalars: Z_Malloc(dwidth * sheight * components, TAG_RESAMPLE), count: Int(dwidth * sheight * components))

    // Pre calculate filter contributions for rows
    contributors = Slots<ContribList>(Z_Malloc(Int32(ContribList.byteCount) * dwidth, TAG_RESAMPLE), count: dwidth)

    let xscale = Float(dwidth) / Float(swidth)

    if xscale < 1.0 {
        width = ceilf(LANCZOS3 / xscale)
        scale = xscale
    } else {
        width = LANCZOS3
        scale = 1.0
    }
    num = (Int32(width) * 2) + 1

    i = 0
    while i < dwidth {
        contributors[i].n = 0
        contributors[i].p = Contrib(Z_Malloc(num * Int32(Contrib.byteCount), TAG_RESAMPLE))

        center = Float(i) / xscale
        left = Int32(ceilf(center - width))
        right = Int32(floorf(center + width))

        j = left
        while j <= right {
            weight = Lanczos3((center - Float(j)) * scale) * scale
            if j < 0 {
                pixel = -j
            } else if j >= swidth {
                pixel = (swidth - j) + swidth - 1
            } else {
                pixel = j
            }
            count = contributors[i].n
            contributors[i].n += 1
            contributors[i].pSlots[count].pixel = pixel
            contributors[i].pSlots[count].weight = weight
            j += 1
        }
        i += 1
    }
    // Apply filters to zoom horizontally from source to work
    k = 0
    while k < sheight {
        raster = source.suffix(from: k * swidth * components)
        i = 0
        while i < dwidth {
            l = 0
            while l < components {
                weight = 0.0
                j = 0
                while j < contributors[i].n {
                    weight += Float(raster[(contributors[i].pSlots[j].pixel * components) + l]) * contributors[i].pSlots[j].weight
                    j += 1
                }
                pixel = Int32(UInt8(Com_Clamp(0.0, 255.0, weight)))
                work[byte: (k * dwidth * components) + (i * components) + l] = pixel
                l += 1
            }
            i += 1
        }
        k += 1
    }
    // Clean up
    i = 0
    while i < dwidth {
        Z_Free(contributors[i].p?.handle)
        i += 1
    }
    Z_Free(contributors[0].handle)

    // Columns
    contributors = Slots<ContribList>(Z_Malloc(Int32(ContribList.byteCount) * dheight, TAG_RESAMPLE), count: dheight)

    let yscale = Float(dheight) / Float(sheight)
    if yscale < 1.0 {
        height = ceilf(LANCZOS3 / yscale)
        scale = yscale
    } else {
        height = LANCZOS3
        scale = 1.0
    }
    num = (Int32(height) * 2) + 1

    i = 0
    while i < dheight {
        contributors[i].n = 0
        contributors[i].p = Contrib(Z_Malloc(num * Int32(Contrib.byteCount), TAG_RESAMPLE))

        center = Float(i) / yscale
        left = Int32(ceilf(center - height))
        right = Int32(floorf(center + height))

        j = left
        while j <= right {
            weight = Lanczos3((center - Float(j)) * scale) * scale
            if j < 0 {
                pixel = -j
            } else if j >= sheight {
                pixel = (sheight - j) + sheight - 1
            } else {
                pixel = j
            }
            count = contributors[i].n
            contributors[i].n += 1
            contributors[i].pSlots[count].pixel = pixel
            contributors[i].pSlots[count].weight = weight
            j += 1
        }
        i += 1
    }
    // Apply filter to columns
    k = 0
    while k < dwidth {
        l = 0
        while l < components {
            i = 0
            while i < dheight {
                weight = 0.0
                j = 0
                while j < contributors[i].n {
                    weight += Float(work[(contributors[i].pSlots[j].pixel * dwidth * components) + (k * components) + l]) * contributors[i].pSlots[j].weight
                    j += 1
                }
                pixel = Int32(UInt8(Com_Clamp(0.0, 255.0, weight)))
                dest[byte: (i * dwidth * components) + (k * components) + l] = pixel
                i += 1
            }
            l += 1
        }
        k += 1
    }
    // Clean up
    i = 0
    while i < dheight {
        Z_Free(contributors[i].p?.handle)
        i += 1
    }
    Z_Free(contributors[0].handle)
    Z_Free(OpaquePointer(work.base))

    //	MD_PopTag();
}

/**
```
===============
RE_SplitSkins
input = skinname, possibly being a macro for three skins
return= true if three part skins found
output= qualified names to three skins if return is true, undefined if false
===============
```
*/
/// Source: oracle/codemp/renderer/tr_image.cpp:2980
func RE_SplitSkins(_ INname: String, _ skinhead: inout JKAShared.CharBuf, _ skintorso: inout JKAShared.CharBuf, _ skinlower: inout JKAShared.CharBuf) -> Bool { //INname= "models/players/jedi_tf/|head01_skin1|torso01|lower01";
    if strchr(INname, Int32(ascii: "|")) != nil {
        var name = CharBuf(MAX_QPATH)
        strcpy(&name, INname)
        var p = strchr(name, Int32(ascii: "|"))!
        name[p] = 0
        p += 1
        //fill in the base path
        strcpy(&skinhead, name)
        strcpy(&skintorso, name)
        strcpy(&skinlower, name)

        //now get the the individual files

        //advance to second
        let p2Found = strchr(name[p...], Int32(ascii: "|"))
        if p2Found == nil {
            return false
        }
        var p2 = p2Found! + p
        name[p2] = 0
        p2 += 1
        strcat(&skinhead, name[p...])
        strcat(&skinhead, ".skin")

        //advance to third
        let pFound = strchr(name[p2...], Int32(ascii: "|"))
        if pFound == nil {
            return false
        }
        p = pFound! + p2
        name[p] = 0
        p += 1
        strcat(&skintorso, name[p2...])
        strcat(&skintorso, ".skin")

        strcat(&skinlower, name[p...])
        strcat(&skinlower, ".skin")

        return true
    }
    return false
}

// given a name, go get the skin we want and return
/// Source: oracle/codemp/renderer/tr_image.cpp:3030
func RE_RegisterIndividualSkin(_ name: String, _ hSkin: JKAShared.qhandle_t) -> JKAShared.qhandle_t {
    var skin: Skin
    var surf: SkinSurface
    var text = CharBuf(0)
    var text_p: TextCursor
    var token: String
    var surfName = CharBuf(MAX_QPATH)

    // load and parse the skin file
    // The CharBuf form of FS_ReadFile leaves the buffer empty for a missing file, so Raven's NULL test of `text` reads the length.
    if FS_ReadFile(name, &text) < 0 {
        Com_Printf("WARNING: RE_RegisterSkin( '%s' ) failed to load!\n", name)
        return 0
    }

    skin = tr.skins[hSkin]!

    text_p = TextCursor(text)
    while !text_p.isNull && text_p.byte != 0 {
        // get surface name
        token = CommaParse(&text_p)
        Q_strncpyz(&surfName, token, Int32(surfName.count))

        if token.isEmpty {
            break
        }
        // lowercase the surface name so skin compares are faster
        Q_strlwr(&surfName)

        if text_p.byte == Int32(ascii: ",") {
            text_p.advance()
        }

        if strncmp(token, "tag_", 4) == 0 { //these aren't in there, but just in case you load an id style one...
            continue
        }

        // parse the shader name
        token = CommaParse(&text_p)

        // Port-note: Raven reads before the buffer when the surface name has fewer than four bytes. The cursor reads the empty text there.
        if strcmp(TextCursor(surfName, at: strlen(surfName) - 4).text, "_off") == 0 {
            if strcmp(token, "*off") == 0 {
                continue //don't need these double offs
            }
            surfName[strlen(surfName) - 4] = 0 //remove the "_off"
        }
        // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
        if skin.numSurfaces < 0 || skin.surfaces.count <= skin.numSurfaces {
            Com_Printf("WARNING: RE_RegisterSkin( '%s' ) more than %d surfaces!\n", name, skin.surfaces.count)
            break
        }
        surf = SkinSurface(Hunk_Alloc(Int32(SkinSurface.byteCount), h_low))
        skin.surfaces[skin.numSurfaces] = surf
        Q_strncpyz(&surf.nameBuffer, String(surfName), Int32(surf.nameBuffer.count))

        if gServerSkinHack {
            surf.shader = R_FindServerShader(token, lightmapsNone, stylesDefault, true)
        } else {
            surf.shader = R_FindShader(token, lightmapsNone, stylesDefault, true)
        }
        skin.numSurfaces += 1
    }

    FS_FreeFile(text)

    // never let a skin have 0 shaders
    if skin.numSurfaces == 0 {
        return 0 // use default skin
    }

    return hSkin
}

/// Source: oracle/codemp/renderer/tr_image.cpp:3113
func RE_RegisterSkin(_ name: String) -> JKAShared.qhandle_t {
    var hSkin: qhandle_t
    var skin: Skin

    if name.isEmpty {
        Com_Printf("Empty name passed to RE_RegisterSkin\n")
        return 0
    }

    if strlen(name) >= MAX_QPATH {
        Com_Printf("Skin name exceeds MAX_QPATH\n")
        return 0
    }

    // see if the skin is already loaded
    hSkin = 1
    while hSkin < tr.numSkins {
        skin = tr.skins[hSkin]!
        if Q_stricmp(skin.name, name) == 0 {
            if skin.numSurfaces == 0 {
                return 0 // default skin
            }
            return hSkin
        }
        hSkin += 1
    }

    // allocate a new skin
    if tr.numSkins == MAX_SKINS {
        Com_Printf("WARNING: RE_RegisterSkin( '%s' ) MAX_SKINS hit\n", name)
        return 0
    }
    tr.numSkins += 1
    skin = Skin(Hunk_Alloc(Int32(Skin.byteCount), h_low))
    tr.skins[hSkin] = skin
    Q_strncpyz(&skin.nameBuffer, name, Int32(skin.nameBuffer.count))
    skin.numSurfaces = 0

    // make sure the render thread is stopped
    R_SyncRenderThread()

    // If not a .skin file, load as a single shader
    // Port-note: Raven reads before the text when the name has fewer than five bytes. The cursor reads the empty text there.
    if strcmp(TextCursor(CharBuf(name), at: strlen(name) - 5).text, ".skin") != 0 {
        /*		skin->numSurfaces = 1;
        		skin->surfaces[0] = (skinSurface_t *)Hunk_Alloc( sizeof(skin->surfaces[0]), h_low );
        		skin->surfaces[0]->shader = R_FindShader( name, lightmapsNone, stylesDefault, qtrue );
        		return hSkin;
        */
    }

    var skinhead = CharBuf(MAX_QPATH)
    var skintorso = CharBuf(MAX_QPATH)
    var skinlower = CharBuf(MAX_QPATH)
    if RE_SplitSkins(name, &skinhead, &skintorso, &skinlower) { //three part
        hSkin = RE_RegisterIndividualSkin(String(skinhead), hSkin)
        if hSkin != 0 {
            hSkin = RE_RegisterIndividualSkin(String(skintorso), hSkin)
            if hSkin != 0 {
                hSkin = RE_RegisterIndividualSkin(String(skinlower), hSkin)
            }
        }
    } else { //single skin
        hSkin = RE_RegisterIndividualSkin(name, hSkin)
    }
    return (hSkin)
}

/**
```
==================
CommaParse

This is unfortunate, but the skin files aren't
compatable with our normal parsing rules.
==================
```
*/
/// Source: oracle/codemp/renderer/tr_image.cpp:3193
private func CommaParse(_ data_p: inout JKAShared.TextCursor) -> String {
    var c: Int32 = 0
    var len: Int32
    var data: TextCursor
    // Raven's `static char com_token[MAX_TOKEN_CHARS]` is a local buffer, because the returned String is already a copy.
    var com_token = CharBuf(MAX_TOKEN_CHARS)

    data = data_p
    len = 0
    com_token[0] = 0

    // make sure incoming data is valid
    if data.isNull {
        data_p = TextCursor()
        return String(com_token)
    }

    while 1 != 0 {
        // skip whitespace
        while true {
            c = data.byte
            if !(c <= Int32(ascii: " ")) {
                break
            }
            if c == 0 {
                break
            }
            data.advance()
        }

        c = data.byte

        // skip double slash comments
        if c == Int32(ascii: "/") && data[1] == Int32(ascii: "/") {
            while data.byte != 0 && data.byte != Int32(ascii: "\n") {
                data.advance()
            }
        }
        // skip /* */ comments
        else if c == Int32(ascii: "/") && data[1] == Int32(ascii: "*") {
            while data.byte != 0 && (data.byte != Int32(ascii: "*") || data[1] != Int32(ascii: "/")) {
                data.advance()
            }
            if data.byte != 0 {
                data.advance(by: 2)
            }
        } else {
            break
        }
    }

    if c == 0 {
        return ""
    }

    // handle quoted strings
    if c == Int32(ascii: "\"") {
        data.advance()
        while 1 != 0 {
            c = data.byte
            data.advance()
            if c == Int32(ascii: "\"") || c == 0 {
                com_token[len] = 0
                data_p = data
                return String(com_token)
            }
            if len < MAX_TOKEN_CHARS {
                com_token[len] = c
                len += 1
            }
        }
    }

    // parse a regular word
    repeat {
        if len < MAX_TOKEN_CHARS {
            com_token[len] = c
            len += 1
        }
        data.advance()
        c = data.byte
    } while c > 32 && c != Int32(ascii: ",")

    if len == MAX_TOKEN_CHARS {
        //		Com_Printf ("Token exceeded %i chars, discarded.\n", MAX_TOKEN_CHARS);
        len = 0
    }
    com_token[len] = 0

    data_p = data
    return String(com_token)
}

/// Source: oracle/codemp/renderer/tr_image.cpp:3301
func RE_RegisterServerSkin(_ name: String) -> JKAShared.qhandle_t {
    var r: qhandle_t

    if com_cl_running != nil &&
        com_cl_running!.integer != 0 &&
        Com_TheHunkMarkHasBeenMade() &&
        ShaderHashTableExists() { //If the client is running then we can go straight into the normal registerskin func
        return RE_RegisterSkin(name)
    }

    gServerSkinHack = true
    r = RE_RegisterSkin(name)
    gServerSkinHack = false

    return r
}

/**
```
===============
R_InitSkins
===============
```
*/
/// Source: oracle/codemp/renderer/tr_image.cpp:3324
func R_InitSkins() {
    var skin: Skin

    tr.numSkins = 1

    // make the default skin have all default shaders
    skin = Skin(/*ri.*/Hunk_Alloc(Int32(Skin.byteCount), h_low))
    tr.skins[0] = skin
    Q_strncpyz(&skin.nameBuffer, "<default skin>", Int32(skin.nameBuffer.count))
    skin.numSurfaces = 1
    skin.surfaces[0] = SkinSurface(/*ri.*/Hunk_Alloc(Int32(SkinSurface.byteCount), h_low))
    skin.surfaces[0]!.shader = tr.defaultShader
}

/**
```
===============
R_GetSkinByHandle
===============
```
*/
/// Source: oracle/codemp/renderer/tr_image.cpp:3342
func R_GetSkinByHandle(_ hSkin: JKAShared.qhandle_t) -> Skin? {
    if hSkin < 1 || hSkin >= tr.numSkins {
        return tr.skins[0]
    }
    return tr.skins[hSkin]
}
