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
// TODO: Port global gServerSkinHack
// Raven wrote: bool gServerSkinHack = false
// No table row for `bool`.

/// Source: oracle/codemp/renderer/tr_image.cpp:1421
// TODO: Port signature
// Raven wrote: void LoadTGA ( const char *name, byte **pic, int *width, int *height)
// No table row for `byte ** pic`.
func LoadTGA() -> Never {
    // Port-note: Row TR9. No caller of this function builds under DEDICATED, so it is dead in the host, rule 20.
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
    t = Float(abs(Double(t)))
    if t < 3.0 {
        // M_PI_OVER_3 is Raven's `( M_PI / 3.0f )`, and the double M_PI makes every product run in double.
        return Float(Double(sinf(Float(Double(t) * M_PI)) * sinf(Float(Double(t) * (M_PI / 3.0)))) / (Double(t) * M_PI * Double(t) * (M_PI / 3.0)))
    }
    return (0.0)
}

/// Source: oracle/codemp/renderer/tr_image.cpp:2366
func R_Resample(_ source: Slots<UInt8>, _ swidth: Int32, _ sheight: Int32, _ dest: Slots<UInt8>, _ dwidth: Int32, _ dheight: Int32, _ components: Int32) {
    // Port-note: Row TR5. `contrib_t` and `contrib_list_t` are structs Raven defines inside tr_image.cpp, which have no hand header and no view.
    // TODO: Port R_Resample
    portMissing("R_Resample", source: "oracle/codemp/renderer/tr_image.cpp:2366")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_RegisterIndividualSkin
    portMissing("RE_RegisterIndividualSkin", source: "oracle/codemp/renderer/tr_image.cpp:3030")
}

/// Source: oracle/codemp/renderer/tr_image.cpp:3113
func RE_RegisterSkin(_ name: String) -> JKAShared.qhandle_t {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_RegisterSkin
    portMissing("RE_RegisterSkin", source: "oracle/codemp/renderer/tr_image.cpp:3113")
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
    // Port-note: Row TR3. `gServerSkinHack` of tr_image.cpp:2967 is a `bool` with no table row, so the stem gives it no storage.
    // TODO: Port RE_RegisterServerSkin
    portMissing("RE_RegisterServerSkin", source: "oracle/codemp/renderer/tr_image.cpp:3301")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_InitSkins
    portMissing("R_InitSkins", source: "oracle/codemp/renderer/tr_image.cpp:3324")
}

/**
```
===============
R_GetSkinByHandle
===============
```
*/
/// Source: oracle/codemp/renderer/tr_image.cpp:3342
// TODO: Port signature
// Raven wrote: skin_t *R_GetSkinByHandle( qhandle_t hSkin )
// No table row for the return `skin_t *`.
func R_GetSkinByHandle() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_GetSkinByHandle
    portMissing("R_GetSkinByHandle", source: "oracle/codemp/renderer/tr_image.cpp:3342")
}
