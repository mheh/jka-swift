import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/**
```
================
UI_DrawRect

Coordinates are 640*480 virtual values
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:24
func CG_DrawRect(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ size: Float, _ color: JKAShared.vec4_t?) {
    trap_R_SetColor(color)

    CG_DrawTopBottom(x, y, width, height, size)
    CG_DrawSides(x, y, width, height, size)

    trap_R_SetColor(nil)
}

/**
```
=================
CG_GetColorForHealth
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:40
func CG_GetColorForHealth(_ health: Int32, _ armor: Int32, _ hcolor: inout JKAShared.vec4_t) {
    var count: Int32
    let max: Int32
    // Raven assigns his own `health` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var health = health

    // calculate the total points of damage that can
    // be sustained at the current health / armor level
    if health <= 0 {
        // Raven's VectorClear macro, as its expansion over the first three floats of the vec4_t.
        hcolor[2] = 0
        hcolor[1] = hcolor[2]
        hcolor[0] = hcolor[1]
        hcolor[3] = 1
        return
    }
    count = armor
    max = Int32(Double(health) * ARMOR_PROTECTION / (1.0 - ARMOR_PROTECTION))
    if max < count {
        count = max
    }
    health += count

    // set the color based on health
    hcolor[0] = 1.0
    hcolor[3] = 1.0
    if health >= 100 {
        hcolor[2] = 1.0
    } else if health < 66 {
        hcolor[2] = 0
    } else {
        hcolor[2] = Float(Double(health - 66) / 33.0)
    }

    if health > 60 {
        hcolor[1] = 1.0
    } else if health < 30 {
        hcolor[1] = 0
    } else {
        hcolor[1] = Float(Double(health - 30) / 30.0)
    }
}

/**
```
================
CG_DrawSides

Coords are virtual 640x480
================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:85
func CG_DrawSides(_ x: Float, _ y: Float, _ w: Float, _ h: Float, _ size: Float) {
    // Raven assigns his own `size` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var size = size
    size *= cgs.screenXScale
    trap_R_DrawStretchPic(x, y, size, h, 0, 0, 0, 0, cgs.media.whiteShader)
    trap_R_DrawStretchPic(x + w - size, y, size, h, 0, 0, 0, 0, cgs.media.whiteShader)
}

/// Source: oracle/codemp/cgame/cg_drawtools.c:91
func CG_DrawTopBottom(_ x: Float, _ y: Float, _ w: Float, _ h: Float, _ size: Float) {
    // Raven assigns his own `size` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var size = size
    size *= cgs.screenYScale
    trap_R_DrawStretchPic(x, y, w, size, 0, 0, 0, 0, cgs.media.whiteShader)
    trap_R_DrawStretchPic(x, y + h - size, w, size, 0, 0, 0, 0, cgs.media.whiteShader)
}

/**
```
-------------------------
CGC_FillRect2
real coords
-------------------------
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:103
func CG_FillRect2(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ color: JKAShared.vec4_t?) {
    trap_R_SetColor(color)
    trap_R_DrawStretchPic(x, y, width, height, 0, 0, 0, 0, cgs.media.whiteShader)
    trap_R_SetColor(nil)
}

/**
```
================
CG_FillRect

Coordinates are 640*480 virtual values
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:116
func CG_FillRect(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ color: JKAShared.vec4_t?) {
    trap_R_SetColor(color)

    trap_R_DrawStretchPic(x, y, width, height, 0, 0, 0, 0, cgs.media.whiteShader)

    trap_R_SetColor(nil)
}

/**
```
================
CG_DrawPic

Coordinates are 640*480 virtual values
A width of 0 will draw with the original image width
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:133
func CG_DrawPic(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ hShader: JKAShared.qhandle_t) {
    trap_R_DrawStretchPic(x, y, width, height, 0, 0, 1, 1, hShader)
}

/**
```
================
CG_DrawRotatePic

Coordinates are 640*480 virtual values
A width of 0 will draw with the original image width
rotates around the upper right corner of the passed in point
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:146
func CG_DrawRotatePic(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ angle: Float, _ hShader: JKAShared.qhandle_t) {
    trap_R_DrawRotatePic(x, y, width, height, 0, 0, 1, 1, angle, hShader)
}

/**
```
================
CG_DrawRotatePic2

Coordinates are 640*480 virtual values
A width of 0 will draw with the original image width
Actually rotates around the center point of the passed in coordinates
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:159
func CG_DrawRotatePic2(_ x: Float, _ y: Float, _ width: Float, _ height: Float, _ angle: Float, _ hShader: JKAShared.qhandle_t) {
    trap_R_DrawRotatePic2(x, y, width, height, 0, 0, 1, 1, angle, hShader)
}

/**
```
===============
CG_DrawChar

Coordinates and size in 640*480 virtual screen size
===============
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:170
func CG_DrawChar(_ x: Int32, _ y: Int32, _ width: Int32, _ height: Int32, _ ch: Int32) {
    let row: Int32
    let col: Int32
    let frow: Float
    let fcol: Float
    let size: Float
    let ax: Float
    let ay: Float
    let aw: Float
    let ah: Float
    let size2: Float
    // Raven assigns his own `ch` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var ch = ch

    ch &= 255

    if ch == Int32(ascii: " ") {
        return
    }

    ax = Float(x)
    ay = Float(y)
    aw = Float(width)
    ah = Float(height)

    row = ch >> 4
    col = ch & 15

    frow = Float(Double(row) * 0.0625)
    fcol = Float(Double(col) * 0.0625)
    size = 0.03125
    size2 = 0.0625

    trap_R_DrawStretchPic(ax, ay, aw, ah, fcol, frow, fcol + size, frow + size2, cgs.media.charsetShader)
}

/// Source: oracle/codemp/cgame/cg_drawtools.c:212
func CG_DrawStringExt(_ x: Int32, _ y: Int32, _ string: String, _ setColor: JKAShared.vec4_t?, _ forceColor: Bool, _ shadow: Bool, _ charWidth: Int32, _ charHeight: Int32, _ maxChars: Int32) {
    if trap_Language_IsAsian() {
        // hack-a-doodle-do (post-release quick fix code)...
        //
        var color = vec4_t()
        color = setColor! // de-const it
        CG_Text_Paint(Float(x), Float(y), 1.0, color, string, 0.0, 0, shadow ? ITEM_TEXTSTYLE_SHADOWED : 0, FONT_MEDIUM)
    } else {
        var color = vec4_t()
        // Raven steps a pointer through the bytes of `string`, so the branch reads a CharBuf copy of them.
        let string = CharBuf(string)
        var s: Int32
        var xx: Int32

        // draw the drop shadow
        if shadow {
            color[2] = 0
            color[1] = color[2]
            color[0] = color[1]
            color[3] = setColor![3]
            trap_R_SetColor(color)
            s = 0
            xx = x
            while string[s] != 0 {
                if Q_IsColorString(string, at: s) {
                    s += 2
                    continue
                }
                CG_DrawChar(xx + 2, y + 2, charWidth, charHeight, string[s])
                xx += charWidth
                s += 1
            }
        }

        // draw the colored text
        s = 0
        xx = x
        trap_R_SetColor(setColor)
        while string[s] != 0 {
            if Q_IsColorString(string, at: s) {
                if !forceColor {
                    color = g_color_table[ColorIndex(string[s + 1])]
                    color[3] = setColor![3]
                    trap_R_SetColor(color)
                }
                s += 2
                continue
            }
            CG_DrawChar(xx, y, charWidth, charHeight, string[s])
            xx += charWidth
            s += 1
        }
        trap_R_SetColor(nil)
    }
}

/// Source: oracle/codemp/cgame/cg_drawtools.c:276
func CG_DrawBigString(_ x: Int32, _ y: Int32, _ s: String, _ alpha: Float) {
    var color: [Float] = [Float](repeating: 0, count: 4)

    color[2] = 1.0
    color[1] = color[2]
    color[0] = color[1]
    color[3] = alpha
    CG_DrawStringExt(x, y, s, vec4_t(color[0], color[1], color[2], color[3]), false, true, BIGCHAR_WIDTH, BIGCHAR_HEIGHT, 0)
}

/// Source: oracle/codemp/cgame/cg_drawtools.c:284
func CG_DrawBigStringColor(_ x: Int32, _ y: Int32, _ s: String, _ color: JKAShared.vec4_t) {
    CG_DrawStringExt(x, y, s, color, true, true, BIGCHAR_WIDTH, BIGCHAR_HEIGHT, 0)
}

/// Source: oracle/codemp/cgame/cg_drawtools.c:288
func CG_DrawSmallString(_ x: Int32, _ y: Int32, _ s: String, _ alpha: Float) {
    var color: [Float] = [Float](repeating: 0, count: 4)

    color[2] = 1.0
    color[1] = color[2]
    color[0] = color[1]
    color[3] = alpha
    CG_DrawStringExt(x, y, s, vec4_t(color[0], color[1], color[2], color[3]), false, false, SMALLCHAR_WIDTH, SMALLCHAR_HEIGHT, 0)
}

/// Source: oracle/codemp/cgame/cg_drawtools.c:296
func CG_DrawSmallStringColor(_ x: Int32, _ y: Int32, _ s: String, _ color: JKAShared.vec4_t) {
    CG_DrawStringExt(x, y, s, color, true, false, SMALLCHAR_WIDTH, SMALLCHAR_HEIGHT, 0)
}

/**
```
=================
CG_DrawStrlen

Returns character count, skiping color escape codes
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:307
func CG_DrawStrlen(_ str: String) -> Int32 {
    // Raven steps a pointer through the bytes of `str`, so the body reads a CharBuf copy of them.
    let str = CharBuf(str)
    var s: Int32 = 0
    var count: Int32 = 0

    while str[s] != 0 {
        if Q_IsColorString(str, at: s) {
            s += 2
        } else {
            count += 1
            s += 1
        }
    }

    return count
}

/**
```
=============
CG_TileClearBox

This repeats a 64*64 tile graphic to fill the screen around a sized down
refresh window.
=============
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:331
private func CG_TileClearBox(_ x: Int32, _ y: Int32, _ w: Int32, _ h: Int32, _ hShader: JKAShared.qhandle_t) {
    let s1: Float
    let t1: Float
    let s2: Float
    let t2: Float

    s1 = Float(Double(x) / 64.0)
    t1 = Float(Double(y) / 64.0)
    s2 = Float(Double(x + w) / 64.0)
    t2 = Float(Double(y + h) / 64.0)
    trap_R_DrawStretchPic(Float(x), Float(y), Float(w), Float(h), s1, t1, s2, t2, hShader)
}

/**
```
==============
CG_TileClear

Clear around a sized down screen
==============
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:350
func CG_TileClear() {
    let top: Int32
    let bottom: Int32
    let left: Int32
    let right: Int32
    let w: Int32
    let h: Int32

    w = cgs.glconfig.vidWidth
    h = cgs.glconfig.vidHeight

    if cg.refdef.x == 0 && cg.refdef.y == 0 && cg.refdef.width == w && cg.refdef.height == h {
        return // full screen rendering
    }

    top = cg.refdef.y
    bottom = top + cg.refdef.height - 1
    left = cg.refdef.x
    right = left + cg.refdef.width - 1

    // clear above view screen
    CG_TileClearBox(0, 0, w, top, cgs.media.backTileShader)

    // clear below view screen
    CG_TileClearBox(0, bottom, w, h - bottom, cgs.media.backTileShader)

    // clear left of view screen
    CG_TileClearBox(0, top, left, bottom - top + 1, cgs.media.backTileShader)

    // clear right of view screen
    CG_TileClearBox(right, top, w - right, bottom - top + 1, cgs.media.backTileShader)
}

/**
```
================
CG_FadeColor
================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:387
// TODO: Port signature
// Raven wrote: float *CG_FadeColor( int startMsec, int totalMsec )
// No table row for the return `float *`.
func CG_FadeColor(_ startMsec: Int32, _ totalMsec: Int32) -> JKAShared.vec4_t? {
    // TODO: Port CG_FadeColor
    portMissing("CG_FadeColor", source: "oracle/codemp/cgame/cg_drawtools.c:387")
}

/**
```
=================
CG_ColorForHealth
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:418
func CG_ColorForGivenHealth(_ hcolor: inout JKAShared.vec4_t, _ health: Int32) {
    // set the color based on health
    hcolor[0] = 1.0
    if health >= 100 {
        hcolor[2] = 1.0
    } else if health < 66 {
        hcolor[2] = 0
    } else {
        hcolor[2] = Float(Double(health - 66) / 33.0)
    }

    if health > 60 {
        hcolor[1] = 1.0
    } else if health < 30 {
        hcolor[1] = 0
    } else {
        hcolor[1] = Float(Double(health - 30) / 30.0)
    }
}

/**
```
=================
CG_ColorForHealth
=================
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:454
func CG_ColorForHealth(_ hcolor: inout JKAShared.vec4_t) {
    var health: Int32
    var count: Int32
    let max: Int32

    // calculate the total points of damage that can
    // be sustained at the current health / armor level
    health = cg.snap!.ps.stats[STAT_HEALTH]

    if health <= 0 {
        // Raven's VectorClear macro, as its expansion over the first three floats of the vec4_t.
        hcolor[2] = 0
        hcolor[1] = hcolor[2]
        hcolor[0] = hcolor[1]
        hcolor[3] = 1
        return
    }

    count = cg.snap!.ps.stats[STAT_ARMOR]
    max = Int32(Double(health) * ARMOR_PROTECTION / (1.0 - ARMOR_PROTECTION))
    if max < count {
        count = max
    }
    health += count

    hcolor[3] = 1.0
    CG_ColorForGivenHealth(&hcolor, health)
}

/**
```
==============
CG_DrawNumField

Take x,y positions as if 640 x 480 and scales them to the proper resolution

==============
```
*/
/// Source: oracle/codemp/cgame/cg_drawtools.c:491
func CG_DrawNumField(_ x: Int32, _ y: Int32, _ width: Int32, _ value: Int32, _ charWidth: Int32, _ charHeight: Int32, _ style: Int32, _ zeroFill: Bool) {
    var num = CharBuf(16)
    var ptr = TextCursor()
    var l: Int32
    var frame: Int32
    var xWidth: Int32
    var i: Int32 = 0
    // Raven assigns his own `x` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var x = x
    // Raven assigns his own `width` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var width = width
    // Raven assigns his own `value` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var value = value

    if width < 1 {
        return
    }

    // draw number string
    if width > 5 {
        width = 5
    }

    switch width {
    case 1:
        value = value > 9 ? 9 : value
        value = value < 0 ? 0 : value

    case 2:
        value = value > 99 ? 99 : value
        value = value < -9 ? -9 : value

    case 3:
        value = value > 999 ? 999 : value
        value = value < -99 ? -99 : value

    case 4:
        value = value > 9999 ? 9999 : value
        value = value < -999 ? -999 : value

    default:
        break
    }

    Com_sprintf(&num, Int32((num).count), "%i", value)
    l = strlen(num)
    if l > width {
        l = width
    }

    // FIXME: Might need to do something different for the chunky font??
    switch style {
    case NUM_FONT_SMALL:
        xWidth = charWidth

    case NUM_FONT_CHUNKY:
        xWidth = Int32((charWidth / 1.2) + 2)

    default:
        xWidth = (charWidth / 2) + 7 //(charWidth/6);
    }

    if zeroFill {
        i = 0
        while i < (width - l) {
            switch style {
            case NUM_FONT_SMALL:
                CG_DrawPic(Float(x), Float(y), Float(charWidth), Float(charHeight), cgs.media.smallnumberShaders[0])

            case NUM_FONT_CHUNKY:
                CG_DrawPic(Float(x), Float(y), Float(charWidth), Float(charHeight), cgs.media.chunkyNumberShaders[0])

            default:
                CG_DrawPic(Float(x), Float(y), Float(charWidth), Float(charHeight), cgs.media.numberShaders[0])
            }
            x += 2 + (xWidth)
            i += 1
        }
    } else {
        x += 2 + (xWidth) * (width - l)
    }

    ptr = TextCursor(num)
    while ptr.byte != 0 && l != 0 {
        if ptr.byte == Int32(ascii: "-") {
            frame = STAT_MINUS
        } else {
            frame = ptr.byte - Int32(ascii: "0")
        }

        switch style {
        case NUM_FONT_SMALL:
            CG_DrawPic(Float(x), Float(y), Float(charWidth), Float(charHeight), cgs.media.smallnumberShaders[frame])
            x += 1 // For a one line gap

        case NUM_FONT_CHUNKY:
            CG_DrawPic(Float(x), Float(y), Float(charWidth), Float(charHeight), cgs.media.chunkyNumberShaders[frame])

        default:
            CG_DrawPic(Float(x), Float(y), Float(charWidth), Float(charHeight), cgs.media.numberShaders[frame])
        }

        x += (xWidth)
        ptr.advance()
        l -= 1
    }
}

/// Source: oracle/codemp/cgame/cg_drawtools.c:603
func UI_DrawProportionalString(_ x: Int32, _ y: Int32, _ str: String, _ style: Int32, _ color: JKAShared.vec4_t) {
    // having all these different style defines (1 for UI, one for CG, and now one for the re->font stuff)
    //	is dumb, but for now...
    //
    var iStyle: Int32 = 0
    let iMenuFont: Int32 = (style & UI_SMALLFONT) != 0 ? FONT_SMALL : FONT_MEDIUM
    // Raven assigns his own `x` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var x = x

    switch style & (UI_LEFT | UI_CENTER | UI_RIGHT) {
    case UI_CENTER:
        do {
            x -= CG_Text_Width(str, 1.0, iMenuFont) / 2
        }

    case UI_RIGHT:
        do {
            x -= CG_Text_Width(str, 1.0, iMenuFont) / 2
        }

    default:
        do {
            // nada...
        }
    }

    if (style & UI_DROPSHADOW) != 0 {
        iStyle = ITEM_TEXTSTYLE_SHADOWED
    } else if (style & (UI_BLINK | UI_PULSE)) != 0 {
        iStyle = ITEM_TEXTSTYLE_BLINK
    }

    CG_Text_Paint(Float(x), Float(y), 1.0, color, str, 0, 0, iStyle, iMenuFont)
}

/// Source: oracle/codemp/cgame/cg_drawtools.c:646
func UI_DrawScaledProportionalString(_ x: Int32, _ y: Int32, _ str: String, _ style: Int32, _ color: JKAShared.vec4_t, _ scale: Float) {
    // having all these different style defines (1 for UI, one for CG, and now one for the re->font stuff)
    //	is dumb, but for now...
    //
    var iStyle: Int32 = 0
    // Raven assigns his own `x` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var x = x

    switch style & (UI_LEFT | UI_CENTER | UI_RIGHT) {
    case UI_CENTER:
        do {
            x -= CG_Text_Width(str, scale, FONT_MEDIUM) / 2
        }

    case UI_RIGHT:
        do {
            x -= CG_Text_Width(str, scale, FONT_MEDIUM) / 2
        }

    default:
        do {
            // nada...
        }
    }

    if (style & UI_DROPSHADOW) != 0 {
        iStyle = ITEM_TEXTSTYLE_SHADOWED
    } else if (style & (UI_BLINK | UI_PULSE)) != 0 {
        iStyle = ITEM_TEXTSTYLE_BLINK
    }

    CG_Text_Paint(Float(x), Float(y), scale, color, str, 0, 0, iStyle, FONT_MEDIUM)
}
